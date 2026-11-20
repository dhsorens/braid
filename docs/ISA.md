# The instruction-set models

Each instruction set has one model, a dependency used unmodified at a pinned revision
(`lakefile.toml`). A theorem about a binary is stated against it. This page says what each
model is, how the lowering sees it, and what we would like from it next.

| ISA | Model | Pinned at | Programs are |
| --- | --- | --- | --- |
| RISC-V RV64IM | [riscv-zkvm](https://github.com/Verified-zkEVM/riscv-zkvm), `RiscvZkvm.Rv64` | `d81a910` | a map from addresses to instructions |
| AArch64 | [arm64-semantics](https://github.com/google-deepmind/code-verification/tree/main/arm64-semantics), trusted package | `b0f729a` | bytes in memory, fetched and decoded by the step |
| x86-64 | [Kraken](https://github.com/AeneasVerif/kraken), `Kraken.X64` | `ebd10eb` | assembly: instructions with sizes, laid out from a start address |

All three build on Lean v4.36.0, the toolchain of this repository.

## RISC-V: riscv-zkvm

`RiscvZkvm.Rv64` is a computable RV64IM machine: `MachineState`, `step`, `stepN`. Its
instructions are proved equivalent to the Sail RISC-V model one by one
(`RiscvZkvm.Rv64.SailEquiv`), which is what ties a theorem here to the official
specification.

How the lowering sees it:

- Register `xN` is `braid` register `N`. `x0` is never read or written.
- Memory in the model is a map from addresses to 64-bit doublewords, and a byte is read out
  of the doubleword that holds it. `braid` memory is bytes. `Lowering/RiscV/Mem.lean` proves
  what each aligned access does to the bytes.
- An access must be aligned and inside the model's valid ranges. The lowering emits a
  `guard` for the alignment; the range is which bytes are mapped.
- Code is a separate map, so stores cannot change it.
- `ECALL`, `EBREAK` and the accelerator instructions lower to `trap` when a function is
  lowered. When a whole binary is ([`Programs.md`](Programs.md)), `ECALL` is lowered to the
  two calls the model gives a meaning that a program can use: with `t0 = 0x10` it writes
  bytes out, and with `t0 = 0` it halts with the code in `a0`. Those are the dialect's
  `out` and `exit`, and the events of a labelled run.

### What we would like from it

riscv-zkvm was built for zkVM guests, and the lowering is the first use of it for compiled
code in general. These are the places where that shows, most pressing first. Each is a
candidate for a branch of riscv-zkvm.

1. **The RV64 word operations.** `ADDW`, `SLLW`, `SRAW`, `SRAIW`, `MULW`, `DIVW`, `DIVUW`,
   `REMW` and `REMUW` are not in `Instr` (`ADDIW`, `SUBW`, `SRLW`, `SLLIW` and `SRLIW` are).
   Compilers emit them for 32-bit arithmetic whose result has to be in canonical form. The
   first examples use 64-bit types on RISC-V for that reason. The scaling ladder, CRC-32,
   ChaCha20 and SHA-256 included, needed neither a change to its sources nor a branch of the
   model: at `-O1` clang keeps a 32-bit value in a 64-bit register with whatever the
   additions left above it, adds with `ADD`, and narrows only where it must, with `SLLIW`,
   `SRLIW` and `SW`, which the model has. So the ladder is lowered and proved on RISC-V from
   the same C as on the other two, and a register there is specified up to its low half.
2. **Compressed instructions.** The model steps by four bytes. Go's RISC-V back end and the
   default Rust targets emit the C extension: on a Go binary, more than half the code does
   not decode. The examples are compiled with `-march=rv64im`; Go is lowered for AArch64 and
   x86-64 only.
3. **The memory map.** The valid ranges are those of one emulator (`0x20..0x78000000` and
   `0xa0000000..0xc0000000`). A general model would take the map as a parameter.
4. **The extent of an access.** The validity check looks at the first address of an access
   and not its last. The lowering is sound regardless, because `braid` asks for every byte.
5. **Bytes.** Doubleword-addressed memory makes every sub-word access a mask and a shift. A
   byte-addressed memory would remove `Lowering/RiscV/Mem.lean`.
6. **The decoder.** `RiscvZkvm.Interpreter.decode` is not yet related to Sail's decoder, so
   that the instructions of a binary are the ones in `<f>_code` is trusted
   ([`Trust.md`](Trust.md)).
7. **Environment calls.** `step` gives `ECALL` the meaning of two zkVM ABIs. A general model
   would take the environment as a parameter.

## AArch64: arm64-semantics

The trusted package of Google DeepMind's arm64-semantics: a `State`, a decoder, and a `Step`
relation that fetches four bytes from memory, decodes them and executes the instruction. It
is written from Arm's machine-readable specification and tested against other models. It
covers the integer core, loads and stores, atomics, floating point, SIMD and the crypto
extensions, and Linux system calls.

How the lowering sees it:

- `Xn` is `braid` register `n` for `n` up to 30, and `SP` is register 31. The flags `N`, `Z`,
  `C`, `V` are flags 0 to 3. The zero register is never read or written.
- Memory is bytes with permissions. A `braid` byte is mapped where the model would allow a
  read, and writable where it would allow a write.
- The model faults by setting a status. Every case in which an instruction would not leave
  the status `Running` makes the lowered block fault: a permission fault, an unaligned stack
  pointer, an instruction outside the lowering.
- Code is in memory. It is mapped read-execute, a `braid` store needs a writable byte, and so
  the code is still loaded after every step (`KeepsCode`).

The lowering covers the integer core, the load-acquire and store-release instructions, the
atomic read-modify-write instructions, and a first set of vector instructions: loads, stores,
moves, bitwise operations and lane-wise addition. It does not yet cover store-exclusive and
compare-and-swap, CRC, system registers and system calls, floating-point arithmetic, or the
rest of SIMD. On a complete Go binary (118,148 instructions, the Go runtime included), 97% of
the instructions lower to something other than `trap`; the largest groups left are
store-exclusive, AES and compare-and-swap.

What we would like: nothing in the model itself so far. Two things made proofs longer than
they should be, and are worth raising upstream: the `exec*` helpers bind pairs with `let (a,
b) := …`, which hides their bodies from `rw`; and shift amounts are natural numbers, which
`bv_decide` does not take.

## x86-64: Kraken

Kraken's x64 semantics (Lean FRO, Google and INRIA). Its programs are assembly, not bytes: a
list of directives, each with a size, laid out from a start address. An instruction's meaning
is written in continuation-passing style over an `Effects` type, and `Effects.All` reads it as
"every outcome satisfies the postcondition", with an undefined value as a universal
quantifier. The `braid` semantics has the same shape, which is why `havoc` exists.

How the lowering sees it:

- `rax` to `r15` are `braid` registers 0 to 15, in the model's order. The status flags `cf`,
  `pf`, `af`, `zf`, `sf`, `of` are flags 0 to 5, and `df` is flag 6.
- A sub-register (`eax`, `ax`, `al`, `ah`) is a read or write of the 64-bit register through
  masks and shifts, as the model's `Reg64s.get` and `Reg64s.set` have it.
- Memory is a partial map from addresses to bytes: exactly `braid` memory, with every byte
  writable.
- A flag the model leaves undefined is a `havoc`. So is the auxiliary carry flag, which no
  condition code reads.
- The model's programs are found again by address each time the machine steps. The lowering
  keeps a binary's code as lines (address, size, label, instruction), and
  `Lowering/X86/Layout.lean` proves that the model's executable of well-formed lines has, at
  each line's address, exactly that line.

Because programs are assembly, a theorem about x86-64 code is about the instructions the
disassembler printed. Checking them against the bytes of the binary is later work
([`Trust.md`](Trust.md)).

The lowering covers the moves, `lea`, the stack, the conditional moves and sets, addition and
subtraction with and without carry, comparison, the bitwise operations, shifts by an
immediate and by `cl`, double shifts and rotations by an immediate, `imul`, the widening
multiplications, `bswap`, and every jump, call and return. It does not yet cover rotations
through carry, the string instructions, a 32-bit address size, or the vector instructions. On a complete Go binary
(113,547 instructions, padding left out), 95% of the instructions lower to something other
than `trap`. Of the rest, three quarters are instructions the model's parser does not read
(moves through `xmm` registers, `lock`-prefixed and atomic instructions, bit tests), and
nearly all the others are vector instructions.

### What we would like from it

1. **Division.** The model has no `div` or `idiv`, nor `cdq`/`cqo` to set one up. Every `%`
   and `/` on a value that is not a constant compiles to them: `gcd` in the Rust and Swift
   examples is verified on RISC-V and stops at `divq` on x86-64.
2. **`xchg`, `xadd`, `cmpxchg` and the `lock` prefix**, which a Go or Rust runtime uses for
   every atomic.
3. **Bit tests and scans** (`bt`, `bts`, `bsf`, `bsr`, `popcnt`, `tzcnt`).
4. **The parser.** It reads the memory form of an indirect jump or call but not the register
   form (`jmpq *%rax`), which the front end builds itself; and it does not read `int3`,
   `ud2`, `leave` or `endbr64`.
5. **`ret` with an operand** (`ret 0x20`), which V8's code uses to pop its arguments.
6. **Bytes.** An encoder checked against the bytes of a binary, or a decoder, so that a
   theorem need not trust a disassembler.
7. **A system call.** The model has no `syscall` instruction, no instruction that halts
   (`hlt`, `ud2` and `int3` are not in its syntax either), and no output or exit status in
   its state, so a program on x86-64 cannot write bytes out or exit, and a run has no
   events. There is nothing in the model for a trusted reading to call an event, and
   instructions the model lacks are contributed to Kraken and not added here. This is the
   one gap that changes a statement of the whole program
   ([`Programs.md`](Programs.md)): on x86-64 `sha256_main` leaves the digest in memory
   and ends in a jump to itself, and `sha256_main_correct` says the machine gets there
   with `sha256` of the message at the address of `digest`, where on the other two it
   says the bytes were written and the program exited. What the run reveals and the
   safety property are proved as on the other two.
8. **An index with no base.** The parser does not read `lea 0x0(,%rax,8),%rdx`, which
   clang emits for a multiplication by eight. The whole program's source hides that one
   product from the compiler on x86-64 (`BITS` in `Examples/src/c/sha256_main.c`), which
   then shifts; nothing else in the examples met it.

Instructions the model lacks are contributed to Kraken, not added here.

## Vector code: a survey

`Examples/src/c/chacha20_vec.c` is the ChaCha20 block function over four rows of four 32-bit
lanes, in C with the compilers' vector types and no intrinsics. It was compiled for each
instruction set at the level of `Examples/build.sh` (`-O1 -fno-vectorize`), with vector
registers allowed, and lowered with `braid-lower --stats`. An instruction that does not
lower is of one of three kinds: the model has it and the lowering did not cover it (a
`trap`); the model's parser or decoder does not read it (undecoded); the model does not have
it. This table is what the lowering looked like before the work it sized.

| Target | Instructions | Lowered | `trap`: the model has it | Undecoded: the model does not read it |
| --- | --- | --- | --- | --- |
| AArch64, NEON | 54 | 34 | 20: `shl` and `usra` by lane (12), `ext` (6), `rev32` (2) | 0 |
| x86-64, SSE2 | 75 | 37 | 6: `pshufd` | 32: `pxor`, `por`, `pslld`, `psrld` (8 each) |
| x86-64, SSSE3 | 71 | 39 | 12: `pshufd`, `pshufb` | 20: `pxor` (8), `pslld`, `psrld`, `por` (4 each) |
| x86-64, AVX2 | 61 | 25 | 4 | 32: `vpxor` (8), `vpshufb` (7), `vpshufd` (5), `vpslld`, `vmovdqa`, `vpor` (4 each) |
| x86-64, AVX-512VL | 48 | 25 | 0 | 23: `vprold`, `vpxor` (8 each), `vpshufd` (6), `vmovdqa` (1) |
| RISC-V, RV64IM | 248 | 248 | 0 | 0 |
| RISC-V, RV64IMV | 79 | 10 | 0 | 69: every instruction of the vector extension |

**AArch64.** Everything is in the model, and the four forms were lowered
([`Lowering/README.md`](../Lowering/README.md)).

**x86-64.** The compiled function cannot be lowered at any level of the vector extensions:
Kraken has no exclusive or of vector registers under any name (`pxor`, `vpxor`, `vpxord`),
no shift of lanes to the left (`pslld`, `vpslld`), no `por`, and of the two rotations of
lanes it has `vprord` and not `vprold`, which is the one clang emits. Its vector operations
are the constructors of `AvxOperation`: the moves, `paddd` and `vpaddd`, `pshufb`, `pshufd`,
`palignr`, `pblendw`, `vprord`, `vpsrld`, `vpternlogd`, and the three SHA-256 instructions.
Those are enough to write the function by hand: an exclusive or is `vpternlogd` with the
table `0x5a`, and a rotation to the left by `n` is `vprord` by `32 - n`.
`Examples/src/asm/chacha20_vec.x86.S` is the block function written so, for AVX-512VL, and
it is the x86-64 code that is lowered and proved. So on x86-64 the theorem is about
hand-written assembly in the model's instructions and not about a compiler's output for the
C source; the instructions named above are what the model would need for the latter.

**RISC-V.** The pinned model has nothing of the vector extension: its decoder reads no
instruction of it. Compiled for RV64IM the vector types of the C source become scalar code,
248 instructions that all lower, which is ChaCha20 once more and not vector code. Nothing
about vector code is proved on RISC-V.

### The SHA extensions

`Examples/src/c/sha256_ni.c` is the SHA-256 compression function from the compilers'
intrinsics, compiled with `+sha2` on AArch64 and with `-msha -msse4.1` on x86-64. Before
the work it sized:

| Target | Instructions | Lowered | `trap`: the model has it | Undecoded |
| --- | --- | --- | --- | --- |
| AArch64, SHA-2 | 42 | 36 | 6: `sha256h`, `sha256h2` (2 each), `sha256su1`, `sha256su0` | 0 |
| x86-64, SHA | 56 | 39 | 17: `pshufd`, `palignr`, `pblendw`, `sha256rnds2`, `sha256msg1`, `sha256msg2` | 0 |

Both models give every one of these a meaning, so nothing here is a gap of a model. RISC-V
has no instruction for SHA-256 rounds in the pinned model (the scalar `Zknh` extension is
not in it either).
