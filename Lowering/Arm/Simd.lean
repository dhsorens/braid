/-
  Lowering.Arm.Simd

  The vector instructions of the AArch64 lowering are sound. A vector register is two
  `braid` registers, its low and its high half, and each instruction is compared with the
  model half by half.

  ## Main results

  * `Rel.writeVReg`, `wp_vget`, `wp_vset`: reading and writing a vector register
  * `wp_vloadOps`, `wp_vstoreOps`: a load or store of a vector register
  * `sound_ldrSimd`, `sound_strSimd`, `sound_ldpSimd`, `sound_stpSimd`: loads and stores
  * `sound_fmovGprVec`, `sound_fpDataProc1`: moves
  * `sound_simdThreeSame`, `sound_simdImmShift`: operations on lanes, and constants
-/

module

public import Lowering.Arm.Rel
import Std.Tactic.BVDecide

@[expose] public section

namespace Lowering.Arm

open Braid
open Arm64 (Instr RegWidth MemWidth AddrMode SimdMemSize)

variable {s : Arm64.State} {σ : State}

/-! ## Vector registers -/

/-- A 128-bit value is its two halves. -/
theorem halves_append (x : BitVec 128) : x.extractLsb' 64 64 ++ x.truncate 64 = x := by
  bv_decide

theorem truncate_append (lo hi : Word) : (hi ++ lo : BitVec 128).truncate 64 = lo := by
  bv_decide

theorem extract_append (lo hi : Word) : (hi ++ lo : BitVec 128).extractLsb' 64 64 = hi := by
  bv_decide

/-- Writing the two halves of a vector register gives a state related to the machine's. -/
theorem Rel.writeVReg (h : Rel s σ) (k : BitVec 5) (lo hi : Word) :
    Rel (s.writeVReg128 k (hi ++ lo)) ((σ.setReg (vregLo k) lo).setReg (vregHi k) hi) := by
  refine ⟨fun j hj => ?_, ?_, h.n, h.z, h.c, h.v, h.pc, h.status, h.mem, fun j => ?_,
    fun j => ?_⟩
  · have hlt := j.isLt
    have h1 : j.toNat ≠ 64 + 2 * k.toNat := by omega
    have h2 : j.toNat ≠ 65 + 2 * k.toNat := by omega
    simpa only [State.setReg, vregLo, vregHi, h1, h2, ↓reduceIte, Arm64.State.writeVReg128]
      using h.regs j hj
  · simpa only [State.setReg, vregLo, vregHi, ↓reduceIte, Arm64.State.writeVReg128,
      show (31 : Nat) ≠ 64 + 2 * k.toNat by omega, show (31 : Nat) ≠ 65 + 2 * k.toNat by omega]
      using h.sp
  · have h2 : 64 + 2 * j.toNat ≠ 65 + 2 * k.toNat := by omega
    simp only [State.setReg, vregLo, vregHi, h2, ↓reduceIte, Arm64.State.writeVReg128,
      Arm64.VRegFile.read, Arm64.VRegFile.write]
    by_cases hjk : j = k
    · subst hjk; simp only [↓reduceIte, truncate_append]
    · have h1 : 64 + 2 * j.toNat ≠ 64 + 2 * k.toNat := fun e =>
        hjk (BitVec.eq_of_toNat_eq (by omega))
      simpa only [h1, hjk, ↓reduceIte, Arm64.VRegFile.read] using h.vlo j
  · have h2 : 65 + 2 * j.toNat ≠ 64 + 2 * k.toNat := by omega
    simp only [State.setReg, vregLo, vregHi, h2, ↓reduceIte, Arm64.State.writeVReg128,
      Arm64.VRegFile.read, Arm64.VRegFile.write]
    by_cases hjk : j = k
    · subst hjk; simp only [↓reduceIte, extract_append]
    · have h1 : 65 + 2 * j.toNat ≠ 65 + 2 * k.toNat := fun e =>
        hjk (BitVec.eq_of_toNat_eq (by omega))
      simpa only [h1, hjk, ↓reduceIte, Arm64.VRegFile.read] using h.vhi j

