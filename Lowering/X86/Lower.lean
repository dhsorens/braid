/-
  Lowering.X86.Lower

  The lowering of x86-64 into `braid`: one block for each instruction, at its address. The
  machine model is Kraken's `X64` semantics, whose programs are assembly: instructions with
  sizes, laid out from a start address.

  `rax` to `r15` are `braid` registers 0 to 15, in the model's order. The status flags `cf`,
  `pf`, `af`, `zf`, `sf`, `of` are flags 0 to 5, and the direction flag is flag 6. A value
  narrower than 64 bits is held zero-extended in its SSA value. A flag the model leaves
  undefined is a `havoc`; so is the auxiliary carry flag, which no condition code reads.

  Instructions outside the lowering (a 32-bit address size, string instructions, vector
  instructions, and the rarer arithmetic) become a `trap`. A shift by `cl` changes the flags
  only if its count is not zero, which is known only when it runs: each flag is a `select`
  between its old value and its new one.

  ## Main definitions

  * `lowerOp`: the operations and terminator of one integer instruction
  * `lower`: the block of one instruction
  * `lowerProgram`: the program of an executable
  * `arch`: the names of the registers and flags
-/

module

public import Braid
public import Kraken.X64.Semantics

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp)

/-- The `braid` register of a 64-bit register. -/
def regNum : Reg64 → Braid.Reg
  | .rax => 0 | .rbx => 1 | .rcx => 2 | .rdx => 3
  | .rsi => 4 | .rdi => 5 | .rsp => 6 | .rbp => 7
  | .r8 => 8 | .r9 => 9 | .r10 => 10 | .r11 => 11
  | .r12 => 12 | .r13 => 13 | .r14 => 14 | .r15 => 15

/-- How x86-64 registers and flags are named in the textual form. -/
def arch : Braid.Arch where
  name := "x86_64"
  regName
    | 0 => "rax" | 1 => "rbx" | 2 => "rcx" | 3 => "rdx"
    | 4 => "rsi" | 5 => "rdi" | 6 => "rsp" | 7 => "rbp"
    | r => s!"r{r}"
  flagName
    | 0 => "cf" | 1 => "pf" | 2 => "af" | 3 => "zf" | 4 => "sf" | 5 => "of" | 6 => "df"
    | f => s!"f{f}"

/-- The `braid` width of an operand width. -/
def bw : Width → Braid.Width
  | .W8 => .w8 | .W16 => .w16 | .W32 => .w32 | .W64 => .w64

/-- The word whose only set bit is the sign bit of an operand of width `w`. -/
def signBit (w : Width) : Word := 1#64 <<< (w.bits - 1)

/-- The low bits an operand of width `w` occupies in its register. -/
def mask (w : Width) : Word := (BitVec.allOnes w.bits).zeroExtend 64

/-- Cut the value `a` to the width `w`, into `d`: the operations, and the value that holds the
result. At 64 bits there is nothing to do. -/
def cut (d : Var) (w : Width) (a : Var) : List Op × Var :=
  match w with
  | .W64 => ([], a)
  | _ => ([.un d (.zext w.bits) a], d)

/-! ## Registers -/

/-- Read a register into `n`, zero-extended. Uses values from `n` to `n + 3`. -/
def readReg (n : Var) {w : Width} (r : Reg w) : List Op :=
  if r.offset = 0 then
    match w with
    | .W64 => [.get n (regNum r.base)]
    | _ => [.get (n + 1) (regNum r.base), .un n (.zext w.bits) (n + 1)]
  else
    [.get (n + 1) (regNum r.base), .const (n + 2) 8, .bin (n + 3) .lshr (n + 1) (n + 2),
      .un n (.zext 8) (n + 3)]

