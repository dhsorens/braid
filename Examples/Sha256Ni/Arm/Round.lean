/-
  Examples.Sha256Ni.Arm.Round

  The two loops of `sha256_compress_ni` of `sha256_ni.c` on AArch64. A turn of either is four
  rounds of SHA-256, as `sha256h` and `sha256h2`. The compiler keeps the working variables
  `a` to `d` in `v4` and `e` to `h` in `v3`, and `v19` (or `v16`, in the second loop) holds
  `a` to `d` as they were before `sha256h`, which `sha256h2` reads. At the head of the first
  loop the last sixteen words of the schedule are in `v16`, `v18`, `v17` and `v2`, four words
  each, oldest first; `x9` is sixteen times the number of turns taken, and `x8` the address
  of the table of round constants.

  A turn of the first loop (`step_spec`) adds four round constants to the oldest four words,
  runs four rounds, and computes four new words with `sha256su0` and `sha256su1`, moving the
  window on by four; it also leaves the first three rows of the new window in `v5`, `v7` and
  `v6`. A turn of the second (`tail_spec`) runs four rounds on the row in `v5` and moves
  `v7`, `v6` and `v2` down by one, without a new word. The blocks of the four SHA-256
  instructions are not run by the stepper: each is the triple of
  `Examples.Sha256Ni.Arm.Insts`, called, and what it leaves is read as words of the
  specification by `hash_pack` and `su_pack` of `Examples.Sha256Ni.Arm.Lanes`, so that no
  term outlives the instruction that built it. The first loop is an induction on the turns
  left (`loop_spec`), whose invariant is `Sha256Ni.steps`; the four turns of the second are
  called one after another in `Examples.Sha256Ni.Arm.Compress`.

  ## Main definitions

  * `abcdLo`, `abcdHi`, `efghLo`, `efghHi`: the words of the two vectors of working variables

  ## Main results

  * `block_100fc`, ..., `block_10140`: the blocks that are SHA-256 instructions
  * `step_spec`: a turn of the first loop
  * `loop_spec`: the first loop, from any turn to its end
  * `tail_spec`: a turn of the second loop
-/

module

public import Examples.Sha256Ni.Arm.Image
public import Examples.Sha256Ni.Arm.Insts
public import Examples.Sha256Ni.Arm.Lanes
public import Examples.ArmMachine
public import Examples.Sha256.RunTo

@[expose] public section

namespace Examples.Sha256Ni.Arm

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.Arm Lowering.Arm.Regs

/-! ## The working variables in two vector registers -/

/-- The low word of the vector of the working variables `a` to `d`: `a` and `b`. -/
def abcdLo (v : Vars) : Word := pack v.a v.b

/-- The high word of the vector of the working variables `a` to `d`: `c` and `d`. -/
def abcdHi (v : Vars) : Word := pack v.c v.d

/-- The low word of the vector of the working variables `e` to `h`: `e` and `f`. -/
def efghLo (v : Vars) : Word := pack v.e v.f

/-- The high word of the vector of the working variables `e` to `h`: `g` and `h`. -/
def efghHi (v : Vars) : Word := pack v.g v.h

/-! ## The blocks of the SHA-256 instructions -/

/-- The block at `0x100fc` is `sha256su0 v16, v5`. -/
theorem block_100fc : sha256_compress_ni.program 0x100fc#64 =
    some ⟨.get 0 96 :: .get 1 97 :: .get 2 74 :: (su0Words ++ [.set 96 200, .set 97 201]),
      .jump 0x10100#64⟩ := by rfl

/-- The block at `0x10100` is `sha256h q4, q3, v18`. -/
theorem block_10100 : sha256_compress_ni.program 0x10100#64 =
    some ⟨.get 0 72 :: .get 1 73 :: .get 2 70 :: .get 3 71 :: .get 4 100 :: .get 5 101 ::
      (Lowering.Arm.hashWords ++ [.set 72 200, .set 73 201]), .jump 0x10104#64⟩ := by rfl

