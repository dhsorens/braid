/-
  Examples.Sha256.RiscV.LeakBase

  What the proofs of what SHA-256 reveals share (`docs/Leakage.md`). The trace of SHA-256
  does not depend on the words it works on, so a traced triple about it does not say what
  those words are: its postcondition keeps where the arrays are and forgets what is in them
  (`Braid.Logic.Any`). This file has what the loop of the message schedule reveals, and the
  tactics the proofs use.

  ## Main definitions

  * `scheduleLoopLeak`: what the loop of the message schedule reveals
  * `sha256_forget_mem`, `sha256_name_mem`, `sha256_forget_cells`, `sha256_trace`,
    `sha256_done`: tactics
-/

module

public import Examples.Sha256.RiscV.Image
public import Examples.Sha256.RiscV.Machine
public import Examples.Sha256.RunTo
import Iris.BI.DerivedLaws

@[expose] public section

namespace Examples.Sha256.RiscV

open Braid Lowering.RiscV RiscvZkvm.Rv64
open Iris Iris.BI

/-! ## What the message schedule reveals

`sha256_schedule` and the copy of it that the compiler put in `sha256_compress` are the same
loop at different addresses, so what it reveals is defined once. -/

/-- What one iteration of the loop of the message schedule reveals, filling the cell at `a`:
the four words of the window it reads, the cell it writes, and where its branch goes. -/
def scheduleStepLeak (a next : Word) : Trace :=
  [.read (a - 8#64) 4, .read (a - 28#64) 4, .read (a - 60#64) 4, .read (a - 64#64) 4,
    .write a 4, .jump next]

/-- What the loop of the message schedule reveals, with `n + 1` cells to fill from `a` on:
each iteration goes back to `head`, but for the last, which goes on to `exit`. -/
def scheduleLoopLeak (head exit : Word) (a : Word) : Nat → Trace
  | 0 => scheduleStepLeak a exit
  | n + 1 => scheduleStepLeak a head ++ scheduleLoopLeak head exit (a + 4#64) n

/-! ## Tactics -/

/-- Forget the value of the cell of memory at an address: `sha256_forget_mem a`. -/
macro "sha256_forget_mem " a:term : tactic =>
  `(tactic| (refine TripleT.forget_mem (a := $a) (by braid_upd) ?_))

/-- Name the value of the cell of memory at an address, which holds some value:
`sha256_name_mem a`. -/
macro "sha256_name_mem " a:term : tactic =>
  `(tactic| (refine TripleT.mem_any (a := $a) (by braid_extract) ?_
             intro _))

/-- Forget the contents of the array at an address, of a given number of cells, with a proof
that it has that many: `sha256_forget_cells p, n, h`. -/
macro "sha256_forget_cells " p:term ", " n:term ", " h:term : tactic =>
  `(tactic| (refine TripleT.forget_cells (p := $p) $n (by braid_upd) $h ?_))

/-- Prove that the trace a run has left is the trace a specification gives, by gathering
the labels into one list. Unlike `braid_trace` it does not try `rfl` first, which does not
come back on a trace of some twenty labels. -/
macro "sha256_trace" : tactic =>
  `(tactic| (simp only [List.append_assoc, List.cons_append, List.nil_append, List.append_nil]))

/-- Finish a traced triple: the symbolic state is the postcondition in some order, and the
trace is the one specified. -/
macro "sha256_done" : tactic =>
  `(tactic| (braid_norm
             refine TripleT.done_split ?_ ?_
             · braid_split
             · first | sha256_trace | with_reducible rfl))

end Examples.Sha256.RiscV
