/-
  Examples.Spec.Crc32

  CRC-32, the cyclic redundancy check of IEEE 802.3, zlib and PNG: a plain Lean definition,
  one bit at a time, which the machine code of the examples is proved against. It is the
  textbook definition with the reflected polynomial `0xEDB88320`, written here and checked
  against the standard check value, the CRC-32 of the nine characters `123456789`.

  ## Main definitions

  * `Crc32.bit`: one bit of the division, shifting right
  * `Crc32.byte`: one byte of the message, taken into the register
  * `Crc32.update`: the bytes of a message, taken into the register
  * `Crc32.crc32`: the CRC-32 of a message, continuing from the CRC-32 of what came before

  ## Main results

  * `Crc32.crc32_check`: the CRC-32 of `123456789` is `0xCBF43926`
  * `Crc32.crc32_nil`, `Crc32.crc32_append`: the CRC-32 of a message taken in pieces

  ## References

  * [Williams] R. N. Williams, *A Painless Guide to CRC Error Detection Algorithms*, 1993.
  * [RFC 1952] P. Deutsch, *GZIP file format specification version 4.3*, 1996, §8.
-/

module

@[expose] public section

namespace Examples.Crc32

/-- The generator polynomial of CRC-32, with its bits reflected. -/
def poly : BitVec 32 := 0xEDB88320#32

/-- One bit of the division: shift the register right, and subtract the polynomial if the bit
shifted out was set. -/
def bit (c : BitVec 32) : BitVec 32 :=
  if c.getLsbD 0 then (c >>> 1) ^^^ poly else c >>> 1

/-- One byte of the message: add it to the low byte of the register, and divide by eight
bits. -/
def byte (c : BitVec 32) (b : BitVec 8) : BitVec 32 :=
  bit (bit (bit (bit (bit (bit (bit (bit (c ^^^ b.zeroExtend 32))))))))

/-- The bytes of a message, taken into the register one after another. -/
def update (c : BitVec 32) (bs : List (BitVec 8)) : BitVec 32 := bs.foldl byte c

/-- The CRC-32 of the bytes `bs`, continuing from `crc`, the CRC-32 of the bytes before them
(`0` if there are none). The register starts as the complement of `crc`, and the result is
the complement of the register. -/
def crc32 (crc : BitVec 32) (bs : List (BitVec 8)) : BitVec 32 := ~~~update (~~~crc) bs

/-- The check value of CRC-32: the CRC-32 of the nine characters `123456789`. -/
theorem crc32_check :
    crc32 0#32 [0x31#8, 0x32#8, 0x33#8, 0x34#8, 0x35#8, 0x36#8, 0x37#8, 0x38#8, 0x39#8] =
      0xCBF43926#32 := by
  decide +kernel

/-- The CRC-32 of no bytes, continuing from `crc`, is `crc`. -/
theorem crc32_nil (crc : BitVec 32) : crc32 crc [] = crc := by
  simp [crc32, update]

/-- The CRC-32 of a message in two pieces: that of the second, continuing from that of the
first. -/
theorem crc32_append (crc : BitVec 32) (xs ys : List (BitVec 8)) :
    crc32 crc (xs ++ ys) = crc32 (crc32 crc xs) ys := by
  simp [crc32, update]

end Examples.Crc32
