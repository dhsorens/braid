/-
  Lowering.Arm.Rel

  The relation between a machine state and a `braid` state, and what each group of
  operations the lowering is built from (a register read, a chain, the flags of an
  addition, an address, a load, a store) leaves in the environment and the state. The
  instructions are put together from these in `Simd.lean` and `Sound.lean`.

  ## Main definitions

  * `Rel`: a machine state and a `braid` state that describe the same machine
  * `KeepsCode`: a memory keeps the bytes of another that may not be stored to

  ## Main results

  * `wp_rget`, `wp_rset`, `wp_chain`, `wp_addSubOps`, `wp_logicOps`, `wp_addrOps`: the
    groups of operations
  * `Rel.load`, `Rel.store`: a load or store that `braid` allows is one the machine allows
  * `step_done`: the step of one instruction, from the state it reaches
-/

module

public import Lowering.Arm.Lower
public import Lowering.Arm.Mem
import Std.Tactic.BVDecide
import Braid.BV

@[expose] public section

namespace Lowering.Arm

open Braid
open Arm64 (Instr RegWidth MemWidth CondCode ShiftType ExtendType AddrMode AddSubOp LogicalOp
  MoveWideOp BitfieldOp CondSelectOp DataProc1Op DataProc2Op DataProc3Op)

/-- The machine state `s` and the `braid` state `σ` describe the same machine: the same
registers, stack pointer, flags and program counter, the machine is running, and `braid`
memory has a cell exactly at the bytes the machine may load, writable exactly where the
machine may store. A vector register is two `braid` registers: `V k` has its bits 0 to 63
in register `64 + 2 * k` and its bits 64 to 127 in register `65 + 2 * k`. -/
structure Rel (s : Arm64.State) (σ : State) : Prop where
  regs : ∀ i : BitVec 5, i ≠ 31#5 → σ.regs i.toNat = s.regs.read i
  sp : σ.regs 31 = s.sp
  n : σ.flags 0 = s.pstate.n
  z : σ.flags 1 = s.pstate.z
  c : σ.flags 2 = s.pstate.c
  v : σ.flags 3 = s.pstate.v
  pc : σ.pc = s.pc
  status : s.status = .Running
  mem : ∀ a, σ.mem a =
    if readable s.mem a then some ⟨s.mem.read8 a, writable s.mem a⟩ else none
  vlo : ∀ k : BitVec 5, σ.regs (64 + 2 * k.toNat) = (s.vregs.read k).truncate 64
  vhi : ∀ k : BitVec 5, σ.regs (65 + 2 * k.toNat) = (s.vregs.read k).extractLsb' 64 64

variable {s : Arm64.State} {σ : State}

theorem Rel.cast {s' : Arm64.State} (h : Rel s σ) (e : s' = s) : Rel s' σ := e ▸ h

theorem Rel.setPC (h : Rel s σ) (a : Word) : Rel (s.setPC a) (σ.setPc a) :=
  ⟨h.regs, h.sp, h.n, h.z, h.c, h.v, rfl, h.status, h.mem, h.vlo, h.vhi⟩

theorem Rel.advancePC (h : Rel s σ) : Rel s.advancePC (σ.setPc (s.pc + 4)) :=
  ⟨h.regs, h.sp, h.n, h.z, h.c, h.v, rfl, h.status, h.mem, h.vlo, h.vhi⟩

theorem Rel.setPState (h : Rel s σ) (n z c v : Bool) :
    Rel (s.setPState ⟨n, z, c, v⟩)
      ((((σ.setFlag 0 n).setFlag 1 z).setFlag 2 c).setFlag 3 v) :=
  ⟨h.regs, h.sp, rfl, rfl, rfl, rfl, h.pc, h.status, h.mem, h.vlo, h.vhi⟩