/-- Reading a vector register gives the two halves of the machine's value. -/
theorem wp_vget (h : Rel s σ) {d : Var} {k : BitVec 5} {ρ : Env} {Q : Env → State → Prop}
    {rest : List Op} (hw : wpOps (vget d k ++ rest) ρ σ Q) :
    wpOps rest ((ρ.set d ((s.vregs.read k).truncate 64)).set (d + 1)
      ((s.vregs.read k).extractLsb' 64 64)) σ Q := by
  simpa only [vget, List.cons_append, List.nil_append, wpOps, Op.wp, vregLo, vregHi, h.vlo,
    h.vhi] using hw

/-- Writing a vector register gives a state related to the machine's. -/
theorem wp_vset (h : Rel s σ) {k : BitVec 5} {lo hi : Var} {ρ : Env} {Q : Env → State → Prop}
    {rest : List Op} (hw : wpOps (vset k lo hi ++ rest) ρ σ Q) :
    ∃ σ', Rel (s.writeVReg128 k (ρ hi ++ ρ lo)) σ' ∧ wpOps rest ρ σ' Q :=
  ⟨_, h.writeVReg k _ _, hw⟩

theorem wp_vset' (h : Rel s σ) {k : BitVec 5} {lo hi : Var} {ρ : Env} {Q : Env → State → Prop}
    (hw : wpOps (vset k lo hi) ρ σ Q) : ∃ σ', Rel (s.writeVReg128 k (ρ hi ++ ρ lo)) σ' ∧ Q ρ σ' :=
  wp_vset (rest := []) h (by rwa [List.append_nil])

/-! ## Memory, sixteen bytes at a time -/

theorem canRead_16 {m : Arm64.Memory} {a : Word} (h1 : m.canRead a 8 = true)
    (h2 : m.canRead (a + 8#64) 8 = true) : m.canRead a 16 = true := by
  have e : a + 1#64 + 1#64 + 1#64 + 1#64 + 1#64 + 1#64 + 1#64 + 1#64 = a + 8#64 := by bv_omega
  simp only [canRead_succ, Bool.and_eq_true, e] at h1 h2 ⊢
  simp only [h1, h2, and_self]

theorem canWrite_16 {m : Arm64.Memory} {a : Word} (h1 : m.canWrite a 8 = true)
    (h2 : m.canWrite (a + 8#64) 8 = true) : m.canWrite a 16 = true := by
  have e : a + 1#64 + 1#64 + 1#64 + 1#64 + 1#64 + 1#64 + 1#64 + 1#64 = a + 8#64 := by bv_omega
  simp only [canWrite_succ, Bool.and_eq_true, e] at h1 h2 ⊢
  simp only [h1, h2, and_self]

/-- A load of less than sixteen bytes into a vector register is the load of a general
register, with the high half clear. -/
theorem readSimdSized_narrow (m : Arm64.Memory) {sz : SimdMemSize} (hsz : sz ≠ .Q128)
    (a : Word) :
    m.readSimdSized sz a = (0#64 ++ m.readSized (simdMemW sz) false a : BitVec 128) := by
  cases sz <;> simp only [Arm64.Memory.readSimdSized, Arm64.Memory.readSized, simdMemW,
    Bool.false_eq_true, ↓reduceIte, ne_eq, not_true_eq_false] at hsz ⊢
  · generalize m.read8 a = b; bv_decide
  · generalize m.read16 a = b; bv_decide
  · generalize m.read32 a = b; bv_decide
  · generalize m.read64 a = b; bv_decide

/-- A load of sixteen bytes is two loads of eight. -/
theorem readSimdSized_q (m : Arm64.Memory) (a : Word) :
    m.readSimdSized .Q128 a =
      (m.readSized .X64 false (a + 8#64) ++ m.readSized .X64 false a : BitVec 128) := rfl

/-- A store of less than sixteen bytes of a vector register is the store of its low half. -/
theorem writeSimdSized_narrow (m : Arm64.Memory) {sz : SimdMemSize} (hsz : sz ≠ .Q128)
    (a lo hi : Word) :
    m.writeSimdSized sz a (hi ++ lo) = m.writeSized (simdMemW sz) a lo := by
  cases sz <;> simp only [Arm64.Memory.writeSimdSized, Arm64.Memory.writeSized, simdMemW,
    ne_eq, not_true_eq_false] at hsz ⊢
  · congr 1; bv_decide
  · congr 1; bv_decide
  · congr 1; bv_decide
  · congr 1; bv_decide

/-- A store of sixteen bytes is two stores of eight. -/
theorem writeSimdSized_q (m : Arm64.Memory) (a lo hi : Word) :
    m.writeSimdSized .Q128 a (hi ++ lo) =
      (m.writeSized .X64 a lo).writeSized .X64 (a + 8#64) hi := by
  simp only [Arm64.Memory.writeSimdSized, Arm64.Memory.write128, Arm64.Memory.writeSized,
    extract_append]
  congr 2
  bv_decide

theorem simdMemW_bytes {sz : SimdMemSize} (hsz : sz ≠ .Q128) : (simdMemW sz).bytes = sz.bytes := by
  cases sz <;> first | rfl | exact absurd rfl hsz

/-- A load of a vector register: the machine allows the read, and the two halves of its
value are in `d` and `d + 1`. -/
theorem wp_vloadOps (h : Rel s σ) {d a : Nat} {sz : SimdMemSize} {ρ : Env}
    {Q : Env → State → Prop} {rest : List Op} (ha : a < d)
    (hw : wpOps (vloadOps d a sz ++ rest) ρ σ Q) :
    s.mem.canRead (ρ a) sz.bytes = true ∧
      ∃ ρ' : Env, ρ' d = (s.mem.readSimdSized sz (ρ a)).truncate 64 ∧
        ρ' (d + 1) = (s.mem.readSimdSized sz (ρ a)).extractLsb' 64 64 ∧
        (∀ y, y < d → ρ' y = ρ y) ∧ wpOps rest ρ' σ Q := by
  have had : a ≠ d := by omega
  have had2 : a ≠ d + 2 := by omega
  by_cases hsz : sz = .Q128
  · subst hsz
    simp only [vloadOps, List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply, had,
      had2, ↓reduceIte, BinOp.eval_add] at hw
    obtain ⟨v₁, hv₁, v₂, hv₂, hw⟩ := hw
    obtain ⟨hcr₁, rfl⟩ := h.load (sz := .X64) hv₁
    obtain ⟨hcr₂, rfl⟩ := h.load (sz := .X64) hv₂
    refine ⟨canRead_16 hcr₁ hcr₂, _, ?_, ?_, fun y hy => ?_, hw⟩
    · simp [readSimdSized_q, truncate_append]
    · simp [readSimdSized_q, extract_append]
    · env_below hy
  · have hw' : ∃ v, σ.mem.load (ρ a) (memW (simdMemW sz)) = some v ∧
        wpOps rest ((ρ.set d v).set (d + 1) 0#64) σ Q := by
      cases sz <;> first | exact absurd rfl hsz | exact hw
    obtain ⟨v, hv, hw⟩ := hw'
    obtain ⟨hcr, rfl⟩ := h.load hv
    rw [simdMemW_bytes hsz] at hcr
    refine ⟨hcr, _, ?_, ?_, fun y hy => ?_, hw⟩
    · simp [readSimdSized_narrow _ hsz, truncate_append]
    · simp [readSimdSized_narrow _ hsz, extract_append]
    · env_below hy

/-- A store of a vector register: the machine allows the write, its memory follows, and it
keeps the bytes that may not be stored to. -/
theorem wp_vstoreOps (h : Rel s σ) {a lo hi t : Nat} {sz : SimdMemSize} {ρ : Env}
    {Q : Env → State → Prop} {rest : List Op} (ha : a < t) (hhi : hi < t)
    (hw : wpOps (vstoreOps a lo hi t sz ++ rest) ρ σ Q) :
    s.mem.canWrite (ρ a) sz.bytes = true ∧
      KeepsCode s.mem (s.mem.writeSimdSized sz (ρ a) (ρ hi ++ ρ lo)) ∧
      ∃ (ρ' : Env) (σ' : State),
        Rel (s.setMem (s.mem.writeSimdSized sz (ρ a) (ρ hi ++ ρ lo))) σ' ∧
        (∀ y, y < t → ρ' y = ρ y) ∧ wpOps rest ρ' σ' Q := by
  have hat : a ≠ t := by omega
  have hhit : hi ≠ t := by omega
  have hhit1 : hi ≠ t + 1 := by omega
  by_cases hsz : sz = .Q128
  · subst hsz
    simp only [vstoreOps, List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply, hat,
      hhit, hhit1, ↓reduceIte, BinOp.eval_add] at hw
    obtain ⟨m₁, hm₁, m₂, hm₂, hw⟩ := hw
    obtain ⟨hcw₁, h₁⟩ := h.store (sz := .X64) hm₁
    have hk₁ := h.store_keeps (sz := .X64) hm₁
    obtain ⟨hcw₂, h₂⟩ := h₁.store (sz := .X64) hm₂
    have hk₂ := h₁.store_keeps (sz := .X64) hm₂
    simp only [Arm64.State.setMem, canWrite_writeSized] at hcw₂ hk₂
    rw [writeSimdSized_q]
    exact ⟨canWrite_16 hcw₁ hcw₂, hk₁.trans hk₂, _, _, h₂, fun y hy => by env_below hy, hw⟩
  · have hw' : ∃ m, σ.mem.store (ρ a) (memW (simdMemW sz)) (ρ lo) = some m ∧
        wpOps rest ρ { σ with mem := m } Q := by
      cases sz <;> first | exact absurd rfl hsz | exact hw
    obtain ⟨m, hm, hw⟩ := hw'
    obtain ⟨hcw, h₁⟩ := h.store hm
    have hk := h.store_keeps hm
    rw [simdMemW_bytes hsz] at hcw
    rw [writeSimdSized_narrow _ hsz]
    exact ⟨hcw, hk, _, _, h₁, fun _ _ => rfl, hw⟩

variable {Q : State → Prop}

/-! ## Loads and stores -/

theorem evalInst_ldrSimd (prog : Arm64.Program) (sz : SimdMemSize) (vt : BitVec 5)
    {addr : AddrMode} (hsp : Arm64.checkAddrSPAligned s addr = true)
    (hcr : s.mem.canRead (Arm64.evalAddrMode s addr).1 sz.bytes = true) :
    prog.evalInst (.ldrSimd sz vt addr) s =
      ((wbState s addr).writeVReg128 vt
        (s.mem.readSimdSized sz (Arm64.evalAddrMode s addr).1)).setPC (s.pc + 4) := by
  simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, hsp, wbState]
  generalize Arm64.evalAddrMode s addr = e at hcr ⊢
  obtain ⟨ea, wb⟩ := e
  simp only at hcr
  simp only [hcr]
  cases wb <;> rfl

/-- A load of a vector register is sound. -/
theorem sound_ldrSimd (prog : Arm64.Program) {sz : SimdMemSize} {vt : BitVec 5}
    {addr : AddrMode} (h : Rel s σ) (hw : (lowerLdrSimd s.pc sz vt addr).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.ldrSimd sz vt addr) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.ldrSimd sz vt addr) s).mem := by
  simp only [lowerLdrSimd, Block.wp, List.append_assoc] at hw
  obtain ⟨hsp, ρ₁, σ₁, h₁, hw⟩ := wp_addrOps h hw
  obtain ⟨hcr, ρ₂, hlo, hhi, -, hw⟩ := wp_vloadOps h₁ (by decide) hw
  obtain ⟨σ₂, h₂, hw⟩ := wp_vset' h₁ hw
  simp only [Term.wp] at hw
  simp only [envExt_self, wbState_mem, Nat.reduceAdd] at hcr hlo hhi
  rw [hlo, hhi, halves_append] at h₂
  exact step_done (h₂.setPC _) hw (evalInst_ldrSimd prog sz vt hsp hcr)
    (wbState_mem s addr ▸ KeepsCode.refl _)

theorem evalInst_strSimd (prog : Arm64.Program) (sz : SimdMemSize) (vt : BitVec 5)
    {addr : AddrMode} (hsp : Arm64.checkAddrSPAligned s addr = true)
    (hcw : s.mem.canWrite (Arm64.evalAddrMode s addr).1 sz.bytes = true) :
    prog.evalInst (.strSimd sz vt addr) s =
      ((wbState s addr).setMem (s.mem.writeSimdSized sz (Arm64.evalAddrMode s addr).1
        (s.vregs.read vt))).setPC (s.pc + 4) := by
  simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, hsp, wbState]
  generalize Arm64.evalAddrMode s addr = e at hcw ⊢
  obtain ⟨ea, wb⟩ := e
  simp only at hcw
  simp only [hcw]
  cases wb <;> rfl

/-- A store of a vector register is sound. -/
theorem sound_strSimd (prog : Arm64.Program) {sz : SimdMemSize} {vt : BitVec 5}
    {addr : AddrMode} (h : Rel s σ) (hw : (lowerStrSimd s.pc sz vt addr).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.strSimd sz vt addr) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.strSimd sz vt addr) s).mem := by
  simp only [lowerStrSimd, Block.wp, List.append_assoc] at hw
  have hw := wp_vget h hw
  obtain ⟨hsp, ρ₁, σ₁, h₁, hw⟩ := wp_addrOps h hw
  obtain ⟨hcw, hk, ρ₂, σ₂, h₂, -, hw⟩ :=
    wp_vstoreOps (rest := []) h₁ (a := 2) (hi := 1) (t := 30) (by decide) (by decide)
      (by rwa [List.append_nil])
  simp only [wpOps, Term.wp] at hw
  env_simp_at hcw
  env_simp_at hk
  env_simp_at h₂
  simp only [Nat.reduceAdd, wbState_mem, halves_append] at hcw hk h₂
  exact step_done (h₂.setPC _) hw (evalInst_strSimd prog sz vt hsp hcw) hk

theorem evalInst_ldpSimd (prog : Arm64.Program) (sz : SimdMemSize) (vt1 vt2 : BitVec 5)
    {addr : AddrMode} (hsp : Arm64.checkAddrSPAligned s addr = true)
    (hcr1 : s.mem.canRead (Arm64.evalAddrMode s addr).1 sz.bytes = true)
    (hcr2 : s.mem.canRead ((Arm64.evalAddrMode s addr).1 + simdBytes sz) sz.bytes = true) :
    prog.evalInst (.ldpSimd sz vt1 vt2 addr) s =
      (((wbState s addr).writeVReg128 vt1
          (s.mem.readSimdSized sz (Arm64.evalAddrMode s addr).1)).writeVReg128 vt2
        (s.mem.readSimdSized sz ((Arm64.evalAddrMode s addr).1 + simdBytes sz))).setPC
        (s.pc + 4) := by
  simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, hsp, wbState]
  generalize Arm64.evalAddrMode s addr = e at hcr1 hcr2 ⊢
  obtain ⟨ea, wb⟩ := e
  cases sz <;> simp only [simdBytes] at hcr1 hcr2 ⊢ <;> simp only [hcr1, hcr2] <;>
    cases wb <;> rfl

/-- A load of a pair of vector registers is sound. -/
theorem sound_ldpSimd (prog : Arm64.Program) {sz : SimdMemSize} {vt1 vt2 : BitVec 5}
    {addr : AddrMode} (h : Rel s σ) (hw : (lowerLdpSimd s.pc sz vt1 vt2 addr).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.ldpSimd sz vt1 vt2 addr) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.ldpSimd sz vt1 vt2 addr) s).mem := by
  simp only [lowerLdpSimd, Block.wp, List.append_assoc] at hw
  obtain ⟨hsp, ρ₁, σ₁, h₁, hw⟩ := wp_addrOps h hw
  simp only [List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply, envExt_self,
    Nat.reduceEqDiff, ↓reduceIte, BinOp.eval_add] at hw
  obtain ⟨hcr1, ρ₂, hlo1, hhi1, hlt2, hw⟩ := wp_vloadOps h₁ (by decide) hw
  obtain ⟨hcr2, ρ₃, hlo2, hhi2, hlt3, hw⟩ := wp_vloadOps h₁ (by decide) hw
  obtain ⟨σ₂, h₂, hw⟩ := wp_vset h₁ hw
  obtain ⟨σ₃, h₃, hw⟩ := wp_vset' h₂ hw
  simp only [Term.wp] at hw
  rw [hlt2 22 (by decide)] at hcr2 hlo2 hhi2
  env_simp_at hcr1
  env_simp_at hcr2
  env_simp_at hlo1
  env_simp_at hhi1
  env_simp_at hlo2
  env_simp_at hhi2
  simp only [Nat.reduceAdd, wbState_mem] at hcr1 hcr2 hlo1 hhi1 hlo2 hhi2
  rw [hlt3 23 (by decide), hlt3 24 (by decide), hlo1, hhi1, hlo2, hhi2, halves_append,
    halves_append] at h₃
  exact step_done (h₃.setPC _) hw (evalInst_ldpSimd prog sz vt1 vt2 hsp hcr1 hcr2)
    (wbState_mem s addr ▸ KeepsCode.refl _)

theorem evalInst_stpSimd (prog : Arm64.Program) (sz : SimdMemSize) (vt1 vt2 : BitVec 5)
    {addr : AddrMode} (hsp : Arm64.checkAddrSPAligned s addr = true)
    (hcw1 : s.mem.canWrite (Arm64.evalAddrMode s addr).1 sz.bytes = true)
    (hcw2 : s.mem.canWrite ((Arm64.evalAddrMode s addr).1 + simdBytes sz) sz.bytes = true) :
    prog.evalInst (.stpSimd sz vt1 vt2 addr) s =
      ((wbState s addr).setMem
        ((s.mem.writeSimdSized sz (Arm64.evalAddrMode s addr).1
          (s.vregs.read vt1)).writeSimdSized sz ((Arm64.evalAddrMode s addr).1 + simdBytes sz)
          (s.vregs.read vt2))).setPC (s.pc + 4) := by
  simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, hsp, wbState]
  generalize Arm64.evalAddrMode s addr = e at hcw1 hcw2 ⊢
  obtain ⟨ea, wb⟩ := e
  cases sz <;> simp only [simdBytes] at hcw1 hcw2 ⊢ <;> simp only [hcw1, hcw2] <;>
    cases wb <;> rfl

theorem canWrite_writeSimdSized (m : Arm64.Memory) (sz : SimdMemSize) (a : Word)
    (v : BitVec 128) (x : Word) (n : Nat) :
    (m.writeSimdSized sz a v).canWrite x n = m.canWrite x n := by
  rw [← halves_append v]
  by_cases hsz : sz = .Q128
  · subst hsz; simp only [writeSimdSized_q, canWrite_writeSized]
  · simp only [writeSimdSized_narrow _ hsz, canWrite_writeSized]

/-- A store of a pair of vector registers is sound. -/
theorem sound_stpSimd (prog : Arm64.Program) {sz : SimdMemSize} {vt1 vt2 : BitVec 5}
    {addr : AddrMode} (h : Rel s σ) (hw : (lowerStpSimd s.pc sz vt1 vt2 addr).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.stpSimd sz vt1 vt2 addr) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.stpSimd sz vt1 vt2 addr) s).mem := by
  simp only [lowerStpSimd, Block.wp, List.append_assoc] at hw
  have hw := wp_vget h hw
  have hw := wp_vget h hw
  obtain ⟨hsp, ρ₁, σ₁, h₁, hw⟩ := wp_addrOps h hw
  simp only [List.cons_append, List.nil_append, wpOps, Op.wp, Env.set_apply, envExt_self,
    Nat.reduceEqDiff, ↓reduceIte, BinOp.eval_add] at hw
  obtain ⟨hcw1, hk1, ρ₂, σ₂, h₂, hlt2, hw⟩ :=
    wp_vstoreOps h₁ (a := 4) (hi := 1) (t := 32) (by decide) (by decide) hw
  obtain ⟨hcw2, hk2, ρ₃, σ₃, h₃, -, hw⟩ :=
    wp_vstoreOps (rest := []) h₂ (a := 31) (hi := 3) (t := 34) (by decide) (by decide)
      (by rwa [List.append_nil])
  simp only [wpOps, Term.wp] at hw
  simp only [hlt2 31 (by decide), hlt2 2 (by decide), hlt2 3 (by decide)] at hcw2 hk2 h₃
  env_simp_at hcw1
  env_simp_at hk1
  env_simp_at hcw2
  env_simp_at hk2
  env_simp_at h₃
  simp only [Nat.reduceAdd, wbState_mem, halves_append, Arm64.State.setMem,
    canWrite_writeSimdSized] at hcw1 hk1 hcw2 hk2 h₃
  exact step_done (h₃.setPC _) hw (evalInst_stpSimd prog sz vt1 vt2 hsp hcw1 hcw2)
    (hk1.trans hk2)

/-! ## Moves -/

/-- Two states that write equal values to a vector register and go to the next
instruction. -/
theorem wv_eq (rd : BitVec 5) {a b : BitVec 128} (hab : a = b) :
    (s.writeVReg128 rd a).advancePC = (s.writeVReg128 rd b).setPC (s.pc + 4) :=
  hab ▸ rfl

theorem setReg_self (σ : State) (r : Reg) : σ.setReg r (σ.regs r) = σ := by
  obtain ⟨regs, flags, mem, pc⟩ := σ
  simp only [State.setReg, State.mk.injEq, and_true]
  funext r'
  split
  · rename_i e; rw [e]
  · rfl

/-- Writing the high half of a vector register keeps its low half. -/
theorem Rel.writeVRegHi (h : Rel s σ) (k : BitVec 5) (hi : Word) :
    Rel (s.writeVReg128 k (hi ++ (s.vregs.read k).truncate 64)) (σ.setReg (vregHi k) hi) := by
  have := h.writeVReg k (σ.regs (vregLo k)) hi
  rwa [setReg_self, vregLo, h.vlo] at this

variable (prog : Arm64.Program) (rm rn rd : BitVec 5)

theorem evalInst_fmov_w (s : Arm64.State) :
    prog.evalInst (.fmovGprVec false 0#2 0#2 6#3 rn rd) s =
      (s.writeReg64 (Arm64.Reg.fromZRBits rd)
        (((s.vregs.read rn).truncate 32).zeroExtend 64)).advancePC := rfl

theorem evalInst_fmov_x (s : Arm64.State) :
    prog.evalInst (.fmovGprVec true 1#2 0#2 6#3 rn rd) s =
      (s.writeReg64 (Arm64.Reg.fromZRBits rd) ((s.vregs.read rn).truncate 64)).advancePC := rfl

theorem evalInst_fmov_x_hi (s : Arm64.State) :
    prog.evalInst (.fmovGprVec true 2#2 1#2 6#3 rn rd) s =
      (s.writeReg64 (Arm64.Reg.fromZRBits rd)
        ((s.vregs.read rn).extractLsb' 64 64)).advancePC := rfl

theorem evalInst_fmov_s (s : Arm64.State) :
    prog.evalInst (.fmovGprVec false 0#2 0#2 7#3 rn rd) s =
      (s.writeVReg128 rd (((s.readReg64 (Arm64.Reg.fromZRBits rn)).truncate 32).zeroExtend
        128)).advancePC := rfl

theorem evalInst_fmov_d (s : Arm64.State) :
    prog.evalInst (.fmovGprVec true 1#2 0#2 7#3 rn rd) s =
      (s.writeVReg128 rd ((s.readReg64 (Arm64.Reg.fromZRBits rn)).zeroExtend 128)).advancePC :=
  rfl

theorem evalInst_fmov_d_hi (s : Arm64.State) :
    prog.evalInst (.fmovGprVec true 2#2 1#2 7#3 rn rd) s =
      (s.writeVReg128 rd (s.readReg64 (Arm64.Reg.fromZRBits rn) ++
        (s.vregs.read rd).truncate 64)).advancePC := rfl

/-- Run the operations of a block of moves. -/
macro "vec_ops" h:ident hw:ident : tactic => `(tactic|
  (simp only [Block.wp, List.cons_append, List.nil_append, List.append_assoc, wpOps] at $hw:ident
   repeat (first
     | with_reducible have $hw:ident := wp_rget $h $hw
     | with_reducible have $hw:ident := wp_vget $h $hw
     | simp only [Op.wp, wpOps, Env.set_apply, Nat.reduceEqDiff, Nat.reduceAdd, ↓reduceIte,
         List.cons_append, List.nil_append, vregLo, vregHi, Rel.vlo $h, Rel.vhi $h]
         at $hw:ident)))

/-- A move between a general register and a vector register is sound. -/
theorem sound_fmovGprVec {sf : Bool} {ftype rmode : BitVec 2} {opcode : BitVec 3}
    (h : Rel s σ) (hw : (lower s.pc (.fmovGprVec sf ftype rmode opcode rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.fmovGprVec sf ftype rmode opcode rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.fmovGprVec sf ftype rmode opcode rn rd) s).mem := by
  simp only [lower] at hw
  generalize hops : fmovOps sf ftype rmode opcode rn rd = o at hw
  cases o with
  | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
  | some ops =>
    simp only [fmovOps] at hops
    split at hops
    · rename_i ho
      subst ho
      split at hops
      · rename_i hc
        obtain ⟨rfl, rfl, rfl⟩ := hc
        cases hops
        vec_ops h hw
        obtain ⟨σ', h', hw⟩ := wp_rset' h hw
        simp only [Term.wp] at hw
        refine step_done (h'.setPC _) hw ((evalInst_fmov_w prog rn rd s).trans (wr_eq _ ?_))
        env_simp
        simp only [UnOp.eval_zext]
        generalize s.vregs.read rn = x
        bv_decide
      · split at hops
        · rename_i hc
          obtain ⟨rfl, rfl, rfl⟩ := hc
          cases hops
          vec_ops h hw
          obtain ⟨σ', h', hw⟩ := wp_rset' h hw
          simp only [Term.wp] at hw
          refine step_done (h'.setPC _) hw ((evalInst_fmov_x prog rn rd s).trans (wr_eq _ ?_))
          env_simp
        · split at hops
          · rename_i hc
            obtain ⟨rfl, rfl, rfl⟩ := hc
            cases hops
            vec_ops h hw
            obtain ⟨σ', h', hw⟩ := wp_rset' h hw
            simp only [Term.wp] at hw
            refine step_done (h'.setPC _) hw
              ((evalInst_fmov_x_hi prog rn rd s).trans (wr_eq _ ?_))
            env_simp
          · cases hops
    · split at hops
      · rename_i ho
        subst ho
        split at hops
        · rename_i hc
          obtain ⟨rfl, rfl, rfl⟩ := hc
          cases hops
          vec_ops h hw
          obtain ⟨σ', h', hw⟩ := wp_vset' h hw
          simp only [Term.wp] at hw
          refine step_done (h'.setPC _) hw ((evalInst_fmov_s prog rn rd s).trans (wv_eq _ ?_))
          env_simp
          simp only [UnOp.eval_zext]
          generalize s.readReg64 _ = x
          bv_decide
        · split at hops
          · rename_i hc
            obtain ⟨rfl, rfl, rfl⟩ := hc
            cases hops
            vec_ops h hw
            obtain ⟨σ', h', hw⟩ := wp_vset' h hw
            simp only [Term.wp] at hw
            refine step_done (h'.setPC _) hw
              ((evalInst_fmov_d prog rn rd s).trans (wv_eq _ ?_))
            env_simp
            generalize s.readReg64 _ = x
            bv_decide
          · split at hops
            · rename_i hc
              obtain ⟨rfl, rfl, rfl⟩ := hc
              cases hops
              vec_ops h hw
              simp only [Term.wp] at hw
              exact step_done ((h.writeVRegHi rd _).setPC _) hw
                (evalInst_fmov_d_hi prog rn rd s)
            · cases hops
      · cases hops

theorem evalInst_fpmov_s (s : Arm64.State) :
    prog.evalInst (.fpDataProc1 0#2 0#6 rn rd) s =
      (s.writeVReg128 rd (((s.vregs.read rn).truncate 32).zeroExtend 128)).advancePC := rfl

theorem evalInst_fpmov_d (s : Arm64.State) :
    prog.evalInst (.fpDataProc1 1#2 0#6 rn rd) s =
      (s.writeVReg128 rd (((s.vregs.read rn).truncate 64).zeroExtend 128)).advancePC := rfl

/-- A move of the low bits of a vector register into another is sound. -/
theorem sound_fpDataProc1 {ftype : BitVec 2} {opcode : BitVec 6}
    (h : Rel s σ) (hw : (lower s.pc (.fpDataProc1 ftype opcode rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.fpDataProc1 ftype opcode rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.fpDataProc1 ftype opcode rn rd) s).mem := by
  simp only [lower] at hw
  generalize hops : fpMovOps ftype opcode rn rd = o at hw
  cases o with
  | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
  | some ops =>
    simp only [fpMovOps] at hops
    split at hops
    · rename_i ho
      subst ho
      split at hops
      · rename_i hc
        subst hc
        cases hops
        vec_ops h hw
        obtain ⟨σ', h', hw⟩ := wp_vset' h hw
        simp only [Term.wp] at hw
        refine step_done (h'.setPC _) hw ((evalInst_fpmov_s prog rn rd s).trans (wv_eq _ ?_))
        env_simp
        simp only [UnOp.eval_zext]
        generalize s.vregs.read rn = x
        bv_decide
      · split at hops
        · rename_i hc
          subst hc
          cases hops
          vec_ops h hw
          obtain ⟨σ', h', hw⟩ := wp_vset' h hw
          simp only [Term.wp] at hw
          refine step_done (h'.setPC _) hw ((evalInst_fpmov_d prog rn rd s).trans (wv_eq _ ?_))
          env_simp
          generalize s.vregs.read rn = x
          bv_decide
        · cases hops
    · cases hops

/-! ## Constants -/

theorem movi_halves (q : Bool) (d : Word) :
    (if q = true then d ++ d else BitVec.setWidth 128 d) = (if q = true then d else 0#64) ++ d := by
  cases q
  · simp only [Bool.false_eq_true, ↓reduceIte]; bv_decide
  · rfl

theorem evalInst_movi {q op : Bool} {immb : BitVec 3} {opc : BitVec 5} {d64 : Word}
    (h0 : opc.getLsbD 0 = false)
    (hm : moviImm op (opc.extractLsb' 1 4) (immb ++ rn) = some d64) (s : Arm64.State) :
    prog.evalInst (.simdImmShift q op 0#4 immb opc rn rd) s =
      (s.writeVReg128 rd ((if q then d64 else 0#64) ++ d64)).advancePC := by
  simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, beq_self_eq_true, ↓reduceIte, h0,
    Bool.false_eq_true]
  generalize opc.extractLsb' 1 4 = cmode at hm ⊢
  generalize immb ++ rn = imm8 at hm ⊢
  rw [← movi_halves]
  simp only [moviImm] at hm
  split at hm
  · rename_i hc; obtain ⟨rfl, rfl⟩ := hc; cases hm
    simp
  · rename_i hc1
    split at hm
    · rename_i hc; obtain ⟨rfl, rfl⟩ := hc; cases hm
      simp
    · rename_i hc2
      split at hm
      · rename_i hc; obtain ⟨rfl, hcm⟩ := hc; cases hm
        simp_all
      · rename_i hc3
        split at hm
        · rename_i hc; obtain ⟨rfl, hcm⟩ := hc; cases hm
          simp_all
        · cases hm

/-- A `MOVI` of a constant is sound. -/
theorem sound_simdImmShift {q op : Bool} {immh : BitVec 4} {immb : BitVec 3} {opc : BitVec 5}
    (h : Rel s σ) (hw : (lower s.pc (.simdImmShift q op immh immb opc rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.simdImmShift q op immh immb opc rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.simdImmShift q op immh immb opc rn rd) s).mem := by
  simp only [lower] at hw
  generalize hops : (if immh = 0#4 ∧ opc.getLsbD 0 = false then
    moviImm op (opc.extractLsb' 1 4) (immb ++ rn) else none) = o at hw
  cases o with
  | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
  | some d64 =>
    split at hops
    · rename_i hc
      obtain ⟨rfl, h0⟩ := hc
      vec_ops h hw
      obtain ⟨σ', h', hw⟩ := wp_vset' h hw
      simp only [Term.wp] at hw
      refine step_done (h'.setPC _) hw ?_
      env_simp
      exact evalInst_movi prog rn rd h0 hops s
    · cases hops

/-! ## Operations on lanes -/

theorem bv2_cases (x : BitVec 2) : x = 0#2 ∨ x = 1#2 ∨ x = 2#2 ∨ x = 3#2 := by bv_decide

/-- The model's operation on lanes, as a fold over the lanes. -/
theorem zipSimdLanes_eq (q : Bool) (esize : Nat) (vn vm : BitVec 128)
    (f : BitVec 128 → BitVec 128 → BitVec 128) :
    Arm64.zipSimdLanes q esize vn vm f =
      (List.range' 0 ((if q then 128 else 64) / esize)).foldl (fun acc i =>
        acc ||| ((f ((vn >>> (i * esize)) &&& ((1#128 <<< esize) - 1#128))
          ((vm >>> (i * esize)) &&& ((1#128 <<< esize) - 1#128))) &&&
            ((1#128 <<< esize) - 1#128)) <<< (i * esize)) 0#128 := by
  simp [Arm64.zipSimdLanes, Std.Legacy.Range.forIn_eq_forIn_range', Std.Legacy.Range.size]

/-- The value of an operation on two vector registers: the operation on each half, or on the
low half only, with the high half clear. -/
def vecRes (op : VecOp) (q : Bool) (vn vm vd : BitVec 128) : BitVec 128 :=
  (if q then op.eval (vn.extractLsb' 64 64) (vm.extractLsb' 64 64) (vd.extractLsb' 64 64)
    else 0#64) ++ op.eval (vn.truncate 64) (vm.truncate 64) (vd.truncate 64)

/-- The model's addition or subtraction of lanes is `BinOp.lanes` on each half. -/
theorem zipSimdLanes_addsub (q u : Bool) (size : BitVec 2) (vn vm vd : BitVec 128) :
    Arm64.zipSimdLanes q (8 <<< size.toNat) vn vm (fun a b => if u then a - b else a + b) =
      vecRes (if u then .sub (8 <<< size.toNat) else .add (8 <<< size.toNat)) q vn vm vd := by
  rw [zipSimdLanes_eq]
  rcases bv2_cases size with rfl | rfl | rfl | rfl <;> cases q <;> cases u <;>
    simp only [vecRes, VecOp.eval, BinOp.eval_lanes, ↓reduceIte, Nat.reduceDiv, List.range, List.range.loop,
      List.range', List.foldl, BinOp.eval_add, BinOp.eval_sub, Nat.reduceMul, Nat.reduceAdd,
      BitVec.toNat_ofNat, Nat.reduceMod, Nat.reduceShiftLeft, Bool.false_eq_true, Nat.reducePow] <;>
    bv_decide

theorem evalInst_logic (q u : Bool) (size : BitVec 2) (s : Arm64.State) {op : VecOp}
    (hop : vecOp q u size 3#5 = some op) :
    prog.evalInst (.simdThreeSame q u size rm 3#5 rn rd) s =
      (s.writeVReg128 rd (vecRes op q (s.vregs.read rn) (s.vregs.read rm)
        (s.vregs.read rd))).advancePC := by
  rcases bv2_cases size with rfl | rfl | rfl | rfl <;> cases u <;>
    simp only [vecOp, ↓reduceIte, BitVec.reduceEq, Option.some.injEq,
      reduceCtorEq] at hop <;> subst hop <;>
    refine (rfl : prog.evalInst _ s = (s.writeVReg128 rd _).advancePC).trans
      (congrArg (fun v => (s.writeVReg128 rd v).advancePC) ?_) <;>
    cases q <;> simp only [vecRes, VecOp.eval, Arm64.State.readVReg128, ↓reduceIte, Bool.false_eq_true] <;>
    generalize s.vregs.read rn = a <;> generalize s.vregs.read rm = b <;>
    generalize s.vregs.read rd = c <;> bv_decide

theorem evalInst_addsub (q u : Bool) (size : BitVec 2) (s : Arm64.State)
    (hq : ¬(size = 3#2 ∧ q = false)) :
    prog.evalInst (.simdThreeSame q u size rm 16#5 rn rd) s =
      (s.writeVReg128 rd (Arm64.zipSimdLanes q (8 <<< size.toNat) (s.vregs.read rn)
        (s.vregs.read rm) (fun a b => if u then a - b else a + b))).advancePC := by
  have hq' : (size == 3#2 && !q) = false := by
    cases q <;> simp_all
  simp only [Arm64.Program.evalInst, Arm64.execInstWithSvc, hq']
  rfl


/-- The operations on two vector registers leave the value of the operation in the
destination. -/
theorem wp_vecOps {op : VecOp} {q : Bool} (h : Rel s σ)
    (hw : (⟨vecOps op q rm rn rd, .jump (s.pc + 4)⟩ : Block).wp σ Q) :
    ∃ σ', Rel ((s.writeVReg128 rd (vecRes op q (s.vregs.read rn) (s.vregs.read rm)
      (s.vregs.read rd))).setPC (s.pc + 4)) σ' ∧ Q σ' := by
  cases op <;> cases q <;>
    simp only [vecOps, VecOp.ops, reduceCtorEq, ↓reduceIte, Bool.false_eq_true] at hw <;>
    vec_ops h hw <;>
    obtain ⟨σ', h', hw⟩ := wp_vset' h hw <;>
    simp only [Term.wp] at hw <;>
    refine ⟨_, (h'.setPC (s.pc + 4)).cast ?_, hw⟩ <;>
    env_simp <;>
    simp only [vecRes, VecOp.eval, BinOp.eval_and, BinOp.eval_or, BinOp.eval_xor, UnOp.eval_not,
      ↓reduceIte, Bool.false_eq_true]

/-- A bitwise operation, or an addition or subtraction of lanes, of two vector registers is
sound. -/
theorem sound_simdThreeSame {q u : Bool} {size : BitVec 2} {opcode : BitVec 5}
    (h : Rel s σ) (hw : (lower s.pc (.simdThreeSame q u size rm opcode rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.simdThreeSame q u size rm opcode rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.simdThreeSame q u size rm opcode rn rd) s).mem := by
  simp only [lower] at hw
  generalize hop : vecOp q u size opcode = o at hw
  cases o with
  | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
  | some op =>
    obtain ⟨σ', h', hq⟩ := wp_vecOps rm rn rd h hw
    refine step_done h' hq ?_
    by_cases h3 : opcode = 3#5
    · subst h3
      exact evalInst_logic prog rm rn rd q u size s hop
    · simp only [vecOp, h3, ↓reduceIte] at hop
      split at hop
      · cases hop
      · rename_i hq
        split at hop
        · rename_i h16
          subst h16
          cases hop
          rw [evalInst_addsub prog rm rn rd q u size s hq,
            zipSimdLanes_addsub q u size _ _ (s.vregs.read rd)]
          rfl
        · cases hop

/-! ## Non-temporal pairs, constants, selects, `NOT` and `ADDP` -/

theorem evalInst_ldnpSimd (sz : SimdMemSize) (rn : Arm64.Reg) (offset : Word) (s : Arm64.State) :
    prog.evalInst (.ldnpSimd sz rm rd rn offset) s =
      prog.evalInst (.ldpSimd sz rm rd (.Offset rn offset)) s := by
  cases sz <;> rfl

theorem evalInst_stnpSimd (sz : SimdMemSize) (rn : Arm64.Reg) (offset : Word) (s : Arm64.State) :
    prog.evalInst (.stnpSimd sz rm rd rn offset) s =
      prog.evalInst (.stpSimd sz rm rd (.Offset rn offset)) s := by
  cases sz <;> rfl

theorem evalInst_fpImm_s (imm8 : BitVec 8) (s : Arm64.State) :
    prog.evalInst (.fpImm 0#2 imm8 rd) s =
      (s.writeVReg128 rd ((Arm64.vfpExpandImm32 imm8).zeroExtend 128)).advancePC := rfl

theorem evalInst_fpImm_d (imm8 : BitVec 8) (s : Arm64.State) :
    prog.evalInst (.fpImm 1#2 imm8 rd) s =
      (s.writeVReg128 rd ((Arm64.vfpExpandImm64 imm8).zeroExtend 128)).advancePC := rfl

/-- An `FMOV` of a floating-point constant is sound. -/
theorem sound_fpImm {ftype : BitVec 2} {imm8 : BitVec 8}
    (h : Rel s σ) (hw : (lower s.pc (.fpImm ftype imm8 rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.fpImm ftype imm8 rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.fpImm ftype imm8 rd) s).mem := by
  simp only [lower] at hw
  generalize hops : fpImmOps ftype imm8 rd = o at hw
  cases o with
  | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
  | some ops =>
    simp only [fpImmOps] at hops
    split at hops
    · rename_i hc
      subst hc
      cases hops
      vec_ops h hw
      obtain ⟨σ', h', hw⟩ := wp_vset' h hw
      simp only [Term.wp] at hw
      refine step_done (h'.setPC _) hw ((evalInst_fpImm_s prog rd imm8 s).trans (wv_eq _ ?_))
      env_simp
      generalize Arm64.vfpExpandImm32 imm8 = x
      bv_decide
    · split at hops
      · rename_i hc
        subst hc
        cases hops
        vec_ops h hw
        obtain ⟨σ', h', hw⟩ := wp_vset' h hw
        simp only [Term.wp] at hw
        refine step_done (h'.setPC _) hw ((evalInst_fpImm_d prog rd imm8 s).trans (wv_eq _ ?_))
        env_simp
        generalize Arm64.vfpExpandImm64 imm8 = x
        bv_decide
      · cases hops

theorem evalInst_fcsel_s (cond : BitVec 4) (s : Arm64.State) :
    prog.evalInst (.fpCondSelect 0#2 rm cond rn rd) s =
      (s.writeVReg128 rd ((if Arm64.ConditionHolds (Arm64.CondCode.ofBits cond) s.pstate
        then (s.vregs.read rn).truncate 32 else (s.vregs.read rm).truncate 32).zeroExtend
          128)).advancePC := rfl

theorem evalInst_fcsel_d (cond : BitVec 4) (s : Arm64.State) :
    prog.evalInst (.fpCondSelect 1#2 rm cond rn rd) s =
      (s.writeVReg128 rd ((if Arm64.ConditionHolds (Arm64.CondCode.ofBits cond) s.pstate
        then (s.vregs.read rn).truncate 64 else (s.vregs.read rm).truncate 64).zeroExtend
          128)).advancePC := rfl

/-- An `FCSEL` is sound. -/
theorem sound_fpCondSelect {ftype : BitVec 2} {cond : BitVec 4}
    (h : Rel s σ) (hw : (lower s.pc (.fpCondSelect ftype rm cond rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.fpCondSelect ftype rm cond rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.fpCondSelect ftype rm cond rn rd) s).mem := by
  simp only [lower] at hw
  generalize hops : fcselOps ftype rm cond rn rd = o at hw
  cases o with
  | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
  | some ops =>
    simp only [fcselOps] at hops
    split at hops
    · rename_i hc
      subst hc
      cases hops
      simp only [Block.wp, List.append_assoc] at hw
      obtain ⟨ρ₁, hw⟩ := wp_condOps h hw
      vec_ops h hw
      obtain ⟨σ', h', hw⟩ := wp_vset' h hw
      simp only [Term.wp] at hw
      refine step_done (h'.setPC _) hw ((evalInst_fcsel_s prog rm rn rd cond s).trans (wv_eq _ ?_))
      env_simp
      simp only [UnOp.eval_zext]
      generalize s.vregs.read rn = x
      generalize s.vregs.read rm = y
      cases Arm64.ConditionHolds (Arm64.CondCode.ofBits cond) s.pstate <;>
        simp only [ofBool_true, ofBool_false, ne_eq, not_true_eq_false, ↓reduceIte,
          Bool.false_eq_true] <;>
        bv_decide
    · split at hops
      · rename_i hc
        subst hc
        cases hops
        simp only [Block.wp, List.append_assoc] at hw
        obtain ⟨ρ₁, hw⟩ := wp_condOps h hw
        vec_ops h hw
        obtain ⟨σ', h', hw⟩ := wp_vset' h hw
        simp only [Term.wp] at hw
        refine step_done (h'.setPC _) hw
          ((evalInst_fcsel_d prog rm rn rd cond s).trans (wv_eq _ ?_))
        env_simp
        generalize s.vregs.read rn = x
        generalize s.vregs.read rm = y
        cases Arm64.ConditionHolds (Arm64.CondCode.ofBits cond) s.pstate <;>
          simp only [ofBool_true, ofBool_false, ne_eq, not_true_eq_false, ↓reduceIte,
            Bool.false_eq_true] <;>
          bv_decide
      · cases hops

theorem evalInst_not (q : Bool) (s : Arm64.State) :
    prog.evalInst (.simdTwoRegMisc q true 0#2 5#5 rn rd) s =
      (s.writeVReg128 rd (if q then ~~~(s.vregs.read rn)
        else ((~~~(s.vregs.read rn)).truncate 64).zeroExtend 128)).advancePC := rfl

/-- A `NOT` of a vector register is sound. -/
theorem sound_simdTwoRegMisc {q u : Bool} {size : BitVec 2} {opcode : BitVec 5}
    (h : Rel s σ) (hw : (lower s.pc (.simdTwoRegMisc q u size opcode rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.simdTwoRegMisc q u size opcode rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.simdTwoRegMisc q u size opcode rn rd) s).mem := by
  simp only [lower] at hw
  generalize hops : notOps q u size opcode rn rd = o at hw
  cases o with
  | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
  | some ops =>
    simp only [notOps] at hops
    split at hops
    · rename_i hc
      obtain ⟨rfl, rfl, rfl⟩ := hc
      cases hops
      cases q <;> simp only [Bool.false_eq_true, ↓reduceIte] at hw <;> vec_ops h hw <;>
        obtain ⟨σ', h', hw⟩ := wp_vset' h hw <;>
        simp only [Term.wp] at hw <;>
        refine step_done (h'.setPC _) hw ((evalInst_not prog rn rd _ s).trans (wv_eq _ ?_)) <;>
        env_simp <;>
        simp only [UnOp.eval_not, Bool.false_eq_true, ↓reduceIte] <;>
        generalize s.vregs.read rn = x <;>
        bv_decide
    · cases hops

theorem evalInst_addp (s : Arm64.State) :
    prog.evalInst (.simdAddpScalar rn rd) s =
      (s.writeVReg128 rd (((s.vregs.read rn).extractLsb' 0 64 +
        (s.vregs.read rn).extractLsb' 64 64).zeroExtend 128)).advancePC := rfl

/-- A scalar `ADDP`, the sum of the two halves of a vector register, is sound. -/
theorem sound_simdAddpScalar (h : Rel s σ) (hw : (lower s.pc (.simdAddpScalar rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.simdAddpScalar rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.simdAddpScalar rn rd) s).mem := by
  simp only [lower] at hw
  vec_ops h hw
  obtain ⟨σ', h', hw⟩ := wp_vset' h hw
  simp only [Term.wp] at hw
  refine step_done (h'.setPC _) hw ((evalInst_addp prog rn rd s).trans (wv_eq _ ?_))
  env_simp
  simp only [BinOp.eval_add]
  generalize s.vregs.read rn = x
  bv_decide

end Lowering.Arm
