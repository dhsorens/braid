/-
  Lowering.RiscV.Env

  RISC-V with its environment. `lower` gives `ECALL` a `trap`, since a theorem about a
  function has no use for it. A whole program ends in one, and writes its result out by
  another, so this file lowers `ECALL` to the two events of the environment the model has
  (`Lowering.RiscV.Leak`): with `t0 = 0x10` the `a1` bytes at `a0` are written out, and with
  `t0 = 0` the program exits with the code in `a0`. Any other call faults. The lowering with
  `ECALL` read this way is `lowerEnv`, and it is proved to preserve traces as `lower` is.

  ## Main definitions

  * `ecall`: the block of `ECALL`
  * `lowerEnv`, `lowerCodeEnv`: the lowering with `ECALL` as the environment's two calls

  ## Main results

  * `ecall_sound`: the block of `ECALL` against the model and the reading of its events
  * `lowerCodeEnv_soundL`: every labelled run, `EventuallyL` to `RunL`
-/

module

public import Lowering.RiscV.LeakSound

@[expose] public section

namespace Lowering.RiscV

open Braid hiding Reg
open RiscvZkvm.Rv64

/-- The block of `ECALL` at `pc`. Value 2 is whether the call is the exit (`t0 = 0`) and
value 4 whether it is the write (`t0 = 0x10`); it is one of the two. Value 8 is the number of
bytes written out, `a1` for the write and none for the exit, and it is at most the model's
bound on an output. An exit stays at `pc`. -/
def ecall (pc : Word) : Block :=
  ⟨[.get 0 5, .const 1 0, .bin 2 .eq 0 1, .const 3 0x10, .bin 4 .eq 0 3, .bin 5 .or 2 4,
    .guard 5, .get 6 10, .get 7 11, .select 8 4 7 1, .const 9 0x1000000, .bin 10 .ule 8 9,
    .guard 10, .out 6 8],
   .exit 2 6 pc (pc + 4)⟩

/-- The block of an instruction at `pc`, with `ECALL` as a call of the environment. -/
def lowerEnv (pc : Word) : Instr → Block
  | .ECALL => ecall pc
  | i => lower pc i

/-- The program of a machine's code, with `ECALL` as a call of the environment. -/
def lowerCodeEnv (code : Word → Option Instr) : Program :=
  fun a => (code a).map (lowerEnv a)

variable {s : MachineState} {σ : State}

