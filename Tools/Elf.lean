/-
  Tools.Elf

  A reader for little-endian ELF64 files: the sections and the function symbols, which is
  what the decompiler needs to find the code of each function.

  ## Main definitions

  * `Elf.Image`, `Elf.parse`
  * `Elf.Image.functions`: the function symbols with their bytes
-/

module

public import Braid.IR.Print

public section

namespace Tools

/-- A name that is a Lean identifier: every other character becomes `_`. -/
def ident (s : String) : String :=
  String.ofList (s.toList.map fun c => if c.isAlphanum || c == '_' then c else '_')

end Tools

namespace Tools.Elf

/-- A section: where it is loaded and its bytes in the file. -/
structure Section where
  name : String
  type : Nat
  addr : Nat
  offset : Nat
  size : Nat
  link : Nat
  entsize : Nat
  deriving Repr, Inhabited

/-- A symbol of the symbol table. -/
structure Symbol where
  name : String
  /-- The low four bits of `st_info`: `2` is a function. -/
  type : Nat
  shndx : Nat
  value : Nat
  size : Nat
  deriving Repr, Inhabited

/-- The instruction set of the file, from `e_machine`. -/
inductive Machine where
  | riscv | aarch64 | x86_64 | other (n : Nat)
  deriving Repr, Inhabited, DecidableEq

/-- The parts of an ELF64 file the decompiler reads. -/
structure Image where
  machine : Machine
  entry : Nat
  sections : Array Section
  symbols : Array Symbol
  bytes : ByteArray
  deriving Inhabited

/-- A function: its name, its address and its bytes. -/
structure Function where
  name : String
  addr : Nat
  bytes : ByteArray
  deriving Inhabited

def readLE (bs : ByteArray) (off n : Nat) : Except String Nat :=
  if off + n > bs.size then
    .error s!"ELF: read of {n} bytes at offset {off} is past the end of the file"
  else
    .ok <| (List.range n).foldl (fun acc i => acc ||| ((bs[off + i]!).toNat <<< (8 * i))) 0

partial def cstr (bs : ByteArray) (off : Nat) : String :=
  let rec go (i : Nat) (acc : List Char) : List Char :=
    if i ≥ bs.size then acc.reverse
    else
      let b := bs[i]!
      if b == 0 then acc.reverse else go (i + 1) (Char.ofNat b.toNat :: acc)
  String.ofList (go off [])

/-- Parse a little-endian ELF64 file. -/
def parse (bs : ByteArray) : Except String Image := do
  if bs.size < 64 then throw "ELF: the file is too small for an ELF64 header"
  unless bs[0]! == 0x7f && bs[1]! == 0x45 && bs[2]! == 0x4c && bs[3]! == 0x46 do
    throw "ELF: bad magic number"
  unless bs[4]! == 2 do throw "ELF: not a 64-bit file"
  unless bs[5]! == 1 do throw "ELF: not little-endian"
  let machine := match ← readLE bs 18 2 with
    | 243 => Machine.riscv
    | 183 => .aarch64
    | 62 => .x86_64
    | n => .other n
  let entry ← readLE bs 24 8
  let shoff ← readLE bs 40 8
  let shentsize ← readLE bs 58 2
  let shnum ← readLE bs 60 2
  let shstrndx ← readLE bs 62 2
  let mut raw : Array (Nat × Section) := #[]
  for i in [0:shnum] do
    let o := shoff + i * shentsize
    raw := raw.push (← readLE bs o 4, {
      name := "", type := ← readLE bs (o + 4) 4, addr := ← readLE bs (o + 16) 8,
      offset := ← readLE bs (o + 24) 8, size := ← readLE bs (o + 32) 8,
      link := ← readLE bs (o + 40) 4, entsize := ← readLE bs (o + 56) 8 })
  let strOff := (raw[shstrndx]?.map (·.2.offset)).getD 0
  let sections := raw.map fun (n, s) => { s with name := cstr bs (strOff + n) }
  let mut symbols : Array Symbol := #[]
  for s in sections do
    if s.type == 2 && s.entsize != 0 then
      let strtab := (sections[s.link]?.map (·.offset)).getD 0
      for i in [0:s.size / s.entsize] do
        let o := s.offset + i * s.entsize
        symbols := symbols.push {
          name := cstr bs (strtab + (← readLE bs o 4)), type := (← readLE bs (o + 4) 1) % 16,
          shndx := ← readLE bs (o + 6) 2, value := ← readLE bs (o + 8) 8,
          size := ← readLE bs (o + 16) 8 }
  return { machine, entry, sections, symbols, bytes := bs }

/-- The function symbols of the image, with their bytes, in address order. -/
def Image.functions (img : Image) : Array Function :=
  let fs := img.symbols.filterMap fun s =>
    if s.type == 2 && s.size > 0 then
      img.sections[s.shndx]?.bind fun sec =>
        if sec.addr ≤ s.value && s.value + s.size ≤ sec.addr + sec.size then
          let off := sec.offset + (s.value - sec.addr)
          some { name := s.name, addr := s.value, bytes := img.bytes.extract off (off + s.size) }
        else none
    else none
  fs.qsort fun a b => a.addr < b.addr

/-- The 32-bit little-endian words of a byte array, with their offsets. -/
def words32 (bs : ByteArray) : List (Nat × BitVec 32) :=
  (List.range (bs.size / 4)).map fun i =>
    let b (k : Nat) := (bs[4 * i + k]!).toNat
    (4 * i, BitVec.ofNat 32 (b 0 ||| (b 1 <<< 8) ||| (b 2 <<< 16) ||| (b 3 <<< 24)))

end Tools.Elf
