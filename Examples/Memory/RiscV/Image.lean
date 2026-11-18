/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.RiscV.Sound

@[expose] public section

namespace Examples.Memory.RiscV

open RiscvZkvm.Rv64

/-- The instructions of `swap`, by address. -/
def swap_code : List (BitVec 64 × Instr) := [
  (0x10000#64, RiscvZkvm.Rv64.Instr.LD (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x11) 0x000#12),
  (0x10004#64, RiscvZkvm.Rv64.Instr.LD (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x10) 0x000#12),
  (0x10008#64, RiscvZkvm.Rv64.Instr.SD (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x12) 0x000#12),
  (0x1000c#64, RiscvZkvm.Rv64.Instr.SD (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x13) 0x000#12),
  (0x10010#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `swap`, lowered to `braid`. -/
def swap : Braid.Func :=
  { name := "swap", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 0 11, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0x7#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .load 7 .w64 2, .un 8 (.zext 64) 7, .set 12 8], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.get 0 10, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0x7#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .load 7 .w64 2, .un 8 (.zext 64) 7, .set 13 8], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 0 10, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0x7#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .get 7 12, .store .w64 2 7], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.get 0 11, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0x7#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .get 7 13, .store .w64 2 7], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x10014#64], term := .jumpInd 4 })] }

/-- `swap` is the lowering of `swap_code`. -/
theorem swap_lowered :
    swap.blocks = swap_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

/-- The instructions of `sum_array`, by address. -/
def sum_array_code : List (BitVec 64 × Instr) := [
  (0x10014#64, RiscvZkvm.Rv64.Instr.BEQ (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x0) 0x0028#13),
  (0x10018#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x10) 0x000#12),
  (0x1001c#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x0) 0x000#12),
  (0x10020#64, RiscvZkvm.Rv64.Instr.SLLI (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x11) 0x03#6),
  (0x10024#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x11)),
  (0x10028#64, RiscvZkvm.Rv64.Instr.LD (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x12) 0x000#12),
  (0x1002c#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x12) 0x008#12),
  (0x10030#64, RiscvZkvm.Rv64.Instr.ADD (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x13) (RiscvZkvm.Rv64.Reg.x10)),
  (0x10034#64, RiscvZkvm.Rv64.Instr.BNE (RiscvZkvm.Rv64.Reg.x12) (RiscvZkvm.Rv64.Reg.x11) 0x1ff4#13),
  (0x10038#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12),
  (0x1003c#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x0) 0x000#12),
  (0x10040#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `sum_array`, lowered to `braid`. -/
def sum_array : Braid.Func :=
  { name := "sum_array", entry := 0x10014#64, blocks := [
    (0x10014#64, { ops := [.get 0 11, .const 1 0x0#64, .bin 2 .eq 0 1], term := .branch 2 0x1003c#64 0x10018#64 }),
    (0x10018#64, { ops := [.get 0 10, .const 1 0x0#64, .bin 2 .add 0 1, .set 12 2], term := .jump 0x1001c#64 }),
    (0x1001c#64, { ops := [.const 0 0x0#64, .const 1 0x0#64, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 0 11, .const 1 0x3#64, .bin 2 .shl 0 1, .set 11 2], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 0 12, .get 1 11, .bin 2 .add 0 1, .set 11 2], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 12, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0x7#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .load 7 .w64 2, .un 8 (.zext 64) 7, .set 13 8], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 0 12, .const 1 0x8#64, .bin 2 .add 0 1, .set 12 2], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.get 0 13, .get 1 10, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10034#64 }),
    (0x10034#64, { ops := [.get 0 12, .get 1 11, .bin 2 .ne 0 1], term := .branch 2 0x10028#64 0x10038#64 }),
    (0x10038#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x1003c#64], term := .jumpInd 4 }),
    (0x1003c#64, { ops := [.const 0 0x0#64, .const 1 0x0#64, .bin 2 .add 0 1, .set 10 2], term := .jump 0x10040#64 }),
    (0x10040#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x10044#64], term := .jumpInd 4 })] }

/-- `sum_array` is the lowering of `sum_array_code`. -/
theorem sum_array_lowered :
    sum_array.blocks = sum_array_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

/-- The instructions of `max2`, by address. -/
def max2_code : List (BitVec 64 × Instr) := [
  (0x10044#64, RiscvZkvm.Rv64.Instr.BLTU (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x10) 0x0008#13),
  (0x10048#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x10) (RiscvZkvm.Rv64.Reg.x11) 0x000#12),
  (0x1004c#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x1) 0x000#12)]

/-- `max2`, lowered to `braid`. -/
def max2 : Braid.Func :=
  { name := "max2", entry := 0x10044#64, blocks := [
    (0x10044#64, { ops := [.get 0 11, .get 1 10, .bin 2 .ult 0 1], term := .branch 2 0x1004c#64 0x10048#64 }),
    (0x10048#64, { ops := [.get 0 11, .const 1 0x0#64, .bin 2 .add 0 1, .set 10 2], term := .jump 0x1004c#64 }),
    (0x1004c#64, { ops := [.get 0 1, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x10050#64], term := .jumpInd 4 })] }

/-- `max2` is the lowering of `max2_code`. -/
theorem max2_lowered :
    max2.blocks = max2_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

/-- The instructions of `max3`, by address. -/
def max3_code : List (BitVec 64 × Instr) := [
  (0x10050#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x2) (RiscvZkvm.Rv64.Reg.x2) 0xff0#12),
  (0x10054#64, RiscvZkvm.Rv64.Instr.SD (RiscvZkvm.Rv64.Reg.x2) (RiscvZkvm.Rv64.Reg.x1) 0x008#12),
  (0x10058#64, RiscvZkvm.Rv64.Instr.SD (RiscvZkvm.Rv64.Reg.x2) (RiscvZkvm.Rv64.Reg.x8) 0x000#12),
  (0x1005c#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x8) (RiscvZkvm.Rv64.Reg.x12) 0x000#12),
  (0x10060#64, RiscvZkvm.Rv64.Instr.AUIPC (RiscvZkvm.Rv64.Reg.x1) 0x00000#20),
  (0x10064#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x1) (RiscvZkvm.Rv64.Reg.x1) 0xfe4#12),
  (0x10068#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x11) (RiscvZkvm.Rv64.Reg.x8) 0x000#12),
  (0x1006c#64, RiscvZkvm.Rv64.Instr.LD (RiscvZkvm.Rv64.Reg.x1) (RiscvZkvm.Rv64.Reg.x2) 0x008#12),
  (0x10070#64, RiscvZkvm.Rv64.Instr.LD (RiscvZkvm.Rv64.Reg.x8) (RiscvZkvm.Rv64.Reg.x2) 0x000#12),
  (0x10074#64, RiscvZkvm.Rv64.Instr.ADDI (RiscvZkvm.Rv64.Reg.x2) (RiscvZkvm.Rv64.Reg.x2) 0x010#12),
  (0x10078#64, RiscvZkvm.Rv64.Instr.AUIPC (RiscvZkvm.Rv64.Reg.x6) 0x00000#20),
  (0x1007c#64, RiscvZkvm.Rv64.Instr.JALR (RiscvZkvm.Rv64.Reg.x0) (RiscvZkvm.Rv64.Reg.x6) 0xfcc#12)]

/-- `max3`, lowered to `braid`. -/
def max3 : Braid.Func :=
  { name := "max3", entry := 0x10050#64, blocks := [
    (0x10050#64, { ops := [.get 0 2, .const 1 0xfffffffffffffff0#64, .bin 2 .add 0 1, .set 2 2], term := .jump 0x10054#64 }),
    (0x10054#64, { ops := [.get 0 2, .const 1 0x8#64, .bin 2 .add 0 1, .const 3 0x7#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .get 7 1, .store .w64 2 7], term := .jump 0x10058#64 }),
    (0x10058#64, { ops := [.get 0 2, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0x7#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .get 7 8, .store .w64 2 7], term := .jump 0x1005c#64 }),
    (0x1005c#64, { ops := [.get 0 12, .const 1 0x0#64, .bin 2 .add 0 1, .set 8 2], term := .jump 0x10060#64 }),
    (0x10060#64, { ops := [.const 0 0x10060#64, .set 1 0], term := .jump 0x10064#64 }),
    (0x10064#64, { ops := [.get 0 1, .const 1 0xffffffffffffffe4#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x10068#64, .set 1 5], term := .jumpInd 4 }),
    (0x10068#64, { ops := [.get 0 8, .const 1 0x0#64, .bin 2 .add 0 1, .set 11 2], term := .jump 0x1006c#64 }),
    (0x1006c#64, { ops := [.get 0 2, .const 1 0x8#64, .bin 2 .add 0 1, .const 3 0x7#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .load 7 .w64 2, .un 8 (.zext 64) 7, .set 1 8], term := .jump 0x10070#64 }),
    (0x10070#64, { ops := [.get 0 2, .const 1 0x0#64, .bin 2 .add 0 1, .const 3 0x7#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .load 7 .w64 2, .un 8 (.zext 64) 7, .set 8 8], term := .jump 0x10074#64 }),
    (0x10074#64, { ops := [.get 0 2, .const 1 0x10#64, .bin 2 .add 0 1, .set 2 2], term := .jump 0x10078#64 }),
    (0x10078#64, { ops := [.const 0 0x10078#64, .set 6 0], term := .jump 0x1007c#64 }),
    (0x1007c#64, { ops := [.get 0 6, .const 1 0xffffffffffffffcc#64, .bin 2 .add 0 1, .const 3 0xfffffffffffffffe#64, .bin 4 .and 2 3, .const 5 0x10080#64], term := .jumpInd 4 })] }

/-- `max3` is the lowering of `max3_code`. -/
theorem max3_lowered :
    max3.blocks = max3_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by
  decide

end Examples.Memory.RiscV
