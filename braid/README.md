# Braid: the dialect and the logic

This package is the library a proof imports. It holds the `braid` dialect, its semantics, and
the separation logic built on it. It does not depend on any instruction-set model: the
lowerings from RISC-V, AArch64 and x86-64 live in [`../Lowering`](../Lowering/README.md).

```
Braid/
  IR/
    Syntax.lean      operations, terminators, blocks, functions
    Semantics.lean   states, weakest preconditions, Eventually
    Exec.lean        the functional reading: a block as a function
    Mem.lean         loads and stores, byte by byte
    Print.lean       MLIR text, Lean terms, position-independent text
    Trace.lean       labelled steps: what an operation reveals, traces, labelled runs
  Pass/
    Fuse.lean        fuse a block with the block it jumps to
    DeadFlags.lean   remove flag writes a block overwrites before reading
    Dce.lean         remove operations whose results are never used
    Simplify.lean    the three together, for a function
    DceFast.lean     the dead-operation pass with live sets as bit masks, proved the same
    Plan.lean        the three by a plan of which blocks to fuse, proved for any plan
  Logic/
    Heap.lean        heaps: registers, flags, bytes, the program counter
    Assertion.lean   assertions, as an Iris BI
    Atom.lean        points-to atoms and symbolic states
    Local.lean       what each read and write does beside a frame
    Triple.lean      the triple and its structural rules
    Exec.lean        symbolic execution rules
    Data.lean        arrays, unknown registers, fold and unfold
    Sat.lean         between atoms and plain facts about a state
    Flat.lean        arrays written out as memory atoms, for theorems about a machine
    Cells.lean       arrays of cells of any size, read-only or writable; indexed access
    Trace.lean       traced triples: a triple with the trace before and after
    Tactic.lean      braid_step, braid_run, braid_call, ...
    Sym/             the stepper: braid_sym_step and braid_sym_run, symbolic execution as
                     a metaprogram, for code too long for braid_run (docs/Scaling.md)
BraidTest/           small hand-written programs that exercise the logic
```

To use it from another project:

```toml
[[require]]
name = "braid"
git = "https://github.com/dhsorens/braid"
subDir = "braid"
```

```lean
import Braid
```

## The dialect

