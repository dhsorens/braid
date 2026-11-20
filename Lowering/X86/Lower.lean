/-
  Lowering.X86.Lower

  The lowering of x86-64 into `braid`: one block for each instruction, at its address. The
  machine model is Kraken's `X64` semantics, whose programs are assembly: instructions with
  sizes, laid out from a start address.

  `rax` to `r15` are `braid` registers 0 to 15, in the model's order. The status flags `cf`,
  `pf`, `af`, `zf`, `sf`, `of` are flags 0 to 5, and the direction flag is flag 6. A value
  narrower than 64 bits is held zero-extended in its SSA value. A flag the model leaves
  undefined is a `havoc`; so is the auxiliary carry flag, which no condition code reads.

  A 512-bit vector register is eight words: word `j` of `zmm k`, counted from the low end, is
  `braid` register `32 + 8 * k + j`. An `xmm` register is the low two words of its `zmm`
  register and a `ymm` register the low four. A vector in memory is read and written a word at
  a time. An instruction of the VEX or EVEX encodings clears the words of its destination
  register above its width, and one of the legacy encodings keeps them. An aligned move is a
  `guard` on its address.

  A vector instruction works on the words of its operands. A shift or a rotation of 32-bit
  lanes is a shift of each word under a constant mask of the bits that stay in their lane; a
  bitwise function given by a truth table is exclusive ors and ands of the words; a shuffle of
  32-bit lanes takes each half of a word from the half of a word the immediate names; a blend
  of 16-bit lanes is a choice under a constant mask; a shift of bytes across two vectors is
  two words shifted and or-ed; and a shuffle of bytes brings each byte down by a shift whose
  count is computed from its index.

  The SHA-256 instructions are the same arithmetic on the low two words: the schedule
  instructions by lanes, and the two rounds on working words each in the low half of a value.

  Instructions outside the lowering (a 32-bit address size, string instructions, floating
  point, and the rarer arithmetic) become a `trap`. A shift by `cl`
  changes the flags only if its count is not zero, which is known only when it runs: each
  flag is a `select` between its old value and its new one.

  ## Main definitions

  * `lowerOp`: the operations and terminator of one integer instruction
  * `vecReg`: the `braid` register of a word of a vector register
  * `lowerAvx`: the operations of one vector instruction
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

/-- The number of a vector register: `zmm k` is `k`. -/
def mmNum : RegMm → Nat
  | .mm0 => 0 | .mm1 => 1 | .mm2 => 2 | .mm3 => 3
  | .mm4 => 4 | .mm5 => 5 | .mm6 => 6 | .mm7 => 7
  | .mm8 => 8 | .mm9 => 9 | .mm10 => 10 | .mm11 => 11
  | .mm12 => 12 | .mm13 => 13 | .mm14 => 14 | .mm15 => 15
  | .mm16 => 16 | .mm17 => 17 | .mm18 => 18 | .mm19 => 19
  | .mm20 => 20 | .mm21 => 21 | .mm22 => 22 | .mm23 => 23
  | .mm24 => 24 | .mm25 => 25 | .mm26 => 26 | .mm27 => 27
  | .mm28 => 28 | .mm29 => 29 | .mm30 => 30 | .mm31 => 31

/-- The `braid` register of word `j` of the vector register `k`: bits `64 * j` to
`64 * j + 63` of `zmm k`, for `j` below 8. -/
def vecReg (k : RegMm) (j : Nat) : Nat := 32 + 8 * mmNum k + j

/-- The number of words in a vector of width `w`. -/
def vecWords : AvxWidth → Nat
  | .W128 => 2 | .W256 => 4 | .W512 => 8

/-- How x86-64 registers and flags are named in the textual form. Word `j` of `zmm k` is
`zmm<k>.<j>`. -/
def arch : Braid.Arch where
  name := "x86_64"
  regName
    | 0 => "rax" | 1 => "rbx" | 2 => "rcx" | 3 => "rdx"
    | 4 => "rsi" | 5 => "rdi" | 6 => "rsp" | 7 => "rbp"
    | r => if 32 ≤ r ∧ r < 288 then s!"zmm{(r - 32) / 8}.{(r - 32) % 8}" else s!"r{r}"
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
  | .rol dst (.imm8 c) =>
    let k := immCount p w c
    match w with
    | .W8 | .W16 => none
    | _ =>
      if k = 0 then fin (readRM p 0 dst ++ writeRM p 8 dst 0) else
      let (ct, v) := cut 17 w 16
      fin (readRM p 0 dst ++
        [.const 12 (k.zeroExtend 64), .bin 13 .shl 0 12,
          .const 14 (BitVec.ofNat 64 w.bits - k.zeroExtend 64), .bin 15 .lshr 0 14,
          .bin 16 .or 13 15] ++ ct ++
        [.const 18 1, .bin 19 .and v 18, .setf 0 19] ++
        (if k = 1 then [.bin 21 .xor v 0, .const 22 (signBit w), .bin 23 .and 21 22, .setf 5 23]
        else [.havoc 23, .setf 5 23]) ++
        writeRM p 48 dst v)
  | .ror dst (.imm8 c) =>
    let k := immCount p w c
    match w with
    | .W8 | .W16 => none
    | _ =>
      if k = 0 then fin (readRM p 0 dst ++ writeRM p 8 dst 0) else
      let (ct, v) := cut 17 w 16
      fin (readRM p 0 dst ++
        [.const 12 (k.zeroExtend 64), .bin 13 .lshr 0 12,
          .const 14 (BitVec.ofNat 64 w.bits - k.zeroExtend 64), .bin 15 .shl 0 14,
          .bin 16 .or 13 15] ++ ct ++
        [.const 18 (signBit w), .bin 19 .and v 18, .setf 0 19] ++
        (if k = 1 then [.bin 21 .xor v 0, .const 22 (signBit w), .bin 23 .and 21 22, .setf 5 23]
        else [.havoc 23, .setf 5 23]) ++
        writeRM p 48 dst v)
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

