/-
  Braid.Logic.Sym.RuleT

  The rules of `Braid.Logic.Sym.Rule` after a trace, for the stepper on a traced triple
  (`TripleT`). Each takes the arguments of the rule it is named after, with the trace so far
  after the atoms. An operation that reveals something continues after the trace with its
  label added; the others leave the trace as it is.

  Each rule is the unlabelled rule for the operation alone, by `OpsSpecT.cons`.
-/

module

public import Braid.Logic.Sym.Rule
public import Braid.Logic.Trace

@[expose] public section

namespace Braid

/-- The labels of an operation are the same in two environments that agree on what it
reads. -/
theorem Op.leak_agree {op : Op} {ρ ρ' : Env} (h : ∀ x ∈ op.uses, ρ x = ρ' x) :
    op.leak ρ = op.leak ρ' := by
  cases op <;> simp only [Op.uses, List.mem_cons, List.not_mem_nil, or_false, forall_eq_or_imp,
    forall_eq] at h <;> simp only [Op.leak]
  case bin => rw [h.1, h.2]
  case load => rw [h]
  case store => rw [h.1]

/-- The labels of a terminator are the same in two environments that agree on what it
reads. -/
theorem Term.leak_agree {tm : Term} {ρ ρ' : Env} (h : AgreeOn tm.uses ρ ρ') :
    tm.leak ρ = tm.leak ρ' := by
  cases tm <;> simp only [Term.uses] at h <;> simp only [Term.leak]
  case branch c t f => rw [h c (by simp)]
  case jumpInd a => rw [h a (by simp)]

namespace Sym.RuleT

open Braid Iris Iris.BI Sym.Rule

variable {Φ : Env → Atoms → Trace → Prop}

/-! ## Operations -/

theorem const (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace)
    (Φ : Env → Atoms → Trace → Prop) (d : Var) (v : Word)
    (h : OpsSpecT ops (ρ.set d v) as t Φ) : OpsSpecT (.const d v :: ops) ρ as t Φ :=
  OpsSpecT.cons (List.append_nil t) (Rule.const [] ρ as _ d v (OpsSpec.nil h))

theorem un (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace) (Φ : Env → Atoms → Trace → Prop)
    (d a : Var) (op : UnOp) (va v : Word) (ha : ρ a = va) (hv : op.eval va = v)
    (h : OpsSpecT ops (ρ.set d v) as t Φ) : OpsSpecT (.un d op a :: ops) ρ as t Φ :=
  OpsSpecT.cons (List.append_nil t) (Rule.un [] ρ as _ d a op va v ha hv (OpsSpec.nil h))

/-- A two-operand operation that reveals nothing. -/
theorem bin (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace)
    (Φ : Env → Atoms → Trace → Prop) (d a b : Var) (op : BinOp) (va vb v : Word)
    (hl : op.leaks = false) (ha : ρ a = va) (hb : ρ b = vb) (hv : op.eval va vb = v)
    (h : OpsSpecT ops (ρ.set d v) as t Φ) : OpsSpecT (.bin d op a b :: ops) ρ as t Φ :=
  OpsSpecT.cons (by simp [hl]) (Rule.bin [] ρ as _ d a b op va vb v ha hb hv (OpsSpec.nil h))

/-- A two-operand operation that reveals its operands. -/
theorem binLeak (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace)
    (Φ : Env → Atoms → Trace → Prop) (d a b : Var) (op : BinOp) (va vb v : Word)
    (hl : op.leaks = true) (ha : ρ a = va) (hb : ρ b = vb) (hv : op.eval va vb = v)
    (h : OpsSpecT ops (ρ.set d v) as (t ++ [.operands va vb]) Φ) :
    OpsSpecT (.bin d op a b :: ops) ρ as t Φ :=
  OpsSpecT.cons (by simp [hl, ha, hb])
    (Rule.bin [] ρ as _ d a b op va vb v ha hb hv (OpsSpec.nil h))

