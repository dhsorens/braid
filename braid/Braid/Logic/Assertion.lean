/-
  Braid.Logic.Assertion

  Assertions: predicates on heaps, with the connectives of separation logic. They form a
  bunched-implication logic in the sense of Iris (`Iris.BI`), so the Iris proof mode works
  on entailments between them.

  ## Main definitions

  * `SProp`: an assertion
  * the `BI` instance: `∗`, `-∗`, `emp`, `⌜φ⌝`, `∃`, `∀`, ...
  * `SProp.holds`: an assertion holds of a state, beside a frame
-/

module

public import Braid.Logic.Heap
public import Iris.BI

@[expose] public section

namespace Braid

open Iris Iris.BI

/-- An assertion: a predicate on heaps. -/
def SProp := Heap → Prop

instance : BIBase SProp where
  Entails P Q := ∀ h, P h → Q h
  emp h := h = ∅
  pure φ _ := φ
  and P Q h := P h ∧ Q h
  or P Q h := P h ∨ Q h
  imp P Q h := P h → Q h
  sForall Ψ h := ∀ p, Ψ p → p h
  sExists Ψ h := ∃ p, Ψ p ∧ p h
  sep P Q h := ∃ h₁ h₂, h = h₁ ∪ h₂ ∧ Heap.Disjoint h₁ h₂ ∧ P h₁ ∧ Q h₂
  wand P Q h := ∀ h', Heap.Disjoint h h' → P h' → Q (h ∪ h')
  persistently P _ := P ∅
  later P h := P h

instance : Std.IsPreorder SProp where
  le_refl _ _ h := h
  le_trans _ _ _ h₁ h₂ h hp := h₂ h (h₁ h hp)

instance : COFE SProp := COFE.ofDiscrete _

theorem SProp.sep_def (P Q : SProp) (h : Heap) :
    (iprop(P ∗ Q) : SProp) h ↔ ∃ h₁ h₂, h = h₁ ∪ h₂ ∧ Heap.Disjoint h₁ h₂ ∧ P h₁ ∧ Q h₂ := Iff.rfl

theorem SProp.entails_def (P Q : SProp) : (P ⊢ Q) ↔ ∀ h, P h → Q h := Iff.rfl

instance : BI SProp where
  entails_refl _ h := h
  entails_trans h₁ h₂ h hp := h₂ h (h₁ h hp)
  equiv_iff {P Q} := ⟨
    fun h => h ▸ ⟨fun _ h => h, fun _ h => h⟩,
    fun ⟨h₁, h₂⟩ => funext fun h => propext ⟨h₁ h, h₂ h⟩⟩
  and_ne := ⟨by rintro _ _ _ h1 _ _ h2; exact (h1 : _ = _) ▸ (h2 : _ = _) ▸ rfl⟩
  or_ne := ⟨by rintro _ _ _ h1 _ _ h2; exact (h1 : _ = _) ▸ (h2 : _ = _) ▸ rfl⟩
  imp_ne := ⟨by rintro _ _ _ h1 _ _ h2; exact (h1 : _ = _) ▸ (h2 : _ = _) ▸ rfl⟩
  sep_ne := ⟨by rintro _ _ _ h1 _ _ h2; exact (h1 : _ = _) ▸ (h2 : _ = _) ▸ rfl⟩
  wand_ne := ⟨by rintro _ _ _ h1 _ _ h2; exact (h1 : _ = _) ▸ (h2 : _ = _) ▸ rfl⟩
  persistently_ne := ⟨by rintro _ _ _ h; exact (h : _ = _) ▸ rfl⟩
  later_ne := ⟨by rintro _ _ _ h; exact (h : _ = _) ▸ rfl⟩
  sForall_ne {_ P Q} h := (liftRel_eq.1 (h : liftRel Eq P Q)) ▸ rfl
  sExists_ne {_ P Q} h := (liftRel_eq.1 (h : liftRel Eq P Q)) ▸ rfl
  pure_intro h _ _ := h
  pure_elim' h σ hφ := h hφ σ ⟨⟩
  and_elim_l _ h := h.1
  and_elim_r _ h := h.2
  and_intro h₁ h₂ σ hp := ⟨h₁ σ hp, h₂ σ hp⟩
  or_intro_l _ h := .inl h
  or_intro_r _ h := .inr h
  or_elim h₁ h₂ σ h := h.elim (h₁ σ) (h₂ σ)
  imp_intro h σ hp hq := h σ ⟨hp, hq⟩
  imp_elim h σ hpq := h σ hpq.1 hpq.2
  sForall_intro h σ hp p hΨ := h p hΨ σ hp
  sForall_elim hΨ _ h := h _ hΨ
  sExists_intro hΨ _ h := ⟨_, hΨ, h⟩
  sExists_elim h σ := fun ⟨p, hΨ, hp⟩ => h p hΨ σ hp
  sep_mono h₁ h₂ _ := fun ⟨a, b, e, d, hp, hq⟩ => ⟨a, b, e, d, h₁ a hp, h₂ b hq⟩
  emp_sep := ⟨
    fun _ ⟨a, b, e, _, he, hp⟩ => by
      have he : a = ∅ := he
      subst he; rw [e, Heap.empty_union]; exact hp,
    fun h hp => ⟨∅, h, (Heap.empty_union h).symm, Heap.disjoint_empty_left h, rfl, hp⟩⟩
  sep_symm _ := fun ⟨a, b, e, d, hp, hq⟩ => ⟨b, a, e.trans d.union_comm, d.symm, hq, hp⟩
  sep_assoc_l _ := fun ⟨_, c, e, d, ⟨a, b, e', d', hp, hq⟩, hr⟩ => by
    subst e'
    have d3 := Heap.disjoint_union_left.1 d
    exact ⟨a, b ∪ c, e.trans (Heap.union_assoc a b c),
      Heap.disjoint_union_right.2 ⟨d', d3.1⟩, hp, b, c, rfl, d3.2, hq, hr⟩
  wand_intro h σ hp σ' d hq := h _ ⟨σ, σ', rfl, d, hp, hq⟩
  wand_elim h _ := fun ⟨a, b, e, d, hp, hq⟩ => e ▸ h a hp b d hq
  persistently_mono h _ hp := h ∅ hp
  persistently_idem_2 _ h := h
  persistently_emp_2 _ _ := rfl
  persistently_and_2 _ h := h
  persistently_absorb_l _ := fun ⟨_, _, _, _, hp, _⟩ => hp
  persistently_and_l σ := fun ⟨hp, hq⟩ =>
    ⟨∅, σ, (Heap.empty_union σ).symm, Heap.disjoint_empty_left σ, hp, hq⟩
  later_mono := id
  later_intro _ := id
  later_sForall_2 _ h _ hp := h _ ⟨_, rfl⟩ hp
  later_sExists_false _ := fun ⟨p, hp⟩ => .inr ⟨_, ⟨_, rfl⟩, hp⟩
  later_sep := ⟨fun _ => id, fun _ => id⟩
  later_persistently := ⟨fun _ => id, fun _ => id⟩
  later_false_em _ h := .inr fun _ => h

/-- `P` holds of the state `σ` beside the frame `R`: the heap of `σ` splits into a part
satisfying `P` and a part satisfying `R`. -/
def SProp.holds (P : SProp) (R : SProp) (σ : State) : Prop := (iprop(P ∗ R) : SProp) σ.heap

end Braid
