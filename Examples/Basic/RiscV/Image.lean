/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.RiscV.Sound

@[expose] public section

namespace Examples.Basic.RiscV

open RiscvZkvm.Rv64

/-- The instructions of `add3`, by address. -/
def add3_code : List (BitVec 64 × Instr) := [
  (0x10000#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x10)),
  (0x10004#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x12)),
  (0x10008#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `add3`, lowered to `braid`. -/
def add3 : Braid.Func :=
  { name := "add3", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 0 11, .get 1 10, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.get 0 10, .get 1 12, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x1000c#64], term := .jumpInd 4 })] }

/-- `add3` is the lowering of `add3_code`. -/
theorem add3_lowered :
    add3.blocks = add3_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

/-- The instructions of `max_u64`, by address. -/
def max_u64_code : List (BitVec 64 × Instr) := [
  (0x1000c#64, RiscvZkvm.Rv64.Instr.BLTU (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x10) 0x0008#13),
  (0x10010#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11) 0x000#12),
  (0x10014#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `max_u64`, lowered to `braid`. -/
def max_u64 : Braid.Func :=
  { name := "max_u64", entry := 0x1000c#64, blocks := [
    (0x1000c#64, { ops := [.get 0 11, .get 1 10, .bin 2 .ult 0 1], term := .branch 2 0x10014#64 0x10010#64 }),
    (0x10010#64, { ops := [.get 0 11, .const 1 0x0#64, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10014#64 }),
    (0x10014#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x10018#64], term := .jumpInd 4 })] }

/-- `max_u64` is the lowering of `max_u64_code`. -/
theorem max_u64_lowered :
    max_u64.blocks = max_u64_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

/-- The instructions of `sum_to`, by address. -/
def sum_to_code : List (BitVec 64 × Instr) := [
  (0x10018#64, RiscvZkvm.Rv64.Instr.BEQ (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x0) 0x002c#13),
  (0x1001c#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x10) 0xfff#12),
  (0x10020#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x10) 0xffe#12),
  (0x10024#64, RiscvZkvm.Rv64.Instr.MUL (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x12)),
  (0x10028#64, RiscvZkvm.Rv64.Instr.MULHU (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x12)),
  (0x1002c#64, RiscvZkvm.Rv64.Instr.MUL (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x11)),
  (0x10030#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11)),
  (0x10034#64, RiscvZkvm.Rv64.Instr.SLLI (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x12) 0x3f#6),
  (0x10038#64, RiscvZkvm.Rv64.Instr.SRLI (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x13) 0x01#6),
  (0x1003c#64, RiscvZkvm.Rv64.Instr.OR (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x12)),
  (0x10040#64, RiscvZkvm.Rv64.Instr.SUB (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x12)),
  (0x10044#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `sum_to`, lowered to `braid`. -/
def sum_to : Braid.Func :=
  { name := "sum_to", entry := 0x10018#64, blocks := [
    (0x10018#64, { ops := [.get 0 10, .const 1 0x0#64, .bin 2 .eq 0 1], term := .branch 2 0x10044#64 0x1001c#64 }),
    (0x1001c#64, { ops := [.get 0 10, .const 1 0xffffffffffffffff#64, .bin 2 .add 0 1, .set 11 2], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 0 10, .const 1 0xfffffffffffffffe#64, .bin 2 .add 0 1, .set 12 2], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 0 11, .get 1 12, .bin 2 .mul 0 1, .set 13 2], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 11, .get 1 12, .bin 2 .mulhu 0 1, .set 12 2], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 0 11, .get 1 11, .bin 2 .mul 0 1, .set 11 2], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.get 0 10, .get 1 11, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10034#64 }),
    (0x10034#64, { ops := [.get 0 12, .const 1 0x3f#64, .bin 2 .shl 0 1, .set 12 2], term := .jump 0x10038#64 }),
    (0x10038#64, { ops := [.get 0 13, .const 1 0x1#64, .bin 2 .lshr 0 1, .set 13 2], term := .jump 0x1003c#64 }),
    (0x1003c#64, { ops := [.get 0 13, .get 1 12, .bin 2 .or 0 1, .set 12 2], term := .jump 0x10040#64 }),
    (0x10040#64, { ops := [.get 0 10, .get 1 12, .bin 2 .sub 0 1, .set 10 2], term := .jump 0x10044#64 }),
    (0x10044#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x10048#64], term := .jumpInd 4 })] }

/-- `sum_to` is the lowering of `sum_to_code`. -/
theorem sum_to_lowered :
    sum_to.blocks = sum_to_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

end Examples.Basic.RiscV
