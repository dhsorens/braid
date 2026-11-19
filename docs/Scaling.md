# Scaling

How the cost of a proof grows with the size of the code, what was slow, and what was done
about it. The numbers here are measured, and are measured again after every change that is
meant to move them.

## The benchmark

`Examples/scaling/gen.py` writes a straight-line function of N instructions: a fixed
pseudo-random mix of additions, subtractions, bitwise operations and rotations over eight
registers, then a return. `Examples/scaling/run.sh` assembles it for AArch64 and x86-64,
lowers it with `braid-lower`, and times Lean on two files: the lowered image alone, and the
image with one theorem, a symbolic execution of the function from its entry to its return.
The difference, divided by N, is the cost of one instruction.

```sh
Examples/scaling/run.sh                        # N = 10 100 1000, both instruction sets
TACTIC=braid_run Examples/scaling/run.sh "10 100"   # the older tactic
```

The values in the registers grow as the function runs: after N instructions a register holds
a term about N operations deep. That is deliberate. It is what a hash function does to a
proof, and it is where the first version of the tactics fell over.

Times are wall-clock seconds on one machine (an Apple M-series laptop), so read them for
their shape, not their last digit.

## Results

Milliseconds per instruction, and in brackets the seconds for the whole proof.

| | N = 10 | N = 100 | N = 1000 |
| --- | --- | --- | --- |
| AArch64, `braid_run` (before) | 50 (0.5) | 83 (8.3) | fails after 65 minutes |
| AArch64, `braid_sym_run` | under 5 (0.0) | 2 (0.2) | 30 (30) |
| x86-64, `braid_run` (before) | 240 (2.4) | 344 (34) | fails after 160 minutes |
| x86-64, `braid_sym_run` | under 5 (0.0) | 6 (0.5) | 55 (55) |

At N = 10 the proof takes less time than the noise in starting Lean. An x86-64 instruction
costs more than an AArch64 one because it lowers to more operations: most of them write six
flags.

Before, the image of the 1000-instruction function did not check either: Lean's elaborator
ran out of recursion depth on a list of a thousand blocks, and on the `decide` that certifies
it.

## What was superlinear, and why

Profiling `braid_run` at N = 100 on AArch64 (10.5 seconds):

- **Normalization, 10.3 seconds.** After every operation `braid_norm` ran the simplifier
  over the whole goal: the operations still to run, the SSA environment, and every atom of
  the symbolic state with its value. The goal grows with the values, so each of the N steps
  costs time proportional to N, and the whole run is quadratic. Worse, the simplifier
  revisits terms it has already normalized.
- **Finding the block, 1.6 seconds.** `P p = some b` was proved by `rfl`, which evaluates the
  program, a search down the list of blocks, in the elaborator and again in the kernel. Each
  lookup is linear in the number of blocks, so the run is quadratic here too.
- **Finding an atom** was small: a few applications of a constructor.

## What changed

### The stepper (`braid/Braid/Logic/Sym/`)

`braid_sym_step` and `braid_sym_run` do what `braid_step` and `braid_run` do, but as a
metaprogram that builds the proof term itself. The work for one operation does not depend on
how large the state or its values are:

- An SSA value is looked up by walking the environment, and the proof of the lookup is a
  chain of two lemmas. Nothing is rewritten.
- An atom is found by its register, flag or address, and the proof that it is in the state,
  or that the state with it replaced is the new state, is built directly.
- A new value is normalized by a simplifier call that sees only the top few levels of the
  term. Deeper subterms are replaced by variables first, and put back after. Addresses and
  constants are still folded, which is all later steps need; a deep value is never traversed.
- The blocks of the program are read into a table once for a run. The kernel still checks
  each lookup by evaluation, which it does far faster than the elaborator.

The rules it applies are restatements of the rules of the logic (`Sym/Rule.lean`), and the
kernel checks the finished term, so the stepper adds nothing to what is trusted.

The older tactics remain, and the proofs of the first examples still use them.

### Long functions in the decompiler

`braid-lower` writes a function of more than 128 blocks as several definitions of 128 blocks
each, appended, and certifies it with `decide +kernel`, which asks the kernel alone. Shorter
functions are written exactly as before.

## What is still superlinear

The cost of an instruction still rises with N: 2 ms at N = 100 and 30 ms at N = 1000 on
AArch64. What is left is under measurement; the suspect is the kernel's check of each block
lookup, a linear search, and the next change is to look blocks up by address.

## Limits met in the instruction-set models

None so far.
