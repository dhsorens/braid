/-
  Lowering.X86.Ops

  The instructions that move data and do arithmetic and logic, each lowered soundly.
-/

module

public import Lowering.X86.Rel
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env wpOps State ofBool)

variable [Labels] {p : Std.Rco Int64}

theorem mov_sound {w : Width} (dst : Dst w) (src : Operand w) :
    OpSound p (.mov dst src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Braid.wpOps_append] at hw
  simp only [Operation.interp]
  refine readOp_sound h hw fun v ρ1 _ hv hw => ?_
  refine writeRM_sound h hv (by decide) hw fun s' ρ2 σ' _ h' hq => ?_
  exact done_sound h' hq

theorem movzx_sound {w w' : Width} (dst : Dst w) (src : RegOrMem w') :
    OpSound p (.movzx dst src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp] at hl
  split at hl
  · rename_i hle
    simp only [Option.some.injEq, Prod.mk.injEq] at hl
    obtain ⟨rfl, rfl⟩ := hl
    simp only [Braid.wpOps_append] at hw
    simp only [Operation.interp]
    refine readRM_sound h hw fun v ρ1 _ hv hw => ?_
    refine writeRM_sound (val := v.zeroExtend _) h (hv.trans (setWidth_zext hle v).symm)
      (by decide) hw fun s' ρ2 σ' _ h' hq => ?_
    exact done_sound h' hq
  · cases hl

