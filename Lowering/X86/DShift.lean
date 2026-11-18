/-
  Lowering.X86.DShift

  The double shifts `shld` and `shrd` by an immediate, lowered soundly at 32 and 64 bits: the
  destination is shifted, and the bits that come in are those of a second register.
-/

module

public import Lowering.X86.Shift
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env wpOps State ofBool)

variable [Labels] {p : Std.Rco Int64}

omit [Labels] in
theorem append_eq {n m : Nat} (a : BitVec n) (b : BitVec m) : BitVec.append a b = a ++ b := rfl

/-- Finish a double shift: the result flags, the write, and each flag of the block against the
model's. -/
macro "x86_dshift_fin" h:ident hst:ident st:ident hw:ident val:term : tactic => `(tactic|
  (obtain ⟨ρ4, hag4, $hw:ident⟩ :=
     wp_pzs (n := 32) (val := $val) (by x86_shift_bv $h) (by decide) $hw
   refine writeRM_sound (n := 48) (val := $val)
     (RelD.status $h $st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
     (by first
       | exact (hag4 17 (by decide)).trans (by x86_shift_bv $h)
       | exact (hag4 16 (by decide)).trans (by x86_shift_bv $h))
     (by decide) $hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
   all_goals subst $hst
   all_goals x86_shift_bv $h))

theorem shld_sound {w : Width} (dst : Dst w) (src : Reg w) (c : ConstExpr) :
    OpSound p (.shld dst src (.imm8 c) : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [Operation.interp, interpMasked_imm, Reg.interp]
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
      have hgt : ¬ k.toNat > 32 := Nat.not_lt.2 (Nat.le_of_lt hklt)
      simp only [cut, Braid.wpOps_append] at hw
      refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
      obtain ⟨ρ2, hag2, hb, hw⟩ := readReg_sound h hw
      have ha2 := (hag2 0 (by decide)).trans ha
      generalize s.regs.get src = b at hb ⊢
      dsimp only [Width.type, Width.bits] at a b hw ⊢
      simp only [hk0, hgt, toNat_sub_one hk, Bool.false_eq_true, ↓reduceIte]
      by_cases h1 : k = 1
      · have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
        simp only [h1n, ↓reduceIte, Effects.All, BitVec.drop, append_eq, ← BitVec.shiftLeft_eq']
        intro af
        simp only [h1, ↓reduceIte, afOps] at hw
        x86_ops at hw
        simp only [ha2, hb] at hw
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.af)
        x86_dshift_fin h hst st hw (((a ++ b) <<< k |>.extractLsb' 32 32).setWidth 32)
      · have h1n : (k.toNat == 1) = false := by
          simp only [beq_eq_false_iff_ne, ne_eq]
          exact fun e => h1 (BitVec.eq_of_toNat_eq e)
        simp only [h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, BitVec.drop,
          append_eq, ← BitVec.shiftLeft_eq']
        intro af o
        simp only [h1, ↓reduceIte, afOps] at hw
        x86_ops at hw
        simp only [ha2, hb] at hw
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.of) (ofBool st.af)
        x86_dshift_fin h hst st hw (((a ++ b) <<< k |>.extractLsb' 32 32).setWidth 32)
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
      have hgt : ¬ k.toNat > 64 := Nat.not_lt.2 (Nat.le_of_lt hklt)
      simp only [cut, Braid.wpOps_append] at hw
      refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
      obtain ⟨ρ2, hag2, hb, hw⟩ := readReg_sound h hw
      have ha2 := (hag2 0 (by decide)).trans ha
      generalize s.regs.get src = b at hb ⊢
      dsimp only [Width.type, Width.bits] at a b hw ⊢
      simp only [hk0, hgt, toNat_sub_one hk, Bool.false_eq_true, ↓reduceIte]
      by_cases h1 : k = 1
      · have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
        simp only [h1n, ↓reduceIte, Effects.All, BitVec.drop, append_eq, ← BitVec.shiftLeft_eq']
        intro af
        simp only [h1, ↓reduceIte, afOps] at hw
        x86_ops at hw
        simp only [ha2, hb] at hw
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.af)
        x86_dshift_fin h hst st hw (((a ++ b) <<< k |>.extractLsb' 64 64).setWidth 64)
      · have h1n : (k.toNat == 1) = false := by
          simp only [beq_eq_false_iff_ne, ne_eq]
          exact fun e => h1 (BitVec.eq_of_toNat_eq e)
        simp only [h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, BitVec.drop,
          append_eq, ← BitVec.shiftLeft_eq']
        intro af o
        simp only [h1, ↓reduceIte, afOps] at hw
        x86_ops at hw
        simp only [ha2, hb] at hw
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.of) (ofBool st.af)
        x86_dshift_fin h hst st hw (((a ++ b) <<< k |>.extractLsb' 64 64).setWidth 64)

theorem shrd_sound {w : Width} (dst : Dst w) (src : Reg w) (c : ConstExpr) :
    OpSound p (.shrd dst src (.imm8 c) : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [Operation.interp, interpMasked_imm, Reg.interp]
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
      have hgt : ¬ k.toNat > 32 := Nat.not_lt.2 (Nat.le_of_lt hklt)
      simp only [cut, Braid.wpOps_append] at hw
      refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
      obtain ⟨ρ2, hag2, hb, hw⟩ := readReg_sound h hw
      have ha2 := (hag2 0 (by decide)).trans ha
      generalize s.regs.get src = b at hb ⊢
      dsimp only [Width.type, Width.bits] at a b hw ⊢
      simp only [hk0, hgt, toNat_sub_one hk, Bool.false_eq_true, ↓reduceIte]
      by_cases h1 : k = 1
      · have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
        simp only [h1n, ↓reduceIte, Effects.All, BitVec.take, append_eq, ← BitVec.ushiftRight_eq', getLsbD_toNat]
        intro af
        simp only [h1, ↓reduceIte, afOps] at hw
        x86_ops at hw
        simp only [ha2, hb] at hw
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.af)
        x86_dshift_fin h hst st hw (((b ++ a) >>> k |>.extractLsb' 0 32).setWidth 32)
      · have h1n : (k.toNat == 1) = false := by
          simp only [beq_eq_false_iff_ne, ne_eq]
          exact fun e => h1 (BitVec.eq_of_toNat_eq e)
        simp only [h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, BitVec.take,
          append_eq, ← BitVec.ushiftRight_eq', getLsbD_toNat]
        intro af o
        simp only [h1, ↓reduceIte, afOps] at hw
        x86_ops at hw
        simp only [ha2, hb] at hw
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.of) (ofBool st.af)
        x86_dshift_fin h hst st hw (((b ++ a) >>> k |>.extractLsb' 0 32).setWidth 32)
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
      have hgt : ¬ k.toNat > 64 := Nat.not_lt.2 (Nat.le_of_lt hklt)
      simp only [cut, Braid.wpOps_append] at hw
      refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
      obtain ⟨ρ2, hag2, hb, hw⟩ := readReg_sound h hw
      have ha2 := (hag2 0 (by decide)).trans ha
      generalize s.regs.get src = b at hb ⊢
      dsimp only [Width.type, Width.bits] at a b hw ⊢
      simp only [hk0, hgt, toNat_sub_one hk, Bool.false_eq_true, ↓reduceIte]
      by_cases h1 : k = 1
      · have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
        simp only [h1n, ↓reduceIte, Effects.All, BitVec.take, append_eq, ← BitVec.ushiftRight_eq', getLsbD_toNat]
        intro af
        simp only [h1, ↓reduceIte, afOps] at hw
        x86_ops at hw
        simp only [ha2, hb] at hw
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.af)
        x86_dshift_fin h hst st hw (((b ++ a) >>> k |>.extractLsb' 0 64).setWidth 64)
      · have h1n : (k.toNat == 1) = false := by
          simp only [beq_eq_false_iff_ne, ne_eq]
          exact fun e => h1 (BitVec.eq_of_toNat_eq e)
        simp only [h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, BitVec.take,
          append_eq, ← BitVec.ushiftRight_eq', getLsbD_toNat]
        intro af o
        simp only [h1, ↓reduceIte, afOps] at hw
        x86_ops at hw
        simp only [ha2, hb] at hw
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.of) (ofBool st.af)
        x86_dshift_fin h hst st hw (((b ++ a) >>> k |>.extractLsb' 0 64).setWidth 64)

end Lowering.X86
