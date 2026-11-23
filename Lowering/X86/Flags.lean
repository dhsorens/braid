/-
  Lowering.X86.Flags

  The machine model states the carry and overflow flags of an addition or subtraction in
  integers: the flag is set when the result, read as an integer, is not the integer sum.
  These lemmas restate each as the overflow predicate of bitvectors, which `bv_auto`
  decides.

  ## Main results

  * `uadd_ne`, `sadd_ne`: the carry and overflow of an addition
  * `usub_ne`, `ssub_ne`: the borrow and overflow of a subtraction
  * `cpop_eq`: the model's population count is the library's
-/

module

public import Kraken.X64.Semantics
import Braid.BV

@[expose] public section

namespace Lowering.X86

theorem uadd_ne {w : Nat} (a b : BitVec w) :
    (BitVec.unsigned (a + b) != BitVec.unsigned a + BitVec.unsigned b) =
      BitVec.uaddOverflow a b := by
  by_cases h : BitVec.uaddOverflow a b
  · rw [h]
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq] at h
    have hlt := (a + b).isLt
    simp only [BitVec.unsigned, bne_iff_ne, ne_eq]
    omega
  · have e := BitVec.toNat_add_of_not_uaddOverflow h
    simp only [Bool.not_eq_true] at h
    rw [h]
    simp only [BitVec.unsigned, e, bne_eq_false_iff_eq]
    omega

theorem sadd_ne {w : Nat} (a b : BitVec w) :
    (BitVec.signed (a + b) != BitVec.signed a + BitVec.signed b) = BitVec.saddOverflow a b := by
  by_cases h : BitVec.saddOverflow a b
  · rw [h]
    simp only [BitVec.saddOverflow, ge_iff_le, Bool.or_eq_true, decide_eq_true_eq] at h
    have h1 := @BitVec.toInt_lt w (a + b)
    have h2 := BitVec.le_toInt (a + b)
    simp only [BitVec.signed, bne_iff_ne, ne_eq]
    omega
  · have e := BitVec.toInt_add_of_not_saddOverflow h
    simp only [Bool.not_eq_true] at h
    rw [h]
    simp only [BitVec.signed, e, bne_self_eq_false]

