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
  * `sound_simdThreeSame`: operations on lanes
  * `sound_simdInsDup`: moves between general registers and lanes
  * `sound_simdImmShift`: constants, and shifts of lanes by a constant
  * `sound_simdTwoRegMisc`: `NOT`, and the reversals of elements
  * `sound_simdExt`: `EXT`
-/

module

public import Lowering.Arm.Rel
import Std.Tactic.BVDecide
import Braid.BV

@[expose] public section

namespace Lowering.Arm

open Braid
open Arm64 (Instr RegWidth MemWidth AddrMode SimdMemSize)

variable {s : Arm64.State} {σ : State}

/-! ## Vector registers -/

/-- A 128-bit value is its two halves. -/
theorem halves_append (x : BitVec 128) : x.extractLsb' 64 64 ++ x.truncate 64 = x := by
  bv_auto

theorem truncate_append (lo hi : Word) : (hi ++ lo : BitVec 128).truncate 64 = lo := by
  bv_auto

theorem extract_append (lo hi : Word) : (hi ++ lo : BitVec 128).extractLsb' 64 64 = hi := by
  bv_auto

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
  · generalize m.read8 a = b; bv_auto
  · generalize m.read16 a = b; bv_auto
  · generalize m.read32 a = b; bv_auto
  · generalize m.read64 a = b; bv_auto

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
  · congr 1; bv_auto
  · congr 1; bv_auto
  · congr 1; bv_auto
  · congr 1; bv_auto