theorem select (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace)
    (Φ : Env → Atoms → Trace → Prop) (d c a b : Var) (vc va vb v : Word) (hc : ρ c = vc)
    (ha : ρ a = va) (hb : ρ b = vb) (hv : sel vc va vb = v)
    (h : OpsSpecT ops (ρ.set d v) as t Φ) : OpsSpecT (.select d c a b :: ops) ρ as t Φ :=
  OpsSpecT.cons (List.append_nil t)
    (Rule.select [] ρ as _ d c a b vc va vb v hc ha hb hv (OpsSpec.nil h))

theorem get (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace) (Φ : Env → Atoms → Trace → Prop)
    (d : Var) (r : Reg) (v : Word) (hat : as.At (.reg r v))
    (h : OpsSpecT ops (ρ.set d v) as t Φ) : OpsSpecT (.get d r :: ops) ρ as t Φ :=
  OpsSpecT.cons (List.append_nil t) (Rule.get [] ρ as _ d r v hat (OpsSpec.nil h))

theorem set (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace) (as' : Atoms)
    (Φ : Env → Atoms → Trace → Prop) (a : Var) (r : Reg) (v₀ v : Word) (ha : ρ a = v)
    (hupd : as.Upd (.reg r v₀) (.reg r v) as') (h : OpsSpecT ops ρ as' t Φ) :
    OpsSpecT (.set r a :: ops) ρ as t Φ :=
  OpsSpecT.cons (List.append_nil t) (Rule.set [] ρ as as' _ a r v₀ v ha hupd (OpsSpec.nil h))

theorem getf (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace)
    (Φ : Env → Atoms → Trace → Prop) (d : Var) (f : Flag) (b : Bool) (v : Word)
    (hat : as.At (.flag f b)) (hv : ofBool b = v) (h : OpsSpecT ops (ρ.set d v) as t Φ) :
    OpsSpecT (.getf d f :: ops) ρ as t Φ :=
  OpsSpecT.cons (List.append_nil t) (Rule.getf [] ρ as _ d f b v hat hv (OpsSpec.nil h))

theorem setf (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace) (as' : Atoms)
    (Φ : Env → Atoms → Trace → Prop) (a : Var) (f : Flag) (va : Word) (b₀ b : Bool)
    (ha : ρ a = va) (hv : bnz va = b) (hupd : as.Upd (.flag f b₀) (.flag f b) as')
    (h : OpsSpecT ops ρ as' t Φ) : OpsSpecT (.setf f a :: ops) ρ as t Φ :=
  OpsSpecT.cons (List.append_nil t)
    (Rule.setf [] ρ as as' _ a f va b₀ b ha hv hupd (OpsSpec.nil h))

theorem setf_any (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace) (as' : Atoms)
    (Φ : Env → Atoms → Trace → Prop) (a : Var) (f : Flag) (va : Word) (b : Bool)
    (ha : ρ a = va) (hv : bnz va = b) (hupd : as.Upd (.prop (flagAny f)) (.flag f b) as')
    (h : OpsSpecT ops ρ as' t Φ) : OpsSpecT (.setf f a :: ops) ρ as t Φ :=
  OpsSpecT.cons (List.append_nil t)
    (Rule.setf_any [] ρ as as' _ a f va b ha hv hupd (OpsSpec.nil h))

/-- A load reveals its address and its size. -/
theorem load (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace)
    (Φ : Env → Atoms → Trace → Prop) (d a : Var) (W : Width) (addr v v' : Word) (n : Nat)
    (w : Bool) (ha : ρ a = addr) (hat : as.At (.mem addr n v w)) (hn : n = W.bytes)
    (hv : ld W v = v') (h : OpsSpecT ops (ρ.set d v') as (t ++ [.read addr n]) Φ) :
    OpsSpecT (.load d W a :: ops) ρ as t Φ :=
  OpsSpecT.cons (by simp [ha, hn])
    (Rule.load [] ρ as _ d a W addr v v' n w ha hat hn hv (OpsSpec.nil h))

/-- A store reveals its address and its size. -/
theorem store (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace) (as' : Atoms)
    (Φ : Env → Atoms → Trace → Prop) (a x : Var) (W : Width) (addr v xv : Word) (n : Nat)
    (ha : ρ a = addr) (hx : ρ x = xv)
    (hupd : as.Upd (.mem addr n v true) (.mem addr n xv true) as') (hn : n = W.bytes)
    (h : OpsSpecT ops ρ as' (t ++ [.write addr n]) Φ) : OpsSpecT (.store W a x :: ops) ρ as t Φ :=
  OpsSpecT.cons (by simp [ha, hn])
    (Rule.store [] ρ as as' _ a x W addr v xv n ha hx hupd hn (OpsSpec.nil h))

theorem havoc (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace)
    (Φ : Env → Atoms → Trace → Prop) (d : Var) (h : ∀ v, OpsSpecT ops (ρ.set d v) as t Φ) :
    OpsSpecT (.havoc d :: ops) ρ as t Φ :=
  OpsSpecT.cons (List.append_nil t) (Rule.havoc [] ρ as _ d fun v => OpsSpec.nil (h v))

theorem guard (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace)
    (Φ : Env → Atoms → Trace → Prop) (c : Var) (vc : Word) (hc : ρ c = vc) (hne : nz vc)
    (h : OpsSpecT ops ρ as t Φ) : OpsSpecT (.guard c :: ops) ρ as t Φ :=
  OpsSpecT.cons (List.append_nil t) (Rule.guard [] ρ as _ c vc hc hne (OpsSpec.nil h))

/-! ## Flags that hold some value -/

theorem wpOpsL_agree {ops : List Op} {live : List Var} {ρ ρ' : Env} {σ : State} {t : Trace}
    {Q Q' : Env → State → Trace → Prop} (h : AgreeOn (liveOps ops live) ρ ρ')
    (hQ : ∀ ρ₁ ρ₂ σ' u, AgreeOn live ρ₁ ρ₂ → Q ρ₁ σ' u → Q' ρ₂ σ' u)
    (hw : wpOpsL ops ρ σ t Q) : wpOpsL ops ρ' σ t Q' := by
  induction ops generalizing ρ ρ' σ t with
  | nil => exact hQ _ _ _ _ h hw
  | cons op ops ih =>
    simp only [wpOpsL, Op.wpL] at hw ⊢
    have hl : op.leak ρ = op.leak ρ' :=
      Op.leak_agree fun x hx => h x (List.mem_append_left _ hx)
    rw [← hl]
    exact Op.wp_agree h (fun _ _ _ ha hq => ih ha hq) hw

/-- The rest of a block means the same in two environments that agree on what it reads. -/
theorem env_agree {ops : List Op} {tm : Term} {ρ ρ' : Env} {as : Atoms} {t : Trace}
    {Ψ : Atoms → Trace → Prop} (h : AgreeOn (liveOps ops tm.uses) ρ ρ')
    (hs : OpsSpecT ops ρ as t fun ρ as' u => TermSpecT tm ρ as' u Ψ) :
    OpsSpecT ops ρ' as t fun ρ as' u => TermSpecT tm ρ as' u Ψ := by
  refine ⟨fun R σ hσ => wpOpsL_agree h ?_ (hs.run R σ hσ)⟩
  rintro ρ₁ ρ₂ σ' u ha ⟨as', ht, hh⟩
  refine ⟨as', ⟨fun R σ hσ => ?_⟩, hh⟩
  have := ht.run R σ hσ
  simp only [Term.wpL] at this ⊢
  rw [← Term.leak_agree ha]
  exact Term.wp_agree ha this

/-- An undefined flag: `havoc d` and `setf f d`, when the rest of the block does not read
`d`. The flag holds some value afterwards, and the trace is as it was. -/
theorem havoc_setf (ops : List Op) (ρ : Env) (as : Atoms) (t : Trace) (as' : Atoms)
    (tm : Term) (Ψ : Atoms → Trace → Prop) (d : Var) (f : Flag) (a : Atom)
    (ha : a.interp ⊢ flagAny f) (hdead : (liveOps ops tm.uses).contains d = false)
    (hupd : as.Upd a (.prop (flagAny f)) as')
    (h : OpsSpecT ops ρ as' t fun ρ as' u => TermSpecT tm ρ as' u Ψ) :
    OpsSpecT (.havoc d :: .setf f d :: ops) ρ as t fun ρ as' u => TermSpecT tm ρ as' u Ψ := by
  refine OpsSpecT.cons (List.append_nil t) (OpsSpec.havoc fun v => OpsSpec.nil ?_)
  obtain ⟨as₁, h₁, h₂⟩ := upd_via (.flag f ((ρ.set d v) d != 0#64)) hupd
  refine OpsSpecT.cons (List.append_nil t) (setf_core ha h₁ (weaken (flag_any f _) h₂
    (OpsSpec.nil (env_agree (fun x hx => ?_) h))))
  have hne : x ≠ d := fun e => by
    subst e
    have := List.contains_iff_mem.2 hx
    rw [hdead] at this
    cases this
  exact (Env.set_other ρ v hne).symm

/-! ## Terminators and blocks -/

/-- The end of the operations of a block: its terminator. -/
theorem nil (ρ : Env) (as : Atoms) (t : Trace) (tm : Term) (Ψ : Atoms → Trace → Prop)
    (h : TermSpecT tm ρ as t Ψ) : OpsSpecT [] ρ as t (fun ρ' as' u => TermSpecT tm ρ' as' u Ψ) :=
  OpsSpecT.nil h

theorem jump (ρ : Env) (as : Atoms) (t : Trace) (as' : Atoms) (Ψ : Atoms → Trace → Prop)
    (p a : Word) (hupd : as.Upd (.pc p) (.pc a) as') (h : Ψ as' t) :
    TermSpecT (.jump a) ρ as t Ψ :=
  TermSpecT.of (List.append_nil t) (Rule.jump ρ as as' _ p a hupd h)

/-- A computed jump reveals its target. -/
theorem jumpInd (ρ : Env) (as : Atoms) (t : Trace) (as' : Atoms) (Ψ : Atoms → Trace → Prop)
    (p v : Word) (a : Var) (ha : ρ a = v) (hupd : as.Upd (.pc p) (.pc v) as')
    (h : Ψ as' (t ++ [.jump v])) : TermSpecT (.jumpInd a) ρ as t Ψ :=
  TermSpecT.of (by simp [ha]) (Rule.jumpInd ρ as as' _ p v a ha hupd h)

/-- A conditional branch reveals which way it goes. -/
theorem branch (ρ : Env) (as : Atoms) (t : Trace) (as₁ as₂ : Atoms)
    (Ψ : Atoms → Trace → Prop) (p tt ff : Word) (c : Var) (vc : Word) (hc : ρ c = vc)
    (h₁ : as.Upd (.pc p) (.pc tt) as₁) (h₂ : as.Upd (.pc p) (.pc ff) as₂)
    (ht : nz vc → Ψ as₁ (t ++ [.jump tt])) (hf : isz vc → Ψ as₂ (t ++ [.jump ff])) :
    TermSpecT (.branch c tt ff) ρ as t Ψ := by
  subst hc
  refine TermSpecT.of rfl (TermSpec.branch h₁ h₂ (fun hn => ?_) (fun hz => ?_))
  · have e : (Term.branch c tt ff).leak ρ = [.jump tt] := by
      simp only [Term.leak, ne_eq, hn, not_false_eq_true, ↓reduceIte]
    rw [e]; exact ht hn
  · have e : (Term.branch c tt ff).leak ρ = [.jump ff] := by
      simp only [Term.leak, ne_eq, hz, not_true_eq_false, ↓reduceIte]
    rw [e]; exact hf hz

/-- One block of a program, after a trace. -/
theorem block (P : Program) (as : Atoms) (t : Trace) (post : SProp) (t' : Trace) (p : Word)
    (ops : List Op) (tm : Term) (hpc : as.At (.pc p)) (hb : P p = some ⟨ops, tm⟩)
    (h : OpsSpecT ops (fun _ => 0#64) as t fun ρ as' u =>
      TermSpecT tm ρ as' u fun as'' u' => TripleT P (Atoms.interp as'') u' post t') :
    TripleT P (Atoms.interp as) t post t' :=
  TripleT.step hpc hb h

end Sym.RuleT

end Braid
