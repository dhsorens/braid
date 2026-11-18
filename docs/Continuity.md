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

## Limits of the measurement

Line counts are a crude metric. They over-count on x86-64, where a changed instruction
recomputes all its flags, and they say nothing of how hard a changed line is to re-prove. The
corpus is one small file at one optimisation level. A better measurement would count proof
lines that change, over the edit history of a real project; that is on the
[roadmap](Roadmap.md).
