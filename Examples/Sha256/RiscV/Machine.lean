/-
  Examples.Sha256.RiscV.Machine

  What the theorems about the RISC-V machine say of the memory of SHA-256: an array of
  32-bit words the machine has, and the lemmas that carry such an array into the logic and
  back out. The model has no read-only memory: `Lowering.RiscV.abs` gives every valid byte
  as writable, so the round constants are an array like the others, apart from them.

  RISC-V has no 32-bit registers. A 32-bit value is the low half of a 64-bit register, and
  the code adds such values with the 64-bit `add`, so the high half of a register holds
  whatever the carries left there. `regLow` says what such a register holds: a word with
  given low 32 bits.

  ## Main definitions

  * `HasCells`: the machine has an array of 32-bit words in memory
  * `HasWords`: the machine has an array of 64-bit words in memory, such as part of the stack
  * `Apart`: two regions of memory have no address in common
  * `regLow`: a register holds a word with given low 32 bits

  ## Main results

  * `HasCells.sat`: the atoms of an array are true of a machine that has it
  * `hasCells_of_holds`: an array, read off a postcondition
  * `Triple.forget_high`, `Triple.reg_low`: forget the high half of a register, and name the
    word a register holds again
  * `and3_add_mul4`: a multiple of four added to an address leaves its alignment
-/

module

public import Examples.Sha256.Common
public import Lowering.RiscV.Logic
import Iris.BI.DerivedLaws
import Braid.BV

@[expose] public section

namespace Examples.Sha256.RiscV

open Braid Lowering.RiscV RiscvZkvm.Rv64
open Iris Iris.BI

/-- The machine has the 32-bit words `xs` in valid memory from `p` on, little-endian. -/
def HasCells (s : MachineState) (p : Word) (xs : List W32) : Prop :=
  ∀ (i : Nat) (hi : i < xs.length),
    HasBytes s (p + BitVec.ofNat 64 (4 * i)) 4 (xs[i].setWidth 64)

theorem HasCells.sat {s : MachineState} {p : Word} {xs : List W32} (h : HasCells s p xs) :
    ∀ a ∈ cellsAtoms 4 true p (w32s xs), a.sat (abs s) :=
  cellsAtoms_sat fun i hi => sat_mem_abs.2 (by
    have := h i (by simpa using hi)
    simpa [w32s] using this)

/-- The machine has the 64-bit words `xs` in valid memory from `p` on, little-endian. -/
def HasWords (s : MachineState) (p : Word) (xs : List Word) : Prop :=
  ∀ (i : Nat) (hi : i < xs.length), HasBytes s (p + BitVec.ofNat 64 (8 * i)) 8 xs[i]

theorem HasWords.sat {s : MachineState} {p : Word} {xs : List Word} (h : HasWords s p xs) :
    ∀ a ∈ cellsAtoms 8 true p xs, a.sat (abs s) :=
  cellsAtoms_sat fun i hi => sat_mem_abs.2 (h i hi)

/-- The machine has the 64-bit word `v` in memory at `p`, as an array of one word. -/
theorem sat_word {s : MachineState} {p v : Word} (h : HasBytes s p 8 v) :
    ∀ a ∈ cellsAtoms 8 true p [v], a.sat (abs s) := by
  simpa [cellsAtoms] using sat_mem_abs.2 h

/-- The `n` bytes from `a` and the `k` bytes from `b` have no address in common: each region
starts at or after the end of the other, going round the address space. -/
def Apart (a : Word) (n : Nat) (b : Word) (k : Nat) : Prop :=
  n ≤ (b - a).toNat ∧ k ≤ (a - b).toNat

/-- A cell of an array of a postcondition, read off the machine. -/
theorem hasBytes_of_cell {s : MachineState} {σ : State} {as : Atoms} {R : SProp} {k : Nat}
    {w : Bool} {p : Word} {xs : List Word} (hr : Rel s σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.prop (cellsAt k w p xs))) (i : Nat) (hi : i < xs.length) :
    HasBytes s (p + BitVec.ofNat 64 (k * i)) k xs[i] := by
  intro x hx
  obtain ⟨hv, hc⟩ := hr.cell (cell_of_holds h hat i hi hx)
  exact ⟨hv, (congrArg Cell.val hc).symm⟩

