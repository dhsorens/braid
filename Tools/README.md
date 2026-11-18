# Tools

Two programs, built by `lake build`:

- `braid-lower`, the decompiler: a binary in, lowered functions out, as MLIR text and as a
  Lean module.
- `braid-difftest`, which runs a function on the machine model and on its lowering side by
  side.

Neither is trusted ([`docs/Trust.md`](../docs/Trust.md)). Nothing in `braid/`, `Lowering/` or
a proof imports this directory.

```
Elf.lean       an ELF64 reader: sections and function symbols
RiscV.lean     the RISC-V front end
Arm.lean       the AArch64 front end
X86Asm.lean    x86-64: the text of `objdump -d`, as a Kraken executable
X86.lean       the x86-64 front end
Main.lean      braid-lower
DiffTest.lean  braid-difftest
```

## Installing

```sh
lake build braid-lower braid-difftest
```

The programs are `.lake/build/bin/braid-lower` and `.lake/build/bin/braid-difftest`. Copy
them onto your `PATH`, or run them through `lake exe braid-lower`.

## braid-lower

```
braid-lower <binary> [--list] [--stats] [--fn <name>]... [--mlir <file>] [--lean <file>]
                     [--norm <file>] [--module <Name>] [--disasm <file>]
```

| Option | What it does |
| --- | --- |
| `--list` | print the functions of the binary (address, size, name) and stop |
| `--stats` | print how many instructions the lowering covers, and what the others are |
| `--fn <name>` | lower this function; repeat for more; the default is every function |
| `--mlir <file>` | write the lowered functions in MLIR's generic syntax |
| `--lean <file>` | write the lowered functions as a Lean module |
| `--module <Name>` | the namespace of the Lean module |
| `--norm <file>` | write position-independent text, for comparing two lowerings |
| `--disasm <file>` | x86-64 only: the output of `objdump -d` on the binary |

The instruction set is read from the ELF header.

```sh
$ braid-lower Examples/bin/rustbasic.rv.elf --list
0x10000 12 add3
0x10010 24 gcd
...
$ braid-lower Examples/bin/rustbasic.rv.elf --fn gcd \
    --mlir gcd.mlir --lean Gcd.lean --module Gcd
$ mlir-opt --allow-unregistered-dialect gcd.mlir -o /dev/null   # MLIR tools read the text
```

### The Lean module

For each function the module holds three declarations:

| Declaration | What it is |
| --- | --- |
| `<f>_code` (RISC-V), `<f>_words` (AArch64) | the instructions of the function, as the model has them |
| `<f> : Braid.Func` | the lowered function |
| `<f>_lowered` | a theorem: the blocks of `<f>` are the lowering of the instructions |

The module imports the lowering of its instruction set, so a proof that imports it has the
logic, the lowering's soundness theorem and the function in scope.

### Front ends

**RISC-V.** The words of a function are decoded with riscv-zkvm's decoder. A word it rejects
has no block, and `braid-lower` warns: a compressed instruction, for instance, or one of the
RV64 word operations the model does not have yet ([`docs/ISA.md`](../docs/ISA.md)). Compile
with `-march=rv64im`.

**AArch64.** The words are decoded with the model's own decoder, the one its step function
uses.

**x86-64.** Kraken's programs are assembly. `braid-lower` reads the disassembly `objdump -d`
prints (`--disasm`), parses each instruction with Kraken's own parser, and lays the
instructions out at the addresses and sizes of the binary. An instruction the parser does not
know becomes data: it keeps its place, and execution that reaches it is not defined.

### Coverage

`--stats` is the quickest way to see whether a binary is within reach:

```sh
$ braid-lower Examples/bin/memory.rv.elf --stats
functions:    4
instructions: 32
lowered:      32 (100%)
undecoded:    0
trap:         0
```

A `trap` line names an instruction the model has and the lowering does not cover yet.

## braid-difftest

```
braid-difftest <binary> --fn <name> [--args a,b,..] [--steps n] [--seed n --runs n]
```

It sets up a call to the function (arguments in the argument registers, a stack, a return
address where no code is), then steps the machine model and the `braid` interpreter together,
comparing the program counter and every register after each instruction, until the function
returns.

```sh
$ braid-difftest Examples/bin/rustbasic.rv.elf --fn gcd --args 48,18
gcd: agree after 14 instructions, a0 = 0x6
$ braid-difftest Examples/bin/rustbasic.rv.elf --fn gcd --runs 200 --seed 3
gcd: 200/200 runs agree
```

With `--runs`, the arguments are pseudo-random words, biased towards small values and the
ends of the range.

The lowerings are proved sound, so a disagreement would not mean a wrong theorem. What this
looks for is the lowered code faulting where the machine runs: a `guard` stricter than the
model, or an instruction lowered to `trap` on a path that matters. It runs RISC-V binaries.
