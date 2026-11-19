/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.Crc32.O2.X86


/-- The lines of `crc32`, from `0x401000`. -/
def crc32_code : List Lowering.X86.Line := [
  ⟨0x401000, 2, "L401000", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W32))))))⟩,
  ⟨0x401002, 3, "L401002", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401005, 6, "L401005", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L4010ab"))⟩,
  ⟨0x40100b, 2, "L40100b", some (Instr.regular (Width.W64) (Width.W32) (Operation.not (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32)))))⟩,
  ⟨0x40100d, 4, "L40100d", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401011, 2, "L401011", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401017"))⟩,
  ⟨0x401013, 2, "L401013", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x401015, 2, "L401015", some (Instr.regular (Width.W64) (Width.W64) (Operation.jmp (RelRegOrMem.rel (ConstExpr.sub (ConstExpr.int64 4198534) (ConstExpr.after_current_instruction)))))⟩,
  ⟨0x401017, 3, "L401017", some (Instr.regular (Width.W64) (Width.W64) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x40101a, 4, "L40101a", some (Instr.regular (Width.W64) (Width.W64) (Operation.and (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.imm (ConstExpr.int64 (-2)))))⟩,
  ⟨0x40101e, 2, "L40101e", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x401020, 7, "L401020", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.r8) (Width.W64)) { base := some (RegOrRip.rip), idx := none, disp := ConstExpr.int64 4233 }))⟩,
  ⟨0x401027, 9, "L401027", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 9))⟩,
  ⟨0x401030, 5, "L401030", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 })))⟩,
  ⟨0x401035, 3, "L401035", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401038, 3, "L401038", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))))))⟩,
  ⟨0x40103b, 3, "L40103b", some (Instr.regular (Width.W64) (Width.W32) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 4))))⟩,
  ⟨0x40103e, 4, "L40103e", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.imm (ConstExpr.int64 15))))⟩,
  ⟨0x401042, 4, "L401042", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.r8)), idx := some { reg := Reg64.r9, scale := Width.W32 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401046, 3, "L401046", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401049, 4, "L401049", some (Instr.regular (Width.W64) (Width.W32) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 4))))⟩,
  ⟨0x40104d, 3, "L40104d", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.imm (ConstExpr.int64 15))))⟩,
  ⟨0x401050, 4, "L401050", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.r8)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401054, 5, "L401054", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 1 })))⟩,
  ⟨0x401059, 3, "L401059", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))))))⟩,
  ⟨0x40105c, 3, "L40105c", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40105f, 4, "L40105f", some (Instr.regular (Width.W64) (Width.W32) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 4))))⟩,
  ⟨0x401063, 3, "L401063", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.imm (ConstExpr.int64 15))))⟩,
  ⟨0x401066, 4, "L401066", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.r8)), idx := some { reg := Reg64.rax, scale := Width.W32 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x40106a, 3, "L40106a", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))))))⟩,
  ⟨0x40106d, 3, "L40106d", some (Instr.regular (Width.W64) (Width.W32) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 4))))⟩,
  ⟨0x401070, 4, "L401070", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.imm (ConstExpr.int64 15))))⟩,
  ⟨0x401074, 4, "L401074", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.r8)), idx := some { reg := Reg64.r9, scale := Width.W32 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401078, 4, "L401078", some (Instr.regular (Width.W64) (Width.W64) (Operation.add (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))) (Operand.imm (ConstExpr.int64 2))))⟩,
  ⟨0x40107c, 3, "L40107c", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x40107f, 2, "L40107f", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401030"))⟩,
  ⟨0x401081, 3, "L401081", some (Instr.regular (Width.W64) (Width.W8) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W8))) (Operand.imm (ConstExpr.int64 1))))⟩,
  ⟨0x401084, 2, "L401084", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L4010a9"))⟩,
  ⟨0x401086, 4, "L401086", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 })))⟩,
  ⟨0x40108a, 2, "L40108a", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x40108c, 2, "L40108c", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x40108e, 3, "L40108e", some (Instr.regular (Width.W64) (Width.W32) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 4))))⟩,
  ⟨0x401091, 3, "L401091", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.imm (ConstExpr.int64 15))))⟩,
  ⟨0x401094, 7, "L401094", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rsi) (Width.W64)) { base := some (RegOrRip.rip), idx := none, disp := ConstExpr.int64 4117 }))⟩,
  ⟨0x40109b, 3, "L40109b", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rcx, scale := Width.W32 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x40109e, 2, "L40109e", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))))))⟩,
  ⟨0x4010a0, 3, "L4010a0", some (Instr.regular (Width.W64) (Width.W32) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 4))))⟩,
  ⟨0x4010a3, 3, "L4010a3", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W32))) (Operand.imm (ConstExpr.int64 15))))⟩,
  ⟨0x4010a6, 3, "L4010a6", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rdx, scale := Width.W32 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x4010a9, 2, "L4010a9", some (Instr.regular (Width.W64) (Width.W32) (Operation.not (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32)))))⟩,
  ⟨0x4010ab, 1, "L4010ab", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩]

