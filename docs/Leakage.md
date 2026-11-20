# Leakage

What a run reveals to whoever watches the machine, and how a theorem here says so. This page
gives the leakage model, where it comes from, how it is written in the dialect and for each
machine model, and what it leaves out. What has to be right for a leakage theorem to mean
what it says is in [`Trust.md`](Trust.md).

## The model

The model is the one cryptographers call *constant time*. A run reveals three things:

1. **Where control goes.** The target of every conditional branch and every computed jump.
2. **Which memory is touched.** The address and size of every load and store. The bytes
   read or written are not revealed.
3. **The operands of an instruction whose time depends on them.** Here: division and
   remainder.

A program is constant-time when what it reveals does not depend on its secrets: two runs
that agree on the public inputs reveal the same thing. It does not have to take the same
number of steps on every input. `equal_bytes` returns at the first byte that differs, and
that is a leak only if the position of the difference is a secret.

A theorem here says more than "constant-time, yes or no". It gives what the run reveals as an
explicit function of named inputs, and the two-run statement follows from it: if the function
does not mention the secret, the secret is not revealed.

## Where it comes from

The model, with these three parts, is that of **ct-verif** [1]: a leakage model maps each
configuration of a run to an observation, the observations of a run are concatenated, and a
program is secure when runs from states that agree on the public inputs are
indistinguishable. Its three examples are branch conditions, the addresses of loads and
stores, and the operands of division.

**Jasmin** instruments its semantics "to produce a leakage trace that records the branches
that are taken and memory read/write operations performed" [2], and at the level of assembly
"the sequence of addresses accessed and program point visited". Its later EasyCrypt
embedding keeps "a distinguished leakage variable (modeled as a list of events)" for
"time-varying instructions, targets of conditional jumps and memory accesses", and calls a
program secure when two executions with equal public inputs yield equal leakage [3]. The
proof in Coq that the Jasmin compiler preserves constant time is in [4], where "control-flow
instructions leak the branch in which they jump, and memory-accessing instructions leak the
address (not the value) being accessed".

**CompCert** was extended the same way [5]: its traces of events carry the truth value of
each condition and the address of each memory access or called function, and the compiler is
proved to preserve the property that two runs from related states observe the same leakage.

At the level of binaries, **Binsec/Rel** [6] labels each transition of a lifted binary with
its leakage, at loads, stores, conditionals and computed jumps, and takes the leakage of a
run to be the concatenation; it notes that some versions of constant time also include the
operands of variable-time instructions, and leaves them out. **Vale** [7] gives the machine
state a ghost trace that "captures all branches and memory access locations" and "all inputs
to variable-latency instructions", and proves of assembly that equal public inputs give
equal traces. EverCrypt states the same guarantee for the code it ships [8].

So the model here is the common one, with the third part included as ct-verif and Vale
include it.

### Which instructions depend on their operands

Each instruction set says which instructions take a time independent of their operands,
when the processor is in the right mode.

| | Document | Multiplication | Shifts | Division | Branches, addresses |
| --- | --- | --- | --- | --- | --- |
| RISC-V | Zkt, "data-independent execution latency" [9] | listed | listed | "division and remaindering excluded" | "Loads, stores, conditional branches are excluded" |
| AArch64 | `PSTATE.DIT` [10] | listed (`MADD`, `SMULH`, `UMULH`, …) | listed | `UDIV`, `SDIV` not listed | branches not listed; a load's time is independent of the data, not of the address |
| x86-64 | Data Operand Independent Timing [11] | listed (`MUL`, `IMUL`) | listed (`SHL`, `SHR`, `SAR`, `ROL`, `ROR`, `SHLD`, `SHRD`) | `DIV`, `IDIV` not listed | no `Jcc`; latency may vary with addresses |

