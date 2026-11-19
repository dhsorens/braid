/-
  Examples.Sha256.O2.X86.LeakMachine

  What SHA-256, compiled at `-O2`, reveals on the x86-64 machine (`docs/Leakage.md`): the
  traced triples of `LeakRound`, `LeakSchedule` and `LeakCompress`, as theorems about the
  machine model alone. Each function has two. `<f>_leakage` says that the trace of the run is
  an explicit function of public inputs: the addresses the function is given, the stack
  pointer, and the return address, which on x86-64 is a word on the stack that `ret` loads
  and jumps to.
  `<f>_leakage_eq` says that two machines that agree on those inputs run with the same trace,
  whatever the working variables, the block, the hash value and the stack hold. No branch and
  no address of the compiled code depends on that data.

  The statements and proofs for `sha256_round` and `sha256_schedule` are those of
  `Examples.Sha256.X86.LeakMachine`, word for word, about the code of this binary. Those for
  `sha256_compress` follow `sha256_compress_correct` at `-O2`: the public inputs are those of
  `-O1`, and the hypotheses differ in the frame, which is 340 bytes with six saved registers
  and seven words of the hash value where it was 328 bytes with five saved registers and
  eight working variables, and in the address of the round constants.

  ## Main results

  * `sha256_round_leakage`, `sha256_round_leakage_eq`
  * `sha256_schedule_leakage`, `sha256_schedule_leakage_eq`
  * `sha256_compress_leakage`, `sha256_compress_leakage_eq`
-/

module

public import Examples.Sha256.O2.X86.LeakRound
public import Examples.Sha256.O2.X86.LeakSchedule
public import Examples.Sha256.O2.X86.LeakCompress

public section

namespace Examples.Sha256.O2.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs
open Examples.Sha256.X86

/-! ## The round -/

