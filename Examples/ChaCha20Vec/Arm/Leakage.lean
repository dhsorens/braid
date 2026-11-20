/-
  Examples.ChaCha20Vec.Arm.Leakage

  What `chacha20_block_vec` reveals on AArch64, about the machine alone
  (`docs/Leakage.md`). The traced triple is `block_vec_run` of
  `Examples.ChaCha20Vec.Arm.LeakBlock`, whose trace the run found; here it is carried to the
  machine model, and the two-run statement is drawn from it.

  The code neither branches nor indexes on the words of the state: its loop runs ten times,
  and every address is an offset from one of the two pointers. It has no frame. So the
  public inputs are the two pointers and the return address, and the sixteen words of the
  input are secret, as is whatever the output and the vector registers hold.

  ## Main results

  * `chacha20_block_vec_leakage`: the trace of the run is `blockVecLeak` of the public
    inputs
  * `chacha20_block_vec_leakage_eq`: two machines that agree on the public inputs run with
    the same trace, whatever the input and the output hold
-/

module

public import Examples.ChaCha20Vec.Arm.LeakBlock

public section

namespace Examples.ChaCha20Vec.Arm

open Braid Examples Examples.ChaCha20 Lowering.Arm Lowering.Arm.Regs

/-- **What `chacha20_block_vec` reveals, on the machine.** A running machine runs to the
address in the link register with the trace `blockVecLeak` of `x0`, `x1` and the link
register, which `blockVecLeak_eq` writes out. The trace does not mention `s` or `os`. The
hypotheses ask that

* `hw`: the program holds the words of `chacha20_block_vec` from `0x10000`;
* `hc`: the code is loaded, so that the machine fetches what the program holds;
* `hrun`, `hpc`: the machine is running, with its program counter at the entry;
* `hs`, `hin`: `s` is sixteen 32-bit words, and they are in memory from where `x1` points,
  four bytes each, least significant byte first;
* `hos`, `hout`: `os` is sixteen words, and their low four bytes are in memory from where
  `x0` points, in sixteen cells of four bytes that the machine may store to: whatever the
  output buffer holds;
* `hio`: the 64 bytes of the input and the 64 bytes of the output have no address in
  common. -/
