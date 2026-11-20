/-
  Examples.Sha256Ni.Arm.Proofs

  `sha256_ni.c` on AArch64: the compression function of SHA-256 written with the SHA-2
  instructions, proved against the specification of FIPS 180-4 in `Examples.Spec.Sha256`, the
  one the scalar code of `Examples.Sha256.Arm` is proved against, and carried down to the
  machine model.

  The state of a machine at the entry of the function is written out once (`entryFlat`), with
  the three lemmas that a theorem about the machine needs of it, since the theorem of what
  the function computes and the theorem of what it reveals (`Examples.Sha256Ni.Arm.Leakage`)
  start from the same state.

  ## Main definitions

  * `entryFlat`: the state at the entry, as points-to atoms

  ## Main results

  * `step_spec`, `loop_spec`, `tail_spec`: the turns of the two loops, and the first loop
  * `sha256_compress_ni_spec`: the specification, with `Sha256.compress`
  * `sha256_compress_ni_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256Ni.Arm.Compress
public import Examples.Sha256.Arm.Machine

@[expose] public section

namespace Examples.Sha256Ni.Arm

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.Arm Lowering.Arm.Regs
open Examples.Sha256.Arm (HasCells HasReadOnlyCells hasCells_of_holds)

/-! ## The state at the entry -/

/-- The program counter, the registers and the flags of a machine at the entry of
`sha256_compress_ni`, as atoms: those the code reads or writes. -/
def entryRegs (s : Arm64.State) : Atoms :=
  [.pc 0x100bc#64, .reg x0 (s.regs.read 0#5), .reg x1 (s.regs.read 1#5),
    .reg x8 (s.regs.read 8#5), .reg x9 (s.regs.read 9#5), .reg x10 (s.regs.read 10#5),
    .reg (vlo 0) (regOf s (vlo 0)), .reg (vhi 0) (regOf s (vhi 0)),
    .reg (vlo 1) (regOf s (vlo 1)), .reg (vhi 1) (regOf s (vhi 1)),
    .reg (vlo 2) (regOf s (vlo 2)), .reg (vhi 2) (regOf s (vhi 2)),
    .reg (vlo 3) (regOf s (vlo 3)), .reg (vhi 3) (regOf s (vhi 3)),
    .reg (vlo 4) (regOf s (vlo 4)), .reg (vhi 4) (regOf s (vhi 4)),
    .reg (vlo 5) (regOf s (vlo 5)), .reg (vhi 5) (regOf s (vhi 5)),
    .reg (vlo 6) (regOf s (vlo 6)), .reg (vhi 6) (regOf s (vhi 6)),
    .reg (vlo 7) (regOf s (vlo 7)), .reg (vhi 7) (regOf s (vhi 7)),
    .reg (vlo 16) (regOf s (vlo 16)), .reg (vhi 16) (regOf s (vhi 16)),
    .reg (vlo 17) (regOf s (vlo 17)), .reg (vhi 17) (regOf s (vhi 17)),
    .reg (vlo 18) (regOf s (vlo 18)), .reg (vhi 18) (regOf s (vhi 18)),
    .reg (vlo 19) (regOf s (vlo 19)), .reg (vhi 19) (regOf s (vhi 19)),
    .reg lr (s.regs.read 30#5), .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z,
    .flag Flags.c s.pstate.c, .flag Flags.v s.pstate.v]

/-- The state of a machine at the entry of `sha256_compress_ni`, as points-to atoms: its
registers and flags, and in memory the hash value `H` where `x0` points, the block `M` where
`x1` points, and the round constants, read-only, at `0x20228`. -/
def entryFlat (s : Arm64.State) (H M : List W32) : Atoms :=
  entryRegs s ++
    (cellsAtoms 4 true (s.regs.read 0#5) (w32s H) ++
    (cellsAtoms 4 true (s.regs.read 1#5) (w32s M) ++
    (cellsAtoms 4 false 0x20228#64 (w32s K) ++ [])))

theorem entryFlat_pointsTo (s : Arm64.State) (H M : List W32) :
    ∀ a ∈ entryFlat s H M, a.IsPointsTo :=
  List.forall_mem_append.2 ⟨by simp [entryRegs, Atom.IsPointsTo],
    List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
    List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
    List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩⟩⟩

/-- The atoms of the state at the entry are pairwise disjoint, when the hash value and the
block are apart: the machine has both, and may store to them, so neither meets the
read-only table. -/
theorem entryFlat_disj (s : Arm64.State) (H M : List W32) (hH : H.length = 8)
    (hM : M.length = 16) (hh : HasCells s (s.regs.read 0#5) H)
    (hm : HasCells s (s.regs.read 1#5) M) (hk : HasReadOnlyCells s 0x20228#64 K)
    (hhm : Apart (s.regs.read 0#5) 32 (s.regs.read 1#5) 64) :
    (entryFlat s H M).Pairwise Atom.Disj := by
  have hlK : K.length = 64 := rfl
  exact pairwise_regs_mems (by unfold entryRegs; sha256_disj) (by simp [entryRegs, NotMem])
    (List.forall_mem_append.2 ⟨isMem_cellsAtoms,
      List.forall_mem_append.2 ⟨isMem_cellsAtoms,
      List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩⟩⟩)
    (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hH]),
      List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hM]),
      List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hlK]), .nil, disj_nil_right⟩,
      -- the block, and the round constants
      disj_append_right (cellsAtoms_disj_readOnly hm.sat hk.sat) disj_nil_right⟩,
      -- the hash value, and what follows it
      disj_append_right (cellsAtoms_disj (by rw [w32s_length, hH]; exact hhm.1)
          (by rw [w32s_length, hM]; exact hhm.2))
        (disj_append_right (cellsAtoms_disj_readOnly hh.sat hk.sat) disj_nil_right)⟩)

/-- The atoms of the state at the entry are true of a machine that is there and has the
three arrays. -/
theorem entryFlat_sat (s : Arm64.State) (H M : List W32) (hpc : s.pc = 0x100bc#64)
    (hh : HasCells s (s.regs.read 0#5) H) (hm : HasCells s (s.regs.read 1#5) M)
    (hk : HasReadOnlyCells s 0x20228#64 K) : ∀ a ∈ entryFlat s H M, a.sat (abs s) :=
  List.forall_mem_append.2
    ⟨by
      simp only [entryRegs, List.forall_mem_cons, List.not_mem_nil, false_imp_iff,
        implies_true, and_true, Atom.sat_reg, Atom.sat_flag, Atom.sat_pc]
      repeat' apply And.intro
      all_goals first | exact hpc | rfl,
      List.forall_mem_append.2 ⟨hh.sat,
      List.forall_mem_append.2 ⟨hm.sat,
      List.forall_mem_append.2 ⟨hk.sat, by simp⟩⟩⟩⟩

/-! ## On the machine -/

/-- **`sha256_compress_ni` on the machine.** A running machine runs to the address in the
link register with the compression of `H` with `M` where `x0` pointed, and the block still
where `x1` pointed. The hypotheses ask that

* `hw`: the program holds the words of `sha256_compress_ni` from `0x100bc`;
* `hc`: the code is loaded, so that the machine fetches what the program holds;
* `hrun`, `hpc`: the machine is running, with its program counter at the entry;
* `hH`, `hh`: `H` is eight 32-bit words, and they are in memory from where `x0` points, four
  bytes each, least significant byte first, in cells that the machine may store to;
* `hM`, `hm`: `M` is sixteen 32-bit words, in memory in the same way from where `x1` points;
* `hk`: the 64 round constants of SHA-256 are in read-only memory from `0x20228`, in the
  same way. That is where the linker put the table `K` of `sha256_ni.c`, in the read-only
  data of the binary, so a machine that has the binary loaded satisfies it;
* `hhm`: the 32 bytes of the hash value and the 64 bytes of the block have no address in
  common.

That the table is apart from the hash value and from the block is not asked: the machine
may store to those and not to the table. The code needs no stack and no alignment. -/
theorem sha256_compress_ni_correct (prog : Arm64.Program) (s : Arm64.State) (H M : List W32)
    (hw : prog.hasWords 0x100bc#64 sha256_compress_ni_words)
    (hc : prog.CodeLoaded s.mem) (hrun : s.status = .Running) (hpc : s.pc = 0x100bc#64)
    (hH : H.length = 8) (hM : M.length = 16)
    (hh : HasCells s (s.regs.read 0#5) H) (hm : HasCells s (s.regs.read 1#5) M)
    (hk : HasReadOnlyCells s 0x20228#64 K)
    (hhm : Apart (s.regs.read 0#5) 32 (s.regs.read 1#5) 64) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      HasCells s' (s.regs.read 0#5) (compress H M) ∧ HasCells s' (s.regs.read 1#5) M := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat sha256_compress_ni_lowered
    (sha256_compress_ni_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5) H M true
      (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5)
      (regOf s (vlo 0)) (regOf s (vhi 0)) (regOf s (vlo 1)) (regOf s (vhi 1))
      (regOf s (vlo 2)) (regOf s (vhi 2)) (regOf s (vlo 3)) (regOf s (vhi 3))
      (regOf s (vlo 4)) (regOf s (vhi 4)) (regOf s (vlo 5)) (regOf s (vhi 5))
      (regOf s (vlo 6)) (regOf s (vhi 6)) (regOf s (vlo 7)) (regOf s (vhi 7))
      (regOf s (vlo 16)) (regOf s (vhi 16)) (regOf s (vlo 17)) (regOf s (vhi 17))
      (regOf s (vlo 18)) (regOf s (vhi 18)) (regOf s (vlo 19)) (regOf s (vhi 19))
      s.pstate.n s.pstate.z s.pstate.c s.pstate.v hH hM) hw hc hrun
    (flat := entryFlat s H M)
    (Flat.interp (by unfold entryFlat entryRegs; braid_flat))
    (entryFlat_pointsTo s H M) (entryFlat_disj s H M hH hM hh hm hk hhm)
    (entryFlat_sat s H M hpc hh hm hk)
  refine ⟨s', hsteps, ?_, hasCells_of_holds hr hq (by braid_at),
    hasCells_of_holds hr hq (by braid_at)⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

end Examples.Sha256Ni.Arm
