# Recompile measurements: raw data

The ladder compiled a second time, at `-O2` (the first level is the `-O1` of
`Examples/build.sh`), and `chacha20.c` and `sha256.c` proved again on the recompiled binaries.
This file is the record the proofs left: what was reused, what was changed, what was new, and
what forced each change. `docs/Continuity.md` is written from it.

Reproduce with

```sh
Examples/build.sh chacha20 && Examples/build.sh sha256   # both levels, all three ISAs
Examples/continuity/recompile.py --time rv x86           # the tables below
```

## The second level

`-O2 -fno-vectorize -ffreestanding -nostdlib -fno-builtin`, with `-mgeneral-regs-only` on
AArch64 and x86-64 as at `-O1`. `-O2`, `-O3` and `-Os` were tried on all five ladder sources
and all three instruction sets; every function lowers at every level with no trap and no
undecoded instruction (`braid-lower --stats`), so no model gap decides the choice. On RISC-V
in particular `-O2` emits none of the word operations the pinned model lacks.

Instructions per function (padding excluded):

| | | `-O1` | `-O2` | `-Os` |
| --- | --- | --- | --- | --- |
| RISC-V | `quarter_round` | 29 | 29 | 29 |
| | `chacha20_block` | 226 | 240 | 226 |
| | `sha256_round` | 57 | 57 | 57 |
| | `sha256_schedule` | 31 | 31 | 31 |
| | `sha256_compress` | 130 | 169 | 54 |
| AArch64 | `quarter_round` | 17 | 17 | 17 |
| | `chacha20_block` | 138 | 162 | 142 |
| | `sha256_round` | 29 | 29 | 29 |
| | `sha256_schedule` | 18 | 18 | 18 |
| | `sha256_compress` | 90 | 105 | 48 |
| x86-64 | `quarter_round` | 21 | 21 | 21 |
| | `chacha20_block` | 179 | 176 | 179 |
| | `sha256_round` | 51 | 51 | 51 |
| | `sha256_schedule` | 25 | 25 | 25 |
| | `sha256_compress` | 118 | 157 | 42 |

`-O3` gives the code of `-O2` for these sources. `-O2` was chosen: it is the level real
libraries ship at, it lowers everywhere, and it changes the two large functions on all three
instruction sets while leaving the three leaf functions byte for byte as they were, so the
measurement has both cases. `-Os` leaves `chacha20_block` unchanged on RISC-V and x86-64; on
`sha256_compress` it does something `-O2` does not (it stops inlining, so the function calls
`sha256_schedule` and `sha256_round`), which would be the test of a rule that links
specifications across calls, and is not measured here.

## What is where

`Examples/build.sh` compiles each ladder source twice (`lower_ladder`). The second level is
lowered into `Examples/<Module>/O2/<ISA>/Image.lean` (namespace `Examples.<Module>.O2.<ISA>`),
with binaries `Examples/bin/<name>.o2.<isa>.elf` and MLIR `Examples/mlir/<name>.o2.<isa>.mlir`.
Regenerating leaves every `-O1` `Image.lean` and `.mlir` file unchanged. All fifteen `-O2`
images are generated (five sources, three instruction sets).

Proofs at `-O2` mirror the layout of `-O1`: `Examples/ChaCha20/O2/<ISA>/{QuarterRound,Round,
Block,Proofs}.lean` and `Examples/Sha256/O2/<ISA>/{Round,Schedule,Compress,Proofs}.lean`.

## Shared files

`Examples/Spec/ChaCha20.lean`, `Examples/Spec/Sha256.lean`, `Examples/ChaCha20/Common.lean`,
`Examples/Sha256/Common.lean` and `Examples/Sha256/RunTo.lean` are imported by the `-O2`
proofs and are unchanged: not a line was edited, and nothing had to be added to them.

Two further kinds of file turned out to be shared, though they are not named so:

- `Examples/Sha256/RiscV/Machine.lean` is per instruction set and independent of the binary
  (`HasCells`, `Apart`, `regLow`, the tactics for a 32-bit value in a 64-bit register). The
  `-O2` proofs import it as it is.
