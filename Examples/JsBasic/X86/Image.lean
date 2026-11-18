/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.JsBasic.X86


/-- The lines of `js_add3`, from `0x401000`. -/
def js_add3_code : List Lowering.X86.Line := [
  ⟨0x401000, 4, "L401000", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rcx)), idx := none, disp := ConstExpr.int64 (-64) }))))⟩,
  ⟨0x401004, 4, "L401004", some (Instr.regular (Width.W64) (Width.W8) (Operation.test (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rbx)), idx := none, disp := ConstExpr.int64 15 }) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401008, 2, "L401008", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L401017"))⟩,
  ⟨0x40100a, 10, "L40100a", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W64))) (Operand.imm (ConstExpr.int64 4305610400))))⟩,
  ⟨0x401014, 3, "L401014", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.reg (Reg.low (Reg64.r10) (Width.W64)))))⟩,
  ⟨0x401017, 1, "L401017", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64))))))⟩,
  ⟨0x401018, 3, "L401018", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsp) (Width.W64))))))⟩,
  ⟨0x40101b, 1, "L40101b", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x40101c, 1, "L40101c", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))))))⟩,
  ⟨0x40101d, 4, "L40101d", some (Instr.regular (Width.W64) (Width.W64) (Operation.sub (RegOrMem.reg (Reg.low (Reg64.rsp) (Width.W64))) (Operand.imm (ConstExpr.int64 8))))⟩,
  ⟨0x401021, 4, "L401021", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rbp)), idx := none, disp := ConstExpr.int64 (-24) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401025, 4, "L401025", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rsp) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.r13)), idx := none, disp := ConstExpr.int64 (-32) }))))⟩,
  ⟨0x401029, 6, "L401029", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.be) "L401084"))⟩,
  ⟨0x40102f, 4, "L40102f", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rbp)), idx := none, disp := ConstExpr.int64 32 }))))⟩,
  ⟨0x401033, 3, "L401033", some (Instr.regular (Width.W64) (Width.W8) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W8))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401036, 6, "L401036", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L4010bb"))⟩,
  ⟨0x40103c, 4, "L40103c", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rbp)), idx := none, disp := ConstExpr.int64 24 }))))⟩,
  ⟨0x401040, 3, "L401040", some (Instr.regular (Width.W64) (Width.W8) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W8))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401043, 6, "L401043", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L4010c7"))⟩,
  ⟨0x401049, 3, "L401049", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x40104c, 4, "L40104c", some (Instr.regular (Width.W64) (Width.W64) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (ShiftCountExpr.imm8 (ConstExpr.int64 32))))⟩,
  ⟨0x401050, 3, "L401050", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401053, 4, "L401053", some (Instr.regular (Width.W64) (Width.W64) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))) (ShiftCountExpr.imm8 (ConstExpr.int64 32))))⟩,
  ⟨0x401057, 3, "L401057", some (Instr.regular (Width.W64) (Width.W32) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x40105a, 6, "L40105a", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.o) "L4010d3"))⟩,
  ⟨0x401060, 4, "L401060", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rbp)), idx := none, disp := ConstExpr.int64 16 }))))⟩,
  ⟨0x401064, 4, "L401064", some (Instr.regular (Width.W64) (Width.W8) (Operation.test (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W8))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401068, 6, "L401068", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L4010df"))⟩,
  ⟨0x40106e, 4, "L40106e", some (Instr.regular (Width.W64) (Width.W64) (Operation.sar (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W64))) (ShiftCountExpr.imm8 (ConstExpr.int64 32))))⟩,
  ⟨0x401072, 4, "L401072", some (Instr.regular (Width.W64) (Width.W32) (Operation.lea (Reg.low (Reg64.rdx) (Width.W32)) { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.r8, scale := Width.W8 }, disp := ConstExpr.int64 0 }))⟩,
  ⟨0x401076, 4, "L401076", some (Instr.regular (Width.W64) (Width.W64) (Operation.shl (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (ShiftCountExpr.imm8 (ConstExpr.int64 32))))⟩,
  ⟨0x40107a, 3, "L40107a", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x40107d, 3, "L40107d", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsp) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64))))))⟩,
  ⟨0x401080, 1, "L401080", some (Instr.regular (Width.W64) (Width.W64) (Operation.pop (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64)))))⟩,
  ⟨0x401081, 3, "L401081", none⟩,
  ⟨0x401084, 10, "L401084", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.imm (ConstExpr.int64 240518168576))))⟩,
  ⟨0x40108e, 1, "L40108e", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x40108f, 10, "L40108f", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64))) (Operand.imm (ConstExpr.int64 4302332736))))⟩,
  ⟨0x401099, 5, "L401099", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x40109e, 10, "L40109e", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.imm (ConstExpr.int64 21790333600033))))⟩,
  ⟨0x4010a8, 10, "L4010a8", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W64))) (Operand.imm (ConstExpr.int64 4306038848))))⟩,
  ⟨0x4010b2, 3, "L4010b2", some (Instr.regular (Width.W64) (Width.W64) (Operation.call (RelRegOrMem.reg (Reg.low (Reg64.r10) (Width.W64)))))⟩,
  ⟨0x4010b5, 5, "L4010b5", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4198447) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x4010ba, 1, "L4010ba", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 1))⟩,
  ⟨0x4010bb, 7, "L4010bb", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))) (Operand.imm (ConstExpr.int64 0))))⟩,
  ⟨0x4010c2, 5, "L4010c2", some (Instr.regular (Width.W64) (Width.W64) (Operation.call (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4455104) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x4010c7, 7, "L4010c7", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x4010ce, 5, "L4010ce", some (Instr.regular (Width.W64) (Width.W64) (Operation.call (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4455104) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x4010d3, 7, "L4010d3", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))) (Operand.imm (ConstExpr.int64 2))))⟩,
  ⟨0x4010da, 5, "L4010da", some (Instr.regular (Width.W64) (Width.W64) (Operation.call (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4455104) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x4010df, 7, "L4010df", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))) (Operand.imm (ConstExpr.int64 3))))⟩,
  ⟨0x4010e6, 5, "L4010e6", some (Instr.regular (Width.W64) (Width.W64) (Operation.call (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4455104) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x4010eb, 7, "L4010eb", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))) (Operand.imm (ConstExpr.int64 4))))⟩,
  ⟨0x4010f2, 5, "L4010f2", some (Instr.regular (Width.W64) (Width.W64) (Operation.call (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4717248) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x4010f7, 1, "L4010f7", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 1))⟩]

