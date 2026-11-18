# Roadmap

Where the code stands, and what is next. For what each lowering covers in detail see
[`Lowering/README.md`](../Lowering/README.md); for what is asked of the instruction-set models
see [`ISA.md`](ISA.md).

## What exists

| Piece | State |
| --- | --- |
| The `braid` dialect | syntax, a weakest-precondition semantics, a functional reading proved equivalent to it, MLIR and Lean printers |
| The logic | heaps and assertions as an Iris BI, atoms, triples with the frame rule built in, symbolic execution rules for every operation, tactics, arrays of words and bytes |
| RISC-V lowering | every instruction of the model, proved sound |
| AArch64 lowering | the integer core, proved sound |
| x86-64 lowering | the integer core, proved sound |
| Decompiler | ELF for RISC-V and AArch64; ELF with `objdump`'s disassembly for x86-64; MLIR text, a Lean module with certificates, coverage statistics |
| Differential tester | all three instruction sets |
| Examples | C, Rust, Swift, Go, Python (compiled by Numba) and JavaScript (compiled by V8); straight-line code, branches, loops, memory, calls, and the output of a just-in-time compiler; 61 functions with proved specifications across the three instruction sets, 9 of them down to the machine model, at least one on each |

Everything in the table is checked by `lake build` with no `sorry`, no `axiom`, and no
warnings.

## Next

In rough order of what they would buy.

### Coverage

1. **What is left of the x86-64 integer core**: the rotates, one-operand `imul`, the double
   shifts by `cl`, and `mul` at 8 and 16 bits: 15 instructions of a Go binary.
2. **The exact overflow flag of `imul`, `adc` and `sbb`**. It is a `havoc` today, which is
   sound and loses the `jo` after a checked multiplication.
3. **AArch64 `CLZ`, `RBIT`, and the atomics**, which are what is left of a Go binary there.
4. **Vectors.** x86-64 code moves data through `xmm` registers even with no floating point in
   sight (1,343 instructions of the Go binary). A 128-bit register is two words of `braid`
   state; a lane-wise operation on a word is drafted in the dialect (`BinOp.lanes`).
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

### The dialect

1. **A verified simplifier.** Blocks are lowered one instruction at a time, and a block
   computes flags the next one overwrites. A pass that removes dead flag computations across
   blocks, proved to preserve the semantics, would make the MLIR text shorter and the
   symbolic state smaller.
2. **A registered MLIR dialect.** The text is MLIR's generic syntax, which `mlir-opt` reads
   with `--allow-unregistered-dialect`. An ODS definition, and a round trip through
   [VeIR](https://github.com/opencompl/veir), would let other MLIR tools work on lowered
   code.

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
2. **More languages and more of each**: C++, Zig and OCaml; JavaScript on x86-64 and with
   heap objects; Python with arrays.
4. **Continuity over real history**: proof lines changed per source line changed, over the
   edits of a real project ([`Continuity.md`](Continuity.md)).
