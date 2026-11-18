# Related work

This document places Braid among existing work on verifying machine code, lifting binaries to
intermediate representations, and verified compiler IRs. It is for a reader who wants to judge
whether Braid's design is sound and which ideas it should borrow next.

Each entry says what the work is and how it relates to Braid. Citations were checked in November
2026. Projects that exist only as repositories are described from their own READMEs.

Braid in one paragraph, for reference. Binaries for RV64IM, AArch64 and x86-64 are lowered into
one MLIR-style dialect, `braid`: SSA word arithmetic plus explicit operations on machine state
(`get`/`set`, `getf`/`setf`, `load`/`store`, `havoc`, `guard`) and terminators (`br`, `cond_br`,
`br_ind`, `trap`), one block per instruction, keyed by address. Each operation denotes a
weakest-precondition transformer in Lean; runs are an inductive `Eventually` predicate. Each
lowering has a simulation theorem against an existing Lean ISA model. A separation logic with an
Iris BI instance sits above the dialect and is the same for all three instruction sets.

---

## 1. The landscape at a glance

| System | What it verifies or lifts | Logic or IR | Prover | Relation to Braid |
| --- | --- | --- | --- | --- |
| Decompilation into logic (§2.1) | ARM, x86, PowerPC machine code | Machine-code Hoare triples; output is a HOL function | HOL4 | Same aim (reason about a tractable model, not the bytes). Braid's planned extraction step is this; its lowering targets an IR first. |
| seL4 binary verification (§2.3) | gcc-compiled ARM binary against C semantics | Decompiled functions, a graph language, SMT | HOL4, Isabelle, SMT | Shows the approach scales to a kernel. Braid keeps all steps in one kernel and has no source program. |
| CakeML (§2.4) | Compiler output for five ISAs | 12 intermediate languages | HOL4 | Proof goes down from source; Braid's goes up from the binary. |
| Islaris (§3.1) | Armv8-A and RISC-V machine code | Iris logic over Isla traces | Coq + SMT | Closest program-logic design. Braid replaces SMT-generated traces with lowered blocks proved in-kernel. |
| Jensen-Benton-Kennedy (§3.2) | x86 machine code | Separation logic, frame connective, later modality | Coq | Source of Braid's triple shape: pc in assertions, frame built in. |
| Bedrock2 + riscv-coq (§3.3) | Compiler output on a RISC-V processor | WP-style program logic | Coq | Same semantics style (omni). Braid has no source language. |
| s2n-bignum (§3.4) | Object code of hand-written x86-64 and AArch64 routines | Hoare logic, plus a relational logic | HOL Light | Two ISAs, one logic, but two models and two proofs per routine. |
| Vale (§3.5) | x86 and ARM assembly | VC generation over an assembly AST | Dafny, F* | Verifies assembly text; Braid starts from bytes. |
| LNSym (§3.6) | AArch64 machine code | Symbolic simulation | Lean 4 | Same prover, one ISA, no shared IR. |
| Kraken, arm64-semantics, riscv-zkvm (§3.7) | ISA models and their own logics | Per-model Hoare or separation logics | Lean 4 | Braid's three trusted models. Braid adds one logic above all three. |
| Remill, RetDec, rev.ng (§4.1) | Many ISAs to LLVM IR | LLVM IR | none | Same pipeline shape, no proof, IR semantics not a logic. |
| BIL, VEX, P-Code, B2R2 (§4.2) | Many ISAs to an analysis IR | Purpose-built IRs | none (P-Code semantics on paper) | Closest IR designs. Braid's operation set is similar; its semantics is defined in Lean. |
| Hoare graphs, FoxDec (§4.3) | Stripped x86-64 ELF | Hoare graph, one triple per edge | Isabelle/HOL | Per-instruction proof obligations, as in Braid. One ISA, small instruction subset. |
| Validation of McSema (§4.4) | x86-64 to LLVM IR, per instruction | K semantics + SMT | K | Validates a lifter after the fact. Braid proves the lifter once. |
| MLIR, xDSL, CIRCT (§5.1) | n/a (compiler infrastructure) | Dialects of SSA operations | none | Braid's syntax and textual format. |
| Lean-MLIR, VeIR (§5.2) | Peephole rewrites, MLIR data structures, a RISC-V backend | SSA calculus; MLIR IR in Lean | Lean 4 | Same prover and format. Their `riscv` dialects are compiler targets, not machine models. |
| Vellvm, Alive2, CompCert (§5.3) | LLVM IR, C compilation | LLVM IR; RTL, Asm | Coq; SMT | Precedents for an IR with a mechanised semantics and proved passes. |
| Iris, iris-lean (§6.1) | n/a (logic framework) | BI logics, proof mode | Coq; Lean 4 | Braid's assertions are an instance. |
| Omnisemantics (§6.2) | n/a (semantics style) | Inductive WP over outcome sets | Coq | Braid's `Eventually`. |

---

## 2. Decompilation into logic and translation validation