/-! ## Vector instructions -/

/-- Read the registers `r` to `r + k - 1` into the values `n` to `n + k - 1`. -/
def getRegs (n : Var) (r : Braid.Reg) (k : Nat) : List Op :=
  (List.range k).map fun j => .get (n + j) (r + j)

/-- Write the registers `r` to `r + k - 1`, register `r + j` from the value `g j`. -/
def setRegs (r : Braid.Reg) (g : Nat → Var) (k : Nat) : List Op :=
  (List.range k).map fun j => .set (r + j) (g j)

/-- Load `k` words from the address in `a` into the values `n` to `n + k - 1`, low word
first. Uses values from `t` to `t + 2 * k - 1` for the addresses. -/
def loadWords (n a t : Var) (k : Nat) : List Op :=
  (List.range k).flatMap fun j =>
    [.const (t + 2 * j) (BitVec.ofNat 64 (8 * j)), .bin (t + 2 * j + 1) .add a (t + 2 * j),
      .load (n + j) .w64 (t + 2 * j + 1)]

/-- Store the `k` words in the values `v` to `v + k - 1` at the address in `a`, low word
first. Uses values from `t` to `t + 2 * k - 1` for the addresses. -/
def storeWords (a t v : Var) (k : Nat) : List Op :=
  (List.range k).flatMap fun j =>
    [.const (t + 2 * j) (BitVec.ofNat 64 (8 * j)), .bin (t + 2 * j + 1) .add a (t + 2 * j),
      .store .w64 (t + 2 * j + 1) (v + j)]

/-- If `al`, execution is defined only if the address in `a` is a multiple of `bytes`, a
power of two. Uses values from `n` to `n + 3`. -/
def alignOps (n a : Var) (bytes : Nat) : Bool → List Op
  | true =>
    [.const n (BitVec.ofNat 64 (bytes - 1)), .bin (n + 1) .and a n, .const (n + 2) 0,
      .bin (n + 3) .eq (n + 1) (n + 2), .guard (n + 3)]
  | false => []

/-- Read a vector operand into the values `n` to `n + 7`, a word in each, low word first. A
memory operand must be aligned if `al`. Uses values from `n` to `n + 39`. -/
def readVec (n : Var) {w : AvxWidth} (al : Bool) : AvxRegOrMem w → List Op
  | .avx r => getRegs n (vecReg r.base 0) (vecWords w)
  | .mem a =>
    addrOps p (n + 8) a ++ alignOps (n + 16) (n + 8) w.bytes al ++
      loadWords n (n + 8) (n + 24) (vecWords w)

/-- Write a vector operand from the words in the values `v` up. A register keeps its words
above the width `w` if `legacy`, and has them cleared otherwise. A memory operand must be
aligned if `al`. Uses values from `n` to `n + 31`. -/
def writeVec (n : Var) {w : AvxWidth} (legacy al : Bool) (d : AvxRegOrMem w) (v : Var) :
    List Op :=
  match d with
  | .avx r =>
    setRegs (vecReg r.base 0) (v + ·) (vecWords w) ++
      (if legacy then []
      else .const n 0 :: setRegs (vecReg r.base (vecWords w)) (fun _ => n) (8 - vecWords w))
  | .mem a =>
    addrOps p n a ++ alignOps (n + 8) n w.bytes al ++ storeWords n (n + 16) v (vecWords w)

/-- The operation `op` on each of `k` pairs of words, into the values `d` up. -/
def binWords (d : Var) (op : BinOp) (a b : Var) (k : Nat) : List Op :=
  (List.range k).map fun j => .bin (d + j) op (a + j) (b + j)

/-- The operation `op` on `k` pairs of values, into the values `d` up: pair `j` is the values
`fa j` and `fb j`. -/
def zipWords (d : Var) (op : BinOp) (fa fb : Nat → Var) (k : Nat) : List Op :=
  (List.range k).map fun j => .bin (d + j) op (fa j) (fb j)

/-- The constants `f 0` to `f (k - 1)`, into the values `n` up. -/
def constWords (n : Var) (f : Nat → Word) (k : Nat) : List Op :=
  (List.range k).map fun j => .const (n + j) (f j)

