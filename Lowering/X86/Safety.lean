/-
  Lowering.X86.Safety

  Memory safety of whole runs on x86-64, of every state the machine can reach. The model
  gives a step a set of outcomes: `step1 e m mid` says that every outcome of the step from
  `m` satisfies `mid`. A state is a possible outcome when it satisfies every such `mid`
  (`Next`), and the reachable states are the closure of that (`Reachable`).

  The theorem is proved from the run of the lowered code and not instruction by instruction.
  A block of the dialect changes memory only where its `write` labels say
  (`Block.wpL_writes`), the lowering carries a block to a step of the machine
  (`lowerDirs_sound`), and `Rel` ties the machine's memory to the dialect's. So along a run
  that reaches a postcondition with a known trace, memory changes only at the stores of that
  trace. A program that ends in a jump to itself never leaves that state, so the states
  reachable after the run have the memory the run left.

  ## Main definitions

  * `Unchanged`: two memories agree at every byte that no `write` label of a trace covers
  * `Next`, `Reachable`: a possible outcome of a step, and the states a machine can reach

  ## Main results

  * `Block.wpL_writes`: a block changes memory only at the addresses of its `write` labels
  * `EventuallyL.exists`: a run that reaches a postcondition has an outcome that does
  * `Reachable.rel_of_loop`: a machine at a jump to itself stays in that state
  * `safe_of_eventuallyL`: no store outside `inside`, of every reachable state, from a run
    of the lowered code
  * `program_safeT`: the same from a traced triple about an image
-/

module

public import Lowering.X86.Program

public section

namespace Lowering.X86

open Braid hiding Image

/-! ## What a block of the dialect changes in memory -/

