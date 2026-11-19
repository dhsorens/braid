/-
  Braid.Logic.Cells

  Arrays of cells of any size, read-only or writable: the general form of `wordsAt` and
  `bytesAt`. A cell of `k` bytes holds the low `k` bytes of a word, so an array of 32-bit
  values is `cellsAt 4`, and a table in read-only data is `cellsAt k false`.

  An array can be opened at an index, which is how a loop reads or writes `a[i]` for an `i`
  that is not a literal: `cellsAt_index` splits the array into the cells before `i`, cell `i`
  as a memory atom the execution rules can use, and the cells after.

  ## Main definitions

  * `cellsAt k w p vs`: the cells `vs`, of `k` bytes each, are in memory from `p` on
  * `cellsAtoms k w p vs`: the same, as memory atoms, for theorems about a machine

  ## Main results

  * `cellsAt_cons`, `cellsAt_split`, `cellsAt_index`, `cellsAt_index_set`: opening an array
  * `cellsAtoms_pairwise`, `cellsAtoms_disj`, `cellsAtoms_sat`: an array written out
  * `Flat`, `Flat.interp`, `braid_flat`: a state with several arrays, written out
-/

module

public import Braid.Logic.Data
public import Braid.Logic.Flat
import Iris.BI.DerivedLaws
import Std.Tactic.BVDecide

@[expose] public section

namespace Braid

open Iris Iris.BI

/-- The cells `vs`, of `k` bytes each, are in memory from `p` on; writable if `w`. -/
def cellsAt (k : Nat) (w : Bool) (p : Word) : List Word → SProp
  | [] => iprop(emp)
  | v :: vs => iprop(memIs p k v w ∗ cellsAt k w (p + BitVec.ofNat 64 k) vs)

/-- The memory atoms of an array of cells. -/
def cellsAtoms (k : Nat) (w : Bool) (p : Word) : List Word → Atoms
  | [] => []
  | v :: vs => .mem p k v w :: cellsAtoms k w (p + BitVec.ofNat 64 k) vs

variable {k : Nat} {w : Bool}

theorem cellsAt_eq_interp (p : Word) (vs : List Word) :
    cellsAt k w p vs = Atoms.interp (cellsAtoms k w p vs) := by
  induction vs generalizing p with
  | nil => rfl
  | cons v vs ih => simp only [cellsAt, cellsAtoms, Atoms.interp_cons, ih]; rfl

theorem cellsAt_nil (p : Word) : (Atom.prop (cellsAt k w p [])).interp = Atoms.interp [] := rfl

/-- A nonempty array is its first cell and the rest. -/
theorem cellsAt_cons (p v : Word) (vs : List Word) :
    (Atom.prop (cellsAt k w p (v :: vs))).interp =
      Atoms.interp [.mem p k v w, .prop (cellsAt k w (p + BitVec.ofNat 64 k) vs)] :=
  SProp.ext (sep_mono_right sep_emp.symm.1 |> fun h => ⟨h, sep_mono_right sep_emp.1⟩)

theorem cells_addr_next (p : Word) (k n : Nat) :
    p + BitVec.ofNat 64 (k * n) + BitVec.ofNat 64 k = p + BitVec.ofNat 64 (k * (n + 1)) := by
  rw [BitVec.add_assoc, Nat.mul_succ, BitVec.ofNat_add]

theorem cells_addr_succ (p : Word) (k n : Nat) :
    p + BitVec.ofNat 64 k + BitVec.ofNat 64 (k * n) = p + BitVec.ofNat 64 (k * (n + 1)) := by
  rw [BitVec.add_assoc, Nat.mul_succ, Nat.add_comm (k * n) k, BitVec.ofNat_add]

