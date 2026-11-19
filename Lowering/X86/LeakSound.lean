/-
  Lowering.X86.LeakSound

  The x86-64 lowering preserves traces: the labels the block of an instruction emits are the
  labels of the instruction (`Lowering.X86.Leak`), whatever values its `havoc`s take, so
  every labelled run of the lowered code is a run of the machine with the same trace.

  The model's runs are sets of outcomes, and so are the runs with a trace (`RunL`): the
  theorem carries `Braid.EventuallyL` to `RunL` as `lowerProgram_sound` carries
  `Braid.Eventually` to the model's `Eventually`. A block and its instruction take the same
  number of steps, one, so the traces are equal and not only equal up to stuttering.

  ## Main results

  * `leak_lower`: the labels of a lowered instruction are those of the instruction
  * `lowerProgram_soundL`: every labelled run, `EventuallyL` to `RunL`
  * `RunL.mono`, `RunL.eventually`: a weaker postcondition; runs with a trace are runs
-/

module

public import Lowering.X86.LeakAvx

public section

namespace Lowering.X86

open Braid (Word Block State Trace wpOps Term)

section
variable [Labels] {p : Std.Rco Int64}

/-- **The labels of a lowered instruction are those of the instruction.** If the block of
the instruction `i` runs without fault from a state related to the machine's, the labels it
emits, whatever values its `havoc`s take, are the labels of `i`. -/
theorem leak_lower {s : MachineData} {σ : State} {Q : State → Prop} {i : Instr}
    (h : RelD s σ) (hw : (lower p i).wp σ Q) (hv : Nat → Word) :
    leak p s i = some ((lower p i).leak σ hv) := by
  cases i with
  | regular asz w op =>
    cases asz
    case W64 =>
      simp only [lower] at hw ⊢
      cases hl : lowerOp p op with
      | none => simp [hl, Block.wp, wpOps, Term.wp] at hw
      | some r =>
        obtain ⟨ops, t⟩ := r
        exact leakOp_lower op hv h hl
    all_goals simp [lower, Block.wp, wpOps, Term.wp] at hw
  | avx asz w op =>
    cases asz
    case W64 =>
      simp only [lower] at hw ⊢
      cases hl : lowerAvx p op with
      | none => simp [hl, Block.wp, wpOps, Term.wp] at hw
      | some ops => exact leakAvx_lower op _ hv h hl
    all_goals simp [lower, Block.wp, wpOps, Term.wp] at hw

/-- The labels of the block of the directives at an address are those of what the model runs
there. -/
theorem lowerDirs_leak {s : MachineData} {σ : State} {Q : State → Prop} {pc : Int64}
    {ds : List (Kraken.Sized Directive)} {b : Block} (h : RelD s σ)
    (hb : lowerDirs pc ds = some b) (hw : b.wp σ Q) (hv : Nat → Word) :
    leakDirs s pc ds = some (b.leak σ hv) := by
  induction ds with
  | nil => simp [lowerDirs] at hb
  | cons d ds ih =>
    obtain ⟨dir, sz⟩ := d
    cases dir with
    | instr i =>
      cases ds with
      | nil =>
        simp only [lowerDirs, Option.some.injEq] at hb
        subst hb
        exact leak_lower h hw hv
      | cons d' ds' => simp [lowerDirs] at hb
    | label l =>
      cases sz with
      | zero =>
        simp only [lowerDirs] at hb
        exact ih hb
      | succ n => simp [lowerDirs] at hb
    | byteArray _ => simp [lowerDirs] at hb
    | word _ _ => simp [lowerDirs] at hb

end

/-! ## Programs -/

/-- **The x86-64 lowering preserves traces.** If every labelled run of the lowered code of
an executable from `σ`, after the trace `t`, reaches `Q`, then every run of the executable
in the model, from a state related to `σ` and after `t`, reaches a state related to one of
which `Q` holds with the trace of the run. -/
theorem lowerProgram_soundL [Layout] {e : Executable} {m : MachineState} {σ : State}
    {Q : State → Trace → Prop} {t : Trace} (h : Rel m σ)
    (hw : Braid.EventuallyL (lowerProgram e) Q σ t) :
    RunL e (fun m' t' => ∃ σ', Rel m' σ' ∧ Q σ' t') m t := by
  induction hw generalizing m with
  | done σ t hq => exact .done _ _ ⟨σ, h, hq⟩
  | step σ t R hs _ ih =>
    obtain ⟨b, hb, hwp⟩ := hs
    have hpc : Int64.ofBitVec σ.pc = m.pc := by rw [h.pc]; rfl
    simp only [lowerProgram, hpc] at hb
    have hwp' := Block.wp_of_wpL hwp
    have hleak := fun hv =>
      @lowerDirs_leak (Executable.labels e) m.data σ _ m.pc _ b h.data hb hwp' hv
    refine .step m t (b.leak σ fun _ => 0#64)
      (fun m' => ∃ σ', Rel m' σ' ∧ R σ' (t ++ b.leak σ fun _ => 0#64)) (hleak _) ?_
      fun m' ⟨σ', h', hr⟩ => ih σ' _ hr h'
    refine @lowerDirs_sound (Executable.labels e) m.data σ _ m.pc _ b h.data hb
      (Block.wp_mono hwp' ?_)
    rintro σ' ⟨hv, hr⟩
    rw [← Option.some.inj ((hleak hv).symm.trans (hleak _))]
    exact hr

/-- A run with a trace reaches any postcondition its own implies. -/
theorem RunL.mono [Layout] {e : Executable} {post post' : MachineState → Trace → Prop}
    {m : MachineState} {t : Trace} (h : RunL e post m t)
    (hp : ∀ m t, post m t → post' m t) : RunL e post' m t := by
  induction h with
  | done m t hq => exact .done m t (hp m t hq)
  | step m t ls mid hl hs _ ih => exact .step m t ls mid hl hs ih

/-- Runs with a trace are runs of the model. -/
theorem RunL.eventually [Layout] {e : Executable} {post : MachineState → Trace → Prop}
    {m : MachineState} {t : Trace} (h : RunL e post m t) :
    Eventually (step1 e) (fun m' => ∃ t', post m' t') m := by
  induction h with
  | done m t hq => exact .done m ⟨t, hq⟩
  | step m t ls mid _ hs _ ih => exact .step m mid hs ih

end Lowering.X86
