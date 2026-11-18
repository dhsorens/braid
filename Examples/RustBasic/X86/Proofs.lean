/-
  Examples.RustBasic.X86.Proofs

  `basic.rs` on x86-64: straight-line code, a conditional move, and a loop over a slice
  that walks a byte offset. `gcd` divides (`div`), which the machine model does not have.
-/

module

public import Examples.RustBasic.X86.Image
public import Examples.Spec

public section

namespace Examples.RustBasic.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- `add3` returns the sum of its arguments. It sets the flags. -/
theorem add3_spec (a b d t s r : Word) (c pf af z sg o : Bool) :
    Triple add3.program
      (Atoms.interp [.pc 0x401010#64, .reg rdi a, .reg rsi b, .reg rdx d, .reg rax t,
        .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi a, .reg rsi b, .reg rdx d, .reg rax (a + b + d),
        .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_run
  x86_forget_flags
  refine Triple.done_eq ?_
  have e : d + (a + b) = a + (b + d) := by bv_decide
  simp only [BitVec.mul_one, e]

/-- `max_u64` returns the larger of its arguments. It sets the flags. -/
theorem max_u64_spec (a b t s r : Word) (c pf af z sg o : Bool) :
    Triple max_u64.program
      (Atoms.interp [.pc 0x401050#64, .reg rdi a, .reg rsi b, .reg rax t, .reg rsp s,
        .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi a, .reg rsi b, .reg rax (umax a b), .reg rsp (s + 8#64),
        .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_run
  x86_forget_flags
  refine Triple.done_eq ?_
  simp only [umax, ofBool]
  by_cases h1 : a.ult b <;> by_cases h2 : a = b <;> simp_all
  all_goals bv_decide

/-- The loop of `sum_slice`, at byte offset `i`, with the words `x :: xs` still to add. -/
theorem sum_slice_loop (p e s r : Word) : ∀ (xs : List Word) (x i acc : Word)
    (c pf af z sg o : Bool), i + BitVec.ofNat 64 (8 * (xs.length + 1)) = e →
    i.toNat + 8 * (xs.length + 1) < 2 ^ 64 →
    Triple sum_slice.program
      (Atoms.interp [.pc 0x401070#64, .reg rax acc, .reg rcx i, .reg rdi p, .reg rsi e,
        .prop (wordsAt (p + i * 1#64) (x :: xs)), .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (wsum (x :: xs) acc), .reg rcx e, .reg rdi p, .reg rsi e,
        .prop (wordsAt (p + i * 1#64) (x :: xs)), .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  intro xs
  induction xs with
  | nil =>
    intro x i acc c pf af z sg o he hb
    have hn : e = i + 8#64 := by simpa using he.symm
    subst hn
    braid_unfold wordsAt_cons (p + i * 1#64) x []
    iterate 3 braid_step
    have e8 : 8#64 + i = i + 8#64 := by bv_decide
    braid_step
    · exact absurd (by bv_decide) hbr
    · braid_run
      braid_fold wordsAt_cons (p + i * 1#64) x []
      x86_forget_flags
      simp only [wsum, List.foldl_cons, List.foldl_nil, e8]
      braid_done
  | cons y ys ih =>
    intro x i acc c pf af z sg o he hb
    simp only [List.length_cons] at he hb
    braid_unfold wordsAt_cons (p + i * 1#64) x (y :: ys)
    iterate 3 braid_step
    braid_step
    · have e1 : p + (i * 1#64 + 8#64) = p + (8#64 + i) * 1#64 := by bv_decide
      rw [e1]
      braid_call ih y (8#64 + i) (x + acc) _ _ _ _ _ _ (by rw [← he]; bv_omega) (by bv_omega)
      rw [← e1]
      braid_fold wordsAt_cons (p + i * 1#64) x (y :: ys)
      simp only [wsum, List.foldl_cons]
      braid_done
    · exfalso
      have : e - (8#64 + i) ≠ 0#64 := by rw [← he]; bv_omega
      exact this (by simpa using hbr)

/-- `sum_slice` returns the sum of the words of a slice, given as a pointer and a length. -/
theorem sum_slice_spec (p t0 t1 s r : Word) (xs : List Word) (c pf af z sg o : Bool)
    (hl : xs.length < 2 ^ 61) :
    Triple sum_slice.program
      (Atoms.interp [.pc 0x401060#64, .reg rax t0, .reg rcx t1, .reg rdi p,
        .reg rsi (BitVec.ofNat 64 xs.length), .prop (wordsAt p xs), .reg rsp s,
        .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (wsum xs 0#64), .prop (regAny rcx), .reg rdi p,
        .prop (regAny rsi), .prop (wordsAt p xs), .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  cases xs with
  | nil =>
    simp only [List.length_nil]
    braid_run
    braid_forget 2
    braid_forget 4
    x86_forget_flags
    simp only [wsum, List.foldl_nil, BitVec.xor_self]
    braid_done
  | cons x xs =>
    simp only [List.length_cons] at hl ⊢
    braid_step
    braid_step
    · exfalso
      have : BitVec.ofNat 64 (xs.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · iterate 4 braid_step
      simp only [BitVec.xor_self]
      have he : 0#64 + BitVec.ofNat 64 (8 * (xs.length + 1)) =
          BitVec.ofNat 64 (xs.length + 1) <<< 3#64 := by
        apply BitVec.eq_of_toNat_eq
        simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
        omega
      braid_call sum_slice_loop p _ s r xs x 0#64 0#64 _ _ _ _ _ _ he (by simp; omega)
      braid_forget 2
      braid_forget 4
      braid_done

end Examples.RustBasic.X86
