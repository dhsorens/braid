/-
  Examples.Sha256.O2.X86.Schedule

  `sha256_schedule` of `sha256.c` on x86-64: the message schedule of SHA-256, the 48 words
  that follow the sixteen of the block.

  The loop is proved by induction on the cells still to fill, with an invariant: before the
  index the code keeps in `rax` there is a window of sixteen words of the schedule, and the
  array from the window on is what the induction is about; the words before the window are
  framed out. The code addresses the array from its start, with the index scaled, so the
  window is at an address written with the index, and closing the array for the induction
  hypothesis, whose index is one more, takes an equation between two addresses
  (`cells_win16_at`). One iteration is run symbolically; that the word it stores is the next
  word of the schedule is a goal about bit vectors (`sha256_cell`).

  This is the proof of `Examples.Sha256.X86.Schedule` again, on the binary compiled at `-O2`,
  where the compiler emits for `sha256_schedule` the instructions it emits at `-O1`, at the same
  addresses: the statements and the proofs are the same text, about the code of this binary.

  ## Main results

  * `sha256_schedule_spec`: the specification, with `Sha256.schedule`
  * `sha256_schedule_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256.O2.X86.Image
public import Examples.Sha256.X86.Machine
public import Examples.Sha256.RunTo

public section

namespace Examples.Sha256.O2.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs
open Examples.Sha256.X86

/-- An index scaled by four, as the lowering writes it: the stepper finds a memory atom by
its address as a term, and `i * 4#64` as the elaborator reads it has another type
argument. -/
local notation:70 i:70 " *₄ " => @HMul.hMul Word Word Word _ i (BitVec.ofNat 64 4)

/-- Forget what the loop of the schedule leaves in the registers it uses and in the flags. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 2; braid_forget 3; braid_forget 4; braid_forget 8
             x86_forget_all_flags))

