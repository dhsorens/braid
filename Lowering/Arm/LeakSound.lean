/-
  Lowering.Arm.LeakSound

  The AArch64 lowering preserves traces: the labels the block of an instruction emits are the
  labels of the instruction (`Lowering.Arm.Leak`), so a labelled run of the lowered code is a
  run of the machine with the same trace.

  The proof does not redo the proof that the lowering is sound. The labels of a block are a
  function of the state it starts from (`Block.leak`), computed by `runOps`. Most blocks have
  none, because none of their operations has one (`silent`, `runOps_silent`). For the others,
  what is needed is the value of the address, the condition or the operands when the labelled
  operation runs; the values of the lowering's groups of operations are read off the lemmas
  of `Lowering.Arm.Rel` about their weakest preconditions (`env_of_wp`).

  `leak` says nothing of the instructions the lowering turns into a `trap`. A block that
  runs is not a `trap`, so `leak_lower` covers every instruction of a run of lowered code.

  ## Main results

  * `leak_lower`: the labels of a lowered instruction are those of the instruction
  * `lowerProgram_soundL`: every labelled run, `EventuallyL` to `RunL`
  * `RunL.steps`: a run with a trace is a run
-/

module

public import Lowering.Arm.Sound
public import Lowering.Arm.Leak

public section

namespace Lowering.Arm

open Braid
open Arm64 (Instr RegWidth MemWidth CondCode ShiftType ExtendType AddrMode AddSubOp LogicalOp
  MoveWideOp BitfieldOp CondSelectOp DataProc1Op DataProc2Op DataProc3Op SimdMemSize)

variable {s : Arm64.State} {σ : State}

/-! ## Operations without labels -/

/-- The operation has no label: it is not a load, a store, a division or an `out`. -/
def silent : Op → Bool
  | .load .. | .store .. | .out .. => false
  | .bin _ op _ _ => !op.leaks
  | _ => true

theorem leak_of_silent {op : Op} (h : silent op = true) (ρ : Env) (σ : State) :
    op.leak ρ σ = [] := by
  cases op <;> simp_all [silent, Op.leak]

/-- Operations without labels have an empty trace. -/
theorem runOps_silent {ops : List Op} (h : ops.all silent = true) (ρ : Env) (σ : State)
    (hv : Nat → Word) : (runOps ops ρ σ hv).2.2 = [] := by
  induction ops generalizing ρ σ hv with
  | nil => rfl
  | cons op ops ih =>
    simp only [List.all_cons, Bool.and_eq_true] at h
    simp only [runOps_cons, ih h.2, leak_of_silent h.1, List.append_nil]

/-- A block whose operations have no labels and that ends in a direct jump has none. -/
theorem leak_of_silent_jump {ops : List Op} (h : ops.all silent = true) (a : Word) (σ : State)
    (hv : Nat → Word) : (Block.mk ops (.jump a)).leak σ hv = [] := by
  simp only [Block.leak, runOps_silent h, Term.leak_jump, List.append_nil]

theorem silent_rget (d : Var) (r : Arm64.Reg) : silent (rget d r) = true := by
  cases r <;> simp only [rget] <;> first | rfl | (split <;> rfl)

theorem all_silent_rset (r : Arm64.Reg) (a : Var) : (rset r a).all silent = true := by
  cases r <;> simp only [rset] <;> first | rfl | (split <;> rfl)

/-- The step has no label: it is not a division. -/
def Stage.quiet : Stage → Bool
  | .un _ => true
  | .binc op _ => !op.leaks

theorem all_silent_stage (st : Stage) (res cur n : Var) :
    (st.ops res cur n).all silent = st.quiet := by
  cases st <;> simp [Stage.ops, silent, Stage.quiet]

theorem all_silent_chainFrom {sts : List Stage} (h : sts.all Stage.quiet = true)
    (d cur n : Var) : (chainFrom d cur n sts).all silent = true := by
  induction sts generalizing cur n with
  | nil => rfl
  | cons st sts ih =>
    simp only [List.all_cons, Bool.and_eq_true] at h
    cases sts with
    | nil => simp only [chainFrom, all_silent_stage, h.1]
    | cons st' sts' =>
      simp only [chainFrom, List.all_append, all_silent_stage, h.1, ih h.2, Bool.and_self]

theorem all_silent_chain {first : Var → Op} {sts : List Stage}
    (hf : ∀ x, silent (first x) = true) (h : sts.all Stage.quiet = true) (d : Var) :
    (chain d first sts).all silent = true := by
  cases sts with
  | nil => simp [chain, hf]
  | cons st sts => simp [chain, hf, all_silent_chainFrom h]

theorem quiet_shiftStages (w : RegWidth) (sh : ShiftType) (amount : Nat) :
    (shiftStages w sh amount).all Stage.quiet = true := by
  cases w <;> simp only [shiftStages] <;> split <;> cases sh <;> rfl

theorem quiet_extStages (w : RegWidth) (ext : ExtendType) (amount : Nat) :
    (extStages w ext amount).all Stage.quiet = true := by
  simp only [extStages, List.all_append, Bool.and_eq_true]
  refine ⟨⟨?_, ?_⟩, ?_⟩
  · cases w <;> cases ext <;> rfl
  · split
    · rfl
    · split <;> rfl
  · cases w <;> rfl

