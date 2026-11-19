/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.Mem.X86


/-- The lines of `copy_bytes`, from `0x401000`. -/
def copy_bytes_code : List Lowering.X86.Line := [
  ⟨0x401000, 3, "L401000", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401003, 2, "L401003", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L40101f"))⟩,
  ⟨0x401005, 2, "L401005", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401007, 9, "L401007", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 9))⟩,
  ⟨0x401010, 4, "L401010", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rax, scale := Width.W8 }, disp := ConstExpr.int64 0 })))⟩,
  ⟨0x401014, 3, "L401014", some (Instr.regular (Width.W64) (Width.W8) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rax, scale := Width.W8 }, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))))))⟩,
  ⟨0x401017, 3, "L401017", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64)))))⟩,
  ⟨0x40101a, 3, "L40101a", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x40101d, 2, "L40101d", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401010"))⟩,
  ⟨0x40101f, 1, "L40101f", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩]

/-- The lines of `equal_bytes`, from `0x401020`. -/
def equal_bytes_code : List Lowering.X86.Line := [
  ⟨0x401020, 5, "L401020", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401025, 3, "L401025", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401028, 2, "L401028", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L401043"))⟩,
  ⟨0x40102a, 2, "L40102a", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x40102c, 4, "L40102c", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 4))⟩,
  ⟨0x401030, 5, "L401030", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 })))⟩,
  ⟨0x401035, 4, "L401035", some (Instr.regular (Width.W64) (Width.W8) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W8))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401039, 2, "L401039", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401044"))⟩,
  ⟨0x40103b, 3, "L40103b", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64)))))⟩,
  ⟨0x40103e, 3, "L40103e", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401041, 2, "L401041", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401030"))⟩,
  ⟨0x401043, 1, "L401043", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x401044, 2, "L401044", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401046, 1, "L401046", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x401047, 9, "L401047", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 9))⟩]

/-- The lines of `equal_bytes_ct`, from `0x401050`. -/
def equal_bytes_ct_code : List Lowering.X86.Line := [
  ⟨0x401050, 3, "L401050", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401053, 2, "L401053", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L40107c"))⟩,
  ⟨0x401055, 2, "L401055", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401057, 2, "L401057", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x401059, 7, "L401059", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 7))⟩,
  ⟨0x401060, 5, "L401060", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rax, scale := Width.W8 }, disp := ConstExpr.int64 0 })))⟩,
  ⟨0x401065, 4, "L401065", some (Instr.regular (Width.W64) (Width.W8) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W8))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rax, scale := Width.W8 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401069, 3, "L401069", some (Instr.regular (Width.W64) (Width.W8) (Operation.or (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W8))))))⟩,
  ⟨0x40106c, 3, "L40106c", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64)))))⟩,
  ⟨0x40106f, 3, "L40106f", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x401072, 2, "L401072", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401060"))⟩,
  ⟨0x401074, 2, "L401074", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401076, 2, "L401076", some (Instr.regular (Width.W64) (Width.W8) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))))))⟩,
  ⟨0x401078, 3, "L401078", some (Instr.regular (Width.W64) (Width.W8) (Operation.setcc (CondCode.z) (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W8)))))⟩,
  ⟨0x40107b, 1, "L40107b", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x40107c, 5, "L40107c", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401081, 1, "L401081", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩]

/-- The lines of every function lowered here, in address order. -/
def image : List Lowering.X86.Line :=
  List.flatten [copy_bytes_code, equal_bytes_code, equal_bytes_ct_code]

/-- The lines of the image follow one another. -/
theorem image_wf : Lowering.X86.wf image = true := by
  decide

/-- The executable of the image: the program of the machine model. -/
def exe : Executable := Lowering.X86.exeOf image

