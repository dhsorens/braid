/-
  Braid.IR.Image

  A loaded program, as an object: the code of a binary, its data sections as the memory they
  are loaded into, and its entry point. The decompiler writes one from a binary, so that the
  address and the contents of a table are facts about the binary and not hypotheses of a
  theorem. What it means for a machine to have an image loaded is said for each instruction
  set, since each machine model holds code in its own way.

  ## Main definitions

  * `Image`: the code, data sections, zeroed sections and entry point of a binary
-/

module

public import Braid.IR.Syntax

@[expose] public section

namespace Braid

/-- A binary as it is loaded. `ι` is the type of what the code is made of: instructions for
a model that holds decoded code, words for one that fetches from memory. -/
structure Image (ι : Type) where
  /-- Where the program starts. -/
  entry : Word
  /-- The code, by address. -/
  code : List (Word × ι)
  /-- The sections with contents: an address and the bytes loaded from it on. -/
  data : List (Word × List (BitVec 8))
  /-- The sections without contents (`.bss`): an address and a number of bytes, loaded as
  zero. -/
  zero : List (Word × Nat)

end Braid