theorem quiet_loadStages (w : RegWidth) (sz : MemWidth) (signed : Bool) :
    (loadStages w sz signed).all Stage.quiet = true := by
  cases w <;> cases sz <;> cases signed <;> rfl

theorem quiet_cselStages (w : RegWidth) (op : CondSelectOp) :
    (cselStages w op).all Stage.quiet = true := by
  cases w <;> cases op <;> rfl

theorem all_silent_rgetW (d : Var) (w : RegWidth) (r : Arm64.Reg) :
    (rgetW d w r).all silent = true := by
  cases w <;> exact all_silent_chain (fun _ => silent_rget _ _) rfl d

theorem all_silent_condOps (d : Var) (cond : CondCode) : (condOps d cond).all silent = true := by
  cases cond <;> rfl

theorem all_silent_flagOps (d : Var) (w : RegWidth) (isSub : Bool) (x y : Var) :
    (flagOps d w isSub x y).all silent = true := by
  cases w <;> cases isSub <;> rfl

theorem all_silent_addSubOps (d : Var) (w : RegWidth) (op : AddSubOp) (x y : Var) :
    (addSubOps d w op x y).all silent = true := by
  cases w <;> cases op <;>
    simp [addSubOps, List.all_append, all_silent_flagOps, setNZCV, silent, BinOp.leaks]

theorem all_silent_logicOps (d : Var) (w : RegWidth) (op : LogicalOp) (x y : Var) :
    (logicOps d w op x y).all silent = true := by
  cases w <;> cases op <;> rfl

theorem silent_const (d : Var) (v : Word) : silent (.const d v) = true := by rfl

theorem silent_add (d a b : Var) : silent (.bin d .add a b) = true := by rfl

theorem all_silent_baseOps (d : Var) (base : Arm64.Reg) :
    (baseOps d base).all silent = true := by
  cases base <;> simp only [baseOps, List.all_cons, silent_rget, Bool.true_and] <;> rfl

theorem all_silent_addrOps (d : Var) (addr : AddrMode) : (addrOps d addr).all silent = true := by
  cases addr <;> simp only [addrOps]
  case RegOffset =>
    simp only [List.all_append, List.all_cons, List.all_nil, all_silent_baseOps, silent_add,
      all_silent_chain (fun _ => silent_rget _ _) (quiet_extStages ..), Bool.and_self]
  all_goals first
    | (split <;>
        simp only [List.all_append, List.all_cons, List.all_nil, all_silent_baseOps,
          silent_add, silent_const, Bool.and_self])
    | simp only [List.all_append, List.all_cons, List.all_nil, all_silent_baseOps,
        all_silent_rset, silent_add, silent_const, Bool.and_self]

/-! ## The values of operations that cannot fault -/

/-- The operation cannot fault and takes no value from outside: it is not a load, a store, a
`havoc`, a `guard` or an `out`. -/
def total : Op → Bool
  | .load .. | .store .. | .havoc _ | .guard _ | .out .. => false
  | _ => true

/-- Operations that cannot fault run, to the values and the state `runOps` computes. -/
theorem wpOps_of_total {ops : List Op} (h : ops.all total = true) (ρ : Env) (σ : State)
    (hv : Nat → Word) {Q : Env → State → Prop}
    (hq : Q (runOps ops ρ σ hv).1 (runOps ops ρ σ hv).2.1) : wpOps ops ρ σ Q := by
  induction ops generalizing ρ σ hv with
  | nil => exact hq
  | cons op ops ih =>
    simp only [List.all_cons, Bool.and_eq_true] at h
    rw [runOps_cons] at hq
    cases op <;> first | exact ih h.2 _ _ _ hq | simp [total] at h

/-- The values after a group of operations that cannot fault, from a lemma about its weakest
precondition. -/
theorem env_of_wp {ops : List Op} (h : ops.all total = true) {ρ : Env} {σ : State} {d : Nat}
    {v : Word}
    (hwp : ∀ Q : Env → State → Prop, wpOps (ops ++ []) ρ σ Q →
      ∃ ρ₁, wpOps [] (envExt ρ d v ρ₁) σ Q) (hv : Nat → Word) :
    ∃ ρ₁, (runOps ops ρ σ hv).1 = envExt ρ d v ρ₁ := by
  obtain ⟨ρ₁, e⟩ := hwp (fun ρ' _ => (runOps ops ρ σ hv).1 = ρ')
    (by rw [List.append_nil]; exact wpOps_of_total h ρ σ hv rfl)
  exact ⟨ρ₁, e⟩

theorem total_rget (d : Var) (r : Arm64.Reg) : total (rget d r) = true := by
  cases r <;> simp only [rget] <;> first | rfl | (split <;> rfl)

theorem all_total_chainFrom (sts : List Stage) (d cur n : Var) :
    (chainFrom d cur n sts).all total = true := by
  induction sts generalizing cur n with
  | nil => rfl
  | cons st sts ih =>
    have hst : ∀ res cur n, (st.ops res cur n).all total = true := fun _ _ _ => by
      cases st <;> rfl
    cases sts with
    | nil => simp only [chainFrom, hst]
    | cons st' sts' => simp only [chainFrom, List.all_append, hst, ih, Bool.and_self]

