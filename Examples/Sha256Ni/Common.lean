/-
  Examples.Sha256Ni.Common

  What the proofs of `sha256_ni.c` share between instruction sets: the compression function
  of SHA-256 (`Examples.Spec.Sha256`) in the form that code written with the processor's SHA
  instructions computes it in. Nothing here mentions a machine.

  The instructions take four rounds as one step. A step needs of the schedule and of the
  table of round constants only four sums `k + w`, one for each round (`rounds4`), and the
  schedule is kept as its last sixteen words, which a step moves on by four (`slide4`). The
  compression function is then twelve steps that also move the window (`steps`), and four
  steps on the sixteen words that are left (`rounds16At`). On x86-64 a step is two
  `sha256rnds2`, of two rounds each, and the four new words are `sha256msg1`, an addition and
  `sha256msg2`; on AArch64 a step is `sha256h` with `sha256h2`, and the four new words are
  `sha256su0` with `sha256su1`. Both are these definitions.

  The code loads and stores sixteen bytes at a time, as two 64-bit words, each of two 32-bit
  lanes (`ChaCha20Vec.pack`). An array of 32-bit words in memory is then an array of 64-bit
  cells (`ChaCha20Vec.packs`), and the lemmas of the second half open such an array.

  ## Main definitions

  * `roundS`, `rounds4`: one round given the sum of its constant and its word of the
    schedule, and four rounds from four sums
  * `rounds4At`: four rounds from round `t`, with four words of a window of the schedule
  * `slide`, `slide4`: the window of the schedule moved on by one word, and by four
  * `steps`: steps of four rounds, each moving the window on by four words
  * `rounds16At`: four steps on a window that does not move

  ## Main results

  * `roundKW_eq_roundS`: a round needs only the sum of its constant and its word
  * `slide4_eq`: the four new words of the schedule, written out
  * `sig0_pack`, `sig1_pack`: the mixing of the two lanes of a word, written with shifts
    under masks as both lowerings write it, is `σ₀` and `σ₁` in each lane
  * `rounds_eq_steps`: the 64 rounds are twelve steps and four more on the last window
  * `compress_eq_steps`: the compression function in those terms
  * `cells_w32_packs`, `cells4`, `cells8x8`: arrays of 32-bit words as 64-bit cells, read-only
    or not
  * `cells_pair_at`, `cells_quad_at`: an array of 64-bit cells opened at two cells that
    follow one another, which hold four words of a table read sixteen bytes at a time
-/

module

public import Examples.Sha256.Common
public import Examples.ChaCha20Vec.Common
import Iris.BI.DerivedLaws
import Std.Tactic.BVDecide
import Braid.BV

@[expose] public section

namespace Examples.Sha256Ni

open Braid Examples.Sha256 Examples.ChaCha20Vec

/-! ## Four rounds -/

/-- One round of the compression function, given the sum `s` of the round constant and the
word of the schedule. -/
def roundS (s : W32) (v : Vars) : Vars :=
  let T₁ := v.h + bigSigma1 v.e + Ch v.e v.f v.g + s
  let T₂ := bigSigma0 v.a + Maj v.a v.b v.c
  { h := v.g, g := v.f, f := v.e, e := v.d + T₁, d := v.c, c := v.b, b := v.a, a := T₁ + T₂ }

/-- A round needs only the sum of its constant and its word of the schedule. -/
theorem roundKW_eq_roundS (k w : W32) (v : Vars) : roundKW k w v = roundS (k + w) v := by
  simp only [roundKW, roundS, BitVec.add_assoc]

/-- Four rounds, given the four sums of a round constant and a word of the schedule. -/
def rounds4 (s0 s1 s2 s3 : W32) (v : Vars) : Vars :=
  roundS s3 (roundS s2 (roundS s1 (roundS s0 v)))

/-- Rounds `t` to `t + 3`, with the words `j` to `j + 3` of the list `ws` as their words of
the schedule. -/
def rounds4At (t j : Nat) (ws : List W32) (v : Vars) : Vars :=
  rounds4 (K.getD t 0 + ws.getD j 0) (K.getD (t + 1) 0 + ws.getD (j + 1) 0)
    (K.getD (t + 2) 0 + ws.getD (j + 2) 0) (K.getD (t + 3) 0 + ws.getD (j + 3) 0) v