The three agree on what matters here: additions, logic, shifts, multiplications and
conditional moves reveal nothing about their operands, and division does. That is the rule
in the dialect: of the value operations, `udiv`, `urem`, `sdiv` and `srem` emit their
operands, and no other does. The lists were read as described under [Sources](#sources);
the Arm and Intel entries are from copies and summaries of the vendors' pages and should be
checked against the originals before they are relied on for an instruction not named above.

### Vector and cryptographic instructions

The same three lists speak of vector code, each in its own way.

| ISA | The list says | Of the instructions the examples use |
| --- | --- | --- |
| AArch64 | `DIT` is stated instruction by instruction: the page of each covered instruction says it "is a data-independent-time instruction" [10, 18] | vector `ADD`, `EOR`, `SHL`, `USRA`, `USHR`, `SRI`, `SLI`, `EXT`, `REV32` and `TBL`, and `SHA256H`, `SHA256H2`, `SHA256SU0`, `SHA256SU1`, all carry the sentence. A vector floating-point addition does not |
| x86-64 | one table of mnemonics and opcodes [11] | `VPADDD`, `PADDD`, `VPTERNLOGD`, `VPRORD`, `VPSRLD`, `PSHUFD`, `PSHUFB`, `PALIGNR`, `PBLENDW`, the moves, and `SHA256RNDS2`, `SHA256MSG1`, `SHA256MSG2` are on it. So are `PXOR`, `PSLLD` and `VPROLD`, which a compiler would use and the model lacks ([`ISA.md`](ISA.md)). Gathers and compressions are not |
| RISC-V | Zvkt [19] adds no instruction: it asks for data-independent latency of the vector integer additions, logic, shifts, multiplications, merges, permutations and slides, with shift amounts and gather indices as control operands that are exempt | none: the pinned model has no vector extension |

Two caveats come with the lists. Intel's table does not say which operand forms it covers,
and says a listed instruction "may have variable latency for reasons unrelated to the data
values (for example, loading data from memory ...)": with a memory operand an instruction
is its register form and a load, and the load reveals its address here as any load does.
And Arm's sentence about loads and stores is that their time is "insensitive to the value
of the data being loaded or stored", which says nothing of the address; the address is a
label here.

**No instruction of the vector examples is on no list.** Every vector instruction the
lowerings cover is on its vendor's list, so none reveals its operands; the labels of
vectorised ChaCha20 and of SHA-256 with the SHA instructions are the addresses of their
loads and stores and the branches of their loops. An instruction the lowerings do not
cover has no reading, and a run with a trace has no step through it
([`Trust.md`](Trust.md)).

**How vectorised ChaCha20 is written.** In two shapes [20-24]. In the *row* form the state
of one block is four vectors of four 32-bit lanes, a column round is four quarter rounds at
once, and a diagonal round is a column round between two rotations of the rows' lanes
(`pshufd` on x86-64, `ext` on AArch64). In the *lane* form sixteen vectors each hold one
word of the state for as many blocks as the vector has lanes, and the output is transposed
at the end. Libraries use the row form for one or two blocks and the lane form for four or
more: OpenSSL and BoringSSL have both on each instruction set, the Linux kernel's NEON
code has rows with `ext` for one block and lanes for four, libsodium has rows for one
block and lanes for four and eight, and HACL* has only the lane form. The rotations of a
lane are a byte shuffle or a reversal of halves for 16 and 8 (`pshufb`; `rev32` on 16-bit
lanes, `tbl`), a shift to each side for 12 and 7 (`pslld` and `psrld`; `shl` with `sri` or
`usra`), and `vprold` with AVX-512. `Examples/src/c/chacha20_vec.c` is the row form for one
block; clang compiles it for AArch64 to `rev32`, `shl`, `usra` and `ext`, as the libraries
write by hand.

## In the dialect

A label (`Braid.Label`, in `braid/Braid/IR/Trace.lean`) is one observation:

| Label | Emitted by |
| --- | --- |
| `read addr n`, `write addr n` | `load` and `store` |
| `jump target` | a `branch`, with the target it takes, and a `jumpInd` |
| `operands a b` | `udiv`, `urem`, `sdiv`, `srem` |
| `event e` | an event of the environment: an exit, bytes written out |

A direct jump emits nothing: where it goes is in the code. The trace of a run is its labels
in order. The labelled semantics (`Op.wpL`, `Block.wpL`, `EventuallyL`) is the semantics of
the dialect with the trace so far carried along, and forgetting the trace gives back the
unlabelled one (`eventuallyL_iff`): every statement about a run without its trace is a
statement about the run with it.

In the logic, `TripleT P pre t post t'` is a triple with the trace before and the trace
after. A specification of leakage is one from any `t` to `t ++ ls`, with `ls` written out:

```lean
theorem swap_trace (p q x y t2 t3 r : Word) (hp : p &&& 7#64 = 0#64) (hq : q &&& 7#64 = 0#64)
    (t : Trace) :
    TripleT swap.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 p, .reg a1 q, .reg a2 t2, .reg a3 t3,
        .mem p 8 x true, .mem q 8 y true, .reg ra r]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 p, .reg a1 q, .reg a2 y, .reg a3 x,
        .mem p 8 y true, .mem q 8 x true, .reg ra r])
      (t ++ [.read q 8, .read p 8, .write p 8, .write q 8, .jump (r &&& ~~~1#64)]) := by
  braid_sym_run
  braid_done
```

The trace mentions the two addresses and the return address, and not `x` or `y`: `swap`
reveals where it works and nothing of what it moves. The stepper and the tactics are the ones
that prove a triple; on a traced triple they keep the trace as well.

### A trace the run finds

A traced triple states the trace before the proof starts. For a function of any size that
is a list written by hand, label by label, and written again when the compiler reorders a
load. A statement can leave it open instead (`braid/Braid/Logic/Traced.lean`):

```lean
def swap_run (p q r : Word) : { ls : Trace // ∀ (x y : Word) (t : Trace),
    TripleT swap.program (pre p q r x y) t (post p q r x y) (t ++ ls) } := by
  braid_traced
  intro x y t
  braid_sym_run
  braid_done
```

The definition is a trace and the traced triple that leaves it. `braid_done` finds the
trace: the labels the stepper added, gathered into one list. `(swap_run p q r).1` is what
`swap` reveals, and a theorem about the machine is stated with it.

**What the trace may depend on is a matter of scope.** The trace is found among the
variables bound before the pair: the two addresses and the return address above, and not
the words `x` and `y` at those addresses. A run whose labels mention `x` cannot be closed,
because the value to be found is not in the scope of `x`. So the binders of such a
definition are the public inputs of its code, and that what a run reveals is a function of
them alone, which a two-run statement then says in so many words, is checked when the
definition is. For code that does reveal data (`equal_bytes`, `crc32`), the data it reveals
has to be bound before the pair, and that is the statement of what leaks.

A loop is a definition by recursion on the turns left, as its triple is a proof by
induction: one turn runs the body and calls the definition for the rest, and the trace
found is the labels of a turn before the trace of the rest. Its two equations hold by
`rfl`. The explicit form of a whole trace, where a reader wants to see it, is a theorem
proved by `rfl` from the definition and not the definition itself.

The leakage proofs of ChaCha20, of the vectorised ChaCha20 and of SHA-256 with the SHA
instructions are written this way; those of the rest of the ladder state their traces.

## On a machine

For each instruction set, a file says what each instruction of the machine model reveals
and which of the model's system calls are which events (`Lowering/RiscV/Leak.lean`), and a
run of the machine with its trace (`RunL`) is the labels of the instructions it executes, in
order. That file is trusted ([`Trust.md`](Trust.md)).
The lowering is proved to preserve traces: the labels the block of an instruction emits are
those of the instruction (`leak_lower`), so a traced triple about lowered code is a theorem
about a run of the machine and its trace (`machine_soundT`).

The proof does not redo the proof that the lowering is sound. The labels a block emits are a
function of the state it starts from (`Block.leak`, with `Block.wp_of_wpL`), and that function
is compared with the instruction's labels by evaluation, one instruction at a time.

## Events of the environment

The fifth label is not something a step reveals. It is something the program does to the
world: `write bs`, the bytes `bs` written out, or `exit code`. A system call is lowered to
the dialect's `out` and `exit` when a whole binary is lowered ([`Programs.md`](Programs.md)),
and each emits its event. A trace then has two readings. `Trace.events` is what the program
did: the theorem that a program is correct says its events are the right output and then the
exit. `Trace.leakage` is the trace without its events: the theorem about what a program
reveals says its leakage is a function of public inputs. The digest a program writes out
depends on every byte of the message and is in the trace; it is not in the leakage.

The same trace gives a safety property. It records every store, so a trace of a complete run
in which every `write` is inside a region says that no state on the run has a byte changed
outside the region; and where the machine is deterministic, every state the machine can reach
is on that run (`RunL.safe`, `sha256_main_safe`).

## Not covered

- **The cache, beyond addresses.** The model takes the attacker to see every address, which
  is stronger than any cache attack, but it says nothing of hardware that turns data into
  addresses on its own: a data-dependent prefetcher defeats code that is constant-time in
  this sense [12].
- **Speculation.** The labels are those of the instructions that run. A processor that
  speculates past a branch runs others. Stating that needs a contract between hardware and
  software, a labelled semantics with a speculative mode [13], or a speculative notion of
  constant time [14]. Labelled steps leave room for it; nothing here does it.
- **Power, radiation, frequency.** Constant-time code leaks through frequency scaling [15],
  and the vendors' lists exclude power and thermal channels explicitly [11].
- **The processor's mode.** The vendors' guarantees hold with `DIT` or `DOITM` set, or on a
  core that implements Zkt. A theorem here does not say the mode is set.

## Traces of labelled steps

The trace of a run is the list of its labels in order. Stating properties of a whole
execution over such a trace is how ConCert [16, 17] reasons about smart contracts: its
`ChainTrace` is the reflexive-transitive closure of a labelled step relation between chain
states, a state is reachable when there is a trace to it from the empty chain, and a safety
property is a statement about every reachable state, proved by induction over the trace.
The steps there include actions that are not the contract's own. The labels here have the
same two kinds: what the program's own step reveals, and an event of the environment (an
exit, bytes written out). A machine here is deterministic, so a trace is determined by the
state it starts from; the environment is where that will stop being so.

