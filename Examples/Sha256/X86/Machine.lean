/-
  Examples.Sha256.X86.Machine

  What the theorems about the x86-64 machine say of the memory of SHA-256: an array of
  32-bit words the machine has, and the lemmas that carry such an array into the logic and
  back out.

  ## Main definitions

  * `HasCells`: the machine has an array of 32-bit words in memory
  * `HasWords`: the machine has an array of 64-bit words in memory, such as part of the stack
  * `Apart`: two regions of memory have no address in common

  ## Main results

  * `HasCells.sat`: the atoms of an array are true of a machine that has it
  * `hasCells_of_holds`, `hasBytes_of_cell`: an array, read off a postcondition
-/

module

public import Examples.Sha256.Common
public import Lowering.X86.Logic

@[expose] public section

namespace Examples.Sha256.X86

open Braid Lowering.X86

/-- The machine has the 32-bit words `xs` in memory from `p` on, little-endian. -/
def HasCells (m : MachineState) (p : Word) (xs : List W32) : Prop :=
  ∀ (i : Nat) (hi : i < xs.length),
    HasBytes m (p + BitVec.ofNat 64 (4 * i)) 4 (xs[i].setWidth 64)

theorem HasCells.sat {m : MachineState} {p : Word} {xs : List W32} (h : HasCells m p xs) :
    ∀ a ∈ cellsAtoms 4 true p (w32s xs), a.sat (abs m) :=
  cellsAtoms_sat fun i hi => sat_mem_abs.2 (by
    have := h i (by simpa using hi)
    simpa [w32s] using this)

/-- The machine has the 64-bit words `xs` in memory from `p` on, little-endian. -/
def HasWords (m : MachineState) (p : Word) (xs : List Word) : Prop :=
  ∀ (i : Nat) (hi : i < xs.length), HasBytes m (p + BitVec.ofNat 64 (8 * i)) 8 xs[i]

theorem HasWords.sat {m : MachineState} {p : Word} {xs : List Word} (h : HasWords m p xs) :
    ∀ a ∈ cellsAtoms 8 true p xs, a.sat (abs m) :=
  cellsAtoms_sat fun i hi => sat_mem_abs.2 (h i hi)

/-- The machine has the 64-bit word `v` in memory at `p`, as an array of one word. -/
theorem sat_word {m : MachineState} {p v : Word} (h : HasBytes m p 8 v) :
    ∀ a ∈ cellsAtoms 8 true p [v], a.sat (abs m) := by
  simpa [cellsAtoms] using sat_mem_abs.2 h

/-- The `n` bytes from `a` and the `k` bytes from `b` have no address in common: each region
starts at or after the end of the other, going round the address space. -/
def Apart (a : Word) (n : Nat) (b : Word) (k : Nat) : Prop :=
  n ≤ (b - a).toNat ∧ k ≤ (a - b).toNat

/-- A cell of an array of a postcondition, read off the machine. -/
theorem hasBytes_of_cell {m : MachineState} {σ : State} {as : Atoms} {R : SProp} {k : Nat}
    {w : Bool} {p : Word} {xs : List Word} (hr : Rel m σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.prop (cellsAt k w p xs))) (i : Nat) (hi : i < xs.length) :
    HasBytes m (p + BitVec.ofNat 64 (k * i)) k xs[i] := by
  intro x hx
  have hc := cell_of_holds h hat i hi hx
  rw [hr.data.mem] at hc
  obtain ⟨b, hb, hc⟩ := memOf_eq_some hc
  rw [hb]
  simpa using (congrArg Cell.val hc).symm

/-- **An array of 32-bit words, out of the logic.** A machine related to a state of which a
list of atoms holds has each word of an array in the list. -/
theorem hasCells_of_holds {m : MachineState} {σ : State} {as : Atoms} {R : SProp} {p : Word}
    {xs : List W32} (hr : Rel m σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.prop (cellsAt 4 true p (w32s xs)))) : HasCells m p xs := by
  intro i hi
  have hi' : i < (w32s xs).length := by simpa using hi
  have := hasBytes_of_cell hr h hat i hi'
  simpa [w32s] using this

end Examples.Sha256.X86