theorem all_total_chain_rget (d : Var) (r : Arm64.Reg) (sts : List Stage) :
    (chain d (rget · r) sts).all total = true := by
  cases sts with
  | nil => simp [chain, total_rget]
  | cons st sts => simp [chain, total_rget, all_total_chainFrom]

theorem all_total_rgetW (d : Var) (w : RegWidth) (r : Arm64.Reg) :
    (rgetW d w r).all total = true := by
  cases w <;> exact all_total_chain_rget ..

theorem all_total_condOps (d : Var) (cond : CondCode) : (condOps d cond).all total = true := by
  cases cond <;> rfl

/-! ## Registers, conditions and addresses -/

/-- Reading a register gives the machine's value. -/
theorem rget_next (h : Rel s σ) (d : Var) (r : Arm64.Reg) (ρ : Env) (x : Word) :
    (rget d r).next ρ σ x = (ρ.set d (s.readReg64 r), σ) := by
  cases r with
  | gpr i =>
    simp only [rget, Arm64.State.readReg64, beq_iff_eq]
    split
    · rfl
    · rename_i hi; simp only [Op.next_get, h.regs i hi]
  | sp => simp only [rget, Op.next_get, h.sp, Arm64.State.readReg64]
  | xzr => rfl

/-- The values after a chain from a register. -/
theorem chain_rget_env (h : Rel s σ) (d : Var) (r : Arm64.Reg) (sts : List Stage) (ρ : Env)
    (hv : Nat → Word) :
    ∃ ρ₁, (runOps (chain d (rget · r) sts) ρ σ hv).1 =
      envExt ρ d (Stage.run sts (s.readReg64 r)) ρ₁ :=
  env_of_wp (all_total_chain_rget d r sts) (fun _ hw => wp_chain_rget h hw) hv

/-- The value of a register read at a width. -/
theorem rgetW_env (h : Rel s σ) (d : Var) (w : RegWidth) (r : Arm64.Reg) (ρ : Env)
    (hv : Nat → Word) : (runOps (rgetW d w r) ρ σ hv).1 d = s.readReg w r := by
  obtain ⟨ρ₁, e⟩ := env_of_wp (all_total_rgetW d w r) (fun _ hw => wp_rgetW h hw) hv
  rw [e, envExt_self]

/-- The value of a condition. -/
theorem condOps_env (h : Rel s σ) (d : Var) (cond : CondCode) (ρ : Env) (hv : Nat → Word) :
    (runOps (condOps d cond) ρ σ hv).1 d = ofBool (Arm64.ConditionHolds cond s.pstate) := by
  obtain ⟨ρ₁, e⟩ := env_of_wp (all_total_condOps d cond) (fun _ hw => wp_condOps h hw) hv
  rw [e, envExt_self]

/-- Reading the base register of an access: its value, and the state is as it was. -/
theorem baseOps_run (h : Rel s σ) (d : Var) (base : Arm64.Reg) (ρ : Env) (hv : Nat → Word) :
    (runOps (baseOps d base) ρ σ hv).1 d = s.readReg64 base ∧
      (runOps (baseOps d base) ρ σ hv).2.1 = σ := by
  cases base <;> simp [baseOps, runOps_cons, rget_next h]

@[simp] theorem runOps_rset_env (r : Arm64.Reg) (a : Var) (ρ : Env) (σ : State)
    (hv : Nat → Word) : (runOps (rset r a) ρ σ hv).1 = ρ := by
  cases r <;> simp only [rset] <;> first | rfl | (split <;> rfl)

/-- The address of an access is the one the model computes. -/
theorem addrOps_env (h : Rel s σ) (d : Var) (addr : AddrMode) (ρ : Env) (hv : Nat → Word) :
    (runOps (addrOps d addr) ρ σ hv).1 d = ea s addr := by
  have plain : ∀ (base : Arm64.Reg) (off : Word),
      (runOps (if off = 0 then baseOps d base
        else baseOps (d + 1) base ++ [.const (d + 6) off, .bin d .add (d + 1) (d + 6)])
        ρ σ hv).1 d = s.readReg64 base + off := by
    intro base off
    split
    · rename_i h0; simp [(baseOps_run h d base ρ hv).1, h0]
    · simp [runOps_append, runOps_cons, (baseOps_run h (d + 1) base ρ hv).1]
  cases addr with
  | Offset base off => exact plain base off
  | UnscaledOffset base off => exact plain base off
  | PreIndex base off =>
    simp [addrOps, ea, Arm64.evalAddrMode, runOps_append, runOps_cons,
      (baseOps_run h (d + 1) base ρ hv).1]
  | PostIndex base off =>
    simp [addrOps, ea, Arm64.evalAddrMode, runOps_append, runOps_cons,
      (baseOps_run h d base ρ hv).1]
  | RegOffset base index ext amount =>
    obtain ⟨hb, hs⟩ := baseOps_run h (d + 1) base ρ hv
    simp only [addrOps, runOps_append, hs]
    obtain ⟨ρ₁, e⟩ := chain_rget_env h (d + 6) index (extStages .W64 ext amount)
      (runOps (baseOps (d + 1) base) ρ σ hv).1 (fun i => hv (i + (baseOps (d + 1) base).length))
    simp [runOps_cons, e, envExt_self, envExt_lt, hb, run_extStages, ea, Arm64.evalAddrMode]

