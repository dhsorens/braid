/-
  Examples.Sha256.Arm.LeakBase

  What the proofs of what SHA-256 reveals on AArch64 share (`docs/Leakage.md`). The trace of
  SHA-256 does not depend on the words it works on, so a traced triple about it does not say
  what those words are: its postcondition keeps where the arrays are and forgets what is in
  them (`Braid.Logic.Any`). This file has what the loop of the message schedule reveals, an
  array of forgotten contents opened at an index, which is how the compiled loops address
  their arrays, and the tactics the proofs use. `cellsAny_add` and `cellsAny_index` belong in
  `Braid.Logic.Any`.

  ## Main definitions

  * `scheduleLoopLeak`: what the loop of the message schedule reveals
  * `sha256_trace`, `sha256_done`: tactics

  ## Main results

  * `cellsAny_add`: an array of forgotten contents, as two
  * `cellsAny_index`: an array of 32-bit cells of forgotten contents, opened at an index
-/

module

public import Examples.Sha256.Arm.Image
public import Examples.Sha256.Arm.Machine
public import Examples.Sha256.RunTo
import Iris.BI.DerivedLaws

@[expose] public section

namespace Examples.Sha256.Arm

open Braid Lowering.Arm
open Iris Iris.BI

/-! ## What the message schedule reveals

`sha256_schedule` and the copy of it that the compiler put in `sha256_compress` are the same
loop at different addresses, so what it reveals is defined once. -/

/-- What one iteration of the loop of the message schedule reveals, filling the cell at `a`:
the four words of the window it reads, the cell it writes, and where its branch goes. -/
def scheduleStepLeak (a next : Word) : Trace :=
  [.read (a - 8#64) 4, .read (a - 28#64) 4, .read (a - 64#64) 4, .read (a - 60#64) 4,
    .write a 4, .jump next]

/-- What the loop of the message schedule reveals, with `n + 1` cells to fill from `a` on:
each iteration goes back to `head`, but for the last, which goes on to `exit`. -/
def scheduleLoopLeak (head exit : Word) (a : Word) : Nat → Trace
  | 0 => scheduleStepLeak a exit
  | n + 1 => scheduleStepLeak a head ++ scheduleLoopLeak head exit (a + 4#64) n

/-! ## An array of forgotten contents, opened at an index -/

/-- An array of `m + n` cells of forgotten contents is one of `m` cells and then one of `n`
cells. -/
theorem cellsAny_add {k : Nat} {w : Bool} (p : Word) (m n : Nat) :
    cellsAny k w p (m + n) =
      iprop(cellsAny k w p m ∗ cellsAny k w (p + BitVec.ofNat 64 (k * m)) n) := by
  induction m generalizing p with
  | zero =>
    have e : p + BitVec.ofNat 64 (k * 0) = p := by simp
    rw [Nat.zero_add, e]
    exact SProp.ext emp_sep.symm
  | succ m ih =>
    rw [Nat.add_right_comm]
    simp only [cellsAny, ih, cells_addr_succ]
    exact SProp.ext sep_assoc.symm

/-- **An array of 32-bit cells of forgotten contents, opened at index `t`**: the `t` cells
before, cell `t` at the offset `4 * t`, and the `m` cells after. -/
theorem cellsAny_index (w : Bool) (p : Word) (t m n : Nat) (h : n = t + (m + 1)) :
    (Atom.prop (cellsAny 4 w p n)).interp =
      Atoms.interp [.prop (cellsAny 4 w p t),
        .prop (memAny (p + BitVec.ofNat 64 (4 * t)) 4 w),
        .prop (cellsAny 4 w (p + BitVec.ofNat 64 (4 * (t + 1))) m)] := by
  subst h
  show cellsAny 4 w p (t + (m + 1)) = _
  rw [cellsAny_add]
  simp only [cellsAny, cells_addr_next, Atoms.interp_cons, Atoms.interp_nil, Atom.interp]
  exact SProp.ext ⟨sep_mono_right (sep_mono_right sep_emp.2),
    sep_mono_right (sep_mono_right sep_emp.1)⟩

/-! ## Tactics -/

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

end Examples.Sha256.Arm
