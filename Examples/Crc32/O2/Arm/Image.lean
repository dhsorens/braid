/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.Crc32.O2.Arm


/-- The instruction words of `crc32`, from `0x10000`. -/
def crc32_words : List (BitVec 32) := [
  0xb40001e2#32, 0x2a2003e9#32, 0xd503201f#32, 0x100801a8#32, 0x3840142a#32, 0xf1000442#32, 0x4a0a0129#32, 0x12000d2a#32, 0xb86a590a#32, 0x4a491149#32, 0x12000d2a#32, 0xb86a590a#32, 0x4a491149#32, 0x54fffee1#32, 0x2a2903e0#32, 0xd65f03c0#32]

/-- `crc32`, lowered to `braid`. -/
def crc32 : Braid.Func :=
  { name := "crc32", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 0 2], term := .branch 0 0x10004#64 0x1003c#64 }),
    (0x10004#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 0, .un 2 (.zext 32) 3, .un 13 .not 2, .bin 14 .or 0 13, .un 12 (.zext 32) 14, .set 9 12], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.const 0 0x20040#64, .set 8 0], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.get 0 1, .const 5 0x1#64, .bin 6 .add 0 5, .set 1 6, .load 30 .w8 0, .set 10 30], term := .jump 0x10014#64 }),
    (0x10014#64, { ops := [.get 0 2, .const 2 0x1#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 2 3], term := .jump 0x10018#64 }),
    (0x10018#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 3 10, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 9 12], term := .jump 0x1001c#64 }),
    (0x1001c#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .const 2 0xf#64, .bin 3 .and 0 2, .set 10 3], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 1 8, .get 7 10, .un 9 (.zext 32) 7, .const 10 0x2#64, .bin 6 .shl 9 10, .bin 0 .add 1 6, .load 30 .w32 0, .set 10 30], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 9, .un 5 (.zext 32) 3, .const 6 0x4#64, .bin 2 .lshr 5 6, .bin 12 .xor 0 2, .set 9 12], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .const 2 0xf#64, .bin 3 .and 0 2, .set 10 3], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 1 8, .get 7 10, .un 9 (.zext 32) 7, .const 10 0x2#64, .bin 6 .shl 9 10, .bin 0 .add 1 6, .load 30 .w32 0, .set 10 30], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 9, .un 5 (.zext 32) 3, .const 6 0x4#64, .bin 2 .lshr 5 6, .bin 12 .xor 0 2, .set 9 12], term := .jump 0x10034#64 }),
    (0x10034#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10010#64 0x10038#64 }),
    (0x10038#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 9, .un 2 (.zext 32) 3, .un 13 .not 2, .bin 14 .or 0 13, .un 12 (.zext 32) 14, .set 0 12], term := .jump 0x1003c#64 }),
    (0x1003c#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `crc32` is the lowering of `crc32_words`. -/
theorem crc32_lowered :
    crc32.blocks = Lowering.Arm.lowerWords 0x10000#64 crc32_words := by
  decide

end Examples.Crc32.O2.Arm
