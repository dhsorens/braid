/-
  Examples.Memory.RiscV.Proofs

  `memory.c` on RISC-V: loads and stores, a call with a stack frame, and a tail call.
-/

module

public import Examples.Memory.RiscV.Image
public import Lowering.RiscV.Logic
public import Examples.Spec

public section

/-! ## Reading memory out of a postcondition

These belong in `Lowering.RiscV.Logic`, beside `sat_mem_abs`; the other examples import them
from here. -/

namespace Lowering.RiscV

open Braid RiscvZkvm.Rv64

/-- An atom that is a member of a list is at a place in it. -/
theorem at_of_mem {as : Atoms} {a : Atom} (h : a ∈ as) : as.At a := by
  induction as with
  | nil => cases h
  | cons b as ih =>
    rcases List.mem_cons.1 h with rfl | h
    · exact .here
    · exact .there (ih h)

/-- **Out of the logic, for memory.** A machine related to a state of which a writable memory
atom holds has the bytes of that atom. -/
theorem hasBytes_of_holds {as : Atoms} {R : SProp} {s : MachineState} {σ : State}
    {a v : Word} {n : Nat} (hr : Rel s σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.mem a n v true)) : HasBytes s a n v := by
  intro x hx
  obtain ⟨hv, hc⟩ := hr.cell (Atoms.mem_of_holds h hat hx)
  exact ⟨hv, (congrArg Cell.val hc).symm⟩

/-- A machine related to a state of which an array of words holds has each of the words. -/
theorem hasBytes_of_holds_words {l₁ l₂ : Atoms} {R : SProp} {s : MachineState} {σ : State}
    {p : Word} {xs : List Word} (hr : Rel s σ)
    (h : (Atoms.interp (l₁ ++ .prop (wordsAt p xs) :: l₂)).holds R σ) (i : Nat)
    (hi : i < xs.length) : HasBytes s (p + BitVec.ofNat 64 (8 * i)) 8 xs[i] := by
  rw [wordsAt_eq_interp, Atoms.interp_flatten] at h
  exact hasBytes_of_holds hr h (at_of_mem (List.mem_append_left _
    (List.mem_append_right _ (mem_wordsAtoms.2 ⟨i, hi, rfl⟩))))

/-- A machine related to a state of which an array of bytes holds has each of the bytes. -/
theorem hasBytes_of_holds_bytes {l₁ l₂ : Atoms} {R : SProp} {s : MachineState} {σ : State}
    {p : Word} {bs : List (BitVec 8)} (hr : Rel s σ)
    (h : (Atoms.interp (l₁ ++ .prop (bytesAt p bs) :: l₂)).holds R σ) (i : Nat)
    (hi : i < bs.length) : HasBytes s (p + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64) := by
  rw [bytesAt_eq_interp, Atoms.interp_flatten] at h
  exact hasBytes_of_holds hr h (at_of_mem (List.mem_append_left _
    (List.mem_append_right _ (mem_bytesAtoms.2 ⟨i, hi, rfl⟩))))

end Lowering.RiscV

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

/-- **`swap` on the machine.** A machine that holds the code of `swap`, is at its entry, and
has the word `x` in memory where `a0` points and the word `y` where `a1` points, the two
pointers aligned and different, runs to the return address with `y` where `a0` points and `x`
where `a1` points. -/
theorem swap_correct (s : MachineState) (x y : Word)
    (hcode : ∀ p ∈ swap_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hp : s.getReg .x10 &&& 7#64 = 0#64) (hq : s.getReg .x11 &&& 7#64 = 0#64)
    (hne : s.getReg .x10 ≠ s.getReg .x11)
    (hx : HasBytes s (s.getReg .x10) 8 x) (hy : HasBytes s (s.getReg .x11) 8 y) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      HasBytes s' (s.getReg .x10) 8 y ∧ HasBytes s' (s.getReg .x11) 8 x := by
  have hd : Atom.Disj (.mem (s.getReg .x10) 8 x true) (.mem (s.getReg .x11) 8 y true) := by
    refine Atom.disj_mem_mem fun a ⟨h1, h2⟩ => ?_
    have h1' : a - s.getReg .x10 < 8#64 := by simpa [BitVec.lt_def] using h1
    have h2' : a - s.getReg .x11 < 8#64 := by simpa [BitVec.lt_def] using h2
    bv_decide
  obtain ⟨n, s', σ', hn, hr, hpost⟩ := machine_sound swap_lowered
    (swap_spec (s.getReg .x10) (s.getReg .x11) x y (s.getReg .x12) (s.getReg .x13)
      (s.getReg .x1) hp hq) hcode
    (by simp [Atom.IsPointsTo]) (by braid_disj; simp only [hd, and_true]; decide)
    (by simp only [List.forall_mem_cons, sat_mem_abs]
        simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, hx, hy])
  refine ⟨n, s', hn, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hpost (by braid_at)
  · exact hasBytes_of_holds hr hpost (by braid_at)
  · exact hasBytes_of_holds hr hpost (by braid_at)

