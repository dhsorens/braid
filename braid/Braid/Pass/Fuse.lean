/-
  Braid.Pass.Fuse

  A pass over the dialect: fuse a block that ends in a direct jump with the block it jumps
  to. A lowering makes one block for each instruction, so straight-line code is a chain of
  blocks, each jumping to the next. Fusing a chain gives one block for what the source would
  call a basic block, and puts a value and its uses in one place, where other passes can see
  them.

  SSA values are local to a block and numbered from zero, so the second block is renumbered
  above the values of the first.

  The fused program takes one step where the original takes two, so it never stops in
  between. The theorem goes one way, the way a proof needs: what every run of the fused
  program reaches, every run of the original reaches.

  ## Main definitions

  * `Block.seq`: one block after another, as one block
  * `Program.fuseAt`: the program with the block at an address fused with its successor

  ## Main results

  * `Block.seq_wp`: the fused block establishes what the two blocks establish in turn
  * `Program.fuseAt_eventually`: runs of the fused program are runs of the original
-/

module

public import Braid.Pass.Dce

@[expose] public section

namespace Braid

/-- The operation with every SSA value renumbered `k` higher. -/
def Op.shift (k : Nat) : Op → Op
  | .const d v => .const (d + k) v
  | .un d o a => .un (d + k) o (a + k)
  | .bin d o a b => .bin (d + k) o (a + k) (b + k)
  | .select d c a b => .select (d + k) (c + k) (a + k) (b + k)
  | .get d r => .get (d + k) r
  | .set r a => .set r (a + k)
  | .getf d f => .getf (d + k) f
  | .setf f a => .setf f (a + k)
  | .load d w a => .load (d + k) w (a + k)
  | .store w a v => .store w (a + k) (v + k)
  | .havoc d => .havoc (d + k)
  | .guard c => .guard (c + k)
  | .out a n => .out (a + k) (n + k)

/-- The terminator with every SSA value renumbered `k` higher. -/
def Term.shift (k : Nat) : Term → Term
  | .jump a => .jump a
  | .branch c t f => .branch (c + k) t f
  | .jumpInd a => .jumpInd (a + k)
  | .trap r => .trap r
  | .exit c x t f => .exit (c + k) (x + k) t f

/-- A number above every SSA value the operations define. -/
def defBound : List Op → Nat
  | [] => 0
  | op :: ops => max (match op.defs with | some d => d + 1 | none => 0) (defBound ops)

/-- One block after another, as one block: the operations of the first, then those of the
second renumbered above them, then the terminator of the second. -/
def Block.seq (a b : Block) : Block :=
  ⟨a.ops ++ b.ops.map (Op.shift (defBound a.ops)), b.term.shift (defBound a.ops)⟩

