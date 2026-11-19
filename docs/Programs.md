# Whole programs

A theorem about a function assumes what its caller would have set up: a pointer to a table,
room on the stack, the code at its addresses. A theorem about a whole program assumes one
thing, that the binary is loaded. This page says what that means, how a caller's proof uses a
callee's, and what is proved of one real program on each instruction set.

## A loaded binary

`braid-lower --image <name>` reads a whole binary and writes, beside the lowered code of its
functions:

- its **data sections**, each as its address and its bytes, and each zeroed section (`.bss`)
  as its address and its size;
- its **entry point**;
- the image itself, `<name>_image : Braid.Image`, which is the code, the sections and the
  entry point as one object (`braid/Braid/IR/Image.lean`);
- a **certificate** that the lowered blocks are the lowering of the image's code, and the
  fact that the sections do not overlap. The kernel checks both.

So the address of a table and what is in it are facts about the binary. The specification of
`sha256_compress` on RISC-V takes "the round constants are at `0x10368`" as a hypothesis; the theorem
about the whole program has no such hypothesis, because the section of the image at
`0x10368` is those constants, by `decide`.

What it means for a machine to have an image loaded is said once for each instruction set
(`Loaded`), since each model holds code in its own way:

| ISA | `Loaded s img` says | File |
| --- | --- | --- |
| RISC-V | the model's code map has the image's instructions; every byte of every section is in valid memory with its contents; the program counter is the entry point | `Lowering/RiscV/Program.lean` |
| AArch64 | the machine is running and its supervisor calls are the model's Linux system calls; the four bytes of every instruction word are mapped executable and are that word; every byte of a section with contents is mapped read-only with its contents, and every byte of a zeroed section read-write and zero; the program counter is the entry point | `Lowering/Arm/Program.lean` |
| x86-64 | every byte of every section is in memory with its contents; the program counter is the entry point. The code is not in the state: the model runs the executable of the image's lines | `Lowering/X86/Program.lean` |

In the logic the sections are assertions like any other (`sectionAtoms`): an array of bytes
for each. `program_soundT` turns a traced triple whose precondition is the registers and the
sections of an image into a theorem about every machine that has the image loaded. A proof
then splits the stack's zero bytes into the frames the code uses and reads the bytes of a
table as an array of words (`braid/Braid/Logic/Bytes.lean`).

## Calls within a binary

A function has two theorems proved apart: a triple that says what it computes (`_spec`), and
a traced triple that says what it reveals (`_trace`), with a postcondition that has forgotten
the data. A caller needs both of one run. `TripleT.of_spec` (`braid/Braid/Logic/Link.lean`)
joins them: for a callee that returns to an address outside its own code, a run stops exactly
when it gets there, so the two triples speak of the same final state, and the callee runs to
the postcondition of the first with the trace of the second. `TripleT.mono` then carries the
result from the callee's blocks to any program that contains them, and `braid_call` uses it
at the call, framing the rest of the caller's state.

The whole program below calls `sha256_compress`. Its proof does not run a single instruction
of the callee: `compress_call` is `sha256_compress_spec` and `sha256_compress_trace`, as they
were proved about the binary of `sha256.c` alone, joined and carried over. This works because
the linker script puts the code of `sha256.c` and its table at the addresses they have in
that binary (`Examples/build.sh`, `lower_program`), so the callee's blocks in the two images
are the same list and `compress_blocks` is `rfl`. A callee that had moved would need its
specification stated against its entry and not against literals; that is not done
([`Continuity.md`](Continuity.md)).

## The program

`Examples/src/c/sha256_main.c` is a program with no library and no loader beneath it.
`_start` points the stack pointer at a stack in `.bss` and jumps to `main`, which computes
SHA-256 of a message in the binary's data: it pads the message block by block, each byte of
the padded message computed from its index, calls `sha256_compress` for each block, writes
the 32 bytes of the digest out, and exits. The message and its length are in sections of
their own, the message last, so that the binary with another message differs in those two
sections only, and the theorems are about the binary with any message in it (`image msg`);
the binary as compiled is `image "abc"` (on x86-64 the function is named `imageOf`).

Three theorems are proved about the machine model alone, from the entry point, with no
hypothesis about memory or registers beyond `Loaded s (image msg)` and a bound on the length
of the message (`Examples/Sha256Main/<ISA>/Proofs.lean`):