- On RISC-V the ChaCha20 proofs at `-O1` keep their mathematics about the code's 64-bit
  arithmetic in the same files as the symbolic execution (`low_add`, `qr`, `cells16_low` in
  `QuarterRound.lean`; `colsW`, `diagsW`, `innerW`, `low_innerNW` in `Round.lean`;
  `saved_cells`, `low_rounds` in `Block.lean`). The `-O2` proofs import those `-O1` modules
  and use the lemmas unchanged; they do not copy them. A file `ChaCha20/RiscV/Machine.lean`
  holding them, as `Sha256/RiscV/Machine.lean` does, would make that sharing explicit and
  would keep an `-O2` proof from importing an `-O1` image; the `-O1` proofs were not edited
  to make it.

## RISC-V

Lines are lines of Lean without the module header and blank lines. Of the lines of the `-O2`
file: *same* are in the `-O1` file word for word; *renamed* differ from a line of the `-O1`
file only in a register, a number or an address; *changed* replace lines of the `-O1` file
otherwise; *new* have no counterpart. Of the lines of the `-O1` file that are not in the
`-O2` file: *imported* are used through an import of the `-O1` module; *dropped* are not
needed. Times are processor seconds (user and system) of `lake env lean` on the file, on a
machine that was running other builds at the time.

| function | file | `-O1` | `-O2` | same | renamed | changed | new | imported | dropped | `-O1` s | `-O2` s |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `quarter_round` | `QuarterRound.lean` | 189 | 79 | 72 | 0 | 7 | 0 | 110 | 0 | 3.1 | 3.7 |
| `chacha20_block` | `Round.lean` | 402 | 144 | 78 | 60 | 5 | 1 | 259 | 0 | 10.8 | 9.8 |
| `chacha20_block` | `Block.lean` | 474 | 320 | 249 | 22 | 47 | 2 | 156 | 0 | 16.6 | 6.2 |
| `sha256_round` | `Round.lean` | 104 | 105 | 101 | 0 | 3 | 1 | 0 | 0 | 5.9 | 6.0 |
| `sha256_schedule` | `Schedule.lean` | 133 | 134 | 130 | 0 | 3 | 1 | 0 | 0 | 3.8 | 4.8 |
| `sha256_compress` | `Compress.lean` | 505 | 649 | 272 | 91 | 96 | 190 | 0 | 46 | 26.7 | 24.7 |

The few *changed* lines of the first, fourth and fifth rows are the `namespace`, `import`,
`open` and `end` lines.

Theorems that check at `-O2` on RISC-V (`lake build Examples.ChaCha20.O2.RiscV.Proofs
Examples.Sha256.O2.RiscV.Proofs`, no warnings, no `sorry`, no `set_option`):

- `quarter_round_spec`, `quarter_round_correct`
- `columns_spec`, `diagonals_spec`, `double_round_spec`, `rounds_spec`, `block_head_spec`,
  `block_tail_spec`, `chacha20_block_spec`, `chacha20_block_correct`
- `sha256_round_spec`, `sha256_round_correct`
- `sha256_schedule_loop`, `sha256_schedule_spec`, `sha256_schedule_correct`
- `compress_schedule_loop`, `compress_round_step`, `compress_rounds_loop`,
  `compress_head_spec`, `compress_rounds_spec`, `compress_tail_spec`,
  `sha256_compress_spec`, `sha256_compress_correct`

### What the compiler changed, and what each change cost

**Nothing** (`quarter_round`, `sha256_round`, `sha256_schedule`). Same instructions at the
same addresses. The proof is the same text about another constant: the statement names
`quarter_round.program` of the `-O2` image where it named that of the `-O1` image. Cost: a
copy of the file with four lines changed. The copy is needed only because a theorem is about
a named image; the two images are equal as lists of instructions, and a lemma `code₂ = code₁`
proved by `rfl` would let the `-O1` theorem be restated with no proof at all.

**Registers renamed, code moved** (the loop of ten double rounds in `chacha20_block`; the
loop of the schedule inside `sha256_compress`). The 161 instructions of a ChaCha20 double
round at `-O2` are those of `-O1` under a permutation of sixteen registers
(`s0 s2 s3 s1 t6 t0 t1 t3 a5 a6 a3 a4 t2 t4 t5 a7` become
`s0 s1 s3 s2 t6 t3 t4 t5 t2 a6 a5 a4 a7 t0 t1 a3`), 32 bytes lower. The mathematics is
stated by position, not by register (`colsW` takes sixteen words and returns sixteen), so
all of it is imported unchanged: 259 lines. The four triples (`columns_spec`,
`diagonals_spec`, `double_round_spec`, `rounds_spec`) were not rewritten by hand: a
twenty-line script applied the permutation to every `.reg r` and `regAny r` of the `-O1`
statements and replaced four addresses, and the proof scripts under them check word for word
(60 renamed lines, 78 same). The schedule loop inside `sha256_compress` is the same
instructions with the same registers at other addresses: two addresses replaced, proof
unchanged.

