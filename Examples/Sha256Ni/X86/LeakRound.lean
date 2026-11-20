/-
  Examples.Sha256Ni.X86.LeakRound

  What the two loops of `sha256_compress_ni` reveal on x86-64 (`docs/Leakage.md`), with the
  traces found by the run (`Braid.Logic.Traced`).

  A turn of either loop reads sixteen bytes of the table of round constants, at an offset
  that is sixteen times the number of the turn, and ends with a branch on that number. It
  reads and writes nothing else in memory, and what the vector registers hold is in no
  address and no branch. So each definition here binds before its pair only the number of
  the turn and the number of turns left: the sixteen words of the vector registers, the
  flags and whether the table is read-only are bound inside it, and the trace found cannot
  depend on them.

  The values the instructions compute are forgotten as soon as they are computed, so no term
  of a round is carried through the run.

  ## Main definitions

  * `step_run`, `tail_step_run`: a turn of each loop, up to its branch
  * `loop_run`, `tail_run`: each loop, by recursion on the turns left
  * `loopLeak`, `tailLeak`: what the loops reveal

  ## Main results

  * `step_run_eq`, `tail_step_run_eq`: the two loads of a turn
  * `loopLeak_zero`, `loopLeak_succ`, `tailLeak_zero`, `tailLeak_succ`: the traces of the
    loops, a turn at a time
-/

module

public import Braid.Logic.Traced
public import Examples.Sha256Ni.X86.Round

@[expose] public section

namespace Examples.Sha256Ni.X86

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.X86 Lowering.X86.Regs

/-! ## Tactics -/

/-- Replace the value of a register of the symbolic state of a traced triple by an equal
one: `Triple.reg_val`, with a trace. -/
theorem TripleT.reg_val {P : Braid.Program} {as as' : Atoms} {r : Reg} {v : Word} (v' : Word)
    {Q : SProp} {t t' : Trace} (hupd : as.Upd (.reg r v) (.reg r v') as') (he : v = v')
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

/-- Forget what the eight vector registers of the loops hold: `xmm0`, `xmm1`, `xmm2` and
`xmm5` to `xmm9`. -/
macro "ni_forget_work" : tactic =>
  `(tactic| (braid_forget 32; braid_forget 33; braid_forget 40; braid_forget 41
             braid_forget 48; braid_forget 49; braid_forget 72; braid_forget 73
             braid_forget 80; braid_forget 81; braid_forget 88; braid_forget 89
             braid_forget 96; braid_forget 97; braid_forget 104; braid_forget 105))

/-- Name what the eight vector registers of the loops hold. -/
macro "ni_name_work" : tactic =>
  `(tactic| (braid_name_reg 32; braid_name_reg 33; braid_name_reg 40; braid_name_reg 41
             braid_name_reg 48; braid_name_reg 49; braid_name_reg 72; braid_name_reg 73
             braid_name_reg 80; braid_name_reg 81; braid_name_reg 88; braid_name_reg 89
             braid_name_reg 96; braid_name_reg 97; braid_name_reg 104; braid_name_reg 105))

