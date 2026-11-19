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
TRACED=1 Examples/scaling/run.sh                 # a traced triple (below)
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

## Proving on simplified code

The simplifier fuses straight-line blocks and removes dead flag writes and dead operations
(`braid/Braid/Pass/`). `Func.simplifyBy` does it by a plan, and is proved whatever the plan
(`Func.simplifyBy_eventually`): runs of the simplified function are runs of the function.
`braid-lower --simplify` uses it for the MLIR it prints. The question here was whether a
proof should run on the simplified function instead of the lowered one.

It should not, as things stand. The benchmark function simplifies to one block, and the
stepper was timed on it, with no certificate that the block is the function simplified:

Milliseconds per instruction, and in brackets the seconds to check the whole file, image and
proof. At N = 10 the proof costs less than the noise in starting Lean, so only the seconds
are given.

| | N = 10 | N = 100 | N = 1000 |
| --- | --- | --- | --- |
| AArch64, lowered | (1.2) | 2.0 (2.1) | 1.8 (6.2) |
| AArch64, simplified | (1.2) | 2.2 (2.3) | 6.5 (13.0) |
| x86-64, lowered | (1.3) | 8.0 (2.8) | 9.5 (18.7) |
| x86-64, simplified | (1.2) | 6.2 (3.0) | stopped after 8 minutes |

Two things are behind this.

- **There is little dead work left to remove.** The stepper already runs an undefined flag
  write without a quantifier, and finds a block in a table, so what fusion saves is a write
  of the program counter for each instruction and, on x86-64, the flag writes the next
  instruction overwrites: a fifth of the time at N = 100, and nothing on AArch64.
- **A long block is slower than many short ones.** An SSA value is looked up by walking the
  environment of the block, which is as long as the block. With a block for each instruction
  the walk is a few steps; in one block of ten thousand operations it is quadratic.

The certificate costs more than that saving. The decompiler can write the simplified function
and the plan beside the lowered one, with a theorem, checked by `decide +kernel`, that the
blocks written are `(f.simplifyBy plan).blocks`. That was built and measured: at N = 100 on
AArch64 checking the certificate took longer than checking the image, and at N = 100 on
x86-64 and N = 1000 on AArch64 the kernel ran out of stack, since fusing a thousand blocks
one after another leaves it a thousand nested appends to evaluate. So `braid-lower` does not
write simplified functions into Lean modules, and proofs run on the lowered function.

What would change this: fusing in bounded stretches (a plan that fuses at most a few dozen
blocks keeps the environment short), with the fused block built by one pass over the stretch
and not by repeated appends, and a certificate for each block. On these numbers that is worth
at most a fifth on x86-64, so it was not done.

## Traced triples

A traced triple (`TripleT`, [`Leakage.md`](Leakage.md)) says what a run reveals as well as
where it ends, and the stepper runs on it as it does on a triple, adding a label to the trace
for each load, store, division, conditional branch and computed jump. The work for an
operation that reveals nothing is the same as before, with one more argument to the rule.
`TRACED=1 Examples/scaling/run.sh` measures it, on the same function.

Milliseconds per instruction, and in brackets the seconds to check the whole file. At
N = 10 the proof costs less than the noise in starting Lean, and at N = 100 the difference
of two measurements of about two seconds is noise within a factor of two. *Before* is the
benchmark before a step of the dialect carried a label. *After* is the benchmark as it is
now, with labels of both kinds (what a step reveals, and events of the environment) and
with `Eventually` and `Triple` derived from the labelled step: the same theorem as before,
and the same function proved with a traced triple.

| | N = 10 | N = 100 | N = 1000 |
| --- | --- | --- | --- |
| AArch64, triple, before | (1.1) | 2.0 (2.1) | 1.7 (5.9) |
| AArch64, triple, after | (1.0) | 1.0 (1.8) | 1.7 (5.5) |
| AArch64, traced triple, after | (1.1) | 2.0 (1.9) | 1.6 (5.6) |
| x86-64, triple, before | (1.2) | 13.0 (3.4) | 9.6 (18.1) |
| x86-64, triple, after | (1.1) | 4.0 (2.6) | 8.6 (16.5) |
| x86-64, traced triple, after | (1.1) | 7.0 (2.6) | 9.1 (17.2) |

