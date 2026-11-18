/-
  Lowering.X86.Sound

  The x86-64 lowering is sound: if the block of an instruction runs without fault and
  establishes a postcondition, every outcome of the instruction in the machine model is a
  state related to one that satisfies it. Both semantics are in the same style, a set of
  outcomes all of which must satisfy the postcondition, so the theorem for programs carries
  `Braid.Eventually` to the model's `Eventually` directly.

  ## Main results

  * `lowerOp_sound`: one integer instruction
  * `lower_sound`: one instruction
  * `lowerProgram_sound`: every run of an executable
-/

module

public import Lowering.X86.Ops
public import Lowering.X86.Shift
public import Lowering.X86.ShiftCl
public import Lowering.X86.Carry
public import Lowering.X86.Mul
public import Lowering.X86.DShift
public import Lowering.X86.Rotate

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env wpOps State ofBool)

section
variable [Labels] {p : Std.Rco Int64}

/-! ## Control flow -/

theorem jmp_sound {w : Width} (tgt : RelRegOrMem) : OpSound p (.jmp tgt : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  cases tgt with
  | rel c =>
    simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
    obtain ⟨rfl, rfl⟩ := hl
    simp only [Operation.interp, RelRegOrMem.interp]
    exact done_sound h (by simpa [wpOps, Term.wp] using hw)
  | reg r =>
    simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
    obtain ⟨rfl, rfl⟩ := hl
    simp only [Operation.interp, RelRegOrMem.interp]
    obtain ⟨ρ1, _, hv, hq⟩ := readReg_sound h hw
    exact done_sound h (by simpa [Term.wp, hv] using hq)
  | mem a =>
    simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
    obtain ⟨rfl, rfl⟩ := hl
    simp only [Operation.interp, RelRegOrMem.interp]
    simp only [Braid.wpOps_append] at hw
    obtain ⟨ρ1, _, ha, hw⟩ := wp_addr h hw
    x86_ops at hw
    obtain ⟨v, hl, hq⟩ := hw
    rw [ha] at hl
    refine load_sound (w := .W64) h hl fun e => ?_
    exact done_sound h (by simpa [Term.wp] using hq)

omit [Labels] in
/-- The return address is pushed, and the machine goes to `a`. -/
theorem pushRet_sound {s : MachineData} {σ : State} {ρ : Env} {Q : State → Prop} {tm : Term}
    {a : Int64} (h : RelD s σ)
    (hw : wpOps (pushRet p) ρ σ fun ρ σ' => tm.wp ρ σ' Q)
    (ht : ∀ ρ' σ', (∀ x : Nat, x < 8 → ρ' x = ρ x) → tm.wp ρ' σ' Q → Q (σ'.setPc a.toBitVec)) :
    (MachineData.store (w := .W64)
      { s with regs := s.regs.set64 .rsp (s.regs.get64 .rsp - Width.W64.bytesv) }
      (s.regs.get64 .rsp - Width.W64.bytesv) p.upper.toBitVec
      (fun s' => .done ⟨s', a⟩)).All fun m => ∃ σ', Rel m σ' ∧ Q σ' := by
  simp only [pushRet] at hw
  x86_ops at hw
  rw [h.regs .rsp] at hw
  obtain ⟨m, hs, hq⟩ := hw
  refine store_sound (w := .W64) (h.set64_eq .rsp rfl) (by simp) hs fun s' h' => ?_
  refine done_sound h' (ht _ _ (fun x hx => ?_) hq)
  have h8 : x ≠ 8 := by omega
  have h9 : x ≠ 9 := by omega
  have h10 : x ≠ 10 := by omega
  have h11 : x ≠ 11 := by omega
  simp [h8, h9, h10, h11]

theorem call_sound {w : Width} (tgt : RelRegOrMem) : OpSound p (.call tgt : Operation w) := by
  intro s σ ρ Q ops t h hl hw
  cases tgt with
  | rel c =>
    simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
    obtain ⟨rfl, rfl⟩ := hl
    simp only [Operation.interp, RelRegOrMem.interp]
    exact pushRet_sound h hw fun ρ' σ' _ hq => by simpa [Term.wp] using hq
  | reg r =>
    simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
    obtain ⟨rfl, rfl⟩ := hl
    simp only [Operation.interp, RelRegOrMem.interp]
    simp only [Braid.wpOps_append] at hw
    obtain ⟨ρ1, _, hv, hw⟩ := readReg_sound h hw
    exact pushRet_sound h hw fun ρ' σ' hag hq => by
      simpa [Term.wp, hag 0 (by decide), hv] using hq
  | mem a =>
    simp only [lowerOp, Option.some.injEq, Prod.mk.injEq] at hl
    obtain ⟨rfl, rfl⟩ := hl
    simp only [Operation.interp, RelRegOrMem.interp]
    simp only [Braid.wpOps_append] at hw
    obtain ⟨ρ1, _, ha, hw⟩ := wp_addr h hw
    x86_ops at hw
    obtain ⟨v, hl, hw⟩ := hw
    rw [ha] at hl
    refine load_sound (w := .W64) h hl fun e => ?_
    exact pushRet_sound h hw fun ρ' σ' hag hq => by
      simpa [Term.wp, hag 0 (by decide)] using hq

/-! ## Instructions -/

/-- **Every integer instruction is lowered soundly.** -/
theorem lowerOp_sound {w : Width} (i : Operation w) : OpSound p i := by
  cases i
  case mov dst src => exact mov_sound dst src
  case movzx dst src => exact movzx_sound dst src
  case movsx dst src => exact movsx_sound dst src
  case push src => exact push_sound src
  case pop dst => exact pop_sound dst
  case setcc cc dst => exact setcc_sound cc dst
  case cmovcc cc dst src => exact cmovcc_sound cc dst src
  case lea dst src => exact lea_sound dst src
  case add dst src => exact add_sound dst src
  case sub dst src => exact sub_sound dst src
  case cmp x y => exact cmp_sound x y
  case inc dst => exact inc_sound dst
  case dec dst => exact dec_sound dst
  case neg dst => exact neg_sound dst
  case not dst => exact not_sound dst
  case test x y => exact test_sound x y
  case and dst src => exact and_sound dst src
  case or dst src => exact or_sound dst src
  case xor dst src => exact xor_sound dst src
  case jcc cc l => exact jcc_sound cc l
  case jmp tgt => exact jmp_sound tgt
  case call tgt => exact call_sound tgt
  case ret => exact ret_sound
  case cld => exact cld_sound
  case std => exact std_sound
  case nop n => exact nop_sound n
  case nopalign a pad => exact nopalign_sound a pad
  case imul dst src1 src2 => exact imul_sound dst src1 src2
  case adc dst src => exact adc_sound dst src
  case sbb dst src => exact sbb_sound dst src
  case bswap dst => exact bswap_sound dst
  case mul src => exact mul_sound src
  case imul1 src => exact imul1_sound src
  case rol dst c =>
    cases c with
    | cl => intro s σ ρ Q ops t h hl hw; simp [lowerOp] at hl
    | imm8 c => exact rol_sound dst c
  case ror dst c =>
    cases c with
    | cl => intro s σ ρ Q ops t h hl hw; simp [lowerOp] at hl
    | imm8 c => exact ror_sound dst c
  case shld dst src c =>
    cases c with
    | cl => intro s σ ρ Q ops t h hl hw; simp [lowerOp] at hl
    | imm8 c => exact shld_sound dst src c
  case shrd dst src c =>
    cases c with
    | cl => intro s σ ρ Q ops t h hl hw; simp [lowerOp] at hl
    | imm8 c => exact shrd_sound dst src c
  case shl dst c =>
    cases c with
    | cl => exact shl_cl_sound dst
    | imm8 c => exact shl_sound dst c
  case shr dst c =>
    cases c with
    | cl => exact shr_cl_sound dst
    | imm8 c => exact shr_sound dst c
  case sar dst c =>
    cases c with
    | cl => exact sar_cl_sound dst
    | imm8 c => exact sar_sound dst c
  all_goals intro s σ ρ Q ops t h hl hw; simp [lowerOp] at hl

/-- **Every instruction is lowered soundly.** If the block of the instruction `i`, which
occupies the addresses `p`, runs without fault from a state related to the machine's and
establishes `Q`, then every outcome of `i` in the model is related to a state satisfying
`Q`. -/
theorem lower_sound {s : MachineData} {σ : State} {Q : State → Prop} {i : Instr}
    (h : RelD s σ) (hw : (lower p i).wp σ Q) :
    (i.interp s p (fun s' => .done ⟨s', p.upper⟩) (fun a s' => .done ⟨s', a⟩)).All
      fun m => ∃ σ', Rel m σ' ∧ Q σ' := by
  cases i with
  | regular asz w op =>
    simp only [Instr.interp, Effects.All]
    cases asz
    case W64 =>
      simp only [lower] at hw
      cases hl : lowerOp p op with
      | none => simp [hl, Block.wp, wpOps, Term.wp] at hw
      | some r =>
        obtain ⟨ops, t⟩ := r
        simp only [hl] at hw
        exact lowerOp_sound op h hl hw
    all_goals simp [lower, Block.wp, wpOps, Term.wp] at hw
  | avx asz w op => simp [lower, Block.wp, wpOps, Term.wp] at hw

/-- The block of the directives at an address is the lowering of what the model runs
there. -/
theorem lowerDirs_sound {s : MachineData} {σ : State} {Q : State → Prop} {pc : Int64}
    {ds : List (Kraken.Sized Directive)} {b : Block} (h : RelD s σ)
    (hb : lowerDirs pc ds = some b) (hw : b.wp σ Q) :
    (Directives.interp ds s pc fun pc s => .done ⟨s, pc⟩).All
      fun m => ∃ σ', Rel m σ' ∧ Q σ' := by
  induction ds with
  | nil => simp [lowerDirs] at hb
  | cons d ds ih =>
    obtain ⟨dir, sz⟩ := d
    cases dir with
    | instr i =>
      cases ds with
      | nil =>
        simp only [lowerDirs, Option.some.injEq] at hb
        subst hb
        simp only [Directives.interp, Directive.interp]
        exact lower_sound h hw
      | cons d' ds' => simp [lowerDirs] at hb
    | label l =>
      cases sz with
      | zero =>
        simp only [lowerDirs] at hb
        have h0 : pc + Int64.ofNat 0 = pc := by simp
        simp only [Directives.interp, Directive.interp, h0]
        exact ih hb
      | succ n => simp [lowerDirs] at hb
    | byteArray _ => simp [lowerDirs] at hb
    | word _ _ => simp [lowerDirs] at hb

end

/-! ## Programs -/

/-- **The x86-64 lowering is sound.** If every run of the lowered code of an executable from
`σ` reaches `Q`, then every run of the executable in the model, from a state related to `σ`,
reaches a state related to one satisfying `Q`. -/
theorem lowerProgram_sound [Layout] {e : Executable} {m : MachineState} {σ : State}
    {Q : State → Prop} (h : Rel m σ) (hw : Braid.Eventually (lowerProgram e) Q σ) :
    Eventually (step1 e) (fun m' => ∃ σ', Rel m' σ' ∧ Q σ') m := by
  induction hw generalizing m with
  | done σ hq => exact .done _ ⟨σ, h, hq⟩
  | step σ R hs _ ih =>
    obtain ⟨b, hb, hwp⟩ := hs
    have hpc : Int64.ofBitVec σ.pc = m.pc := by rw [h.pc]; rfl
    simp only [lowerProgram, hpc] at hb
    refine .step m (fun m' => ∃ σ', Rel m' σ' ∧ R σ') ?_ fun m' ⟨σ', h', hr⟩ => ih σ' hr h'
    exact @lowerDirs_sound (Executable.labels e) m.data σ R m.pc _ b h.data hb hwp

end Lowering.X86
