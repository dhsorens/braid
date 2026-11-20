/-
  Examples.ChaCha20Vec.Common

  What the proofs about `chacha20_vec.c` share, on every instruction set. The code keeps the
  state of ChaCha20 as four rows of four 32-bit lanes, and a row is two 64-bit words of the
  machine's state, each holding two lanes, the first in its low half. Here is how such words
  relate to the words of the specification: the operations of the code on a word, as the
  same operations on its two lanes; a state in memory, sixteen 32-bit cells, as eight 64-bit
  cells; the double round as the code computes it, a column round on the rows, a rotation
  of the lanes of three rows, a column round again, and the rotation back; and the sum with
  the state that ends the block function, as additions of lanes.

  Nothing here mentions an instruction set: the shifts and masks are those of 64-bit words.

  ## Main definitions

  * `pack`: two 32-bit lanes in a 64-bit word, the first in the low half
  * `packs`: a list of lanes as a list of words, two lanes to a word
  * `rowLo`, `rowHi`: the two words of a row of a state
  * `shiftRows`, `unshiftRows`: the lanes of rows 1, 2 and 3 rotated by one, two and three
    places, and back

  ## Main results

  * `pack_add`, `lanes_add_comm`, `pack_xor`, `pack_or`: addition of lanes and bitwise
    operations on words, on the lanes
  * `pack_shl16`, ..., `pack_shr25`: a shift of a word under the mask that clears what
    crossed from one lane into the other, as the shift of each lane
  * `pack_ext`, `pack_ext_mask`: the high lane of a word and the low lane of the next, as a
    word
  * `lanes_self_mask`: a word built from its own two lanes
  * `rotl16_or`, `rotl12_add`, `rotl12_or`, `rotl12_or'`, ...: two shifts of a lane, as a
    rotation
  * `memIs_pack`, `cells_packs`, `cells_packs_truncate`, `packs16`: 32-bit cells in memory,
    two to a 64-bit cell
  * `diagonals_eq_shift`: a diagonal round is a column round between two rotations of rows
  * `inner_eq_shift`: a double round, as column rounds and rotations of rows
  * `rowLo_block`, `rowHi_block`: a row of the block function, as an addition of lanes
-/

module

public import Braid.Logic.Bytes
public import Examples.ChaCha20.Common
import Iris.BI.DerivedLaws

public section

namespace Examples.ChaCha20Vec

open Braid Iris Iris.BI Examples.ChaCha20

/-! ## Two lanes in a word -/

/-- Two 32-bit lanes in a 64-bit word, the first in the low half. -/
@[expose] def pack (a b : W32) : Word := a.zeroExtend 64 ||| b.zeroExtend 64 <<< 32

/-- An addition of 32-bit lanes is the addition of each lane. -/
theorem pack_add (a b c d : W32) :
    (BinOp.lanes 32 .add).eval (pack a b) (pack c d) = pack (a + c) (b + d) := by
  simp only [BinOp.eval_lanes, BinOp.eval_add, pack, Nat.reduceDiv, List.range,
    List.range.loop, List.foldl, Nat.reduceMul]
  bv_decide

/-- An addition of 32-bit lanes, the other way round. -/
theorem lanes_add_comm (x y : Word) :
    (BinOp.lanes 32 .add).eval x y = (BinOp.lanes 32 .add).eval y x := by
  simp only [BinOp.eval_lanes, BinOp.eval_add, Nat.reduceDiv, List.range, List.range.loop,
    List.foldl, Nat.reduceMul]
  bv_decide

/-- An exclusive or of words is that of each lane. -/
theorem pack_xor (a b c d : W32) : pack a b ^^^ pack c d = pack (a ^^^ c) (b ^^^ d) := by
  simp only [pack]
  bv_decide

/-- An or of words is that of each lane. -/
theorem pack_or (a b c d : W32) : pack a b ||| pack c d = pack (a ||| c) (b ||| d) := by
  simp only [pack]
  bv_decide

/-- A shift of a word to the left, under the mask that clears what crossed into the high
lane, is the shift of each lane. -/
theorem pack_shl16 (a b : W32) :
    pack a b <<< 16#64 &&& 0xffff0000ffff0000#64 = pack (a <<< 16) (b <<< 16) := by
  simp only [pack]
  bv_decide

theorem pack_shl12 (a b : W32) :
    pack a b <<< 12#64 &&& 0xfffff000fffff000#64 = pack (a <<< 12) (b <<< 12) := by
  simp only [pack]
  bv_decide

