/-
  Tools.DiffTest

  `braid-difftest`: run a function on the machine model and its lowering on the `braid`
  interpreter, side by side, and compare the registers and the program counter after every
  instruction. The lowering is proved sound, so a run of the lowered code is a run of the
  machine. This tests the other direction: that the lowered code runs wherever the machine
  does, and so that no `guard` is stricter than the model.

      braid-difftest prog.elf --fn name [--args 1,2,3] [--steps 10000] [--seed 7 --runs 20]
-/

import Tools.RiscV
import Tools.DiffTestMore
import Braid.IR.Exec

open Tools

namespace Tools.DiffTest.RiscV

open RiscvZkvm.Rv64 hiding Instr MachineState

/-- The RISC-V model's instructions and states; the x86-64 model has types of the same names. -/
abbrev Instr := RiscvZkvm.Rv64.Instr
abbrev MachineState := RiscvZkvm.Rv64.MachineState

/-- Where the stack pointer starts: inside the model's valid memory. -/
def stackTop : Braid.Word := 0x70000000#64

/-- The return address of the function under test: no code is there. -/
def sentinel : Braid.Word := 0x7ff00000#64

def argRegs : List Reg := [.x10, .x11, .x12, .x13, .x14, .x15, .x16, .x17]

/-- The machine state at the entry of a function called with `args`. -/
def initMachine (code : List (Braid.Word × Instr)) (entry : Braid.Word) (args : List Braid.Word) :
    MachineState :=
  let s : MachineState :=
    { regs := fun _ => 0, mem := fun _ => 0, pc := entry
      code := fun a => (code.find? (·.1 == a)).map (·.2) }
  let s := (s.setReg .x2 stackTop).setReg .x1 sentinel
  (argRegs.zip args).foldl (fun s (r, v) => s.setReg r v) s

/-- The `braid` state of a machine state. Registers are numbered as the lowering does. -/
def absState (s : MachineState) : Braid.State where
  regs n := if n == 0 then 0 else s.regs (RiscvZkvm.Interpreter.regOfBits (BitVec.ofNat 5 n))
  flags _ := false
  mem a := if isValidMemAddr a then some ⟨s.getByte a, true⟩ else none
  pc := s.pc

/-- The first register on which the two states differ, if any. -/
def firstDiff (s : MachineState) (σ : Braid.State) : Option String :=
  if s.pc != σ.pc then some s!"pc: machine 0x{Braid.hex s.pc.toNat}, braid 0x{Braid.hex σ.pc.toNat}"
  else
    (List.range 32).findSome? fun n =>
      if n == 0 then none
      else
        let m := s.regs (RiscvZkvm.Interpreter.regOfBits (BitVec.ofNat 5 n))
        if m != σ.regs n then
          some s!"x{n}: machine 0x{Braid.hex m.toNat}, braid 0x{Braid.hex (σ.regs n).toNat}"
        else none

inductive Outcome where
  | agree (steps : Nat) (result : Braid.Word)
  | outOfFuel (steps : Nat)
  | bothStop (steps : Nat) (pc : Braid.Word)
  | mismatch (steps : Nat) (pc : Braid.Word) (what : String)

/-- Run the two side by side until the function returns. -/
def run (P : Braid.Program) : Nat → Nat → MachineState → Braid.State → Outcome
  | 0, n, _, _ => .outOfFuel n
  | fuel + 1, n, s, σ =>
    if s.pc == sentinel then .agree n (s.getReg .x10)
    else
      match step s, (P σ.pc).bind (·.exec σ) with
      | some s', some σ' =>
        match firstDiff s' σ' with
        | some d => .mismatch n s.pc d
        | none => run P fuel (n + 1) s' σ'
      | none, none => .bothStop n s.pc
      | some _, none => .mismatch n s.pc "the machine steps, the lowered code faults"
      | none, some _ => .mismatch n s.pc "the lowered code steps, the machine traps"

/-- A pseudo-random stream of words, biased towards small values and boundary cases. -/
def randWords (seed n : Nat) : List Braid.Word :=
  let rec go (k : Nat) (x : Nat) (acc : List Braid.Word) : List Braid.Word :=
    match k with
    | 0 => acc.reverse
    | k + 1 =>
      let x := (x * 6364136223846793005 + 1442695040888963407) % 2 ^ 64
      let v := match x % 7 with
        | 0 => (x / 7) % 16
        | 1 => 2 ^ 64 - 1 - (x / 7) % 16
        | 2 => 2 ^ 63 + (x / 7) % 4
        | 3 => (x / 7) % 1000
        | _ => x
      go k x (BitVec.ofNat 64 v :: acc)
  go n (seed + 1) []

end Tools.DiffTest.RiscV

namespace Tools.DiffTest

/-- Print the verdicts of the runs of a function, and count the failures. -/
def report (fn : String) (runs : Nat) (result : String) (vs : List (List Word × Verdict)) :
    IO UInt32 := do
  let mut failed := 0
  for (input, v) in vs do
    match v with
    | .agree n r =>
      if runs == 0 then IO.println s!"{fn}: agree after {n} instructions, {result} = {hex r}"
    | .outOfFuel n => IO.println s!"{fn}: agree for {n} instructions, then out of fuel"
    | .bothStop n pc => IO.println s!"{fn}: both stop after {n} instructions at {hex pc}"
    | .mismatch n pc d =>
      failed := failed + 1
      IO.println s!"{fn}: MISMATCH after {n} instructions at {hex pc}: {d}"
      IO.println s!"  inputs: {input.map hex}"
  if runs != 0 then IO.println s!"{fn}: {runs - failed}/{runs} runs agree"
  return if failed == 0 then 0 else 1

end Tools.DiffTest

