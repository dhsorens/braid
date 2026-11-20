/-
  Lowering.Arm.Sound

  The AArch64 lowering is sound: if the block of an instruction runs without fault and
  establishes a postcondition, the machine executes the instruction, stays running, and
  lands in a related state that satisfies it.

  The proof follows the shape of the lowering. Each group of operations the lowering is
  built from (a register read, a chain, the flags of an addition, an address) has a lemma
  in `Rel.lean` saying what it leaves in the environment and the state, and each instruction
  puts these together and compares the result with the model. The vector instructions are
  in `Simd.lean`, and the SHA-256 instructions in `Sha.lean`.

  ## Main results

  * `lower_step`, `lower_sound`: one instruction
  * `codeLoaded_of_keepsCode`, `fetchMem_of_fetch`: the code stays loaded, and is what the
    machine fetches
  * `lowerProgram_sound`: every run, `Eventually` to `Arm64.Steps`
-/

module

public import Lowering.Arm.Sha
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.Arm

open Braid
open Arm64 (Instr RegWidth MemWidth CondCode ShiftType ExtendType AddrMode AddSubOp LogicalOp
  MoveWideOp BitfieldOp CondSelectOp DataProc1Op DataProc2Op DataProc3Op)

variable {s : Arm64.State} {σ : State} {Q : State → Prop}

/-! ## Loads and stores of pairs, and literal loads -/

