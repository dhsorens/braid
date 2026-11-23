/-
  Examples.Sha256.O2.Arm.Round

  `sha256_round` of `sha256.c` on AArch64: one round of the compression function of SHA-256,
  on the eight working variables in memory.

  The code is straight-line. Symbolic execution leaves each cell with the value the machine
  computed, a 64-bit expression; that its low 32 bits are the specification's is a separate
  goal about bit vectors for each cell, which `bv_auto` proves (`sha256_cell`).

  This is the proof of `Examples.Sha256.Arm.Round` again, on the binary compiled at `-O2`,
  where the compiler emits for `sha256_round` the instructions it emits at `-O1`, at the
  same addresses: the statements and the proofs are the same text, about the code of this
  binary.

  ## Main results

  * `sha256_round_spec`: the specification, with `roundKW`
  * `sha256_round_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256.O2.Arm.Image
public import Examples.Sha256.Arm.Machine
import Braid.BV

public section

namespace Examples.Sha256.O2.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs
open Examples.Sha256.Arm

/-- `sha256_round` replaces the working variables its first argument points to by one round
of them, with the round constant in the low half of its second argument and the word of the
schedule in the low half of its third. -/
theorem sha256_round_spec (p kk ww r : Word) (v : Vars)
    (t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 : Word) :
    Triple sha256_round.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 p, .reg x1 kk, .reg x2 ww,
        .reg x8 t8, .reg x9 t9, .reg x10 t10, .reg x11 t11, .reg x12 t12, .reg x13 t13,
        .reg x14 t14, .reg x15 t15, .reg x16 t16, .reg x17 t17, .reg x18 t18,
        .reg lr r, .prop (cellsAt 4 true p (w32s v.toList))])
      (Atoms.interp [.pc r, .reg x0 p, .prop (regAny x1), .prop (regAny x2),
        .prop (regAny x8), .prop (regAny x9), .prop (regAny x10), .prop (regAny x11),
        .prop (regAny x12), .prop (regAny x13), .prop (regAny x14), .prop (regAny x15),
        .prop (regAny x16), .prop (regAny x17), .prop (regAny x18),
        .reg lr r, .prop (cellsAt 4 true p
          (w32s (roundKW (kk.setWidth 32) (ww.setWidth 32) v).toList))]) := by
  -- The base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨q, rfl⟩ : ∃ q : BitVec 64, p = q + 1#64 := ⟨p - 1#64, by bv_omega⟩
  braid_unfold cells_vars true (q + 1#64) v
  braid_sym_run
  sha256_cell (q + 1#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).a.setWidth 64
  sha256_cell (q + 5#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).b.setWidth 64
  sha256_cell (q + 9#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).c.setWidth 64
  sha256_cell (q + 13#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).d.setWidth 64
  sha256_cell (q + 17#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).e.setWidth 64
  sha256_cell (q + 21#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).f.setWidth 64
  sha256_cell (q + 25#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).g.setWidth 64
  sha256_cell (q + 29#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).h.setWidth 64
  braid_fold cells_vars true (q + 1#64) (roundKW (kk.setWidth 32) (ww.setWidth 32) v)
  braid_forget 1
  braid_forget 2
  braid_forget 8
  braid_forget 9
  braid_forget 10
  braid_forget 11
  braid_forget 12
  braid_forget 13
  braid_forget 14
  braid_forget 15
  braid_forget 16
  braid_forget 17
  braid_forget 18
  braid_done

/-! ## On the machine -/

/-- **`sha256_round` on the machine.** A running machine whose program holds the words of
`sha256_round`, with its code loaded and its program counter at the entry, and with the
eight working variables `v` in memory where `x0` points, runs to the address in the link
register with one round of them there instead: the round whose constant is the low half of
`x1` and whose word of the schedule is the low half of `x2`. -/
theorem sha256_round_correct (prog : Arm64.Program) (s : Arm64.State) (v : Vars)
    (hw : prog.hasWords 0x10000#64 sha256_round_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64)
    (hv : HasCells s (s.regs.read 0#5) v.toList) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      HasCells s' (s.regs.read 0#5)
        (roundKW ((s.regs.read 1#5).setWidth 32) ((s.regs.read 2#5).setWidth 32) v).toList := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat sha256_round_lowered
    (sha256_round_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 2#5)
      (s.regs.read 30#5) v (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5)
      (s.regs.read 11#5) (s.regs.read 12#5) (s.regs.read 13#5) (s.regs.read 14#5)
      (s.regs.read 15#5) (s.regs.read 16#5) (s.regs.read 17#5) (s.regs.read 18#5)) hw hc hrun
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
  refine ⟨s', hsteps, ?_, hasCells_of_holds hr hq (by braid_at)⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

end Examples.Sha256.O2.Arm