/-- Bytes the dialect reads from memory are the bytes the machine reads, at valid
addresses. -/
theorem bytes_eq_readBytes (h : Rel s σ) {a : Word} {n : Nat} {bs : List (BitVec 8)}
    (hb : σ.mem.bytes a n = some bs) :
    bs = s.readBytes a n ∧ ∀ i < n, isValidMemAddr (a + BitVec.ofNat 64 i) = true := by
  induction n generalizing a bs with
  | zero =>
    simp only [Mem.bytes, Option.some.injEq] at hb
    exact ⟨hb ▸ rfl, fun _ hi => absurd hi (Nat.not_lt_zero _)⟩
  | succ n ih =>
    simp only [Mem.bytes, h.mem a] at hb
    split at hb
    · rename_i c bs' hc hbs
      split at hc
      · rename_i hv
        cases hc
        cases hb
        obtain ⟨e, hvs⟩ := ih hbs
        refine ⟨by simp only [MachineState.readBytes, e], fun i hi => ?_⟩
        cases i with
        | zero => simpa using hv
        | succ i =>
          have := hvs i (by omega)
          have e' : a + BitVec.ofNat 64 (i + 1) = a + 1 + BitVec.ofNat 64 i := by bv_omega
          rw [e']; exact this
      · cases hc
    · cases hb

/-- A run of valid addresses, no longer than the model's bound on an output, is a range the
model accepts for an output: it cannot cross from one zone of memory into another. -/
theorem isValidOutputRange_of {a : Word} {n : Nat}
    (hv : ∀ i < n, isValidMemAddr (a + BitVec.ofNat 64 i) = true) (hn : n ≤ 0x1000000) :
    isValidOutputRange a n = true := by
  simp only [isValidOutputRange, MAX_OUTPUT_BYTES, Bool.and_eq_true, Bool.or_eq_true]
  refine ⟨decide_eq_true hn, ?_⟩
  rcases Nat.eq_zero_or_pos n with h0 | hpos
  · exact .inl (decide_eq_true h0)
  · right
    have h1 := hv 0 hpos
    have h2 := hv (n - 1) (by omega)
    simp only [isValidMemAddr, MEM_START, MEM_END, INPUT_MEM_START, INPUT_MEM_END,
      RAM_MEM_START, RAM_MEM_END, Bool.or_eq_true, Bool.and_eq_true, decide_eq_true_eq]
      at h1 h2 ⊢
    have e1 : (a + BitVec.ofNat 64 0).toNat = a.toNat := by simp
    have e2 : (a + BitVec.ofNat 64 (n - 1)).toNat = a.toNat + (n - 1) := by
      rw [e1] at h1
      rw [BitVec.toNat_add, BitVec.toNat_ofNat]
      omega
    rw [e1] at h1
    rw [e2] at h2
    by_cases hx : a.toNat ≤ 0x78000000 ∧ 0xa0000000 ≤ a.toNat + (n - 1)
    · have h3 := hv (0x78000001 - a.toNat) (by omega)
      have e3 : (a + BitVec.ofNat 64 (0x78000001 - a.toNat)).toNat = 0x78000001 := by
        rw [BitVec.toNat_add, BitVec.toNat_ofNat]
        omega
      simp only [isValidMemAddr, MEM_START, MEM_END, INPUT_MEM_START, INPUT_MEM_END,
        RAM_MEM_START, RAM_MEM_END, Bool.or_eq_true, Bool.and_eq_true, decide_eq_true_eq,
        e3] at h3
      omega
    · omega

/-- **The block of `ECALL`, against the model.** If the block runs after the trace `t` and
establishes `R`, then either the machine is at the halting call and `R` holds of the state as
it is with the exit event added to the trace, or the machine takes its step into a related
state of which `R` holds with the labels of the instruction added. -/
theorem ecall_sound {t : Trace} {R : State → Trace → Prop} (h : Rel s σ)
    (hf : s.code s.pc = some .ECALL) (hw : (ecall s.pc).wpL σ t R) :
    (s.getReg .x5 = 0#64 ∧ R σ (t ++ [.event (.exit (s.getReg .x10))])) ∨
    ∃ s₁ σ₁, covered s .ECALL = true ∧ step s = some s₁ ∧ Rel s₁ σ₁ ∧
      R σ₁ (t ++ leak s .ECALL) := by
  have r5 : σ.regs 5 = s.getReg .x5 := by rw [getReg_eq (by decide)]; exact h.regs .x5 (by decide)
  have r10 : σ.regs 10 = s.getReg .x10 := by
    rw [getReg_eq (by decide)]; exact h.regs .x10 (by decide)
  have r11 : σ.regs 11 = s.getReg .x11 := by
    rw [getReg_eq (by decide)]; exact h.regs .x11 (by decide)
  simp [ecall, Block.wpL, wpOpsL, Op.wpL, Op.wp, Term.wpL, Term.wp, Op.leak, Term.leak,
    BinOp.leaks, Env.set, r5, r10, r11] at hw
  obtain ⟨hd, hle, ⟨bs, hbs⟩, hr⟩ := hw
  by_cases h0 : s.getReg .x5 = 0#64
  · left
    have e : σ.setPc s.pc = σ := by rw [← h.pc]; rfl
    refine ⟨h0, ?_⟩
    simpa [h0, e] using hr
  · right
    have h16 := hd h0
    simp only [h16, ↓reduceIte] at hle hbs hr
    obtain ⟨e, hv⟩ := bytes_eq_readBytes h hbs
    have hrange := isValidOutputRange_of hv (by
      have := BitVec.ule_iff_toNat_le.1 hle
      simpa using this)
    refine ⟨(s.writeOutput (s.getReg .x10) (s.getReg .x11)).setPC (s.pc + 4),
      σ.setPc (s.pc + 4), by simp [covered, h16], ?_, ⟨?_, rfl, ?_⟩, ?_⟩
    · simp [step, hf, h16, hrange]
    · exact h.regs
    · exact h.mem
    · simpa [leak, h16, hbs, e, h0] using hr

theorem lowerEnv_of_ne {pc : Word} {i : Instr} (h : i ≠ .ECALL) : lowerEnv pc i = lower pc i := by
  cases i <;> first | rfl | exact absurd rfl h

/-- **The RISC-V lowering with its environment preserves traces.** If every labelled run of
the lowered code of a machine reaches `Q`, the machine runs, with some trace, to a state and
that trace added to the one it started after, of which `Q` holds. -/
theorem lowerCodeEnv_soundL {code : Word → Option Instr} {Q : State → Trace → Prop} {t : Trace}
    (hc : s.code = code) (h : Rel s σ) (hw : EventuallyL (lowerCodeEnv code) Q σ t) :
    ∃ s' σ' tr, RunL s tr s' ∧ Rel s' σ' ∧ Q σ' (t ++ tr) := by
  induction hw generalizing s with
  | done σ t hq => exact ⟨s, σ, [], .refl s, h, by simpa using hq⟩
  | step σ t R hs _ ih =>
    obtain ⟨b, hb, hwp⟩ := hs
    simp only [lowerCodeEnv, Option.map_eq_some_iff] at hb
    obtain ⟨i, hi, rfl⟩ := hb
    rw [h.pc] at hi hwp
    by_cases hne : i = .ECALL
    · subst hne
      rcases ecall_sound h (hc ▸ hi) hwp with ⟨h0, hr⟩ | ⟨s₁, σ₁, hcov, hstep, h₁, hr⟩
      · obtain ⟨s', σ', tr, hrun, h', hq⟩ := ih σ _ hr hc h
        exact ⟨s', σ', _, .halt (hc ▸ hi) h0 hrun, h', by simpa using hq⟩
      · obtain ⟨s', σ', tr, hrun, h', hq⟩ := ih σ₁ _ hr ((code_step hstep).trans hc) h₁
        exact ⟨s', σ', leak s .ECALL ++ tr, .step (hc ▸ hi) hcov hstep hrun, h',
          by rw [← List.append_assoc]; exact hq⟩
    · rw [lowerEnv_of_ne hne] at hwp
      obtain ⟨s₁, σ₁, hstep, h₁, hv, hr⟩ := lower_sound h (hc ▸ hi) (Block.wp_of_wpL hwp)
      rw [leak_lower h i hne] at hr
      obtain ⟨s', σ', tr, hrun, h', hq⟩ := ih σ₁ _ hr ((code_step hstep).trans hc) h₁
      have hcov : covered s i = true := by
        cases i <;>
          first
          | rfl
          | exact absurd rfl hne
          | exact absurd (Block.wp_of_wpL hwp) (by simp [lower, Block.wp, wpOps, Term.wp])
      exact ⟨s', σ', leak s i ++ tr, .step (hc ▸ hi) hcov hstep hrun, h',
        by rw [← List.append_assoc]; exact hq⟩

end Lowering.RiscV
