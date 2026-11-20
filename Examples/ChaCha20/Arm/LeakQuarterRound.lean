/-
  Examples.ChaCha20.Arm.LeakQuarterRound

  What `quarter_round` reveals on AArch64 (`docs/Leakage.md`): the addresses of the four
  words it works on and the return address, and nothing of the words. The code loads the
  words as two pairs, works on registers, and stores them as two pairs; it has no branch
  but the return.

  ## Main definitions

  * `quarter_round_run`: the trace of `quarter_round`, found by its run, with the traced
    triple; the trace is a function of the argument and the return address
  * `quarterRoundLeak`: what `quarter_round` reveals, which is that trace

  ## Main results

  * `quarter_round_leakage`: the same, about the machine alone
  * `quarter_round_leakage_eq`: two machines that agree on the argument and the return
    address run with the same trace
-/

module

public import Braid.Logic.Traced
public import Examples.ChaCha20.Arm.Proofs

public section

namespace Examples.ChaCha20.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- **`quarter_round` and the trace of its run.** It works on the four words its argument
points to, and the trace is found by running it: it is a function of the argument `s` and
the return address `r` alone, and of nothing the registers or the four words hold. -/
def quarter_round_run (s r : Word) : { ls : Trace // ∀ (t8 t9 t10 t11 : Word)
    (a b c d : W32) (t : Trace),
    TripleT quarter_round.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 s, .reg x8 t8, .reg x9 t9, .reg x10 t10,
        .reg x11 t11, .reg lr r,
        .prop (cellsAt 4 true s ([a, b, c, d].map (·.zeroExtend 64)))]) t
      (Atoms.interp [.pc r, .reg x0 s, .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .prop (regAny x11), .reg lr r,
        .prop (cellsAt 4 true s ([(quarter a b c d).1, (quarter a b c d).2.1,
          (quarter a b c d).2.2.1, (quarter a b c d).2.2.2].map (·.zeroExtend 64)))])
      (t ++ ls) } := by
  braid_traced
  intro t8 t9 t10 t11 a b c d t
  rw [← qr_eq]
  simp only [qr]
  simp only [List.map_cons, List.map_nil]
  braid_unfold cells4' s _ _ _ _
  braid_sym_run
  simp only [zadd, zxor, trunc32_zext, zror16, zror20, zror24, zror25]
  braid_fold cells4' s _ _ _ _
  braid_forget 8
  braid_forget 9
  braid_forget 10
  braid_forget 11
  braid_done

/-- What `quarter_round` reveals: the addresses of the four words, read as two pairs and
written as two pairs, the second pair first, and where it returns. It is the trace that the
run of `quarter_round_run` finds. -/
def quarterRoundLeak (s r : Word) : Trace := (quarter_round_run s r).1

