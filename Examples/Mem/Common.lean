/-
  Examples.Mem.Common

  What the proofs about `mem.c` share, on every instruction set.

  `equal_bytes` only reads its two regions, so they may overlap, or be the same region. An
  assertion with one array for each region would say that they are disjoint. Here memory is
  instead a set of single bytes, `cellsOn f addrs`, at a list of addresses, each holding
  what a function `f` says, and each region is a list of bytes that is read through that set
  (`Reads`). The set is opened at any of its addresses for a load, and closed again.

  ## Main definitions

  * `cellsOn f addrs`: each address of the list holds the byte `f` gives it
  * `cellsOnAtoms f addrs`: the same, as memory atoms, for theorems about a machine
  * `Reads f addrs p bs`: the bytes `bs` are those of `f` from `p` on, at addresses of the list
  * `addrsFrom p n`: the `n` addresses from `p` on
  * `dedup`: a list without its repetitions

  ## Main results

  * `cellsOn_open`: a set of bytes, opened at one of its addresses
  * `cellsOnAtoms_pairwise`, `cellsOnAtoms_sat`, `disj_mem_cellsOnAtoms`: a set written out
  * `reads_of_forall`: `Reads`, from what each byte is
  * `bytesAt_cell`: the cells of an array of bytes that holds of a state
  * `bytesAtoms_disj`, `pairwise_flat₂`, `forall_flat₂`: a state with two arrays, written out
-/

module

public import Braid
import Iris.BI.DerivedLaws

@[expose] public section

namespace Examples.Mem

open Braid Iris Iris.BI

/-! ## A set of bytes -/

/-- Each address of the list holds the byte `f` gives it, and may be written. The addresses
are distinct, since the bytes are separate. -/
def cellsOn (f : Word → BitVec 8) : List Word → SProp
  | [] => iprop(emp)
  | x :: xs => iprop(memIs x 1 ((f x).zeroExtend 64) ∗ cellsOn f xs)

/-- The memory atoms of a set of bytes. -/
def cellsOnAtoms (f : Word → BitVec 8) : List Word → Atoms
  | [] => []
  | x :: xs => .mem x 1 ((f x).zeroExtend 64) true :: cellsOnAtoms f xs

theorem cellsOn_eq_interp (f : Word → BitVec 8) (addrs : List Word) :
    cellsOn f addrs = Atoms.interp (cellsOnAtoms f addrs) := by
  induction addrs with
  | nil => rfl
  | cons x xs ih => simp only [cellsOn, cellsOnAtoms, Atoms.interp_cons, ih]; rfl

/-- **A set of bytes, opened at one of its addresses**: the byte there, as a memory atom the
execution rules can use, and the other bytes. -/
theorem cellsOn_open (f : Word → BitVec 8) {x : Word} {addrs : List Word} (h : x ∈ addrs) :
    (Atom.prop (cellsOn f addrs)).interp =
      Atoms.interp [.mem x 1 ((f x).zeroExtend 64) true, .prop (cellsOn f (addrs.erase x))] := by
  induction addrs with
  | nil => cases h
  | cons y ys ih =>
    by_cases e : y = x
    · subst e
      rw [List.erase_cons_head]
      exact SProp.ext ⟨sep_mono_right sep_emp.symm.1, sep_mono_right sep_emp.1⟩
    · have hx : x ∈ ys := by
        rcases List.mem_cons.1 h with rfl | h
        · exact absurd rfl e
        · exact h
      have ih' : cellsOn f ys =
          iprop(memIs x 1 ((f x).zeroExtend 64) ∗ cellsOn f (ys.erase x)) := by
        have := ih hx
        simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil] at this
        rw [this]
        exact SProp.ext (sep_congr_right sep_emp)
      rw [List.erase_cons_tail (by simpa using e)]
      simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil, cellsOn, ih']
      exact SProp.ext (sep_left_comm.trans (sep_congr_right sep_emp.symm))

