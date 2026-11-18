/-
  Examples.Basic.Arm.Proofs

  `basic.c` on AArch64: straight-line code and a conditional select, with `add3` down to the
  machine model. The compiler turns the loop of `sum_to` into a closed form.
-/

module

public import Examples.Basic.Arm.Image
public import Examples.Spec

public section

namespace Examples.Basic.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- `add3` returns the sum of its arguments. -/
theorem add3_spec (a b c t r : Word) :
    Triple add3.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 a, .reg x1 b, .reg x2 c, .reg x8 t, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (b + (a + c)), .reg x1 b, .reg x2 c, .reg x8 (b + a),
        .reg lr r]) := by
  braid_run
  braid_done

/-- `max_u64` returns the larger of its arguments. It sets the flags. -/
theorem max_u64_spec (a b r : Word) (fn fz fc fv : Bool) :
    Triple max_u64.program
      (Atoms.interp [.pc 0x1000c#64, .reg x0 a, .reg x1 b, .reg lr r,
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

/-- **`add3` on the machine.** A running machine whose program holds the words of `add3`,
with its code loaded and its program counter at the entry, runs to the address in the link
register with the sum of `x0`, `x1` and `x2` in `x0`. -/
theorem add3_correct (prog : Arm64.Program) (s : Arm64.State)
    (hw : prog.hasWords 0x10000#64 add3_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = s.regs.read 1#5 + (s.regs.read 0#5 + s.regs.read 2#5) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound add3_lowered
    (add3_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 2#5) (s.regs.read 8#5)
      (s.regs.read 30#5)) hw hc hrun
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, regOf, hpc])
  refine ⟨s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) hq (by braid_at)

end Examples.Basic.Arm
