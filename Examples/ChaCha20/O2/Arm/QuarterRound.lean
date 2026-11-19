/-
  Examples.ChaCha20.O2.Arm.QuarterRound

  `quarter_round` of `chacha20.c` on AArch64, compiled at `-O2`: the quarter round of ChaCha20
  on four 32-bit words in memory.

  At `-O2` the compiler emits, for this function, the instructions it emits at `-O1`, at the
  same addresses. The expression `qr`, which is the code's arithmetic read as arithmetic on
  32-bit words, and the lemma `qr_eq` that it is `ChaCha20.quarter` are those of
  `Examples.ChaCha20.Arm.QuarterRound`, imported and not repeated; the two theorems here are
  stated about the code of this binary, and their proofs are those of the first, word for
  word.

  ## Main results

  * `quarter_round_spec`: the specification, against `ChaCha20.quarter`
  * `quarter_round_correct`: the same, about the machine alone
-/

module

public import Examples.ChaCha20.O2.Arm.Image
public import Examples.ChaCha20.Arm.QuarterRound

public section

namespace Examples.ChaCha20.O2.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs
open Examples.ChaCha20.Arm (qr qr_eq)

/-! ## The code -/

/-- `quarter_round` replaces the four 32-bit words its argument points to by their quarter
round. -/
theorem quarter_round_spec (s r t8 t9 t10 t11 : Word) (a b c d : W32) :
    Triple quarter_round.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 s, .reg x8 t8, .reg x9 t9, .reg x10 t10,
        .reg x11 t11, .reg lr r,
        .prop (cellsAt 4 true s ([a, b, c, d].map (·.zeroExtend 64)))])
      (Atoms.interp [.pc r, .reg x0 s, .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .prop (regAny x11), .reg lr r,
        .prop (cellsAt 4 true s ([(quarter a b c d).1, (quarter a b c d).2.1,
          (quarter a b c d).2.2.1, (quarter a b c d).2.2.2].map (·.zeroExtend 64)))]) := by
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

/-! ## On the machine -/

/-- **`quarter_round` on the machine.** A running machine whose program holds the words of
`quarter_round`, with its code loaded and its program counter at the entry, and with the
32-bit words `a`, `b`, `c` and `d` in memory where `x0` points, runs to the address in the
link register with the quarter round of the four words where `x0` pointed. -/
theorem quarter_round_correct (prog : Arm64.Program) (s : Arm64.State) (a b c d : W32)
    (hw : prog.hasWords 0x10000#64 quarter_round_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64)
    (ha : HasBytes s (s.regs.read 0#5) 4 (a.zeroExtend 64))
    (hb : HasBytes s (s.regs.read 0#5 + 4#64) 4 (b.zeroExtend 64))
    (hc' : HasBytes s (s.regs.read 0#5 + 8#64) 4 (c.zeroExtend 64))
    (hd : HasBytes s (s.regs.read 0#5 + 12#64) 4 (d.zeroExtend 64)) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      HasBytes s' (s.regs.read 0#5) 4 ((quarter a b c d).1.zeroExtend 64) ∧
      HasBytes s' (s.regs.read 0#5 + 4#64) 4 ((quarter a b c d).2.1.zeroExtend 64) ∧
      HasBytes s' (s.regs.read 0#5 + 8#64) 4 ((quarter a b c d).2.2.1.zeroExtend 64) ∧
      HasBytes s' (s.regs.read 0#5 + 12#64) 4 ((quarter a b c d).2.2.2.zeroExtend 64) := by
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat quarter_round_lowered
    (quarter_round_spec (s.regs.read 0#5) (s.regs.read 30#5) (s.regs.read 8#5)
      (s.regs.read 9#5) (s.regs.read 10#5) (s.regs.read 11#5) a b c d) hw hc hrun
    (Flat.interp (by braid_flat))
    (by simp [Atom.IsPointsTo, cellsAtoms])
    (by simp only [List.map_cons, List.map_nil, cellsAtoms]; braid_disj_mem)
    (by simp [cellsAtoms, Atom.sat_reg, Atom.sat_pc, sat_mem_hasBytes, regOf, hpc, ha, hb,
      hc', hd, BitVec.add_assoc])
  have h := fun i hi => hr.hasBytes (a := s.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) (n := 4)
    fun x hx => cell_of_holds hq (by braid_at) i hi hx
  refine ⟨s', hsteps, ?_, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · simpa using h 0 (by simp)
  · simpa using h 1 (by simp)
  · simpa using h 2 (by simp)
  · simpa using h 3 (by simp)

end Examples.ChaCha20.O2.Arm
