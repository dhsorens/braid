/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.Memory.Arm


/-- The instruction words of `swap`, from `0x10000`. -/
def swap_words : List (BitVec 32) := [
  0xf9400028#32, 0xf9400009#32, 0xf9000008#32, 0xf9000029#32, 0xd65f03c0#32]

/-- `swap`, lowered to `braid`. -/
def swap : Braid.Func :=
  { name := "swap", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 0 1, .load 30 .w64 0, .set 8 30], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.get 0 0, .load 30 .w64 0, .set 9 30], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 0 8, .get 1 0, .store .w64 1 0], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.get 0 9, .get 1 1, .store .w64 1 0], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `swap` is the lowering of `swap_words`. -/
theorem swap_lowered :
    swap.blocks = Lowering.Arm.lowerWords 0x10000#64 swap_words := by
  decide

/-- The instruction words of `sum_array`, from `0x10014`. -/
def sum_array_words : List (BitVec 32) := [
  0xaa1f03e8#32, 0xb40000a1#32, 0xf8408409#32, 0xf1000421#32, 0x8b080128#32, 0x54ffffa1#32, 0xaa0803e0#32, 0xd65f03c0#32]

/-- `sum_array`, lowered to `braid`. -/
def sum_array : Braid.Func :=
  { name := "sum_array", entry := 0x10014#64, blocks := [
    (0x10014#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10018#64 }),
    (0x10018#64, { ops := [.get 0 1], term := .branch 0 0x1001c#64 0x1002c#64 }),
    (0x1001c#64, { ops := [.get 0 0, .const 5 0x8#64, .bin 6 .add 0 5, .set 0 6, .load 30 .w64 0, .set 9 30], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 0 1, .const 2 0x1#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 1 3], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 0 9, .get 2 8, .bin 12 .add 0 2, .set 8 12], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x1001c#64 0x1002c#64 }),
    (0x1002c#64, { ops := [.const 0 0x0#64, .get 2 8, .bin 12 .or 0 2, .set 0 12], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `sum_array` is the lowering of `sum_array_words`. -/
theorem sum_array_lowered :
    sum_array.blocks = Lowering.Arm.lowerWords 0x10014#64 sum_array_words := by
  decide

/-- The instruction words of `max2`, from `0x10034`. -/
def max2_words : List (BitVec 32) := [
  0xeb01001f#32, 0x9a818000#32, 0xd65f03c0#32]

/-- `max2`, lowered to `braid`. -/
def max2 : Braid.Func :=
  { name := "max2", entry := 0x10034#64, blocks := [
    (0x10034#64, { ops := [.get 0 0, .get 2 1, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x10038#64 }),
    (0x10038#64, { ops := [.getf 1 2, .getf 2 1, .bin 0 .ult 2 1, .get 5 0, .get 7 1, .select 12 0 5 7, .set 0 12], term := .jump 0x1003c#64 }),
    (0x1003c#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `max2` is the lowering of `max2_words`. -/
theorem max2_lowered :
    max2.blocks = Lowering.Arm.lowerWords 0x10034#64 max2_words := by
  decide

/-- The instruction words of `max3`, from `0x10040`. -/
def max3_words : List (BitVec 32) := [
  0xa9be7bfd#32, 0xf9000bf3#32, 0x910003fd#32, 0xaa0203f3#32, 0x97fffff9#32, 0xaa1303e1#32, 0xf9400bf3#32, 0xa8c27bfd#32, 0x17fffff5#32]

/-- `max3`, lowered to `braid`. -/
def max3 : Braid.Func :=
  { name := "max3", entry := 0x10040#64, blocks := [
    (0x10040#64, { ops := [.get 0 29, .get 1 30, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0xffffffffffffffe0#64, .bin 2 .add 3 8, .set 31 2, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x10044#64 }),
    (0x10044#64, { ops := [.get 0 19, .get 2 31, .const 3 0xf#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .const 7 0x10#64, .bin 1 .add 2 7, .store .w64 1 0], term := .jump 0x10048#64 }),
    (0x10048#64, { ops := [.get 0 31, .const 2 0x0#64, .bin 3 .add 0 2, .set 29 3], term := .jump 0x1004c#64 }),
    (0x1004c#64, { ops := [.const 0 0x0#64, .get 2 2, .bin 12 .or 0 2, .set 19 12], term := .jump 0x10050#64 }),
    (0x10050#64, { ops := [.const 0 0x10054#64, .set 30 0], term := .jump 0x10034#64 }),
    (0x10054#64, { ops := [.const 0 0x0#64, .get 2 19, .bin 12 .or 0 2, .set 1 12], term := .jump 0x10058#64 }),
    (0x10058#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x10#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 19 30], term := .jump 0x1005c#64 }),
    (0x1005c#64, { ops := [.get 0 31, .const 1 0xf#64, .bin 2 .and 0 1, .const 3 0x0#64, .bin 4 .eq 2 3, .guard 4, .const 5 0x20#64, .bin 6 .add 0 5, .set 31 6, .const 21 0x8#64, .bin 22 .add 0 21, .load 23 .w64 0, .load 26 .w64 22, .set 29 23, .set 30 26], term := .jump 0x10060#64 }),
    (0x10060#64, { ops := [], term := .jump 0x10034#64 })] }

/-- `max3` is the lowering of `max3_words`. -/
theorem max3_lowered :
    max3.blocks = Lowering.Arm.lowerWords 0x10040#64 max3_words := by
  decide

end Examples.Memory.Arm
