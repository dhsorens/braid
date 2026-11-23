/-
  Lowering.RiscV.Sound

  The RISC-V lowering is sound: if the block of an instruction runs without fault and
  establishes a postcondition, the machine takes its step and lands in a related state
  that satisfies it.

  ## Main results

  * `Rel`: a machine state and a `braid` state that describe the same machine
  * `lower_sound`: one instruction
  * `lowerCode_sound`: every run, `Eventually` to `stepN`
-/

module

public import Lowering.RiscV.Lower
public import Lowering.RiscV.Mem
import Std.Tactic.BVDecide
import Braid.BV

@[expose] public section

namespace Lowering.RiscV

open Braid hiding Reg
open RiscvZkvm.Rv64

/-- The machine state `s` and the `braid` state `σ` describe the same machine: the same
registers and program counter, and the same bytes at every valid address. -/
structure Rel (s : MachineState) (σ : State) : Prop where
  regs : ∀ r : Reg, r ≠ .x0 → σ.regs r.toNat = s.regs r
  pc : σ.pc = s.pc
  mem : ∀ a, σ.mem a = if isValidMemAddr a then some ⟨s.getByte a, true⟩ else none

theorem Reg.toNat_inj {r r' : Reg} (h : r.toNat = r'.toNat) : r = r' := by
  cases r <;> cases r' <;> first | rfl | exact absurd h (by decide)

theorem Rel.setPC {s : MachineState} {σ : State} (h : Rel s σ) (a : Word) :
    Rel (s.setPC a) (σ.setPc a) :=
  ⟨h.regs, rfl, h.mem⟩

