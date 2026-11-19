/-
  Examples.Sha256.O2.RiscV.Schedule

  `sha256_schedule` of `sha256.c` on RISC-V: the message schedule of SHA-256, the 48 words
  that follow the sixteen of the block.

  The code keeps a pointer to the cell it fills next, and stops when the pointer is the end
  of the array. The loop is proved by induction on the cells still to fill, with an
  invariant: sixteen words before the pointer are a window of the schedule, and the array
  from the window on is what the induction is about; the words before the window are framed
  out. One iteration is run symbolically; that the word it stores is the next word of the
  schedule is a goal about bit vectors (`sha256_cell`). Each access is behind a guard for
  its alignment, so the array is at an address aligned to four bytes.

  This is the proof of `Examples.Sha256.RiscV.Schedule` again, on the binary compiled at `-O2`,
  where the compiler emits for `sha256_schedule` the instructions it emits at `-O1`, at the same
  addresses: the statements and the proofs are the same text, about the code of this binary.

  ## Main results

  * `sha256_schedule_spec`: the specification, with `Sha256.schedule`
  * `sha256_schedule_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256.O2.RiscV.Image
public import Examples.Sha256.RiscV.Machine
public import Examples.Sha256.RunTo

public section

namespace Examples.Sha256.O2.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64
open Examples.Sha256.RiscV

/-- Forget what the loop of the schedule leaves in the registers it uses. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 12; braid_forget 13; braid_forget 14; braid_forget 15
             braid_forget 16; braid_forget 17; braid_forget 5; braid_forget 6))

/-- The loop of `sha256_schedule`: with a window of sixteen words of the schedule at `q`,
`js.length + 1` cells after it, the last of them just before `e`, fill those cells with the
next words of the schedule. -/
theorem sha256_schedule_loop (e r : Word) : ∀ (js : List Word) (win : List W32) (j q : Word)
    (x12 x13 x14 x15 x16 x17 x5 x6 : Word), win.length = 16 → q &&& 3#64 = 0#64 →
    q + 64#64 + BitVec.ofNat 64 (4 * (js.length + 1)) = e → js.length + 1 ≤ 48 →
    Triple sha256_schedule.program
      (Atoms.interp [.pc 0x100ec#64, .reg a0 e, .reg a1 (q + 64#64), .reg a2 x12,
        .reg a3 x13, .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5,
        .reg t1 x6, .reg ra r, .prop (cellsAt 4 true q (w32s win ++ j :: js))])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 e, .reg a1 e, .prop (regAny a2),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .reg ra r,
        .prop (cellsAt 4 true q (w32s (extend (js.length + 1) win)))]) := by
  intro js
  induction js with
  | nil =>
    intro win j q x12 x13 x14 x15 x16 x17 x5 x6 hw hq he hb
    obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
      eq_of_length_16 hw
    simp only [List.length_nil, Nat.zero_add] at he ⊢
    rw [w32s_extend_one]
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    braid_unfold cells_win17 true (q' + 1#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
      j []
    braid_sym_run
    · exact absurd (by bv_omega) hbr
    · subst hbr
      braid_sym_run
      sha256_cell (q' + 65#64), (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12,
          w13, w14, w15]).setWidth 64
      sha256_fold cells_win17 true (q' + 1#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14
          w15
        ((nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14,
            w15]).setWidth 64) []
      schedule_forget
      braid_done
  | cons j' js ih =>
    intro win j q x12 x13 x14 x15 x16 x17 x5 x6 hw hq he hb
    obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
      eq_of_length_16 hw
    simp only [List.length_cons] at he hb ⊢
    rw [w32s_extend_succ]
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    braid_unfold cells_win17 true (q' + 1#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
      j (j' :: js)
    braid_sym_run
    · sha256_cell (q' + 65#64), (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12,
        w13, w14, w15]).setWidth 64
      sha256_fold cells_win16 true (q' + 5#64) w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
        (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]) (j' ::
            js)
      braid_call ih [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, nextWord
        [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]]
        j' (q' + 5#64) _ _ _ _ _ _ _ _ rfl (by bv_decide) (by rw [← he]; bv_omega) (by omega)
      sha256_fold cellsAt_cons (k := 4) (w := true) (q' + 1#64) (w0.setWidth 64)
        (w32s (extend (js.length + 1) [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13,
            w14, w15,
          nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]]))
      braid_done
    · exfalso
      rw [← hbr] at he
      bv_omega

/-- `sha256_schedule` fills the 48 cells after the sixteen words of a block, where its
argument points, with the rest of the message schedule of the block, and returns through
`ra`. The pointer is aligned to four bytes. It leaves `a0` at the end of the schedule. -/
theorem sha256_schedule_spec (p r x11 x12 x13 x14 x15 x16 x17 x5 x6 : Word) (M : List W32)
    (js : List Word) (hM : M.length = 16) (hjs : js.length = 48) (hp : p &&& 3#64 = 0#64) :
    Triple sha256_schedule.program
      (Atoms.interp [.pc 0x100e4#64, .reg a0 p, .reg a1 x11, .reg a2 x12, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg ra r, .prop (cellsAt 4 true p (w32s M ++ js))])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (p + 256#64), .prop (regAny a1),
        .prop (regAny a2), .prop (regAny a3), .prop (regAny a4), .prop (regAny a5),
        .prop (regAny a6), .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .reg ra r,
        .prop (cellsAt 4 true p (w32s (schedule M)))]) := by
  obtain ⟨j, js', rfl⟩ : ∃ j js', js = j :: js' := by
    cases js with
    | nil => simp at hjs
    | cons a b => exact ⟨a, b, rfl⟩
  have h47 : js'.length = 47 := by simpa using hjs
  rw [schedule_eq_extend M hM]
  braid_sym_run_to 0x100ec
  braid_call sha256_schedule_loop (p + 256#64) r js' M j p _ _ _ _ _ _ _ _ hM hp
    (by rw [h47]; bv_omega) (by omega)
  simp only [h47, Nat.reduceAdd]
  braid_forget 11
  braid_done

/-! ## On the machine -/

/-- **`sha256_schedule` on the machine.** A machine that holds the code of
`sha256_schedule`, is at its entry, and has 64 words in memory where `a0` points, the first
sixteen of them the block `M`, with `a0` aligned to four bytes, runs to the return address
with the message schedule of `M` where `a0` pointed. -/
theorem sha256_schedule_correct (s : MachineState) (M js : List W32)
    (hcode : ∀ p ∈ sha256_schedule_code, s.code p.1 = some p.2) (hpc : s.pc = 0x100e4#64)
    (hM : M.length = 16) (hjs : js.length = 48) (hp : s.getReg .x10 &&& 3#64 = 0#64)
    (hm : HasCells s (s.getReg .x10) (M ++ js)) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      HasCells s' (s.getReg .x10) (schedule M) := by
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound_flat sha256_schedule_lowered
    (sha256_schedule_spec (s.getReg .x10) (s.getReg .x1)
      (s.getReg .x11) (s.getReg .x12) (s.getReg .x13) (s.getReg .x14) (s.getReg .x15) (s.getReg
          .x16) (s.getReg .x17) (s.getReg .x5) (s.getReg .x6) M (w32s js) hM (by simpa using hjs)
          hp) hcode
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
  refine ⟨n, s', hn, ?_, hasCells_of_holds hr hq (by braid_at)⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

end Examples.Sha256.O2.RiscV
