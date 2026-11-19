/-
  Examples.Sha256.O2.X86.Proofs

  `sha256.c` on x86-64, compiled a second time at `-O2`: a round, the message schedule and
  the compression function of SHA-256 proved again on the recompiled binary
  (`docs/Continuity.md`), against the same specification, `Examples.Spec.Sha256`, with
  `Examples.Sha256.Common` and `Examples.Sha256.X86.Machine` reused unchanged.

  ## Main results

  * `sha256_round_spec`, `sha256_round_correct`: one round, on working variables in memory
  * `sha256_schedule_spec`, `sha256_schedule_correct`: the message schedule
  * `sha256_compress_spec`, `sha256_compress_correct`: the compression function
-/

module

public import Examples.Sha256.O2.X86.Round
public import Examples.Sha256.O2.X86.Schedule
public import Examples.Sha256.O2.X86.Compress
