/-
  Examples.Limbs.Common

  The specification of `limbs.c`, multi-limb addition, the second rung of the scaling ladder
  (`docs/Scaling.md`): a number is a list of 64-bit limbs, least significant first, and
  `addLimbs` adds two of them with a carry, limb by limb, as the loop does. The functions
  are about words and lists and know nothing of any instruction set.

  ## Main definitions

  * `limbsVal`: the natural number a list of limbs stands for
  * `carryOut`, `addLimbs`: the carry out of one limb, and the sum of two lists of limbs

  ## Main results

  * `addLimbs_val`: `addLimbs` adds the numbers: the value of the result, with the carry out
    above it, is the sum of the values of the arguments and the carry in
  * `wordsAtoms_disj`: the memory atoms of two arrays of words that are apart are disjoint
  * `interp_arrays`, `forall_arrays`, `pairwise_arrays`: a state that ends in three arrays,
    written out as memory atoms for a theorem about a machine
-/

module

public import Braid

@[expose] public section

namespace Examples.Limbs

open Braid

/-- The natural number a list of 64-bit limbs stands for, least significant limb first. -/
def limbsVal : List Word → Nat
  | [] => 0
  | x :: xs => x.toNat + 2 ^ 64 * limbsVal xs

/-- The carry out of adding the limbs `a` and `b` and the carry `c`, as the source computes
it: one if either of the two additions wraps around. -/
def carryOut (a b c : Word) : Word :=
  if (a + c).ult c || (a + c + b).ult (a + c) then 1#64 else 0#64

/-- The sum of two lists of limbs and a carry, limb by limb from the least significant: the
limbs of the sum, and the carry out. The lists are meant to have the same length; the sum
stops with the shorter. -/
def addLimbs : List Word → List Word → Word → List Word × Word
  | a :: as, b :: bs, c =>
    ((a + c + b) :: (addLimbs as bs (carryOut a b c)).1, (addLimbs as bs (carryOut a b c)).2)
  | [], _, c => ([], c)
  | _ :: _, [], c => ([], c)

theorem addLimbs_cons (a b c : Word) (as bs : List Word) :
    addLimbs (a :: as) (b :: bs) c =
      ((a + c + b) :: (addLimbs as bs (carryOut a b c)).1,
        (addLimbs as bs (carryOut a b c)).2) := rfl

theorem addLimbs_nil (bs : List Word) (c : Word) : addLimbs [] bs c = ([], c) := rfl

/-- The sum has as many limbs as its arguments. -/
theorem addLimbs_length : ∀ (as bs : List Word) (c : Word), as.length = bs.length →
    (addLimbs as bs c).1.length = as.length
  | [], _, _, _ => rfl
  | _ :: _, [], _, h => by simp at h
  | a :: as, b :: bs, c, h => by
    simp only [addLimbs_cons, List.length_cons]
    rw [addLimbs_length as bs _ (by simpa using h)]

/-- The carry out of one limb is zero or one. -/
theorem carryOut_le (a b c : Word) : (carryOut a b c).toNat ≤ 1 := by
  unfold carryOut
  split <;> simp

/-- **One limb.** With a carry in of zero or one, the sum limb, with the carry out above
it, is the sum of the two limbs and the carry in. -/
theorem add_limb_val (a b c : Word) (hc : c.toNat ≤ 1) :
    (a + c + b).toNat + 2 ^ 64 * (carryOut a b c).toNat = a.toNat + b.toNat + c.toNat := by
  have ha := a.isLt
  have hb := b.isLt
  unfold carryOut
  split
  next h =>
    simp only [Bool.or_eq_true, BitVec.ult, decide_eq_true_eq, BitVec.toNat_add] at h
    simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  next h =>
    simp only [Bool.or_eq_true, BitVec.ult, decide_eq_true_eq, BitVec.toNat_add, not_or,
      Nat.not_lt] at h
    simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
    omega

/-- The carry out of a sum, begun with a carry of zero or one, is zero or one. -/
theorem addLimbs_carry_le : ∀ (as bs : List Word) (c : Word), c.toNat ≤ 1 →
    (addLimbs as bs c).2.toNat ≤ 1
  | [], _, _, h => h
  | _ :: _, [], _, h => h
  | a :: as, b :: bs, c, _ => addLimbs_carry_le as bs _ (carryOut_le a b c)

