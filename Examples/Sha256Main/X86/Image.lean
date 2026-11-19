/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Program

@[expose] public section

namespace Examples.Sha256Main.X86


/-- The lines of `sha256_compress`, from `0x401100`. -/
def sha256_compress_code : List Lowering.X86.Line := [
  ⟨0x401100, 1, "L401100", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64))))))⟩,
  ⟨0x401101, 2, "L401101", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W64))))))⟩,
  ⟨0x401103, 2, "L401103", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W64))))))⟩,
  ⟨0x401105, 2, "L401105", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W64))))))⟩,
  ⟨0x401107, 1, "L401107", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64))))))⟩,
  ⟨0x401108, 7, "L401108", some (Instr.regular (Width.W64) (Width.W64) (Operation.sub (RegOrMem.reg (Reg.low (Reg64.rsp) (Width.W64))) (Operand.imm (ConstExpr.int64 160))))⟩,
  ⟨0x40110f, 2, "L40110f", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401111, 15, "L401111", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 15))⟩,
  ⟨0x401120, 3, "L401120", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401123, 4, "L401123", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 (-96) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x401127, 3, "L401127", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64)))))⟩,
  ⟨0x40112a, 4, "L40112a", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.imm (ConstExpr.int64 16))))⟩,
  ⟨0x40112e, 2, "L40112e", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401120"))⟩,
  ⟨0x401130, 5, "L401130", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.imm (ConstExpr.int64 16))))⟩,
  ⟨0x401135, 11, "L401135", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 11))⟩,
  ⟨0x401140, 4, "L401140", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 (-104) }))))⟩,
  ⟨0x401144, 2, "L401144", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x401146, 3, "L401146", some (Instr.regular (Width.W64) (Width.W32) (Operation.rol (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 15))))⟩,
  ⟨0x401149, 2, "L401149", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x40114b, 3, "L40114b", some (Instr.regular (Width.W64) (Width.W32) (Operation.rol (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 13))))⟩,
  ⟨0x40114e, 2, "L40114e", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x401150, 3, "L401150", some (Instr.regular (Width.W64) (Width.W32) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 10))))⟩,
  ⟨0x401153, 2, "L401153", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))))))⟩,
  ⟨0x401155, 4, "L401155", some (Instr.regular (Width.W64) (Width.W32) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 (-124) }))))⟩,
  ⟨0x401159, 7, "L401159", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 (-156) }))))⟩,
  ⟨0x401160, 2, "L401160", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x401162, 3, "L401162", some (Instr.regular (Width.W64) (Width.W32) (Operation.rol (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 25))))⟩,
  ⟨0x401165, 3, "L401165", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x401168, 4, "L401168", some (Instr.regular (Width.W64) (Width.W32) (Operation.rol (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 14))))⟩,
  ⟨0x40116c, 3, "L40116c", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))))))⟩,
  ⟨0x40116f, 3, "L40116f", some (Instr.regular (Width.W64) (Width.W32) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 3))))⟩,
  ⟨0x401172, 3, "L401172", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x401175, 7, "L401175", some (Instr.regular (Width.W64) (Width.W32) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 (-160) }))))⟩,
  ⟨0x40117c, 2, "L40117c", some (Instr.regular (Width.W64) (Width.W32) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x40117e, 4, "L40117e", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 (-96) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x401182, 3, "L401182", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64)))))⟩,
  ⟨0x401185, 4, "L401185", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.imm (ConstExpr.int64 64))))⟩,
  ⟨0x401189, 2, "L401189", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401140"))⟩,
  ⟨0x40118b, 2, "L40118b", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40118d, 3, "L40118d", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 3))⟩,
  ⟨0x401190, 3, "L401190", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401193, 4, "L401193", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 (-128) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x401197, 3, "L401197", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64)))))⟩,
  ⟨0x40119a, 4, "L40119a", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.imm (ConstExpr.int64 8))))⟩,
  ⟨0x40119e, 2, "L40119e", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401190"))⟩,
  ⟨0x4011a0, 4, "L4011a0", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-128) }))))⟩,
  ⟨0x4011a4, 4, "L4011a4", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-124) }))))⟩,
  ⟨0x4011a8, 4, "L4011a8", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-120) }))))⟩,
  ⟨0x4011ac, 4, "L4011ac", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-116) }))))⟩,
  ⟨0x4011b0, 4, "L4011b0", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-112) }))))⟩,
  ⟨0x4011b4, 5, "L4011b4", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-108) }))))⟩,
  ⟨0x4011b9, 5, "L4011b9", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-104) }))))⟩,
  ⟨0x4011be, 5, "L4011be", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-100) }))))⟩,
  ⟨0x4011c3, 3, "L4011c3", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W32))))))⟩,
  ⟨0x4011c6, 7, "L4011c6", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rbx) (Width.W64)) { base := some (RegOrRip.rip), idx := none, disp := ConstExpr.int64 4323 }))⟩,
  ⟨0x4011cd, 3, "L4011cd", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 3))⟩,
  ⟨0x4011d0, 3, "L4011d0", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W32))))))⟩,
  ⟨0x4011d3, 3, "L4011d3", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))))))⟩,
  ⟨0x4011d6, 3, "L4011d6", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x4011d9, 3, "L4011d9", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))))))⟩,
  ⟨0x4011dc, 2, "L4011dc", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x4011de, 2, "L4011de", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x4011e0, 2, "L4011e0", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x4011e2, 2, "L4011e2", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))))))⟩,
  ⟨0x4011e4, 3, "L4011e4", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x4011e7, 3, "L4011e7", some (Instr.regular (Width.W64) (Width.W32) (Operation.rol (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 26))))⟩,
  ⟨0x4011ea, 5, "L4011ea", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.r11, scale := Width.W8 }, disp := ConstExpr.int64 (-96) }))))⟩,
  ⟨0x4011ef, 3, "L4011ef", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x4011f2, 4, "L4011f2", some (Instr.regular (Width.W64) (Width.W32) (Operation.rol (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 21))))⟩,
  ⟨0x4011f6, 3, "L4011f6", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))))))⟩,
  ⟨0x4011f9, 3, "L4011f9", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x4011fc, 3, "L4011fc", some (Instr.regular (Width.W64) (Width.W32) (Operation.rol (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 7))))⟩,
  ⟨0x4011ff, 3, "L4011ff", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W32))))))⟩,
  ⟨0x401202, 3, "L401202", some (Instr.regular (Width.W64) (Width.W32) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))))))⟩,
  ⟨0x401205, 3, "L401205", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))))))⟩,
  ⟨0x401208, 3, "L401208", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W32))))))⟩,
  ⟨0x40120b, 3, "L40120b", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x40120e, 3, "L40120e", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W32))))))⟩,
  ⟨0x401211, 4, "L401211", some (Instr.regular (Width.W64) (Width.W32) (Operation.add (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.r11)), idx := some { reg := Reg64.rbx, scale := Width.W8 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401215, 3, "L401215", some (Instr.regular (Width.W64) (Width.W32) (Operation.add (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))))))⟩,
  ⟨0x401218, 2, "L401218", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40121a, 3, "L40121a", some (Instr.regular (Width.W64) (Width.W32) (Operation.rol (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 30))))⟩,
  ⟨0x40121d, 3, "L40121d", some (Instr.regular (Width.W64) (Width.W32) (Operation.add (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))))))⟩,
  ⟨0x401220, 3, "L401220", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401223, 4, "L401223", some (Instr.regular (Width.W64) (Width.W32) (Operation.rol (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 19))))⟩,
  ⟨0x401227, 3, "L401227", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))))))⟩,
  ⟨0x40122a, 3, "L40122a", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40122d, 4, "L40122d", some (Instr.regular (Width.W64) (Width.W32) (Operation.rol (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 10))))⟩,
  ⟨0x401231, 3, "L401231", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))))))⟩,
  ⟨0x401234, 3, "L401234", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x401237, 3, "L401237", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x40123a, 3, "L40123a", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40123d, 2, "L40123d", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x40123f, 2, "L40123f", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x401241, 3, "L401241", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W32))))))⟩,
  ⟨0x401244, 3, "L401244", some (Instr.regular (Width.W64) (Width.W32) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W32))))))⟩,
  ⟨0x401247, 3, "L401247", some (Instr.regular (Width.W64) (Width.W32) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W32))))))⟩,
  ⟨0x40124a, 3, "L40124a", some (Instr.regular (Width.W64) (Width.W32) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W32))))))⟩,
  ⟨0x40124d, 4, "L40124d", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W64))) (Operand.imm (ConstExpr.int64 4))))⟩,
  ⟨0x401251, 7, "L401251", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.r11) (Width.W64))) (Operand.imm (ConstExpr.int64 256))))⟩,
  ⟨0x401258, 6, "L401258", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L4011d0"))⟩,
  ⟨0x40125e, 4, "L40125e", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-128) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W32))))))⟩,
  ⟨0x401262, 4, "L401262", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-124) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401266, 4, "L401266", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-120) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x40126a, 4, "L40126a", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-116) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x40126e, 4, "L40126e", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-112) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))))))⟩,
  ⟨0x401272, 5, "L401272", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-108) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x401277, 5, "L401277", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-104) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))))))⟩,
  ⟨0x40127c, 5, "L40127c", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 (-100) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W32))))))⟩,
  ⟨0x401281, 2, "L401281", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401283, 13, "L401283", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 13))⟩,
  ⟨0x401290, 4, "L401290", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 (-128) }))))⟩,
  ⟨0x401294, 3, "L401294", some (Instr.regular (Width.W64) (Width.W32) (Operation.add (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x401297, 3, "L401297", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64)))))⟩,
  ⟨0x40129a, 4, "L40129a", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.imm (ConstExpr.int64 8))))⟩,
  ⟨0x40129e, 2, "L40129e", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401290"))⟩,
  ⟨0x4012a0, 7, "L4012a0", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rsp) (Width.W64))) (Operand.imm (ConstExpr.int64 160))))⟩,
  ⟨0x4012a7, 1, "L4012a7", some (Instr.regular (Width.W64) (Width.W64) (Operation.pop (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64)))))⟩,
  ⟨0x4012a8, 2, "L4012a8", some (Instr.regular (Width.W64) (Width.W64) (Operation.pop (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W64)))))⟩,
  ⟨0x4012aa, 2, "L4012aa", some (Instr.regular (Width.W64) (Width.W64) (Operation.pop (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W64)))))⟩,
  ⟨0x4012ac, 2, "L4012ac", some (Instr.regular (Width.W64) (Width.W64) (Operation.pop (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W64)))))⟩,
  ⟨0x4012ae, 1, "L4012ae", some (Instr.regular (Width.W64) (Width.W64) (Operation.pop (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64)))))⟩,
  ⟨0x4012af, 1, "L4012af", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩,
  ⟨0x4012b0, 4352, "G4012b0", none⟩]