/-- An array of two lists is the first and then the second. -/
theorem cellsAt_append (p : Word) (xs ys : List Word) :
    cellsAt k w p (xs ++ ys) =
      iprop(cellsAt k w p xs ∗ cellsAt k w (p + BitVec.ofNat 64 (k * xs.length)) ys) := by
  induction xs generalizing p with
  | nil =>
    have e : p + BitVec.ofNat 64 (k * ([] : List Word).length) = p := by simp
    rw [e]
    exact SProp.ext emp_sep.symm
  | cons x xs ih =>
    simp only [List.cons_append, cellsAt, ih, List.length_cons, cells_addr_succ]
    exact SProp.ext sep_assoc.symm

/-- An array, split at `i`. -/
theorem cellsAt_split (p : Word) (xs : List Word) (i : Nat) (hi : i ≤ xs.length) :
    (Atom.prop (cellsAt k w p xs)).interp =
      Atoms.interp [.prop (cellsAt k w p (xs.take i)),
        .prop (cellsAt k w (p + BitVec.ofNat 64 (k * i)) (xs.drop i))] := by
  have e := cellsAt_append (k := k) (w := w) p (xs.take i) (xs.drop i)
  rw [List.take_append_drop, List.length_take, Nat.min_eq_left hi] at e
  simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil, e]
  exact SProp.ext ⟨sep_mono_right sep_emp.symm.1, sep_mono_right sep_emp.1⟩

/-- **An array, opened at index `i`**: the cells before, cell `i`, and the cells after. -/
theorem cellsAt_index (p : Word) (xs : List Word) (i : Nat) (hi : i < xs.length) :
    (Atom.prop (cellsAt k w p xs)).interp =
      Atoms.interp [.prop (cellsAt k w p (xs.take i)),
        .mem (p + BitVec.ofNat 64 (k * i)) k xs[i] w,
        .prop (cellsAt k w (p + BitVec.ofNat 64 (k * (i + 1))) (xs.drop (i + 1)))] := by
  rw [cellsAt_split p xs i (Nat.le_of_lt hi)]
  have hd : xs.drop i = xs[i] :: xs.drop (i + 1) := List.drop_eq_getElem_cons hi
  simp only [Atoms.interp_cons, Atoms.interp_nil, Atom.interp, hd, cellsAt, cells_addr_next]
  exact SProp.ext ⟨sep_mono_right sep_assoc.1, sep_mono_right sep_assoc.2⟩

/-- An array with cell `i` replaced, opened at `i`: for closing an array after a store. -/
theorem cellsAt_index_set (p v : Word) (xs : List Word) (i : Nat) (hi : i < xs.length) :
    (Atom.prop (cellsAt k w p (xs.set i v))).interp =
      Atoms.interp [.prop (cellsAt k w p (xs.take i)),
        .mem (p + BitVec.ofNat 64 (k * i)) k v w,
        .prop (cellsAt k w (p + BitVec.ofNat 64 (k * (i + 1))) (xs.drop (i + 1)))] := by
  rw [cellsAt_index p (xs.set i v) i (by simpa using hi)]
  simp only [List.take_set_of_le (Nat.le_refl i), List.drop_set_of_lt (Nat.lt_succ_self i),
    List.getElem_set_self]

/-! ## Written out -/

theorem mem_cellsAtoms {p : Word} {vs : List Word} {b : Atom} :
    b ∈ cellsAtoms k w p vs ↔
      ∃ (i : Nat) (h : i < vs.length), b = .mem (p + BitVec.ofNat 64 (k * i)) k vs[i] w := by
  induction vs generalizing p with
  | nil => simp [cellsAtoms]
  | cons x xs ih =>
    simp only [cellsAtoms, List.mem_cons, ih, List.length_cons]
    constructor
    · rintro (rfl | ⟨i, hi, rfl⟩)
      · exact ⟨0, by omega, by simp⟩
      · exact ⟨i + 1, by omega, by simp [cells_addr_succ]⟩
    · rintro ⟨i, hi, rfl⟩
      cases i with
      | zero => left; simp
      | succ i => right; exact ⟨i, by omega, by simp [cells_addr_succ]⟩

