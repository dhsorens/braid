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

/-- A remainder computed as a compiler does without a remainder instruction: divide, multiply
back, subtract. -/
theorem sub_udiv_mul (a b : Word) : a - a / b * b = a % b := by
  apply BitVec.eq_of_toNat_eq
  have h1 := Nat.div_mul_le_self a.toNat b.toNat
  have h2 := Nat.div_add_mod a.toNat b.toNat
  rw [Nat.mul_comm] at h2
  have h3 := a.isLt
  rw [BitVec.toNat_sub, BitVec.toNat_mul, BitVec.toNat_udiv, BitVec.toNat_umod,
    Nat.mod_eq_of_lt (a := a.toNat / b.toNat * b.toNat) (by omega)]
  omega

/-- The sum of the numbers from one to `n`, as a word. -/
def tri (n : Word) : Word := BitVec.ofNat 64 (n.toNat * (n.toNat + 1) / 2)

/-- The full 128-bit product of two words. -/
def wide (a b : Word) : BitVec 128 := a.zeroExtend 128 * b.zeroExtend 128

theorem wide_lo (a b : Word) : (wide a b).truncate 64 = a * b := by
  simp [wide, BitVec.setWidth_mul]

theorem wide_toNat (a b : Word) : (wide a b).toNat = a.toNat * b.toNat := by
  have ha := a.isLt
  have hb := b.isLt
  have h : a.toNat * b.toNat < 2 ^ 128 :=
    Nat.mul_lt_mul'' (c := 2 ^ 64) (d := 2 ^ 64) ha hb
  simp only [wide, BitVec.toNat_mul, BitVec.zeroExtend, BitVec.toNat_setWidth]
  rw [Nat.mod_eq_of_lt (a := a.toNat) (by omega), Nat.mod_eq_of_lt (a := b.toNat) (by omega),
    Nat.mod_eq_of_lt h]

/-- The arithmetic behind the closed form: for `m + 2` in place of `n`. -/
theorem tri_nat (m : Nat) :
    (m + 2) + (m + 1) * (m + 1) - (m + 1) * m / 2 = (m + 2) * (m + 3) / 2 := by
  have h1 : 2 * ((m + 2) + (m + 1) * (m + 1)) = (m + 1) * m + (m + 2) * (m + 3) := by
    simp only [Nat.mul_add, Nat.add_mul, Nat.mul_one, Nat.one_mul]
    omega
  have e1 : (m + 1) * m % 2 = 0 := by
    rw [Nat.mul_mod]
    rcases Nat.mod_two_eq_zero_or_one m with h | h
    · rw [h]; simp
    · have : (m + 1) % 2 = 0 := by omega
      rw [this]; simp
  have e2 : (m + 2) * (m + 3) % 2 = 0 := by
    rw [Nat.mul_mod]
    rcases Nat.mod_two_eq_zero_or_one m with h | h
    · have : (m + 2) % 2 = 0 := by omega
      rw [this]; simp
    · have : (m + 3) % 2 = 0 := by omega
      rw [this]; simp
  omega

/-- **The closed form compilers give the loop `s = 1 + 2 + ... + n`.** With `n` not zero, the
sum is `n + (n - 1)² - (n - 1)(n - 2) / 2`, the last product taken at full width. -/
theorem tri_closed (n : Word) (hn : n ≠ 0#64) :
    n + (n - 1#64) * (n - 1#64) - ((wide (n - 1#64) (n - 2#64)) >>> 1).truncate 64 = tri n := by
  have hN : n.toNat ≠ 0 := fun h => hn (BitVec.eq_of_toNat_eq h)
  have hlt := n.isLt
  have h1 : (n - 1#64).toNat = n.toNat - 1 := by
    rw [BitVec.toNat_sub]; simp; omega
  apply BitVec.eq_of_toNat_eq
  by_cases h2 : n.toNat = 1
  · have e : n = 1#64 := BitVec.eq_of_toNat_eq h2
    subst e
    decide
  · obtain ⟨m, hm⟩ : ∃ m, n.toNat = m + 2 := ⟨n.toNat - 2, by omega⟩
    have h2' : (n - 2#64).toNat = m := by
      rw [BitVec.toNat_sub]; simp; omega
    have hT : (((wide (n - 1#64) (n - 2#64)) >>> 1).truncate 64).toNat =
        ((m + 1) * m / 2) % 2 ^ 64 := by
      simp only [BitVec.truncate, BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, wide_toNat,
        h1, h2', hm, Nat.shiftRight_eq_div_pow]
      rfl
    have key := tri_nat m
    simp only [tri, BitVec.toNat_sub, BitVec.toNat_add, BitVec.toNat_mul, BitVec.toNat_ofNat,
      h1, hT, hm, show m + 2 - 1 = m + 1 from rfl]
    have hx : (m + 1) * m / 2 ≤ (m + 2) + (m + 1) * (m + 1) := by
      have : (m + 1) * m ≤ (m + 1) * (m + 1) := Nat.mul_le_mul_left _ (by omega)
      omega
    generalize (m + 1) * m / 2 = x at key hx ⊢
    generalize (m + 2) * (m + 3) / 2 = y at key ⊢
    generalize (m + 1) * (m + 1) = q at key hx ⊢
    omega

theorem tri_zero : tri 0#64 = 0#64 := by decide

/-- The number of ones in the binary form of a number. -/
def ones (n : Nat) : Nat := if n = 0 then 0 else n % 2 + ones (n / 2)
decreasing_by omega

theorem ones_zero : ones 0 = 0 := by rw [ones]; rfl

theorem ones_pos {n : Nat} (h : n ≠ 0) : ones n = n % 2 + ones (n / 2) := by
  rw [ones]; simp [h]

end Examples
