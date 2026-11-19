# Examples

Programs in several languages, compiled for each instruction set, lowered by `braid-lower`,
and verified with the logic. The corpus has two jobs: to show how a proof goes, and to find
out where the lowerings and the logic fall short on what compilers really emit.

```
src/           the sources, by language
build.sh       compile and lower every example
bin/           binaries and intermediate files (not kept in the repository)
mlir/          the lowered code of each example, as MLIR text
<Module>/<ISA>/Image.lean    the lowered code, as a Lean module (written by braid-lower)
<Module>/<ISA>/Proofs.lean   specifications and proofs
Spec.lean      functions the specifications share (umax, wsum, wgcd, ones)
Spec/          specifications in plain Lean: CRC-32, ChaCha20 (RFC 8439), SHA-256 (FIPS 180-4)
<Module>/Common.lean         what a module's proofs share on every instruction set
<Module>/<ISA>/Leak*.lean    what a function reveals (docs/Leakage.md)
<Module>/O2/<ISA>/           the same source compiled at -O2, lowered and proved again
Sha256Main/                  a whole program, proved from its entry point (docs/Programs.md)
scaling/       the scaling benchmark (docs/Scaling.md)
ArmMachine.lean  what the AArch64 machine theorems are stated with (HasBytes, Apart)
continuity/    the continuity experiment (docs/Continuity.md)
```

## What is verified

Every name in the table is a function with a proved specification (`<function>_spec`) and a
theorem about the machine model alone (`<function>_correct`).

| Source | RISC-V | AArch64 | x86-64 |
| --- | --- | --- | --- |
| `c/basic.c` | add3, max_u64, sum_to | add3, max_u64, sum_to | add3, max_u64, sum_to |
| `c/memory.c` | swap, max2, max3, sum_array | swap, max2, max3, sum_array | swap, max2, max3, sum_array |
| `c/bytes.c` | str_len, fill, count_ones | str_len, fill, count_ones | str_len, fill, count_ones |
| `rust/basic.rs` | gcd | add3, max_u64, gcd, sum_slice | add3, max_u64, sum_slice |
| `swift/basic.swift` | swift_add3, swift_min, swift_gcd | swift_add3, swift_min, swift_gcd | swift_add3, swift_min |
| `go/basic.go` | not lowered | Add3, MaxU64, SumSlice | Add3, MaxU64, SumSlice |
| `python/basic.py` | py_add3, py_max_u64, py_gcd | py_add3, py_max_u64 | py_add3, py_max_u64 |
| `js/basic.js` | | js_add3 | js_add3 (to its return instruction) |
| `c/mem.c` | copy_bytes, equal_bytes, equal_bytes_ct | copy_bytes, equal_bytes, equal_bytes_ct | copy_bytes, equal_bytes, equal_bytes_ct |
| `c/limbs.c` | add_limbs | add_limbs | add_limbs |
| `c/crc32.c` | crc32 | crc32 | crc32 |
| `c/chacha20.c` | quarter_round, chacha20_block | quarter_round, chacha20_block | quarter_round, chacha20_block |
| `c/sha256.c` | sha256_round, sha256_schedule, sha256_compress | sha256_round, sha256_schedule, sha256_compress | sha256_round, sha256_schedule, sha256_compress |

The last five sources are the scaling ladder ([`docs/Scaling.md`](../docs/Scaling.md)):
functions of growing size, up to the SHA-256 compression function, proved against
definitions in plain Lean (`Spec/`) that are checked on the standards' test vectors.

## What is revealed

Every function of the ladder, and `swap`, also has a theorem about what a run of it reveals
(`<function>_leakage`, about the machine model alone: the trace is an explicit function of
named public inputs) and the two-run statement that follows (`<function>_leakage_eq`: runs
that agree on the public inputs have equal traces). The model is in
[`docs/Leakage.md`](../docs/Leakage.md). On all three instruction sets:

