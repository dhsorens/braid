/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.GoBasic.X86


/-- The lines of `main.Add3`, from `0x47a600`. -/
def main_Add3_code : List Lowering.X86.Line := [
  ⟨0x47a600, 4, "L47a600", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rdx) (Width.W64)) { base := some (RegOrRip.reg (Reg64.rbx)), idx := some { reg := Reg64.rax, scale := Width.W8 }, disp := ConstExpr.int64 0 }))⟩,
  ⟨0x47a604, 4, "L47a604", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rax) (Width.W64)) { base := some (RegOrRip.reg (Reg64.rcx)), idx := some { reg := Reg64.rdx, scale := Width.W8 }, disp := ConstExpr.int64 0 }))⟩,
  ⟨0x47a608, 1, "L47a608", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x47a609, 1, "L47a609", none⟩,
  ⟨0x47a60a, 1, "L47a60a", none⟩,
  ⟨0x47a60b, 1, "L47a60b", none⟩,
  ⟨0x47a60c, 1, "L47a60c", none⟩,
  ⟨0x47a60d, 1, "L47a60d", none⟩,
  ⟨0x47a60e, 1, "L47a60e", none⟩,
  ⟨0x47a60f, 1, "L47a60f", none⟩,
  ⟨0x47a610, 1, "L47a610", none⟩,
  ⟨0x47a611, 1, "L47a611", none⟩,
  ⟨0x47a612, 1, "L47a612", none⟩,
  ⟨0x47a613, 1, "L47a613", none⟩,
  ⟨0x47a614, 1, "L47a614", none⟩,
  ⟨0x47a615, 1, "L47a615", none⟩,
  ⟨0x47a616, 1, "L47a616", none⟩,
  ⟨0x47a617, 1, "L47a617", none⟩,
  ⟨0x47a618, 1, "L47a618", none⟩,
  ⟨0x47a619, 1, "L47a619", none⟩,
  ⟨0x47a61a, 1, "L47a61a", none⟩,
  ⟨0x47a61b, 1, "L47a61b", none⟩,
  ⟨0x47a61c, 1, "L47a61c", none⟩,
  ⟨0x47a61d, 1, "L47a61d", none⟩,
  ⟨0x47a61e, 1, "L47a61e", none⟩,
  ⟨0x47a61f, 1, "L47a61f", none⟩]

/-- The lines of `main.MaxU64`, from `0x47a620`. -/
def main_MaxU64_code : List Lowering.X86.Line := [
  ⟨0x47a620, 3, "L47a620", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x47a623, 2, "L47a623", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nc) "L47a626"))⟩,
  ⟨0x47a625, 1, "L47a625", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x47a626, 3, "L47a626", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64))))))⟩,
  ⟨0x47a629, 1, "L47a629", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x47a62a, 1, "L47a62a", none⟩,
  ⟨0x47a62b, 1, "L47a62b", none⟩,
  ⟨0x47a62c, 1, "L47a62c", none⟩,
  ⟨0x47a62d, 1, "L47a62d", none⟩,
  ⟨0x47a62e, 1, "L47a62e", none⟩,
  ⟨0x47a62f, 1, "L47a62f", none⟩,
  ⟨0x47a630, 1, "L47a630", none⟩,
  ⟨0x47a631, 1, "L47a631", none⟩,
  ⟨0x47a632, 1, "L47a632", none⟩,
  ⟨0x47a633, 1, "L47a633", none⟩,
  ⟨0x47a634, 1, "L47a634", none⟩,
  ⟨0x47a635, 1, "L47a635", none⟩,
  ⟨0x47a636, 1, "L47a636", none⟩,
  ⟨0x47a637, 1, "L47a637", none⟩,
  ⟨0x47a638, 1, "L47a638", none⟩,
  ⟨0x47a639, 1, "L47a639", none⟩,
  ⟨0x47a63a, 1, "L47a63a", none⟩,
  ⟨0x47a63b, 1, "L47a63b", none⟩,
  ⟨0x47a63c, 1, "L47a63c", none⟩,
  ⟨0x47a63d, 1, "L47a63d", none⟩,
  ⟨0x47a63e, 1, "L47a63e", none⟩,
  ⟨0x47a63f, 1, "L47a63f", none⟩]

/-- The lines of `main.SumSlice`, from `0x47a640`. -/
def main_SumSlice_code : List Lowering.X86.Line := [
  ⟨0x47a640, 5, "L47a640", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 8 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x47a645, 2, "L47a645", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x47a647, 2, "L47a647", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x47a649, 2, "L47a649", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4695634) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x47a64b, 4, "L47a64b", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rax)), idx := some { reg := Reg64.rcx, scale := Width.W64 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x47a64f, 3, "L47a64f", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64)))))⟩,
  ⟨0x47a652, 3, "L47a652", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x47a655, 2, "L47a655", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.g) "L47a64b"))⟩,
  ⟨0x47a657, 3, "L47a657", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x47a65a, 1, "L47a65a", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x47a65b, 1, "L47a65b", none⟩,
  ⟨0x47a65c, 1, "L47a65c", none⟩,
  ⟨0x47a65d, 1, "L47a65d", none⟩,
  ⟨0x47a65e, 1, "L47a65e", none⟩,
  ⟨0x47a65f, 1, "L47a65f", none⟩]

