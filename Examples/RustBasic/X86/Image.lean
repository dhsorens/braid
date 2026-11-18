/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.RustBasic.X86


/-- The lines of `add3`, from `0x401010`. -/
def add3_code : List Lowering.X86.Line := [
  ⟨0x401010, 4, "L401010", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rax) (Width.W64)) { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rsi, scale := Width.W8 }, disp := ConstExpr.int64 0 }))⟩,
  ⟨0x401014, 3, "L401014", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401017, 1, "L401017", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x401018, 8, "L401018", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 8))⟩]

/-- The lines of `gcd`, from `0x401020`. -/
def gcd_code : List Lowering.X86.Line := [
  ⟨0x401020, 3, "L401020", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))))))⟩,
  ⟨0x401023, 3, "L401023", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401026, 2, "L401026", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L401040"))⟩,
  ⟨0x401028, 8, "L401028", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 8))⟩,
  ⟨0x401030, 2, "L401030", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x401032, 3, "L401032", none⟩,
  ⟨0x401035, 3, "L401035", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401038, 3, "L401038", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x40103b, 3, "L40103b", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x40103e, 2, "L40103e", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401030"))⟩,
  ⟨0x401040, 1, "L401040", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x401041, 15, "L401041", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 15))⟩]

/-- The lines of `max_u64`, from `0x401050`. -/
def max_u64_code : List Lowering.X86.Line := [
  ⟨0x401050, 3, "L401050", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401053, 3, "L401053", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401056, 4, "L401056", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmovcc (CondCode.a) (Reg.low (Reg64.rax) (Width.W64)) (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64)))))⟩,
  ⟨0x40105a, 1, "L40105a", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x40105b, 5, "L40105b", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 5))⟩]

/-- The lines of `sum_slice`, from `0x401060`. -/
def sum_slice_code : List Lowering.X86.Line := [
  ⟨0x401060, 3, "L401060", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401063, 2, "L401063", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L40107e"))⟩,
  ⟨0x401065, 4, "L401065", some (Instr.regular (Width.W64) (Width.W64) (Operation.shl (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (ShiftCountExpr.imm8 (ConstExpr.int64 3))))⟩,
  ⟨0x401069, 2, "L401069", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40106b, 2, "L40106b", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x40106d, 3, "L40106d", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 3))⟩,
  ⟨0x401070, 4, "L401070", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401074, 4, "L401074", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.imm (ConstExpr.int64 8))))⟩,
  ⟨0x401078, 3, "L401078", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x40107b, 2, "L40107b", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401070"))⟩,
  ⟨0x40107d, 1, "L40107d", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x40107e, 2, "L40107e", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401080, 1, "L401080", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩]

/-- The lines of every function lowered here, in address order. -/
def image : List Lowering.X86.Line :=
  List.flatten [add3_code, gcd_code, max_u64_code, sum_slice_code]

/-- The lines of the image follow one another. -/
theorem image_wf : Lowering.X86.wf image = true := by
  decide

/-- The executable of the image: the program of the machine model. -/
def exe : Executable := Lowering.X86.exeOf image

