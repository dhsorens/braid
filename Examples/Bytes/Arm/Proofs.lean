/-
  Examples.Bytes.Arm.Proofs

  `bytes.c` on AArch64: a loop over the bytes of a string with a register-indexed byte load,
  and a loop over the bits of a word.
-/

module

public import Examples.Bytes.Arm.Image
public import Examples.Spec

public section

namespace Examples.Bytes.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- The loop of `str_len`: from index `i`, count the bytes up to the terminating zero. -/
theorem str_len_loop (p r : Word) : ∀ (suf : List (BitVec 8)) (i t : Word),
    (∀ b ∈ suf, b ≠ 0#8) →
    Triple str_len.program
      (Atoms.interp [.pc 0x10004#64, .reg x0 p, .reg x8 i, .reg x9 t,
        .prop (bytesAt (p + i) (suf ++ [0#8])), .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (i + BitVec.ofNat 64 suf.length),
        .prop (regAny x8), .prop (regAny x9), .prop (bytesAt (p + i) (suf ++ [0#8])),
        .reg lr r]) := by
  intro suf
  induction suf with
  | nil =>
    intro i t _
    braid_unfold bytesAt_cons (p + i) 0#8 []
    iterate 2 braid_step
    braid_run
    braid_fold bytesAt_cons (p + i) 0#8 []
    braid_forget 8
    braid_forget 9
    simp only [List.length_nil]
    braid_done
  | cons b bs ih =>
    intro i t hnz
    have hb : b ≠ 0#8 := hnz b List.mem_cons_self
    braid_unfold bytesAt_cons (p + i) b (bs ++ [0#8])
    iterate 2 braid_step
    braid_step
    · braid_call ih (i + 1#64) _ (fun c hc => hnz c (List.mem_cons_of_mem _ hc))
      braid_fold bytesAt_cons (p + i) b (bs ++ [0#8])
      have e : i + (1#64 + BitVec.ofNat 64 bs.length) = i + BitVec.ofNat 64 (bs.length + 1) := by
        congr 1; bv_omega
      simp only [List.length_cons, e]
      braid_done
    · exact absurd (by bv_decide) hb

/-- `str_len` returns the number of bytes before the first zero byte. -/
theorem str_len_spec (p r t8 t9 : Word) (s : List (BitVec 8)) (hnz : ∀ b ∈ s, b ≠ 0#8) :
    Triple str_len.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 p, .reg x8 t8, .reg x9 t9,
        .prop (bytesAt p (s ++ [0#8])), .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (BitVec.ofNat 64 s.length),
        .prop (regAny x8), .prop (regAny x9), .prop (bytesAt p (s ++ [0#8])), .reg lr r]) := by
  braid_step
  braid_call str_len_loop p r s 0#64 t9 hnz
  braid_done

/-- The loop of `count_ones`: add the ones of `x` to the count. -/
theorem count_ones_loop (r : Word) (k : Nat) : ∀ x c t : Word, x.toNat = k → x ≠ 0#64 →
    Triple count_ones.program
      (Atoms.interp [.pc 0x10034#64, .reg x0 x, .reg x8 c, .reg x9 t, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (c + BitVec.ofNat 64 (ones x.toNat)),
        .prop (regAny x8), .prop (regAny x9), .reg lr r]) := by
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
    have e1 : x >>> 1#64 = x >>> 1 := rfl
    iterate 3 braid_step
    simp only [e1]
    braid_step
    · refine (ih _ ?_ (x >>> 1) (c + (x &&& 1#64)) _ rfl hbr).cast rfl (by rw [hstep])
      rw [← hk, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
      omega
    · braid_run
      braid_forget 8
      braid_forget 9
      have h0 : (x >>> 1).toNat = 0 := by
        have := congrArg BitVec.toNat hbr
        simpa using this
      refine Triple.done_eq ?_
      rw [hstep, h0]
      simp [ones_zero]

/-- `count_ones` returns the number of ones in the binary form of its argument. -/
theorem count_ones_spec (x t8 t9 r : Word) :
    Triple count_ones.program
      (Atoms.interp [.pc 0x1002c#64, .reg x0 x, .reg x8 t8, .reg x9 t9, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (BitVec.ofNat 64 (ones x.toNat)),
        .prop (regAny x8), .prop (regAny x9), .reg lr r]) := by
  braid_step
  braid_step
  · braid_call count_ones_loop r _ x 0#64 t9 rfl hbr
    braid_done
  · subst hbr
    braid_run
    braid_forget 8
    braid_forget 9
    exact Triple.done_eq (by simp [ones_zero])

end Examples.Bytes.Arm