Labelled steps cost nothing that can be measured: at N = 1000 a triple costs what it did,
and a traced triple is within 6% of it on both, well inside the factor of 1.5 that was the
limit set for the change. The benchmark function reveals little: one load and one jump, at
its return. A function that touches memory at every other instruction adds a label that
often, and each is one more node of the trace; the ladder below measures that, function by
function.

The benchmark is of AArch64 and x86-64, as it was before labelled steps: its generator
writes assembly for those two, and there is no figure for RISC-V from before to compare
with. On RISC-V the cost is measured on the ladder.

## The ladder

The benchmark is straight-line code. The ladder is real functions of growing size, each
compiled by clang for AArch64 and x86-64 and proved twice on each: a specification, a
triple, and a theorem about the machine model alone, stated against a definition in plain
Lean (`Examples/Spec/`). All of them use the stepper.

| Source | Functions | Instructions, AArch64 / x86-64 | Proofs check in, AArch64 / x86-64 |
| --- | --- | --- | --- |
| `mem.c` | `copy_bytes`, `equal_bytes` | 20 / 24 | 4 s / 5 s |
| `limbs.c` | `add_limbs` | 13 / 16 | 3 s / 4 s |
| `crc32.c` | `crc32` | 16 / 22 | 5 s / 6 s |
| `chacha20.c` | `quarter_round`, `chacha20_block` | 155 / 204 | 17 s / 18 s |
| `sha256.c` | `sha256_round`, `sha256_schedule`, `sha256_compress` | 138 / 202 | 28 s / 23 s |

The times are processor seconds for every proof file of the module on that instruction set,
each of which starts Lean (about a second). The file with the SHA-256 compression function
takes 17 seconds on AArch64 and 13 on x86-64.

What made the two hash functions go through, where the first attempt at a single round did
not finish:

- **Symbolic execution and mathematics apart.** A stretch of code is run to "the registers
  hold this expression of the inputs", and that the expression is the specification's is a
  separate goal over bit-vectors, closed by `bv_decide`: one quarter round deep for
  ChaCha20, one round deep for SHA-256.
- **Loops by induction, with values folded back.** The ten double rounds of ChaCha20, the 48
  steps of the SHA-256 schedule and its 64 rounds are each proved once, for an arbitrary
  iteration, with the state stated as the specification's function of a variable. A term is
  never more than one iteration deep. The copy loops of 8 and 16 iterations are run out.
- **Arrays opened where they are used.** The schedule and the table of round constants are
  `cellsAt` arrays opened at an index that is not a literal; the constants are read-only.

Neither compiler vectorised either hash function, so no proof met an instruction the
lowerings do not cover.

### What the ladder found

- **The stepper found a memory atom only if its address was the same term.** The same sum is
  written `p + 16#64` at type `Word` by one lemma and at `BitVec 64` by another, and prints
  the same. Every rung met this and worked around it. The stepper now falls back to
  comparing addresses up to the unfolding of `Word`; the workarounds in the proofs are
  still there.
- **`braid_sym_run` cannot be told where to stop**, so a proof that takes a loop by
  induction steps to the loop head by hand, or uses the `braid_sym_run_to` of
  `Examples/Sha256/RunTo.lean`, which belongs in the stepper.
- **Three things the stepper does not normalize on x86-64**: `x ^^^ x` after `xor eax, eax`,
  a literal added on the left (`160#64 + (s + 129#64)` after `add rsp, 0xa0`), and an index
  scaled by one. Each leaves an address the next load does not find, and a proof rewrites it.
- **Machine-level statements are long and each module wrote its own helpers**: reading an
  array back out of a postcondition, disjointness of a state with several arrays, a
  read-only `HasBytes` on AArch64, and `bv_omega` failing on the x86-64 model's register
  terms, whose width is not a literal. These are the same lemmas four times over and belong
  in the logic and in one file for each instruction set ([`Roadmap.md`](Roadmap.md)).
- **The x86-64 model has no read-only memory**, so on x86-64 the CRC and SHA-256 tables are
  ordinary memory in the machine-level theorems, with hypotheses that they are apart from
  what the function writes. The triples hold for a read-only table.

## What is still superlinear

On x86-64 the cost of an instruction still rises a little with N (7 ms at N = 100 and 11 ms
at N = 1000). It is not yet profiled.

## Limits met in the instruction-set models

One: the x86-64 model's memory has no permissions, so a table in read-only data cannot be
stated as read-only in a theorem about that machine (above).
