/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.Memory.X86


/-- The lines of `swap`, from `0x401000`. -/
def swap_code : List Lowering.X86.Line := [
  ⟨0x401000, 3, "L401000", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := none, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401003, 3, "L401003", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := none, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401006, 3, "L401006", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := none, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401009, 3, "L401009", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := none, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x40100c, 1, "L40100c", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x40100d, 3, "L40100d", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 3))⟩]

/-- The lines of `sum_array`, from `0x401010`. -/
def sum_array_code : List Lowering.X86.Line := [
  ⟨0x401010, 2, "L401010", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401012, 3, "L401012", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401015, 2, "L401015", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L40102c"))⟩,
  ⟨0x401017, 2, "L401017", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x401019, 7, "L401019", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 7))⟩,
  ⟨0x401020, 4, "L401020", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rcx, scale := Width.W64 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401024, 3, "L401024", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64)))))⟩,
  ⟨0x401027, 3, "L401027", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x40102a, 2, "L40102a", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401020"))⟩,
  ⟨0x40102c, 1, "L40102c", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x40102d, 3, "L40102d", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 3))⟩]

/-- The lines of `max2`, from `0x401030`. -/
def max2_code : List Lowering.X86.Line := [
  ⟨0x401030, 3, "L401030", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401033, 3, "L401033", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401036, 4, "L401036", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmovcc (CondCode.a) (Reg.low (Reg64.rax) (Width.W64)) (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64)))))⟩,
  ⟨0x40103a, 1, "L40103a", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x40103b, 5, "L40103b", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 5))⟩]

/-- The lines of `max3`, from `0x401040`. -/
def max3_code : List Lowering.X86.Line := [
  ⟨0x401040, 1, "L401040", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64))))))⟩,
  ⟨0x401041, 3, "L401041", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401044, 5, "L401044", some (Instr.regular (Width.W64) (Width.W64) (Operation.call (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4198448) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x401049, 3, "L401049", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x40104c, 3, "L40104c", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64))))))⟩,
  ⟨0x40104f, 1, "L40104f", some (Instr.regular (Width.W64) (Width.W64) (Operation.pop (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64)))))⟩,
  ⟨0x401050, 5, "L401050", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4198448) (ConstExpr.after_current_instruction)))))⟩]

/-- The lines of every function lowered here, in address order. -/
def image : List Lowering.X86.Line :=
  List.flatten [swap_code, sum_array_code, max2_code, max3_code]

/-- The lines of the image follow one another. -/
theorem image_wf : Lowering.X86.wf image = true := by
  decide

/-- The executable of the image: the program of the machine model. -/
def exe : Executable := Lowering.X86.exeOf image

/-- `swap`, lowered to `braid`. -/
def swap : Braid.Func :=
  { name := "swap", entry := 0x401000#64, blocks := [
    (0x401000#64, { ops := [.get 1 5, .load 0 .w64 1, .set 0 0], term := .jump 0x401003#64 }),
    (0x401003#64, { ops := [.get 1 4, .load 0 .w64 1, .set 2 0], term := .jump 0x401006#64 }),
    (0x401006#64, { ops := [.get 0 2, .get 8 5, .store .w64 8 0], term := .jump 0x401009#64 }),
    (0x401009#64, { ops := [.get 0 0, .get 8 4, .store .w64 8 0], term := .jump 0x40100c#64 }),
    (0x40100c#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x40100d#64, { ops := [], term := .jump 0x401010#64 })] }

/-- `swap` is the lowering of `swap_code`. -/
theorem swap_lowered :
    swap.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) swap_code := by
  decide

/-- The blocks of `swap` are blocks of the lowering of the executable. -/
theorem swap_holds :
    ∀ p ∈ swap.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) swap_lowered

/-- `sum_array`, lowered to `braid`. -/
def sum_array : Braid.Func :=
  { name := "sum_array", entry := 0x401010#64, blocks := [
    (0x401010#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401012#64 }),
    (0x401012#64, { ops := [.get 0 4, .get 8 4, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401015#64 }),
    (0x401015#64, { ops := [.getf 0 3], term := .branch 0 0x40102c#64 0x401017#64 }),
    (0x401017#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x401019#64 }),
    (0x401019#64, { ops := [], term := .jump 0x401020#64 }),
    (0x401020#64, { ops := [.get 2 5, .get 3 2, .const 4 0x8#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w64 1, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401024#64 }),
    (0x401024#64, { ops := [.get 0 2, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x401027#64 }),
    (0x401027#64, { ops := [.get 0 4, .get 8 2, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40102a#64 }),
    (0x40102a#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401020#64 0x40102c#64 }),
    (0x40102c#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x40102d#64, { ops := [], term := .jump 0x401030#64 })] }

/-- `sum_array` is the lowering of `sum_array_code`. -/
theorem sum_array_lowered :
    sum_array.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) sum_array_code := by
  decide

/-- The blocks of `sum_array` are blocks of the lowering of the executable. -/
theorem sum_array_holds :
    ∀ p ∈ sum_array.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.head _), h⟩) sum_array_lowered

/-- `max2`, lowered to `braid`. -/
def max2 : Braid.Func :=
  { name := "max2", entry := 0x401030#64, blocks := [
    (0x401030#64, { ops := [.get 0 4, .set 0 0], term := .jump 0x401033#64 }),
    (0x401033#64, { ops := [.get 0 5, .get 8 4, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401036#64 }),
    (0x401036#64, { ops := [.get 0 5, .get 8 0, .getf 17 0, .getf 18 3, .bin 19 .or 17 18, .const 20 0x0#64, .bin 16 .eq 19 20, .select 24 16 0 8, .set 0 24], term := .jump 0x40103a#64 }),
    (0x40103a#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x40103b#64, { ops := [], term := .jump 0x401040#64 })] }

/-- `max2` is the lowering of `max2_code`. -/
theorem max2_lowered :
    max2.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) max2_code := by
  decide

/-- The blocks of `max2` are blocks of the lowering of the executable. -/
theorem max2_holds :
    ∀ p ∈ max2.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)), h⟩) max2_lowered

/-- `max3`, lowered to `braid`. -/
def max3 : Braid.Func :=
  { name := "max3", entry := 0x401040#64, blocks := [
    (0x401040#64, { ops := [.get 0 1, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x401041#64 }),
    (0x401041#64, { ops := [.get 0 3, .set 1 0], term := .jump 0x401044#64 }),
    (0x401044#64, { ops := [.get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .const 11 0x401049#64, .store .w64 10 11], term := .jump 0x401030#64 }),
    (0x401049#64, { ops := [.get 0 0, .set 5 0], term := .jump 0x40104c#64 }),
    (0x40104c#64, { ops := [.get 0 1, .set 4 0], term := .jump 0x40104f#64 }),
    (0x40104f#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3, .set 1 1], term := .jump 0x401050#64 }),
    (0x401050#64, { ops := [], term := .jump 0x401030#64 })] }

/-- `max3` is the lowering of `max3_code`. -/
theorem max3_lowered :
    max3.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) max3_code := by
  decide

/-- The blocks of `max3` are blocks of the lowering of the executable. -/
theorem max3_holds :
    ∀ p ∈ max3.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))), h⟩) max3_lowered

end Examples.Memory.X86