| Function | What its trace is a function of | Constant-time |
| --- | --- | --- |
| `swap` | the two addresses, the return address | yes |
| `copy_bytes` | the two addresses, the length, the return address | yes |
| `equal_bytes` | the two addresses, the length, the return address, and the index of the first byte that differs | no: it returns at the first difference, and the theorem says exactly that |
| `equal_bytes_ct` | the two addresses, the length, the return address | yes |
| `add_limbs` | the three addresses, the number of limbs, the return address | yes |
| `crc32` | the address, the length, the return address, and the two four-bit indices at which the table is read for each byte | no: the lookups index on the data, the theorem says exactly which indices, and from one starting value they determine the message (`crcIndices_inj`) |
| `quarter_round`, `chacha20_block` | the addresses, the stack pointer, the return address | yes |
| `sha256_round`, `sha256_schedule`, `sha256_compress` | the addresses, the stack pointer, the return address | yes |

## Recompiled

`chacha20.c` and `sha256.c` are compiled a second time, at `-O2`, and their five functions
are proved again on every instruction set, `_spec`, `_correct` and `_leakage`
(`<Module>/O2/<ISA>/`), with `Spec/` and `<Module>/Common.lean` as they are. What of each
proof survived the recompile is measured in [`docs/Continuity.md`](../docs/Continuity.md).

## A whole program

`c/sha256_main.c` is a program: `_start`, and a `main` that computes SHA-256 of a message in
the binary's data, calling `sha256_compress` for each block, writes the digest out and
exits. It is lowered as a loaded image (code, data sections, entry point), and
`Sha256Main/<ISA>/Proofs.lean` proves about the machine model alone, from the entry point and
with no hypothesis but that the binary is loaded, that it writes out the digest and exits
(`sha256_main_correct`), that what it reveals is a function of the length of the message
(`sha256_main_leakage`), and that it never stores outside its stack (`sha256_main_safe`).
On x86-64, whose model has no system call, the program leaves the digest in memory and
the first theorem says that.
See [`docs/Programs.md`](../docs/Programs.md).

What the examples exercise:

- **Straight-line code** (`add3`): operands, and on x86-64 the flags an addition sets.
- **A branch or a conditional move** (`max_u64`, `max2`, `swift_min`): the same source is a
  branch on RISC-V and in Go, `csel` on AArch64 and `cmov` on x86-64.
- **Loads and stores** (`swap`): points-to facts and the frame rule.
- **A loop over an array** (`sum_array`, `sum_slice`, `SumSlice`): a pointer walk on RISC-V,
  an indexed load on AArch64 and x86-64, a signed loop condition in Go.
- **A loop over bytes** (`str_len`, `fill`): byte loads and stores, and a comparison against
  memory on x86-64.
- **A loop the compiler removed** (`sum_to`): the binary multiplies at double width and
  shifts; the specification is the sum, and a lemma connects the two.
- **A loop that needs a measure** (`gcd`, `count_ones`): termination by strong induction.
- **A call with a stack frame, and a tail call** (`max3`): a callee-saved register saved
  around the call. On x86-64 the return address is a word on the stack, pushed by `call` and
  popped by `ret`.

- **Two regions that may overlap** (`equal_bytes`): memory as a set of single bytes, opened
  at each load.
- **A table in read-only data** (`crc32`, `sha256_compress`): a read-only array opened at an
  index the code computes.
- **Multi-word arithmetic** (`add_limbs`): the specification is an equation between natural
  numbers.
- **A function too long to run in one go** (`chacha20_block`, `sha256_compress`): loops by
  induction with the state folded back into the specification after each round, and the
  arithmetic of a round as a separate lemma.
- **Code from a just-in-time compiler** (`js_add3`): the machine code V8 produced for a
  JavaScript function after it had run on small integers. The code checks that it has not
  been marked for deoptimisation, that the stack has room, that each argument is a tagged
  small integer and that the sum does not overflow, and the theorem is about the path on
  which the checks pass. Its proof is three lemmas, for the prologue, the body and the
  epilogue, joined by the frame rule.
- **A foreign calling convention** (`py_add3`): Numba's compiled functions return a status
  and write their result through a pointer.

