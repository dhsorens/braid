/-
  Examples.Basic.RiscV.Proofs

  `basic.c` on RISC-V: the specifications of its functions, proved of the lowered code and
  carried down to the machine.
-/

module

public import Examples.Basic.RiscV.Image
public import Lowering.RiscV.Logic
public import Examples.Spec

public section

namespace Examples.Basic.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

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
  · rw [← hr.getReg (r := .x10) (by decide)]; exact Atoms.reg_of_holds (r := 10) hq (by braid_at)

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
  · rw [← hr.getReg (r := .x10) (by decide)]; exact Atoms.reg_of_holds (r := 10) hq (by braid_at)

/-- `sum_to` returns `1 + 2 + ... + n`. The compiler has replaced the loop of the source by a
closed form with a 128-bit product. -/
theorem sum_to_spec (n t1 t2 t3 r : Word) :
    Triple sum_to.program
      (Atoms.interp [.pc 0x10018#64, .reg a0 n, .reg a1 t1, .reg a2 t2, .reg a3 t3, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (tri n), .prop (regAny a1),
        .prop (regAny a2), .prop (regAny a3), .reg ra r]) := by
  braid_step
  · subst hbr
    braid_run
    braid_forget 11
    braid_forget 12
    braid_forget 13
    have h0 : tri 0#64 = 0#64 := by decide
    exact Triple.done_eq (by rw [h0])
  · braid_run
    braid_forget 11
    braid_forget 12
    braid_forget 13
    refine Triple.done_eq ?_
    have a1 : n + 18446744073709551615#64 = n - 1#64 := by bv_decide
    have a2 : n + 18446744073709551614#64 = n - 2#64 := by bv_decide
    have hw : BitVec.setWidth 128 (n - 1#64) * BitVec.setWidth 128 (n - 2#64) =
        wide (n - 1#64) (n - 2#64) := rfl
    rw [a1, a2, hw, ← tri_closed n hbr, ← wide_lo (n - 1#64) (n - 2#64)]
    generalize wide (n - 1#64) (n - 2#64) = X
    simp only [List.cons.injEq, Atom.reg.injEq, true_and, and_true]
    bv_decide

end Examples.Basic.RiscV
