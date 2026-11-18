/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.Bytes.Arm


/-- The instruction words of `str_len`, from `0x10000`. -/
def str_len_words : List (BitVec 32) := [
  0xaa1f03e8#32, 0x38686809#32, 0x91000508#32, 0x35ffffc9#32, 0xd1000500#32, 0xd65f03c0#32]

/-- `str_len`, lowered to `braid`. -/
def str_len : Braid.Func :=
  { name := "str_len", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.get 1 0, .get 6 8, .bin 0 .add 1 6, .load 30 .w8 0, .set 9 30], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 0 8, .const 2 0x1#64, .bin 3 .add 0 2, .set 8 3], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.get 1 9, .un 0 (.zext 32) 1], term := .branch 0 0x10004#64 0x10010#64 }),
    (0x10010#64, { ops := [.get 0 8, .const 2 0x1#64, .bin 3 .sub 0 2, .set 0 3], term := .jump 0x10014#64 }),
    (0x10014#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `str_len` is the lowering of `str_len_words`. -/
theorem str_len_lowered :
    str_len.blocks = Lowering.Arm.lowerWords 0x10000#64 str_len_words := by
  decide

/-- The instruction words of `fill`, from `0x10018`. -/
def fill_words : List (BitVec 32) := [
  0xb4000081#32, 0xf1000421#32, 0x38001402#32, 0x54ffffc1#32, 0xd65f03c0#32]

/-- `fill`, lowered to `braid`. -/
def fill : Braid.Func :=
  { name := "fill", entry := 0x10018#64, blocks := [
    (0x10018#64, { ops := [.get 0 1], term := .branch 0 0x1001c#64 0x10028#64 }),
    (0x1001c#64, { ops := [.get 0 1, .const 2 0x1#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 1 3], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 0 2, .get 1 0, .const 6 0x1#64, .bin 7 .add 1 6, .set 0 7, .store .w8 1 0], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x1001c#64 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `fill` is the lowering of `fill_words`. -/
theorem fill_lowered :
    fill.blocks = Lowering.Arm.lowerWords 0x10018#64 fill_words := by
  decide

/-- The instruction words of `count_ones`, from `0x1002c`. -/
def count_ones_words : List (BitVec 32) := [
  0xaa1f03e8#32, 0xb40000a0#32, 0x92400009#32, 0xd341fc00#32, 0x8b090108#32, 0xb5ffffa0#32, 0xaa0803e0#32, 0xd65f03c0#32]

/-- `count_ones`, lowered to `braid`. -/
def count_ones : Braid.Func :=
  { name := "count_ones", entry := 0x1002c#64, blocks := [
    (0x1002c#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.get 0 0], term := .branch 0 0x10034#64 0x10044#64 }),
    (0x10034#64, { ops := [.get 0 0, .const 2 0x1#64, .bin 3 .and 0 2, .set 9 3], term := .jump 0x10038#64 }),
    (0x10038#64, { ops := [.get 0 0, .const 3 0x1#64, .bin 20 .lshr 0 3, .set 0 20], term := .jump 0x1003c#64 }),
    (0x1003c#64, { ops := [.get 0 8, .get 2 9, .bin 12 .add 0 2, .set 8 12], term := .jump 0x10040#64 }),
    (0x10040#64, { ops := [.get 0 0], term := .branch 0 0x10034#64 0x10044#64 }),
    (0x10044#64, { ops := [.const 0 0x0#64, .get 2 8, .bin 12 .or 0 2, .set 0 12], term := .jump 0x10048#64 }),
    (0x10048#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `count_ones` is the lowering of `count_ones_words`. -/
theorem count_ones_lowered :
    count_ones.blocks = Lowering.Arm.lowerWords 0x1002c#64 count_ones_words := by
  decide

end Examples.Bytes.Arm
