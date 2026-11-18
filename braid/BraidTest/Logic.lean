/-
  BraidTest.Logic

  Tests of the separation logic on small hand-written programs.
-/

module

public import Braid

namespace BraidTest

open Braid

/-- `r10 := max r10 r11` (unsigned), then go to the address in `r1`. -/
def maxProg : Program := Program.ofList [
  (0x1000#64, { ops := [.get 0 10, .get 1 11, .bin 2 .ult 0 1], term := .branch 2 0x1004#64 0x1008#64 }),
  (0x1004#64, { ops := [.get 0 11, .set 10 0], term := .jump 0x1008#64 }),
  (0x1008#64, { ops := [.get 0 1], term := .jumpInd 0 })]

theorem maxProg_spec (a b ra : Word) :
    Triple maxProg
      (Atoms.interp [.pc 0x1000#64, .reg 10 a, .reg 11 b, .reg 1 ra])
      (Atoms.interp [.pc ra, .reg 10 (if a.ult b then b else a), .reg 11 b, .reg 1 ra]) := by
  braid_step
  · braid_run
    braid_done
  · braid_run
    braid_done

/-- The sum of the numbers up to `n`. -/
def tri : Nat → Word
  | 0 => 0
  | k + 1 => BitVec.ofNat 64 (k + 1) + tri k

/-- `r12 := r10 + (r10 - 1) + ... + 1`, then go to the address in `r1`. -/
def sumProg : Program := Program.ofList [
  (0x2000#64, { ops := [.const 0 0#64, .set 12 0], term := .jump 0x2004#64 }),
  (0x2004#64, { ops := [.get 0 10, .const 1 0#64, .bin 2 .eq 0 1], term := .branch 2 0x2010#64 0x2008#64 }),
  (0x2008#64, { ops := [.get 0 10, .get 1 12, .bin 2 .add 1 0, .set 12 2, .const 3 1#64, .bin 4 .sub 0 3, .set 10 4],
                term := .jump 0x2004#64 }),
  (0x2010#64, { ops := [.get 0 1], term := .jumpInd 0 })]

theorem sumProg_loop (ra : Word) (k : Nat) : ∀ n acc : Word, n.toNat = k →
    Triple sumProg
      (Atoms.interp [.pc 0x2004#64, .reg 10 n, .reg 12 acc, .reg 1 ra])
      (Atoms.interp [.pc ra, .reg 10 0#64, .reg 12 (acc + tri k), .reg 1 ra]) := by
  induction k with
  | zero =>
    intro n acc hn
    have : n = 0#64 := BitVec.eq_of_toNat_eq hn
    subst this
    braid_step
    braid_run
    exact Triple.done_eq (by simp [tri])
  | succ k ih =>
    intro n acc hn
    braid_step
    · subst hbr; simp at hn
    · braid_step
      refine (ih _ _ ?_).cast rfl ?_
      · bv_omega
      · have e : BitVec.ofNat 64 (k + 1) = n := by rw [← hn]; simp
        simp [tri, e, BitVec.add_assoc]

/-- A lane-wise addition wraps within each lane and does not carry into the next. -/
example : (BinOp.lanes 32 .add).eval 0x00000001ffffffff#64 0x0000000100000001#64 =
    0x0000000200000000#64 := by decide

/-- A lane-wise operation on 64-bit lanes is the operation itself. -/
example : (BinOp.lanes 64 .xor).eval 0xff00#64 0x0ff0#64 = 0xf0f0#64 := by decide

end BraidTest
