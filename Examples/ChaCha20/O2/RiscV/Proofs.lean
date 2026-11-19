/-
  Examples.ChaCha20.O2.RiscV.Proofs

  `chacha20.c` on RISC-V, compiled a second time at `-O2`: the quarter round and the block
  function of ChaCha20 proved again on the recompiled binary (`docs/Continuity.md`), against
  the same specification, `Examples.Spec.ChaCha20`, with `Examples.ChaCha20.Common` and the
  mathematics of the first proof reused unchanged.

  ## Main results

  * `quarter_round_spec`, `quarter_round_correct`: the quarter round on four words in memory
  * `rounds_spec`: the loop of ten double rounds, by induction
  * `chacha20_block_spec`, `chacha20_block_correct`: the block function
-/

module

public import Examples.ChaCha20.O2.RiscV.QuarterRound
public import Examples.ChaCha20.O2.RiscV.Block
