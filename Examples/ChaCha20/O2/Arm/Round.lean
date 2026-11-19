/-
  Examples.ChaCha20.O2.Arm.Round

  The loop of `chacha20_block` of `chacha20.c` on AArch64, compiled at `-O2`: ten double
  rounds on a state of sixteen words, which the compiler keeps in sixteen registers.

  At `-O2` a round of the loop is again 96 instructions that work on the registers alone, but
  not those of `-O1` under a renaming: the sixteen words are in other registers at the head
  of the loop and in the middle of a round, the instructions come in another order, and the
  code uses one more register, `x23`. The expressions `colsCode` and `diagsCode`, which are
  the code's arithmetic read instruction by instruction on 32-bit words, are therefore
  written again, from the disassembly of this binary, and so are the registers of the four
  triples. The proofs are those of `Examples.ChaCha20.Arm.Round` with the registers that are
  forgotten or named changed: each half is run symbolically once and ends in its expression,
  that the expressions are `ChaCha20.columns` and `ChaCha20.diagonals` is proved by
  `bv_decide` one quarter round deep, and the loop is an induction on the number of rounds
  left.

  ## Main results

  * `colsCode_eq`, `diagsCode_eq`: the arithmetic of the code is that of the specification
  * `columns_spec`, `diagonals_spec`: the two halves of a round
  * `double_round_spec`: a round of the loop is `ChaCha20.inner`
  * `rounds_spec`: the loop, with `n + 1` rounds left, is `ChaCha20.innerN (n + 1)`
-/

module

public import Examples.ChaCha20.O2.Arm.Image
public import Examples.ChaCha20.Common
public import Examples.ArmMachine

@[expose] public section

namespace Examples.ChaCha20.O2.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-! ## The expressions -/

/-- What the first half of a round of the loop of `chacha20_block` computes, instruction by
instruction, from the registers the state is in. -/
def colsCode (w7 w6 w5 w17 w4 w3 w2 w16 w15 w18 w11 w10 w14 w13 w12 w9 : W32) :
    List W32 :=
  let w6 := w6 + w3
  let w7 := w7 + w4
  let w5 := w5 + w2
  let w17 := w17 + w16
  let w13 := w13 ^^^ w6
  let w14 := w14 ^^^ w7
  let w12 := w12 ^^^ w5
  let w9 := w9 ^^^ w17
  let w13 := w13.rotateLeft 16
  let w14 := w14.rotateLeft 16
  let w12 := w12.rotateLeft 16
  let w9 := w9.rotateLeft 16
  let w18 := w18 + w13
  let w19 := w15 + w14
  let w20 := w11 + w12
  let w15 := w18 ^^^ w3
  let w3 := w10 + w9
  let w11 := w19 ^^^ w4
  let w2 := w20 ^^^ w2
  let w10 := w3 ^^^ w16
  let w4 := w11.rotateLeft 12
  let w21 := w15.rotateLeft 12
  let w2 := w2.rotateLeft 12
  let w22 := w10.rotateLeft 12
  let w7 := w4 + w7
  let w6 := w21 + w6
  let w5 := w2 + w5
  let w11 := w22 + w17
  let w10 := w7 ^^^ w14
  let w13 := w6 ^^^ w13
  let w12 := w5 ^^^ w12
  let w9 := w11 ^^^ w9
  let w14 := w10.rotateLeft 8
  let w17 := w13.rotateLeft 8
  let w15 := w12.rotateLeft 8
  let w23 := w9.rotateLeft 8
  let w10 := w14 + w19
  let w9 := w17 + w18
  let w16 := w15 + w20
  let w3 := w23 + w3
  let w12 := w10 ^^^ w4
  let w13 := w9 ^^^ w21
  let w2 := w16 ^^^ w2
  let w4 := w3 ^^^ w22
  let w18 := w13.rotateLeft 7
  let w2 := w2.rotateLeft 7
  let w4 := w4.rotateLeft 7
  let w13 := w12.rotateLeft 7
  [w7, w6, w5, w11, w13, w18, w2, w4, w10, w9, w16, w3, w14, w17, w15, w23]