**Registers renamed, with other temporaries** (a round inside `sha256_compress`). The eight
working variables and three pointers move to other registers; the five registers for
intermediate values are others and are not reused in the same pattern (the map from `-O1`
registers to `-O2` registers is not a function), and two sums are associated differently.
The statement of `compress_round_step` and `compress_rounds_loop` was again produced from
the `-O1` text by a renaming, here of register names in atoms and of register numbers in the
tactic calls (`sha256_low 7` becomes `sha256_low 18`), and the proof scripts check unchanged
otherwise: they say `braid_sym_run` and then give each register its specified value by
`bv_decide`, which does not care which temporaries were used or how a sum was associated.
A proof that had written the intermediate expressions out, as the ChaCha20 loop does, would
not have survived this.

**Loops removed, frame changed** (the rest of both functions). At `-O2` `chacha20_block`
keeps no copy of the state on the stack: the loop that copied the input and the loop that
added it are gone, replaced by sixteen loads and by sixteen load-add-store triples, and the
frame is 48 bytes where it was 112. `sha256_compress` loses its three copying loops and its
adding loop in the same way, keeps the hash value in eight registers, saves ten callee-saved
registers where it saved three, and has a frame of 336 bytes where it had 320. These parts
were rewritten by hand, and this is where the *changed* and *new* lines are:

- the specification itself changes, because it names what the function touches below the
  stack pointer: `chacha20_block_spec` loses the sixteen cells of the frame copy (`fr`), and
  `sha256_compress_spec` loses the eight cells of working variables (`fvs`) and has ten
  saved double words where it had three. The `_correct` theorems change with them: fewer
  hypotheses about the stack, other distances in the `Apart` hypotheses, more registers
  restored in the conclusion. A caller that had framed the old stack footprint would have to
  be touched.
- `sha256_compress_spec` at `-O1` leaves `a0` at the end of the hash value and says so; at
  `-O2` the code leaves `a0` as it was. A specification that says `regAny` of every
  caller-saved register would not have noticed.
- the address of the round constants moves from `0x10368` to `0x10404`, because the code
  before the table grew. It is a literal in the statement in both proofs.
- the proof scripts lose their `iterate 15 loop_again` and gain nothing in exchange: where a
  loop was unrolled, a line of `braid_sym_run_to` runs it.
- one declaration no longer fits. `sha256_compress_spec` at `-O1` is one theorem that runs
  the whole function. At `-O2`, with ten saved cells to fold back, the same script reached
  the default limit on heartbeats, and the function is proved as three triples
  (`compress_head_spec`, `compress_rounds_spec`, `compress_tail_spec`) and their
  composition. This accounts for most of the 190 new lines: three statements instead of
  one. Nothing in the logic was missing; the cut points were chosen by hand (the end of the
  schedule, the end of the rounds).
- a list literal of 33 atoms elaborates differently from one of 28 (Lean splits long list
  literals into chunks bound by `let`), and the precondition of `sha256_compress_spec` is
  written with five leading `::` to stay under the limit. This is an accident of scale, not
  of the recompile, but the recompile is what crossed it.

**What did not change at all**: the specifications in `Examples/Spec`, the shared lemmas,
every lemma that connects the code's arithmetic to the specification, the induction that
proves each loop (its statement is renamed, its proof is not touched), and the whole proof
that carries a triple down to the machine (`machine_sound_flat` and the disjointness
argument), apart from following the change of the frame.

### Where the lines went, in sum

Over the five functions on RISC-V the `-O1` proofs are 1807 lines and the `-O2` proofs 1431.
Of the `-O2` lines 902 (63%) are the `-O1` text word for word, 173 (12%) are the `-O1` text
with a register, a number or an address replaced, 161 (11%) are changed otherwise and 195
(14%) are new; a further 525 lines of `-O1` are reused through an import. The changed and
new lines are almost all in two places: the statements of the triples for the parts of the
two large functions whose structure changed, and the lists of registers and stack cells in
the two `_correct` theorems.

## x86-64 and AArch64

### x86-64: the loop of `chacha20_block` (done), the rest (not done)

