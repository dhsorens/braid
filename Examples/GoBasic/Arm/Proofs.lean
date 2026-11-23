/-
  Examples.GoBasic.Arm.Proofs

  `basic.go` on AArch64, compiled by Go's own back end. Go passes arguments in `x0`, `x1`,
  `x2` and returns in `x0`, as its internal ABI says. The binary holds the whole Go runtime;
  these are the three functions of the source.
-/

module

public import Examples.GoBasic.Arm.Image
public import Examples.ArmMachine
public import Examples.Spec
import Braid.BV

public section

namespace Examples.GoBasic.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- `main.Add3` returns the sum of its arguments. -/
theorem main_Add3_spec (a b c r : Word) :
    Triple main_Add3.program
      (Atoms.interp [.pc 0x84500#64, .reg x0 a, .reg x1 b, .reg x2 c, .reg lr r])
      (Atoms.interp [.pc r, .reg x0 (c + (b + a)), .reg x1 (b + a), .reg x2 c, .reg lr r]) := by
  braid_run
  braid_done

/-- `main.MaxU64` returns the larger of its arguments. -/
theorem main_MaxU64_spec (a b r : Word) (fn fz fc fv : Bool) :
    Triple main_MaxU64.program
      (Atoms.interp [.pc 0x84510#64, .reg x0 a, .reg x1 b, .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (umax a b), .reg x1 b, .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  braid_step
  braid_step
  all_goals
    braid_run
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    refine Triple.done_eq ?_
    have h : b.ult a = !a.ule b := by bv_auto
    simp [umax, h, hbr]

/-- After `cmp a, b`, the condition `gt` is the signed comparison. -/
theorem cond_gt (a b : Word) :
    BitVec.ult (ofBool (a == b))
      (ofBool (ofBool (BitVec.slt (a - b) 0#64) ==
        ofBool (BitVec.slt ((a ^^^ b) &&& (a ^^^ a - b)) 0#64))) = b.slt a := by
  simp only [ofBool]
  bv_auto

/-- The loop of `main.SumSlice`, from index `i`, with `rest` still to add. -/
theorem main_SumSlice_loop (p len r : Word) : ∀ (rest : List Word) (i acc t4 : Word)
    (fn fz fc fv : Bool), i + BitVec.ofNat 64 rest.length = len → len.toNat < 2 ^ 61 →
    i.toNat + rest.length < 2 ^ 61 →
    Triple main_SumSlice.program
      (Atoms.interp [.pc 0x8454c#64, .reg x0 p, .reg x1 len, .reg x2 i, .reg x3 acc, .reg x4 t4,
        .prop (wordsAt (p + i <<< 3#64) rest), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (wsum rest acc), .reg x1 len, .reg x2 len,
        .reg x3 (wsum rest acc), .prop (regAny x4), .prop (wordsAt (p + i <<< 3#64) rest),
        .reg lr r, .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  intro rest
  induction rest with
  | nil =>
    intro i acc t4 fn fz fc fv he hlen hi
    have hil : i = len := by simpa using he
    subst hil
    braid_step
    braid_step
    · rw [cond_gt] at hbr
      exact absurd hbr (by simp [BitVec.slt])
    · braid_run
      braid_forget 4
      braid_forget_flag 0
      braid_forget_flag 1
      braid_forget_flag 2
      braid_forget_flag 3
      simp only [wsum, List.foldl_nil]
      braid_done
  | cons x xs ih =>
    intro i acc t4 fn fz fc fv he hlen hi
    simp only [List.length_cons] at he hi
    braid_step
    braid_step
    · braid_unfold wordsAt_cons (p + i <<< 3#64) x xs
      iterate 3 braid_step
      have e : p + (i <<< 3#64 + 8#64) = p + (i + 1#64) <<< 3#64 := by bv_auto
      rw [e]
      braid_call ih (i + 1#64) (acc + x) x _ _ _ _ (by rw [← he]; bv_omega) hlen (by bv_omega)
      rw [← e]
      braid_fold wordsAt_cons (p + i <<< 3#64) x xs
      simp only [wsum, List.foldl_cons, BitVec.add_comm x acc]
      braid_done
    · exfalso
      rw [cond_gt] at hbr
      have : i.slt len = true := by
        have h1 : i < len := by rw [← he]; bv_omega
        have h2 : len < 2305843009213693952#64 := by bv_omega
        bv_auto
      simp [this] at hbr

/-- `main.SumSlice` returns the sum of the words of a slice, given as a pointer and a length.
It first saves the pointer in the word above the stack pointer, as Go's calling convention
has a function do with a register argument. -/
theorem main_SumSlice_spec (p t2 t3 t4 s old r : Word) (xs : List Word) (fn fz fc fv : Bool)
    (hs : s &&& 15#64 = 0#64) (hl : xs.length < 2 ^ 61) :
    Triple main_SumSlice.program
      (Atoms.interp [.pc 0x84530#64, .reg x0 p, .reg x1 (BitVec.ofNat 64 xs.length),
        .reg x2 t2, .reg x3 t3, .reg x4 t4, .reg sp s, .mem (s + 8#64) 8 old true,
        .prop (wordsAt p xs), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (wsum xs 0#64), .reg x1 (BitVec.ofNat 64 xs.length),
        .reg x2 (BitVec.ofNat 64 xs.length), .reg x3 (wsum xs 0#64), .prop (regAny x4),
        .reg sp s, .mem (s + 8#64) 8 p true, .prop (wordsAt p xs), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  have hloop := main_SumSlice_loop p (BitVec.ofNat 64 xs.length) r xs 0#64 0#64 t4 fn fz fc fv
    (by simp) (by simp; omega) (by simpa using hl)
  have e : p + 0#64 <<< 3#64 = p := by bv_auto
  rw [e] at hloop
  iterate 4 braid_step
  braid_call hloop
  braid_done

/-! ## On the machine -/

/-- **`main.Add3` on the machine.** A running machine whose program holds the words of
`main.Add3`, with its code loaded and its program counter at the entry, runs to the address in
the link register with the sum of `x0`, `x1` and `x2` in `x0`. -/
theorem main_Add3_correct (prog : Arm64.Program) (s : Arm64.State)
    (hw : prog.hasWords 0x84500#64 main_Add3_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x84500#64) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = s.regs.read 2#5 + (s.regs.read 1#5 + s.regs.read 0#5) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound main_Add3_lowered
    (main_Add3_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 2#5) (s.regs.read 30#5))
    hw hc hrun
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, regOf, hpc])
  refine ⟨s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) hq (by braid_at)

/-- **`main.MaxU64` on the machine.** A running machine whose program holds the words of
`main.MaxU64`, with its code loaded and its program counter at the entry, runs to the address in
the link register with the larger of `x0` and `x1`, as unsigned numbers, in `x0`. -/
theorem main_MaxU64_correct (prog : Arm64.Program) (s : Arm64.State)
    (hw : prog.hasWords 0x84510#64 main_MaxU64_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x84510#64) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = umax (s.regs.read 0#5) (s.regs.read 1#5) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound main_MaxU64_lowered
    (main_MaxU64_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5) s.pstate.n
      s.pstate.z s.pstate.c s.pstate.v) hw hc hrun
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
      Flags.v, hpc])
  refine ⟨s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) (v := umax _ _) hq (by braid_at)

/-- **`main.SumSlice` on the machine.** A running machine whose program holds the words of
`main.SumSlice`, with its code loaded and its program counter at the entry, with the words
`xs` in memory where `x0` points and their number in `x1`, and with an aligned stack pointer
and a word of memory above it, apart from the slice, where Go's calling convention has the
function save its argument, runs to the address in the link register with the sum of `xs` in
`x0`. -/
theorem main_SumSlice_correct (prog : Arm64.Program) (s : Arm64.State) (xs : List Word)
    (old : Word) (hw : prog.hasWords 0x84530#64 main_SumSlice_words)
    (hc : prog.CodeLoaded s.mem) (hrun : s.status = .Running) (hpc : s.pc = 0x84530#64)
    (hsp : s.sp &&& 15#64 = 0#64) (hl : xs.length < 2 ^ 61)
    (hn : s.regs.read 1#5 = BitVec.ofNat 64 xs.length)
    (hmem : ∀ (i : Nat) (hi : i < xs.length),
      HasBytes s (s.regs.read 0#5 + BitVec.ofNat 64 (8 * i)) 8 xs[i])
    (hslot : HasBytes s (s.sp + 8#64) 8 old)
    (hd : Apart (s.sp + 8#64) 8 (s.regs.read 0#5) (8 * xs.length)) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = wsum xs 0#64 := by
  obtain ⟨hd1, hd2⟩ := hd
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat main_SumSlice_lowered
    (main_SumSlice_spec (s.regs.read 0#5) (s.regs.read 2#5) (s.regs.read 3#5)
      (s.regs.read 4#5) s.sp old (s.regs.read 30#5) xs s.pstate.n s.pstate.z s.pstate.c
      s.pstate.v hsp hl) hw hc hrun
    (flat := [.pc 0x84530#64, .reg x0 (s.regs.read 0#5), .reg x1 (BitVec.ofNat 64 xs.length),
      .reg x2 (s.regs.read 2#5), .reg x3 (s.regs.read 3#5), .reg x4 (s.regs.read 4#5),
      .reg sp s.sp, .mem (s.sp + 8#64) 8 old true] ++ wordsAtoms (s.regs.read 0#5) xs ++
      [.reg lr (s.regs.read 30#5), .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z,
        .flag Flags.c s.pstate.c, .flag Flags.v s.pstate.v])
    (by rw [wordsAt_eq_interp]
        exact Atoms.interp_flatten [.pc 0x84530#64, .reg x0 (s.regs.read 0#5),
          .reg x1 (BitVec.ofNat 64 xs.length), .reg x2 (s.regs.read 2#5),
          .reg x3 (s.regs.read 3#5), .reg x4 (s.regs.read 4#5), .reg sp s.sp,
          .mem (s.sp + 8#64) 8 old true] _ _)
    (Atoms.forall_flat (by simp [Atom.IsPointsTo]) wordsAtoms_isPointsTo)
    (Atoms.pairwise_flat (by braid_disj) (wordsAtoms_pairwise (by omega))
      (by braid_disj_array
          exact disj_mem_wordsAtoms (fun x hx hx' => by bv_omega) (by omega)))
    (Atoms.forall_flat
      (by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, sat_mem_hasBytes, regOf, Flags.n,
        Flags.z, Flags.c, Flags.v, hpc, hn, hslot])
      (wordsAtoms_sat fun i hi => sat_mem_hasBytes.2 (hmem i hi)))
  refine ⟨s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) (v := wsum _ _) hq (by braid_at)

end Examples.GoBasic.Arm
