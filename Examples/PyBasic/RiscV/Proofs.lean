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

end Examples.PyBasic.RiscV
