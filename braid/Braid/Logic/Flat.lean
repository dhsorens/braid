/-
  Braid.Logic.Flat

  Arrays, as lists of memory atoms. An assertion about an array, `wordsAt` or `bytesAt`, is
  the conjunction of one memory atom for each element. A theorem about a machine needs its
  precondition as plain facts about memory, so it states the precondition with the array
  written out, and `Atoms.holds_of_sat_flat` carries the plain facts back into the logic.

  ## Main definitions

  * `wordsAtoms`, `bytesAtoms`: the memory atoms of an array

  ## Main results

  * `wordsAt_eq_interp`, `bytesAt_eq_interp`: an array assertion is its atoms
  * `Atoms.interp_flatten`: an array inside a symbolic state, written out
  * `Atoms.holds_of_sat_flat`: into the logic, through the written-out state
  * `mem_wordsAtoms`, `wordsAtoms_pairwise`, `wordsAtoms_sat` and their companions for bytes:
    what the side conditions come to
-/

module

public import Braid.Logic.Sat
public import Braid.Logic.Data
import Iris.BI.DerivedLaws

@[expose] public section

namespace Braid

open Iris Iris.BI

/-- The memory atoms of an array of 64-bit words at `p`. -/
def wordsAtoms (p : Word) : List Word → Atoms
  | [] => []
  | x :: xs => .mem p 8 x true :: wordsAtoms (p + 8#64) xs

/-- The memory atoms of an array of bytes at `p`. -/
def bytesAtoms (p : Word) : List (BitVec 8) → Atoms
  | [] => []
  | b :: bs => .mem p 1 (b.zeroExtend 64) true :: bytesAtoms (p + 1#64) bs

theorem wordsAt_eq_interp (p : Word) (xs : List Word) :
    wordsAt p xs = Atoms.interp (wordsAtoms p xs) := by
  induction xs generalizing p with
  | nil => rfl
  | cons x xs ih => simp only [wordsAt, wordsAtoms, Atoms.interp_cons, ih]; rfl

theorem bytesAt_eq_interp (p : Word) (bs : List (BitVec 8)) :
    bytesAt p bs = Atoms.interp (bytesAtoms p bs) := by
  induction bs generalizing p with
  | nil => rfl
  | cons b bs ih => simp only [bytesAt, bytesAtoms, Atoms.interp_cons, ih]; rfl

/-- An assertion that is a list of atoms, inside a symbolic state, written out. -/
theorem Atoms.interp_flatten (l₁ l₂ m : Atoms) :
    Atoms.interp (l₁ ++ .prop (Atoms.interp m) :: l₂) = Atoms.interp (l₁ ++ m ++ l₂) := by
  rw [Atoms.interp_append, List.append_assoc, Atoms.interp_append, Atoms.interp_append]
  rfl

/-- **Into the logic, through a written-out state.** If `pre` means the same as `flat`, and
the atoms of `flat` are points-to facts, pairwise disjoint and each true of a state, then
`pre` holds of the state beside the rest of it. -/
theorem Atoms.holds_of_sat_flat {pre flat : Atoms} {σ : State}
    (heq : Atoms.interp pre = Atoms.interp flat) (hpt : ∀ a ∈ flat, a.IsPointsTo)
    (hdisj : flat.Pairwise Atom.Disj) (hsat : ∀ a ∈ flat, a.sat σ) :
    (iprop(Atoms.interp pre ∗ True) : SProp) σ.heap := by
  rw [heq]; exact Atoms.holds_of_sat hpt hdisj hsat

/-- Disjointness of a state with an array written out in the middle of it: the rest is
pairwise disjoint, the array is, and each atom of the rest is disjoint from each of the
array's. -/
theorem Atoms.pairwise_flat {l₁ m l₂ : Atoms} (h : (l₁ ++ l₂).Pairwise Atom.Disj)
    (hm : m.Pairwise Atom.Disj) (hc : ∀ a ∈ l₁ ++ l₂, ∀ b ∈ m, Atom.Disj a b) :
    (l₁ ++ m ++ l₂).Pairwise Atom.Disj := by
  rw [List.pairwise_append] at h ⊢
  refine ⟨List.pairwise_append.2 ⟨h.1, hm, fun a ha b hb => hc a (List.mem_append_left _ ha) b hb⟩,
    h.2.1, fun a ha b hb => ?_⟩
  rcases List.mem_append.1 ha with ha | ha
  · exact h.2.2 a ha b hb
  · exact (hc b (List.mem_append_right _ hb) a ha).symm

/-- A property of every atom of a state with an array written out in the middle of it. -/
theorem Atoms.forall_flat {l₁ m l₂ : Atoms} {P : Atom → Prop} (h : ∀ a ∈ l₁ ++ l₂, P a)
    (hm : ∀ a ∈ m, P a) : ∀ a ∈ l₁ ++ m ++ l₂, P a := by
  intro a ha
  rcases List.mem_append.1 ha with ha | ha
  · rcases List.mem_append.1 ha with ha | ha
    · exact h a (List.mem_append_left _ ha)
    · exact hm a ha
  · exact h a (List.mem_append_right _ ha)

/-! ## Words -/

theorem mem_wordsAtoms {p : Word} {xs : List Word} {b : Atom} :
    b ∈ wordsAtoms p xs ↔
      ∃ (i : Nat) (h : i < xs.length), b = .mem (p + BitVec.ofNat 64 (8 * i)) 8 xs[i] true := by
  induction xs generalizing p with
  | nil => simp [wordsAtoms]
  | cons x xs ih =>
    simp only [wordsAtoms, List.mem_cons, ih, List.length_cons]
    constructor
    · rintro (rfl | ⟨i, hi, rfl⟩)
      · exact ⟨0, by omega, by simp⟩
      · refine ⟨i + 1, by omega, ?_⟩
        have e : p + 8#64 + BitVec.ofNat 64 (8 * i) = p + BitVec.ofNat 64 (8 * (i + 1)) := by
          rw [BitVec.add_assoc]; congr 1; bv_omega
        simp [e]
    · rintro ⟨i, hi, rfl⟩
      cases i with
      | zero => left; simp
      | succ i =>
        right
        refine ⟨i, by omega, ?_⟩
        have e : p + 8#64 + BitVec.ofNat 64 (8 * i) = p + BitVec.ofNat 64 (8 * (i + 1)) := by
          rw [BitVec.add_assoc]; congr 1; bv_omega
        simp [e]

theorem wordsAtoms_isPointsTo {p : Word} {xs : List Word} :
    ∀ a ∈ wordsAtoms p xs, a.IsPointsTo := by
  intro a ha
  obtain ⟨i, hi, rfl⟩ := mem_wordsAtoms.1 ha
  trivial

/-- An atom that is not memory is disjoint from every atom of an array. -/
theorem disj_wordsAtoms_of_not_mem {p : Word} {xs : List Word} {a : Atom}
    (ha : ∀ q n v w, Atom.Disj a (.mem q n v w)) : ∀ b ∈ wordsAtoms p xs, Atom.Disj a b := by
  intro b hb
  obtain ⟨i, hi, rfl⟩ := mem_wordsAtoms.1 hb
  exact ha _ _ _ _

theorem disj_reg_wordsAtoms {p : Word} {xs : List Word} {r : Reg} {v : Word} :
    ∀ b ∈ wordsAtoms p xs, Atom.Disj (.reg r v) b :=
  disj_wordsAtoms_of_not_mem fun _ _ _ _ => Atom.disj_reg_mem

theorem disj_flag_wordsAtoms {p : Word} {xs : List Word} {f : Flag} {c : Bool} :
    ∀ b ∈ wordsAtoms p xs, Atom.Disj (.flag f c) b :=
  disj_wordsAtoms_of_not_mem fun _ _ _ _ => Atom.disj_flag_mem

theorem disj_pc_wordsAtoms {p : Word} {xs : List Word} {a : Word} :
    ∀ b ∈ wordsAtoms p xs, Atom.Disj (.pc a) b :=
  disj_wordsAtoms_of_not_mem fun _ _ _ _ => Atom.disj_pc_mem

/-- A memory atom is disjoint from every atom of an array that it does not reach into. -/
theorem disj_mem_wordsAtoms {p q v : Word} {n : Nat} {w : Bool} {xs : List Word}
    (h : ∀ x : Word, (x - q).toNat < n → ¬ (x - p).toNat < 8 * xs.length)
    (hlen : 8 * xs.length ≤ 2 ^ 64) :
    ∀ b ∈ wordsAtoms p xs, Atom.Disj (.mem q n v w) b := by
  intro b hb
  obtain ⟨i, hi, rfl⟩ := mem_wordsAtoms.1 hb
  refine Atom.disj_mem_mem fun x hx => h x hx.1 ?_
  have := hx.2
  bv_omega

/-- The atoms of an array that does not wrap around the address space are disjoint. -/
theorem wordsAtoms_pairwise {p : Word} {xs : List Word} (hlen : 8 * xs.length ≤ 2 ^ 64) :
    (wordsAtoms p xs).Pairwise Atom.Disj := by
  induction xs generalizing p with
  | nil => exact .nil
  | cons x xs ih =>
    simp only [List.length_cons] at hlen
    refine List.pairwise_cons.2 ⟨?_, ih (by omega)⟩
    refine disj_mem_wordsAtoms (fun y hy hy' => ?_) (by omega)
    bv_omega

/-- The atoms of an array are true of a state when each word is. -/
theorem wordsAtoms_sat {p : Word} {xs : List Word} {σ : State}
    (h : ∀ (i : Nat) (hi : i < xs.length),
      (Atom.mem (p + BitVec.ofNat 64 (8 * i)) 8 xs[i] true).sat σ) :
    ∀ a ∈ wordsAtoms p xs, a.sat σ := by
  intro a ha
  obtain ⟨i, hi, rfl⟩ := mem_wordsAtoms.1 ha
  exact h i hi

/-! ## Bytes -/

theorem mem_bytesAtoms {p : Word} {bs : List (BitVec 8)} {b : Atom} :
    b ∈ bytesAtoms p bs ↔
      ∃ (i : Nat) (h : i < bs.length),
        b = .mem (p + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64) true := by
  induction bs generalizing p with
  | nil => simp [bytesAtoms]
  | cons c bs ih =>
    simp only [bytesAtoms, List.mem_cons, ih, List.length_cons]
    constructor
    · rintro (rfl | ⟨i, hi, rfl⟩)
      · exact ⟨0, by omega, by simp⟩
      · refine ⟨i + 1, by omega, ?_⟩
        have e : p + 1#64 + BitVec.ofNat 64 i = p + BitVec.ofNat 64 (i + 1) := by
          rw [BitVec.add_assoc]; congr 1; bv_omega
        simp [e]
    · rintro ⟨i, hi, rfl⟩
      cases i with
      | zero => left; simp
      | succ i =>
        right
        refine ⟨i, by omega, ?_⟩
        have e : p + 1#64 + BitVec.ofNat 64 i = p + BitVec.ofNat 64 (i + 1) := by
          rw [BitVec.add_assoc]; congr 1; bv_omega
        simp [e]

theorem bytesAtoms_isPointsTo {p : Word} {bs : List (BitVec 8)} :
    ∀ a ∈ bytesAtoms p bs, a.IsPointsTo := by
  intro a ha
  obtain ⟨i, hi, rfl⟩ := mem_bytesAtoms.1 ha
  trivial

/-- An atom that is not memory is disjoint from every atom of an array of bytes. -/
theorem disj_bytesAtoms_of_not_mem {p : Word} {bs : List (BitVec 8)} {a : Atom}
    (ha : ∀ q n v w, Atom.Disj a (.mem q n v w)) : ∀ b ∈ bytesAtoms p bs, Atom.Disj a b := by
  intro b hb
  obtain ⟨i, hi, rfl⟩ := mem_bytesAtoms.1 hb
  exact ha _ _ _ _

theorem disj_reg_bytesAtoms {p : Word} {xs : List (BitVec 8)} {r : Reg} {v : Word} :
    ∀ b ∈ bytesAtoms p xs, Atom.Disj (.reg r v) b :=
  disj_bytesAtoms_of_not_mem fun _ _ _ _ => Atom.disj_reg_mem

theorem disj_flag_bytesAtoms {p : Word} {xs : List (BitVec 8)} {f : Flag} {c : Bool} :
    ∀ b ∈ bytesAtoms p xs, Atom.Disj (.flag f c) b :=
  disj_bytesAtoms_of_not_mem fun _ _ _ _ => Atom.disj_flag_mem

theorem disj_pc_bytesAtoms {p : Word} {xs : List (BitVec 8)} {a : Word} :
    ∀ b ∈ bytesAtoms p xs, Atom.Disj (.pc a) b :=
  disj_bytesAtoms_of_not_mem fun _ _ _ _ => Atom.disj_pc_mem

/-- A memory atom is disjoint from every atom of an array of bytes that it does not reach
into. -/
theorem disj_mem_bytesAtoms {p q v : Word} {n : Nat} {w : Bool} {bs : List (BitVec 8)}
    (h : ∀ x : Word, (x - q).toNat < n → ¬ (x - p).toNat < bs.length)
    (hlen : bs.length ≤ 2 ^ 64) :
    ∀ b ∈ bytesAtoms p bs, Atom.Disj (.mem q n v w) b := by
  intro b hb
  obtain ⟨i, hi, rfl⟩ := mem_bytesAtoms.1 hb
  refine Atom.disj_mem_mem fun x hx => h x hx.1 ?_
  have := hx.2
  bv_omega

/-- The atoms of an array of bytes that does not wrap around the address space are
disjoint. -/
theorem bytesAtoms_pairwise {p : Word} {bs : List (BitVec 8)} (hlen : bs.length ≤ 2 ^ 64) :
    (bytesAtoms p bs).Pairwise Atom.Disj := by
  induction bs generalizing p with
  | nil => exact .nil
  | cons c bs ih =>
    simp only [List.length_cons] at hlen
    refine List.pairwise_cons.2 ⟨?_, ih (by omega)⟩
    refine disj_mem_bytesAtoms (fun y hy hy' => ?_) (by omega)
    bv_omega

/-- The atoms of an array of bytes are true of a state when each byte is. -/
theorem bytesAtoms_sat {p : Word} {bs : List (BitVec 8)} {σ : State}
    (h : ∀ (i : Nat) (hi : i < bs.length),
      (Atom.mem (p + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64) true).sat σ) :
    ∀ a ∈ bytesAtoms p bs, a.sat σ := by
  intro a ha
  obtain ⟨i, hi, rfl⟩ := mem_bytesAtoms.1 ha
  exact h i hi

end Braid
