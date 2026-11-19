/-
  Examples.Mem.EqualCt

  What the proofs about `equal_bytes_ct` share, on every instruction set.

  `equal_bytes_ct` does not compare its bytes one pair at a time: it gathers, by OR, the XOR
  of each pair into one byte, and compares that byte with zero at the end. `orDiff d as bs`
  is that byte, from the byte `d` gathered so far, and it is zero exactly when `d` is zero
  and the two lists are the same.

  ## Main definitions

  * `orDiff d as bs`: `d`, with the XOR of each pair of `as` and `bs` ORed into it

  ## Main results

  * `orDiff_eq_zero`: `orDiff d as bs` is zero exactly when `d` is zero and `as = bs`
  * `orDiff_zero`: `orDiff 0 as bs` is zero exactly when `as = bs`
-/

module

public import Braid

@[expose] public section

namespace Examples.Mem

/-- The byte `d`, with the XOR of each pair of bytes of the two lists ORed into it. -/
def orDiff (d : BitVec 8) : List (BitVec 8) → List (BitVec 8) → BitVec 8
  | a :: as, b :: bs => orDiff (d ||| (a ^^^ b)) as bs
  | _, _ => d

theorem orDiff_cons (d a b : BitVec 8) (as bs : List (BitVec 8)) :
    orDiff d (a :: as) (b :: bs) = orDiff (d ||| (a ^^^ b)) as bs := rfl

theorem orDiff_nil (d : BitVec 8) : orDiff d [] [] = d := rfl

/-- A byte with the XOR of two bytes ORed into it is zero exactly when it was zero and the
two bytes are the same. -/
theorem or_xor_eq_zero (d a b : BitVec 8) : d ||| (a ^^^ b) = 0#8 ↔ d = 0#8 ∧ a = b := by
  constructor
  · intro h
    constructor <;> bv_decide
  · rintro ⟨rfl, rfl⟩
    simp

/-- **What the gathered byte says.** For lists of the same length, it is zero exactly when
the byte gathered before them was zero and the lists are the same. -/
theorem orDiff_eq_zero : ∀ (as bs : List (BitVec 8)) (d : BitVec 8), bs.length = as.length →
    (orDiff d as bs = 0#8 ↔ d = 0#8 ∧ as = bs)
  | [], [], d, _ => by simp [orDiff]
  | [], _ :: _, _, h => by simp at h
  | _ :: _, [], _, h => by simp at h
  | a :: as, b :: bs, d, h => by
    rw [orDiff_cons, orDiff_eq_zero as bs _ (by simpa using h), or_xor_eq_zero,
      List.cons.injEq, and_assoc]

/-- From nothing gathered, the gathered byte of two lists of the same length is zero exactly
when they are the same. -/
theorem orDiff_zero (as bs : List (BitVec 8)) (h : bs.length = as.length) :
    orDiff 0#8 as bs = 0#8 ↔ as = bs := by
  rw [orDiff_eq_zero as bs _ h]
  exact and_iff_right rfl

end Examples.Mem