theorem cellsAtoms_isPointsTo {p : Word} {vs : List Word} :
    ∀ a ∈ cellsAtoms k w p vs, a.IsPointsTo := by
  intro a ha
  obtain ⟨i, hi, rfl⟩ := mem_cellsAtoms.1 ha
  trivial

/-- An atom that is not memory is disjoint from every atom of an array. -/
theorem disj_cellsAtoms_of_not_mem {p : Word} {vs : List Word} {a : Atom}
    (ha : ∀ q n v w, Atom.Disj a (.mem q n v w)) : ∀ b ∈ cellsAtoms k w p vs, Atom.Disj a b := by
  intro b hb
  obtain ⟨i, hi, rfl⟩ := mem_cellsAtoms.1 hb
  exact ha _ _ _ _

theorem disj_reg_cellsAtoms {p : Word} {vs : List Word} {r : Reg} {v : Word} :
    ∀ b ∈ cellsAtoms k w p vs, Atom.Disj (.reg r v) b :=
  disj_cellsAtoms_of_not_mem fun _ _ _ _ => Atom.disj_reg_mem

theorem disj_flag_cellsAtoms {p : Word} {vs : List Word} {f : Flag} {c : Bool} :
    ∀ b ∈ cellsAtoms k w p vs, Atom.Disj (.flag f c) b :=
  disj_cellsAtoms_of_not_mem fun _ _ _ _ => Atom.disj_flag_mem

theorem disj_pc_cellsAtoms {p : Word} {vs : List Word} {a : Word} :
    ∀ b ∈ cellsAtoms k w p vs, Atom.Disj (.pc a) b :=
  disj_cellsAtoms_of_not_mem fun _ _ _ _ => Atom.disj_pc_mem

/-- Cell `i` of an array that does not wrap around the address space lies within it. -/
theorem cell_within {p x : Word} {n i : Nat} (hi : i < n) (hlen : k * n ≤ 2 ^ 64)
    (hx : (x - (p + BitVec.ofNat 64 (k * i))).toNat < k) : (x - p).toNat < k * n := by
  have h1 : k * i + k ≤ k * n := by
    have := Nat.mul_le_mul_left k (Nat.succ_le_of_lt hi)
    rwa [Nat.mul_succ] at this
  bv_omega