## Sources

Read for this page, with what could not be checked.

1. J. B. Almeida, M. Barbosa, G. Barthe, F. Dupressoir, M. Emmi. *Verifying Constant-Time
   Implementations.* USENIX Security 2016.
   <https://files.usenix.org/s3fs-public/cdn/sec16_paper_almeida.pdf>
2. J. B. Almeida, M. Barbosa, G. Barthe, A. Blot, B. Grégoire, V. Laporte, T. Oliveira,
   H. Pacheco, B. Schmidt, P.-Y. Strub. *Jasmin: High-Assurance and High-Speed Cryptography.*
   CCS 2017. <https://acmccs.github.io/papers/p1807-almeidaA.pdf>
3. J. B. Almeida, M. Barbosa, G. Barthe, B. Grégoire, A. Koutsos, V. Laporte, T. Oliveira,
   P.-Y. Strub. *The Last Mile: High-Assurance and High-Speed Cryptographic
   Implementations.* IEEE S&P 2020. <https://arxiv.org/pdf/1904.04606>
4. G. Barthe, B. Grégoire, V. Laporte, S. Priya. *Structured Leakage and Applications to
   Cryptographic Constant-Time and Cost.* CCS 2021.
   <https://members.loria.fr/VLaporte/files/CCS2021_StructuredLeakage.pdf>