/-- The word with `x` in each of its two 32-bit lanes. -/
def dup32 (x : BitVec 32) : Word := x ++ x

/-- The count of a rotation of 32-bit lanes to the right by `c`. -/
def rorCount (c : BitVec 8) : Word := (c &&& 31#8).zeroExtend 64

/-- Each 32-bit lane of the word `x` rotated to the right by `c` modulo 32: the word shifted
right and the word shifted left, each under the mask of the bits that stay in their lane. -/
def rorLanes (c : BitVec 8) (x : Word) : Word :=
  (x >>> rorCount c &&& dup32 (0xffffffff#32 >>> rorCount c)) |||
    (x <<< (32#64 - rorCount c) &&& dup32 (0xffffffff#32 <<< (32#64 - rorCount c)))

/-- Each 32-bit lane of the word `x` shifted right by `c`; zero if `c` is 32 or more. -/
def shrLanes (c : BitVec 8) (x : Word) : Word :=
  x >>> c.zeroExtend 64 &&& dup32 (0xffffffff#32 >>> c)

/-- Rotate each 32-bit lane of the `k` words in the values 0 up to the right by `c` modulo
32, into the values 80 up: `rorLanes c` of each word. Uses values from 40 to 79. -/
def rorWords (c : BitVec 8) (k : Nat) : List Op :=
  [.const 40 (rorCount c), .const 41 (dup32 (0xffffffff#32 >>> rorCount c)),
    .const 42 (32#64 - rorCount c),
    .const 43 (dup32 (0xffffffff#32 <<< (32#64 - rorCount c)))] ++
  zipWords 48 .lshr (0 + ·) (fun _ => 40) k ++ zipWords 56 .and (48 + ·) (fun _ => 41) k ++
  zipWords 64 .shl (0 + ·) (fun _ => 42) k ++ zipWords 72 .and (64 + ·) (fun _ => 43) k ++
  zipWords 80 .or (56 + ·) (72 + ·) k

/-- Shift each 32-bit lane of the `k` words in the values 0 up to the right by `c`, into the
values 56 up: `shrLanes c` of each word. Uses values from 40 to 55. -/
def shrWords (c : BitVec 8) (k : Nat) : List Op :=
  [.const 40 (c.zeroExtend 64), .const 41 (dup32 (0xffffffff#32 >>> c))] ++
  zipWords 48 .lshr (0 + ·) (fun _ => 40) k ++ zipWords 56 .and (48 + ·) (fun _ => 41) k

/-- The word of all ones if `b`, and zero otherwise. -/
def bitMask (b : Bool) : Word := if b then -1#64 else 0#64

/-- The bitwise function of three words with the truth table `t`: bit `4x + 2y + z` of `t`
is the result where a bit of `a` is `x`, of `b` is `y` and of `c` is `z`. It is a choice by
`a` between two functions of `b` and `c`, each a choice by `b` between two functions of `c`,
and a choice by `s` between `u` and `v` is `v ^^^ (s &&& (v ^^^ u))`. -/
def ternLanes (t : BitVec 8) (a b c : Word) : Word :=
  let h (i : Nat) : Word :=
    (c &&& bitMask (t.getLsbD (2 * i) != t.getLsbD (2 * i + 1))) ^^^ bitMask (t.getLsbD (2 * i))
  let g0 := h 0 ^^^ (b &&& (h 0 ^^^ h 1))
  let g1 := h 2 ^^^ (b &&& (h 2 ^^^ h 3))
  g0 ^^^ (a &&& (g0 ^^^ g1))

/-- The bitwise function with the truth table `t` of the `k` words in the values 80 up, 40 up
and 0 up, into the values 256 up. The tables that are an exclusive or of two or of all three
operands (`0x5a`, `0x3c`, `0x66`, `0x96`) are that exclusive or. Any other table is
`ternLanes t` of each three words. Uses values from 120 to 255. -/
def ternWords (t : BitVec 8) (k : Nat) : List Op :=
  if t = 0x5a#8 then zipWords 256 .xor (80 + ·) (0 + ·) k
  else if t = 0x3c#8 then zipWords 256 .xor (80 + ·) (40 + ·) k
  else if t = 0x66#8 then zipWords 256 .xor (40 + ·) (0 + ·) k
  else if t = 0x96#8 then
    zipWords 248 .xor (80 + ·) (40 + ·) k ++ zipWords 256 .xor (248 + ·) (0 + ·) k
  else
    [.const 120 (bitMask (t.getLsbD 0 != t.getLsbD 1)), .const 121 (bitMask (t.getLsbD 0)),
      .const 122 (bitMask (t.getLsbD 2 != t.getLsbD 3)), .const 123 (bitMask (t.getLsbD 2)),
      .const 124 (bitMask (t.getLsbD 4 != t.getLsbD 5)), .const 125 (bitMask (t.getLsbD 4)),
      .const 126 (bitMask (t.getLsbD 6 != t.getLsbD 7)), .const 127 (bitMask (t.getLsbD 6))] ++
    zipWords 128 .and (0 + ·) (fun _ => 120) k ++ zipWords 136 .xor (128 + ·) (fun _ => 121) k ++
    zipWords 144 .and (0 + ·) (fun _ => 122) k ++ zipWords 152 .xor (144 + ·) (fun _ => 123) k ++
    zipWords 160 .and (0 + ·) (fun _ => 124) k ++ zipWords 168 .xor (160 + ·) (fun _ => 125) k ++
    zipWords 176 .and (0 + ·) (fun _ => 126) k ++ zipWords 184 .xor (176 + ·) (fun _ => 127) k ++
    zipWords 192 .xor (136 + ·) (152 + ·) k ++ zipWords 200 .and (40 + ·) (192 + ·) k ++
    zipWords 208 .xor (136 + ·) (200 + ·) k ++
    zipWords 216 .xor (168 + ·) (184 + ·) k ++ zipWords 224 .and (40 + ·) (216 + ·) k ++
    zipWords 232 .xor (168 + ·) (224 + ·) k ++
    zipWords 240 .xor (208 + ·) (232 + ·) k ++ zipWords 248 .and (80 + ·) (240 + ·) k ++
    zipWords 256 .xor (208 + ·) (248 + ·) k

/-- The 32-bit lane that lane `i` of a shuffle by `imm` takes: within its block of four
lanes, the one numbered by bits `2 * (i % 4)` and `2 * (i % 4) + 1` of `imm`. -/
def shufLane (imm : BitVec 8) (i : Nat) : Nat := 4 * (i / 4) + (imm.toNat >>> (2 * (i % 4))) % 4

/-- Shuffle the 32-bit lanes of the `k` words in the values 0 up by `imm`, into the values 96
up. The low half of word `j` is lane `shufLane imm (2 * j)`, a half of word
`shufLane imm (2 * j) / 2` that a shift by 0 or by 32 brings down, and the high half is lane
`shufLane imm (2 * j + 1)`, brought down and shifted up. Uses values from 40 to 95. -/
def shufWords (imm : BitVec 8) (k : Nat) : List Op :=
  [.const 40 32, .const 41 0xffffffff] ++
  constWords 48 (fun j => BitVec.ofNat 64 (32 * (shufLane imm (2 * j) % 2))) k ++
  constWords 56 (fun j => BitVec.ofNat 64 (32 * (shufLane imm (2 * j + 1) % 2))) k ++
  zipWords 64 .lshr (fun j => 0 + shufLane imm (2 * j) / 2) (48 + ·) k ++
  zipWords 72 .and (64 + ·) (fun _ => 41) k ++
  zipWords 80 .lshr (fun j => 0 + shufLane imm (2 * j + 1) / 2) (56 + ·) k ++
  zipWords 88 .shl (80 + ·) (fun _ => 40) k ++ zipWords 96 .or (72 + ·) (88 + ·) k

/-- The 16-bit lanes of word `j` that a blend by `imm` takes from its second operand, as a
mask: lane `i` of a vector is taken where bit `i % 8` of `imm` is set. -/
def blendMask (imm : BitVec 8) (j : Nat) : Word :=
  BitVec.ofLanes 64 16 fun t => if imm.getLsbD ((4 * j + t) % 8) then BitVec.allOnes 16 else 0#16

/-- Blend the 16-bit lanes of the `k` words in the values 40 up with those of the words in the
values 0 up, into the values 104 up: a word `a` and a word `b` give
`a ^^^ ((a ^^^ b) &&& blendMask imm j)`. Uses values from 80 to 103. -/
def blendWords (imm : BitVec 8) (k : Nat) : List Op :=
  constWords 80 (blendMask imm) k ++ zipWords 88 .xor (40 + ·) (0 + ·) k ++
  zipWords 96 .and (88 + ·) (80 + ·) k ++ zipWords 104 .xor (40 + ·) (96 + ·) k

/-- Where word `j` of a shift of bytes by `n` starts, in its block of four words (two of the
low operand below two of the high one): the number of the word. -/
def alignWord (n j : Nat) : Nat := (8 * (j % 2) + n) / 8

/-- Where word `j` of a shift of bytes by `n` starts in the word `alignWord n j`: the number
of the byte. -/
def alignByte (n j : Nat) : Nat := (8 * (j % 2) + n) % 8

/-- The value holding word `q` of the block of word `j`: a word of the low operand, in the
values 0 up, a word of the high operand, in the values 40 up, or the zero in the value 80. -/
def alignVar (j q : Nat) : Nat :=
  if q < 2 then 0 + (2 * (j / 2) + q) else if q < 4 then 40 + (2 * (j / 2) + q - 2) else 80

/-- Shift the bytes of each block of two of the `k` words in the values 40 up, above the two
words of the same block in the values 0 up, to the right by `n` bytes, into the values 120
up. Word `j` is the word `alignWord n j` of the block shifted right by `alignByte n j` bytes,
or-ed with the next word shifted left by the rest; a shift by 64 gives zero. Uses values from
80 to 119. -/
def alignWords (n k : Nat) : List Op :=
  [.const 80 0#64] ++
  constWords 88 (fun j => BitVec.ofNat 64 (8 * alignByte n j)) k ++
  constWords 96 (fun j => BitVec.ofNat 64 (64 - 8 * alignByte n j)) k ++
  zipWords 104 .lshr (fun j => alignVar j (alignWord n j)) (88 + ·) k ++
  zipWords 112 .shl (fun j => alignVar j (alignWord n j + 1)) (96 + ·) k ++
  zipWords 120 .or (104 + ·) (112 + ·) k

/-- The count of the shift that brings down the byte that byte `b` of the word `m` of indices
picks from a block of 16 bytes: eight times the low four bits of the index, and 1024 or more
if its top bit is set. -/
def bshufCount (m : Word) (b : Nat) : Word :=
  (m >>> BitVec.ofNat 64 (8 * b) &&& 0x8f#64) <<< 3#64

/-- Byte `b` of a word of a shuffle of bytes, in its place: the byte that byte `b` of `m`
picks from the block of the words `lo` and `hi`, and zero if the top bit of the index is
set. A shift by 64 or more gives zero, so at most one of the two shifts gives the byte. -/
def bshufLane (m lo hi : Word) (b : Nat) : Word :=
  ((lo >>> bshufCount m b ||| hi >>> (bshufCount m b - 64#64)) &&& 0xff#64) <<<
    BitVec.ofNat 64 (8 * b)

/-- Byte `b` of each of the `k` words of a shuffle of bytes, or-ed into the words in the
values `n - 16` up, into the values `n + 80` up: `bshufLane` of the word of indices in the
values 0 up and the two words of its block in the values 40 up. The values 80 to 83 hold
`0x8f`, 3, 64 and `0xff`. Uses values from `n` to `n + 79`. -/
def bshufByte (n b k : Nat) : List Op :=
  [.const n (BitVec.ofNat 64 (8 * b))] ++
  zipWords (n + 8) .lshr (0 + ·) (fun _ => n) k ++
  zipWords (n + 16) .and (n + 8 + ·) (fun _ => 80) k ++
  zipWords (n + 24) .shl (n + 16 + ·) (fun _ => 81) k ++
  zipWords (n + 32) .lshr (fun j => 40 + 2 * (j / 2)) (n + 24 + ·) k ++
  zipWords (n + 40) .sub (n + 24 + ·) (fun _ => 82) k ++
  zipWords (n + 48) .lshr (fun j => 40 + (2 * (j / 2) + 1)) (n + 40 + ·) k ++
  zipWords (n + 56) .or (n + 32 + ·) (n + 48 + ·) k ++
  zipWords (n + 64) .and (n + 56 + ·) (fun _ => 83) k ++
  zipWords (n + 72) .shl (n + 64 + ·) (fun _ => n) k ++
  zipWords (n + 80) .or (n - 16 + ·) (n + 72 + ·) k

/-- Shuffle the bytes of each block of two of the `k` words in the values 40 up by the bytes
of the words in the values 0 up, into the values 864 up: zero or-ed with `bshufLane` of each
of the eight bytes of a word. Uses values from 80 to 863. -/
def bshufWords (k : Nat) : List Op :=
  [.const 80 0x8f#64, .const 81 3#64, .const 82 64#64, .const 83 0xff#64] ++
  constWords 96 (fun _ => 0#64) k ++
  bshufByte 112 0 k ++ bshufByte 208 1 k ++ bshufByte 304 2 k ++ bshufByte 400 3 k ++
  bshufByte 496 4 k ++ bshufByte 592 5 k ++ bshufByte 688 6 k ++ bshufByte 784 7 k

/-! The SHA-256 instructions work on the 32-bit lanes of the low two words of their operands.
The two schedule instructions are a mixing of lanes and a packed addition. The round
instruction takes its eight working words out of the lanes, each into the low half of a
value. -/

/-- A mixing of each 32-bit lane of the word `x` in the message schedule: the lane rotated
right by `r1`, by `r2`, and shifted right by `s`, exclusive-ored. -/
def sigLanes (r1 r2 s : BitVec 8) (x : Word) : Word :=
  rorLanes r1 x ^^^ rorLanes r2 x ^^^ shrLanes s x

/-- The ten constants of `sigLanes r1 r2 s`, into the values `k` up. -/
def sigConsts (k : Nat) (r1 r2 s : BitVec 8) : List Op :=
  [.const k (rorCount r1), .const (k + 1) (dup32 (0xffffffff#32 >>> rorCount r1)),
    .const (k + 2) (32#64 - rorCount r1),
    .const (k + 3) (dup32 (0xffffffff#32 <<< (32#64 - rorCount r1))),
    .const (k + 4) (rorCount r2), .const (k + 5) (dup32 (0xffffffff#32 >>> rorCount r2)),
    .const (k + 6) (32#64 - rorCount r2),
    .const (k + 7) (dup32 (0xffffffff#32 <<< (32#64 - rorCount r2))),
    .const (k + 8) (s.zeroExtend 64), .const (k + 9) (dup32 (0xffffffff#32 >>> s))]

/-- The value `a` plus, lane by lane, `sigLanes` of the value `x`, into the value `d`, with
the constants in the values `k` up. Uses values from `n` to `n + 13`. -/
def sigOps (n k x d a : Nat) : List Op :=
  [.bin n .lshr x k, .bin (n + 1) .and n (k + 1), .bin (n + 2) .shl x (k + 2),
    .bin (n + 3) .and (n + 2) (k + 3), .bin (n + 4) .or (n + 1) (n + 3),
    .bin (n + 5) .lshr x (k + 4), .bin (n + 6) .and (n + 5) (k + 5),
    .bin (n + 7) .shl x (k + 6), .bin (n + 8) .and (n + 7) (k + 7),
    .bin (n + 9) .or (n + 6) (n + 8),
    .bin (n + 10) .lshr x (k + 8), .bin (n + 11) .and (n + 10) (k + 9),
    .bin (n + 12) .xor (n + 4) (n + 9), .bin (n + 13) .xor (n + 12) (n + 11),
    .bin d (.lanes 32 .add) a (n + 13)]

/-- The high half of the value `x` below the low half of the value `y`, into the value
`n + 3`. Uses values from `n` to `n + 2`. -/
def joinOps (n x y : Nat) : List Op :=
  [.const n 32#64, .bin (n + 1) .lshr x n, .bin (n + 2) .shl y n,
    .bin (n + 3) .or (n + 1) (n + 2)]

/-- The low word of `sha256msg1`: the low word `d0` of the destination plus, lane by lane,
the mixing of the two lanes above its low one, the second of them from the high word
`d1`. -/
def msg1Lo (d0 d1 : Word) : Word :=
  (BinOp.lanes 32 .add).eval d0 (sigLanes 7 18 3 (d0 >>> 32#64 ||| d1 <<< 32#64))

/-- The high word of `sha256msg1`: the high word `d1` of the destination plus, lane by lane,
the mixing of its high lane and of the low lane of the source's low word `s0`. -/
def msg1Hi (d1 s0 : Word) : Word :=
  (BinOp.lanes 32 .add).eval d1 (sigLanes 7 18 3 (d1 >>> 32#64 ||| s0 <<< 32#64))

/-- The low word of `sha256msg2`: the low word `d0` of the destination plus, lane by lane,
the mixing of the high word `s1` of the source. -/
def msg2Lo (d0 s1 : Word) : Word := (BinOp.lanes 32 .add).eval d0 (sigLanes 17 19 10 s1)

/-- The high word of `sha256msg2`: the high word `d1` of the destination plus, lane by lane,
the mixing of the low word `lo` of the result. -/
def msg2Hi (d1 lo : Word) : Word := (BinOp.lanes 32 .add).eval d1 (sigLanes 17 19 10 lo)

/-- The two words of `sha256msg1`, of the destination in the values 40 and 41 and the source
in the value 0, into the values 200 and 201: `msg1Lo` and `msg1Hi`, with zero in the `k`
values after them. Uses values from 82 to 133. -/
def msg1Words (k : Nat) : List Op :=
  sigConsts 82 7 18 3 ++ joinOps 92 40 41 ++ sigOps 96 82 95 200 40 ++ joinOps 110 41 0 ++
  sigOps 120 82 113 201 41 ++ constWords 202 (fun _ => 0#64) k

/-- The two words of `sha256msg2`, of the destination in the values 40 and 41 and the source
in the value 1, into the values 200 and 201: `msg2Lo`, and `msg2Hi` of it, with zero in the
`k` values after them. Uses values from 80 to 125. -/
def msg2Words (k : Nat) : List Op :=
  sigConsts 80 17 19 10 ++ sigOps 96 80 1 200 40 ++ sigOps 112 80 200 201 41 ++
  constWords 202 (fun _ => 0#64) k

/-- The word with the low half of `x` in both halves, for `x` below `2 ^ 32`: a shift of it
to the right by `c` has in its low half the low half of `x` rotated by `c`. -/
def dupLo (x : Word) : Word := x ||| x <<< 32#64

/-- A mixing of a working word in a round: the word rotated right by `c1`, by `c2` and by
`c3`, exclusive-ored. The low half is the mixing of `x`, for `x` below `2 ^ 32`. -/
def bigSig (c1 c2 c3 x : Word) : Word := dupLo x >>> c1 ^^^ dupLo x >>> c2 ^^^ dupLo x >>> c3

/-- What a round adds to its fourth and to its first working word, in the low half: the
choice by `e` between `f` and `g`, the mixing of `e`, the message word with its constant, and
`h`. Only `e` must be below `2 ^ 32`. -/
def rndT (e f g h k : Word) : Word :=
  (g ^^^ (e &&& (f ^^^ g))) + bigSig 6#64 11#64 25#64 e + k + h

/-- The new first working word of a round, in the low half: `rndT`, the majority of `a`, `b`
and `c`, and the mixing of `a`. Only `a` and `e` must be below `2 ^ 32`. -/
def rndA (a b c e f g h k : Word) : Word :=
  rndT e f g h k + ((a &&& (b ^^^ c)) ^^^ (b &&& c)) + bigSig 2#64 13#64 22#64 a

/-- The new fifth working word of a round, in the low half: `rndT` and `d`. -/
def rndE (d e f g h k : Word) : Word := rndT e f g h k + d

/-- One round, of the working words in the values `a` to `h` and the message word in `k`:
`rndA` into the value `n + 25` and `rndE` into `n + 26`. The values 81 to 87 hold 32 and the
six counts. Uses values from `n` to `n + 24`. -/
def rndOps (n a b c d e f g h k : Nat) : List Op :=
  [.bin n .shl e 81, .bin (n + 1) .or e n,
    .bin (n + 2) .lshr (n + 1) 82, .bin (n + 3) .lshr (n + 1) 83, .bin (n + 4) .lshr (n + 1) 84,
    .bin (n + 5) .xor (n + 2) (n + 3), .bin (n + 6) .xor (n + 5) (n + 4),
    .bin (n + 7) .xor f g, .bin (n + 8) .and e (n + 7), .bin (n + 9) .xor g (n + 8),
    .bin (n + 10) .add (n + 9) (n + 6), .bin (n + 11) .add (n + 10) k,
    .bin (n + 12) .add (n + 11) h,
    .bin (n + 13) .shl a 81, .bin (n + 14) .or a (n + 13),
    .bin (n + 15) .lshr (n + 14) 85, .bin (n + 16) .lshr (n + 14) 86,
    .bin (n + 17) .lshr (n + 14) 87,
    .bin (n + 18) .xor (n + 15) (n + 16), .bin (n + 19) .xor (n + 18) (n + 17),
    .bin (n + 20) .xor b c, .bin (n + 21) .and a (n + 20), .bin (n + 22) .and b c,
    .bin (n + 23) .xor (n + 21) (n + 22),
    .bin (n + 24) .add (n + 12) (n + 23), .bin (n + 25) .add (n + 24) (n + 19),
    .bin (n + 26) .add (n + 12) d]

/-- The first working word after the first of the two rounds of `sha256rnds2`, below
`2 ^ 32`. The source's words are `x0` and `x1`, the destination's `y0` and `y1`, and `k` is
the low word of `xmm0`. -/
def rnds2A (x0 x1 y0 y1 k : Word) : Word :=
  rndA (x1 >>> 32#64) x1 (y1 >>> 32#64) (x0 >>> 32#64) x0 (y0 >>> 32#64) y0 k &&&
    0xffffffff#64

/-- The fifth working word after the first of the two rounds of `sha256rnds2`, below
`2 ^ 32`. -/
def rnds2E (x0 y0 y1 k : Word) : Word :=
  rndE y1 (x0 >>> 32#64) x0 (y0 >>> 32#64) y0 k &&& 0xffffffff#64

/-- The low word of `sha256rnds2`: the fifth working word after the first round, and after
the second above it. -/
def rnds2Lo (x0 y0 y1 k : Word) : Word :=
  rnds2E x0 y0 y1 k |||
    rndE (y1 >>> 32#64) (rnds2E x0 y0 y1 k) (x0 >>> 32#64) x0 (y0 >>> 32#64) (k >>> 32#64) <<<
      32#64

/-- The high word of `sha256rnds2`: the first working word after the first round, and after
the second above it. -/
def rnds2Hi (x0 x1 y0 y1 k : Word) : Word :=
  rnds2A x0 x1 y0 y1 k |||
    rndA (rnds2A x0 x1 y0 y1 k) (x1 >>> 32#64) x1 (rnds2E x0 y0 y1 k) (x0 >>> 32#64) x0
      (y0 >>> 32#64) (k >>> 32#64) <<< 32#64

/-- What the two rounds of `sha256rnds2` start from: the low word of `xmm0` into the value
80, the constants into the values 81 to 88, and the high halves of the source's words (the
values 0 and 1), of the destination's (40 and 41) and of the low word of `xmm0` into the
values 90 to 94. -/
def rnds2Pre : List Op :=
  [.get 80 (vecReg .mm0 0), .const 81 32#64, .const 82 6#64, .const 83 11#64,
    .const 84 25#64, .const 85 2#64, .const 86 13#64, .const 87 22#64,
    .const 88 0xffffffff#64,
    .bin 90 .lshr 0 81, .bin 91 .lshr 40 81, .bin 92 .lshr 1 81, .bin 93 .lshr 41 81,
    .bin 94 .lshr 80 81]

/-- The low halves of the first and the fifth working word after the first round, into the
values 123 and 124. -/
def rnds2Mask : List Op := [.bin 123 .and 121 88, .bin 124 .and 122 88]

/-- The two result words of `sha256rnds2`, into the values 200 and 201: each a working word
after the first round, and after the second above it. -/
def rnds2Pack : List Op :=
  [.bin 155 .shl 154 81, .bin 200 .or 124 155, .bin 156 .shl 153 81, .bin 201 .or 123 156]

/-- The two words of `sha256rnds2`, of the destination in the values 40 and 41, the source in
the values 0 and 1 and the low word of `xmm0`, into the values 200 and 201: `rnds2Lo` and
`rnds2Hi`, with zero in the `k` values after them. Uses values from 80 to 156. -/
def rnds2Words (k : Nat) : List Op :=
  rnds2Pre ++ rndOps 96 92 1 93 41 90 0 91 40 80 ++ rnds2Mask ++
  rndOps 128 123 92 1 93 124 90 0 91 94 ++ rnds2Pack ++ constWords 202 (fun _ => 0#64) k

/-- The low byte of an immediate. -/
def imm8 (c : ConstExpr) : BitVec 8 := (c.interp p).toBitVec.take 8

/-- A move of a vector. -/
def moveVec {w : AvxWidth} (legacy al : Bool) (dst src : AvxRegOrMem w) : List Op :=
  readVec p 0 al src ++ writeVec p 40 legacy al dst 0

/-- The operations of the vector instruction `i`, or `none` if it is outside the lowering.
Every vector instruction goes on to the next one. -/
def lowerAvx {w : AvxWidth} : AvxOperation w → Option (List Op)
  | .movups dst src => some (moveVec p true false dst src)
  | .movdqu dst src => some (moveVec p true false dst src)
  | .movaps dst src => some (moveVec p true true dst src)
  | .movdqa dst src => some (moveVec p true true dst src)
  | .vmovups dst src => some (moveVec p false false dst src)
  | .vmovdqu dst src => some (moveVec p false false dst src)
  | .vmovdqu32 dst src => some (moveVec p false false dst src)
  | .vmovdqa32 dst src => some (moveVec p false true dst src)
  | .vmovq dst src =>
    some ([.get 0 (vecReg src.base 0), .const 1 0] ++
      setRegs (vecReg dst.base 0) (fun j => if j = 0 then 0 else 1) 8)
  | .vmovIn _ dst src =>
    some (readRM p 0 src ++ [.const 8 0] ++
      setRegs (vecReg dst.base 0) (fun j => if j = 0 then 0 else 8) 8)
  | .vmovOut n dst src =>
    some ([.get 0 (vecReg src.base 0), .un 1 (.zext n.bits) 0] ++ writeRM p 8 dst 1)
  | .paddd dst src =>
    some (readVec p 0 true src ++ readVec p 40 false dst ++
      binWords 80 (.lanes 32 .add) 40 0 (vecWords w) ++ writeVec p 96 true false dst 80)
  | .vpaddd dst src1 src2 =>
    some (readVec p 0 false src2 ++ readVec p 40 false src1 ++
      binWords 80 (.lanes 32 .add) 40 0 (vecWords w) ++ writeVec p 96 false false dst 80)
  | .vprord dst src imm =>
    some (readVec p 0 false src ++ rorWords (imm8 p imm) (vecWords w) ++
      writeVec p 96 false false dst 80)
  | .vpsrld dst src imm =>
    some (readVec p 0 false src ++ shrWords (imm8 p imm) (vecWords w) ++
      writeVec p 64 false false dst 56)
  | .vpternlogd dst src2 src3 imm =>
    some (readVec p 0 false src3 ++ readVec p 40 false src2 ++ readVec p 80 false dst ++
      ternWords (imm8 p imm) (vecWords w) ++ writeVec p 264 false false dst 256)
  | .pblendw dst src imm =>
    some (readVec p 0 true src ++ readVec p 40 false dst ++
      blendWords (imm8 p imm) (vecWords w) ++ writeVec p 112 true false dst 104)
  | .palignr dst src imm =>
    some (readVec p 0 true src ++ readVec p 40 false dst ++
      alignWords (imm8 p imm).toNat (vecWords w) ++ writeVec p 128 true false dst 120)
  | .pshufb dst src =>
    some (readVec p 0 true src ++ readVec p 40 false dst ++ bshufWords (vecWords w) ++
      writeVec p 872 true false dst 864)
  | .sha256rnds2 dst src =>
    some (readVec p 0 true src ++ readVec p 40 false dst ++ rnds2Words (vecWords w - 2) ++
      writeVec p 208 true false dst 200)
  | .sha256msg1 dst src =>
    some (readVec p 0 true src ++ readVec p 40 false dst ++ msg1Words (vecWords w - 2) ++
      writeVec p 208 true false dst 200)
  | .sha256msg2 dst src =>
    some (readVec p 0 true src ++ readVec p 40 false dst ++ msg2Words (vecWords w - 2) ++
      writeVec p 208 true false dst 200)
  | .pshufd dst src imm =>
    some (readVec p 0 true src ++ shufWords (imm8 p imm) (vecWords w) ++
      writeVec p 104 true false dst 96)
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
  | .avx .W64 _ op =>
    match lowerAvx p op with
    | some ops => ⟨ops, .jump p.upper.toBitVec⟩
    | none => ⟨[], .trap "vector instruction"⟩
  | .avx .. => ⟨[], .trap "32-bit address size"⟩

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
