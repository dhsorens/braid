/-
  Examples.Sha256.O2.Arm.LeakMachine

  What SHA-256 reveals on the AArch64 machine, compiled at `-O2` (`docs/Leakage.md`): the
  traced triples of
  `LeakRound`, `LeakSchedule` and `LeakCompress`, as theorems about the machine model alone.
  Each function has two. `<f>_leakage` says that the trace of the run is an explicit function
  of public inputs: the addresses the function is given, the stack pointer where it uses the
  stack, and the return address. `<f>_leakage_eq` says that two machines that agree on those
  inputs run with the same trace, whatever the working variables, the block, the hash value
  and the stack hold. No branch and no address of the compiled code depends on that data.

  The public inputs of each function are those of `-O1`. For `sha256_round` and
  `sha256_schedule` the statements and the proofs are those of
  `Examples.Sha256.Arm.LeakMachine`, word for word. For `sha256_compress` the hypotheses
  follow the frame of this binary: 320 bytes below the stack pointer, the schedule, the frame
  pointer and six saved registers, with no copy of the working variables, and the round
  constants at `0x20264`.

  ## Main results

  * `sha256_round_leakage`, `sha256_round_leakage_eq`
  * `sha256_schedule_leakage`, `sha256_schedule_leakage_eq`
  * `sha256_compress_leakage`, `sha256_compress_leakage_eq`
-/

module

public import Examples.Sha256.O2.Arm.LeakRound
public import Examples.Sha256.O2.Arm.LeakSchedule
public import Examples.Sha256.O2.Arm.LeakCompress

public section

namespace Examples.Sha256.O2.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs
open Examples.Sha256.Arm

/-! ## The round -/

