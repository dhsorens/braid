/-
  Lowering.Arm.Mem

  The machine model's memory, byte by byte. arm64-semantics keeps memory as a map from
  addresses to a byte and an optional permission, and checks `canRead` or `canWrite` before
  every access. `braid` memory is cells: a byte and whether it may be written. These lemmas
  say when the model allows an access and what a write does to the bytes.

  ## Main definitions

  * `readable`, `writable`: whether the model lets one byte be loaded, or stored to

  ## Main results

  * `canRead_of`, `canWrite_of`: an access is allowed when each of its bytes is
  * `perm_writeSized`, `read8_writeSized`, `isLazyFree_writeSized`: memory after a write
  * `readSized_w8`, `readSized_w16`, `readSized_w32`, `readSized_w64`: a read, from its bytes
-/

module

public import Braid
public import Arm64.Trusted.ISA.Semantics
import Std.Tactic.BVDecide
import Braid.BV

@[expose] public section

namespace Lowering.Arm

open Braid (Word)
open Arm64 (Memory MemWidth)

/-- The model lets the byte at `a` be loaded: it is mapped readable, and not marked
`lazyFree`. -/
def readable (m : Memory) (a : Word) : Bool := (m.perm a).r && !m.isLazyFree a

/-- The model lets the byte at `a` be stored to: it is mapped writable and not executable. -/
def writable (m : Memory) (a : Word) : Bool := (m.perm a).w && !(m.perm a).x

/-! ## Permission checks, byte by byte -/

