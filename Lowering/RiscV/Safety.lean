/-
  Lowering.RiscV.Safety

  Memory safety of whole runs, from the trace of one complete run. The trace of a run of the
  machine (`Lowering.RiscV.Leak`) records every store with its address and its size, and the
  machine is deterministic. So the trace of one run that reaches the halt bounds what every
  state the machine passes through can have changed in memory: a byte that no `write` label
  of that trace covers still has the value it started with.

  ## Main results

  * `step_getByte`: one step changes no byte outside the `write` labels of its instruction
  * `RunL.getByte`: a run changes no byte outside the `write` labels of its trace
  * `RunL.mem_of_halted`: every label of a run from `s` is a label of the complete run from
    `s`, or an exit
  * `RunL.safe`: no store outside `inside`, of every reachable state
-/

module

public import Lowering.RiscV.LeakSound

public section

namespace Lowering.RiscV

open Braid hiding Reg
open RiscvZkvm.Rv64

/-! ## One step -/

/-- The bytes of a state are those of its memory. -/
theorem getByte_congr {s s' : MachineState} (h : s'.mem = s.mem) (a : Word) :
    s'.getByte a = s.getByte a := by
  simp only [getByte_eq, h]

theorem and_of_mod8 {a : Word} (h : a.toNat % 8 = 0) : a &&& 7#64 = 0#64 := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and]
  exact (Nat.and_two_pow_sub_one_eq_mod a.toNat 3).trans h

theorem and_of_mod4 {a : Word} (h : a.toNat % 4 = 0) : a &&& 3#64 = 0#64 := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and]
  exact (Nat.and_two_pow_sub_one_eq_mod a.toNat 2).trans h

theorem and_of_mod2 {a : Word} (h : a.toNat % 2 = 0) : a &&& 1#64 = 0#64 := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and]
  exact (Nat.and_two_pow_sub_one_eq_mod a.toNat 1).trans h

theorem mem_setPC (s : MachineState) (v : Word) : (s.setPC v).mem = s.mem := rfl

theorem mem_setReg (s : MachineState) (r : Reg) (v : Word) : (s.setReg r v).mem = s.mem := by
  cases r <;> rfl

/-- Whether the instruction is a store. -/
def isStore : Instr → Bool
  | .SD .. | .SW .. | .SH .. | .SB .. => true
  | _ => false

/-- An instruction that is neither a store nor an accelerator call leaves memory alone. -/
theorem mem_execInstrBr (s : MachineState) {i : Instr} (hs : isStore i = false)
    (hc : covered s i = true) : (execInstrBr s i).mem = s.mem := by
  cases i
  case SD => cases hs
  case SW => cases hs
  case SH => cases hs
  case SB => cases hs
  case CSRS => cases hc
  all_goals
    first
      | rfl
      | exact mem_setReg _ _ _
      | (simp only [execInstrBr]; split <;> rfl)

/-- **One step changes no byte outside the `write` labels of its instruction.** Of the
instructions `leak` covers, only the stores change memory, and each has its `write` label. -/
theorem step_getByte {s s₁ : MachineState} {i : Instr} {a : Word}
    (hf : s.code s.pc = some i) (hc : covered s i = true) (hs : step s = some s₁)
    (hw : ∀ b n, Label.write b n ∈ leak s i → ¬ (a - b).toNat < n) :
    s₁.getByte a = s.getByte a := by
  cases i
  case CSRS => cases hc
  case EBREAK => simp [step, hf] at hs
  case SD rs1 rs2 off =>
    simp only [step, hf, isValidDwordAccess, isAligned8, Bool.and_eq_true, beq_iff_eq] at hs
    split at hs
    · rename_i hv
      cases hs
      have h := getByte_setMem s (s.getReg rs2) a (and_of_mod8 hv.2)
      have hn : ¬ (a - (s.getReg rs1 + signExtend12 off)).toNat < 8 :=
        hw _ 8 (by simp [leak, ea])
      simp only [hn, ↓reduceIte] at h
      exact (getByte_congr rfl a).trans h
    · cases hs
  case SW rs1 rs2 off =>
    simp only [step, hf, isValidMemAccess, isAligned4, Bool.and_eq_true, beq_iff_eq] at hs
    split at hs
    · rename_i hv
      cases hs
      have h := getByte_setWord32 s (s.getReg rs2) a (and_of_mod4 hv.2)
      have hn : ¬ (a - (s.getReg rs1 + signExtend12 off)).toNat < 4 :=
        hw _ 4 (by simp [leak, ea])
      simp only [hn, ↓reduceIte] at h
      exact (getByte_congr rfl a).trans h
    · cases hs
  case SH rs1 rs2 off =>
    simp only [step, hf, isValidHalfwordAccess, isAligned2, Bool.and_eq_true, beq_iff_eq] at hs
    split at hs
    · rename_i hv
      cases hs
      have h := getByte_setHalfword s (s.getReg rs2) a (and_of_mod2 hv.2)
      have hn : ¬ (a - (s.getReg rs1 + signExtend12 off)).toNat < 2 :=
        hw _ 2 (by simp [leak, ea])
      simp only [hn, ↓reduceIte] at h
      exact (getByte_congr rfl a).trans h
    · cases hs
  case SB rs1 rs2 off =>
    simp only [step, hf] at hs
    split at hs
    · cases hs
      have h := getByte_setByte s (s.getReg rs1 + signExtend12 off) (s.getReg rs2) a
      have hn : ¬ (a - (s.getReg rs1 + signExtend12 off)).toNat < 1 :=
        hw _ 1 (by simp [leak, ea])
      simp only [hn, ↓reduceIte] at h
      exact (getByte_congr rfl a).trans h
    · cases hs
  case ECALL =>
    have h5 : s.getReg .x5 = 0x10#64 := by simpa [covered] using hc
    cases hr : isValidOutputRange (s.getReg .x10) (s.getReg .x11).toNat
    · rw [step_ecall_write_output_trap hf h5 hr] at hs; cases hs
    · rw [step_ecall_write_output hf h5 hr] at hs; cases hs; exact getByte_congr rfl a
  all_goals
    simp only [step, hf] at hs
    first
      | (cases hs; exact getByte_congr (mem_execInstrBr _ rfl rfl) a)
      | (split at hs
         · cases hs; exact getByte_congr (mem_execInstrBr _ rfl rfl) a
         · cases hs)

