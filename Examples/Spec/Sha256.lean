/-
  Examples.Spec.Sha256

  SHA-256, as FIPS 180-4 defines it: a plain Lean definition, which the machine code of the
  examples is proved against.

  Ported from hash-specs (https://github.com/Verified-zkEVM/hash-specs, `Hash/SHA2/Reference.lean`
  with `Hash/SHA2/Constants.lean`, `Hash/Prelude/Bits.lean` and
  `Hash/Construction/MerkleDamgard.lean`, at revision 2ccc6d3; Copyright (c) 2026 Derek
  Sorensen, released under the Apache 2.0 licence). hash-specs states the SHA-2 family once,
  over a record of parameters, and depends on Mathlib; this is its reference specification with
  the parameters of SHA-256 put in, and nothing else changed. The test vectors at the end are
  those of the standard.

  ## Main definitions

  * `Sha256.schedule`: the message schedule of a block
  * `Sha256.round`, `Sha256.rounds`: one round, and the first `n` rounds
  * `Sha256.compress`: the compression function
  * `Sha256.hash`: the hash of a bit string

  ## References

  * [FIPS 180-4] NIST, *Secure Hash Standard (SHS)*, FIPS PUB 180-4, 2015.
-/

module

@[expose] public section

namespace Examples.Sha256

/-- A word of SHA-256. -/
abbrev W32 := BitVec 32

/-! ## Bit strings -/

/-- The `w`-bit big-endian representation of `n`: the most significant bit comes first. -/
def natToBitsBE (w n : Nat) : List Bool :=
  (List.range w).reverse.map fun i => n.testBit i

/-- The natural number denoted by a big-endian bit string. -/
def bitsToNatBE (bs : List Bool) : Nat :=
  bs.foldl (fun acc b => 2 * acc + b.toNat) 0

/-- Split a list into consecutive pieces of length `n`; the last piece may be shorter. -/
def chunks {α : Type} (n : Nat) (l : List α) : List (List α) :=
  go l.length l
where
  /-- `chunks` with an explicit fuel argument. -/
  go : Nat → List α → List (List α)
    | 0, _ => []
    | _ + 1, [] => []
    | k + 1, l@(_ :: _) => l.take n :: go k (l.drop n)

/-! ## Constants [FIPS 180-4, §4.2.2, §5.3.3] -/

/-- The round constants `K₀ … K₆₃`. -/
def K : List W32 := [
  0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
  0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
  0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
  0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
  0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
  0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
  0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
  0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2]

/-- The initial hash value `H⁽⁰⁾`. -/
def H0 : List W32 := [
  0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19]

/-! ## Functions [FIPS 180-4, §3.2, §4.1.2] -/

/-- `ROTRⁿ(x)`, the circular right shift. -/
def ROTR (n : Nat) (x : W32) : W32 := x.rotateRight n

/-- `SHRⁿ(x)`, the right shift. -/
def SHR (n : Nat) (x : W32) : W32 := x >>> n

/-- `Ch(x, y, z) = (x ∧ y) ⊕ (¬x ∧ z)`. -/
def Ch (x y z : W32) : W32 := (x &&& y) ^^^ (~~~x &&& z)

/-- `Maj(x, y, z) = (x ∧ y) ⊕ (x ∧ z) ⊕ (y ∧ z)`. -/
def Maj (x y z : W32) : W32 := (x &&& y) ^^^ (x &&& z) ^^^ (y &&& z)

/-- `Σ₀`. -/
def bigSigma0 (x : W32) : W32 := ROTR 2 x ^^^ ROTR 13 x ^^^ ROTR 22 x

/-- `Σ₁`. -/
def bigSigma1 (x : W32) : W32 := ROTR 6 x ^^^ ROTR 11 x ^^^ ROTR 25 x

/-- `σ₀`. -/
def smallSigma0 (x : W32) : W32 := ROTR 7 x ^^^ ROTR 18 x ^^^ SHR 3 x

/-- `σ₁`. -/
def smallSigma1 (x : W32) : W32 := ROTR 17 x ^^^ ROTR 19 x ^^^ SHR 10 x

/-! ## Preprocessing [FIPS 180-4, §5] -/

/-- The number of zero bits added by padding a message of `ℓ` bits. -/
def padZeros (ℓ : Nat) : Nat := (512 - (ℓ + 1 + 64) % 512) % 512

