/-
  Lowering.X86.Shift

  The shifts by an immediate and the two- and three-operand multiplication, each lowered
  soundly.
-/

module

public import Lowering.X86.Rel
import Std.Tactic.BVDecide
import Braid.BV

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env wpOps State ofBool)

variable [Labels] {p : Std.Rco Int64}

theorem imul_sound {w : Width} (dst : Option (Dst w)) (src1 : RegOrMem w) (src2 : Operand w) :
    OpSound p (.imul dst src1 src2 : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  cases w <;> cases dst
  all_goals
    simp only [cut, Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    refine readOp_sound h hw fun b ρ2 hag hb hw => ?_
    dsimp only [Width.type, Width.bits] at a b
    have ha' := (hag 0 (by decide)).trans ha
    x86_ops at hw
    simp only [ha', hb] at hw
    refine writeRM_sound (n := 24) (val := a * b) h (by simp <;> bv_auto) (by decide) hw
      fun s' ρ3 σ' _ h' hq => ?_
    simp only [Effects.All]
    intro sf zf af pf
    refine done_sound (RelD.status h' _ (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
      (hq (ofBool (BitVec.signed (a * b) != BitVec.signed a * BitVec.signed b)) (ofBool sf)
        (ofBool zf) (ofBool af) (ofBool pf))
    all_goals simp [State.setFlag, h'.df]

/-- The count of a shift by an immediate, as the model masks it. -/
theorem interpMasked_imm (c : ConstExpr) (s : MachineData) (w : Width) :
    (ShiftCountExpr.imm8 c).interpMasked s p w = (immCount p w c).toNat := by
  cases w <;> simp [ShiftCountExpr.interpMasked, ShiftCountExpr.interp, immCount]

theorem immCount_lt (c : ConstExpr) (w : Width) : immCount p w c < 64#8 := by
  simp only [immCount]
  generalize (c.interp p).toBitVec.take 8 = x
  cases w <;> bv_auto

theorem immCount_lt32 (c : ConstExpr) {w : Width} (hw : w ≠ .W64) : immCount p w c < 32#8 := by
  simp only [immCount]
  generalize (c.interp p).toBitVec.take 8 = x
  cases w <;> first | exact absurd rfl hw | bv_auto

omit [Labels] in
theorem toNat_sub_one {k : BitVec 8} (hk : k ≠ 0) : k.toNat - 1 = (k - 1).toNat := by
  have : k.toNat ≠ 0 := fun h => hk (BitVec.eq_of_toNat_eq h)
  rw [BitVec.toNat_sub]
  have := k.isLt
  have h1 : (1 : BitVec 8).toNat = 1 := rfl
  rw [h1]
  omega

/-- Decide a fact about a shift, after evaluating the operations of the block. -/
macro "x86_shift_bv" h:ident : tactic => `(tactic|
  ((try simp only [State.setFlag, StatusFlags.from_result, Env.set_apply, Env.set_same,
      Nat.reduceEqDiff, ↓reduceIte, ($h).df, ($h).cf, ($h).of, BinOp.eval_add, BinOp.eval_sub,
      BinOp.eval_and, BinOp.eval_or, BinOp.eval_xor, BinOp.eval_shl, BinOp.eval_lshr,
      BinOp.eval_ashr, BinOp.eval_eq, BinOp.eval_ne, BinOp.eval_ult, UnOp.eval_zext,
      UnOp.eval_sext, UnOp.eval_popcnt, Braid.ofBool_bne_zero, signBit_w8, signBit_w16,
      signBit_w32, signBit_w64]) <;> bv_decide))

/-- Finish a shift: the result flags, the write, and each flag of the block against the
model's. -/
macro "x86_shift_fin" h:ident hst:ident st:ident hw:ident val:term : tactic => `(tactic|
  (obtain ⟨ρ4, hag4, $hw:ident⟩ :=
     wp_pzs (n := 32) (val := $val) (by x86_shift_bv $h) (by decide) $hw
   refine writeRM_sound (n := 48) (val := $val)
     (RelD.status $h $st (by rfl) (by rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_)
     (by first
       | exact (hag4 10 (by decide)).trans (by x86_shift_bv $h)
       | exact (hag4 9 (by decide)).trans (by x86_shift_bv $h))
     (by decide) $hw fun s' ρ5 σ' _ h' hq => done_sound h' hq
   all_goals subst $hst
   all_goals x86_shift_bv $h))

/-- Evaluate the operations of a shift, in one case of its count. -/
macro "x86_shift_ops" a:ident hw:ident hlt:ident h1:ident ha:ident : tactic => `(tactic|
  (dsimp only [Width.type, Width.bits] at $a:ident $hw:ident $hlt:ident
   simp only [$hlt:ident, ↓reduceIte, afOps, cut, Braid.wpOps_append] at $hw:ident
   simp only [$h1:ident, ↓reduceIte] at $hw:ident
   x86_ops at $hw
   simp only [$ha:ident] at $hw:ident))

omit [Labels] in
theorem ushiftRight_toNat {n : Nat} (a : BitVec n) (k : BitVec 8) :
    a.ushiftRight k.toNat = a >>> k := rfl

omit [Labels] in
theorem sshiftRight_toNat {n : Nat} (a : BitVec n) (k : BitVec 8) :
    a.sshiftRight k.toNat = a.sshiftRight' k := rfl

omit [Labels] in
theorem getLsbD_toNat {n : Nat} (a : BitVec n) (k : BitVec 8) :
    a.getLsbD k.toNat = (a >>> k).getLsbD 0 := by
  simp [BitVec.getLsbD_ushiftRight]

/-- The zero count of a shift: the destination is written back, and no flag changes. -/
theorem shift_zero {w : Width} {dst : Dst w} {s : MachineData} {σ : State} {ρ : Env}
    {Q : State → Prop} (h : RelD s σ)
    (hw : wpOps (readRM p 0 dst ++ writeRM p 8 dst 0) ρ σ fun ρ σ' =>
      (Term.jump p.upper.toBitVec).wp ρ σ' Q) :
    (@RegOrMem.interp w _ ⟨.W64⟩ dst s p fun a s =>
      @MachineData.set w _ ⟨.W64⟩ s dst a p fun s' => .done ⟨s', p.upper⟩).All
      fun m => ∃ σ', Rel m σ' ∧ Q σ' := by
  simp only [Braid.wpOps_append] at hw
  refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
  exact writeRM_sound h ha (by decide) hw fun s' ρ2 σ' _ h' hq => done_sound h' hq

theorem shl_sound {w : Width} (dst : Dst w) (c : ConstExpr) :
    OpSound p (.shl dst (.imm8 c) : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [Operation.interp, interpMasked_imm]
  simp only [lowerOp] at hl
  have hk64 := immCount_lt (p := p) c w
  generalize immCount p w c = k at hl hk64 ⊢
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
    simp only [hk0, toNat_sub_one hk, Bool.false_eq_true, ↓reduceIte]
    simp only [cut, Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    by_cases hlt : k < BitVec.ofNat 8 w.bits <;> by_cases h1 : k = 1
    · have hltn : k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
      simp only [hltn, h1n, ↓reduceIte, Effects.All, ← BitVec.shiftLeft_eq']
      intro af
      cases w
      all_goals
        x86_shift_ops a hw hlt h1 ha
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.af)
        x86_shift_fin h hst st hw (a <<< k)
    · have hltn : k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => h1 (BitVec.eq_of_toNat_eq e)
      simp only [hltn, h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, ← BitVec.shiftLeft_eq']
      intro af o
      cases w
      all_goals
        x86_shift_ops a hw hlt h1 ha
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.of) (ofBool st.af)
        x86_shift_fin h hst st hw (a <<< k)
    · have hltn : ¬ k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
      simp only [hltn, h1n, ↓reduceIte, Effects.All, ← BitVec.shiftLeft_eq']
      intro af cf
      cases w
      all_goals first
        | exact absurd hk64 hlt
        | (x86_shift_ops a hw hlt h1 ha
           generalize hst : StatusFlags.from_result _ _ = st
           have hw := hw (ofBool st.cf) (ofBool st.af)
           x86_shift_fin h hst st hw (a <<< k))
    · have hltn : ¬ k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => h1 (BitVec.eq_of_toNat_eq e)
      simp only [hltn, h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, ← BitVec.shiftLeft_eq']
      intro af cf o
      cases w
      all_goals first
        | exact absurd hk64 hlt
        | (x86_shift_ops a hw hlt h1 ha
           generalize hst : StatusFlags.from_result _ _ = st
           have hw := hw (ofBool st.cf) (ofBool st.of) (ofBool st.af)
           x86_shift_fin h hst st hw (a <<< k))

theorem shr_sound {w : Width} (dst : Dst w) (c : ConstExpr) :
    OpSound p (.shr dst (.imm8 c) : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [Operation.interp, interpMasked_imm]
  simp only [lowerOp] at hl
  have hk64 := immCount_lt (p := p) c w
  generalize immCount p w c = k at hl hk64 ⊢
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
    simp only [hk0, toNat_sub_one hk, Bool.false_eq_true, ↓reduceIte]
    simp only [Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    by_cases hlt : k < BitVec.ofNat 8 w.bits <;> by_cases h1 : k = 1
    · have hltn : k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
      simp only [hltn, h1n, ↓reduceIte, Effects.All, ushiftRight_toNat, getLsbD_toNat]
      intro af
      cases w
      all_goals
        x86_shift_ops a hw hlt h1 ha
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.af)
        x86_shift_fin h hst st hw (a >>> k)
    · have hltn : k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => h1 (BitVec.eq_of_toNat_eq e)
      simp only [hltn, h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, ushiftRight_toNat,
        getLsbD_toNat]
      intro af o
      cases w
      all_goals
        x86_shift_ops a hw hlt h1 ha
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.of) (ofBool st.af)
        x86_shift_fin h hst st hw (a >>> k)
    · have hltn : ¬ k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
      simp only [hltn, h1n, ↓reduceIte, Effects.All, ushiftRight_toNat]
      intro af cf
      cases w
      all_goals first
        | exact absurd hk64 hlt
        | (x86_shift_ops a hw hlt h1 ha
           generalize hst : StatusFlags.from_result _ _ = st
           have hw := hw (ofBool st.cf) (ofBool st.af)
           x86_shift_fin h hst st hw (a >>> k))
    · have hltn : ¬ k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => h1 (BitVec.eq_of_toNat_eq e)
      simp only [hltn, h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, ushiftRight_toNat]
      intro af cf o
      cases w
      all_goals first
        | exact absurd hk64 hlt
        | (x86_shift_ops a hw hlt h1 ha
           generalize hst : StatusFlags.from_result _ _ = st
           have hw := hw (ofBool st.cf) (ofBool st.of) (ofBool st.af)
           x86_shift_fin h hst st hw (a >>> k))

theorem sar_sound {w : Width} (dst : Dst w) (c : ConstExpr) :
    OpSound p (.sar dst (.imm8 c) : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [Operation.interp, interpMasked_imm]
  simp only [lowerOp] at hl
  generalize immCount p w c = k at hl ⊢
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
    simp only [hk0, toNat_sub_one hk, Bool.false_eq_true, ↓reduceIte]
    simp only [cut, Braid.wpOps_append] at hw
    refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
    by_cases h1 : k = 1
    · have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
      simp only [h1n, ↓reduceIte, Effects.All, sshiftRight_toNat]
      intro af
      cases w
      all_goals
        dsimp only [Width.type, Width.bits] at a hw
        simp only [h1, ↓reduceIte, afOps] at hw
        x86_ops at hw
        simp only [ha] at hw
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.af)
        x86_shift_fin h hst st hw (a.sshiftRight' k)
    · have h1n : (k.toNat == 1) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => h1 (BitVec.eq_of_toNat_eq e)
      simp only [h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, sshiftRight_toNat]
      intro af o
      cases w
      all_goals
        dsimp only [Width.type, Width.bits] at a hw
        simp only [h1, ↓reduceIte, afOps] at hw
        x86_ops at hw
        simp only [ha] at hw
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.of) (ofBool st.af)
        x86_shift_fin h hst st hw (a.sshiftRight' k)

end Lowering.X86