/-- The lines of every function lowered here, in address order. -/
def image : List Lowering.X86.Line :=
  List.flatten [main_Add3_code, main_MaxU64_code, main_SumSlice_code]

/-- The lines of the image follow one another. -/
theorem image_wf : Lowering.X86.wf image = true := by
  decide

/-- The executable of the image: the program of the machine model. -/
def exe : Executable := Lowering.X86.exeOf image

/-- `main.Add3`, lowered to `braid`. -/
def main_Add3 : Braid.Func :=
  { name := "main.Add3", entry := 0x47a600#64, blocks := [
    (0x47a600#64, { ops := [.get 1 1, .get 2 0, .const 3 0x1#64, .bin 4 .mul 2 3, .bin 5 .add 1 4, .const 6 0x0#64, .bin 0 .add 5 6, .set 3 0], term := .jump 0x47a604#64 }),
    (0x47a604#64, { ops := [.get 1 2, .get 2 3, .const 3 0x1#64, .bin 4 .mul 2 3, .bin 5 .add 1 4, .const 6 0x0#64, .bin 0 .add 5 6, .set 0 0], term := .jump 0x47a608#64 }),
    (0x47a608#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `main_Add3` is the lowering of `main_Add3_code`. -/
theorem main_Add3_lowered :
    main_Add3.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) main_Add3_code := by
  decide

/-- The blocks of `main_Add3` are blocks of the lowering of the executable. -/
theorem main_Add3_holds :
    ∀ p ∈ main_Add3.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) main_Add3_lowered

/-- `main.MaxU64`, lowered to `braid`. -/
def main_MaxU64 : Braid.Func :=
  { name := "main.MaxU64", entry := 0x47a620#64, blocks := [
    (0x47a620#64, { ops := [.get 0 1, .get 8 0, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x47a623#64 }),
    (0x47a623#64, { ops := [.getf 1 0, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x47a626#64 0x47a625#64 }),
    (0x47a625#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x47a626#64, { ops := [.get 0 1, .set 0 0], term := .jump 0x47a629#64 }),
    (0x47a629#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `main_MaxU64` is the lowering of `main_MaxU64_code`. -/
theorem main_MaxU64_lowered :
    main_MaxU64.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) main_MaxU64_code := by
  decide

/-- The blocks of `main_MaxU64` are blocks of the lowering of the executable. -/
theorem main_MaxU64_holds :
    ∀ p ∈ main_MaxU64.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.head _), h⟩) main_MaxU64_lowered

/-- `main.SumSlice`, lowered to `braid`. -/
def main_SumSlice : Braid.Func :=
  { name := "main.SumSlice", entry := 0x47a640#64, blocks := [
    (0x47a640#64, { ops := [.get 0 0, .get 9 6, .const 10 0x8#64, .bin 8 .add 9 10, .store .w64 8 0], term := .jump 0x47a645#64 }),
    (0x47a645#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x47a647#64 }),
    (0x47a647#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 9 3, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x47a649#64 }),
    (0x47a649#64, { ops := [], term := .jump 0x47a652#64 }),
    (0x47a64b#64, { ops := [.get 2 0, .get 3 2, .const 4 0x8#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w64 1, .get 8 3, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x47a64f#64 }),
    (0x47a64f#64, { ops := [.get 0 2, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x47a652#64 }),
    (0x47a652#64, { ops := [.get 0 1, .get 8 2, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x47a655#64 }),
    (0x47a655#64, { ops := [.getf 1 4, .getf 2 5, .bin 3 .xor 1 2, .getf 4 3, .bin 5 .or 3 4, .const 6 0x0#64, .bin 0 .eq 5 6], term := .branch 0 0x47a64b#64 0x47a657#64 }),
    (0x47a657#64, { ops := [.get 0 3, .set 0 0], term := .jump 0x47a65a#64 }),
    (0x47a65a#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `main_SumSlice` is the lowering of `main_SumSlice_code`. -/
theorem main_SumSlice_lowered :
    main_SumSlice.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) main_SumSlice_code := by
  decide

/-- The blocks of `main_SumSlice` are blocks of the lowering of the executable. -/
theorem main_SumSlice_holds :
    ∀ p ∈ main_SumSlice.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)), h⟩) main_SumSlice_lowered

end Examples.GoBasic.X86
