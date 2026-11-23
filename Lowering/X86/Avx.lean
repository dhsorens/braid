/-
  Lowering.X86.Avx

  The vector instructions, each lowered soundly: the moves between vector registers and
  memory, the moves between general and vector registers, the packed 32-bit addition, the
  rotation and the shift of 32-bit lanes by an immediate, the bitwise function of three
  vectors given by a truth table, the shuffles of 32-bit lanes and of bytes, the blend of
  16-bit lanes, the shift of bytes across two vectors, and the three SHA-256 instructions. A
  piece of a block (reading a vector operand, writing one, an alignment check, the operation
  on the words) is related to the model's function for the same thing, and an instruction is
  those lemmas in order.

  ## Main definitions

  * `AvxSound`: a vector instruction is lowered soundly

  ## Main results

  * `readVec_sound`, `writeVec_sound`: vector operands
  * `wp_zipWords`, `wp_constWords`: a run of operations, one for each word
  * `wp_rorWords`, `wp_shrWords`, `wp_ternWords`, `wp_shufWords`, `wp_blendWords`,
    `wp_alignWords`, `wp_bshufWords`: the operation on the words
  * `wp_msg1Words`, `wp_msg2Words`, `wp_rnds2Words`: the two result words of a SHA-256
    instruction
  * `lowerAvx_sound`: every vector instruction
-/

module

public import Lowering.X86.Vec
import Std.Tactic.BVDecide
import Braid.BV

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env wpOps State ofBool)

variable {s : MachineData} {σ : State} {ρ : Env} {Q : Env → State → Prop}

/-! ## Runs of operations -/

/-- `Env.set_other`, with the values as natural numbers. -/
theorem set_ne (ρ : Env) {x y : Nat} (v : Word) (h : y ≠ x) : ρ.set x v y = ρ y :=
  Env.set_other ρ v h

theorem getRegs_succ (n r k : Nat) :
    getRegs n r (k + 1) = getRegs n r k ++ [.get (n + k) (r + k)] := by
  simp [getRegs, List.range_succ]

theorem setRegs_succ (r : Nat) (g : Nat → Var) (k : Nat) :
    setRegs r g (k + 1) = setRegs r g k ++ [.set (r + k) (g k)] := by
  simp [setRegs, List.range_succ]

theorem binWords_succ (d : Var) (op : BinOp) (a b : Var) (k : Nat) :
    binWords d op a b (k + 1) = binWords d op a b k ++ [.bin (d + k) op (a + k) (b + k)] := by
  simp [binWords, List.range_succ]

theorem loadWords_succ (n a t k : Nat) :
    loadWords n a t (k + 1) = loadWords n a t k ++
      [.const (t + 2 * k) (BitVec.ofNat 64 (8 * k)), .bin (t + 2 * k + 1) .add a (t + 2 * k),
        .load (n + k) .w64 (t + 2 * k + 1)] := by
  simp [loadWords, List.range_succ]

theorem storeWords_succ (a t v k : Nat) :
    storeWords a t v (k + 1) = storeWords a t v k ++
      [.const (t + 2 * k) (BitVec.ofNat 64 (8 * k)), .bin (t + 2 * k + 1) .add a (t + 2 * k),
        .store .w64 (t + 2 * k + 1) (v + k)] := by
  simp [storeWords, List.range_succ]