/-- The lines of `js_max`, from `0x4010f8`. -/
def js_max_code : List Lowering.X86.Line := [
  ⟨0x4010f8, 4, "L4010f8", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rcx)), idx := none, disp := ConstExpr.int64 (-64) }))))⟩,
  ⟨0x4010fc, 4, "L4010fc", some (Instr.regular (Width.W64) (Width.W8) (Operation.test (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rbx)), idx := none, disp := ConstExpr.int64 15 }) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401100, 2, "L401100", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L40110f"))⟩,
  ⟨0x401102, 10, "L401102", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W64))) (Operand.imm (ConstExpr.int64 4305610400))))⟩,
  ⟨0x40110c, 3, "L40110c", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.reg (Reg.low (Reg64.r10) (Width.W64)))))⟩,
  ⟨0x40110f, 1, "L40110f", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64))))))⟩,
  ⟨0x401110, 3, "L401110", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsp) (Width.W64))))))⟩,
  ⟨0x401113, 1, "L401113", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x401114, 1, "L401114", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))))))⟩,
  ⟨0x401115, 4, "L401115", some (Instr.regular (Width.W64) (Width.W64) (Operation.sub (RegOrMem.reg (Reg.low (Reg64.rsp) (Width.W64))) (Operand.imm (ConstExpr.int64 8))))⟩,
  ⟨0x401119, 4, "L401119", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rbp)), idx := none, disp := ConstExpr.int64 (-24) }) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))))))⟩,
  ⟨0x40111d, 4, "L40111d", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rsp) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.r13)), idx := none, disp := ConstExpr.int64 (-32) }))))⟩,
  ⟨0x401121, 6, "L401121", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.be) "L401155"))⟩,
  ⟨0x401127, 4, "L401127", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rbp)), idx := none, disp := ConstExpr.int64 16 }))))⟩,
  ⟨0x40112b, 2, "L40112b", some (Instr.regular (Width.W64) (Width.W8) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W8))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x40112d, 6, "L40112d", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401189"))⟩,
  ⟨0x401133, 4, "L401133", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rbp)), idx := none, disp := ConstExpr.int64 24 }))))⟩,
  ⟨0x401137, 3, "L401137", some (Instr.regular (Width.W64) (Width.W8) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W8))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x40113a, 6, "L40113a", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401195"))⟩,
  ⟨0x401140, 3, "L401140", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401143, 6, "L401143", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.l) "L401150"))⟩,
  ⟨0x401149, 3, "L401149", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsp) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64))))))⟩,
  ⟨0x40114c, 1, "L40114c", some (Instr.regular (Width.W64) (Width.W64) (Operation.pop (RegOrMem.reg (Reg.low (Reg64.rbp) (Width.W64)))))⟩,
  ⟨0x40114d, 3, "L40114d", none⟩,
  ⟨0x401150, 3, "L401150", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401153, 2, "L401153", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4198729) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x401155, 10, "L401155", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.imm (ConstExpr.int64 171798691840))))⟩,
  ⟨0x40115f, 1, "L40115f", some (Instr.regular (Width.W64) (Width.W64) (Operation.push (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401160, 10, "L401160", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rbx) (Width.W64))) (Operand.imm (ConstExpr.int64 4302332736))))⟩,
  ⟨0x40116a, 5, "L40116a", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x40116f, 10, "L40116f", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rsi) (Width.W64))) (Operand.imm (ConstExpr.int64 51815395623201))))⟩,
  ⟨0x401179, 10, "L401179", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r10) (Width.W64))) (Operand.imm (ConstExpr.int64 4306038848))))⟩,
  ⟨0x401183, 3, "L401183", some (Instr.regular (Width.W64) (Width.W64) (Operation.call (RelRegOrMem.reg (Reg.low (Reg64.r10) (Width.W64)))))⟩,
  ⟨0x401186, 2, "L401186", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4198695) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x401188, 1, "L401188", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 1))⟩,
  ⟨0x401189, 7, "L401189", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))) (Operand.imm (ConstExpr.int64 0))))⟩,
  ⟨0x401190, 5, "L401190", some (Instr.regular (Width.W64) (Width.W64) (Operation.call (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4454968) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x401195, 7, "L401195", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x40119c, 5, "L40119c", some (Instr.regular (Width.W64) (Width.W64) (Operation.call (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4454968) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x4011a1, 7, "L4011a1", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r13) (Width.W64))) (Operand.imm (ConstExpr.int64 2))))⟩,
  ⟨0x4011a8, 5, "L4011a8", some (Instr.regular (Width.W64) (Width.W64) (Operation.call (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4717112) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x4011ad, 3, "L4011ad", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 3))⟩]