/-- The environment `ρ'` holds, `k` higher, the values of `ρ`. -/
def Shifted (k : Nat) (ρ ρ' : Env) : Prop := ∀ x, ρ' (x + k) = ρ x

theorem Shifted.set {k : Nat} {ρ ρ' : Env} (h : Shifted k ρ ρ') (d : Var) (v : Word) :
    Shifted k (ρ.set d v) (ρ'.set (d + k) v) := by
  intro x
  by_cases hx : x = d
  · subst hx; simp
  · have hx' : x + k ≠ d + k := fun e => hx (Nat.add_right_cancel e)
    rw [Env.set_other _ _ hx, Env.set_other _ _ hx']; exact h x

/-- A renumbered operation establishes what the operation does. -/
theorem Op.wp_of_shift {op : Op} {k : Nat} {ρ ρ' : Env} {σ : State} {Q Q' : Env → State → Prop}
    (h : Shifted k ρ ρ') (hQ : ∀ ρ₁ ρ₂ σ', Shifted k ρ₁ ρ₂ → Q' ρ₂ σ' → Q ρ₁ σ')
    (hw : (op.shift k).wp ρ' σ Q') : op.wp ρ σ Q := by
  cases op <;> simp only [Op.shift, Op.wp, h _] at hw <;> simp only [Op.wp]
  case load d w a => obtain ⟨v, hv, hq⟩ := hw; exact ⟨v, hv, hQ _ _ _ (h.set d v) hq⟩
  case store w a v => obtain ⟨m, hm, hq⟩ := hw; exact ⟨m, hm, hQ _ _ _ h hq⟩
  case havoc d => exact fun v => hQ _ _ _ (h.set d v) (hw v)
  case guard c => exact ⟨hw.1, hQ _ _ _ h hw.2⟩
  case out a n => exact ⟨hw.1, hQ _ _ _ h hw.2⟩
  case set r a => exact hQ _ _ _ h hw
  case setf f a => exact hQ _ _ _ h hw
  all_goals exact hQ _ _ _ (h.set _ _) hw

theorem wpOps_of_shift {ops : List Op} {k : Nat} {ρ ρ' : Env} {σ : State}
    {Q Q' : Env → State → Prop} (h : Shifted k ρ ρ')
    (hQ : ∀ ρ₁ ρ₂ σ', Shifted k ρ₁ ρ₂ → Q' ρ₂ σ' → Q ρ₁ σ')
    (hw : wpOps (ops.map (Op.shift k)) ρ' σ Q') : wpOps ops ρ σ Q := by
  induction ops generalizing ρ ρ' σ with
  | nil => exact hQ _ _ _ h hw
  | cons op ops ih => exact Op.wp_of_shift h (fun _ _ _ h' hq => ih h' hq) hw

theorem Term.wp_of_shift {t : Term} {k : Nat} {ρ ρ' : Env} {σ : State} {Q : State → Prop}
    (h : Shifted k ρ ρ') (hw : (t.shift k).wp ρ' σ Q) : t.wp ρ σ Q := by
  cases t <;> simp only [Term.shift, Term.wp, h _] at hw <;> simp only [Term.wp] <;> exact hw

/-- An operation leaves every SSA value alone but the one it defines. -/
theorem Op.wp_keeps {op : Op} {ρ : Env} {σ : State} {Q : Env → State → Prop}
    (hw : op.wp ρ σ Q) :
    op.wp ρ σ fun ρ' σ' => Q ρ' σ' ∧ ∀ y, op.defs ≠ some y → ρ' y = ρ y := by
  have hset : ∀ (d : Var) (v : Word) (y : Var), some d ≠ some y → ρ.set d v y = ρ y :=
    fun d v y h => Env.set_other _ _ fun e => h (by rw [e])
  cases op <;> simp only [Op.wp, Op.defs] at hw ⊢
  case load d w a => obtain ⟨v, hv, hq⟩ := hw; exact ⟨v, hv, hq, hset d v⟩
  case store w a v => obtain ⟨m, hm, hq⟩ := hw; exact ⟨m, hm, by simpa using hq⟩
  case havoc d => exact fun v => ⟨hw v, hset d v⟩
  case guard c => exact ⟨hw.1, by simpa using hw.2⟩
  case out a n => exact ⟨hw.1, by simpa using hw.2⟩
  case set r a => simpa using hw
  case setf f a => simpa using hw
  all_goals exact ⟨hw, hset _ _⟩

/-- Operations leave every SSA value alone from their bound up. -/
theorem wpOps_keeps {ops : List Op} {ρ : Env} {σ : State} {Q : Env → State → Prop}
    (hw : wpOps ops ρ σ Q) :
    wpOps ops ρ σ fun ρ' σ' => Q ρ' σ' ∧ ∀ y, defBound ops ≤ y → ρ' y = ρ y := by
  induction ops generalizing ρ σ with
  | nil => exact ⟨hw, fun _ _ => rfl⟩
  | cons op ops ih =>
    refine Op.wp_mono (Op.wp_keeps hw) fun ρ₁ σ₁ ⟨h₁, hk⟩ => ?_
    refine wpOps_mono (ih h₁) fun ρ₂ σ₂ ⟨h₂, hk'⟩ => ⟨h₂, fun y hy => ?_⟩
    simp only [defBound] at hy
    rw [hk' y (by omega)]
    refine hk y fun e => ?_
    rw [e] at hy
    simp only at hy
    omega

/-- No operation reads the program counter. -/
theorem Op.wp_setPc {op : Op} {ρ : Env} {σ : State} {Q : Env → State → Prop} (p : Word)
    (hw : op.wp ρ σ Q) :
    op.wp ρ (σ.setPc p) fun ρ' σ' => ∃ σ₀, Q ρ' σ₀ ∧ σ' = σ₀.setPc p := by
  cases op <;> simp only [Op.wp] at hw ⊢
  case load d w a => obtain ⟨v, hv, hq⟩ := hw; exact ⟨v, hv, _, hq, rfl⟩
  case store w a v => obtain ⟨m, hm, hq⟩ := hw; exact ⟨m, hm, _, hq, rfl⟩
  case havoc d => exact fun v => ⟨_, hw v, rfl⟩
  case guard c => exact ⟨hw.1, _, hw.2, rfl⟩
  case out a n => exact ⟨hw.1, _, hw.2, rfl⟩
  all_goals exact ⟨_, hw, rfl⟩

theorem wpOps_setPc {ops : List Op} {ρ : Env} {σ : State} {Q : Env → State → Prop} (p : Word)
    (hw : wpOps ops ρ σ Q) :
    wpOps ops ρ (σ.setPc p) fun ρ' σ' => ∃ σ₀, Q ρ' σ₀ ∧ σ' = σ₀.setPc p := by
  induction ops generalizing ρ σ with
  | nil => exact ⟨σ, hw, rfl⟩
  | cons op ops ih =>
    refine Op.wp_mono (Op.wp_setPc p hw) ?_
    rintro ρ₁ _ ⟨σ₀, h, rfl⟩
    exact ih h

/-- A terminator sets the program counter whatever it was. -/
theorem Term.wp_setPc {t : Term} {ρ : Env} {σ : State} {Q : State → Prop} (p : Word)
    (hw : t.wp ρ σ Q) : t.wp ρ (σ.setPc p) Q := by
  cases t <;> exact hw

/-- **The fused block establishes what the two blocks establish in turn.** If the first ends
in a jump to `t`, a run of the fused block is a run of the first to a state at `t`, then a
run of the second. -/
theorem Block.seq_wp {a b : Block} {t : Word} (ht : a.term = .jump t) {σ : State}
    {Q : State → Prop} (hw : (a.seq b).wp σ Q) :
    a.wp σ fun σ' => σ'.pc = t ∧ b.wp σ' Q := by
  simp only [Block.wp, Block.seq, wpOps_append] at hw ⊢
  rw [ht]
  refine wpOps_mono (wpOps_keeps hw) fun ρ₁ σ₁ ⟨h₁, hk⟩ => ?_
  have hs : Shifted (defBound a.ops) (fun _ => 0#64) ρ₁ := fun x => hk _ (by omega)
  have h₂ : wpOps b.ops (fun _ => 0#64) σ₁ fun ρ σ' => b.term.wp ρ σ' Q :=
    wpOps_of_shift hs (fun _ _ _ h' hq => Term.wp_of_shift h' hq) h₁
  refine ⟨rfl, wpOps_mono (wpOps_setPc t h₂) ?_⟩
  rintro ρ₂ _ ⟨σ₀, hq, rfl⟩
  exact Term.wp_setPc t hq

/-- The program with the block at `a` fused with the block it jumps to, when it ends in a
direct jump to a block of the program. Every other block is as it was. -/
def Program.fuseAt (P : Program) (a : Word) : Program := fun x =>
  if x = a then
    match P a with
    | some A =>
      match A.term with
      | .jump t =>
        match P t with
        | some B => some (A.seq B)
        | none => some A
      | _ => some A
    | none => none
  else P x

/-- **Runs of the fused program are runs of the original.** Whatever every run of the fused
program reaches, every run of the original reaches. -/
theorem Program.fuseAt_eventually (P : Program) (a : Word) {Q : State → Prop} {σ : State}
    (h : Eventually (P.fuseAt a) Q σ) : Eventually P Q σ := by
  induction h with
  | done σ hq => exact .done σ hq
  | step σ R hs _ ih =>
    obtain ⟨blk, hb, hw⟩ := hs
    simp only [Program.fuseAt] at hb
    by_cases hx : σ.pc = a
    · simp only [hx, ↓reduceIte] at hb
      cases hA : P a with
      | none => rw [hA] at hb; cases hb
      | some A =>
        rw [hA] at hb
        have hplain : blk = A → Eventually P Q σ := fun e =>
          .step σ R ⟨A, hx ▸ hA, e ▸ hw⟩ ih
        cases hterm : A.term with
        | jump t =>
          simp only [hterm] at hb
          cases hB : P t with
          | none => rw [hB] at hb; exact hplain (Option.some.inj hb).symm
          | some B =>
            rw [hB] at hb
            cases Option.some.inj hb
            refine .step σ _ ⟨A, hx ▸ hA, Block.seq_wp hterm hw⟩ ?_
            rintro σ₁ ⟨hpc, hw₁⟩
            exact .step σ₁ R ⟨B, hpc ▸ hB, hw₁⟩ ih
        | branch c t f => simp only [hterm] at hb; exact hplain (Option.some.inj hb).symm
        | jumpInd x => simp only [hterm] at hb; exact hplain (Option.some.inj hb).symm
        | trap r => simp only [hterm] at hb; exact hplain (Option.some.inj hb).symm
        | exit c x t f => simp only [hterm] at hb; exact hplain (Option.some.inj hb).symm
    · simp only [hx, ↓reduceIte] at hb
      exact .step σ R ⟨blk, hb, hw⟩ ih

end Braid