theorem usub_ne {w : Nat} (a b : BitVec w) :
    (BitVec.unsigned (a - b) != BitVec.unsigned a - BitVec.unsigned b) =
      BitVec.usubOverflow a b := by
  by_cases h : BitVec.usubOverflow a b
  · rw [h]
    simp only [BitVec.usubOverflow, decide_eq_true_eq] at h
    simp only [BitVec.unsigned, bne_iff_ne, ne_eq]
    omega
  · have e := BitVec.toNat_sub_of_not_usubOverflow h
    simp only [BitVec.usubOverflow, decide_eq_true_eq, Nat.not_lt] at h
    have h' : BitVec.usubOverflow a b = false := by
      simp only [BitVec.usubOverflow, decide_eq_false_iff_not, Nat.not_lt]; exact h
    rw [h']
    simp only [BitVec.unsigned, e, bne_eq_false_iff_eq]
    omega

theorem ssub_ne {w : Nat} (a b : BitVec w) :
    (BitVec.signed (a - b) != BitVec.signed a - BitVec.signed b) = BitVec.ssubOverflow a b := by
  by_cases h : BitVec.ssubOverflow a b
  · rw [h]
    simp only [BitVec.ssubOverflow, ge_iff_le, Bool.or_eq_true, decide_eq_true_eq] at h
    have h1 := @BitVec.toInt_lt w (a - b)
    have h2 := BitVec.le_toInt (a - b)
    simp only [BitVec.signed, bne_iff_ne, ne_eq]
    omega
  · have e := BitVec.toInt_sub_of_not_ssubOverflow h
    simp only [Bool.not_eq_true] at h
    rw [h]
    simp only [BitVec.signed, e, bne_self_eq_false]

theorem neg_ne {w : Nat} (a : BitVec w) :
    (BitVec.signed (-a) != -BitVec.signed a) = BitVec.negOverflow a := by
  by_cases h : BitVec.negOverflow a
  · rw [h]
    simp only [BitVec.negOverflow, beq_iff_eq] at h
    have h1 := @BitVec.toInt_lt w (-a)
    simp only [BitVec.signed, bne_iff_ne, ne_eq]
    omega
  · have e := BitVec.toInt_neg_of_not_negOverflow h
    simp only [Bool.not_eq_true] at h
    rw [h]
    simp only [BitVec.signed, e, bne_self_eq_false]

/-- The overflow of an increment, at a width where `1` is the integer one. -/
theorem inc_ne {w : Nat} (a : BitVec w) (h1 : BitVec.signed (1 : BitVec w) = 1) :
    (BitVec.signed (a + 1) != BitVec.signed a + 1) = BitVec.saddOverflow a 1 := by
  rw [← sadd_ne, h1]

/-- The overflow of a decrement, at a width where `1` is the integer one. -/
theorem dec_ne {w : Nat} (a : BitVec w) (h1 : BitVec.signed (1 : BitVec w) = 1) :
    (BitVec.signed (a - 1) != BitVec.signed a - 1) = BitVec.ssubOverflow a 1 := by
  rw [← ssub_ne, h1]

theorem inc_ne8 (a : BitVec 8) :
    (BitVec.signed (a + 1) != BitVec.signed a + 1) = BitVec.saddOverflow a 1 :=
  inc_ne a (by decide)

theorem inc_ne16 (a : BitVec 16) :
    (BitVec.signed (a + 1) != BitVec.signed a + 1) = BitVec.saddOverflow a 1 :=
  inc_ne a (by decide)

theorem inc_ne32 (a : BitVec 32) :
    (BitVec.signed (a + 1) != BitVec.signed a + 1) = BitVec.saddOverflow a 1 :=
  inc_ne a (by decide)

theorem inc_ne64 (a : BitVec 64) :
    (BitVec.signed (a + 1) != BitVec.signed a + 1) = BitVec.saddOverflow a 1 :=
  inc_ne a (by decide)

theorem dec_ne8 (a : BitVec 8) :
    (BitVec.signed (a - 1) != BitVec.signed a - 1) = BitVec.ssubOverflow a 1 :=
  dec_ne a (by decide)

theorem dec_ne16 (a : BitVec 16) :
    (BitVec.signed (a - 1) != BitVec.signed a - 1) = BitVec.ssubOverflow a 1 :=
  dec_ne a (by decide)

theorem dec_ne32 (a : BitVec 32) :
    (BitVec.signed (a - 1) != BitVec.signed a - 1) = BitVec.ssubOverflow a 1 :=
  dec_ne a (by decide)

theorem dec_ne64 (a : BitVec 64) :
    (BitVec.signed (a - 1) != BitVec.signed a - 1) = BitVec.ssubOverflow a 1 :=
  dec_ne a (by decide)

/-- The carry of an addition with a carry in: either addition carries. `hc` says the width
has room for the carry bit. -/
theorem adc_ne {w : Nat} (a b : BitVec w) (c : Bool)
    (hc : (BitVec.ofNat w c.toNat).toNat = c.toNat) :
    (BitVec.unsigned (a + b + BitVec.ofNat w c.toNat) !=
        BitVec.unsigned a + BitVec.unsigned b + (c.toNat : Int)) =
      (BitVec.uaddOverflow a b || BitVec.uaddOverflow (a + b) (BitVec.ofNat w c.toNat)) := by
  have hv := (a + b + BitVec.ofNat w c.toNat).isLt
  by_cases h1 : BitVec.uaddOverflow a b
  · rw [h1, Bool.true_or]
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq] at h1
    simp only [BitVec.unsigned, bne_iff_ne, ne_eq]
    omega
  · have e1 := BitVec.toNat_add_of_not_uaddOverflow h1
    simp only [Bool.not_eq_true] at h1
    rw [h1, Bool.false_or]
    by_cases h2 : BitVec.uaddOverflow (a + b) (BitVec.ofNat w c.toNat)
    · rw [h2]
      simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq] at h2
      simp only [BitVec.unsigned, bne_iff_ne, ne_eq]
      omega
    · have e2 := BitVec.toNat_add_of_not_uaddOverflow h2
      simp only [Bool.not_eq_true] at h2
      rw [h2]
      simp only [BitVec.unsigned, bne_eq_false_iff_eq]
      omega

