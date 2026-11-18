/-
  Braid.IR.Mem

  Loads and stores, byte by byte. A lowering proves its instruction set's memory accesses
  against these, and the separation logic derives its points-to rules from them.

  ## Main results

  * `Mem.load_w8`, `Mem.load_w16`, `Mem.load_w32`, `Mem.load_w64`: a load succeeds exactly
    when its bytes are mapped, and gives them little-endian
  * `Mem.storeN_spec`: a store succeeds exactly when its bytes are mapped and writable, and
    what memory holds afterwards
-/

module

public import Braid.IR.Semantics
import Std.Tactic.BVDecide

@[expose] public section

namespace Braid

theorem Mem.loadN_succ {m : Mem} {a : Word} {n : Nat} {v : Word} :
    m.loadN a (n + 1) = some v ↔
      ∃ c r, m a = some c ∧ m.loadN (a + 1) n = some r ∧ v = (r <<< 8) ||| c.val.zeroExtend 64 := by
  simp only [Mem.loadN]
  cases hc : m a <;> cases hr : m.loadN (a + 1) n <;> simp [eq_comm]

theorem Mem.loadN_zero {m : Mem} {a : Word} : m.loadN a 0 = some 0 := rfl

theorem Mem.load_w8 {m : Mem} {a v : Word} :
    m.load a .w8 = some v ↔ ∃ c0, m a = some c0 ∧ v = c0.val.zeroExtend 64 := by
  simp only [Mem.load, Width.bytes, Mem.loadN_succ, Mem.loadN_zero, Option.some.injEq]
  constructor
  · rintro ⟨c0, r, h0, rfl, rfl⟩; exact ⟨c0, h0, by simp⟩
  · rintro ⟨c0, h0, rfl⟩; exact ⟨c0, 0, h0, rfl, by simp⟩

theorem Mem.load_w16 {m : Mem} {a v : Word} :
    m.load a .w16 = some v ↔ ∃ c0 c1, m a = some c0 ∧ m (a + 1) = some c1 ∧
      v = (c1.val ++ c0.val).zeroExtend 64 := by
  simp only [Mem.load, Width.bytes, Mem.loadN_succ, Mem.loadN_zero, Option.some.injEq]
  constructor
  · rintro ⟨c0, _, h0, ⟨c1, _, h1, rfl, rfl⟩, rfl⟩
    exact ⟨c0, c1, h0, h1, by bv_decide⟩
  · rintro ⟨c0, c1, h0, h1, rfl⟩
    exact ⟨c0, _, h0, ⟨c1, _, h1, rfl, rfl⟩, by bv_decide⟩

theorem Mem.load_w32 {m : Mem} {a v : Word} :
    m.load a .w32 = some v ↔ ∃ c0 c1 c2 c3, m a = some c0 ∧ m (a + 1) = some c1 ∧
      m (a + 2) = some c2 ∧ m (a + 3) = some c3 ∧
      v = (c3.val ++ c2.val ++ c1.val ++ c0.val).zeroExtend 64 := by
  have e2 : a + 1 + 1 = a + 2 := by bv_decide
  have e3 : a + 2 + 1 = a + 3 := by bv_decide
  simp only [Mem.load, Width.bytes, Mem.loadN_succ, Mem.loadN_zero, Option.some.injEq, e2, e3]
  constructor
  · rintro ⟨c0, _, h0, ⟨c1, _, h1, ⟨c2, _, h2, ⟨c3, _, h3, rfl, rfl⟩, rfl⟩, rfl⟩, rfl⟩
    exact ⟨c0, c1, c2, c3, h0, h1, h2, h3, by bv_decide⟩
  · rintro ⟨c0, c1, c2, c3, h0, h1, h2, h3, rfl⟩
    exact ⟨c0, _, h0, ⟨c1, _, h1, ⟨c2, _, h2, ⟨c3, _, h3, rfl, rfl⟩, rfl⟩, rfl⟩, by bv_decide⟩

theorem Mem.load_w64 {m : Mem} {a v : Word} :
    m.load a .w64 = some v ↔ ∃ c0 c1 c2 c3 c4 c5 c6 c7, m a = some c0 ∧ m (a + 1) = some c1 ∧
      m (a + 2) = some c2 ∧ m (a + 3) = some c3 ∧ m (a + 4) = some c4 ∧ m (a + 5) = some c5 ∧
      m (a + 6) = some c6 ∧ m (a + 7) = some c7 ∧
      v = c7.val ++ c6.val ++ c5.val ++ c4.val ++ c3.val ++ c2.val ++ c1.val ++ c0.val := by
  have e2 : a + 1 + 1 = a + 2 := by bv_decide
  have e3 : a + 2 + 1 = a + 3 := by bv_decide
  have e4 : a + 3 + 1 = a + 4 := by bv_decide
  have e5 : a + 4 + 1 = a + 5 := by bv_decide
  have e6 : a + 5 + 1 = a + 6 := by bv_decide
  have e7 : a + 6 + 1 = a + 7 := by bv_decide
  simp only [Mem.load, Width.bytes, Mem.loadN_succ, Mem.loadN_zero, Option.some.injEq, e2, e3, e4,
    e5, e6, e7]
  constructor
  · rintro ⟨c0, _, h0, ⟨c1, _, h1, ⟨c2, _, h2, ⟨c3, _, h3, ⟨c4, _, h4, ⟨c5, _, h5, ⟨c6, _, h6,
      ⟨c7, _, h7, rfl, rfl⟩, rfl⟩, rfl⟩, rfl⟩, rfl⟩, rfl⟩, rfl⟩, rfl⟩
    exact ⟨c0, c1, c2, c3, c4, c5, c6, c7, h0, h1, h2, h3, h4, h5, h6, h7, by bv_decide⟩
  · rintro ⟨c0, c1, c2, c3, c4, c5, c6, c7, h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩
    exact ⟨c0, _, h0, ⟨c1, _, h1, ⟨c2, _, h2, ⟨c3, _, h3, ⟨c4, _, h4, ⟨c5, _, h5, ⟨c6, _, h6,
      ⟨c7, _, h7, rfl, rfl⟩, rfl⟩, rfl⟩, rfl⟩, rfl⟩, rfl⟩, rfl⟩, by bv_decide⟩