/-- What the second half of a round of the loop computes, instruction by instruction. -/
def diagsCode (w7 w6 w5 w11 w13 w18 w2 w4 w10 w9 w16 w3 w14 w17 w15 w23 : W32) :
    List W32 :=
  let w12 := w18 + w7
  let w6 := w2 + w6
  let w5 := w4 + w5
  let w11 := w11 + w13
  let w7 := w23 ^^^ w12
  let w14 := w6 ^^^ w14
  let w17 := w5 ^^^ w17
  let w19 := w7.rotateLeft 16
  let w15 := w11 ^^^ w15
  let w14 := w14.rotateLeft 16
  let w20 := w17.rotateLeft 16
  let w15 := w15.rotateLeft 16
  let w16 := w19 + w16
  let w3 := w3 + w14
  let w21 := w20 + w10
  let w10 := w16 ^^^ w18
  let w17 := w3 ^^^ w2
  let w18 := w21 ^^^ w4
  let w2 := w15 + w9
  let w4 := w10.rotateLeft 12
  let w22 := w17.rotateLeft 12
  let w9 := w2 ^^^ w13
  let w18 := w18.rotateLeft 12
  let w23 := w9.rotateLeft 12
  let w7 := w4 + w12
  let w6 := w22 + w6
  let w5 := w18 + w5
  let w9 := w7 ^^^ w19
  let w17 := w23 + w11
  let w10 := w6 ^^^ w14
  let w11 := w5 ^^^ w20
  let w9 := w9.rotateLeft 8
  let w12 := w17 ^^^ w15
  let w14 := w10.rotateLeft 8
  let w13 := w11.rotateLeft 8
  let w12 := w12.rotateLeft 8
  let w11 := w9 + w16
  let w10 := w14 + w3
  let w15 := w13 + w21
  let w16 := w11 ^^^ w4
  let w4 := w10 ^^^ w22
  let w19 := w15 ^^^ w18
  let w18 := w12 + w2
  let w2 := w4.rotateLeft 7
  let w4 := w18 ^^^ w23
  let w3 := w16.rotateLeft 7
  let w16 := w19.rotateLeft 7
  let w4 := w4.rotateLeft 7
  [w7, w6, w5, w17, w4, w3, w2, w16, w15, w18, w11, w10, w14, w13, w12, w9]

/-- The first half of a round computes the quarter rounds on the columns. -/
theorem colsCode_eq (s : List W32) :
    colsCode (s.getD 0 0) (s.getD 1 0) (s.getD 2 0) (s.getD 3 0) (s.getD 4 0) (s.getD 5 0)
      (s.getD 6 0) (s.getD 7 0) (s.getD 8 0) (s.getD 9 0) (s.getD 10 0) (s.getD 11 0)
      (s.getD 12 0) (s.getD 13 0) (s.getD 14 0) (s.getD 15 0) = columns s := by
  simp only [colsCode, columns, quarter, List.cons.injEq, and_true]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- The second half of a round computes the quarter rounds on the diagonals. -/
theorem diagsCode_eq (s : List W32) :
    diagsCode (s.getD 0 0) (s.getD 1 0) (s.getD 2 0) (s.getD 3 0) (s.getD 4 0) (s.getD 5 0)
      (s.getD 6 0) (s.getD 7 0) (s.getD 8 0) (s.getD 9 0) (s.getD 10 0) (s.getD 11 0)
      (s.getD 12 0) (s.getD 13 0) (s.getD 14 0) (s.getD 15 0) = diagonals s := by
  simp only [diagsCode, diagonals, quarter, List.cons.injEq, and_true]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-! ## A round of the loop -/