/-- The borrow of a subtraction with a borrow in: either subtraction borrows. -/
theorem sbb_ne {w : Nat} (a b : BitVec w) (c : Bool)
    (hc : (BitVec.ofNat w c.toNat).toNat = c.toNat) :
    (BitVec.unsigned (b - a - BitVec.ofNat w c.toNat) !=
        BitVec.unsigned b - BitVec.unsigned a - (c.toNat : Int)) =
      (BitVec.usubOverflow b a || BitVec.usubOverflow (b - a) (BitVec.ofNat w c.toNat)) := by
  by_cases h1 : BitVec.usubOverflow b a
  · rw [h1, Bool.true_or]
    simp only [BitVec.usubOverflow, decide_eq_true_eq] at h1
    simp only [BitVec.unsigned, bne_iff_ne, ne_eq]
    omega
  · have e1 := BitVec.toNat_sub_of_not_usubOverflow h1
    have h1' : a.toNat ≤ b.toNat := by
      simpa [BitVec.usubOverflow] using h1
    simp only [Bool.not_eq_true] at h1
    rw [h1, Bool.false_or]
    by_cases h2 : BitVec.usubOverflow (b - a) (BitVec.ofNat w c.toNat)
    · rw [h2]
      simp only [BitVec.usubOverflow, decide_eq_true_eq] at h2
      simp only [BitVec.unsigned, bne_iff_ne, ne_eq]
      omega
    · have e2 := BitVec.toNat_sub_of_not_usubOverflow h2
      have h2' : (BitVec.ofNat w c.toNat).toNat ≤ (b - a).toNat := by
        simpa [BitVec.usubOverflow] using h2
      simp only [Bool.not_eq_true] at h2
      rw [h2]
      simp only [BitVec.unsigned, bne_eq_false_iff_eq]
      omega

/-- A truth value as a bit-vector, in the form the bit-vector solver reads. -/
theorem ofNat_toNat_bool (w : Nat) (c : Bool) :
    BitVec.ofNat w c.toNat = (BitVec.ofBool c).setWidth w := by
  cases c <;> apply BitVec.eq_of_toNat_eq <;> simp

theorem adc_ne8 (a b : BitVec 8) (c : Bool) :
    (BitVec.unsigned (a + b + BitVec.ofNat 8 c.toNat) !=
        BitVec.unsigned a + BitVec.unsigned b + (c.toNat : Int)) =
      (BitVec.uaddOverflow a b || BitVec.uaddOverflow (a + b) (BitVec.ofNat 8 c.toNat)) :=
  adc_ne a b c (by cases c <;> rfl)

theorem sbb_ne8 (a b : BitVec 8) (c : Bool) :
    (BitVec.unsigned (b - a - BitVec.ofNat 8 c.toNat) !=
        BitVec.unsigned b - BitVec.unsigned a - (c.toNat : Int)) =
      (BitVec.usubOverflow b a || BitVec.usubOverflow (b - a) (BitVec.ofNat 8 c.toNat)) :=
  sbb_ne a b c (by cases c <;> rfl)

theorem adc_ne16 (a b : BitVec 16) (c : Bool) :
    (BitVec.unsigned (a + b + BitVec.ofNat 16 c.toNat) !=
        BitVec.unsigned a + BitVec.unsigned b + (c.toNat : Int)) =
      (BitVec.uaddOverflow a b || BitVec.uaddOverflow (a + b) (BitVec.ofNat 16 c.toNat)) :=
  adc_ne a b c (by cases c <;> rfl)

