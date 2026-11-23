/-
  Examples.Memory.Arm.Proofs

  `memory.c` on AArch64: loads and stores, a loop with a post-indexed load, a call with a
  stack frame, and a tail call. The specifications are those of the RISC-V proofs, with
  AArch64's registers and flags.
-/

module

public import Examples.Memory.Arm.Image
public import Examples.ArmMachine
public import Examples.Spec
import Braid.BV

public section

namespace Examples.Memory.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- `swap` exchanges the two words its arguments point to. -/
theorem swap_spec (p q x y t8 t9 r : Word) :
    Triple swap.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 p, .reg x1 q, .reg x8 t8, .reg x9 t9,
        .mem p 8 x true, .mem q 8 y true, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 p, .reg x1 q, .reg x8 y, .reg x9 x,
        .mem p 8 y true, .mem q 8 x true, .reg lr r]) := by
  braid_run
  braid_done

/-- `max2` returns the larger of its arguments. It sets the flags. -/
theorem max2_spec (a b r : Word) (fn fz fc fv : Bool) :
    Triple max2.program
      (Atoms.interp [.pc 0x10034#64, .reg x0 a, .reg x1 b, .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (umax a b), .reg x1 b, .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  braid_run
  braid_forget_flag 0
  braid_forget_flag 1
  braid_forget_flag 2
  braid_forget_flag 3
  refine Triple.done_eq ?_
  simp only [umax, ofBool]
  by_cases h1 : a = b <;> by_cases h2 : b.ule a <;> simp_all
  all_goals bv_auto

/-- `max2` and `max3` together. -/
def prog : Braid.Program := Braid.Program.ofList (max2.blocks ++ max3.blocks)

theorem max2_spec' (a b r : Word) (fn fz fc fv : Bool) :
    Triple prog
      (Atoms.interp [.pc 0x10034#64, .reg x0 a, .reg x1 b, .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (umax a b), .reg x1 b, .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) :=
  (max2_spec a b r fn fz fc fv).mono
    (Braid.Program.ofList_mono (fun _ h => List.mem_append_left _ h) (by decide))

/-- `max3` returns the largest of its arguments. It keeps its third argument in a
callee-saved register, saved in its frame, across a call of `max2`, and returns through a
tail call. -/
theorem max3_spec (a b c v19 fp0 s r m0 m1 m2 : Word) (fn fz fc fv : Bool)
    (hs : s &&& 15#64 = 0#64) :
    Triple prog
      (Atoms.interp [.pc 0x10040#64, .reg x0 a, .reg x1 b, .reg x2 c, .reg x19 v19,
        .reg x29 fp0, .reg lr r, .reg sp s, .mem (s - 32#64) 8 m0 true,
        .mem (s - 24#64) 8 m1 true, .mem (s - 16#64) 8 m2 true,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (umax (umax a b) c), .reg x1 c, .reg x2 c, .reg x19 v19,
        .reg x29 fp0, .reg lr r, .reg sp s, .mem (s - 32#64) 8 fp0 true,
        .mem (s - 24#64) 8 r true, .mem (s - 16#64) 8 v19 true,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  iterate 5 braid_step
  braid_call max2_spec' _ _ _ _ _ _ _
  iterate 4 braid_step
  braid_name_flag 0
  braid_name_flag 1
  braid_name_flag 2
  braid_name_flag 3
  braid_call max2_spec' _ _ _ _ _ _ _
  braid_done

/-- The loop of `sum_array`, with the words `x :: xs` still to add. -/
theorem sum_array_loop (r : Word) : ∀ (xs : List Word) (x q n acc t9 : Word)
    (fn fz fc fv : Bool), n = BitVec.ofNat 64 (xs.length + 1) → xs.length + 1 < 2 ^ 64 →
    Triple sum_array.program
      (Atoms.interp [.pc 0x1001c#64, .reg x0 q, .reg x1 n, .reg x8 acc, .reg x9 t9,
        .prop (wordsAt q (x :: xs)), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (wsum (x :: xs) acc), .reg x1 0#64,
        .reg x8 (wsum (x :: xs) acc), .prop (regAny x9), .prop (wordsAt q (x :: xs)),
        .reg lr r, .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  intro xs
  induction xs with
  | nil =>
    intro x q n acc t9 fn fz fc fv he hb
    have he' : n = 1#64 := by simpa using he
    subst he'
    braid_unfold wordsAt_cons q x []
    braid_run
    braid_fold wordsAt_cons q x []
    braid_forget 9
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    simp only [wsum, List.foldl_cons, List.foldl_nil]
    braid_done
  | cons y ys ih =>
    intro x q n acc t9 fn fz fc fv he hb
    simp only [List.length_cons] at he hb
    braid_unfold wordsAt_cons q x (y :: ys)
    iterate 3 braid_step
    braid_step
    · braid_call ih y (q + 8#64) (n + 0xffffffffffffffff#64) (x + acc) _ _ _ _ _
        (by rw [he]; bv_omega) (by omega)
      braid_fold wordsAt_cons q x (y :: ys)
      simp only [wsum, List.foldl_cons]
      braid_done
    · exfalso
      have : n ≠ 1#64 := by rw [he]; bv_omega
      exact this (by simpa using hbr)

/-- `sum_array` returns the sum of the `n` words its first argument points to. -/
theorem sum_array_spec (p t8 t9 r : Word) (xs : List Word) (fn fz fc fv : Bool)
    (hl : xs.length < 2 ^ 64) :
    Triple sum_array.program
      (Atoms.interp [.pc 0x10014#64, .reg x0 p, .reg x1 (BitVec.ofNat 64 xs.length),
        .reg x8 t8, .reg x9 t9, .prop (wordsAt p xs), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (wsum xs 0#64), .prop (regAny x1), .reg x8 (wsum xs 0#64),
        .prop (regAny x9), .prop (wordsAt p xs), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  cases xs with
  | nil =>
    simp only [List.length_nil]
    braid_run
    braid_forget 1
    braid_forget 9
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    simp only [wsum, List.foldl_nil]
    braid_done
  | cons x xs =>
    simp only [List.length_cons] at hl ⊢
    braid_step
    braid_step
    · braid_call sum_array_loop r xs x p _ 0#64 t9 _ _ _ _ rfl hl
      braid_forget 1
      braid_done
    · exfalso
      have : BitVec.ofNat 64 (xs.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)

/-! ## On the machine -/

/-- **`max2` on the machine.** A running machine whose program holds the words of `max2`, with
its code loaded and its program counter at the entry, runs to the address in the link register
with the larger of `x0` and `x1`, as unsigned numbers, in `x0`. -/
theorem max2_correct (prog : Arm64.Program) (s : Arm64.State)
    (hw : prog.hasWords 0x10034#64 max2_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10034#64) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = umax (s.regs.read 0#5) (s.regs.read 1#5) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound max2_lowered
    (max2_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5) s.pstate.n s.pstate.z
      s.pstate.c s.pstate.v) hw hc hrun
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
      Flags.v, hpc])
  refine ⟨s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) (v := umax _ _) hq (by braid_at)

/-- **`swap` on the machine.** A running machine whose program holds the words of `swap`,
with its code loaded and its program counter at the entry, and with the words `x` and `y` in
memory where `x0` and `x1` point, apart from one another, runs to the address in the link
register with `y` where `x0` points and `x` where `x1` points. -/
theorem swap_correct (prog : Arm64.Program) (s : Arm64.State) (x y : Word)
    (hw : prog.hasWords 0x10000#64 swap_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64)
    (hx : HasBytes s (s.regs.read 0#5) 8 x) (hy : HasBytes s (s.regs.read 1#5) 8 y)
    (hd : Apart (s.regs.read 0#5) 8 (s.regs.read 1#5) 8) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      HasBytes s' (s.regs.read 0#5) 8 y ∧ HasBytes s' (s.regs.read 1#5) 8 x := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound swap_lowered
    (swap_spec (s.regs.read 0#5) (s.regs.read 1#5) x y (s.regs.read 8#5) (s.regs.read 9#5)
      (s.regs.read 30#5)) hw hc hrun
    (by simp [Atom.IsPointsTo]) (by braid_disj_mem; exact disj_mem_of_apart hd)
    (by simp [Atom.sat_reg, Atom.sat_pc, sat_mem_hasBytes, regOf, hpc, hx, hy])
  refine ⟨s', hsteps, ?_, hasBytes_of_holds hr hq (by braid_at),
    hasBytes_of_holds hr hq (by braid_at)⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`max3` on the machine.** A running machine whose program holds the words of `max3` and
of `max2`, which it calls, with its code loaded and its program counter at the entry of
`max3`, whose stack pointer is aligned and has three words of memory below it, runs to the
address in the link register with the largest of `x0`, `x1` and `x2`, as unsigned numbers, in
`x0`. The stack pointer, the frame pointer and `x19` are as they were. -/
theorem max3_correct (prog : Arm64.Program) (s : Arm64.State) (m0 m1 m2 : Word)
    (hw : prog.hasWords 0x10040#64 max3_words) (hw2 : prog.hasWords 0x10034#64 max2_words)
    (hc : prog.CodeLoaded s.mem) (hrun : s.status = .Running) (hpc : s.pc = 0x10040#64)
    (hsp : s.sp &&& 15#64 = 0#64) (h0 : HasBytes s (s.sp - 32#64) 8 m0)
    (h1 : HasBytes s (s.sp - 24#64) 8 m1) (h2 : HasBytes s (s.sp - 16#64) 8 m2) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = umax (umax (s.regs.read 0#5) (s.regs.read 1#5)) (s.regs.read 2#5) ∧
      s'.sp = s.sp ∧ s'.regs.read 29#5 = s.regs.read 29#5 ∧
      s'.regs.read 19#5 = s.regs.read 19#5 := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound₂ max2_lowered max3_lowered
    (max3_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 2#5) (s.regs.read 19#5)
      (s.regs.read 29#5) s.sp (s.regs.read 30#5) m0 m1 m2 s.pstate.n s.pstate.z s.pstate.c
      s.pstate.v hsp) hw2 hw hc hrun
    (by simp [Atom.IsPointsTo]) (by braid_disj_mem)
    (by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, sat_mem_hasBytes, regOf, Flags.n,
      Flags.z, Flags.c, Flags.v, hpc, h0, h1, h2])
  refine ⟨s', hsteps, ?_, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) (v := umax _ _) hq (by braid_at)
  · rw [← hr.sp]; exact Atoms.reg_of_holds (r := 31) hq (by braid_at)
  · rw [← hr.readReg (i := 29#5) (by decide)]
    exact Atoms.reg_of_holds (r := 29) hq (by braid_at)
  · rw [← hr.readReg (i := 19#5) (by decide)]
    exact Atoms.reg_of_holds (r := 19) hq (by braid_at)

/-- **`sum_array` on the machine.** A running machine whose program holds the words of
`sum_array`, with its code loaded and its program counter at the entry, and with the words
`xs` in memory where `x0` points and their number in `x1`, runs to the address in the link
register with their sum in `x0`. -/
theorem sum_array_correct (prog : Arm64.Program) (s : Arm64.State) (xs : List Word)
    (hw : prog.hasWords 0x10014#64 sum_array_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10014#64) (hl : xs.length < 2 ^ 61)
    (hn : s.regs.read 1#5 = BitVec.ofNat 64 xs.length)
    (hmem : ∀ (i : Nat) (hi : i < xs.length),
      HasBytes s (s.regs.read 0#5 + BitVec.ofNat 64 (8 * i)) 8 xs[i]) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = wsum xs 0#64 := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat sum_array_lowered
    (sum_array_spec (s.regs.read 0#5) (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 30#5)
      xs s.pstate.n s.pstate.z s.pstate.c s.pstate.v (by omega)) hw hc hrun
    (flat := [.pc 0x10014#64, .reg x0 (s.regs.read 0#5), .reg x1 (BitVec.ofNat 64 xs.length),
      .reg x8 (s.regs.read 8#5), .reg x9 (s.regs.read 9#5)] ++
      wordsAtoms (s.regs.read 0#5) xs ++
      [.reg lr (s.regs.read 30#5), .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z,
        .flag Flags.c s.pstate.c, .flag Flags.v s.pstate.v])
    (by rw [wordsAt_eq_interp]
        exact Atoms.interp_flatten [.pc 0x10014#64, .reg x0 (s.regs.read 0#5),
          .reg x1 (BitVec.ofNat 64 xs.length), .reg x8 (s.regs.read 8#5),
          .reg x9 (s.regs.read 9#5)] _ _)
    (Atoms.forall_flat (by simp [Atom.IsPointsTo]) wordsAtoms_isPointsTo)
    (Atoms.pairwise_flat (by braid_disj) (wordsAtoms_pairwise (by omega))
      (by braid_disj_array))
    (Atoms.forall_flat
      (by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
        Flags.v, hpc, hn])
      (wordsAtoms_sat fun i hi => sat_mem_hasBytes.2 (hmem i hi)))
  refine ⟨s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) (v := wsum _ _) hq (by braid_at)

end Examples.Memory.Arm
