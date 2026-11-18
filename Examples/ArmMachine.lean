/-
  Examples.ArmMachine

  What the AArch64 examples need to state a theorem about the machine alone when the code
  touches memory: a predicate for the bytes of a word in the machine's memory, one for two
  regions that do not overlap, and the lemmas that carry them into the logic and back out.
  They belong in `Lowering.Arm.Logic`, and are in its namespace.

  ## Main definitions

  * `HasBytes`: the machine has bytes of a word in memory, and may load and store them
  * `Apart`: two regions of memory have no address in common

  ## Main results

  * `sat_mem_hasBytes`: a writable memory atom is true of a machine state when it has the bytes
  * `disj_mem_of_apart`, `Apart.disj_mem`: memory atoms on, or within, regions that are apart
    are disjoint
  * `hasBytes_of_holds`, `hasBytes_of_bytesAt`: memory, read off a postcondition
  * `machine_sound₂`: `machine_sound` for code in two places, a function and one it calls
-/

module

public import Lowering.Arm.Logic
import Iris.BI.DerivedLaws

@[expose] public section

namespace Lowering.Arm

open Braid Iris Iris.BI

/-- The machine has the low `n` bytes of `v` in memory at `a`, little-endian, and may load
each of them and store to it. -/
def HasBytes (s : Arm64.State) (a : Word) (n : Nat) (v : Word) : Prop :=
  ∀ x : Word, (x - a).toNat < n →
    readable s.mem x = true ∧ s.mem.read8 x = (v >>> ((x - a) <<< 3)).truncate 8 ∧
      writable s.mem x = true

/-- The `n` bytes from `a` and the `m` bytes from `b` have no address in common: each region
starts at or after the end of the other, going round the address space. -/
def Apart (a : Word) (n : Nat) (b : Word) (m : Nat) : Prop :=
  n ≤ (b - a).toNat ∧ m ≤ (a - b).toNat

/-- A writable memory atom is true of the state of a machine exactly when the machine has its
bytes. -/
theorem sat_mem_hasBytes {s : Arm64.State} {a v : Word} {n : Nat} :
    (Atom.mem a n v true).sat (abs s) ↔ HasBytes s a n v :=
  sat_mem_abs

/-- No address is in both of two regions that are apart. -/
theorem Apart.not_both {a b : Word} {n m : Nat} (h : Apart a n b m) (x : Word) :
    ¬ ((x - a).toNat < n ∧ (x - b).toNat < m) := by
  obtain ⟨h1, h2⟩ := h
  rintro ⟨hx1, hx2⟩
  bv_omega

