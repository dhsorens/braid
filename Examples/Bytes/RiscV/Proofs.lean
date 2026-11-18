/-
  Examples.Bytes.RiscV.Proofs

  `bytes.c` on RISC-V: byte loads and stores, and loops whose invariants are about arrays of
  bytes and about the bits of a word.
-/

module

public import Examples.Bytes.RiscV.Image
public import Lowering.RiscV.Logic
public import Examples.Spec
public import Examples.Memory.RiscV.Proofs

public section

namespace Examples.Bytes.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- The loop of `str_len`: from index `i`, count the bytes up to the terminating zero. -/
theorem str_len_loop (p r : Word) : ∀ (suf : List (BitVec 8)) (i t : Word),
    (∀ b ∈ suf, b ≠ 0#8) →
    Triple str_len.program
      (Atoms.interp [.pc 0x10004#64, .reg a0 p, .reg a1 i, .reg a2 t,
        .prop (bytesAt (p + i) (suf ++ [0#8])), .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (i + BitVec.ofNat 64 suf.length),
        .prop (regAny a1), .prop (regAny a2), .prop (bytesAt (p + i) (suf ++ [0#8])),
        .reg ra r]) := by
  intro suf
  induction suf with
  | nil =>
    intro i t _
    braid_unfold bytesAt_cons (p + i) 0#8 []
    iterate 3 braid_step
    braid_step
    braid_run
    braid_fold bytesAt_cons (p + i) 0#8 []
    braid_forget 11
    braid_forget 12
    simp only [List.length_nil]
    braid_done
  | cons b bs ih =>
    intro i t hnz
    have hb : b ≠ 0#8 := hnz b List.mem_cons_self
    braid_unfold bytesAt_cons (p + i) b (bs ++ [0#8])
    iterate 3 braid_step
    braid_step
    · braid_call ih (i + 1#64) _ (fun c hc => hnz c (List.mem_cons_of_mem _ hc))
      braid_fold bytesAt_cons (p + i) b (bs ++ [0#8])
      have e : i + (1#64 + BitVec.ofNat 64 bs.length) = i + BitVec.ofNat 64 (bs.length + 1) := by
        congr 1; bv_omega
      simp only [List.length_cons, e]
      braid_done
    · exact absurd (by bv_decide) hb

/-- `str_len` returns the number of bytes before the first zero byte. -/
theorem str_len_spec (p r t1 t2 : Word) (s : List (BitVec 8)) (hnz : ∀ b ∈ s, b ≠ 0#8) :
    Triple str_len.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 p, .reg a1 t1, .reg a2 t2,
        .prop (bytesAt p (s ++ [0#8])), .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (BitVec.ofNat 64 s.length),
        .prop (regAny a1), .prop (regAny a2), .prop (bytesAt p (s ++ [0#8])), .reg ra r]) := by
  braid_step
  braid_call str_len_loop p r s 0#64 t2 hnz
  braid_done

/-- The loop of `count_ones`: add the ones of `x` to the count. -/
theorem count_ones_loop (r : Word) (k : Nat) : ∀ x c t : Word, x.toNat = k → x ≠ 0#64 →
    Triple count_ones.program
      (Atoms.interp [.pc 0x1003c#64, .reg a0 x, .reg a1 c, .reg a2 t, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (c + BitVec.ofNat 64 (ones x.toNat)),
        .prop (regAny a1), .prop (regAny a2), .reg ra r]) := by
  induction k using Nat.strongRecOn with
  | ind k ih =>
    intro x c t hk hx
    have hpos : x.toNat ≠ 0 := fun h => hx (BitVec.eq_of_toNat_eq h)
    have hstep : c + BitVec.ofNat 64 (ones x.toNat) =
        c + (x &&& 1#64) + BitVec.ofNat 64 (ones (x >>> 1).toNat) := by
      rw [ones_pos hpos, BitVec.add_assoc]
      congr 1
      have h1 : (x &&& 1#64).toNat = x.toNat % 2 := by
        rw [BitVec.toNat_and]; exact Nat.and_two_pow_sub_one_eq_mod x.toNat 1
      have h2 : (x >>> 1).toNat = x.toNat / 2 := by
        rw [BitVec.toNat_ushiftRight]; exact Nat.shiftRight_eq_div_pow x.toNat 1
      apply BitVec.eq_of_toNat_eq
      rw [BitVec.toNat_add, h1, h2]
      simp
    iterate 3 braid_step
    braid_step
    · refine (ih _ ?_ (x >>> 1) (c + (x &&& 1#64)) _ rfl hbr).cast rfl (by rw [hstep]; simp)
      rw [← hk, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
      omega
    · braid_run
      braid_forget 11
      braid_forget 12
      have h0 : (x >>> 1).toNat = 0 := by
        have := congrArg BitVec.toNat hbr
        simpa using this
      refine Triple.done_eq ?_
      rw [hstep, h0]
      simp [ones_zero]

/-- `count_ones` returns the number of ones in the binary form of its argument. -/
theorem count_ones_spec (x t1 t2 r : Word) :
    Triple count_ones.program
      (Atoms.interp [.pc 0x10034#64, .reg a0 x, .reg a1 t1, .reg a2 t2, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (BitVec.ofNat 64 (ones x.toNat)),
        .prop (regAny a1), .prop (regAny a2), .reg ra r]) := by
  braid_step
  braid_step
  · subst hbr
    braid_run
    braid_forget 11
    braid_forget 12
    exact Triple.done_eq (by simp [ones_zero])
  · braid_call count_ones_loop r _ x 0#64 t2 rfl hbr
    braid_done

/-- **`count_ones` on the machine.** -/
theorem count_ones_correct (s : MachineState)
    (hcode : ∀ p ∈ count_ones_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10034#64) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 = BitVec.ofNat 64 (ones (s.getReg .x10).toNat) := by
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound count_ones_lowered
    (count_ones_spec (s.getReg .x10) (s.getReg .x11) (s.getReg .x12) (s.getReg .x1)) hcode
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc])
  refine ⟨n, s', hn, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]
    exact Atoms.reg_of_holds (r := 10) hq (by braid_at)

/-- The loop of `fill`: store the byte from `q` up to the end `e`. -/
theorem fill_loop (e v r : Word) : ∀ (bs : List (BitVec 8)) (b : BitVec 8) (q : Word),
    q + BitVec.ofNat 64 (bs.length + 1) = e → bs.length + 1 < 2 ^ 64 →
    Triple fill.program
      (Atoms.interp [.pc 0x10024#64, .reg a0 q, .reg a1 e, .reg a2 v,
        .prop (bytesAt q (b :: bs)), .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 e, .reg a1 e, .reg a2 v,
        .prop (bytesAt q (List.replicate (bs.length + 1) (v.truncate 8))), .reg ra r]) := by
  intro bs
  induction bs with
  | nil =>
    intro b q he hb
    have he' : e = q + 1#64 := by simpa using he.symm
    subst he'
    braid_unfold bytesAt_cons q b []
    braid_run
    braid_fold bytesAt_cons_store q v []
    simp only [List.length_nil, Nat.zero_add, List.replicate_one]
    braid_done
  | cons c cs ih =>
    intro b q he hb
    simp only [List.length_cons] at he hb
    braid_unfold bytesAt_cons q b (c :: cs)
    iterate 2 braid_step
    braid_step
    · braid_call ih c (q + 1#64) (by rw [← he]; bv_omega) (by omega)
      braid_fold bytesAt_cons_store q v (List.replicate (cs.length + 1) (v.truncate 8))
      simp only [List.length_cons, List.replicate_succ]
      braid_done
    · exfalso
      have : q + 1#64 ≠ e := by rw [← he]; bv_omega
      exact this (by simpa using hbr)

/-- `fill` stores the byte `v` in each of the `n` bytes its first argument points to. -/
theorem fill_spec (p v r : Word) (bs : List (BitVec 8)) (hl : bs.length < 2 ^ 64) :
    Triple fill.program
      (Atoms.interp [.pc 0x1001c#64, .reg a0 p, .reg a1 (BitVec.ofNat 64 bs.length), .reg a2 v,
        .prop (bytesAt p bs), .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .prop (regAny a0), .prop (regAny a1), .reg a2 v,
        .prop (bytesAt p (List.replicate bs.length (v.truncate 8))), .reg ra r]) := by
  cases bs with
  | nil =>
    simp only [List.length_nil]
    braid_run
    braid_forget 10
    braid_forget 11
    simp only [List.replicate_zero]
    braid_done
  | cons b bs =>
    simp only [List.length_cons] at hl ⊢
    braid_step
    · exfalso
      have : BitVec.ofNat 64 (bs.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · braid_step
      braid_call fill_loop _ v r bs b p rfl hl
      braid_forget 10
      braid_forget 11
      braid_done

/-- The byte a machine has at an address is the low byte of the word it has there. -/
theorem getByte_of_hasBytes {s : MachineState} {a v : Word} (h : HasBytes s a 1 v) :
    s.getByte a = v.truncate 8 := by
  have := (h a (by simp)).2
  simpa using this

/-- Only the low byte of a word matters to a machine that has one byte of it. -/
theorem hasBytes_one_of_truncate {s : MachineState} {a v : Word}
    (h : HasBytes s a 1 ((v.truncate 8).zeroExtend 64)) : HasBytes s a 1 v := by
  intro x hx
  obtain ⟨hv, hb⟩ := h x hx
  refine ⟨hv, hb.trans ?_⟩
  have e : x - a = 0#64 := by bv_omega
  rw [e]
  bv_decide

/-- **`str_len` on the machine.** A machine that holds the code of `str_len`, is at its
entry, and has in memory where `a0` points the bytes `bs`, none of them zero, and then a zero
byte, runs to the return address with the number of the bytes in `a0`. -/
theorem str_len_correct (s : MachineState) (bs : List (BitVec 8))
    (hcode : ∀ p ∈ str_len_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hnz : ∀ b ∈ bs, b ≠ 0#8)
    (hmem : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.getReg .x10 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64))
    (hend : HasBytes s (s.getReg .x10 + BitVec.ofNat 64 bs.length) 1 0#64) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 = BitVec.ofNat 64 bs.length := by
  have hlen : bs.length < 2 ^ 64 := by
    refine Nat.lt_of_not_le fun hge => ?_
    have hi : bs.length - 2 ^ 64 < bs.length := by omega
    have e : BitVec.ofNat 64 (bs.length - 2 ^ 64) = BitVec.ofNat 64 bs.length := by
      apply BitVec.eq_of_toNat_eq
      simp only [BitVec.toNat_ofNat]
      omega
    have h1 := getByte_of_hasBytes (hmem _ hi)
    rw [e, getByte_of_hasBytes hend] at h1
    exact hnz _ (List.getElem_mem hi) (by simpa using h1.symm)
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound_flat str_len_lowered
    (str_len_spec (s.getReg .x10) (s.getReg .x1) (s.getReg .x11) (s.getReg .x12) bs hnz) hcode
    (flat := [.pc 0x10000#64, .reg a0 (s.getReg .x10), .reg a1 (s.getReg .x11),
      .reg a2 (s.getReg .x12)] ++ bytesAtoms (s.getReg .x10) (bs ++ [0#8]) ++
      [.reg ra (s.getReg .x1)])
    (by rw [bytesAt_eq_interp]
        exact Atoms.interp_flatten [.pc 0x10000#64, .reg a0 (s.getReg .x10),
          .reg a1 (s.getReg .x11), .reg a2 (s.getReg .x12)] [.reg ra (s.getReg .x1)] _)
    (Atoms.forall_flat (by simp [Atom.IsPointsTo]) bytesAtoms_isPointsTo)
    (Atoms.pairwise_flat (by braid_disj)
      (bytesAtoms_pairwise (by simp only [List.length_append, List.length_singleton]; omega))
      (by braid_disj_array))
    (Atoms.forall_flat (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc])
      (bytesAtoms_sat fun i hi => sat_mem_abs.2 (by
        by_cases h : i < bs.length
        · rw [List.getElem_append_left h]; exact hmem i h
        · have hi' : i = bs.length := by
            simp only [List.length_append, List.length_singleton] at hi; omega
          subst hi'
          simpa using hend)))
  refine ⟨n, s', hn, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]
    exact Atoms.reg_of_holds (r := 10) hq (by braid_at)

/-- **`fill` on the machine.** A machine that holds the code of `fill`, is at its entry, and
has the bytes `bs` in memory where `a0` points, with their number in `a1`, runs to the return
address with the low byte of `a2` in each of those places. -/
theorem fill_correct (s : MachineState) (bs : List (BitVec 8))
    (hcode : ∀ p ∈ fill_code, s.code p.1 = some p.2) (hpc : s.pc = 0x1001c#64)
    (hl : bs.length < 2 ^ 64) (hn : s.getReg .x11 = BitVec.ofNat 64 bs.length)
    (hmem : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.getReg .x10 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64)) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      ∀ i, i < bs.length →
        HasBytes s' (s.getReg .x10 + BitVec.ofNat 64 i) 1 (s.getReg .x12) := by
  obtain ⟨n, s', σ', hn', hr, hq⟩ := machine_sound_flat fill_lowered
    (fill_spec (s.getReg .x10) (s.getReg .x12) (s.getReg .x1) bs hl) hcode
    (flat := [.pc 0x1001c#64, .reg a0 (s.getReg .x10), .reg a1 (BitVec.ofNat 64 bs.length),
      .reg a2 (s.getReg .x12)] ++ bytesAtoms (s.getReg .x10) bs ++ [.reg ra (s.getReg .x1)])
    (by rw [bytesAt_eq_interp]
        exact Atoms.interp_flatten [.pc 0x1001c#64, .reg a0 (s.getReg .x10),
          .reg a1 (BitVec.ofNat 64 bs.length), .reg a2 (s.getReg .x12)]
          [.reg ra (s.getReg .x1)] _)
    (Atoms.forall_flat (by simp [Atom.IsPointsTo]) bytesAtoms_isPointsTo)
    (Atoms.pairwise_flat (by braid_disj) (bytesAtoms_pairwise (by omega))
      (by braid_disj_array))
    (Atoms.forall_flat (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, hn])
      (bytesAtoms_sat fun i hi => sat_mem_abs.2 (hmem i hi)))
  refine ⟨n, s', hn', ?_, fun i hi => ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · have h := hasBytes_of_holds_bytes
      (l₁ := [.pc (s.getReg .x1 &&& ~~~1#64), .prop (regAny a0), .prop (regAny a1),
        .reg a2 (s.getReg .x12)]) hr hq i (by simpa using hi)
    rw [List.getElem_replicate] at h
    exact hasBytes_one_of_truncate h

end Examples.Bytes.RiscV
