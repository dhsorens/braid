/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.RustBasic.Arm


/-- The instruction words of `add3`, from `0x10004`. -/
def add3_words : List (BitVec 32) := [
  0x8b000028#32, 0x8b020100#32, 0xd65f03c0#32]

/-- `add3`, lowered to `braid`. -/
def add3 : Braid.Func :=
  { name := "add3", entry := 0x10004#64, blocks := [
    (0x10004#64, { ops := [.get 0 1, .get 2 0, .bin 12 .add 0 2, .set 8 12], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 0 8, .get 2 2, .bin 12 .add 0 2, .set 0 12], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `add3` is the lowering of `add3_words`. -/
theorem add3_lowered :
    add3.blocks = Lowering.Arm.lowerWords 0x10004#64 add3_words := by
  decide

/-- The instruction words of `max_u64`, from `0x1002c`. -/
def max_u64_words : List (BitVec 32) := [
  0xeb01001f#32, 0x9a818000#32, 0xd65f03c0#32]

/-- `max_u64`, lowered to `braid`. -/
def max_u64 : Braid.Func :=
  { name := "max_u64", entry := 0x1002c#64, blocks := [
    (0x1002c#64, { ops := [.get 0 0, .get 2 1, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.getf 1 2, .getf 2 1, .bin 0 .ult 2 1, .get 5 0, .get 7 1, .select 12 0 5 7, .set 0 12], term := .jump 0x10034#64 }),
    (0x10034#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `max_u64` is the lowering of `max_u64_words`. -/
theorem max_u64_lowered :
    max_u64.blocks = Lowering.Arm.lowerWords 0x1002c#64 max_u64_words := by
  decide

/-- The instruction words of `gcd`, from `0x10010`. -/
def gcd_words : List (BitVec 32) := [
  0xb40000c1#32, 0x9ac10808#32, 0x9b018108#32, 0xaa0103e0#32, 0xaa0803e1#32, 0xb5ffff88#32, 0xd65f03c0#32]

/-- `gcd`, lowered to `braid`. -/
def gcd : Braid.Func :=
  { name := "gcd", entry := 0x10010#64, blocks := [
    (0x10010#64, { ops := [.get 0 1], term := .branch 0 0x10014#64 0x10028#64 }),
    (0x10014#64, { ops := [.get 0 0, .get 1 1, .bin 9 .udiv 0 1, .set 8 9], term := .jump 0x10018#64 }),
    (0x10018#64, { ops := [.get 0 8, .get 1 1, .get 2 0, .bin 3 .mul 0 1, .bin 9 .sub 2 3, .set 8 9], term := .jump 0x1001c#64 }),
    (0x1001c#64, { ops := [.const 0 0x0#64, .get 2 1, .bin 12 .or 0 2, .set 0 12], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.const 0 0x0#64, .get 2 8, .bin 12 .or 0 2, .set 1 12], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 0 8], term := .branch 0 0x10014#64 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `gcd` is the lowering of `gcd_words`. -/
theorem gcd_lowered :
    gcd.blocks = Lowering.Arm.lowerWords 0x10010#64 gcd_words := by
  decide

/-- The instruction words of `sum_slice`, from `0x10038`. -/
def sum_slice_words : List (BitVec 32) := [
  0xb4000121#32, 0xd37df029#32, 0xaa1f03e8#32, 0xf840840a#32, 0xf1002129#32, 0x8b080148#32, 0x54ffffa1#32, 0xaa0803e0#32, 0xd65f03c0#32, 0xaa1f03e8#32, 0xaa0803e0#32, 0xd65f03c0#32]

/-- `sum_slice`, lowered to `braid`. -/
def sum_slice : Braid.Func :=
  { name := "sum_slice", entry := 0x10038#64, blocks := [
    (0x10038#64, { ops := [.get 0 1], term := .branch 0 0x1003c#64 0x1005c#64 }),
    (0x1003c#64, { ops := [.get 0 1, .const 3 0x3#64, .bin 20 .shl 0 3, .set 9 20], term := .jump 0x10040#64 }),
    (0x10040#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10044#64 }),
    (0x10044#64, { ops := [.get 0 0, .const 5 0x8#64, .bin 6 .add 0 5, .set 0 6, .load 30 .w64 0, .set 10 30], term := .jump 0x10048#64 }),
    (0x10048#64, { ops := [.get 0 9, .const 2 0x8#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 9 3], term := .jump 0x1004c#64 }),
    (0x1004c#64, { ops := [.get 0 10, .get 2 8, .bin 12 .add 0 2, .set 8 12], term := .jump 0x10050#64 }),
    (0x10050#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10044#64 0x10054#64 }),
    (0x10054#64, { ops := [.const 0 0x0#64, .get 2 8, .bin 12 .or 0 2, .set 0 12], term := .jump 0x10058#64 }),
    (0x10058#64, { ops := [.get 0 30], term := .jumpInd 0 }),
    (0x1005c#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10060#64 }),
    (0x10060#64, { ops := [.const 0 0x0#64, .get 2 8, .bin 12 .or 0 2, .set 0 12], term := .jump 0x10064#64 }),
    (0x10064#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `sum_slice` is the lowering of `sum_slice_words`. -/
theorem sum_slice_lowered :
    sum_slice.blocks = Lowering.Arm.lowerWords 0x10038#64 sum_slice_words := by
  decide

end Examples.RustBasic.Arm