The common pattern: run an untrusted tool, then prove a theorem that ties its output to the ISA
model, so the tool is not trusted.

### 2.1 Decompilation into logic (Myreen, Gordon, Slind)

- **What.** A proof-producing decompiler in HOL4. Given machine code, it returns a function in
  the logic and a certificate theorem relating that function to the code. Proofs are then done
  about the function. The FMCAD 2008 paper applies it to ARM, PowerPC and x86 models. A 2012
  revision by the same authors simplifies the method and makes it faster.
- **How it relates to Braid.** This is the model for Braid's planned extraction step: from
  lowered code to a Lean function plus certificate. The difference is where the common ground
  between ISAs sits. Myreen's decompiler is parametric in the ISA model and works on
  per-instruction Hoare triples derived from each model. Braid first lowers each ISA to one IR
  with one semantics, so extraction would be written once against `braid`, not once per model.

Links: [project page](https://www.cl.cam.ac.uk/~mom22/decompilation);
*Machine-Code Verification for Multiple Architectures: An Application of Decompilation into
Logic*, FMCAD 2008, [doi:10.1109/FMCAD.2008.ECP.24](https://doi.org/10.1109/FMCAD.2008.ECP.24);
*Decompilation into Logic, Improved*, FMCAD 2012,
[PDF](https://www.cs.utexas.edu/~hunt/FMCAD/FMCAD12/016.pdf).

### 2.2 Myreen's machine-code Hoare logic

- **What.** *Hoare Logic for Realistically Modelled Machine Code* (Myreen and Gordon, TACAS
  2007) is a mechanised Hoare-style logic in HOL4 for programs over realistic machine models.
  Assertions describe machine resources joined by a separating conjunction, the code is a
  separate component of the triple, and the program counter is an ordinary resource. Myreen's
  thesis is the long account.
- **How it relates to Braid.** `Triple P pre post` has the same parts: a program, and
  assertions that include the pc. Braid's definition quantifies over a frame, so the frame rule
  is a three-line lemma and not a property to prove per instruction. The relational-logic paper
  of §3.4 criticises this family of logics for lacking a conjunction rule; Braid's triples
  should be checked against the same criticism.

Links: [doi:10.1007/978-3-540-71209-1_44](https://doi.org/10.1007/978-3-540-71209-1_44);
thesis, [UCAM-CL-TR-765](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-765.html).

### 2.3 Translation validation for seL4 (Sewell, Myreen, Klein; PLDI 2013)

- **What.** Extends the seL4 functional-correctness proof from C to the ARM binary produced by
  gcc, so the compiler is not trusted. The binary is decompiled into HOL4 with Myreen's tool.
  The C semantics comes from Isabelle/HOL. Both are translated into a common graph language and
  refinement is discharged by SMT solvers.
- **How it relates to Braid.** It is the strongest evidence that decompilation scales to
  compiler output. Two lessons carry over. The decompiler had to treat the stack as a separate
  object to line binary functions up with C functions, which is the job of Braid's call and
  frame rules. Loops were the hard case: the reported failures at `-O2` come from finding
  matching loop points. Braid's loop rule takes a user invariant and so does not attempt that
  search. The trust story differs: seL4's validation uses three provers and SMT, and Braid's
  chain is one Lean development ending in a theorem about the ISA model.

Link: [PDF](https://www.cl.cam.ac.uk/~mom22/pldi13.pdf).

### 2.4 CakeML

- **What.** A verified implementation of ML in HOL4. The POPL 2014 paper (Kumar, Myreen,
  Norrish, Owens) gives a verified read-eval-print loop in x86-64 machine code. The compiler was
  bootstrapped inside the logic, and the garbage collector and bignum library were produced by
  proof-producing synthesis of machine code, citing *Extensible proof-producing compilation*
  (Myreen, Slind, Gordon; CC 2009). That method generates code without proof, decompiles it
  with proof, and proves the result equal to the source function. The later backend (Tan et
  al., JFP 2019) has 12 intermediate languages and targets x86-64, ARMv6, ARMv8, MIPS-64 and
  RISC-V.
- **How it relates to Braid.** CakeML shows decompilation used as a component of a compiler,
  and it shows one verified development serving several ISAs through a shared low-level
  language. The direction is opposite: CakeML proves that emitted code refines a source
  program, and Braid starts from code with no source.

Links: [POPL 2014 PDF](https://www.cl.cam.ac.uk/~mom22/popl14.pdf);
CC 2009, [doi:10.1007/978-3-642-00722-4_2](https://doi.org/10.1007/978-3-642-00722-4_2);
JFP 2019, [doi:10.1017/S0956796818000229](https://doi.org/10.1017/S0956796818000229).

---

## 3. Program logics for machine code over ISA models

### 3.1 Islaris, Isla and Sail

- **What.** Sail is a language for ISA specifications (Armstrong et al., POPL 2019). Its
  Armv8-A model is derived from Arm's own specification and its RISC-V model is the official
  one. Isla (Armstrong, Campbell, Simner, Pulte, Sewell; CAV 2021) is an SMT-based symbolic
  executor for Sail models. Islaris (Sammler et al., PLDI 2022) verifies machine code above
  those models: Isla reduces each instruction to a small trace under stated constraints, and an
  Iris separation logic in Coq reasons about the traces.
- **How it relates to Braid.** The architecture is the same in outline: reduce each instruction
  to a small first-order description, then run a separation logic over that. An Isla trace and
  a `braid` block play the same role. The differences are three.
  - Islaris traces come from an SMT-based tool. The paper validates them against the
    Sail-generated Coq model for RISC-V only. Braid's blocks come from a Lean function with a
    simulation theorem, so nothing outside the kernel is trusted for the lowering.
  - Islaris reasons over the full authoritative models. Braid's models are smaller Lean models
    that are tested against, or proved equivalent to, Sail on their supported subset (§3.7).
  - Islaris's trace language is internal. Braid's is an MLIR dialect that other tools can read.

Links: Islaris, [doi:10.1145/3519939.3523434](https://doi.org/10.1145/3519939.3523434);
Isla, [PDF](https://www.cl.cam.ac.uk/~pes20/isla/isla-cav2021.pdf);
Sail, [PDF](https://www.cl.cam.ac.uk/~pes20/sail/sail-popl2019.pdf).

### 3.2 High-level separation logic for low-level code

- **What.** Jensen, Benton and Kennedy (POPL 2013) give a separation logic for unstructured x86
  machine code in Coq. It is built on a specification logic with frame connectives and a later
  modality; triples for code are derived from a safety predicate, and the instruction pointer
  is a register in the assertion. Kennedy, Benton, Jensen and Dagand (PPDP 2013) build an x86
  macro assembler in Coq on top, with a correctness theorem linking the emitted bytes to
  separation-logic specifications.
- **How it relates to Braid.** Braid's triple is this style specialised to total correctness:
  `Triple P pre post` holds if, for every frame `R`, a state satisfying `pre * R` eventually
  reaches `post * R`. Because Braid uses a least fixed point and not a safety predicate, it has
  no later modality in its triples (the BI instance's `later` is the identity). The cost is that
  Braid's triples say nothing about code that does not terminate, which a safety-based logic
  can describe. The macro assembler is the reverse direction of
  Braid's lowering and a model for how higher-order specifications of code blocks compose.

Links: [POPL 2013 PDF](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/12/hlsl.pdf);
[PPDP 2013](https://www.microsoft.com/en-us/research/publication/coq-worlds-best-macro-assembler/).

### 3.3 Bedrock, Bedrock2 and riscv-coq

- **What.** Bedrock (Chlipala, PLDI 2011; ICFP 2013) is a Coq framework for mostly automated
  separation-logic proofs about low-level programs, including first-class code pointers.
  Bedrock2 is its successor: a small C-like language with a program logic and a verified
  compiler to RISC-V. Erbsen, Gruetter, Choi, Wood and Chlipala (PLDI 2021) use it to verify an
  embedded system from application software to a RISC-V processor as one Coq theorem.
  riscv-coq is the RISC-V specification underneath, generated from a Haskell specification
  with hs-to-coq.
- **How it relates to Braid.** Bedrock2 is the best-developed program logic whose end theorem
  is about a RISC-V machine, and its authors introduced the semantics style Braid uses (§6.2).
  It verifies source and compiles down. Braid has no source language and gives the same kind of
  end-to-end statement directly for a binary.

Links: [Bedrock, PLDI 2011](https://adam.chlipala.net/papers/BedrockPLDI11/);
[Bedrock, ICFP 2013](https://adam.chlipala.net/papers/BedrockICFP13/);
[PLDI 2021](https://adam.chlipala.net/papers/LightbulbPLDI21/);
[bedrock2](https://github.com/mit-plv/bedrock2); [riscv-coq](https://github.com/mit-plv/riscv-coq).

### 3.4 s2n-bignum and its relational logic

- **What.** A library of big-integer routines written by hand in x86-64 and AArch64 machine
  code, each with a HOL Light proof that the object file from the build meets a mathematical
  specification. The proofs assume a formal model of each processor. Mazzucato et al. (CAV
  2025) add a relational Hoare logic in HOL Light and use it to prove constant-time properties
  and the equivalence of optimised and reference routines.
- **How it relates to Braid.** s2n-bignum is the industrial benchmark for the two ISAs it
  covers, and it verifies bytes, as Braid does. Its two architectures share a logic but not a
  program representation: each routine is proved twice, against two models. Braid's bet is
  that a shared IR lets tactics, rules and library lemmas be written once. Braid has no
  relational logic and no leakage model. If constant time comes into scope, the dialect would
  need an observation for leaked values, and this paper is the design to follow.

Links: [repository](https://github.com/awslabs/s2n-bignum);
relational logic, [arXiv:2505.14348](https://arxiv.org/abs/2505.14348).

### 3.5 Vale

- **What.** A language and tool for verified high-performance cryptographic assembly (Bond et
  al., USENIX Security 2017), first on Dafny. Fromherz et al. (POPL 2019) embed a subset of x64
  assembly in F* with a verified verification-condition generator.
- **How it relates to Braid.** Vale verifies an assembly-level program that is then printed
  for an external assembler, so the object verified is not the bytes. Braid's lowerings start
  from decoded instructions at addresses. Vale's verified VC generator is a precedent
  for making Braid's symbolic execution a verified function instead of a tactic loop.

Links: [USENIX Security 2017](https://www.usenix.org/conference/usenixsecurity17/technical-sessions/presentation/bond);
[POPL 2019 PDF](https://www.microsoft.com/en-us/research/uploads/prod/2018/12/popl19-vale.pdf).

### 3.6 LNSym

A symbolic simulator for Armv8 AArch64 machine code in Lean 4, with its own formalisation of
the ISA and conformance tests that run on an AArch64 host
([repository](https://github.com/leanprover/LNSym)). It has the same prover and goal as Braid,
for one ISA, and simulates the ISA model directly. Braid's symbolic execution never unfolds an
ISA model: that happens once, in the lowering's soundness proof.

### 3.7 The three Lean ISA models Braid lowers from

- **riscv-zkvm** (Verified-zkEVM). Contains a Lean extraction of the official Sail RISC-V
  specification, a separate hand-written computable RV64IM model (`RiscvZkvm.Rv64`), and
  per-instruction theorems plus step and run simulations tying the two. Braid's RISC-V lowering
  is proved against `RiscvZkvm.Rv64`, so its end theorems reach Sail through that tie. The
  generated Sail model comes from Sail's Lean backend; the standalone
  [sail-riscv-lean](https://github.com/opencompl/sail-riscv-lean) describes that backend as
  work in progress. [Repository](https://github.com/Verified-zkEVM/riscv-zkvm).
- **arm64-semantics** (Google DeepMind, in `code-verification`). An AArch64 semantics in Lean
  written from Arm's machine-readable specification. Its README reports differential testing
  against Unicorn, the Sail Armv9.4-A model and LLVM. It has a trusted layer (decoding,
  per-instruction evaluation, ELF loading) and an untrusted proof library with its own
  separation logic. Braid uses the trusted layer only.
  [Repository](https://github.com/google-deepmind/code-verification).
- **Kraken** (Lean FRO, Google, INRIA). A Lean framework for verifying assembly programs, with
  a hand-written x64 model that is a subset of the ISA (64-bit mode, flags, memory; no faults,
  virtual memory or segments). Its README states that it works one level above binary code,
  with no concrete instruction sizes or addresses. Braid's x86-64 lowering therefore inherits
  an assembler-level trust gap that its other two lowerings do not have.
  [Repository](https://github.com/AeneasVerif/kraken).
- **How these relate to Braid.** Each model ships its own proof machinery. Braid does not
  replace the models. It adds a layer where one set of rules serves all three, and each
  lowering's simulation theorem transfers results back: if the lowered code reaches a
  postcondition, the machine does. A proof done in Braid ends as a statement about the ISA
  model alone, so the dialect and its semantics are not in the trusted base.

---

## 4. Binary lifting to compiler IRs

Lifters translate machine code into an IR for analysis, decompilation or recompilation. Almost
all are unverified, and their IRs have no mechanised semantics. Braid is a lifter whose IR has a
semantics that is a logic, and whose translation is proved.

### 4.1 Lifters to LLVM IR

- **Remill, McSema, Anvill** (Trail of Bits). Remill is a library that lifts x86, amd64,
  AArch64 and SPARC machine code to LLVM bitcode. McSema lifts whole binaries using Remill.
  Anvill builds on Remill to produce bitcode suited to decompilation.
  [remill](https://github.com/lifting-bits/remill),
  [mcsema](https://github.com/lifting-bits/mcsema),
  [anvill](https://github.com/lifting-bits/anvill).
- **RetDec** (Avast). A retargetable decompiler built on LLVM: one component translates
  binaries to LLVM IR and another turns LLVM IR into C-like source.
  [Repository](https://github.com/avast/retdec).
- **rev.ng** (Di Federico, Payer, Agosta; CC 2017). Lifts through QEMU's intermediate form to
  compilable LLVM IR, which gives it every architecture QEMU supports, and adds analyses to
  recover control-flow graphs and function boundaries.
  [PDF](https://www.nebelwelt.net/files/17CC.pdf).
- **How these relate to Braid.** The shape is the same: many ISAs, one IR, one set of tools
  above. LLVM IR is the wrong target for Braid's purpose. Its semantics involves poison,
  undefined behaviour and an abstract memory model, which a lifter must avoid or encode, and
  machine state has to be modelled as globals or a state struct by convention. `braid` makes
  machine state the only state, has no undefined behaviour beyond `havoc` and `guard`, and is
  small enough for a complete semantics in about 300 lines of Lean. What these tools do well,
  and Braid does not attempt, is recovery of function boundaries, indirect-jump targets, stack
  variables and types. Their output can serve as untrusted hints that a Braid proof checks.

### 4.2 Analysis IRs

- **BAP and BIL** (Brumley, Jager, Avgerinos, Schwartz; CAV 2011). BAP lifts to an intermediate
  language in which every side effect of an instruction is explicit, to allow syntax-directed
  analysis and verification-condition generation.
  [doi:10.1007/978-3-642-22110-1_37](https://doi.org/10.1007/978-3-642-22110-1_37).
- **VEX and angr.** VEX is the architecture-neutral IR of Valgrind (Nethercote and Seward, PLDI
  2007). angr (Shoshitaishvili et al., IEEE S&P 2016) is a binary-analysis framework that lifts
  through VEX. [Valgrind](https://doi.org/10.1145/1273442.1250746),
  [angr](https://sites.cs.ucsb.edu/~vigna/publications/2016_SP_angrSoK.pdf).
- **Ghidra P-Code.** A register transfer language; each processor is described in SLEIGH,
  which maps instructions to P-Code.
  [Reference manual](https://ghidra.re/ghidra_docs/languages/html/pcoderef.html).
- **B2R2** (Jung, Kim, Han, Choi, Cha; BAR 2019). A binary-analysis front end in F# with its
  own IR, designed for fast and parallel lifting.
  [PDF](https://softsec.kaist.ac.kr/~sangkilc/papers/jung-bar19.pdf).
- **How these relate to Braid.** These are the nearest relatives of the dialect itself. BIL's
  principle, explicit side effects, is exactly `get`/`set`/`getf`/`setf`/`load`/`store`. One
  machine instruction becomes several IR statements in all of them, as in Braid. The
  differences are that `braid` is SSA within a block, is printed in a format an existing
  compiler framework parses, and has a semantics defined in a proof assistant. The P-Code case
  shows why the last point matters: Naus, Verbeek, Walker and Ravindran (*A Formal Semantics
  for P-Code*, VSTTE 2022) had to extend P-Code to give it an executable semantics and found
  problems in Ghidra and its documentation while doing so.
  [doi:10.1007/978-3-031-25803-9_7](https://doi.org/10.1007/978-3-031-25803-9_7).

### 4.3 Verified lifting: Hoare graphs and FoxDec

- **What.** Verbeek, Bockenek, Fu and Ravindran (PLDI 2022) lift stripped x86-64 binaries to
  Hoare graphs: vertices carry predicates over registers, flags and memory, and edges are
  instructions. An unverified tool builds the graph. Each edge is then exported as an
  independent Hoare triple and proved in Isabelle/HOL. The lifting also establishes sanity
  properties such as return-address integrity. FoxDec is the group's tool that continues this
  work.
- **How it relates to Braid.** This is the closest verified-lifting work. Both produce one
  obligation per instruction against a formal semantics. Three differences:
  - The Hoare-graph proofs are generated per binary. Braid's lowering is proved once per ISA,
    for all code, as a theorem about the lowering function.
  - A Hoare graph includes inferred invariants and a recovered control-flow graph. Braid's
    lowering infers nothing: `br_ind` stays an indirect jump, and control-flow facts are proved
    later in the logic.
  - The PLDI 2022 Isabelle proofs covered a limited x86-64 instruction subset, which bounded
    what could be checked. Braid depends on the coverage of its three models in the same way.

Links: [doi:10.1145/3519939.3523702](https://doi.org/10.1145/3519939.3523702);
[FoxDec](https://github.com/ssrg-vt/FoxDec).

### 4.4 Validated lifting: K semantics of x86-64 and McSema

- **What.** Dasgupta, Park, Kasampalis, Adve and Roşu (PLDI 2019) give an executable K
  semantics of the user-level x86-64 Haswell instruction set: 3155 instruction variants over
  774 mnemonics, tested on more than 7,000 instruction-level tests and the GCC torture suite.
  Dasgupta, Dinesh, Venkatesh, Adve and Fletcher (PLDI 2020, *Scalable Validation of Binary
  Lifters*) use it to validate McSema's translation of single instructions to LLVM IR, and
  then check whole functions by composing validated instruction translations and comparing the
  result with McSema's output structurally. The work reports previously unknown bugs in
  McSema.
- **How it relates to Braid.** It supports two of Braid's choices. Per-instruction granularity
  is the right unit: a lifter that maps each instruction independently can be validated, or
  proved, instruction by instruction, and whole-program soundness follows by composition.
  Braid's `lowerCode_sound` is that composition as an induction over `Eventually`. And
  unverified lifters do contain semantic bugs, so the proof is not a formality. The K semantics
  is also a coverage yardstick for the x86-64 lowering.

Links: K x86-64, [doi:10.1145/3314221.3314601](https://doi.org/10.1145/3314221.3314601);
validation, [PLDI 2020 page](https://pldi20.sigplan.org/details/pldi-2020-papers/4/Scalable-Validation-of-Binary-Lifters).

---

## 5. MLIR and verified compiler IRs

### 5.1 MLIR, xDSL and CIRCT

- **MLIR** (Lattner et al., CGO 2021). A compiler infrastructure in which IRs are *dialects*:
  sets of operations over SSA values, grouped into blocks and regions, with a generic textual
  syntax that any dialect can be printed in.
  [doi:10.1109/CGO51591.2021.9370308](https://doi.org/10.1109/CGO51591.2021.9370308).
- **xDSL** (Fehr et al., CGO 2025). A Python framework that shares MLIR's core concepts and
  exchanges IR with MLIR through the textual format. The paper calls this arrangement
  sidekick compilation.
  [doi:10.1145/3696443.3708945](https://doi.org/10.1145/3696443.3708945).
- **CIRCT.** An LLVM project that applies MLIR to hardware design, with dialects such as `hw`,
  `comb` and `seq`. [Project site](https://circt.llvm.org/).
- **How these relate to Braid.** Braid uses MLIR's structure and textual format, not its C++
  implementation. A `braid` module prints as `braid_cf.func` operations holding one region, with
  one block per instruction, and `mlir-opt --allow-unregistered-dialect` accepts it. In xDSL's
  terms Braid is a sidekick whose side of the exchange has a formal semantics. CIRCT is the
  precedent for a dialect family whose subject is not a software language. One mismatch to
  keep in view: MLIR blocks name their successors, and `braid.br_ind` cannot, so a function
  with indirect jumps is not a complete control-flow graph in MLIR's sense.

### 5.2 Lean-MLIR and VeIR

- **Lean-MLIR** (Bhat, Keizer, Hughes, Goens, Grosser; ITP 2024, *Verifying Peephole Rewriting
  In SSA Compiler IRs*). A mechanised SSA calculus in Lean with an embedding of MLIR syntax,
  correctness theorems for peephole rewriting, and verified dead-code and common-subexpression
  elimination. [doi:10.4230/LIPIcs.ITP.2024.9](https://doi.org/10.4230/LIPIcs.ITP.2024.9).
  A EuroLLVM 2026 talk from the same group (Kuhn, Cicolini, Keizer, Yasar, Grosser) verifies
  LLVM instruction-selection patterns for RISC-V in Lean-MLIR with `bv_decide`, taking the
  instruction semantics from the Sail model through Sail's Lean backend.
  [Slides](https://www.llvm.org/devmtg/2026-04/slides/technical_talk/technical_talk_cicolini_kuhn.pdf).
- **VeIR** ([opencompl/veir](https://github.com/opencompl/veir)). A compiler infrastructure in
  Lean with MLIR's imperative design: blocks, operations and regions as mutable data
  structures, dialect definitions, a pass infrastructure, a peephole rewriter and an
  interpreter framework. Its README marks the core data structures as verified and says VeIR
  connects with MLIR through the textual format.
- **VeIR's `riscv` dialects.** In the clone examined (commit `b4610193`, November 2026) these
  are instruction-selection targets:
  - `riscv` has one operation per instruction or pseudo-instruction (`riscv.addi`,
    `riscv.li`, ...). Operands and
    results are SSA values of type `!riscv.reg`. A value is the content of a register that has
    not been assigned yet; there is no register file, pc or flag state.
  - `riscv_cf` holds structured functions, calls and branches with block successors.
    `riscv_stack` has one operation, `alloca`, whose frame offset is left to the backend.
    `gmir_riscv` mirrors LLVM's generic `RISCV::G_*` operations. `rv64.get_register` names a
    physical register.
  - The dialects are produced by instruction selection from VeIR's LLVM dialect, and rewrites
    over them (`RISCVCombines`) are proved with `bv_decide`. The README says `llc` then allocates
    registers and prints assembly.
- **How these relate to Braid.** VeIR's `riscv` describes code a compiler is about to emit:
  pure functions on register values. Braid describes code that already exists at addresses in
  a machine: its operations read and write the register file, flags, memory and pc. The two
  are complementary, and neither subsumes the other. There is no RISC-V machine model in VeIR
  for Braid to lower from, and Braid has no instruction selection.
- **Interoperation.** The shared ground is the MLIR textual format and Lean.
  - *Syntactic.* Braid already prints MLIR's generic operation syntax. For VeIR to read it,
    `braid` would be declared as a VeIR dialect (an opcode type, its properties and a local
    verifier, as VeIR's existing dialects do). Braid's printer puts `reg`, `value` and
    `sym_name` in attribute dictionaries. VeIR's own tests print such data as properties
    (`<{...}>`), so the two printers would need to agree.
  - *Semantic.* With the dialect declared, VeIR's pass and rewriter infrastructure could host
    Braid's planned passes (block fusion, dead-code elimination). Their correctness would
    still be stated against Braid's weakest-precondition semantics. VeIR's interpreter models
    poison and undefined behaviour for LLVM-style dialects, and Braid has only `havoc` and
    `guard`, so a `braid` instance of that interpreter would be simple.
  - *Practical.* The two projects pin different Lean toolchains (VeIR `v4.35.0-rc4`, Braid
    `v4.36.0` at the time of writing), so a shared build needs alignment.

### 5.3 Vellvm, Alive2 and CompCert

- **Vellvm** (Zhao, Nagarakatte, Martin, Zdancewic; POPL 2012). A Coq formalisation of LLVM IR,
  its type system and SSA properties, used to verify transformations. A later redesign
  (Zakowski et al., ICFP 2021) gives a modular, executable semantics built on interaction
  trees. [POPL 2012](https://doi.org/10.1145/2103656.2103709),
  [ICFP 2021](https://doi.org/10.1145/3473572).
- **Alive2** (Lopes, Lee, Hur, Liu, Regehr; PLDI 2021). Bounded translation validation for
  LLVM IR with an SMT solver. Run over LLVM's unit tests it found 47 new bugs.
  [doi:10.1145/3453483.3454030](https://doi.org/10.1145/3453483.3454030).
- **CompCert** (Leroy, CACM 2009). A verified C compiler in Coq whose proof passes through
  eight intermediate languages, including the register-transfer language RTL, down to an
  assembly language. [PDF](https://xavierleroy.org/publi/compcert-CACM.pdf).
- **How these relate to Braid.** They establish that an IR with a mechanised semantics can
  carry proved transformations (Vellvm, CompCert) or validated ones (Alive2). `braid` sits
  roughly where CompCert's lowest languages do: explicit machine registers and memory. Most of
  the difficulty in Vellvm and Alive2 comes from LLVM's undefined behaviour and memory model,
  which `braid` avoids by design. For Braid's planned passes the correctness statement is
  simple to write: a pass is sound if `Eventually` for the output program implies `Eventually`
  for the input program, the same shape as the lowering theorems.

---

## 6. Separation logic frameworks and semantics styles

### 6.1 Iris and iris-lean

- **What.** Iris is a framework for higher-order concurrent separation logic in Coq (Jung,
  Krebbers, Jourdan, Bizjak, Birkedal, Dreyer; JFP 2018). Its interactive proof mode (Krebbers,
  Timany, Birkedal; POPL 2017) was generalised as MoSeL (Krebbers et al., ICFP 2018) to any
  logic that satisfies an interface of bunched-implication laws, affine or linear.
  [iris-lean](https://github.com/leanprover-community/iris-lean) is the Lean 4 port: the MoSeL
  proof interface, the standard model, HeapLang and a selection of resources. Its
  documentation covers using the proof mode with separation logics other than Iris.
- **How it relates to Braid.** Braid takes the smallest useful piece. Its assertions are
  predicates on heaps of registers, flags, memory bytes and the pc, and they are given a `BI`
  instance, so entailments are proved with the Iris proof mode. Braid does not use Iris's
  model: no step-indexing, no ghost state, no invariants, no weakest-precondition connective
  from Iris. This is a deliberate fit to sequential, terminating machine code. If Braid
  later needs invariants or concurrency, the route is to replace the heap-predicate model with
  Iris's and re-derive the triple, as Islaris did from the start.

Links: Iris, [doi:10.1017/S0956796818000151](https://doi.org/10.1017/S0956796818000151);
proof mode, [doi:10.1145/3009837.3009855](https://doi.org/10.1145/3009837.3009855);
MoSeL, [doi:10.1145/3236772](https://doi.org/10.1145/3236772).

### 6.2 Omnisemantics

- **What.** Charguéraud, Chlipala, Erbsen and Gruetter (TOPLAS 2023) present a style of
  semantics that relates a starting state to a set of outcomes. One derivation covers every
  nondeterministic execution, safety is built in, and the judgement is an inductively defined
  weakest precondition. The results are formalised in Coq.
- **How it relates to Braid.** Braid's semantics is this style. `Op.wp` maps a postcondition
  to a precondition, `havoc` is a universal quantifier, a fault is `False`, and `Eventually` is
  the inductive closure over blocks. Three consequences follow, all used in Braid.
  - Undefined values need no separate treatment: a flag an instruction leaves undefined is a
    `havoc` followed by a `setf`.
  - The simulation theorems are short inductions over `Eventually`: from a fact about every
    run of the lowered code to a concrete run of the deterministic machine.
  - Being inductive, `Eventually` gives total correctness only. Non-terminating programs
    (servers, event loops) are outside the current semantics.

Link: [doi:10.1145/3579834](https://doi.org/10.1145/3579834).

### 6.3 VST, RefinedC and Lithium

- **VST.** The Verified Software Toolchain proves C programs correct in Coq with Verifiable C,
  a higher-order separation Hoare logic proved sound against CompCert's Clight semantics.
  VST-Floyd (Cao, Beringer, Gruetter, Dodds, Appel; JAR 2018) is its semi-automatic tactic
  library. [doi:10.1007/s10817-018-9457-5](https://doi.org/10.1007/s10817-018-9457-5).
- **RefinedC and Lithium** (Sammler, Lepigre, Krebbers, Memarian, Dreyer, Garg; PLDI 2021). A
  type system with refinement and ownership types for C, justified semantically in Iris. Its
  rules are encoded in Lithium, a fragment of separation logic chosen so that proof search is
  automatic. [doi:10.1145/3453483.3454036](https://doi.org/10.1145/3453483.3454036).
- **How these relate to Braid.** Both are answers to the automation problem Braid also has:
  keep a symbolic state in a canonical form and make each step deterministic. VST-Floyd keeps
  preconditions in a fixed shape of pure facts, local variables and spatial conjuncts. Braid's
  list of points-to atoms is the same idea for a machine state, and is simpler because
  registers and flags never alias. Lithium is the model for a next step: a goal language in
  which symbolic execution, atom lookup and frame inference need no backtracking, so that the
  `braid_step` tactics become a predictable procedure.

### 6.4 Lean's `mvcgen` and `Std.Do`

- **What.** Lean's standard library includes a framework for verifying monadic programs.
  Monadic code is given a predicate-transformer semantics, Hoare triples are defined through
  weakest preconditions, and the `mvcgen` tactic turns a goal into verification conditions
  using specification lemmas and user-supplied loop invariants. Kraken's README says it is
  being connected to `mvcgen`.
- **How it relates to Braid.** `mvcgen` targets programs written in a monad, and its
  assertions are predicates on the monad's state, without a separating conjunction. `braid`
  programs are data (lists of operations), and Braid's rules need framing. So Braid has its own
  tactics. The planned extraction step would produce ordinary Lean functions; if those are
  monadic, `mvcgen` is the natural tool for the proofs about them, which would put Braid's
  separation logic below the extracted function and `Std.Do` above it.

Link: [Lean reference, the `mvcgen` tactic](https://lean-lang.org/doc/reference/4.33.1/The--mvcgen--tactic/Overview/).

---

## 7. What Braid takes, and what appears to be new

### What Braid takes

| From | Braid takes |
| --- | --- |
| Myreen, Gordon, Slind | A tractable model with a certificate back to the machine; the planned extraction of Lean functions. |
| Myreen's logic; Jensen, Benton, Kennedy | Triples over unstructured code, pc inside the assertions, frame rule built into the definition. |
| Islaris; Hoare graphs; Dasgupta et al. | One small first-order description and one proof obligation per instruction; soundness by composition. |
| BIL, VEX, P-Code; MLIR, xDSL | Explicit side effects as the operation set; dialect structure, SSA and the generic textual format. |
| Lean-MLIR, VeIR, CompCert, Vellvm | An IR with a mechanised semantics as the place to prove passes. |
| Iris, MoSeL, iris-lean | The BI interface and the proof mode for entailments. |
| Omnisemantics | Weakest preconditions over outcome sets; `havoc` as a quantifier; an inductive `Eventually`. |
| VST-Floyd, Lithium | A canonical symbolic state so that execution steps need no search. |
| riscv-zkvm, arm64-semantics, Kraken | The trusted ISA models, used unmodified. |

### What appears to be new

Each ingredient has a precedent above; no work found in this review combines all four.

1. **One IR, with a semantics that is a logic, shared by three ISAs.** Multi-ISA lifters share
   an IR without a mechanised semantics (§4.1, §4.2). Multi-ISA verification efforts share a
   logic but keep one model and one proof per ISA (§2.1, §3.4), or share intermediate languages
   in the compile-down direction (§2.4). Islaris has two ISAs through one trace language, with
   trace generation outside the prover.
2. **Lowerings proved once, as theorems.** Each lowering has a simulation theorem for all code,
   in the same kernel as the proofs that use it. Verified lifting elsewhere is per binary
   (§4.3) or by validation (§4.4).
3. **An MLIR dialect whose subject is a running machine.** Existing verified MLIR work treats
   ISA-named dialects as compiler targets (§5.2). `braid` uses the same format to describe
   machine state transitions, which makes lifted binaries readable by MLIR tooling.
4. **A single separation logic above the dialect, independent of the ISA,** with an Iris BI
   instance and end theorems that mention only the ISA model.

### Limits to state alongside

- The trusted base is the three ISA models and how well they match hardware. Their coverage
  and validation differ (§3.7), and the x86-64 model works above the byte level.
- Total correctness only; sequential code only; no system-level features; no leakage model.
- Control-flow recovery, loop invariants and function boundaries are left to the user or to
  untrusted hints. The lifters of §4 do this automatically, without proof.
- The extraction step, verified passes and VeIR compatibility are planned, not done.