/-! ## The groups without labels -/

@[local simp] theorem silent_un (d a : Var) (op : UnOp) : silent (.un d op a) = true := by rfl
@[local simp] theorem silent_bin (d a b : Var) (op : BinOp) :
    silent (.bin d op a b) = !op.leaks := by rfl
@[local simp] theorem silent_select (d c a b : Var) : silent (.select d c a b) = true := by rfl
@[local simp] theorem silent_get (d : Var) (r : Reg) : silent (.get d r) = true := by rfl
@[local simp] theorem silent_set (r : Reg) (a : Var) : silent (.set r a) = true := by rfl
@[local simp] theorem silent_getf (d : Var) (f : Flag) : silent (.getf d f) = true := by rfl
@[local simp] theorem silent_setf (f : Flag) (a : Var) : silent (.setf f a) = true := by rfl
@[local simp] theorem silent_load (d a : Var) (w : Width) : silent (.load d w a) = false := by rfl
@[local simp] theorem silent_store (a v : Var) (w : Width) :
    silent (.store w a v) = false := by rfl

attribute [local simp] silent_const BinOp.leaks silent_rget all_silent_rset all_silent_rgetW
  all_silent_condOps all_silent_flagOps all_silent_addSubOps all_silent_logicOps
  all_silent_baseOps all_silent_addrOps setNZCV vget vset

@[local simp] theorem all_silent_chain_rget {sts : List Stage} (h : sts.all Stage.quiet = true)
    (d : Var) (r : Arm64.Reg) : (chain d (rget · r) sts).all silent = true :=
  all_silent_chain (fun _ => silent_rget _ _) h d

attribute [local simp] quiet_shiftStages quiet_extStages quiet_cselStages

@[local simp] theorem all_silent_bfOps (w : RegWidth) (op : BitfieldOp) (rd rn : Arm64.Reg)
    (immr imms : Nat) : (bfOps w op rd rn immr imms).all silent = true := by
  simp only [bfOps]
  repeat' split
  all_goals simp

@[local simp] theorem all_silent_extrOps (w : RegWidth) (rn rm : Arm64.Reg) (lsb : Nat) :
    (extrOps w rn rm lsb).all silent = true := by
  cases w <;> simp only [extrOps] <;> split <;> simp

@[local simp] theorem all_silent_adcOps (w : RegWidth) (op : AddSubOp) :
    (adcOps w op).all silent = true := by
  cases w <;> cases op <;> rfl

@[local simp] theorem all_silent_ccmpOps (w : RegWidth) (isSub : Bool) (nzcv : BitVec 4) :
    (ccmpOps w isSub nzcv).all silent = true := by
  simp [ccmpOps]

@[local simp] theorem all_silent_dp3Ops (w : RegWidth) (op : DataProc3Op)
    (rn rm ra : Arm64.Reg) : (dp3Ops w op rn rm ra).all silent = true := by
  cases w <;> cases op <;> simp [dp3Ops]

theorem all_silent_dp1Ops {w : RegWidth} {op : DataProc1Op} {ops : List Op}
    (h : dp1Ops w op = some ops) : ops.all silent = true := by
  cases w <;> cases op <;> simp only [dp1Ops, Option.some.injEq] at h <;> subst h <;> rfl

theorem all_silent_fmovOps {sf : Bool} {ftype rmode : BitVec 2} {opcode : BitVec 3}
    {rn rd : Arm64.VReg} {ops : List Op} (h : fmovOps sf ftype rmode opcode rn rd = some ops) :
    ops.all silent = true := by
  simp only [fmovOps] at h
  repeat' split at h
  all_goals first | (cases h; done) | (cases h; simp)

theorem all_silent_fpMovOps {ftype : BitVec 2} {opcode : BitVec 6} {rn rd : Arm64.VReg}
    {ops : List Op} (h : fpMovOps ftype opcode rn rd = some ops) : ops.all silent = true := by
  simp only [fpMovOps] at h
  repeat' split at h
  all_goals first | (cases h; done) | (cases h; simp)

theorem all_silent_fpImmOps {ftype : BitVec 2} {imm8 : BitVec 8} {rd : Arm64.VReg}
    {ops : List Op} (h : fpImmOps ftype imm8 rd = some ops) : ops.all silent = true := by
  simp only [fpImmOps] at h
  repeat' split at h
  all_goals first | (cases h; done) | (cases h; simp)

theorem all_silent_fcselOps {ftype : BitVec 2} {rm : Arm64.VReg} {cond : BitVec 4}
    {rn rd : Arm64.VReg} {ops : List Op} (h : fcselOps ftype rm cond rn rd = some ops) :
    ops.all silent = true := by
  simp only [fcselOps] at h
  repeat' split at h
  all_goals first | (cases h; done) | (cases h; simp)

