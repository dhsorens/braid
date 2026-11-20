# Continuity

How much does the lowered code change when the source changes a little? If a one-line edit
rewrote the whole lowered function, every proof about it would have to be redone, and the
approach would not survive a codebase that moves. This page measures it.

## The experiment

`Examples/continuity/base.c` has three small functions: a clamp, a checksum loop and a
polynomial. Nine variants each make one small edit. Every variant is compiled at `-O1` for the
three instruction sets and lowered, and compared with the base three ways:

- **source**: lines of C that differ;
- **asm**: lines of disassembly that differ, with addresses removed;
- **braid**: lines of lowered code that differ, in the position-independent form
  `braid-lower --norm` writes, where a jump target is an offset from the function's entry.

Functions are matched by name, so moving a function costs nothing by construction, and a new
function counts in full. `Examples/continuity/run.sh` reproduces the table.

| Variant | What changes | source | RISC-V asm | AArch64 asm | x86-64 asm | RISC-V braid | AArch64 braid | x86-64 braid |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| *(size of base)* | | 19 | 31 | 22 | 28 | 181 | 150 | 400 |
| `v1_constant` | a constant in the loop | 2 | 2 | 2 | 2 | 2 | 2 | 2 |
| `v2_operator` | `^` becomes `+` in the loop | 2 | 2 | 2 | 7 | 2 | 2 | 43 |
| `v3_statement` | one more statement in the loop | 1 | 18 | 16 | 5 | 82 | 89 | 29 |
| `v4_condition` | `x < lo` written as `lo > x` | 2 | 0 | 0 | 0 | 0 | 0 | 0 |
| `v5_reorder` | two commuting statements swapped | 2 | 0 | 0 | 0 | 0 | 0 | 0 |
| `v6_coefficient` | a coefficient of the polynomial | 2 | 2 | 2 | 2 | 2 | 2 | 2 |
| `v7_new_function` | a function added | 2 | 2 | 2 | 3 | 14 | 9 | 19 |
| `v8_swap_branches` | the two tests of the clamp swapped | 2 | 14 | 6 | 8 | 20 | 58 | 82 |
| `v9_move_function` | a function moved in the file | 3 | 0 | 0 | 2 | 0 | 0 | 4 |

## What it shows

**The lowering adds no discontinuity of its own.** It works one instruction at a time, with no
analysis across instructions, so the lowered code changes exactly where the machine code does.
A changed constant is one changed instruction and one changed line of `braid`
(`v1_constant`, `v6_coefficient`). An edit the compiler sees through changes nothing at all
(`v4_condition`, `v5_reorder`).

**The amplification is a constant factor for each instruction set.** One instruction is about
six lines of `braid` on RISC-V, seven on AArch64 and fourteen on x86-64, where most
instructions also compute six flags. A changed instruction costs that many lines and no more:
`v2_operator` on x86-64 changes seven instructions and 43 lines.

**The discontinuities are the compiler's.** `v3_statement` adds one line to a loop, and the
compiler chooses a different loop shape on RISC-V and AArch64: an induction variable appears,
and most of the function is new machine code. `v8_swap_branches` changes which test comes
first, and the branch structure with it. No decompiler that follows the binary can make these
small.

**Changes stay inside the function they touch.** No variant changes the lowered code of a
function its edit did not touch. Jump targets are relative in the normalised form and absolute
in the Lean module, so moving a function changes addresses in the module but not the shape of
its blocks.

## What it means for proofs

A proof in this style is a specification, a loop invariant where there is a loop, and calls to
`braid_run`. Of those, only the invariant knows the shape of the code.

- When an instruction's operand changes, the specification's constant changes and the proof
  script does not.
- When the compiler picks a new loop shape, the loop lemma is restated for the new shape. The
  function's specification, and every proof that calls it, are untouched: a caller sees the
  triple, not the blocks.
- When code moves, the addresses in the specification move. They come from the image, and a
  specification written against `f.entry` would not notice; the examples write them out so
  that they can be read.

