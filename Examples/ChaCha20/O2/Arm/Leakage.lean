/-
  Examples.ChaCha20.O2.Arm.Leakage

  What `chacha20_block` reveals on AArch64, compiled at `-O2`, about the machine alone
  (`docs/Leakage.md`). The traced triple is `chacha20_block_trace` of
  `Examples.ChaCha20.O2.Arm.LeakBlock`; here it is carried to the machine model, and the
  two-run statement is drawn from it.

  The code neither branches nor indexes on the words of the state: its one loop runs a
  fixed number of times, and every address is an offset from one of the two pointers or
  from the stack pointer. So the public inputs are the two pointers, the stack pointer and
  the return address, and the sixteen words of the input are secret. These are the public
  inputs of `-O1`; the hypotheses differ from those of `Examples.ChaCha20.Arm.Leakage` only
  in the frame, which is 48 bytes with five saved registers where it was 96 bytes with a copy
  of the state.

  ## Main results

  * `chacha20_block_leakage`: the trace of the run is `blockLeak` of the public inputs
  * `chacha20_block_leakage_eq`: two machines that agree on the public inputs run with the
    same trace, whatever the input, the output and the saved registers' cells hold
-/

module

public import Examples.ChaCha20.O2.Arm.LeakBlock

public section

namespace Examples.ChaCha20.O2.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- **What `chacha20_block` reveals, on the machine.** A running machine whose program holds
the words of `chacha20_block`, with its code loaded and its program counter at the entry,
with the sixteen 32-bit words `s` in memory where `x1` points, sixteen 32-bit cells `os`
where `x0` points, and a stack pointer that is a multiple of 16 with memory below it for
five saved registers (the 64-bit cell `m`, 48 bytes below, and the four 64-bit cells `sv`,
32 bytes below), the input and the output apart from one another and from the 48 bytes below
the stack pointer, runs to the address in the link register with the trace `blockLeak` of
`x0`, `x1`, the stack pointer and the link register. The trace does not mention `s`, `os`,
`m` or `sv`. -/
theorem chacha20_block_leakage (prog : Arm64.Program) (st : Arm64.State) (s : List W32)
    (os sv : List Word) (m : Word) (hw : prog.hasWords 0x10044#64 chacha20_block_words)
    (hc : prog.CodeLoaded st.mem) (hrun : st.status = .Running) (hpc : st.pc = 0x10044#64)
    (hsp : st.sp &&& 15#64 = 0#64) (hs : s.length = 16) (hos : os.length = 16)
    (hsv : sv.length = 4)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes st (st.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hout : ∀ (i : Nat) (hi : i < os.length),
      HasBytes st (st.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) 4 os[i])
    (hfoot : HasBytes st (st.sp - 48#64) 8 m)
    (hsaved : ∀ (i : Nat) (hi : i < sv.length),
      HasBytes st (st.sp - 32#64 + BitVec.ofNat 64 (8 * i)) 8 sv[i])
    (hio : Apart (st.regs.read 1#5) 64 (st.regs.read 0#5) 64)
    (his : Apart (st.regs.read 1#5) 64 (st.sp - 48#64) 48)
    (hos' : Apart (st.regs.read 0#5) 64 (st.sp - 48#64) 48) :
    ∃ st', RunL prog st (blockLeak (st.regs.read 0#5) (st.regs.read 1#5) st.sp
        (st.regs.read 30#5)) st' ∧ st'.pc = st.regs.read 30#5 := by
  obtain ⟨hio₁, hio₂⟩ := hio
  obtain ⟨his₁, his₂⟩ := his
  obtain ⟨hos₁, hos₂⟩ := hos'
  have hrest : ∀ b ∈ ([.pc 0x10044#64, .reg x0 (st.regs.read 0#5), .reg x1 (st.regs.read 1#5),
      .reg x2 (st.regs.read 2#5), .reg x3 (st.regs.read 3#5), .reg x4 (st.regs.read 4#5),
      .reg x5 (st.regs.read 5#5), .reg x6 (st.regs.read 6#5), .reg x7 (st.regs.read 7#5),
      .reg x8 (st.regs.read 8#5), .reg x9 (st.regs.read 9#5), .reg x10 (st.regs.read 10#5),
      .reg x11 (st.regs.read 11#5), .reg x12 (st.regs.read 12#5), .reg x13 (st.regs.read 13#5),
      .reg x14 (st.regs.read 14#5), .reg x15 (st.regs.read 15#5), .reg x16 (st.regs.read 16#5),
      .reg x17 (st.regs.read 17#5), .reg x18 (st.regs.read 18#5),
      .reg x19 (st.regs.read 19#5), .reg x20 (st.regs.read 20#5),
      .reg x21 (st.regs.read 21#5), .reg x22 (st.regs.read 22#5), .reg x23 (st.regs.read 23#5),
      .reg sp st.sp, .reg lr (st.regs.read 30#5), .flag Flags.n st.pstate.n,
      .flag Flags.z st.pstate.z, .flag Flags.c st.pstate.c, .flag Flags.v st.pstate.v] : Atoms),
      ∀ q n v w', Atom.Disj b (.mem q n v w') := by
    braid_not_mem
  obtain ⟨st', σ', hsteps, hr, hq⟩ := machine_soundT chacha20_block_lowered
    (chacha20_block_trace (st.regs.read 0#5) (st.regs.read 1#5) (st.regs.read 30#5) st.sp s os
      sv m
      (st.regs.read 2#5) (st.regs.read 3#5) (st.regs.read 4#5) (st.regs.read 5#5)
      (st.regs.read 6#5) (st.regs.read 7#5) (st.regs.read 8#5) (st.regs.read 9#5)
      (st.regs.read 10#5) (st.regs.read 11#5) (st.regs.read 12#5) (st.regs.read 13#5)
      (st.regs.read 14#5) (st.regs.read 15#5) (st.regs.read 16#5) (st.regs.read 17#5)
      (st.regs.read 18#5)
      (st.regs.read 19#5) (st.regs.read 20#5) (st.regs.read 21#5) (st.regs.read 22#5)
      (st.regs.read 23#5) st.pstate.n st.pstate.z st.pstate.c st.pstate.v hs hos hsv hsp [])
    hw hc hrun
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2
      ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
        List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp [Atom.IsPointsTo]⟩⟩⟩⟩)
    (pairwise_cells_append (by simp [hs])
      (pairwise_cells_append (by simp [hos])
        (pairwise_cells_append (by simp)
          (pairwise_cells_append (by simp [hsv])
            (by braid_disj; repeat' apply And.intro
                all_goals decide)
            (disj_cellsAtoms_rest hrest))
          (disj_append
            (cellsAtoms_disj (by rw [List.length_singleton]; bv_omega) (by rw [hsv]; bv_omega))
            (disj_cellsAtoms_rest hrest)))
        (disj_append
          (cellsAtoms_disj (by rw [hos]; bv_omega) (by rw [List.length_singleton]; bv_omega))
          (disj_append
            (cellsAtoms_disj (by rw [hos]; bv_omega) (by rw [hsv]; bv_omega))
            (disj_cellsAtoms_rest hrest))))
      (disj_append
        (cellsAtoms_disj (by rw [List.length_map, hs]; exact hio₁) (by rw [hos]; exact hio₂))
        (disj_append
          (cellsAtoms_disj (by rw [List.length_map, hs]; bv_omega)
            (by rw [List.length_singleton]; bv_omega))
          (disj_append
            (cellsAtoms_disj (by rw [List.length_map, hs]; bv_omega) (by rw [hsv]; bv_omega))
            (disj_cellsAtoms_rest hrest)))))
    (List.forall_mem_append.2
      ⟨cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (by simpa using hin i (by simpa using hi)),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (hout i hi),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (by
        obtain rfl : i = 0 := by simpa using hi
        simpa using hfoot),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (hsaved i hi),
        by
          simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
            and_true, Atom.sat_reg, Atom.sat_flag, Atom.sat_pc]
          repeat' apply And.intro
          all_goals first | exact hpc | rfl⟩⟩⟩⟩)
  refine ⟨st', hsteps, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`chacha20_block` reveals nothing of the state it works on.** Two running machines that
hold the words of `chacha20_block`, with their code loaded and at its entry, and that agree
on `x0`, `x1`, the stack pointer and the link register, the stack pointer a multiple of 16
and the input, the output and the saved registers' cells in memory and apart as
`chacha20_block_leakage` asks, run with the same trace, whatever sixteen words each has as
input (`s₁`, `s₂`), and whatever each has in the output and below the stack pointer. -/
theorem chacha20_block_leakage_eq (prog₁ prog₂ : Arm64.Program) (st₁ st₂ : Arm64.State)
    (s₁ s₂ : List W32) (os₁ sv₁ os₂ sv₂ : List Word) (m₁ m₂ : Word)
    (hw₁ : prog₁.hasWords 0x10044#64 chacha20_block_words) (hc₁ : prog₁.CodeLoaded st₁.mem)
    (hw₂ : prog₂.hasWords 0x10044#64 chacha20_block_words) (hc₂ : prog₂.CodeLoaded st₂.mem)
    (hrun₁ : st₁.status = .Running) (hrun₂ : st₂.status = .Running)
    (hpc₁ : st₁.pc = 0x10044#64) (hpc₂ : st₂.pc = 0x10044#64)
    (hsp : st₁.sp &&& 15#64 = 0#64)
    (hs₁ : s₁.length = 16) (hos₁ : os₁.length = 16) (hsv₁ : sv₁.length = 4)
    (hs₂ : s₂.length = 16) (hos₂ : os₂.length = 16) (hsv₂ : sv₂.length = 4)
    (hin₁ : ∀ (i : Nat) (hi : i < s₁.length),
      HasBytes st₁ (st₁.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) 4 (s₁[i].zeroExtend 64))
    (hout₁ : ∀ (i : Nat) (hi : i < os₁.length),
      HasBytes st₁ (st₁.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) 4 os₁[i])
    (hfoot₁ : HasBytes st₁ (st₁.sp - 48#64) 8 m₁)
    (hsaved₁ : ∀ (i : Nat) (hi : i < sv₁.length),
      HasBytes st₁ (st₁.sp - 32#64 + BitVec.ofNat 64 (8 * i)) 8 sv₁[i])
    (hin₂ : ∀ (i : Nat) (hi : i < s₂.length),
      HasBytes st₂ (st₂.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) 4 (s₂[i].zeroExtend 64))
    (hout₂ : ∀ (i : Nat) (hi : i < os₂.length),
      HasBytes st₂ (st₂.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) 4 os₂[i])
    (hfoot₂ : HasBytes st₂ (st₂.sp - 48#64) 8 m₂)
    (hsaved₂ : ∀ (i : Nat) (hi : i < sv₂.length),
      HasBytes st₂ (st₂.sp - 32#64 + BitVec.ofNat 64 (8 * i)) 8 sv₂[i])
    (hio : Apart (st₁.regs.read 1#5) 64 (st₁.regs.read 0#5) 64)
    (his : Apart (st₁.regs.read 1#5) 64 (st₁.sp - 48#64) 48)
    (hos : Apart (st₁.regs.read 0#5) 64 (st₁.sp - 48#64) 48)
    (e0 : st₂.regs.read 0#5 = st₁.regs.read 0#5) (e1 : st₂.regs.read 1#5 = st₁.regs.read 1#5)
    (esp : st₂.sp = st₁.sp) (e30 : st₂.regs.read 30#5 = st₁.regs.read 30#5) :
    ∃ tr st₁' st₂', RunL prog₁ st₁ tr st₁' ∧ RunL prog₂ st₂ tr st₂' ∧
      st₁'.pc = st₁.regs.read 30#5 ∧ st₂'.pc = st₁.regs.read 30#5 := by
  obtain ⟨st₁', h₁, hp₁⟩ := chacha20_block_leakage prog₁ st₁ s₁ os₁ sv₁ m₁ hw₁ hc₁ hrun₁
    hpc₁ hsp hs₁ hos₁ hsv₁ hin₁ hout₁ hfoot₁ hsaved₁ hio his hos
  obtain ⟨st₂', h₂, hp₂⟩ := chacha20_block_leakage prog₂ st₂ s₂ os₂ sv₂ m₂ hw₂ hc₂ hrun₂
    hpc₂ (esp ▸ hsp) hs₂ hos₂ hsv₂ hin₂ hout₂ hfoot₂ hsaved₂
    (by rw [e0, e1]; exact hio) (by rw [e1, esp]; exact his) (by rw [e0, esp]; exact hos)
  simp only [e0, e1, esp, e30] at h₂ hp₂
  exact ⟨_, st₁', st₂', h₁, h₂, hp₁, hp₂⟩

end Examples.ChaCha20.O2.Arm