One specification serves a function on every instruction set, up to the names of the
registers: `max2_spec` says `umax a b` everywhere, and `sum_array_spec` says `wsum xs 0`.

## Building

```sh
lake build braid-lower      # the decompiler
Examples/build.sh           # compile and lower every example, for every instruction set
Examples/build.sh memory    # one example
Examples/build.sh sha256main  # the whole program (after sha256)
ISAS=x86 Examples/build.sh  # one instruction set
lake build Examples         # check every image and every proof
```

`build.sh` needs clang with the RISC-V, AArch64 and x86-64 targets, a RISC-V linker, `lld`,
and `rustc`, `swiftc`, `go`, Node, and a Python with Numba (named by `PYTHON`) for those
examples. The tools are named by variables at the top
of the script. The lowered images are in the repository, so `lake build Examples` needs none
of them.

How each language reaches all three instruction sets:

| Language | Route |
| --- | --- |
| C | clang, once for each target |
| Rust, Swift | the compiler's LLVM IR, then clang for each target, so that one back end produces the code for all three |
| Go | Go's own back ends and linker. Its RISC-V back end emits compressed instructions, which the RISC-V model does not have, so Go is lowered for AArch64 and x86-64 |
| Python | [Numba](https://numba.pydata.org) compiles a typed Python function through LLVM; `src/python/emit_ll.py` writes its IR, which then goes the way of Rust's and Swift's |
| JavaScript | V8's optimising compiler, as Node prints its output (`node --print-opt-code`); `src/js/emit_s.py` writes the bytes back as an assembly file. The code is for the machine Node runs on: AArch64 from a native Node, and x86-64 from an x86-64 build of Node (`NODE_X64`, which on an Apple machine runs under Rosetta) |

## Writing a proof

A proof file imports its image and states a triple about the lowered function:

```lean
theorem swap_spec (p q x y t0 t1 s r : Word) :
    Triple swap.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi p, .reg rsi q, .reg rax t0, .reg rcx t1,
        .mem p 8 x true, .mem q 8 y true, .reg rsp s, .mem s 8 r true])
      (Atoms.interp [.pc r, .reg rdi p, .reg rsi q, .reg rax x, .reg rcx y,
        .mem p 8 y true, .mem q 8 x true, .reg rsp (s + 8#64), .mem s 8 r true]) := by
  braid_run
  braid_done
```

The precondition lists what the function may touch: the program counter at its entry, the
registers it reads and writes, the memory it reads and writes, and here the word on the stack
that holds the return address. `braid_run` executes the blocks on that symbolic state until
the program counter leaves the function. [`braid/README.md`](../braid/README.md) describes
the tactics, and [`docs/Walkthrough.md`](../docs/Walkthrough.md) follows one function from
its source to the machine.

Three habits from the corpus:

- **A loop is a lemma.** State the loop from an arbitrary iteration, prove it by induction on
  what is left to do, and call it from the function's specification with `braid_call`.
- **Flags are part of the state.** On AArch64 and x86-64 a function that compares owns the
  flags it sets. Take them in the precondition with any value, and leave them as `flagAny` in
  the postcondition (`x86_forget_flags` does all six).
- **Say what the compiler did, not what you wrote.** `sum_to` in `basic.c` is a loop in the
  source and, on every instruction set, a closed form with a 128-bit product in the binary.
  Its proof is the symbolic run and one lemma of arithmetic, `tri_closed`, shared by all
  three.

## What the corpus found

Running real compiler output through the lowerings is how most of their gaps were found. The
ones still open are in [`docs/Roadmap.md`](../docs/Roadmap.md); the ones that are properties
of a model are in [`docs/ISA.md`](../docs/ISA.md). `braid-lower --stats` on a whole Go binary
is the broadest test: 95% of its instructions lower on AArch64, and 95% on x86-64.

Every C function is verified on all three instruction sets. What is not verified, and why:
`gcd` on x86-64, because the machine model has no `div`; the last instruction of the
JavaScript function on x86-64, `ret 0x20`, which the model does not have either; and
JavaScript on RISC-V, for which there was no V8 to run.