/-- **`max2` on the machine.** A machine that holds the code of `max2` and is at its entry
runs to the return address with the larger of `a0` and `a1`, as unsigned numbers, in `a0`. -/
theorem max2_correct (s : MachineState) (hcode : ∀ p ∈ max2_code, s.code p.1 = some p.2)
    (hpc : s.pc = 0x10044#64) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 =
        if (s.getReg .x11).ult (s.getReg .x10) then s.getReg .x10 else s.getReg .x11 := by
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound max2_lowered
    (max2_spec (s.getReg .x10) (s.getReg .x11) (s.getReg .x1)) hcode
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc])
  refine ⟨n, s', hn, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]
    exact Atoms.reg_of_holds (r := 10) (v := umax _ _) hq (by braid_at)

/-- **`max3` on the machine.** A machine that holds the code of `max2` and of `max3`, is at
the entry of `max3`, and has an aligned stack pointer with two words of valid memory below
it, runs to the return address with the largest of `a0`, `a1` and `a2`, as unsigned numbers,
in `a0`. The stack pointer and `s0` are as they were. -/
theorem max3_correct (s : MachineState) (m0 m1 : Word)
    (hcode2 : ∀ p ∈ max2_code, s.code p.1 = some p.2)
    (hcode3 : ∀ p ∈ max3_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10050#64)
    (hsp : s.getReg .x2 &&& 7#64 = 0#64)
    (h0 : HasBytes s (s.getReg .x2 - 16#64) 8 m0) (h1 : HasBytes s (s.getReg .x2 - 8#64) 8 m1) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 = umax (umax (s.getReg .x10) (s.getReg .x11)) (s.getReg .x12) ∧
      s'.getReg .x2 = s.getReg .x2 ∧ s'.getReg .x8 = s.getReg .x8 := by
  have hd : Atom.Disj (.mem (s.getReg .x2 - 16#64) 8 m0 true)
      (.mem (s.getReg .x2 - 8#64) 8 m1 true) :=
    Atom.disj_mem_mem fun a ⟨h1, h2⟩ => by bv_omega
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound (code := max2_code ++ max3_code)
    (by rw [List.map_append, ← max2_lowered, ← max3_lowered])
    (max3_spec (s.getReg .x10) (s.getReg .x11) (s.getReg .x12) (s.getReg .x2) (s.getReg .x1)
      (s.getReg .x8) (s.getReg .x6) m0 m1 hsp)
    (fun p hp => (List.mem_append.1 hp).elim (hcode2 p) (hcode3 p))
    (by simp [Atom.IsPointsTo]) (by braid_disj; simp only [hd, and_true]; decide)
    (by simp only [List.forall_mem_cons, sat_mem_abs]
        simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, h0, h1])
  refine ⟨n, s', hn, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]
    exact Atoms.reg_of_holds (r := 10) (v := umax _ _) hq (by braid_at)
  · rw [← hr.getReg (r := .x2) (by decide)]; exact Atoms.reg_of_holds (r := 2) hq (by braid_at)
  · rw [← hr.getReg (r := .x8) (by decide)]; exact Atoms.reg_of_holds (r := 8) hq (by braid_at)

end Examples.Memory.RiscV
