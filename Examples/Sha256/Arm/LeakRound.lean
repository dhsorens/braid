/-
  Examples.Sha256.Arm.LeakRound

  What `sha256_round` reveals on AArch64 (`docs/Leakage.md`): a traced triple, by one run of
  the stepper. The theorem about the machine is in `LeakMachine`.

  ## Main definitions

  * `roundLeak`: what `sha256_round` reveals, from its pointer and the return address

  ## Main results

  * `sha256_round_trace`: the code reveals `roundLeak`
-/

module

public import Examples.Sha256.Arm.Round
public import Examples.Sha256.Arm.LeakBase

public section

namespace Examples.Sha256.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- What `sha256_round` reveals, given the pointer `p` to the working variables and the
return address `r`: the eight working variables read, two at a time, then written, two at a
time, and the return. The function does not use the stack. -/
def roundLeak (p r : Word) : Trace :=
  [.read (p + 16#64) 4, .read (p + 20#64) 4, .read p 4, .read (p + 4#64) 4,
    .read (p + 24#64) 4, .read (p + 28#64) 4, .read (p + 8#64) 4, .read (p + 12#64) 4,
    .write (p + 24#64) 4, .write (p + 28#64) 4, .write (p + 8#64) 4, .write (p + 12#64) 4,
    .write (p + 16#64) 4, .write (p + 20#64) 4, .write p 4, .write (p + 4#64) 4,
    .jump r]

/-- Forget what `sha256_round` leaves in the registers it uses. -/
local macro "round_forget" : tactic =>
  `(tactic| (braid_forget 1; braid_forget 2; braid_forget 8; braid_forget 9
             braid_forget 10; braid_forget 11; braid_forget 12; braid_forget 13
             braid_forget 14; braid_forget 15; braid_forget 16; braid_forget 17
             braid_forget 18))

/-- **What `sha256_round` reveals.** From the precondition of `sha256_round_spec`, the code
runs to its return and reveals `roundLeak` of the pointer and the return address: the working
variables `v`, the round constant `kk` and the word of the schedule `ww` are not in the
trace. The postcondition keeps where the working variables are and forgets what they hold. -/
theorem sha256_round_trace (p kk ww r : Word) (v : Vars)
    (t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 : Word) (t : Trace) :
    TripleT sha256_round.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 p, .reg x1 kk, .reg x2 ww,
        .reg x8 t8, .reg x9 t9, .reg x10 t10, .reg x11 t11, .reg x12 t12, .reg x13 t13,
        .reg x14 t14, .reg x15 t15, .reg x16 t16, .reg x17 t17, .reg x18 t18,
        .reg lr r, .prop (cellsAt 4 true p (w32s v.toList))]) t
      (Atoms.interp [.pc r, .reg x0 p, .prop (regAny x1), .prop (regAny x2),
        .prop (regAny x8), .prop (regAny x9), .prop (regAny x10), .prop (regAny x11),
        .prop (regAny x12), .prop (regAny x13), .prop (regAny x14), .prop (regAny x15),
        .prop (regAny x16), .prop (regAny x17), .prop (regAny x18),
        .reg lr r, .prop (cellsAny 4 true p 8)])
      (t ++ roundLeak p r) := by
  obtain ⟨q, rfl⟩ : ∃ q : BitVec 64, p = q + 1#64 := ⟨p - 1#64, by bv_omega⟩
  simp only [roundLeak]
  braid_unfold cells_vars true (q + 1#64) v
  braid_sym_run
  braid_forget_mem (q + 1#64)
  braid_forget_mem (q + 5#64)
  braid_forget_mem (q + 9#64)
  braid_forget_mem (q + 13#64)
  braid_forget_mem (q + 17#64)
  braid_forget_mem (q + 21#64)
  braid_forget_mem (q + 25#64)
  braid_forget_mem (q + 29#64)
  sha256_fold cellsAny8 true (q + 1#64)
  round_forget
  sha256_done

end Examples.Sha256.Arm
