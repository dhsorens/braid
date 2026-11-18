/-
  Examples.PyBasic.Arm.Proofs

  `basic.py` on AArch64: Python functions compiled to native code by Numba. A compiled
  function returns a status in `w0`, zero for success, and writes its result through the
  pointer it is given in `x0`. Its Python arguments start at `x2`.
-/

module

public import Examples.PyBasic.Arm.Image
public import Examples.ArmMachine
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

/-! ## On the machine -/

/-- **`add3` on the machine.** A running machine whose program holds the words of `py_add3`,
with its code loaded and its program counter at the entry, and with a word of memory where
`x0` points, runs to the address in the link register with the sum of `x2`, `x3` and `x4` in
that word and zero in `x0`. -/
theorem py_add3_correct (prog : Arm64.Program) (s : Arm64.State) (old : Word)
    (hw : prog.hasWords 0x10000#64 py_add3_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64)
    (hp : HasBytes s (s.regs.read 0#5) 8 old) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧ s'.regs.read 0#5 = 0#64 ∧
      HasBytes s' (s.regs.read 0#5) 8
        (s.regs.read 3#5 + (s.regs.read 2#5 + s.regs.read 4#5)) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound py_add3_lowered
    (py_add3_spec (s.regs.read 0#5) (s.regs.read 2#5) (s.regs.read 3#5) (s.regs.read 4#5)
      (s.regs.read 8#5) (s.regs.read 9#5) old (s.regs.read 30#5)) hw hc hrun
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, sat_mem_hasBytes, regOf, hpc, hp])
  refine ⟨s', hsteps, ?_, ?_, hasBytes_of_holds hr hq (by braid_at)⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) hq (by braid_at)

/-- **`max_u64` on the machine.** A running machine whose program holds the words of
`py_max_u64`, with its code loaded and its program counter at the entry, and with a word of
memory where `x0` points, runs to the address in the link register with the larger of `x2`
and `x3`, as unsigned numbers, in that word and zero in `x0`. -/
theorem py_max_u64_correct (prog : Arm64.Program) (s : Arm64.State) (old : Word)
    (hw : prog.hasWords 0x10018#64 py_max_u64_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10018#64)
    (hp : HasBytes s (s.regs.read 0#5) 8 old) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧ s'.regs.read 0#5 = 0#64 ∧
      HasBytes s' (s.regs.read 0#5) 8 (umax (s.regs.read 2#5) (s.regs.read 3#5)) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound py_max_u64_lowered
    (py_max_u64_spec (s.regs.read 0#5) (s.regs.read 2#5) (s.regs.read 3#5) (s.regs.read 8#5)
      (s.regs.read 9#5) old (s.regs.read 30#5) s.pstate.n s.pstate.z s.pstate.c s.pstate.v)
    hw hc hrun (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, sat_mem_hasBytes, regOf, Flags.n,
      Flags.z, Flags.c, Flags.v, hpc, hp])
  refine ⟨s', hsteps, ?_, ?_, hasBytes_of_holds hr hq (by braid_at)⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) hq (by braid_at)

end Examples.PyBasic.Arm
