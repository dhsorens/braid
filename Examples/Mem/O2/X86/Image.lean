/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.Mem.O2.X86


/-- The lines of `copy_bytes`, from `0x401000`. -/
def copy_bytes_code : List Lowering.X86.Line := [
  ⟨0x401000, 3, "L401000", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401003, 2, "L401003", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L40106f"))⟩,
  ⟨0x401005, 2, "L401005", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x401007, 3, "L401007", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.imm (ConstExpr.int64 3))))⟩,
  ⟨0x40100a, 4, "L40100a", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.imm (ConstExpr.int64 4))))⟩,
  ⟨0x40100e, 2, "L40100e", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nc) "L401014"))⟩,
  ⟨0x401010, 2, "L401010", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x401012, 2, "L401012", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4198488) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x401014, 4, "L401014", some (Instr.regular (Width.W64) (Width.W64) (Operation.and (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.imm (ConstExpr.int64 (-4)))))⟩,
  ⟨0x401018, 2, "L401018", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x40101a, 6, "L40101a", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 6))⟩,
  ⟨0x401020, 5, "L401020", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 })))⟩,
  ⟨0x401025, 4, "L401025", some (Instr.regular (Width.W64) (Width.W8) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W8))))))⟩,
  ⟨0x401029, 6, "L401029", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 1 })))⟩,
  ⟨0x40102f, 5, "L40102f", some (Instr.regular (Width.W64) (Width.W8) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 1 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W8))))))⟩,
  ⟨0x401034, 6, "L401034", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 2 })))⟩,
  ⟨0x40103a, 5, "L40103a", some (Instr.regular (Width.W64) (Width.W8) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 2 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W8))))))⟩,
  ⟨0x40103f, 6, "L40103f", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 3 })))⟩,
  ⟨0x401045, 5, "L401045", some (Instr.regular (Width.W64) (Width.W8) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 3 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W8))))))⟩,
  ⟨0x40104a, 4, "L40104a", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.imm (ConstExpr.int64 4))))⟩,
  ⟨0x40104e, 3, "L40104e", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401051, 2, "L401051", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401020"))⟩,
  ⟨0x401053, 3, "L401053", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x401056, 2, "L401056", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L40106f"))⟩,
  ⟨0x401058, 3, "L401058", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x40105b, 3, "L40105b", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x40105e, 2, "L40105e", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x401060, 4, "L401060", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 })))⟩,
  ⟨0x401064, 3, "L401064", some (Instr.regular (Width.W64) (Width.W8) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W8))))))⟩,
  ⟨0x401067, 3, "L401067", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64)))))⟩,
  ⟨0x40106a, 3, "L40106a", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x40106d, 2, "L40106d", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401060"))⟩,
  ⟨0x40106f, 1, "L40106f", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩]

/-- The lines of `equal_bytes`, from `0x401070`. -/
def equal_bytes_code : List Lowering.X86.Line := [
  ⟨0x401070, 5, "L401070", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401075, 3, "L401075", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401078, 2, "L401078", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L401093"))⟩,
  ⟨0x40107a, 2, "L40107a", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x40107c, 4, "L40107c", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 4))⟩,
  ⟨0x401080, 5, "L401080", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 })))⟩,
  ⟨0x401085, 4, "L401085", some (Instr.regular (Width.W64) (Width.W8) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W8))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401089, 2, "L401089", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401094"))⟩,
  ⟨0x40108b, 3, "L40108b", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64)))))⟩,
  ⟨0x40108e, 3, "L40108e", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x401091, 2, "L401091", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401080"))⟩,
  ⟨0x401093, 1, "L401093", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x401094, 2, "L401094", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401096, 1, "L401096", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x401097, 9, "L401097", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 9))⟩]

