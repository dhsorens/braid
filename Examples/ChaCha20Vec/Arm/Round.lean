/-
  Examples.ChaCha20Vec.Arm.Round

  The loop of `chacha20_block_vec` of `chacha20_vec.c` on AArch64: ten double rounds on a
  state of sixteen words, which the compiler keeps as four rows in four vector registers. A
  vector register is two 64-bit words of the symbolic state, each holding two 32-bit lanes
  (`ChaCha20Vec.pack`).

  A round of the loop is 38 instructions that work on the registers alone: a column round on
  the rows, with the rotations of the lanes of three rows that bring the diagonals into the
  columns, and then a column round again, with the rotations back. Each half is run
  symbolically once. The lemmas of `Examples.ChaCha20Vec.Common` turn the shifts, masks and
  additions of lanes of the lowered code into arithmetic on the lanes, and what is left in
  each lane is an expression of four words, `qrCols` or `qrDiags`, which is the code's
  arithmetic read as arithmetic on 32-bit words. That these are `ChaCha20.quarter` are
  separate lemmas, proved by `bv_decide`. After each half the registers hold the
  specification's function of the state, so nothing grows from round to round, and the loop
  is an induction on the number of rounds left.

  ## Main results

  * `qrCols_eq`, `qrDiags_eq`: the arithmetic of the code in a lane is the quarter round
  * `columns_spec`, `diagonals_spec`: the two halves of a round
  * `double_round_spec`: a round of the loop is `ChaCha20.inner`
  * `rounds_spec`: the loop, with `n + 1` rounds left, is `ChaCha20.innerN (n + 1)`
-/

module

public import Examples.ChaCha20Vec.Arm.Image
public import Examples.ChaCha20Vec.Common
public import Examples.ArmMachine

@[expose] public section

namespace Examples.ChaCha20Vec.Arm

open Braid Examples Examples.ChaCha20 Lowering.Arm Lowering.Arm.Regs

/-! ## The expressions -/

/-- What the first half of a round of the loop computes in a lane, instruction by
instruction. -/
def qrCols (a b c d : W32) : W32 × W32 × W32 × W32 :=
  let a := b + a
  let d := (d ^^^ a).rotateLeft 16
  let c := d + c
  let b := (c ^^^ b).rotateLeft 12
  let a := b + a
  let d := (a ^^^ d).rotateLeft 8
  let c := d + c
  let b := (c ^^^ b).rotateLeft 7
  (a, b, c, d)

/-- What the second half of a round of the loop computes in a lane, instruction by
instruction. -/
def qrDiags (a b c d : W32) : W32 × W32 × W32 × W32 :=
  let a := b + a
  let d := (a ^^^ d).rotateLeft 16
  let c := d + c
  let b := (c ^^^ b).rotateLeft 12
  let a := b + a
  let d := (a ^^^ d).rotateLeft 8
  let c := d + c
  let b := (c ^^^ b).rotateLeft 7
  (a, b, c, d)

