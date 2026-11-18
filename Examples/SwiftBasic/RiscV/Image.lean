/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.RiscV.Sound

@[expose] public section

namespace Examples.SwiftBasic.RiscV

open RiscvZkvm.Rv64

/-- The instructions of `swift_add3`, by address. -/
def swift_add3_code : List (BitVec 64 × Instr) := [
  (0x10000#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x10)),
  (0x10004#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x12)),
  (0x10008#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `swift_add3`, lowered to `braid`. -/
def swift_add3 : Braid.Func :=
  { name := "swift_add3", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 0 11, .get 1 10, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.get 0 10, .get 1 12, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x1000c#64], term := .jumpInd 4 })] }

/-- `swift_add3` is the lowering of `swift_add3_code`. -/
theorem swift_add3_lowered :
    swift_add3.blocks = swift_add3_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

/-- The instructions of `swift_gcd`, by address. -/
def swift_gcd_code : List (BitVec 64 × Instr) := [
  (0x10018#64, RiscvZkvm.Rv64.Instr.BEQ (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x0) 0x0018#13),
  (0x1001c#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x11) 0x000#12),
  (0x10020#64, RiscvZkvm.Rv64.Instr.REMU (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11)),
  (0x10024#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x12) 0x000#12),
  (0x10028#64, RiscvZkvm.Rv64.Instr.BNE (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x0) 0x1ff4#13),
  (0x1002c#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x12) 0x000#12),
  (0x10030#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `swift_gcd`, lowered to `braid`. -/
def swift_gcd : Braid.Func :=
  { name := "swift_gcd", entry := 0x10018#64, blocks := [
    (0x10018#64, { ops := [.get 0 11, .const 1 0x0#64, .bin 2 .eq 0 1], term := .branch 2 0x10030#64 0x1001c#64 }),
    (0x1001c#64, { ops := [.get 0 11, .const 1 0x0#64, .bin 2 .add 0 1, .set 12 2], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 0 10, .get 1 11, .bin 2 .urem 0 1, .const 3 0x0#64, .bin 4 .eq 1 3, .select 6 4 0 2, .set 11 6], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 0 12, .const 1 0x0#64, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 11, .const 1 0x0#64, .bin 2 .ne 0 1], term := .branch 2 0x1001c#64 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 0 12, .const 1 0x0#64, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x10034#64], term := .jumpInd 4 })] }

/-- `swift_gcd` is the lowering of `swift_gcd_code`. -/
theorem swift_gcd_lowered :
    swift_gcd.blocks = swift_gcd_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

/-- The instructions of `swift_min`, by address. -/
def swift_min_code : List (BitVec 64 × Instr) := [
  (0x10050#64, RiscvZkvm.Rv64.Instr.BLTU (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11) 0x0008#13),
  (0x10054#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11) 0x000#12),
  (0x10058#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `swift_min`, lowered to `braid`. -/
def swift_min : Braid.Func :=
  { name := "swift_min", entry := 0x10050#64, blocks := [
    (0x10050#64, { ops := [.get 0 10, .get 1 11, .bin 2 .ult 0 1], term := .branch 2 0x10058#64 0x10054#64 }),
    (0x10054#64, { ops := [.get 0 11, .const 1 0x0#64, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10058#64 }),
    (0x10058#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x1005c#64], term := .jumpInd 4 })] }

/-- `swift_min` is the lowering of `swift_min_code`. -/
theorem swift_min_lowered :
    swift_min.blocks = swift_min_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

end Examples.SwiftBasic.RiscV