/-- **`addLimbs` adds.** For two numbers of `n` limbs and a carry in of zero or one, the
value of the sum's limbs, with the carry out at `2 ^ (64 * n)`, is the sum of the values of
the arguments and the carry in. -/
theorem addLimbs_val : ∀ (as bs : List Word) (c : Word), as.length = bs.length →
    c.toNat ≤ 1 →
    limbsVal (addLimbs as bs c).1 + 2 ^ (64 * as.length) * (addLimbs as bs c).2.toNat =
      limbsVal as + limbsVal bs + c.toNat
  | [], [], c, _, _ => by simp [addLimbs_nil, limbsVal]
  | [], _ :: _, _, h, _ => by simp at h
  | _ :: _, [], _, h, _ => by simp at h
  | a :: as, b :: bs, c, h, hc => by
    have ih := addLimbs_val as bs (carryOut a b c) (by simpa using h) (carryOut_le a b c)
    have h1 := add_limb_val a b c hc
    have e : 2 ^ (64 * (as.length + 1)) = 2 ^ 64 * 2 ^ (64 * as.length) := by
      rw [Nat.mul_succ, Nat.pow_add, Nat.mul_comm]
    simp only [addLimbs_cons, limbsVal, List.length_cons, e]
    generalize limbsVal (addLimbs as bs (carryOut a b c)).1 = R at ih ⊢
    generalize (addLimbs as bs (carryOut a b c)).2.toNat = K at ih ⊢
    generalize 2 ^ (64 * as.length) = P at ih ⊢
    generalize limbsVal as = A at ih ⊢
    generalize limbsVal bs = B at ih ⊢
    have e2 : 2 ^ 64 * P * K = 2 ^ 64 * (P * K) := Nat.mul_assoc ..
    rw [e2]
    generalize P * K = PK at ih ⊢
    omega

/-- The value of a number of `n` limbs is below `2 ^ (64 * n)`. -/
theorem limbsVal_lt : ∀ xs : List Word, limbsVal xs < 2 ^ (64 * xs.length)
  | [] => by simp [limbsVal]
  | x :: xs => by
    have ih := limbsVal_lt xs
    have hx := x.isLt
    have e : 2 ^ (64 * (xs.length + 1)) = 2 ^ 64 * 2 ^ (64 * xs.length) := by
      rw [Nat.mul_succ, Nat.pow_add, Nat.mul_comm]
    simp only [limbsVal, List.length_cons, e]
    generalize 2 ^ (64 * xs.length) = P at ih ⊢
    generalize limbsVal xs = V at ih ⊢
    have : 2 ^ 64 * (V + 1) ≤ 2 ^ 64 * P := Nat.mul_le_mul_left _ ih
    omega

/-! ## Three arrays, written out

What a theorem about a machine needs when the precondition ends in three arrays of words:
the state with the arrays written out as memory atoms, and the side conditions of
`machine_sound_flat` for it. -/

/-- An atom of a list is at some place in it. -/
theorem at_of_mem {as : Atoms} {a : Atom} (h : a ∈ as) : as.At a := by
  induction as with
  | nil => cases h
  | cons b as ih =>
    rcases List.mem_cons.1 h with rfl | h
    · exact .here
    · exact .there (ih h)