/-- A memory atom is disjoint from every atom of an array that it does not reach into. -/
theorem disj_mem_cellsAtoms {p q v : Word} {n : Nat} {w' : Bool} {vs : List Word}
    (h : ∀ x : Word, (x - q).toNat < n → ¬ (x - p).toNat < k * vs.length)
    (hlen : k * vs.length ≤ 2 ^ 64) :
    ∀ b ∈ cellsAtoms k w p vs, Atom.Disj (.mem q n v w') b := by
  intro b hb
  obtain ⟨i, hi, rfl⟩ := mem_cellsAtoms.1 hb
  exact Atom.disj_mem_mem fun x hx => h x hx.1 (cell_within hi hlen hx.2)

/-- The atoms of an array that does not wrap around the address space are disjoint. -/
theorem cellsAtoms_pairwise {p : Word} {vs : List Word} (hlen : k * vs.length ≤ 2 ^ 64) :
    (cellsAtoms k w p vs).Pairwise Atom.Disj := by
  induction vs generalizing p with
  | nil => exact .nil
  | cons x xs ih =>
    simp only [List.length_cons, Nat.mul_succ] at hlen
    refine List.pairwise_cons.2 ⟨?_, ih (by omega)⟩
    refine disj_mem_cellsAtoms (fun y hy hy' => ?_) (by omega)
    bv_omega

/-- The atoms of two arrays are disjoint when each array starts at or beyond the end of the
other, going round the address space. -/
theorem cellsAtoms_disj {k' : Nat} {w' : Bool} {p q : Word} {xs ys : List Word}
    (hx : k * xs.length ≤ (q - p).toNat) (hy : k' * ys.length ≤ (p - q).toNat) :
    ∀ a ∈ cellsAtoms k w p xs, ∀ b ∈ cellsAtoms k' w' q ys, Atom.Disj a b := by
  intro a ha b hb
  obtain ⟨i, hi, rfl⟩ := mem_cellsAtoms.1 ha
  obtain ⟨j, hj, rfl⟩ := mem_cellsAtoms.1 hb
  have hlx : k * xs.length ≤ 2 ^ 64 := by have := (q - p).isLt; omega
  have hly : k' * ys.length ≤ 2 ^ 64 := by have := (p - q).isLt; omega
  refine Atom.disj_mem_mem fun x h => ?_
  have h1 : (x - p).toNat < (q - p).toNat := Nat.lt_of_lt_of_le (cell_within hi hlx h.1) hx
  have h2 : (x - q).toNat < (p - q).toNat := Nat.lt_of_lt_of_le (cell_within hj hly h.2) hy
  clear h hx hy hlx hly ha hb hi hj
  bv_omega

/-- The atoms of an array are true of a state when each cell is. -/
theorem cellsAtoms_sat {p : Word} {vs : List Word} {σ : State}
    (h : ∀ (i : Nat) (hi : i < vs.length),
      (Atom.mem (p + BitVec.ofNat 64 (k * i)) k vs[i] w).sat σ) :
    ∀ a ∈ cellsAtoms k w p vs, a.sat σ := by
  intro a ha
  obtain ⟨i, hi, rfl⟩ := mem_cellsAtoms.1 ha
  exact h i hi

/-! ## A state with several arrays, written out -/

/-- `flat` is `pre` with each of its arrays written out as memory atoms. A theorem about a
machine has a precondition with arrays in it; `holds_of_sat_flat` asks for the same state as
points-to atoms, and this relation produces it: `Flat pre ?flat` is proved by its
constructors, which also find `?flat`. -/
inductive Flat : Atoms → Atoms → Prop where
  | nil : Flat [] []
  | cells {k : Nat} {w : Bool} {p : Word} {vs : List Word} {pre flat : Atoms} :
      Flat pre flat → Flat (.prop (cellsAt k w p vs) :: pre) (cellsAtoms k w p vs ++ flat)
  | words {p : Word} {xs : List Word} {pre flat : Atoms} :
      Flat pre flat → Flat (.prop (wordsAt p xs) :: pre) (wordsAtoms p xs ++ flat)
  | bytes {p : Word} {bs : List (BitVec 8)} {pre flat : Atoms} :
      Flat pre flat → Flat (.prop (bytesAt p bs) :: pre) (bytesAtoms p bs ++ flat)
  | atom {a : Atom} {pre flat : Atoms} : Flat pre flat → Flat (a :: pre) (a :: flat)

/-- A state and its written-out form mean the same. -/
theorem Flat.interp {pre flat : Atoms} (h : Flat pre flat) :
    Atoms.interp pre = Atoms.interp flat := by
  induction h with
  | nil => rfl
  | cells _ ih => rw [Atoms.interp_cons, Atoms.interp_append, ih, ← cellsAt_eq_interp]; rfl
  | words _ ih => rw [Atoms.interp_cons, Atoms.interp_append, ih, ← wordsAt_eq_interp]; rfl
  | bytes _ ih => rw [Atoms.interp_cons, Atoms.interp_append, ih, ← bytesAt_eq_interp]; rfl
  | atom _ ih => rw [Atoms.interp_cons, Atoms.interp_cons, ih]

/-- Write out the arrays of a precondition: proves `Flat pre ?flat`. -/
macro "braid_flat" : tactic =>
  `(tactic| repeat (first
      | exact Flat.nil
      | apply Flat.cells
      | apply Flat.words
      | apply Flat.bytes
      | apply Flat.atom))

end Braid