/-- Name the sixteen words of a state. -/
local macro "name_state " s:term : tactic =>
  `(tactic| generalize List.getD $s 0 0 = a0, List.getD $s 1 0 = a1, List.getD $s 2 0 = a2,
      List.getD $s 3 0 = a3, List.getD $s 4 0 = a4, List.getD $s 5 0 = a5,
      List.getD $s 6 0 = a6, List.getD $s 7 0 = a7, List.getD $s 8 0 = a8,
      List.getD $s 9 0 = a9, List.getD $s 10 0 = a10, List.getD $s 11 0 = a11,
      List.getD $s 12 0 = a12, List.getD $s 13 0 = a13, List.getD $s 14 0 = a14,
      List.getD $s 15 0 = a15)

/-- The first half of a round of the loop: the quarter rounds on the columns of the state,
and the count of rounds, in `w8`, one less. The words change registers, one of them into
`x23`. -/
theorem columns_spec (s : List W32) (k : W32) (t19 t20 t21 t22 t23 : Word)
    (fn fz fc fv : Bool) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x10074#64,
        .reg x7 ((s.getD 0 0).zeroExtend 64), .reg x6 ((s.getD 1 0).zeroExtend 64),
        .reg x5 ((s.getD 2 0).zeroExtend 64), .reg x17 ((s.getD 3 0).zeroExtend 64),
        .reg x4 ((s.getD 4 0).zeroExtend 64), .reg x3 ((s.getD 5 0).zeroExtend 64),
        .reg x2 ((s.getD 6 0).zeroExtend 64), .reg x16 ((s.getD 7 0).zeroExtend 64),
        .reg x15 ((s.getD 8 0).zeroExtend 64), .reg x18 ((s.getD 9 0).zeroExtend 64),
        .reg x11 ((s.getD 10 0).zeroExtend 64), .reg x10 ((s.getD 11 0).zeroExtend 64),
        .reg x14 ((s.getD 12 0).zeroExtend 64), .reg x13 ((s.getD 13 0).zeroExtend 64),
        .reg x12 ((s.getD 14 0).zeroExtend 64), .reg x9 ((s.getD 15 0).zeroExtend 64),
        .reg x8 (k.zeroExtend 64), .reg x19 t19, .reg x20 t20, .reg x21 t21, .reg x22 t22,
        .reg x23 t23,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc 0x10138#64,
        .reg x7 (((columns s).getD 0 0).zeroExtend 64),
        .reg x6 (((columns s).getD 1 0).zeroExtend 64),
        .reg x5 (((columns s).getD 2 0).zeroExtend 64),
        .reg x11 (((columns s).getD 3 0).zeroExtend 64),
        .reg x13 (((columns s).getD 4 0).zeroExtend 64),
        .reg x18 (((columns s).getD 5 0).zeroExtend 64),
        .reg x2 (((columns s).getD 6 0).zeroExtend 64),
        .reg x4 (((columns s).getD 7 0).zeroExtend 64),
        .reg x10 (((columns s).getD 8 0).zeroExtend 64),
        .reg x9 (((columns s).getD 9 0).zeroExtend 64),
        .reg x16 (((columns s).getD 10 0).zeroExtend 64),
        .reg x3 (((columns s).getD 11 0).zeroExtend 64),
        .reg x14 (((columns s).getD 12 0).zeroExtend 64),
        .reg x17 (((columns s).getD 13 0).zeroExtend 64),
        .reg x15 (((columns s).getD 14 0).zeroExtend 64),
        .reg x23 (((columns s).getD 15 0).zeroExtend 64),
        .reg x8 ((k - 1).zeroExtend 64), .prop (regAny x12), .prop (regAny x19),
        .prop (regAny x20), .prop (regAny x21), .prop (regAny x22),
        .prop (flagAny Flags.n), .flag Flags.z (k.zeroExtend 64 == 1#64),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) := by
  rw [← colsCode_eq s]
  name_state s
  simp only [colsCode, List.getD_cons_zero, List.getD_cons_succ]
  iterate 49 braid_sym_step
  simp only [zadd, zxor, trunc32_zext, zror16, zror20, zror24, zror25, zdec]
  braid_forget 12
  braid_forget 19
  braid_forget 20
  braid_forget 21
  braid_forget 22
  braid_forget_flag 0
  braid_forget_flag 2
  braid_forget_flag 3
  braid_done

/-- The second half of a round of the loop: the quarter rounds on the diagonals of the
state. The words are back in the registers they were in at the head of the loop. -/
theorem diagonals_spec (s : List W32) (t12 t19 t20 t21 t22 : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x10138#64,
        .reg x7 ((s.getD 0 0).zeroExtend 64), .reg x6 ((s.getD 1 0).zeroExtend 64),
        .reg x5 ((s.getD 2 0).zeroExtend 64), .reg x11 ((s.getD 3 0).zeroExtend 64),
        .reg x13 ((s.getD 4 0).zeroExtend 64), .reg x18 ((s.getD 5 0).zeroExtend 64),
        .reg x2 ((s.getD 6 0).zeroExtend 64), .reg x4 ((s.getD 7 0).zeroExtend 64),
        .reg x10 ((s.getD 8 0).zeroExtend 64), .reg x9 ((s.getD 9 0).zeroExtend 64),
        .reg x16 ((s.getD 10 0).zeroExtend 64), .reg x3 ((s.getD 11 0).zeroExtend 64),
        .reg x14 ((s.getD 12 0).zeroExtend 64), .reg x17 ((s.getD 13 0).zeroExtend 64),
        .reg x15 ((s.getD 14 0).zeroExtend 64), .reg x23 ((s.getD 15 0).zeroExtend 64),
        .reg x12 t12, .reg x19 t19, .reg x20 t20, .reg x21 t21, .reg x22 t22])
      (Atoms.interp [.pc 0x101f8#64,
        .reg x7 (((diagonals s).getD 0 0).zeroExtend 64),
        .reg x6 (((diagonals s).getD 1 0).zeroExtend 64),
        .reg x5 (((diagonals s).getD 2 0).zeroExtend 64),
        .reg x17 (((diagonals s).getD 3 0).zeroExtend 64),
        .reg x4 (((diagonals s).getD 4 0).zeroExtend 64),
        .reg x3 (((diagonals s).getD 5 0).zeroExtend 64),
        .reg x2 (((diagonals s).getD 6 0).zeroExtend 64),
        .reg x16 (((diagonals s).getD 7 0).zeroExtend 64),
        .reg x15 (((diagonals s).getD 8 0).zeroExtend 64),
        .reg x18 (((diagonals s).getD 9 0).zeroExtend 64),
        .reg x11 (((diagonals s).getD 10 0).zeroExtend 64),
        .reg x10 (((diagonals s).getD 11 0).zeroExtend 64),
        .reg x14 (((diagonals s).getD 12 0).zeroExtend 64),
        .reg x13 (((diagonals s).getD 13 0).zeroExtend 64),
        .reg x12 (((diagonals s).getD 14 0).zeroExtend 64),
        .reg x9 (((diagonals s).getD 15 0).zeroExtend 64),
        .prop (regAny x19), .prop (regAny x20), .prop (regAny x21), .prop (regAny x22),
        .prop (regAny x23)]) := by
  rw [← diagsCode_eq s]
  name_state s
  simp only [diagsCode, List.getD_cons_zero, List.getD_cons_succ]
  iterate 48 braid_sym_step
  simp only [zadd, zxor, trunc32_zext, zror16, zror20, zror24, zror25]
  braid_forget 19
  braid_forget 20
  braid_forget 21
  braid_forget 22
  braid_forget 23
  braid_done

/-- **A round of the loop** is a double round of ChaCha20 on the state, with the count of
rounds, in `w8`, one less, and the zero flag set if none is left. -/
theorem double_round_spec (s : List W32) (hs : s.length = 16) (k : W32)
    (t19 t20 t21 t22 t23 : Word) (fn fz fc fv : Bool) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x10074#64,
        .reg x7 ((s.getD 0 0).zeroExtend 64), .reg x6 ((s.getD 1 0).zeroExtend 64),
        .reg x5 ((s.getD 2 0).zeroExtend 64), .reg x17 ((s.getD 3 0).zeroExtend 64),
        .reg x4 ((s.getD 4 0).zeroExtend 64), .reg x3 ((s.getD 5 0).zeroExtend 64),
        .reg x2 ((s.getD 6 0).zeroExtend 64), .reg x16 ((s.getD 7 0).zeroExtend 64),
        .reg x15 ((s.getD 8 0).zeroExtend 64), .reg x18 ((s.getD 9 0).zeroExtend 64),
        .reg x11 ((s.getD 10 0).zeroExtend 64), .reg x10 ((s.getD 11 0).zeroExtend 64),
        .reg x14 ((s.getD 12 0).zeroExtend 64), .reg x13 ((s.getD 13 0).zeroExtend 64),
        .reg x12 ((s.getD 14 0).zeroExtend 64), .reg x9 ((s.getD 15 0).zeroExtend 64),
        .reg x8 (k.zeroExtend 64), .reg x19 t19, .reg x20 t20, .reg x21 t21, .reg x22 t22,
        .reg x23 t23,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc 0x101f8#64,
        .reg x7 (((inner s).getD 0 0).zeroExtend 64), .reg x6 (((inner s).getD 1 0).zeroExtend 64),
        .reg x5 (((inner s).getD 2 0).zeroExtend 64),
        .reg x17 (((inner s).getD 3 0).zeroExtend 64),
        .reg x4 (((inner s).getD 4 0).zeroExtend 64),
        .reg x3 (((inner s).getD 5 0).zeroExtend 64),
        .reg x2 (((inner s).getD 6 0).zeroExtend 64),
        .reg x16 (((inner s).getD 7 0).zeroExtend 64),
        .reg x15 (((inner s).getD 8 0).zeroExtend 64),
        .reg x18 (((inner s).getD 9 0).zeroExtend 64),
        .reg x11 (((inner s).getD 10 0).zeroExtend 64),
        .reg x10 (((inner s).getD 11 0).zeroExtend 64),
        .reg x14 (((inner s).getD 12 0).zeroExtend 64),
        .reg x13 (((inner s).getD 13 0).zeroExtend 64),
        .reg x12 (((inner s).getD 14 0).zeroExtend 64),
        .reg x9 (((inner s).getD 15 0).zeroExtend 64),
        .reg x8 ((k - 1).zeroExtend 64), .prop (regAny x19), .prop (regAny x20),
        .prop (regAny x21), .prop (regAny x22), .prop (regAny x23),
        .prop (flagAny Flags.n), .flag Flags.z (k.zeroExtend 64 == 1#64),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) := by
  rw [inner_eq s hs]
  braid_call columns_spec s k t19 t20 t21 t22 t23 fn fz fc fv
  braid_name_reg 12
  braid_name_reg 19
  braid_name_reg 20
  braid_name_reg 21
  braid_name_reg 22
  braid_call diagonals_spec (columns s) _ _ _ _ _
  braid_done

/-! ## The loop -/

/-- **The loop of `chacha20_block`**, with `n + 1` rounds left: that many double rounds on
the state. Proved by induction on `n`, with this specification as the invariant: a round is
`double_round_spec`, whatever the state, so the proof does not run the code again. -/
theorem rounds_spec : ∀ (n : Nat) (s : List W32) (k : W32) (t19 t20 t21 t22 t23 : Word)
    (fn fz fc fv : Bool), s.length = 16 → k = BitVec.ofNat 32 (n + 1) → n + 1 < 2 ^ 32 →
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x10074#64,
        .reg x7 ((s.getD 0 0).zeroExtend 64), .reg x6 ((s.getD 1 0).zeroExtend 64),
        .reg x5 ((s.getD 2 0).zeroExtend 64), .reg x17 ((s.getD 3 0).zeroExtend 64),
        .reg x4 ((s.getD 4 0).zeroExtend 64), .reg x3 ((s.getD 5 0).zeroExtend 64),
        .reg x2 ((s.getD 6 0).zeroExtend 64), .reg x16 ((s.getD 7 0).zeroExtend 64),
        .reg x15 ((s.getD 8 0).zeroExtend 64), .reg x18 ((s.getD 9 0).zeroExtend 64),
        .reg x11 ((s.getD 10 0).zeroExtend 64), .reg x10 ((s.getD 11 0).zeroExtend 64),
        .reg x14 ((s.getD 12 0).zeroExtend 64), .reg x13 ((s.getD 13 0).zeroExtend 64),
        .reg x12 ((s.getD 14 0).zeroExtend 64), .reg x9 ((s.getD 15 0).zeroExtend 64),
        .reg x8 (k.zeroExtend 64), .reg x19 t19, .reg x20 t20, .reg x21 t21, .reg x22 t22,
        .reg x23 t23,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc 0x101fc#64,
        .reg x7 (((innerN (n + 1) s).getD 0 0).zeroExtend 64),
        .reg x6 (((innerN (n + 1) s).getD 1 0).zeroExtend 64),
        .reg x5 (((innerN (n + 1) s).getD 2 0).zeroExtend 64),
        .reg x17 (((innerN (n + 1) s).getD 3 0).zeroExtend 64),
        .reg x4 (((innerN (n + 1) s).getD 4 0).zeroExtend 64),
        .reg x3 (((innerN (n + 1) s).getD 5 0).zeroExtend 64),
        .reg x2 (((innerN (n + 1) s).getD 6 0).zeroExtend 64),
        .reg x16 (((innerN (n + 1) s).getD 7 0).zeroExtend 64),
        .reg x15 (((innerN (n + 1) s).getD 8 0).zeroExtend 64),
        .reg x18 (((innerN (n + 1) s).getD 9 0).zeroExtend 64),
        .reg x11 (((innerN (n + 1) s).getD 10 0).zeroExtend 64),
        .reg x10 (((innerN (n + 1) s).getD 11 0).zeroExtend 64),
        .reg x14 (((innerN (n + 1) s).getD 12 0).zeroExtend 64),
        .reg x13 (((innerN (n + 1) s).getD 13 0).zeroExtend 64),
        .reg x12 (((innerN (n + 1) s).getD 14 0).zeroExtend 64),
        .reg x9 (((innerN (n + 1) s).getD 15 0).zeroExtend 64),
        .reg x8 0#64, .prop (regAny x19), .prop (regAny x20), .prop (regAny x21),
        .prop (regAny x22), .prop (regAny x23), .prop (flagAny Flags.n),
        .prop (flagAny Flags.z), .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) := by
  intro n
  induction n with
  | zero =>
    intro s k t19 t20 t21 t22 t23 fn fz fc fv hs hk _
    obtain rfl : k = 1#32 := hk
    rw [show innerN (0 + 1) s = inner s from rfl]
    braid_call double_round_spec s hs 1#32 t19 t20 t21 t22 t23 fn fz fc fv
    braid_sym_step
    braid_forget_flag 1
    braid_done
  | succ n ih =>
    intro s k t19 t20 t21 t22 t23 fn fz fc fv hs hk hn
    rw [show innerN (n + 1 + 1) s = innerN (n + 1) (inner s) from rfl]
    braid_call double_round_spec s hs k t19 t20 t21 t22 t23 fn fz fc fv
    braid_sym_step
    · braid_name_reg 19
      braid_name_reg 20
      braid_name_reg 21
      braid_name_reg 22
      braid_name_reg 23
      braid_name_flag 0
      braid_name_flag 2
      braid_name_flag 3
      braid_call ih (inner s) (k - 1) _ _ _ _ _ _ _ _ _ (by rw [length_inner, hs])
        (by rw [hk]; bv_omega) (by omega)
      braid_done
    · exfalso
      have : k ≠ 1#32 := by rw [hk]; bv_omega
      exact this (by bv_decide)

end Examples.ChaCha20.O2.Arm