theorem wp_getRegs {n r k : Nat} (hw : wpOps (getRegs n r k) ρ σ Q) :
    ∃ ρ', Agree n ρ ρ' ∧ (∀ j, j < k → ρ' (n + j) = σ.regs (r + j)) ∧ Q ρ' σ := by
  induction k generalizing Q with
  | zero => exact ⟨ρ, Agree.refl _ _, fun j hj => absurd hj (Nat.not_lt_zero j), hw⟩
  | succ k ih =>
    rw [getRegs_succ, Braid.wpOps_append] at hw
    obtain ⟨ρ1, hag, hv, hq⟩ := ih hw
    simp only [wpOps, Op.wp] at hq
    refine ⟨_, hag.set (by omega) _, fun j hj => ?_, hq⟩
    by_cases hjk : j = k
    · subst hjk; rw [Env.set_same]
    · rw [set_ne _ _ (by omega), hv j (by omega)]

theorem wp_setRegs {r : Nat} {g : Nat → Var} {k : Nat} (hw : wpOps (setRegs r g k) ρ σ Q) :
    Q ρ (setWords σ r (fun j => ρ (g j)) k) := by
  induction k generalizing Q with
  | zero => rw [setWords_zero]; exact hw
  | succ k ih =>
    rw [setRegs_succ, Braid.wpOps_append] at hw
    rw [setWords_succ]
    exact ih hw

theorem wp_binWords {d a b k : Nat} {op : BinOp} (ha : a + k ≤ d) (hb : b + k ≤ d)
    (hw : wpOps (binWords d op a b k) ρ σ Q) :
    ∃ ρ', Agree d ρ ρ' ∧ (∀ j, j < k → ρ' (d + j) = op.eval (ρ (a + j)) (ρ (b + j))) ∧
      Q ρ' σ := by
  induction k generalizing Q with
  | zero => exact ⟨ρ, Agree.refl _ _, fun j hj => absurd hj (Nat.not_lt_zero j), hw⟩
  | succ k ih =>
    rw [binWords_succ, Braid.wpOps_append] at hw
    obtain ⟨ρ1, hag, hv, hq⟩ := ih (by omega) (by omega) hw
    simp only [wpOps, Op.wp] at hq
    rw [hag (a + k) (by omega), hag (b + k) (by omega)] at hq
    refine ⟨_, hag.set (by omega) _, fun j hj => ?_, hq⟩
    by_cases hjk : j = k
    · subst hjk; rw [Env.set_same]
    · rw [set_ne _ _ (by omega), hv j (by omega)]

theorem zipWords_succ (d : Var) (op : BinOp) (fa fb : Nat → Var) (k : Nat) :
    zipWords d op fa fb (k + 1) = zipWords d op fa fb k ++ [.bin (d + k) op (fa k) (fb k)] := by
  simp [zipWords, List.range_succ]

theorem constWords_succ (n : Var) (f : Nat → Word) (k : Nat) :
    constWords n f (k + 1) = constWords n f k ++ [.const (n + k) (f k)] := by
  simp [constWords, List.range_succ]

/-- A run of operations on pairs of earlier values sets the values `d` to `d + k - 1`, each
to the operation on its pair, and no other. -/
theorem wp_zipWords {d k : Nat} {op : BinOp} {fa fb : Nat → Nat}
    (h : ∀ j, j < k → fa j < d ∧ fb j < d) (hw : wpOps (zipWords d op fa fb k) ρ σ Q) :
    ∃ ρ', (∀ x : Nat, ¬ (d ≤ x ∧ x < d + k) → ρ' x = ρ x) ∧
      (∀ j, j < k → ρ' (d + j) = op.eval (ρ (fa j)) (ρ (fb j))) ∧ Q ρ' σ := by
  induction k generalizing Q with
  | zero => exact ⟨ρ, fun _ _ => rfl, fun j hj => absurd hj (Nat.not_lt_zero j), hw⟩
  | succ k ih =>
    rw [zipWords_succ, Braid.wpOps_append] at hw
    obtain ⟨ρ1, hf, hv, hq⟩ := ih (fun j hj => h j (by omega)) hw
    obtain ⟨ha, hb⟩ := h k (by omega)
    simp only [wpOps, Op.wp] at hq
    rw [hf (fa k) (by omega), hf (fb k) (by omega)] at hq
    refine ⟨_, fun x hx => ?_, fun j hj => ?_, hq⟩
    · rw [set_ne _ _ (by omega), hf x (by omega)]
    · by_cases hjk : j = k
      · subst hjk; rw [Env.set_same]
      · rw [set_ne _ _ (by omega), hv j (by omega)]

/-- A run of constants sets the values `n` to `n + k - 1`, and no other. -/
theorem wp_constWords {n k : Nat} {f : Nat → Word} (hw : wpOps (constWords n f k) ρ σ Q) :
    ∃ ρ', (∀ x : Nat, ¬ (n ≤ x ∧ x < n + k) → ρ' x = ρ x) ∧
      (∀ j, j < k → ρ' (n + j) = f j) ∧ Q ρ' σ := by
  induction k generalizing Q with
  | zero => exact ⟨ρ, fun _ _ => rfl, fun j hj => absurd hj (Nat.not_lt_zero j), hw⟩
  | succ k ih =>
    rw [constWords_succ, Braid.wpOps_append] at hw
    obtain ⟨ρ1, hf, hv, hq⟩ := ih hw
    simp only [wpOps, Op.wp] at hq
    refine ⟨_, fun x hx => ?_, fun j hj => ?_, hq⟩
    · rw [set_ne _ _ (by omega), hf x (by omega)]
    · by_cases hjk : j = k
      · subst hjk; rw [Env.set_same]
      · rw [set_ne _ _ (by omega), hv j (by omega)]

/-! ## Operations on the words of a vector -/

/-- The rotation of lanes sets the values 80 up to `rorLanes` of the words in the values 0
up. -/
theorem wp_rorWords {c : BitVec 8} {k : Nat} (hk : k ≤ 8) (hw : wpOps (rorWords c k) ρ σ Q) :
    ∃ ρ', Agree 40 ρ ρ' ∧ (∀ j, j < k → ρ' (80 + j) = rorLanes c (ρ (0 + j))) ∧
      Q ρ' σ := by
  simp only [rorWords, List.cons_append, List.nil_append, Braid.wpOps_append, wpOps, Op.wp]
    at hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ3, f3, v3, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ4, f4, v4, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ5, f5, v5, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  refine ⟨ρ5, fun x hx => ?_, fun j hj => ?_, hw⟩
  · simp (disch := omega) only [f5, f4, f3, f2, f1, set_ne]
  · simp (disch := omega) only [v5, v4, v3, v2, v1, f4, f3, f2, f1, set_ne, Env.set_same,
      BinOp.eval_or, BinOp.eval_and, BinOp.eval_shl, BinOp.eval_lshr]
    rfl

/-- The shift of lanes sets the values 56 up to `shrLanes` of the words in the values 0
up. -/
theorem wp_shrWords {c : BitVec 8} {k : Nat} (hk : k ≤ 8) (hw : wpOps (shrWords c k) ρ σ Q) :
    ∃ ρ', Agree 40 ρ ρ' ∧ (∀ j, j < k → ρ' (56 + j) = shrLanes c (ρ (0 + j))) ∧
      Q ρ' σ := by
  simp only [shrWords, List.cons_append, List.nil_append, Braid.wpOps_append, wpOps, Op.wp]
    at hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  refine ⟨ρ2, fun x hx => ?_, fun j hj => ?_, hw⟩
  · simp (disch := omega) only [f2, f1, set_ne]
  · simp (disch := omega) only [v2, v1, f1, set_ne, Env.set_same, BinOp.eval_and,
      BinOp.eval_lshr]
    rfl

/-- The bitwise function with the truth table `t` sets the values 256 up to the model's
function of the words in the values 80 up, 40 up and 0 up. -/
theorem wp_ternWords {t : BitVec 8} {k : Nat} (hk : k ≤ 8) (hw : wpOps (ternWords t k) ρ σ Q) :
    ∃ ρ', Agree 120 ρ ρ' ∧
      (∀ j, j < k → ρ' (256 + j) =
        BitVec.ternaryLogic (ρ (80 + j)) (ρ (40 + j)) (ρ (0 + j)) t) ∧ Q ρ' σ := by
  unfold ternWords at hw
  split at hw
  · obtain ⟨ρ1, f1, v1, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
    refine ⟨ρ1, fun x hx => f1 x (by omega), fun j hj => ?_, hw⟩
    subst t
    rw [v1 j hj, ternaryLogic_5a, BinOp.eval_xor]
  split at hw
  · obtain ⟨ρ1, f1, v1, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
    refine ⟨ρ1, fun x hx => f1 x (by omega), fun j hj => ?_, hw⟩
    subst t
    rw [v1 j hj, ternaryLogic_3c, BinOp.eval_xor]
  split at hw
  · obtain ⟨ρ1, f1, v1, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
    refine ⟨ρ1, fun x hx => f1 x (by omega), fun j hj => ?_, hw⟩
    subst t
    rw [v1 j hj, ternaryLogic_66, BinOp.eval_xor]
  split at hw
  · rw [Braid.wpOps_append] at hw
    obtain ⟨ρ1, f1, v1, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
    obtain ⟨ρ2, f2, v2, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
    refine ⟨ρ2, fun x hx => ?_, fun j hj => ?_, hw⟩
    · rw [f2 x (by omega), f1 x (by omega)]
    · subst t
      rw [v2 j hj, v1 j hj, f1 _ (by omega), ternaryLogic_96, BinOp.eval_xor, BinOp.eval_xor]
  simp only [List.cons_append, List.nil_append, Braid.wpOps_append, wpOps, Op.wp] at hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ3, f3, v3, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ4, f4, v4, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ5, f5, v5, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ6, f6, v6, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ7, f7, v7, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ8, f8, v8, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ9, f9, v9, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ10, f10, v10, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ11, f11, v11, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ12, f12, v12, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ13, f13, v13, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ14, f14, v14, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ15, f15, v15, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ16, f16, v16, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ17, f17, v17, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  refine ⟨ρ17, fun x hx => ?_, fun j hj => ?_, hw⟩
  · simp (disch := omega) only [f17, f16, f15, f14, f13, f12, f11, f10, f9, f8, f7, f6, f5, f4,
      f3, f2, f1, set_ne]
  · simp (disch := omega) only [v17, v16, v15, v14, v13, v12, v11, v10, v9, v8, v7, v6, v5, v4,
      v3, v2, v1, f16, f15, f14, f13, f12, f11, f10, f9, f8, f7, f6, f5, f4, f3, f2, f1,
      set_ne, Env.set_same, BinOp.eval_and, BinOp.eval_xor]
    rw [ternaryLogic_eq_ternLanes]
    rfl

theorem shufLane_div_lt (imm : BitVec 8) {i k : Nat} (hi : i < 2 * k) (hk : k % 2 = 0) :
    shufLane imm i / 2 < k := by
  simp only [shufLane]
  omega

/-- The shuffle of lanes sets the values 96 up, each half of a word to the half of a word in
the values 0 up that `shufLane` names. -/
theorem wp_shufWords {imm : BitVec 8} {k : Nat} (hk : k ≤ 8) (hk2 : k % 2 = 0)
    (hw : wpOps (shufWords imm k) ρ σ Q) :
    ∃ ρ', Agree 40 ρ ρ' ∧
      (∀ j, j < k → ρ' (96 + j) =
        (ρ (0 + shufLane imm (2 * j) / 2) >>>
            BitVec.ofNat 64 (32 * (shufLane imm (2 * j) % 2)) &&& 0xffffffff#64) |||
          (ρ (0 + shufLane imm (2 * j + 1) / 2) >>>
            BitVec.ofNat 64 (32 * (shufLane imm (2 * j + 1) % 2))) <<< 32#64) ∧ Q ρ' σ := by
  have hl0 : ∀ j, j < k → shufLane imm (2 * j) / 2 < 8 := fun j hj =>
    Nat.lt_of_lt_of_le (shufLane_div_lt imm (by omega) hk2) hk
  have hl1 : ∀ j, j < k → shufLane imm (2 * j + 1) / 2 < 8 := fun j hj =>
    Nat.lt_of_lt_of_le (shufLane_div_lt imm (by omega) hk2) hk
  simp only [shufWords, List.cons_append, List.nil_append, Braid.wpOps_append, wpOps, Op.wp]
    at hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_constWords hw
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_constWords hw
  obtain ⟨ρ3, f3, v3, hw⟩ := wp_zipWords
    (fun j hj => ⟨by have := hl0 j hj; omega, by omega⟩) hw
  obtain ⟨ρ4, f4, v4, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ5, f5, v5, hw⟩ := wp_zipWords
    (fun j hj => ⟨by have := hl1 j hj; omega, by omega⟩) hw
  obtain ⟨ρ6, f6, v6, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ7, f7, v7, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  refine ⟨ρ7, fun x hx => ?_, fun j hj => ?_, hw⟩
  · simp (disch := omega) only [f7, f6, f5, f4, f3, f2, f1, set_ne]
  · have h0 := hl0 j hj
    have h1 := hl1 j hj
    simp (disch := omega) only [v7, v6, v5, v4, v3, v2, v1, f6, f5, f4, f3, f2, f1, set_ne,
      Env.set_same, BinOp.eval_or, BinOp.eval_and, BinOp.eval_shl, BinOp.eval_lshr]
    rfl

/-- The blend of lanes sets the values 104 up, each to a choice by `blendMask` between a word
in the values 40 up and a word in the values 0 up. -/
theorem wp_blendWords {imm : BitVec 8} {k : Nat} (hk : k ≤ 8)
    (hw : wpOps (blendWords imm k) ρ σ Q) :
    ∃ ρ', Agree 80 ρ ρ' ∧
      (∀ j, j < k → ρ' (104 + j) =
        ρ (40 + j) ^^^ ((ρ (40 + j) ^^^ ρ (0 + j)) &&& blendMask imm j)) ∧ Q ρ' σ := by
  simp only [blendWords, Braid.wpOps_append] at hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_constWords hw
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ3, f3, v3, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ4, f4, v4, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  refine ⟨ρ4, fun x hx => ?_, fun j hj => ?_, hw⟩
  · simp (disch := omega) only [f4, f3, f2, f1]
  · simp (disch := omega) only [v4, v3, v2, v1, f3, f2, f1, BinOp.eval_and, BinOp.eval_xor]

/-- Word `q` of the block of word `j`, of two of the values 0 up below two of the values 40
up; zero above them. -/
def alignVal (ρ : Env) (j q : Nat) : Word :=
  if q < 2 then ρ (0 + (2 * (j / 2) + q))
  else if q < 4 then ρ (40 + (2 * (j / 2) + q - 2)) else 0#64

theorem set_alignVar (ρ : Env) {j : Nat} (hj : j < 8) (q : Nat) :
    (ρ.set 80 0#64) (alignVar j q) = alignVal ρ j q := by
  unfold alignVar alignVal
  split
  · rw [set_ne _ _ (by omega)]
  · split
    · rw [set_ne _ _ (by omega)]
    · rw [Env.set_same]

theorem alignVar_le {j : Nat} (hj : j < 8) (q : Nat) : alignVar j q ≤ 80 := by
  unfold alignVar
  split
  · omega
  · split <;> omega

/-- The shift of bytes sets the values 120 up, each to two words of its block, shifted and
or-ed. -/
theorem wp_alignWords {n k : Nat} (hk : k ≤ 8) (hw : wpOps (alignWords n k) ρ σ Q) :
    ∃ ρ', Agree 80 ρ ρ' ∧
      (∀ j, j < k → ρ' (120 + j) =
        alignVal ρ j (alignWord n j) >>> BitVec.ofNat 64 (8 * alignByte n j) |||
          alignVal ρ j (alignWord n j + 1) <<< BitVec.ofNat 64 (64 - 8 * alignByte n j)) ∧
      Q ρ' σ := by
  simp only [alignWords, List.cons_append, List.nil_append, Braid.wpOps_append, wpOps, Op.wp]
    at hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_constWords hw
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_constWords hw
  obtain ⟨ρ3, f3, v3, hw⟩ := wp_zipWords
    (fun j hj => ⟨Nat.lt_of_le_of_lt (alignVar_le (by omega) _) (by decide), by omega⟩) hw
  obtain ⟨ρ4, f4, v4, hw⟩ := wp_zipWords
    (fun j hj => ⟨Nat.lt_of_le_of_lt (alignVar_le (by omega) _) (by decide), by omega⟩) hw
  obtain ⟨ρ5, f5, v5, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  refine ⟨ρ5, fun x hx => ?_, fun j hj => ?_, hw⟩
  · simp (disch := omega) only [f5, f4, f3, f2, f1, set_ne]
  · have h0 := alignVar_le (j := j) (by omega) (alignWord n j)
    have h1 := alignVar_le (j := j) (by omega) (alignWord n j + 1)
    simp (disch := omega) only [v5, v4, v3, v2, v1, f4, f3, f2, f1, BinOp.eval_or,
      BinOp.eval_shl, BinOp.eval_lshr]
    rw [set_alignVar _ (j := j) (by omega), set_alignVar _ (j := j) (by omega)]

/-- One byte of the shuffle of bytes sets the values `n + 80` up, each to the word in the
values `n - 16` up or-ed with `bshufLane` of the words in the values 0 up and 40 up. -/
theorem wp_bshufByte {n b k : Nat} (hk : k ≤ 8) (hn : 112 ≤ n)
    (hc : ρ 80 = 0x8f#64 ∧ ρ 81 = 3#64 ∧ ρ 82 = 64#64 ∧ ρ 83 = 0xff#64)
    (hw : wpOps (bshufByte n b k) ρ σ Q) :
    ∃ ρ', (∀ x : Nat, x < n → ρ' x = ρ x) ∧
      (∀ j, j < k → ρ' (n + 80 + j) = ρ (n - 16 + j) |||
        bshufLane (ρ (0 + j)) (ρ (40 + 2 * (j / 2))) (ρ (40 + (2 * (j / 2) + 1))) b) ∧
      Q ρ' σ := by
  obtain ⟨c0, c1, c2, c3⟩ := hc
  simp only [bshufByte, List.cons_append, List.nil_append, Braid.wpOps_append, wpOps, Op.wp]
    at hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ3, f3, v3, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ4, f4, v4, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ5, f5, v5, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ6, f6, v6, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ7, f7, v7, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ8, f8, v8, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ9, f9, v9, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  obtain ⟨ρ10, f10, v10, hw⟩ := wp_zipWords (fun j hj => ⟨by omega, by omega⟩) hw
  refine ⟨ρ10, fun x hx => ?_, fun j hj => ?_, hw⟩
  · simp (disch := omega) only [f10, f9, f8, f7, f6, f5, f4, f3, f2, f1, set_ne]
  · simp (disch := omega) only [v10, v9, v8, v7, v6, v5, v4, v3, v2, v1, f9, f8, f7, f6, f5,
      f4, f3, f2, f1, set_ne, Env.set_same, c0, c1, c2, c3, BinOp.eval_or, BinOp.eval_and,
      BinOp.eval_shl, BinOp.eval_lshr, BinOp.eval_sub]
    rfl

/-- The shuffle of bytes sets the values 864 up, each to zero or-ed with `bshufLane` of each
of the eight bytes of a word in the values 0 up and the two words of its block in the values
40 up. -/
theorem wp_bshufWords {k : Nat} (hk : k ≤ 8) (hw : wpOps (bshufWords k) ρ σ Q) :
    ∃ ρ', Agree 80 ρ ρ' ∧
      (∀ j, j < k → ρ' (864 + j) =
        0#64 ||| bshufLane (ρ (0 + j)) (ρ (40 + 2 * (j / 2))) (ρ (40 + (2 * (j / 2) + 1))) 0
          ||| bshufLane (ρ (0 + j)) (ρ (40 + 2 * (j / 2))) (ρ (40 + (2 * (j / 2) + 1))) 1
          ||| bshufLane (ρ (0 + j)) (ρ (40 + 2 * (j / 2))) (ρ (40 + (2 * (j / 2) + 1))) 2
          ||| bshufLane (ρ (0 + j)) (ρ (40 + 2 * (j / 2))) (ρ (40 + (2 * (j / 2) + 1))) 3
          ||| bshufLane (ρ (0 + j)) (ρ (40 + 2 * (j / 2))) (ρ (40 + (2 * (j / 2) + 1))) 4
          ||| bshufLane (ρ (0 + j)) (ρ (40 + 2 * (j / 2))) (ρ (40 + (2 * (j / 2) + 1))) 5
          ||| bshufLane (ρ (0 + j)) (ρ (40 + 2 * (j / 2))) (ρ (40 + (2 * (j / 2) + 1))) 6
          ||| bshufLane (ρ (0 + j)) (ρ (40 + 2 * (j / 2))) (ρ (40 + (2 * (j / 2) + 1))) 7) ∧
      Q ρ' σ := by
  simp only [bshufWords, List.cons_append, List.nil_append, Braid.wpOps_append, wpOps, Op.wp]
    at hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_constWords hw
  obtain ⟨ρ2, g2, u2, hw⟩ := wp_bshufByte hk (by decide)
    (by simp (disch := omega) only [f1, set_ne, Env.set_same, and_self]) hw
  simp only [Nat.reduceAdd, Nat.reduceSub] at g2 u2
  obtain ⟨ρ3, g3, u3, hw⟩ := wp_bshufByte hk (by decide)
    (by simp (disch := omega) only [g2, f1, set_ne, Env.set_same, and_self]) hw
  simp only [Nat.reduceAdd, Nat.reduceSub] at g3 u3
  obtain ⟨ρ4, g4, u4, hw⟩ := wp_bshufByte hk (by decide)
    (by simp (disch := omega) only [g3, g2, f1, set_ne, Env.set_same, and_self]) hw
  simp only [Nat.reduceAdd, Nat.reduceSub] at g4 u4
  obtain ⟨ρ5, g5, u5, hw⟩ := wp_bshufByte hk (by decide)
    (by simp (disch := omega) only [g4, g3, g2, f1, set_ne, Env.set_same, and_self]) hw
  simp only [Nat.reduceAdd, Nat.reduceSub] at g5 u5
  obtain ⟨ρ6, g6, u6, hw⟩ := wp_bshufByte hk (by decide)
    (by simp (disch := omega) only [g5, g4, g3, g2, f1, set_ne, Env.set_same, and_self]) hw
  simp only [Nat.reduceAdd, Nat.reduceSub] at g6 u6
  obtain ⟨ρ7, g7, u7, hw⟩ := wp_bshufByte hk (by decide)
    (by simp (disch := omega) only [g6, g5, g4, g3, g2, f1, set_ne, Env.set_same, and_self]) hw
  simp only [Nat.reduceAdd, Nat.reduceSub] at g7 u7
  obtain ⟨ρ8, g8, u8, hw⟩ := wp_bshufByte hk (by decide)
    (by simp (disch := omega) only [g7, g6, g5, g4, g3, g2, f1, set_ne, Env.set_same, and_self]) hw
  simp only [Nat.reduceAdd, Nat.reduceSub] at g8 u8
  obtain ⟨ρ9, g9, u9, hw⟩ := wp_bshufByte hk (by decide)
    (by simp (disch := omega) only [g8, g7, g6, g5, g4, g3, g2, f1, set_ne, Env.set_same,
      and_self]) hw
  simp only [Nat.reduceAdd, Nat.reduceSub] at g9 u9
  refine ⟨ρ9, fun x hx => ?_, fun j hj => ?_, hw⟩
  · simp (disch := omega) only [g9, g8, g7, g6, g5, g4, g3, g2, f1, set_ne]
  · simp (disch := omega) only [u9, u8, u7, u6, u5, u4, u3, u2, g8, g7, g6, g5, g4, g3, g2, v1,
      f1, set_ne]

/-! ## SHA-256 -/

/-- The values `k` up hold the ten constants of `sigLanes r1 r2 s`. -/
def SigConsts (ρ : Env) (k : Nat) (r1 r2 s : BitVec 8) : Prop :=
  ρ k = rorCount r1 ∧ ρ (k + 1) = dup32 (0xffffffff#32 >>> rorCount r1) ∧
  ρ (k + 2) = 32#64 - rorCount r1 ∧
  ρ (k + 3) = dup32 (0xffffffff#32 <<< (32#64 - rorCount r1)) ∧
  ρ (k + 4) = rorCount r2 ∧ ρ (k + 5) = dup32 (0xffffffff#32 >>> rorCount r2) ∧
  ρ (k + 6) = 32#64 - rorCount r2 ∧
  ρ (k + 7) = dup32 (0xffffffff#32 <<< (32#64 - rorCount r2)) ∧
  ρ (k + 8) = s.zeroExtend 64 ∧ ρ (k + 9) = dup32 (0xffffffff#32 >>> s)

/-- The constants of a mixing of lanes are in the values `k` up, and no other value is
set. -/
theorem wp_sigConsts {k : Nat} {r1 r2 s : BitVec 8} (hw : wpOps (sigConsts k r1 r2 s) ρ σ Q) :
    ∃ ρ', (∀ y : Nat, ¬ (k ≤ y ∧ y < k + 10) → ρ' y = ρ y) ∧
      SigConsts ρ' k r1 r2 s ∧ Q ρ' σ := by
  simp only [sigConsts, wpOps, Op.wp] at hw
  refine ⟨_, fun y hy => ?_, ?_, hw⟩
  · simp (disch := omega) only [set_ne]
  · unfold SigConsts
    simp (disch := omega) only [set_ne, Env.set_same, and_self]

/-- The mixing of lanes and the addition set the value `d` to the value `a` plus, lane by
lane, `sigLanes` of the value `x`, and no other value outside `n` to `n + 13`. -/
theorem wp_sigOps {n k x d a : Nat} (r1 r2 s : BitVec 8) (hk : k + 10 ≤ n)
    (hx : ¬ (n ≤ x ∧ x < n + 14)) (ha : ¬ (n ≤ a ∧ a < n + 14)) (hd : n + 14 ≤ d)
    (hc : SigConsts ρ k r1 r2 s) (hw : wpOps (sigOps n k x d a) ρ σ Q) :
    ∃ ρ', (∀ y : Nat, ¬ (n ≤ y ∧ y < n + 14) → y ≠ d → ρ' y = ρ y) ∧
      ρ' d = (BinOp.lanes 32 .add).eval (ρ a) (sigLanes r1 r2 s (ρ x)) ∧ Q ρ' σ := by
  obtain ⟨c0, c1, c2, c3, c4, c5, c6, c7, c8, c9⟩ := hc
  simp only [sigOps, wpOps, Op.wp] at hw
  refine ⟨_, fun y hy hy' => ?_, ?_, hw⟩
  · simp (disch := omega) only [set_ne]
  · simp (disch := omega) only [set_ne, Env.set_same, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9,
      BinOp.eval_or, BinOp.eval_and, BinOp.eval_xor, BinOp.eval_shl, BinOp.eval_lshr]
    rfl

/-- The join sets the value `n + 3` to the high half of the value `x` below the low half of
the value `y`, and no value outside `n` to `n + 3`. -/
theorem wp_joinOps {n x y : Nat} (hx : x < n) (hy : y < n) (hw : wpOps (joinOps n x y) ρ σ Q) :
    ∃ ρ', (∀ z : Nat, ¬ (n ≤ z ∧ z < n + 4) → ρ' z = ρ z) ∧
      ρ' (n + 3) = ρ x >>> 32#64 ||| ρ y <<< 32#64 ∧ Q ρ' σ := by
  simp only [joinOps, wpOps, Op.wp] at hw
  refine ⟨_, fun z hz => ?_, ?_, hw⟩
  · simp (disch := omega) only [set_ne]
  · simp (disch := omega) only [set_ne, Env.set_same, BinOp.eval_or, BinOp.eval_shl,
      BinOp.eval_lshr]

/-- A round sets the value `n + 25` to `rndA` and the value `n + 26` to `rndE` of the values
it is given, and no value below `n`. -/
theorem wp_rndOps {n a b c d e f g h k : Nat} (hn : 89 ≤ n)
    (hin : a < n ∧ b < n ∧ c < n ∧ d < n ∧ e < n ∧ f < n ∧ g < n ∧ h < n ∧ k < n)
    (hc : ρ 81 = 32#64 ∧ ρ 82 = 6#64 ∧ ρ 83 = 11#64 ∧ ρ 84 = 25#64 ∧ ρ 85 = 2#64 ∧
      ρ 86 = 13#64 ∧ ρ 87 = 22#64)
    (hw : wpOps (rndOps n a b c d e f g h k) ρ σ Q) :
    ∃ ρ', (∀ y : Nat, y < n → ρ' y = ρ y) ∧
      ρ' (n + 25) = rndA (ρ a) (ρ b) (ρ c) (ρ e) (ρ f) (ρ g) (ρ h) (ρ k) ∧
      ρ' (n + 26) = rndE (ρ d) (ρ e) (ρ f) (ρ g) (ρ h) (ρ k) ∧ Q ρ' σ := by
  obtain ⟨c1, c2, c3, c4, c5, c6, c7⟩ := hc
  obtain ⟨ha, hb, hc, hd, he, hf, hg, hh, hk⟩ := hin
  simp only [rndOps, wpOps, Op.wp] at hw
  refine ⟨_, fun y hy => ?_, ?_, ?_, hw⟩
  · simp (disch := omega) only [set_ne]
  · simp (disch := omega) only [set_ne, Env.set_same, c1, c2, c3, c4, c5, c6, c7,
      BinOp.eval_or, BinOp.eval_and, BinOp.eval_xor, BinOp.eval_shl, BinOp.eval_lshr,
      BinOp.eval_add]
    rfl
  · simp (disch := omega) only [set_ne, Env.set_same, c1, c2, c3, c4, c5, c6, c7,
      BinOp.eval_or, BinOp.eval_and, BinOp.eval_xor, BinOp.eval_shl, BinOp.eval_lshr,
      BinOp.eval_add]
    rfl

/-- What the two rounds start from. -/
theorem wp_rnds2Pre (hw : wpOps rnds2Pre ρ σ Q) :
    ∃ ρ', Agree 80 ρ ρ' ∧ ρ' 80 = σ.regs (vecReg .mm0 0) ∧
      (ρ' 81 = 32#64 ∧ ρ' 82 = 6#64 ∧ ρ' 83 = 11#64 ∧ ρ' 84 = 25#64 ∧ ρ' 85 = 2#64 ∧
        ρ' 86 = 13#64 ∧ ρ' 87 = 22#64) ∧ ρ' 88 = 0xffffffff#64 ∧
      ρ' 90 = ρ 0 >>> 32#64 ∧ ρ' 91 = ρ 40 >>> 32#64 ∧ ρ' 92 = ρ 1 >>> 32#64 ∧
      ρ' 93 = ρ 41 >>> 32#64 ∧ ρ' 94 = σ.regs (vecReg .mm0 0) >>> 32#64 ∧ Q ρ' σ := by
  simp only [rnds2Pre, wpOps, Op.wp] at hw
  refine ⟨_, fun y hy => ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, hw⟩
  · simp (disch := omega) only [set_ne]
  all_goals simp (disch := omega) only [set_ne, Env.set_same, BinOp.eval_lshr, and_self]

theorem wp_rnds2Mask (hw : wpOps rnds2Mask ρ σ Q) :
    ∃ ρ', (∀ y : Nat, y ≠ 123 → y ≠ 124 → ρ' y = ρ y) ∧
      ρ' 123 = ρ 121 &&& ρ 88 ∧ ρ' 124 = ρ 122 &&& ρ 88 ∧ Q ρ' σ := by
  simp only [rnds2Mask, wpOps, Op.wp] at hw
  refine ⟨_, fun y h1 h2 => ?_, ?_, ?_, hw⟩
  all_goals simp (disch := omega) only [set_ne, Env.set_same, BinOp.eval_and]

theorem wp_rnds2Pack (hw : wpOps rnds2Pack ρ σ Q) :
    ∃ ρ', Agree 155 ρ ρ' ∧ ρ' 200 = ρ 124 ||| ρ 154 <<< ρ 81 ∧
      ρ' 201 = ρ 123 ||| ρ 153 <<< ρ 81 ∧
      (∀ y : Nat, 202 ≤ y → ρ' y = ρ y) ∧ Q ρ' σ := by
  simp only [rnds2Pack, wpOps, Op.wp] at hw
  refine ⟨_, fun y hy => ?_, ?_, ?_, fun y hy => ?_, hw⟩
  all_goals simp (disch := omega) only [set_ne, Env.set_same, BinOp.eval_or, BinOp.eval_shl]

/-- The operations of `sha256msg2` set the values 200 and 201 to `msg2Lo` and `msg2Hi`, and
the `k` values after them to zero. -/
theorem wp_msg2Words {k : Nat} (hw : wpOps (msg2Words k) ρ σ Q) :
    ∃ ρ', Agree 80 ρ ρ' ∧ ρ' 200 = msg2Lo (ρ 40) (ρ 1) ∧
      ρ' 201 = msg2Hi (ρ 41) (msg2Lo (ρ 40) (ρ 1)) ∧
      (∀ j, j < k → ρ' (202 + j) = 0#64) ∧ Q ρ' σ := by
  simp only [msg2Words, Braid.wpOps_append] at hw
  obtain ⟨ρ0, f0, hc, hw⟩ := wp_sigConsts hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_sigOps 17 19 10 (by omega) (by omega) (by omega) (by omega)
    hc hw
  obtain ⟨c0, c1, c2, c3, c4, c5, c6, c7, c8, c9⟩ := hc
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_sigOps 17 19 10 (by omega) (by omega) (by omega) (by omega)
    (by unfold SigConsts
        simp (disch := omega) only [f1, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, and_self]) hw
  obtain ⟨ρ3, f3, v3, hw⟩ := wp_constWords hw
  refine ⟨ρ3, fun x hx => ?_, ?_, ?_, v3, hw⟩
  · simp (disch := omega) only [f3, f2, f1, f0]
  · simp (disch := omega) only [f3, f2, f0, v1]
    rfl
  · simp (disch := omega) only [f3, f1, f0, v2, v1]
    rfl

/-- The operations of `sha256msg1` set the values 200 and 201 to `msg1Lo` and `msg1Hi`, and
the `k` values after them to zero. -/
theorem wp_msg1Words {k : Nat} (hw : wpOps (msg1Words k) ρ σ Q) :
    ∃ ρ', Agree 80 ρ ρ' ∧ ρ' 200 = msg1Lo (ρ 40) (ρ 41) ∧
      ρ' 201 = msg1Hi (ρ 41) (ρ 0) ∧ (∀ j, j < k → ρ' (202 + j) = 0#64) ∧ Q ρ' σ := by
  simp only [msg1Words, Braid.wpOps_append] at hw
  obtain ⟨ρ0, f0, hc, hw⟩ := wp_sigConsts hw
  obtain ⟨c0, c1, c2, c3, c4, c5, c6, c7, c8, c9⟩ := hc
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_joinOps (by omega) (by omega) hw
  simp only [Nat.reduceAdd] at v1
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_sigOps 7 18 3 (by omega) (by omega) (by omega) (by omega)
    (by unfold SigConsts
        simp (disch := omega) only [f1, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, and_self]) hw
  obtain ⟨ρ3, f3, v3, hw⟩ := wp_joinOps (by omega) (by omega) hw
  simp only [Nat.reduceAdd] at v3
  obtain ⟨ρ4, f4, v4, hw⟩ := wp_sigOps 7 18 3 (by omega) (by omega) (by omega) (by omega)
    (by unfold SigConsts
        simp (disch := omega) only [f3, f2, f1, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9,
          and_self]) hw
  obtain ⟨ρ5, f5, v5, hw⟩ := wp_constWords hw
  refine ⟨ρ5, fun x hx => ?_, ?_, ?_, v5, hw⟩
  · simp (disch := omega) only [f5, f4, f3, f2, f1, f0]
  · simp (disch := omega) only [f5, f4, f3, f1, f0, v2, v1]
    rfl
  · simp (disch := omega) only [f5, f3, f2, f1, f0, v4, v3]
    rfl

/-- The operations of `sha256rnds2` set the values 200 and 201 to `rnds2Lo` and `rnds2Hi`,
and the `k` values after them to zero. -/
theorem wp_rnds2Words {k : Nat} (hw : wpOps (rnds2Words k) ρ σ Q) :
    ∃ ρ', Agree 80 ρ ρ' ∧
      ρ' 200 = rnds2Lo (ρ 0) (ρ 40) (ρ 41) (σ.regs (vecReg .mm0 0)) ∧
      ρ' 201 = rnds2Hi (ρ 0) (ρ 1) (ρ 40) (ρ 41) (σ.regs (vecReg .mm0 0)) ∧
      (∀ j, j < k → ρ' (202 + j) = 0#64) ∧ Q ρ' σ := by
  simp only [rnds2Words, Braid.wpOps_append] at hw
  obtain ⟨ρ0, f0, hk0, hc, hm, h90, h91, h92, h93, h94, hw⟩ := wp_rnds2Pre hw
  obtain ⟨ρ1, f1, va1, ve1, hw⟩ := wp_rndOps (by omega)
    ⟨by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega⟩
    hc hw
  simp only [Nat.reduceAdd] at va1 ve1
  obtain ⟨ρ2, f2, va2, ve2, hw⟩ := wp_rnds2Mask hw
  obtain ⟨c1, c2, c3, c4, c5, c6, c7⟩ := hc
  obtain ⟨ρ3, f3, va3, ve3, hw⟩ := wp_rndOps (by omega)
    ⟨by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega⟩
    (by simp (disch := omega) only [f2, f1, c1, c2, c3, c4, c5, c6, c7, and_self]) hw
  simp only [Nat.reduceAdd] at va3 ve3
  obtain ⟨ρ4, f4, v0, v1, f4', hw⟩ := wp_rnds2Pack hw
  obtain ⟨ρ5, f5, v5, hw⟩ := wp_constWords hw
  have e0 : ρ0 0 = ρ 0 := f0 0 (by omega)
  have e1 : ρ0 1 = ρ 1 := f0 1 (by omega)
  have e40 : ρ0 40 = ρ 40 := f0 40 (by omega)
  have e41 : ρ0 41 = ρ 41 := f0 41 (by omega)
  refine ⟨ρ5, fun x hx => ?_, ?_, ?_, v5, hw⟩
  · rw [f5 x (by omega), f4 x (by omega), f3 x (by omega), f2 x (by omega) (by omega),
      f1 x (by omega)]
    exact f0 x hx
  · simp (disch := omega) only [f5, v0, f3, ve3, ve2, f2, f1, ve1, c1, hm, hk0, h90, h91, h93,
      h94, e0, e40, e41]
    rfl
  · simp (disch := omega) only [f5, v1, f3, va3, va2, ve2, f2, f1, va1, ve1, c1, hm, hk0, h90,
      h91, h92, h93, h94, e0, e1, e40, e41]
    rfl

/-- The values 200 up hold the words of a 128-bit result widened to the operation width:
its two words, and zero above them. -/
theorem vecWord_widen {w : AvxWidth} (r : BitVec 128) {ρ : Env} (h0 : ρ 200 = vecWord r 0)
    (h1 : ρ 201 = vecWord r 1) (hz : ∀ j, j < vecWords w - 2 → ρ (202 + j) = 0#64) (j : Nat)
    (hj : j < vecWords w) : ρ (200 + j) = vecWord (r.setWidth w.bits) j := by
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  match j with
  | 0 => rw [vecWord_setWidth _ (by omega)]; exact h0
  | 1 => rw [vecWord_setWidth _ (by omega)]; exact h1
  | j + 2 =>
    rw [vecWord_setWidth_zero _ (by omega), show 200 + (j + 2) = 202 + j by omega]
    exact hz j (by omega)

theorem wp_loadWords {n a t k : Nat} (hn : n + k ≤ a) (ha : a < t)
    (hw : wpOps (loadWords n a t k) ρ σ Q) :
    ∃ ρ', Agree n ρ ρ' ∧ ρ' a = ρ a ∧
      (∀ j, j < k → σ.mem.load (ρ a + BitVec.ofNat 64 (8 * j)) .w64 = some (ρ' (n + j))) ∧
      Q ρ' σ := by
  induction k generalizing Q with
  | zero => exact ⟨ρ, Agree.refl _ _, rfl, fun j hj => absurd hj (Nat.not_lt_zero j), hw⟩
  | succ k ih =>
    rw [loadWords_succ, Braid.wpOps_append] at hw
    obtain ⟨ρ1, hag, hra, hv, hq⟩ := ih (by omega) hw
    have h1 : a ≠ t + 2 * k := by omega
    simp only [wpOps, Op.wp, Env.set_apply, h1, ↓reduceIte, BinOp.eval_add, hra] at hq
    obtain ⟨v, hl, hq⟩ := hq
    refine ⟨_, ((hag.set (by omega) _).set (by omega) _).set (by omega) _, ?_, fun j hj => ?_,
      hq⟩
    · rw [set_ne _ _ (by omega), set_ne _ _ (by omega),
        set_ne _ _ (by omega), hra]
    · by_cases hjk : j = k
      · subst hjk; rw [Env.set_same]; exact hl
      · rw [set_ne _ _ (by omega), set_ne _ _ (by omega),
          set_ne _ _ (by omega)]
        exact hv j (by omega)

theorem wp_storeWords {a t v k : Nat} (ha : a < t) (hv : v + k ≤ t)
    (hw : wpOps (storeWords a t v k) ρ σ Q) :
    ∃ ρ' m, Agree t ρ ρ' ∧ storeSeq σ.mem (ρ a) (fun j => ρ (v + j)) k = some m ∧
      Q ρ' { σ with mem := m } := by
  induction k generalizing Q with
  | zero => exact ⟨ρ, σ.mem, Agree.refl _ _, rfl, hw⟩
  | succ k ih =>
    rw [storeWords_succ, Braid.wpOps_append] at hw
    obtain ⟨ρ1, m1, hag, hs, hq⟩ := ih (by omega) hw
    have h1 : a ≠ t + 2 * k := by omega
    have h2 : v + k ≠ t + 2 * k := by omega
    have h3 : v + k ≠ t + 2 * k + 1 := by omega
    simp only [wpOps, Op.wp, Env.set_apply, h1, h2, h3, ↓reduceIte, BinOp.eval_add, hag a ha,
      hag (v + k) (by omega)] at hq
    obtain ⟨m, hm, hq⟩ := hq
    refine ⟨_, m, (hag.set (by omega) _).set (by omega) _, ?_, hq⟩
    simp only [storeSeq, hs, Option.bind_some]
    exact hm

/-! ## Alignment -/

theorem wp_alignOps {n a bytes : Nat} {al : Bool} (ha : a < n)
    (hw : wpOps (alignOps n a bytes al) ρ σ Q) :
    ∃ ρ', Agree n ρ ρ' ∧ (al = true → ρ a &&& BitVec.ofNat 64 (bytes - 1) = 0#64) ∧ Q ρ' σ := by
  cases al with
  | false => exact ⟨ρ, Agree.refl _ _, fun h => Bool.noConfusion h, hw⟩
  | true =>
    have h0 : a ≠ n := by omega
    simp only [alignOps, wpOps, Op.wp, Env.set_apply, h0, ↓reduceIte] at hw
    obtain ⟨hg, hq⟩ := hw
    refine ⟨_, by agree, fun _ => ?_, hq⟩
    simpa using hg

theorem isAligned_of_mask (w : AvxWidth) {x : Word}
    (h : x &&& BitVec.ofNat 64 (w.bytes - 1) = 0#64) : isAligned w.bytes x = true := by
  have key : ∀ c : Word, x % c = 0#64 → x.toNat % c.toNat = 0 := fun c hc => by
    rw [← BitVec.toNat_umod, hc]; rfl
  cases w <;> simp only [isAligned, AvxWidth.bytes, beq_iff_eq, Nat.reduceSub] at h ⊢
  · exact key 16#64 (by bv_auto)
  · exact key 32#64 (by bv_auto)
  · exact key 64#64 (by bv_auto)

/-! ## Vectors in memory -/

section
variable {post : MachineState → Prop}

/-- Word loads `braid` allows are a vector load of the model, of the vector with those
words. -/
theorem loadAvx_sound (h : RelD s σ) {a : Word} {w : AvxWidth} {al : Bool}
    {ret : w.type → MachineData → Effects} {f : Nat → Word}
    (hal : al = true → a &&& BitVec.ofNat 64 (w.bytes - 1) = 0#64)
    (hl : ∀ j, j < vecWords w → σ.mem.load (a + BitVec.ofNat 64 (8 * j)) .w64 = some (f j))
    (hk : ∀ v : w.type, (∀ j, j < vecWords w → vecWord v j = f j) → (ret v s).All post) :
    (s.loadAvx a w ret al).All post := by
  have hc : (al && !isAligned w.bytes a) = false := by
    cases al
    · rfl
    · simp [isAligned_of_mask w (hal rfl)]
  have hb : w.bytes = 8 * vecWords w := by cases w <;> rfl
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  rw [h.mem] at hl
  have hi := loadInt_of_loads hl
  rw [← hb] at hi
  simp only [MachineData.loadAvx, hc, Bool.false_eq_true, ↓reduceIte,
    Effects.All_require_read_access, hi]
  exact hk _ fun j hj => vecWord_ofInt_joinWords f hj hbits

/-- Word stores `braid` allows are a vector store of the model. -/
theorem storeAvx_sound (h : RelD s σ) {a : Word} {w : AvxWidth} {al : Bool} {val : w.type}
    {m : Braid.Mem} {ret : MachineData → Effects}
    (hal : al = true → a &&& BitVec.ofNat 64 (w.bytes - 1) = 0#64)
    (hs : storeSeq σ.mem a (vecWord val) (vecWords w) = some m)
    (hk : ∀ s', RelD s' { σ with mem := m } → (ret s').All post) :
    (s.storeAvx a val ret al).All post := by
  have hc : (al && !isAligned w.bytes a) = false := by
    cases al
    · rfl
    · simp [isAligned_of_mask w (hal rfl)]
  have hb : w.bytes = 8 * vecWords w := by cases w <;> rfl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hbits : w.bits = 8 * (8 * vecWords w) := by cases w <;> rfl
  rw [h.mem] at hs
  obtain ⟨hsome, hm⟩ := storeInt_of_storeSeq hw8 hbits hs
  rw [← hb] at hsome hm
  obtain ⟨i, hi⟩ := Option.isSome_iff_exists.1 hsome
  simp only [MachineData.storeAvx, hc, Bool.false_eq_true, ↓reduceIte,
    Effects.All_require_write_access, hi]
  exact hk _ ⟨h.regs, h.cf, h.pf, h.af, h.zf, h.sf, h.of, h.df, hm, h.vec⟩

end

/-! ## Vector registers -/

/-- A write of a vector register by an instruction of the VEX or EVEX encodings: the words of
the value, and zero above them. -/
theorem set_eq (z : RegZmms) {w : AvxWidth} (r : AvxReg w) (val : w.type) :
    ∃ v, z.set r val = z.set512 r.base v ∧
      (∀ j, j < vecWords w → vecWord v j = vecWord val j) ∧
      (∀ j, vecWords w ≤ j → j < 8 → vecWord v j = 0#64) := by
  cases r with
  | xmm k =>
    refine ⟨_, rfl, fun j hj => vecWord_setWidth (n := 128) (m := 512) _ ?_,
      fun j hj _ => vecWord_setWidth_zero (n := 128) _ ?_⟩ <;>
    simp only [vecWords] at hj <;> omega
  | ymm k =>
    refine ⟨_, rfl, fun j hj => vecWord_setWidth (n := 256) (m := 512) _ ?_,
      fun j hj _ => vecWord_setWidth_zero (n := 256) _ ?_⟩ <;>
    simp only [vecWords] at hj <;> omega
  | zmm k =>
    refine ⟨_, rfl, fun j _ => rfl, fun j hj hj' => ?_⟩
    simp only [vecWords] at hj
    omega

/-- A write of a vector register by an instruction of the legacy encodings: the words of the
value, and the old words above them. -/
theorem setLegacy_eq (z : RegZmms) {w : AvxWidth} (r : AvxReg w) (val : w.type) :
    ∃ v, z.setLegacy r val = z.set512 r.base v ∧
      (∀ j, j < vecWords w → vecWord v j = vecWord val j) ∧
      (∀ j, vecWords w ≤ j → j < 8 → vecWord v j = vecWord (z.get512 r.base) j) := by
  cases r with
  | xmm k =>
    refine ⟨_, rfl, fun j hj => vecWord_replaceLow_lt (n := 128) (m := 512) _ _ ?_ (by decide),
      fun j hj _ => vecWord_replaceLow_ge (n := 128) _ _ ?_⟩ <;>
    simp only [vecWords] at hj <;> omega
  | ymm k =>
    refine ⟨_, rfl, fun j hj => vecWord_replaceLow_lt (n := 256) (m := 512) _ _ ?_ (by decide),
      fun j hj _ => vecWord_replaceLow_ge (n := 256) _ _ ?_⟩ <;>
    simp only [vecWords] at hj <;> omega
  | zmm k =>
    refine ⟨_, rfl, fun j _ => rfl, fun j hj hj' => ?_⟩
    simp only [vecWords] at hj
    omega

/-! ## Operands -/

section
variable [Labels] {p : Std.Rco Int64} {post : MachineState → Prop}

theorem readVec_sound (h : RelD s σ) {n : Nat} {w : AvxWidth} {o : AvxRegOrMem w} {al : Bool}
    {ret : w.type → MachineData → Effects} (hw : wpOps (readVec p n al o) ρ σ Q)
    (hk : ∀ (v : w.type) ρ', Agree n ρ ρ' → (∀ j, j < vecWords w → ρ' (n + j) = vecWord v j) →
      Q ρ' σ → (ret v s).All post) :
    (@AvxRegOrMem.interp w _ ⟨.W64⟩ o s p ret al).All post := by
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  cases o with
  | avx r =>
    simp only [readVec] at hw
    obtain ⟨ρ', hag, hv, hq⟩ := wp_getRegs hw
    refine hk _ ρ' hag (fun j hj => ?_) hq
    rw [hv j hj]
    simp only [RegZmms.get]
    rw [vecWord_take _ (by omega)]
    exact h.vec r.base j (by omega)
  | mem a =>
    simp only [readVec, Braid.wpOps_append] at hw
    obtain ⟨ρ1, hag1, ha, hw⟩ := wp_addr h hw
    obtain ⟨ρ2, hag2, hal, hw⟩ := wp_alignOps (by omega) hw
    obtain ⟨ρ3, hag3, -, hl, hq⟩ := wp_loadWords (by omega) (by omega) hw
    rw [ha] at hal
    rw [hag2 (n + 8) (by omega), ha] at hl
    simp only [AvxRegOrMem.interp]
    refine loadAvx_sound h hal hl fun v hv => hk v ρ3 (fun x hx => ?_)
      (fun j hj => (hv j hj).symm) hq
    rw [hag3 x hx, hag2 x (by omega), hag1 x (by omega)]

theorem writeVec_sound (h : RelD s σ) {n v : Nat} {w : AvxWidth} {d : AvxRegOrMem w}
    {val : w.type} {legacy al : Bool} {ret : MachineData → Effects}
    (hv : ∀ j, j < vecWords w → ρ (v + j) = vecWord val j) (hvn : v + 8 ≤ n)
    (hw : wpOps (writeVec p n legacy al d v) ρ σ Q)
    (hk : ∀ s' ρ' σ', Agree n ρ ρ' → RelD s' σ' → Q ρ' σ' → (ret s').All post) :
    (cond legacy (@MachineData.setAvxLegacy w _ ⟨.W64⟩ s d val p ret al)
      (@MachineData.setAvx w _ ⟨.W64⟩ s d val p ret al)).All post := by
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  cases d with
  | avx r =>
    simp only [writeVec, Braid.wpOps_append] at hw
    have hw := wp_setRegs hw
    cases legacy with
    | true =>
      simp only [↓reduceIte, wpOps] at hw
      obtain ⟨z, hz, h1, h2⟩ := setLegacy_eq s.zmms r val
      simp only [Bool.cond_true, MachineData.setAvxLegacy, MachineData.setAvxLegacyReg, hz]
      refine hk _ _ _ (Agree.refl _ _) ?_ hw
      refine h.set512 r.base z rfl rfl (fun j hj => ?_)
        fun x hx => setWords_regs_other _ _ _ _ _ (by omega) hx
      rw [setWords_regs_vecReg]
      by_cases hj' : j < vecWords w
      · have hc : 0 ≤ j ∧ j < 0 + vecWords w := by omega
        simp only [hc, and_self, ↓reduceIte, Nat.sub_zero]
        rw [hv j hj', h1 j hj']
      · have hc : ¬ (0 ≤ j ∧ j < 0 + vecWords w) := by omega
        simp only [hc, ↓reduceIte]
        rw [h.vec _ j hj, h2 j (by omega) hj]
    | false =>
      simp only [Bool.false_eq_true, ↓reduceIte, wpOps, Op.wp] at hw
      have hw := wp_setRegs hw
      obtain ⟨z, hz, h1, h2⟩ := set_eq s.zmms r val
      simp only [Bool.cond_false, MachineData.setAvx, MachineData.setAvxReg, hz]
      refine hk _ _ _ (Agree.set (Agree.refl _ _) (Nat.le_refl _) _) ?_ hw
      refine h.set512 r.base z rfl rfl (fun j hj => ?_) fun x hx => ?_
      · rw [setWords_regs_vecReg, setWords_regs_vecReg]
        by_cases hj' : j < vecWords w
        · have hc : ¬ (vecWords w ≤ j ∧ j < vecWords w + (8 - vecWords w)) := by omega
          have hc' : 0 ≤ j ∧ j < 0 + vecWords w := by omega
          simp only [hc, hc', and_self, ↓reduceIte, Nat.sub_zero]
          rw [hv j hj', h1 j hj']
        · have hc : vecWords w ≤ j ∧ j < vecWords w + (8 - vecWords w) := by omega
          simp only [hc, and_self, ↓reduceIte, Env.set_same]
          rw [h2 j (by omega) hj]
          rfl
      · rw [setWords_regs_other _ _ _ _ _ (by omega) hx,
          setWords_regs_other _ _ _ _ _ (by omega) hx]
  | mem a =>
    simp only [writeVec, Braid.wpOps_append] at hw
    obtain ⟨ρ1, hag1, ha, hw⟩ := wp_addr h hw
    obtain ⟨ρ2, hag2, hal, hw⟩ := wp_alignOps (by omega) hw
    obtain ⟨ρ3, m, hag3, hs, hq⟩ := wp_storeWords (by omega) (by omega) hw
    rw [ha] at hal
    rw [hag2 n (by omega), ha] at hs
    have hs' : storeSeq σ.mem (addrVal p a s) (vecWord val) (vecWords w) = some m := by
      rw [← hs]
      refine (storeSeq_congr _ _ fun j hj => ?_).symm
      rw [hag2 (v + j) (by omega), hag1 (v + j) (by omega)]
      exact hv j hj
    have hag : Agree n ρ ρ3 := fun x hx => by
      rw [hag3 x (by omega), hag2 x (by omega), hag1 x hx]
    cases legacy
    all_goals
      simp only [Bool.cond_true, Bool.cond_false, MachineData.setAvxLegacy, MachineData.setAvx]
      exact storeAvx_sound h hal hs' fun s' h' => hk s' ρ3 _ hag h' hq

/-! ## Instructions -/

/-- The vector instruction `i` is lowered soundly: if its operations run without fault and
establish `Q` at the next instruction, every outcome of `i` in the model is related to a state
satisfying `Q`. -/
def AvxSound (p : Std.Rco Int64) {w : AvxWidth} (i : AvxOperation w) : Prop :=
  ∀ {s : MachineData} {σ : State} {ρ : Env} {Q : State → Prop} {ops : List Op},
    RelD s σ → lowerAvx p i = some ops →
    wpOps ops ρ σ (fun ρ σ' => (Term.jump p.upper.toBitVec).wp ρ σ' Q) →
    (@AvxOperation.interp _ ⟨.W64⟩ w i p s fun s' => .done ⟨s', p.upper⟩).All
      fun m => ∃ σ', Rel m σ' ∧ Q σ'

/-- A move of a vector, of either encoding, aligned or not. -/
theorem moveVec_sound {w : AvxWidth} {legacy al : Bool} {dst src : AvxRegOrMem w}
    {Q : State → Prop} (h : RelD s σ)
    (hw : wpOps (moveVec p legacy al dst src) ρ σ
      fun ρ σ' => (Term.jump p.upper.toBitVec).wp ρ σ' Q) :
    (@AvxRegOrMem.interp w _ ⟨.W64⟩ src s p (fun val s =>
      cond legacy
        (@MachineData.setAvxLegacy w _ ⟨.W64⟩ s dst val p (fun s' => .done ⟨s', p.upper⟩) al)
        (@MachineData.setAvx w _ ⟨.W64⟩ s dst val p (fun s' => .done ⟨s', p.upper⟩) al)) al).All
      fun m => ∃ σ', Rel m σ' ∧ Q σ' := by
  simp only [moveVec, Braid.wpOps_append] at hw
  refine readVec_sound h hw fun v ρ1 _ hv hw => ?_
  refine writeVec_sound h hv (by decide) hw fun s' ρ2 σ' _ h' hq => ?_
  exact done_sound h' hq

theorem paddd_sound {w : AvxWidth} (dst src : AvxRegOrMem w) :
    AvxSound p (.paddd dst src) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun a ρ1 _ ha hw => ?_
  refine readVec_sound h hw fun b ρ2 hag2 hb hw => ?_
  obtain ⟨ρ3, hag3, hv, hw⟩ := wp_binWords (by omega) (by omega) hw
  refine writeVec_sound (legacy := true) (val := BitVec.packedBinOp 32 (· + ·) b a) h
    (fun j hj => ?_) (by decide) hw fun s' ρ4 σ' _ h' hq => done_sound h' hq
  rw [hv j hj, hb j hj, hag2 (0 + j) (by omega), ha j hj,
    vecWord_packedBinOp_add _ _ _ (by omega)]

theorem vpaddd_sound {w : AvxWidth} (dst src1 src2 : AvxRegOrMem w) :
    AvxSound p (.vpaddd dst src1 src2) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun b ρ1 _ hb hw => ?_
  refine readVec_sound h hw fun a ρ2 hag2 ha hw => ?_
  obtain ⟨ρ3, hag3, hv, hw⟩ := wp_binWords (by omega) (by omega) hw
  refine writeVec_sound (legacy := false) (val := BitVec.packedBinOp 32 (· + ·) a b) h
    (fun j hj => ?_) (by decide) hw fun s' ρ4 σ' _ h' hq => done_sound h' hq
  rw [hv j hj, ha j hj, hag2 (0 + j) (by omega), hb j hj,
    vecWord_packedBinOp_add _ _ _ (by omega)]

theorem vprord_sound {w : AvxWidth} (dst src : AvxRegOrMem w) (imm : ConstExpr) :
    AvxSound p (.vprord dst src imm) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun a ρ1 _ ha hw => ?_
  obtain ⟨ρ2, _, hv, hw⟩ := wp_rorWords hw8 hw
  refine writeVec_sound (legacy := false)
    (val := a.mapLanes 32 (·.rotateRight ((imm8 p imm).toNat % 32))) h
    (fun j hj => ?_) (by decide) hw fun s' ρ3 σ' _ h' hq => done_sound h' hq
  rw [hv j hj, ha j hj, vecWord_rotateRight _ _ _ (by omega)]

theorem vpsrld_sound {w : AvxWidth} (dst src : AvxRegOrMem w) (imm : ConstExpr) :
    AvxSound p (.vpsrld dst src imm) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun a ρ1 _ ha hw => ?_
  obtain ⟨ρ2, _, hv, hw⟩ := wp_shrWords hw8 hw
  refine writeVec_sound (legacy := false)
    (val := a.mapLanes 32
      (fun x => if (imm8 p imm).toNat < 32 then x >>> (imm8 p imm).toNat else 0#32)) h
    (fun j hj => ?_) (by decide) hw fun s' ρ3 σ' _ h' hq => done_sound h' hq
  rw [hv j hj, ha j hj, vecWord_shiftRight _ _ _ (by omega)]

theorem vpternlogd_sound {w : AvxWidth} (dst src2 src3 : AvxRegOrMem w) (imm : ConstExpr) :
    AvxSound p (.vpternlogd dst src2 src3 imm) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun c ρ1 _ hc hw => ?_
  refine readVec_sound h hw fun b ρ2 hag2 hb hw => ?_
  refine readVec_sound h hw fun a ρ3 hag3 ha hw => ?_
  obtain ⟨ρ4, _, hv, hw⟩ := wp_ternWords hw8 hw
  refine writeVec_sound (legacy := false) (val := BitVec.ternaryLogic a b c (imm8 p imm)) h
    (fun j hj => ?_) (by decide) hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
  rw [hv j hj, ha j hj, hag3 (40 + j) (by omega), hb j hj, hag3 (0 + j) (by omega),
    hag2 (0 + j) (by omega), hc j hj, vecWord_ternaryLogic _ _ _ _ _ (by omega)]

theorem pshufd_sound {w : AvxWidth} (dst src : AvxRegOrMem w) (imm : ConstExpr) :
    AvxSound p (.pshufd dst src imm) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hw2 : vecWords w % 2 = 0 := by cases w <;> rfl
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun a ρ1 _ ha hw => ?_
  obtain ⟨ρ2, _, hv, hw⟩ := wp_shufWords hw8 hw2 hw
  refine writeVec_sound (legacy := true) (val := a.shuffleDwords (imm8 p imm)) h
    (fun j hj => ?_) (by decide) hw fun s' ρ3 σ' _ h' hq => done_sound h' hq
  rw [hv j hj, ha _ (shufLane_div_lt _ (by omega) hw2),
    ha _ (shufLane_div_lt _ (by omega) hw2), vecWord_shuffleDwords _ _ _ (by omega)]

theorem pblendw_sound {w : AvxWidth} (dst src : AvxRegOrMem w) (imm : ConstExpr) :
    AvxSound p (.pblendw dst src imm) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun b ρ1 _ hb hw => ?_
  refine readVec_sound h hw fun a ρ2 hag2 ha hw => ?_
  obtain ⟨ρ3, _, hv, hw⟩ := wp_blendWords hw8 hw
  refine writeVec_sound (legacy := true) (val := a.blendWords b (imm8 p imm)) h
    (fun j hj => ?_) (by decide) hw fun s' ρ4 σ' _ h' hq => done_sound h' hq
  rw [hv j hj, ha j hj, hag2 (0 + j) (by omega), hb j hj,
    vecWord_blendWords _ _ _ _ (by omega)]

theorem palignr_sound {w : AvxWidth} (dst src : AvxRegOrMem w) (imm : ConstExpr) :
    AvxSound p (.palignr dst src imm) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hw2 : vecWords w % 2 = 0 := by cases w <;> rfl
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun b ρ1 _ hb hw => ?_
  refine readVec_sound h hw fun a ρ2 hag2 ha hw => ?_
  obtain ⟨ρ3, _, hv, hw⟩ := wp_alignWords hw8 hw
  refine writeVec_sound (legacy := true) (val := a.alignBytes b (imm8 p imm)) h
    (fun j hj => ?_) (by decide) hw fun s' ρ4 σ' _ h' hq => done_sound h' hq
  have hs : ∀ q, alignVal ρ2 j q = alignSrc a b j q := by
    intro q
    unfold alignVal alignSrc
    split
    · rw [hag2 _ (by omega), hb _ (by omega)]
    · split
      · rw [ha _ (by omega)]
      · rfl
  rw [hv j hj, hs, hs, vecWord_alignBytes _ _ _ _ (by omega)]

theorem pshufb_sound {w : AvxWidth} (dst src : AvxRegOrMem w) :
    AvxSound p (.pshufb dst src) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hw2 : vecWords w % 2 = 0 := by cases w <;> rfl
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun m ρ1 _ hm hw => ?_
  refine readVec_sound h hw fun a ρ2 hag2 ha hw => ?_
  obtain ⟨ρ3, _, hv, hw⟩ := wp_bshufWords hw8 hw
  refine writeVec_sound (legacy := true) (val := a.shuffleBytes m) h
    (fun j hj => ?_) (by decide) hw fun s' ρ4 σ' _ h' hq => done_sound h' hq
  rw [hv j hj, hag2 (0 + j) (by omega), hm j hj, ha _ (by omega), ha _ (by omega),
    vecWord_shuffleBytes _ _ _ (by omega)]

theorem sha256msg1_sound {w : AvxWidth} (dst src : AvxRegOrMem w) :
    AvxSound p (.sha256msg1 dst src) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw2 : 2 ≤ vecWords w := by cases w <;> decide
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun x ρ1 _ hx hw => ?_
  refine readVec_sound h hw fun y ρ2 hag2 hy hw => ?_
  obtain ⟨ρ3, _, h0, h1, hz, hw⟩ := wp_msg1Words hw
  have e0 : ρ2 40 = vecWord y 0 := hy 0 (by omega)
  have e1 : ρ2 41 = vecWord y 1 := hy 1 (by omega)
  have e2 : ρ2 0 = vecWord x 0 := (hag2 0 (by omega)).trans (hx 0 (by omega))
  refine writeVec_sound (legacy := true)
    (val := (Sha256.msg1 (y.setWidth 128) (x.setWidth 128)).setWidth _) h
    (vecWord_widen _ ?_ ?_ hz) (by decide) hw fun s' ρ4 σ' _ h' hq => done_sound h' hq
  · rw [h0, vecWord_msg1_zero, vecWord_setWidth _ (by decide), vecWord_setWidth _ (by decide),
      e0, e1]
  · rw [h1, vecWord_msg1_one, vecWord_setWidth _ (by decide), vecWord_setWidth _ (by decide),
      e1, e2]

theorem sha256msg2_sound {w : AvxWidth} (dst src : AvxRegOrMem w) :
    AvxSound p (.sha256msg2 dst src) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw2 : 2 ≤ vecWords w := by cases w <;> decide
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun x ρ1 _ hx hw => ?_
  refine readVec_sound h hw fun y ρ2 hag2 hy hw => ?_
  obtain ⟨ρ3, _, h0, h1, hz, hw⟩ := wp_msg2Words hw
  have e0 : ρ2 40 = vecWord y 0 := hy 0 (by omega)
  have e1 : ρ2 41 = vecWord y 1 := hy 1 (by omega)
  have e2 : ρ2 1 = vecWord x 1 := (hag2 1 (by omega)).trans (hx 1 (by omega))
  refine writeVec_sound (legacy := true)
    (val := (Sha256.msg2 (y.setWidth 128) (x.setWidth 128)).setWidth _) h
    (vecWord_widen _ ?_ ?_ hz) (by decide) hw fun s' ρ4 σ' _ h' hq => done_sound h' hq
  · rw [h0, vecWord_msg2_zero, vecWord_setWidth _ (by decide), vecWord_setWidth _ (by decide),
      e0, e2]
  · rw [h1, vecWord_msg2_one, vecWord_setWidth _ (by decide), vecWord_setWidth _ (by decide),
      vecWord_setWidth _ (by decide), e0, e1, e2]

theorem sha256rnds2_sound {w : AvxWidth} (dst src : AvxRegOrMem w) :
    AvxSound p (.sha256rnds2 dst src) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw2 : 2 ≤ vecWords w := by cases w <;> decide
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun x ρ1 _ hx hw => ?_
  refine readVec_sound h hw fun y ρ2 hag2 hy hw => ?_
  obtain ⟨ρ3, _, h0, h1, hz, hw⟩ := wp_rnds2Words hw
  have e0 : ρ2 40 = vecWord y 0 := hy 0 (by omega)
  have e1 : ρ2 41 = vecWord y 1 := hy 1 (by omega)
  have e2 : ρ2 0 = vecWord x 0 := (hag2 0 (by omega)).trans (hx 0 (by omega))
  have e3 : ρ2 1 = vecWord x 1 := (hag2 1 (by omega)).trans (hx 1 (by omega))
  have ek : σ.regs (vecReg .mm0 0) = vecWord (s.zmms.get (AvxReg.xmm .mm0)) 0 := by
    simp only [RegZmms.get]
    rw [vecWord_take _ (by decide)]
    exact h.vec .mm0 0 (by decide)
  obtain ⟨r0, r1⟩ := vecWord_rounds2 (y.setWidth 128) (x.setWidth 128)
    (s.zmms.get (AvxReg.xmm .mm0))
  refine writeVec_sound (legacy := true)
    (val := (Sha256.rounds2 (y.setWidth 128) (x.setWidth 128)
      (s.zmms.get (AvxReg.xmm .mm0))).setWidth _) h
    (vecWord_widen _ ?_ ?_ hz) (by decide) hw fun s' ρ4 σ' _ h' hq => done_sound h' hq
  · rw [h0, r0, vecWord_setWidth _ (by decide), vecWord_setWidth _ (by decide),
      vecWord_setWidth _ (by decide), e0, e1, e2, ek]
  · rw [h1, r1, vecWord_setWidth _ (by decide), vecWord_setWidth _ (by decide),
      vecWord_setWidth _ (by decide), vecWord_setWidth _ (by decide), e0, e1, e2, e3, ek]

theorem vmovq_sound {w : AvxWidth} (dst src : AvxReg w) : AvxSound p (.vmovq dst src) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw2 : 2 ≤ vecWords w := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [AvxOperation.interp]
  simp only [List.cons_append, List.nil_append, wpOps, Op.wp] at hw
  have hw := wp_setRegs hw
  obtain ⟨z, hz, h1, h2⟩ := set_eq s.zmms dst (((s.zmms.get src).take 64).zeroExtend _)
  simp only [MachineData.setAvxReg, hz]
  refine done_sound ?_ hw
  refine h.set512 dst.base z rfl rfl (fun j hj => ?_)
    fun x hx => setWords_regs_other _ _ _ _ _ (by omega) hx
  rw [setWords_regs_vecReg]
  have hc : 0 ≤ j ∧ j < 0 + 8 := by omega
  simp only [hc, and_self, ↓reduceIte, Nat.sub_zero]
  by_cases hj0 : j = 0
  · subst hj0
    simp only [↓reduceIte, Env.set_apply, Nat.zero_ne_one]
    rw [h1 0 (by omega), h.vec _ 0 (by omega)]
    simp only [RegZmms.get]
    rw [vecWord_setWidth _ (by omega), vecWord_take _ (by omega), vecWord_take _ (by omega)]
  · simp only [hj0, ↓reduceIte, Env.set_same]
    by_cases hj' : j < vecWords w
    · rw [h1 j hj', vecWord_setWidth_zero (n := 64) _ (by omega)]
      rfl
    · rw [h2 j (by omega) hj]
      rfl

theorem vmovIn_sound {w : AvxWidth} (n : Width) (dst : AvxReg w) (src : RegOrMem n) :
    AvxSound p (.vmovIn n dst src) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw2 : 2 ≤ vecWords w := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  have hn : n.bits ≤ 64 := by cases n <;> decide
  simp only [AvxOperation.interp]
  simp only [Braid.wpOps_append] at hw
  refine readRM_sound h hw fun v ρ1 _ hv hw => ?_
  simp only [wpOps, Op.wp] at hw
  have hw := wp_setRegs hw
  obtain ⟨z, hz, h1, h2⟩ := set_eq s.zmms dst (v.zeroExtend _)
  simp only [MachineData.setAvxReg, hz]
  refine done_sound ?_ hw
  refine h.set512 dst.base z rfl rfl (fun j hj => ?_)
    fun x hx => setWords_regs_other _ _ _ _ _ (by omega) hx
  rw [setWords_regs_vecReg]
  have hc : 0 ≤ j ∧ j < 0 + 8 := by omega
  simp only [hc, and_self, ↓reduceIte, Nat.sub_zero]
  by_cases hj0 : j = 0
  · subst hj0
    have h8 : (0 : Nat) ≠ 8 := by decide
    simp only [↓reduceIte, Env.set_apply, h8]
    rw [h1 0 (by omega), hv]
    exact (vecWord_zero_setWidth _ (by omega)).symm
  · simp only [hj0, ↓reduceIte, Env.set_same]
    by_cases hj' : j < vecWords w
    · rw [h1 j hj']
      exact (vecWord_setWidth_zero _ (by omega)).symm
    · rw [h2 j (by omega) hj]
      rfl

theorem vmovOut_sound {w : AvxWidth} (n : Width) (dst : Dst n) (src : AvxReg w) :
    AvxSound p (.vmovOut n dst src) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hn : n.bits ≤ w.bits := by cases n <;> cases w <;> decide
  simp only [AvxOperation.interp]
  simp only [List.cons_append, List.nil_append, wpOps, Op.wp] at hw
  refine writeRM_sound (val := (s.zmms.get src).take n.bits) h ?_ (by decide) hw
    fun s' ρ' σ' _ h' hq => done_sound h' hq
  simp only [Env.set_same, UnOp.eval_zext, h.vec _ 0 (by decide), RegZmms.get]
  exact vecWord_zero_take _ hn

/-- **Every vector instruction is lowered soundly.** -/
theorem lowerAvx_sound {w : AvxWidth} (i : AvxOperation w) : AvxSound p i := by
  cases i
  case paddd dst src => exact paddd_sound dst src
  case vpaddd dst src1 src2 => exact vpaddd_sound dst src1 src2
  case vprord dst src imm => exact vprord_sound dst src imm
  case vpsrld dst src imm => exact vpsrld_sound dst src imm
  case vpternlogd dst src2 src3 imm => exact vpternlogd_sound dst src2 src3 imm
  case pshufd dst src imm => exact pshufd_sound dst src imm
  case pblendw dst src imm => exact pblendw_sound dst src imm
  case palignr dst src imm => exact palignr_sound dst src imm
  case pshufb dst src => exact pshufb_sound dst src
  case sha256msg1 dst src => exact sha256msg1_sound dst src
  case sha256msg2 dst src => exact sha256msg2_sound dst src
  case sha256rnds2 dst src => exact sha256rnds2_sound dst src
  case vmovq dst src => exact vmovq_sound dst src
  case vmovIn n dst src => exact vmovIn_sound n dst src
  case vmovOut n dst src => exact vmovOut_sound n dst src
  case movups dst src | movdqu dst src | movaps dst src | movdqa dst src | vmovups dst src |
      vmovdqu dst src | vmovdqu32 dst src | vmovdqa32 dst src =>
    intro s σ ρ Q ops h hl hw
    simp only [lowerAvx, Option.some.injEq] at hl
    subst hl
    exact moveVec_sound h hw
  all_goals intro s σ ρ Q ops h hl hw; simp [lowerAvx] at hl

end

end Lowering.X86
