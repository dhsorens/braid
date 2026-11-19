/-
  Braid.IR.Trace

  Labelled steps. An operation of the dialect, besides what it does to the state, reveals
  something to whoever watches the machine run: the address of a load or a store, the
  operands of a division, where a branch went. A label is one such observation, and the
  trace of a run is the list of its labels in order. This is the leakage model of
  cryptographic constant-time code (`docs/Leakage.md`). A label can also be an event of the
  environment: an exit, or bytes written out.

  The labelled semantics is the semantics of `Braid.IR.Semantics` with the trace so far
  carried along. Forgetting the trace gives back the unlabelled one (`wpOpsL_erase`,
  `eventuallyL_iff`), so every statement about `Eventually` is a statement about `EventuallyL`.

  A lowering is proved to preserve traces through `Block.wp_of_wpL`: the labels a block emits
  are a function of the state it starts from and of the values its `havoc`s take, and that
  function, `Block.leak`, is what is compared with the labels of the machine instruction.

  ## Main definitions

  * `Label`, `Event`, `Trace`
  * `Op.leak`, `Term.leak`: the labels of one operation and of a terminator
  * `Op.wpL`, `wpOpsL`, `Term.wpL`, `Block.wpL`: weakest preconditions, with the trace
  * `Program.stepL`, `EventuallyL`: one block, and running until a postcondition holds
  * `runOps`, `Block.leak`: the labels of a block, as a function

  ## Main results

  * `wpOpsL_erase`, `Block.wpL_erase`, `eventuallyL_iff`: forgetting the trace
  * `Block.wp_of_wpL`: the trace of a block is `Block.leak`
-/

module

public import Braid.IR.Semantics

@[expose] public section

namespace Braid

/-! ## Labels -/

/-- An event of the environment. -/
inductive Event where
  /-- The program exits with a code. -/
  | exit (code : Word)
  /-- The program writes bytes out. -/
  | write (bytes : List (BitVec 8))
  deriving DecidableEq, Repr, Inhabited

/-- What one step reveals. -/
inductive Label where
  /-- `n` bytes are read at `addr`. The bytes themselves are not revealed. -/
  | read (addr : Word) (n : Nat)
  /-- `n` bytes are written at `addr`. -/
  | write (addr : Word) (n : Nat)
  /-- Control goes to `target`, by a conditional branch or a computed jump. -/
  | jump (target : Word)
  /-- An operation whose time depends on its operands runs on `a` and `b`. -/
  | operands (a b : Word)
  /-- An event of the environment. -/
  | event (e : Event)
  deriving DecidableEq, Repr, Inhabited

/-- The labels of a run, in order. -/
abbrev Trace := List Label

/-- Whether the time an operation takes depends on its operands: the divisions and
remainders, which no instruction set promises to run in constant time. -/
def BinOp.leaks : BinOp → Bool
  | .udiv | .urem | .sdiv | .srem => true
  | .lanes _ op => op.leaks
  | _ => false

/-- The labels of an operation, from the SSA values and the state it runs in. -/
def Op.leak : Op → Env → State → Trace
  | .bin _ op a b, ρ, _ => if op.leaks then [.operands (ρ a) (ρ b)] else []
  | .load _ w a, ρ, _ => [.read (ρ a) w.bytes]
  | .store w a _, ρ, _ => [.write (ρ a) w.bytes]
  | _, _, _ => []

