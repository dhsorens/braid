/-
  Tools.X86

  The x86-64 front end of the decompiler. The machine model's programs are assembly, so the
  instructions come from the disassembly `objdump -d` prints, parsed with the model's own
  parser. Each function becomes a list of lines, the lines of all the functions asked for
  become one executable, and the Lean module holds the lines, the lowered functions and the
  certificates that tie them together.

  ## Main definitions

  * `lines`: the lines of a function of a disassembly
  * `image`: the lines of several functions, with the room between them
  * `leanSource`: the Lean module of an image
-/

module

public import Tools.Elf
public import Tools.X86Asm
public import Lowering.X86.Logic

public section

namespace Tools.X86

open Lowering.X86 (Line)

/-- A 64-bit register, by its AT&T name. -/
def reg64? : String → Option Reg64
  | "%rax" => some .rax | "%rbx" => some .rbx | "%rcx" => some .rcx | "%rdx" => some .rdx
  | "%rsi" => some .rsi | "%rdi" => some .rdi | "%rsp" => some .rsp | "%rbp" => some .rbp
  | "%r8" => some .r8 | "%r9" => some .r9 | "%r10" => some .r10 | "%r11" => some .r11
  | "%r12" => some .r12 | "%r13" => some .r13 | "%r14" => some .r14 | "%r15" => some .r15
  | _ => none

/-- A constant expression with each label `L<address>` replaced by the address. A relative
jump or call then needs no label, and may leave the lines lowered. -/
def unlabel : ConstExpr → ConstExpr
  | .label l =>
    match X86Asm.hexVal? (l.drop 1).toString with
    | some a => if l.startsWith "L" then .int64 (.ofNat a) else .label l
    | none => .label l
  | .add a b => .add (unlabel a) (unlabel b)
  | .sub a b => .sub (unlabel a) (unlabel b)
  | c => c

/-- The target of a jump or call, with labels replaced by addresses. -/
def unlabelTarget : RelRegOrMem → RelRegOrMem
  | .rel c => .rel (unlabel c)
  | t => t

/-- An instruction as the lowering wants it: a relative jump or call goes to an address. -/
def tidy : Instr → Instr
  | .regular a w (.jmp t) => .regular a w (.jmp (unlabelTarget t))
  | .regular a w (.call t) => .regular a w (.call (unlabelTarget t))
  | i => i

/-- The instruction of a line of disassembly, or `none` if the model's parser does not read
it. A padding `nop` of any form is a `nop` of its size, and an indirect jump or call through
a register is built here, since the parser reads only the memory form. -/
def instr? (l : X86Asm.Line) : Option Instr :=
  let words := (l.text.splitOn " ").filter (· ≠ "")
  let mnemonic := words.head!
  if mnemonic.startsWith "nop" || l.text.startsWith "data16" || mnemonic == "endbr64" then
    some (.regular .W64 .W64 (.nop l.size))
  else
    match words with
    | [m, t] =>
      if t.startsWith "*%" then
        match reg64? (t.drop 1).toString with
        | some r =>
          if m == "jmpq" || m == "jmp" then
            some (.regular .W64 .W64 (.jmp (.reg (.low r .W64))))
          else if m == "callq" || m == "call" then
            some (.regular .W64 .W64 (.call (.reg (.low r .W64))))
          else none
        | none => none
      else parsed
    | _ => parsed
where
  parsed : Option Instr :=
    match Kraken.X64.Parser.parse (X86Asm.normalize l.text) with
    | .ok [.instr i] => some (tidy i)
    | _ => none

/-- The lines of a function, from its address: its instructions, and a line without an
instruction for each stretch the disassembly skips. -/
def lines (f : X86Asm.Function) : List Line :=
  let rec go (ls : List X86Asm.Line) (at_ : Nat) (acc : List Line) : List Line :=
    match ls with
    | [] => acc.reverse
    | l :: rest =>
      let gap : List Line :=
        if l.addr > at_ then
          [{ addr := at_, size := l.addr - at_, label := s!"G{Braid.hex at_}", instr := none }]
        else []
      go rest (l.addr + l.size)
        ({ addr := l.addr, size := l.size, label := X86Asm.label l.addr, instr := instr? l } ::
          (gap ++ acc))
  go (f.lines.filter (·.size > 0)) f.addr []

/-- The address after the last line of a list. -/
def endOf (ls : List Line) (default : Nat) : Nat :=
  match ls.getLast? with
  | some l => l.addr + l.size
  | none => default