theorem execLdp_eq (w : RegWidth) (signed : Bool) (rt1 rt2 : Arm64.Reg) {addr : AddrMode}
    (hsp : Arm64.checkAddrSPAligned s addr = true)
    (hcr1 : s.mem.canRead (Arm64.evalAddrMode s addr).1
      (if signed then MemWidth.W32 else regMemW w).bytes = true)
    (hcr2 : s.mem.canRead ((Arm64.evalAddrMode s addr).1 + (if signed then 4#64 else regBytes w))
      (if signed then MemWidth.W32 else regMemW w).bytes = true) :
    Arm64.execLdp w signed rt1 rt2 addr s =
      (((wbState s addr).writeReg (if signed then .W64 else w) rt1
          (s.mem.readSized (if signed then .W32 else regMemW w) signed
            (Arm64.evalAddrMode s addr).1)).writeReg (if signed then .W64 else w) rt2
        (s.mem.readSized (if signed then .W32 else regMemW w) signed
          ((Arm64.evalAddrMode s addr).1 + (if signed then 4#64 else regBytes w)))).setPC
        (s.pc + 4) := by
  simp only [Arm64.execLdp, hsp, wbState]
  generalize Arm64.evalAddrMode s addr = e at hcr1 hcr2 ⊢
  obtain ⟨ea, wb⟩ := e
  cases w <;> cases signed <;>
    simp only [regMemW, regBytes, Bool.false_eq_true, ↓reduceIte] at hcr1 hcr2 ⊢ <;>
    simp only [hcr1, hcr2] <;> cases wb <;> rfl

/-- A load of a pair of registers is sound. -/
theorem sound_ldp {w : RegWidth} {signed : Bool} {rt1 rt2 : Arm64.Reg} {addr : AddrMode}
    (h : Rel s σ) (hw : (lowerLdp s.pc w signed rt1 rt2 addr).wp σ Q) :
    ∃ σ', Rel (Arm64.execLdp w signed rt1 rt2 addr s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (Arm64.execLdp w signed rt1 rt2 addr s).mem := by
  simp only [lowerLdp, Block.wp, List.append_assoc] at hw
  obtain ⟨hsp, ρ₁, σ₁, h₁, hw⟩ := wp_addrOps h hw
  simp only [List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply, envExt_self,
    Nat.reduceEqDiff, ↓reduceIte, BinOp.eval_add] at hw
  obtain ⟨hcr1, ρ₂, hw⟩ := wp_chain_load h₁ hw
  obtain ⟨hcr2, ρ₃, hw⟩ := wp_chain_load h₁ hw
  obtain ⟨σ₂, h₂, hw⟩ := wp_rset h₁ hw
  obtain ⟨σ₃, h₃, hw⟩ := wp_rset' h₂ hw
  simp only [Term.wp] at hw
  env_simp_at hcr1
  env_simp_at hcr2
  rw [wbState_mem] at hcr1 hcr2
  refine step_done (h₃.setPC _) hw ?_ (wbState_mem s addr ▸ KeepsCode.refl _)
  env_simp
  simp only [wbState_mem, run_loadStages, ← writeReg_eq]
  exact execLdp_eq w signed rt1 rt2 hsp hcr1 hcr2

theorem execStp_eq (w : RegWidth) (rt1 rt2 : Arm64.Reg) {addr : AddrMode}
    (hsp : Arm64.checkAddrSPAligned s addr = true)
    (hcw1 : s.mem.canWrite (Arm64.evalAddrMode s addr).1 (regMemW w).bytes = true)
    (hcw2 : s.mem.canWrite ((Arm64.evalAddrMode s addr).1 + regBytes w) (regMemW w).bytes = true) :
    Arm64.execStp w rt1 rt2 addr s =
      ((wbState s addr).setMem
        ((s.mem.writeSized (regMemW w) (Arm64.evalAddrMode s addr).1 (s.readReg64 rt1)).writeSized
          (regMemW w) ((Arm64.evalAddrMode s addr).1 + regBytes w) (s.readReg64 rt2))).setPC
        (s.pc + 4) := by
  simp only [Arm64.execStp, hsp, wbState]
  generalize Arm64.evalAddrMode s addr = e at hcw1 hcw2 ⊢
  obtain ⟨ea, wb⟩ := e
  cases w <;> simp only [regMemW, regBytes] at hcw1 hcw2 ⊢ <;>
    simp only [hcw1, hcw2] <;> cases wb <;> rfl

/-- A store of a pair of registers is sound. -/
theorem sound_stp {w : RegWidth} {rt1 rt2 : Arm64.Reg} {addr : AddrMode}
    (h : Rel s σ) (hw : (lowerStp s.pc w rt1 rt2 addr).wp σ Q) :
    ∃ σ', Rel (Arm64.execStp w rt1 rt2 addr s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (Arm64.execStp w rt1 rt2 addr s).mem := by
  simp only [lowerStp, Block.wp, wpOps] at hw
  have hw := wp_rget h hw
  have hw := wp_rget h hw
  obtain ⟨hsp, ρ₁, σ₁, h₁, hw⟩ := wp_addrOps h hw
  simp only [wpOps, Op.wp, Env.set_apply, envExt_apply,
    Nat.reduceEqDiff, Nat.reduceLT, Nat.lt_irrefl, ↓reduceIte, BinOp.eval_add] at hw
  obtain ⟨m₁, hm₁, m₂, hm₂, hw⟩ := hw
  obtain ⟨hcw1, h₂⟩ := h₁.store hm₁
  have hk1 := h₁.store_keeps hm₁
  obtain ⟨hcw2, h₃⟩ := h₂.store hm₂
  have hk2 := h₂.store_keeps hm₂
  simp only [Term.wp] at hw
  simp only [Arm64.State.setMem, canWrite_writeSized, wbState_mem] at hcw1 hcw2 hk1 hk2
  refine step_done (h₃.setPC _) hw ?_ (by
    show KeepsCode s.mem (((wbState s addr).mem.writeSized _ _ _).writeSized _ _ _)
    rw [wbState_mem]
    exact hk1.trans hk2)
  simp only [wbState_mem]
  exact execStp_eq w rt1 rt2 hsp hcw1 hcw2

/-- A load of a literal is sound. -/
theorem sound_ldrLit (prog : Arm64.Program) {w : RegWidth} {signed : Bool} {rt : Arm64.Reg}
    {offset : Word} (h : Rel s σ) (hw : (lower s.pc (.ldrLit w signed rt offset)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.ldrLit w signed rt offset) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.ldrLit w signed rt offset) s).mem := by
  simp only [lower, Block.wp, wpOps, Op.wp] at hw
  obtain ⟨hcr, ρ₁, hw⟩ := wp_chain_load h hw
  obtain ⟨σ₂, h₂, hw⟩ := wp_rset' h hw
  simp only [Term.wp] at hw
  simp only [Env.set_same] at hcr
  refine step_done (h₂.setPC _) hw ?_
  simp only [envExt_self, Env.set_same, run_loadStages, ← writeReg_eq]
  cases w <;> cases signed <;>
    simp only [regMemW, Bool.false_eq_true, ↓reduceIte] at hcr ⊢ <;>
    simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, Arm64.execLdrLit,
      Bool.false_eq_true, ↓reduceIte, hcr] <;> rfl

/-! ## Conditional select, test-and-branch, extended add, conditional compare -/

theorem run_cselStages (w : RegWidth) (op : CondSelectOp) (v : Word) :
    Stage.run (cselStages w op) v = norm w (match op with
      | .CSEL => norm w v
      | .CSINC => norm w v + 1#64
      | .CSINV => ~~~norm w v
      | .CSNEG => 0#64 - norm w v) := by
  cases w <;> cases op <;>
    simp only [cselStages, Stage.run, Stage.eval, List.foldl, List.nil_append, List.cons_append,
      norm, BinOp.eval_add, UnOp.eval_not, UnOp.eval_neg, UnOp.eval_zext] <;>
    bv_decide

/-- A conditional select is sound. -/
theorem sound_condSelect (prog : Arm64.Program) {w : RegWidth} {op : CondSelectOp}
    {rd rn rm : Arm64.Reg} {cond : CondCode} (h : Rel s σ)
    (hw : (lower s.pc (.condSelect w op rd rn rm cond)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.condSelect w op rd rn rm cond) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.condSelect w op rd rn rm cond) s).mem := by
  simp only [lower] at hw
  arm_ops h hw
  obtain ⟨σ', h', hw⟩ := wp_rset' h hw
  simp only [Term.wp] at hw
  refine step_done (h'.setPC _) hw ?_
  env_simp
  simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, Arm64.execCondSelect, writeReg_eq,
    run_cselStages, ← readReg_eq]
  cases Arm64.ConditionHolds cond s.pstate <;>
    simp only [ofBool_true, ofBool_false, ne_eq, not_true_eq_false, ↓reduceIte, norm_readReg,
      Bool.false_eq_true] <;>
    rfl

theorem and_twoPow_ne_zero (v : Word) (n : Nat) :
    (v &&& BitVec.twoPow 64 n ≠ 0#64) ↔ v.getLsbD n = true := by
  rw [BitVec.and_twoPow]
  cases hb : v.getLsbD n
  · simp
  · have hn : n < 64 := BitVec.lt_of_getLsbD hb
    simp only [↓reduceIte, ne_eq, iff_true]
    intro h0
    have := congrArg (fun x : Word => x.getLsbD n) h0
    simp [hn] at this

/-- A test-and-branch is sound. -/
theorem sound_tbz (prog : Arm64.Program) {w : RegWidth} {isNonZero : Bool} {rt : Arm64.Reg}
    {bit : Nat} {offset : Word} (h : Rel s σ)
    (hw : (lower s.pc (.tbz w isNonZero rt bit offset)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.tbz w isNonZero rt bit offset) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.tbz w isNonZero rt bit offset) s).mem := by
  simp only [lower] at hw
  arm_ops h hw
  cases isNonZero <;> simp only [Term.wp, Bool.false_eq_true, ↓reduceIte] at hw <;>
    refine step_done (h.setPC _) hw ?_ <;>
    env_simp <;>
    simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, BinOp.eval_and,
      and_twoPow_ne_zero] <;>
    cases (s.readReg64 rt).getLsbD bit <;> simp <;> rfl

/-- An addition or subtraction of an extended register is sound. -/
theorem sound_addSubExt (prog : Arm64.Program) {w : RegWidth} {op : AddSubOp}
    {rd rn rm : Arm64.Reg} {ext : ExtendType} {amount : Nat} (h : Rel s σ)
    (hw : (lower s.pc (.addSubExt w op rd rn rm ext amount)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.addSubExt w op rd rn rm ext amount) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.addSubExt w op rd rn rm ext amount) s).mem := by
  simp only [lower] at hw
  arm_ops h hw
  simp only [run_extStages] at hw
  obtain ⟨ρ₁, σ₁, h₁, hw⟩ := wp_addSubOps h (by decide) (by decide)
    (by env_simp; exact norm_readReg _ _) (by env_simp; exact norm_extendVal ..) hw
  obtain ⟨σ₂, h₂, hw⟩ := wp_rset' h₁ hw
  simp only [Term.wp] at hw
  refine step_done (h₂.setPC _) hw ?_
  env_simp
  exact modelRes_eq w rd (Arm64.evalAddSub w op _ _ none) (norm_evalAddSub ..)

/-- A conditional compare writes the flags of the comparison, or the given ones. -/
theorem wp_ccmpOps (h : Rel s σ) {w : RegWidth} {isSub : Bool} {nzcv : BitVec 4} {ρ : Env}
    {K : Env → State → Prop} (hx : norm w (ρ 5) = ρ 5) (hy : norm w (ρ 7) = ρ 7)
    (hw : wpOps (ccmpOps w isSub nzcv) ρ σ K) :
    ∃ ρ' σ', Rel (s.setPState (if ρ 0 ≠ 0#64 then (addSubRes w isSub (ρ 5) (ρ 7) isSub).2
        else Arm64.PState.ofBits4 nzcv)) σ' ∧ K ρ' σ' := by
  simp only [ccmpOps] at hw
  obtain ⟨ρ₁, hw⟩ := wp_flagOps (by decide) (by decide) hx hy hw
  simp only [wpOps, Op.wp, Env.set_apply, envExt5_apply, Nat.reduceEqDiff, Nat.reduceLT,
    Nat.reduceAdd, ↓reduceIte] at hw
  refine ⟨_, _, (h.setPState _ _ _ _).cast ?_, hw⟩
  by_cases hc : ρ 0 = 0#64 <;> simp [hc, Arm64.PState.ofBits4]

theorem execCondCompare_eq (w : RegWidth) (isSub isImm : Bool) (rn rm : Arm64.Reg)
    (rhs : Word) (nzcv : BitVec 4) (cond : CondCode) :
    Arm64.execCondCompare w isSub isImm rn rhs rm nzcv cond s =
      (s.setPState (if ofBool (Arm64.ConditionHolds cond s.pstate) ≠ 0#64 then
          (addSubRes w isSub (s.readReg w rn) (if isImm then rhs else s.readReg w rm) isSub).2
        else Arm64.PState.ofBits4 nzcv)).setPC (s.pc + 4) := by
  simp only [Arm64.execCondCompare]
  cases Arm64.ConditionHolds cond s.pstate <;> cases isSub <;>
    simp [evalAddSub_ADDS, evalAddSub_SUBS] <;> rfl

/-- A conditional compare with a register is sound. -/
theorem sound_condCompareReg (prog : Arm64.Program) {w : RegWidth} {isSub : Bool}
    {rn rm : Arm64.Reg} {nzcv : BitVec 4} {cond : CondCode} (h : Rel s σ)
    (hw : (lower s.pc (.condCompareReg w isSub rn rm nzcv cond)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.condCompareReg w isSub rn rm nzcv cond) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.condCompareReg w isSub rn rm nzcv cond) s).mem := by
  simp only [lower] at hw
  arm_ops h hw
  obtain ⟨ρ', σ', h', hw⟩ := wp_ccmpOps h (by env_simp; exact norm_readReg _ _)
    (by env_simp; exact norm_readReg _ _) hw
  simp only [Term.wp] at hw
  refine step_done (h'.setPC _) hw ?_
  env_simp
  exact execCondCompare_eq w isSub false rn rm 0#64 nzcv cond

/-- A conditional compare with a constant is sound. -/
theorem sound_condCompareImm (prog : Arm64.Program) {w : RegWidth} {isSub : Bool}
    {rn : Arm64.Reg} {imm5 : BitVec 5} {nzcv : BitVec 4} {cond : CondCode} (h : Rel s σ)
    (hw : (lower s.pc (.condCompareImm w isSub rn imm5 nzcv cond)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.condCompareImm w isSub rn imm5 nzcv cond) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.condCompareImm w isSub rn imm5 nzcv cond) s).mem := by
  simp only [lower] at hw
  arm_ops h hw
  obtain ⟨ρ', σ', h', hw⟩ := wp_ccmpOps h (by env_simp; exact norm_readReg _ _)
    (by env_simp; cases w <;> first | (simp only [norm]; done) | (simp only [norm]; bv_decide)) hw
  simp only [Term.wp] at hw
  refine step_done (h'.setPC _) hw ?_
  env_simp
  exact execCondCompare_eq w isSub true rn .xzr (imm5.zeroExtend 64) nzcv cond

/-! ## Multiplication, division, shifts by a register, byte reversal, `EXTR` -/

/-- A multiplication with an addend, or the high half of a product, is sound. -/
theorem sound_dataProc3 (prog : Arm64.Program) {w : RegWidth} {op : DataProc3Op}
    {rd rn rm ra : Arm64.Reg} (h : Rel s σ)
    (hw : (lower s.pc (.dataProc3 w op rd rn rm ra)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.dataProc3 w op rd rn rm ra) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.dataProc3 w op rd rn rm ra) s).mem := by
  simp only [lower] at hw
  cases op <;> cases w <;> simp only [dp3Ops] at hw <;> arm_ops h hw <;>
    obtain ⟨σ', h', hw⟩ := wp_rset' h hw <;>
    simp only [Term.wp] at hw <;>
    refine step_done (h'.setPC _) hw ?_ <;>
    env_simp <;>
    simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, Arm64.execDataProc3, writeReg_eq,
      norm, Arm64.State.readReg32, BinOp.eval_add, BinOp.eval_sub, BinOp.eval_mul,
      BinOp.eval_mulhs, BinOp.eval_mulhu, UnOp.eval_zext, UnOp.eval_sext] <;>
    refine wr_eq rd ?_ <;>
    generalize s.readReg64 rn = a <;> generalize s.readReg64 rm = b <;>
    generalize s.readReg64 ra = c
  all_goals first | rfl | bv_decide

/-- Unsigned division of 32-bit values is division of their zero extensions. -/
theorem udiv_zext (x y : BitVec 32) :
    BitVec.setWidth 64 (x / y) = BitVec.setWidth 64 x / BitVec.setWidth 64 y := by
  apply BitVec.eq_of_toNat_eq
  have hx := x.isLt
  have hy := y.isLt
  have hd : x.toNat / y.toNat < 2 ^ 32 := Nat.lt_of_le_of_lt (Nat.div_le_self _ _) hx
  simp only [BitVec.toNat_setWidth, BitVec.toNat_udiv]
  rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]