/-- A store of at most eight bytes succeeds exactly when each is mapped and writable. Then
byte `x - a` of the value is at each `x` within `n` of `a`, and the rest is unchanged. -/
theorem Mem.storeN_spec {m m' : Mem} {a v : Word} {n : Nat} (hn : n ≤ 8) :
    m.storeN a v n = some m' ↔
      (∀ x : Word, (x - a).toNat < n → ∃ c, m x = some c ∧ c.writable = true) ∧
      m' = fun x => if (x - a).toNat < n then some ⟨(v >>> ((x - a) <<< 3)).truncate 8, true⟩
        else m x := by
  induction n generalizing m a v with
  | zero =>
    simp only [Mem.storeN, Nat.not_lt_zero, ↓reduceIte, false_implies, implies_true, true_and,
      Option.some.injEq]
    exact eq_comm
  | succ n ih =>
    have hsub : ∀ x : Word, x ≠ a → (x - a).toNat = (x - (a + 1)).toNat + 1 := by
      intro x hx; bv_omega
    have hself : ¬ (a - (a + 1)).toNat < n := by
      have : a - (a + 1) = BitVec.allOnes 64 := by bv_decide
      have e : (BitVec.allOnes 64).toNat = 18446744073709551615 := by decide
      rw [this, e]; omega
    have hval : ∀ x : Word, x ≠ a → (x - a).toNat < n + 1 →
        (v >>> 8) >>> ((x - (a + 1)) <<< 3) = v >>> ((x - a) <<< 3) := by
      intro x hx hlt
      have hlt' : x - a < 8#64 := by bv_omega
      bv_decide
    simp only [Mem.storeN]
    cases hc : m a with
    | none =>
      refine ⟨fun h => absurd h (by simp), fun h => ?_⟩
      obtain ⟨c, hc', _⟩ := h.1 a (by simp)
      rw [hc] at hc'; cases hc'
    | some c =>
      by_cases hwr : c.writable = true
      · simp only [hwr, ↓reduceIte]
        rw [ih (by omega)]
        constructor
        · rintro ⟨hall, rfl⟩
          refine ⟨fun x hx => ?_, ?_⟩
          · by_cases hxa : x = a
            · subst hxa; exact ⟨c, hc, hwr⟩
            · obtain ⟨c', hc', hw'⟩ := hall x (by have := hsub x hxa; omega)
              simp only [hxa, ↓reduceIte] at hc'
              exact ⟨c', hc', hw'⟩
          · funext x
            by_cases hxa : x = a
            · subst hxa
              simp only [hself, ↓reduceIte, BitVec.sub_self]
              simp
            · have h1 := hsub x hxa
              by_cases hlt : (x - (a + 1)).toNat < n
              · have h2 : (x - a).toNat < n + 1 := by omega
                simp only [hlt, h2, ↓reduceIte, hval x hxa h2]
              · have h2 : ¬ (x - a).toNat < n + 1 := by omega
                simp only [hlt, h2, ↓reduceIte, hxa]
        · rintro ⟨hall, rfl⟩
          refine ⟨fun x hx => ?_, ?_⟩
          · have hxa : x ≠ a := by rintro rfl; exact hself hx
            obtain ⟨c', hc', hw'⟩ := hall x (by have := hsub x hxa; omega)
            exact ⟨c', by simp [hxa, hc'], hw'⟩
          · funext x
            by_cases hxa : x = a
            · subst hxa
              simp only [hself, ↓reduceIte, BitVec.sub_self]
              simp
            · have h1 := hsub x hxa
              by_cases hlt : (x - (a + 1)).toNat < n
              · have h2 : (x - a).toNat < n + 1 := by omega
                simp only [hlt, h2, ↓reduceIte, hval x hxa h2]
              · have h2 : ¬ (x - a).toNat < n + 1 := by omega
                simp only [hlt, h2, ↓reduceIte, hxa]
      · simp only [hwr, Bool.false_eq_true, ↓reduceIte]
        refine ⟨fun h => absurd h (by simp), fun h => ?_⟩
        obtain ⟨c', hc', hw'⟩ := h.1 a (by simp)
        rw [hc] at hc'; cases hc'; exact absurd hw' hwr

end Braid
