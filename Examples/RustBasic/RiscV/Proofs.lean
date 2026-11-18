/-
  Examples.RustBasic.RiscV.Proofs

  `basic.rs` on RISC-V: Euclid's algorithm, a loop whose termination needs a measure.
-/

module

public import Examples.RustBasic.RiscV.Image
public import Lowering.RiscV.Logic

public section

namespace Examples.RustBasic.RiscV

open Braid Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- The greatest common divisor of two words. -/
def wgcd (a b : Word) : Word := BitVec.ofNat 64 (Nat.gcd a.toNat b.toNat)

theorem wgcd_zero (a : Word) : wgcd a 0#64 = a := by simp [wgcd]

theorem wgcd_rec (a b : Word) : wgcd a b = wgcd b (a % b) := by
  simp only [wgcd, BitVec.toNat_umod]
  rw [Nat.gcd_comm a.toNat, Nat.gcd_rec, Nat.gcd_comm]

/-- The loop of `gcd`, entered with a divisor that is not zero. -/
theorem gcd_loop (r : Word) (k : Nat) : ∀ a b t : Word, b.toNat = k → b ≠ 0#64 →
    Triple gcd.program
      (Atoms.interp [.pc 0x10014#64, .reg a0 a, .reg a1 b, .reg a2 t, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (wgcd a b), .reg a1 0#64, .reg a2 0#64,
        .reg ra r]) := by
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

/-- `gcd` returns the greatest common divisor of its arguments. -/
theorem gcd_spec (a b t r : Word) :
    Triple gcd.program
      (Atoms.interp [.pc 0x10010#64, .reg a0 a, .reg a1 b, .reg a2 t, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (wgcd a b), .prop (regAny a1),
        .prop (regAny a2), .reg ra r]) := by
  braid_step
  · subst hbr
    braid_run
    braid_forget 11
    braid_forget 12
    exact Triple.done_eq (by simp [wgcd_zero])
  · braid_call gcd_loop r _ a b t rfl hbr
    braid_forget 11
    braid_forget 12
    braid_done

/-- **`gcd` on the machine.** A machine that holds the code of `gcd` and is at its entry runs
to the return address with the greatest common divisor of `a0` and `a1` in `a0`. -/
theorem gcd_correct (s : MachineState) (hcode : ∀ p ∈ gcd_code, s.code p.1 = some p.2)
    (hpc : s.pc = 0x10010#64) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 = BitVec.ofNat 64 (Nat.gcd (s.getReg .x10).toNat (s.getReg .x11).toNat) := by
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound gcd_lowered
    (gcd_spec (s.getReg .x10) (s.getReg .x11) (s.getReg .x12) (s.getReg .x1)) hcode
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc])
  refine ⟨n, s', hn, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]
    exact Atoms.reg_of_holds (r := 10) (v := wgcd _ _) hq (by braid_at)

end Examples.RustBasic.RiscV
