/-
  Examples.ChaCha20Vec.Arm.Proofs

  `chacha20_vec.c` on AArch64: the vectorised block function of ChaCha20, proved against the
  plain Lean specification of `Examples.Spec.ChaCha20`, the one the scalar code of
  `Examples.ChaCha20.Arm` is proved against, and carried down to the machine model.

  ## Main results

  * `rounds_spec`: the loop of ten double rounds on four vector registers, by induction
  * `chacha20_block_vec_spec`, `chacha20_block_vec_inplace_spec`: the block function, for an
    output apart from the input and for an output that is the input
  * `chacha20_block_vec_correct`, `chacha20_block_vec_inplace_correct`: the same, about the
    machine alone
-/

module

public import Examples.ChaCha20Vec.Arm.Block

public section

namespace Examples.ChaCha20Vec.Arm

open Braid Examples Examples.ChaCha20 Lowering.Arm Lowering.Arm.Regs

/-- The registers, flags and program counter of the precondition of `chacha20_block_vec`,
read off a machine state: no atom of them is a memory atom. -/
private theorem rest_not_mem (st : Arm64.State) (o i : Word) :
    ∀ b ∈ ([.pc 0x10000#64, .reg x0 o, .reg x1 i, .reg x8 (st.regs.read 8#5),
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

/-- **`chacha20_block_vec` on the machine.** A running machine runs to the address in the
link register with the ChaCha20 block function of `s` where `x0` pointed, and `s` still
where `x1` pointed. The hypotheses ask that

* `hw`: the program holds the words of `chacha20_block_vec` from `0x10000`;
* `hc`: the code is loaded, so that the machine fetches what the program holds;
* `hrun`, `hpc`: the machine is running, with its program counter at the entry;
* `hs`, `hin`: `s` is sixteen 32-bit words, and they are in memory from where `x1` points,
  four bytes each, least significant byte first;
* `hos`, `hout`: `os` is sixteen words, and their low four bytes are in memory from where
  `x0` points, in sixteen cells of four bytes that the machine may store to: whatever the
  output buffer holds;
* `hio`: the 64 bytes of the input and the 64 bytes of the output have no address in common.

The code stores a row of the output before it loads the next row of the input again, so
an output that overlaps the input in part is not covered, and for one that is the input
there is `chacha20_block_vec_inplace_correct`. The code needs no stack and no alignment. -/
theorem chacha20_block_vec_correct (prog : Arm64.Program) (st : Arm64.State) (s : List W32)
    (os : List Word) (hw : prog.hasWords 0x10000#64 chacha20_block_vec_words)
    (hc : prog.CodeLoaded st.mem) (hrun : st.status = .Running) (hpc : st.pc = 0x10000#64)
    (hs : s.length = 16) (hos : os.length = 16)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes st (st.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hout : ∀ (i : Nat) (hi : i < os.length),
      HasBytes st (st.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) 4 os[i])
    (hio : Apart (st.regs.read 1#5) 64 (st.regs.read 0#5) 64) :
    ∃ st', Arm64.Steps prog st st' ∧ st'.pc = st.regs.read 30#5 ∧
      (∀ (i : Nat) (hi : i < (block s).length),
        HasBytes st' (st.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) 4
          ((block s)[i].zeroExtend 64)) ∧
      (∀ (i : Nat) (hi : i < s.length),
        HasBytes st' (st.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64)) := by
  obtain ⟨hio₁, hio₂⟩ := hio
  have hrest := rest_not_mem st (st.regs.read 0#5) (st.regs.read 1#5)
  obtain ⟨st', σ', hsteps, hr, hq⟩ := machine_sound_flat chacha20_block_vec_lowered
    (chacha20_block_vec_spec (st.regs.read 0#5) (st.regs.read 1#5) (st.regs.read 30#5) s os
      (st.regs.read 8#5) (regOf st (vlo 0)) (regOf st (vhi 0)) (regOf st (vlo 1))
      (regOf st (vhi 1)) (regOf st (vlo 2)) (regOf st (vhi 2)) (regOf st (vlo 3))
      (regOf st (vhi 3)) (regOf st (vlo 4)) (regOf st (vhi 4)) (regOf st (vlo 5))
      (regOf st (vhi 5)) (regOf st (vlo 6)) (regOf st (vhi 6))
      st.pstate.n st.pstate.z st.pstate.c st.pstate.v hs hos) hw hc hrun
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
  refine ⟨st', hsteps, ?_, fun i hi => ?_, fun i hi => ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · have hc := fun x => cell_of_holds (k := 4) (p := st.regs.read 0#5)
      (vs := (block s).map (·.zeroExtend 64)) hq (by braid_at) i (by simpa using hi) (x := x)
    have h := hr.hasBytes (a := st.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) (n := 4) hc
    simpa using h
  · have hc := fun x => cell_of_holds (k := 4) (p := st.regs.read 1#5)
      (vs := s.map (·.zeroExtend 64)) hq (by braid_at) i (by simpa using hi) (x := x)
    have h := hr.hasBytes (a := st.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) (n := 4) hc
    simpa using h

/-- **`chacha20_block_vec` on the machine, in place.** A running machine whose two arguments
are the same address runs to the address in the link register with the ChaCha20 block
function of `s` where `s` was. The hypotheses ask that

* `hw`: the program holds the words of `chacha20_block_vec` from `0x10000`;
* `hc`: the code is loaded, so that the machine fetches what the program holds;
* `hrun`, `hpc`: the machine is running, with its program counter at the entry;
* `hsame`: `x0` and `x1` hold the same address;
* `hs`, `hin`: `s` is sixteen 32-bit words, and they are in memory from where `x1` points,
  four bytes each, least significant byte first, in cells that the machine may store to. -/
theorem chacha20_block_vec_inplace_correct (prog : Arm64.Program) (st : Arm64.State)
    (s : List W32) (hw : prog.hasWords 0x10000#64 chacha20_block_vec_words)
    (hc : prog.CodeLoaded st.mem) (hrun : st.status = .Running) (hpc : st.pc = 0x10000#64)
    (hsame : st.regs.read 0#5 = st.regs.read 1#5) (hs : s.length = 16)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes st (st.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64)) :
    ∃ st', Arm64.Steps prog st st' ∧ st'.pc = st.regs.read 30#5 ∧
      ∀ (i : Nat) (hi : i < (block s).length),
        HasBytes st' (st.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) 4
          ((block s)[i].zeroExtend 64) := by
  have hrest := rest_not_mem st (st.regs.read 1#5) (st.regs.read 1#5)
  obtain ⟨st', σ', hsteps, hr, hq⟩ := machine_sound_flat chacha20_block_vec_lowered
    (chacha20_block_vec_inplace_spec (st.regs.read 1#5) (st.regs.read 30#5) s
      (st.regs.read 8#5) (regOf st (vlo 0)) (regOf st (vhi 0)) (regOf st (vlo 1))
      (regOf st (vhi 1)) (regOf st (vlo 2)) (regOf st (vhi 2)) (regOf st (vlo 3))
      (regOf st (vhi 3)) (regOf st (vlo 4)) (regOf st (vhi 4)) (regOf st (vlo 5))
      (regOf st (vhi 5)) (regOf st (vlo 6)) (regOf st (vhi 6))
      st.pstate.n st.pstate.z st.pstate.c st.pstate.v hs) hw hc hrun
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp [Atom.IsPointsTo]⟩)
    (pairwise_cells_append (by simp [hs])
      (by braid_disj; repeat' apply And.intro
          all_goals decide)
      (disj_cellsAtoms_rest hrest))
    (List.forall_mem_append.2
      ⟨cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (by simpa using hin i (by simpa using hi)),
        by
          simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
            and_true, Atom.sat_reg, Atom.sat_flag, Atom.sat_pc]
          repeat' apply And.intro
          all_goals first | exact hpc | exact hsame | rfl⟩)
  refine ⟨st', hsteps, ?_, fun i hi => ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · have hc := fun x => cell_of_holds (k := 4) (p := st.regs.read 1#5)
      (vs := (block s).map (·.zeroExtend 64)) hq (by braid_at) i (by simpa using hi) (x := x)
    have h := hr.hasBytes (a := st.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) (n := 4) hc
    simpa using h

end Examples.ChaCha20Vec.Arm
