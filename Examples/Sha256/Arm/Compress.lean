/-
  Examples.Sha256.Arm.Compress

  `sha256_compress` of `sha256.c` on AArch64: the compression function of SHA-256. The
  compiler inlined `sha256_schedule` and `sha256_round` into it, and keeps the eight working
  variables in registers through the 64 rounds, so the proof has the two loops again, as loops
  of this function.

  The proof is in stages, and the terms of one stage do not reach the next:

  * the three short copying loops (sixteen, eight and eight iterations of a fixed count) are
    run out by the stepper;
  * the message schedule is `compress_schedule_loop`, an induction with the sliding window
    of `Examples.Sha256.Arm.Schedule` as its invariant;
  * a round is `compress_round_step`: one iteration run symbolically, the two tables opened
    at the index of the round, and each register then given the value of the specification's
    `round`, a goal about bit vectors for `bv_auto`;
  * the 64 rounds are `compress_rounds_loop`, an induction on the rounds left whose invariant
    is the specification's rounds so far (`roundsFrom`), which uses the round only through
    its triple.

  ## Main results

  * `sha256_compress_spec`: the specification, with `Sha256.compress`
  * `sha256_compress_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256.Arm.Image
public import Examples.Sha256.Arm.Machine
public import Examples.Sha256.RunTo
import Braid.BV

public section

namespace Examples.Sha256.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- Forget what the loop of the schedule leaves in the registers it uses and in the flags. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 8; braid_forget 10; braid_forget 11; braid_forget 12
             braid_forget 13; braid_forget 14; braid_forget 15
             braid_forget_flag 0; braid_forget_flag 1; braid_forget_flag 2
             braid_forget_flag 3))

/-! ## The message schedule -/

/-- The loop of the message schedule in `sha256_compress`, where `sha256_schedule` is
inlined: with a window of sixteen words of the schedule at `q` and `js.length + 1` cells
after it, fill those cells with the next words of the schedule. -/
theorem compress_schedule_loop : ∀ (js : List Word) (win : List W32) (j : Word)
    (q c t10 t11 t12 t13 t14 t15 : Word) (fn fz fc fv : Bool), win.length = 16 →
    c = BitVec.ofNat 64 (js.length + 1) → js.length + 1 < 2 ^ 64 →
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x100ec#64, .reg x9 c, .reg x8 (q + 64#64),
        .reg x10 t10, .reg x11 t11, .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 true q (w32s win ++ j :: js))])
      (Atoms.interp [.pc 0x10128#64, .reg x9 0#64, .prop (regAny x8),
        .prop (regAny x10), .prop (regAny x11), .prop (regAny x12), .prop (regAny x13),
        .prop (regAny x14), .prop (regAny x15),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 4 true q (w32s (extend (js.length + 1) win)))]) := by
  intro js
  induction js with
  | nil =>
    intro win j q c t10 t11 t12 t13 t14 t15 fn fz fc fv hw he hb
    obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
      eq_of_length_16 hw
    have he' : c = 1#64 := by simpa using he
    subst he'
    simp only [List.length_nil, Nat.zero_add]
    rw [w32s_extend_one]
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    braid_unfold cells_win17 true (q' + 1#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
      j []
    braid_sym_run_to 0x10128
    sha256_cell (q' + 65#64), (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12,
      w13, w14, w15]).setWidth 64
    sha256_fold cells_win17 true (q' + 1#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
      ((nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]).setWidth
        64) []
    schedule_forget
    braid_done
  | cons j' js ih =>
    intro win j q c t10 t11 t12 t13 t14 t15 fn fz fc fv hw he hb
    obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
      eq_of_length_16 hw
    simp only [List.length_cons] at he hb ⊢
    rw [w32s_extend_succ]
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    braid_unfold cells_win17 true (q' + 1#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
      j (j' :: js)
    braid_sym_run
    · sha256_cell (q' + 65#64), (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12,
        w13, w14, w15]).setWidth 64
      sha256_fold cells_win16 true (q' + 5#64) w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
        (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]) (j' :: js)
      braid_call ih [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, nextWord
        [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]]
        j' (q' + 5#64) (c + 18446744073709551615#64) _ _ _ _ _ _ _ _ _ _ rfl
        (by rw [he]; bv_omega) (by omega)
      sha256_fold cellsAt_cons (k := 4) (w := true) (q' + 1#64) (w0.setWidth 64)
        (w32s (extend (js.length + 1) [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14,
          w15,
          nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]]))
      braid_done
    · exfalso
      have : c ≠ 1#64 := by rw [he]; bv_omega
      exact this hbr

/-! ## The rounds -/

/-- Forget what a round leaves in the registers it uses for intermediate values, and in the
flags. -/
local macro "round_forget" : tactic =>
  `(tactic| (braid_forget 1; braid_forget 2; braid_forget 3; braid_forget 4; braid_forget 5
             braid_forget_flag 0; braid_forget_flag 1; braid_forget_flag 2
             braid_forget_flag 3))

