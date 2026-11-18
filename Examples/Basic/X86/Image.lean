/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.Basic.X86


/-- The lines of `add3`, from `0x401000`. -/
def add3_code : List Lowering.X86.Line := [
  ⟨0x401000, 4, "L401000", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rax) (Width.W64)) { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rsi, scale := Width.W8 }, disp := ConstExpr.int64 0 }))⟩,
  ⟨0x401004, 3, "L401004", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401007, 1, "L401007", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x401008, 8, "L401008", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 8))⟩]

/-- The lines of `max_u64`, from `0x401010`. -/
def max_u64_code : List Lowering.X86.Line := [
  ⟨0x401010, 3, "L401010", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401013, 3, "L401013", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401016, 4, "L401016", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmovcc (CondCode.a) (Reg.low (Reg64.rax) (Width.W64)) (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64)))))⟩,
  ⟨0x40101a, 1, "L40101a", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x40101b, 5, "L40101b", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 5))⟩]

/-- The lines of `sum_to`, from `0x401020`. -/
def sum_to_code : List Lowering.X86.Line := [
  ⟨0x401020, 3, "L401020", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))))))⟩,
  ⟨0x401023, 2, "L401023", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L401049"))⟩,
  ⟨0x401025, 4, "L401025", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rax) (Width.W64)) { base := some (RegOrRip.reg (Reg64.rdi)), idx := none, disp := ConstExpr.int64 (-1) }))⟩,
  ⟨0x401029, 3, "L401029", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x40102c, 4, "L40102c", some (Instr.regular (Width.W64) (Width.W64) (Operation.imul none (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x401030, 3, "L401030", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))))))⟩,
  ⟨0x401033, 4, "L401033", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.imm (ConstExpr.int64 (-2)))))⟩,
  ⟨0x401037, 3, "L401037", some (Instr.regular (Width.W64) (Width.W64) (Operation.mul (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64)))))⟩,
  ⟨0x40103a, 3, "L40103a", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x40103d, 3, "L40103d", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401040, 5, "L401040", some (Instr.regular (Width.W64) (Width.W64) (Operation.shld (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Reg.low (Reg64.rcx) (Width.W64)) (ShiftCountExpr.imm8 (ConstExpr.int64 63))))⟩,
  ⟨0x401045, 3, "L401045", some (Instr.regular (Width.W64) (Width.W64) (Operation.sub (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401048, 1, "L401048", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x401049, 2, "L401049", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40104b, 1, "L40104b", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩]

/-- The lines of every function lowered here, in address order. -/
def image : List Lowering.X86.Line :=
  List.flatten [add3_code, max_u64_code, sum_to_code]

/-- The lines of the image follow one another. -/
theorem image_wf : Lowering.X86.wf image = true := by
  decide

/-- The executable of the image: the program of the machine model. -/
def exe : Executable := Lowering.X86.exeOf image

/-- `add3`, lowered to `braid`. -/
def add3 : Braid.Func :=
  { name := "add3", entry := 0x401000#64, blocks := [
    (0x401000#64, { ops := [.get 1 5, .get 2 4, .const 3 0x1#64, .bin 4 .mul 2 3, .bin 5 .add 1 4, .const 6 0x0#64, .bin 0 .add 5 6, .set 0 0], term := .jump 0x401004#64 }),
    (0x401004#64, { ops := [.get 0 3, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401007#64 }),
    (0x401007#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x401008#64, { ops := [], term := .jump 0x401010#64 })] }

/-- `add3` is the lowering of `add3_code`. -/
theorem add3_lowered :
    add3.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) add3_code := by
  decide

/-- The blocks of `add3` are blocks of the lowering of the executable. -/
theorem add3_holds :
    ∀ p ∈ add3.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) add3_lowered

/-- `max_u64`, lowered to `braid`. -/
def max_u64 : Braid.Func :=
  { name := "max_u64", entry := 0x401010#64, blocks := [
    (0x401010#64, { ops := [.get 0 4, .set 0 0], term := .jump 0x401013#64 }),
    (0x401013#64, { ops := [.get 0 5, .get 8 4, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401016#64 }),
    (0x401016#64, { ops := [.get 0 5, .get 8 0, .getf 17 0, .getf 18 3, .bin 19 .or 17 18, .const 20 0x0#64, .bin 16 .eq 19 20, .select 24 16 0 8, .set 0 24], term := .jump 0x40101a#64 }),
    (0x40101a#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x40101b#64, { ops := [], term := .jump 0x401020#64 })] }

/-- `max_u64` is the lowering of `max_u64_code`. -/
theorem max_u64_lowered :
    max_u64.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) max_u64_code := by
  decide

/-- The blocks of `max_u64` are blocks of the lowering of the executable. -/
theorem max_u64_holds :
    ∀ p ∈ max_u64.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.head _), h⟩) max_u64_lowered

/-- `sum_to`, lowered to `braid`. -/
def sum_to : Braid.Func :=
  { name := "sum_to", entry := 0x401020#64, blocks := [
    (0x401020#64, { ops := [.get 0 5, .get 8 5, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401023#64 }),
    (0x401023#64, { ops := [.getf 0 3], term := .branch 0 0x401049#64 0x401025#64 }),
    (0x401025#64, { ops := [.get 1 5, .const 2 0xffffffffffffffff#64, .bin 0 .add 1 2, .set 0 0], term := .jump 0x401029#64 }),
    (0x401029#64, { ops := [.get 0 0, .set 4 0], term := .jump 0x40102c#64 }),
    (0x40102c#64, { ops := [.get 0 4, .get 8 0, .bin 16 .mul 0 8, .set 4 16, .havoc 40, .setf 0 40, .setf 5 40, .havoc 41, .setf 4 41, .havoc 42, .setf 3 42, .havoc 43, .setf 2 43, .havoc 44, .setf 1 44], term := .jump 0x401030#64 }),
    (0x401030#64, { ops := [.get 0 5, .get 8 4, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 4 16], term := .jump 0x401033#64 }),
    (0x401033#64, { ops := [.const 0 0xfffffffffffffffe#64, .get 8 5, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 5 16], term := .jump 0x401037#64 }),
    (0x401037#64, { ops := [.get 0 0, .get 8 5, .bin 16 .mul 0 8, .bin 17 .mulhu 0 8, .const 18 0x0#64, .bin 19 .ne 17 18, .setf 0 19, .setf 5 19, .havoc 40, .setf 4 40, .havoc 41, .setf 3 41, .havoc 42, .setf 2 42, .havoc 43, .setf 1 43, .set 0 16, .set 3 17], term := .jump 0x40103a#64 }),
    (0x40103a#64, { ops := [.get 0 0, .set 2 0], term := .jump 0x40103d#64 }),
    (0x40103d#64, { ops := [.get 0 4, .set 0 0], term := .jump 0x401040#64 }),
    (0x401040#64, { ops := [], term := .trap "shld" }),
    (0x401045#64, { ops := [.get 0 3, .get 8 0, .bin 16 .sub 8 0, .bin 18 .ult 8 0, .setf 0 18, .bin 19 .xor 8 0, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401048#64 }),
    (0x401048#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x401049#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40104b#64 }),
    (0x40104b#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `sum_to` is the lowering of `sum_to_code`. -/
theorem sum_to_lowered :
    sum_to.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) sum_to_code := by
  decide

/-- The blocks of `sum_to` are blocks of the lowering of the executable. -/
theorem sum_to_holds :
    ∀ p ∈ sum_to.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)), h⟩) sum_to_lowered

end Examples.Basic.X86
