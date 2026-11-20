/-
  Lowering.X86.LeakAvx

  The labels of a lowered vector instruction of x86-64 are the labels of the instruction
  (`Lowering.X86.Leak`). A vector in memory is loaded and stored a word at a time, and the
  labels are one for each word, lowest first. A vector register is words of `braid` state
  that are not general registers, so writing one leaves every address as it was. The
  operations between the read and the write of a rotation, a shift, a bitwise function, a
  shuffle or a blend are constants and operations on words, which emit nothing.

  ## Main definitions

  * `AvxLeak`: the labels of a lowered vector instruction are those of the instruction

  ## Main results

  * `loadWords_run`, `storeWords_run`: the labels of a vector loaded or stored by words
  * `readVec_emits`, `writeVec_emits`: the labels of a vector operand
  * `leakAvx_lower`: every vector instruction
-/

module

public import Lowering.X86.LeakOps

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env State Trace Label runOps runOps_cons
  runOps_append runOps_nil)

/-! ## Words of a vector -/

theorem vecReg_ge (k : RegMm) (j : Nat) : 16 ≤ vecReg k j := by
  unfold vecReg
  omega

theorem vecWords_eq (w : AvxWidth) : w.bytes / 8 = vecWords w := by cases w <;> rfl

theorem vecWords_le (w : AvxWidth) : vecWords w ≤ 8 := by cases w <;> decide

theorem getRegs_quiet (n : Nat) (r : Braid.Reg) (k : Nat) :
    (getRegs n r k).all isQuiet = true := by
  simp [getRegs, isQuiet]

theorem setRegs_quiet {r : Nat} (hr : 16 ≤ r) (g : Nat → Var) (k : Nat) :
    (setRegs r g k).all isQuiet = true := by
  simp only [setRegs, List.all_map, List.all_eq_true, Function.comp_apply, isQuiet,
    decide_eq_true_eq]
  intro j _
  exact Nat.le_add_right_of_le hr

theorem binWords_quiet (d a b : Var) (k : Nat) :
    (binWords d (.lanes 32 .add) a b k).all isQuiet = true := by
  simp [binWords, isQuiet, BinOp.leaks]

theorem rorWords_quiet (c : BitVec 8) (k : Nat) : (rorWords c k).all isQuiet = true := by
  simp [rorWords, zipWords, isQuiet, BinOp.leaks]

theorem shrWords_quiet (c : BitVec 8) (k : Nat) : (shrWords c k).all isQuiet = true := by
  simp [shrWords, zipWords, isQuiet, BinOp.leaks]

theorem ternWords_quiet (t : BitVec 8) (k : Nat) : (ternWords t k).all isQuiet = true := by
  unfold ternWords
  repeat' split
  all_goals simp [zipWords, isQuiet, BinOp.leaks]

theorem shufWords_quiet (imm : BitVec 8) (k : Nat) :
    (shufWords imm k).all isQuiet = true := by
  simp [shufWords, zipWords, constWords, isQuiet, BinOp.leaks]

theorem blendWords_quiet (imm : BitVec 8) (k : Nat) :
    (blendWords imm k).all isQuiet = true := by
  simp [blendWords, zipWords, constWords, isQuiet, BinOp.leaks]

theorem alignWords_quiet (n k : Nat) : (alignWords n k).all isQuiet = true := by
  simp [alignWords, zipWords, constWords, isQuiet, BinOp.leaks]

theorem bshufWords_quiet (k : Nat) : (bshufWords k).all isQuiet = true := by
  simp [bshufWords, bshufByte, zipWords, constWords, isQuiet, BinOp.leaks]

theorem alignOps_quiet (n a : Var) (bytes : Nat) (al : Bool) :
    (alignOps n a bytes al).all isQuiet = true := by
  cases al <;> rfl

/-- The operations of an alignment check leave the address they check where it was. -/
theorem alignOps_env {n a : Nat} (h : a < n) (bytes : Nat) (al : Bool) (ρ : Env) (σ : State)
    (hv : Nat → Word) : (runOps (alignOps n a bytes al) ρ σ hv).1 a = ρ a := by
  have h0 : a ≠ n := by omega
  have h1 : a ≠ n + 1 := by omega
  have h2 : a ≠ n + 2 := by omega
  have h3 : a ≠ n + 3 := by omega
  cases al <;> simp [alignOps, runOps_cons, h0, h1, h2, h3]