The frame rule is what keeps the damage local: a function's triple names only what the
function touches, so nothing else in the program has to be re-proved when it changes.

## A recompile, measured on proofs

The measurement above counts lines of lowered code. This one counts lines of proof. The
ladder is compiled a second time, at `-O2` (the first level is the `-O1` of
`Examples/build.sh`), and `chacha20.c` and `sha256.c` are proved again on the recompiled
binaries, on all three instruction sets: `_spec`, `_correct` and `_leakage` for each of
their five functions (`Examples/<Module>/O2/<ISA>/`). `Examples/Spec`,
`<Module>/Common.lean` and `Sha256/RunTo.lean` are used by both levels and were not edited.
`Examples/continuity/recompile.py` compares the two proofs of each function line by line and
times both; [`Examples/continuity/recompile.md`](../Examples/continuity/recompile.md) has the
table file by file, why `-O2` was chosen, and what the compiler did to each function.

Of the lines of the `-O2` proof: **same** are in the `-O1` proof word for word; **renamed**
differ from a line of it only in a register, a number or an address; **changed** replace
lines of it otherwise; **new** have no counterpart. Of the lines of the `-O1` proof that are
not in the `-O2` proof: **imported** are used through an import of the `-O1` module, and
**dropped** are not needed. Lines are lines of Lean without the header comment and blank
lines. Times are processor seconds (user and system) of `lake env lean` on the files.

What each function computes (`_spec` and `_correct`):

| | function | `-O1` | `-O2` | same | renamed | changed | new | imported | dropped | `-O1` s | `-O2` s |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| RISC-V | `quarter_round` | 189 | 79 | 72 | 0 | 7 | 0 | 110 | 0 | 2.5 | 2.0 |
|  | `chacha20_block` | 876 | 464 | 327 | 82 | 52 | 3 | 415 | 0 | 22.9 | 13.1 |
|  | `sha256_round` | 104 | 105 | 101 | 0 | 3 | 1 | 0 | 0 | 6.0 | 6.0 |
|  | `sha256_schedule` | 133 | 134 | 130 | 0 | 3 | 1 | 0 | 0 | 3.9 | 4.0 |
|  | `sha256_compress` | 505 | 649 | 272 | 91 | 96 | 190 | 0 | 46 | 20.5 | 24.4 |
| | **all** | **1807** | **1431** | **902** | **173** | **161** | **195** | **525** | **46** | **55.8** | **49.5** |
| x86-64 | `quarter_round` | 149 | 97 | 90 | 0 | 7 | 0 | 52 | 0 | 2.2 | 1.7 |
|  | `chacha20_block` | 892 | 799 | 460 | 159 | 106 | 74 | 0 | 167 | 15.7 | 12.6 |
|  | `sha256_round` | 131 | 132 | 128 | 0 | 3 | 1 | 0 | 0 | 5.0 | 5.3 |
|  | `sha256_schedule` | 165 | 166 | 162 | 0 | 3 | 1 | 0 | 0 | 3.4 | 3.5 |
|  | `sha256_compress` | 488 | 559 | 309 | 71 | 42 | 137 | 0 | 66 | 13.1 | 17.8 |
| | **all** | **1825** | **1753** | **1149** | **230** | **161** | **213** | **52** | **233** | **39.4** | **40.9** |
| AArch64 | `quarter_round` | 81 | 65 | 59 | 0 | 6 | 0 | 16 | 0 | 2.4 | 1.6 |
|  | `chacha20_block` | 628 | 616 | 369 | 147 | 69 | 31 | 0 | 43 | 13.4 | 11.5 |
|  | `sha256_round` | 86 | 87 | 83 | 0 | 3 | 1 | 0 | 0 | 4.9 | 4.9 |
|  | `sha256_schedule` | 138 | 140 | 134 | 0 | 4 | 2 | 0 | 0 | 3.1 | 3.2 |
|  | `sha256_compress` | 422 | 642 | 266 | 65 | 72 | 239 | 0 | 19 | 16.1 | 22.8 |
| | **all** | **1355** | **1550** | **911** | **212** | **154** | **273** | **16** | **62** | **39.9** | **44.0** |

