/-
  Braid.BV

  Tactics for goals about bit vectors whose proofs the kernel checks, in place of
  `bv_decide`. `bv_decide` hands a goal to a SAT solver and admits the solver's certificate
  through an axiom that trusts compiled code (`docs/Trust.md`); the tactics here build
  ordinary proofs.

  `bv_auto` is the one to call. It first drops the hypotheses that are not about bit
  vectors, Booleans and numbers, and puts the rest in a normal form: `setWidth` for every
  change of width, shifts by numbers, `setWidth` pushed through the operations it
  commutes with. Then it tries, in order:

  * `bv_ac`, for two sides that differ by the order of an associative operation;
  * `bv_arith`: comparisons, overflow and masks as arithmetic on `toNat`, then `omega`;
  * `bv_bits`: the goal bit by bit, each index a literal, each bit a Boolean formula in the
    bits of the variables, decided;
  * case splits on the conditions of `if`s and on Boolean comparisons, and on the values of a
    variable a hypothesis bounds by a small constant, then the above on each case;
  * a contradiction with a hypothesis `¬ a = b`.

  ## Main definitions

  * `bv_auto`: close a goal about bit vectors
  * `bv_arith`, `bv_bits`: the arithmetic and the bitwise procedure on their own
  * `bv_clear`, `bv_norm`: the preparation
-/

module

public meta import Lean.Elab.Tactic

@[expose] public section

namespace Braid.BV

/-- `∀ i < n + 1` is the case `0` and `∀ i < n` shifted by one. -/
theorem bits_split {P : Nat → Prop} {n : Nat} (h0 : P 0) (hs : ∀ i < n, P (i + 1)) :
    ∀ i < n + 1, P i := by
  intro i hi; cases i with
  | zero => exact h0
  | succ i => exact hs i (by omega)

theorem bits_zero {P : Nat → Prop} : ∀ i < 0, P i := fun _ h => absurd h (Nat.not_lt_zero _)

/-- Two bit vectors are equal if their bits are. -/
theorem eq_of_bits {n : Nat} {x y : BitVec n} (h : ∀ i < n, x.getLsbD i = y.getLsbD i) :
    x = y :=
  BitVec.eq_of_getLsbD_eq (fun i hi => h i hi)

/-- An equation between bit vectors, bit by bit. -/
theorem bits_of_eq {n : Nat} {x y : BitVec n} (h : x = y) :
    ∀ i < n, x.getLsbD i = y.getLsbD i := fun _ _ => h ▸ rfl

theorem extractLsb'_zero_eq {w n : Nat} (x : BitVec w) :
    BitVec.extractLsb' 0 n x = BitVec.setWidth n x := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp [hi]

theorem setWidth_sub_of_le {w i : Nat} (x y : BitVec w) (h : i ≤ w) :
    BitVec.setWidth i (x - y) = BitVec.setWidth i x - BitVec.setWidth i y := by
  rw [BitVec.sub_eq_add_neg, BitVec.setWidth_add _ _ h, BitVec.setWidth_neg_of_le h,
    ← BitVec.sub_eq_add_neg]

/-- A sign extension is zero exactly when what it extends is. -/
theorem signExtend_eq_zero_iff {v w : Nat} (x : BitVec v) (h : v ≤ w) :
    x.signExtend w = 0#w ↔ x = 0#v := by
  constructor
  · intro e
    apply BitVec.eq_of_getLsbD_eq; intro i hi
    have := congrArg (·.getLsbD i) e
    simp only [BitVec.getLsbD_signExtend, BitVec.getLsbD_zero] at this ⊢
    simp only [show i < w by omega, hi, decide_true, Bool.true_and, ite_true] at this
    exact this
  · rintro rfl; apply BitVec.eq_of_getLsbD_eq; intro i hi
    simp [BitVec.getLsbD_signExtend, BitVec.msb_zero]

/-- A product with a power of two is a shift. -/
theorem mul_pow2 {w : Nat} (x : BitVec w) (k c : Nat) (h : c = 2 ^ k) :
    x * BitVec.ofNat w c = x <<< k := by
  rw [BitVec.shiftLeft_eq_mul_twoPow]; congr 1
  apply BitVec.eq_of_toNat_eq; simp [BitVec.toNat_twoPow, h]

/-! The left commutativity of the associative and commutative operations, with which `simp`
puts a term of them in order. -/

theorem add_left_comm {w : Nat} (a b c : BitVec w) : a + (b + c) = b + (a + c) := by
  rw [← BitVec.add_assoc, BitVec.add_comm a b, BitVec.add_assoc]

theorem mul_left_comm {w : Nat} (a b c : BitVec w) : a * (b * c) = b * (a * c) := by
  rw [← BitVec.mul_assoc, BitVec.mul_comm a b, BitVec.mul_assoc]

theorem and_left_comm {w : Nat} (a b c : BitVec w) : a &&& (b &&& c) = b &&& (a &&& c) := by
  rw [← BitVec.and_assoc, BitVec.and_comm a b, BitVec.and_assoc]

theorem or_left_comm {w : Nat} (a b c : BitVec w) : a ||| (b ||| c) = b ||| (a ||| c) := by
  rw [← BitVec.or_assoc, BitVec.or_comm a b, BitVec.or_assoc]

theorem xor_left_comm {w : Nat} (a b c : BitVec w) : a ^^^ (b ^^^ c) = b ^^^ (a ^^^ c) := by
  rw [← BitVec.xor_assoc, BitVec.xor_comm a b, BitVec.xor_assoc]

/-- A bit of a choice is the bit of the side chosen. -/
theorem getLsbD_ite {w : Nat} (c : Prop) [Decidable c] (a b : BitVec w) (i : Nat) :
    (if c then a else b).getLsbD i = if c then a.getLsbD i else b.getLsbD i := by
  split <;> rfl

