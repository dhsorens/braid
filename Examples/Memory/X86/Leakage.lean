/-
  Examples.Memory.X86.Leakage

  What `swap` reveals on x86-64, as the pattern for a theorem about leakage there
  (`docs/Leakage.md`). There are three statements, each from the one before:

  * `swap_trace`: a traced triple. From any trace `t`, the code runs to `t` and then the
    labels `swapLeak` gives.
  * `swap_leakage`: the same about the machine alone. Every run has the trace `swapLeak` of
    the two addresses, the stack pointer and the return address.
  * `swap_leakage_eq`: two machines that agree on those four values, whatever is in memory
    at the two addresses, run with the same trace.

  On x86-64 the return address is a word on the stack, so `ret` reveals the stack pointer,
  by the load, and the return address, by the jump. `swapLeak` takes those and the two
  addresses and nothing else, so that it does not mention the words swapped is visible in
  its type.
-/

module

public import Examples.Memory.X86.Proofs

public section

namespace Examples.Memory.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- What `swap` reveals: the two addresses, each read and then written, the stack pointer,
where the return address is read, and the return address, where it goes. -/
def swapLeak (p q s r : Word) : Trace :=
  [.read p 8, .read q 8, .write p 8, .write q 8, .read s 8, .jump r]

/-- `swap` exchanges two words and reveals `swapLeak` of their addresses, the stack pointer
and the return address. -/
theorem swap_trace (p q x y t0 t1 s r : Word) (t : Trace) :
    TripleT swap.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi p, .reg rsi q, .reg rax t0, .reg rcx t1,
        .mem p 8 x true, .mem q 8 y true, .reg rsp s, .mem s 8 r true]) t
      (Atoms.interp [.pc r, .reg rdi p, .reg rsi q, .reg rax x, .reg rcx y,
        .mem p 8 y true, .mem q 8 x true, .reg rsp (s + 8#64), .mem s 8 r true])
      (t ++ swapLeak p q s r) := by
  braid_sym_run
  braid_done

/-- **What `swap` reveals, on the machine.** A machine of the model that runs the executable
of this image, is at the entry of `swap`, has a word in memory where each of `rdi` and `rsi`
points, and has the return address `r` in the eight bytes at the stack pointer, the three
words apart from one another, reaches `r` on every run, and the trace of the run is
`swapLeak` of `rdi`, `rsi`, the stack pointer and `r`. -/
theorem swap_leakage [Layout] (m : MachineState) (x y r : Word) (hpc : m.pc = 0x401000)
    (hx : HasBytes m (m.data.regs.get64 .rdi) 8 x)
    (hy : HasBytes m (m.data.regs.get64 .rsi) 8 y)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hpq : 8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rdi).toNat)
    (hps : 8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsp).toNat ∧
      8 ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat)
    (hqs : 8 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rsp).toNat ∧
      8 ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rsi).toNat) :
    RunL exe
      (fun m' u => u = swapLeak (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
        (m.data.regs.get64 .rsp) r ∧ m'.pc.toBitVec = r) m [] := by
  refine (machine_soundT swap_holds
    (swap_trace (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) x y (m.data.regs.get64 .rax)
      (m.data.regs.get64 .rcx) (m.data.regs.get64 .rsp) r []) rfl
    (by simp [Atom.IsPointsTo])
    (by
      braid_disj
      repeat' constructor
      all_goals first | decide | exact Atom.disj_mem_mem_of_apart (by assumption))
    (by simp [Atom.sat_reg, Atom.sat_pc, sat_mem_abs, regOf, hpc, hret, hx, hy])).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_⟩
  rw [← hr.pc]
  exact Atoms.pc_of_holds hq (by braid_at)

/-- **`swap` reveals nothing of the words it exchanges.** Two machines that run the
executable of this image, are at the entry of `swap`, and agree on `rdi`, `rsi`, the stack
pointer and the return address, have the same trace on every run, whatever words are where
`rdi` and `rsi` point. The second machine's words are apart because its registers are the
first's. -/
theorem swap_leakage_eq [Layout] (m₁ m₂ : MachineState) (x₁ y₁ x₂ y₂ r : Word)
    (hpc₁ : m₁.pc = 0x401000) (hpc₂ : m₂.pc = 0x401000)
    (hx₁ : HasBytes m₁ (m₁.data.regs.get64 .rdi) 8 x₁)
    (hy₁ : HasBytes m₁ (m₁.data.regs.get64 .rsi) 8 y₁)
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (hx₂ : HasBytes m₂ (m₂.data.regs.get64 .rdi) 8 x₂)
    (hy₂ : HasBytes m₂ (m₂.data.regs.get64 .rsi) 8 y₂)
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hpq : 8 ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rdi).toNat)
    (hps : 8 ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rsp).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rdi).toNat)
    (hqs : 8 ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rsp).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rsi).toNat)
    (edi : m₂.data.regs.get64 .rdi = m₁.data.regs.get64 .rdi)
    (esi : m₂.data.regs.get64 .rsi = m₁.data.regs.get64 .rsi)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := swap_leakage m₁ x₁ y₁ r hpc₁ hx₁ hy₁ hret₁ hpq hps hqs
  have h₂ := swap_leakage m₂ x₂ y₂ r hpc₂ hx₂ hy₂ hret₂ (by rw [edi, esi]; exact hpq)
    (by rw [edi, esp]; exact hps) (by rw [esi, esp]; exact hqs)
  rw [edi, esi, esp] at h₂
  exact ⟨_, h₁, h₂⟩

end Examples.Memory.X86