/-- Signed division of 32-bit values is the low half of division of their sign extensions. -/
theorem sdiv_sext (x y : BitVec 32) :
    BitVec.setWidth 32 ((x.signExtend 64).sdiv (y.signExtend 64)) = x.sdiv y := by
  have mx : (x.signExtend 64).msb = x.msb := by bv_decide
  have my : (y.signExtend 64).msb = y.msb := by bv_decide
  rw [BitVec.sdiv_eq, BitVec.sdiv_eq, mx, my]
  cases hx : x.msb <;> cases hy : y.msb <;> simp only [BitVec.udiv_eq]
  · have ex : x.signExtend 64 = x.setWidth 64 := by bv_decide
    have ey : y.signExtend 64 = y.setWidth 64 := by bv_decide
    rw [ex, ey, ← udiv_zext]
    generalize x / y = r
    bv_decide
  · have ex : x.signExtend 64 = x.setWidth 64 := by bv_decide
    have ey : -y.signExtend 64 = (-y).setWidth 64 := by bv_decide
    rw [ex, ey, ← udiv_zext]
    generalize x / -y = r
    bv_decide
  · have ex : -x.signExtend 64 = (-x).setWidth 64 := by bv_decide
    have ey : y.signExtend 64 = y.setWidth 64 := by bv_decide
    rw [ex, ey, ← udiv_zext]
    generalize -x / y = r
    bv_decide
  · have ex : -x.signExtend 64 = (-x).setWidth 64 := by bv_decide
    have ey : -y.signExtend 64 = (-y).setWidth 64 := by bv_decide
    rw [ex, ey, ← udiv_zext]
    generalize -x / -y = r
    bv_decide

