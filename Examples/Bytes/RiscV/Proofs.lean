/-
  Examples.Bytes.RiscV.Proofs

  `bytes.c` on RISC-V: byte loads and stores, and loops whose invariants are about arrays of
  bytes and about the bits of a word.
-/

module

public import Examples.Bytes.RiscV.Image
public import Lowering.RiscV.Logic
public import Examples.Spec

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

end Examples.Bytes.RiscV
