/-
  Examples.ChaCha20.O2.X86.LeakRound

  What the loop of rounds of `chacha20_block` reveals on x86-64, compiled at `-O2`
  (`docs/Leakage.md`). The compiler keeps fifteen words of the state in registers and one in
  a slot of the stack, with one more slot to spill a word and one for the count of rounds, so
  a round reveals the addresses of those three slots, in the order in which it reads and
  writes them, and then where the branch at its end goes. The slots are at fixed offsets from
  the stack pointer, and the branch tests a count that the code set to ten and decrements in
  its slot, so none of this depends on the state: the rest of a round is additions, exclusive
  ors and rotations on registers, which have no label.

  At `-O1` three words of the state were in slots and the count of rounds in `edx`, so the
  two halves of a round reveal other addresses here, and `colsLeak` and `diagsLeak` are new,
  with the statements of the four traced triples. The proofs are those of
  `Examples.ChaCha20.X86.LeakRound`, with the counts of instructions and the registers
  changed.

  The traced triples here say nothing of what the rounds compute, which is `rounds_spec` of
  `Examples.ChaCha20.O2.X86.Round`: the registers and the slot of the state hold any words
  before and some words after, so the code is run on sixteen opaque words and the arithmetic
  is forgotten.

  ## Main definitions

  * `colsLeak`, `diagsLeak`: what each half of a round reveals, from the stack pointer
  * `roundsLeak`: what the loop reveals, from the stack pointer, by recursion on the rounds
    left after this one

  ## Main results

  * `columns_trace`, `diagonals_trace`, `double_round_trace`: a round, up to its branch
  * `rounds_trace`: the loop, with `n + 1` rounds left, reveals `roundsLeak q n`
-/

module

public import Examples.ChaCha20.O2.X86.Round
public import Braid.Logic.Any

@[expose] public section

namespace Examples.ChaCha20.O2.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- Addition as the stepper writes it when it evaluates an `add`: all three types `Word`.
The stepper finds memory atoms by syntactic equality of addresses. -/
local notation:65 a:65 " +ʷ " b:66 => @HAdd.hAdd Word Word Word instHAdd a b

/-! ## What is revealed -/

