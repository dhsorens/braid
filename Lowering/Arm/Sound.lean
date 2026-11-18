/-
  Lowering.Arm.Sound

  The AArch64 lowering is sound: if the block of an instruction runs without fault and
  establishes a postcondition, the machine executes the instruction, stays running, and
  lands in a related state that satisfies it.

  The proof follows the shape of the lowering. Each group of operations the lowering is
  built from (a register read, a chain, the flags of an addition, an address) has a lemma
  saying what it leaves in the environment and the state, and each instruction puts these
  together and compares the result with the model.

  ## Main definitions

  * `Rel`: a machine state and a `braid` state that describe the same machine
  * `KeepsCode`: a memory keeps the bytes of another that may not be stored to

  ## Main results

  * `lower_step`, `lower_sound`: one instruction
  * `codeLoaded_of_keepsCode`, `fetchMem_of_fetch`: the code stays loaded, and is what the
    machine fetches
  * `lowerProgram_sound`: every run, `Eventually` to `Arm64.Steps`
-/

module

public import Lowering.Arm.Lower
public import Lowering.Arm.Mem
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.Arm

open Braid
open Arm64 (Instr RegWidth MemWidth CondCode ShiftType ExtendType AddrMode AddSubOp LogicalOp
  MoveWideOp BitfieldOp CondSelectOp DataProc1Op DataProc2Op DataProc3Op)

/-- The machine state `s` and the `braid` state `σ` describe the same machine: the same
registers, stack pointer, flags and program counter, the machine is running, and `braid`
memory has a cell exactly at the bytes the machine may load, writable exactly where the
machine may store. -/
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

variable {s : Arm64.State} {σ : State}

theorem Rel.cast {s' : Arm64.State} (h : Rel s σ) (e : s' = s) : Rel s' σ := e ▸ h

theorem Rel.setPC (h : Rel s σ) (a : Word) : Rel (s.setPC a) (σ.setPc a) :=
  ⟨h.regs, h.sp, h.n, h.z, h.c, h.v, rfl, h.status, h.mem⟩

theorem Rel.advancePC (h : Rel s σ) : Rel s.advancePC (σ.setPc (s.pc + 4)) :=
  ⟨h.regs, h.sp, h.n, h.z, h.c, h.v, rfl, h.status, h.mem⟩

theorem Rel.setPState (h : Rel s σ) (n z c v : Bool) :
    Rel (s.setPState ⟨n, z, c, v⟩)
      ((((σ.setFlag 0 n).setFlag 1 z).setFlag 2 c).setFlag 3 v) :=
  ⟨h.regs, h.sp, rfl, rfl, rfl, rfl, h.pc, h.status, h.mem⟩

