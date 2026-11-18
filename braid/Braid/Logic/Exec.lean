/-
  Braid.Logic.Exec

  Symbolic execution: the rules that run a block on a symbolic state. The state is a list of
  atoms, and each rule is the weakest-precondition equation of one operation, read on that
  list: a read finds its atom, a write replaces it, and nothing else moves. `Triple.step`
  takes one block of a program this way.

  ## Main definitions

  * `OpsSpec`, `TermSpec`, `BlockSpec`: operations, a terminator and a block, run on atoms

  ## Main results

  * one rule for each operation and terminator
  * `Triple.step`: the block at the program counter
-/

module

public import Braid.Logic.Local
public import Braid.Logic.Triple

@[expose] public section

namespace Braid

open Iris Iris.BI

/-- From any state satisfying the atoms beside a frame, the operations run without fault,
and every outcome satisfies atoms that `Φ` accepts, beside the same frame. -/
structure OpsSpec (ops : List Op) (ρ : Env) (as : Atoms) (Φ : Env → Atoms → Prop) : Prop where
  run : ∀ (R : SProp) (σ : State), (Atoms.interp as).holds R σ →
    wpOps ops ρ σ fun ρ' σ' => ∃ as', Φ ρ' as' ∧ (Atoms.interp as').holds R σ'

/-- The same, for a terminator. -/
structure TermSpec (t : Term) (ρ : Env) (as : Atoms) (Φ : Atoms → Prop) : Prop where
  run : ∀ (R : SProp) (σ : State), (Atoms.interp as).holds R σ →
    t.wp ρ σ fun σ' => ∃ as', Φ as' ∧ (Atoms.interp as').holds R σ'

/-- The same, for a block. -/
structure BlockSpec (b : Block) (as : Atoms) (Φ : Atoms → Prop) : Prop where
  run : ∀ (R : SProp) (σ : State), (Atoms.interp as).holds R σ →
    b.wp σ fun σ' => ∃ as', Φ as' ∧ (Atoms.interp as').holds R σ'

theorem holds_split {as : Atoms} {A F R : SProp} {σ : State}
    (e : Atoms.interp as = iprop(A ∗ F)) :
    (Atoms.interp as).holds R σ ↔ A.holds iprop(F ∗ R) σ := by
  rw [e]; exact SProp.holds_assoc

namespace OpsSpec

