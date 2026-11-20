/-
  Lowering.Arm.Safety

  Memory safety of whole runs, from one complete run. The trace of a run of the machine
  (`Lowering.Arm.Leak`) records every store with its address and its size, and the machine is
  deterministic. The run that the lowering builds from a proof about lowered code keeps, at
  each step, the bytes the machine may load outside the stores among the step's labels
  (`RunS`, in `Lowering.Arm.Env`). So one such run that reaches the exit bounds what every
  state the machine passes through can have changed in memory: a byte the machine could load
  at the start, which no `write` label of that run covers, can still be loaded and has the
  value it started with.

  This is said of the bytes the machine may load, and not of every byte, because it is read
  off the lowered code, whose memory is those bytes.

  ## Main results

  * `leak_isEvent`: no label of an instruction is an event
  * `RunL.status_of_exit`: a run that records an exit ends exited, with that code
  * `RunS.kept`: every run from `s` keeps what one complete run from `s` keeps
  * `RunS.safe`: no store outside `inside`, of every reachable state
-/

module

public import Lowering.Arm.Env

public section

namespace Lowering.Arm

open Braid
open Arm64 (Instr)

theorem pairLeak_isEvent {acc : Word → Nat → Label} (hacc : ∀ a n, (acc a n).isEvent = false)
    (a : Word) (n : Nat) : ∀ l ∈ pairLeak acc a n, l.isEvent = false := by
  intro l hl
  simp only [pairLeak, List.mem_cons, List.not_mem_nil, or_false] at hl
  rcases hl with rfl | rfl <;> exact hacc _ _

theorem vecLeak_isEvent {acc : Word → Nat → Label} (hacc : ∀ a n, (acc a n).isEvent = false)
    (a : Word) (sz : Arm64.SimdMemSize) : ∀ l ∈ vecLeak acc a sz, l.isEvent = false := by
  intro l hl
  cases sz <;> simp only [vecLeak, List.mem_cons, List.not_mem_nil, or_false] at hl
  all_goals rcases hl with rfl | rfl <;> exact hacc _ _

theorem vecPairLeak_isEvent {acc : Word → Nat → Label}
    (hacc : ∀ a n, (acc a n).isEvent = false) (a : Word) (sz : Arm64.SimdMemSize) :
    ∀ l ∈ vecPairLeak acc a sz, l.isEvent = false := by
  intro l hl
  rcases List.mem_append.1 hl with hl | hl <;> exact vecLeak_isEvent hacc _ _ l hl

/-- No label of an instruction is an event of the environment. -/
theorem leak_isEvent {s : Arm64.State} {i : Instr} {ls : Trace} (h : leak s i = some ls) :
    ∀ l ∈ ls, l.isEvent = false := by
  have hr : ∀ (a : Word) (n : Nat), (Label.read a n).isEvent = false := fun _ _ => rfl
  have hw : ∀ (a : Word) (n : Nat), (Label.write a n).isEvent = false := fun _ _ => rfl
  unfold leak at h
  split at h <;> (try split at h) <;> (try split at h) <;> cases h <;>
    first
      | exact fun _ hl => absurd hl List.not_mem_nil
      | exact pairLeak_isEvent hr _ _
      | exact pairLeak_isEvent hw _ _
      | exact vecLeak_isEvent hr _ _
      | exact vecLeak_isEvent hw _ _
      | exact vecPairLeak_isEvent hr _ _
      | exact vecPairLeak_isEvent hw _ _
      | (intro l hl
         simp only [List.mem_cons, List.not_mem_nil, or_false] at hl
         first
           | (subst hl; rfl)
           | (rcases hl with rfl | rfl <;> rfl))

/-! ## Runs -/