/-- The labels of a terminator: where a conditional branch or a computed jump goes. -/
def Term.leak : Term → Env → Trace
  | .branch c t f, ρ => [.jump (if ρ c ≠ 0#64 then t else f)]
  | .jumpInd a, ρ => [.jump (ρ a)]
  | _, _ => []

@[simp] theorem Op.leak_const (d : Var) (v : Word) (ρ : Env) (σ : State) : (Op.const d v).leak ρ σ = [] := rfl
@[simp] theorem Op.leak_un (d a : Var) (op : UnOp) (ρ : Env) (σ : State) : (Op.un d op a).leak ρ σ = [] := rfl
@[simp] theorem Op.leak_bin (d a b : Var) (op : BinOp) (ρ : Env) (σ : State) :
    (Op.bin d op a b).leak ρ σ = if op.leaks then [.operands (ρ a) (ρ b)] else [] := rfl
@[simp] theorem Op.leak_select (d c a b : Var) (ρ : Env) (σ : State) : (Op.select d c a b).leak ρ σ = [] := rfl
@[simp] theorem Op.leak_get (d : Var) (r : Reg) (ρ : Env) (σ : State) : (Op.get d r).leak ρ σ = [] := rfl
@[simp] theorem Op.leak_set (r : Reg) (a : Var) (ρ : Env) (σ : State) : (Op.set r a).leak ρ σ = [] := rfl
@[simp] theorem Op.leak_getf (d : Var) (f : Flag) (ρ : Env) (σ : State) : (Op.getf d f).leak ρ σ = [] := rfl
@[simp] theorem Op.leak_setf (f : Flag) (a : Var) (ρ : Env) (σ : State) : (Op.setf f a).leak ρ σ = [] := rfl
@[simp] theorem Op.leak_load (d a : Var) (w : Width) (ρ : Env) (σ : State) :
    (Op.load d w a).leak ρ σ = [.read (ρ a) w.bytes] := rfl
@[simp] theorem Op.leak_store (a v : Var) (w : Width) (ρ : Env) (σ : State) :
    (Op.store w a v).leak ρ σ = [.write (ρ a) w.bytes] := rfl
@[simp] theorem Op.leak_havoc (d : Var) (ρ : Env) (σ : State) : (Op.havoc d).leak ρ σ = [] := rfl
@[simp] theorem Op.leak_guard (c : Var) (ρ : Env) (σ : State) : (Op.guard c).leak ρ σ = [] := rfl

@[simp] theorem Term.leak_jump (a : Word) (ρ : Env) : (Term.jump a).leak ρ = [] := rfl
@[simp] theorem Term.leak_branch (c : Var) (t f : Word) (ρ : Env) :
    (Term.branch c t f).leak ρ = [.jump (if ρ c ≠ 0#64 then t else f)] := rfl
@[simp] theorem Term.leak_jumpInd (a : Var) (ρ : Env) :
    (Term.jumpInd a).leak ρ = [.jump (ρ a)] := rfl
@[simp] theorem Term.leak_trap (r : String) (ρ : Env) : (Term.trap r).leak ρ = [] := rfl

/-! ## Weakest preconditions, with the trace -/

/-- The weakest precondition of an operation run after the trace `t`: the postcondition is
of the trace with the labels of the operation added. -/
def Op.wpL (op : Op) (ρ : Env) (σ : State) (t : Trace) (Q : Env → State → Trace → Prop) : Prop :=
  op.wp ρ σ fun ρ' σ' => Q ρ' σ' (t ++ op.leak ρ σ)

/-- The weakest precondition of a list of operations, in order, after the trace `t`. -/
def wpOpsL : List Op → Env → State → Trace → (Env → State → Trace → Prop) → Prop
  | [], ρ, σ, t, Q => Q ρ σ t
  | op :: ops, ρ, σ, t, Q => op.wpL ρ σ t fun ρ' σ' t' => wpOpsL ops ρ' σ' t' Q

/-- The weakest precondition of a terminator after the trace `t`. -/
def Term.wpL (tm : Term) (ρ : Env) (σ : State) (t : Trace) (Q : State → Trace → Prop) : Prop :=
  tm.wp ρ σ fun σ' => Q σ' (t ++ tm.leak ρ)

/-- The weakest precondition of a block after the trace `t`. -/
def Block.wpL (b : Block) (σ : State) (t : Trace) (Q : State → Trace → Prop) : Prop :=
  wpOpsL b.ops (fun _ => 0#64) σ t fun ρ σ' t' => b.term.wpL ρ σ' t' Q

theorem Op.wpL_mono {op : Op} {ρ : Env} {σ : State} {t : Trace}
    {Q Q' : Env → State → Trace → Prop} (h : op.wpL ρ σ t Q)
    (hQ : ∀ ρ σ t, Q ρ σ t → Q' ρ σ t) : op.wpL ρ σ t Q' :=
  Op.wp_mono h fun _ _ h => hQ _ _ _ h

theorem wpOpsL_mono {ops : List Op} {ρ : Env} {σ : State} {t : Trace}
    {Q Q' : Env → State → Trace → Prop} (h : wpOpsL ops ρ σ t Q)
    (hQ : ∀ ρ σ t, Q ρ σ t → Q' ρ σ t) : wpOpsL ops ρ σ t Q' := by
  induction ops generalizing ρ σ t with
  | nil => exact hQ _ _ _ h
  | cons op ops ih => exact Op.wpL_mono h fun _ _ _ h => ih h

theorem Term.wpL_mono {tm : Term} {ρ : Env} {σ : State} {t : Trace} {Q Q' : State → Trace → Prop}
    (h : tm.wpL ρ σ t Q) (hQ : ∀ σ t, Q σ t → Q' σ t) : tm.wpL ρ σ t Q' :=
  Term.wp_mono h fun _ h => hQ _ _ h

theorem Block.wpL_mono {b : Block} {σ : State} {t : Trace} {Q Q' : State → Trace → Prop}
    (h : b.wpL σ t Q) (hQ : ∀ σ t, Q σ t → Q' σ t) : b.wpL σ t Q' :=
  wpOpsL_mono h fun _ _ _ h => Term.wpL_mono h hQ

/-! ## Forgetting the trace -/

/-- A postcondition that ignores the trace gives the unlabelled weakest precondition. -/
theorem wpOpsL_erase {ops : List Op} {ρ : Env} {σ : State} {t : Trace}
    {Q : Env → State → Prop} : wpOpsL ops ρ σ t (fun ρ' σ' _ => Q ρ' σ') ↔ wpOps ops ρ σ Q := by
  induction ops generalizing ρ σ t with
  | nil => rfl
  | cons op ops ih =>
    simp only [wpOpsL, wpOps, Op.wpL]
    exact ⟨fun h => Op.wp_mono h fun _ _ h => ih.1 h, fun h => Op.wp_mono h fun _ _ h => ih.2 h⟩

theorem Block.wpL_erase {b : Block} {σ : State} {t : Trace} {Q : State → Prop} :
    b.wpL σ t (fun σ' _ => Q σ') ↔ b.wp σ Q :=
  wpOpsL_erase (Q := fun ρ σ' => b.term.wp ρ σ' Q)

/-! ## Programs -/

/-- One step of a program after the trace `t`: the block at the program counter runs, and
every outcome, with the trace it leaves, satisfies `Q`. -/
def Program.stepL (P : Program) (σ : State) (t : Trace) (Q : State → Trace → Prop) : Prop :=
  ∃ b, P σ.pc = some b ∧ b.wpL σ t Q

theorem Program.stepL_mono {P : Program} {σ : State} {t : Trace} {Q Q' : State → Trace → Prop}
    (h : P.stepL σ t Q) (hQ : ∀ σ t, Q σ t → Q' σ t) : P.stepL σ t Q' :=
  let ⟨b, hb, h⟩ := h; ⟨b, hb, Block.wpL_mono h hQ⟩

/-- Every run of `P` from the state, after the trace `t`, reaches a state and a trace
satisfying `Q`, without fault. -/
inductive EventuallyL (P : Program) (Q : State → Trace → Prop) : State → Trace → Prop where
  | done (σ : State) (t : Trace) : Q σ t → EventuallyL P Q σ t
  | step (σ : State) (t : Trace) (R : State → Trace → Prop) :
      P.stepL σ t R → (∀ σ' t', R σ' t' → EventuallyL P Q σ' t') → EventuallyL P Q σ t

theorem EventuallyL.trans {P : Program} {Q Q' : State → Trace → Prop} {σ : State} {t : Trace}
    (h : EventuallyL P Q σ t) (hQ : ∀ σ t, Q σ t → EventuallyL P Q' σ t) :
    EventuallyL P Q' σ t := by
  induction h with
  | done σ t h => exact hQ σ t h
  | step σ t R hs _ ih => exact .step σ t R hs ih

theorem EventuallyL.mono {P : Program} {Q Q' : State → Trace → Prop} {σ : State} {t : Trace}
    (h : EventuallyL P Q σ t) (hQ : ∀ σ t, Q σ t → Q' σ t) : EventuallyL P Q' σ t :=
  h.trans fun σ t h => .done σ t (hQ σ t h)

/-- A program with more blocks has every run of the smaller one. -/
theorem EventuallyL.of_le {P P' : Program} {Q : State → Trace → Prop} {σ : State} {t : Trace}
    (h : EventuallyL P Q σ t) (hP : ∀ a b, P a = some b → P' a = some b) :
    EventuallyL P' Q σ t := by
  induction h with
  | done σ t h => exact .done σ t h
  | step σ t R hs _ ih =>
    obtain ⟨b, hb, h⟩ := hs
    exact .step σ t R ⟨b, hP _ _ hb, h⟩ ih

/-- A labelled run is an unlabelled run, of any postcondition its own implies. -/
theorem EventuallyL.erase {P : Program} {Q' : State → Trace → Prop} {Q : State → Prop}
    {σ : State} {t : Trace} (h : EventuallyL P Q' σ t) (hQ : ∀ σ t, Q' σ t → Q σ) :
    Eventually P Q σ := by
  induction h with
  | done σ t h => exact .done σ (hQ σ t h)
  | step σ t R hs _ ih =>
    obtain ⟨b, hb, hw⟩ := hs
    refine .step σ (fun σ' => ∃ t', R σ' t') ⟨b, hb, ?_⟩ fun σ' ⟨t', hr⟩ => ih σ' t' hr
    exact Block.wpL_erase.1 (Block.wpL_mono hw fun σ' t' h => ⟨t', h⟩)

/-- **The unlabelled runs are the labelled runs with the trace forgotten.** -/
theorem eventuallyL_iff {P : Program} {Q : State → Prop} {σ : State} {t : Trace} :
    EventuallyL P (fun σ' _ => Q σ') σ t ↔ Eventually P Q σ := by
  constructor
  · exact fun h => h.erase fun _ _ h => h
  · intro h
    induction h generalizing t with
    | done σ h => exact .done σ t h
    | step σ R hs _ ih =>
      obtain ⟨b, hb, hw⟩ := hs
      exact .step σ t (fun σ' _ => R σ') ⟨b, hb, Block.wpL_erase.2 hw⟩ fun σ' t' hr => ih σ' hr

/-! ## The labels of a block, as a function

The labels of an operation depend on the SSA values it reads, which depend on the state the
block started from and on the values its `havoc`s took. `runOps` runs the operations as a
function, given those values, and collects the labels. -/

/-- The operation as a total function, given the value a `havoc` takes. Where the operation
faults the state is left as it was: a faulting run has no trace to speak of. -/
def Op.next : Op → Env → State → Word → Env × State
  | .const d v, ρ, σ, _ => (ρ.set d v, σ)
  | .un d op a, ρ, σ, _ => (ρ.set d (op.eval (ρ a)), σ)
  | .bin d op a b, ρ, σ, _ => (ρ.set d (op.eval (ρ a) (ρ b)), σ)
  | .select d c a b, ρ, σ, _ => (ρ.set d (if ρ c ≠ 0#64 then ρ a else ρ b), σ)
  | .get d r, ρ, σ, _ => (ρ.set d (σ.regs r), σ)
  | .set r a, ρ, σ, _ => (ρ, σ.setReg r (ρ a))
  | .getf d f, ρ, σ, _ => (ρ.set d (ofBool (σ.flags f)), σ)
  | .setf f a, ρ, σ, _ => (ρ, σ.setFlag f (ρ a != 0#64))
  | .load d w a, ρ, σ, _ => (ρ.set d ((σ.mem.load (ρ a) w).getD 0#64), σ)
  | .store w a v, ρ, σ, _ => (ρ, { σ with mem := (σ.mem.store (ρ a) w (ρ v)).getD σ.mem })
  | .havoc d, ρ, σ, x => (ρ.set d x, σ)
  | .guard _, ρ, σ, _ => (ρ, σ)

@[simp] theorem Op.next_const (d : Var) (v : Word) (ρ : Env) (σ : State) (x : Word) :
    (Op.const d v).next ρ σ x = (ρ.set d v, σ) := rfl
@[simp] theorem Op.next_un (d a : Var) (op : UnOp) (ρ : Env) (σ : State) (x : Word) :
    (Op.un d op a).next ρ σ x = (ρ.set d (op.eval (ρ a)), σ) := rfl
@[simp] theorem Op.next_bin (d a b : Var) (op : BinOp) (ρ : Env) (σ : State) (x : Word) :
    (Op.bin d op a b).next ρ σ x = (ρ.set d (op.eval (ρ a) (ρ b)), σ) := rfl
@[simp] theorem Op.next_select (d c a b : Var) (ρ : Env) (σ : State) (x : Word) :
    (Op.select d c a b).next ρ σ x = (ρ.set d (if ρ c ≠ 0#64 then ρ a else ρ b), σ) := rfl
@[simp] theorem Op.next_get (d : Var) (r : Reg) (ρ : Env) (σ : State) (x : Word) :
    (Op.get d r).next ρ σ x = (ρ.set d (σ.regs r), σ) := rfl
@[simp] theorem Op.next_set (r : Reg) (a : Var) (ρ : Env) (σ : State) (x : Word) :
    (Op.set r a).next ρ σ x = (ρ, σ.setReg r (ρ a)) := rfl
@[simp] theorem Op.next_getf (d : Var) (f : Flag) (ρ : Env) (σ : State) (x : Word) :
    (Op.getf d f).next ρ σ x = (ρ.set d (ofBool (σ.flags f)), σ) := rfl
@[simp] theorem Op.next_setf (f : Flag) (a : Var) (ρ : Env) (σ : State) (x : Word) :
    (Op.setf f a).next ρ σ x = (ρ, σ.setFlag f (ρ a != 0#64)) := rfl
@[simp] theorem Op.next_load (d a : Var) (w : Width) (ρ : Env) (σ : State) (x : Word) :
    (Op.load d w a).next ρ σ x = (ρ.set d ((σ.mem.load (ρ a) w).getD 0#64), σ) := rfl
@[simp] theorem Op.next_store (a v : Var) (w : Width) (ρ : Env) (σ : State) (x : Word) :
    (Op.store w a v).next ρ σ x =
      (ρ, { σ with mem := (σ.mem.store (ρ a) w (ρ v)).getD σ.mem }) := rfl
@[simp] theorem Op.next_havoc (d : Var) (ρ : Env) (σ : State) (x : Word) :
    (Op.havoc d).next ρ σ x = (ρ.set d x, σ) := rfl
@[simp] theorem Op.next_guard (c : Var) (ρ : Env) (σ : State) (x : Word) :
    (Op.guard c).next ρ σ x = (ρ, σ) := rfl

/-- The operations as a function: the SSA values and the state after them, and their labels.
`hv i` is the value the operation at position `i` takes if it is a `havoc`. -/
def runOps : List Op → Env → State → (Nat → Word) → Env × State × Trace
  | [], ρ, σ, _ => (ρ, σ, [])
  | op :: ops, ρ, σ, hv =>
    let r := runOps ops (op.next ρ σ (hv 0)).1 (op.next ρ σ (hv 0)).2 fun i => hv (i + 1)
    (r.1, r.2.1, op.leak ρ σ ++ r.2.2)

/-- The labels of a block run from a state, given the values its `havoc`s take. -/
def Block.leak (b : Block) (σ : State) (hv : Nat → Word) : Trace :=
  (runOps b.ops (fun _ => 0#64) σ hv).2.2 ++ b.term.leak (runOps b.ops (fun _ => 0#64) σ hv).1

@[simp] theorem runOps_nil (ρ : Env) (σ : State) (hv : Nat → Word) :
    runOps [] ρ σ hv = (ρ, σ, []) := rfl

theorem runOps_cons (op : Op) (ops : List Op) (ρ : Env) (σ : State) (hv : Nat → Word) :
    runOps (op :: ops) ρ σ hv =
      ((runOps ops (op.next ρ σ (hv 0)).1 (op.next ρ σ (hv 0)).2 fun i => hv (i + 1)).1,
       (runOps ops (op.next ρ σ (hv 0)).1 (op.next ρ σ (hv 0)).2 fun i => hv (i + 1)).2.1,
       op.leak ρ σ ++
         (runOps ops (op.next ρ σ (hv 0)).1 (op.next ρ σ (hv 0)).2 fun i => hv (i + 1)).2.2) :=
  rfl

theorem runOps_append (ops₁ ops₂ : List Op) (ρ : Env) (σ : State) (hv : Nat → Word) :
    runOps (ops₁ ++ ops₂) ρ σ hv =
      ((runOps ops₂ (runOps ops₁ ρ σ hv).1 (runOps ops₁ ρ σ hv).2.1
          fun i => hv (i + ops₁.length)).1,
       (runOps ops₂ (runOps ops₁ ρ σ hv).1 (runOps ops₁ ρ σ hv).2.1
          fun i => hv (i + ops₁.length)).2.1,
       (runOps ops₁ ρ σ hv).2.2 ++
         (runOps ops₂ (runOps ops₁ ρ σ hv).1 (runOps ops₁ ρ σ hv).2.1
            fun i => hv (i + ops₁.length)).2.2) := by
  induction ops₁ generalizing ρ σ hv with
  | nil => simp
  | cons op ops ih =>
    simp only [List.cons_append, runOps_cons, ih, List.length_cons, List.append_assoc]
    simp only [Nat.add_assoc]

/-- An operation that runs takes the state `Op.next` gives, for the value its `havoc` took. -/
theorem Op.wp_next {op : Op} {ρ : Env} {σ : State} {Q : Env → State → Prop}
    (h : op.wp ρ σ Q) :
    op.wp ρ σ fun ρ' σ' => Q ρ' σ' ∧ ∃ x, (ρ', σ') = op.next ρ σ x := by
  cases op <;> simp only [Op.wp] at h ⊢
  case load =>
    obtain ⟨v, hv, hq⟩ := h
    exact ⟨v, hv, hq, 0#64, by simp only [Op.next, hv, Option.getD_some]⟩
  case store =>
    obtain ⟨m, hm, hq⟩ := h
    exact ⟨m, hm, hq, 0#64, by simp only [Op.next, hm, Option.getD_some]⟩
  case havoc => exact fun v => ⟨h v, v, rfl⟩
  case guard => exact ⟨h.1, h.2, 0#64, rfl⟩
  all_goals exact ⟨h, 0#64, rfl⟩

/-- The trace of a list of operations is the one `runOps` computes, for some values of its
`havoc`s. -/
theorem wpOps_of_wpOpsL {ops : List Op} {ρ : Env} {σ : State} {t : Trace}
    {Q : Env → State → Trace → Prop} (h : wpOpsL ops ρ σ t Q) :
    wpOps ops ρ σ fun ρ' σ' => ∃ hv, ρ' = (runOps ops ρ σ hv).1 ∧
      Q ρ' σ' (t ++ (runOps ops ρ σ hv).2.2) := by
  induction ops generalizing ρ σ t with
  | nil =>
    refine ⟨fun _ => 0#64, rfl, ?_⟩
    simp only [runOps_nil, List.append_nil]
    exact h
  | cons op ops ih =>
    simp only [wpOpsL, Op.wpL] at h
    simp only [wpOps]
    refine Op.wp_mono (Op.wp_next h) ?_
    rintro ρ₁ σ₁ ⟨h₁, x, e⟩
    refine wpOps_mono (ih h₁) ?_
    rintro ρ' σ' ⟨hv, e', hq⟩
    refine ⟨fun i => match i with | 0 => x | i + 1 => hv i, ?_, ?_⟩
    · rw [runOps_cons]
      simp only [← e]
      exact e'
    · rw [runOps_cons]
      simp only [← e, ← List.append_assoc]
      exact hq

/-- **The trace of a block is `Block.leak`.** If a block runs after the trace `t` to a
postcondition of the state and the trace, it runs, without the trace, to states of which the
postcondition holds with `t` and then the labels `Block.leak` computes. -/
theorem Block.wp_of_wpL {b : Block} {σ : State} {t : Trace} {Q : State → Trace → Prop}
    (h : b.wpL σ t Q) : b.wp σ fun σ' => ∃ hv, Q σ' (t ++ b.leak σ hv) := by
  refine wpOps_mono (wpOps_of_wpOpsL h) ?_
  rintro ρ' σ' ⟨hv, e, hq⟩
  refine Term.wp_mono hq fun σ'' hq' => ⟨hv, ?_⟩
  rw [Block.leak, ← List.append_assoc, ← e]
  exact hq'

end Braid
