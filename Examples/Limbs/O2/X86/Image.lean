/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.Limbs.O2.X86


/-- The lines of `add_limbs`, from `0x401000`. -/
def add_limbs_code : List Lowering.X86.Line := [
  ⟨0x401000, 3, "L401000", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401003, 2, "L401003", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L401012"))⟩,
  ⟨0x401005, 4, "L401005", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401009, 2, "L401009", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401015"))⟩,
  ⟨0x40100b, 2, "L40100b", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40100d, 3, "L40100d", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x401010, 2, "L401010", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4198519) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x401012, 2, "L401012", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401014, 1, "L401014", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x401015, 3, "L401015", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401018, 4, "L401018", some (Instr.regular (Width.W64) (Width.W64) (Operation.and (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W64))) (Operand.imm (ConstExpr.int64 (-2)))))⟩,
  ⟨0x40101c, 2, "L40101c", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40101e, 3, "L40101e", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x401021, 15, "L401021", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 15))⟩,
  ⟨0x401030, 4, "L401030", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.r8, scale := Width.W64 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401034, 4, "L401034", some (Instr.regular (Width.W64) (Width.W8) (Operation.setcc (CondCode.c) (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W8)))))⟩,
  ⟨0x401038, 4, "L401038", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdx)), idx := some { reg := Reg64.r8, scale := Width.W64 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x40103c, 4, "L40103c", some (Instr.regular (Width.W64) (Width.W8) (Operation.setcc (CondCode.c) (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W8)))))⟩,
  ⟨0x401040, 4, "L401040", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.r8, scale := Width.W64 }, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x401044, 3, "L401044", some (Instr.regular (Width.W64) (Width.W8) (Operation.or (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W8))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W8))))))⟩,
  ⟨0x401047, 4, "L401047", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W8)))))⟩,
  ⟨0x40104b, 5, "L40104b", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.r8, scale := Width.W64 }, disp := ConstExpr.int64 8 }))))⟩,
  ⟨0x401050, 4, "L401050", some (Instr.regular (Width.W64) (Width.W8) (Operation.setcc (CondCode.c) (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W8)))))⟩,
  ⟨0x401054, 5, "L401054", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdx)), idx := some { reg := Reg64.r8, scale := Width.W64 }, disp := ConstExpr.int64 8 }))))⟩,
  ⟨0x401059, 4, "L401059", some (Instr.regular (Width.W64) (Width.W8) (Operation.setcc (CondCode.c) (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W8)))))⟩,
  ⟨0x40105d, 5, "L40105d", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.r8, scale := Width.W64 }, disp := ConstExpr.int64 8 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x401062, 3, "L401062", some (Instr.regular (Width.W64) (Width.W8) (Operation.or (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W8))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W8))))))⟩,
  ⟨0x401065, 4, "L401065", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W8)))))⟩,
  ⟨0x401069, 4, "L401069", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))) (Operand.imm (ConstExpr.int64 2))))⟩,
  ⟨0x40106d, 3, "L40106d", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))))))⟩,
  ⟨0x401070, 2, "L401070", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401030"))⟩,
  ⟨0x401072, 3, "L401072", some (Instr.regular (Width.W64) (Width.W8) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401075, 2, "L401075", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L40108e"))⟩,
  ⟨0x401077, 4, "L401077", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.r8, scale := Width.W64 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x40107b, 3, "L40107b", some (Instr.regular (Width.W64) (Width.W8) (Operation.setcc (CondCode.c) (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8)))))⟩,
  ⟨0x40107e, 4, "L40107e", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdx)), idx := some { reg := Reg64.r8, scale := Width.W64 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401082, 3, "L401082", some (Instr.regular (Width.W64) (Width.W8) (Operation.setcc (CondCode.c) (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W8)))))⟩,
  ⟨0x401085, 4, "L401085", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.r8, scale := Width.W64 }, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x401089, 2, "L401089", some (Instr.regular (Width.W64) (Width.W8) (Operation.or (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W8))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))))))⟩,
  ⟨0x40108b, 3, "L40108b", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W8)))))⟩,
  ⟨0x40108e, 1, "L40108e", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩]

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
    (0x401000#64, { ops := [.get 0 2, .get 8 2, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401003#64 }),
    (0x401003#64, { ops := [.getf 0 3], term := .branch 0 0x401012#64 0x401005#64 }),
    (0x401005#64, { ops := [.get 0 2, .const 8 0x1#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401009#64 }),
    (0x401009#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401015#64 0x40100b#64 }),
    (0x40100b#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40100d#64 }),
    (0x40100d#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 9 8, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 8 16], term := .jump 0x401010#64 }),
    (0x401010#64, { ops := [], term := .jump 0x401077#64 }),
    (0x401012#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401014#64 }),
    (0x401014#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x401015#64, { ops := [.get 0 2, .set 9 0], term := .jump 0x401018#64 }),
    (0x401018#64, { ops := [.get 0 9, .const 8 0xfffffffffffffffe#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 9 16], term := .jump 0x40101c#64 }),
    (0x40101c#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40101e#64 }),
    (0x40101e#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 9 8, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 8 16], term := .jump 0x401021#64 }),
    (0x401021#64, { ops := [], term := .jump 0x401030#64 }),
    (0x401030#64, { ops := [.get 2 4, .get 3 8, .const 4 0x8#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w64 1, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401034#64 }),
    (0x401034#64, { ops := [.getf 0 0, .get 8 10, .const 9 0xffffffffffffff00#64, .bin 10 .and 8 9, .bin 11 .or 10 0, .set 10 11], term := .jump 0x401038#64 }),
    (0x401038#64, { ops := [.get 2 3, .get 3 8, .const 4 0x8#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w64 1, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40103c#64 }),
    (0x40103c#64, { ops := [.getf 0 0, .get 8 11, .const 9 0xffffffffffffff00#64, .bin 10 .and 8 9, .bin 11 .or 10 0, .set 11 11], term := .jump 0x401040#64 }),
    (0x401040#64, { ops := [.get 0 0, .get 9 5, .get 10 8, .const 11 0x8#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x0#64, .bin 8 .add 13 14, .store .w64 8 0], term := .jump 0x401044#64 }),
    (0x401044#64, { ops := [.get 1 11, .un 0 (.zext 8) 1, .get 9 10, .un 8 (.zext 8) 9, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 11, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 11 51], term := .jump 0x401047#64 }),
    (0x401047#64, { ops := [.get 1 11, .un 0 (.zext 8) 1, .set 0 0], term := .jump 0x40104b#64 }),
    (0x40104b#64, { ops := [.get 2 4, .get 3 8, .const 4 0x8#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x8#64, .bin 1 .add 6 7, .load 0 .w64 1, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401050#64 }),
    (0x401050#64, { ops := [.getf 0 0, .get 8 10, .const 9 0xffffffffffffff00#64, .bin 10 .and 8 9, .bin 11 .or 10 0, .set 10 11], term := .jump 0x401054#64 }),
    (0x401054#64, { ops := [.get 2 3, .get 3 8, .const 4 0x8#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x8#64, .bin 1 .add 6 7, .load 0 .w64 1, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401059#64 }),
    (0x401059#64, { ops := [.getf 0 0, .get 8 11, .const 9 0xffffffffffffff00#64, .bin 10 .and 8 9, .bin 11 .or 10 0, .set 11 11], term := .jump 0x40105d#64 }),
    (0x40105d#64, { ops := [.get 0 0, .get 9 5, .get 10 8, .const 11 0x8#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x8#64, .bin 8 .add 13 14, .store .w64 8 0], term := .jump 0x401062#64 }),
    (0x401062#64, { ops := [.get 1 11, .un 0 (.zext 8) 1, .get 9 10, .un 8 (.zext 8) 9, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 11, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 11 51], term := .jump 0x401065#64 }),
    (0x401065#64, { ops := [.get 1 11, .un 0 (.zext 8) 1, .set 0 0], term := .jump 0x401069#64 }),
    (0x401069#64, { ops := [.const 0 0x2#64, .get 8 8, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 8 16], term := .jump 0x40106d#64 }),
    (0x40106d#64, { ops := [.get 0 9, .get 8 8, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401070#64 }),
    (0x401070#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401030#64 0x401072#64 }),
    (0x401072#64, { ops := [.get 1 2, .un 0 (.zext 8) 1, .const 8 0x1#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401075#64 }),
    (0x401075#64, { ops := [.getf 0 3], term := .branch 0 0x40108e#64 0x401077#64 }),
    (0x401077#64, { ops := [.get 2 4, .get 3 8, .const 4 0x8#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w64 1, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40107b#64 }),
    (0x40107b#64, { ops := [.getf 0 0, .get 8 2, .const 9 0xffffffffffffff00#64, .bin 10 .and 8 9, .bin 11 .or 10 0, .set 2 11], term := .jump 0x40107e#64 }),
    (0x40107e#64, { ops := [.get 2 3, .get 3 8, .const 4 0x8#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w64 1, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401082#64 }),
    (0x401082#64, { ops := [.getf 0 0, .get 8 3, .const 9 0xffffffffffffff00#64, .bin 10 .and 8 9, .bin 11 .or 10 0, .set 3 11], term := .jump 0x401085#64 }),
    (0x401085#64, { ops := [.get 0 0, .get 9 5, .get 10 8, .const 11 0x8#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x0#64, .bin 8 .add 13 14, .store .w64 8 0], term := .jump 0x401089#64 }),
    (0x401089#64, { ops := [.get 1 3, .un 0 (.zext 8) 1, .get 9 2, .un 8 (.zext 8) 9, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 3, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 3 51], term := .jump 0x40108b#64 }),
    (0x40108b#64, { ops := [.get 1 3, .un 0 (.zext 8) 1, .set 0 0], term := .jump 0x40108e#64 }),
    (0x40108e#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `add_limbs` is the lowering of `add_limbs_code`. -/
theorem add_limbs_lowered :
    add_limbs.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) add_limbs_code := by
  decide

/-- The blocks of `add_limbs` are blocks of the lowering of the executable. -/
theorem add_limbs_holds :
    ∀ p ∈ add_limbs.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) add_limbs_lowered

end Examples.Limbs.O2.X86
