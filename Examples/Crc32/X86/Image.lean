/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.X86.Logic

@[expose] public section

namespace Examples.Crc32.X86


/-- The lines of `crc32`, from `0x401000`. -/
def crc32_code : List Lowering.X86.Line := [
  ⟨0x401000, 2, "L401000", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdi) (Width.W32))))))⟩,
  ⟨0x401002, 3, "L401002", some (Instr.regular (Width.W64) (Width.W64) (Operation.test (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))))))⟩,
  ⟨0x401005, 2, "L401005", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.z) "L40104f"))⟩,
  ⟨0x401007, 2, "L401007", some (Instr.regular (Width.W64) (Width.W32) (Operation.not (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32)))))⟩,
  ⟨0x401009, 2, "L401009", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W32))))))⟩,
  ⟨0x40100b, 7, "L40100b", some (Instr.regular (Width.W64) (Width.W64) (Operation.lea (Reg.low (Reg64.rdi) (Width.W64)) { base := some (RegOrRip.rip), idx := none, disp := ConstExpr.int64 4158 }))⟩,
  ⟨0x401012, 14, "L401012", some (Instr.regular (Width.W64) (Width.W64) (Operation.nop 14))⟩,
  ⟨0x401020, 5, "L401020", some (Instr.regular (Width.W64) (Width.W32) (Operation.movzx (w' := Width.W8) (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rsi)), idx := some { reg := Reg64.rcx, scale := Width.W8 }, disp := ConstExpr.int64 0 })))⟩,
  ⟨0x401025, 3, "L401025", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))))))⟩,
  ⟨0x401028, 3, "L401028", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))))))⟩,
  ⟨0x40102b, 4, "L40102b", some (Instr.regular (Width.W64) (Width.W32) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 4))))⟩,
  ⟨0x40102f, 4, "L40102f", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.r8) (Width.W32))) (Operand.imm (ConstExpr.int64 15))))⟩,
  ⟨0x401033, 4, "L401033", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.r8, scale := Width.W32 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401037, 3, "L401037", some (Instr.regular (Width.W64) (Width.W32) (Operation.mov (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))))))⟩,
  ⟨0x40103a, 3, "L40103a", some (Instr.regular (Width.W64) (Width.W32) (Operation.shr (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (ShiftCountExpr.imm8 (ConstExpr.int64 4))))⟩,
  ⟨0x40103d, 4, "L40103d", some (Instr.regular (Width.W64) (Width.W32) (Operation.and (RegOrMem.reg (Reg.low (Reg64.r9) (Width.W32))) (Operand.imm (ConstExpr.int64 15))))⟩,
  ⟨0x401041, 4, "L401041", some (Instr.regular (Width.W64) (Width.W32) (Operation.xor (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32))) (Operand.regOrMem (RegOrMem.mem { base := some (RegOrRip.reg (Reg64.rdi)), idx := some { reg := Reg64.r9, scale := Width.W32 }, disp := ConstExpr.int64 0 }))))⟩,
  ⟨0x401045, 3, "L401045", some (Instr.regular (Width.W64) (Width.W64) (Operation.inc (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64)))))⟩,
  ⟨0x401048, 3, "L401048", some (Instr.regular (Width.W64) (Width.W64) (Operation.cmp (RegOrMem.reg (Reg.low (Reg64.rdx) (Width.W64))) (Operand.regOrMem (RegOrMem.reg (Reg.low (Reg64.rcx) (Width.W64))))))⟩,
  ⟨0x40104b, 2, "L40104b", some (Instr.regular (Width.W64) (Width.W64) (Operation.jcc (CondCode.nz) "L401020"))⟩,
  ⟨0x40104d, 2, "L40104d", some (Instr.regular (Width.W64) (Width.W32) (Operation.not (RegOrMem.reg (Reg.low (Reg64.rax) (Width.W32)))))⟩,
  ⟨0x40104f, 1, "L40104f", some (Instr.regular (Width.W64) (Width.W64) (Operation.ret))⟩]

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
    (0x401005#64, { ops := [.getf 0 3], term := .branch 0 0x40104f#64 0x401007#64 }),
    (0x401007#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .un 8 .not 0, .un 9 (.zext 32) 8, .set 0 9], term := .jump 0x401009#64 }),
    (0x401009#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 9 2, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x40100b#64 }),
    (0x40100b#64, { ops := [.const 0 0x402050#64, .set 5 0], term := .jump 0x401012#64 }),
    (0x401012#64, { ops := [], term := .jump 0x401020#64 }),
    (0x401020#64, { ops := [.get 2 4, .get 3 2, .const 4 0x1#64, .bin 5 .mul 3 4, .bin 6 .add 2 5, .const 7 0x0#64, .bin 1 .add 6 7, .load 0 .w8 1, .set 8 0], term := .jump 0x401025#64 }),
    (0x401025#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 9 0, .un 8 (.zext 32) 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 8 16], term := .jump 0x401028#64 }),
    (0x401028#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .set 9 0], term := .jump 0x40102b#64 }),
    (0x40102b#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .const 8 0x4#64, .bin 9 .lshr 0 8, .const 11 0x3#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 9 39, .setf 4 40, .set 9 9], term := .jump 0x40102f#64 }),
    (0x40102f#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .const 8 0xf#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 8 16], term := .jump 0x401033#64 }),
    (0x401033#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 10 5, .get 11 8, .const 12 0x4#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w32 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 9 16], term := .jump 0x401037#64 }),
    (0x401037#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .set 0 0], term := .jump 0x40103a#64 }),
    (0x40103a#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .const 8 0x4#64, .bin 9 .lshr 0 8, .const 11 0x3#64, .bin 12 .lshr 0 11, .const 13 0x1#64, .bin 14 .and 12 13, .setf 0 14, .havoc 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 9, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 9 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 9 39, .setf 4 40, .set 0 9], term := .jump 0x40103d#64 }),
    (0x40103d#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .const 8 0xf#64, .bin 16 .and 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 9 16], term := .jump 0x401041#64 }),
    (0x401041#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .get 10 5, .get 11 9, .const 12 0x4#64, .bin 13 .mul 11 12, .bin 14 .add 10 13, .const 15 0x0#64, .bin 9 .add 14 15, .load 8 .w32 9, .bin 16 .xor 0 8, .const 17 0x0#64, .setf 0 17, .setf 5 17, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x80000000#64, .bin 40 .and 16 39, .setf 4 40, .set 0 16], term := .jump 0x401045#64 }),
    (0x401045#64, { ops := [.get 0 2, .const 8 0x1#64, .bin 16 .add 0 8, .const 19 0x8000000000000000#64, .bin 20 .eq 16 19, .setf 5 20, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40, .set 2 16], term := .jump 0x401048#64 }),
    (0x401048#64, { ops := [.get 0 3, .get 8 2, .bin 16 .sub 0 8, .bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 16, .bin 21 .and 19 20, .const 22 0x8000000000000000#64, .bin 23 .and 21 22, .setf 5 23, .havoc 24, .setf 2 24, .un 32 (.zext 8) 16, .un 33 .popcnt 32, .const 34 0x1#64, .bin 35 .and 33 34, .const 36 0x0#64, .bin 37 .eq 35 36, .setf 1 37, .bin 38 .eq 16 36, .setf 3 38, .const 39 0x8000000000000000#64, .bin 40 .and 16 39, .setf 4 40], term := .jump 0x40104b#64 }),
    (0x40104b#64, { ops := [.getf 1 3, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x401020#64 0x40104d#64 }),
    (0x40104d#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .un 8 .not 0, .un 9 (.zext 32) 8, .set 0 9], term := .jump 0x40104f#64 }),
    (0x40104f#64, { ops := [.get 0 6, .load 1 .w64 0, .const 2 0x8#64, .bin 3 .add 0 2, .set 6 3], term := .jumpInd 1 })] }

/-- `crc32` is the lowering of `crc32_code`. -/
theorem crc32_lowered :
    crc32.blocks = Lowering.X86.lowerLines (Lowering.X86.labelsOf image) crc32_code := by
  decide

/-- The blocks of `crc32` are blocks of the lowering of the executable. -/
theorem crc32_holds :
    ∀ p ∈ crc32.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=
  Lowering.X86.holds_exeOf image_wf
    (fun _ h => List.mem_flatten.2 ⟨_, List.Mem.head _, h⟩) crc32_lowered

end Examples.Crc32.X86