/-- Rounds `t` to `t + 15`, with the sixteen words of `ws` as their words of the schedule. -/
def rounds16At (t : Nat) (ws : List W32) (v : Vars) : Vars :=
  rounds4At (t + 12) 12 ws (rounds4At (t + 8) 8 ws (rounds4At (t + 4) 4 ws (rounds4At t 0 ws v)))

/-! ## The schedule, four words at a time -/

/-- A window of sixteen words of the schedule, moved on by one word. -/
def slide (win : List W32) : List W32 := win.drop 1 ++ [nextWord win]

/-- A window of sixteen words of the schedule, moved on by four words. -/
def slide4 (win : List W32) : List W32 := slide (slide (slide (slide win)))

/-- **Four new words of the schedule from the sixteen before them**: the first two from
words of the window alone, and the last two from the first two as well. -/
theorem slide4_eq (w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 : W32) :
    slide4 [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15] =
      [w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15,
        smallSigma1 w14 + w9 + smallSigma0 w1 + w0,
        smallSigma1 w15 + w10 + smallSigma0 w2 + w1,
        smallSigma1 (smallSigma1 w14 + w9 + smallSigma0 w1 + w0) + w11 + smallSigma0 w3 + w2,
        smallSigma1 (smallSigma1 w15 + w10 + smallSigma0 w2 + w1) + w12 + smallSigma0 w4 +
          w3] := rfl

theorem slide4_length (win : List W32) (h : win.length = 16) : (slide4 win).length = 16 := by
  obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
    eq_of_length_16 h
  rfl

/-- A window extended by four words more is its first four words, and the window moved on by
four, extended. -/
theorem extend_add4 (n : Nat) (w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 : W32) :
    extend (n + 4) [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15] =
      [w0, w1, w2, w3] ++ extend n
        (slide4 [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]) := rfl

/-! ## The compression function, four rounds at a time -/

/-- `n` steps of four rounds from round `t`, each on the first four words of the window,
which it then moves on by four: the window and the working variables after them. -/
def steps : Nat → Nat → List W32 → Vars → List W32 × Vars
  | _, 0, win, v => (win, v)
  | t, n + 1, win, v => steps (t + 4) n (slide4 win) (rounds4At t 0 win v)

theorem steps_zero (t : Nat) (win : List W32) (v : Vars) : steps t 0 win v = (win, v) := rfl

theorem steps_succ (t n : Nat) (win : List W32) (v : Vars) :
    steps t (n + 1) win v = steps (t + 4) n (slide4 win) (rounds4At t 0 win v) := rfl

/-- The window after any number of steps is sixteen words. -/
theorem steps_length : ∀ (n t : Nat) (win : List W32) (v : Vars), win.length = 16 →
    (steps t n win v).1.length = 16
  | 0, _, _, _, h => h
  | n + 1, t, win, _, h => steps_length n (t + 4) (slide4 win) _ (slide4_length win h)

theorem roundsFrom_add (W : List W32) : ∀ (a b t : Nat) (v : Vars),
    roundsFrom W t (a + b) v = roundsFrom W (t + a) b (roundsFrom W t a v)
  | 0, _, _, _ => by simp only [Nat.zero_add, Nat.add_zero, roundsFrom]
  | a + 1, b, t, v => by
    rw [Nat.add_right_comm, roundsFrom_succ, roundsFrom_succ, roundsFrom_add W a b (t + 1),
      Nat.add_assoc, Nat.add_comm 1 a]

/-- Four rounds of the specification are `rounds4` of the four sums. -/
theorem roundsFrom_four (W : List W32) (t : Nat) (v : Vars) :
    roundsFrom W t 4 v =
      rounds4 (K.getD t 0 + W.getD t 0) (K.getD (t + 1) 0 + W.getD (t + 1) 0)
        (K.getD (t + 2) 0 + W.getD (t + 2) 0) (K.getD (t + 3) 0 + W.getD (t + 3) 0) v := by
  simp only [roundsFrom, round_eq_roundKW, roundKW_eq_roundS, rounds4, Nat.add_assoc,
    Nat.reduceAdd]

