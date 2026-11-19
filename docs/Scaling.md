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

Times are processor seconds (user and system), not wall-clock, so that they do not depend on
what else the machine is doing. Read them for their shape, not their last digit: starting
Lean costs about a second, and at N = 10 the proof costs less than the noise in that.

## Results

Milliseconds per instruction, and in brackets the seconds for the whole proof.

| | N = 10 | N = 100 | N = 1000 |
| --- | --- | --- | --- |
| AArch64, `braid_run` (before) | 60 (0.6) | 94 (9.4) | does not finish |
| AArch64, `braid_sym_run` | under 10 | 3 (0.3) | 2 (2) |
| x86-64, `braid_run` (before) | 270 (2.7) | 346 (35) | does not finish |
| x86-64, `braid_sym_run` | under 10 | 7 (0.7) | 11 (11) |

An x86-64 instruction costs more than an AArch64 one because it lowers to more operations:
most of them write six flags.

Before, the 1000-instruction case failed in three places. Lean's elaborator ran out of
recursion depth on a list of a thousand blocks, and on the `decide` that certifies it, so the
image did not check; and `braid_run` on it ran for more than an hour and then ran out of
recursion depth too.

The steps between the two rows, on the 1000-instruction case:

| Change | AArch64 | x86-64 |
| --- | --- | --- |
| The stepper, with blocks found by evaluating the program | 28 s | 49 s |
| Blocks found in a sorted table | 1.1 s | 26 s |
| Undefined flags without a quantifier | 2 s | 11 s |

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
- The blocks of the program are read into a table once for a run.

The rules it applies are restatements of the rules of the logic (`Sym/Rule.lean`), and the
kernel checks the finished term, so the stepper adds nothing to what is trusted.

The older tactics remain, and the proofs of the first examples still use them.

### Long functions in the decompiler

`braid-lower` writes a function of more than 128 blocks as several definitions of 128 blocks
each, appended, and certifies it with `decide +kernel`, which asks the kernel alone. Shorter
functions are written exactly as before.

### Finding a block without a search

With the stepper in place, nearly all the time left was the kernel's: of 28 seconds for the
AArch64 run, under one was spent building the proof. The kernel was checking each
`P p = some b` by evaluating the program, which compares `p` with the address of each block
in turn, and a comparison of two 64-bit words by `decide` is slow in the kernel.

A lowered function's blocks are in address order. `Rule.Table P l` says that `P` is the
program of the list `l` and that the addresses in `l` are strictly increasing, and it is
proved once for a run, by evaluation, which is linear. From it, `P e.1 = some e.2` follows
for any entry `e` that is in `l`, and membership is a short proof term, not a search: a few
steps to the part of the list the entry is in, and at most 128 within the part.

### Undefined flags without a quantifier

An instruction that leaves a flag undefined lowers to `havoc d`, `setf f d`. The rule for
`havoc` puts the rest of the proof under a quantifier over the value of `d`. On x86-64 most
instructions leave a flag undefined, so the proof of a long run sat under thousands of
quantifiers, and Lean abstracts the whole of the rest of the proof once for each: quadratic.
When nothing later in the block reads `d`, `Rule.havoc_setf` runs the pair with no
quantifier, and the flag holds some value (`flagAny`) afterwards. The stepper's loop itself
took 4 of the 20 seconds; the rest was assembling the proof.

### Arrays (`braid/Braid/Logic/Cells.lean`)

`cellsAt k w p vs` is an array of cells of `k` bytes, writable or read-only, which covers
arrays of 32-bit values and tables in read-only data. `cellsAt_index` opens an array at an
index that need not be a literal, into the cells before, the cell itself as a memory atom,
and the cells after, so a loop can read or write `a[i]`. `Flat` writes out a state with
several arrays in it as points-to atoms, which is what a theorem about a machine starts from.

## What is still superlinear

On x86-64 the cost of an instruction still rises a little with N (7 ms at N = 100 and 11 ms
at N = 1000). It is not yet profiled.

## Limits met in the instruction-set models

None so far.
