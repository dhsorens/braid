/-
  Lowering.RiscV.Leak

  What a RISC-V instruction reveals, and the trace of a run of the machine. This is the
  leakage model of `docs/Leakage.md` read on the instructions of `RiscvZkvm.Rv64`: a load or a
  store reveals its address and its size, a conditional branch and `JALR` reveal where they
  go, and a division or a remainder reveals its operands. Every other instruction reveals
  nothing: by the Zkt extension, additions, logic, shifts and multiplications take a time
  that does not depend on their operands.

  It also reads the two events of the environment off the model's `ECALL`, which follows the
  host interface of a zkVM: with `t0 = 0x10` the model appends the `a1` bytes at `a0` to its
  public output, and that is the event of writing those bytes; with `t0 = 0` the model halts,
  and that is the event of exiting, with the code in `a0`. A halted machine takes no step, so
  a run that reaches the halt may record the exit and stays where it is.

  This file is trusted: a theorem about what a RISC-V program leaks says so in these terms
  (`docs/Trust.md`). It is definitions only.

  ## Main definitions

  * `leak`: the labels of one instruction, from the state it runs in
  * `covered`: the instructions it speaks of
  * `RunL`: a run of the machine, with its trace
  * `Reachable`: the states a machine passes through
-/

module

public import RiscvZkvm.Rv64.Execution
public import Braid.IR.Trace

@[expose] public section

namespace Lowering.RiscV

open Braid hiding Reg
open RiscvZkvm.Rv64

/-- The address of a load or a store. -/
def ea (s : MachineState) (rs1 : Reg) (offset : BitVec 12) : Word :=
  s.getReg rs1 + signExtend12 offset

/-- Where a conditional branch goes. -/
def target (s : MachineState) (taken : Bool) (offset : BitVec 13) : Word :=
  if taken then s.pc + signExtend13 offset else s.pc + 4

/-- What the instruction `i` reveals when it runs in the state `s`. -/
def leak (s : MachineState) : Instr → Trace
  | .LD _ rs1 off => [.read (ea s rs1 off) 8]
  | .LW _ rs1 off | .LWU _ rs1 off => [.read (ea s rs1 off) 4]
  | .LH _ rs1 off | .LHU _ rs1 off => [.read (ea s rs1 off) 2]
  | .LB _ rs1 off | .LBU _ rs1 off => [.read (ea s rs1 off) 1]
  | .SD rs1 _ off => [.write (ea s rs1 off) 8]
  | .SW rs1 _ off => [.write (ea s rs1 off) 4]
  | .SH rs1 _ off => [.write (ea s rs1 off) 2]
  | .SB rs1 _ off => [.write (ea s rs1 off) 1]
  | .BEQ rs1 rs2 off => [.jump (target s (s.getReg rs1 == s.getReg rs2) off)]
  | .BNE rs1 rs2 off => [.jump (target s (s.getReg rs1 != s.getReg rs2) off)]
  | .BLT rs1 rs2 off => [.jump (target s ((s.getReg rs1).slt (s.getReg rs2)) off)]
  | .BGE rs1 rs2 off => [.jump (target s (!(s.getReg rs1).slt (s.getReg rs2)) off)]
  | .BLTU rs1 rs2 off => [.jump (target s ((s.getReg rs1).ult (s.getReg rs2)) off)]
  | .BGEU rs1 rs2 off => [.jump (target s (!(s.getReg rs1).ult (s.getReg rs2)) off)]
  | .JALR _ rs1 off => [.jump ((s.getReg rs1 + signExtend12 off) &&& ~~~1#64)]
  | .DIV _ rs1 rs2 | .DIVU _ rs1 rs2 | .REM _ rs1 rs2 | .REMU _ rs1 rs2 =>
    [.operands (s.getReg rs1) (s.getReg rs2)]
  | .ECALL =>
    if s.getReg .x5 = 0x10#64 ∧ s.getReg .x11 ≠ 0#64 then
      [.event (.write (s.readBytes (s.getReg .x10) (s.getReg .x11).toNat))]
    else []
  | _ => []

/-- Whether this file says what the instruction reveals in the state `s`. It does not for
the accelerator instructions of a zkVM (`CSRS`), nor for an `ECALL` other than the write. -/
def covered (s : MachineState) : Instr → Bool
  | .CSRS .. => false
  | .ECALL => s.getReg .x5 == 0x10#64
  | _ => true

/-- A run of the machine from `s` to `s'`, with its trace: the labels of each instruction it
executes, in order, and the exit event where it halts. A run has no step through an
instruction this file does not cover. A machine at the halting `ECALL` takes no step: `halt`
records its exit with the code in `a0` and leaves it where it is. -/
inductive RunL : MachineState → Trace → MachineState → Prop where
  | refl (s : MachineState) : RunL s [] s
  | step {s s₁ s₂ : MachineState} {i : Instr} {tr : Trace} :
      s.code s.pc = some i → covered s i = true → step s = some s₁ → RunL s₁ tr s₂ →
      RunL s (leak s i ++ tr) s₂
  | halt {s s₂ : MachineState} {tr : Trace} :
      s.code s.pc = some .ECALL → s.getReg .x5 = 0#64 → RunL s tr s₂ →
      RunL s (.event (.exit (s.getReg .x10)) :: tr) s₂

/-- The states a machine passes through, running from `s`. -/
def Reachable (s s' : MachineState) : Prop := ∃ tr, RunL s tr s'

end Lowering.RiscV
