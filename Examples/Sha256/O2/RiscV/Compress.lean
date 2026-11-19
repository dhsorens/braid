/-
  Examples.Sha256.O2.RiscV.Compress

  `sha256_compress` of `sha256.c` on RISC-V, compiled at `-O2`: the compression function of
  SHA-256. As at `-O1` the compiler inlined `sha256_schedule` and `sha256_round` into it and
  keeps the eight working variables in registers through the 64 rounds. What `-O2` changes:

  * the three short copying loops and the loop that adds are gone. The block is copied to
    the start of the schedule by sixteen loads and sixteen stores in a line; the hash value
    is loaded into eight registers, which hold it to the end, and no copy of the working
    variables is kept in the frame; the sums are eight additions and eight stores;
  * the frame is 336 bytes, the schedule and ten saved registers (`s0` to `s9`), where it
    was 320, with three;
  * the loop of the schedule is the same instructions at other addresses;
  * a round is the same computation with the working variables in other registers, five
    other registers for intermediate values, and some sums associated differently;
  * the round constants are at `0x10404`, where they were at `0x10368`;
  * `a0` is left as it was, where `-O1` left it at the end of the hash value.

  The stages of the proof are those of `Examples.Sha256.RiscV.Compress`. The two loops
  (`compress_schedule_loop`, `compress_round_step`, `compress_rounds_loop`) are its
  statements with the addresses and the registers of this binary, and its proofs with the
  numbers of the registers changed and nothing else. The function itself is run again, and
  in three triples (`compress_head_spec`, `compress_rounds_spec`, `compress_tail_spec`) where
  `-O1` had one: with ten saved registers in the frame, one declaration that runs all of the
  code does not fit in the default limit on heartbeats.

  ## Main results

  * `sha256_compress_spec`: the specification, with `Sha256.compress`
  * `sha256_compress_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256.O2.RiscV.Image
public import Examples.Sha256.RiscV.Machine
public import Examples.Sha256.RunTo

public section

namespace Examples.Sha256.O2.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64
open Examples.Sha256.RiscV

/-! ## The message schedule -/

/-- Forget what the loop of the schedule leaves in the registers it uses. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 13; braid_forget 14; braid_forget 15; braid_forget 16
             braid_forget 17; braid_forget 5; braid_forget 6; braid_forget 7))

/-- The loop of the message schedule in `sha256_compress`, where `sha256_schedule` is
inlined: with a window of sixteen words of the schedule at `q`, `js.length + 1` cells after
it, the last of them just before `e`, fill those cells with the next words of the
schedule. -/
theorem compress_schedule_loop (e : Word) : ∀ (js : List Word) (win : List W32) (j q : Word)
    (x13 x14 x15 x16 x17 x5 x6 x7 : Word), win.length = 16 → q &&& 3#64 = 0#64 →
    q + 64#64 + BitVec.ofNat 64 (4 * (js.length + 1)) = e → js.length + 1 ≤ 48 →
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x10214#64, .reg a1 (q + 64#64), .reg a2 e, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .prop (cellsAt 4 true q (w32s win ++ j :: js))])
      (Atoms.interp [.pc 0x10284#64, .reg a1 e, .reg a2 e, .prop (regAny a3),
        .prop (regAny a4), .prop (regAny a5), .prop (regAny a6), .prop (regAny a7),
        .prop (regAny t0), .prop (regAny t1), .prop (regAny t2),
        .prop (cellsAt 4 true q (w32s (extend (js.length + 1) win)))]) := by
  intro js
  induction js with
  | nil =>
    intro win j q x13 x14 x15 x16 x17 x5 x6 x7 hw hq he hb
    obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
      eq_of_length_16 hw
    simp only [List.length_nil, Nat.zero_add] at he ⊢
    rw [w32s_extend_one]
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    braid_unfold cells_win17 true (q' + 1#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
      j []
    braid_sym_run_to 0x10284
    · exact absurd (by bv_omega) hbr
    · subst hbr
      sha256_cell (q' + 65#64), (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12,
          w13, w14, w15]).setWidth 64
      sha256_fold cells_win17 true (q' + 1#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14
          w15
        ((nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14,
            w15]).setWidth 64) []
      schedule_forget
      braid_done
  | cons j' js ih =>
    intro win j q x13 x14 x15 x16 x17 x5 x6 x7 hw hq he hb
    obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
      eq_of_length_16 hw
    simp only [List.length_cons] at he hb ⊢
    rw [w32s_extend_succ]
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    braid_unfold cells_win17 true (q' + 1#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
      j (j' :: js)
    braid_sym_run_to 0x10284
    · sha256_cell (q' + 65#64), (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12,
        w13, w14, w15]).setWidth 64
      sha256_fold cells_win16 true (q' + 5#64) w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
        (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]) (j' ::
            js)
      braid_call ih [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, nextWord
        [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]]
        j' (q' + 5#64) _ _ _ _ _ _ _ _ rfl (by bv_decide) (by rw [← he]; bv_omega) (by omega)
      sha256_fold cellsAt_cons (k := 4) (w := true) (q' + 1#64) (w0.setWidth 64)
        (w32s (extend (js.length + 1) [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13,
            w14, w15,
          nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]]))
      braid_done
    · exfalso
      rw [← hbr] at he
      bv_omega
/-! ## The rounds -/

/-- Forget what a round leaves in the registers it uses for intermediate values. -/
local macro "round_forget" : tactic =>
  `(tactic| (braid_forget 19; braid_forget 22; braid_forget 23; braid_forget 24
             braid_forget 25))

