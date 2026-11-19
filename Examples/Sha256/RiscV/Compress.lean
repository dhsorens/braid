/-
  Examples.Sha256.RiscV.Compress

  `sha256_compress` of `sha256.c` on RISC-V: the compression function of SHA-256. The
  compiler inlined `sha256_schedule` and `sha256_round` into it, and keeps the eight working
  variables in registers through the 64 rounds, so the proof has the two loops again, as loops
  of this function. Every loop of the code ends by comparing a pointer with the end of an
  array, and every access to memory is behind a guard for its alignment.

  The proof is in stages, and the terms of one stage do not reach the next:

  * the three short copying loops and the loop that adds the working variables to the hash
    value (sixteen, eight, eight and eight iterations of a fixed count) are run out by the
    stepper, the branch at the end of each iteration decided by `bv_decide`;
  * the message schedule is `compress_schedule_loop`, an induction with the sliding window
    of `Examples.Sha256.RiscV.Schedule` as its invariant;
  * a round is `compress_round_step`: one iteration run symbolically, the two tables opened
    at the index of the round, and each register then given the value of the specification's
    `round` in its low 32 bits (`regLow`), a goal about bit vectors for `bv_decide`. The
    registers are 64 bits wide and the code adds with the 64-bit `add`, so nothing is said
    of their high 32 bits;
  * the 64 rounds are `compress_rounds_loop`, an induction on the rounds left whose invariant
    is the specification's rounds so far (`roundsFrom`), which uses the round only through
    its triple.

  ## Main results

  * `sha256_compress_spec`: the specification, with `Sha256.compress`
  * `sha256_compress_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256.RiscV.Image
public import Examples.Sha256.RiscV.Machine
public import Examples.Sha256.RunTo

public section

namespace Examples.Sha256.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

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
      (Atoms.interp [.pc 0x10194#64, .reg a1 (q + 64#64), .reg a2 e, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .prop (cellsAt 4 true q (w32s win ++ j :: js))])
      (Atoms.interp [.pc 0x10204#64, .reg a1 e, .reg a2 e, .prop (regAny a3),
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
    braid_sym_run_to 0x10204
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
    braid_sym_run_to 0x10204
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
  `(tactic| (braid_forget 30; braid_forget 31; braid_forget 8; braid_forget 9
             braid_forget 18))

/-- After the instructions of a round: give the registers the values of the specification,
close the two arrays, and forget the intermediate values. -/
local macro "round_finish " kp:term ", " wp:term ", " ka:term ", " wa:term ", " wk:term ", "
    W:term ", " v:term ", " t:term ", " hK:term ", " hW:term ", " hka:term ", " hwa:term : tactic
        =>
  `(tactic| (sha256_low 7, (round $W $v $t).a
             sha256_low 12, (round $W $v $t).b
             sha256_low 13, (round $W $v $t).c
             sha256_low 28, (round $W $v $t).d
             sha256_low 29, (round $W $v $t).e
             sha256_low 14, (round $W $v $t).f
             sha256_low 15, (round $W $v $t).g
             sha256_low 16, (round $W $v $t).h
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
    (t : Nat) (ht : t < 64) (v : Vars) (ka wa xa xb xc xd xe xf xg xh y30 y31 y8 y9 y18 : Word)
    (hkp : kp &&& 3#64 = 0#64) (hwp : wp &&& 3#64 = 0#64) (hke : ke = kp + 256#64)
    (hka : ka = kp + BitVec.ofNat 64 (4 * t)) (hwa : wa = wp + BitVec.ofNat 64 (4 * t))
    (ha : xa.setWidth 32 = v.a) (hb : xb.setWidth 32 = v.b) (hc : xc.setWidth 32 = v.c)
    (hd : xd.setWidth 32 = v.d) (he : xe.setWidth 32 = v.e) (hf : xf.setWidth 32 = v.f)
    (hg : xg.setWidth 32 = v.g) (hh : xh.setWidth 32 = v.h) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x10254#64, .reg a7 ka, .reg t0 wa, .reg t1 ke,
        .reg t2 xa, .reg a2 xb, .reg a3 xc, .reg t3 xd, .reg t4 xe, .reg a4 xf, .reg a5 xg,
        .reg a6 xh, .reg t5 y30, .reg t6 y31, .reg s0 y8, .reg s1 y9, .reg s2 y18,
        .prop (cellsAt 4 wk kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))])
      (Atoms.interp [.pc (if t = 63 then 0x10314#64 else 0x10254#64),
        .reg a7 (ka + 4#64), .reg t0 (wa + 4#64), .reg t1 ke,
        .prop (regLow t2 (round W v t).a), .prop (regLow a2 (round W v t).b),
        .prop (regLow a3 (round W v t).c), .prop (regLow t3 (round W v t).d),
        .prop (regLow t4 (round W v t).e), .prop (regLow a4 (round W v t).f),
        .prop (regLow a5 (round W v t).g), .prop (regLow a6 (round W v t).h),
        .prop (regAny t5), .prop (regAny t6), .prop (regAny s0), .prop (regAny s1),
        .prop (regAny s2),
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
  `(tactic| (braid_name_reg 30; braid_name_reg 31; braid_name_reg 8; braid_name_reg 9
             braid_name_reg 18))

