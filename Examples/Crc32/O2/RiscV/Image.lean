/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.RiscV.Sound

@[expose] public section

namespace Examples.Crc32.O2.RiscV

open RiscvZkvm.Rv64

/-- The instructions of `crc32`, by address. -/
def crc32_code : List (BitVec 64 × Instr) := [
  (0x10000#64, RiscvZkvm.Rv64.Instr.BEQ (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x0) 0x0058#13),
  (0x10004#64, RiscvZkvm.Rv64.Instr.XORI (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x10) 0xfff#12),
  (0x10008#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x12)),
  (0x1000c#64, RiscvZkvm.Rv64.Instr.LUI (RiscvZkvm.Rv64.Reg.x10) 0x00010#20),
  (0x10010#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x10) 0x05c#12),
  (0x10014#64, RiscvZkvm.Rv64.Instr.LBU (RiscvZkvm.Rv64.Reg.x14) (RiscvZkvm.Rv64.Reg.x11) 0x000#12),
  (0x10018#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x11) 0x001#12),
  (0x1001c#64, RiscvZkvm.Rv64.Instr.XOR (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x14)),
  (0x10020#64, RiscvZkvm.Rv64.Instr.ANDI (RiscvZkvm.Rv64.Reg.x14) (RiscvZkvm.Rv64.Reg.x13) 0x00f#12),
  (0x10024#64, RiscvZkvm.Rv64.Instr.SLLI (RiscvZkvm.Rv64.Reg.x14) (RiscvZkvm.Rv64.Reg.x14) 0x02#6),
  (0x10028#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x14) (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x14)),
  (0x1002c#64, RiscvZkvm.Rv64.Instr.LW (RiscvZkvm.Rv64.Reg.x14) (RiscvZkvm.Rv64.Reg.x14) 0x000#12),
  (0x10030#64, RiscvZkvm.Rv64.Instr.SRLIW (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x13) 0x04#5),
  (0x10034#64, RiscvZkvm.Rv64.Instr.XOR (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x14)),
  (0x10038#64, RiscvZkvm.Rv64.Instr.ANDI (RiscvZkvm.Rv64.Reg.x14) (RiscvZkvm.Rv64.Reg.x13) 0x00f#12),
  (0x1003c#64, RiscvZkvm.Rv64.Instr.SLLI (RiscvZkvm.Rv64.Reg.x14) (RiscvZkvm.Rv64.Reg.x14) 0x02#6),
  (0x10040#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x14) (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x14)),
  (0x10044#64, RiscvZkvm.Rv64.Instr.LW (RiscvZkvm.Rv64.Reg.x14) (RiscvZkvm.Rv64.Reg.x14) 0x000#12),
  (0x10048#64, RiscvZkvm.Rv64.Instr.SRLIW (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x13) 0x04#5),
  (0x1004c#64, RiscvZkvm.Rv64.Instr.XOR (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x14)),
  (0x10050#64, RiscvZkvm.Rv64.Instr.BNE (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x12) 0x1fc4#13),
  (0x10054#64, RiscvZkvm.Rv64.Instr.XORI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x13) 0xfff#12),
  (0x10058#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `crc32`, lowered to `braid`. -/
def crc32 : Braid.Func :=
  { name := "crc32", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 0 12, .const 1 0x0#64, .bin 2 .eq 0 1], term := .branch 2 0x10058#64 0x10004#64 }),
    (0x10004#64, { ops := [.get 0 10, .const 1 0xffffffffffffffff#64, .bin 2 .xor 0 1, .set 13 2], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 0 11, .get 1 12, .bin 2 .add 0 1, .set 12 2], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.const 0 0x10000#64, .set 10 0], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.get 0 10, .const 1 0x5c#64, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10014#64 }),
    (0x10014#64, { ops := [.get 0 11, .const 1 0x0#64, .bin 2 .add 0 1, .load 7 .w8 2, .un 8 (.zext 8) 7, .set 14 8], term := .jump 0x10018#64 }),
    (0x10018#64, { ops := [.get 0 11, .const 1 0x1#64, .bin 2 .add 0 1, .set 11 2], term := .jump 0x1001c#64 }),
    (0x1001c#64, { ops := [.get 0 13, .get 1 14, .bin 2 .xor 0 1, .set 13 2], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 0 13, .const 1 0xf#64, .bin 2 .and 0 1, .set 14 2], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 0 14, .const 1 0x2#64, .bin 2 .shl 0 1, .set 14 2], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 10, .get 1 14, .bin 2 .add 0 1, .set 14 2], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 0 14, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0x3#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .load 7 .w32 2, .un 8 (.sext 32) 7, .set 14 8], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.get 0 13, .un 1 (.zext 32) 0, .const 2 0x4#64, .bin 3 .lshr 1 2, .un 4 (.sext 32) 3, .set 13 4], term := .jump 0x10034#64 }),
    (0x10034#64, { ops := [.get 0 13, .get 1 14, .bin 2 .xor 0 1, .set 13 2], term := .jump 0x10038#64 }),
    (0x10038#64, { ops := [.get 0 13, .const 1 0xf#64, .bin 2 .and 0 1, .set 14 2], term := .jump 0x1003c#64 }),
    (0x1003c#64, { ops := [.get 0 14, .const 1 0x2#64, .bin 2 .shl 0 1, .set 14 2], term := .jump 0x10040#64 }),
    (0x10040#64, { ops := [.get 0 10, .get 1 14, .bin 2 .add 0 1, .set 14 2], term := .jump 0x10044#64 }),
    (0x10044#64, { ops := [.get 0 14, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0x3#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .load 7 .w32 2, .un 8 (.sext 32) 7, .set 14 8], term := .jump 0x10048#64 }),
    (0x10048#64, { ops := [.get 0 13, .un 1 (.zext 32) 0, .const 2 0x4#64, .bin 3 .lshr 1 2, .un 4 (.sext 32) 3, .set 13 4], term := .jump 0x1004c#64 }),
    (0x1004c#64, { ops := [.get 0 13, .get 1 14, .bin 2 .xor 0 1, .set 13 2], term := .jump 0x10050#64 }),
    (0x10050#64, { ops := [.get 0 11, .get 1 12, .bin 2 .ne 0 1], term := .branch 2 0x10014#64 0x10054#64 }),
    (0x10054#64, { ops := [.get 0 13, .const 1 0xffffffffffffffff#64, .bin 2 .xor 0 1, .set 10 2], term := .jump 0x10058#64 }),
    (0x10058#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x1005c#64], term := .jumpInd 4 })] }

/-- `crc32` is the lowering of `crc32_code`. -/
theorem crc32_lowered :
    crc32.blocks = crc32_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

end Examples.Crc32.O2.RiscV
