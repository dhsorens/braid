/-
  Tools.X86Asm

  The x86-64 code of a binary, as a Kraken executable. Kraken's programs are assembly, so
  this front end reads the disassembly `objdump -d` prints, parses each instruction with
  Kraken's own AT&T parser, and lays the instructions out at the addresses and sizes the
  binary has. Every instruction gets a label, `L<address>`, and jump targets become labels.

  An instruction Kraken's parser does not know becomes a data directive of the same size:
  it takes its room in the layout, and execution that reaches it is not defined.

  ## Main definitions

  * `Line`, `parseObjdump`: the instructions of a disassembly
  * `toExecutable`: the Kraken executable of a list of instructions
-/

module

public import Kraken.X64.Parser.Basic
public import Kraken.Layout

@[expose] public section

namespace Tools.X86Asm

/-- One instruction of a disassembly. -/
structure Line where
  addr : Nat
  size : Nat
  text : String
  deriving Repr, Inhabited

/-- A function of a disassembly. -/
structure Function where
  name : String
  addr : Nat
  lines : List Line
  deriving Repr, Inhabited

/-- A string without the blanks at its ends. -/
def trim (s : String) : String := s.trimAscii.toString

def hexVal? (s : String) : Option Nat :=
  if s.isEmpty then none else
  s.toList.foldlM (fun acc c =>
    if c.isDigit then some (acc * 16 + (c.toNat - '0'.toNat))
    else if 'a' ≤ c ∧ c ≤ 'f' then some (acc * 16 + (c.toNat - 'a'.toNat + 10))
    else if 'A' ≤ c ∧ c ≤ 'F' then some (acc * 16 + (c.toNat - 'A'.toNat + 10))
    else none) 0

/-- The label of the instruction at an address. -/
def label (a : Nat) : String := s!"L{String.ofList (Nat.toDigits 16 a)}"

/-- An instruction line of `objdump -d`: `  401000: 48 8b 07   movq (%rdi), %rax`. The size
is the number of bytes printed. -/
def parseLine (l : String) : Option Line := do
  let parts := l.splitOn "\t"
  guard (parts.length ≥ 2)
  let head := trim (parts[0]!)
  let colon := head.splitOn ":"
  guard (colon.length ≥ 2)
  let addr ← hexVal? (trim (colon[0]!))
  let bytes := ((trim (colon[1]!)).splitOn " ").filter (· ≠ "")
  guard (bytes.all fun b => b.length == 2 && (hexVal? b).isSome)
  let text := " ".intercalate ((parts.drop 1).map trim)
  some { addr, size := bytes.length, text }

/-- A function header of `objdump -d`: `0000000000401000 <swap>:`. -/
def parseHeader (l : String) : Option (Nat × String) := do
  guard (l.endsWith ">:")
  let parts := l.splitOn " <"
  guard (parts.length == 2)
  let addr ← hexVal? (trim (parts[0]!))
  some (addr, ((parts[1]!).dropEnd 2).toString)

/-- The functions of the text `objdump -d` prints. A line that continues the bytes of the
instruction before it adds to that instruction's size. -/
def parseObjdump (text : String) : List Function :=
  let step (acc : List Function) (l : String) : List Function :=
    match parseHeader l with
    | some (addr, name) => { name, addr, lines := [] } :: acc
    | none =>
      match parseLine l, acc with
      | some ln, f :: rest =>
        if ln.text.isEmpty then
          match f.lines with
          | last :: ls => { f with lines := { last with size := last.size + ln.size } :: ls } :: rest
          | [] => acc
        else { f with lines := ln :: f.lines } :: rest
      | _, _ => acc
  ((text.splitOn "\n").foldl step []).reverse.map fun f => { f with lines := f.lines.reverse }

/-- The text of an instruction, as Kraken's parser reads it: a jump target `0x401020 <f+0x10>`
becomes the label `L401020`. -/
def normalize (text : String) : String :=
  match text.splitOn " <" with
  | [pre, _] =>
    match pre.splitOn "0x" with
    | [] => text
    | parts =>
      let last := parts.getLast!
      match hexVal? last with
      | some a => "0x".intercalate (parts.dropLast) ++ label a
      | none => text
  | _ => text

/-- The directive of one instruction, and whether Kraken's parser read it. A padding `nop`
of any form is a `nop` of its size. -/
def directive (l : Line) : _root_.Directive × Bool :=
  let mnemonic := (l.text.splitOn " ").head!
  if mnemonic.startsWith "nop" || l.text.startsWith "data16" || mnemonic == "endbr64" then
    (.instr (.regular .W64 .W64 (.nop l.size)), true)
  else
    match Kraken.X64.Parser.parse (normalize l.text) with
    | .ok [d] => (d, true)
    | _ => (.byteArray (ByteArray.mk (Array.replicate l.size 0)), false)

/-- The executable of a list of instructions in address order: each has a label and its
size. A gap between two instructions is filled with a data directive. -/
def toExecutable (lines : List Line) : _root_.Executable :=
  let start := (lines.head?.map (·.addr)).getD 0
  let rec go (ls : List Line) (at_ : Nat) (acc : List (Kraken.Sized _root_.Directive)) :=
    match ls with
    | [] => acc.reverse
    | l :: rest =>
      let gap : List (Kraken.Sized _root_.Directive) :=
        if l.addr > at_ then
          [{ directive := .byteArray (ByteArray.mk (Array.replicate (l.addr - at_) 0)),
             size := l.addr - at_ }]
        else []
      go rest (l.addr + l.size)
        ({ directive := (directive l).1, size := l.size } ::
          { directive := .label (label l.addr), size := 0 } :: (gap ++ acc))
  { startAddr := Int64.ofNat start, program := go lines start [] }

end Tools.X86Asm