theorem udiv_w32 (a b : Word) :
    BitVec.zeroExtend 64 (BitVec.truncate 32 (BitVec.zeroExtend 64
      (if (BitVec.truncate 32 (BitVec.zeroExtend 64 (BitVec.truncate 32 b)) == 0#32) = true
        then 0#32
        else BitVec.truncate 32 (BitVec.zeroExtend 64 (BitVec.truncate 32 a)) /
          BitVec.truncate 32 (BitVec.zeroExtend 64 (BitVec.truncate 32 b))))) =
    BitVec.zeroExtend 64 (BitVec.truncate 32 a) / BitVec.zeroExtend 64 (BitVec.truncate 32 b) := by
  have ta : ∀ v : Word, BitVec.truncate 32 (BitVec.zeroExtend 64 (BitVec.truncate 32 v)) =
      BitVec.truncate 32 v := fun v => by bv_decide
  simp only [ta, BitVec.truncate_eq_setWidth]
  generalize BitVec.setWidth 32 a = x
  generalize BitVec.setWidth 32 b = y
  rw [← udiv_zext]
  have e : (if (y == 0#32) = true then 0#32 else x / y) = x / y := by
    split
    · rename_i h0; rw [eq_of_beq h0, BitVec.udiv_zero]
    · rfl
  rw [e]
  generalize x / y = r
  bv_decide

theorem sdiv_w32 (a b : Word) :
    BitVec.zeroExtend 64 (BitVec.truncate 32 (BitVec.zeroExtend 64
      (if (BitVec.truncate 32 (BitVec.zeroExtend 64 (BitVec.truncate 32 b)) == 0#32) = true
        then 0#32
        else (BitVec.truncate 32 (BitVec.zeroExtend 64 (BitVec.truncate 32 a))).sdiv
          (BitVec.truncate 32 (BitVec.zeroExtend 64 (BitVec.truncate 32 b)))))) =
    BitVec.zeroExtend 64 (BitVec.truncate 32
      ((BitVec.signExtend 64 (BitVec.truncate 32 a)).sdiv
        (BitVec.signExtend 64 (BitVec.truncate 32 b)))) := by
  have ta : ∀ v : Word, BitVec.truncate 32 (BitVec.zeroExtend 64 (BitVec.truncate 32 v)) =
      BitVec.truncate 32 v := fun v => by bv_decide
  simp only [ta, BitVec.truncate_eq_setWidth]
  generalize BitVec.setWidth 32 a = x
  generalize BitVec.setWidth 32 b = y
  rw [sdiv_sext]
  have e : (if (y == 0#32) = true then 0#32 else x.sdiv y) = x.sdiv y := by
    split
    · rename_i h0; rw [eq_of_beq h0, BitVec.sdiv_zero]
    · rfl
  rw [e]
  generalize x.sdiv y = r
  bv_decide

theorem toNat_mod_64 (y : Word) : y.toNat % 64 = (y &&& 63#64).toNat := by
  rw [BitVec.toNat_and]
  exact (Nat.and_two_pow_sub_one_eq_mod y.toNat 6).symm

theorem toNat_trunc_mod_32 (y : Word) : (y.truncate 32).toNat % 32 = (y &&& 31#64).toNat := by
  have e : (y &&& 31#64).toNat = y.toNat % 32 := by
    rw [BitVec.toNat_and]
    exact Nat.and_two_pow_sub_one_eq_mod y.toNat 5
  rw [e, BitVec.truncate_eq_setWidth, BitVec.toNat_setWidth]
  omega

/-- A division or a shift by a register is sound. -/
theorem sound_dataProc2 (prog : Arm64.Program) {w : RegWidth} {op : DataProc2Op}
    {rd rn rm : Arm64.Reg} (h : Rel s σ)
    (hw : (lower s.pc (.dataProc2 w op rd rn rm)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.dataProc2 w op rd rn rm) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.dataProc2 w op rd rn rm) s).mem := by
  simp only [lower] at hw
  cases w <;> cases op <;> simp only [dp2Ops] at hw <;> arm_ops h hw <;>
    obtain ⟨σ', h', hw⟩ := wp_rset' h hw <;>
    simp only [Term.wp] at hw <;>
    refine step_done (h'.setPC _) hw ?_ <;>
    env_simp <;>
    simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, Arm64.execDataProc2, writeReg_eq,
      readReg_eq, norm, Arm64.shift32, Arm64.shift64, toNat_mod_64, toNat_trunc_mod_32,
      BitVec.rotateRight_def,
      BinOp.eval_udiv, BinOp.eval_sdiv, BinOp.eval_shl, BinOp.eval_lshr, BinOp.eval_ashr,
      BinOp.eval_rotr, BinOp.eval_and, BinOp.eval_mul, UnOp.eval_zext, UnOp.eval_sext] <;>
    refine wr_eq rd ?_ <;>
    generalize s.readReg64 rn = a <;> generalize s.readReg64 rm = b
  all_goals first
    | rfl
    | exact udiv_w32 a b
    | exact sdiv_w32 a b
    | bv_decide
    | (have e : b &&& 63#64 &&& 63#64 = b &&& 63#64 := by bv_decide
       rw [e])
    | (generalize hk : BitVec.zeroExtend 64 (BitVec.truncate 32 b) &&& 31#64 = k
       have hlt : k < 32#64 := by rw [← hk]; bv_decide
       have e1 : k.toNat % 32 = k.toNat := Nat.mod_eq_of_lt (by bv_omega)
       have e2 : 32 - k.toNat = (32#64 - k).toNat := by bv_omega
       rw [e1, e2]
       have hb : b &&& 31#64 = k := by rw [← hk]; bv_decide
       bv_decide)

/-! The model counts leading zeros and sign bits, and reverses bits, with loops of its own.
These are `BitVec.clz` and `BitVec.reverse`. -/

theorem clz64 (v : BitVec 64) : BitVec.ofNat 64 (Arm64.countLeadingZeros v) = v.clz := by
  simp only [Arm64.countLeadingZeros, Arm64.countLeadingZeros.loop, Nat.reduceSub, apply_ite (BitVec.ofNat 64)]
  bv_decide

theorem clz32 (v : BitVec 32) : BitVec.ofNat 64 (Arm64.countLeadingZeros v) = (v.zeroExtend 64).clz - 32#64 := by
  simp only [Arm64.countLeadingZeros, Arm64.countLeadingZeros.loop, Nat.reduceSub, apply_ite (BitVec.ofNat 64)]
  bv_decide

theorem ite_yield {α : Type} (c : Prop) [Decidable c] (a b : α) :
    (if c then (pure (ForInStep.yield a) : Id (ForInStep α)) else pure (ForInStep.yield b)) =
      pure (ForInStep.yield (if c then a else b)) := by
  split <;> rfl

theorem reverseBits_eq {n : Nat} (v : BitVec n) :
    Arm64.reverseBits v = (List.range' 0 n).foldl (fun acc i =>
      if v.getLsbD i then acc ||| (BitVec.ofNat n 1 <<< (n - 1 - i)) else acc) 0 := by
  simp only [Arm64.reverseBits, Std.Legacy.Range.forIn_eq_forIn_range', Std.Legacy.Range.size]
  simp [ite_yield]

set_option maxRecDepth 20000 in
theorem rbit64 (v : BitVec 64) : Arm64.reverseBits v = v.reverse := by
  rw [reverseBits_eq]
  simp only [List.range', List.foldl, Nat.reduceAdd, Nat.reduceSub]
  bv_decide

set_option maxRecDepth 20000 in
theorem rbit32 (v : BitVec 32) : (Arm64.reverseBits v).zeroExtend 64 = (v.zeroExtend 64).reverse >>> 32#64 := by
  rw [reverseBits_eq]
  simp only [List.range', List.foldl, Nat.reduceAdd, Nat.reduceSub]
  bv_decide

theorem cls64 (v : BitVec 64) : BitVec.ofNat 64 (Arm64.countLeadingSigns v) = (v ^^^ v.sshiftRight' 1#64).clz - 1#64 := by
  simp only [Arm64.countLeadingSigns, Arm64.countLeadingSigns.loop, Nat.reduceSub, Nat.reduceLeDiff, ↓reduceIte, apply_ite (BitVec.ofNat 64)]
  bv_decide

theorem cls32 (v : BitVec 32) : BitVec.ofNat 64 (Arm64.countLeadingSigns v) =
    (v.signExtend 64 ^^^ (v.signExtend 64).sshiftRight' 1#64).clz - 33#64 := by
  simp only [Arm64.countLeadingSigns, Arm64.countLeadingSigns.loop, Nat.reduceSub, Nat.reduceLeDiff, ↓reduceIte, apply_ite (BitVec.ofNat 64)]
  bv_decide

/-- A byte or bit reversal, or a count of leading zeros or sign bits, is sound. -/
theorem sound_dataProc1 (prog : Arm64.Program) {w : RegWidth} {op : DataProc1Op}
    {rd rn : Arm64.Reg} (h : Rel s σ) (hw : (lower s.pc (.dataProc1 w op rd rn)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.dataProc1 w op rd rn) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.dataProc1 w op rd rn) s).mem := by
  cases op <;> cases w <;> simp only [lower, dp1Ops] at hw
  case RBIT.W32 | RBIT.W64 | CLZ.W32 | CLZ.W64 | CLS.W32 | CLS.W64 =>
    arm_ops h hw
    obtain ⟨σ', h', hw⟩ := wp_rset' h hw
    simp only [Term.wp] at hw
    refine step_done (h'.setPC _) hw ?_
    env_simp
    simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, Arm64.execDataProc1, writeReg_eq,
      readReg_eq, norm, clz64, clz32, rbit64, rbit32, cls64, cls32, BinOp.eval_sub,
      BinOp.eval_lshr, BinOp.eval_ashr, BinOp.eval_xor, UnOp.eval_clz, UnOp.eval_rbit,
      UnOp.eval_sext]
    refine wr_eq rd ?_
    generalize s.readReg64 rn = a
    bv_decide
  all_goals
    arm_ops h hw
    obtain ⟨σ', h', hw⟩ := wp_rset' h hw
    simp only [Term.wp] at hw
    refine step_done (h'.setPC _) hw ?_
    env_simp
    simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, Arm64.execDataProc1, writeReg_eq,
      readReg_eq, norm, Arm64.rev16_64, Arm64.rev32_64, Arm64.rev64, Braid.bswap,
      BinOp.eval_and, BinOp.eval_or, BinOp.eval_shl, BinOp.eval_lshr, BinOp.eval_rotr,
      UnOp.eval_bswap]
    refine wr_eq rd ?_
    generalize s.readReg64 rn = a
    bv_decide

theorem extr_w64 (a b k : Word) (hk : k < 64#64) (hk0 : k ≠ 0#64) :
    BitVec.truncate 64 ((a ++ b : BitVec 128) >>> k.toNat) = b >>> k ||| a <<< (64#64 - k) := by
  bv_decide

theorem extr_w32 (a b k : Word) (hk : k < 32#64) (hk0 : k ≠ 0#64) :
    BitVec.zeroExtend 64 (BitVec.truncate 32 (BitVec.zeroExtend 64 (BitVec.truncate 32
      ((BitVec.truncate 32 a ++ BitVec.truncate 32 b : BitVec 64) >>> k.toNat)))) =
    BitVec.zeroExtend 64 (BitVec.truncate 32
      (BitVec.zeroExtend 64 (BitVec.truncate 32 b) >>> k ||| a <<< (32#64 - k))) := by
  bv_decide

/-- An `EXTR` is sound. -/
theorem sound_extr (prog : Arm64.Program) {w : RegWidth} {rd rn rm : Arm64.Reg} {lsb : Nat}
    (h : Rel s σ) (hw : (lower s.pc (.extr w rd rn rm lsb)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.extr w rd rn rm lsb) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.extr w rd rn rm lsb) s).mem := by
  simp only [lower] at hw
  cases w <;> simp only [extrOps] at hw <;> split at hw <;> rename_i h0 <;> arm_ops h hw <;>
    obtain ⟨σ', h', hw⟩ := wp_rset' h hw <;>
    simp only [Term.wp] at hw <;>
    refine step_done (h'.setPC _) hw ?_ <;>
    env_simp <;>
    simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, writeReg_eq, norm,
      Arm64.State.readReg32, h0, BinOp.eval_or, BinOp.eval_shl, BinOp.eval_lshr,
      UnOp.eval_zext] <;>
    refine wr_eq rd ?_ <;>
    generalize s.readReg64 rn = a <;> generalize s.readReg64 rm = b
  · bv_decide
  · obtain ⟨k, hk, hke⟩ := exists_bv_of_lt (k := lsb % 32) (by omega)
    have hk32 : k < 32#64 := by bv_omega
    have hk0 : k ≠ 0#64 := by rintro rfl; exact h0 (by simpa using hke)
    have e2 : BitVec.ofNat 64 (32 - k.toNat) = 32#64 - k := by bv_omega
    simp only [hke, BitVec.ofNat_toNat, BitVec.setWidth_eq, e2]
    exact extr_w32 a b k hk32 hk0
  · bv_decide
  · obtain ⟨k, hk, hke⟩ := exists_bv_of_lt (k := lsb % 64) (by omega)
    have hk0 : k ≠ 0#64 := by rintro rfl; exact h0 (by simpa using hke)
    have e2 : BitVec.ofNat 64 (64 - k.toNat) = 64#64 - k := by bv_omega
    simp only [hke, BitVec.ofNat_toNat, BitVec.setWidth_eq, e2]
    exact extr_w64 a b k hk hk0

/-! ## Addition and subtraction with carry -/

/-- Two states that write equal values to a register and equal flags, and go to the next
instruction. -/
theorem wrf_eq (rd : Arm64.Reg) {a b : Word} {p q : Arm64.PState} (hab : a = b) (hpq : p = q) :
    ((s.writeReg64 rd a).setPState p).advancePC =
      ((s.setPState q).writeReg64 rd b).setPC (s.pc + 4) := by
  subst hab hpq
  rfl

/-- An addition or subtraction with carry is sound. -/
theorem sound_addSubCarry (prog : Arm64.Program) {w : RegWidth} {op : AddSubOp}
    {rd rn rm : Arm64.Reg} (h : Rel s σ)
    (hw : (lower s.pc (.addSubCarry w op rd rn rm)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.addSubCarry w op rd rn rm) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.addSubCarry w op rd rn rm) s).mem := by
  simp only [lower] at hw
  arm_ops h hw
  cases op <;> cases w <;>
    simp only [adcOps, AddSubOp.setsFlags, setNZCV, Bool.false_eq_true, ↓reduceIte,
      List.append_nil, List.nil_append, List.cons_append] at hw <;>
    arm_ops h hw
  all_goals first
    | obtain ⟨σ₂, h₂, hw⟩ := wp_rset' (h.setPState _ _ _ _) hw
    | obtain ⟨σ₂, h₂, hw⟩ := wp_rset' h hw
  all_goals
    simp only [Term.wp] at hw
    refine step_done (h₂.setPC _) hw ?_
    env_simp
    simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, Arm64.execAddSubCarry,
      Arm64.evalAddSub, Arm64.AddWithCarry32, Arm64.AddWithCarry64, writeReg_eq, readReg_eq,
      norm, h.c, BinOp.eval_add, BinOp.eval_xor, BinOp.eval_and, BinOp.eval_or, BinOp.eval_slt,
      BinOp.eval_eq, BinOp.eval_ne, BinOp.eval_ult, UnOp.eval_not, UnOp.eval_zext,
      UnOp.eval_sext, ofBool_bne_zero]
    first
      | refine wr_eq rd ?_
      | refine wrf_eq rd ?_ (Arm64.PState.ext ?_ ?_ ?_ ?_)
  all_goals
    simp only [ofBool, Bool.false_eq_true, ↓reduceIte]
    generalize s.readReg64 rn = a
    generalize s.readReg64 rm = b
    generalize s.pstate.c = c
    bv_decide

/-! ## Bitfield moves -/

/-- A shift amount below `N`, and `N` less it, as words. -/
theorem nat_amounts {n N : Nat} (hN : N ≤ 64) (hn : n < N) :
    ∃ k : Word, n = k.toNat ∧ N - n = (BitVec.ofNat 64 N - k).toNat ∧ k < BitVec.ofNat 64 N := by
  refine ⟨BitVec.ofNat 64 n, ?_, ?_, ?_⟩
  · simp only [BitVec.toNat_ofNat]; omega
  · simp only [BitVec.toNat_sub, BitVec.toNat_ofNat]; omega
  · simp only [BitVec.lt_def, BitVec.toNat_ofNat]; omega

theorem getLsbD_eq (x : Word) (n : Nat) : x.getLsbD n = ((x >>> n) &&& 1#64 != 0#64) := by
  have e : x.getLsbD n = (x >>> n).getLsbD 0 := by simp
  rw [e]
  generalize x >>> n = z
  bv_decide

/-- Turn the shift amounts of a bitfield move into words, and decide. -/
macro "bf_bits" N:num immr:ident imms:ident : tactic => `(tactic|
  (try generalize BitVec.ofNat 64 (Nat.shiftLeft 1 _ - 1) = m₁
   try generalize BitVec.ofNat 64 (Nat.shiftLeft 1 _ - 1) = m₂
   try simp only [getLsbD_eq]
   obtain ⟨rb, hr, hr', hrlt⟩ := nat_amounts (N := $N) (n := $immr % $N) (by decide)
     (Nat.mod_lt _ (by decide))
   obtain ⟨sb, hs, -, hslt⟩ := nat_amounts (N := $N) (n := $imms % $N) (by decide)
     (Nat.mod_lt _ (by decide))
   try simp only [hr']
   simp only [hr, hs, BitVec.ofNat_toNat, BitVec.setWidth_eq]
   bv_decide))

/-- A bitfield move is sound. -/
theorem sound_bitfield (prog : Arm64.Program) {w : RegWidth} {op : BitfieldOp}
    {rd rn : Arm64.Reg} {immr imms : Nat} (h : Rel s σ)
    (hw : (lower s.pc (.bitfield w op rd rn immr imms)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.bitfield w op rd rn immr imms) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.bitfield w op rd rn immr imms) s).mem := by
  have b1 : (BitfieldOp.UBFM == BitfieldOp.UBFM) = true := by decide
  have b2 : (BitfieldOp.SBFM == BitfieldOp.UBFM) = false := by decide
  have b3 : (BitfieldOp.BFM == BitfieldOp.UBFM) = false := by decide
  have b4 : (BitfieldOp.UBFM == BitfieldOp.SBFM) = false := by decide
  have b5 : (BitfieldOp.SBFM == BitfieldOp.SBFM) = true := by decide
  have b6 : (BitfieldOp.BFM == BitfieldOp.SBFM) = false := by decide
  simp only [lower] at hw
  cases w <;> cases op <;>
    simp only [bfOps, reduceCtorEq, false_and, true_and, ↓reduceIte] at hw <;>
    simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, Arm64.execBitfield,
      Arm64.evalBitfield, b1, b2, b3, b4, b5, b6, Bool.false_and, Bool.true_and,
      Bool.false_eq_true, ↓reduceIte, beq_iff_eq, Bool.and_eq_true, decide_eq_true_eq]
  all_goals
    repeat' (split at hw <;> rename_i c <;> simp only [c, ↓reduceIte, and_self])
  all_goals
    arm_ops h hw
    obtain ⟨σ', h', hw⟩ := wp_rset' h hw
    simp only [Term.wp] at hw
    refine step_done (h'.setPC _) hw ?_
    env_simp
    simp only [writeReg_eq, readReg_eq, norm, BinOp.eval_and, BinOp.eval_or, BinOp.eval_shl,
      BinOp.eval_lshr, BinOp.eval_ashr, UnOp.eval_zext, UnOp.eval_sext, UnOp.eval_neg]
    refine wr_eq rd ?_
    generalize s.readReg64 rn = a
    generalize s.readReg64 rd = b
  all_goals first
    | bf_bits 32 immr imms
    | bf_bits 64 immr imms

/-! ## Loads and stores at an aligned address -/

/-- The alignment guard of an access: the address is aligned. -/
theorem wp_alignOps {a t : Nat} {sz : MemWidth} {ρ : Env} {K : Env → State → Prop}
    {rest : List Op} (ha : a < t) (hw : wpOps (alignOps a t sz ++ rest) ρ σ K) :
    sz.isAligned (ρ a) = true ∧ ∃ ρ' : Env, (∀ y, y < t → ρ' y = ρ y) ∧ wpOps rest ρ' σ K := by
  have hat : a ≠ t := by omega
  cases sz
  · exact ⟨rfl, ρ, fun _ _ => rfl, hw⟩
  all_goals
    simp only [alignOps, List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply, hat,
      ↓reduceIte, Nat.reduceEqDiff, Nat.add_left_cancel_iff, BinOp.eval_and,
      BinOp.eval_eq] at hw
    refine ⟨?_, _, fun y hy => by env_below hy, hw.2⟩
    have := hw.1
    simp only [Arm64.MemWidth.isAligned]
    simpa using this

/-- An unsigned load fits the register it is written to. -/
theorem norm_readSized (sz : MemWidth) (m : Arm64.Memory) (a : Word) :
    norm (match sz with | .X64 => .W64 | _ => .W32) (m.readSized sz false a) =
      m.readSized sz false a := by
  cases sz <;> simp only [norm, Arm64.Memory.readSized, Bool.false_eq_true, ↓reduceIte]
  · generalize m.read8 a = b; bv_decide
  · generalize m.read16 a = b; bv_decide
  · generalize m.read32 a = b; bv_decide

theorem evalInst_ldar (prog : Arm64.Program) (sz : MemWidth) (rn rt : Arm64.Reg)
    (hsp : Arm64.checkRegSPAligned s rn = true) (hal : sz.isAligned (s.readReg64 rn) = true)
    (hcr : s.mem.canRead (s.readReg64 rn) sz.bytes = true) :
    prog.evalInst (.ldarStlr sz true rn rt) s =
      (s.writeReg64 rt (s.mem.readSized sz false (s.readReg64 rn))).setPC (s.pc + 4) := by
  cases sz <;>
    simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, hsp, hal, hcr, writeReg_eq,
      Bool.not_true, Bool.false_eq_true, ↓reduceIte]
  · exact wr_eq rt (norm_readSized .B8 _ _)
  · exact wr_eq rt (norm_readSized .H16 _ _)
  · exact wr_eq rt (norm_readSized .W32 _ _)
  · exact wr_eq rt (norm_readSized .X64 _ _)

theorem evalInst_stlr (prog : Arm64.Program) (sz : MemWidth) (rn rt : Arm64.Reg)
    (hsp : Arm64.checkRegSPAligned s rn = true) (hal : sz.isAligned (s.readReg64 rn) = true)
    (hcw : s.mem.canWrite (s.readReg64 rn) sz.bytes = true) :
    prog.evalInst (.ldarStlr sz false rn rt) s =
      (s.setMem (s.mem.writeSized sz (s.readReg64 rn) (s.readReg64 rt))).setPC (s.pc + 4) := by
  simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, hsp, hal, hcw, Bool.not_true,
    Bool.false_eq_true, ↓reduceIte]
  rfl

/-- A load from an aligned address is sound. -/
theorem sound_ldar (prog : Arm64.Program) {sz : MemWidth} {rn rt : Arm64.Reg} (h : Rel s σ)
    (hw : (lowerLdar s.pc sz rn rt).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.ldarStlr sz true rn rt) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.ldarStlr sz true rn rt) s).mem := by
  simp only [lowerLdar, Block.wp, List.append_assoc] at hw
  obtain ⟨hsp, ρ₁, hw⟩ := wp_baseOps h hw
  obtain ⟨hal, ρ₂, hlt, hw⟩ := wp_alignOps (a := 0) (t := 5) (by decide) hw
  simp only [List.cons_append, List.nil_append, wpOps, Op.wp] at hw
  obtain ⟨v, hv, hw⟩ := hw
  obtain ⟨hcr, rfl⟩ := h.load hv
  obtain ⟨σ', h', hw⟩ := wp_rset' h hw
  simp only [Term.wp] at hw
  simp only [hlt 0 (by decide), envExt_self, Env.set_same] at hal hcr h'
  exact step_done (h'.setPC _) hw (evalInst_ldar prog sz rn rt hsp hal hcr)

/-- A store to an aligned address is sound. -/
theorem sound_stlr (prog : Arm64.Program) {sz : MemWidth} {rn rt : Arm64.Reg} (h : Rel s σ)
    (hw : (lowerStlr s.pc sz rn rt).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.ldarStlr sz false rn rt) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.ldarStlr sz false rn rt) s).mem := by
  simp only [lowerStlr, Block.wp, wpOps, List.append_assoc] at hw
  have hw := wp_rget h hw
  obtain ⟨hsp, ρ₁, hw⟩ := wp_baseOps h hw
  obtain ⟨hal, ρ₂, hlt, hw⟩ := wp_alignOps (a := 1) (t := 6) (by decide) hw
  simp only [wpOps, Op.wp] at hw
  obtain ⟨m, hm, hw⟩ := hw
  obtain ⟨hcw, h₂⟩ := h.store hm
  have hk := h.store_keeps hm
  simp only [Term.wp] at hw
  simp only [hlt 1 (by decide), hlt 0 (by decide), envExt_self,
    envExt_lt _ _ _ (show 0 < 1 by decide), Env.set_same] at hal hcw h₂ hk
  exact step_done (h₂.setPC _) hw (evalInst_stlr prog sz rn rt hsp hal hcw) hk

/-- The new value of an atomic read-modify-write is the model's. -/
theorem wp_atomicOps {op : Arm64.AtomicOp} {sz : MemWidth} {ρ : Env} {K : Env → State → Prop}
    {rest : List Op} {m : Arm64.Memory} {a : Word} (hold : ρ 30 = m.readSized sz false a)
    (hw : wpOps (atomicOps op sz ++ rest) ρ σ K) :
    ∃ ρ' : Env, ρ' 40 = Arm64.evalAtomicOp op sz (ρ 30) (ρ 0) ∧
      (∀ y : Nat, y < 31 → ρ' y = ρ y) ∧
      wpOps rest ρ' σ K := by
  cases op <;> cases sz <;>
    simp only [atomicOps, MemWidth.bytes, Nat.reduceMul, List.cons_append, List.nil_append,
      wpOps, Op.wp] at hw <;>
    refine ⟨_, ?_, fun y hy => by env_below hy, hw⟩ <;>
    simp only [Env.set_apply, Nat.reduceEqDiff, ↓reduceIte, Arm64.evalAtomicOp, MemWidth.bytes,
      Nat.reduceMul, Nat.reduceSub, hold, Arm64.Memory.readSized, ofBool,
      Bool.false_eq_true, BinOp.eval_add, BinOp.eval_and, BinOp.eval_or, BinOp.eval_xor,
      BinOp.eval_ult, BinOp.eval_slt, UnOp.eval_not, UnOp.eval_zext, UnOp.eval_sext] <;>
    generalize ρ 0 = r <;>
    generalize m.read8 a = b₁ <;> generalize m.read16 a = b₂ <;>
    generalize m.read32 a = b₃ <;> generalize m.read64 a = b₄ <;>
    bv_decide

theorem evalInst_atomic (prog : Arm64.Program) (op : Arm64.AtomicOp) (sz : MemWidth)
    (acq rel : Bool) (rs rn rt : Arm64.Reg) (hsp : Arm64.checkRegSPAligned s rn = true)
    (hal : sz.isAligned (s.readReg64 rn) = true)
    (hcr : s.mem.canRead (s.readReg64 rn) sz.bytes = true)
    (hcw : s.mem.canWrite (s.readReg64 rn) sz.bytes = true) :
    prog.evalInst (.atomicRmw op sz acq rel rs rn rt) s =
      ((s.setMem (s.mem.writeSized sz (s.readReg64 rn) (Arm64.evalAtomicOp op sz
        (s.mem.readSized sz false (s.readReg64 rn)) (s.readReg64 rs)))).writeReg64 rt
          (s.mem.readSized sz false (s.readReg64 rn))).setPC (s.pc + 4) := by
  cases sz <;>
    simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, hsp, hal, hcr, hcw, writeReg_eq,
      Bool.not_true, Bool.false_eq_true, ↓reduceIte, Bool.and_self]
  · exact wr_eq _ (norm_readSized .B8 _ _)
  · exact wr_eq _ (norm_readSized .H16 _ _)
  · exact wr_eq _ (norm_readSized .W32 _ _)
  · exact wr_eq _ (norm_readSized .X64 _ _)

/-- An atomic read-modify-write is sound. -/
theorem sound_atomicRmw (prog : Arm64.Program) {op : Arm64.AtomicOp} {sz : MemWidth}
    {acq rel : Bool} {rs rn rt : Arm64.Reg} (h : Rel s σ)
    (hw : (lowerAtomic s.pc op sz rs rn rt).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.atomicRmw op sz acq rel rs rn rt) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.atomicRmw op sz acq rel rs rn rt) s).mem := by
  simp only [lowerAtomic, Block.wp, wpOps, List.append_assoc] at hw
  have hw := wp_rget h hw
  obtain ⟨hsp, ρ₁, hw⟩ := wp_baseOps h hw
  obtain ⟨hal, ρ₂, hlt, hw⟩ := wp_alignOps (a := 1) (t := 6) (by decide) hw
  simp only [List.cons_append, List.nil_append, wpOps, Op.wp] at hw
  obtain ⟨v, hv, hw⟩ := hw
  obtain ⟨hcr, rfl⟩ := h.load hv
  obtain ⟨ρ₃, h40, hlt3, hw⟩ := wp_atomicOps (Env.set_same ..) hw
  simp only [wpOps, Op.wp] at hw
  obtain ⟨m, hm, hw⟩ := hw
  obtain ⟨hcw, h₂⟩ := h.store hm
  have hk := h.store_keeps hm
  obtain ⟨σ', h', hw⟩ := wp_rset' h₂ hw
  simp only [Term.wp] at hw
  have e0 : ∀ v' : Word, (ρ₂.set 30 v') 0 = s.readReg64 rs := fun v' => by
    rw [set_below _ _ (by decide), hlt 0 (by decide), envExt_lt _ _ _ (by decide), Env.set_same]
  simp only [h40, hlt3 30 (by decide), hlt3 1 (by decide), Env.set_same, e0,
    set_below _ _ (show 1 < 30 by decide), hlt 1 (by decide), envExt_self] at hal hcr hcw h' hk
  exact step_done (h'.setPC _) hw
    (evalInst_atomic prog op sz acq rel rs rn rt hsp hal hcr hcw) hk

/-- One instruction: the machine executes it and stays running, in a state related to one
satisfying the postcondition, and it keeps the bytes that may not be stored to. -/
theorem lower_step (prog : Arm64.Program) {i : Instr} (h : Rel s σ)
    (hw : (lower s.pc i).wp σ Q) :
    ∃ σ', Rel (prog.evalInst i s) σ' ∧ Q σ' ∧ KeepsCode s.mem (prog.evalInst i s).mem := by
  cases i
  case nop | hint | barrier | prfm | prfmLit =>
    simp only [lower, Block.wp, wpOps, Term.wp] at hw
    exact step_done h.advancePC hw rfl
  case adr page rd offset =>
    simp only [lower] at hw
    arm_ops h hw
    obtain ⟨σ', h', hw⟩ := wp_rset' h hw
    simp only [Term.wp] at hw
    exact step_done (h'.setPC _) hw (by env_simp; rfl)
  case addSubImm w op rd rn imm12 shift12 =>
    simp only [lower] at hw
    arm_ops h hw
    obtain ⟨ρ₁, σ₁, h₁, hw⟩ := wp_addSubOps h (by decide) (by decide)
      (by env_simp; exact norm_readReg _ _)
      (by env_simp; cases w <;> cases shift12 <;> simp only [norm] <;> bv_decide) hw
    obtain ⟨σ₂, h₂, hw⟩ := wp_rset' h₁ hw
    simp only [Term.wp] at hw
    refine step_done (h₂.setPC _) hw ?_
    env_simp
    exact modelRes_eq w rd (Arm64.evalAddSub w op _ _ none) (norm_evalAddSub ..)
  case addSubShift w op rd rn rm shift amount =>
    simp only [lower] at hw
    arm_ops h hw
    simp only [run_shiftStages, ← readReg_eq] at hw
    obtain ⟨ρ₁, σ₁, h₁, hw⟩ := wp_addSubOps h (by decide) (by decide)
      (by env_simp; exact norm_readReg _ _) (by env_simp; exact norm_shiftVal ..) hw
    obtain ⟨σ₂, h₂, hw⟩ := wp_rset' h₁ hw
    simp only [Term.wp] at hw
    refine step_done (h₂.setPC _) hw ?_
    env_simp
    exact modelRes_eq w rd (Arm64.evalAddSub w op _ _ none) (norm_evalAddSub ..)
  case logicalImm w op rd rn mask =>
    simp only [lower] at hw
    arm_ops h hw
    obtain ⟨ρ₁, σ₁, h₁, hw⟩ := wp_logicOps h (by decide)
      (by env_simp; exact norm_readReg _ _) (by env_simp; exact norm_norm ..) hw
    obtain ⟨σ₂, h₂, hw⟩ := wp_rset' h₁ hw
    simp only [Term.wp] at hw
    refine step_done (h₂.setPC _) hw ?_
    env_simp
    rw [evalLogical_norm]
    exact modelRes_eq w rd (Arm64.evalLogical w op _ _ _) (norm_evalLogical ..)
  case logicalShift w op rd rn rm shift amount =>
    simp only [lower] at hw
    arm_ops h hw
    simp only [run_shiftStages, ← readReg_eq] at hw
    obtain ⟨ρ₁, σ₁, h₁, hw⟩ := wp_logicOps h (by decide)
      (by env_simp; exact norm_readReg _ _) (by env_simp; exact norm_shiftVal ..) hw
    obtain ⟨σ₂, h₂, hw⟩ := wp_rset' h₁ hw
    simp only [Term.wp] at hw
    refine step_done (h₂.setPC _) hw ?_
    env_simp
    exact modelRes_eq w rd (Arm64.evalLogical w op _ _ _) (norm_evalLogical ..)
  case moveWide w op rd imm16 hw' =>
    cases op <;> simp only [lower] at hw <;> arm_ops h hw <;>
      obtain ⟨σ', h', hw⟩ := wp_rset' h hw <;>
      simp only [Term.wp] at hw <;>
      refine step_done (h'.setPC _) hw ?_ <;>
      env_simp <;>
      simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, Arm64.execMoveWide, writeReg_eq]
    · rfl
    · rfl
    · simp only [BinOp.eval_or, BinOp.eval_and, readReg_eq]
      generalize s.readReg64 rd = x
      generalize (65535#64 <<< hw') = m
      generalize BitVec.zeroExtend 64 imm16 <<< hw' = k
      have e : norm w (norm w x &&& ~~~m ||| k) = norm w x &&& norm w (~~~m) ||| norm w k := by
        cases w <;> first | (simp only [norm]; done) | (simp only [norm]; bv_decide)
      rw [e]
      rfl
  case b offset =>
    simp only [lower, Block.wp, wpOps, Term.wp] at hw
    exact step_done (h.setPC _) hw rfl
  case bl offset =>
    simp only [lower] at hw
    arm_ops h hw
    obtain ⟨σ', h', hw⟩ := wp_rset' h hw
    simp only [Term.wp] at hw
    exact step_done (h'.setPC _) hw (by env_simp; rfl)
  case bCond cond offset =>
    simp only [lower] at hw
    rw [← List.append_nil (condOps _ _)] at hw
    arm_ops h hw
    simp only [Term.wp] at hw
    refine step_done (h.setPC _) hw ?_
    simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc]
    cases Arm64.ConditionHolds cond s.pstate <;> simp <;> rfl
  case cbz w isNonZero rt offset =>
    simp only [lower] at hw
    rw [← List.append_nil (rgetW _ _ _)] at hw
    arm_ops h hw
    cases isNonZero <;> simp only [Term.wp, Bool.false_eq_true, ↓reduceIte] at hw <;>
      refine step_done (h.setPC _) hw ?_ <;>
      env_simp <;>
      simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc] <;>
      by_cases hz : s.readReg w rt = 0#64 <;> simp [hz] <;> rfl
  case br rn =>
    simp only [lower] at hw
    arm_ops h hw
    simp only [Term.wp] at hw
    exact step_done (h.setPC _) hw (by env_simp; rfl)
  case ret rn =>
    simp only [lower] at hw
    arm_ops h hw
    simp only [Term.wp] at hw
    exact step_done (h.setPC _) hw (by env_simp; rfl)
  case blr rn =>
    simp only [lower] at hw
    arm_ops h hw
    obtain ⟨σ', h', hw⟩ := wp_rset' h hw
    simp only [Term.wp] at hw
    exact step_done (h'.setPC _) hw (by env_simp; rfl)
  case ldr w sz signed rt addr =>
    simp only [lower, Block.wp, List.append_assoc] at hw
    obtain ⟨hsp, ρ₁, σ₁, h₁, hw⟩ := wp_addrOps h hw
    obtain ⟨hcr, ρ₂, hw⟩ := wp_chain_load h₁ hw
    obtain ⟨σ₂, h₂, hw⟩ := wp_rset' h₁ hw
    simp only [Term.wp] at hw
    simp only [envExt_self, wbState_mem] at hcr
    refine step_done (h₂.setPC _) hw ?_ (wbState_mem s addr ▸ KeepsCode.refl _)
    simp only [envExt_self, wbState_mem, run_loadStages, ← writeReg_eq]
    exact execLdr_eq w sz signed rt hsp hcr
  case str sz rt addr =>
    simp only [lower, Block.wp, wpOps] at hw
    have hw := wp_rget h hw
    obtain ⟨hsp, ρ₁, σ₁, h₁, hw⟩ := wp_addrOps h hw
    simp only [wpOps, Op.wp] at hw
    obtain ⟨m, hm, hw⟩ := hw
    obtain ⟨hcw, h₂⟩ := h₁.store hm
    have hk := h₁.store_keeps hm
    simp only [Term.wp] at hw
    simp only [envExt_self, wbState_mem] at hcw
    rw [wbState_mem] at hk
    refine step_done (h₂.setPC _) hw ?_ (by
      show KeepsCode s.mem ((wbState s addr).mem.writeSized _ _ _)
      rw [wbState_mem]
      exact hk)
    simp only [envExt_self, wbState_mem, envExt_lt _ _ _ (show 0 < 1 by decide), Env.set_same]
    exact execStr_eq sz rt hsp hcw
  case dataProc1 => exact sound_dataProc1 prog h hw
  case dataProc2 => exact sound_dataProc2 prog h hw
  case dataProc3 => exact sound_dataProc3 prog h hw
  case extr => exact sound_extr prog h hw
  case ldrLit => exact sound_ldrLit prog h hw
  case ldp | ldnp => exact sound_ldp h hw
  case stp | stnp => exact sound_stp h hw
  case condSelect => exact sound_condSelect prog h hw
  case tbz => exact sound_tbz prog h hw
  case addSubExt => exact sound_addSubExt prog h hw
  case condCompareReg => exact sound_condCompareReg prog h hw
  case condCompareImm => exact sound_condCompareImm prog h hw
  case addSubCarry => exact sound_addSubCarry prog h hw
  case bitfield => exact sound_bitfield prog h hw
  case ldarStlr sz isLoad rn rt =>
    cases isLoad
    · exact sound_stlr prog h hw
    · exact sound_ldar prog h hw
  case ldxr | ldapr => exact sound_ldar prog h hw
  case atomicRmw => exact sound_atomicRmw prog h hw
  case ldrSimd => exact sound_ldrSimd prog h hw
  case strSimd => exact sound_strSimd prog h hw
  case ldpSimd => exact sound_ldpSimd prog h hw
  case stpSimd => exact sound_stpSimd prog h hw
  case fmovGprVec => exact sound_fmovGprVec prog _ _ h hw
  case fpDataProc1 => exact sound_fpDataProc1 prog _ _ h hw
  case simdImmShift => exact sound_simdImmShift prog _ _ h hw
  case simdThreeSame => exact sound_simdThreeSame prog _ _ _ h hw
  case ldnpSimd =>
    exact (evalInst_ldnpSimd prog ..).symm ▸ sound_ldpSimd prog h hw
  case stnpSimd =>
    exact (evalInst_stnpSimd prog ..).symm ▸ sound_stpSimd prog h hw
  case fpImm => exact sound_fpImm prog _ h hw
  case fpCondSelect => exact sound_fpCondSelect prog _ _ _ h hw
  case simdTwoRegMisc => exact sound_simdTwoRegMisc prog _ _ h hw
  case simdAddpScalar => exact sound_simdAddpScalar prog _ _ h hw
  case simdInsDup => exact sound_simdInsDup prog _ _ h hw
  case simdExt => exact sound_simdExt prog _ _ _ h hw
  case cryptoSha2Reg => exact sound_cryptoSha2Reg prog _ _ h hw
  case cryptoSha3Reg => exact sound_cryptoSha3Reg prog _ _ _ h hw
  all_goals exact absurd hw (by simp [lower, Block.wp, wpOps, Term.wp])

/-- **One instruction of the AArch64 lowering is sound.** If the block of the instruction
`i` at the program counter runs from `σ` without fault and establishes `Q`, the machine
executes `i` from a related state and lands, still running, in a state related to one
satisfying `Q`. -/
theorem lower_sound (prog : Arm64.Program) {i : Instr} (h : Rel s σ)
    (hw : (lower s.pc i).wp σ Q) : ∃ σ', Rel (prog.evalInst i s) σ' ∧ Q σ' :=
  let ⟨σ', h', hq, _⟩ := lower_step prog h hw
  ⟨σ', h', hq⟩

/-! ## Programs -/

/-- Loaded code stays loaded in a memory that keeps the bytes that may not be stored to:
code is mapped read-execute, so no store reaches it. -/
theorem codeLoaded_of_keepsCode {prog : Arm64.Program} {m m' : Arm64.Memory}
    (hc : prog.CodeLoaded m) (hk : KeepsCode m m') : prog.CodeLoaded m' := by
  unfold Arm64.Program.CodeLoaded at hc ⊢
  refine ⟨hc.1, hc.2.1, fun i hi => ?_⟩
  obtain ⟨hr, hp, hl⟩ := hc.2.2 i hi
  obtain ⟨hr', hp', hl'⟩ := hk (prog.base + BitVec.ofNat 64 i) (by simp only [writable, hp]; rfl)
  exact ⟨hr'.trans hr, hp'.trans hp, hl'.trans hl⟩

/-- When the code is loaded, an instruction fetched from the code image is the one fetched
from memory. -/
theorem fetchMem_of_fetch {prog : Arm64.Program} {m : Arm64.Memory} {pc : Word} {i : Instr}
    (hc : prog.CodeLoaded m) (hf : prog.fetch pc = some i) : prog.fetchMem m pc = some i := by
  unfold Arm64.Program.CodeLoaded at hc
  obtain ⟨hbase, hlen, hcode⟩ := hc
  simp only [Arm64.Program.fetch] at hf
  split at hf
  · cases hf
  rename_i hext
  simp only [Arm64.Program.readWordOff] at hf
  split at hf
  · cases hf
  rename_i hoff
  split at hf
  · rename_i b0 b1 b2 b3 tl hd
    simp only [Option.bind_some] at hf
    generalize hoffd : (pc - prog.base).toNat = off at hoff hd
    have hpc : prog.base + BitVec.ofNat 64 off = pc := by
      rw [← hoffd, BitVec.ofNat_toNat, BitVec.setWidth_eq]
      bv_omega
    have hlen4 : off + 4 ≤ prog.code.length := by
      have := congrArg List.length hd
      simp only [List.length_drop, List.length_cons] at this
      omega
    have key : ∀ k b, (b0 :: b1 :: b2 :: b3 :: tl)[k]? = some b →
        m.read8 (pc + BitVec.ofNat 64 k) = b ∧
          m.perm (pc + BitVec.ofNat 64 k) = some Arm64.Perm.rx := by
      intro k b hkb
      have h1 : prog.code[off + k]? = some b := by rw [← hkb, ← hd, List.getElem?_drop]
      obtain ⟨hlt, hget⟩ := List.getElem?_eq_some_iff.1 h1
      obtain ⟨hr, hp, _⟩ := hcode (off + k) hlt
      rw [BitVec.ofNat_add, ← BitVec.add_assoc, hpc] at hr hp
      exact ⟨hr.trans hget, hp⟩
    obtain ⟨r0, p0⟩ := key 0 b0 rfl
    obtain ⟨r1, p1⟩ := key 1 b1 rfl
    obtain ⟨r2, p2⟩ := key 2 b2 rfl
    obtain ⟨r3, p3⟩ := key 3 b3 rfl
    have hal : pc.toNat % 4 = 0 := by
      have := congrArg BitVec.toNat hpc
      simp only [BitVec.toNat_add, BitVec.toNat_ofNat] at this
      omega
    have e0 : pc + 0#64 = pc := by bv_decide
    have e2 : pc + 1#64 + 1#64 = pc + 2#64 := by bv_decide
    have e3 : pc + 2#64 + 1#64 = pc + 3#64 := by bv_decide
    rw [e0] at r0 p0
    simp only [Arm64.Program.fetchMem, hext, hal, Arm64.Memory.canExec, Arm64.Memory.allPerm,
      Arm64.Memory.read32, e0, e2, e3, p0, p1, p2, p3, r0, r1, r2, r3]
    simpa [Arm64.Perm.rx] using hf
  · cases hf

/-- **The AArch64 lowering is sound.** If the code of `prog` is loaded and every run of the
lowered program from `σ` reaches `Q`, then the machine, from a state related to `σ`, runs
some number of steps, each the execution of an instruction, to a running state related to
one satisfying `Q`. -/
theorem lowerProgram_sound {prog : Arm64.Program} (hc : prog.CodeLoaded s.mem) (h : Rel s σ)
    (hw : Eventually (lowerProgram prog) Q σ) :
    ∃ s' σ', Arm64.Steps prog s s' ∧ Rel s' σ' ∧ Q σ' := by
  induction hw generalizing s with
  | done σ hq => exact ⟨s, σ, .refl s, h, hq⟩
  | step σ R hs _ ih =>
    obtain ⟨b, hb, hwp⟩ := hs
    simp only [lowerProgram, Option.map_eq_some_iff] at hb
    obtain ⟨i, hi, rfl⟩ := hb
    rw [h.pc] at hi hwp
    obtain ⟨σ₁, h₁, hr, hk⟩ := lower_step prog h hwp
    obtain ⟨s', σ', hsteps, h', hq⟩ := ih σ₁ hr (codeLoaded_of_keepsCode hc hk) h₁
    exact ⟨s', σ', .step (.exec h.status (fetchMem_of_fetch hc hi)) hsteps, h', hq⟩

end Lowering.Arm
