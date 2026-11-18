/-
  Examples.Bytes.X86.Proofs

  `bytes.c` on x86-64: a loop over the bytes of a string, with a byte comparison against
  memory and an index that starts at minus one.
-/

module

public import Examples.Bytes.X86.Image
public import Examples.Spec

public section

namespace Examples.Bytes.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- The loop of `str_len`: with `rax` one below the index, count the bytes up to the
terminating zero. -/
theorem str_len_loop (p s r : Word) : ∀ (suf : List (BitVec 8)) (j : Word)
    (c pf af z sg o : Bool), (∀ b ∈ suf, b ≠ 0#8) →
    Triple str_len.program
      (Atoms.interp [.pc 0x401010#64, .reg rdi p, .reg rax j,
        .prop (bytesAt (p + (j * 1#64 + 1#64)) (suf ++ [0#8])), .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi p, .reg rax (j + (1#64 + BitVec.ofNat 64 suf.length)),
        .prop (bytesAt (p + (j * 1#64 + 1#64)) (suf ++ [0#8])), .reg rsp (s + 8#64),
        .mem s 8 r true, .prop (flagAny Flags.cf), .prop (flagAny Flags.pf),
        .prop (flagAny Flags.af), .prop (flagAny Flags.zf), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) := by
  intro suf
  induction suf with
  | nil =>
    intro j c pf af z sg o _
    braid_unfold bytesAt_cons (p + (j * 1#64 + 1#64)) 0#8 []
    iterate 2 braid_step
    braid_run
    braid_fold bytesAt_cons (p + (j * 1#64 + 1#64)) 0#8 []
    x86_forget_flags
    simp only [List.length_nil]
    braid_done
  | cons b bs ih =>
    intro j c pf af z sg o hnz
    have hb : b ≠ 0#8 := hnz b List.mem_cons_self
    braid_unfold bytesAt_cons (p + (j * 1#64 + 1#64)) b (bs ++ [0#8])
    iterate 2 braid_step
    braid_step
    · have e : p + (j * 1#64 + 2#64) = p + ((j + 1#64) * 1#64 + 1#64) := by bv_decide
      rw [e]
      braid_call ih (j + 1#64) _ _ _ _ _ _ (fun c hc => hnz c (List.mem_cons_of_mem _ hc))
      rw [← e]
      braid_fold bytesAt_cons (p + (j * 1#64 + 1#64)) b (bs ++ [0#8])
      have e2 : j + (1#64 + (1#64 + BitVec.ofNat 64 bs.length)) =
          j + (1#64 + BitVec.ofNat 64 (bs.length + 1)) := by
        congr 2; bv_omega
      simp only [List.length_cons, e2]
      braid_done
    · exact absurd (by bv_decide) hb

/-- `str_len` returns the number of bytes before the first zero byte. -/
theorem str_len_spec (p t s r : Word) (str : List (BitVec 8)) (c pf af z sg o : Bool)
    (hnz : ∀ b ∈ str, b ≠ 0#8) :
    Triple str_len.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi p, .reg rax t,
        .prop (bytesAt p (str ++ [0#8])), .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi p, .reg rax (BitVec.ofNat 64 str.length),
        .prop (bytesAt p (str ++ [0#8])), .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  iterate 2 braid_step
  braid_call str_len_loop p s r str 0xffffffffffffffff#64 _ _ _ _ _ _ hnz
  refine Triple.done_eq ?_
  have e : 0xffffffffffffffff#64 + (1#64 + BitVec.ofNat 64 str.length) =
      BitVec.ofNat 64 str.length := by bv_omega
  simp [e]

/-- The loop of `fill`, at index `i`: store the byte up to index `n`. -/
theorem fill_loop (p n v s r : Word) : ∀ (bs : List (BitVec 8)) (b : BitVec 8) (i : Word)
    (c pf af z sg o : Bool), i + BitVec.ofNat 64 (bs.length + 1) = n →
    i.toNat + bs.length + 1 < 2 ^ 64 →
    Triple fill.program
      (Atoms.interp [.pc 0x401030#64, .reg rax i, .reg rdi p, .reg rsi n, .reg rdx v,
        .prop (bytesAt (p + i * 1#64) (b :: bs)), .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax n, .reg rdi p, .reg rsi n, .reg rdx v,
        .prop (bytesAt (p + i * 1#64) (List.replicate (bs.length + 1) (v.truncate 8))),
        .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  intro bs
  induction bs with
  | nil =>
    intro b i c pf af z sg o he hb
    have hn : n = i + 1#64 := by simpa using he.symm
    subst hn
    braid_unfold bytesAt_cons (p + i * 1#64) b []
    iterate 3 braid_step
    braid_step
    · exact absurd hbr (by simp)
    · braid_run
      braid_fold bytesAt_cons_store (p + i * 1#64) _ []
      x86_forget_flags
      simp only [List.length_nil, Nat.zero_add, List.replicate_one]
      braid_done
  | cons d ds ih =>
    intro b i c pf af z sg o he hb
    simp only [List.length_cons] at he hb
    braid_unfold bytesAt_cons (p + i * 1#64) b (d :: ds)
    iterate 3 braid_step
    braid_step
    · have e1 : p + (i * 1#64 + 1#64) = p + (i + 1#64) * 1#64 := by bv_decide
      rw [e1]
      braid_call ih d (i + 1#64) _ _ _ _ _ _ (by rw [← he]; bv_omega) (by bv_omega)
      rw [← e1]
      braid_fold bytesAt_cons_store (p + i * 1#64) _
        (List.replicate (ds.length + 1) (v.truncate 8))
      simp only [List.length_cons, List.replicate_succ]
      braid_done
    · exfalso
      have : n - (i + 1#64) ≠ 0#64 := by rw [← he]; bv_omega
      exact this (by simpa using hbr)

/-- `fill` stores the byte `v` in each of the `n` bytes its first argument points to. -/
theorem fill_spec (p v t s r : Word) (bs : List (BitVec 8)) (c pf af z sg o : Bool)
    (hl : bs.length < 2 ^ 64) :
    Triple fill.program
      (Atoms.interp [.pc 0x401020#64, .reg rax t, .reg rdi p,
        .reg rsi (BitVec.ofNat 64 bs.length), .reg rdx v, .prop (bytesAt p bs), .reg rsp s,
        .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .prop (regAny rax), .reg rdi p,
        .reg rsi (BitVec.ofNat 64 bs.length), .reg rdx v,
        .prop (bytesAt p (List.replicate bs.length (v.truncate 8))), .reg rsp (s + 8#64),
        .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  cases bs with
  | nil =>
    simp only [List.length_nil]
    braid_run
    braid_forget 0
    x86_forget_flags
    simp only [List.replicate_zero]
    braid_done
  | cons b bs =>
    simp only [List.length_cons] at hl ⊢
    iterate 1 braid_step
    braid_step
    · exfalso
      have : BitVec.ofNat 64 (bs.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · iterate 2 braid_step
      simp only [BitVec.xor_self]
      braid_call fill_loop p (BitVec.ofNat 64 (bs.length + 1)) v s r bs b 0#64 _ _ _ _ _ _
        (by simp) (by simp; omega)
      braid_forget 0
      braid_done

/-- The loop of `count_ones`: add the ones of `x` to the count. -/
theorem count_ones_loop (s r : Word) (k : Nat) : ∀ (x cnt t : Word) (c pf af z sg o : Bool),
    x.toNat = k → x ≠ 0#64 →
    Triple count_ones.program
      (Atoms.interp [.pc 0x401050#64, .reg rdi x, .reg rax cnt, .reg rcx t, .reg rsp s,
        .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .prop (regAny rdi), .reg rax (cnt + BitVec.ofNat 64 (ones x.toNat)),
        .prop (regAny rcx), .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  induction k using Nat.strongRecOn with
  | ind k ih =>
    intro x cnt t c pf af z sg o hk hx
    have hpos : x.toNat ≠ 0 := fun h => hx (BitVec.eq_of_toNat_eq h)
    have hstep : cnt + BitVec.ofNat 64 (ones x.toNat) =
        (x &&& 1#64) + cnt + BitVec.ofNat 64 (ones (x >>> 1).toNat) := by
      rw [ones_pos hpos, BitVec.add_comm (x &&& 1#64) cnt, BitVec.add_assoc]
      congr 1
      have h1 : (x &&& 1#64).toNat = x.toNat % 2 := by
        rw [BitVec.toNat_and]; exact Nat.and_two_pow_sub_one_eq_mod x.toNat 1
      have h2 : (x >>> 1).toNat = x.toNat / 2 := by
        rw [BitVec.toNat_ushiftRight]; exact Nat.shiftRight_eq_div_pow x.toNat 1
      apply BitVec.eq_of_toNat_eq
      rw [BitVec.toNat_add, h1, h2]
      simp
    have e1 : x >>> 1#64 = x >>> 1 := rfl
    have e2 : BitVec.setWidth 64 (BitVec.setWidth 32 x) &&& 1#64 = x &&& 1#64 := by bv_decide
    iterate 4 braid_step
    simp only [e1, e2]
    braid_step
    · have hne : x >>> 1 ≠ 0#64 := by simpa using hbr
      braid_call ih _ (by
        rw [← hk, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]; omega)
        (x >>> 1) _ _ _ _ _ _ _ _ rfl hne
      rw [hstep]
      braid_done
    · have h0 : (x >>> 1).toNat = 0 := by
        have := congrArg BitVec.toNat (show x >>> 1 = 0#64 by simpa using hbr)
        simpa using this
      braid_run
      braid_forget 5
      braid_forget 2
      x86_forget_flags
      refine Triple.done_eq ?_
      rw [hstep, h0]
      simp [ones_zero]

/-- `count_ones` returns the number of ones in the binary form of its argument. -/
theorem count_ones_spec (x t0 t2 s r : Word) (c pf af z sg o : Bool) :
    Triple count_ones.program
      (Atoms.interp [.pc 0x401040#64, .reg rdi x, .reg rax t0, .reg rcx t2, .reg rsp s,
        .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .prop (regAny rdi), .reg rax (BitVec.ofNat 64 (ones x.toNat)),
        .prop (regAny rcx), .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  iterate 2 braid_step
  braid_step
  · have hx : x = 0#64 := by simpa using hbr
    subst hx
    braid_run
    braid_forget 5
    braid_forget 2
    x86_forget_flags
    simp only [BitVec.xor_self]
    exact Triple.done_eq (by simp [ones_zero])
  · have hx : x ≠ 0#64 := by simpa using hbr
    braid_step
    simp only [BitVec.xor_self]
    braid_call count_ones_loop s r _ x 0#64 t2 _ _ _ _ _ _ rfl hx
    braid_done

end Examples.Bytes.X86