/-- The first half of a round computes the quarter round in each lane. -/
theorem qrCols_eq (a b c d : W32) : qrCols a b c d = quarter a b c d := by
  simp only [qrCols, quarter, Prod.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- The second half of a round computes the quarter round in each lane. -/
theorem qrDiags_eq (a b c d : W32) : qrDiags a b c d = quarter a b c d := by
  simp only [qrDiags, quarter, Prod.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_⟩ <;> bv_decide

/-! ## A round of the loop -/

/-- Name the sixteen words of a state. -/
local macro "name_state " s:term : tactic =>
  `(tactic| generalize List.getD $s 0 0 = a0, List.getD $s 1 0 = a1, List.getD $s 2 0 = a2,
      List.getD $s 3 0 = a3, List.getD $s 4 0 = a4, List.getD $s 5 0 = a5,
      List.getD $s 6 0 = a6, List.getD $s 7 0 = a7, List.getD $s 8 0 = a8,
      List.getD $s 9 0 = a9, List.getD $s 10 0 = a10, List.getD $s 11 0 = a11,
      List.getD $s 12 0 = a12, List.getD $s 13 0 = a13, List.getD $s 14 0 = a14,
      List.getD $s 15 0 = a15)

/-- Turn the shifts, masks and additions of lanes that the stepper leaves in the registers
into arithmetic on the lanes. -/
local macro "lanes_norm" : tactic =>
  `(tactic| simp only [pack_add, pack_xor, pack_or, pack_shl16, pack_shl12, pack_shl8,
      pack_shl7, pack_shr16, pack_shr20, pack_shr24, pack_shr25, pack_ext, rotl16_or,
      rotl12_add, rotl8_add, rotl7_add, zdec])

/-- The first half of a round of the loop: a column round on the rows, in `v4`, `v2`, `v1`
and `v3`, and the count of rounds, in `w8`, one less. The rows are left in `v2`, `v3`, `v1`
and `v4`, the lanes of the last three rotated. -/
theorem columns_spec (s : List W32) (k : W32) (t50 t51 : Word) (fn fz fc fv : Bool) :
    Triple chacha20_block_vec.program
      (Atoms.interp [.pc 0x10010#64,
        .reg (vlo 4) (rowLo s 0), .reg (vhi 4) (rowHi s 0),
        .reg (vlo 2) (rowLo s 1), .reg (vhi 2) (rowHi s 1),
        .reg (vlo 1) (rowLo s 2), .reg (vhi 1) (rowHi s 2),
        .reg (vlo 3) (rowLo s 3), .reg (vhi 3) (rowHi s 3),
        .reg (vlo 5) t50, .reg (vhi 5) t51, .reg x8 (k.zeroExtend 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc 0x1005c#64,
        .reg (vlo 2) (rowLo (shiftRows (columns s)) 0),
        .reg (vhi 2) (rowHi (shiftRows (columns s)) 0),
        .reg (vlo 3) (rowLo (shiftRows (columns s)) 1),
        .reg (vhi 3) (rowHi (shiftRows (columns s)) 1),
        .reg (vlo 1) (rowLo (shiftRows (columns s)) 2),
        .reg (vhi 1) (rowHi (shiftRows (columns s)) 2),
        .reg (vlo 4) (rowLo (shiftRows (columns s)) 3),
        .reg (vhi 4) (rowHi (shiftRows (columns s)) 3),
        .prop (regAny (vlo 5)), .prop (regAny (vhi 5)), .reg x8 ((k - 1).zeroExtend 64),
        .prop (flagAny Flags.n), .flag Flags.z (k.zeroExtend 64 == 1#64),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) := by
  simp only [rowLo, rowHi, shiftRows, columns, Nat.reduceMul, Nat.reduceAdd,
    List.getD_cons_zero, List.getD_cons_succ, ← qrCols_eq]
  name_state s
  simp only [qrCols]
  iterate 19 braid_sym_step
  lanes_norm
  braid_forget (vlo 5)
  braid_forget (vhi 5)
  braid_forget_flag 0
  braid_forget_flag 2
  braid_forget_flag 3
  braid_done

/-- The second half of a round of the loop: a column round on the rows, in `v2`, `v3`, `v1`
and `v4`. The rows are left in `v4`, `v2`, `v1` and `v3`, where they were at the head of the
loop, the lanes of the last three rotated back. -/
theorem diagonals_spec (s : List W32) (t50 t51 t60 t61 : Word) :
    Triple chacha20_block_vec.program
      (Atoms.interp [.pc 0x1005c#64,
        .reg (vlo 2) (rowLo s 0), .reg (vhi 2) (rowHi s 0),
        .reg (vlo 3) (rowLo s 1), .reg (vhi 3) (rowHi s 1),
        .reg (vlo 1) (rowLo s 2), .reg (vhi 1) (rowHi s 2),
        .reg (vlo 4) (rowLo s 3), .reg (vhi 4) (rowHi s 3),
        .reg (vlo 5) t50, .reg (vhi 5) t51, .reg (vlo 6) t60, .reg (vhi 6) t61])
      (Atoms.interp [.pc 0x100a4#64,
        .reg (vlo 4) (rowLo (unshiftRows (columns s)) 0),
        .reg (vhi 4) (rowHi (unshiftRows (columns s)) 0),
        .reg (vlo 2) (rowLo (unshiftRows (columns s)) 1),
        .reg (vhi 2) (rowHi (unshiftRows (columns s)) 1),
        .reg (vlo 1) (rowLo (unshiftRows (columns s)) 2),
        .reg (vhi 1) (rowHi (unshiftRows (columns s)) 2),
        .reg (vlo 3) (rowLo (unshiftRows (columns s)) 3),
        .reg (vhi 3) (rowHi (unshiftRows (columns s)) 3),
        .prop (regAny (vlo 5)), .prop (regAny (vhi 5)), .prop (regAny (vlo 6)),
        .prop (regAny (vhi 6))]) := by
  simp only [rowLo, rowHi, unshiftRows, columns, Nat.reduceMul, Nat.reduceAdd,
    List.getD_cons_zero, List.getD_cons_succ, ← qrDiags_eq]
  name_state s
  simp only [qrDiags]
  iterate 18 braid_sym_step
  lanes_norm
  braid_forget (vlo 5)
  braid_forget (vhi 5)
  braid_forget (vlo 6)
  braid_forget (vhi 6)
  braid_done

/-- **A round of the loop** is a double round of ChaCha20 on the rows, in `v4`, `v2`, `v1`
and `v3`, with the count of rounds, in `w8`, one less, and the zero flag set if none is
left. -/
theorem double_round_spec (s : List W32) (hs : s.length = 16) (k : W32)
    (t50 t51 t60 t61 : Word) (fn fz fc fv : Bool) :
    Triple chacha20_block_vec.program
      (Atoms.interp [.pc 0x10010#64,
        .reg (vlo 4) (rowLo s 0), .reg (vhi 4) (rowHi s 0),
        .reg (vlo 2) (rowLo s 1), .reg (vhi 2) (rowHi s 1),
        .reg (vlo 1) (rowLo s 2), .reg (vhi 1) (rowHi s 2),
        .reg (vlo 3) (rowLo s 3), .reg (vhi 3) (rowHi s 3),
        .reg (vlo 5) t50, .reg (vhi 5) t51, .reg (vlo 6) t60, .reg (vhi 6) t61,
        .reg x8 (k.zeroExtend 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc 0x100a4#64,
        .reg (vlo 4) (rowLo (inner s) 0), .reg (vhi 4) (rowHi (inner s) 0),
        .reg (vlo 2) (rowLo (inner s) 1), .reg (vhi 2) (rowHi (inner s) 1),
        .reg (vlo 1) (rowLo (inner s) 2), .reg (vhi 1) (rowHi (inner s) 2),
        .reg (vlo 3) (rowLo (inner s) 3), .reg (vhi 3) (rowHi (inner s) 3),
        .prop (regAny (vlo 5)), .prop (regAny (vhi 5)), .prop (regAny (vlo 6)),
        .prop (regAny (vhi 6)), .reg x8 ((k - 1).zeroExtend 64),
        .prop (flagAny Flags.n), .flag Flags.z (k.zeroExtend 64 == 1#64),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) := by
  rw [inner_eq_shift s hs]
  braid_call columns_spec s k t50 t51 fn fz fc fv
  braid_name_reg (vlo 5)
  braid_name_reg (vhi 5)
  braid_call diagonals_spec (shiftRows (columns s)) _ _ t60 t61
  braid_done

/-! ## The loop -/

/-- **The loop of `chacha20_block_vec`**, with `n + 1` rounds left: that many double rounds
on the rows. Proved by induction on `n`, with this specification as the invariant: a round
is `double_round_spec`, whatever the state, so the proof does not run the code again. -/
theorem rounds_spec : ∀ (n : Nat) (s : List W32) (k : W32) (t50 t51 t60 t61 : Word)
    (fn fz fc fv : Bool), s.length = 16 → k = BitVec.ofNat 32 (n + 1) → n + 1 < 2 ^ 32 →
    Triple chacha20_block_vec.program
      (Atoms.interp [.pc 0x10010#64,
        .reg (vlo 4) (rowLo s 0), .reg (vhi 4) (rowHi s 0),
        .reg (vlo 2) (rowLo s 1), .reg (vhi 2) (rowHi s 1),
        .reg (vlo 1) (rowLo s 2), .reg (vhi 1) (rowHi s 2),
        .reg (vlo 3) (rowLo s 3), .reg (vhi 3) (rowHi s 3),
        .reg (vlo 5) t50, .reg (vhi 5) t51, .reg (vlo 6) t60, .reg (vhi 6) t61,
        .reg x8 (k.zeroExtend 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc 0x100a8#64,
        .reg (vlo 4) (rowLo (innerN (n + 1) s) 0), .reg (vhi 4) (rowHi (innerN (n + 1) s) 0),
        .reg (vlo 2) (rowLo (innerN (n + 1) s) 1), .reg (vhi 2) (rowHi (innerN (n + 1) s) 1),
        .reg (vlo 1) (rowLo (innerN (n + 1) s) 2), .reg (vhi 1) (rowHi (innerN (n + 1) s) 2),
        .reg (vlo 3) (rowLo (innerN (n + 1) s) 3), .reg (vhi 3) (rowHi (innerN (n + 1) s) 3),
        .prop (regAny (vlo 5)), .prop (regAny (vhi 5)), .prop (regAny (vlo 6)),
        .prop (regAny (vhi 6)), .reg x8 0#64,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  intro n
  induction n with
  | zero =>
    intro s k t50 t51 t60 t61 fn fz fc fv hs hk _
    obtain rfl : k = 1#32 := hk
    rw [show innerN (0 + 1) s = inner s from rfl]
    braid_call double_round_spec s hs 1#32 t50 t51 t60 t61 fn fz fc fv
    braid_sym_step
    braid_forget_flag 1
    braid_done
  | succ n ih =>
    intro s k t50 t51 t60 t61 fn fz fc fv hs hk hn
    rw [show innerN (n + 1 + 1) s = innerN (n + 1) (inner s) from rfl]
    braid_call double_round_spec s hs k t50 t51 t60 t61 fn fz fc fv
    braid_sym_step
    · braid_name_reg (vlo 5)
      braid_name_reg (vhi 5)
      braid_name_reg (vlo 6)
      braid_name_reg (vhi 6)
      braid_name_flag 0
      braid_name_flag 2
      braid_name_flag 3
      braid_call ih (inner s) (k - 1) _ _ _ _ _ _ _ _ (by rw [length_inner, hs])
        (by rw [hk]; bv_omega) (by omega)
      braid_done
    · exfalso
      have : k ≠ 1#32 := by rw [hk]; bv_omega
      exact this (by bv_decide)

end Examples.ChaCha20Vec.Arm
