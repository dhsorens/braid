/-
  Lowering.Arm.Lower

  The lowering of AArch64 into `braid`: one block for each instruction, at its address. The
  machine model is the trusted package of arm64-semantics, `Arm64.Trusted`.

  Register `Xn` is `braid` register `n`, and `SP` is register 31. `XZR` is never read or
  written: a read is the constant zero and a write is dropped. The flags `N`, `Z`, `C`, `V`
  are `braid` flags 0 to 3. A 32-bit operation works on values zero-extended to 64 bits.

  A vector register is two `braid` registers: `V k` has its bits 0 to 63 in register
  `64 + 2 * k` and its bits 64 to 127 in register `65 + 2 * k`. A vector instruction works
  on the two halves one after the other, and an operation on lanes is `BinOp.lanes` on each
  half. Covered: loads and stores of vector registers, moves between general and vector
  registers, the bitwise operations and the addition and subtraction of lanes, and the
  constants of `MOVI`.

  Whenever the model would not simply run the instruction (a permission fault, a stack
  pointer that is not aligned, a supervisor call, a breakpoint), the block faults. Floating
  point and the rest of SIMD, atomics and exclusives, system registers and system calls,
  `CRC32`, and `RBIT`, `CLZ` and `CLS` are outside the lowering and become a `trap`.

  The SSA values of a block are numbered by the group of operations that defines them, so
  the numbers are neither dense nor in order of definition.

  ## Main definitions

  * `lower`: the block of one instruction
  * `vregLo`, `vregHi`: the two `braid` registers of a vector register
  * `lowerProgram`: the program of a code image
  * `arch`: the names of the registers and flags
-/

module

public import Braid
public import Arm64.Trusted.ISA.Semantics

@[expose] public section

namespace Lowering.Arm

open Braid
open Arm64 (Instr RegWidth MemWidth CondCode ShiftType ExtendType AddrMode AddSubOp LogicalOp
  MoveWideOp BitfieldOp CondSelectOp DataProc1Op DataProc2Op DataProc3Op SimdMemSize)

/-- How AArch64 registers and flags are named in the textual form. The two halves of the
vector register `V k` are `v<k>.lo` and `v<k>.hi`. -/
def arch : Arch where
  name := "aarch64"
  regName r :=
    if r = 31 then "sp"
    else if 64 ≤ r ∧ r < 128 then
      s!"v{(r - 64) / 2}.{if r % 2 = 0 then "lo" else "hi"}"
    else s!"x{r}"
  flagName f :=
    match f with
    | 0 => "n" | 1 => "z" | 2 => "c" | 3 => "v"
    | _ => s!"f{f}"

/-! ## Registers -/

/-- Read a register into `d`. -/
def rget (d : Var) (r : Arm64.Reg) : Op :=
  match r with
  | .gpr i => if i = 31#5 then .const d 0 else .get d i.toNat
  | .sp => .get d 31
  | .xzr => .const d 0

/-- Write a register from `a`. -/
def rset (r : Arm64.Reg) (a : Var) : List Op :=
  match r with
  | .gpr i => if i = 31#5 then [] else [.set i.toNat a]
  | .sp => [.set 31 a]
  | .xzr => []

/-- A value as a register of width `w` holds it: the low 32 bits zero-extended, or all 64. -/
def norm (w : RegWidth) (v : Word) : Word :=
  match w with
  | .W32 => (v.truncate 32).zeroExtend 64
  | .W64 => v

/-! ## Chains

Most operands are a register or a loaded value put through a few steps: an extension, a
shift by a constant. A chain is the operations that do so. -/

/-- One step on a single value: a one-operand operation, or a two-operand operation whose
second operand is a constant. -/
inductive Stage where
  | un (op : UnOp)
  | binc (op : BinOp) (c : Word)
  deriving DecidableEq, Repr, Inhabited

/-- The value of a step. -/
def Stage.eval : Stage → Word → Word
  | .un op, a => op.eval a
  | .binc op c, a => op.eval a c

/-- The value of a list of steps, in order. -/
def Stage.run (sts : List Stage) (v : Word) : Word := sts.foldl (fun a st => st.eval a) v

/-- The operations of a step from `cur` into `res`. A constant goes in `n`. -/
def Stage.ops (st : Stage) (res cur n : Var) : List Op :=
  match st with
  | .un op => [.un res op cur]
  | .binc op c => [.const n c, .bin res op cur n]

/-- The operations of the steps `sts` on the value `cur`. The last one defines `d`, and the
others use values from `n` up. -/
def chainFrom (d : Var) : Var → Var → List Stage → List Op
  | _, _, [] => []
  | cur, n, [st] => st.ops d cur n
  | cur, n, st :: st' :: sts => st.ops (n + 1) cur n ++ chainFrom d (n + 1) (n + 2) (st' :: sts)

/-- The operation `first` followed by the steps `sts` on its value. The result is `d`, and
the values from `d + 1` to `d + 1 + 2 * sts.length` are used on the way. -/
def chain (d : Var) (first : Var → Op) (sts : List Stage) : List Op :=
  match sts with
  | [] => [first d]
  | _ :: _ => first (d + 1) :: chainFrom d (d + 1) (d + 2) sts

/-- Read a register at width `w` into `d`. Uses `d + 1`. -/
def rgetW (d : Var) (w : RegWidth) (r : Arm64.Reg) : List Op :=
  chain d (rget · r) (match w with | .W32 => [.un (.zext 32)] | .W64 => [])

/-- The `braid` operation of a shift. -/
def shiftOp : ShiftType → BinOp
  | .LSL => .shl
  | .LSR => .lshr
  | .ASR => .ashr
  | .ROR => .rotr

