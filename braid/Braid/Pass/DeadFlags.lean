/-
  Braid.Pass.DeadFlags

  A pass over the dialect: remove a write of a flag that the same block writes again before
  reading it. One instruction's block writes each flag once, so the pass does nothing on a
  freshly lowered program. After `Program.fuseAt` has joined a chain of instructions into
  one block it does most of the work: on x86-64 nearly every instruction writes six flags,
  and only the last write of each before a branch is ever read.

  The pass keeps every operation that can fault, so the block faults exactly where it did.

  ## Main definitions

  * `Block.dse`: the block without its overwritten flag writes
  * `Program.dse`: the pass on every block

  ## Main results

  * `Block.dse_wp`: the image establishes what the block does
  * `Program.dse_eventually`: runs of the image are runs of the program
-/

module

public import Braid.Pass.Fuse

@[expose] public section

namespace Braid

/-- The operations without the flag writes that are overwritten before being read, and the
flags that are dead before them: written again before any read. -/
def dseOps : List Op → List Op × List Flag
  | [] => ([], [])
  | .setf f a :: ops =>
    let r := dseOps ops
    if r.2.contains f then r else (.setf f a :: r.1, f :: r.2)
  | .getf d f :: ops =>
    let r := dseOps ops
    (.getf d f :: r.1, r.2.filter (· ≠ f))
  | op :: ops =>
    let r := dseOps ops
    (op :: r.1, r.2)

/-- The block without the flag writes that it overwrites before reading. -/
def Block.dse (b : Block) : Block := ⟨(dseOps b.ops).1, b.term⟩

/-- The pass on every block of a program. -/
def Program.dse (P : Program) : Program := fun a => (P a).map Block.dse

/-- The pass on every block of a function. -/
def Func.dse (f : Func) : Func := { f with blocks := f.blocks.map fun ab => (ab.1, ab.2.dse) }

/-- Two states are the same but for the flags of a list. -/
def AgreeExcept (D : List Flag) (σ τ : State) : Prop :=
  σ.regs = τ.regs ∧ σ.mem = τ.mem ∧ σ.pc = τ.pc ∧ ∀ f, f ∉ D → σ.flags f = τ.flags f

theorem AgreeExcept.refl (D : List Flag) (σ : State) : AgreeExcept D σ σ :=
  ⟨rfl, rfl, rfl, fun _ _ => rfl⟩

theorem AgreeExcept.eq {σ τ : State} (h : AgreeExcept [] σ τ) : σ = τ := by
  obtain ⟨hr, hm, hp, hf⟩ := h
  cases σ; cases τ
  simp only at hr hm hp hf
  subst hr hm hp
  congr 1
  funext f
  exact hf f (by simp)