theorem chacha20_block_vec_leakage (prog : Arm64.Program) (st : Arm64.State) (s : List W32)
    (os : List Word) (hw : prog.hasWords 0x10000#64 chacha20_block_vec_words)
    (hc : prog.CodeLoaded st.mem) (hrun : st.status = .Running) (hpc : st.pc = 0x10000#64)
    (hs : s.length = 16) (hos : os.length = 16)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes st (st.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hout : ∀ (i : Nat) (hi : i < os.length),
      HasBytes st (st.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) 4 os[i])
    (hio : Apart (st.regs.read 1#5) 64 (st.regs.read 0#5) 64) :
    ∃ st', RunL prog st (blockVecLeak (st.regs.read 0#5) (st.regs.read 1#5)
        (st.regs.read 30#5)) st' ∧ st'.pc = st.regs.read 30#5 := by
  obtain ⟨hio₁, hio₂⟩ := hio
  have hrest : ∀ b ∈ ([.pc 0x10000#64, .reg x0 (st.regs.read 0#5),
      .reg x1 (st.regs.read 1#5), .reg x8 (st.regs.read 8#5),
      .reg (vlo 0) (regOf st (vlo 0)), .reg (vhi 0) (regOf st (vhi 0)),
      .reg (vlo 1) (regOf st (vlo 1)), .reg (vhi 1) (regOf st (vhi 1)),
      .reg (vlo 2) (regOf st (vlo 2)), .reg (vhi 2) (regOf st (vhi 2)),
      .reg (vlo 3) (regOf st (vlo 3)), .reg (vhi 3) (regOf st (vhi 3)),
      .reg (vlo 4) (regOf st (vlo 4)), .reg (vhi 4) (regOf st (vhi 4)),
      .reg (vlo 5) (regOf st (vlo 5)), .reg (vhi 5) (regOf st (vhi 5)),
      .reg (vlo 6) (regOf st (vlo 6)), .reg (vhi 6) (regOf st (vhi 6)),
      .reg lr (st.regs.read 30#5), .flag Flags.n st.pstate.n, .flag Flags.z st.pstate.z,
      .flag Flags.c st.pstate.c, .flag Flags.v st.pstate.v] : Atoms),
      ∀ q n v w', Atom.Disj b (.mem q n v w') := by
    braid_not_mem
  obtain ⟨st', σ', hsteps, hr, hq⟩ := machine_soundT chacha20_block_vec_lowered
    ((block_vec_run (st.regs.read 0#5) (st.regs.read 1#5) (st.regs.read 30#5)).2 s os
      (st.regs.read 8#5) (regOf st (vlo 0)) (regOf st (vhi 0)) (regOf st (vlo 1))
      (regOf st (vhi 1)) (regOf st (vlo 2)) (regOf st (vhi 2)) (regOf st (vlo 3))
      (regOf st (vhi 3)) (regOf st (vlo 4)) (regOf st (vhi 4)) (regOf st (vlo 5))
      (regOf st (vhi 5)) (regOf st (vlo 6)) (regOf st (vhi 6))
      st.pstate.n st.pstate.z st.pstate.c st.pstate.v [] hs hos) hw hc hrun
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2
      ⟨cellsAtoms_isPointsTo, by simp [Atom.IsPointsTo]⟩⟩)
    (pairwise_cells_append (by simp [hs])
      (pairwise_cells_append (by simp [hos])
        (by braid_disj; repeat' apply And.intro
            all_goals decide)
        (disj_cellsAtoms_rest hrest))
      (disj_append
        (cellsAtoms_disj (by rw [List.length_map, hs]; exact hio₁) (by rw [hos]; exact hio₂))
        (disj_cellsAtoms_rest hrest)))
    (List.forall_mem_append.2
      ⟨cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (by simpa using hin i (by simpa using hi)),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (hout i hi),
        by
          simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
            and_true, Atom.sat_reg, Atom.sat_flag, Atom.sat_pc]
          repeat' apply And.intro
          all_goals first | exact hpc | rfl⟩⟩)
  refine ⟨st', hsteps, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`chacha20_block_vec` reveals nothing of the state it works on.** Two running machines
that hold the words of `chacha20_block_vec`, with their code loaded and at its entry, and
that agree on `x0`, `x1` and the link register (`e0`, `e1`, `e30`), run with the same trace,
whatever sixteen words each has as input (`s₁`, `s₂`) and whatever each has in the output
(`os₁`, `os₂`) and in its other registers. Of each machine the hypotheses ask what
`chacha20_block_vec_leakage` asks: its program holds the words (`hw₁`, `hw₂`), the code is
loaded (`hc₁`, `hc₂`), it is running at the entry (`hrun₁`, `hpc₁`, and the same of the
second), its input is sixteen 32-bit words in memory where `x1` points (`hs₁`, `hin₁`), and
its output is sixteen cells of four bytes where `x0` points that it may store to (`hos₁`,
`hout₁`). The input and the output are apart (`hio`), which is asked of the first machine
and holds of the second since the pointers are the same. -/
theorem chacha20_block_vec_leakage_eq (prog₁ prog₂ : Arm64.Program) (st₁ st₂ : Arm64.State)
    (s₁ s₂ : List W32) (os₁ os₂ : List Word)
    (hw₁ : prog₁.hasWords 0x10000#64 chacha20_block_vec_words)
    (hc₁ : prog₁.CodeLoaded st₁.mem)
    (hw₂ : prog₂.hasWords 0x10000#64 chacha20_block_vec_words)
    (hc₂ : prog₂.CodeLoaded st₂.mem)
    (hrun₁ : st₁.status = .Running) (hrun₂ : st₂.status = .Running)
    (hpc₁ : st₁.pc = 0x10000#64) (hpc₂ : st₂.pc = 0x10000#64)
    (hs₁ : s₁.length = 16) (hos₁ : os₁.length = 16)
    (hs₂ : s₂.length = 16) (hos₂ : os₂.length = 16)
    (hin₁ : ∀ (i : Nat) (hi : i < s₁.length),
      HasBytes st₁ (st₁.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) 4 (s₁[i].zeroExtend 64))
    (hout₁ : ∀ (i : Nat) (hi : i < os₁.length),
      HasBytes st₁ (st₁.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) 4 os₁[i])
    (hin₂ : ∀ (i : Nat) (hi : i < s₂.length),
      HasBytes st₂ (st₂.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) 4 (s₂[i].zeroExtend 64))
    (hout₂ : ∀ (i : Nat) (hi : i < os₂.length),
      HasBytes st₂ (st₂.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) 4 os₂[i])
    (hio : Apart (st₁.regs.read 1#5) 64 (st₁.regs.read 0#5) 64)
    (e0 : st₂.regs.read 0#5 = st₁.regs.read 0#5) (e1 : st₂.regs.read 1#5 = st₁.regs.read 1#5)
    (e30 : st₂.regs.read 30#5 = st₁.regs.read 30#5) :
    ∃ tr st₁' st₂', RunL prog₁ st₁ tr st₁' ∧ RunL prog₂ st₂ tr st₂' ∧
      st₁'.pc = st₁.regs.read 30#5 ∧ st₂'.pc = st₁.regs.read 30#5 := by
  obtain ⟨st₁', h₁, hp₁⟩ := chacha20_block_vec_leakage prog₁ st₁ s₁ os₁ hw₁ hc₁ hrun₁ hpc₁
    hs₁ hos₁ hin₁ hout₁ hio
  obtain ⟨st₂', h₂, hp₂⟩ := chacha20_block_vec_leakage prog₂ st₂ s₂ os₂ hw₂ hc₂ hrun₂ hpc₂
    hs₂ hos₂ hin₂ hout₂ (by rw [e0, e1]; exact hio)
  simp only [e0, e1, e30] at h₂ hp₂
  exact ⟨_, st₁', st₂', h₁, h₂, hp₁, hp₂⟩

end Examples.ChaCha20Vec.Arm
