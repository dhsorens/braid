/-
  Tools.Main

  `braid-lower`: the decompiler. It reads a binary, lowers the functions asked for into the
  `braid` dialect, and writes them as MLIR text and as a Lean module.

      braid-lower prog.elf --fn name ... [--mlir out.mlir] [--lean Out.lean --module Out]
-/

import Std.Data.HashMap
import Tools.RiscV
import Tools.Arm
import Tools.X86
import Braid.Pass.Plan

open Tools

structure Options where
  input : String := ""
  fns : List String := []
  mlir : Option String := none
  lean : Option String := none
  norm : Option String := none
  disasm : Option String := none
  module : String := "Image"
  image : Option String := none
  list : Bool := false
  stats : Bool := false
  simplify : Bool := false

def usage : String :=
  "usage: braid-lower <binary> [--list] [--stats] [--fn <name>]... [--mlir <file>] [--lean <file>]\n" ++
  "                   [--norm <file>] [--module <Name>] [--disasm <file>]\n" ++
  "  --list           print the functions of the binary and stop\n" ++
  "  --stats          print how much of the code the lowering covers\n" ++
  "  --simplify       fuse blocks and remove dead work in the MLIR and position-independent text\n" ++
  "  --fn <name>      lower this function (repeatable; default: every function)\n" ++
  "  --mlir <file>    write the lowered functions in MLIR's generic syntax\n" ++
  "  --lean <file>    write the lowered functions as a Lean module\n" ++
  "  --norm <file>    write the lowered functions as position-independent text, for diffing\n" ++
  "  --module <Name>  the namespace of the Lean module (default: Image)\n" ++
  "  --image <name>   also write the whole binary as a loaded image named <name>: its data\n" ++
  "                   sections and entry point, with system calls lowered as events\n" ++
  "  --disasm <file>  x86-64 only: the output of `objdump -d` on the binary\n"

def parseArgs : List String → Options → Except String Options
  | [], o => if o.input.isEmpty then .error usage else .ok o
  | "--list" :: rest, o => parseArgs rest { o with list := true }
  | "--stats" :: rest, o => parseArgs rest { o with stats := true }
  | "--simplify" :: rest, o => parseArgs rest { o with simplify := true }
  | "--fn" :: n :: rest, o => parseArgs rest { o with fns := o.fns ++ [n] }
  | "--mlir" :: f :: rest, o => parseArgs rest { o with mlir := some f }
  | "--lean" :: f :: rest, o => parseArgs rest { o with lean := some f }
  | "--norm" :: f :: rest, o => parseArgs rest { o with norm := some f }
  | "--module" :: m :: rest, o => parseArgs rest { o with module := m }
  | "--image" :: n :: rest, o => parseArgs rest { o with image := some n }
  | "--disasm" :: f :: rest, o => parseArgs rest { o with disasm := some f }
  | a :: rest, o =>
    if a.startsWith "--" then .error s!"unknown option {a}\n{usage}"
    else parseArgs rest { o with input := a }

def leanHeader (ns : String) (imports : List String) (opens : List String) : String :=
  "/- Written by `braid-lower`. Do not edit. -/\n\nmodule\n\n" ++
  String.join (imports.map fun i => s!"public import {i}\n") ++
  "\n@[expose] public section\n\n" ++ s!"namespace {ns}\n\n" ++
  String.join (opens.map fun o => s!"open {o}\n") ++ "\n"

/-- Print how many instructions were lowered, and what the others were. -/
def printStats (funcs : List Braid.Func) (undecoded : Nat) (unread : List String := []) :
    IO Unit := do
  let blocks := funcs.flatMap (·.blocks)
  let traps := blocks.filterMap fun (_, b) => match b.term with
    | .trap r => some r
    | _ => none
  let total := blocks.length + undecoded
  let lowered := blocks.length - traps.length
  IO.println s!"functions:    {funcs.length}"
  IO.println s!"instructions: {total}"
  IO.println s!"lowered:      {lowered} ({if total == 0 then 100 else lowered * 100 / total}%)"
  IO.println s!"undecoded:    {undecoded}"
  IO.println s!"trap:         {traps.length}"
  let reasons := traps.eraseDups.map fun r => (traps.count r, r)
  for (n, r) in reasons.mergeSort (fun a b => a.1 ≥ b.1) do
    IO.println s!"  {n}\t{r}"
  unless unread.isEmpty do
    IO.println "undecoded, by mnemonic:"
    let counts := unread.foldl (fun (m : Std.HashMap String Nat) k => m.insert k (m.getD k 0 + 1)) {}
    for (r, n) in counts.toList.mergeSort (fun a b => a.2 ≥ b.2) do
      IO.println s!"  {n}\t{r}"