/-- After the instructions of a round: give the registers the values of the specification,
close the two arrays, and forget the intermediate values. -/
local macro "round_finish " kp:term ", " wp:term ", " ka:term ", " wa:term ", " wk:term ", "
    W:term ", " v:term ", " t:term ", " hK:term ", " hW:term ", " hka:term ", " hwa:term : tactic
        =>
  `(tactic| (sha256_low 18, (round $W $v $t).a
             sha256_low 9, (round $W $v $t).b
             sha256_low 8, (round $W $v $t).c
             sha256_low 21, (round $W $v $t).d
             sha256_low 20, (round $W $v $t).e
             sha256_low 28, (round $W $v $t).f
             sha256_low 7, (round $W $v $t).g
             sha256_low 6, (round $W $v $t).h
             sha256_fold cells_w32_index_at $wk $kp $ka K $t $hK $hka
             sha256_fold cells_w32_index_at true $wp $wa $W $t $hW $hwa
             round_forget
             braid_done))

/-- One iteration of the loop of rounds in `sha256_compress`, where `sha256_round` is
inlined and the working variables are in registers: round `t`, with the round constants at
`kp` and the schedule at `wp`, the code's two pointers `ka` and `wa` at their words of index
`t`. A register holds a working variable in its low 32 bits; its high 32 bits are whatever
the 64-bit additions carried there. It ends at the head of the loop, or after it when `t` is
the last round. -/
theorem compress_round_step (kp wp ke : Word) (wk : Bool) (W : List W32) (hW : W.length = 64)
    (t : Nat) (ht : t < 64) (v : Vars) (ka wa xa xb xc xd xe xf xg xh y19 y22 y23 y24 y25 : Word)
    (hkp : kp &&& 3#64 = 0#64) (hwp : wp &&& 3#64 = 0#64) (hke : ke = kp + 256#64)
    (hka : ka = kp + BitVec.ofNat 64 (4 * t)) (hwa : wa = wp + BitVec.ofNat 64 (4 * t))
    (ha : xa.setWidth 32 = v.a) (hb : xb.setWidth 32 = v.b) (hc : xc.setWidth 32 = v.c)
    (hd : xd.setWidth 32 = v.d) (he : xe.setWidth 32 = v.e) (hf : xf.setWidth 32 = v.f)
    (hg : xg.setWidth 32 = v.g) (hh : xh.setWidth 32 = v.h) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x102d4#64, .reg t4 ka, .reg t5 wa, .reg t6 ke,
        .reg s2 xa, .reg s1 xb, .reg s0 xc, .reg s5 xd, .reg s4 xe, .reg t3 xf, .reg t2 xg,
        .reg t1 xh, .reg s3 y19, .reg s6 y22, .reg s7 y23, .reg s8 y24, .reg s9 y25,
        .prop (cellsAt 4 wk kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))])
      (Atoms.interp [.pc (if t = 63 then 0x10394#64 else 0x102d4#64),
        .reg t4 (ka + 4#64), .reg t5 (wa + 4#64), .reg t6 ke,
        .prop (regLow s2 (round W v t).a), .prop (regLow s1 (round W v t).b),
        .prop (regLow s0 (round W v t).c), .prop (regLow s5 (round W v t).d),
        .prop (regLow s4 (round W v t).e), .prop (regLow t3 (round W v t).f),
        .prop (regLow t2 (round W v t).g), .prop (regLow t1 (round W v t).h),
        .prop (regAny s3), .prop (regAny s6), .prop (regAny s7), .prop (regAny s8),
        .prop (regAny s9),
        .prop (cellsAt 4 wk kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))]) := by
  have hK : t < K.length := ht
  have hka3 : ka &&& 3#64 = 0#64 := by rw [hka, and3_add_mul4, hkp]
  have hwa3 : wa &&& 3#64 = 0#64 := by rw [hwa, and3_add_mul4, hwp]
  braid_unfold cells_w32_index_at wk kp ka K t hK hka
  braid_unfold cells_w32_index_at true wp wa W t (hW ▸ ht) hwa
  braid_sym_run
  · have h63 : t ≠ 63 := by
      rintro rfl
      exact hbr (by rw [hka, hke]; bv_omega)
    simp only [h63, ↓reduceIte]
    round_finish kp, wp, ka, wa, wk, W, v, t, hK, hW ▸ ht, hka, hwa
  · obtain rfl : t = 63 := by rw [hka, hke] at hbr; bv_omega
    simp only [↓reduceIte]
    round_finish kp, wp, ka, wa, wk, W, v, 63, hK, hW ▸ ht, hka, hwa

/-- Name the values a round left in the registers it uses for intermediate values. -/
local macro "round_name" : tactic =>
  `(tactic| (braid_name_reg 19; braid_name_reg 22; braid_name_reg 23; braid_name_reg 24
             braid_name_reg 25))