/-- `add3`, lowered to `braid`. -/
def add3 : Braid.Func :=
  { name := "add3", entry := 0x401010#64, blocks := [
    (0x401010#64, { ops := [.get 1 5, .get 2 4, .const 3 0x1#64, .bin 4 .mul 2 3, .bin 5 .add 1 4, .const 6 0x0#64, .bin 0 .add 5 6, .set 0 0], term := .jump 0x401014#64 }),
    (0x401014#64, { ops := [.get 0 3, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401017#64 }),
    (0x401017#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x401018#64, { ops := [], term := .jump 0x401020#64 })] }

/-- `add3` is the lowering of `add3_code`. -/
theorem add3_lowered :
    add3.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) add3_code := by
  decide

/-- The blocks of `add3` are blocks of the lowering of the executable. -/
theorem add3_holds :
    ∀ p ∈ add3.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) add3_lowered

/-- `gcd`, lowered to `braid`. -/
def gcd : Braid.Func :=
  { name := "gcd", entry := 0x401020#64, blocks := [
    (0x401020#64, { ops := [.get 0 5, .set 0 0], term := .jump 0x401023#64 }),
    (0x401023#64, { ops := [.get 0 4, .get 8 4, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401026#64 }),
    (0x401026#64, { ops := [.getf 0 3], term := .branch 0 0x401040#64 0x401028#64 }),
    (0x401028#64, { ops := [], term := .jump 0x401030#64 }),
    (0x401030#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 9 3, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x401032#64 }),
    (0x401035#64, { ops := [.get 0 4, .set 0 0], term := .jump 0x401038#64 }),
    (0x401038#64, { ops := [.get 0 3, .get 8 3, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40103b#64 }),
    (0x40103b#64, { ops := [.get 0 3, .set 4 0], term := .jump 0x40103e#64 }),
    (0x40103e#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401030#64 0x401040#64 }),
    (0x401040#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x401041#64, { ops := [], term := .jump 0x401050#64 })] }

/-- `gcd` is the lowering of `gcd_code`. -/
theorem gcd_lowered :
    gcd.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) gcd_code := by
  decide

/-- The blocks of `gcd` are blocks of the lowering of the executable. -/
theorem gcd_holds :
    ∀ p ∈ gcd.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.head _), h⟩) gcd_lowered

/-- `max_u64`, lowered to `braid`. -/
def max_u64 : Braid.Func :=
  { name := "max_u64", entry := 0x401050#64, blocks := [
    (0x401050#64, { ops := [.get 0 4, .set 0 0], term := .jump 0x401053#64 }),
    (0x401053#64, { ops := [.get 0 5, .get 8 4, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401056#64 }),
    (0x401056#64, { ops := [.get 0 5, .get 8 0, .getf 17 0, .getf 18 3, .bin 19 .or 17 18, .const 20 0x0#64, .bin 16 .eq 19 20, .select 24 16 0 8, .set 0 24], term := .jump 0x40105a#64 }),
    (0x40105a#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x40105b#64, { ops := [], term := .jump 0x401060#64 })] }

/-- `max_u64` is the lowering of `max_u64_code`. -/
theorem max_u64_lowered :
    max_u64.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) max_u64_code := by
  decide

/-- The blocks of `max_u64` are blocks of the lowering of the executable. -/
theorem max_u64_holds :
    ∀ p ∈ max_u64.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)), h⟩) max_u64_lowered

/-- `sum_slice`, lowered to `braid`. -/
def sum_slice : Braid.Func :=
  { name := "sum_slice", entry := 0x401060#64, blocks := [
    (0x401060#64, { ops := [.get 0 4, .get 8 4, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401063#64 }),
    (0x401063#64, { ops := [.getf 0 3], term := .branch 0 0x40107e#64 0x401065#64 }),
    (0x401065#64, { ops := [.get 0 4, .const 8 0x3#64, .bin 9 .shl 0 8, .const 11 0x3d#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 9 39, .setf 4 40, .set 4 9], term := .jump 0x401069#64 }),
    (0x401069#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40106b#64 }),
    (0x40106b#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x40106d#64 }),
    (0x40106d#64, { ops := [], term := .jump 0x401070#64 }),
    (0x401070#64, { ops := [.get 2 5, .get 3 2, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w64 1, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401074#64 }),
    (0x401074#64, { ops := [.const 0 0x8#64, .get 8 2, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x401078#64 }),
    (0x401078#64, { ops := [.get 0 4, .get 8 2, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40107b#64 }),
    (0x40107b#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401070#64 0x40107d#64 }),
    (0x40107d#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x40107e#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401080#64 }),
    (0x401080#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `sum_slice` is the lowering of `sum_slice_code`. -/
theorem sum_slice_lowered :
    sum_slice.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) sum_slice_code := by
  decide

/-- The blocks of `sum_slice` are blocks of the lowering of the executable. -/
theorem sum_slice_holds :
    ∀ p ∈ sum_slice.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))), h⟩) sum_slice_lowered

end Examples.RustBasic.X86
