/-
  Examples.ChaCha20.O2.RiscV.LeakRound

  What the loop of rounds of `chacha20_block` reveals on RISC-V, compiled at `-O2`
  (`docs/Leakage.md`): where the branch at its end goes, once a round, and nothing else. A
  round is 161 instructions on registers alone, additions, exclusive ors and shifts, which
  have no label; the branch compares a count that the code set to ten with zero, so it does
  not depend on the state.

  The traced triples here say nothing of what the rounds compute, which is `rounds_spec` of
  `Examples.ChaCha20.O2.RiscV.Round`: the registers of the state are any words before and
  `regAny` after, so the code is run on sixteen opaque words and the arithmetic is forgotten.

  At `-O2` a round is the instructions of `-O1` with sixteen registers renamed, 32 bytes
  lower. The statements here are those of `Examples.ChaCha20.RiscV.LeakRound` with the
  registers and the addresses of this binary, `roundsLeak` has the two addresses of this
  loop, and the proofs are those of the first, word for word.

  ## Main definitions

  * `roundsLeak`: what the loop reveals, by recursion on the rounds left after this one

  ## Main results

  * `columns_trace`, `diagonals_trace`, `double_round_trace`: a round reveals nothing
  * `rounds_trace`: the loop, with `n + 1` rounds left, reveals `roundsLeak n`
-/

module

public import Examples.ChaCha20.O2.RiscV.Round

@[expose] public section

namespace Examples.ChaCha20.O2.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64
open Examples.ChaCha20.RiscV (sdec)

/-- What the loop of rounds reveals with `n` rounds left after the one it is in: the branch
back to the head of the loop after each round but the last, and the way out after the
last. The addresses are those of the code, so this is the same list for every state. -/
def roundsLeak : Nat → Trace
  | 0 => [.jump 0x10358#64]
  | n + 1 => .jump 0x100d0#64 :: roundsLeak n

/-- Forget the sixteen registers of the state. -/
macro "rv_forget_state" : tactic =>
  `(tactic| (braid_forget 8; braid_forget 9; braid_forget 19; braid_forget 18
             braid_forget 31; braid_forget 28; braid_forget 29; braid_forget 30
             braid_forget 7; braid_forget 16; braid_forget 15; braid_forget 14
             braid_forget 17; braid_forget 5; braid_forget 6; braid_forget 13))

/-- Name what the sixteen registers of the state hold. -/
macro "rv_name_state" : tactic =>
  `(tactic| (braid_name_reg 8; braid_name_reg 9; braid_name_reg 19; braid_name_reg 18
             braid_name_reg 31; braid_name_reg 28; braid_name_reg 29; braid_name_reg 30
             braid_name_reg 7; braid_name_reg 16; braid_name_reg 15; braid_name_reg 14
             braid_name_reg 17; braid_name_reg 5; braid_name_reg 6; braid_name_reg 13))

/-- The first half of a round of the loop reveals nothing: it leaves the trace as it was,
with the count of rounds, in `a2`, one less. -/
theorem columns_trace (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word)
    (k : W32) (t20 : Word) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp [.pc 0x100d0#64,
        .reg s0 v0, .reg s1 v1, .reg s3 v2, .reg s2 v3, .reg t6 v4, .reg t3 v5, .reg t4 v6,
        .reg t5 v7, .reg t2 v8, .reg a6 v9, .reg a5 v10, .reg a4 v11, .reg a7 v12,
        .reg t0 v13, .reg t1 v14, .reg a3 v15, .reg a2 (BitVec.signExtend 64 k), .reg s4 t20]) t
      (Atoms.interp [.pc 0x10214#64,
        .prop (regAny s0), .prop (regAny s1), .prop (regAny s3), .prop (regAny s2),
        .prop (regAny t6), .prop (regAny t3), .prop (regAny t4), .prop (regAny t5),
        .prop (regAny t2), .prop (regAny a6), .prop (regAny a5), .prop (regAny a4),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .prop (regAny a3),
        .reg a2 (BitVec.signExtend 64 (k - 1)), .prop (regAny s4)]) t := by
  iterate 81 braid_sym_step
  simp only [sdec]
  rv_forget_state
  braid_forget 20
  braid_done