/-- `copy_bytes`, lowered to `braid`. -/
def copy_bytes : Braid.Func :=
  { name := "copy_bytes", entry := 0x401000#64, blocks := [
    (0x401000#64, { ops := [.get 0 3, .get 8 3, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401003#64 }),
    (0x401003#64, { ops := [.getf 0 3], term := .branch 0 0x40101f#64 0x401005#64 }),
    (0x401005#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401007#64 }),
    (0x401007#64, { ops := [], term := .jump 0x401010#64 }),
    (0x401010#64, { ops := [.get 2 4, .get 3 0, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 2 0], term := .jump 0x401014#64 }),
    (0x401014#64, { ops := [.get 1 2, .un 0 (.zext 8) 1, .get 9 5, .get 10 0, .const 11 0x1#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x0#64, .bin 8 .add 13 14, .store .w8 8 0], term := .jump 0x401017#64 }),
    (0x401017#64, { ops := [.get 0 0, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40101a#64 }),
    (0x40101a#64, { ops := [.get 0 3, .get 8 0, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40101d#64 }),
    (0x40101d#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401010#64 0x40101f#64 }),
    (0x40101f#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `copy_bytes` is the lowering of `copy_bytes_code`. -/
theorem copy_bytes_lowered :
    copy_bytes.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) copy_bytes_code := by
  decide

/-- The blocks of `copy_bytes` are blocks of the lowering of the executable. -/
theorem copy_bytes_holds :
    ∀ p ∈ copy_bytes.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) copy_bytes_lowered

/-- `equal_bytes`, lowered to `braid`. -/
def equal_bytes : Braid.Func :=
  { name := "equal_bytes", entry := 0x401020#64, blocks := [
    (0x401020#64, { ops := [.const 0 0x1#64, .set 0 0], term := .jump 0x401025#64 }),
    (0x401025#64, { ops := [.get 0 3, .get 8 3, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401028#64 }),
    (0x401028#64, { ops := [.getf 0 3], term := .branch 0 0x401043#64 0x40102a#64 }),
    (0x40102a#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x40102c#64 }),
    (0x40102c#64, { ops := [], term := .jump 0x401030#64 }),
    (0x401030#64, { ops := [.get 2 5, .get 3 2, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 8 0], term := .jump 0x401035#64 }),
    (0x401035#64, { ops := [.get 1 8, .un 0 (.zext 8) 1, .get 10 4, .get 11 2, .const 12 0x1#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w8 9, .bin 16 .sub 0 8, .un 17 (.zext 8) 16, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 17, .bin 21 .and 19 20, .const 22 0x80#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 17 39, .setf 4 40], term := .jump 0x401039#64 }),
    (0x401039#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401044#64 0x40103b#64 }),
    (0x40103b#64, { ops := [.get 0 2, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x40103e#64 }),
    (0x40103e#64, { ops := [.get 0 3, .get 8 2, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401041#64 }),
    (0x401041#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401030#64 0x401043#64 }),
    (0x401043#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x401044#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401046#64 }),
    (0x401046#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x401047#64, { ops := [], term := .jump 0x401050#64 })] }

/-- `equal_bytes` is the lowering of `equal_bytes_code`. -/
theorem equal_bytes_lowered :
    equal_bytes.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) equal_bytes_code := by
  decide

/-- The blocks of `equal_bytes` are blocks of the lowering of the executable. -/
theorem equal_bytes_holds :
    ∀ p ∈ equal_bytes.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.head _), h⟩) equal_bytes_lowered

/-- `equal_bytes_ct`, lowered to `braid`. -/
def equal_bytes_ct : Braid.Func :=
  { name := "equal_bytes_ct", entry := 0x401050#64, blocks := [
    (0x401050#64, { ops := [.get 0 3, .get 8 3, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401053#64 }),
    (0x401053#64, { ops := [.getf 0 3], term := .branch 0 0x40107c#64 0x401055#64 }),
    (0x401055#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401057#64 }),
    (0x401057#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x401059#64 }),
    (0x401059#64, { ops := [], term := .jump 0x401060#64 }),
    (0x401060#64, { ops := [.get 2 4, .get 3 0, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 8 0], term := .jump 0x401065#64 }),
    (0x401065#64, { ops := [.get 1 8, .un 0 (.zext 8) 1, .get 10 5, .get 11 0, .const 12 0x1#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w8 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 8, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 8 51], term := .jump 0x401069#64 }),
    (0x401069#64, { ops := [.get 1 2, .un 0 (.zext 8) 1, .get 9 8, .un 8 (.zext 8) 9, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 2, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 2 51], term := .jump 0x40106c#64 }),
    (0x40106c#64, { ops := [.get 0 0, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40106f#64 }),
    (0x40106f#64, { ops := [.get 0 3, .get 8 0, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401072#64 }),
    (0x401072#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401060#64 0x401074#64 }),
    (0x401074#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401076#64 }),
    (0x401076#64, { ops := [.get 1 2, .un 0 (.zext 8) 1, .get 9 2, .un 8 (.zext 8) 9, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401078#64 }),
    (0x401078#64, { ops := [.getf 0 3, .get 8 0, .const 9 0xffffffffffffff00#64, .bin 10 .and 8 9, .bin 11 .or 10 0, .set 0 11], term := .jump 0x40107b#64 }),
    (0x40107b#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x40107c#64, { ops := [.const 0 0x1#64, .set 0 0], term := .jump 0x401081#64 }),
    (0x401081#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `equal_bytes_ct` is the lowering of `equal_bytes_ct_code`. -/
theorem equal_bytes_ct_lowered :
    equal_bytes_ct.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) equal_bytes_ct_code := by
  decide

/-- The blocks of `equal_bytes_ct` are blocks of the lowering of the executable. -/
theorem equal_bytes_ct_holds :
    ∀ p ∈ equal_bytes_ct.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)), h⟩) equal_bytes_ct_lowered

end Examples.Mem.X86