theorem toNat_ne_31 {i : BitVec 5} (hi : i ≠ 31#5) : i.toNat ≠ 31 :=
  fun h => hi (BitVec.eq_of_toNat_eq h)

theorem Rel.writeGpr (h : Rel s σ) {i : BitVec 5} (hi : i ≠ 31#5) (v : Word) :
    Rel (s.writeReg64 (.gpr i) v) (σ.setReg i.toNat v) := by
  refine ⟨fun j hj => ?_, ?_, h.n, h.z, h.c, h.v, h.pc, h.status, h.mem⟩
  · simp only [State.setReg, Arm64.State.writeReg64, beq_iff_eq, hi, ↓reduceIte,
      Arm64.RegFile.read, Arm64.RegFile.write]
    by_cases hji : j = i
    · subst hji; simp
    · have hn : j.toNat ≠ i.toNat := fun hn => hji (BitVec.eq_of_toNat_eq hn)
      simpa [hn, hji, Arm64.RegFile.read] using h.regs j hj
  · simp only [State.setReg, Arm64.State.writeReg64]
    have := toNat_ne_31 hi
    simpa [Ne.symm this] using h.sp

theorem Rel.writeSp (h : Rel s σ) (v : Word) : Rel (s.writeReg64 .sp v) (σ.setReg 31 v) := by
  refine ⟨fun j hj => ?_, ?_, h.n, h.z, h.c, h.v, h.pc, h.status, h.mem⟩
  · simp only [State.setReg, Arm64.State.writeReg64]
    simpa [toNat_ne_31 hj] using h.regs j hj
  · simp [State.setReg, Arm64.State.writeReg64]

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
      · bv_decide
      · bv_decide
      · bv_decide
      · have e1 : kb.toNat % 32 = kb.toNat := Nat.mod_eq_of_lt (by bv_omega)
        have e2 : 32 - kb.toNat = (32#64 - kb).toNat := by bv_omega
        rw [e1, e2]
        bv_decide
  · simp only [shiftStages]
    obtain ⟨kb, hkb, hk⟩ := exists_bv_of_lt (k := amount % 64) (by omega)
    split
    · rename_i h0
      cases sh <;> simp [Stage.run, Arm64.shiftVal, Arm64.shift64, norm, h0, BitVec.rotateRight_def]
    · cases sh <;> simp only [Stage.run, Stage.eval, Arm64.shiftVal, Arm64.shift64, norm, hk, List.foldl, shiftOp, BitVec.ofNat_toNat, BitVec.setWidth_eq, BinOp.eval_shl, BinOp.eval_lshr, BinOp.eval_ashr, BinOp.eval_rotr]
      all_goals bv_decide

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
        bv_decide
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
         bv_decide
       have e2 : BitVec.setWidth 32 (BitVec.signExtend 64 (BitVec.setWidth 32 v)) = BitVec.setWidth 32 v := by
         bv_decide
       simp only [BitVec.setWidth_shiftLeft_of_le (show 32 ≤ 64 by decide), e1, e2])

theorem run_loadStages (w : RegWidth) (sz : MemWidth) (signed : Bool) (m : Arm64.Memory) (a : Word) :
    Stage.run (loadStages w sz signed) (m.readSized sz false a) = norm w (m.readSized sz signed a) := by
  cases signed
  · cases w <;> cases sz <;> simp [loadStages, Stage.run, norm, Stage.eval, Arm64.Memory.readSized]
  · cases w <;> cases sz <;> simp [loadStages, Stage.run, norm, Stage.eval, Arm64.Memory.readSized]
    generalize m.read32 a = b
    bv_decide

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
    first | bv_decide | (congr 1; bv_decide)

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
      generalize ρ x = a <;> generalize ρ y = b <;> bv_decide

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
      first
        | bv_decide
        | (refine congrArg (Arm64.State.setPState s) (Arm64.PState.ext ?_ ?_ ?_ ?_) <;> bv_decide)
  all_goals
    cases w <;>
      simp only [logicOps, List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply,
        hxd, ↓reduceIte] at hw <;>
      refine (wpOps_ext (ρ := ρ) hw ?_ (fun y hy => by env_below hy)).elim fun ρ₁ hw => ⟨ρ₁, σ, h, hw⟩ <;>
      simp only [Arm64.evalLogical, norm, BinOp.eval_and, BinOp.eval_or, BinOp.eval_xor,
        UnOp.eval_not, UnOp.eval_zext, Env.set_same] at hnx hny ⊢ <;>
      generalize ρ x = a at * <;> generalize ρ y = b at * <;> bv_decide

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
    h.regs, h.sp, h.n, h.z, h.c, h.v, h.pc, h.status, fun x => ?_⟩
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
  bv_decide

theorem norm_readReg (w : RegWidth) (r : Arm64.Reg) : norm w (s.readReg w r) = s.readReg w r := by
  rw [readReg_eq, norm_norm]

theorem norm_shiftVal (w : RegWidth) (v : Word) (sh : ShiftType) (amount : Nat) :
    norm w (Arm64.shiftVal w v sh amount) = Arm64.shiftVal w v sh amount := by
  cases w <;> simp only [norm, Arm64.shiftVal]
  generalize Arm64.shift32 _ _ _ = z
  bv_decide

theorem norm_extendVal (w : RegWidth) (v : Word) (ext : ExtendType) (amount : Nat) :
    norm w (Arm64.extendVal w v ext amount) = Arm64.extendVal w v ext amount := by
  cases w <;> simp only [norm, Arm64.extendVal]
  generalize (_ : Word) <<< amount = z
  bv_decide

theorem norm_evalAddSub (w : RegWidth) (op : AddSubOp) (x y : Word) (c : Option Bool) :
    norm w (Arm64.evalAddSub w op x y c).1 = (Arm64.evalAddSub w op x y c).1 := by
  cases w <;> simp only [norm, Arm64.evalAddSub]
  generalize (Arm64.AddWithCarry32 _ _ _).1 = z
  bv_decide

theorem norm_evalLogical (w : RegWidth) (op : LogicalOp) (x y : Word) (ps : Arm64.PState) :
    norm w (Arm64.evalLogical w op x y ps).1 = (Arm64.evalLogical w op x y ps).1 := by
  cases w <;> simp only [norm, Arm64.evalLogical]
  bv_decide

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
        BitVec.truncate 32 (x &&& y) := by bv_decide
    have e2 : BitVec.truncate 32 (x &&& ~~~BitVec.zeroExtend 64 (BitVec.truncate 32 y)) =
        BitVec.truncate 32 (x &&& ~~~y) := by bv_decide
    have e3 : BitVec.truncate 32 (x ||| BitVec.zeroExtend 64 (BitVec.truncate 32 y)) =
        BitVec.truncate 32 (x ||| y) := by bv_decide
    have e4 : BitVec.truncate 32 (x ||| ~~~BitVec.zeroExtend 64 (BitVec.truncate 32 y)) =
        BitVec.truncate 32 (x ||| ~~~y) := by bv_decide
    have e5 : BitVec.truncate 32 (x ^^^ BitVec.zeroExtend 64 (BitVec.truncate 32 y)) =
        BitVec.truncate 32 (x ^^^ y) := by bv_decide
    have e6 : BitVec.truncate 32 (x ^^^ ~~~BitVec.zeroExtend 64 (BitVec.truncate 32 y)) =
        BitVec.truncate 32 (x ^^^ ~~~y) := by bv_decide
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

variable {Q : State → Prop}

/-! ## Loads and stores of pairs, and literal loads -/

theorem KeepsCode.trans {m₁ m₂ m₃ : Arm64.Memory} (h₁ : KeepsCode m₁ m₂) (h₂ : KeepsCode m₂ m₃) :
    KeepsCode m₁ m₃ := by
  intro a ha
  obtain ⟨r₁, p₁, l₁⟩ := h₁ a ha
  obtain ⟨r₂, p₂, l₂⟩ := h₂ a (by simpa only [writable, p₁] using ha)
  exact ⟨r₂.trans r₁, p₂.trans p₁, l₂.trans l₁⟩

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

/-- Two states that write equal values to a register and go to the next instruction. -/
theorem wr_eq (rd : Arm64.Reg) {a b : Word} (hab : a = b) :
    (s.writeReg64 rd a).advancePC = (s.writeReg64 rd b).setPC (s.pc + 4) :=
  hab ▸ rfl

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

/-- A byte reversal is sound. -/
theorem sound_dataProc1 (prog : Arm64.Program) {w : RegWidth} {op : DataProc1Op}
    {rd rn : Arm64.Reg} (h : Rel s σ) (hw : (lower s.pc (.dataProc1 w op rd rn)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.dataProc1 w op rd rn) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.dataProc1 w op rd rn) s).mem := by
  cases op <;> cases w <;> simp only [lower, dp1Ops] at hw
  case RBIT.W32 | RBIT.W64 | CLZ.W32 | CLZ.W64 | CLS.W32 | CLS.W64 =>
    exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
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