What each function reveals (the traced triple and `_leakage`; *on the machine* is the file
with the theorems about the machine for the three functions of `sha256.c`):

| | function | `-O1` | `-O2` | same | renamed | changed | new | imported | dropped | `-O1` s | `-O2` s |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| RISC-V | `quarter_round` | 96 | 98 | 93 | 0 | 3 | 2 | 0 | 0 | 2.6 | 2.0 |
|  | `chacha20_block` | 635 | 510 | 353 | 58 | 78 | 21 | 0 | 146 | 25.3 | 15.6 |
|  | `sha256_round` | 62 | 63 | 59 | 0 | 3 | 1 | 0 | 0 | 2.0 | 2.0 |
|  | `sha256_schedule` | 108 | 109 | 105 | 0 | 3 | 1 | 0 | 0 | 3.3 | 3.9 |
|  | `sha256_compress` | 475 | 489 | 172 | 29 | 50 | 238 | 0 | 224 | 11.3 | 15.0 |
|  | on the machine | 306 | 294 | 228 | 22 | 39 | 5 | 0 | 17 | 4.0 | 4.3 |
| | **all** | **1682** | **1563** | **1010** | **109** | **176** | **268** | **0** | **387** | **48.5** | **42.8** |
| x86-64 | `quarter_round` | 118 | 119 | 115 | 0 | 3 | 1 | 0 | 0 | 1.7 | 1.8 |
|  | `chacha20_block` | 855 | 718 | 470 | 91 | 140 | 17 | 115 | 39 | 20.5 | 16.6 |
|  | `sha256_round` | 74 | 75 | 71 | 0 | 3 | 1 | 0 | 0 | 2.3 | 2.4 |
|  | `sha256_schedule` | 126 | 127 | 123 | 0 | 3 | 1 | 0 | 0 | 5.5 | 5.3 |
|  | `sha256_compress` | 520 | 523 | 190 | 34 | 32 | 267 | 0 | 264 | 14.7 | 19.5 |
|  | on the machine | 370 | 371 | 322 | 35 | 13 | 1 | 0 | 0 | 3.4 | 3.2 |
| | **all** | **2063** | **1933** | **1291** | **160** | **194** | **288** | **115** | **303** | **48.1** | **48.8** |
| AArch64 | `quarter_round` | 86 | 87 | 83 | 0 | 3 | 1 | 0 | 0 | 2.2 | 1.7 |
|  | `chacha20_block` | 696 | 570 | 354 | 63 | 132 | 21 | 0 | 147 | 15.2 | 12.3 |
|  | `sha256_round` | 54 | 55 | 51 | 0 | 3 | 1 | 0 | 0 | 1.3 | 1.4 |
|  | `sha256_schedule` | 109 | 110 | 106 | 0 | 3 | 1 | 0 | 0 | 3.0 | 2.8 |
|  | `sha256_compress` | 584 | 490 | 213 | 40 | 58 | 179 | 0 | 273 | 8.5 | 12.0 |
|  | on the machine | 284 | 291 | 224 | 13 | 40 | 14 | 0 | 7 | 4.3 | 4.8 |
| | **all** | **1813** | **1603** | **1031** | **116** | **239** | **217** | **0** | **427** | **34.5** | **35.0** |

Read by what the compiler did:

- **Nothing** (`quarter_round`, `sha256_round`, `sha256_schedule`, on all three). The code
  is the same instructions. The proof is the same text about another constant; the three or
  four changed lines are the `namespace`, `import` and `end` lines.
- **Registers and addresses** (the loop of double rounds of `chacha20_block`, the schedule
  and the rounds inside `sha256_compress`). The statement is the `-O1` statement under a
  renaming, and the proof script under it checks unchanged. These are the *renamed* lines:
  about one line in eight of a functional proof.