/-- A word of a list that follows another. -/
theorem getD_append_length (pre l : List W32) (j : Nat) :
    (pre ++ l).getD (pre.length + j) 0 = l.getD j 0 := by
  rw [List.getD_eq_getElem?_getD, List.getD_eq_getElem?_getD,
    List.getElem?_append_right (Nat.le_add_right _ _), Nat.add_sub_cancel_left]

/-- Four rounds on a schedule of which the words from the first of them on are known. -/
theorem roundsFrom_four_at (pre l : List W32) (j : Nat) (v : Vars) :
    roundsFrom (pre ++ l) (pre.length + j) 4 v = rounds4At (pre.length + j) j l v := by
  rw [roundsFrom_four, rounds4At, Nat.add_assoc, Nat.add_assoc, Nat.add_assoc,
    getD_append_length, getD_append_length, getD_append_length, getD_append_length]

/-- Sixteen rounds on a schedule of which the sixteen words from the first of them on are
known. -/
theorem roundsFrom_sixteen (pre win : List W32) (v : Vars) :
    roundsFrom (pre ++ win) pre.length 16 v = rounds16At pre.length win v := by
  have h := roundsFrom_four_at pre win
  rw [show 16 = 4 + (4 + (4 + 4)) from rfl, roundsFrom_add, roundsFrom_add, roundsFrom_add,
    Nat.add_assoc, Nat.add_assoc, rounds16At]
  have h0 := h 0
  rw [Nat.add_zero] at h0
  rw [h0, h 4, h (4 + 4), h (4 + (4 + 4))]

/-- The rounds from the end of a prefix of the schedule on, with `4 * n` words of it still
to be computed from the window, are `n` steps and sixteen rounds on the window they leave. -/
theorem roundsFrom_steps : ∀ (n : Nat) (pre win : List W32) (v : Vars), win.length = 16 →
    roundsFrom (pre ++ extend (4 * n) win) pre.length (4 * n + 16) v =
      rounds16At (pre.length + 4 * n) (steps pre.length n win v).1 (steps pre.length n win v).2
  | 0, pre, win, v, _ => roundsFrom_sixteen pre win v
  | n + 1, pre, win, v, h => by
    obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
      eq_of_length_16 h
    have ih := roundsFrom_steps n (pre ++ [w0, w1, w2, w3])
      (slide4 [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15])
      (rounds4At pre.length 0 [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14,
        w15] v) (slide4_length _ rfl)
    have hl : (pre ++ [w0, w1, w2, w3]).length = pre.length + 4 := by simp
    rw [hl, List.append_assoc] at ih
    have h4 := roundsFrom_four_at pre ([w0, w1, w2, w3] ++ extend (4 * n)
      (slide4 [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15])) 0 v
    rw [Nat.add_zero] at h4
    rw [show 4 * (n + 1) = 4 * n + 4 from rfl, extend_add4,
      show 4 * n + 4 + 16 = 4 + (4 * n + 16) by omega, roundsFrom_add, h4, steps_succ,
      show pre.length + (4 * n + 4) = pre.length + 4 + 4 * n by omega]
    exact ih

/-- **The 64 rounds, four at a time**: twelve steps that move the window of the schedule on,
from the block, and four on the sixteen words they leave. -/
theorem rounds_eq_steps (M : List W32) (h : M.length = 16) (v : Vars) :
    rounds (schedule M) v 64 = rounds16At 48 (steps 0 12 M v).1 (steps 0 12 M v).2 := by
  rw [rounds_eq_roundsFrom, schedule_eq_extend M h]
  exact roundsFrom_steps 12 [] M v h

