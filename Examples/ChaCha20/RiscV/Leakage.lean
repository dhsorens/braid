/-
  Examples.ChaCha20.RiscV.Leakage

  What `chacha20_block` reveals on RISC-V, about the machine alone (`docs/Leakage.md`). The
  traced triple is that of `block_run` of `Examples.ChaCha20.RiscV.LeakBlock`, whose run
  finds the trace `blockLeak`; here it is carried to the machine model, and the two-run
  statement is drawn from it.

  The code neither branches nor indexes on the words of the state: its three loops run a
  fixed number of times, and every address is an offset from one of the two pointers or
  from the stack pointer. So the public inputs are the two pointers, the stack pointer and
  the return address, and the sixteen words of the input are secret.

  ## Main results

  * `chacha20_block_leakage`: the trace of the run is `blockLeak` of the public inputs
  * `chacha20_block_leakage_eq`: two machines that agree on the public inputs run with the
    same trace, whatever the input, the output and the frame hold
-/

module

public import Examples.ChaCha20.RiscV.LeakBlock

public section

namespace Examples.ChaCha20.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- **What `chacha20_block` reveals, on the machine.** A machine that holds the code of
`chacha20_block` and is at its entry, with the sixteen 32-bit words `s` in valid memory where
`a1` points, sixteen 32-bit cells `os` where `a0` points, both pointers multiples of 4, and a
stack pointer that is a multiple of 8 with 104 bytes of valid memory below it (the sixteen
32-bit cells `fr` and the five 64-bit cells `sv`), the three regions apart from one another,
runs to the return address with the trace `blockLeak` of `a0`, `a1`, the stack pointer and
the return address. The trace does not mention `s`, `os`, `fr` or `sv`. -/
theorem chacha20_block_leakage (st : MachineState) (s : List W32) (os fr sv : List Word)
    (hcode : ∀ p ∈ chacha20_block_code, st.code p.1 = some p.2) (hpc : st.pc = 0x10074#64)
    (hsp : st.getReg .x2 &&& 7#64 = 0#64) (hinp : st.getReg .x11 &&& 3#64 = 0#64)
    (hout : st.getReg .x10 &&& 3#64 = 0#64) (hs : s.length = 16) (hos : os.length = 16)
    (hfr : fr.length = 16) (hsv : sv.length = 5)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes st (st.getReg .x11 + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hout' : ∀ (i : Nat) (hi : i < os.length),
      HasBytes st (st.getReg .x10 + BitVec.ofNat 64 (4 * i)) 4 os[i])
    (hframe : ∀ (i : Nat) (hi : i < fr.length),
      HasBytes st (st.getReg .x2 - 104#64 + BitVec.ofNat 64 (4 * i)) 4 fr[i])
    (hsaved : ∀ (i : Nat) (hi : i < sv.length),
      HasBytes st (st.getReg .x2 - 40#64 + BitVec.ofNat 64 (8 * i)) 8 sv[i])
    (hio : Apart (st.getReg .x11) 64 (st.getReg .x10) 64)
    (his : Apart (st.getReg .x11) 64 (st.getReg .x2 - 104#64) 104)
    (hos' : Apart (st.getReg .x10) 64 (st.getReg .x2 - 104#64) 104) :
    ∃ st', RunL st (blockLeak (st.getReg .x10) (st.getReg .x11) (st.getReg .x2)
        (st.getReg .x1)) st' ∧ st'.pc = st.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨hio₁, hio₂⟩ := hio
  obtain ⟨his₁, his₂⟩ := his
  obtain ⟨hos₁, hos₂⟩ := hos'
  have hrest : ∀ b ∈ ([.pc 0x10074#64, .reg a0 (st.getReg .x10), .reg a1 (st.getReg .x11),
      .reg a2 (st.getReg .x12), .reg a3 (st.getReg .x13), .reg a4 (st.getReg .x14),
      .reg a5 (st.getReg .x15), .reg a6 (st.getReg .x16), .reg a7 (st.getReg .x17),
      .reg t0 (st.getReg .x5), .reg t1 (st.getReg .x6), .reg t2 (st.getReg .x7),
      .reg t3 (st.getReg .x28), .reg t4 (st.getReg .x29), .reg t5 (st.getReg .x30),
      .reg t6 (st.getReg .x31), .reg s0 (st.getReg .x8), .reg s1 (st.getReg .x9),
      .reg s2 (st.getReg .x18), .reg s3 (st.getReg .x19), .reg s4 (st.getReg .x20),
      .reg sp (st.getReg .x2), .reg ra (st.getReg .x1)] : Atoms),
      ∀ q n v w', Atom.Disj b (.mem q n v w') := by
    braid_not_mem
  obtain ⟨st', σ', hrun, hr, hq⟩ := machine_soundT chacha20_block_lowered
    ((block_run (st.getReg .x10) (st.getReg .x11) (st.getReg .x2) (st.getReg .x1)).2 s os
      fr sv (st.getReg .x5) (st.getReg .x6) (st.getReg .x7) (st.getReg .x8) (st.getReg .x9)
      (st.getReg .x12) (st.getReg .x13) (st.getReg .x14) (st.getReg .x15) (st.getReg .x16)
      (st.getReg .x17) (st.getReg .x18) (st.getReg .x19) (st.getReg .x20) (st.getReg .x28)
      (st.getReg .x29) (st.getReg .x30) (st.getReg .x31) hs hos hfr hsv hsp hinp hout [])
    hcode (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2
      ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
        List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp [Atom.IsPointsTo]⟩⟩⟩⟩)
    (pairwise_cells_append (by simp [hs])
      (pairwise_cells_append (by simp [hos])
        (pairwise_cells_append (by simp [hfr])
          (pairwise_cells_append (by simp [hsv])
            (by braid_disj; repeat' apply And.intro
                all_goals decide)
            (disj_cellsAtoms_rest hrest))
          (disj_append
            (cellsAtoms_disj (by rw [hfr]; bv_omega) (by rw [hsv]; bv_omega))
            (disj_cellsAtoms_rest hrest)))
        (disj_append
          (cellsAtoms_disj (by rw [hos]; exact hos₁) (by rw [hfr]; bv_omega))
          (disj_append
            (cellsAtoms_disj (by rw [hos]; bv_omega) (by rw [hsv]; bv_omega))
            (disj_cellsAtoms_rest hrest))))
      (disj_append
        (cellsAtoms_disj (by rw [List.length_map, hs]; exact hio₁) (by rw [hos]; exact hio₂))
        (disj_append
          (cellsAtoms_disj (by rw [List.length_map, hs]; exact his₁) (by rw [hfr]; bv_omega))
          (disj_append
            (cellsAtoms_disj (by rw [List.length_map, hs]; bv_omega) (by rw [hsv]; bv_omega))
            (disj_cellsAtoms_rest hrest)))))
    (List.forall_mem_append.2
      ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (by simpa using hin i (by simpa using hi)),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (hout' i hi),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (hframe i hi),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (hsaved i hi),
        by
          simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
            and_true, Atom.sat_reg, Atom.sat_pc]
          repeat' apply And.intro
          all_goals first | exact hpc | rfl⟩⟩⟩⟩)
  refine ⟨st', hrun, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`chacha20_block` reveals nothing of the state it works on.** Two machines that hold the
code of `chacha20_block`, are at its entry, and agree on `a0`, `a1`, the stack pointer and the
return address, the pointers aligned and the three regions in valid memory and apart as
`chacha20_block_leakage` asks, run with the same trace, whatever sixteen words each has as
input (`s₁`, `s₂`), and whatever each has in the output and below the stack pointer. -/
theorem chacha20_block_leakage_eq (st₁ st₂ : MachineState) (s₁ s₂ : List W32)
    (os₁ fr₁ sv₁ os₂ fr₂ sv₂ : List Word)
    (hcode₁ : ∀ p ∈ chacha20_block_code, st₁.code p.1 = some p.2)
    (hcode₂ : ∀ p ∈ chacha20_block_code, st₂.code p.1 = some p.2)
    (hpc₁ : st₁.pc = 0x10074#64) (hpc₂ : st₂.pc = 0x10074#64)
    (hsp : st₁.getReg .x2 &&& 7#64 = 0#64) (hinp : st₁.getReg .x11 &&& 3#64 = 0#64)
    (hout : st₁.getReg .x10 &&& 3#64 = 0#64)
    (hs₁ : s₁.length = 16) (hos₁ : os₁.length = 16) (hfr₁ : fr₁.length = 16)
    (hsv₁ : sv₁.length = 5)
    (hs₂ : s₂.length = 16) (hos₂ : os₂.length = 16) (hfr₂ : fr₂.length = 16)
    (hsv₂ : sv₂.length = 5)
    (hin₁ : ∀ (i : Nat) (hi : i < s₁.length),
      HasBytes st₁ (st₁.getReg .x11 + BitVec.ofNat 64 (4 * i)) 4 (s₁[i].zeroExtend 64))
    (hout₁ : ∀ (i : Nat) (hi : i < os₁.length),
      HasBytes st₁ (st₁.getReg .x10 + BitVec.ofNat 64 (4 * i)) 4 os₁[i])
    (hframe₁ : ∀ (i : Nat) (hi : i < fr₁.length),
      HasBytes st₁ (st₁.getReg .x2 - 104#64 + BitVec.ofNat 64 (4 * i)) 4 fr₁[i])
    (hsaved₁ : ∀ (i : Nat) (hi : i < sv₁.length),
      HasBytes st₁ (st₁.getReg .x2 - 40#64 + BitVec.ofNat 64 (8 * i)) 8 sv₁[i])
    (hin₂ : ∀ (i : Nat) (hi : i < s₂.length),
      HasBytes st₂ (st₂.getReg .x11 + BitVec.ofNat 64 (4 * i)) 4 (s₂[i].zeroExtend 64))
    (hout₂ : ∀ (i : Nat) (hi : i < os₂.length),
      HasBytes st₂ (st₂.getReg .x10 + BitVec.ofNat 64 (4 * i)) 4 os₂[i])
    (hframe₂ : ∀ (i : Nat) (hi : i < fr₂.length),
      HasBytes st₂ (st₂.getReg .x2 - 104#64 + BitVec.ofNat 64 (4 * i)) 4 fr₂[i])
    (hsaved₂ : ∀ (i : Nat) (hi : i < sv₂.length),
      HasBytes st₂ (st₂.getReg .x2 - 40#64 + BitVec.ofNat 64 (8 * i)) 8 sv₂[i])
    (hio : Apart (st₁.getReg .x11) 64 (st₁.getReg .x10) 64)
    (his : Apart (st₁.getReg .x11) 64 (st₁.getReg .x2 - 104#64) 104)
    (hos : Apart (st₁.getReg .x10) 64 (st₁.getReg .x2 - 104#64) 104)
    (e10 : st₂.getReg .x10 = st₁.getReg .x10) (e11 : st₂.getReg .x11 = st₁.getReg .x11)
    (e2 : st₂.getReg .x2 = st₁.getReg .x2) (e1 : st₂.getReg .x1 = st₁.getReg .x1) :
    ∃ tr st₁' st₂', RunL st₁ tr st₁' ∧ RunL st₂ tr st₂' ∧
      st₁'.pc = st₁.getReg .x1 &&& ~~~1#64 ∧ st₂'.pc = st₁.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨st₁', h₁, hp₁⟩ := chacha20_block_leakage st₁ s₁ os₁ fr₁ sv₁ hcode₁ hpc₁ hsp hinp
    hout hs₁ hos₁ hfr₁ hsv₁ hin₁ hout₁ hframe₁ hsaved₁ hio his hos
  obtain ⟨st₂', h₂, hp₂⟩ := chacha20_block_leakage st₂ s₂ os₂ fr₂ sv₂ hcode₂ hpc₂
    (e2 ▸ hsp) (e11 ▸ hinp) (e10 ▸ hout) hs₂ hos₂ hfr₂ hsv₂ hin₂ hout₂ hframe₂ hsaved₂
    (by rw [e10, e11]; exact hio) (by rw [e11, e2]; exact his) (by rw [e10, e2]; exact hos)
  simp only [e10, e11, e2, e1] at h₂ hp₂
  exact ⟨_, st₁', st₂', h₁, h₂, hp₁, hp₂⟩

end Examples.ChaCha20.RiscV