/-- The block at `0x10104` is `sha256h2 q3, q19, v18`. -/
theorem block_10104 : sha256_compress_ni.program 0x10104#64 =
    some ⟨.get 0 102 :: .get 1 103 :: .get 2 70 :: .get 3 71 :: .get 4 100 :: .get 5 101 ::
      (hash2Words ++ [.set 70 200, .set 71 201]), .jump 0x10108#64⟩ := by rfl

/-- The block at `0x10114` is `sha256su1 v2, v17, v6`. -/
theorem block_10114 : sha256_compress_ni.program 0x10114#64 =
    some ⟨.get 0 68 :: .get 1 69 :: .get 2 98 :: .get 3 99 :: .get 4 76 :: .get 5 77 ::
      (su1Words ++ [.set 68 200, .set 69 201]), .jump 0x10118#64⟩ := by rfl

/-- The block at `0x1013c` is `sha256h q4, q3, v5`. -/
theorem block_1013c : sha256_compress_ni.program 0x1013c#64 =
    some ⟨.get 0 72 :: .get 1 73 :: .get 2 70 :: .get 3 71 :: .get 4 74 :: .get 5 75 ::
      (Lowering.Arm.hashWords ++ [.set 72 200, .set 73 201]), .jump 0x10140#64⟩ := by rfl

/-- The block at `0x10140` is `sha256h2 q3, q16, v5`. -/
theorem block_10140 : sha256_compress_ni.program 0x10140#64 =
    some ⟨.get 0 96 :: .get 1 97 :: .get 2 70 :: .get 3 71 :: .get 4 74 :: .get 5 75 ::
      (hash2Words ++ [.set 70 200, .set 71 201]), .jump 0x10144#64⟩ := by rfl

/-! ## Tactics -/

/-- Give a register of the symbolic state the value `v`, which `h` proves equal to the one it
holds: `ni_val r, v, h`. -/
macro "ni_val " r:term ", " v:term ", " h:term : tactic =>
  `(tactic| refine Triple.reg_val (r := $r) $v (by braid_upd) $h ?_)

/-- After the instructions of a turn of either loop: close the table of round constants, and
forget the registers and flags the turn leaves with values of no use. -/
local macro "turn_finish " wk:term ", " K:term ", " i:term ", " hq:term ", " hq0:term ", "
    hq1:term : tactic =>
  `(tactic| (subst_vars
             sha256_fold cells_quad_at $wk 0x20228#64 _ _ $K $i $hq $hq0 $hq1
             braid_forget_flag 0
             braid_forget_flag 1
             braid_forget_flag 2
             braid_forget_flag 3
             braid_done))

/-! ## The first loop -/

