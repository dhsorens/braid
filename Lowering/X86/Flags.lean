/-
  Lowering.X86.Flags

  The machine model states the carry and overflow flags of an addition or subtraction in
  integers: the flag is set when the result, read as an integer, is not the integer sum.
  These lemmas restate each as the overflow predicate of bitvectors, which `bv_decide`
  decides.

  ## Main results

  * `uadd_ne`, `sadd_ne`: the carry and overflow of an addition
  * `usub_ne`, `ssub_ne`: the borrow and overflow of a subtraction
  * `cpop_eq`: the model's population count is the library's
-/

module

public import Kraken.X64.Semantics

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

theorem cpop_eq {w : Nat} (x : BitVec w) : x.cpop_ = x.cpop := by
  have key : ∀ pos acc, x.cpopNatRec_ pos acc = x.cpopNatRec pos acc := by
    intro pos
    induction pos with
    | zero => intro acc; rfl
    | succ n ih => intro acc; simp only [BitVec.cpopNatRec_, BitVec.cpopNatRec, ih]
  simp only [BitVec.cpop_, BitVec.cpop, key]

end Lowering.X86
