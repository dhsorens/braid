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
import Lowering.RiscV.Env
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

/-- The lowered function. With `env`, `ECALL` is lowered as a call of the environment
(`Lowering.RiscV.lowerEnv`). -/
def toFunc (name : String) (entry : Nat) (code : List (Braid.Word × Instr))
    (env : Bool := false) : Braid.Func :=
  { name, entry := BitVec.ofNat 64 entry,
    blocks := code.map fun (a, i) =>
      (a, if env then Lowering.RiscV.lowerEnv a i else Lowering.RiscV.lower a i) }

/-- The Lean definitions of a function: its instructions, its lowering, and the certificate
that the second is the lowering of the first. -/
def leanSource (name : String) (entry : Nat) (code : List (Braid.Word × Instr))
    (env : Bool := false) : String :=
  let n := ident name
  let low := if env then "lowerEnv" else "lower"
  let instr (p : Braid.Word × Instr) :=
    s!"  ({Braid.LeanSrc.word p.1}, {(repr p.2).pretty 10000})"
  s!"/-- The instructions of `{name}`, by address. -/\n" ++
  s!"def {n}_code : List (BitVec 64 × Instr) := [\n" ++
    ",\n".intercalate (code.map instr) ++ "]\n\n" ++
  (toFunc name entry code env).toLeanDef n s!"`{name}`, lowered to `braid`." ++ "\n" ++
  s!"/-- `{n}` is the lowering of `{n}_code`. -/\n" ++
  s!"theorem {n}_lowered :\n    {n}.blocks = {n}_code.map fun p => (p.1, Lowering.RiscV.{low} p.1 p.2) := by\n  {Braid.Func.decideTactic code.length}\n"

/-- The Lean definitions of a whole binary, after those of its functions `fns` (lowered with
`env`): each data section, the image, the blocks of the whole program, the certificate that
they are the lowering of the image's code, and the fact that its sections do not overlap. -/
def imageSource (name : String) (entry : Nat) (fns : List String)
    (data : List (String × Nat × List UInt8)) (zero : List (Nat × Nat)) : String :=
  let n := ident name
  let w (a : Nat) := Braid.LeanSrc.word (BitVec.ofNat 64 a)
  let secName (s : String) := s!"{n}_section_{ident ((s.dropWhile (· == '.')).toString)}"
  let secs := data.map fun (s, _, bs) =>
    s!"/-- The bytes of the section `{s}`. -/\n" ++
    s!"def {secName s} : List (BitVec 8) := [\n  " ++
      ", ".intercalate (bs.map fun b => s!"{b.toNat}") ++ "]\n\n"
  let fs := fns.map ident
  -- every section in address order, a zeroed one as its zeros
  let withData : List (Nat × String) := data.map fun d => (d.2.1, s!"({w d.2.1}, {secName d.1})")
  let withZero : List (Nat × String) :=
    zero.map fun z => (z.1, s!"({w z.1}, List.replicate {z.2} 0#8)")
  let loaded := (withData ++ withZero).mergeSort fun x y => x.1 ≤ y.1
  "".intercalate secs ++
  s!"/-- The binary as it is loaded: its code, its sections and its entry point. -/\n" ++
  s!"def {n}_image : Lowering.RiscV.Image :=\n  \{ entry := {w entry},\n    code := " ++
    " ++ ".intercalate (fs.map (· ++ "_code")) ++ ",\n    data := [\n      " ++
    ",\n      ".intercalate (loaded.map (·.2)) ++ "],\n    zero := [] }\n\n" ++
  s!"/-- The blocks of the whole program. -/\n" ++
  s!"def {n}_blocks : List (Braid.Word × Braid.Block) :=\n  " ++
    " ++ ".intercalate (fs.map (· ++ ".blocks")) ++ "\n\n" ++
  s!"/-- The blocks of the program are the lowering of the code of the image. -/\n" ++
  s!"theorem {n}_lowered :\n    {n}_blocks =\n      {n}_image.code.map fun p => " ++
    s!"(p.1, Lowering.RiscV.lowerEnv p.1 p.2) := by\n" ++
  s!"  simp only [{n}_blocks, {n}_image, List.map_append, " ++
    ", ".intercalate (fs.map (· ++ "_lowered")) ++ "]\n\n" ++
  s!"/-- The sections of the image do not overlap. -/\n" ++
  s!"theorem {n}_apart : Braid.Sections.Apart {n}_image.sections := by\n  decide +kernel\n"

end Tools.RiscV
