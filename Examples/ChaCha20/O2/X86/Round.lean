/-
  Examples.ChaCha20.O2.X86.Round

  The loop of `chacha20_block` of `chacha20.c` on x86-64, compiled at `-O2`: ten double
  rounds on a state of sixteen words, which the compiler keeps in fifteen registers and one
  stack slot, with one more slot to spill a word and one for the count of rounds.

  A round of the loop is 102 instructions: the four quarter rounds on the columns, one after
  another, and then the four on the diagonals. At `-O1` the compiler kept three words of the
  state in stack slots and the count of rounds in `edx`; here it is the other way round, the
  quarter rounds use other registers, and their instructions are in another order. So the
  two expressions `colsCode` and `diagsCode`, which are the code's arithmetic read
  instruction by instruction, are new, and with them the statements of the four triples.
  The proofs are those of `Examples.ChaCha20.X86.Round`, with the counts of instructions
  changed.

  ## Main results

  * `colsCode_eq`, `diagsCode_eq`: the arithmetic of the code is that of the specification
  * `columns_spec`, `diagonals_spec`: the two halves of a round
  * `double_round_spec`: a round of the loop is `ChaCha20.inner`
  * `rounds_spec`: the loop, with `n + 1` rounds left, is `ChaCha20.innerN (n + 1)`
-/

module

public import Examples.ChaCha20.O2.X86.Image
public import Examples.ChaCha20.Common
import Braid.BV

@[expose] public section

namespace Examples.ChaCha20.O2.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- Addition as the stepper writes it when it evaluates an `add`: all three types `Word`.
The stepper finds memory atoms by syntactic equality of addresses. -/
local notation:65 a:65 " +ʷ " b:66 => @HAdd.hAdd Word Word Word instHAdd a b

/-! ## The expressions -/

/-- What the first half of a round of the loop of `chacha20_block` computes, instruction by
instruction, from the registers and the stack slot the state is in. -/
def colsCode (r10 edi r9 r13 r12 r15 r14 ebp ebx r11 m18 esi r8 edx ecx eax : W32) :
    List W32 :=
  let r10 := r12 + r10
  let r8 := r8 ^^^ r10
  let r8 := r8.rotateLeft 16
  let ebx := r8 + ebx
  let r12 := r12 ^^^ ebx
  let r12 := r12.rotateLeft 12
  let r10 := r12 + r10
  let r8 := r8 ^^^ r10
  let r8 := r8.rotateLeft 8
  let ebx := r8 + ebx
  let r12 := r12 ^^^ ebx
  let r12 := r12.rotateLeft 7
  let edi := r15 + edi
  let edx := edx ^^^ edi
  let edx := edx.rotateLeft 16
  let r11 := edx + r11
  let r15 := r15 ^^^ r11
  let r15 := r15.rotateLeft 12
  let edi := r15 + edi
  let edx := edx ^^^ edi
  let edx := edx.rotateLeft 8
  let r11 := edx + r11
  let m1c := r11
  let r15 := r15 ^^^ r11
  let r15 := r15.rotateLeft 7
  let r9 := r14 + r9
  let ecx := ecx ^^^ r9
  let ecx := ecx.rotateLeft 16
  let r11 := m18
  let r11 := ecx + r11
  let r14 := r14 ^^^ r11
  let r14 := r14.rotateLeft 12
  let r9 := r14 + r9
  let ecx := ecx ^^^ r9
  let ecx := ecx.rotateLeft 8
  let r11 := ecx + r11
  let r14 := r14 ^^^ r11
  let r14 := r14.rotateLeft 7
  let r13 := ebp + r13
  let eax := eax ^^^ r13
  let eax := eax.rotateLeft 16
  let esi := eax + esi
  let ebp := ebp ^^^ esi
  let ebp := ebp.rotateLeft 12
  let r13 := ebp + r13
  let eax := eax ^^^ r13
  let eax := eax.rotateLeft 8
  let esi := eax + esi
  let ebp := ebp ^^^ esi
  let ebp := ebp.rotateLeft 7
  [r10, edi, r9, r13, r12, r15, r14, ebp, ebx, m1c, r11, esi, r8, edx, ecx, eax]

