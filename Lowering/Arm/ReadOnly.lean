/-
  Lowering.Arm.ReadOnly

  Arrays of bytes that may not be stored to. The model gives each byte of memory a
  permission, and the constants of a binary are loaded read-only, so the sections of an image
  are of two kinds: those that may be stored to, which are `bytesAt`, and those that may not.
  This file has the second kind, `bytesW false`, with what `Braid.Logic.Bytes` and
  `Braid.Logic.Flat` have for `bytesAt`: an array is its cells, it splits at an index, and a
  state that has it loaded satisfies it. Nothing here is particular to AArch64.

  ## Main definitions

  * `bytesW`: an array of bytes, writable or not
  * `Image.Apart`, `Image.LoadedIn`: the sections of an image do not overlap, and a state
    has them loaded, those with contents read-only and the zeroed ones writable
  * `dataAtoms`, `zeroAtoms`: the sections of an image, as assertions of a symbolic state

  ## Main results

  * `bytesW_true`: a writable array is `bytesAt`
  * `bytesW_interp_mem`, `bytesW_interp_cellsAt`, `bytesW_index`: an array as one cell, as an
    array of cells, and opened at an index
  * `holds_image`: a state that has the sections of an image loaded satisfies them beside its
    registers
-/

module

public import Braid.Logic
import Iris.BI.DerivedLaws

@[expose] public section

namespace Lowering.Arm

open Braid hiding Image
open Iris Iris.BI

