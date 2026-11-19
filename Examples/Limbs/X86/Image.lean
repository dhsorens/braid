/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.Limbs.X86


/-- The lines of `add_limbs`, from `0x401000`. -/
def add_limbs_code : List Lowering.X86.Line := [
  ⟨0x401000, 2, "L401000", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401002, 3, "L401002", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401005, 2, "L401005", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L401033"))⟩,
  ⟨0x401007, 3, "L401007", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x40100a, 6, "L40100a", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 6))⟩,
  ⟨0x401010, 4, "L401010", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.r8, scale := Width.W64 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401014, 4, "L401014", some (Instr.regular (Width.W64) (Width.W8) (Operation.setcc (CondCode.c) (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W8)))))⟩,
  ⟨0x401018, 4, "L401018", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdx)), idx := some { reg := Reg64.r8, scale := Width.W64 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x40101c, 4, "L40101c", some (Instr.regular (Width.W64) (Width.W8) (Operation.setcc (CondCode.c) (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W8)))))⟩,
  ⟨0x401020, 4, "L401020", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.r8, scale := Width.W64 }, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x401024, 3, "L401024", some (Instr.regular (Width.W64) (Width.W8) (Operation.or (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W8))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W8))))))⟩,
  ⟨0x401027, 4, "L401027", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W8)))))⟩,
  ⟨0x40102b, 3, "L40102b", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64)))))⟩,
  ⟨0x40102e, 3, "L40102e", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))))))⟩,
  ⟨0x401031, 2, "L401031", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401010"))⟩,
  ⟨0x401033, 1, "L401033", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩]

/-- The lines of every function lowered here, in address order. -/
def image : List Lowering.X86.Line :=
  List.flatten [add_limbs_code]

/-- The lines of the image follow one another. -/
theorem image_wf : Lowering.X86.wf image = true := by
  decide

/-- The executable of the image: the program of the machine model. -/
def exe : Executable := Lowering.X86.exeOf image

/-- `add_limbs`, lowered to `braid`. -/
def add_limbs : Braid.Func :=
  { name := "add_limbs", entry := 0x401000#64, blocks := [
    (0x401000#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401002#64 }),
    (0x401002#64, { ops := [.get 0 2, .get 8 2, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401005#64 }),
    (0x401005#64, { ops := [.getf 0 3], term := .branch 0 0x401033#64 0x401007#64 }),
    (0x401007#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 9 8, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 8 16], term := .jump 0x40100a#64 }),
    (0x40100a#64, { ops := [], term := .jump 0x401010#64 }),
    (0x401010#64, { ops := [.get 2 4, .get 3 8, .const 4 0x8#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w64 1, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401014#64 }),
    (0x401014#64, { ops := [.getf 0 0, .get 8 9, .const 9 0xffffffffffffff00#64, .bin 10 .and 8 9, .bin 11 .or 10 0, .set 9 11], term := .jump 0x401018#64 }),
    (0x401018#64, { ops := [.get 2 3, .get 3 8, .const 4 0x8#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w64 1, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40101c#64 }),
    (0x40101c#64, { ops := [.getf 0 0, .get 8 10, .const 9 0xffffffffffffff00#64, .bin 10 .and 8 9, .bin 11 .or 10 0, .set 10 11], term := .jump 0x401020#64 }),
    (0x401020#64, { ops := [.get 0 0, .get 9 5, .get 10 8, .const 11 0x8#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x0#64, .bin 8 .add 13 14, .store .w64 8 0], term := .jump 0x401024#64 }),
    (0x401024#64, { ops := [.get 1 10, .un 0 (.zext 8) 1, .get 9 9, .un 8 (.zext 8) 9, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 10, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 10 51], term := .jump 0x401027#64 }),
    (0x401027#64, { ops := [.get 1 10, .un 0 (.zext 8) 1, .set 0 0], term := .jump 0x40102b#64 }),
    (0x40102b#64, { ops := [.get 0 8, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 8 16], term := .jump 0x40102e#64 }),
    (0x40102e#64, { ops := [.get 0 2, .get 8 8, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401031#64 }),
    (0x401031#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401010#64 0x401033#64 }),
    (0x401033#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `add_limbs` is the lowering of `add_limbs_code`. -/
theorem add_limbs_lowered :
    add_limbs.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) add_limbs_code := by
  decide

/-- The blocks of `add_limbs` are blocks of the lowering of the executable. -/
theorem add_limbs_holds :
    ∀ p ∈ add_limbs.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) add_limbs_lowered

end Examples.Limbs.X86
