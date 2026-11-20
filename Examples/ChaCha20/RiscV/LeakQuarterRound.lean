/-
  Examples.ChaCha20.RiscV.LeakQuarterRound

  What `quarter_round` reveals on RISC-V (`docs/Leakage.md`): the addresses of the four
  words it works on and the return address, and nothing of the words.

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
public import Examples.ChaCha20.RiscV.Proofs

public section

namespace Examples.ChaCha20.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- **`quarter_round` and the trace of its run.** It works on the four words its argument
points to, and the trace is found by running it: it is a function of the argument `s` and
the return address `r` alone, and of nothing the registers or the four words hold. -/
def quarter_round_run (s r : Word) : { ls : Trace // ∀ (t1 t2 t3 t4 t5 : Word)
    (a b c d : W32) (_ : s &&& 3#64 = 0#64) (t : Trace),
    TripleT quarter_round.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 s, .reg a1 t1, .reg a2 t2, .reg a3 t3,
        .reg a4 t4, .reg a5 t5, .reg ra r,
        .prop (cellsAt 4 true s ([a, b, c, d].map (·.zeroExtend 64)))]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 s, .prop (regAny a1), .prop (regAny a2),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .reg ra r,
        .prop (cellsAt 4 true s ([(quarter a b c d).1, (quarter a b c d).2.1,
          (quarter a b c d).2.2.1, (quarter a b c d).2.2.2].map (·.zeroExtend 64)))])
      (t ++ ls) } := by
  braid_traced
  intro t1 t2 t3 t4 t5 a b c d hs t
  rw [← qr_eq]
  simp only [qr]
  simp only [List.map_cons, List.map_nil]
  braid_unfold cells4 s _ _ _ _
  braid_sym_run
  braid_fold cells4_low s _ _ _ _
  simp only [↓ low_add, ↓ low_xor, ↓ low_rot16, ↓ low_rot12, ↓ low_rot8, ↓ low_rot7,
    ↓ low_sext]
  braid_forget 11
  braid_forget 12
  braid_forget 13
  braid_forget 14
  braid_forget 15
  braid_done

/-- What `quarter_round` reveals: the addresses of the four words, each read and then
written, and where it returns. It is the trace that the run of `quarter_round_run` finds. -/
def quarterRoundLeak (s r : Word) : Trace := (quarter_round_run s r).1

/-- The trace found, written out. -/
example (s r : Word) : quarterRoundLeak s r =
    [.read s 4, .read (s + 4#64) 4, .read (s + 12#64) 4, .read (s + 8#64) 4,
      .write s 4, .write (s + 4#64) 4, .write (s + 8#64) 4, .write (s + 12#64) 4,
      .jump (r &&& ~~~1#64)] := rfl

/-- **What `quarter_round` reveals, on the machine.** A machine that holds the code of
`quarter_round`, is at its entry, and has the 32-bit words `a`, `b`, `c` and `d` in valid
memory where `a0` points, `a0` a multiple of 4, runs to the return address with the trace
`quarterRoundLeak` of `a0` and the return address. -/
theorem quarter_round_leakage (s : MachineState) (a b c d : W32)
    (hcode : ∀ p ∈ quarter_round_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hp : s.getReg .x10 &&& 3#64 = 0#64)
    (ha : HasBytes s (s.getReg .x10) 4 (a.zeroExtend 64))
    (hb : HasBytes s (s.getReg .x10 + 4#64) 4 (b.zeroExtend 64))
    (hc : HasBytes s (s.getReg .x10 + 8#64) 4 (c.zeroExtend 64))
    (hd : HasBytes s (s.getReg .x10 + 12#64) 4 (d.zeroExtend 64)) :
    ∃ s', RunL s (quarterRoundLeak (s.getReg .x10) (s.getReg .x1)) s' ∧
      s'.pc = s.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨s', σ', hrun, hr, hq⟩ := machine_soundT quarter_round_lowered
    ((quarter_round_run (s.getReg .x10) (s.getReg .x1)).2 (s.getReg .x11) (s.getReg .x12)
      (s.getReg .x13) (s.getReg .x14) (s.getReg .x15) a b c d hp []) hcode
    (Flat.interp (by braid_flat))
    (by simp [Atom.IsPointsTo, cellsAtoms])
    (by simp only [List.map_cons, List.map_nil, cellsAtoms]
        braid_disj
        repeat' apply And.intro
        all_goals first
          | decide
          | (refine Atom.disj_mem_mem fun x hx => ?_
             obtain ⟨hx1, hx2⟩ := hx
             bv_omega))
    (by simp only [List.map_cons, List.map_nil, cellsAtoms, List.cons_append, List.nil_append,
          List.forall_mem_cons, sat_mem_abs]
        simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, ha, hb, hc, hd,
          BitVec.add_assoc])
  refine ⟨s', hrun, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`quarter_round` reveals nothing of the words it works on.** Two machines that hold the
code of `quarter_round`, are at its entry, and agree on `a0`, a multiple of 4, and on the
return address, run with the same trace, whatever four words each has where `a0` points. -/
theorem quarter_round_leakage_eq (s₁ s₂ : MachineState) (a₁ b₁ c₁ d₁ a₂ b₂ c₂ d₂ : W32)
    (hcode₁ : ∀ p ∈ quarter_round_code, s₁.code p.1 = some p.2)
    (hcode₂ : ∀ p ∈ quarter_round_code, s₂.code p.1 = some p.2)
    (hpc₁ : s₁.pc = 0x10000#64) (hpc₂ : s₂.pc = 0x10000#64)
    (hp : s₁.getReg .x10 &&& 3#64 = 0#64)
    (ha₁ : HasBytes s₁ (s₁.getReg .x10) 4 (a₁.zeroExtend 64))
    (hb₁ : HasBytes s₁ (s₁.getReg .x10 + 4#64) 4 (b₁.zeroExtend 64))
    (hc₁ : HasBytes s₁ (s₁.getReg .x10 + 8#64) 4 (c₁.zeroExtend 64))
    (hd₁ : HasBytes s₁ (s₁.getReg .x10 + 12#64) 4 (d₁.zeroExtend 64))
    (ha₂ : HasBytes s₂ (s₂.getReg .x10) 4 (a₂.zeroExtend 64))
    (hb₂ : HasBytes s₂ (s₂.getReg .x10 + 4#64) 4 (b₂.zeroExtend 64))
    (hc₂ : HasBytes s₂ (s₂.getReg .x10 + 8#64) 4 (c₂.zeroExtend 64))
    (hd₂ : HasBytes s₂ (s₂.getReg .x10 + 12#64) 4 (d₂.zeroExtend 64))
    (e10 : s₂.getReg .x10 = s₁.getReg .x10) (e1 : s₂.getReg .x1 = s₁.getReg .x1) :
    ∃ tr s₁' s₂', RunL s₁ tr s₁' ∧ RunL s₂ tr s₂' ∧
      s₁'.pc = s₁.getReg .x1 &&& ~~~1#64 ∧ s₂'.pc = s₁.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨s₁', h₁, hp₁⟩ :=
    quarter_round_leakage s₁ a₁ b₁ c₁ d₁ hcode₁ hpc₁ hp ha₁ hb₁ hc₁ hd₁
  obtain ⟨s₂', h₂, hp₂⟩ :=
    quarter_round_leakage s₂ a₂ b₂ c₂ d₂ hcode₂ hpc₂ (e10 ▸ hp) ha₂ hb₂ hc₂ hd₂
  simp only [e10, e1] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.ChaCha20.RiscV