/-- Name the values a round left in the registers it uses for intermediate values, and in
the flags. -/
local macro "round_name" : tactic =>
  `(tactic| (braid_name_reg 1; braid_name_reg 2; braid_name_reg 3; braid_name_reg 4
             braid_name_reg 5; braid_name_flag 0; braid_name_flag 1; braid_name_flag 2
             braid_name_flag 3))

/-- Give the registers of the working variables the values of the specification's round. -/
local macro "round_values " W:term ", " v:term ", " t:term : tactic =>
  `(tactic| (sha256_reg 17, (round $W $v $t).a.setWidth 64
             sha256_reg 9, (round $W $v $t).b.setWidth 64
             sha256_reg 10, (round $W $v $t).c.setWidth 64
             sha256_reg 12, (round $W $v $t).d.setWidth 64
             sha256_reg 18, (round $W $v $t).e.setWidth 64
             sha256_reg 11, (round $W $v $t).f.setWidth 64
             sha256_reg 13, (round $W $v $t).g.setWidth 64
             sha256_reg 14, (round $W $v $t).h.setWidth 64))

/-- After the instructions of a round: give the registers the values of the specification,
and close the two arrays. -/
local macro "round_finish " kq:term ", " wq:term ", " W:term ", " v:term ", " t:term ", "
    hK:term ", " hW:term : tactic =>
  `(tactic| (round_values $W, $v, $t
             refine Triple.reg_val (r := 8) (BitVec.ofNat 64 (4 * ($t + 1))) (by braid_upd)
               (ofNat_mul4_succ $t) ?_
             sha256_fold cells_w32_index false ($kq + 1#64) K $t $hK
             sha256_fold cells_w32_index true ($wq + 1#64) $W $t $hW
             round_forget
             braid_done))

/-- One iteration of the loop of rounds in `sha256_compress`, where `sha256_round` is
inlined and the working variables are in registers: round `t`, with the round constants at
`kp` and the schedule at `wp`. It ends at the head of the loop, or after it when `t` is the
last round. -/
theorem compress_round_step (kp wp : Word) (W : List W32) (hW : W.length = 64) (t : Nat)
    (ht : t < 64) (v : Vars) (t1 t2 t3 t4 t5 : Word) (fn fz fc fv : Bool) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x10164#64, .reg x1 t1, .reg x2 t2, .reg x3 t3, .reg x4 t4,
        .reg x5 t5, .reg x8 (BitVec.ofNat 64 (4 * t)), .reg x15 kp, .reg x16 wp,
        .reg x17 (v.a.setWidth 64), .reg x9 (v.b.setWidth 64), .reg x10 (v.c.setWidth 64),
        .reg x12 (v.d.setWidth 64), .reg x18 (v.e.setWidth 64), .reg x11 (v.f.setWidth 64),
        .reg x13 (v.g.setWidth 64), .reg x14 (v.h.setWidth 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 false kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))])
      (Atoms.interp [.pc (if t = 63 then 0x101e8#64 else 0x10164#64),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x3), .prop (regAny x4),
        .prop (regAny x5), .reg x8 (BitVec.ofNat 64 (4 * (t + 1))), .reg x15 kp, .reg x16 wp,
        .reg x17 ((round W v t).a.setWidth 64),
        .reg x9 ((round W v t).b.setWidth 64), .reg x10 ((round W v t).c.setWidth 64),
        .reg x12 ((round W v t).d.setWidth 64), .reg x18 ((round W v t).e.setWidth 64),
        .reg x11 ((round W v t).f.setWidth 64), .reg x13 ((round W v t).g.setWidth 64),
        .reg x14 ((round W v t).h.setWidth 64),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 4 false kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))]) := by
  have hK : t < K.length := ht
  obtain ⟨kq, rfl⟩ : ∃ kq : BitVec 64, kp = kq + 1#64 := ⟨kp - 1#64, by bv_omega⟩
  obtain ⟨wq, rfl⟩ : ∃ wq : BitVec 64, wp = wq + 1#64 := ⟨wp - 1#64, by bv_omega⟩
  braid_unfold cells_w32_index false (kq + 1#64) K t hK
  braid_unfold cells_w32_index true (wq + 1#64) W t (hW ▸ ht)
  braid_sym_run
  · have h63 : t ≠ 63 := by rintro rfl; exact hbr (by decide)
    simp only [h63, ↓reduceIte]
    round_finish kq, wq, W, v, t, hK, hW ▸ ht
  · obtain rfl : t = 63 := by bv_omega
    simp only [↓reduceIte]
    round_finish kq, wq, W, v, 63, hK, hW ▸ ht

/-- The loop of rounds in `sha256_compress`, from round `t` to the last: an induction on
the number of rounds left, each of them `compress_round_step`. -/
theorem compress_rounds_loop (kp wp : Word) (W : List W32) (hW : W.length = 64) :
    ∀ (n t : Nat) (v : Vars) (t1 t2 t3 t4 t5 : Word) (fn fz fc fv : Bool), t + n + 1 = 64 →
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x10164#64, .reg x1 t1, .reg x2 t2, .reg x3 t3, .reg x4 t4,
        .reg x5 t5, .reg x8 (BitVec.ofNat 64 (4 * t)), .reg x15 kp, .reg x16 wp,
        .reg x17 (v.a.setWidth 64), .reg x9 (v.b.setWidth 64), .reg x10 (v.c.setWidth 64),
        .reg x12 (v.d.setWidth 64), .reg x18 (v.e.setWidth 64), .reg x11 (v.f.setWidth 64),
        .reg x13 (v.g.setWidth 64), .reg x14 (v.h.setWidth 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 false kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))])
      (Atoms.interp [.pc 0x101e8#64,
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x3), .prop (regAny x4),
        .prop (regAny x5), .reg x8 256#64, .reg x15 kp, .reg x16 wp,
        .reg x17 ((roundsFrom W t (n + 1) v).a.setWidth 64),
        .reg x9 ((roundsFrom W t (n + 1) v).b.setWidth 64), .reg x10 ((roundsFrom W t (n + 1)
          v).c.setWidth 64),
        .reg x12 ((roundsFrom W t (n + 1) v).d.setWidth 64), .reg x18 ((roundsFrom W t (n + 1)
          v).e.setWidth 64),
        .reg x11 ((roundsFrom W t (n + 1) v).f.setWidth 64), .reg x13 ((roundsFrom W t (n + 1)
          v).g.setWidth 64),
        .reg x14 ((roundsFrom W t (n + 1) v).h.setWidth 64),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 4 false kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))]) := by
  intro n
  induction n with
  | zero =>
    intro t v t1 t2 t3 t4 t5 fn fz fc fv hn
    obtain rfl : t = 63 := by omega
    rw [roundsFrom_one]
    braid_call compress_round_step kp wp W hW 63 (by omega) v t1 t2 t3 t4 t5 fn fz fc fv
    braid_done
  | succ n ih =>
    intro t v t1 t2 t3 t4 t5 fn fz fc fv hn
    have h63 : t ≠ 63 := by omega
    rw [roundsFrom_succ]
    braid_call compress_round_step kp wp W hW t (by omega) v t1 t2 t3 t4 t5 fn fz fc fv
    simp only [h63, ↓reduceIte]
    round_name
    braid_call ih (t + 1) (round W v t) _ _ _ _ _ _ _ _ _ (by omega)
    braid_done

/-! ## The compression function -/

/-- `sha256_compress` replaces the hash value its first argument points to by the
compression of it with the block its second argument points to. It reads the round
constants from read-only data at `0x20228`, and uses 304 bytes of stack: the working
variables, the message schedule, and the frame pointer it saves and restores. -/
theorem sha256_compress_spec (hp mp s r fp sv : Word) (H M : List W32) (wm : Bool)
    (fvs fws : List Word) (t2 t3 t4 t5 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 : Word)
    (fn fz fc fv : Bool) (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 8)
    (hfw : fws.length = 64) (hs : s &&& 15#64 = 0#64) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x100bc#64, .reg x0 hp, .reg x1 mp, .reg x2 t2, .reg x3 t3,
        .reg x4 t4, .reg x5 t5, .reg x8 t8, .reg x9 t9, .reg x10 t10, .reg x11 t11,
        .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15, .reg x16 t16, .reg x17 t17,
        .reg x18 t18, .reg x29 fp, .reg lr r, .reg sp s,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 false 0x20228#64 (w32s K)),
        .prop (cellsAt 4 true (s - 0x130#64) fvs), .prop (cellsAt 4 true (s - 0x110#64) fws),
        .prop (cellsAt 8 true (s - 0x10#64) [sv])])
      (Atoms.interp [.pc r, .reg x0 hp, .prop (regAny x1), .prop (regAny x2),
        .prop (regAny x3), .prop (regAny x4), .prop (regAny x5), .prop (regAny x8),
        .prop (regAny x9), .prop (regAny x10), .prop (regAny x11), .prop (regAny x12),
        .prop (regAny x13), .prop (regAny x14), .prop (regAny x15), .prop (regAny x16),
        .prop (regAny x17), .prop (regAny x18), .reg x29 fp, .reg lr r, .reg sp s,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 4 true hp (w32s (compress H M))), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 false 0x20228#64 (w32s K)),
        .prop (cellsAt 4 true (s - 0x130#64)
          (w32s (rounds (schedule M) (Vars.ofList H) 64).toList)),
        .prop (cellsAt 4 true (s - 0x110#64) (w32s (schedule M))),
        .prop (cellsAt 8 true (s - 0x10#64) [fp])]) := by
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ := eq_of_length_8 hH
  obtain ⟨m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15, rfl⟩ :=
    eq_of_length_16 hM
  obtain ⟨v0, v1, v2, v3, v4, v5, v6, v7, rfl⟩ := eq_of_length_8 hfv
  obtain ⟨f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, js, rfl, hjs⟩ :=
    eq_of_length_16_add (n := 48) hfw
  obtain ⟨j, js', rfl⟩ : ∃ j js', js = j :: js' := by
    cases js with
    | nil => simp at hjs
    | cons a b => exact ⟨a, b, rfl⟩
  have h47 : js'.length = 47 := by simpa using hjs
  rw [compress_eq, Vars.ofList_eq]
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨mq, rfl⟩ : ∃ mq : BitVec 64, mp = mq + 1#64 := ⟨mp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 0x131#64 := ⟨s - 0x131#64, by bv_omega⟩
  braid_unfold cells8_w32 true (hq + 1#64) h0 h1 h2 h3 h4 h5 h6 h7
  braid_unfold cells16_w32 wm (mq + 1#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
  braid_unfold cells8 true (sq + 1#64) v0 v1 v2 v3 v4 v5 v6 v7
  braid_unfold cells_pre16 true (sq + 33#64) f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13
    f14 f15 (j :: js')
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 289#64) sv []
  -- The frame, and the block copied to the start of the schedule.
  braid_sym_run_to 0x100ec
  -- The message schedule.
  sha256_fold cells_win16 true (sq + 33#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
    (j :: js')
  braid_call compress_schedule_loop js' [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12,
    m13, m14, m15] j (sq + 33#64) 48#64 _ _ _ _ _ _ _ _ _ _ rfl
    (by rw [h47]) (by omega)
  simp only [h47, Nat.reduceAdd]
  rw [← schedule_eq_extend [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15]
    rfl]
  braid_name_reg 8
  braid_name_reg 10
  braid_name_reg 11
  braid_name_reg 12
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  -- The hash value copied to the working variables, and those loaded into registers.
  braid_sym_run_to 0x10164
  -- The rounds.
  braid_call compress_rounds_loop 0x20228#64 (sq + 33#64) (schedule [m0, m1, m2, m3, m4, m5, m6,
    m7, m8, m9, m10, m11, m12, m13, m14, m15])
    (schedule_length _ rfl) 63 0 ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ _ _ _ _ _ _ _ _ _ (by omega)
  simp only [Nat.reduceAdd]
  rw [← rounds_eq_roundsFrom]
  generalize hR : rounds (schedule [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13,
    m14, m15]) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64 = R
  -- The working variables stored, and added to the hash value.
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
  sha256_fold cells16_w32 wm (mq + 1#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
  sha256_fold cells_vars true (sq + 1#64) R
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 289#64) fp []
  braid_forget 8
  braid_forget 9
  braid_forget 10
  braid_forget 11
  braid_forget 12
  braid_forget 13
  braid_forget 14
  braid_forget 15
  braid_forget 16
  braid_forget 17
  braid_forget 18
  braid_forget_flag 0
  braid_forget_flag 1
  braid_forget_flag 2
  braid_forget_flag 3
  braid_done

/-! ## On the machine -/

/-- **`sha256_compress` on the machine.** A running machine whose program holds the words of
`sha256_compress`, with its code loaded and its program counter at the entry, with the hash
value `H` (eight words) in memory where `x0` points, the block `M` (sixteen words) where `x1`
points, and the round constants of SHA-256 in read-only memory at `0x20228`, where the code
looks for them; whose stack pointer is aligned and has 304 bytes of memory below it (here
eight words `fvs`, 64 words `fws` and a double word `sv`, all of which are overwritten); and
where the hash value, the block and those 304 bytes are pairwise apart; runs to the address
in the link register with the compression of `H` with `M` where `x0` pointed. The block is
as it was, and so are the stack pointer and the frame pointer. -/
theorem sha256_compress_correct (prog : Arm64.Program) (s : Arm64.State) (H M fvs fws : List W32)
    (sv : Word) (hw : prog.hasWords 0x100bc#64 sha256_compress_words)
    (hc : prog.CodeLoaded s.mem) (hrun : s.status = .Running) (hpc : s.pc = 0x100bc#64)
    (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 8) (hfw : fws.length = 64)
    (hsp : s.sp &&& 15#64 = 0#64)
    (hh : HasCells s (s.regs.read 0#5) H) (hm : HasCells s (s.regs.read 1#5) M)
    (hk : HasReadOnlyCells s 0x20228#64 K)
    (hv : HasCells s (s.sp - 0x130#64) fvs) (hws : HasCells s (s.sp - 0x110#64) fws)
    (hsv : HasBytes s (s.sp - 0x10#64) 8 sv)
    (hhm : Apart (s.regs.read 0#5) 32 (s.regs.read 1#5) 64)
    (hhs : Apart (s.regs.read 0#5) 32 (s.sp - 0x130#64) 304)
    (hms : Apart (s.regs.read 1#5) 64 (s.sp - 0x130#64) 304) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      HasCells s' (s.regs.read 0#5) (compress H M) ∧ HasCells s' (s.regs.read 1#5) M ∧
      s'.sp = s.sp ∧ s'.regs.read 29#5 = s.regs.read 29#5 := by
  obtain ⟨hhm1, hhm2⟩ := hhm
  obtain ⟨hhs1, hhs2⟩ := hhs
  obtain ⟨hms1, hms2⟩ := hms
  have hsvs : ∀ a ∈ cellsAtoms 8 true (s.sp - 0x10#64) [sv], a.sat (abs s) := by
    simpa [cellsAtoms] using sat_mem_hasBytes.2 hsv
  have hlK : K.length = 64 := rfl
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat sha256_compress_lowered
    (sha256_compress_spec (s.regs.read 0#5) (s.regs.read 1#5) s.sp (s.regs.read 30#5)
      (s.regs.read 29#5) sv H M true (w32s fvs) (w32s fws) (s.regs.read 2#5)
      (s.regs.read 3#5) (s.regs.read 4#5) (s.regs.read 5#5) (s.regs.read 8#5)
      (s.regs.read 9#5) (s.regs.read 10#5) (s.regs.read 11#5) (s.regs.read 12#5)
      (s.regs.read 13#5) (s.regs.read 14#5) (s.regs.read 15#5) (s.regs.read 16#5)
      (s.regs.read 17#5) (s.regs.read 18#5) s.pstate.n s.pstate.z s.pstate.c s.pstate.v
      hH hM (by simpa using hfv) (by simpa using hfw) hsp) hw hc hrun
    (flat := [.pc 0x100bc#64, .reg x0 (s.regs.read 0#5), .reg x1 (s.regs.read 1#5),
      .reg x2 (s.regs.read 2#5), .reg x3 (s.regs.read 3#5), .reg x4 (s.regs.read 4#5),
      .reg x5 (s.regs.read 5#5), .reg x8 (s.regs.read 8#5), .reg x9 (s.regs.read 9#5),
      .reg x10 (s.regs.read 10#5), .reg x11 (s.regs.read 11#5), .reg x12 (s.regs.read 12#5),
      .reg x13 (s.regs.read 13#5), .reg x14 (s.regs.read 14#5), .reg x15 (s.regs.read 15#5),
      .reg x16 (s.regs.read 16#5), .reg x17 (s.regs.read 17#5), .reg x18 (s.regs.read 18#5),
      .reg x29 (s.regs.read 29#5), .reg lr (s.regs.read 30#5), .reg sp s.sp,
      .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z, .flag Flags.c s.pstate.c,
      .flag Flags.v s.pstate.v] ++
      (cellsAtoms 4 true (s.regs.read 0#5) (w32s H) ++
      (cellsAtoms 4 true (s.regs.read 1#5) (w32s M) ++
      (cellsAtoms 4 false 0x20228#64 (w32s K) ++
      (cellsAtoms 4 true (s.sp - 0x130#64) (w32s fvs) ++
      (cellsAtoms 4 true (s.sp - 0x110#64) (w32s fws) ++
      (cellsAtoms 8 true (s.sp - 0x10#64) [sv] ++ [])))))))
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
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp), .nil, disj_nil_right⟩,
        -- the schedule, and what follows it
        disj_append_right (cellsAtoms_disj (by simp [hfw]; bv_omega) (by simp; bv_omega))
          disj_nil_right⟩,
        -- the working variables, and what follows them
        disj_append_right (cellsAtoms_disj (by simp [hfv]; bv_omega) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hfv]; bv_omega) (by simp; bv_omega))
          disj_nil_right)⟩,
        -- the round constants, and what follows them
        disj_append_right (disj_flip (cellsAtoms_disj_readOnly hv.sat hk.sat))
          (disj_append_right (disj_flip (cellsAtoms_disj_readOnly hws.sat hk.sat))
          (disj_append_right (disj_flip (cellsAtoms_disj_readOnly hsvs hk.sat))
          disj_nil_right))⟩,
        -- the block, and what follows it
        disj_append_right (cellsAtoms_disj_readOnly hm.sat hk.sat)
          (disj_append_right (cellsAtoms_disj (by simp [hM]; bv_omega) (by simp [hfv]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hM]; bv_omega) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hM]; bv_omega) (by simp; bv_omega))
          disj_nil_right)))⟩,
        -- the hash value, and what follows it
        disj_append_right (cellsAtoms_disj (by rw [w32s_length, hH]; exact hhm1)
            (by rw [w32s_length, hM]; exact hhm2))
          (disj_append_right (cellsAtoms_disj_readOnly hh.sat hk.sat)
          (disj_append_right (cellsAtoms_disj (by simp [hH]; bv_omega) (by simp [hfv]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hH]; bv_omega) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hH]; bv_omega) (by simp; bv_omega))
          disj_nil_right))))⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
          Flags.v, hpc],
        List.forall_mem_append.2 ⟨hh.sat,
        List.forall_mem_append.2 ⟨hm.sat,
        List.forall_mem_append.2 ⟨hk.sat,
        List.forall_mem_append.2 ⟨hv.sat,
        List.forall_mem_append.2 ⟨hws.sat,
        List.forall_mem_append.2 ⟨hsvs, by simp⟩⟩⟩⟩⟩⟩⟩)
  refine ⟨s', hsteps, ?_, hasCells_of_holds hr hq (by braid_at),
    hasCells_of_holds hr hq (by braid_at), ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.sp]; exact Atoms.reg_of_holds (r := 31) hq (by braid_at)
  · rw [← hr.readReg (i := 29#5) (by decide)]
    exact Atoms.reg_of_holds (r := 29) hq (by braid_at)

end Examples.Sha256.Arm
