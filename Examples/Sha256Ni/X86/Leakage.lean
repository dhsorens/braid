/-
  Examples.Sha256Ni.X86.Leakage

  What `sha256_compress_ni` reveals on x86-64, about the machine alone
  (`docs/Leakage.md`). The traced triple is `compress_ni_run` of
  `Examples.Sha256Ni.X86.LeakCompress`, whose trace the run found; here it is carried to the
  machine model, and the two-run statement is drawn from it.

  The public inputs are the two pointers, the stack pointer and the return address. The hash
  value and the block are secret, as is whatever the registers hold.

  ## Main results

  * `sha256_compress_ni_leakage`: the trace of the run is `compressNiLeak` of the public
    inputs
  * `sha256_compress_ni_leakage_eq`: two machines that agree on the public inputs run with
    the same trace, whatever the hash value and the block are
-/

module

public import Examples.Sha256Ni.X86.Proofs
public import Examples.Sha256Ni.X86.LeakCompress

public section

namespace Examples.Sha256Ni.X86

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.X86 Lowering.X86.Regs
open Examples.Sha256.X86 (HasCells Apart)

/-- **What `sha256_compress_ni` reveals, on the machine.** A machine under the hypotheses of
`sha256_compress_ni_correct` (it runs the executable of this image and is at the entry of
`sha256_compress_ni`; it has the hash value `H`, eight words, in memory where `rdi` points,
the block `M`, sixteen words, where `rsi` points, the round constants of SHA-256 at
`0x402110`, where the code looks for them, and the return address `r` in the eight bytes at
the stack pointer; the hash value, the block, the round constants and the return address are
pairwise apart) reaches `r` on every run, and the trace of the run is `compressNiLeak` of
`rdi`, `rsi`, the stack pointer and `r`, which `compressNiLeak_eq` writes out. Neither the
hash value nor the block is in the trace: the compiled code has no branch and no address
that depends on them. -/
theorem sha256_compress_ni_leakage [Layout] (m : MachineState) (H M : List W32) (r : Word)
    (hpc : m.pc = 0x401000) (hH : H.length = 8) (hM : M.length = 16)
    (hh : HasCells m (m.data.regs.get64 .rdi) H) (hm : HasCells m (m.data.regs.get64 .rsi) M)
    (hk : HasCells m 0x402110#64 K) (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hhm : Apart (m.data.regs.get64 .rdi) 32 (m.data.regs.get64 .rsi) 64)
    (hhk : Apart (m.data.regs.get64 .rdi) 32 0x402110#64 256)
    (hhs : Apart (m.data.regs.get64 .rdi) 32 (m.data.regs.get64 .rsp) 8)
    (hmk : Apart (m.data.regs.get64 .rsi) 64 0x402110#64 256)
    (hms : Apart (m.data.regs.get64 .rsi) 64 (m.data.regs.get64 .rsp) 8)
    (hks : Apart 0x402110#64 256 (m.data.regs.get64 .rsp) 8) :
    RunL exe
      (fun m' u => u = compressNiLeak (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
        (m.data.regs.get64 .rsp) r ∧ m'.pc.toBitVec = r) m [] := by
  refine (machine_soundT sha256_compress_ni_holds
    ((compress_ni_run (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
      (m.data.regs.get64 .rsp) r).2 H M true true (m.data.regs.get64 .rax)
      (m.data.regs.get64 .rcx)
      (regOf m.data (zmm 0 0)) (regOf m.data (zmm 0 1)) (regOf m.data (zmm 1 0))
      (regOf m.data (zmm 1 1)) (regOf m.data (zmm 2 0)) (regOf m.data (zmm 2 1))
      (regOf m.data (zmm 3 0)) (regOf m.data (zmm 3 1)) (regOf m.data (zmm 4 0))
      (regOf m.data (zmm 4 1)) (regOf m.data (zmm 5 0)) (regOf m.data (zmm 5 1))
      (regOf m.data (zmm 6 0)) (regOf m.data (zmm 6 1)) (regOf m.data (zmm 7 0))
      (regOf m.data (zmm 7 1)) (regOf m.data (zmm 8 0)) (regOf m.data (zmm 8 1))
      (regOf m.data (zmm 9 0)) (regOf m.data (zmm 9 1))
      m.data.status.cf m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf
      m.data.status.of [] hH hM)
    (flat := entryFlat m H M r)
    (Flat.interp (by unfold entryFlat entryRegs; braid_flat))
    (entryFlat_pointsTo m H M r) (entryFlat_disj m H M r hH hM hhm hhk hhs hmk hms hks)
    (entryFlat_sat m H M r hpc hh hm hk hret)).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`sha256_compress_ni` reveals nothing of the hash value or the block.** Two machines
that each satisfy the hypotheses of `sha256_compress_ni_leakage`, with hash values `H₁` and
`H₂`, blocks `M₁` and `M₂` and the same return address `r` at the stack pointer, and that
agree on the two pointers `rdi` and `rsi` and on the stack pointer, have the same trace on
every run, whatever their other registers hold. The hypotheses that the regions are apart
are asked of the first machine, and hold of the second as the two agree on the addresses. -/
theorem sha256_compress_ni_leakage_eq [Layout] (m₁ m₂ : MachineState)
    (H₁ M₁ H₂ M₂ : List W32) (r : Word)
    (hpc₁ : m₁.pc = 0x401000) (hpc₂ : m₂.pc = 0x401000)
    (hH₁ : H₁.length = 8) (hM₁ : M₁.length = 16) (hH₂ : H₂.length = 8) (hM₂ : M₂.length = 16)
    (hh₁ : HasCells m₁ (m₁.data.regs.get64 .rdi) H₁)
    (hm₁ : HasCells m₁ (m₁.data.regs.get64 .rsi) M₁)
    (hk₁ : HasCells m₁ 0x402110#64 K)
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (hh₂ : HasCells m₂ (m₂.data.regs.get64 .rdi) H₂)
    (hm₂ : HasCells m₂ (m₂.data.regs.get64 .rsi) M₂)
    (hk₂ : HasCells m₂ 0x402110#64 K)
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hhm : Apart (m₁.data.regs.get64 .rdi) 32 (m₁.data.regs.get64 .rsi) 64)
    (hhk : Apart (m₁.data.regs.get64 .rdi) 32 0x402110#64 256)
    (hhs : Apart (m₁.data.regs.get64 .rdi) 32 (m₁.data.regs.get64 .rsp) 8)
    (hmk : Apart (m₁.data.regs.get64 .rsi) 64 0x402110#64 256)
    (hms : Apart (m₁.data.regs.get64 .rsi) 64 (m₁.data.regs.get64 .rsp) 8)
    (hks : Apart 0x402110#64 256 (m₁.data.regs.get64 .rsp) 8)
    (edi : m₂.data.regs.get64 .rdi = m₁.data.regs.get64 .rdi)
    (esi : m₂.data.regs.get64 .rsi = m₁.data.regs.get64 .rsi)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := sha256_compress_ni_leakage m₁ H₁ M₁ r hpc₁ hH₁ hM₁ hh₁ hm₁ hk₁ hret₁ hhm hhk hhs
    hmk hms hks
  have h₂ := sha256_compress_ni_leakage m₂ H₂ M₂ r hpc₂ hH₂ hM₂ hh₂ hm₂ hk₂ hret₂
    (by rw [edi, esi]; exact hhm) (by rw [edi]; exact hhk) (by rw [edi, esp]; exact hhs)
    (by rw [esi]; exact hmk) (by rw [esi, esp]; exact hms) (by rw [esp]; exact hks)
  rw [edi, esi, esp] at h₂
  exact ⟨_, h₁, h₂⟩

end Examples.Sha256Ni.X86
