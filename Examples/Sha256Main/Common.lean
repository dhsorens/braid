/-
  Examples.Sha256Main.Common

  SHA-256 of a message of bytes, as a program computes it: block by block, with the padding
  written out byte by byte. The specification (`Examples.Spec.Sha256`) pads a string of bits
  and cuts it into blocks of sixteen words; here the padded message is described by its
  bytes (`padByte`), a block by its sixteen big-endian words (`block`), and the two are proved
  to agree. Nothing here mentions a machine.

  ## Main definitions

  * `total`: the length of the padded message, in bytes
  * `padByte`, `padBytes`: one byte of the padded message, and all of them
  * `be32`, `blockWord`, `block`, `blocks`: a big-endian word of four bytes, and the padded
    message as blocks of sixteen such words

  ## Main results

  * `padByte_lt`, `padByte_eq`, `padByte_zero`, `padByte_len`: the four cases of `padByte`,
    the last with the 64-bit shift a program computes
  * `pad_bytesToBits`: the padding of the standard, of a whole number of bytes, is `padBytes`
  * `parse_bytesToBits`: parsing a whole number of blocks of bytes, as big-endian words
  * `parse_pad`: the padded and parsed message is `blocks`
  * `hashWords_bytes`, `sha256_eq`: the hash value and the digest are the fold of the
    compression function over `blocks`
  * `blocks_length`, `block_length`, `dvd_total`, `le_total`, `total_lt`: sizes
-/

module

public import Examples.Spec.Sha256
import Std.Tactic.BVDecide

@[expose] public section

namespace Examples.Sha256Main

open Sha256

/-! ## The padded message -/

/-- The length of the padded message, in bytes: the message, one byte `0x80`, and eight bytes
of length, rounded up to a block. -/
def total (n : Nat) : Nat := ((n + 8) / 64 + 1) * 64

/-- Byte `k` of the padded message. -/
def padByte (msg : List (BitVec 8)) (k : Nat) : BitVec 8 :=
  if k < msg.length then msg.getD k 0
  else if k = msg.length then 0x80
  else if total msg.length - 8 ≤ k then
    BitVec.ofNat 8 ((8 * msg.length) >>> (8 * (total msg.length - 1 - k)))
  else 0

/-- The padded message, as bytes. -/
def padBytes (msg : List (BitVec 8)) : List (BitVec 8) :=
  (List.range (total msg.length)).map (padByte msg)

/-- The 32-bit word of four bytes, most significant first. -/
def be32 (a b c d : BitVec 8) : W32 :=
  a.setWidth 32 <<< 24 ||| b.setWidth 32 <<< 16 ||| c.setWidth 32 <<< 8 ||| d.setWidth 32

/-- Word `j` of block `b`: four bytes of the padded message, most significant first. -/
def blockWord (msg : List (BitVec 8)) (b j : Nat) : W32 :=
  be32 (padByte msg (64 * b + 4 * j)) (padByte msg (64 * b + 4 * j + 1))
    (padByte msg (64 * b + 4 * j + 2)) (padByte msg (64 * b + 4 * j + 3))

/-- Block `b` of the padded message: sixteen words. -/
def block (msg : List (BitVec 8)) (b : Nat) : List W32 := (List.range 16).map (blockWord msg b)

/-- The blocks of the padded message. -/
def blocks (msg : List (BitVec 8)) : List (List W32) :=
  (List.range (total msg.length / 64)).map (block msg)

/-! ## Sizes -/

/-- The padded message is a whole number of blocks. -/
theorem dvd_total (n : Nat) : 64 ∣ total n := ⟨(n + 8) / 64 + 1, by simp [total, Nat.mul_comm]⟩

/-- The padded message has room for the message, the byte `0x80` and the length. -/
theorem le_total (n : Nat) : n + 9 ≤ total n := by simp only [total]; omega

/-- Padding adds less than a block and nine bytes. -/
theorem total_lt (n : Nat) : total n < n + 73 := by simp only [total]; omega

@[simp] theorem padBytes_length (msg : List (BitVec 8)) :
    (padBytes msg).length = total msg.length := by simp [padBytes]

