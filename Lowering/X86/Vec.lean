/-
  Lowering.X86.Vec

  The vector registers and vectors in memory, a word at a time. A 512-bit register of the
  model is eight `braid` registers, and a vector in memory is loaded and stored as its words,
  low word first. These lemmas relate the words to the model's one wide value, and a word of
  the result of each of the model's operations on vectors to the words of its operands.

  ## Main definitions

  * `setWords`: a state with a run of registers written
  * `joinWords`: the number whose 64-bit digits are given words
  * `storeSeq`: a run of word stores
  * `alignSrc`, `alignBit`: a word and a bit of a block of two words of each of two vectors

  ## Main results

  * `RelD.set512`: writing the words of a vector register keeps the states related
  * `loadInt_of_loads`: word loads `braid` allows are one wide load of the model
  * `storeInt_of_storeSeq`: word stores `braid` allows are one wide store of the model
  * `vecWord_packedBinOp_add`: a packed 32-bit addition is `BinOp.lanes 32 .add` on each word
  * `lane_ofLanes`, `getLsbD_ofLanes`: the lanes and the bits of the model's `ofLanes`
  * `vecWord_rotateRight`, `vecWord_shiftRight`: a rotation and a shift of 32-bit lanes
  * `vecWord_ternaryLogic`, `ternaryLogic_eq_ternLanes`: a bitwise function by its truth table
  * `vecWord_shuffleDwords`, `vecWord_shuffleBytes`: shuffles of 32-bit lanes and of bytes
  * `vecWord_blendWords`, `vecWord_alignBytes`: a blend of 16-bit lanes, a shift of bytes
  * `vecWord_msg1_zero`, `vecWord_msg1_one`, `vecWord_msg2_zero`, `vecWord_msg2_one`,
    `vecWord_rounds2`: the two words of each SHA-256 instruction
-/

module

public import Lowering.X86.Rel
import all Kraken.Mem
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env wpOps State ofBool)

/-! ## Vector registers -/

/-- The vector register with a number; `mmNum` is its inverse. -/
def mmOfNum : Nat → RegMm
  | 0 => .mm0 | 1 => .mm1 | 2 => .mm2 | 3 => .mm3
  | 4 => .mm4 | 5 => .mm5 | 6 => .mm6 | 7 => .mm7
  | 8 => .mm8 | 9 => .mm9 | 10 => .mm10 | 11 => .mm11
  | 12 => .mm12 | 13 => .mm13 | 14 => .mm14 | 15 => .mm15
  | 16 => .mm16 | 17 => .mm17 | 18 => .mm18 | 19 => .mm19
  | 20 => .mm20 | 21 => .mm21 | 22 => .mm22 | 23 => .mm23
  | 24 => .mm24 | 25 => .mm25 | 26 => .mm26 | 27 => .mm27
  | 28 => .mm28 | 29 => .mm29 | 30 => .mm30 | _ => .mm31

theorem mmOfNum_mmNum (k : RegMm) : mmOfNum (mmNum k) = k := by
  cases k <;> rfl

theorem mmNum_lt (k : RegMm) : mmNum k < 32 := by
  cases k <;> decide

theorem mmNum_inj {k k' : RegMm} (h : mmNum k = mmNum k') : k = k' := by
  rw [← mmOfNum_mmNum k, h, mmOfNum_mmNum]

