/-
  Tools.Arm

  The AArch64 front end of the decompiler: decode the words of a function with the model's
  own decoder, lower each instruction, and print the Lean definitions a proof imports.

  ## Main definitions

  * `toFunc`: the lowered function
  * `leanSource`: the Lean definitions of a function and its lowering certificate
-/

module

public import Tools.Elf
public import Lowering.Arm.Logic

public section

namespace Tools.Arm

/-- The words of a function, and those the model's decoder rejects. -/
def decodeFunction (addr : Nat) (ws : List (Nat × BitVec 32)) :
    List (BitVec 32) × List (Nat × BitVec 32) :=
  (ws.map (·.2), ws.filterMap fun (off, w) =>
    if (Arm64.decode w).isNone then some (addr + off, w) else none)

/-- The lowered function. -/
def toFunc (name : String) (entry : Nat) (ws : List (BitVec 32)) : Braid.Func :=
  { name, entry := BitVec.ofNat 64 entry,
    blocks := Lowering.Arm.lowerWords (BitVec.ofNat 64 entry) ws }

/-- The Lean definitions of a function: its words, its lowering, and the certificate that the
second is the lowering of the first. -/
def leanSource (name : String) (entry : Nat) (ws : List (BitVec 32)) : String :=
  let n := ident name
  let word (w : BitVec 32) := s!"0x{Braid.hex w.toNat}#32"
  s!"/-- The instruction words of `{name}`, from `0x{Braid.hex entry}`. -/\n" ++
  s!"def {n}_words : List (BitVec 32) := [\n  " ++
    ", ".intercalate (ws.map word) ++ "]\n\n" ++
  s!"/-- `{name}`, lowered to `braid`. -/\n" ++
  s!"def {n} : Braid.Func :=\n{(toFunc name entry ws).toLean}\n\n" ++
  s!"/-- `{n}` is the lowering of `{n}_words`. -/\n" ++
  s!"theorem {n}_lowered :\n    {n}.blocks = Lowering.Arm.lowerWords 0x{Braid.hex entry}#64 {n}_words := by\n  decide\n"

end Tools.Arm
