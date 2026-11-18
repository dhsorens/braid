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
continuity/    the continuity experiment (docs/Continuity.md)
```

## What is verified

A name in the table is a function with a proved specification. **Bold** means the proof goes
down to a theorem about the machine model alone (`<function>_correct`).

| Source | RISC-V | AArch64 | x86-64 |
| --- | --- | --- | --- |
| `c/basic.c` | **add3**, **max_u64** | **add3**, max_u64 | **add3**, max_u64 |
| `c/memory.c` | swap, max2, max3, sum_array | swap, max2, max3, sum_array | swap, **max2**, max3, sum_array |
| `c/bytes.c` | str_len, **count_ones** | str_len, count_ones | str_len |
| `rust/basic.rs` | **gcd** | add3, max_u64, **gcd**, sum_slice | add3, max_u64, sum_slice |
| `swift/basic.swift` | swift_add3, swift_min, **swift_gcd** | swift_add3, swift_min, swift_gcd | swift_add3, swift_min |
| `go/basic.go` | not lowered | Add3, MaxU64, SumSlice | Add3, MaxU64 |
| `python/basic.py` | py_add3, py_max_u64, py_gcd | py_add3, py_max_u64 | py_add3, py_max_u64 |
| `js/basic.js` | | js_add3 | |

What the examples exercise:

- **Straight-line code** (`add3`): operands, and on x86-64 the flags an addition sets.
- **A branch or a conditional move** (`max_u64`, `max2`, `swift_min`): the same source is a
  branch on RISC-V and in Go, `csel` on AArch64 and `cmov` on x86-64.
- **Loads and stores** (`swap`): points-to facts and the frame rule.
- **A loop over an array** (`sum_array`, `sum_slice`, `SumSlice`): a pointer walk on RISC-V,
  an indexed load on AArch64 and x86-64, a signed loop condition in Go.
- **A loop over bytes** (`str_len`): byte loads, and a comparison against memory on x86-64.
- **A loop that needs a measure** (`gcd`, `count_ones`): termination by strong induction.
- **A call with a stack frame, and a tail call** (`max3`): a callee-saved register saved
  around the call. On x86-64 the return address is a word on the stack, pushed by `call` and
  popped by `ret`.

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
| JavaScript | V8's optimising compiler, as Node prints its output (`node --print-opt-code`); `src/js/emit_s.py` writes the instruction words back as an assembly file. The code is for the machine Node runs on, so this example is AArch64 only |

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
  source and a closed form with a 128-bit product on x86-64. The proof is about the binary.

## What the corpus found

Running real compiler output through the lowerings is how most of their gaps were found. The
ones still open are in [`docs/Roadmap.md`](../docs/Roadmap.md); the ones that are properties
of a model are in [`docs/ISA.md`](../docs/ISA.md). `braid-lower --stats` on a whole Go binary
is the broadest test: 95% of its instructions lower on AArch64, and 95% on x86-64.

What is not verified, and why: `gcd` on x86-64, because the machine model has no `div`;
`sum_to`, which every compiler turns into a closed form whose correctness is a fact of
arithmetic not yet proved here; `fill`; and JavaScript on RISC-V and x86-64, because V8
emits code for the machine it runs on.