theorem AgreeExcept.mono {D D' : List Flag} {σ τ : State} (h : AgreeExcept D σ τ)
    (hD : ∀ f, f ∈ D → f ∈ D') : AgreeExcept D' σ τ :=
  ⟨h.1, h.2.1, h.2.2.1, fun f hf => h.2.2.2 f fun hm => hf (hD f hm)⟩

/-- An operation that is not a flag read or write has the same meaning in two states that
agree but for some flags, and keeps them so. -/
theorem Op.wp_agreeExcept {op : Op} {D : List Flag} {ρ : Env} {σ τ : State}
    {Q Q' : Env → State → Prop} (hop : ∀ f a, op ≠ .setf f a) (hop' : ∀ d f, op ≠ .getf d f)
    (h : AgreeExcept D σ τ) (hQ : ∀ ρ' σ' τ', AgreeExcept D σ' τ' → Q' ρ' σ' → Q ρ' τ')
    (hw : op.wp ρ σ Q') : op.wp ρ τ Q := by
  obtain ⟨hr, hm, hp, hf⟩ := h
  cases op <;> simp only [Op.wp] at hw ⊢
  case setf f a => exact absurd rfl (hop f a)
  case getf d f => exact absurd rfl (hop' d f)
  case get d r => rw [← hr]; exact hQ _ _ _ ⟨hr, hm, hp, hf⟩ hw
  case set r a =>
    exact hQ _ (σ.setReg r (ρ a)) (τ.setReg r (ρ a))
      ⟨by simp only [State.setReg, hr], hm, hp, hf⟩ hw
  case load d w a =>
    obtain ⟨v, hv, hq⟩ := hw
    exact ⟨v, by rw [← hm]; exact hv, hQ _ _ _ ⟨hr, hm, hp, hf⟩ hq⟩
  case store w a v =>
    obtain ⟨m, hm', hq⟩ := hw
    exact ⟨m, by rw [← hm]; exact hm',
      hQ _ { σ with mem := m } { τ with mem := m } ⟨hr, rfl, hp, hf⟩ hq⟩
  case havoc d => exact fun v => hQ _ _ _ ⟨hr, hm, hp, hf⟩ (hw v)
  case guard c => exact ⟨hw.1, hQ _ _ _ ⟨hr, hm, hp, hf⟩ hw.2⟩
  all_goals exact hQ _ _ _ ⟨hr, hm, hp, hf⟩ hw

/-- The operations without their overwritten flag writes establish what the operations do,
from states that agree but for the flags dead before them. -/
theorem wpOps_of_dse {ops : List Op} {ρ : Env} {σ τ : State} {Q : Env → State → Prop}
    (h : AgreeExcept (dseOps ops).2 σ τ) (hw : wpOps (dseOps ops).1 ρ σ Q) : wpOps ops ρ τ Q := by
  induction ops generalizing ρ σ τ with
  | nil => rw [← h.eq]; exact hw
  | cons op ops ih =>
    by_cases hs : ∃ f a, op = .setf f a
    · obtain ⟨f, a, rfl⟩ := hs
      simp only [dseOps] at h hw
      by_cases hd : (dseOps ops).2.contains f = true
      · simp only [hd, ↓reduceIte] at h hw
        simp only [wpOps, Op.wp]
        refine ih ⟨h.1, h.2.1, h.2.2.1, fun g hg => ?_⟩ hw
        have hgf : g ≠ f := fun e => hg (by rw [e]; simpa using hd)
        simp only [State.setFlag, hgf, ↓reduceIte]
        exact h.2.2.2 g hg
      · simp only [hd, Bool.false_eq_true, ↓reduceIte] at h hw
        simp only [wpOps, Op.wp] at hw ⊢
        refine ih (σ := σ.setFlag f (ρ a != 0#64)) (τ := τ.setFlag f (ρ a != 0#64))
          ⟨h.1, h.2.1, h.2.2.1, fun g hg => ?_⟩ hw
        simp only [State.setFlag]
        by_cases hgf : g = f
        · simp only [hgf, ↓reduceIte]
        · simp only [hgf, ↓reduceIte]
          exact h.2.2.2 g (by simp [hgf, hg])
    · by_cases hg : ∃ d f, op = .getf d f
      · obtain ⟨d, f, rfl⟩ := hg
        simp only [dseOps] at h hw
        have hf : σ.flags f = τ.flags f := h.2.2.2 f (by simp)
        simp only [wpOps, Op.wp] at hw ⊢
        rw [← hf]
        exact ih (h.mono fun g hg => (List.mem_filter.1 hg).1) hw
      · have e : dseOps (op :: ops) = (op :: (dseOps ops).1, (dseOps ops).2) := by
          cases op <;> first | rfl | exact absurd ⟨_, _, rfl⟩ hs | exact absurd ⟨_, _, rfl⟩ hg
        rw [e] at h hw
        exact Op.wp_agreeExcept (fun f a e => hs ⟨f, a, e⟩) (fun d f e => hg ⟨d, f, e⟩) h
          (fun _ _ _ h' hq => ih h' hq) hw

/-- **The block without its overwritten flag writes establishes what the block does.** -/
theorem Block.dse_wp {b : Block} {σ : State} {Q : State → Prop} (hw : b.dse.wp σ Q) :
    b.wp σ Q :=
  wpOps_of_dse (AgreeExcept.refl _ σ) hw

/-- **Runs of the image are runs of the program.** -/
theorem Program.dse_eventually (P : Program) {Q : State → Prop} {σ : State}
    (h : Eventually P.dse Q σ) : Eventually P Q σ := by
  induction h with
  | done σ hq => exact .done σ hq
  | step σ R hs _ ih =>
    obtain ⟨b', hb, hw⟩ := hs
    simp only [Program.dse, Option.map_eq_some_iff] at hb
    obtain ⟨b, hb, rfl⟩ := hb
    exact .step σ R ⟨b, hb, Block.dse_wp hw⟩ ih

end Braid
