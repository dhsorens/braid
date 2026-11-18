/-
  Lowering.RiscV.Lower

  The lowering of RV64IM into `braid`: one block for each instruction, at its address. The
  machine model is riscv-zkvm's `RiscvZkvm.Rv64`, which is tied to the Sail RISC-V model.

  Register `xN` is `braid` register `N`. `x0` is never read or written: a read is the
  constant zero and a write is dropped. Environment calls, breakpoints and the accelerator
  instructions are outside the lowering and become a `trap`.

  ## Main definitions

  * `lower`: the block of one instruction
  * `lowerCode`: the program of a code memory
  * `arch`: the names of the registers
-/

module

public import Braid
public import RiscvZkvm.Rv64.Execution

@[expose] public section

namespace Lowering.RiscV

open Braid hiding Reg
open RiscvZkvm.Rv64

/-- How RISC-V registers are named in the textual form. RISC-V has no flags. -/
def arch : Arch where
  name := "riscv64"
  regName r := s!"x{r}"
  flagName f := s!"f{f}"

/-- Read a register into `d`. -/
def rget (d : Var) (r : Reg) : Op :=
  if r = .x0 then .const d 0 else .get d r.toNat

/-- Write a register from `a`. -/
def rset (r : Reg) (a : Var) : List Op :=
  if r = .x0 then [] else [.set r.toNat a]

/-- `rd := rs1 op rs2`. -/
def binRR (pc : Word) (op : BinOp) (rd rs1 rs2 : Reg) : Block :=
  ⟨[rget 0 rs1, rget 1 rs2, .bin 2 op 0 1] ++ rset rd 2, .jump (pc + 4)⟩

/-- `rd := rs1 op imm`. -/
def binRI (pc : Word) (op : BinOp) (rd rs1 : Reg) (imm : Word) : Block :=
  ⟨[rget 0 rs1, .const 1 imm, .bin 2 op 0 1] ++ rset rd 2, .jump (pc + 4)⟩

/-- `rd := rs1 op (rs2 mod 64)`: a shift by a register. -/
def shiftRR (pc : Word) (op : BinOp) (rd rs1 rs2 : Reg) : Block :=
  ⟨[rget 0 rs1, rget 1 rs2, .const 2 63, .bin 3 .and 1 2, .bin 4 op 0 3] ++ rset rd 4,
    .jump (pc + 4)⟩

/-- `rd := sext32 (f (rs1, rs2))` for the operations on the low 32 bits. -/
def binW (pc : Word) (ops : List Op) (res : Var) (rd : Reg) : Block :=
  ⟨ops ++ [.un (res + 1) (.sext 32) res] ++ rset rd (res + 1), .jump (pc + 4)⟩

/-- The address `rs1 + sext(offset)` in value `2`, checked to be aligned to `w`. -/
def addrOps (rs1 : Reg) (offset : BitVec 12) (w : Width) : List Op :=
  [rget 0 rs1, .const 1 (signExtend12 offset), .bin 2 .add 0 1] ++
    match w with
    | .w8 => []
    | _ => [.const 3 (BitVec.ofNat 64 (w.bytes - 1)), .bin 4 .and 2 3, .const 5 0,
            .bin 6 .eq 4 5, .guard 6]

/-- A load of width `w`, sign-extended if `signed`. -/
def loadI (pc : Word) (w : Width) (signed : Bool) (rd rs1 : Reg) (offset : BitVec 12) : Block :=
  ⟨addrOps rs1 offset w ++ [.load 7 w 2] ++
      (if signed then [.un 8 (.sext w.bits) 7] else [.un 8 (.zext w.bits) 7]) ++ rset rd 8,
    .jump (pc + 4)⟩

/-- A store of width `w`. -/
def storeI (pc : Word) (w : Width) (rs1 rs2 : Reg) (offset : BitVec 12) : Block :=
  ⟨addrOps rs1 offset w ++ [rget 7 rs2, .store w 2 7], .jump (pc + 4)⟩

