/-
  Examples.ChaCha20.RiscV.Round

  The loop of `chacha20_block` of `chacha20.c` on RISC-V: ten double rounds on a state of
  sixteen words, which the compiler keeps in sixteen registers.

  A round of the loop is 161 instructions that work on the registers alone: the four quarter
  rounds on the columns, side by side, and then the four on the diagonals. The registers are
  64 bits wide and the arithmetic is on all 64 (`QuarterRound.lean`), so the high half of a
  register holds junk from the first `add` on, and never loses it: nothing in the loop
  narrows a word but `srliw`, into a scratch register. The loop is therefore specified by a
  function on sixteen 64-bit words, `innerW`, which is the code's arithmetic as it is,
  instruction by instruction; each half of a round is run symbolically once and ends in
  exactly that. That the low halves of `innerW` are `ChaCha20.inner` of the low halves is a
  separate lemma about bit-vectors, proved by `bv_auto` one quarter round deep. After a
  round the registers hold `innerW` of what they held, so nothing grows from round to round,
  and the loop is an induction on the number of rounds left.

  ## Main definitions

  * `colsW`, `diagsW`: the two halves of a round, as the code computes them on 64-bit words
  * `innerW`, `innerNW`: a round of the loop, and `n` of them

  ## Main results

  * `low_colsL`, `low_diagsL`, `low_innerW`, `low_innerNW`: the low halves are the
    specification's function of the low halves
  * `columns_spec`, `diagonals_spec`: the two halves of a round
  * `double_round_spec`: a round of the loop is `innerW`
  * `rounds_spec`: the loop, with `n + 1` rounds left, is `innerNW (n + 1)`
-/

module

public import Examples.ChaCha20.RiscV.QuarterRound
import Braid.BV

@[expose] public section

namespace Examples.ChaCha20.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-! ## The expressions -/

/-- What the first half of a round of the loop of `chacha20_block` computes, instruction by
instruction, from the registers the state is in: 64-bit arithmetic, as the stepper writes
it. The arguments and the result are in the order of the words of the state. -/
def colsW (s0 s2 s3 s1 t6 t0 t1 t3 a5 a6 a3 a4 t2 t4 t5 a7 : Word) : List Word :=
  let s0 := s0 + t6
  let s2 := s2 + t0
  let s3 := s3 + t1
  let s1 := s1 + t3
  let t2 := t2 ^^^ s0
  let t4 := t4 ^^^ s2
  let t5 := t5 ^^^ s3
  let a7 := a7 ^^^ s1
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t2) >>> 16#64))
  let t2 := t2 <<< 16#64
  let t2 := t2 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t4) >>> 16#64))
  let t4 := t4 <<< 16#64
  let t4 := t4 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t5) >>> 16#64))
  let t5 := t5 <<< 16#64
  let t5 := t5 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 a7) >>> 16#64))
  let a7 := a7 <<< 16#64
  let a7 := a7 ||| s4
  let a5 := a5 + t2
  let a6 := a6 + t4
  let a3 := a3 + t5
  let a4 := a4 + a7
  let t6 := a5 ^^^ t6
  let t0 := a6 ^^^ t0
  let t1 := a3 ^^^ t1
  let t3 := a4 ^^^ t3
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t6) >>> 20#64))
  let t6 := t6 <<< 12#64
  let t6 := t6 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t0) >>> 20#64))
  let t0 := t0 <<< 12#64
  let t0 := t0 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t1) >>> 20#64))
  let t1 := t1 <<< 12#64
  let t1 := t1 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t3) >>> 20#64))
  let t3 := t3 <<< 12#64
  let t3 := t3 ||| s4
  let s0 := t6 + s0
  let s2 := t0 + s2
  let s3 := t1 + s3
  let s1 := t3 + s1
  let t2 := s0 ^^^ t2
  let t4 := s2 ^^^ t4
  let t5 := s3 ^^^ t5
  let a7 := s1 ^^^ a7
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t2) >>> 24#64))
  let t2 := t2 <<< 8#64
  let t2 := t2 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t4) >>> 24#64))
  let t4 := t4 <<< 8#64
  let t4 := t4 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t5) >>> 24#64))
  let t5 := t5 <<< 8#64
  let t5 := t5 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 a7) >>> 24#64))
  let a7 := a7 <<< 8#64
  let a7 := a7 ||| s4
  let a5 := t2 + a5
  let a6 := t4 + a6
  let a3 := t5 + a3
  let a4 := a7 + a4
  let t6 := a5 ^^^ t6
  let t0 := a6 ^^^ t0
  let t1 := a3 ^^^ t1
  let t3 := a4 ^^^ t3
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t6) >>> 25#64))
  let t6 := t6 <<< 7#64
  let t6 := t6 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t0) >>> 25#64))
  let t0 := t0 <<< 7#64
  let t0 := t0 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t1) >>> 25#64))
  let t1 := t1 <<< 7#64
  let t1 := t1 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t3) >>> 25#64))
  let t3 := t3 <<< 7#64
  let t3 := t3 ||| s4
  [s0, s2, s3, s1, t6, t0, t1, t3, a5, a6, a3, a4, t2, t4, t5, a7]

