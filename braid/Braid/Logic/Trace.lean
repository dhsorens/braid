/-
  Braid.Logic.Trace

  Triples that say what a run reveals. `TripleT P pre t post t'` is a triple with the trace
  before and the trace after: from a state satisfying `pre`, after the trace `t`, every run
  reaches a state satisfying `post` with the trace `t'`. A specification of leakage is a
  `TripleT` from any `t` to `t ++ ls`, with `ls` written as a function of what is public.

  The rules are those of `Braid.Logic.Triple`, `Braid.Logic.Exec` and `Braid.Logic.Data` with
  the trace carried along. A rule for an operation is the unlabelled rule for that operation
  alone, followed by the rest of the block after the trace with its labels added
  (`OpsSpecT.cons`), so nothing about an operation is proved twice.

  ## Main definitions

  * `TripleT`: a triple with the trace before and after
  * `OpsSpecT`, `TermSpecT`: operations and a terminator, run on atoms after a trace

  ## Main results

  * `TripleT.triple`: a traced triple is a triple
  * `TripleT.frame`, `TripleT.seq`, `TripleT.conseq`, `TripleT.call`: the structural rules
  * `TripleT.step`: the block at the program counter
  * `TripleT.sound`: a traced triple, in terms of labelled runs
-/

module

public import Braid.Logic.Exec
public import Braid.Logic.Data
public import Braid.IR.Trace
import Iris.BI.DerivedLaws

@[expose] public section

namespace Braid

open Iris Iris.BI