theorem movsx_sound {w w' : Width} (dst : Dst w) (src : RegOrMem w') :
    OpSound p (.movsx dst src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w <;> cases w'
  all_goals
    simp only [cut, Braid.wpOps_append] at hw
    refine readRM_sound h hw fun v ρ1 _ hv hw => ?_
    dsimp only [Width.type, Width.bits] at v
    x86_ops at hw
    simp only [hv] at hw
    refine writeRM_sound (n := 16) (val := v.signExtend _) h (by simp <;> bv_decide)
      (by decide) hw fun s' ρ2 σ' _ h' hq => ?_
    exact done_sound h' hq

theorem push_sound {w : Width} (src : Operand w) :
    OpSound p (.push src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Braid.wpOps_append] at hw
  simp only [Operation.interp]
  refine readOp_sound h hw fun v ρ1 _ hv hw => ?_
  x86_ops at hw
  rw [h.regs .rsp] at hw
  obtain ⟨m, hs, hq⟩ := hw
  exact store_sound (h.set64_eq .rsp rfl) hv hs fun s' h' => done_sound h' hq

theorem pop_sound {w : Width} (dst : Dst w) :
    OpSound p (.pop dst : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Braid.wpOps_append] at hw
  simp only [Operation.interp]
  x86_ops at hw
  obtain ⟨v, hl, hw⟩ := hw
  rw [h.regs .rsp] at hl hw
  refine load_sound h hl fun e => ?_
  refine writeRM_sound (n := 8) (h.set64_eq .rsp rfl) (by simp [e]) (by decide) hw
    fun s' ρ2 σ' _ h' hq => done_sound h' hq

theorem setcc_sound {w : Width} (cc : CondCode) (dst : Dst w) :
    OpSound p (.setcc cc dst : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Braid.wpOps_append] at hw
  simp only [Operation.interp]
  obtain ⟨ρ1, _, hv, hw⟩ := wp_cc h hw
  exact writeRM_sound h (hv.trans (ofBool_coe w _)) (by decide) hw
    fun s' ρ2 σ' _ h' hq => done_sound h' hq

theorem cmovcc_sound {w : Width} (cc : CondCode) (dst : Reg w) (src : RegOrMem w) :
    OpSound p (.cmovcc cc dst src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Braid.wpOps_append] at hw
  simp only [Operation.interp]
  refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
  obtain ⟨ρ2, hag2, hb, hw⟩ := readReg_sound h hw
  obtain ⟨ρ3, hag3, hc, hw⟩ := wp_cc h hw
  x86_ops at hw
  have ha3 : ρ3 0 = a.setWidth 64 :=
    (hag3 0 (by decide)).trans ((hag2 0 (by decide)).trans ha)
  have hb3 : ρ3 8 = (s.regs.get dst).setWidth 64 := (hag3 8 (by decide)).trans hb
  obtain ⟨ρ5, σ', _, h', hq⟩ := writeReg_sound (n := 32)
    (val := if cc.interp s.status then a else s.regs.get dst) h
    (by simp only [Env.set_same, hc, ha3, hb3]; cases cc.interp s.status <;> simp)
    (by decide) hw
  exact done_sound h' hq

theorem lea_sound {w : Width} (dst : Reg w) (src : AddrExpr) :
    OpSound p (.lea dst src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [cut, Braid.wpOps_append] at hw
    obtain ⟨ρ1, _, hv, hw⟩ := wp_addr h hw
    try x86_ops at hw
    obtain ⟨ρ2, σ', _, h', hq⟩ := writeReg_sound (n := 16)
      (val := (@AddrExpr.interp _ ⟨.W64⟩ src s.regs p).zeroExtend _) h
      (by simp [hv, addrVal]) (by decide) hw
    exact done_sound h' hq

theorem add_sound {w : Width} (dst : Dst w) (src : Operand w) :
    OpSound p (.add dst src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [cut, Braid.wpOps_append] at hw
    refine readOp_sound h hw fun a ρ1 _ ha hw => ?_
    refine readRM_sound h hw fun b ρ2 hag hb hw => ?_
    dsimp only [Width.type, Width.bits] at a b
    have ha' := (hag 0 (by decide)).trans ha
    simp only [afOps] at hw
    x86_ops at hw
    simp only [ha', hb] at hw
    generalize hst : StatusFlags.from_result _ _ = st
    obtain ⟨ρ4, hag4, hw⟩ := wp_pzs (n := 32) (val := a + b) (by simp <;> bv_decide)
      (by decide) (hw (ofBool st.af))
    refine writeRM_sound (n := 48) (val := a + b)
      (RelD.status h st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
      (by first
        | exact (hag4 17 (by decide)).trans (by simp; bv_decide)
        | exact (hag4 16 (by decide)).trans (by simp))
      (by decide) hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
    x86_flags h hst

theorem sub_sound {w : Width} (dst : Dst w) (src : Operand w) :
    OpSound p (.sub dst src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [cut, Braid.wpOps_append] at hw
    refine readOp_sound h hw fun a ρ1 _ ha hw => ?_
    refine readRM_sound h hw fun b ρ2 hag hb hw => ?_
    dsimp only [Width.type, Width.bits] at a b
    have ha' := (hag 0 (by decide)).trans ha
    simp only [afOps] at hw
    x86_ops at hw
    simp only [ha', hb] at hw
    generalize hst : StatusFlags.from_result _ _ = st
    obtain ⟨ρ4, hag4, hw⟩ := wp_pzs (n := 32) (val := b - a) (by simp <;> bv_decide)
      (by decide) (hw (ofBool st.af))
    refine writeRM_sound (n := 48) (val := b - a)
      (RelD.status h st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
      (by first
        | exact (hag4 17 (by decide)).trans (by simp; bv_decide)
        | exact (hag4 16 (by decide)).trans (by simp))
      (by decide) hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
    x86_flags h hst

theorem cmp_sound {w : Width} (x : RegOrMem w) (y : Operand w) :
    OpSound p (.cmp x y : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [cut, Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    refine readOp_sound h hw fun b ρ2 hag hb hw => ?_
    dsimp only [Width.type, Width.bits] at a b
    have ha' := (hag 0 (by decide)).trans ha
    simp only [afOps] at hw
    x86_ops at hw
    simp only [ha', hb] at hw
    generalize hst : StatusFlags.from_result _ _ = st
    obtain ⟨ρ4, hag4, hw⟩ := wp_pzs (n := 32) (val := a - b) (by simp <;> bv_decide)
      (by decide) (hw (ofBool st.af))
    refine done_sound (RelD.status h st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_) hw
    x86_flags h hst

theorem inc_sound {w : Width} (dst : RegOrMem w) :
    OpSound p (.inc dst : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [cut, Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    dsimp only [Width.type, Width.bits] at a
    simp only [afOps] at hw
    x86_ops at hw
    simp only [ha] at hw
    generalize hst : StatusFlags.from_result _ _ = st
    obtain ⟨ρ4, hag4, hw⟩ := wp_pzs (n := 32) (val := a + 1) (by simp <;> bv_decide)
      (by decide) (hw (ofBool st.af))
    refine writeRM_sound (n := 48) (val := a + 1)
      (RelD.status h st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
      (by first
        | exact (hag4 17 (by decide)).trans (by simp; bv_decide)
        | exact (hag4 16 (by decide)).trans (by simp))
      (by decide) hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
    x86_flags h hst

theorem dec_sound {w : Width} (dst : RegOrMem w) :
    OpSound p (.dec dst : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [cut, Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    dsimp only [Width.type, Width.bits] at a
    simp only [afOps] at hw
    x86_ops at hw
    simp only [ha] at hw
    generalize hst : StatusFlags.from_result _ _ = st
    obtain ⟨ρ4, hag4, hw⟩ := wp_pzs (n := 32) (val := a - 1) (by simp <;> bv_decide)
      (by decide) (hw (ofBool st.af))
    refine writeRM_sound (n := 48) (val := a - 1)
      (RelD.status h st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
      (by first
        | exact (hag4 17 (by decide)).trans (by simp; bv_decide)
        | exact (hag4 16 (by decide)).trans (by simp))
      (by decide) hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
    x86_flags h hst

theorem neg_sound {w : Width} (dst : RegOrMem w) :
    OpSound p (.neg dst : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [cut, Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    dsimp only [Width.type, Width.bits] at a
    simp only [afOps] at hw
    x86_ops at hw
    simp only [ha] at hw
    generalize hst : StatusFlags.from_result _ _ = st
    obtain ⟨ρ4, hag4, hw⟩ := wp_pzs (n := 32) (val := -a) (by simp)
      (by decide) (hw (ofBool st.af))
    refine writeRM_sound (n := 48) (val := -a)
      (RelD.status h st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
      (by first
        | exact (hag4 17 (by decide)).trans (by simp <;> bv_decide)
        | exact (hag4 16 (by decide)).trans (by simp))
      (by decide) hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
    x86_flags h hst

theorem not_sound {w : Width} (dst : Dst w) :
    OpSound p (.not dst : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [cut, Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    dsimp only [Width.type, Width.bits] at a
    x86_ops at hw
    simp only [ha] at hw
    exact writeRM_sound (n := 16) (val := ~~~a) h (by simp) (by decide) hw
      fun s' ρ2 σ' _ h' hq => done_sound h' hq

theorem test_sound {w : Width} (x : RegOrMem w) (y : Operand w) :
    OpSound p (.test x y : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    refine readOp_sound h hw fun b ρ2 hag hb hw => ?_
    dsimp only [Width.type, Width.bits] at a b
    have ha' := (hag 0 (by decide)).trans ha
    simp only [afOps, clearCO] at hw
    x86_ops at hw
    simp only [ha', hb] at hw
    simp only [Effects.All]
    intro af
    generalize hst : StatusFlags.from_result _ _ = st
    obtain ⟨ρ4, hag4, hw⟩ := wp_pzs (n := 32) (val := a &&& b) (by simp)
      (by decide) (hw (ofBool st.af))
    refine done_sound (RelD.status h st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_) hw
    x86_flags h hst

theorem and_sound {w : Width} (dst : Dst w) (src : Operand w) :
    OpSound p (.and dst src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    refine readOp_sound h hw fun b ρ2 hag hb hw => ?_
    dsimp only [Width.type, Width.bits] at a b
    have ha' := (hag 0 (by decide)).trans ha
    simp only [afOps, clearCO] at hw
    x86_ops at hw
    simp only [ha', hb] at hw
    simp only [Effects.All]
    intro af
    generalize hst : StatusFlags.from_result _ _ = st
    obtain ⟨ρ4, hag4, hw⟩ := wp_pzs (n := 32) (val := a &&& b) (by simp)
      (by decide) (hw (ofBool st.af))
    refine writeRM_sound (n := 48) (val := a &&& b)
      (RelD.status h st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
      ((hag4 16 (by decide)).trans (by simp))
      (by decide) hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
    x86_flags h hst

theorem or_sound {w : Width} (dst : Dst w) (src : Operand w) :
    OpSound p (.or dst src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    refine readOp_sound h hw fun b ρ2 hag hb hw => ?_
    dsimp only [Width.type, Width.bits] at a b
    have ha' := (hag 0 (by decide)).trans ha
    simp only [afOps, clearCO] at hw
    x86_ops at hw
    simp only [ha', hb] at hw
    simp only [Effects.All]
    intro af
    generalize hst : StatusFlags.from_result _ _ = st
    obtain ⟨ρ4, hag4, hw⟩ := wp_pzs (n := 32) (val := a ||| b) (by simp)
      (by decide) (hw (ofBool st.af))
    refine writeRM_sound (n := 48) (val := a ||| b)
      (RelD.status h st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
      ((hag4 16 (by decide)).trans (by simp))
      (by decide) hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
    x86_flags h hst

theorem xor_sound {w : Width} (dst : Dst w) (src : Operand w) :
    OpSound p (.xor dst src : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w
  all_goals
    simp only [Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    refine readOp_sound h hw fun b ρ2 hag hb hw => ?_
    dsimp only [Width.type, Width.bits] at a b
    have ha' := (hag 0 (by decide)).trans ha
    simp only [afOps, clearCO] at hw
    x86_ops at hw
    simp only [ha', hb] at hw
    simp only [Effects.All]
    intro af
    generalize hst : StatusFlags.from_result _ _ = st
    obtain ⟨ρ4, hag4, hw⟩ := wp_pzs (n := 32) (val := a ^^^ b) (by simp)
      (by decide) (hw (ofBool st.af))
    refine writeRM_sound (n := 48) (val := a ^^^ b)
      (RelD.status h st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
      ((hag4 16 (by decide)).trans (by simp))
      (by decide) hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
    x86_flags h hst

theorem jcc_sound {w : Width} (cc : CondCode) (l : Label) :
    OpSound p (.jcc cc l : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  obtain ⟨ρ1, _, hc, hw⟩ := wp_cc h hw
  simp only [Term.wp, hc] at hw
  cases hcc : cc.interp s.status <;> simp only [hcc] at hw ⊢
  · exact done_sound h (by simpa using hw)
  · exact done_sound h (by simpa using hw)

theorem ret_sound {w : Width} :
    OpSound p (.ret : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  x86_ops at hw
  obtain ⟨v, hl, hq⟩ := hw
  rw [h.regs .rsp] at hl hq
  refine load_sound h hl fun e => ?_
  exact done_sound (h.set64_eq .rsp rfl) (by simpa [Term.wp] using hq)

theorem cld_sound {w : Width} :
    OpSound p (.cld : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  x86_ops at hw
  exact done_sound (h.setDf (by simp)) hw

theorem std_sound {w : Width} :
    OpSound p (.std : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  x86_ops at hw
  exact done_sound (h.setDf (by simp)) hw

theorem nop_sound {w : Width} (n : Nat) : OpSound p (.nop n : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  exact done_sound h hw

theorem nopalign_sound {w : Width} (a : Nat) (pad : Option Nat) :
    OpSound p (.nopalign a pad : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  exact done_sound h hw

end Lowering.X86
