/-
  Examples.ChaCha20Vec.Arm.LeakRound

  What the loop of rounds of `chacha20_block_vec` reveals on AArch64 (`docs/Leakage.md`):
  where the branch at its end goes, once a round, and nothing else. A round is 37
  instructions on vector registers alone, additions of lanes, exclusive ors, shifts and
  moves of lanes, which have no label, and the decrement of a count; the branch tests a
  flag that the decrement sets, and the code set the count to ten, so it does not depend
  on the state.

  The traces are not written here: each definition is a trace together with the traced
  triple that leaves it, and the run finds the trace (`Braid.Logic.Traced`). What a trace
  may depend on is what its definition binds before the pair, which for the loop is the
  number of rounds left and nothing of the state. The traced triples say nothing of what
  the rounds compute, which is `rounds_spec` of `Examples.ChaCha20Vec.Arm.Round`: the
  vector registers hold any words before and `regAny` after, so the code is run on opaque
  words and the arithmetic is forgotten.

  ## Main definitions

  * `double_round_run`: a round of the loop, up to its branch, and its trace, which is empty
  * `rounds_run`: the loop with `n + 1` rounds left, and its trace
  * `roundsVecLeak`: what the loop reveals, the trace of `rounds_run`

  ## Main results

  * `double_round_run_eq`, `roundsVecLeak_zero`, `roundsVecLeak_succ`: the traces, written
    out
-/

module

public import Braid.Logic.Traced
public import Examples.ChaCha20Vec.Arm.Round

@[expose] public section

namespace Examples.ChaCha20Vec.Arm

open Braid Examples Examples.ChaCha20 Lowering.Arm Lowering.Arm.Regs

/-- Forget what the vector registers `v1` to `v5` hold: the rows of the state and the
register a round uses beside them in each of its halves. -/
macro "arm_forget_rows" : tactic =>
  `(tactic| (braid_forget (vlo 4); braid_forget (vhi 4); braid_forget (vlo 2)
             braid_forget (vhi 2); braid_forget (vlo 1); braid_forget (vhi 1)
             braid_forget (vlo 3); braid_forget (vhi 3); braid_forget (vlo 5)
             braid_forget (vhi 5)))

/-- Name what the vector registers `v1` to `v5` hold. -/
macro "arm_name_rows" : tactic =>
  `(tactic| (braid_name_reg (vlo 4); braid_name_reg (vhi 4); braid_name_reg (vlo 2)
             braid_name_reg (vhi 2); braid_name_reg (vlo 1); braid_name_reg (vhi 1)
             braid_name_reg (vlo 3); braid_name_reg (vhi 3); braid_name_reg (vlo 5)
             braid_name_reg (vhi 5)))

