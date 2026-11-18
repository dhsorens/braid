/-
  Lowering.X86.Mem

  The machine model's memory, as `braid` memory. Kraken keeps data memory as a partial map
  from addresses to bytes, and reads and writes an integer through its list of bytes.
  `braid` memory is the same partial map, with every byte writable. These lemmas say that a
  load or store `braid` allows is one the model performs, with the same bytes.

  ## Main definitions

  * `memOf`: the `braid` memory of the model's memory

  ## Main results

  * `loadInt_of_loadN`: a load `braid` allows is a load of the model, with the same value
  * `storeInt_of_storeN`: a store `braid` allows is a store of the model, with the same bytes
-/

module

public import Braid
public import Kraken.X64.Semantics
import all Kraken.Mem
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.X86

open Braid (Word)

/-- The `braid` memory of the model's memory: every mapped byte, writable. -/
def memOf (m : DataMem) : Braid.Mem := fun a => (m[a]?).map fun b => ⟨b.toBitVec, true⟩

theorem memOf_eq_some {m : DataMem} {a : Word} {c : Braid.Cell} (h : memOf m a = some c) :
    ∃ b, m[a]? = some b ∧ c = ⟨b.toBitVec, true⟩ := by
  simp only [memOf, Option.map_eq_some_iff] at h
  obtain ⟨b, hb, rfl⟩ := h
  exact ⟨b, hb, rfl⟩

/-! ## Loads -/

theorem loadBytes_zero (m : DataMem) (a : Word) : Mem.loadBytes m a 0 = some [] := by
  simp [Mem.loadBytes]

theorem add_ofNat_succ (a : Word) (i : Nat) :
    a + BitVec.ofNat 64 (i + 1) = a + 1 + BitVec.ofNat 64 i := by
  rw [BitVec.add_assoc]; congr 1; rw [Nat.add_comm, BitVec.ofNat_add]; rfl

theorem loadBytes_succ (m : DataMem) (a : Word) (n : Nat) :
    Mem.loadBytes m a (n + 1) =
      (m[a]?).bind fun b => (Mem.loadBytes m (a + 1) n).map (b :: ·) := by
  unfold Mem.loadBytes
  rw [List.range_succ_eq_map, List.map_cons, List.map_map, List.mapM_cons]
  have hf : ((fun i => m.get? (a + BitVec.ofNat 64 i)) ∘ Nat.succ) =
      fun i => m.get? (a + 1 + BitVec.ofNat 64 i) := by
    funext i; simp only [Function.comp, Nat.succ_eq_add_one, add_ofNat_succ]
  have h0 : m.get? (a + BitVec.ofNat 64 0) = m[a]? := by
    rw [Std.ExtHashMap.get?_eq_getElem?]; congr 1; exact BitVec.add_zero a
  rw [hf, h0]
  cases m[a]? with
  | none => rfl
  | some b =>
    simp only [id_eq, Option.bind_some, Option.bind_eq_bind]
    cases List.mapM id (List.map (fun i => m.get? (a + 1 + BitVec.ofNat 64 i)) (List.range n)) <;>
      rfl

/-- A load `braid` allows reads bytes the model has: their integer is the value loaded,
which fits in the bytes read. -/
theorem loadBytes_of_loadN {m : DataMem} {a v : Word} {n : Nat} (hn : n ≤ 8)
    (h : (memOf m).loadN a n = some v) :
    ∃ bs, Mem.loadBytes m a n = some bs ∧ Int.ofBytes bs = (v.toNat : Int) ∧
      v.toNat < 2 ^ (8 * n) := by
  induction n generalizing a v with
  | zero =>
    cases h
    exact ⟨[], loadBytes_zero m a, rfl, by simp⟩
  | succ n ih =>
    obtain ⟨c, r, hc, hr, rfl⟩ := Braid.Mem.loadN_succ.1 h
    obtain ⟨b, hb, rfl⟩ := memOf_eq_some hc
    obtain ⟨bs, hbs, hval, hlt⟩ := ih (by omega) hr
    have hp : 2 ^ (8 * n) ≤ 2 ^ 56 := Nat.pow_le_pow_right (by decide) (by omega)
    have hb8 : b.toBitVec.toNat < 256 := b.toBitVec.isLt
    have hv : (r <<< 8 ||| b.toBitVec.zeroExtend 64).toNat = r.toNat * 256 + b.toBitVec.toNat := by
      rw [BitVec.toNat_or, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth, Nat.shiftLeft_eq,
        Nat.mod_eq_of_lt (a := b.toBitVec.toNat) (by omega), Nat.mod_eq_of_lt (by omega)]
      have := Nat.shiftLeft_add_eq_or_of_lt (i := 8) hb8 r.toNat
      rw [Nat.shiftLeft_eq] at this
      exact this.symm
    refine ⟨b :: bs, by rw [loadBytes_succ, hb, Option.bind_some, hbs, Option.map_some], ?_, ?_⟩
    · rw [Int.ofBytes_cons, hval, hv, UInt8.toNat_toBitVec]
      omega
    · rw [hv, show 8 * (n + 1) = 8 * n + 8 by omega, Nat.pow_add]
      omega

/-- A load `braid` allows is a load of the model, with the same value. -/
theorem loadInt_of_loadN {m : DataMem} {a v : Word} {n : Nat} (hn : n ≤ 8)
    (h : (memOf m).loadN a n = some v) :
    Mem.loadInt m a n = some (v.toNat : Int) ∧ v.toNat < 2 ^ (8 * n) := by
  obtain ⟨bs, hbs, hval, hlt⟩ := loadBytes_of_loadN hn h
  exact ⟨by simp [Mem.loadInt, hbs, hval], hlt⟩

