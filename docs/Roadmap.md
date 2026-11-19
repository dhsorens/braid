# Roadmap

Where the code stands, and what is next. For what each lowering covers in detail see
[`Lowering/README.md`](../Lowering/README.md); for what is asked of the instruction-set models
see [`ISA.md`](ISA.md).

## What exists

| Piece | State |
| --- | --- |
| The `braid` dialect | syntax, a weakest-precondition semantics, a functional reading proved equivalent to it, MLIR and Lean printers, an IRDL definition, three proved simplification passes |
| The logic | heaps and assertions as an Iris BI, atoms, triples with the frame rule built in, symbolic execution rules for every operation, tactics, arrays of words and bytes |
| Traces | a step of the dialect carries labels: what it reveals, and events of the environment; triples that state the trace of a run, produced by the stepper; a trusted reading of each machine model's labels, which each lowering is proved to preserve ([`Leakage.md`](Leakage.md)) |
| Whole programs | a loaded binary as an object (code, data sections, entry point) written by the decompiler with a checked certificate; a rule that joins a callee's specification and its trace at a call; safety of every reachable state from the trace of one run ([`Programs.md`](Programs.md)) |
| RISC-V lowering | every instruction of the model, proved sound |
| AArch64 lowering | the integer core with load-acquire, store-release and the atomic read-modify-writes, and vector registers with their loads, stores, moves, bitwise operations and lane-wise addition, proved sound |
| x86-64 lowering | the integer core, and vector registers with their moves at 128, 256 and 512 bits and packed addition, proved sound |
| Decompiler | ELF for RISC-V and AArch64; ELF with `objdump`'s disassembly for x86-64; MLIR text, a Lean module with certificates, coverage statistics |
| Differential tester | all three instruction sets |
| Examples | C, Rust, Swift, Go, Python (compiled by Numba) and JavaScript (compiled by V8); straight-line code, branches, loops, memory, calls, and the output of a just-in-time compiler; 94 functions across the three instruction sets (28 on RISC-V, 34 on AArch64, 32 on x86-64), up to the ChaCha20 block function and the SHA-256 compression function, each with a proved specification and a theorem about the machine model alone; for the twelve functions of the scaling ladder on each, a theorem of what a run reveals; ChaCha20 and SHA-256 proved a second time at `-O2`; and one whole program on each, SHA-256 of a message, proved from its entry point |

Everything in the table is checked by `lake build` with no `sorry`, no `axiom`, and no
warnings.

## Next

The next three goals, in order:

1. **Vector and cryptographic instructions**, with a vectorised ChaCha20 proved correct
   and constant-time. The theorems about what code reveals are about scalar code
   compiled with vectorisation off; real libraries are not.
2. **Proof reuse.** [`Continuity.md`](Continuity.md) measures what of a proof survives a
   recompile and lists what the decompiler and the logic would have to do for the rest to
   be regenerated: statements against the image and not against literals, cut points and
   frames from the code, the function of what a run reveals produced by the stepper.
3. **Concurrency**, starting with triples as Iris weakest preconditions and steps of the
   environment, before any model of several cores.

The rest, in rough order of what it would buy.

### Coverage

1. **What is left of the x86-64 integer core**: rotations through carry, rotations and double
   shifts by `cl`, and the widening multiplications at 8 and 16 bits: five instructions of a
   Go binary.
2. **The exact overflow flag of `imul`, `adc` and `sbb`**. It is a `havoc` today, which is
   sound and loses the `jo` after a checked multiplication.
3. **AArch64 store-exclusive and compare-and-swap**, the largest groups left of a Go binary
   there (97% of it lowers). Both store or not depending on a comparison, and the dialect
   has no conditional store: the block would write the old value back, which needs a lemma
   that doing so changes nothing in the model.
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

6. **What the ladder asked of the stepper** ([`Scaling.md`](Scaling.md)): a run that stops
   at a given address, normalization of `x ^^^ x`, of a literal added on the left and of an
   index scaled by one, and a `braid_done` that does not run out of depth on thirty atoms.

5. **Shorter theorems about the machine.** Every example ends in a theorem about its machine
   model, and writing those showed what the library lacks. A precondition with an array has
   to be written out by hand before `machine_sound_flat` takes it; `braid_disj` gives up when
   two memory atoms are present; scratch stack words are quantified one by one where "these
   bytes may be written" would do; and the predicates the statements use (`HasBytes`, and
   `Apart` for regions that do not overlap) are defined once per instruction set, in three
   slightly different places. One set of these in the logic, and a tactic for the side
   conditions, would cut the longest statements by half.

### The dialect

1. **Proofs that use the simplifier.** Three passes are proved to preserve what the runs of
   a program reach: fusing a block with the block it jumps to, removing a flag write that
   the same block overwrites, and removing operations whose results nothing reads. The
   driver that applies them to a function, by a plan of which blocks to fuse, is proved for
   any plan, and `braid-lower --simplify` prints its result: a function comes out with a
   third of its blocks and a fifth less text. The Lean modules the decompiler writes are not
   simplified, and proofs step through one block for each instruction. Measured, that is the
   faster way today ([`Scaling.md`](Scaling.md)); bounded fusion with a certificate for each
   block is what would change it.
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
2. **Whole programs, further.** One program is proved from its entry point on each
   instruction set ([`Programs.md`](Programs.md)). Not done: a callee proved at other
   addresses than it is linked at, position-independent code, a program that reads input,
   and anything of a loader. The first is the same work as the first item of
   [`Continuity.md`](Continuity.md). On x86-64 the program cannot exit, for want of a
   system call in the model ([`ISA.md`](ISA.md)).

### The corpus

1. **More of what compilers emit**: structs and pointers to them, recursion, jump tables,
   64-bit division, strings, and an allocator.
2. **More languages and more of each**: C++, Zig and OCaml; JavaScript with heap objects;
   Python with arrays.
4. **Continuity over real history**: proof lines changed per source line changed, over the
   edits of a real project ([`Continuity.md`](Continuity.md)).
