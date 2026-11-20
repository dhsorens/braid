/-
  Braid.Logic.Traced

  A traced triple whose trace the run finds. A theorem of what a piece of code reveals has
  two parts: the labels of its run, and the proof that the run leaves them. Stated as a
  `TripleT`, the first part is written out before the proof starts, label by label, and has
  to be written again whenever the code changes its loads and stores. Here the statement
  leaves it open:

  ```
  def f_run (p q : Word) : { ls : Trace // ∀ (x y : Word) (t : Trace),
      TripleT f.program (pre p q x y) t (post p q x y) (t ++ ls) } := by
    braid_traced
    intro x y t
    braid_sym_run
    braid_done
  ```

  `braid_traced` opens the pair, leaving the trace as a value to be found, and `braid_done`
  finds it: the labels the stepper has added to the trace, gathered into one list.
  `(f_run p q).1` is then the trace of `f` and `(f_run p q).2` the traced triple, to be used
  with `braid_call` like any other.

  What the trace may depend on is what is bound before the pair: `p` and `q` above, and
  not `x` and `y`. A run whose labels mention `x` cannot be closed, since the value to be
  found is not in the scope of `x`. So the binders of a definition of this form are the
  public inputs of its code, and that the trace is a function of them alone is checked
  when the definition is.

  A loop is a definition by recursion on the number of turns left, as its triple is a proof
  by induction: the case for one more turn runs the body and calls the definition for the
  turns that remain, and the trace found is the labels of one turn before the trace of the
  rest.

  ## Main definitions

  * `braid_traced`: open a definition of a trace with its traced triple
  * `braid_done`, again: finish, and find the trace that was left open
-/

module

public import Braid.Logic.Tactic

public section

namespace Braid

/-- Open a definition of the form `{ ls : Trace // … TripleT P pre t post (t ++ ls) }`: the
goal becomes the traced triple, with the trace `ls` left to be found by `braid_done`. -/
macro "braid_traced" : tactic => `(tactic| apply Subtype.mk)

/-- Find the trace a run has left: the goal is `t ++ [l₁] ++ … ++ [lₙ] = t ++ ?ls`, with the
labels added one at a time and with the traces of the triples that were called, and `?ls`
becomes the list of them. -/
macro "braid_trace_find" : tactic =>
  `(tactic| first
      | rfl
      | (simp only [List.append_assoc, List.cons_append, List.nil_append]; rfl))

/-- Finish a traced triple whose trace was left open by `braid_traced`: the symbolic state
is the postcondition, and the trace to be found is the one the run has left. -/
macro_rules
  | `(tactic| braid_done) =>
    `(tactic| (braid_norm
               first
                 | (refine TripleT.done_eq rfl ?_; braid_trace_find)
                 | (refine TripleT.done_split ?_ ?_
                    · braid_split; done
                    · braid_trace_find)))

end Braid