/-- The lines of every function lowered here, in address order. -/
def image : List Lowering.X86.Line :=
  List.flatten [js_add3_code, js_max_code]

/-- The lines of the image follow one another. -/
theorem image_wf : Lowering.X86.wf image = true := by
  decide

/-- The executable of the image: the program of the machine model. -/
def exe : Executable := Lowering.X86.exeOf image

/-- `js_add3`, lowered to `braid`. -/
def js_add3 : Braid.Func :=
  { name := "js_add3", entry := 0x401000#64, blocks := [
    (0x401000#64, { ops := [.get 2 2, .const 3 0xffffffffffffffc0#64, .bin 1 .add 2 3, .load 0 .w64 1, .set 1 0], term := .jump 0x401004#64 }),
    (0x401004#64, { ops := [.get 2 1, .const 3 0xf#64, .bin 1 .add 2 3, .load 0 .w8 1, .const 8 0x1#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401008#64 }),
    (0x401008#64, { ops := [.getf 0 3], term := .branch 0 0x401017#64 0x40100a#64 }),
    (0x40100a#64, { ops := [.const 0 0x100a266a0#64, .set 10 0], term := .jump 0x401014#64 }),
    (0x401014#64, { ops := [.get 0 10], term := .jumpInd 0 }),
    (0x401017#64, { ops := [.get 0 7, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x401018#64 }),
    (0x401018#64, { ops := [.get 0 6, .set 7 0], term := .jump 0x40101b#64 }),
    (0x40101b#64, { ops := [.get 0 4, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x40101c#64 }),
    (0x40101c#64, { ops := [.get 0 5, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x40101d#64 }),
    (0x40101d#64, { ops := [.const 0 0x8#64, .get 8 6, .bin 16 .sub 8 0, .bin 18 .ult 8 0, .setf 0 18, .bin 19 .xor 8 0, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 6 16], term := .jump 0x401021#64 }),
    (0x401021#64, { ops := [.get 0 4, .get 9 7, .const 10 0xffffffffffffffe8#64, .bin 8 .add 9 10, .store .w64 8 0], term := .jump 0x401025#64 }),
    (0x401025#64, { ops := [.get 0 6, .get 10 13, .const 11 0xffffffffffffffe0#64, .bin 9 .add 10 11, .load 8 .w64 9, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401029#64 }),
    (0x401029#64, { ops := [.getf 1 0, .getf 2 3, .bin 0 .or 1 2], term := .branch 0 0x401084#64 0x40102f#64 }),
    (0x40102f#64, { ops := [.get 2 7, .const 3 0x20#64, .bin 1 .add 2 3, .load 0 .w64 1, .set 3 0], term := .jump 0x401033#64 }),
    (0x401033#64, { ops := [.get 1 3, .un 0 (.zext 8) 1, .const 8 0x1#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401036#64 }),
    (0x401036#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x4010bb#64 0x40103c#64 }),
    (0x40103c#64, { ops := [.get 2 7, .const 3 0x18#64, .bin 1 .add 2 3, .load 0 .w64 1, .set 2 0], term := .jump 0x401040#64 }),
    (0x401040#64, { ops := [.get 1 2, .un 0 (.zext 8) 1, .const 8 0x1#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401043#64 }),
    (0x401043#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x4010c7#64 0x401049#64 }),
    (0x401049#64, { ops := [.get 0 2, .set 5 0], term := .jump 0x40104c#64 }),
    (0x40104c#64, { ops := [.get 0 5, .const 8 0x20#64, .bin 9 .lshr 0 8, .const 11 0x1f#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 9 39, .setf 4 40, .set 5 9], term := .jump 0x401050#64 }),
    (0x401050#64, { ops := [.get 0 3, .set 8 0], term := .jump 0x401053#64 }),
    (0x401053#64, { ops := [.get 0 8, .const 8 0x20#64, .bin 9 .lshr 0 8, .const 11 0x1f#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 9 39, .setf 4 40, .set 8 9], term := .jump 0x401057#64 }),
    (0x401057#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 9 5, .un 8 (.zext 32) 9, .bin 16 .add 0 8, .un 17 (.zext 32) 16, .bin 18 .ult 17 0, .setf 0 18, .bin 19 .xor 0 17, .bin 20 .xor 8 17, .bin 21 .and 19 20, .const 22 0x80000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 17, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 17 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 17 39, .setf 4 40, .set 5 17], term := .jump 0x40105a#64 }),
    (0x40105a#64, { ops := [.getf 0 5], term := .branch 0 0x4010d3#64 0x401060#64 }),
    (0x401060#64, { ops := [.get 2 7, .const 3 0x10#64, .bin 1 .add 2 3, .load 0 .w64 1, .set 8 0], term := .jump 0x401064#64 }),
    (0x401064#64, { ops := [.get 1 8, .un 0 (.zext 8) 1, .const 8 0x1#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401068#64 }),
    (0x401068#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x4010df#64 0x40106e#64 }),
    (0x40106e#64, { ops := [.get 0 8, .un 7 (.sext 64) 0, .const 8 0x20#64, .bin 9 .ashr 7 8, .const 11 0x1f#64, .bin 12 .ashr 7 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 9 39, .setf 4 40, .set 8 9], term := .jump 0x401072#64 }),
    (0x401072#64, { ops := [.get 1 5, .get 2 8, .const 3 0x1#64, .bin 4 .mul 2 3, .bin 5 .add 1 4, .const 6 0x0#64, .bin 0 .add 5 6, .un 8 (.zext 32) 0, .set 3 8], term := .jump 0x401076#64 }),
    (0x401076#64, { ops := [.get 0 3, .const 8 0x20#64, .bin 9 .shl 0 8, .const 11 0x20#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 9 39, .setf 4 40, .set 3 9], term := .jump 0x40107a#64 }),
    (0x40107a#64, { ops := [.get 0 3, .set 0 0], term := .jump 0x40107d#64 }),
    (0x40107d#64, { ops := [.get 0 7, .set 6 0], term := .jump 0x401080#64 }),
    (0x401080#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3, .set 7 1], term := .jump 0x401081#64 }),
    (0x401084#64, { ops := [.const 0 0x3800000000#64, .set 3 0], term := .jump 0x40108e#64 }),
    (0x40108e#64, { ops := [.get 0 3, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x40108f#64 }),
    (0x40108f#64, { ops := [.const 0 0x100706340#64, .set 1 0], term := .jump 0x401099#64 }),
    (0x401099#64, { ops := [.const 0 0x1#64, .set 0 0], term := .jump 0x40109e#64 }),
    (0x40109e#64, { ops := [.const 0 0x13d175180121#64, .set 4 0], term := .jump 0x4010a8#64 }),
    (0x4010a8#64, { ops := [.const 0 0x100a8f040#64, .set 10 0], term := .jump 0x4010b2#64 }),
    (0x4010b2#64, { ops := [.get 0 10, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .const 11 0x4010b5#64, .store .w64 10 11], term := .jumpInd 0 }),
    (0x4010b5#64, { ops := [], term := .jump 0x40102f#64 }),
    (0x4010ba#64, { ops := [], term := .jump 0x4010bb#64 }),
    (0x4010bb#64, { ops := [.const 0 0x0#64, .set 13 0], term := .jump 0x4010c2#64 }),
    (0x4010c2#64, { ops := [.get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .const 11 0x4010c7#64, .store .w64 10 11], term := .jump 0x43fac0#64 }),
    (0x4010c7#64, { ops := [.const 0 0x1#64, .set 13 0], term := .jump 0x4010ce#64 }),
    (0x4010ce#64, { ops := [.get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .const 11 0x4010d3#64, .store .w64 10 11], term := .jump 0x43fac0#64 }),
    (0x4010d3#64, { ops := [.const 0 0x2#64, .set 13 0], term := .jump 0x4010da#64 }),
    (0x4010da#64, { ops := [.get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .const 11 0x4010df#64, .store .w64 10 11], term := .jump 0x43fac0#64 }),
    (0x4010df#64, { ops := [.const 0 0x3#64, .set 13 0], term := .jump 0x4010e6#64 }),
    (0x4010e6#64, { ops := [.get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .const 11 0x4010eb#64, .store .w64 10 11], term := .jump 0x43fac0#64 }),
    (0x4010eb#64, { ops := [.const 0 0x4#64, .set 13 0], term := .jump 0x4010f2#64 }),
    (0x4010f2#64, { ops := [.get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .const 11 0x4010f7#64, .store .w64 10 11], term := .jump 0x47fac0#64 }),
    (0x4010f7#64, { ops := [], term := .jump 0x4010f8#64 })] }

/-- `js_add3` is the lowering of `js_add3_code`. -/
theorem js_add3_lowered :
    js_add3.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) js_add3_code := by
  decide

/-- The blocks of `js_add3` are blocks of the lowering of the executable. -/
theorem js_add3_holds :
    ∀ p ∈ js_add3.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) js_add3_lowered

/-- `js_max`, lowered to `braid`. -/
def js_max : Braid.Func :=
  { name := "js_max", entry := 0x4010f8#64, blocks := [
    (0x4010f8#64, { ops := [.get 2 2, .const 3 0xffffffffffffffc0#64, .bin 1 .add 2 3, .load 0 .w64 1, .set 1 0], term := .jump 0x4010fc#64 }),
    (0x4010fc#64, { ops := [.get 2 1, .const 3 0xf#64, .bin 1 .add 2 3, .load 0 .w8 1, .const 8 0x1#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401100#64 }),
    (0x401100#64, { ops := [.getf 0 3], term := .branch 0 0x40110f#64 0x401102#64 }),
    (0x401102#64, { ops := [.const 0 0x100a266a0#64, .set 10 0], term := .jump 0x40110c#64 }),
    (0x40110c#64, { ops := [.get 0 10], term := .jumpInd 0 }),
    (0x40110f#64, { ops := [.get 0 7, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x401110#64 }),
    (0x401110#64, { ops := [.get 0 6, .set 7 0], term := .jump 0x401113#64 }),
    (0x401113#64, { ops := [.get 0 4, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x401114#64 }),
    (0x401114#64, { ops := [.get 0 5, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x401115#64 }),
    (0x401115#64, { ops := [.const 0 0x8#64, .get 8 6, .bin 16 .sub 8 0, .bin 18 .ult 8 0, .setf 0 18, .bin 19 .xor 8 0, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 6 16], term := .jump 0x401119#64 }),
    (0x401119#64, { ops := [.get 0 4, .get 9 7, .const 10 0xffffffffffffffe8#64, .bin 8 .add 9 10, .store .w64 8 0], term := .jump 0x40111d#64 }),
    (0x40111d#64, { ops := [.get 0 6, .get 10 13, .const 11 0xffffffffffffffe0#64, .bin 9 .add 10 11, .load 8 .w64 9, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401121#64 }),
    (0x401121#64, { ops := [.getf 1 0, .getf 2 3, .bin 0 .or 1 2], term := .branch 0 0x401155#64 0x401127#64 }),
    (0x401127#64, { ops := [.get 2 7, .const 3 0x10#64, .bin 1 .add 2 3, .load 0 .w64 1, .set 0 0], term := .jump 0x40112b#64 }),
    (0x40112b#64, { ops := [.get 1 0, .un 0 (.zext 8) 1, .const 8 0x1#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40112d#64 }),
    (0x40112d#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401189#64 0x401133#64 }),
    (0x401133#64, { ops := [.get 2 7, .const 3 0x18#64, .bin 1 .add 2 3, .load 0 .w64 1, .set 3 0], term := .jump 0x401137#64 }),
    (0x401137#64, { ops := [.get 1 3, .un 0 (.zext 8) 1, .const 8 0x1#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40113a#64 }),
    (0x40113a#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401195#64 0x401140#64 }),
    (0x401140#64, { ops := [.get 0 0, .get 8 3, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401143#64 }),
    (0x401143#64, { ops := [.getf 1 4, .getf 2 5, .bin 0 .xor 1 2], term := .branch 0 0x401150#64 0x401149#64 }),
    (0x401149#64, { ops := [.get 0 7, .set 6 0], term := .jump 0x40114c#64 }),
    (0x40114c#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3, .set 7 1], term := .jump 0x40114d#64 }),
    (0x401150#64, { ops := [.get 0 3, .set 0 0], term := .jump 0x401153#64 }),
    (0x401153#64, { ops := [], term := .jump 0x401149#64 }),
    (0x401155#64, { ops := [.const 0 0x2800000000#64, .set 3 0], term := .jump 0x40115f#64 }),
    (0x40115f#64, { ops := [.get 0 3, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .store .w64 10 0], term := .jump 0x401160#64 }),
    (0x401160#64, { ops := [.const 0 0x100706340#64, .set 1 0], term := .jump 0x40116a#64 }),
    (0x40116a#64, { ops := [.const 0 0x1#64, .set 0 0], term := .jump 0x40116f#64 }),
    (0x40116f#64, { ops := [.const 0 0x2f2036400121#64, .set 4 0], term := .jump 0x401179#64 }),
    (0x401179#64, { ops := [.const 0 0x100a8f040#64, .set 10 0], term := .jump 0x401183#64 }),
    (0x401183#64, { ops := [.get 0 10, .get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .const 11 0x401186#64, .store .w64 10 11], term := .jumpInd 0 }),
    (0x401186#64, { ops := [], term := .jump 0x401127#64 }),
    (0x401188#64, { ops := [], term := .jump 0x401189#64 }),
    (0x401189#64, { ops := [.const 0 0x0#64, .set 13 0], term := .jump 0x401190#64 }),
    (0x401190#64, { ops := [.get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .const 11 0x401195#64, .store .w64 10 11], term := .jump 0x43fa38#64 }),
    (0x401195#64, { ops := [.const 0 0x1#64, .set 13 0], term := .jump 0x40119c#64 }),
    (0x40119c#64, { ops := [.get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .const 11 0x4011a1#64, .store .w64 10 11], term := .jump 0x43fa38#64 }),
    (0x4011a1#64, { ops := [.const 0 0x2#64, .set 13 0], term := .jump 0x4011a8#64 }),
    (0x4011a8#64, { ops := [.get 8 6, .const 9 0x8#64, .bin 10 .sub 8 9, .set 6 10, .const 11 0x4011ad#64, .store .w64 10 11], term := .jump 0x47fa38#64 }),
    (0x4011ad#64, { ops := [], term := .jump 0x4011b0#64 })] }

/-- `js_max` is the lowering of `js_max_code`. -/
theorem js_max_lowered :
    js_max.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) js_max_code := by
  decide

/-- The blocks of `js_max` are blocks of the lowering of the executable. -/
theorem js_max_holds :
    ∀ p ∈ js_max.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.tail _ (List.Mem.head _), h⟩) js_max_lowered

end Examples.JsBasic.X86
