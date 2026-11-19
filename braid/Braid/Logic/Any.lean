/-
  Braid.Logic.Any

  Memory whose contents are not said. What a function reveals often does not depend on the
  values it works on, and a traced triple about it then keeps where its arrays are and
  forgets what is in them. This file has the assertions for memory of forgotten contents, the
  rules that forget the contents and name them again on a traced triple, and the tactics
  that apply them.

  ## Main definitions

  * `memAny`: a cell of memory, holding some value
  * `cellsAny`: an array of cells, each holding some value
  * `braid_forget_mem`, `braid_name_mem`, `braid_forget_cells`: tactics

  ## Main results

  * `TripleT.forget_mem`, `TripleT.mem_any`: forget the value of a cell, and name it again
  * `TripleT.forget_cells`: forget the contents of an array
  * `cellsAny_cons`, `cellsAny8`, `cellsAny16`, `cellsAny_pre16`: an array of forgotten
    contents, opened
-/

module

public import Braid.Logic.Trace
public import Braid.Logic.Cells
public import Braid.Logic.Tactic
import Iris.BI.DerivedLaws

@[expose] public section

namespace Braid

open Iris Iris.BI

/-- The `k` bytes of memory at `a` hold some value. -/
def memAny (a : Word) (k : Nat) (w : Bool) : SProp := iprop(∃ v, memIs a k v w)

/-- `n` cells of `k` bytes from `p` on, each holding some value. -/
def cellsAny (k : Nat) (w : Bool) (p : Word) : Nat → SProp
  | 0 => iprop(emp)
  | n + 1 => iprop(memAny p k w ∗ cellsAny k w (p + BitVec.ofNat 64 k) n)

/-- An array of cells is an array of as many cells of some values. -/
theorem cellsAt_entails_cellsAny {k : Nat} {w : Bool} (p : Word) (vs : List Word) :
    cellsAt k w p vs ⊢ cellsAny k w p vs.length := by
  induction vs generalizing p with
  | nil => exact .rfl
  | cons v vs ih => exact sep_mono (fun _ hv => ⟨_, ⟨v, rfl⟩, hv⟩) (ih _)

/-- An assertion is the list of atoms that has it alone. -/
theorem prop_interp_singleton (Q : SProp) :
    (Atom.prop Q).interp = Atoms.interp [.prop Q] :=
  SProp.ext ⟨sep_emp.2, sep_emp.1⟩

/-- An assertion beside atoms is a list of atoms. -/
theorem prop_sep_interp (A Q : SProp) (as : Atoms)
    (h : (Atom.prop Q).interp = Atoms.interp as) :
    (Atom.prop iprop(A ∗ Q)).interp = Atoms.interp (.prop A :: as) := by
  rw [Atoms.interp_cons, ← h]; rfl

/-- A nonempty array of forgotten contents is its first cell and the rest. -/
theorem cellsAny_cons {k : Nat} {w : Bool} (p : Word) (n : Nat) :
    (Atom.prop (cellsAny k w p (n + 1))).interp =
      Atoms.interp [.prop (memAny p k w), .prop (cellsAny k w (p + BitVec.ofNat 64 k) n)] :=
  SProp.ext (sep_mono_right sep_emp.symm.1 |> fun h => ⟨h, sep_mono_right sep_emp.1⟩)

/-- An array of one cell of forgotten contents is that cell. -/
theorem cellsAny_one {k : Nat} {w : Bool} (p : Word) :
    (Atom.prop (cellsAny k w p 1)).interp = Atoms.interp [.prop (memAny p k w)] := rfl

