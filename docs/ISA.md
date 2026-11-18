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
- `ECALL`, `EBREAK` and the accelerator instructions lower to `trap`.

### What we would like from it

riscv-zkvm was built for zkVM guests, and the lowering is the first use of it for compiled
code in general. These are the places where that shows, most pressing first. Each is a
candidate for a branch of riscv-zkvm.

1. **The RV64 word operations.** `ADDW`, `SLLW`, `SRAW`, `SRAIW`, `MULW`, `DIVW`, `DIVUW`,
   `REMW` and `REMUW` are not in `Instr` (`ADDIW`, `SUBW`, `SRLW`, `SLLIW` and `SRLIW` are).
   Compilers emit them for every 32-bit `int`. Until they are there, the examples use 64-bit
   types on RISC-V.
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

The lowering covers the integer core. It does not yet cover `RBIT`, `CLZ` and `CLS`, the
atomics and exclusives, CRC, system registers and system calls, or floating point and SIMD.
On a complete Go binary (118,148 instructions, the Go runtime included), 95% of the
instructions lower to something other than `trap`; the rest are, in order, load-acquire and
store-release, exclusives, SIMD and floating point, and `CLZ`.

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
- A flag the model leaves undefined is a `havoc`.

Because programs are assembly, a theorem about x86-64 code is about the instructions the
disassembler printed. Checking them against the bytes of the binary is later work
([`Trust.md`](Trust.md)).

The model has no `div`, `idiv`, `xchg`, `cdq`/`cqo`, `leave`, `bt` or `endbr64`. Compiled code
uses the first few often. Instructions it lacks are contributed to Kraken, not added here.
