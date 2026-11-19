/-
  Examples.Sha256.RiscV.LeakRound

  What `sha256_round` reveals on RISC-V (`docs/Leakage.md`): a traced triple, by one run of
  the stepper. The theorem about the machine is in `LeakMachine`.

  ## Main definitions

  * `roundLeak`: what `sha256_round` reveals, from its pointer, the stack pointer and the
    return address

  ## Main results

  * `sha256_round_trace`: the code reveals `roundLeak`
-/

module

public import Examples.Sha256.RiscV.Round
public import Examples.Sha256.RiscV.LeakBase

public section

namespace Examples.Sha256.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- What `sha256_round` reveals, given the pointer `p` to the working variables, the stack
pointer `s` and the return address `r`: `s0` saved below the stack pointer, the eight
working variables read and then written, `s0` restored, and the return. -/
def roundLeak (p s r : Word) : Trace :=
  [.write (s - 8#64) 8,
    .read p 4, .read (p + 4#64) 4, .read (p + 8#64) 4, .read (p + 12#64) 4,
    .read (p + 16#64) 4, .read (p + 20#64) 4, .read (p + 24#64) 4, .read (p + 28#64) 4,
    .write (p + 16#64) 4, .write (p + 20#64) 4, .write (p + 24#64) 4, .write (p + 28#64) 4,
    .write p 4, .write (p + 4#64) 4, .write (p + 8#64) 4, .write (p + 12#64) 4,
    .read (s - 8#64) 8, .jump (r &&& ~~~1#64)]

/-- Forget what `sha256_round` leaves in the registers it uses. -/
local macro "round_forget" : tactic =>
  `(tactic| (braid_forget 11; braid_forget 12; braid_forget 13; braid_forget 14
             braid_forget 15; braid_forget 16; braid_forget 17; braid_forget 5
             braid_forget 6; braid_forget 7; braid_forget 28; braid_forget 29
             braid_forget 30; braid_forget 31))

/-- **What `sha256_round` reveals.** From the precondition of `sha256_round_spec`, the code
runs to its return and reveals `roundLeak` of the pointer, the stack pointer and the return
address: the working variables `v`, the round constant `kk` and the word of the schedule
`ww` are not in the trace. The postcondition keeps where the working variables are and
forgets what they hold. -/
theorem sha256_round_trace (p kk ww s r v8 m0 : Word) (v : Vars)
    (x5 x6 x7 x13 x14 x15 x16 x17 x28 x29 x30 x31 : Word)
    (hp : p &&& 3#64 = 0#64) (hs : s &&& 7#64 = 0#64) (t : Trace) :
    TripleT sha256_round.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 p, .reg a1 kk, .reg a2 ww, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .reg t3 x28, .reg t4 x29, .reg t5 x30, .reg t6 x31, .reg s0 v8,
        .reg sp s, .reg ra r,
        .prop (cellsAt 4 true p (w32s v.toList)), .prop (cellsAt 8 true (s - 8#64) [m0])]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 p, .prop (regAny a1), .prop (regAny a2),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .prop (regAny t2),
        .prop (regAny t3), .prop (regAny t4), .prop (regAny t5), .prop (regAny t6),
        .reg s0 v8, .reg sp s, .reg ra r,
        .prop (cellsAny 4 true p 8), .prop (cellsAt 8 true (s - 8#64) [v8])])
      (t ++ roundLeak p s r) := by
  obtain ⟨q, rfl⟩ : ∃ q : BitVec 64, p = q + 1#64 := ⟨p - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 9#64 := ⟨s - 9#64, by bv_omega⟩
  simp only [roundLeak]
  braid_unfold cells_vars true (q + 1#64) v
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 1#64) m0 []
  braid_sym_run
  sha256_forget_mem (q + 1#64)
  sha256_forget_mem (q + 5#64)
  sha256_forget_mem (q + 9#64)
  sha256_forget_mem (q + 13#64)
  sha256_forget_mem (q + 17#64)
  sha256_forget_mem (q + 21#64)
  sha256_forget_mem (q + 25#64)
  sha256_forget_mem (q + 29#64)
  sha256_fold cellsAny8 true (q + 1#64)
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 1#64) v8 []
  round_forget
  sha256_done

end Examples.Sha256.RiscV
