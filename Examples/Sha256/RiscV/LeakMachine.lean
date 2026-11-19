/-
  Examples.Sha256.RiscV.LeakMachine

  What SHA-256 reveals on the RISC-V machine (`docs/Leakage.md`): the traced triples of
  `LeakRound`, `LeakSchedule` and `LeakCompress`, as theorems about the machine model alone.
  Each function has two. `<f>_leakage` says that the trace of the run is an explicit function
  of public inputs: the addresses the function is given, the stack pointer where it uses the
  stack, and the return address. `<f>_leakage_eq` says that two machines that agree on those
  inputs run with the same trace, whatever the working variables, the block, the hash value
  and the stack hold. No branch and no address of the compiled code depends on that data.

  ## Main results

  * `sha256_round_leakage`, `sha256_round_leakage_eq`
  * `sha256_schedule_leakage`, `sha256_schedule_leakage_eq`
  * `sha256_compress_leakage`, `sha256_compress_leakage_eq`
-/

module

public import Examples.Sha256.RiscV.LeakRound
public import Examples.Sha256.RiscV.LeakSchedule
public import Examples.Sha256.RiscV.LeakCompress

public section

namespace Examples.Sha256.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-! ## The round -/

/-- **What `sha256_round` reveals, on the machine.** A machine that holds the code of
`sha256_round`, is at its entry, has the eight working variables `v` in memory where `a0`
points and a word `m0` of memory below the stack pointer, with `a0` aligned to four bytes
and the stack pointer to eight, and the working variables apart from that word of stack,
runs to the return address with the trace `roundLeak` of `a0`, the stack pointer and the
return address. The round constant in `a1` and the word of the schedule in `a2` are not in
the trace, and neither are the working variables. -/
theorem sha256_round_leakage (s : MachineState) (v : Vars) (m0 : Word)
    (hcode : ∀ p ∈ sha256_round_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hp : s.getReg .x10 &&& 3#64 = 0#64) (hsp : s.getReg .x2 &&& 7#64 = 0#64)
    (hv : HasCells s (s.getReg .x10) v.toList)
    (hstk : HasBytes s (s.getReg .x2 - 8#64) 8 m0)
    (hsep : Apart (s.getReg .x10) 32 (s.getReg .x2 - 8#64) 8) :
    ∃ s', RunL s (roundLeak (s.getReg .x10) (s.getReg .x2) (s.getReg .x1)) s' ∧
      s'.pc = s.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨hsep1, hsep2⟩ := hsep
  obtain ⟨s', σ', hrun, hr, hq⟩ := machine_soundT sha256_round_lowered
    (sha256_round_trace (s.getReg .x10) (s.getReg .x11) (s.getReg .x12) (s.getReg .x2)
      (s.getReg .x1) (s.getReg .x8) m0 v
      (s.getReg .x5) (s.getReg .x6) (s.getReg .x7) (s.getReg .x13) (s.getReg .x14)
      (s.getReg .x15) (s.getReg .x16) (s.getReg .x17) (s.getReg .x28) (s.getReg .x29)
      (s.getReg .x30) (s.getReg .x31) hp hsp []) hcode
    (flat := [.pc 0x10000#64, .reg a0 (s.getReg .x10), .reg a1 (s.getReg .x11), .reg a2
      (s.getReg .x12), .reg a3 (s.getReg .x13), .reg a4 (s.getReg .x14), .reg a5 (s.getReg
      .x15), .reg a6 (s.getReg .x16), .reg a7 (s.getReg .x17), .reg t0 (s.getReg .x5), .reg
      t1 (s.getReg .x6), .reg t2 (s.getReg .x7), .reg t3 (s.getReg .x28), .reg t4 (s.getReg
      .x29), .reg t5 (s.getReg .x30), .reg t6 (s.getReg .x31), .reg s0 (s.getReg .x8), .reg
      sp (s.getReg .x2), .reg ra (s.getReg .x1)] ++
      (cellsAtoms 4 true (s.getReg .x10) (w32s v.toList) ++
      (cellsAtoms 8 true (s.getReg .x2 - 8#64) [m0] ++ [])))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [Vars.toList]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp), .nil, disj_nil_right⟩,
        disj_append_right
          (cellsAtoms_disj (by simp [Vars.toList]; bv_omega) (by simp; bv_omega))
          disj_nil_right⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc],
        List.forall_mem_append.2 ⟨hv.sat,
        List.forall_mem_append.2 ⟨sat_word hstk, by simp⟩⟩⟩)
  rw [List.nil_append] at hrun
  refine ⟨s', hrun, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`sha256_round` reveals nothing of the words it works on.** Two machines that hold the
code of `sha256_round`, are at its entry, each with eight working variables where `a0`
points and a word of memory below the stack pointer, and that agree on `a0`, aligned to four
bytes, on the stack pointer, aligned to eight, and on the return address, run with the same
trace, whatever the working variables, the round constant in `a1` and the word of the
schedule in `a2` of each are. -/
theorem sha256_round_leakage_eq (s₁ s₂ : MachineState) (v₁ v₂ : Vars) (m₁ m₂ : Word)
    (hcode₁ : ∀ p ∈ sha256_round_code, s₁.code p.1 = some p.2)
    (hcode₂ : ∀ p ∈ sha256_round_code, s₂.code p.1 = some p.2)
    (hpc₁ : s₁.pc = 0x10000#64) (hpc₂ : s₂.pc = 0x10000#64)
    (hp : s₁.getReg .x10 &&& 3#64 = 0#64) (hsp : s₁.getReg .x2 &&& 7#64 = 0#64)
    (hv₁ : HasCells s₁ (s₁.getReg .x10) v₁.toList)
    (hstk₁ : HasBytes s₁ (s₁.getReg .x2 - 8#64) 8 m₁)
    (hv₂ : HasCells s₂ (s₂.getReg .x10) v₂.toList)
    (hstk₂ : HasBytes s₂ (s₂.getReg .x2 - 8#64) 8 m₂)
    (hsep : Apart (s₁.getReg .x10) 32 (s₁.getReg .x2 - 8#64) 8)
    (e10 : s₂.getReg .x10 = s₁.getReg .x10) (e2 : s₂.getReg .x2 = s₁.getReg .x2)
    (e1 : s₂.getReg .x1 = s₁.getReg .x1) :
    ∃ tr s₁' s₂', RunL s₁ tr s₁' ∧ RunL s₂ tr s₂' ∧
      s₁'.pc = s₁.getReg .x1 &&& ~~~1#64 ∧ s₂'.pc = s₁.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨s₁', h₁, hp₁⟩ := sha256_round_leakage s₁ v₁ m₁ hcode₁ hpc₁ hp hsp hv₁ hstk₁ hsep
  obtain ⟨s₂', h₂, hp₂⟩ := sha256_round_leakage s₂ v₂ m₂ hcode₂ hpc₂ (by rw [e10]; exact hp)
    (by rw [e2]; exact hsp) hv₂ hstk₂ (by rw [e10, e2]; exact hsep)
  simp only [e10, e2, e1] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

/-! ## The message schedule -/

/-- **What `sha256_schedule` reveals, on the machine.** A machine that holds the code of
`sha256_schedule`, is at its entry, and has 64 words in memory where `a0` points (the block
`M` and 48 words `js` after it), with `a0` aligned to four bytes, runs to the return address
with the trace `scheduleLeak` of `a0` and the return address. The block is not in the
trace. -/
theorem sha256_schedule_leakage (s : MachineState) (M js : List W32)
    (hcode : ∀ p ∈ sha256_schedule_code, s.code p.1 = some p.2) (hpc : s.pc = 0x100e4#64)
    (hM : M.length = 16) (hjs : js.length = 48) (hp : s.getReg .x10 &&& 3#64 = 0#64)
    (hm : HasCells s (s.getReg .x10) (M ++ js)) :
    ∃ s', RunL s (scheduleLeak (s.getReg .x10) (s.getReg .x1)) s' ∧
      s'.pc = s.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨s', σ', hrun, hr, hq⟩ := machine_soundT sha256_schedule_lowered
    (sha256_schedule_trace (s.getReg .x10) (s.getReg .x1)
      (s.getReg .x11) (s.getReg .x12) (s.getReg .x13) (s.getReg .x14) (s.getReg .x15)
      (s.getReg .x16) (s.getReg .x17) (s.getReg .x5) (s.getReg .x6) M (w32s js) hM
      (by simpa using hjs) hp []) hcode
    (flat := [.pc 0x100e4#64, .reg a0 (s.getReg .x10), .reg a1 (s.getReg .x11), .reg a2
      (s.getReg .x12), .reg a3 (s.getReg .x13), .reg a4 (s.getReg .x14), .reg a5 (s.getReg
      .x15), .reg a6 (s.getReg .x16), .reg a7 (s.getReg .x17), .reg t0 (s.getReg .x5), .reg
      t1 (s.getReg .x6), .reg ra (s.getReg .x1)] ++
      (cellsAtoms 4 true (s.getReg .x10) (w32s M ++ w32s js) ++ []))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hM, hjs]), .nil,
        disj_nil_right⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc],
        List.forall_mem_append.2 ⟨by rw [← w32s_append]; exact hm.sat, by simp⟩⟩)
  rw [List.nil_append] at hrun
  refine ⟨s', hrun, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`sha256_schedule` reveals nothing of the block.** Two machines that hold the code of
`sha256_schedule`, are at its entry, each with 64 words in memory where `a0` points, and
that agree on `a0`, aligned to four bytes, and on the return address, run with the same
trace, whatever the 64 words of each are. -/
theorem sha256_schedule_leakage_eq (s₁ s₂ : MachineState) (M₁ js₁ M₂ js₂ : List W32)
    (hcode₁ : ∀ p ∈ sha256_schedule_code, s₁.code p.1 = some p.2)
    (hcode₂ : ∀ p ∈ sha256_schedule_code, s₂.code p.1 = some p.2)
    (hpc₁ : s₁.pc = 0x100e4#64) (hpc₂ : s₂.pc = 0x100e4#64)
    (hM₁ : M₁.length = 16) (hjs₁ : js₁.length = 48)
    (hM₂ : M₂.length = 16) (hjs₂ : js₂.length = 48)
    (hp : s₁.getReg .x10 &&& 3#64 = 0#64)
    (hm₁ : HasCells s₁ (s₁.getReg .x10) (M₁ ++ js₁))
    (hm₂ : HasCells s₂ (s₂.getReg .x10) (M₂ ++ js₂))
    (e10 : s₂.getReg .x10 = s₁.getReg .x10) (e1 : s₂.getReg .x1 = s₁.getReg .x1) :
    ∃ tr s₁' s₂', RunL s₁ tr s₁' ∧ RunL s₂ tr s₂' ∧
      s₁'.pc = s₁.getReg .x1 &&& ~~~1#64 ∧ s₂'.pc = s₁.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨s₁', h₁, hp₁⟩ := sha256_schedule_leakage s₁ M₁ js₁ hcode₁ hpc₁ hM₁ hjs₁ hp hm₁
  obtain ⟨s₂', h₂, hp₂⟩ := sha256_schedule_leakage s₂ M₂ js₂ hcode₂ hpc₂ hM₂ hjs₂
    (by rw [e10]; exact hp) hm₂
  simp only [e10, e1] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

/-! ## The compression function -/

/-- **What `sha256_compress` reveals, on the machine.** A machine under the hypotheses of
`sha256_compress_correct` (it holds the code of `sha256_compress` and is at its entry; it
has in valid memory the hash value `H`, eight words, where `a0` points, the block `M`,
sixteen words, where `a1` points, the round constants of SHA-256 at `0x10368`, where the
code looks for them, and 312 bytes below the stack pointer, here eight words `fvs`, 64 words
`fws` and three double words `sv`; `a0` and `a1` are aligned to four bytes and the stack
pointer to eight; the hash value, the block, the round constants and those 312 bytes of
stack are pairwise apart) runs to the return address with the trace `compressLeak` of `a0`,
`a1`, the stack pointer and the return address. Neither the hash value nor the block is in
the trace: the compiled code has no branch and no address that depends on them. -/
theorem sha256_compress_leakage (s : MachineState) (H M fvs fws : List W32) (sv : List Word)
    (hcode : ∀ p ∈ sha256_compress_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10160#64)
    (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 8) (hfw : fws.length = 64)
    (hsvl : sv.length = 3)
    (hhp : s.getReg .x10 &&& 3#64 = 0#64) (hmp : s.getReg .x11 &&& 3#64 = 0#64)
    (hsp : s.getReg .x2 &&& 7#64 = 0#64)
    (hh : HasCells s (s.getReg .x10) H) (hm : HasCells s (s.getReg .x11) M)
    (hk : HasCells s 0x10368#64 K)
    (hv : HasCells s (s.getReg .x2 - 312#64) fvs) (hws : HasCells s (s.getReg .x2 - 280#64) fws)
    (hsv : HasWords s (s.getReg .x2 - 24#64) sv)
    (hhm : Apart (s.getReg .x10) 32 (s.getReg .x11) 64)
    (hhk : Apart (s.getReg .x10) 32 0x10368#64 256)
    (hhs : Apart (s.getReg .x10) 32 (s.getReg .x2 - 312#64) 312)
    (hmk : Apart (s.getReg .x11) 64 0x10368#64 256)
    (hms : Apart (s.getReg .x11) 64 (s.getReg .x2 - 312#64) 312)
    (hks : Apart 0x10368#64 256 (s.getReg .x2 - 312#64) 312) :
    ∃ s', RunL s
        (compressLeak (s.getReg .x10) (s.getReg .x11) (s.getReg .x2) (s.getReg .x1)) s' ∧
      s'.pc = s.getReg .x1 &&& ~~~1#64 := by
  have hlK : K.length = 64 := rfl
  obtain ⟨s', σ', hrun, hr, hq⟩ := machine_soundT sha256_compress_lowered
    (sha256_compress_trace
      (s.getReg .x10) (s.getReg .x11) (s.getReg .x2) (s.getReg .x1) (s.getReg .x8) (s.getReg
      .x9) (s.getReg .x18) H M true true (w32s fvs) (w32s fws) sv
      (s.getReg .x12) (s.getReg .x13) (s.getReg .x14) (s.getReg .x15) (s.getReg .x16) (s.getReg
      .x17) (s.getReg .x5) (s.getReg .x6) (s.getReg .x7) (s.getReg .x28) (s.getReg .x29)
      (s.getReg .x30) (s.getReg .x31) hH hM
      (by simpa using hfv) (by simpa using hfw) hsvl hhp hmp hsp []) hcode
    (flat := [.pc 0x10160#64, .reg a0 (s.getReg .x10), .reg a1 (s.getReg .x11), .reg a2
      (s.getReg .x12), .reg a3 (s.getReg .x13), .reg a4 (s.getReg .x14), .reg a5 (s.getReg
      .x15), .reg a6 (s.getReg .x16), .reg a7 (s.getReg .x17), .reg t0 (s.getReg .x5), .reg
      t1 (s.getReg .x6), .reg t2 (s.getReg .x7), .reg t3 (s.getReg .x28), .reg t4 (s.getReg
      .x29), .reg t5 (s.getReg .x30), .reg t6 (s.getReg .x31), .reg s0 (s.getReg .x8), .reg
      s1 (s.getReg .x9), .reg s2 (s.getReg .x18), .reg sp (s.getReg .x2), .reg ra (s.getReg
      .x1)] ++
      (cellsAtoms 4 true (s.getReg .x10) (w32s H) ++
      (cellsAtoms 4 true (s.getReg .x11) (w32s M) ++
      (cellsAtoms 4 true 0x10368#64 (w32s K) ++
      (cellsAtoms 4 true (s.getReg .x2 - 312#64) (w32s fvs) ++
      (cellsAtoms 4 true (s.getReg .x2 - 280#64) (w32s fws) ++
      (cellsAtoms 8 true (s.getReg .x2 - 24#64) sv ++ [])))))))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩⟩⟩⟩⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩⟩⟩⟩⟩⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hH]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hM]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hlK]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hfv]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hfw]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hsvl]), .nil, disj_nil_right⟩,
        -- the schedule, and what follows it
        disj_append_right (cellsAtoms_disj (by simp [hfw]; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right⟩,
        -- the working variables, and what follows them
        disj_append_right (cellsAtoms_disj (by simp [hfv]; bv_omega) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hfv]; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right)⟩,
        -- the round constants, and what follows them
        disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hfv])
            (by simp [hlK]) (by simp [hfv]))
          (disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hfw])
            (by simp [hlK]) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hsvl])
            (by simp [hlK]) (by simp [hsvl]; bv_omega))
          disj_nil_right))⟩,
        -- the block, and what follows it
        disj_append_right (cellsAtoms_disj_of_apart hmk.1 hmk.2 (by simp [hM]) (by simp [hlK])
            (by simp [hM]) (by simp [hlK]))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hfv])
            (by simp [hM]) (by simp [hfv]))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hfw])
            (by simp [hM]) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hsvl])
            (by simp [hM]) (by simp [hsvl]; bv_omega))
          disj_nil_right)))⟩,
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
          disj_nil_right))))⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc],
        List.forall_mem_append.2 ⟨hh.sat,
        List.forall_mem_append.2 ⟨hm.sat,
        List.forall_mem_append.2 ⟨hk.sat,
        List.forall_mem_append.2 ⟨hv.sat,
        List.forall_mem_append.2 ⟨hws.sat,
        List.forall_mem_append.2 ⟨hsv.sat, by simp⟩⟩⟩⟩⟩⟩⟩)
  rw [List.nil_append] at hrun
  refine ⟨s', hrun, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`sha256_compress` reveals nothing of the hash value or the block.** Two machines that
each satisfy the hypotheses of `sha256_compress_leakage`, with hash values `H₁` and `H₂`,
blocks `M₁` and `M₂` and any contents of the 312 bytes of stack, and that agree on the two
pointers `a0` and `a1`, on the stack pointer and on the return address, run with the same
trace. The hypotheses on alignment and on the regions being apart are asked of the first
machine, and hold of the second as the two agree on the addresses. -/
theorem sha256_compress_leakage_eq (s₁ s₂ : MachineState)
    (H₁ M₁ fvs₁ fws₁ H₂ M₂ fvs₂ fws₂ : List W32) (sv₁ sv₂ : List Word)
    (hcode₁ : ∀ p ∈ sha256_compress_code, s₁.code p.1 = some p.2)
    (hcode₂ : ∀ p ∈ sha256_compress_code, s₂.code p.1 = some p.2)
    (hpc₁ : s₁.pc = 0x10160#64) (hpc₂ : s₂.pc = 0x10160#64)
    (hH₁ : H₁.length = 8) (hM₁ : M₁.length = 16) (hfv₁ : fvs₁.length = 8)
    (hfw₁ : fws₁.length = 64) (hsvl₁ : sv₁.length = 3)
    (hH₂ : H₂.length = 8) (hM₂ : M₂.length = 16) (hfv₂ : fvs₂.length = 8)
    (hfw₂ : fws₂.length = 64) (hsvl₂ : sv₂.length = 3)
    (hhp : s₁.getReg .x10 &&& 3#64 = 0#64) (hmp : s₁.getReg .x11 &&& 3#64 = 0#64)
    (hsp : s₁.getReg .x2 &&& 7#64 = 0#64)
    (hh₁ : HasCells s₁ (s₁.getReg .x10) H₁) (hm₁ : HasCells s₁ (s₁.getReg .x11) M₁)
    (hk₁ : HasCells s₁ 0x10368#64 K)
    (hv₁ : HasCells s₁ (s₁.getReg .x2 - 312#64) fvs₁)
    (hws₁ : HasCells s₁ (s₁.getReg .x2 - 280#64) fws₁)
    (hsv₁ : HasWords s₁ (s₁.getReg .x2 - 24#64) sv₁)
    (hh₂ : HasCells s₂ (s₂.getReg .x10) H₂) (hm₂ : HasCells s₂ (s₂.getReg .x11) M₂)
    (hk₂ : HasCells s₂ 0x10368#64 K)
    (hv₂ : HasCells s₂ (s₂.getReg .x2 - 312#64) fvs₂)
    (hws₂ : HasCells s₂ (s₂.getReg .x2 - 280#64) fws₂)
    (hsv₂ : HasWords s₂ (s₂.getReg .x2 - 24#64) sv₂)
    (hhm : Apart (s₁.getReg .x10) 32 (s₁.getReg .x11) 64)
    (hhk : Apart (s₁.getReg .x10) 32 0x10368#64 256)
    (hhs : Apart (s₁.getReg .x10) 32 (s₁.getReg .x2 - 312#64) 312)
    (hmk : Apart (s₁.getReg .x11) 64 0x10368#64 256)
    (hms : Apart (s₁.getReg .x11) 64 (s₁.getReg .x2 - 312#64) 312)
    (hks : Apart 0x10368#64 256 (s₁.getReg .x2 - 312#64) 312)
    (e10 : s₂.getReg .x10 = s₁.getReg .x10) (e11 : s₂.getReg .x11 = s₁.getReg .x11)
    (e2 : s₂.getReg .x2 = s₁.getReg .x2) (e1 : s₂.getReg .x1 = s₁.getReg .x1) :
    ∃ tr s₁' s₂', RunL s₁ tr s₁' ∧ RunL s₂ tr s₂' ∧
      s₁'.pc = s₁.getReg .x1 &&& ~~~1#64 ∧ s₂'.pc = s₁.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨s₁', h₁, hp₁⟩ := sha256_compress_leakage s₁ H₁ M₁ fvs₁ fws₁ sv₁ hcode₁ hpc₁ hH₁ hM₁
    hfv₁ hfw₁ hsvl₁ hhp hmp hsp hh₁ hm₁ hk₁ hv₁ hws₁ hsv₁ hhm hhk hhs hmk hms hks
  obtain ⟨s₂', h₂, hp₂⟩ := sha256_compress_leakage s₂ H₂ M₂ fvs₂ fws₂ sv₂ hcode₂ hpc₂ hH₂ hM₂
    hfv₂ hfw₂ hsvl₂ (by rw [e10]; exact hhp) (by rw [e11]; exact hmp) (by rw [e2]; exact hsp)
    hh₂ hm₂ hk₂ hv₂ hws₂ hsv₂ (by rw [e10, e11]; exact hhm) (by rw [e10]; exact hhk)
    (by rw [e10, e2]; exact hhs) (by rw [e11]; exact hmk) (by rw [e11, e2]; exact hms)
    (by rw [e2]; exact hks)
  simp only [e10, e11, e2, e1] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.Sha256.RiscV
