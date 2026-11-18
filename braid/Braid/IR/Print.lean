/-
  Braid.IR.Print

  The textual forms of a module: MLIR's generic operation syntax, which `mlir-opt` and other
  MLIR tools read, and a Lean term, which a proof imports.

  In the MLIR form a function is a `braid.func` operation holding one region. Each block is
  labelled with its offset from the function's entry, and SSA values are named after their
  block, so a change to one instruction changes the text of its block alone.

  ## Main definitions

  * `Module.toMlir`: the module in MLIR's generic syntax
  * `Module.toLean`: the module as a Lean definition
-/

module

public import Braid.IR.Syntax

@[expose] public section

namespace Braid

/-- A natural number in hexadecimal, without a prefix. -/
def hex (n : Nat) : String := String.ofList (Nat.toDigits 16 n)

def UnOp.name : UnOp → String
  | .not => "not" | .neg => "neg" | .sext _ => "sext" | .zext _ => "zext" | .clz => "clz"
  | .popcnt => "popcnt" | .rbit => "rbit" | .bswap => "bswap"

def BinOp.name : BinOp → String
  | .add => "add" | .sub => "sub" | .mul => "mul" | .mulhu => "mulhu" | .mulhs => "mulhs"
  | .mulhsu => "mulhsu" | .udiv => "udiv" | .urem => "urem" | .sdiv => "sdiv" | .srem => "srem"
  | .and => "and" | .or => "or" | .xor => "xor" | .shl => "shl" | .lshr => "lshr"
  | .ashr => "ashr" | .rotr => "rotr" | .eq => "eq" | .ne => "ne" | .ult => "ult"
  | .ule => "ule" | .slt => "slt" | .sle => "sle"

/-! ## MLIR -/

namespace Mlir

/-- The label of the block at `a` in the function entered at `entry`. -/
def label (entry a : Word) : String :=
  if a.toNat ≥ entry.toNat then s!"^bb{hex (a.toNat - entry.toNat)}"
  else s!"^bbm{hex (entry.toNat - a.toNat)}"

/-- The label of the block standing for a jump out of the function to `a`. -/
def extLabel (a : Word) : String := s!"^ext{hex a.toNat}"

/-- The name of SSA value `x` of the block labelled `l`. -/
def val (l : String) (x : Var) : String := s!"%{l.drop 1}_{x}"

def op (arch : Arch) (l : String) : Op → String
  | .const d v => s!"{val l d} = \"braid.const\"() \{value = {v.toInt} : i64} : () -> i64"
  | .un d (.sext n) a =>
    s!"{val l d} = \"braid.sext\"({val l a}) \{bits = {n} : i64} : (i64) -> i64"
  | .un d (.zext n) a =>
    s!"{val l d} = \"braid.zext\"({val l a}) \{bits = {n} : i64} : (i64) -> i64"
  | .un d o a => s!"{val l d} = \"braid.{o.name}\"({val l a}) : (i64) -> i64"
  | .bin d o a b => s!"{val l d} = \"braid.{o.name}\"({val l a}, {val l b}) : (i64, i64) -> i64"
  | .select d c a b =>
    s!"{val l d} = \"braid.select\"({val l c}, {val l a}, {val l b}) : (i64, i64, i64) -> i64"
  | .get d r => s!"{val l d} = \"braid.get\"() \{reg = \"{arch.regName r}\"} : () -> i64"
  | .set r a => s!"\"braid.set\"({val l a}) \{reg = \"{arch.regName r}\"} : (i64) -> ()"
  | .getf d f => s!"{val l d} = \"braid.getf\"() \{flag = \"{arch.flagName f}\"} : () -> i64"
  | .setf f a => s!"\"braid.setf\"({val l a}) \{flag = \"{arch.flagName f}\"} : (i64) -> ()"
  | .load d w a =>
    s!"{val l d} = \"braid.load\"({val l a}) \{bytes = {w.bytes} : i64} : (i64) -> i64"
  | .store w a v =>
    s!"\"braid.store\"({val l a}, {val l v}) \{bytes = {w.bytes} : i64} : (i64, i64) -> ()"
  | .havoc d => s!"{val l d} = \"braid.havoc\"() : () -> i64"
  | .guard c => s!"\"braid.guard\"({val l c}) : (i64) -> ()"