/-- **A turn of the first loop**, turn `i` of twelve: rounds `4 * i` to `4 * i + 3` on the
working variables `v`, with the first four words of the window `win`, and the window moved
on by four words. It ends at the head of the loop, or after it when `i` is the last turn. -/
theorem step_spec (wk : Bool) (i : Nat) (hi : i < 12) (c : Word)
    (hc : c = BitVec.ofNat 64 (16 * i)) (win : List W32) (hw : win.length = 16) (v : Vars)
    (y5 y5' y6 y6' y7 y7' y19 y19' : Word) (fn fz fc fv : Bool) :
    Triple sha256_compress_ni.program
      (Atoms.interp [.pc 0x100dc#64, .reg x8 0x20228#64, .reg x9 c,
        .reg (vlo 16) (rowLo win 0), .reg (vhi 16) (rowHi win 0),
        .reg (vlo 18) (rowLo win 1), .reg (vhi 18) (rowHi win 1),
        .reg (vlo 17) (rowLo win 2), .reg (vhi 17) (rowHi win 2),
        .reg (vlo 2) (rowLo win 3), .reg (vhi 2) (rowHi win 3),
        .reg (vlo 4) (abcdLo v), .reg (vhi 4) (abcdHi v),
        .reg (vlo 3) (efghLo v), .reg (vhi 3) (efghHi v),
        .reg (vlo 5) y5, .reg (vhi 5) y5', .reg (vlo 6) y6, .reg (vhi 6) y6',
        .reg (vlo 7) y7, .reg (vhi 7) y7', .reg (vlo 19) y19, .reg (vhi 19) y19',
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 8 wk 0x20228#64 (packs K))])
      (Atoms.interp [.pc (if i = 11 then 0x10120#64 else 0x100dc#64),
        .reg x8 0x20228#64, .reg x9 (c + 16#64),
        .reg (vlo 16) (rowLo (slide4 win) 0), .reg (vhi 16) (rowHi (slide4 win) 0),
        .reg (vlo 18) (rowLo (slide4 win) 1), .reg (vhi 18) (rowHi (slide4 win) 1),
        .reg (vlo 17) (rowLo (slide4 win) 2), .reg (vhi 17) (rowHi (slide4 win) 2),
        .reg (vlo 2) (rowLo (slide4 win) 3), .reg (vhi 2) (rowHi (slide4 win) 3),
        .reg (vlo 4) (abcdLo (rounds4At (4 * i) 0 win v)),
        .reg (vhi 4) (abcdHi (rounds4At (4 * i) 0 win v)),
        .reg (vlo 3) (efghLo (rounds4At (4 * i) 0 win v)),
        .reg (vhi 3) (efghHi (rounds4At (4 * i) 0 win v)),
        .reg (vlo 5) (rowLo (slide4 win) 0), .reg (vhi 5) (rowHi (slide4 win) 0),
        .reg (vlo 6) (rowLo (slide4 win) 2), .reg (vhi 6) (rowHi (slide4 win) 2),
        .reg (vlo 7) (rowLo (slide4 win) 1), .reg (vhi 7) (rowHi (slide4 win) 1),
        .reg (vlo 19) (abcdLo v), .reg (vhi 19) (abcdHi v),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 8 wk 0x20228#64 (packs K))]) := by
  obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
    eq_of_length_16 hw
  obtain ⟨a, b, cc, d, e, f, g, h⟩ := v
  rw [slide4_eq]
  simp only [rowLo, rowHi, abcdLo, abcdHi, efghLo, efghHi, rounds4At, List.getD_cons_succ,
    List.getD_cons_zero, Nat.reduceMul, Nat.reduceAdd]
  have hq : 4 * i + 3 < K.length := by show 4 * i + 3 < 64; omega
  have hq0 : 0x20228#64 + c = 0x20228#64 + BitVec.ofNat 64 (16 * i) := by rw [hc]
  have hq1 : 0x20228#64 + (c + 8#64) = 0x20228#64 + BitVec.ofNat 64 (16 * i + 8) := by
    rw [hc, BitVec.ofNat_add]
  braid_unfold cells_quad_at wk 0x20228#64 (0x20228#64 + c) (0x20228#64 + (c + 8#64)) K i
    hq hq0 hq1
  generalize hk0 : K.getD (4 * i) 0 = k0
  generalize hk1 : K.getD (4 * i + 1) 0 = k1
  generalize hk2 : K.getD (4 * i + 2) 0 = k2
  generalize hk3 : K.getD (4 * i + 3) 0 = k3
  have hh := hash_pack a b cc d e f g h (k0 + w0) (k1 + w1) (k2 + w2) (k3 + w3)
  have hs := su_pack w0 w1 w2 w3 w4 w5 w8 w9 w10 w11 w12 w13 w14 w15
  generalize rounds4 (k0 + w0) (k1 + w1) (k2 + w2) (k3 + w3) ⟨a, b, cc, d, e, f, g, h⟩ = V
    at hh ⊢
  -- The window copied, the four sums, and the count.
  iterate 8 braid_sym_step
  simp only [BitVec.or_self, pack_add]
  -- The first half of the new words, and the four rounds.
  braid_call sha256su0_triple block_100fc _ _ _
  braid_call sha256h_triple block_10100 _ _ _ _ _ _
  braid_call sha256h2_triple block_10104 _ _ _ _ _ _
  simp only [hh.1, hh.2.1, hh.2.2.1, hh.2.2.2]
  -- The window moved on, and the second half of the new words.
  iterate 3 braid_sym_step
  simp only [BitVec.or_self]
  braid_call sha256su1_triple block_10114 _ _ _ _ _ _
  simp only [hs.1, hs.2]
  braid_sym_run
  · have h11 : i ≠ 11 := by
      rintro rfl
      exact hbr (by subst hc; decide)
    simp only [h11, ↓reduceIte, BitVec.or_self]
    turn_finish wk, K, i, hq, hq0, hq1
  · obtain rfl : i = 11 := by bv_omega
    simp only [↓reduceIte, BitVec.or_self]
    turn_finish wk, K, 11, hq, hq0, hq1

/-- **The first loop**, from turn `i` to the last, with `n` turns after this one: an induction
on `n`, each turn `step_spec`. It leaves the window and the working variables that
`Sha256Ni.steps` gives, and the first three rows of the window also in `v5`, `v7` and `v6`,
where the second loop looks for them. -/
theorem loop_spec (wk : Bool) : ∀ (n i : Nat) (c : Word) (win : List W32) (v : Vars)
    (y5 y5' y6 y6' y7 y7' y19 y19' : Word) (fn fz fc fv : Bool), i + n + 1 = 12 →
    c = BitVec.ofNat 64 (16 * i) → win.length = 16 →
    Triple sha256_compress_ni.program
      (Atoms.interp [.pc 0x100dc#64, .reg x8 0x20228#64, .reg x9 c,
        .reg (vlo 16) (rowLo win 0), .reg (vhi 16) (rowHi win 0),
        .reg (vlo 18) (rowLo win 1), .reg (vhi 18) (rowHi win 1),
        .reg (vlo 17) (rowLo win 2), .reg (vhi 17) (rowHi win 2),
        .reg (vlo 2) (rowLo win 3), .reg (vhi 2) (rowHi win 3),
        .reg (vlo 4) (abcdLo v), .reg (vhi 4) (abcdHi v),
        .reg (vlo 3) (efghLo v), .reg (vhi 3) (efghHi v),
        .reg (vlo 5) y5, .reg (vhi 5) y5', .reg (vlo 6) y6, .reg (vhi 6) y6',
        .reg (vlo 7) y7, .reg (vhi 7) y7', .reg (vlo 19) y19, .reg (vhi 19) y19',
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 8 wk 0x20228#64 (packs K))])
      (Atoms.interp [.pc 0x10120#64, .reg x8 0x20228#64, .reg x9 192#64,
        .reg (vlo 16) (rowLo (steps (4 * i) (n + 1) win v).1 0),
        .reg (vhi 16) (rowHi (steps (4 * i) (n + 1) win v).1 0),
        .reg (vlo 18) (rowLo (steps (4 * i) (n + 1) win v).1 1),
        .reg (vhi 18) (rowHi (steps (4 * i) (n + 1) win v).1 1),
        .reg (vlo 17) (rowLo (steps (4 * i) (n + 1) win v).1 2),
        .reg (vhi 17) (rowHi (steps (4 * i) (n + 1) win v).1 2),
        .reg (vlo 2) (rowLo (steps (4 * i) (n + 1) win v).1 3),
        .reg (vhi 2) (rowHi (steps (4 * i) (n + 1) win v).1 3),
        .reg (vlo 4) (abcdLo (steps (4 * i) (n + 1) win v).2),
        .reg (vhi 4) (abcdHi (steps (4 * i) (n + 1) win v).2),
        .reg (vlo 3) (efghLo (steps (4 * i) (n + 1) win v).2),
        .reg (vhi 3) (efghHi (steps (4 * i) (n + 1) win v).2),
        .reg (vlo 5) (rowLo (steps (4 * i) (n + 1) win v).1 0),
        .reg (vhi 5) (rowHi (steps (4 * i) (n + 1) win v).1 0),
        .reg (vlo 6) (rowLo (steps (4 * i) (n + 1) win v).1 2),
        .reg (vhi 6) (rowHi (steps (4 * i) (n + 1) win v).1 2),
        .reg (vlo 7) (rowLo (steps (4 * i) (n + 1) win v).1 1),
        .reg (vhi 7) (rowHi (steps (4 * i) (n + 1) win v).1 1),
        .prop (regAny (vlo 19)), .prop (regAny (vhi 19)),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 8 wk 0x20228#64 (packs K))]) := by
  intro n
  induction n with
  | zero =>
    intro i c win v y5 y5' y6 y6' y7 y7' y19 y19' fn fz fc fv hn hc hw
    obtain rfl : i = 11 := by omega
    rw [steps_succ, steps_zero]
    braid_call step_spec wk 11 (by omega) c hc win hw v y5 y5' y6 y6' y7 y7' y19 y19' fn fz
      fc fv
    ni_val 9, 192#64, (by subst hc; decide)
    braid_forget (vlo 19)
    braid_forget (vhi 19)
    braid_done
  | succ n ih =>
    intro i c win v y5 y5' y6 y6' y7 y7' y19 y19' fn fz fc fv hn hc hw
    have h11 : i ≠ 11 := by omega
    rw [steps_succ, show 4 * i + 4 = 4 * (i + 1) by omega]
    braid_call step_spec wk i (by omega) c hc win hw v y5 y5' y6 y6' y7 y7' y19 y19' fn fz
      fc fv
    simp only [h11, ↓reduceIte]
    braid_name_flag 0
    braid_name_flag 1
    braid_name_flag 2
    braid_name_flag 3
    braid_call ih (i + 1) (c + 16#64) (slide4 win) (rounds4At (4 * i) 0 win v) _ _ _ _ _ _ _ _
      _ _ _ _ (by omega) (by rw [hc, Nat.mul_succ, BitVec.ofNat_add]) (slide4_length win hw)
    braid_done

/-! ## The second loop -/

/-- **A turn of the second loop**, turn `j` of four: rounds `4 * (12 + j)` to
`4 * (12 + j) + 3` on the working variables `v`, with the words `4 * j` to `4 * j + 3` of
the list `W`, which `v5` holds. No word of the schedule is computed: the registers of the
window move on by one, whatever they hold, and the last is repeated. It ends at the head of
the loop, or after it when `j` is the last turn. -/
theorem tail_spec (wk : Bool) (j : Nat) (hj : j < 4) (c : Word)
    (hc : c = BitVec.ofNat 64 (16 * j)) (W : List W32) (v : Vars)
    (t10 y16 y16' y7 y7' y6 y6' y2 y2' : Word) (fn fz fc fv : Bool) :
    Triple sha256_compress_ni.program
      (Atoms.interp [.pc 0x10124#64, .reg x8 0x20228#64, .reg x9 c, .reg x10 t10,
        .reg (vlo 16) y16, .reg (vhi 16) y16',
        .reg (vlo 5) (rowLo W j), .reg (vhi 5) (rowHi W j),
        .reg (vlo 7) y7, .reg (vhi 7) y7', .reg (vlo 6) y6, .reg (vhi 6) y6',
        .reg (vlo 2) y2, .reg (vhi 2) y2',
        .reg (vlo 4) (abcdLo v), .reg (vhi 4) (abcdHi v),
        .reg (vlo 3) (efghLo v), .reg (vhi 3) (efghHi v),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 8 wk 0x20228#64 (packs K))])
      (Atoms.interp [.pc (if j = 3 then 0x10154#64 else 0x10124#64),
        .reg x8 0x20228#64, .reg x9 (c + 16#64), .prop (regAny x10),
        .prop (regAny (vlo 16)), .prop (regAny (vhi 16)),
        .reg (vlo 5) y7, .reg (vhi 5) y7', .reg (vlo 7) y6, .reg (vhi 7) y6',
        .reg (vlo 6) y2, .reg (vhi 6) y2', .reg (vlo 2) y2, .reg (vhi 2) y2',
        .reg (vlo 4) (abcdLo (rounds4At (4 * (12 + j)) (4 * j) W v)),
        .reg (vhi 4) (abcdHi (rounds4At (4 * (12 + j)) (4 * j) W v)),
        .reg (vlo 3) (efghLo (rounds4At (4 * (12 + j)) (4 * j) W v)),
        .reg (vhi 3) (efghHi (rounds4At (4 * (12 + j)) (4 * j) W v)),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 8 wk 0x20228#64 (packs K))]) := by
  obtain ⟨a, b, cc, d, e, f, g, h⟩ := v
  simp only [rowLo, rowHi, abcdLo, abcdHi, efghLo, efghHi, rounds4At]
  have hq : 4 * (12 + j) + 3 < K.length := by show 4 * (12 + j) + 3 < 64; omega
  have hq0 : 0x20228#64 + (c + 192#64) = 0x20228#64 + BitVec.ofNat 64 (16 * (12 + j)) := by
    rw [hc, Nat.mul_add, BitVec.ofNat_add]
    generalize BitVec.ofNat 64 (16 * j) = z
    bv_decide
  have hq1 : 0x20228#64 + (c + 200#64) =
      0x20228#64 + BitVec.ofNat 64 (16 * (12 + j) + 8) := by
    rw [hc, Nat.mul_add, BitVec.ofNat_add, BitVec.ofNat_add]
    generalize BitVec.ofNat 64 (16 * j) = z
    bv_decide
  braid_unfold cells_quad_at wk 0x20228#64 (0x20228#64 + (c + 192#64))
    (0x20228#64 + (c + 200#64)) K (12 + j) hq hq0 hq1
  generalize hk0 : K.getD (4 * (12 + j)) 0 = k0
  generalize hk1 : K.getD (4 * (12 + j) + 1) 0 = k1
  generalize hk2 : K.getD (4 * (12 + j) + 2) 0 = k2
  generalize hk3 : K.getD (4 * (12 + j) + 3) 0 = k3
  generalize hp0 : W.getD (4 * j) 0 = p0
  generalize hp1 : W.getD (4 * j + 1) 0 = p1
  generalize hp2 : W.getD (4 * j + 2) 0 = p2
  generalize hp3 : W.getD (4 * j + 3) 0 = p3
  have hh := hash_pack a b cc d e f g h (k0 + p0) (k1 + p1) (k2 + p2) (k3 + p3)
  generalize rounds4 (k0 + p0) (k1 + p1) (k2 + p2) (k3 + p3) ⟨a, b, cc, d, e, f, g, h⟩ = V
    at hh ⊢
  -- The four sums, and the working variables copied.
  iterate 6 braid_sym_step
  simp only [BitVec.or_self, pack_add]
  -- The four rounds.
  braid_call sha256h_triple block_1013c _ _ _ _ _ _
  braid_call sha256h2_triple block_10140 _ _ _ _ _ _
  simp only [hh.1, hh.2.1, hh.2.2.1, hh.2.2.2]
  braid_sym_run
  · have h3 : j ≠ 3 := by
      rintro rfl
      exact hbr (by subst hc; decide)
    simp only [h3, ↓reduceIte, BitVec.or_self]
    braid_forget 10
    braid_forget (vlo 16)
    braid_forget (vhi 16)
    turn_finish wk, K, (12 + j), hq, hq0, hq1
  · obtain rfl : j = 3 := by bv_omega
    simp only [↓reduceIte, BitVec.or_self]
    braid_forget 10
    braid_forget (vlo 16)
    braid_forget (vhi 16)
    turn_finish wk, K, (12 + 3), hq, hq0, hq1

end Examples.Sha256Ni.Arm