/-- **What `sha256_round` reveals, on the machine.** A running machine whose program holds
the words of `sha256_round`, with its code loaded and its program counter at the entry, and
with the eight working variables `v` in memory where `x0` points, runs to the address in the
link register with the trace `roundLeak` of `x0` and the link register. The round constant
in `x1` and the word of the schedule in `x2` are not in the trace, and neither are the
working variables. -/
theorem sha256_round_leakage (prog : Arm64.Program) (s : Arm64.State) (v : Vars)
    (hw : prog.hasWords 0x10000#64 sha256_round_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64)
    (hv : HasCells s (s.regs.read 0#5) v.toList) :
    ∃ s', RunL prog s (roundLeak (s.regs.read 0#5) (s.regs.read 30#5)) s' ∧
      s'.pc = s.regs.read 30#5 := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_soundT sha256_round_lowered
    (sha256_round_trace (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 2#5)
      (s.regs.read 30#5) v (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5)
      (s.regs.read 11#5) (s.regs.read 12#5) (s.regs.read 13#5) (s.regs.read 14#5)
      (s.regs.read 15#5) (s.regs.read 16#5) (s.regs.read 17#5) (s.regs.read 18#5) [])
    hw hc hrun
    (flat := [.pc 0x10000#64, .reg x0 (s.regs.read 0#5), .reg x1 (s.regs.read 1#5),
      .reg x2 (s.regs.read 2#5), .reg x8 (s.regs.read 8#5), .reg x9 (s.regs.read 9#5),
      .reg x10 (s.regs.read 10#5), .reg x11 (s.regs.read 11#5), .reg x12 (s.regs.read 12#5),
      .reg x13 (s.regs.read 13#5), .reg x14 (s.regs.read 14#5), .reg x15 (s.regs.read 15#5),
      .reg x16 (s.regs.read 16#5), .reg x17 (s.regs.read 17#5), .reg x18 (s.regs.read 18#5),
      .reg lr (s.regs.read 30#5)] ++ (cellsAtoms 4 true (s.regs.read 0#5) (w32s v.toList) ++ []))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [Vars.toList]), .nil,
        disj_nil_right⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_pc, regOf, hpc],
        List.forall_mem_append.2 ⟨hv.sat, by simp⟩⟩)
  rw [List.nil_append] at hsteps
  refine ⟨s', hsteps, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`sha256_round` reveals nothing of the words it works on.** Two running machines that
hold the words of `sha256_round`, with their code loaded and at its entry, each with eight
working variables where `x0` points, and that agree on `x0` and on the link register, run
with the same trace, whatever the working variables, the round constant in `x1` and the word
of the schedule in `x2` of each are. -/
theorem sha256_round_leakage_eq (prog₁ prog₂ : Arm64.Program) (s₁ s₂ : Arm64.State)
    (v₁ v₂ : Vars)
    (hw₁ : prog₁.hasWords 0x10000#64 sha256_round_words) (hc₁ : prog₁.CodeLoaded s₁.mem)
    (hw₂ : prog₂.hasWords 0x10000#64 sha256_round_words) (hc₂ : prog₂.CodeLoaded s₂.mem)
    (hrun₁ : s₁.status = .Running) (hrun₂ : s₂.status = .Running)
    (hpc₁ : s₁.pc = 0x10000#64) (hpc₂ : s₂.pc = 0x10000#64)
    (hv₁ : HasCells s₁ (s₁.regs.read 0#5) v₁.toList)
    (hv₂ : HasCells s₂ (s₂.regs.read 0#5) v₂.toList)
    (e0 : s₂.regs.read 0#5 = s₁.regs.read 0#5)
    (e30 : s₂.regs.read 30#5 = s₁.regs.read 30#5) :
    ∃ tr s₁' s₂', RunL prog₁ s₁ tr s₁' ∧ RunL prog₂ s₂ tr s₂' ∧
      s₁'.pc = s₁.regs.read 30#5 ∧ s₂'.pc = s₁.regs.read 30#5 := by
  obtain ⟨s₁', h₁, hp₁⟩ := sha256_round_leakage prog₁ s₁ v₁ hw₁ hc₁ hrun₁ hpc₁ hv₁
  obtain ⟨s₂', h₂, hp₂⟩ := sha256_round_leakage prog₂ s₂ v₂ hw₂ hc₂ hrun₂ hpc₂ hv₂
  simp only [e0, e30] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

/-! ## The message schedule -/

/-- **What `sha256_schedule` reveals, on the machine.** A running machine whose program
holds the words of `sha256_schedule`, with its code loaded and its program counter at the
entry, and with 64 words in memory where `x0` points (the block `M` and 48 words `js` after
it), runs to the address in the link register with the trace `scheduleLeak` of `x0` and the
link register. The block is not in the trace. -/
theorem sha256_schedule_leakage (prog : Arm64.Program) (s : Arm64.State) (M js : List W32)
    (hw : prog.hasWords 0x10074#64 sha256_schedule_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10074#64)
    (hM : M.length = 16) (hjs : js.length = 48)
    (hm : HasCells s (s.regs.read 0#5) (M ++ js)) :
    ∃ s', RunL prog s (scheduleLeak (s.regs.read 0#5) (s.regs.read 30#5)) s' ∧
      s'.pc = s.regs.read 30#5 := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_soundT sha256_schedule_lowered
    (sha256_schedule_trace (s.regs.read 0#5) (s.regs.read 30#5) (s.regs.read 8#5)
      (s.regs.read 9#5) (s.regs.read 10#5) (s.regs.read 11#5) (s.regs.read 12#5)
      (s.regs.read 13#5) (s.regs.read 14#5) (s.regs.read 15#5) M (w32s js) s.pstate.n
      s.pstate.z s.pstate.c s.pstate.v hM (by simpa using hjs) []) hw hc hrun
    (flat := [.pc 0x10074#64, .reg x0 (s.regs.read 0#5), .reg x8 (s.regs.read 8#5),
      .reg x9 (s.regs.read 9#5), .reg x10 (s.regs.read 10#5), .reg x11 (s.regs.read 11#5),
      .reg x12 (s.regs.read 12#5), .reg x13 (s.regs.read 13#5), .reg x14 (s.regs.read 14#5),
      .reg x15 (s.regs.read 15#5), .reg lr (s.regs.read 30#5), .flag Flags.n s.pstate.n,
      .flag Flags.z s.pstate.z, .flag Flags.c s.pstate.c, .flag Flags.v s.pstate.v] ++
      (cellsAtoms 4 true (s.regs.read 0#5) (w32s M ++ w32s js) ++ []))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hM, hjs]), .nil,
        disj_nil_right⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
          Flags.v, hpc],
        List.forall_mem_append.2 ⟨by rw [← w32s_append]; exact hm.sat, by simp⟩⟩)
  rw [List.nil_append] at hsteps
  refine ⟨s', hsteps, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`sha256_schedule` reveals nothing of the block.** Two running machines that hold the
words of `sha256_schedule`, with their code loaded and at its entry, each with 64 words in
memory where `x0` points, and that agree on `x0` and on the link register, run with the same
trace, whatever the 64 words of each are. -/
theorem sha256_schedule_leakage_eq (prog₁ prog₂ : Arm64.Program) (s₁ s₂ : Arm64.State)
    (M₁ js₁ M₂ js₂ : List W32)
    (hw₁ : prog₁.hasWords 0x10074#64 sha256_schedule_words) (hc₁ : prog₁.CodeLoaded s₁.mem)
    (hw₂ : prog₂.hasWords 0x10074#64 sha256_schedule_words) (hc₂ : prog₂.CodeLoaded s₂.mem)
    (hrun₁ : s₁.status = .Running) (hrun₂ : s₂.status = .Running)
    (hpc₁ : s₁.pc = 0x10074#64) (hpc₂ : s₂.pc = 0x10074#64)
    (hM₁ : M₁.length = 16) (hjs₁ : js₁.length = 48)
    (hM₂ : M₂.length = 16) (hjs₂ : js₂.length = 48)
    (hm₁ : HasCells s₁ (s₁.regs.read 0#5) (M₁ ++ js₁))
    (hm₂ : HasCells s₂ (s₂.regs.read 0#5) (M₂ ++ js₂))
    (e0 : s₂.regs.read 0#5 = s₁.regs.read 0#5)
    (e30 : s₂.regs.read 30#5 = s₁.regs.read 30#5) :
    ∃ tr s₁' s₂', RunL prog₁ s₁ tr s₁' ∧ RunL prog₂ s₂ tr s₂' ∧
      s₁'.pc = s₁.regs.read 30#5 ∧ s₂'.pc = s₁.regs.read 30#5 := by
  obtain ⟨s₁', h₁, hp₁⟩ :=
    sha256_schedule_leakage prog₁ s₁ M₁ js₁ hw₁ hc₁ hrun₁ hpc₁ hM₁ hjs₁ hm₁
  obtain ⟨s₂', h₂, hp₂⟩ :=
    sha256_schedule_leakage prog₂ s₂ M₂ js₂ hw₂ hc₂ hrun₂ hpc₂ hM₂ hjs₂ hm₂
  simp only [e0, e30] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

/-! ## The compression function -/

/-- **What `sha256_compress` reveals, on the machine.** A machine under the hypotheses of
`sha256_compress_correct` (it is running, its program holds the words of `sha256_compress`,
its code is loaded and its program counter is at the entry; it has the hash value `H`, eight
words, in memory where `x0` points, the block `M`, sixteen words, where `x1` points, and the
round constants of SHA-256 in read-only memory at `0x20264`, where the code looks for them;
its stack pointer is aligned to sixteen bytes and has 320 bytes of memory below it, here
64 words `fws`, a double word `sv` and, eight bytes further, six double words `svs`; the
hash value, the block and those 320 bytes are pairwise apart) runs to the address in the
link register with the trace `compressLeak` of `x0`, `x1`, the stack pointer and the link
register. Neither the hash value nor the block is in the trace: the compiled code has no
branch and no address that depends on them. -/
theorem sha256_compress_leakage (prog : Arm64.Program) (s : Arm64.State)
    (H M fws : List W32) (sv : Word) (svs : List Word)
    (hw : prog.hasWords 0x100bc#64 sha256_compress_words)
    (hc : prog.CodeLoaded s.mem) (hrun : s.status = .Running) (hpc : s.pc = 0x100bc#64)
    (hH : H.length = 8) (hM : M.length = 16) (hfw : fws.length = 64) (hsvl : svs.length = 6)
    (hsp : s.sp &&& 15#64 = 0#64)
    (hh : HasCells s (s.regs.read 0#5) H) (hm : HasCells s (s.regs.read 1#5) M)
    (hk : HasReadOnlyCells s 0x20264#64 K)
    (hws : HasCells s (s.sp - 0x140#64) fws) (hsv : HasBytes s (s.sp - 0x40#64) 8 sv)
    (hsvs : HasWords s (s.sp - 0x30#64) svs)
    (hhm : Apart (s.regs.read 0#5) 32 (s.regs.read 1#5) 64)
    (hhs : Apart (s.regs.read 0#5) 32 (s.sp - 0x140#64) 320)
    (hms : Apart (s.regs.read 1#5) 64 (s.sp - 0x140#64) 320) :
    ∃ s', RunL prog s
        (compressLeak (s.regs.read 0#5) (s.regs.read 1#5) s.sp (s.regs.read 30#5)) s' ∧
      s'.pc = s.regs.read 30#5 := by
  obtain ⟨hhm1, hhm2⟩ := hhm
  obtain ⟨hhs1, hhs2⟩ := hhs
  obtain ⟨hms1, hms2⟩ := hms
  have hsvw : ∀ a ∈ cellsAtoms 8 true (s.sp - 0x40#64) [sv], a.sat (abs s) := by
    simpa [cellsAtoms] using sat_mem_hasBytes.2 hsv
  have hlK : K.length = 64 := rfl
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_soundT sha256_compress_lowered
    (sha256_compress_trace (s.regs.read 0#5) (s.regs.read 1#5) s.sp (s.regs.read 30#5)
      (s.regs.read 29#5) sv H M true (w32s fws) svs (s.regs.read 2#5)
      (s.regs.read 3#5) (s.regs.read 4#5) (s.regs.read 5#5) (s.regs.read 6#5)
      (s.regs.read 7#5) (s.regs.read 8#5)
      (s.regs.read 9#5) (s.regs.read 10#5) (s.regs.read 11#5) (s.regs.read 12#5)
      (s.regs.read 13#5) (s.regs.read 14#5) (s.regs.read 15#5) (s.regs.read 16#5)
      (s.regs.read 17#5) (s.regs.read 18#5) (s.regs.read 19#5) (s.regs.read 20#5)
      (s.regs.read 21#5) (s.regs.read 22#5) (s.regs.read 23#5) (s.regs.read 24#5)
      s.pstate.n s.pstate.z s.pstate.c s.pstate.v
      hH hM (by simpa using hfw) hsvl hsp []) hw hc hrun
    (flat := [.pc 0x100bc#64, .reg x0 (s.regs.read 0#5), .reg x1 (s.regs.read 1#5),
      .reg x2 (s.regs.read 2#5), .reg x3 (s.regs.read 3#5), .reg x4 (s.regs.read 4#5),
      .reg x5 (s.regs.read 5#5), .reg x6 (s.regs.read 6#5), .reg x7 (s.regs.read 7#5),
      .reg x8 (s.regs.read 8#5), .reg x9 (s.regs.read 9#5),
      .reg x10 (s.regs.read 10#5), .reg x11 (s.regs.read 11#5), .reg x12 (s.regs.read 12#5),
      .reg x13 (s.regs.read 13#5), .reg x14 (s.regs.read 14#5), .reg x15 (s.regs.read 15#5),
      .reg x16 (s.regs.read 16#5), .reg x17 (s.regs.read 17#5), .reg x18 (s.regs.read 18#5),
      .reg x19 (s.regs.read 19#5), .reg x20 (s.regs.read 20#5), .reg x21 (s.regs.read 21#5),
      .reg x22 (s.regs.read 22#5), .reg x23 (s.regs.read 23#5), .reg x24 (s.regs.read 24#5),
      .reg x29 (s.regs.read 29#5), .reg lr (s.regs.read 30#5), .reg sp s.sp,
      .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z, .flag Flags.c s.pstate.c,
      .flag Flags.v s.pstate.v] ++
      (cellsAtoms 4 true (s.regs.read 0#5) (w32s H) ++
      (cellsAtoms 4 true (s.regs.read 1#5) (w32s M) ++
      (cellsAtoms 4 false 0x20264#64 (w32s K) ++
      (cellsAtoms 4 true (s.sp - 0x140#64) (w32s fws) ++
      (cellsAtoms 8 true (s.sp - 0x40#64) [sv] ++
      (cellsAtoms 8 true (s.sp - 0x30#64) svs ++ [])))))))
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
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hfw]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hsvl]), .nil, disj_nil_right⟩,
        -- the frame pointer, and what follows it
        disj_append_right (cellsAtoms_disj (by simp; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right⟩,
        -- the schedule, and what follows it
        disj_append_right (cellsAtoms_disj (by simp [hfw]; bv_omega) (by simp; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hfw]; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right)⟩,
        -- the round constants, and what follows them
        disj_append_right (disj_flip (cellsAtoms_disj_readOnly hws.sat hk.sat))
          (disj_append_right (disj_flip (cellsAtoms_disj_readOnly hsvw hk.sat))
          (disj_append_right (disj_flip (cellsAtoms_disj_readOnly hsvs.sat hk.sat))
          disj_nil_right))⟩,
        -- the block, and what follows it
        disj_append_right (cellsAtoms_disj_readOnly hm.sat hk.sat)
          (disj_append_right (cellsAtoms_disj (by simp [hM]; bv_omega) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hM]; bv_omega) (by simp; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hM]; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right)))⟩,
        -- the hash value, and what follows it
        disj_append_right (cellsAtoms_disj (by rw [w32s_length, hH]; exact hhm1)
            (by rw [w32s_length, hM]; exact hhm2))
          (disj_append_right (cellsAtoms_disj_readOnly hh.sat hk.sat)
          (disj_append_right (cellsAtoms_disj (by simp [hH]; bv_omega) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hH]; bv_omega) (by simp; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hH]; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right))))⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
          Flags.v, hpc],
        List.forall_mem_append.2 ⟨hh.sat,
        List.forall_mem_append.2 ⟨hm.sat,
        List.forall_mem_append.2 ⟨hk.sat,
        List.forall_mem_append.2 ⟨hws.sat,
        List.forall_mem_append.2 ⟨hsvw,
        List.forall_mem_append.2 ⟨hsvs.sat, by simp⟩⟩⟩⟩⟩⟩⟩)
  rw [List.nil_append] at hsteps
  refine ⟨s', hsteps, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`sha256_compress` reveals nothing of the hash value or the block.** Two machines that
each satisfy the hypotheses of `sha256_compress_leakage`, with hash values `H₁` and `H₂`,
blocks `M₁` and `M₂` and any contents of the 320 bytes of stack, and that agree on the two
pointers `x0` and `x1`, on the stack pointer and on the link register, run with the same
trace. The hypotheses on the alignment of the stack pointer and on the regions being apart
are asked of the first machine, and hold of the second as the two agree on the addresses. -/
theorem sha256_compress_leakage_eq (prog₁ prog₂ : Arm64.Program) (s₁ s₂ : Arm64.State)
    (H₁ M₁ fws₁ H₂ M₂ fws₂ : List W32) (sv₁ sv₂ : Word) (svs₁ svs₂ : List Word)
    (hw₁ : prog₁.hasWords 0x100bc#64 sha256_compress_words) (hc₁ : prog₁.CodeLoaded s₁.mem)
    (hw₂ : prog₂.hasWords 0x100bc#64 sha256_compress_words) (hc₂ : prog₂.CodeLoaded s₂.mem)
    (hrun₁ : s₁.status = .Running) (hrun₂ : s₂.status = .Running)
    (hpc₁ : s₁.pc = 0x100bc#64) (hpc₂ : s₂.pc = 0x100bc#64)
    (hH₁ : H₁.length = 8) (hM₁ : M₁.length = 16) (hfw₁ : fws₁.length = 64)
    (hsvl₁ : svs₁.length = 6)
    (hH₂ : H₂.length = 8) (hM₂ : M₂.length = 16) (hfw₂ : fws₂.length = 64)
    (hsvl₂ : svs₂.length = 6)
    (hsp : s₁.sp &&& 15#64 = 0#64)
    (hh₁ : HasCells s₁ (s₁.regs.read 0#5) H₁) (hm₁ : HasCells s₁ (s₁.regs.read 1#5) M₁)
    (hk₁ : HasReadOnlyCells s₁ 0x20264#64 K)
    (hws₁ : HasCells s₁ (s₁.sp - 0x140#64) fws₁) (hsv₁ : HasBytes s₁ (s₁.sp - 0x40#64) 8 sv₁)
    (hsvs₁ : HasWords s₁ (s₁.sp - 0x30#64) svs₁)
    (hh₂ : HasCells s₂ (s₂.regs.read 0#5) H₂) (hm₂ : HasCells s₂ (s₂.regs.read 1#5) M₂)
    (hk₂ : HasReadOnlyCells s₂ 0x20264#64 K)
    (hws₂ : HasCells s₂ (s₂.sp - 0x140#64) fws₂) (hsv₂ : HasBytes s₂ (s₂.sp - 0x40#64) 8 sv₂)
    (hsvs₂ : HasWords s₂ (s₂.sp - 0x30#64) svs₂)
    (hhm : Apart (s₁.regs.read 0#5) 32 (s₁.regs.read 1#5) 64)
    (hhs : Apart (s₁.regs.read 0#5) 32 (s₁.sp - 0x140#64) 320)
    (hms : Apart (s₁.regs.read 1#5) 64 (s₁.sp - 0x140#64) 320)
    (e0 : s₂.regs.read 0#5 = s₁.regs.read 0#5) (e1 : s₂.regs.read 1#5 = s₁.regs.read 1#5)
    (esp : s₂.sp = s₁.sp) (e30 : s₂.regs.read 30#5 = s₁.regs.read 30#5) :
    ∃ tr s₁' s₂', RunL prog₁ s₁ tr s₁' ∧ RunL prog₂ s₂ tr s₂' ∧
      s₁'.pc = s₁.regs.read 30#5 ∧ s₂'.pc = s₁.regs.read 30#5 := by
  obtain ⟨s₁', h₁, hp₁⟩ := sha256_compress_leakage prog₁ s₁ H₁ M₁ fws₁ sv₁ svs₁ hw₁ hc₁ hrun₁
    hpc₁ hH₁ hM₁ hfw₁ hsvl₁ hsp hh₁ hm₁ hk₁ hws₁ hsv₁ hsvs₁ hhm hhs hms
  obtain ⟨s₂', h₂, hp₂⟩ := sha256_compress_leakage prog₂ s₂ H₂ M₂ fws₂ sv₂ svs₂ hw₂ hc₂ hrun₂
    hpc₂ hH₂ hM₂ hfw₂ hsvl₂ (by rw [esp]; exact hsp) hh₂ hm₂ hk₂ hws₂ hsv₂ hsvs₂
    (by rw [e0, e1]; exact hhm) (by rw [e0, esp]; exact hhs) (by rw [e1, esp]; exact hms)
  simp only [e0, e1, esp, e30] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.Sha256.O2.Arm