/-- What the second half of a round of the loop computes, instruction by instruction. -/
def diagsCode (r10 edi r9 r13 r12 r15 r14 ebp ebx m1c r11 esi r8 edx ecx eax : W32) :
    List W32 :=
  let r10 := r15 + r10
  let eax := eax ^^^ r10
  let eax := eax.rotateLeft 16
  let r11 := eax + r11
  let r15 := r15 ^^^ r11
  let r15 := r15.rotateLeft 12
  let r10 := r15 + r10
  let eax := eax ^^^ r10
  let eax := eax.rotateLeft 8
  let r11 := eax + r11
  let m18 := r11
  let r15 := r15 ^^^ r11
  let r11 := m1c
  let r15 := r15.rotateLeft 7
  let edi := r14 + edi
  let r8 := r8 ^^^ edi
  let r8 := r8.rotateLeft 16
  let esi := r8 + esi
  let r14 := r14 ^^^ esi
  let r14 := r14.rotateLeft 12
  let edi := r14 + edi
  let r8 := r8 ^^^ edi
  let r8 := r8.rotateLeft 8
  let esi := r8 + esi
  let r14 := r14 ^^^ esi
  let r14 := r14.rotateLeft 7
  let r9 := ebp + r9
  let edx := edx ^^^ r9
  let edx := edx.rotateLeft 16
  let ebx := edx + ebx
  let ebp := ebp ^^^ ebx
  let ebp := ebp.rotateLeft 12
  let r9 := ebp + r9
  let edx := edx ^^^ r9
  let edx := edx.rotateLeft 8
  let ebx := edx + ebx
  let ebp := ebp ^^^ ebx
  let ebp := ebp.rotateLeft 7
  let r13 := r12 + r13
  let ecx := ecx ^^^ r13
  let ecx := ecx.rotateLeft 16
  let r11 := ecx + r11
  let r12 := r12 ^^^ r11
  let r12 := r12.rotateLeft 12
  let r13 := r12 + r13
  let ecx := ecx ^^^ r13
  let ecx := ecx.rotateLeft 8
  let r11 := ecx + r11
  let r12 := r12 ^^^ r11
  let r12 := r12.rotateLeft 7
  [r10, edi, r9, r13, r12, r15, r14, ebp, ebx, r11, m18, esi, r8, edx, ecx, eax]

/-- The first half of a round computes the quarter rounds on the columns. -/
theorem colsCode_eq (s : List W32) :
    colsCode (s.getD 0 0) (s.getD 1 0) (s.getD 2 0) (s.getD 3 0) (s.getD 4 0) (s.getD 5 0)
      (s.getD 6 0) (s.getD 7 0) (s.getD 8 0) (s.getD 9 0) (s.getD 10 0) (s.getD 11 0)
      (s.getD 12 0) (s.getD 13 0) (s.getD 14 0) (s.getD 15 0) = columns s := by
  simp only [colsCode, columns, quarter, List.cons.injEq, and_true]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_auto

/-- The second half of a round computes the quarter rounds on the diagonals. -/
theorem diagsCode_eq (s : List W32) :
    diagsCode (s.getD 0 0) (s.getD 1 0) (s.getD 2 0) (s.getD 3 0) (s.getD 4 0) (s.getD 5 0)
      (s.getD 6 0) (s.getD 7 0) (s.getD 8 0) (s.getD 9 0) (s.getD 10 0) (s.getD 11 0)
      (s.getD 12 0) (s.getD 13 0) (s.getD 14 0) (s.getD 15 0) = diagonals s := by
  simp only [diagsCode, diagonals, quarter, List.cons.injEq, and_true]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_auto

/-! ## A round of the loop -/