/-- The loop of rounds in `sha256_compress`, from round `t` to the last: an induction on
the number of rounds left, each of them `compress_round_step`. -/
theorem compress_rounds_loop (kp wp ke : Word) (wk : Bool) (W : List W32) (hW : W.length = 64)
    (hkp : kp &&& 3#64 = 0#64) (hwp : wp &&& 3#64 = 0#64) (hke : ke = kp + 256#64) :
    ∀ (n t : Nat) (v : Vars) (ka wa xa xb xc xd xe xf xg xh y19 y22 y23 y24 y25 : Word),
    t + n + 1 = 64 → ka = kp + BitVec.ofNat 64 (4 * t) → wa = wp + BitVec.ofNat 64 (4 * t) →
    xa.setWidth 32 = v.a → xb.setWidth 32 = v.b → xc.setWidth 32 = v.c →
    xd.setWidth 32 = v.d → xe.setWidth 32 = v.e → xf.setWidth 32 = v.f →
    xg.setWidth 32 = v.g → xh.setWidth 32 = v.h →
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x102d4#64, .reg t4 ka, .reg t5 wa, .reg t6 ke,
        .reg s2 xa, .reg s1 xb, .reg s0 xc, .reg s5 xd, .reg s4 xe, .reg t3 xf, .reg t2 xg,
        .reg t1 xh, .reg s3 y19, .reg s6 y22, .reg s7 y23, .reg s8 y24, .reg s9 y25,
        .prop (cellsAt 4 wk kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))])
      (Atoms.interp [.pc 0x10394#64, .prop (regAny t4), .prop (regAny t5), .reg t6 ke,
        .prop (regLow s2 (roundsFrom W t (n + 1) v).a), .prop (regLow s1 (roundsFrom W t (n + 1)
        v).b), .prop (regLow s0 (roundsFrom W t (n + 1) v).c), .prop (regLow s5 (roundsFrom W t (n
        + 1) v).d), .prop (regLow s4 (roundsFrom W t (n + 1) v).e), .prop (regLow t3 (roundsFrom W
        t (n + 1) v).f), .prop (regLow t2 (roundsFrom W t (n + 1) v).g), .prop (regLow t1
        (roundsFrom W t (n + 1) v).h),
        .prop (regAny s3), .prop (regAny s6), .prop (regAny s7), .prop (regAny s8),
        .prop (regAny s9),
        .prop (cellsAt 4 wk kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))]) := by
  intro n
  induction n with
  | zero =>
    intro t v ka wa xa xb xc xd xe xf xg xh y19 y22 y23 y24 y25 hn hka hwa ha hb hc hd he hf hg hh
    obtain rfl : t = 63 := by omega
    rw [roundsFrom_one]
    braid_call compress_round_step kp wp ke wk W hW 63 (by omega) v ka wa xa xb xc xd xe xf xg xh
      y19 y22 y23 y24 y25 hkp hwp hke hka hwa ha hb hc hd he hf hg hh
    braid_forget 29
    braid_forget 30
    braid_done
  | succ n ih =>
    intro t v ka wa xa xb xc xd xe xf xg xh y19 y22 y23 y24 y25 hn hka hwa ha hb hc hd he hf hg hh
    have h63 : t ≠ 63 := by omega
    rw [roundsFrom_succ]
    braid_call compress_round_step kp wp ke wk W hW t (by omega) v ka wa xa xb xc xd xe xf xg xh
      y19 y22 y23 y24 y25 hkp hwp hke hka hwa ha hb hc hd he hf hg hh
    simp only [h63, ↓reduceIte]
    round_name
    sha256_name_low 18 with xa' ha'
    sha256_name_low 9 with xb' hb'
    sha256_name_low 8 with xc' hc'
    sha256_name_low 21 with xd' hd'
    sha256_name_low 20 with xe' he'
    sha256_name_low 28 with xf' hf'
    sha256_name_low 7 with xg' hg'
    sha256_name_low 6 with xh' hh'
    braid_call ih (t + 1) (round W v t) (ka + 4#64) (wa + 4#64) xa' xb' xc' xd' xe' xf' xg' xh'
      _ _ _ _ _ (by omega) (by rw [hka, BitVec.add_assoc, ofNat_mul4_succ])
      (by rw [hwa, BitVec.add_assoc, ofNat_mul4_succ]) ha' hb' hc' hd' he' hf' hg' hh'
    braid_done
/-! ## The compression function -/

/-- **The head of `sha256_compress`**, to the end of the message schedule: the frame is made,
ten registers are saved in it, the block is copied to the start of the schedule, and the
schedule is filled. -/
theorem compress_head_spec (mp s v8 v9 v18 v19 v20 v21 v22 v23 v24 v25 : Word) (M : List W32)
    (wm : Bool) (fws sv : List Word) (x12 x13 x14 x15 x16 x17 x5 x6 x7 : Word)
    (hM : M.length = 16) (hfw : fws.length = 64) (hsv : sv.length = 10)
    (hmp : mp &&& 3#64 = 0#64) (hs : s &&& 7#64 = 0#64) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x10160#64, .reg a1 mp, .reg a2 x12, .reg a3 x13, .reg a4 x14,
        .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6, .reg t2 x7,
        .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg s3 v19, .reg s4 v20,
        .reg s5 v21, .reg s6 v22, .reg s7 v23, .reg s8 v24, .reg s9 v25, .reg sp s,
        .prop (cellsAt 4 wm mp (w32s M)), .prop (cellsAt 4 true (s - 336#64) fws),
        .prop (cellsAt 8 true (s - 80#64) sv)])
      (Atoms.interp [.pc 0x10284#64, .reg a1 (s - 80#64), .reg a2 (s - 80#64),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .prop (regAny t2),
        .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg s3 v19, .reg s4 v20,
        .reg s5 v21, .reg s6 v22, .reg s7 v23, .reg s8 v24, .reg s9 v25, .reg sp (s - 336#64),
        .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 true (s - 336#64) (w32s (schedule M))),
        .prop (cellsAt 8 true (s - 80#64) [v25, v24, v23, v22, v21, v20, v19, v18, v9, v8])]) := by
  obtain ⟨m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15, rfl⟩ :=
    eq_of_length_16 hM
  obtain ⟨g0, g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12, g13, g14, g15, js, rfl, hjs⟩ :=
    eq_of_length_16_add (n := 48) hfw
  obtain ⟨j, js', rfl⟩ : ∃ j js', js = j :: js' := by
    cases js with
    | nil => simp at hjs
    | cons a b => exact ⟨a, b, rfl⟩
  have h47 : js'.length = 47 := by simpa using hjs
  obtain ⟨sv0, sv1, sv2, sv3, sv4, sv5, sv6, sv7, sv8, sv9, rfl⟩ :
      ∃ sv0 sv1 sv2 sv3 sv4 sv5 sv6 sv7 sv8 sv9,
        sv = [sv0, sv1, sv2, sv3, sv4, sv5, sv6, sv7, sv8, sv9] := by
    match sv, hsv with
    | [sv0, sv1, sv2, sv3, sv4, sv5, sv6, sv7, sv8, sv9], _ =>
      exact ⟨sv0, sv1, sv2, sv3, sv4, sv5, sv6, sv7, sv8, sv9, rfl⟩
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨mq, rfl⟩ : ∃ mq : BitVec 64, mp = mq + 1#64 := ⟨mp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 337#64 := ⟨s - 337#64, by bv_omega⟩
  braid_unfold cells16_w32 wm (mq + 1#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
  braid_unfold cells_pre16 true (sq + 1#64) g0 g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 g11 g12 g13
    g14 g15 (j :: js')
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 257#64) sv0 [sv1, sv2, sv3, sv4, sv5, sv6,
    sv7, sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 265#64) sv1 [sv2, sv3, sv4, sv5, sv6, sv7,
    sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 273#64) sv2 [sv3, sv4, sv5, sv6, sv7, sv8,
    sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 281#64) sv3 [sv4, sv5, sv6, sv7, sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 289#64) sv4 [sv5, sv6, sv7, sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 297#64) sv5 [sv6, sv7, sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 305#64) sv6 [sv7, sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 313#64) sv7 [sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 321#64) sv8 [sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 329#64) sv9 []
  -- The frame, and the block copied to the start of the schedule.
  braid_sym_run_to 0x10214
  -- The message schedule.
  sha256_cell (sq + 1#64), m0.setWidth 64
  sha256_cell (sq + 5#64), m1.setWidth 64
  sha256_cell (sq + 9#64), m2.setWidth 64
  sha256_cell (sq + 13#64), m3.setWidth 64
  sha256_cell (sq + 17#64), m4.setWidth 64
  sha256_cell (sq + 21#64), m5.setWidth 64
  sha256_cell (sq + 25#64), m6.setWidth 64
  sha256_cell (sq + 29#64), m7.setWidth 64
  sha256_cell (sq + 33#64), m8.setWidth 64
  sha256_cell (sq + 37#64), m9.setWidth 64
  sha256_cell (sq + 41#64), m10.setWidth 64
  sha256_cell (sq + 45#64), m11.setWidth 64
  sha256_cell (sq + 49#64), m12.setWidth 64
  sha256_cell (sq + 53#64), m13.setWidth 64
  sha256_cell (sq + 57#64), m14.setWidth 64
  sha256_cell (sq + 61#64), m15.setWidth 64
  sha256_fold cells_win16 true (sq + 1#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
    (j :: js')
  braid_call compress_schedule_loop (sq + 257#64) js' [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9,
      m10, m11, m12, m13, m14, m15] j (sq + 1#64) _ _ _ _ _ _ _ _ rfl (by bv_decide)
    (by rw [h47]; bv_omega) (by omega)
  simp only [h47, Nat.reduceAdd]
  rw [← schedule_eq_extend [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15]
    rfl]
  sha256_fold cells16_w32 wm (mq + 1#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 329#64) v8 []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 321#64) v9 [v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 313#64) v18 [v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 305#64) v19 [v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 297#64) v20 [v19, v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 289#64) v21 [v20, v19, v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 281#64) v22 [v21, v20, v19, v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 273#64) v23 [v22, v21, v20, v19, v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 265#64) v24 [v23, v22, v21, v20, v19, v18,
    v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 257#64) v25 [v24, v23, v22, v21, v20, v19,
    v18, v9, v8]
  braid_done

/-- **The rounds of `sha256_compress`**, from the end of the message schedule to the end of
the loop of rounds: the hash value is loaded into eight registers, which keep it, and copied
to the registers of the working variables, on which the 64 rounds run. -/
theorem compress_rounds_spec (hp s : Word) (h0 h1 h2 h3 h4 h5 h6 h7 : W32) (W : List W32)
    (wk : Bool) (x11 x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 : Word)
    (y8 y9 y18 y19 y20 y21 y22 y23 y24 y25 : Word) (hW : W.length = 64)
    (hhp : hp &&& 3#64 = 0#64) (hs : s &&& 7#64 = 0#64) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x10284#64, .reg a0 hp, .reg a1 x11, .reg a2 x12, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .reg t3 x28, .reg t4 x29, .reg t5 x30, .reg t6 x31,
        .reg s0 y8, .reg s1 y9, .reg s2 y18, .reg s3 y19, .reg s4 y20, .reg s5 y21,
        .reg s6 y22, .reg s7 y23, .reg s8 y24, .reg s9 y25, .reg sp (s - 336#64),
        .prop (cellsAt 4 true hp (w32s [h0, h1, h2, h3, h4, h5, h6, h7])),
        .prop (cellsAt 4 wk 0x10404#64 (w32s K)),
        .prop (cellsAt 4 true (s - 336#64) (w32s W))])
      (Atoms.interp [.pc 0x10394#64, .reg a0 hp, .reg a1 (BitVec.signExtend 64 h7),
        .reg a2 (BitVec.signExtend 64 h6), .reg a3 (BitVec.signExtend 64 h5),
        .reg a4 (BitVec.signExtend 64 h4), .reg a5 (BitVec.signExtend 64 h3),
        .reg a6 (BitVec.signExtend 64 h2), .reg a7 (BitVec.signExtend 64 h1),
        .reg t0 (BitVec.signExtend 64 h0),
        .prop (regLow t1 (rounds W ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).h),
        .prop (regLow t2 (rounds W ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).g),
        .prop (regLow t3 (rounds W ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).f),
        .prop (regAny t4), .prop (regAny t5), .prop (regAny t6),
        .prop (regLow s0 (rounds W ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).c),
        .prop (regLow s1 (rounds W ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).b),
        .prop (regLow s2 (rounds W ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).a), .prop (regAny s3),
        .prop (regLow s4 (rounds W ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).e),
        .prop (regLow s5 (rounds W ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).d),
        .prop (regAny s6), .prop (regAny s7), .prop (regAny s8), .prop (regAny s9),
        .reg sp (s - 336#64),
        .prop (cellsAt 4 true hp (w32s [h0, h1, h2, h3, h4, h5, h6, h7])),
        .prop (cellsAt 4 wk 0x10404#64 (w32s K)),
        .prop (cellsAt 4 true (s - 336#64) (w32s W))]) := by
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 337#64 := ⟨s - 337#64, by bv_omega⟩
  braid_unfold cells8_w32 true (hq + 1#64) h0 h1 h2 h3 h4 h5 h6 h7
  -- The hash value loaded into registers, and copied to those of the working variables.
  braid_sym_run_to 0x102d4
  sha256_reg 5, BitVec.signExtend 64 h0
  sha256_reg 17, BitVec.signExtend 64 h1
  sha256_reg 16, BitVec.signExtend 64 h2
  sha256_reg 15, BitVec.signExtend 64 h3
  sha256_reg 14, BitVec.signExtend 64 h4
  sha256_reg 13, BitVec.signExtend 64 h5
  sha256_reg 12, BitVec.signExtend 64 h6
  sha256_reg 11, BitVec.signExtend 64 h7
  sha256_reg 18, BitVec.signExtend 64 h0
  sha256_reg 9, BitVec.signExtend 64 h1
  sha256_reg 8, BitVec.signExtend 64 h2
  sha256_reg 21, BitVec.signExtend 64 h3
  sha256_reg 20, BitVec.signExtend 64 h4
  sha256_reg 28, BitVec.signExtend 64 h5
  sha256_reg 7, BitVec.signExtend 64 h6
  sha256_reg 6, BitVec.signExtend 64 h7
  sha256_fold cells8_w32 true (hq + 1#64) h0 h1 h2 h3 h4 h5 h6 h7
  -- The rounds.
  braid_call compress_rounds_loop 0x10404#64 (sq + 1#64) 0x10504#64 wk W hW (by decide)
    (by bv_decide) (by decide) 63 0 ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩
    0x10404#64 (sq + 1#64) (BitVec.signExtend 64 h0) (BitVec.signExtend 64 h1) (BitVec.signExtend
        64 h2) (BitVec.signExtend 64 h3) (BitVec.signExtend 64 h4) (BitVec.signExtend 64 h5)
        (BitVec.signExtend 64 h6) (BitVec.signExtend 64 h7)
    _ _ _ _ _ (by omega) (by decide) (by simp)
    (by show _ = h0; bv_decide)
    (by show _ = h1; bv_decide)
    (by show _ = h2; bv_decide)
    (by show _ = h3; bv_decide)
    (by show _ = h4; bv_decide)
    (by show _ = h5; bv_decide)
    (by show _ = h6; bv_decide)
    (by show _ = h7; bv_decide)
  simp only [Nat.reduceAdd]
  rw [← rounds_eq_roundsFrom]
  braid_forget 31
  braid_done

/-- **The tail of `sha256_compress`**, from the end of the loop of rounds: the working
variables are added to the hash value, which the registers still hold, the sums are stored,
the ten saved registers are restored, and the frame is dropped. -/
theorem compress_tail_spec (hp s r : Word) (h0 h1 h2 h3 h4 h5 h6 h7 : W32) (R : Vars)
    (xa xb xc xd xe xf xg xh y19 y22 y23 y24 y25 : Word)
    (v8 v9 v18 v19 v20 v21 v22 v23 v24 v25 : Word)
    (hhp : hp &&& 3#64 = 0#64) (hs : s &&& 7#64 = 0#64)
    (hxa : xa.setWidth 32 = R.a) (hxb : xb.setWidth 32 = R.b) (hxc : xc.setWidth 32 = R.c)
    (hxd : xd.setWidth 32 = R.d) (hxe : xe.setWidth 32 = R.e) (hxf : xf.setWidth 32 = R.f)
    (hxg : xg.setWidth 32 = R.g) (hxh : xh.setWidth 32 = R.h) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x10394#64, .reg a0 hp, .reg a1 (BitVec.signExtend 64 h7),
        .reg a2 (BitVec.signExtend 64 h6), .reg a3 (BitVec.signExtend 64 h5),
        .reg a4 (BitVec.signExtend 64 h4), .reg a5 (BitVec.signExtend 64 h3),
        .reg a6 (BitVec.signExtend 64 h2), .reg a7 (BitVec.signExtend 64 h1),
        .reg t0 (BitVec.signExtend 64 h0), .reg t1 xh, .reg t2 xg, .reg t3 xf,
        .reg s0 xc, .reg s1 xb, .reg s2 xa, .reg s3 y19, .reg s4 xe, .reg s5 xd,
        .reg s6 y22, .reg s7 y23, .reg s8 y24, .reg s9 y25, .reg sp (s - 336#64), .reg ra r,
        .prop (cellsAt 4 true hp (w32s [h0, h1, h2, h3, h4, h5, h6, h7])),
        .prop (cellsAt 8 true (s - 80#64) [v25, v24, v23, v22, v21, v20, v19, v18, v9, v8])])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 hp, .prop (regAny a1), .prop (regAny a2),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .prop (regAny t2),
        .prop (regAny t3),
        .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg s3 v19, .reg s4 v20,
        .reg s5 v21, .reg s6 v22, .reg s7 v23, .reg s8 v24, .reg s9 v25, .reg sp s, .reg ra r,
        .prop (cellsAt 4 true hp (w32s [R.a + h0, R.b + h1, R.c + h2, R.d + h3, R.e + h4,
          R.f + h5, R.g + h6, R.h + h7])),
        .prop (cellsAt 8 true (s - 80#64) [v25, v24, v23, v22, v21, v20, v19, v18, v9, v8])]) := by
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 337#64 := ⟨s - 337#64, by bv_omega⟩
  braid_unfold cells8_w32 true (hq + 1#64) h0 h1 h2 h3 h4 h5 h6 h7
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 257#64) v25 [v24, v23, v22, v21, v20, v19,
    v18, v9, v8]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 265#64) v24 [v23, v22, v21, v20, v19, v18,
    v9, v8]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 273#64) v23 [v22, v21, v20, v19, v18, v9,
    v8]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 281#64) v22 [v21, v20, v19, v18, v9, v8]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 289#64) v21 [v20, v19, v18, v9, v8]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 297#64) v20 [v19, v18, v9, v8]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 305#64) v19 [v18, v9, v8]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 313#64) v18 [v9, v8]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 321#64) v9 [v8]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 329#64) v8 []
  -- The working variables added to the hash value, and stored; the registers restored.
  braid_sym_run
  sha256_cell (hq + 1#64), (R.a + h0).setWidth 64
  sha256_cell (hq + 5#64), (R.b + h1).setWidth 64
  sha256_cell (hq + 9#64), (R.c + h2).setWidth 64
  sha256_cell (hq + 13#64), (R.d + h3).setWidth 64
  sha256_cell (hq + 17#64), (R.e + h4).setWidth 64
  sha256_cell (hq + 21#64), (R.f + h5).setWidth 64
  sha256_cell (hq + 25#64), (R.g + h6).setWidth 64
  sha256_cell (hq + 29#64), (R.h + h7).setWidth 64
  sha256_fold cells8_w32 true (hq + 1#64) (R.a + h0) (R.b + h1) (R.c + h2) (R.d + h3)
    (R.e + h4) (R.f + h5) (R.g + h6) (R.h + h7)
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 329#64) v8 []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 321#64) v9 [v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 313#64) v18 [v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 305#64) v19 [v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 297#64) v20 [v19, v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 289#64) v21 [v20, v19, v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 281#64) v22 [v21, v20, v19, v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 273#64) v23 [v22, v21, v20, v19, v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 265#64) v24 [v23, v22, v21, v20, v19, v18,
    v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 257#64) v25 [v24, v23, v22, v21, v20, v19,
    v18, v9, v8]
  braid_forget 11
  braid_forget 12
  braid_forget 13
  braid_forget 14
  braid_forget 15
  braid_forget 16
  braid_forget 17
  braid_forget 5
  braid_forget 6
  braid_forget 7
  braid_forget 28
  braid_done

/-- `sha256_compress` replaces the hash value its first argument points to by the
compression of it with the block its second argument points to. It reads the round constants
at `0x10404`, and uses 336 bytes of stack: the message schedule, and the ten callee-saved
registers it saves and restores. The two pointers are aligned to four bytes and the stack
pointer to eight. -/
theorem sha256_compress_spec (hp mp s r v8 v9 v18 v19 v20 v21 v22 v23 v24 v25 : Word)
    (H M : List W32) (wm wk : Bool)
    (fws sv : List Word) (x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 : Word)
    (hH : H.length = 8) (hM : M.length = 16) (hfw : fws.length = 64)
    (hsv : sv.length = 10) (hhp : hp &&& 3#64 = 0#64) (hmp : mp &&& 3#64 = 0#64)
    (hs : s &&& 7#64 = 0#64) :
    Triple sha256_compress.program
      (Atoms.interp (.pc 0x10160#64 :: .reg a0 hp :: .reg a1 mp :: .reg a2 x12 :: .reg a3 x13 ::
        [.reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .reg t3 x28, .reg t4 x29, .reg t5 x30, .reg t6 x31,
        .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg s3 v19, .reg s4 v20,
        .reg s5 v21, .reg s6 v22, .reg s7 v23, .reg s8 v24, .reg s9 v25, .reg sp s, .reg ra r,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x10404#64 (w32s K)),
        .prop (cellsAt 4 true (s - 336#64) fws), .prop (cellsAt 8 true (s - 80#64) sv)]))
      (Atoms.interp (.pc (r &&& ~~~1#64) :: .reg a0 hp :: .prop (regAny a1) ::
        .prop (regAny a2) :: .prop (regAny a3) :: [.prop (regAny a4), .prop (regAny a5),
        .prop (regAny a6), .prop (regAny a7), .prop (regAny t0), .prop (regAny t1),
        .prop (regAny t2), .prop (regAny t3), .prop (regAny t4), .prop (regAny t5),
        .prop (regAny t6),
        .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg s3 v19, .reg s4 v20,
        .reg s5 v21, .reg s6 v22, .reg s7 v23, .reg s8 v24, .reg s9 v25, .reg sp s, .reg ra r,
        .prop (cellsAt 4 true hp (w32s (compress H M))), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x10404#64 (w32s K)),
        .prop (cellsAt 4 true (s - 336#64) (w32s (schedule M))),
        .prop (cellsAt 8 true (s - 80#64) [v25, v24, v23, v22, v21, v20, v19, v18, v9, v8])])) := by
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ := eq_of_length_8 hH
  rw [compress_eq]
  braid_call compress_head_spec mp s v8 v9 v18 v19 v20 v21 v22 v23 v24 v25 M wm fws sv
    x12 x13 x14 x15 x16 x17 x5 x6 x7 hM hfw hsv hmp hs
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  braid_name_reg 16
  braid_name_reg 17
  braid_name_reg 5
  braid_name_reg 6
  braid_name_reg 7
  braid_call compress_rounds_spec hp s h0 h1 h2 h3 h4 h5 h6 h7 (schedule M) wk
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (schedule_length M hM) hhp hs
  generalize rounds (schedule M) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64 = R
  sha256_name_low 18 with xa hxa
  sha256_name_low 9 with xb hxb
  sha256_name_low 8 with xc hxc
  sha256_name_low 21 with xd hxd
  sha256_name_low 20 with xe hxe
  sha256_name_low 28 with xf hxf
  sha256_name_low 7 with xg hxg
  sha256_name_low 6 with xh hxh
  braid_name_reg 19
  braid_name_reg 22
  braid_name_reg 23
  braid_name_reg 24
  braid_name_reg 25
  braid_call compress_tail_spec hp s r h0 h1 h2 h3 h4 h5 h6 h7 R xa xb xc xd xe xf xg xh
    _ _ _ _ _ v8 v9 v18 v19 v20 v21 v22 v23 v24 v25 hhp hs hxa hxb hxc hxd hxe hxf hxg hxh
  braid_done

/-! ## On the machine -/

/-- **`sha256_compress` on the machine.** A machine that holds the code of `sha256_compress`,
is at its entry, and has in valid memory the hash value `H` (eight words) where `a0` points,
the block `M` (sixteen words) where `a1` points, the round constants of SHA-256 at `0x10404`,
where the code looks for them, and 336 bytes below the stack pointer (here 64 words `fws`
and ten double words `sv`, all of which are overwritten); with `a0` and `a1` aligned to four
bytes and the stack pointer to eight; where the hash value, the block, the round constants
and those 336 bytes of stack are pairwise apart; runs to the return address with the
compression of `H` with `M` where `a0` pointed. The block is as it was, and so are the stack
pointer and the callee-saved registers the code uses. The model has no read-only memory, so
the round constants are asked to be apart from what the code writes. -/
theorem sha256_compress_correct (s : MachineState) (H M fws : List W32) (sv : List Word)
    (hcode : ∀ p ∈ sha256_compress_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10160#64)
    (hH : H.length = 8) (hM : M.length = 16) (hfw : fws.length = 64)
    (hsvl : sv.length = 10)
    (hhp : s.getReg .x10 &&& 3#64 = 0#64) (hmp : s.getReg .x11 &&& 3#64 = 0#64)
    (hsp : s.getReg .x2 &&& 7#64 = 0#64)
    (hh : HasCells s (s.getReg .x10) H) (hm : HasCells s (s.getReg .x11) M)
    (hk : HasCells s 0x10404#64 K)
    (hws : HasCells s (s.getReg .x2 - 336#64) fws)
    (hsv : HasWords s (s.getReg .x2 - 80#64) sv)
    (hhm : Apart (s.getReg .x10) 32 (s.getReg .x11) 64)
    (hhk : Apart (s.getReg .x10) 32 0x10404#64 256)
    (hhs : Apart (s.getReg .x10) 32 (s.getReg .x2 - 336#64) 336)
    (hmk : Apart (s.getReg .x11) 64 0x10404#64 256)
    (hms : Apart (s.getReg .x11) 64 (s.getReg .x2 - 336#64) 336)
    (hks : Apart 0x10404#64 256 (s.getReg .x2 - 336#64) 336) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      HasCells s' (s.getReg .x10) (compress H M) ∧ HasCells s' (s.getReg .x11) M ∧
      s'.getReg .x2 = s.getReg .x2 ∧ s'.getReg .x8 = s.getReg .x8 ∧
      s'.getReg .x9 = s.getReg .x9 ∧ s'.getReg .x18 = s.getReg .x18 ∧
      s'.getReg .x19 = s.getReg .x19 ∧ s'.getReg .x20 = s.getReg .x20 ∧
      s'.getReg .x21 = s.getReg .x21 ∧ s'.getReg .x22 = s.getReg .x22 ∧
      s'.getReg .x23 = s.getReg .x23 ∧ s'.getReg .x24 = s.getReg .x24 ∧
      s'.getReg .x25 = s.getReg .x25 := by
  have hlK : K.length = 64 := rfl
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound_flat sha256_compress_lowered
    (sha256_compress_spec
      (s.getReg .x10) (s.getReg .x11) (s.getReg .x2) (s.getReg .x1) (s.getReg .x8)
      (s.getReg .x9) (s.getReg .x18) (s.getReg .x19) (s.getReg .x20) (s.getReg .x21)
      (s.getReg .x22) (s.getReg .x23) (s.getReg .x24) (s.getReg .x25)
      H M true true (w32s fws) sv
      (s.getReg .x12) (s.getReg .x13) (s.getReg .x14) (s.getReg .x15) (s.getReg .x16) (s.getReg
      .x17) (s.getReg .x5) (s.getReg .x6) (s.getReg .x7) (s.getReg .x28) (s.getReg .x29)
      (s.getReg .x30) (s.getReg .x31) hH hM
      (by simpa using hfw) hsvl hhp hmp hsp) hcode
    (flat := [.pc 0x10160#64, .reg a0 (s.getReg .x10), .reg a1 (s.getReg .x11), .reg a2
      (s.getReg .x12), .reg a3 (s.getReg .x13), .reg a4 (s.getReg .x14), .reg a5 (s.getReg
      .x15), .reg a6 (s.getReg .x16), .reg a7 (s.getReg .x17), .reg t0 (s.getReg .x5), .reg
      t1 (s.getReg .x6), .reg t2 (s.getReg .x7), .reg t3 (s.getReg .x28), .reg t4 (s.getReg
      .x29), .reg t5 (s.getReg .x30), .reg t6 (s.getReg .x31), .reg s0 (s.getReg .x8), .reg
      s1 (s.getReg .x9), .reg s2 (s.getReg .x18), .reg s3 (s.getReg .x19),
      .reg s4 (s.getReg .x20), .reg s5 (s.getReg .x21), .reg s6 (s.getReg .x22),
      .reg s7 (s.getReg .x23), .reg s8 (s.getReg .x24), .reg s9 (s.getReg .x25),
      .reg sp (s.getReg .x2), .reg ra (s.getReg .x1)] ++
      (cellsAtoms 4 true (s.getReg .x10) (w32s H) ++
      (cellsAtoms 4 true (s.getReg .x11) (w32s M) ++
      (cellsAtoms 4 true 0x10404#64 (w32s K) ++
      (cellsAtoms 4 true (s.getReg .x2 - 336#64) (w32s fws) ++
      (cellsAtoms 8 true (s.getReg .x2 - 80#64) sv ++ []))))))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩⟩⟩⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩⟩⟩⟩⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hH]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hM]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hlK]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hfw]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hsvl]), .nil, disj_nil_right⟩,
        -- the schedule, and what follows it
        disj_append_right (cellsAtoms_disj (by simp [hfw]; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right⟩,
        -- the round constants, and what follows them
        disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hfw])
            (by simp [hlK]) (by simp [hfw]))
          (disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hsvl])
            (by simp [hlK]) (by simp [hsvl]; bv_omega))
          disj_nil_right)⟩,
        -- the block, and what follows it
        disj_append_right (cellsAtoms_disj_of_apart hmk.1 hmk.2 (by simp [hM]) (by simp [hlK])
            (by simp [hM]) (by simp [hlK]))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hfw])
            (by simp [hM]) (by simp [hfw]))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hsvl])
            (by simp [hM]) (by simp [hsvl]; bv_omega))
          disj_nil_right))⟩,
        -- the hash value, and what follows it
        disj_append_right (cellsAtoms_disj (by rw [w32s_length, hH]; exact hhm.1)
            (by rw [w32s_length, hM]; exact hhm.2))
          (disj_append_right (cellsAtoms_disj_of_apart hhk.1 hhk.2 (by simp [hH]) (by simp [hlK])
            (by simp [hH]) (by simp [hlK]))
          (disj_append_right (cellsAtoms_disj_of_apart hhs.1 hhs.2 (by simp [hH]) (by simp [hfw])
            (by simp [hH]) (by simp [hfw]))
          (disj_append_right (cellsAtoms_disj_of_apart hhs.1 hhs.2 (by simp [hH]) (by simp [hsvl])
            (by simp [hH]) (by simp [hsvl]; bv_omega))
          disj_nil_right)))⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc],
        List.forall_mem_append.2 ⟨hh.sat,
        List.forall_mem_append.2 ⟨hm.sat,
        List.forall_mem_append.2 ⟨hk.sat,
        List.forall_mem_append.2 ⟨hws.sat,
        List.forall_mem_append.2 ⟨hsv.sat, by simp⟩⟩⟩⟩⟩⟩)
  refine ⟨n, s', hn, ?_, hasCells_of_holds hr hq (by braid_at),
    hasCells_of_holds hr hq (by braid_at), ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x2) (by decide)]; exact Atoms.reg_of_holds (r := 2) hq (by braid_at)
  · rw [← hr.getReg (r := .x8) (by decide)]; exact Atoms.reg_of_holds (r := 8) hq (by braid_at)
  · rw [← hr.getReg (r := .x9) (by decide)]; exact Atoms.reg_of_holds (r := 9) hq (by braid_at)
  · rw [← hr.getReg (r := .x18) (by decide)]
    exact Atoms.reg_of_holds (r := 18) hq (by braid_at)
  · rw [← hr.getReg (r := .x19) (by decide)]
    exact Atoms.reg_of_holds (r := 19) hq (by braid_at)
  · rw [← hr.getReg (r := .x20) (by decide)]
    exact Atoms.reg_of_holds (r := 20) hq (by braid_at)
  · rw [← hr.getReg (r := .x21) (by decide)]
    exact Atoms.reg_of_holds (r := 21) hq (by braid_at)
  · rw [← hr.getReg (r := .x22) (by decide)]
    exact Atoms.reg_of_holds (r := 22) hq (by braid_at)
  · rw [← hr.getReg (r := .x23) (by decide)]
    exact Atoms.reg_of_holds (r := 23) hq (by braid_at)
  · rw [← hr.getReg (r := .x24) (by decide)]
    exact Atoms.reg_of_holds (r := 24) hq (by braid_at)
  · rw [← hr.getReg (r := .x25) (by decide)]
    exact Atoms.reg_of_holds (r := 25) hq (by braid_at)

end Examples.Sha256.O2.RiscV
