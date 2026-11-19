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
public import Braid.Logic.Data
public import Braid.Pass.Dce

@[expose] public section

namespace Braid.Sym.Rule

open Braid Iris Iris.BI

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

/-! ## Flags that hold some value

A flag an instruction leaves undefined is lowered to `havoc d` and `setf f d`. Run by the
rules above, that puts the rest of the proof under a quantifier over the value of `d`, and
on x86-64, where most instructions leave a flag undefined, a long proof under thousands of
quantifiers is slow to assemble. When nothing later in the block reads `d`, the pair is run
by one rule with no quantifier: the flag holds some value (`flagAny`). -/

theorem flag_any (f : Flag) (b : Bool) : (Atom.flag f b).interp ⊢ flagAny f :=
  fun _ hv => ⟨_, ⟨b, rfl⟩, hv⟩

theorem any_any (f : Flag) : (Atom.prop (flagAny f)).interp ⊢ flagAny f := .rfl

/-- A flag write, to a flag that holds a known value or some value. -/
theorem setf_core {ops : List Op} {ρ : Env} {as as' : Atoms} {Φ : Env → Atoms → Prop}
    {x : Var} {f : Flag} {a : Atom} (ha : a.interp ⊢ flagAny f)
    (hupd : as.Upd a (.flag f (ρ x != 0#64)) as') (h : OpsSpec ops ρ as' Φ) :
    OpsSpec (.setf f x :: ops) ρ as Φ := by
  refine ⟨fun R σ hs => ?_⟩
  obtain ⟨F, e, e'⟩ := hupd.split
  obtain ⟨h₁, h₂, eh, d, ⟨_, ⟨b, rfl⟩, hb⟩, hr⟩ :=
    SProp.holds_mono ha ((holds_split e).1 hs)
  exact h.run R _ ((holds_split e').2 (flagIs_set _ ⟨h₁, h₂, eh, d, hb, hr⟩))

/-- A symbolic state may forget the value of an atom. -/
theorem weaken {ops : List Op} {ρ : Env} {as as' : Atoms} {Φ : Env → Atoms → Prop}
    {a a' : Atom} (ha : a.interp ⊢ a'.interp) (hupd : as.Upd a a' as')
    (h : OpsSpec ops ρ as' Φ) : OpsSpec ops ρ as Φ := by
  refine ⟨fun R σ hs => h.run R σ ?_⟩
  obtain ⟨F, e, e'⟩ := hupd.split
  exact (holds_split e').2 (SProp.holds_mono ha ((holds_split e).1 hs))

theorem upd_via {as as' : Atoms} {a c : Atom} (b : Atom) (h : as.Upd a c as') :
    ∃ as₁, as.Upd a b as₁ ∧ as₁.Upd b c as' := by
  induction h with
  | here => exact ⟨_, .here, .here⟩
  | there _ ih => obtain ⟨as₁, h₁, h₂⟩ := ih; exact ⟨_, .there h₁, .there h₂⟩

/-- The SSA values live before a list of operations, given those live after it. -/
def liveOps : List Op → List Var → List Var
  | [], live => live
  | op :: ops, live => op.liveIn (liveOps ops live)

theorem wpOps_agree {ops : List Op} {live : List Var} {ρ ρ' : Env} {σ : State}
    {Q Q' : Env → State → Prop} (h : AgreeOn (liveOps ops live) ρ ρ')
    (hQ : ∀ ρ₁ ρ₂ σ', AgreeOn live ρ₁ ρ₂ → Q ρ₁ σ' → Q' ρ₂ σ') (hw : wpOps ops ρ σ Q) :
    wpOps ops ρ' σ Q' := by
  induction ops generalizing ρ ρ' σ with
  | nil => exact hQ _ _ _ h hw
  | cons op ops ih => exact Op.wp_agree h (fun _ _ _ ha hq => ih ha hq) hw

/-- The rest of a block means the same in two environments that agree on what it reads. -/
theorem env_agree {ops : List Op} {t : Term} {ρ ρ' : Env} {as : Atoms} {Ψ : Atoms → Prop}
    (h : AgreeOn (liveOps ops t.uses) ρ ρ')
    (hs : OpsSpec ops ρ as fun ρ as' => TermSpec t ρ as' Ψ) :
    OpsSpec ops ρ' as fun ρ as' => TermSpec t ρ as' Ψ := by
  refine ⟨fun R σ hσ => wpOps_agree h ?_ (hs.run R σ hσ)⟩
  rintro ρ₁ ρ₂ σ' ha ⟨as', ht, hh⟩
  exact ⟨as', ⟨fun R σ hσ => Term.wp_agree ha (ht.run R σ hσ)⟩, hh⟩

/-- An undefined flag: `havoc d` and `setf f d`, when the rest of the block does not read
`d`. The flag holds some value afterwards. `a` is the atom of the flag before. -/
theorem havoc_setf (ops : List Op) (ρ : Env) (as as' : Atoms) (t : Term) (Ψ : Atoms → Prop)
    (d : Var) (f : Flag) (a : Atom) (ha : a.interp ⊢ flagAny f)
    (hdead : (liveOps ops t.uses).contains d = false)
    (hupd : as.Upd a (.prop (flagAny f)) as')
    (h : OpsSpec ops ρ as' fun ρ as' => TermSpec t ρ as' Ψ) :
    OpsSpec (.havoc d :: .setf f d :: ops) ρ as fun ρ as' => TermSpec t ρ as' Ψ := by
  refine OpsSpec.havoc fun v => ?_
  obtain ⟨as₁, h₁, h₂⟩ := upd_via (.flag f ((ρ.set d v) d != 0#64)) hupd
  refine setf_core ha h₁ (weaken (flag_any f _) h₂ (env_agree (fun x hx => ?_) h))
  have hne : x ≠ d := fun e => by
    subst e
    have := List.contains_iff_mem.2 hx
    rw [hdead] at this
    cases this
  exact (Env.set_other ρ v hne).symm

/-- A flag write, to a flag that holds some value. -/
theorem setf_any (ops : List Op) (ρ : Env) (as as' : Atoms) (Φ : Env → Atoms → Prop) (a : Var)
    (f : Flag) (va : Word) (b : Bool) (ha : ρ a = va) (hv : bnz va = b)
    (hupd : as.Upd (.prop (flagAny f)) (.flag f b) as') (h : OpsSpec ops ρ as' Φ) :
    OpsSpec (.setf f a :: ops) ρ as Φ := by
  subst ha hv; exact setf_core (any_any f) hupd h

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

/-! ## Finding a block

`P p = some b` can be proved by evaluating the program, a search down its list of blocks. For
a list in address order there is a proof that searches nothing: the block is in the list, and
no other block has its address. -/

/-- The addresses of the blocks are strictly increasing. -/
def sortedKeys : List (Word × Block) → Bool
  | a :: b :: l => decide (a.1.toNat < b.1.toNat) && sortedKeys (b :: l)
  | _ => true

theorem sortedKeys_tail {a : Word × Block} {l : List (Word × Block)}
    (h : sortedKeys (a :: l) = true) : sortedKeys l = true := by
  cases l with
  | nil => rfl
  | cons b l => simp only [sortedKeys, Bool.and_eq_true] at h; exact h.2

theorem sortedKeys_lt {a : Word × Block} {l : List (Word × Block)}
    (h : sortedKeys (a :: l) = true) : ∀ x ∈ l, a.1.toNat < x.1.toNat := by
  induction l generalizing a with
  | nil => intro x hx; cases hx
  | cons b l ih =>
    intro x hx
    simp only [sortedKeys, Bool.and_eq_true, decide_eq_true_eq] at h
    rcases List.mem_cons.1 hx with rfl | hx
    · exact h.1
    · exact Nat.lt_trans h.1 (ih h.2 x hx)

theorem sortedKeys_nodup {l : List (Word × Block)} (h : sortedKeys l = true) :
    (l.map (·.1)).Nodup := by
  induction l with
  | nil => simp
  | cons a l ih =>
    rw [List.map_cons, List.nodup_cons]
    refine ⟨fun hmem => ?_, ih (sortedKeys_tail h)⟩
    obtain ⟨x, hx, e⟩ := List.mem_map.1 hmem
    have := sortedKeys_lt h x hx
    rw [e] at this
    exact Nat.lt_irrefl _ this

/-- The program `P` is given by the list `l`, whose blocks are in address order. -/
structure Table (P : Program) (l : List (Word × Block)) : Prop where
  eq : P = Program.ofList l
  sorted : sortedKeys l = true

theorem Table.intro (P : Program) (l : List (Word × Block)) (eq : P = Program.ofList l)
    (sorted : sortedKeys l = true) : Table P l :=
  ⟨eq, sorted⟩

/-- A block in the list is the block of the program at its address. -/
theorem Table.get (P : Program) (l : List (Word × Block)) (e : Word × Block) (T : Table P l)
    (hm : e ∈ l) : P e.1 = some e.2 := by
  rw [T.eq]
  refine Program.ofList_mono (l := [e]) (fun p hp => ?_) (sortedKeys_nodup T.sorted) e.1 e.2 ?_
  · rw [List.mem_singleton.1 hp]; exact hm
  · simp [Program.ofList]

end Braid.Sym.Rule
