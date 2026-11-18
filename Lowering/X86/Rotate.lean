/-
  Lowering.X86.Rotate

  The rotations `rol` and `ror` by an immediate, lowered soundly at 32 and 64 bits. A rotation
  is two shifts and an `or`; it changes the carry and overflow flags only.
-/

module

public import Lowering.X86.Shift
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env wpOps State ofBool)

variable [Labels] {p : Std.Rco Int64}

omit [Labels] in
theorem rotl32 (a : BitVec 32) (k : BitVec 8) (hk : k < 32#8) :
    a.rotateLeft k.toNat = a <<< k ||| a >>> (32#8 - k) := by
  have hlt : k.toNat < 32 := hk
  have e : (32#8 - k).toNat = 32 - k.toNat := by
    rw [BitVec.toNat_sub]; simp; omega
  rw [BitVec.rotateLeft_eq_rotateLeftAux_of_lt hlt, BitVec.rotateLeftAux, BitVec.shiftLeft_eq',
    BitVec.ushiftRight_eq', e]

omit [Labels] in
theorem rotr32 (a : BitVec 32) (k : BitVec 8) (hk : k < 32#8) :
    a.rotateRight k.toNat = a >>> k ||| a <<< (32#8 - k) := by
  have hlt : k.toNat < 32 := hk
  have e : (32#8 - k).toNat = 32 - k.toNat := by
    rw [BitVec.toNat_sub]; simp; omega
  rw [BitVec.rotateRight_eq_rotateRightAux_of_lt hlt, BitVec.rotateRightAux,
    BitVec.shiftLeft_eq', BitVec.ushiftRight_eq', e]

omit [Labels] in
theorem rotl64 (a : BitVec 64) (k : BitVec 8) (hk : k < 64#8) :
    a.rotateLeft k.toNat = a <<< k ||| a >>> (64#8 - k) := by
  have hlt : k.toNat < 64 := hk
  have e : (64#8 - k).toNat = 64 - k.toNat := by
    rw [BitVec.toNat_sub]; simp; omega
  rw [BitVec.rotateLeft_eq_rotateLeftAux_of_lt hlt, BitVec.rotateLeftAux, BitVec.shiftLeft_eq',
    BitVec.ushiftRight_eq', e]

omit [Labels] in
theorem rotr64 (a : BitVec 64) (k : BitVec 8) (hk : k < 64#8) :
    a.rotateRight k.toNat = a >>> k ||| a <<< (64#8 - k) := by
  have hlt : k.toNat < 64 := hk
  have e : (64#8 - k).toNat = 64 - k.toNat := by
    rw [BitVec.toNat_sub]; simp; omega
  rw [BitVec.rotateRight_eq_rotateRightAux_of_lt hlt, BitVec.rotateRightAux,
    BitVec.shiftLeft_eq', BitVec.ushiftRight_eq', e]

/-- Finish a rotation: the two flags it sets, and the write. -/
macro "x86_rot_fin" h:ident hw:ident val:term : tactic => `(tactic|
  (refine writeRM_sound (n := 48) (val := $val)
     (RelD.status $h _ (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
     (by x86_shift_bv $h)
     (by decide) $hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
   all_goals
     (try simp only [State.setFlag, Nat.reduceEqDiff, ↓reduceIte, ($h).df, ($h).pf, ($h).af,
        ($h).zf, ($h).sf, Env.set_apply, Env.set_same, BinOp.eval_and, BinOp.eval_or,
        BinOp.eval_xor, BinOp.eval_shl, BinOp.eval_lshr, UnOp.eval_zext,
        Braid.ofBool_bne_zero, signBit_w32, signBit_w64]) <;> bv_decide))

theorem rol_sound {w : Width} (dst : Dst w) (c : ConstExpr) :
    OpSound p (.rol dst (.imm8 c) : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [Operation.interp, interpMasked_imm]
  cases w
  case W8 => simp [lowerOp] at hl
  case W16 => simp [lowerOp] at hl
  case W32 =>
    simp only [lowerOp] at hl
    have hklt : immCount p Width.W32 c < 32#8 := immCount_lt32 c (by decide)
    generalize immCount p Width.W32 c = k at hl hklt ⊢
    split at hl
    · rename_i hk
      subst hk
      simp only [Option.some.injEq, Prod.mk.injEq] at hl
      obtain ⟨rfl, rfl⟩ := hl
      simp only [show (BitVec.toNat (0 : BitVec 8) == 0) = true from rfl, ↓reduceIte]
      exact shift_zero h hw
    · rename_i hk
      simp only [Option.some.injEq, Prod.mk.injEq] at hl
      obtain ⟨rfl, rfl⟩ := hl
      have hk0 : (k.toNat == 0) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => hk (BitVec.eq_of_toNat_eq e)
      simp only [cut, Braid.wpOps_append] at hw
      refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
      dsimp only [Width.type, Width.bits] at a hw ⊢
      simp only [hk0, Bool.false_eq_true, ↓reduceIte, rotl32 a k hklt]
      by_cases h1 : k = 1
      · have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
        simp only [h1n, ↓reduceIte]
        simp only [h1, ↓reduceIte] at hw
        x86_ops at hw
        simp only [ha] at hw
        x86_rot_fin h hw (a <<< k ||| a >>> (32#8 - k))
      · have h1n : (k.toNat == 1) = false := by
          simp only [beq_eq_false_iff_ne, ne_eq]
          exact fun e => h1 (BitVec.eq_of_toNat_eq e)
        simp only [h1n, Bool.false_eq_true, ↓reduceIte, Effects.All]
        intro o
        simp only [h1, ↓reduceIte] at hw
        x86_ops at hw
        simp only [ha] at hw
        have hw := hw (ofBool o)
        x86_rot_fin h hw (a <<< k ||| a >>> (32#8 - k))
  case W64 =>
    simp only [lowerOp] at hl
    have hklt : immCount p Width.W64 c < 64#8 := immCount_lt c _
    generalize immCount p Width.W64 c = k at hl hklt ⊢
    split at hl
    · rename_i hk
      subst hk
      simp only [Option.some.injEq, Prod.mk.injEq] at hl
      obtain ⟨rfl, rfl⟩ := hl
      simp only [show (BitVec.toNat (0 : BitVec 8) == 0) = true from rfl, ↓reduceIte]
      exact shift_zero h hw
    · rename_i hk
      simp only [Option.some.injEq, Prod.mk.injEq] at hl
      obtain ⟨rfl, rfl⟩ := hl
      have hk0 : (k.toNat == 0) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => hk (BitVec.eq_of_toNat_eq e)
      simp only [cut, Braid.wpOps_append] at hw
      refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
      dsimp only [Width.type, Width.bits] at a hw ⊢
      simp only [hk0, Bool.false_eq_true, ↓reduceIte, rotl64 a k hklt]
      by_cases h1 : k = 1
      · have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
        simp only [h1n, ↓reduceIte]
        simp only [h1, ↓reduceIte] at hw
        x86_ops at hw
        simp only [ha] at hw
        x86_rot_fin h hw (a <<< k ||| a >>> (64#8 - k))
      · have h1n : (k.toNat == 1) = false := by
          simp only [beq_eq_false_iff_ne, ne_eq]
          exact fun e => h1 (BitVec.eq_of_toNat_eq e)
        simp only [h1n, Bool.false_eq_true, ↓reduceIte, Effects.All]
        intro o
        simp only [h1, ↓reduceIte] at hw
        x86_ops at hw
        simp only [ha] at hw
        have hw := hw (ofBool o)
        x86_rot_fin h hw (a <<< k ||| a >>> (64#8 - k))

theorem ror_sound {w : Width} (dst : Dst w) (c : ConstExpr) :
    OpSound p (.ror dst (.imm8 c) : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [Operation.interp, interpMasked_imm]
  cases w
  case W8 => simp [lowerOp] at hl
  case W16 => simp [lowerOp] at hl
  case W32 =>
    simp only [lowerOp] at hl
    have hklt : immCount p Width.W32 c < 32#8 := immCount_lt32 c (by decide)
    generalize immCount p Width.W32 c = k at hl hklt ⊢
    split at hl
    · rename_i hk
      subst hk
      simp only [Option.some.injEq, Prod.mk.injEq] at hl
      obtain ⟨rfl, rfl⟩ := hl
      simp only [show (BitVec.toNat (0 : BitVec 8) == 0) = true from rfl, ↓reduceIte]
      exact shift_zero h hw
    · rename_i hk
      simp only [Option.some.injEq, Prod.mk.injEq] at hl
      obtain ⟨rfl, rfl⟩ := hl
      have hk0 : (k.toNat == 0) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => hk (BitVec.eq_of_toNat_eq e)
      simp only [cut, Braid.wpOps_append] at hw
      refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
      dsimp only [Width.type, Width.bits] at a hw ⊢
      simp only [hk0, Bool.false_eq_true, ↓reduceIte, rotr32 a k hklt]
      by_cases h1 : k = 1
      · have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
        simp only [h1n, ↓reduceIte]
        simp only [h1, ↓reduceIte] at hw
        x86_ops at hw
        simp only [ha] at hw
        x86_rot_fin h hw (a >>> k ||| a <<< (32#8 - k))
      · have h1n : (k.toNat == 1) = false := by
          simp only [beq_eq_false_iff_ne, ne_eq]
          exact fun e => h1 (BitVec.eq_of_toNat_eq e)
        simp only [h1n, Bool.false_eq_true, ↓reduceIte, Effects.All]
        intro o
        simp only [h1, ↓reduceIte] at hw
        x86_ops at hw
        simp only [ha] at hw
        have hw := hw (ofBool o)
        x86_rot_fin h hw (a >>> k ||| a <<< (32#8 - k))
  case W64 =>
    simp only [lowerOp] at hl
    have hklt : immCount p Width.W64 c < 64#8 := immCount_lt c _
    generalize immCount p Width.W64 c = k at hl hklt ⊢
    split at hl
    · rename_i hk
      subst hk
      simp only [Option.some.injEq, Prod.mk.injEq] at hl
      obtain ⟨rfl, rfl⟩ := hl
      simp only [show (BitVec.toNat (0 : BitVec 8) == 0) = true from rfl, ↓reduceIte]
      exact shift_zero h hw
    · rename_i hk
      simp only [Option.some.injEq, Prod.mk.injEq] at hl
      obtain ⟨rfl, rfl⟩ := hl
      have hk0 : (k.toNat == 0) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => hk (BitVec.eq_of_toNat_eq e)
      simp only [cut, Braid.wpOps_append] at hw
      refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
      dsimp only [Width.type, Width.bits] at a hw ⊢
      simp only [hk0, Bool.false_eq_true, ↓reduceIte, rotr64 a k hklt]
      by_cases h1 : k = 1
      · have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
        simp only [h1n, ↓reduceIte]
        simp only [h1, ↓reduceIte] at hw
        x86_ops at hw
        simp only [ha] at hw
        x86_rot_fin h hw (a >>> k ||| a <<< (64#8 - k))
      · have h1n : (k.toNat == 1) = false := by
          simp only [beq_eq_false_iff_ne, ne_eq]
          exact fun e => h1 (BitVec.eq_of_toNat_eq e)
        simp only [h1n, Bool.false_eq_true, ↓reduceIte, Effects.All]
        intro o
        simp only [h1, ↓reduceIte] at hw
        x86_ops at hw
        simp only [ha] at hw
        have hw := hw (ofBool o)
        x86_rot_fin h hw (a >>> k ||| a <<< (64#8 - k))

end Lowering.X86