/-- An array of bytes at `p`, which may be stored to if `w`. -/
def bytesW (w : Bool) (p : Word) : List (BitVec 8) → SProp
  | [] => iprop(emp)
  | b :: bs => iprop(memIs p 1 (b.zeroExtend 64) w ∗ bytesW w (p + 1#64) bs)

/-- The memory atoms of an array of bytes. -/
def bytesWAtoms (w : Bool) (p : Word) : List (BitVec 8) → Atoms
  | [] => []
  | b :: bs => .mem p 1 (b.zeroExtend 64) w :: bytesWAtoms w (p + 1#64) bs

variable {w : Bool}

/-- A writable array of bytes is `bytesAt`. -/
theorem bytesW_true (p : Word) (bs : List (BitVec 8)) : bytesW true p bs = bytesAt p bs := by
  induction bs generalizing p with
  | nil => rfl
  | cons b bs ih => simp only [bytesW, bytesAt, ih]

theorem bytesW_eq_interp (p : Word) (bs : List (BitVec 8)) :
    bytesW w p bs = Atoms.interp (bytesWAtoms w p bs) := by
  induction bs generalizing p with
  | nil => rfl
  | cons b bs ih => simp only [bytesW, bytesWAtoms, Atoms.interp_cons, ih]; rfl

/-! ## A cell is its bytes -/

/-- **A cell is its bytes.** A cell of at most eight bytes holding `v` is the array of the low
bytes of `v`, least significant first. -/
theorem memIs_eq_bytesW (a v : Word) (k : Nat) (hk : k ≤ 8) :
    memIs a k v w = bytesW w a (leBytes k v) := by
  induction k generalizing a v with
  | zero => exact memIs_zero a v w
  | succ k ih =>
    rw [memIs_succ a v k w (by omega), ih (a + 1#64) (v >>> 8) (by omega), leBytes_succ]
    simp only [bytesW, memIs_byte]

/-- An array of bytes known to be those of a word, as a memory atom. -/
theorem bytesW_interp_mem (a v : Word) (k : Nat) (bs : List (BitVec 8)) (hk : k ≤ 8)
    (h : bs = leBytes k v) :
    (Atom.prop (bytesW w a bs)).interp = Atoms.interp [.mem a k v w] := by
  subst h
  show bytesW w a (leBytes k v) = iprop(memIs a k v w ∗ emp)
  rw [← memIs_eq_bytesW a v k hk]
  exact SProp.ext ⟨sep_emp.2, sep_emp.1⟩

/-! ## An array of bytes, in two parts -/

theorem bytesW_append_eq (p : Word) (xs ys : List (BitVec 8)) :
    bytesW w p (xs ++ ys) =
      iprop(bytesW w p xs ∗ bytesW w (p + BitVec.ofNat 64 xs.length) ys) := by
  induction xs generalizing p with
  | nil =>
    have e : p + BitVec.ofNat 64 ([] : List (BitVec 8)).length = p := by simp
    rw [e]
    exact SProp.ext emp_sep.symm
  | cons x xs ih =>
    simp only [List.cons_append, bytesW, ih, List.length_cons, bytes_addr_succ]
    exact SProp.ext sep_assoc.symm

/-- An array of bytes, split at `i`. -/
theorem bytesW_split (p : Word) (bs : List (BitVec 8)) (i : Nat) (hi : i ≤ bs.length) :
    (Atom.prop (bytesW w p bs)).interp =
      Atoms.interp [.prop (bytesW w p (bs.take i)),
        .prop (bytesW w (p + BitVec.ofNat 64 i) (bs.drop i))] := by
  have e := bytesW_append_eq (w := w) p (bs.take i) (bs.drop i)
  rw [List.take_append_drop, List.length_take, Nat.min_eq_left hi] at e
  rw [e]
  exact sep_interp_pair _ _

/-- An array of bytes, opened at index `i`. -/
theorem bytesW_index (p : Word) (bs : List (BitVec 8)) (i : Nat) (hi : i < bs.length) :
    (Atom.prop (bytesW w p bs)).interp =
      Atoms.interp [.prop (bytesW w p (bs.take i)),
        .mem (p + BitVec.ofNat 64 i) 1 ((bs.getD i 0#8).zeroExtend 64) w,
        .prop (bytesW w (p + BitVec.ofNat 64 i + 1#64) (bs.drop (i + 1)))] := by
  rw [bytesW_split p bs i (Nat.le_of_lt hi)]
  have hd : bs.drop i = bs.getD i 0#8 :: bs.drop (i + 1) := by
    rw [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hi]
    exact List.drop_eq_getElem_cons hi
  simp only [Atoms.interp_cons, Atoms.interp_nil, Atom.interp, hd, bytesW]
  exact SProp.ext ⟨sep_mono_right sep_assoc.1, sep_mono_right sep_assoc.2⟩

/-! ## An array of cells is the bytes of its cells -/

theorem cellsAt_eq_bytesW (p : Word) (vs : List Word) (k : Nat) (hk : k ≤ 8) :
    cellsAt k w p vs = bytesW w p (vs.flatMap (leBytes k)) := by
  induction vs generalizing p with
  | nil => rfl
  | cons v vs ih =>
    simp only [cellsAt, List.flatMap_cons, bytesW_append_eq, leBytes_length,
      memIs_eq_bytesW p v k hk, ih]

/-- An array of bytes that are those of cells, as the array of the cells: for
`braid_unfold` and `braid_fold`. -/
theorem bytesW_interp_cellsAt (p : Word) (bs : List (BitVec 8)) (vs : List Word) (k : Nat)
    (hk : k ≤ 8) (h : bs = vs.flatMap (leBytes k)) :
    (Atom.prop (bytesW w p bs)).interp = Atoms.interp [.prop (cellsAt k w p vs)] := by
  subst h
  rw [← prop_interp_singleton, cellsAt_eq_bytesW p vs k hk]

/-! ## The atoms of an array -/

theorem mem_bytesWAtoms {p : Word} {bs : List (BitVec 8)} {b : Atom} :
    b ∈ bytesWAtoms w p bs ↔
      ∃ (i : Nat) (h : i < bs.length),
        b = .mem (p + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64) w := by
  induction bs generalizing p with
  | nil => simp [bytesWAtoms]
  | cons c bs ih =>
    simp only [bytesWAtoms, List.mem_cons, ih, List.length_cons]
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

/-- Two arrays of bytes that do not overlap have disjoint atoms. -/
theorem disj_bytesWAtoms {w' : Bool} {p q : Word} {bs cs : List (BitVec 8)}
    (h : p.toNat + bs.length ≤ q.toNat ∨ q.toNat + cs.length ≤ p.toNat)
    (hp : p.toNat + bs.length ≤ 2 ^ 64) (hq : q.toNat + cs.length ≤ 2 ^ 64) :
    ∀ a ∈ bytesWAtoms w p bs, ∀ b ∈ bytesWAtoms w' q cs, Atom.Disj a b := by
  intro a ha b hb
  obtain ⟨i, hi, rfl⟩ := mem_bytesWAtoms.1 ha
  obtain ⟨j, hj, rfl⟩ := mem_bytesWAtoms.1 hb
  refine Atom.disj_mem_mem fun x hx => ?_
  have := hx.1
  have := hx.2
  bv_omega

/-- The atoms of an array of bytes that does not wrap around the address space are
disjoint. -/
theorem bytesWAtoms_pairwise {p : Word} {bs : List (BitVec 8)} (hlen : bs.length ≤ 2 ^ 64) :
    (bytesWAtoms w p bs).Pairwise Atom.Disj := by
  induction bs generalizing p with
  | nil => exact .nil
  | cons c bs ih =>
    simp only [List.length_cons] at hlen
    refine List.pairwise_cons.2 ⟨?_, ih (by omega)⟩
    intro b hb
    obtain ⟨i, hi, rfl⟩ := mem_bytesWAtoms.1 hb
    refine Atom.disj_mem_mem fun x hx => ?_
    have := hx.1
    have := hx.2
    bv_omega

/-! ## The sections of an image -/

/-- Byte arrays as assertions of a symbolic state: one `bytesW` for each. -/
def secAtoms (w : Bool) (secs : List (Word × List (BitVec 8))) : Atoms :=
  secs.map fun d => .prop (bytesW w d.1 d.2)

/-- Byte arrays as memory atoms, one for each byte. -/
def secFlat (w : Bool) : List (Word × List (BitVec 8)) → Atoms
  | [] => []
  | d :: ds => bytesWAtoms w d.1 d.2 ++ secFlat w ds

theorem secAtoms_interp (secs : List (Word × List (BitVec 8))) :
    Atoms.interp (secAtoms w secs) = Atoms.interp (secFlat w secs) := by
  induction secs with
  | nil => rfl
  | cons d ds ih =>
    simp only [secAtoms, List.map_cons, secFlat, Atoms.interp_cons, Atoms.interp_append] at ih ⊢
    rw [ih, ← bytesW_eq_interp]
    rfl

theorem mem_secFlat {secs : List (Word × List (BitVec 8))} {b : Atom} :
    b ∈ secFlat w secs ↔ ∃ d ∈ secs, b ∈ bytesWAtoms w d.1 d.2 := by
  induction secs with
  | nil => simp [secFlat]
  | cons d ds ih => simp [secFlat, ih]

theorem secFlat_pairwise {secs : List (Word × List (BitVec 8))} (h : Sections.Apart secs) :
    (secFlat w secs).Pairwise Atom.Disj := by
  induction secs with
  | nil => exact .nil
  | cons d ds ih =>
    obtain ⟨hp, hw⟩ := h
    rw [List.pairwise_cons] at hp
    have hd := hw d List.mem_cons_self
    refine List.pairwise_append.2 ⟨bytesWAtoms_pairwise (by omega),
      ih ⟨hp.2, fun e he => hw e (List.mem_cons_of_mem _ he)⟩, ?_⟩
    intro a ha b hb
    obtain ⟨e, he, hb⟩ := mem_secFlat.1 hb
    exact disj_bytesWAtoms (.inl (hp.1 e he)) hd (hw e (List.mem_cons_of_mem _ he)) a ha b hb

/-- The zeroed sections of an image, as byte arrays. -/
def zeros (zero : List (Word × Nat)) : List (Word × List (BitVec 8)) :=
  zero.map fun z => (z.1, List.replicate z.2 0#8)

/-- The sections of an image that have contents, as assertions: arrays of bytes that may not
be stored to. -/
def dataAtoms {ι : Type} (img : Braid.Image ι) : Atoms := secAtoms false img.data

/-- The zeroed sections of an image, as assertions: arrays of zero bytes that may be stored
to. -/
def zeroAtoms {ι : Type} (img : Braid.Image ι) : Atoms := sectionAtoms (zeros img.zero)

/-- The sections of an image do not overlap: those with contents are in address order and
apart, the zeroed ones are, and none of the first kind overlaps one of the second. A
written-out image decides this. -/
def Image.Apart {ι : Type} (img : Braid.Image ι) : Prop :=
  Sections.Apart img.data ∧ Sections.Apart (zeros img.zero) ∧
    ∀ d ∈ img.data, ∀ z ∈ zeros img.zero,
      d.1.toNat + d.2.length ≤ z.1.toNat ∨ z.1.toNat + z.2.length ≤ d.1.toNat

instance {ι : Type} (img : Braid.Image ι) : Decidable (Image.Apart img) :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _))

/-- The sections of an image are in the memory of the state: the bytes of those with
contents, which may not be stored to, and zeros that may be stored to for the others. -/
def Image.LoadedIn {ι : Type} (img : Braid.Image ι) (σ : State) : Prop :=
  (∀ d ∈ img.data, ∀ (i : Nat) (hi : i < d.2.length),
    σ.mem (d.1 + BitVec.ofNat 64 i) = some ⟨d.2[i], false⟩) ∧
  ∀ z ∈ img.zero, ∀ i < z.2, σ.mem (z.1 + BitVec.ofNat 64 i) = some ⟨0#8, true⟩

theorem sat_bytesWAtoms {p : Word} {bs : List (BitVec 8)} {σ : State}
    (h : ∀ (i : Nat) (hi : i < bs.length), σ.mem (p + BitVec.ofNat 64 i) = some ⟨bs[i], w⟩) :
    ∀ a ∈ bytesWAtoms w p bs, a.sat σ := by
  intro a ha
  obtain ⟨i, hi, rfl⟩ := mem_bytesWAtoms.1 ha
  refine Atom.sat_mem.2 fun x hx => ?_
  have e : x = p + BitVec.ofNat 64 i := by bv_omega
  subst e
  rw [h i hi]
  have e0 : p + BitVec.ofNat 64 i - (p + BitVec.ofNat 64 i) = 0#64 := by bv_omega
  simp [e0]

/-- **A state that has the sections of an image loaded satisfies them, beside its
registers.** `regs` are atoms for registers, flags and the program counter, each true of the
state. Then the state satisfies the registers, the sections with contents as read-only
arrays and the zeroed sections as writable arrays, beside the rest of it. -/
theorem holds_image {ι : Type} {img : Braid.Image ι} {regs : Atoms} {σ : State}
    (hpt : ∀ a ∈ regs, a.IsPointsTo)
    (hnm : ∀ a ∈ regs, ∀ q n v w, Atom.Disj a (.mem q n v w))
    (hrd : regs.Pairwise Atom.Disj) (hrs : ∀ a ∈ regs, a.sat σ)
    (hap : Image.Apart img) (hmem : Image.LoadedIn img σ) :
    (iprop(Atoms.interp (regs ++ dataAtoms img ++ zeroAtoms img) ∗ True) : SProp) σ.heap := by
  obtain ⟨hd, hz, hx⟩ := hap
  have hzf : Atoms.interp (zeroAtoms img) = Atoms.interp (secFlat true (zeros img.zero)) := by
    rw [← secAtoms_interp]
    simp only [zeroAtoms, sectionAtoms, secAtoms, bytesW_true]
  refine Atoms.holds_of_sat_flat
    (flat := regs ++ secFlat false img.data ++ secFlat true (zeros img.zero)) ?_ ?_ ?_ ?_
  · simp only [Atoms.interp_append, dataAtoms, secAtoms_interp, hzf]
  · intro a ha
    rcases List.mem_append.1 ha with ha | ha
    · rcases List.mem_append.1 ha with ha | ha
      · exact hpt a ha
      · obtain ⟨d, _, hb⟩ := mem_secFlat.1 ha
        obtain ⟨i, hi, rfl⟩ := mem_bytesWAtoms.1 hb
        trivial
    · obtain ⟨d, _, hb⟩ := mem_secFlat.1 ha
      obtain ⟨i, hi, rfl⟩ := mem_bytesWAtoms.1 hb
      trivial
  · refine List.pairwise_append.2 ⟨List.pairwise_append.2 ⟨hrd, secFlat_pairwise hd, ?_⟩,
      secFlat_pairwise hz, ?_⟩
    · intro a ha b hb
      obtain ⟨d, _, hb⟩ := mem_secFlat.1 hb
      obtain ⟨i, hi, rfl⟩ := mem_bytesWAtoms.1 hb
      exact hnm a ha _ _ _ _
    · intro a ha b hb
      obtain ⟨z, hzm, hb⟩ := mem_secFlat.1 hb
      rcases List.mem_append.1 ha with ha | ha
      · obtain ⟨i, hi, rfl⟩ := mem_bytesWAtoms.1 hb
        exact hnm a ha _ _ _ _
      · obtain ⟨d, hdm, ha⟩ := mem_secFlat.1 ha
        exact disj_bytesWAtoms (hx d hdm z hzm) (hd.2 d hdm) (hz.2 z hzm) a ha b hb
  · intro a ha
    rcases List.mem_append.1 ha with ha | ha
    · rcases List.mem_append.1 ha with ha | ha
      · exact hrs a ha
      · obtain ⟨d, hdm, hb⟩ := mem_secFlat.1 ha
        exact sat_bytesWAtoms (hmem.1 d hdm) a hb
    · obtain ⟨z, hzm, hb⟩ := mem_secFlat.1 ha
      obtain ⟨z', hz', rfl⟩ := List.mem_map.1 hzm
      refine sat_bytesWAtoms (fun i hi => ?_) a hb
      have hi' : i < z'.2 := by simpa using hi
      simp [hmem.2 z' hz' i hi']

end Lowering.Arm