theorem sbb_ne16 (a b : BitVec 16) (c : Bool) :
    (BitVec.unsigned (b - a - BitVec.ofNat 16 c.toNat) !=
        BitVec.unsigned b - BitVec.unsigned a - (c.toNat : Int)) =
      (BitVec.usubOverflow b a || BitVec.usubOverflow (b - a) (BitVec.ofNat 16 c.toNat)) :=
  sbb_ne a b c (by cases c <;> rfl)

theorem adc_ne32 (a b : BitVec 32) (c : Bool) :
    (BitVec.unsigned (a + b + BitVec.ofNat 32 c.toNat) !=
        BitVec.unsigned a + BitVec.unsigned b + (c.toNat : Int)) =
      (BitVec.uaddOverflow a b || BitVec.uaddOverflow (a + b) (BitVec.ofNat 32 c.toNat)) :=
  adc_ne a b c (by cases c <;> rfl)

theorem sbb_ne32 (a b : BitVec 32) (c : Bool) :
    (BitVec.unsigned (b - a - BitVec.ofNat 32 c.toNat) !=
        BitVec.unsigned b - BitVec.unsigned a - (c.toNat : Int)) =
      (BitVec.usubOverflow b a || BitVec.usubOverflow (b - a) (BitVec.ofNat 32 c.toNat)) :=
  sbb_ne a b c (by cases c <;> rfl)

theorem adc_ne64 (a b : BitVec 64) (c : Bool) :
    (BitVec.unsigned (a + b + BitVec.ofNat 64 c.toNat) !=
        BitVec.unsigned a + BitVec.unsigned b + (c.toNat : Int)) =
      (BitVec.uaddOverflow a b || BitVec.uaddOverflow (a + b) (BitVec.ofNat 64 c.toNat)) :=
  adc_ne a b c (by cases c <;> rfl)

theorem sbb_ne64 (a b : BitVec 64) (c : Bool) :
    (BitVec.unsigned (b - a - BitVec.ofNat 64 c.toNat) !=
        BitVec.unsigned b - BitVec.unsigned a - (c.toNat : Int)) =
      (BitVec.usubOverflow b a || BitVec.usubOverflow (b - a) (BitVec.ofNat 64 c.toNat)) :=
  sbb_ne a b c (by cases c <;> rfl)

/-- The high half of an unsigned product, as the model computes it in integers and as a
product at twice the width. -/
theorem mulhi_eq {n : Nat} (a b : BitVec n) :
    BitVec.ofInt n ((BitVec.unsigned a * BitVec.unsigned b) >>> n) =
      ((a.setWidth (2 * n) * b.setWidth (2 * n)) >>> n).setWidth n := by
  have hab : a.toNat * b.toNat < 2 ^ (2 * n) := by
    rw [Nat.two_mul, Nat.pow_add]; exact Nat.mul_lt_mul'' a.isLt b.isLt
  have hle : 2 ^ n ≤ 2 ^ (2 * n) := Nat.pow_le_pow_right (by decide) (by omega)
  have hl : (BitVec.unsigned a * BitVec.unsigned b) >>> n =
      (((a.toNat * b.toNat) >>> n : Nat) : Int) := by
    simp only [BitVec.unsigned]
    rw [← Int.natCast_mul, Int.shiftRight_eq_div_pow, Nat.shiftRight_eq_div_pow,
      Int.natCast_ediv, Int.natCast_pow]
  apply BitVec.eq_of_toNat_eq
  rw [hl, BitVec.ofInt_natCast]
  simp only [BitVec.toNat_ofNat, BitVec.toNat_setWidth, BitVec.toNat_ushiftRight,
    BitVec.toNat_mul]
  rw [Nat.mod_eq_of_lt (Nat.lt_of_lt_of_le a.isLt hle),
    Nat.mod_eq_of_lt (Nat.lt_of_lt_of_le b.isLt hle), Nat.mod_eq_of_lt hab]

