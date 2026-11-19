/-
  Examples.ChaCha20.O2.Arm.Proofs

  `chacha20.c` on AArch64, compiled a second time at `-O2`: the quarter round and the block
  function of ChaCha20 proved again on the recompiled binary (`docs/Continuity.md`), against
  the same specification, `Examples.Spec.ChaCha20`, with `Examples.ChaCha20.Common` reused
  unchanged.

  ## Main results

  * `quarter_round_spec`, `quarter_round_correct`: the quarter round on four words in memory
  * `rounds_spec`: the loop of ten double rounds, by induction
  * `chacha20_block_spec`, `chacha20_block_correct`: the block function
-/

module

public import Examples.ChaCha20.O2.Arm.QuarterRound
public import Examples.ChaCha20.O2.Arm.Block
