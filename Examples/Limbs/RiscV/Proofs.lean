/-
  Examples.Limbs.RiscV.Proofs

  `limbs.c` on RISC-V: multi-limb addition with carry, the second rung of the scaling
  ladder (`docs/Scaling.md`). The loop walks three arrays up to the end of the destination,
  and keeps the carry in a register between rounds. RISC-V has no flags: the carry of each of
  the two additions of a round is an unsigned comparison of the sum with an operand.

  The loop is proved by induction on the limbs still to add, with the stepper: one round is
  run symbolically, the carry it leaves is shown to be `carryOut` (`carry_eq`, by
  `bv_decide`), and the induction hypothesis is the rest of the loop. That `addLimbs` adds
  the numbers is `addLimbs_val`, a theorem about lists.

  The limbs are loaded and stored as doublewords, which the machine model only does at
  addresses that are multiples of eight: the three pointers are aligned in the specification.

  ## Main results

  * `add_limbs_spec`: the specification, with `addLimbs`
  * `add_limbs_correct`: on the machine, the limbs written and the carry returned are the sum
    of the two numbers
-/

module

public import Examples.Limbs.RiscV.Image
public import Examples.Limbs.Common
public import Lowering.RiscV.Logic

public section

namespace Examples.Limbs.RiscV

open Braid Examples Examples.Limbs Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- The carry the code computes in a round, from the comparisons after its two additions, is
`carryOut`. -/
theorem carry_eq (a b c : Word) :
    ofBool (BitVec.ult (a + c) a) ||| ofBool ((a + (c + b)).ult (a + c)) = carryOut a b c := by
  unfold carryOut ofBool
  bv_decide

