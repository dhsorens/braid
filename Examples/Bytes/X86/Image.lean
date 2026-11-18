/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.Bytes.X86


/-- The lines of `str_len`, from `0x401000`. -/
def str_len_code : List Lowering.X86.Line := [
  ⟨0x401000, 7, "L401000", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.imm (ConstExpr.int64 (-1)))))⟩,
  ⟨0x401007, 9, "L401007", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 9))⟩,
  ⟨0x401010, 5, "L401010", some (Instr.regular (Width.W64) (Width.W8) (Operation.cmp (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rax, scale := Width.W8 }, disp := ConstExpr.int64 1 }) (Operand.imm (ConstExpr.int64 0))))⟩,
  ⟨0x401015, 4, "L401015", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rax) (Width.W64)) { base := some (RegOrRip.reg (Reg64.rax)), idx := none, disp := ConstExpr.int64 1 }))⟩,
  ⟨0x401019, 2, "L401019", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401010"))⟩,
  ⟨0x40101b, 1, "L40101b", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x40101c, 4, "L40101c", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 4))⟩]

/-- The lines of `fill`, from `0x401020`. -/
def fill_code : List Lowering.X86.Line := [
  ⟨0x401020, 3, "L401020", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401023, 2, "L401023", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L40103b"))⟩,
  ⟨0x401025, 2, "L401025", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401027, 9, "L401027", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 9))⟩,
  ⟨0x401030, 3, "L401030", some (Instr.regular (Width.W64) (Width.W8) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rax, scale := Width.W8 }, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W8))))))⟩,
  ⟨0x401033, 3, "L401033", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64)))))⟩,
  ⟨0x401036, 3, "L401036", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x401039, 2, "L401039", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401030"))⟩,
  ⟨0x40103b, 1, "L40103b", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x40103c, 4, "L40103c", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 4))⟩]

/-- The lines of `count_ones`, from `0x401040`. -/
def count_ones_code : List Lowering.X86.Line := [
  ⟨0x401040, 2, "L401040", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401042, 3, "L401042", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))))))⟩,
  ⟨0x401045, 2, "L401045", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L40105d"))⟩,
  ⟨0x401047, 9, "L401047", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 9))⟩,
  ⟨0x401050, 2, "L401050", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W32))))))⟩,
  ⟨0x401052, 3, "L401052", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401055, 3, "L401055", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401058, 3, "L401058", some (Instr.regular (Width.W64) (Width.W64) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (ShiftCountExpr.imm8 (ConstExpr.int64 1))))⟩,
  ⟨0x40105b, 2, "L40105b", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401050"))⟩,
  ⟨0x40105d, 1, "L40105d", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩]

/-- The lines of every function lowered here, in address order. -/
def image : List Lowering.X86.Line :=
  List.flatten [str_len_code, fill_code, count_ones_code]

/-- The lines of the image follow one another. -/
theorem image_wf : Lowering.X86.wf image = true := by
  decide

/-- The executable of the image: the program of the machine model. -/
def exe : Executable := Lowering.X86.exeOf image

/-- `str_len`, lowered to `braid`. -/
def str_len : Braid.Func :=
  { name := "str_len", entry := 0x401000#64, blocks := [
    (0x401000#64, { ops := [.const 0 0xffffffffffffffff#64, .set 0 0], term := .jump 0x401007#64 }),
    (0x401007#64, { ops := [], term := .jump 0x401010#64 }),
    (0x401010#64, { ops := [.get 2 5, .get 3 0, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x1#64, .bin 1 .add 6 7, .load 0 .w8 1, .const 8 0x0#64, .bin 16 .sub 0 8, .un 17 (.zext 8) 16, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 17, .bin 21 .and 19 20, .const 22 0x80#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 17 39, .setf 4 40], term := .jump 0x401015#64 }),
    (0x401015#64, { ops := [.get 1 0, .const 2 0x1#64, .bin 0 .add 1 2, .set 0 0], term := .jump 0x401019#64 }),
    (0x401019#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401010#64 0x40101b#64 }),
    (0x40101b#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x40101c#64, { ops := [], term := .jump 0x401020#64 })] }

/-- `str_len` is the lowering of `str_len_code`. -/
theorem str_len_lowered :
    str_len.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) str_len_code := by
  decide

/-- The blocks of `str_len` are blocks of the lowering of the executable. -/
theorem str_len_holds :
    ∀ p ∈ str_len.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) str_len_lowered

/-- `fill`, lowered to `braid`. -/
def fill : Braid.Func :=
  { name := "fill", entry := 0x401020#64, blocks := [
    (0x401020#64, { ops := [.get 0 4, .get 8 4, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401023#64 }),
    (0x401023#64, { ops := [.getf 0 3], term := .branch 0 0x40103b#64 0x401025#64 }),
    (0x401025#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401027#64 }),
    (0x401027#64, { ops := [], term := .jump 0x401030#64 }),
    (0x401030#64, { ops := [.get 1 3, .un 0 (.zext 8) 1, .get 9 5, .get 10 0, .const 11 0x1#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x0#64, .bin 8 .add 13 14, .store .w8 8 0], term := .jump 0x401033#64 }),
    (0x401033#64, { ops := [.get 0 0, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401036#64 }),
    (0x401036#64, { ops := [.get 0 4, .get 8 0, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401039#64 }),
    (0x401039#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401030#64 0x40103b#64 }),
    (0x40103b#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x40103c#64, { ops := [], term := .jump 0x401040#64 })] }

/-- `fill` is the lowering of `fill_code`. -/
theorem fill_lowered :
    fill.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) fill_code := by
  decide

/-- The blocks of `fill` are blocks of the lowering of the executable. -/
theorem fill_holds :
    ∀ p ∈ fill.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.head _), h⟩) fill_lowered

/-- `count_ones`, lowered to `braid`. -/
def count_ones : Braid.Func :=
  { name := "count_ones", entry := 0x401040#64, blocks := [
    (0x401040#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401042#64 }),
    (0x401042#64, { ops := [.get 0 5, .get 8 5, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401045#64 }),
    (0x401045#64, { ops := [.getf 0 3], term := .branch 0 0x40105d#64 0x401047#64 }),
    (0x401047#64, { ops := [], term := .jump 0x401050#64 }),
    (0x401050#64, { ops := [.get 1 5, .un 0 (.zext 32) 1, .set 2 0], term := .jump 0x401052#64 }),
    (0x401052#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .const 8 0x1#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x401055#64 }),
    (0x401055#64, { ops := [.get 0 2, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401058#64 }),
    (0x401058#64, { ops := [.get 0 5, .const 8 0x1#64, .bin 9 .lshr 0 8, .const 11 0x0#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .const 16 0x8000000000000000#64, .bin 17 .and 0 16, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 9 39, .setf 4 40, .set 5 9], term := .jump 0x40105b#64 }),
    (0x40105b#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401050#64 0x40105d#64 }),
    (0x40105d#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `count_ones` is the lowering of `count_ones_code`. -/
theorem count_ones_lowered :
    count_ones.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) count_ones_code := by
  decide

/-- The blocks of `count_ones` are blocks of the lowering of the executable. -/
theorem count_ones_holds :
    ∀ p ∈ count_ones.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)), h⟩) count_ones_lowered

end Examples.Bytes.X86
