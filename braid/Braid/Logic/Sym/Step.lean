/-
  Braid.Logic.Sym.Step

  The stepper: symbolic execution as a metaprogram. It does what `braid_step` does, one
  block of the program on the symbolic state, but it builds the proof term itself, from the
  rules of `Braid.Logic.Sym.Rule`, where `braid_step` simplifies the whole goal after every
  operation. The work for one operation does not depend on how large the symbolic state or
  its values have become:

  * an SSA value is looked up by walking the environment, not by rewriting;
  * an atom is found by its register, flag or address, and the proof that it is there is
    built directly;
  * a new value is put in normal form by a simplifier call that sees only the top few
    levels of the term (`norm`): deeper subterms are replaced by variables first;
  * the block at an address is found in a table built once for a run, and when the blocks
    are in address order, as a lowered function's are, the proof that the program has the
    block there is that the block is in the list (`Rule.Table`), which the kernel checks
    without searching.

  The kernel checks the term at the end, so nothing here is trusted.

  ## Main definitions

  * `braid_sym_step`: run the block at the program counter
  * `braid_sym_run`: run blocks until the program has none at the program counter, or a
    branch goes both ways
-/

module

public import Braid.Logic.Sym.Rule
public import Braid.Logic.Sym.RuleT
public import Braid.Logic.Tactic
public meta import Lean.Elab.Tactic

public meta section

namespace Braid.Sym

open Lean Meta Elab Tactic

/-! ## Normal forms -/

/-- The simplifier call that puts a value in normal form: the lemmas of `braid_norm`, and
the equations of the values the rules ask for. -/
def normStx : CoreM Syntax :=
  `(tactic| simp only [Rule.sel_eq, Rule.bnz_eq, Rule.ld_eq, Rule.nz_eq, Rule.isz_eq,
    ofBool_true, ofBool_false, ↓reduceIte,
    BinOp.eval_add, BinOp.eval_sub, BinOp.eval_mul, BinOp.eval_mulhu, BinOp.eval_mulhs,
    BinOp.eval_mulhsu, BinOp.eval_udiv, BinOp.eval_urem, BinOp.eval_sdiv, BinOp.eval_srem,
    BinOp.eval_and, BinOp.eval_or, BinOp.eval_xor, BinOp.eval_shl, BinOp.eval_lshr,
    BinOp.eval_ashr, BinOp.eval_rotr, BinOp.eval_eq, BinOp.eval_ne, BinOp.eval_ult,
    BinOp.eval_ule, BinOp.eval_slt, BinOp.eval_sle, UnOp.eval_not, UnOp.eval_neg,
    UnOp.eval_clz, UnOp.eval_popcnt, UnOp.eval_rbit, UnOp.eval_bswap, UnOp.eval_sext,
    UnOp.eval_zext, Width.bytes, Width.bits, Nat.reduceMul, BitVec.truncate_eq_setWidth,
    BitVec.zeroExtend_eq_setWidth, BitVec.setWidth_eq, trunc8_zext, trunc16_zext,
    trunc32_zext, BitVec.reduceSetWidth, sub_lit, BitVec.add_assoc, BitVec.reduceAdd,
    BitVec.reduceAnd, BitVec.reduceOr, BitVec.reduceXOr, BitVec.reduceNot,
    BitVec.reduceSub, BitVec.reduceNeg, BitVec.reduceMul, BitVec.add_zero, BitVec.zero_add,
    BitVec.zero_or, BitVec.or_zero, BitVec.xor_zero, BitVec.zero_xor,
    ne_eq, ofBool_eq_zero, ofBool_bne_zero, Bool.not_eq_false, beq_iff_eq, bne_iff_ne,
    beq_eq_false_iff_ne, bne_eq_false_iff_eq, BitVec.reduceEq, BitVec.reduceNe,
    BitVec.reduceBEq, BitVec.reduceBNe,
    BitVec.reduceULT, BitVec.reduceULE, BitVec.reduceSLT, BitVec.reduceSLE, reduceCtorEq,
    not_true_eq_false, not_false_eq_true, Decidable.not_not])

/-- What `norm` simplifies with. -/
structure Norm where
  ctx : Simp.Context
  simprocs : Simp.SimprocsArray

def Norm.make : TacticM Norm := do
  let r ← mkSimpContext (← normStx) (eraseLocal := false)
  return { ctx := r.ctx, simprocs := r.simprocs }

/-- Replace the words and bits more than `d` levels down in `e` by variables, recording
which variable stands for what. -/
partial def cut (d : Nat) (e : Expr) : StateT (Array (FVarId × Expr × Expr)) MetaM Expr := do
  if !e.isApp || !e.hasFVar then return e
  if d == 0 then
    let ty ← whnfR (← inferType e)
    if ty.isAppOf ``BitVec || ty.isConstOf ``Bool then
      if let some (fv, _, _) := (← get).find? (·.2.1 == e) then return mkFVar fv
      let fv ← mkFreshFVarId
      modify (·.push (fv, e, ty))
      return mkFVar fv
  let args ← e.getAppArgs.mapM (cut (d - 1))
  return mkAppN e.getAppFn args

/-- Put `e` in normal form, looking only at its top `depth` levels. The result is the new
term and, when it differs by more than unfolding, a proof that `e` equals it. -/
def norm (N : Norm) (e : Expr) (depth : Nat := 4) : MetaM Simp.Result := do
  let (sk, abs) ← (cut depth e).run #[]
  let lctx := abs.foldl (fun l (fv, _, ty) => l.mkLocalDecl fv `x ty) (← getLCtx)
  let r ← withLCtx lctx (← getLocalInstances) do
    let (r, _) ← simp sk N.ctx N.simprocs
    let p ← r.proof?.mapM instantiateMVars
    pure (← instantiateMVars r.expr, p)
  let fvs := abs.map (mkFVar ·.1)
  let vals := abs.map (·.2.1)
  return { expr := r.1.replaceFVars fvs vals, proof? := r.2.map (·.replaceFVars fvs vals) }