5. G. Barthe, S. Blazy, B. Grégoire, R. Hutin, V. Laporte, D. Pichardie, A. Trieu. *Formal
   Verification of a Constant-Time Preserving C Compiler.* POPL 2020.
   <https://eprint.iacr.org/2019/926>. The full text could not be opened; what is said of it
   here is from the abstract and from a co-author's slides.
6. L.-A. Daniel, S. Bardin, T. Rezk. *Binsec/Rel: Efficient Relational Symbolic Execution
   for Constant-Time at Binary-Level.* IEEE S&P 2020. <https://arxiv.org/pdf/1912.08788>
7. B. Bond, C. Hawblitzel, M. Kapritsos, K. R. M. Leino, J. R. Lorch, B. Parno, A. Rane,
   S. Setty, L. Thompson. *Vale: Verifying High-Performance Cryptographic Assembly Code.*
   USENIX Security 2017.
   <https://www.usenix.org/system/files/conference/usenixsecurity17/sec17-bond.pdf>
8. J. Protzenko, B. Parno, A. Fromherz, C. Hawblitzel, M. Polubelova, K. Bhargavan, et al.
   *EverCrypt: A Fast, Verified, Cross-Platform Cryptographic Provider.* IEEE S&P 2020.
   <https://www.microsoft.com/en-us/research/uploads/prod/2019/10/evercrypt.pdf>
