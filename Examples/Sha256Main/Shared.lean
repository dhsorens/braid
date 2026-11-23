/-
  Examples.Sha256Main.Shared

  What the proofs about the whole program share on every instruction set, beyond the
  mathematics of padding (`Examples.Sha256Main.Common`): arrays opened at an index and
  extended at their end, cells given a value of the specification, the lengths as compiled
  code computes them, and small facts about the hash value and the digest as lists.

  ## Main results

  * `bytesAt_index`, `cellsAt_snoc`: an array of bytes opened at an index, and an array of
    cells with one more cell at its end
  * `TripleT.mem1_val`, `TripleT.mem4_val`: a cell of one byte or of four given a value with
    the same low bits
  * `total_mask`, `total_shift`, `shl2`, `shl3`: lengths and shifts, as the code computes them
  * `compress_length`, `foldl_compress_length`, `sha256_eq_foldl`: the hash value block
    after block, and the digest as its bytes
-/

module

public import Examples.Sha256Main.Common
public import Examples.Sha256.Common
public import Braid.Logic
import Std.Tactic.BVDecide
import Braid.BV

public section

namespace Examples.Sha256Main

open Braid Examples Examples.Sha256

/-- An array of bytes, opened at index `i`. -/
theorem bytesAt_index (p : Word) (bs : List (BitVec 8)) (i : Nat) (hi : i < bs.length) :
    (Atom.prop (bytesAt p bs)).interp =
      Atoms.interp [.prop (bytesAt p (bs.take i)),
        .mem (p + BitVec.ofNat 64 i) 1 ((bs.getD i 0#8).zeroExtend 64) true,
        .prop (bytesAt (p + BitVec.ofNat 64 i + 1#64) (bs.drop (i + 1)))] := by
  rw [bytesAt_split p bs i (Nat.le_of_lt hi)]
  have hd : bs.drop i = bs.getD i 0#8 :: bs.drop (i + 1) := by
    rw [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hi]
    exact List.drop_eq_getElem_cons hi
  simp only [Atoms.interp_cons, Atoms.interp_nil, Atom.interp, hd, bytesAt]
  exact SProp.ext ⟨Iris.BI.sep_mono_right Iris.BI.sep_assoc.1,
    Iris.BI.sep_mono_right Iris.BI.sep_assoc.2⟩

/-- An array with one more cell at its end, which is at `q`. -/
theorem cellsAt_snoc (p q v : Word) (xs : List Word) (k : Nat) (w : Bool)
    (hq : q = p + BitVec.ofNat 64 (k * xs.length)) :
    (Atom.prop (cellsAt k w p (xs ++ [v]))).interp =
      Atoms.interp [.prop (cellsAt k w p xs), .mem q k v w] := by
  subst hq
  have e : cellsAt k w (p + BitVec.ofNat 64 (k * xs.length)) [v] =
      memIs (p + BitVec.ofNat 64 (k * xs.length)) k v w :=
    SProp.ext ⟨Iris.BI.sep_emp.1, Iris.BI.sep_emp.2⟩
  rw [cellsAt_append, sep_interp_pair, e]
  rfl

/-- An index scaled by four, as the code computes it. -/
theorem shl2 (x : Word) : x <<< 2#64 = x * 4#64 := by bv_auto

/-- The words of a block, the first `j` and one more. -/
theorem w32s_range_succ (msg : List (BitVec 8)) (b j : Nat) :
    w32s ((List.range j).map (blockWord msg b)) ++ [(blockWord msg b j).setWidth 64] =
      w32s ((List.range (j + 1)).map (blockWord msg b)) := by
  simp [w32s, List.range_succ]

/-- The compression of a hash value of eight words is eight words. -/
theorem compress_length (H M : List W32) (h : H.length = 8) : (compress H M).length = 8 := by
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ := eq_of_length_8 h
  rfl

theorem ult_false {a b : Word} (h : b.toNat ≤ a.toNat) : a.ult b = false := by
  rw [← Bool.not_eq_true, BitVec.ult_iff_lt]
  bv_omega

theorem ult_true {a b : Word} (h : a.toNat < b.toNat) : a.ult b = true := by
  rw [BitVec.ult_iff_lt]
  bv_omega

/-- Replace the value of a one-byte cell of the symbolic state by one with the same low
byte. -/
theorem _root_.Braid.TripleT.mem1_val {P : Program} {as as' : Atoms} {a v : Word} {w : Bool}
    {t t' : Trace} (v' : Word) {Q : SProp} (hupd : as.Upd (.mem a 1 v w) (.mem a 1 v' w) as')
    (he : v.truncate 8 = v'.truncate 8)
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  obtain ⟨F, e, e'⟩ := hupd.split
  have em : (Atom.mem a 1 v w).interp = (Atom.mem a 1 v' w).interp := by
    show memIs a 1 v w = memIs a 1 v' w
    funext h
    simp only [memIs, Heap.bytes_byte a v w, Heap.bytes_byte a v' w, he]
  rw [e, em]; rw [e'] at h
  exact h

theorem w32s_cons (x : W32) (xs : List W32) : w32s (x :: xs) = x.setWidth 64 :: w32s xs := rfl

theorem flatMap_wordBytes_cons (x : W32) (xs : List W32) :
    (x :: xs).flatMap wordBytes =
      (x >>> 24).setWidth 8 :: (x >>> 16).setWidth 8 :: (x >>> 8).setWidth 8 :: x.setWidth 8 ::
        xs.flatMap wordBytes := rfl

/-- The padded length less a block: the length and eight, rounded down to a block. -/
theorem total_mask (n : Nat) (hn : n < 2 ^ 32) :
    BitVec.ofNat 64 n + 8#64 &&& 18446744073709551552#64 = BitVec.ofNat 64 (total n - 64) := by
  have key : ∀ x : Word, x &&& 18446744073709551552#64 = (x >>> 6) <<< 6 := by
    intro x; bv_auto
  rw [key]
  simp only [total]
  bv_omega

/-- The shift of the first byte of the length, as the code computes it. -/
theorem total_shift (n : Nat) (hn : n < 2 ^ 32) :
    (BitVec.ofNat 64 n + 8#64) <<< 3#64 ||| 504#64 =
      BitVec.ofNat 64 (8 * (total n - 1 - 64 * 0)) := by
  have key : ∀ x : Word, x <<< 3#64 ||| 504#64 =
      ((x &&& 18446744073709551552#64) + 63#64) * 8#64 := by
    intro x; bv_auto
  have hT : 64 ≤ total n := by simp only [total]; omega
  have hT' := total_lt n
  rw [key, total_mask n hn]
  bv_omega

theorem shl3 (n : Nat) : BitVec.ofNat 64 n <<< 3#64 = BitVec.ofNat 64 (8 * n) := by
  have key : ∀ x : Word, x <<< 3#64 = x * 8#64 := by intro x; bv_auto
  rw [key]
  bv_omega

/-- A hash value of eight words stays one of eight words, block after block. -/
theorem foldl_compress_length (Ms : List (List W32)) : ∀ (H : List W32), H.length = 8 →
    (Ms.foldl compress H).length = 8 := by
  induction Ms with
  | nil => exact fun H h => h
  | cons M Ms ih => exact fun H h => ih _ (compress_length H M h)

/-- The digest is the hash value after the blocks of the padded message, as bytes. -/
theorem sha256_eq_foldl (msg : List (BitVec 8)) (r : Nat)
    (hr : 64 * (0 + r + 1) = total msg.length) :
    sha256 msg =
      (((List.range' 0 (r + 1)).map (block msg)).foldl compress H0).flatMap wordBytes := by
  rw [sha256_eq, blocks, List.range_eq_range', show total msg.length / 64 = r + 1 from by omega]

/-- Eight words are 32 bytes. -/
theorem flatMap_wordBytes_length (H : List W32) : (H.flatMap wordBytes).length = 4 * H.length := by
  induction H with
  | nil => rfl
  | cons x xs ih => simp [wordBytes, ih]; omega

theorem H0_eq : H0 = [0x6a09e667#32, 0xbb67ae85#32, 0x3c6ef372#32, 0xa54ff53a#32,
    0x510e527f#32, 0x9b05688c#32, 0x1f83d9ab#32, 0x5be0cd19#32] := rfl

/-- Replace the value of a 32-bit cell of the symbolic state by one with the same low 32
bits. -/
theorem _root_.Braid.TripleT.mem4_val {P : Program} {as as' : Atoms} {a v : Word} {w : Bool}
    {t t' : Trace} (v' : Word) {Q : SProp} (hupd : as.Upd (.mem a 4 v w) (.mem a 4 v' w) as')
    (he : v.setWidth 32 = v'.setWidth 32)
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  obtain ⟨F, e, e'⟩ := hupd.split
  have em : (Atom.mem a 4 v w).interp = (Atom.mem a 4 v' w).interp := by
    show memIs a 4 v w = memIs a 4 v' w
    funext h
    simp only [memIs, Heap.bytes_setWidth32 a v w, Heap.bytes_setWidth32 a v' w, he]
  rw [e, em]; rw [e'] at h
  exact h

/-- A cell of eight bytes is two cells of four: the low half, and the high half. -/
theorem mem8_split (a v : Word) :
    (Atom.mem a 8 v true).interp =
      Atoms.interp [.mem a 4 v true, .mem (a + 4#64) 4 (v >>> 32) true] := by
  have e : leBytes 8 v = leBytes 4 v ++ leBytes 4 (v >>> 32) := by
    simp only [leBytes, List.cons_append, List.nil_append, List.cons.injEq, and_true]
    refine ⟨trivial, trivial, trivial, trivial, ?_, ?_, ?_, ?_⟩ <;> bv_auto
  show memIs a 8 v true = iprop(memIs a 4 v true ∗ memIs (a + 4#64) 4 (v >>> 32) true ∗ emp)
  rw [memIs_eq_bytesAt a v 8 (by decide), memIs_eq_bytesAt a v 4 (by decide),
    memIs_eq_bytesAt (a + 4#64) (v >>> 32) 4 (by decide), e, bytesAt_append_eq, leBytes_length]
  exact SProp.ext ⟨Iris.BI.sep_mono_right Iris.BI.sep_emp.2,
    Iris.BI.sep_mono_right Iris.BI.sep_emp.1⟩

/-- The padded length less eight, as the code computes it from the padded length less a
block. -/
theorem total_or (n : Nat) (hn : n < 2 ^ 32) :
    BitVec.ofNat 64 (total n - 64) ||| 56#64 = BitVec.ofNat 64 (total n - 8) := by
  have key : ∀ x : Word, (x &&& 18446744073709551552#64) ||| 56#64 =
      (x &&& 18446744073709551552#64) + 56#64 := by
    intro x; bv_auto
  have hT : 64 ≤ total n := by simp only [total]; omega
  have hT' := total_lt n
  rw [← total_mask n hn, key, total_mask n hn]
  bv_omega

end Examples.Sha256Main
