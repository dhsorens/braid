/-
  Examples.Spec

  The functions the examples are specified with. They are about words and lists, and know
  nothing of any instruction set: the same function specifies the RISC-V, AArch64 and x86-64
  code of one source.
-/

module

public import Braid

@[expose] public section

namespace Examples

open Braid

/-- The larger of two words, unsigned. -/
def umax (a b : Word) : Word := if b.ult a then a else b

/-- The smaller of two words, unsigned. -/
def umin (a b : Word) : Word := if a.ult b then a else b

/-- The sum of a list of words, added to `acc` from the left as a loop does. -/
def wsum (xs : List Word) (acc : Word) : Word := xs.foldl (fun s x => x + s) acc

/-- The greatest common divisor of two words. -/
def wgcd (a b : Word) : Word := BitVec.ofNat 64 (Nat.gcd a.toNat b.toNat)

theorem wgcd_zero (a : Word) : wgcd a 0#64 = a := by simp [wgcd]

theorem wgcd_rec (a b : Word) : wgcd a b = wgcd b (a % b) := by
  simp only [wgcd, BitVec.toNat_umod]
  rw [Nat.gcd_comm a.toNat, Nat.gcd_rec, Nat.gcd_comm]

/-- The number of ones in the binary form of a number. -/
def ones (n : Nat) : Nat := if n = 0 then 0 else n % 2 + ones (n / 2)
decreasing_by omega

theorem ones_zero : ones 0 = 0 := by rw [ones]; rfl

theorem ones_pos {n : Nat} (h : n ≠ 0) : ones n = n % 2 + ones (n / 2) := by
  rw [ones]; simp [h]

end Examples
