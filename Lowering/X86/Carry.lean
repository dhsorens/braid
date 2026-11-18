/-
  Lowering.X86.Carry

  Addition and subtraction with the carry flag as a third operand, each lowered soundly. The
  carry out is exact, so that a chain of them over the words of a long integer is. The
  overflow flag of the last link is left undefined. Also `bswap`.
-/

module

public import Lowering.X86.Rel
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env wpOps State ofBool)

variable [Labels] {p : Std.Rco Int64}

omit [Labels] in
/-- `1` or `0` from a truth value, in the form the bit-vector solver reads. -/
theorem ofBool_ofNat (b : Bool) : ofBool b = (BitVec.ofBool b).setWidth 64 := by
  cases b <;> rfl

/-- Decide the value of a sum or difference with a carry. -/
macro "x86_carry_bv" : tactic => `(tactic|
  (simp [Env.set_apply, ofBool_ofNat, ofNat_toNat_bool] <;> bv_decide))

theorem adc_sound {w : Width} (dst : Dst w) (src : Operand w) :
    OpSound p (.adc dst src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [cut, Braid.wpOps_append] at hw
    refine readOp_sound h hw fun a ρ1 _ ha hw => ?_
    refine readRM_sound h hw fun b ρ2 hag hb hw => ?_
    dsimp only [Width.type, Width.bits] at a b ⊢
    have ha' := (hag 0 (by decide)).trans ha
    simp only [afOps] at hw
    x86_ops at hw
    simp only [ha', hb, h.cf] at hw
    generalize hst : StatusFlags.from_result _ _ = st
    have hw := hw (ofBool st.of) (ofBool st.af)
    obtain ⟨ρ4, hag4, hw⟩ := wp_pzs (n := 32) (val := a + b + BitVec.ofNat _ s.status.cf.toNat)
      (by x86_carry_bv) (by decide) hw
    refine writeRM_sound (n := 48) (val := a + b + BitVec.ofNat _ s.status.cf.toNat)
      (RelD.status h st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
      (by first
        | exact (hag4 19 (by decide)).trans (by x86_carry_bv)
        | exact (hag4 18 (by decide)).trans (by x86_carry_bv))
      (by decide) hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
    all_goals subst hst
    all_goals try simp only [StatusFlags.from_result, adc_ne8, adc_ne16, adc_ne32, adc_ne64]
    all_goals simp [State.setFlag, h.df, ofBool_ofNat, ofNat_toNat_bool]
    all_goals bv_decide

theorem sbb_sound {w : Width} (dst : Dst w) (src : Operand w) :
    OpSound p (.sbb dst src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [cut, Braid.wpOps_append] at hw
    refine readOp_sound h hw fun a ρ1 _ ha hw => ?_
    refine readRM_sound h hw fun b ρ2 hag hb hw => ?_
    dsimp only [Width.type, Width.bits] at a b ⊢
    have ha' := (hag 0 (by decide)).trans ha
    simp only [afOps] at hw
    x86_ops at hw
    simp only [ha', hb, h.cf] at hw
    generalize hst : StatusFlags.from_result _ _ = st
    have hw := hw (ofBool st.of) (ofBool st.af)
    obtain ⟨ρ4, hag4, hw⟩ := wp_pzs (n := 32) (val := b - a - BitVec.ofNat _ s.status.cf.toNat)
      (by x86_carry_bv) (by decide) hw
    refine writeRM_sound (n := 48) (val := b - a - BitVec.ofNat _ s.status.cf.toNat)
      (RelD.status h st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
      (by first
        | exact (hag4 19 (by decide)).trans (by x86_carry_bv)
        | exact (hag4 18 (by decide)).trans (by x86_carry_bv))
      (by decide) hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
    all_goals subst hst
    all_goals try simp only [StatusFlags.from_result, sbb_ne8, sbb_ne16, sbb_ne32, sbb_ne64]
    all_goals simp [State.setFlag, h.df, ofBool_ofNat, ofNat_toNat_bool]
    all_goals bv_decide

omit [Labels] in
/-- A register is written, and the instruction is done. -/
theorem setReg_done {s : MachineData} {σ : State} {ρ : Env} {Q : State → Prop} {w : Width}
    {r : Reg w} {val : w.type} {n v : Nat} (h : RelD s σ) (hv : ρ v = val.setWidth 64)
    (hvn : v < n)
    (hw : wpOps (writeReg n r v) ρ σ fun ρ σ' => (Term.jump p.upper.toBitVec).wp ρ σ' Q) :
    (Effects.done ⟨s.setReg r val, p.upper⟩).All fun m => ∃ σ', Rel m σ' ∧ Q σ' := by
  obtain ⟨ρ2, σ', _, h', hq⟩ := writeReg_sound h hv hvn hw
  exact done_sound h' hq

/-- `bswap` reverses the bytes of a 64-bit register, or of the low half of one. -/
theorem bswap_sound {w : Width} (dst : Reg w) : OpSound p (.bswap dst : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  cases w
  case W8 => simp [lowerOp] at hl
  case W16 => simp [lowerOp] at hl
  all_goals
    simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
    obtain ⟨rfl, rfl⟩ := hl
    simp only [Operation.interp]
    simp only [Braid.wpOps_append] at hw
    obtain ⟨ρ1, _, ha, hw⟩ := readReg_sound h hw
    x86_ops at hw
    simp only [ha] at hw
    generalize s.regs.get dst = a at hw ⊢
    dsimp only [Width.type, Width.bits] at a
    refine setReg_done (n := 16) h ?_ (by decide) hw
    simp [Braid.bswap, BitVec.take, BitVec.drop] <;> bv_decide

end Lowering.X86
