/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.Basic.Arm


/-- The instruction words of `add3`, from `0x10000`. -/
def add3_words : List (BitVec 32) := [
  0x8b000028#32, 0x8b020100#32, 0xd65f03c0#32]

/-- `add3`, lowered to `braid`. -/
def add3 : Braid.Func :=
  { name := "add3", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 0 1, .get 2 0, .bin 12 .add 0 2, .set 8 12], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.get 0 8, .get 2 2, .bin 12 .add 0 2, .set 0 12], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `add3` is the lowering of `add3_words`. -/
theorem add3_lowered :
    add3.blocks = Lowering.Arm.lowerWords 0x10000#64 add3_words := by
  decide

/-- The instruction words of `max_u64`, from `0x1000c`. -/
def max_u64_words : List (BitVec 32) := [
  0xeb01001f#32, 0x9a818000#32, 0xd65f03c0#32]

/-- `max_u64`, lowered to `braid`. -/
def max_u64 : Braid.Func :=
  { name := "max_u64", entry := 0x1000c#64, blocks := [
    (0x1000c#64, { ops := [.get 0 0, .get 2 1, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.getf 1 2, .getf 2 1, .bin 0 .ult 2 1, .get 5 0, .get 7 1, .select 12 0 5 7, .set 0 12], term := .jump 0x10014#64 }),
    (0x10014#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `max_u64` is the lowering of `max_u64_words`. -/
theorem max_u64_lowered :
    max_u64.blocks = Lowering.Arm.lowerWords 0x1000c#64 max_u64_words := by
  decide

/-- The instruction words of `sum_to`, from `0x10018`. -/
def sum_to_words : List (BitVec 32) := [
  0xb4000100#32, 0xd1000408#32, 0xd1000809#32, 0x9b097d0a#32, 0x9bc97d09#32, 0x9b080108#32, 0x93ca0529#32, 0xcb090100#32, 0xd65f03c0#32]

/-- `sum_to`, lowered to `braid`. -/
def sum_to : Braid.Func :=
  { name := "sum_to", entry := 0x10018#64, blocks := [
    (0x10018#64, { ops := [.get 0 0], term := .branch 0 0x1001c#64 0x10038#64 }),
    (0x1001c#64, { ops := [.get 0 0, .const 2 0x1#64, .bin 3 .sub 0 2, .set 8 3], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 0 0, .const 2 0x2#64, .bin 3 .sub 0 2, .set 9 3], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 0 8, .get 1 9, .const 2 0x0#64, .bin 3 .mul 0 1, .bin 9 .add 2 3, .set 10 9], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 8, .get 1 9, .bin 9 .mulhu 0 1, .set 9 9], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 0 8, .get 1 8, .get 2 0, .bin 3 .mul 0 1, .bin 9 .add 2 3, .set 8 9], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.get 0 9, .get 1 10, .const 2 0x1#64, .bin 3 .lshr 1 2, .const 4 0x3f#64, .bin 5 .shl 0 4, .bin 9 .or 3 5, .set 9 9], term := .jump 0x10034#64 }),
    (0x10034#64, { ops := [.get 0 8, .get 2 9, .bin 12 .sub 0 2, .set 0 12], term := .jump 0x10038#64 }),
    (0x10038#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `sum_to` is the lowering of `sum_to_words`. -/
theorem sum_to_lowered :
    sum_to.blocks = Lowering.Arm.lowerWords 0x10018#64 sum_to_words := by
  decide

end Examples.Basic.Arm