- **Loops and the frame** (the entry and exit of the two large functions). At `-O2` the
  copying loops are gone and the frame has another size and other saved registers. The
  triples for those parts are restated, the specification changes where it names the frame,
  and `sha256_compress`, one triple at `-O1`, is proved at `-O2` as two or three triples
  and their composition on every instruction set. Nearly all the *changed* and *new* lines
  are here, and `sha256_compress` alone has half of them or more on every instruction set.

In sum, of a functional proof at `-O2`, 59 to 66 lines in a hundred are the `-O1` proof word
for word and 12 to 14 are it renamed; of a leakage proof, 64 to 67 and 7 to 8. The time to
check does not move much: a proof of the recompiled code costs what the first did.

The leakage proofs reuse less by renaming and have more new lines than the functional ones,
for one reason: the function that says what a run reveals (`compressLeak`) is written out
by hand, label by label, and it follows the code's loads and stores in order. When the
compiler reorders them the function is new text, although no person decided anything in it.

A smaller experiment happened by accident. A change to one line of the whole program's
source ([`Programs.md`](Programs.md)) made the compiler swap two callee-saved registers
throughout `main` on RISC-V. The 1,155 lines of that proof were repaired by exchanging the
two names in the two files that mention them, with no other edit.

## What it would take to regenerate the machine-run part

