/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.GoBasic.Arm


/-- The instruction words of `main.Add3`, from `0x84500`. -/
def main_Add3_words : List (BitVec 32) := [
  0x8b000021#32, 0x8b010040#32, 0xd65f03c0#32, 0x0#32]

/-- `main.Add3`, lowered to `braid`. -/
def main_Add3 : Braid.Func :=
  { name := "main.Add3", entry := 0x84500#64, blocks := [
    (0x84500#64, { ops := [.get 0 1, .get 2 0, .bin 12 .add 0 2, .set 1 12], term := .jump 0x84504#64 }),
    (0x84504#64, { ops := [.get 0 2, .get 2 1, .bin 12 .add 0 2, .set 0 12], term := .jump 0x84508#64 }),
    (0x84508#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `main_Add3` is the lowering of `main_Add3_words`. -/
theorem main_Add3_lowered :
    main_Add3.blocks = Lowering.Arm.lowerWords 0x84500#64 main_Add3_words := by
  decide

/-- The instruction words of `main.MaxU64`, from `0x84510`. -/
def main_MaxU64_words : List (BitVec 32) := [
  0xeb00003f#32, 0x54000042#32, 0xd65f03c0#32, 0xaa0103e0#32, 0xd65f03c0#32, 0x0#32, 0x0#32, 0x0#32]

/-- `main.MaxU64`, lowered to `braid`. -/
def main_MaxU64 : Braid.Func :=
  { name := "main.MaxU64", entry := 0x84510#64, blocks := [
    (0x84510#64, { ops := [.get 0 1, .get 2 0, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x84514#64 }),
    (0x84514#64, { ops := [.getf 0 2], term := .branch 0 0x8451c#64 0x84518#64 }),
    (0x84518#64, { ops := [.get 0 30], term := .jumpInd 0 }),
    (0x8451c#64, { ops := [.const 0 0x0#64, .get 2 1, .bin 12 .or 0 2, .set 0 12], term := .jump 0x84520#64 }),
    (0x84520#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `main_MaxU64` is the lowering of `main_MaxU64_words`. -/
theorem main_MaxU64_lowered :
    main_MaxU64.blocks = Lowering.Arm.lowerWords 0x84510#64 main_MaxU64_words := by
  decide

/-- The instruction words of `main.SumSlice`, from `0x84530`. -/
def main_SumSlice_words : List (BitVec 32) := [
  0xf90007e0#32, 0xaa1f03e2#32, 0xaa1f03e3#32, 0x14000004#32, 0xf8627804#32, 0x8b040063#32, 0x91000442#32, 0xeb02003f#32, 0x54ffff8c#32, 0xaa0303e0#32, 0xd65f03c0#32, 0x0#32]

/-- `main.SumSlice`, lowered to `braid`. -/
def main_SumSlice : Braid.Func :=
  { name := "main.SumSlice", entry := 0x84530#64, blocks := [
    (0x84530#64, { ops := [.get 0 0, .get 2 31, .const 3 0xf#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .const 7 0x8#64, .bin 1 .add 2 7, .store .w64 1 0], term := .jump 0x84534#64 }),
    (0x84534#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 2 12], term := .jump 0x84538#64 }),
    (0x84538#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 3 12], term := .jump 0x8453c#64 }),
    (0x8453c#64, { ops := [], term := .jump 0x8454c#64 }),
    (0x84540#64, { ops := [.get 1 0, .get 7 2, .const 8 0x3#64, .bin 6 .shl 7 8, .bin 0 .add 1 6, .load 30 .w64 0, .set 4 30], term := .jump 0x84544#64 }),
    (0x84544#64, { ops := [.get 0 3, .get 2 4, .bin 12 .add 0 2, .set 3 12], term := .jump 0x84548#64 }),
    (0x84548#64, { ops := [.get 0 2, .const 2 0x1#64, .bin 3 .add 0 2, .set 2 3], term := .jump 0x8454c#64 }),
    (0x8454c#64, { ops := [.get 0 1, .get 2 2, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x84550#64 }),
    (0x84550#64, { ops := [.getf 1 0, .getf 2 3, .bin 3 .eq 1 2, .getf 4 1, .bin 0 .ult 4 3], term := .branch 0 0x84540#64 0x84554#64 }),
    (0x84554#64, { ops := [.const 0 0x0#64, .get 2 3, .bin 12 .or 0 2, .set 0 12], term := .jump 0x84558#64 }),
    (0x84558#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `main_SumSlice` is the lowering of `main_SumSlice_words`. -/
theorem main_SumSlice_lowered :
    main_SumSlice.blocks = Lowering.Arm.lowerWords 0x84530#64 main_SumSlice_words := by
  decide

end Examples.GoBasic.Arm