/-- The loop of `add_limbs`: add the limbs `a :: as` and `b :: bs` and the carry `c`, and
store the sum over `r0 :: rs`, which end at `e`. -/
theorem add_limbs_loop (lrv e : Word) : ∀ (as bs rs : List Word) (a b r0 : Word)
    (pr pa pb c t5 t6 : Word), bs.length = as.length → rs.length = as.length →
    pr &&& 7#64 = 0#64 → pa &&& 7#64 = 0#64 → pb &&& 7#64 = 0#64 →
    pr + BitVec.ofNat 64 (8 * (as.length + 1)) = e → as.length + 1 < 2 ^ 61 →
    Triple add_limbs.program
      (Atoms.interp [.pc 0x10010#64, .reg a0 pr, .reg a1 pa, .reg a2 pb, .reg a3 e,
        .reg a4 c, .reg a5 t5, .reg a6 t6, .reg ra lrv,
        .prop (wordsAt pa (a :: as)), .prop (wordsAt pb (b :: bs)),
        .prop (wordsAt pr (r0 :: rs))])
      (Atoms.interp [.pc (lrv &&& ~~~1#64), .reg a0 (addLimbs (a :: as) (b :: bs) c).2,
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3),
        .prop (regAny a4), .prop (regAny a5), .prop (regAny a6), .reg ra lrv,
        .prop (wordsAt pa (a :: as)), .prop (wordsAt pb (b :: bs)),
        .prop (wordsAt pr (addLimbs (a :: as) (b :: bs) c).1)]) := by
  intro as
  induction as with
  | nil =>
    intro bs rs a b r0 pr pa pb c t5 t6 hlb hlr hpr hpa hpb he hb
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlb
    have hrs : rs = [] := List.length_eq_zero_iff.1 hlr
    have he' : e = pr + 8#64 := by simpa using he.symm
    subst hbs hrs he'
    braid_unfold wordsAt_cons pa a []
    braid_unfold wordsAt_cons pb b []
    braid_unfold wordsAt_cons pr r0 []
    braid_sym_run
    rw [carry_eq a b c]
    braid_fold wordsAt_cons pa a []
    braid_fold wordsAt_cons pb b []
    braid_fold wordsAt_cons pr (a + (c + b)) []
    braid_forget 11
    braid_forget 12
    braid_forget 13
    braid_forget 14
    braid_forget 15
    braid_forget 16
    simp only [addLimbs_cons, addLimbs_nil]
    braid_done
  | cons a' as ih =>
    intro bs rs a b r0 pr pa pb c t5 t6 hlb hlr hpr hpa hpb he hb
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
        (carryOut a b c) _ _ (by omega) (by omega) (by bv_decide) (by bv_decide)
        (by bv_decide) (by rw [← he]; bv_omega) (by omega)
      braid_fold wordsAt_cons pa a (a' :: as)
      braid_fold wordsAt_cons pb b (b' :: bs')
      braid_fold wordsAt_cons pr (a + (c + b))
        (addLimbs (a' :: as) (b' :: bs') (carryOut a b c)).1
      rw [addLimbs_cons a b c]
      braid_done
    · exfalso
      have : pr + 8#64 ≠ e := by rw [← he]; bv_omega
      exact this hbr

/-- `add_limbs` adds the `n` limbs its second and third arguments point to, stores the
limbs of the sum where its first argument points, and returns the carry out. The three
arrays are separate, and each is at a multiple of eight. -/
theorem add_limbs_spec (pr pa pb lrv t4 t5 t6 : Word) (as bs rs : List Word)
    (hlb : bs.length = as.length) (hlr : rs.length = as.length)
    (hpr : pr &&& 7#64 = 0#64) (hpa : pa &&& 7#64 = 0#64) (hpb : pb &&& 7#64 = 0#64)
    (hl : as.length < 2 ^ 61) :
    Triple add_limbs.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 pr, .reg a1 pa, .reg a2 pb,
        .reg a3 (BitVec.ofNat 64 as.length), .reg a4 t4, .reg a5 t5, .reg a6 t6,
        .reg ra lrv,
        .prop (wordsAt pa as), .prop (wordsAt pb bs), .prop (wordsAt pr rs)])
      (Atoms.interp [.pc (lrv &&& ~~~1#64), .reg a0 (addLimbs as bs 0#64).2,
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3),
        .prop (regAny a4), .prop (regAny a5), .prop (regAny a6), .reg ra lrv,
        .prop (wordsAt pa as), .prop (wordsAt pb bs),
        .prop (wordsAt pr (addLimbs as bs 0#64).1)]) := by
  cases as with
  | nil =>
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlb
    have hrs : rs = [] := List.length_eq_zero_iff.1 hlr
    subst hbs hrs
    simp only [List.length_nil, addLimbs_nil]
    braid_sym_run
    braid_forget 11
    braid_forget 12
    braid_forget 13
    braid_forget 14
    braid_forget 15
    braid_forget 16
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
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr
    · braid_sym_step
      braid_sym_step
      have he : pr + BitVec.ofNat 64 (8 * (as.length + 1)) =
          pr + BitVec.ofNat 64 (as.length + 1) <<< 3#64 := by
        congr 1
        apply BitVec.eq_of_toNat_eq
        simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
        omega
      braid_call add_limbs_loop lrv _ as bs' rs' a b r0 pr pa pb 0#64 t5 t6
        (by omega) (by omega) hpr hpa hpb he hl
      braid_done

/-! ## On the machine -/

/-- **`add_limbs` on the machine.** A machine that holds the code of `add_limbs`, is at its
entry, has the number of limbs `n` in `a3`, and has `n` limbs in memory at each of `a1` (the
limbs `as`), `a2` (the limbs `bs`) and `a0` (any limbs `rs`), the three pointers multiples
of eight and the three arrays pairwise apart, runs to the return address. Then the limbs
`as` and `bs` are where they were, and where `a0` pointed there are `n` limbs `sum` which,
with the carry returned in `a0` above them, are the sum of the two numbers.

The pointers are aligned because the machine model traps on a doubleword access that is
not. The destination may not overlap a source, nor one source the other: the three arrays
are three separate pieces of memory in the specification. (The code would also be right with
the destination equal to a source; that is another specification, with two arrays.) -/
theorem add_limbs_correct (s : MachineState) (as bs rs : List Word)
    (hcode : ∀ p ∈ add_limbs_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hlb : bs.length = as.length) (hlr : rs.length = as.length)
    (hn : s.getReg .x13 = BitVec.ofNat 64 as.length)
    (hpr : s.getReg .x10 &&& 7#64 = 0#64) (hpa : s.getReg .x11 &&& 7#64 = 0#64)
    (hpb : s.getReg .x12 &&& 7#64 = 0#64)
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes s (s.getReg .x11 + BitVec.ofNat 64 (8 * i)) 8 as[i])
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.getReg .x12 + BitVec.ofNat 64 (8 * i)) 8 bs[i])
    (hr : ∀ (i : Nat) (hi : i < rs.length),
      HasBytes s (s.getReg .x10 + BitVec.ofNat 64 (8 * i)) 8 rs[i])
    (hab : 8 * as.length ≤ (s.getReg .x12 - s.getReg .x11).toNat ∧
      8 * as.length ≤ (s.getReg .x11 - s.getReg .x12).toNat)
    (har : 8 * as.length ≤ (s.getReg .x10 - s.getReg .x11).toNat ∧
      8 * as.length ≤ (s.getReg .x11 - s.getReg .x10).toNat)
    (hbr : 8 * as.length ≤ (s.getReg .x10 - s.getReg .x12).toNat ∧
      8 * as.length ≤ (s.getReg .x12 - s.getReg .x10).toNat) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      (∀ (i : Nat) (hi : i < as.length),
        HasBytes s' (s.getReg .x11 + BitVec.ofNat 64 (8 * i)) 8 as[i]) ∧
      (∀ (i : Nat) (hi : i < bs.length),
        HasBytes s' (s.getReg .x12 + BitVec.ofNat 64 (8 * i)) 8 bs[i]) ∧
      ∃ sum : List Word, sum.length = as.length ∧
        (∀ (i : Nat) (hi : i < sum.length),
          HasBytes s' (s.getReg .x10 + BitVec.ofNat 64 (8 * i)) 8 sum[i]) ∧
        limbsVal sum + 2 ^ (64 * as.length) * (s'.getReg .x10).toNat =
          limbsVal as + limbsVal bs := by
  have h8 : 8 * as.length < 2 ^ 64 := by
    have := (s.getReg .x12 - s.getReg .x11).isLt
    have := hab.1
    omega
  have hl : as.length < 2 ^ 61 := by omega
  obtain ⟨n, s', σ', hsteps, hrel, hq⟩ := machine_sound_flat add_limbs_lowered
    (add_limbs_spec (s.getReg .x10) (s.getReg .x11) (s.getReg .x12) (s.getReg .x1)
      (s.getReg .x14) (s.getReg .x15) (s.getReg .x16) as bs rs hlb hlr hpr hpa hpb hl) hcode
    (interp_arrays [.pc 0x10000#64, .reg a0 (s.getReg .x10), .reg a1 (s.getReg .x11),
      .reg a2 (s.getReg .x12), .reg a3 (BitVec.ofNat 64 as.length),
      .reg a4 (s.getReg .x14), .reg a5 (s.getReg .x15), .reg a6 (s.getReg .x16),
      .reg ra (s.getReg .x1)] _ _ _ _ _ _)
    (forall_arrays (by simp [Atom.IsPointsTo]) wordsAtoms_isPointsTo wordsAtoms_isPointsTo
      wordsAtoms_isPointsTo)
    (pairwise_arrays (by braid_disj) (wordsAtoms_pairwise (by omega))
      (wordsAtoms_pairwise (by omega)) (wordsAtoms_pairwise (by omega))
      (by braid_disj_array) (by braid_disj_array) (by braid_disj_array)
      (wordsAtoms_disj (by have := hab.1; omega) (by have := hab.2; omega))
      (wordsAtoms_disj (by have := har.1; omega) (by have := har.2; omega))
      (wordsAtoms_disj (by have := hbr.1; omega) (by have := hbr.2; omega)))
    (forall_arrays
      (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, hn])
      (wordsAtoms_sat fun i hi => sat_mem_abs.2 (ha i hi))
      (wordsAtoms_sat fun i hi => sat_mem_abs.2 (hb i hi))
      (wordsAtoms_sat fun i hi => sat_mem_abs.2 (hr i hi)))
  have hq' := holds_arrays (l := [.pc (s.getReg .x1 &&& ~~~1#64),
    .reg a0 (addLimbs as bs 0#64).2, .prop (regAny a1), .prop (regAny a2), .prop (regAny a3),
    .prop (regAny a4), .prop (regAny a5), .prop (regAny a6), .reg ra (s.getReg .x1)]) hq
  refine ⟨n, s', hsteps, ?_, fun i hi => ?_, fun i hi => ?_, (addLimbs as bs 0#64).1,
    addLimbs_length as bs _ hlb.symm, fun i hi => ?_, ?_⟩
  · rw [← hrel.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · exact hasBytes_of_holds hrel hq' (at_of_mem (List.mem_append_right _
      (List.mem_append_left _ (mem_wordsAtoms.2 ⟨i, hi, rfl⟩))))
  · exact hasBytes_of_holds hrel hq' (at_of_mem (List.mem_append_right _
      (List.mem_append_right _ (List.mem_append_left _ (mem_wordsAtoms.2 ⟨i, hi, rfl⟩)))))
  · exact hasBytes_of_holds hrel hq' (at_of_mem (List.mem_append_right _
      (List.mem_append_right _ (List.mem_append_right _ (List.mem_append_left _
        (mem_wordsAtoms.2 ⟨i, hi, rfl⟩))))))
  · have h0 : s'.getReg .x10 = (addLimbs as bs 0#64).2 := by
      rw [← hrel.getReg (r := .x10) (by decide)]
      exact Atoms.reg_of_holds (r := 10) hq (by braid_at)
    rw [h0]
    simpa using addLimbs_val as bs 0#64 hlb.symm (by simp)

end Examples.Limbs.RiscV