/-- The lines of `_start`, from `0x4023b0`. -/
def _start_code : List Lowering.X86.Line := [
  ⟨0x4023b0, 7, "L4023b0", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rsp) (Width.W64)) { base := some (RegOrRip.rip), idx := none, disp := ConstExpr.int64 2441 }))⟩,
  ⟨0x4023b7, 5, "L4023b7", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4203456) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x4023bc, 4, "L4023bc", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 4))⟩]

/-- The lines of `main`, from `0x4023c0`. -/
def main_code : List Lowering.X86.Line := [
  ⟨0x4023c0, 1, "L4023c0", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64))))))⟩,
  ⟨0x4023c1, 2, "L4023c1", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W64))))))⟩,
  ⟨0x4023c3, 2, "L4023c3", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W64))))))⟩,
  ⟨0x4023c5, 2, "L4023c5", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))))))⟩,
  ⟨0x4023c7, 2, "L4023c7", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W64))))))⟩,
  ⟨0x4023c9, 1, "L4023c9", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64))))))⟩,
  ⟨0x4023ca, 7, "L4023ca", some (Instr.regular (Width.W64) (Width.W64) (Operation.sub (RegOrMem.reg (Reg.low (Reg64.rsp) (Width.W64))) (Operand.imm (ConstExpr.int64 152))))⟩,
  ⟨0x4023d1, 7, "L4023d1", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rax) (Width.W64)) { base := some (RegOrRip.rip), idx := none, disp := ConstExpr.int64 2440 }))⟩,
  ⟨0x4023d8, 3, "L4023d8", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rax)), idx := none, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x4023db, 4, "L4023db", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.r12) (Width.W64)) { base := some (RegOrRip.reg (Reg64.r15)), idx := none, disp := ConstExpr.int64 8 }))⟩,
  ⟨0x4023df, 3, "L4023df", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W64))))))⟩,
  ⟨0x4023e2, 4, "L4023e2", some (Instr.regular (Width.W64) (Width.W64) (Operation.and (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))) (Operand.imm (ConstExpr.int64 (-64)))))⟩,
  ⟨0x4023e6, 3, "L4023e6", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W64))))))⟩,
  ⟨0x4023e9, 3, "L4023e9", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))))))⟩,
  ⟨0x4023ec, 10, "L4023ec", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.imm (ConstExpr.int64 (-4942790177982912921)))))⟩,
  ⟨0x4023f6, 5, "L4023f6", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 16 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x4023fb, 10, "L4023fb", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.imm (ConstExpr.int64 (-6534734903820487822)))))⟩,
  ⟨0x402405, 5, "L402405", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 24 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x40240a, 10, "L40240a", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.imm (ConstExpr.int64 (-7276294671082564993)))))⟩,
  ⟨0x402414, 5, "L402414", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 32 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x402419, 10, "L402419", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.imm (ConstExpr.int64 6620516960021240235))))⟩,
  ⟨0x402423, 5, "L402423", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 40 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x402428, 4, "L402428", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.imm (ConstExpr.int64 64))))⟩,
  ⟨0x40242c, 5, "L40242c", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 8 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x402431, 6, "L402431", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L4024ea"))⟩,
  ⟨0x402437, 4, "L402437", some (Instr.regular (Width.W64) (Width.W64) (Operation.shl (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64))) (ShiftCountExpr.imm8 (ConstExpr.int64 3))))⟩,
  ⟨0x40243b, 4, "L40243b", some (Instr.regular (Width.W64) (Width.W64) (Operation.or (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))) (Operand.imm (ConstExpr.int64 56))))⟩,
  ⟨0x40243f, 4, "L40243f", some (Instr.regular (Width.W64) (Width.W64) (Operation.or (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W64))) (Operand.imm (ConstExpr.int64 63))))⟩,
  ⟨0x402443, 4, "L402443", some (Instr.regular (Width.W64) (Width.W64) (Operation.shl (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W64))) (ShiftCountExpr.imm8 (ConstExpr.int64 3))))⟩,
  ⟨0x402447, 3, "L402447", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W32))))))⟩,
  ⟨0x40244a, 7, "L40244a", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rbx) (Width.W64)) { base := some (RegOrRip.rip), idx := none, disp := ConstExpr.int64 2327 }))⟩,
  ⟨0x402451, 2, "L402451", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4203649) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x402453, 13, "L402453", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 13))⟩,
  ⟨0x402460, 5, "L402460", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rdi) (Width.W64)) { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 16 }))⟩,
  ⟨0x402465, 5, "L402465", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rsi) (Width.W64)) { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 80 }))⟩,
  ⟨0x40246a, 5, "L40246a", some (Instr.regular (Width.W64) (Width.W64) (Operation.call (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4198656) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x40246f, 4, "L40246f", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W64))) (Operand.imm (ConstExpr.int64 64))))⟩,
  ⟨0x402473, 7, "L402473", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W64))) (Operand.imm (ConstExpr.int64 (-512)))))⟩,
  ⟨0x40247a, 5, "L40247a", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := none, disp := ConstExpr.int64 8 }))))⟩,
  ⟨0x40247f, 2, "L40247f", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nc) "L4024ea"))⟩,
  ⟨0x402481, 3, "L402481", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r14) (Width.W64))))))⟩,
  ⟨0x402484, 3, "L402484", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r12) (Width.W64))))))⟩,
  ⟨0x402487, 2, "L402487", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W32))))))⟩,
  ⟨0x402489, 2, "L402489", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4203685) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x40248b, 5, "L40248b", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 5))⟩,
  ⟨0x402490, 4, "L402490", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.rsi, scale := Width.W32 }, disp := ConstExpr.int64 80 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W32))))))⟩,
  ⟨0x402494, 3, "L402494", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64)))))⟩,
  ⟨0x402497, 4, "L402497", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.imm (ConstExpr.int64 (-32)))))⟩,
  ⟨0x40249b, 4, "L40249b", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.imm (ConstExpr.int64 4))))⟩,
  ⟨0x40249f, 4, "L40249f", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.imm (ConstExpr.int64 16))))⟩,
  ⟨0x4024a3, 2, "L4024a3", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L402460"))⟩,
  ⟨0x4024a5, 2, "L4024a5", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W32))))))⟩,
  ⟨0x4024a7, 3, "L4024a7", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))))))⟩,
  ⟨0x4024aa, 3, "L4024aa", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))))))⟩,
  ⟨0x4024ad, 2, "L4024ad", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4203719) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x4024af, 1, "L4024af", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 1))⟩,
  ⟨0x4024b0, 5, "L4024b0", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rbx)), idx := some { reg := Reg64.r8, scale := Width.W8 }, disp := ConstExpr.int64 0 })))⟩,
  ⟨0x4024b5, 3, "L4024b5", some (Instr.regular (Width.W64) (Width.W32) (Operation.shl (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 8))))⟩,
  ⟨0x4024b8, 2, "L4024b8", some (Instr.regular (Width.W64) (Width.W32) (Operation.or (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x4024ba, 4, "L4024ba", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W64))) (Operand.imm (ConstExpr.int64 (-8)))))⟩,
  ⟨0x4024be, 3, "L4024be", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64)))))⟩,
  ⟨0x4024c1, 4, "L4024c1", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W64))) (Operand.imm (ConstExpr.int64 (-32)))))⟩,
  ⟨0x4024c5, 2, "L4024c5", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L402490"))⟩,
  ⟨0x4024c7, 3, "L4024c7", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r15) (Width.W64))))))⟩,
  ⟨0x4024ca, 2, "L4024ca", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.c) "L4024b0"))⟩,
  ⟨0x4024cc, 5, "L4024cc", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.imm (ConstExpr.int64 128))))⟩,
  ⟨0x4024d1, 2, "L4024d1", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L4024b5"))⟩,
  ⟨0x4024d3, 2, "L4024d3", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x4024d5, 3, "L4024d5", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))))))⟩,
  ⟨0x4024d8, 2, "L4024d8", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.c) "L4024b5"))⟩,
  ⟨0x4024da, 4, "L4024da", some (Instr.regular (Width.W64) (Width.W32) (Operation.lea (Reg.low (Reg64.rcx) (Width.W32)) { base := some (RegOrRip.reg (Reg64.rdx)), idx := some { reg := Reg64.r9, scale := Width.W8 }, disp := ConstExpr.int64 0 }))⟩,
  ⟨0x4024de, 3, "L4024de", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64))))))⟩,
  ⟨0x4024e1, 3, "L4024e1", some (Instr.regular (Width.W64) (Width.W64) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W64))) (ShiftCountExpr.cl)))⟩,
  ⟨0x4024e4, 4, "L4024e4", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W8)))))⟩,
  ⟨0x4024e8, 2, "L4024e8", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4203701) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x4024ea, 2, "L4024ea", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x4024ec, 4, "L4024ec", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 4))⟩,
  ⟨0x4024f0, 4, "L4024f0", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 16 }))))⟩,
  ⟨0x4024f4, 2, "L4024f4", some (Instr.regular (Width.W64) (Width.W32) (Operation.bswap (Reg.low (Reg64.rcx) (Width.W32))))⟩,
  ⟨0x4024f6, 4, "L4024f6", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 48 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x4024fa, 3, "L4024fa", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64)))))⟩,
  ⟨0x4024fd, 4, "L4024fd", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.imm (ConstExpr.int64 8))))⟩,
  ⟨0x402501, 2, "L402501", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L4024f0"))⟩,
  ⟨0x402503, 2, "L402503", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x402505, 7, "L402505", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rcx) (Width.W64)) { base := some (RegOrRip.rip), idx := none, disp := ConstExpr.int64 2100 }))⟩,
  ⟨0x40250c, 4, "L40250c", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 4))⟩,
  ⟨0x402510, 5, "L402510", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsp)), idx := some { reg := Reg64.rax, scale := Width.W8 }, disp := ConstExpr.int64 48 })))⟩,
  ⟨0x402515, 3, "L402515", some (Instr.regular (Width.W64) (Width.W8) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rax)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W8))))))⟩,
  ⟨0x402518, 3, "L402518", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64)))))⟩,
  ⟨0x40251b, 4, "L40251b", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.imm (ConstExpr.int64 32))))⟩,
  ⟨0x40251f, 2, "L40251f", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L402510"))⟩,
  ⟨0x402521, 15, "L402521", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 15))⟩,
  ⟨0x402530, 2, "L402530", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4203824) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x402532, 1, "L402532", none⟩,
  ⟨0x402533, 1, "L402533", none⟩]

