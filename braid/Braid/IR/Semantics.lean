/-
  Braid.IR.Semantics

  The meaning of the dialect, as predicate transformers in higher-order logic. An operation
  maps a postcondition to the weakest precondition under which it runs without fault and
  establishes it. A fault (an unmapped load, a failed `guard`, a `trap`) has precondition
  `False`. An undefined value (`havoc`) quantifies over every word. A program runs by taking
  the block at the program counter, and `Eventually` is the least set of states from which
  every run reaches the postcondition.

  ## Main definitions

  * `State`: registers, flags, memory and the program counter
  * `Op.wp`, `Term.wp`, `Block.wp`: weakest preconditions
  * `Program.step`, `Eventually`: one block, and running until a postcondition holds
-/

module

public import Braid.IR.Syntax

@[expose] public section

namespace Braid

/-! ## State -/

/-- A mapped byte of memory, and whether it may be written. -/
structure Cell where
  val : BitVec 8
  writable : Bool
  deriving DecidableEq, Repr, Inhabited

/-- Memory: the mapped bytes, by address. -/
abbrev Mem := Word → Option Cell

/-- The machine state a `braid` program runs on. -/
structure State where
  regs : Reg → Word
  flags : Flag → Bool
  mem : Mem
  pc : Word

/-- The values of the SSA variables of the block being run. -/
abbrev Env := Var → Word

/-- The environment with `x` bound to `v`. -/
def Env.set (ρ : Env) (x : Var) (v : Word) : Env :=
  fun y => if y = x then v else ρ y

@[simp] theorem Env.set_same (ρ : Env) (x : Var) (v : Word) : ρ.set x v x = v := by
  simp [Env.set]

@[simp] theorem Env.set_other (ρ : Env) {x y : Var} (v : Word) (h : y ≠ x) :
    ρ.set x v y = ρ y := by
  simp [Env.set, h]