/-- A block has sixteen words. -/
@[simp] theorem block_length (msg : List (BitVec 8)) (b : Nat) : (block msg b).length = 16 := by
  simp [block]

/-- The number of blocks of the padded message. -/
@[simp] theorem blocks_length (msg : List (BitVec 8)) :
    (blocks msg).length = total msg.length / 64 := by simp [blocks]

/-! ## Bits of bytes -/

theorem natToBitsBE_length (w n : Nat) : (natToBitsBE w n).length = w := by simp [natToBitsBE]

theorem natToBitsBE_getElem? (w n i : Nat) :
    (natToBitsBE w n)[i]? = if i < w then some (n.testBit (w - 1 - i)) else none := by
  by_cases h : i < w
  · simp [natToBitsBE, h]
  · simp [natToBitsBE, h]

theorem bytesToBits_cons (b : BitVec 8) (bs : List (BitVec 8)) :
    bytesToBits (b :: bs) = natToBitsBE 8 b.toNat ++ bytesToBits bs := by
  simp [bytesToBits]

theorem bytesToBits_length (bs : List (BitVec 8)) : (bytesToBits bs).length = 8 * bs.length := by
  induction bs with
  | nil => rfl
  | cons b bs ih => simp [bytesToBits_cons, natToBitsBE_length, ih]; omega

/-- Bit `i` of a list of bytes is bit `7 - i % 8` of byte `i / 8`. -/
theorem bytesToBits_getElem? (bs : List (BitVec 8)) (i : Nat) :
    (bytesToBits bs)[i]? = bs[i / 8]?.map fun b => b.toNat.testBit (7 - i % 8) := by
  induction bs generalizing i with
  | nil => simp [bytesToBits]
  | cons b bs ih =>
    rw [bytesToBits_cons, List.getElem?_append, natToBitsBE_length]
    by_cases hi : i < 8
    · have h0 : i / 8 = 0 := by omega
      have h1 : i % 8 = i := by omega
      simp [hi, h0, h1, natToBitsBE_getElem?]
    · have h0 : i / 8 = (i - 8) / 8 + 1 := by omega
      have h1 : i % 8 = (i - 8) % 8 := by omega
      simp [hi, h0, h1, ih]

theorem bytesToBits_drop (bs : List (BitVec 8)) (k : Nat) :
    (bytesToBits bs).drop (8 * k) = bytesToBits (bs.drop k) := by
  induction k generalizing bs with
  | zero => simp
  | succ k ih =>
    cases bs with
    | nil => simp [bytesToBits]
    | cons b bs =>
      rw [bytesToBits_cons, List.drop_succ_cons, ← ih, List.drop_append, natToBitsBE_length,
        List.drop_of_length_le (by rw [natToBitsBE_length]; omega), List.nil_append]
      congr 1

theorem bytesToBits_take (bs : List (BitVec 8)) (k : Nat) :
    (bytesToBits bs).take (8 * k) = bytesToBits (bs.take k) := by
  induction k generalizing bs with
  | zero => simp [bytesToBits]
  | succ k ih =>
    cases bs with
    | nil => simp [bytesToBits]
    | cons b bs =>
      rw [List.take_succ_cons, bytesToBits_cons, bytesToBits_cons, ← ih, List.take_append,
        natToBitsBE_length, List.take_of_length_le (by rw [natToBitsBE_length]; omega)]
      congr 2

/-! ## Padding -/

/-- The length of the padding of the standard, for a whole number of bytes. -/
theorem pad_length (msg : List (BitVec 8)) :
    (pad (bytesToBits msg)).length = 8 * total msg.length := by
  simp only [pad, List.length_append, List.length_replicate, natToBitsBE_length,
    bytesToBits_length, List.length_singleton, padZeros, total]
  omega

theorem testBit_0x80 (r : Nat) (h : r < 8) : (128).testBit (7 - r) = decide (r = 0) := by
  have : ∀ r : Fin 8, (128).testBit (7 - r.val) = decide (r.val = 0) := by decide
  exact this ⟨r, h⟩

