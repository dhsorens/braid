/-
  Examples.Basic.Arm.Proofs

  `basic.c` on AArch64: straight-line code and a conditional select, each down to the machine
  model. The compiler turns the loop of `sum_to` into a closed form.
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

/-- `sum_to` returns `1 + 2 + ... + n`. The compiler has replaced the loop of the source by a
closed form with a 128-bit product. -/
theorem sum_to_spec (n t8 t9 t10 r : Word) :
    Triple sum_to.program
      (Atoms.interp [.pc 0x10018#64, .reg x0 n, .reg x8 t8, .reg x9 t9, .reg x10 t10,
        .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (tri n), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .reg lr r]) := by
  braid_step
  · braid_run
    braid_forget 8
    braid_forget 9
    braid_forget 10
    refine Triple.done_eq ?_
    have a1 : n + 18446744073709551615#64 = n - 1#64 := by bv_decide
    have a2 : n + 18446744073709551614#64 = n - 2#64 := by bv_decide
    have hw : BitVec.setWidth 128 (n - 1#64) * BitVec.setWidth 128 (n - 2#64) =
        wide (n - 1#64) (n - 2#64) := rfl
    rw [a1, a2, hw, ← tri_closed n hbr, ← wide_lo (n - 1#64) (n - 2#64)]
    generalize wide (n - 1#64) (n - 2#64) = X
    simp only [List.cons.injEq, Atom.reg.injEq, true_and, and_true]
    bv_decide
  · subst hbr
    braid_run
    braid_forget 8
    braid_forget 9
    braid_forget 10
    exact Triple.done_eq (by rw [tri_zero])

/-! ## On the machine -/

/-- **`max_u64` on the machine.** A running machine whose program holds the words of
`max_u64`, with its code loaded and its program counter at the entry, runs to the address in
the link register with the larger of `x0` and `x1`, as unsigned numbers, in `x0`. -/
theorem max_u64_correct (prog : Arm64.Program) (s : Arm64.State)
    (hw : prog.hasWords 0x1000c#64 max_u64_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x1000c#64) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = umax (s.regs.read 0#5) (s.regs.read 1#5) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound max_u64_lowered
    (max_u64_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5)
      s.pstate.n s.pstate.z s.pstate.c s.pstate.v) hw hc hrun
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
      Flags.v, hpc])
  refine ⟨s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) (v := umax _ _) hq (by braid_at)

/-- **`sum_to` on the machine.** A running machine whose program holds the words of `sum_to`,
with its code loaded and its program counter at the entry, runs to the address in the link
register with the sum of the numbers from one to `x0`, as a 64-bit word, in `x0`. -/
theorem sum_to_correct (prog : Arm64.Program) (s : Arm64.State)
    (hw : prog.hasWords 0x10018#64 sum_to_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10018#64) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = tri (s.regs.read 0#5) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound sum_to_lowered
    (sum_to_spec (s.regs.read 0#5) (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5)
      (s.regs.read 30#5)) hw hc hrun
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, regOf, hpc])
  refine ⟨s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) (v := tri _) hq (by braid_at)

end Examples.Basic.Arm
