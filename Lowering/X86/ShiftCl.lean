/-
  Lowering.X86.ShiftCl

  The shifts whose count is in `cl`, each lowered soundly. The count is known only when the
  instruction runs, and a count of zero leaves every flag alone, so the block computes each
  new flag and selects between it and the old one.
-/

module

public import Lowering.X86.Shift
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env wpOps State ofBool)

variable [Labels] {p : Std.Rco Int64}

/-- The count of a shift by `cl`, as the model masks it. -/
def clK (s : MachineData) (w : Width) : BitVec 8 :=
  (s.regs.get64 .rcx).take 8 &&& (match w with | .W64 => 0x3f#8 | _ => 0x1f#8)

theorem interpMasked_cl (s : MachineData) (w : Width) :
    ShiftCountExpr.cl.interpMasked s p w = (clK s w).toNat := by
  cases w <;> simp [ShiftCountExpr.interpMasked, ShiftCountExpr.interp, clK, Reg64s.get64]

omit [Labels] in
theorem clK_and (s : MachineData) (w : Width) :
    s.regs.get64 .rcx &&& (match w with | .W64 => 0x3f#64 | _ => 0x1f#64) =
      (clK s w).setWidth 64 := by
  have k1 : ∀ x : BitVec 64, x &&& 0x1f#64 = (x.extractLsb' 0 8 &&& 0x1f#8).setWidth 64 := by
    intro x; bv_decide
  have k2 : ∀ x : BitVec 64, x &&& 0x3f#64 = (x.extractLsb' 0 8 &&& 0x3f#8).setWidth 64 := by
    intro x; bv_decide
  cases w <;> first | exact k1 _ | exact k2 _

omit [Labels] in
theorem clK_lt (s : MachineData) (w : Width) : clK s w < 64#8 := by
  have k1 : ∀ x : BitVec 64, x.extractLsb' 0 8 &&& 0x1f#8 < 64#8 := by intro x; bv_decide
  have k2 : ∀ x : BitVec 64, x.extractLsb' 0 8 &&& 0x3f#8 < 64#8 := by intro x; bv_decide
  cases w <;> first | exact k1 _ | exact k2 _

omit [Labels] in
theorem clK_lt32 (s : MachineData) {w : Width} (hw : w ≠ .W64) : clK s w < 32#8 := by
  have k1 : ∀ x : BitVec 64, x.extractLsb' 0 8 &&& 0x1f#8 < 32#8 := by intro x; bv_decide
  cases w <;> first | exact absurd rfl hw | exact k1 _

omit [Labels] in
/-- `1` or `0` from a truth value, in the form the bit-vector solver reads. -/
theorem ofBool_ofBool (b : Bool) : ofBool b = (BitVec.ofBool b).setWidth 64 := by
  cases b <;> rfl

/-- Decide a fact about a shift by `cl`, after evaluating the operations of the block. -/
macro "x86_cl_bv" h:ident : tactic => `(tactic|
  ((try simp only [State.setFlag, StatusFlags.from_result, Env.set_apply, Env.set_same,
      Nat.reduceEqDiff, ↓reduceIte, ($h).df, ($h).cf, ($h).of, BinOp.eval_add, BinOp.eval_sub,
      BinOp.eval_and, BinOp.eval_or, BinOp.eval_xor, BinOp.eval_shl, BinOp.eval_lshr,
      BinOp.eval_ashr, BinOp.eval_eq, BinOp.eval_ne, BinOp.eval_ult, UnOp.eval_zext,
      UnOp.eval_sext, UnOp.eval_popcnt, Braid.ofBool_bne_zero, Braid.ofBool_eq_zero, ne_eq,
      Bool.not_eq_false, signBit_w8, signBit_w16, signBit_w32, signBit_w64, ofBool_ofBool])
    <;> bv_decide))

/-- Finish a shift by a count that is not zero: the new flags are selected, and the result
is written. -/
macro "x86_cl_fin" h:ident hst:ident st:ident hw:ident val:term : tactic => `(tactic|
  (obtain ⟨ρ4, hag4, hpf, hzf, hsf, $hw:ident⟩ :=
     wp_pzsVals (n := 32) (val := $val) (by x86_cl_bv $h) (by decide) $hw
   obtain ⟨ρ5, σ5, hag5, h5, $hw:ident⟩ := wp_selFlags_set $h (st := $st)
     (by rw [hag4 29 (by decide)]; x86_cl_bv $h) (by decide)
     (by rw [hag4 19 (by decide)]; subst $hst; x86_cl_bv $h)
     (by subst $hst; exact hpf)
     (by rw [hag4 24 (by decide)]; simp [Env.set_apply])
     (by subst $hst; exact hzf)
     (by subst $hst; exact hsf)
     (by rw [hag4 27 (by decide)]; subst $hst; x86_cl_bv $h) $hw
   refine writeRM_sound (n := 48) (val := $val) h5
     (by first
       | exact (hag5 10 (by decide)).trans ((hag4 10 (by decide)).trans (by x86_cl_bv $h))
       | exact (hag5 9 (by decide)).trans ((hag4 9 (by decide)).trans (by x86_cl_bv $h)))
     (by decide) $hw fun s' ρ6 σ' _ h' hq => done_sound h' hq))

/-- Finish a shift by a count of zero: the flags are kept, and the destination is written
back. -/
macro "x86_cl_zero" h:ident hw:ident a:ident : tactic => `(tactic|
  (obtain ⟨ρ4, hag4, -, -, -, $hw:ident⟩ :=
     wp_pzsVals (n := 32) (val := $a) (by x86_cl_bv $h) (by decide) $hw
   obtain ⟨ρ5, σ5, hag5, h5, $hw:ident⟩ := wp_selFlags_keep $h
     (by rw [hag4 29 (by decide)]; simp [Env.set_apply]) (by decide) $hw
   refine writeRM_sound (n := 48) (val := $a) h5
     (by first
       | exact (hag5 10 (by decide)).trans ((hag4 10 (by decide)).trans (by x86_cl_bv $h))
       | exact (hag5 9 (by decide)).trans ((hag4 9 (by decide)).trans (by x86_cl_bv $h)))
     (by decide) $hw fun s' ρ6 σ' _ h' hq => done_sound h' hq))

/-- Evaluate the operations of a shift by `cl`, at one width. -/
macro "x86_cl_ops" h:ident a:ident hw:ident ha:ident hkand:ident : tactic => `(tactic|
  (dsimp only [Width.type, Width.bits] at $a:ident $hw:ident $hkand:ident
   simp only [cut, clCount, Braid.wpOps_append] at $hw:ident
   x86_ops at $hw
   simp only [$ha:ident, ($h).regs .rcx, BinOp.eval_and, $hkand:ident] at $hw:ident))

theorem shl_cl_sound {w : Width} (dst : Dst w) :
    OpSound p (.shl dst .cl : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  simp only [cut, Braid.wpOps_append] at hw
  refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
  simp only [interpMasked_cl]
  have hkand := clK_and s w
  have hk64 := clK_lt s w
  have hk32 := clK_lt32 s (w := w)
  generalize clK s w = k at hkand hk64 hk32 ⊢
  by_cases hk : k = 0
  · subst hk
    simp only [show (BitVec.toNat (0 : BitVec 8) == 0) = true from rfl, ↓reduceIte]
    cases w
    all_goals
      x86_cl_ops h a hw ha hkand
      have hw := hw 0#64 0#64 0#64
      x86_cl_zero h hw a
  · have hk0 : (k.toNat == 0) = false := by
      simp only [beq_eq_false_iff_ne, ne_eq]
      exact fun e => hk (BitVec.eq_of_toNat_eq e)
    simp only [hk0, toNat_sub_one hk, Bool.false_eq_true, ↓reduceIte]
    by_cases hlt : k < BitVec.ofNat 8 w.bits <;> by_cases h1 : k = 1
    · have hltn : k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
      simp only [hltn, h1n, ↓reduceIte, Effects.All, ← BitVec.shiftLeft_eq']
      intro af
      cases w
      all_goals
        dsimp only [Width.bits] at hlt
        x86_cl_ops h a hw ha hkand
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.cf) (ofBool st.of) (ofBool st.af)
        x86_cl_fin h hst st hw (a <<< k)
    · have hltn : k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => h1 (BitVec.eq_of_toNat_eq e)
      simp only [hltn, h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, ← BitVec.shiftLeft_eq']
      intro af o
      cases w
      all_goals
        dsimp only [Width.bits] at hlt
        x86_cl_ops h a hw ha hkand
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.cf) (ofBool st.of) (ofBool st.af)
        x86_cl_fin h hst st hw (a <<< k)
    · have hltn : ¬ k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
      simp only [hltn, h1n, ↓reduceIte, Effects.All, ← BitVec.shiftLeft_eq']
      intro af cf
      cases w
      all_goals
        have hk32' := hk32
        dsimp only [Width.bits] at hlt
        first
        | exact absurd hk64 hlt
        | exact absurd (hk32' (by decide)) hlt
        | (x86_cl_ops h a hw ha hkand
           generalize hst : StatusFlags.from_result _ _ = st
           have hw := hw (ofBool st.cf) (ofBool st.of) (ofBool st.af)
           x86_cl_fin h hst st hw (a <<< k))
    · have hltn : ¬ k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => h1 (BitVec.eq_of_toNat_eq e)
      simp only [hltn, h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, ← BitVec.shiftLeft_eq']
      intro af cf o
      cases w
      all_goals
        have hk32' := hk32
        dsimp only [Width.bits] at hlt
        first
        | exact absurd hk64 hlt
        | exact absurd (hk32' (by decide)) hlt
        | (x86_cl_ops h a hw ha hkand
           generalize hst : StatusFlags.from_result _ _ = st
           have hw := hw (ofBool st.cf) (ofBool st.of) (ofBool st.af)
           x86_cl_fin h hst st hw (a <<< k))

theorem shr_cl_sound {w : Width} (dst : Dst w) :
    OpSound p (.shr dst .cl : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  simp only [Braid.wpOps_append] at hw
  refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
  simp only [interpMasked_cl]
  have hkand := clK_and s w
  have hk64 := clK_lt s w
  have hk32 := clK_lt32 s (w := w)
  generalize clK s w = k at hkand hk64 hk32 ⊢
  by_cases hk : k = 0
  · subst hk
    simp only [show (BitVec.toNat (0 : BitVec 8) == 0) = true from rfl, ↓reduceIte]
    cases w
    all_goals
      x86_cl_ops h a hw ha hkand
      have hw := hw 0#64 0#64 0#64
      x86_cl_zero h hw a
  · have hk0 : (k.toNat == 0) = false := by
      simp only [beq_eq_false_iff_ne, ne_eq]
      exact fun e => hk (BitVec.eq_of_toNat_eq e)
    simp only [hk0, toNat_sub_one hk, Bool.false_eq_true, ↓reduceIte]
    by_cases hlt : k < BitVec.ofNat 8 w.bits <;> by_cases h1 : k = 1
    · have hltn : k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
      simp only [hltn, h1n, ↓reduceIte, Effects.All, ushiftRight_toNat, getLsbD_toNat]
      intro af
      cases w
      all_goals
        dsimp only [Width.bits] at hlt
        x86_cl_ops h a hw ha hkand
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.cf) (ofBool st.of) (ofBool st.af)
        x86_cl_fin h hst st hw (a >>> k)
    · have hltn : k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => h1 (BitVec.eq_of_toNat_eq e)
      simp only [hltn, h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, ushiftRight_toNat, getLsbD_toNat]
      intro af o
      cases w
      all_goals
        dsimp only [Width.bits] at hlt
        x86_cl_ops h a hw ha hkand
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.cf) (ofBool st.of) (ofBool st.af)
        x86_cl_fin h hst st hw (a >>> k)
    · have hltn : ¬ k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
      simp only [hltn, h1n, ↓reduceIte, Effects.All, ushiftRight_toNat]
      intro af cf
      cases w
      all_goals
        have hk32' := hk32
        dsimp only [Width.bits] at hlt
        first
        | exact absurd hk64 hlt
        | exact absurd (hk32' (by decide)) hlt
        | (x86_cl_ops h a hw ha hkand
           generalize hst : StatusFlags.from_result _ _ = st
           have hw := hw (ofBool st.cf) (ofBool st.of) (ofBool st.af)
           x86_cl_fin h hst st hw (a >>> k))
    · have hltn : ¬ k.toNat < w.bits := by cases w <;> exact hlt
      have h1n : (k.toNat == 1) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => h1 (BitVec.eq_of_toNat_eq e)
      simp only [hltn, h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, ushiftRight_toNat]
      intro af cf o
      cases w
      all_goals
        have hk32' := hk32
        dsimp only [Width.bits] at hlt
        first
        | exact absurd hk64 hlt
        | exact absurd (hk32' (by decide)) hlt
        | (x86_cl_ops h a hw ha hkand
           generalize hst : StatusFlags.from_result _ _ = st
           have hw := hw (ofBool st.cf) (ofBool st.of) (ofBool st.af)
           x86_cl_fin h hst st hw (a >>> k))

theorem sar_cl_sound {w : Width} (dst : Dst w) :
    OpSound p (.sar dst .cl : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
  obtain ⟨rfl, rfl⟩ := hl
  simp only [Operation.interp]
  simp only [cut, Braid.wpOps_append] at hw
  refine readRM_sound h hw fun a ρ1 _ ha hw => ?_
  simp only [interpMasked_cl]
  have hkand := clK_and s w
  have hk64 := clK_lt s w
  have hk32 := clK_lt32 s (w := w)
  generalize clK s w = k at hkand hk64 hk32 ⊢
  by_cases hk : k = 0
  · subst hk
    simp only [show (BitVec.toNat (0 : BitVec 8) == 0) = true from rfl, ↓reduceIte]
    cases w
    all_goals
      x86_cl_ops h a hw ha hkand
      have hw := hw 0#64 0#64
      x86_cl_zero h hw a
  · have hk0 : (k.toNat == 0) = false := by
      simp only [beq_eq_false_iff_ne, ne_eq]
      exact fun e => hk (BitVec.eq_of_toNat_eq e)
    simp only [hk0, toNat_sub_one hk, Bool.false_eq_true, ↓reduceIte]
    by_cases h1 : k = 1
    · have h1n : (k.toNat == 1) = true := by rw [h1]; rfl
      simp only [h1n, ↓reduceIte, Effects.All, sshiftRight_toNat]
      intro af
      cases w
      all_goals
        x86_cl_ops h a hw ha hkand
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.of) (ofBool st.af)
        x86_cl_fin h hst st hw (a.sshiftRight' k)
    · have h1n : (k.toNat == 1) = false := by
        simp only [beq_eq_false_iff_ne, ne_eq]
        exact fun e => h1 (BitVec.eq_of_toNat_eq e)
      simp only [h1n, Bool.false_eq_true, ↓reduceIte, Effects.All, sshiftRight_toNat]
      intro af o
      cases w
      all_goals
        x86_cl_ops h a hw ha hkand
        generalize hst : StatusFlags.from_result _ _ = st
        have hw := hw (ofBool st.of) (ofBool st.af)
        x86_cl_fin h hst st hw (a.sshiftRight' k)

end Lowering.X86