def main (args : List String) : IO UInt32 := do
  let opts ← match parseArgs args {} with
    | .ok o => pure o
    | .error e => IO.eprint e; return 1
  let img ← match Elf.parse (← IO.FS.readBinFile opts.input) with
    | .ok i => pure i
    | .error e => IO.eprintln e; return 1
  let view (fs : List Braid.Func) := if opts.simplify then fs.map fun f => f.simplifyBy f.fusePlan else fs
  let all := img.functions
  if opts.list then
    for f in all do IO.println s!"0x{Braid.hex f.addr} {f.bytes.size} {f.name}"
    return 0
  let fs := if opts.fns.isEmpty then all.toList else
    opts.fns.filterMap fun n => all.find? (·.name == n)
  for n in opts.fns do
    unless all.any (·.name == n) do IO.eprintln s!"warning: no function named {n}"
  match img.machine with
  | .riscv =>
    let decoded := fs.map fun f => (f, RiscV.decodeFunction f)
    unless opts.stats do
      for (f, (_, bad)) in decoded do
        for (a, w) in bad do
          IO.eprintln s!"warning: {f.name}: 0x{Braid.hex a}: the word 0x{Braid.hex w.toNat} does not decode"
    let env := opts.image.isSome
    let funcs := decoded.map fun (f, (code, _)) => RiscV.toFunc f.name f.addr code env
    if opts.stats then
      printStats funcs (decoded.foldl (fun n (_, (_, bad)) => n + bad.length) 0)
    if let some out := opts.mlir then
      IO.FS.writeFile out (Braid.Module.toMlir Lowering.RiscV.arch { arch := "riscv64", funcs := view funcs })
    if let some out := opts.norm then
      IO.FS.writeFile out (Braid.Module.toNorm Lowering.RiscV.arch { arch := "riscv64", funcs := view funcs })
    if let some out := opts.lean then
      IO.FS.writeFile out <|
        leanHeader opts.module [if env then "Lowering.RiscV.Program" else "Lowering.RiscV.Sound"]
          ["RiscvZkvm.Rv64"] ++
        "\n".intercalate
          (decoded.map fun (f, (code, _)) => RiscV.leanSource f.name f.addr code env) ++
        (match opts.image with
          | some n => "\n" ++ RiscV.imageSource n img.entry (fs.map (·.name)) img.dataSections
              img.zeroSections
          | none => "") ++
        s!"\nend {opts.module}\n"
    return 0
  | .aarch64 =>
    let decoded := fs.map fun f => (f, Arm.decodeFunction f.addr (Elf.words32 f.bytes))
    unless opts.stats do
      for (f, (_, bad)) in decoded do
        for (a, w) in bad do
          IO.eprintln s!"warning: {f.name}: 0x{Braid.hex a}: the word 0x{Braid.hex w.toNat} does not decode"
    let funcs := decoded.map fun (f, (ws, _)) => Arm.toFunc f.name f.addr ws
    if opts.stats then
      printStats funcs (decoded.foldl (fun n (_, (_, bad)) => n + bad.length) 0)
    if let some out := opts.mlir then
      IO.FS.writeFile out (Braid.Module.toMlir Lowering.Arm.arch { arch := "aarch64", funcs := view funcs })
    if let some out := opts.norm then
      IO.FS.writeFile out (Braid.Module.toNorm Lowering.Arm.arch { arch := "aarch64", funcs := view funcs })
    if let some out := opts.lean then
      IO.FS.writeFile out <|
        leanHeader opts.module ["Lowering.Arm.Logic"] [] ++
        "\n".intercalate (decoded.map fun (f, (ws, _)) => Arm.leanSource f.name f.addr ws) ++
        s!"\nend {opts.module}\n"
    return 0
  | .x86_64 =>
    let some dis := opts.disasm
      | IO.eprintln "braid-lower: an x86-64 binary needs --disasm <file>, the output of `objdump -d`"
        return 1
    let allFns := X86Asm.parseObjdump (← IO.FS.readFile dis)
    let chosen := if opts.fns.isEmpty then allFns else
      opts.fns.filterMap fun n => allFns.find? (·.name == n)
    for n in opts.fns do
      unless allFns.any (·.name == n) do
        IO.eprintln s!"warning: no function named {n} in the disassembly"
    let image := X86.image chosen
    let lines := image.flatMap (·.2)
    let mnemonic (t : String) := ((t.splitOn " ").filter (· ≠ "")).head!
    unless opts.stats do
      for (f, _) in image do
        for (a, t) in X86.unread f do
          unless mnemonic t == "int3" do
            IO.eprintln s!"warning: {f.name}: 0x{Braid.hex a}: the model does not read `{t}`"
    let funcs := image.map fun (f, ls) => X86.toFunc lines f.name f.addr ls
    if opts.stats then
      -- `int3` fills the room between functions; it is padding, not code.
      let unread := (image.flatMap fun (f, _) => (X86.unread f).map fun (_, t) => mnemonic t).filter
        (· ≠ "int3")
      printStats funcs unread.length unread
    if let some out := opts.mlir then
      IO.FS.writeFile out (Braid.Module.toMlir Lowering.X86.arch { arch := "x86_64", funcs := view funcs })
    if let some out := opts.norm then
      IO.FS.writeFile out (Braid.Module.toNorm Lowering.X86.arch { arch := "x86_64", funcs := view funcs })
    if let some out := opts.lean then
      IO.FS.writeFile out <|
        leanHeader opts.module
          [if opts.image.isSome then "Lowering.X86.Program" else "Lowering.X86.Logic"] [] ++
        X86.leanSource image ++
        (match opts.image with
          | some n => X86.imageSource n img.entry (image.map (·.1.name)) img.dataSections
              img.zeroSections
          | none => "") ++
        s!"\nend {opts.module}\n"
    return 0
  | m =>
    IO.eprintln s!"braid-lower: no front end for {repr m} yet"
    return 1
