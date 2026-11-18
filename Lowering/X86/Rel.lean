/-
  Lowering.X86.Rel

  The relation between a machine state of the model and a `braid` state, and what each
  piece of a lowered block does to related states: reading and writing a register or a
  memory operand, computing an address, a condition code, and the flags of a result.

  ## Main definitions

  * `RelD`, `Rel`: a machine state and a `braid` state that describe the same machine
  * `OpSound`: an instruction is lowered soundly

  ## Main results

  * `readRM_sound`, `readOp_sound`, `writeRM_sound`: operands
  * `wp_addr`, `wp_cc`, `wp_pzs`: addresses, condition codes and result flags
-/

module

public import Lowering.X86.Lower
public import Lowering.X86.Mem
public import Lowering.X86.Flags
public import Kraken.X64.OmniSemantics
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env wpOps State ofBool)

/-- The machine data `s` and the `braid` state `σ` describe the same machine: the same
registers, flags and bytes of memory. The vector registers are not part of a `braid` state. -/
structure RelD (s : MachineData) (σ : State) : Prop where
  regs : ∀ r, σ.regs (regNum r) = s.regs.get64 r
  cf : σ.flags 0 = s.status.cf
  pf : σ.flags 1 = s.status.pf
  af : σ.flags 2 = s.status.af
  zf : σ.flags 3 = s.status.zf
  sf : σ.flags 4 = s.status.sf
  of : σ.flags 5 = s.status.of
  df : σ.flags 6 = s.df
  mem : σ.mem = memOf s.dmem

/-- The machine state `m` and the `braid` state `σ` describe the same machine, at the same
program counter. -/
structure Rel (m : MachineState) (σ : State) : Prop where
  data : RelD m.data σ
  pc : σ.pc = m.pc.toBitVec