/-- The lines of several functions, in address order. Each function's lines end with a line
without an instruction that takes the room up to the next function, so that the lines of
all of them follow one another. -/
def image (fs : List X86Asm.Function) : List (X86Asm.Function × List Line) :=
  let sorted := fs.mergeSort (fun a b => a.addr ≤ b.addr)
  let rec go : List X86Asm.Function → List (X86Asm.Function × List Line)
    | [] => []
    | [f] => [(f, lines f)]
    | f :: g :: rest =>
      let ls := lines f
      let e := endOf ls f.addr
      let pad : List Line :=
        if g.addr > e then
          [{ addr := e, size := g.addr - e, label := s!"G{Braid.hex e}", instr := none }]
        else []
      (f, ls ++ pad) :: go (g :: rest)
  go sorted

/-- The lowered function of some of the lines of an image. -/
def toFunc (all : List Line) (name : String) (entry : Nat) (code : List Line) : Braid.Func :=
  { name, entry := BitVec.ofNat 64 entry,
    blocks := Lowering.X86.lowerLines (Lowering.X86.labelsOf all) code }

/-- The mnemonics of the lines the model's parser did not read. -/
def unread (f : X86Asm.Function) : List (Nat × String) :=
  (f.lines.filter (·.size > 0)).filterMap fun l =>
    if (instr? l).isNone then some (l.addr, l.text) else none

/-- An instruction, as Lean source. The derived form leaves out the source width of a move
with extension, which a memory operand does not determine. -/
def instrSrc : Instr → String
  | .regular a w (.movzx (w' := w') dst src) =>
    s!"Instr.regular ({repr a}) ({repr w}) (Operation.movzx (w' := {repr w'}) " ++
      s!"{(reprArg dst).pretty 100000} {(reprArg src).pretty 100000})"
  | .regular a w (.movsx (w' := w') dst src) =>
    s!"Instr.regular ({repr a}) ({repr w}) (Operation.movsx (w' := {repr w'}) " ++
      s!"{(reprArg dst).pretty 100000} {(reprArg src).pretty 100000})"
  | i => (repr i).pretty 100000

/-- A line, as Lean source. -/
def lineSrc (l : Line) : String :=
  let i := match l.instr with
    | some i => s!"some ({instrSrc i})"
    | none => "none"
  s!"  ⟨0x{Braid.hex l.addr}, {l.size}, {repr l.label}, {i}⟩"

/-- The membership proof of the `k`-th element of a list. -/
def memProof : Nat → String
  | 0 => "List.Mem.head _"
  | k + 1 => s!"List.Mem.tail _ ({memProof k})"

/-- The Lean definitions of an image: the lines of each function, the lines of the image and
the certificate that they follow one another, and for each function its lowering, the
certificate that it is the lowering of its lines, and the theorem that its blocks are blocks
of the lowering of the image's executable. -/
def leanSource (img : List (X86Asm.Function × List Line)) : String :=
  let all := img.flatMap (·.2)
  let names := img.map fun (f, _) => ident f.name
  let codes := "\n".intercalate (img.map fun (f, ls) =>
    let n := ident f.name
    s!"/-- The lines of `{f.name}`, from `0x{Braid.hex f.addr}`. -/\n" ++
    s!"def {n}_code : List Lowering.X86.Line := [\n" ++
      ",\n".intercalate (ls.map lineSrc) ++ "]\n")
  let image :=
    "/-- The lines of every function lowered here, in address order. -/\n" ++
    "def image : List Lowering.X86.Line :=\n  List.flatten [" ++
      ", ".intercalate (names.map (· ++ "_code")) ++ "]\n\n" ++
    "/-- The lines of the image follow one another. -/\n" ++
    "theorem image_wf : Lowering.X86.wf image = true := by\n  decide\n\n" ++
    "/-- The executable of the image: the program of the machine model. -/\n" ++
    "def exe : Executable := Lowering.X86.exeOf image\n"
  let funcs := "\n".intercalate (img.zipIdx.map fun ((f, ls), k) =>
    let n := ident f.name
    s!"/-- `{f.name}`, lowered to `braid`. -/\n" ++
    s!"def {n} : Braid.Func :=\n{(toFunc all f.name f.addr ls).toLean}\n\n" ++
    s!"/-- `{n}` is the lowering of `{n}_code`. -/\n" ++
    s!"theorem {n}_lowered :\n    {n}.blocks = " ++
      s!"Lowering.X86.lowerLines (Lowering.X86.labelsOf image) {n}_code := by\n  decide\n\n" ++
    s!"/-- The blocks of `{n}` are blocks of the lowering of the executable. -/\n" ++
    s!"theorem {n}_holds :\n    ∀ p ∈ {n}.blocks, Lowering.X86.lowerProgram exe p.1 = some p.2 :=\n" ++
    s!"  Lowering.X86.holds_exeOf image_wf\n" ++
    s!"    (fun _ h => List.mem_flatten.2 ⟨_, {memProof k}, h⟩) {n}_lowered\n")
  codes ++ "\n" ++ image ++ "\n" ++ funcs

end Tools.X86