| function | file | `-O1` | `-O2` | same | renamed | changed | new | imported | dropped | `-O1` s | `-O2` s |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `chacha20_block` | `Round.lean` | 378 | 352 | 113 | 124 | 51 | 64 | 0 | 90 | 6.1 | 6.5 |

`Examples/ChaCha20/O2/X86/Round.lean` checks: `colsCode_eq`, `diagsCode_eq`, `columns_spec`,
`diagonals_spec`, `double_round_spec`, `rounds_spec`.

Here the recompile is not a renaming. At `-O1` the compiler kept three words of the state in
stack slots and the count of rounds in `edx`; at `-O2` one word is in a slot, the count of
rounds is in a slot and is decremented there (`decl -0x14(%rsp)`), the quarter rounds use
other registers, and the words change places differently within a round. The two
expressions `colsCode` and `diagsCode`, which on x86-64 read the code's arithmetic
instruction by instruction on 32-bit words, are therefore new, and so are the four
statements. None of it was written by hand: a script read the disassembly of the loop,
emitted one `let` for each instruction, and wrote the atoms of the four statements from a
table of where each of the sixteen words is at the head of the loop and at its middle (two
lists of sixteen locations, found by reading 30 lines of the entry code and four spill
instructions). The proof scripts are those of `-O1` with two counts of instructions and one
count of atoms changed; `colsCode_eq` and `diagsCode_eq` (`bv_decide`, one quarter round
deep) and the induction check as they are. The lemma for a decrement in a register (`zdec`)
also closes the decrement in memory.

So this file is the evidence that the machine-run part can be *generated*: its inputs were
the binary, the two tables of locations, and the address of the middle of the loop.

Not done on x86-64: `Block.lean` for `chacha20_block` (the entry, the exit, the
specification and the two theorems about the machine), `quarter_round`, and all of
`sha256.c`. What is known of them:

- `quarter_round`, `sha256_round` and `sha256_schedule` have the same number of
  instructions at both levels (21, 51, 25); whether they are the same instructions was
  checked on RISC-V only.
- `chacha20_block` at `-O2` pushes the same six registers, keeps `out`, `inp`, the count of
  rounds and two words in five slots of the red zone (76 bytes below the entry stack
  pointer, where `-O1` used 148), loads the input straight into registers, and replaces the
  loop that adds by sixteen `add`-from-memory and store pairs. Its entry and exit triples
  have to be restated for that frame; the `-O1` proof needed `Triple.restate` in three
  places for addresses the stepper computes in two forms, and the same is to be expected.
- `sha256_compress` grows from 118 to 157 instructions.

### AArch64: not started

The images are generated. `chacha20_block` grows from 138 to 162 instructions and
`sha256_compress` from 90 to 105; the three leaf functions have the same number of
instructions at both levels.

## What the evidence says about regeneration

Sorted by what a recompile did to the code, this is what it took to get the machine-run part
of the proof back:

1. *Same code.* Nothing but the name of the image. Needs: a statement that does not depend
   on which image constant it names, or a `rfl` lemma that two images are the same code.
2. *Same code, other addresses and registers.* A renaming of the statement; the proof script
   unchanged. Needs: statements whose registers and addresses are parameters, or are
   produced by a tool from the binary. Register numbers inside tactic calls
   (`braid_forget 20`, `sha256_low 7`) and counts of steps (`iterate 81 braid_sym_step`) are
   the only things in a proof script that know the code; both are data a tool can supply.
3. *Other instruction selection and order, same loop structure.* New "arithmetic of the
   code" (`colsCode`), generated from the disassembly, and a `bv_decide` that it is the
   specification. Needs: the decompiler to emit that expression (it is the symbolic state
   after a run), and a table of where the specification's variables live at each cut point.
   That table is the one thing a person supplied here that no tool had.
4. *Other loop structure and frame.* The triples for the affected parts are restated by
   hand, and the specification itself changes when it names the frame. Needs: frames stated
   as "these many bytes below the stack pointer may be written" and not cell by cell;
   caller-saved registers always `regAny`; data addresses taken from the image and not
   written as literals; and cut points (where one triple ends and the next begins) that do
   not have to be moved by hand when a declaration outgrows the heartbeat limit.

Proofs that state each register's final value and leave the equality to `bv_decide`
(SHA-256) survived a change of temporaries untouched. Proofs that write the intermediate
expression out and close by syntactic equality (ChaCha20) survive only an exact renaming,
and otherwise need the expression regenerated.