/-- The padding of the standard, applied to a whole number of bytes, is the bytes of
`padBytes`. -/
theorem pad_bytesToBits (msg : List (BitVec 8)) :
    pad (bytesToBits msg) = bytesToBits (padBytes msg) := by
  apply List.ext_getElem?
  intro i
  have hT := le_total msg.length
  have hz7 : 7 ≤ padZeros (8 * msg.length) := by simp only [padZeros]; omega
  have hz : 8 * msg.length + 1 + padZeros (8 * msg.length) + 64 = 8 * total msg.length := by
    simp only [padZeros, total]; omega
  by_cases hi : i < 8 * total msg.length
  · have hk : i / 8 < total msg.length := by omega
    rw [bytesToBits_getElem?, padBytes, List.getElem?_map, List.getElem?_range hk]
    simp only [pad, List.getElem?_append, List.length_append, List.length_replicate,
      bytesToBits_length, List.length_singleton, bytesToBits_getElem?, natToBitsBE_getElem?,
      List.getElem?_replicate, padByte, Option.map_some]
    by_cases h1 : i < 8 * msg.length
    · have h1' : i / 8 < msg.length := by omega
      simp [h1, h1', show i < 8 * msg.length + 1 by omega,
        show i < 8 * msg.length + 1 + padZeros (8 * msg.length) by omega]
    · have h1' : ¬ i / 8 < msg.length := by omega
      by_cases h2 : i / 8 = msg.length
      · by_cases h3 : i = 8 * msg.length
        · simp [h3, show 8 * msg.length < 8 * msg.length + 1 + padZeros (8 * msg.length) by omega,
            show Nat.testBit 128 7 = true by decide]
        · have hr := testBit_0x80 (i % 8) (by omega)
          have hr' : i % 8 ≠ 0 := by omega
          simp [h2, hr, hr', show i < 8 * msg.length + 1 + padZeros (8 * msg.length) by omega,
            show ¬ i < 8 * msg.length + 1 by omega,
            show i - (8 * msg.length + 1) < padZeros (8 * msg.length) by omega]
      · by_cases h3 : total msg.length - 8 ≤ i / 8
        · have h5 : i - (8 * msg.length + 1 + padZeros (8 * msg.length)) < 64 := by omega
          have h6 : 64 - 1 - (i - (8 * msg.length + 1 + padZeros (8 * msg.length))) =
              8 * (total msg.length - 1 - i / 8) + (7 - i % 8) := by omega
          simp [h1', h2, h3, h5, h6,
            show ¬ i < 8 * msg.length + 1 + padZeros (8 * msg.length) by omega]
          rw [show (256 : Nat) = 2 ^ 8 from rfl, Nat.testBit_mod_two_pow, Nat.testBit_shiftRight,
            decide_eq_true (show 7 - i % 8 < 8 by omega), Bool.true_and]
        · simp [h1', h2, h3,
            show i < 8 * msg.length + 1 + padZeros (8 * msg.length) by omega,
            show ¬ i < 8 * msg.length + 1 by omega,
            show i - (8 * msg.length + 1) < padZeros (8 * msg.length) by omega]
  · rw [List.getElem?_eq_none (by rw [pad_length]; omega),
      List.getElem?_eq_none (by rw [bytesToBits_length, padBytes_length]; omega)]

/-! ## Parsing -/

theorem chunks_go_eq {α : Type} (k : Nat) (hk : 0 < k) (m fuel : Nat) (l : List α)
    (hl : l.length = k * m) (hf : m ≤ fuel) :
    chunks.go k fuel l = (List.range m).map fun i => (l.drop (k * i)).take k := by
  induction m generalizing fuel l with
  | zero =>
    have : l = [] := List.eq_nil_of_length_eq_zero (by simpa using hl)
    subst this
    cases fuel <;> simp [chunks.go]
  | succ m ih =>
    obtain ⟨fuel, rfl⟩ : ∃ f, fuel = f + 1 := ⟨fuel - 1, by omega⟩
    cases l with
    | nil => simp [Nat.mul_succ] at hl; omega
    | cons a l =>
      rw [chunks.go, ih fuel _ (by simp [Nat.mul_succ] at hl ⊢; omega) (by omega),
        List.range_succ_eq_map]
      simp [Nat.mul_succ, Nat.add_comm]

