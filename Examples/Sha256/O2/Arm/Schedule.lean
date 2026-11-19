/-
  Examples.Sha256.O2.Arm.Schedule

  `sha256_schedule` of `sha256.c` on AArch64: the message schedule of SHA-256, the 48 words
  that follow the sixteen of the block.

  The loop is proved by induction on the cells still to fill, with an invariant: the pointer
  the code keeps is sixteen words beyond a window of sixteen words of the schedule, and the
  array from the window on is what the induction is about; the words before the window are
  framed out. One iteration is run symbolically; that the word it stores is the next word of
  the schedule is a goal about bit vectors (`sha256_cell`). That the window sliding 48 times
  is the schedule of the specification is `schedule_eq_extend`, about lists.

  This is the proof of `Examples.Sha256.Arm.Schedule` again, on the binary compiled at `-O2`,
  where the compiler emits for `sha256_schedule` the instructions it emits at `-O1`, at the
  same addresses: the statements and the proofs are the same text, about the code of this
  binary.

  ## Main results

  * `sha256_schedule_spec`: the specification, with `Sha256.schedule`
  * `sha256_schedule_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256.O2.Arm.Image
public import Examples.Sha256.Arm.Machine

public section

namespace Examples.Sha256.O2.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs
open Examples.Sha256.Arm

/-- Forget what the loop of the schedule leaves in the registers it uses and in the flags. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 9; braid_forget 10; braid_forget 11; braid_forget 12
             braid_forget 13; braid_forget 14; braid_forget 15
             braid_forget_flag 0; braid_forget_flag 1; braid_forget_flag 2
             braid_forget_flag 3))

/-- The loop of `sha256_schedule`: with a window of sixteen words of the schedule at `q` and
`js.length + 1` cells after it, fill those cells with the next words of the schedule. -/
theorem sha256_schedule_loop (p r : Word) : ∀ (js : List Word) (win : List W32) (j : Word)
    (q c t10 t11 t12 t13 t14 t15 : Word) (fn fz fc fv : Bool), win.length = 16 →
    c = BitVec.ofNat 64 (js.length + 1) → js.length + 1 < 2 ^ 64 →
    Triple sha256_schedule.program
      (Atoms.interp [.pc 0x1007c#64, .reg x0 p, .reg x8 c, .reg x9 (q + 64#64),
        .reg x10 t10, .reg x11 t11, .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15,
        .reg lr r, .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 true q (w32s win ++ j :: js))])
      (Atoms.interp [.pc r, .reg x0 p, .reg x8 0#64, .prop (regAny x9),
        .prop (regAny x10), .prop (regAny x11), .prop (regAny x12), .prop (regAny x13),
        .prop (regAny x14), .prop (regAny x15), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 4 true q (w32s (extend (js.length + 1) win)))]) := by
  intro js
  induction js with
  | nil =>
    intro win j q c t10 t11 t12 t13 t14 t15 fn fz fc fv hw he hb
    obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
      eq_of_length_16 hw
    have he' : c = 1#64 := by simpa using he
    subst he'
    simp only [List.length_nil, Nat.zero_add]
    rw [w32s_extend_one]
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    braid_unfold cells_win17 true (q' + 1#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
      j []
    braid_sym_run
    sha256_cell (q' + 65#64), (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12,
      w13, w14, w15]).setWidth 64
    sha256_fold cells_win17 true (q' + 1#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
      ((nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]).setWidth
        64) []
    schedule_forget
    braid_done
  | cons j' js ih =>
    intro win j q c t10 t11 t12 t13 t14 t15 fn fz fc fv hw he hb
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
        (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15])
        (j' :: js)
      braid_call ih [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, nextWord
        [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]]
        j' (q' + 5#64) (c + 18446744073709551615#64) _ _ _ _ _ _ _ _ _ _ rfl (by rw [he]; bv_omega)
          (by omega)
      sha256_fold cellsAt_cons (k := 4) (w := true) (q' + 1#64) (w0.setWidth 64)
        (w32s (extend (js.length + 1) [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14,
          w15,
          nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]]))
      braid_done
    · exfalso
      have : c ≠ 1#64 := by rw [he]; bv_omega
      exact this hbr

/-- `sha256_schedule` fills the 48 cells after the sixteen words of a block, where its
argument points, with the rest of the message schedule of the block. -/
theorem sha256_schedule_spec (p r t8 t9 t10 t11 t12 t13 t14 t15 : Word) (M : List W32)
    (js : List Word) (fn fz fc fv : Bool) (hM : M.length = 16) (hjs : js.length = 48) :
    Triple sha256_schedule.program
      (Atoms.interp [.pc 0x10074#64, .reg x0 p, .reg x8 t8, .reg x9 t9,
        .reg x10 t10, .reg x11 t11, .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15,
        .reg lr r, .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 true p (w32s M ++ js))])
      (Atoms.interp [.pc r, .reg x0 p, .reg x8 0#64, .prop (regAny x9),
        .prop (regAny x10), .prop (regAny x11), .prop (regAny x12), .prop (regAny x13),
        .prop (regAny x14), .prop (regAny x15), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v), .prop (cellsAt 4 true p (w32s (schedule M)))]) := by
  obtain ⟨j, js', rfl⟩ : ∃ j js', js = j :: js' := by
    cases js with
    | nil => simp at hjs
    | cons a b => exact ⟨a, b, rfl⟩
  have h47 : js'.length = 47 := by simpa using hjs
  rw [schedule_eq_extend M hM]
  braid_sym_step
  braid_sym_step
  braid_call sha256_schedule_loop p r js' M j p 48#64 t10 t11 t12 t13 t14 t15 fn fz fc fv hM
    (by rw [h47]) (by omega)
  simp only [h47, Nat.reduceAdd]
  braid_done

/-! ## On the machine -/

/-- **`sha256_schedule` on the machine.** A running machine whose program holds the words of
`sha256_schedule`, with its code loaded and its program counter at the entry, and with 64
words in memory where `x0` points, the first sixteen of them the block `M`, runs to the
address in the link register with the message schedule of `M` there. -/
theorem sha256_schedule_correct (prog : Arm64.Program) (s : Arm64.State) (M js : List W32)
    (hw : prog.hasWords 0x10074#64 sha256_schedule_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10074#64)
    (hM : M.length = 16) (hjs : js.length = 48)
    (hm : HasCells s (s.regs.read 0#5) (M ++ js)) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      HasCells s' (s.regs.read 0#5) (schedule M) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat sha256_schedule_lowered
    (sha256_schedule_spec (s.regs.read 0#5) (s.regs.read 30#5) (s.regs.read 8#5)
      (s.regs.read 9#5) (s.regs.read 10#5) (s.regs.read 11#5) (s.regs.read 12#5)
      (s.regs.read 13#5) (s.regs.read 14#5) (s.regs.read 15#5) M (w32s js) s.pstate.n
      s.pstate.z s.pstate.c s.pstate.v hM (by simpa using hjs)) hw hc hrun
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
  refine ⟨s', hsteps, ?_, hasCells_of_holds hr hq (by braid_at)⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

end Examples.Sha256.O2.Arm
