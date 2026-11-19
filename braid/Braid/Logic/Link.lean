/-
  Braid.Logic.Link

  Using a function's specification and its leakage together. A function has a triple that
  says what it computes and a traced triple that says what it reveals, proved apart and with
  different postconditions. A caller needs both of one run: the values the callee leaves, and
  the trace it left. `TripleT.of_spec` joins them, for a callee that returns to an address
  outside its own code: a run of the callee's program stops exactly when it gets there, so
  the two triples speak of the same final state.

  ## Main results

  * `Block.wpL_and`: a block that establishes one postcondition and, with its trace, another,
    establishes both
  * `EventuallyL.and_of_stuck`: runs that reach `Q` and reach `Q'` with a trace, both only
    where the program has no block, reach both together
  * `TripleT.of_spec`: a specification and a specification of leakage, as one traced triple
-/

module

public import Braid.Logic.Trace

public section

namespace Braid

open Iris Iris.BI

theorem Op.wp_and {op : Op} {ρ : Env} {σ : State} {Q Q' : Env → State → Prop}
    (h : op.wp ρ σ Q) (h' : op.wp ρ σ Q') : op.wp ρ σ fun ρ' σ' => Q ρ' σ' ∧ Q' ρ' σ' := by
  cases op <;> simp only [Op.wp] at h h' ⊢
  case load =>
    obtain ⟨v, hv, hq⟩ := h
    obtain ⟨v', hv', hq'⟩ := h'
    cases hv.symm.trans hv'
    exact ⟨v, hv, hq, hq'⟩
  case store =>
    obtain ⟨m, hm, hq⟩ := h
    obtain ⟨m', hm', hq'⟩ := h'
    cases hm.symm.trans hm'
    exact ⟨m, hm, hq, hq'⟩
  case havoc => exact fun v => ⟨h v, h' v⟩
  case guard => exact ⟨h.1, h.2, h'.2⟩
  case out => exact ⟨h.1, h.2, h'.2⟩
  all_goals exact ⟨h, h'⟩

theorem wpOpsL_and {ops : List Op} {ρ : Env} {σ : State} {t : Trace} {Q : Env → State → Prop}
    {Q' : Env → State → Trace → Prop} (h : wpOps ops ρ σ Q) (h' : wpOpsL ops ρ σ t Q') :
    wpOpsL ops ρ σ t fun ρ' σ' t' => Q ρ' σ' ∧ Q' ρ' σ' t' := by
  induction ops generalizing ρ σ t with
  | nil => exact ⟨h, h'⟩
  | cons op ops ih =>
    simp only [wpOps] at h
    simp only [wpOpsL, Op.wpL] at h' ⊢
    exact Op.wp_mono (Op.wp_and h h') fun _ _ hq => ih hq.1 hq.2

theorem Term.wp_and {tm : Term} {ρ : Env} {σ : State} {Q Q' : State → Prop}
    (h : tm.wp ρ σ Q) (h' : tm.wp ρ σ Q') : tm.wp ρ σ fun σ' => Q σ' ∧ Q' σ' := by
  cases tm <;> simp only [Term.wp] at h h' ⊢
  all_goals exact ⟨h, h'⟩

/-- A block that establishes `Q`, and establishes `Q'` of the state and the trace,
establishes both. -/
theorem Block.wpL_and {b : Block} {σ : State} {t : Trace} {Q : State → Prop}
    {Q' : State → Trace → Prop} (h : b.wp σ Q) (h' : b.wpL σ t Q') :
    b.wpL σ t fun σ' t' => Q σ' ∧ Q' σ' t' :=
  wpOpsL_mono (wpOpsL_and h h') fun _ _ _ hq => Term.wp_and hq.1 hq.2

/-- **Two facts about one run.** If every run reaches `Q`, and every run reaches `Q'` with
its trace, and each holds only of states where the program has no block, then every run
reaches a state of which both hold: a run stops at the first such state, whichever fact is
asked of it. -/
theorem EventuallyL.and_of_stuck {P : Program} {Q : State → Prop} {Q' : State → Trace → Prop}
    {σ : State} {t : Trace} (hQ : ∀ σ, Q σ → P σ.pc = none)
    (hQ' : ∀ σ t, Q' σ t → P σ.pc = none) (h : Eventually P Q σ) (h' : EventuallyL P Q' σ t) :
    EventuallyL P (fun σ' t' => Q σ' ∧ Q' σ' t') σ t := by
  induction h generalizing t with
  | done σ hq =>
    cases h' with
    | done _ _ hq' => exact .done σ t ⟨hq, hq'⟩
    | step _ _ R' hs' _ =>
      obtain ⟨b, hb, _⟩ := hs'
      rw [hQ σ hq] at hb
      cases hb
  | step σ R hs _ ih =>
    cases h' with
    | done _ _ hq' =>
      obtain ⟨b, hb, _⟩ := hs
      rw [hQ' σ t hq'] at hb
      cases hb
    | step _ _ R' hs' hn' =>
      obtain ⟨b, hb, hw⟩ := hs
      obtain ⟨b', hb', hw'⟩ := hs'
      cases hb.symm.trans hb'
      exact .step σ t _ ⟨b, hb, Block.wpL_and hw hw'⟩ fun σ' t' hr => ih σ' hr.1 (hn' σ' t' hr.2)

/-- **A specification and a specification of leakage, as one traced triple.** A function has
a triple that says what it computes and a traced triple that says what it reveals. If both
end at the address `r`, and `r` is outside the code of the function, then the function runs
to the postcondition of the first with the trace of the second. A caller uses this at its own
return address, and then `TripleT.mono` and `TripleT.call`. -/
theorem TripleT.of_spec {P : Program} {pre : SProp} {post post' : Atoms} {t t' : Trace}
    {r : Word} (hr : P r = none) (hp : post.At (.pc r)) (hp' : post'.At (.pc r))
    (hs : Triple P pre (Atoms.interp post))
    (ht : TripleT P pre t (Atoms.interp post') t') :
    TripleT P pre t (Atoms.interp post) t' := by
  intro R σ hpre
  have pc_of : ∀ {as : Atoms}, as.At (.pc r) → ∀ σ : State,
      (Atoms.interp as).holds R σ → P σ.pc = none := by
    intro as hat σ h
    obtain ⟨F, e⟩ := hat.split
    rw [pcIs_get ((holds_split e).1 h)]
    exact hr
  refine (EventuallyL.and_of_stuck (pc_of hp) (fun σ _ h => pc_of hp' σ h.1)
    (hs R σ hpre) (ht R σ hpre)).mono fun σ' u h => ⟨h.1, h.2.2⟩

end Braid