/-- The loop of `sha256_schedule`: with a window of sixteen words of the schedule before
index `i` of the array at `p`, and `js.length + 1` cells from that index on, fill those
cells with the next words of the schedule. -/
theorem sha256_schedule_loop (p s r : Word) : ∀ (js : List Word) (win : List W32)
    (j i t2 t3 t4 t8 : Word) (c pf af z sg o : Bool), win.length = 16 →
    i + BitVec.ofNat 64 (js.length + 1) = 64#64 → js.length + 1 ≤ 48 →
    Triple sha256_schedule.program
      (Atoms.interp [.pc 0x4010b0#64, .reg rdi p, .reg rax i, .reg rcx t2, .reg rdx t3,
        .reg rsi t4, .reg r8 t8, .reg rsp s,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true (p + i *₄ - 64#64) (w32s win ++ j :: js)),
        .prop (cellsAt 8 true s [r])])
      (Atoms.interp [.pc r, .reg rdi p, .reg rax 64#64, .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .prop (regAny r8), .reg rsp (s + 8#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true (p + i *₄ - 64#64) (w32s (extend (js.length + 1) win))),
        .prop (cellsAt 8 true s [r])]) := by
  intro js
  induction js with
  | nil =>
    intro win j i t2 t3 t4 t8 c pf af z sg o hw he hb
    obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
      eq_of_length_16 hw
    simp only [List.length_nil, Nat.zero_add] at he ⊢
    rw [w32s_extend_one]
    obtain ⟨q, rfl⟩ : ∃ q : BitVec 64, p = q + 1#64 := ⟨p - 1#64, by bv_omega⟩
    braid_unfold cells_win17 true (q + 1#64 + i *₄ - 64#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11
      w12 w13 w14 w15 j []
    braid_unfold cellsAt_cons (k := 8) (w := true) s r []
    braid_sym_run
    · exact absurd (by bv_omega) hbr
    · braid_sym_run
      sha256_cell (q + (1#64 + i *₄)), (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11,
        w12, w13, w14, w15]).setWidth 64
      refine Triple.reg_val (r := 0) 64#64 (by braid_upd) he ?_
      sha256_fold cells_win17 true (q + 1#64 + i *₄ - 64#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11
        w12 w13 w14 w15
        ((nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]).setWidth
          64) []
      sha256_fold cellsAt_cons (k := 8) (w := true) s r []
      schedule_forget
      braid_done
  | cons j' js ih =>
    intro win j i t2 t3 t4 t8 c pf af z sg o hw he hb
    obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
      eq_of_length_16 hw
    simp only [List.length_cons] at he hb ⊢
    rw [w32s_extend_succ]
    obtain ⟨q, rfl⟩ : ∃ q : BitVec 64, p = q + 1#64 := ⟨p - 1#64, by bv_omega⟩
    braid_unfold cells_win17 true (q + 1#64 + i *₄ - 64#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11
      w12 w13 w14 w15 j (j' :: js)
    braid_sym_run
    · sha256_cell (q + (1#64 + i *₄)), (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11,
        w12, w13, w14, w15]).setWidth 64
      sha256_fold cells_win16_at true (q + 1#64 + i *₄ - 60#64)
        (q + 1#64 + (i + 1#64) *₄ - 64#64) (by bv_omega) w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13
          w14 w15
        (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]) (j' :: js)
      braid_name_flag 2
      braid_call ih [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, nextWord
        [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]]
        j' (i + 1#64) _ _ _ _ _ _ _ _ _ _ rfl (by bv_omega) (by omega)
      sha256_fold cells_cons_at true (q + 1#64 + i *₄ - 64#64)
        (q + 1#64 + (i + 1#64) *₄ - 64#64) (by bv_omega) (w0.setWidth 64)
        (w32s (extend (js.length + 1) [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14,
          w15,
          nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]]))
      braid_done
    · exact absurd hbr (by bv_omega)

/-- `sha256_schedule` fills the 48 cells after the sixteen words of a block, where its
argument points, with the rest of the message schedule of the block, and returns through the
address on the stack. -/
theorem sha256_schedule_spec (p s r t0 t2 t3 t4 t8 : Word) (M : List W32) (js : List Word)
    (c pf af z sg o : Bool) (hM : M.length = 16) (hjs : js.length = 48) :
    Triple sha256_schedule.program
      (Atoms.interp [.pc 0x4010a0#64, .reg rdi p, .reg rax t0, .reg rcx t2, .reg rdx t3,
        .reg rsi t4, .reg r8 t8, .reg rsp s,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true p (w32s M ++ js)), .prop (cellsAt 8 true s [r])])
      (Atoms.interp [.pc r, .reg rdi p, .reg rax 64#64, .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .prop (regAny r8), .reg rsp (s + 8#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true p (w32s (schedule M))), .prop (cellsAt 8 true s [r])]) := by
  obtain ⟨j, js', rfl⟩ : ∃ j js', js = j :: js' := by
    cases js with
    | nil => simp at hjs
    | cons a b => exact ⟨a, b, rfl⟩
  have h47 : js'.length = 47 := by simpa using hjs
  rw [schedule_eq_extend M hM]
  braid_sym_run_to 0x4010b0
  braid_call sha256_schedule_loop p s r js' M j 16#64 _ _ _ _ c pf af z sg o hM
    (by rw [h47]; rfl) (by omega)
  simp only [h47, Nat.reduceAdd]
  braid_done

/-! ## On the machine -/

/-- **`sha256_schedule` on the machine.** A machine of the model that runs the executable of
this image, is at the entry of `sha256_schedule`, has 64 words in memory where `rdi` points,
the first sixteen of them the block `M`, and the return address `r` in the eight bytes at the
stack pointer, apart from those words, reaches `r` on every run, with the message schedule
of `M` where `rdi` pointed. -/
theorem sha256_schedule_correct [Layout] (m : MachineState) (M js : List W32) (r : Word)
    (hpc : m.pc = 0x4010a0) (hM : M.length = 16) (hjs : js.length = 48)
    (hm : HasCells m (m.data.regs.get64 .rdi) (M ++ js))
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hsep : Apart (m.data.regs.get64 .rdi) 256 (m.data.regs.get64 .rsp) 8) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧ HasCells m' (m.data.regs.get64 .rdi) (schedule M) ∧
        m'.data.regs.get64 .rsp = (m.data.regs.get64 .rsp) + 8#64) m := by
  obtain ⟨hsep1, hsep2⟩ := hsep
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat sha256_schedule_holds
    (sha256_schedule_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsp) r
      (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx) (m.data.regs.get64 .rdx)
      (m.data.regs.get64 .rsi) (m.data.regs.get64 .r8) M (w32s js) m.data.status.cf
      m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of
      hM (by simpa using hjs))
    (flat := [.pc 0x4010a0#64, .reg rdi (m.data.regs.get64 .rdi), .reg rax (m.data.regs.get64 .rax),
      .reg rcx (m.data.regs.get64 .rcx), .reg rdx (m.data.regs.get64 .rdx),
      .reg rsi (m.data.regs.get64 .rsi), .reg r8 (m.data.regs.get64 .r8),
      .reg rsp (m.data.regs.get64 .rsp),
      .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
      .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
      .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of] ++
      (cellsAtoms 4 true (m.data.regs.get64 .rdi) (w32s M ++ w32s js) ++
      (cellsAtoms 8 true (m.data.regs.get64 .rsp) [r] ++ [])))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hM, hjs]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp), .nil, disj_nil_right⟩,
        disj_append_right
          (cellsAtoms_disj (by simp [hM, hjs]; bv_omega) (by simp; bv_omega))
          disj_nil_right⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, regOf, flagOf, hpc],
        List.forall_mem_append.2 ⟨by rw [← w32s_append]; exact hm.sat,
        List.forall_mem_append.2 ⟨sat_word hret, by simp⟩⟩⟩))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, hasCells_of_holds hr hq (by braid_at), ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rsp]
    exact Atoms.reg_of_holds (r := 6) hq (by braid_at)

end Examples.Sha256.O2.X86
