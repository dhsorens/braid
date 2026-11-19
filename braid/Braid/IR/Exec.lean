/-
  Braid.IR.Exec

  The functional reading of the dialect. A block without `havoc` is a function from states
  to states, partial where the block faults, and a program is its iteration. This is the
  decompilation of the code into logic at the level of blocks: `Block.exec` is a Lean
  function, and `Block.wp_iff_exec` says the predicate transformer of the block is exactly
  that function. It also runs, which is how the lowerings are tested against the machine
  models.

  ## Main definitions

  * `Op.exec`, `Term.exec`, `Block.exec`: one operation, a terminator, a block
  * `Program.run`: a number of blocks
  * `Op.HavocFree`, `Block.HavocFree`

  ## Main results

  * `Block.wp_of_exec`: what the function computes, the predicate transformer establishes
  * `Block.wp_iff_exec`: and conversely, for a block without `havoc`
  * `Program.eventually_of_run`: a run of the function is a run of the program
-/

module

public import Braid.IR.Semantics

@[expose] public section

namespace Braid

/-- The operation as a function; `none` where it faults. A `havoc` has no value to take,
so it is `none` as well. -/
def Op.exec : Op → Env → State → Option (Env × State)
  | .const d v, ρ, σ => some (ρ.set d v, σ)
  | .un d op a, ρ, σ => some (ρ.set d (op.eval (ρ a)), σ)
  | .bin d op a b, ρ, σ => some (ρ.set d (op.eval (ρ a) (ρ b)), σ)
  | .select d c a b, ρ, σ => some (ρ.set d (if ρ c ≠ 0#64 then ρ a else ρ b), σ)
  | .get d r, ρ, σ => some (ρ.set d (σ.regs r), σ)
  | .set r a, ρ, σ => some (ρ, σ.setReg r (ρ a))
  | .getf d f, ρ, σ => some (ρ.set d (ofBool (σ.flags f)), σ)
  | .setf f a, ρ, σ => some (ρ, σ.setFlag f (ρ a != 0#64))
  | .load d w a, ρ, σ => (σ.mem.load (ρ a) w).map fun v => (ρ.set d v, σ)
  | .store w a v, ρ, σ => (σ.mem.store (ρ a) w (ρ v)).map fun m => (ρ, { σ with mem := m })
  | .havoc _, _, _ => none
  | .guard c, ρ, σ => if ρ c ≠ 0#64 then some (ρ, σ) else none
  | .out a n, ρ, σ => (σ.mem.bytes (ρ a) (ρ n).toNat).map fun _ => (ρ, σ)

/-- A list of operations as a function. -/
def execOps : List Op → Env → State → Option (Env × State)
  | [], ρ, σ => some (ρ, σ)
  | op :: ops, ρ, σ => (op.exec ρ σ).bind fun p => execOps ops p.1 p.2

/-- The terminator as a function. -/
def Term.exec : Term → Env → State → Option State
  | .jump a, _, σ => some (σ.setPc a)
  | .branch c t f, ρ, σ => some (σ.setPc (if ρ c ≠ 0#64 then t else f))
  | .jumpInd a, ρ, σ => some (σ.setPc (ρ a))
  | .trap _, _, _ => none
  | .exit c _ t f, ρ, σ => some (σ.setPc (if ρ c ≠ 0#64 then t else f))

/-- The block as a function. -/
def Block.exec (b : Block) (σ : State) : Option State :=
  (execOps b.ops (fun _ => 0#64) σ).bind fun p => b.term.exec p.1 p.2

/-- `n` blocks of the program, as a function. -/
def Program.run (P : Program) : Nat → State → Option State
  | 0, σ => some σ
  | n + 1, σ => (P σ.pc).bind fun b => (b.exec σ).bind (P.run n)

/-- The operation is not `havoc`. -/
def Op.HavocFree : Op → Prop
  | .havoc _ => False
  | _ => True

instance : DecidablePred Op.HavocFree := fun op => by
  cases op <;> first | exact isTrue trivial | exact isFalse id

/-- No operation of the block is `havoc`. -/
def Block.HavocFree (b : Block) : Prop := ∀ op ∈ b.ops, op.HavocFree

instance : DecidablePred Block.HavocFree := fun b =>
  inferInstanceAs (Decidable (∀ op ∈ b.ops, op.HavocFree))

theorem Op.wp_of_exec {op : Op} {ρ ρ' : Env} {σ σ' : State} {Q : Env → State → Prop}
    (h : op.exec ρ σ = some (ρ', σ')) (hq : Q ρ' σ') : op.wp ρ σ Q := by
  cases op <;> simp only [Op.exec, Option.some.injEq, Prod.mk.injEq, Option.map_eq_some_iff,
    reduceCtorEq] at h <;> simp only [Op.wp]
  case load => obtain ⟨v, hv, rfl, rfl⟩ := h; exact ⟨v, hv, hq⟩
  case store => obtain ⟨m, hm, rfl, rfl⟩ := h; exact ⟨m, hm, hq⟩
  case out => obtain ⟨bs, hb, rfl, rfl⟩ := h; exact ⟨⟨bs, hb⟩, hq⟩
  case guard =>
    split at h
    · rename_i hc
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, rfl⟩ := h; exact ⟨hc, hq⟩
    · cases h
  all_goals (obtain ⟨rfl, rfl⟩ := h; exact hq)

theorem Op.exec_of_wp {op : Op} {ρ : Env} {σ : State} {Q : Env → State → Prop}
    (hf : op.HavocFree) (h : op.wp ρ σ Q) : ∃ ρ' σ', op.exec ρ σ = some (ρ', σ') ∧ Q ρ' σ' := by
  cases op <;> simp only [Op.wp] at h <;> simp only [Op.exec]
  case havoc => exact absurd hf id
  case out => obtain ⟨⟨bs, hb⟩, hq⟩ := h; exact ⟨_, _, by rw [hb]; rfl, hq⟩
  case load => obtain ⟨v, hv, hq⟩ := h; exact ⟨_, _, by rw [hv]; rfl, hq⟩
  case store => obtain ⟨m, hm, hq⟩ := h; exact ⟨_, _, by rw [hm]; rfl, hq⟩
  case guard => exact ⟨_, _, by simp only [h.1, ne_eq, not_false_eq_true, ↓reduceIte], h.2⟩
  all_goals exact ⟨_, _, rfl, h⟩

theorem wpOps_of_exec {ops : List Op} {ρ ρ' : Env} {σ σ' : State} {Q : Env → State → Prop}
    (h : execOps ops ρ σ = some (ρ', σ')) (hq : Q ρ' σ') : wpOps ops ρ σ Q := by
  induction ops generalizing ρ σ with
  | nil =>
    simp only [execOps, Option.some.injEq, Prod.mk.injEq] at h
    obtain ⟨rfl, rfl⟩ := h; exact hq
  | cons op ops ih =>
    simp only [execOps, Option.bind_eq_some_iff] at h
    obtain ⟨⟨ρ₁, σ₁⟩, h₁, h₂⟩ := h
    exact Op.wp_of_exec h₁ (ih h₂)

theorem execOps_of_wp {ops : List Op} {ρ : Env} {σ : State} {Q : Env → State → Prop}
    (hf : ∀ op ∈ ops, op.HavocFree) (h : wpOps ops ρ σ Q) :
    ∃ ρ' σ', execOps ops ρ σ = some (ρ', σ') ∧ Q ρ' σ' := by
  induction ops generalizing ρ σ with
  | nil => exact ⟨ρ, σ, rfl, h⟩
  | cons op ops ih =>
    obtain ⟨ρ₁, σ₁, h₁, hq⟩ := Op.exec_of_wp (hf op List.mem_cons_self) h
    obtain ⟨ρ', σ', h₂, hq'⟩ := ih (fun o ho => hf o (List.mem_cons_of_mem _ ho)) hq
    exact ⟨ρ', σ', by simp only [execOps, h₁, Option.bind_some, h₂], hq'⟩

theorem Term.wp_iff_exec {t : Term} {ρ : Env} {σ : State} {Q : State → Prop} :
    t.wp ρ σ Q ↔ ∃ σ', t.exec ρ σ = some σ' ∧ Q σ' := by
  cases t <;> simp [Term.wp, Term.exec]

/-- What the function of a block computes, its predicate transformer establishes. -/
theorem Block.wp_of_exec {b : Block} {σ σ' : State} {Q : State → Prop}
    (h : b.exec σ = some σ') (hq : Q σ') : b.wp σ Q := by
  simp only [Block.exec, Option.bind_eq_some_iff] at h
  obtain ⟨⟨ρ₁, σ₁⟩, h₁, h₂⟩ := h
  exact wpOps_of_exec h₁ (Term.wp_iff_exec.2 ⟨σ', h₂, hq⟩)

/-- **A block without `havoc` is a function.** Its predicate transformer holds exactly when
the function is defined and the postcondition holds of its value. -/
theorem Block.wp_iff_exec {b : Block} (hf : b.HavocFree) {σ : State} {Q : State → Prop} :
    b.wp σ Q ↔ ∃ σ', b.exec σ = some σ' ∧ Q σ' := by
  constructor
  · intro h
    obtain ⟨ρ₁, σ₁, h₁, ht⟩ := execOps_of_wp hf h
    obtain ⟨σ', h₂, hq⟩ := Term.wp_iff_exec.1 ht
    exact ⟨σ', by simp only [Block.exec, h₁, Option.bind_some, h₂], hq⟩
  · rintro ⟨σ', h, hq⟩
    exact Block.wp_of_exec h hq

/-- **A run of the function is a run of the program.** -/
theorem Program.eventually_of_run {P : Program} {n : Nat} {σ σ' : State} {Q : State → Prop}
    (h : P.run n σ = some σ') (hq : Q σ') : Eventually P Q σ := by
  induction n generalizing σ with
  | zero =>
    simp only [Program.run, Option.some.injEq] at h
    subst h; exact .done _ hq
  | succ n ih =>
    simp only [Program.run, Option.bind_eq_some_iff] at h
    obtain ⟨b, hb, σ₁, h₁, h₂⟩ := h
    exact .step σ (· = σ₁) ⟨b, hb, Block.wp_of_exec h₁ rfl⟩ fun _ e => e ▸ ih h₂

end Braid
