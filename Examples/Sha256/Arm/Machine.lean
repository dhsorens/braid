/-
  Examples.Sha256.Arm.Machine

  What the theorems about the AArch64 machine say of the memory of SHA-256: an array of
  32-bit words the machine has, writable or read-only, and the lemmas that carry such an
  array into the logic and back out. `HasReadOnlyBytes` is the read-only form of
  `HasBytes`, and belongs beside it in `Examples.ArmMachine`.

  ## Main definitions

  * `HasReadOnlyBytes`: the machine has bytes of a word in memory, and may load them only
  * `HasCells`, `HasReadOnlyCells`: the machine has an array of 32-bit words in memory

  ## Main results

  * `HasCells.sat`, `HasReadOnlyCells.sat`: the atoms of an array are true of a machine that
    has it
  * `hasCells_of_holds`: an array, read off a postcondition
-/

module

public import Examples.Sha256.Common
public import Examples.ArmMachine

@[expose] public section

namespace Examples.Sha256.Arm

open Braid Lowering.Arm

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

/-- The machine has the 32-bit words `xs` in memory from `p` on, little-endian, and may load
and store them. -/
def HasCells (s : Arm64.State) (p : Word) (xs : List W32) : Prop :=
  ∀ (i : Nat) (hi : i < xs.length),
    HasBytes s (p + BitVec.ofNat 64 (4 * i)) 4 (xs[i].setWidth 64)

/-- The machine has the 32-bit words `xs` in memory from `p` on, little-endian, and may load
them but not store to them. -/
def HasReadOnlyCells (s : Arm64.State) (p : Word) (xs : List W32) : Prop :=
  ∀ (i : Nat) (hi : i < xs.length),
    HasReadOnlyBytes s (p + BitVec.ofNat 64 (4 * i)) 4 (xs[i].setWidth 64)

theorem HasCells.sat {s : Arm64.State} {p : Word} {xs : List W32} (h : HasCells s p xs) :
    ∀ a ∈ cellsAtoms 4 true p (w32s xs), a.sat (abs s) :=
  cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (by
    have := h i (by simpa using hi)
    simpa [w32s] using this)

theorem HasReadOnlyCells.sat {s : Arm64.State} {p : Word} {xs : List W32}
    (h : HasReadOnlyCells s p xs) : ∀ a ∈ cellsAtoms 4 false p (w32s xs), a.sat (abs s) :=
  cellsAtoms_sat fun i hi => sat_mem_hasReadOnlyBytes.2 (by
    have := h i (by simpa using hi)
    simpa [w32s] using this)

/-- **An array of 32-bit words, out of the logic.** A machine related to a state of which a
list of atoms holds has each word of a writable array in the list. -/
theorem hasCells_of_holds {s : Arm64.State} {σ : State} {as : Atoms} {R : SProp} {p : Word}
    {xs : List W32} (hr : Rel s σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.prop (cellsAt 4 true p (w32s xs)))) : HasCells s p xs := by
  intro i hi
  have hi' : i < (w32s xs).length := by simpa using hi
  refine hr.hasBytes fun x hx => ?_
  have := cell_of_holds h hat i hi' hx
  simpa [w32s] using this

end Examples.Sha256.Arm
