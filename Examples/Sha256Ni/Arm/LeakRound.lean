/-
  Examples.Sha256Ni.Arm.LeakRound

  What the two loops of `sha256_compress_ni` reveal on AArch64 (`docs/Leakage.md`): the
  addresses of the loads of the table of round constants, sixteen bytes a turn, and where the
  branch at the end of each turn goes. The SHA-256 instructions, the additions of lanes and
  the moves have no label; the address of a load is the table plus the count of the loop,
  and the branch tests a flag that a comparison of the count with a constant sets, so
  neither depends on the working variables or the schedule.

  The traces are not written here: each definition is a trace together with the traced
  triple that leaves it, and the run finds the trace (`Braid.Logic.Traced`). What a trace
  may depend on is what its definition binds before the pair, which is the number of the
  turn and the number of turns left, and nothing of the state. The traced triples say
  nothing of what is computed, which is `step_spec`, `loop_spec` and `tail_spec` of
  `Examples.Sha256Ni.Arm.Round`: the vector registers hold any words before and `regAny`
  after. Here the blocks of `sha256h` and `sha256h2` are run by the stepper, on opaque words,
  and what they leave is forgotten at once.

  ## Main definitions

  * `step_run`, `tail_step_run`: a turn of each loop, up to its branch, and its trace
  * `loop_run`, `tail_run`: each loop from a turn to its end, and its trace
  * `loopLeak`, `tailLeak`: what the loops reveal

  ## Main results

  * `step_run_eq`, `tail_step_run_eq`: the trace of a turn, written out
  * `loopLeak_zero`, `loopLeak_succ`, `tailLeak_zero`, `tailLeak_succ`: the traces of the
    loops, a turn at a time
-/

module

public import Braid.Logic.Traced
public import Braid.Logic.Any
public import Examples.Sha256Ni.Arm.Round

@[expose] public section

namespace Examples.Sha256Ni.Arm

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.Arm Lowering.Arm.Regs

/-! ## Tactics -/

