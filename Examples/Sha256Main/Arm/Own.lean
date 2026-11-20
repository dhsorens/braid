/-
  Examples.Sha256Main.Arm.Own

  The code of the whole program on AArch64 that is its own: `_start` and `main`, without the
  compression function they call. What is proved of `main`'s loops that do not call it is
  stated about this program, so that it holds of every binary with this `_start` and this
  `main` at these addresses, whichever compression function is linked beside them. This
  file and what is stated about `ownProgram` alone import nothing about a compression
  function but the image it is in.

  ## Main definitions

  * `ownBlocks`: the lowered blocks of `_start` and `main`
  * `ownProgram`: the lowered code of `_start` and `main`
-/

module

public import Examples.Sha256Main.Arm.Image

@[expose] public section

namespace Examples.Sha256Main.Arm

open Braid

/-- The lowered blocks of `_start` and `main`. -/
def ownBlocks : List (Word × Block) := _start.blocks ++ main.blocks

/-- The lowered code of `_start` and `main`: the binary without the function it calls. -/
def ownProgram : Program := Program.ofList ownBlocks

end Examples.Sha256Main.Arm
