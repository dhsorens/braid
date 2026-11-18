/-
  Tools.DiffTestMore

  The differential tester for AArch64 and x86-64: run a function on the machine model and
  its lowering on the `braid` interpreter, side by side, and compare the program counter,
  the registers and the flags after every instruction.

  A value the model leaves undefined is zero there. Where the lowering leaves a flag undefined
  that the model defines (the auxiliary carry flag on x86-64, for one), the flag is not
  compared, and the run goes on with the model's value.
-/

import Tools.Arm
import Tools.X86
import Braid.IR.Exec

namespace Tools.DiffTest

open Braid (Word)

/-- A block as a function, with zero for every `havoc`. It also follows which flags hold a
value that came from a `havoc`: `tf` lists them before the block, and the result lists them
after it. A flag in the list is one the lowering leaves undefined, and is not compared. -/
def execBlock (b : Braid.Block) (σ : Braid.State) (tf : List Nat) :
    Option (Braid.State × List Nat) :=
  let rec go : List Braid.Op → Braid.Env → Braid.State → List Braid.Var → List Nat →
      Option (Braid.Env × Braid.State × List Nat)
    | [], ρ, σ, _, tf => some (ρ, σ, tf)
    | op :: ops, ρ, σ, tv, tf =>
      let tv' : List Braid.Var := match op with
        | .havoc d => d :: tv
        | .un d _ a => if tv.contains a then d :: tv else tv.erase d
        | .bin d _ a c => if tv.contains a || tv.contains c then d :: tv else tv.erase d
        | .select d c a e =>
          if tv.contains c || tv.contains a || tv.contains e then d :: tv else tv.erase d
        | .getf d f => if tf.contains f then d :: tv else tv.erase d
        | .const d _ | .get d _ | .load d _ _ => tv.erase d
        | _ => tv
      let tf' : List Nat := match op with
        | .setf f a => if tv.contains a then f :: tf.erase f else tf.erase f
        | _ => tf
      match op with
      | .havoc d => go ops (ρ.set d 0#64) σ tv' tf'
      | _ => (op.exec ρ σ).bind fun (ρ', σ') => go ops ρ' σ' tv' tf'
  (go b.ops (fun _ => 0#64) σ [] tf).bind fun (ρ, σ', tf') =>
    (b.term.exec ρ σ').map fun σ'' => (σ'', tf')

/-- How a run of the two sides ended. -/
inductive Verdict where
  | agree (steps : Nat) (result : Word)
  | outOfFuel (steps : Nat)
  | bothStop (steps : Nat) (pc : Word)
  | mismatch (steps : Nat) (pc : Word) (what : String)

def hex (w : Word) : String := s!"0x{Braid.hex w.toNat}"

/-- The first register or defined flag on which two `braid` states differ. -/
def firstDiff (arch : Braid.Arch) (nregs nflags : Nat) (tf : List Nat) (m σ : Braid.State) :
    Option String :=
  if m.pc != σ.pc then some s!"pc: machine {hex m.pc}, braid {hex σ.pc}"
  else
    ((List.range nregs).findSome? fun r =>
      if m.regs r != σ.regs r then
        some s!"{arch.regName r}: machine {hex (m.regs r)}, braid {hex (σ.regs r)}"
      else none).orElse fun _ =>
    (List.range nflags).findSome? fun f =>
      if !tf.contains f && m.flags f != σ.flags f then
        some s!"{arch.flagName f}: machine {m.flags f}, braid {σ.flags f}"
      else none

/-- Where the stack pointer starts, and the return address of the function under test. -/
def stackTop : Word := 0x70000000#64
def sentinel : Word := 0x7ff00000#64

/-! ## x86-64 -/

namespace X86

open Lowering.X86

/-- One step of the model, with every undefined value zero; `none` where it faults. -/
partial def resolve : Effects → Option MachineState
  | .done s => some s
  | .require_read_access _ ok => resolve (ok ())
  | .require_write_access _ ok => resolve (ok ())
  | .require_exec_access _ ok => resolve (ok ())
  | @Effects.undefined _ t cont => resolve (cont (t.from_hash 0))
  | _ => none

/-- The machine at the entry of a function called with `args`: a stack of 4096 mapped bytes
below the stack pointer, with the return address on top. -/
def initMachine (entry : Nat) (args : List Word) : MachineState :=
  let argRegs : List Reg64 := [.rdi, .rsi, .rdx, .rcx, .r8, .r9]
  let regs := (argRegs.zip args).foldl (fun r (x, v) => r.set64 x v) ({} : Reg64s)
  let regs := regs.set64 .rsp stackTop
  let dmem : DataMem := (List.range 4352).foldl
    (fun m i => m.insert (stackTop - 4096#64 + BitVec.ofNat 64 i) 0) ∅
  let dmem := Mem.storeInt dmem stackTop 8 sentinel.toNat
  { data := { regs, dmem }, pc := .ofNat entry }

def run (e : Executable) (P : Braid.Program) :
    Nat → Nat → MachineState → Braid.State → List Nat → Verdict
  | 0, n, _, _, _ => .outOfFuel n
  | fuel + 1, n, m, σ, tf =>
    if m.pc.toBitVec == sentinel then .agree n (m.data.regs.get64 .rax)
    else
      match resolve (Executable.step e m .done), (P σ.pc).bind (execBlock · σ tf) with
      | some m', some (σ', tf') =>
        match firstDiff arch 16 7 tf' (abs m') σ' with
        | some d => .mismatch n σ.pc d
        | none =>
          -- Where the lowering leaves a flag undefined, go on with the model's value.
          run e P fuel (n + 1) m' { σ' with flags := (abs m').flags } tf'
      | none, none => .bothStop n σ.pc
      | some _, none => .mismatch n σ.pc "the machine steps, the lowered code faults"
      | none, some _ => .mismatch n σ.pc "the lowered code steps, the machine faults"

end X86

/-! ## AArch64 -/

namespace Arm

open Lowering.Arm

/-- The machine at the entry of a function called with `args`: the code mapped read-execute,
a stack of 4096 bytes mapped read-write, and the return address in the link register. -/
def initMachine (base : Nat) (code : List (BitVec 8)) (entry : Nat) (args : List Word) :
    Arm64.State :=
  let codeArr := code.toArray
  let cells : BitVec 64 → Option (Option Arm64.Perm × BitVec 8) := fun a =>
    let off := a.toNat - base
    if base ≤ a.toNat ∧ off < codeArr.size then
      some (some { r := true, w := false, x := true }, codeArr[off]!)
    else if stackTop.toNat - 4096 ≤ a.toNat ∧ a.toNat < stackTop.toNat + 256 then
      some (some { r := true, w := true, x := false }, 0#8)
    else none
  let s : Arm64.State := { mem := { cells }, pc := BitVec.ofNat 64 entry, sp := stackTop }
  let s := s.writeReg64 (.gpr 30#5) sentinel
  (List.range args.length |>.zip args).foldl
    (fun s (i, v) => s.writeReg64 (.gpr (BitVec.ofNat 5 i)) v) s

def run (prog : Arm64.Program) (P : Braid.Program) :
    Nat → Nat → Arm64.State → Braid.State → Verdict
  | 0, n, _, _ => .outOfFuel n
  | fuel + 1, n, s, σ =>
    if s.pc == sentinel then .agree n (s.regs.read 0#5)
    else
      let next := (prog.fetchMem s.mem s.pc).map fun i => prog.evalInst i s
      let next := next.filter fun s' => s'.status == .Running
      match next, (P σ.pc).bind (execBlock · σ []) with
      | some s', some (σ', _) =>
        match firstDiff arch 32 4 [] (abs s') σ' with
        | some d => .mismatch n s.pc d
        | none => run prog P fuel (n + 1) s' σ'
      | none, none => .bothStop n s.pc
      | some _, none => .mismatch n s.pc "the machine steps, the lowered code faults"
      | none, some _ => .mismatch n s.pc "the lowered code steps, the machine faults"

end Arm

end Tools.DiffTest
