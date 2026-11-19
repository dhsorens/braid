/-
  Examples.Sha256.X86.Proofs

  `sha256.c` on x86-64: the top rung of the scaling ladder (`docs/Scaling.md`). One round,
  the message schedule, and the compression function of SHA-256, each proved against the
  specification of FIPS 180-4 in `Examples.Spec.Sha256`, as a triple and as a theorem about
  the machine alone.

  ## Main results

  * `sha256_round_spec`, `sha256_round_correct`: one round
  * `sha256_schedule_spec`, `sha256_schedule_correct`: the message schedule
  * `sha256_compress_spec`, `sha256_compress_correct`: the compression function
-/

module

public import Examples.Sha256.X86.Round
public import Examples.Sha256.X86.Schedule
public import Examples.Sha256.X86.Compress
