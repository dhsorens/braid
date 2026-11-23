/-
  Examples.Sha256.O2.RiscV.Round

  `sha256_round` of `sha256.c` on RISC-V: one round of the compression function of SHA-256,
  on the eight working variables in memory.

  The code is straight-line, between a store and a load of the callee-saved register `s0`.
  Each access to memory is behind a guard for its alignment, which the lowering emits, so the
  specification asks that the two pointers are aligned. Symbolic execution leaves each cell
  with the value the machine computed, a 64-bit expression: the code loads each working
  variable sign-extended and adds with the 64-bit `add`, and only `sw` narrows the result.
  That its low 32 bits are the specification's is a separate goal about bit vectors for each
  cell, which `bv_auto` proves (`sha256_cell`).

  This is the proof of `Examples.Sha256.RiscV.Round` again, on the binary compiled at `-O2`,
  where the compiler emits for `sha256_round` the instructions it emits at `-O1`, at the same
  addresses: the statements and the proofs are the same text, about the code of this binary.

  ## Main results

  * `sha256_round_spec`: the specification, with `roundKW`
  * `sha256_round_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256.O2.RiscV.Image
public import Examples.Sha256.RiscV.Machine
public import Examples.Sha256.RunTo
import Braid.BV

public section

namespace Examples.Sha256.O2.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64
open Examples.Sha256.RiscV

/-- Forget what `sha256_round` leaves in the registers it uses. -/
local macro "round_forget" : tactic =>
  `(tactic| (braid_forget 11; braid_forget 12; braid_forget 13; braid_forget 14
             braid_forget 15; braid_forget 16; braid_forget 17; braid_forget 5
             braid_forget 6; braid_forget 7; braid_forget 28; braid_forget 29
             braid_forget 30; braid_forget 31))

/-- `sha256_round` replaces the working variables its first argument points to by one round
of them, with the round constant in the low half of its second argument and the word of the
schedule in the low half of its third. Both the pointer and the stack pointer are aligned.
It saves `s0` in the word below the stack pointer, and returns through `ra`. -/
theorem sha256_round_spec (p kk ww s r v8 m0 : Word) (v : Vars)
    (x5 x6 x7 x13 x14 x15 x16 x17 x28 x29 x30 x31 : Word)
    (hp : p &&& 3#64 = 0#64) (hs : s &&& 7#64 = 0#64) :
    Triple sha256_round.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 p, .reg a1 kk, .reg a2 ww, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .reg t3 x28, .reg t4 x29, .reg t5 x30, .reg t6 x31, .reg s0 v8,
        .reg sp s, .reg ra r,
        .prop (cellsAt 4 true p (w32s v.toList)), .prop (cellsAt 8 true (s - 8#64) [m0])])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 p, .prop (regAny a1), .prop (regAny a2),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .prop (regAny t2),
        .prop (regAny t3), .prop (regAny t4), .prop (regAny t5), .prop (regAny t6),
        .reg s0 v8, .reg sp s, .reg ra r,
        .prop (cellsAt 4 true p (w32s (roundKW (kk.setWidth 32) (ww.setWidth 32) v).toList)),
        .prop (cellsAt 8 true (s - 8#64) [v8])]) := by
  obtain ⟨q, rfl⟩ : ∃ q : BitVec 64, p = q + 1#64 := ⟨p - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 9#64 := ⟨s - 9#64, by bv_omega⟩
  braid_unfold cells_vars true (q + 1#64) v
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 1#64) m0 []
  braid_sym_run
  sha256_cell (q + 1#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).a.setWidth 64
  sha256_cell (q + 5#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).b.setWidth 64
  sha256_cell (q + 9#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).c.setWidth 64
  sha256_cell (q + 13#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).d.setWidth 64
  sha256_cell (q + 17#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).e.setWidth 64
  sha256_cell (q + 21#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).f.setWidth 64
  sha256_cell (q + 25#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).g.setWidth 64
  sha256_cell (q + 29#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).h.setWidth 64
  sha256_fold cells_vars true (q + 1#64) (roundKW (kk.setWidth 32) (ww.setWidth 32) v)
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 1#64) v8 []
  round_forget
  braid_done

/-! ## On the machine -/

/-- **`sha256_round` on the machine.** A machine that holds the code of `sha256_round`, is at
its entry, has the eight working variables `v` in memory where `a0` points and a word of
memory below the stack pointer, with `a0` aligned to four bytes and the stack pointer to
eight, and the working variables apart from that word of stack, runs to the return address
with one round of the working variables where `a0` pointed: the round whose constant is the
low half of `a1` and whose word of the schedule is the low half of `a2`. The stack pointer
and `s0` are as they were. -/
theorem sha256_round_correct (s : MachineState) (v : Vars) (m0 : Word)
    (hcode : ∀ p ∈ sha256_round_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hp : s.getReg .x10 &&& 3#64 = 0#64) (hsp : s.getReg .x2 &&& 7#64 = 0#64)
    (hv : HasCells s (s.getReg .x10) v.toList)
    (hstk : HasBytes s (s.getReg .x2 - 8#64) 8 m0)
    (hsep : Apart (s.getReg .x10) 32 (s.getReg .x2 - 8#64) 8) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      HasCells s' (s.getReg .x10)
        (roundKW ((s.getReg .x11).setWidth 32) ((s.getReg .x12).setWidth 32) v).toList ∧
      s'.getReg .x2 = s.getReg .x2 ∧ s'.getReg .x8 = s.getReg .x8 := by
  obtain ⟨hsep1, hsep2⟩ := hsep
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound_flat sha256_round_lowered
    (sha256_round_spec (s.getReg .x10) (s.getReg .x11) (s.getReg .x12) (s.getReg .x2) (s.getReg
        .x1) (s.getReg .x8) m0 v
      (s.getReg .x5) (s.getReg .x6) (s.getReg .x7) (s.getReg .x13) (s.getReg .x14) (s.getReg .x15)
          (s.getReg .x16) (s.getReg .x17) (s.getReg .x28) (s.getReg .x29) (s.getReg .x30)
          (s.getReg .x31) hp hsp) hcode
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
  refine ⟨n, s', hn, ?_, hasCells_of_holds hr hq (by braid_at), ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x2) (by decide)]; exact Atoms.reg_of_holds (r := 2) hq (by braid_at)
  · rw [← hr.getReg (r := .x8) (by decide)]; exact Atoms.reg_of_holds (r := 8) hq (by braid_at)

end Examples.Sha256.O2.RiscV