/-- Write a register from `v`, which holds the value zero-extended. A 32-bit write clears
the upper half; a narrower one keeps the other bits. Uses values from `n` to `n + 5`. -/
def writeReg (n : Var) {w : Width} (r : Reg w) (v : Var) : List Op :=
  if r.offset = 0 then
    match w with
    | .W64 | .W32 => [.set (regNum r.base) v]
    | _ =>
      [.get n (regNum r.base), .const (n + 1) (~~~mask w), .bin (n + 2) .and n (n + 1),
        .bin (n + 3) .or (n + 2) v, .set (regNum r.base) (n + 3)]
  else
    [.get n (regNum r.base), .const (n + 1) (~~~0xff00#64), .bin (n + 2) .and n (n + 1),
      .const (n + 3) 8, .bin (n + 4) .shl v (n + 3), .bin (n + 5) .or (n + 2) (n + 4),
      .set (regNum r.base) (n + 5)]

section
variable [Labels] (p : Std.Rco Int64)

/-! ## Addresses and operands -/

/-- The base of an address, into `n`. -/
def baseOps (n : Var) : Option RegOrRip → List Op
  | some (.reg r) => [.get n (regNum r)]
  | some .rip => [.const n p.upper.toBitVec]
  | none => [.const n 0]

/-- The address of a memory operand, into `n`. Uses values from `n` to `n + 6`. -/
def addrOps (n : Var) (a : AddrExpr) : List Op :=
  match a.base, a.idx with
  | some (.reg r), none =>
    if a.disp = .int64 0 then [.get n (regNum r)]
    else [.get (n + 1) (regNum r), .const (n + 2) (a.disp.interp p).toBitVec,
      .bin n .add (n + 1) (n + 2)]
  | some .rip, none => [.const n (p.upper.toBitVec + (a.disp.interp p).toBitVec)]
  | none, none => [.const n (a.disp.interp p).toBitVec]
  | b, some i =>
    baseOps p (n + 1) b ++
      [.get (n + 2) (regNum i.reg), .const (n + 3) (BitVec.ofNat 64 i.scale.bytes),
        .bin (n + 4) .mul (n + 2) (n + 3), .bin (n + 5) .add (n + 1) (n + 4),
        .const (n + 6) (a.disp.interp p).toBitVec, .bin n .add (n + 5) (n + 6)]

/-- Read a register or memory operand into `n`, zero-extended. Uses values from `n` to
`n + 7`. -/
def readRM (n : Var) {w : Width} : RegOrMem w → List Op
  | .reg r => readReg n r
  | .mem a => addrOps p (n + 1) a ++ [.load n (bw w) (n + 1)]

/-- Read an operand into `n`, zero-extended. Uses values from `n` to `n + 7`. -/
def readOp (n : Var) {w : Width} : Operand w → List Op
  | .regOrMem o => readRM p n o
  | .imm c => [.const n (((c.interp p).toBitVec.truncate w.bits).zeroExtend 64)]

/-- Write a register or memory operand from `v`, which holds the value zero-extended. Uses
values from `n` to `n + 6`. -/
def writeRM (n : Var) {w : Width} (d : RegOrMem w) (v : Var) : List Op :=
  match d with
  | .reg r => writeReg n r v
  | .mem a => addrOps p n a ++ [.store (bw w) n v]

/-! ## Flags -/

/-- Set the parity, zero and sign flags from the result in `r`. Uses values from `n` to
`n + 8`. -/
def pzsOps (n : Var) (w : Width) (r : Var) : List Op :=
  [.un n (.zext 8) r, .un (n + 1) .popcnt n, .const (n + 2) 1, .bin (n + 3) .and (n + 1) (n + 2),
    .const (n + 4) 0, .bin (n + 5) .eq (n + 3) (n + 4), .setf 1 (n + 5),
    .bin (n + 6) .eq r (n + 4), .setf 3 (n + 6),
    .const (n + 7) (signBit w), .bin (n + 8) .and r (n + 7), .setf 4 (n + 8)]

/-- The parity, zero and sign flags of the result in `r`, as the values `n + 5`, `n + 6` and
`n + 8`, without setting them. Uses values from `n` to `n + 8`. -/
def pzsVals (n : Var) (w : Width) (r : Var) : List Op :=
  [.un n (.zext 8) r, .un (n + 1) .popcnt n, .const (n + 2) 1, .bin (n + 3) .and (n + 1) (n + 2),
    .const (n + 4) 0, .bin (n + 5) .eq (n + 3) (n + 4), .bin (n + 6) .eq r (n + 4),
    .const (n + 7) (signBit w), .bin (n + 8) .and r (n + 7)]

/-- Set each status flag from its new value, or keep it if `z` is not zero: an instruction
whose flags depend on a value known only when it runs. Uses values 60 to 71. -/
def selFlags (z cf pf af zf sf of : Var) : List Op :=
  [.getf 60 0, .select 61 z 60 cf, .setf 0 61, .getf 62 1, .select 63 z 62 pf, .setf 1 63,
    .getf 64 2, .select 65 z 64 af, .setf 2 65, .getf 66 3, .select 67 z 66 zf, .setf 3 67,
    .getf 68 4, .select 69 z 68 sf, .setf 4 69, .getf 70 5, .select 71 z 70 of, .setf 5 71]

/-- The count of a shift by `cl`, masked to five bits, or six at 64 bits, in value 8, and
whether it is zero in value 29. -/
def clCount (w : Width) : List Op :=
  [.get 56 (regNum .rcx), .const 57 (match w with | .W64 => 0x3f#64 | _ => 0x1f#64),
    .bin 8 .and 56 57, .const 28 0, .bin 29 .eq 8 28]

/-- A condition code, as `1` or `0` in `n`. Uses values from `n` to `n + 6`. -/
def ccOps (n : Var) : CondCode → List Op
  | .o => [.getf n 5]
  | .no => [.getf (n + 1) 5, .const (n + 2) 0, .bin n .eq (n + 1) (n + 2)]
  | .c => [.getf n 0]
  | .nc => [.getf (n + 1) 0, .const (n + 2) 0, .bin n .eq (n + 1) (n + 2)]
  | .z => [.getf n 3]
  | .nz => [.getf (n + 1) 3, .const (n + 2) 0, .bin n .eq (n + 1) (n + 2)]
  | .be => [.getf (n + 1) 0, .getf (n + 2) 3, .bin n .or (n + 1) (n + 2)]
  | .a =>
    [.getf (n + 1) 0, .getf (n + 2) 3, .bin (n + 3) .or (n + 1) (n + 2), .const (n + 4) 0,
      .bin n .eq (n + 3) (n + 4)]
  | .s => [.getf n 4]
  | .ns => [.getf (n + 1) 4, .const (n + 2) 0, .bin n .eq (n + 1) (n + 2)]
  | .p => [.getf n 1]
  | .np => [.getf (n + 1) 1, .const (n + 2) 0, .bin n .eq (n + 1) (n + 2)]
  | .l => [.getf (n + 1) 4, .getf (n + 2) 5, .bin n .xor (n + 1) (n + 2)]
  | .ge => [.getf (n + 1) 4, .getf (n + 2) 5, .bin n .eq (n + 1) (n + 2)]
  | .le =>
    [.getf (n + 1) 4, .getf (n + 2) 5, .bin (n + 3) .xor (n + 1) (n + 2), .getf (n + 4) 3,
      .bin n .or (n + 3) (n + 4)]
  | .g =>
    [.getf (n + 1) 4, .getf (n + 2) 5, .bin (n + 3) .xor (n + 1) (n + 2), .getf (n + 4) 3,
      .bin (n + 5) .or (n + 3) (n + 4), .const (n + 6) 0, .bin n .eq (n + 5) (n + 6)]

/-- The auxiliary carry flag, left undefined. -/
def afOps (n : Var) : List Op := [.havoc n, .setf 2 n]

/-- The carry and overflow flags, cleared. -/
def clearCO (n : Var) : List Op := [.const n 0, .setf 0 n, .setf 5 n]

/-! ## Instructions -/

/-- The count of a shift by an immediate, masked to five bits, or six at 64 bits. -/
def immCount (w : Width) (c : ConstExpr) : BitVec 8 :=
  (c.interp p).toBitVec.take 8 &&& (match w with | .W64 => 0x3f#8 | _ => 0x1f#8)

/-- Push the return address and leave the target of a call alone. -/
def pushRet : List Op :=
  [.get 8 (regNum .rsp), .const 9 8, .bin 10 .sub 8 9, .set (regNum .rsp) 10,
    .const 11 p.upper.toBitVec, .store .w64 10 11]

/-- The operations and terminator of the instruction `i`, or `none` if it is outside the
lowering. -/
def lowerOp {w : Width} (i : Operation w) : Option (List Op × Term) :=
  let fin (ops : List Op) : Option (List Op × Term) := some (ops, .jump p.upper.toBitVec)
  match i with
  | .mov dst src => fin (readOp p 0 src ++ writeRM p 8 dst 0)
  | .movzx (w' := w') dst src =>
    if w'.bits ≤ w.bits then fin (readRM p 0 src ++ writeRM p 8 dst 0) else none
  | .movsx (w' := w') dst src =>
    let (c, v) := cut 9 w 8
    fin (readRM p 0 src ++ [.un 8 (.sext w'.bits) 0] ++ c ++ writeRM p 16 dst v)
  | .push src =>
    fin (readOp p 0 src ++
      [.get 8 (regNum .rsp), .const 9 (BitVec.ofNat 64 w.bytes), .bin 10 .sub 8 9,
        .set (regNum .rsp) 10, .store (bw w) 10 0])
  | .pop dst =>
    fin ([.get 0 (regNum .rsp), .load 1 (bw w) 0, .const 2 (BitVec.ofNat 64 w.bytes),
        .bin 3 .add 0 2, .set (regNum .rsp) 3] ++ writeRM p 8 dst 1)
  | .setcc cc dst => fin (ccOps 0 cc ++ writeRM p 8 dst 0)
  | .cmovcc cc dst src =>
    fin (readRM p 0 src ++ readReg 8 dst ++ ccOps 16 cc ++ [.select 24 16 0 8] ++
      writeReg 32 dst 24)
  | .lea dst src =>
    let (c, v) := cut 8 w 0
    fin (addrOps p 0 src ++ c ++ writeReg 16 dst v)
  | .add dst src =>
    let (c, v) := cut 17 w 16
    fin (readOp p 0 src ++ readRM p 8 dst ++ [.bin 16 .add 0 8] ++ c ++
      [.bin 18 .ult v 0, .setf 0 18, .bin 19 .xor 0 v, .bin 20 .xor 8 v, .bin 21 .and 19 20,
        .const 22 (signBit w), .bin 23 .and 21 22, .setf 5 23] ++
      afOps 24 ++ pzsOps 32 w v ++ writeRM p 48 dst v)
  | .sub dst src =>
    let (c, v) := cut 17 w 16
    fin (readOp p 0 src ++ readRM p 8 dst ++ [.bin 16 .sub 8 0] ++ c ++
      [.bin 18 .ult 8 0, .setf 0 18, .bin 19 .xor 8 0, .bin 20 .xor 8 v, .bin 21 .and 19 20,
        .const 22 (signBit w), .bin 23 .and 21 22, .setf 5 23] ++
      afOps 24 ++ pzsOps 32 w v ++ writeRM p 48 dst v)
  | .adc dst src =>
    let (c1, t) := cut 17 w 16
    let (c2, v) := cut 19 w 18
    fin (readOp p 0 src ++ readRM p 8 dst ++ [.getf 9 0, .bin 16 .add 0 8] ++ c1 ++
      [.bin 18 .add t 9] ++ c2 ++
      [.bin 20 .ult t 0, .bin 21 .ult v t, .bin 22 .or 20 21, .setf 0 22, .havoc 23,
        .setf 5 23] ++
      afOps 24 ++ pzsOps 32 w v ++ writeRM p 48 dst v)
  | .sbb dst src =>
    let (c1, t) := cut 17 w 16
    let (c2, v) := cut 19 w 18
    fin (readOp p 0 src ++ readRM p 8 dst ++ [.getf 9 0, .bin 16 .sub 8 0] ++ c1 ++
      [.bin 18 .sub t 9] ++ c2 ++
      [.bin 20 .ult 8 0, .bin 21 .ult t 9, .bin 22 .or 20 21, .setf 0 22, .havoc 23,
        .setf 5 23] ++
      afOps 24 ++ pzsOps 32 w v ++ writeRM p 48 dst v)
  | .cmp a b =>
    let (c, v) := cut 17 w 16
    fin (readRM p 0 a ++ readOp p 8 b ++ [.bin 16 .sub 0 8] ++ c ++
      [.bin 18 .ult 0 8, .setf 0 18, .bin 19 .xor 0 8, .bin 20 .xor 0 v, .bin 21 .and 19 20,
        .const 22 (signBit w), .bin 23 .and 21 22, .setf 5 23] ++
      afOps 24 ++ pzsOps 32 w v)
  | .inc dst =>
    let (c, v) := cut 17 w 16
    fin (readRM p 0 dst ++ [.const 8 1, .bin 16 .add 0 8] ++ c ++
      [.const 19 (signBit w), .bin 20 .eq v 19, .setf 5 20] ++
      afOps 24 ++ pzsOps 32 w v ++ writeRM p 48 dst v)
  | .dec dst =>
    let (c, v) := cut 17 w 16
    fin (readRM p 0 dst ++ [.const 8 1, .bin 16 .sub 0 8] ++ c ++
      [.const 19 (signBit w), .bin 20 .eq 0 19, .setf 5 20] ++
      afOps 24 ++ pzsOps 32 w v ++ writeRM p 48 dst v)
  | .neg dst =>
    let (c, v) := cut 17 w 16
    fin (readRM p 0 dst ++ [.const 8 0, .bin 16 .sub 8 0] ++ c ++
      [.bin 18 .ne 0 8, .setf 0 18, .const 19 (signBit w), .bin 20 .eq 0 19, .setf 5 20] ++
      afOps 24 ++ pzsOps 32 w v ++ writeRM p 48 dst v)
  | .not dst =>
    let (c, v) := cut 9 w 8
    fin (readRM p 0 dst ++ [.un 8 .not 0] ++ c ++ writeRM p 16 dst v)
  | .test a b =>
    fin (readRM p 0 a ++ readOp p 8 b ++ [.bin 16 .and 0 8] ++ clearCO 17 ++ afOps 24 ++
      pzsOps 32 w 16)
  | .and dst src =>
    fin (readRM p 0 dst ++ readOp p 8 src ++ [.bin 16 .and 0 8] ++ clearCO 17 ++ afOps 24 ++
      pzsOps 32 w 16 ++ writeRM p 48 dst 16)
  | .or dst src =>
    fin (readRM p 0 dst ++ readOp p 8 src ++ [.bin 16 .or 0 8] ++ clearCO 17 ++ afOps 24 ++
      pzsOps 32 w 16 ++ writeRM p 48 dst 16)
  | .xor dst src =>
    fin (readRM p 0 dst ++ readOp p 8 src ++ [.bin 16 .xor 0 8] ++ clearCO 17 ++ afOps 24 ++
      pzsOps 32 w 16 ++ writeRM p 48 dst 16)
  | .shl dst (.imm8 c) =>
    let k := immCount p w c
    if k = 0 then fin (readRM p 0 dst ++ writeRM p 8 dst 0) else
    let (ct, v) := cut 10 w 9
    fin (readRM p 0 dst ++ [.const 8 (k.zeroExtend 64), .bin 9 .shl 0 8] ++ ct ++
      (if k < BitVec.ofNat 8 w.bits then
        [.const 11 (BitVec.ofNat 64 w.bits - k.zeroExtend 64), .bin 12 .lshr 0 11, .const 13 1,
          .bin 14 .and 12 13, .setf 0 14]
      else [.havoc 14, .setf 0 14]) ++
      (if k = 1 then [.bin 15 .xor v 0, .const 16 (signBit w), .bin 17 .and 15 16, .setf 5 17]
      else [.havoc 17, .setf 5 17]) ++
      afOps 24 ++ pzsOps 32 w v ++ writeRM p 48 dst v)
  | .shr dst (.imm8 c) =>
    let k := immCount p w c
    if k = 0 then fin (readRM p 0 dst ++ writeRM p 8 dst 0) else
    fin (readRM p 0 dst ++ [.const 8 (k.zeroExtend 64), .bin 9 .lshr 0 8] ++
      (if k < BitVec.ofNat 8 w.bits then
        [.const 11 ((k - 1).zeroExtend 64), .bin 12 .lshr 0 11, .const 13 1,
          .bin 14 .and 12 13, .setf 0 14]
      else [.havoc 14, .setf 0 14]) ++
      (if k = 1 then [.const 16 (signBit w), .bin 17 .and 0 16, .setf 5 17]
      else [.havoc 17, .setf 5 17]) ++
      afOps 24 ++ pzsOps 32 w 9 ++ writeRM p 48 dst 9)
  | .sar dst (.imm8 c) =>
    let k := immCount p w c
    if k = 0 then fin (readRM p 0 dst ++ writeRM p 8 dst 0) else
    let (ct, v) := cut 10 w 9
    fin (readRM p 0 dst ++
      [.un 7 (.sext w.bits) 0, .const 8 (k.zeroExtend 64), .bin 9 .ashr 7 8] ++ ct ++
      [.const 11 ((k - 1).zeroExtend 64), .bin 12 .ashr 7 11, .const 13 1, .bin 14 .and 12 13,
        .setf 0 14] ++
      (if k = 1 then [.const 17 0, .setf 5 17] else [.havoc 17, .setf 5 17]) ++
      afOps 24 ++ pzsOps 32 w v ++ writeRM p 48 dst v)
  | .shl dst .cl =>
    let (ct, v) := cut 10 w 9
    fin (readRM p 0 dst ++ clCount w ++ [.bin 9 .shl 0 8] ++ ct ++
      [.const 11 (BitVec.ofNat 64 w.bits), .bin 12 .sub 11 8, .bin 13 .lshr 0 12, .const 14 1,
        .bin 15 .and 13 14, .havoc 16, .bin 18 .ult 8 11, .select 19 18 15 16,
        .bin 20 .xor v 0, .const 21 (signBit w), .bin 22 .and 20 21, .havoc 23,
        .bin 26 .eq 8 14, .select 27 26 22 23, .havoc 24] ++
      pzsVals 32 w v ++ selFlags 29 19 37 24 38 40 27 ++ writeRM p 48 dst v)
  | .shr dst .cl =>
    fin (readRM p 0 dst ++ clCount w ++ [.bin 9 .lshr 0 8] ++
      [.const 11 (BitVec.ofNat 64 w.bits), .const 14 1, .bin 12 .sub 8 14, .bin 13 .lshr 0 12,
        .bin 15 .and 13 14, .havoc 16, .bin 18 .ult 8 11, .select 19 18 15 16,
        .const 21 (signBit w), .bin 22 .and 0 21, .havoc 23,
        .bin 26 .eq 8 14, .select 27 26 22 23, .havoc 24] ++
      pzsVals 32 w 9 ++ selFlags 29 19 37 24 38 40 27 ++ writeRM p 48 dst 9)
  | .sar dst .cl =>
    let (ct, v) := cut 10 w 9
    fin (readRM p 0 dst ++ clCount w ++ [.un 7 (.sext w.bits) 0, .bin 9 .ashr 7 8] ++ ct ++
      [.const 14 1, .bin 12 .sub 8 14, .bin 13 .ashr 7 12, .bin 19 .and 13 14,
        .const 22 0, .havoc 23, .bin 26 .eq 8 14, .select 27 26 22 23, .havoc 24] ++
      pzsVals 32 w v ++ selFlags 29 19 37 24 38 40 27 ++ writeRM p 48 dst v)
  | .shld dst src (.imm8 c) =>
    let k := immCount p w c
    match w with
    | .W8 | .W16 => none
    | _ =>
      if k = 0 then fin (readRM p 0 dst ++ writeRM p 8 dst 0) else
      let (ct, v) := cut 17 w 16
      fin (readRM p 0 dst ++ readReg 8 src ++
        [.const 12 (k.zeroExtend 64), .bin 13 .shl 0 12,
          .const 14 (BitVec.ofNat 64 w.bits - k.zeroExtend 64), .bin 15 .lshr 8 14,
          .bin 16 .or 13 15] ++ ct ++
        [.bin 18 .lshr 0 14, .const 19 1, .bin 20 .and 18 19, .setf 0 20] ++
        (if k = 1 then [.bin 21 .xor v 0, .const 22 (signBit w), .bin 23 .and 21 22, .setf 5 23]
        else [.havoc 23, .setf 5 23]) ++
        afOps 24 ++ pzsOps 32 w v ++ writeRM p 48 dst v)
  | .shrd dst src (.imm8 c) =>
    let k := immCount p w c
    match w with
    | .W8 | .W16 => none
    | _ =>
      if k = 0 then fin (readRM p 0 dst ++ writeRM p 8 dst 0) else
      let (ct, v) := cut 17 w 16
      fin (readRM p 0 dst ++ readReg 8 src ++
        [.const 12 (k.zeroExtend 64), .bin 13 .lshr 0 12,
          .const 14 (BitVec.ofNat 64 w.bits - k.zeroExtend 64), .bin 15 .shl 8 14,
          .bin 16 .or 13 15] ++ ct ++
        [.const 18 ((k - 1).zeroExtend 64), .bin 19 .lshr 0 18, .const 21 1, .bin 20 .and 19 21,
          .setf 0 20] ++
        (if k = 1 then [.bin 21 .xor v 0, .const 22 (signBit w), .bin 23 .and 21 22, .setf 5 23]
        else [.havoc 23, .setf 5 23]) ++
        afOps 24 ++ pzsOps 32 w v ++ writeRM p 48 dst v)
  | .imul dst src1 src2 =>
    let (c, v) := cut 17 w 16
    fin (readRM p 0 src1 ++ readOp p 8 src2 ++ [.bin 16 .mul 0 8] ++ c ++
      writeRM p 24 (match dst with | some d => d | none => src1) v ++
      [.havoc 40, .setf 0 40, .setf 5 40, .havoc 41, .setf 4 41, .havoc 42, .setf 3 42,
        .havoc 43, .setf 2 43, .havoc 44, .setf 1 44])
  | .mul src =>
    let flags : List Op :=
      [.const 18 0, .bin 19 .ne 17 18, .setf 0 19, .setf 5 19, .havoc 40, .setf 4 40,
        .havoc 41, .setf 3 41, .havoc 42, .setf 2 42, .havoc 43, .setf 1 43]
    match w with
    | .W64 =>
      fin (readReg 0 (.low .rax w) ++ readRM p 8 src ++
        [.bin 16 .mul 0 8, .bin 17 .mulhu 0 8] ++ flags ++
        writeReg 24 (.low .rax w) 16 ++ writeReg 32 (.low .rdx w) 17)
    | .W32 =>
      fin (readReg 0 (.low .rax w) ++ readRM p 8 src ++
        [.bin 16 .mul 0 8, .un 20 (.zext 32) 16, .const 21 32, .bin 17 .lshr 16 21] ++ flags ++
        writeReg 24 (.low .rax w) 20 ++ writeReg 32 (.low .rdx w) 17)
    | _ => none
  | .imul1 src =>
    let flags : List Op :=
      [.havoc 39, .setf 0 39, .setf 5 39, .havoc 40, .setf 4 40, .havoc 41, .setf 3 41,
        .havoc 42, .setf 2 42, .havoc 43, .setf 1 43]
    match w with
    | .W64 =>
      fin (readReg 0 (.low .rax w) ++ readRM p 8 src ++
        [.bin 16 .mul 0 8, .bin 17 .mulhs 0 8] ++ flags ++
        writeReg 24 (.low .rax w) 16 ++ writeReg 32 (.low .rdx w) 17)
    | .W32 =>
      fin (readReg 0 (.low .rax w) ++ readRM p 8 src ++
        [.un 18 (.sext 32) 0, .un 19 (.sext 32) 8, .bin 16 .mul 18 19, .un 20 (.zext 32) 16,
          .const 21 32, .bin 17 .lshr 16 21] ++ flags ++
        writeReg 24 (.low .rax w) 20 ++ writeReg 32 (.low .rdx w) 17)
    | _ => none
  | .bswap dst =>
    match w with
    | .W64 => fin (readReg 0 dst ++ [.un 8 .bswap 0] ++ writeReg 16 dst 8)
    | .W32 =>
      fin (readReg 0 dst ++ [.un 8 .bswap 0, .const 9 32, .bin 10 .lshr 8 9] ++
        writeReg 16 dst 10)
    | _ => none
  | .jcc cc l => some (ccOps 0 cc, .branch 0 (label l).toBitVec p.upper.toBitVec)
  | .jmp (.rel c) => some ([], .jump (p.upper + c.interp p).toBitVec)
  | .jmp (.reg r) => some (readReg 0 r, .jumpInd 0)
  | .jmp (.mem a) => some (addrOps p 1 a ++ [.load 0 .w64 1], .jumpInd 0)
  | .call (.rel c) => some (pushRet p, .jump (p.upper + c.interp p).toBitVec)
  | .call (.reg r) => some (readReg 0 r ++ pushRet p, .jumpInd 0)
  | .call (.mem a) => some (addrOps p 1 a ++ [.load 0 .w64 1] ++ pushRet p, .jumpInd 0)
  | .ret =>
    some ([.get 0 (regNum .rsp), .load 1 .w64 0, .const 2 8, .bin 3 .add 0 2,
      .set (regNum .rsp) 3], .jumpInd 1)
  | .cld => fin [.const 0 0, .setf 6 0]
  | .std => fin [.const 0 1, .setf 6 0]
  | .nop _ | .nopalign _ _ => fin []
  | _ => none

end

/-- The mnemonic of an instruction, for the reason of a `trap`. -/
def opName {w : Width} : Operation w → String
  | .mov .. => "mov" | .movsx .. => "movsx" | .movzx .. => "movzx" | .push .. => "push"
  | .pop .. => "pop" | .setcc .. => "setcc" | .cmovcc .. => "cmovcc" | .movs .. => "movs"
  | .stos .. => "stos" | .lea .. => "lea" | .add .. => "add" | .adc .. => "adc"
  | .adcx .. => "adcx" | .adox .. => "adox" | .inc .. => "inc" | .dec .. => "dec"
  | .neg .. => "neg" | .sub .. => "sub" | .sbb .. => "sbb" | .cmp .. => "cmp" | .mul .. => "mul"
  | .mulx .. => "mulx" | .imul1 .. => "imul" | .imul .. => "imul" | .test .. => "test"
  | .and .. => "and" | .not .. => "not" | .or .. => "or" | .xor .. => "xor" | .shl .. => "shl"
  | .shr .. => "shr" | .sar .. => "sar" | .shld .. => "shld" | .shrd .. => "shrd"
  | .rol .. => "rol" | .ror .. => "ror" | .rcl .. => "rcl" | .rcr .. => "rcr"
  | .bswap .. => "bswap" | .cld => "cld" | .std => "std" | .jcc .. => "jcc" | .jmp .. => "jmp"
  | .call .. => "call" | .ret => "ret" | .nop .. => "nop" | .nopalign .. => "nopalign"

/-- The block of the instruction `i`, which occupies the addresses `p`. -/
def lower [Labels] (p : Std.Rco Int64) : Instr → Block
  | .regular .W64 _ op =>
    match lowerOp p op with
    | some (ops, t) => ⟨ops, t⟩
    | none => ⟨[], .trap (opName op)⟩
  | .regular .. => ⟨[], .trap "32-bit address size"⟩
  | .avx .. => ⟨[], .trap "vector instruction"⟩

/-- The block of the directives at one address: labels, which take no room, and then one
instruction. -/
def lowerDirs [Labels] (pc : Int64) : List (Kraken.Sized Directive) → Option Block
  | [⟨.instr i, sz⟩] => some (lower ⟨pc, pc + .ofNat sz⟩ i)
  | ⟨.label _, 0⟩ :: ds => lowerDirs pc ds
  | _ => none

/-- The program of an executable: the block of the instruction at each address. -/
def lowerProgram (e : Executable) : Braid.Program :=
  fun a =>
    let := Executable.labels e
    lowerDirs (.ofBitVec a) (e.directivesAtAddress (.ofBitVec a))

end Lowering.X86
