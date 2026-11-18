/-
  Examples.PyBasic.Arm.Proofs

  `basic.py` on AArch64: Python functions compiled to native code by Numba. A compiled
  function returns a status in `w0`, zero for success, and writes its result through the
  pointer it is given in `x0`. Its Python arguments start at `x2`.
-/

module

public import Examples.PyBasic.Arm.Image
public import Examples.Spec

public section

namespace Examples.PyBasic.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- `add3` writes the sum of its arguments through the result pointer, and returns zero. -/
theorem py_add3_spec (p a b c t8 t9 old r : Word) :
    Triple py_add3.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 p, .reg x2 a, .reg x3 b, .reg x4 c, .reg x8 t8,
        .reg x9 t9, .mem p 8 old true, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 0#64, .reg x2 a, .reg x3 b, .reg x4 c, .reg x8 p,
        .reg x9 (b + (a + c)), .mem p 8 (b + (a + c)) true, .reg lr r]) := by
  braid_run
  braid_done

/-- `max_u64` writes the larger of its arguments through the result pointer. It sets the
flags. -/
theorem py_max_u64_spec (p a b t8 t9 old r : Word) (fn fz fc fv : Bool) :
    Triple py_max_u64.program
      (Atoms.interp [.pc 0x10018#64, .reg x0 p, .reg x2 a, .reg x3 b, .reg x8 t8, .reg x9 t9,
        .mem p 8 old true, .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 0#64, .reg x2 a, .reg x3 b, .reg x8 p, .reg x9 (umax a b),
        .mem p 8 (umax a b) true, .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  braid_run
  braid_forget_flag 0
  braid_forget_flag 1
  braid_forget_flag 2
  braid_forget_flag 3
  refine Triple.done_eq ?_
  simp only [umax, ofBool]
  by_cases h1 : a = b <;> by_cases h2 : b.ule a <;> simp_all
  all_goals bv_decide

end Examples.PyBasic.Arm
