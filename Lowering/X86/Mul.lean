/-
  Lowering.X86.Mul

  The widening multiplications, unsigned and signed, lowered soundly at 32 and 64 bits: the
  product of `rax` and the operand goes to `rdx:rax`. For the unsigned one the carry and
  overflow flags say whether the high half is not zero; for the signed one they are left
  undefined.
-/

module

public import Lowering.X86.Rel
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env wpOps State ofBool)

variable [Labels] {p : Std.Rco Int64}

theorem mul_sound {w : Width} (src : RegOrMem w) : OpSound p (.mul src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  cases w
  case W8 => simp [lowerOp] at hl
  case W16 => simp [lowerOp] at hl
  case W32 =>
    simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
    obtain ⟨rfl, rfl⟩ := hl
    simp only [Operation.interp]
    simp only [Braid.wpOps_append] at hw
    obtain ⟨ρ1, _, ha, hw⟩ := readReg_sound h hw
    refine readRM_sound h hw fun b ρ2 hag hb hw => ?_
    have ha' := (hag 0 (by decide)).trans ha
    generalize s.regs.get (Reg.low Reg64.rax _) = a at ha' ⊢
    dsimp only [Width.type, Width.bits] at a b
    x86_ops at hw
    simp only [ha', hb] at hw
    simp only [Effects.All, show (Width.W32 == Width.W8) = false from rfl, Bool.false_eq_true,
      ↓reduceIte]
    intro sf zf af pf
    have hw := hw (ofBool sf) (ofBool zf) (ofBool af) (ofBool pf)
    obtain ⟨ρ3, σ3, hag3, h3, hw⟩ := writeReg_sound (n := 24) (val := a * b)
      (RelD.status h
        ⟨BitVec.unsigned (a * b) != BitVec.unsigned a * BitVec.unsigned b, pf, af, zf, sf,
          BitVec.unsigned (a * b) != BitVec.unsigned a * BitVec.unsigned b⟩
        (by rfl) (by rfl) (by simp [State.setFlag, h.df])
        (by simp [State.setFlag, umul_ne]; bv_decide) (by simp [State.setFlag])
        (by simp [State.setFlag]) (by simp [State.setFlag]) (by simp [State.setFlag])
        (by simp [State.setFlag, umul_ne]; bv_decide))
      (by simp; bv_decide) (by decide) hw
    obtain ⟨ρ4, σ4, _, h4, hq⟩ := writeReg_sound (n := 32)
      (val := BitVec.ofInt 32 ((BitVec.unsigned a * BitVec.unsigned b) >>> 32)) h3
      ((hag3 17 (by decide)).trans (by simp [mulhi_eq]; bv_decide))
      (by decide) hw
    exact done_sound h4 hq
  case W64 =>
    simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
    obtain ⟨rfl, rfl⟩ := hl
    simp only [Operation.interp]
    simp only [Braid.wpOps_append] at hw
    obtain ⟨ρ1, _, ha, hw⟩ := readReg_sound h hw
    refine readRM_sound h hw fun b ρ2 hag hb hw => ?_
    have ha' := (hag 0 (by decide)).trans ha
    generalize s.regs.get (Reg.low Reg64.rax _) = a at ha' ⊢
    dsimp only [Width.type, Width.bits] at a b
    x86_ops at hw
    simp only [ha', hb] at hw
    simp only [Effects.All, show (Width.W64 == Width.W8) = false from rfl, Bool.false_eq_true,
      ↓reduceIte]
    intro sf zf af pf
    have hw := hw (ofBool sf) (ofBool zf) (ofBool af) (ofBool pf)
    obtain ⟨ρ3, σ3, hag3, h3, hw⟩ := writeReg_sound (n := 24) (val := a * b)
      (RelD.status h
        ⟨BitVec.unsigned (a * b) != BitVec.unsigned a * BitVec.unsigned b, pf, af, zf, sf,
          BitVec.unsigned (a * b) != BitVec.unsigned a * BitVec.unsigned b⟩
        (by rfl) (by rfl) (by simp [State.setFlag, h.df])
        (by simp [State.setFlag, umul_ne]) (by simp [State.setFlag])
        (by simp [State.setFlag]) (by simp [State.setFlag]) (by simp [State.setFlag])
        (by simp [State.setFlag, umul_ne]))
      (by simp) (by decide) hw
    obtain ⟨ρ4, σ4, _, h4, hq⟩ := writeReg_sound (n := 32)
      (val := BitVec.ofInt 64 ((BitVec.unsigned a * BitVec.unsigned b) >>> 64)) h3
      ((hag3 17 (by decide)).trans (by simp [mulhi_eq]))
      (by decide) hw
    exact done_sound h4 hq

omit [Labels] in
/-- The low half of a signed product at double width is the product. -/
theorem mul_lo_sext (a b : BitVec 64) :
    (a.signExtend 128 * b.signExtend 128).extractLsb' 0 64 = a * b := by
  have e : ∀ x : BitVec 128, x.extractLsb' 0 64 = x.setWidth 64 := fun x => by bv_decide
  have e1 : ∀ x : BitVec 64, (x.signExtend 128).setWidth 64 = x := fun x => by bv_decide
  rw [e, BitVec.setWidth_mul _ _ (by decide), e1, e1]

/-- The widening signed multiplication. Its carry and overflow flags are left undefined. -/
theorem imul1_sound {w : Width} (src : RegOrMem w) : OpSound p (.imul1 src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  cases w
  case W8 => simp [lowerOp] at hl
  case W16 => simp [lowerOp] at hl
  case W32 =>
    simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
    obtain ⟨rfl, rfl⟩ := hl
    simp only [Operation.interp]
    simp only [Braid.wpOps_append] at hw
    obtain ⟨ρ1, _, ha, hw⟩ := readReg_sound h hw
    refine readRM_sound h hw fun b ρ2 hag hb hw => ?_
    have ha' := (hag 0 (by decide)).trans ha
    generalize s.regs.get (Reg.low Reg64.rax _) = a at ha' ⊢
    dsimp only [Width.type, Width.bits] at a b
    x86_ops at hw
    simp only [ha', hb] at hw
    simp only [Effects.All, show (Width.W32 == Width.W8) = false from rfl, Bool.false_eq_true,
      ↓reduceIte, ofInt_mul_toInt, BitVec.take, BitVec.drop]
    intro sf zf af pf
    generalize hcf : ((_ : Int) != _) = cf
    have hw := hw (ofBool cf) (ofBool sf) (ofBool zf) (ofBool af) (ofBool pf)
    generalize hP : a.signExtend (32 * 2) * b.signExtend (32 * 2) = P at hw ⊢
    obtain ⟨ρ3, σ3, hag3, h3, hw⟩ := writeReg_sound (n := 24) (val := P.extractLsb' 0 32)
      (RelD.status h ⟨cf, pf, af, zf, sf, cf⟩
        (by rfl) (by rfl) (by simp [State.setFlag, h.df])
        (by simp [State.setFlag]) (by simp [State.setFlag]) (by simp [State.setFlag])
        (by simp [State.setFlag]) (by simp [State.setFlag]) (by simp [State.setFlag]))
      (by subst hP; simp; bv_decide) (by decide) hw
    obtain ⟨ρ4, σ4, _, h4, hq⟩ := writeReg_sound (n := 32)
      (val := (P.extractLsb' 32 (32 * 2 - 32)).setWidth 32) h3
      ((hag3 17 (by decide)).trans (by subst hP; simp; bv_decide)) (by decide) hw
    exact done_sound h4 hq
  case W64 =>
    simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
    obtain ⟨rfl, rfl⟩ := hl
    simp only [Operation.interp]
    simp only [Braid.wpOps_append] at hw
    obtain ⟨ρ1, _, ha, hw⟩ := readReg_sound h hw
    refine readRM_sound h hw fun b ρ2 hag hb hw => ?_
    have ha' := (hag 0 (by decide)).trans ha
    generalize s.regs.get (Reg.low Reg64.rax _) = a at ha' ⊢
    dsimp only [Width.type, Width.bits] at a b
    x86_ops at hw
    simp only [ha', hb] at hw
    simp only [Effects.All, show (Width.W64 == Width.W8) = false from rfl, Bool.false_eq_true,
      ↓reduceIte, ofInt_mul_toInt, BitVec.take, BitVec.drop]
    intro sf zf af pf
    generalize hcf : ((_ : Int) != _) = cf
    have hw := hw (ofBool cf) (ofBool sf) (ofBool zf) (ofBool af) (ofBool pf)
    generalize hP : a.signExtend (64 * 2) * b.signExtend (64 * 2) = P at hw ⊢
    obtain ⟨ρ3, σ3, hag3, h3, hw⟩ := writeReg_sound (n := 24) (val := P.extractLsb' 0 64)
      (RelD.status h ⟨cf, pf, af, zf, sf, cf⟩
        (by rfl) (by rfl) (by simp [State.setFlag, h.df])
        (by simp [State.setFlag]) (by simp [State.setFlag]) (by simp [State.setFlag])
        (by simp [State.setFlag]) (by simp [State.setFlag]) (by simp [State.setFlag]))
      (by subst hP; simp [mul_lo_sext]) (by decide) hw
    obtain ⟨ρ4, σ4, _, h4, hq⟩ := writeReg_sound (n := 32)
      (val := (P.extractLsb' 64 (64 * 2 - 64)).setWidth 64) h3
      ((hag3 17 (by decide)).trans (by subst hP; simp; bv_decide)) (by decide) hw
    exact done_sound h4 hq

end Lowering.X86
