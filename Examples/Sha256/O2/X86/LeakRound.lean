/-
  Examples.Sha256.O2.X86.LeakRound

  What `sha256_round` reveals on x86-64, compiled at `-O2` (`docs/Leakage.md`): a traced
  triple, by one run of the stepper. The theorem about the machine is in `LeakMachine`.

  This is the proof of `Examples.Sha256.X86.LeakRound` again, on the binary compiled at
  `-O2`, where the compiler emits for `sha256_round` the instructions it emits at `-O1`, at
  the same addresses: what it reveals is the same function of the same inputs, and the
  statement and the proof are the same text, about the code of this binary. `LeakBase` of
  `Examples.Sha256.X86`, which says nothing of the code, is imported as it is.

  ## Main definitions

  * `roundLeak`: what `sha256_round` reveals, from its pointer, the stack pointer and the
    return address

  ## Main results

  * `sha256_round_trace`: the code reveals `roundLeak`
-/

module

public import Examples.Sha256.O2.X86.Round
public import Examples.Sha256.X86.LeakBase

public section

namespace Examples.Sha256.O2.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs
open Examples.Sha256.X86

/-- What `sha256_round` reveals, given the pointer `p` to the working variables, the stack
pointer `s` and the return address `r`: `rbp` and `rbx` pushed below the stack pointer, the
eight working variables read and written, in the order of the code, the two registers
popped, the return address read from the stack, and the return. -/
def roundLeak (p s r : Word) : Trace :=
  [.write (s - 8#64) 8, .write (s - 16#64) 8,
    .read p 4, .read (p + 4#64) 4, .read (p + 8#64) 4, .read (p + 16#64) 4,
    .read (p + 20#64) 4, .read (p + 24#64) 4, .read (p + 28#64) 4,
    .write (p + 28#64) 4, .write (p + 24#64) 4, .write (p + 20#64) 4,
    .read (p + 12#64) 4,
    .write (p + 16#64) 4, .write (p + 12#64) 4, .write (p + 8#64) 4, .write (p + 4#64) 4,
    .write p 4,
    .read (s - 16#64) 8, .read (s - 8#64) 8, .read s 8, .jump r]

/-- Forget what `sha256_round` leaves in the registers it uses and in the flags. -/
local macro "round_forget" : tactic =>
  `(tactic| (braid_forget 4; braid_forget 3; braid_forget 0; braid_forget 2
             braid_forget 8; braid_forget 9; braid_forget 10; braid_forget 11
             x86_forget_all_flags))

/-- **What `sha256_round` reveals.** From the precondition of `sha256_round_spec`, the code
runs to its return and reveals `roundLeak` of the pointer, the stack pointer and the return
address: the working variables `v`, the round constant `kk`, the word of the schedule `ww`
and the two words `sv` below the stack pointer are not in the trace. The postcondition keeps
where the working variables are and forgets what they hold. -/
theorem sha256_round_trace (p kk ww s r vb vp : Word) (v : Vars) (sv : List Word)
    (t0 t2 t8 t9 t10 t11 : Word) (c pf af z sg o : Bool) (hsv : sv.length = 2) (t : Trace) :
    TripleT sha256_round.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi p, .reg rsi kk, .reg rdx ww, .reg rax t0,
        .reg rcx t2, .reg r8 t8, .reg r9 t9, .reg r10 t10, .reg r11 t11, .reg rbx vb,
        .reg rbp vp, .reg rsp s,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true p (w32s v.toList)), .prop (cellsAt 8 true (s - 16#64) sv),
        .prop (cellsAt 8 true s [r])]) t
      (Atoms.interp [.pc r, .reg rdi p, .prop (regAny rsi), .prop (regAny rdx),
        .prop (regAny rax), .prop (regAny rcx), .prop (regAny r8), .prop (regAny r9),
        .prop (regAny r10), .prop (regAny r11), .reg rbx vb, .reg rbp vp, .reg rsp (s + 8#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true p 8),
        .prop (cellsAt 8 true (s - 16#64) [vb, vp]), .prop (cellsAt 8 true s [r])])
      (t ++ roundLeak p s r) := by
  obtain ⟨m1, m0, rfl⟩ : ∃ m1 m0, sv = [m1, m0] := by
    match sv, hsv with
    | [m1, m0], _ => exact ⟨m1, m0, rfl⟩
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨q, rfl⟩ : ∃ q : BitVec 64, p = q + 1#64 := ⟨p - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 17#64 := ⟨s - 17#64, by bv_omega⟩
  simp only [roundLeak]
  braid_unfold cells_vars true (q + 1#64) v
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 1#64) m1 [m0]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 9#64) m0 []
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 17#64) r []
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
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 9#64) vp []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 1#64) vb [vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 17#64) r []
  round_forget
  sha256_leak_done

end Examples.Sha256.O2.X86