/-- The second half of a round of the loop reveals nothing. -/
theorem diagonals_trace (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word)
    (t20 : Word) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp [.pc 0x10214#64,
        .reg s0 v0, .reg s1 v1, .reg s3 v2, .reg s2 v3, .reg t6 v4, .reg t3 v5, .reg t4 v6,
        .reg t5 v7, .reg t2 v8, .reg a6 v9, .reg a5 v10, .reg a4 v11, .reg a7 v12,
        .reg t0 v13, .reg t1 v14, .reg a3 v15, .reg s4 t20]) t
      (Atoms.interp [.pc 0x10354#64,
        .prop (regAny s0), .prop (regAny s1), .prop (regAny s3), .prop (regAny s2),
        .prop (regAny t6), .prop (regAny t3), .prop (regAny t4), .prop (regAny t5),
        .prop (regAny t2), .prop (regAny a6), .prop (regAny a5), .prop (regAny a4),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .prop (regAny a3),
        .prop (regAny s4)]) t := by
  iterate 80 braid_sym_step
  rv_forget_state
  braid_forget 20
  braid_done

/-- **A round of the loop reveals nothing**, up to the branch at its end. -/
theorem double_round_trace (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word)
    (k : W32) (t20 : Word) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp [.pc 0x100d0#64,
        .reg s0 v0, .reg s1 v1, .reg s3 v2, .reg s2 v3, .reg t6 v4, .reg t3 v5, .reg t4 v6,
        .reg t5 v7, .reg t2 v8, .reg a6 v9, .reg a5 v10, .reg a4 v11, .reg a7 v12,
        .reg t0 v13, .reg t1 v14, .reg a3 v15, .reg a2 (BitVec.signExtend 64 k), .reg s4 t20]) t
      (Atoms.interp [.pc 0x10354#64,
        .prop (regAny s0), .prop (regAny s1), .prop (regAny s3), .prop (regAny s2),
        .prop (regAny t6), .prop (regAny t3), .prop (regAny t4), .prop (regAny t5),
        .prop (regAny t2), .prop (regAny a6), .prop (regAny a5), .prop (regAny a4),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .prop (regAny a3),
        .reg a2 (BitVec.signExtend 64 (k - 1)), .prop (regAny s4)]) t := by
  braid_call columns_trace v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 k t20 t
  rv_name_state
  braid_name_reg 20
  braid_call diagonals_trace _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ t
  braid_done

/-- **What the loop of `chacha20_block` reveals**, with `n + 1` rounds left: `roundsLeak n`,
whatever the registers of the state hold. Proved by induction on `n`, as `rounds_spec` is. -/
theorem rounds_trace : ∀ (n : Nat)
    (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word) (k : W32) (t20 : Word)
    (t : Trace), k = BitVec.ofNat 32 (n + 1) → n + 1 < 2 ^ 32 →
    TripleT chacha20_block.program
      (Atoms.interp [.pc 0x100d0#64,
        .reg s0 v0, .reg s1 v1, .reg s3 v2, .reg s2 v3, .reg t6 v4, .reg t3 v5, .reg t4 v6,
        .reg t5 v7, .reg t2 v8, .reg a6 v9, .reg a5 v10, .reg a4 v11, .reg a7 v12,
        .reg t0 v13, .reg t1 v14, .reg a3 v15, .reg a2 (BitVec.signExtend 64 k), .reg s4 t20]) t
      (Atoms.interp [.pc 0x10358#64,
        .prop (regAny s0), .prop (regAny s1), .prop (regAny s3), .prop (regAny s2),
        .prop (regAny t6), .prop (regAny t3), .prop (regAny t4), .prop (regAny t5),
        .prop (regAny t2), .prop (regAny a6), .prop (regAny a5), .prop (regAny a4),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .prop (regAny a3),
        .reg a2 0#64, .prop (regAny s4)]) (t ++ roundsLeak n) := by
  intro n
  induction n with
  | zero =>
    intro v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 k t20 t hk _
    obtain rfl : k = 1#32 := hk
    braid_call double_round_trace v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 1#32
      t20 t
    braid_sym_step
    · exact absurd (by decide) hbr
    · rw [hbr]
      braid_done
  | succ n ih =>
    intro v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 k t20 t hk hn
    braid_call double_round_trace v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 k t20 t
    braid_sym_step
    · rv_name_state
      braid_name_reg 20
      braid_call ih _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (k - 1) _ _ (by rw [hk]; bv_omega)
        (by omega)
      braid_done
    · exfalso
      have : k ≠ 1#32 := by rw [hk]; bv_omega
      exact this (by bv_decide)

end Examples.ChaCha20.O2.RiscV