/-- **What `sha256_round` reveals, on the machine.** A machine under the hypotheses of
`sha256_round_correct` (it runs the executable of this image and is at the entry of
`sha256_round`; it has the eight working variables `v` in memory where `rdi` points, the
return address `r` in the eight bytes at the stack pointer, and two double words `sv` below
it, which the code overwrites; the working variables are apart from those 24 bytes of stack)
reaches `r` on every run, and the trace of the run is `roundLeak` of `rdi`, the stack pointer
and `r`. The round constant in `rsi` and the word of the schedule in `rdx` are not in the
trace, and neither are the working variables. -/
theorem sha256_round_leakage [Layout] (m : MachineState) (v : Vars) (sv : List Word) (r : Word)
    (hpc : m.pc = 0x401000) (hsv : sv.length = 2)
    (hv : HasCells m (m.data.regs.get64 .rdi) v.toList)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hstk : HasWords m ((m.data.regs.get64 .rsp) - 16#64) sv)
    (hsep : Apart (m.data.regs.get64 .rdi) 32 ((m.data.regs.get64 .rsp) - 16#64) 24) :
    RunL exe
      (fun m' u => u = roundLeak (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsp) r ∧
        m'.pc.toBitVec = r) m [] := by
  obtain ⟨hsep1, hsep2⟩ := hsep
  refine (machine_soundT sha256_round_holds
    (sha256_round_trace (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64 .rdx)
      (m.data.regs.get64 .rsp) r (m.data.regs.get64 .rbx) (m.data.regs.get64 .rbp) v sv
      (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx) (m.data.regs.get64 .r8) (m.data.regs.get64
        .r9)
      (m.data.regs.get64 .r10) (m.data.regs.get64 .r11) m.data.status.cf m.data.status.pf
      m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of hsv [])
    (flat := [.pc 0x401000#64, .reg rdi (m.data.regs.get64 .rdi),
      .reg rsi (m.data.regs.get64 .rsi),
      .reg rdx (m.data.regs.get64 .rdx), .reg rax (m.data.regs.get64 .rax),
      .reg rcx (m.data.regs.get64 .rcx), .reg r8 (m.data.regs.get64 .r8),
      .reg r9 (m.data.regs.get64 .r9), .reg r10 (m.data.regs.get64 .r10),
      .reg r11 (m.data.regs.get64 .r11), .reg rbx (m.data.regs.get64 .rbx),
      .reg rbp (m.data.regs.get64 .rbp), .reg rsp (m.data.regs.get64 .rsp),
      .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
      .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
      .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of] ++
      (cellsAtoms 4 true (m.data.regs.get64 .rdi) (w32s v.toList) ++
      (cellsAtoms 8 true ((m.data.regs.get64 .rsp) - 16#64) sv ++
      (cellsAtoms 8 true (m.data.regs.get64 .rsp) [r] ++ []))))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩⟩⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [Vars.toList]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hsv]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp), .nil, disj_nil_right⟩,
        disj_append_right (cellsAtoms_disj (by simp [hsv]; bv_omega) (by simp; bv_omega))
          disj_nil_right⟩,
        disj_append_right
          (cellsAtoms_disj (by simp [Vars.toList]; bv_omega) (by simp [hsv]; bv_omega))
          (disj_append_right
            (cellsAtoms_disj (by simp [Vars.toList]; bv_omega) (by simp; bv_omega))
            disj_nil_right)⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, regOf, flagOf, hpc],
        List.forall_mem_append.2 ⟨hv.sat,
        List.forall_mem_append.2 ⟨hstk.sat,
        List.forall_mem_append.2 ⟨sat_word hret, by simp⟩⟩⟩⟩)).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`sha256_round` reveals nothing of the words it works on.** Two machines that each
satisfy the hypotheses of `sha256_round_leakage`, with the same return address `r` at the
stack pointer, and that agree on `rdi` and on the stack pointer, have the same trace on every
run, whatever the working variables, the round constant in `rsi`, the word of the schedule
in `rdx` and the two double words below the stack pointer of each are. The hypothesis that
the regions are apart is asked of the first machine, and holds of the second as the two
agree on the addresses. -/
theorem sha256_round_leakage_eq [Layout] (m₁ m₂ : MachineState) (v₁ v₂ : Vars)
    (sv₁ sv₂ : List Word) (r : Word)
    (hpc₁ : m₁.pc = 0x401000) (hpc₂ : m₂.pc = 0x401000)
    (hsv₁ : sv₁.length = 2) (hsv₂ : sv₂.length = 2)
    (hv₁ : HasCells m₁ (m₁.data.regs.get64 .rdi) v₁.toList)
    (hv₂ : HasCells m₂ (m₂.data.regs.get64 .rdi) v₂.toList)
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hstk₁ : HasWords m₁ ((m₁.data.regs.get64 .rsp) - 16#64) sv₁)
    (hstk₂ : HasWords m₂ ((m₂.data.regs.get64 .rsp) - 16#64) sv₂)
    (hsep : Apart (m₁.data.regs.get64 .rdi) 32 ((m₁.data.regs.get64 .rsp) - 16#64) 24)
    (edi : m₂.data.regs.get64 .rdi = m₁.data.regs.get64 .rdi)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := sha256_round_leakage m₁ v₁ sv₁ r hpc₁ hsv₁ hv₁ hret₁ hstk₁ hsep
  have h₂ := sha256_round_leakage m₂ v₂ sv₂ r hpc₂ hsv₂ hv₂ hret₂ hstk₂
    (by rw [edi, esp]; exact hsep)
  rw [edi, esp] at h₂
  exact ⟨_, h₁, h₂⟩

/-! ## The message schedule -/

/-- **What `sha256_schedule` reveals, on the machine.** A machine under the hypotheses of
`sha256_schedule_correct` (it runs the executable of this image and is at the entry of
`sha256_schedule`; it has 64 words in memory where `rdi` points, the block `M` and 48 words
`js` after it, and the return address `r` in the eight bytes at the stack pointer, apart from
those words) reaches `r` on every run, and the trace of the run is `scheduleLeak` of `rdi`,
the stack pointer and `r`. The block is not in the trace. -/
theorem sha256_schedule_leakage [Layout] (m : MachineState) (M js : List W32) (r : Word)
    (hpc : m.pc = 0x4010a0) (hM : M.length = 16) (hjs : js.length = 48)
    (hm : HasCells m (m.data.regs.get64 .rdi) (M ++ js))
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hsep : Apart (m.data.regs.get64 .rdi) 256 (m.data.regs.get64 .rsp) 8) :
    RunL exe
      (fun m' u => u = scheduleLeak (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsp) r ∧
        m'.pc.toBitVec = r) m [] := by
  obtain ⟨hsep1, hsep2⟩ := hsep
  refine (machine_soundT sha256_schedule_holds
    (sha256_schedule_trace (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsp) r
      (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx) (m.data.regs.get64 .rdx)
      (m.data.regs.get64 .rsi) (m.data.regs.get64 .r8) M (w32s js) m.data.status.cf
      m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of
      hM (by simpa using hjs) [])
    (flat := [.pc 0x4010a0#64, .reg rdi (m.data.regs.get64 .rdi),
      .reg rax (m.data.regs.get64 .rax),
      .reg rcx (m.data.regs.get64 .rcx), .reg rdx (m.data.regs.get64 .rdx),
      .reg rsi (m.data.regs.get64 .rsi), .reg r8 (m.data.regs.get64 .r8),
      .reg rsp (m.data.regs.get64 .rsp),
      .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
      .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
      .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of] ++
      (cellsAtoms 4 true (m.data.regs.get64 .rdi) (w32s M ++ w32s js) ++
      (cellsAtoms 8 true (m.data.regs.get64 .rsp) [r] ++ [])))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hM, hjs]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp), .nil, disj_nil_right⟩,
        disj_append_right
          (cellsAtoms_disj (by simp [hM, hjs]; bv_omega) (by simp; bv_omega))
          disj_nil_right⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, regOf, flagOf, hpc],
        List.forall_mem_append.2 ⟨by rw [← w32s_append]; exact hm.sat,
        List.forall_mem_append.2 ⟨sat_word hret, by simp⟩⟩⟩)).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`sha256_schedule` reveals nothing of the block.** Two machines that each satisfy the
hypotheses of `sha256_schedule_leakage`, with the same return address `r` at the stack
pointer, and that agree on `rdi` and on the stack pointer, have the same trace on every run,
whatever the 64 words of each are. The hypothesis that the regions are apart is asked of the
first machine, and holds of the second as the two agree on the addresses. -/
theorem sha256_schedule_leakage_eq [Layout] (m₁ m₂ : MachineState)
    (M₁ js₁ M₂ js₂ : List W32) (r : Word)
    (hpc₁ : m₁.pc = 0x4010a0) (hpc₂ : m₂.pc = 0x4010a0)
    (hM₁ : M₁.length = 16) (hjs₁ : js₁.length = 48)
    (hM₂ : M₂.length = 16) (hjs₂ : js₂.length = 48)
    (hm₁ : HasCells m₁ (m₁.data.regs.get64 .rdi) (M₁ ++ js₁))
    (hm₂ : HasCells m₂ (m₂.data.regs.get64 .rdi) (M₂ ++ js₂))
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hsep : Apart (m₁.data.regs.get64 .rdi) 256 (m₁.data.regs.get64 .rsp) 8)
    (edi : m₂.data.regs.get64 .rdi = m₁.data.regs.get64 .rdi)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := sha256_schedule_leakage m₁ M₁ js₁ r hpc₁ hM₁ hjs₁ hm₁ hret₁ hsep
  have h₂ := sha256_schedule_leakage m₂ M₂ js₂ r hpc₂ hM₂ hjs₂ hm₂ hret₂
    (by rw [edi, esp]; exact hsep)
  rw [edi, esp] at h₂
  exact ⟨_, h₁, h₂⟩

/-! ## The compression function -/

/-- **What `sha256_compress` reveals, on the machine.** A machine under the hypotheses of
`sha256_compress_correct` (it runs the executable of this image and is at the entry of
`sha256_compress`; it has the hash value `H`, eight words, in memory where `rdi` points, the
block `M`, sixteen words, where `rsi` points, the round constants of SHA-256 at `0x402320`,
where the code looks for them, the return address `r` in the eight bytes at the stack
pointer and, in the 340 bytes below them, seven words `fvs`, 64 words `fws` and, eight bytes
further, six double words `sv`, all of which are overwritten; the hash value, the block, the
round constants and those 348 bytes of stack are pairwise apart) reaches `r` on every run,
and the trace of the run is `compressLeak` of `rdi`, `rsi`, the stack pointer and `r`.
Neither the hash value nor the block is in the trace: the compiled code has no branch and no
address that depends on them. -/
theorem sha256_compress_leakage [Layout] (m : MachineState) (H M fvs fws : List W32)
    (sv : List Word) (r : Word) (hpc : m.pc = 0x401100)
    (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 7) (hfw : fws.length = 64)
    (hsvl : sv.length = 6)
    (hh : HasCells m (m.data.regs.get64 .rdi) H) (hm : HasCells m (m.data.regs.get64 .rsi) M)
    (hk : HasCells m 0x402320#64 K)
    (hv : HasCells m ((m.data.regs.get64 .rsp) - 340#64) fvs)
    (hws : HasCells m ((m.data.regs.get64 .rsp) - 312#64) fws)
    (hsv : HasWords m ((m.data.regs.get64 .rsp) - 48#64) sv)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hhm : Apart (m.data.regs.get64 .rdi) 32 (m.data.regs.get64 .rsi) 64)
    (hhk : Apart (m.data.regs.get64 .rdi) 32 0x402320#64 256)
    (hhs : Apart (m.data.regs.get64 .rdi) 32 ((m.data.regs.get64 .rsp) - 340#64) 348)
    (hmk : Apart (m.data.regs.get64 .rsi) 64 0x402320#64 256)
    (hms : Apart (m.data.regs.get64 .rsi) 64 ((m.data.regs.get64 .rsp) - 340#64) 348)
    (hks : Apart 0x402320#64 256 ((m.data.regs.get64 .rsp) - 340#64) 348) :
    RunL exe
      (fun m' u => u = compressLeak (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
        (m.data.regs.get64 .rsp) r ∧ m'.pc.toBitVec = r) m [] := by
  have hlK : K.length = 64 := rfl
  refine (machine_soundT sha256_compress_holds
    (sha256_compress_trace (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64
      .rsp) r
      (m.data.regs.get64 .rbx) (m.data.regs.get64 .rbp) (m.data.regs.get64 .r12) (m.data.regs.get64
        .r13) (m.data.regs.get64 .r14)
      (m.data.regs.get64 .r15) H M true true (w32s fvs) (w32s fws) sv (m.data.regs.get64 .rax)
      (m.data.regs.get64 .rcx) (m.data.regs.get64 .rdx) (m.data.regs.get64 .r8) (m.data.regs.get64
        .r9)
      (m.data.regs.get64 .r10) (m.data.regs.get64 .r11) m.data.status.cf m.data.status.pf
      m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of hH hM
      (by simpa using hfv) (by simpa using hfw) hsvl [])
    (flat := [.pc 0x401100#64, .reg rdi (m.data.regs.get64 .rdi),
      .reg rsi (m.data.regs.get64 .rsi),
      .reg rax (m.data.regs.get64 .rax), .reg rcx (m.data.regs.get64 .rcx),
      .reg rdx (m.data.regs.get64 .rdx), .reg r8 (m.data.regs.get64 .r8),
      .reg r9 (m.data.regs.get64 .r9), .reg r10 (m.data.regs.get64 .r10),
      .reg r11 (m.data.regs.get64 .r11), .reg rbx (m.data.regs.get64 .rbx),
      .reg rbp (m.data.regs.get64 .rbp), .reg r12 (m.data.regs.get64 .r12),
      .reg r13 (m.data.regs.get64 .r13), .reg r14 (m.data.regs.get64 .r14),
      .reg r15 (m.data.regs.get64 .r15), .reg rsp (m.data.regs.get64 .rsp),
      .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
      .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
      .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of] ++
      (cellsAtoms 4 true (m.data.regs.get64 .rdi) (w32s H) ++
      (cellsAtoms 4 true (m.data.regs.get64 .rsi) (w32s M) ++
      (cellsAtoms 4 true 0x402320#64 (w32s K) ++
      (cellsAtoms 4 true ((m.data.regs.get64 .rsp) - 340#64) (w32s fvs) ++
      (cellsAtoms 4 true ((m.data.regs.get64 .rsp) - 312#64) (w32s fws) ++
      (cellsAtoms 8 true ((m.data.regs.get64 .rsp) - 48#64) sv ++
      (cellsAtoms 8 true (m.data.regs.get64 .rsp) [r] ++ []))))))))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩⟩⟩⟩⟩⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩⟩⟩⟩⟩⟩⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hH]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hM]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hlK]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hfv]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hfw]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hsvl]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp), .nil, disj_nil_right⟩,
        -- the saved registers, and the return address
        disj_append_right (cellsAtoms_disj (by simp [hsvl]; bv_omega) (by simp; bv_omega))
          disj_nil_right⟩,
        -- the schedule, and what follows it
        disj_append_right (cellsAtoms_disj (by simp [hfw]; bv_omega) (by simp [hsvl]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hfw]; bv_omega) (by simp; bv_omega))
          disj_nil_right)⟩,
        -- the working variables, and what follows them
        disj_append_right (cellsAtoms_disj (by simp [hfv]; bv_omega) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hfv]; bv_omega) (by simp [hsvl]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hfv]; bv_omega) (by simp; bv_omega))
          disj_nil_right))⟩,
        -- the round constants, and what follows them
        disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hfv])
            (by simp [hlK]) (by simp [hfv]))
          (disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hfw])
            (by simp [hlK]) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hsvl])
            (by simp [hlK]) (by simp [hsvl]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp)
            (by simp [hlK]) (by simp; bv_omega))
          disj_nil_right)))⟩,
        -- the block, and what follows it
        disj_append_right (cellsAtoms_disj_of_apart hmk.1 hmk.2 (by simp [hM]) (by simp [hlK])
            (by simp [hM]) (by simp [hlK]))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hfv])
            (by simp [hM]) (by simp [hfv]))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hfw])
            (by simp [hM]) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hsvl])
            (by simp [hM]) (by simp [hsvl]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp)
            (by simp [hM]) (by simp; bv_omega))
          disj_nil_right))))⟩,
        -- the hash value, and what follows it
        disj_append_right (cellsAtoms_disj (by rw [w32s_length, hH]; exact hhm.1)
            (by rw [w32s_length, hM]; exact hhm.2))
          (disj_append_right (cellsAtoms_disj_of_apart hhk.1 hhk.2 (by simp [hH]) (by simp [hlK])
            (by simp [hH]) (by simp [hlK]))
          (disj_append_right (cellsAtoms_disj_of_apart hhs.1 hhs.2 (by simp [hH]) (by simp [hfv])
            (by simp [hH]) (by simp [hfv]))
          (disj_append_right (cellsAtoms_disj_of_apart hhs.1 hhs.2 (by simp [hH]) (by simp [hfw])
            (by simp [hH]) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hhs.1 hhs.2 (by simp [hH]) (by simp [hsvl])
            (by simp [hH]) (by simp [hsvl]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hhs.1 hhs.2 (by simp [hH]) (by simp)
            (by simp [hH]) (by simp; bv_omega))
          disj_nil_right)))))⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, regOf, flagOf, hpc],
        List.forall_mem_append.2 ⟨hh.sat,
        List.forall_mem_append.2 ⟨hm.sat,
        List.forall_mem_append.2 ⟨hk.sat,
        List.forall_mem_append.2 ⟨hv.sat,
        List.forall_mem_append.2 ⟨hws.sat,
        List.forall_mem_append.2 ⟨hsv.sat,
        List.forall_mem_append.2 ⟨sat_word hret, by simp⟩⟩⟩⟩⟩⟩⟩⟩)).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`sha256_compress` reveals nothing of the hash value or the block.** Two machines that