/-- **An array of 32-bit words, out of the logic.** A machine related to a state of which a
list of atoms holds has each word of an array in the list. -/
theorem hasCells_of_holds {s : MachineState} {σ : State} {as : Atoms} {R : SProp} {p : Word}
    {xs : List W32} (hr : Rel s σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.prop (cellsAt 4 true p (w32s xs)))) : HasCells s p xs := by
  intro i hi
  have hi' : i < (w32s xs).length := by simpa using hi
  have := hasBytes_of_cell hr h hat i hi'
  simpa [w32s] using this

/-! ## A 32-bit value in a 64-bit register -/

/-- The word with high half `hi` and low half `v`. -/
def withLow (hi v : W32) : Word := hi.setWidth 64 <<< 32 ||| v.setWidth 64

/-- Register `r` holds a word whose low 32 bits are `v`; its high 32 bits are not known. -/
def regLow (r : Braid.Reg) (v : W32) : SProp := iprop(∃ hi : W32, regIs r (withLow hi v))

/-- Forget the high half of a register: keep the low 32 bits of its value, as `v`. -/
theorem _root_.Braid.Triple.forget_high {P : Program} {as as' : Atoms} {r : Braid.Reg}
    {x : Word} (v : W32) {Q : SProp} (hupd : as.Upd (.reg r x) (.prop (regLow r v)) as')
    (he : x.setWidth 32 = v) (h : Triple P (Atoms.interp as') Q) :
    Triple P (Atoms.interp as) Q := by
  obtain ⟨F, e, e'⟩ := hupd.split
  have hx : x = withLow (x.extractLsb' 32 32) v := by
    subst he
    unfold withLow
    bv_auto
  rw [e]; rw [e'] at h
  refine h.conseq (sep_mono_left (fun _ hv => ⟨_, ⟨x.extractLsb' 32 32, rfl⟩, ?_⟩)) .rfl
  show regIs r (withLow (x.extractLsb' 32 32) v) _
  rw [← hx]
  exact hv

/-- Name the word a register with known low 32 bits holds. -/
theorem _root_.Braid.Triple.reg_low {P : Program} {as rest : Atoms} {r : Braid.Reg} {v : W32}
    {Q : SProp} (hext : as.Extract (.prop (regLow r v)) rest)
    (h : ∀ x : Word, x.setWidth 32 = v → Triple P (Atoms.interp (.reg r x :: rest)) Q) :
    Triple P (Atoms.interp as) Q := by
  rw [hext.interp]
  exact (Triple.exists_pre fun hi : W32 =>
    h (withLow hi v) (by unfold withLow; bv_auto)).conseq sep_exists_right.1 .rfl

/-- Give a register of the symbolic state, of whose value only the low 32 bits matter, the
value `v` of the specification: `sha256_low r, v`. -/
macro "sha256_low " r:term ", " v:term : tactic =>
  `(tactic| (refine Triple.forget_high (r := $r) $v (by braid_upd) ?_ ?_
             · sha256_bv))

/-- Name the word a register with known low 32 bits holds, and the equation that gives its
low 32 bits: `sha256_name_low r with x hx`. -/
macro "sha256_name_low " r:term " with " x:ident hx:ident : tactic =>
  `(tactic| (apply Triple.reg_low (r := $r)
             case hext => braid_extract
             intro $x:ident $hx:ident))

/-! ## Alignment -/

/-- A multiple of four added to an address leaves its alignment to four bytes as it was. -/
theorem and3_add_mul4 (p : Word) (t : Nat) :
    (p + BitVec.ofNat 64 (4 * t)) &&& 3#64 = p &&& 3#64 := by
  have e : BitVec.ofNat 64 (4 * t) = 4#64 * BitVec.ofNat 64 t := by
    rw [BitVec.ofNat_mul]
  rw [e]
  generalize BitVec.ofNat 64 t = x
  bv_auto

end Examples.Sha256.RiscV
