/-
  Lowering.RiscV.Leak

  What a RISC-V instruction reveals, and the trace of a run of the machine. This is the
  leakage model of `docs/Leakage.md` read on the instructions of `RiscvZkvm.Rv64`: a load or a
  store reveals its address and its size, a conditional branch and `JALR` reveal where they
  go, and a division or a remainder reveals its operands. Every other instruction reveals
  nothing: by the Zkt extension, additions, logic, shifts and multiplications take a time
  that does not depend on their operands.

  This file is trusted: a theorem about what a RISC-V program leaks says so in these terms
  (`docs/Trust.md`). It is definitions only.

  ## Main definitions

  * `leak`: the labels of one instruction, from the state it runs in
  * `RunL`: a run of the machine, with its trace
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
  | _ => []

/-- A run of the machine from `s` to `s'`, with its trace: the labels of each instruction it
executes, in order. -/
inductive RunL : MachineState → Trace → MachineState → Prop where
  | refl (s : MachineState) : RunL s [] s
  | step {s s₁ s₂ : MachineState} {i : Instr} {tr : Trace} :
      s.code s.pc = some i → step s = some s₁ → RunL s₁ tr s₂ → RunL s (leak s i ++ tr) s₂

end Lowering.RiscV
