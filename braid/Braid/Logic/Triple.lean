/-
  Braid.Logic.Triple

  The triple of the logic. `Triple P pre post` says: from any state satisfying `pre` beside
  any frame, every run of the program `P` reaches a state satisfying `post` beside the same
  frame, without fault. The program counter is part of the assertions, so `pre` says where
  execution starts and `post` where it has got to. The frame rule holds by construction.

  ## Main definitions

  * `Triple`

  ## Main results

  * `Triple.frame`, `Triple.seq`, `Triple.conseq`: the structural rules
  * `Triple.exists_pre`, `Triple.pure_pre`: quantifiers and pure facts in a precondition
  * `Triple.sound`: a triple, as a statement about `Eventually`
-/

module

public import Braid.Logic.Atom
import Iris.BI.DerivedLaws

@[expose] public section

namespace Braid

open Iris Iris.BI

/-- From any state satisfying `pre` beside a frame, every run of `P` reaches a state
satisfying `post` beside the same frame. -/
def Triple (P : Program) (pre post : SProp) : Prop :=
  ∀ (R : SProp) (σ : State), pre.holds R σ → Eventually P (fun σ' => post.holds R σ') σ

theorem SProp.holds_mono {P Q R : SProp} {σ : State} (h : P ⊢ Q) (hp : P.holds R σ) :
    Q.holds R σ :=
  (sep_mono_left h : iprop(P ∗ R) ⊢ iprop(Q ∗ R)) _ hp

theorem SProp.holds_assoc {P Q R : SProp} {σ : State} :
    (iprop(P ∗ Q) : SProp).holds R σ ↔ P.holds iprop(Q ∗ R) σ :=
  ⟨fun h => (sep_assoc.1 : iprop((P ∗ Q) ∗ R) ⊢ iprop(P ∗ Q ∗ R)) _ h,
   fun h => (sep_assoc.2 : iprop(P ∗ Q ∗ R) ⊢ iprop((P ∗ Q) ∗ R)) _ h⟩

namespace Triple

variable {P : Program} {pre post mid : SProp}

/-- A precondition that entails the postcondition needs no steps. -/
theorem done (h : pre ⊢ post) : Triple P pre post :=
  fun _ σ hp => .done σ (SProp.holds_mono h hp)

/-- **The frame rule.** -/
theorem frame (F : SProp) (h : Triple P pre post) : Triple P iprop(pre ∗ F) iprop(post ∗ F) :=
  fun R _ hp => (h iprop(F ∗ R) _ (SProp.holds_assoc.1 hp)).mono fun _ hq => SProp.holds_assoc.2 hq

/-- Sequencing. -/
theorem seq (h₁ : Triple P pre mid) (h₂ : Triple P mid post) : Triple P pre post :=
  fun R _ hp => (h₁ R _ hp).trans fun _ hm => h₂ R _ hm

/-- The rule of consequence. -/
theorem conseq {pre' post' : SProp} (hpre : pre' ⊢ pre) (hpost : post ⊢ post')
    (h : Triple P pre post) : Triple P pre' post' :=
  fun R _ hp => (h R _ (SProp.holds_mono hpre hp)).mono fun _ hq => SProp.holds_mono hpost hq

/-- A program with more blocks satisfies the triples of the smaller one. -/
theorem mono {P' : Program} (hP : ∀ a b, P a = some b → P' a = some b) (h : Triple P pre post) :
    Triple P' pre post :=
  fun R _ hp => (h R _ hp).of_le hP

/-- An existential in the precondition is a universal over the triple. -/
theorem exists_pre {α : Sort _} {pre : α → SProp} (h : ∀ x, Triple P (pre x) post) :
    Triple P iprop(∃ x, pre x) post := by
  intro R σ hp
  obtain ⟨h₁, h₂, e, d, ⟨_, ⟨x, rfl⟩, hx⟩, hr⟩ := hp
  exact h x R σ ⟨h₁, h₂, e, d, hx, hr⟩

/-- A pure fact in the precondition is a hypothesis of the triple. -/
theorem pure_pre {φ : Prop} (h : φ → Triple P pre post) : Triple P iprop(⌜φ⌝ ∧ pre) post := by
  intro R σ hp
  obtain ⟨h₁, h₂, e, d, ⟨hφ, hpre⟩, hr⟩ := hp
  exact h hφ R σ ⟨h₁, h₂, e, d, hpre, hr⟩

/-- **A triple, in terms of runs.** From a state part of which satisfies `pre`, every run of
`P` reaches a state part of which satisfies `post`. The rest of the state is whatever it was:
take `Triple.frame` first to say so. -/
theorem sound (h : Triple P pre post) {σ : State} (hp : (iprop(pre ∗ True) : SProp) σ.heap) :
    Eventually P (fun σ' => (iprop(post ∗ True) : SProp) σ'.heap) σ :=
  h iprop(True) σ hp

end Triple

end Braid
