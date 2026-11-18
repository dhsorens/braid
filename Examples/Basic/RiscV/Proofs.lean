/-
  Examples.Basic.RiscV.Proofs

  `basic.c` on RISC-V: the specifications of its functions, proved of the lowered code and
  carried down to the machine.
-/

module

public import Examples.Basic.RiscV.Image
public import Lowering.RiscV.Logic

namespace Examples.Basic.RiscV

open Braid Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- `add3` returns the sum of its arguments. -/
theorem add3_spec (a b c r : Word) :
    Triple add3.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 a, .reg a1 b, .reg a2 c, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (b + a + c), .reg a1 b, .reg a2 c, .reg ra r]) := by
  braid_run
  braid_done

/-- `max_u64` returns the larger of its arguments. -/
theorem max_u64_spec (a b r : Word) :
    Triple max_u64.program
      (Atoms.interp [.pc 0x1000c#64, .reg a0 a, .reg a1 b, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (if b.ult a then a else b), .reg a1 b, .reg ra r]) := by
  braid_step
  · braid_run
    braid_done
  · braid_run
    braid_done

/-- **`add3` on the machine.** A machine that holds the code of `add3` and is at its entry
runs to the return address with the sum of the three argument registers in `a0`. -/
theorem add3_correct (s : MachineState) (hcode : ∀ p ∈ add3_code, s.code p.1 = some p.2)
    (hpc : s.pc = 0x10000#64) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 = s.getReg .x11 + s.getReg .x10 + s.getReg .x12 := by
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound add3_lowered
    (add3_spec (s.getReg .x10) (s.getReg .x11) (s.getReg .x12) (s.getReg .x1)) hcode
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc])
  refine ⟨n, s', hn, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]; exact Atoms.reg_of_holds hq (by braid_at)

/-- **`max_u64` on the machine.** -/
theorem max_u64_correct (s : MachineState)
    (hcode : ∀ p ∈ max_u64_code, s.code p.1 = some p.2) (hpc : s.pc = 0x1000c#64) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 =
        if (s.getReg .x11).ult (s.getReg .x10) then s.getReg .x10 else s.getReg .x11 := by
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound max_u64_lowered
    (max_u64_spec (s.getReg .x10) (s.getReg .x11) (s.getReg .x1)) hcode
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc])
  refine ⟨n, s', hn, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]; exact Atoms.reg_of_holds hq (by braid_at)

end Examples.Basic.RiscV