/-- The loop of rounds in `sha256_compress`, from round `t` to the last: an induction on
the number of rounds left, each of them `compress_round_step`. -/
theorem compress_rounds_loop (kp wp ke : Word) (wk : Bool) (W : List W32) (hW : W.length = 64)
    (hkp : kp &&& 3#64 = 0#64) (hwp : wp &&& 3#64 = 0#64) (hke : ke = kp + 256#64) :
    ∀ (n t : Nat) (v : Vars) (ka wa xa xb xc xd xe xf xg xh y30 y31 y8 y9 y18 : Word),
    t + n + 1 = 64 → ka = kp + BitVec.ofNat 64 (4 * t) → wa = wp + BitVec.ofNat 64 (4 * t) →
    xa.setWidth 32 = v.a → xb.setWidth 32 = v.b → xc.setWidth 32 = v.c →
    xd.setWidth 32 = v.d → xe.setWidth 32 = v.e → xf.setWidth 32 = v.f →
    xg.setWidth 32 = v.g → xh.setWidth 32 = v.h →
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x10254#64, .reg a7 ka, .reg t0 wa, .reg t1 ke,
        .reg t2 xa, .reg a2 xb, .reg a3 xc, .reg t3 xd, .reg t4 xe, .reg a4 xf, .reg a5 xg,
        .reg a6 xh, .reg t5 y30, .reg t6 y31, .reg s0 y8, .reg s1 y9, .reg s2 y18,
        .prop (cellsAt 4 wk kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))])
      (Atoms.interp [.pc 0x10314#64, .prop (regAny a7), .prop (regAny t0), .reg t1 ke,
        .prop (regLow t2 (roundsFrom W t (n + 1) v).a), .prop (regLow a2 (roundsFrom W t (n + 1)
        v).b), .prop (regLow a3 (roundsFrom W t (n + 1) v).c), .prop (regLow t3 (roundsFrom W t (n
        + 1) v).d), .prop (regLow t4 (roundsFrom W t (n + 1) v).e), .prop (regLow a4 (roundsFrom W
        t (n + 1) v).f), .prop (regLow a5 (roundsFrom W t (n + 1) v).g), .prop (regLow a6
        (roundsFrom W t (n + 1) v).h),
        .prop (regAny t5), .prop (regAny t6), .prop (regAny s0), .prop (regAny s1),
        .prop (regAny s2),
        .prop (cellsAt 4 wk kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))]) := by
  intro n
  induction n with
  | zero =>
    intro t v ka wa xa xb xc xd xe xf xg xh y30 y31 y8 y9 y18 hn hka hwa ha hb hc hd he hf hg hh
    obtain rfl : t = 63 := by omega
    rw [roundsFrom_one]
    braid_call compress_round_step kp wp ke wk W hW 63 (by omega) v ka wa xa xb xc xd xe xf xg xh
      y30 y31 y8 y9 y18 hkp hwp hke hka hwa ha hb hc hd he hf hg hh
    braid_forget 17
    braid_forget 5
    braid_done
  | succ n ih =>
    intro t v ka wa xa xb xc xd xe xf xg xh y30 y31 y8 y9 y18 hn hka hwa ha hb hc hd he hf hg hh
    have h63 : t ≠ 63 := by omega
    rw [roundsFrom_succ]
    braid_call compress_round_step kp wp ke wk W hW t (by omega) v ka wa xa xb xc xd xe xf xg xh
      y30 y31 y8 y9 y18 hkp hwp hke hka hwa ha hb hc hd he hf hg hh
    simp only [h63, ↓reduceIte]
    round_name
    sha256_name_low 7 with xa' ha'
    sha256_name_low 12 with xb' hb'
    sha256_name_low 13 with xc' hc'
    sha256_name_low 28 with xd' hd'
    sha256_name_low 29 with xe' he'
    sha256_name_low 14 with xf' hf'
    sha256_name_low 15 with xg' hg'
    sha256_name_low 16 with xh' hh'
    braid_call ih (t + 1) (round W v t) (ka + 4#64) (wa + 4#64) xa' xb' xc' xd' xe' xf' xg' xh'
      _ _ _ _ _ (by omega) (by rw [hka, BitVec.add_assoc, ofNat_mul4_succ])
      (by rw [hwa, BitVec.add_assoc, ofNat_mul4_succ]) ha' hb' hc' hd' he' hf' hg' hh'
    braid_done

/-! ## The compression function -/

/-- One iteration of a copying loop that is not the last: run to the branch at its end, which
compares two pointers, and take it, as the pointers differ. -/
local macro "loop_again" : tactic =>
  `(tactic| (braid_sym_run_to 0
             rotate_left
             · exfalso; bv_decide
             clear ‹¬(_ : Word) = _›))

/-- `sha256_compress` replaces the hash value its first argument points to by the
compression of it with the block its second argument points to. It reads the round constants
at `0x10368`, and uses 312 bytes of stack: the working variables, the message schedule, and
the three callee-saved registers it saves and restores. The two pointers are aligned to four
bytes and the stack pointer to eight. It leaves `a0` at the end of the hash value. -/
theorem sha256_compress_spec (hp mp s r v8 v9 v18 : Word) (H M : List W32) (wm wk : Bool)
    (fvs fws sv : List Word) (x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 : Word)
    (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 8) (hfw : fws.length = 64)
    (hsv : sv.length = 3) (hhp : hp &&& 3#64 = 0#64) (hmp : mp &&& 3#64 = 0#64)
    (hs : s &&& 7#64 = 0#64) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x10160#64, .reg a0 hp, .reg a1 mp, .reg a2 x12, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .reg t3 x28, .reg t4 x29, .reg t5 x30, .reg t6 x31, .reg s0 v8,
        .reg s1 v9, .reg s2 v18, .reg sp s, .reg ra r,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x10368#64 (w32s K)),
        .prop (cellsAt 4 true (s - 312#64) fvs), .prop (cellsAt 4 true (s - 280#64) fws),
        .prop (cellsAt 8 true (s - 24#64) sv)])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (hp + 32#64), .prop (regAny a1),
        .prop (regAny a2), .prop (regAny a3), .prop (regAny a4), .prop (regAny a5),
        .prop (regAny a6), .prop (regAny a7), .prop (regAny t0), .prop (regAny t1),
        .prop (regAny t2), .prop (regAny t3), .prop (regAny t4), .prop (regAny t5),
        .prop (regAny t6), .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg sp s, .reg ra r,
        .prop (cellsAt 4 true hp (w32s (compress H M))), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x10368#64 (w32s K)),
        .prop (cellsAt 4 true (s - 312#64)
          (w32s (rounds (schedule M) (Vars.ofList H) 64).toList)),
        .prop (cellsAt 4 true (s - 280#64) (w32s (schedule M))),
        .prop (cellsAt 8 true (s - 24#64) [v18, v9, v8])]) := by
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ := eq_of_length_8 hH
  obtain ⟨m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15, rfl⟩ :=
    eq_of_length_16 hM
  obtain ⟨f0, f1, f2, f3, f4, f5, f6, f7, rfl⟩ := eq_of_length_8 hfv
  obtain ⟨g0, g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12, g13, g14, g15, js, rfl, hjs⟩ :=
    eq_of_length_16_add (n := 48) hfw
  obtain ⟨j, js', rfl⟩ : ∃ j js', js = j :: js' := by
    cases js with
    | nil => simp at hjs
    | cons a b => exact ⟨a, b, rfl⟩
  have h47 : js'.length = 47 := by simpa using hjs
  obtain ⟨sv0, sv1, sv2, rfl⟩ : ∃ sv0 sv1 sv2, sv = [sv0, sv1, sv2] := by
    match sv, hsv with
    | [sv0, sv1, sv2], _ => exact ⟨sv0, sv1, sv2, rfl⟩
  rw [compress_eq, Vars.ofList_eq]
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨mq, rfl⟩ : ∃ mq : BitVec 64, mp = mq + 1#64 := ⟨mp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 313#64 := ⟨s - 313#64, by bv_omega⟩
  braid_unfold cells8_w32 true (hq + 1#64) h0 h1 h2 h3 h4 h5 h6 h7
  braid_unfold cells16_w32 wm (mq + 1#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
  braid_unfold cells8 true (sq + 1#64) f0 f1 f2 f3 f4 f5 f6 f7
  braid_unfold cells_pre16 true (sq + 33#64) g0 g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 g11 g12 g13
    g14 g15 (j :: js')
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 289#64) sv0 [sv1, sv2]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 297#64) sv1 [sv2]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 305#64) sv2 []
  -- The frame, and the block copied to the start of the schedule.
  iterate 15 loop_again
  braid_sym_run_to 0x10194
  -- The message schedule.
  sha256_cell (sq + 33#64), m0.setWidth 64
  sha256_cell (sq + 37#64), m1.setWidth 64
  sha256_cell (sq + 41#64), m2.setWidth 64
  sha256_cell (sq + 45#64), m3.setWidth 64
  sha256_cell (sq + 49#64), m4.setWidth 64
  sha256_cell (sq + 53#64), m5.setWidth 64
  sha256_cell (sq + 57#64), m6.setWidth 64
  sha256_cell (sq + 61#64), m7.setWidth 64
  sha256_cell (sq + 65#64), m8.setWidth 64
  sha256_cell (sq + 69#64), m9.setWidth 64
  sha256_cell (sq + 73#64), m10.setWidth 64
  sha256_cell (sq + 77#64), m11.setWidth 64
  sha256_cell (sq + 81#64), m12.setWidth 64
  sha256_cell (sq + 85#64), m13.setWidth 64
  sha256_cell (sq + 89#64), m14.setWidth 64
  sha256_cell (sq + 93#64), m15.setWidth 64
  sha256_fold cells_win16 true (sq + 33#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
    (j :: js')
  braid_call compress_schedule_loop (sq + 289#64) js' [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9,
      m10, m11, m12, m13, m14, m15] j (sq + 33#64) _ _ _ _ _ _ _ _ rfl (by bv_decide)
    (by rw [h47]; bv_omega) (by omega)
  simp only [h47, Nat.reduceAdd]
  rw [← schedule_eq_extend [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15]
    rfl]
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  braid_name_reg 16
  braid_name_reg 17
  braid_name_reg 5
  braid_name_reg 6
  braid_name_reg 7
  -- The hash value copied to the working variables, and those loaded into registers.
  iterate 7 loop_again
  braid_sym_run_to 0x10254
  sha256_reg 7, BitVec.signExtend 64 h0
  sha256_reg 12, BitVec.signExtend 64 h1
  sha256_reg 13, BitVec.signExtend 64 h2
  sha256_reg 28, BitVec.signExtend 64 h3
  sha256_reg 29, BitVec.signExtend 64 h4
  sha256_reg 14, BitVec.signExtend 64 h5
  sha256_reg 15, BitVec.signExtend 64 h6
  sha256_reg 16, BitVec.signExtend 64 h7
  -- The rounds.
  braid_call compress_rounds_loop 0x10368#64 (sq + 33#64) 0x10468#64 wk (schedule [m0, m1, m2, m3,
      m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15])
    (schedule_length _ rfl) (by decide) (by bv_decide) (by decide) 63 0 ⟨h0, h1, h2, h3, h4, h5,
        h6, h7⟩
    0x10368#64 (sq + 33#64) (BitVec.signExtend 64 h0) (BitVec.signExtend 64 h1) (BitVec.signExtend
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
  generalize rounds (schedule [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14,
      m15]) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64 = R
  sha256_name_low 7 with xa hxa
  sha256_name_low 12 with xb hxb
  sha256_name_low 13 with xc hxc
  sha256_name_low 28 with xd hxd
  sha256_name_low 29 with xe hxe
  sha256_name_low 14 with xf hxf
  sha256_name_low 15 with xg hxg
  sha256_name_low 16 with xh hxh
  braid_name_reg 8
  braid_name_reg 9
  braid_name_reg 18
  -- The working variables stored, and added to the hash value; the registers restored.
  iterate 7 loop_again
  braid_sym_run
  sha256_cell (hq + 1#64), (R.a + h0).setWidth 64
  sha256_cell (hq + 5#64), (R.b + h1).setWidth 64
  sha256_cell (hq + 9#64), (R.c + h2).setWidth 64
  sha256_cell (hq + 13#64), (R.d + h3).setWidth 64
  sha256_cell (hq + 17#64), (R.e + h4).setWidth 64
  sha256_cell (hq + 21#64), (R.f + h5).setWidth 64
  sha256_cell (hq + 25#64), (R.g + h6).setWidth 64
  sha256_cell (hq + 29#64), (R.h + h7).setWidth 64
  sha256_cell (sq + 1#64), R.a.setWidth 64
  sha256_cell (sq + 5#64), R.b.setWidth 64
  sha256_cell (sq + 9#64), R.c.setWidth 64
  sha256_cell (sq + 13#64), R.d.setWidth 64
  sha256_cell (sq + 17#64), R.e.setWidth 64
  sha256_cell (sq + 21#64), R.f.setWidth 64
  sha256_cell (sq + 25#64), R.g.setWidth 64
  sha256_cell (sq + 29#64), R.h.setWidth 64
  sha256_fold cells8_w32 true (hq + 1#64) (R.a + h0) (R.b + h1) (R.c + h2) (R.d + h3)
    (R.e + h4) (R.f + h5) (R.g + h6) (R.h + h7)
  sha256_fold cells16_w32 wm (mq + 1#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
  sha256_fold cells_vars true (sq + 1#64) R
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 305#64) v8 []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 297#64) v9 [v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 289#64) v18 [v9, v8]
  braid_forget 11
  braid_forget 12
  braid_forget 13
  braid_forget 14
  braid_forget 15
  braid_forget 16
  braid_forget 6
  braid_forget 7
  braid_forget 28
  braid_forget 29
  braid_done

/-! ## On the machine -/

/-- **`sha256_compress` on the machine.** A machine that holds the code of `sha256_compress`,
is at its entry, and has in valid memory the hash value `H` (eight words) where `a0` points,
the block `M` (sixteen words) where `a1` points, the round constants of SHA-256 at `0x10368`,
where the code looks for them, and 312 bytes below the stack pointer (here eight words `fvs`,
64 words `fws` and three double words `sv`, all of which are overwritten); with `a0` and `a1`
aligned to four bytes and the stack pointer to eight; where the hash value, the block, the
round constants and those 312 bytes of stack are pairwise apart; runs to the return address
with the compression of `H` with `M` where `a0` pointed. The block is as it was, and so are
the stack pointer and the callee-saved registers the code uses. The model has no read-only
memory, so the round constants are asked to be apart from what the code writes. -/
theorem sha256_compress_correct (s : MachineState) (H M fvs fws : List W32) (sv : List Word)
    (hcode : ∀ p ∈ sha256_compress_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10160#64)
    (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 8) (hfw : fws.length = 64)
    (hsvl : sv.length = 3)
    (hhp : s.getReg .x10 &&& 3#64 = 0#64) (hmp : s.getReg .x11 &&& 3#64 = 0#64)
    (hsp : s.getReg .x2 &&& 7#64 = 0#64)
    (hh : HasCells s (s.getReg .x10) H) (hm : HasCells s (s.getReg .x11) M)
    (hk : HasCells s 0x10368#64 K)
    (hv : HasCells s (s.getReg .x2 - 312#64) fvs) (hws : HasCells s (s.getReg .x2 - 280#64) fws)
    (hsv : HasWords s (s.getReg .x2 - 24#64) sv)
    (hhm : Apart (s.getReg .x10) 32 (s.getReg .x11) 64)
    (hhk : Apart (s.getReg .x10) 32 0x10368#64 256)
    (hhs : Apart (s.getReg .x10) 32 (s.getReg .x2 - 312#64) 312)
    (hmk : Apart (s.getReg .x11) 64 0x10368#64 256)
    (hms : Apart (s.getReg .x11) 64 (s.getReg .x2 - 312#64) 312)
    (hks : Apart 0x10368#64 256 (s.getReg .x2 - 312#64) 312) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      HasCells s' (s.getReg .x10) (compress H M) ∧ HasCells s' (s.getReg .x11) M ∧
      s'.getReg .x2 = s.getReg .x2 ∧ s'.getReg .x8 = s.getReg .x8 ∧
      s'.getReg .x9 = s.getReg .x9 ∧ s'.getReg .x18 = s.getReg .x18 := by
  have hlK : K.length = 64 := rfl
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound_flat sha256_compress_lowered
    (sha256_compress_spec
      (s.getReg .x10) (s.getReg .x11) (s.getReg .x2) (s.getReg .x1) (s.getReg .x8) (s.getReg
      .x9) (s.getReg .x18) H M true true (w32s fvs) (w32s fws) sv
      (s.getReg .x12) (s.getReg .x13) (s.getReg .x14) (s.getReg .x15) (s.getReg .x16) (s.getReg
      .x17) (s.getReg .x5) (s.getReg .x6) (s.getReg .x7) (s.getReg .x28) (s.getReg .x29)
      (s.getReg .x30) (s.getReg .x31) hH hM
      (by simpa using hfv) (by simpa using hfw) hsvl hhp hmp hsp) hcode
    (flat := [.pc 0x10160#64, .reg a0 (s.getReg .x10), .reg a1 (s.getReg .x11), .reg a2
      (s.getReg .x12), .reg a3 (s.getReg .x13), .reg a4 (s.getReg .x14), .reg a5 (s.getReg
      .x15), .reg a6 (s.getReg .x16), .reg a7 (s.getReg .x17), .reg t0 (s.getReg .x5), .reg
      t1 (s.getReg .x6), .reg t2 (s.getReg .x7), .reg t3 (s.getReg .x28), .reg t4 (s.getReg
      .x29), .reg t5 (s.getReg .x30), .reg t6 (s.getReg .x31), .reg s0 (s.getReg .x8), .reg
      s1 (s.getReg .x9), .reg s2 (s.getReg .x18), .reg sp (s.getReg .x2), .reg ra (s.getReg
      .x1)] ++
      (cellsAtoms 4 true (s.getReg .x10) (w32s H) ++
      (cellsAtoms 4 true (s.getReg .x11) (w32s M) ++
      (cellsAtoms 4 true 0x10368#64 (w32s K) ++
      (cellsAtoms 4 true (s.getReg .x2 - 312#64) (w32s fvs) ++
      (cellsAtoms 4 true (s.getReg .x2 - 280#64) (w32s fws) ++
      (cellsAtoms 8 true (s.getReg .x2 - 24#64) sv ++ [])))))))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩⟩⟩⟩⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩⟩⟩⟩⟩⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hH]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hM]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hlK]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hfv]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hfw]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hsvl]), .nil, disj_nil_right⟩,
        -- the schedule, and what follows it
        disj_append_right (cellsAtoms_disj (by simp [hfw]; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right⟩,
        -- the working variables, and what follows them
        disj_append_right (cellsAtoms_disj (by simp [hfv]; bv_omega) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hfv]; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right)⟩,
        -- the round constants, and what follows them
        disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hfv])
            (by simp [hlK]) (by simp [hfv]))
          (disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hfw])
            (by simp [hlK]) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hsvl])
            (by simp [hlK]) (by simp [hsvl]; bv_omega))
          disj_nil_right))⟩,
        -- the block, and what follows it
        disj_append_right (cellsAtoms_disj_of_apart hmk.1 hmk.2 (by simp [hM]) (by simp [hlK])
            (by simp [hM]) (by simp [hlK]))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hfv])
            (by simp [hM]) (by simp [hfv]))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hfw])
            (by simp [hM]) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hsvl])
            (by simp [hM]) (by simp [hsvl]; bv_omega))
          disj_nil_right)))⟩,
        -- the hash value, and what follows it
        disj_append_right (cellsAtoms_disj (by rw [w32s_length, hH]; exact hhm.1)
            (by rw [w32s_length, hM]; exact hhm.2))
          (disj_append_right (cellsAtoms_disj_of_apart hhk.1 hhk.2 (by simp [hH]) (by simp [hlK])
            (by simp [hH]) (by simp [hlK]))
          (disj_append_right (cellsAtoms_disj_of_apart hhs.1 hhs.2 (by simp [hH]) (by simp [hfv])
            (by simp [hH]) (by simp [hfv]))
          (disj_append_right (cellsAtoms_disj_of_apart hhs.1 hhs.2 (by simp [hH]) (by simp [hfw])
            (by simp [hH]) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hhs.1 hhs.2 (by simp [hH]) (by simp [hsvl])
            (by simp [hH]) (by simp [hsvl]; bv_omega))
          disj_nil_right))))⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc],
        List.forall_mem_append.2 ⟨hh.sat,
        List.forall_mem_append.2 ⟨hm.sat,
        List.forall_mem_append.2 ⟨hk.sat,
        List.forall_mem_append.2 ⟨hv.sat,
        List.forall_mem_append.2 ⟨hws.sat,
        List.forall_mem_append.2 ⟨hsv.sat, by simp⟩⟩⟩⟩⟩⟩⟩)
  refine ⟨n, s', hn, ?_, hasCells_of_holds hr hq (by braid_at),
    hasCells_of_holds hr hq (by braid_at), ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x2) (by decide)]; exact Atoms.reg_of_holds (r := 2) hq (by braid_at)
  · rw [← hr.getReg (r := .x8) (by decide)]; exact Atoms.reg_of_holds (r := 8) hq (by braid_at)
  · rw [← hr.getReg (r := .x9) (by decide)]; exact Atoms.reg_of_holds (r := 9) hq (by braid_at)
  · rw [← hr.getReg (r := .x18) (by decide)]
    exact Atoms.reg_of_holds (r := 18) hq (by braid_at)

end Examples.Sha256.RiscV
