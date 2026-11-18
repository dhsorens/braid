/-
  Braid.Pass.Dce

  A pass over the dialect: remove the operations of a block whose results are never used.
  A lowering works one instruction at a time and computes every value the instruction
  defines, so a block often holds values nothing reads: the link address of a jump that
  discards it, or a flag the next operation overwrites. Only operations that cannot fault
  and do not change the state are removed: constants, arithmetic, and reads of registers and
  flags.

  The pass is proved to preserve the meaning of a block, and so the runs of a program.

  ## Main definitions

  * `Block.dce`: the block without its dead operations
  * `Program.dce`, `Func.dce`: the pass on every block

  ## Main results

  * `Block.dce_wp`: the block and its image have the same weakest preconditions
  * `Program.dce_eventually`: a program and its image have the same runs
-/

module

public import Braid.IR.Semantics

@[expose] public section

namespace Braid

/-- The SSA values an operation reads. -/
def Op.uses : Op → List Var
  | .const _ _ => []
  | .un _ _ a => [a]
  | .bin _ _ a b => [a, b]
  | .select _ c a b => [c, a, b]
  | .get _ _ => []
  | .set _ a => [a]
  | .getf _ _ => []
  | .setf _ a => [a]
  | .load _ _ a => [a]
  | .store _ a v => [a, v]
  | .havoc _ => []
  | .guard c => [c]

/-- The SSA value an operation defines, if it defines one. -/
def Op.defs : Op → Option Var
  | .const d _ | .un d _ _ | .bin d _ _ _ | .select d _ _ _ | .get d _ | .getf d _
  | .load d _ _ | .havoc d => some d
  | .set _ _ | .setf _ _ | .store _ _ _ | .guard _ => none

/-- The operation can be removed when its result is not used: it cannot fault and does not
change the state. -/
def Op.removable : Op → Bool
  | .const _ _ | .un _ _ _ | .bin _ _ _ _ | .select _ _ _ _ | .get _ _ | .getf _ _ => true
  | _ => false

/-- The SSA values a terminator reads. -/
def Term.uses : Term → List Var
  | .jump _ => []
  | .branch c _ _ => [c]
  | .jumpInd a => [a]
  | .trap _ => []

/-- The values live before an operation, given those live after it. -/
def Op.liveIn (op : Op) (live : List Var) : List Var :=
  op.uses ++ match op.defs with
    | some d => live.filter (· ≠ d)
    | none => live

/-- The operations without the dead ones, and the values live before them, given the values
live after them. -/
def dceOps : List Op → List Var → List Op × List Var
  | [], live => ([], live)
  | op :: ops, live =>
    let r := dceOps ops live
    match op.defs with
    | some d => if op.removable && !r.2.contains d then r else (op :: r.1, op.liveIn r.2)
    | none => (op :: r.1, op.liveIn r.2)

/-- The block without the operations whose results are never used. -/
def Block.dce (b : Block) : Block := ⟨(dceOps b.ops b.term.uses).1, b.term⟩

/-- The pass on every block of a program. -/
def Program.dce (P : Program) : Program := fun a => (P a).map Block.dce

/-- The pass on every block of a function. -/
def Func.dce (f : Func) : Func := { f with blocks := f.blocks.map fun ab => (ab.1, ab.2.dce) }