theorem mem_cellsOnAtoms {f : Word → BitVec 8} {addrs : List Word} {b : Atom} :
    b ∈ cellsOnAtoms f addrs ↔ ∃ x ∈ addrs, b = .mem x 1 ((f x).zeroExtend 64) true := by
  induction addrs with
  | nil => simp [cellsOnAtoms]
  | cons y ys ih => simp [cellsOnAtoms, ih]

theorem cellsOnAtoms_isPointsTo {f : Word → BitVec 8} {addrs : List Word} :
    ∀ a ∈ cellsOnAtoms f addrs, a.IsPointsTo := by
  intro a ha
  obtain ⟨x, _, rfl⟩ := mem_cellsOnAtoms.1 ha
  trivial

/-- An atom that is not memory is disjoint from every atom of a set of bytes. -/
theorem disj_cellsOnAtoms_of_not_mem {f : Word → BitVec 8} {addrs : List Word} {a : Atom}
    (ha : ∀ q n v w, Atom.Disj a (.mem q n v w)) :
    ∀ b ∈ cellsOnAtoms f addrs, Atom.Disj a b := by
  intro b hb
  obtain ⟨x, _, rfl⟩ := mem_cellsOnAtoms.1 hb
  exact ha _ _ _ _

theorem disj_reg_cellsOnAtoms {f : Word → BitVec 8} {addrs : List Word} {r : Reg} {v : Word} :
    ∀ b ∈ cellsOnAtoms f addrs, Atom.Disj (.reg r v) b :=
  disj_cellsOnAtoms_of_not_mem fun _ _ _ _ => Atom.disj_reg_mem

theorem disj_flag_cellsOnAtoms {f : Word → BitVec 8} {addrs : List Word} {g : Flag}
    {c : Bool} : ∀ b ∈ cellsOnAtoms f addrs, Atom.Disj (.flag g c) b :=
  disj_cellsOnAtoms_of_not_mem fun _ _ _ _ => Atom.disj_flag_mem

theorem disj_pc_cellsOnAtoms {f : Word → BitVec 8} {addrs : List Word} {a : Word} :
    ∀ b ∈ cellsOnAtoms f addrs, Atom.Disj (.pc a) b :=
  disj_cellsOnAtoms_of_not_mem fun _ _ _ _ => Atom.disj_pc_mem

/-- A memory atom is disjoint from every atom of a set of bytes none of whose addresses it
reaches. -/
theorem disj_mem_cellsOnAtoms {f : Word → BitVec 8} {addrs : List Word} {q v : Word} {n : Nat}
    {w : Bool} (h : ∀ x ∈ addrs, ¬ (x - q).toNat < n) :
    ∀ b ∈ cellsOnAtoms f addrs, Atom.Disj (.mem q n v w) b := by
  intro b hb
  obtain ⟨x, hx, rfl⟩ := mem_cellsOnAtoms.1 hb
  refine Atom.disj_mem_mem fun y hy => h x hx ?_
  have e : y = x := by bv_omega
  rw [← e]
  exact hy.1

/-- The atoms of a set of bytes at distinct addresses are disjoint. -/
theorem cellsOnAtoms_pairwise {f : Word → BitVec 8} {addrs : List Word}
    (h : addrs.Pairwise (· ≠ ·)) : (cellsOnAtoms f addrs).Pairwise Atom.Disj := by
  induction addrs with
  | nil => exact .nil
  | cons y ys ih =>
    obtain ⟨hy, hys⟩ := List.pairwise_cons.1 h
    refine List.pairwise_cons.2 ⟨disj_mem_cellsOnAtoms fun x hx hlt => hy x hx ?_, ih hys⟩
    bv_omega

/-- The atoms of a set of bytes are true of a state when each byte is. -/
theorem cellsOnAtoms_sat {f : Word → BitVec 8} {addrs : List Word} {σ : State}
    (h : ∀ x ∈ addrs, (Atom.mem x 1 ((f x).zeroExtend 64) true).sat σ) :
    ∀ a ∈ cellsOnAtoms f addrs, a.sat σ := by
  intro a ha
  obtain ⟨x, hx, rfl⟩ := mem_cellsOnAtoms.1 ha
  exact h x hx