/-- A word below `2 ^ n` is the zero-extension of its low `n` bits. -/
theorem setWidth_setWidth_of_lt {v : Word} {n : Nat} (h : v.toNat < 2 ^ n) :
    (v.setWidth n).setWidth 64 = v := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth]
  rw [Nat.mod_eq_of_lt h, Nat.mod_eq_of_lt v.isLt]

/-! ## Stores -/

theorem loadBytes_isSome {m : DataMem} {a : Word} {n : Nat}
    (h : ∀ i, i < n → (m[a + BitVec.ofNat 64 i]?).isSome) : (Mem.loadBytes m a n).isSome := by
  induction n generalizing a with
  | zero => simp [loadBytes_zero]
  | succ n ih =>
    have h0 := h 0 (by omega)
    rw [show a + BitVec.ofNat 64 0 = a from BitVec.add_zero a] at h0
    obtain ⟨b, hb⟩ := Option.isSome_iff_exists.1 h0
    have hrest : (Mem.loadBytes m (a + 1) n).isSome := ih fun i hi => by
      have := h (i + 1) (by omega)
      rwa [add_ofNat_succ] at this
    obtain ⟨bs, hbs⟩ := Option.isSome_iff_exists.1 hrest
    rw [loadBytes_succ, hb, Option.bind_some, hbs, Option.map_some]; rfl

/-- Byte `k` of the bytes of an integer. -/
theorem toBytes_getElem? (n k : Nat) (i : Int) (hk : k < n) :
    (Int.toBytes n i)[k]? = some ((i / 256 ^ k) % 256).toNat.toUInt8 := by
  induction n generalizing i k with
  | zero => omega
  | succ n ih =>
    cases k with
    | zero => simp [Int.toBytes, Int.take]
    | succ k =>
      simp only [Int.toBytes, List.getElem?_cons_succ]
      rw [ih k (i / 256) (by omega), Int.pow_succ, Int.ediv_ediv_of_nonneg (by decide), Int.mul_comm]

theorem sub_ofNat_toNat (a : Word) {i : Nat} (hi : i < 2 ^ 64) :
    (a + BitVec.ofNat 64 i - a).toNat = i := by
  have : a + BitVec.ofNat 64 i - a = BitVec.ofNat 64 i := by
    rw [BitVec.add_comm, BitVec.add_sub_cancel]
  rw [this, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hi]

/-- A store `braid` allows is a store of the model: the model has every byte, and the
memory after it is the `braid` memory after it. The integer the model stores need only
agree with the word `braid` stores in the bytes written. -/
theorem storeInt_of_storeN {m : DataMem} {a v : Word} {n : Nat} {m' : Braid.Mem} (hn : n ≤ 8)
    (h : (memOf m).storeN a v n = some m') (i : Int)
    (hi : i % 2 ^ (8 * n) = (v.toNat : Int) % 2 ^ (8 * n)) :
    (Mem.loadInt m a n).isSome ∧ m' = memOf (Mem.storeInt m a n i) := by
  obtain ⟨hall, rfl⟩ := (Braid.Mem.storeN_spec hn).1 h
  refine ⟨?_, ?_⟩
  · have : (Mem.loadBytes m a n).isSome := loadBytes_isSome fun k hk => by
      obtain ⟨c, hc, _⟩ := hall (a + BitVec.ofNat 64 k) (by
        rw [sub_ofNat_toNat a (by omega)]; exact hk)
      obtain ⟨b, hb, _⟩ := memOf_eq_some hc
      simp [hb]
    obtain ⟨bs, hbs⟩ := Option.isSome_iff_exists.1 this
    simp [Mem.loadInt, hbs]
  · funext x
    have hbytes : Int.toBytes n i = Int.toBytes n (v.toNat : Int) := by
      rw [← Int.toBytes_emod n i, ← Int.toBytes_emod n (v.toNat : Int)]
      simp only [Int.take, hi]
    have hlen : (Int.toBytes n (v.toNat : Int)).length ≤ 2 ^ 64 := by
      rw [Int.toBytes_length]; omega
    simp only [memOf, Mem.storeInt, Mem.storeBytes, Std.ExtHashMap.union_eq,
      Std.ExtHashMap.getElem?_union, hbytes, get?_At _ _ _ hlen]
    by_cases hx : (x - a).toNat < n
    · have hk8 : (x - a).toNat < 8 := by omega
      simp only [hx, ↓reduceIte, toBytes_getElem? n _ _ hx, Option.some_or, Option.map_some,
        Option.some.injEq, Braid.Cell.mk.injEq, and_true]
      apply BitVec.eq_of_toNat_eq
      have hsh : ((x - a) <<< 3).toNat = 8 * (x - a).toNat := by
        rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega)]
        omega
      have hpow : (256 : Int) ^ (x - a).toNat = ((2 ^ (8 * (x - a).toNat) : Nat) : Int) := by
        rw [Nat.pow_mul, Int.natCast_pow]; rfl
      simp only [BitVec.truncate, BitVec.toNat_setWidth, BitVec.ushiftRight_eq',
        BitVec.toNat_ushiftRight, hsh, Nat.shiftRight_eq_div_pow, hpow]
      rw [← Int.natCast_ediv]
      generalize BitVec.toNat v / 2 ^ (8 * BitVec.toNat (x - a)) = q
      have hq : ((q : Int) % 256).toNat = q % 256 := by omega
      rw [hq, UInt8.toNat_toBitVec, Nat.toUInt8_eq, UInt8.toNat_ofNat']
      omega
    · simp only [hx, ↓reduceIte]
      rw [List.getElem?_eq_none (by rw [Int.toBytes_length]; omega)]
      simp

end Lowering.X86
