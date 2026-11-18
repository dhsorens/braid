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

end Examples.Bytes.X86