/-- A list of `m` pieces of length `k`, cut into its pieces. -/
theorem chunks_eq {α : Type} (k : Nat) (hk : 0 < k) (m : Nat) (l : List α)
    (hl : l.length = k * m) :
    chunks k l = (List.range m).map fun i => (l.drop (k * i)).take k :=
  chunks_go_eq k hk m _ l hl (by rw [hl]; exact Nat.le_mul_of_pos_left m hk)

theorem foldl_bits (bs : List Bool) (acc : Nat) :
    bs.foldl (fun acc b => 2 * acc + b.toNat) acc = acc * 2 ^ bs.length + bitsToNatBE bs := by
  induction bs generalizing acc with
  | nil => simp [bitsToNatBE]
  | cons b bs ih =>
    rw [bitsToNatBE, List.foldl_cons, List.foldl_cons, ih, ih (2 * 0 + b.toNat),
      List.length_cons, Nat.pow_succ]
    simp only [Nat.add_mul, Nat.mul_zero, Nat.zero_add, Nat.add_assoc]
    congr 1
    rw [Nat.mul_comm 2 acc, Nat.mul_assoc, Nat.mul_comm 2]

theorem bitsToNatBE_append (xs ys : List Bool) :
    bitsToNatBE (xs ++ ys) = bitsToNatBE xs * 2 ^ ys.length + bitsToNatBE ys := by
  rw [bitsToNatBE, List.foldl_append, foldl_bits]
  rfl

theorem bitsToNatBE_byte (b : BitVec 8) : bitsToNatBE (natToBitsBE 8 b.toNat) = b.toNat := by
  have : ∀ n : Fin 256, bitsToNatBE (natToBitsBE 8 n.val) = n.val := by decide +kernel
  exact this ⟨b.toNat, b.isLt⟩

/-- Four bytes read as a big-endian number of 32 bits. -/
theorem ofNat_bitsToNatBE_bytes (a b c d : BitVec 8) :
    BitVec.ofNat 32 (bitsToNatBE (bytesToBits [a, b, c, d])) = be32 a b c d := by
  simp only [bytesToBits, List.flatMap_cons, List.flatMap_nil, List.append_nil,
    bitsToNatBE_append, bitsToNatBE_byte, List.length_append, natToBitsBE_length]
  simp only [BitVec.ofNat_add, BitVec.ofNat_mul, BitVec.ofNat_toNat, be32, Nat.reduceAdd,
    Nat.reducePow]
  bv_decide

/-! ## The cases of a byte of the padded message -/

/-- Below the length of the message, the padded message is the message. -/
theorem padByte_lt (msg : List (BitVec 8)) (k : Nat) (h : k < msg.length) :
    padByte msg k = msg.getD k 0#8 := by
  simp [padByte, h]

/-- The byte after the message is `0x80`. -/
theorem padByte_eq (msg : List (BitVec 8)) : padByte msg msg.length = 0x80#8 := by
  simp [padByte]

/-- Between the byte `0x80` and the length, the padded message is zero. -/
theorem padByte_zero (msg : List (BitVec 8)) (k : Nat) (h : msg.length < k)
    (hk : k < total msg.length - 8) : padByte msg k = 0#8 := by
  rw [padByte]
  split
  · omega
  · split
    · omega
    · split
      · omega
      · rfl

/-- The last eight bytes of the padded message are the length of the message in bits, as a
64-bit big-endian number: each is a byte of a 64-bit shift. -/
theorem padByte_len (msg : List (BitVec 8)) (k : Nat) (hn : msg.length < 2 ^ 61)
    (h : total msg.length - 8 ≤ k) (hk : k < total msg.length) :
    padByte msg k =
      ((BitVec.ofNat 64 (8 * msg.length)) >>> (8 * (total msg.length - 1 - k))).setWidth 8 := by
  have hT := le_total msg.length
  have e : padByte msg k =
      BitVec.ofNat 8 ((8 * msg.length) >>> (8 * (total msg.length - 1 - k))) := by
    rw [padByte]
    split
    · omega
    · split
      · omega
      · rfl
  rw [e]
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_ofNat, BitVec.toNat_setWidth, BitVec.toNat_ushiftRight]
  rw [Nat.mod_eq_of_lt (a := 8 * msg.length) (by omega)]

