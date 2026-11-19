/-
  Braid.Logic.Sym.Rule

  The rules of symbolic execution in the form the stepper (`Braid.Logic.Sym.Step`) applies
  them. Every argument is explicit and in a fixed order, so that the stepper can build a
  proof term directly. Every SSA value an operation reads is given by an equation, which
  the stepper proves by walking the environment, and every value an operation computes is
  given by another, so that the stepper can put the value in whatever form it likes.

  These are restatements of the rules of `Braid.Logic.Exec`; nothing here is new logic.
-/

module

public import Braid.Logic.Exec

@[expose] public section

namespace Braid.Sym.Rule

open Braid

/-! ## The values the stepper asks for

Each is a name for a value or a condition of the semantics, so that the stepper can build
the term without its instances, and unfold it with the equation beside it. -/

/-- The value of a `select`. -/
def sel (c a b : Word) : Word := if c ≠ 0#64 then a else b

theorem sel_eq (c a b : Word) : sel c a b = if c ≠ 0#64 then a else b := rfl

/-- The flag a `setf` writes. -/
def bnz (v : Word) : Bool := v != 0#64

theorem bnz_eq (v : Word) : bnz v = (v != 0#64) := rfl

/-- The value a load of width `W` gives from the value `v` of the bytes. -/
def ld (W : Width) (v : Word) : Word := (v.truncate W.bits).zeroExtend 64

theorem ld_eq (W : Width) (v : Word) : ld W v = (v.truncate W.bits).zeroExtend 64 := rfl

/-- The condition of a `guard`, and of a branch taken. -/
def nz (v : Word) : Prop := v ≠ 0#64

theorem nz_eq (v : Word) : nz v = (v ≠ 0#64) := rfl

/-- The condition of a branch not taken. -/
def isz (v : Word) : Prop := v = 0#64

theorem isz_eq (v : Word) : isz v = (v = 0#64) := rfl

/-! ## Looking up an SSA value -/

theorem here (ρ : Env) (x : Var) (v : Word) : ρ.set x v x = v := Env.set_same ρ x v

theorem there (ρ : Env) (x y : Var) (v w : Word) (hne : Nat.beq y x = false) (h : ρ y = w) :
    ρ.set x v y = w := by
  rw [Env.set_other ρ v (Nat.ne_of_beq_eq_false hne)]; exact h

/-! ## Operations -/

theorem const (ops : List Op) (ρ : Env) (as : Atoms) (Φ : Env → Atoms → Prop) (d : Var)
    (v : Word) (h : OpsSpec ops (ρ.set d v) as Φ) : OpsSpec (.const d v :: ops) ρ as Φ :=
  OpsSpec.const h

theorem un (ops : List Op) (ρ : Env) (as : Atoms) (Φ : Env → Atoms → Prop) (d a : Var)
    (op : UnOp) (va v : Word) (ha : ρ a = va) (hv : op.eval va = v)
    (h : OpsSpec ops (ρ.set d v) as Φ) : OpsSpec (.un d op a :: ops) ρ as Φ := by
  subst ha hv; exact OpsSpec.un h

theorem bin (ops : List Op) (ρ : Env) (as : Atoms) (Φ : Env → Atoms → Prop) (d a b : Var)
    (op : BinOp) (va vb v : Word) (ha : ρ a = va) (hb : ρ b = vb) (hv : op.eval va vb = v)
    (h : OpsSpec ops (ρ.set d v) as Φ) : OpsSpec (.bin d op a b :: ops) ρ as Φ := by
  subst ha hb hv; exact OpsSpec.bin h

theorem select (ops : List Op) (ρ : Env) (as : Atoms) (Φ : Env → Atoms → Prop)
    (d c a b : Var) (vc va vb v : Word) (hc : ρ c = vc) (ha : ρ a = va) (hb : ρ b = vb)
    (hv : sel vc va vb = v) (h : OpsSpec ops (ρ.set d v) as Φ) :
    OpsSpec (.select d c a b :: ops) ρ as Φ := by
  subst hc ha hb hv; exact OpsSpec.select h

theorem get (ops : List Op) (ρ : Env) (as : Atoms) (Φ : Env → Atoms → Prop) (d : Var)
    (r : Reg) (v : Word) (hat : as.At (.reg r v)) (h : OpsSpec ops (ρ.set d v) as Φ) :
    OpsSpec (.get d r :: ops) ρ as Φ :=
  OpsSpec.get hat h

theorem set (ops : List Op) (ρ : Env) (as as' : Atoms) (Φ : Env → Atoms → Prop) (a : Var)
    (r : Reg) (v₀ v : Word) (ha : ρ a = v) (hupd : as.Upd (.reg r v₀) (.reg r v) as')
    (h : OpsSpec ops ρ as' Φ) : OpsSpec (.set r a :: ops) ρ as Φ := by
  subst ha; exact OpsSpec.set hupd h

theorem getf (ops : List Op) (ρ : Env) (as : Atoms) (Φ : Env → Atoms → Prop) (d : Var)
    (f : Flag) (b : Bool) (v : Word) (hat : as.At (.flag f b)) (hv : ofBool b = v)
    (h : OpsSpec ops (ρ.set d v) as Φ) : OpsSpec (.getf d f :: ops) ρ as Φ := by
  subst hv; exact OpsSpec.getf hat h

theorem setf (ops : List Op) (ρ : Env) (as as' : Atoms) (Φ : Env → Atoms → Prop) (a : Var)
    (f : Flag) (va : Word) (b₀ b : Bool) (ha : ρ a = va) (hv : bnz va = b)
    (hupd : as.Upd (.flag f b₀) (.flag f b) as') (h : OpsSpec ops ρ as' Φ) :
    OpsSpec (.setf f a :: ops) ρ as Φ := by
  subst ha hv; exact OpsSpec.setf hupd h

theorem load (ops : List Op) (ρ : Env) (as : Atoms) (Φ : Env → Atoms → Prop) (d a : Var)
    (W : Width) (addr v v' : Word) (n : Nat) (w : Bool) (ha : ρ a = addr)
    (hat : as.At (.mem addr n v w)) (hn : n = W.bytes)
    (hv : ld W v = v') (h : OpsSpec ops (ρ.set d v') as Φ) :
    OpsSpec (.load d W a :: ops) ρ as Φ := by
  subst hv; exact OpsSpec.load' ha hat hn h

theorem store (ops : List Op) (ρ : Env) (as as' : Atoms) (Φ : Env → Atoms → Prop)
    (a x : Var) (W : Width) (addr v xv : Word) (n : Nat) (ha : ρ a = addr) (hx : ρ x = xv)
    (hupd : as.Upd (.mem addr n v true) (.mem addr n xv true) as') (hn : n = W.bytes)
    (h : OpsSpec ops ρ as' Φ) : OpsSpec (.store W a x :: ops) ρ as Φ := by
  subst hx; exact OpsSpec.store' ha hupd hn h

theorem havoc (ops : List Op) (ρ : Env) (as : Atoms) (Φ : Env → Atoms → Prop) (d : Var)
    (h : ∀ v, OpsSpec ops (ρ.set d v) as Φ) : OpsSpec (.havoc d :: ops) ρ as Φ :=
  OpsSpec.havoc h

theorem guard (ops : List Op) (ρ : Env) (as : Atoms) (Φ : Env → Atoms → Prop) (c : Var)
    (vc : Word) (hc : ρ c = vc) (hne : nz vc) (h : OpsSpec ops ρ as Φ) :
    OpsSpec (.guard c :: ops) ρ as Φ := by
  subst hc; exact OpsSpec.guard hne h

/-! ## Terminators and blocks -/

/-- The end of the operations of a block: its terminator. -/
theorem nil (ρ : Env) (as : Atoms) (t : Term) (Ψ : Atoms → Prop) (h : TermSpec t ρ as Ψ) :
    OpsSpec [] ρ as (fun ρ' as' => TermSpec t ρ' as' Ψ) :=
  OpsSpec.nil h

theorem jump (ρ : Env) (as as' : Atoms) (Ψ : Atoms → Prop) (p a : Word)
    (hupd : as.Upd (.pc p) (.pc a) as') (h : Ψ as') : TermSpec (.jump a) ρ as Ψ :=
  TermSpec.jump hupd h

theorem jumpInd (ρ : Env) (as as' : Atoms) (Ψ : Atoms → Prop) (p v : Word) (a : Var)
    (ha : ρ a = v) (hupd : as.Upd (.pc p) (.pc v) as') (h : Ψ as') :
    TermSpec (.jumpInd a) ρ as Ψ := by
  subst ha; exact TermSpec.jumpInd hupd h

theorem branch (ρ : Env) (as as₁ as₂ : Atoms) (Ψ : Atoms → Prop) (p t f : Word) (c : Var)
    (vc : Word) (hc : ρ c = vc) (h₁ : as.Upd (.pc p) (.pc t) as₁)
    (h₂ : as.Upd (.pc p) (.pc f) as₂) (ht : nz vc → Ψ as₁) (hf : isz vc → Ψ as₂) :
    TermSpec (.branch c t f) ρ as Ψ := by
  subst hc; exact TermSpec.branch h₁ h₂ ht hf

/-- One block of a program: its operations run on the atoms, then its terminator, and the
triple continues from each outcome. -/
theorem block (P : Program) (as : Atoms) (post : SProp) (p : Word) (ops : List Op) (t : Term)
    (hpc : as.At (.pc p)) (hb : P p = some ⟨ops, t⟩)
    (h : OpsSpec ops (fun _ => 0#64) as fun ρ as' =>
      TermSpec t ρ as' fun as'' => Triple P (Atoms.interp as'') post) :
    Triple P (Atoms.interp as) post :=
  Triple.step hpc hb (BlockSpec.intro h)

end Braid.Sym.Rule
