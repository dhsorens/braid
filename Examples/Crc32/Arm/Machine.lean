/-
  Examples.Crc32.Arm.Machine

  What a theorem about the AArch64 machine needs when the code reads a table in read-only
  data: a predicate for bytes the machine may load but not store to, the read-only form of
  `HasBytes`. It belongs in `Lowering.Arm.Logic`, beside `HasBytes`, and is in its namespace.

  ## Main definitions

  * `HasReadOnlyBytes`: the machine has bytes of a word in memory, and may load them only

  ## Main results

  * `sat_mem_hasReadOnlyBytes`: a read-only memory atom is true of a machine state when it
    has the bytes, read-only
  * `HasBytes.not_readOnly`: no byte is both in a writable word and in a read-only one
  * `hasReadOnlyBytes_of_cells`: a read-only array, read off a postcondition
-/

module

public import Examples.ArmMachine
public import Examples.Crc32.Common

@[expose] public section

namespace Lowering.Arm

open Braid

/-- The machine has the low `n` bytes of `v` in memory at `a`, little-endian, and may load
each of them but not store to it: bytes of read-only data. -/
def HasReadOnlyBytes (s : Arm64.State) (a : Word) (n : Nat) (v : Word) : Prop :=
  ∀ x : Word, (x - a).toNat < n →
    readable s.mem x = true ∧ s.mem.read8 x = (v >>> ((x - a) <<< 3)).truncate 8 ∧
      writable s.mem x = false

/-- A read-only memory atom is true of the state of a machine exactly when the machine has
its bytes, read-only. -/
theorem sat_mem_hasReadOnlyBytes {s : Arm64.State} {a v : Word} {n : Nat} :
    (Atom.mem a n v false).sat (abs s) ↔ HasReadOnlyBytes s a n v :=
  sat_mem_abs

/-- No byte is both in a word the machine may store to and in one it may not: memory atoms
on a writable word and a read-only one are disjoint. -/
theorem HasBytes.not_readOnly {s : Arm64.State} {a b v v' : Word} {n m : Nat}
    (h : HasBytes s a n v) (h' : HasReadOnlyBytes s b m v') :
    Atom.Disj (.mem a n v true) (.mem b m v' false) :=
  Atom.disj_mem_mem fun x hx => by
    have h1 := (h x hx.1).2.2
    have h2 := (h' x hx.2).2.2
    rw [h1] at h2
    exact Bool.noConfusion h2

/-- A machine related to a state with read-only cells at the bytes of a word has those bytes,
read-only. -/
theorem Rel.hasReadOnlyBytes {s : Arm64.State} {σ : State} (h : Rel s σ) {a v : Word} {n : Nat}
    (hm : ∀ x : Word, (x - a).toNat < n →
      σ.mem x = some ⟨(v >>> ((x - a) <<< 3)).truncate 8, false⟩) :
    HasReadOnlyBytes s a n v := by
  intro x hx
  have := hm x hx
  rw [h.mem x] at this
  cases hr : readable s.mem x <;> simp_all

/-- **A read-only array, out of the logic.** A machine related to a state of which a list of
atoms holds has each cell of a read-only array in the list, read-only. -/
theorem hasReadOnlyBytes_of_cells {s : Arm64.State} {σ : State} {as : Atoms} {R : SProp}
    {k : Nat} {p : Word} {vs : List Word} (hr : Rel s σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.prop (cellsAt k false p vs))) (i : Nat) (hi : i < vs.length) :
    HasReadOnlyBytes s (p + BitVec.ofNat 64 (k * i)) k vs[i] := by
  obtain ⟨F, e⟩ := hat.split
  rw [e] at h
  exact hr.hasReadOnlyBytes fun x hx =>
    Examples.Crc32.cellsAt_cell (SProp.holds_assoc.1 h) i hi x hx

end Lowering.Arm
