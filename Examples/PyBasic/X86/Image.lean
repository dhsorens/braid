/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.PyBasic.X86


/-- The lines of `py_add3`, from `0x401000`. -/
def py_add3_code : List Lowering.X86.Line := [
  ⟨0x401000, 3, "L401000", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401003, 3, "L401003", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))))))⟩,
  ⟨0x401006, 3, "L401006", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := none, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401009, 2, "L401009", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40100b, 1, "L40100b", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x40100c, 4, "L40100c", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 4))⟩]

/-- The lines of `py_max_u64`, from `0x401010`. -/
def py_max_u64_code : List Lowering.X86.Line := [
  ⟨0x401010, 3, "L401010", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401013, 4, "L401013", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmovcc (CondCode.a) (Reg.low (Reg64.rcx) (Width.W64)) (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64)))))⟩,
  ⟨0x401017, 3, "L401017", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := none, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x40101a, 2, "L40101a", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40101c, 1, "L40101c", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x40101d, 3, "L40101d", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 3))⟩]

/-- The lines of `py_gcd`, from `0x401020`. -/
def py_gcd_code : List Lowering.X86.Line := [
  ⟨0x401020, 3, "L401020", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401023, 3, "L401023", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401026, 2, "L401026", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L401045"))⟩,
  ⟨0x401028, 8, "L401028", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 8))⟩,
  ⟨0x401030, 3, "L401030", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401033, 2, "L401033", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x401035, 3, "L401035", none⟩,
  ⟨0x401038, 3, "L401038", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x40103b, 3, "L40103b", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x40103e, 3, "L40103e", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401041, 2, "L401041", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401030"))⟩,
  ⟨0x401043, 2, "L401043", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4198472) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x401045, 3, "L401045", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x401048, 3, "L401048", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := none, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x40104b, 2, "L40104b", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40104d, 1, "L40104d", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩]

/-- The lines of every function lowered here, in address order. -/
def image : List Lowering.X86.Line :=
  List.flatten [py_add3_code, py_max_u64_code, py_gcd_code]

/-- The lines of the image follow one another. -/
theorem image_wf : Lowering.X86.wf image = true := by
  decide

/-- The executable of the image: the program of the machine model. -/
def exe : Executable := Lowering.X86.exeOf image

/-- `py_add3`, lowered to `braid`. -/
def py_add3 : Braid.Func :=
  { name := "py_add3", entry := 0x401000#64, blocks := [
    (0x401000#64, { ops := [.get 0 2, .get 8 3, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x401003#64 }),
    (0x401003#64, { ops := [.get 0 8, .get 8 3, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x401006#64 }),
    (0x401006#64, { ops := [.get 0 3, .get 8 5, .store .w64 8 0], term := .jump 0x401009#64 }),
    (0x401009#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40100b#64 }),
    (0x40100b#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x40100c#64, { ops := [], term := .jump 0x401010#64 })] }

/-- `py_add3` is the lowering of `py_add3_code`. -/
theorem py_add3_lowered :
    py_add3.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) py_add3_code := by
  decide

/-- The blocks of `py_add3` are blocks of the lowering of the executable. -/
theorem py_add3_holds :
    ∀ p ∈ py_add3.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) py_add3_lowered

/-- `py_max_u64`, lowered to `braid`. -/
def py_max_u64 : Braid.Func :=
  { name := "py_max_u64", entry := 0x401010#64, blocks := [
    (0x401010#64, { ops := [.get 0 3, .get 8 2, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401013#64 }),
    (0x401013#64, { ops := [.get 0 3, .get 8 2, .getf 17 0, .getf 18 3, .bin 19 .or 17 18, .const 20 0x0#64, .bin 16 .eq 19 20, .select 24 16 0 8, .set 2 24], term := .jump 0x401017#64 }),
    (0x401017#64, { ops := [.get 0 2, .get 8 5, .store .w64 8 0], term := .jump 0x40101a#64 }),
    (0x40101a#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40101c#64 }),
    (0x40101c#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x40101d#64, { ops := [], term := .jump 0x401020#64 })] }

/-- `py_max_u64` is the lowering of `py_max_u64_code`. -/
theorem py_max_u64_lowered :
    py_max_u64.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) py_max_u64_code := by
  decide

/-- The blocks of `py_max_u64` are blocks of the lowering of the executable. -/
theorem py_max_u64_holds :
    ∀ p ∈ py_max_u64.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.head _), h⟩) py_max_u64_lowered

/-- `py_gcd`, lowered to `braid`. -/
def py_gcd : Braid.Func :=
  { name := "py_gcd", entry := 0x401020#64, blocks := [
    (0x401020#64, { ops := [.get 0 3, .set 0 0], term := .jump 0x401023#64 }),
    (0x401023#64, { ops := [.get 0 2, .get 8 2, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401026#64 }),
    (0x401026#64, { ops := [.getf 0 3], term := .branch 0 0x401045#64 0x401028#64 }),
    (0x401028#64, { ops := [], term := .jump 0x401030#64 }),
    (0x401030#64, { ops := [.get 0 2, .set 4 0], term := .jump 0x401033#64 }),
    (0x401033#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 9 3, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x401035#64 }),
    (0x401038#64, { ops := [.get 0 2, .set 0 0], term := .jump 0x40103b#64 }),
    (0x40103b#64, { ops := [.get 0 3, .set 2 0], term := .jump 0x40103e#64 }),
    (0x40103e#64, { ops := [.get 0 3, .get 8 3, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401041#64 }),
    (0x401041#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401030#64 0x401043#64 }),
    (0x401043#64, { ops := [], term := .jump 0x401048#64 }),
    (0x401045#64, { ops := [.get 0 0, .set 4 0], term := .jump 0x401048#64 }),
    (0x401048#64, { ops := [.get 0 4, .get 8 5, .store .w64 8 0], term := .jump 0x40104b#64 }),
    (0x40104b#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40104d#64 }),
    (0x40104d#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `py_gcd` is the lowering of `py_gcd_code`. -/
theorem py_gcd_lowered :
    py_gcd.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) py_gcd_code := by
  decide

/-- The blocks of `py_gcd` are blocks of the lowering of the executable. -/
theorem py_gcd_holds :
    ∀ p ∈ py_gcd.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)), h⟩) py_gcd_lowered

end Examples.PyBasic.X86
