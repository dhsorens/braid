/-
  Examples.ChaCha20Vec.X86.Round

  The loop of `chacha20_block_vec` of `chacha20_vec.x86.S` on x86-64: ten double rounds on a
  state of sixteen words, kept as four rows in the vector registers `xmm0` to `xmm3`. A
  vector register of the model is eight 64-bit words of the symbolic state, `zmm k 0` to
  `zmm k 7`; a row is the first two, each holding two 32-bit lanes (`ChaCha20Vec.pack`), and
  the other six are zero throughout the loop, since the instructions that write a row in
  their VEX or EVEX form clear them.

  A round of the loop is 31 instructions that work on the registers alone: a column round on
  the rows, the shuffles of lanes that bring the diagonals into the columns, a column round
  again, the shuffles back, and the decrement of the count of rounds. Each half is run
  symbolically once. The lemmas of `Examples.ChaCha20Vec.Common` turn the shifts, masks and
  additions of lanes of the lowered code into arithmetic on the lanes, and what is left in
  each lane is the quarter round of the specification, `ChaCha20.quarter`, as it is
  written: the code does its additions, exclusive ors and rotations in the order of the
  specification, so no lemma about its arithmetic is needed. After each half the registers
  hold the specification's function of the state, so nothing grows from round to round, and
  the loop is an induction on the number of rounds left.

  ## Main results

  * `columns_spec`, `diagonals_spec`: the two halves of a round
  * `double_round_spec`: a round of the loop is `ChaCha20.inner`
  * `rounds_spec`: the loop, with `n + 1` rounds left, is `ChaCha20.innerN (n + 1)`
-/

module

public import Examples.ChaCha20Vec.X86.Image
public import Examples.ChaCha20Vec.Common

@[expose] public section

namespace Examples.ChaCha20Vec.X86

open Braid Examples Examples.ChaCha20 Lowering.X86 Lowering.X86.Regs

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
      pack_shl7, pack_shr16, pack_shr20, pack_shr24, pack_shr25, pack_ext_mask,
      lanes_self_mask, rotl16_or, rotl12_or', rotl8_or', rotl7_or', zdec])

/-- The first half of a round of the loop: a column round on the rows, in `xmm0` to `xmm3`,
and the shuffles that rotate the lanes of the last three. The words of the registers above
the rows are zero before and after. -/
theorem columns_spec (s : List W32) :
    Triple chacha20_block_vec.program
      (Atoms.interp [.pc 0x401020#64,
        .reg (zmm 0 0) (rowLo s 0), .reg (zmm 0 1) (rowHi s 0),
        .reg (zmm 1 0) (rowLo s 1), .reg (zmm 1 1) (rowHi s 1),
        .reg (zmm 2 0) (rowLo s 2), .reg (zmm 2 1) (rowHi s 2),
        .reg (zmm 3 0) (rowLo s 3), .reg (zmm 3 1) (rowHi s 3),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64])
      (Atoms.interp [.pc 0x401077#64,
        .reg (zmm 0 0) (rowLo (shiftRows (columns s)) 0),
        .reg (zmm 0 1) (rowHi (shiftRows (columns s)) 0),
        .reg (zmm 1 0) (rowLo (shiftRows (columns s)) 1),
        .reg (zmm 1 1) (rowHi (shiftRows (columns s)) 1),
        .reg (zmm 2 0) (rowLo (shiftRows (columns s)) 2),
        .reg (zmm 2 1) (rowHi (shiftRows (columns s)) 2),
        .reg (zmm 3 0) (rowLo (shiftRows (columns s)) 3),
        .reg (zmm 3 1) (rowHi (shiftRows (columns s)) 3),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64]) := by
  simp only [rowLo, rowHi, shiftRows, columns, Nat.reduceMul, Nat.reduceAdd,
    List.getD_cons_zero, List.getD_cons_succ]
  name_state s
  simp only [quarter]
  iterate 15 braid_sym_step
  lanes_norm
  braid_done_perm 33

