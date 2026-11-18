/-
  Examples.SwiftBasic.RiscV.Proofs

  `basic.swift` on RISC-V. The specifications are those of the C and Rust examples: the
  compiler differs, the meaning does not.
-/

module

public import Examples.SwiftBasic.RiscV.Image
public import Lowering.RiscV.Logic
public import Examples.Spec

public section

namespace Examples.SwiftBasic.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- `swift_add3` returns the sum of its arguments. -/
theorem swift_add3_spec (a b c r : Word) :
    Triple swift_add3.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 a, .reg a1 b, .reg a2 c, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (b + a + c), .reg a1 b, .reg a2 c, .reg ra r]) := by
  braid_run
  braid_done

/-- `swift_min` returns the smaller of its arguments. -/
theorem swift_min_spec (a b r : Word) :
    Triple swift_min.program
      (Atoms.interp [.pc 0x10050#64, .reg a0 a, .reg a1 b, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (umin a b), .reg a1 b, .reg ra r]) := by
  braid_step
  · braid_run
    exact Triple.done_eq (by simp [umin, hbr])
  · braid_run
    exact Triple.done_eq (by simp [umin, hbr])

/-- The loop of `swift_gcd`, entered with a divisor that is not zero. -/
theorem swift_gcd_loop (r : Word) (k : Nat) : ∀ a b t : Word, b.toNat = k → b ≠ 0#64 →
    Triple swift_gcd.program
      (Atoms.interp [.pc 0x1001c#64, .reg a0 a, .reg a1 b, .reg a2 t, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (wgcd a b), .reg a1 0#64,
        .prop (regAny a2), .reg ra r]) := by
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
      braid_forget 12
      exact Triple.done_eq (by simp [wgcd_rec a b, hbr, wgcd_zero])

/-- `swift_gcd` returns the greatest common divisor of its arguments. -/
theorem swift_gcd_spec (a b t r : Word) :
    Triple swift_gcd.program
      (Atoms.interp [.pc 0x10018#64, .reg a0 a, .reg a1 b, .reg a2 t, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (wgcd a b), .prop (regAny a1),
        .prop (regAny a2), .reg ra r]) := by
  braid_step
  · subst hbr
    braid_run
    braid_forget 11
    braid_forget 12
    exact Triple.done_eq (by simp [wgcd_zero])
  · braid_call swift_gcd_loop r _ a b t rfl hbr
    braid_forget 11
    braid_done

/-- **`swift_gcd` on the machine.** -/
theorem swift_gcd_correct (s : MachineState)
    (hcode : ∀ p ∈ swift_gcd_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10018#64) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 = BitVec.ofNat 64 (Nat.gcd (s.getReg .x10).toNat (s.getReg .x11).toNat) := by
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound swift_gcd_lowered
    (swift_gcd_spec (s.getReg .x10) (s.getReg .x11) (s.getReg .x12) (s.getReg .x1)) hcode
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc])
  refine ⟨n, s', hn, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]
    exact Atoms.reg_of_holds (r := 10) (v := wgcd _ _) hq (by braid_at)

end Examples.SwiftBasic.RiscV
