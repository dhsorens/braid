/-
  Tools.Arm

  The AArch64 front end of the decompiler: decode the words of a function with the model's
  own decoder, lower each instruction, and print the Lean definitions a proof imports.

  ## Main definitions

  * `labelCode`: the code at a label that is not marked as a function
  * `toFunc`: the lowered function
  * `leanSource`: the Lean definitions of a function and its lowering certificate
  * `imageSource`: the Lean definitions of a whole binary as a loaded image
-/

module

public import Tools.Elf
public import Lowering.Arm.Program

public section

namespace Tools.Arm

/-- The words of a function, and those the model's decoder rejects. -/
def decodeFunction (addr : Nat) (ws : List (Nat × BitVec 32)) :
    List (BitVec 32) × List (Nat × BitVec 32) :=
  (ws.map (·.2), ws.filterMap fun (off, w) =>
    if (Arm64.decode w).isNone then some (addr + off, w) else none)

/-- The code at a label that is not marked as a function, such as an entry point written in
assembly: from the label to the next function of its section, or to the end of the section. -/
def labelCode (img : Elf.Image) (name : String) : Option Elf.Function :=
  (img.symbols.find? fun s => s.name == name && s.type != 2).bind fun s =>
    img.sections[s.shndx]?.bind fun sec =>
      if sec.flags &&& 4 != 0 && sec.addr ≤ s.value && s.value < sec.addr + sec.size then
        let stop := img.symbols.foldl (init := sec.addr + sec.size) fun e t =>
          if t.shndx == s.shndx && t.type == 2 && s.value < t.value && t.value < e then t.value
          else e
        let off := sec.offset + (s.value - sec.addr)
        some { name, addr := s.value, bytes := img.bytes.extract off (off + (stop - s.value)) }
      else none

/-- The lowered function. With `env`, `SVC #0` is lowered as a call of the environment
(`Lowering.Arm.lowerEnv`). -/
def toFunc (name : String) (entry : Nat) (ws : List (BitVec 32)) (env : Bool := false) :
    Braid.Func :=
  { name, entry := BitVec.ofNat 64 entry,
    blocks := if env then Lowering.Arm.lowerWordsEnv (BitVec.ofNat 64 entry) ws
      else Lowering.Arm.lowerWords (BitVec.ofNat 64 entry) ws }

/-- The Lean definitions of a function: its words, its lowering, and the certificate that the
second is the lowering of the first. -/
def leanSource (name : String) (entry : Nat) (ws : List (BitVec 32)) (env : Bool := false) :
    String :=
  let n := ident name
  let low := if env then "lowerWordsEnv" else "lowerWords"
  let word (w : BitVec 32) := s!"0x{Braid.hex w.toNat}#32"
  s!"/-- The instruction words of `{name}`, from `0x{Braid.hex entry}`. -/\n" ++
  s!"def {n}_words : List (BitVec 32) := [\n  " ++
    ", ".intercalate (ws.map word) ++ "]\n\n" ++
  (toFunc name entry ws env).toLeanDef n s!"`{name}`, lowered to `braid`." ++ "\n" ++
  s!"/-- `{n}` is the lowering of `{n}_words`. -/\n" ++
  s!"theorem {n}_lowered :\n    {n}.blocks = Lowering.Arm.{low} 0x{Braid.hex entry}#64 {n}_words := by\n  {Braid.Func.decideTactic ws.length}\n"

/-- The Lean definitions of a whole binary, after those of its functions `fns` (each a name
and an address, lowered with `env`): each data section, the image, the blocks of the whole
program, the certificate that they are the lowering of the image's code, and the fact that
its sections do not overlap. The sections with contents are in address order, and so are the
zeroed ones. -/
def imageSource (name : String) (entry : Nat) (fns : List (String × Nat))
    (data : List (String × Nat × List UInt8)) (zero : List (Nat × Nat)) : String :=
  let n := ident name
  let w (a : Nat) := Braid.LeanSrc.word (BitVec.ofNat 64 a)
  let secName (s : String) := s!"{n}_section_{ident ((s.dropWhile (· == '.')).toString)}"
  let secs := data.map fun (s, _, bs) =>
    s!"/-- The bytes of the section `{s}`. -/\n" ++
    s!"def {secName s} : List (BitVec 8) := [\n  " ++
      ", ".intercalate (bs.map fun b => s!"{b.toNat}") ++ "]\n\n"
  let fs := fns.map fun f => ident f.1
  let withData := (data.mergeSort fun x y => x.2.1 ≤ y.2.1).map fun d =>
    s!"({w d.2.1}, {secName d.1})"
  let withZero := (zero.mergeSort fun x y => x.1 ≤ y.1).map fun z => s!"({w z.1}, {z.2})"
  "".intercalate secs ++
  s!"/-- The binary as it is loaded: its code, its sections and its entry point. -/\n" ++
  s!"def {n}_image : Lowering.Arm.Image :=\n  \{ entry := {w entry},\n    code := " ++
    " ++\n      ".intercalate (fns.map fun f =>
      s!"Lowering.Arm.wordsAt {w f.2} {ident f.1}_words") ++
    ",\n    data := [\n      " ++ ",\n      ".intercalate withData ++ "],\n    zero := [" ++
    ", ".intercalate withZero ++ "] }\n\n" ++
  s!"/-- The blocks of the whole program. -/\n" ++
  s!"def {n}_blocks : List (Braid.Word × Braid.Block) :=\n  " ++
    " ++ ".intercalate (fs.map (· ++ ".blocks")) ++ "\n\n" ++
  s!"/-- The blocks of the program are the lowering of the code of the image. -/\n" ++
  s!"theorem {n}_lowered :\n    {n}_blocks = Lowering.Arm.lowerImage {n}_image.code := by\n" ++
  s!"  simp only [{n}_blocks, {n}_image, Lowering.Arm.lowerImage_append,\n" ++
  s!"    Lowering.Arm.lowerImage_wordsAt, " ++
    ", ".intercalate (fs.map (· ++ "_lowered")) ++ "]\n\n" ++
  s!"/-- The sections of the image do not overlap. -/\n" ++
  s!"theorem {n}_apart : Lowering.Arm.Image.Apart {n}_image := by\n  decide +kernel\n"

end Tools.Arm