theorem pack_shl8 (a b : W32) :
    pack a b <<< 8#64 &&& 0xffffff00ffffff00#64 = pack (a <<< 8) (b <<< 8) := by
  simp only [pack]
  bv_decide

theorem pack_shl7 (a b : W32) :
    pack a b <<< 7#64 &&& 0xffffff80ffffff80#64 = pack (a <<< 7) (b <<< 7) := by
  simp only [pack]
  bv_decide

/-- A shift of a word to the right, under the mask that clears what crossed into the low
lane, is the shift of each lane. -/
theorem pack_shr16 (a b : W32) :
    pack a b >>> 16#64 &&& 0x0000ffff0000ffff#64 = pack (a >>> 16) (b >>> 16) := by
  simp only [pack]
  bv_decide

theorem pack_shr20 (a b : W32) :
    pack a b >>> 20#64 &&& 0x00000fff00000fff#64 = pack (a >>> 20) (b >>> 20) := by
  simp only [pack]
  bv_decide

theorem pack_shr24 (a b : W32) :
    pack a b >>> 24#64 &&& 0x000000ff000000ff#64 = pack (a >>> 24) (b >>> 24) := by
  simp only [pack]
  bv_decide

theorem pack_shr25 (a b : W32) :
    pack a b >>> 25#64 &&& 0x0000007f0000007f#64 = pack (a >>> 25) (b >>> 25) := by
  simp only [pack]
  bv_decide

/-- The high lane of a word and the low lane of another, as a word: how the lanes of a row
move when the row is rotated by an odd number of places. -/
theorem pack_ext (a b c d : W32) : pack a b >>> 32#64 ||| pack c d <<< 32#64 = pack b c := by
  simp only [pack]
  bv_decide

/-- The same, as code that builds a word a lane at a time writes it: the high lane of a
word, moved down and masked, and the low lane of another, moved up. -/
theorem pack_ext_mask (a b c d : W32) :
    pack a b >>> 32#64 &&& 0xffffffff#64 ||| pack c d >>> 0#64 <<< 32#64 = pack b c := by
  simp only [pack]
  bv_decide

/-- A word built a lane at a time from its own two lanes, each where it was, is the word:
how the lanes of a row move when the row is rotated by two places, the two words changing
places. -/
theorem lanes_self_mask (x : Word) :
    x >>> 0#64 &&& 0xffffffff#64 ||| x >>> 32#64 <<< 32#64 = x := by
  bv_decide

/-! ## Rotations of a lane -/

/-- A rotation by 16, as two shifts and an or. -/
theorem rotl16_or (a : W32) : a >>> 16 ||| a <<< 16 = a.rotateLeft 16 := by
  bv_decide

theorem rotl16_or' (a : W32) : a <<< 16 ||| a >>> 16 = a.rotateLeft 16 := by
  bv_decide

/-- A rotation, as two shifts and an addition: the shifted words have no bit in common. -/
theorem rotl12_add (a : W32) : a <<< 12 + a >>> 20 = a.rotateLeft 12 := by
  bv_decide

theorem rotl8_add (a : W32) : a <<< 8 + a >>> 24 = a.rotateLeft 8 := by
  bv_decide

theorem rotl7_add (a : W32) : a <<< 7 + a >>> 25 = a.rotateLeft 7 := by
  bv_decide

/-- A rotation, as two shifts and an or. -/
theorem rotl12_or (a : W32) : a <<< 12 ||| a >>> 20 = a.rotateLeft 12 := by
  bv_decide

theorem rotl8_or (a : W32) : a <<< 8 ||| a >>> 24 = a.rotateLeft 8 := by
  bv_decide

theorem rotl7_or (a : W32) : a <<< 7 ||| a >>> 25 = a.rotateLeft 7 := by
  bv_decide

/-- A rotation, as two shifts and an or, the shift to the right first: a rotation to the
right by 20, 24 or 25. -/
theorem rotl12_or' (a : W32) : a >>> 20 ||| a <<< 12 = a.rotateLeft 12 := by
  bv_decide

theorem rotl8_or' (a : W32) : a >>> 24 ||| a <<< 8 = a.rotateLeft 8 := by
  bv_decide

theorem rotl7_or' (a : W32) : a >>> 25 ||| a <<< 7 = a.rotateLeft 7 := by
  bv_decide

/-! ## A state in memory -/

