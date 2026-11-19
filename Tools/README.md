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
DiffTest.lean  braid-difftest (RISC-V, and the command line)
DiffTestMore.lean  braid-difftest for AArch64 and x86-64
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
| `--simplify` | fuse straight-line blocks and remove dead work (`Func.simplifyBy`, with the plan `Func.fusePlan`) in the MLIR and position-independent text |
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

On x86-64 the machine model's program is one executable for the whole image, so the module
also holds the image:

| Declaration | What it is |
| --- | --- |
| `<f>_code` | the lines of the function: address, size, label and instruction |
| `image`, `image_wf` | the lines of every function lowered, and the certificate that they follow one another |
| `exe` | the model's executable of the image |
| `<f> : Braid.Func`, `<f>_lowered` | as above |
| `<f>_holds` | a theorem: the blocks of `<f>` are blocks of the lowering of `exe`, which is what `machine_sound` asks for |

A function of more than 128 blocks is written in parts: definitions `<f>_blocks_0`,
`<f>_blocks_1`, ... of 128 blocks each, which `<f>` appends, and its certificates are checked
with `decide +kernel`. Lean's elaborator runs out of depth on one long list; the kernel does
not ([`docs/Scaling.md`](../docs/Scaling.md)).

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
know becomes data: it keeps its place, and execution that reaches it is not defined. A
relative jump or call is given its target as an address, so that it may leave the functions
lowered; a conditional jump names a label, which must be among them.

```sh
$ objdump -d prog.elf > prog.dis
$ braid-lower prog.elf --disasm prog.dis --fn max2 --fn max3 \
    --mlir prog.mlir --lean Image.lean --module Image
```

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

A `trap` line names an instruction the model has and the lowering does not cover yet. On
x86-64 the instructions the model's parser does not read are listed by mnemonic, and the
`int3` bytes between functions are left out of the count.

## braid-difftest

```
braid-difftest <binary> --fn <name> [--args a,b,..] [--steps n] [--seed n --runs n]
                        [--disasm <file>]
```

It sets up a call to the function (arguments in the argument registers, a stack, a return
address where no code is), then steps the machine model and the `braid` interpreter together,
comparing the program counter, every register and every flag after each instruction, until
the function returns. It runs binaries of all three instruction sets; an x86-64 binary needs
`--disasm`, as for `braid-lower`.

```sh
$ braid-difftest Examples/bin/rustbasic.rv.elf --fn gcd --args 48,18
gcd: agree after 14 instructions, a0 = 0x6
$ braid-difftest Examples/bin/rustbasic.arm.elf --fn gcd --runs 300 --seed 5
gcd: 300/300 runs agree
$ braid-difftest Examples/bin/memory.x86.elf --disasm Examples/bin/memory.x86.dis \
    --fn max3 --runs 300 --seed 5
max3: 300/300 runs agree
$ braid-difftest Examples/bin/basic.x86.elf --disasm Examples/bin/basic.x86.dis \
    --fn sum_to --args 10
sum_to: MISMATCH after 10 instructions at 0x401040: the machine steps, the lowered code faults
```

With `--runs`, the arguments are pseudo-random words, biased towards small values and the
ends of the range.

The lowerings are proved sound, so a disagreement would not mean a wrong theorem. What this
looks for is the lowered code faulting where the machine runs: a `guard` stricter than the
model, or an instruction lowered to `trap` on a path that matters. The last run above is one:
`0x401040` is a `shld`, which the x86-64 lowering does not cover yet.

Where the lowering leaves a flag undefined that the model defines, as it does the auxiliary
carry flag on x86-64, the tester follows the `havoc` through the block, does not compare that
flag, and goes on with the model's value. A value the model itself leaves undefined is zero.
