/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.SwiftBasic.Arm


/-- The instruction words of `swift_add3`, from `0x10000`. -/
def swift_add3_words : List (BitVec 32) := [
  0x8b000028#32, 0x8b020100#32, 0xd65f03c0#32]

/-- `swift_add3`, lowered to `braid`. -/
def swift_add3 : Braid.Func :=
  { name := "swift_add3", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 0 1, .get 2 0, .bin 12 .add 0 2, .set 8 12], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.get 0 8, .get 2 2, .bin 12 .add 0 2, .set 0 12], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `swift_add3` is the lowering of `swift_add3_words`. -/
theorem swift_add3_lowered :
    swift_add3.blocks = Lowering.Arm.lowerWords 0x10000#64 swift_add3_words := by
  decide

/-- The instruction words of `swift_gcd`, from `0x10018`. -/
def swift_gcd_words : List (BitVec 32) := [
  0xb40000e1#32, 0x9ac10809#32, 0xaa0103e8#32, 0x9b018121#32, 0xaa0803e0#32, 0xb5ffff81#32, 0xaa0803e0#32, 0xd65f03c0#32]

/-- `swift_gcd`, lowered to `braid`. -/
def swift_gcd : Braid.Func :=
  { name := "swift_gcd", entry := 0x10018#64, blocks := [
    (0x10018#64, { ops := [.get 0 1], term := .branch 0 0x1001c#64 0x10034#64 }),
    (0x1001c#64, { ops := [.get 0 0, .get 1 1, .bin 9 .udiv 0 1, .set 9 9], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.const 0 0x0#64, .get 2 1, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 0 9, .get 1 1, .get 2 0, .bin 3 .mul 0 1, .bin 9 .sub 2 3, .set 1 9], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.const 0 0x0#64, .get 2 8, .bin 12 .or 0 2, .set 0 12], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 0 1], term := .branch 0 0x1001c#64 0x10030#64 }),
    (0x10030#64, { ops := [.const 0 0x0#64, .get 2 8, .bin 12 .or 0 2, .set 0 12], term := .jump 0x10034#64 }),
    (0x10034#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `swift_gcd` is the lowering of `swift_gcd_words`. -/
theorem swift_gcd_lowered :
    swift_gcd.blocks = Lowering.Arm.lowerWords 0x10018#64 swift_gcd_words := by
  decide

/-- The instruction words of `swift_min`, from `0x10058`. -/
def swift_min_words : List (BitVec 32) := [
  0xeb01001f#32, 0x9a813000#32, 0xd65f03c0#32]

/-- `swift_min`, lowered to `braid`. -/
def swift_min : Braid.Func :=
  { name := "swift_min", entry := 0x10058#64, blocks := [
    (0x10058#64, { ops := [.get 0 0, .get 2 1, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x1005c#64 }),
    (0x1005c#64, { ops := [.getf 1 2, .const 2 0x0#64, .bin 0 .eq 1 2, .get 5 0, .get 7 1, .select 12 0 5 7, .set 0 12], term := .jump 0x10060#64 }),
    (0x10060#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `swift_min` is the lowering of `swift_min_words`. -/
theorem swift_min_lowered :
    swift_min.blocks = Lowering.Arm.lowerWords 0x10058#64 swift_min_words := by
  decide

end Examples.SwiftBasic.Arm