theorem setReg_eq {s : MachineState} {r : Reg} (hr : r ≠ .x0) (v : Word) :
    s.setReg r v = { s with regs := fun r' => if r' == r then v else s.regs r' } := by
  cases r <;> first | exact absurd rfl hr | rfl

theorem getReg_eq {s : MachineState} {r : Reg} (hr : r ≠ .x0) : s.getReg r = s.regs r := by
  cases r <;> first | exact absurd rfl hr | rfl

theorem Rel.setReg {s : MachineState} {σ : State} (h : Rel s σ) {r : Reg} (hr : r ≠ .x0)
    (v : Word) : Rel (s.setReg r v) (σ.setReg r.toNat v) := by
  rw [setReg_eq hr]
  refine ⟨fun r' hr' => ?_, h.pc, h.mem⟩
  simp only [State.setReg]
  by_cases hrr : r' = r
  · subst hrr; simp
  · have hn : r'.toNat ≠ r.toNat := fun hn => hrr (Reg.toNat_inj hn)
    simp [hn, hrr, h.regs r' hr']

/-- Reading a register gives the machine's value. -/
theorem wp_rget {s : MachineState} {σ : State} (h : Rel s σ) {d : Var} {r : Reg} {ρ : Env}
    {Q : Env → State → Prop} (hw : (rget d r).wp ρ σ Q) : Q (ρ.set d (s.getReg r)) σ := by
  unfold rget at hw
  split at hw
  · subst_vars; exact hw
  · rename_i hr
    simp only [Op.wp] at hw
    rw [h.regs r hr, ← getReg_eq hr] at hw
    exact hw

/-- Writing a register gives a state related to the machine's. -/
theorem wp_rset {s : MachineState} {σ : State} (h : Rel s σ) {r : Reg} {a : Var} {ρ : Env}
    {Q : Env → State → Prop} (hw : wpOps (rset r a) ρ σ Q) :
    ∃ σ', Rel (s.setReg r (ρ a)) σ' ∧ Q ρ σ' := by
  unfold rset at hw
  split at hw
  · subst_vars; exact ⟨σ, h, hw⟩
  · rename_i hr
    exact ⟨_, h.setReg hr _, hw⟩

/-! ## The shapes of block -/

variable {s : MachineState} {σ : State} {Q : State → Prop} {pc : Word}

theorem binRR_sound (h : Rel s σ) {op : BinOp} {rd rs1 rs2 : Reg}
    (hw : (binRR pc op rd rs1 rs2).wp σ Q) :
    ∃ σ', Rel ((s.setReg rd (op.eval (s.getReg rs1) (s.getReg rs2))).setPC (pc + 4)) σ' ∧
      Q σ' := by
  simp only [binRR, Block.wp, List.cons_append, List.nil_append, wpOps] at hw
  have hw := wp_rget h hw
  have hw := wp_rget h hw
  simp only [Op.wp] at hw
  obtain ⟨σ', h', hw⟩ := wp_rset h hw
  simp [Env.set] at h'
  exact ⟨_, h'.setPC _, hw⟩

theorem binRI_sound (h : Rel s σ) {op : BinOp} {rd rs1 : Reg} {imm : Word}
    (hw : (binRI pc op rd rs1 imm).wp σ Q) :
    ∃ σ', Rel ((s.setReg rd (op.eval (s.getReg rs1) imm)).setPC (pc + 4)) σ' ∧ Q σ' := by
  simp only [binRI, Block.wp, List.cons_append, List.nil_append, wpOps] at hw
  have hw := wp_rget h hw
  simp only [Op.wp] at hw
  obtain ⟨σ', h', hw⟩ := wp_rset h hw
  simp [Env.set] at h'
  exact ⟨_, h'.setPC _, hw⟩

theorem shiftRR_sound (h : Rel s σ) {op : BinOp} {rd rs1 rs2 : Reg}
    (hw : (shiftRR pc op rd rs1 rs2).wp σ Q) :
    ∃ σ', Rel ((s.setReg rd (op.eval (s.getReg rs1) (s.getReg rs2 &&& 63))).setPC (pc + 4)) σ' ∧
      Q σ' := by
  simp only [shiftRR, Block.wp, List.cons_append, List.nil_append, wpOps] at hw
  have hw := wp_rget h hw
  have hw := wp_rget h hw
  simp only [Op.wp] at hw
  obtain ⟨σ', h', hw⟩ := wp_rset h hw
  simp [Env.set] at h'
  exact ⟨_, h'.setPC _, hw⟩

theorem Rel.cast {s s' : MachineState} (h : Rel s σ) (e : s' = s) : Rel s' σ := e ▸ h

/-- Run the register reads and pure operations at the head of a block. -/
macro "rv_ops" h:ident hw:ident : tactic => `(tactic|
  (simp only [Block.wp, List.cons_append, List.nil_append, List.append_assoc, wpOps] at $hw:ident
   repeat (first
     | have $hw:ident := wp_rget $h $hw
     | simp only [Op.wp, Env.set_apply, Nat.reduceEqDiff, ↓reduceIte] at $hw:ident)))

theorem branchI_sound (h : Rel s σ) {op : BinOp} {neg : Bool} {rs1 rs2 : Reg}
    {offset : BitVec 13} (hw : (branchI pc op neg rs1 rs2 offset).wp σ Q) :
    ∃ σ', Rel (s.setPC (if (op.eval (s.getReg rs1) (s.getReg rs2) != 0) != neg
      then pc + signExtend13 offset else pc + 4)) σ' ∧ Q σ' := by
  simp only [branchI] at hw
  rv_ops h hw
  refine ⟨_, h.setPC _, ?_⟩
  cases neg <;> simp only [Term.wp] at hw
  · simpa using hw
  · by_cases hc : op.eval (s.getReg rs1) (s.getReg rs2) = 0 <;> simpa [hc] using hw

theorem divI_sound (h : Rel s σ) {op : BinOp} {byZero : Option Word} {rd rs1 rs2 : Reg}
    (hw : (divI pc op byZero rd rs1 rs2).wp σ Q) :
    ∃ σ', Rel ((s.setReg rd (if s.getReg rs2 == 0 then byZero.getD (s.getReg rs1)
      else op.eval (s.getReg rs1) (s.getReg rs2))).setPC (pc + 4)) σ' ∧ Q σ' := by
  simp only [divI] at hw
  cases byZero <;> rv_ops h hw
  all_goals
    obtain ⟨σ', h', hw⟩ := wp_rset h hw
    refine ⟨_, (h'.setPC _).cast ?_, hw⟩
    by_cases hc : s.getReg rs2 = 0 <;> simp [Env.set, hc]

@[simp] theorem nat_and_63 (n : Nat) : n &&& 63 = n % 64 := Nat.and_two_pow_sub_one_eq_mod n 6

@[simp] theorem nat_and_31 (n : Nat) : n &&& 31 = n % 32 := Nat.and_two_pow_sub_one_eq_mod n 5

@[simp] theorem toNat_mod_word {w : Nat} (x : BitVec w) (hw : w ≤ 64 := by decide) :
    x.toNat % 18446744073709551616 = x.toNat :=
  Nat.mod_eq_of_lt (Nat.lt_of_lt_of_le x.isLt (Nat.pow_le_pow_right (by decide) hw))

theorem trunc_zext_lshr (x : BitVec 32) (n : Nat) :
    BitVec.setWidth 32 (BitVec.setWidth 64 x >>> n) = x >>> n := by
  ext i hi
  simp only [BitVec.getElem_setWidth, BitVec.getLsbD_ushiftRight, BitVec.getElem_ushiftRight,
    BitVec.getLsbD_setWidth]
  by_cases h : n + i < 32
  · simp [h]; omega
  · cases hx : x.getLsbD (n + i)
    · simp
    · exact absurd (BitVec.lt_of_getLsbD hx) h

theorem trunc_add (a b : Word) :
    BitVec.setWidth 32 (a + b) = BitVec.setWidth 32 a + BitVec.setWidth 32 b :=
  by bv_auto

theorem trunc_sub (a b : Word) :
    BitVec.setWidth 32 (a - b) = BitVec.setWidth 32 a - BitVec.setWidth 32 b :=
  by bv_auto

theorem step_plain {i : Instr} (hf : s.code s.pc = some i) (hne : i ≠ .ECALL)
    (hnb : i ≠ .EBREAK) (hnm : i.isMemAccess = false) : step s = some (execInstrBr s i) :=
  step_non_ecall_non_mem hf hne hnb hnm

/-- Finish an instruction that writes one register and goes to the next. -/
macro "rv_reg" h:ident hf:ident hw:ident : tactic => `(tactic|
  (simp only [lower, binW] at $hw:ident
   rv_ops $h $hw
   obtain ⟨σ', h', hq⟩ := wp_rset $h $hw
   simp only [Term.wp] at hq
   exact ⟨_, _, step_plain $hf (by simp) (by simp) rfl,
     (h'.setPC _).cast (by simp [execInstrBr, Env.set, trunc_zext_lshr, trunc_add, trunc_sub]), hq⟩))

/-! ## Memory -/

theorem Rel.cell (h : Rel s σ) {a : Word} {c : Cell} (hc : σ.mem a = some c) :
    isValidMemAddr a = true ∧ c = ⟨s.getByte a, true⟩ := by
  rw [h.mem] at hc
  split at hc
  · rename_i hv; exact ⟨hv, (Option.some.inj hc).symm⟩
  · cases hc

/-- A store that `braid` allows is one the machine's bytes follow. -/
theorem Rel.store (h : Rel s σ) {a v : Word} {n : Nat} {m : Mem} {s' : MachineState}
    (hn : n ≤ 8) (hm : σ.mem.storeN a v n = some m)
    (hregs : s'.regs = s.regs) (hpc : s'.pc = s.pc)
    (hb : ∀ x, s'.getByte x =
      if (x - a).toNat < n then (v >>> ((x - a) <<< 3)).truncate 8 else s.getByte x) :
    Rel s' { σ with mem := m } := by
  obtain ⟨hall, rfl⟩ := (Mem.storeN_spec hn).1 hm
  refine ⟨fun r hr => by rw [hregs]; exact h.regs r hr, by rw [hpc]; exact h.pc, fun x => ?_⟩
  simp only [hb]
  by_cases hx : (x - a).toNat < n
  · obtain ⟨c, hc, _⟩ := hall x hx
    simp only [hx, ↓reduceIte, (h.cell hc).1]
  · simp only [hx, ↓reduceIte, h.mem]

theorem regs_setMem (a v : Word) : (s.setMem a v).regs = s.regs := rfl

/-- What the block of a load establishes: the load succeeds at an aligned address, and the
register holds the value read. -/
theorem loadI_sound (h : Rel s σ) {w : Width} {signed : Bool} {rd rs1 : Reg}
    {offset : BitVec 12} (hw : (loadI pc w signed rd rs1 offset).wp σ Q) :
    ∃ v σ', σ.mem.load (s.getReg rs1 + signExtend12 offset) w = some v ∧
      (w ≠ .w8 → (s.getReg rs1 + signExtend12 offset) &&& BitVec.ofNat 64 (w.bytes - 1) = 0#64) ∧
      Rel ((s.setReg rd (if signed then (v.truncate w.bits).signExtend 64
        else (v.truncate w.bits).zeroExtend 64)).setPC (pc + 4)) σ' ∧ Q σ' := by
  simp only [loadI, addrOps] at hw
  cases w <;> cases signed <;> simp only [Bool.false_eq_true, ↓reduceIte] at hw <;> rv_ops h hw
  all_goals first
    | (obtain ⟨v, hv, hw⟩ := hw
       obtain ⟨σ', h', hq⟩ := wp_rset h hw
       simp only [Term.wp] at hq
       exact ⟨v, _, by simpa using hv, fun hne => absurd rfl hne,
         (h'.setPC _).cast (by simp [Width.bits, Width.bytes]), hq⟩)
    | (obtain ⟨hg, v, hv, hw⟩ := hw
       obtain ⟨σ', h', hq⟩ := wp_rset h hw
       simp only [Term.wp] at hq
       exact ⟨v, _, by simpa using hv, fun _ => by simpa using hg,
         (h'.setPC _).cast (by simp [Width.bits, Width.bytes]), hq⟩)

/-- What the block of a store establishes: the store succeeds at an aligned address. -/
theorem storeI_sound (h : Rel s σ) {w : Width} {rs1 rs2 : Reg} {offset : BitVec 12}
    (hw : (storeI pc w rs1 rs2 offset).wp σ Q) :
    ∃ m, σ.mem.store (s.getReg rs1 + signExtend12 offset) w (s.getReg rs2) = some m ∧
      (w ≠ .w8 → (s.getReg rs1 + signExtend12 offset) &&& BitVec.ofNat 64 (w.bytes - 1) = 0#64) ∧
      Q ({ σ with mem := m }.setPc (pc + 4)) := by
  simp only [storeI, addrOps] at hw
  cases w <;> rv_ops h hw
  all_goals first
    | (simp only [Term.wp] at hw
       obtain ⟨m, hm, hq⟩ := hw
       exact ⟨m, by simpa using hm, fun hne => absurd rfl hne, hq⟩)
    | (obtain ⟨hg, hw⟩ := hw
       have hw := wp_rget h hw
       simp only [Term.wp, Env.set_apply, Nat.reduceEqDiff, ↓reduceIte] at hw
       obtain ⟨m, hm, hq⟩ := hw
       exact ⟨m, by simpa using hm, fun _ => by simpa using hg, hq⟩)

theorem mod8_of_and {a : Word} (h : a &&& 7#64 = 0#64) : a.toNat % 8 = 0 := by
  have := congrArg BitVec.toNat h
  rw [BitVec.toNat_and] at this
  exact (Nat.and_two_pow_sub_one_eq_mod a.toNat 3).symm.trans this

theorem mod4_of_and {a : Word} (h : a &&& 3#64 = 0#64) : a.toNat % 4 = 0 := by
  have := congrArg BitVec.toNat h
  rw [BitVec.toNat_and] at this
  exact (Nat.and_two_pow_sub_one_eq_mod a.toNat 2).symm.trans this

theorem mod2_of_and {a : Word} (h : a &&& 1#64 = 0#64) : a.toNat % 2 = 0 := by
  have := congrArg BitVec.toNat h
  rw [BitVec.toNat_and] at this
  exact (Nat.and_two_pow_sub_one_eq_mod a.toNat 1).symm.trans this


theorem lower_sound {i : Instr} (h : Rel s σ) (hf : s.code s.pc = some i)
    (hw : (lower s.pc i).wp σ Q) : ∃ s' σ', step s = some s' ∧ Rel s' σ' ∧ Q σ' := by
  cases i
  case ECALL => exact absurd hw (by simp [lower, Block.wp, wpOps, Term.wp])
  case EBREAK => exact absurd hw (by simp [lower, Block.wp, wpOps, Term.wp])
  case CSRS => exact absurd hw (by simp [lower, Block.wp, wpOps, Term.wp])
  case ADD | SUB | AND | OR | XOR | SLT | SLTU | MUL | MULH | MULHSU | MULHU =>
    obtain ⟨σ', h', hq⟩ := binRR_sound h hw
    exact ⟨_, σ', step_plain hf (by simp) (by simp) rfl, h', hq⟩
  case ADDI | ANDI | ORI | XORI | SLTI | SLTIU | SLLI | SRLI | SRAI =>
    obtain ⟨σ', h', hq⟩ := binRI_sound h hw
    exact ⟨_, σ', step_plain hf (by simp) (by simp) rfl,
      h'.cast (by simp [execInstrBr, ofBool]), hq⟩
  case SLL | SRL | SRA =>
    obtain ⟨σ', h', hq⟩ := shiftRR_sound h hw
    exact ⟨_, σ', step_plain hf (by simp) (by simp) rfl,
      h'.cast (by simp [execInstrBr]), hq⟩
  case BEQ | BNE | BLT | BGE | BLTU | BGEU =>
    obtain ⟨σ', h', hq⟩ := branchI_sound h hw
    refine ⟨_, σ', step_plain hf (by simp) (by simp) rfl, h'.cast ?_, hq⟩
    simp only [execInstrBr]
    split <;> simp_all
  case DIV | DIVU | REM | REMU =>
    obtain ⟨σ', h', hq⟩ := divI_sound h hw
    exact ⟨_, σ', step_plain hf (by simp) (by simp) rfl,
      h'.cast (by simp [execInstrBr, rv64_div, rv64_divu, rv64_rem, rv64_remu]), hq⟩
  case LUI | AUIPC | MV | LI | ADDIW | SUBW | SRLW | SLLIW | SRLIW | JAL => rv_reg h hf hw
  case NOP | FENCE =>
    simp only [lower, Block.wp, wpOps, Term.wp] at hw
    exact ⟨_, _, step_plain hf (by simp) (by simp) rfl, (h.setPC _).cast (by simp [execInstrBr]), hw⟩
  case JALR rd rs1 offset =>
    simp only [lower] at hw
    rv_ops h hw
    obtain ⟨σ', h', hq⟩ := wp_rset h hw
    simp only [Term.wp] at hq
    exact ⟨_, _, step_plain hf (by simp) (by simp) rfl,
      (h'.setPC _).cast (by simp [execInstrBr, Env.set]), hq⟩
  case LD rd rs1 offset =>
    obtain ⟨v, σ', hv, ha, h', hq⟩ := loadI_sound h hw
    have ha := ha (by decide)
    obtain ⟨c0, c1, c2, c3, c4, c5, c6, c7, h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ := Mem.load_w64.1 hv
    obtain ⟨hv0, rfl⟩ := h.cell h0
    obtain ⟨_, rfl⟩ := h.cell h1
    obtain ⟨_, rfl⟩ := h.cell h2
    obtain ⟨_, rfl⟩ := h.cell h3
    obtain ⟨_, rfl⟩ := h.cell h4
    obtain ⟨_, rfl⟩ := h.cell h5
    obtain ⟨_, rfl⟩ := h.cell h6
    obtain ⟨_, rfl⟩ := h.cell h7
    have hs : step s = some (execInstrBr s (.LD rd rs1 offset)) := by
      simp only [step, hf, isValidDwordAccess, hv0, isAligned8, mod8_of_and ha]; rfl
    exact ⟨_, σ', hs, h'.cast (by simp [execInstrBr, getMem_bytes s ha, Width.bits, Width.bytes]), hq⟩
  case LW rd rs1 offset =>
    obtain ⟨v, σ', hv, ha, h', hq⟩ := loadI_sound h hw
    have ha := ha (by decide)
    obtain ⟨c0, c1, c2, c3, h0, h1, h2, h3, rfl⟩ := Mem.load_w32.1 hv
    obtain ⟨hv0, rfl⟩ := h.cell h0
    obtain ⟨_, rfl⟩ := h.cell h1
    obtain ⟨_, rfl⟩ := h.cell h2
    obtain ⟨_, rfl⟩ := h.cell h3
    have hs : step s = some (execInstrBr s (.LW rd rs1 offset)) := by
      simp only [step, hf, isValidMemAccess, hv0, isAligned4, mod4_of_and ha]; rfl
    exact ⟨_, σ', hs, h'.cast (by simp [execInstrBr, getWord32_bytes s ha, Width.bits, Width.bytes]), hq⟩
  case LWU rd rs1 offset =>
    obtain ⟨v, σ', hv, ha, h', hq⟩ := loadI_sound h hw
    have ha := ha (by decide)
    obtain ⟨c0, c1, c2, c3, h0, h1, h2, h3, rfl⟩ := Mem.load_w32.1 hv
    obtain ⟨hv0, rfl⟩ := h.cell h0
    obtain ⟨_, rfl⟩ := h.cell h1
    obtain ⟨_, rfl⟩ := h.cell h2
    obtain ⟨_, rfl⟩ := h.cell h3
    have hs : step s = some (execInstrBr s (.LWU rd rs1 offset)) := by
      simp only [step, hf, isValidMemAccess, hv0, isAligned4, mod4_of_and ha]; rfl
    exact ⟨_, σ', hs, h'.cast (by simp [execInstrBr, getWord32_bytes s ha, Width.bits, Width.bytes]), hq⟩
  case LH rd rs1 offset =>
    obtain ⟨v, σ', hv, ha, h', hq⟩ := loadI_sound h hw
    have ha := ha (by decide)
    obtain ⟨c0, c1, h0, h1, rfl⟩ := Mem.load_w16.1 hv
    obtain ⟨hv0, rfl⟩ := h.cell h0
    obtain ⟨_, rfl⟩ := h.cell h1
    have hs : step s = some (execInstrBr s (.LH rd rs1 offset)) := by
      simp only [step, hf, isValidHalfwordAccess, hv0, isAligned2, mod2_of_and ha]; rfl
    exact ⟨_, σ', hs, h'.cast (by simp [execInstrBr, getHalfword_bytes s ha, Width.bits, Width.bytes]), hq⟩
  case LHU rd rs1 offset =>
    obtain ⟨v, σ', hv, ha, h', hq⟩ := loadI_sound h hw
    have ha := ha (by decide)
    obtain ⟨c0, c1, h0, h1, rfl⟩ := Mem.load_w16.1 hv
    obtain ⟨hv0, rfl⟩ := h.cell h0
    obtain ⟨_, rfl⟩ := h.cell h1
    have hs : step s = some (execInstrBr s (.LHU rd rs1 offset)) := by
      simp only [step, hf, isValidHalfwordAccess, hv0, isAligned2, mod2_of_and ha]; rfl
    exact ⟨_, σ', hs, h'.cast (by simp [execInstrBr, getHalfword_bytes s ha, Width.bits, Width.bytes]), hq⟩
  case LB rd rs1 offset =>
    obtain ⟨v, σ', hv, ha, h', hq⟩ := loadI_sound h hw
    clear ha
    obtain ⟨c0, h0, rfl⟩ := Mem.load_w8.1 hv
    obtain ⟨hv0, rfl⟩ := h.cell h0
    have hs : step s = some (execInstrBr s (.LB rd rs1 offset)) := by
      simp only [step, hf, isValidByteAccess, hv0]; rfl
    exact ⟨_, σ', hs, h'.cast (by simp [execInstrBr, Width.bits, Width.bytes]), hq⟩
  case LBU rd rs1 offset =>
    obtain ⟨v, σ', hv, ha, h', hq⟩ := loadI_sound h hw
    clear ha
    obtain ⟨c0, h0, rfl⟩ := Mem.load_w8.1 hv
    obtain ⟨hv0, rfl⟩ := h.cell h0
    have hs : step s = some (execInstrBr s (.LBU rd rs1 offset)) := by
      simp only [step, hf, isValidByteAccess, hv0]; rfl
    exact ⟨_, σ', hs, h'.cast (by simp [execInstrBr, Width.bits, Width.bytes]), hq⟩
  case SD rs1 rs2 offset =>
    obtain ⟨m, hm, ha, hq⟩ := storeI_sound h hw
    have hv0 : isValidMemAddr (s.getReg rs1 + signExtend12 offset) = true := by
      obtain ⟨c, hc, _⟩ := ((Mem.storeN_spec (by decide)).1 hm).1
        (s.getReg rs1 + signExtend12 offset) (by simp [Width.bytes])
      exact (h.cell hc).1
    have ha := ha (by decide)
    have hrel := h.store (n := 8) (s' := s.setMem (s.getReg rs1 + signExtend12 offset) (s.getReg rs2)) (by decide) hm rfl rfl
      (fun x => getByte_setMem s _ x ha)
    have hs : step s = some (execInstrBr s (.SD rs1 rs2 offset)) := by
      simp only [step, hf, isValidDwordAccess, hv0, isAligned8, mod8_of_and ha]; rfl
    exact ⟨_, _, hs, (hrel.setPC _).cast (by simp [execInstrBr]), hq⟩
  case SW rs1 rs2 offset =>
    obtain ⟨m, hm, ha, hq⟩ := storeI_sound h hw
    have hv0 : isValidMemAddr (s.getReg rs1 + signExtend12 offset) = true := by
      obtain ⟨c, hc, _⟩ := ((Mem.storeN_spec (by decide)).1 hm).1
        (s.getReg rs1 + signExtend12 offset) (by simp [Width.bytes])
      exact (h.cell hc).1
    have ha := ha (by decide)
    have hrel := h.store (n := 4) (s' := s.setWord32 (s.getReg rs1 + signExtend12 offset) ((s.getReg rs2).truncate 32)) (by decide) hm rfl rfl
      (fun x => getByte_setWord32 s _ x ha)
    have hs : step s = some (execInstrBr s (.SW rs1 rs2 offset)) := by
      simp only [step, hf, isValidMemAccess, hv0, isAligned4, mod4_of_and ha]; rfl
    exact ⟨_, _, hs, (hrel.setPC _).cast (by simp [execInstrBr]), hq⟩
  case SH rs1 rs2 offset =>
    obtain ⟨m, hm, ha, hq⟩ := storeI_sound h hw
    have hv0 : isValidMemAddr (s.getReg rs1 + signExtend12 offset) = true := by
      obtain ⟨c, hc, _⟩ := ((Mem.storeN_spec (by decide)).1 hm).1
        (s.getReg rs1 + signExtend12 offset) (by simp [Width.bytes])
      exact (h.cell hc).1
    have ha := ha (by decide)
    have hrel := h.store (n := 2) (s' := s.setHalfword (s.getReg rs1 + signExtend12 offset) ((s.getReg rs2).truncate 16)) (by decide) hm rfl rfl
      (fun x => getByte_setHalfword s _ x ha)
    have hs : step s = some (execInstrBr s (.SH rs1 rs2 offset)) := by
      simp only [step, hf, isValidHalfwordAccess, hv0, isAligned2, mod2_of_and ha]; rfl
    exact ⟨_, _, hs, (hrel.setPC _).cast (by simp [execInstrBr]), hq⟩
  case SB rs1 rs2 offset =>
    obtain ⟨m, hm, ha, hq⟩ := storeI_sound h hw
    have hv0 : isValidMemAddr (s.getReg rs1 + signExtend12 offset) = true := by
      obtain ⟨c, hc, _⟩ := ((Mem.storeN_spec (by decide)).1 hm).1
        (s.getReg rs1 + signExtend12 offset) (by simp [Width.bytes])
      exact (h.cell hc).1
    clear ha
    have hrel := h.store (n := 1) (s' := s.setByte (s.getReg rs1 + signExtend12 offset) ((s.getReg rs2).truncate 8)) (by decide) hm rfl rfl
      (fun x => getByte_setByte s _ _ x)
    have hs : step s = some (execInstrBr s (.SB rs1 rs2 offset)) := by
      simp only [step, hf, isValidByteAccess, hv0]; rfl
    exact ⟨_, _, hs, (hrel.setPC _).cast (by simp [execInstrBr]), hq⟩

/-! ## Programs -/

/-- **The RISC-V lowering is sound.** If every run of the lowered code from `σ` reaches `Q`,
then the machine, from a state related to `σ`, runs some number of steps without a trap to a
state related to one satisfying `Q`. -/
theorem lowerCode_sound {code : Word → Option Instr} (hc : s.code = code) (h : Rel s σ)
    (hw : Eventually (lowerCode code) Q σ) :
    ∃ n s' σ', stepN n s = some s' ∧ Rel s' σ' ∧ Q σ' := by
  induction hw generalizing s with
  | done σ hq => exact ⟨0, s, σ, rfl, h, hq⟩
  | step σ R hs _ ih =>
    obtain ⟨b, hb, hwp⟩ := hs
    simp only [lowerCode, Option.map_eq_some_iff] at hb
    obtain ⟨i, hi, rfl⟩ := hb
    rw [h.pc] at hi hwp
    obtain ⟨s₁, σ₁, hstep, h₁, hr⟩ := lower_sound h (hc ▸ hi) hwp
    obtain ⟨n, s', σ', hn, h', hq⟩ := ih σ₁ hr ((code_step hstep).trans hc) h₁
    exact ⟨n + 1, s', σ', by simp [stepN, hstep, hn], h', hq⟩

end Lowering.RiscV