/-- From any state satisfying `pre` beside a frame, after the trace `t`, every run of `P`
reaches a state satisfying `post` beside the same frame, with the trace `t'`. -/
def TripleT (P : Program) (pre : SProp) (t : Trace) (post : SProp) (t' : Trace) : Prop :=
  ∀ (R : SProp) (σ : State), pre.holds R σ →
    EventuallyL P (fun σ' u => post.holds R σ' ∧ u = t') σ t

namespace TripleT

variable {P : Program} {pre post mid : SProp} {t t' u : Trace}

/-- **A traced triple is a triple.** -/
theorem triple (h : TripleT P pre t post t') : Triple P pre post :=
  fun R σ hp => (h R σ hp).erase fun _ _ h => h.1

/-- A precondition that entails the postcondition needs no steps, and leaves the trace. -/
theorem done (h : pre ⊢ post) (ht : t = t') : TripleT P pre t post t' :=
  fun _ σ hp => .done σ t ⟨SProp.holds_mono h hp, ht⟩

/-- **The frame rule.** -/
theorem frame (F : SProp) (h : TripleT P pre t post t') :
    TripleT P iprop(pre ∗ F) t iprop(post ∗ F) t' :=
  fun R _ hp => (h iprop(F ∗ R) _ (SProp.holds_assoc.1 hp)).mono
    fun _ _ hq => ⟨SProp.holds_assoc.2 hq.1, hq.2⟩

/-- Sequencing. -/
theorem seq (h₁ : TripleT P pre t mid u) (h₂ : TripleT P mid u post t') :
    TripleT P pre t post t' :=
  fun R _ hp => (h₁ R _ hp).trans fun _ _ hm => hm.2 ▸ h₂ R _ hm.1

/-- The rule of consequence. -/
theorem conseq {pre' post' : SProp} (hpre : pre' ⊢ pre) (hpost : post ⊢ post')
    (h : TripleT P pre t post t') : TripleT P pre' t post' t' :=
  fun R _ hp => (h R _ (SProp.holds_mono hpre hp)).mono
    fun _ _ hq => ⟨SProp.holds_mono hpost hq.1, hq.2⟩

/-- A program with more blocks satisfies the triples of the smaller one. -/
theorem mono {P' : Program} (hP : ∀ a b, P a = some b → P' a = some b)
    (h : TripleT P pre t post t') : TripleT P' pre t post t' :=
  fun R _ hp => (h R _ hp).of_le hP

/-- An existential in the precondition is a universal over the triple. -/
theorem exists_pre {α : Sort _} {pre : α → SProp} (h : ∀ x, TripleT P (pre x) t post t') :
    TripleT P iprop(∃ x, pre x) t post t' := by
  intro R σ hp
  obtain ⟨h₁, h₂, e, d, ⟨_, ⟨x, rfl⟩, hx⟩, hr⟩ := hp
  exact h x R σ ⟨h₁, h₂, e, d, hx, hr⟩

/-- **A traced triple, in terms of labelled runs.** From a state part of which satisfies
`pre`, after the trace `t`, every run reaches a state part of which satisfies `post`, with
the trace `t'`. -/
theorem sound (h : TripleT P pre t post t') {σ : State}
    (hp : (iprop(pre ∗ True) : SProp) σ.heap) :
    EventuallyL P (fun σ' u => (iprop(post ∗ True) : SProp) σ'.heap ∧ u = t') σ t :=
  h iprop(True) σ hp

end TripleT

/-! ## Operations and terminators on atoms, after a trace -/

/-- From any state satisfying the atoms beside a frame, after the trace `t`, the operations
run without fault, and every outcome satisfies atoms, with a trace, that `Φ` accepts. -/
structure OpsSpecT (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace)
    (Φ : Env → Atoms → Trace → Prop) : Prop where
  run : ∀ (R : SProp) (σ : State), (Atoms.interp as).holds R σ →
    wpOpsL ops ρ σ t fun ρ' σ' t' => ∃ as', Φ ρ' as' t' ∧ (Atoms.interp as').holds R σ'

/-- The same, for a terminator. -/
structure TermSpecT (tm : Term) (ρ : Env) (as : Atoms) (t : Trace)
    (Φ : Atoms → Trace → Prop) : Prop where
  run : ∀ (R : SProp) (σ : State), (Atoms.interp as).holds R σ →
    tm.wpL ρ σ t fun σ' t' => ∃ as', Φ as' t' ∧ (Atoms.interp as').holds R σ'

theorem OpsSpecT.nil {ρ : Env} {as : Atoms} {t : Trace} {Φ : Env → Atoms → Trace → Prop}
    (h : Φ ρ as t) : OpsSpecT [] ρ as t Φ :=
  ⟨fun _ _ hs => ⟨as, h, hs⟩⟩

/-- **One operation, by its unlabelled rule.** The operation runs on the atoms as it does
without a trace, and the rest of the block runs after the trace with its labels added. -/
theorem OpsSpecT.cons {op : Op} {ops : List Op} {ρ : Env} {as : Atoms} {t t' : Trace}
    {Φ : Env → Atoms → Trace → Prop} (he : t ++ op.leak ρ = t')
    (h : OpsSpec [op] ρ as fun ρ' as' => OpsSpecT ops ρ' as' t' Φ) :
    OpsSpecT (op :: ops) ρ as t Φ := by
  subst he
  refine ⟨fun R σ hs => ?_⟩
  simp only [wpOpsL, Op.wpL]
  refine Op.wp_mono (h.run R σ hs) ?_
  rintro ρ' σ' ⟨as', hΦ, hs'⟩
  exact hΦ.run R σ' hs'

/-- **A terminator, by its unlabelled rule.** -/
theorem TermSpecT.of {tm : Term} {ρ : Env} {as : Atoms} {t t' : Trace}
    {Φ : Atoms → Trace → Prop} (he : t ++ tm.leak ρ = t')
    (h : TermSpec tm ρ as fun as' => Φ as' t') : TermSpecT tm ρ as t Φ := by
  subst he
  exact ⟨fun R σ hs => h.run R σ hs⟩

/-- **One block of a program, after a trace.** With the program counter at `p`, the block
there runs on the atoms, and the triple continues from each outcome. -/
theorem TripleT.step {P : Program} {as : Atoms} {post : SProp} {t t' : Trace} {p : Word}
    {ops : List Op} {tm : Term} (hpc : as.At (.pc p)) (hb : P p = some ⟨ops, tm⟩)
    (h : OpsSpecT ops (fun _ => 0#64) as t fun ρ as' u =>
      TermSpecT tm ρ as' u fun as'' u' => TripleT P (Atoms.interp as'') u' post t') :
    TripleT P (Atoms.interp as) t post t' := by
  intro R σ hs
  obtain ⟨F, e⟩ := hpc.split
  have hp : σ.pc = p := pcIs_get ((holds_split e).1 hs)
  refine .step σ t
    (fun σ' u => ∃ as', TripleT P (Atoms.interp as') u post t' ∧ (Atoms.interp as').holds R σ')
    ⟨⟨ops, tm⟩, hp ▸ hb, ?_⟩ ?_
  · exact wpOpsL_mono (h.run R σ hs) fun ρ σ' u ⟨as', ht, hs'⟩ => ht.run R σ' hs'
  · rintro σ' u ⟨as', ht, hs'⟩
    exact ht R σ' hs'

/-! ## The rules of `Braid.Logic.Exec` and `Braid.Logic.Data`, after a trace -/

namespace TripleT

variable {P : Program} {t t' : Trace}

/-- A symbolic state that is the postcondition needs no steps. -/
theorem done_eq {as bs : Atoms} (h : as = bs) (ht : t = t') :
    TripleT P (Atoms.interp as) t (Atoms.interp bs) t' :=
  h ▸ TripleT.done .rfl ht

/-- A symbolic state that is the postcondition in another order needs no steps. -/
theorem done_split {as bs : Atoms} (h : as.Split bs []) (ht : t = t') :
    TripleT P (Atoms.interp as) t (Atoms.interp bs) t' := by
  rw [h.interp, List.append_nil]; exact TripleT.done .rfl ht

/-- **A call, or any use of a traced triple already proved.** Split the symbolic state into
the precondition of the triple and a frame; afterwards the state is its postcondition and
the same frame, and the trace is the one the triple leaves. -/
theorem call {cur pre post fr : Atoms} {Q : SProp} {u : Trace} (hsplit : cur.Split pre fr)
    (hcallee : TripleT P (Atoms.interp pre) t (Atoms.interp post) u)
    (hcont : TripleT P (Atoms.interp (post ++ fr)) u Q t') :
    TripleT P (Atoms.interp cur) t Q t' := by
  rw [hsplit.interp, Atoms.interp_append]
  rw [Atoms.interp_append] at hcont
  exact (hcallee.frame _).seq hcont

/-- Replace an atom of the symbolic state by atoms that mean the same. -/
theorem unfold {as rest bs : Atoms} {a : Atom} {Q : SProp} (hext : as.Extract a rest)
    (heq : a.interp = Atoms.interp bs) (h : TripleT P (Atoms.interp (bs ++ rest)) t Q t') :
    TripleT P (Atoms.interp as) t Q t' := by
  rw [hext.interp, heq, ← Atoms.interp_append]; exact h

/-- Replace atoms of the symbolic state by one atom that means the same. -/
theorem fold {as rest bs : Atoms} (a : Atom) {Q : SProp} (hsplit : as.Split bs rest)
    (heq : a.interp = Atoms.interp bs) (h : TripleT P (Atoms.interp (a :: rest)) t Q t') :
    TripleT P (Atoms.interp as) t Q t' := by
  rw [hsplit.interp, Atoms.interp_append, ← heq]; exact h

/-- Forget the value of a register. -/
theorem forget_reg {as as' : Atoms} {r : Reg} {v : Word} {Q : SProp}
    (hupd : as.Upd (.reg r v) (.prop (regAny r)) as')
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h.conseq (sep_mono_left (fun _ hv => ⟨_, ⟨v, rfl⟩, hv⟩)) .rfl

/-- Forget the value of a flag. -/
theorem forget_flag {as as' : Atoms} {f : Flag} {b : Bool} {Q : SProp}
    (hupd : as.Upd (.flag f b) (.prop (flagAny f)) as')
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h.conseq (sep_mono_left (fun _ hv => ⟨_, ⟨b, rfl⟩, hv⟩)) .rfl

/-- Name the value of a flag that holds some value. -/
theorem flag_any {as rest : Atoms} {f : Flag} {Q : SProp}
    (hext : as.Extract (.prop (flagAny f)) rest)
    (h : ∀ b, TripleT P (Atoms.interp (.flag f b :: rest)) t Q t') :
    TripleT P (Atoms.interp as) t Q t' := by
  rw [hext.interp]
  exact (TripleT.exists_pre h).conseq sep_exists_right.1 .rfl

/-- Name the value of a register that holds some value. -/
theorem reg_any {as rest : Atoms} {r : Reg} {Q : SProp}
    (hext : as.Extract (.prop (regAny r)) rest)
    (h : ∀ v, TripleT P (Atoms.interp (.reg r v :: rest)) t Q t') :
    TripleT P (Atoms.interp as) t Q t' := by
  rw [hext.interp]
  exact (TripleT.exists_pre h).conseq sep_exists_right.1 .rfl

/-- Change the trace a triple starts from, or ends with, to an equal one. -/
theorem trace_eq {pre post : SProp} {u u' : Trace} (h : TripleT P pre u post u')
    (ht : t = u) (ht' : u' = t') : TripleT P pre t post t' :=
  ht ▸ ht' ▸ h

end TripleT

end Braid
