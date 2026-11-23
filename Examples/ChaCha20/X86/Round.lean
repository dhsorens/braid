/-
  Examples.ChaCha20.X86.Round

  The loop of `chacha20_block` of `chacha20.c` on x86-64: ten double rounds on a state of
  sixteen words, which the compiler keeps in thirteen registers and three stack slots, with
  two more slots to spill a word and the count of rounds.

  A round of the loop is 109 instructions: the four quarter rounds on the columns, one after
  another, and then the four on the diagonals. Each half is run symbolically once, and ends
  in an expression of the sixteen words, `colsCode` or `diagsCode`, which is the code's
  arithmetic read as arithmetic on 32-bit words. That these are `ChaCha20.columns` and
  `ChaCha20.diagonals` are separate lemmas, proved by `bv_auto`, one quarter round deep.
  After each half the registers and slots hold the specification's function of the state, so
  nothing grows from round to round, and the loop is an induction on the number of rounds
  left.

  ## Main results

  * `colsCode_eq`, `diagsCode_eq`: the arithmetic of the code is that of the specification
  * `columns_spec`, `diagonals_spec`: the two halves of a round
  * `double_round_spec`: a round of the loop is `ChaCha20.inner`
  * `rounds_spec`: the loop, with `n + 1` rounds left, is `ChaCha20.innerN (n + 1)`
-/

module

public import Examples.ChaCha20.X86.Image
public import Examples.ChaCha20.Common
import Braid.BV

@[expose] public section

namespace Examples.ChaCha20.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- Addition as the stepper writes it when it evaluates an `add`: all three types `Word`.
The stepper finds memory atoms by syntactic equality of addresses. -/
local notation:65 a:65 " +ʷ " b:66 => @HAdd.hAdd Word Word Word instHAdd a b

/-! ## The expressions -/

/-- What the first half of a round of the loop of `chacha20_block` computes, instruction by
instruction, from the registers and the stack slots the state is in. -/
def colsCode (m60 m5c r11 r15 ecx edi r10 r14 eax m64 ebp esi r13 r8 ebx r12 : W32) :
    List W32 :=
  let m18 := r11
  let r9 := m60
  let r9 := ecx + r9
  let r13 := r13 ^^^ r9
  let r13 := r13.rotateLeft 16
  let eax := r13 + eax
  let ecx := ecx ^^^ eax
  let ecx := ecx.rotateLeft 12
  let r9 := ecx + r9
  let r13 := r13 ^^^ r9
  let r13 := r13.rotateLeft 8
  let eax := r13 + eax
  let ecx := ecx ^^^ eax
  let ecx := ecx.rotateLeft 7
  let edx := m5c
  let edx := edi + edx
  let r8 := r8 ^^^ edx
  let r8 := r8.rotateLeft 16
  let r11 := m64
  let r11 := r8 + r11
  let edi := edi ^^^ r11
  let edi := edi.rotateLeft 12
  let edx := edi + edx
  let r8 := r8 ^^^ edx
  let r8 := r8.rotateLeft 8
  let r11 := r8 + r11
  let m64 := r11
  let edi := edi ^^^ r11
  let r11 := m18
  let edi := edi.rotateLeft 7
  let r11 := r10 + r11
  let ebx := ebx ^^^ r11
  let ebx := ebx.rotateLeft 16
  let ebp := ebx + ebp
  let r10 := r10 ^^^ ebp
  let r10 := r10.rotateLeft 12
  let r11 := r10 + r11
  let ebx := ebx ^^^ r11
  let ebx := ebx.rotateLeft 8
  let ebp := ebx + ebp
  let r10 := r10 ^^^ ebp
  let r10 := r10.rotateLeft 7
  let r15 := r14 + r15
  let r12 := r12 ^^^ r15
  let r12 := r12.rotateLeft 16
  let esi := r12 + esi
  let r14 := r14 ^^^ esi
  let r14 := r14.rotateLeft 12
  let r15 := r14 + r15
  let r12 := r12 ^^^ r15
  let r12 := r12.rotateLeft 8
  let esi := r12 + esi
  let r14 := r14 ^^^ esi
  let r14 := r14.rotateLeft 7
  [r9, edx, r11, r15, ecx, edi, r10, r14, eax, m64, ebp, esi, r13, r8, ebx, r12]

