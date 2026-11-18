/-
  Examples.GoBasic.X86.Proofs

  `basic.go` on x86-64, compiled by Go's own back end. Go passes arguments in `rax`, `rbx`
  and `rcx`, and returns in `rax`.
-/

module

public import Examples.GoBasic.X86.Image
public import Examples.Spec

public section

namespace Examples.GoBasic.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- `main.Add3` returns the sum of its arguments. -/
theorem main_Add3_spec (a b d t s r : Word) :
    Triple main_Add3.program
      (Atoms.interp [.pc 0x47a600#64, .reg rax a, .reg rbx b, .reg rcx d, .reg rdx t,
        .reg rsp s, .mem s 8 r true])
      (Atoms.interp [.pc r, .reg rax (d + (b + a)), .reg rbx b, .reg rcx d, .reg rdx (b + a),
        .reg rsp (s + 8#64), .mem s 8 r true]) := by
  braid_run
  refine Triple.done_eq ?_
  simp only [BitVec.mul_one]

/-- `main.MaxU64` returns the larger of its arguments. It branches, where the C compiler
uses a conditional move. -/
theorem main_MaxU64_spec (a b s r : Word) (c pf af z sg o : Bool) :
    Triple main_MaxU64.program
      (Atoms.interp [.pc 0x47a620#64, .reg rax a, .reg rbx b, .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (umax a b), .reg rbx b, .reg rsp (s + 8#64),
        .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_step
  braid_step
  all_goals
    braid_run
    x86_forget_flags
    refine Triple.done_eq ?_
    simp only [umax]
    by_cases h1 : b.ult a <;> simp_all

/-- After `cmp a, b`, the condition `g` is the signed comparison. -/
theorem cond_g (a b : Word) :
    ((ofBool (a - b &&& 9223372036854775808#64 != 0#64) ^^^
        ofBool ((a ^^^ b) &&& (a ^^^ a - b) &&& 9223372036854775808#64 != 0#64) |||
      ofBool (a - b == 0#64)) == 0#64) = b.slt a := by
  simp only [ofBool]
  bv_decide

theorem cond_g_iff (a b : Word) :
    (ofBool (a - b &&& 9223372036854775808#64 != 0#64) ^^^
        ofBool ((a ^^^ b) &&& (a ^^^ a - b) &&& 9223372036854775808#64 != 0#64) |||
      ofBool (a - b == 0#64) = 0#64) ↔ b.slt a = true := by
  rw [← cond_g a b, beq_iff_eq]

/-- The loop of `main.SumSlice`, from index `i`, with `rest` still to add. -/
theorem main_SumSlice_loop (p len s r : Word) : ∀ (rest : List Word) (i acc : Word)
    (c pf af z sg o : Bool), i + BitVec.ofNat 64 rest.length = len → len.toNat < 2 ^ 61 →
    i.toNat + rest.length < 2 ^ 61 →
    Triple main_SumSlice.program
      (Atoms.interp [.pc 0x47a652#64, .reg rax p, .reg rbx len, .reg rcx i, .reg rdx acc,
        .prop (wordsAt (p + i * 8#64) rest), .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (wsum rest acc), .reg rbx len, .reg rcx len,
        .reg rdx (wsum rest acc), .prop (wordsAt (p + i * 8#64) rest), .reg rsp (s + 8#64),
        .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  intro rest
  induction rest with
  | nil =>
    intro i acc c pf af z sg o he hlen hi
    have hil : i = len := by simpa using he
    subst hil
    braid_step
    braid_step
    · rw [cond_g_iff] at hbr
      exact absurd hbr (by simp [BitVec.slt])
    · braid_run
      x86_forget_flags
      simp only [wsum, List.foldl_nil]
      braid_done
  | cons x xs ih =>
    intro i acc c pf af z sg o he hlen hi
    simp only [List.length_cons] at he hi
    braid_step
    braid_step
    · braid_unfold wordsAt_cons (p + i * 8#64) x xs
      iterate 2 braid_step
      have e : p + (i * 8#64 + 8#64) = p + (i + 1#64) * 8#64 := by bv_decide
      rw [e]
      braid_call ih (i + 1#64) (x + acc) _ _ _ _ _ _ (by rw [← he]; bv_omega) hlen
        (by bv_omega)
      rw [← e]
      braid_fold wordsAt_cons (p + i * 8#64) x xs
      simp only [wsum, List.foldl_cons]
      braid_done
    · exfalso
      rw [cond_g_iff] at hbr
      have : i.slt len = true := by
        have h1 : i < len := by rw [← he]; bv_omega
        have h2 : len < 2305843009213693952#64 := by bv_omega
        bv_decide
      exact hbr this

end Examples.GoBasic.X86