/-- Loading `k` words from the address in `a` emits a read of each, lowest first, and leaves
the state and the address as they were. -/
theorem loadWords_run (n a t : Nat) (k : Nat) (ρ : Env) (σ : State) (hv : Nat → Word)
    (ha : ∀ j, j < k → n + j ≠ a ∧ t + 2 * j ≠ a ∧ t + 2 * j + 1 ≠ a) :
    (runOps (loadWords n a t k) ρ σ hv).2.2 =
        (List.range k).map (fun j => Label.read (ρ a + BitVec.ofNat 64 (8 * j)) 8) ∧
      (runOps (loadWords n a t k) ρ σ hv).2.1 = σ ∧
      (runOps (loadWords n a t k) ρ σ hv).1 a = ρ a := by
  induction k with
  | zero => exact ⟨rfl, rfl, rfl⟩
  | succ k ih =>
    obtain ⟨e1, e2, e3⟩ := ih fun j hj => ha j (by omega)
    obtain ⟨h1, h2, h3⟩ := ha k (by omega)
    have hl : loadWords n a t (k + 1) = loadWords n a t k ++
        [.const (t + 2 * k) (BitVec.ofNat 64 (8 * k)), .bin (t + 2 * k + 1) .add a (t + 2 * k),
          .load (n + k) .w64 (t + 2 * k + 1)] := by
      simp [loadWords, List.range_succ, List.flatMap_append]
    rw [hl, runOps_append]
    simp [runOps_cons, e1, e2, e3, List.range_succ, h1.symm, h2.symm, h3.symm,
      BinOp.leaks, Braid.Width.bytes]

/-- Storing `k` words at the address in `a` emits a write of each, lowest first, and leaves
the registers and the address as they were. -/
theorem storeWords_run (a t v : Nat) (k : Nat) (ρ : Env) (σ : State) (hv : Nat → Word)
    (ha : ∀ j, j < k → t + 2 * j ≠ a ∧ t + 2 * j + 1 ≠ a) :
    (runOps (storeWords a t v k) ρ σ hv).2.2 =
        (List.range k).map (fun j => Label.write (ρ a + BitVec.ofNat 64 (8 * j)) 8) ∧
      (runOps (storeWords a t v k) ρ σ hv).2.1.regs = σ.regs ∧
      (runOps (storeWords a t v k) ρ σ hv).1 a = ρ a := by
  induction k with
  | zero => exact ⟨rfl, rfl, rfl⟩
  | succ k ih =>
    obtain ⟨e1, e2, e3⟩ := ih fun j hj => ha j (by omega)
    obtain ⟨h2, h3⟩ := ha k (by omega)
    have hl : storeWords a t v (k + 1) = storeWords a t v k ++
        [.const (t + 2 * k) (BitVec.ofNat 64 (8 * k)), .bin (t + 2 * k + 1) .add a (t + 2 * k),
          .store .w64 (t + 2 * k + 1) (v + k)] := by
      simp [storeWords, List.range_succ, List.flatMap_append]
    rw [hl, runOps_append]
    simp [runOps_cons, e1, e2, e3, List.range_succ, h2.symm, h3.symm,
      BinOp.leaks, Braid.Width.bytes]

/-! ## Vector operands -/

section
variable [Labels] {p : Std.Rco Int64} {regs : Reg64s}

theorem readVec_emits (n : Nat) {w : AvxWidth} (al : Bool) (o : AvxRegOrMem w) :
    Emits (readVec p n al o) regs (vecRead p regs o) := by
  cases o with
  | avx r => exact Emits.quiet (getRegs_quiet _ _ _)
  | mem a =>
    refine ⟨fun ρ σ hv hr => ?_⟩
    have hq := addrOps_quiet (p := p) (n + 8) a
    have hqa := alignOps_quiet (n + 16) (n + 8) w.bytes al
    simp only [readVec, vecRead, runOps_append]
    obtain ⟨e1, e2, _⟩ := loadWords_run n (n + 8) (n + 24) (vecWords w)
      (runOps (alignOps (n + 16) (n + 8) w.bytes al)
        (runOps (addrOps p (n + 8) a) ρ σ hv).1 (runOps (addrOps p (n + 8) a) ρ σ hv).2.1
        fun i => hv (i + (addrOps p (n + 8) a).length)).1
      (runOps (alignOps (n + 16) (n + 8) w.bytes al)
        (runOps (addrOps p (n + 8) a) ρ σ hv).1 (runOps (addrOps p (n + 8) a) ρ σ hv).2.1
        fun i => hv (i + (addrOps p (n + 8) a).length)).2.1
      (fun i => hv (i + (addrOps p (n + 8) a ++ alignOps (n + 16) (n + 8) w.bytes al).length))
      (fun j hj => by have := vecWords_le w; omega)
    rw [e1, e2, runOps_silent (all_silent_of_quiet hq), runOps_silent (all_silent_of_quiet hqa),
      alignOps_env (by omega), addrOps_env hr, vecWords_eq]
    exact ⟨rfl, (runOps_quiet hqa _ _ _).2 regs ((runOps_quiet hq ρ σ hv).2 regs hr)⟩