/-- The memory `m'` is `m` at every address that no `write` label of `ls` covers. -/
@[expose] def Unchanged (ls : Trace) (m m' : Braid.Mem) : Prop :=
  ∀ x : Word, (∀ b n, Label.write b n ∈ ls → ¬ (x - b).toNat < n) → m' x = m x

theorem Unchanged.refl (ls : Trace) (m : Braid.Mem) : Unchanged ls m m := fun _ _ => rfl

theorem Unchanged.append {ls ls' : Trace} {m m' m'' : Braid.Mem} (h : Unchanged ls m m')
    (h' : Unchanged ls' m' m'') : Unchanged (ls ++ ls') m m'' := fun x hx =>
  (h' x fun b n hm => hx b n (List.mem_append_right _ hm)).trans
    (h x fun b n hm => hx b n (List.mem_append_left _ hm))

/-- A store changes no byte outside the bytes it writes. -/
theorem storeN_unchanged {n : Nat} : ∀ {m m' : Braid.Mem} {a v : Word},
    m.storeN a v n = some m' → ∀ x : Word, ¬ (x - a).toNat < n → m' x = m x := by
  induction n with
  | zero =>
    intro m m' a v h x _
    cases h
    rfl
  | succ n ih =>
    intro m m' a v h x hx
    simp only [Mem.storeN] at h
    split at h
    · split at h
      · have hne : x ≠ a := by
          rintro rfl
          exact hx (by simp)
        rw [ih h x (by bv_omega)]
        simp [hne]
      · cases h
    · cases h

/-- **An operation changes memory only at the addresses of its `write` labels.** -/
theorem Op.wp_writes {op : Op} {ρ : Env} {σ : State} {Q : Env → State → Prop}
    (h : op.wp ρ σ Q) :
    op.wp ρ σ fun ρ' σ' => Q ρ' σ' ∧ Unchanged (op.leak ρ σ) σ.mem σ'.mem := by
  cases op <;> simp only [Op.wp] at h ⊢
  case load => obtain ⟨v, hv, hq⟩ := h; exact ⟨v, hv, hq, Unchanged.refl _ _⟩
  case store w a v =>
    obtain ⟨m, hm, hq⟩ := h
    refine ⟨m, hm, hq, fun x hx => ?_⟩
    exact storeN_unchanged hm x (hx _ _ (by simp [Op.leak]))
  case havoc => exact fun v => ⟨h v, Unchanged.refl _ _⟩
  case guard => exact ⟨h.1, h.2, Unchanged.refl _ _⟩
  case out => exact ⟨h.1, h.2, Unchanged.refl _ _⟩
  all_goals exact ⟨h, Unchanged.refl _ _⟩

theorem wpOpsL_writes {ops : List Op} {ρ : Env} {σ : State} {t : Trace}
    {Q : Env → State → Trace → Prop} (h : wpOpsL ops ρ σ t Q) :
    wpOpsL ops ρ σ t fun ρ' σ' t' =>
      Q ρ' σ' t' ∧ ∃ ls, t' = t ++ ls ∧ Unchanged ls σ.mem σ'.mem := by
  induction ops generalizing ρ σ t with
  | nil => exact ⟨h, [], (List.append_nil t).symm, Unchanged.refl _ _⟩
  | cons op ops ih =>
    simp only [wpOpsL, Op.wpL] at h ⊢
    refine Op.wp_mono (Op.wp_writes h) ?_
    rintro ρ₁ σ₁ ⟨h₁, hu⟩
    refine wpOpsL_mono (ih h₁) ?_
    rintro ρ' σ' t' ⟨hq, ls, rfl, hu'⟩
    exact ⟨hq, _, List.append_assoc .., hu.append hu'⟩

/-- **A block changes memory only at the addresses of its `write` labels.** If a block runs
after the trace `t` to `Q`, it runs to states and traces of which `Q` holds, where the trace
is `t` and then some labels `ls`, and memory is as it was at every address that no `write`
label of `ls` covers. -/
theorem Block.wpL_writes {b : Block} {σ : State} {t : Trace} {Q : State → Trace → Prop}
    (h : b.wpL σ t Q) :
    b.wpL σ t fun σ' t' => Q σ' t' ∧ ∃ ls, t' = t ++ ls ∧ Unchanged ls σ.mem σ'.mem := by
  refine wpOpsL_mono (wpOpsL_writes h) ?_
  rintro ρ σ₁ t₁ ⟨hq, ls, rfl, hu⟩
  simp only [Term.wpL] at hq ⊢
  have hm : ∀ a, (σ₁.setPc a).mem = σ₁.mem := fun _ => rfl
  have hu' : ∀ a, Unchanged (ls ++ b.term.leak ρ) σ.mem (σ₁.setPc a).mem := fun a =>
    hu.append (Unchanged.refl _ _)
  cases hb : b.term <;> rw [hb] at hq hu' <;> simp only [Term.wp] at hq ⊢
  all_goals exact ⟨hq, _, List.append_assoc .., hu' _⟩

/-! ## A run has an outcome -/

theorem Op.wp_exists {op : Op} {ρ : Env} {σ : State} {Q : Env → State → Prop}
    (h : op.wp ρ σ Q) : ∃ ρ' σ', Q ρ' σ' := by
  cases op <;> simp only [Op.wp] at h
  case load => obtain ⟨v, _, hq⟩ := h; exact ⟨_, _, hq⟩
  case store => obtain ⟨m, _, hq⟩ := h; exact ⟨_, _, hq⟩
  case havoc => exact ⟨_, _, h 0#64⟩
  case guard => exact ⟨_, _, h.2⟩
  case out => exact ⟨_, _, h.2⟩
  all_goals exact ⟨_, _, h⟩

theorem wpOpsL_exists {ops : List Op} {ρ : Env} {σ : State} {t : Trace}
    {Q : Env → State → Trace → Prop} (h : wpOpsL ops ρ σ t Q) :
    ∃ ρ' σ' t', Q ρ' σ' t' := by
  induction ops generalizing ρ σ t with
  | nil => exact ⟨_, _, _, h⟩
  | cons op ops ih =>
    obtain ⟨ρ₁, σ₁, h₁⟩ := Op.wp_exists h
    exact ih h₁

/-- A block that runs to `Q` has an outcome of which `Q` holds. -/
theorem Block.wpL_exists {b : Block} {σ : State} {t : Trace} {Q : State → Trace → Prop}
    (h : b.wpL σ t Q) : ∃ σ' t', Q σ' t' := by
  obtain ⟨ρ, σ₁, t₁, hq⟩ := wpOpsL_exists h
  simp only [Term.wpL] at hq
  cases hb : b.term <;> rw [hb] at hq <;> simp only [Term.wp] at hq
  all_goals exact ⟨_, _, hq⟩

/-- **A run that reaches a postcondition has an outcome that does.** If every run of `P`
from `σ` after `t` reaches `Q`, some state and some trace that extends `t` satisfy `Q`. -/
theorem _root_.Braid.EventuallyL.exists {P : Braid.Program} {Q : State → Trace → Prop}
    {σ : State}
    {t : Trace} (h : EventuallyL P Q σ t) : ∃ σ' ls, Q σ' (t ++ ls) := by
  induction h with
  | done σ t hq => exact ⟨σ, [], by rwa [List.append_nil]⟩
  | step σ t R hs _ ih =>
    obtain ⟨b, _, hw⟩ := hs
    obtain ⟨σ₁, t₁, hr, ls, rfl, _⟩ := Block.wpL_exists (Block.wpL_writes hw)
    obtain ⟨σ', ls', hq⟩ := ih σ₁ _ hr
    exact ⟨σ', ls ++ ls', by rwa [← List.append_assoc]⟩

/-! ## The states a machine can reach -/

/-- Two machine states related to states of the dialect with the same byte of memory have
the same byte. -/
theorem dmem_eq_of_rel {m m' : MachineState} {σ σ' : State} (h : Rel m σ) (h' : Rel m' σ')
    {a : Word} (he : σ'.mem a = σ.mem a) : m'.data.dmem[a]? = m.data.dmem[a]? := by
  rw [h.data.mem, h'.data.mem] at he
  simp only [memOf] at he
  cases hx : m'.data.dmem[a]? with
  | none =>
    cases hy : m.data.dmem[a]? with
    | none => rfl
    | some y => rw [hx, hy] at he; cases he
  | some x =>
    cases hy : m.data.dmem[a]? with
    | none => rw [hx, hy] at he; cases he
    | some y =>
      rw [hx, hy] at he
      simp only [Option.map_some, Option.some.injEq, Cell.mk.injEq, and_true] at he
      rw [UInt8.toBitVec_inj.1 he]

section
variable [Layout]

/-- The state `m'` is a possible outcome of a step of the executable from `m`: whatever the
model says of every outcome of that step is true of `m'`. Where the model gives `m` no step
at all, because the instruction there faults or is outside the model, it says nothing of the
outcomes, and every state is a possible outcome: this takes a fault to be able to do
anything. -/
@[expose] def Next (e : Executable) (m m' : MachineState) : Prop :=
  ∀ mid : MachineState → Prop, step1 e m mid → mid m'

/-- The states the machine can reach from `m`, in any number of steps. -/
inductive Reachable (e : Executable) : MachineState → MachineState → Prop where
  | refl (m : MachineState) : Reachable e m m
  | step {m m₁ m' : MachineState} : Next e m m₁ → Reachable e m₁ m' → Reachable e m m'

/-- A block of the lowered code is a step of the machine: every outcome of the step from a
state related to `σ` is related to an outcome of the block. -/
theorem step1_of_wp {e : Executable} {m : MachineState} {σ : State} {b : Block}
    {R : State → Prop} (h : Rel m σ) (hb : lowerProgram e σ.pc = some b) (hw : b.wp σ R) :
    step1 e m fun m' => ∃ σ', Rel m' σ' ∧ R σ' := by
  have hpc : Int64.ofBitVec σ.pc = m.pc := by rw [h.pc]; rfl
  simp only [lowerProgram, hpc] at hb
  exact @lowerDirs_sound (Executable.labels e) m.data σ R m.pc _ b h.data hb hw

/-- **A machine at a jump to itself stays in that state.** If the lowered code at the
program counter is a jump to that address and nothing else, every state the machine can
reach is related to the same state of the dialect: the same registers, flags, memory and
program counter. -/
theorem Reachable.rel_of_loop {e : Executable} {m m' : MachineState} {σ : State}
    (hr : Reachable e m m') (h : Rel m σ)
    (hb : lowerProgram e σ.pc = some { ops := [], term := .jump σ.pc }) : Rel m' σ := by
  induction hr with
  | refl => exact h
  | step hn _ ih =>
    have hs := step1_of_wp (R := fun σ' => σ' = σ) h hb rfl
    obtain ⟨σ', h', rfl⟩ := hn _ hs
    exact ih h'

/-- **No store outside `inside`, of every reachable state.** Let every run of the lowered
code of an executable from `σ`, after the trace `t`, reach `Q`, where `Q` holds only of a
state at a jump to itself and of a trace whose every `write` label is inside `inside`. Then
every state the machine can reach from a state related to `σ` has, at every address outside
`inside`, the byte the machine started with. -/
theorem safe_of_eventuallyL {e : Executable} {Q : State → Trace → Prop} {inside : Word → Prop}
    (hstop : ∀ σ t, Q σ t → lowerProgram e σ.pc = some { ops := [], term := .jump σ.pc })
    (hin : ∀ σ t, Q σ t → ∀ b n, Label.write b n ∈ t →
      ∀ a : Word, (a - b).toNat < n → inside a)
    {m : MachineState} {σ : State} {t : Trace} (h : Rel m σ)
    (hw : EventuallyL (lowerProgram e) Q σ t) :
    ∀ m', Reachable e m m' → ∀ a : Word, ¬ inside a →
      m'.data.dmem[a]? = m.data.dmem[a]? := by
  induction hw generalizing m with
  | done σ t hq =>
    intro m' hr a _
    exact dmem_eq_of_rel h (hr.rel_of_loop h (hstop σ t hq)) rfl
  | step σ t R hs hn ih =>
    intro m' hr a ha
    cases hr with
    | refl => rfl
    | step hnext hr' =>
      obtain ⟨b, hb, hwp⟩ := hs
      have hs := step1_of_wp h hb (Block.wpL_erase.1
        (Block.wpL_mono (Block.wpL_writes hwp) fun σ' t' hq =>
          (⟨t', hq⟩ :
            ∃ t', R σ' t' ∧ ∃ ls, t' = t ++ ls ∧ Unchanged ls σ.mem σ'.mem)))
      obtain ⟨σ₁, h₁, t₁, hr₁, ls, rfl, hu⟩ := hnext _ hs
      refine (ih σ₁ _ hr₁ h₁ m' hr' a ha).trans
        (dmem_eq_of_rel h h₁ (hu a fun b n hm hlt => ?_))
      obtain ⟨σf, ls', hq⟩ := (hn σ₁ _ hr₁).exists
      exact ha (hin σf _ hq b n
        (List.mem_append_left ls' (List.mem_append_right t hm)) a hlt)

/-- **No store outside `inside`, from a traced triple about an image.** `blocks` are blocks
of the lowering of the executable `e`. If they satisfy a traced triple from the atoms `regs`
and the sections of the image to a postcondition at the address `stop`, where the code is a
jump to `stop` itself, and every `write` label of the triple's trace is inside `inside`, then
every state the machine can reach from a state that has the image loaded, and of which
`regs` are true, has at every address outside `inside` the byte it started with. -/
theorem program_safeT {e : Executable} {img : Image} {blocks : List (Word × Block)}
    {regs post : Atoms} {ls : Trace} {m : MachineState} {stop : Word} {inside : Word → Prop}
    (hcode : ∀ p ∈ blocks, lowerProgram e p.1 = some p.2)
    (ht : TripleT (Program.ofList blocks) (Atoms.interp (regs ++ sectionAtoms img.sections)) []
      (Atoms.interp post) ls)
    (hl : Loaded m img) (hap : Sections.Apart img.sections)
    (hpt : ∀ a ∈ regs, a.IsPointsTo)
    (hnm : ∀ a ∈ regs, ∀ q n v w, Atom.Disj a (.mem q n v w))
    (hrd : regs.Pairwise Atom.Disj) (hrs : ∀ a ∈ regs, a.sat (abs m))
    (hpc : post.At (.pc stop))
    (hstop : lowerProgram e stop = some { ops := [], term := .jump stop })
    (hin : ∀ b n, Label.write b n ∈ ls → ∀ a : Word, (a - b).toNat < n → inside a) :
    ∀ m', Reachable e m m' → ∀ a : Word, ¬ inside a →
      m'.data.dmem[a]? = m.data.dmem[a]? := by
  refine safe_of_eventuallyL
    (Q := fun σ' u => (Atoms.interp post).holds iprop(True) σ' ∧ u = ls)
    ?_ ?_ (rel_abs m)
    ((ht _ _ (holds_sections hpt hnm hrd hrs hap hl.loadedIn)).of_le
      (ofList_le_lowerProgram hcode))
  · rintro σ' u ⟨hq, _⟩
    rw [Atoms.pc_of_holds hq hpc]
    exact hstop
  · rintro σ' u ⟨_, rfl⟩
    exact hin

end

end Lowering.X86