/-- The environment `ρ'` has the values of `ρ` below `n`. -/
def Agree (n : Nat) (ρ ρ' : Env) : Prop := ∀ x : Nat, x < n → ρ' x = ρ x

theorem Agree.refl (n : Nat) (ρ : Env) : Agree n ρ ρ := fun _ _ => rfl

theorem Agree.set {n : Nat} {ρ ρ' : Env} (h : Agree n ρ ρ') {k : Nat} (hk : n ≤ k) (v : Word) :
    Agree n ρ (ρ'.set k v) := fun x hx => by
  have hne : x ≠ k := by omega
  rw [Env.set_other _ _ hne]; exact h x hx

theorem Agree.trans {n m : Nat} {ρ ρ' ρ'' : Env} (h : Agree n ρ ρ') (h' : Agree m ρ' ρ'')
    (hnm : n ≤ m) : Agree n ρ ρ'' := fun x hx =>
  (h' x (Nat.lt_of_lt_of_le hx hnm)).trans (h x hx)

/-- Close a goal `Agree n ρ (ρ.set … |>.set …)`. -/
macro "agree" : tactic => `(tactic|
  (repeat (first | exact Agree.refl _ _ | refine Agree.set ?_ (by omega) _)))

/-! ## Registers -/

theorem regNum_inj {r r' : Reg64} (h : regNum r = regNum r') : r = r' := by
  cases r <;> cases r' <;> first | rfl | exact absurd h (by decide)

theorem get64_set64 (s : Reg64s) (r r' : Reg64) (v : BitVec 64) :
    (s.set64 r v).get64 r' = if r' = r then v else s.get64 r' := by
  by_cases h : r' = r
  · subst h; cases r' <;> simp [Reg64s.get64, Reg64s.set64]
  · cases r <;> cases r' <;> first | exact absurd rfl h | simp [Reg64s.get64, Reg64s.set64]

theorem RelD.set64 {s : MachineData} {σ : State} (h : RelD s σ) (r : Reg64) (v : Word) :
    RelD { s with regs := s.regs.set64 r v } (σ.setReg (regNum r) v) := by
  refine ⟨fun r' => ?_, h.cf, h.pf, h.af, h.zf, h.sf, h.of, h.df, h.mem⟩
  simp only [State.setReg, get64_set64]
  by_cases hr : r' = r
  · subst hr; simp
  · have : regNum r' ≠ regNum r := fun e => hr (regNum_inj e)
    simp [hr, this, h.regs r']

/-- A state with other flags is related to the machine with that status. -/
theorem RelD.status {s : MachineData} {σ σ' : State} (h : RelD s σ) (st : StatusFlags)
    (hregs : σ'.regs = σ.regs) (hmem : σ'.mem = σ.mem) (hdf : σ'.flags 6 = σ.flags 6)
    (hcf : σ'.flags 0 = st.cf) (hpf : σ'.flags 1 = st.pf) (haf : σ'.flags 2 = st.af)
    (hzf : σ'.flags 3 = st.zf) (hsf : σ'.flags 4 = st.sf) (hof : σ'.flags 5 = st.of) :
    RelD { s with status := st } σ' :=
  ⟨fun r => by rw [hregs]; exact h.regs r, hcf, hpf, haf, hzf, hsf, hof, by rw [hdf]; exact h.df,
    by rw [hmem]; exact h.mem⟩

theorem RelD.setPc {s : MachineData} {σ : State} (h : RelD s σ) (a : Word) :
    RelD s (σ.setPc a) :=
  ⟨h.regs, h.cf, h.pf, h.af, h.zf, h.sf, h.of, h.df, h.mem⟩

variable {s : MachineData} {σ : State} {ρ : Env} {Q : Env → State → Prop}

/-- A sub-register, zero-extended, from its 64-bit register. -/
theorem get_low (regs : Reg64s) (r : Reg64) (w : Width) :
    (regs.get (.low r w)).setWidth 64 = ((regs.get64 r).setWidth w.bits).setWidth 64 := by
  simp only [Reg64s.get, Reg.base, Reg.offset, BitVec.take, BitVec.drop]
  generalize regs.get64 r = x
  cases w <;> simp only [Width.bits] <;> bv_decide

theorem get_low64 (regs : Reg64s) (r : Reg64) : regs.get (.low r .W64) = regs.get64 r := by
  simpa using get_low regs r .W64

theorem get_high (regs : Reg64s) (r : Reg .W8) (hr : r.offset ≠ 0) :
    (regs.get r).setWidth 64 = ((regs.get64 r.base >>> 8#64).setWidth 8).setWidth 64 := by
  cases r <;> first | exact absurd rfl hr | skip
  all_goals
    simp only [Reg64s.get, Reg.base, Reg.offset, BitVec.take, BitVec.drop]
    generalize regs.get64 _ = x
    simp only [Width.bits, Width.type]
    bv_decide

theorem readReg_sound (h : RelD s σ) {n : Nat} {w : Width} {r : Reg w}
    (hw : wpOps (readReg n r) ρ σ Q) :
    ∃ ρ', Agree n ρ ρ' ∧ ρ' n = (s.regs.get r).setWidth 64 ∧ Q ρ' σ := by
  by_cases ho : r.offset = 0
  · cases r with
    | low r w =>
      cases w <;> simp only [readReg, Reg.offset, ↓reduceIte, wpOps, Op.wp, Reg.base] at hw
      all_goals
        refine ⟨_, by agree, ?_, hw⟩
        simp [h.regs, get_low, get_low64]
    | _ => exact absurd ho (by decide)
  · have hw8 : w = .W8 := by cases r <;> first | rfl | exact absurd rfl ho
    subst hw8
    simp only [readReg, ho, ↓reduceIte, wpOps, Op.wp] at hw
    refine ⟨_, by agree, ?_, hw⟩
    simp [h.regs, get_high _ _ ho]

theorem RelD.set64_eq (h : RelD s σ) (r : Reg64) {v v' : Word} (e : v = v') :
    RelD { s with regs := s.regs.set64 r v' } (σ.setReg (regNum r) v) := e ▸ h.set64 r v

theorem set_low64 (regs : Reg64s) (r : Reg64) (v : BitVec 64) :
    regs.set (.low r .W64) v = regs.set64 r v := rfl

theorem set_low32 (regs : Reg64s) (r : Reg64) (v : BitVec 32) :
    regs.set (.low r .W32) v = regs.set64 r (v.setWidth 64) := rfl

theorem set_low16 (regs : Reg64s) (r : Reg64) (v : BitVec 16) :
    regs.set (.low r .W16) v =
      regs.set64 r ((regs.get64 r &&& ~~~0xffff#64) ||| v.setWidth 64) := by
  have key : ∀ x : BitVec 64, (x.extractLsb' 16 48 ++ v).setWidth 64 =
      (x &&& ~~~0xffff#64) ||| v.setWidth 64 := by intro x; bv_decide
  exact congrArg (regs.set64 r) (key _)

theorem set_low8 (regs : Reg64s) (r : Reg64) (v : BitVec 8) :
    regs.set (.low r .W8) v =
      regs.set64 r ((regs.get64 r &&& ~~~0xff#64) ||| v.setWidth 64) := by
  have key : ∀ x : BitVec 64, (x.extractLsb' 8 56 ++ v).setWidth 64 =
      (x &&& ~~~0xff#64) ||| v.setWidth 64 := by intro x; bv_decide
  exact congrArg (regs.set64 r) (key _)

theorem set_high (regs : Reg64s) (r : Reg .W8) (hr : r.offset ≠ 0) (v : BitVec 8) :
    regs.set r v =
      regs.set64 r.base ((regs.get64 r.base &&& ~~~0xff00#64) ||| (v.setWidth 64 <<< 8#64)) := by
  have key : ∀ x : BitVec 64,
      (x.extractLsb' 16 48 ++ (v ++ (x.extractLsb' 0 64).extractLsb' 0 8)).setWidth 64 =
        (x &&& ~~~0xff00#64) ||| (v.setWidth 64 <<< 8#64) := by intro x; bv_decide
  cases r <;> first | exact absurd rfl hr | skip
  all_goals
    simp only [Reg64s.set, Reg64s.get, BitVec.replaceLow, BitVec.drop, BitVec.take, Reg.base,
      Reg.offset]
    refine congrArg _ ?_
    exact key _

@[simp] theorem signBit_w8 : signBit .W8 = 0x80#64 := by decide

@[simp] theorem signBit_w16 : signBit .W16 = 0x8000#64 := by decide

@[simp] theorem signBit_w32 : signBit .W32 = 0x80000000#64 := by decide

@[simp] theorem signBit_w64 : signBit .W64 = 0x8000000000000000#64 := by decide

@[simp] theorem mask_w16 : mask .W16 = 0xffff#64 := by decide

@[simp] theorem mask_w8 : mask .W8 = 0xff#64 := by decide

/-- Writing a register gives a state related to the machine's. -/
theorem writeReg_sound (h : RelD s σ) {n v : Nat} {w : Width} {r : Reg w} {val : w.type}
    (hv : ρ v = val.setWidth 64) (hvn : v < n) (hw : wpOps (writeReg n r v) ρ σ Q) :
    ∃ ρ' σ', Agree n ρ ρ' ∧ RelD (s.setReg r val) σ' ∧ Q ρ' σ' := by
  have h0 : v ≠ n := by omega
  have h1 : v ≠ n + 1 := by omega
  have h2 : v ≠ n + 2 := by omega
  have h3 : v ≠ n + 3 := by omega
  have h4 : v ≠ n + 4 := by omega
  by_cases ho : r.offset = 0
  · cases r with
    | low r w =>
      cases w <;> simp only [writeReg, Reg.offset, ↓reduceIte, wpOps, Op.wp, Reg.base] at hw
      · refine ⟨_, _, by agree, ?_, hw⟩
        rw [MachineData.setReg, set_low8]
        exact h.set64_eq r (by simp [h0, h1, h2, hv, h.regs])
      · refine ⟨_, _, by agree, ?_, hw⟩
        rw [MachineData.setReg, set_low16]
        exact h.set64_eq r (by simp [h0, h1, h2, hv, h.regs])
      · refine ⟨_, _, by agree, ?_, hw⟩
        rw [MachineData.setReg, set_low32]
        exact h.set64_eq r (by simp [hv])
      · refine ⟨_, _, by agree, ?_, hw⟩
        rw [MachineData.setReg, set_low64]
        exact h.set64_eq r (by simpa using hv)
    | _ => exact absurd ho (by decide)
  · have hw8 : w = .W8 := by cases r <;> first | rfl | exact absurd rfl ho
    subst hw8
    simp only [writeReg, ho, ↓reduceIte, wpOps, Op.wp] at hw
    refine ⟨_, _, by agree, ?_, hw⟩
    rw [MachineData.setReg, set_high _ _ ho]
    exact h.set64_eq _ (by simp [h0, h1, h2, h3, hv, h.regs])

/-! ## Addresses and memory -/

section
variable [Labels] {p : Std.Rco Int64} {post : MachineState → Prop}

/-- The address of a memory operand, at the 64-bit address size. -/
def addrVal (p : Std.Rco Int64) (a : AddrExpr) (s : MachineData) : Word :=
  (a.interp (address_size := ⟨.W64⟩) s.regs p).zeroExtend 64

theorem addrVal_eq (a : AddrExpr) (s : MachineData) :
    addrVal p a s =
      (match a.base with
        | some (.reg r) => s.regs.get64 r
        | some .rip => p.upper.toBitVec
        | none => 0#64) +
      (match a.idx with
        | some i => s.regs.get64 i.reg * BitVec.ofNat 64 i.scale.bytes
        | none => 0#64) +
      (a.disp.interp p).toBitVec := by
  obtain ⟨base, idx, disp⟩ := a
  rcases base with _ | r | _ <;> rcases idx with _ | ⟨ir, ic⟩ <;>
    simp only [addrVal, AddrExpr.interp, BitVec.toAddressSize, BitVec.take, BitVec.signed]
  all_goals
    simp [BitVec.ofInt_add, BitVec.ofInt_mul, ← Int64.toInt_toBitVec]

/-- Run the pure operations at the head of a list, looking values up as they are used. -/
macro "x86_ops" "at" hw:ident : tactic => `(tactic|
  simp only [wpOps, Op.wp, Env.set_apply, List.cons_append, List.nil_append, List.append_assoc,
    Nat.add_left_cancel_iff, Nat.add_eq_left, Nat.left_eq_add, Nat.reduceEqDiff,
    Nat.succ_ne_self, ↓reduceIte] at $hw:ident)

theorem wp_addr (h : RelD s σ) {n : Nat} {a : AddrExpr} (hw : wpOps (addrOps p n a) ρ σ Q) :
    ∃ ρ', Agree n ρ ρ' ∧ ρ' n = addrVal p a s ∧ Q ρ' σ := by
  rw [addrVal_eq]
  obtain ⟨base, idx, disp⟩ := a
  rcases base with _ | r | _ <;> rcases idx with _ | ⟨ir, ic⟩
  all_goals simp only [addrOps, baseOps] at hw
  case some.reg.none =>
    by_cases hd : disp = .int64 0
    · subst hd
      simp only [↓reduceIte] at hw
      x86_ops at hw
      exact ⟨_, by agree, by simp [h.regs, ConstExpr.interp], hw⟩
    · simp only [hd, ↓reduceIte] at hw
      x86_ops at hw
      exact ⟨_, by agree, by simp [h.regs], hw⟩
  all_goals
    x86_ops at hw
    exact ⟨_, by agree, by simp [h.regs], hw⟩

omit [Labels] in
/-- A load `braid` allows is a load of the model, of the value zero-extended. -/
theorem load_sound (h : RelD s σ) {a v : Word} {w : Width}
    {ret : w.type → MachineData → Effects} (hl : σ.mem.load a (bw w) = some v)
    (hk : (v.setWidth w.bits).setWidth 64 = v → (ret (v.setWidth w.bits) s).All post) :
    (s.load a w ret).All post := by
  have hn : w.bytes ≤ 8 := by cases w <;> decide
  have hb : (bw w).bytes = w.bytes := by cases w <;> rfl
  have hbits : w.bits = 8 * w.bytes := by cases w <;> rfl
  rw [Braid.Mem.load, hb, h.mem] at hl
  obtain ⟨hi, hlt⟩ := loadInt_of_loadN hn hl
  rw [← hbits] at hlt
  simp only [MachineData.load, Effects.All_require_read_access, hi]
  have e : BitVec.ofInt w.bits (v.toNat : Int) = v.setWidth w.bits := by
    rw [BitVec.ofInt_natCast, BitVec.ofNat_toNat]
  rw [e]
  exact hk (setWidth_setWidth_of_lt hlt)

theorem readRM_sound (h : RelD s σ) {n : Nat} {w : Width} {o : RegOrMem w}
    {ret : w.type → MachineData → Effects} (hw : wpOps (readRM p n o) ρ σ Q)
    (hk : ∀ (v : w.type) ρ', Agree n ρ ρ' → ρ' n = v.setWidth 64 → Q ρ' σ →
      (ret v s).All post) :
    (@RegOrMem.interp w _ ⟨.W64⟩ o s p ret).All post := by
  cases o with
  | reg r =>
    obtain ⟨ρ', hag, hv, hq⟩ := readReg_sound h hw
    exact hk _ ρ' hag hv hq
  | mem a =>
    simp only [readRM, Braid.wpOps_append] at hw
    obtain ⟨ρ', hag, hv, hq⟩ := wp_addr h hw
    x86_ops at hq
    obtain ⟨v, hl, hq⟩ := hq
    rw [hv] at hl
    refine load_sound h hl fun e => hk _ _ ?_ ?_ hq
    · exact fun x hx => by
        have hne : x ≠ n := by omega
        rw [Env.set_other _ _ hne]; exact hag x (by omega)
    · rw [Env.set_same, e]

theorem readOp_sound (h : RelD s σ) {n : Nat} {w : Width} {o : Operand w}
    {ret : w.type → MachineData → Effects} (hw : wpOps (readOp p n o) ρ σ Q)
    (hk : ∀ (v : w.type) ρ', Agree n ρ ρ' → ρ' n = v.setWidth 64 → Q ρ' σ →
      (ret v s).All post) :
    (@Operand.interp w _ ⟨.W64⟩ o s p ret).All post := by
  cases o with
  | regOrMem o => exact readRM_sound h hw hk
  | imm c =>
    simp only [readOp] at hw
    x86_ops at hw
    exact hk ((c.interp p).toBitVec.truncate w.bits) _ (by agree) (by simp) hw

omit [Labels] in
/-- A store `braid` allows is a store of the model. -/
theorem store_sound (h : RelD s σ) {a v : Word} {w : Width} {val : w.type} {m : Braid.Mem}
    {ret : MachineData → Effects} (hv : v = val.setWidth 64)
    (hs : σ.mem.store a (bw w) v = some m)
    (hk : ∀ s', RelD s' { σ with mem := m } → (ret s').All post) :
    (s.store a val ret).All post := by
  have hn : w.bytes ≤ 8 := by cases w <;> decide
  have hb : (bw w).bytes = w.bytes := by cases w <;> rfl
  have hbits : w.bits = 8 * w.bytes := by cases w <;> rfl
  rw [Braid.Mem.store, hb, h.mem] at hs
  have hi : val.toInt % 2 ^ (8 * w.bytes) = (v.toNat : Int) % 2 ^ (8 * w.bytes) := by
    have hle : w.bits ≤ 64 := by cases w <;> decide
    have hlt : val.toNat < 2 ^ 64 :=
      Nat.lt_of_lt_of_le val.isLt (Nat.pow_le_pow_right (by decide) hle)
    rw [← hbits, hv, BitVec.toInt_eq_toNat_bmod, BitVec.toNat_setWidth, Nat.mod_eq_of_lt hlt]
    exact Int.bmod_emod
  obtain ⟨hsome, hm⟩ := storeInt_of_storeN hn hs val.toInt hi
  obtain ⟨i, hi'⟩ := Option.isSome_iff_exists.1 hsome
  simp only [MachineData.store, Effects.All_require_write_access, hi']
  exact hk _ ⟨h.regs, h.cf, h.pf, h.af, h.zf, h.sf, h.of, h.df, hm⟩

theorem writeRM_sound (h : RelD s σ) {n v : Nat} {w : Width} {d : RegOrMem w} {val : w.type}
    {ret : MachineData → Effects} (hv : ρ v = val.setWidth 64) (hvn : v < n)
    (hw : wpOps (writeRM p n d v) ρ σ Q)
    (hk : ∀ s' ρ' σ', Agree n ρ ρ' → RelD s' σ' → Q ρ' σ' → (ret s').All post) :
    (@MachineData.set w _ ⟨.W64⟩ s d val p ret).All post := by
  cases d with
  | reg r =>
    obtain ⟨ρ', σ', hag, h', hq⟩ := writeReg_sound h hv hvn hw
    exact hk _ ρ' σ' hag h' hq
  | mem a =>
    simp only [writeRM, Braid.wpOps_append] at hw
    obtain ⟨ρ', hag, ha, hq⟩ := wp_addr h hw
    x86_ops at hq
    obtain ⟨m, hs, hq⟩ := hq
    rw [ha, hag v hvn, hv] at hs
    exact store_sound h rfl hs fun s' h' => hk s' ρ' _ hag h' hq

/-! ## Flags -/

omit [Labels] in
theorem wp_cc (h : RelD s σ) {n : Nat} {cc : CondCode} (hw : wpOps (ccOps n cc) ρ σ Q) :
    ∃ ρ', Agree n ρ ρ' ∧ ρ' n = ofBool (cc.interp s.status) ∧ Q ρ' σ := by
  cases cc <;> simp only [ccOps] at hw <;> x86_ops at hw <;> refine ⟨_, by agree, ?_, hw⟩ <;>
    simp only [Env.set_same, CondCode.interp, h.cf, h.pf, h.zf, h.sf, h.of] <;>
    cases s.status.cf <;> cases s.status.pf <;> cases s.status.zf <;> cases s.status.sf <;>
    cases s.status.of <;> rfl

omit [Labels] in
/-- The parity, zero and sign flags of a result, as the model computes them. -/
theorem wp_pzs {n r : Nat} {w : Width} {val : w.type} (hr : ρ r = val.setWidth 64)
    (hrn : r < n) (hw : wpOps (pzsOps n w r) ρ σ Q) :
    ∃ ρ', Agree n ρ ρ' ∧
      Q ρ' (((σ.setFlag 1 ((val.take 8).cpop_ % 2 == BitVec.zero _)).setFlag 3
        (val == BitVec.zero _)).setFlag 4 val.msb) := by
  have h0 : r ≠ n := by omega
  have h1 : r ≠ n + 1 := by omega
  have h2 : r ≠ n + 2 := by omega
  have h3 : r ≠ n + 3 := by omega
  have h4 : r ≠ n + 4 := by omega
  have h5 : r ≠ n + 5 := by omega
  have h6 : r ≠ n + 6 := by omega
  have h7 : r ≠ n + 7 := by omega
  simp only [pzsOps] at hw
  x86_ops at hw
  simp only [h0, h1, h2, h3, h4, h5, h6, h7, ↓reduceIte, hr] at hw
  have e1 : (BinOp.eq.eval (BinOp.and.eval (UnOp.popcnt.eval ((UnOp.zext 8).eval
      (BitVec.setWidth 64 val))) 1) 0 != 0#64) =
      ((val.take 8).cpop_ % 2 == BitVec.zero _) := by
    clear hw hr
    simp only [cpop_eq, BitVec.take]
    cases w <;> dsimp only [Width.type, Width.bits] at val ⊢ <;> simp <;> bv_decide
  have e2 : (BinOp.eq.eval (BitVec.setWidth 64 val) 0 != 0#64) = (val == BitVec.zero _) := by
    clear hw hr e1
    cases w <;> dsimp only [Width.type, Width.bits] at val ⊢ <;> simp <;> bv_decide
  have e3 : (BinOp.and.eval (BitVec.setWidth 64 val) (signBit w) != 0#64) = val.msb := by
    clear hw hr e1 e2
    cases w <;> dsimp only [Width.type, Width.bits] at val ⊢ <;> simp <;> bv_decide
  rw [e1, e2, e3] at hw
  exact ⟨_, by agree, hw⟩

omit [Labels] in
/-- The parity, zero and sign flags of a result, as values. -/
theorem wp_pzsVals {n r : Nat} {w : Width} {val : w.type} (hr : ρ r = val.setWidth 64)
    (hrn : r < n) (hw : wpOps (pzsVals n w r) ρ σ Q) :
    ∃ ρ', Agree n ρ ρ' ∧ (ρ' (n + 5) != 0#64) = ((val.take 8).cpop_ % 2 == BitVec.zero _) ∧
      (ρ' (n + 6) != 0#64) = (val == BitVec.zero _) ∧ (ρ' (n + 8) != 0#64) = val.msb ∧
      Q ρ' σ := by
  have h0 : r ≠ n := by omega
  have h1 : r ≠ n + 1 := by omega
  have h2 : r ≠ n + 2 := by omega
  have h3 : r ≠ n + 3 := by omega
  have h4 : r ≠ n + 4 := by omega
  have h5 : r ≠ n + 5 := by omega
  have h6 : r ≠ n + 6 := by omega
  have h7 : r ≠ n + 7 := by omega
  simp only [pzsVals] at hw
  x86_ops at hw
  simp only [h0, h1, h2, h3, h4, h5, h6, h7, ↓reduceIte, hr] at hw
  have e1 : (BinOp.eq.eval (BinOp.and.eval (UnOp.popcnt.eval ((UnOp.zext 8).eval
      (BitVec.setWidth 64 val))) 1) 0 != 0#64) =
      ((val.take 8).cpop_ % 2 == BitVec.zero _) := by
    clear hw hr
    simp only [cpop_eq, BitVec.take]
    cases w <;> dsimp only [Width.type, Width.bits] at val ⊢ <;> simp <;> bv_decide
  have e2 : (BinOp.eq.eval (BitVec.setWidth 64 val) 0 != 0#64) = (val == BitVec.zero _) := by
    clear hw hr e1
    cases w <;> dsimp only [Width.type, Width.bits] at val ⊢ <;> simp <;> bv_decide
  have e3 : (BinOp.and.eval (BitVec.setWidth 64 val) (signBit w) != 0#64) = val.msb := by
    clear hw hr e1 e2
    cases w <;> dsimp only [Width.type, Width.bits] at val ⊢ <;> simp <;> bv_decide
  refine ⟨_, by agree, ?_, ?_, ?_, hw⟩
  · simpa [Env.set_apply] using e1
  · simpa [Env.set_apply] using e2
  · simpa [Env.set_apply] using e3

omit [Labels] in
/-- The flags are kept: the condition of `selFlags` is not zero. -/
theorem wp_selFlags_keep (h : RelD s σ) {z cf pf af zf sf of : Nat} (hz : ρ z ≠ 0#64)
    (hlt : z < 60) (hw : wpOps (selFlags z cf pf af zf sf of) ρ σ Q) :
    ∃ ρ' σ', Agree 60 ρ ρ' ∧ RelD s σ' ∧ Q ρ' σ' := by
  have z0 : z ≠ 60 := by omega
  have z1 : z ≠ 61 := by omega
  have z2 : z ≠ 62 := by omega
  have z3 : z ≠ 63 := by omega
  have z4 : z ≠ 64 := by omega
  have z5 : z ≠ 65 := by omega
  have z6 : z ≠ 66 := by omega
  have z7 : z ≠ 67 := by omega
  have z8 : z ≠ 68 := by omega
  have z9 : z ≠ 69 := by omega
  have z10 : z ≠ 70 := by omega
  simp only [selFlags] at hw
  x86_ops at hw
  simp only [z0, z1, z2, z3, z4, z5, z6, z7, z8, z9, z10, ↓reduceIte, hz, ne_eq,
    not_false_eq_true, Braid.ofBool_bne_zero] at hw
  refine ⟨_, _, by agree, ?_, hw⟩
  have hs : s = { s with status := s.status } := rfl
  rw [hs]
  exact RelD.status h s.status (by rfl) (by rfl) (by simp [State.setFlag])
    (by simp [State.setFlag, h.cf]) (by simp [State.setFlag, h.pf])
    (by simp [State.setFlag, h.af]) (by simp [State.setFlag, h.zf])
    (by simp [State.setFlag, h.sf]) (by simp [State.setFlag, h.of])

omit [Labels] in
/-- The flags are set: the condition of `selFlags` is zero, and each value is the flag of
the status `st`. -/
theorem wp_selFlags_set (h : RelD s σ) {z cf pf af zf sf of : Nat} {st : StatusFlags}
    (hz : ρ z = 0#64)
    (hlt : z < 60 ∧ cf < 60 ∧ pf < 60 ∧ af < 60 ∧ zf < 60 ∧ sf < 60 ∧ of < 60)
    (hcf : (ρ cf != 0#64) = st.cf) (hpf : (ρ pf != 0#64) = st.pf)
    (haf : (ρ af != 0#64) = st.af) (hzf : (ρ zf != 0#64) = st.zf)
    (hsf : (ρ sf != 0#64) = st.sf) (hof : (ρ of != 0#64) = st.of)
    (hw : wpOps (selFlags z cf pf af zf sf of) ρ σ Q) :
    ∃ ρ' σ', Agree 60 ρ ρ' ∧ RelD { s with status := st } σ' ∧ Q ρ' σ' := by
  obtain ⟨hz', hc', hp', ha', hzz', hs', ho'⟩ := hlt
  have ne : ∀ {x : Nat}, x < 60 → x ≠ 60 ∧ x ≠ 61 ∧ x ≠ 62 ∧ x ≠ 63 ∧ x ≠ 64 ∧ x ≠ 65 ∧
      x ≠ 66 ∧ x ≠ 67 ∧ x ≠ 68 ∧ x ≠ 69 ∧ x ≠ 70 ∧ x ≠ 71 := fun hx => by omega
  obtain ⟨a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, -⟩ := ne hz'
  obtain ⟨b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, -⟩ := ne hc'
  obtain ⟨c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, -⟩ := ne hp'
  obtain ⟨d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, -⟩ := ne ha'
  obtain ⟨e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, -⟩ := ne hzz'
  obtain ⟨f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, -⟩ := ne hs'
  obtain ⟨g0, g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, -⟩ := ne ho'
  simp only [selFlags] at hw
  x86_ops at hw
  simp only [a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, b0, c0, c1, c2, d0, d1, d2, d3, d4,
    e0, e1, e2, e3, e4, e5, e6, f0, f1, f2, f3, f4, f5, f6, f7, f8, g0, g1, g2, g3, g4, g5, g6,
    g7, g8, g9, g10, ↓reduceIte, hz, ne_eq, not_true_eq_false, hcf, hpf, haf, hzf, hsf, hof] at hw
  exact ⟨_, _, by agree, RelD.status h st (by rfl) (by rfl) (by simp [State.setFlag])
    (by simp [State.setFlag]) (by simp [State.setFlag]) (by simp [State.setFlag])
    (by simp [State.setFlag]) (by simp [State.setFlag]) (by simp [State.setFlag]), hw⟩

omit [Labels] in
/-- The machine has gone to `a`, and so has the block. -/
theorem done_sound {s' : MachineData} {σ' : State} {a : Int64} {Q : State → Prop}
    (h : RelD s' σ') (hq : Q (σ'.setPc a.toBitVec)) :
    (Effects.done ⟨s', a⟩).All fun m => ∃ σ', Rel m σ' ∧ Q σ' :=
  ⟨_, ⟨h.setPc _, rfl⟩, hq⟩

omit [Labels] in
theorem RelD.setDf (h : RelD s σ) {b b' : Bool} (e : b' = b) :
    RelD { s with df := b } (σ.setFlag 6 b') := by
  subst e
  exact ⟨h.regs, h.cf, h.pf, h.af, h.zf, h.sf, h.of, by simp [State.setFlag], h.mem⟩

omit [Labels] in
theorem ofBool_coe (w : Width) (b : Bool) :
    ofBool b = (BitVec.ofNat w.bits b.toNat : BitVec w.bits).setWidth 64 := by
  cases w <;> cases b <;> decide

omit [Labels] in
theorem setWidth_zext {w w' : Width} (hle : w'.bits ≤ w.bits) (v : w'.type) :
    ((v.zeroExtend w.bits).setWidth 64 : Word) = v.setWidth 64 := by
  cases w <;> cases w' <;> first | exact absurd hle (by decide) | skip
  all_goals
    dsimp only [Width.type, Width.bits] at v ⊢
    bv_decide

/-- Finish an instruction that sets the status flags: each flag of the block is the model's. -/
macro "x86_flags" h:ident hst:ident : tactic => `(tactic|
  (all_goals subst $hst
   all_goals try simp only [StatusFlags.from_result, uadd_ne, sadd_ne, usub_ne, ssub_ne, neg_ne,
     inc_ne8, inc_ne16, inc_ne32, inc_ne64, dec_ne8, dec_ne16, dec_ne32, dec_ne64]
   all_goals simp [State.setFlag, ($h).df, ($h).cf]
   all_goals bv_decide))

/-- The instruction `i` is lowered soundly: if its operations and terminator run without fault
and establish `Q`, every outcome of `i` in the model is related to a state satisfying `Q`. -/
def OpSound (p : Std.Rco Int64) {w : Width} (i : Operation w) : Prop :=
  ∀ {s : MachineData} {σ : State} {ρ : Env} {Q : State → Prop} {ops : List Op} {t : Term},
    RelD s σ → lowerOp p i = some (ops, t) → wpOps ops ρ σ (fun ρ σ' => t.wp ρ σ' Q) →
    (@Operation.interp _ ⟨.W64⟩ w i p s (fun s' => .done ⟨s', p.upper⟩)
      (fun a s' => .done ⟨s', a⟩)).All fun m => ∃ σ', Rel m σ' ∧ Q σ'

end

end Lowering.X86