/-- A proof of `e = r.expr`. -/
def eqProof (r : Simp.Result) : MetaM Expr :=
  match r.proof? with
  | some p => pure p
  | none => mkEqRefl r.expr

/-! ## Reading terms -/

/-- The number a literal register, flag or SSA name is. -/
def natLit? (e : Expr) : MetaM (Option Nat) := do
  if let some n := e.nat? then return n
  if let some n := e.rawNatLit? then return n
  let e ← whnfR e
  if let some n := e.nat? then return n
  if let some n := e.rawNatLit? then return n
  (evalNat e).run

def natLit (e : Expr) : MetaM Nat := do
  let some n ← natLit? e | throwError "braid_sym: not a literal: {e}"
  return n

def boolFalseRefl : Expr :=
  mkApp2 (mkConst ``Eq.refl [1]) (mkConst ``Bool) (mkConst ``Bool.false)

/-- The value of SSA name `y` in the environment `ρ`, and a proof that `ρ y` is it. -/
partial def lookup (ρ y : Expr) (yn : Nat) : MetaM (Expr × Expr) := do
  match_expr ρ with
  | Braid.Env.set ρ' x v =>
    if (← natLit x) == yn then
      return (v, mkApp3 (mkConst ``Rule.here) ρ' y v)
    else
      let (w, h) ← lookup ρ' y yn
      return (w, mkApp7 (mkConst ``Rule.there) ρ' x y v w boolFalseRefl h)
  | _ => throwError "braid_sym: SSA value {y} is read before it is defined"

def lookupVar (ρ y : Expr) : MetaM (Expr × Expr) := do lookup ρ y (← natLit y)

/-! ## The symbolic state -/

def atomTy : Expr := mkConst ``Braid.Atom

def mkCons (a tl : Expr) : Expr := mkApp3 (mkConst ``List.cons [0]) atomTy a tl

/-- A list of atoms, with the term of each of its tails. -/
structure AtomList where
  atoms : Array Expr
  tails : Array Expr

namespace AtomList

def ofArray (atoms : Array Expr) : AtomList := Id.run do
  let mut tl := mkApp (mkConst ``List.nil [0]) atomTy
  let mut tails := Array.replicate (atoms.size + 1) tl
  for i in [0:atoms.size] do
    let j := atoms.size - 1 - i
    tl := mkCons atoms[j]! tl
    tails := tails.set! j tl
  return { atoms, tails }

def expr (A : AtomList) : Expr := A.tails[0]!

/-- The list with atom `i` replaced. The tails after `i` are shared. -/
def set (A : AtomList) (i : Nat) (a : Expr) : AtomList := Id.run do
  let atoms := A.atoms.set! i a
  let mut tails := A.tails
  for k in [0:i + 1] do
    let j := i - k
    tails := tails.set! j (mkCons atoms[j]! tails[j + 1]!)
  return { atoms, tails }

/-- A proof of `A.expr.At atoms[i]`. -/
def atProof (A : AtomList) (i : Nat) : Expr := Id.run do
  let a := A.atoms[i]!
  let mut p := mkApp2 (mkConst ``Braid.Atoms.At.here) a A.tails[i + 1]!
  for k in [0:i] do
    let j := i - 1 - k
    p := mkApp4 (mkConst ``Braid.Atoms.At.there) a A.atoms[j]! A.tails[j + 1]! p
  return p

/-- A proof of `A.expr.Upd atoms[i] a' (A.set i a').expr`. -/
def updProof (A A' : AtomList) (i : Nat) : Expr := Id.run do
  let a := A.atoms[i]!
  let a' := A'.atoms[i]!
  let mut p := mkApp3 (mkConst ``Braid.Atoms.Upd.here) a a' A.tails[i + 1]!
  for k in [0:i] do
    let j := i - 1 - k
    p := mkApp6 (mkConst ``Braid.Atoms.Upd.there) a a' A.atoms[j]! A.tails[j + 1]!
      A'.tails[j + 1]! p
  return p

/-- Read a list of atoms written out with `::` and `[]`. -/
partial def parse (e : Expr) (acc : Array Expr := #[]) : MetaM AtomList := do
  match_expr e with
  | List.cons _ a tl => parse tl (acc.push a)
  | List.nil _ => return ofArray acc
  | _ => throwError "braid_sym: the symbolic state is not a list of atoms written out: {e}"

/-- Whether two addresses are the same: the same term, or the same once `Word` is read as
`BitVec 64`, which is how the same sum is written by different lemmas. -/
def sameAddr (a b : Expr) : MetaM Bool := do
  if a == b then return true
  withReducible (withoutModifyingState (isDefEq a b))

/-- The first atom built by `ctor` that `p` accepts, as its index and arguments. -/
def find (A : AtomList) (ctor : Name) (p : Array Expr → MetaM Bool) :
    MetaM (Option (Nat × Array Expr)) := do
  for i in [0:A.atoms.size] do
    let mut a := A.atoms[i]!
    unless a.getAppFn.isConst do a ← whnfR a
    if a.isAppOf ctor then
      let args := a.getAppArgs
      if ← p args then return some (i, args)
  return none

end AtomList

/-! ## Blocks -/

/-- The blocks of a program given by a list. -/
structure BlockTable where
  P : Expr
  /-- The list, as the program has it. -/
  l : Expr
  /-- By address: the entry of the list, and a proof that it is in the list. -/
  entries : Std.HashMap Nat (Expr × (Unit → Expr))
  /-- A proof of `Rule.Table P l`, when the list is in address order. -/
  table? : Option Expr

def pairTy : Expr :=
  mkApp2 (mkConst ``Prod [0, 0]) (mkConst ``Braid.Word) (mkConst ``Braid.Block)

/-- Unfold a list until it is a `::`, a `[]` or a `++`. -/
partial def exposeList (e : Expr) : MetaM Expr := do
  let e ← whnfCore e
  if e.isAppOf ``List.cons || e.isAppOf ``List.nil || e.isAppOfArity ``HAppend.hAppend 6 then
    return e
  if let .proj _ i s := e then
    let s ← whnf s
    let some name := s.getAppFn.constName? | return e
    let some (.ctorInfo c) := (← getEnv).find? name | return e
    return ← exposeList (s.getArg! (c.numParams + i))
  match ← unfoldDefinition? e with
  | some e' => exposeList e'
  | none => return e

/-- The entries of a list of blocks, in order: address, entry, and how to prove the entry is
in the whole list, given `wrap`, which says so for an entry of this part of it. -/
partial def collectBlocks (l : Expr) (wrap : Expr → Expr → Expr)
    (acc : Array (Nat × Expr × (Unit → Expr))) :
    MetaM (Array (Nat × Expr × (Unit → Expr))) := do
  let e ← exposeList l
  match_expr e with
  | List.cons _ hd tl =>
    let hd' ← whnf hd
    unless hd'.isAppOfArity ``Prod.mk 4 do throwError "braid_sym: not a block entry: {hd}"
    let some ⟨_, a⟩ ← getBitVecValue? (hd'.getArg! 2)
      | throwError "braid_sym: the address of a block is not a literal: {hd}"
    let here := fun _ => wrap hd (mkApp3 (mkConst ``List.Mem.head [0]) pairTy hd tl)
    collectBlocks tl
      (fun x h => wrap x (mkApp5 (mkConst ``List.Mem.tail [0]) pairTy x hd tl h))
      (acc.push (a.toNat, hd, here))
  | List.nil _ => return acc
  | HAppend.hAppend _ _ _ _ as bs =>
    let acc ← collectBlocks as
      (fun x h => wrap x (mkApp5 (mkConst ``List.mem_append_left [0]) pairTy x as bs h)) acc
    collectBlocks bs
      (fun x h => wrap x (mkApp5 (mkConst ``List.mem_append_right [0]) pairTy x as bs h)) acc
  | _ => throwError "braid_sym: not a list of blocks written out: {e}"

def boolTrueRefl : Expr :=
  mkApp2 (mkConst ``Eq.refl [1]) (mkConst ``Bool) (mkConst ``Bool.true)

/-- Read the blocks of a program. -/
partial def BlockTable.build (P : Expr) : MetaM BlockTable := do
  let mut e := P
  while !e.isAppOfArity ``Braid.Program.ofList 1 do
    let some e' ← unfoldDefinition? e
      | throwError "braid_sym: the program is not given by a list of blocks: {P}"
    e := e'
  let l := e.appArg!
  let all ← collectBlocks l (fun _ h => h) #[]
  let mut entries : Std.HashMap Nat (Expr × (Unit → Expr)) := {}
  let mut sorted := true
  let mut last : Option Nat := none
  for (a, hd, pf) in all do
    if let some b := last then
      unless b < a do sorted := false
    last := some a
    unless entries.contains a do entries := entries.insert a (hd, pf)
  let table? :=
    if sorted then
      some (mkApp4 (mkConst ``Rule.Table.intro) P l
        (mkApp2 (mkConst ``Eq.refl [1]) (mkConst ``Braid.Program) P) boolTrueRefl)
    else none
  return { P, l, entries, table? }

/-- The block at an address, and a proof that the program has it there. -/
def BlockTable.get (T : BlockTable) (a : Nat) : MetaM (Option (Expr × Expr × Expr)) := do
  let some (hd, pf) := T.entries[a]? | return none
  let hd' ← whnf hd
  let b ← whnf (hd'.getArg! 3)
  let_expr Braid.Block.mk ops t := b
    | throwError "braid_sym: not a block written out: {b}"
  let blockTy := mkConst ``Braid.Block
  let hb := match T.table? with
    | some tbl => mkApp5 (mkConst ``Rule.Table.get) T.P T.l hd tbl (pf ())
    | none => mkApp2 (mkConst ``Eq.refl [1]) (mkApp (mkConst ``Option [0]) blockTy)
        (mkApp2 (mkConst ``Option.some [0]) blockTy b)
  return some (ops, t, hb)

/-! ## The stepper -/

/-- What stays the same while a block runs. -/
structure Ctx where
  N : Norm
  /-- The program. -/
  P : Expr
  post : Expr
  /-- `fun as => Triple P (Atoms.interp as) post`. -/
  Ψ : Expr
  /-- `fun ρ as => TermSpec t ρ as Ψ`. -/
  Φ : Expr
  /-- The terminator of the block. -/
  tm : Expr
  /-- Whether the goal is a traced triple. `Ψ` and `Φ` then take the trace as well. -/
  lab : Bool := false
  /-- The trace a traced triple ends with. -/
  tEnd : Expr := mkNatLit 0

def mkTriple (P as post : Expr) : Expr :=
  mkApp3 (mkConst ``Braid.Triple) P (mkApp (mkConst ``Braid.Atoms.interp) as) post

def mkSet (ρ d v : Expr) : Expr := mkApp3 (mkConst ``Braid.Env.set) ρ d v

/-- The rule of the same name for a traced triple, if the goal is one. -/
def Ctx.nm (c : Ctx) (n : Name) : Name :=
  if c.lab then Name.mkStr `Braid.Sym.RuleT n.getString! else n

/-- The trace so far, as an argument of a rule, if the goal is a traced triple. -/
def Ctx.tr (c : Ctx) (u : Expr) : Array Expr := if c.lab then #[u] else #[]

/-- The triple from the atoms `as`, after the trace `u`. -/
def Ctx.goal (c : Ctx) (as u : Expr) : Expr :=
  if c.lab then
    mkApp5 (mkConst ``Braid.TripleT) c.P (mkApp (mkConst ``Braid.Atoms.interp) as) u c.post c.tEnd
  else mkTriple c.P as c.post

def labelTy : Expr := mkConst ``Braid.Label

/-- The trace `u` with the label `l` added. -/
def snoc (u l : Expr) : Expr :=
  let ty := mkApp (mkConst ``List [0]) labelTy
  mkApp6 (mkConst ``HAppend.hAppend [0, 0, 0]) ty ty ty
    (mkApp2 (mkConst ``instHAppendOfAppend [0]) ty (mkApp (mkConst ``List.instAppend [0]) labelTy))
    u (mkApp3 (mkConst ``List.cons [0]) labelTy l (mkApp (mkConst ``List.nil [0]) labelTy))

def mkOps (c : Ctx) (ops ρ : Expr) (A : AtomList) (u : Expr) : Expr :=
  if c.lab then mkApp5 (mkConst ``Braid.OpsSpecT) ops ρ A.expr u c.Φ
  else mkApp4 (mkConst ``Braid.OpsSpec) ops ρ A.expr c.Φ

/-- Prove a proposition the code must satisfy: by simplification, from a hypothesis, or
with `bv_decide`. -/
def discharge (N : Norm) (prop : Expr) : TacticM Expr := do
  let r ← norm N prop 6
  if r.expr.isTrue then
    return mkApp2 (mkConst ``of_eq_true) prop (← eqProof r)
  let m ← mkFreshExprSyntheticOpaqueMVar r.expr
  let closed ← try withReducible m.mvarId!.assumption; pure true catch _ => pure false
  unless closed do
    let saved ← getGoals
    setGoals [m.mvarId!]
    evalTactic (← `(tactic| bv_decide))
    unless (← getGoals).isEmpty do throwError "braid_sym: a guard is left open: {r.expr}"
    setGoals saved
  match r.proof? with
  | some p => mkEqMPR p m
  | none => return m

/-- Put a hypothesis in normal form. The goal is closed if the hypothesis is false. -/
def normHyp (N : Norm) (g : MVarId) (fv : FVarId) : MetaM (Option MVarId) := g.withContext do
  let ty ← instantiateMVars (← fv.getType)
  let r ← norm N ty 6
  if r.expr.isFalse then
    let h ← match r.proof? with
      | some p => mkEqMP p (mkFVar fv)
      | none => pure (mkFVar fv)
    g.assign (← mkFalseElim (← g.getType) h)
    return none
  if r.expr == ty then return some g
  if r.expr.isTrue then return some (← g.clear fv)
  return some (← g.replaceLocalDecl fv r.expr (← eqProof r)).mvarId

/-- The atom of flag `fn`: its index, the flag as the atom names it, and its value if the
atom gives one (`none` for `flagAny`). -/
def findFlag (A : AtomList) (fn : Nat) : MetaM (Nat × Expr × Option Expr) := do
  for i in [0:A.atoms.size] do
    let mut a := A.atoms[i]!
    unless a.getAppFn.isConst do a ← whnfR a
    match_expr a with
    | Braid.Atom.flag f b => if (← natLit? f) == some fn then return (i, f, some b)
    | Braid.Atom.prop q =>
      if q.isAppOfArity ``Braid.flagAny 1 then
        if (← natLit? q.appArg!) == some fn then return (i, q.appArg!, none)
    | _ => pure ()
  throwError "braid_sym: the symbolic state has no atom for flag {fn}"

/-- The SSA values an operation reads, and the one it defines. -/
def opUses (op : Expr) : Array Expr × Option Expr :=
  let a := op.getAppArgs
  match op.getAppFn.constName? with
  | some ``Braid.Op.const => (#[], a[0]?)
  | some ``Braid.Op.un => (#[a[2]!], a[0]?)
  | some ``Braid.Op.bin => (#[a[2]!, a[3]!], a[0]?)
  | some ``Braid.Op.select => (#[a[1]!, a[2]!, a[3]!], a[0]?)
  | some ``Braid.Op.get => (#[], a[0]?)
  | some ``Braid.Op.set => (#[a[1]!], none)
  | some ``Braid.Op.getf => (#[], a[0]?)
  | some ``Braid.Op.setf => (#[a[1]!], none)
  | some ``Braid.Op.load => (#[a[2]!], a[0]?)
  | some ``Braid.Op.store => (#[a[1]!, a[2]!], none)
  | some ``Braid.Op.havoc => (#[], a[0]?)
  | some ``Braid.Op.guard => (#[a[0]!], none)
  | _ => (#[], none)

/-- Whether the rest of a block, `ops` and then `t`, never reads SSA value `d`. -/
partial def deadIn (d : Nat) (ops t : Expr) : MetaM Bool := do
  match_expr ops with
  | List.cons _ op rest =>
    let (uses, def?) := opUses op
    for u in uses do
      if (← natLit? u) == some d then return false
    if let some x := def? then
      if (← natLit? x) == some d then return true
    deadIn d rest t
  | List.nil _ =>
    let uses := match t.getAppFn.constName? with
      | some ``Braid.Term.branch => #[t.getArg! 0]
      | some ``Braid.Term.jumpInd => #[t.getArg! 0]
      | some ``Braid.Term.jump => #[]
      | _ => #[t]
    for u in uses do
      if (← natLit? u) != none && (← natLit? u) != some d then continue
      return false
    return true
  | _ => return false

/-- Run a terminator. The goals left are triples from the states it leads to. -/
def runTerm (c : Ctx) (g : MVarId) (t ρ : Expr) (A : AtomList) (u : Expr) :
    TacticM (List MVarId) := do
  let some (i, pcArgs) ← A.find ``Braid.Atom.pc fun _ => pure true
    | throwError "braid_sym: the symbolic state has no program counter"
  let p := pcArgs[0]!
  let goto (a : Expr) : AtomList := A.set i (mkApp (mkConst ``Braid.Atom.pc) a)
  let rule (n : Name) (args : Array Expr) :=
    mkAppN (mkConst (c.nm n)) (#[ρ, A.expr] ++ c.tr u ++ args)
  match_expr t with
  | Braid.Term.jump a =>
    let A' := goto a
    let m ← mkFreshExprSyntheticOpaqueMVar (c.goal A'.expr u)
    g.assign (rule ``Rule.jump #[A'.expr, c.Ψ, p, a, A.updProof A' i, m])
    return [m.mvarId!]
  | Braid.Term.jumpInd a =>
    let (v, ha) ← lookupVar ρ a
    let A' := goto v
    let m ← mkFreshExprSyntheticOpaqueMVar
      (c.goal A'.expr (snoc u (mkApp (mkConst ``Braid.Label.jump) v)))
    g.assign (rule ``Rule.jumpInd #[A'.expr, c.Ψ, p, v, a, ha, A.updProof A' i, m])
    return [m.mvarId!]
  | Braid.Term.branch cv tt ff =>
    let (vc, hc) ← lookupVar ρ cv
    let A₁ := goto tt
    let A₂ := goto ff
    let m₁ ← mkFreshExprSyntheticOpaqueMVar
      (← mkArrow (mkApp (mkConst ``Rule.nz) vc)
        (c.goal A₁.expr (snoc u (mkApp (mkConst ``Braid.Label.jump) tt))))
    let m₂ ← mkFreshExprSyntheticOpaqueMVar
      (← mkArrow (mkApp (mkConst ``Rule.isz) vc)
        (c.goal A₂.expr (snoc u (mkApp (mkConst ``Braid.Label.jump) ff))))
    g.assign (rule ``Rule.branch #[A₁.expr, A₂.expr, c.Ψ, p, tt, ff, cv, vc, hc,
      A.updProof A₁ i, A.updProof A₂ i, m₁, m₂])
    let mut out := []
    for m in [m₁, m₂] do
      let (fv, g') ← m.mvarId!.intro `hbr
      if let some g'' ← normHyp c.N g' fv then out := out ++ [g'']
    return out
  | Braid.Term.trap reason =>
    throwError "braid_sym: execution reaches a trap: {reason}"
  | _ => throwError "braid_sym: not a terminator written out: {t}"

/-- Run the operations of a block, then its terminator. -/
partial def runOps (c : Ctx) (g : MVarId) (ops ρ : Expr) (A : AtomList) (u : Expr) :
    TacticM (List MVarId) := g.withContext do
  let next (g' : Expr) (rest ρ' : Expr) (A' : AtomList) (u' : Expr) :=
    runOps c g'.mvarId! rest ρ' A' u'
  match_expr ops with
  | List.nil _ =>
    let t := c.tm
    let m ← mkFreshExprSyntheticOpaqueMVar <|
      if c.lab then mkApp5 (mkConst ``Braid.TermSpecT) t ρ A.expr u c.Ψ
      else mkApp4 (mkConst ``Braid.TermSpec) t ρ A.expr c.Ψ
    g.assign (mkAppN (mkConst (c.nm ``Rule.nil)) (#[ρ, A.expr] ++ c.tr u ++ #[t, c.Ψ, m]))
    runTerm c m.mvarId! t ρ A u
  | List.cons _ op rest =>
    let rule (n : Name) (args : Array Expr) :=
      mkAppN (mkConst (c.nm n)) (#[rest, ρ, A.expr] ++ c.tr u ++ args)
    let cont (ρ' : Expr) (A' : AtomList) (u' : Expr) :=
      mkFreshExprSyntheticOpaqueMVar (mkOps c rest ρ' A' u')
    match_expr op with
    | Braid.Op.const d v =>
      let ρ' := mkSet ρ d v
      let m ← cont ρ' A u
      g.assign (rule ``Rule.const #[c.Φ, d, v, m])
      next m rest ρ' A u
    | Braid.Op.un d o a =>
      let (va, ha) ← lookupVar ρ a
      let r ← norm c.N (mkApp2 (mkConst ``Braid.UnOp.eval) o va)
      let ρ' := mkSet ρ d r.expr
      let m ← cont ρ' A u
      g.assign (rule ``Rule.un #[c.Φ, d, a, o, va, r.expr, ha, ← eqProof r, m])
      next m rest ρ' A u
    | Braid.Op.bin d o a b =>
      let (va, ha) ← lookupVar ρ a
      let (vb, hb) ← lookupVar ρ b
      let r ← norm c.N (mkApp3 (mkConst ``Braid.BinOp.eval) o va vb)
      let ρ' := mkSet ρ d r.expr
      if c.lab then
        let leaks := (← whnf (mkApp (mkConst ``Braid.BinOp.leaks) o)).isConstOf ``Bool.true
        let u' := if leaks then snoc u (mkApp2 (mkConst ``Braid.Label.operands) va vb) else u
        let m ← cont ρ' A u'
        let hl := mkApp2 (mkConst ``Eq.refl [1]) (mkConst ``Bool)
          (mkConst (if leaks then ``Bool.true else ``Bool.false))
        g.assign (mkAppN (mkConst (if leaks then ``RuleT.binLeak else ``RuleT.bin))
          (#[rest, ρ, A.expr, u] ++
          #[c.Φ, d, a, b, o, va, vb, r.expr, hl, ha, hb, ← eqProof r, m]))
        return ← next m rest ρ' A u'
      let m ← cont ρ' A u
      g.assign (rule ``Rule.bin #[c.Φ, d, a, b, o, va, vb, r.expr, ha, hb, ← eqProof r, m])
      next m rest ρ' A u
    | Braid.Op.select d cv a b =>
      let (vc, hc) ← lookupVar ρ cv
      let (va, ha) ← lookupVar ρ a
      let (vb, hb) ← lookupVar ρ b
      let r ← norm c.N (mkApp3 (mkConst ``Rule.sel) vc va vb)
      let ρ' := mkSet ρ d r.expr
      let m ← cont ρ' A u
      g.assign (rule ``Rule.select
        #[c.Φ, d, cv, a, b, vc, va, vb, r.expr, hc, ha, hb, ← eqProof r, m])
      next m rest ρ' A u
    | Braid.Op.get d r =>
      let rn ← natLit r
      let some (i, args) ← A.find ``Braid.Atom.reg fun args => return (← natLit? args[0]!) == some rn
        | throwError "braid_sym: the symbolic state has no atom for register {rn}"
      let v := args[1]!
      let ρ' := mkSet ρ d v
      let m ← cont ρ' A u
      g.assign (rule ``Rule.get #[c.Φ, d, r, v, A.atProof i, m])
      next m rest ρ' A u
    | Braid.Op.set r a =>
      let rn ← natLit r
      let (v, ha) ← lookupVar ρ a
      let some (i, args) ← A.find ``Braid.Atom.reg fun args => return (← natLit? args[0]!) == some rn
        | throwError "braid_sym: the symbolic state has no atom for register {rn}"
      let A' := A.set i (mkApp2 (mkConst ``Braid.Atom.reg) args[0]! v)
      let m ← cont ρ A' u
      g.assign (rule ``Rule.set #[A'.expr, c.Φ, a, r, args[1]!, v, ha, A.updProof A' i, m])
      next m rest ρ A' u
    | Braid.Op.getf d f =>
      let fn ← natLit f
      let (i, _, b?) ← findFlag A fn
      let some b := b?
        | throwError "braid_sym: flag {fn} is read while it holds no known value"
      let r ← norm c.N (mkApp (mkConst ``Braid.ofBool) b)
      let ρ' := mkSet ρ d r.expr
      let m ← cont ρ' A u
      g.assign (rule ``Rule.getf #[c.Φ, d, f, b, r.expr, A.atProof i, ← eqProof r, m])
      next m rest ρ' A u
    | Braid.Op.setf f a =>
      let fn ← natLit f
      let (va, ha) ← lookupVar ρ a
      let (i, fa, b?) ← findFlag A fn
      let r ← norm c.N (mkApp (mkConst ``Rule.bnz) va)
      let A' := A.set i (mkApp2 (mkConst ``Braid.Atom.flag) fa r.expr)
      let m ← cont ρ A' u
      match b? with
      | some b₀ =>
        g.assign (rule ``Rule.setf
          #[A'.expr, c.Φ, a, f, va, b₀, r.expr, ha, ← eqProof r, A.updProof A' i, m])
      | none =>
        g.assign (rule ``Rule.setf_any
          #[A'.expr, c.Φ, a, f, va, r.expr, ha, ← eqProof r, A.updProof A' i, m])
      next m rest ρ A' u
    | Braid.Op.load d W a =>
      let (addr, ha) ← lookupVar ρ a
      let some (i, args) ←
          (do match ← A.find ``Braid.Atom.mem fun args => return args[0]! == addr with
              | some r => pure (some r)
              | none => A.find ``Braid.Atom.mem fun args => AtomList.sameAddr args[0]! addr)
        | throwError "braid_sym: the symbolic state has no memory atom at {addr}"
      let addr := args[0]!
      let n := args[1]!
      let v := args[2]!
      let r ← norm c.N (mkApp2 (mkConst ``Rule.ld) W v)
      let ρ' := mkSet ρ d r.expr
      let u' := if c.lab then snoc u (mkApp2 (mkConst ``Braid.Label.read) addr n) else u
      let m ← cont ρ' A u'
      g.assign (rule ``Rule.load #[c.Φ, d, a, W, addr, v, r.expr, n, args[3]!, ha,
        A.atProof i, ← mkEqRefl n, ← eqProof r, m])
      next m rest ρ' A u'
    | Braid.Op.store W a x =>
      let (addr, ha) ← lookupVar ρ a
      let (xv, hx) ← lookupVar ρ x
      let writable (args : Array Expr) : MetaM Bool :=
        return (← whnfR args[3]!).isConstOf ``Bool.true
      let some (i, args) ←
          (do match ← A.find ``Braid.Atom.mem fun args =>
                  return args[0]! == addr && (← writable args) with
              | some r => pure (some r)
              | none => A.find ``Braid.Atom.mem fun args =>
                  return (← AtomList.sameAddr args[0]! addr) && (← writable args))
        | throwError "braid_sym: the symbolic state has no writable memory atom at {addr}"
      let addr := args[0]!
      let n := args[1]!
      let tt := mkConst ``Bool.true
      let A' := A.set i (mkApp4 (mkConst ``Braid.Atom.mem) addr n xv tt)
      let u' := if c.lab then snoc u (mkApp2 (mkConst ``Braid.Label.write) addr n) else u
      let m ← cont ρ A' u'
      g.assign (rule ``Rule.store #[A'.expr, c.Φ, a, x, W, addr, args[2]!, xv, n, ha, hx,
        A.updProof A' i, ← mkEqRefl n, m])
      next m rest ρ A' u'
    | Braid.Op.havoc d =>
      -- An undefined flag: `havoc d`, `setf f d`, and `d` not read again.
      let t := c.tm
      if rest.isAppOfArity ``List.cons 3 then
        let op₂ := rest.getArg! 1
        let rest₂ := rest.getArg! 2
        if op₂.isAppOfArity ``Braid.Op.setf 2 then
          let dn ← natLit d
          if (← natLit? (op₂.getArg! 1)) == some dn && (← deadIn dn rest₂ t) then
            let f := op₂.getArg! 0
            let (i, fa, b?) ← findFlag A (← natLit f)
            let hle := match b? with
              | some b => mkApp2 (mkConst ``Rule.flag_any) fa b
              | none => mkApp (mkConst ``Rule.any_any) fa
            let any := mkApp (mkConst ``Braid.Atom.prop) (mkApp (mkConst ``Braid.flagAny) fa)
            let A' := A.set i any
            let m ← mkFreshExprSyntheticOpaqueMVar (mkOps c rest₂ ρ A' u)
            g.assign (mkAppN (mkConst (c.nm ``Rule.havoc_setf)) (#[rest₂, ρ, A.expr] ++ c.tr u ++
              #[A'.expr, t, c.Ψ, d, f, A.atoms[i]!, hle, boolFalseRefl, A.updProof A' i, m]))
            return ← next m rest₂ ρ A' u
      let body :=
        if c.lab then mkApp5 (mkConst ``Braid.OpsSpecT) rest (mkSet ρ d (mkBVar 0)) A.expr u c.Φ
        else mkApp4 (mkConst ``Braid.OpsSpec) rest (mkSet ρ d (mkBVar 0)) A.expr c.Φ
      let m ← mkFreshExprSyntheticOpaqueMVar (mkForall `v .default (mkConst ``Braid.Word) body)
      g.assign (rule ``Rule.havoc #[c.Φ, d, m])
      let (fv, g') ← m.mvarId!.intro1
      runOps c g' rest (mkSet ρ d (mkFVar fv)) A u
    | Braid.Op.guard cv =>
      let (vc, hc) ← lookupVar ρ cv
      let hne ← discharge c.N (mkApp (mkConst ``Rule.nz) vc)
      let m ← cont ρ A u
      g.assign (rule ``Rule.guard #[c.Φ, cv, vc, hc, hne, m])
      next m rest ρ A u
    | _ => throwError "braid_sym: not an operation written out: {op}"
  | _ =>
    -- A long list is written in parts: a `have` for each stretch of it, or parts appended.
    let ops' ← whnf ops
    if ops'.isAppOf ``List.cons || ops'.isAppOf ``List.nil then runOps c g ops' ρ A u
    else throwError "braid_sym: not a list of operations written out: {ops}"

/-- The table of blocks of the program of a run. -/
abbrev Tables := IO.Ref (Option BlockTable)

def tableOf (T : Tables) (P : Expr) : MetaM BlockTable := do
  if let some t ← T.get then
    if t.P == P then return t
  let t ← BlockTable.build P
  T.set (some t)
  return t

/-- The program, precondition and postcondition of a triple, and for a traced triple the
trace before and the trace after. -/
def tripleParts (g : MVarId) : MetaM (Expr × Expr × Expr × Option (Expr × Expr)) := do
  let ty ← instantiateMVars (← g.getType)
  match_expr ty with
  | Braid.Triple P pre post => return (P, pre, post, none)
  | Braid.TripleT P pre t post t' => return (P, pre, post, some (t, t'))
  | _ => throwError "braid_sym: the goal is not a triple"

/-- Run the block at the program counter. The goals left are triples. -/
def stepBlock (N : Norm) (T : Tables) (g : MVarId) : TacticM (List MVarId) := g.withContext do
  let (P, pre, post, tr?) ← tripleParts g
  let_expr Braid.Atoms.interp as := pre
    | throwError "braid_sym: the precondition is not a list of atoms"
  let A ← AtomList.parse as
  let some (i, pcArgs) ← A.find ``Braid.Atom.pc fun _ => pure true
    | throwError "braid_sym: the symbolic state has no program counter"
  let p := pcArgs[0]!
  let some ⟨_, pv⟩ ← getBitVecValue? p
    | throwError "braid_sym: the program counter is not a literal: {p}"
  let some (ops, t, hb) ← (← tableOf T P).get pv.toNat
    | throwError "braid_sym: the program has no block at {p}"
  let atoms := mkApp (mkConst ``List [0]) atomTy
  let zero := mkApp2 (mkConst ``BitVec.ofNat) (mkNatLit 64) (mkNatLit 0)
  let ρ := mkLambda `x .default (mkConst ``Braid.Var) zero
  match tr? with
  | none =>
    let Ψ := mkLambda `as .default atoms (mkTriple P (mkBVar 0) post)
    let Φ := mkLambda `ρ .default (mkConst ``Braid.Env) <| mkLambda `as .default atoms <|
      mkApp4 (mkConst ``Braid.TermSpec) t (mkBVar 1) (mkBVar 0) Ψ
    let c : Ctx := { N, P, post, Ψ, Φ, tm := t }
    let m ← mkFreshExprSyntheticOpaqueMVar (mkOps c ops ρ A zero)
    g.assign (mkAppN (mkConst ``Rule.block) #[P, A.expr, post, p, ops, t, A.atProof i, hb, m])
    runOps c m.mvarId! ops ρ A zero
  | some (u, tEnd) =>
    let trace := mkApp (mkConst ``List [0]) labelTy
    let Ψ := mkLambda `as .default atoms <| mkLambda `u .default trace <|
      mkApp5 (mkConst ``Braid.TripleT) P (mkApp (mkConst ``Braid.Atoms.interp) (mkBVar 1))
        (mkBVar 0) post tEnd
    let Φ := mkLambda `ρ .default (mkConst ``Braid.Env) <| mkLambda `as .default atoms <|
      mkLambda `u .default trace <|
        mkApp5 (mkConst ``Braid.TermSpecT) t (mkBVar 2) (mkBVar 1) (mkBVar 0) Ψ
    let c : Ctx := { N, P, post, Ψ, Φ, tm := t, lab := true, tEnd }
    let m ← mkFreshExprSyntheticOpaqueMVar (mkOps c ops ρ A u)
    g.assign (mkAppN (mkConst ``RuleT.block)
      #[P, A.expr, u, post, tEnd, p, ops, t, A.atProof i, hb, m])
    runOps c m.mvarId! ops ρ A u

/-- Run the block at the program counter, or change nothing and say why not. -/
def tryStep (N : Norm) (T : Tables) (g : MVarId) : TacticM (Except Exception (List MVarId)) := do
  let s ← saveState
  try
    return .ok (← withCurrHeartbeats (stepBlock N T g))
  catch e =>
    s.restore
    return .error e

/-- Run the block at the program counter on the symbolic state. A conditional branch leaves
a goal for each direction the condition allows, with the condition as the hypothesis `hbr`. -/
elab "braid_sym_step_core" : tactic => do
  let N ← Norm.make
  let T ← IO.mkRef none
  let g ← getMainGoal
  match ← tryStep N T g with
  | .ok gs => replaceMainGoal gs
  | .error e => throw e

/-- Run blocks for as long as the program has one at the program counter and execution goes
one way. It stops, without failing, where a step cannot be taken. -/
elab "braid_sym_run_core" : tactic => do
  let N ← Norm.make
  let T ← IO.mkRef none
  let mut g ← getMainGoal
  -- The fact that the blocks are in address order is proved once, as a hypothesis.
  let mut hyp : Option FVarId := none
  let tbl? ← try some <$> (do tableOf T (← tripleParts g).1) catch _ => pure none
  if let some tbl := tbl? then
    if let some pf := tbl.table? then
      let ty := mkApp2 (mkConst ``Rule.Table) tbl.P tbl.l
      let (fv, g') ← (← g.assert `braid_table ty pf).intro1
      T.set (some { tbl with table? := some (mkFVar fv) })
      g := g'
      hyp := some fv
  let mut out := [g]
  repeat
    match ← tryStep N T g with
    | .ok [g'] => g := g'; out := [g']
    | .ok gs => out := gs; break
    | .error _ => break
  if let some fv := hyp then
    out ← out.mapM fun g => do try g.clear fv catch _ => pure g
  replaceMainGoal out

/-- Run the block at the program counter on the symbolic state. -/
macro "braid_sym_step" : tactic =>
  `(tactic| first | braid_sym_step_core | (braid_norm; braid_sym_step_core))

/-- Run blocks for as long as the program has one at the program counter and execution goes
one way. -/
macro "braid_sym_run" : tactic =>
  `(tactic| ((first | braid_sym_step | skip); braid_sym_run_core))

end Braid.Sym
