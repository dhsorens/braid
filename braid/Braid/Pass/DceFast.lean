/-
  Braid.Pass.DceFast

  `Block.dce` again, in a form the kernel evaluates in linear time. `dceOps` keeps the live
  values as a list, built by appending and filtering. The kernel evaluates by need and does
  not share what it has evaluated, so on a long block each question about the list goes back
  down the whole chain of filters, and removing the dead operations of a block of `n`
  operations takes time quadratic in `n`. Here the live values are the bits of a natural
  number. The kernel computes on natural numbers with machine arithmetic, and `forceNat`
  makes it compute the number at every step, so each step is constant work.

  ## Main definitions

  * `dceOpsM`, `Block.dceFast`: removal of dead operations, with the live set as a number

  ## Main results

  * `Block.dceFast_eq`: it is `Block.dce`
-/

module

public import Braid.Pass.Dce

@[expose] public section

namespace Braid

/-- Evaluate a number before going on. In the kernel, the match makes the number a literal,
so what follows does not carry an unevaluated term. -/
def forceNat {α : Type} (n : Nat) (k : Nat → α) : α :=
  match n with
  | 0 => k 0
  | m + 1 => k (m + 1)

theorem forceNat_eq {α : Type} (n : Nat) (k : Nat → α) : forceNat n k = k n := by
  cases n <;> rfl

/-- The set with `x` in it. -/
def setBit (m : Nat) (x : Var) : Nat := m ||| (1 <<< x)

/-- The set without `d`. -/
def clearBit (m : Nat) (d : Var) : Nat := m ^^^ (m &&& (1 <<< d))

/-- The set with each of `xs` in it. -/
def setBits (m : Nat) (xs : List Var) : Nat := xs.foldl setBit m

/-- The number `m` is the set of the values in the list `l`. -/
def RepLive (m : Nat) (l : List Var) : Prop := ∀ x, m.testBit x = l.contains x

theorem testBit_one_shiftLeft (d x : Nat) : (1 <<< d).testBit x = decide (d = x) := by
  rw [Nat.one_shiftLeft, Nat.testBit_two_pow]

theorem RepLive.setBit {m : Nat} {l : List Var} (h : RepLive m l) (x : Var) :
    RepLive (setBit m x) (x :: l) := by
  intro y
  simp only [Braid.setBit, Nat.testBit_or, h y, testBit_one_shiftLeft, List.contains_cons]
  rw [Bool.or_comm]
  congr 1
  by_cases e : x = y
  · subst e; simp
  · have e' : ¬ y = x := fun h => e h.symm
    simp [e, e']

theorem contains_filter_ne (l : List Var) (d y : Var) :
    (l.filter (· ≠ d)).contains y = (l.contains y && !decide (d = y)) := by
  rw [Bool.eq_iff_iff]
  simp only [List.contains_iff_mem, List.mem_filter, Bool.and_eq_true, Bool.not_eq_true',
    decide_eq_false_iff_not, ne_eq, decide_not]
  exact ⟨fun h => ⟨h.1, fun e => h.2 e.symm⟩, fun h => ⟨h.1, fun e => h.2 e.symm⟩⟩

theorem RepLive.clearBit {m : Nat} {l : List Var} (h : RepLive m l) (d : Var) :
    RepLive (clearBit m d) (l.filter (· ≠ d)) := by
  intro y
  simp only [Braid.clearBit, Nat.testBit_xor, Nat.testBit_and, h y, testBit_one_shiftLeft,
    contains_filter_ne]
  cases l.contains y <;> cases decide (d = y) <;> rfl

theorem RepLive.congr {m : Nat} {l l' : List Var} (h : RepLive m l)
    (hl : ∀ x, l.contains x = l'.contains x) : RepLive m l' :=
  fun x => (h x).trans (hl x)

theorem RepLive.setBits {m : Nat} {l : List Var} (h : RepLive m l) (xs : List Var) :
    RepLive (setBits m xs) (xs ++ l) := by
  induction xs generalizing m l with
  | nil => exact h
  | cons x xs ih =>
    refine (ih (h.setBit x)).congr fun y => ?_
    rw [Bool.eq_iff_iff]
    simp only [List.contains_iff_mem, List.mem_append, List.mem_cons]
    constructor
    · rintro (h | h | h)
      · exact .inl (.inr h)
      · exact .inl (.inl h)
      · exact .inr h
    · rintro ((h | h) | h)
      · exact .inr (.inl h)
      · exact .inl h
      · exact .inr (.inr h)

/-- `Op.liveIn`, on sets as numbers. -/
def Op.liveInM (op : Op) (m : Nat) : Nat :=
  setBits (match op.defs with
    | some d => clearBit m d
    | none => m) op.uses

theorem RepLive.liveIn {m : Nat} {l : List Var} (h : RepLive m l) (op : Op) :
    RepLive (op.liveInM m) (op.liveIn l) := by
  simp only [Op.liveInM, Op.liveIn]
  cases op.defs with
  | none => exact h.setBits _
  | some d => exact (h.clearBit d).setBits _

/-- `dceOps`, with the live set as a number, evaluated at each step. -/
def dceOpsM : List Op → Nat → List Op × Nat
  | [], m => ([], m)
  | op :: ops, m =>
    match dceOpsM ops m with
    | (ops', m') =>
      match op.defs with
      | some d =>
        if op.removable && !m'.testBit d then (ops', m')
        else forceNat (op.liveInM m') fun m₁ => (op :: ops', m₁)
      | none => forceNat (op.liveInM m') fun m₁ => (op :: ops', m₁)

theorem dceOpsM_eq {m : Nat} {l : List Var} (h : RepLive m l) (ops : List Op) :
    (dceOpsM ops m).1 = (dceOps ops l).1 ∧ RepLive (dceOpsM ops m).2 (dceOps ops l).2 := by
  induction ops with
  | nil => exact ⟨rfl, h⟩
  | cons op ops ih =>
    obtain ⟨e, hr⟩ := ih
    simp only [dceOpsM, dceOps, forceNat_eq]
    cases hd : op.defs with
    | none => exact ⟨by simp only [e], hr.liveIn op⟩
    | some d =>
      simp only [hr d]
      split
      · exact ⟨e, hr⟩
      · exact ⟨by simp only [e], hr.liveIn op⟩

/-- The block without the operations whose results are never used: `Block.dce`, computed with
the live set as a number. -/
def Block.dceFast (b : Block) : Block := ⟨(dceOpsM b.ops (setBits 0 b.term.uses)).1, b.term⟩

theorem Block.dceFast_eq (b : Block) : b.dceFast = b.dce := by
  have h0 : RepLive 0 [] := fun x => by simp
  have h : RepLive (setBits 0 b.term.uses) b.term.uses :=
    (h0.setBits b.term.uses).congr fun x => by simp
  simp only [Block.dceFast, Block.dce, (dceOpsM_eq h b.ops).1]

end Braid
