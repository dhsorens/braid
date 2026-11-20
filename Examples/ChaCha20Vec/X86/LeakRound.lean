/-
  Examples.ChaCha20Vec.X86.LeakRound

  What the loop of rounds of `chacha20_block_vec` reveals on x86-64 (`docs/Leakage.md`):
  where the branch at its end goes, once a round, and nothing else. A round is 31
  instructions on registers alone, additions of lanes, exclusive ors, rotations and shuffles
  of lanes, which have no label, and the decrement of a count; the branch tests the zero
  flag that the decrement sets, and the code set the count to ten, so it does not depend on
  the state.

  The traces are not written here: each definition is a trace together with the traced
  triple that leaves it, and the run finds the trace (`Braid.Logic.Traced`). What a trace
  may depend on is what its definition binds before the pair, which for the loop is the
  number of rounds left and nothing of the state. The traced triples say nothing of what
  the rounds compute, which is `rounds_spec` of `Examples.ChaCha20Vec.X86.Round`: the rows
  hold any words before and `regAny` after, so the code is run on opaque words and the
  arithmetic is forgotten.

  ## Main definitions

  * `columns_run`, `diagonals_run`: the two halves of a round, and their traces
  * `double_round_run`: a round of the loop, up to its branch, and its trace, which is empty
  * `rounds_run`: the loop with `n + 1` rounds left, and its trace
  * `roundsVecLeak`: what the loop reveals, the trace of `rounds_run`

  ## Main results

  * `double_round_run_eq`, `roundsVecLeak_zero`, `roundsVecLeak_succ`: the traces, written
    out
-/

module

public import Braid.Logic.Traced
public import Examples.ChaCha20Vec.X86.Block

@[expose] public section

namespace Examples.ChaCha20Vec.X86

open Braid Examples Examples.ChaCha20 Lowering.X86 Lowering.X86.Regs