/-- What the second half of a round of the loop computes, instruction by instruction. -/
def diagsCode (r9 edx r11 r15 ecx edi r10 r14 eax m64 ebp esi r13 r8 ebx r12 : W32) :
    List W32 :=
  let r9 := edi + r9
  let r12 := r12 ^^^ r9
  let r12 := r12.rotateLeft 16
  let ebp := r12 + ebp
  let edi := edi ^^^ ebp
  let edi := edi.rotateLeft 12
  let r9 := edi + r9
  let m60 := r9
  let r12 := r12 ^^^ r9
  let r12 := r12.rotateLeft 8
  let ebp := r12 + ebp
  let edi := edi ^^^ ebp
  let edi := edi.rotateLeft 7
  let edx := r10 + edx
  let r13 := r13 ^^^ edx
  let r13 := r13.rotateLeft 16
  let esi := r13 + esi
  let r10 := r10 ^^^ esi
  let r10 := r10.rotateLeft 12
  let edx := r10 + edx
  let m5c := edx
  let r13 := r13 ^^^ edx
  let r13 := r13.rotateLeft 8
  let esi := r13 + esi
  let r10 := r10 ^^^ esi
  let r10 := r10.rotateLeft 7
  let r11 := r14 + r11
  let r8 := r8 ^^^ r11
  let r8 := r8.rotateLeft 16
  let eax := r8 + eax
  let r14 := r14 ^^^ eax
  let r14 := r14.rotateLeft 12
  let r11 := r14 + r11
  let r8 := r8 ^^^ r11
  let r8 := r8.rotateLeft 8
  let eax := r8 + eax
  let r14 := r14 ^^^ eax
  let r14 := r14.rotateLeft 7
  let r15 := ecx + r15
  let ebx := ebx ^^^ r15
  let ebx := ebx.rotateLeft 16
  let r9 := m64
  let r9 := ebx + r9
  let ecx := ecx ^^^ r9
  let ecx := ecx.rotateLeft 12
  let r15 := ecx + r15
  let ebx := ebx ^^^ r15
  let ebx := ebx.rotateLeft 8
  let r9 := ebx + r9
  let m64 := r9
  let ecx := ecx ^^^ r9
  let ecx := ecx.rotateLeft 7
  [m60, m5c, r11, r15, ecx, edi, r10, r14, eax, m64, ebp, esi, r13, r8, ebx, r12]

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
The words change places: two of those in stack slots are now in `r9d` and `edx`, and their
slots, with the two slots that spill the third word and the count of rounds, hold what is
no longer needed. -/
theorem columns_spec (s : List W32) (k : W32) (q t9 u18 u14 : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x4010d0#64, .reg rsp q,
        .mem (q +ʷ 18446744073709551520#64) 4 ((s.getD 0 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551524#64) 4 ((s.getD 1 0).zeroExtend 64) true,
        .reg r11 ((s.getD 2 0).zeroExtend 64), .reg r15 ((s.getD 3 0).zeroExtend 64),
        .reg rcx ((s.getD 4 0).zeroExtend 64), .reg rdi ((s.getD 5 0).zeroExtend 64),
        .reg r10 ((s.getD 6 0).zeroExtend 64), .reg r14 ((s.getD 7 0).zeroExtend 64),
        .reg rax ((s.getD 8 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551516#64) 4 ((s.getD 9 0).zeroExtend 64) true,
        .reg rbp ((s.getD 10 0).zeroExtend 64), .reg rsi ((s.getD 11 0).zeroExtend 64),
        .reg r13 ((s.getD 12 0).zeroExtend 64), .reg r8 ((s.getD 13 0).zeroExtend 64),
        .reg rbx ((s.getD 14 0).zeroExtend 64), .reg r12 ((s.getD 15 0).zeroExtend 64),
        .reg rdx (k.zeroExtend 64), .reg r9 t9, .mem (q +ʷ 18446744073709551592#64) 4 u18 true,
        .mem (q +ʷ 18446744073709551596#64) 4 u14 true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (Atoms.interp [.pc 0x401185#64, .reg rsp q,
        .reg r9 (((columns s).getD 0 0).zeroExtend 64),
        .reg rdx (((columns s).getD 1 0).zeroExtend 64),
        .reg r11 (((columns s).getD 2 0).zeroExtend 64),
        .reg r15 (((columns s).getD 3 0).zeroExtend 64),
        .reg rcx (((columns s).getD 4 0).zeroExtend 64),
        .reg rdi (((columns s).getD 5 0).zeroExtend 64),
        .reg r10 (((columns s).getD 6 0).zeroExtend 64),
        .reg r14 (((columns s).getD 7 0).zeroExtend 64),
        .reg rax (((columns s).getD 8 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551516#64) 4 (((columns s).getD 9 0).zeroExtend 64) true,
        .reg rbp (((columns s).getD 10 0).zeroExtend 64),
        .reg rsi (((columns s).getD 11 0).zeroExtend 64),
        .reg r13 (((columns s).getD 12 0).zeroExtend 64),
        .reg r8 (((columns s).getD 13 0).zeroExtend 64),
        .reg rbx (((columns s).getD 14 0).zeroExtend 64),
        .reg r12 (((columns s).getD 15 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551520#64) 4 ((s.getD 0 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551524#64) 4 ((s.getD 1 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551592#64) 4 ((s.getD 2 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551596#64) 4 (k.zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  rw [← colsCode_eq s]
  name_state s
  simp only [colsCode, List.getD_cons_zero, List.getD_cons_succ]
  iterate 55 braid_sym_step
  simp only [zadd, zxor, trunc32_zext, zrol16, zrol12, zrol8, zrol7]
  forget_flags
  braid_done

/-- The second half of a round of the loop: the quarter rounds on the diagonals of the
state, and the count of rounds, in `edx`, one less. The words are back where they were at
the head of the loop. -/
theorem diagonals_spec (s : List W32) (k : W32) (q u60 u5c : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x401185#64, .reg rsp q,
        .reg r9 ((s.getD 0 0).zeroExtend 64), .reg rdx ((s.getD 1 0).zeroExtend 64),
        .reg r11 ((s.getD 2 0).zeroExtend 64), .reg r15 ((s.getD 3 0).zeroExtend 64),
        .reg rcx ((s.getD 4 0).zeroExtend 64), .reg rdi ((s.getD 5 0).zeroExtend 64),
        .reg r10 ((s.getD 6 0).zeroExtend 64), .reg r14 ((s.getD 7 0).zeroExtend 64),
        .reg rax ((s.getD 8 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551516#64) 4 ((s.getD 9 0).zeroExtend 64) true,
        .reg rbp ((s.getD 10 0).zeroExtend 64), .reg rsi ((s.getD 11 0).zeroExtend 64),
        .reg r13 ((s.getD 12 0).zeroExtend 64), .reg r8 ((s.getD 13 0).zeroExtend 64),
        .reg rbx ((s.getD 14 0).zeroExtend 64), .reg r12 ((s.getD 15 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551520#64) 4 u60 true,
        .mem (q +ʷ 18446744073709551524#64) 4 u5c true,
        .mem (q +ʷ 18446744073709551596#64) 4 (k.zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (Atoms.interp [.pc 0x401236#64, .reg rsp q,
        .mem (q +ʷ 18446744073709551520#64) 4 (((diagonals s).getD 0 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551524#64) 4 (((diagonals s).getD 1 0).zeroExtend 64) true,
        .reg r11 (((diagonals s).getD 2 0).zeroExtend 64),
        .reg r15 (((diagonals s).getD 3 0).zeroExtend 64),
        .reg rcx (((diagonals s).getD 4 0).zeroExtend 64),
        .reg rdi (((diagonals s).getD 5 0).zeroExtend 64),
        .reg r10 (((diagonals s).getD 6 0).zeroExtend 64),
        .reg r14 (((diagonals s).getD 7 0).zeroExtend 64),
        .reg rax (((diagonals s).getD 8 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551516#64) 4 (((diagonals s).getD 9 0).zeroExtend 64) true,
        .reg rbp (((diagonals s).getD 10 0).zeroExtend 64),
        .reg rsi (((diagonals s).getD 11 0).zeroExtend 64),
        .reg r13 (((diagonals s).getD 12 0).zeroExtend 64),
        .reg r8 (((diagonals s).getD 13 0).zeroExtend 64),
        .reg rbx (((diagonals s).getD 14 0).zeroExtend 64),
        .reg r12 (((diagonals s).getD 15 0).zeroExtend 64),
        .reg rdx ((k - 1).zeroExtend 64), .prop (regAny r9),
        .mem (q +ʷ 18446744073709551596#64) 4 (k.zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .flag Flags.zf ((k - 1).zeroExtend 64 == 0#64), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) := by
  rw [← diagsCode_eq s]
  name_state s
  simp only [diagsCode, List.getD_cons_zero, List.getD_cons_succ]
  iterate 54 braid_sym_step
  simp only [zadd, zxor, trunc32_zext, zrol16, zrol12, zrol8, zrol7, zdec]
  braid_forget 9
  try braid_forget_flag 0
  try braid_forget_flag 1
  try braid_forget_flag 2
  try braid_forget_flag 4
  try braid_forget_flag 5
  braid_done

/-- **A round of the loop** is a double round of ChaCha20 on the state, with the count of
rounds, in `edx`, one less, and the zero flag set if none is left. -/
theorem double_round_spec (s : List W32) (hs : s.length = 16) (k : W32)
    (q t9 u18 u14 : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x4010d0#64, .reg rsp q,
        .mem (q +ʷ 18446744073709551520#64) 4 ((s.getD 0 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551524#64) 4 ((s.getD 1 0).zeroExtend 64) true,
        .reg r11 ((s.getD 2 0).zeroExtend 64), .reg r15 ((s.getD 3 0).zeroExtend 64),
        .reg rcx ((s.getD 4 0).zeroExtend 64), .reg rdi ((s.getD 5 0).zeroExtend 64),
        .reg r10 ((s.getD 6 0).zeroExtend 64), .reg r14 ((s.getD 7 0).zeroExtend 64),
        .reg rax ((s.getD 8 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551516#64) 4 ((s.getD 9 0).zeroExtend 64) true,
        .reg rbp ((s.getD 10 0).zeroExtend 64), .reg rsi ((s.getD 11 0).zeroExtend 64),
        .reg r13 ((s.getD 12 0).zeroExtend 64), .reg r8 ((s.getD 13 0).zeroExtend 64),
        .reg rbx ((s.getD 14 0).zeroExtend 64), .reg r12 ((s.getD 15 0).zeroExtend 64),
        .reg rdx (k.zeroExtend 64), .reg r9 t9, .mem (q +ʷ 18446744073709551592#64) 4 u18 true,
        .mem (q +ʷ 18446744073709551596#64) 4 u14 true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (Atoms.interp [.pc 0x401236#64, .reg rsp q,
        .mem (q +ʷ 18446744073709551520#64) 4 (((inner s).getD 0 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551524#64) 4 (((inner s).getD 1 0).zeroExtend 64) true,
        .reg r11 (((inner s).getD 2 0).zeroExtend 64),
        .reg r15 (((inner s).getD 3 0).zeroExtend 64),
        .reg rcx (((inner s).getD 4 0).zeroExtend 64),
        .reg rdi (((inner s).getD 5 0).zeroExtend 64),
        .reg r10 (((inner s).getD 6 0).zeroExtend 64),
        .reg r14 (((inner s).getD 7 0).zeroExtend 64),
        .reg rax (((inner s).getD 8 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551516#64) 4 (((inner s).getD 9 0).zeroExtend 64) true,
        .reg rbp (((inner s).getD 10 0).zeroExtend 64),
        .reg rsi (((inner s).getD 11 0).zeroExtend 64),
        .reg r13 (((inner s).getD 12 0).zeroExtend 64),
        .reg r8 (((inner s).getD 13 0).zeroExtend 64),
        .reg rbx (((inner s).getD 14 0).zeroExtend 64),
        .reg r12 (((inner s).getD 15 0).zeroExtend 64),
        .reg rdx ((k - 1).zeroExtend 64), .prop (regAny r9),
        .mem (q +ʷ 18446744073709551592#64) 4 ((s.getD 2 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551596#64) 4 (k.zeroExtend 64) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .flag Flags.zf ((k - 1).zeroExtend 64 == 0#64), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) := by
  rw [inner_eq s hs]
  braid_call columns_spec s k q t9 u18 u14
  braid_call diagonals_spec (columns s) k q _ _
  braid_done_perm 28

/-! ## The loop -/

/-- **The loop of `chacha20_block`**, with `n + 1` rounds left: that many double rounds on
the state. Proved by induction on `n`, with this specification as the invariant: a round is
`double_round_spec`, whatever the state, so the proof does not run the code again. The two
spill slots are left with the third word of the state before the last round, and one. -/
theorem rounds_spec : ∀ (n : Nat) (s : List W32) (k : W32) (q t9 u18 u14 : Word),
    s.length = 16 → k = BitVec.ofNat 32 (n + 1) → n + 1 < 2 ^ 32 →
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x4010d0#64, .reg rsp q,
        .mem (q +ʷ 18446744073709551520#64) 4 ((s.getD 0 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551524#64) 4 ((s.getD 1 0).zeroExtend 64) true,
        .reg r11 ((s.getD 2 0).zeroExtend 64), .reg r15 ((s.getD 3 0).zeroExtend 64),
        .reg rcx ((s.getD 4 0).zeroExtend 64), .reg rdi ((s.getD 5 0).zeroExtend 64),
        .reg r10 ((s.getD 6 0).zeroExtend 64), .reg r14 ((s.getD 7 0).zeroExtend 64),
        .reg rax ((s.getD 8 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551516#64) 4 ((s.getD 9 0).zeroExtend 64) true,
        .reg rbp ((s.getD 10 0).zeroExtend 64), .reg rsi ((s.getD 11 0).zeroExtend 64),
        .reg r13 ((s.getD 12 0).zeroExtend 64), .reg r8 ((s.getD 13 0).zeroExtend 64),
        .reg rbx ((s.getD 14 0).zeroExtend 64), .reg r12 ((s.getD 15 0).zeroExtend 64),
        .reg rdx (k.zeroExtend 64), .reg r9 t9, .mem (q +ʷ 18446744073709551592#64) 4 u18 true,
        .mem (q +ʷ 18446744073709551596#64) 4 u14 true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (Atoms.interp [.pc 0x40123c#64, .reg rsp q,
        .mem (q +ʷ 18446744073709551520#64) 4 (((innerN (n + 1) s).getD 0 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551524#64) 4 (((innerN (n + 1) s).getD 1 0).zeroExtend 64) true,
        .reg r11 (((innerN (n + 1) s).getD 2 0).zeroExtend 64),
        .reg r15 (((innerN (n + 1) s).getD 3 0).zeroExtend 64),
        .reg rcx (((innerN (n + 1) s).getD 4 0).zeroExtend 64),
        .reg rdi (((innerN (n + 1) s).getD 5 0).zeroExtend 64),
        .reg r10 (((innerN (n + 1) s).getD 6 0).zeroExtend 64),
        .reg r14 (((innerN (n + 1) s).getD 7 0).zeroExtend 64),
        .reg rax (((innerN (n + 1) s).getD 8 0).zeroExtend 64),
        .mem (q +ʷ 18446744073709551516#64) 4 (((innerN (n + 1) s).getD 9 0).zeroExtend 64) true,
        .reg rbp (((innerN (n + 1) s).getD 10 0).zeroExtend 64),
        .reg rsi (((innerN (n + 1) s).getD 11 0).zeroExtend 64),
        .reg r13 (((innerN (n + 1) s).getD 12 0).zeroExtend 64),
        .reg r8 (((innerN (n + 1) s).getD 13 0).zeroExtend 64),
        .reg rbx (((innerN (n + 1) s).getD 14 0).zeroExtend 64),
        .reg r12 (((innerN (n + 1) s).getD 15 0).zeroExtend 64),
        .reg rdx 0#64, .prop (regAny r9),
        .mem (q +ʷ 18446744073709551592#64) 4 (((innerN n s).getD 2 0).zeroExtend 64) true,
        .mem (q +ʷ 18446744073709551596#64) 4 1#64 true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  intro n
  induction n with
  | zero =>
    intro s k q t9 u18 u14 hs hk _
    obtain rfl : k = 1#32 := hk
    rw [show innerN (0 + 1) s = inner s from rfl, show innerN 0 s = s from rfl]
    braid_call double_round_spec s hs 1#32 q t9 u18 u14
    braid_sym_step
    braid_forget_flag 3
    braid_done_perm 28
  | succ n ih =>
    intro s k q t9 u18 u14 hs hk hn
    rw [show innerN (n + 1 + 1) s = innerN (n + 1) (inner s) from rfl,
      show innerN (n + 1) s = innerN n (inner s) from rfl]
    braid_call double_round_spec s hs k q t9 u18 u14
    braid_sym_step
    · braid_name_reg 9
      braid_forget_flag 3
      braid_call ih (inner s) (k - 1) q _ _ _ (by rw [length_inner, hs])
        (by rw [hk]; bv_omega) (by omega)
      braid_done_perm 28
    · exfalso
      have : k - 1 ≠ 0#32 := by rw [hk]; bv_omega
      exact this (by bv_auto)

end Examples.ChaCha20.X86