variable {ops : List Op} {ρ : Env} {as as' : Atoms} {Φ : Env → Atoms → Prop}

theorem nil (h : Φ ρ as) : OpsSpec [] ρ as Φ :=
  ⟨fun _ _ hs => ⟨as, h, hs⟩⟩

theorem const {d : Var} {v : Word} (h : OpsSpec ops (ρ.set d v) as Φ) :
    OpsSpec (.const d v :: ops) ρ as Φ :=
  ⟨fun R σ hs => h.run R σ hs⟩

theorem un {d a : Var} {op : UnOp} (h : OpsSpec ops (ρ.set d (op.eval (ρ a))) as Φ) :
    OpsSpec (.un d op a :: ops) ρ as Φ :=
  ⟨fun R σ hs => h.run R σ hs⟩

theorem bin {d a b : Var} {op : BinOp}
    (h : OpsSpec ops (ρ.set d (op.eval (ρ a) (ρ b))) as Φ) :
    OpsSpec (.bin d op a b :: ops) ρ as Φ :=
  ⟨fun R σ hs => h.run R σ hs⟩

theorem select {d c a b : Var}
    (h : OpsSpec ops (ρ.set d (if ρ c ≠ 0#64 then ρ a else ρ b)) as Φ) :
    OpsSpec (.select d c a b :: ops) ρ as Φ :=
  ⟨fun R σ hs => h.run R σ hs⟩

theorem get {d : Var} {r : Reg} {v : Word} (hat : as.At (.reg r v))
    (h : OpsSpec ops (ρ.set d v) as Φ) : OpsSpec (.get d r :: ops) ρ as Φ := by
  refine ⟨fun R σ hs => ?_⟩
  obtain ⟨F, e⟩ := hat.split
  simp only [wpOps, Op.wp, regIs_get ((holds_split e).1 hs)]
  exact h.run R σ hs

theorem set {a : Var} {r : Reg} {v : Word} (hupd : as.Upd (.reg r v) (.reg r (ρ a)) as')
    (h : OpsSpec ops ρ as' Φ) : OpsSpec (.set r a :: ops) ρ as Φ := by
  refine ⟨fun R σ hs => ?_⟩
  obtain ⟨F, e, e'⟩ := hupd.split
  exact h.run R _ ((holds_split e').2 (regIs_set _ ((holds_split e).1 hs)))

theorem getf {d : Var} {f : Flag} {b : Bool} (hat : as.At (.flag f b))
    (h : OpsSpec ops (ρ.set d (ofBool b)) as Φ) : OpsSpec (.getf d f :: ops) ρ as Φ := by
  refine ⟨fun R σ hs => ?_⟩
  obtain ⟨F, e⟩ := hat.split
  simp only [wpOps, Op.wp, flagIs_get ((holds_split e).1 hs)]
  exact h.run R σ hs

theorem setf {a : Var} {f : Flag} {b : Bool}
    (hupd : as.Upd (.flag f b) (.flag f (ρ a != 0#64)) as') (h : OpsSpec ops ρ as' Φ) :
    OpsSpec (.setf f a :: ops) ρ as Φ := by
  refine ⟨fun R σ hs => ?_⟩
  obtain ⟨F, e, e'⟩ := hupd.split
  exact h.run R _ ((holds_split e').2 (flagIs_set _ ((holds_split e).1 hs)))

theorem load {d a : Var} {W : Width} {v : Word} {w : Bool}
    (hat : as.At (.mem (ρ a) W.bytes v w))
    (h : OpsSpec ops (ρ.set d ((v.truncate W.bits).zeroExtend 64)) as Φ) :
    OpsSpec (.load d W a :: ops) ρ as Φ := by
  refine ⟨fun R σ hs => ?_⟩
  obtain ⟨F, e⟩ := hat.split
  exact ⟨_, memIs_load W ((holds_split e).1 hs), h.run R σ hs⟩

theorem store {a x : Var} {W : Width} {v : Word}
    (hupd : as.Upd (.mem (ρ a) W.bytes v true) (.mem (ρ a) W.bytes (ρ x) true) as')
    (h : OpsSpec ops ρ as' Φ) : OpsSpec (.store W a x :: ops) ρ as Φ := by
  refine ⟨fun R σ hs => ?_⟩
  obtain ⟨F, e, e'⟩ := hupd.split
  obtain ⟨m, hm, hs'⟩ := memIs_store (by cases W <;> decide) (ρ x) ((holds_split e).1 hs)
  exact ⟨m, hm, h.run R _ ((holds_split e').2 hs')⟩

theorem havoc {d : Var} (h : ∀ v, OpsSpec ops (ρ.set d v) as Φ) :
    OpsSpec (.havoc d :: ops) ρ as Φ :=
  ⟨fun R σ hs v => (h v).run R σ hs⟩

theorem guard {c : Var} (hc : ρ c ≠ 0#64) (h : OpsSpec ops ρ as Φ) :
    OpsSpec (.guard c :: ops) ρ as Φ :=
  ⟨fun R σ hs => ⟨hc, h.run R σ hs⟩⟩

end OpsSpec

namespace TermSpec

variable {ρ : Env} {as as' : Atoms} {Φ : Atoms → Prop}

theorem pc_set {p : Word} (a : Word) (hupd : as.Upd (.pc p) (.pc a) as') {R : SProp}
    {σ : State} (hs : (Atoms.interp as).holds R σ) : (Atoms.interp as').holds R (σ.setPc a) := by
  obtain ⟨F, e, e'⟩ := hupd.split
  exact (holds_split e').2 (pcIs_set _ ((holds_split e).1 hs))

theorem jump {p a : Word} (hupd : as.Upd (.pc p) (.pc a) as') (h : Φ as') :
    TermSpec (.jump a) ρ as Φ :=
  ⟨fun _ _ hs => ⟨as', h, pc_set a hupd hs⟩⟩

theorem jumpInd {p : Word} {a : Var} (hupd : as.Upd (.pc p) (.pc (ρ a)) as') (h : Φ as') :
    TermSpec (.jumpInd a) ρ as Φ :=
  ⟨fun _ _ hs => ⟨as', h, pc_set (ρ a) hupd hs⟩⟩

theorem branch {p t f : Word} {c : Var} {as₁ as₂ : Atoms}
    (h₁ : as.Upd (.pc p) (.pc t) as₁) (h₂ : as.Upd (.pc p) (.pc f) as₂)
    (ht : ρ c ≠ 0#64 → Φ as₁) (hf : ρ c = 0#64 → Φ as₂) : TermSpec (.branch c t f) ρ as Φ := by
  refine ⟨fun R σ hs => ?_⟩
  simp only [Term.wp]
  by_cases hc : ρ c = 0#64
  · simp only [ne_eq, hc, not_true_eq_false, ↓reduceIte]
    exact ⟨as₂, hf hc, pc_set f h₂ hs⟩
  · simp only [ne_eq, hc, not_false_eq_true, ↓reduceIte]
    exact ⟨as₁, ht hc, pc_set t h₁ hs⟩

end TermSpec

/-- A block runs its operations, then its terminator. -/
theorem BlockSpec.intro {b : Block} {as : Atoms} {Φ : Atoms → Prop}
    (h : OpsSpec b.ops (fun _ => 0#64) as fun ρ as' => TermSpec b.term ρ as' Φ) :
    BlockSpec b as Φ := by
  refine ⟨fun R σ hs => ?_⟩
  refine wpOps_mono (h.run R σ hs) ?_
  rintro ρ σ' ⟨as', ht, hs'⟩
  exact ht.run R σ' hs'

/-- **One block of a program.** With the program counter at `p`, the block there runs on
the atoms, and the triple continues from each outcome. -/
theorem Triple.step {P : Program} {as : Atoms} {post : SProp} {p : Word} {b : Block}
    (hpc : as.At (.pc p)) (hb : P p = some b)
    (h : BlockSpec b as fun as' => Triple P (Atoms.interp as') post) :
    Triple P (Atoms.interp as) post := by
  intro R σ hs
  obtain ⟨F, e⟩ := hpc.split
  have hp : σ.pc = p := pcIs_get ((holds_split e).1 hs)
  refine .step σ _ ⟨b, hp ▸ hb, h.run R σ hs⟩ ?_
  rintro σ' ⟨as', ht, hs'⟩
  exact ht R σ' hs'

/-- A symbolic state that is the postcondition needs no steps. -/
theorem Triple.done_eq {P : Program} {as bs : Atoms} (h : as = bs) :
    Triple P (Atoms.interp as) (Atoms.interp bs) :=
  h ▸ Triple.done .rfl

/-- Change the symbolic states of a triple to equal ones. -/
theorem Triple.cast {P : Program} {as as' bs bs' : Atoms} (h : Triple P (Atoms.interp as) (Atoms.interp bs))
    (ha : as' = as) (hb : bs = bs') : Triple P (Atoms.interp as') (Atoms.interp bs') :=
  ha ▸ hb ▸ h

end Braid
