/-
  Tools.Main

  `braid-lower`: the decompiler. It reads a binary, lowers the functions asked for into the
  `braid` dialect, and writes them as MLIR text and as a Lean module.

      braid-lower prog.elf --fn name ... [--mlir out.mlir] [--lean Out.lean --module Out]
-/

import Tools.RiscV

open Tools

structure Options where
  input : String := ""
  fns : List String := []
  mlir : Option String := none
  lean : Option String := none
  module : String := "Image"
  list : Bool := false
  stats : Bool := false

def usage : String :=
  "usage: braid-lower <binary> [--list] [--fn <name>]... [--mlir <file>] [--lean <file>] [--module <Name>]\n" ++
  "  --list           print the functions of the binary and stop\n" ++
  "  --stats          print how much of the code the lowering covers\n" ++
  "  --fn <name>      lower this function (repeatable; default: every function)\n" ++
  "  --mlir <file>    write the lowered functions in MLIR's generic syntax\n" ++
  "  --lean <file>    write the lowered functions as a Lean module\n" ++
  "  --module <Name>  the namespace of the Lean module (default: Image)\n"

def parseArgs : List String → Options → Except String Options
  | [], o => if o.input.isEmpty then .error usage else .ok o
  | "--list" :: rest, o => parseArgs rest { o with list := true }
  | "--stats" :: rest, o => parseArgs rest { o with stats := true }
  | "--fn" :: n :: rest, o => parseArgs rest { o with fns := o.fns ++ [n] }
  | "--mlir" :: f :: rest, o => parseArgs rest { o with mlir := some f }
  | "--lean" :: f :: rest, o => parseArgs rest { o with lean := some f }
  | "--module" :: m :: rest, o => parseArgs rest { o with module := m }
  | a :: rest, o =>
    if a.startsWith "--" then .error s!"unknown option {a}\n{usage}"
    else parseArgs rest { o with input := a }

def leanHeader (ns : String) (imports : List String) (opens : List String) : String :=
  "/- Written by `braid-lower`. Do not edit. -/\n\nmodule\n\n" ++
  String.join (imports.map fun i => s!"public import {i}\n") ++
  "\n@[expose] public section\n\n" ++ s!"namespace {ns}\n\n" ++
  String.join (opens.map fun o => s!"open {o}\n") ++ "\n"

/-- Print how many instructions were lowered, and what the others were. -/
def printStats (funcs : List Braid.Func) (undecoded : Nat) : IO Unit := do
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

def main (args : List String) : IO UInt32 := do
  let opts ← match parseArgs args {} with
    | .ok o => pure o
    | .error e => IO.eprint e; return 1
  let img ← match Elf.parse (← IO.FS.readBinFile opts.input) with
    | .ok i => pure i
    | .error e => IO.eprintln e; return 1
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
    let funcs := decoded.map fun (f, (code, _)) => RiscV.toFunc f.name f.addr code
    if opts.stats then
      printStats funcs (decoded.foldl (fun n (_, (_, bad)) => n + bad.length) 0)
    if let some out := opts.mlir then
      IO.FS.writeFile out (Braid.Module.toMlir Lowering.RiscV.arch { arch := "riscv64", funcs })
    if let some out := opts.lean then
      IO.FS.writeFile out <|
        leanHeader opts.module ["Lowering.RiscV.Sound"] ["RiscvZkvm.Rv64"] ++
        "\n".intercalate (decoded.map fun (f, (code, _)) => RiscV.leanSource f.name f.addr code) ++
        s!"\nend {opts.module}\n"
    return 0
  | m =>
    IO.eprintln s!"braid-lower: no front end for {repr m} yet"
    return 1