9. RISC-V ISA manual, scalar cryptography, *Zkt Extension for Data-Independent Execution
   Latency.* <https://github.com/riscv/riscv-isa-manual/blob/main/src/unpriv/zkt.adoc>. Read
   on the `main` branch, not in the ratified document.
10. Arm A-profile system registers, *DIT, Data Independent Timing.* Read in copies of Arm's
    register documentation, not on Arm's site; that division is excluded is from its absence
    from the list of the 2026-03 release.
11. Intel, *Data Operand Independent Timing ISA Guidance* and *Data Operand Independent
    Timing Instructions.*
    <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/best-practices/data-operand-independent-timing-isa-guidance.html>.
    Read through a summary of the pages, not the table itself.
12. B. Chen, Y. Wang, P. Shome, C. W. Fletcher, D. Kohlbrenner, R. Paccagnella, D. Genkin.
    *GoFetch: Breaking Constant-Time Cryptographic Implementations Using Data
    Memory-Dependent Prefetchers.* USENIX Security 2024. <https://gofetch.fail/>
13. M. Guarnieri, B. Köpf, J. Reineke, P. Vila. *Hardware-Software Contracts for Secure
    Speculation.* IEEE S&P 2021. <https://arxiv.org/pdf/2006.03841>
14. S. Cauligi, C. Disselkoen, K. v. Gleissenthall, D. Tullsen, D. Stefan, T. Rezk,
    G. Barthe. *Constant-Time Foundations for the New Spectre Era.* PLDI 2020.
    <https://arxiv.org/pdf/1910.01755>
15. Y. Wang, R. Paccagnella, E. T. He, H. Shacham, C. Fletcher, D. Kohlbrenner. *Hertzbleed:
    Turning Power Side-Channel Attacks Into Remote Timing Attacks on x86.* USENIX Security
    2022. <https://www.hertzbleed.com/>
16. J. B. Nielsen, B. Spitters. *Smart Contract Interactions in Coq.* FMBC 2019.
    <https://arxiv.org/pdf/1911.04732>
17. D. Annenkov, J. B. Nielsen, B. Spitters. *ConCert: A Smart Contract Certification
    Framework in Coq.* CPP 2020. <https://arxiv.org/pdf/1907.10674>. `ChainTrace`,
    `reachable` and `contract_induction` are in `execution/theories/` of
    <https://github.com/AU-COBRA/ConCert>.
18. Arm A64 instruction descriptions, *Operational information* of each instruction, 2026-03
    release. Read in a copy,
    <https://www.scs.stanford.edu/~zyedidia/arm64/sha256h_advsimd.html> and its siblings,
    not on Arm's site.
19. RISC-V ISA manual, vector cryptography, *Zvkt Vector Data-Independent Execution Latency.*
    <https://github.com/riscv/riscv-isa-manual/blob/main/src/unpriv/zvk.adoc>. Read on the
    `main` branch, not in the ratified document.
20. OpenSSL, `crypto/chacha/asm/chacha-x86_64.pl` and `chacha-armv8.pl`.
    <https://github.com/openssl/openssl/tree/master/crypto/chacha/asm>
21. T. Krovetz's vector implementation, as BoringSSL once carried it.
    <https://github.com/google/boringssl/blob/chromium-2214/crypto/chacha/chacha_vec.c>
22. libsodium, `crypto_stream/chacha20/dolbeau`.
    <https://github.com/jedisct1/libsodium/tree/master/src/libsodium/crypto_stream/chacha20/dolbeau>
23. Linux, `lib/crypto/arm64/chacha-neon-core.S` and
    `lib/crypto/x86/chacha-avx512vl-x86_64.S`. <https://github.com/torvalds/linux/tree/master/lib/crypto>
24. HACL*, `code/chacha20/Hacl.Impl.Chacha20.Core32xN.fst`.
    <https://github.com/hacl-star/hacl-star/tree/main/code/chacha20>
