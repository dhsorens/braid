# What is trusted

A theorem here is about a machine model. This page lists what has to be right for such a
theorem to mean what it says about a real binary on a real processor, and what does not.

## Trusted

**The Lean kernel**, and the three axioms Lean's library uses: `propext`, `Classical.choice`
and `Quot.sound`.

**`bv_decide`.** Bit-vector goals are closed by `bv_decide`, which calls a SAT solver and
checks its certificate with a verified checker that runs as compiled code. Each call adds an
axiom saying the compiled checker accepted. `#print axioms` lists them as
`…._native.bv_decide.ax_…`. They trust the Lean compiler to run the checker as the kernel
would. No other axiom is used: there is no `sorry`, no `axiom` and no `native_decide` in the
sources.

**The instruction-set models.** Each is used unmodified at a pinned revision
([`ISA.md`](ISA.md)).

| ISA | Model | What it is tied to |
| --- | --- | --- |
| RISC-V RV64IM | riscv-zkvm's `Rv64` | proved equivalent, instruction by instruction, to the Sail RISC-V model |
| AArch64 | arm64-semantics, trusted package | written from Arm's machine-readable specification, tested against other models |
| x86-64 | Kraken's x64 semantics | written by hand, for testing and for proof |

**How a binary becomes the model's program.** This differs by instruction set.

- *RISC-V.* The model keeps code as a map from addresses to instructions, not as bytes. A
  theorem assumes the machine holds given instructions at given addresses (`hcode` in the
  examples). That those are the instructions the bytes of the binary decode to rests on
  riscv-zkvm's decoder, which is not yet proved against Sail's.
- *AArch64.* The model fetches bytes from memory and decodes them itself. A theorem assumes
  the bytes of the code are loaded. Nothing between the bytes and the theorem is trusted.
- *x86-64.* Kraken's programs are assembly, with a size for each instruction, and not bytes.
  A theorem is about the instructions the disassembler printed, laid out at the addresses of
  the binary. The disassembler (`objdump`) and Kraken's parser are trusted to have read the
  bytes correctly.

**What an instruction reveals.** A theorem about leakage is stated with the trace of a run
of the machine, and none of the three models defines one. For each instruction set one file
says what each instruction reveals when it runs in a state, in the model of
[`Leakage.md`](Leakage.md): the address and size of each load and store, where a conditional
branch or a computed jump goes, and the operands of a division. A run's trace is those labels
in order. These files are definitions only, and they are trusted: if one leaves out an access
an instruction makes, a theorem will say the program reveals less than it does.

| ISA | File | Status |
| --- | --- | --- |
| RISC-V | `Lowering/RiscV/Leak.lean` (`leak`, `RunL`) | the lowering is proved to preserve it (`lowerCode_soundL`) |
| AArch64 | `Lowering/Arm/Leak.lean` (`leak`, `RunL`) | the lowering is proved to preserve it (`lowerProgram_soundL`) |
| x86-64 | `Lowering/X86/Leak.lean` (`leak`, `RunL`) | the lowering is proved to preserve it (`lowerProgram_soundL`) |

On AArch64 and x86-64 the reading is partial: it says nothing of an instruction the lowering
does not cover, and a run with a trace has no step through one. On x86-64 a run with a trace
is stated as the model states runs, of every outcome at once (`RunL e post m t`), since
Kraken's semantics is a set of outcomes. Kraken has no division, so nothing on x86-64
reveals its operands.

**What the environment sees.** The same three files read the events of a run off each
model: bytes written out, and the exit with its code. A theorem about a whole program is
stated with them ([`Programs.md`](Programs.md)).

| ISA | An event is | A run that has exited |
| --- | --- | --- |
| RISC-V | the model's `ECALL` with `t0 = 0x10` (the `a1` bytes at `a0` are written) or `t0 = 0` (halt, code in `a0`) | stays at the halting `ECALL`; the run records the exit and stops |
| AArch64 | `SVC #0` under the model's Linux system calls (`Arm64.Syscall.standard`): `write` (`x8 = 64`) of every byte asked for to the standard output, and `exit` (`x8 = 93`) | has the status `Exited c` and takes no step; the run records the exit with `c` |
| x86-64 | nothing: Kraken has no system call ([`ISA.md`](ISA.md)) | does not exist; a whole program ends in a jump to itself |

Both models keep an output of their own: riscv-zkvm appends the bytes of a `write_output`
call to the public output of its state (the calls follow the host interface of a zkVM),
and arm64-semantics appends the bytes of a `write` to its trace of output. The label of a
write event is the bytes of memory at the buffer of the call, read by the definition in
the trusted file. That these are the bytes the model appends is how the model's call is
written, and is read off it, not proved: no theorem here mentions either model's output.
A system call the files do not speak of has no label, and a run with a trace has no step
through it.

**What it means for a binary to be loaded.** A theorem about a whole program has one
hypothesis about the machine, `Loaded s img`, defined once for each instruction set
(`Lowering/<ISA>/Program.lean`): the code of the image is where the model looks for code,
every byte of every section is in memory with its contents, and the program counter is the
entry point. The image is written by `braid-lower --image` from the ELF file. That its
lowered blocks are the lowering of its code is checked by the kernel; that its sections
are the bytes of the file's sections is not checked by anything, and neither is the
loader: nothing here models how an operating system gets a machine into a state where
`Loaded` holds.

The labels of the dialect are not trusted. They are compared with the machine's by the proof
that a lowering preserves traces.

**The statement.** A specification can be wrong. The top theorem of each example is stated
about the machine model alone, so that it can be read without knowing the dialect or the
logic.

## Not trusted

**The compilers and linkers.** Proofs are about the binary. Nothing is assumed of `clang`,
`rustc`, `go` or the linker.

**The decompiler.** `braid-lower` writes the instructions of a function, its lowered blocks,
and a certificate that the blocks are the lowering of the instructions. The kernel checks the
certificate. A wrong decompiler produces a certificate that fails.

**The lowerings.** Each is proved sound against its model: if the lowered code reaches a
postcondition, the machine does (`lowerCode_sound` and its companions).

**The dialect's printers.** The MLIR text is for reading and for other tools. Proofs are about
the Lean term.

**The logic and its tactics.** The rules are theorems about the semantics of the dialect. A
tactic can fail, but it cannot prove something false.

**The differential tester.** It looks for places where the lowered code faults and the machine
does not. It proves nothing and nothing depends on it.

## What a theorem does not say

- **Completeness.** Soundness is proved: a run of the lowered code is a run of the machine. The
  converse is tested, not proved. Where a lowering is stricter than the model, a proof gets
  stuck; it does not go wrong.
- **Everything outside the model.** Caches, speculation, power, interrupts, other threads,
  and whatever an environment call does are outside all three models. Timing is in only as
  far as the leakage model of [`Leakage.md`](Leakage.md) goes, and only in theorems that
  state a trace.
- **More than it names.** A theorem about a function is about that function, from its entry
  to its return, on the states its hypotheses allow. A theorem about a whole program is
  about one binary from its entry point, on every machine that has it loaded; it says
  nothing of a binary linked otherwise, or of the same code called from elsewhere.
- **Input.** The two events are outputs. No example reads from its environment.