/-- An unsigned product overflows exactly when its high half is not zero. -/
theorem umul_ne {n : Nat} (a b : BitVec n) :
    (BitVec.unsigned (a * b) != BitVec.unsigned a * BitVec.unsigned b) =
      (((a.setWidth (2 * n) * b.setWidth (2 * n)) >>> n).setWidth n != 0#n) := by
  have hab : a.toNat * b.toNat < 2 ^ (2 * n) := by
    rw [Nat.two_mul, Nat.pow_add]; exact Nat.mul_lt_mul'' a.isLt b.isLt
  have hle : 2 ^ n ≤ 2 ^ (2 * n) := Nat.pow_le_pow_right (by decide) (by omega)
  have hpos : 0 < 2 ^ n := Nat.pos_of_ne_zero (by simp)
  have hdiv : a.toNat * b.toNat / 2 ^ n < 2 ^ n := by
    rw [Nat.div_lt_iff_lt_mul hpos, ← Nat.pow_add, ← Nat.two_mul]; exact hab
  have hhi : (((a.setWidth (2 * n) * b.setWidth (2 * n)) >>> n).setWidth n).toNat =
      a.toNat * b.toNat / 2 ^ n := by
    simp only [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, BitVec.toNat_mul]
    rw [Nat.mod_eq_of_lt (Nat.lt_of_lt_of_le a.isLt hle),
      Nat.mod_eq_of_lt (Nat.lt_of_lt_of_le b.isLt hle), Nat.mod_eq_of_lt hab,
      Nat.shiftRight_eq_div_pow, Nat.mod_eq_of_lt hdiv]
  have hv : (a * b).toNat = a.toNat * b.toNat % 2 ^ n := BitVec.toNat_mul a b
  by_cases h : a.toNat * b.toNat < 2 ^ n
  · have h0 : a.toNat * b.toNat / 2 ^ n = 0 := Nat.div_eq_of_lt h
    have e1 : ((a.setWidth (2 * n) * b.setWidth (2 * n)) >>> n).setWidth n = 0#n :=
      BitVec.eq_of_toNat_eq (by rw [hhi, h0]; simp)
    have e2 : BitVec.unsigned (a * b) = BitVec.unsigned a * BitVec.unsigned b := by
      simp only [BitVec.unsigned, hv, Nat.mod_eq_of_lt h]
      exact Int.natCast_mul _ _
    simp [e1, e2]
  · have h1 : 0 < a.toNat * b.toNat / 2 ^ n := Nat.div_pos (Nat.le_of_not_lt h) hpos
    have e1 : ((a.setWidth (2 * n) * b.setWidth (2 * n)) >>> n).setWidth n ≠ 0#n := fun e => by
      have := congrArg BitVec.toNat e
      rw [hhi] at this
      simp at this
      omega
    have hm := Nat.mod_lt (a.toNat * b.toNat) hpos
    have e2 : BitVec.unsigned (a * b) ≠ BitVec.unsigned a * BitVec.unsigned b := by
      simp only [BitVec.unsigned, hv]
      rw [← Int.natCast_mul]
      intro e
      have := Int.natCast_inj.1 e
      omega
    rw [bne_iff_ne.2 e2, bne_iff_ne.2 e1]

/-- A signed product at a wider width, as the model computes it in integers. -/
theorem ofInt_mul_toInt {n : Nat} (a b : BitVec n) (m : Nat) :
    BitVec.ofInt m (a.toInt * b.toInt) = a.signExtend m * b.signExtend m := by
  simp [BitVec.ofInt_mul, BitVec.signExtend]

theorem cpop_eq {w : Nat} (x : BitVec w) : x.cpop_ = x.cpop := by
  have key : ∀ pos acc, x.cpopNatRec_ pos acc = x.cpopNatRec pos acc := by
    intro pos
    induction pos with
    | zero => intro acc; rfl
    | succ n ih => intro acc; simp only [BitVec.cpopNatRec_, BitVec.cpopNatRec, ih]
  simp only [BitVec.cpop_, BitVec.cpop, key]

end Lowering.X86