open Tools.DiffTest Tools.DiffTest.RiscV in
def main (args : List String) : IO UInt32 := do
  let rec parse : List String → (String × String × List Nat × Nat × Nat × Nat) →
      (String × String × List Nat × Nat × Nat × Nat)
    | "--fn" :: f :: r, (i, _, a, st, sd, rn) => parse r (i, f, a, st, sd, rn)
    | "--args" :: a :: r, (i, f, _, st, sd, rn) =>
      parse r (i, f, (a.splitOn ",").map (·.toNat!), st, sd, rn)
    | "--steps" :: n :: r, (i, f, a, _, sd, rn) => parse r (i, f, a, n.toNat!, sd, rn)
    | "--seed" :: n :: r, (i, f, a, st, _, rn) => parse r (i, f, a, st, n.toNat!, rn)
    | "--runs" :: n :: r, (i, f, a, st, sd, _) => parse r (i, f, a, st, sd, n.toNat!)
    | x :: r, (_, f, a, st, sd, rn) => parse r (x, f, a, st, sd, rn)
    | [], o => o
  let disasm := match args.dropWhile (· != "--disasm") with
    | _ :: f :: _ => some f
    | _ => none
  let args := match args.span (· != "--disasm") with
    | (pre, _ :: _ :: post) => pre ++ post
    | (pre, _) => pre
  let (input, fn, fixed, steps, seed, runs) := parse args ("", "", [], 100000, 0, 0)
  if input.isEmpty || fn.isEmpty then
    IO.eprintln ("usage: braid-difftest <binary> --fn <name> [--args a,b,..] [--steps n] " ++
      "[--seed n --runs n] [--disasm <file>]")
    return 1
  let img ← match Elf.parse (← IO.FS.readBinFile input) with
    | .ok i => pure i
    | .error e => IO.eprintln e; return 1
  let inputs : List (List Braid.Word) :=
    if runs == 0 then [fixed.map (BitVec.ofNat 64)]
    else (List.range runs).map fun k => RiscV.randWords (seed + k) 6
  if img.machine == .aarch64 then
    let some f := img.functions.find? (·.name == fn)
      | IO.eprintln s!"no function named {fn}"; return 1
    -- Every function of the binary is loaded, so that calls can be followed.
    let fns := img.functions.toList
    let base := fns.foldl (fun b g => min b g.addr) f.addr
    let top := fns.foldl (fun t g => max t (g.addr + g.bytes.size)) 0
    let bytes : Array (BitVec 8) := fns.foldl (init := Array.replicate (top - base) 0#8)
      fun arr g => (List.range g.bytes.size).foldl
        (fun arr i => arr.set! (g.addr - base + i) (BitVec.ofNat 8 g.bytes[i]!.toNat)) arr
    let P := Braid.Program.ofList (fns.flatMap fun g =>
      (Arm.toFunc g.name g.addr (Arm.decodeFunction g.addr (Elf.words32 g.bytes)).1).blocks)
    let vs := inputs.map fun input =>
      let s := Tools.DiffTest.Arm.initMachine base bytes.toList f.addr input
      (input, Tools.DiffTest.Arm.run {} P steps 0 s (Lowering.Arm.abs s))
    return ← report fn runs "x0" vs
  if img.machine == .x86_64 then
    let some dis := disasm
      | IO.eprintln "braid-difftest: an x86-64 binary needs --disasm <file>"; return 1
    let fns := X86Asm.parseObjdump (← IO.FS.readFile dis)
    let some f := fns.find? (·.name == fn)
      | IO.eprintln s!"no function named {fn}"; return 1
    let lines := (X86.image fns).flatMap (·.2)
    let e := Lowering.X86.exeOf lines
    let P := Braid.Program.ofList (Lowering.X86.lowerLines (Lowering.X86.labelsOf lines) lines)
    let vs := inputs.map fun input =>
      let m := Tools.DiffTest.X86.initMachine f.addr input
      (input, Tools.DiffTest.X86.run e P steps 0 m (Lowering.X86.abs m) [])
    return ← report fn runs "rax" vs
  unless img.machine == .riscv do
    IO.eprintln "braid-difftest: no model for this machine"
    return 1
  let some f := img.functions.find? (·.name == fn)
    | IO.eprintln s!"no function named {fn}"; return 1
  -- Every function of the binary is loaded, so that calls can be followed.
  let code := img.functions.toList.flatMap fun g => (RiscV.decodeFunction g).1
  let P := Braid.Program.ofList (code.map fun (a, i) => (a, Lowering.RiscV.lower a i))
  let inputs : List (List Braid.Word) :=
    if runs == 0 then [fixed.map (BitVec.ofNat 64)]
    else (List.range runs).map fun k => randWords (seed + k) 8
  let mut failed := 0
  for input in inputs do
    let s := initMachine code (BitVec.ofNat 64 f.addr) input
    match run P steps 0 s (absState s) with
    | .agree n r =>
      if runs == 0 then IO.println s!"{fn}: agree after {n} instructions, a0 = 0x{Braid.hex r.toNat}"
    | .outOfFuel n => IO.println s!"{fn}: agree for {n} instructions, then out of fuel"
    | .bothStop n pc =>
      IO.println s!"{fn}: both stop after {n} instructions at 0x{Braid.hex pc.toNat}"
    | .mismatch n pc d =>
      failed := failed + 1
      IO.println s!"{fn}: MISMATCH after {n} instructions at 0x{Braid.hex pc.toNat}: {d}"
      IO.println s!"  inputs: {input.map fun w => s!"0x{Braid.hex w.toNat}"}"
  if runs != 0 then IO.println s!"{fn}: {runs - failed}/{runs} runs agree"
  return if failed == 0 then 0 else 1