/-- A machine that has exited stays where it is. -/
theorem RunL.of_exited {prog : Arm64.Program} {s s' : Arm64.State} {tr : Trace} {c : Word}
    (h : RunL prog s tr s') (hx : s.status = .Exited c) : s' = s := by
  induction h with
  | refl => rfl
  | step hs _ _ _ _ => rw [hx] at hs; cases hs
  | svc hs _ _ _ _ _ => rw [hx] at hs; cases hs
  | exited _ _ ih => exact ih hx

/-- **A run that records an exit ends exited, with that code.** -/
theorem RunL.status_of_exit {prog : Arm64.Program} {s s' : Arm64.State} {tr : Trace}
    {c : Word} (h : RunL prog s tr s') (hm : Label.event (.exit c) ∈ tr) :
    s'.status = .Exited c := by
  induction h with
  | refl => cases hm
  | step _ _ hl _ ih =>
    rcases List.mem_append.1 hm with hm | hm
    · cases leak_isEvent hl _ hm
    · exact ih hm
  | @svc s s' ls tr _ _ _ hl _ ih =>
    rcases List.mem_append.1 hm with hm | hm
    · simp only [svcLeak] at hl
      split at hl
      · cases hl; cases hm
      · split at hl
        · cases hl
          simp at hm
        · cases hl
    · exact ih hm
  | exited hs hr ih =>
    rcases List.mem_cons.1 hm with e | hm
    · cases e
      rw [hr.of_exited hs]
      exact hs
    · exact ih hm

theorem Kept.refl (s : Arm64.State) (u : Trace) : Kept s s u := fun _ hr _ => ⟨hr, rfl⟩

theorem Kept.trans {s₁ s₂ s₃ : Arm64.State} {u v : Trace} (h₁ : Kept s₁ s₂ u)
    (h₂ : Kept s₂ s₃ v) : Kept s₁ s₃ (u ++ v) := by
  intro a hr ha
  obtain ⟨hr₂, e₂⟩ := h₁ a hr fun b n hm => ha b n (List.mem_append_left _ hm)
  obtain ⟨hr₃, e₃⟩ := h₂ a hr₂ fun b n hm => ha b n (List.mem_append_right _ hm)
  exact ⟨hr₃, e₃.trans e₂⟩

theorem Kept.cons {s s' : Arm64.State} {u : Trace} (l : Label) (h : Kept s s' u) :
    Kept s s' (l :: u) :=
  fun a hr ha => h a hr fun b n hm => ha b n (List.mem_cons_of_mem _ hm)

/-- **The machine is deterministic up to the exit.** Given a run from `s` that ends exited,
each step of which keeps the bytes the machine may load outside its stores, every state any
run from `s` reaches keeps them outside the stores of that run. -/
theorem RunS.kept {prog : Arm64.Program} {s sf s' : Arm64.State} {tr tr' : Trace} {c : Word}
    (h : RunS prog s tr sf) (hx : sf.status = .Exited c) (h' : RunL prog s tr' s') :
    Kept s s' tr := by
  induction h generalizing tr' s' with
  | refl => rw [h'.of_exited hx]; exact .refl _ _
  | step hs hf hl hk _ ih =>
    cases h' with
    | refl => exact .refl _ _
    | step _ hf' _ hr' =>
      obtain rfl := Option.some.inj (hf.symm.trans hf')
      exact hk.trans (ih hx hr')
    | svc _ hf' _ _ _ =>
      obtain rfl := Option.some.inj (hf.symm.trans hf')
      cases hl
    | exited hs' _ => rw [hs] at hs'; cases hs'
  | svc hs hf _ _ hk _ ih =>
    cases h' with
    | refl => exact .refl _ _
    | step _ hf' hl' _ =>
      obtain rfl := Option.some.inj (hf.symm.trans hf')
      cases hl'
    | svc _ _ _ _ hr' => exact hk.trans (ih hx hr')
    | exited hs' _ => rw [hs] at hs'; cases hs'
  | exited hs _ _ => rw [h'.of_exited hs]; exact .refl _ _

/-- **No store outside `inside`**, stated of every reachable state. Take one complete run
from `s`: a run that ends exited, each step of which keeps the bytes the machine may load
outside its stores, as the run of a proof about lowered code does. If every `write` label of
its trace lies inside `inside`, then in every state the machine passes through from `s`,
every byte outside `inside` that the machine could load in `s` can be loaded, and is as it
was in `s`. -/
theorem RunS.safe {prog : Arm64.Program} {s sf : Arm64.State} {tr : Trace} {c : Word}
    {inside : Word → Prop} (h : RunS prog s tr sf) (hx : sf.status = .Exited c)
    (hw : ∀ b n, Label.write b n ∈ tr → ∀ a, (a - b).toNat < n → inside a) :
    ∀ s', Reachable prog s s' → ∀ a, ¬ inside a → s.mem.canRead a 1 = true →
      s'.mem.canRead a 1 = true ∧ s'.mem.read8 a = s.mem.read8 a := by
  rintro s' ⟨tr', h'⟩ a ha hr
  have e : ∀ m : Arm64.Memory, m.canRead a 1 = readable m a := fun m => by
    rw [canRead_succ]
    simp [Arm64.Memory.canRead, Arm64.Memory.allPerm, Arm64.Memory.allNoLazyFree]
  rw [e] at hr ⊢
  exact h.kept hx h' a hr fun b n hm hlt => ha (hw b n hm a hlt)

end Lowering.Arm
