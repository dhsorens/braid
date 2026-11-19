/-
  Examples.Limbs.X86.Leakage

  What `add_limbs` reveals on x86-64 (`docs/Leakage.md`): the three addresses, the number of
  limbs, the stack pointer and the return address, and nothing of the limbs or of the
  carries. The compiled code sets each carry in the low byte of a register with `setc` and
  combines the two with `or`: it does not branch on a limb or a carry, the only branches are
  on the number of limbs, and every address is a base plus eight times the index. The return
  address is a word on the stack, so `ret` reveals the stack pointer, by the load, and the
  return address, by the jump; both are public inputs.

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

public import Examples.Limbs.X86.Proofs

public section

namespace Examples.Limbs.X86

open Braid Examples Examples.Limbs Lowering.X86 Lowering.X86.Regs

/-- Finish a traced triple whose trace needs a proof of its own: the symbolic state is the
postcondition, and the equation between the traces is left as the goal. -/
local macro "braid_done_trace" : tactic =>
  `(tactic| (braid_norm; refine TripleT.done_split (by braid_split) ?_))

/-- Forget the values of the six status flags, of which those the last instruction leaves
undefined hold no value already. -/
local macro "forget_flags" : tactic =>
  `(tactic| (try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 3
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-- What `n` rounds of the loop of `add_limbs` reveal: in each, the addresses of the two
limbs read and of the limb written, and whether the loop goes round again, which is whether
it is the last of the `n`. -/
def addRoundsLeak (pr pa pb : Word) : Nat → Trace
  | 0 => []
  | n + 1 =>
    [.read pa 8, .read pb 8, .write pr 8,
      .jump (if n = 0 then 0x401033#64 else 0x401010#64)] ++
      addRoundsLeak (pr + 8#64) (pa + 8#64) (pb + 8#64) n

/-- What `add_limbs` reveals: whether there is anything to add, the address of each limb read
and written, in order, the stack pointer, where the return address is read, and the return
address, where it goes. It is a function of the destination `pr`, the sources `pa` and
`pb`, the number of limbs `n`, the stack pointer `sp` and the return address `r`, and of
nothing else. -/
def addLimbsLeak (pr pa pb : Word) (n : Nat) (sp r : Word) : Trace :=
  [.jump (if n = 0 then 0x401033#64 else 0x401007#64)] ++ addRoundsLeak pr pa pb n ++
    [.read sp 8, .jump r]

/-- The loop of `add_limbs`, at index `i`, with what it reveals. -/
theorem add_limbs_loop_trace (pr pa pb n sp r : Word) :
    ∀ (as bs rs : List Word) (a b r0 : Word)
    (i c t9 t10 : Word) (fc fp fa fz fs fo : Bool) (t : Trace), bs.length = as.length →
    rs.length = as.length → i + BitVec.ofNat 64 (as.length + 1) = n →
    i.toNat + as.length + 1 < 2 ^ 64 →
    TripleT add_limbs.program
      (Atoms.interp [.pc 0x401010#64, .reg rax c, .reg rcx n, .reg rdx pb, .reg rsi pa,
        .reg rdi pr, .reg r8 i, .reg r9 t9, .reg r10 t10, .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (wordsAt (pa + i * 8#64) (a :: as)), .prop (wordsAt (pb + i * 8#64) (b :: bs)),
        .prop (wordsAt (pr + i * 8#64) (r0 :: rs))]) t
      (Atoms.interp [.pc r, .reg rax (addLimbs (a :: as) (b :: bs) c).2, .reg rcx n,
        .reg rdx pb, .reg rsi pa, .reg rdi pr, .prop (regAny r8), .prop (regAny r9),
        .prop (regAny r10), .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (wordsAt (pa + i * 8#64) (a :: as)), .prop (wordsAt (pb + i * 8#64) (b :: bs)),
        .prop (wordsAt (pr + i * 8#64) (addLimbs (a :: as) (b :: bs) c).1)])
      (t ++ (addRoundsLeak (pr + i * 8#64) (pa + i * 8#64) (pb + i * 8#64) (as.length + 1) ++
        [.read sp 8, .jump r])) := by
  have e8 : ∀ p i : Word, p + (i + 1#64) * 8#64 = p + i * 8#64 + 8#64 := fun p i => by
    rw [BitVec.add_mul, BitVec.add_assoc]; rfl
  intro as
  induction as with
  | nil =>
    intro bs rs a b r0 i c t9 t10 fc fp fa fz fs fo t hlb hlr he hb
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlb
    have hrs : rs = [] := List.length_eq_zero_iff.1 hlr
    have hn : n = i + 1#64 := by simpa using he.symm
    subst hbs hrs hn
    braid_unfold wordsAt_index pa i a []
    braid_unfold wordsAt_index pb i b []
    braid_unfold wordsAt_index pr i r0 []
    braid_sym_run
    · exact absurd (BitVec.sub_self _) hbr
    · braid_sym_run
      rw [carry_eq a b c t9 t10, sum_eq a b c]
      braid_fold wordsAt_index pa i a []
      braid_fold wordsAt_index pb i b []
      braid_fold wordsAt_index pr i (a + c + b) []
      braid_forget 8
      braid_forget 9
      braid_forget 10
      forget_flags
      simp only [addLimbs_cons, addLimbs_nil]
      braid_done_trace
      simp [addRoundsLeak]
  | cons a' as ih =>
    intro bs rs a b r0 i c t9 t10 fc fp fa fz fs fo t hlb hlr he hb
    obtain ⟨b', bs', rfl⟩ : ∃ b' bs', bs = b' :: bs' := by
      cases bs with
      | nil => simp at hlb
      | cons x y => exact ⟨x, y, rfl⟩
    obtain ⟨r', rs', rfl⟩ : ∃ r' rs', rs = r' :: rs' := by
      cases rs with
      | nil => simp at hlr
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at he hb hlb hlr
    braid_unfold wordsAt_index pa i a (a' :: as)
    braid_unfold wordsAt_index pb i b (b' :: bs')
    braid_unfold wordsAt_index pr i r0 (r' :: rs')
    braid_sym_run
    · rw [carry_eq a b c t9 t10, sum_eq a b c]
      try braid_name_flag 2
      braid_call ih bs' rs' a' b' r' (i + 1#64) (carryOut a b c) _ _ _ _ _ _ _ _ _
        (by omega) (by omega) (by rw [← he]; bv_omega) (by bv_omega)
      braid_fold wordsAt_index pa i a (a' :: as)
      braid_fold wordsAt_index pb i b (b' :: bs')
      braid_fold wordsAt_index pr i (a + c + b)
        (addLimbs (a' :: as) (b' :: bs') (carryOut a b c)).1
      rw [addLimbs_cons a b c]
      braid_done_trace
      simp [addRoundsLeak, e8]
    · exfalso
      have : n - (i + 1#64) ≠ 0#64 := by rw [← he]; bv_omega
      exact this hbr

/-- `add_limbs` adds `n` limbs and reveals `addLimbsLeak` of the three addresses, `n`, the
stack pointer and the return address. -/
theorem add_limbs_trace (pr pa pb sp r t0 t8 t9 t10 : Word) (as bs rs : List Word)
    (fc fp fa fz fs fo : Bool) (hlb : bs.length = as.length) (hlr : rs.length = as.length)
    (hl : as.length < 2 ^ 64) (t : Trace) :
    TripleT add_limbs.program
      (Atoms.interp [.pc 0x401000#64, .reg rax t0, .reg rcx (BitVec.ofNat 64 as.length),
        .reg rdx pb, .reg rsi pa, .reg rdi pr, .reg r8 t8, .reg r9 t9, .reg r10 t10,
        .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (wordsAt pa as), .prop (wordsAt pb bs), .prop (wordsAt pr rs)]) t
      (Atoms.interp [.pc r, .reg rax (addLimbs as bs 0#64).2,
        .reg rcx (BitVec.ofNat 64 as.length), .reg rdx pb, .reg rsi pa, .reg rdi pr,
        .prop (regAny r8), .prop (regAny r9), .prop (regAny r10), .reg rsp (sp + 8#64),
        .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (wordsAt pa as), .prop (wordsAt pb bs),
        .prop (wordsAt pr (addLimbs as bs 0#64).1)])
      (t ++ addLimbsLeak pr pa pb as.length sp r) := by
  cases as with
  | nil =>
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlb
    have hrs : rs = [] := List.length_eq_zero_iff.1 hlr
    subst hbs hrs
    simp only [List.length_nil, addLimbs_nil]
    braid_sym_run
    simp only [BitVec.xor_self]
    braid_forget 8
    braid_forget 9
    braid_forget 10
    forget_flags
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
    have hloop := add_limbs_loop_trace pr pa pb (BitVec.ofNat 64 (as.length + 1)) sp r as bs' rs'
      a b r0 0#64 0#64
    simp only [BitVec.zero_mul, BitVec.add_zero, BitVec.zero_add] at hloop
    braid_sym_run
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · braid_sym_step
      braid_sym_step
      simp only [BitVec.xor_self]
      try braid_name_flag 2
      braid_call hloop _ _ _ _ _ _ _ _ _ (by omega) (by omega) trivial (by simpa using hl)
      braid_done_trace
      simp [addLimbsLeak]

/-! ## On the machine -/

/-- **What `add_limbs` reveals, on the machine.** A machine of the model that runs the
executable of this image, is at the entry of `add_limbs`, has the number of limbs `n` in
`rcx` (`hn`) and `n` limbs in memory at each of `rsi` (the limbs `as`), `rdx` (the limbs
`bs`) and `rdi` (any limbs `rs`), and has the return address `r` in the eight bytes at the
stack pointer (`hret`), the three arrays and the return address apart from one another, as
`add_limbs_correct` asks, reaches `r` on every run, and the trace of the run is
`addLimbsLeak` of `rdi`, `rsi`, `rdx`, the number in `rcx`, the stack pointer and `r`. -/
theorem add_limbs_leakage [Layout] (m : MachineState) (as bs rs : List Word) (r : Word)
    (hpc : m.pc = 0x401000) (hlb : bs.length = as.length) (hlr : rs.length = as.length)
    (hn : m.data.regs.get64 .rcx = BitVec.ofNat 64 as.length)
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes m (m.data.regs.get64 .rsi + BitVec.ofNat 64 (8 * i)) 8 as[i])
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes m (m.data.regs.get64 .rdx + BitVec.ofNat 64 (8 * i)) 8 bs[i])
    (hr : ∀ (i : Nat) (hi : i < rs.length),
      HasBytes m (m.data.regs.get64 .rdi + BitVec.ofNat 64 (8 * i)) 8 rs[i])
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hab : 8 * as.length ≤ (m.data.regs.get64 .rdx - m.data.regs.get64 .rsi).toNat ∧
      8 * as.length ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rdx).toNat)
    (har : 8 * as.length ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsi).toNat ∧
      8 * as.length ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rdi).toNat)
    (hbr : 8 * as.length ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rdx).toNat ∧
      8 * as.length ≤ (m.data.regs.get64 .rdx - m.data.regs.get64 .rdi).toNat)
    (hasp : 8 * as.length ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rsp).toNat)
    (hbsp : 8 * as.length ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rdx).toNat ∧
      8 ≤ (m.data.regs.get64 .rdx - m.data.regs.get64 .rsp).toNat)
    (hrsp : 8 * as.length ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsp).toNat) :
    RunL exe
      (fun m' u => u = addLimbsLeak (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
        (m.data.regs.get64 .rdx) (m.data.regs.get64 .rcx).toNat (m.data.regs.get64 .rsp) r ∧
        m'.pc.toBitVec = r) m [] := by
  have h8 : 8 * as.length < 2 ^ 64 := by
    have : (m.data.regs.get64 .rsp - m.data.regs.get64 .rsi).toNat < 2 ^ 64 := BitVec.isLt _
    omega
  have hl : as.length < 2 ^ 64 := by omega
  have hnat : (m.data.regs.get64 .rcx).toNat = as.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  refine (machine_soundT add_limbs_holds
    (add_limbs_trace (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64 .rdx)
      (m.data.regs.get64 .rsp) r (m.data.regs.get64 .rax) (m.data.regs.get64 .r8)
      (m.data.regs.get64 .r9) (m.data.regs.get64 .r10) as bs rs m.data.status.cf
      m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of
      hlb hlr hl [])
    (interp_arrays [.pc 0x401000#64, .reg rax (m.data.regs.get64 .rax),
      .reg rcx (BitVec.ofNat 64 as.length), .reg rdx (m.data.regs.get64 .rdx),
      .reg rsi (m.data.regs.get64 .rsi), .reg rdi (m.data.regs.get64 .rdi),
      .reg r8 (m.data.regs.get64 .r8), .reg r9 (m.data.regs.get64 .r9),
      .reg r10 (m.data.regs.get64 .r10), .reg rsp (m.data.regs.get64 .rsp),
      .mem (m.data.regs.get64 .rsp) 8 r true,
      .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
      .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
      .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of] _ _ _ _ _ _)
    (forall_arrays (by simp [Atom.IsPointsTo]) wordsAtoms_isPointsTo wordsAtoms_isPointsTo
      wordsAtoms_isPointsTo)
    (pairwise_arrays
      (by
        braid_disj
        repeat' constructor
        all_goals decide)
      (wordsAtoms_pairwise (by omega))
      (wordsAtoms_pairwise (by omega)) (wordsAtoms_pairwise (by omega))
      (by
        braid_disj_array
        exact disj_mem_wordsAtoms (sep_array hasp) (by omega))
      (by
        braid_disj_array
        exact disj_mem_wordsAtoms (sep_array (hlb ▸ hbsp)) (by omega))
      (by
        braid_disj_array
        exact disj_mem_wordsAtoms (sep_array (hlr ▸ hrsp)) (by omega))
      (wordsAtoms_disj (by have := hab.1; omega) (by have := hab.2; omega))
      (wordsAtoms_disj (by have := har.1; omega) (by have := har.2; omega))
      (wordsAtoms_disj (by have := hbr.1; omega) (by have := hbr.2; omega)))
    (forall_arrays
      (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
        hret, hn])
      (wordsAtoms_sat fun i hi => sat_mem_abs.2 (ha i hi))
      (wordsAtoms_sat fun i hi => sat_mem_abs.2 (hb i hi))
      (wordsAtoms_sat fun i hi => sat_mem_abs.2 (hr i hi)))).mono ?_
  rintro m' u ⟨e, σ', hrel, hq⟩
  refine ⟨e, ?_⟩
  rw [← hrel.pc]
  exact Atoms.pc_of_holds hq (by braid_at)

/-- **`add_limbs` reveals nothing of the limbs it adds.** Two machines that run the
executable of this image, are at the entry of `add_limbs`, each with three arrays and the
return address `r` on its stack as `add_limbs_leakage` asks, and that agree on `rdi`, `rsi`,
`rdx`, `rcx` and the stack pointer, have the same trace on every run, whatever the limbs
are, and whatever carries they make. -/
theorem add_limbs_leakage_eq [Layout] (m₁ m₂ : MachineState)
    (as₁ bs₁ rs₁ as₂ bs₂ rs₂ : List Word) (r : Word)
    (hpc₁ : m₁.pc = 0x401000) (hlb₁ : bs₁.length = as₁.length) (hlr₁ : rs₁.length = as₁.length)
    (hn₁ : m₁.data.regs.get64 .rcx = BitVec.ofNat 64 as₁.length)
    (ha₁ : ∀ (i : Nat) (hi : i < as₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rsi + BitVec.ofNat 64 (8 * i)) 8 as₁[i])
    (hb₁ : ∀ (i : Nat) (hi : i < bs₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rdx + BitVec.ofNat 64 (8 * i)) 8 bs₁[i])
    (hr₁ : ∀ (i : Nat) (hi : i < rs₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rdi + BitVec.ofNat 64 (8 * i)) 8 rs₁[i])
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (hab₁ : 8 * as₁.length ≤ (m₁.data.regs.get64 .rdx - m₁.data.regs.get64 .rsi).toNat ∧
      8 * as₁.length ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rdx).toNat)
    (har₁ : 8 * as₁.length ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rsi).toNat ∧
      8 * as₁.length ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rdi).toNat)
    (hbr₁ : 8 * as₁.length ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rdx).toNat ∧
      8 * as₁.length ≤ (m₁.data.regs.get64 .rdx - m₁.data.regs.get64 .rdi).toNat)
    (hasp₁ : 8 * as₁.length ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rsp).toNat)
    (hbsp₁ : 8 * as₁.length ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rdx).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rdx - m₁.data.regs.get64 .rsp).toNat)
    (hrsp₁ : 8 * as₁.length ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rsp).toNat)
    (hpc₂ : m₂.pc = 0x401000) (hlb₂ : bs₂.length = as₂.length) (hlr₂ : rs₂.length = as₂.length)
    (hn₂ : m₂.data.regs.get64 .rcx = BitVec.ofNat 64 as₂.length)
    (ha₂ : ∀ (i : Nat) (hi : i < as₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rsi + BitVec.ofNat 64 (8 * i)) 8 as₂[i])
    (hb₂ : ∀ (i : Nat) (hi : i < bs₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rdx + BitVec.ofNat 64 (8 * i)) 8 bs₂[i])
    (hr₂ : ∀ (i : Nat) (hi : i < rs₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rdi + BitVec.ofNat 64 (8 * i)) 8 rs₂[i])
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hab₂ : 8 * as₂.length ≤ (m₂.data.regs.get64 .rdx - m₂.data.regs.get64 .rsi).toNat ∧
      8 * as₂.length ≤ (m₂.data.regs.get64 .rsi - m₂.data.regs.get64 .rdx).toNat)
    (har₂ : 8 * as₂.length ≤ (m₂.data.regs.get64 .rdi - m₂.data.regs.get64 .rsi).toNat ∧
      8 * as₂.length ≤ (m₂.data.regs.get64 .rsi - m₂.data.regs.get64 .rdi).toNat)
    (hbr₂ : 8 * as₂.length ≤ (m₂.data.regs.get64 .rdi - m₂.data.regs.get64 .rdx).toNat ∧
      8 * as₂.length ≤ (m₂.data.regs.get64 .rdx - m₂.data.regs.get64 .rdi).toNat)
    (hasp₂ : 8 * as₂.length ≤ (m₂.data.regs.get64 .rsp - m₂.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m₂.data.regs.get64 .rsi - m₂.data.regs.get64 .rsp).toNat)
    (hbsp₂ : 8 * as₂.length ≤ (m₂.data.regs.get64 .rsp - m₂.data.regs.get64 .rdx).toNat ∧
      8 ≤ (m₂.data.regs.get64 .rdx - m₂.data.regs.get64 .rsp).toNat)
    (hrsp₂ : 8 * as₂.length ≤ (m₂.data.regs.get64 .rsp - m₂.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m₂.data.regs.get64 .rdi - m₂.data.regs.get64 .rsp).toNat)
    (edi : m₂.data.regs.get64 .rdi = m₁.data.regs.get64 .rdi)
    (esi : m₂.data.regs.get64 .rsi = m₁.data.regs.get64 .rsi)
    (edx : m₂.data.regs.get64 .rdx = m₁.data.regs.get64 .rdx)
    (ecx : m₂.data.regs.get64 .rcx = m₁.data.regs.get64 .rcx)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := add_limbs_leakage m₁ as₁ bs₁ rs₁ r hpc₁ hlb₁ hlr₁ hn₁ ha₁ hb₁ hr₁ hret₁ hab₁ har₁ hbr₁
    hasp₁ hbsp₁ hrsp₁
  have h₂ := add_limbs_leakage m₂ as₂ bs₂ rs₂ r hpc₂ hlb₂ hlr₂ hn₂ ha₂ hb₂ hr₂ hret₂ hab₂ har₂ hbr₂
    hasp₂ hbsp₂ hrsp₂
  rw [edi, esi, edx, ecx, esp] at h₂
  exact ⟨_, h₁, h₂⟩

end Examples.Limbs.X86