theorem all_silent_notOps {q u : Bool} {size : BitVec 2} {opcode : BitVec 5}
    {rn rd : Arm64.VReg} {ops : List Op} (h : notOps q u size opcode rn rd = some ops) :
    ops.all silent = true := by
  simp only [notOps] at h
  split at h
  · simp only [Option.some.injEq] at h; subst h; cases q <;> simp
  · cases h

theorem all_silent_insDupOps {q op : Bool} {imm5 : BitVec 5} {imm4 : BitVec 4}
    {rn rd : Arm64.VReg} {ops : List Op} (h : insDupOps q op imm5 imm4 rn rd = some ops) :
    ops.all silent = true := by
  simp only [insDupOps] at h
  repeat' split at h
  all_goals first | (cases h; done) | (cases h; simp)

theorem all_silent_immShiftOps {q op : Bool} {immh : BitVec 4} {immb : BitVec 3}
    {opc : BitVec 5} {rn rd : Arm64.VReg} {ops : List Op}
    (h : immShiftOps q op immh immb opc rn rd = some ops) : ops.all silent = true := by
  simp only [immShiftOps] at h
  split at h
  · split at h
    · cases hm : moviImm op (opc.extractLsb' 1 4) (immb ++ rn) with
      | none => simp [hm] at h
      | some d64 =>
        simp only [hm, Option.map_some, Option.some.injEq] at h
        subst h
        simp
    · cases h
  · cases hs : laneShift q op immh opc with
    | none => simp [hs] at h
    | some sop =>
      simp only [hs, Option.map_some, Option.some.injEq] at h
      subst h
      cases sop <;> cases q <;> simp [shiftOps, LaneShift.ops, LaneShift.readsDst]

theorem all_silent_swapOps (g : Nat) (d x : Var) : (swapOps g d x).all silent = true := by
  simp [swapOps]

theorem all_silent_revOps (gs : List Nat) (d x : Var) : (revOps gs d x).all silent = true := by
  induction gs generalizing d x with
  | nil => rfl
  | cons g gs ih => simp [revOps, all_silent_swapOps, ih]

theorem all_silent_revVecOps (gs : List Nat) (q : Bool) (rn rd : Arm64.VReg) :
    (revVecOps gs q rn rd).all silent = true := by
  cases q <;> simp [revVecOps, all_silent_revOps]

theorem all_silent_extOps {q : Bool} {rm : Arm64.VReg} {imm4 : BitVec 4} {rn rd : Arm64.VReg}
    {ops : List Op} (h : extOps q rm imm4 rn rd = some ops) : ops.all silent = true := by
  simp only [extOps] at h
  repeat' split at h
  all_goals first | (cases h; done) | (cases h; simp [extWord])

@[local simp] theorem all_silent_vecOps (op : VecOp) (q : Bool) (rm rn rd : Arm64.VReg) :
    (vecOps op q rm rn rd).all silent = true := by
  cases op <;> cases q <;> simp [vecOps, VecOp.ops]

/-! ## The labels of a lowered instruction -/

@[local simp] theorem runOps_rset_leak (r : Arm64.Reg) (a : Var) (ρ : Env) (σ : State)
    (hv : Nat → Word) : (runOps (rset r a) ρ σ hv).2.2 = [] :=
  runOps_silent (all_silent_rset r a) ρ σ hv

@[local simp] theorem runOps_addrOps_leak (d : Var) (addr : AddrMode) (ρ : Env) (σ : State)
    (hv : Nat → Word) : (runOps (addrOps d addr) ρ σ hv).2.2 = [] :=
  runOps_silent (all_silent_addrOps d addr) ρ σ hv

@[local simp] theorem runOps_baseOps_leak (d : Var) (base : Arm64.Reg) (ρ : Env) (σ : State)
    (hv : Nat → Word) : (runOps (baseOps d base) ρ σ hv).2.2 = [] :=
  runOps_silent (all_silent_baseOps d base) ρ σ hv

@[local simp] theorem runOps_condOps_leak (d : Var) (cond : CondCode) (ρ : Env) (σ : State)
    (hv : Nat → Word) : (runOps (condOps d cond) ρ σ hv).2.2 = [] :=
  runOps_silent (all_silent_condOps d cond) ρ σ hv

@[local simp] theorem runOps_rgetW_leak (d : Var) (w : RegWidth) (r : Arm64.Reg) (ρ : Env)
    (σ : State) (hv : Nat → Word) : (runOps (rgetW d w r) ρ σ hv).2.2 = [] :=
  runOps_silent (all_silent_rgetW d w r) ρ σ hv

@[local simp] theorem rget_leak (d : Var) (r : Arm64.Reg) (ρ : Env) (σ : State) :
    (rget d r).leak ρ σ = [] :=
  leak_of_silent (silent_rget d r) ρ σ

/-- A load followed by steps without labels has the label of the load. -/
theorem runOps_chain_load_leak {sts : List Stage} (h : sts.all Stage.quiet = true) (d a : Var)
    (w : Width) (ρ : Env) (σ : State) (hv : Nat → Word) :
    (runOps (chain d (.load · w a) sts) ρ σ hv).2.2 = [.read (ρ a) w.bytes] := by
  cases sts with
  | nil => simp [chain, runOps_cons]
  | cons st sts => simp [chain, runOps_cons, runOps_silent (all_silent_chainFrom h ..)]

/-- A `trap` does not run. -/
theorem not_wp_trap {r : String} {Q : State → Prop} (hw : (Block.mk [] (.trap r)).wp σ Q) :
    False := by
  simp only [Block.wp, wpOps, Term.wp] at hw

/-- **The labels of a lowered instruction are those of the instruction.** For an instruction
whose block runs, so that it is not one the lowering turns into a `trap`, `leak` gives the
labels the block emits, whatever values its `havoc`s take. -/
theorem leak_lower (h : Rel s σ) (i : Instr) (hv : Nat → Word) {Q : State → Prop}
    (hw : (lower s.pc i).wp σ Q) : leak s i = some ((lower s.pc i).leak σ hv) := by
  cases i
  case nop | hint | barrier | prfm | prfmLit | b => rfl
  case adr | addSubImm | addSubShift | logicalImm | logicalShift | bl | bitfield | extr
      | addSubExt | addSubCarry | condCompareReg | condCompareImm | condSelect | dataProc3
      | simdAddpScalar =>
    simp only [lower, leak]
    rw [leak_of_silent_jump (by simp)]
  case sysReg | dcZva | system | udf | crc32 | stxr | ldxp | stxp | cas | casp | ldapurStlur
      | ldrSimdLit | st1SinglePost | simdLdSt1Single | simdLdSt1Multi | simdLdStMulti | simdLd1r
      | fpDataProc2 | fpCompare | fpCondCompare | fpDataProc3 | fpFixedConv | simdAcrossLanes
      | simdPermute | simdTbl | simdDupScalar | simdPmull | simdThreeDiff | aes
      | cryptoSha2Reg | cryptoSha3Reg | cryptoSha512Reg2 | cryptoSha512Reg3 | cryptoSha3FourReg
      | cryptoXar =>
    exact (not_wp_trap hw).elim
  case moveWide w op rd imm16 hw' =>
    cases op <;> simp only [lower, leak] <;> rw [leak_of_silent_jump (by simp)]
  case bCond cond offset =>
    simp only [lower, leak, Block.leak, runOps_condOps_leak, List.nil_append, Term.leak_branch,
      condOps_env h, target]
    cases Arm64.ConditionHolds cond s.pstate <;> simp
  case cbz w isNonZero rt offset =>
    cases isNonZero <;> by_cases h0 : s.readReg w rt = 0#64 <;>
      simp [lower, leak, Block.leak, target, h0, rgetW_env h]
  case br rn | ret rn => simp [lower, leak, Block.leak, runOps_cons, rget_next h]
  case blr rn => simp [lower, leak, Block.leak, runOps_cons, rget_next h]
  case tbz w isNonZero rt bit offset =>
    cases isNonZero <;>
      cases hb : (s.readReg64 rt).getLsbD bit <;>
      simp [lower, leak, Block.leak, runOps_cons, rget_next h, target, and_twoPow_ne_zero, hb]
  case ldr w sz signed rt addr =>
    simp [lower, leak, Block.leak, runOps_append, runOps_chain_load_leak (quiet_loadStages ..),
      addrOps_env h, memW_bytes]
  case str sz rt addr =>
    simp [lower, leak, Block.leak, runOps_append, runOps_cons, rget_next h, addrOps_env h,
      memW_bytes]
  case dataProc1 w op rd rn =>
    cases hops : dp1Ops w op with
    | none => simp only [lower, hops] at hw; exact (not_wp_trap hw).elim
    | some ops =>
      simp only [lower, hops, leak]
      rw [leak_of_silent_jump (by simp [all_silent_dp1Ops hops])]
  case dataProc2 w op rd rn rm =>
    cases w <;> cases op <;>
      simp [lower, leak, Block.leak, dp2Ops, runOps_cons, rget_next h, divArg,
        Arm64.State.readReg32]
  case ldrLit w signed rt offset =>
    cases w <;> cases signed <;>
      simp [lower, leak, Block.leak, runOps_cons, runOps_append, regSize, regMemW,
        runOps_chain_load_leak (quiet_loadStages ..), memW_bytes]
  case ldp w signed rt1 rt2 addr =>
    cases w <;> cases signed <;>
      simp [lower, lowerLdp, leak, Block.leak, runOps_cons, runOps_append, regSize, regMemW,
        regBytes, pairLeak, chain, chainFrom, Stage.ops, loadStages, memW, Width.bytes,
        addrOps_env h]
  case stp w rt1 rt2 addr =>
    cases w <;>
      simp [lower, lowerStp, leak, Block.leak, runOps_cons, runOps_append, regSize, regMemW,
        regBytes, pairLeak, memW, Width.bytes, rget_next h, addrOps_env h]
  case ldnp sz rn rt rt2 offset =>
    cases sz <;>
      simp [lower, lowerLdp, leak, Block.leak, runOps_cons, runOps_append, regMemW,
        regBytes, pairLeak, chain, loadStages, memW, Width.bytes, addrOps_env h, ea,
        Arm64.evalAddrMode]
  case stnp sz rn rt rt2 offset =>
    cases sz <;>
      simp [lower, lowerStp, leak, Block.leak, runOps_cons, runOps_append, regMemW,
        regBytes, pairLeak, memW, Width.bytes, rget_next h, addrOps_env h, ea,
        Arm64.evalAddrMode]
  case ldarStlr sz isLoad rn rt =>
    cases isLoad <;> cases sz <;>
      simp [lower, lowerLdar, lowerStlr, leak, Block.leak, runOps_cons, runOps_append,
        alignOps, memW, Width.bytes, rget_next h, baseOps_run h, MemWidth.bytes]
  case ldxr sz _ rn rt | ldapr sz rn rt =>
    cases sz <;>
      simp [lower, lowerLdar, leak, Block.leak, runOps_cons, runOps_append,
        alignOps, memW, Width.bytes, baseOps_run h, MemWidth.bytes]
  case atomicRmw op sz _ _ rs rn rt =>
    cases sz <;> cases op <;>
      simp [lower, lowerAtomic, atomicOps, leak, Block.leak, runOps_cons, runOps_append,
        alignOps, memW, Width.bytes, rget_next h, baseOps_run h, MemWidth.bytes]
  case ldrSimd sz vt addr =>
    cases sz <;>
      simp [lower, lowerLdrSimd, vloadOps, leak, vecLeak, Block.leak, runOps_cons,
        runOps_append, Width.bytes, SimdMemSize.bytes, addrOps_env h]
  case strSimd sz vt addr =>
    cases sz <;>
      simp [lower, lowerStrSimd, vstoreOps, leak, vecLeak, Block.leak, runOps_cons,
        runOps_append, Width.bytes, SimdMemSize.bytes, addrOps_env h]
  case ldpSimd sz vt1 vt2 addr =>
    cases sz <;>
      simp [lower, lowerLdpSimd, vloadOps, simdBytes, leak, vecLeak, vecPairLeak, Block.leak,
        runOps_cons, runOps_append, Width.bytes, SimdMemSize.bytes, addrOps_env h]
  case stpSimd sz vt1 vt2 addr =>
    cases sz <;>
      simp [lower, lowerStpSimd, vstoreOps, simdBytes, leak, vecLeak, vecPairLeak, Block.leak,
        runOps_cons, runOps_append, Width.bytes, SimdMemSize.bytes, addrOps_env h]
  case ldnpSimd sz vt1 vt2 rn offset =>
    cases sz <;>
      simp [lower, lowerLdpSimd, vloadOps, simdBytes, leak, vecLeak, vecPairLeak, Block.leak,
        runOps_cons, runOps_append, Width.bytes, SimdMemSize.bytes, addrOps_env h, ea,
        Arm64.evalAddrMode]
  case stnpSimd sz vt1 vt2 rn offset =>
    cases sz <;>
      simp [lower, lowerStpSimd, vstoreOps, simdBytes, leak, vecLeak, vecPairLeak, Block.leak,
        runOps_cons, runOps_append, Width.bytes, SimdMemSize.bytes, addrOps_env h, ea,
        Arm64.evalAddrMode]
  case fmovGprVec sf ftype rmode opcode rn rd =>
    cases hops : fmovOps sf ftype rmode opcode rn rd with
    | none => simp only [lower, hops] at hw; exact (not_wp_trap hw).elim
    | some ops =>
      have hc : opcode = 6#3 ∨ opcode = 7#3 := by
        by_cases h6 : opcode = 6#3
        · exact .inl h6
        · by_cases h7 : opcode = 7#3
          · exact .inr h7
          · simp [fmovOps, h6, h7] at hops
      simp only [lower, hops, leak, hc, ↓reduceIte]
      rw [leak_of_silent_jump (all_silent_fmovOps hops)]
  case fpDataProc1 ftype opcode rn rd =>
    cases hops : fpMovOps ftype opcode rn rd with
    | none => simp only [lower, hops] at hw; exact (not_wp_trap hw).elim
    | some ops =>
      have hc : opcode = 0#6 := by
        by_cases h0 : opcode = 0#6
        · exact h0
        · simp [fpMovOps, h0] at hops
      subst hc
      simp only [lower, hops, leak, ↓reduceIte]
      rw [leak_of_silent_jump (all_silent_fpMovOps hops)]
  case fpImm ftype imm8 rd =>
    cases hops : fpImmOps ftype imm8 rd with
    | none => simp only [lower, hops] at hw; exact (not_wp_trap hw).elim
    | some ops =>
      simp only [lower, hops, leak]
      rw [leak_of_silent_jump (all_silent_fpImmOps hops)]
  case fpCondSelect ftype rm cond rn rd =>
    cases hops : fcselOps ftype rm cond rn rd with
    | none => simp only [lower, hops] at hw; exact (not_wp_trap hw).elim
    | some ops =>
      simp only [lower, hops, leak]
      rw [leak_of_silent_jump (all_silent_fcselOps hops)]
  case simdInsDup q op imm5 imm4 rn rd =>
    cases hops : insDupOps q op imm5 imm4 rn rd with
    | none => simp only [lower, hops] at hw; exact (not_wp_trap hw).elim
    | some ops =>
      simp only [lower, hops, leak]
      rw [leak_of_silent_jump (all_silent_insDupOps hops)]
  case simdThreeSame q u size rm opcode rn rd =>
    cases hops : vecOp q u size opcode with
    | none => simp only [lower, hops] at hw; exact (not_wp_trap hw).elim
    | some op =>
      have hc : opcode = 3#5 ∨ opcode = 16#5 := by
        by_cases h3 : opcode = 3#5
        · exact .inl h3
        · by_cases h16 : opcode = 16#5
          · exact .inr h16
          · simp [vecOp, h3, h16] at hops
      simp only [lower, hops, leak, hc, ↓reduceIte]
      rw [leak_of_silent_jump (by simp)]
  case simdTwoRegMisc q u size opcode rn rd =>
    cases hops : notOps q u size opcode rn rd with
    | none =>
      cases hg : revGroups u size opcode with
      | none => simp only [lower, hops, hg] at hw; exact (not_wp_trap hw).elim
      | some gs =>
        have hc : opcode = 0#5 ∨ (opcode = 1#5 ∧ u = false ∧ size = 0#2) := by
          by_cases h0 : opcode = 0#5
          · exact .inl h0
          · by_cases h1 : opcode = 1#5 ∧ u = false ∧ size = 0#2
            · exact .inr h1
            · simp [revGroups, h0, h1] at hg
        simp only [lower, hops, hg, leak, hc, or_true, ↓reduceIte]
        rw [leak_of_silent_jump (all_silent_revVecOps ..)]
    | some ops =>
      have hc : opcode = 5#5 := by
        by_cases h5 : opcode = 5#5
        · exact h5
        · simp [notOps, h5] at hops
      subst hc
      simp only [lower, hops, leak, true_or, ↓reduceIte]
      rw [leak_of_silent_jump (all_silent_notOps hops)]
  case simdImmShift q op immh immb opc rn rd =>
    cases hops : immShiftOps q op immh immb opc rn rd with
    | none => simp only [lower, hops] at hw; exact (not_wp_trap hw).elim
    | some ops =>
      have hc : immh = 0#4 ∨ opc = 10#5 ∨ (op = true ∧ (opc = 0#5 ∨ opc = 2#5 ∨ opc = 8#5)) := by
        by_cases h0 : immh = 0#4
        · exact .inl h0
        · refine .inr ?_
          cases hs : laneShift q op immh opc with
          | none => simp [immShiftOps, h0, hs] at hops
          | some sop =>
            simp only [laneShift] at hs
            repeat' split at hs
            all_goals first | (cases hs; done) | simp_all
      simp only [lower, hops, leak]
      rw [leak_of_silent_jump (all_silent_immShiftOps hops)]
      rcases hc with hc | hc
      · simp only [hc, ↓reduceIte]
      · by_cases h0 : immh = 0#4 <;> simp only [h0, hc, ↓reduceIte]
  case simdExt q rm imm4 rn rd =>
    cases hops : extOps q rm imm4 rn rd with
    | none => simp only [lower, hops] at hw; exact (not_wp_trap hw).elim
    | some ops =>
      simp only [lower, hops, leak]
      rw [leak_of_silent_jump (all_silent_extOps hops)]

/-! ## Programs -/

/-- **The AArch64 lowering preserves traces.** If the code of `prog` is loaded and every
labelled run of the lowered program from `σ`, after the trace `t`, reaches `Q`, the machine
runs from a state related to `σ`, with some trace, to a running state related to one of
which `Q` holds with that trace added to `t`. -/
theorem lowerProgram_soundL {prog : Arm64.Program} {Q : State → Trace → Prop} {t : Trace}
    (hc : prog.CodeLoaded s.mem) (h : Rel s σ) (hw : EventuallyL (lowerProgram prog) Q σ t) :
    ∃ s' σ' tr, RunL prog s tr s' ∧ Rel s' σ' ∧ Q σ' (t ++ tr) := by
  induction hw generalizing s with
  | done σ t hq => exact ⟨s, σ, [], .refl s, h, by simpa using hq⟩
  | step σ t R hs _ ih =>
    obtain ⟨b, hb, hwp⟩ := hs
    simp only [lowerProgram, Option.map_eq_some_iff] at hb
    obtain ⟨i, hi, rfl⟩ := hb
    rw [h.pc] at hi hwp
    have hwp' := Block.wp_of_wpL hwp
    obtain ⟨σ₁, h₁, ⟨hv, hr⟩, hk⟩ := lower_step prog h hwp'
    obtain ⟨s', σ', tr, hrun, h', hq⟩ := ih σ₁ _ hr (codeLoaded_of_keepsCode hc hk) h₁
    exact ⟨s', σ', _, .step h.status (fetchMem_of_fetch hc hi) (leak_lower h i hv hwp') hrun,
      h', by rw [← List.append_assoc]; exact hq⟩

/-- A run with a trace is a run. -/
theorem RunL.steps {prog : Arm64.Program} {s s' : Arm64.State} {tr : Trace}
    (h : RunL prog s tr s') : Arm64.Steps prog s s' := by
  induction h with
  | refl s => exact .refl s
  | step hs hf _ _ ih => exact .step (.exec hs hf) ih
  | svc hs hf _ _ _ ih => exact .step (.exec hs hf) ih
  | exited _ _ ih => exact ih

end Lowering.Arm