A proof here has three parts. The mathematics (the specification, and lemmas that the
arithmetic of the code is the specification's) survived every recompile untouched; that is
what "shared files unchanged" measures. The proof scripts (`braid_sym_run`, an induction, a
`bv_decide`) survived wherever the loop structure did. What was rewritten is the third part:
the *statements* of the intermediate triples, which say where the code is, which register
or stack slot holds which variable of the specification, and what the frame looks like. A
recompile is, for the proof, a change to those statements. So the machine-run part can be
regenerated when the statements can be, and the evidence says what that needs.

Of the decompiler:

1. **Specifications against the image, not against literals.** Every address in a statement
   (an entry, a cut point, a table) was a literal that had to be replaced. The whole program
   shows the other way: a callee's blocks in the two binaries are the same list, the lemma
   that says so is `rfl`, and the callee's two theorems are carried over without running an
   instruction. The decompiler should emit, with each function, its entry, the addresses of
   its loop heads and the addresses of the data it refers to as named constants, and
   statements should use them. An equality check between two images' code for a function
   would then turn "same code" into no proof at all.
2. **The cut points.** Where one triple ends and the next begins was chosen by hand (the head
   of each loop, the end of the schedule), and moved by hand when a declaration grew too
   large to check. The loop heads are in the control-flow graph, which the decompiler has.
3. **The frame and the saved registers.** How far the stack pointer moves, which
   callee-saved registers are stored where, and that they are restored, were restated cell
   by cell. They can be read off the prologue and the epilogue.
4. **The leakage function.** `compressLeak` and its kin are the labels of the symbolic run
   in order, with loops as recursion over the same cut points. The stepper already produces
   the labels of each straight run; it should produce the function and not check one that
   was typed in.

Of the logic:

5. **Frames stated by extent.** A specification that says "the 336 bytes below the stack
   pointer may be written" and "every caller-saved register holds something", and not which
   cell holds what, would not have changed when the frame did, and its callers would not
   have noticed. The pieces exist (`cellsAny`, `regAny`); the specifications of the ladder
   were written before them and name cells.
6. **Final values, not intermediate expressions.** Proofs that state each register's value
   at the end of a run and leave the equality to `bv_decide` (SHA-256) survived a change of
   temporaries and of the association of sums untouched. Proofs that write the intermediate
   expression out and close by syntactic equality (the ChaCha20 loop) survive an exact
   renaming and nothing else, and needed the expression generated again from the
   disassembly. The first style should be the only one.
7. **Declarations that do not depend on size.** Twice a recompile crossed a limit: a run
   that had checked as one declaration had to be cut in three, and a list of 33 atoms had
   to be written another way than one of 28. A rule that composes the triples of the cut
   points automatically would make the size of a function a matter of how many pieces, not
   of whether it checks.

What is left for a person, were all of that done, is one table for each cut point: which
register or slot holds which variable of the specification there. That table is the loop
invariant, it is the one thing supplied by hand here that no tool had, and it is the one
thing about a loop that the compiler is free to change without telling anyone. For the
recompiles measured it was found by reading the disassembly of each function.
A decompiler that tracked it from the source's debug information, or a search over
permutations checked by `bv_decide`, would close the gap; neither is attempted here.

## The trace found by the run

The fourth item above was done. A traced triple can now leave its trace open, and the run
finds it (`braid/Braid/Logic/Traced.lean`, [`Leakage.md`](Leakage.md)): the statement is a
pair of a trace and the triple that leaves it, `braid_done` gathers the labels the stepper
has added, and a loop is a definition by recursion on the turns left, as its triple was a
proof by induction. What the trace may depend on is what is bound before the pair, so that
it is a function of the public inputs is checked by scope, when the definition is.

The leakage proofs of `chacha20.c` at `-O1` were converted on all three instruction sets,
with no change to any statement about a machine: `quarterRoundLeak` and `blockLeak` keep
their names and arguments and are now the traces the runs find. Lines are lines of the four
files of each proof; *trace, by hand* is the lines of them that were definitions of traces,
label by label or by recursion; times are processor seconds of `lake env lean` on the four
files, both measured on the same machine at the same load, the files of before put back
in place and built for the purpose.

| | lines before | lines after | trace, by hand, before | after | seconds before | seconds after |
| --- | --- | --- | --- | --- | --- | --- |
| RISC-V | 868 | 832 | 28 | 0 | 20.9 | 16.2 |
| AArch64 | 924 | 890 | 29 | 0 | 15.6 | 12.5 |
| x86-64 | 1144 | 1134 | 43 | 0 | 17.1 | 12.3 |

The files are hardly shorter, and the measurement should not be read as if they were. The
hand-written traces of ChaCha20 were short: the function touches memory at its ends and
runs its rounds on registers. What changed is not the size but who writes the trace. The
intermediate definitions (`headLeak`, `storesLeak`, `sumLeak`, the recursive `roundsLeak`)
are gone with the lemmas that unfolded them, and in their place are the same runs, stated
as pairs. The proofs check faster because the trace is no longer compared with a list
written elsewhere.

Where the gain is expected is the case the recompile measured: `LeakCompress.lean` of
SHA-256 lost half its lines to a rewritten `compressLeak` on each instruction set. The
proofs written since in this style have no such function to rewrite. The vectorised
ChaCha20 and SHA-256 with the SHA instructions ([`Scaling.md`](Scaling.md)) state their
traces by reference on both instruction sets, and the explicit form of each (thirty-odd
labels, or the recursion equations of a loop) is a theorem proved by `rfl` for the reader,
not a definition the proof depends on. The scalar SHA-256 proofs were not converted.

Converting found what the tactics lacked, which is now in the core: a run that leaves no
label, a run whose labels follow the trace of a triple it called, a trace of seventy
labels or more (gathered one label at a time), and a state of thirty atoms (taken out one
at a time, `braid_done_traced`). The tactics that forget a cell or name a value in memory
(`braid_forget_mem`, `braid_name_mem`, `braid_forget_cells`) were local to the x86-64
proof and to the second whole program, as workarounds; they now close by the form they
had or, failing that, by applying the rule and proving its side conditions in turn, and
the workarounds are gone.

## Limits of the measurement

Line counts are a crude metric. They over-count on x86-64, where a changed instruction
recomputes all its flags, and they say nothing of how hard a changed line is to re-prove:
the lines counted as *same* in a recompiled proof were still found to be the same by a
person who tried them. The corpus of the first experiment is one small file at one
optimisation level, and that of the second is two files at two levels of one compiler; the
`-O2` proofs were written after the `-O1` proofs and with them open, so they are as close
to them as they could be made. A better measurement would count proof lines that change
over the edit history of a real project; that is on the [roadmap](Roadmap.md).
