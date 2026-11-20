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
  * `braid_done_traced n`: the same, taking the `n` atoms of a large state one at a time
  * `braid_done_long n`: the same, for a run of seventy labels or more
-/

module

public import Braid.Logic.Tactic

public section

namespace Braid

/-- Open a definition of the form `{ ls : Trace // … TripleT P pre t post (t ++ ls) }`: the
goal becomes the traced triple, with the trace `ls` left to be found by `braid_done`. -/
macro "braid_traced" : tactic => `(tactic| apply Subtype.mk)

/-- The trace a run has left, `x`, is `t` and then some labels, if it is so with no labels
after it: the first step of gathering the labels of a long run. -/
theorem Trace.gather_start {x t ls : Trace} (h : x ++ [] = t ++ ls) : x = t ++ ls := by
  rwa [List.append_nil] at h

/-- The last label the stepper added goes to the front of the labels already gathered. -/
theorem Trace.gather_snoc {x t ls acc : Trace} {l : Label} (h : x ++ l :: acc = t ++ ls) :
    x ++ [l] ++ acc = t ++ ls := by
  rwa [List.append_assoc]

/-- Find the trace a run has left: the goal is `t ++ [l₁] ++ … ++ [lₙ] = t ++ ?ls`, with the
labels added one at a time and with the traces of the triples that were called, and `?ls`
becomes the list of them, or the empty list for a run that left no label. The labels are
gathered before the two sides are compared: comparing them as they stand can unfold a
trace that was called for. A run of some seventy labels or more is too long to gather at
once: `braid_done_long` is for those. -/
macro "braid_trace_find" : tactic =>
  `(tactic| first
      | (simp only [List.append_assoc, List.cons_append, List.nil_append]
         first | done | rfl)
      | exact (List.append_nil _).symm
      | rfl)

/-- Finish a traced triple whose trace was left open by `braid_traced`: the symbolic state
is the postcondition, and the trace to be found is the one the run has left. A traced
triple whose trace is stated closes as it did, by the last two forms. -/
macro_rules
  | `(tactic| braid_done) =>
    `(tactic| (braid_norm
               first
                 | (refine TripleT.done_eq rfl ?_; braid_trace_find)
                 | (refine TripleT.done_split ?_ ?_
                    · braid_split; done
                    · braid_trace_find)
                 | exact TripleT.done_eq rfl (by braid_trace)
                 | (refine TripleT.done_split ?_ (by braid_trace); braid_split; done)))

/-- `braid_done` for a traced triple whose trace is to be found, when the symbolic state is
the `n` atoms of the postcondition in another order and they are best taken out one at a
time, as for a state of thirty atoms or so. -/
macro "braid_done_traced " n:num : tactic =>
  `(tactic| (braid_norm
             refine TripleT.done_split ?_ ?_
             · iterate $n (apply Atoms.Split.cons; · braid_extract)
               exact Atoms.Split.nil
             · braid_trace_find))

/-- `braid_done_traced n` for a long run that called no traced triple: seventy labels or
more, each added by the stepper. The labels are gathered from the last to the first, one
rule for each, so that the trace is not reassociated as a whole. -/
macro "braid_done_long " n:num : tactic =>
  `(tactic| (braid_norm
             refine TripleT.done_split ?_ ?_
             · iterate $n (apply Atoms.Split.cons; · braid_extract)
               exact Atoms.Split.nil
             · apply Trace.gather_start
               repeat apply Trace.gather_snoc
               rfl))

end Braid
