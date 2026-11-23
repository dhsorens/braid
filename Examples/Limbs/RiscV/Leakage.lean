/-
  Examples.Limbs.RiscV.Leakage

  What `add_limbs` reveals on RISC-V (`docs/Leakage.md`): the three addresses, the number of
  limbs and the return address, and nothing of the limbs or of the carries. The compiled
  code computes each carry with two unsigned comparisons into a register (`sltu`) and an
  `or`: it does not branch on a limb or a carry, and the only branches are on the number of
  limbs.

  The loop is proved by the induction of the functional proof, with what the rounds still to
  run reveal as a function of their number. The traced triples carry the functional
  postcondition as well.

  ## Main definitions

  * `addLimbsLeak`: what a run reveals, as a function of what is public

  ## Main results

  * `add_limbs_trace`: the traced triple
  * `add_limbs_leakage`: the same, about the machine alone
  * `add_limbs_leakage_eq`: two machines that agree on what is public run with the same trace
-/

module

public import Examples.Limbs.RiscV.Proofs
import Braid.BV

public section

namespace Examples.Limbs.RiscV

open Braid Examples Examples.Limbs Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- Finish a traced triple whose trace needs a proof of its own: the symbolic state is the
postcondition, and the equation between the traces is left as the goal. -/
local macro "braid_done_trace" : tactic =>
  `(tactic| (braid_norm; refine TripleT.done_split (by braid_split) ?_))

/-- What `n` rounds of the loop of `add_limbs` reveal: in each, the addresses of the two
limbs read and of the limb written, and whether the loop goes round again, which is whether
it is the last of the `n`. -/
def addRoundsLeak (pr pa pb : Word) : Nat → Trace
  | 0 => []
  | n + 1 =>
    [.read pa 8, .read pb 8, .write pr 8,
      .jump (if n = 0 then 0x10040#64 else 0x10010#64)] ++
      addRoundsLeak (pr + 8#64) (pa + 8#64) (pb + 8#64) n

/-- What `add_limbs` reveals: whether there is anything to add, the address of each limb read
and written, in order, and where it returns. It is a function of the destination `pr`, the
sources `pa` and `pb`, the number of limbs `n` and the return address `r`, and of nothing
else. -/
def addLimbsLeak (pr pa pb : Word) (n : Nat) (r : Word) : Trace :=
  [.jump (if n = 0 then 0x10040#64 else 0x10008#64)] ++ addRoundsLeak pr pa pb n ++
    [.jump (r &&& ~~~1#64)]

/-- The loop of `add_limbs`, with what it reveals. -/
theorem add_limbs_loop_trace (lrv e : Word) : ∀ (as bs rs : List Word) (a b r0 : Word)
    (pr pa pb c t5 t6 : Word) (t : Trace), bs.length = as.length → rs.length = as.length →
    pr &&& 7#64 = 0#64 → pa &&& 7#64 = 0#64 → pb &&& 7#64 = 0#64 →
    pr + BitVec.ofNat 64 (8 * (as.length + 1)) = e → as.length + 1 < 2 ^ 61 →
    TripleT add_limbs.program
      (Atoms.interp [.pc 0x10010#64, .reg a0 pr, .reg a1 pa, .reg a2 pb, .reg a3 e,
        .reg a4 c, .reg a5 t5, .reg a6 t6, .reg ra lrv,
        .prop (wordsAt pa (a :: as)), .prop (wordsAt pb (b :: bs)),
        .prop (wordsAt pr (r0 :: rs))]) t
      (Atoms.interp [.pc (lrv &&& ~~~1#64), .reg a0 (addLimbs (a :: as) (b :: bs) c).2,
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3),
        .prop (regAny a4), .prop (regAny a5), .prop (regAny a6), .reg ra lrv,
        .prop (wordsAt pa (a :: as)), .prop (wordsAt pb (b :: bs)),
        .prop (wordsAt pr (addLimbs (a :: as) (b :: bs) c).1)])
      (t ++ (addRoundsLeak pr pa pb (as.length + 1) ++ [.jump (lrv &&& ~~~1#64)])) := by
  intro as
  induction as with
  | nil =>
    intro bs rs a b r0 pr pa pb c t5 t6 t hlb hlr hpr hpa hpb he hb
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
    braid_done_trace
    simp [addRoundsLeak]
  | cons a' as ih =>
    intro bs rs a b r0 pr pa pb c t5 t6 t hlb hlr hpr hpa hpb he hb
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
        (carryOut a b c) _ _ _ (by omega) (by omega) (by bv_auto) (by bv_auto)
        (by bv_auto) (by rw [← he]; bv_omega) (by omega)
      braid_fold wordsAt_cons pa a (a' :: as)
      braid_fold wordsAt_cons pb b (b' :: bs')
      braid_fold wordsAt_cons pr (a + (c + b))
        (addLimbs (a' :: as) (b' :: bs') (carryOut a b c)).1
      rw [addLimbs_cons a b c]
      braid_done_trace
      simp [addRoundsLeak]
    · exfalso
      have : pr + 8#64 ≠ e := by rw [← he]; bv_omega
      exact this hbr

/-- `add_limbs` adds `n` limbs and reveals `addLimbsLeak` of the three addresses, `n` and the
return address. -/
theorem add_limbs_trace (pr pa pb lrv t4 t5 t6 : Word) (as bs rs : List Word)
    (hlb : bs.length = as.length) (hlr : rs.length = as.length)
    (hpr : pr &&& 7#64 = 0#64) (hpa : pa &&& 7#64 = 0#64) (hpb : pb &&& 7#64 = 0#64)
    (hl : as.length < 2 ^ 61) (t : Trace) :
    TripleT add_limbs.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 pr, .reg a1 pa, .reg a2 pb,
        .reg a3 (BitVec.ofNat 64 as.length), .reg a4 t4, .reg a5 t5, .reg a6 t6,
        .reg ra lrv,
        .prop (wordsAt pa as), .prop (wordsAt pb bs), .prop (wordsAt pr rs)]) t
      (Atoms.interp [.pc (lrv &&& ~~~1#64), .reg a0 (addLimbs as bs 0#64).2,
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3),
        .prop (regAny a4), .prop (regAny a5), .prop (regAny a6), .reg ra lrv,
        .prop (wordsAt pa as), .prop (wordsAt pb bs),
        .prop (wordsAt pr (addLimbs as bs 0#64).1)])
      (t ++ addLimbsLeak pr pa pb as.length lrv) := by
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
    braid_done_trace
    simp [addLimbsLeak, addRoundsLeak]
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
      braid_call add_limbs_loop_trace lrv _ as bs' rs' a b r0 pr pa pb 0#64 t5 t6 _
        (by omega) (by omega) hpr hpa hpb he hl
      braid_done_trace
      simp [addLimbsLeak]

/-! ## On the machine -/

/-- **What `add_limbs` reveals, on the machine.** A machine that holds the code of
`add_limbs`, is at its entry, has the number of limbs `n` in `a3` (`hn`), and has `n` limbs
in memory at each of `a1` (the limbs `as`), `a2` (the limbs `bs`) and `a0` (any limbs `rs`),
the three pointers multiples of eight and the three arrays pairwise apart, as
`add_limbs_correct` asks, runs to the return address with the trace `addLimbsLeak` of the
three addresses, the number in `a3` and the return address. -/
theorem add_limbs_leakage (s : MachineState) (as bs rs : List Word)
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
    ∃ s', RunL s (addLimbsLeak (s.getReg .x10) (s.getReg .x11) (s.getReg .x12)
        (s.getReg .x13).toNat (s.getReg .x1)) s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 := by
  have h8 : 8 * as.length < 2 ^ 64 := by
    have := (s.getReg .x12 - s.getReg .x11).isLt
    have := hab.1
    omega
  have hl : as.length < 2 ^ 61 := by omega
  have hnat : (s.getReg .x13).toNat = as.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  rw [hnat]
  obtain ⟨s', σ', hrun, hrel, hq⟩ := machine_soundT add_limbs_lowered
    (add_limbs_trace (s.getReg .x10) (s.getReg .x11) (s.getReg .x12) (s.getReg .x1)
      (s.getReg .x14) (s.getReg .x15) (s.getReg .x16) as bs rs hlb hlr hpr hpa hpb hl [])
    hcode
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
  refine ⟨s', hrun, ?_⟩
  rw [← hrel.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`add_limbs` reveals nothing of the limbs it adds, nor of the carries.** Two machines
that hold the code of `add_limbs`, are at its entry, each with three arrays as
`add_limbs_leakage` asks, and that agree on the three addresses, the number of limbs and the
return address, run with the same trace, whatever the limbs are. -/
theorem add_limbs_leakage_eq (s₁ s₂ : MachineState) (as₁ bs₁ rs₁ as₂ bs₂ rs₂ : List Word)
    (hcode₁ : ∀ p ∈ add_limbs_code, s₁.code p.1 = some p.2)
    (hcode₂ : ∀ p ∈ add_limbs_code, s₂.code p.1 = some p.2)
    (hpc₁ : s₁.pc = 0x10000#64) (hpc₂ : s₂.pc = 0x10000#64)
    (hlb₁ : bs₁.length = as₁.length) (hlr₁ : rs₁.length = as₁.length)
    (hlb₂ : bs₂.length = as₂.length) (hlr₂ : rs₂.length = as₂.length)
    (hn₁ : s₁.getReg .x13 = BitVec.ofNat 64 as₁.length)
    (hn₂ : s₂.getReg .x13 = BitVec.ofNat 64 as₂.length)
    (hpr : s₁.getReg .x10 &&& 7#64 = 0#64) (hpa : s₁.getReg .x11 &&& 7#64 = 0#64)
    (hpb : s₁.getReg .x12 &&& 7#64 = 0#64)
    (ha₁ : ∀ (i : Nat) (hi : i < as₁.length),
      HasBytes s₁ (s₁.getReg .x11 + BitVec.ofNat 64 (8 * i)) 8 as₁[i])
    (hb₁ : ∀ (i : Nat) (hi : i < bs₁.length),
      HasBytes s₁ (s₁.getReg .x12 + BitVec.ofNat 64 (8 * i)) 8 bs₁[i])
    (hr₁ : ∀ (i : Nat) (hi : i < rs₁.length),
      HasBytes s₁ (s₁.getReg .x10 + BitVec.ofNat 64 (8 * i)) 8 rs₁[i])
    (ha₂ : ∀ (i : Nat) (hi : i < as₂.length),
      HasBytes s₂ (s₂.getReg .x11 + BitVec.ofNat 64 (8 * i)) 8 as₂[i])
    (hb₂ : ∀ (i : Nat) (hi : i < bs₂.length),
      HasBytes s₂ (s₂.getReg .x12 + BitVec.ofNat 64 (8 * i)) 8 bs₂[i])
    (hr₂ : ∀ (i : Nat) (hi : i < rs₂.length),
      HasBytes s₂ (s₂.getReg .x10 + BitVec.ofNat 64 (8 * i)) 8 rs₂[i])
    (hab₁ : 8 * as₁.length ≤ (s₁.getReg .x12 - s₁.getReg .x11).toNat ∧
      8 * as₁.length ≤ (s₁.getReg .x11 - s₁.getReg .x12).toNat)
    (har₁ : 8 * as₁.length ≤ (s₁.getReg .x10 - s₁.getReg .x11).toNat ∧
      8 * as₁.length ≤ (s₁.getReg .x11 - s₁.getReg .x10).toNat)
    (hbr₁ : 8 * as₁.length ≤ (s₁.getReg .x10 - s₁.getReg .x12).toNat ∧
      8 * as₁.length ≤ (s₁.getReg .x12 - s₁.getReg .x10).toNat)
    (hab₂ : 8 * as₂.length ≤ (s₂.getReg .x12 - s₂.getReg .x11).toNat ∧
      8 * as₂.length ≤ (s₂.getReg .x11 - s₂.getReg .x12).toNat)
    (har₂ : 8 * as₂.length ≤ (s₂.getReg .x10 - s₂.getReg .x11).toNat ∧
      8 * as₂.length ≤ (s₂.getReg .x11 - s₂.getReg .x10).toNat)
    (hbr₂ : 8 * as₂.length ≤ (s₂.getReg .x10 - s₂.getReg .x12).toNat ∧
      8 * as₂.length ≤ (s₂.getReg .x12 - s₂.getReg .x10).toNat)
    (e10 : s₂.getReg .x10 = s₁.getReg .x10) (e11 : s₂.getReg .x11 = s₁.getReg .x11)
    (e12 : s₂.getReg .x12 = s₁.getReg .x12) (e13 : s₂.getReg .x13 = s₁.getReg .x13)
    (e1 : s₂.getReg .x1 = s₁.getReg .x1) :
    ∃ tr s₁' s₂', RunL s₁ tr s₁' ∧ RunL s₂ tr s₂' ∧
      s₁'.pc = s₁.getReg .x1 &&& ~~~1#64 ∧ s₂'.pc = s₁.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨s₁', h₁, hp₁⟩ := add_limbs_leakage s₁ as₁ bs₁ rs₁ hcode₁ hpc₁ hlb₁ hlr₁ hn₁
    hpr hpa hpb ha₁ hb₁ hr₁ hab₁ har₁ hbr₁
  obtain ⟨s₂', h₂, hp₂⟩ := add_limbs_leakage s₂ as₂ bs₂ rs₂ hcode₂ hpc₂ hlb₂ hlr₂ hn₂
    (e10 ▸ hpr) (e11 ▸ hpa) (e12 ▸ hpb) ha₂ hb₂ hr₂ hab₂ har₂ hbr₂
  simp only [e10, e11, e12, e13, e1] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.Limbs.RiscV
