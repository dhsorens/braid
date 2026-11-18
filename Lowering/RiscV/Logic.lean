/-
  Lowering.RiscV.Logic

  The separation logic, for RISC-V. A triple about lowered code is a statement about the
  machine: `triple_sound` carries it down through the lowering.

  ## Main definitions

  * `Regs`: the ABI names of the registers

  ## Main results

  * `triple_sound`: a triple about the lowered code of a function, for the machine
-/

module

public import Lowering.RiscV.Sound
public import Braid.Logic
import Iris.BI.DerivedLaws

@[expose] public section

namespace Lowering.RiscV

open Braid hiding Reg
open RiscvZkvm.Rv64

/-! The ABI names of the registers, as `braid` registers. -/

namespace Regs

abbrev ra : Braid.Reg := 1
abbrev sp : Braid.Reg := 2
abbrev gp : Braid.Reg := 3
abbrev tp : Braid.Reg := 4
abbrev t0 : Braid.Reg := 5
abbrev t1 : Braid.Reg := 6
abbrev t2 : Braid.Reg := 7
abbrev s0 : Braid.Reg := 8
abbrev s1 : Braid.Reg := 9
abbrev a0 : Braid.Reg := 10
abbrev a1 : Braid.Reg := 11
abbrev a2 : Braid.Reg := 12
abbrev a3 : Braid.Reg := 13
abbrev a4 : Braid.Reg := 14
abbrev a5 : Braid.Reg := 15
abbrev a6 : Braid.Reg := 16
abbrev a7 : Braid.Reg := 17
abbrev s2 : Braid.Reg := 18
abbrev s3 : Braid.Reg := 19
abbrev s4 : Braid.Reg := 20
abbrev s5 : Braid.Reg := 21
abbrev s6 : Braid.Reg := 22
abbrev s7 : Braid.Reg := 23
abbrev s8 : Braid.Reg := 24
abbrev s9 : Braid.Reg := 25
abbrev s10 : Braid.Reg := 26
abbrev s11 : Braid.Reg := 27
abbrev t3 : Braid.Reg := 28
abbrev t4 : Braid.Reg := 29
abbrev t5 : Braid.Reg := 30
abbrev t6 : Braid.Reg := 31

end Regs

/-- The lowering of a list of instructions is part of the lowering of any code memory that
holds them. -/
theorem ofList_le_lowerCode {code : List (Word × Instr)} {mem : Word → Option Instr}
    (hcode : ∀ p ∈ code, mem p.1 = some p.2) (a : Word) (b : Block)
    (h : Program.ofList (code.map fun p => (p.1, lower p.1 p.2)) a = some b) :
    lowerCode mem a = some b := by
  simp only [Program.ofList, Option.map_eq_some_iff] at h
  obtain ⟨⟨a', b'⟩, hfind, rfl⟩ := h
  have hmem := List.mem_of_find?_eq_some hfind
  have ha : a' = a := by simpa using List.find?_some hfind
  subst ha
  obtain ⟨p, hp, hpe⟩ := List.mem_map.1 hmem
  cases hpe
  simp [lowerCode, hcode p hp]

/-- **A triple about lowered RISC-V code holds of the machine.** Let a machine state hold
the instructions `code`, and be related to a `braid` state part of which satisfies `pre`.
If the lowering of `code` satisfies the triple from `pre` to `post`, then the machine runs,
without a trap, to a state related to one part of which satisfies `post`. -/
theorem triple_sound {code : List (Word × Instr)} {blocks : List (Word × Block)}
    {pre post : SProp} {s : MachineState} {σ : State}
    (hlow : blocks = code.map fun p => (p.1, lower p.1 p.2))
    (ht : Triple (Program.ofList blocks) pre post)
    (hcode : ∀ p ∈ code, s.code p.1 = some p.2) (h : Rel s σ)
    (hp : (iprop(pre ∗ True) : SProp) σ.heap) :
    ∃ n s' σ', stepN n s = some s' ∧ Rel s' σ' ∧ (iprop(post ∗ True) : SProp) σ'.heap := by
  subst hlow
  exact lowerCode_sound rfl h ((ht.sound hp).of_le (ofList_le_lowerCode hcode))

/-! ## Theorems about the machine alone -/

/-- The register with a given number; `x0` beyond 31. -/
def regOfNat : Nat → Reg
  | 0 => .x0
  | 1 => .x1
  | 2 => .x2
  | 3 => .x3
  | 4 => .x4
  | 5 => .x5
  | 6 => .x6
  | 7 => .x7
  | 8 => .x8
  | 9 => .x9
  | 10 => .x10
  | 11 => .x11
  | 12 => .x12
  | 13 => .x13
  | 14 => .x14
  | 15 => .x15
  | 16 => .x16
  | 17 => .x17
  | 18 => .x18
  | 19 => .x19
  | 20 => .x20
  | 21 => .x21
  | 22 => .x22
  | 23 => .x23
  | 24 => .x24
  | 25 => .x25
  | 26 => .x26
  | 27 => .x27
  | 28 => .x28
  | 29 => .x29
  | 30 => .x30
  | 31 => .x31
  | _ => .x0

theorem regOfNat_toNat (r : Reg) : regOfNat r.toNat = r := by cases r <;> rfl

/-- The `braid` state of a machine state: its registers, its program counter and its valid
bytes, all writable. -/
def abs (s : MachineState) : State where
  regs n := s.getReg (regOfNat n)
  flags _ := false
  mem a := if isValidMemAddr a then some ⟨s.getByte a, true⟩ else none
  pc := s.pc

theorem rel_abs (s : MachineState) : Rel s (abs s) :=
  ⟨fun r hr => by simp only [abs, regOfNat_toNat, getReg_eq hr], rfl, fun _ => rfl⟩