/-! ## Reading a list of bytes through a set -/

/-- The bytes `bs` are those `f` gives the addresses from `p` on, and each of those addresses
is in the list. -/
def Reads (f : Word → BitVec 8) (addrs : List Word) : Word → List (BitVec 8) → Prop
  | _, [] => True
  | p, b :: bs => p ∈ addrs ∧ f p = b ∧ Reads f addrs (p + 1#64) bs

/-- `Reads`, from what each byte is. -/
theorem reads_of_forall {f : Word → BitVec 8} {addrs : List Word} :
    ∀ {bs : List (BitVec 8)} {p : Word},
      (∀ (i : Nat) (hi : i < bs.length),
        p + BitVec.ofNat 64 i ∈ addrs ∧ f (p + BitVec.ofNat 64 i) = bs[i]) →
      Reads f addrs p bs
  | [], _, _ => trivial
  | b :: bs, p, h => by
    have h0 := h 0 (by simp)
    simp only [BitVec.add_zero, List.getElem_cons_zero] at h0
    refine ⟨h0.1, h0.2, reads_of_forall fun i hi => ?_⟩
    have e : p + 1#64 + BitVec.ofNat 64 i = p + BitVec.ofNat 64 (i + 1) := by
      rw [BitVec.add_assoc]; congr 1; bv_omega
    have := h (i + 1) (by simpa using hi)
    rw [e]
    simpa using this

/-! ## Lists of addresses -/

/-- The `n` addresses from `p` on. -/
def addrsFrom (p : Word) (n : Nat) : List Word :=
  (List.range n).map fun i => p + BitVec.ofNat 64 i

theorem mem_addrsFrom {p x : Word} {n : Nat} :
    x ∈ addrsFrom p n ↔ ∃ i, i < n ∧ x = p + BitVec.ofNat 64 i := by
  simp only [addrsFrom, List.mem_map, List.mem_range]
  exact ⟨fun ⟨i, hi, e⟩ => ⟨i, hi, e.symm⟩, fun ⟨i, hi, e⟩ => ⟨i, hi, e.symm⟩⟩

/-- A list without its repetitions. -/
def dedup : List Word → List Word
  | [] => []
  | x :: xs => if x ∈ dedup xs then dedup xs else x :: dedup xs

theorem mem_dedup {x : Word} : ∀ {l : List Word}, x ∈ dedup l ↔ x ∈ l
  | [] => Iff.rfl
  | y :: ys => by
    simp only [dedup]
    split
    · rename_i hy
      rw [List.mem_cons, ← mem_dedup (l := ys)]
      exact ⟨Or.inr, fun h => h.elim (fun e => e ▸ hy) id⟩
    · rw [List.mem_cons, List.mem_cons, mem_dedup (l := ys)]

theorem dedup_pairwise : ∀ l : List Word, (dedup l).Pairwise (· ≠ ·)
  | [] => .nil
  | y :: ys => by
    simp only [dedup]
    split
    · exact dedup_pairwise ys
    · rename_i hy
      exact List.pairwise_cons.2 ⟨fun x hx e => hy (e ▸ hx), dedup_pairwise ys⟩

/-! ## An array of bytes, out of the logic -/

/-- The cells of an array of bytes that holds of a state. -/
theorem bytesAt_cell {σ : State} : ∀ {bs : List (BitVec 8)} {p : Word} {R : SProp},
    (bytesAt p bs).holds R σ → ∀ (i : Nat) (hi : i < bs.length),
      σ.mem (p + BitVec.ofNat 64 i) = some ⟨bs[i], true⟩
  | [], _, _, _, _, hi => absurd hi (by simp)
  | b :: bs, p, R, h, 0, _ => by
    have := memIs_cell (x := p) (SProp.holds_assoc.1 h) (by simp)
    simpa using this
  | b :: bs, p, R, h, i + 1, hi => by
    have h' : (iprop(bytesAt (p + 1#64) bs ∗ memIs p 1 (b.zeroExtend 64) true) : SProp).holds
        R σ := SProp.holds_mono sep_comm.1 h
    have := bytesAt_cell (SProp.holds_assoc.1 h') i (by simpa using hi)
    have e : p + 1#64 + BitVec.ofNat 64 i = p + BitVec.ofNat 64 (i + 1) := by
      rw [BitVec.add_assoc]; congr 1; bv_omega
    simpa [e] using this

/-! ## A state with two arrays, written out -/

/-- The atoms of two arrays of bytes are disjoint when each array starts at or beyond the end
of the other, going round the address space. -/
theorem bytesAtoms_disj {p q : Word} {xs ys : List (BitVec 8)}
    (hx : xs.length ≤ (q - p).toNat) (hy : ys.length ≤ (p - q).toNat) :
    ∀ a ∈ bytesAtoms p xs, ∀ b ∈ bytesAtoms q ys, Atom.Disj a b := by
  intro a ha b hb
  obtain ⟨i, hi, rfl⟩ := mem_bytesAtoms.1 ha
  obtain ⟨j, hj, rfl⟩ := mem_bytesAtoms.1 hb
  refine Atom.disj_mem_mem fun x h => ?_
  obtain ⟨h1, h2⟩ := h
  bv_omega

/-- Disjointness of a state with two arrays written out in the middle of it: the rest is
pairwise disjoint, each array is, the arrays are disjoint from each other, and each atom of
the rest is disjoint from each of the arrays'. -/
theorem pairwise_flat₂ {l₁ m₁ m₂ l₂ : Atoms} (h : (l₁ ++ l₂).Pairwise Atom.Disj)
    (h₁ : m₁.Pairwise Atom.Disj) (h₂ : m₂.Pairwise Atom.Disj)
    (h₁₂ : ∀ a ∈ m₁, ∀ b ∈ m₂, Atom.Disj a b)
    (hc₁ : ∀ a ∈ l₁ ++ l₂, ∀ b ∈ m₁, Atom.Disj a b)
    (hc₂ : ∀ a ∈ l₁ ++ l₂, ∀ b ∈ m₂, Atom.Disj a b) :
    (l₁ ++ (m₁ ++ (m₂ ++ l₂))).Pairwise Atom.Disj := by
  rw [List.pairwise_append] at h
  have hl : ∀ {a}, a ∈ l₁ → a ∈ l₁ ++ l₂ := fun ha => List.mem_append_left _ ha
  have hr : ∀ {a}, a ∈ l₂ → a ∈ l₁ ++ l₂ := fun ha => List.mem_append_right _ ha
  refine List.pairwise_append.2 ⟨h.1, List.pairwise_append.2 ⟨h₁, List.pairwise_append.2
    ⟨h₂, h.2.1, fun a ha b hb => (hc₂ b (hr hb) a ha).symm⟩, fun a ha b hb => ?_⟩,
    fun a ha b hb => ?_⟩
  · rcases List.mem_append.1 hb with hb | hb
    · exact h₁₂ a ha b hb
    · exact (hc₁ b (hr hb) a ha).symm
  · rcases List.mem_append.1 hb with hb | hb
    · exact hc₁ a (hl ha) b hb
    · rcases List.mem_append.1 hb with hb | hb
      · exact hc₂ a (hl ha) b hb
      · exact h.2.2 a ha b hb

/-- A property of every atom of a state with two arrays written out in the middle of it. -/
theorem forall_flat₂ {l₁ m₁ m₂ l₂ : Atoms} {P : Atom → Prop} (h : ∀ a ∈ l₁ ++ l₂, P a)
    (h₁ : ∀ a ∈ m₁, P a) (h₂ : ∀ a ∈ m₂, P a) : ∀ a ∈ l₁ ++ (m₁ ++ (m₂ ++ l₂)), P a := by
  intro a ha
  rcases List.mem_append.1 ha with ha | ha
  · exact h a (List.mem_append_left _ ha)
  · rcases List.mem_append.1 ha with ha | ha
    · exact h₁ a ha
    · rcases List.mem_append.1 ha with ha | ha
      · exact h₂ a ha
      · exact h a (List.mem_append_right _ ha)

end Examples.Mem
