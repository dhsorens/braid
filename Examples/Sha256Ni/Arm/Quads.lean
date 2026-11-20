/-
  Examples.Sha256Ni.Arm.Quads

  Mathematics of `sha256_ni.c` that mentions no instruction set and that
  `Examples.Sha256Ni.Common` does not have: it is here only because that file belongs to the
  proof on x86-64 while this one is written, and it should move there. The proof on x86-64
  has the same two lemmas, in `Examples.Sha256Ni.X86.Lanes`, since the lowerings of both
  instruction sets mix the lanes of a word of the schedule with the same shifts under the
  same masks.

  ## Main results

  * `sig0_pack`, `sig1_pack`: the mixing of the two lanes of a word, written with shifts
    under masks, is `σ₀` and `σ₁` of the specification in each lane
-/

module

public import Examples.Sha256Ni.Common
import Std.Tactic.BVDecide

public section

namespace Examples.Sha256Ni.Arm

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec

/-- Rotations and a shift of the two lanes of a word, written as shifts of the word under the
masks that clear what crossed from one lane into the other, are `σ₀` in each lane. -/
theorem sig0_pack (a b : W32) :
    (pack a b >>> 7#64 &&& 0x01ffffff01ffffff#64 |||
          pack a b <<< 25#64 &&& 0xfe000000fe000000#64) ^^^
        (pack a b >>> 18#64 &&& 0x00003fff00003fff#64 |||
          pack a b <<< 14#64 &&& 0xffffc000ffffc000#64) ^^^
      pack a b >>> 3#64 &&& 0x1fffffff1fffffff#64 =
      pack (smallSigma0 a) (smallSigma0 b) := by
  simp only [pack, smallSigma0, ROTR, SHR]
  bv_decide

/-- The same for `σ₁`. -/
theorem sig1_pack (a b : W32) :
    (pack a b >>> 17#64 &&& 0x00007fff00007fff#64 |||
          pack a b <<< 15#64 &&& 0xffff8000ffff8000#64) ^^^
        (pack a b >>> 19#64 &&& 0x00001fff00001fff#64 |||
          pack a b <<< 13#64 &&& 0xffffe000ffffe000#64) ^^^
      pack a b >>> 10#64 &&& 0x003fffff003fffff#64 =
      pack (smallSigma1 a) (smallSigma1 b) := by
  simp only [pack, smallSigma1, ROTR, SHR]
  bv_decide

end Examples.Sha256Ni.Arm
