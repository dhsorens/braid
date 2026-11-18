/-
  Braid.Logic.Atom

  Atoms: the points-to facts a symbolic state is made of, and lists of them. A list of atoms
  denotes their separating conjunction. Symbolic execution keeps the state as such a list
  and never has to decide whether two addresses are equal: two atoms of one list are
  disjoint by construction.

  ## Main definitions

  * `Atom`: a register, flag, program counter or memory points-to, or any assertion
  * `Atoms.interp`: the assertion of a list of atoms
  * `Atoms.At`, `Atoms.Upd`: an atom is in a list; a list with one atom replaced

  ## Main results

  * `Atoms.Upd.split`: a list and its update are the atom and its replacement beside the
    same frame
-/

module

public import Braid.Logic.Assertion
import Iris.BI.DerivedLaws

@[expose] public section

namespace Braid

open Iris Iris.BI

/-- The heap of `n` bytes at `a` holding the low bytes of `v`, little-endian. -/
def Heap.bytes (a : Word) (n : Nat) (v : Word) (w : Bool) : Heap
  | .mem x =>
    if (x - a).toNat < n then some (.cell ⟨(v >>> ((x - a) <<< 3)).truncate 8, w⟩) else none
  | _ => none

/-- Register `r` holds `v`. -/
def regIs (r : Reg) (v : Word) : SProp := fun h => h = Heap.single (.reg r) (.word v)

/-- Flag `f` holds `b`. -/
def flagIs (f : Flag) (b : Bool) : SProp := fun h => h = Heap.single (.flag f) (.bit b)

/-- The program counter is `a`. -/
def pcIs (a : Word) : SProp := fun h => h = Heap.single .pc (.word a)

/-- The `n` bytes at `a` hold the low bytes of `v`, little-endian, and may be written if `w`. -/
def memIs (a : Word) (n : Nat) (v : Word) (w : Bool := true) : SProp :=
  fun h => h = Heap.bytes a n v w

/-- A points-to fact, or any assertion. -/
inductive Atom where
  | reg (r : Reg) (v : Word)
  | flag (f : Flag) (b : Bool)
  | pc (a : Word)
  | mem (a : Word) (n : Nat) (v : Word) (w : Bool)
  | prop (P : SProp)

/-- The assertion of an atom. -/
def Atom.interp : Atom → SProp
  | .reg r v => regIs r v
  | .flag f b => flagIs f b
  | .pc a => pcIs a
  | .mem a n v w => memIs a n v w
  | .prop P => P

/-- A symbolic state: a list of atoms. -/
abbrev Atoms := List Atom

/-- The assertion of a list of atoms: their separating conjunction. -/
def Atoms.interp : Atoms → SProp
  | [] => iprop(emp)
  | a :: as => iprop(a.interp ∗ Atoms.interp as)

@[simp] theorem Atoms.interp_nil : Atoms.interp [] = iprop(emp) := rfl

@[simp] theorem Atoms.interp_cons (a : Atom) (as : Atoms) :
    Atoms.interp (a :: as) = iprop(a.interp ∗ Atoms.interp as) := rfl

/-- Equivalent assertions are equal. -/
theorem SProp.ext {P Q : SProp} (h : P ⊣⊢ Q) : P = Q :=
  funext fun σ => propext ⟨h.1 σ, h.2 σ⟩

theorem Atoms.interp_append (as bs : Atoms) :
    Atoms.interp (as ++ bs) = iprop(Atoms.interp as ∗ Atoms.interp bs) := by
  induction as with
  | nil => exact SProp.ext emp_sep.symm
  | cons a as ih =>
    simp only [List.cons_append, Atoms.interp_cons, ih]
    exact SProp.ext sep_assoc.symm

/-- The atom `a` is in the list. -/
inductive Atoms.At : Atoms → Atom → Prop where
  | here {a : Atom} {as : Atoms} : At (a :: as) a
  | there {a b : Atom} {as : Atoms} : At as a → At (b :: as) a

/-- An atom that is a member of the list is in it. -/
theorem Atoms.At.of_mem {as : Atoms} {a : Atom} (h : a ∈ as) : as.At a := by
  induction as with
  | nil => cases h
  | cons b as ih =>
    rcases List.mem_cons.1 h with rfl | h
    · exact .here
    · exact .there (ih h)

/-- The second list is the first with one occurrence of `a` replaced by `a'`. -/
inductive Atoms.Upd : Atoms → Atom → Atom → Atoms → Prop where
  | here {a a' : Atom} {as : Atoms} : Upd (a :: as) a a' (a' :: as)
  | there {a a' b : Atom} {as as' : Atoms} : Upd as a a' as' → Upd (b :: as) a a' (b :: as')

/-- A list and its update are the atom and its replacement, beside the same frame. -/
theorem Atoms.Upd.split {as as' : Atoms} {a a' : Atom} (h : Upd as a a' as') :
    ∃ F : SProp, Atoms.interp as = iprop(a.interp ∗ F) ∧
      Atoms.interp as' = iprop(a'.interp ∗ F) := by
  induction h with
  | here => exact ⟨_, rfl, rfl⟩
  | @there a a' b as as' _ ih =>
    obtain ⟨F, e, e'⟩ := ih
    refine ⟨iprop(b.interp ∗ F), ?_, ?_⟩
    · rw [Atoms.interp_cons, e]; exact SProp.ext sep_left_comm
    · rw [Atoms.interp_cons, e']; exact SProp.ext sep_left_comm

/-- A list is one of its atoms beside a frame. -/
theorem Atoms.At.split {as : Atoms} {a : Atom} (h : At as a) :
    ∃ F : SProp, Atoms.interp as = iprop(a.interp ∗ F) := by
  induction h with
  | here => exact ⟨_, rfl⟩
  | @there a b as _ ih =>
    obtain ⟨F, e⟩ := ih
    exact ⟨iprop(b.interp ∗ F), by rw [Atoms.interp_cons, e]; exact SProp.ext sep_left_comm⟩

/-- The second list is the first with one occurrence of `a` removed. -/
inductive Atoms.Extract : Atoms → Atom → Atoms → Prop where
  | here {a : Atom} {as : Atoms} : Extract (a :: as) a as
  | there {a b : Atom} {as as' : Atoms} : Extract as a as' → Extract (b :: as) a (b :: as')

/-- The first list is the atoms of the second, in any order, and those of the third. -/
inductive Atoms.Split : Atoms → Atoms → Atoms → Prop where
  | nil {as : Atoms} : Split as [] as
  | cons {a : Atom} {as as' pre fr : Atoms} :
      Extract as a as' → Split as' pre fr → Split as (a :: pre) fr

theorem Atoms.Extract.interp {as as' : Atoms} {a : Atom} (h : Extract as a as') :
    Atoms.interp as = iprop(a.interp ∗ Atoms.interp as') := by
  induction h with
  | here => rfl
  | @there a b as as' _ ih =>
    rw [Atoms.interp_cons, ih]; exact SProp.ext sep_left_comm

/-- A list split in two is the conjunction of the two parts. -/
theorem Atoms.Split.interp {as pre fr : Atoms} (h : Split as pre fr) :
    Atoms.interp as = Atoms.interp (pre ++ fr) := by
  induction h with
  | nil => rfl
  | cons he _ ih => rw [he.interp, ih]; rfl

end Braid
