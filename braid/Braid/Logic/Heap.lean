/-
  Braid.Logic.Heap

  Heaps: the pieces of a machine state that separation logic splits and joins. A location is
  a register, a flag, a byte of memory, or the program counter, and a heap holds the values
  of some of them. The heap of a state holds all of them.

  ## Main definitions

  * `Loc`, `Val`, `Heap`
  * `Heap.union`, `Heap.Disjoint`, `Heap.single`
  * `State.heap`: the whole state, as a heap
-/

module

public import Braid.IR.Semantics

@[expose] public section

namespace Braid

/-- A location of the machine state. -/
inductive Loc where
  | reg (r : Reg)
  | flag (f : Flag)
  | mem (a : Word)
  | pc
  deriving DecidableEq, Repr

/-- What a location holds. -/
inductive Val where
  | word (w : Word)
  | bit (b : Bool)
  | cell (c : Cell)
  deriving DecidableEq, Repr

/-- A heap: the values of some locations. -/
abbrev Heap := Loc → Option Val

namespace Heap

/-- The heap that holds nothing. -/
def empty : Heap := fun _ => none

/-- The heap that holds `v` at `l` and nothing else. -/
def single (l : Loc) (v : Val) : Heap := fun l' => if l' = l then some v else none

/-- Both heaps together; where both hold a location, the first wins. -/
def union (h₁ h₂ : Heap) : Heap := fun l =>
  match h₁ l with
  | some v => some v
  | none => h₂ l

/-- No location is held by both heaps. -/
def Disjoint (h₁ h₂ : Heap) : Prop := ∀ l, h₁ l = none ∨ h₂ l = none

/-- The heap with `l` holding `v`. -/
def update (h : Heap) (l : Loc) (v : Val) : Heap := fun l' => if l' = l then some v else h l'

instance : EmptyCollection Heap := ⟨empty⟩
instance : Union Heap := ⟨union⟩

theorem union_apply (h₁ h₂ : Heap) (l : Loc) :
    (h₁ ∪ h₂) l = match h₁ l with | some v => some v | none => h₂ l := rfl

@[simp] theorem empty_apply (l : Loc) : (∅ : Heap) l = none := rfl

@[simp] theorem empty_union (h : Heap) : ∅ ∪ h = h := rfl

@[simp] theorem union_empty (h : Heap) : h ∪ ∅ = h := by
  funext l; simp only [union_apply, empty_apply]; cases h l <;> rfl

theorem union_assoc (h₁ h₂ h₃ : Heap) : (h₁ ∪ h₂) ∪ h₃ = h₁ ∪ (h₂ ∪ h₃) := by
  funext l; simp only [union_apply]; cases h₁ l <;> rfl

theorem Disjoint.symm {h₁ h₂ : Heap} (h : Disjoint h₁ h₂) : Disjoint h₂ h₁ :=
  fun l => (h l).symm

theorem Disjoint.union_comm {h₁ h₂ : Heap} (h : Disjoint h₁ h₂) : h₁ ∪ h₂ = h₂ ∪ h₁ := by
  funext l
  simp only [union_apply]
  rcases h l with h | h <;> rw [h] <;> cases h₁ l <;> cases h₂ l <;> simp_all

@[simp] theorem disjoint_empty_left (h : Heap) : Disjoint ∅ h := fun _ => .inl rfl

@[simp] theorem disjoint_empty_right (h : Heap) : Disjoint h ∅ := fun _ => .inr rfl

theorem disjoint_union_left {h₁ h₂ h₃ : Heap} :
    Disjoint (h₁ ∪ h₂) h₃ ↔ Disjoint h₁ h₃ ∧ Disjoint h₂ h₃ := by
  constructor
  · intro h
    refine ⟨fun l => ?_, fun l => ?_⟩ <;> have := h l <;> simp only [union_apply] at this <;>
      cases h1 : h₁ l <;> cases h2 : h₂ l <;> simp_all
  · rintro ⟨h13, h23⟩ l
    have := h13 l; have := h23 l
    simp only [union_apply]
    cases h1 : h₁ l <;> cases h2 : h₂ l <;> simp_all

theorem disjoint_union_right {h₁ h₂ h₃ : Heap} :
    Disjoint h₁ (h₂ ∪ h₃) ↔ Disjoint h₁ h₂ ∧ Disjoint h₁ h₃ := by
  constructor
  · intro h
    have := disjoint_union_left.1 h.symm
    exact ⟨this.1.symm, this.2.symm⟩
  · rintro ⟨h12, h13⟩
    exact (disjoint_union_left.2 ⟨h12.symm, h13.symm⟩).symm

theorem union_apply_left {h₁ h₂ : Heap} {l : Loc} {v : Val} (h : h₁ l = some v) :
    (h₁ ∪ h₂) l = some v := by
  simp only [union_apply, h]

theorem union_apply_right {h₁ h₂ : Heap} {l : Loc} (h : h₁ l = none) : (h₁ ∪ h₂) l = h₂ l := by
  simp only [union_apply, h]

@[simp] theorem single_apply_self (l : Loc) (v : Val) : single l v l = some v := by
  simp [single]

theorem single_apply_ne {l l' : Loc} (v : Val) (h : l' ≠ l) : single l v l' = none := by
  simp [single, h]

/-- Updating the union at a location updates the first heap there. -/
theorem update_union (h₁ h₂ : Heap) (l : Loc) (v : Val) :
    (h₁ ∪ h₂).update l v = h₁.update l v ∪ h₂ := by
  funext l'
  simp only [update, union_apply]
  by_cases h : l' = l
  · simp [h]
  · simp [h]

/-- Updating a location a heap holds keeps it disjoint from another. -/
theorem Disjoint.update {h₁ h₂ : Heap} (h : Disjoint h₁ h₂) {l : Loc} (v : Val)
    (hl : (h₁ l).isSome) : Disjoint (h₁.update l v) h₂ := by
  intro l'
  by_cases e : l' = l
  · subst e
    rcases h l' with h | h
    · rw [h] at hl; cases hl
    · exact .inr h
  · simpa [Heap.update, e] using h l'

end Heap

/-- The whole state, as a heap. -/
def State.heap (σ : State) : Heap
  | .reg r => some (.word (σ.regs r))
  | .flag f => some (.bit (σ.flags f))
  | .mem a => (σ.mem a).map .cell
  | .pc => some (.word σ.pc)

end Braid
