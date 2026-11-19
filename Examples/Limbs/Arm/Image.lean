/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.Limbs.Arm


/-- The instruction words of `add_limbs`, from `0x10000`. -/
def add_limbs_words : List (BitVec 32) := [
  0xaa1f03e8#32, 0xb4000143#32, 0xf8408429#32, 0xf840844a#32, 0xab080128#32, 0x1a9f37e9#32, 0xab0a010a#32, 0x1a9f3528#32, 0xf1000463#32, 0xf800840a#32, 0x54ffff01#32, 0xaa0803e0#32, 0xd65f03c0#32]

/-- `add_limbs`, lowered to `braid`. -/
def add_limbs : Braid.Func :=
  { name := "add_limbs", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.get 0 3], term := .branch 0 0x10008#64 0x1002c#64 }),
    (0x10008#64, { ops := [.get 0 1, .const 5 0x8#64, .bin 6 .add 0 5, .set 1 6, .load 30 .w64 0, .set 9 30], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.get 0 2, .const 5 0x8#64, .bin 6 .add 0 5, .set 2 6, .load 30 .w64 0, .set 10 30], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.get 0 9, .get 2 8, .bin 12 .add 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 12 17, .bin 15 .ult 12 0, .bin 18 .xor 0 12, .bin 19 .xor 2 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16, .set 8 12], term := .jump 0x10014#64 }),
    (0x10014#64, { ops := [.getf 1 2, .const 2 0x0#64, .bin 0 .eq 1 2, .const 6 0x0#64, .un 5 (.zext 32) 6, .const 8 0x0#64, .const 9 0x1#64, .bin 10 .add 8 9, .un 7 (.zext 32) 10, .select 12 0 5 7, .set 9 12], term := .jump 0x10018#64 }),
    (0x10018#64, { ops := [.get 0 8, .get 2 10, .bin 12 .add 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 12 17, .bin 15 .ult 12 0, .bin 18 .xor 0 12, .bin 19 .xor 2 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16, .set 10 12], term := .jump 0x1001c#64 }),
    (0x1001c#64, { ops := [.getf 1 2, .const 2 0x0#64, .bin 0 .eq 1 2, .get 6 9, .un 5 (.zext 32) 6, .const 8 0x0#64, .const 9 0x1#64, .bin 10 .add 8 9, .un 7 (.zext 32) 10, .select 12 0 5 7, .set 8 12], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 0 3, .const 2 0x1#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 3 3], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 0 10, .get 1 0, .const 6 0x8#64, .bin 7 .add 1 6, .set 0 7, .store .w64 1 0], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10008#64 0x1002c#64 }),
    (0x1002c#64, { ops := [.const 0 0x0#64, .get 2 8, .bin 12 .or 0 2, .set 0 12], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `add_limbs` is the lowering of `add_limbs_words`. -/
theorem add_limbs_lowered :
    add_limbs.blocks = Lowering.Arm.lowerWords 0x10000#64 add_limbs_words := by
  decide

end Examples.Limbs.Arm
