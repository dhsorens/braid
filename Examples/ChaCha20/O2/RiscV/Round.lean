/-
  Examples.ChaCha20.O2.RiscV.Round

  The loop of `chacha20_block` of `chacha20.c` on RISC-V, compiled at `-O2`: ten double
  rounds on a state of sixteen words, which the compiler keeps in sixteen registers.

  At `-O2` a round of the loop is the 161 instructions of `-O1` with the registers renamed
  and at other addresses: the sixteen words of the state are in `s0 s1 s3 s2`, `t6 t3 t4 t5`,
  `t2 a6 a5 a4`, `a7 t0 t1 a3`, where at `-O1` they were in `s0 s2 s3 s1`, `t6 t0 t1 t3`,
  `a5 a6 a3 a4`, `t2 t4 t5 a7`. The functions `colsW`, `diagsW` and `innerW` on sixteen
  64-bit words say what the instructions compute from the words by position, not by
  register, so they and every lemma about them are those of `Examples.ChaCha20.RiscV.Round`,
  imported and not repeated. The four triples here are stated with the registers and the
  addresses of this binary; their proofs are those of the first, word for word.

  ## Main results

  * `columns_spec`, `diagonals_spec`: the two halves of a round
  * `double_round_spec`: a round of the loop is `innerW`
  * `rounds_spec`: the loop, with `n + 1` rounds left, is `innerNW (n + 1)`
-/

module

public import Examples.ChaCha20.O2.RiscV.QuarterRound
public import Examples.ChaCha20.RiscV.Round
import Braid.BV

public section

namespace Examples.ChaCha20.O2.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64
open Examples.ChaCha20.RiscV (colsW diagsW colsL diagsL innerW innerNW sdec)

