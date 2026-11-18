/-
  Examples.GoBasic.Arm.Proofs

  `basic.go` on AArch64, compiled by Go's own back end. Go passes arguments in `x0`, `x1`,
  `x2` and returns in `x0`, as its internal ABI says. The binary holds the whole Go runtime;
  these are the three functions of the source.
-/

module

public import Examples.GoBasic.Arm.Image
public import Examples.Spec

public section

namespace Examples.GoBasic.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- `main.Add3` returns the sum of its arguments. -/
theorem main_Add3_spec (a b c r : Word) :
    Triple main_Add3.program
      (Atoms.interp [.pc 0x84500#64, .reg x0 a, .reg x1 b, .reg x2 c, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (c + (b + a)), .reg x1 (b + a), .reg x2 c, .reg lr r]) := by
  braid_run
  braid_done

/-- `main.MaxU64` returns the larger of its arguments. -/
theorem main_MaxU64_spec (a b r : Word) (fn fz fc fv : Bool) :
    Triple main_MaxU64.program
      (Atoms.interp [.pc 0x84510#64, .reg x0 a, .reg x1 b, .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (umax a b), .reg x1 b, .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  braid_step
  braid_step
  all_goals
    braid_run
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    refine Triple.done_eq ?_
    have h : b.ult a = !a.ule b := by bv_decide
    simp [umax, h, hbr]

/-- After `cmp a, b`, the condition `gt` is the signed comparison. -/
theorem cond_gt (a b : Word) :
    BitVec.ult (ofBool (a == b))
      (ofBool (ofBool (BitVec.slt (a - b) 0#64) ==
        ofBool (BitVec.slt ((a ^^^ b) &&& (a ^^^ a - b)) 0#64))) = b.slt a := by
  simp only [ofBool]
  bv_decide

/-- The loop of `main.SumSlice`, from index `i`, with `rest` still to add. -/
theorem main_SumSlice_loop (p len r : Word) : ∀ (rest : List Word) (i acc t4 : Word)
    (fn fz fc fv : Bool), i + BitVec.ofNat 64 rest.length = len → len.toNat < 2 ^ 61 →
    i.toNat + rest.length < 2 ^ 61 →
    Triple main_SumSlice.program
      (Atoms.interp [.pc 0x8454c#64, .reg x0 p, .reg x1 len, .reg x2 i, .reg x3 acc, .reg x4 t4,
        .prop (wordsAt (p + i <<< 3#64) rest), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (wsum rest acc), .reg x1 len, .reg x2 len,
        .reg x3 (wsum rest acc), .prop (regAny x4), .prop (wordsAt (p + i <<< 3#64) rest),
        .reg lr r, .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  intro rest
  induction rest with
  | nil =>
    intro i acc t4 fn fz fc fv he hlen hi
    have hil : i = len := by simpa using he
    subst hil
    braid_step
    braid_step
    · rw [cond_gt] at hbr
      exact absurd hbr (by simp [BitVec.slt])
    · braid_run
      braid_forget 4
      braid_forget_flag 0
      braid_forget_flag 1
      braid_forget_flag 2
      braid_forget_flag 3
      simp only [wsum, List.foldl_nil]
      braid_done
  | cons x xs ih =>
    intro i acc t4 fn fz fc fv he hlen hi
    simp only [List.length_cons] at he hi
    braid_step
    braid_step
    · braid_unfold wordsAt_cons (p + i <<< 3#64) x xs
      iterate 3 braid_step
      have e : p + (i <<< 3#64 + 8#64) = p + (i + 1#64) <<< 3#64 := by bv_decide
      rw [e]
      braid_call ih (i + 1#64) (acc + x) x _ _ _ _ (by rw [← he]; bv_omega) hlen (by bv_omega)
      rw [← e]
      braid_fold wordsAt_cons (p + i <<< 3#64) x xs
      simp only [wsum, List.foldl_cons, BitVec.add_comm x acc]
      braid_done
    · exfalso
      rw [cond_gt] at hbr
      have : i.slt len = true := by
        have h1 : i < len := by rw [← he]; bv_omega
        have h2 : len < 2305843009213693952#64 := by bv_omega
        bv_decide
      simp [this] at hbr

end Examples.GoBasic.Arm