/-- `cellsAny_cons` for 32-bit cells, with the length written another way. -/
theorem cellsAny4_cons (w : Bool) (p : Word) (n m : Nat) (h : m = n + 1) :
    (Atom.prop (cellsAny 4 w p m)).interp =
      Atoms.interp [.prop (memAny p 4 w), .prop (cellsAny 4 w (p + 4#64) n)] := by
  subst h
  exact cellsAny_cons p n

/-- Eight 32-bit cells of forgotten contents, as cells. -/
theorem cellsAny8 (w : Bool) (p : Word) :
    (Atom.prop (cellsAny 4 w p 8)).interp =
      Atoms.interp [.prop (memAny p 4 w), .prop (memAny (p + 4#64) 4 w),
        .prop (memAny (p + 8#64) 4 w), .prop (memAny (p + 12#64) 4 w),
        .prop (memAny (p + 16#64) 4 w), .prop (memAny (p + 20#64) 4 w),
        .prop (memAny (p + 24#64) 4 w), .prop (memAny (p + 28#64) 4 w)] := by
  show cellsAny 4 w p 8 = _
  simp only [cellsAny, Atoms.interp_cons, Atoms.interp_nil, BitVec.add_assoc, BitVec.reduceAdd]
  rfl

/-- Sixteen 32-bit cells of forgotten contents, as cells. -/
theorem cellsAny16 (w : Bool) (p : Word) :
    (Atom.prop (cellsAny 4 w p 16)).interp =
      Atoms.interp [.prop (memAny p 4 w), .prop (memAny (p + 4#64) 4 w),
        .prop (memAny (p + 8#64) 4 w), .prop (memAny (p + 12#64) 4 w),
        .prop (memAny (p + 16#64) 4 w), .prop (memAny (p + 20#64) 4 w),
        .prop (memAny (p + 24#64) 4 w), .prop (memAny (p + 28#64) 4 w),
        .prop (memAny (p + 32#64) 4 w), .prop (memAny (p + 36#64) 4 w),
        .prop (memAny (p + 40#64) 4 w), .prop (memAny (p + 44#64) 4 w),
        .prop (memAny (p + 48#64) 4 w), .prop (memAny (p + 52#64) 4 w),
        .prop (memAny (p + 56#64) 4 w), .prop (memAny (p + 60#64) 4 w)] := by
  show cellsAny 4 w p 16 = _
  simp only [cellsAny, Atoms.interp_cons, Atoms.interp_nil, BitVec.add_assoc, BitVec.reduceAdd]
  rfl

/-- An array of at least sixteen 32-bit cells of forgotten contents: the first sixteen as
cells, and the rest. -/
theorem cellsAny_pre16 (w : Bool) (p : Word) (n m : Nat) (h : m = n + 16) :
    (Atom.prop (cellsAny 4 w p m)).interp =
      Atoms.interp [.prop (memAny p 4 w), .prop (memAny (p + 4#64) 4 w),
        .prop (memAny (p + 8#64) 4 w), .prop (memAny (p + 12#64) 4 w),
        .prop (memAny (p + 16#64) 4 w), .prop (memAny (p + 20#64) 4 w),
        .prop (memAny (p + 24#64) 4 w), .prop (memAny (p + 28#64) 4 w),
        .prop (memAny (p + 32#64) 4 w), .prop (memAny (p + 36#64) 4 w),
        .prop (memAny (p + 40#64) 4 w), .prop (memAny (p + 44#64) 4 w),
        .prop (memAny (p + 48#64) 4 w), .prop (memAny (p + 52#64) 4 w),
        .prop (memAny (p + 56#64) 4 w), .prop (memAny (p + 60#64) 4 w),
        .prop (cellsAny 4 w (p + 64#64) n)] := by
  subst h
  simp only [cellsAny, BitVec.add_assoc, BitVec.reduceAdd]
  iterate 16 refine prop_sep_interp _ _ _ ?_
  exact prop_interp_singleton _

namespace TripleT

variable {P : Program} {t t' : Trace}

/-- Forget the value of a cell of memory. -/
theorem forget_mem {as as' : Atoms} {a v : Word} {k : Nat} {w : Bool} {Q : SProp}
    (hupd : as.Upd (.mem a k v w) (.prop (memAny a k w)) as')
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h.conseq (sep_mono_left (fun _ hv => ⟨_, ⟨v, rfl⟩, hv⟩)) .rfl

/-- Name the value of a cell of memory that holds some value. -/
theorem mem_any {as rest : Atoms} {a : Word} {k : Nat} {w : Bool} {Q : SProp}
    (hext : as.Extract (.prop (memAny a k w)) rest)
    (h : ∀ v, TripleT P (Atoms.interp (.mem a k v w :: rest)) t Q t') :
    TripleT P (Atoms.interp as) t Q t' := by
  rw [hext.interp]
  exact (TripleT.exists_pre h).conseq sep_exists_right.1 .rfl

/-- Forget the contents of an array: keep where it is and how many cells it has. -/
theorem forget_cells {as as' : Atoms} {p : Word} {vs : List Word} {k : Nat} {w : Bool}
    {Q : SProp} (n : Nat)
    (hupd : as.Upd (.prop (cellsAt k w p vs)) (.prop (cellsAny k w p n)) as')
    (hn : vs.length = n)
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  subst hn
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h.conseq (sep_mono_left (cellsAt_entails_cellsAny p vs)) .rfl

end TripleT

/-- Forget the value of the cell of memory at an address: `braid_forget_mem a`. -/
macro "braid_forget_mem " a:term : tactic =>
  `(tactic| (refine TripleT.forget_mem (a := $a) (by braid_upd) ?_))

/-- Name the value of the cell of memory at an address, which holds some value:
`braid_name_mem a`. -/
macro "braid_name_mem " a:term : tactic =>
  `(tactic| (refine TripleT.mem_any (a := $a) (by braid_extract) ?_
             intro _))

/-- Forget the contents of the array at an address, of a given number of cells, with a proof
that it has that many: `braid_forget_cells p, n, h`. -/
macro "braid_forget_cells " p:term ", " n:term ", " h:term : tactic =>
  `(tactic| (refine TripleT.forget_cells (p := $p) $n (by braid_upd) $h ?_))

end Braid
