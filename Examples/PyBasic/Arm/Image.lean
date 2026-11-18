/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.PyBasic.Arm


/-- The instruction words of `py_add3`, from `0x10000`. -/
def py_add3_words : List (BitVec 32) := [
  0x8b020069#32, 0xaa0003e8#32, 0x2a1f03e0#32, 0x8b040129#32, 0xf9000109#32, 0xd65f03c0#32]

/-- `py_add3`, lowered to `braid`. -/
def py_add3 : Braid.Func :=
  { name := "py_add3", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 0 3, .get 2 2, .bin 12 .add 0 2, .set 9 12], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.const 0 0x0#64, .get 2 0, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .const 3 0x0#64, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 0 12], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.get 0 9, .get 2 4, .bin 12 .add 0 2, .set 9 12], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.get 0 9, .get 1 8, .store .w64 1 0], term := .jump 0x10014#64 }),
    (0x10014#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `py_add3` is the lowering of `py_add3_words`. -/
theorem py_add3_lowered :
    py_add3.blocks = Lowering.Arm.lowerWords 0x10000#64 py_add3_words := by
  decide

/-- The instruction words of `py_max_u64`, from `0x10018`. -/
def py_max_u64_words : List (BitVec 32) := [
  0xeb03005f#32, 0xaa0003e8#32, 0x2a1f03e0#32, 0x9a838049#32, 0xf9000109#32, 0xd65f03c0#32]

/-- `py_max_u64`, lowered to `braid`. -/
def py_max_u64 : Braid.Func :=
  { name := "py_max_u64", entry := 0x10018#64, blocks := [
    (0x10018#64, { ops := [.get 0 2, .get 2 3, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x1001c#64 }),
    (0x1001c#64, { ops := [.const 0 0x0#64, .get 2 0, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .const 3 0x0#64, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 0 12], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.getf 1 2, .getf 2 1, .bin 0 .ult 2 1, .get 5 2, .get 7 3, .select 12 0 5 7, .set 9 12], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 9, .get 1 8, .store .w64 1 0], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `py_max_u64` is the lowering of `py_max_u64_words`. -/
theorem py_max_u64_lowered :
    py_max_u64.blocks = Lowering.Arm.lowerWords 0x10018#64 py_max_u64_words := by
  decide

/-- The instruction words of `py_gcd`, from `0x10030`. -/
def py_gcd_words : List (BitVec 32) := [
  0xaa0003e8#32, 0xb40000e3#32, 0x9ac3084a#32, 0xaa0303e9#32, 0x9b038943#32, 0xaa0903e2#32, 0xb5ffff83#32, 0x14000002#32, 0xaa0203e9#32, 0x2a1f03e0#32, 0xf9000109#32, 0xd65f03c0#32]

/-- `py_gcd`, lowered to `braid`. -/
def py_gcd : Braid.Func :=
  { name := "py_gcd", entry := 0x10030#64, blocks := [
    (0x10030#64, { ops := [.const 0 0x0#64, .get 2 0, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10034#64 }),
    (0x10034#64, { ops := [.get 0 3], term := .branch 0 0x10038#64 0x10050#64 }),
    (0x10038#64, { ops := [.get 0 2, .get 1 3, .bin 9 .udiv 0 1, .set 10 9], term := .jump 0x1003c#64 }),
    (0x1003c#64, { ops := [.const 0 0x0#64, .get 2 3, .bin 12 .or 0 2, .set 9 12], term := .jump 0x10040#64 }),
    (0x10040#64, { ops := [.get 0 10, .get 1 3, .get 2 2, .bin 3 .mul 0 1, .bin 9 .sub 2 3, .set 3 9], term := .jump 0x10044#64 }),
    (0x10044#64, { ops := [.const 0 0x0#64, .get 2 9, .bin 12 .or 0 2, .set 2 12], term := .jump 0x10048#64 }),
    (0x10048#64, { ops := [.get 0 3], term := .branch 0 0x10038#64 0x1004c#64 }),
    (0x1004c#64, { ops := [], term := .jump 0x10054#64 }),
    (0x10050#64, { ops := [.const 0 0x0#64, .get 2 2, .bin 12 .or 0 2, .set 9 12], term := .jump 0x10054#64 }),
    (0x10054#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .const 3 0x0#64, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 0 12], term := .jump 0x10058#64 }),
    (0x10058#64, { ops := [.get 0 9, .get 1 8, .store .w64 1 0], term := .jump 0x1005c#64 }),
    (0x1005c#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `py_gcd` is the lowering of `py_gcd_words`. -/
theorem py_gcd_lowered :
    py_gcd.blocks = Lowering.Arm.lowerWords 0x10030#64 py_gcd_words := by
  decide

end Examples.PyBasic.Arm
