/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.RiscV.Sound

@[expose] public section

namespace Examples.Bytes.RiscV

open RiscvZkvm.Rv64

/-- The instructions of `str_len`, by address. -/
def str_len_code : List (BitVec 64 × Instr) := [
  (0x10000#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x0) 0x000#12),
  (0x10004#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11)),
  (0x10008#64, RiscvZkvm.Rv64.Instr.LBU (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x12) 0x000#12),
  (0x1000c#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x11) 0x001#12),
  (0x10010#64, RiscvZkvm.Rv64.Instr.BNE (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x0) 0x1ff4#13),
  (0x10014#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11) 0xfff#12),
  (0x10018#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `str_len`, lowered to `braid`. -/
def str_len : Braid.Func :=
  { name := "str_len", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.const 0 0x0#64, .const 1 0x0#64, .bin 2 .add 0 1, .set 11 2], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.get 0 10, .get 1 11, .bin 2 .add 0 1, .set 12 2], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 0 12, .const 1 0x0#64, .bin 2 .add 0 1, .load 7 .w8 2, .un 8 (.zext 8) 7, .set 12 8], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.get 0 11, .const 1 0x1#64, .bin 2 .add 0 1, .set 11 2], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.get 0 12, .const 1 0x0#64, .bin 2 .ne 0 1], term := .branch 2 0x10004#64 0x10014#64 }),
    (0x10014#64, { ops := [.get 0 11, .const 1 0xffffffffffffffff#64, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10018#64 }),
    (0x10018#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x1001c#64], term := .jumpInd 4 })] }

/-- `str_len` is the lowering of `str_len_code`. -/
theorem str_len_lowered :
    str_len.blocks = str_len_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

/-- The instructions of `fill`, by address. -/
def fill_code : List (BitVec 64 × Instr) := [
  (0x1001c#64, RiscvZkvm.Rv64.Instr.BEQ (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x0) 0x0014#13),
  (0x10020#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11)),
  (0x10024#64, RiscvZkvm.Rv64.Instr.SB (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x12) 0x000#12),
  (0x10028#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x10) 0x001#12),
  (0x1002c#64, RiscvZkvm.Rv64.Instr.BNE (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11) 0x1ff8#13),
  (0x10030#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `fill`, lowered to `braid`. -/
def fill : Braid.Func :=
  { name := "fill", entry := 0x1001c#64, blocks := [
    (0x1001c#64, { ops := [.get 0 11, .const 1 0x0#64, .bin 2 .eq 0 1], term := .branch 2 0x10030#64 0x10020#64 }),
    (0x10020#64, { ops := [.get 0 10, .get 1 11, .bin 2 .add 0 1, .set 11 2], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 0 10, .const 1 0x0#64, .bin 2 .add 0 1, .get 7 12, .store .w8 2 7], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 10, .const 1 0x1#64, .bin 2 .add 0 1, .set 10 2], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 0 10, .get 1 11, .bin 2 .ne 0 1], term := .branch 2 0x10024#64 0x10030#64 }),
    (0x10030#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x10034#64], term := .jumpInd 4 })] }

/-- `fill` is the lowering of `fill_code`. -/
theorem fill_lowered :
    fill.blocks = fill_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

/-- The instructions of `count_ones`, by address. -/
def count_ones_code : List (BitVec 64 × Instr) := [
  (0x10034#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x0) 0x000#12),
  (0x10038#64, RiscvZkvm.Rv64.Instr.BEQ (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x0) 0x0014#13),
  (0x1003c#64, RiscvZkvm.Rv64.Instr.ANDI (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x10) 0x001#12),
  (0x10040#64, RiscvZkvm.Rv64.Instr.SRLI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x10) 0x01#6),
  (0x10044#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x12)),
  (0x10048#64, RiscvZkvm.Rv64.Instr.BNE (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x0) 0x1ff4#13),
  (0x1004c#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11) 0x000#12),
  (0x10050#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `count_ones`, lowered to `braid`. -/
def count_ones : Braid.Func :=
  { name := "count_ones", entry := 0x10034#64, blocks := [
    (0x10034#64, { ops := [.const 0 0x0#64, .const 1 0x0#64, .bin 2 .add 0 1, .set 11 2], term := .jump 0x10038#64 }),
    (0x10038#64, { ops := [.get 0 10, .const 1 0x0#64, .bin 2 .eq 0 1], term := .branch 2 0x1004c#64 0x1003c#64 }),
    (0x1003c#64, { ops := [.get 0 10, .const 1 0x1#64, .bin 2 .and 0 1, .set 12 2], term := .jump 0x10040#64 }),
    (0x10040#64, { ops := [.get 0 10, .const 1 0x1#64, .bin 2 .lshr 0 1, .set 10 2], term := .jump 0x10044#64 }),
    (0x10044#64, { ops := [.get 0 11, .get 1 12, .bin 2 .add 0 1, .set 11 2], term := .jump 0x10048#64 }),
    (0x10048#64, { ops := [.get 0 10, .const 1 0x0#64, .bin 2 .ne 0 1], term := .branch 2 0x1003c#64 0x1004c#64 }),
    (0x1004c#64, { ops := [.get 0 11, .const 1 0x0#64, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10050#64 }),
    (0x10050#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x10054#64], term := .jumpInd 4 })] }

/-- `count_ones` is the lowering of `count_ones_code`. -/
theorem count_ones_lowered :
    count_ones.blocks = count_ones_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

end Examples.Bytes.RiscV
