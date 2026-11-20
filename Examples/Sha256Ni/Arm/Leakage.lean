/-
  Examples.Sha256Ni.Arm.Leakage

  What `sha256_compress_ni` reveals on AArch64, about the machine alone
  (`docs/Leakage.md`). The traced triple is `compress_ni_run` of
  `Examples.Sha256Ni.Arm.LeakCompress`, whose trace the run found; here it is carried to the
  machine model, and the two-run statement is drawn from it.

  The code neither branches nor indexes on the hash value or on the block: its two loops run
  twelve times and four times, the table of round constants is read at offsets that are the
  count of a loop, and every other address is an offset from one of the two pointers. It has
  no frame. So the public inputs are the two pointers and the return address, and the hash
  value and the block are secret, as is whatever the other registers hold.

  ## Main results

  * `sha256_compress_ni_leakage`: the trace of the run is `compressNiLeak` of the public
    inputs
  * `sha256_compress_ni_leakage_eq`: two machines that agree on the public inputs run with
    the same trace, whatever the hash value and the block of each are
-/

module

public import Examples.Sha256Ni.Arm.Proofs
public import Examples.Sha256Ni.Arm.LeakCompress

public section

namespace Examples.Sha256Ni.Arm

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.Arm Lowering.Arm.Regs
open Examples.Sha256.Arm (HasCells HasReadOnlyCells)

/-- **What `sha256_compress_ni` reveals, on the machine.** A machine under the hypotheses of
`sha256_compress_ni_correct` (it is running, its program holds the words of
`sha256_compress_ni`, its code is loaded and its program counter is at the entry; it has the
hash value `H`, eight words, in memory where `x0` points, the block `M`, sixteen words, where
`x1` points, and the round constants of SHA-256 in read-only memory at `0x20228`, where the
code looks for them; the hash value and the block are apart) runs to the address in the link
register with the trace `compressNiLeak` of `x0`, `x1` and the link register, which
`compressNiLeak_eq` writes out. Neither the hash value nor the block is in the trace: the
compiled code has no branch and no address that depends on them. -/
theorem sha256_compress_ni_leakage (prog : Arm64.Program) (s : Arm64.State) (H M : List W32)
    (hw : prog.hasWords 0x100bc#64 sha256_compress_ni_words)
    (hc : prog.CodeLoaded s.mem) (hrun : s.status = .Running) (hpc : s.pc = 0x100bc#64)
    (hH : H.length = 8) (hM : M.length = 16)
    (hh : HasCells s (s.regs.read 0#5) H) (hm : HasCells s (s.regs.read 1#5) M)
    (hk : HasReadOnlyCells s 0x20228#64 K)
    (hhm : Apart (s.regs.read 0#5) 32 (s.regs.read 1#5) 64) :
    ∃ s', RunL prog s
        (compressNiLeak (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5)) s' ∧
      s'.pc = s.regs.read 30#5 := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_soundT sha256_compress_ni_lowered
    (sha256_compress_ni_trace (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5) H M
      true (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5)
      (regOf s (vlo 0)) (regOf s (vhi 0)) (regOf s (vlo 1)) (regOf s (vhi 1))
      (regOf s (vlo 2)) (regOf s (vhi 2)) (regOf s (vlo 3)) (regOf s (vhi 3))
      (regOf s (vlo 4)) (regOf s (vhi 4)) (regOf s (vlo 5)) (regOf s (vhi 5))
      (regOf s (vlo 6)) (regOf s (vhi 6)) (regOf s (vlo 7)) (regOf s (vhi 7))
      (regOf s (vlo 16)) (regOf s (vhi 16)) (regOf s (vlo 17)) (regOf s (vhi 17))
      (regOf s (vlo 18)) (regOf s (vhi 18)) (regOf s (vlo 19)) (regOf s (vhi 19))
      s.pstate.n s.pstate.z s.pstate.c s.pstate.v hH hM []) hw hc hrun
    (flat := entryFlat s H M)
    (Flat.interp (by unfold entryFlat entryRegs; braid_flat))
    (entryFlat_pointsTo s H M) (entryFlat_disj s H M hH hM hh hm hk hhm)
    (entryFlat_sat s H M hpc hh hm hk)
  rw [List.nil_append] at hsteps
  refine ⟨s', hsteps, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`sha256_compress_ni` reveals nothing of the hash value or the block.** Two machines
that each satisfy the hypotheses of `sha256_compress_ni_leakage`, with hash values `H₁` and
`H₂` and blocks `M₁` and `M₂`, and that agree on the two pointers `x0` and `x1` and on the
link register, run with the same trace, whatever their other registers hold. That the hash
value and the block are apart is asked of the first machine, and holds of the second as the
two agree on the pointers. -/
theorem sha256_compress_ni_leakage_eq (prog₁ prog₂ : Arm64.Program) (s₁ s₂ : Arm64.State)
    (H₁ M₁ H₂ M₂ : List W32)
    (hw₁ : prog₁.hasWords 0x100bc#64 sha256_compress_ni_words)
    (hc₁ : prog₁.CodeLoaded s₁.mem)
    (hw₂ : prog₂.hasWords 0x100bc#64 sha256_compress_ni_words)
    (hc₂ : prog₂.CodeLoaded s₂.mem)
    (hrun₁ : s₁.status = .Running) (hrun₂ : s₂.status = .Running)
    (hpc₁ : s₁.pc = 0x100bc#64) (hpc₂ : s₂.pc = 0x100bc#64)
    (hH₁ : H₁.length = 8) (hM₁ : M₁.length = 16) (hH₂ : H₂.length = 8) (hM₂ : M₂.length = 16)
    (hh₁ : HasCells s₁ (s₁.regs.read 0#5) H₁) (hm₁ : HasCells s₁ (s₁.regs.read 1#5) M₁)
    (hk₁ : HasReadOnlyCells s₁ 0x20228#64 K)
    (hh₂ : HasCells s₂ (s₂.regs.read 0#5) H₂) (hm₂ : HasCells s₂ (s₂.regs.read 1#5) M₂)
    (hk₂ : HasReadOnlyCells s₂ 0x20228#64 K)
    (hhm : Apart (s₁.regs.read 0#5) 32 (s₁.regs.read 1#5) 64)
    (e0 : s₂.regs.read 0#5 = s₁.regs.read 0#5) (e1 : s₂.regs.read 1#5 = s₁.regs.read 1#5)
    (e30 : s₂.regs.read 30#5 = s₁.regs.read 30#5) :
    ∃ tr s₁' s₂', RunL prog₁ s₁ tr s₁' ∧ RunL prog₂ s₂ tr s₂' ∧
      s₁'.pc = s₁.regs.read 30#5 ∧ s₂'.pc = s₁.regs.read 30#5 := by
  obtain ⟨s₁', h₁, hp₁⟩ := sha256_compress_ni_leakage prog₁ s₁ H₁ M₁ hw₁ hc₁ hrun₁ hpc₁ hH₁
    hM₁ hh₁ hm₁ hk₁ hhm
  obtain ⟨s₂', h₂, hp₂⟩ := sha256_compress_ni_leakage prog₂ s₂ H₂ M₂ hw₂ hc₂ hrun₂ hpc₂ hH₂
    hM₂ hh₂ hm₂ hk₂ (by rw [e0, e1]; exact hhm)
  simp only [e0, e1, e30] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.Sha256Ni.Arm