theorem canRead_succ (m : Memory) (a : Word) (n : Nat) :
    m.canRead a (n + 1) = (readable m a && m.canRead (a + 1#64) n) := by
  simp only [Memory.canRead, Memory.allPerm, Memory.allNoLazyFree, readable]
  cases (m.perm a).r <;> cases m.isLazyFree a <;> simp

theorem canWrite_succ (m : Memory) (a : Word) (n : Nat) :
    m.canWrite a (n + 1) = (writable m a && m.canWrite (a + 1#64) n) := by
  simp only [Memory.canWrite, Memory.allPerm, writable]

theorem sub_succ_lt {x a : Word} {n : Nat} (hn : n < 8) (h : (x - (a + 1#64)).toNat < n) :
    (x - a).toNat < n + 1 := by
  bv_omega

/-- A read of at most eight bytes is allowed when each byte is readable. -/
theorem canRead_of {m : Memory} {a : Word} {n : Nat} (hn : n ≤ 8)
    (h : ∀ x : Word, (x - a).toNat < n → readable m x = true) : m.canRead a n = true := by
  induction n generalizing a with
  | zero => rfl
  | succ n ih =>
    rw [canRead_succ, h a (by simp), ih (by omega) fun x hx => h x (sub_succ_lt (by omega) hx)]

/-- A write of at most eight bytes is allowed when each byte is writable. -/
theorem canWrite_of {m : Memory} {a : Word} {n : Nat} (hn : n ≤ 8)
    (h : ∀ x : Word, (x - a).toNat < n → writable m x = true) : m.canWrite a n = true := by
  induction n generalizing a with
  | zero => rfl
  | succ n ih =>
    rw [canWrite_succ, h a (by simp), ih (by omega) fun x hx => h x (sub_succ_lt (by omega) hx)]

/-! ## Memory after a write -/

theorem perm_write8 (m : Memory) (a x : Word) (v : BitVec 8) :
    (m.write8 a v).perm x = m.perm x := by
  simp only [Memory.perm, Memory.write8, Memory.rawPerm]
  by_cases hx : x = a
  · subst hx
    simp only [↓reduceIte]
    cases m.cells x with
    | none => rfl
    | some c => obtain ⟨p, b⟩ := c; cases p <;> rfl
  · simp only [hx, ↓reduceIte]

theorem read8_write8 (m : Memory) (a x : Word) (v : BitVec 8) :
    (m.write8 a v).read8 x = if x = a then v else m.read8 x := by
  simp only [Memory.read8, Memory.write8]
  by_cases hx : x = a <;> simp only [hx, ↓reduceIte]

theorem isLazyFree_write8 (m : Memory) (a x : Word) (v : BitVec 8) :
    (m.write8 a v).isLazyFree x = if x = a then false else m.isLazyFree x := by
  simp only [Memory.isLazyFree, Memory.write8, Memory.rawPerm]
  by_cases hx : x = a
  · subst hx
    simp only [↓reduceIte]
    cases m.cells x with
    | none => rfl
    | some c => obtain ⟨p, b⟩ := c; cases p <;> rfl
  · simp only [hx, ↓reduceIte]

/-- A write changes no permission. -/
theorem perm_writeSized (m : Memory) (sz : MemWidth) (a v x : Word) :
    (m.writeSized sz a v).perm x = m.perm x := by
  cases sz <;>
    simp only [Memory.writeSized, Memory.write16, Memory.write32, Memory.write64, perm_write8]

/-- The bytes after a write: byte `x - a` of the value at each `x` within the width of `a`,
and the rest unchanged. -/
theorem read8_writeSized (m : Memory) (sz : MemWidth) (a v x : Word) :
    (m.writeSized sz a v).read8 x =
      if (x - a).toNat < sz.bytes then (v >>> ((x - a) <<< 3)).truncate 8 else m.read8 x := by
  have h1 : (x - a).toNat < 1 ↔ x - a < 1#64 := Iff.rfl
  have h2 : (x - a).toNat < 2 ↔ x - a < 2#64 := Iff.rfl
  have h4 : (x - a).toNat < 4 ↔ x - a < 4#64 := Iff.rfl
  have h8 : (x - a).toNat < 8 ↔ x - a < 8#64 := Iff.rfl
  cases sz <;>
    simp only [Memory.writeSized, Memory.write16, Memory.write32, Memory.write64, read8_write8,
      MemWidth.bytes, h1, h2, h4, h8] <;>
    generalize m.read8 x = b <;>
    -- `x` as `a` plus its offset `d`, and each test of `x` a test of `d`
    obtain ⟨d, rfl⟩ : ∃ d, x = a + d := ⟨x - a, by bv_omega⟩ <;>
    (have e : a + d - a = d := by bv_omega) <;>
    simp only [e, BitVec.add_right_inj, BitVec.add_right_eq_self, BitVec.add_zero] <;>
    -- each choice: the tests contradict each other, or `d` is known
    (repeat' split) <;> first | rfl | (exfalso; bv_omega) | (subst_vars; bv_auto)

/-- A write clears the `lazyFree` mark of the bytes it covers. -/
theorem isLazyFree_writeSized (m : Memory) (sz : MemWidth) (a v x : Word) :
    (m.writeSized sz a v).isLazyFree x =
      if (x - a).toNat < sz.bytes then false else m.isLazyFree x := by
  have h1 : (x - a).toNat < 1 ↔ x - a < 1#64 := Iff.rfl
  have h2 : (x - a).toNat < 2 ↔ x - a < 2#64 := Iff.rfl
  have h4 : (x - a).toNat < 4 ↔ x - a < 4#64 := Iff.rfl
  have h8 : (x - a).toNat < 8 ↔ x - a < 8#64 := Iff.rfl
  cases sz <;>
    simp only [Memory.writeSized, Memory.write16, Memory.write32, Memory.write64,
      isLazyFree_write8, MemWidth.bytes, h1, h2, h4, h8] <;>
    generalize m.isLazyFree x = b <;> bv_auto

theorem allPerm_congr {m m' : Memory} (h : ∀ x, m'.perm x = m.perm x) (p : Option Arm64.Perm → Bool)
    (a : Word) (n : Nat) : m'.allPerm p a n = m.allPerm p a n := by
  induction n generalizing a with
  | zero => rfl
  | succ n ih => simp only [Memory.allPerm, h, ih]

/-- A write changes what may be written nowhere. -/
theorem canWrite_writeSized (m : Memory) (sz : MemWidth) (a v x : Word) (n : Nat) :
    (m.writeSized sz a v).canWrite x n = m.canWrite x n :=
  allPerm_congr (perm_writeSized m sz a v) _ x n

/-! ## Reads, from their bytes -/

theorem readSized_w8 (m : Memory) (a : Word) :
    m.readSized .B8 false a = (m.read8 a).zeroExtend 64 := rfl

theorem readSized_w16 (m : Memory) (a : Word) :
    m.readSized .H16 false a = (m.read8 (a + 1) ++ m.read8 a).zeroExtend 64 := by
  simp [Memory.readSized, Memory.read16]

theorem readSized_w32 (m : Memory) (a : Word) :
    m.readSized .W32 false a =
      (m.read8 (a + 3) ++ m.read8 (a + 2) ++ m.read8 (a + 1) ++ m.read8 a).zeroExtend 64 := by
  simp [Memory.readSized, Memory.read32]

theorem readSized_w64 (m : Memory) (a : Word) :
    m.readSized .X64 false a =
      m.read8 (a + 7) ++ m.read8 (a + 6) ++ m.read8 (a + 5) ++ m.read8 (a + 4) ++
        m.read8 (a + 3) ++ m.read8 (a + 2) ++ m.read8 (a + 1) ++ m.read8 a := by
  simp [Memory.readSized, Memory.read64]

/-- A signed read is the sign extension of the unsigned read. -/
theorem readSized_signed (m : Memory) (sz : MemWidth) (a : Word) :
    m.readSized sz true a =
      ((m.readSized sz false a).truncate (8 * sz.bytes)).signExtend 64 := by
  cases sz <;> simp only [Memory.readSized, MemWidth.bytes, ↓reduceIte, Bool.false_eq_true]
  · generalize m.read8 a = b; bv_auto
  · generalize m.read16 a = b; bv_auto
  · generalize m.read32 a = b; bv_auto
  · generalize m.read64 a = b; bv_auto

end Lowering.Arm