theorem Rel.getReg {s : MachineState} {σ : State} (h : Rel s σ) {r : Reg} (hr : r ≠ .x0) :
    σ.regs r.toNat = s.getReg r := by
  rw [h.regs r hr, getReg_eq hr]

/-- **A triple about lowered RISC-V code, as a theorem about the machine.** If the machine
holds the instructions `code` and its state satisfies the atoms `pre`, it runs, without a
trap, to a state related to one that satisfies the atoms `post`. Read the conclusion off
with `Atoms.reg_of_holds` and its companions, and `Rel`. -/
theorem machine_sound {code : List (Word × Instr)} {blocks : List (Word × Block)}
    {pre post : Atoms} {s : MachineState}
    (hlow : blocks = code.map fun p => (p.1, lower p.1 p.2))
    (ht : Triple (Program.ofList blocks) (Atoms.interp pre) (Atoms.interp post))
    (hcode : ∀ p ∈ code, s.code p.1 = some p.2)
    (hpt : ∀ a ∈ pre, a.IsPointsTo) (hdisj : pre.Pairwise Atom.Disj)
    (hsat : ∀ a ∈ pre, a.sat (abs s)) :
    ∃ n s' σ', stepN n s = some s' ∧ Rel s' σ' ∧ (Atoms.interp post).holds iprop(True) σ' :=
  triple_sound hlow ht hcode (rel_abs s) (Atoms.holds_of_sat hpt hdisj hsat)

/-- The machine has the low `n` bytes of `v` in valid memory at `a`, little-endian. -/
def HasBytes (s : MachineState) (a : Word) (n : Nat) (v : Word) : Prop :=
  ∀ x : Word, (x - a).toNat < n →
    isValidMemAddr x = true ∧ s.getByte x = (v >>> ((x - a) <<< 3)).truncate 8

/-- A writable memory atom is true of the state of a machine exactly when the machine has its
bytes. -/
theorem sat_mem_abs {s : MachineState} {a v : Word} {n : Nat} :
    (Atom.mem a n v true).sat (abs s) ↔ HasBytes s a n v := by
  rw [Atom.sat_mem]
  refine forall_congr' fun x => imp_congr_right fun _ => ?_
  simp only [abs]
  cases isValidMemAddr x <;> simp

/-- `machine_sound`, for a precondition with arrays in it: `flat` is the precondition with
each array written out as its memory atoms (`Atoms.interp_flatten`). -/
theorem machine_sound_flat {code : List (Word × Instr)} {blocks : List (Word × Block)}
    {pre flat post : Atoms} {s : MachineState}
    (hlow : blocks = code.map fun p => (p.1, lower p.1 p.2))
    (ht : Triple (Program.ofList blocks) (Atoms.interp pre) (Atoms.interp post))
    (hcode : ∀ p ∈ code, s.code p.1 = some p.2)
    (heq : Atoms.interp pre = Atoms.interp flat)
    (hpt : ∀ a ∈ flat, a.IsPointsTo) (hdisj : flat.Pairwise Atom.Disj)
    (hsat : ∀ a ∈ flat, a.sat (abs s)) :
    ∃ n s' σ', stepN n s = some s' ∧ Rel s' σ' ∧ (Atoms.interp post).holds iprop(True) σ' :=
  triple_sound hlow ht hcode (rel_abs s) (Atoms.holds_of_sat_flat heq hpt hdisj hsat)

/-! ## Out of the logic, for memory -/


/-- **Out of the logic, for memory.** A machine related to a state of which a writable memory
atom holds has the bytes of that atom. -/
theorem hasBytes_of_holds {as : Atoms} {R : SProp} {s : MachineState} {σ : State}
    {a v : Word} {n : Nat} (hr : Rel s σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.mem a n v true)) : HasBytes s a n v := by
  intro x hx
  obtain ⟨hv, hc⟩ := hr.cell (Atoms.mem_of_holds h hat hx)
  exact ⟨hv, (congrArg Cell.val hc).symm⟩

/-- A machine related to a state of which an array of words holds has each of the words. -/
theorem hasBytes_of_holds_words {l₁ l₂ : Atoms} {R : SProp} {s : MachineState} {σ : State}
    {p : Word} {xs : List Word} (hr : Rel s σ)
    (h : (Atoms.interp (l₁ ++ .prop (wordsAt p xs) :: l₂)).holds R σ) (i : Nat)
    (hi : i < xs.length) : HasBytes s (p + BitVec.ofNat 64 (8 * i)) 8 xs[i] := by
  rw [wordsAt_eq_interp, Atoms.interp_flatten] at h
  exact hasBytes_of_holds hr h (Atoms.At.of_mem (List.mem_append_left _
    (List.mem_append_right _ (mem_wordsAtoms.2 ⟨i, hi, rfl⟩))))

/-- A machine related to a state of which an array of bytes holds has each of the bytes. -/
theorem hasBytes_of_holds_bytes {l₁ l₂ : Atoms} {R : SProp} {s : MachineState} {σ : State}
    {p : Word} {bs : List (BitVec 8)} (hr : Rel s σ)
    (h : (Atoms.interp (l₁ ++ .prop (bytesAt p bs) :: l₂)).holds R σ) (i : Nat)
    (hi : i < bs.length) : HasBytes s (p + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64) := by
  rw [bytesAt_eq_interp, Atoms.interp_flatten] at h
  exact hasBytes_of_holds hr h (Atoms.At.of_mem (List.mem_append_left _
    (List.mem_append_right _ (mem_bytesAtoms.2 ⟨i, hi, rfl⟩))))

end Lowering.RiscV
