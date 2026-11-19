/-
  Lowering.RiscV.LeakSound

  The RISC-V lowering preserves traces: the labels the block of an instruction emits are the
  labels of the instruction (`Lowering.RiscV.Leak`), so a labelled run of the lowered code is
  a run of the machine with the same trace.

  ## Main results

  * `leak_lower`: the labels of a lowered instruction are those of the instruction
  * `lowerCode_soundL`: every labelled run, `EventuallyL` to `RunL`
  * `RunL.stepN`: a run with a trace is a run
-/

module

public import Lowering.RiscV.Sound
public import Lowering.RiscV.Leak

public section

namespace Lowering.RiscV

open Braid hiding Reg
open RiscvZkvm.Rv64

variable {s : MachineState} {σ : State}

theorem rget_next (h : Rel s σ) (d : Var) (r : Reg) (ρ : Env) (x : Word) :
    (rget d r).next ρ σ x = (ρ.set d (s.getReg r), σ) := by
  unfold rget
  split
  · subst_vars; rfl
  · rename_i hr
    simp only [Op.next, h.regs r hr, getReg_eq hr]

@[simp] theorem rget_leak (d : Var) (r : Reg) (ρ : Env) : (rget d r).leak ρ = [] := by
  unfold rget; split <;> rfl

@[simp] theorem runOps_rset_env (r : Reg) (a : Var) (ρ : Env) (σ : State) (hv : Nat → Word) :
    (runOps (rset r a) ρ σ hv).1 = ρ := by
  unfold rset; split <;> rfl

@[simp] theorem runOps_rset_leak (r : Reg) (a : Var) (ρ : Env) (σ : State) (hv : Nat → Word) :
    (runOps (rset r a) ρ σ hv).2.2 = [] := by
  unfold rset; split <;> rfl

/-- **The labels of a lowered instruction are those of the instruction.** -/
theorem leak_lower (h : Rel s σ) (i : Instr) (hv : Nat → Word) :
    (lower s.pc i).leak σ hv = leak s i := by
  cases i <;>
    simp [lower, binRR, binRI, shiftRR, binW, addrOps, loadI, storeI, branchI, divI,
      Block.leak, runOps_cons, rget_next h, leak, ea, target, BinOp.leaks]
  case BGE rs1 rs2 off => cases (s.getReg rs1).slt (s.getReg rs2) <;> rfl
  case BGEU rs1 rs2 off => cases (s.getReg rs1).ult (s.getReg rs2) <;> rfl

/-- **The RISC-V lowering preserves traces.** If every labelled run of the lowered code of a
machine reaches `Q`, the machine runs, with some trace, to a state and that trace added to
the one it started after, of which `Q` holds. -/
theorem lowerCode_soundL {code : Word → Option Instr} {Q : State → Trace → Prop} {t : Trace}
    (hc : s.code = code) (h : Rel s σ) (hw : EventuallyL (lowerCode code) Q σ t) :
    ∃ s' σ' tr, RunL s tr s' ∧ Rel s' σ' ∧ Q σ' (t ++ tr) := by
  induction hw generalizing s with
  | done σ t hq => exact ⟨s, σ, [], .refl s, h, by simpa using hq⟩
  | step σ t R hs _ ih =>
    obtain ⟨b, hb, hwp⟩ := hs
    simp only [lowerCode, Option.map_eq_some_iff] at hb
    obtain ⟨i, hi, rfl⟩ := hb
    rw [h.pc] at hi hwp
    obtain ⟨s₁, σ₁, hstep, h₁, hv, hr⟩ := lower_sound h (hc ▸ hi) (Block.wp_of_wpL hwp)
    rw [leak_lower h] at hr
    obtain ⟨s', σ', tr, hrun, h', hq⟩ := ih σ₁ _ hr ((code_step hstep).trans hc) h₁
    exact ⟨s', σ', leak s i ++ tr, .step (hc ▸ hi) hstep hrun, h',
      by rw [← List.append_assoc]; exact hq⟩

/-- A run with a trace is a run. -/
theorem RunL.stepN {s s' : MachineState} {tr : Trace} (h : RunL s tr s') :
    ∃ n, stepN n s = some s' := by
  induction h with
  | refl s => exact ⟨0, rfl⟩
  | step _ hstep _ ih =>
    obtain ⟨n, hn⟩ := ih
    exact ⟨n + 1, by simp [RiscvZkvm.Rv64.stepN, hstep, hn]⟩

end Lowering.RiscV
