/-
  Lowering.X86.Avx

  The vector instructions, each lowered soundly: the moves between vector registers and
  memory, the moves between general and vector registers, and the packed 32-bit
  addition. A piece of a block (reading a vector operand, writing one, an alignment
  check) is related to the model's function for the same thing, and an instruction is those
  lemmas in order.

  ## Main definitions

  * `AvxSound`: a vector instruction is lowered soundly

  ## Main results

  * `readVec_sound`, `writeVec_sound`: vector operands
  * `lowerAvx_sound`: every vector instruction
-/

module

public import Lowering.X86.Vec
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env wpOps State ofBool)

variable {s : MachineData} {σ : State} {ρ : Env} {Q : Env → State → Prop}

/-! ## Runs of operations -/

/-- `Env.set_other`, with the values as natural numbers. -/
theorem set_ne (ρ : Env) {x y : Nat} (v : Word) (h : y ≠ x) : ρ.set x v y = ρ y :=
  Env.set_other ρ v h

theorem getRegs_succ (n r k : Nat) :
    getRegs n r (k + 1) = getRegs n r k ++ [.get (n + k) (r + k)] := by
  simp [getRegs, List.range_succ]

theorem setRegs_succ (r : Nat) (g : Nat → Var) (k : Nat) :
    setRegs r g (k + 1) = setRegs r g k ++ [.set (r + k) (g k)] := by
  simp [setRegs, List.range_succ]

theorem binWords_succ (d : Var) (op : BinOp) (a b : Var) (k : Nat) :
    binWords d op a b (k + 1) = binWords d op a b k ++ [.bin (d + k) op (a + k) (b + k)] := by
  simp [binWords, List.range_succ]

theorem loadWords_succ (n a t k : Nat) :
    loadWords n a t (k + 1) = loadWords n a t k ++
      [.const (t + 2 * k) (BitVec.ofNat 64 (8 * k)), .bin (t + 2 * k + 1) .add a (t + 2 * k),
        .load (n + k) .w64 (t + 2 * k + 1)] := by
  simp [loadWords, List.range_succ]

theorem storeWords_succ (a t v k : Nat) :
    storeWords a t v (k + 1) = storeWords a t v k ++
      [.const (t + 2 * k) (BitVec.ofNat 64 (8 * k)), .bin (t + 2 * k + 1) .add a (t + 2 * k),
        .store .w64 (t + 2 * k + 1) (v + k)] := by
  simp [storeWords, List.range_succ]

