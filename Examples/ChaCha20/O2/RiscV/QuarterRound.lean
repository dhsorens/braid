/-
  Examples.ChaCha20.O2.RiscV.QuarterRound

  `quarter_round` of `chacha20.c` on RISC-V, compiled at `-O2`: the quarter round of ChaCha20
  on four 32-bit words in memory.

  At `-O2` the compiler emits, for this function, the instructions it emits at `-O1`, at the
  same addresses. The lemmas about the low half of a register and the expression `qr` are
  those of `Examples.ChaCha20.RiscV.QuarterRound`, imported and not repeated; the two
  theorems here are stated about the code of this binary, and their proofs are those of the
  first, word for word.

  ## Main results

  * `quarter_round_spec`, `quarter_round_correct`: the quarter round on four words in memory
-/

module

public import Examples.ChaCha20.O2.RiscV.Image
public import Examples.ChaCha20.RiscV.QuarterRound

public section

namespace Examples.ChaCha20.O2.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64
open Examples.ChaCha20.RiscV (qr qr_eq low_add low_xor low_rot16 low_rot12 low_rot8 low_rot7
  low_sext cells4_low hasBytes_of_mem)

/-! ## The code -/

/-- `quarter_round` replaces the four 32-bit words its argument points to, which must be a
multiple of 4, by their quarter round. -/
theorem quarter_round_spec (s r t1 t2 t3 t4 t5 : Word) (a b c d : W32)
    (hs : s &&& 3#64 = 0#64) :
    Triple quarter_round.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 s, .reg a1 t1, .reg a2 t2, .reg a3 t3,
        .reg a4 t4, .reg a5 t5, .reg ra r,
        .prop (cellsAt 4 true s ([a, b, c, d].map (·.zeroExtend 64)))])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 s, .prop (regAny a1), .prop (regAny a2),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .reg ra r,
        .prop (cellsAt 4 true s ([(quarter a b c d).1, (quarter a b c d).2.1,
          (quarter a b c d).2.2.1, (quarter a b c d).2.2.2].map (·.zeroExtend 64)))]) := by
  rw [← qr_eq]
  simp only [qr]
  simp only [List.map_cons, List.map_nil]
  braid_unfold cells4 s _ _ _ _
  braid_sym_run
  braid_fold cells4_low s _ _ _ _
  -- From the outside in (`↓`): a rotation is recognized before its argument is rewritten.
  simp only [↓ low_add, ↓ low_xor, ↓ low_rot16, ↓ low_rot12, ↓ low_rot8, ↓ low_rot7,
    ↓ low_sext]
  braid_forget 11
  braid_forget 12
  braid_forget 13
  braid_forget 14
  braid_forget 15
  braid_done
/-! ## On the machine -/

/-- **`quarter_round` on the machine.** A machine that holds the code of `quarter_round`, is
at its entry, and has the 32-bit words `a`, `b`, `c` and `d` in valid memory where `a0`
points, `a0` a multiple of 4, runs to the return address with the quarter round of the four
words where `a0` pointed. -/
theorem quarter_round_correct (s : MachineState) (a b c d : W32)
    (hcode : ∀ p ∈ quarter_round_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hp : s.getReg .x10 &&& 3#64 = 0#64)
    (ha : HasBytes s (s.getReg .x10) 4 (a.zeroExtend 64))
    (hb : HasBytes s (s.getReg .x10 + 4#64) 4 (b.zeroExtend 64))
    (hc : HasBytes s (s.getReg .x10 + 8#64) 4 (c.zeroExtend 64))
    (hd : HasBytes s (s.getReg .x10 + 12#64) 4 (d.zeroExtend 64)) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      HasBytes s' (s.getReg .x10) 4 ((quarter a b c d).1.zeroExtend 64) ∧
      HasBytes s' (s.getReg .x10 + 4#64) 4 ((quarter a b c d).2.1.zeroExtend 64) ∧
      HasBytes s' (s.getReg .x10 + 8#64) 4 ((quarter a b c d).2.2.1.zeroExtend 64) ∧
      HasBytes s' (s.getReg .x10 + 12#64) 4 ((quarter a b c d).2.2.2.zeroExtend 64) := by
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound_flat quarter_round_lowered
    (quarter_round_spec (s.getReg .x10) (s.getReg .x1) (s.getReg .x11) (s.getReg .x12)
      (s.getReg .x13) (s.getReg .x14) (s.getReg .x15) a b c d hp) hcode
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
  have h := fun i hi => hasBytes_of_mem hr (a := s.getReg .x10 + BitVec.ofNat 64 (4 * i))
    (n := 4) fun x hx => cell_of_holds hq (by braid_at) i hi hx
  refine ⟨n, s', hn, ?_, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · simpa using h 0 (by simp)
  · simpa using h 1 (by simp)
  · simpa using h 2 (by simp)
  · simpa using h 3 (by simp)
end Examples.ChaCha20.O2.RiscV
