/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.SwiftBasic.X86


/-- The lines of `swift_add3`, from `0x401000`. -/
def swift_add3_code : List Lowering.X86.Line := [
  ⟨0x401000, 4, "L401000", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rax) (Width.W64)) { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rsi, scale := Width.W8 }, disp := ConstExpr.int64 0 }))⟩,
  ⟨0x401004, 3, "L401004", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401007, 1, "L401007", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x401008, 1, "L401008", none⟩,
  ⟨0x401009, 1, "L401009", none⟩,
  ⟨0x40100a, 1, "L40100a", none⟩,
  ⟨0x40100b, 1, "L40100b", none⟩,
  ⟨0x40100c, 1, "L40100c", none⟩,
  ⟨0x40100d, 1, "L40100d", none⟩,
  ⟨0x40100e, 1, "L40100e", none⟩,
  ⟨0x40100f, 1, "L40100f", none⟩,
  ⟨0x401010, 16, "G401010", none⟩]

/-- The lines of `swift_gcd`, from `0x401020`. -/
def swift_gcd_code : List Lowering.X86.Line := [
  ⟨0x401020, 3, "L401020", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))))))⟩,
  ⟨0x401023, 3, "L401023", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401026, 2, "L401026", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L401043"))⟩,
  ⟨0x401028, 3, "L401028", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x40102b, 5, "L40102b", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 5))⟩,
  ⟨0x401030, 3, "L401030", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401033, 2, "L401033", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x401035, 3, "L401035", none⟩,
  ⟨0x401038, 3, "L401038", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x40103b, 3, "L40103b", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x40103e, 2, "L40103e", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401030"))⟩,
  ⟨0x401040, 3, "L401040", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401043, 1, "L401043", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x401044, 1, "L401044", none⟩,
  ⟨0x401045, 1, "L401045", none⟩,
  ⟨0x401046, 1, "L401046", none⟩,
  ⟨0x401047, 1, "L401047", none⟩,
  ⟨0x401048, 1, "L401048", none⟩,
  ⟨0x401049, 1, "L401049", none⟩,
  ⟨0x40104a, 1, "L40104a", none⟩,
  ⟨0x40104b, 1, "L40104b", none⟩,
  ⟨0x40104c, 1, "L40104c", none⟩,
  ⟨0x40104d, 1, "L40104d", none⟩,
  ⟨0x40104e, 1, "L40104e", none⟩,
  ⟨0x40104f, 1, "L40104f", none⟩,
  ⟨0x401050, 48, "G401050", none⟩]

/-- The lines of `swift_min`, from `0x401080`. -/
def swift_min_code : List Lowering.X86.Line := [
  ⟨0x401080, 3, "L401080", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401083, 3, "L401083", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401086, 4, "L401086", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmovcc (CondCode.c) (Reg.low (Reg64.rax) (Width.W64)) (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64)))))⟩,
  ⟨0x40108a, 1, "L40108a", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x40108b, 1, "L40108b", none⟩,
  ⟨0x40108c, 1, "L40108c", none⟩,
  ⟨0x40108d, 1, "L40108d", none⟩,
  ⟨0x40108e, 1, "L40108e", none⟩,
  ⟨0x40108f, 1, "L40108f", none⟩]

/-- The lines of every function lowered here, in address order. -/
def image : List Lowering.X86.Line :=
  List.flatten [swift_add3_code, swift_gcd_code, swift_min_code]

/-- The lines of the image follow one another. -/
theorem image_wf : Lowering.X86.wf image = true := by
  decide

/-- The executable of the image: the program of the machine model. -/
def exe : Executable := Lowering.X86.exeOf image

/-- `swift_add3`, lowered to `braid`. -/
def swift_add3 : Braid.Func :=
  { name := "swift_add3", entry := 0x401000#64, blocks := [
    (0x401000#64, { ops := [.get 1 5, .get 2 4, .const 3 0x1#64, .bin 4 .mul 2 3, .bin 5 .add 1 4, .const 6 0x0#64, .bin 0 .add 5 6, .set 0 0], term := .jump 0x401004#64 }),
    (0x401004#64, { ops := [.get 0 3, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401007#64 }),
    (0x401007#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `swift_add3` is the lowering of `swift_add3_code`. -/
theorem swift_add3_lowered :
    swift_add3.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) swift_add3_code := by
  decide

/-- The blocks of `swift_add3` are blocks of the lowering of the executable. -/
theorem swift_add3_holds :
    ∀ p ∈ swift_add3.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) swift_add3_lowered

/-- `swift_gcd`, lowered to `braid`. -/
def swift_gcd : Braid.Func :=
  { name := "swift_gcd", entry := 0x401020#64, blocks := [
    (0x401020#64, { ops := [.get 0 5, .set 0 0], term := .jump 0x401023#64 }),
    (0x401023#64, { ops := [.get 0 4, .get 8 4, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401026#64 }),
    (0x401026#64, { ops := [.getf 0 3], term := .branch 0 0x401043#64 0x401028#64 }),
    (0x401028#64, { ops := [.get 0 4, .set 3 0], term := .jump 0x40102b#64 }),
    (0x40102b#64, { ops := [], term := .jump 0x401030#64 }),
    (0x401030#64, { ops := [.get 0 3, .set 2 0], term := .jump 0x401033#64 }),
    (0x401033#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 9 3, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x401035#64 }),
    (0x401038#64, { ops := [.get 0 2, .set 0 0], term := .jump 0x40103b#64 }),
    (0x40103b#64, { ops := [.get 0 3, .get 8 3, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40103e#64 }),
    (0x40103e#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401030#64 0x401040#64 }),
    (0x401040#64, { ops := [.get 0 2, .set 0 0], term := .jump 0x401043#64 }),
    (0x401043#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `swift_gcd` is the lowering of `swift_gcd_code`. -/
theorem swift_gcd_lowered :
    swift_gcd.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) swift_gcd_code := by
  decide

/-- The blocks of `swift_gcd` are blocks of the lowering of the executable. -/
theorem swift_gcd_holds :
    ∀ p ∈ swift_gcd.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.head _), h⟩) swift_gcd_lowered

/-- `swift_min`, lowered to `braid`. -/
def swift_min : Braid.Func :=
  { name := "swift_min", entry := 0x401080#64, blocks := [
    (0x401080#64, { ops := [.get 0 4, .set 0 0], term := .jump 0x401083#64 }),
    (0x401083#64, { ops := [.get 0 5, .get 8 4, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401086#64 }),
    (0x401086#64, { ops := [.get 0 5, .get 8 0, .getf 16 0, .select 24 16 0 8, .set 0 24], term := .jump 0x40108a#64 }),
    (0x40108a#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `swift_min` is the lowering of `swift_min_code`. -/
theorem swift_min_lowered :
    swift_min.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) swift_min_code := by
  decide

/-- The blocks of `swift_min` are blocks of the lowering of the executable. -/
theorem swift_min_holds :
    ∀ p ∈ swift_min.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)), h⟩) swift_min_lowered

end Examples.SwiftBasic.X86