/-- The label a jump to `a` uses: the block itself if the function has it, and a block
standing for the jump out otherwise. -/
def target (f : Func) (a : Word) : String :=
  if f.blocks.any (·.1 == a) then label f.entry a else extLabel a

def term (f : Func) (l : String) : Term → String
  | .jump a => s!"\"braid.br\"()[{target f a}] : () -> ()"
  | .branch c t e => s!"\"braid.cond_br\"({val l c})[{target f t}, {target f e}] : (i64) -> ()"
  | .jumpInd a => s!"\"braid.br_ind\"({val l a}) : (i64) -> ()"
  | .trap r => s!"\"braid.trap\"() \{reason = {repr r}} : () -> ()"

/-- The addresses a terminator may jump to. -/
def targets : Term → List Word
  | .jump a => [a]
  | .branch _ t e => [t, e]
  | _ => []

def block (arch : Arch) (f : Func) (ab : Word × Block) : String :=
  let l := label f.entry ab.1
  let lines := ab.2.ops.map (op arch l) ++ [term f l ab.2.term]
  s!"    {l}:  // 0x{hex ab.1.toNat}\n" ++ String.join (lines.map fun s => s!"      {s}\n")

def func (arch : Arch) (f : Func) : String :=
  let exts := ((f.blocks.flatMap fun ab => targets ab.2.term).filter fun a =>
    !f.blocks.any (·.1 == a)).eraseDups
  let extBlocks := exts.map fun a =>
    s!"    {extLabel a}:\n      \"braid.tail\"() \{target = {a.toNat} : i64} : () -> ()\n"
  s!"  \"braid.func\"() (\{\n      \"braid.br\"()[{target f f.entry}] : () -> ()\n" ++
    String.join (f.blocks.map (block arch f)) ++ String.join extBlocks ++
    s!"  }) \{sym_name = {repr f.name}, entry = {f.entry.toNat} : i64} : () -> ()\n"

end Mlir

/-- The module in MLIR's generic operation syntax. -/
def Module.toMlir (arch : Arch) (m : Module) : String :=
  "\"braid.module\"() ({\n" ++ String.join (m.funcs.map (Mlir.func arch)) ++
    s!"}) \{arch = {repr m.arch}} : () -> ()\n"

/-! ## Lean -/

namespace LeanSrc

def word (w : Word) : String := s!"0x{hex w.toNat}#64"

def width : Width → String
  | .w8 => ".w8" | .w16 => ".w16" | .w32 => ".w32" | .w64 => ".w64"

def unop : UnOp → String
  | .sext n => s!"(.sext {n})"
  | .zext n => s!"(.zext {n})"
  | o => s!".{o.name}"

def op : Op → String
  | .const d v => s!".const {d} {word v}"
  | .un d o a => s!".un {d} {unop o} {a}"
  | .bin d o a b => s!".bin {d} .{o.name} {a} {b}"
  | .select d c a b => s!".select {d} {c} {a} {b}"
  | .get d r => s!".get {d} {r}"
  | .set r a => s!".set {r} {a}"
  | .getf d f => s!".getf {d} {f}"
  | .setf f a => s!".setf {f} {a}"
  | .load d w a => s!".load {d} {width w} {a}"
  | .store w a v => s!".store {width w} {a} {v}"
  | .havoc d => s!".havoc {d}"
  | .guard c => s!".guard {c}"

def term : Term → String
  | .jump a => s!".jump {word a}"
  | .branch c t e => s!".branch {c} {word t} {word e}"
  | .jumpInd a => s!".jumpInd {a}"
  | .trap r => s!".trap {repr r}"

def block (ab : Word × Block) : String :=
  s!"    ({word ab.1}, \{ ops := [{", ".intercalate (ab.2.ops.map op)}], term := {term ab.2.term} })"

def func (f : Func) : String :=
  s!"  \{ name := {repr f.name}, entry := {word f.entry}, blocks := [\n" ++
    ",\n".intercalate (f.blocks.map block) ++ "] }"

end LeanSrc

/-- The function as a Lean term of type `Braid.Func`. -/
def Func.toLean (f : Func) : String := LeanSrc.func f

end Braid