theorem wp_getRegs {n r k : Nat} (hw : wpOps (getRegs n r k) ρ σ Q) :
    ∃ ρ', Agree n ρ ρ' ∧ (∀ j, j < k → ρ' (n + j) = σ.regs (r + j)) ∧ Q ρ' σ := by
  induction k generalizing Q with
  | zero => exact ⟨ρ, Agree.refl _ _, fun j hj => absurd hj (Nat.not_lt_zero j), hw⟩
  | succ k ih =>
    rw [getRegs_succ, Braid.wpOps_append] at hw
    obtain ⟨ρ1, hag, hv, hq⟩ := ih hw
    simp only [wpOps, Op.wp] at hq
    refine ⟨_, hag.set (by omega) _, fun j hj => ?_, hq⟩
    by_cases hjk : j = k
    · subst hjk; rw [Env.set_same]
    · rw [set_ne _ _ (by omega), hv j (by omega)]

theorem wp_setRegs {r : Nat} {g : Nat → Var} {k : Nat} (hw : wpOps (setRegs r g k) ρ σ Q) :
    Q ρ (setWords σ r (fun j => ρ (g j)) k) := by
  induction k generalizing Q with
  | zero => rw [setWords_zero]; exact hw
  | succ k ih =>
    rw [setRegs_succ, Braid.wpOps_append] at hw
    rw [setWords_succ]
    exact ih hw

theorem wp_binWords {d a b k : Nat} {op : BinOp} (ha : a + k ≤ d) (hb : b + k ≤ d)
    (hw : wpOps (binWords d op a b k) ρ σ Q) :
    ∃ ρ', Agree d ρ ρ' ∧ (∀ j, j < k → ρ' (d + j) = op.eval (ρ (a + j)) (ρ (b + j))) ∧
      Q ρ' σ := by
  induction k generalizing Q with
  | zero => exact ⟨ρ, Agree.refl _ _, fun j hj => absurd hj (Nat.not_lt_zero j), hw⟩
  | succ k ih =>
    rw [binWords_succ, Braid.wpOps_append] at hw
    obtain ⟨ρ1, hag, hv, hq⟩ := ih (by omega) (by omega) hw
    simp only [wpOps, Op.wp] at hq
    rw [hag (a + k) (by omega), hag (b + k) (by omega)] at hq
    refine ⟨_, hag.set (by omega) _, fun j hj => ?_, hq⟩
    by_cases hjk : j = k
    · subst hjk; rw [Env.set_same]
    · rw [set_ne _ _ (by omega), hv j (by omega)]

theorem wp_loadWords {n a t k : Nat} (hn : n + k ≤ a) (ha : a < t)
    (hw : wpOps (loadWords n a t k) ρ σ Q) :
    ∃ ρ', Agree n ρ ρ' ∧ ρ' a = ρ a ∧
      (∀ j, j < k → σ.mem.load (ρ a + BitVec.ofNat 64 (8 * j)) .w64 = some (ρ' (n + j))) ∧
      Q ρ' σ := by
  induction k generalizing Q with
  | zero => exact ⟨ρ, Agree.refl _ _, rfl, fun j hj => absurd hj (Nat.not_lt_zero j), hw⟩
  | succ k ih =>
    rw [loadWords_succ, Braid.wpOps_append] at hw
    obtain ⟨ρ1, hag, hra, hv, hq⟩ := ih (by omega) hw
    have h1 : a ≠ t + 2 * k := by omega
    simp only [wpOps, Op.wp, Env.set_apply, h1, ↓reduceIte, BinOp.eval_add, hra] at hq
    obtain ⟨v, hl, hq⟩ := hq
    refine ⟨_, ((hag.set (by omega) _).set (by omega) _).set (by omega) _, ?_, fun j hj => ?_,
      hq⟩
    · rw [set_ne _ _ (by omega), set_ne _ _ (by omega),
        set_ne _ _ (by omega), hra]
    · by_cases hjk : j = k
      · subst hjk; rw [Env.set_same]; exact hl
      · rw [set_ne _ _ (by omega), set_ne _ _ (by omega),
          set_ne _ _ (by omega)]
        exact hv j (by omega)

theorem wp_storeWords {a t v k : Nat} (ha : a < t) (hv : v + k ≤ t)
    (hw : wpOps (storeWords a t v k) ρ σ Q) :
    ∃ ρ' m, Agree t ρ ρ' ∧ storeSeq σ.mem (ρ a) (fun j => ρ (v + j)) k = some m ∧
      Q ρ' { σ with mem := m } := by
  induction k generalizing Q with
  | zero => exact ⟨ρ, σ.mem, Agree.refl _ _, rfl, hw⟩
  | succ k ih =>
    rw [storeWords_succ, Braid.wpOps_append] at hw
    obtain ⟨ρ1, m1, hag, hs, hq⟩ := ih (by omega) hw
    have h1 : a ≠ t + 2 * k := by omega
    have h2 : v + k ≠ t + 2 * k := by omega
    have h3 : v + k ≠ t + 2 * k + 1 := by omega
    simp only [wpOps, Op.wp, Env.set_apply, h1, h2, h3, ↓reduceIte, BinOp.eval_add, hag a ha,
      hag (v + k) (by omega)] at hq
    obtain ⟨m, hm, hq⟩ := hq
    refine ⟨_, m, (hag.set (by omega) _).set (by omega) _, ?_, hq⟩
    simp only [storeSeq, hs, Option.bind_some]
    exact hm

/-! ## Alignment -/

theorem wp_alignOps {n a bytes : Nat} {al : Bool} (ha : a < n)
    (hw : wpOps (alignOps n a bytes al) ρ σ Q) :
    ∃ ρ', Agree n ρ ρ' ∧ (al = true → ρ a &&& BitVec.ofNat 64 (bytes - 1) = 0#64) ∧ Q ρ' σ := by
  cases al with
  | false => exact ⟨ρ, Agree.refl _ _, fun h => Bool.noConfusion h, hw⟩
  | true =>
    have h0 : a ≠ n := by omega
    simp only [alignOps, wpOps, Op.wp, Env.set_apply, h0, ↓reduceIte] at hw
    obtain ⟨hg, hq⟩ := hw
    refine ⟨_, by agree, fun _ => ?_, hq⟩
    simpa using hg

theorem isAligned_of_mask (w : AvxWidth) {x : Word}
    (h : x &&& BitVec.ofNat 64 (w.bytes - 1) = 0#64) : isAligned w.bytes x = true := by
  have key : ∀ c : Word, x % c = 0#64 → x.toNat % c.toNat = 0 := fun c hc => by
    rw [← BitVec.toNat_umod, hc]; rfl
  cases w <;> simp only [isAligned, AvxWidth.bytes, beq_iff_eq, Nat.reduceSub] at h ⊢
  · exact key 16#64 (by bv_decide)
  · exact key 32#64 (by bv_decide)
  · exact key 64#64 (by bv_decide)

/-! ## Vectors in memory -/

section
variable {post : MachineState → Prop}

/-- Word loads `braid` allows are a vector load of the model, of the vector with those
words. -/
theorem loadAvx_sound (h : RelD s σ) {a : Word} {w : AvxWidth} {al : Bool}
    {ret : w.type → MachineData → Effects} {f : Nat → Word}
    (hal : al = true → a &&& BitVec.ofNat 64 (w.bytes - 1) = 0#64)
    (hl : ∀ j, j < vecWords w → σ.mem.load (a + BitVec.ofNat 64 (8 * j)) .w64 = some (f j))
    (hk : ∀ v : w.type, (∀ j, j < vecWords w → vecWord v j = f j) → (ret v s).All post) :
    (s.loadAvx a w ret al).All post := by
  have hc : (al && !isAligned w.bytes a) = false := by
    cases al
    · rfl
    · simp [isAligned_of_mask w (hal rfl)]
  have hb : w.bytes = 8 * vecWords w := by cases w <;> rfl
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  rw [h.mem] at hl
  have hi := loadInt_of_loads hl
  rw [← hb] at hi
  simp only [MachineData.loadAvx, hc, Bool.false_eq_true, ↓reduceIte,
    Effects.All_require_read_access, hi]
  exact hk _ fun j hj => vecWord_ofInt_joinWords f hj hbits

/-- Word stores `braid` allows are a vector store of the model. -/
theorem storeAvx_sound (h : RelD s σ) {a : Word} {w : AvxWidth} {al : Bool} {val : w.type}
    {m : Braid.Mem} {ret : MachineData → Effects}
    (hal : al = true → a &&& BitVec.ofNat 64 (w.bytes - 1) = 0#64)
    (hs : storeSeq σ.mem a (vecWord val) (vecWords w) = some m)
    (hk : ∀ s', RelD s' { σ with mem := m } → (ret s').All post) :
    (s.storeAvx a val ret al).All post := by
  have hc : (al && !isAligned w.bytes a) = false := by
    cases al
    · rfl
    · simp [isAligned_of_mask w (hal rfl)]
  have hb : w.bytes = 8 * vecWords w := by cases w <;> rfl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hbits : w.bits = 8 * (8 * vecWords w) := by cases w <;> rfl
  rw [h.mem] at hs
  obtain ⟨hsome, hm⟩ := storeInt_of_storeSeq hw8 hbits hs
  rw [← hb] at hsome hm
  obtain ⟨i, hi⟩ := Option.isSome_iff_exists.1 hsome
  simp only [MachineData.storeAvx, hc, Bool.false_eq_true, ↓reduceIte,
    Effects.All_require_write_access, hi]
  exact hk _ ⟨h.regs, h.cf, h.pf, h.af, h.zf, h.sf, h.of, h.df, hm, h.vec⟩

end

/-! ## Vector registers -/

/-- A write of a vector register by an instruction of the VEX or EVEX encodings: the words of
the value, and zero above them. -/
theorem set_eq (z : RegZmms) {w : AvxWidth} (r : AvxReg w) (val : w.type) :
    ∃ v, z.set r val = z.set512 r.base v ∧
      (∀ j, j < vecWords w → vecWord v j = vecWord val j) ∧
      (∀ j, vecWords w ≤ j → j < 8 → vecWord v j = 0#64) := by
  cases r with
  | xmm k =>
    refine ⟨_, rfl, fun j hj => vecWord_setWidth (n := 128) (m := 512) _ ?_,
      fun j hj _ => vecWord_setWidth_zero (n := 128) _ ?_⟩ <;>
    simp only [vecWords] at hj <;> omega
  | ymm k =>
    refine ⟨_, rfl, fun j hj => vecWord_setWidth (n := 256) (m := 512) _ ?_,
      fun j hj _ => vecWord_setWidth_zero (n := 256) _ ?_⟩ <;>
    simp only [vecWords] at hj <;> omega
  | zmm k =>
    refine ⟨_, rfl, fun j _ => rfl, fun j hj hj' => ?_⟩
    simp only [vecWords] at hj
    omega

/-- A write of a vector register by an instruction of the legacy encodings: the words of the
value, and the old words above them. -/
theorem setLegacy_eq (z : RegZmms) {w : AvxWidth} (r : AvxReg w) (val : w.type) :
    ∃ v, z.setLegacy r val = z.set512 r.base v ∧
      (∀ j, j < vecWords w → vecWord v j = vecWord val j) ∧
      (∀ j, vecWords w ≤ j → j < 8 → vecWord v j = vecWord (z.get512 r.base) j) := by
  cases r with
  | xmm k =>
    refine ⟨_, rfl, fun j hj => vecWord_replaceLow_lt (n := 128) (m := 512) _ _ ?_ (by decide),
      fun j hj _ => vecWord_replaceLow_ge (n := 128) _ _ ?_⟩ <;>
    simp only [vecWords] at hj <;> omega
  | ymm k =>
    refine ⟨_, rfl, fun j hj => vecWord_replaceLow_lt (n := 256) (m := 512) _ _ ?_ (by decide),
      fun j hj _ => vecWord_replaceLow_ge (n := 256) _ _ ?_⟩ <;>
    simp only [vecWords] at hj <;> omega
  | zmm k =>
    refine ⟨_, rfl, fun j _ => rfl, fun j hj hj' => ?_⟩
    simp only [vecWords] at hj
    omega

/-! ## Operands -/

section
variable [Labels] {p : Std.Rco Int64} {post : MachineState → Prop}

theorem readVec_sound (h : RelD s σ) {n : Nat} {w : AvxWidth} {o : AvxRegOrMem w} {al : Bool}
    {ret : w.type → MachineData → Effects} (hw : wpOps (readVec p n al o) ρ σ Q)
    (hk : ∀ (v : w.type) ρ', Agree n ρ ρ' → (∀ j, j < vecWords w → ρ' (n + j) = vecWord v j) →
      Q ρ' σ → (ret v s).All post) :
    (@AvxRegOrMem.interp w _ ⟨.W64⟩ o s p ret al).All post := by
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  cases o with
  | avx r =>
    simp only [readVec] at hw
    obtain ⟨ρ', hag, hv, hq⟩ := wp_getRegs hw
    refine hk _ ρ' hag (fun j hj => ?_) hq
    rw [hv j hj]
    simp only [RegZmms.get]
    rw [vecWord_take _ (by omega)]
    exact h.vec r.base j (by omega)
  | mem a =>
    simp only [readVec, Braid.wpOps_append] at hw
    obtain ⟨ρ1, hag1, ha, hw⟩ := wp_addr h hw
    obtain ⟨ρ2, hag2, hal, hw⟩ := wp_alignOps (by omega) hw
    obtain ⟨ρ3, hag3, -, hl, hq⟩ := wp_loadWords (by omega) (by omega) hw
    rw [ha] at hal
    rw [hag2 (n + 8) (by omega), ha] at hl
    simp only [AvxRegOrMem.interp]
    refine loadAvx_sound h hal hl fun v hv => hk v ρ3 (fun x hx => ?_)
      (fun j hj => (hv j hj).symm) hq
    rw [hag3 x hx, hag2 x (by omega), hag1 x (by omega)]

theorem writeVec_sound (h : RelD s σ) {n v : Nat} {w : AvxWidth} {d : AvxRegOrMem w}
    {val : w.type} {legacy al : Bool} {ret : MachineData → Effects}
    (hv : ∀ j, j < vecWords w → ρ (v + j) = vecWord val j) (hvn : v + 8 ≤ n)
    (hw : wpOps (writeVec p n legacy al d v) ρ σ Q)
    (hk : ∀ s' ρ' σ', Agree n ρ ρ' → RelD s' σ' → Q ρ' σ' → (ret s').All post) :
    (cond legacy (@MachineData.setAvxLegacy w _ ⟨.W64⟩ s d val p ret al)
      (@MachineData.setAvx w _ ⟨.W64⟩ s d val p ret al)).All post := by
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  cases d with
  | avx r =>
    simp only [writeVec, Braid.wpOps_append] at hw
    have hw := wp_setRegs hw
    cases legacy with
    | true =>
      simp only [↓reduceIte, wpOps] at hw
      obtain ⟨z, hz, h1, h2⟩ := setLegacy_eq s.zmms r val
      simp only [Bool.cond_true, MachineData.setAvxLegacy, MachineData.setAvxLegacyReg, hz]
      refine hk _ _ _ (Agree.refl _ _) ?_ hw
      refine h.set512 r.base z rfl rfl (fun j hj => ?_)
        fun x hx => setWords_regs_other _ _ _ _ _ (by omega) hx
      rw [setWords_regs_vecReg]
      by_cases hj' : j < vecWords w
      · have hc : 0 ≤ j ∧ j < 0 + vecWords w := by omega
        simp only [hc, and_self, ↓reduceIte, Nat.sub_zero]
        rw [hv j hj', h1 j hj']
      · have hc : ¬ (0 ≤ j ∧ j < 0 + vecWords w) := by omega
        simp only [hc, ↓reduceIte]
        rw [h.vec _ j hj, h2 j (by omega) hj]
    | false =>
      simp only [Bool.false_eq_true, ↓reduceIte, wpOps, Op.wp] at hw
      have hw := wp_setRegs hw
      obtain ⟨z, hz, h1, h2⟩ := set_eq s.zmms r val
      simp only [Bool.cond_false, MachineData.setAvx, MachineData.setAvxReg, hz]
      refine hk _ _ _ (Agree.set (Agree.refl _ _) (Nat.le_refl _) _) ?_ hw
      refine h.set512 r.base z rfl rfl (fun j hj => ?_) fun x hx => ?_
      · rw [setWords_regs_vecReg, setWords_regs_vecReg]
        by_cases hj' : j < vecWords w
        · have hc : ¬ (vecWords w ≤ j ∧ j < vecWords w + (8 - vecWords w)) := by omega
          have hc' : 0 ≤ j ∧ j < 0 + vecWords w := by omega
          simp only [hc, hc', and_self, ↓reduceIte, Nat.sub_zero]
          rw [hv j hj', h1 j hj']
        · have hc : vecWords w ≤ j ∧ j < vecWords w + (8 - vecWords w) := by omega
          simp only [hc, and_self, ↓reduceIte, Env.set_same]
          rw [h2 j (by omega) hj]
          rfl
      · rw [setWords_regs_other _ _ _ _ _ (by omega) hx,
          setWords_regs_other _ _ _ _ _ (by omega) hx]
  | mem a =>
    simp only [writeVec, Braid.wpOps_append] at hw
    obtain ⟨ρ1, hag1, ha, hw⟩ := wp_addr h hw
    obtain ⟨ρ2, hag2, hal, hw⟩ := wp_alignOps (by omega) hw
    obtain ⟨ρ3, m, hag3, hs, hq⟩ := wp_storeWords (by omega) (by omega) hw
    rw [ha] at hal
    rw [hag2 n (by omega), ha] at hs
    have hs' : storeSeq σ.mem (addrVal p a s) (vecWord val) (vecWords w) = some m := by
      rw [← hs]
      refine (storeSeq_congr _ _ fun j hj => ?_).symm
      rw [hag2 (v + j) (by omega), hag1 (v + j) (by omega)]
      exact hv j hj
    have hag : Agree n ρ ρ3 := fun x hx => by
      rw [hag3 x (by omega), hag2 x (by omega), hag1 x hx]
    cases legacy
    all_goals
      simp only [Bool.cond_true, Bool.cond_false, MachineData.setAvxLegacy, MachineData.setAvx]
      exact storeAvx_sound h hal hs' fun s' h' => hk s' ρ3 _ hag h' hq

/-! ## Instructions -/

/-- The vector instruction `i` is lowered soundly: if its operations run without fault and
establish `Q` at the next instruction, every outcome of `i` in the model is related to a state
satisfying `Q`. -/
def AvxSound (p : Std.Rco Int64) {w : AvxWidth} (i : AvxOperation w) : Prop :=
  ∀ {s : MachineData} {σ : State} {ρ : Env} {Q : State → Prop} {ops : List Op},
    RelD s σ → lowerAvx p i = some ops →
    wpOps ops ρ σ (fun ρ σ' => (Term.jump p.upper.toBitVec).wp ρ σ' Q) →
    (@AvxOperation.interp _ ⟨.W64⟩ w i p s fun s' => .done ⟨s', p.upper⟩).All
      fun m => ∃ σ', Rel m σ' ∧ Q σ'

/-- A move of a vector, of either encoding, aligned or not. -/
theorem moveVec_sound {w : AvxWidth} {legacy al : Bool} {dst src : AvxRegOrMem w}
    {Q : State → Prop} (h : RelD s σ)
    (hw : wpOps (moveVec p legacy al dst src) ρ σ
      fun ρ σ' => (Term.jump p.upper.toBitVec).wp ρ σ' Q) :
    (@AvxRegOrMem.interp w _ ⟨.W64⟩ src s p (fun val s =>
      cond legacy
        (@MachineData.setAvxLegacy w _ ⟨.W64⟩ s dst val p (fun s' => .done ⟨s', p.upper⟩) al)
        (@MachineData.setAvx w _ ⟨.W64⟩ s dst val p (fun s' => .done ⟨s', p.upper⟩) al)) al).All
      fun m => ∃ σ', Rel m σ' ∧ Q σ' := by
  simp only [moveVec, Braid.wpOps_append] at hw
  refine readVec_sound h hw fun v ρ1 _ hv hw => ?_
  refine writeVec_sound h hv (by decide) hw fun s' ρ2 σ' _ h' hq => ?_
  exact done_sound h' hq

theorem paddd_sound {w : AvxWidth} (dst src : AvxRegOrMem w) :
    AvxSound p (.paddd dst src) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun a ρ1 _ ha hw => ?_
  refine readVec_sound h hw fun b ρ2 hag2 hb hw => ?_
  obtain ⟨ρ3, hag3, hv, hw⟩ := wp_binWords (by omega) (by omega) hw
  refine writeVec_sound (legacy := true) (val := BitVec.packedBinOp 32 (· + ·) b a) h
    (fun j hj => ?_) (by decide) hw fun s' ρ4 σ' _ h' hq => done_sound h' hq
  rw [hv j hj, hb j hj, hag2 (0 + j) (by omega), ha j hj,
    vecWord_packedBinOp_add _ _ _ (by omega)]

theorem vpaddd_sound {w : AvxWidth} (dst src1 src2 : AvxRegOrMem w) :
    AvxSound p (.vpaddd dst src1 src2) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw8 : vecWords w ≤ 8 := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [Braid.wpOps_append] at hw
  simp only [AvxOperation.interp]
  refine readVec_sound h hw fun b ρ1 _ hb hw => ?_
  refine readVec_sound h hw fun a ρ2 hag2 ha hw => ?_
  obtain ⟨ρ3, hag3, hv, hw⟩ := wp_binWords (by omega) (by omega) hw
  refine writeVec_sound (legacy := false) (val := BitVec.packedBinOp 32 (· + ·) a b) h
    (fun j hj => ?_) (by decide) hw fun s' ρ4 σ' _ h' hq => done_sound h' hq
  rw [hv j hj, ha j hj, hag2 (0 + j) (by omega), hb j hj,
    vecWord_packedBinOp_add _ _ _ (by omega)]

theorem vmovq_sound {w : AvxWidth} (dst src : AvxReg w) : AvxSound p (.vmovq dst src) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw2 : 2 ≤ vecWords w := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  simp only [AvxOperation.interp]
  simp only [List.cons_append, List.nil_append, wpOps, Op.wp] at hw
  have hw := wp_setRegs hw
  obtain ⟨z, hz, h1, h2⟩ := set_eq s.zmms dst (((s.zmms.get src).take 64).zeroExtend _)
  simp only [MachineData.setAvxReg, hz]
  refine done_sound ?_ hw
  refine h.set512 dst.base z rfl rfl (fun j hj => ?_)
    fun x hx => setWords_regs_other _ _ _ _ _ (by omega) hx
  rw [setWords_regs_vecReg]
  have hc : 0 ≤ j ∧ j < 0 + 8 := by omega
  simp only [hc, and_self, ↓reduceIte, Nat.sub_zero]
  by_cases hj0 : j = 0
  · subst hj0
    simp only [↓reduceIte, Env.set_apply, Nat.zero_ne_one]
    rw [h1 0 (by omega), h.vec _ 0 (by omega)]
    simp only [RegZmms.get]
    rw [vecWord_setWidth _ (by omega), vecWord_take _ (by omega), vecWord_take _ (by omega)]
  · simp only [hj0, ↓reduceIte, Env.set_same]
    by_cases hj' : j < vecWords w
    · rw [h1 j hj', vecWord_setWidth_zero (n := 64) _ (by omega)]
      rfl
    · rw [h2 j (by omega) hj]
      rfl

theorem vmovIn_sound {w : AvxWidth} (n : Width) (dst : AvxReg w) (src : RegOrMem n) :
    AvxSound p (.vmovIn n dst src) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hw2 : 2 ≤ vecWords w := by cases w <;> decide
  have hbits : w.bits = 64 * vecWords w := by cases w <;> rfl
  have hn : n.bits ≤ 64 := by cases n <;> decide
  simp only [AvxOperation.interp]
  simp only [Braid.wpOps_append] at hw
  refine readRM_sound h hw fun v ρ1 _ hv hw => ?_
  simp only [wpOps, Op.wp] at hw
  have hw := wp_setRegs hw
  obtain ⟨z, hz, h1, h2⟩ := set_eq s.zmms dst (v.zeroExtend _)
  simp only [MachineData.setAvxReg, hz]
  refine done_sound ?_ hw
  refine h.set512 dst.base z rfl rfl (fun j hj => ?_)
    fun x hx => setWords_regs_other _ _ _ _ _ (by omega) hx
  rw [setWords_regs_vecReg]
  have hc : 0 ≤ j ∧ j < 0 + 8 := by omega
  simp only [hc, and_self, ↓reduceIte, Nat.sub_zero]
  by_cases hj0 : j = 0
  · subst hj0
    have h8 : (0 : Nat) ≠ 8 := by decide
    simp only [↓reduceIte, Env.set_apply, h8]
    rw [h1 0 (by omega), hv]
    exact (vecWord_zero_setWidth _ (by omega)).symm
  · simp only [hj0, ↓reduceIte, Env.set_same]
    by_cases hj' : j < vecWords w
    · rw [h1 j hj']
      exact (vecWord_setWidth_zero _ (by omega)).symm
    · rw [h2 j (by omega) hj]
      rfl

theorem vmovOut_sound {w : AvxWidth} (n : Width) (dst : Dst n) (src : AvxReg w) :
    AvxSound p (.vmovOut n dst src) := by
  intro s σ ρ Q ops h hl hw
  simp only [lowerAvx, Option.some.injEq] at hl
  subst hl
  have hn : n.bits ≤ w.bits := by cases n <;> cases w <;> decide
  simp only [AvxOperation.interp]
  simp only [List.cons_append, List.nil_append, wpOps, Op.wp] at hw
  refine writeRM_sound (val := (s.zmms.get src).take n.bits) h ?_ (by decide) hw
    fun s' ρ' σ' _ h' hq => done_sound h' hq
  simp only [Env.set_same, UnOp.eval_zext, h.vec _ 0 (by decide), RegZmms.get]
  exact vecWord_zero_take _ hn

/-- **Every vector instruction is lowered soundly.** -/
theorem lowerAvx_sound {w : AvxWidth} (i : AvxOperation w) : AvxSound p i := by
  cases i
  case paddd dst src => exact paddd_sound dst src
  case vpaddd dst src1 src2 => exact vpaddd_sound dst src1 src2
  case vmovq dst src => exact vmovq_sound dst src
  case vmovIn n dst src => exact vmovIn_sound n dst src
  case vmovOut n dst src => exact vmovOut_sound n dst src
  case movups dst src | movdqu dst src | movaps dst src | movdqa dst src | vmovups dst src |
      vmovdqu dst src | vmovdqu32 dst src | vmovdqa32 dst src =>
    intro s σ ρ Q ops h hl hw
    simp only [lowerAvx, Option.some.injEq] at hl
    subst hl
    exact moveVec_sound h hw
  all_goals intro s σ ρ Q ops h hl hw; simp [lowerAvx] at hl

end

end Lowering.X86
