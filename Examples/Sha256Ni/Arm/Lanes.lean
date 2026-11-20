/-
  Examples.Sha256Ni.Arm.Lanes

  The SHA-256 instructions of AArch64 on words of two lanes: the mathematics of
  `sha256_compress_ni` that is particular to the instruction set. Nothing here mentions the
  code.

  The lowering of `sha256h` and `sha256h2` takes the eight working variables out of the
  lanes of two vector registers, each into a 64-bit word (`Lowering.Arm.Work`), and does four
  rounds on those (`hashWork`). A round on such words is a round of the specification on
  their low halves (`step_vars`), proved alone by `bv_decide`; four of them are `rounds4` of
  `Examples.Sha256Ni.Common`, and the two words each instruction leaves hold the working
  variables after them (`hash_pack`).

  `sha256su0` and `sha256su1` together compute four new words of the schedule from the
  sixteen before them, with `sigLanes` of the lowering, which is `σ₀` or `σ₁` in each lane
  (`su_pack`).

  ## Main definitions

  * `workVars`: the working variables that eight words hold in their low halves

  ## Main results

  * `step_vars`: a round of the lowering is a round of the specification
  * `hashWork_vars`: `hashWork` is four rounds of the specification
  * `hash_pack`: `sha256h` and `sha256h2` leave the working variables after four rounds
  * `su_pack`: `sha256su1` of `sha256su0` leaves four new words of the schedule
-/

module

public import Examples.Sha256Ni.Arm.Quads
public import Lowering.Arm.Sha
import Std.Tactic.BVDecide

public section

namespace Examples.Sha256Ni.Arm

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.Arm

/-! ## Four rounds -/

/-- The working variables that eight words hold in their low halves. -/
@[expose] def workVars (s : Work) : Vars :=
  ⟨s.a.setWidth 32, s.b.setWidth 32, s.c.setWidth 32, s.d.setWidth 32, s.e.setWidth 32,
    s.f.setWidth 32, s.g.setWidth 32, s.h.setWidth 32⟩

