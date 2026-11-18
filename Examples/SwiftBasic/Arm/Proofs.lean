/-
  Examples.SwiftBasic.Arm.Proofs

  `basic.swift` on AArch64: wrapping arithmetic, a conditional select, and Euclid's
  algorithm.
-/

module

public import Examples.SwiftBasic.Arm.Image
public import Examples.Spec

public section

namespace Examples.SwiftBasic.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- `swift_add3` returns the sum of its arguments. -/
theorem swift_add3_spec (a b c t r : Word) :
    Triple swift_add3.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 a, .reg x1 b, .reg x2 c, .reg x8 t, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (b + (a + c)), .reg x1 b, .reg x2 c, .reg x8 (b + a),
        .reg lr r]) := by
  braid_run
  braid_done

/-- `swift_min` returns the smaller of its arguments. It sets the flags. -/
theorem swift_min_spec (a b r : Word) (fn fz fc fv : Bool) :
    Triple swift_min.program
      (Atoms.interp [.pc 0x10058#64, .reg x0 a, .reg x1 b, .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (umin a b), .reg x1 b, .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  braid_run
  braid_forget_flag 0
  braid_forget_flag 1
  braid_forget_flag 2
  braid_forget_flag 3
  refine Triple.done_eq ?_
  simp only [umin]
  by_cases h1 : a.ult b <;> by_cases h2 : b.ule a <;> simp_all
  all_goals bv_decide

/-- The loop of `swift_gcd`, entered with a divisor that is not zero. -/
theorem swift_gcd_loop (r : Word) (k : Nat) : ∀ a b t8 t9 : Word, b.toNat = k → b ≠ 0#64 →
    Triple swift_gcd.program
      (Atoms.interp [.pc 0x1001c#64, .reg x0 a, .reg x1 b, .reg x8 t8, .reg x9 t9, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (wgcd a b), .reg x1 0#64, .reg x8 (wgcd a b),
        .prop (regAny x9), .reg lr r]) := by
  induction k using Nat.strongRecOn with
  | ind k ih =>
    intro a b t8 t9 hk hb
    iterate 4 braid_step
    simp only [sub_udiv_mul]
    braid_step
    · refine (ih _ ?_ b (a % b) _ _ rfl hbr).cast rfl (by simp [wgcd_rec a b])
      rw [← hk, BitVec.toNat_umod]
      exact Nat.mod_lt _ (Nat.pos_of_ne_zero fun h => hb (BitVec.eq_of_toNat_eq h))
    · braid_run
      braid_forget 9
      exact Triple.done_eq (by simp [wgcd_rec a b, hbr, wgcd_zero])

/-- `swift_gcd` returns the greatest common divisor of its arguments. -/
theorem swift_gcd_spec (a b t8 t9 r : Word) :
    Triple swift_gcd.program
      (Atoms.interp [.pc 0x10018#64, .reg x0 a, .reg x1 b, .reg x8 t8, .reg x9 t9, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (wgcd a b), .prop (regAny x1), .prop (regAny x8),
        .prop (regAny x9), .reg lr r]) := by
  braid_step
  · braid_call swift_gcd_loop r _ a b t8 t9 rfl hbr
    braid_forget 1
    braid_forget 8
    braid_done
  · subst hbr
    braid_run
    braid_forget 1
    braid_forget 8
    braid_forget 9
    exact Triple.done_eq (by simp [wgcd_zero])

end Examples.SwiftBasic.Arm