/-- No bit vector is below zero. -/
theorem ult_zero {w : Nat} (x : BitVec w) : x.ult 0#w = false := by
  simp [BitVec.ult_eq_decide]

/-- Two bit vectors with no bit in common: their disjunction is their sum. -/
theorem or_eq_add {w : Nat} (x y : BitVec w) (h : x &&& y = 0#w) : x ||| y = x + y :=
  (BitVec.add_eq_or_of_and_eq_zero x y h).symm

/-- Sign-extending and cutting back to the width one started from gives back the start. -/
theorem setWidth_signExtend_self {w m : Nat} (y : BitVec m) (h : m ≤ w) :
    (y.signExtend w).setWidth m = y := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp [BitVec.getLsbD_signExtend, hi]; intro; omega

/-- Widening, shifting right and cutting back is shifting right in the narrow width. -/
theorem setWidth_ushr_setWidth {w m : Nat} (z : BitVec m) (k : Nat) (h : m ≤ w) :
    (z.setWidth w >>> k).setWidth m = z >>> k := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp [BitVec.getLsbD_ushiftRight, hi]
  intro hz
  have := BitVec.lt_of_getLsbD hz
  omega

/-- A rotation by less than the width is a disjunction of two shifts. -/
theorem rotateLeft_eq_or {w : Nat} (x : BitVec w) (k : Nat) (h : k < w) :
    x.rotateLeft k = x <<< k ||| x >>> (w - k) := by
  rw [BitVec.rotateLeft_def, Nat.mod_eq_of_lt h]

/-- Two shifts of one bit vector, by amounts that add up to its width, are a rotation. -/
theorem or_shifts_eq_rotateLeft {w : Nat} (x : BitVec w) (k j : Nat) (h : k + j = w)
    (hk : k < w) : x <<< k ||| x >>> j = x.rotateLeft k := by
  rw [rotateLeft_eq_or x k hk]; congr; omega

theorem uaddOverflow_eq_decide {w : Nat} (x y : BitVec w) :
    x.uaddOverflow y = decide (2 ^ w ≤ x.toNat + y.toNat) := rfl

theorem and_mask_nat (x k c : Nat) (h : c = 2 ^ k - 1) : x &&& c = x % (c + 1) := by
  subst h
  rw [Nat.and_two_pow_sub_one_eq_mod, Nat.sub_add_cancel (Nat.one_le_two_pow)]

end Braid.BV

end

public meta section

open Lean Elab Tactic Meta

namespace Braid.BV

/-- The subterms that are one bit of a bit vector: `x.getLsbD k` and `x.msb`. -/
partial def collectBits (e : Expr) (acc : Array Expr) : MetaM (Array Expr) := do
  let acc ← if e.isAppOfArity ``BitVec.getLsbD 3 || e.isAppOfArity ``BitVec.msb 2 then
      if acc.contains e then pure acc else pure (acc.push e)
    else pure acc
  match e with
  | .app f a => collectBits a (← collectBits f acc)
  | .mdata _ b => collectBits b acc
  | _ => pure acc

/-- The literal indices `k` of the bits `x.getLsbD k` in `e`. -/
partial def collectIndices (e : Expr) (acc : Array Nat) : MetaM (Array Nat) := do
  let acc ← if e.isAppOfArity ``BitVec.getLsbD 3 then
      match ← evalNat (e.getArg! 2) |>.run with
      | some k => pure (if acc.contains k then acc else acc.push k)
      | none => pure acc
    else pure acc
  match e with
  | .app f a => collectIndices a (← collectIndices f acc)
  | .mdata _ b => collectIndices b acc
  | _ => pure acc

/-- Constants a goal about bit vectors is made of. A hypothesis made of anything else is
dropped by `bv_clear`, unless what else it mentions is in the goal too. -/
def known (n : Name) : Bool :=
  let ns := [`BitVec, `Bool, `Nat, `Int, `Fin, `Eq, `Ne, `Not, `And, `Or, `Iff, `True, `False,
    `ite, `dite, `decide, `Decidable, `LT, `LE, `GT, `GE, `HAdd, `HSub, `HMul, `HDiv, `HMod,
    `HPow, `HAnd, `HOr, `HXor, `HShiftLeft, `HShiftRight, `HAppend, `Complement, `Neg, `OfNat,
    `BEq, `bne, `instBEqOfDecidableEq, `Add, `Sub, `Mul, `Div, `Mod, `Pow, `AndOp, `OrOp,
    `Xor, `ShiftLeft, `ShiftRight, `Max, `Min, `Exists, `outParam, `id, `instDecidableEqBool,
    `instDecidableEqNat, `Std.PreorderPackage, `Std.LinearPreorderPackage,
    `Std.LinearOrderPackage, `LawfulBEq, `ReflBEq]
  ns.any (fun p => p.isPrefixOf n) || (n.toString.splitOn "inst").head? == some ""

/-- Whether `sub` occurs in `e`. -/
def occursIn (e sub : Expr) : Bool :=
  (e.find? (· == sub)).isSome

/-- Whether `e` is made of known constants and of the subterms of `goal`. -/
partial def isPlain (goal : Expr) (e : Expr) : MetaM Bool := do
  if e.isFVar || e.isBVar || e.isSort || e.isLit then return true
  if !e.hasLooseBVars && occursIn goal e then return true
  match e with
  | .const n _ =>
    if known n then return true
    -- a type abbreviation such as `Word`
    let some ci := (← getEnv).find? n | return false
    return ci.type.getForallBody.isSort
  | .app f a => return (← isPlain goal f) && (← isPlain goal a)
  | .forallE _ d b _ => return (← isPlain goal d) && (← isPlain goal b)
  | .lam _ d b _ => return (← isPlain goal d) && (← isPlain goal b)
  | .mdata _ b => isPlain goal b
  | .letE _ t v b _ => return (← isPlain goal t) && (← isPlain goal v) && (← isPlain goal b)
  | .proj _ _ b => isPlain goal b
  | _ => return false

/-- The largest subterms of `e` that are bit vectors built by something other than the
operations on bit vectors, such as a register of a machine state. -/
partial def foreignAtoms (e : Expr) (acc : Array Expr) : MetaM (Array Expr) := do
  if e.hasLooseBVars || e.isFVar || e.isMVar then
    match e with
    | .app f a => return ← foreignAtoms a (← foreignAtoms f acc)
    | .mdata _ b => return ← foreignAtoms b acc
    | .forallE _ d b _ | .lam _ d b _ => return ← foreignAtoms b (← foreignAtoms d acc)
    | _ => return acc
  if let some n := e.getAppFn.constName? then
    if !known n && e.isApp then
      let ty ← whnfR (← inferType e)
      if ty.isAppOfArity ``BitVec 1 then
        return if acc.contains e then acc else acc.push e
  match e with
  | .app f a => foreignAtoms a (← foreignAtoms f acc)
  | .mdata _ b => foreignAtoms b acc
  | .forallE _ d b _ | .lam _ d b _ => foreignAtoms b (← foreignAtoms d acc)
  | _ => pure acc

/-- Each bit vector built by something other than the operations on bit vectors, in the goal
or in a hypothesis about bit vectors, made a variable. -/
elab "bv_atoms" : tactic => do
  let g ← getMainGoal
  g.withContext do
  let mut atoms ← foreignAtoms (← instantiateMVars (← g.getType)) #[]
  let mut hyps : Array FVarId := #[]
  for d in (← getLCtx) do
    if d.isImplementationDetail then continue
    let ty ← instantiateMVars d.type
    if !(← isProp ty) then continue
    let as ← foreignAtoms ty #[]
    if as.isEmpty then continue
    hyps := hyps.push d.fvarId
    for a in as do
      if !atoms.contains a then atoms := atoms.push a
  if atoms.isEmpty then return
  let (ns, g) ← g.revert hyps (preserveOrder := true)
  let (_, g) ← g.generalize (atoms.map fun a => { expr := a })
  let (_, g) ← g.introNP ns.size
  replaceMainGoal [g]

/-- Drop every hypothesis that is not a statement about bit vectors, Booleans and numbers.
What a hypothesis mentions beyond those may be kept only if it is in the goal too. -/
elab "bv_clear" : tactic => do
  let g ← getMainGoal
  g.withContext do
    let goal ← instantiateMVars (← g.getType)
    let mut drop : Array FVarId := #[]
    for d in (← getLCtx) do
      if d.isImplementationDetail then continue
      let ty ← instantiateMVars d.type
      if !(← isProp ty) then continue
      if !(← isPlain goal ty) then drop := drop.push d.fvarId
    let mut g := g
    for fv in drop.reverse do
      g ← g.tryClear fv
    replaceMainGoal [g]

/-- Clear every hypothesis that shares no variable with the goal, nor with a hypothesis kept,
and so on: it cannot help. A goal with no variable, such as `False`, keeps them all. -/
elab "bv_relevant" : tactic => do
  let g ← getMainGoal
  g.withContext do
  let t ← instantiateMVars (← g.getType)
  let mut vars : Array FVarId := (collectFVars {} t).fvarIds
  if vars.isEmpty then return
  let mut cands : Array (FVarId × Array FVarId) := #[]
  for d in (← getLCtx) do
    if d.isImplementationDetail then continue
    let ty ← instantiateMVars d.type
    unless (← isProp ty) do continue
    cands := cands.push (d.fvarId, (collectFVars {} ty).fvarIds)
  let mut keep : Array FVarId := #[]
  let mut changed := true
  while changed do
    changed := false
    for (fv, vs) in cands do
      if keep.contains fv then continue
      if vs.any (vars.contains ·) then
        keep := keep.push fv
        changed := true
        for v in vs do
          if !vars.contains v then vars := vars.push v
  let mut g := g
  for (fv, _) in cands.reverse do
    unless keep.contains fv do g ← g.tryClear fv
  replaceMainGoal [g]

/-- The goal is a Boolean formula in bits of bit vectors: generalize each bit, together with
the hypotheses about those bits (and about the bits those mention, and so on), and decide.
A hypothesis whose bits meet none of the goal's cannot help, and is left out. -/
elab "bv_bool_decide" : tactic => do
  let g ← getMainGoal
  g.withContext do
  let t ← instantiateMVars (← g.getType)
  let mut atoms := (← collectBits t #[]).filter (fun a => !a.hasLooseBVars)
  let mut cands : Array (FVarId × Array Expr) := #[]
  for d in (← getLCtx) do
    if d.isImplementationDetail then continue
    let ty ← instantiateMVars d.type
    if (← isProp ty) && !ty.isForall then
      let as := (← collectBits ty #[]).filter (fun a => !a.hasLooseBVars)
      if !as.isEmpty then cands := cands.push (d.fvarId, as)
  let mut hyps : Array FVarId := #[]
  let mut changed := true
  while changed do
    changed := false
    for (fv, as) in cands do
      if hyps.contains fv then continue
      if as.any (atoms.contains ·) then
        hyps := hyps.push fv
        changed := true
        for a in as do
          if !atoms.contains a then atoms := atoms.push a
  let ordered := (← getLCtx).foldl (init := #[]) fun acc d =>
    if hyps.contains d.fvarId then acc.push d.fvarId else acc
  let (_, g) ← g.revert ordered
  let (fvs, g) ← g.generalize (atoms.map fun a => { expr := a })
  let (_, g) ← g.revert fvs
  replaceMainGoal [g]
  evalTactic (← `(tactic| decide))

/-- Hypotheses `∀ i < n, …` (an equation between bit vectors, bit by bit) taken at the
literal indices of the bits in the goal, or at every index if `n` is at most 16. -/
elab "bv_inst_bits" : tactic => do
  let g ← getMainGoal
  g.withContext do
  let t ← instantiateMVars (← g.getType)
  let ks ← collectIndices t #[]
  let mut g := g
  for d in (← getLCtx) do
    if d.isImplementationDetail then continue
    let ty ← instantiateMVars d.type
    let .forallE _ (.const ``Nat []) b _ := ty | continue
    let .forallE _ lt _ _ := b | continue
    unless lt.isAppOfArity ``LT.lt 4 do continue
    let some n ← (evalNat (lt.getArg! 3)).run | continue
    -- a narrow hypothesis at every index: a bit of the goal may follow from another of its
    let ks := if n ≤ 16 then (List.range n).toArray else ks
    for k in ks do
      unless k < n do continue
      let pf ← mkDecideProof (← mkLt (mkNatLit k) (lt.getArg! 3))
      let v := mkApp2 (mkFVar d.fvarId) (mkNatLit k) pf
      let (_, g') ← (← g.assert `hbit (← inferType v) v).intro1P
      g := g'
  replaceMainGoal [g]

/-- `∀ i < n, P i`, `n` a literal: one goal `P k` for each `k < n`. -/
elab "bv_index_split" : tactic => do
  let mut done : Array MVarId := #[]
  let mut g ← getMainGoal
  repeat
    let gs ← try g.apply (mkConst ``Braid.BV.bits_zero)
      catch _ => g.apply (← mkConstWithFreshMVarLevels ``Braid.BV.bits_split)
    match gs with
    | [] => break
    | [h0, hs] => done := done.push h0; g := hs
    | _ => throwError "bv_index_split: unexpected goals"
  replaceMainGoal done.toList

/-- Replace each hypothesis `x = y` between bit vectors by its bits. -/
elab "bv_hyp_bits" : tactic => do
  let g ← getMainGoal
  g.withContext do
  let mut g := g
  for d in (← getLCtx) do
    if d.isImplementationDetail then continue
    let ty ← whnfR (← instantiateMVars d.type)
    let some (α, _, _) := ty.eq? | continue
    let α ← whnfR α
    unless α.isAppOfArity ``BitVec 1 do continue
    let v ← mkAppM ``Braid.BV.bits_of_eq #[mkFVar d.fvarId]
    let (_, g') ← (← g.assert d.userName (← inferType v) v).intro1P
    g := g'
  replaceMainGoal [g]

/-- `x &&& c` for a literal `c` one less than a power of two is `x % (c + 1)`. -/
simproc reduceAndMask ((_ : Nat) &&& _) := fun e => do
  let_expr HAnd.hAnd _ _ _ _ x c := e | return .continue
  let some n := c.nat? | return .continue
  if n == 0 || (n + 1) &&& n != 0 then return .continue
  let k := (n + 1).log2
  let pf := mkApp4 (mkConst ``Braid.BV.and_mask_nat) x (mkNatLit k) (mkNatLit n)
    (← mkEqRefl (mkNatLit n))
  return .done { expr := ← mkAppM ``HMod.hMod #[x, mkNatLit (n + 1)], proof? := some pf }

/-- `x * c` for a literal `c` that is a power of two is a shift. -/
simproc reduceMulPow2 ((_ : BitVec _) * _) := fun e => do
  let_expr HMul.hMul _ _ _ _ x c := e | return .continue
  let some ⟨w, cv⟩ ← getBitVecValue? c | return .continue
  let n := cv.toNat
  if n < 2 || n &&& (n - 1) != 0 then return .continue
  let k := n.log2
  let pf := mkApp5 (mkConst ``Braid.BV.mul_pow2) (toExpr w) x (mkNatLit k) (mkNatLit n)
    (← mkEqRefl (mkNatLit n))
  return .done { expr := ← mkAppM ``HShiftLeft.hShiftLeft #[x, mkNatLit k], proof? := some pf }

/-- `Nat.testBit` of two literals. -/
dsimproc reduceTestBit (Nat.testBit _ _) := fun e => do
  let_expr Nat.testBit m i := e | return .continue
  let some m := m.nat? | return .continue
  let some i := i.nat? | return .continue
  return .done (toExpr (m.testBit i))

/-- `i < c` for a variable `i` and a small literal `c`: one goal for each value of `i`. -/
elab "bv_enum" : tactic => do
  let g ← getMainGoal
  g.withContext do
  for d in (← getLCtx) do
    if d.isImplementationDetail then continue
    let ty ← instantiateMVars d.type
    -- `i < c#w` between bit vectors
    let_expr LT.lt α _ i c := ty | continue
    unless i.isFVar do continue
    let α ← whnfR α
    let_expr BitVec w := α | continue
    let some cv ← getBitVecValue? c | continue
    let n := cv.2.toNat
    unless 0 < n && n ≤ 16 do continue
    let some wv ← evalNat w |>.run | continue
    let iId := mkIdent (← i.fvarId!.getUserName)
    let disj ← (List.range n).foldrM (init := none) fun k acc => do
      let lit ← `(($(quote k) : BitVec $(quote wv)))
      let eq ← `($iId = $lit)
      match acc with
      | none => pure (some eq)
      | some r => pure (some (← `($eq ∨ $r)))
    let some disj := disj | continue
    let pats ← (List.range n).mapM fun _ => `(rcasesPat| rfl)
    evalTactic (← `(tactic|
      (rcases (show $disj by bv_omega) with $[$(pats.toArray)]|*) <;> subst_vars))
    return
  throwError "bv_enum: no variable bounded by a small literal"

/-- Run `tac`, turning a runtime failure (a recursion or heartbeat limit) into an ordinary
one, so that `first` goes on to the next alternative. -/
elab "bv_guard " tac:tactic : tactic => do
  let s ← saveState
  -- without recovery: a step that fails inside fails the whole, and is not admitted
  tryCatchRuntimeEx (withoutRecover (evalTactic tac)) fun e => do
    s.restore
    throwError "bv_guard: {e.toMessageData}"

/-- A Boolean `b`, not a variable, under `BitVec.ofBool`: one goal for each value of it. -/
elab "bv_bool_cases" : tactic => do
  let g ← getMainGoal
  g.withContext do
  let t ← instantiateMVars (← g.getType)
  let some e := t.find? (fun e => e.isAppOfArity ``BitVec.ofBool 1 &&
      !(e.getArg! 0).isFVar && !(e.getArg! 0).hasLooseBVars && (e.getArg! 0).constName?.isNone)
    | throwError "bv_bool_cases: no Boolean to split"
  let stx ← Term.exprToSyntax (e.getArg! 0)
  evalTactic (← `(tactic| (cases _h : $stx <;>
    simp only [BitVec.ofBool_true, BitVec.ofBool_false] at *)))

/-- An equation between two applications of the same operation that differ in one operand
only, peeled down to that operand, as far as it goes. -/
elab "bv_peel" : tactic => do
  let mut peeled := false
  for _ in [0:64] do
    let g ← getMainGoal
    -- the goal may come wrapped in annotations
    let t := (← instantiateMVars (← g.getType)).cleanupAnnotations
    let some (_, l, r) := t.eq? | break
    let fl := l.getAppFn
    unless fl.isConst && fl == r.getAppFn && l.getAppNumArgs == r.getAppNumArgs do break
    let (la, ra) := (l.getAppArgs, r.getAppArgs)
    -- the operands that differ, up to unfolding reducible definitions only
    let idx ← (List.range la.size).filterM fun i => do
      if la[i]! == ra[i]! then pure false
      else return !(← withReducible (isDefEq la[i]! ra[i]!))
    let [i] := idx | break
    let (a, b) := (la[i]!, ra[i]!)
    let α ← inferType a
    unless (← whnfR α).isAppOfArity ``BitVec 1 do break
    -- `l = r` from `a = b`, by `congrArg` on `l` with its `i`-th operand abstracted
    let f ← withLocalDeclD `x α fun x =>
      mkLambdaFVars #[x] (mkAppN fl (la.set! i x))
    let h ← mkFreshExprSyntheticOpaqueMVar (← mkEq a b)
    g.assign (← mkCongrArg f h)
    replaceMainGoal [h.mvarId!]
    peeled := true
  unless peeled do throwError "bv_peel: the two sides do not differ in one operand"

/-- Run `tac` with at most `n` thousand heartbeats more than spent so far, and never more
than the limit already in force: an attempt that fails leaves the rest of the budget to the
attempts after it. -/
elab "bv_budget " n:num tac:tactic : tactic => do
  let ctx ← readThe Core.Context
  let used := (← IO.getNumHeartbeats) - ctx.initHeartbeats
  let mut lim := used + n.getNat * 1000
  if ctx.maxHeartbeats != 0 && ctx.maxHeartbeats < lim then lim := ctx.maxHeartbeats
  let s ← saveState
  tryCatchRuntimeEx
    (withTheReader Core.Context (fun c => { c with maxHeartbeats := lim })
      (withoutRecover (evalTactic tac)))
    fun e => do
      s.restore
      throwError "bv_budget: {e.toMessageData}"

/-- A comparison between bit vectors, as a Boolean. -/
def isCmp (e : Expr) : Bool :=
  !e.hasLooseBVars && !e.hasMVar &&
  (e.isAppOfArity ``BitVec.ult 3 || e.isAppOfArity ``BitVec.ule 3 ||
    e.isAppOfArity ``BitVec.msb 2 || e.isAppOfArity ``BEq.beq 4 ||
    (e.isAppOfArity ``BitVec.getLsbD 3 && !(e.getArg! 1).isFVar))

/-- One goal for each value of an innermost comparison in the goal, simplified with it. -/
elab "bv_cmp_split" : tactic => do
  let g ← getMainGoal
  g.withContext do
  let t ← instantiateMVars (← g.getType)
  let some e := t.find? (fun e => isCmp e && e.getAppArgs.all fun a => (a.find? isCmp).isNone)
    | throwError "bv_cmp_split: no comparison"
  let stx ← Term.exprToSyntax e
  evalTactic (← `(tactic| (cases _h : $stx <;>
    try simp only [Bool.true_and, Bool.and_true, Bool.false_and, Bool.and_false, Bool.true_or,
      Bool.or_true, Bool.false_or, Bool.or_false, Bool.not_true, Bool.not_false,
      Bool.xor_true, Bool.xor_false, Bool.true_xor, Bool.false_xor, bne_self_eq_false,
      Bool.bne_true, Bool.bne_false, Bool.true_bne, Bool.false_bne, beq_self_eq_true,
      Bool.true_beq, Bool.false_beq, beq_true, beq_false, ↓reduceIte,
      Bool.true_eq_false, Bool.false_eq_true, BitVec.reduceULT, BitVec.reduceULE,
      BitVec.reduceBEq, BitVec.reduceEq, *] at ⊢)))

/-- The number of choices (`if`) in `e`, counted up to a little past `cap`. -/
partial def countIte (cap : Nat) (e : Expr) (acc : Nat) : Nat :=
  if acc > cap then acc else
  let acc := if e.isAppOfArity ``ite 5 || e.isAppOfArity ``dite 5 then acc + 1 else acc
  match e with
  | .app f a => countIte cap a (countIte cap f acc)
  | .mdata _ b => countIte cap b acc
  | _ => acc

/-- Succeeds when the goal makes a few choices (`if`), at most four, which `split` takes
apart cheaply. Many choices, nested, are better read bit by bit. -/
elab "bv_few_ite" : tactic => do
  let t ← instantiateMVars (← getMainTarget)
  let c := countIte 4 t 0
  unless 0 < c && c ≤ 4 do throwError "bv_few_ite: {c} choices in the goal"

/-- The casts `setWidth m x` of variables `x` in `e`. -/
partial def castsOfVars (e : Expr) (acc : Array Expr) : Array Expr :=
  let acc := if e.isAppOfArity ``BitVec.setWidth 3 && (e.getArg! 2).isFVar && !acc.contains e
    then acc.push e else acc
  match e with
  | .app f a => castsOfVars a (castsOfVars f acc)
  | .mdata _ b => castsOfVars b acc
  | _ => acc

/-- Each change of width of a variable in the goal, made a variable: smaller terms to put in
order. -/
elab "bv_gen_casts" : tactic => do
  let g ← getMainGoal
  g.withContext do
  let cs := castsOfVars (← instantiateMVars (← g.getType)) #[]
  if cs.isEmpty then throwError "bv_gen_casts: no change of width of a variable"
  let (_, g) ← g.generalize (cs.map fun a => { expr := a })
  replaceMainGoal [g]

/-- A contradiction with a hypothesis `¬ P`, `P` proved by `tac`. -/
elab "bv_contra " tac:tactic : tactic => do
  let g ← getMainGoal
  g.withContext do
  for d in (← getLCtx) do
    if d.isImplementationDetail then continue
    let ty ← instantiateMVars d.type
    let_expr Not p := ty | continue
    let s ← saveState
    -- a failure, or a recursion or heartbeat limit reached on the way: the next hypothesis
    let closed ← tryCatchRuntimeEx
      (do
        let gp ← mkFreshExprSyntheticOpaqueMVar p
        g.assign (← mkAbsurd (← g.getType) gp (mkFVar d.fvarId))
        setGoals [gp.mvarId!]
        evalTactic tac
        unless (← getGoals).isEmpty do throwError "bv_contra: not closed"
        pure true)
      fun _ => do s.restore; pure false
    if closed then return
  throwError "bv_contra: no hypothesis to contradict"

end Braid.BV

end

/-- Arithmetic on literal indices, and the Boolean connectives on literals. -/
syntax "bv_bit_arith" (Lean.Parser.Tactic.location)? : tactic
macro_rules | `(tactic| bv_bit_arith $[$loc]?) => `(tactic|
  simp only [Nat.reduceAdd, Nat.reduceSub, Nat.reduceMul, Nat.reduceDiv, Nat.reduceMod,
      Nat.reducePow, Nat.reduceLT, Nat.reduceGT, Nat.reduceLeDiff, Nat.reduceEqDiff,
      Nat.reduceBEq, Nat.reduceBNe, ↓reduceIte, ↓reduceDIte,
      decide_true, decide_false, Bool.true_and, Bool.and_true, Bool.false_and,
      Bool.and_false, Bool.not_true, Bool.not_false, ite_true, ite_false, dite_true, dite_false,
      Nat.zero_add, Nat.add_zero, Bool.or_false, Bool.false_or, Bool.true_or,
      Bool.or_true, Bool.xor_false, Bool.false_xor, Bool.not_not, BitVec.getLsbD_of_ge,
      Braid.BV.reduceTestBit] $[$loc]?)

/-- The bits of the operations on bit vectors, then arithmetic on the literal indices. -/
syntax "bv_bit_simp" (Lean.Parser.Tactic.location)? : tactic
macro_rules | `(tactic| bv_bit_simp $[$loc]?) => `(tactic| first
  | (simp only [BitVec.getLsbD_and, BitVec.getLsbD_or, BitVec.getLsbD_xor,
      BitVec.getLsbD_not, BitVec.getLsbD_shiftLeft, BitVec.getLsbD_ushiftRight,
      BitVec.getLsbD_setWidth, BitVec.getLsbD_extractLsb', BitVec.getLsbD_append,
      BitVec.getLsbD_rotateLeft, BitVec.getLsbD_rotateRight, BitVec.getLsbD_signExtend,
      BitVec.getLsbD_sshiftRight, BitVec.getLsbD_ofBool,
      BitVec.getLsbD_ofNat, BitVec.getLsbD_zero, BitVec.getLsbD_allOnes, BitVec.getLsbD_cast,
      BitVec.msb_eq_getLsbD_last, Braid.BV.getLsbD_ite, ite_self] $[$loc]?
     try bv_bit_arith $[$loc]?)
  | bv_bit_arith $[$loc]?)

/-- Every change of width as `setWidth`, every shift by a number, and `setWidth` pushed
through the operations it commutes with. -/
syntax "bv_norm" (Lean.Parser.Tactic.location)? : tactic
macro_rules | `(tactic| bv_norm $[$loc]?) => `(tactic|
  simp only [BitVec.truncate_eq_setWidth, BitVec.zeroExtend_eq_setWidth,
    Braid.BV.extractLsb'_zero_eq, BitVec.setWidth_eq,
    BitVec.shiftLeft_eq', BitVec.ushiftRight_eq', BitVec.sshiftRight_eq', BitVec.toNat_ofNat,
    Nat.reduceMod, Nat.reducePow,
    BitVec.setWidth_setWidth_of_le, BitVec.setWidth_add, BitVec.setWidth_mul,
    Braid.BV.setWidth_sub_of_le, BitVec.setWidth_neg_of_le,
    Nat.le_refl, Nat.reduceLeDiff, BitVec.ofNat_eq_ofNat,
    BitVec.reduceNeg, BitVec.reduceNot, BitVec.reduceAnd, BitVec.reduceOr, BitVec.reduceXOr,
    BitVec.reduceAdd, BitVec.reduceMul, BitVec.reduceSub, BitVec.reduceShiftLeft,
    BitVec.reduceUShiftRight, BitVec.reduceHShiftLeft, BitVec.reduceHShiftRight,
    BitVec.reduceAppend, BitVec.reduceSetWidth, BitVec.reduceExtractLsb, BitVec.reduceToNat,
    BitVec.reduceEq, BitVec.reduceBEq, BitVec.reduceULT, BitVec.reduceULE, BitVec.reduceLT,
    BitVec.reduceLE, BitVec.reduceAllOnes, BitVec.reduceSignExtend, BitVec.reduceGetLsb,
    BitVec.reduceRotateLeft, BitVec.reduceRotateRight, ← BitVec.getLsbD_eq_getElem,
    Braid.BV.signExtend_eq_zero_iff, BitVec.zero_or, BitVec.or_zero, BitVec.shiftLeft_zero,
    BitVec.ushiftRight_zero, BitVec.zero_add, BitVec.add_zero] $[$loc]?)

/-- Comparisons, overflow, masks and bits as arithmetic on `toNat`, then `omega`. -/
macro "bv_arith" : tactic => `(tactic| (
  (try simp only [← BitVec.neg_one_eq_allOnes, BitVec.ult_eq_decide, BitVec.ule_eq_decide,
      Braid.BV.uaddOverflow_eq_decide, BitVec.usubOverflow_eq, BitVec.msb_eq_decide,
      bne, beq_iff_eq, Bool.decide_or, Bool.decide_and, Bool.or_eq_true, Bool.and_eq_true,
      Bool.not_eq_true, Bool.not_eq_false, Bool.not_eq_true',
      decide_eq_decide, decide_eq_true_eq, decide_eq_false_iff_not,
      Bool.not_true, Bool.not_false, BitVec.toNat_and, BitVec.toNat_or, BitVec.toNat_ofBool,
      BitVec.toNat_ofNat, BitVec.lt_def, BitVec.le_def, BitVec.toNat_eq, BitVec.toNat_setWidth,
      BitVec.ofNat_eq_ofNat, BitVec.toNat_zero, beq_eq_false_iff_ne, ne_eq, Nat.reduceSub,
      Nat.reducePow, Nat.reduceMod, Braid.BV.reduceAndMask] at *)
  bv_omega))

/-- The goal, an equation between bit vectors, bit by bit. -/
macro "bv_bits" : tactic => `(tactic| (
  apply Braid.BV.eq_of_bits
  (try bv_hyp_bits)
  bv_index_split
  all_goals (try bv_inst_bits) <;> (try bv_bit_simp at *) <;> bv_bool_decide))

/-- Sums of parts with no bit in common, such as bytes shifted into place, as disjunctions:
each product with a power of two a shift, each such sum an `|||`, then bit by bit. -/
macro "bv_add_or" : tactic => `(tactic| (
  (try simp only [Braid.BV.reduceMulPow2] at *)
  simp (disch := bv_guard ((try bv_norm); bv_bits)) only [BitVec.add_eq_or_of_and_eq_zero]
  all_goals bv_bits))

/-- Two sides that differ by the order of the operands of `+`, `*`, `&&&`, `|||` and `^^^`:
both put in one order. Cheaper than `ac_rfl`, which searches for instances on every
operation it meets. -/
macro "bv_ac" : tactic => `(tactic| (
  simp only [BitVec.add_comm, BitVec.add_assoc, Braid.BV.add_left_comm,
    BitVec.mul_comm, BitVec.mul_assoc, Braid.BV.mul_left_comm,
    BitVec.and_comm, BitVec.and_assoc, Braid.BV.and_left_comm,
    BitVec.or_comm, BitVec.or_assoc, Braid.BV.or_left_comm,
    BitVec.xor_comm, BitVec.xor_assoc, Braid.BV.xor_left_comm]; done))

/-- A Boolean formula in comparisons of bit vectors (unsigned, signed, top bits, equality):
signed comparisons and top bits as unsigned ones, one goal for each value of each
comparison, and each goal by arithmetic. -/
macro "bv_bool_split" : tactic => `(tactic| (
  (try simp only [BitVec.slt_eq_ult, BitVec.sle_eq_not_slt, BitVec.msb_and, BitVec.msb_or,
    BitVec.msb_xor, BitVec.msb_not, BitVec.msb_zero, Braid.BV.ult_zero, Bool.xor_false,
    Bool.bne_false, Bool.false_bne] at *)
  (repeat' bv_cmp_split)
  all_goals first | rfl | decide | bv_arith))

/-- Parts with no bit in common, such as lanes or bytes put side by side, and arithmetic on
them: each such disjunction a sum, then arithmetic on `toNat`. -/
macro "bv_or_arith" : tactic => `(tactic| (
  simp (disch := bv_guard ((try bv_norm); bv_bits)) only [Braid.BV.or_eq_add]
  (try simp only [BitVec.toNat_eq, BitVec.toNat_add, BitVec.toNat_shiftLeft,
    BitVec.toNat_ushiftRight, BitVec.toNat_setWidth, Nat.shiftLeft_eq, Nat.shiftRight_eq_div_pow,
    BitVec.toNat_ofNat, Nat.reducePow] at *)
  bv_arith))

/-- Code that works in a wide register for an operation of a narrow width (32-bit words in
64-bit registers, rotations as two shifts): every change of width pushed in as far as it
goes, a shift of a widened value cut back, two shifts that make a rotation made one, the
changes of width of variables made variables, and then both sides put in one order. -/
macro "bv_narrow_ac" : tactic => `(tactic| (
  (try simp only [BitVec.shiftLeft_eq', BitVec.ushiftRight_eq', BitVec.toNat_ofNat,
    Nat.reduceMod, Nat.reducePow])
  simp only [BitVec.setWidth_setWidth_of_le, BitVec.setWidth_shiftLeft_of_le,
    ↓Braid.BV.setWidth_signExtend_self, ↓Braid.BV.setWidth_ushr_setWidth, Nat.reduceSub,
    Nat.reduceLeDiff, Nat.reduceLT, Nat.le_refl, BitVec.setWidth_or, BitVec.setWidth_xor,
    BitVec.setWidth_and, BitVec.setWidth_not, BitVec.setWidth_add, BitVec.setWidth_mul]
  (try bv_gen_casts)
  (try simp only [Braid.BV.or_shifts_eq_rotateLeft, Nat.reduceAdd, Nat.reduceLT])
  bv_ac))

/-- The decision procedures on their own, without splitting. -/
macro "bv_solve" : tactic => `(tactic| first
  | bv_budget 30000 bv_arith
  | bv_budget 20000 bv_ac
  | bv_budget 60000 bv_bits
  | bv_budget 50000 bv_add_or
  | bv_guard ((bv_bit_simp at *) <;> bv_bool_decide))

public meta section

open Lean Elab Tactic Meta

namespace Braid.BV

/-- What a goal is made of, to choose the order in which to try the procedures. -/
structure Shape where
  /-- An equation between bit vectors. -/
  eqBV : Bool
  /-- `+`, `-`, `*`, `/`, `%` or `-x` on bit vectors. -/
  arith : Bool
  /-- `&&&`, `|||`, `^^^`, `~~~`, shifts, rotations, changes of width, bits. -/
  bitwise : Bool
  /-- How many choices (`if`), up to five. -/
  ites : Nat

/-- The shape of `t`. -/
def shapeOf (t : Expr) : MetaM Shape := do
  let has (ns : List Name) := (t.find? fun e => match e.getAppFn.constName? with
    | some n => ns.contains n && e.getAppNumArgs ≥ 2
    | none => false).isSome
  let eqBV ← match t.cleanupAnnotations.eq? with
    | some (α, _, _) => pure ((← whnfR α).isAppOfArity ``BitVec 1)
    | none => pure false
  return {
    eqBV
    arith := has [``HAdd.hAdd, ``HSub.hSub, ``HMul.hMul, ``HDiv.hDiv, ``HMod.hMod, ``Neg.neg]
    bitwise := has [``HAnd.hAnd, ``HOr.hOr, ``HXor.hXor, ``Complement.complement,
      ``HShiftLeft.hShiftLeft, ``HShiftRight.hShiftRight, ``BitVec.rotateLeft,
      ``BitVec.rotateRight, ``BitVec.setWidth, ``BitVec.signExtend, ``BitVec.extractLsb',
      ``HAppend.hAppend, ``BitVec.getLsbD, ``BitVec.msb]
    ites := countIte 4 t 0 }

/-- Try the procedures in an order chosen from the shape of the goal: first those that its
shape suits, then the others. Each runs on a budget of its own, so that one that fails
leaves the rest of the budget to those after it. -/
elab "bv_dispatch" : tactic => do
  let sh ← shapeOf (← instantiateMVars (← getMainTarget))
  -- after the split, a test `a == b` that chose a side is an equation, and a side the tests
  -- rule out is closed by contradiction
  let split ← `(tactic| bv_guard ((repeat' split) <;>
    (try simp only [beq_iff_eq, beq_eq_false_iff_ne, ne_eq] at *) <;> (try bv_norm at *) <;>
    first | bv_solve | bv_contra bv_solve))
  let arith ← `(tactic| bv_budget 30000 bv_arith)
  let ac ← `(tactic| bv_budget 20000 bv_ac)
  let narrow ← `(tactic| bv_budget 30000 bv_narrow_ac)
  let bits ← `(tactic| bv_budget 60000 bv_bits)
  let addOr ← `(tactic| bv_budget 50000 bv_add_or)
  let bitDecide ← `(tactic| bv_guard ((bv_bit_simp at *) <;> bv_bool_decide))
  let enum ← `(tactic| bv_guard (bv_enum <;> (try bv_norm at *) <;> bv_solve))
  let boolCases ← `(tactic| bv_guard (bv_bool_cases <;> (try bv_norm at *) <;> bv_solve))
  let peel ← `(tactic| bv_guard (bv_peel <;> (try bv_relevant) <;> bv_solve))
  let boolSplit ← `(tactic| bv_budget 50000 bv_bool_split)
  let orArith ← `(tactic| bv_budget 120000 bv_or_arith)
  let contra ← `(tactic| bv_guard contradiction)
  -- the statement a hypothesis `¬ P` denies, proved: directly, or by its choices
  let contraBy ← `(tactic| bv_contra (first
    | bv_solve
    | bv_guard ((repeat' split) <;>
        (try simp only [beq_iff_eq, beq_eq_false_iff_ne, ne_eq] at *) <;>
        (try bv_norm at *) <;> bv_solve)))
  let first : Array (TSyntax `tactic) :=
    if 0 < sh.ites && sh.ites ≤ 4 then #[split]
    else if sh.eqBV && !sh.arith then #[bits, peel, ac, enum]
    else if sh.eqBV && !sh.bitwise then #[arith, ac, peel]
    else if sh.eqBV then #[narrow, ac, peel, addOr, enum, arith, bits, orArith]
    else #[arith, boolSplit, bitDecide, boolCases]
  let rest := #[arith, ac, bits, addOr, bitDecide, split, enum, boolCases, peel, narrow,
    boolSplit, orArith, contra, contraBy]
  let mut tried : Array (TSyntax `tactic) := #[]
  for tac in first ++ rest do
    if tried.contains tac then continue
    tried := tried.push tac
    let s ← saveState
    let closed ← tryCatchRuntimeEx
      (do
        withoutRecover (evalTactic tac)
        pure (← getGoals).isEmpty)
      fun _ => pure false
    if closed then return
    s.restore
  throwError "bv_auto: no procedure closes the goal"

end Braid.BV

end

/-- Close a goal about bit vectors, with a proof the kernel checks. -/
macro "bv_auto" : tactic => `(tactic| (
  (try bv_atoms)
  bv_clear
  (try subst_vars)
  (try bv_norm at *)
  first
  | done
  | bv_dispatch))