- **`sha256_main_correct`**: the run ends in the exit event, and the bytes written out are
  `sha256 msg`. The specification (`Examples/Spec/Sha256.lean`) pads a string of bits and is
  checked on the examples of FIPS 180-4; `Examples/Sha256Main/Common.lean` proves that the
  padding the program computes byte by byte is the standard's. `sha256_main_abc` is the
  instance for the binary as compiled: it writes out `ba7816bf…f20015ad`.
- **`sha256_main_leakage`**: the leakage of the run, which is its trace without the events of
  the environment, is `mainLeak` of the length of the message: an explicit function of the
  length alone. `sha256_main_leakage_eq` is the two-run statement: two messages of one length
  give the same leakage. The length is revealed, as it must be: the number of blocks is the
  number of calls. The padding loop branches four ways on the index of each byte (a byte of
  the message, the byte `0x80`, a zero, a byte of the length), and those branches depend on
  the index and the length and not on any byte of the message.
- **`sha256_main_safe`**: no store outside the stack. Every state the machine passes through
  has every byte of memory outside the stack in use as it was at the start: the code's
  table, the message and its length are never written. The stack in use is 520 bytes on
  RISC-V and 512 on AArch64; on x86-64 the range is 568 bytes, the stack in use and the 32
  bytes of `digest` above it.

The safety property is a statement about every reachable state, and it is proved from the
trace of one run. The trace records every store with its address and size, the machine is
deterministic, and the run ends in a halt: so every state the machine can reach is on that
run, and a byte no `write` label covers has not changed (`RunL.safe`). That every `write` of
the trace is inside the stack is a fact about `mainLeak`, proved by induction over its loops,
with the callee's part (`compressLeak` at the constants of the call) evaluated by the kernel.

The three models say "every reachable state" in their own ways. RISC-V's step is a
function, and `Reachable` is its closure. On AArch64 `Reachable` is the states of labelled
runs, and the property is stated of the bytes the machine could load at the start, since
the model's memory has permissions: each can still be loaded and is unchanged. Kraken's
step is a set of outcomes, so on x86-64 a state follows another if every set the step
accepts contains it (`Next`, `Lowering/X86/Safety.lean`); a state with no step would be
followed by every state, so the theorem also says that no reachable state is stuck.

| | RISC-V | AArch64 | x86-64 |
| --- | --- | --- | --- |
| The events | the model's `ECALL`: `t0 = 0x10` writes, `t0 = 0` halts | the model's `SVC #0` as Linux `write` and `exit` | none: the model has no system call |
| `sha256_main_correct` | proved | proved | proved, in the form the model allows: the machine reaches the final jump to itself with `sha256 msg` in memory at `digest` |
| `sha256_main_leakage`, `_eq` | proved | proved | proved |
| `sha256_main_safe` | proved | proved | proved |
| Proof, lines (and 538 shared by the three) | 1,155 | 1,279 | 1,451 |
| Processor time | 20 s | 19 s | 24 s |

## The environment

A step of the dialect carries labels of two kinds: what the step reveals, and an event of the
environment ([`Leakage.md`](Leakage.md)). There are two events, `write bs` and `exit code`.
A system call is lowered to a `trap` when a function is lowered, since a theorem about a
function has no use for it, and to the dialect's `out` and `exit` when a whole binary is
(`lowerEnv`). The reading of events off each machine model is trusted, with the rest of the
labelled reading ([`Trust.md`](Trust.md)).

A program that has exited takes no further step. The machine models differ in how they say
so, and the labelled runs follow each model: on RISC-V a machine at the halting `ECALL` stays
there, and a run records its exit and stops; on AArch64 the model's status becomes `Exited`
with the code, the machine takes no step, and a run records the exit from the status. On
AArch64 the bytes of a `write` event are the bytes the model appends to its own output.

Kraken's x86-64 has no system call ([`ISA.md`](ISA.md)), so there is no event to read on
x86-64. The program there is the same `main` with another ending: it copies the digest to
a global and jumps to itself, and the theorem says where the digest is when it gets there.
The same variant would exit through `syscall` if the model had one.

## What this does not do

- **One binary.** Linking is within one binary whose callee is where its proof says. There
  is no rule for position-independent code or for a callee proved at other addresses.
- **No loader.** "Loaded" is a hypothesis about the first state. Nothing models the kernel
  that puts the sections in memory, relocations, or dynamic linking; the program is linked
  statically and uses no library.
- **A deterministic environment.** The two events are outputs. A program that reads input
  has a trace that is not determined by its first state, and the safety argument above,
  which follows the one run there is, does not apply as it stands.