/-- The second half of a round of the loop: a column round on the rotated rows, the shuffles
that rotate the lanes back, and the count of rounds, in `eax`, one less. The decrement sets
the zero flag if no round is left, does not write the carry flag, and leaves the other four
status flags with some values. -/
theorem diagonals_spec (s : List W32) (k : W32) (fp fa fz fs fo : Bool) :
    Triple chacha20_block_vec.program
      (Atoms.interp [.pc 0x401077#64,
        .reg (zmm 0 0) (rowLo s 0), .reg (zmm 0 1) (rowHi s 0),
        .reg (zmm 1 0) (rowLo s 1), .reg (zmm 1 1) (rowHi s 1),
        .reg (zmm 2 0) (rowLo s 2), .reg (zmm 2 1) (rowHi s 2),
        .reg (zmm 3 0) (rowLo s 3), .reg (zmm 3 1) (rowHi s 3),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .reg rax (k.zeroExtend 64),
        .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz, .flag Flags.sf fs,
        .flag Flags.of fo])
      (Atoms.interp [.pc 0x4010d0#64,
        .reg (zmm 0 0) (rowLo (unshiftRows (columns s)) 0),
        .reg (zmm 0 1) (rowHi (unshiftRows (columns s)) 0),
        .reg (zmm 1 0) (rowLo (unshiftRows (columns s)) 1),
        .reg (zmm 1 1) (rowHi (unshiftRows (columns s)) 1),
        .reg (zmm 2 0) (rowLo (unshiftRows (columns s)) 2),
        .reg (zmm 2 1) (rowHi (unshiftRows (columns s)) 2),
        .reg (zmm 3 0) (rowLo (unshiftRows (columns s)) 3),
        .reg (zmm 3 1) (rowHi (unshiftRows (columns s)) 3),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .reg rax ((k - 1).zeroExtend 64),
        .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .flag Flags.zf ((k - 1).zeroExtend 64 == 0#64), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) := by
  simp only [rowLo, rowHi, unshiftRows, columns, Nat.reduceMul, Nat.reduceAdd,
    List.getD_cons_zero, List.getD_cons_succ]
  name_state s
  simp only [quarter]
  iterate 16 braid_sym_step
  lanes_norm
  braid_forget_flag 1
  braid_forget_flag 4
  braid_forget_flag 5
  braid_done_perm 39

/-- **A round of the loop** is a double round of ChaCha20 on the rows, in `xmm0` to `xmm3`,
with the count of rounds, in `eax`, one less, and the zero flag set if none is left. -/
theorem double_round_spec (s : List W32) (hs : s.length = 16) (k : W32)
    (fp fa fz fs fo : Bool) :
    Triple chacha20_block_vec.program
      (Atoms.interp [.pc 0x401020#64,
        .reg (zmm 0 0) (rowLo s 0), .reg (zmm 0 1) (rowHi s 0),
        .reg (zmm 1 0) (rowLo s 1), .reg (zmm 1 1) (rowHi s 1),
        .reg (zmm 2 0) (rowLo s 2), .reg (zmm 2 1) (rowHi s 2),
        .reg (zmm 3 0) (rowLo s 3), .reg (zmm 3 1) (rowHi s 3),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .reg rax (k.zeroExtend 64),
        .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz, .flag Flags.sf fs,
        .flag Flags.of fo])
      (Atoms.interp [.pc 0x4010d0#64,
        .reg (zmm 0 0) (rowLo (inner s) 0), .reg (zmm 0 1) (rowHi (inner s) 0),
        .reg (zmm 1 0) (rowLo (inner s) 1), .reg (zmm 1 1) (rowHi (inner s) 1),
        .reg (zmm 2 0) (rowLo (inner s) 2), .reg (zmm 2 1) (rowHi (inner s) 2),
        .reg (zmm 3 0) (rowLo (inner s) 3), .reg (zmm 3 1) (rowHi (inner s) 3),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .reg rax ((k - 1).zeroExtend 64),
        .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .flag Flags.zf ((k - 1).zeroExtend 64 == 0#64), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) := by
  rw [inner_eq_shift s hs]
  braid_call columns_spec s
  braid_call diagonals_spec (shiftRows (columns s)) k fp fa fz fs fo
  braid_done_perm 39

/-! ## The loop -/

/-- **The loop of `chacha20_block_vec`**, with `n + 1` rounds left: that many double rounds
on the rows. Proved by induction on `n`, with this specification as the invariant: a round
is `double_round_spec`, whatever the state, so the proof does not run the code again. The
count of rounds is left zero, and the words of the registers above the rows zero. -/
theorem rounds_spec : ∀ (n : Nat) (s : List W32) (k : W32) (fp fa fz fs fo : Bool),
    s.length = 16 → k = BitVec.ofNat 32 (n + 1) → n + 1 < 2 ^ 32 →
    Triple chacha20_block_vec.program
      (Atoms.interp [.pc 0x401020#64,
        .reg (zmm 0 0) (rowLo s 0), .reg (zmm 0 1) (rowHi s 0),
        .reg (zmm 1 0) (rowLo s 1), .reg (zmm 1 1) (rowHi s 1),
        .reg (zmm 2 0) (rowLo s 2), .reg (zmm 2 1) (rowHi s 2),
        .reg (zmm 3 0) (rowLo s 3), .reg (zmm 3 1) (rowHi s 3),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .reg rax (k.zeroExtend 64),
        .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz, .flag Flags.sf fs,
        .flag Flags.of fo])
      (Atoms.interp [.pc 0x4010d6#64,
        .reg (zmm 0 0) (rowLo (innerN (n + 1) s) 0),
        .reg (zmm 0 1) (rowHi (innerN (n + 1) s) 0),
        .reg (zmm 1 0) (rowLo (innerN (n + 1) s) 1),
        .reg (zmm 1 1) (rowHi (innerN (n + 1) s) 1),
        .reg (zmm 2 0) (rowLo (innerN (n + 1) s) 2),
        .reg (zmm 2 1) (rowHi (innerN (n + 1) s) 2),
        .reg (zmm 3 0) (rowLo (innerN (n + 1) s) 3),
        .reg (zmm 3 1) (rowHi (innerN (n + 1) s) 3),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .reg rax 0#64,
        .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  intro n
  induction n with
  | zero =>
    intro s k fp fa fz fs fo hs hk _
    obtain rfl : k = 1#32 := hk
    rw [show innerN (0 + 1) s = inner s from rfl]
    braid_call double_round_spec s hs 1#32 fp fa fz fs fo
    braid_sym_step
    braid_forget_flag 3
    braid_done_perm 39
  | succ n ih =>
    intro s k fp fa fz fs fo hs hk hn
    rw [show innerN (n + 1 + 1) s = innerN (n + 1) (inner s) from rfl]
    braid_call double_round_spec s hs k fp fa fz fs fo
    braid_sym_step
    · braid_name_flag 1
      braid_name_flag 2
      braid_name_flag 4
      braid_name_flag 5
      braid_call ih (inner s) (k - 1) _ _ _ _ _ (by rw [length_inner, hs])
        (by rw [hk]; bv_omega) (by omega)
      braid_done_perm 39
    · exfalso
      have : k - 1 ≠ 0#32 := by rw [hk]; bv_omega
      exact this (by bv_decide)

end Examples.ChaCha20Vec.X86
