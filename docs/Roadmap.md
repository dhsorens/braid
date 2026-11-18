# Roadmap

Where the code stands, and what is next. For what each lowering covers in detail see
[`Lowering/README.md`](../Lowering/README.md); for what is asked of the instruction-set models
see [`ISA.md`](ISA.md).

## What exists

| Piece | State |
| --- | --- |
| The `braid` dialect | syntax, a weakest-precondition semantics, a functional reading proved equivalent to it, MLIR and Lean printers, an IRDL definition, three proved simplification passes |
| The logic | heaps and assertions as an Iris BI, atoms, triples with the frame rule built in, symbolic execution rules for every operation, tactics, arrays of words and bytes |
| RISC-V lowering | every instruction of the model, proved sound |
| AArch64 lowering | the integer core, and vector registers with their loads, stores, moves, bitwise operations and lane-wise addition, proved sound |
| x86-64 lowering | the integer core, and vector registers with their moves at 128, 256 and 512 bits and packed addition, proved sound |
| Decompiler | ELF for RISC-V and AArch64; ELF with `objdump`'s disassembly for x86-64; MLIR text, a Lean module with certificates, coverage statistics |
| Differential tester | all three instruction sets |
| Examples | C, Rust, Swift, Go, Python (compiled by Numba) and JavaScript (compiled by V8); straight-line code, branches, loops, memory, calls, and the output of a just-in-time compiler; 61 functions across the three instruction sets (17 on RISC-V, 23 on AArch64, 21 on x86-64), each with a proved specification and a theorem about the machine model alone |

Everything in the table is checked by `lake build` with no `sorry`, no `axiom`, and no
warnings.

## Next

In rough order of what they would buy.

### Coverage

1. **What is left of the x86-64 integer core**: rotations through carry, rotations and double
   shifts by `cl`, and the widening multiplications at 8 and 16 bits: five instructions of a
   Go binary.
2. **The exact overflow flag of `imul`, `adc` and `sbb`**. It is a `havoc` today, which is
   sound and loses the `jo` after a checked multiplication.
3. **AArch64 `CLZ`, `RBIT`, and the atomics**, which are what is left of a Go binary there.
4. **More of the vector instructions.** A vector register is words of `braid` state, and a
   lane-wise operation on a word is in the dialect (`BinOp.lanes`). AArch64 has its loads,
   stores, moves, bitwise operations and lane-wise addition lowered and proved; x86-64 has
   its moves at 128, 256 and 512 bits, the moves to and from general registers, and packed
   addition. That took the vector traps of a Go binary on x86-64 from 1,343 to 40. Not
   lowered on either: shuffles, table lookups, shifts by lane, `vzeroupper`, the
   cryptographic instructions and floating point.
5. **What the models lack**: `div` and `idiv`, `xchg`, `cqo`, bit tests and atomics on x86-64;
   the RV64 word operations and compressed instructions on RISC-V. These go to the models
   ([`ISA.md`](ISA.md)), not here.

### The logic

1. **A flags atom.** A specification on x86-64 names six flags before and six after. One atom
   for "the status flags, with these values" and one for "whatever they are" would halve the
   text of every specification.
2. **Loops without a lemma each.** An invariant rule for a backward jump, so that a simple
   loop is an invariant and `braid_run`.
3. **Read-only and shared memory.** The atoms have a writable bit; fractional permissions
   would let two specifications share a table.
4. **Closer to Iris.** Assertions are an instance of Iris's BI interface and its proof mode
   works on them. Triples are not yet Iris weakest preconditions; making them so would bring
   invariants and ghost state.

5. **Shorter theorems about the machine.** Every example ends in a theorem about its machine
   model, and writing those showed what the library lacks. A precondition with an array has
   to be written out by hand before `machine_sound_flat` takes it; `braid_disj` gives up when
   two memory atoms are present; scratch stack words are quantified one by one where "these
   bytes may be written" would do; and the predicates the statements use (`HasBytes`, and
   `Apart` for regions that do not overlap) are defined once per instruction set, in three
   slightly different places. One set of these in the logic, and a tactic for the side
   conditions, would cut the longest statements by half.

### The dialect

1. **A proved driver for the simplifier, and proofs that use it.** Three passes are proved to
   preserve what the runs of a program reach: fusing a block with the block it jumps to,
   removing a flag write that the same block overwrites, and removing operations whose
   results nothing reads. `braid-lower --simplify` applies them to the text it prints, and a
   function comes out with a third of its blocks and a fifth less text. Two things are
   missing. The driver that chooses which blocks of a function to fuse is not itself proved,
   only the passes it calls. And the Lean modules the decompiler writes are not simplified,
   so proofs still step through one block for each instruction.
2. **A dialect VeIR knows.** The value operations are defined in IRDL
   (`braid/mlir/braid.irdl.mlir`), so `mlir-opt` checks them, and every example module goes
   through [VeIR](https://github.com/opencompl/veir)'s `veir-opt` and back
   (`Examples/check-mlir.sh`). What is missing is the dialect inside VeIR: its operations
   registered there, with the terminators marked as such, so that VeIR's verifier and its
   pass infrastructure work on lowered code, and so that a pass written in VeIR can be
   proved against the semantics here.

### The interface to binaries

1. **x86-64 from bytes.** A theorem about x86-64 is about the instructions the disassembler
   printed. A verified decoder, or a check of Kraken's encoder against the bytes of the
   binary, would remove the disassembler from what is trusted ([`Trust.md`](Trust.md)).
2. **Whole programs.** A theorem is about the functions it names. Linking specifications
   across a binary, with its data sections as initial memory, is the step from functions to
   programs.

### The corpus

1. **More of what compilers emit**: structs and pointers to them, recursion, jump tables,
   64-bit division, strings, and an allocator.
2. **More languages and more of each**: C++, Zig and OCaml; JavaScript with heap objects;
   Python with arrays.
4. **Continuity over real history**: proof lines changed per source line changed, over the
   edits of a real project ([`Continuity.md`](Continuity.md)).
