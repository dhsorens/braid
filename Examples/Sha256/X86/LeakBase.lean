/-
  Examples.Sha256.X86.LeakBase

  What the proofs of what SHA-256 reveals on x86-64 share (`docs/Leakage.md`). The trace of
  SHA-256 does not depend on the words it works on, so a traced triple about it does not say
  what those words are: its postcondition keeps where the arrays are and forgets what is in
  them (`Braid.Logic.Any`). This file has what the loop of the message schedule reveals, and
  the tactics the proofs use.

  ## Main definitions

  * `scheduleStepLeak`, `scheduleLoopLeak`: what the loop of the message schedule reveals
  * `sha256_leak_trace`, `sha256_leak_done`: tactics

  ## Main results

  * `tripleT_reg_val`: give a register of a traced triple an equal value
-/

module

public import Examples.Sha256.X86.Image
public import Examples.Sha256.X86.Machine
public import Examples.Sha256.RunTo
public import Braid.Logic.Any

@[expose] public section

namespace Examples.Sha256.X86

open Braid Lowering.X86

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

/-! ## Values of the symbolic state -/

/-- Replace the value of a register of the symbolic state of a traced triple by an equal
one: `Triple.reg_val`, with a trace. -/
theorem tripleT_reg_val {P : Braid.Program} {as as' : Atoms} {r : Reg} {v : Word} (v' : Word)
    {Q : SProp} {t t' : Trace} (hupd : as.Upd (.reg r v) (.reg r v') as') (he : v = v')
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  subst he
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h

/-! ## Tactics -/

/-- Prove that the trace a run has left is the trace a specification gives, by gathering
the labels into one list. Unlike `braid_trace` it does not try `rfl` first, which does not
come back on a long trace. -/
macro "sha256_leak_trace" : tactic =>
  `(tactic| (simp only [List.append_assoc, List.cons_append, List.nil_append, List.append_nil]))

/-- Finish a traced triple: the symbolic state is the postcondition in some order, and the
trace is the one specified. -/
macro "sha256_leak_done" : tactic =>
  `(tactic| (braid_norm
             refine TripleT.done_split ?_ ?_
             · braid_split
             · first | sha256_leak_trace | with_reducible rfl))

end Examples.Sha256.X86