/-- A conditional branch: to `pc + offset` if the comparison is `1` (or `0`, if `neg`). -/
def branchI (pc : Word) (op : BinOp) (neg : Bool) (rs1 rs2 : Reg) (offset : BitVec 13) : Block :=
  let taken := pc + signExtend13 offset
  ⟨[rget 0 rs1, rget 1 rs2, .bin 2 op 0 1],
    if neg then .branch 2 (pc + 4) taken else .branch 2 taken (pc + 4)⟩

/-- A division or remainder: `byZero` if the divisor is zero, and `op` otherwise. -/
def divI (pc : Word) (op : BinOp) (byZero : Option Word) (rd rs1 rs2 : Reg) : Block :=
  ⟨[rget 0 rs1, rget 1 rs2, .bin 2 op 0 1, .const 3 0, .bin 4 .eq 1 3] ++
      (match byZero with
        | some v => [.const 5 v, .select 6 4 5 2]
        | none => [.select 6 4 0 2]) ++
      rset rd 6,
    .jump (pc + 4)⟩

/-- The block of the instruction `i` at address `pc`. -/
def lower (pc : Word) (i : Instr) : Block :=
  match i with
  | .ADD rd rs1 rs2 => binRR pc .add rd rs1 rs2
  | .SUB rd rs1 rs2 => binRR pc .sub rd rs1 rs2
  | .SLL rd rs1 rs2 => shiftRR pc .shl rd rs1 rs2
  | .SRL rd rs1 rs2 => shiftRR pc .lshr rd rs1 rs2
  | .SRA rd rs1 rs2 => shiftRR pc .ashr rd rs1 rs2
  | .AND rd rs1 rs2 => binRR pc .and rd rs1 rs2
  | .OR rd rs1 rs2 => binRR pc .or rd rs1 rs2
  | .XOR rd rs1 rs2 => binRR pc .xor rd rs1 rs2
  | .SLT rd rs1 rs2 => binRR pc .slt rd rs1 rs2
  | .SLTU rd rs1 rs2 => binRR pc .ult rd rs1 rs2
  | .ADDI rd rs1 imm => binRI pc .add rd rs1 (signExtend12 imm)
  | .ANDI rd rs1 imm => binRI pc .and rd rs1 (signExtend12 imm)
  | .ORI rd rs1 imm => binRI pc .or rd rs1 (signExtend12 imm)
  | .XORI rd rs1 imm => binRI pc .xor rd rs1 (signExtend12 imm)
  | .SLTI rd rs1 imm => binRI pc .slt rd rs1 (signExtend12 imm)
  | .SLTIU rd rs1 imm => binRI pc .ult rd rs1 (signExtend12 imm)
  | .SLLI rd rs1 shamt => binRI pc .shl rd rs1 (shamt.zeroExtend 64)
  | .SRLI rd rs1 shamt => binRI pc .lshr rd rs1 (shamt.zeroExtend 64)
  | .SRAI rd rs1 shamt => binRI pc .ashr rd rs1 (shamt.zeroExtend 64)
  | .LUI rd imm =>
    ⟨[.const 0 ((imm.zeroExtend 32 <<< 12 : BitVec 32).signExtend 64)] ++ rset rd 0,
      .jump (pc + 4)⟩
  | .AUIPC rd imm =>
    ⟨[.const 0 (pc + (imm.zeroExtend 32 <<< 12 : BitVec 32).signExtend 64)] ++ rset rd 0,
      .jump (pc + 4)⟩
  | .LD rd rs1 offset => loadI pc .w64 false rd rs1 offset
  | .LW rd rs1 offset => loadI pc .w32 true rd rs1 offset
  | .LWU rd rs1 offset => loadI pc .w32 false rd rs1 offset
  | .LH rd rs1 offset => loadI pc .w16 true rd rs1 offset
  | .LHU rd rs1 offset => loadI pc .w16 false rd rs1 offset
  | .LB rd rs1 offset => loadI pc .w8 true rd rs1 offset
  | .LBU rd rs1 offset => loadI pc .w8 false rd rs1 offset
  | .SD rs1 rs2 offset => storeI pc .w64 rs1 rs2 offset
  | .SW rs1 rs2 offset => storeI pc .w32 rs1 rs2 offset
  | .SH rs1 rs2 offset => storeI pc .w16 rs1 rs2 offset
  | .SB rs1 rs2 offset => storeI pc .w8 rs1 rs2 offset
  | .BEQ rs1 rs2 offset => branchI pc .eq false rs1 rs2 offset
  | .BNE rs1 rs2 offset => branchI pc .ne false rs1 rs2 offset
  | .BLT rs1 rs2 offset => branchI pc .slt false rs1 rs2 offset
  | .BGE rs1 rs2 offset => branchI pc .slt true rs1 rs2 offset
  | .BLTU rs1 rs2 offset => branchI pc .ult false rs1 rs2 offset
  | .BGEU rs1 rs2 offset => branchI pc .ult true rs1 rs2 offset
  | .JAL rd offset =>
    ⟨[.const 0 (pc + 4)] ++ rset rd 0, .jump (pc + signExtend21 offset)⟩
  | .JALR rd rs1 offset =>
    ⟨[rget 0 rs1, .const 1 (signExtend12 offset), .bin 2 .add 0 1, .const 3 (~~~1#64),
        .bin 4 .and 2 3, .const 5 (pc + 4)] ++ rset rd 5,
      .jumpInd 4⟩
  | .MV rd rs => ⟨[rget 0 rs] ++ rset rd 0, .jump (pc + 4)⟩
  | .LI rd imm => ⟨[.const 0 imm] ++ rset rd 0, .jump (pc + 4)⟩
  | .NOP => ⟨[], .jump (pc + 4)⟩
  | .FENCE => ⟨[], .jump (pc + 4)⟩
  | .ADDIW rd rs1 imm =>
    binW pc [rget 0 rs1, .const 1 (signExtend12 imm), .bin 2 .add 0 1] 2 rd
  | .SUBW rd rs1 rs2 => binW pc [rget 0 rs1, rget 1 rs2, .bin 2 .sub 0 1] 2 rd
  | .SRLW rd rs1 rs2 =>
    binW pc [rget 0 rs1, rget 1 rs2, .un 2 (.zext 32) 0, .const 3 31, .bin 4 .and 1 3,
      .bin 5 .lshr 2 4] 5 rd
  | .SLLIW rd rs1 shamt =>
    binW pc [rget 0 rs1, .const 1 (shamt.zeroExtend 64), .bin 2 .shl 0 1] 2 rd
  | .SRLIW rd rs1 shamt =>
    binW pc [rget 0 rs1, .un 1 (.zext 32) 0, .const 2 (shamt.zeroExtend 64), .bin 3 .lshr 1 2]
      3 rd
  | .MUL rd rs1 rs2 => binRR pc .mul rd rs1 rs2
  | .MULH rd rs1 rs2 => binRR pc .mulhs rd rs1 rs2
  | .MULHSU rd rs1 rs2 => binRR pc .mulhsu rd rs1 rs2
  | .MULHU rd rs1 rs2 => binRR pc .mulhu rd rs1 rs2
  | .DIV rd rs1 rs2 => divI pc .sdiv (some (BitVec.allOnes 64)) rd rs1 rs2
  | .DIVU rd rs1 rs2 => divI pc .udiv (some (BitVec.allOnes 64)) rd rs1 rs2
  | .REM rd rs1 rs2 => divI pc .srem none rd rs1 rs2
  | .REMU rd rs1 rs2 => divI pc .urem none rd rs1 rs2
  | .ECALL => ⟨[], .trap "ecall"⟩
  | .EBREAK => ⟨[], .trap "ebreak"⟩
  | .CSRS _ _ => ⟨[], .trap "csrs"⟩

/-- The program of a code memory: the block of the instruction at each address. -/
def lowerCode (code : Word → Option Instr) : Program :=
  fun a => (code a).map (lower a)

end Lowering.RiscV
