/-
  Tools.RiscV

  The RISC-V front end of the decompiler: decode the words of a function, lower each
  instruction, and print the Lean definitions a proof imports.

  ## Main definitions

  * `decodeFunction`: the instructions of a function, by address
  * `toFunc`: the lowered function
  * `leanSource`: the Lean definitions of a function and its lowering certificate
-/

import Tools.Elf
import Lowering.RiscV.Lower
import RiscvZkvm.Interpreter.Decode

namespace Tools.RiscV

open RiscvZkvm.Rv64

/-- The instructions of a function, by address, and the words that do not decode. -/
def decodeFunction (f : Elf.Function) :
    List (Braid.Word × Instr) × List (Nat × BitVec 32) :=
  (Elf.words32 f.bytes).foldr (init := ([], [])) fun (off, w) (is, bad) =>
    match RiscvZkvm.Interpreter.decode w with
    | some i => ((BitVec.ofNat 64 (f.addr + off), i) :: is, bad)
    | none => (is, (f.addr + off, w) :: bad)

/-- The lowered function. -/
def toFunc (name : String) (entry : Nat) (code : List (Braid.Word × Instr)) : Braid.Func :=
  { name, entry := BitVec.ofNat 64 entry,
    blocks := code.map fun (a, i) => (a, Lowering.RiscV.lower a i) }

/-- A name that is a Lean identifier: every other character becomes `_`. -/
def ident (s : String) : String :=
  String.ofList (s.toList.map fun c => if c.isAlphanum || c == '_' then c else '_')

/-- The Lean definitions of a function: its instructions, its lowering, and the certificate
that the second is the lowering of the first. -/
def leanSource (name : String) (entry : Nat) (code : List (Braid.Word × Instr)) : String :=
  let n := ident name
  let instr (p : Braid.Word × Instr) :=
    s!"  ({Braid.LeanSrc.word p.1}, {(repr p.2).pretty 10000})"
  s!"/-- The instructions of `{name}`, by address. -/\n" ++
  s!"def {n}_code : List (BitVec 64 × Instr) := [\n" ++
    ",\n".intercalate (code.map instr) ++ "]\n\n" ++
  s!"/-- `{name}`, lowered to `braid`. -/\n" ++
  s!"def {n} : Braid.Func :=\n{(toFunc name entry code).toLean}\n\n" ++
  s!"/-- `{n}` is the lowering of `{n}_code`. -/\n" ++
  s!"theorem {n}_lowered :\n    {n}.blocks = {n}_code.map fun p => (p.1, Lowering.RiscV.lower p.1 p.2) := by\n  decide\n"

end Tools.RiscV