/-- The atoms of an array of words are those of an array of eight-byte cells. -/
theorem wordsAtoms_eq_cellsAtoms : ∀ (p : Word) (xs : List Word),
    wordsAtoms p xs = cellsAtoms 8 true p xs
  | _, [] => rfl
  | p, x :: xs => congrArg (Atom.mem p 8 x true :: ·) (wordsAtoms_eq_cellsAtoms (p + 8#64) xs)

/-- The atoms of two arrays of words are disjoint when each array starts at or beyond the
end of the other, going round the address space. -/
theorem wordsAtoms_disj {p q : Word} {xs ys : List Word}
    (hx : 8 * xs.length ≤ (q - p).toNat) (hy : 8 * ys.length ≤ (p - q).toNat) :
    ∀ a ∈ wordsAtoms p xs, ∀ b ∈ wordsAtoms q ys, Atom.Disj a b := by
  rw [wordsAtoms_eq_cellsAtoms, wordsAtoms_eq_cellsAtoms]
  exact cellsAtoms_disj hx hy

/-- A state with a tail written out is the state. -/
theorem flat_append (l : Atoms) {rest flat : Atoms} (h : Flat rest flat) :
    Flat (l ++ rest) (l ++ flat) := by
  induction l with
  | nil => exact h
  | cons a l ih => exact .atom ih

/-- A state that ends in three arrays of words means the same with the arrays written
out. -/
theorem interp_arrays (l : Atoms) (p₁ p₂ p₃ : Word) (xs₁ xs₂ xs₃ : List Word) :
    Atoms.interp (l ++ [.prop (wordsAt p₁ xs₁), .prop (wordsAt p₂ xs₂),
      .prop (wordsAt p₃ xs₃)]) =
    Atoms.interp (l ++ (wordsAtoms p₁ xs₁ ++ (wordsAtoms p₂ xs₂ ++ (wordsAtoms p₃ xs₃ ++ [])))) :=
  (flat_append l (.words (.words (.words .nil)))).interp

/-- A state that ends in three arrays of words holds with the arrays written out. -/
theorem holds_arrays {l : Atoms} {p₁ p₂ p₃ : Word} {xs₁ xs₂ xs₃ : List Word} {R : SProp}
    {σ : State}
    (h : (Atoms.interp (l ++ [.prop (wordsAt p₁ xs₁), .prop (wordsAt p₂ xs₂),
      .prop (wordsAt p₃ xs₃)])).holds R σ) :
    (Atoms.interp (l ++ (wordsAtoms p₁ xs₁ ++ (wordsAtoms p₂ xs₂ ++
      (wordsAtoms p₃ xs₃ ++ []))))).holds R σ := by
  rw [← interp_arrays]; exact h

/-- A property of every atom of a state that ends in three lists of atoms. -/
theorem forall_arrays {l m₁ m₂ m₃ : Atoms} {P : Atom → Prop} (hl : ∀ a ∈ l, P a)
    (h₁ : ∀ a ∈ m₁, P a) (h₂ : ∀ a ∈ m₂, P a) (h₃ : ∀ a ∈ m₃, P a) :
    ∀ a ∈ l ++ (m₁ ++ (m₂ ++ (m₃ ++ []))), P a := by
  intro a ha
  simp only [List.mem_append, List.not_mem_nil, or_false] at ha
  rcases ha with ha | ha | ha | ha
  · exact hl a ha
  · exact h₁ a ha
  · exact h₂ a ha
  · exact h₃ a ha

/-- Disjointness of a state that ends in three lists of atoms: each part is pairwise
disjoint, and each atom of a part is disjoint from each atom of a later part. -/
theorem pairwise_arrays {l m₁ m₂ m₃ : Atoms} (hl : l.Pairwise Atom.Disj)
    (h₁ : m₁.Pairwise Atom.Disj) (h₂ : m₂.Pairwise Atom.Disj) (h₃ : m₃.Pairwise Atom.Disj)
    (hl₁ : ∀ a ∈ l, ∀ b ∈ m₁, Atom.Disj a b) (hl₂ : ∀ a ∈ l, ∀ b ∈ m₂, Atom.Disj a b)
    (hl₃ : ∀ a ∈ l, ∀ b ∈ m₃, Atom.Disj a b) (h₁₂ : ∀ a ∈ m₁, ∀ b ∈ m₂, Atom.Disj a b)
    (h₁₃ : ∀ a ∈ m₁, ∀ b ∈ m₃, Atom.Disj a b) (h₂₃ : ∀ a ∈ m₂, ∀ b ∈ m₃, Atom.Disj a b) :
    (l ++ (m₁ ++ (m₂ ++ (m₃ ++ [])))).Pairwise Atom.Disj := by
  simp only [List.append_nil, List.pairwise_append, List.mem_append]
  refine ⟨hl, ⟨h₁, ⟨h₂, h₃, h₂₃⟩, fun a ha b hb => ?_⟩, fun a ha b hb => ?_⟩
  · rcases hb with hb | hb
    · exact h₁₂ a ha b hb
    · exact h₁₃ a ha b hb
  · rcases hb with hb | hb | hb
    · exact hl₁ a ha b hb
    · exact hl₂ a ha b hb
    · exact hl₃ a ha b hb

end Examples.Limbs