/-- The steps that shift a register of width `w` by the constant `amount`. A 32-bit rotation
is a shift of the value repeated in the upper half. -/
def shiftStages (w : RegWidth) (sh : ShiftType) (amount : Nat) : List Stage :=
  match w with
  | .W64 =>
    if amount % 64 = 0 then [] else [.binc (shiftOp sh) (BitVec.ofNat 64 (amount % 64))]
  | .W32 =>
    let k : Word := BitVec.ofNat 64 (amount % 32)
    if amount % 32 = 0 then [.un (.zext 32)] else
    match sh with
    | .LSL => [.binc .shl k, .un (.zext 32)]
    | .LSR => [.un (.zext 32), .binc .lshr k]
    | .ASR => [.un (.sext 32), .binc .ashr k, .un (.zext 32)]
    | .ROR => [.un (.zext 32), .binc .mul 0x100000001#64, .binc .lshr k, .un (.zext 32)]

/-- The steps that extend a register and shift it left by `amount`, at width `w`. -/
def extStages (w : RegWidth) (ext : ExtendType) (amount : Nat) : List Stage :=
  (match ext, w with
    | .UXTB, _ => [.un (.zext 8)]
    | .UXTH, _ => [.un (.zext 16)]
    | .UXTW, .W64 => [.un (.zext 32)]
    | .SXTB, _ => [.un (.sext 8)]
    | .SXTH, _ => [.un (.sext 16)]
    | .SXTW, .W64 => [.un (.sext 32)]
    | _, _ => []) ++
  (if amount = 0 then [] else if amount < 64 then [.binc .shl (BitVec.ofNat 64 amount)]
    else [.binc .and 0#64]) ++
  (match w with | .W32 => [.un (.zext 32)] | .W64 => [])

/-- The width of a memory access. -/
def memW : MemWidth → Braid.Width
  | .B8 => .w8
  | .H16 => .w16
  | .W32 => .w32
  | .X64 => .w64

/-- The steps from a loaded value, which `braid` zero-extends, to the value a register of
width `w` gets: a sign extension if `signed`, and the low 32 bits for a 32-bit register. -/
def loadStages (w : RegWidth) (sz : MemWidth) (signed : Bool) : List Stage :=
  match sz, signed, w with
  | .X64, _, .W64 => []
  | .X64, _, .W32 => [.un (.zext 32)]
  | _, false, _ => []
  | .B8, true, .W64 => [.un (.sext 8)]
  | .H16, true, .W64 => [.un (.sext 16)]
  | .W32, true, .W64 => [.un (.sext 32)]
  | .B8, true, .W32 => [.un (.sext 8), .un (.zext 32)]
  | .H16, true, .W32 => [.un (.sext 16), .un (.zext 32)]
  | .W32, true, .W32 => []

/-! ## Flags -/

/-- Write the four flags from `n`, `z`, `c`, `v`. -/
def setNZCV (n z c v : Var) : List Op := [.setf 0 n, .setf 1 z, .setf 2 c, .setf 3 v]

/-- Whether the condition `cond` holds, as `1` or `0` in `d`. Uses up to `d + 4`. -/
def condOps (d : Var) (cond : CondCode) : List Op :=
  match cond with
  | .EQ => [.getf d 1]
  | .NE => [.getf (d + 1) 1, .const (d + 2) 0, .bin d .eq (d + 1) (d + 2)]
  | .CS => [.getf d 2]
  | .CC => [.getf (d + 1) 2, .const (d + 2) 0, .bin d .eq (d + 1) (d + 2)]
  | .MI => [.getf d 0]
  | .PL => [.getf (d + 1) 0, .const (d + 2) 0, .bin d .eq (d + 1) (d + 2)]
  | .VS => [.getf d 3]
  | .VC => [.getf (d + 1) 3, .const (d + 2) 0, .bin d .eq (d + 1) (d + 2)]
  | .HI => [.getf (d + 1) 2, .getf (d + 2) 1, .bin d .ult (d + 2) (d + 1)]
  | .LS => [.getf (d + 1) 2, .getf (d + 2) 1, .bin d .ule (d + 1) (d + 2)]
  | .GE => [.getf (d + 1) 0, .getf (d + 2) 3, .bin d .eq (d + 1) (d + 2)]
  | .LT => [.getf (d + 1) 0, .getf (d + 2) 3, .bin d .ne (d + 1) (d + 2)]
  | .GT => [.getf (d + 1) 0, .getf (d + 2) 3, .bin (d + 3) .eq (d + 1) (d + 2), .getf (d + 4) 1,
      .bin d .ult (d + 4) (d + 3)]
  | .LE => [.getf (d + 1) 0, .getf (d + 2) 3, .bin (d + 3) .eq (d + 1) (d + 2), .getf (d + 4) 1,
      .bin d .ule (d + 3) (d + 4)]
  | .AL => [.const d 1]
  | .NV => [.const d 1]

/-- An addition or subtraction of `x` and `y`, both of width `w`, with its flags: the result
in `d`, and `N`, `Z`, `C`, `V` in `d + 1` to `d + 4`. Uses up to `d + 11`. -/
def flagOps (d : Var) (w : RegWidth) (isSub : Bool) (x y : Var) : List Op :=
  match w, isSub with
  | .W64, false =>
    [.bin d .add x y, .const (d + 5) 0, .bin (d + 1) .slt d (d + 5), .bin (d + 2) .eq d (d + 5),
      .bin (d + 3) .ult d x, .bin (d + 6) .xor x d, .bin (d + 7) .xor y d,
      .bin (d + 8) .and (d + 6) (d + 7), .bin (d + 4) .slt (d + 8) (d + 5)]
  | .W64, true =>
    [.bin d .sub x y, .const (d + 5) 0, .bin (d + 1) .slt d (d + 5), .bin (d + 2) .eq x y,
      .bin (d + 3) .ule y x, .bin (d + 6) .xor x y, .bin (d + 7) .xor x d,
      .bin (d + 8) .and (d + 6) (d + 7), .bin (d + 4) .slt (d + 8) (d + 5)]
  | .W32, false =>
    [.bin (d + 5) .add x y, .un d (.zext 32) (d + 5), .const (d + 6) 0,
      .un (d + 7) (.sext 32) d, .bin (d + 1) .slt (d + 7) (d + 6), .bin (d + 2) .eq d (d + 6),
      .bin (d + 3) .ne d (d + 5), .bin (d + 8) .xor x d, .bin (d + 9) .xor y d,
      .bin (d + 10) .and (d + 8) (d + 9), .un (d + 11) (.sext 32) (d + 10),
      .bin (d + 4) .slt (d + 11) (d + 6)]
  | .W32, true =>
    [.bin (d + 5) .sub x y, .un d (.zext 32) (d + 5), .const (d + 6) 0,
      .un (d + 7) (.sext 32) d, .bin (d + 1) .slt (d + 7) (d + 6), .bin (d + 2) .eq x y,
      .bin (d + 3) .ule y x, .bin (d + 8) .xor x y, .bin (d + 9) .xor x d,
      .bin (d + 10) .and (d + 8) (d + 9), .un (d + 11) (.sext 32) (d + 10),
      .bin (d + 4) .slt (d + 11) (d + 6)]

/-- `ADD`, `ADDS`, `SUB` or `SUBS` of `x` and `y`, both of width `w`: the result in `d`, and
the flags written if the operation sets them. Uses up to `d + 11`. -/
def addSubOps (d : Var) (w : RegWidth) (op : AddSubOp) (x y : Var) : List Op :=
  match op, w with
  | .ADD, .W64 => [.bin d .add x y]
  | .SUB, .W64 => [.bin d .sub x y]
  | .ADD, .W32 => [.bin (d + 1) .add x y, .un d (.zext 32) (d + 1)]
  | .SUB, .W32 => [.bin (d + 1) .sub x y, .un d (.zext 32) (d + 1)]
  | .ADDS, _ => flagOps d w false x y ++ setNZCV (d + 1) (d + 2) (d + 3) (d + 4)
  | .SUBS, _ => flagOps d w true x y ++ setNZCV (d + 1) (d + 2) (d + 3) (d + 4)

/-- A logical operation on `x` and `y`, both of width `w`: the result in `d`, and the flags
written if the operation sets them. Uses up to `d + 4`. -/
def logicOps (d : Var) (w : RegWidth) (op : LogicalOp) (x y : Var) : List Op :=
  let flags : List Op :=
    match w with
    | .W64 =>
      [.const (d + 1) 0, .bin (d + 2) .slt d (d + 1), .bin (d + 3) .eq d (d + 1)] ++
        setNZCV (d + 2) (d + 3) (d + 1) (d + 1)
    | .W32 =>
      [.const (d + 1) 0, .un (d + 4) (.sext 32) d, .bin (d + 2) .slt (d + 4) (d + 1),
        .bin (d + 3) .eq d (d + 1)] ++ setNZCV (d + 2) (d + 3) (d + 1) (d + 1)
  match op, w with
  | .AND, _ => [.bin d .and x y]
  | .ORR, _ => [.bin d .or x y]
  | .EOR, _ => [.bin d .xor x y]
  | .BIC, _ => [.un (d + 1) .not y, .bin d .and x (d + 1)]
  | .ORN, .W64 => [.un (d + 1) .not y, .bin d .or x (d + 1)]
  | .EON, .W64 => [.un (d + 1) .not y, .bin d .xor x (d + 1)]
  | .ORN, .W32 => [.un (d + 1) .not y, .bin (d + 2) .or x (d + 1), .un d (.zext 32) (d + 2)]
  | .EON, .W32 => [.un (d + 1) .not y, .bin (d + 2) .xor x (d + 1), .un d (.zext 32) (d + 2)]
  | .ANDS, _ => [.bin d .and x y] ++ flags
  | .BICS, _ => [.un (d + 5) .not y, .bin d .and x (d + 5)] ++ flags

/-! ## Addresses -/

/-- Read the base register of an access into `d`. If it is `SP`, it must be aligned to 16
bytes. Uses up to `d + 4`. -/
def baseOps (d : Var) (base : Arm64.Reg) : List Op :=
  rget d base ::
    match base with
    | .sp => [.const (d + 1) 15, .bin (d + 2) .and d (d + 1), .const (d + 3) 0,
        .bin (d + 4) .eq (d + 2) (d + 3), .guard (d + 4)]
    | _ => []

/-- The address of an access in `d`, with the base register written back for the indexed
modes. Uses up to `d + 20`. -/
def addrOps (d : Var) (addr : AddrMode) : List Op :=
  match addr with
  | .Offset base off | .UnscaledOffset base off =>
    if off = 0 then baseOps d base
    else baseOps (d + 1) base ++ [.const (d + 6) off, .bin d .add (d + 1) (d + 6)]
  | .PreIndex base off =>
    baseOps (d + 1) base ++ [.const (d + 6) off, .bin d .add (d + 1) (d + 6)] ++ rset base d
  | .PostIndex base off =>
    baseOps d base ++ [.const (d + 5) off, .bin (d + 6) .add d (d + 5)] ++ rset base (d + 6)
  | .RegOffset base index ext amount =>
    baseOps (d + 1) base ++ chain (d + 6) (rget · index) (extStages .W64 ext amount) ++
      [.bin d .add (d + 1) (d + 6)]

/-! ## Instructions -/

/-- The width of a load or store of a whole register. -/
def regMemW : RegWidth → MemWidth
  | .W32 => .W32
  | .W64 => .X64

/-- The number of bytes of a register of width `w`. -/
def regBytes : RegWidth → Word
  | .W32 => 4#64
  | .W64 => 8#64

/-- A load of a pair of registers: `LDP`, `LDPSW`, `LDNP`. -/
def lowerLdp (pc : Word) (w : RegWidth) (signed : Bool) (rt1 rt2 : Arm64.Reg) (addr : AddrMode) :
    Block :=
  let sz : MemWidth := if signed then .W32 else regMemW w
  let outW : RegWidth := if signed then .W64 else w
  ⟨addrOps 0 addr ++ [.const 21 (if signed then 4#64 else regBytes w), .bin 22 .add 0 21] ++
      chain 23 (.load · (memW sz) 0) (loadStages outW sz signed) ++
      chain 26 (.load · (memW sz) 22) (loadStages outW sz signed) ++ rset rt1 23 ++ rset rt2 26,
    .jump (pc + 4)⟩

/-- A store of a pair of registers: `STP`, `STNP`. -/
def lowerStp (pc : Word) (w : RegWidth) (rt1 rt2 : Arm64.Reg) (addr : AddrMode) : Block :=
  ⟨rget 0 rt1 :: rget 1 rt2 :: (addrOps 2 addr ++ [.const 23 (regBytes w), .bin 24 .add 2 23,
      .store (memW (regMemW w)) 2 0, .store (memW (regMemW w)) 24 1]),
    .jump (pc + 4)⟩

/-- The steps of a conditional select on the register that is taken when the condition
fails. -/
def cselStages (w : RegWidth) (op : CondSelectOp) : List Stage :=
  (match op with
    | .CSEL => []
    | .CSINC => [.binc .add 1#64]
    | .CSINV => [.un .not]
    | .CSNEG => [.un .neg]) ++
  (match w with | .W32 => [.un (.zext 32)] | .W64 => [])

/-- A division or a shift by a register, of `0` and `1` into `9`. -/
def dp2Ops (w : RegWidth) (op : DataProc2Op) : List Op :=
  match w, op with
  | .W64, .UDIV => [.bin 9 .udiv 0 1]
  | .W64, .SDIV => [.bin 9 .sdiv 0 1]
  | .W64, .LSLV => [.const 2 63, .bin 3 .and 1 2, .bin 9 .shl 0 3]
  | .W64, .LSRV => [.const 2 63, .bin 3 .and 1 2, .bin 9 .lshr 0 3]
  | .W64, .ASRV => [.const 2 63, .bin 3 .and 1 2, .bin 9 .ashr 0 3]
  | .W64, .RORV => [.bin 9 .rotr 0 1]
  | .W32, .UDIV => [.un 2 (.zext 32) 0, .un 3 (.zext 32) 1, .bin 9 .udiv 2 3]
  | .W32, .SDIV =>
    [.un 2 (.sext 32) 0, .un 3 (.sext 32) 1, .bin 4 .sdiv 2 3, .un 9 (.zext 32) 4]
  | .W32, .LSLV => [.const 2 31, .bin 3 .and 1 2, .bin 4 .shl 0 3, .un 9 (.zext 32) 4]
  | .W32, .LSRV => [.un 2 (.zext 32) 0, .const 3 31, .bin 4 .and 1 3, .bin 9 .lshr 2 4]
  | .W32, .ASRV =>
    [.un 2 (.sext 32) 0, .const 3 31, .bin 4 .and 1 3, .bin 5 .ashr 2 4, .un 9 (.zext 32) 5]
  | .W32, .RORV =>
    [.un 2 (.zext 32) 0, .const 3 0x100000001#64, .bin 4 .mul 2 3, .const 5 31, .bin 6 .and 1 5,
      .bin 7 .lshr 4 6, .un 9 (.zext 32) 7]

/-- A multiplication with an addend, into `9`. -/
def dp3Ops (w : RegWidth) (op : DataProc3Op) (rn rm ra : Arm64.Reg) : List Op :=
  let fin (v : Var) : List Op := match w with | .W32 => [.un 9 (.zext 32) v] | .W64 => []
  let res : Var := match w with | .W32 => 8 | .W64 => 9
  match op with
  | .MADD => [rget 0 rn, rget 1 rm, rget 2 ra, .bin 3 .mul 0 1, .bin res .add 2 3] ++ fin 8
  | .MSUB => [rget 0 rn, rget 1 rm, rget 2 ra, .bin 3 .mul 0 1, .bin res .sub 2 3] ++ fin 8
  | .SMADDL =>
    [rget 0 rn, rget 1 rm, rget 2 ra, .un 3 (.sext 32) 0, .un 4 (.sext 32) 1, .bin 5 .mul 3 4,
      .bin res .add 2 5] ++ fin 8
  | .SMSUBL =>
    [rget 0 rn, rget 1 rm, rget 2 ra, .un 3 (.sext 32) 0, .un 4 (.sext 32) 1, .bin 5 .mul 3 4,
      .bin res .sub 2 5] ++ fin 8
  | .UMADDL =>
    [rget 0 rn, rget 1 rm, rget 2 ra, .un 3 (.zext 32) 0, .un 4 (.zext 32) 1, .bin 5 .mul 3 4,
      .bin res .add 2 5] ++ fin 8
  | .UMSUBL =>
    [rget 0 rn, rget 1 rm, rget 2 ra, .un 3 (.zext 32) 0, .un 4 (.zext 32) 1, .bin 5 .mul 3 4,
      .bin res .sub 2 5] ++ fin 8
  | .SMULH => [rget 0 rn, rget 1 rm, .bin res .mulhs 0 1] ++ fin 8
  | .UMULH => [rget 0 rn, rget 1 rm, .bin res .mulhu 0 1] ++ fin 8

/-- A byte reversal of the register read at width `w` into `0`, into `9`. `none` for the
operations outside the lowering: `RBIT`, `CLZ`, `CLS`. -/
def dp1Ops (w : RegWidth) (op : DataProc1Op) : Option (List Op) :=
  let rev16 : List Op :=
    [.const 1 0xff00ff00ff00ff00#64, .bin 2 .and 0 1, .const 3 8, .bin 4 .lshr 2 3,
      .const 5 0x00ff00ff00ff00ff#64, .bin 6 .and 0 5, .bin 7 .shl 6 3, .bin 9 .or 4 7]
  match op, w with
  | .REV, .W64 => some [.un 9 .bswap 0]
  | .REV, .W32 => some [.un 1 .bswap 0, .const 2 32, .bin 9 .lshr 1 2]
  | .REV32, .W64 => some [.un 1 .bswap 0, .const 2 32, .bin 9 .rotr 1 2]
  | .REV32, .W32 => some [.un 1 .bswap 0, .const 2 32, .bin 9 .lshr 1 2]
  | .REV16, _ => some rev16
  | _, _ => none

/-- The two operands of an `EXTR` put together, into `9`. -/
def extrOps (w : RegWidth) (rn rm : Arm64.Reg) (lsb : Nat) : List Op :=
  match w with
  | .W64 =>
    if lsb % 64 = 0 then [rget 9 rm]
    else [rget 0 rn, rget 1 rm, .const 2 (BitVec.ofNat 64 (lsb % 64)), .bin 3 .lshr 1 2,
      .const 4 (BitVec.ofNat 64 (64 - lsb % 64)), .bin 5 .shl 0 4, .bin 9 .or 3 5]
  | .W32 =>
    if lsb % 32 = 0 then [rget 0 rm, .un 9 (.zext 32) 0]
    else [rget 0 rn, rget 1 rm, .un 2 (.zext 32) 1, .const 3 (BitVec.ofNat 64 (lsb % 32)),
      .bin 4 .lshr 2 3, .const 5 (BitVec.ofNat 64 (32 - lsb % 32)), .bin 6 .shl 0 5,
      .bin 7 .or 4 6, .un 9 (.zext 32) 7]

/-- An addition or subtraction with carry of `0` and `2`, with the carry flag in `4`: the
result in `5`, and the flags written if the operation sets them. A subtraction adds the
complement. -/
def adcOps (w : RegWidth) (op : AddSubOp) : List Op :=
  let inv : List Op × Var :=
    match op, w with
    | .ADD, _ | .ADDS, _ => ([], 2)
    | _, .W64 => ([.un 10 .not 2], 10)
    | _, .W32 => ([.const 11 0xffffffff#64, .bin 10 .xor 2 11], 10)
  let y := inv.2
  let core : List Op :=
    match w with
    | .W64 => [.bin 12 .add 0 y, .bin 5 .add 12 4]
    | .W32 => [.bin 12 .add 0 y, .bin 13 .add 12 4, .un 5 (.zext 32) 13]
  let flags : List Op :=
    match w with
    | .W64 =>
      [.const 14 0, .bin 6 .slt 5 14, .bin 7 .eq 5 14, .bin 15 .ult 12 0, .bin 16 .ult 5 12,
        .bin 8 .or 15 16, .bin 17 .xor 0 5, .bin 18 .xor y 5, .bin 19 .and 17 18,
        .bin 9 .slt 19 14]
    | .W32 =>
      [.const 14 0, .un 15 (.sext 32) 5, .bin 6 .slt 15 14, .bin 7 .eq 5 14, .bin 8 .ne 5 13,
        .bin 16 .xor 0 5, .bin 17 .xor y 5, .bin 18 .and 16 17, .un 19 (.sext 32) 18,
        .bin 9 .slt 19 14]
  inv.1 ++ core ++ if op.setsFlags then flags ++ setNZCV 6 7 8 9 else []

/-- A bitfield move, into `20`. The cases are the model's: a shift right, an arithmetic
shift right, a shift left, a field taken from `immr` up, and a field put at `N - immr`. A
signed move fills the bits above the field with its top bit, and `BFM` keeps the bits of the
destination outside the field. -/
def bfOps (w : RegWidth) (op : BitfieldOp) (rd rn : Arm64.Reg) (immr imms : Nat) : List Op :=
  let N : Nat := match w with | .W32 => 32 | .W64 => 64
  let r := immr % N
  let s := imms % N
  let fin : List Op := match w with | .W32 => [.un 20 (.zext 32) 19] | .W64 => []
  let res : Var := match w with | .W32 => 19 | .W64 => 20
  let sign : List Op :=
    [.const 7 (BitVec.ofNat 64 s), .bin 8 .lshr 0 7, .const 9 1, .bin 10 .and 8 9, .un 11 .neg 10]
  if op = .UBFM ∧ s + 1 = N then
    rgetW 0 w rn ++ [.const 3 (BitVec.ofNat 64 r), .bin 20 .lshr 0 3]
  else if op = .SBFM ∧ s + 1 = N then
    match w with
    | .W64 => [rget 0 rn, .const 3 (BitVec.ofNat 64 r), .bin 20 .ashr 0 3]
    | .W32 =>
      [rget 0 rn, .un 1 (.sext 32) 0, .const 3 (BitVec.ofNat 64 r), .bin 4 .ashr 1 3,
        .un 20 (.zext 32) 4]
  else if op = .UBFM ∧ r > s ∧ s + 1 = r then
    [rget 0 rn, .const 3 (BitVec.ofNat 64 (N - r)), .bin res .shl 0 3] ++ fin
  else if s ≥ r then
    let mask : Word := BitVec.ofNat 64 (Nat.shiftLeft 1 (s - r + 1) - 1)
    match op with
    | .UBFM =>
      rgetW 0 w rn ++ [.const 3 (BitVec.ofNat 64 r), .bin 4 .lshr 0 3, .const 5 mask,
        .bin res .and 4 5] ++ fin
    | .SBFM =>
      rgetW 0 w rn ++ [.const 3 (BitVec.ofNat 64 r), .bin 4 .lshr 0 3, .const 5 mask,
        .bin 6 .and 4 5] ++ sign ++ [.const 12 (~~~mask), .bin 13 .and 11 12,
        .bin res .or 6 13] ++ fin
    | .BFM =>
      rgetW 0 w rn ++ rgetW 14 w rd ++ [.const 3 (BitVec.ofNat 64 r), .bin 4 .lshr 0 3,
        .const 5 mask, .bin 6 .and 4 5, .const 12 (~~~mask), .bin 13 .and 14 12,
        .bin res .or 13 6] ++ fin
  else
    let lowMask : Word := BitVec.ofNat 64 (Nat.shiftLeft 1 (s + 1) - 1)
    let pos : Nat := N - r
    match op with
    | .UBFM =>
      rgetW 0 w rn ++ [.const 3 lowMask, .bin 4 .and 0 3, .const 5 (BitVec.ofNat 64 pos),
        .bin res .shl 4 5] ++ fin
    | .SBFM =>
      rgetW 0 w rn ++ [.const 3 lowMask, .bin 4 .and 0 3, .const 5 (BitVec.ofNat 64 pos),
        .bin 6 .shl 4 5] ++ sign ++
        [.const 12 (if pos + (s + 1) ≥ 64 then 0#64
            else ~~~(BitVec.ofNat 64 (Nat.shiftLeft 1 (pos + (s + 1)) - 1))),
          .bin 13 .and 11 12, .bin res .or 6 13] ++ fin
    | .BFM =>
      rgetW 0 w rn ++ rgetW 14 w rd ++ [.const 3 lowMask, .bin 4 .and 0 3,
        .const 5 (BitVec.ofNat 64 pos), .bin 6 .shl 4 5, .const 12 (~~~(lowMask <<< pos)),
        .bin 13 .and 14 12, .bin res .or 13 6] ++ fin

/-- A conditional compare: the flags of the comparison of `5` and `7` if the condition in
`0` holds, and the flags `nzcv` otherwise. -/
def ccmpOps (w : RegWidth) (isSub : Bool) (nzcv : BitVec 4) : List Op :=
  flagOps 9 w isSub 5 7 ++
    [.const 21 (ofBool (nzcv.getLsbD 3)), .const 22 (ofBool (nzcv.getLsbD 2)),
      .const 23 (ofBool (nzcv.getLsbD 1)), .const 24 (ofBool (nzcv.getLsbD 0)),
      .select 25 0 10 21, .select 26 0 11 22, .select 27 0 12 23, .select 28 0 13 24,
      .setf 0 25, .setf 1 26, .setf 2 27, .setf 3 28]

/-! ## Vector registers -/

/-- The `braid` register that holds bits 0 to 63 of the vector register `V k`. -/
def vregLo (k : Arm64.VReg) : Reg := 64 + 2 * k.toNat

/-- The `braid` register that holds bits 64 to 127 of the vector register `V k`. -/
def vregHi (k : Arm64.VReg) : Reg := 65 + 2 * k.toNat

/-- Read a vector register: its low half into `d` and its high half into `d + 1`. -/
def vget (d : Var) (k : Arm64.VReg) : List Op := [.get d (vregLo k), .get (d + 1) (vregHi k)]

/-- Write a vector register: its low half from `lo` and its high half from `hi`. -/
def vset (k : Arm64.VReg) (lo hi : Var) : List Op := [.set (vregLo k) lo, .set (vregHi k) hi]

/-- The width of the one access that loads or stores a vector register at a size of at most
eight bytes, and of each of the two accesses at sixteen. -/
def simdMemW : SimdMemSize → MemWidth
  | .B8 => .B8
  | .H16 => .H16
  | .S32 => .W32
  | .D64 => .X64
  | .Q128 => .X64

/-- The number of bytes of a vector register a load or store of size `sz` covers. -/
def simdBytes : SimdMemSize → Word
  | .B8 => 1#64
  | .H16 => 2#64
  | .S32 => 4#64
  | .D64 => 8#64
  | .Q128 => 16#64

/-- A load of size `sz` from the address in `a`, as a vector register gets it: the low half
in `d` and the high half in `d + 1`. A load of less than sixteen bytes clears the rest of the
register. Uses `d + 2` and `d + 3`. -/
def vloadOps (d a : Var) : SimdMemSize → List Op
  | .B8 => [.load d .w8 a, .const (d + 1) 0]
  | .H16 => [.load d .w16 a, .const (d + 1) 0]
  | .S32 => [.load d .w32 a, .const (d + 1) 0]
  | .D64 => [.load d .w64 a, .const (d + 1) 0]
  | .Q128 =>
    [.load d .w64 a, .const (d + 2) 8, .bin (d + 3) .add a (d + 2), .load (d + 1) .w64 (d + 3)]

/-- A store of size `sz` to the address in `a`, of the vector register whose halves are in
`lo` and `hi`. Uses `t` and `t + 1`. -/
def vstoreOps (a lo hi t : Var) : SimdMemSize → List Op
  | .B8 => [.store .w8 a lo]
  | .H16 => [.store .w16 a lo]
  | .S32 => [.store .w32 a lo]
  | .D64 => [.store .w64 a lo]
  | .Q128 => [.store .w64 a lo, .const t 8, .bin (t + 1) .add a t, .store .w64 (t + 1) hi]

/-- A load of a vector register: `LDR` and `LDUR` of `B`, `H`, `S`, `D` or `Q`. -/
def lowerLdrSimd (pc : Word) (sz : SimdMemSize) (vt : Arm64.VReg) (addr : AddrMode) : Block :=
  ⟨addrOps 0 addr ++ vloadOps 30 0 sz ++ vset vt 30 31, .jump (pc + 4)⟩

/-- A store of a vector register: `STR` and `STUR` of `B`, `H`, `S`, `D` or `Q`. -/
def lowerStrSimd (pc : Word) (sz : SimdMemSize) (vt : Arm64.VReg) (addr : AddrMode) : Block :=
  ⟨vget 0 vt ++ addrOps 2 addr ++ vstoreOps 2 0 1 30 sz, .jump (pc + 4)⟩

/-- A load of a pair of vector registers: `LDP` of `S`, `D` or `Q`. -/
def lowerLdpSimd (pc : Word) (sz : SimdMemSize) (vt1 vt2 : Arm64.VReg) (addr : AddrMode) :
    Block :=
  ⟨addrOps 0 addr ++ [.const 21 (simdBytes sz), .bin 22 .add 0 21] ++ vloadOps 23 0 sz ++
      vloadOps 27 22 sz ++ vset vt1 23 24 ++ vset vt2 27 28,
    .jump (pc + 4)⟩

/-- A store of a pair of vector registers: `STP` of `S`, `D` or `Q`. -/
def lowerStpSimd (pc : Word) (sz : SimdMemSize) (vt1 vt2 : Arm64.VReg) (addr : AddrMode) :
    Block :=
  ⟨vget 0 vt1 ++ vget 2 vt2 ++ addrOps 4 addr ++ [.const 30 (simdBytes sz), .bin 31 .add 4 30] ++
      vstoreOps 4 0 1 32 sz ++ vstoreOps 31 2 3 34 sz,
    .jump (pc + 4)⟩

/-- A move between a general register and a vector register, the `FMOV` that converts
nothing: into `W` or `X` from the low 32 or 64 bits or from the high half, and from `W` or
`X` into the low bits, clearing the rest, or into the high half, keeping the low one. `none`
for the conversions between integers and floating point. -/
def fmovOps (sf : Bool) (ftype rmode : BitVec 2) (opcode : BitVec 3) (rn rd : Arm64.VReg) :
    Option (List Op) :=
  if opcode = 6#3 then
    if sf = false ∧ ftype = 0#2 ∧ rmode = 0#2 then
      some ([.get 0 (vregLo rn), .un 1 (.zext 32) 0] ++ rset (Arm64.Reg.fromZRBits rd) 1)
    else if sf = true ∧ ftype = 1#2 ∧ rmode = 0#2 then
      some (.get 0 (vregLo rn) :: rset (Arm64.Reg.fromZRBits rd) 0)
    else if sf = true ∧ ftype = 2#2 ∧ rmode = 1#2 then
      some (.get 0 (vregHi rn) :: rset (Arm64.Reg.fromZRBits rd) 0)
    else none
  else if opcode = 7#3 then
    if sf = false ∧ ftype = 0#2 ∧ rmode = 0#2 then
      some ([rget 0 (Arm64.Reg.fromZRBits rn), .un 1 (.zext 32) 0, .const 2 0] ++ vset rd 1 2)
    else if sf = true ∧ ftype = 1#2 ∧ rmode = 0#2 then
      some ([rget 0 (Arm64.Reg.fromZRBits rn), .const 1 0] ++ vset rd 0 1)
    else if sf = true ∧ ftype = 2#2 ∧ rmode = 1#2 then
      some [rget 0 (Arm64.Reg.fromZRBits rn), .set (vregHi rd) 0]
    else none
  else none

/-- A move of the low 32 or 64 bits of a vector register into another, clearing the rest:
`FMOV Sd, Sn` and `FMOV Dd, Dn`. `none` for the arithmetic on floating point. -/
def fpMovOps (ftype : BitVec 2) (opcode : BitVec 6) (rn rd : Arm64.VReg) : Option (List Op) :=
  if opcode = 0#6 then
    if ftype = 0#2 then
      some ([.get 0 (vregLo rn), .un 1 (.zext 32) 0, .const 2 0] ++ vset rd 1 2)
    else if ftype = 1#2 then some ([.get 0 (vregLo rn), .const 1 0] ++ vset rd 0 1)
    else none
  else none

/-- An operation on two vector registers that works the same way on each half: a bitwise
operation, `BSL`, which also reads the destination, or an addition or subtraction of lanes
of `n` bits. -/
inductive VecOp where
  | and | bic | orr | orn | eor | bsl
  | add (n : Nat)
  | sub (n : Nat)
  deriving DecidableEq, Repr, Inhabited

/-- The value of an operation on one half: of `x` and `y`, and the destination `z`. -/
def VecOp.eval : VecOp → Word → Word → Word → Word
  | .and, x, y, _ => x &&& y
  | .bic, x, y, _ => x &&& ~~~y
  | .orr, x, y, _ => x ||| y
  | .orn, x, y, _ => x ||| ~~~y
  | .eor, x, y, _ => x ^^^ y
  | .bsl, x, y, z => ((x ^^^ y) &&& z) ^^^ y
  | .add n, x, y, _ => (BinOp.lanes n .add).eval x y
  | .sub n, x, y, _ => (BinOp.lanes n .sub).eval x y

/-- The operations of one half, of `x`, `y` and the destination `z`, into `d`. Uses `d + 1`
and `d + 2`. -/
def VecOp.ops : VecOp → (d x y z : Var) → List Op
  | .and, d, x, y, _ => [.bin d .and x y]
  | .bic, d, x, y, _ => [.un (d + 1) .not y, .bin d .and x (d + 1)]
  | .orr, d, x, y, _ => [.bin d .or x y]
  | .orn, d, x, y, _ => [.un (d + 1) .not y, .bin d .or x (d + 1)]
  | .eor, d, x, y, _ => [.bin d .xor x y]
  | .bsl, d, x, y, z => [.bin (d + 1) .xor x y, .bin (d + 2) .and (d + 1) z, .bin d .xor (d + 2) y]
  | .add n, d, x, y, _ => [.bin d (.lanes n .add) x y]
  | .sub n, d, x, y, _ => [.bin d (.lanes n .sub) x y]

/-- The operation of a `simdThreeSame` instruction, where it is one the lowering covers:
`AND`, `BIC`, `ORR`, `ORN`, `EOR`, `BSL`, and `ADD` and `SUB` of lanes. -/
def vecOp (q u : Bool) (size : BitVec 2) (opcode : BitVec 5) : Option VecOp :=
  if opcode = 3#5 then
    if u = false then
      if size = 0#2 then some .and else if size = 1#2 then some .bic
      else if size = 2#2 then some .orr else some .orn
    else if size = 0#2 then some .eor else if size = 1#2 then some .bsl else none
  else if size = 3#2 ∧ q = false then none
  else if opcode = 16#5 then
    some (if u then .sub (8 <<< size.toNat) else .add (8 <<< size.toNat))
  else none

/-- An operation on two vector registers, half by half. With `q` clear it works on the low
halves only and clears the high half of the destination. -/
def vecOps (op : VecOp) (q : Bool) (rm rn rd : Arm64.VReg) : List Op :=
  vget 0 rn ++ vget 2 rm ++ (if op = .bsl then vget 4 rd else []) ++ op.ops 10 0 2 4 ++
    (if q then op.ops 20 1 3 5 else [.const 20 0#64]) ++ vset rd 10 20

/-- The 64 bits that a `MOVI` with the 8-bit constant `imm8` repeats: a byte in every byte,
a byte or all ones for each bit, or a shifted constant in every 32 or 16 bits. `none` for
the other modified constants. -/
def moviImm (op : Bool) (cmode : BitVec 4) (imm8 : BitVec 8) : Option Word :=
  if op = false ∧ cmode = 14#4 then
    some (imm8 ++ imm8 ++ imm8 ++ imm8 ++ imm8 ++ imm8 ++ imm8 ++ imm8)
  else if op = true ∧ cmode = 14#4 then
    let b (i : Nat) : BitVec 8 := if imm8.getLsbD i then 0xff#8 else 0x00#8
    some (b 7 ++ b 6 ++ b 5 ++ b 4 ++ b 3 ++ b 2 ++ b 1 ++ b 0)
  else if op = false ∧ cmode &&& 9#4 = 0#4 then
    let w32 : BitVec 32 := (imm8.zeroExtend 32) <<< ((cmode.extractLsb' 1 2).toNat * 8)
    some (w32 ++ w32)
  else if op = false ∧ cmode &&& 13#4 = 8#4 then
    let h16 : BitVec 16 := (imm8.zeroExtend 16) <<< ((cmode.extractLsb' 1 1).toNat * 8)
    some (h16 ++ h16 ++ h16 ++ h16)
  else none

/-- An `FMOV` of a floating-point constant into the low 32 or 64 bits of a vector register,
clearing the rest. The constant is the model's expansion of `imm8`. `none` for half
precision. -/
def fpImmOps (ftype : BitVec 2) (imm8 : BitVec 8) (rd : Arm64.VReg) : Option (List Op) :=
  if ftype = 0#2 then
    some ([.const 0 ((Arm64.vfpExpandImm32 imm8).zeroExtend 64), .const 1 0#64] ++ vset rd 0 1)
  else if ftype = 1#2 then
    some ([.const 0 (Arm64.vfpExpandImm64 imm8), .const 1 0#64] ++ vset rd 0 1)
  else none

/-- `FCSEL`: the low 32 or 64 bits of `rn` if the condition holds and of `rm` otherwise,
with the rest of the destination clear. `none` for half precision. -/
def fcselOps (ftype : BitVec 2) (rm : Arm64.VReg) (cond : BitVec 4) (rn rd : Arm64.VReg) :
    Option (List Op) :=
  if ftype = 0#2 then
    some (condOps 0 (CondCode.ofBits cond) ++ [.get 5 (vregLo rn), .get 6 (vregLo rm),
      .select 7 0 5 6, .un 8 (.zext 32) 7, .const 9 0#64] ++ vset rd 8 9)
  else if ftype = 1#2 then
    some (condOps 0 (CondCode.ofBits cond) ++ [.get 5 (vregLo rn), .get 6 (vregLo rm),
      .select 7 0 5 6, .const 9 0#64] ++ vset rd 7 9)
  else none

/-- `NOT` (`MVN`) of a vector register, on both halves or on the low one with the high one
clear. `none` for the other `simdTwoRegMisc` instructions. -/
def notOps (q u : Bool) (size : BitVec 2) (opcode : BitVec 5) (rn rd : Arm64.VReg) :
    Option (List Op) :=
  if u = true ∧ opcode = 5#5 ∧ size = 0#2 then
    some ([.get 0 (vregLo rn), .un 1 .not 0] ++
      (if q then [.get 2 (vregHi rn), .un 3 .not 2] else [.const 3 0#64]) ++ vset rd 1 3)
  else none

/-- The block of the instruction `i` at address `pc`. -/
def lower (pc : Word) (i : Instr) : Block :=
  match i with
  | .nop => ⟨[], .jump (pc + 4)⟩
  | .hint _ => ⟨[], .jump (pc + 4)⟩
  | .barrier _ _ => ⟨[], .jump (pc + 4)⟩
  | .prfm _ _ => ⟨[], .jump (pc + 4)⟩
  | .prfmLit _ _ => ⟨[], .jump (pc + 4)⟩
  | .adr page rd offset =>
    ⟨.const 0 ((if page then pc &&& 0xfffffffffffff000#64 else pc) + offset) :: rset rd 0,
      .jump (pc + 4)⟩
  | .addSubImm w op rd rn imm12 shift12 =>
    ⟨rgetW 0 w rn ++
        [.const 2 (if shift12 then imm12.zeroExtend 64 <<< 12 else imm12.zeroExtend 64)] ++
        addSubOps 3 w op 0 2 ++ rset rd 3,
      .jump (pc + 4)⟩
  | .addSubShift w op rd rn rm shift amount =>
    ⟨rgetW 0 w rn ++ chain 2 (rget · rm) (shiftStages w shift amount) ++
        addSubOps 12 w op 0 2 ++ rset rd 12,
      .jump (pc + 4)⟩
  | .logicalImm w op rd rn mask =>
    ⟨rgetW 0 w rn ++ [.const 2 (norm w mask)] ++ logicOps 3 w op 0 2 ++ rset rd 3,
      .jump (pc + 4)⟩
  | .logicalShift w op rd rn rm shift amount =>
    ⟨rgetW 0 w rn ++ chain 2 (rget · rm) (shiftStages w shift amount) ++
        logicOps 12 w op 0 2 ++ rset rd 12,
      .jump (pc + 4)⟩
  | .moveWide w op rd imm16 hw =>
    let shifted : Word := imm16.zeroExtend 64 <<< hw
    match op with
    | .MOVZ => ⟨.const 0 (norm w shifted) :: rset rd 0, .jump (pc + 4)⟩
    | .MOVN => ⟨.const 0 (norm w (~~~shifted)) :: rset rd 0, .jump (pc + 4)⟩
    | .MOVK =>
      ⟨rgetW 0 w rd ++ [.const 2 (norm w (~~~(0xffff#64 <<< hw))), .bin 3 .and 0 2,
          .const 4 (norm w shifted), .bin 5 .or 3 4] ++ rset rd 5,
        .jump (pc + 4)⟩
  | .b offset => ⟨[], .jump (pc + offset)⟩
  | .bl offset => ⟨.const 0 (pc + 4) :: rset Arm64.Reg.lr 0, .jump (pc + offset)⟩
  | .bCond cond offset => ⟨condOps 0 cond, .branch 0 (pc + offset) (pc + 4)⟩
  | .cbz w isNonZero rt offset =>
    ⟨rgetW 0 w rt,
      if isNonZero then .branch 0 (pc + offset) (pc + 4) else .branch 0 (pc + 4) (pc + offset)⟩
  | .br rn => ⟨[rget 0 rn], .jumpInd 0⟩
  | .ret rn => ⟨[rget 0 rn], .jumpInd 0⟩
  | .blr rn => ⟨rget 0 rn :: .const 1 (pc + 4) :: rset Arm64.Reg.lr 1, .jumpInd 0⟩
  | .ldr w sz signed rt addr =>
    ⟨addrOps 0 addr ++ chain 30 (.load · (memW sz) 0) (loadStages w sz signed) ++ rset rt 30,
      .jump (pc + 4)⟩
  | .str sz rt addr =>
    ⟨rget 0 rt :: (addrOps 1 addr ++ [.store (memW sz) 1 0]), .jump (pc + 4)⟩
  | .bitfield w op rd rn immr imms =>
    ⟨bfOps w op rd rn immr imms ++ rset rd 20, .jump (pc + 4)⟩
  | .extr w rd rn rm lsb => ⟨extrOps w rn rm lsb ++ rset rd 9, .jump (pc + 4)⟩
  | .tbz _ isNonZero rt bit offset =>
    ⟨[rget 0 rt, .const 1 (BitVec.twoPow 64 bit), .bin 2 .and 0 1],
      if isNonZero then .branch 2 (pc + offset) (pc + 4) else .branch 2 (pc + 4) (pc + offset)⟩
  | .sysReg .. => ⟨[], .trap "sysReg"⟩
  | .dcZva .. => ⟨[], .trap "dcZva"⟩
  | .system .. => ⟨[], .trap "system"⟩
  | .udf .. => ⟨[], .trap "udf"⟩
  | .addSubExt w op rd rn rm ext amount =>
    ⟨rgetW 0 w rn ++ chain 2 (rget · rm) (extStages w ext amount) ++
        addSubOps 12 w op 0 2 ++ rset rd 12,
      .jump (pc + 4)⟩
  | .addSubCarry w op rd rn rm =>
    ⟨rgetW 0 w rn ++ rgetW 2 w rm ++ [.getf 4 2] ++ adcOps w op ++ rset rd 5, .jump (pc + 4)⟩
  | .condCompareReg w isSub rn rm nzcv cond =>
    ⟨condOps 0 cond ++ rgetW 5 w rn ++ rgetW 7 w rm ++ ccmpOps w isSub nzcv, .jump (pc + 4)⟩
  | .condCompareImm w isSub rn imm5 nzcv cond =>
    ⟨condOps 0 cond ++ rgetW 5 w rn ++ [.const 7 (imm5.zeroExtend 64)] ++ ccmpOps w isSub nzcv,
      .jump (pc + 4)⟩
  | .condSelect w op rd rn rm cond =>
    ⟨condOps 0 cond ++ rgetW 5 w rn ++ chain 7 (rget · rm) (cselStages w op) ++
        [.select 12 0 5 7] ++ rset rd 12,
      .jump (pc + 4)⟩
  | .dataProc1 w op rd rn =>
    match dp1Ops w op with
    | some ops => ⟨rgetW 0 w rn ++ ops ++ rset rd 9, .jump (pc + 4)⟩
    | none => ⟨[], .trap "dataProc1"⟩
  | .dataProc2 w op rd rn rm =>
    ⟨rget 0 rn :: rget 1 rm :: (dp2Ops w op ++ rset rd 9), .jump (pc + 4)⟩
  | .dataProc3 w op rd rn rm ra => ⟨dp3Ops w op rn rm ra ++ rset rd 9, .jump (pc + 4)⟩
  | .crc32 .. => ⟨[], .trap "crc32"⟩
  | .ldrLit w signed rt offset =>
    let sz : MemWidth := if signed then .W32 else regMemW w
    ⟨.const 0 (pc + offset) :: (chain 1 (.load · (memW sz) 0) (loadStages w sz signed) ++
        rset rt 1),
      .jump (pc + 4)⟩
  | .ldp w signed rt1 rt2 addr => lowerLdp pc w signed rt1 rt2 addr
  | .stp w rt1 rt2 addr => lowerStp pc w rt1 rt2 addr
  | .ldnp sz rn rt rt2 offset =>
    lowerLdp pc (match sz with | .X64 => .W64 | _ => .W32) false rt rt2 (.Offset rn offset)
  | .stnp sz rn rt rt2 offset =>
    lowerStp pc (match sz with | .X64 => .W64 | _ => .W32) rt rt2 (.Offset rn offset)
  | .ldarStlr .. => ⟨[], .trap "ldarStlr"⟩
  | .ldxr .. => ⟨[], .trap "ldxr"⟩
  | .stxr .. => ⟨[], .trap "stxr"⟩
  | .ldxp .. => ⟨[], .trap "ldxp"⟩
  | .stxp .. => ⟨[], .trap "stxp"⟩
  | .cas .. => ⟨[], .trap "cas"⟩
  | .casp .. => ⟨[], .trap "casp"⟩
  | .atomicRmw .. => ⟨[], .trap "atomicRmw"⟩
  | .ldapr .. => ⟨[], .trap "ldapr"⟩
  | .ldapurStlur .. => ⟨[], .trap "ldapurStlur"⟩
  | .ldrSimd sz vt addr => lowerLdrSimd pc sz vt addr
  | .strSimd sz vt addr => lowerStrSimd pc sz vt addr
  | .ldrSimdLit .. => ⟨[], .trap "ldrSimdLit"⟩
  | .ldpSimd sz vt1 vt2 addr => lowerLdpSimd pc sz vt1 vt2 addr
  | .stpSimd sz vt1 vt2 addr => lowerStpSimd pc sz vt1 vt2 addr
  | .ldnpSimd sz vt1 vt2 rn offset => lowerLdpSimd pc sz vt1 vt2 (.Offset rn offset)
  | .stnpSimd sz vt1 vt2 rn offset => lowerStpSimd pc sz vt1 vt2 (.Offset rn offset)
  | .st1SinglePost .. => ⟨[], .trap "st1SinglePost"⟩
  | .simdLdSt1Single .. => ⟨[], .trap "simdLdSt1Single"⟩
  | .simdLdSt1Multi .. => ⟨[], .trap "simdLdSt1Multi"⟩
  | .simdLdStMulti .. => ⟨[], .trap "simdLdStMulti"⟩
  | .simdLd1r .. => ⟨[], .trap "simdLd1r"⟩
  | .fmovGprVec sf ftype rmode opcode rn rd =>
    match fmovOps sf ftype rmode opcode rn rd with
    | some ops => ⟨ops, .jump (pc + 4)⟩
    | none => ⟨[], .trap "fmovGprVec"⟩
  | .fpDataProc1 ftype opcode rn rd =>
    match fpMovOps ftype opcode rn rd with
    | some ops => ⟨ops, .jump (pc + 4)⟩
    | none => ⟨[], .trap "fpDataProc1"⟩
  | .fpDataProc2 .. => ⟨[], .trap "fpDataProc2"⟩
  | .fpCompare .. => ⟨[], .trap "fpCompare"⟩
  | .fpImm ftype imm8 rd =>
    match fpImmOps ftype imm8 rd with
    | some ops => ⟨ops, .jump (pc + 4)⟩
    | none => ⟨[], .trap "fpImm"⟩
  | .fpCondCompare .. => ⟨[], .trap "fpCondCompare"⟩
  | .fpCondSelect ftype rm cond rn rd =>
    match fcselOps ftype rm cond rn rd with
    | some ops => ⟨ops, .jump (pc + 4)⟩
    | none => ⟨[], .trap "fpCondSelect"⟩
  | .fpDataProc3 .. => ⟨[], .trap "fpDataProc3"⟩
  | .fpFixedConv .. => ⟨[], .trap "fpFixedConv"⟩
  | .simdImmShift q op immh immb opc rn rd =>
    match if immh = 0#4 ∧ opc.getLsbD 0 = false then
        moviImm op (opc.extractLsb' 1 4) (immb ++ rn) else none with
    | some d64 => ⟨[.const 0 d64, .const 1 (if q then d64 else 0#64)] ++ vset rd 0 1, .jump (pc + 4)⟩
    | none => ⟨[], .trap "simdImmShift"⟩
  | .simdInsDup .. => ⟨[], .trap "simdInsDup"⟩
  | .simdThreeSame q u size rm opcode rn rd =>
    match vecOp q u size opcode with
    | some op => ⟨vecOps op q rm rn rd, .jump (pc + 4)⟩
    | none => ⟨[], .trap "simdThreeSame"⟩
  | .simdTwoRegMisc q u size opcode rn rd =>
    match notOps q u size opcode rn rd with
    | some ops => ⟨ops, .jump (pc + 4)⟩
    | none => ⟨[], .trap "simdTwoRegMisc"⟩
  | .simdAcrossLanes .. => ⟨[], .trap "simdAcrossLanes"⟩
  | .simdPermute .. => ⟨[], .trap "simdPermute"⟩
  | .simdExt .. => ⟨[], .trap "simdExt"⟩
  | .simdTbl .. => ⟨[], .trap "simdTbl"⟩
  | .simdAddpScalar rn rd =>
    ⟨[.get 0 (vregLo rn), .get 1 (vregHi rn), .bin 2 .add 0 1, .const 3 0#64] ++ vset rd 2 3,
      .jump (pc + 4)⟩
  | .simdDupScalar .. => ⟨[], .trap "simdDupScalar"⟩
  | .simdPmull .. => ⟨[], .trap "simdPmull"⟩
  | .simdThreeDiff .. => ⟨[], .trap "simdThreeDiff"⟩
  | .aes .. => ⟨[], .trap "aes"⟩
  | .cryptoSha2Reg .. => ⟨[], .trap "cryptoSha2Reg"⟩
  | .cryptoSha3Reg .. => ⟨[], .trap "cryptoSha3Reg"⟩
  | .cryptoSha512Reg2 .. => ⟨[], .trap "cryptoSha512Reg2"⟩
  | .cryptoSha512Reg3 .. => ⟨[], .trap "cryptoSha512Reg3"⟩
  | .cryptoSha3FourReg .. => ⟨[], .trap "cryptoSha3FourReg"⟩
  | .cryptoXar .. => ⟨[], .trap "cryptoXar"⟩

/-- The program of a code image: the block of the instruction at each address. -/
def lowerProgram (prog : Arm64.Program) : Program :=
  fun a => (prog.fetch a).map (lower a)

end Lowering.Arm