theorem writeVec_emits (n : Nat) {w : AvxWidth} (legacy al : Bool) (d : AvxRegOrMem w)
    (v : Var) : Emits (writeVec p n legacy al d v) regs (vecWrite p regs d) := by
  cases d with
  | avx r =>
    refine Emits.quiet ?_
    simp only [writeVec, List.all_append, Bool.and_eq_true]
    refine ⟨setRegs_quiet (vecReg_ge _ _) _ _, ?_⟩
    cases legacy
    · simpa [isQuiet] using setRegs_quiet (vecReg_ge _ _) _ _
    · rfl
  | mem a =>
    refine ⟨fun ρ σ hv hr => ?_⟩
    have hq := addrOps_quiet (p := p) n a
    have hqa := alignOps_quiet (n + 8) n w.bytes al
    simp only [writeVec, vecWrite, runOps_append]
    obtain ⟨e1, e2, _⟩ := storeWords_run n (n + 16) v (vecWords w)
      (runOps (alignOps (n + 8) n w.bytes al)
        (runOps (addrOps p n a) ρ σ hv).1 (runOps (addrOps p n a) ρ σ hv).2.1
        fun i => hv (i + (addrOps p n a).length)).1
      (runOps (alignOps (n + 8) n w.bytes al)
        (runOps (addrOps p n a) ρ σ hv).1 (runOps (addrOps p n a) ρ σ hv).2.1
        fun i => hv (i + (addrOps p n a).length)).2.1
      (fun i => hv (i + (addrOps p n a ++ alignOps (n + 8) n w.bytes al).length))
      (fun j hj => by have := vecWords_le w; omega)
    rw [e1, runOps_silent (all_silent_of_quiet hq), runOps_silent (all_silent_of_quiet hqa),
      alignOps_env (by omega), addrOps_env hr, vecWords_eq]
    refine ⟨rfl, fun r => ?_⟩
    rw [e2]
    exact (runOps_quiet hqa _ _ _).2 regs ((runOps_quiet hq ρ σ hv).2 regs hr) r

/-- Find the labels of a list of operations that is the pieces of a lowered vector
instruction. -/
macro "x86_emits_vec" : tactic => `(tactic|
  repeat' first
    | with_reducible exact Emits.quiet (rorWords_quiet _ _)
    | with_reducible exact Emits.quiet (shrWords_quiet _ _)
    | with_reducible exact Emits.quiet (ternWords_quiet _ _)
    | with_reducible exact Emits.quiet (shufWords_quiet _ _)
    | with_reducible exact Emits.quiet (blendWords_quiet _ _)
    | with_reducible exact Emits.quiet (alignWords_quiet _ _)
    | with_reducible exact Emits.quiet (bshufWords_quiet _)
    | apply Emits.append
    | apply Emits.appendT
    | exact Emits.quiet (by rfl)
    | exact readVec_emits _ _ _
    | exact writeVec_emits _ _ _ _ _
    | exact readRM_emits _ _
    | exact Emits.quiet (binWords_quiet _ _ _ _)
    | exact Emits.quiet (setRegs_quiet (vecReg_ge _ _) _ _)
    | exact writeRM_emits _ _ _
    | apply Emits.toT)

/-! ## Instructions -/

/-- The labels of the lowered vector instruction `i` are those of `i`. -/
def AvxLeak (p : Std.Rco Int64) {w : AvxWidth} (i : AvxOperation w) : Prop :=
  ∀ {s : MachineData} {σ : State} {ops : List Op} (a : Word) (hv : Nat → Word),
    RelD s σ → lowerAvx p i = some ops → leakAvx p s i = some (Block.leak ⟨ops, .jump a⟩ σ hv)

/-- **The labels of a lowered vector instruction are those of the instruction.** -/
theorem leakAvx_lower {w : AvxWidth} (i : AvxOperation w) : AvxLeak p i := by
  intro s σ ops a hv h hl
  cases i <;> simp only [lowerAvx, moveVec] at hl <;> cases hl
  all_goals
    simp only [leakAvx]
    apply leak_jump (RelD.regsRel h)
    case he => x86_emits_vec
    case e => first | rfl | simp only [List.append_nil, List.append_assoc]

end

end Lowering.X86