/-- Two environments agree on a list of values. -/
def AgreeOn (l : List Var) (ρ ρ' : Env) : Prop := ∀ x ∈ l, ρ x = ρ' x

theorem AgreeOn.symm {l : List Var} {ρ ρ' : Env} (h : AgreeOn l ρ ρ') : AgreeOn l ρ' ρ :=
  fun x hx => (h x hx).symm

/-- After an operation that defines `d`, environments that agreed on the values live before
it, and get the same value for `d`, agree on the values live after it. -/
theorem AgreeOn.set {l : List Var} {ρ ρ' : Env} {d : Var} (v : Word)
    (h : AgreeOn (l.filter (· ≠ d)) ρ ρ') : AgreeOn l (ρ.set d v) (ρ'.set d v) := by
  intro x hx
  by_cases hxd : x = d
  · subst hxd; simp
  · rw [Env.set_other _ _ hxd, Env.set_other _ _ hxd]
    exact h x (List.mem_filter.2 ⟨hx, by simpa using hxd⟩)

/-- An operation has the same meaning in two environments that agree on what it reads,
when its postconditions agree on environments that agree on what is live after it. -/
theorem Op.wp_agree {op : Op} {live : List Var} {ρ ρ' : Env} {σ : State}
    {Q Q' : Env → State → Prop} (h : AgreeOn (op.liveIn live) ρ ρ')
    (hQ : ∀ ρ₁ ρ₂ σ', AgreeOn live ρ₁ ρ₂ → Q ρ₁ σ' → Q' ρ₂ σ') (hw : op.wp ρ σ Q) :
    op.wp ρ' σ Q' := by
  have hu : ∀ x ∈ op.uses, ρ x = ρ' x := fun x hx => h x (List.mem_append_left _ hx)
  cases op <;> simp only [Op.liveIn, Op.uses, Op.defs] at h hu <;> simp only [Op.wp] at hw ⊢
  case const d v => exact hQ _ _ _ (AgreeOn.set v h) hw
  case un d o a =>
    rw [← hu a (by simp)]
    exact hQ _ _ _ (AgreeOn.set _ fun x hx => h x (List.mem_append_right _ hx)) hw
  case bin d o a b =>
    rw [← hu a (by simp), ← hu b (by simp)]
    exact hQ _ _ _ (AgreeOn.set _ fun x hx => h x (List.mem_append_right _ hx)) hw
  case select d c a b =>
    rw [← hu a (by simp), ← hu b (by simp), ← hu c (by simp)]
    exact hQ _ _ _ (AgreeOn.set _ fun x hx => h x (List.mem_append_right _ hx)) hw
  case get d r => exact hQ _ _ _ (AgreeOn.set _ h) hw
  case getf d f => exact hQ _ _ _ (AgreeOn.set _ h) hw
  case set r a =>
    rw [← hu a (by simp)]
    exact hQ _ _ _ (fun x hx => h x (List.mem_append_right _ hx)) hw
  case setf f a =>
    rw [← hu a (by simp)]
    exact hQ _ _ _ (fun x hx => h x (List.mem_append_right _ hx)) hw
  case load d w a =>
    obtain ⟨v, hv, hq⟩ := hw
    exact ⟨v, by rw [← hu a (by simp)]; exact hv,
      hQ _ _ _ (AgreeOn.set _ fun x hx => h x (List.mem_append_right _ hx)) hq⟩
  case store w a v =>
    obtain ⟨m, hm, hq⟩ := hw
    exact ⟨m, by rw [← hu a (by simp), ← hu v (by simp)]; exact hm,
      hQ _ _ _ (fun x hx => h x (List.mem_append_right _ hx)) hq⟩
  case havoc d => exact fun v => hQ _ _ _ (AgreeOn.set v h) (hw v)
  case guard c =>
    exact ⟨by rw [← hu c (by simp)]; exact hw.1,
      hQ _ _ _ (fun x hx => h x (List.mem_append_right _ hx)) hw.2⟩

/-- The value a removable operation binds. -/
def Op.val : Op → Env → State → Word
  | .const _ v, _, _ => v
  | .un _ o a, ρ, _ => o.eval (ρ a)
  | .bin _ o a b, ρ, _ => o.eval (ρ a) (ρ b)
  | .select _ c a b, ρ, _ => if ρ c ≠ 0#64 then ρ a else ρ b
  | .get _ r, _, σ => σ.regs r
  | .getf _ f, _, σ => ofBool (σ.flags f)
  | _, _, _ => 0#64

/-- A removable operation only binds its result. -/
theorem Op.wp_removable {op : Op} {d : Var} (hr : op.removable = true) (hd : op.defs = some d)
    {ρ : Env} {σ : State} {Q : Env → State → Prop} :
    op.wp ρ σ Q ↔ Q (ρ.set d (op.val ρ σ)) σ := by
  cases op <;> simp only [Op.removable, Bool.false_eq_true] at hr <;>
    simp only [Op.defs, Option.some.injEq] at hd <;> subst hd <;> rfl

/-- Binding a value that is not live keeps two environments in agreement. -/
theorem AgreeOn.set_left {l : List Var} {ρ ρ' : Env} {d : Var} (v : Word)
    (h : AgreeOn l ρ ρ') (hd : d ∉ l) : AgreeOn l (ρ.set d v) ρ' := by
  intro x hx
  have hxd : x ≠ d := fun e => hd (by rw [← e]; exact hx)
  rw [Env.set_other _ _ hxd]
  exact h x hx

theorem AgreeOn.set_right {l : List Var} {ρ ρ' : Env} {d : Var} (v : Word)
    (h : AgreeOn l ρ ρ') (hd : d ∉ l) : AgreeOn l ρ (ρ'.set d v) :=
  (h.symm.set_left v hd).symm

/-- The operations with the dead ones removed establish what the operations do. -/
theorem wpOps_of_dce {ops : List Op} {live : List Var} {ρ ρ' : Env} {σ : State}
    {Q Q' : Env → State → Prop} (h : AgreeOn (dceOps ops live).2 ρ ρ')
    (hQ : ∀ ρ₁ ρ₂ σ', AgreeOn live ρ₁ ρ₂ → Q ρ₁ σ' → Q' ρ₂ σ')
    (hw : wpOps (dceOps ops live).1 ρ σ Q) : wpOps ops ρ' σ Q' := by
  induction ops generalizing ρ ρ' σ with
  | nil => exact hQ _ _ _ h hw
  | cons op ops ih =>
    simp only [dceOps] at h hw
    cases hd : op.defs with
    | none =>
      simp only [hd] at h hw
      exact Op.wp_agree h (fun _ _ _ ha hq => ih ha hq) hw
    | some d =>
      simp only [hd] at h hw
      by_cases hdead : (op.removable && !(dceOps ops live).2.contains d) = true
      · simp only [hdead, ↓reduceIte] at h hw
        simp only [Bool.and_eq_true, Bool.not_eq_eq_eq_not, Bool.not_true,
          List.contains_eq_mem, decide_eq_false_iff_not] at hdead
        exact (Op.wp_removable hdead.1 hd).2 (ih (h.set_right _ hdead.2) hw)
      · simp only [hdead, Bool.false_eq_true, ↓reduceIte] at h hw
        exact Op.wp_agree h (fun _ _ _ ha hq => ih ha hq) hw

/-- The operations establish what they do with the dead ones removed. -/
theorem wpOps_dce {ops : List Op} {live : List Var} {ρ ρ' : Env} {σ : State}
    {Q Q' : Env → State → Prop} (h : AgreeOn (dceOps ops live).2 ρ ρ')
    (hQ : ∀ ρ₁ ρ₂ σ', AgreeOn live ρ₁ ρ₂ → Q ρ₁ σ' → Q' ρ₂ σ')
    (hw : wpOps ops ρ σ Q) : wpOps (dceOps ops live).1 ρ' σ Q' := by
  induction ops generalizing ρ ρ' σ with
  | nil => exact hQ _ _ _ h hw
  | cons op ops ih =>
    simp only [dceOps] at h ⊢
    cases hd : op.defs with
    | none =>
      simp only [hd] at h ⊢
      exact Op.wp_agree h (fun _ _ _ ha hq => ih ha hq) hw
    | some d =>
      simp only [hd] at h ⊢
      by_cases hdead : (op.removable && !(dceOps ops live).2.contains d) = true
      · simp only [hdead, ↓reduceIte] at h ⊢
        simp only [Bool.and_eq_true, Bool.not_eq_eq_eq_not, Bool.not_true,
          List.contains_eq_mem, decide_eq_false_iff_not] at hdead
        exact ih (h.set_left _ hdead.2) ((Op.wp_removable hdead.1 hd).1 hw)
      · simp only [hdead, Bool.false_eq_true, ↓reduceIte] at h ⊢
        exact Op.wp_agree h (fun _ _ _ ha hq => ih ha hq) hw

/-- A terminator has the same meaning in two environments that agree on what it reads. -/
theorem Term.wp_agree {t : Term} {ρ ρ' : Env} {σ : State} {Q : State → Prop}
    (h : AgreeOn t.uses ρ ρ') (hw : t.wp ρ σ Q) : t.wp ρ' σ Q := by
  cases t <;> simp only [Term.uses] at h <;> simp only [Term.wp] at hw ⊢
  case jump => exact hw
  case branch c t f => rw [← h c (by simp)]; exact hw
  case jumpInd a => rw [← h a (by simp)]; exact hw

/-- **Removing dead operations preserves the meaning of a block.** -/
theorem Block.dce_wp (b : Block) (σ : State) (Q : State → Prop) : b.dce.wp σ Q ↔ b.wp σ Q :=
  ⟨wpOps_of_dce (fun _ _ => rfl) fun _ _ _ ha hq => Term.wp_agree ha hq,
   wpOps_dce (fun _ _ => rfl) fun _ _ _ ha hq => Term.wp_agree ha hq⟩

theorem Program.dce_step (P : Program) (σ : State) (Q : State → Prop) :
    P.dce.step σ Q ↔ P.step σ Q := by
  simp only [Program.step, Program.dce, Option.map_eq_some_iff]
  constructor
  · rintro ⟨_, ⟨b, hb, rfl⟩, hw⟩
    exact ⟨b, hb, (b.dce_wp σ Q).1 hw⟩
  · rintro ⟨b, hb, hw⟩
    exact ⟨b.dce, ⟨b, hb, rfl⟩, (b.dce_wp σ Q).2 hw⟩

/-- **Removing dead operations preserves the runs of a program.** -/
theorem Program.dce_eventually (P : Program) (Q : State → Prop) (σ : State) :
    Eventually P.dce Q σ ↔ Eventually P Q σ := by
  constructor <;> intro h
  · induction h with
    | done σ hq => exact .done σ hq
    | step σ R hs _ ih => exact .step σ R ((P.dce_step σ R).1 hs) ih
  · induction h with
    | done σ hq => exact .done σ hq
    | step σ R hs _ ih => exact .step σ R ((P.dce_step σ R).2 hs) ih

end Braid