/-- What the first half of a round reveals, with the stack pointer at `q`: the store that
spills a word of the state, and the load of the word of the state that is in a slot. -/
def colsLeak (q : Word) : Trace :=
  [.write (q - 28#64) 4, .read (q - 24#64) 4]

/-- What the second half of a round reveals, with the stack pointer at `q`: the load of the
word that was spilled and the store of the word of the state that is in a slot, and the load
and the store of the count of rounds, which the code decrements in its slot. -/
def diagsLeak (q : Word) : Trace :=
  [.write (q - 24#64) 4, .read (q - 28#64) 4, .read (q - 20#64) 4, .write (q - 20#64) 4]

/-- What the loop of rounds reveals with the stack pointer at `q` and `n` rounds left after
the one it is in: for each round, the addresses of the slots it uses and where its branch
goes, which is back to the head of the loop after each round but the last, and on after the
last. It is a function of the stack pointer and the number of rounds, which is ten. -/
def roundsLeak (q : Word) : Nat → Trace
  | 0 => colsLeak q ++ (diagsLeak q ++ [.jump 0x4011e4#64])
  | n + 1 => colsLeak q ++ (diagsLeak q ++ .jump 0x4010a0#64 :: roundsLeak q n)

/-! ## Tactics -/

/-- Forget the values of the status flags that have one. -/
local macro "forget_flags" : tactic =>
  `(tactic| (try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 3
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-- Forget the fifteen registers of the state. -/
local macro "forget_regs" : tactic =>
  `(tactic| (braid_forget 10; braid_forget 5; braid_forget 9; braid_forget 13
             braid_forget 12; braid_forget 15; braid_forget 14; braid_forget 7
             braid_forget 1; braid_forget 11; braid_forget 4; braid_forget 8
             braid_forget 3; braid_forget 2; braid_forget 0))

/-- Name what the fifteen registers of the state hold. -/
local macro "name_regs" : tactic =>
  `(tactic| (braid_name_reg 10; braid_name_reg 5; braid_name_reg 9; braid_name_reg 13
             braid_name_reg 12; braid_name_reg 15; braid_name_reg 14; braid_name_reg 7
             braid_name_reg 1; braid_name_reg 11; braid_name_reg 4; braid_name_reg 8
             braid_name_reg 3; braid_name_reg 2; braid_name_reg 0))

/-- The symbolic state is the `n` atoms of the postcondition in another order:
`braid_done_perm`, for a traced triple. It leaves the equation between the traces. -/
local macro "done_perm " n:num : tactic =>
  `(tactic| (braid_norm
             refine TripleT.done_split ?_ ?_
             · iterate $n (apply Atoms.Split.cons; · braid_extract)
               exact Atoms.Split.nil))

/-! ## A round of the loop -/

/-- The first half of a round of the loop reveals `colsLeak` of the stack pointer, whatever
the registers and the slot of the state hold. -/
theorem columns_trace (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word)
    (q u1c : Word) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp [.pc 0x4010a0#64, .reg rsp q,
        .reg r10 v0, .reg rdi v1, .reg r9 v2, .reg r13 v3, .reg r12 v4, .reg r15 v5,
        .reg r14 v6, .reg rbp v7, .reg rbx v8, .reg r11 v9,
        .mem (q +ʷ 18446744073709551592#64) 4 v10 true,
        .reg rsi v11, .reg r8 v12, .reg rdx v13, .reg rcx v14, .reg rax v15,
        .mem (q +ʷ 18446744073709551588#64) 4 u1c true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) t
      (Atoms.interp [.pc 0x40113c#64, .reg rsp q,
        .prop (regAny r10), .prop (regAny rdi), .prop (regAny r9), .prop (regAny r13),
        .prop (regAny r12), .prop (regAny r15), .prop (regAny r14), .prop (regAny rbp),
        .prop (regAny rbx), .prop (regAny r11),
        .prop (memAny (q +ʷ 18446744073709551592#64) 4 true),
        .prop (regAny rsi), .prop (regAny r8), .prop (regAny rdx), .prop (regAny rcx),
        .prop (regAny rax),
        .prop (memAny (q +ʷ 18446744073709551588#64) 4 true),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (t ++ colsLeak q) := by
  iterate 50 braid_sym_step
  forget_flags
  forget_regs
  braid_forget_mem (q +ʷ 18446744073709551592#64)
  braid_forget_mem (q +ʷ 18446744073709551588#64)
  done_perm 25
  simp only [colsLeak, sub_lit, BitVec.reduceNeg, List.append_assoc, List.cons_append,
    List.nil_append]

/-- The second half of a round of the loop reveals `diagsLeak` of the stack pointer. The
count of rounds, in its slot, is one less, and the zero flag is set if none is left. -/
theorem diagonals_trace (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word)
    (k : W32) (q u18 : Word) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp [.pc 0x40113c#64, .reg rsp q,
        .reg r10 v0, .reg rdi v1, .reg r9 v2, .reg r13 v3, .reg r12 v4, .reg r15 v5,
        .reg r14 v6, .reg rbp v7, .reg rbx v8,
        .mem (q +ʷ 18446744073709551588#64) 4 v9 true,
        .reg r11 v10, .reg rsi v11, .reg r8 v12, .reg rdx v13, .reg rcx v14, .reg rax v15,
        .mem (q +ʷ 18446744073709551592#64) 4 u18 true,
        .mem (q +ʷ 18446744073709551596#64) 4 (k.zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) t
      (Atoms.interp [.pc 0x4011de#64, .reg rsp q,
        .prop (regAny r10), .prop (regAny rdi), .prop (regAny r9), .prop (regAny r13),
        .prop (regAny r12), .prop (regAny r15), .prop (regAny r14), .prop (regAny rbp),
        .prop (regAny rbx), .prop (regAny r11),
        .prop (memAny (q +ʷ 18446744073709551592#64) 4 true),
        .prop (regAny rsi), .prop (regAny r8), .prop (regAny rdx), .prop (regAny rcx),
        .prop (regAny rax),
        .prop (memAny (q +ʷ 18446744073709551588#64) 4 true),
        .mem (q +ʷ 18446744073709551596#64) 4 ((k - 1).zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .flag Flags.zf ((k - 1).zeroExtend 64 == 0#64), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) (t ++ diagsLeak q) := by
  iterate 51 braid_sym_step
  simp only [zdec]
  try braid_forget_flag 0
  try braid_forget_flag 1
  try braid_forget_flag 2
  try braid_forget_flag 4
  try braid_forget_flag 5
  forget_regs
  braid_forget_mem (q +ʷ 18446744073709551592#64)
  braid_forget_mem (q +ʷ 18446744073709551588#64)
  done_perm 26
  simp only [diagsLeak, sub_lit, BitVec.reduceNeg, List.append_assoc, List.cons_append,
    List.nil_append]

/-- Name what the slot of the state and the spill slot hold. -/
local macro "name_slots " q:term : tactic =>
  `(tactic| (braid_name_mem ($q +ʷ 18446744073709551592#64)
             braid_name_mem ($q +ʷ 18446744073709551588#64)))

/-- **A round of the loop reveals `colsLeak` and then `diagsLeak`** of the stack pointer, up
to the branch at its end, whatever the registers and the slot of the state hold. -/
theorem double_round_trace (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word)
    (k : W32) (q u1c : Word) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp [.pc 0x4010a0#64, .reg rsp q,
        .reg r10 v0, .reg rdi v1, .reg r9 v2, .reg r13 v3, .reg r12 v4, .reg r15 v5,
        .reg r14 v6, .reg rbp v7, .reg rbx v8, .reg r11 v9,
        .mem (q +ʷ 18446744073709551592#64) 4 v10 true,
        .reg rsi v11, .reg r8 v12, .reg rdx v13, .reg rcx v14, .reg rax v15,
        .mem (q +ʷ 18446744073709551588#64) 4 u1c true,
        .mem (q +ʷ 18446744073709551596#64) 4 (k.zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) t
      (Atoms.interp [.pc 0x4011de#64, .reg rsp q,
        .prop (regAny r10), .prop (regAny rdi), .prop (regAny r9), .prop (regAny r13),
        .prop (regAny r12), .prop (regAny r15), .prop (regAny r14), .prop (regAny rbp),
        .prop (regAny rbx), .prop (regAny r11),
        .prop (memAny (q +ʷ 18446744073709551592#64) 4 true),
        .prop (regAny rsi), .prop (regAny r8), .prop (regAny rdx), .prop (regAny rcx),
        .prop (regAny rax),
        .prop (memAny (q +ʷ 18446744073709551588#64) 4 true),
        .mem (q +ʷ 18446744073709551596#64) 4 ((k - 1).zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .flag Flags.zf ((k - 1).zeroExtend 64 == 0#64), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) (t ++ (colsLeak q ++ diagsLeak q)) := by
  braid_call columns_trace v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 q u1c t
  name_regs
  name_slots q
  braid_call diagonals_trace _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ k q _ _
  done_perm 26
  simp only [List.append_assoc]

/-! ## The loop -/

/-- **What the loop of `chacha20_block` reveals**, with the stack pointer at `q` and `n + 1`
rounds left: `roundsLeak q n`, whatever the registers and the slot of the state hold. Proved
by induction on `n`, as `rounds_spec` is. -/
theorem rounds_trace : ∀ (n : Nat)
    (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word) (k : W32)
    (q u1c : Word) (t : Trace), k = BitVec.ofNat 32 (n + 1) → n + 1 < 2 ^ 32 →
    TripleT chacha20_block.program
      (Atoms.interp [.pc 0x4010a0#64, .reg rsp q,
        .reg r10 v0, .reg rdi v1, .reg r9 v2, .reg r13 v3, .reg r12 v4, .reg r15 v5,
        .reg r14 v6, .reg rbp v7, .reg rbx v8, .reg r11 v9,
        .mem (q +ʷ 18446744073709551592#64) 4 v10 true,
        .reg rsi v11, .reg r8 v12, .reg rdx v13, .reg rcx v14, .reg rax v15,
        .mem (q +ʷ 18446744073709551588#64) 4 u1c true,
        .mem (q +ʷ 18446744073709551596#64) 4 (k.zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) t
      (Atoms.interp [.pc 0x4011e4#64, .reg rsp q,
        .prop (regAny r10), .prop (regAny rdi), .prop (regAny r9), .prop (regAny r13),
        .prop (regAny r12), .prop (regAny r15), .prop (regAny r14), .prop (regAny rbp),
        .prop (regAny rbx), .prop (regAny r11),
        .prop (memAny (q +ʷ 18446744073709551592#64) 4 true),
        .prop (regAny rsi), .prop (regAny r8), .prop (regAny rdx), .prop (regAny rcx),
        .prop (regAny rax),
        .prop (memAny (q +ʷ 18446744073709551588#64) 4 true),
        .mem (q +ʷ 18446744073709551596#64) 4 0#64 true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)])
      (t ++ roundsLeak q n) := by
  intro n
  induction n with
  | zero =>
    intro v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 k q u1c t hk _
    obtain rfl : k = 1#32 := hk
    braid_call double_round_trace v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 1#32 q
      u1c t
    braid_sym_step
    braid_forget_flag 3
    done_perm 26
    simp only [roundsLeak, List.append_assoc]
  | succ n ih =>
    intro v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 k q u1c t hk hn
    braid_call double_round_trace v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 k q
      u1c t
    braid_sym_step
    · name_regs
      name_slots q
      braid_forget_flag 3
      braid_call ih _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (k - 1) q _ _ (by rw [hk]; bv_omega)
        (by omega)
      done_perm 26
      simp only [roundsLeak, List.append_assoc, List.cons_append, List.nil_append]
    · exfalso
      have : k - 1 ≠ 0#32 := by rw [hk]; bv_omega
      exact this (by bv_decide)

end Examples.ChaCha20.O2.X86