`braid` is an [MLIR](https://mlir.llvm.org/) dialect for machine code. It is first-order and
small. A value is a 64-bit word. The machine state is not threaded through SSA values: it is
read and written by explicit operations, so that a block lowered from one instruction reads
like the instruction.

A **block** is a list of operations in SSA form and one terminator. A **program** maps
addresses to blocks: the block at an address is the instruction that was there. A **function**
is a named list of blocks, and prints as one MLIR region.

| Operation | Meaning |
| --- | --- |
| `const` | a 64-bit constant |
| `add` `sub` `mul` `and` `or` `xor` | word arithmetic, wrapping |
| `mulhu` `mulhs` `mulhsu` | the high word of the 128-bit product |
| `udiv` `urem` `sdiv` `srem` | division; a zero divisor gives zero (quotient) or the dividend (remainder) |
| `shl` `lshr` `ashr` `rotr` | shifts and rotation; a shift of 64 or more gives zero, or the sign |
| `eq` `ne` `ult` `ule` `slt` `sle` | comparisons, giving `1` or `0` |
| `lanes n op` | `op` on each lane of `n` bits of the two words, for vector code |
| `not` `neg` `clz` `popcnt` `rbit` `bswap` | one-operand operations |
| `sext` `zext` | sign- or zero-extend the low `bits` bits |
| `select` | one of two values, by a condition |
| `get` `set` | read and write a register |
| `getf` `setf` | read and write a one-bit flag |
| `load` `store` | read and write 1, 2, 4 or 8 bytes of memory, little-endian |
| `havoc` | any word at all: a value the instruction set leaves undefined |
| `guard` | execution is defined only if the operand is not zero |

| Terminator | Meaning |
| --- | --- |
| `br` | go to a block |
| `cond_br` | go to one of two blocks |
| `br_ind` | go to the address in a value: a return, or a computed jump or call |
| `trap` | execution is not defined here: an instruction outside the lowering, or a fault |

Every instruction set lowers into these. What differs between them is which registers and
flags exist, and those are only names: `Arch` maps the numbers of the dialect to `x10`, `sp`,
`rax`, `zf` and so on when a module is printed.

### Textual form

A module prints in MLIR's generic operation syntax, which `mlir-opt
--allow-unregistered-dialect` and other MLIR tools read. This is `gcd` from
`Examples/src/rust/basic.rs`, compiled for RISC-V, as far as the end of its second block:

```mlir
"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10010
      %bb0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.eq"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb0_2)[^bb14, ^bb4] : (i64) -> ()
    ^bb4:  // 0x10014
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb4_2 = "braid.urem"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      ...
```

The value operations are in the dialect `braid`. The terminators and the containers
(`func`, `module`) are in a second namespace, `braid_cf`. The split is there because
[`mlir/braid.irdl.mlir`](mlir/braid.irdl.mlir) defines the `braid` dialect in
[IRDL](https://mlir.llvm.org/docs/Dialects/IRDL/), and with it `mlir-opt` checks every value
operation of a lowered module, its operands, results and attributes, instead of only parsing
it:

```sh
mlir-opt --irdl-file=braid/mlir/braid.irdl.mlir --allow-unregistered-dialect f.mlir
```

IRDL cannot yet say that an operation is a terminator, so `braid_cf` stays unregistered.

[VeIR](https://github.com/opencompl/veir), the MLIR infrastructure in Lean, reads the same
text. Every module of the example corpus parses and prints through `veir-opt`, and `mlir-opt`
accepts what it prints. VeIR's verifier has to be off (`--disable-verifiers`), because it does
not know which unregistered operations end a block. `Examples/check-mlir.sh` runs both checks.

A block is labelled with its offset from the entry of its function, and an SSA value is named
after its block, so a change to one instruction changes the text of one block. A jump out of
the function goes to a block that holds a single `braid_cf.tail`.

`Module.toNorm` prints the same module with addresses made relative, for comparing two
lowerings ([`docs/Continuity.md`](../docs/Continuity.md)). `Func.toLean` prints a function as
a Lean term, which is what a proof imports.

## The semantics

The meaning of the dialect is given in higher-order logic, in Lean, as predicate transformers
(`Braid/IR/Semantics.lean`). For an operation `op`, an SSA environment `ρ`, a state `σ` and a
postcondition `Q`,

```lean
op.wp ρ σ Q : Prop
```

says that `op` runs from `ρ` and `σ` without fault and every outcome satisfies `Q`. A fault has
precondition `False`: an unmapped load, a store to a byte that is missing or not writable, a
failed `guard`, a `trap`. A `havoc` is a universal quantifier. The equations are short enough
to read in full:

```lean
| .get d r,     ρ, σ, Q => Q (ρ.set d (σ.regs r)) σ
| .load d w a,  ρ, σ, Q => ∃ v, σ.mem.load (ρ a) w = some v ∧ Q (ρ.set d v) σ
| .havoc d,     ρ, σ, Q => ∀ v, Q (ρ.set d v) σ
| .guard c,     ρ, σ, Q => ρ c ≠ 0#64 ∧ Q ρ σ
```

A state is the registers, the flags, memory and the program counter. Memory is a partial map
from addresses to bytes, each with a flag that says whether it may be written.

A program takes a step by running the block at the program counter. `Eventually P Q σ` is the
least predicate such that either `Q σ` holds, or a step from `σ` is defined and every outcome
is again in `Eventually P Q`. It says: every run of `P` from `σ` reaches `Q`, without fault.

### The functional reading

A block without `havoc` is a function. `Block.exec : Block → State → Option State` is that
function, and `Block.wp_iff_exec` says the predicate transformer and the function agree:

```lean
theorem Block.wp_iff_exec (hf : b.HavocFree) :
    b.wp σ Q ↔ ∃ σ', b.exec σ = some σ' ∧ Q σ'
```

`Program.run` iterates it, and `Program.eventually_of_run` says a run of the function is a run
of the program. This is the decompilation of code into logic at the level of blocks, in the
sense of Myreen, Gordon and Slind: the code is a function of the logic, with a theorem that
says so. It also runs, which is how `braid-difftest` checks the lowerings against the machine
models.

## The logic

The logic is a separation logic over the dialect. It is written once and holds for every
instruction set.

A **heap** holds the values of some locations: registers, flags, bytes of memory, the program
counter. An **assertion** (`SProp`) is a predicate on heaps. Assertions are an instance of
Iris's `BI` class ([iris-lean](https://github.com/leanprover-community/iris-lean)), so `∗`,
`-∗`, `∃`, `⌜φ⌝` and the Iris proof mode are available for entailments.

The points-to assertions are `regIs r v`, `flagIs f b`, `pcIs a` and `memIs a n v`, the last
for the low `n` bytes of `v` at `a`. A list of them is a symbolic state:

```lean
Atoms.interp [.pc 0x10010#64, .reg a0 a, .reg a1 b, .mem p 8 x true]
  = pcIs 0x10010 ∗ regIs a0 a ∗ regIs a1 b ∗ memIs p 8 x ∗ emp
```

The **triple** carries the frame rule inside it:

```lean
def Triple (P : Program) (pre post : SProp) : Prop :=
  ∀ R σ, (pre ∗ R) σ.heap → Eventually P (fun σ' => (post ∗ R) σ'.heap) σ
```

The program counter is part of the assertions. A specification of a function says where
execution starts and where it has got to: at the entry in the precondition, at the return
address in the postcondition.

```mermaid
flowchart LR
  T["Triple P pre post"] -->|Triple.sound| E["Eventually P ... σ"]
  E -->|lowering soundness| M["the machine runs to a state satisfying post"]
```

### Rules

| Rule | What it says |
| --- | --- |
| `Triple.frame` | a triple holds beside any assertion it does not mention |
| `Triple.seq` | triples compose |
| `Triple.conseq` | strengthen the precondition, weaken the postcondition |
| `Triple.step` | run the block at the program counter on the symbolic state |
| `Triple.call` | use a triple already proved: split off its precondition, put back its postcondition |
| `Triple.mono` | a triple about some blocks holds of a program with more blocks |
| `Triple.exists_pre`, `Triple.pure_pre` | quantifiers and pure facts in a precondition |
| `Triple.unfold`, `Triple.fold` | open an atom into atoms that mean the same, and close them |
| `OpsSpec.get`, `.set`, `.load`, `.store`, ... | one rule for each operation of the dialect |

Symbolic execution never decides whether two addresses are equal. A load finds the atom whose
address is syntactically the address it loads from, and the separating conjunction guarantees
that no other atom overlaps it.

### Tactics

| Tactic | Use |
| --- | --- |
| `braid_step` | run the block at the program counter |
| `braid_run` | run blocks until the program has none at the program counter, or a branch splits the goal |
| `braid_call h` | use the triple `h`, for a call or a loop invariant |
| `braid_unfold h`, `braid_fold h` | open or close an atom by an equation such as `wordsAt_cons` |
| `braid_forget r` | forget the value of register `r` |
| `braid_done` | finish: the symbolic state is the postcondition, in any order |
| `braid_norm` | put values and addresses in normal form |
| `braid_disj` | prove the atoms of a precondition pairwise disjoint |

A conditional branch leaves two goals, each with the condition as the hypothesis `hbr`.

### An example

Euclid's algorithm, written in Rust and compiled for RISC-V
(`Examples/RustBasic/RiscV/Proofs.lean`). The loop is proved by strong induction on the
divisor, the function by a call to the loop:

```lean
theorem gcd_loop (r : Word) (k : Nat) : ∀ a b t : Word, b.toNat = k → b ≠ 0#64 →
    Triple gcd.program
      (Atoms.interp [.pc 0x10014#64, .reg a0 a, .reg a1 b, .reg a2 t, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (wgcd a b), .reg a1 0#64, .reg a2 0#64,
        .reg ra r]) := by
  induction k using Nat.strongRecOn with
  | ind k ih =>
    intro a b t hk hb
    iterate 3 braid_step
    braid_step
    · -- the remainder is not zero: go round again
      simp only [hb, ↓reduceIte] at hbr ⊢
      refine (ih _ ?_ b (a % b) _ rfl hbr).cast rfl (by simp [wgcd_rec a b])
      rw [← hk, BitVec.toNat_umod]
      exact Nat.mod_lt _ (Nat.pos_of_ne_zero fun h => hb (BitVec.eq_of_toNat_eq h))
    · -- the remainder is zero: return
      simp only [hb, ↓reduceIte] at hbr ⊢
      braid_run
      exact Triple.done_eq (by simp [wgcd_rec a b, hbr, wgcd_zero])
```

`Lowering.RiscV.machine_sound` then turns the triple into a theorem about the RISC-V machine
with no `braid` notion left in its statement. The walkthrough is
[`docs/Walkthrough.md`](../docs/Walkthrough.md).

## What is not here yet

- Vector registers and SIMD operations. Values are 64-bit words.
- Types other than `i64`. A narrower value is a word whose high bits are zero or a sign.
- Environment calls. A system call lowers to `trap`.
- A parser for the textual form.
- Proofs on simplified code. `Braid/Pass/` has three passes, each proved to preserve what
  the runs of a program reach: fusing a block with the block it jumps to, `Block.dse`, which
  removes a flag write the block overwrites before reading, and `Block.dce`, which removes
  operations whose results are never used. `Func.simplifyBy` applies them to a function by
  a plan of which blocks to fuse, and is proved for any plan (`Func.simplifyBy_eventually`,
  in `Pass/Plan.lean`); `braid-lower --simplify` prints its result. The Lean modules the
  decompiler writes are not simplified: measured, a proof on simplified code is no faster
  ([`docs/Scaling.md`](../docs/Scaling.md)).
- Automatic extraction of a recursive Lean function from a loop. `Block.exec` is the
  function of a block; the function of a loop is still written by hand, as `wgcd` is above.