/-- What the second half of a round of the loop computes, instruction by instruction. -/
def diagsW (s0 s2 s3 s1 t6 t0 t1 t3 a5 a6 a3 a4 t2 t4 t5 a7 : Word) : List Word :=
  let s0 := t0 + s0
  let s2 := t1 + s2
  let s3 := t3 + s3
  let s1 := s1 + t6
  let a7 := a7 ^^^ s0
  let t2 := s2 ^^^ t2
  let t4 := s3 ^^^ t4
  let t5 := s1 ^^^ t5
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 a7) >>> 16#64))
  let a7 := a7 <<< 16#64
  let a7 := a7 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t2) >>> 16#64))
  let t2 := t2 <<< 16#64
  let t2 := t2 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t4) >>> 16#64))
  let t4 := t4 <<< 16#64
  let t4 := t4 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t5) >>> 16#64))
  let t5 := t5 <<< 16#64
  let t5 := t5 ||| s4
  let a3 := a7 + a3
  let a4 := a4 + t2
  let a5 := t4 + a5
  let a6 := t5 + a6
  let t0 := a3 ^^^ t0
  let t1 := a4 ^^^ t1
  let t3 := a5 ^^^ t3
  let t6 := a6 ^^^ t6
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t0) >>> 20#64))
  let t0 := t0 <<< 12#64
  let t0 := t0 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t1) >>> 20#64))
  let t1 := t1 <<< 12#64
  let t1 := t1 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t3) >>> 20#64))
  let t3 := t3 <<< 12#64
  let t3 := t3 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t6) >>> 20#64))
  let t6 := t6 <<< 12#64
  let t6 := t6 ||| s4
  let s0 := t0 + s0
  let s2 := t1 + s2
  let s3 := t3 + s3
  let s1 := t6 + s1
  let a7 := s0 ^^^ a7
  let t2 := s2 ^^^ t2
  let t4 := s3 ^^^ t4
  let t5 := s1 ^^^ t5
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 a7) >>> 24#64))
  let a7 := a7 <<< 8#64
  let a7 := a7 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t2) >>> 24#64))
  let t2 := t2 <<< 8#64
  let t2 := t2 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t4) >>> 24#64))
  let t4 := t4 <<< 8#64
  let t4 := t4 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t5) >>> 24#64))
  let t5 := t5 <<< 8#64
  let t5 := t5 ||| s4
  let a3 := a7 + a3
  let a4 := t2 + a4
  let a5 := t4 + a5
  let a6 := t5 + a6
  let t0 := a3 ^^^ t0
  let t1 := a4 ^^^ t1
  let t3 := a5 ^^^ t3
  let t6 := a6 ^^^ t6
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t0) >>> 25#64))
  let t0 := t0 <<< 7#64
  let t0 := t0 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t1) >>> 25#64))
  let t1 := t1 <<< 7#64
  let t1 := t1 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t3) >>> 25#64))
  let t3 := t3 <<< 7#64
  let t3 := t3 ||| s4
  let s4 := BitVec.signExtend 64 (BitVec.setWidth 32
    (BitVec.setWidth 64 (BitVec.setWidth 32 t6) >>> 25#64))
  let t6 := t6 <<< 7#64
  let t6 := t6 ||| s4
  [s0, s2, s3, s1, t6, t0, t1, t3, a5, a6, a3, a4, t2, t4, t5, a7]

/-- The first half of a round, on a state as a list. -/
def colsL (vs : List Word) : List Word :=
  colsW (vs.getD 0 0) (vs.getD 1 0) (vs.getD 2 0) (vs.getD 3 0) (vs.getD 4 0) (vs.getD 5 0)
    (vs.getD 6 0) (vs.getD 7 0) (vs.getD 8 0) (vs.getD 9 0) (vs.getD 10 0) (vs.getD 11 0)
    (vs.getD 12 0) (vs.getD 13 0) (vs.getD 14 0) (vs.getD 15 0)

/-- The second half of a round, on a state as a list. -/
def diagsL (vs : List Word) : List Word :=
  diagsW (vs.getD 0 0) (vs.getD 1 0) (vs.getD 2 0) (vs.getD 3 0) (vs.getD 4 0) (vs.getD 5 0)
    (vs.getD 6 0) (vs.getD 7 0) (vs.getD 8 0) (vs.getD 9 0) (vs.getD 10 0) (vs.getD 11 0)
    (vs.getD 12 0) (vs.getD 13 0) (vs.getD 14 0) (vs.getD 15 0)

/-- A round of the loop, on the registers as they are. -/
def innerW (vs : List Word) : List Word := diagsL (colsL vs)

/-- `innerW`, `n` times. -/
def innerNW : Nat → List Word → List Word
  | 0, vs => vs
  | n + 1, vs => innerNW n (innerW vs)

theorem length_innerW (vs : List Word) : (innerW vs).length = 16 := rfl

theorem length_innerNW (n : Nat) (vs : List Word) (h : vs.length = 16) :
    (innerNW n vs).length = 16 := by
  induction n generalizing vs with
  | zero => exact h
  | succ n ih => exact ih _ (length_innerW vs)

/-! ## The low halves -/

/-- A word of the low halves of a state is the low half of the word of the state. -/
theorem getD_map_low (vs : List Word) (i : Nat) :
    (vs.map (BitVec.setWidth 32)).getD i 0 = BitVec.setWidth 32 (vs.getD i 0) := by
  simp only [List.getD_eq_getElem?_getD, List.getElem?_map]
  cases vs[i]? <;> simp

/-- Name the sixteen words of a state. -/
local macro "name_state " s:term : tactic =>
  `(tactic| generalize List.getD $s 0 0 = a0, List.getD $s 1 0 = a1, List.getD $s 2 0 = a2,
      List.getD $s 3 0 = a3, List.getD $s 4 0 = a4, List.getD $s 5 0 = a5,
      List.getD $s 6 0 = a6, List.getD $s 7 0 = a7, List.getD $s 8 0 = a8,
      List.getD $s 9 0 = a9, List.getD $s 10 0 = a10, List.getD $s 11 0 = a11,
      List.getD $s 12 0 = a12, List.getD $s 13 0 = a13, List.getD $s 14 0 = a14,
      List.getD $s 15 0 = a15)

/-- The low halves of the first half of a round are the quarter rounds on the columns of the
low halves. -/
theorem low_colsL (vs : List Word) :
    (colsL vs).map (BitVec.setWidth 32) = columns (vs.map (BitVec.setWidth 32)) := by
  simp only [colsL, colsW, columns, quarter, getD_map_low, List.map_cons, List.map_nil,
    List.cons.injEq, and_true]
  name_state vs
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_auto

/-- The low halves of the second half of a round are the quarter rounds on the diagonals of
the low halves. -/
theorem low_diagsL (vs : List Word) :
    (diagsL vs).map (BitVec.setWidth 32) = diagonals (vs.map (BitVec.setWidth 32)) := by
  simp only [diagsL, diagsW, diagonals, quarter, getD_map_low, List.map_cons, List.map_nil,
    List.cons.injEq, and_true]
  name_state vs
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_auto

/-- The low halves of a round of the loop are a double round of the low halves. -/
theorem low_innerW (vs : List Word) (h : vs.length = 16) :
    (innerW vs).map (BitVec.setWidth 32) = inner (vs.map (BitVec.setWidth 32)) := by
  rw [inner_eq _ (by rw [List.length_map, h]), innerW, low_diagsL, low_colsL]

/-- The low halves of `n` rounds of the loop are `n` double rounds of the low halves. -/
theorem low_innerNW (n : Nat) (vs : List Word) (h : vs.length = 16) :
    (innerNW n vs).map (BitVec.setWidth 32) = innerN n (vs.map (BitVec.setWidth 32)) := by
  induction n generalizing vs with
  | zero => rfl
  | succ n ih => rw [innerNW, ih _ (length_innerW vs), low_innerW vs h, innerN]

/-! ## A round of the loop -/

/-- The low half of the count of rounds, one less, as `addiw` leaves it. -/
theorem sdec (k : W32) :
    BitVec.signExtend 64 (BitVec.setWidth 32
      (BitVec.signExtend 64 k + 18446744073709551615#64)) = BitVec.signExtend 64 (k - 1) := by
  bv_decide

/-- The first half of a round of the loop: `colsL` of the registers of the state, and the
count of rounds, in `a2`, one less. -/
theorem columns_spec (vs : List Word) (k : W32) (t20 : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x100f0#64,
        .reg s0 (vs.getD 0 0), .reg s2 (vs.getD 1 0), .reg s3 (vs.getD 2 0), .reg s1 (vs.getD 3 0),
        .reg t6 (vs.getD 4 0), .reg t0 (vs.getD 5 0), .reg t1 (vs.getD 6 0), .reg t3 (vs.getD 7 0),
        .reg a5 (vs.getD 8 0), .reg a6 (vs.getD 9 0), .reg a3 (vs.getD 10 0),
        .reg a4 (vs.getD 11 0), .reg t2 (vs.getD 12 0), .reg t4 (vs.getD 13 0),
        .reg t5 (vs.getD 14 0), .reg a7 (vs.getD 15 0),
        .reg a2 (BitVec.signExtend 64 k), .reg s4 t20])
      (Atoms.interp [.pc 0x10234#64,
        .reg s0 ((colsL vs).getD 0 0), .reg s2 ((colsL vs).getD 1 0),
        .reg s3 ((colsL vs).getD 2 0), .reg s1 ((colsL vs).getD 3 0),
        .reg t6 ((colsL vs).getD 4 0), .reg t0 ((colsL vs).getD 5 0),
        .reg t1 ((colsL vs).getD 6 0), .reg t3 ((colsL vs).getD 7 0),
        .reg a5 ((colsL vs).getD 8 0), .reg a6 ((colsL vs).getD 9 0),
        .reg a3 ((colsL vs).getD 10 0), .reg a4 ((colsL vs).getD 11 0),
        .reg t2 ((colsL vs).getD 12 0), .reg t4 ((colsL vs).getD 13 0),
        .reg t5 ((colsL vs).getD 14 0), .reg a7 ((colsL vs).getD 15 0),
        .reg a2 (BitVec.signExtend 64 (k - 1)), .prop (regAny s4)]) := by
  simp only [colsL]
  name_state vs
  simp only [colsW, List.getD_cons_zero, List.getD_cons_succ]
  iterate 81 braid_sym_step
  simp only [sdec]
  braid_forget 20
  braid_done

/-- The second half of a round of the loop: `diagsL` of the registers of the state. -/
theorem diagonals_spec (vs : List Word) (t20 : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x10234#64,
        .reg s0 (vs.getD 0 0), .reg s2 (vs.getD 1 0), .reg s3 (vs.getD 2 0), .reg s1 (vs.getD 3 0),
        .reg t6 (vs.getD 4 0), .reg t0 (vs.getD 5 0), .reg t1 (vs.getD 6 0), .reg t3 (vs.getD 7 0),
        .reg a5 (vs.getD 8 0), .reg a6 (vs.getD 9 0), .reg a3 (vs.getD 10 0),
        .reg a4 (vs.getD 11 0), .reg t2 (vs.getD 12 0), .reg t4 (vs.getD 13 0),
        .reg t5 (vs.getD 14 0), .reg a7 (vs.getD 15 0),
        .reg s4 t20])
      (Atoms.interp [.pc 0x10374#64,
        .reg s0 ((diagsL vs).getD 0 0), .reg s2 ((diagsL vs).getD 1 0),
        .reg s3 ((diagsL vs).getD 2 0), .reg s1 ((diagsL vs).getD 3 0),
        .reg t6 ((diagsL vs).getD 4 0), .reg t0 ((diagsL vs).getD 5 0),
        .reg t1 ((diagsL vs).getD 6 0), .reg t3 ((diagsL vs).getD 7 0),
        .reg a5 ((diagsL vs).getD 8 0), .reg a6 ((diagsL vs).getD 9 0),
        .reg a3 ((diagsL vs).getD 10 0), .reg a4 ((diagsL vs).getD 11 0),
        .reg t2 ((diagsL vs).getD 12 0), .reg t4 ((diagsL vs).getD 13 0),
        .reg t5 ((diagsL vs).getD 14 0), .reg a7 ((diagsL vs).getD 15 0),
        .prop (regAny s4)]) := by
  simp only [diagsL]
  name_state vs
  simp only [diagsW, List.getD_cons_zero, List.getD_cons_succ]
  iterate 80 braid_sym_step
  braid_forget 20
  braid_done

/-- **A round of the loop** is `innerW` of the registers of the state, with the count of
rounds, in `a2`, one less. -/
theorem double_round_spec (vs : List Word) (k : W32) (t20 : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x100f0#64,
        .reg s0 (vs.getD 0 0), .reg s2 (vs.getD 1 0), .reg s3 (vs.getD 2 0), .reg s1 (vs.getD 3 0),
        .reg t6 (vs.getD 4 0), .reg t0 (vs.getD 5 0), .reg t1 (vs.getD 6 0), .reg t3 (vs.getD 7 0),
        .reg a5 (vs.getD 8 0), .reg a6 (vs.getD 9 0), .reg a3 (vs.getD 10 0),
        .reg a4 (vs.getD 11 0), .reg t2 (vs.getD 12 0), .reg t4 (vs.getD 13 0),
        .reg t5 (vs.getD 14 0), .reg a7 (vs.getD 15 0),
        .reg a2 (BitVec.signExtend 64 k), .reg s4 t20])
      (Atoms.interp [.pc 0x10374#64,
        .reg s0 ((innerW vs).getD 0 0), .reg s2 ((innerW vs).getD 1 0),
        .reg s3 ((innerW vs).getD 2 0), .reg s1 ((innerW vs).getD 3 0),
        .reg t6 ((innerW vs).getD 4 0), .reg t0 ((innerW vs).getD 5 0),
        .reg t1 ((innerW vs).getD 6 0), .reg t3 ((innerW vs).getD 7 0),
        .reg a5 ((innerW vs).getD 8 0), .reg a6 ((innerW vs).getD 9 0),
        .reg a3 ((innerW vs).getD 10 0), .reg a4 ((innerW vs).getD 11 0),
        .reg t2 ((innerW vs).getD 12 0), .reg t4 ((innerW vs).getD 13 0),
        .reg t5 ((innerW vs).getD 14 0), .reg a7 ((innerW vs).getD 15 0),
        .reg a2 (BitVec.signExtend 64 (k - 1)), .prop (regAny s4)]) := by
  rw [innerW]
  braid_call columns_spec vs k t20
  braid_name_reg 20
  braid_call diagonals_spec (colsL vs) _
  braid_done

/-! ## The loop -/

/-- **The loop of `chacha20_block`**, with `n + 1` rounds left: that many rounds on the
registers of the state. Proved by induction on `n`, with this specification as the
invariant: a round is `double_round_spec`, whatever the registers hold, so the proof does
not run the code again. -/
theorem rounds_spec : ∀ (n : Nat) (vs : List Word) (k : W32) (t20 : Word),
    k = BitVec.ofNat 32 (n + 1) → n + 1 < 2 ^ 32 →
    Triple chacha20_block.program
      (Atoms.interp [.pc 0x100f0#64,
        .reg s0 (vs.getD 0 0), .reg s2 (vs.getD 1 0), .reg s3 (vs.getD 2 0), .reg s1 (vs.getD 3 0),
        .reg t6 (vs.getD 4 0), .reg t0 (vs.getD 5 0), .reg t1 (vs.getD 6 0), .reg t3 (vs.getD 7 0),
        .reg a5 (vs.getD 8 0), .reg a6 (vs.getD 9 0), .reg a3 (vs.getD 10 0),
        .reg a4 (vs.getD 11 0), .reg t2 (vs.getD 12 0), .reg t4 (vs.getD 13 0),
        .reg t5 (vs.getD 14 0), .reg a7 (vs.getD 15 0),
        .reg a2 (BitVec.signExtend 64 k), .reg s4 t20])
      (Atoms.interp [.pc 0x10378#64,
        .reg s0 ((innerNW (n + 1) vs).getD 0 0), .reg s2 ((innerNW (n + 1) vs).getD 1 0),
        .reg s3 ((innerNW (n + 1) vs).getD 2 0), .reg s1 ((innerNW (n + 1) vs).getD 3 0),
        .reg t6 ((innerNW (n + 1) vs).getD 4 0), .reg t0 ((innerNW (n + 1) vs).getD 5 0),
        .reg t1 ((innerNW (n + 1) vs).getD 6 0), .reg t3 ((innerNW (n + 1) vs).getD 7 0),
        .reg a5 ((innerNW (n + 1) vs).getD 8 0), .reg a6 ((innerNW (n + 1) vs).getD 9 0),
        .reg a3 ((innerNW (n + 1) vs).getD 10 0), .reg a4 ((innerNW (n + 1) vs).getD 11 0),
        .reg t2 ((innerNW (n + 1) vs).getD 12 0), .reg t4 ((innerNW (n + 1) vs).getD 13 0),
        .reg t5 ((innerNW (n + 1) vs).getD 14 0), .reg a7 ((innerNW (n + 1) vs).getD 15 0),
        .reg a2 0#64, .prop (regAny s4)]) := by
  intro n
  induction n with
  | zero =>
    intro vs k t20 hk _
    obtain rfl : k = 1#32 := hk
    rw [show innerNW (0 + 1) vs = innerW vs from rfl]
    braid_call double_round_spec vs 1#32 t20
    braid_sym_step
    · exact absurd (by decide) hbr
    · rw [hbr]
      braid_done
  | succ n ih =>
    intro vs k t20 hk hn
    rw [show innerNW (n + 1 + 1) vs = innerNW (n + 1) (innerW vs) from rfl]
    braid_call double_round_spec vs k t20
    braid_sym_step
    · braid_name_reg 20
      braid_call ih (innerW vs) (k - 1) _ (by rw [hk]; bv_omega) (by omega)
      braid_done
    · exfalso
      have : k ≠ 1#32 := by rw [hk]; bv_omega
      exact this (by bv_auto)

end Examples.ChaCha20.RiscV
