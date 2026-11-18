/-
  Lowering.X86.Mul

  The widening unsigned multiplication, lowered soundly at 32 and 64 bits: the product of
  `rax` and the operand goes to `rdx:rax`, and the carry and overflow flags say whether the
  high half is not zero.
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

end Lowering.X86
