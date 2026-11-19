/-
  Braid.Logic.Image

  A loaded binary, in the logic. The sections of an image are byte arrays at fixed addresses,
  and a state that has them loaded satisfies them as assertions, beside the registers: that
  is the precondition of a theorem about a whole program, and nothing in it is a hypothesis
  about memory other than that the binary is loaded.

  ## Main definitions

  * `Image.sections`: the sections of an image, the zeroed ones written out
  * `sectionAtoms`: byte arrays, as assertions of a symbolic state
  * `Sections.Apart`: byte arrays in address order that do not overlap
  * `Sections.LoadedIn`: the bytes of each array are in a state's memory, writable

  ## Main results

  * `holds_sections`: a state that has byte arrays loaded satisfies them beside its registers
-/

module

public import Braid.IR.Image
public import Braid.Logic.Flat

@[expose] public section

namespace Braid

open Iris Iris.BI

/-- The sections of an image as byte arrays: those with contents, and those without as
zeros. -/
def Image.sections {ι : Type} (img : Image ι) : List (Word × List (BitVec 8)) :=
  img.data ++ img.zero.map fun z => (z.1, List.replicate z.2 0#8)

/-- Byte arrays as assertions of a symbolic state: one `bytesAt` for each. -/
def sectionAtoms (secs : List (Word × List (BitVec 8))) : Atoms :=
  secs.map fun d => .prop (bytesAt d.1 d.2)

/-- Byte arrays as memory atoms, one for each byte. -/
def sectionFlat : List (Word × List (BitVec 8)) → Atoms
  | [] => []
  | d :: ds => bytesAtoms d.1 d.2 ++ sectionFlat ds

/-- Byte arrays that do not overlap: each ends at or before the start of every later one,
and none wraps around the address space. A list of sections with addresses written out
decides this. -/
def Sections.Apart (secs : List (Word × List (BitVec 8))) : Prop :=
  secs.Pairwise (fun d e => d.1.toNat + d.2.length ≤ e.1.toNat) ∧
    ∀ d ∈ secs, d.1.toNat + d.2.length ≤ 2 ^ 64

instance (secs : List (Word × List (BitVec 8))) : Decidable (Sections.Apart secs) :=
  inferInstanceAs (Decidable (_ ∧ _))

/-- The bytes of each array are in the memory of the state, and may be written. -/
def Sections.LoadedIn (secs : List (Word × List (BitVec 8))) (σ : State) : Prop :=
  ∀ d ∈ secs, ∀ (i : Nat) (hi : i < d.2.length),
    σ.mem (d.1 + BitVec.ofNat 64 i) = some ⟨d.2[i], true⟩

theorem sectionAtoms_interp (secs : List (Word × List (BitVec 8))) :
    Atoms.interp (sectionAtoms secs) = Atoms.interp (sectionFlat secs) := by
  induction secs with
  | nil => rfl
  | cons d ds ih =>
    simp only [sectionAtoms, List.map_cons, sectionFlat, Atoms.interp_cons,
      Atoms.interp_append] at ih ⊢
    rw [ih, ← bytesAt_eq_interp]
    rfl

theorem mem_sectionFlat {secs : List (Word × List (BitVec 8))} {b : Atom} :
    b ∈ sectionFlat secs ↔ ∃ d ∈ secs, b ∈ bytesAtoms d.1 d.2 := by
  induction secs with
  | nil => simp [sectionFlat]
  | cons d ds ih => simp [sectionFlat, ih]

theorem sectionFlat_pairwise {secs : List (Word × List (BitVec 8))} (h : Sections.Apart secs) :
    (sectionFlat secs).Pairwise Atom.Disj := by
  induction secs with
  | nil => exact .nil
  | cons d ds ih =>
    obtain ⟨hp, hw⟩ := h
    rw [List.pairwise_cons] at hp
    have hd := hw d List.mem_cons_self
    refine List.pairwise_append.2 ⟨bytesAtoms_pairwise (by omega),
      ih ⟨hp.2, fun e he => hw e (List.mem_cons_of_mem _ he)⟩, ?_⟩
    intro a ha b hb
    obtain ⟨i, hi, rfl⟩ := mem_bytesAtoms.1 ha
    obtain ⟨e, he, hb⟩ := mem_sectionFlat.1 hb
    obtain ⟨j, hj, rfl⟩ := mem_bytesAtoms.1 hb
    have h1 := hp.1 e he
    have h2 := hw e (List.mem_cons_of_mem _ he)
    refine Atom.disj_mem_mem fun x hx => ?_
    have := hx.1
    have := hx.2
    bv_omega

/-- **A state that has byte arrays loaded satisfies them, beside its registers.** `regs` are
atoms for registers, flags and the program counter, each true of the state; `secs` are byte
arrays that do not overlap, each in the state's memory. Then the state satisfies the
registers and the arrays, beside the rest of it. -/
theorem holds_sections {regs : Atoms} {secs : List (Word × List (BitVec 8))} {σ : State}
    (hpt : ∀ a ∈ regs, a.IsPointsTo) (hnm : ∀ a ∈ regs, ∀ q n v w, Atom.Disj a (.mem q n v w))
    (hrd : regs.Pairwise Atom.Disj) (hrs : ∀ a ∈ regs, a.sat σ)
    (hap : Sections.Apart secs) (hmem : Sections.LoadedIn secs σ) :
    (iprop(Atoms.interp (regs ++ sectionAtoms secs) ∗ True) : SProp) σ.heap := by
  refine Atoms.holds_of_sat_flat (flat := regs ++ sectionFlat secs) ?_ ?_ ?_ ?_
  · rw [Atoms.interp_append, Atoms.interp_append, sectionAtoms_interp]
  · intro a ha
    rcases List.mem_append.1 ha with ha | ha
    · exact hpt a ha
    · obtain ⟨d, _, hb⟩ := mem_sectionFlat.1 ha
      exact bytesAtoms_isPointsTo a hb
  · refine List.pairwise_append.2 ⟨hrd, sectionFlat_pairwise hap, ?_⟩
    intro a ha b hb
    obtain ⟨d, _, hb⟩ := mem_sectionFlat.1 hb
    exact disj_bytesAtoms_of_not_mem (hnm a ha) b hb
  · intro a ha
    rcases List.mem_append.1 ha with ha | ha
    · exact hrs a ha
    · obtain ⟨d, hd, hb⟩ := mem_sectionFlat.1 ha
      obtain ⟨i, hi, rfl⟩ := mem_bytesAtoms.1 hb
      refine Atom.sat_mem.2 fun x hx => ?_
      have e : x = d.1 + BitVec.ofNat 64 i := by bv_omega
      subst e
      rw [hmem d hd i hi]
      have e0 : d.1 + BitVec.ofNat 64 i - (d.1 + BitVec.ofNat 64 i) = 0#64 := by bv_omega
      simp [e0]

end Braid
