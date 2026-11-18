/-
  Lowering.X86.Vec

  The vector registers and vectors in memory, a word at a time. A 512-bit register of the
  model is eight `braid` registers, and a vector in memory is loaded and stored as its words,
  low word first. These lemmas relate the words to the model's one wide value.

  ## Main definitions

  * `setWords`: a state with a run of registers written
  * `joinWords`: the number whose 64-bit digits are given words
  * `storeSeq`: a run of word stores

  ## Main results

  * `RelD.set512`: writing the words of a vector register keeps the states related
  * `loadInt_of_loads`: word loads `braid` allows are one wide load of the model
  * `storeInt_of_storeSeq`: word stores `braid` allows are one wide store of the model
  * `vecWord_packedBinOp_add`: a packed 32-bit addition is `BinOp.lanes 32 .add` on each word
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

end Lowering.X86