/-! ## The padded message, parsed -/

theorem getD_padBytes (msg : List (BitVec 8)) (k : Nat) (h : k < total msg.length) :
    (padBytes msg).getD k 0#8 = padByte msg k := by
  simp [padBytes, h]

theorem take_four_drop (bs : List (BitVec 8)) (k : Nat) (h : k + 4 ≤ bs.length) :
    (bs.drop k).take 4 =
      [bs.getD k 0#8, bs.getD (k + 1) 0#8, bs.getD (k + 2) 0#8, bs.getD (k + 3) 0#8] := by
  apply List.ext_getElem?
  intro i
  rcases i with _ | _ | _ | _ | i <;> simp [List.getElem?_take, List.getElem?_drop] <;>
    first | omega | (rw [List.getElem?_eq_getElem (by omega)]; rfl)

/-- Parsing the bits of `m` blocks of 64 bytes gives, for each block, its sixteen big-endian
words. -/
theorem parse_bytesToBits (bs : List (BitVec 8)) (m : Nat) (h : bs.length = 64 * m) :
    parse (bytesToBits bs) = (List.range m).map fun b => (List.range 16).map fun j =>
      be32 (bs.getD (64 * b + 4 * j) 0#8) (bs.getD (64 * b + 4 * j + 1) 0#8)
        (bs.getD (64 * b + 4 * j + 2) 0#8) (bs.getD (64 * b + 4 * j + 3) 0#8) := by
  rw [parse, chunks_eq 512 (by omega) m _ (by rw [bytesToBits_length]; omega), List.map_map]
  apply List.map_congr_left
  intro b hb
  have hb' : b < m := List.mem_range.mp hb
  simp only [Function.comp_apply]
  rw [show 512 * b = 8 * (64 * b) by omega, bytesToBits_drop,
    show 512 = 8 * 64 from rfl, bytesToBits_take,
    chunks_eq 32 (by omega) 16 _ (by rw [bytesToBits_length]; simp; omega), List.map_map]
  apply List.map_congr_left
  intro j hj
  have hj' : j < 16 := List.mem_range.mp hj
  simp only [Function.comp_apply]
  rw [show 32 * j = 8 * (4 * j) by omega, bytesToBits_drop,
    show ∀ l, (bytesToBits l).take 32 = bytesToBits (l.take 4) from
      fun l => bytesToBits_take l 4, List.drop_take, List.take_take,
    show min 4 (64 - 4 * j) = 4 by omega, List.drop_drop,
    take_four_drop _ _ (by omega), ofNat_bitsToNatBE_bytes]

/-- The padded and parsed message, of a whole number of bytes, is `blocks`. -/
theorem parse_pad (msg : List (BitVec 8)) : parse (pad (bytesToBits msg)) = blocks msg := by
  have hd := dvd_total msg.length
  rw [pad_bytesToBits, parse_bytesToBits _ (total msg.length / 64) (by simp; omega), blocks]
  apply List.map_congr_left
  intro b hb
  have hb' := List.mem_range.mp hb
  rw [block]
  apply List.map_congr_left
  intro j hj
  have hj' := List.mem_range.mp hj
  rw [blockWord, getD_padBytes _ _ (by omega), getD_padBytes _ _ (by omega),
    getD_padBytes _ _ (by omega), getD_padBytes _ _ (by omega)]

/-- The hash value of a message of bytes is the fold of the compression function over its
blocks. -/
theorem hashWords_bytes (msg : List (BitVec 8)) :
    hashWords (bytesToBits msg) = (blocks msg).foldl compress H0 := by
  rw [hashWords, parse_pad]

/-- SHA-256 of a message of bytes: compress the blocks of the padded message in turn, and
write out the bytes of the result. -/
theorem sha256_eq (msg : List (BitVec 8)) :
    sha256 msg = ((blocks msg).foldl compress H0).flatMap wordBytes := by
  rw [sha256, hashWords_bytes]

end Examples.Sha256Main