/-- A store of sixteen bytes is two stores of eight. -/
theorem writeSimdSized_q (m : Arm64.Memory) (a lo hi : Word) :
    m.writeSimdSized .Q128 a (hi ++ lo) =
      (m.writeSized .X64 a lo).writeSized .X64 (a + 8#64) hi := by
  simp only [Arm64.Memory.writeSimdSized, Arm64.Memory.write128, Arm64.Memory.writeSized,
    extract_append]
  congr 2
  bv_auto

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
        bv_auto
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
          bv_auto
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
            bv_auto
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
        bv_auto
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
          bv_auto
        · cases hops
    · cases hops

/-! ## Constants -/

theorem movi_halves (q : Bool) (d : Word) :
    (if q = true then d ++ d else BitVec.setWidth 128 d) = (if q = true then d else 0#64) ++ d := by
  cases q
  · simp only [Bool.false_eq_true, ↓reduceIte]; bv_auto
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

/-! ## Operations on lanes -/

theorem bv2_cases (x : BitVec 2) : x = 0#2 ∨ x = 1#2 ∨ x = 2#2 ∨ x = 3#2 := by bv_auto

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
      bv_auto
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
        bv_auto
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
  bv_auto

/-! ## Lanes -/

theorem bv5_cases (x : BitVec 5) :
    x = 0#5 ∨ x = 1#5 ∨ x = 2#5 ∨ x = 3#5 ∨ x = 4#5 ∨ x = 5#5 ∨ x = 6#5 ∨ x = 7#5 ∨
      x = 8#5 ∨ x = 9#5 ∨ x = 10#5 ∨ x = 11#5 ∨ x = 12#5 ∨ x = 13#5 ∨ x = 14#5 ∨ x = 15#5 ∨
      x = 16#5 ∨ x = 17#5 ∨ x = 18#5 ∨ x = 19#5 ∨ x = 20#5 ∨ x = 21#5 ∨ x = 22#5 ∨ x = 23#5 ∨
      x = 24#5 ∨ x = 25#5 ∨ x = 26#5 ∨ x = 27#5 ∨ x = 28#5 ∨ x = 29#5 ∨ x = 30#5 ∨ x = 31#5 := by
  bv_auto

/-- Split a 5-bit field into its 32 values. -/
macro "bv5_split" x:ident : tactic => `(tactic|
  (rcases bv5_cases $x:ident with
    h | h | h | h | h | h | h | h |
    h | h | h | h | h | h | h | h |
    h | h | h | h | h | h | h | h |
    h | h | h | h | h | h | h | h <;>
   subst h))

/-- The half of a vector register a lane lies in. -/
def vhalf (imm5 : BitVec 5) (v : BitVec 128) : Word :=
  if lanePos imm5 < 64 then v.truncate 64 else v.extractLsb' 64 64

/-- The lane of a vector register that `imm5` names, zero-extended. -/
def vlane (imm5 : BitVec 5) (v : BitVec 128) : Word :=
  (UnOp.zext (laneSize imm5)).eval (vhalf imm5 v >>> BitVec.ofNat 64 (lanePos imm5 % 64))

/-- The model's operation on each lane, as a fold over the lanes. -/
theorem mapSimdLanes_eq (q : Bool) (esize : Nat) (v : BitVec 128) (f : BitVec 128 → BitVec 128) :
    Arm64.mapSimdLanes q esize v f =
      (List.range' 0 ((if q then 128 else 64) / esize)).foldl (fun acc i =>
        acc ||| ((f ((v >>> (i * esize)) &&& ((1#128 <<< esize) - 1#128))) &&&
            ((1#128 <<< esize) - 1#128)) <<< (i * esize)) 0#128 := by
  simp [Arm64.mapSimdLanes, Std.Legacy.Range.forIn_eq_forIn_range', Std.Legacy.Range.size]

set_option maxRecDepth 4000 in
theorem evalInst_umov (imm5 : BitVec 5) (q : Bool) (s : Arm64.State)
    (h0 : imm5.extractLsb' 0 4 ≠ 0#4)
    (hq : (q = true ∧ laneSize imm5 = 64) ∨ (q = false ∧ laneSize imm5 < 64)) :
    prog.evalInst (.simdInsDup q false imm5 7#4 rn rd) s =
      (s.writeReg64 (Arm64.Reg.fromZRBits rd) (vlane imm5 (s.vregs.read rn))).advancePC := by
  bv5_split imm5 <;>
    first
    | exact absurd rfl h0
    | (cases q <;> first
        | (exfalso; revert hq; decide)
        | (refine (rfl : prog.evalInst _ s = (s.writeReg64 _ _).advancePC).trans
            (congrArg (fun v => (s.writeReg64 (Arm64.Reg.fromZRBits rd) v).advancePC) ?_)
           simp [vlane, vhalf, laneSize, lanePos, Arm64.getSimdLane, Arm64.State.readVReg128]
           generalize s.vregs.read rn = x
           bv_decide))

set_option maxRecDepth 4000 in
theorem evalInst_smov (imm5 : BitVec 5) (q : Bool) (s : Arm64.State)
    (h0 : imm5.extractLsb' 0 4 ≠ 0#4)
    (hq : (q = true ∧ laneSize imm5 < 64) ∨ (q = false ∧ laneSize imm5 < 32)) :
    prog.evalInst (.simdInsDup q false imm5 5#4 rn rd) s =
      (s.writeReg64 (Arm64.Reg.fromZRBits rd)
        (if q then (UnOp.sext (laneSize imm5)).eval
            (vhalf imm5 (s.vregs.read rn) >>> BitVec.ofNat 64 (lanePos imm5 % 64))
          else (UnOp.zext 32).eval ((UnOp.sext (laneSize imm5)).eval
            (vhalf imm5 (s.vregs.read rn) >>> BitVec.ofNat 64 (lanePos imm5 % 64))))).advancePC := by
  bv5_split imm5 <;>
    first
    | exact absurd rfl h0
    | (cases q <;> first
        | (exfalso; revert hq; decide)
        | (refine (rfl : prog.evalInst _ s = (s.writeReg64 _ _).advancePC).trans
            (congrArg (fun v => (s.writeReg64 (Arm64.Reg.fromZRBits rd) v).advancePC) ?_)
           simp [vhalf, laneSize, lanePos, Arm64.getSimdLane, Arm64.State.readVReg128]
           generalize s.vregs.read rn = x
           bv_decide))

/-- A vector register with the lane that `imm5` names replaced by the low bits of `x`. -/
def vins (imm5 : BitVec 5) (v : BitVec 128) (x : Word) : BitVec 128 :=
  let f (w : Word) : Word :=
    (w &&& ~~~((UnOp.zext (laneSize imm5)).eval (-1#64) <<< BitVec.ofNat 64 (lanePos imm5 % 64))) |||
      ((UnOp.zext (laneSize imm5)).eval x <<< BitVec.ofNat 64 (lanePos imm5 % 64))
  if lanePos imm5 < 64 then v.extractLsb' 64 64 ++ f (v.truncate 64)
  else f (v.extractLsb' 64 64) ++ v.truncate 64

set_option maxRecDepth 4000 in
theorem evalInst_ins (imm5 : BitVec 5) (s : Arm64.State) (h0 : imm5.extractLsb' 0 4 ≠ 0#4) :
    prog.evalInst (.simdInsDup true false imm5 3#4 rn rd) s =
      (s.writeVReg128 rd (vins imm5 (s.vregs.read rd)
        (s.readReg64 (Arm64.Reg.fromZRBits rn)))).advancePC := by
  bv5_split imm5 <;>
    first
    | exact absurd rfl h0
    | (refine (rfl : prog.evalInst _ s = (s.writeVReg128 _ _).advancePC).trans
        (congrArg (fun v => (s.writeVReg128 rd v).advancePC) ?_)
       simp [vins, laneSize, lanePos, Arm64.State.readVReg128]
       generalize s.vregs.read rd = x
       generalize s.readReg64 _ = y
       bv_decide)

/-- A vector register with the lane `x` in every lane, of both halves or of the low one. -/
def vsplat (q : Bool) (imm5 : BitVec 5) (x : Word) : BitVec 128 :=
  (if q then x * laneOnes (laneSize imm5) else 0#64) ++ x * laneOnes (laneSize imm5)

set_option maxRecDepth 4000 in
theorem evalInst_dup (imm5 : BitVec 5) (q : Bool) (s : Arm64.State)
    (h0 : imm5.extractLsb' 0 4 ≠ 0#4) (hq : ¬(laneSize imm5 = 64 ∧ q = false)) :
    prog.evalInst (.simdInsDup q false imm5 1#4 rn rd) s =
      (s.writeVReg128 rd (vsplat q imm5 ((UnOp.zext (laneSize imm5)).eval
        (s.readReg64 (Arm64.Reg.fromZRBits rn))))).advancePC := by
  bv5_split imm5 <;>
    first
    | exact absurd rfl h0
    | (cases q <;> first
        | (exfalso; revert hq; decide)
        | (refine (rfl : prog.evalInst _ s = (s.writeVReg128 _ _).advancePC).trans
            (congrArg (fun v => (s.writeVReg128 rd v).advancePC) ?_)
           simp [vsplat, laneSize, laneOnes, mapSimdLanes_eq, List.range']
           generalize s.readReg64 _ = y
           bv_decide))

set_option maxRecDepth 4000 in
theorem evalInst_dupElem (imm5 : BitVec 5) (q : Bool) (s : Arm64.State)
    (h0 : imm5.extractLsb' 0 4 ≠ 0#4) (hq : ¬(laneSize imm5 = 64 ∧ q = false)) :
    prog.evalInst (.simdInsDup q false imm5 0#4 rn rd) s =
      (s.writeVReg128 rd (vsplat q imm5 (vlane imm5 (s.vregs.read rn)))).advancePC := by
  bv5_split imm5 <;>
    first
    | exact absurd rfl h0
    | (cases q <;> first
        | (exfalso; revert hq; decide)
        | (refine (rfl : prog.evalInst _ s = (s.writeVReg128 _ _).advancePC).trans
            (congrArg (fun v => (s.writeVReg128 rd v).advancePC) ?_)
           simp [vsplat, vlane, vhalf, laneSize, lanePos, laneOnes, mapSimdLanes_eq, List.range',
             Arm64.getSimdLane, Arm64.State.readVReg128]
           generalize s.vregs.read rn = y
           bv_decide))

theorem setReg_comm_self (σ : State) {a b : Reg} (hab : b ≠ a) (v : Word) :
    (σ.setReg a v).setReg b (σ.regs b) = σ.setReg a v := by
  have := setReg_self (σ.setReg a v) b
  simpa only [State.setReg, hab, ↓reduceIte] using this

/-- Writing the low half of a vector register keeps its high half. -/
theorem Rel.writeVRegLo (h : Rel s σ) (k : BitVec 5) (lo : Word) :
    Rel (s.writeVReg128 k ((s.vregs.read k).extractLsb' 64 64 ++ lo)) (σ.setReg (vregLo k) lo) := by
  have := h.writeVReg k lo (σ.regs (vregHi k))
  have hne : vregHi k ≠ vregLo k := by
    show (65 + 2 * k.toNat : Nat) ≠ 64 + 2 * k.toNat
    omega
  rwa [setReg_comm_self _ hne, vregHi, h.vhi] at this

/-- The half of a vector register a lane lies in, read off a related state. -/
theorem Rel.half (h : Rel s σ) (imm5 k : BitVec 5) :
    σ.regs (if lanePos imm5 < 64 then 64 + 2 * k.toNat else 65 + 2 * k.toNat) =
      vhalf imm5 (s.vregs.read k) := by
  unfold vhalf
  split
  · exact h.vlo k
  · exact h.vhi k

/-- Writing a lane of a vector register gives a state related to the machine's. -/
theorem Rel.ins (h : Rel s σ) (imm5 k : BitVec 5) (x y : Word)
    (hy : y = (UnOp.zext (laneSize imm5)).eval x <<< BitVec.ofNat 64 (lanePos imm5 % 64)) :
    Rel (s.writeVReg128 k (vins imm5 (s.vregs.read k) x))
      (σ.setReg (if lanePos imm5 < 64 then 64 + 2 * k.toNat else 65 + 2 * k.toNat)
        ((vhalf imm5 (s.vregs.read k) &&&
          ~~~((UnOp.zext (laneSize imm5)).eval (-1#64) <<<
            BitVec.ofNat 64 (lanePos imm5 % 64))) ||| y)) := by
  subst hy
  unfold vins vhalf
  split
  · exact h.writeVRegLo k _
  · exact h.writeVRegHi k _

/-- A move between a general register and a lane, or of a lane into every lane, is sound. -/
theorem sound_simdInsDup {q op : Bool} {imm5 : BitVec 5} {imm4 : BitVec 4}
    (h : Rel s σ) (hw : (lower s.pc (.simdInsDup q op imm5 imm4 rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.simdInsDup q op imm5 imm4 rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.simdInsDup q op imm5 imm4 rn rd) s).mem := by
  simp only [lower] at hw
  generalize hops : insDupOps q op imm5 imm4 rn rd = o at hw
  cases o with
  | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
  | some ops =>
    simp only [insDupOps] at hops
    split at hops
    · cases hops
    rename_i h0
    split at hops
    · rename_i hc
      obtain ⟨rfl, rfl, hq⟩ := hc
      cases hops
      vec_ops h hw
      obtain ⟨σ', h', hw⟩ := wp_vset' h hw
      simp only [Term.wp] at hw
      refine step_done (h'.setPC _) hw
        ((evalInst_dup prog rn rd imm5 q s h0 hq).trans (wv_eq _ ?_))
      cases q <;>
        simp only [vsplat, Env.set_apply, Nat.reduceEqDiff, ↓reduceIte, Bool.false_eq_true,
          BinOp.eval_mul]
    split at hops
    · rename_i hc
      obtain ⟨rfl, rfl, hq⟩ := hc
      cases hops
      vec_ops h hw
      simp only [h.half] at hw
      obtain ⟨σ', h', hw⟩ := wp_vset' h hw
      simp only [Term.wp] at hw
      refine step_done (h'.setPC _) hw
        ((evalInst_dupElem prog rn rd imm5 q s h0 hq).trans (wv_eq _ ?_))
      cases q <;>
        simp only [vsplat, vlane, Env.set_apply, Nat.reduceEqDiff, ↓reduceIte, Bool.false_eq_true,
          BinOp.eval_mul, BinOp.eval_lshr]
    split at hops
    · rename_i hc
      obtain ⟨rfl, rfl, rfl⟩ := hc
      cases hops
      vec_ops h hw
      simp only [h.half, Term.wp] at hw
      exact step_done ((h.ins imm5 rd _ _ rfl).setPC _) hw (evalInst_ins prog rn rd imm5 s h0)
    split at hops
    · rename_i hc
      obtain ⟨rfl, rfl, hq⟩ := hc
      cases hops
      vec_ops h hw
      simp only [h.half] at hw
      obtain ⟨σ', h', hw⟩ := wp_rset' h hw
      simp only [Term.wp] at hw
      exact step_done (h'.setPC _) hw
        ((evalInst_umov prog rn rd imm5 q s h0 hq).trans (wr_eq _ rfl))
    split at hops
    · rename_i hc
      obtain ⟨rfl, rfl, hq⟩ := hc
      cases hops
      vec_ops h hw
      simp only [h.half] at hw
      obtain ⟨σ', h', hw⟩ := wp_rset' h hw
      simp only [Term.wp] at hw
      refine step_done (h'.setPC _) hw
        ((evalInst_smov prog rn rd imm5 q s h0 hq).trans (wr_eq _ ?_))
      cases q <;>
        simp only [Env.set_apply, Nat.reduceEqDiff, ↓reduceIte, Bool.false_eq_true,
          BinOp.eval_lshr]
    · cases hops

/-! ## Shifts of lanes by a constant -/

/-- The value of a shift of lanes by a constant: the shift of each half, or of the low half
only, with the high half clear. -/
def shiftRes (sop : LaneShift) (e k : Nat) (q : Bool) (vn vd : BitVec 128) : BitVec 128 :=
  (if q then sop.eval e k (vn.extractLsb' 64 64) (vd.extractLsb' 64 64) else 0#64) ++
    sop.eval e k (vn.truncate 64) (vd.truncate 64)

/-- An amount of at most 64, as a field of seven bits and its bound in the same terms. -/
theorem amount_bv {e k : Nat} (he : e = 8 ∨ e = 16 ∨ e = 32 ∨ e = 64) (hk : k ≤ e) :
    ∃ kb : BitVec 7, kb.toNat = k ∧ kb ≤ BitVec.ofNat 7 e := by
  refine ⟨BitVec.ofNat 7 k, ?_, ?_⟩
  · rw [BitVec.toNat_ofNat]; omega
  · rw [BitVec.le_def, BitVec.toNat_ofNat, BitVec.toNat_ofNat]; omega

/-- Unfold a shift of lanes of a known size on both sides, down to words. -/
macro "lanes_simp" : tactic => `(tactic|
  simp only [shiftRes, LaneShift.eval, shlMask, shrMask, laneOnes, UnOp.eval_zext, ↓reduceIte,
    Nat.reduceDiv, List.range', List.range, List.range.loop, List.foldl, Nat.reduceMul,
    Nat.reduceAdd, Bool.false_eq_true, BitVec.ofNat_toNat, BinOp.eval_lanes, BinOp.eval_add,
    Nat.reduceEqDiff])

/-- The model's shift left of lanes is the shift of each half, masked. -/
theorem lanes_shl {e k : Nat} (he : e = 8 ∨ e = 16 ∨ e = 32 ∨ e = 64) (hk : k ≤ e)
    (q : Bool) (vn vd : BitVec 128) :
    Arm64.mapSimdLanes q e vn (fun lane => lane <<< k) = shiftRes .shl e k q vn vd := by
  obtain ⟨kb, rfl, hkb⟩ := amount_bv he hk
  rw [mapSimdLanes_eq]
  rcases he with rfl | rfl | rfl | rfl <;> cases q <;> lanes_simp <;> bv_decide

/-- The model's shift right of lanes is the shift of each half, masked. -/
theorem lanes_ushr {e k : Nat} (he : e = 8 ∨ e = 16 ∨ e = 32 ∨ e = 64) (hk : k ≤ e)
    (q : Bool) (vn vd : BitVec 128) :
    Arm64.mapSimdLanes q e vn (fun lane => lane >>> k) = shiftRes .ushr e k q vn vd := by
  obtain ⟨kb, rfl, hkb⟩ := amount_bv he hk
  rw [mapSimdLanes_eq]
  rcases he with rfl | rfl | rfl | rfl <;> cases q <;> lanes_simp <;> bv_decide

/-- The model's shift right of a lane, which it does on integers, is a shift of bits. -/
theorem usra_lane (e k : Nat) (x : BitVec 128) :
    Arm64.intToSimdLane e (Arm64.aslRShr (Arm64.simdLaneUInt e x) k false) =
      ((x &&& ((1#128 <<< e) - 1#128)) >>> k) &&& ((1#128 <<< e) - 1#128) := by
  simp only [Arm64.intToSimdLane, Arm64.aslRShr, Arm64.simdLaneUInt, Bool.false_eq_true,
    ↓reduceIte]
  congr 1
  generalize x &&& ((1#128 <<< e) - 1#128) = y
  have h : (Int.ofNat y.toNat / Int.ofNat (1 <<< k) : Int) = ((y >>> k).toNat : Int) := by
    rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, Nat.shiftLeft_eq, Nat.one_mul]
    rfl
  split
  · rename_i hk
    have hk : k = 0 := by simpa using hk
    subst hk
    simp
  · rw [h, BitVec.ofInt_natCast, BitVec.ofNat_toNat, BitVec.setWidth_eq]

/-- The model's shift right of lanes, added to the lanes of the destination, is the shift of
each half, masked, and `BinOp.lanes` of the sum. -/
theorem lanes_usra {e k : Nat} (he : e = 8 ∨ e = 16 ∨ e = 32 ∨ e = 64) (hk : k ≤ e)
    (q : Bool) (vn vd : BitVec 128) :
    Arm64.zipSimdLanes q e vn vd (fun lane acc =>
        acc + Arm64.intToSimdLane e (Arm64.aslRShr (Arm64.simdLaneUInt e lane) k false)) =
      shiftRes .usra e k q vn vd := by
  obtain ⟨kb, rfl, hkb⟩ := amount_bv he hk
  simp only [usra_lane]
  rw [zipSimdLanes_eq]
  rcases he with rfl | rfl | rfl | rfl <;> cases q <;> lanes_simp <;> bv_decide

/-- The model's `SRI` of lanes is the shift of each half, into the bits it fills. -/
theorem lanes_sri {e k : Nat} (he : e = 8 ∨ e = 16 ∨ e = 32 ∨ e = 64) (hk : k ≤ e)
    (q : Bool) (vn vd : BitVec 128) :
    Arm64.zipSimdLanes q e vn vd (fun a d =>
        (d &&& ~~~(((1#128 <<< e) - 1#128) >>> k)) |||
          ((a >>> k) &&& (((1#128 <<< e) - 1#128) >>> k))) =
      shiftRes .sri e k q vn vd := by
  obtain ⟨kb, rfl, hkb⟩ := amount_bv he hk
  rw [zipSimdLanes_eq]
  rcases he with rfl | rfl | rfl | rfl <;> cases q <;> lanes_simp <;> bv_decide

/-- The model's `SLI` of lanes is the shift of each half, into the bits it fills. -/
theorem lanes_sli {e k : Nat} (he : e = 8 ∨ e = 16 ∨ e = 32 ∨ e = 64) (hk : k ≤ e)
    (q : Bool) (vn vd : BitVec 128) :
    Arm64.zipSimdLanes q e vn vd (fun a d =>
        (d &&& ~~~((((1#128 <<< e) - 1#128) <<< k) &&& ((1#128 <<< e) - 1#128))) |||
          (((a <<< k) &&& ((1#128 <<< e) - 1#128)) &&&
            ((((1#128 <<< e) - 1#128) <<< k) &&& ((1#128 <<< e) - 1#128)))) =
      shiftRes .sli e k q vn vd := by
  obtain ⟨kb, rfl, hkb⟩ := amount_bv he hk
  rw [zipSimdLanes_eq]
  rcases he with rfl | rfl | rfl | rfl <;> cases q <;> lanes_simp <;> bv_decide

/-- The lanes of a shift by a constant are of 8, 16, 32 or 64 bits, and its amount to the
left and its amount to the right are at most a lane. -/
theorem shift_bounds {immh : BitVec 4} (immb : BitVec 3) (h0 : immh ≠ 0#4) :
    (shiftLaneSize immh immb = 8 ∨ shiftLaneSize immh immb = 16 ∨
        shiftLaneSize immh immb = 32 ∨ shiftLaneSize immh immb = 64) ∧
      (immh ++ immb).toNat - shiftLaneSize immh immb ≤ shiftLaneSize immh immb ∧
      2 * shiftLaneSize immh immb - (immh ++ immb).toNat ≤ shiftLaneSize immh immb := by
  have h8 : 8#7 ≤ immh ++ immb := by bv_decide
  have h8 : 8 ≤ (immh ++ immb).toNat := by simpa [BitVec.le_def] using h8
  have hlt := (immh ++ immb).isLt
  unfold shiftLaneSize
  repeat' split
  all_goals omega

section
variable {q : Bool} {immh : BitVec 4} (immb : BitVec 3) (s : Arm64.State)
  (h0 : immh ≠ 0#4) (hq : ¬(immh.getLsbD 3 = true ∧ q = false))
include h0 hq

theorem evalInst_shl :
    prog.evalInst (.simdImmShift q false immh immb 10#5 rn rd) s =
      (s.writeVReg128 rd (Arm64.mapSimdLanes q (shiftLaneSize immh immb) (s.vregs.read rn)
        (fun lane => lane <<< ((immh ++ immb).toNat - shiftLaneSize immh immb)))).advancePC := by
  have h0' : (immh == 0#4) = false := by simpa using h0
  have hq' : immh[3] = false ∨ q = true := by cases q <;> simp_all
  simp [Arm64.Program.evalInst, Arm64.execInstWithSvc, h0', hq']
  rfl

theorem evalInst_ushr :
    prog.evalInst (.simdImmShift q true immh immb 0#5 rn rd) s =
      (s.writeVReg128 rd (Arm64.mapSimdLanes q (shiftLaneSize immh immb) (s.vregs.read rn)
        (fun lane =>
          lane >>> (2 * shiftLaneSize immh immb - (immh ++ immb).toNat)))).advancePC := by
  have h0' : (immh == 0#4) = false := by simpa using h0
  have hq' : immh[3] = false ∨ q = true := by cases q <;> simp_all
  simp [Arm64.Program.evalInst, Arm64.execInstWithSvc, h0', hq']
  rfl

theorem evalInst_usra :
    prog.evalInst (.simdImmShift q true immh immb 2#5 rn rd) s =
      (s.writeVReg128 rd (Arm64.zipSimdLanes q (shiftLaneSize immh immb) (s.vregs.read rn)
        (s.vregs.read rd) (fun lane acc => acc + Arm64.intToSimdLane (shiftLaneSize immh immb)
          (Arm64.aslRShr (Arm64.simdLaneUInt (shiftLaneSize immh immb) lane)
            (2 * shiftLaneSize immh immb - (immh ++ immb).toNat) false)))).advancePC := by
  have h0' : (immh == 0#4) = false := by simpa using h0
  have hq' : immh[3] = false ∨ q = true := by cases q <;> simp_all
  simp [Arm64.Program.evalInst, Arm64.execInstWithSvc, Arm64.evalSimdImmShiftNonZeroExt,
    Arm64.evalSimdImmShiftNonZeroExtSatFlags, h0', hq']
  rfl

theorem evalInst_sri :
    prog.evalInst (.simdImmShift q true immh immb 8#5 rn rd) s =
      (s.writeVReg128 rd (Arm64.zipSimdLanes q (shiftLaneSize immh immb) (s.vregs.read rn)
        (s.vregs.read rd) (fun a d =>
          (d &&& ~~~(((1#128 <<< shiftLaneSize immh immb) - 1#128) >>>
            (2 * shiftLaneSize immh immb - (immh ++ immb).toNat))) |||
          ((a >>> (2 * shiftLaneSize immh immb - (immh ++ immb).toNat)) &&&
            (((1#128 <<< shiftLaneSize immh immb) - 1#128) >>>
              (2 * shiftLaneSize immh immb - (immh ++ immb).toNat)))))).advancePC := by
  have h0' : (immh == 0#4) = false := by simpa using h0
  have hq' : immh[3] = false ∨ q = true := by cases q <;> simp_all
  simp [Arm64.Program.evalInst, Arm64.execInstWithSvc, h0', hq']
  rfl

theorem evalInst_sli :
    prog.evalInst (.simdImmShift q true immh immb 10#5 rn rd) s =
      (s.writeVReg128 rd (Arm64.zipSimdLanes q (shiftLaneSize immh immb) (s.vregs.read rn)
        (s.vregs.read rd) (fun a d =>
          (d &&& ~~~((((1#128 <<< shiftLaneSize immh immb) - 1#128) <<<
            ((immh ++ immb).toNat - shiftLaneSize immh immb)) &&&
              ((1#128 <<< shiftLaneSize immh immb) - 1#128))) |||
          (((a <<< ((immh ++ immb).toNat - shiftLaneSize immh immb)) &&&
              ((1#128 <<< shiftLaneSize immh immb) - 1#128)) &&&
            ((((1#128 <<< shiftLaneSize immh immb) - 1#128) <<<
              ((immh ++ immb).toNat - shiftLaneSize immh immb)) &&&
                ((1#128 <<< shiftLaneSize immh immb) - 1#128)))))).advancePC := by
  have h0' : (immh == 0#4) = false := by simpa using h0
  have hq' : immh[3] = false ∨ q = true := by cases q <;> simp_all
  simp [Arm64.Program.evalInst, Arm64.execInstWithSvc, h0', hq']
  rfl

end

/-- The model's shift of lanes by a constant writes the shift of each half. -/
theorem evalInst_laneShift {q op : Bool} {immh : BitVec 4} (immb : BitVec 3) {opc : BitVec 5}
    {sop : LaneShift} (s : Arm64.State) (h0 : immh ≠ 0#4)
    (hs : laneShift q op immh opc = some sop) :
    prog.evalInst (.simdImmShift q op immh immb opc rn rd) s =
      (s.writeVReg128 rd (shiftRes sop (shiftLaneSize immh immb) (shiftAmount sop immh immb) q
        (s.vregs.read rn) (s.vregs.read rd))).advancePC := by
  obtain ⟨he, hl, hr⟩ := shift_bounds immb h0
  simp only [laneShift] at hs
  split at hs
  · cases hs
  rename_i hq
  split at hs
  · rename_i hop
    subst hop
    split at hs
    · rename_i ho
      subst ho
      cases hs
      rw [evalInst_shl prog rn rd immb s h0 hq, lanes_shl he hl q _ (s.vregs.read rd)]
      rfl
    · cases hs
  rename_i hop
  have hop : op = true := by simpa using hop
  subst hop
  split at hs
  · rename_i ho
    subst ho
    cases hs
    rw [evalInst_ushr prog rn rd immb s h0 hq, lanes_ushr he hr q _ (s.vregs.read rd)]
    rfl
  split at hs
  · rename_i ho
    subst ho
    cases hs
    rw [evalInst_usra prog rn rd immb s h0 hq, lanes_usra he hr q]
    rfl
  split at hs
  · rename_i ho
    subst ho
    cases hs
    rw [evalInst_sri prog rn rd immb s h0 hq, lanes_sri he hr q]
    rfl
  split at hs
  · rename_i ho
    subst ho
    cases hs
    rw [evalInst_sli prog rn rd immb s h0 hq, lanes_sli he hl q]
    rfl
  · cases hs

/-- The operations of a shift of lanes leave the value of the shift in the destination. -/
theorem wp_shiftOps {sop : LaneShift} {e k : Nat} {q : Bool} (h : Rel s σ)
    (hw : (⟨shiftOps sop e k q rn rd, .jump (s.pc + 4)⟩ : Block).wp σ Q) :
    ∃ σ', Rel ((s.writeVReg128 rd (shiftRes sop e k q (s.vregs.read rn)
      (s.vregs.read rd))).setPC (s.pc + 4)) σ' ∧ Q σ' := by
  cases sop <;> cases q <;>
    simp only [shiftOps, LaneShift.ops, LaneShift.readsDst, ↓reduceIte,
      Bool.false_eq_true] at hw <;>
    vec_ops h hw <;>
    obtain ⟨σ', h', hw⟩ := wp_vset' h hw <;>
    simp only [Term.wp] at hw <;>
    refine ⟨_, (h'.setPC (s.pc + 4)).cast ?_, hw⟩ <;>
    env_simp <;>
    simp only [shiftRes, LaneShift.eval, BinOp.eval_and, BinOp.eval_or, BinOp.eval_shl,
      BinOp.eval_lshr, UnOp.eval_not, ↓reduceIte, Bool.false_eq_true]

/-- A `MOVI` of a constant, or a shift of lanes by a constant, is sound. -/
theorem sound_simdImmShift {q op : Bool} {immh : BitVec 4} {immb : BitVec 3} {opc : BitVec 5}
    (h : Rel s σ) (hw : (lower s.pc (.simdImmShift q op immh immb opc rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.simdImmShift q op immh immb opc rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.simdImmShift q op immh immb opc rn rd) s).mem := by
  simp only [lower] at hw
  generalize hops : immShiftOps q op immh immb opc rn rd = o at hw
  cases o with
  | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
  | some ops =>
    simp only [immShiftOps] at hops
    split at hops
    · rename_i hi
      subst hi
      split at hops
      · rename_i hb
        generalize hm : moviImm op (opc.extractLsb' 1 4) (immb ++ rn) = m at hops
        cases m with
        | none => cases hops
        | some d64 =>
          cases hops
          vec_ops h hw
          obtain ⟨σ', h', hw⟩ := wp_vset' h hw
          simp only [Term.wp] at hw
          refine step_done (h'.setPC _) hw ?_
          env_simp
          exact evalInst_movi prog rn rd hb hm s
      · cases hops
    · rename_i hi
      generalize hs : laneShift q op immh opc = so at hops
      cases so with
      | none => cases hops
      | some sop =>
        cases hops
        obtain ⟨σ', h', hq⟩ := wp_shiftOps rn rd h hw
        exact step_done h' hq (evalInst_laneShift prog rn rd immb s hi hs)

/-! ## Reversals -/

/-- The value of a reversal: of each half, or of the low half with the high half clear. -/
def revRes (gs : List Nat) (q : Bool) (vn : BitVec 128) : BitVec 128 :=
  (if q then revEval gs (vn.extractLsb' 64 64) else 0#64) ++ revEval gs (vn.truncate 64)

/-- The reversals the lowering covers. -/
theorem revGroups_cases {u : Bool} {size : BitVec 2} {opcode : BitVec 5} {gs : List Nat}
    (hg : revGroups u size opcode = some gs) :
    gs = [8, 16, 32] ∨ gs = [16, 32] ∨ gs = [32] ∨ gs = [8, 16] ∨ gs = [16] ∨
      gs = [8] := by
  simp only [revGroups] at hg
  repeat' split at hg
  all_goals first | (cases hg; done) | (cases hg; simp)

/-- One reversal of the model, of a known kind, is the exchanges of groups. -/
macro "rev_case" prog:ident s:ident rn:ident rd:ident q:ident : tactic => `(tactic|
  (refine (rfl : Arm64.Program.evalInst $prog _ $s =
      (Arm64.State.writeVReg128 $s $rd _).advancePC).trans
      (congrArg (fun v => (Arm64.State.writeVReg128 $s $rd v).advancePC) ?_)
   cases $q:ident <;>
     simp [revRes, revEval, swapEval, swapMask, laneOnes, Arm64.State.readVReg128,
       Arm64.rev16_64, Std.Legacy.Range.forIn_eq_forIn_range', Std.Legacy.Range.size,
       List.range'] <;>
     generalize Arm64.VRegFile.read (Arm64.State.vregs $s) $rn = x <;>
     bv_decide))

/-- The model's reversal writes the exchanges of groups of each half. -/
theorem evalInst_rev {q u : Bool} {size : BitVec 2} {opcode : BitVec 5} {gs : List Nat}
    (s : Arm64.State) (hg : revGroups u size opcode = some gs) :
    prog.evalInst (.simdTwoRegMisc q u size opcode rn rd) s =
      (s.writeVReg128 rd (revRes gs q (s.vregs.read rn))).advancePC := by
  simp only [revGroups] at hg
  split at hg
  · rename_i ho
    subst ho
    rcases bv2_cases size with rfl | rfl | rfl | rfl <;> cases u <;>
      simp only [↓reduceIte, BitVec.reduceEq, Bool.true_eq_false, Option.some.injEq,
        reduceCtorEq] at hg <;>
      subst hg <;>
      rev_case prog s rn rd q
  · split at hg
    · rename_i hc
      obtain ⟨rfl, rfl, rfl⟩ := hc
      cases hg
      rev_case prog s rn rd q
    · cases hg

/-- An exchange of groups leaves its value in `d`, and keeps the values below `d`. -/
theorem wp_swapOps {σ : State} {g d x : Nat} {ρ : Env} {Q : Env → State → Prop}
    {rest : List Op} (hx : x < d) (hw : wpOps (swapOps g d x ++ rest) ρ σ Q) :
    ∃ ρ' : Env, ρ' d = swapEval g (ρ x) ∧ (∀ y, y < d → ρ' y = ρ y) ∧
      wpOps rest ρ' σ Q := by
  have h1 : x ≠ d + 1 := by omega
  have h2 : x ≠ d + 2 := by omega
  have h3 : x ≠ d + 3 := by omega
  have h4 : x ≠ d + 4 := by omega
  simp only [swapOps, List.cons_append, List.nil_append, wpOps, Op.wp] at hw
  refine ⟨_, ?_, fun y hy => ?_, hw⟩
  · simp [h1, h2, h3, h4, swapEval]
  · env_below hy

/-- The exchanges of a reversal leave its value, and keep the values below `d`. -/
theorem wp_revOps {σ : State} (gs : List Nat) {d x : Nat} {ρ : Env} {Q : Env → State → Prop}
    {rest : List Op} (hx : x < d) (hw : wpOps (revOps gs d x ++ rest) ρ σ Q) :
    ∃ ρ' : Env, ρ' (revVar gs d x) = revEval gs (ρ x) ∧ (∀ y, y < d → ρ' y = ρ y) ∧
      wpOps rest ρ' σ Q := by
  induction gs generalizing d x ρ with
  | nil => exact ⟨ρ, rfl, fun _ _ => rfl, hw⟩
  | cons g gs ih =>
    simp only [revOps, List.append_assoc] at hw
    obtain ⟨ρ₁, e₁, hlt₁, hw⟩ := wp_swapOps hx hw
    obtain ⟨ρ₂, e₂, hlt₂, hw⟩ := ih (show d < d + 10 by omega) hw
    refine ⟨ρ₂, ?_, fun y hy => ?_, hw⟩
    · rw [revVar, revEval, e₂, e₁]
    · rw [hlt₂ y (by omega), hlt₁ y hy]

/-- The operations of a reversal leave its value in the destination. -/
theorem wp_revVecOps {gs : List Nat} {q : Bool}
    (hgs : gs = [8, 16, 32] ∨ gs = [16, 32] ∨ gs = [32] ∨ gs = [8, 16] ∨ gs = [16] ∨
      gs = [8])
    (h : Rel s σ) (hw : (⟨revVecOps gs q rn rd, .jump (s.pc + 4)⟩ : Block).wp σ Q) :
    ∃ σ', Rel ((s.writeVReg128 rd (revRes gs q (s.vregs.read rn))).setPC (s.pc + 4)) σ' ∧
      Q σ' := by
  have hv : revVar gs 10 0 < 50 := by
    rcases hgs with rfl | rfl | rfl | rfl | rfl | rfl <;> decide
  simp only [revVecOps, Block.wp, List.append_assoc] at hw
  have hw := wp_vget h hw
  obtain ⟨ρ₁, e₁, hlt₁, hw⟩ := wp_revOps gs (show 0 < 10 by decide) hw
  cases q
  · simp only [Bool.false_eq_true, ↓reduceIte, List.cons_append, List.nil_append, wpOps,
      Op.wp] at hw
    obtain ⟨σ', h', hw⟩ := wp_vset' h hw
    simp only [Term.wp] at hw
    refine ⟨_, (h'.setPC (s.pc + 4)).cast ?_, hw⟩
    simp only [revRes, Env.set_same, Env.set_other _ _ (Nat.ne_of_lt hv), e₁, Bool.false_eq_true,
      ↓reduceIte]
    rfl
  · simp only [↓reduceIte] at hw
    obtain ⟨ρ₂, e₂, hlt₂, hw⟩ := wp_revOps gs (show 1 < 50 by decide) hw
    obtain ⟨σ', h', hw⟩ := wp_vset' h hw
    simp only [Term.wp] at hw
    refine ⟨_, (h'.setPC (s.pc + 4)).cast ?_, hw⟩
    simp only [revRes, e₂, hlt₂ _ hv, e₁, hlt₁ 1 (by decide), ↓reduceIte]
    rfl

/-- A `NOT` of a vector register, or a reversal of its elements, is sound. -/
theorem sound_simdTwoRegMisc {q u : Bool} {size : BitVec 2} {opcode : BitVec 5}
    (h : Rel s σ) (hw : (lower s.pc (.simdTwoRegMisc q u size opcode rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.simdTwoRegMisc q u size opcode rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.simdTwoRegMisc q u size opcode rn rd) s).mem := by
  simp only [lower] at hw
  generalize hops : notOps q u size opcode rn rd = o at hw
  cases o with
  | none =>
    simp only at hw
    generalize hg : revGroups u size opcode = g at hw
    cases g with
    | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
    | some gs =>
      obtain ⟨σ', h', hq⟩ := wp_revVecOps rn rd (revGroups_cases hg) h hw
      exact step_done h' hq (evalInst_rev prog rn rd s hg)
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
        bv_auto
    · cases hops

/-! ## `EXT` -/

theorem bv4_cases (x : BitVec 4) :
    x = 0#4 ∨ x = 1#4 ∨ x = 2#4 ∨ x = 3#4 ∨ x = 4#4 ∨ x = 5#4 ∨ x = 6#4 ∨ x = 7#4 ∨
      x = 8#4 ∨ x = 9#4 ∨ x = 10#4 ∨ x = 11#4 ∨ x = 12#4 ∨ x = 13#4 ∨ x = 14#4 ∨
      x = 15#4 := by
  bv_auto

/-- The 64 bits from bit `k` of `b:a`, for `k` below 64. -/
def extVal (k : Nat) (a b : Word) : Word :=
  if k = 0 then a else (a >>> BitVec.ofNat 64 k) ||| (b <<< BitVec.ofNat 64 (64 - k))

/-- The value of an `EXT`: the two words from byte `imm4` of the four words of `vm:vn`, or
the one word from byte `imm4` of the low halves, with the high half clear. -/
def extRes (q : Bool) (imm4 : BitVec 4) (vn vm : BitVec 128) : BitVec 128 :=
  if q then
    if imm4.toNat < 8 then
      extVal (8 * (imm4.toNat % 8)) (vn.extractLsb' 64 64) (vm.truncate 64) ++
        extVal (8 * (imm4.toNat % 8)) (vn.truncate 64) (vn.extractLsb' 64 64)
    else
      extVal (8 * (imm4.toNat % 8)) (vm.truncate 64) (vm.extractLsb' 64 64) ++
        extVal (8 * (imm4.toNat % 8)) (vn.extractLsb' 64 64) (vm.truncate 64)
  else 0#64 ++ extVal (8 * (imm4.toNat % 8)) (vn.truncate 64) (vm.truncate 64)

/-- The model's `EXT` writes the words from byte `imm4`. -/
theorem evalInst_ext (q : Bool) (imm4 : BitVec 4) (s : Arm64.State)
    (hq : ¬(q = false ∧ imm4.getLsbD 3 = true)) :
    prog.evalInst (.simdExt q rm imm4 rn rd) s =
      (s.writeVReg128 rd (extRes q imm4 (s.vregs.read rn) (s.vregs.read rm))).advancePC := by
  rcases bv4_cases imm4 with
    rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
    rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
  cases q <;>
  first
  | (exfalso; revert hq; decide)
  | (refine (rfl : prog.evalInst _ s = (s.writeVReg128 rd _).advancePC).trans
        (congrArg (fun v => (s.writeVReg128 rd v).advancePC) ?_)
     simp [extRes, extVal, Arm64.State.readVReg128]
     generalize s.vregs.read rn = x
     generalize s.vregs.read rm = y
     bv_decide)

/-- Run the operations of one form of `EXT` and compare the value they leave. -/
macro "ext_case" h:ident hw:ident : tactic => `(tactic|
  (vec_ops $h $hw
   obtain ⟨σ', h', $hw:ident⟩ := wp_vset' $h $hw
   simp only [Term.wp] at $hw:ident
   refine ⟨_, (Rel.setPC h' _).cast ?_, $hw⟩
   env_simp
   simp only [extVal, BinOp.eval_or, BinOp.eval_shl, BinOp.eval_lshr, ↓reduceIte, *]))

/-- The operations of an `EXT` leave its value in the destination. -/
theorem wp_extOps {q : Bool} {imm4 : BitVec 4} {ops : List Op} (h : Rel s σ)
    (hops : extOps q rm imm4 rn rd = some ops)
    (hw : (⟨ops, .jump (s.pc + 4)⟩ : Block).wp σ Q) :
    ¬(q = false ∧ imm4.getLsbD 3 = true) ∧
      ∃ σ', Rel ((s.writeVReg128 rd (extRes q imm4 (s.vregs.read rn)
        (s.vregs.read rm))).setPC (s.pc + 4)) σ' ∧ Q σ' := by
  simp only [extOps, extWord] at hops
  unfold extRes
  generalize 8 * (imm4.toNat % 8) = k at hops ⊢
  cases q <;> simp only [Bool.false_eq_true, ↓reduceIte] at hops ⊢
  · split at hops
    · cases hops
    rename_i hb
    refine ⟨fun hc => hb hc.2, ?_⟩
    split at hops <;> cases hops <;> ext_case h hw
  · refine ⟨by simp, ?_⟩
    by_cases ha : imm4.toNat < 8 <;> simp only [ha, ↓reduceIte, Nat.reduceAdd] at hops ⊢ <;>
      split at hops <;> cases hops <;> ext_case h hw

/-- An `EXT`, the bytes of a pair of vector registers from a constant position, is sound. -/
theorem sound_simdExt {q : Bool} {imm4 : BitVec 4}
    (h : Rel s σ) (hw : (lower s.pc (.simdExt q rm imm4 rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.simdExt q rm imm4 rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.simdExt q rm imm4 rn rd) s).mem := by
  simp only [lower] at hw
  generalize hops : extOps q rm imm4 rn rd = o at hw
  cases o with
  | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
  | some ops =>
    obtain ⟨hq, σ', h', hq'⟩ := wp_extOps rm rn rd h hops hw
    exact step_done h' hq' (evalInst_ext prog rm rn rd q imm4 s hq)

end Lowering.Arm