theorem get512_set512 (s : RegZmms) (k k' : RegMm) (v : BitVec 512) :
    (s.set512 k v).get512 k' = if k' = k then v else s.get512 k' := by
  by_cases h : k' = k
  · subst h; simp only [↓reduceIte]; cases k' <;> rfl
  · simp only [h, ↓reduceIte]
    cases k <;> cases k' <;> first | exact absurd rfl h | rfl

/-- The state with the registers `r` to `r + k - 1` holding `f 0` to `f (k - 1)`. -/
def setWords (σ : State) (r : Nat) (f : Nat → Word) (k : Nat) : State :=
  { σ with regs := fun x : Nat => if r ≤ x ∧ x < r + k then f (x - r) else σ.regs x }

theorem setWords_zero (σ : State) (r : Nat) (f : Nat → Word) : setWords σ r f 0 = σ := by
  have e : (fun x : Nat => if r ≤ x ∧ x < r + 0 then f (x - r) else σ.regs x) = σ.regs := by
    apply funext
    intro (x : Nat)
    have : ¬ (r ≤ x ∧ x < r + 0) := by omega
    simp only [this, ↓reduceIte]
  simp only [setWords, e]

theorem setWords_succ (σ : State) (r : Nat) (f : Nat → Word) (k : Nat) :
    setWords σ r f (k + 1) = (setWords σ r f k).setReg (r + k) (f k) := by
  simp only [setWords, State.setReg]
  congr 1
  apply funext
  intro (x : Nat)
  by_cases h1 : x = r + k
  · subst h1; simp
  · by_cases h2 : r ≤ x ∧ x < r + k
    · have : r ≤ x ∧ x < r + (k + 1) := by omega
      simp only [h1, h2, this, and_self, ↓reduceIte]
    · have : ¬ (r ≤ x ∧ x < r + (k + 1)) := by omega
      simp only [h1, h2, this, ↓reduceIte]

/-- A word of the register `k`, after a run of words of `k` is written. -/
theorem setWords_regs_vecReg (σ : State) (k : RegMm) (i j n : Nat) (f : Nat → Word) :
    (setWords σ (vecReg k i) f n).regs (vecReg k j) =
      if i ≤ j ∧ j < i + n then f (j - i) else σ.regs (vecReg k j) := by
  simp only [setWords, vecReg]
  by_cases h : i ≤ j ∧ j < i + n
  · have h' : 32 + 8 * mmNum k + i ≤ 32 + 8 * mmNum k + j ∧
        32 + 8 * mmNum k + j < 32 + 8 * mmNum k + i + n := by omega
    have e : 32 + 8 * mmNum k + j - (32 + 8 * mmNum k + i) = j - i := by omega
    simp only [h, h', and_self, ↓reduceIte, e]
  · have h' : ¬ (32 + 8 * mmNum k + i ≤ 32 + 8 * mmNum k + j ∧
        32 + 8 * mmNum k + j < 32 + 8 * mmNum k + i + n) := by omega
    simp only [h, h', ↓reduceIte]

/-- A register outside the words of `k`, after a run of words of `k` is written. -/
theorem setWords_regs_other (σ : State) (k : RegMm) (i n : Nat) (f : Nat → Word) (hn : i + n ≤ 8)
    {x : Nat} (hx : ¬ (vecReg k 0 ≤ x ∧ x < vecReg k 0 + 8)) :
    (setWords σ (vecReg k i) f n).regs x = σ.regs x := by
  simp only [vecReg] at hx
  have h' : ¬ (32 + 8 * mmNum k + i ≤ x ∧ x < 32 + 8 * mmNum k + i + n) := by omega
  simp only [setWords, vecReg, h', ↓reduceIte]

/-- Writing the eight words of a vector register gives a state related to the machine with
that register set. -/
theorem RelD.set512 {s : MachineData} {σ σ' : State} (h : RelD s σ) (k : RegMm) (v : BitVec 512)
    (hfl : σ'.flags = σ.flags) (hmem : σ'.mem = σ.mem)
    (hin : ∀ j, j < 8 → σ'.regs (vecReg k j) = vecWord v j)
    (hout : ∀ x : Nat, ¬ (vecReg k 0 ≤ x ∧ x < vecReg k 0 + 8) → σ'.regs x = σ.regs x) :
    RelD { s with zmms := s.zmms.set512 k v } σ' := by
  refine ⟨fun r => ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, fun k' j hj => ?_⟩
  · rw [hout, h.regs]
    have := regNum_lt r
    simp only [vecReg]
    omega
  · rw [hfl]; exact h.cf
  · rw [hfl]; exact h.pf
  · rw [hfl]; exact h.af
  · rw [hfl]; exact h.zf
  · rw [hfl]; exact h.sf
  · rw [hfl]; exact h.of
  · rw [hfl]; exact h.df
  · rw [hmem]; exact h.mem
  · simp only [get512_set512]
    by_cases hk : k' = k
    · subst hk; simp only [↓reduceIte]; exact hin j hj
    · simp only [hk, ↓reduceIte]
      rw [hout, h.vec k' j hj]
      have : mmNum k' ≠ mmNum k := fun e => hk (mmNum_inj e)
      simp only [vecReg]
      omega

/-! ## Words of a vector -/

theorem vecWord_take {n m : Nat} (v : BitVec n) {j : Nat} (hj : 64 * (j + 1) ≤ m) :
    vecWord (v.take m) j = vecWord v j := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have : 64 * j + i < m := by omega
  simp [vecWord, BitVec.take, hi, this]

theorem vecWord_setWidth {n m : Nat} (v : BitVec n) {j : Nat} (hj : 64 * (j + 1) ≤ m) :
    vecWord (v.setWidth m) j = vecWord v j := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have : 64 * j + i < m := by omega
  simp [vecWord, hi, this]

theorem vecWord_setWidth_zero {n m : Nat} (v : BitVec n) {j : Nat} (hj : n ≤ 64 * j) :
    vecWord (v.setWidth m) j = 0#64 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have : n ≤ 64 * j + i := by omega
  simp [vecWord, hi, BitVec.getLsbD_of_ge _ _ this]

theorem vecWord_zero_setWidth {n m : Nat} (v : BitVec n) (hm : 64 ≤ m) :
    vecWord (v.setWidth m) 0 = v.setWidth 64 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have : i < m := by omega
  simp [vecWord, hi, this]

theorem vecWord_zero_take {m : Nat} (v : BitVec m) {n w : Nat} (hw : n ≤ w) :
    ((vecWord v 0).setWidth n).setWidth 64 = ((v.take w).take n).setWidth 64 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  by_cases h : i < n
  · have h1 : i < w := by omega
    simp [vecWord, BitVec.take, hi, h, h1]
  · simp [vecWord, BitVec.take, h]

theorem vecWord_replaceLow_lt {n m : Nat} (old : BitVec m) (new : BitVec n) {j : Nat}
    (hj : 64 * (j + 1) ≤ n) (hnm : n ≤ m) : vecWord (old.replaceLow new) j = vecWord new j := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have h1 : 64 * j + i < n := by omega
  have h2 : 64 * j + i < m := by omega
  simp [vecWord, BitVec.replaceLow, BitVec.append_eq, BitVec.getLsbD_append, hi, h1, h2]

theorem vecWord_replaceLow_ge {n m : Nat} (old : BitVec m) (new : BitVec n) {j : Nat}
    (hj : n ≤ 64 * j) : vecWord (old.replaceLow new) j = vecWord old j := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have h1 : ¬ 64 * j + i < n := by omega
  have e : n + (64 * j + i - n) = 64 * j + i := by omega
  simp only [vecWord, BitVec.replaceLow, BitVec.append_eq, BitVec.drop, BitVec.getLsbD_append,
    BitVec.getLsbD_extractLsb', BitVec.getLsbD_setWidth, hi, h1, e, decide_true, Bool.true_and,
    ↓reduceIte]
  by_cases h2 : 64 * j + i < m
  · have h3 : 64 * j + i - n < m - n := by omega
    simp [h2, h3]
  · simp [BitVec.getLsbD_of_ge _ _ (Nat.le_of_not_lt h2)]

/-- The number whose 64-bit digits are `f 0` to `f (k - 1)`, low digit first. -/
def joinWords (f : Nat → Word) : Nat → Nat
  | 0 => 0
  | k + 1 => joinWords f k + (f k).toNat * 2 ^ (64 * k)

theorem joinWords_lt (f : Nat → Word) (k : Nat) : joinWords f k < 2 ^ (64 * k) := by
  induction k with
  | zero => simp [joinWords]
  | succ k ih =>
    have hf := (f k).isLt
    have e : 2 ^ (64 * (k + 1)) = 2 ^ 64 * 2 ^ (64 * k) := by
      rw [show 64 * (k + 1) = 64 + 64 * k by omega, Nat.pow_add]
    have hm : ((f k).toNat + 1) * 2 ^ (64 * k) ≤ 2 ^ 64 * 2 ^ (64 * k) :=
      Nat.mul_le_mul_right _ hf
    rw [Nat.add_mul, Nat.one_mul] at hm
    simp only [joinWords, e]
    omega

theorem joinWords_div (f : Nat → Word) {j k : Nat} (hj : j < k) :
    joinWords f k / 2 ^ (64 * j) % 2 ^ 64 = (f j).toNat := by
  induction k with
  | zero => omega
  | succ k ih =>
    simp only [joinWords]
    by_cases hjk : j = k
    · subst hjk
      rw [Nat.add_mul_div_right _ _ (Nat.pow_pos (by decide)),
        Nat.div_eq_of_lt (joinWords_lt f j), Nat.zero_add, Nat.mod_eq_of_lt (f j).isLt]
    · have e : 2 ^ (64 * k) = 2 ^ (64 * j) * (2 ^ 64 * 2 ^ (64 * (k - j - 1))) := by
        rw [← Nat.pow_add, ← Nat.pow_add]; congr 1; omega
      rw [e, ← Nat.mul_assoc, Nat.mul_comm _ (2 ^ (64 * j)), Nat.mul_assoc,
        Nat.add_mul_div_left _ _ (Nat.pow_pos (by decide)), ← Nat.mul_assoc,
        Nat.mul_comm _ (2 ^ 64), Nat.mul_assoc, Nat.add_mul_mod_self_left]
      exact ih (by omega)

/-- The words of the vector of given digits are the digits. -/
theorem vecWord_ofInt_joinWords (f : Nat → Word) {j k n : Nat} (hj : j < k) (hn : n = 64 * k) :
    vecWord (BitVec.ofInt n (joinWords f k : Int)) j = f j := by
  subst hn
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.ofInt_natCast]
  simp only [vecWord, BitVec.extractLsb'_toNat, BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
  rw [Nat.mod_eq_of_lt (joinWords_lt f k)]
  exact joinWords_div f hj

theorem toNat_div_vecWord {n : Nat} (v : BitVec n) (j : Nat) :
    v.toNat / 2 ^ (64 * j) % 2 ^ 64 = (vecWord v j).toNat := by
  simp only [vecWord, BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow]

/-! ## Loads -/

theorem loadBytes_length {m : DataMem} {a : Word} {n : Nat} {bs : List UInt8}
    (h : Mem.loadBytes m a n = some bs) : bs.length = n := by
  induction n generalizing a bs with
  | zero => rw [loadBytes_zero] at h; cases h; rfl
  | succ n ih =>
    rw [loadBytes_succ] at h
    cases hb : m[a]? with
    | none => simp [hb] at h
    | some b =>
      cases hr : Mem.loadBytes m (a + 1) n with
      | none => rw [hb, hr] at h; simp at h
      | some r =>
        simp only [hb, hr, Option.bind_some, Option.map_some, Option.some.injEq] at h
        subst h
        simp [ih hr]

theorem loadBytes_add (m : DataMem) (a : Word) (n1 n2 : Nat) :
    Mem.loadBytes m a (n1 + n2) =
      (Mem.loadBytes m a n1).bind fun b1 =>
        (Mem.loadBytes m (a + BitVec.ofNat 64 n1) n2).map (b1 ++ ·) := by
  induction n1 generalizing a with
  | zero =>
    have e : a + BitVec.ofNat 64 0 = a := BitVec.add_zero a
    simp [loadBytes_zero, e]
  | succ n1 ih =>
    rw [show n1 + 1 + n2 = (n1 + n2) + 1 by omega, loadBytes_succ, loadBytes_succ, ih,
      add_ofNat_succ]
    cases m[a]? with
    | none => rfl
    | some b =>
      cases Mem.loadBytes m (a + 1) n1 with
      | none => rfl
      | some r =>
        cases Mem.loadBytes m (a + 1 + BitVec.ofNat 64 n1) n2 <;> rfl

theorem isSome_of_loadBytes {m : DataMem} {a : Word} {n : Nat}
    (h : (Mem.loadBytes m a n).isSome) {i : Nat} (hi : i < n) :
    (m[a + BitVec.ofNat 64 i]?).isSome := by
  induction n generalizing a i with
  | zero => omega
  | succ n ih =>
    rw [loadBytes_succ] at h
    cases hb : m[a]? with
    | none => simp [hb] at h
    | some b =>
      cases hr : Mem.loadBytes m (a + 1) n with
      | none => rw [hb, hr] at h; simp at h
      | some r =>
        cases i with
        | zero =>
          rw [show a + BitVec.ofNat 64 0 = a from BitVec.add_zero a, hb]; rfl
        | succ i =>
          rw [add_ofNat_succ]
          exact ih (by rw [hr]; rfl) (by omega)

/-- Word loads `braid` allows, at `a` and every eight bytes on, are one load of the model of
the vector with those words. -/
theorem loadInt_of_loads {m : DataMem} {a : Word} {f : Nat → Word} {k : Nat}
    (h : ∀ j, j < k → (memOf m).load (a + BitVec.ofNat 64 (8 * j)) .w64 = some (f j)) :
    Mem.loadInt m a (8 * k) = some (joinWords f k : Int) := by
  have key : ∃ bs, Mem.loadBytes m a (8 * k) = some bs ∧
      Int.ofBytes bs = (joinWords f k : Int) := by
    induction k with
    | zero => exact ⟨[], loadBytes_zero m a, rfl⟩
    | succ k ih =>
      obtain ⟨bs1, h1, e1⟩ := ih fun j hj => h j (by omega)
      obtain ⟨bs2, h2, e2, -⟩ := loadBytes_of_loadN (n := 8) (by decide) (h k (by omega))
      refine ⟨bs1 ++ bs2, ?_, ?_⟩
      · rw [show 8 * (k + 1) = 8 * k + 8 by omega, loadBytes_add, h1, Option.bind_some, h2,
          Option.map_some]
      · have hp : (256 : Int) ^ (8 * k) = ((2 ^ (64 * k) : Nat) : Int) := by
          rw [show 64 * k = 8 * (8 * k) by omega, Nat.pow_mul, Int.natCast_pow]; rfl
        rw [Int.ofBytes_append, e1, e2, loadBytes_length h1, hp]
        simp only [joinWords, Int.natCast_add, Int.natCast_mul]
        rw [Int.mul_comm]
  obtain ⟨bs, hbs, e⟩ := key
  simp [Mem.loadInt, hbs, e]

/-! ## Stores -/

/-- Store the words `f 0` to `f (k - 1)` at `a` and every eight bytes on, in that order. -/
def storeSeq (m : Braid.Mem) (a : Word) (f : Nat → Word) : Nat → Option Braid.Mem
  | 0 => some m
  | k + 1 =>
    (storeSeq m a f k).bind fun m' => m'.store (a + BitVec.ofNat 64 (8 * k)) .w64 (f k)

theorem storeSeq_congr (m : Braid.Mem) (a : Word) {f g : Nat → Word} {k : Nat}
    (h : ∀ j, j < k → f j = g j) : storeSeq m a f k = storeSeq m a g k := by
  induction k with
  | zero => rfl
  | succ k ih => simp only [storeSeq, ih fun j hj => h j (by omega), h k (by omega)]

theorem toBytes_add (n1 n2 : Nat) (i : Int) :
    Int.toBytes (n1 + n2) i = Int.toBytes n1 i ++ Int.toBytes n2 (i / 256 ^ n1) := by
  induction n1 generalizing i with
  | zero => simp [Int.toBytes]
  | succ n1 ih =>
    rw [show n1 + 1 + n2 = (n1 + n2) + 1 by omega]
    simp only [Int.toBytes, List.cons_append, ih]
    rw [Int.pow_succ, Int.ediv_ediv_of_nonneg (by decide), Int.mul_comm]

theorem storeInt_add (m : DataMem) (a : Word) (n1 n2 : Nat) (i : Int) (h : n1 + n2 ≤ 2 ^ 64) :
    Mem.storeInt (Mem.storeInt m a n1 i) (a + BitVec.ofNat 64 n1) n2 (i / 256 ^ n1) =
      Mem.storeInt m a (n1 + n2) i := by
  have hl := Int.toBytes_length n1 i
  have hl2 := Int.toBytes_length n2 (i / 256 ^ n1)
  simp only [Mem.storeInt, Mem.storeBytes, toBytes_add]
  rw [List.At_append _ _ _ (by omega), hl]
  apply Std.ExtHashMap.ext_getElem?
  intro x
  simp only [Std.ExtHashMap.union_eq, Std.ExtHashMap.getElem?_union, Option.or_assoc]

theorem isSome_of_storeInt {m : DataMem} {a x : Word} {n : Nat} {i : Int}
    (hl : (Mem.loadBytes m a n).isSome) (hn : n ≤ 2 ^ 64)
    (h : ((Mem.storeInt m a n i)[x]?).isSome) : (m[x]?).isSome := by
  have hlen : (Int.toBytes n i).length ≤ 2 ^ 64 := by rw [Int.toBytes_length]; exact hn
  simp only [Mem.storeInt, Mem.storeBytes, Std.ExtHashMap.union_eq,
    Std.ExtHashMap.getElem?_union, get?_At _ _ _ hlen] at h
  by_cases hx : (x - a).toNat < n
  · have e : a + BitVec.ofNat 64 (x - a).toNat = x := by
      rw [BitVec.ofNat_toNat, BitVec.setWidth_eq, BitVec.add_comm, BitVec.sub_add_cancel]
    rw [← e]
    exact isSome_of_loadBytes hl hx
  · rw [List.getElem?_eq_none (by rw [Int.toBytes_length]; omega)] at h
    simpa using h

theorem storeBytes_of_storeSeq {m : DataMem} {a : Word} {f : Nat → Word} {k : Nat}
    {m' : Braid.Mem} (hk : k ≤ 8) (h : storeSeq (memOf m) a f k = some m') (N : Nat)
    (hN : ∀ j, j < k → N / 2 ^ (64 * j) % 2 ^ 64 = (f j).toNat) :
    (Mem.loadBytes m a (8 * k)).isSome ∧ m' = memOf (Mem.storeInt m a (8 * k) (N : Int)) := by
  induction k generalizing m' with
  | zero =>
    cases h
    refine ⟨by simp [loadBytes_zero], ?_⟩
    funext x
    simp [memOf, Mem.storeInt, Mem.storeBytes, Int.toBytes, List.At,
      Std.ExtHashMap.getElem?_union]
  | succ k ih =>
    simp only [storeSeq, Option.bind_eq_some_iff] at h
    obtain ⟨m1, h1, h2⟩ := h
    obtain ⟨hs1, rfl⟩ := ih (by omega) h1 fun j hj => hN j (by omega)
    have hp : (256 : Int) ^ (8 * k) = ((2 ^ (64 * k) : Nat) : Int) := by
      rw [show 64 * k = 8 * (8 * k) by omega, Nat.pow_mul, Int.natCast_pow]; rfl
    have hi : ((N : Int) / 256 ^ (8 * k)) % 2 ^ (8 * 8) = ((f k).toNat : Int) % 2 ^ (8 * 8) := by
      have := hN k (by omega)
      have hf := (f k).isLt
      rw [hp, ← Int.natCast_ediv]
      omega
    obtain ⟨hs2, rfl⟩ := storeInt_of_storeN (n := 8) (by decide) h2 _ hi
    rw [show 8 * (k + 1) = 8 * k + 8 by omega]
    refine ⟨?_, by rw [storeInt_add _ _ _ _ _ (by omega)]⟩
    have hb : (Mem.loadBytes m (a + BitVec.ofNat 64 (8 * k)) 8).isSome := by
      have hs2' : (Mem.loadBytes (Mem.storeInt m a (8 * k) (N : Int))
          (a + BitVec.ofNat 64 (8 * k)) 8).isSome := by
        simp only [Mem.loadInt, Option.isSome_map] at hs2
        exact hs2
      exact loadBytes_isSome fun i hi =>
        isSome_of_storeInt hs1 (by omega) (isSome_of_loadBytes hs2' hi)
    obtain ⟨b1, hb1⟩ := Option.isSome_iff_exists.1 hs1
    obtain ⟨b2, hb2⟩ := Option.isSome_iff_exists.1 hb
    rw [loadBytes_add, hb1, Option.bind_some, hb2]
    rfl

/-- Word stores `braid` allows, at `a` and every eight bytes on, are one store of the model,
of a vector with those words: the model has every byte, and the memory after it is the
`braid` memory after them. -/
theorem storeInt_of_storeSeq {m : DataMem} {a : Word} {k b : Nat} {v : BitVec b}
    {m' : Braid.Mem} (hk : k ≤ 8) (hb : b = 8 * (8 * k))
    (h : storeSeq (memOf m) a (vecWord v) k = some m') :
    (Mem.loadInt m a (8 * k)).isSome ∧ m' = memOf (Mem.storeInt m a (8 * k) v.toInt) := by
  obtain ⟨hs, hm⟩ := storeBytes_of_storeSeq hk h v.toNat fun j _ => toNat_div_vecWord v j
  refine ⟨by simpa [Mem.loadInt] using hs, ?_⟩
  have hi : Int.toBytes (8 * k) v.toInt = Int.toBytes (8 * k) (v.toNat : Int) := by
    rw [← Int.toBytes_emod _ v.toInt, ← Int.toBytes_emod _ (v.toNat : Int)]
    congr 1
    simp only [Int.take]
    rw [← hb, BitVec.toInt_eq_toNat_bmod]
    exact Int.bmod_emod
  rw [hm]
  simp only [Mem.storeInt, hi]

/-! ## Packed addition -/

theorem lane_append_zero {m n : Nat} (hi : BitVec m) (lo : BitVec 32) (hn : 32 ≤ n) :
    ((BitVec.append hi lo).setWidth n).extractLsb' 0 32 = lo := by
  apply BitVec.eq_of_getLsbD_eq
  intro t ht
  have : t < n := by omega
  simp [BitVec.append_eq, BitVec.getLsbD_append, ht, this]

theorem lane_append_succ {m n : Nat} (hi : BitVec m) (lo : BitVec 32) (i : Nat)
    (hn : 32 * (i + 2) ≤ n) :
    ((BitVec.append hi lo).setWidth n).extractLsb' (32 * (i + 1)) 32 =
      hi.extractLsb' (32 * i) 32 := by
  apply BitVec.eq_of_getLsbD_eq
  intro t ht
  have h1 : 32 * (i + 1) + t < n := by omega
  have h2 : ¬ 32 * (i + 1) + t < 32 := by omega
  have e : 32 * (i + 1) + t - 32 = 32 * i + t := by omega
  simp [BitVec.append_eq, BitVec.getLsbD_append, ht, h1, h2, e]

theorem lane_drop {n : Nat} (a : BitVec n) (i : Nat) (hn : 32 * (i + 2) ≤ n) :
    (a.drop 32).extractLsb' (32 * i) 32 = a.extractLsb' (32 * (i + 1)) 32 := by
  apply BitVec.eq_of_getLsbD_eq
  intro t ht
  have h1 : 32 * i + t < n - 32 := by omega
  have e : 32 + (32 * i + t) = 32 * (i + 1) + t := by omega
  simp [BitVec.drop, ht, h1, e]

/-- Lane `i` of the model's packed operation on 32-bit lanes is the operation on lane `i` of
each operand. -/
theorem lane_packedBinOp {n : Nat} (op : BitVec 32 → BitVec 32 → BitVec 32) (a b : BitVec n)
    (i : Nat) (hi : 32 * (i + 1) ≤ n) :
    (BitVec.packedBinOp 32 op a b).extractLsb' (32 * i) 32 =
      op (a.extractLsb' (32 * i) 32) (b.extractLsb' (32 * i) 32) := by
  induction i generalizing n with
  | zero =>
    rw [BitVec.packedBinOp]
    have hc : ¬ (32 = 0 ∨ n < 32) := by omega
    simp only [hc, ↓reduceDIte]
    exact lane_append_zero _ _ (by omega)
  | succ i ih =>
    rw [BitVec.packedBinOp]
    have hc : ¬ (32 = 0 ∨ n < 32) := by omega
    simp only [hc, ↓reduceDIte]
    rw [lane_append_succ _ _ _ (by omega), ih _ _ (by omega), lane_drop _ _ (by omega),
      lane_drop _ _ (by omega)]

/-- `BinOp.lanes 32 .add` adds the two halves of its words separately. -/
theorem eval_lanes_add (x y : Word) :
    (BinOp.lanes 32 .add).eval x y =
      (x.extractLsb' 32 32 + y.extractLsb' 32 32) ++
        (x.extractLsb' 0 32 + y.extractLsb' 0 32) := by
  rw [BinOp.eval_lanes, show List.range (64 / 32) = [0, 1] from rfl]
  simp only [List.foldl_cons, List.foldl_nil, BinOp.eval_add]
  bv_decide

theorem vecWord_lanes {n : Nat} (v : BitVec n) (j : Nat) :
    vecWord v j = v.extractLsb' (32 * (2 * j + 1)) 32 ++ v.extractLsb' (32 * (2 * j)) 32 := by
  apply BitVec.eq_of_getLsbD_eq
  intro t ht
  simp only [vecWord, BitVec.getLsbD_extractLsb', BitVec.getLsbD_append, ht, decide_true,
    Bool.true_and]
  by_cases h : t < 32
  · have e : 32 * (2 * j) + t = 64 * j + t := by omega
    simp [h, e]
  · have h' : t - 32 < 32 := by omega
    have e : 32 * (2 * j + 1) + (t - 32) = 64 * j + t := by omega
    simp [h, h', e]

theorem vecWord_low {n : Nat} (v : BitVec n) (j : Nat) :
    (vecWord v j).extractLsb' 0 32 = v.extractLsb' (32 * (2 * j)) 32 := by
  apply BitVec.eq_of_getLsbD_eq
  intro t ht
  have h : t < 64 := by omega
  have e : 64 * j + t = 32 * (2 * j) + t := by omega
  simp [vecWord, ht, h, e]

theorem vecWord_high {n : Nat} (v : BitVec n) (j : Nat) :
    (vecWord v j).extractLsb' 32 32 = v.extractLsb' (32 * (2 * j + 1)) 32 := by
  apply BitVec.eq_of_getLsbD_eq
  intro t ht
  have h : 32 + t < 64 := by omega
  have e : 64 * j + (32 + t) = 32 * (2 * j + 1) + t := by omega
  simp [vecWord, ht, h, e]

/-- A word of the model's packed 32-bit addition is `BinOp.lanes 32 .add` on the words of
the operands. -/
theorem vecWord_packedBinOp_add {n : Nat} (a b : BitVec n) (j : Nat) (hj : 64 * (j + 1) ≤ n) :
    vecWord (BitVec.packedBinOp 32 (· + ·) a b) j =
      (BinOp.lanes 32 .add).eval (vecWord a j) (vecWord b j) := by
  rw [eval_lanes_add, vecWord_lanes, lane_packedBinOp _ _ _ _ (by omega),
    lane_packedBinOp _ _ _ _ (by omega), vecWord_low, vecWord_low, vecWord_high, vecWord_high]

/-! ## Lanes -/

theorem getLsbD_foldl_lanes (w c : Nat) (hc : 0 < c) (f : Nat → BitVec c) (n q : Nat) :
    ((List.range n).foldl (fun acc i => acc ||| ((f i).setWidth w <<< (c * i))) 0#w).getLsbD q =
      (decide (q < w) && decide (q / c < n) && (f (q / c)).getLsbD (q % c)) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [List.range_succ, List.foldl_append, List.foldl_cons, List.foldl_nil, BitVec.getLsbD_or,
      ih, BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth]
    by_cases hw : q < w
    · rcases Nat.lt_trichotomy (q / c) n with h | h | h
      · have h1 : q < c * n := by rw [Nat.mul_comm]; exact (Nat.div_lt_iff_lt_mul hc).1 h
        have h2 : q / c < n + 1 := by omega
        simp [hw, h, h1, h2]
      · subst h
        have h1 : ¬ q < c * (q / c) := Nat.not_lt.2 (Nat.mul_div_le q c)
        have h2 : q - c * (q / c) = q % c := by
          have := Nat.div_add_mod q c
          omega
        have h3 : q % c < w := Nat.lt_of_le_of_lt (Nat.mod_le q c) hw
        simp [hw, h1, h2, h3]
      · have h1 : ¬ q / c < n := by omega
        have h2 : ¬ q / c < n + 1 := by omega
        have h3 : c * (n + 1) ≤ q := by
          rw [Nat.mul_comm]; exact (Nat.le_div_iff_mul_le hc).1 h
        have h4 : c ≤ q - c * n := by rw [Nat.mul_succ] at h3; omega
        simp [h1, h2, BitVec.getLsbD_of_ge _ _ h4]
    · simp [hw]

theorem getLsbD_ofLanes (w c : Nat) (hc : 0 < c) (f : Nat → BitVec c) (q : Nat) :
    (BitVec.ofLanes w c f).getLsbD q =
      (decide (q < w) && decide (q / c < w / c) && (f (q / c)).getLsbD (q % c)) :=
  getLsbD_foldl_lanes w c hc f (w / c) q

/-- Lane `i` of the vector of given lanes is the lane given. -/
theorem lane_ofLanes (w c : Nat) (hc : 0 < c) (f : Nat → BitVec c) (i : Nat)
    (hi : c * (i + 1) ≤ w) : (BitVec.ofLanes w c f).extractLsb' (c * i) c = f i := by
  apply BitVec.eq_of_getLsbD_eq
  intro t ht
  have h1 : c * i + t < w := by rw [Nat.mul_succ] at hi; omega
  have h2 : (c * i + t) / c = i := by
    rw [Nat.mul_add_div hc, Nat.div_eq_of_lt ht, Nat.add_zero]
  have h3 : (c * i + t) % c = t := by rw [Nat.mul_add_mod, Nat.mod_eq_of_lt ht]
  have h4 : i < w / c := by
    apply (Nat.le_div_iff_mul_le hc).2
    rw [Nat.mul_comm]
    exact hi
  simp only [BitVec.getLsbD_extractLsb', ht, decide_true, Bool.true_and, BitVec.ofLanes]
  rw [getLsbD_foldl_lanes w c hc, h2, h3]
  simp [h1, h4]

/-- A word of a vector with each 32-bit lane mapped is its two halves mapped. -/
theorem vecWord_mapLanes {n : Nat} (f : BitVec 32 → BitVec 32) (a : BitVec n) (j : Nat)
    (hj : 64 * (j + 1) ≤ n) :
    vecWord (a.mapLanes 32 f) j =
      f ((vecWord a j).extractLsb' 32 32) ++ f ((vecWord a j).extractLsb' 0 32) := by
  rw [vecWord_lanes, vecWord_low, vecWord_high]
  simp only [BitVec.mapLanes, BitVec.lane]
  rw [lane_ofLanes _ _ (by decide) _ _ (by omega), lane_ofLanes _ _ (by decide) _ _ (by omega)]

/-! ## Rotations and shifts of lanes -/

theorem rotateRight_lane (x : BitVec 32) (c : BitVec 8) :
    x.rotateRight (c.toNat % 32) =
      x >>> ((c &&& 31#8).zeroExtend 32) ||| x <<< (32#32 - (c &&& 31#8).zeroExtend 32) := by
  have e1 : ((c &&& 31#8).zeroExtend 32).toNat = c.toNat % 32 := by
    have e : c &&& 31#8 = c % 32#8 := by bv_decide
    rw [e]
    simp only [BitVec.truncate_eq_setWidth, BitVec.toNat_setWidth, BitVec.toNat_umod,
      BitVec.toNat_ofNat, Nat.reducePow, Nat.reduceMod]
    omega
  have e2 : (32#32 - (c &&& 31#8).zeroExtend 32).toNat = 32 - c.toNat % 32 := by
    rw [BitVec.toNat_sub_of_le (by bv_decide), e1]
    rfl
  rw [BitVec.rotateRight_def, BitVec.shiftLeft_eq', BitVec.ushiftRight_eq', e1, e2,
    Nat.mod_mod_of_dvd _ (Nat.dvd_refl 32)]

/-- A word of the model's rotation of 32-bit lanes is `rorLanes` of the word. -/
theorem vecWord_rotateRight {n : Nat} (a : BitVec n) (c : BitVec 8) (j : Nat)
    (hj : 64 * (j + 1) ≤ n) :
    vecWord (a.mapLanes 32 (·.rotateRight (c.toNat % 32))) j = rorLanes c (vecWord a j) := by
  rw [vecWord_mapLanes _ _ _ hj, rotateRight_lane, rotateRight_lane]
  generalize vecWord a j = x
  simp only [rorLanes, rorCount, dup32]
  bv_decide

/-- A word of the model's shift of 32-bit lanes is `shrLanes` of the word. -/
theorem vecWord_shiftRight {n : Nat} (a : BitVec n) (c : BitVec 8) (j : Nat)
    (hj : 64 * (j + 1) ≤ n) :
    vecWord (a.mapLanes 32 (fun x => if c.toNat < 32 then x >>> c.toNat else 0#32)) j =
      shrLanes c (vecWord a j) := by
  have e : ∀ x : BitVec 32,
      (if c.toNat < 32 then x >>> c.toNat else 0#32) = if c < 32#8 then x >>> c else 0#32 := by
    intro x
    have h : c.toNat < 32 ↔ c < 32#8 := by rw [BitVec.lt_def]; rfl
    simp only [h, BitVec.ushiftRight_eq']
  rw [vecWord_mapLanes _ _ _ hj, e, e]
  generalize vecWord a j = x
  simp only [shrLanes, dup32]
  bv_decide

/-! ## Bitwise functions -/

theorem vecWord_or {n : Nat} (x y : BitVec n) (j : Nat) :
    vecWord (x ||| y) j = vecWord x j ||| vecWord y j := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp [vecWord, hi]

theorem vecWord_and {n : Nat} (x y : BitVec n) (j : Nat) :
    vecWord (x &&& y) j = vecWord x j &&& vecWord y j := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp [vecWord, hi]

theorem vecWord_not {n : Nat} (x : BitVec n) (j : Nat) (hj : 64 * (j + 1) ≤ n) :
    vecWord (~~~x) j = ~~~vecWord x j := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have : 64 * j + i < n := by omega
  simp [vecWord, hi, this]

/-- A word of the model's bitwise function of three vectors is the function of the words. -/
theorem vecWord_ternaryLogic {n : Nat} (a b c : BitVec n) (t : BitVec 8) (j : Nat)
    (hj : 64 * (j + 1) ≤ n) :
    vecWord (BitVec.ternaryLogic a b c t) j =
      BitVec.ternaryLogic (vecWord a j) (vecWord b j) (vecWord c j) t := by
  have hp : ∀ (bit : Bool) (v : BitVec n),
      vecWord (if bit then v else ~~~v) j = if bit then vecWord v j else ~~~vecWord v j := by
    intro bit v
    cases bit
    · exact vecWord_not v j hj
    · rfl
  have key : ∀ (l : List Nat) (acc : BitVec n),
      vecWord (l.foldl (fun acc k =>
        if t.getLsbD k then
          acc ||| ((if k / 4 % 2 == 1 then a else ~~~a) &&& (if k / 2 % 2 == 1 then b else ~~~b) &&&
            (if k % 2 == 1 then c else ~~~c))
        else acc) acc) j =
      l.foldl (fun acc k =>
        if t.getLsbD k then
          acc ||| ((if k / 4 % 2 == 1 then vecWord a j else ~~~vecWord a j) &&&
            (if k / 2 % 2 == 1 then vecWord b j else ~~~vecWord b j) &&&
            (if k % 2 == 1 then vecWord c j else ~~~vecWord c j))
        else acc) (vecWord acc j) := by
    intro l
    induction l with
    | nil => intro acc; rfl
    | cons k l ih =>
      intro acc
      rw [List.foldl_cons, List.foldl_cons, ih]
      congr 1
      cases t.getLsbD k
      · rfl
      · simp only [↓reduceIte, vecWord_or, vecWord_and, hp]
  have h0 : vecWord (0#n) j = 0#64 := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp [vecWord]
  simp only [BitVec.ternaryLogic]
  rw [key, h0]

/-- `ternLanes` is the model's bitwise function of three words. -/
theorem ternaryLogic_eq_ternLanes (a b c : Word) (t : BitVec 8) :
    BitVec.ternaryLogic a b c t = ternLanes t a b c := by
  simp only [BitVec.ternaryLogic, ternLanes, bitMask,
    show List.range 8 = [0, 1, 2, 3, 4, 5, 6, 7] from rfl, List.foldl_cons, List.foldl_nil]
  simp only [Nat.reduceDiv, Nat.reduceMod, Nat.reduceBEq, Nat.reduceMul, Nat.reduceAdd,
    ↓reduceIte, Bool.false_eq_true]
  bv_decide

theorem ternaryLogic_5a (a b c : Word) : BitVec.ternaryLogic a b c 0x5a#8 = a ^^^ c := by
  rw [ternaryLogic_eq_ternLanes]
  simp only [ternLanes, bitMask]
  bv_decide

theorem ternaryLogic_3c (a b c : Word) : BitVec.ternaryLogic a b c 0x3c#8 = a ^^^ b := by
  rw [ternaryLogic_eq_ternLanes]
  simp only [ternLanes, bitMask]
  bv_decide

theorem ternaryLogic_66 (a b c : Word) : BitVec.ternaryLogic a b c 0x66#8 = b ^^^ c := by
  rw [ternaryLogic_eq_ternLanes]
  simp only [ternLanes, bitMask]
  bv_decide

theorem ternaryLogic_96 (a b c : Word) : BitVec.ternaryLogic a b c 0x96#8 = a ^^^ b ^^^ c := by
  rw [ternaryLogic_eq_ternLanes]
  simp only [ternLanes, bitMask]
  bv_decide

/-! ## Shuffles -/

/-- A 32-bit lane of a vector is a half of a word, brought down by a shift. -/
theorem lane_eq_vecWord {n : Nat} (a : BitVec n) (i : Nat) :
    a.extractLsb' (32 * i) 32 =
      (vecWord a (i / 2) >>> BitVec.ofNat 64 (32 * (i % 2))).setWidth 32 := by
  rcases Nat.mod_two_eq_zero_or_one i with h | h
  · have e : i = 2 * (i / 2) := by omega
    rw [h]
    conv => lhs; rw [e]
    rw [← vecWord_low]
    generalize vecWord a (i / 2) = x
    bv_decide
  · have e : i = 2 * (i / 2) + 1 := by omega
    rw [h]
    conv => lhs; rw [e]
    rw [← vecWord_high]
    generalize vecWord a (i / 2) = x
    bv_decide

/-- A word of the model's shuffle of 32-bit lanes: each half is the half of a word that
`shufLane` names. -/
theorem vecWord_shuffleDwords {n : Nat} (a : BitVec n) (imm : BitVec 8) (j : Nat)
    (hj : 64 * (j + 1) ≤ n) :
    vecWord (a.shuffleDwords imm) j =
      (vecWord a (shufLane imm (2 * j) / 2) >>>
          BitVec.ofNat 64 (32 * (shufLane imm (2 * j) % 2)) &&& 0xffffffff#64) |||
        (vecWord a (shufLane imm (2 * j + 1) / 2) >>>
          BitVec.ofNat 64 (32 * (shufLane imm (2 * j + 1) % 2))) <<< 32#64 := by
  rw [vecWord_lanes]
  simp only [BitVec.shuffleDwords, BitVec.lane]
  rw [lane_ofLanes _ _ (by decide) _ _ (by omega), lane_ofLanes _ _ (by decide) _ _ (by omega)]
  rw [← shufLane, ← shufLane, lane_eq_vecWord, lane_eq_vecWord]
  generalize vecWord a (shufLane imm (2 * j) / 2) >>>
    BitVec.ofNat 64 (32 * (shufLane imm (2 * j) % 2)) = x
  generalize vecWord a (shufLane imm (2 * j + 1) / 2) >>>
    BitVec.ofNat 64 (32 * (shufLane imm (2 * j + 1) % 2)) = y
  bv_decide

/-! ## Blends -/

/-- A word of the model's blend of 16-bit lanes is a choice between the words of its
operands, by `blendMask`. -/
theorem vecWord_blendWords {n : Nat} (a b : BitVec n) (imm : BitVec 8) (j : Nat)
    (hj : 64 * (j + 1) ≤ n) :
    vecWord (a.blendWords b imm) j =
      vecWord a j ^^^ ((vecWord a j ^^^ vecWord b j) &&& blendMask imm j) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have h1 : 64 * j + i < n := by omega
  have h2 : (64 * j + i) / 16 = 4 * j + i / 16 := by omega
  have h3 : (64 * j + i) % 16 = i % 16 := by omega
  have h4 : 4 * j + i / 16 < n / 16 := by omega
  have h5 : i / 16 < 64 / 16 := by omega
  have h6 : 16 * (4 * j + i / 16) + i % 16 = 64 * j + i := by omega
  have h7 : i % 16 < 16 := by omega
  simp only [vecWord, BitVec.blendWords, blendMask, BitVec.lane, BitVec.getLsbD_extractLsb',
    BitVec.getLsbD_xor, BitVec.getLsbD_and, getLsbD_ofLanes _ _ (show 0 < 16 by decide), hi, h1,
    h2, h3, h4, h5, decide_true, Bool.true_and]
  have h8 : (BitVec.allOnes 16).getLsbD (i % 16) = true := by
    rw [BitVec.getLsbD_allOnes]
    exact decide_eq_true h7
  cases imm.getLsbD ((4 * j + i / 16) % 8)
  · simp [h6, h7]
  · simp only [↓reduceIte, h8]
    simp [h6, h7]

/-! ## Shifts of bytes -/

/-- Word `q` of the block of word `j`, of two words of `lo` below two words of `hi`; zero
above them. -/
def alignSrc {n : Nat} (hi lo : BitVec n) (j q : Nat) : Word :=
  if q < 2 then vecWord lo (2 * (j / 2) + q)
  else if q < 4 then vecWord hi (2 * (j / 2) + q - 2) else 0#64

/-- Bit `x` of the block of word `j`. -/
def alignBit {n : Nat} (hi lo : BitVec n) (j x : Nat) : Bool :=
  if x < 128 then lo.getLsbD (128 * (j / 2) + x)
  else if x < 256 then hi.getLsbD (128 * (j / 2) + x - 128) else false

theorem getLsbD_alignSrc {n : Nat} (hi lo : BitVec n) (j q x : Nat) :
    (alignSrc hi lo j q).getLsbD x = (decide (x < 64) && alignBit hi lo j (64 * q + x)) := by
  by_cases hx : x < 64
  · by_cases h2 : q < 2
    · have h : 64 * q + x < 128 := by omega
      have e : 64 * (2 * (j / 2) + q) + x = 128 * (j / 2) + (64 * q + x) := by omega
      simp [alignSrc, alignBit, vecWord, hx, h2, h, e]
    · by_cases h4 : q < 4
      · have h : ¬ 64 * q + x < 128 := by omega
        have h' : 64 * q + x < 256 := by omega
        have e : 64 * (2 * (j / 2) + q - 2) + x = 128 * (j / 2) + (64 * q + x) - 128 := by
          omega
        simp [alignSrc, alignBit, vecWord, hx, h2, h4, h, h', e]
      · have h : ¬ 64 * q + x < 128 := by omega
        have h' : ¬ 64 * q + x < 256 := by omega
        simp [alignSrc, alignBit, h2, h4, h, h']
  · simp [hx, BitVec.getLsbD_of_ge _ _ (Nat.le_of_not_lt hx)]

/-- A word of the model's shift of bytes is two words of the block, shifted and or-ed. -/
theorem vecWord_alignBytes {n : Nat} (hi lo : BitVec n) (imm : BitVec 8) (j : Nat)
    (hj : 128 * (j / 2 + 1) ≤ n) :
    vecWord (hi.alignBytes lo imm) j =
      alignSrc hi lo j (alignWord imm.toNat j) >>>
          BitVec.ofNat 64 (8 * alignByte imm.toNat j) |||
        alignSrc hi lo j (alignWord imm.toNat j + 1) <<<
          BitVec.ofNat 64 (64 - 8 * alignByte imm.toNat j) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi'
  have hr : alignByte imm.toNat j < 8 := Nat.mod_lt _ (by decide)
  have hq : 8 * (j % 2) + imm.toNat = 8 * alignWord imm.toNat j + alignByte imm.toNat j :=
    (Nat.div_add_mod _ 8).symm
  generalize alignWord imm.toNat j = q at hq ⊢
  generalize alignByte imm.toNat j = r at hr hq ⊢
  have e1 : (BitVec.ofNat 64 (8 * r)).toNat = 8 * r := by
    rw [BitVec.toNat_ofNat]; omega
  have e2 : (BitVec.ofNat 64 (64 - 8 * r)).toNat = 64 - 8 * r := by
    rw [BitVec.toNat_ofNat]; omega
  have lhs : (vecWord (hi.alignBytes lo imm) j).getLsbD i =
      alignBit hi lo j (64 * q + 8 * r + i) := by
    have h1 : 64 * j + i < n := by omega
    have h2 : (64 * j + i) / 8 = 8 * j + i / 8 := by omega
    have h3 : (64 * j + i) % 8 = i % 8 := by omega
    have h4 : 8 * j + i / 8 < n / 8 := by omega
    have h5 : (8 * j + i / 8) % 16 = 8 * (j % 2) + i / 8 := by omega
    have h6 : (8 * j + i / 8) / 16 = j / 2 := by omega
    have h7 : i % 8 < 8 := by omega
    simp only [vecWord, BitVec.alignBytes, BitVec.lane, BitVec.getLsbD_extractLsb',
      getLsbD_ofLanes _ _ (show 0 < 8 by decide), hi', h1, h2, h3, h4, h5, h6, decide_true,
      Bool.true_and]
    by_cases c1 : 8 * (j % 2) + i / 8 + imm.toNat < 16
    · have h : 64 * q + 8 * r + i < 128 := by omega
      have e : 8 * (16 * (j / 2) + (8 * (j % 2) + i / 8 + imm.toNat)) + i % 8 =
          128 * (j / 2) + (64 * q + 8 * r + i) := by omega
      simp [alignBit, c1, h, h7, e]
    · by_cases c2 : 8 * (j % 2) + i / 8 + imm.toNat < 32
      · have h : ¬ 64 * q + 8 * r + i < 128 := by omega
        have h' : 64 * q + 8 * r + i < 256 := by omega
        have e : 8 * (16 * (j / 2) + (8 * (j % 2) + i / 8 + imm.toNat) - 16) + i % 8 =
            128 * (j / 2) + (64 * q + 8 * r + i) - 128 := by omega
        simp [alignBit, c1, c2, h, h', h7, e]
      · have h : ¬ 64 * q + 8 * r + i < 128 := by omega
        have h' : ¬ 64 * q + 8 * r + i < 256 := by omega
        simp [alignBit, c1, c2, h, h']
  rw [lhs, BitVec.getLsbD_or, BitVec.ushiftRight_eq', BitVec.shiftLeft_eq',
    BitVec.getLsbD_ushiftRight, BitVec.getLsbD_shiftLeft, getLsbD_alignSrc, getLsbD_alignSrc,
    e1, e2]
  by_cases c : 8 * r + i < 64
  · have h : i < 64 - 8 * r := by omega
    have e : 64 * q + (8 * r + i) = 64 * q + 8 * r + i := by omega
    simp [c, h, hi', e]
  · have h : ¬ i < 64 - 8 * r := by omega
    have h' : i - (64 - 8 * r) < 64 := by omega
    have e : 64 * (q + 1) + (i - (64 - 8 * r)) = 64 * q + 8 * r + i := by omega
    simp [c, h, h', hi', e]

/-! ## Shuffles of bytes -/

/-- A word of the vector of given bytes is the word of its eight bytes. -/
theorem vecWord_ofLanes {n : Nat} (f : Nat → BitVec 8) (j : Nat) (hj : 64 * (j + 1) ≤ n) :
    vecWord (BitVec.ofLanes n 8 f) j = BitVec.ofLanes 64 8 fun t => f (8 * j + t) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have h1 : 64 * j + i < n := by omega
  have h2 : (64 * j + i) / 8 = 8 * j + i / 8 := by omega
  have h3 : (64 * j + i) % 8 = i % 8 := by omega
  have h4 : 8 * j + i / 8 < n / 8 := by omega
  have h5 : i / 8 < 64 / 8 := by omega
  simp only [vecWord, BitVec.getLsbD_extractLsb', getLsbD_ofLanes _ _ (show 0 < 8 by decide),
    hi, h1, h2, h3, h4, h5, decide_true, Bool.true_and]

/-- A byte of a vector is a byte of a word, brought down by a shift. -/
theorem byte_eq_vecWord {n : Nat} (m : BitVec n) (j t : Nat) (ht : t < 8) :
    m.extractLsb' (8 * (8 * j + t)) 8 =
      (vecWord m j >>> BitVec.ofNat 64 (8 * t)).setWidth 8 := by
  apply BitVec.eq_of_getLsbD_eq
  intro u hu
  have e : (BitVec.ofNat 64 (8 * t)).toNat = 8 * t := by rw [BitVec.toNat_ofNat]; omega
  have h1 : 8 * t + u < 64 := by omega
  have h2 : 64 * j + (8 * t + u) = 8 * (8 * j + t) + u := by omega
  simp [vecWord, BitVec.ushiftRight_eq', e, hu, h1, h2]

/-- A byte of a block of 16 is a byte of one of its two words. -/
theorem byte_eq_block {n : Nat} (a : BitVec n) (j y : Nat) (hy : y < 16) :
    a.extractLsb' (8 * (16 * (j / 2) + y)) 8 =
      if y < 8 then (vecWord a (2 * (j / 2)) >>> (8 * y)).setWidth 8
      else (vecWord a (2 * (j / 2) + 1) >>> (8 * (y - 8))).setWidth 8 := by
  apply BitVec.eq_of_getLsbD_eq
  intro u hu
  by_cases h : y < 8
  · have h1 : 8 * y + u < 64 := by omega
    have h2 : 64 * (2 * (j / 2)) + (8 * y + u) = 8 * (16 * (j / 2) + y) + u := by omega
    simp [vecWord, h, hu, h1, h2]
  · have h1 : 8 * (y - 8) + u < 64 := by omega
    have h2 : 64 * (2 * (j / 2) + 1) + (8 * (y - 8) + u) = 8 * (16 * (j / 2) + y) + u := by
      omega
    simp [vecWord, h, hu, h1, h2]

/-- The byte an index picks from a block of two words, by two shifts. -/
theorem byte_of_index (x : BitVec 8) (lo hi : Word) :
    (if x.msb then 0#8
      else if x.toNat % 16 < 8 then (lo >>> (8 * (x.toNat % 16))).setWidth 8
      else (hi >>> (8 * (x.toNat % 16 - 8))).setWidth 8) =
    (lo >>> ((x.zeroExtend 64 &&& 0x8f#64) <<< 3#64) |||
      hi >>> ((x.zeroExtend 64 &&& 0x8f#64) <<< 3#64 - 64#64)).setWidth 8 := by
  have hz : x.toNat % 16 = (x % 16#8).toNat := by rw [BitVec.toNat_umod]; rfl
  rw [hz]
  generalize hz' : x % 16#8 = z
  have hlt := z.isLt
  by_cases h8 : z.toNat < 8
  · have s1 : 8 * z.toNat = (8#64 * z.zeroExtend 64).toNat := by
      simp only [BitVec.truncate_eq_setWidth, BitVec.toNat_mul, BitVec.toNat_setWidth,
        BitVec.toNat_ofNat]
      omega
    have h8' : z < 8#8 := by rw [BitVec.lt_def]; exact h8
    simp only [h8, ↓reduceIte]
    rw [s1, ← BitVec.ushiftRight_eq']
    bv_decide
  · have h8' : 8#8 ≤ z := by rw [BitVec.le_def]; exact Nat.le_of_not_lt h8
    have s2 : 8 * (z.toNat - 8) = (8#64 * (z - 8#8).zeroExtend 64).toNat := by
      have e : (z - 8#8).toNat = z.toNat - 8 := BitVec.toNat_sub_of_le h8'
      simp only [BitVec.truncate_eq_setWidth, BitVec.toNat_mul, BitVec.toNat_setWidth,
        BitVec.toNat_ofNat, e]
      omega
    simp only [h8, ↓reduceIte]
    rw [s2, ← BitVec.ushiftRight_eq']
    bv_decide

theorem ofLanes_congr (w c : Nat) (hc : 0 < c) {f g : Nat → BitVec c}
    (h : ∀ t, t < w / c → f t = g t) : BitVec.ofLanes w c f = BitVec.ofLanes w c g := by
  apply BitVec.eq_of_getLsbD_eq
  intro q _
  rw [getLsbD_ofLanes w c hc, getLsbD_ofLanes w c hc]
  by_cases hq : q / c < w / c
  · rw [h _ hq]
  · simp [hq]

/-- A word of the model's shuffle of bytes is its eight bytes, each `bshufLane` of the word
of indices and the two words of its block. -/
theorem vecWord_shuffleBytes {n : Nat} (a m : BitVec n) (j : Nat)
    (hj : 128 * (j / 2 + 1) ≤ n) :
    vecWord (a.shuffleBytes m) j =
      0#64 ||| bshufLane (vecWord m j) (vecWord a (2 * (j / 2))) (vecWord a (2 * (j / 2) + 1)) 0
        ||| bshufLane (vecWord m j) (vecWord a (2 * (j / 2))) (vecWord a (2 * (j / 2) + 1)) 1
        ||| bshufLane (vecWord m j) (vecWord a (2 * (j / 2))) (vecWord a (2 * (j / 2) + 1)) 2
        ||| bshufLane (vecWord m j) (vecWord a (2 * (j / 2))) (vecWord a (2 * (j / 2) + 1)) 3
        ||| bshufLane (vecWord m j) (vecWord a (2 * (j / 2))) (vecWord a (2 * (j / 2) + 1)) 4
        ||| bshufLane (vecWord m j) (vecWord a (2 * (j / 2))) (vecWord a (2 * (j / 2) + 1)) 5
        ||| bshufLane (vecWord m j) (vecWord a (2 * (j / 2))) (vecWord a (2 * (j / 2) + 1)) 6
        ||| bshufLane (vecWord m j) (vecWord a (2 * (j / 2))) (vecWord a (2 * (j / 2) + 1)) 7 := by
  have key : ∀ t, t < 64 / 8 →
      (if (m.lane 8 (8 * j + t)).msb then 0#8
        else a.lane 8 (16 * ((8 * j + t) / 16) + (m.lane 8 (8 * j + t)).toNat % 16)) =
      (vecWord a (2 * (j / 2)) >>> bshufCount (vecWord m j) t |||
        vecWord a (2 * (j / 2) + 1) >>> (bshufCount (vecWord m j) t - 64#64)).setWidth 8 := by
    intro t ht
    have e : (8 * j + t) / 16 = j / 2 := by omega
    simp only [BitVec.lane, e]
    rw [byte_eq_vecWord m j t (by omega)]
    generalize hx : (vecWord m j >>> BitVec.ofNat 64 (8 * t)).setWidth 8 = x
    rw [byte_eq_block a j _ (Nat.mod_lt _ (by decide)), byte_of_index]
    have ec : (x.zeroExtend 64 &&& 0x8f#64) <<< 3#64 = bshufCount (vecWord m j) t := by
      rw [← hx, bshufCount]
      generalize vecWord m j >>> BitVec.ofNat 64 (8 * t) = y
      bv_decide
    rw [ec]
  rw [BitVec.shuffleBytes, vecWord_ofLanes _ _ (by omega), ofLanes_congr 64 8 (by decide) key]
  simp only [BitVec.ofLanes, bshufLane,
    show List.range (64 / 8) = [0, 1, 2, 3, 4, 5, 6, 7] from rfl, List.foldl_cons, List.foldl_nil]
  generalize vecWord a (2 * (j / 2)) >>> bshufCount (vecWord m j) 0 |||
    vecWord a (2 * (j / 2) + 1) >>> (bshufCount (vecWord m j) 0 - 64#64) = x0
  generalize vecWord a (2 * (j / 2)) >>> bshufCount (vecWord m j) 1 |||
    vecWord a (2 * (j / 2) + 1) >>> (bshufCount (vecWord m j) 1 - 64#64) = x1
  generalize vecWord a (2 * (j / 2)) >>> bshufCount (vecWord m j) 2 |||
    vecWord a (2 * (j / 2) + 1) >>> (bshufCount (vecWord m j) 2 - 64#64) = x2
  generalize vecWord a (2 * (j / 2)) >>> bshufCount (vecWord m j) 3 |||
    vecWord a (2 * (j / 2) + 1) >>> (bshufCount (vecWord m j) 3 - 64#64) = x3
  generalize vecWord a (2 * (j / 2)) >>> bshufCount (vecWord m j) 4 |||
    vecWord a (2 * (j / 2) + 1) >>> (bshufCount (vecWord m j) 4 - 64#64) = x4
  generalize vecWord a (2 * (j / 2)) >>> bshufCount (vecWord m j) 5 |||
    vecWord a (2 * (j / 2) + 1) >>> (bshufCount (vecWord m j) 5 - 64#64) = x5
  generalize vecWord a (2 * (j / 2)) >>> bshufCount (vecWord m j) 6 |||
    vecWord a (2 * (j / 2) + 1) >>> (bshufCount (vecWord m j) 6 - 64#64) = x6
  generalize vecWord a (2 * (j / 2)) >>> bshufCount (vecWord m j) 7 |||
    vecWord a (2 * (j / 2) + 1) >>> (bshufCount (vecWord m j) 7 - 64#64) = x7
  bv_decide

/-! ## SHA-256 -/

theorem lane_even {n : Nat} (v : BitVec n) (j : Nat) :
    v.lane 32 (2 * j) = (vecWord v j).setWidth 32 := by
  rw [BitVec.lane, ← vecWord_low]
  generalize vecWord v j = x
  bv_decide

theorem lane_odd {n : Nat} (v : BitVec n) (j : Nat) :
    v.lane 32 (2 * j + 1) = (vecWord v j >>> 32#64).setWidth 32 := by
  rw [BitVec.lane, ← vecWord_high]
  generalize vecWord v j = x
  bv_decide

/-- A word of the vector of given 32-bit lanes is two of them. -/
theorem vecWord_ofLanes32 (w : Nat) (f : Nat → BitVec 32) (j : Nat) (hj : 64 * (j + 1) ≤ w) :
    vecWord (BitVec.ofLanes w 32 f) j = f (2 * j + 1) ++ f (2 * j) := by
  rw [vecWord_lanes, lane_ofLanes _ _ (by decide) _ _ (by omega),
    lane_ofLanes _ _ (by decide) _ _ (by omega)]

/-- The low word of the model's `sha256msg1` is `msg1Lo` of the words of the destination. -/
theorem vecWord_msg1_zero (d s : BitVec 128) :
    vecWord (Sha256.msg1 d s) 0 = msg1Lo (vecWord d 0) (vecWord d 1) := by
  have h0 : d.lane 32 0 = (vecWord d 0).setWidth 32 := lane_even d 0
  have h1 : d.lane 32 1 = (vecWord d 0 >>> 32#64).setWidth 32 := lane_odd d 0
  have h2 : d.lane 32 2 = (vecWord d 1).setWidth 32 := lane_even d 1
  rw [Sha256.msg1, vecWord_ofLanes32 _ _ _ (by decide)]
  simp only [Nat.reduceMul, Nat.reduceAdd, Nat.reduceLT, ↓reduceIte, h0, h1, h2, msg1Lo,
    eval_lanes_add, sigLanes, rorLanes, rorCount, shrLanes, dup32, Sha256.σ₀]
  generalize vecWord d 0 = x
  generalize vecWord d 1 = y
  bv_decide

/-- The high word of the model's `sha256msg1` is `msg1Hi` of the high word of the destination
and the low word of the source. -/
theorem vecWord_msg1_one (d s : BitVec 128) :
    vecWord (Sha256.msg1 d s) 1 = msg1Hi (vecWord d 1) (vecWord s 0) := by
  have h2 : d.lane 32 2 = (vecWord d 1).setWidth 32 := lane_even d 1
  have h3 : d.lane 32 3 = (vecWord d 1 >>> 32#64).setWidth 32 := lane_odd d 1
  have h4 : s.lane 32 0 = (vecWord s 0).setWidth 32 := lane_even s 0
  rw [Sha256.msg1, vecWord_ofLanes32 _ _ _ (by decide)]
  simp only [Nat.reduceMul, Nat.reduceAdd, Nat.reduceLT, ↓reduceIte, Nat.lt_irrefl, h2, h3, h4,
    msg1Hi, eval_lanes_add, sigLanes, rorLanes, rorCount, shrLanes, dup32, Sha256.σ₀]
  generalize vecWord d 1 = x
  generalize vecWord s 0 = y
  bv_decide

/-- The low word of the model's `sha256msg2` is `msg2Lo` of the low word of the destination
and the high word of the source. -/
theorem vecWord_msg2_zero (d s : BitVec 128) :
    vecWord (Sha256.msg2 d s) 0 = msg2Lo (vecWord d 0) (vecWord s 1) := by
  have h0 : d.lane 32 0 = (vecWord d 0).setWidth 32 := lane_even d 0
  have h1 : d.lane 32 1 = (vecWord d 0 >>> 32#64).setWidth 32 := lane_odd d 0
  have h2 : s.lane 32 2 = (vecWord s 1).setWidth 32 := lane_even s 1
  have h3 : s.lane 32 3 = (vecWord s 1 >>> 32#64).setWidth 32 := lane_odd s 1
  rw [Sha256.msg2, vecWord_ofLanes32 _ _ _ (by decide)]
  simp only [Nat.reduceMul, Nat.reduceAdd, h0, h1, h2, h3, msg2Lo,
    eval_lanes_add, sigLanes, rorLanes, rorCount, shrLanes, dup32, Sha256.σ₁]
  generalize vecWord d 0 = x
  generalize vecWord s 1 = y
  bv_decide

/-- The high word of the model's `sha256msg2` is `msg2Hi` of the high word of the destination
and the low word of the result. -/
theorem vecWord_msg2_one (d s : BitVec 128) :
    vecWord (Sha256.msg2 d s) 1 =
      msg2Hi (vecWord d 1) (msg2Lo (vecWord d 0) (vecWord s 1)) := by
  have h0 : d.lane 32 0 = (vecWord d 0).setWidth 32 := lane_even d 0
  have h1 : d.lane 32 1 = (vecWord d 0 >>> 32#64).setWidth 32 := lane_odd d 0
  have h2 : s.lane 32 2 = (vecWord s 1).setWidth 32 := lane_even s 1
  have h3 : s.lane 32 3 = (vecWord s 1 >>> 32#64).setWidth 32 := lane_odd s 1
  have h4 : d.lane 32 2 = (vecWord d 1).setWidth 32 := lane_even d 1
  have h5 : d.lane 32 3 = (vecWord d 1 >>> 32#64).setWidth 32 := lane_odd d 1
  rw [Sha256.msg2, vecWord_ofLanes32 _ _ _ (by decide)]
  simp only [Nat.reduceMul, Nat.reduceAdd, h0, h1, h2, h3, h4, h5, msg2Hi, msg2Lo,
    eval_lanes_add, sigLanes, rorLanes, rorCount, shrLanes, dup32, Sha256.σ₁]
  generalize vecWord d 0 = x
  generalize vecWord d 1 = z
  generalize vecWord s 1 = y
  bv_decide

/-- A round of the model, of working words that are the low halves of words, is `rndA` and
`rndE` in the low half. The first and the fifth working word must be below `2 ^ 32`. -/
theorem round_eq (a b c d e f g h k : Word) (ha : a >>> 32#64 = 0#64)
    (he : e >>> 32#64 = 0#64) :
    Sha256.State.round ⟨a.setWidth 32, b.setWidth 32, c.setWidth 32, d.setWidth 32,
        e.setWidth 32, f.setWidth 32, g.setWidth 32, h.setWidth 32⟩ (k.setWidth 32) =
      ⟨(rndA a b c e f g h k &&& 0xffffffff#64).setWidth 32, a.setWidth 32, b.setWidth 32,
        c.setWidth 32, (rndE d e f g h k &&& 0xffffffff#64).setWidth 32, e.setWidth 32,
        f.setWidth 32, g.setWidth 32⟩ := by
  simp only [Sha256.State.round, Sha256.ch, Sha256.maj, Sha256.«Σ₀», Sha256.«Σ₁», rndA,
    rndE, rndT, bigSig, dupLo, Sha256.State.mk.injEq, and_true, true_and]
  constructor <;> bv_decide

theorem rnds2A_lt (x0 x1 y0 y1 k : Word) : rnds2A x0 x1 y0 y1 k >>> 32#64 = 0#64 := by
  rw [rnds2A]
  generalize rndA _ _ _ _ _ _ _ _ = t
  bv_decide

theorem rnds2E_lt (x0 y0 y1 k : Word) : rnds2E x0 y0 y1 k >>> 32#64 = 0#64 := by
  rw [rnds2E]
  generalize rndE _ _ _ _ _ _ = t
  bv_decide

/-- The words of the model's `sha256rnds2` are `rnds2Lo` and `rnds2Hi` of the words of the
source `x`, the destination `y` and the low word of `k`. -/
theorem vecWord_rounds2 (y x k : BitVec 128) :
    vecWord (Sha256.rounds2 y x k) 0 =
        rnds2Lo (vecWord x 0) (vecWord y 0) (vecWord y 1) (vecWord k 0) ∧
      vecWord (Sha256.rounds2 y x k) 1 =
        rnds2Hi (vecWord x 0) (vecWord x 1) (vecWord y 0) (vecWord y 1) (vecWord k 0) := by
  have hx0 : x.lane 32 0 = (vecWord x 0).setWidth 32 := lane_even x 0
  have hx1 : x.lane 32 1 = (vecWord x 0 >>> 32#64).setWidth 32 := lane_odd x 0
  have hx2 : x.lane 32 2 = (vecWord x 1).setWidth 32 := lane_even x 1
  have hx3 : x.lane 32 3 = (vecWord x 1 >>> 32#64).setWidth 32 := lane_odd x 1
  have hy0 : y.lane 32 0 = (vecWord y 0).setWidth 32 := lane_even y 0
  have hy1 : y.lane 32 1 = (vecWord y 0 >>> 32#64).setWidth 32 := lane_odd y 0
  have hy2 : y.lane 32 2 = (vecWord y 1).setWidth 32 := lane_even y 1
  have hy3 : y.lane 32 3 = (vecWord y 1 >>> 32#64).setWidth 32 := lane_odd y 1
  have hk0 : k.lane 32 0 = (vecWord k 0).setWidth 32 := lane_even k 0
  have hk1 : k.lane 32 1 = (vecWord k 0 >>> 32#64).setWidth 32 := lane_odd k 0
  generalize vecWord x 0 = x0 at *
  generalize vecWord x 1 = x1 at *
  generalize vecWord y 0 = y0 at *
  generalize vecWord y 1 = y1 at *
  generalize vecWord k 0 = k0 at *
  have r1 := round_eq (x1 >>> 32#64) x1 (y1 >>> 32#64) y1 (x0 >>> 32#64) x0 (y0 >>> 32#64) y0
    k0 (by bv_decide) (by bv_decide)
  have r2 := round_eq (rnds2A x0 x1 y0 y1 k0) (x1 >>> 32#64) x1 (y1 >>> 32#64)
    (rnds2E x0 y0 y1 k0) (x0 >>> 32#64) x0 (y0 >>> 32#64) (k0 >>> 32#64)
    (rnds2A_lt _ _ _ _ _) (rnds2E_lt _ _ _ _)
  have ea : (rnds2A x0 x1 y0 y1 k0).setWidth 32 =
      (rndA (x1 >>> 32#64) x1 (y1 >>> 32#64) (x0 >>> 32#64) x0 (y0 >>> 32#64) y0 k0 &&&
        0xffffffff#64).setWidth 32 := rfl
  have ee : (rnds2E x0 y0 y1 k0).setWidth 32 =
      (rndE y1 (x0 >>> 32#64) x0 (y0 >>> 32#64) y0 k0 &&& 0xffffffff#64).setWidth 32 := rfl
  rw [ea, ee] at r2
  simp only [Sha256.rounds2, hx0, hx1, hx2, hx3, hy0, hy1, hy2, hy3, hk0, hk1, r1, r2]
  rw [vecWord_ofLanes32 _ _ _ (by decide), vecWord_ofLanes32 _ _ _ (by decide)]
  simp only [Nat.reduceMul, Nat.reduceAdd, rnds2Lo, rnds2Hi, rnds2A, rnds2E]
  generalize rndE y1 _ _ _ _ _ = e1
  generalize rndA (x1 >>> 32#64) _ _ _ _ _ _ _ = a1
  generalize rndE _ _ _ _ _ _ = e2
  generalize rndA _ _ _ _ _ _ _ _ = a2
  constructor <;> bv_decide

end Lowering.X86
