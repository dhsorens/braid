/-
  Examples.PyBasic.RiscV.Proofs

  `basic.py` on RISC-V: Python functions compiled to native code by Numba. A compiled
  function returns a status in `a0`, zero for success, and writes its result through the
  pointer it is given in `a0`. Its Python arguments start at `a2`.
-/

module

public import Examples.PyBasic.RiscV.Image
public import Lowering.RiscV.Logic
public import Examples.Spec

public section

namespace Examples.PyBasic.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- `add3` writes the sum of its arguments through the result pointer, and returns zero. -/
theorem py_add3_spec (p a b c old r : Word) (hp : p &&& 7#64 = 0#64) :
    Triple py_add3.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 p, .reg a2 a, .reg a3 b, .reg a4 c,
        .mem p 8 old true, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 0#64, .reg a2 (b + (a + c)), .reg a3 b,
        .reg a4 c, .mem p 8 (b + (a + c)) true, .reg ra r]) := by
  braid_run
  braid_done

/-- `max_u64` writes the larger of its arguments through the result pointer. -/
theorem py_max_u64_spec (p a b old r : Word) (hp : p &&& 7#64 = 0#64) :
    Triple py_max_u64.program
      (Atoms.interp [.pc 0x10014#64, .reg a0 p, .reg a2 a, .reg a3 b, .mem p 8 old true,
        .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 0#64, .reg a2 (umax a b), .reg a3 b,
        .mem p 8 (umax a b) true, .reg ra r]) := by
  braid_step
  · braid_run
    exact Triple.done_eq (by simp [umax, hbr])
  · braid_run
    exact Triple.done_eq (by simp [umax, hbr])

/-- The loop of `gcd`, entered with a divisor that is not zero. -/
theorem py_gcd_loop (p old r : Word) (hp : p &&& 7#64 = 0#64) (k : Nat) :
    ∀ a b t : Word, b.toNat = k → b ≠ 0#64 →
    Triple py_gcd.program
      (Atoms.interp [.pc 0x1002c#64, .reg a0 p, .reg a1 t, .reg a2 a, .reg a3 b,
        .mem p 8 old true, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 0#64, .reg a1 (wgcd a b),
        .reg a2 (wgcd a b), .reg a3 0#64, .mem p 8 (wgcd a b) true, .reg ra r]) := by
  induction k using Nat.strongRecOn with
  | ind k ih =>
    intro a b t hk hb
    iterate 3 braid_step
    braid_step
    · simp only [hb, ↓reduceIte] at hbr ⊢
      refine (ih _ ?_ b (a % b) _ rfl hbr).cast rfl (by simp [wgcd_rec a b])
      rw [← hk, BitVec.toNat_umod]
      exact Nat.mod_lt _ (Nat.pos_of_ne_zero fun h => hb (BitVec.eq_of_toNat_eq h))
    · simp only [hb, ↓reduceIte] at hbr ⊢
      braid_run
      exact Triple.done_eq (by simp [wgcd_rec a b, hbr, wgcd_zero])

/-- `gcd` writes the greatest common divisor of its arguments through the result pointer. -/
theorem py_gcd_spec (p a b t old r : Word) (hp : p &&& 7#64 = 0#64) :
    Triple py_gcd.program
      (Atoms.interp [.pc 0x10028#64, .reg a0 p, .reg a1 t, .reg a2 a, .reg a3 b,
        .mem p 8 old true, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 0#64, .reg a1 (wgcd a b),
        .reg a2 (wgcd a b), .reg a3 0#64, .mem p 8 (wgcd a b) true, .reg ra r]) := by
  braid_step
  · subst hbr
    braid_run
    exact Triple.done_eq (by simp [wgcd_zero])
  · braid_call py_gcd_loop p old r hp _ a b t rfl hbr
    braid_done

/-- **`add3` on the machine.** A machine that holds the code of `add3`, is at its entry, and
has a word of valid memory where the aligned pointer in `a0` points, runs to the return address
with the sum of `a2`, `a3` and `a4` in that word and zero, for success, in `a0`. -/
theorem py_add3_correct (s : MachineState) (old : Word)
    (hcode : ∀ p ∈ py_add3_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hp : s.getReg .x10 &&& 7#64 = 0#64) (hmem : HasBytes s (s.getReg .x10) 8 old) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 = 0#64 ∧
      HasBytes s' (s.getReg .x10) 8
        (s.getReg .x13 + (s.getReg .x12 + s.getReg .x14)) := by
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound py_add3_lowered
    (py_add3_spec (s.getReg .x10) (s.getReg .x12) (s.getReg .x13) (s.getReg .x14) old
      (s.getReg .x1) hp) hcode
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp only [List.forall_mem_cons, sat_mem_abs]
        simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, hmem])
  refine ⟨n, s', hn, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]
    exact Atoms.reg_of_holds (r := 10) hq (by braid_at)
  · exact hasBytes_of_holds hr hq (by braid_at)

/-- **`max_u64` on the machine.** A machine that holds the code of `max_u64`, is at its entry,
and has a word of valid memory where the aligned pointer in `a0` points, runs to the return
address with the larger of `a2` and `a3`, as unsigned numbers, in that word and zero, for
success, in `a0`. -/
theorem py_max_u64_correct (s : MachineState) (old : Word)
    (hcode : ∀ p ∈ py_max_u64_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10014#64)
    (hp : s.getReg .x10 &&& 7#64 = 0#64) (hmem : HasBytes s (s.getReg .x10) 8 old) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 = 0#64 ∧
      HasBytes s' (s.getReg .x10) 8
        (if (s.getReg .x13).ult (s.getReg .x12) then s.getReg .x12 else s.getReg .x13) := by
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound py_max_u64_lowered
    (py_max_u64_spec (s.getReg .x10) (s.getReg .x12) (s.getReg .x13) old (s.getReg .x1) hp) hcode
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp only [List.forall_mem_cons, sat_mem_abs]
        simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, hmem])
  refine ⟨n, s', hn, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]
    exact Atoms.reg_of_holds (r := 10) hq (by braid_at)
  · exact hasBytes_of_holds (v := umax _ _) hr hq (by braid_at)

/-- **`gcd` on the machine.** A machine that holds the code of `gcd`, is at its entry, and has
a word of valid memory where the aligned pointer in `a0` points, runs to the return address
with the greatest common divisor of `a2` and `a3` in that word and zero, for success, in `a0`.
-/
theorem py_gcd_correct (s : MachineState) (old : Word)
    (hcode : ∀ p ∈ py_gcd_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10028#64)
    (hp : s.getReg .x10 &&& 7#64 = 0#64) (hmem : HasBytes s (s.getReg .x10) 8 old) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 = 0#64 ∧
      HasBytes s' (s.getReg .x10) 8
        (BitVec.ofNat 64 (Nat.gcd (s.getReg .x12).toNat (s.getReg .x13).toNat)) := by
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound py_gcd_lowered
    (py_gcd_spec (s.getReg .x10) (s.getReg .x12) (s.getReg .x13) (s.getReg .x11) old
      (s.getReg .x1) hp) hcode
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp only [List.forall_mem_cons, sat_mem_abs]
        simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, hmem])
  refine ⟨n, s', hn, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]
    exact Atoms.reg_of_holds (r := 10) hq (by braid_at)
  · exact hasBytes_of_holds (v := wgcd _ _) hr hq (by braid_at)

end Examples.PyBasic.RiscV