/-- The eight bytes of a word of two lanes are the four of the first and the four of the
second. -/
theorem leBytes_pack (a b : W32) :
    leBytes 8 (pack a b) = leBytes 4 (a.zeroExtend 64) ++ leBytes 4 (b.zeroExtend 64) := by
  simp only [leBytes, pack, List.cons_append, List.nil_append, List.cons.injEq,
    _root_.and_true]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- The four low bytes of a word are those of its low 32 bits. -/
theorem leBytes_truncate (x : Word) :
    leBytes 4 ((x.truncate 32).zeroExtend 64) = leBytes 4 x := by
  simp only [leBytes, List.cons.injEq, _root_.and_true]
  refine ⟨?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- Two 32-bit cells side by side are one 64-bit cell that holds the two lanes. -/
theorem memIs_pack (p : Word) (a b : W32) :
    iprop(memIs p 4 (a.zeroExtend 64) true ∗ memIs (p + 4#64) 4 (b.zeroExtend 64) true) =
      memIs p 8 (pack a b) true := by
  rw [memIs_eq_bytesAt p _ 8 (by decide), leBytes_pack, bytesAt_append_eq, leBytes_length,
    memIs_eq_bytesAt p _ 4 (by decide), memIs_eq_bytesAt (p + 4#64) _ 4 (by decide)]

/-- Two 32-bit cells side by side that hold the low halves of two words are one 64-bit cell
that holds the two halves. -/
theorem memIs_pack_truncate (p x y : Word) :
    iprop(memIs p 4 x true ∗ memIs (p + 4#64) 4 y true) =
      memIs p 8 (pack (x.truncate 32) (y.truncate 32)) true := by
  rw [← memIs_pack, memIs_eq_bytesAt p x 4 (by decide),
    memIs_eq_bytesAt (p + 4#64) y 4 (by decide),
    memIs_eq_bytesAt p ((x.truncate 32).zeroExtend 64) 4 (by decide),
    memIs_eq_bytesAt (p + 4#64) ((y.truncate 32).zeroExtend 64) 4 (by decide),
    leBytes_truncate, leBytes_truncate]

/-- A list of lanes as a list of words, two lanes to a word. -/
@[expose] def packs : List W32 → List Word
  | a :: b :: s => pack a b :: packs s
  | _ => []

/-- **An array of 32-bit cells is an array of 64-bit cells**, each holding two of them: what
code that loads and stores a row a word at a time needs of an array in memory. The cells
hold any words, of which only the low halves are in memory. -/
theorem cells_packs_truncate : ∀ (n : Nat) (p : Word) (vs : List Word), vs.length = 2 * n →
    cellsAt 4 true p vs = cellsAt 8 true p (packs (vs.map (·.truncate 32)))
  | 0, _, [], _ => rfl
  | n + 1, p, x :: y :: vs, h => by
    have e : p + BitVec.ofNat 64 4 + BitVec.ofNat 64 4 = p + BitVec.ofNat 64 8 := by
      rw [BitVec.add_assoc]; rfl
    simp only [List.map_cons, cellsAt, packs, e]
    rw [← cells_packs_truncate n (p + BitVec.ofNat 64 8) vs (by simp at h; omega),
      ← memIs_pack_truncate]
    exact SProp.ext sep_assoc.symm
  | 0, _, _ :: _, h => by simp at h
  | _ + 1, _, [], h => by simp at h
  | _ + 1, _, [_], h => by simp at h; omega

/-- **A state in memory**, an array of 32-bit cells, is an array of 64-bit cells, each
holding two lanes. -/
theorem cells_packs (n : Nat) (p : Word) (s : List W32) (h : s.length = 2 * n) :
    cellsAt 4 true p (s.map (·.zeroExtend 64)) = cellsAt 8 true p (packs s) := by
  rw [cells_packs_truncate n p _ (by rw [List.length_map, h]), List.map_map]
  congr 2
  conv => rhs; rw [← List.map_id s]
  refine List.map_congr_left fun a _ => ?_
  show (a.zeroExtend 64).truncate 32 = a
  bv_decide

/-! ## The rows of a state -/

/-- The low word of row `i` of a state: its first two lanes. -/
@[expose] def rowLo (s : List W32) (i : Nat) : Word :=
  pack (s.getD (4 * i) 0) (s.getD (4 * i + 1) 0)

/-- The high word of row `i` of a state: its last two lanes. -/
@[expose] def rowHi (s : List W32) (i : Nat) : Word :=
  pack (s.getD (4 * i + 2) 0) (s.getD (4 * i + 3) 0)

/-- The words of a state of sixteen lanes are the two words of each of its four rows. -/
theorem packs16 (s : List W32) (h : s.length = 16) :
    packs s = [rowLo s 0, rowHi s 0, rowLo s 1, rowHi s 1, rowLo s 2, rowHi s 2, rowLo s 3,
      rowHi s 3] := by
  conv => lhs; rw [← eta16 s h]
  rfl

/-- A state with the lanes of its second, third and fourth rows rotated to the left by one,
two and three places, so that its diagonals stand in its columns. -/
@[expose] def shiftRows (s : List W32) : List W32 :=
  [s.getD 0 0, s.getD 1 0, s.getD 2 0, s.getD 3 0, s.getD 5 0, s.getD 6 0, s.getD 7 0,
    s.getD 4 0, s.getD 10 0, s.getD 11 0, s.getD 8 0, s.getD 9 0, s.getD 15 0, s.getD 12 0,
    s.getD 13 0, s.getD 14 0]

/-- A state with the lanes of its second, third and fourth rows rotated to the right by one,
two and three places: what undoes `shiftRows`. -/
@[expose] def unshiftRows (s : List W32) : List W32 :=
  [s.getD 0 0, s.getD 1 0, s.getD 2 0, s.getD 3 0, s.getD 7 0, s.getD 4 0, s.getD 5 0,
    s.getD 6 0, s.getD 10 0, s.getD 11 0, s.getD 8 0, s.getD 9 0, s.getD 13 0, s.getD 14 0,
    s.getD 15 0, s.getD 12 0]

theorem length_shiftRows (s : List W32) : (shiftRows s).length = 16 := rfl

theorem length_unshiftRows (s : List W32) : (unshiftRows s).length = 16 := rfl

/-- **A diagonal round is a column round between two rotations of the rows.** -/
theorem diagonals_eq_shift (s : List W32) :
    diagonals s = unshiftRows (columns (shiftRows s)) := rfl

/-- **A double round**, as vector code computes it: a column round, the rows rotated, a
column round, and the rows rotated back. A column round is the quarter round of the
specification in each of the four lanes of the rows (`ChaCha20.columns`). -/
theorem inner_eq_shift (s : List W32) (h : s.length = 16) :
    inner s = unshiftRows (columns (shiftRows (columns s))) := by
  rw [inner_eq s h, diagonals_eq_shift]

/-! ## The sum with the state -/

/-- A word of the sum of two lists of one length is the sum of the words. -/
theorem getD_zipWith_add (t s : List W32) (hl : t.length = s.length) (j : Nat) :
    (List.zipWith (· + ·) t s).getD j 0 = t.getD j 0 + s.getD j 0 := by
  by_cases h : j < s.length
  · simp [List.getD_eq_getElem?_getD, List.getElem?_zipWith, List.getElem?_eq_getElem h,
      List.getElem?_eq_getElem (hl ▸ h)]
  · have h' : s.length ≤ j := Nat.le_of_not_lt h
    simp [List.getD_eq_getElem?_getD, List.getElem?_zipWith, List.getElem?_eq_none h',
      List.getElem?_eq_none (hl ▸ h')]

/-- A word of the block function is the sum of a word of the state after the rounds and one
of the state. -/
theorem getD_block (s : List W32) (j : Nat) :
    (block s).getD j 0 = (innerN 10 s).getD j 0 + s.getD j 0 :=
  getD_zipWith_add _ s (length_innerN 10 s) j

/-- The low word of a row of the block function is the addition of lanes of that of the
state after the rounds and that of the state. -/
theorem rowLo_block (s : List W32) (i : Nat) :
    rowLo (block s) i = (BinOp.lanes 32 .add).eval (rowLo (innerN 10 s) i) (rowLo s i) := by
  simp only [rowLo, getD_block, pack_add]

theorem rowHi_block (s : List W32) (i : Nat) :
    rowHi (block s) i = (BinOp.lanes 32 .add).eval (rowHi (innerN 10 s) i) (rowHi s i) := by
  simp only [rowHi, getD_block, pack_add]

/-- The same, with the state on the left of the addition. -/
theorem rowLo_block_comm (s : List W32) (i : Nat) :
    rowLo (block s) i = (BinOp.lanes 32 .add).eval (rowLo s i) (rowLo (innerN 10 s) i) := by
  rw [rowLo_block, lanes_add_comm]

theorem rowHi_block_comm (s : List W32) (i : Nat) :
    rowHi (block s) i = (BinOp.lanes 32 .add).eval (rowHi s i) (rowHi (innerN 10 s) i) := by
  rw [rowHi_block, lanes_add_comm]

end Examples.ChaCha20Vec