/-- **A round of the lowering is a round of the specification**, on the low halves of the
working words, with the low half of `k` as the sum of the round constant and the word of
the schedule. The first and the fifth working word must be below `2 ^ 32`. -/
theorem step_vars (s : Work) (k : Word) (ha : s.a >>> 32#64 = 0#64)
    (he : s.e >>> 32#64 = 0#64) : workVars (s.step k) = roundS (k.setWidth 32) (workVars s) := by
  obtain ⟨a, b, c, d, e, f, g, h⟩ := s
  simp only [Work.step, workVars, roundS, rndA, rndE, rndT, bigSig, dupLo, bigSigma0,
    bigSigma1, Ch, Maj, ROTR, Vars.mk.injEq, and_true, true_and] at ha he ⊢
  constructor <;> bv_decide

/-- **`hashWork` is four rounds of the specification**, on the low halves of the working
words that the lanes of the operands give, with the four lanes of the last operand as the
sums of a round constant and a word of the schedule. -/
theorem hashWork_vars (x0 x1 y0 y1 w0 w1 : Word) :
    workVars (hashWork x0 x1 y0 y1 w0 w1) =
      rounds4 (w0.setWidth 32) ((w0 >>> 32#64).setWidth 32) (w1.setWidth 32)
        ((w1 >>> 32#64).setWidth 32) (workVars (Work.init x0 x1 y0 y1)) := by
  rw [hashWork, step_vars _ _ (step_a_lt ..) (step_e_lt ..),
    step_vars _ _ (step_a_lt ..) (step_e_lt ..), step_vars _ _ (step_a_lt ..) (step_e_lt ..),
    step_vars _ _ (init_a_lt ..) (init_e_lt ..), rounds4]

/-- The working variables in the lanes of four words are those `Work.init` takes out. -/
theorem init_vars (a b c d e f g h : W32) :
    workVars (Work.init (pack a b) (pack c d) (pack e f) (pack g h)) =
      ⟨a, b, c, d, e, f, g, h⟩ := by
  simp only [Work.init, workVars, pack, Vars.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- Two words below `2 ^ 32`, the second moved up, are their low halves as two lanes. -/
theorem or_shl_pack (x y : Word) (hx : x >>> 32#64 = 0#64) (hy : y >>> 32#64 = 0#64) :
    x ||| y <<< 32#64 = pack (x.setWidth 32) (y.setWidth 32) := by
  simp only [pack]
  bv_decide

theorem pack_lo (a b : W32) : (pack a b).setWidth 32 = a := by
  simp only [pack]
  bv_decide

theorem pack_hi (a b : W32) : (pack a b >>> 32#64).setWidth 32 = b := by
  simp only [pack]
  bv_decide

/-- **`sha256h` and `sha256h2` are four rounds of the specification.** With the working
variables `a` to `d` in the lanes of one vector register and `e` to `h` in those of another,
and four sums of a round constant and a word of the schedule in the lanes of a third, the
two words `sha256h` leaves hold `a` to `d` after the four rounds, and the two words
`sha256h2` leaves hold `e` to `h` after them. -/
theorem hash_pack (a b c d e f g h s0 s1 s2 s3 : W32) :
    sha256hLo (pack a b) (pack c d) (pack e f) (pack g h) (pack s0 s1) (pack s2 s3) =
        pack (rounds4 s0 s1 s2 s3 ⟨a, b, c, d, e, f, g, h⟩).a
          (rounds4 s0 s1 s2 s3 ⟨a, b, c, d, e, f, g, h⟩).b ∧
      sha256hHi (pack a b) (pack c d) (pack e f) (pack g h) (pack s0 s1) (pack s2 s3) =
        pack (rounds4 s0 s1 s2 s3 ⟨a, b, c, d, e, f, g, h⟩).c
          (rounds4 s0 s1 s2 s3 ⟨a, b, c, d, e, f, g, h⟩).d ∧
      sha256h2Lo (pack e f) (pack g h) (pack a b) (pack c d) (pack s0 s1) (pack s2 s3) =
        pack (rounds4 s0 s1 s2 s3 ⟨a, b, c, d, e, f, g, h⟩).e
          (rounds4 s0 s1 s2 s3 ⟨a, b, c, d, e, f, g, h⟩).f ∧
      sha256h2Hi (pack e f) (pack g h) (pack a b) (pack c d) (pack s0 s1) (pack s2 s3) =
        pack (rounds4 s0 s1 s2 s3 ⟨a, b, c, d, e, f, g, h⟩).g
          (rounds4 s0 s1 s2 s3 ⟨a, b, c, d, e, f, g, h⟩).h := by
  have hv := hashWork_vars (pack a b) (pack c d) (pack e f) (pack g h) (pack s0 s1)
    (pack s2 s3)
  rw [init_vars, pack_lo, pack_hi, pack_lo, pack_hi] at hv
  rw [← hv]
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact or_shl_pack _ _ (step_a_lt ..) (step_a_lt ..)
  · exact or_shl_pack _ _ (step_a_lt ..) (step_a_lt ..)
  · exact or_shl_pack _ _ (step_e_lt ..) (step_e_lt ..)
  · exact or_shl_pack _ _ (step_e_lt ..) (step_e_lt ..)

/-! ## The schedule -/

/-- The mixing of lanes of `sha256su0` is `σ₀` in each lane. -/
theorem sigLanes0_pack (a b : W32) :
    sigLanes 7 18 3 (pack a b) = pack (smallSigma0 a) (smallSigma0 b) := by
  rw [← sig0_pack]
  rfl

/-- The mixing of lanes of `sha256su1` is `σ₁` in each lane. -/
theorem sigLanes1_pack (a b : W32) :
    sigLanes 17 19 10 (pack a b) = pack (smallSigma1 a) (smallSigma1 b) := by
  rw [← sig1_pack]
  rfl

/-- **`sha256su1` of `sha256su0` is four new words of the schedule**: from the sixteen
words before them in the lanes of four vector registers, the two words of the result hold
the four words that follow, as `Sha256Ni.slide4_eq` writes them. -/
theorem su_pack (w0 w1 w2 w3 w4 w5 w8 w9 w10 w11 w12 w13 w14 w15 : W32) :
    su1Lo (su0Lo (pack w0 w1) (pack w2 w3)) (pack w8 w9) (pack w10 w11) (pack w14 w15) =
        pack (smallSigma1 w14 + w9 + smallSigma0 w1 + w0)
          (smallSigma1 w15 + w10 + smallSigma0 w2 + w1) ∧
      su1Hi (su0Hi (pack w2 w3) (pack w4 w5)) (pack w10 w11) (pack w12 w13)
          (pack (smallSigma1 w14 + w9 + smallSigma0 w1 + w0)
            (smallSigma1 w15 + w10 + smallSigma0 w2 + w1)) =
        pack (smallSigma1 (smallSigma1 w14 + w9 + smallSigma0 w1 + w0) + w11 +
            smallSigma0 w3 + w2)
          (smallSigma1 (smallSigma1 w15 + w10 + smallSigma0 w2 + w1) + w12 +
            smallSigma0 w4 + w3) := by
  simp only [su0Lo, su0Hi, su1Lo, su1Hi, pack_ext, sigLanes0_pack, sigLanes1_pack, pack_add]
  constructor <;> ac_rfl

end Examples.Sha256Ni.Arm
