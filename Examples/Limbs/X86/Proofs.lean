/-
  Examples.Limbs.X86.Proofs

  `limbs.c` on x86-64: multi-limb addition with carry, the second rung of the scaling
  ladder (`docs/Scaling.md`). The loop keeps an index in a register and addresses the limbs
  of the three arrays as base plus eight times the index; the carry of each of the two
  additions is set in the low byte of a register, and the two are combined into the carry
  for the next round.

  The loop is proved by induction on the limbs still to add, at any index `i`, with the
  stepper: one round is run symbolically, the carry it leaves is shown to be `carryOut`
  (`carry_eq`, by `bv_auto`), and the induction hypothesis is the rest of the loop. That
  `addLimbs` adds the numbers is `addLimbs_val`, a theorem about lists.

  ## Main results

  * `add_limbs_spec`: the specification, with `addLimbs`
  * `add_limbs_correct`: on the machine, the limbs written and the carry returned are the sum
    of the two numbers
-/

module

public import Examples.Limbs.X86.Image
public import Examples.Limbs.Common
import Braid.BV

public section

namespace Examples.Limbs.X86

open Braid Examples Examples.Limbs Lowering.X86 Lowering.X86.Regs

/-- An array of words that starts at index `i` from `p`, opened at its first word, whose
address is written as the code computes it. -/
theorem wordsAt_index (p i x : Word) (xs : List Word) :
    (Atom.prop (wordsAt (p + i * 8#64) (x :: xs))).interp =
      Atoms.interp [.mem (p + @HMul.hMul Word Word Word instHMul i 8#64) 8 x true,
        .prop (wordsAt (p + (i + 1#64) * 8#64) xs)] := by
  have e : p + i * 8#64 + 8#64 = p + (i + 1#64) * 8#64 := by
    rw [BitVec.add_mul, BitVec.add_assoc]; rfl
  rw [wordsAt_cons, e]

/-- The carry the code computes in a round, from the carry flags of its two additions, each
set in the low byte of a register and the two then combined, is `carryOut`. -/
theorem carry_eq (a b c t9 t10 : Word) :
    BitVec.setWidth 64 (BitVec.setWidth 8
      ((t10 &&& 0xffffffffffffff00#64 ||| ofBool (BitVec.ult (b + (a + c)) b)) &&&
          0xffffffffffffff00#64 |||
        (BitVec.setWidth 64 (BitVec.setWidth 8
            (t10 &&& 0xffffffffffffff00#64 ||| ofBool (BitVec.ult (b + (a + c)) b))) |||
          BitVec.setWidth 64 (BitVec.setWidth 8
            (t9 &&& 0xffffffffffffff00#64 ||| ofBool (BitVec.ult (a + c) a)))))) =
      carryOut a b c := by
  unfold carryOut ofBool
  bv_auto

/-- The sum the code computes in a round is that of `addLimbs`. -/
theorem sum_eq (a b c : Word) : b + (a + c) = a + c + b := by
  bv_auto

/-- Forget the values of the six status flags, of which those the last instruction leaves
undefined hold no value already. -/
local macro "forget_flags" : tactic =>
  `(tactic| (try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 3
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-- The loop of `add_limbs`, at index `i`: add the limbs `a :: as` and `b :: bs` and the
carry `c`, and store the sum over `r0 :: rs`. -/
theorem add_limbs_loop (pr pa pb n sp r : Word) : ∀ (as bs rs : List Word) (a b r0 : Word)
    (i c t9 t10 : Word) (fc fp fa fz fs fo : Bool), bs.length = as.length →
    rs.length = as.length → i + BitVec.ofNat 64 (as.length + 1) = n →
    i.toNat + as.length + 1 < 2 ^ 64 →
    Triple add_limbs.program
      (Atoms.interp [.pc 0x401010#64, .reg rax c, .reg rcx n, .reg rdx pb, .reg rsi pa,
        .reg rdi pr, .reg r8 i, .reg r9 t9, .reg r10 t10, .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (wordsAt (pa + i * 8#64) (a :: as)), .prop (wordsAt (pb + i * 8#64) (b :: bs)),
        .prop (wordsAt (pr + i * 8#64) (r0 :: rs))])
      (Atoms.interp [.pc r, .reg rax (addLimbs (a :: as) (b :: bs) c).2, .reg rcx n,
        .reg rdx pb, .reg rsi pa, .reg rdi pr, .prop (regAny r8), .prop (regAny r9),
        .prop (regAny r10), .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (wordsAt (pa + i * 8#64) (a :: as)), .prop (wordsAt (pb + i * 8#64) (b :: bs)),
        .prop (wordsAt (pr + i * 8#64) (addLimbs (a :: as) (b :: bs) c).1)]) := by
  intro as
  induction as with
  | nil =>
    intro bs rs a b r0 i c t9 t10 fc fp fa fz fs fo hlb hlr he hb
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
      braid_done
  | cons a' as ih =>
    intro bs rs a b r0 i c t9 t10 fc fp fa fz fs fo hlb hlr he hb
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
      braid_call ih bs' rs' a' b' r' (i + 1#64) (carryOut a b c) _ _ _ _ _ _ _ _
        (by omega) (by omega) (by rw [← he]; bv_omega) (by bv_omega)
      braid_fold wordsAt_index pa i a (a' :: as)
      braid_fold wordsAt_index pb i b (b' :: bs')
      braid_fold wordsAt_index pr i (a + c + b)
        (addLimbs (a' :: as) (b' :: bs') (carryOut a b c)).1
      rw [addLimbs_cons a b c]
      braid_done
    · exfalso
      have : n - (i + 1#64) ≠ 0#64 := by rw [← he]; bv_omega
      exact this hbr

/-- `add_limbs` adds the `n` limbs its second and third arguments point to, stores the
limbs of the sum where its first argument points, and returns the carry out. The three
arrays are separate. -/
theorem add_limbs_spec (pr pa pb sp r t0 t8 t9 t10 : Word) (as bs rs : List Word)
    (fc fp fa fz fs fo : Bool) (hlb : bs.length = as.length) (hlr : rs.length = as.length)
    (hl : as.length < 2 ^ 64) :
    Triple add_limbs.program
      (Atoms.interp [.pc 0x401000#64, .reg rax t0, .reg rcx (BitVec.ofNat 64 as.length),
        .reg rdx pb, .reg rsi pa, .reg rdi pr, .reg r8 t8, .reg r9 t9, .reg r10 t10,
        .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (wordsAt pa as), .prop (wordsAt pb bs), .prop (wordsAt pr rs)])
      (Atoms.interp [.pc r, .reg rax (addLimbs as bs 0#64).2,
        .reg rcx (BitVec.ofNat 64 as.length), .reg rdx pb, .reg rsi pa, .reg rdi pr,
        .prop (regAny r8), .prop (regAny r9), .prop (regAny r10), .reg rsp (sp + 8#64),
        .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (wordsAt pa as), .prop (wordsAt pb bs),
        .prop (wordsAt pr (addLimbs as bs 0#64).1)]) := by
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
    have hloop := add_limbs_loop pr pa pb (BitVec.ofNat 64 (as.length + 1)) sp r as bs' rs'
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
      braid_call hloop _ _ _ _ _ _ _ _ (by omega) (by omega) trivial (by simpa using hl)
      braid_done

/-! ## On the machine -/

/-- A memory atom of a postcondition, read off the machine. -/
theorem hasBytes_of_holds {as : Atoms} {R : SProp} {σ : State} {m : MachineState}
    {a v : Word} {n : Nat} {w : Bool} (hr : Rel m σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.mem a n v w)) : HasBytes m a n v := by
  intro x hx
  have hc := Atoms.mem_of_holds h hat hx
  rw [hr.data.mem] at hc
  obtain ⟨b, hb, hc⟩ := memOf_eq_some hc
  rw [hb]
  simpa using (congrArg Cell.val hc).symm

/-- A word that starts at or beyond the end of an array, and ends before the array starts,
does not reach into it. -/
theorem sep_array {s p : Word} {l : Nat} (h : l ≤ (s - p).toNat ∧ 8 ≤ (p - s).toNat)
    (x : Word) (hx : (x - s).toNat < 8) : ¬ (x - p).toNat < l := by
  bv_omega

/-- **`add_limbs` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `add_limbs`, has the number of limbs `n` in `rcx` and `n` limbs in
memory at each of `rsi` (the limbs `as`), `rdx` (the limbs `bs`) and `rdi` (any limbs `rs`),
and has the return address `r` in the eight bytes at the stack pointer, the three arrays and
the return address apart from one another, reaches `r` on every run. Then the limbs `as` and
`bs` are where they were, and where `rdi` pointed there are `n` limbs `sum` which, with the
carry returned in `rax` above them, are the sum of the two numbers.

The destination may not overlap a source, nor one source the other: the three arrays are
three separate pieces of memory in the specification. (The code would also be right with
the destination equal to a source; that is another specification, with two arrays.) -/
theorem add_limbs_correct [Layout] (m : MachineState) (as bs rs : List Word) (r : Word)
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
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        (∀ (i : Nat) (hi : i < as.length),
          HasBytes m' (m.data.regs.get64 .rsi + BitVec.ofNat 64 (8 * i)) 8 as[i]) ∧
        (∀ (i : Nat) (hi : i < bs.length),
          HasBytes m' (m.data.regs.get64 .rdx + BitVec.ofNat 64 (8 * i)) 8 bs[i]) ∧
        ∃ sum : List Word, sum.length = as.length ∧
          (∀ (i : Nat) (hi : i < sum.length),
            HasBytes m' (m.data.regs.get64 .rdi + BitVec.ofNat 64 (8 * i)) 8 sum[i]) ∧
          limbsVal sum + 2 ^ (64 * as.length) * (m'.data.regs.get64 .rax).toNat =
            limbsVal as + limbsVal bs) m := by
  have h8 : 8 * as.length < 2 ^ 64 := by
    have : (m.data.regs.get64 .rsp - m.data.regs.get64 .rsi).toNat < 2 ^ 64 := BitVec.isLt _
    omega
  have hl : as.length < 2 ^ 64 := by omega
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat add_limbs_holds
    (add_limbs_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64 .rdx)
      (m.data.regs.get64 .rsp) r (m.data.regs.get64 .rax) (m.data.regs.get64 .r8)
      (m.data.regs.get64 .r9) (m.data.regs.get64 .r10) as bs rs m.data.status.cf
      m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of
      hlb hlr hl)
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
      (wordsAtoms_sat fun i hi => sat_mem_abs.2 (hr i hi))))
  rintro m' ⟨σ', hrel, hq⟩
  have hq' := holds_arrays (l := [.pc r, .reg rax (addLimbs as bs 0#64).2,
    .reg rcx (BitVec.ofNat 64 as.length), .reg rdx (m.data.regs.get64 .rdx),
    .reg rsi (m.data.regs.get64 .rsi), .reg rdi (m.data.regs.get64 .rdi),
    .prop (regAny r8), .prop (regAny r9), .prop (regAny r10),
    .reg rsp (m.data.regs.get64 .rsp + 8#64), .mem (m.data.regs.get64 .rsp) 8 r true,
    .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
    .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) hq
  refine ⟨?_, fun i hi => ?_, fun i hi => ?_, (addLimbs as bs 0#64).1,
    addLimbs_length as bs _ hlb.symm, fun i hi => ?_, ?_⟩
  · rw [← hrel.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · exact hasBytes_of_holds hrel hq' (at_of_mem (List.mem_append_right _
      (List.mem_append_left _ (mem_wordsAtoms.2 ⟨i, hi, rfl⟩))))
  · exact hasBytes_of_holds hrel hq' (at_of_mem (List.mem_append_right _
      (List.mem_append_right _ (List.mem_append_left _ (mem_wordsAtoms.2 ⟨i, hi, rfl⟩)))))
  · exact hasBytes_of_holds hrel hq' (at_of_mem (List.mem_append_right _
      (List.mem_append_right _ (List.mem_append_right _ (List.mem_append_left _
        (mem_wordsAtoms.2 ⟨i, hi, rfl⟩))))))
  · have h0 : m'.data.regs.get64 .rax = (addLimbs as bs 0#64).2 := by
      rw [← hrel.reg .rax]
      exact Atoms.reg_of_holds (r := 0) hq (by braid_at)
    rw [h0]
    simpa using addLimbs_val as bs 0#64 hlb.symm (by simp)

end Examples.Limbs.X86
