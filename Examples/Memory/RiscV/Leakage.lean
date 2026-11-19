/-
  Examples.Memory.RiscV.Leakage

  What `swap` reveals on RISC-V, as the pattern for a theorem about leakage
  (`docs/Leakage.md`). There are three statements, each from the one before:

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

public import Examples.Memory.RiscV.Proofs

public section

namespace Examples.Memory.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- What `swap` reveals: the two addresses, each read and then written, and where it
returns. -/
def swapLeak (p q r : Word) : Trace :=
  [.read q 8, .read p 8, .write p 8, .write q 8, .jump (r &&& ~~~1#64)]

/-- `swap` exchanges two words and reveals `swapLeak` of their addresses. -/
theorem swap_trace (p q x y t2 t3 r : Word) (hp : p &&& 7#64 = 0#64) (hq : q &&& 7#64 = 0#64)
    (t : Trace) :
    TripleT swap.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 p, .reg a1 q, .reg a2 t2, .reg a3 t3,
        .mem p 8 x true, .mem q 8 y true, .reg ra r]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 p, .reg a1 q, .reg a2 y, .reg a3 x,
        .mem p 8 y true, .mem q 8 x true, .reg ra r]) (t ++ swapLeak p q r) := by
  braid_sym_run
  braid_done

/-- **What `swap` reveals, on the machine.** A machine that holds the code of `swap`, is at
its entry, and has a word at each of the two aligned, distinct addresses in `a0` and `a1`,
runs to the return address with the trace `swapLeak` of those addresses and the return
address. -/
theorem swap_leakage (s : MachineState) (x y : Word)
    (hcode : ∀ p ∈ swap_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hp : s.getReg .x10 &&& 7#64 = 0#64) (hq : s.getReg .x11 &&& 7#64 = 0#64)
    (hne : s.getReg .x10 ≠ s.getReg .x11)
    (hx : HasBytes s (s.getReg .x10) 8 x) (hy : HasBytes s (s.getReg .x11) 8 y) :
    ∃ s', RunL s (swapLeak (s.getReg .x10) (s.getReg .x11) (s.getReg .x1)) s' ∧
      s'.pc = s.getReg .x1 &&& ~~~1#64 := by
  have hd : Atom.Disj (.mem (s.getReg .x10) 8 x true) (.mem (s.getReg .x11) 8 y true) := by
    refine Atom.disj_mem_mem fun a ⟨h1, h2⟩ => ?_
    have h1' : a - s.getReg .x10 < 8#64 := by simpa [BitVec.lt_def] using h1
    have h2' : a - s.getReg .x11 < 8#64 := by simpa [BitVec.lt_def] using h2
    bv_decide
  obtain ⟨s', σ', hrun, hr, hpost⟩ := machine_soundT swap_lowered
    (swap_trace (s.getReg .x10) (s.getReg .x11) x y (s.getReg .x12) (s.getReg .x13)
      (s.getReg .x1) hp hq []) hcode rfl
    (by simp [Atom.IsPointsTo]) (by braid_disj; simp only [hd, and_true]; decide)
    (by simp only [List.forall_mem_cons, sat_mem_abs]
        simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, hx, hy])
  refine ⟨s', hrun, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hpost (by braid_at)

/-- **`swap` reveals nothing of the words it exchanges.** Two machines that hold the code of
`swap`, are at its entry, and agree on the two addresses and on the return address, run with
the same trace, whatever words are at the addresses. -/
theorem swap_leakage_eq (s₁ s₂ : MachineState) (x₁ y₁ x₂ y₂ : Word)
    (hcode₁ : ∀ p ∈ swap_code, s₁.code p.1 = some p.2)
    (hcode₂ : ∀ p ∈ swap_code, s₂.code p.1 = some p.2)
    (hpc₁ : s₁.pc = 0x10000#64) (hpc₂ : s₂.pc = 0x10000#64)
    (hp : s₁.getReg .x10 &&& 7#64 = 0#64) (hq : s₁.getReg .x11 &&& 7#64 = 0#64)
    (hne : s₁.getReg .x10 ≠ s₁.getReg .x11)
    (hx₁ : HasBytes s₁ (s₁.getReg .x10) 8 x₁) (hy₁ : HasBytes s₁ (s₁.getReg .x11) 8 y₁)
    (hx₂ : HasBytes s₂ (s₂.getReg .x10) 8 x₂) (hy₂ : HasBytes s₂ (s₂.getReg .x11) 8 y₂)
    (e10 : s₂.getReg .x10 = s₁.getReg .x10) (e11 : s₂.getReg .x11 = s₁.getReg .x11)
    (e1 : s₂.getReg .x1 = s₁.getReg .x1) :
    ∃ tr s₁' s₂', RunL s₁ tr s₁' ∧ RunL s₂ tr s₂' ∧
      s₁'.pc = s₁.getReg .x1 &&& ~~~1#64 ∧ s₂'.pc = s₁.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨s₁', h₁, hp₁⟩ := swap_leakage s₁ x₁ y₁ hcode₁ hpc₁ hp hq hne hx₁ hy₁
  obtain ⟨s₂', h₂, hp₂⟩ := swap_leakage s₂ x₂ y₂ hcode₂ hpc₂ (e10 ▸ hp) (e11 ▸ hq)
    (by rw [e10, e11]; exact hne) hx₂ hy₂
  simp only [e10, e11, e1] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.Memory.RiscV