/-- The lines of every function lowered here, in address order. -/
def image : List Lowering.X86.Line :=
  List.flatten [sha256_compress_code, _start_code, main_code]

/-- The lines of the image follow one another. -/
theorem image_wf : Lowering.X86.wf image = true := by
  decide +kernel

/-- The executable of the image: the program of the machine model. -/
def exe : Executable := Lowering.X86.exeOf image

/-- `sha256_compress`, lowered to `braid`. -/
def sha256_compress : Braid.Func :=
  { name := "sha256_compress", entry := 0x401100#64, blocks := [
    (0x401100#64, { ops := [.get 0 7, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x401101#64 }),
    (0x401101#64, { ops := [.get 0 15, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x401103#64 }),
    (0x401103#64, { ops := [.get 0 14, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x401105#64 }),
    (0x401105#64, { ops := [.get 0 12, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x401107#64 }),
    (0x401107#64, { ops := [.get 0 1, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x401108#64 }),
    (0x401108#64, { ops := [.const 0 0xa0#64, .get 8 6, .bin 16 .sub 8 0, .bin 18 .ult 8 0, .setf 0 18, .bin 19 .xor 8 0, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 6 16], term := .jump 0x40110f#64 }),
    (0x40110f#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401111#64 }),
    (0x401111#64, { ops := [], term := .jump 0x401120#64 }),
    (0x401120#64, { ops := [.get 2 4, .get 3 0, .const 4 0x4#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w32 1, .set 2 0], term := .jump 0x401123#64 }),
    (0x401123#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 6, .get 10 0, .const 11 0x4#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0xffffffffffffffa0#64, .bin 8 .add 13 14, .store .w32 8 0], term := .jump 0x401127#64 }),
    (0x401127#64, { ops := [.get 0 0, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40112a#64 }),
    (0x40112a#64, { ops := [.get 0 0, .const 8 0x10#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40112e#64 }),
    (0x40112e#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401120#64 0x401130#64 }),
    (0x401130#64, { ops := [.const 0 0x10#64, .set 0 0], term := .jump 0x401135#64 }),
    (0x401135#64, { ops := [], term := .jump 0x401140#64 }),
    (0x401140#64, { ops := [.get 2 6, .get 3 0, .const 4 0x4#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0xffffffffffffff98#64, .bin 1 .add 6 7, .load 0 .w32 1, .set 2 0], term := .jump 0x401144#64 }),
    (0x401144#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .set 3 0], term := .jump 0x401146#64 }),
    (0x401146#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .const 12 0xf#64, .bin 13 .shl 0 12, .const 14 0x11#64, .bin 15 .lshr 0 14, .bin 16 .or 13 15, .un 17 (.zext 32) 16, .const 18 0x1#64, .bin 19 .and 17 18, .setf 0 19, .havoc 23, .setf 5 23, .set 3 17], term := .jump 0x401149#64 }),
    (0x401149#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .set 4 0], term := .jump 0x40114b#64 }),
    (0x40114b#64, { ops := [.get 1 4, .un 0 (.zext 32) 1, .const 12 0xd#64, .bin 13 .shl 0 12, .const 14 0x13#64, .bin 15 .lshr 0 14, .bin 16 .or 13 15, .un 17 (.zext 32) 16, .const 18 0x1#64, .bin 19 .and 17 18, .setf 0 19, .havoc 23, .setf 5 23, .set 4 17], term := .jump 0x40114e#64 }),
    (0x40114e#64, { ops := [.get 1 4, .un 0 (.zext 32) 1, .get 9 3, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 4 16], term := .jump 0x401150#64 }),
    (0x401150#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .const 8 0xa#64, .bin 9 .lshr 0 8, .const 11 0x9#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 9 39, .setf 4 40, .set 2 9], term := .jump 0x401153#64 }),
    (0x401153#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 4, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x401155#64 }),
    (0x401155#64, { ops := [.get 2 6, .get 3 0, .const 4 0x4#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0xffffffffffffff84#64, .bin 1 .add 6 7, .load 0 .w32 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .add 0 8, .un 17 (.zext 32) 16, .bin 18 .ult 17 0, .setf 0 18, .bin 19 .xor 0 17, .bin 20 .xor 8 17, .bin 21 .and 19 20, .const 22 0x80000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 17 39, .setf 4 40, .set 2 17], term := .jump 0x401159#64 }),
    (0x401159#64, { ops := [.get 2 6, .get 3 0, .const 4 0x4#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0xffffffffffffff64#64, .bin 1 .add 6 7, .load 0 .w32 1, .set 3 0], term := .jump 0x401160#64 }),
    (0x401160#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .set 4 0], term := .jump 0x401162#64 }),
    (0x401162#64, { ops := [.get 1 4, .un 0 (.zext 32) 1, .const 12 0x19#64, .bin 13 .shl 0 12, .const 14 0x7#64, .bin 15 .lshr 0 14, .bin 16 .or 13 15, .un 17 (.zext 32) 16, .const 18 0x1#64, .bin 19 .and 17 18, .setf 0 19, .havoc 23, .setf 5 23, .set 4 17], term := .jump 0x401165#64 }),
    (0x401165#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .set 8 0], term := .jump 0x401168#64 }),
    (0x401168#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .const 12 0xe#64, .bin 13 .shl 0 12, .const 14 0x12#64, .bin 15 .lshr 0 14, .bin 16 .or 13 15, .un 17 (.zext 32) 16, .const 18 0x1#64, .bin 19 .and 17 18, .setf 0 19, .havoc 23, .setf 5 23, .set 8 17], term := .jump 0x40116c#64 }),
    (0x40116c#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 9 4, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 8 16], term := .jump 0x40116f#64 }),
    (0x40116f#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .const 8 0x3#64, .bin 9 .lshr 0 8, .const 11 0x2#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 9 39, .setf 4 40, .set 3 9], term := .jump 0x401172#64 }),
    (0x401172#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 9 8, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x401175#64 }),
    (0x401175#64, { ops := [.get 2 6, .get 3 0, .const 4 0x4#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0xffffffffffffff60#64, .bin 1 .add 6 7, .load 0 .w32 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .add 0 8, .un 17 (.zext 32) 16, .bin 18 .ult 17 0, .setf 0 18, .bin 19 .xor 0 17, .bin 20 .xor 8 17, .bin 21 .and 19 20, .const 22 0x80000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 17 39, .setf 4 40, .set 2 17], term := .jump 0x40117c#64 }),
    (0x40117c#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .add 0 8, .un 17 (.zext 32) 16, .bin 18 .ult 17 0, .setf 0 18, .bin 19 .xor 0 17, .bin 20 .xor 8 17, .bin 21 .and 19 20, .const 22 0x80000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 17 39, .setf 4 40, .set 2 17], term := .jump 0x40117e#64 }),
    (0x40117e#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 6, .get 10 0, .const 11 0x4#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0xffffffffffffffa0#64, .bin 8 .add 13 14, .store .w32 8 0], term := .jump 0x401182#64 }),
    (0x401182#64, { ops := [.get 0 0, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401185#64 }),
    (0x401185#64, { ops := [.get 0 0, .const 8 0x40#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401189#64 }),
    (0x401189#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401140#64 0x40118b#64 }),
    (0x40118b#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40118d#64 }),
    (0x40118d#64, { ops := [], term := .jump 0x401190#64 }),
    (0x401190#64, { ops := [.get 2 5, .get 3 0, .const 4 0x4#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w32 1, .set 2 0], term := .jump 0x401193#64 }),
    (0x401193#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 6, .get 10 0, .const 11 0x4#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0xffffffffffffff80#64, .bin 8 .add 13 14, .store .w32 8 0], term := .jump 0x401197#64 }),
    (0x401197#64, { ops := [.get 0 0, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40119a#64 }),
    (0x40119a#64, { ops := [.get 0 0, .const 8 0x8#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40119e#64 }),
    (0x40119e#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401190#64 0x4011a0#64 }),
    (0x4011a0#64, { ops := [.get 2 6, .const 3 0xffffffffffffff80#64, .bin 1 .add 2 3, .load 0 .w32 1, .set 7 0], term := .jump 0x4011a4#64 }),
    (0x4011a4#64, { ops := [.get 2 6, .const 3 0xffffffffffffff84#64, .bin 1 .add 2 3, .load 0 .w32 1, .set 0 0], term := .jump 0x4011a8#64 }),
    (0x4011a8#64, { ops := [.get 2 6, .const 3 0xffffffffffffff88#64, .bin 1 .add 2 3, .load 0 .w32 1, .set 2 0], term := .jump 0x4011ac#64 }),
    (0x4011ac#64, { ops := [.get 2 6, .const 3 0xffffffffffffff8c#64, .bin 1 .add 2 3, .load 0 .w32 1, .set 3 0], term := .jump 0x4011b0#64 }),
    (0x4011b0#64, { ops := [.get 2 6, .const 3 0xffffffffffffff90#64, .bin 1 .add 2 3, .load 0 .w32 1, .set 4 0], term := .jump 0x4011b4#64 }),
    (0x4011b4#64, { ops := [.get 2 6, .const 3 0xffffffffffffff94#64, .bin 1 .add 2 3, .load 0 .w32 1, .set 8 0], term := .jump 0x4011b9#64 }),
    (0x4011b9#64, { ops := [.get 2 6, .const 3 0xffffffffffffff98#64, .bin 1 .add 2 3, .load 0 .w32 1, .set 9 0], term := .jump 0x4011be#64 }),
    (0x4011be#64, { ops := [.get 2 6, .const 3 0xffffffffffffff9c#64, .bin 1 .add 2 3, .load 0 .w32 1, .set 10 0], term := .jump 0x4011c3#64 }),
    (0x4011c3#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 9 11, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 11 16], term := .jump 0x4011c6#64 }),
    (0x4011c6#64, { ops := [.const 0 0x4022b0#64, .set 1 0], term := .jump 0x4011cd#64 }),
    (0x4011cd#64, { ops := [], term := .jump 0x4011d0#64 }),
    (0x4011d0#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .set 15 0], term := .jump 0x4011d3#64 }),
    (0x4011d3#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .set 10 0], term := .jump 0x4011d6#64 }),
    (0x4011d6#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .set 9 0], term := .jump 0x4011d9#64 }),
    (0x4011d9#64, { ops := [.get 1 4, .un 0 (.zext 32) 1, .set 8 0], term := .jump 0x4011dc#64 }),
    (0x4011dc#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .set 4 0], term := .jump 0x4011de#64 }),
    (0x4011de#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .set 3 0], term := .jump 0x4011e0#64 }),
    (0x4011e0#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .set 2 0], term := .jump 0x4011e2#64 }),
    (0x4011e2#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .set 0 0], term := .jump 0x4011e4#64 }),
    (0x4011e4#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .set 7 0], term := .jump 0x4011e7#64 }),
    (0x4011e7#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .const 12 0x1a#64, .bin 13 .shl 0 12, .const 14 0x6#64, .bin 15 .lshr 0 14, .bin 16 .or 13 15, .un 17 (.zext 32) 16, .const 18 0x1#64, .bin 19 .and 17 18, .setf 0 19, .havoc 23, .setf 5 23, .set 7 17], term := .jump 0x4011ea#64 }),
    (0x4011ea#64, { ops := [.get 2 6, .get 3 11, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0xffffffffffffffa0#64, .bin 1 .add 6 7, .load 0 .w32 1, .set 14 0], term := .jump 0x4011ef#64 }),
    (0x4011ef#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .set 12 0], term := .jump 0x4011f2#64 }),
    (0x4011f2#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .const 12 0x15#64, .bin 13 .shl 0 12, .const 14 0xb#64, .bin 15 .lshr 0 14, .bin 16 .or 13 15, .un 17 (.zext 32) 16, .const 18 0x1#64, .bin 19 .and 17 18, .setf 0 19, .havoc 23, .setf 5 23, .set 12 17], term := .jump 0x4011f6#64 }),
    (0x4011f6#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 9 7, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 12 16], term := .jump 0x4011f9#64 }),
    (0x4011f9#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .set 7 0], term := .jump 0x4011fc#64 }),
    (0x4011fc#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .const 12 0x7#64, .bin 13 .shl 0 12, .const 14 0x19#64, .bin 15 .lshr 0 14, .bin 16 .or 13 15, .un 17 (.zext 32) 16, .const 18 0x1#64, .bin 19 .and 17 18, .setf 0 19, .havoc 23, .setf 5 23, .set 7 17], term := .jump 0x4011ff#64 }),
    (0x4011ff#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .get 9 12, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 7 16], term := .jump 0x401202#64 }),
    (0x401202#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 9 7, .un 8 (.zext 32) 9, .bin 16 .add 0 8, .un 17 (.zext 32) 16, .bin 18 .ult 17 0, .setf 0 18, .bin 19 .xor 0 17, .bin 20 .xor 8 17, .bin 21 .and 19 20, .const 22 0x80000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 17 39, .setf 4 40, .set 7 17], term := .jump 0x401205#64 }),
    (0x401205#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .set 15 0], term := .jump 0x401208#64 }),
    (0x401208#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 9 10, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 15 16], term := .jump 0x40120b#64 }),
    (0x40120b#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 9 8, .un 8 (.zext 32) 9, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 15 16], term := .jump 0x40120e#64 }),
    (0x40120e#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 9 10, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 15 16], term := .jump 0x401211#64 }),
    (0x401211#64, { ops := [.get 2 11, .get 3 1, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w32 1, .get 9 14, .un 8 (.zext 32) 9, .bin 16 .add 0 8, .un 17 (.zext 32) 16, .bin 18 .ult 17 0, .setf 0 18, .bin 19 .xor 0 17, .bin 20 .xor 8 17, .bin 21 .and 19 20, .const 22 0x80000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 17 39, .setf 4 40, .set 14 17], term := .jump 0x401215#64 }),
    (0x401215#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .get 9 15, .un 8 (.zext 32) 9, .bin 16 .add 0 8, .un 17 (.zext 32) 16, .bin 18 .ult 17 0, .setf 0 18, .bin 19 .xor 0 17, .bin 20 .xor 8 17, .bin 21 .and 19 20, .const 22 0x80000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 17 39, .setf 4 40, .set 15 17], term := .jump 0x401218#64 }),
    (0x401218#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .set 7 0], term := .jump 0x40121a#64 }),
    (0x40121a#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .const 12 0x1e#64, .bin 13 .shl 0 12, .const 14 0x2#64, .bin 15 .lshr 0 14, .bin 16 .or 13 15, .un 17 (.zext 32) 16, .const 18 0x1#64, .bin 19 .and 17 18, .setf 0 19, .havoc 23, .setf 5 23, .set 7 17], term := .jump 0x40121d#64 }),
    (0x40121d#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 9 14, .un 8 (.zext 32) 9, .bin 16 .add 0 8, .un 17 (.zext 32) 16, .bin 18 .ult 17 0, .setf 0 18, .bin 19 .xor 0 17, .bin 20 .xor 8 17, .bin 21 .and 19 20, .const 22 0x80000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 17 39, .setf 4 40, .set 14 17], term := .jump 0x401220#64 }),
    (0x401220#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .set 15 0], term := .jump 0x401223#64 }),
    (0x401223#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .const 12 0x13#64, .bin 13 .shl 0 12, .const 14 0xd#64, .bin 15 .lshr 0 14, .bin 16 .or 13 15, .un 17 (.zext 32) 16, .const 18 0x1#64, .bin 19 .and 17 18, .setf 0 19, .havoc 23, .setf 5 23, .set 15 17], term := .jump 0x401227#64 }),
    (0x401227#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 9 7, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 15 16], term := .jump 0x40122a#64 }),
    (0x40122a#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .set 12 0], term := .jump 0x40122d#64 }),
    (0x40122d#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .const 12 0xa#64, .bin 13 .shl 0 12, .const 14 0x16#64, .bin 15 .lshr 0 14, .bin 16 .or 13 15, .un 17 (.zext 32) 16, .const 18 0x1#64, .bin 19 .and 17 18, .setf 0 19, .havoc 23, .setf 5 23, .set 12 17], term := .jump 0x401231#64 }),
    (0x401231#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 9 15, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 12 16], term := .jump 0x401234#64 }),
    (0x401234#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .set 15 0], term := .jump 0x401237#64 }),
    (0x401237#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 15 16], term := .jump 0x40123a#64 }),
    (0x40123a#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 15 16], term := .jump 0x40123d#64 }),
    (0x40123d#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .set 7 0], term := .jump 0x40123f#64 }),
    (0x40123f#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 7 16], term := .jump 0x401241#64 }),
    (0x401241#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .get 9 15, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 7 16], term := .jump 0x401244#64 }),
    (0x401244#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 9 7, .un 8 (.zext 32) 9, .bin 16 .add 0 8, .un 17 (.zext 32) 16, .bin 18 .ult 17 0, .setf 0 18, .bin 19 .xor 0 17, .bin 20 .xor 8 17, .bin 21 .and 19 20, .const 22 0x80000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 17 39, .setf 4 40, .set 7 17], term := .jump 0x401247#64 }),
    (0x401247#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 9 4, .un 8 (.zext 32) 9, .bin 16 .add 0 8, .un 17 (.zext 32) 16, .bin 18 .ult 17 0, .setf 0 18, .bin 19 .xor 0 17, .bin 20 .xor 8 17, .bin 21 .and 19 20, .const 22 0x80000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 17 39, .setf 4 40, .set 4 17], term := .jump 0x40124a#64 }),
    (0x40124a#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 9 7, .un 8 (.zext 32) 9, .bin 16 .add 0 8, .un 17 (.zext 32) 16, .bin 18 .ult 17 0, .setf 0 18, .bin 19 .xor 0 17, .bin 20 .xor 8 17, .bin 21 .and 19 20, .const 22 0x80000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 17 39, .setf 4 40, .set 7 17], term := .jump 0x40124d#64 }),
    (0x40124d#64, { ops := [.const 0 0x4#64, .get 8 11, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 11 16], term := .jump 0x401251#64 }),
    (0x401251#64, { ops := [.get 0 11, .const 8 0x100#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401258#64 }),
    (0x401258#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x4011d0#64 0x40125e#64 }),
    (0x40125e#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .get 9 6, .const 10 0xffffffffffffff80#64, .bin 8 .add 9 10, .store .w32 8 0], term := .jump 0x401262#64 }),
    (0x401262#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 6, .const 10 0xffffffffffffff84#64, .bin 8 .add 9 10, .store .w32 8 0], term := .jump 0x401266#64 }),
    (0x401266#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 6, .const 10 0xffffffffffffff88#64, .bin 8 .add 9 10, .store .w32 8 0], term := .jump 0x40126a#64 }),
    (0x40126a#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 9 6, .const 10 0xffffffffffffff8c#64, .bin 8 .add 9 10, .store .w32 8 0], term := .jump 0x40126e#64 }),
    (0x40126e#64, { ops := [.get 1 4, .un 0 (.zext 32) 1, .get 9 6, .const 10 0xffffffffffffff90#64, .bin 8 .add 9 10, .store .w32 8 0], term := .jump 0x401272#64 }),
    (0x401272#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 9 6, .const 10 0xffffffffffffff94#64, .bin 8 .add 9 10, .store .w32 8 0], term := .jump 0x401277#64 }),
    (0x401277#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 9 6, .const 10 0xffffffffffffff98#64, .bin 8 .add 9 10, .store .w32 8 0], term := .jump 0x40127c#64 }),
    (0x40127c#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 9 6, .const 10 0xffffffffffffff9c#64, .bin 8 .add 9 10, .store .w32 8 0], term := .jump 0x401281#64 }),
    (0x401281#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401283#64 }),
    (0x401283#64, { ops := [], term := .jump 0x401290#64 }),
    (0x401290#64, { ops := [.get 2 6, .get 3 0, .const 4 0x4#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0xffffffffffffff80#64, .bin 1 .add 6 7, .load 0 .w32 1, .set 2 0], term := .jump 0x401294#64 }),
    (0x401294#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 10 5, .get 11 0, .const 12 0x4#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w32 9, .bin 16 .add 0 8, .un 17 (.zext 32) 16, .bin 18 .ult 17 0, .setf 0 18, .bin 19 .xor 0 17, .bin 20 .xor 8 17, .bin 21 .and 19 20, .const 22 0x80000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 17 39, .setf 4 40, .get 49 5, .get 50 0, .const 51 0x4#64, .bin 52 .mul 50 51, .bin 53 .add 49 52, .const 54 0x0#64, .bin 48 .add 53 54, .store .w32 48 17], term := .jump 0x401297#64 }),
    (0x401297#64, { ops := [.get 0 0, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40129a#64 }),
    (0x40129a#64, { ops := [.get 0 0, .const 8 0x8#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40129e#64 }),
    (0x40129e#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401290#64 0x4012a0#64 }),
    (0x4012a0#64, { ops := [.const 0 0xa0#64, .get 8 6, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 6 16], term := .jump 0x4012a7#64 }),
    (0x4012a7#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3, .set 1 1], term := .jump 0x4012a8#64 }),
    (0x4012a8#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3, .set 12 1], term := .jump 0x4012aa#64 }),
    (0x4012aa#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3, .set 14 1], term := .jump 0x4012ac#64 }),
    (0x4012ac#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3, .set 15 1], term := .jump 0x4012ae#64 }),
    (0x4012ae#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3, .set 7 1], term := .jump 0x4012af#64 }),
    (0x4012af#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `sha256_compress` is the lowering of `sha256_compress_code`. -/
theorem sha256_compress_lowered :
    sha256_compress.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) sha256_compress_code := by
  decide +kernel

/-- The blocks of `sha256_compress` are blocks of the lowering of the executable. -/
theorem sha256_compress_holds :
    ∀ p ∈ sha256_compress.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) sha256_compress_lowered

/-- `_start`, lowered to `braid`. -/
def _start : Braid.Func :=
  { name := "_start", entry := 0x4023b0#64, blocks := [
    (0x4023b0#64, { ops := [.const 0 0x402d40#64, .set 6 0], term := .jump 0x4023b7#64 }),
    (0x4023b7#64, { ops := [], term := .jump 0x4023c0#64 }),
    (0x4023bc#64, { ops := [], term := .jump 0x4023c0#64 })] }

/-- `_start` is the lowering of `_start_code`. -/
theorem _start_lowered :
    _start.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) _start_code := by
  decide +kernel

/-- The blocks of `_start` are blocks of the lowering of the executable. -/
theorem _start_holds :
    ∀ p ∈ _start.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.head _), h⟩) _start_lowered

/-- `main`, lowered to `braid`. -/
def main : Braid.Func :=
  { name := "main", entry := 0x4023c0#64, blocks := [
    (0x4023c0#64, { ops := [.get 0 7, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x4023c1#64 }),
    (0x4023c1#64, { ops := [.get 0 15, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x4023c3#64 }),
    (0x4023c3#64, { ops := [.get 0 14, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x4023c5#64 }),
    (0x4023c5#64, { ops := [.get 0 13, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x4023c7#64 }),
    (0x4023c7#64, { ops := [.get 0 12, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x4023c9#64 }),
    (0x4023c9#64, { ops := [.get 0 1, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x4023ca#64 }),
    (0x4023ca#64, { ops := [.const 0 0x98#64, .get 8 6, .bin 16 .sub 8 0, .bin 18 .ult 8 0, .setf 0 18, .bin 19 .xor 8 0, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 6 16], term := .jump 0x4023d1#64 }),
    (0x4023d1#64, { ops := [.const 0 0x402d60#64, .set 0 0], term := .jump 0x4023d8#64 }),
    (0x4023d8#64, { ops := [.get 1 0, .load 0 .w64 1, .set 15 0], term := .jump 0x4023db#64 }),
    (0x4023db#64, { ops := [.get 1 15, .const 2 0x8#64, .bin 0 .add 1 2, .set 12 0], term := .jump 0x4023df#64 }),
    (0x4023df#64, { ops := [.get 0 12, .set 13 0], term := .jump 0x4023e2#64 }),
    (0x4023e2#64, { ops := [.get 0 13, .const 8 0xffffffffffffffc0#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 13 16], term := .jump 0x4023e6#64 }),
    (0x4023e6#64, { ops := [.get 0 15, .set 7 0], term := .jump 0x4023e9#64 }),
    (0x4023e9#64, { ops := [.get 0 13, .set 2 0], term := .jump 0x4023ec#64 }),
    (0x4023ec#64, { ops := [.const 0 0xbb67ae856a09e667#64, .set 0 0], term := .jump 0x4023f6#64 }),
    (0x4023f6#64, { ops := [.get 0 0, .get 9 6, .const 10 0x10#64, .bin 8 .add 9 10, .store .w64 8 0], term := .jump 0x4023fb#64 }),
    (0x4023fb#64, { ops := [.const 0 0xa54ff53a3c6ef372#64, .set 0 0], term := .jump 0x402405#64 }),
    (0x402405#64, { ops := [.get 0 0, .get 9 6, .const 10 0x18#64, .bin 8 .add 9 10, .store .w64 8 0], term := .jump 0x40240a#64 }),
    (0x40240a#64, { ops := [.const 0 0x9b05688c510e527f#64, .set 0 0], term := .jump 0x402414#64 }),
    (0x402414#64, { ops := [.get 0 0, .get 9 6, .const 10 0x20#64, .bin 8 .add 9 10, .store .w64 8 0], term := .jump 0x402419#64 }),
    (0x402419#64, { ops := [.const 0 0x5be0cd191f83d9ab#64, .set 0 0], term := .jump 0x402423#64 }),
    (0x402423#64, { ops := [.get 0 0, .get 9 6, .const 10 0x28#64, .bin 8 .add 9 10, .store .w64 8 0], term := .jump 0x402428#64 }),
    (0x402428#64, { ops := [.const 0 0x40#64, .get 8 2, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x40242c#64 }),
    (0x40242c#64, { ops := [.get 0 2, .get 9 6, .const 10 0x8#64, .bin 8 .add 9 10, .store .w64 8 0], term := .jump 0x402431#64 }),
    (0x402431#64, { ops := [.getf 0 3], term := .branch 0 0x4024ea#64 0x402437#64 }),
    (0x402437#64, { ops := [.get 0 7, .const 8 0x3#64, .bin 9 .shl 0 8, .const 11 0x3d#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 9 39, .setf 4 40, .set 7 9], term := .jump 0x40243b#64 }),
    (0x40243b#64, { ops := [.get 0 13, .const 8 0x38#64, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 13 16], term := .jump 0x40243f#64 }),
    (0x40243f#64, { ops := [.get 0 12, .const 8 0x3f#64, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 12 16], term := .jump 0x402443#64 }),
    (0x402443#64, { ops := [.get 0 12, .const 8 0x3#64, .bin 9 .shl 0 8, .const 11 0x3d#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 9 39, .setf 4 40, .set 12 9], term := .jump 0x402447#64 }),
    (0x402447#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 9 14, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 14 16], term := .jump 0x40244a#64 }),
    (0x40244a#64, { ops := [.const 0 0x402d68#64, .set 1 0], term := .jump 0x402451#64 }),
    (0x402451#64, { ops := [], term := .jump 0x402481#64 }),
    (0x402453#64, { ops := [], term := .jump 0x402460#64 }),
    (0x402460#64, { ops := [.get 1 6, .const 2 0x10#64, .bin 0 .add 1 2, .set 5 0], term := .jump 0x402465#64 }),
    (0x402465#64, { ops := [.get 1 6, .const 2 0x50#64, .bin 0 .add 1 2, .set 4 0], term := .jump 0x40246a#64 }),
    (0x40246a#64, { ops := [.get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .const 11 0x40246f#64, .store .w64 10 11], term := .jump 0x401100#64 }),
    (0x40246f#64, { ops := [.const 0 0x40#64, .get 8 14, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 14 16], term := .jump 0x402473#64 }),
    (0x402473#64, { ops := [.const 0 0xfffffffffffffe00#64, .get 8 12, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 12 16], term := .jump 0x40247a#64 }),
    (0x40247a#64, { ops := [.get 0 14, .get 10 6, .const 11 0x8#64, .bin 9 .add 10 11, .load 8 .w64 9, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40247f#64 }),
    (0x40247f#64, { ops := [.getf 1 0, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x4024ea#64 0x402481#64 }),
    (0x402481#64, { ops := [.get 0 14, .set 0 0], term := .jump 0x402484#64 }),
    (0x402484#64, { ops := [.get 0 12, .set 3 0], term := .jump 0x402487#64 }),
    (0x402487#64, { ops := [.get 1 4, .un 0 (.zext 32) 1, .get 9 4, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 4 16], term := .jump 0x402489#64 }),
    (0x402489#64, { ops := [], term := .jump 0x4024a5#64 }),
    (0x40248b#64, { ops := [], term := .jump 0x402490#64 }),
    (0x402490#64, { ops := [.get 1 5, .un 0 (.zext 32) 1, .get 9 6, .get 10 4, .const 11 0x4#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x50#64, .bin 8 .add 13 14, .store .w32 8 0], term := .jump 0x402494#64 }),
    (0x402494#64, { ops := [.get 0 4, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 4 16], term := .jump 0x402497#64 }),
    (0x402497#64, { ops := [.const 0 0xffffffffffffffe0#64, .get 8 3, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x40249b#64 }),
    (0x40249b#64, { ops := [.const 0 0x4#64, .get 8 0, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40249f#64 }),
    (0x40249f#64, { ops := [.get 0 4, .const 8 0x10#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x4024a3#64 }),
    (0x4024a3#64, { ops := [.getf 0 3], term := .branch 0 0x402460#64 0x4024a5#64 }),
    (0x4024a5#64, { ops := [.get 1 5, .un 0 (.zext 32) 1, .get 9 5, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 5 16], term := .jump 0x4024a7#64 }),
    (0x4024a7#64, { ops := [.get 0 0, .set 8 0], term := .jump 0x4024aa#64 }),
    (0x4024aa#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 9 9, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 9 16], term := .jump 0x4024ad#64 }),
    (0x4024ad#64, { ops := [], term := .jump 0x4024c7#64 }),
    (0x4024af#64, { ops := [], term := .jump 0x4024b0#64 }),
    (0x4024b0#64, { ops := [.get 2 1, .get 3 8, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 2 0], term := .jump 0x4024b5#64 }),
    (0x4024b5#64, { ops := [.get 1 5, .un 0 (.zext 32) 1, .const 8 0x8#64, .bin 9 .shl 0 8, .un 10 (.zext 32) 9, .const 11 0x18#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 10, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 10 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 10 39, .setf 4 40, .set 5 10], term := .jump 0x4024b8#64 }),
    (0x4024b8#64, { ops := [.get 1 5, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .or 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 5 16], term := .jump 0x4024ba#64 }),
    (0x4024ba#64, { ops := [.const 0 0xfffffffffffffff8#64, .get 8 9, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 9 16], term := .jump 0x4024be#64 }),
    (0x4024be#64, { ops := [.get 0 8, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 8 16], term := .jump 0x4024c1#64 }),
    (0x4024c1#64, { ops := [.get 0 9, .const 8 0xffffffffffffffe0#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x4024c5#64 }),
    (0x4024c5#64, { ops := [.getf 0 3], term := .branch 0 0x402490#64 0x4024c7#64 }),
    (0x4024c7#64, { ops := [.get 0 8, .get 8 15, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x4024ca#64 }),
    (0x4024ca#64, { ops := [.getf 0 0], term := .branch 0 0x4024b0#64 0x4024cc#64 }),
    (0x4024cc#64, { ops := [.const 0 0x80#64, .set 2 0], term := .jump 0x4024d1#64 }),
    (0x4024d1#64, { ops := [.getf 0 3], term := .branch 0 0x4024b5#64 0x4024d3#64 }),
    (0x4024d3#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x4024d5#64 }),
    (0x4024d5#64, { ops := [.get 0 8, .get 8 13, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x4024d8#64 }),
    (0x4024d8#64, { ops := [.getf 0 0], term := .branch 0 0x4024b5#64 0x4024da#64 }),
    (0x4024da#64, { ops := [.get 1 3, .get 2 9, .const 3 0x1#64, .bin 4 .mul 2 3, .bin 5 .add 1 4, .const 6 0x0#64, .bin 0 .add 5 6, .un 8 (.zext 32) 0, .set 2 8], term := .jump 0x4024de#64 }),
    (0x4024de#64, { ops := [.get 0 7, .set 10 0], term := .jump 0x4024e1#64 }),
    (0x4024e1#64, { ops := [.get 0 10, .get 56 2, .const 57 0x3f#64, .bin 8 .and 56 57, .const 28 0x0#64, .bin 29 .eq 8 28, .bin 9 .lshr 0 8, .const 11 0x40#64, .const 14 0x1#64, .bin 12 .sub 8 14, .bin 13 .lshr 0 12, .bin 15 .and 13 14, .havoc 16, .bin 18 .ult 8 11, .select 19 18 15 16, .const 21 0x8000000000000000#64, .bin 22 .and 0 21, .havoc 23, .bin 26 .eq 8 14, .select 27 26 22 23, .havoc 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .bin 38 .eq 9 36, .const 39 0x8000000000000000#64, .bin 40 .and 9 39, .getf 60 0, .select 61 29 60 19, .setf 0 61, .getf 62 1, .select 63 29 62 37, .setf 1 63, .getf 64 2, .select 65 29 64 24, .setf 2 65, .getf 66 3, .select 67 29 66 38, .setf 3 67, .getf 68 4, .select 69 29 68 40, .setf 4 69, .getf 70 5, .select 71 29 70 27, .setf 5 71, .set 10 9], term := .jump 0x4024e4#64 }),
    (0x4024e4#64, { ops := [.get 1 10, .un 0 (.zext 8) 1, .set 2 0], term := .jump 0x4024e8#64 }),
    (0x4024e8#64, { ops := [], term := .jump 0x4024b5#64 }),
    (0x4024ea#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x4024ec#64 }),
    (0x4024ec#64, { ops := [], term := .jump 0x4024f0#64 }),
    (0x4024f0#64, { ops := [.get 2 6, .get 3 0, .const 4 0x4#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x10#64, .bin 1 .add 6 7, .load 0 .w32 1, .set 2 0], term := .jump 0x4024f4#64 }),
    (0x4024f4#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .un 8 .bswap 0, .const 9 0x20#64, .bin 10 .lshr 8 9, .set 2 10], term := .jump 0x4024f6#64 }),
    (0x4024f6#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 6, .get 10 0, .const 11 0x4#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x30#64, .bin 8 .add 13 14, .store .w32 8 0], term := .jump 0x4024fa#64 }),
    (0x4024fa#64, { ops := [.get 0 0, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x4024fd#64 }),
    (0x4024fd#64, { ops := [.get 0 0, .const 8 0x8#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x402501#64 }),
    (0x402501#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x4024f0#64 0x402503#64 }),
    (0x402503#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x402505#64 }),
    (0x402505#64, { ops := [.const 0 0x402d40#64, .set 2 0], term := .jump 0x40250c#64 }),
    (0x40250c#64, { ops := [], term := .jump 0x402510#64 }),
    (0x402510#64, { ops := [.get 2 6, .get 3 0, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x30#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 3 0], term := .jump 0x402515#64 }),
    (0x402515#64, { ops := [.get 1 3, .un 0 (.zext 8) 1, .get 9 0, .get 10 2, .const 11 0x1#64, .bin 12 .mul 10 11, .bin 13 .add 9 12, .const 14 0x0#64, .bin 8 .add 13 14, .store .w8 8 0], term := .jump 0x402518#64 }),
    (0x402518#64, { ops := [.get 0 0, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40251b#64 }),
    (0x40251b#64, { ops := [.get 0 0, .const 8 0x20#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40251f#64 }),
    (0x40251f#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x402510#64 0x402521#64 }),
    (0x402521#64, { ops := [], term := .jump 0x402530#64 }),
    (0x402530#64, { ops := [], term := .jump 0x402530#64 })] }

/-- `main` is the lowering of `main_code`. -/
theorem main_lowered :
    main.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) main_code := by
  decide +kernel

/-- The blocks of `main` are blocks of the lowering of the executable. -/
theorem main_holds :
    ∀ p ∈ main.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)), h⟩) main_lowered

/-- The bytes of the section `.rodata`. -/
def sha256_main_section_rodata : List (BitVec 8) := [
  152, 47, 138, 66, 145, 68, 55, 113, 207, 251, 192, 181, 165, 219, 181, 233, 91, 194, 86, 57, 241, 17, 241, 89, 164, 130, 63, 146, 213, 94, 28, 171, 152, 170, 7, 216, 1, 91, 131, 18, 190, 133, 49, 36, 195, 125, 12, 85, 116, 93, 190, 114, 254, 177, 222, 128, 167, 6, 220, 155, 116, 241, 155, 193, 193, 105, 155, 228, 134, 71, 190, 239, 198, 157, 193, 15, 204, 161, 12, 36, 111, 44, 233, 45, 170, 132, 116, 74, 220, 169, 176, 92, 218, 136, 249, 118, 82, 81, 62, 152, 109, 198, 49, 168, 200, 39, 3, 176, 199, 127, 89, 191, 243, 11, 224, 198, 71, 145, 167, 213, 81, 99, 202, 6, 103, 41, 41, 20, 133, 10, 183, 39, 56, 33, 27, 46, 252, 109, 44, 77, 19, 13, 56, 83, 84, 115, 10, 101, 187, 10, 106, 118, 46, 201, 194, 129, 133, 44, 114, 146, 161, 232, 191, 162, 75, 102, 26, 168, 112, 139, 75, 194, 163, 81, 108, 199, 25, 232, 146, 209, 36, 6, 153, 214, 133, 53, 14, 244, 112, 160, 106, 16, 22, 193, 164, 25, 8, 108, 55, 30, 76, 119, 72, 39, 181, 188, 176, 52, 179, 12, 28, 57, 74, 170, 216, 78, 79, 202, 156, 91, 243, 111, 46, 104, 238, 130, 143, 116, 111, 99, 165, 120, 20, 120, 200, 132, 8, 2, 199, 140, 250, 255, 190, 144, 235, 108, 80, 164, 247, 163, 249, 190, 242, 120, 113, 198]

/-- The bytes of the section `.msglen`. -/
def sha256_main_section_msglen : List (BitVec 8) := [
  3, 0, 0, 0, 0, 0, 0, 0]

/-- The bytes of the section `.msg`. -/
def sha256_main_section_msg : List (BitVec 8) := [
  97, 98, 99]

/-- The binary as it is loaded: its lines, its sections and its entry point. -/
def sha256_main_image : Braid.Image Lowering.X86.Line :=
  { entry := 0x4023b0#64,
    code := image.map fun l => (BitVec.ofNat 64 l.addr, l),
    data := [
      (0x4022b0#64, sha256_main_section_rodata),
      (0x402540#64, List.replicate 2080 0#8),
      (0x402d60#64, sha256_main_section_msglen),
      (0x402d68#64, sha256_main_section_msg)],
    zero := [] }

/-- The blocks of the whole program. -/
def sha256_main_blocks : List (Braid.Word × Braid.Block) :=
  sha256_compress.blocks ++ _start.blocks ++ main.blocks

/-- The blocks of the program are blocks of the lowering of the executable. -/
theorem sha256_main_holds :
    ∀ p ∈ sha256_main_blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 := by
  intro p hp
  simp only [sha256_main_blocks, List.mem_append] at hp
  rcases hp with ((hp | hp) | hp)
  · exact sha256_compress_holds p hp
  · exact _start_holds p hp
  · exact main_holds p hp

/-- The sections of the image do not overlap. -/
theorem sha256_main_apart : Braid.Sections.Apart sha256_main_image.sections := by
  decide +kernel

end Examples.Sha256Main.X86
