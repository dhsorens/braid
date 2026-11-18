/-
  Braid.Pass.Simplify

  The passes, put together for a function: fuse each straight-line chain of blocks into one
  block, remove the flag writes each block overwrites, and remove the operations whose
  results nothing reads.

  Each pass is proved at the level of programs (`Program.fuseAt_eventually`,
  `Program.dse_eventually`, `Program.dce_eventually`): what every run of the simplified
  program reaches, every run of the original reaches. `Func.simplify` is the driver that
  chooses which blocks to fuse in a function, for the text the decompiler prints. A block is
  fused into its predecessor, and dropped, only when that predecessor is the one place that
  jumps to it.

  ## Main definitions

  * `Program.fuseAll`: fuse at each address of a list, with `Program.fuseAll_eventually`
  * `Func.fuse`, `Func.simplify`: the driver for a function
-/

module

public import Braid.Pass.DeadFlags

@[expose] public section

namespace Braid

/-- The program fused at each address of a list, in order. -/
def Program.fuseAll (P : Program) (as : List Word) : Program := as.foldl Program.fuseAt P

/-- Runs of a program fused at several addresses are runs of the original. -/
theorem Program.fuseAll_eventually (P : Program) (as : List Word) {Q : State → Prop}
    {σ : State} (h : Eventually (P.fuseAll as) Q σ) : Eventually P Q σ := by
  induction as generalizing P with
  | nil => exact h
  | cons a as ih => exact P.fuseAt_eventually a (ih (P.fuseAt a) h)

/-- The addresses a terminator may jump to. -/
def Term.targets : Term → List Word
  | .jump a => [a]
  | .branch _ t e => [t, e]
  | _ => []

/-- One fusion in a function: the first block that ends in a jump to a block nothing else
jumps to, and that is not the entry, takes that block in. `none` when there is none. -/
def Func.fuseStep (f : Func) : Option Func :=
  let preds (t : Word) := (f.blocks.flatMap fun ab => ab.2.term.targets).count t
  (f.blocks.findSome? fun (a, A) =>
    match A.term with
    | .jump t =>
      if t != a && t != f.entry && preds t == 1 then
        (f.blocks.find? (·.1 == t)).map fun (_, B) => (a, t, A.seq B)
      else none
    | _ => none).map fun (a, t, AB) =>
      { f with blocks := f.blocks.filterMap fun (x, X) =>
          if x == t then none else if x == a then some (x, AB) else some (x, X) }

/-- Fuse the straight-line chains of a function, at most `n` fusions. -/
def Func.fuseN (f : Func) : Nat → Func
  | 0 => f
  | n + 1 => match f.fuseStep with
    | some g => g.fuseN n
    | none => f

/-- Fuse every straight-line chain of a function. -/
def Func.fuse (f : Func) : Func := f.fuseN f.blocks.length

/-- A function with its chains fused, its overwritten flag writes removed, and its dead
operations removed. -/
def Func.simplify (f : Func) : Func := f.fuse.dse.dce

end Braid
