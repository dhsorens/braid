/-
  Examples.ChaCha20.X86.Proofs

  `chacha20.c` on x86-64: the quarter round and the block function of ChaCha20, the fourth
  rung of the scaling ladder (`docs/Scaling.md`), each proved against the plain Lean
  specification of `Examples.Spec.ChaCha20` and carried down to the machine model.

  ## Main results

  * `quarter_round_spec`, `quarter_round_correct`: the quarter round on four words in memory
  * `rounds_spec`: the loop of ten double rounds, by induction
  * `chacha20_block_spec`, `chacha20_block_correct`: the block function
-/

module

public import Examples.ChaCha20.X86.QuarterRound
public import Examples.ChaCha20.X86.Block
