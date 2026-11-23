/-
  Examples.Limbs.Arm.Proofs

  `limbs.c` on AArch64: multi-limb addition with carry, the second rung of the scaling
  ladder (`docs/Scaling.md`). The loop walks three arrays with post-indexed loads and
  stores, and keeps the carry in a register between rounds, computed from the carry flag
  of each of the two additions.

  The loop is proved by induction on the limbs still to add, with the stepper: one round is
  run symbolically, the carry it leaves is shown to be `carryOut` (`carry_eq`, by
  `bv_auto`), and the induction hypothesis is the rest of the loop. That `addLimbs` adds
  the numbers is `addLimbs_val`, a theorem about lists.

  ## Main results

  * `add_limbs_spec`: the specification, with `addLimbs`
  * `add_limbs_correct`: on the machine, the limbs written and the carry returned are the sum
    of the two numbers
-/

module

public import Examples.Limbs.Arm.Image
public import Examples.Limbs.Common
public import Examples.ArmMachine
import Braid.BV

public section

namespace Examples.Limbs.Arm

open Braid Examples Examples.Limbs Lowering.Arm Lowering.Arm.Regs

/-- The carry the code computes in a round, from the carry flags of its two additions, is
`carryOut`. -/
theorem carry_eq (a b c : Word) :
    (if ¬(a + (c + b)).ult (a + c) = true then
      BitVec.setWidth 64 (BitVec.setWidth 32 (if ¬BitVec.ult (a + c) a = true then 0#64 else 1#64))
    else 1#64) = carryOut a b c := by
  unfold carryOut
  bv_auto

/-- The loop of `add_limbs`: add the limbs `a :: as` and `b :: bs` and the carry `c`, and
store the sum over `r0 :: rs`. -/
theorem add_limbs_loop (lrv : Word) : ∀ (as bs rs : List Word) (a b r0 : Word)
    (pr pa pb n c t9 t10 : Word) (fn fz fc fv : Bool), bs.length = as.length →
    rs.length = as.length →
    n = BitVec.ofNat 64 (as.length + 1) → as.length + 1 < 2 ^ 64 →
    Triple add_limbs.program
      (Atoms.interp [.pc 0x10008#64, .reg x0 pr, .reg x1 pa, .reg x2 pb, .reg x3 n,
        .reg x8 c, .reg x9 t9, .reg x10 t10, .reg lr lrv,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (wordsAt pa (a :: as)), .prop (wordsAt pb (b :: bs)),
        .prop (wordsAt pr (r0 :: rs))])
      (Atoms.interp [.pc lrv, .reg x0 (addLimbs (a :: as) (b :: bs) c).2,
        .prop (regAny x1), .prop (regAny x2), .reg x3 0#64,
        .prop (regAny x8), .prop (regAny x9), .prop (regAny x10), .reg lr lrv,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v),
        .prop (wordsAt pa (a :: as)), .prop (wordsAt pb (b :: bs)),
        .prop (wordsAt pr (addLimbs (a :: as) (b :: bs) c).1)]) := by
  intro as
  induction as with
  | nil =>
    intro bs rs a b r0 pr pa pb n c t9 t10 fn fz fc fv hlb hlr he hb
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlb
    have hrs : rs = [] := List.length_eq_zero_iff.1 hlr
    have he' : n = 1#64 := by simpa using he
    subst hbs hrs he'
    braid_unfold wordsAt_cons pa a []
    braid_unfold wordsAt_cons pb b []
    braid_unfold wordsAt_cons pr r0 []
    braid_sym_run
    rw [carry_eq a b c]
    braid_fold wordsAt_cons pa a []
    braid_fold wordsAt_cons pb b []
    braid_fold wordsAt_cons pr (a + (c + b)) []
    braid_forget 1
    braid_forget 2
    braid_forget 8
    braid_forget 9
    braid_forget 10
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    simp only [addLimbs_cons, addLimbs_nil]
    braid_done
  | cons a' as ih =>
    intro bs rs a b r0 pr pa pb n c t9 t10 fn fz fc fv hlb hlr he hb
    obtain ⟨b', bs', rfl⟩ : ∃ b' bs', bs = b' :: bs' := by
      cases bs with
      | nil => simp at hlb
      | cons x y => exact ⟨x, y, rfl⟩
    obtain ⟨r', rs', rfl⟩ : ∃ r' rs', rs = r' :: rs' := by
      cases rs with
      | nil => simp at hlr
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at he hb hlb hlr
    braid_unfold wordsAt_cons pa a (a' :: as)
    braid_unfold wordsAt_cons pb b (b' :: bs')
    braid_unfold wordsAt_cons pr r0 (r' :: rs')
    braid_sym_run
    · rw [carry_eq a b c]
      braid_call ih bs' rs' a' b' r' (pr + 8#64) (pa + 8#64) (pb + 8#64)
        (n + 0xffffffffffffffff#64) (carryOut a b c) _ _ _ _ _ _
        (by omega) (by omega) (by rw [he]; bv_omega) (by omega)
      braid_fold wordsAt_cons pa a (a' :: as)
      braid_fold wordsAt_cons pb b (b' :: bs')
      braid_fold wordsAt_cons pr (a + (c + b))
        (addLimbs (a' :: as) (b' :: bs') (carryOut a b c)).1
      rw [addLimbs_cons a b c]
      braid_done
    · exfalso
      have : n ≠ 1#64 := by rw [he]; bv_omega
      exact this hbr

/-- `add_limbs` adds the `n` limbs its second and third arguments point to, stores the
limbs of the sum where its first argument points, and returns the carry out. The three
arrays are separate. -/
theorem add_limbs_spec (pr pa pb lrv t8 t9 t10 : Word) (as bs rs : List Word)
    (fn fz fc fv : Bool) (hlb : bs.length = as.length) (hlr : rs.length = as.length)
    (hl : as.length < 2 ^ 64) :
    Triple add_limbs.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 pr, .reg x1 pa, .reg x2 pb,
        .reg x3 (BitVec.ofNat 64 as.length), .reg x8 t8, .reg x9 t9, .reg x10 t10,
        .reg lr lrv,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (wordsAt pa as), .prop (wordsAt pb bs), .prop (wordsAt pr rs)])
      (Atoms.interp [.pc lrv, .reg x0 (addLimbs as bs 0#64).2,
        .prop (regAny x1), .prop (regAny x2), .reg x3 0#64,
        .prop (regAny x8), .prop (regAny x9), .prop (regAny x10), .reg lr lrv,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v),
        .prop (wordsAt pa as), .prop (wordsAt pb bs),
        .prop (wordsAt pr (addLimbs as bs 0#64).1)]) := by
  cases as with
  | nil =>
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlb
    have hrs : rs = [] := List.length_eq_zero_iff.1 hlr
    subst hbs hrs
    simp only [List.length_nil, addLimbs_nil]
    braid_sym_run
    braid_forget 1
    braid_forget 2
    braid_forget 8
    braid_forget 9
    braid_forget 10
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    braid_done
  | cons a as =>
    obtain ⟨b, bs', rfl⟩ : ∃ b bs', bs = b :: bs' := by
      cases bs with
      | nil => simp at hlb
      | cons x y => exact ⟨x, y, rfl⟩
    obtain ⟨r0, rs', rfl⟩ : ∃ r0 rs', rs = r0 :: rs' := by
      cases rs with
      | nil => simp at hlr
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at hl hlb hlr ⊢
    braid_sym_step
    braid_sym_step
    · braid_call add_limbs_loop lrv as bs' rs' a b r0 pr pa pb _ 0#64 t9 t10 fn fz fc fv
        (by omega) (by omega) rfl hl
      braid_done
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr

/-! ## On the machine -/

/-- **`add_limbs` on the machine.** A running machine whose program holds the words of
`add_limbs`, with its code loaded and its program counter at the entry, with the number of
limbs `n` in `x3`, and with `n` limbs in memory at each of `x1` (the limbs `as`), `x2` (the
limbs `bs`) and `x0` (any limbs `rs`), the three arrays pairwise apart, runs to the address
in the link register. Then the limbs `as` and `bs` are where they were, and where `x0`
pointed there are `n` limbs `sum` which, with the carry returned in `x0` above them, are
the sum of the two numbers.

The destination may not overlap a source, nor one source the other: the three arrays are
three separate pieces of memory in the specification. (The code would also be right with
the destination equal to a source; that is another specification, with two arrays.) -/
theorem add_limbs_correct (prog : Arm64.Program) (s : Arm64.State) (as bs rs : List Word)
    (hw : prog.hasWords 0x10000#64 add_limbs_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64)
    (hlb : bs.length = as.length) (hlr : rs.length = as.length)
    (hn : s.regs.read 3#5 = BitVec.ofNat 64 as.length)
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes s (s.regs.read 1#5 + BitVec.ofNat 64 (8 * i)) 8 as[i])
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.regs.read 2#5 + BitVec.ofNat 64 (8 * i)) 8 bs[i])
    (hr : ∀ (i : Nat) (hi : i < rs.length),
      HasBytes s (s.regs.read 0#5 + BitVec.ofNat 64 (8 * i)) 8 rs[i])
    (hab : Apart (s.regs.read 1#5) (8 * as.length) (s.regs.read 2#5) (8 * as.length))
    (har : Apart (s.regs.read 1#5) (8 * as.length) (s.regs.read 0#5) (8 * as.length))
    (hbr : Apart (s.regs.read 2#5) (8 * as.length) (s.regs.read 0#5) (8 * as.length)) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      (∀ (i : Nat) (hi : i < as.length),
        HasBytes s' (s.regs.read 1#5 + BitVec.ofNat 64 (8 * i)) 8 as[i]) ∧
      (∀ (i : Nat) (hi : i < bs.length),
        HasBytes s' (s.regs.read 2#5 + BitVec.ofNat 64 (8 * i)) 8 bs[i]) ∧
      ∃ sum : List Word, sum.length = as.length ∧
        (∀ (i : Nat) (hi : i < sum.length),
          HasBytes s' (s.regs.read 0#5 + BitVec.ofNat 64 (8 * i)) 8 sum[i]) ∧
        limbsVal sum + 2 ^ (64 * as.length) * (s'.regs.read 0#5).toNat =
          limbsVal as + limbsVal bs := by
  have h8 : 8 * as.length < 2 ^ 64 := by
    have := (s.regs.read 2#5 - s.regs.read 1#5).isLt
    have := hab.1
    omega
  have hl : as.length < 2 ^ 64 := by omega
  obtain ⟨s', σ', hsteps, hrel, hq⟩ := machine_sound_flat add_limbs_lowered
    (add_limbs_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 2#5) (s.regs.read 30#5)
      (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5) as bs rs s.pstate.n s.pstate.z
      s.pstate.c s.pstate.v hlb hlr hl) hw hc hrun
    (interp_arrays [.pc 0x10000#64, .reg x0 (s.regs.read 0#5), .reg x1 (s.regs.read 1#5),
      .reg x2 (s.regs.read 2#5), .reg x3 (BitVec.ofNat 64 as.length),
      .reg x8 (s.regs.read 8#5), .reg x9 (s.regs.read 9#5), .reg x10 (s.regs.read 10#5),
      .reg lr (s.regs.read 30#5), .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z,
      .flag Flags.c s.pstate.c, .flag Flags.v s.pstate.v] _ _ _ _ _ _)
    (forall_arrays (by simp [Atom.IsPointsTo]) wordsAtoms_isPointsTo wordsAtoms_isPointsTo
      wordsAtoms_isPointsTo)
    (pairwise_arrays (by braid_disj) (wordsAtoms_pairwise (by omega))
      (wordsAtoms_pairwise (by omega)) (wordsAtoms_pairwise (by omega))
      (by braid_disj_array) (by braid_disj_array) (by braid_disj_array)
      (wordsAtoms_disj (by have := hab.1; omega) (by have := hab.2; omega))
      (wordsAtoms_disj (by have := har.1; omega) (by have := har.2; omega))
      (wordsAtoms_disj (by have := hbr.1; omega) (by have := hbr.2; omega)))
    (forall_arrays
      (by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
        Flags.v, hpc, hn])
      (wordsAtoms_sat fun i hi => sat_mem_hasBytes.2 (ha i hi))
      (wordsAtoms_sat fun i hi => sat_mem_hasBytes.2 (hb i hi))
      (wordsAtoms_sat fun i hi => sat_mem_hasBytes.2 (hr i hi)))
  have hq' := holds_arrays (l := [.pc (s.regs.read 30#5),
    .reg x0 (addLimbs as bs 0#64).2, .prop (regAny x1), .prop (regAny x2), .reg x3 0#64,
    .prop (regAny x8), .prop (regAny x9), .prop (regAny x10), .reg lr (s.regs.read 30#5),
    .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
    .prop (flagAny Flags.v)]) hq
  refine ⟨s', hsteps, ?_, fun i hi => ?_, fun i hi => ?_, (addLimbs as bs 0#64).1,
    addLimbs_length as bs _ hlb.symm, fun i hi => ?_, ?_⟩
  · rw [← hrel.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · exact hasBytes_of_holds hrel hq' (at_of_mem (List.mem_append_right _
      (List.mem_append_left _ (mem_wordsAtoms.2 ⟨i, hi, rfl⟩))))
  · exact hasBytes_of_holds hrel hq' (at_of_mem (List.mem_append_right _
      (List.mem_append_right _ (List.mem_append_left _ (mem_wordsAtoms.2 ⟨i, hi, rfl⟩)))))
  · exact hasBytes_of_holds hrel hq' (at_of_mem (List.mem_append_right _
      (List.mem_append_right _ (List.mem_append_right _ (List.mem_append_left _
        (mem_wordsAtoms.2 ⟨i, hi, rfl⟩))))))
  · have h0 : s'.regs.read 0#5 = (addLimbs as bs 0#64).2 := by
      rw [← hrel.readReg (i := 0#5) (by decide)]
      exact Atoms.reg_of_holds (r := 0) hq (by braid_at)
    rw [h0]
    simpa using addLimbs_val as bs 0#64 hlb.symm (by simp)

end Examples.Limbs.Arm