/-- Name the sixteen words of a state. -/
local macro "name_state " s:term : tactic =>
  `(tactic| generalize List.getD $s 0 0 = a0, List.getD $s 1 0 = a1, List.getD $s 2 0 = a2,
      List.getD $s 3 0 = a3, List.getD $s 4 0 = a4, List.getD $s 5 0 = a5,
      List.getD $s 6 0 = a6, List.getD $s 7 0 = a7, List.getD $s 8 0 = a8,
      List.getD $s 9 0 = a9, List.getD $s 10 0 = a10, List.getD $s 11 0 = a11,
      List.getD $s 12 0 = a12, List.getD $s 13 0 = a13, List.getD $s 14 0 = a14,
      List.getD $s 15 0 = a15)

/-- Forget the values of the status flags that have one. -/
local macro "forget_flags" : tactic =>
  `(tactic| (try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 3
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-- The first half of a round of the loop: the quarter rounds on the columns of the state.
Two words change places: the tenth is now in the spill slot and the eleventh in `r11d`, and
the slot the eleventh was in holds what it was. -/
theorem columns_spec (s : List W32) (q u1c : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x4010a0#64, .reg rsp q, .reg r10 ((s.getD 0 0).zeroExtend 64),
        .reg rdi ((s.getD 1 0).zeroExtend 64), .reg r9 ((s.getD 2 0).zeroExtend 64),
        .reg r13 ((s.getD 3 0).zeroExtend 64), .reg r12 ((s.getD 4 0).zeroExtend 64),
        .reg r15 ((s.getD 5 0).zeroExtend 64), .reg r14 ((s.getD 6 0).zeroExtend 64),
        .reg rbp ((s.getD 7 0).zeroExtend 64), .reg rbx ((s.getD 8 0).zeroExtend 64),
        .reg r11 ((s.getD 9 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551592#64) 4 ((s.getD 10 0).zeroExtend 64) true,
        .reg rsi ((s.getD 11 0).zeroExtend 64), .reg r8 ((s.getD 12 0).zeroExtend 64),
        .reg rdx ((s.getD 13 0).zeroExtend 64), .reg rcx ((s.getD 14 0).zeroExtend 64),
        .reg rax ((s.getD 15 0).zeroExtend 64), .mem (q +ʷ 18446744073709551588#64) 4 u1c true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (Atoms.interp [.pc 0x40113c#64, .reg rsp q, .reg r10 (((columns s).getD 0 0).zeroExtend 64),
        .reg rdi (((columns s).getD 1 0).zeroExtend 64),
        .reg r9 (((columns s).getD 2 0).zeroExtend 64),
        .reg r13 (((columns s).getD 3 0).zeroExtend 64),
        .reg r12 (((columns s).getD 4 0).zeroExtend 64),
        .reg r15 (((columns s).getD 5 0).zeroExtend 64),
        .reg r14 (((columns s).getD 6 0).zeroExtend 64),
        .reg rbp (((columns s).getD 7 0).zeroExtend 64),
        .reg rbx (((columns s).getD 8 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551588#64) 4 (((columns s).getD 9 0).zeroExtend 64) true,
        .reg r11 (((columns s).getD 10 0).zeroExtend 64),
        .reg rsi (((columns s).getD 11 0).zeroExtend 64),
        .reg r8 (((columns s).getD 12 0).zeroExtend 64),
        .reg rdx (((columns s).getD 13 0).zeroExtend 64),
        .reg rcx (((columns s).getD 14 0).zeroExtend 64),
        .reg rax (((columns s).getD 15 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551592#64) 4 ((s.getD 10 0).zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  rw [← colsCode_eq s]
  name_state s
  simp only [colsCode, List.getD_cons_zero, List.getD_cons_succ]
  iterate 50 braid_sym_step
  simp only [zadd, zxor, trunc32_zext, zrol16, zrol12, zrol8, zrol7]
  forget_flags
  braid_done

/-- The second half of a round of the loop: the quarter rounds on the diagonals of the
state, and the count of rounds, in its stack slot, one less. The words are back where they
were at the head of the loop. -/
theorem diagonals_spec (s : List W32) (k : W32) (q u18 : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x40113c#64, .reg rsp q, .reg r10 ((s.getD 0 0).zeroExtend 64),
        .reg rdi ((s.getD 1 0).zeroExtend 64), .reg r9 ((s.getD 2 0).zeroExtend 64),
        .reg r13 ((s.getD 3 0).zeroExtend 64), .reg r12 ((s.getD 4 0).zeroExtend 64),
        .reg r15 ((s.getD 5 0).zeroExtend 64), .reg r14 ((s.getD 6 0).zeroExtend 64),
        .reg rbp ((s.getD 7 0).zeroExtend 64), .reg rbx ((s.getD 8 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551588#64) 4 ((s.getD 9 0).zeroExtend 64) true,
        .reg r11 ((s.getD 10 0).zeroExtend 64), .reg rsi ((s.getD 11 0).zeroExtend 64),
        .reg r8 ((s.getD 12 0).zeroExtend 64), .reg rdx ((s.getD 13 0).zeroExtend 64),
        .reg rcx ((s.getD 14 0).zeroExtend 64), .reg rax ((s.getD 15 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551592#64) 4 u18 true,
        .mem (q +ʷ 18446744073709551596#64) 4 (k.zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (Atoms.interp [.pc 0x4011de#64, .reg rsp q, .reg r10 (((diagonals s).getD 0 0).zeroExtend 64),
        .reg rdi (((diagonals s).getD 1 0).zeroExtend 64),
        .reg r9 (((diagonals s).getD 2 0).zeroExtend 64),
        .reg r13 (((diagonals s).getD 3 0).zeroExtend 64),
        .reg r12 (((diagonals s).getD 4 0).zeroExtend 64),
        .reg r15 (((diagonals s).getD 5 0).zeroExtend 64),
        .reg r14 (((diagonals s).getD 6 0).zeroExtend 64),
        .reg rbp (((diagonals s).getD 7 0).zeroExtend 64),
        .reg rbx (((diagonals s).getD 8 0).zeroExtend 64),
        .reg r11 (((diagonals s).getD 9 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551592#64) 4 (((diagonals s).getD 10 0).zeroExtend 64) true,
        .reg rsi (((diagonals s).getD 11 0).zeroExtend 64),
        .reg r8 (((diagonals s).getD 12 0).zeroExtend 64),
        .reg rdx (((diagonals s).getD 13 0).zeroExtend 64),
        .reg rcx (((diagonals s).getD 14 0).zeroExtend 64),
        .reg rax (((diagonals s).getD 15 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551588#64) 4 ((s.getD 9 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551596#64) 4 ((k - 1).zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .flag Flags.zf ((k - 1).zeroExtend 64 == 0#64), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) := by
  rw [← diagsCode_eq s]
  name_state s
  simp only [diagsCode, List.getD_cons_zero, List.getD_cons_succ]
  iterate 51 braid_sym_step
  simp only [zadd, zxor, trunc32_zext, zrol16, zrol12, zrol8, zrol7, zdec]
  try braid_forget_flag 0
  try braid_forget_flag 1
  try braid_forget_flag 2
  try braid_forget_flag 4
  try braid_forget_flag 5
  braid_done

/-- **A round of the loop** is a double round of ChaCha20 on the state, with the count of
rounds, in its stack slot, one less, and the zero flag set if none is left. -/
theorem double_round_spec (s : List W32) (hs : s.length = 16) (k : W32) (q u1c : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x4010a0#64, .reg rsp q, .reg r10 ((s.getD 0 0).zeroExtend 64),
        .reg rdi ((s.getD 1 0).zeroExtend 64), .reg r9 ((s.getD 2 0).zeroExtend 64),
        .reg r13 ((s.getD 3 0).zeroExtend 64), .reg r12 ((s.getD 4 0).zeroExtend 64),
        .reg r15 ((s.getD 5 0).zeroExtend 64), .reg r14 ((s.getD 6 0).zeroExtend 64),
        .reg rbp ((s.getD 7 0).zeroExtend 64), .reg rbx ((s.getD 8 0).zeroExtend 64),
        .reg r11 ((s.getD 9 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551592#64) 4 ((s.getD 10 0).zeroExtend 64) true,
        .reg rsi ((s.getD 11 0).zeroExtend 64), .reg r8 ((s.getD 12 0).zeroExtend 64),
        .reg rdx ((s.getD 13 0).zeroExtend 64), .reg rcx ((s.getD 14 0).zeroExtend 64),
        .reg rax ((s.getD 15 0).zeroExtend 64), .mem (q +ʷ 18446744073709551588#64) 4 u1c true,
        .mem (q +ʷ 18446744073709551596#64) 4 (k.zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (Atoms.interp [.pc 0x4011de#64, .reg rsp q, .reg r10 (((inner s).getD 0 0).zeroExtend 64),
        .reg rdi (((inner s).getD 1 0).zeroExtend 64),
        .reg r9 (((inner s).getD 2 0).zeroExtend 64),
        .reg r13 (((inner s).getD 3 0).zeroExtend 64),
        .reg r12 (((inner s).getD 4 0).zeroExtend 64),
        .reg r15 (((inner s).getD 5 0).zeroExtend 64),
        .reg r14 (((inner s).getD 6 0).zeroExtend 64),
        .reg rbp (((inner s).getD 7 0).zeroExtend 64),
        .reg rbx (((inner s).getD 8 0).zeroExtend 64),
        .reg r11 (((inner s).getD 9 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551592#64) 4 (((inner s).getD 10 0).zeroExtend 64) true,
        .reg rsi (((inner s).getD 11 0).zeroExtend 64),
        .reg r8 (((inner s).getD 12 0).zeroExtend 64),
        .reg rdx (((inner s).getD 13 0).zeroExtend 64),
        .reg rcx (((inner s).getD 14 0).zeroExtend 64),
        .reg rax (((inner s).getD 15 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551588#64) 4 (((columns s).getD 9 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551596#64) 4 ((k - 1).zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .flag Flags.zf ((k - 1).zeroExtend 64 == 0#64), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) := by
  rw [inner_eq s hs]
  braid_call columns_spec s q u1c
  braid_call diagonals_spec (columns s) k q _
  braid_done_perm 26

/-! ## The loop -/

/-- **The loop of `chacha20_block`**, with `n + 1` rounds left: that many double rounds on
the state. Proved by induction on `n`, with this specification as the invariant: a round is
`double_round_spec`, whatever the state, so the proof does not run the code again. The spill
slot is left with a word of the state half a round before the end. -/
theorem rounds_spec : ∀ (n : Nat) (s : List W32) (k : W32) (q u1c : Word),
    s.length = 16 → k = BitVec.ofNat 32 (n + 1) → n + 1 < 2 ^ 32 →
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x4010a0#64, .reg rsp q, .reg r10 ((s.getD 0 0).zeroExtend 64),
        .reg rdi ((s.getD 1 0).zeroExtend 64), .reg r9 ((s.getD 2 0).zeroExtend 64),
        .reg r13 ((s.getD 3 0).zeroExtend 64), .reg r12 ((s.getD 4 0).zeroExtend 64),
        .reg r15 ((s.getD 5 0).zeroExtend 64), .reg r14 ((s.getD 6 0).zeroExtend 64),
        .reg rbp ((s.getD 7 0).zeroExtend 64), .reg rbx ((s.getD 8 0).zeroExtend 64),
        .reg r11 ((s.getD 9 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551592#64) 4 ((s.getD 10 0).zeroExtend 64) true,
        .reg rsi ((s.getD 11 0).zeroExtend 64), .reg r8 ((s.getD 12 0).zeroExtend 64),
        .reg rdx ((s.getD 13 0).zeroExtend 64), .reg rcx ((s.getD 14 0).zeroExtend 64),
        .reg rax ((s.getD 15 0).zeroExtend 64), .mem (q +ʷ 18446744073709551588#64) 4 u1c true,
        .mem (q +ʷ 18446744073709551596#64) 4 (k.zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (Atoms.interp [.pc 0x4011e4#64, .reg rsp q,
        .reg r10 (((innerN (n + 1) s).getD 0 0).zeroExtend 64),
        .reg rdi (((innerN (n + 1) s).getD 1 0).zeroExtend 64),
        .reg r9 (((innerN (n + 1) s).getD 2 0).zeroExtend 64),
        .reg r13 (((innerN (n + 1) s).getD 3 0).zeroExtend 64),
        .reg r12 (((innerN (n + 1) s).getD 4 0).zeroExtend 64),
        .reg r15 (((innerN (n + 1) s).getD 5 0).zeroExtend 64),
        .reg r14 (((innerN (n + 1) s).getD 6 0).zeroExtend 64),
        .reg rbp (((innerN (n + 1) s).getD 7 0).zeroExtend 64),
        .reg rbx (((innerN (n + 1) s).getD 8 0).zeroExtend 64),
        .reg r11 (((innerN (n + 1) s).getD 9 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551592#64) 4 (((innerN (n + 1) s).getD 10 0).zeroExtend 64) true,
        .reg rsi (((innerN (n + 1) s).getD 11 0).zeroExtend 64),
        .reg r8 (((innerN (n + 1) s).getD 12 0).zeroExtend 64),
        .reg rdx (((innerN (n + 1) s).getD 13 0).zeroExtend 64),
        .reg rcx (((innerN (n + 1) s).getD 14 0).zeroExtend 64),
        .reg rax (((innerN (n + 1) s).getD 15 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551588#64) 4
          (((columns (innerN n s)).getD 9 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551596#64) 4 0#64 true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  intro n
  induction n with
  | zero =>
    intro s k q u1c hs hk _
    obtain rfl : k = 1#32 := hk
    rw [show innerN (0 + 1) s = inner s from rfl, show innerN 0 s = s from rfl]
    braid_call double_round_spec s hs 1#32 q u1c
    braid_sym_step
    braid_forget_flag 3
    braid_done_perm 26
  | succ n ih =>
    intro s k q u1c hs hk hn
    rw [show innerN (n + 1 + 1) s = innerN (n + 1) (inner s) from rfl,
      show innerN (n + 1) s = innerN n (inner s) from rfl]
    braid_call double_round_spec s hs k q u1c
    braid_sym_step
    · braid_forget_flag 3
      braid_call ih (inner s) (k - 1) q _ (by rw [length_inner, hs])
        (by rw [hk]; bv_omega) (by omega)
      braid_done_perm 26
    · exfalso
      have : k - 1 ≠ 0#32 := by rw [hk]; bv_omega
      exact this (by bv_auto)

end Examples.ChaCha20.O2.X86