/-- Padding: the bit `1`, then zero bits, then the length of the message as a 64-bit
big-endian number. -/
def pad (M : List Bool) : List Bool :=
  M ++ [true] ++ List.replicate (padZeros M.length) false ++ natToBitsBE 64 M.length

/-- Parsing: the padded message as blocks of sixteen words. -/
def parse (M : List Bool) : List (List W32) :=
  (chunks 512 M).map fun block =>
    (chunks 32 block).map fun word => BitVec.ofNat 32 (bitsToNatBE word)

/-! ## Hash computation [FIPS 180-4, §6.2.2] -/

/-- Step 1: the message schedule `W₀ … W₆₃` of one block, where `Wₜ = Mₜ` for `t < 16` and
`Wₜ = σ₁(W_{t−2}) + W_{t−7} + σ₀(W_{t−15}) + W_{t−16}` otherwise. -/
def schedule (M : List W32) : List W32 :=
  (List.range 64).foldl (init := []) fun W t =>
    W ++ [if t < 16 then M.getD t 0
          else smallSigma1 (W.getD (t - 2) 0) + W.getD (t - 7) 0 +
            smallSigma0 (W.getD (t - 15) 0) + W.getD (t - 16) 0]

/-- The eight working variables `a, b, …, h`. -/
structure Vars where
  a : W32
  b : W32
  c : W32
  d : W32
  e : W32
  f : W32
  g : W32
  h : W32
  deriving DecidableEq, Repr

/-- Step 3: round `t` of the compression function. -/
def round (W : List W32) (v : Vars) (t : Nat) : Vars :=
  let T₁ := v.h + bigSigma1 v.e + Ch v.e v.f v.g + K.getD t 0 + W.getD t 0
  let T₂ := bigSigma0 v.a + Maj v.a v.b v.c
  { h := v.g, g := v.f, f := v.e, e := v.d + T₁, d := v.c, c := v.b, b := v.a, a := T₁ + T₂ }

/-- The first `n` rounds. -/
def rounds (W : List W32) (v : Vars) (n : Nat) : Vars := (List.range n).foldl (round W) v

/-- Steps 1 to 4: process one message block `M`, updating the hash value `H`. -/
def compress (H : List W32) (M : List W32) : List W32 :=
  let W := schedule M
  let v₀ : Vars := ⟨H.getD 0 0, H.getD 1 0, H.getD 2 0, H.getD 3 0,
    H.getD 4 0, H.getD 5 0, H.getD 6 0, H.getD 7 0⟩
  let v := rounds W v₀ 64
  [v.a + H.getD 0 0, v.b + H.getD 1 0, v.c + H.getD 2 0, v.d + H.getD 3 0,
    v.e + H.getD 4 0, v.f + H.getD 5 0, v.g + H.getD 6 0, v.h + H.getD 7 0]

/-- The hash value after the blocks of a padded message. -/
def hashWords (M : List Bool) : List W32 := (parse (pad M)).foldl compress H0

/-- The hash function: pad and parse the message, compress each block in turn starting from
`H⁽⁰⁾`, and write out the final hash value. -/
def hash (M : List Bool) : List Bool :=
  (hashWords M).flatMap fun h => natToBitsBE 32 h.toNat

/-! ## Test vectors

The examples of the standard (NIST, *SHA-256 example computations*, and FIPS 180-2,
Appendix B), checked by the kernel. -/

/-- The bits of an ASCII string, each byte most significant bit first. -/
def ascii (s : String) : List Bool := s.toUTF8.toList.flatMap fun b => natToBitsBE 8 b.toNat

/-- The one-block message `"abc"`. -/
theorem hash_abc : hashWords (ascii "abc") =
    [0xba7816bf, 0x8f01cfea, 0x414140de, 0x5dae2223,
     0xb00361a3, 0x96177a9c, 0xb410ff61, 0xf20015ad] := by
  decide +kernel

/-- The two-block message of 448 bits. -/
theorem hash_448 :
    hashWords (ascii "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq") =
    [0x248d6a61, 0xd20638b8, 0xe5c02693, 0x0c3e6039,
     0xa33ce459, 0x64ff2167, 0xf6ecedd4, 0x19db06c1] := by
  decide +kernel

/-- The empty message. -/
theorem hash_empty : hashWords [] =
    [0xe3b0c442, 0x98fc1c14, 0x9afbf4c8, 0x996fb924,
     0x27ae41e4, 0x649b934c, 0xa495991b, 0x7852b855] := by
  decide +kernel

end Examples.Sha256