each satisfy the hypotheses of `sha256_compress_leakage`, with hash values `H₁` and `H₂`,
blocks `M₁` and `M₂`, any contents of the 340 bytes below the stack pointer and the same
return address `r` at it, and that agree on the two pointers `rdi` and `rsi` and on the
stack pointer, have the same trace on every run. The hypotheses that the regions are apart
are asked of the first machine, and hold of the second as the two agree on the addresses. -/
theorem sha256_compress_leakage_eq [Layout] (m₁ m₂ : MachineState)
    (H₁ M₁ fvs₁ fws₁ H₂ M₂ fvs₂ fws₂ : List W32) (sv₁ sv₂ : List Word)
    (r : Word)
    (hpc₁ : m₁.pc = 0x401100) (hpc₂ : m₂.pc = 0x401100)
    (hH₁ : H₁.length = 8) (hM₁ : M₁.length = 16) (hfv₁ : fvs₁.length = 7)
    (hfw₁ : fws₁.length = 64) (hsvl₁ : sv₁.length = 6)
    (hH₂ : H₂.length = 8) (hM₂ : M₂.length = 16) (hfv₂ : fvs₂.length = 7)
    (hfw₂ : fws₂.length = 64) (hsvl₂ : sv₂.length = 6)
    (hh₁ : HasCells m₁ (m₁.data.regs.get64 .rdi) H₁)
    (hm₁ : HasCells m₁ (m₁.data.regs.get64 .rsi) M₁)
    (hk₁ : HasCells m₁ 0x402320#64 K)
    (hv₁ : HasCells m₁ ((m₁.data.regs.get64 .rsp) - 340#64) fvs₁)
    (hws₁ : HasCells m₁ ((m₁.data.regs.get64 .rsp) - 312#64) fws₁)
    (hsv₁ : HasWords m₁ ((m₁.data.regs.get64 .rsp) - 48#64) sv₁)
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (hh₂ : HasCells m₂ (m₂.data.regs.get64 .rdi) H₂)
    (hm₂ : HasCells m₂ (m₂.data.regs.get64 .rsi) M₂)
    (hk₂ : HasCells m₂ 0x402320#64 K)
    (hv₂ : HasCells m₂ ((m₂.data.regs.get64 .rsp) - 340#64) fvs₂)
    (hws₂ : HasCells m₂ ((m₂.data.regs.get64 .rsp) - 312#64) fws₂)
    (hsv₂ : HasWords m₂ ((m₂.data.regs.get64 .rsp) - 48#64) sv₂)
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hhm : Apart (m₁.data.regs.get64 .rdi) 32 (m₁.data.regs.get64 .rsi) 64)
    (hhk : Apart (m₁.data.regs.get64 .rdi) 32 0x402320#64 256)
    (hhs : Apart (m₁.data.regs.get64 .rdi) 32 ((m₁.data.regs.get64 .rsp) - 340#64) 348)
    (hmk : Apart (m₁.data.regs.get64 .rsi) 64 0x402320#64 256)
    (hms : Apart (m₁.data.regs.get64 .rsi) 64 ((m₁.data.regs.get64 .rsp) - 340#64) 348)
    (hks : Apart 0x402320#64 256 ((m₁.data.regs.get64 .rsp) - 340#64) 348)
    (edi : m₂.data.regs.get64 .rdi = m₁.data.regs.get64 .rdi)
    (esi : m₂.data.regs.get64 .rsi = m₁.data.regs.get64 .rsi)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := sha256_compress_leakage m₁ H₁ M₁ fvs₁ fws₁ sv₁ r hpc₁ hH₁ hM₁ hfv₁ hfw₁
    hsvl₁ hh₁ hm₁ hk₁ hv₁ hws₁ hsv₁ hret₁ hhm hhk hhs hmk hms hks
  have h₂ := sha256_compress_leakage m₂ H₂ M₂ fvs₂ fws₂ sv₂ r hpc₂ hH₂ hM₂ hfv₂ hfw₂
    hsvl₂ hh₂ hm₂ hk₂ hv₂ hws₂ hsv₂ hret₂ (by rw [edi, esi]; exact hhm)
    (by rw [edi]; exact hhk)
    (by rw [edi, esp]; exact hhs) (by rw [esi]; exact hmk) (by rw [esi, esp]; exact hms)
    (by rw [esp]; exact hks)
  rw [edi, esi, esp] at h₂
  exact ⟨_, h₁, h₂⟩

end Examples.Sha256.O2.X86
