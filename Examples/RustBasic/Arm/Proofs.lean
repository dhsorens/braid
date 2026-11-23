/-
  Examples.RustBasic.Arm.Proofs

  `basic.rs` on AArch64: straight-line code, a conditional select, Euclid's algorithm with a
  division and a multiply-subtract for the remainder, and a loop over a slice.
-/

module

public import Examples.RustBasic.Arm.Image
public import Examples.ArmMachine
public import Examples.Spec
import Braid.BV

public section

namespace Examples.RustBasic.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- `add3` returns the sum of its arguments. -/
theorem add3_spec (a b c t r : Word) :
    Triple add3.program
      (Atoms.interp [.pc 0x10004#64, .reg x0 a, .reg x1 b, .reg x2 c, .reg x8 t, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (b + (a + c)), .reg x1 b, .reg x2 c, .reg x8 (b + a),
        .reg lr r]) := by
  braid_run
  braid_done

/-- `max_u64` returns the larger of its arguments. It sets the flags. -/
theorem max_u64_spec (a b r : Word) (fn fz fc fv : Bool) :
    Triple max_u64.program
      (Atoms.interp [.pc 0x1002c#64, .reg x0 a, .reg x1 b, .reg lr r,
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

/-- The loop of `gcd`, entered with a divisor that is not zero. -/
theorem gcd_loop (r : Word) (k : Nat) : ∀ a b t : Word, b.toNat = k → b ≠ 0#64 →
    Triple gcd.program
      (Atoms.interp [.pc 0x10014#64, .reg x0 a, .reg x1 b, .reg x8 t, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (wgcd a b), .reg x1 0#64, .reg x8 0#64, .reg lr r]) := by
  induction k using Nat.strongRecOn with
  | ind k ih =>
    intro a b t hk hb
    iterate 4 braid_step
    simp only [sub_udiv_mul]
    braid_step
    · refine (ih _ ?_ b (a % b) _ rfl hbr).cast rfl (by simp [wgcd_rec a b])
      rw [← hk, BitVec.toNat_umod]
      exact Nat.mod_lt _ (Nat.pos_of_ne_zero fun h => hb (BitVec.eq_of_toNat_eq h))
    · braid_run
      exact Triple.done_eq (by simp [wgcd_rec a b, hbr, wgcd_zero])

/-- `gcd` returns the greatest common divisor of its arguments. -/
theorem gcd_spec (a b t r : Word) :
    Triple gcd.program
      (Atoms.interp [.pc 0x10010#64, .reg x0 a, .reg x1 b, .reg x8 t, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (wgcd a b), .prop (regAny x1), .prop (regAny x8),
        .reg lr r]) := by
  braid_step
  · braid_call gcd_loop r _ a b t rfl hbr
    braid_forget 1
    braid_forget 8
    braid_done
  · subst hbr
    braid_run
    braid_forget 1
    braid_forget 8
    exact Triple.done_eq (by simp [wgcd_zero])

/-- **`gcd` on the machine.** A running machine whose program holds the words of `gcd`, with
its code loaded and its program counter at the entry, runs to the address in the link
register with the greatest common divisor of `x0` and `x1` in `x0`. -/
theorem gcd_correct (prog : Arm64.Program) (s : Arm64.State)
    (hw : prog.hasWords 0x10010#64 gcd_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10010#64) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 =
        BitVec.ofNat 64 (Nat.gcd (s.regs.read 0#5).toNat (s.regs.read 1#5).toNat) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound gcd_lowered
    (gcd_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 8#5) (s.regs.read 30#5))
    hw hc hrun (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, regOf, hpc])
  refine ⟨s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) (v := wgcd _ _) hq (by braid_at)

/-- The loop of `sum_slice`, with the words `x :: xs` still to add and `e` bytes left. -/
theorem sum_slice_loop (r : Word) : ∀ (xs : List Word) (x q e acc t10 : Word)
    (fn fz fc fv : Bool), e = BitVec.ofNat 64 (8 * (xs.length + 1)) →
    8 * (xs.length + 1) < 2 ^ 64 →
    Triple sum_slice.program
      (Atoms.interp [.pc 0x10044#64, .reg x0 q, .reg x8 acc, .reg x9 e, .reg x10 t10,
        .prop (wordsAt q (x :: xs)), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (wsum (x :: xs) acc), .reg x8 (wsum (x :: xs) acc),
        .reg x9 0#64, .prop (regAny x10), .prop (wordsAt q (x :: xs)), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  intro xs
  induction xs with
  | nil =>
    intro x q e acc t10 fn fz fc fv he hb
    have he' : e = 8#64 := by simpa using he
    subst he'
    braid_unfold wordsAt_cons q x []
    braid_run
    braid_fold wordsAt_cons q x []
    braid_forget 10
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    simp only [wsum, List.foldl_cons, List.foldl_nil]
    braid_done
  | cons y ys ih =>
    intro x q e acc t10 fn fz fc fv he hb
    simp only [List.length_cons] at he hb
    braid_unfold wordsAt_cons q x (y :: ys)
    iterate 3 braid_step
    braid_step
    · braid_call ih y (q + 8#64) (e + 0xfffffffffffffff8#64) (x + acc) _ _ _ _ _
        (by rw [he]; bv_omega) (by omega)
      braid_fold wordsAt_cons q x (y :: ys)
      simp only [wsum, List.foldl_cons]
      braid_done
    · exfalso
      have : e ≠ 8#64 := by rw [he]; bv_omega
      exact this (by simpa using hbr)

/-- `sum_slice` returns the sum of the words of a slice, given as a pointer and a length. -/
theorem sum_slice_spec (p t8 t9 t10 r : Word) (xs : List Word) (fn fz fc fv : Bool)
    (hl : xs.length < 2 ^ 61) :
    Triple sum_slice.program
      (Atoms.interp [.pc 0x10038#64, .reg x0 p, .reg x1 (BitVec.ofNat 64 xs.length),
        .reg x8 t8, .reg x9 t9, .reg x10 t10, .prop (wordsAt p xs), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (wsum xs 0#64), .reg x1 (BitVec.ofNat 64 xs.length),
        .reg x8 (wsum xs 0#64), .prop (regAny x9), .prop (regAny x10), .prop (wordsAt p xs),
        .reg lr r, .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  cases xs with
  | nil =>
    simp only [List.length_nil]
    braid_run
    braid_forget 9
    braid_forget 10
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    simp only [wsum, List.foldl_nil]
    braid_done
  | cons x xs =>
    simp only [List.length_cons] at hl ⊢
    braid_step
    · iterate 2 braid_step
      have he : BitVec.ofNat 64 (xs.length + 1) <<< 3#64 =
          BitVec.ofNat 64 (8 * (xs.length + 1)) := by
        apply BitVec.eq_of_toNat_eq
        simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
        omega
      braid_call sum_slice_loop r xs x p _ 0#64 t10 _ _ _ _ he (by omega)
      braid_forget 9
      braid_done
    · exfalso
      have : BitVec.ofNat 64 (xs.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)

/-! ## On the machine -/

/-- **`add3` on the machine.** A running machine whose program holds the words of `add3`, with
its code loaded and its program counter at the entry, runs to the address in the link register
with the sum of `x0`, `x1` and `x2` in `x0`. -/
theorem add3_correct (prog : Arm64.Program) (s : Arm64.State)
    (hw : prog.hasWords 0x10004#64 add3_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10004#64) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = s.regs.read 1#5 + (s.regs.read 0#5 + s.regs.read 2#5) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound add3_lowered
    (add3_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 2#5) (s.regs.read 8#5)
      (s.regs.read 30#5)) hw hc hrun
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, regOf, hpc])
  refine ⟨s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) hq (by braid_at)

/-- **`max_u64` on the machine.** A running machine whose program holds the words of `max_u64`,
with its code loaded and its program counter at the entry, runs to the address in the link
register with the larger of `x0` and `x1`, as unsigned numbers, in `x0`. -/
theorem max_u64_correct (prog : Arm64.Program) (s : Arm64.State)
    (hw : prog.hasWords 0x1002c#64 max_u64_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x1002c#64) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = umax (s.regs.read 0#5) (s.regs.read 1#5) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound max_u64_lowered
    (max_u64_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5) s.pstate.n s.pstate.z
      s.pstate.c s.pstate.v) hw hc hrun
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
      Flags.v, hpc])
  refine ⟨s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) (v := umax _ _) hq (by braid_at)

/-- **`sum_slice` on the machine.** A running machine whose program holds the words of
`sum_slice`, with its code loaded and its program counter at the entry, and with the words
`xs` in memory where `x0` points and their number in `x1`, runs to the address in the link
register with their sum in `x0`. -/
theorem sum_slice_correct (prog : Arm64.Program) (s : Arm64.State) (xs : List Word)
    (hw : prog.hasWords 0x10038#64 sum_slice_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10038#64) (hl : xs.length < 2 ^ 61)
    (hn : s.regs.read 1#5 = BitVec.ofNat 64 xs.length)
    (hmem : ∀ (i : Nat) (hi : i < xs.length),
      HasBytes s (s.regs.read 0#5 + BitVec.ofNat 64 (8 * i)) 8 xs[i]) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = wsum xs 0#64 := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat sum_slice_lowered
    (sum_slice_spec (s.regs.read 0#5) (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5)
      (s.regs.read 30#5) xs s.pstate.n s.pstate.z s.pstate.c s.pstate.v hl) hw hc hrun
    (flat := [.pc 0x10038#64, .reg x0 (s.regs.read 0#5), .reg x1 (BitVec.ofNat 64 xs.length),
      .reg x8 (s.regs.read 8#5), .reg x9 (s.regs.read 9#5), .reg x10 (s.regs.read 10#5)] ++
      wordsAtoms (s.regs.read 0#5) xs ++
      [.reg lr (s.regs.read 30#5), .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z,
        .flag Flags.c s.pstate.c, .flag Flags.v s.pstate.v])
    (by rw [wordsAt_eq_interp]
        exact Atoms.interp_flatten [.pc 0x10038#64, .reg x0 (s.regs.read 0#5),
          .reg x1 (BitVec.ofNat 64 xs.length), .reg x8 (s.regs.read 8#5),
          .reg x9 (s.regs.read 9#5), .reg x10 (s.regs.read 10#5)] _ _)
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

end Examples.RustBasic.Arm
