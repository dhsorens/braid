/-
  Examples.Memory.RiscV.Proofs

  `memory.c` on RISC-V: loads and stores, a call with a stack frame, and a tail call.
-/

module

public import Examples.Memory.RiscV.Image
public import Lowering.RiscV.Logic
public import Examples.Spec

public section

namespace Examples.Memory.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- `swap` exchanges the two words its arguments point to. -/
theorem swap_spec (p q x y t2 t3 r : Word) (hp : p &&& 7#64 = 0#64) (hq : q &&& 7#64 = 0#64) :
    Triple swap.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 p, .reg a1 q, .reg a2 t2, .reg a3 t3,
        .mem p 8 x true, .mem q 8 y true, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 p, .reg a1 q, .reg a2 y, .reg a3 x,
        .mem p 8 y true, .mem q 8 x true, .reg ra r]) := by
  braid_run
  braid_done

/-- `max2` returns the larger of its arguments. -/
theorem max2_spec (a b r : Word) :
    Triple max2.program
      (Atoms.interp [.pc 0x10044#64, .reg a0 a, .reg a1 b, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (umax a b), .reg a1 b, .reg ra r]) := by
  braid_step
  · braid_run
    exact Triple.done_eq (by simp [umax, hbr])
  · braid_run
    exact Triple.done_eq (by simp [umax, hbr])

/-- `max2` and `max3` together. -/
def prog : Program := Program.ofList (max2.blocks ++ max3.blocks)

theorem max2_spec' (a b r : Word) :
    Triple prog
      (Atoms.interp [.pc 0x10044#64, .reg a0 a, .reg a1 b, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (umax a b), .reg a1 b, .reg ra r]) :=
  (max2_spec a b r).mono (Program.ofList_mono (fun _ h => List.mem_append_left _ h) (by decide))

/-- `max3` returns the largest of its arguments. It calls `max2`, keeping its third argument
in a callee-saved register across the call, and returns through a tail call. -/
theorem max3_spec (a b c s r v0 vt m0 m1 : Word) (hs : s &&& 7#64 = 0#64) :
    Triple prog
      (Atoms.interp [.pc 0x10050#64, .reg a0 a, .reg a1 b, .reg a2 c, .reg sp s, .reg ra r,
        .reg s0 v0, .reg t1 vt, .mem (s - 16#64) 8 m0 true, .mem (s - 8#64) 8 m1 true])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (umax (umax a b) c), .reg a1 c, .reg a2 c,
        .reg sp s, .reg ra r, .reg s0 v0, .reg t1 0x10078#64, .mem (s - 16#64) 8 v0 true,
        .mem (s - 8#64) 8 r true]) := by
  iterate 6 braid_step
  braid_call max2_spec' _ _ _
  iterate 6 braid_step
  braid_call max2_spec' _ _ _
  braid_done

/-- The loop of `sum_array`, entered with at least one word left. -/
theorem sum_array_loop (r e : Word) : ∀ (xs : List Word) (x q acc t3 : Word),
    q &&& 7#64 = 0#64 → q + BitVec.ofNat 64 (8 * (xs.length + 1)) = e →
    xs.length + 1 < 2 ^ 61 →
    Triple sum_array.program
      (Atoms.interp [.pc 0x10028#64, .reg a0 acc, .reg a1 e, .reg a2 q, .reg a3 t3,
        .prop (wordsAt q (x :: xs)), .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (wsum (x :: xs) acc), .reg a1 e, .reg a2 e,
        .prop (regAny a3), .prop (wordsAt q (x :: xs)), .reg ra r]) := by
  intro xs
  induction xs with
  | nil =>
    intro x q acc t3 hq he hl
    braid_unfold wordsAt_cons q x []
    iterate 3 braid_step
    braid_step
    · exact absurd (by simpa using he) hbr
    · subst hbr
      braid_run
      braid_fold wordsAt_cons q x []
      braid_forget 13
      simp only [wsum, List.foldl_cons, List.foldl_nil]
      braid_done
  | cons y ys ih =>
    intro x q acc t3 hq he hl
    braid_unfold wordsAt_cons q x (y :: ys)
    iterate 3 braid_step
    braid_step
    · braid_call ih y (q + 8#64) (x + acc) x (by bv_decide)
        (by simp only [List.length_cons] at he ⊢; bv_omega)
        (by simp only [List.length_cons] at hl ⊢; omega)
      braid_fold wordsAt_cons q x (y :: ys)
      simp only [wsum, List.foldl_cons]
      braid_done
    · exfalso
      simp only [List.length_cons] at he hl
      bv_omega

/-- `sum_array` returns the sum of the `n` words its first argument points to. -/
theorem sum_array_spec (p r t2 t3 : Word) (xs : List Word) (hp : p &&& 7#64 = 0#64)
    (hl : xs.length < 2 ^ 61) :
    Triple sum_array.program
      (Atoms.interp [.pc 0x10014#64, .reg a0 p, .reg a1 (BitVec.ofNat 64 xs.length), .reg a2 t2,
        .reg a3 t3, .prop (wordsAt p xs), .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (wsum xs 0#64), .prop (regAny a1),
        .prop (regAny a2), .prop (regAny a3), .prop (wordsAt p xs), .reg ra r]) := by
  cases xs with
  | nil =>
    braid_step
    · braid_run
      braid_forget 11
      braid_forget 12
      braid_forget 13
      simp only [wsum, List.foldl_nil]
      braid_done
    · exact absurd rfl hbr
  | cons x xs =>
    braid_step
    · exfalso
      simp only [List.length_cons] at hbr hl
      bv_omega
    · iterate 4 braid_step
      have he : p + BitVec.ofNat 64 (8 * (xs.length + 1)) =
          p + BitVec.ofNat 64 (x :: xs).length <<< 3#64 := by
        congr 1
        apply BitVec.eq_of_toNat_eq
        simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
        omega
      braid_call sum_array_loop r _ xs x p 0#64 t3 hp he hl
      braid_forget 11
      braid_forget 12
      braid_done

/-- **`sum_array` on the machine.** A machine that holds the code of `sum_array`, is at its
entry, and has the words `xs` in memory where `a0` points, with their number in `a1`, runs to
the return address with their sum in `a0`. -/
theorem sum_array_correct (s : MachineState) (xs : List Word)
    (hcode : ∀ p ∈ sum_array_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10014#64)
    (hp : s.getReg .x10 &&& 7#64 = 0#64) (hl : xs.length < 2 ^ 61)
    (hn : s.getReg .x11 = BitVec.ofNat 64 xs.length)
    (hmem : ∀ (i : Nat) (hi : i < xs.length),
      HasBytes s (s.getReg .x10 + BitVec.ofNat 64 (8 * i)) 8 xs[i]) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 = wsum xs 0#64 := by
  obtain ⟨n, s', σ', hn', hr, hq⟩ := machine_sound_flat sum_array_lowered
    (sum_array_spec (s.getReg .x10) (s.getReg .x1) (s.getReg .x12) (s.getReg .x13) xs hp hl) hcode
    (flat := [.pc 0x10014#64, .reg a0 (s.getReg .x10), .reg a1 (BitVec.ofNat 64 xs.length),
      .reg a2 (s.getReg .x12), .reg a3 (s.getReg .x13)] ++ wordsAtoms (s.getReg .x10) xs ++
      [.reg ra (s.getReg .x1)])
    (by rw [wordsAt_eq_interp]
        exact Atoms.interp_flatten [.pc 0x10014#64, .reg a0 (s.getReg .x10),
          .reg a1 (BitVec.ofNat 64 xs.length), .reg a2 (s.getReg .x12), .reg a3 (s.getReg .x13)]
          [.reg ra (s.getReg .x1)] _)
    (Atoms.forall_flat (by simp [Atom.IsPointsTo]) wordsAtoms_isPointsTo)
    (Atoms.pairwise_flat (by braid_disj) (wordsAtoms_pairwise (by omega))
      (by braid_disj_array))
    (Atoms.forall_flat (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, hn])
      (wordsAtoms_sat fun i hi => sat_mem_abs.2 (hmem i hi)))
  refine ⟨n, s', hn', ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]
    exact Atoms.reg_of_holds (r := 10) (v := wsum _ _) hq (by braid_at)

end Examples.Memory.RiscV