theorem toNat_ne_31 {i : BitVec 5} (hi : i ≠ 31#5) : i.toNat ≠ 31 :=
  fun h => hi (BitVec.eq_of_toNat_eq h)

theorem Rel.writeGpr (h : Rel s σ) {i : BitVec 5} (hi : i ≠ 31#5) (v : Word) :
    Rel (s.writeReg64 (.gpr i) v) (σ.setReg i.toNat v) := by
  have hlt := i.isLt
  refine ⟨fun j hj => ?_, ?_, h.n, h.z, h.c, h.v, h.pc, h.status, h.mem, fun k => ?_,
    fun k => ?_⟩
  · simp only [State.setReg, Arm64.State.writeReg64, beq_iff_eq, hi, ↓reduceIte,
      Arm64.RegFile.read, Arm64.RegFile.write]
    by_cases hji : j = i
    · subst hji; simp
    · have hn : j.toNat ≠ i.toNat := fun hn => hji (BitVec.eq_of_toNat_eq hn)
      simpa [hn, hji, Arm64.RegFile.read] using h.regs j hj
  · simp only [State.setReg, Arm64.State.writeReg64]
    have := toNat_ne_31 hi
    simpa [Ne.symm this] using h.sp
  · have hne : 64 + 2 * k.toNat ≠ i.toNat := by omega
    simpa only [State.setReg, Arm64.State.writeReg64, hne, ↓reduceIte] using h.vlo k
  · have hne : 65 + 2 * k.toNat ≠ i.toNat := by omega
    simpa only [State.setReg, Arm64.State.writeReg64, hne, ↓reduceIte] using h.vhi k

theorem Rel.writeSp (h : Rel s σ) (v : Word) : Rel (s.writeReg64 .sp v) (σ.setReg 31 v) := by
  refine ⟨fun j hj => ?_, ?_, h.n, h.z, h.c, h.v, h.pc, h.status, h.mem, fun k => ?_,
    fun k => ?_⟩
  · simp only [State.setReg, Arm64.State.writeReg64]
    simpa [toNat_ne_31 hj] using h.regs j hj
  · simp [State.setReg, Arm64.State.writeReg64]
  · have hne : 64 + 2 * k.toNat ≠ 31 := by omega
    simpa only [State.setReg, Arm64.State.writeReg64, hne, ↓reduceIte] using h.vlo k
  · have hne : 65 + 2 * k.toNat ≠ 31 := by omega
    simpa only [State.setReg, Arm64.State.writeReg64, hne, ↓reduceIte] using h.vhi k

/-! ## Registers -/

/-- Reading a register gives the machine's value. -/
theorem wp_rget (h : Rel s σ) {d : Var} {r : Arm64.Reg} {ρ : Env} {Q : Env → State → Prop}
    (hw : (rget d r).wp ρ σ Q) : Q (ρ.set d (s.readReg64 r)) σ := by
  cases r with
  | gpr i =>
    simp only [rget] at hw
    simp only [Arm64.State.readReg64, beq_iff_eq]
    split at hw
    · rename_i hi; simpa [hi, Op.wp] using hw
    · rename_i hi
      simp only [Op.wp] at hw
      rw [h.regs i hi] at hw
      simpa [hi] using hw
  | sp => simp only [rget, Op.wp] at hw; rw [h.sp] at hw; exact hw
  | xzr => exact hw

/-- Writing a register gives a state related to the machine's. -/
theorem wp_rset (h : Rel s σ) {r : Arm64.Reg} {a : Var} {ρ : Env} {Q : Env → State → Prop}
    {rest : List Op} (hw : wpOps (rset r a ++ rest) ρ σ Q) :
    ∃ σ', Rel (s.writeReg64 r (ρ a)) σ' ∧ wpOps rest ρ σ' Q := by
  cases r with
  | gpr i =>
    simp only [rset] at hw
    split at hw
    · rename_i hi; subst hi; exact ⟨σ, h, hw⟩
    · rename_i hi; exact ⟨_, h.writeGpr hi _, hw⟩
  | sp => exact ⟨_, h.writeSp _, hw⟩
  | xzr => exact ⟨σ, h, hw⟩

/-! ## Environments -/

/-- The environment after a group of operations that defines `d`, uses values above `d` on
the way, and leaves the values below `d` alone. -/
def envExt (ρ : Env) (d : Nat) (v : Word) (ρ₁ : Env) : Env :=
  fun y => if y < d then ρ y else if y = d then v else ρ₁ y

theorem envExt_apply (ρ : Env) (d : Nat) (v : Word) (ρ₁ : Env) (y : Nat) :
    envExt ρ d v ρ₁ y = if y < d then ρ y else if y = d then v else ρ₁ y := rfl

theorem wpOps_ext {rest : List Op} {ρ ρ' : Env} {d : Nat} {v : Word} {Q : Env → State → Prop}
    (hw : wpOps rest ρ' σ Q) (hd : ρ' d = v) (hlt : ∀ y, y < d → ρ' y = ρ y) :
    ∃ ρ₁, wpOps rest (envExt ρ d v ρ₁) σ Q := by
  refine ⟨ρ', ?_⟩
  have e : envExt ρ d v ρ' = ρ' := by
    funext y
    simp only [envExt_apply]
    split
    · rename_i hy; exact (hlt y hy).symm
    · split
      · rename_i hy; subst hy; exact hd.symm
      · rfl
  rw [e]; exact hw

/-! ## Chains -/

theorem wp_chainFrom {d : Nat} {sts : List Stage} (hne : sts ≠ []) {cur n : Nat}
    (hcur : d < cur) (hn : cur < n) {ρ : Env} {Q : Env → State → Prop} {rest : List Op}
    (hw : wpOps (chainFrom d cur n sts ++ rest) ρ σ Q) :
    ∃ ρ' : Env, ρ' d = Stage.run sts (ρ cur) ∧ (∀ y, y < d → ρ' y = ρ y) ∧
      wpOps rest ρ' σ Q := by
  induction sts generalizing cur n ρ with
  | nil => exact absurd rfl hne
  | cons st sts ih =>
    cases sts with
    | nil =>
      cases st with
      | un op =>
        simp only [chainFrom, Stage.ops, List.cons_append, List.nil_append, wpOps, Op.wp] at hw
        refine ⟨_, ?_, fun y hy => ?_, hw⟩
        · simp [Stage.run, Stage.eval]
        · simp [Nat.ne_of_lt hy]
      | binc op c =>
        simp only [chainFrom, Stage.ops, List.cons_append, List.nil_append, wpOps, Op.wp] at hw
        refine ⟨_, ?_, fun y hy => ?_, hw⟩
        · simp [Stage.run, Stage.eval, Nat.ne_of_lt hn]
        · have h1 : y ≠ d := Nat.ne_of_lt hy
          have h2 : y ≠ n := by omega
          simp [h1, h2]
    | cons st' sts' =>
      cases st with
      | un op =>
        simp only [chainFrom, Stage.ops, List.cons_append, List.nil_append, wpOps, Op.wp] at hw
        obtain ⟨ρ', hd, hlt, hw⟩ := ih (by simp) (by omega) (by omega) hw
        refine ⟨ρ', ?_, fun y hy => ?_, hw⟩
        · rw [hd]; simp [Stage.run, Stage.eval]
        · rw [hlt y hy]
          have h1 : y ≠ n + 1 := by omega
          simp [h1]
      | binc op c =>
        simp only [chainFrom, Stage.ops, List.cons_append, List.nil_append, wpOps, Op.wp] at hw
        obtain ⟨ρ', hd, hlt, hw⟩ := ih (by simp) (by omega) (by omega) hw
        refine ⟨ρ', ?_, fun y hy => ?_, hw⟩
        · rw [hd]; simp [Stage.run, Stage.eval, Nat.ne_of_lt hn]
        · rw [hlt y hy]
          have h1 : y ≠ n + 1 := by omega
          have h2 : y ≠ n := by omega
          simp [h1, h2]

/-- A chain puts the value of its first operation through its steps. -/
theorem wp_chain {d : Nat} {first : Var → Op} {sts : List Stage} {v₀ : Word} {ρ : Env}
    {Q : Env → State → Prop} {rest : List Op}
    (hfirst : ∀ (x : Var) (Q' : Env → State → Prop), (first x).wp ρ σ Q' → Q' (ρ.set x v₀) σ)
    (hw : wpOps (chain d first sts ++ rest) ρ σ Q) :
    ∃ ρ₁, wpOps rest (envExt ρ d (Stage.run sts v₀) ρ₁) σ Q := by
  cases sts with
  | nil =>
    simp only [chain, List.cons_append, List.nil_append, wpOps] at hw
    exact wpOps_ext (hfirst _ _ hw) (by simp [Stage.run]) fun y hy => by
      simp [Nat.ne_of_lt hy]
  | cons st sts =>
    simp only [chain, List.cons_append, wpOps] at hw
    obtain ⟨ρ', hd, hlt, hw⟩ := wp_chainFrom (by simp) (by omega) (by omega) (hfirst _ _ hw)
    refine wpOps_ext hw (by simpa using hd) fun y hy => ?_
    rw [hlt y hy]
    have h1 : y ≠ d + 1 := by omega
    simp [h1]

/-- A chain from a register. -/
theorem wp_chain_rget (h : Rel s σ) {d : Var} {r : Arm64.Reg} {sts : List Stage} {ρ : Env}
    {Q : Env → State → Prop} {rest : List Op}
    (hw : wpOps (chain d (rget · r) sts ++ rest) ρ σ Q) :
    ∃ ρ₁, wpOps rest (envExt ρ d (Stage.run sts (s.readReg64 r)) ρ₁) σ Q :=
  wp_chain (fun _ _ hw => wp_rget h hw) hw

theorem readReg_eq (w : RegWidth) (r : Arm64.Reg) : s.readReg w r = norm w (s.readReg64 r) := by
  cases w <;> rfl

theorem writeReg_eq (w : RegWidth) (r : Arm64.Reg) (v : Word) :
    s.writeReg w r v = s.writeReg64 r (norm w v) := by
  cases w <;> rfl

/-- Reading a register at a width gives the machine's value. -/
theorem wp_rgetW (h : Rel s σ) {d : Var} {w : RegWidth} {r : Arm64.Reg} {ρ : Env}
    {Q : Env → State → Prop} {rest : List Op} (hw : wpOps (rgetW d w r ++ rest) ρ σ Q) :
    ∃ ρ₁, wpOps rest (envExt ρ d (s.readReg w r) ρ₁) σ Q := by
  cases w <;> exact wp_chain_rget h hw

/-! ## The values of chains -/

/-- A shift amount below 64, as a word. -/
theorem exists_bv_of_lt {k : Nat} (hk : k < 64) : ∃ kb : Word, kb < 64#64 ∧ k = kb.toNat :=
  ⟨BitVec.ofNat 64 k, by
    have : (BitVec.ofNat 64 k).toNat = k := by simp; omega
    exact ⟨by bv_omega, this.symm⟩⟩

theorem run_shiftStages (w : RegWidth) (sh : ShiftType) (amount : Nat) (v : Word) :
    Stage.run (shiftStages w sh amount) v = Arm64.shiftVal w (norm w v) sh amount := by
  cases w
  · simp only [shiftStages]
    obtain ⟨kb, hkb, hk⟩ := exists_bv_of_lt (k := amount % 32) (by omega)
    have hkb' : kb < 32#64 := by bv_omega
    split
    · rename_i h0
      cases sh <;> simp [Stage.run, Stage.eval, Arm64.shiftVal, Arm64.shift32, norm, h0, BitVec.rotateRight_def]
    · rename_i h0
      have hk0 : kb ≠ 0#64 := by rintro rfl; exact h0 (by simpa using hk)
      cases sh <;> simp only [Stage.run, Stage.eval, Arm64.shiftVal, Arm64.shift32, norm, hk, List.foldl, BitVec.rotateRight_def, BitVec.ofNat_toNat, BitVec.setWidth_eq, BinOp.eval_shl, BinOp.eval_lshr, BinOp.eval_ashr, BinOp.eval_mul, UnOp.eval_zext, UnOp.eval_sext, BitVec.truncate_eq_setWidth]
      · bv_auto
      · bv_auto
      · bv_auto
      · have e1 : kb.toNat % 32 = kb.toNat := Nat.mod_eq_of_lt (by bv_omega)
        rw [e1, BitVec.ushiftRight_eq',
          Braid.BV.ror32_dup (BitVec.setWidth 32 v) _ (by bv_omega)]
        simp only [BitVec.setWidth_setWidth_of_le, BitVec.setWidth_eq, Nat.reduceLeDiff]
  · simp only [shiftStages]
    obtain ⟨kb, hkb, hk⟩ := exists_bv_of_lt (k := amount % 64) (by omega)
    split
    · rename_i h0
      cases sh <;> simp [Stage.run, Arm64.shiftVal, Arm64.shift64, norm, h0, BitVec.rotateRight_def]
    · cases sh <;> simp only [Stage.run, Stage.eval, Arm64.shiftVal, Arm64.shift64, norm, hk, List.foldl, shiftOp, BitVec.ofNat_toNat, BitVec.setWidth_eq, BinOp.eval_shl, BinOp.eval_lshr, BinOp.eval_ashr, BinOp.eval_rotr]
      all_goals bv_auto

theorem run_extStages (w : RegWidth) (ext : ExtendType) (amount : Nat) (v : Word) :
    Stage.run (extStages w ext amount) v = Arm64.extendVal w v ext amount := by
  have hsh : ∀ x : Word, Stage.run (if amount = 0 then [] else if amount < 64 then
      [.binc .shl (BitVec.ofNat 64 amount)] else [.binc .and 0#64]) x = x <<< amount := by
    intro x
    split
    · rename_i h; simp [Stage.run, h]
    · split
      · rename_i h
        obtain ⟨kb, hkb, hk⟩ := exists_bv_of_lt h
        simp only [Stage.run, Stage.eval, List.foldl, hk, BitVec.ofNat_toNat, BitVec.setWidth_eq, BinOp.eval_shl]
        bv_auto
      · rename_i h
        simp only [Stage.run, Stage.eval, List.foldl, BinOp.eval_and]
        rw [BitVec.shiftLeft_eq_zero (by omega)]; simp
  have happ : ∀ (a b : List Stage) (x : Word), Stage.run (a ++ b) x = Stage.run b (Stage.run a x) := by
    intro a b x; simp [Stage.run]
  simp only [extStages, happ, hsh]
  cases w <;> cases ext <;> simp only [Stage.run, Stage.eval, List.foldl, Arm64.extendVal, UnOp.eval_zext, UnOp.eval_sext, BitVec.truncate_eq_setWidth]
  all_goals first
    | rfl
    | (have e1 : BitVec.setWidth 32 (BitVec.setWidth 64 (BitVec.setWidth 32 v)) = BitVec.setWidth 32 v := by
         bv_auto
       have e2 : BitVec.setWidth 32 (BitVec.signExtend 64 (BitVec.setWidth 32 v)) = BitVec.setWidth 32 v := by
         bv_auto
       simp only [BitVec.setWidth_shiftLeft_of_le (show 32 ≤ 64 by decide), e1, e2])

theorem run_loadStages (w : RegWidth) (sz : MemWidth) (signed : Bool) (m : Arm64.Memory) (a : Word) :
    Stage.run (loadStages w sz signed) (m.readSized sz false a) = norm w (m.readSized sz signed a) := by
  cases signed
  · cases w <;> cases sz <;> simp [loadStages, Stage.run, norm, Stage.eval, Arm64.Memory.readSized]
  · cases w <;> cases sz <;> simp [loadStages, Stage.run, norm, Stage.eval, Arm64.Memory.readSized]
    generalize m.read32 a = b
    bv_auto

/-! ## Flags -/

/-- Writing the four flags gives a state related to the machine's. -/
theorem wp_setNZCV (h : Rel s σ) {n z c v : Var} {ρ : Env} {Q : Env → State → Prop}
    {rest : List Op} (hw : wpOps (setNZCV n z c v ++ rest) ρ σ Q) :
    ∃ σ', Rel (s.setPState ⟨ρ n != 0#64, ρ z != 0#64, ρ c != 0#64, ρ v != 0#64⟩) σ' ∧
      wpOps rest ρ σ' Q := by
  simp only [setNZCV, List.cons_append, List.nil_append, wpOps, Op.wp] at hw
  exact ⟨_, h.setPState _ _ _ _, hw⟩

theorem set_below (ρ : Env) {x y : Nat} (v : Word) (h : y < x) : ρ.set x v y = ρ y := by
  simp [Env.set, Nat.ne_of_lt h]

/-- Look up a value below `d` in an environment that sets values from `d` up. -/
macro "env_below" hy:ident : tactic => `(tactic|
  (have := $hy; simp (disch := omega) only [set_below]))

/-- The condition of an instruction, from the flags. -/
theorem wp_condOps (h : Rel s σ) {d : Nat} {cond : CondCode} {ρ : Env}
    {Q : Env → State → Prop} {rest : List Op} (hw : wpOps (condOps d cond ++ rest) ρ σ Q) :
    ∃ ρ₁, wpOps rest (envExt ρ d (ofBool (Arm64.ConditionHolds cond s.pstate)) ρ₁) σ Q := by
  cases cond <;>
    simp only [condOps, List.cons_append, List.nil_append, wpOps, Op.wp, h.n, h.z, h.c, h.v]
      at hw <;>
    refine wpOps_ext hw ?_ (fun y hy => by env_below hy) <;>
    simp only [Arm64.ConditionHolds] <;>
    cases s.pstate.n <;> cases s.pstate.z <;> cases s.pstate.c <;> cases s.pstate.v <;>
    simp

/-- The result and the flags of an addition or subtraction at width `w`, as the model
computes them. -/
def addSubRes (w : RegWidth) (isSub : Bool) (x y : Word) (cin : Bool) : Word × Arm64.PState :=
  match w with
  | .W32 =>
    let r := Arm64.AddWithCarry32 (x.truncate 32)
      (if isSub then ~~~(y.truncate 32) else y.truncate 32) cin
    (r.1.zeroExtend 64, r.2)
  | .W64 => Arm64.AddWithCarry64 x (if isSub then ~~~y else y) cin

/-- The environment after a group of operations that defines `d` and the four flag values
after it. -/
def envExt5 (ρ : Env) (d : Nat) (r n z c v : Word) (ρ₁ : Env) : Env :=
  fun y => if y < d then ρ y else if y = d then r else if y = d + 1 then n
    else if y = d + 2 then z else if y = d + 3 then c else if y = d + 4 then v else ρ₁ y

theorem envExt5_apply (ρ : Env) (d : Nat) (r n z c v : Word) (ρ₁ : Env) (y : Nat) :
    envExt5 ρ d r n z c v ρ₁ y = if y < d then ρ y else if y = d then r else if y = d + 1 then n
      else if y = d + 2 then z else if y = d + 3 then c else if y = d + 4 then v else ρ₁ y :=
  rfl

theorem envExt5_lt (ρ : Env) {d : Nat} (r n z c v : Word) (ρ₁ : Env) {y : Nat} (h : y < d) :
    envExt5 ρ d r n z c v ρ₁ y = ρ y := by
  simp [envExt5, h]

theorem envExt5_0 (ρ : Env) (d : Nat) (r n z c v : Word) (ρ₁ : Env) :
    envExt5 ρ d r n z c v ρ₁ d = r := by
  simp [envExt5]

theorem envExt5_1 (ρ : Env) (d : Nat) (r n z c v : Word) (ρ₁ : Env) :
    envExt5 ρ d r n z c v ρ₁ (d + 1) = n := by
  have h : ¬ d + 1 < d := by omega
  simp [envExt5, h]

theorem envExt5_2 (ρ : Env) (d : Nat) (r n z c v : Word) (ρ₁ : Env) :
    envExt5 ρ d r n z c v ρ₁ (d + 2) = z := by
  have h : ¬ d + 2 < d := by omega
  simp [envExt5, h]

theorem envExt5_3 (ρ : Env) (d : Nat) (r n z c v : Word) (ρ₁ : Env) :
    envExt5 ρ d r n z c v ρ₁ (d + 3) = c := by
  have h : ¬ d + 3 < d := by omega
  simp [envExt5, h]

theorem envExt5_4 (ρ : Env) (d : Nat) (r n z c v : Word) (ρ₁ : Env) :
    envExt5 ρ d r n z c v ρ₁ (d + 4) = v := by
  have h : ¬ d + 4 < d := by omega
  simp [envExt5, h]

theorem wpOps_ext5 {rest : List Op} {ρ ρ' : Env} {d : Nat} {r n z c v : Word}
    {Q : Env → State → Prop} (hw : wpOps rest ρ' σ Q) (hr : ρ' d = r) (hn : ρ' (d + 1) = n)
    (hz : ρ' (d + 2) = z) (hc : ρ' (d + 3) = c) (hv : ρ' (d + 4) = v)
    (hlt : ∀ y, y < d → ρ' y = ρ y) : ∃ ρ₁, wpOps rest (envExt5 ρ d r n z c v ρ₁) σ Q := by
  refine ⟨ρ', ?_⟩
  have e : envExt5 ρ d r n z c v ρ' = ρ' := by
    funext y
    simp only [envExt5_apply]
    split
    · rename_i hy; exact (hlt y hy).symm
    split
    · rename_i hy; rw [hy, hr]
    split
    · rename_i hy; rw [hy, hn]
    split
    · rename_i hy; rw [hy, hz]
    split
    · rename_i hy; rw [hy, hc]
    split
    · rename_i hy; rw [hy, hv]
    rfl
  rw [e]; exact hw

/-- An addition or subtraction with its flags. -/
theorem wp_flagOps {d x y : Nat} {w : RegWidth} {isSub : Bool} {ρ : Env}
    {Q : Env → State → Prop} {rest : List Op} (hx : x < d) (hy : y < d)
    (hnx : norm w (ρ x) = ρ x) (hny : norm w (ρ y) = ρ y)
    (hw : wpOps (flagOps d w isSub x y ++ rest) ρ σ Q) :
    ∃ ρ₁, wpOps rest (envExt5 ρ d (addSubRes w isSub (ρ x) (ρ y) isSub).1
      (ofBool (addSubRes w isSub (ρ x) (ρ y) isSub).2.n)
      (ofBool (addSubRes w isSub (ρ x) (ρ y) isSub).2.z)
      (ofBool (addSubRes w isSub (ρ x) (ρ y) isSub).2.c)
      (ofBool (addSubRes w isSub (ρ x) (ρ y) isSub).2.v) ρ₁) σ Q := by
  have hxd : ∀ k, x ≠ d + k := fun k => by omega
  have hyd : ∀ k, y ≠ d + k := fun k => by omega
  have hxd0 : x ≠ d := by omega
  have hyd0 : y ≠ d := by omega
  cases w <;> cases isSub <;>
    simp only [flagOps, List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply, hxd, hyd,
      hxd0, hyd0, ↓reduceIte, Nat.add_left_cancel_iff, Nat.reduceEqDiff, Nat.left_eq_add,
      Nat.add_eq_left] at hw <;>
    refine wpOps_ext5 hw ?_ ?_ ?_ ?_ ?_ (fun y hy => by env_below hy) <;>
    simp only [Env.set_apply, ↓reduceIte, Nat.add_left_cancel_iff,
      Nat.reduceEqDiff, Nat.left_eq_add,
      addSubRes, Arm64.AddWithCarry32, Arm64.AddWithCarry64, norm] at hnx hny ⊢ <;>
    generalize ρ x = a at * <;> generalize ρ y = b at *
  all_goals
    clear hw
    simp only [BinOp.eval_add, BinOp.eval_sub, BinOp.eval_slt, BinOp.eval_eq, BinOp.eval_ne,
      BinOp.eval_ult, BinOp.eval_ule, BinOp.eval_xor, BinOp.eval_and, UnOp.eval_zext,
      UnOp.eval_sext]
    bv_auto

theorem evalAddSub_ADDS (w : RegWidth) (x y : Word) :
    Arm64.evalAddSub w .ADDS x y none =
      ((addSubRes w false x y false).1, some (addSubRes w false x y false).2) := by
  cases w <;> rfl

theorem evalAddSub_SUBS (w : RegWidth) (x y : Word) :
    Arm64.evalAddSub w .SUBS x y none =
      ((addSubRes w true x y true).1, some (addSubRes w true x y true).2) := by
  cases w <;> rfl

/-- `ADD`, `ADDS`, `SUB` or `SUBS`: the result, and the flags if the operation sets them. -/
theorem wp_addSubOps (h : Rel s σ) {d x y : Nat} {w : RegWidth} {op : AddSubOp} {ρ : Env}
    {Q : Env → State → Prop} {rest : List Op} (hx : x < d) (hy : y < d)
    (hnx : norm w (ρ x) = ρ x) (hny : norm w (ρ y) = ρ y)
    (hw : wpOps (addSubOps d w op x y ++ rest) ρ σ Q) :
    ∃ ρ₁ σ', Rel (match (Arm64.evalAddSub w op (ρ x) (ρ y) none).2 with
        | some ps => s.setPState ps
        | none => s) σ' ∧
      wpOps rest (envExt ρ d (Arm64.evalAddSub w op (ρ x) (ρ y) none).1 ρ₁) σ' Q := by
  cases op
  case ADDS | SUBS =>
    simp only [addSubOps, List.append_assoc] at hw
    obtain ⟨ρ₁, hw⟩ := wp_flagOps hx hy hnx hny hw
    obtain ⟨σ', h', hw⟩ := wp_setNZCV h hw
    simp only [envExt5_1, envExt5_2, envExt5_3, envExt5_4, ofBool_bne_zero] at h'
    obtain ⟨ρ₂, hw⟩ := wpOps_ext (ρ := ρ) hw (envExt5_0 ..) fun y hy => envExt5_lt _ _ _ _ _ _ _ hy
    first
      | exact ⟨ρ₂, σ', by rw [evalAddSub_ADDS]; exact h', by rw [evalAddSub_ADDS]; exact hw⟩
      | exact ⟨ρ₂, σ', by rw [evalAddSub_SUBS]; exact h', by rw [evalAddSub_SUBS]; exact hw⟩
  all_goals
    cases w <;>
      simp only [addSubOps, List.cons_append, List.nil_append, wpOps, Op.wp] at hw <;>
      refine (wpOps_ext (ρ := ρ) hw ?_ (fun y hy => by env_below hy)).elim fun ρ₁ hw => ⟨ρ₁, σ, h, hw⟩ <;>
      simp only [Arm64.evalAddSub, Arm64.AddWithCarry32, Arm64.AddWithCarry64,
        BinOp.eval_add, BinOp.eval_sub, UnOp.eval_zext, Env.set_same] <;>
      generalize ρ x = a <;> generalize ρ y = b <;> bv_auto

/-- A logical operation: the result, and the flags if the operation sets them. -/
theorem wp_logicOps (h : Rel s σ) {d x y : Nat} {w : RegWidth} {op : LogicalOp} {ρ : Env}
    {Q : Env → State → Prop} {rest : List Op} (hx : x < d)
    (hnx : norm w (ρ x) = ρ x) (hny : norm w (ρ y) = ρ y)
    (hw : wpOps (logicOps d w op x y ++ rest) ρ σ Q) :
    ∃ ρ₁ σ', Rel (match (Arm64.evalLogical w op (ρ x) (ρ y) s.pstate).2 with
        | some ps => s.setPState ps
        | none => s) σ' ∧
      wpOps rest (envExt ρ d (Arm64.evalLogical w op (ρ x) (ρ y) s.pstate).1 ρ₁) σ' Q := by
  have hxd : ∀ k, x ≠ d + k := fun k => by omega
  cases op
  case ANDS | BICS =>
    cases w <;>
      simp only [logicOps, setNZCV, List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply,
        hxd, ↓reduceIte, Nat.add_left_cancel_iff, Nat.reduceEqDiff, Nat.left_eq_add] at hw <;>
      refine (wpOps_ext (ρ := ρ) hw ?_ (fun y hy => by env_below hy)).elim fun ρ₁ hw =>
        ⟨ρ₁, _, (h.setPState _ _ _ _).cast ?_, hw⟩
    all_goals
      simp only [Arm64.evalLogical, norm, BinOp.eval_and, BinOp.eval_slt, BinOp.eval_eq,
        UnOp.eval_not, UnOp.eval_sext, Env.set_apply, ↓reduceIte, Nat.left_eq_add,
        Nat.reduceEqDiff, ofBool_bne_zero] at hnx hny ⊢ <;>
      generalize ρ x = a at * <;>
      generalize ρ y = b at * <;>
      bv_auto
  all_goals
    cases w <;>
      simp only [logicOps, List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply,
        hxd, ↓reduceIte] at hw <;>
      refine (wpOps_ext (ρ := ρ) hw ?_ (fun y hy => by env_below hy)).elim fun ρ₁ hw => ⟨ρ₁, σ, h, hw⟩ <;>
      simp only [Arm64.evalLogical, norm, BinOp.eval_and, BinOp.eval_or, BinOp.eval_xor,
        UnOp.eval_not, UnOp.eval_zext, Env.set_same] at hnx hny ⊢ <;>
      generalize ρ x = a at * <;> generalize ρ y = b at * <;> bv_auto

/-! ## Addresses -/

theorem envExt_self (ρ : Env) (d : Nat) (v : Word) (ρ₁ : Env) : envExt ρ d v ρ₁ d = v := by
  simp [envExt]

theorem envExt_lt (ρ : Env) {d : Nat} (v : Word) (ρ₁ : Env) {y : Nat} (h : y < d) :
    envExt ρ d v ρ₁ y = ρ y := by
  simp [envExt, h]

/-- Look up a value below every value an environment defines. -/
macro "env_lt" hy:ident : tactic => `(tactic|
  (have := $hy; simp (disch := omega) only [set_below, envExt_lt]))

/-- Reading the base register of an access: the stack pointer is aligned. -/
theorem wp_baseOps (h : Rel s σ) {d : Nat} {base : Arm64.Reg} {ρ : Env}
    {Q : Env → State → Prop} {rest : List Op} (hw : wpOps (baseOps d base ++ rest) ρ σ Q) :
    Arm64.checkRegSPAligned s base = true ∧
      ∃ ρ₁, wpOps rest (envExt ρ d (s.readReg64 base) ρ₁) σ Q := by
  simp only [baseOps, List.cons_append, wpOps] at hw
  have hw := wp_rget h hw
  cases base with
  | sp =>
    simp only [List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply, ↓reduceIte,
      Nat.left_eq_add, Nat.reduceEqDiff, Nat.add_left_cancel_iff, BinOp.eval_and,
      BinOp.eval_eq] at hw
    refine ⟨?_, wpOps_ext hw.2 (by simp) fun y hy => by env_lt hy⟩
    have := hw.1
    simp only [Arm64.checkRegSPAligned, Arm64.State.spAligned, Arm64.State.readReg64] at this ⊢
    simpa using this
  | gpr i => exact ⟨rfl, wpOps_ext hw (by simp) fun y hy => by env_lt hy⟩
  | xzr => exact ⟨rfl, wpOps_ext hw (by simp) fun y hy => by env_lt hy⟩

/-- The machine state after the base register of an access is written back. -/
def wbState (s : Arm64.State) (addr : AddrMode) : Arm64.State :=
  match (Arm64.evalAddrMode s addr).2 with
  | some (b, v) => s.writeReg64 b v
  | none => s

theorem wbState_mem (s : Arm64.State) (addr : AddrMode) : (wbState s addr).mem = s.mem := by
  cases addr <;> rfl

/-- The address of an access, with the stack pointer aligned and the base written back. -/
theorem wp_addrOps (h : Rel s σ) {d : Nat} {addr : AddrMode} {ρ : Env}
    {Q : Env → State → Prop} {rest : List Op} (hw : wpOps (addrOps d addr ++ rest) ρ σ Q) :
    Arm64.checkAddrSPAligned s addr = true ∧
      ∃ ρ₁ σ', Rel (wbState s addr) σ' ∧
        wpOps rest (envExt ρ d (Arm64.evalAddrMode s addr).1 ρ₁) σ' Q := by
  have plain : ∀ {base : Arm64.Reg} {off : Word} {rest : List Op},
      wpOps ((if off = 0 then baseOps d base
        else baseOps (d + 1) base ++ [.const (d + 6) off, .bin d .add (d + 1) (d + 6)]) ++ rest)
        ρ σ Q →
      Arm64.checkRegSPAligned s base = true ∧
        ∃ ρ₁, wpOps rest (envExt ρ d (s.readReg64 base + off) ρ₁) σ Q := by
    intro base off rest hw
    split at hw
    · rename_i h0
      obtain ⟨hsp, ρ₁, hw⟩ := wp_baseOps h hw
      exact ⟨hsp, ρ₁, by simpa [h0] using hw⟩
    · simp only [List.append_assoc] at hw
      obtain ⟨hsp, ρ₁, hw⟩ := wp_baseOps h hw
      simp only [List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply, envExt_self,
        ↓reduceIte, Nat.reduceEqDiff, Nat.add_left_cancel_iff, BinOp.eval_add] at hw
      exact ⟨hsp, wpOps_ext hw (by simp) fun y hy => by env_lt hy⟩
  cases addr with
  | Offset base off =>
    obtain ⟨hsp, ρ₁, hw⟩ := plain hw
    exact ⟨hsp, ρ₁, σ, h, hw⟩
  | UnscaledOffset base off =>
    obtain ⟨hsp, ρ₁, hw⟩ := plain hw
    exact ⟨hsp, ρ₁, σ, h, hw⟩
  | PreIndex base off =>
    simp only [addrOps, List.append_assoc] at hw
    obtain ⟨hsp, ρ₁, hw⟩ := wp_baseOps h hw
    simp only [List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply, envExt_self,
      ↓reduceIte, Nat.reduceEqDiff, Nat.add_left_cancel_iff, BinOp.eval_add] at hw
    obtain ⟨σ', h', hw⟩ := wp_rset h hw
    refine ⟨hsp, (wpOps_ext hw (by simp [Arm64.evalAddrMode]) fun y hy => by env_lt hy).elim fun ρ₂ hw =>
      ⟨ρ₂, σ', h'.cast ?_, hw⟩⟩
    simp [wbState, Arm64.evalAddrMode]
  | PostIndex base off =>
    simp only [addrOps, List.append_assoc] at hw
    obtain ⟨hsp, ρ₁, hw⟩ := wp_baseOps h hw
    simp only [List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply, envExt_self,
      ↓reduceIte, Nat.reduceEqDiff, Nat.left_eq_add, BinOp.eval_add] at hw
    obtain ⟨σ', h', hw⟩ := wp_rset h hw
    refine ⟨hsp, (wpOps_ext hw (by simp [Arm64.evalAddrMode, envExt_self]) fun y hy => by env_lt hy).elim fun ρ₂ hw =>
      ⟨ρ₂, σ', h'.cast ?_, hw⟩⟩
    simp [wbState, Arm64.evalAddrMode]
  | RegOffset base index ext amount =>
    simp only [addrOps, List.append_assoc] at hw
    obtain ⟨hsp, ρ₁, hw⟩ := wp_baseOps h hw
    obtain ⟨ρ₂, hw⟩ := wp_chain_rget h hw
    simp only [List.cons_append, List.nil_append, wpOps, Op.wp, run_extStages, BinOp.eval_add,
      envExt_self, envExt_lt _ _ _ (show d + 1 < d + 6 by omega)] at hw
    exact ⟨hsp, (wpOps_ext hw (by simp [Arm64.evalAddrMode]) fun y hy => by env_lt hy).elim fun ρ₃ hw =>
      ⟨ρ₃, σ, h, hw⟩⟩

/-! ## Memory -/

theorem Rel.cell (h : Rel s σ) {a : Word} {c : Cell} (hc : σ.mem a = some c) :
    readable s.mem a = true ∧ c = ⟨s.mem.read8 a, writable s.mem a⟩ := by
  rw [h.mem] at hc
  split at hc
  · rename_i hr; exact ⟨hr, (Option.some.inj hc).symm⟩
  · cases hc

theorem loadN_cells {m : Mem} {a v : Word} {n : Nat} (hn : n ≤ 8) (h : m.loadN a n = some v) :
    ∀ x : Word, (x - a).toNat < n → ∃ c, m x = some c := by
  induction n generalizing a v with
  | zero => intro x hx; exact absurd hx (Nat.not_lt_zero _)
  | succ n ih =>
    obtain ⟨c, r, hc, hr, _⟩ := Mem.loadN_succ.1 h
    intro x hx
    by_cases hxa : x = a
    · subst hxa; exact ⟨c, hc⟩
    · exact ih (by omega) hr x (by bv_omega)

theorem memW_bytes (sz : MemWidth) : (memW sz).bytes = sz.bytes := by
  cases sz <;> rfl

/-- A load that `braid` allows is one the machine allows, and gives the machine's value. -/
theorem Rel.load (h : Rel s σ) {a v : Word} {sz : MemWidth}
    (hv : σ.mem.load a (memW sz) = some v) :
    s.mem.canRead a sz.bytes = true ∧ v = s.mem.readSized sz false a := by
  refine ⟨canRead_of (by cases sz <;> decide) fun x hx => ?_, ?_⟩
  · obtain ⟨c, hc⟩ := loadN_cells (by cases sz <;> decide) hv x (by rw [memW_bytes]; exact hx)
    exact (h.cell hc).1
  · cases sz
    · obtain ⟨c0, h0, rfl⟩ := Mem.load_w8.1 hv
      obtain ⟨_, rfl⟩ := h.cell h0
      rfl
    · obtain ⟨c0, c1, h0, h1, rfl⟩ := Mem.load_w16.1 hv
      obtain ⟨_, rfl⟩ := h.cell h0
      obtain ⟨_, rfl⟩ := h.cell h1
      rw [readSized_w16]
    · obtain ⟨c0, c1, c2, c3, h0, h1, h2, h3, rfl⟩ := Mem.load_w32.1 hv
      obtain ⟨_, rfl⟩ := h.cell h0
      obtain ⟨_, rfl⟩ := h.cell h1
      obtain ⟨_, rfl⟩ := h.cell h2
      obtain ⟨_, rfl⟩ := h.cell h3
      rw [readSized_w32]
    · obtain ⟨c0, c1, c2, c3, c4, c5, c6, c7, h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ :=
        Mem.load_w64.1 hv
      obtain ⟨_, rfl⟩ := h.cell h0
      obtain ⟨_, rfl⟩ := h.cell h1
      obtain ⟨_, rfl⟩ := h.cell h2
      obtain ⟨_, rfl⟩ := h.cell h3
      obtain ⟨_, rfl⟩ := h.cell h4
      obtain ⟨_, rfl⟩ := h.cell h5
      obtain ⟨_, rfl⟩ := h.cell h6
      obtain ⟨_, rfl⟩ := h.cell h7
      rw [readSized_w64]

/-- A store that `braid` allows is one the machine allows, and the machine's bytes follow. -/
theorem Rel.store (h : Rel s σ) {a v : Word} {sz : MemWidth} {m : Mem}
    (hm : σ.mem.store a (memW sz) v = some m) :
    s.mem.canWrite a sz.bytes = true ∧
      Rel (s.setMem (s.mem.writeSized sz a v)) { σ with mem := m } := by
  have hn : sz.bytes ≤ 8 := by cases sz <;> decide
  simp only [Mem.store, memW_bytes] at hm
  obtain ⟨hall, rfl⟩ := (Mem.storeN_spec hn).1 hm
  refine ⟨canWrite_of hn fun x hx => ?_,
    h.regs, h.sp, h.n, h.z, h.c, h.v, h.pc, h.status, fun x => ?_, h.vlo, h.vhi⟩
  · obtain ⟨c, hc, hwr⟩ := hall x hx
    obtain ⟨_, rfl⟩ := h.cell hc
    exact hwr
  · simp only [Arm64.State.setMem, readable, writable, perm_writeSized, isLazyFree_writeSized,
      read8_writeSized]
    by_cases hx : (x - a).toNat < sz.bytes
    · obtain ⟨c, hc, hwr⟩ := hall x hx
      obtain ⟨hr, rfl⟩ := h.cell hc
      simp only [readable, Bool.and_eq_true, Bool.not_eq_eq_eq_not, Bool.not_true] at hr
      simp only [writable] at hwr
      simp only [hx, ↓reduceIte, hr.1, hwr, Bool.not_false, Bool.and_self]
    · simp only [hx, ↓reduceIte]
      exact h.mem x

/-! ## Values of a register width -/

theorem norm_norm (w : RegWidth) (v : Word) : norm w (norm w v) = norm w v := by
  cases w <;> simp only [norm]
  bv_auto

theorem norm_readReg (w : RegWidth) (r : Arm64.Reg) : norm w (s.readReg w r) = s.readReg w r := by
  rw [readReg_eq, norm_norm]

theorem norm_shiftVal (w : RegWidth) (v : Word) (sh : ShiftType) (amount : Nat) :
    norm w (Arm64.shiftVal w v sh amount) = Arm64.shiftVal w v sh amount := by
  cases w <;> simp only [norm, Arm64.shiftVal]
  generalize Arm64.shift32 _ _ _ = z
  bv_auto

theorem norm_extendVal (w : RegWidth) (v : Word) (ext : ExtendType) (amount : Nat) :
    norm w (Arm64.extendVal w v ext amount) = Arm64.extendVal w v ext amount := by
  cases w <;> simp only [norm, Arm64.extendVal]
  generalize (_ : Word) <<< amount = z
  bv_auto

theorem norm_evalAddSub (w : RegWidth) (op : AddSubOp) (x y : Word) (c : Option Bool) :
    norm w (Arm64.evalAddSub w op x y c).1 = (Arm64.evalAddSub w op x y c).1 := by
  cases w <;> simp only [norm, Arm64.evalAddSub]
  generalize (Arm64.AddWithCarry32 _ _ _).1 = z
  bv_auto

theorem norm_evalLogical (w : RegWidth) (op : LogicalOp) (x y : Word) (ps : Arm64.PState) :
    norm w (Arm64.evalLogical w op x y ps).1 = (Arm64.evalLogical w op x y ps).1 := by
  cases w <;> simp only [norm, Arm64.evalLogical]
  bv_auto

/-- The state after an instruction that computes a result and maybe flags, writes the
result to `rd`, and goes to the next instruction. -/
def resState (s : Arm64.State) (rd : Arm64.Reg) (e : Word × Option Arm64.PState) : Arm64.State :=
  ((match e.2 with
    | some ps => s.setPState ps
    | none => s).writeReg64 rd e.1).setPC (s.pc + 4)

/-- The same state, as the model computes it. -/
def modelRes (s : Arm64.State) (w : RegWidth) (rd : Arm64.Reg)
    (e : Word × Option Arm64.PState) : Arm64.State :=
  match e with
  | (res, optPs) =>
    (match optPs with
      | some ps => (s.writeReg w rd res).setPState ps
      | none => s.writeReg w rd res).advancePC

theorem modelRes_eq (w : RegWidth) (rd : Arm64.Reg) (e : Word × Option Arm64.PState)
    (hn : norm w e.1 = e.1) : modelRes s w rd e = resState s rd e := by
  obtain ⟨res, ops⟩ := e
  simp only at hn
  cases ops <;> simp only [modelRes, resState, writeReg_eq, hn] <;> rfl

theorem evalLogical_norm (w : RegWidth) (op : LogicalOp) (x y : Word) (ps : Arm64.PState) :
    Arm64.evalLogical w op x (norm w y) ps = Arm64.evalLogical w op x y ps := by
  cases w
  · have e1 : BitVec.truncate 32 (x &&& BitVec.zeroExtend 64 (BitVec.truncate 32 y)) =
        BitVec.truncate 32 (x &&& y) := by bv_auto
    have e2 : BitVec.truncate 32 (x &&& ~~~BitVec.zeroExtend 64 (BitVec.truncate 32 y)) =
        BitVec.truncate 32 (x &&& ~~~y) := by bv_auto
    have e3 : BitVec.truncate 32 (x ||| BitVec.zeroExtend 64 (BitVec.truncate 32 y)) =
        BitVec.truncate 32 (x ||| y) := by bv_auto
    have e4 : BitVec.truncate 32 (x ||| ~~~BitVec.zeroExtend 64 (BitVec.truncate 32 y)) =
        BitVec.truncate 32 (x ||| ~~~y) := by bv_auto
    have e5 : BitVec.truncate 32 (x ^^^ BitVec.zeroExtend 64 (BitVec.truncate 32 y)) =
        BitVec.truncate 32 (x ^^^ y) := by bv_auto
    have e6 : BitVec.truncate 32 (x ^^^ ~~~BitVec.zeroExtend 64 (BitVec.truncate 32 y)) =
        BitVec.truncate 32 (x ^^^ ~~~y) := by bv_auto
    cases op <;> simp only [Arm64.evalLogical, norm, e1, e2, e3, e4, e5, e6]
  · rfl

/-- A chain from a load: the machine allows the read, and the chain starts from its value. -/
theorem wp_chain_load (h : Rel s σ) {d : Nat} {a : Var} {sz : MemWidth} {sts : List Stage}
    {ρ : Env} {Q : Env → State → Prop} {rest : List Op}
    (hw : wpOps (chain d (.load · (memW sz) a) sts ++ rest) ρ σ Q) :
    s.mem.canRead (ρ a) sz.bytes = true ∧
      ∃ ρ₁, wpOps rest (envExt ρ d (Stage.run sts (s.mem.readSized sz false (ρ a))) ρ₁) σ Q := by
  have ⟨v, hv⟩ : ∃ v, σ.mem.load (ρ a) (memW sz) = some v := by
    cases sts <;> simp only [chain, List.cons_append, wpOps, Op.wp] at hw <;>
      exact ⟨_, hw.choose_spec.1⟩
  obtain ⟨hcr, rfl⟩ := h.load hv
  refine ⟨hcr, wp_chain (fun x Q' hw' => ?_) hw⟩
  simp only [Op.wp] at hw'
  obtain ⟨v', hv', hq⟩ := hw'
  rw [hv] at hv'
  cases hv'
  exact hq

theorem execLdr_eq (w : RegWidth) (sz : MemWidth) (signed : Bool) (rt : Arm64.Reg)
    {addr : AddrMode} (hsp : Arm64.checkAddrSPAligned s addr = true)
    (hcr : s.mem.canRead (Arm64.evalAddrMode s addr).1 sz.bytes = true) :
    Arm64.execLdr w sz signed rt addr s =
      ((wbState s addr).writeReg w rt
        (s.mem.readSized sz signed (Arm64.evalAddrMode s addr).1)).setPC (s.pc + 4) := by
  simp only [Arm64.execLdr, hsp, wbState]
  generalize Arm64.evalAddrMode s addr = e at hcr ⊢
  obtain ⟨ea, wb⟩ := e
  simp only at hcr
  simp only [hcr]
  cases wb <;> rfl

theorem execStr_eq (sz : MemWidth) (rt : Arm64.Reg) {addr : AddrMode}
    (hsp : Arm64.checkAddrSPAligned s addr = true)
    (hcw : s.mem.canWrite (Arm64.evalAddrMode s addr).1 sz.bytes = true) :
    Arm64.execStr sz rt addr s =
      ((wbState s addr).setMem
        (s.mem.writeSized sz (Arm64.evalAddrMode s addr).1 (s.readReg64 rt))).setPC (s.pc + 4) := by
  simp only [Arm64.execStr, hsp, wbState]
  generalize Arm64.evalAddrMode s addr = e at hcw ⊢
  obtain ⟨ea, wb⟩ := e
  simp only at hcw
  simp only [hcw]
  cases wb <;> rfl

/-! ## Code stays loaded -/

/-- The memory `m'` keeps every byte of `m` that may not be stored to: its value, its
permission and its `lazyFree` mark. An instruction that runs does this, so the code stays
loaded. -/
def KeepsCode (m m' : Arm64.Memory) : Prop :=
  ∀ a, writable m a = false →
    m'.read8 a = m.read8 a ∧ m'.perm a = m.perm a ∧ m'.isLazyFree a = m.isLazyFree a

theorem KeepsCode.refl (m : Arm64.Memory) : KeepsCode m m := fun _ _ => ⟨rfl, rfl, rfl⟩

theorem KeepsCode.trans {m₁ m₂ m₃ : Arm64.Memory} (h₁ : KeepsCode m₁ m₂) (h₂ : KeepsCode m₂ m₃) :
    KeepsCode m₁ m₃ := by
  intro a ha
  obtain ⟨r₁, p₁, l₁⟩ := h₁ a ha
  obtain ⟨r₂, p₂, l₂⟩ := h₂ a (by simpa only [writable, p₁] using ha)
  exact ⟨r₂.trans r₁, p₂.trans p₁, l₂.trans l₁⟩

/-- A store the machine allows keeps the bytes that may not be stored to. -/
theorem keepsCode_writeSized {m : Arm64.Memory} {sz : MemWidth} {a : Word} (v : Word)
    (hcw : ∀ x : Word, (x - a).toNat < sz.bytes → writable m x = true) :
    KeepsCode m (m.writeSized sz a v) := by
  intro x hx
  have hnot : ¬ (x - a).toNat < sz.bytes := fun hlt => by rw [hcw x hlt] at hx; cases hx
  simp only [read8_writeSized, perm_writeSized, isLazyFree_writeSized, hnot, ↓reduceIte,
    and_self]

/-- A store that `braid` allows keeps the bytes that may not be stored to. -/
theorem Rel.store_keeps (h : Rel s σ) {a v : Word} {sz : MemWidth} {m : Mem}
    (hm : σ.mem.store a (memW sz) v = some m) : KeepsCode s.mem (s.mem.writeSized sz a v) := by
  have hn : sz.bytes ≤ 8 := by cases sz <;> decide
  simp only [Mem.store, memW_bytes] at hm
  obtain ⟨hall, _⟩ := (Mem.storeN_spec hn).1 hm
  refine keepsCode_writeSized v fun x hx => ?_
  obtain ⟨c, hc, hwr⟩ := hall x hx
  obtain ⟨_, rfl⟩ := h.cell hc
  exact hwr

/-- Show that an instruction which stores nothing keeps the code. -/
macro "keeps" : tactic => `(tactic|
  first
    | exact KeepsCode.refl _
    | (split <;> exact KeepsCode.refl _))

/-- Conclude the step of one instruction from the state it reaches. -/
theorem step_done {T S : Arm64.State} {σ' : State} {Q : State → Prop} (hr : Rel S σ')
    (hq : Q σ') (e : T = S) (hk : KeepsCode s.mem S.mem := by keeps) :
    ∃ σ', Rel T σ' ∧ Q σ' ∧ KeepsCode s.mem T.mem :=
  e ▸ ⟨σ', hr, hq, hk⟩

/-- Look up values in the environment of a block. -/
macro "env_simp" : tactic => `(tactic|
  simp only [Env.set_apply, envExt_apply, Nat.reduceEqDiff, Nat.reduceLT, Nat.lt_irrefl,
    ↓reduceIte])

/-- Look up values in the environment of a block, in a hypothesis. -/
macro "env_simp_at" h:ident : tactic => `(tactic|
  simp only [Env.set_apply, envExt_apply, Nat.reduceEqDiff, Nat.reduceLT, Nat.lt_irrefl,
    ↓reduceIte] at $h:ident)

/-! ## Instructions -/

theorem wp_rset' (h : Rel s σ) {r : Arm64.Reg} {a : Var} {ρ : Env} {Q : Env → State → Prop}
    (hw : wpOps (rset r a) ρ σ Q) : ∃ σ', Rel (s.writeReg64 r (ρ a)) σ' ∧ Q ρ σ' :=
  wp_rset (rest := []) h (by rwa [List.append_nil])

/-- Two states that write equal values to a register and go to the next instruction. -/
theorem wr_eq (rd : Arm64.Reg) {a b : Word} (hab : a = b) :
    (s.writeReg64 rd a).advancePC = (s.writeReg64 rd b).setPC (s.pc + 4) :=
  hab ▸ rfl

/-- Run the register reads, chains and pure operations at the head of a block. -/
macro "arm_ops" h:ident hw:ident : tactic => `(tactic|
  (simp only [Block.wp, List.cons_append, List.nil_append, List.append_assoc, wpOps] at $hw:ident
   repeat (first
     | (with_reducible have hw' := wp_rgetW $h $hw); obtain ⟨_, $hw:ident⟩ := hw'
     | (with_reducible have hw' := wp_chain_rget $h $hw); obtain ⟨_, $hw:ident⟩ := hw'
     | (with_reducible have hw' := wp_condOps $h $hw); obtain ⟨_, $hw:ident⟩ := hw'
     | with_reducible have $hw:ident := wp_rget $h $hw
     | simp only [Op.wp, wpOps, Env.set_apply, envExt_apply, Nat.reduceEqDiff, Nat.reduceLT,
         Nat.lt_irrefl, ↓reduceIte, List.cons_append, List.nil_append] at $hw:ident)))

end Lowering.Arm
