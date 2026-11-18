/-
  Examples.Memory.Arm.Proofs

  `memory.c` on AArch64: loads and stores, a call with a stack frame, and a tail call. The
  specifications are those of the RISC-V proofs, with AArch64's registers.
-/

module

public import Examples.Memory.Arm.Image
public import Examples.Spec

public section

namespace Examples.Memory.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- `swap` exchanges the two words its arguments point to. -/
theorem swap_spec (p q x y t8 t9 r : Word) :
    Triple swap.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 p, .reg x1 q, .reg x8 t8, .reg x9 t9,
        .mem p 8 x true, .mem q 8 y true, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 p, .reg x1 q, .reg x8 y, .reg x9 x,
        .mem p 8 y true, .mem q 8 x true, .reg lr r]) := by
  braid_run
  braid_done

/-- `max2` returns the larger of its arguments. It sets the flags. -/
theorem max2_spec (a b r : Word) (fn fz fc fv : Bool) :
    Triple max2.program
      (Atoms.interp [.pc 0x10034#64, .reg x0 a, .reg x1 b, .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (umax a b), .reg x1 b, .reg lr r,
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

end Examples.Memory.Arm
