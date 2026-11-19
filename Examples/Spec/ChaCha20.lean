/-
  Examples.Spec.ChaCha20

  The ChaCha20 block function, as RFC 8439 defines it: a plain Lean definition, which the
  machine code of the examples is proved against. hash-specs has no ChaCha20, so this is
  written here from the RFC and checked against the RFC's test vectors.

  ## Main definitions

  * `ChaCha20.quarter`: the quarter round on four words
  * `ChaCha20.quarterAt`: the quarter round on four words of a state
  * `ChaCha20.inner`: a column round and a diagonal round
  * `ChaCha20.block`: the block function on a state of sixteen words

  ## References

  * [RFC 8439] Y. Nir, A. Langley, *ChaCha20 and Poly1305 for IETF Protocols*, 2018.
-/

module

@[expose] public section

namespace Examples.ChaCha20

/-- A word of ChaCha20. -/
abbrev W32 := BitVec 32

/-- The quarter round [RFC 8439, §2.1]. -/
def quarter (a b c d : W32) : W32 × W32 × W32 × W32 :=
  let a := a + b
  let d := (d ^^^ a).rotateLeft 16
  let c := c + d
  let b := (b ^^^ c).rotateLeft 12
  let a := a + b
  let d := (d ^^^ a).rotateLeft 8
  let c := c + d
  let b := (b ^^^ c).rotateLeft 7
  (a, b, c, d)

/-- The quarter round on the words at four indices of a state [RFC 8439, §2.2]. -/
def quarterAt (s : List W32) (i j k l : Nat) : List W32 :=
  let r := quarter (s.getD i 0) (s.getD j 0) (s.getD k 0) (s.getD l 0)
  (((s.set i r.1).set j r.2.1).set k r.2.2.1).set l r.2.2.2

/-- A column round and then a diagonal round [RFC 8439, §2.3]. -/
def inner (s : List W32) : List W32 :=
  let s := quarterAt s 0 4 8 12
  let s := quarterAt s 1 5 9 13
  let s := quarterAt s 2 6 10 14
  let s := quarterAt s 3 7 11 15
  let s := quarterAt s 0 5 10 15
  let s := quarterAt s 1 6 11 12
  let s := quarterAt s 2 7 8 13
  quarterAt s 3 4 9 14

/-- `inner`, `n` times. -/
def innerN : Nat → List W32 → List W32
  | 0, s => s
  | n + 1, s => innerN n (inner s)

/-- The block function: twenty rounds, and the state added to the result [RFC 8439, §2.3]. -/
def block (s : List W32) : List W32 := List.zipWith (· + ·) (innerN 10 s) s

/-! ## Test vectors -/

/-- The quarter round [RFC 8439, §2.1.1]. -/
theorem quarter_test : quarter 0x11111111 0x01020304 0x9b8d6f43 0x01234567 =
    (0xea2a92f4, 0xcb1cf8ce, 0x4581472e, 0x5881c4bb) := by
  decide +kernel

/-- The quarter round on a state [RFC 8439, §2.2.1]. -/
theorem quarterAt_test :
    quarterAt [0x879531e0, 0xc5ecf37d, 0x516461b1, 0xc9a62f8a,
               0x44c20ef3, 0x3390af7f, 0xd9fc690b, 0x2a5f714c,
               0x53372767, 0xb00a5631, 0x974c541a, 0x359e9963,
               0x5c971061, 0x3d631689, 0x2098d9d6, 0x91dbd320] 2 7 8 13 =
    [0x879531e0, 0xc5ecf37d, 0xbdb886dc, 0xc9a62f8a,
     0x44c20ef3, 0x3390af7f, 0xd9fc690b, 0xcfacafd2,
     0xe46bea80, 0xb00a5631, 0x974c541a, 0x359e9963,
     0x5c971061, 0xccc07c79, 0x2098d9d6, 0x91dbd320] := by
  decide +kernel

/-- The block function [RFC 8439, §2.3.2]. -/
theorem block_test :
    block [0x61707865, 0x3320646e, 0x79622d32, 0x6b206574,
           0x03020100, 0x07060504, 0x0b0a0908, 0x0f0e0d0c,
           0x13121110, 0x17161514, 0x1b1a1918, 0x1f1e1d1c,
           0x00000001, 0x09000000, 0x4a000000, 0x00000000] =
    [0xe4e7f110, 0x15593bd1, 0x1fdd0f50, 0xc47120a3,
     0xc7f4d1c7, 0x0368c033, 0x9aaa2204, 0x4e6cd4c3,
     0x466482d2, 0x09aa9f07, 0x05d7c214, 0xa2028bd9,
     0xd19c12b5, 0xb94e16de, 0xe883d0cb, 0x4e3c50a2] := by
  decide +kernel

end Examples.ChaCha20
