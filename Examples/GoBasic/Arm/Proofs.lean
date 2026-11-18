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

end Examples.GoBasic.Arm