/-- The lines of `equal_bytes_ct`, from `0x4010a0`. -/
def equal_bytes_ct_code : List Lowering.X86.Line := [
  ⟨0x4010a0, 3, "L4010a0", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x4010a3, 2, "L4010a3", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L4010b7"))⟩,
  ⟨0x4010a5, 2, "L4010a5", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x4010a7, 3, "L4010a7", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.imm (ConstExpr.int64 3))))⟩,
  ⟨0x4010aa, 4, "L4010aa", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.imm (ConstExpr.int64 4))))⟩,
  ⟨0x4010ae, 2, "L4010ae", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nc) "L4010bd"))⟩,
  ⟨0x4010b0, 3, "L4010b0", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x4010b3, 2, "L4010b3", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x4010b5, 2, "L4010b5", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4198676) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x4010b7, 5, "L4010b7", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x4010bc, 1, "L4010bc", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x4010bd, 4, "L4010bd", some (Instr.regular (Width.W64) (Width.W64) (Operation.and (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.imm (ConstExpr.int64 (-4)))))⟩,
  ⟨0x4010c1, 3, "L4010c1", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x4010c4, 2, "L4010c4", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x4010c6, 10, "L4010c6", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 10))⟩,
  ⟨0x4010d0, 5, "L4010d0", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.r8, scale := Width.W8 }, disp := ConstExpr.int64 0 })))⟩,
  ⟨0x4010d5, 6, "L4010d5", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.r8, scale := Width.W8 }, disp := ConstExpr.int64 1 })))⟩,
  ⟨0x4010db, 4, "L4010db", some (Instr.regular (Width.W64) (Width.W8) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W8))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.r8, scale := Width.W8 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x4010df, 5, "L4010df", some (Instr.regular (Width.W64) (Width.W8) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W8))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.r8, scale := Width.W8 }, disp := ConstExpr.int64 1 }))))⟩,
  ⟨0x4010e4, 3, "L4010e4", some (Instr.regular (Width.W64) (Width.W8) (Operation.or (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W8))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))))))⟩,
  ⟨0x4010e7, 6, "L4010e7", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.r8, scale := Width.W8 }, disp := ConstExpr.int64 2 })))⟩,
  ⟨0x4010ed, 5, "L4010ed", some (Instr.regular (Width.W64) (Width.W8) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W8))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.r8, scale := Width.W8 }, disp := ConstExpr.int64 2 }))))⟩,
  ⟨0x4010f2, 3, "L4010f2", some (Instr.regular (Width.W64) (Width.W8) (Operation.or (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W8))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W8))))))⟩,
  ⟨0x4010f5, 6, "L4010f5", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.r8, scale := Width.W8 }, disp := ConstExpr.int64 3 })))⟩,
  ⟨0x4010fb, 5, "L4010fb", some (Instr.regular (Width.W64) (Width.W8) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.r8, scale := Width.W8 }, disp := ConstExpr.int64 3 }))))⟩,
  ⟨0x401100, 3, "L401100", some (Instr.regular (Width.W64) (Width.W8) (Operation.or (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W8))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W8))))))⟩,
  ⟨0x401103, 3, "L401103", some (Instr.regular (Width.W64) (Width.W8) (Operation.or (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W8))))))⟩,
  ⟨0x401106, 4, "L401106", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))) (Operand.imm (ConstExpr.int64 4))))⟩,
  ⟨0x40110a, 3, "L40110a", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))))))⟩,
  ⟨0x40110d, 2, "L40110d", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L4010d0"))⟩,
  ⟨0x40110f, 3, "L40110f", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x401112, 2, "L401112", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L401134"))⟩,
  ⟨0x401114, 3, "L401114", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))))))⟩,
  ⟨0x401117, 3, "L401117", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))))))⟩,
  ⟨0x40111a, 2, "L40111a", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x40111c, 4, "L40111c", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 4))⟩,
  ⟨0x401120, 5, "L401120", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rdx, scale := Width.W8 }, disp := ConstExpr.int64 0 })))⟩,
  ⟨0x401125, 4, "L401125", some (Instr.regular (Width.W64) (Width.W8) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W8))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rdx, scale := Width.W8 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401129, 3, "L401129", some (Instr.regular (Width.W64) (Width.W8) (Operation.or (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W8))))))⟩,
  ⟨0x40112c, 3, "L40112c", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64)))))⟩,
  ⟨0x40112f, 3, "L40112f", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401132, 2, "L401132", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401120"))⟩,
  ⟨0x401134, 2, "L401134", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401136, 2, "L401136", some (Instr.regular (Width.W64) (Width.W8) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))))))⟩,
  ⟨0x401138, 3, "L401138", some (Instr.regular (Width.W64) (Width.W8) (Operation.setcc (CondCode.z) (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W8)))))⟩,
  ⟨0x40113b, 1, "L40113b", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩]

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
    (0x401003#64, { ops := [.getf 0 3], term := .branch 0 0x40106f#64 0x401005#64 }),
    (0x401005#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .set 0 0], term := .jump 0x401007#64 }),
    (0x401007#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .const 8 0x3#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40100a#64 }),
    (0x40100a#64, { ops := [.get 0 3, .const 8 0x4#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40100e#64 }),
    (0x40100e#64, { ops := [.getf 1 0, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401014#64 0x401010#64 }),
    (0x401010#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x401012#64 }),
    (0x401012#64, { ops := [], term := .jump 0x401058#64 }),
    (0x401014#64, { ops := [.get 0 3, .const 8 0xfffffffffffffffc#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x401018#64 }),
    (0x401018#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x40101a#64 }),
    (0x40101a#64, { ops := [], term := .jump 0x401020#64 }),
    (0x401020#64, { ops := [.get 2 4, .get 3 2, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 8 0], term := .jump 0x401025#64 }),
    (0x401025#64, { ops := [.get 1 8, .un 0 (.zext 8) 1, .get 9 5, .get 10 2, .const 11 0x1#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x0#64, .bin 8 .add 13 14, .store .w8 8 0], term := .jump 0x401029#64 }),
    (0x401029#64, { ops := [.get 2 4, .get 3 2, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x1#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 8 0], term := .jump 0x40102f#64 }),
    (0x40102f#64, { ops := [.get 1 8, .un 0 (.zext 8) 1, .get 9 5, .get 10 2, .const 11 0x1#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x1#64, .bin 8 .add 13 14, .store .w8 8 0], term := .jump 0x401034#64 }),
    (0x401034#64, { ops := [.get 2 4, .get 3 2, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x2#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 8 0], term := .jump 0x40103a#64 }),
    (0x40103a#64, { ops := [.get 1 8, .un 0 (.zext 8) 1, .get 9 5, .get 10 2, .const 11 0x1#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x2#64, .bin 8 .add 13 14, .store .w8 8 0], term := .jump 0x40103f#64 }),
    (0x40103f#64, { ops := [.get 2 4, .get 3 2, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x3#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 8 0], term := .jump 0x401045#64 }),
    (0x401045#64, { ops := [.get 1 8, .un 0 (.zext 8) 1, .get 9 5, .get 10 2, .const 11 0x1#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x3#64, .bin 8 .add 13 14, .store .w8 8 0], term := .jump 0x40104a#64 }),
    (0x40104a#64, { ops := [.const 0 0x4#64, .get 8 2, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x40104e#64 }),
    (0x40104e#64, { ops := [.get 0 3, .get 8 2, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401051#64 }),
    (0x401051#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401020#64 0x401053#64 }),
    (0x401053#64, { ops := [.get 0 0, .get 8 0, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401056#64 }),
    (0x401056#64, { ops := [.getf 0 3], term := .branch 0 0x40106f#64 0x401058#64 }),
    (0x401058#64, { ops := [.get 0 2, .get 8 5, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 5 16], term := .jump 0x40105b#64 }),
    (0x40105b#64, { ops := [.get 0 2, .get 8 4, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 4 16], term := .jump 0x40105e#64 }),
    (0x40105e#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x401060#64 }),
    (0x401060#64, { ops := [.get 2 4, .get 3 2, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 3 0], term := .jump 0x401064#64 }),
    (0x401064#64, { ops := [.get 1 3, .un 0 (.zext 8) 1, .get 9 5, .get 10 2, .const 11 0x1#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x0#64, .bin 8 .add 13 14, .store .w8 8 0], term := .jump 0x401067#64 }),
    (0x401067#64, { ops := [.get 0 2, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x40106a#64 }),
    (0x40106a#64, { ops := [.get 0 0, .get 8 2, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40106d#64 }),
    (0x40106d#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401060#64 0x40106f#64 }),
    (0x40106f#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

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
  { name := "equal_bytes", entry := 0x401070#64, blocks := [
    (0x401070#64, { ops := [.const 0 0x1#64, .set 0 0], term := .jump 0x401075#64 }),
    (0x401075#64, { ops := [.get 0 3, .get 8 3, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401078#64 }),
    (0x401078#64, { ops := [.getf 0 3], term := .branch 0 0x401093#64 0x40107a#64 }),
    (0x40107a#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x40107c#64 }),
    (0x40107c#64, { ops := [], term := .jump 0x401080#64 }),
    (0x401080#64, { ops := [.get 2 5, .get 3 2, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 8 0], term := .jump 0x401085#64 }),
    (0x401085#64, { ops := [.get 1 8, .un 0 (.zext 8) 1, .get 10 4, .get 11 2, .const 12 0x1#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w8 9, .bin 16 .sub 0 8, .un 17 (.zext 8) 16, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 17, .bin 21 .and 19 20, .const 22 0x80#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 17 39, .setf 4 40], term := .jump 0x401089#64 }),
    (0x401089#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401094#64 0x40108b#64 }),
    (0x40108b#64, { ops := [.get 0 2, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x40108e#64 }),
    (0x40108e#64, { ops := [.get 0 3, .get 8 2, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401091#64 }),
    (0x401091#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401080#64 0x401093#64 }),
    (0x401093#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x401094#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401096#64 }),
    (0x401096#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x401097#64, { ops := [], term := .jump 0x4010a0#64 })] }

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
  { name := "equal_bytes_ct", entry := 0x4010a0#64, blocks := [
    (0x4010a0#64, { ops := [.get 0 3, .get 8 3, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x4010a3#64 }),
    (0x4010a3#64, { ops := [.getf 0 3], term := .branch 0 0x4010b7#64 0x4010a5#64 }),
    (0x4010a5#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .set 0 0], term := .jump 0x4010a7#64 }),
    (0x4010a7#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .const 8 0x3#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x4010aa#64 }),
    (0x4010aa#64, { ops := [.get 0 3, .const 8 0x4#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x4010ae#64 }),
    (0x4010ae#64, { ops := [.getf 1 0, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x4010bd#64 0x4010b0#64 }),
    (0x4010b0#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 9 8, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 8 16], term := .jump 0x4010b3#64 }),
    (0x4010b3#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x4010b5#64 }),
    (0x4010b5#64, { ops := [], term := .jump 0x401114#64 }),
    (0x4010b7#64, { ops := [.const 0 0x1#64, .set 0 0], term := .jump 0x4010bc#64 }),
    (0x4010bc#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 }),
    (0x4010bd#64, { ops := [.get 0 3, .const 8 0xfffffffffffffffc#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x4010c1#64 }),
    (0x4010c1#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 9 8, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 8 16], term := .jump 0x4010c4#64 }),
    (0x4010c4#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x4010c6#64 }),
    (0x4010c6#64, { ops := [], term := .jump 0x4010d0#64 }),
    (0x4010d0#64, { ops := [.get 2 4, .get 3 8, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 9 0], term := .jump 0x4010d5#64 }),
    (0x4010d5#64, { ops := [.get 2 4, .get 3 8, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x1#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 10 0], term := .jump 0x4010db#64 }),
    (0x4010db#64, { ops := [.get 1 9, .un 0 (.zext 8) 1, .get 10 5, .get 11 8, .const 12 0x1#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w8 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 9, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 9 51], term := .jump 0x4010df#64 }),
    (0x4010df#64, { ops := [.get 1 10, .un 0 (.zext 8) 1, .get 10 5, .get 11 8, .const 12 0x1#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x1#64, .bin 9 .add 14 15, .load 8 .w8 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 10, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 10 51], term := .jump 0x4010e4#64 }),
    (0x4010e4#64, { ops := [.get 1 9, .un 0 (.zext 8) 1, .get 9 2, .un 8 (.zext 8) 9, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 9, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 9 51], term := .jump 0x4010e7#64 }),
    (0x4010e7#64, { ops := [.get 2 4, .get 3 8, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x2#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 11 0], term := .jump 0x4010ed#64 }),
    (0x4010ed#64, { ops := [.get 1 11, .un 0 (.zext 8) 1, .get 10 5, .get 11 8, .const 12 0x1#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x2#64, .bin 9 .add 14 15, .load 8 .w8 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 11, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 11 51], term := .jump 0x4010f2#64 }),
    (0x4010f2#64, { ops := [.get 1 11, .un 0 (.zext 8) 1, .get 9 10, .un 8 (.zext 8) 9, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 11, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 11 51], term := .jump 0x4010f5#64 }),
    (0x4010f5#64, { ops := [.get 2 4, .get 3 8, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x3#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 2 0], term := .jump 0x4010fb#64 }),
    (0x4010fb#64, { ops := [.get 1 2, .un 0 (.zext 8) 1, .get 10 5, .get 11 8, .const 12 0x1#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x3#64, .bin 9 .add 14 15, .load 8 .w8 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 2, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 2 51], term := .jump 0x401100#64 }),
    (0x401100#64, { ops := [.get 1 11, .un 0 (.zext 8) 1, .get 9 9, .un 8 (.zext 8) 9, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 11, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 11 51], term := .jump 0x401103#64 }),
    (0x401103#64, { ops := [.get 1 2, .un 0 (.zext 8) 1, .get 9 11, .un 8 (.zext 8) 9, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 2, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 2 51], term := .jump 0x401106#64 }),
    (0x401106#64, { ops := [.const 0 0x4#64, .get 8 8, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 8 16], term := .jump 0x40110a#64 }),
    (0x40110a#64, { ops := [.get 0 3, .get 8 8, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40110d#64 }),
    (0x40110d#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x4010d0#64 0x40110f#64 }),
    (0x40110f#64, { ops := [.get 0 0, .get 8 0, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401112#64 }),
    (0x401112#64, { ops := [.getf 0 3], term := .branch 0 0x401134#64 0x401114#64 }),
    (0x401114#64, { ops := [.get 0 8, .get 8 4, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 4 16], term := .jump 0x401117#64 }),
    (0x401117#64, { ops := [.get 0 8, .get 8 5, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 5 16], term := .jump 0x40111a#64 }),
    (0x40111a#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 9 3, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x40111c#64 }),
    (0x40111c#64, { ops := [], term := .jump 0x401120#64 }),
    (0x401120#64, { ops := [.get 2 4, .get 3 3, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 8 0], term := .jump 0x401125#64 }),
    (0x401125#64, { ops := [.get 1 8, .un 0 (.zext 8) 1, .get 10 5, .get 11 3, .const 12 0x1#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w8 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 8, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 8 51], term := .jump 0x401129#64 }),
    (0x401129#64, { ops := [.get 1 2, .un 0 (.zext 8) 1, .get 9 8, .un 8 (.zext 8) 9, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40, .get 48 2, .const 49 0xffffffffffffff00#64, .bin 50 .and 48 49, .bin 51 .or 50 16, .set 2 51], term := .jump 0x40112c#64 }),
    (0x40112c#64, { ops := [.get 0 3, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x40112f#64 }),
    (0x40112f#64, { ops := [.get 0 0, .get 8 3, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401132#64 }),
    (0x401132#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401120#64 0x401134#64 }),
    (0x401134#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401136#64 }),
    (0x401136#64, { ops := [.get 1 2, .un 0 (.zext 8) 1, .get 9 2, .un 8 (.zext 8) 9, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401138#64 }),
    (0x401138#64, { ops := [.getf 0 3, .get 8 0, .const 9 0xffffffffffffff00#64, .bin 10 .and 8 9, .bin 11 .or 10 0, .set 0 11], term := .jump 0x40113b#64 }),
    (0x40113b#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `equal_bytes_ct` is the lowering of `equal_bytes_ct_code`. -/
theorem equal_bytes_ct_lowered :
    equal_bytes_ct.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) equal_bytes_ct_code := by
  decide

/-- The blocks of `equal_bytes_ct` are blocks of the lowering of the executable. -/
theorem equal_bytes_ct_holds :
    ∀ p ∈ equal_bytes_ct.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)), h⟩) equal_bytes_ct_lowered

end Examples.Mem.O2.X86
