/-
  Examples.ChaCha20.O2.Arm.LeakRound

  What the loop of rounds of `chacha20_block` reveals on AArch64, compiled at `-O2`
  (`docs/Leakage.md`): where the branch at its end goes, once a round, and nothing else. A
  round is 96 instructions on registers alone, additions, exclusive ors and rotations, which
  have no label; the branch tests a flag that the decrement of a count sets, and the code set
  the count to ten, so it does not depend on the state.

  The traced triples here say nothing of what the rounds compute, which is `rounds_spec` of
  `Examples.ChaCha20.O2.Arm.Round`: the registers of the state are any words before and
  `regAny` after, so the code is run on opaque words and the arithmetic is forgotten.

  At `-O2` a round is not the instructions of `-O1` under a renaming: they come in another
  order and use one more register, `x23`. Nothing of that shows here, where a round is run on
  opaque words: the statements are those of `Examples.ChaCha20.Arm.LeakRound` with the
  registers and the addresses of this binary and `x23` beside `x19` to `x22`, `roundsLeak`
  has the two addresses of this loop, and the proofs are those of the first with one more
  register to name and to forget.

  ## Main definitions

  * `roundsLeak`: what the loop reveals, by recursion on the rounds left after this one

  ## Main results

  * `columns_trace`, `diagonals_trace`, `double_round_trace`: a round reveals nothing
  * `rounds_trace`: the loop, with `n + 1` rounds left, reveals `roundsLeak n`
-/

module

public import Examples.ChaCha20.O2.Arm.Round

@[expose] public section

