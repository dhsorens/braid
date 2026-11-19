/-
  Examples.Memory.Arm.Leakage

  What `swap` reveals on AArch64 (`docs/Leakage.md`), in three statements, each from the one
  before, as on RISC-V:

  * `swap_trace`: a traced triple. From any trace `t`, the code runs to `t` and then the
    labels `swapLeak` gives.
  * `swap_leakage`: the same about the machine alone. The trace of the run is `swapLeak` of
    the two addresses and the return address.
  * `swap_leakage_eq`: two machines that agree on those three values, whatever is in memory,
    run with the same trace.

  `swapLeak` takes the public inputs and nothing else, so that it does not mention the words
  swapped is visible in its type.
-/

module

public import Examples.Memory.Arm.Proofs

public section

namespace Examples.Memory.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- What `swap` reveals: the two addresses, each read and then written, and where it
returns. -/
def swapLeak (p q r : Word) : Trace :=
  [.read q 8, .read p 8, .write p 8, .write q 8, .jump r]

/-- `swap` exchanges two words and reveals `swapLeak` of their addresses. -/
theorem swap_trace (p q x y t8 t9 r : Word) (t : Trace) :
    TripleT swap.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 p, .reg x1 q, .reg x8 t8, .reg x9 t9,
        .mem p 8 x true, .mem q 8 y true, .reg lr r]) t
      (Atoms.interp [.pc r, .reg x0 p, .reg x1 q, .reg x8 y, .reg x9 x,
        .mem p 8 y true, .mem q 8 x true, .reg lr r]) (t ++ swapLeak p q r) := by
  braid_sym_run
  braid_done

/-- **What `swap` reveals, on the machine.** A running machine whose program holds the words
of `swap`, with its code loaded and its program counter at the entry, and with a word in
memory where each of `x0` and `x1` points, apart from one another, runs to the address in the
link register with the trace `swapLeak` of the two addresses and the link register. -/
theorem swap_leakage (prog : Arm64.Program) (s : Arm64.State) (x y : Word)
    (hw : prog.hasWords 0x10000#64 swap_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64)
    (hx : HasBytes s (s.regs.read 0#5) 8 x) (hy : HasBytes s (s.regs.read 1#5) 8 y)
    (hd : Apart (s.regs.read 0#5) 8 (s.regs.read 1#5) 8) :
    ∃ s', RunL prog s (swapLeak (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5)) s' ∧
      s'.pc = s.regs.read 30#5 := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_soundT swap_lowered
    (swap_trace (s.regs.read 0#5) (s.regs.read 1#5) x y (s.regs.read 8#5) (s.regs.read 9#5)
      (s.regs.read 30#5) []) hw hc hrun rfl
    (by simp [Atom.IsPointsTo]) (by braid_disj_mem; exact disj_mem_of_apart hd)
    (by simp [Atom.sat_reg, Atom.sat_pc, sat_mem_hasBytes, regOf, hpc, hx, hy])
  refine ⟨s', hsteps, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`swap` reveals nothing of the words it exchanges.** Two running machines that hold the
words of `swap`, with their code loaded and at its entry, and that agree on the two
addresses and on the link register, run with the same trace, whatever words are at the
addresses. -/
theorem swap_leakage_eq (prog₁ prog₂ : Arm64.Program) (s₁ s₂ : Arm64.State)
    (x₁ y₁ x₂ y₂ : Word)
    (hw₁ : prog₁.hasWords 0x10000#64 swap_words) (hc₁ : prog₁.CodeLoaded s₁.mem)
    (hw₂ : prog₂.hasWords 0x10000#64 swap_words) (hc₂ : prog₂.CodeLoaded s₂.mem)
    (hrun₁ : s₁.status = .Running) (hrun₂ : s₂.status = .Running)
    (hpc₁ : s₁.pc = 0x10000#64) (hpc₂ : s₂.pc = 0x10000#64)
    (hx₁ : HasBytes s₁ (s₁.regs.read 0#5) 8 x₁) (hy₁ : HasBytes s₁ (s₁.regs.read 1#5) 8 y₁)
    (hx₂ : HasBytes s₂ (s₂.regs.read 0#5) 8 x₂) (hy₂ : HasBytes s₂ (s₂.regs.read 1#5) 8 y₂)
    (hd : Apart (s₁.regs.read 0#5) 8 (s₁.regs.read 1#5) 8)
    (e0 : s₂.regs.read 0#5 = s₁.regs.read 0#5) (e1 : s₂.regs.read 1#5 = s₁.regs.read 1#5)
    (e30 : s₂.regs.read 30#5 = s₁.regs.read 30#5) :
    ∃ tr s₁' s₂', RunL prog₁ s₁ tr s₁' ∧ RunL prog₂ s₂ tr s₂' ∧
      s₁'.pc = s₁.regs.read 30#5 ∧ s₂'.pc = s₁.regs.read 30#5 := by
  obtain ⟨s₁', h₁, hp₁⟩ := swap_leakage prog₁ s₁ x₁ y₁ hw₁ hc₁ hrun₁ hpc₁ hx₁ hy₁ hd
  obtain ⟨s₂', h₂, hp₂⟩ := swap_leakage prog₂ s₂ x₂ y₂ hw₂ hc₂ hrun₂ hpc₂ hx₂ hy₂
    (by rw [e0, e1]; exact hd)
  simp only [e0, e1, e30] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.Memory.Arm