/-- The trace found, written out. -/
example (s r : Word) : quarterRoundLeak s r =
    [.read s 4, .read (s + 4#64) 4, .read (s + 8#64) 4, .read (s + 12#64) 4,
      .write (s + 8#64) 4, .write (s + 12#64) 4, .write s 4, .write (s + 4#64) 4,
      .jump r] := rfl

/-- **What `quarter_round` reveals, on the machine.** A running machine whose program holds
the words of `quarter_round`, with its code loaded and its program counter at the entry, and
with the 32-bit words `a`, `b`, `c` and `d` in memory where `x0` points, runs to the address
in the link register with the trace `quarterRoundLeak` of `x0` and the link register. -/
theorem quarter_round_leakage (prog : Arm64.Program) (s : Arm64.State) (a b c d : W32)
    (hw : prog.hasWords 0x10000#64 quarter_round_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64)
    (ha : HasBytes s (s.regs.read 0#5) 4 (a.zeroExtend 64))
    (hb : HasBytes s (s.regs.read 0#5 + 4#64) 4 (b.zeroExtend 64))
    (hc' : HasBytes s (s.regs.read 0#5 + 8#64) 4 (c.zeroExtend 64))
    (hd : HasBytes s (s.regs.read 0#5 + 12#64) 4 (d.zeroExtend 64)) :
    ∃ s', RunL prog s (quarterRoundLeak (s.regs.read 0#5) (s.regs.read 30#5)) s' ∧
      s'.pc = s.regs.read 30#5 := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_soundT quarter_round_lowered
    ((quarter_round_run (s.regs.read 0#5) (s.regs.read 30#5)).2 (s.regs.read 8#5)
      (s.regs.read 9#5) (s.regs.read 10#5) (s.regs.read 11#5) a b c d []) hw hc hrun
    (Flat.interp (by braid_flat))
    (by simp [Atom.IsPointsTo, cellsAtoms])
    (by simp only [List.map_cons, List.map_nil, cellsAtoms]; braid_disj_mem)
    (by simp [cellsAtoms, Atom.sat_reg, Atom.sat_pc, sat_mem_hasBytes, regOf, hpc, ha, hb,
      hc', hd, BitVec.add_assoc])
  refine ⟨s', hsteps, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`quarter_round` reveals nothing of the words it works on.** Two running machines that
hold the words of `quarter_round`, with their code loaded and at its entry, and that agree on
`x0` and on the link register, run with the same trace, whatever four words each has where
`x0` points. -/
theorem quarter_round_leakage_eq (prog₁ prog₂ : Arm64.Program) (s₁ s₂ : Arm64.State)
    (a₁ b₁ c₁ d₁ a₂ b₂ c₂ d₂ : W32)
    (hw₁ : prog₁.hasWords 0x10000#64 quarter_round_words) (hc₁ : prog₁.CodeLoaded s₁.mem)
    (hw₂ : prog₂.hasWords 0x10000#64 quarter_round_words) (hc₂ : prog₂.CodeLoaded s₂.mem)
    (hrun₁ : s₁.status = .Running) (hrun₂ : s₂.status = .Running)
    (hpc₁ : s₁.pc = 0x10000#64) (hpc₂ : s₂.pc = 0x10000#64)
    (ha₁ : HasBytes s₁ (s₁.regs.read 0#5) 4 (a₁.zeroExtend 64))
    (hb₁ : HasBytes s₁ (s₁.regs.read 0#5 + 4#64) 4 (b₁.zeroExtend 64))
    (hc₁' : HasBytes s₁ (s₁.regs.read 0#5 + 8#64) 4 (c₁.zeroExtend 64))
    (hd₁ : HasBytes s₁ (s₁.regs.read 0#5 + 12#64) 4 (d₁.zeroExtend 64))
    (ha₂ : HasBytes s₂ (s₂.regs.read 0#5) 4 (a₂.zeroExtend 64))
    (hb₂ : HasBytes s₂ (s₂.regs.read 0#5 + 4#64) 4 (b₂.zeroExtend 64))
    (hc₂' : HasBytes s₂ (s₂.regs.read 0#5 + 8#64) 4 (c₂.zeroExtend 64))
    (hd₂ : HasBytes s₂ (s₂.regs.read 0#5 + 12#64) 4 (d₂.zeroExtend 64))
    (e0 : s₂.regs.read 0#5 = s₁.regs.read 0#5) (e30 : s₂.regs.read 30#5 = s₁.regs.read 30#5) :
    ∃ tr s₁' s₂', RunL prog₁ s₁ tr s₁' ∧ RunL prog₂ s₂ tr s₂' ∧
      s₁'.pc = s₁.regs.read 30#5 ∧ s₂'.pc = s₁.regs.read 30#5 := by
  obtain ⟨s₁', h₁, hp₁⟩ :=
    quarter_round_leakage prog₁ s₁ a₁ b₁ c₁ d₁ hw₁ hc₁ hrun₁ hpc₁ ha₁ hb₁ hc₁' hd₁
  obtain ⟨s₂', h₂, hp₂⟩ :=
    quarter_round_leakage prog₂ s₂ a₂ b₂ c₂ d₂ hw₂ hc₂ hrun₂ hpc₂ ha₂ hb₂ hc₂' hd₂
  simp only [e0, e30] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.ChaCha20.Arm