/-- An address within a region is within one that contains it. -/
theorem lt_of_sub_region {x a a' : Word} {n n' : Nat} (ha : (a' - a).toNat + n' ≤ n)
    (hx : (x - a').toNat < n') : (x - a).toNat < n := by
  have e : x - a = (x - a') + (a' - a) := by bv_omega
  have := Nat.mod_le ((x - a').toNat + (a' - a).toNat) (2 ^ 64)
  rw [e, BitVec.toNat_add]
  omega

/-- Memory atoms on regions that are apart are disjoint. -/
theorem disj_mem_of_apart {a b v v' : Word} {n m : Nat} {w w' : Bool} (h : Apart a n b m) :
    Atom.Disj (.mem a n v w) (.mem b m v' w') :=
  Atom.disj_mem_mem h.not_both

/-- Memory atoms within regions that are apart are disjoint: the first is `n'` bytes at `a'`
inside the `n` bytes at `a`, and the second likewise inside the `m` bytes at `b`. -/
theorem Apart.disj_mem {a b : Word} {n m : Nat} (h : Apart a n b m) {a' b' v v' : Word}
    {n' m' : Nat} {w w' : Bool} (ha : (a' - a).toNat + n' ≤ n)
    (hb : (b' - b).toNat + m' ≤ m) : Atom.Disj (.mem a' n' v w) (.mem b' m' v' w') :=
  Atom.disj_mem_mem fun x hx =>
    h.not_both x ⟨lt_of_sub_region ha hx.1, lt_of_sub_region hb hx.2⟩

/-- Prove that the atoms of a precondition are pairwise disjoint, where it has memory atoms:
`braid_disj`, then each pair of memory atoms at fixed offsets from one address by `bv_omega`.
A pair that needs a hypothesis to tell it apart is left as a goal, for `disj_mem_of_apart`
or `Apart.disj_mem`. -/
macro "braid_disj_mem" : tactic =>
  `(tactic| (braid_disj
             repeat' apply And.intro
             all_goals first
               | decide
               | (refine Atom.disj_mem_mem fun x hx => ?_
                  obtain ⟨hx1, hx2⟩ := hx
                  bv_omega)
               | skip))

/-- A machine related to a state with writable cells at the bytes of a word has those
bytes. -/
theorem Rel.hasBytes {s : Arm64.State} {σ : State} (h : Rel s σ) {a v : Word} {n : Nat}
    (hm : ∀ x : Word, (x - a).toNat < n →
      σ.mem x = some ⟨(v >>> ((x - a) <<< 3)).truncate 8, true⟩) : HasBytes s a n v := by
  intro x hx
  have := hm x hx
  rw [h.mem x] at this
  cases hr : readable s.mem x <;> simp_all

/-- **Memory, out of the logic.** A machine related to a state of which a list of atoms
holds has the bytes of each writable memory atom in the list. -/
theorem hasBytes_of_holds {s : Arm64.State} {σ : State} {as : Atoms} {R : SProp}
    {a v : Word} {n : Nat} (hr : Rel s σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.mem a n v true)) : HasBytes s a n v :=
  hr.hasBytes fun _ hx => Atoms.mem_of_holds h hat hx

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

/-- **An array of bytes, out of the logic.** A machine related to a state of which a list of
atoms holds has each byte of an array in the list. -/
theorem hasBytes_of_bytesAt {s : Arm64.State} {σ : State} {as : Atoms} {R : SProp} {p : Word}
    {bs : List (BitVec 8)} (hr : Rel s σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.prop (bytesAt p bs))) (i : Nat) (hi : i < bs.length) :
    HasBytes s (p + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64) := by
  obtain ⟨F, e⟩ := hat.split
  rw [e] at h
  refine hr.hasBytes fun x hx => ?_
  have hx' : x = p + BitVec.ofNat 64 i := by bv_omega
  subst hx'
  simpa using bytesAt_cell (SProp.holds_assoc.1 h) i hi

/-- The blocks of two lists are blocks of a program that has the blocks of each. -/
theorem ofList_append_le {l₁ l₂ : List (Word × Block)} {P : Program}
    (h₁ : ∀ a b, Program.ofList l₁ a = some b → P a = some b)
    (h₂ : ∀ a b, Program.ofList l₂ a = some b → P a = some b) (a : Word) (b : Block)
    (h : Program.ofList (l₁ ++ l₂) a = some b) : P a = some b := by
  simp only [Program.ofList, List.find?_append] at h
  cases hf : l₁.find? (·.1 == a) with
  | some p => exact h₁ a b (by simpa [Program.ofList, hf] using h)
  | none => exact h₂ a b (by simpa [Program.ofList, hf] using h)

/-- **`machine_sound`, for code in two places.** The triple is about the lowering of the
words `ws₁` at `base₁` together with that of `ws₂` at `base₂`, a function and one it
calls, and the program holds both. -/
theorem machine_sound₂ {prog : Arm64.Program} {base₁ base₂ : Word}
    {ws₁ ws₂ : List (BitVec 32)} {blocks₁ blocks₂ : List (Word × Block)} {pre post : Atoms}
    {s : Arm64.State} (hlow₁ : blocks₁ = lowerWords base₁ ws₁)
    (hlow₂ : blocks₂ = lowerWords base₂ ws₂)
    (ht : Triple (Program.ofList (blocks₁ ++ blocks₂)) (Atoms.interp pre)
      (Atoms.interp post))
    (hw₁ : prog.hasWords base₁ ws₁) (hw₂ : prog.hasWords base₂ ws₂)
    (hc : prog.CodeLoaded s.mem) (hrun : s.status = .Running)
    (hpt : ∀ a ∈ pre, a.IsPointsTo) (hdisj : pre.Pairwise Atom.Disj)
    (hsat : ∀ a ∈ pre, a.sat (abs s)) :
    ∃ s' σ', Arm64.Steps prog s s' ∧ Rel s' σ' ∧
      (Atoms.interp post).holds iprop(True) σ' := by
  subst hlow₁ hlow₂
  exact lowerProgram_sound hc (rel_abs hrun)
    ((ht.sound (Atoms.holds_of_sat hpt hdisj hsat)).of_le
      (ofList_append_le (ofList_le_lowerProgram hw₁) (ofList_le_lowerProgram hw₂)))

end Lowering.Arm
