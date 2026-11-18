/-
  Braid.IR.Syntax

  The syntax of the `braid` dialect: SSA values, operations, terminators, blocks and
  functions. Every value is a 64-bit word. The machine state (registers, flags, memory) is
  read and written by explicit operations, so a block is a list of operations in SSA form
  followed by one terminator, as in MLIR.

  ## Main definitions

  * `Op`, `Term`, `Block`: one block of the dialect
  * `Func`, `Module`: named groups of blocks, keyed by address
  * `Program`: the blocks of a program, by address
-/

module

@[expose] public section

namespace Braid

/-- A machine word. Every SSA value of the dialect is one. -/
abbrev Word := BitVec 64

/-- An SSA value, `%n` in the textual form. -/
abbrev Var := Nat

/-- A machine register. Each instruction set numbers its own (`Arch.regName`). -/
abbrev Reg := Nat

/-- A one-bit machine flag. Each instruction set numbers its own (`Arch.flagName`). -/
abbrev Flag := Nat

/-- The width of a memory access. -/
inductive Width where
  | w8 | w16 | w32 | w64
  deriving DecidableEq, Repr, Inhabited

/-- The number of bytes a memory access of this width covers. -/
@[reducible] def Width.bytes : Width → Nat
  | .w8 => 1 | .w16 => 2 | .w32 => 4 | .w64 => 8

/-- The number of bits a memory access of this width covers. -/
@[reducible] def Width.bits (w : Width) : Nat := 8 * w.bytes

/-- An operation with one operand. -/
inductive UnOp where
  /-- Bitwise complement. -/
  | not
  /-- Two's complement negation. -/
  | neg
  /-- Sign-extend the low `n` bits. -/
  | sext (n : Nat)
  /-- Zero-extend the low `n` bits: clear every bit from `n` up. -/
  | zext (n : Nat)
  /-- The number of leading zero bits. -/
  | clz
  /-- The number of set bits. -/
  | popcnt
  /-- The bits in reverse order. -/
  | rbit
  /-- The bytes in reverse order. -/
  | bswap
  deriving DecidableEq, Repr, Inhabited

/-- An operation with two operands. A comparison gives `1` or `0`. -/
inductive BinOp where
  | add | sub | mul
  /-- The high word of the unsigned 128-bit product. -/
  | mulhu
  /-- The high word of the signed 128-bit product. -/
  | mulhs
  /-- The high word of the 128-bit product of a signed and an unsigned word. -/
  | mulhsu
  /-- Unsigned division; a zero divisor gives zero. -/
  | udiv
  /-- Unsigned remainder; a zero divisor gives the dividend. -/
  | urem
  /-- Signed division, rounding to zero; a zero divisor gives zero. -/
  | sdiv
  /-- Signed remainder, with the sign of the dividend; a zero divisor gives the dividend. -/
  | srem
  | and | or | xor
  /-- Shift left; an amount of 64 or more gives zero. -/
  | shl
  /-- Logical shift right; an amount of 64 or more gives zero. -/
  | lshr
  /-- Arithmetic shift right; an amount of 64 or more gives the sign. -/
  | ashr
  /-- Rotate right, by the amount modulo 64. -/
  | rotr
  | eq | ne | ult | ule | slt | sle
  deriving DecidableEq, Repr, Inhabited

/-- An operation of the dialect. `dst` is the SSA value the operation defines. -/
inductive Op where
  /-- A constant. -/
  | const (dst : Var) (v : Word)
  | un (dst : Var) (op : UnOp) (a : Var)
  | bin (dst : Var) (op : BinOp) (a b : Var)
  /-- `a` if `c` is not zero, and `b` otherwise. -/
  | select (dst : Var) (c a b : Var)
  /-- Read a register. -/
  | get (dst : Var) (r : Reg)
  /-- Write a register. -/
  | set (r : Reg) (a : Var)
  /-- Read a flag, as `1` or `0`. -/
  | getf (dst : Var) (f : Flag)
  /-- Write a flag: set if `a` is not zero. -/
  | setf (f : Flag) (a : Var)
  /-- Read memory, little-endian and zero-extended. Every byte must be mapped. -/
  | load (dst : Var) (w : Width) (addr : Var)
  /-- Write memory, little-endian. Every byte must be mapped and writable. -/
  | store (w : Width) (addr : Var) (val : Var)
  /-- Any word at all: a value the instruction set leaves undefined. -/
  | havoc (dst : Var)
  /-- Execution is defined only if `c` is not zero. -/
  | guard (c : Var)
  deriving DecidableEq, Repr, Inhabited

/-- How a block ends. A target is the address of a block. -/
inductive Term where
  /-- Go to the block at `target`. -/
  | jump (target : Word)
  /-- Go to `t` if `c` is not zero, and to `f` otherwise. -/
  | branch (c : Var) (t f : Word)
  /-- Go to the block at the address held in `a`: a return, or a computed jump or call. -/
  | jumpInd (a : Var)
  /-- Execution is not defined here: an instruction outside the lowering, or a fault. -/
  | trap (reason : String)
  deriving DecidableEq, Repr, Inhabited

/-- A block: operations in order, then a terminator. SSA values are local to the block. -/
structure Block where
  ops : List Op
  term : Term
  deriving DecidableEq, Repr, Inhabited

/-- A program: its blocks, by address. -/
abbrev Program := Word → Option Block

/-- The program holding the blocks of a list, by address. The first block at an address wins. -/
def Program.ofList (bs : List (Word × Block)) : Program :=
  fun a => (bs.find? (·.1 == a)).map (·.2)

/-- The instruction set a function was lowered from: how its registers and flags are named. -/
structure Arch where
  name : String
  regName : Reg → String
  flagName : Flag → String

/-- A function: a name and the blocks lowered from its instructions, in address order. -/
structure Func where
  name : String
  entry : Word
  blocks : List (Word × Block)
  deriving Repr, Inhabited

/-- The program of a function. -/
def Func.program (f : Func) : Program := Program.ofList f.blocks

/-- A module: the functions lowered from one binary. -/
structure Module where
  arch : String
  funcs : List Func
  deriving Repr, Inhabited

/-- The program of a module: every block of every function. -/
def Module.program (m : Module) : Program :=
  Program.ofList (m.funcs.flatMap (·.blocks))

end Braid
