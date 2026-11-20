/-
  Examples.Sha256Ni.X86.Lanes

  The SHA instructions of x86-64 on words of two lanes: the mathematics of
  `sha256_compress_ni` that is particular to the instruction set. Nothing here mentions the
  code.

  `sha256rnds2` holds the working variables as two vectors, `(a, b, e, f)` and
  `(c, d, g, h)`, with the first variable in the highest lane, so that the low word of the
  first is `pack f e` and its high word `pack b a`. Its lowering is the functions `rnds2Lo`
  and `rnds2Hi` of `Lowering.X86`, on 64-bit words, and here they are two rounds of the
  specification on the lanes. A round is proved alone, by `bv_decide`, and the second round
  on the variables that the first leaves.

  `sha256msg1` and `sha256msg2` mix the lanes of a word of the schedule with shifts under
  masks, which the stepper leaves written out; `sig0_pack` and `sig1_pack` read such a word
  as the `σ₀` and `σ₁` of the specification in each lane.

  ## Main results

  * `rnds2_pack`: `sha256rnds2` is two rounds of the specification
  * `sig0_pack`, `sig1_pack`: the mixing of the lanes of a word in the schedule instructions
-/

module

public import Examples.Sha256Ni.Common
public import Lowering.X86.Logic
import Std.Tactic.BVDecide

public section

namespace Examples.Sha256Ni.X86

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.X86

/-! ## Two rounds -/

/-- The fifth working variable after the first round of `sha256rnds2`. -/
theorem rnds2E_pack (a b c d e f g h s0 s1 : W32) :
    rnds2E (pack f e) (pack h g) (pack d c) (pack s0 s1) =
      (roundS s0 ⟨a, b, c, d, e, f, g, h⟩).e.zeroExtend 64 := by
  simp only [rnds2E, rndE, rndT, bigSig, dupLo, pack, roundS, bigSigma1, Ch, ROTR]
  bv_decide

/-- The first working variable after the first round of `sha256rnds2`. -/
theorem rnds2A_pack (a b c d e f g h s0 s1 : W32) :
    rnds2A (pack f e) (pack b a) (pack h g) (pack d c) (pack s0 s1) =
      (roundS s0 ⟨a, b, c, d, e, f, g, h⟩).a.zeroExtend 64 := by
  simp only [rnds2A, rndA, rndT, bigSig, dupLo, pack, roundS, bigSigma0, bigSigma1, Ch, Maj,
    ROTR]
  bv_decide

/-- **`sha256rnds2` is two rounds of the specification**: with the working variables in the
lanes of its two operands and the sums of a round constant and a word of the schedule for
the two rounds in the low lanes of its third, its result holds the first, second, fifth and
sixth variables after the two rounds. The other four are the first, second, fifth and sixth
before them, which are the operand the instruction does not write. -/
theorem rnds2_pack (a b c d e f g h s0 s1 : W32) :
    rnds2Lo (pack f e) (pack h g) (pack d c) (pack s0 s1) =
        pack (roundS s1 (roundS s0 ⟨a, b, c, d, e, f, g, h⟩)).f
          (roundS s1 (roundS s0 ⟨a, b, c, d, e, f, g, h⟩)).e ∧
      rnds2Hi (pack f e) (pack b a) (pack h g) (pack d c) (pack s0 s1) =
        pack (roundS s1 (roundS s0 ⟨a, b, c, d, e, f, g, h⟩)).b
          (roundS s1 (roundS s0 ⟨a, b, c, d, e, f, g, h⟩)).a := by
  have he := rnds2E_pack a b c d e f g h s0 s1
  have ha := rnds2A_pack a b c d e f g h s0 s1
  have hv : roundS s0 ⟨a, b, c, d, e, f, g, h⟩ =
      ⟨(roundS s0 ⟨a, b, c, d, e, f, g, h⟩).a, a, b, c,
        (roundS s0 ⟨a, b, c, d, e, f, g, h⟩).e, e, f, g⟩ := rfl
  rw [hv]
  generalize (roundS s0 ⟨a, b, c, d, e, f, g, h⟩).a = a1 at ha ⊢
  generalize (roundS s0 ⟨a, b, c, d, e, f, g, h⟩).e = e1 at he ⊢
  constructor
  · rw [rnds2Lo, he]
    simp only [rndE, rndT, bigSig, dupLo, pack, roundS, bigSigma1, Ch, ROTR]
    bv_decide
  · rw [rnds2Hi, ha, he]
    simp only [rndA, rndT, bigSig, dupLo, pack, roundS, bigSigma0, bigSigma1, Ch, Maj, ROTR]
    bv_decide

/-! ## The schedule -/

/-- The mixing of `sha256msg1`, as its lowering writes it, is `σ₀` in each lane. -/
theorem sig0_pack (a b : W32) :
    (pack a b >>> 7#64 &&& 0x01ffffff01ffffff#64 |||
          pack a b <<< 25#64 &&& 0xfe000000fe000000#64) ^^^
        (pack a b >>> 18#64 &&& 0x00003fff00003fff#64 |||
          pack a b <<< 14#64 &&& 0xffffc000ffffc000#64) ^^^
      pack a b >>> 3#64 &&& 0x1fffffff1fffffff#64 =
      pack (smallSigma0 a) (smallSigma0 b) := by
  simp only [pack, smallSigma0, ROTR, SHR]
  bv_decide

/-- The mixing of `sha256msg2`, as its lowering writes it, is `σ₁` in each lane. -/
theorem sig1_pack (a b : W32) :
    (pack a b >>> 17#64 &&& 0x00007fff00007fff#64 |||
          pack a b <<< 15#64 &&& 0xffff8000ffff8000#64) ^^^
        (pack a b >>> 19#64 &&& 0x00001fff00001fff#64 |||
          pack a b <<< 13#64 &&& 0xffffe000ffffe000#64) ^^^
      pack a b >>> 10#64 &&& 0x003fffff003fffff#64 =
      pack (smallSigma1 a) (smallSigma1 b) := by
  simp only [pack, smallSigma1, ROTR, SHR]
  bv_decide

/-! ## Shuffles -/

/-- `pshufd` by `0x0e` brings the high word of its operand down: the low word of the result,
as the lowering writes it, is that word. -/
theorem shuf_high (x : Word) : x >>> 0#64 &&& 0xffffffff#64 ||| x >>> 32#64 <<< 32#64 = x := by
  bv_decide

end Examples.Sha256Ni.X86