/-- Forget the values of the status flags other than the zero flag. -/
macro "ni_forget_flags" : tactic =>
  `(tactic| (try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-! ## The first loop -/

/-- **A turn of the first loop, and what it reveals**, turn `i`, from the head of the loop
to the branch at its end, whatever the vector registers hold. Only `i` is bound before the
pair. The count in `rcx` is sixteen more after, and the zero flag is set if that was the
last turn. -/
def step_run (i : Nat) : { ls : Trace // ∀ (wk : Bool)
    (x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9' : Word) (fc fp fa fz fs fo : Bool)
    (t : Trace), i < 12 →
    TripleT sha256_compress_ni.program
      (Atoms.interp [.pc 0x401050#64, .reg rax 0x402110#64,
        .reg rcx (BitVec.ofNat 64 (16 * i)),
        .reg (zmm 0 0) x0, .reg (zmm 0 1) x0', .reg (zmm 1 0) x1, .reg (zmm 1 1) x1',
        .reg (zmm 2 0) x2, .reg (zmm 2 1) x2', .reg (zmm 5 0) x5, .reg (zmm 5 1) x5',
        .reg (zmm 6 0) x6, .reg (zmm 6 1) x6', .reg (zmm 7 0) x7, .reg (zmm 7 1) x7',
        .reg (zmm 8 0) x8, .reg (zmm 8 1) x8', .reg (zmm 9 0) x9, .reg (zmm 9 1) x9',
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (cellsAt 8 wk 0x402110#64 (packs K))]) t
      (Atoms.interp [.pc 0x401098#64, .reg rax 0x402110#64,
        .reg rcx (BitVec.ofNat 64 (16 * (i + 1))),
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)), .prop (regAny (zmm 1 0)),
        .prop (regAny (zmm 1 1)), .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .prop (regAny (zmm 5 0)), .prop (regAny (zmm 5 1)), .prop (regAny (zmm 6 0)),
        .prop (regAny (zmm 6 1)), .prop (regAny (zmm 7 0)), .prop (regAny (zmm 7 1)),
        .prop (regAny (zmm 8 0)), .prop (regAny (zmm 8 1)), .prop (regAny (zmm 9 0)),
        .prop (regAny (zmm 9 1)),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .flag Flags.zf (BitVec.ofNat 64 (16 * (i + 1)) + 18446744073709551424#64 == 0#64),
        .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 8 wk 0x402110#64 (packs K))]) (t ++ ls) } := by
  braid_traced
  intro wk x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9' fc fp fa fz fs fo t hi
  have ha := aligned16 i
  have hq : 4 * i + 3 < K.length := by show 4 * i + 3 < 64; omega
  have hq0 : BitVec.ofNat 64 (16 * i) + 0x402110#64 =
      0x402110#64 + BitVec.ofNat 64 (16 * i) := BitVec.add_comm _ _
  have hq1 : BitVec.ofNat 64 (16 * i) + 0x402118#64 =
      0x402110#64 + BitVec.ofNat 64 (16 * i + 8) := by
    rw [BitVec.ofNat_add]
    generalize BitVec.ofNat 64 (16 * i) = z
    bv_decide
  braid_unfold cells_quad_at wk 0x402110#64 (BitVec.ofNat 64 (16 * i) + 0x402110#64)
    (BitVec.ofNat 64 (16 * i) + 0x402118#64) K i hq hq0 hq1
  -- The four sums, and the first two rounds.
  iterate 7 braid_sym_step
  ni_fresh 72
  ni_fresh 73
  -- The last two rounds.
  braid_sym_step
  ni_fresh 32
  ni_fresh 33
  braid_sym_step
  ni_fresh 88
  ni_fresh 89
  -- Four new words of the schedule, and the count.
  iterate 5 braid_sym_step
  ni_valT 2, BitVec.ofNat 64 (16 * (i + 1)), (by
    rw [Nat.mul_succ, BitVec.ofNat_add, BitVec.add_comm])
  braid_sym_step
  sha256_fold cells_quad_at wk 0x402110#64 (BitVec.ofNat 64 (16 * i) + 0x402110#64)
    (BitVec.ofNat 64 (16 * i) + 0x402118#64) K i hq hq0 hq1
  ni_forget_work
  ni_forget_flags
  braid_done

/-- A turn of the first loop reads sixteen bytes of the table of round constants, as two
loads of eight, at sixteen times the number of the turn. -/
theorem step_run_eq (i : Nat) : (step_run i).1 =
    [.read (BitVec.ofNat 64 (16 * i) + 0x402110#64) 8,
      .read (BitVec.ofNat 64 (16 * i) + 0x402118#64) 8] := rfl

/-- **The first loop, and what it reveals**, from turn `i`, with `n` turns after this one,
whatever the vector registers hold. By recursion on `n`: a turn is `step_run`, the branch at
its end adds a label, and the turns that remain are this definition again. Only `n` and `i`
are bound before the pair. -/
def loop_run : (n i : Nat) → { ls : Trace // ∀ (wk : Bool)
    (x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9' : Word) (fc fp fa fz fs fo : Bool)
    (t : Trace), i + n + 1 = 12 →
    TripleT sha256_compress_ni.program
      (Atoms.interp [.pc 0x401050#64, .reg rax 0x402110#64,
        .reg rcx (BitVec.ofNat 64 (16 * i)),
        .reg (zmm 0 0) x0, .reg (zmm 0 1) x0', .reg (zmm 1 0) x1, .reg (zmm 1 1) x1',
        .reg (zmm 2 0) x2, .reg (zmm 2 1) x2', .reg (zmm 5 0) x5, .reg (zmm 5 1) x5',
        .reg (zmm 6 0) x6, .reg (zmm 6 1) x6', .reg (zmm 7 0) x7, .reg (zmm 7 1) x7',
        .reg (zmm 8 0) x8, .reg (zmm 8 1) x8', .reg (zmm 9 0) x9, .reg (zmm 9 1) x9',
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (cellsAt 8 wk 0x402110#64 (packs K))]) t
      (Atoms.interp [.pc 0x40109a#64, .reg rax 0x402110#64, .reg rcx 192#64,
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)), .prop (regAny (zmm 1 0)),
        .prop (regAny (zmm 1 1)), .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .prop (regAny (zmm 5 0)), .prop (regAny (zmm 5 1)), .prop (regAny (zmm 6 0)),
        .prop (regAny (zmm 6 1)), .prop (regAny (zmm 7 0)), .prop (regAny (zmm 7 1)),
        .prop (regAny (zmm 8 0)), .prop (regAny (zmm 8 1)), .prop (regAny (zmm 9 0)),
        .prop (regAny (zmm 9 1)),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 8 wk 0x402110#64 (packs K))]) (t ++ ls) }
  | 0, i => by
    braid_traced
    intro wk x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9' fc fp fa fz fs fo t hn
    braid_call (step_run i).2 wk x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9' fc fp fa
      fz fs fo t (by omega)
    braid_sym_step
    · exfalso
      exact hbr (by obtain rfl : i = 11 := (by omega); decide)
    · ni_valT 2, 192#64, (by obtain rfl : i = 11 := (by omega); decide)
      braid_forget_flag 3
      braid_done
  | n + 1, i => by
    braid_traced
    intro wk x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9' fc fp fa fz fs fo t hn
    braid_call (step_run i).2 wk x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9' fc fp fa
      fz fs fo t (by omega)
    braid_sym_step
    · ni_name_work
      x86_name_all_flags
      braid_call (loop_run n (i + 1)).2 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by omega)
      braid_done
    · exfalso
      bv_omega

/-- What the first loop reveals from turn `i`, with `n` turns after this one: the trace that
`loop_run` finds. Each turn loads sixteen bytes of the table of round constants and
branches, back to the head of the loop or, after the last turn, on. -/
def loopLeak (n i : Nat) : Trace := (loop_run n i).1

/-- After the last turn, the branch goes on. -/
theorem loopLeak_zero (i : Nat) : loopLeak 0 i =
    [.read (BitVec.ofNat 64 (16 * i) + 0x402110#64) 8,
      .read (BitVec.ofNat 64 (16 * i) + 0x402118#64) 8, .jump 0x40109a#64] := rfl

/-- After a turn that is not the last, the branch goes back to the head of the loop. -/
theorem loopLeak_succ (n i : Nat) : loopLeak (n + 1) i =
    .read (BitVec.ofNat 64 (16 * i) + 0x402110#64) 8 ::
      .read (BitVec.ofNat 64 (16 * i) + 0x402118#64) 8 :: .jump 0x401050#64 ::
      loopLeak n (i + 1) := rfl

/-! ## The second loop -/

/-- **A turn of the second loop, and what it reveals**, turn `j`, from the head of the loop
to the branch at its end, whatever the vector registers hold. Only `j` is bound before the
pair. -/
def tail_step_run (j : Nat) : { ls : Trace // ∀ (wk : Bool)
    (x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9' : Word) (fc fp fa fz fs fo : Bool)
    (t : Trace), j < 4 →
    TripleT sha256_compress_ni.program
      (Atoms.interp [.pc 0x4010a0#64, .reg rax 0x402110#64,
        .reg rcx (BitVec.ofNat 64 (16 * j)),
        .reg (zmm 0 0) x0, .reg (zmm 0 1) x0', .reg (zmm 1 0) x1, .reg (zmm 1 1) x1',
        .reg (zmm 2 0) x2, .reg (zmm 2 1) x2', .reg (zmm 5 0) x5, .reg (zmm 5 1) x5',
        .reg (zmm 6 0) x6, .reg (zmm 6 1) x6', .reg (zmm 7 0) x7, .reg (zmm 7 1) x7',
        .reg (zmm 8 0) x8, .reg (zmm 8 1) x8', .reg (zmm 9 0) x9, .reg (zmm 9 1) x9',
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (cellsAt 8 wk 0x402110#64 (packs K))]) t
      (Atoms.interp [.pc 0x4010d5#64, .reg rax 0x402110#64,
        .reg rcx (BitVec.ofNat 64 (16 * (j + 1))),
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)), .prop (regAny (zmm 1 0)),
        .prop (regAny (zmm 1 1)), .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .prop (regAny (zmm 5 0)), .prop (regAny (zmm 5 1)), .prop (regAny (zmm 6 0)),
        .prop (regAny (zmm 6 1)), .prop (regAny (zmm 7 0)), .prop (regAny (zmm 7 1)),
        .prop (regAny (zmm 8 0)), .prop (regAny (zmm 8 1)), .prop (regAny (zmm 9 0)),
        .prop (regAny (zmm 9 1)),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .flag Flags.zf (BitVec.ofNat 64 (16 * (j + 1)) + 18446744073709551552#64 == 0#64),
        .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 8 wk 0x402110#64 (packs K))]) (t ++ ls) } := by
  braid_traced
  intro wk x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9' fc fp fa fz fs fo t hj
  have ha := aligned16 j
  have hq : 4 * (12 + j) + 3 < K.length := by show 4 * (12 + j) + 3 < 64; omega
  have hq0 : BitVec.ofNat 64 (16 * j) + 0x4021d0#64 =
      0x402110#64 + BitVec.ofNat 64 (16 * (12 + j)) := by
    rw [Nat.mul_add, BitVec.ofNat_add]
    generalize BitVec.ofNat 64 (16 * j) = z
    bv_decide
  have hq1 : BitVec.ofNat 64 (16 * j) + 0x4021d8#64 =
      0x402110#64 + BitVec.ofNat 64 (16 * (12 + j) + 8) := by
    rw [Nat.mul_add, BitVec.ofNat_add, BitVec.ofNat_add]
    generalize BitVec.ofNat 64 (16 * j) = z
    bv_decide
  braid_unfold cells_quad_at wk 0x402110#64 (BitVec.ofNat 64 (16 * j) + 0x4021d0#64)
    (BitVec.ofNat 64 (16 * j) + 0x4021d8#64) K (12 + j) hq hq0 hq1
  -- The four sums.
  braid_sym_step
  ni_fresh 40
  ni_fresh 41
  -- The window moved on, and the first two rounds.
  iterate 5 braid_sym_step
  ni_fresh 72
  ni_fresh 73
  -- The last two rounds, and the count.
  iterate 2 braid_sym_step
  ni_fresh 88
  ni_fresh 89
  braid_sym_step
  ni_valT 2, BitVec.ofNat 64 (16 * (j + 1)), (by
    rw [Nat.mul_succ, BitVec.ofNat_add, BitVec.add_comm])
  iterate 2 braid_sym_step
  sha256_fold cells_quad_at wk 0x402110#64 (BitVec.ofNat 64 (16 * j) + 0x4021d0#64)
    (BitVec.ofNat 64 (16 * j) + 0x4021d8#64) K (12 + j) hq hq0 hq1
  ni_forget_work
  ni_forget_flags
  braid_done

/-- A turn of the second loop reads sixteen bytes of the table of round constants, 192 bytes
after those the turn of the same number of the first loop reads. -/
theorem tail_step_run_eq (j : Nat) : (tail_step_run j).1 =
    [.read (BitVec.ofNat 64 (16 * j) + 0x4021d0#64) 8,
      .read (BitVec.ofNat 64 (16 * j) + 0x4021d8#64) 8] := rfl

/-- **The second loop, and what it reveals**, from turn `i`, with `n` turns after this one,
whatever the vector registers hold: `tail_step_run` and a branch for each turn, by recursion
on `n`. Only `n` and `i` are bound before the pair. -/
def tail_run : (n i : Nat) → { ls : Trace // ∀ (wk : Bool)
    (x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9' : Word) (fc fp fa fz fs fo : Bool)
    (t : Trace), i + n + 1 = 4 →
    TripleT sha256_compress_ni.program
      (Atoms.interp [.pc 0x4010a0#64, .reg rax 0x402110#64,
        .reg rcx (BitVec.ofNat 64 (16 * i)),
        .reg (zmm 0 0) x0, .reg (zmm 0 1) x0', .reg (zmm 1 0) x1, .reg (zmm 1 1) x1',
        .reg (zmm 2 0) x2, .reg (zmm 2 1) x2', .reg (zmm 5 0) x5, .reg (zmm 5 1) x5',
        .reg (zmm 6 0) x6, .reg (zmm 6 1) x6', .reg (zmm 7 0) x7, .reg (zmm 7 1) x7',
        .reg (zmm 8 0) x8, .reg (zmm 8 1) x8', .reg (zmm 9 0) x9, .reg (zmm 9 1) x9',
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (cellsAt 8 wk 0x402110#64 (packs K))]) t
      (Atoms.interp [.pc 0x4010d7#64, .reg rax 0x402110#64, .reg rcx 64#64,
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)), .prop (regAny (zmm 1 0)),
        .prop (regAny (zmm 1 1)), .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .prop (regAny (zmm 5 0)), .prop (regAny (zmm 5 1)), .prop (regAny (zmm 6 0)),
        .prop (regAny (zmm 6 1)), .prop (regAny (zmm 7 0)), .prop (regAny (zmm 7 1)),
        .prop (regAny (zmm 8 0)), .prop (regAny (zmm 8 1)), .prop (regAny (zmm 9 0)),
        .prop (regAny (zmm 9 1)),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 8 wk 0x402110#64 (packs K))]) (t ++ ls) }
  | 0, i => by
    braid_traced
    intro wk x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9' fc fp fa fz fs fo t hn
    braid_call (tail_step_run i).2 wk x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9'
      fc fp fa fz fs fo t (by omega)
    braid_sym_step
    · exfalso
      exact hbr (by obtain rfl : i = 3 := (by omega); decide)
    · ni_valT 2, 64#64, (by obtain rfl : i = 3 := (by omega); decide)
      braid_forget_flag 3
      braid_done
  | n + 1, i => by
    braid_traced
    intro wk x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9' fc fp fa fz fs fo t hn
    braid_call (tail_step_run i).2 wk x0 x0' x1 x1' x2 x2' x5 x5' x6 x6' x7 x7' x8 x8' x9 x9'
      fc fp fa fz fs fo t (by omega)
    braid_sym_step
    · ni_name_work
      x86_name_all_flags
      braid_call (tail_run n (i + 1)).2 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by omega)
      braid_done
    · exfalso
      bv_omega

/-- What the second loop reveals from turn `i`, with `n` turns after this one: the trace
that `tail_run` finds. -/
def tailLeak (n i : Nat) : Trace := (tail_run n i).1

/-- After the last turn, the branch goes on. -/
theorem tailLeak_zero (i : Nat) : tailLeak 0 i =
    [.read (BitVec.ofNat 64 (16 * i) + 0x4021d0#64) 8,
      .read (BitVec.ofNat 64 (16 * i) + 0x4021d8#64) 8, .jump 0x4010d7#64] := rfl

/-- After a turn that is not the last, the branch goes back to the head of the loop. -/
theorem tailLeak_succ (n i : Nat) : tailLeak (n + 1) i =
    .read (BitVec.ofNat 64 (16 * i) + 0x4021d0#64) 8 ::
      .read (BitVec.ofNat 64 (16 * i) + 0x4021d8#64) 8 :: .jump 0x4010a0#64 ::
      tailLeak n (i + 1) := rfl

end Examples.Sha256Ni.X86
