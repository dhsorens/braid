/-
  Examples.Limbs.Arm.Leakage

  What `add_limbs` reveals on AArch64 (`docs/Leakage.md`): the three addresses, the number of
  limbs and the return address, and nothing of the limbs or of the carries. The compiled
  code takes each carry from the carry flag of an addition into a register with a
  conditional set (`cset`), which reveals nothing: it does not branch on a limb or a carry,
  and the only branches are on the number of limbs.

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

public import Examples.Limbs.Arm.Proofs

public section

namespace Examples.Limbs.Arm

open Braid Examples Examples.Limbs Lowering.Arm Lowering.Arm.Regs

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
      .jump (if n = 0 then 0x1002c#64 else 0x10008#64)] ++
      addRoundsLeak (pr + 8#64) (pa + 8#64) (pb + 8#64) n

/-- What `add_limbs` reveals: whether there is anything to add, the address of each limb read
and written, in order, and where it returns. It is a function of the destination `pr`, the
sources `pa` and `pb`, the number of limbs `n` and the return address `r`, and of nothing
else. -/
def addLimbsLeak (pr pa pb : Word) (n : Nat) (r : Word) : Trace :=
  [.jump (if n = 0 then 0x1002c#64 else 0x10008#64)] ++ addRoundsLeak pr pa pb n ++
    [.jump r]

/-- Forget what `add_limbs` leaves in the registers it uses and in the flags. -/
local macro "add_limbs_forget" : tactic =>
  `(tactic| (braid_forget 1; braid_forget 2; braid_forget 8; braid_forget 9; braid_forget 10
             braid_forget_flag 0; braid_forget_flag 1; braid_forget_flag 2
             braid_forget_flag 3))

/-- The loop of `add_limbs`, with what it reveals. -/
theorem add_limbs_loop_trace (lrv : Word) : ∀ (as bs rs : List Word) (a b r0 : Word)
    (pr pa pb n c t9 t10 : Word) (fn fz fc fv : Bool) (t : Trace), bs.length = as.length →
    rs.length = as.length →
    n = BitVec.ofNat 64 (as.length + 1) → as.length + 1 < 2 ^ 64 →
    TripleT add_limbs.program
      (Atoms.interp [.pc 0x10008#64, .reg x0 pr, .reg x1 pa, .reg x2 pb, .reg x3 n,
        .reg x8 c, .reg x9 t9, .reg x10 t10, .reg lr lrv,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (wordsAt pa (a :: as)), .prop (wordsAt pb (b :: bs)),
        .prop (wordsAt pr (r0 :: rs))]) t
      (Atoms.interp [.pc lrv, .reg x0 (addLimbs (a :: as) (b :: bs) c).2,
        .prop (regAny x1), .prop (regAny x2), .reg x3 0#64,
        .prop (regAny x8), .prop (regAny x9), .prop (regAny x10), .reg lr lrv,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v),
        .prop (wordsAt pa (a :: as)), .prop (wordsAt pb (b :: bs)),
        .prop (wordsAt pr (addLimbs (a :: as) (b :: bs) c).1)])
      (t ++ (addRoundsLeak pr pa pb (as.length + 1) ++ [.jump lrv])) := by
  intro as
  induction as with
  | nil =>
    intro bs rs a b r0 pr pa pb n c t9 t10 fn fz fc fv t hlb hlr he hb
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
    add_limbs_forget
    simp only [addLimbs_cons, addLimbs_nil]
    braid_done_trace
    simp [addRoundsLeak]
  | cons a' as ih =>
    intro bs rs a b r0 pr pa pb n c t9 t10 fn fz fc fv t hlb hlr he hb
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
        (n + 0xffffffffffffffff#64) (carryOut a b c) _ _ _ _ _ _ _
        (by omega) (by omega) (by rw [he]; bv_omega) (by omega)
      braid_fold wordsAt_cons pa a (a' :: as)
      braid_fold wordsAt_cons pb b (b' :: bs')
      braid_fold wordsAt_cons pr (a + (c + b))
        (addLimbs (a' :: as) (b' :: bs') (carryOut a b c)).1
      rw [addLimbs_cons a b c]
      braid_done_trace
      simp [addRoundsLeak]
    · exfalso
      have : n ≠ 1#64 := by rw [he]; bv_omega
      exact this hbr

/-- `add_limbs` adds `n` limbs and reveals `addLimbsLeak` of the three addresses, `n` and the
return address. -/
theorem add_limbs_trace (pr pa pb lrv t8 t9 t10 : Word) (as bs rs : List Word)
    (fn fz fc fv : Bool) (hlb : bs.length = as.length) (hlr : rs.length = as.length)
    (hl : as.length < 2 ^ 64) (t : Trace) :
    TripleT add_limbs.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 pr, .reg x1 pa, .reg x2 pb,
        .reg x3 (BitVec.ofNat 64 as.length), .reg x8 t8, .reg x9 t9, .reg x10 t10,
        .reg lr lrv,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (wordsAt pa as), .prop (wordsAt pb bs), .prop (wordsAt pr rs)]) t
      (Atoms.interp [.pc lrv, .reg x0 (addLimbs as bs 0#64).2,
        .prop (regAny x1), .prop (regAny x2), .reg x3 0#64,
        .prop (regAny x8), .prop (regAny x9), .prop (regAny x10), .reg lr lrv,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v),
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
    add_limbs_forget
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
    · braid_call add_limbs_loop_trace lrv as bs' rs' a b r0 pr pa pb _ 0#64 t9 t10
        fn fz fc fv _ (by omega) (by omega) rfl hl
      braid_done_trace
      simp [addLimbsLeak]
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr

/-! ## On the machine -/

/-- **What `add_limbs` reveals, on the machine.** A running machine whose program holds the
words of `add_limbs` (`hw`), with its code loaded (`hc`) and its program counter at the entry
(`hpc`), with the number of limbs `n` in `x3` (`hn`), and with `n` limbs in memory at each of
`x1` (the limbs `as`, `ha`), `x2` (the limbs `bs`, `hlb`, `hb`) and `x0` (any limbs `rs`,
`hlr`, `hr`), the three arrays pairwise apart (`hab`, `har`, `hbr`), as `add_limbs_correct`
asks, runs to the address in the link register with the trace `addLimbsLeak` of the three
addresses, the number in `x3` and the link register. -/
theorem add_limbs_leakage (prog : Arm64.Program) (s : Arm64.State) (as bs rs : List Word)
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
    ∃ s', RunL prog s (addLimbsLeak (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 2#5)
        (s.regs.read 3#5).toNat (s.regs.read 30#5)) s' ∧ s'.pc = s.regs.read 30#5 := by
  have h8 : 8 * as.length < 2 ^ 64 := by
    have := (s.regs.read 2#5 - s.regs.read 1#5).isLt
    have := hab.1
    omega
  have hl : as.length < 2 ^ 64 := by omega
  have hnat : (s.regs.read 3#5).toNat = as.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  obtain ⟨s', σ', hsteps, hrel, hq⟩ := machine_soundT add_limbs_lowered
    (add_limbs_trace (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 2#5) (s.regs.read 30#5)
      (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5) as bs rs s.pstate.n s.pstate.z
      s.pstate.c s.pstate.v hlb hlr hl []) hw hc hrun
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
  refine ⟨s', hsteps, ?_⟩
  rw [← hrel.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`add_limbs` reveals nothing of the limbs it adds, nor of the carries.** Two running
machines that hold the words of `add_limbs`, with their code loaded and at its entry, each
with three arrays as `add_limbs_leakage` asks, and that agree on the three addresses, the
number of limbs and the link register, run with the same trace, whatever the limbs are. -/
theorem add_limbs_leakage_eq (prog₁ prog₂ : Arm64.Program) (s₁ s₂ : Arm64.State)
    (as₁ bs₁ rs₁ as₂ bs₂ rs₂ : List Word)
    (hw₁ : prog₁.hasWords 0x10000#64 add_limbs_words) (hc₁ : prog₁.CodeLoaded s₁.mem)
    (hw₂ : prog₂.hasWords 0x10000#64 add_limbs_words) (hc₂ : prog₂.CodeLoaded s₂.mem)
    (hrun₁ : s₁.status = .Running) (hrun₂ : s₂.status = .Running)
    (hpc₁ : s₁.pc = 0x10000#64) (hpc₂ : s₂.pc = 0x10000#64)
    (hlb₁ : bs₁.length = as₁.length) (hlr₁ : rs₁.length = as₁.length)
    (hlb₂ : bs₂.length = as₂.length) (hlr₂ : rs₂.length = as₂.length)
    (hn₁ : s₁.regs.read 3#5 = BitVec.ofNat 64 as₁.length)
    (hn₂ : s₂.regs.read 3#5 = BitVec.ofNat 64 as₂.length)
    (ha₁ : ∀ (i : Nat) (hi : i < as₁.length),
      HasBytes s₁ (s₁.regs.read 1#5 + BitVec.ofNat 64 (8 * i)) 8 as₁[i])
    (hb₁ : ∀ (i : Nat) (hi : i < bs₁.length),
      HasBytes s₁ (s₁.regs.read 2#5 + BitVec.ofNat 64 (8 * i)) 8 bs₁[i])
    (hr₁ : ∀ (i : Nat) (hi : i < rs₁.length),
      HasBytes s₁ (s₁.regs.read 0#5 + BitVec.ofNat 64 (8 * i)) 8 rs₁[i])
    (ha₂ : ∀ (i : Nat) (hi : i < as₂.length),
      HasBytes s₂ (s₂.regs.read 1#5 + BitVec.ofNat 64 (8 * i)) 8 as₂[i])
    (hb₂ : ∀ (i : Nat) (hi : i < bs₂.length),
      HasBytes s₂ (s₂.regs.read 2#5 + BitVec.ofNat 64 (8 * i)) 8 bs₂[i])
    (hr₂ : ∀ (i : Nat) (hi : i < rs₂.length),
      HasBytes s₂ (s₂.regs.read 0#5 + BitVec.ofNat 64 (8 * i)) 8 rs₂[i])
    (hab₁ : Apart (s₁.regs.read 1#5) (8 * as₁.length) (s₁.regs.read 2#5) (8 * as₁.length))
    (har₁ : Apart (s₁.regs.read 1#5) (8 * as₁.length) (s₁.regs.read 0#5) (8 * as₁.length))
    (hbr₁ : Apart (s₁.regs.read 2#5) (8 * as₁.length) (s₁.regs.read 0#5) (8 * as₁.length))
    (hab₂ : Apart (s₂.regs.read 1#5) (8 * as₂.length) (s₂.regs.read 2#5) (8 * as₂.length))
    (har₂ : Apart (s₂.regs.read 1#5) (8 * as₂.length) (s₂.regs.read 0#5) (8 * as₂.length))
    (hbr₂ : Apart (s₂.regs.read 2#5) (8 * as₂.length) (s₂.regs.read 0#5) (8 * as₂.length))
    (e0 : s₂.regs.read 0#5 = s₁.regs.read 0#5) (e1 : s₂.regs.read 1#5 = s₁.regs.read 1#5)
    (e2 : s₂.regs.read 2#5 = s₁.regs.read 2#5) (e3 : s₂.regs.read 3#5 = s₁.regs.read 3#5)
    (e30 : s₂.regs.read 30#5 = s₁.regs.read 30#5) :
    ∃ tr s₁' s₂', RunL prog₁ s₁ tr s₁' ∧ RunL prog₂ s₂ tr s₂' ∧
      s₁'.pc = s₁.regs.read 30#5 ∧ s₂'.pc = s₁.regs.read 30#5 := by
  obtain ⟨s₁', h₁, hp₁⟩ := add_limbs_leakage prog₁ s₁ as₁ bs₁ rs₁ hw₁ hc₁ hrun₁ hpc₁ hlb₁
    hlr₁ hn₁ ha₁ hb₁ hr₁ hab₁ har₁ hbr₁
  obtain ⟨s₂', h₂, hp₂⟩ := add_limbs_leakage prog₂ s₂ as₂ bs₂ rs₂ hw₂ hc₂ hrun₂ hpc₂ hlb₂
    hlr₂ hn₂ ha₂ hb₂ hr₂ hab₂ har₂ hbr₂
  simp only [e0, e1, e2, e3, e30] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.Limbs.Arm