namespace Examples.ChaCha20.O2.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- What the loop of rounds reveals with `n` rounds left after the one it is in: the branch
back to the head of the loop after each round but the last, and the way out after the
last. The addresses are those of the code, so this is the same list for every state. -/
def roundsLeak : Nat → Trace
  | 0 => [.jump 0x101fc#64]
  | n + 1 => .jump 0x10074#64 :: roundsLeak n

/-- Forget the sixteen registers the state is in at the head of the loop. -/
macro "arm_forget_state" : tactic =>
  `(tactic| (braid_forget 7; braid_forget 6; braid_forget 5; braid_forget 17
             braid_forget 4; braid_forget 3; braid_forget 2; braid_forget 16
             braid_forget 15; braid_forget 18; braid_forget 11; braid_forget 10
             braid_forget 14; braid_forget 13; braid_forget 12; braid_forget 9))

/-- Forget the five registers the loop uses beside those of the state, `x19` to `x23`. -/
macro "arm_forget_saved" : tactic =>
  `(tactic| (braid_forget 19; braid_forget 20; braid_forget 21; braid_forget 22
             braid_forget 23))

/-- Name what the sixteen registers of the state hold. -/
macro "arm_name_state" : tactic =>
  `(tactic| (braid_name_reg 7; braid_name_reg 6; braid_name_reg 5; braid_name_reg 17
             braid_name_reg 4; braid_name_reg 3; braid_name_reg 2; braid_name_reg 16
             braid_name_reg 15; braid_name_reg 18; braid_name_reg 11; braid_name_reg 10
             braid_name_reg 14; braid_name_reg 13; braid_name_reg 12; braid_name_reg 9))

/-- Name what `x19` to `x23` hold. -/
macro "arm_name_saved" : tactic =>
  `(tactic| (braid_name_reg 19; braid_name_reg 20; braid_name_reg 21; braid_name_reg 22
             braid_name_reg 23))

/-- The first half of a round of the loop reveals nothing: it leaves the trace as it was,
with the count of rounds, in `w8`, one less, and the zero flag set if none is left. -/
theorem columns_trace (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word)
    (k : W32) (t19 t20 t21 t22 t23 : Word) (fn fz fc fv : Bool) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp [.pc 0x10074#64,
        .reg x7 v0, .reg x6 v1, .reg x5 v2, .reg x17 v3, .reg x4 v4, .reg x3 v5,
        .reg x2 v6, .reg x16 v7, .reg x15 v8, .reg x18 v9, .reg x11 v10, .reg x10 v11,
        .reg x14 v12, .reg x13 v13, .reg x12 v14, .reg x9 v15,
        .reg x19 t19, .reg x20 t20, .reg x21 t21, .reg x22 t22, .reg x23 t23,
        .reg x8 (k.zeroExtend 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]) t
      (Atoms.interp [.pc 0x10138#64,
        .prop (regAny x7), .prop (regAny x6), .prop (regAny x5), .prop (regAny x17),
        .prop (regAny x4), .prop (regAny x3), .prop (regAny x2), .prop (regAny x16),
        .prop (regAny x15), .prop (regAny x18), .prop (regAny x11), .prop (regAny x10),
        .prop (regAny x14), .prop (regAny x13), .prop (regAny x12), .prop (regAny x9),
        .prop (regAny x19), .prop (regAny x20), .prop (regAny x21), .prop (regAny x22),
        .prop (regAny x23),
        .reg x8 ((k - 1).zeroExtend 64),
        .prop (flagAny Flags.n), .flag Flags.z (k.zeroExtend 64 == 1#64),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) t := by
  iterate 49 braid_sym_step
  simp only [zdec]
  arm_forget_state
  arm_forget_saved
  braid_forget_flag 0
  braid_forget_flag 2
  braid_forget_flag 3
  braid_done

/-- The second half of a round of the loop reveals nothing. -/
theorem diagonals_trace (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word)
    (t19 t20 t21 t22 t23 : Word) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp [.pc 0x10138#64,
        .reg x7 v0, .reg x6 v1, .reg x5 v2, .reg x17 v3, .reg x4 v4, .reg x3 v5,
        .reg x2 v6, .reg x16 v7, .reg x15 v8, .reg x18 v9, .reg x11 v10, .reg x10 v11,
        .reg x14 v12, .reg x13 v13, .reg x12 v14, .reg x9 v15,
        .reg x19 t19, .reg x20 t20, .reg x21 t21, .reg x22 t22, .reg x23 t23]) t
      (Atoms.interp [.pc 0x101f8#64,
        .prop (regAny x7), .prop (regAny x6), .prop (regAny x5), .prop (regAny x17),
        .prop (regAny x4), .prop (regAny x3), .prop (regAny x2), .prop (regAny x16),
        .prop (regAny x15), .prop (regAny x18), .prop (regAny x11), .prop (regAny x10),
        .prop (regAny x14), .prop (regAny x13), .prop (regAny x12), .prop (regAny x9),
        .prop (regAny x19), .prop (regAny x20), .prop (regAny x21), .prop (regAny x22),
        .prop (regAny x23)]) t := by
  iterate 48 braid_sym_step
  arm_forget_state
  arm_forget_saved
  braid_done

/-- **A round of the loop reveals nothing**, up to the branch at its end. -/
theorem double_round_trace (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word)
    (k : W32) (t19 t20 t21 t22 t23 : Word) (fn fz fc fv : Bool) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp [.pc 0x10074#64,
        .reg x7 v0, .reg x6 v1, .reg x5 v2, .reg x17 v3, .reg x4 v4, .reg x3 v5,
        .reg x2 v6, .reg x16 v7, .reg x15 v8, .reg x18 v9, .reg x11 v10, .reg x10 v11,
        .reg x14 v12, .reg x13 v13, .reg x12 v14, .reg x9 v15,
        .reg x19 t19, .reg x20 t20, .reg x21 t21, .reg x22 t22, .reg x23 t23,
        .reg x8 (k.zeroExtend 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]) t
      (Atoms.interp [.pc 0x101f8#64,
        .prop (regAny x7), .prop (regAny x6), .prop (regAny x5), .prop (regAny x17),
        .prop (regAny x4), .prop (regAny x3), .prop (regAny x2), .prop (regAny x16),
        .prop (regAny x15), .prop (regAny x18), .prop (regAny x11), .prop (regAny x10),
        .prop (regAny x14), .prop (regAny x13), .prop (regAny x12), .prop (regAny x9),
        .prop (regAny x19), .prop (regAny x20), .prop (regAny x21), .prop (regAny x22),
        .prop (regAny x23),
        .reg x8 ((k - 1).zeroExtend 64),
        .prop (flagAny Flags.n), .flag Flags.z (k.zeroExtend 64 == 1#64),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) t := by
  braid_call columns_trace v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 k t19 t20
    t21 t22 t23 fn fz fc fv t
  arm_name_state
  arm_name_saved
  braid_call diagonals_trace _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ t
  braid_done

/-- **What the loop of `chacha20_block` reveals**, with `n + 1` rounds left: `roundsLeak n`,
whatever the registers of the state hold. Proved by induction on `n`, as `rounds_spec` is. -/
theorem rounds_trace : ∀ (n : Nat)
    (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word) (k : W32)
    (t19 t20 t21 t22 t23 : Word) (fn fz fc fv : Bool) (t : Trace),
    k = BitVec.ofNat 32 (n + 1) → n + 1 < 2 ^ 32 →
    TripleT chacha20_block.program
      (Atoms.interp [.pc 0x10074#64,
        .reg x7 v0, .reg x6 v1, .reg x5 v2, .reg x17 v3, .reg x4 v4, .reg x3 v5,
        .reg x2 v6, .reg x16 v7, .reg x15 v8, .reg x18 v9, .reg x11 v10, .reg x10 v11,
        .reg x14 v12, .reg x13 v13, .reg x12 v14, .reg x9 v15,
        .reg x19 t19, .reg x20 t20, .reg x21 t21, .reg x22 t22, .reg x23 t23,
        .reg x8 (k.zeroExtend 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]) t
      (Atoms.interp [.pc 0x101fc#64,
        .prop (regAny x7), .prop (regAny x6), .prop (regAny x5), .prop (regAny x17),
        .prop (regAny x4), .prop (regAny x3), .prop (regAny x2), .prop (regAny x16),
        .prop (regAny x15), .prop (regAny x18), .prop (regAny x11), .prop (regAny x10),
        .prop (regAny x14), .prop (regAny x13), .prop (regAny x12), .prop (regAny x9),
        .prop (regAny x19), .prop (regAny x20), .prop (regAny x21), .prop (regAny x22),
        .prop (regAny x23),
        .reg x8 0#64,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) (t ++ roundsLeak n) := by
  intro n
  induction n with
  | zero =>
    intro v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 k t19 t20 t21 t22 t23 fn fz
      fc fv t hk _
    obtain rfl : k = 1#32 := hk
    braid_call double_round_trace v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 1#32
      t19 t20 t21 t22 t23 fn fz fc fv t
    braid_sym_step
    braid_forget_flag 1
    braid_done
  | succ n ih =>
    intro v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 k t19 t20 t21 t22 t23 fn fz
      fc fv t hk hn
    braid_call double_round_trace v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 k
      t19 t20 t21 t22 t23 fn fz fc fv t
    braid_sym_step
    · arm_name_state
      arm_name_saved
      braid_name_flag 0
      braid_name_flag 2
      braid_name_flag 3
      braid_call ih _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (k - 1) _ _ _ _ _ _ _ _ _ _
        (by rw [hk]; bv_omega) (by omega)
      braid_done
    · exfalso
      have : k ≠ 1#32 := by rw [hk]; bv_omega
      exact this (by bv_decide)

end Examples.ChaCha20.O2.Arm