/-- **The first half of a round of the loop, and what it reveals**: the column round and the
rotations of lanes after it, whatever the vector registers hold. The count of rounds, in
`w8`, is one less after, and the zero flag is set if none is left. -/
def columns_run : { ls : Trace // ∀ (a a' b b' c c' d d' e e' : Word) (k : W32)
    (fn fz fc fv : Bool) (t : Trace),
    TripleT chacha20_block_vec.program
      (Atoms.interp [.pc 0x10010#64,
        .reg (vlo 4) a, .reg (vhi 4) a', .reg (vlo 2) b, .reg (vhi 2) b',
        .reg (vlo 1) c, .reg (vhi 1) c', .reg (vlo 3) d, .reg (vhi 3) d',
        .reg (vlo 5) e, .reg (vhi 5) e', .reg x8 (k.zeroExtend 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]) t
      (Atoms.interp [.pc 0x1005c#64,
        .prop (regAny (vlo 4)), .prop (regAny (vhi 4)), .prop (regAny (vlo 2)),
        .prop (regAny (vhi 2)), .prop (regAny (vlo 1)), .prop (regAny (vhi 1)),
        .prop (regAny (vlo 3)), .prop (regAny (vhi 3)), .prop (regAny (vlo 5)),
        .prop (regAny (vhi 5)), .reg x8 ((k - 1).zeroExtend 64),
        .prop (flagAny Flags.n), .flag Flags.z (k.zeroExtend 64 == 1#64),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) (t ++ ls) } := by
  braid_traced
  intro a a' b b' c c' d d' e e' k fn fz fc fv t
  iterate 19 braid_sym_step
  arm_forget_rows
  braid_forget_flag 0
  braid_forget_flag 2
  braid_forget_flag 3
  simp only [zdec]
  braid_done

/-- **The second half of a round of the loop, and what it reveals**: the column round on the
rotated rows and the rotations back, whatever the vector registers hold. -/
def diagonals_run : { ls : Trace // ∀ (a a' b b' c c' d d' e e' f f' : Word) (t : Trace),
    TripleT chacha20_block_vec.program
      (Atoms.interp [.pc 0x1005c#64,
        .reg (vlo 4) a, .reg (vhi 4) a', .reg (vlo 2) b, .reg (vhi 2) b',
        .reg (vlo 1) c, .reg (vhi 1) c', .reg (vlo 3) d, .reg (vhi 3) d',
        .reg (vlo 5) e, .reg (vhi 5) e', .reg (vlo 6) f, .reg (vhi 6) f']) t
      (Atoms.interp [.pc 0x100a4#64,
        .prop (regAny (vlo 4)), .prop (regAny (vhi 4)), .prop (regAny (vlo 2)),
        .prop (regAny (vhi 2)), .prop (regAny (vlo 1)), .prop (regAny (vhi 1)),
        .prop (regAny (vlo 3)), .prop (regAny (vhi 3)), .prop (regAny (vlo 5)),
        .prop (regAny (vhi 5)), .prop (regAny (vlo 6)), .prop (regAny (vhi 6))])
      (t ++ ls) } := by
  braid_traced
  intro a a' b b' c c' d d' e e' f f' t
  iterate 18 braid_sym_step
  arm_forget_rows
  braid_forget (vlo 6)
  braid_forget (vhi 6)
  braid_done

/-- **A round of the loop, and what it reveals**, from the head of the loop to the branch at
its end, whatever the vector registers hold. Nothing is bound before the pair, so the
trace is the same list for every state. -/
def double_round_run : { ls : Trace // ∀ (a a' b b' c c' d d' e e' f f' : Word) (k : W32)
    (fn fz fc fv : Bool) (t : Trace),
    TripleT chacha20_block_vec.program
      (Atoms.interp [.pc 0x10010#64,
        .reg (vlo 4) a, .reg (vhi 4) a', .reg (vlo 2) b, .reg (vhi 2) b',
        .reg (vlo 1) c, .reg (vhi 1) c', .reg (vlo 3) d, .reg (vhi 3) d',
        .reg (vlo 5) e, .reg (vhi 5) e', .reg (vlo 6) f, .reg (vhi 6) f',
        .reg x8 (k.zeroExtend 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]) t
      (Atoms.interp [.pc 0x100a4#64,
        .prop (regAny (vlo 4)), .prop (regAny (vhi 4)), .prop (regAny (vlo 2)),
        .prop (regAny (vhi 2)), .prop (regAny (vlo 1)), .prop (regAny (vhi 1)),
        .prop (regAny (vlo 3)), .prop (regAny (vhi 3)), .prop (regAny (vlo 5)),
        .prop (regAny (vhi 5)), .prop (regAny (vlo 6)), .prop (regAny (vhi 6)),
        .reg x8 ((k - 1).zeroExtend 64),
        .prop (flagAny Flags.n), .flag Flags.z (k.zeroExtend 64 == 1#64),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) (t ++ ls) } := by
  braid_traced
  intro a a' b b' c c' d d' e e' f f' k fn fz fc fv t
  braid_call columns_run.2 a a' b b' c c' d d' e e' k fn fz fc fv t
  arm_name_rows
  braid_call diagonals_run.2 _ _ _ _ _ _ _ _ _ _ f f' _
  braid_done

/-- A round of the loop, up to its branch, reveals nothing. -/
theorem double_round_run_eq : double_round_run.1 = [] := rfl

/-- **The loop of `chacha20_block_vec`, and what it reveals**, with `n + 1` rounds left,
whatever the vector registers hold. By recursion on `n`: a round is `double_round_run`, the
branch at its end adds a label, and the rounds that remain are this definition again. Only
`n` is bound before the pair, so the trace depends on nothing else. -/
def rounds_run : (n : Nat) → { ls : Trace // ∀ (a a' b b' c c' d d' e e' f f' : Word)
    (k : W32) (fn fz fc fv : Bool) (t : Trace),
    k = BitVec.ofNat 32 (n + 1) → n + 1 < 2 ^ 32 →
    TripleT chacha20_block_vec.program
      (Atoms.interp [.pc 0x10010#64,
        .reg (vlo 4) a, .reg (vhi 4) a', .reg (vlo 2) b, .reg (vhi 2) b',
        .reg (vlo 1) c, .reg (vhi 1) c', .reg (vlo 3) d, .reg (vhi 3) d',
        .reg (vlo 5) e, .reg (vhi 5) e', .reg (vlo 6) f, .reg (vhi 6) f',
        .reg x8 (k.zeroExtend 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]) t
      (Atoms.interp [.pc 0x100a8#64,
        .prop (regAny (vlo 4)), .prop (regAny (vhi 4)), .prop (regAny (vlo 2)),
        .prop (regAny (vhi 2)), .prop (regAny (vlo 1)), .prop (regAny (vhi 1)),
        .prop (regAny (vlo 3)), .prop (regAny (vhi 3)), .prop (regAny (vlo 5)),
        .prop (regAny (vhi 5)), .prop (regAny (vlo 6)), .prop (regAny (vhi 6)),
        .reg x8 0#64,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) (t ++ ls) }
  | 0 => by
    braid_traced
    intro a a' b b' c c' d d' e e' f f' k fn fz fc fv t hk _
    obtain rfl : k = 1#32 := hk
    braid_call double_round_run.2 a a' b b' c c' d d' e e' f f' 1#32 fn fz fc fv t
    braid_sym_step
    braid_forget_flag 1
    braid_done
  | n + 1 => by
    braid_traced
    intro a a' b b' c c' d d' e e' f f' k fn fz fc fv t hk hn
    braid_call double_round_run.2 a a' b b' c c' d d' e e' f f' k fn fz fc fv t
    braid_sym_step
    · arm_name_rows
      braid_name_reg (vlo 6)
      braid_name_reg (vhi 6)
      braid_name_flag 0
      braid_name_flag 2
      braid_name_flag 3
      braid_call (rounds_run n).2 _ _ _ _ _ _ _ _ _ _ _ _ (k - 1) _ _ _ _ _
        (by rw [hk]; bv_omega) (by omega)
      braid_done
    · exfalso
      have : k ≠ 1#32 := by rw [hk]; bv_omega
      exact this (by bv_decide)

/-- What the loop of rounds reveals with `n` rounds left after the one it is in: the trace
that `rounds_run` finds. It is the branch back to the head of the loop after each round but
the last, and the way out after the last. -/
def roundsVecLeak (n : Nat) : Trace := (rounds_run n).1

/-- After the last round, the branch goes on. -/
theorem roundsVecLeak_zero : roundsVecLeak 0 = [.jump 0x100a8#64] := rfl

/-- After a round that is not the last, the branch goes back to the head of the loop. -/
theorem roundsVecLeak_succ (n : Nat) :
    roundsVecLeak (n + 1) = .jump 0x10010#64 :: roundsVecLeak n := rfl

end Examples.ChaCha20Vec.Arm