/-- Name the sixteen words of a state. -/
local macro "name_state " s:term : tactic =>
  `(tactic| generalize List.getD $s 0 0 = a0, List.getD $s 1 0 = a1, List.getD $s 2 0 = a2,
      List.getD $s 3 0 = a3, List.getD $s 4 0 = a4, List.getD $s 5 0 = a5,
      List.getD $s 6 0 = a6, List.getD $s 7 0 = a7, List.getD $s 8 0 = a8,
      List.getD $s 9 0 = a9, List.getD $s 10 0 = a10, List.getD $s 11 0 = a11,
      List.getD $s 12 0 = a12, List.getD $s 13 0 = a13, List.getD $s 14 0 = a14,
      List.getD $s 15 0 = a15)
/-! ## A round of the loop -/

/-- The first half of a round of the loop: `colsL` of the registers of the state, and the
count of rounds, in `a2`, one less. -/
theorem columns_spec (vs : List Word) (k : W32) (t20 : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x100d0#64,
        .reg s0 (vs.getD 0 0), .reg s1 (vs.getD 1 0), .reg s3 (vs.getD 2 0), .reg s2 (vs.getD 3 0),
        .reg t6 (vs.getD 4 0), .reg t3 (vs.getD 5 0), .reg t4 (vs.getD 6 0), .reg t5 (vs.getD 7 0),
        .reg t2 (vs.getD 8 0), .reg a6 (vs.getD 9 0), .reg a5 (vs.getD 10 0),
        .reg a4 (vs.getD 11 0), .reg a7 (vs.getD 12 0), .reg t0 (vs.getD 13 0),
        .reg t1 (vs.getD 14 0), .reg a3 (vs.getD 15 0),
        .reg a2 (BitVec.signExtend 64 k), .reg s4 t20])
      (Atoms.interp [.pc 0x10214#64,
        .reg s0 ((colsL vs).getD 0 0), .reg s1 ((colsL vs).getD 1 0),
        .reg s3 ((colsL vs).getD 2 0), .reg s2 ((colsL vs).getD 3 0),
        .reg t6 ((colsL vs).getD 4 0), .reg t3 ((colsL vs).getD 5 0),
        .reg t4 ((colsL vs).getD 6 0), .reg t5 ((colsL vs).getD 7 0),
        .reg t2 ((colsL vs).getD 8 0), .reg a6 ((colsL vs).getD 9 0),
        .reg a5 ((colsL vs).getD 10 0), .reg a4 ((colsL vs).getD 11 0),
        .reg a7 ((colsL vs).getD 12 0), .reg t0 ((colsL vs).getD 13 0),
        .reg t1 ((colsL vs).getD 14 0), .reg a3 ((colsL vs).getD 15 0),
        .reg a2 (BitVec.signExtend 64 (k - 1)), .prop (regAny s4)]) := by
  simp only [colsL]
  name_state vs
  simp only [colsW, List.getD_cons_zero, List.getD_cons_succ]
  iterate 81 braid_sym_step
  simp only [sdec]
  braid_forget 20
  braid_done

/-- The second half of a round of the loop: `diagsL` of the registers of the state. -/
theorem diagonals_spec (vs : List Word) (t20 : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x10214#64,
        .reg s0 (vs.getD 0 0), .reg s1 (vs.getD 1 0), .reg s3 (vs.getD 2 0), .reg s2 (vs.getD 3 0),
        .reg t6 (vs.getD 4 0), .reg t3 (vs.getD 5 0), .reg t4 (vs.getD 6 0), .reg t5 (vs.getD 7 0),
        .reg t2 (vs.getD 8 0), .reg a6 (vs.getD 9 0), .reg a5 (vs.getD 10 0),
        .reg a4 (vs.getD 11 0), .reg a7 (vs.getD 12 0), .reg t0 (vs.getD 13 0),
        .reg t1 (vs.getD 14 0), .reg a3 (vs.getD 15 0),
        .reg s4 t20])
      (Atoms.interp [.pc 0x10354#64,
        .reg s0 ((diagsL vs).getD 0 0), .reg s1 ((diagsL vs).getD 1 0),
        .reg s3 ((diagsL vs).getD 2 0), .reg s2 ((diagsL vs).getD 3 0),
        .reg t6 ((diagsL vs).getD 4 0), .reg t3 ((diagsL vs).getD 5 0),
        .reg t4 ((diagsL vs).getD 6 0), .reg t5 ((diagsL vs).getD 7 0),
        .reg t2 ((diagsL vs).getD 8 0), .reg a6 ((diagsL vs).getD 9 0),
        .reg a5 ((diagsL vs).getD 10 0), .reg a4 ((diagsL vs).getD 11 0),
        .reg a7 ((diagsL vs).getD 12 0), .reg t0 ((diagsL vs).getD 13 0),
        .reg t1 ((diagsL vs).getD 14 0), .reg a3 ((diagsL vs).getD 15 0),
        .prop (regAny s4)]) := by
  simp only [diagsL]
  name_state vs
  simp only [diagsW, List.getD_cons_zero, List.getD_cons_succ]
  iterate 80 braid_sym_step
  braid_forget 20
  braid_done

/-- **A round of the loop** is `innerW` of the registers of the state, with the count of
rounds, in `a2`, one less. -/
theorem double_round_spec (vs : List Word) (k : W32) (t20 : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x100d0#64,
        .reg s0 (vs.getD 0 0), .reg s1 (vs.getD 1 0), .reg s3 (vs.getD 2 0), .reg s2 (vs.getD 3 0),
        .reg t6 (vs.getD 4 0), .reg t3 (vs.getD 5 0), .reg t4 (vs.getD 6 0), .reg t5 (vs.getD 7 0),
        .reg t2 (vs.getD 8 0), .reg a6 (vs.getD 9 0), .reg a5 (vs.getD 10 0),
        .reg a4 (vs.getD 11 0), .reg a7 (vs.getD 12 0), .reg t0 (vs.getD 13 0),
        .reg t1 (vs.getD 14 0), .reg a3 (vs.getD 15 0),
        .reg a2 (BitVec.signExtend 64 k), .reg s4 t20])
      (Atoms.interp [.pc 0x10354#64,
        .reg s0 ((innerW vs).getD 0 0), .reg s1 ((innerW vs).getD 1 0),
        .reg s3 ((innerW vs).getD 2 0), .reg s2 ((innerW vs).getD 3 0),
        .reg t6 ((innerW vs).getD 4 0), .reg t3 ((innerW vs).getD 5 0),
        .reg t4 ((innerW vs).getD 6 0), .reg t5 ((innerW vs).getD 7 0),
        .reg t2 ((innerW vs).getD 8 0), .reg a6 ((innerW vs).getD 9 0),
        .reg a5 ((innerW vs).getD 10 0), .reg a4 ((innerW vs).getD 11 0),
        .reg a7 ((innerW vs).getD 12 0), .reg t0 ((innerW vs).getD 13 0),
        .reg t1 ((innerW vs).getD 14 0), .reg a3 ((innerW vs).getD 15 0),
        .reg a2 (BitVec.signExtend 64 (k - 1)), .prop (regAny s4)]) := by
  rw [innerW]
  braid_call columns_spec vs k t20
  braid_name_reg 20
  braid_call diagonals_spec (colsL vs) _
  braid_done

/-! ## The loop -/

/-- **The loop of `chacha20_block`**, with `n + 1` rounds left: that many rounds on the
registers of the state. Proved by induction on `n`, with this specification as the
invariant: a round is `double_round_spec`, whatever the registers hold, so the proof does
not run the code again. -/
theorem rounds_spec : ∀ (n : Nat) (vs : List Word) (k : W32) (t20 : Word),
    k = BitVec.ofNat 32 (n + 1) → n + 1 < 2 ^ 32 →
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x100d0#64,
        .reg s0 (vs.getD 0 0), .reg s1 (vs.getD 1 0), .reg s3 (vs.getD 2 0), .reg s2 (vs.getD 3 0),
        .reg t6 (vs.getD 4 0), .reg t3 (vs.getD 5 0), .reg t4 (vs.getD 6 0), .reg t5 (vs.getD 7 0),
        .reg t2 (vs.getD 8 0), .reg a6 (vs.getD 9 0), .reg a5 (vs.getD 10 0),
        .reg a4 (vs.getD 11 0), .reg a7 (vs.getD 12 0), .reg t0 (vs.getD 13 0),
        .reg t1 (vs.getD 14 0), .reg a3 (vs.getD 15 0),
        .reg a2 (BitVec.signExtend 64 k), .reg s4 t20])
      (Atoms.interp [.pc 0x10358#64,
        .reg s0 ((innerNW (n + 1) vs).getD 0 0), .reg s1 ((innerNW (n + 1) vs).getD 1 0),
        .reg s3 ((innerNW (n + 1) vs).getD 2 0), .reg s2 ((innerNW (n + 1) vs).getD 3 0),
        .reg t6 ((innerNW (n + 1) vs).getD 4 0), .reg t3 ((innerNW (n + 1) vs).getD 5 0),
        .reg t4 ((innerNW (n + 1) vs).getD 6 0), .reg t5 ((innerNW (n + 1) vs).getD 7 0),
        .reg t2 ((innerNW (n + 1) vs).getD 8 0), .reg a6 ((innerNW (n + 1) vs).getD 9 0),
        .reg a5 ((innerNW (n + 1) vs).getD 10 0), .reg a4 ((innerNW (n + 1) vs).getD 11 0),
        .reg a7 ((innerNW (n + 1) vs).getD 12 0), .reg t0 ((innerNW (n + 1) vs).getD 13 0),
        .reg t1 ((innerNW (n + 1) vs).getD 14 0), .reg a3 ((innerNW (n + 1) vs).getD 15 0),
        .reg a2 0#64, .prop (regAny s4)]) := by
  intro n
  induction n with
  | zero =>
    intro vs k t20 hk _
    obtain rfl : k = 1#32 := hk
    rw [show innerNW (0 + 1) vs = innerW vs from rfl]
    braid_call double_round_spec vs 1#32 t20
    braid_sym_step
    · exact absurd (by decide) hbr
    · rw [hbr]
      braid_done
  | succ n ih =>
    intro vs k t20 hk hn
    rw [show innerNW (n + 1 + 1) vs = innerNW (n + 1) (innerW vs) from rfl]
    braid_call double_round_spec vs k t20
    braid_sym_step
    · braid_name_reg 20
      braid_call ih (innerW vs) (k - 1) _ (by rw [hk]; bv_omega) (by omega)
      braid_done
    · exfalso
      have : k ≠ 1#32 := by rw [hk]; bv_omega
      exact this (by bv_auto)
end Examples.ChaCha20.O2.RiscV