/-- Replace the value of a register of the symbolic state of a traced triple by an equal
one: `Triple.reg_val`, with a trace. -/
theorem TripleT.reg_val {P : Braid.Program} {as as' : Atoms} {r : Reg} {v : Word}
    (v' : Word) {Q : SProp} {t t' : Trace} (hupd : as.Upd (.reg r v) (.reg r v') as') (he : v = v')
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  subst he
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h

/-- Give a register of the symbolic state of a traced triple the value `v`, which `h` proves
equal to the one it holds: `ni_valT r, v, h`. -/
macro "ni_valT " r:term ", " v:term ", " h:term : tactic =>
  `(tactic| (apply TripleT.reg_val (r := $r) $v
             case hupd => braid_upd
             case he => exact $h))

/-- Forget what a register holds and name it again: a value of which nothing is known. -/
macro "ni_fresh " r:term : tactic => `(tactic| (braid_forget $r; braid_name_reg $r))

/-- Forget what the ten vector registers of the loops hold: `v2` to `v7` and `v16` to
`v19`. -/
macro "ni_forget_work" : tactic =>
  `(tactic| (
             braid_forget (vlo 2); braid_forget (vhi 2)
             braid_forget (vlo 3); braid_forget (vhi 3)
             braid_forget (vlo 4); braid_forget (vhi 4)
             braid_forget (vlo 5); braid_forget (vhi 5)
             braid_forget (vlo 6); braid_forget (vhi 6)
             braid_forget (vlo 7); braid_forget (vhi 7)
             braid_forget (vlo 16); braid_forget (vhi 16)
             braid_forget (vlo 17); braid_forget (vhi 17)
             braid_forget (vlo 18); braid_forget (vhi 18)
             braid_forget (vlo 19); braid_forget (vhi 19)))

/-- Name what the ten vector registers of the loops hold. -/
macro "ni_name_work" : tactic =>
  `(tactic| (
             braid_name_reg (vlo 2); braid_name_reg (vhi 2)
             braid_name_reg (vlo 3); braid_name_reg (vhi 3)
             braid_name_reg (vlo 4); braid_name_reg (vhi 4)
             braid_name_reg (vlo 5); braid_name_reg (vhi 5)
             braid_name_reg (vlo 6); braid_name_reg (vhi 6)
             braid_name_reg (vlo 7); braid_name_reg (vhi 7)
             braid_name_reg (vlo 16); braid_name_reg (vhi 16)
             braid_name_reg (vlo 17); braid_name_reg (vhi 17)
             braid_name_reg (vlo 18); braid_name_reg (vhi 18)
             braid_name_reg (vlo 19); braid_name_reg (vhi 19)))

/-- Name what the flags other than the zero flag hold. -/
macro "ni_name_nzcv" : tactic =>
  `(tactic| (braid_name_flag 0; braid_name_flag 2; braid_name_flag 3))

/-! ## The first loop -/

/-- **A turn of the first loop, and what it reveals**, turn `i`, from the head of the loop
to the branch at its end, whatever the vector registers hold. Only `i` is bound before the
pair. The count in `x9` is sixteen more after, and the zero flag is set if that was the
last turn. -/
def step_run (i : Nat) : { ls : Trace // ∀ (wk : Bool)
    (y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17 y17' y18 y18' y19 y19' : Word)
    (fn fz fc fv : Bool) (t : Trace), i < 12 →
    TripleT sha256_compress_ni.program
      (Atoms.interp [.pc 0x100dc#64, .reg x8 0x20228#64,
        .reg x9 (BitVec.ofNat 64 (16 * i)),
        .reg (vlo 2) y2, .reg (vhi 2) y2', .reg (vlo 3) y3, .reg (vhi 3) y3',
        .reg (vlo 4) y4, .reg (vhi 4) y4', .reg (vlo 5) y5, .reg (vhi 5) y5',
        .reg (vlo 6) y6, .reg (vhi 6) y6', .reg (vlo 7) y7, .reg (vhi 7) y7',
        .reg (vlo 16) y16, .reg (vhi 16) y16', .reg (vlo 17) y17, .reg (vhi 17) y17',
        .reg (vlo 18) y18, .reg (vhi 18) y18', .reg (vlo 19) y19, .reg (vhi 19) y19',
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 8 wk 0x20228#64 (packs K))]) t
      (Atoms.interp [.pc 0x1011c#64, .reg x8 0x20228#64,
        .reg x9 (BitVec.ofNat 64 (16 * (i + 1))),
        .prop (regAny (vlo 2)), .prop (regAny (vhi 2)),
        .prop (regAny (vlo 3)), .prop (regAny (vhi 3)),
        .prop (regAny (vlo 4)), .prop (regAny (vhi 4)),
        .prop (regAny (vlo 5)), .prop (regAny (vhi 5)),
        .prop (regAny (vlo 6)), .prop (regAny (vhi 6)),
        .prop (regAny (vlo 7)), .prop (regAny (vhi 7)),
        .prop (regAny (vlo 16)), .prop (regAny (vhi 16)),
        .prop (regAny (vlo 17)), .prop (regAny (vhi 17)),
        .prop (regAny (vlo 18)), .prop (regAny (vhi 18)),
        .prop (regAny (vlo 19)), .prop (regAny (vhi 19)),
        .prop (flagAny Flags.n), .flag Flags.z (BitVec.ofNat 64 (16 * (i + 1)) == 192#64), .prop
        (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 8 wk 0x20228#64 (packs K))]) (t ++ ls) } := by
  braid_traced
  intro wk y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17 y17' y18 y18' y19 y19' fn fz fc
    fv t hi
  have hq : 4 * i + 3 < K.length := by show 4 * i + 3 < 64; omega
  have hq1 : 0x20228#64 + (BitVec.ofNat 64 (16 * i) + 8#64) =
      0x20228#64 + BitVec.ofNat 64 (16 * i + 8) := by rw [BitVec.ofNat_add]
  braid_unfold cells_quad_at wk 0x20228#64 (0x20228#64 + BitVec.ofNat 64 (16 * i))
    (0x20228#64 + (BitVec.ofNat 64 (16 * i) + 8#64)) K i hq rfl hq1
  -- The window copied, the load of four round constants, and the count.
  iterate 5 braid_sym_step
  ni_valT 9, BitVec.ofNat 64 (16 * (i + 1)), (by rw [Nat.mul_succ, BitVec.ofNat_add])
  -- The four sums, the first half of the new words, and the four rounds.
  iterate 5 braid_sym_step
  ni_fresh (vlo 4)
  ni_fresh (vhi 4)
  braid_sym_step
  ni_fresh (vlo 3)
  ni_fresh (vhi 3)
  -- The window moved on, and the second half of the new words.
  iterate 5 braid_sym_step
  sha256_fold cells_quad_at wk 0x20228#64 (0x20228#64 + BitVec.ofNat 64 (16 * i))
    (0x20228#64 + (BitVec.ofNat 64 (16 * i) + 8#64)) K i hq rfl hq1
  ni_forget_work
  braid_forget_flag 0
  braid_forget_flag 2
  braid_forget_flag 3
  braid_done

/-- A turn of the first loop reads sixteen bytes of the table of round constants, as two
loads of eight, at sixteen times the number of the turn. -/
theorem step_run_eq (i : Nat) : (step_run i).1 =
    [.read (0x20228#64 + BitVec.ofNat 64 (16 * i)) 8,
      .read (0x20228#64 + (BitVec.ofNat 64 (16 * i) + 8#64)) 8] := rfl

/-- **The first loop, and what it reveals**, from turn `i`, with `n` turns after this one,
whatever the vector registers hold. By recursion on `n`: a turn is `step_run`, the branch at
its end adds a label, and the turns that remain are this definition again. Only `n` and `i`
are bound before the pair. -/
def loop_run : (n i : Nat) → { ls : Trace // ∀ (wk : Bool)
    (y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17 y17' y18 y18' y19 y19' : Word)
    (fn fz fc fv : Bool) (t : Trace), i + n + 1 = 12 →
    TripleT sha256_compress_ni.program
      (Atoms.interp [.pc 0x100dc#64, .reg x8 0x20228#64,
        .reg x9 (BitVec.ofNat 64 (16 * i)),
        .reg (vlo 2) y2, .reg (vhi 2) y2', .reg (vlo 3) y3, .reg (vhi 3) y3',
        .reg (vlo 4) y4, .reg (vhi 4) y4', .reg (vlo 5) y5, .reg (vhi 5) y5',
        .reg (vlo 6) y6, .reg (vhi 6) y6', .reg (vlo 7) y7, .reg (vhi 7) y7',
        .reg (vlo 16) y16, .reg (vhi 16) y16', .reg (vlo 17) y17, .reg (vhi 17) y17',
        .reg (vlo 18) y18, .reg (vhi 18) y18', .reg (vlo 19) y19, .reg (vhi 19) y19',
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 8 wk 0x20228#64 (packs K))]) t
      (Atoms.interp [.pc 0x10120#64, .reg x8 0x20228#64,
        .reg x9 192#64,
        .prop (regAny (vlo 2)), .prop (regAny (vhi 2)),
        .prop (regAny (vlo 3)), .prop (regAny (vhi 3)),
        .prop (regAny (vlo 4)), .prop (regAny (vhi 4)),
        .prop (regAny (vlo 5)), .prop (regAny (vhi 5)),
        .prop (regAny (vlo 6)), .prop (regAny (vhi 6)),
        .prop (regAny (vlo 7)), .prop (regAny (vhi 7)),
        .prop (regAny (vlo 16)), .prop (regAny (vhi 16)),
        .prop (regAny (vlo 17)), .prop (regAny (vhi 17)),
        .prop (regAny (vlo 18)), .prop (regAny (vhi 18)),
        .prop (regAny (vlo 19)), .prop (regAny (vhi 19)),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 8 wk 0x20228#64 (packs K))]) (t ++ ls) }
  | 0, i => by
    braid_traced
    intro wk y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17 y17' y18 y18' y19 y19' fn fz
      fc fv t hn
    braid_call (step_run i).2 wk y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17 y17' y18
      y18' y19 y19' fn fz fc fv t (by omega)
    braid_sym_step
    · exfalso
      exact hbr (by obtain rfl : i = 11 := (by omega); decide)
    · ni_valT 9, 192#64, (by obtain rfl : i = 11 := (by omega); decide)
      braid_forget_flag 1
      braid_done
  | n + 1, i => by
    braid_traced
    intro wk y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17 y17' y18 y18' y19 y19' fn fz
      fc fv t hn
    braid_call (step_run i).2 wk y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17 y17' y18
      y18' y19 y19' fn fz fc fv t (by omega)
    braid_sym_step
    · ni_name_work
      ni_name_nzcv
      braid_call (loop_run n (i + 1)).2 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by
        omega)
      braid_done
    · exfalso
      bv_omega

/-- What the first loop reveals from turn `i`, with `n` turns after this one: the trace that
`loop_run` finds. Each turn loads sixteen bytes of the table of round constants and
branches, back to the head of the loop or, after the last turn, on. -/
def loopLeak (n i : Nat) : Trace := (loop_run n i).1

/-- After the last turn, the branch goes on. -/
theorem loopLeak_zero (i : Nat) : loopLeak 0 i =
    [.read (0x20228#64 + BitVec.ofNat 64 (16 * i)) 8,
      .read (0x20228#64 + (BitVec.ofNat 64 (16 * i) + 8#64)) 8, .jump 0x10120#64] := rfl

/-- After a turn that is not the last, the branch goes back to the head of the loop. -/
theorem loopLeak_succ (n i : Nat) : loopLeak (n + 1) i =
    .read (0x20228#64 + BitVec.ofNat 64 (16 * i)) 8 ::
      .read (0x20228#64 + (BitVec.ofNat 64 (16 * i) + 8#64)) 8 :: .jump 0x100dc#64 ::
      loopLeak n (i + 1) := rfl

/-! ## The second loop -/

/-- **A turn of the second loop, and what it reveals**, turn `j`, from the head of the loop
to the branch at its end, whatever the vector registers hold. Only `j` is bound before the
pair. -/
def tail_step_run (j : Nat) : { ls : Trace // ∀ (wk : Bool) (t10 : Word)
    (y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17 y17' y18 y18' y19 y19' : Word)
    (fn fz fc fv : Bool) (t : Trace), j < 4 →
    TripleT sha256_compress_ni.program
      (Atoms.interp [.pc 0x10124#64, .reg x8 0x20228#64,
        .reg x9 (BitVec.ofNat 64 (16 * j)), .reg x10 t10,
        .reg (vlo 2) y2, .reg (vhi 2) y2', .reg (vlo 3) y3, .reg (vhi 3) y3',
        .reg (vlo 4) y4, .reg (vhi 4) y4', .reg (vlo 5) y5, .reg (vhi 5) y5',
        .reg (vlo 6) y6, .reg (vhi 6) y6', .reg (vlo 7) y7, .reg (vhi 7) y7',
        .reg (vlo 16) y16, .reg (vhi 16) y16', .reg (vlo 17) y17, .reg (vhi 17) y17',
        .reg (vlo 18) y18, .reg (vhi 18) y18', .reg (vlo 19) y19, .reg (vhi 19) y19',
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 8 wk 0x20228#64 (packs K))]) t
      (Atoms.interp [.pc 0x10150#64, .reg x8 0x20228#64,
        .reg x9 (BitVec.ofNat 64 (16 * (j + 1))), .prop (regAny x10),
        .prop (regAny (vlo 2)), .prop (regAny (vhi 2)),
        .prop (regAny (vlo 3)), .prop (regAny (vhi 3)),
        .prop (regAny (vlo 4)), .prop (regAny (vhi 4)),
        .prop (regAny (vlo 5)), .prop (regAny (vhi 5)),
        .prop (regAny (vlo 6)), .prop (regAny (vhi 6)),
        .prop (regAny (vlo 7)), .prop (regAny (vhi 7)),
        .prop (regAny (vlo 16)), .prop (regAny (vhi 16)),
        .prop (regAny (vlo 17)), .prop (regAny (vhi 17)),
        .prop (regAny (vlo 18)), .prop (regAny (vhi 18)),
        .prop (regAny (vlo 19)), .prop (regAny (vhi 19)),
        .prop (flagAny Flags.n), .flag Flags.z (BitVec.ofNat 64 (16 * (j + 1)) == 64#64), .prop
        (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 8 wk 0x20228#64 (packs K))]) (t ++ ls) } := by
  braid_traced
  intro wk t10 y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17 y17' y18 y18' y19 y19' fn fz
    fc fv t hj
  have hq : 4 * (12 + j) + 3 < K.length := by show 4 * (12 + j) + 3 < 64; omega
  have hq0 : 0x20228#64 + (BitVec.ofNat 64 (16 * j) + 192#64) =
      0x20228#64 + BitVec.ofNat 64 (16 * (12 + j)) := by
    rw [Nat.mul_add, BitVec.ofNat_add]
    generalize BitVec.ofNat 64 (16 * j) = z
    bv_decide
  have hq1 : 0x20228#64 + (BitVec.ofNat 64 (16 * j) + 200#64) =
      0x20228#64 + BitVec.ofNat 64 (16 * (12 + j) + 8) := by
    rw [Nat.mul_add, BitVec.ofNat_add, BitVec.ofNat_add]
    generalize BitVec.ofNat 64 (16 * j) = z
    bv_decide
  braid_unfold cells_quad_at wk 0x20228#64 (0x20228#64 + (BitVec.ofNat 64 (16 * j) + 192#64))
    (0x20228#64 + (BitVec.ofNat 64 (16 * j) + 200#64)) K (12 + j) hq hq0 hq1
  -- The address of four round constants, and the count.
  iterate 2 braid_sym_step
  ni_valT 9, BitVec.ofNat 64 (16 * (j + 1)), (by rw [Nat.mul_succ, BitVec.ofNat_add])
  -- The load, the four sums, and the four rounds.
  iterate 5 braid_sym_step
  ni_fresh (vlo 4)
  ni_fresh (vhi 4)
  braid_sym_step
  ni_fresh (vlo 3)
  ni_fresh (vhi 3)
  -- The window moved on.
  iterate 3 braid_sym_step
  sha256_fold cells_quad_at wk 0x20228#64
    (0x20228#64 + (BitVec.ofNat 64 (16 * j) + 192#64))
    (0x20228#64 + (BitVec.ofNat 64 (16 * j) + 200#64)) K (12 + j) hq hq0 hq1
  ni_forget_work
  braid_forget 10
  braid_forget_flag 0
  braid_forget_flag 2
  braid_forget_flag 3
  braid_done

/-- A turn of the second loop reads sixteen bytes of the table of round constants, 192 bytes
after those the turn of the same number of the first loop reads. -/
theorem tail_step_run_eq (j : Nat) : (tail_step_run j).1 =
    [.read (0x20228#64 + (BitVec.ofNat 64 (16 * j) + 192#64)) 8,
      .read (0x20228#64 + (BitVec.ofNat 64 (16 * j) + 200#64)) 8] := rfl

/-- **The second loop, and what it reveals**, from turn `i`, with `n` turns after this one,
whatever the vector registers hold: `tail_step_run` and a branch for each turn, by recursion
on `n`. Only `n` and `i` are bound before the pair. -/
def tail_run : (n i : Nat) → { ls : Trace // ∀ (wk : Bool) (t10 : Word)
    (y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17 y17' y18 y18' y19 y19' : Word)
    (fn fz fc fv : Bool) (t : Trace), i + n + 1 = 4 →
    TripleT sha256_compress_ni.program
      (Atoms.interp [.pc 0x10124#64, .reg x8 0x20228#64,
        .reg x9 (BitVec.ofNat 64 (16 * i)), .reg x10 t10,
        .reg (vlo 2) y2, .reg (vhi 2) y2', .reg (vlo 3) y3, .reg (vhi 3) y3',
        .reg (vlo 4) y4, .reg (vhi 4) y4', .reg (vlo 5) y5, .reg (vhi 5) y5',
        .reg (vlo 6) y6, .reg (vhi 6) y6', .reg (vlo 7) y7, .reg (vhi 7) y7',
        .reg (vlo 16) y16, .reg (vhi 16) y16', .reg (vlo 17) y17, .reg (vhi 17) y17',
        .reg (vlo 18) y18, .reg (vhi 18) y18', .reg (vlo 19) y19, .reg (vhi 19) y19',
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 8 wk 0x20228#64 (packs K))]) t
      (Atoms.interp [.pc 0x10154#64, .reg x8 0x20228#64,
        .reg x9 64#64, .prop (regAny x10),
        .prop (regAny (vlo 2)), .prop (regAny (vhi 2)),
        .prop (regAny (vlo 3)), .prop (regAny (vhi 3)),
        .prop (regAny (vlo 4)), .prop (regAny (vhi 4)),
        .prop (regAny (vlo 5)), .prop (regAny (vhi 5)),
        .prop (regAny (vlo 6)), .prop (regAny (vhi 6)),
        .prop (regAny (vlo 7)), .prop (regAny (vhi 7)),
        .prop (regAny (vlo 16)), .prop (regAny (vhi 16)),
        .prop (regAny (vlo 17)), .prop (regAny (vhi 17)),
        .prop (regAny (vlo 18)), .prop (regAny (vhi 18)),
        .prop (regAny (vlo 19)), .prop (regAny (vhi 19)),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 8 wk 0x20228#64 (packs K))]) (t ++ ls) }
  | 0, i => by
    braid_traced
    intro wk t10 y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17 y17' y18 y18' y19 y19' fn
      fz fc fv t hn
    braid_call (tail_step_run i).2 wk t10 y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17
      y17' y18 y18' y19 y19' fn fz fc fv t (by omega)
    braid_sym_step
    · exfalso
      exact hbr (by obtain rfl : i = 3 := (by omega); decide)
    · ni_valT 9, 64#64, (by obtain rfl : i = 3 := (by omega); decide)
      braid_forget_flag 1
      braid_done
  | n + 1, i => by
    braid_traced
    intro wk t10 y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17 y17' y18 y18' y19 y19' fn
      fz fc fv t hn
    braid_call (tail_step_run i).2 wk t10 y2 y2' y3 y3' y4 y4' y5 y5' y6 y6' y7 y7' y16 y16' y17
      y17' y18 y18' y19 y19' fn fz fc fv t (by omega)
    braid_sym_step
    · ni_name_work
      braid_name_reg 10
      ni_name_nzcv
      braid_call (tail_run n (i + 1)).2 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by
        omega)
      braid_done
    · exfalso
      bv_omega

/-- What the second loop reveals from turn `i`, with `n` turns after this one: the trace
that `tail_run` finds. -/
def tailLeak (n i : Nat) : Trace := (tail_run n i).1

/-- After the last turn, the branch goes on. -/
theorem tailLeak_zero (i : Nat) : tailLeak 0 i =
    [.read (0x20228#64 + (BitVec.ofNat 64 (16 * i) + 192#64)) 8,
      .read (0x20228#64 + (BitVec.ofNat 64 (16 * i) + 200#64)) 8, .jump 0x10154#64] := rfl

/-- After a turn that is not the last, the branch goes back to the head of the loop. -/
theorem tailLeak_succ (n i : Nat) : tailLeak (n + 1) i =
    .read (0x20228#64 + (BitVec.ofNat 64 (16 * i) + 192#64)) 8 ::
      .read (0x20228#64 + (BitVec.ofNat 64 (16 * i) + 200#64)) 8 :: .jump 0x10124#64 ::
      tailLeak n (i + 1) := rfl

end Examples.Sha256Ni.Arm
