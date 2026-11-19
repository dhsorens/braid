/-
  Examples.Sha256.RunTo

  `braid_sym_run_to a`: the stepper's `braid_sym_run`, stopping when the program counter is
  `a`. `braid_sym_run` stops only where it cannot go on, and a loop that the proof takes by
  induction starts at an address it can run through; this stops at the head of the loop. It
  belongs in `Braid.Logic.Sym.Step`, and uses only what that file exports.

  ## Main definitions

  * `braid_sym_run_to`: run blocks until the program counter is a given address
-/

module

public import Braid.Logic.Sym.Step
public meta import Braid.Logic.Sym.Step

public meta section

namespace Examples.Sha256

open Lean Meta Elab Tactic Braid.Sym

/-- The program counter of the symbolic state of a goal, when it is a literal. -/
def pcOf (g : MVarId) : MetaM (Option Nat) := g.withContext do
  try
    let (_, pre, _) ← tripleParts g
    let_expr Braid.Atoms.interp as := pre | return none
    let A ← AtomList.parse as
    let some (_, args) ← A.find ``Braid.Atom.pc fun _ => pure true | return none
    let some ⟨_, v⟩ ← getBitVecValue? args[0]! | return none
    return some v.toNat
  catch _ => return none

/-- Run blocks until the program counter is `a`, or a step cannot be taken, or a branch goes
both ways. -/
elab "braid_sym_run_to_core " a:num : tactic => do
  let stop := a.getNat
  let N ← Norm.make
  let T ← IO.mkRef none
  let mut g ← getMainGoal
  let mut hyp : Option FVarId := none
  let tbl? ← try some <$> (do tableOf T (← tripleParts g).1) catch _ => pure none
  if let some tbl := tbl? then
    if let some pf := tbl.table? then
      let ty := mkApp2 (mkConst ``Braid.Sym.Rule.Table) tbl.P tbl.l
      let (fv, g') ← (← g.assert `braid_table ty pf).intro1
      T.set (some { tbl with table? := some (mkFVar fv) })
      g := g'
      hyp := some fv
  let mut out := [g]
  repeat
    if (← pcOf g) == some stop then break
    match ← tryStep N T g with
    | .ok [g'] => g := g'; out := [g']
    | .ok gs => out := gs; break
    | .error _ => break
  if let some fv := hyp then
    out ← out.mapM fun g => do try g.clear fv catch _ => pure g
  replaceMainGoal out

/-- Run blocks until the program counter is `a`: `braid_sym_run_to 0x10164`. -/
macro "braid_sym_run_to " a:num : tactic =>
  `(tactic| (braid_norm; braid_sym_run_to_core $a))

end Examples.Sha256