/-- The lines of every function lowered here, in address order. -/
def image : List Lowering.X86.Line :=
  List.flatten [crc32_code]

/-- The lines of the image follow one another. -/
theorem image_wf : Lowering.X86.wf image = true := by
  decide

/-- The executable of the image: the program of the machine model. -/
def exe : Executable := Lowering.X86.exeOf image

/-- `crc32`, lowered to `braid`. -/
def crc32 : Braid.Func :=
  { name := "crc32", entry := 0x401000#64, blocks := [
    (0x401000#64, { ops := [.get 1 5, .un 0 (.zext 32) 1, .set 0 0], term := .jump 0x401002#64 }),
    (0x401002#64, { ops := [.get 0 3, .get 8 3, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401005#64 }),
    (0x401005#64, { ops := [.getf 0 3], term := .branch 0 0x4010ab#64 0x40100b#64 }),
    (0x40100b#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .un 8 .not 0, .un 9 (.zext 32) 8, .set 0 9], term := .jump 0x40100d#64 }),
    (0x40100d#64, { ops := [.get 0 3, .const 8 0x1#64, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401011#64 }),
    (0x401011#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401017#64 0x401013#64 }),
    (0x401013#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x401015#64 }),
    (0x401015#64, { ops := [], term := .jump 0x401086#64 }),
    (0x401017#64, { ops := [.get 0 3, .set 5 0], term := .jump 0x40101a#64 }),
    (0x40101a#64, { ops := [.get 0 5, .const 8 0xfffffffffffffffe#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 5 16], term := .jump 0x40101e#64 }),
    (0x40101e#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x401020#64 }),
    (0x401020#64, { ops := [.const 0 0x4020b0#64, .set 8 0], term := .jump 0x401027#64 }),
    (0x401027#64, { ops := [], term := .jump 0x401030#64 }),
    (0x401030#64, { ops := [.get 2 4, .get 3 2, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 9 0], term := .jump 0x401035#64 }),
    (0x401035#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 9 16], term := .jump 0x401038#64 }),
    (0x401038#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .set 0 0], term := .jump 0x40103b#64 }),
    (0x40103b#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .const 8 0x4#64, .bin 9 .lshr 0 8, .const 11 0x3#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 9 39, .setf 4 40, .set 0 9], term := .jump 0x40103e#64 }),
    (0x40103e#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .const 8 0xf#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 9 16], term := .jump 0x401042#64 }),
    (0x401042#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 10 8, .get 11 9, .const 12 0x4#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w32 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401046#64 }),
    (0x401046#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .set 9 0], term := .jump 0x401049#64 }),
    (0x401049#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .const 8 0x4#64, .bin 9 .lshr 0 8, .const 11 0x3#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 9 39, .setf 4 40, .set 9 9], term := .jump 0x40104d#64 }),
    (0x40104d#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .const 8 0xf#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401050#64 }),
    (0x401050#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 10 8, .get 11 0, .const 12 0x4#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w32 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 9 16], term := .jump 0x401054#64 }),
    (0x401054#64, { ops := [.get 2 4, .get 3 2, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x1#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 0 0], term := .jump 0x401059#64 }),
    (0x401059#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 9 9, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x40105c#64 }),
    (0x40105c#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .set 9 0], term := .jump 0x40105f#64 }),
    (0x40105f#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .const 8 0x4#64, .bin 9 .lshr 0 8, .const 11 0x3#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 9 39, .setf 4 40, .set 9 9], term := .jump 0x401063#64 }),
    (0x401063#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .const 8 0xf#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401066#64 }),
    (0x401066#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 10 8, .get 11 0, .const 12 0x4#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w32 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 9 16], term := .jump 0x40106a#64 }),
    (0x40106a#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .set 0 0], term := .jump 0x40106d#64 }),
    (0x40106d#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .const 8 0x4#64, .bin 9 .lshr 0 8, .const 11 0x3#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 9 39, .setf 4 40, .set 0 9], term := .jump 0x401070#64 }),
    (0x401070#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .const 8 0xf#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 9 16], term := .jump 0x401074#64 }),
    (0x401074#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 10 8, .get 11 9, .const 12 0x4#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w32 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401078#64 }),
    (0x401078#64, { ops := [.const 0 0x2#64, .get 8 2, .bin 16 .add 0 8, .bin 18 .ult 16 0, .setf 0 18, .bin 19 .xor 0 16, .bin 20 .xor 8 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x40107c#64 }),
    (0x40107c#64, { ops := [.get 0 5, .get 8 2, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40107f#64 }),
    (0x40107f#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401030#64 0x401081#64 }),
    (0x401081#64, { ops := [.get 1 3, .un 0 (.zext 8) 1, .const 8 0x1#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x401084#64 }),
    (0x401084#64, { ops := [.getf 0 3], term := .branch 0 0x4010a9#64 0x401086#64 }),
    (0x401086#64, { ops := [.get 2 4, .get 3 2, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 2 0], term := .jump 0x40108a#64 }),
    (0x40108a#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x40108c#64 }),
    (0x40108c#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .set 3 0], term := .jump 0x40108e#64 }),
    (0x40108e#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .const 8 0x4#64, .bin 9 .lshr 0 8, .const 11 0x3#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 9 39, .setf 4 40, .set 3 9], term := .jump 0x401091#64 }),
    (0x401091#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .const 8 0xf#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x401094#64 }),
    (0x401094#64, { ops := [.const 0 0x4020b0#64, .set 4 0], term := .jump 0x40109b#64 }),
    (0x40109b#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 10 4, .get 11 2, .const 12 0x4#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w32 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x40109e#64 }),
    (0x40109e#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .set 0 0], term := .jump 0x4010a0#64 }),
    (0x4010a0#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .const 8 0x4#64, .bin 9 .lshr 0 8, .const 11 0x3#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 9 39, .setf 4 40, .set 0 9], term := .jump 0x4010a3#64 }),
    (0x4010a3#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .const 8 0xf#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 3 16], term := .jump 0x4010a6#64 }),
    (0x4010a6#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 10 4, .get 11 3, .const 12 0x4#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w32 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x4010a9#64 }),
    (0x4010a9#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .un 8 .not 0, .un 9 (.zext 32) 8, .set 0 9], term := .jump 0x4010ab#64 }),
    (0x4010ab#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `crc32` is the lowering of `crc32_code`. -/
theorem crc32_lowered :
    crc32.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) crc32_code := by
  decide

/-- The blocks of `crc32` are blocks of the lowering of the executable. -/
theorem crc32_holds :
    ∀ p ∈ crc32.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) crc32_lowered

end Examples.Crc32.O2.X86