/-- The state with register `r` holding `v`. -/
def State.setReg (σ : State) (r : Reg) (v : Word) : State :=
  { σ with regs := fun r' => if r' = r then v else σ.regs r' }

/-- The state with flag `f` holding `b`. -/
def State.setFlag (σ : State) (f : Flag) (b : Bool) : State :=
  { σ with flags := fun f' => if f' = f then b else σ.flags f' }

/-- The state with the program counter at `a`. -/
def State.setPc (σ : State) (a : Word) : State := { σ with pc := a }

/-! ## Memory -/

/-- The `n` bytes at `a`, little-endian, as a word; `none` if one is unmapped. -/
def Mem.loadN (m : Mem) (a : Word) : Nat → Option Word
  | 0 => some 0
  | n + 1 =>
    match m a, m.loadN (a + 1) n with
    | some c, some r => some ((r <<< 8) ||| c.val.zeroExtend 64)
    | _, _ => none

/-- Memory with the low `n` bytes of `v` written at `a`, little-endian; `none` if a byte is
unmapped or not writable. -/
def Mem.storeN (m : Mem) (a : Word) (v : Word) : Nat → Option Mem
  | 0 => some m
  | n + 1 =>
    match m a with
    | some c =>
      if c.writable then
        Mem.storeN (fun a' => if a' = a then some ⟨v.truncate 8, true⟩ else m a') (a + 1)
          (v >>> 8) n
      else none
    | none => none

/-- A load of width `w` at `a`. -/
def Mem.load (m : Mem) (a : Word) (w : Width) : Option Word := m.loadN a w.bytes

/-- A store of width `w` at `a`. -/
def Mem.store (m : Mem) (a : Word) (w : Width) (v : Word) : Option Mem := m.storeN a v w.bytes

/-! ## Operations -/

/-- `1` if `b`, and `0` otherwise. -/
def ofBool (b : Bool) : Word := if b then 1 else 0

@[simp] theorem ofBool_true : ofBool true = 1 := rfl
@[simp] theorem ofBool_false : ofBool false = 0 := rfl

@[simp] theorem ofBool_ne_zero (b : Bool) : (ofBool b ≠ 0) = (b = true) := by
  cases b <;> simp [ofBool]

@[simp] theorem ofBool_eq_zero (b : Bool) : (ofBool b = 0) = (b = false) := by
  cases b <;> simp [ofBool]

/-- The bytes of a word in reverse order. -/
def bswap (a : Word) : Word :=
  a.extractLsb' 0 8 ++ a.extractLsb' 8 8 ++ a.extractLsb' 16 8 ++ a.extractLsb' 24 8 ++
    a.extractLsb' 32 8 ++ a.extractLsb' 40 8 ++ a.extractLsb' 48 8 ++ a.extractLsb' 56 8

/-- The value of a one-operand operation. -/
def UnOp.eval : UnOp → Word → Word
  | .not, a => ~~~a
  | .neg, a => -a
  | .sext n, a => (a.truncate n).signExtend 64
  | .zext n, a => (a.truncate n).zeroExtend 64
  | .clz, a => a.clz
  | .popcnt, a => a.cpop
  | .rbit, a => a.reverse
  | .bswap, a => Braid.bswap a

/-- The value of a two-operand operation. -/
def BinOp.eval : BinOp → Word → Word → Word
  | .add, a, b => a + b
  | .sub, a, b => a - b
  | .mul, a, b => a * b
  | .mulhu, a, b => ((a.zeroExtend 128 * b.zeroExtend 128) >>> 64).truncate 64
  | .mulhs, a, b => ((a.signExtend 128 * b.signExtend 128) >>> 64).truncate 64
  | .mulhsu, a, b => ((a.signExtend 128 * b.zeroExtend 128) >>> 64).truncate 64
  | .udiv, a, b => a / b
  | .urem, a, b => a % b
  | .sdiv, a, b => a.sdiv b
  | .srem, a, b => a.srem b
  | .and, a, b => a &&& b
  | .or, a, b => a ||| b
  | .xor, a, b => a ^^^ b
  | .shl, a, b => a <<< b
  | .lshr, a, b => a >>> b
  | .ashr, a, b => a.sshiftRight' b
  | .rotr, a, b => a.rotateRight b.toNat
  | .eq, a, b => ofBool (a == b)
  | .ne, a, b => ofBool (a != b)
  | .ult, a, b => ofBool (a.ult b)
  | .ule, a, b => ofBool (a.ule b)
  | .slt, a, b => ofBool (a.slt b)
  | .sle, a, b => ofBool (a.sle b)

/-- The weakest precondition of an operation: it runs without fault from `ρ` and `σ`, and
every outcome satisfies `Q`. -/
def Op.wp (op : Op) (ρ : Env) (σ : State) (Q : Env → State → Prop) : Prop :=
  match op with
  | .const d v => Q (ρ.set d v) σ
  | .un d op a => Q (ρ.set d (op.eval (ρ a))) σ
  | .bin d op a b => Q (ρ.set d (op.eval (ρ a) (ρ b))) σ
  | .select d c a b => Q (ρ.set d (if ρ c ≠ 0 then ρ a else ρ b)) σ
  | .get d r => Q (ρ.set d (σ.regs r)) σ
  | .set r a => Q ρ (σ.setReg r (ρ a))
  | .getf d f => Q (ρ.set d (ofBool (σ.flags f))) σ
  | .setf f a => Q ρ (σ.setFlag f (ρ a != 0))
  | .load d w a => ∃ v, σ.mem.load (ρ a) w = some v ∧ Q (ρ.set d v) σ
  | .store w a v => ∃ m, σ.mem.store (ρ a) w (ρ v) = some m ∧ Q ρ { σ with mem := m }
  | .havoc d => ∀ v, Q (ρ.set d v) σ
  | .guard c => ρ c ≠ 0 ∧ Q ρ σ

/-- The weakest precondition of a list of operations, in order. -/
def wpOps : List Op → Env → State → (Env → State → Prop) → Prop
  | [], ρ, σ, Q => Q ρ σ
  | op :: ops, ρ, σ, Q => op.wp ρ σ fun ρ' σ' => wpOps ops ρ' σ' Q

/-- The weakest precondition of a terminator: where the program counter goes. -/
def Term.wp (t : Term) (ρ : Env) (σ : State) (Q : State → Prop) : Prop :=
  match t with
  | .jump a => Q (σ.setPc a)
  | .branch c t f => Q (σ.setPc (if ρ c ≠ 0 then t else f))
  | .jumpInd a => Q (σ.setPc (ρ a))
  | .trap _ => False

/-- The weakest precondition of a block. Its SSA values start out as zero. -/
def Block.wp (b : Block) (σ : State) (Q : State → Prop) : Prop :=
  wpOps b.ops (fun _ => 0) σ fun ρ σ' => b.term.wp ρ σ' Q

/-! ## Monotonicity -/

theorem Op.wp_mono {op : Op} {ρ : Env} {σ : State} {Q Q' : Env → State → Prop}
    (h : op.wp ρ σ Q) (hQ : ∀ ρ σ, Q ρ σ → Q' ρ σ) : op.wp ρ σ Q' := by
  cases op <;> simp only [Op.wp] at h ⊢
  case load => obtain ⟨v, hv, h⟩ := h; exact ⟨v, hv, hQ _ _ h⟩
  case store => obtain ⟨m, hm, h⟩ := h; exact ⟨m, hm, hQ _ _ h⟩
  case havoc => exact fun v => hQ _ _ (h v)
  case guard => exact ⟨h.1, hQ _ _ h.2⟩
  all_goals exact hQ _ _ h

theorem wpOps_mono {ops : List Op} {ρ : Env} {σ : State} {Q Q' : Env → State → Prop}
    (h : wpOps ops ρ σ Q) (hQ : ∀ ρ σ, Q ρ σ → Q' ρ σ) : wpOps ops ρ σ Q' := by
  induction ops generalizing ρ σ with
  | nil => exact hQ _ _ h
  | cons op ops ih => exact Op.wp_mono h fun _ _ h => ih h

theorem wpOps_append {ops₁ ops₂ : List Op} {ρ : Env} {σ : State} {Q : Env → State → Prop} :
    wpOps (ops₁ ++ ops₂) ρ σ Q ↔ wpOps ops₁ ρ σ fun ρ' σ' => wpOps ops₂ ρ' σ' Q := by
  induction ops₁ generalizing ρ σ with
  | nil => rfl
  | cons op ops ih =>
    simp only [List.cons_append, wpOps]
    constructor <;> intro h <;> exact Op.wp_mono h fun _ _ h => by first | exact ih.1 h | exact ih.2 h

theorem Term.wp_mono {t : Term} {ρ : Env} {σ : State} {Q Q' : State → Prop}
    (h : t.wp ρ σ Q) (hQ : ∀ σ, Q σ → Q' σ) : t.wp ρ σ Q' := by
  cases t <;> simp only [Term.wp] at h ⊢
  all_goals exact hQ _ h

theorem Block.wp_mono {b : Block} {σ : State} {Q Q' : State → Prop}
    (h : b.wp σ Q) (hQ : ∀ σ, Q σ → Q' σ) : b.wp σ Q' :=
  wpOps_mono h fun _ _ h => Term.wp_mono h hQ

/-! ## Programs -/

/-- One step of a program: the block at the program counter runs, and every outcome
satisfies `Q`. -/
def Program.step (P : Program) (σ : State) (Q : State → Prop) : Prop :=
  ∃ b, P σ.pc = some b ∧ b.wp σ Q

theorem Program.step_mono {P : Program} {σ : State} {Q Q' : State → Prop}
    (h : P.step σ Q) (hQ : ∀ σ, Q σ → Q' σ) : P.step σ Q' :=
  let ⟨b, hb, h⟩ := h; ⟨b, hb, Block.wp_mono h hQ⟩

/-- Every run of `P` from the state reaches a state satisfying `Q`, without fault. -/
inductive Eventually (P : Program) (Q : State → Prop) : State → Prop where
  | done (σ : State) : Q σ → Eventually P Q σ
  | step (σ : State) (R : State → Prop) :
      P.step σ R → (∀ σ', R σ' → Eventually P Q σ') → Eventually P Q σ

theorem Eventually.step' {P : Program} {Q : State → Prop} {σ : State}
    (h : P.step σ (Eventually P Q)) : Eventually P Q σ :=
  .step σ _ h fun _ => id

theorem Eventually.trans {P : Program} {Q Q' : State → Prop} {σ : State}
    (h : Eventually P Q σ) (hQ : ∀ σ, Q σ → Eventually P Q' σ) : Eventually P Q' σ := by
  induction h with
  | done σ h => exact hQ σ h
  | step σ R hs _ ih => exact .step σ R hs ih

theorem Eventually.mono {P : Program} {Q Q' : State → Prop} {σ : State}
    (h : Eventually P Q σ) (hQ : ∀ σ, Q σ → Q' σ) : Eventually P Q' σ :=
  h.trans fun σ h => .done σ (hQ σ h)

/-- A program with more blocks has every run of the smaller one. -/
theorem Eventually.of_le {P P' : Program} {Q : State → Prop} {σ : State}
    (h : Eventually P Q σ) (hP : ∀ a b, P a = some b → P' a = some b) : Eventually P' Q σ := by
  induction h with
  | done σ h => exact .done σ h
  | step σ R hs _ ih =>
    obtain ⟨b, hb, h⟩ := hs
    exact .step σ R ⟨b, hP _ _ hb, h⟩ ih

end Braid