/-! ## Runs -/

/-- **A run changes no byte outside the `write` labels of its trace.** -/
theorem RunL.getByte {s s' : MachineState} {tr : Trace} {a : Word} (h : RunL s tr s')
    (hw : ∀ b n, Label.write b n ∈ tr → ¬ (a - b).toNat < n) :
    s'.getByte a = s.getByte a := by
  induction h with
  | refl => rfl
  | step hf hc hs _ ih =>
    exact (ih fun b n hm => hw b n (List.mem_append_right _ hm)).trans
      (step_getByte hf hc hs fun b n hm => hw b n (List.mem_append_left _ hm))
  | halt _ _ _ ih => exact ih fun b n hm => hw b n (List.mem_cons_of_mem _ hm)

/-- A halted machine stays where it is, and a run from it records only exits. -/
theorem RunL.of_halted {s s' : MachineState} {tr : Trace} (h : RunL s tr s')
    (hf : s.code s.pc = some .ECALL) (h5 : s.getReg .x5 = 0#64) :
    s' = s ∧ ∀ l ∈ tr, ∃ c, l = .event (.exit c) := by
  induction h with
  | refl => exact ⟨rfl, fun _ hl => nomatch hl⟩
  | step _ _ hs _ _ => rw [step_ecall_halt hf h5] at hs; cases hs
  | halt _ _ _ ih =>
    obtain ⟨rfl, ht⟩ := ih hf h5
    refine ⟨rfl, fun l hl => ?_⟩
    rcases List.mem_cons.1 hl with rfl | hl
    · exact ⟨_, rfl⟩
    · exact ht l hl

/-- **The machine is deterministic up to the halt.** Given a run from `s` that ends halted,
every label of any other run from `s` is a label of that run, or an exit. -/
theorem RunL.mem_of_halted {s sf s' : MachineState} {tr tr' : Trace} (h : RunL s tr sf)
    (hf : sf.code sf.pc = some .ECALL) (h5 : sf.getReg .x5 = 0#64) (h' : RunL s tr' s') :
    ∀ l ∈ tr', l ∈ tr ∨ ∃ c, l = .event (.exit c) := by
  induction h generalizing tr' s' with
  | refl => exact fun l hl => .inr ((h'.of_halted hf h5).2 l hl)
  | @step s s₁ s₂ i tr hi _ hs _ ih =>
    cases h' with
    | refl => exact fun _ hl => nomatch hl
    | step hi' _ hs' hr' =>
      obtain rfl := Option.some.inj (hi.symm.trans hi')
      obtain rfl := Option.some.inj (hs.symm.trans hs')
      intro l hl
      rcases List.mem_append.1 hl with hl | hl
      · exact .inl (List.mem_append_left _ hl)
      · exact (ih hf h5 hr' l hl).imp (List.mem_append_right _) id
    | halt hi' h5' _ => rw [step_ecall_halt hi' h5'] at hs; cases hs
  | halt hi h5' _ _ => exact fun l hl => .inr ((h'.of_halted hi h5').2 l hl)

/-- **No store outside `inside`**, stated of every reachable state. Take one complete run
from `s`: a run that ends at the halting `ECALL`. If every `write` label of its trace lies
inside `inside`, then every state the machine passes through from `s` has the memory outside
`inside` as it was in `s`. -/
theorem RunL.safe {s sf : MachineState} {tr : Trace} {inside : Word → Prop}
    (h : RunL s tr sf) (hf : sf.code sf.pc = some .ECALL) (h5 : sf.getReg .x5 = 0#64)
    (hw : ∀ b n, Label.write b n ∈ tr → ∀ a, (a - b).toNat < n → inside a) :
    ∀ s', Reachable s s' → ∀ a, ¬ inside a → s'.getByte a = s.getByte a := by
  rintro s' ⟨tr', h'⟩ a ha
  refine h'.getByte fun b n hm hlt => ha ?_
  rcases h.mem_of_halted hf h5 h' _ hm with hm | ⟨c, hc⟩
  · exact hw b n hm a hlt
  · cases hc

end Lowering.RiscV