/-- **The compression function, four rounds at a time.** -/
theorem compress_eq_steps (h0 h1 h2 h3 h4 h5 h6 h7 : W32) (M : List W32) (h : M.length = 16) :
    compress [h0, h1, h2, h3, h4, h5, h6, h7] M =
      [(rounds16At 48 (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).1
          (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).2).a + h0,
       (rounds16At 48 (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).1
          (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).2).b + h1,
       (rounds16At 48 (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).1
          (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).2).c + h2,
       (rounds16At 48 (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).1
          (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).2).d + h3,
       (rounds16At 48 (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).1
          (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).2).e + h4,
       (rounds16At 48 (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).1
          (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).2).f + h5,
       (rounds16At 48 (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).1
          (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).2).g + h6,
       (rounds16At 48 (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).1
          (steps 0 12 M ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩).2).h + h7] := by
  rw [compress_eq, rounds_eq_steps M h]

/-! ## Arrays of 32-bit words, sixteen bytes at a time -/

/-- A cell of `k + m` bytes is its low `k` bytes beside its high `m`, read-only or not. -/
theorem memIs_add (w : Bool) : ∀ (k m : Nat) (a v : Word), k + m ≤ 8 →
    memIs a (k + m) v w =
      iprop(memIs a k v w ∗ memIs (a + BitVec.ofNat 64 k) m (v >>> (8 * k)) w)
  | 0, m, a, v, _ => by
    have e : a + BitVec.ofNat 64 0 = a := by simp
    rw [memIs_zero, Nat.zero_add, e, Nat.mul_zero, BitVec.ushiftRight_zero]
    exact SProp.ext Iris.BI.emp_sep.symm
  | k + 1, m, a, v, h => by
    have e : k + 1 + m = (k + m) + 1 := by omega
    have ea : a + 1#64 + BitVec.ofNat 64 k = a + BitVec.ofNat 64 (k + 1) := by
      rw [BitVec.add_assoc, BitVec.add_comm 1#64, ← BitVec.ofNat_add]
    have ev : v >>> 8 >>> (8 * k) = v >>> (8 * (k + 1)) := by
      rw [← BitVec.shiftRight_add, Nat.mul_succ, Nat.add_comm]
    rw [e, memIs_succ a v (k + m) w (by omega), memIs_add w k m (a + 1#64) (v >>> 8) (by omega),
      memIs_succ a v k w (by omega), ea, ev]
    exact SProp.ext Iris.BI.sep_assoc.symm

/-- Two 32-bit cells side by side are one 64-bit cell that holds the two lanes, read-only or
not. -/
theorem memIs_pack_any (w : Bool) (p : Word) (a b : W32) :
    iprop(memIs p 4 (a.setWidth 64) w ∗ memIs (p + 4#64) 4 (b.setWidth 64) w) =
      memIs p 8 (pack a b) w := by
  have e1 : memIs p 4 (pack a b) w = memIs p 4 (a.setWidth 64) w := by
    have ea : ((pack a b).setWidth 32).setWidth 64 = a.setWidth 64 := by
      simp only [pack]
      bv_auto
    funext h
    simp only [memIs]
    rw [Heap.bytes_setWidth32 p (pack a b) w, ea]
  have e2 : pack a b >>> (8 * 4) = b.setWidth 64 := by
    simp only [pack, Nat.reduceMul]
    bv_auto
  rw [show (8 : Nat) = 4 + 4 from rfl, memIs_add w 4 4 p (pack a b) (by omega), e1, e2]

/-- **An array of 32-bit words is an array of 64-bit cells**, each holding two of them,
read-only or not: what code that loads sixteen bytes at a time needs of an array. -/
theorem cells_w32_packs (w : Bool) : ∀ (n : Nat) (p : Word) (s : List W32), s.length = 2 * n →
    cellsAt 4 w p (w32s s) = cellsAt 8 w p (packs s)
  | 0, _, [], _ => rfl
  | n + 1, p, x :: y :: s, h => by
    have e : p + BitVec.ofNat 64 4 + BitVec.ofNat 64 4 = p + BitVec.ofNat 64 8 := by
      rw [BitVec.add_assoc]; rfl
    have ih := cells_w32_packs w n (p + BitVec.ofNat 64 8) s (by simp at h; omega)
    rw [w32s] at ih
    simp only [w32s, List.map_cons, cellsAt, packs, e]
    rw [ih, ← memIs_pack_any]
    exact SProp.ext Iris.BI.sep_assoc.symm
  | 0, _, _ :: _, h => by simp at h
  | _ + 1, _, [], h => by simp at h
  | _ + 1, _, [_], h => by simp at h; omega

/-- Four 64-bit cells, as memory atoms. -/
theorem cells4 (w : Bool) (p v0 v1 v2 v3 : Word) :
    (Atom.prop (cellsAt 8 w p [v0, v1, v2, v3])).interp =
      Atoms.interp [.mem p 8 v0 w, .mem (p + 8#64) 8 v1 w, .mem (p + 16#64) 8 v2 w,
        .mem (p + 24#64) 8 v3 w] := by
  rw [cells_eq_atoms]
  simp only [cellsAtoms, BitVec.add_assoc, BitVec.reduceAdd]

/-- Eight 64-bit cells, as memory atoms. -/
theorem cells8x8 (w : Bool) (p v0 v1 v2 v3 v4 v5 v6 v7 : Word) :
    (Atom.prop (cellsAt 8 w p [v0, v1, v2, v3, v4, v5, v6, v7])).interp =
      Atoms.interp [.mem p 8 v0 w, .mem (p + 8#64) 8 v1 w, .mem (p + 16#64) 8 v2 w,
        .mem (p + 24#64) 8 v3 w, .mem (p + 32#64) 8 v4 w, .mem (p + 40#64) 8 v5 w,
        .mem (p + 48#64) 8 v6 w, .mem (p + 56#64) 8 v7 w] := by
  rw [cells_eq_atoms]
  simp only [cellsAtoms, BitVec.add_assoc, BitVec.reduceAdd]

/-- A word of the 64-bit cells of an array of 32-bit words is two of its words. -/
theorem packs_getD : ∀ (s : List W32) (i : Nat), 2 * i + 1 < s.length →
    (packs s).getD i 0 = pack (s.getD (2 * i) 0) (s.getD (2 * i + 1) 0)
  | a :: b :: s, 0, _ => rfl
  | a :: b :: s, i + 1, h => by
    have ih := packs_getD s i (by simp only [List.length_cons] at h; omega)
    have e1 : 2 * (i + 1) = 2 * i + 1 + 1 := by omega
    simp only [packs, List.getD_cons_succ, ih, e1]
  | [], _, h => by simp at h
  | [_], _, h => by simp at h

/-- An array of 32-bit words is half as many 64-bit cells. -/
theorem packs_length : ∀ (s : List W32), (packs s).length = s.length / 2
  | [] => rfl
  | [_] => by simp [packs]
  | a :: b :: s => by
    simp only [packs, List.length_cons, packs_length s]
    omega

/-- **An array of 64-bit cells, opened at the cells `2 * i` and `2 * i + 1`**: the cells
before, the two cells as memory atoms at the addresses `a0` and `a1`, which are the offsets
`16 * i` and `16 * i + 8` written as the code computes them, and the cells after. -/
theorem cells_pair_at (w : Bool) (p a0 a1 : Word) (xs : List Word) (i : Nat)
    (hi : 2 * i + 1 < xs.length) (h0 : a0 = p + BitVec.ofNat 64 (16 * i))
    (h1 : a1 = p + BitVec.ofNat 64 (16 * i + 8)) :
    (Atom.prop (cellsAt 8 w p xs)).interp =
      Atoms.interp [.prop (cellsAt 8 w p (xs.take (2 * i))),
        .mem a0 8 (xs.getD (2 * i) 0) w, .mem a1 8 (xs.getD (2 * i + 1) 0) w,
        .prop (cellsAt 8 w (p + BitVec.ofNat 64 (16 * (i + 1))) (xs.drop (2 * i + 2)))] := by
  subst h0 h1
  have hd : xs.drop (2 * i + 1) = xs[2 * i + 1] :: xs.drop (2 * i + 2) :=
    List.drop_eq_getElem_cons hi
  have e0 : xs.getD (2 * i) 0 = xs[2 * i]'(by omega) := by
    simp [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem (show 2 * i < xs.length by omega)]
  have e1 : xs.getD (2 * i + 1) 0 = xs[2 * i + 1] := by
    simp [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hi]
  have a0 : 8 * (2 * i) = 16 * i := by omega
  have a1 : 8 * (2 * i + 1) = 16 * i + 8 := by omega
  have a2 : p + BitVec.ofNat 64 (16 * i + 8) + BitVec.ofNat 64 8 =
      p + BitVec.ofNat 64 (16 * (i + 1)) := by
    rw [BitVec.add_assoc, ← BitVec.ofNat_add]
    congr 2
  rw [cellsAt_index p xs (2 * i) (by omega), e0, e1]
  simp only [Atoms.interp_cons, Atoms.interp_nil, Atom.interp, hd, cellsAt, a0, a1, a2]
  exact SProp.ext ⟨Iris.BI.sep_mono_right (Iris.BI.sep_mono_right Iris.BI.sep_assoc.1),
    Iris.BI.sep_mono_right (Iris.BI.sep_mono_right Iris.BI.sep_assoc.2)⟩

/-- **An array of 32-bit words as 64-bit cells, opened at the words `4 * i` to `4 * i + 3`**:
the sixteen bytes that one load of a vector register reads, as two memory atoms at the
addresses `a0` and `a1`, with the cells before and the cells after. -/
theorem cells_quad_at (w : Bool) (p a0 a1 : Word) (s : List W32) (i : Nat)
    (hi : 4 * i + 3 < s.length) (h0 : a0 = p + BitVec.ofNat 64 (16 * i))
    (h1 : a1 = p + BitVec.ofNat 64 (16 * i + 8)) :
    (Atom.prop (cellsAt 8 w p (packs s))).interp =
      Atoms.interp [.prop (cellsAt 8 w p ((packs s).take (2 * i))),
        .mem a0 8 (pack (s.getD (4 * i) 0) (s.getD (4 * i + 1) 0)) w,
        .mem a1 8 (pack (s.getD (4 * i + 2) 0) (s.getD (4 * i + 3) 0)) w,
        .prop (cellsAt 8 w (p + BitVec.ofNat 64 (16 * (i + 1)))
          ((packs s).drop (2 * i + 2)))] := by
  have hl := packs_length s
  have e0 : 2 * (2 * i) = 4 * i := by omega
  have e1 : 2 * (2 * i + 1) = 4 * i + 2 := by omega
  have g0 := packs_getD s (2 * i) (by omega)
  have g1 := packs_getD s (2 * i + 1) (by omega)
  rw [e0] at g0
  rw [e1] at g1
  rw [cells_pair_at w p a0 a1 (packs s) i (by omega) h0 h1, g0, g1]

/-! ## The mixing of the schedule on two lanes -/

/-- The mixing of a schedule step that both lowerings write, rotations and a shift of the two
lanes of a word as shifts under masks, is `σ₀` in each lane. -/
theorem sig0_pack (a b : W32) :
    (pack a b >>> 7#64 &&& 0x01ffffff01ffffff#64 |||
          pack a b <<< 25#64 &&& 0xfe000000fe000000#64) ^^^
        (pack a b >>> 18#64 &&& 0x00003fff00003fff#64 |||
          pack a b <<< 14#64 &&& 0xffffc000ffffc000#64) ^^^
      pack a b >>> 3#64 &&& 0x1fffffff1fffffff#64 =
      pack (smallSigma0 a) (smallSigma0 b) := by
  simp only [pack, smallSigma0, ROTR, SHR]
  bv_auto

/-- The second mixing of a schedule step, written the same way, is `σ₁` in each lane. -/
theorem sig1_pack (a b : W32) :
    (pack a b >>> 17#64 &&& 0x00007fff00007fff#64 |||
          pack a b <<< 15#64 &&& 0xffff8000ffff8000#64) ^^^
        (pack a b >>> 19#64 &&& 0x00001fff00001fff#64 |||
          pack a b <<< 13#64 &&& 0xffffe000ffffe000#64) ^^^
      pack a b >>> 10#64 &&& 0x003fffff003fffff#64 =
      pack (smallSigma1 a) (smallSigma1 b) := by
  simp only [pack, smallSigma1, ROTR, SHR]
  bv_auto

end Examples.Sha256Ni