/-- Name what the rows hold: the first two words of `zmm0` to `zmm3`. -/
macro "x86_name_rows" : tactic =>
  `(tactic| (braid_name_reg (zmm 0 0); braid_name_reg (zmm 0 1); braid_name_reg (zmm 1 0)
             braid_name_reg (zmm 1 1); braid_name_reg (zmm 2 0); braid_name_reg (zmm 2 1)
             braid_name_reg (zmm 3 0); braid_name_reg (zmm 3 1)))

/-- **The first half of a round of the loop, and what it reveals**: the column round and the
shuffles of lanes after it, whatever the rows hold. -/
def columns_run : { ls : Trace // ∀ (a a' b b' c c' d d' : Word) (t : Trace),
    TripleT chacha20_block_vec.program
      (Atoms.interp [.pc 0x401020#64,
        .reg (zmm 0 0) a, .reg (zmm 0 1) a', .reg (zmm 1 0) b, .reg (zmm 1 1) b',
        .reg (zmm 2 0) c, .reg (zmm 2 1) c', .reg (zmm 3 0) d, .reg (zmm 3 1) d',
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64]) t
      (Atoms.interp [.pc 0x401077#64,
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)), .prop (regAny (zmm 1 0)),
        .prop (regAny (zmm 1 1)), .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .prop (regAny (zmm 3 0)), .prop (regAny (zmm 3 1)),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64]) (t ++ ls) } := by
  braid_traced
  intro a a' b b' c c' d d' t
  iterate 15 braid_sym_step
  x86_forget_rows
  braid_done

/-- **The second half of a round of the loop, and what it reveals**: the column round on the
rotated rows, the shuffles back and the decrement of the count of rounds, in `eax`, whatever
the rows hold. The zero flag is set if no round is left. -/
def diagonals_run : { ls : Trace // ∀ (a a' b b' c c' d d' : Word) (k : W32)
    (fp fa fz fs fo : Bool) (t : Trace),
    TripleT chacha20_block_vec.program
      (Atoms.interp [.pc 0x401077#64,
        .reg (zmm 0 0) a, .reg (zmm 0 1) a', .reg (zmm 1 0) b, .reg (zmm 1 1) b',
        .reg (zmm 2 0) c, .reg (zmm 2 1) c', .reg (zmm 3 0) d, .reg (zmm 3 1) d',
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .reg rax (k.zeroExtend 64),
        .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz, .flag Flags.sf fs,
        .flag Flags.of fo]) t
      (Atoms.interp [.pc 0x4010d0#64,
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)), .prop (regAny (zmm 1 0)),
        .prop (regAny (zmm 1 1)), .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .prop (regAny (zmm 3 0)), .prop (regAny (zmm 3 1)),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .reg rax ((k - 1).zeroExtend 64),
        .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .flag Flags.zf ((k - 1).zeroExtend 64 == 0#64), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) (t ++ ls) } := by
  braid_traced
  intro a a' b b' c c' d d' k fp fa fz fs fo t
  iterate 16 braid_sym_step
  x86_forget_rows
  braid_forget_flag 1
  braid_forget_flag 4
  braid_forget_flag 5
  simp only [zdec]
  braid_done

/-- **A round of the loop, and what it reveals**, from the head of the loop to the branch at
its end, whatever the rows hold. Nothing is bound before the pair, so the trace is the same
list for every state. -/
def double_round_run : { ls : Trace // ∀ (a a' b b' c c' d d' : Word) (k : W32)
    (fp fa fz fs fo : Bool) (t : Trace),
    TripleT chacha20_block_vec.program
      (Atoms.interp [.pc 0x401020#64,
        .reg (zmm 0 0) a, .reg (zmm 0 1) a', .reg (zmm 1 0) b, .reg (zmm 1 1) b',
        .reg (zmm 2 0) c, .reg (zmm 2 1) c', .reg (zmm 3 0) d, .reg (zmm 3 1) d',
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .reg rax (k.zeroExtend 64),
        .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz, .flag Flags.sf fs,
        .flag Flags.of fo]) t
      (Atoms.interp [.pc 0x4010d0#64,
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)), .prop (regAny (zmm 1 0)),
        .prop (regAny (zmm 1 1)), .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .prop (regAny (zmm 3 0)), .prop (regAny (zmm 3 1)),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .reg rax ((k - 1).zeroExtend 64),
        .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .flag Flags.zf ((k - 1).zeroExtend 64 == 0#64), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) (t ++ ls) } := by
  braid_traced
  intro a a' b b' c c' d d' k fp fa fz fs fo t
  braid_call columns_run.2 a a' b b' c c' d d' t
  x86_name_rows
  braid_call diagonals_run.2 _ _ _ _ _ _ _ _ k fp fa fz fs fo _
  braid_done

/-- A round of the loop, up to its branch, reveals nothing. -/
theorem double_round_run_eq : double_round_run.1 = [] := rfl

/-- **The loop of `chacha20_block_vec`, and what it reveals**, with `n + 1` rounds left,
whatever the rows hold. By recursion on `n`: a round is `double_round_run`, the branch at
its end adds a label, and the rounds that remain are this definition again. Only `n` is
bound before the pair, so the trace depends on nothing else. -/
def rounds_run : (n : Nat) → { ls : Trace // ∀ (a a' b b' c c' d d' : Word) (k : W32)
    (fp fa fz fs fo : Bool) (t : Trace),
    k = BitVec.ofNat 32 (n + 1) → n + 1 < 2 ^ 32 →
    TripleT chacha20_block_vec.program
      (Atoms.interp [.pc 0x401020#64,
        .reg (zmm 0 0) a, .reg (zmm 0 1) a', .reg (zmm 1 0) b, .reg (zmm 1 1) b',
        .reg (zmm 2 0) c, .reg (zmm 2 1) c', .reg (zmm 3 0) d, .reg (zmm 3 1) d',
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .reg rax (k.zeroExtend 64),
        .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz, .flag Flags.sf fs,
        .flag Flags.of fo]) t
      (Atoms.interp [.pc 0x4010d6#64,
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)), .prop (regAny (zmm 1 0)),
        .prop (regAny (zmm 1 1)), .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .prop (regAny (zmm 3 0)), .prop (regAny (zmm 3 1)),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .reg rax 0#64,
        .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) (t ++ ls) }
  | 0 => by
    braid_traced
    intro a a' b b' c c' d d' k fp fa fz fs fo t hk _
    obtain rfl : k = 1#32 := hk
    braid_call double_round_run.2 a a' b b' c c' d d' 1#32 fp fa fz fs fo t
    braid_sym_step
    braid_forget_flag 3
    braid_done
  | n + 1 => by
    braid_traced
    intro a a' b b' c c' d d' k fp fa fz fs fo t hk hn
    braid_call double_round_run.2 a a' b b' c c' d d' k fp fa fz fs fo t
    braid_sym_step
    · x86_name_rows
      braid_name_flag 1
      braid_name_flag 2
      braid_name_flag 4
      braid_name_flag 5
      braid_call (rounds_run n).2 _ _ _ _ _ _ _ _ (k - 1) _ _ _ _ _ _
        (by rw [hk]; bv_omega) (by omega)
      braid_done
    · exfalso
      have : k - 1 ≠ 0#32 := by rw [hk]; bv_omega
      exact this (by bv_decide)

/-- What the loop of rounds reveals with `n` rounds left after the one it is in: the trace
that `rounds_run` finds. It is the branch back to the head of the loop after each round but
the last, and the way out after the last. -/
def roundsVecLeak (n : Nat) : Trace := (rounds_run n).1

/-- After the last round, the branch goes on. -/
theorem roundsVecLeak_zero : roundsVecLeak 0 = [.jump 0x4010d6#64] := rfl

/-- After a round that is not the last, the branch goes back to the head of the loop. -/
theorem roundsVecLeak_succ (n : Nat) :
    roundsVecLeak (n + 1) = .jump 0x401020#64 :: roundsVecLeak n := rfl

end Examples.ChaCha20Vec.X86
