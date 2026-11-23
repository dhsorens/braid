/-
  Examples.Sha256.O2.Arm.Compress

  `sha256_compress` of `sha256.c` on AArch64, compiled at `-O2`: the compression function of
  SHA-256. As at `-O1` the compiler inlined `sha256_schedule` and `sha256_round` into it, so
  the proof has the two loops again, as loops of this function.

  At `-O2` the three short loops that copy and the loop that adds are gone. The block is
  copied to the start of the schedule by loads and stores in a line, four of them of eight
  bytes, each over two 32-bit words; the hash value stays in eight registers through the
  rounds, with the working variables in eight others, and is added and stored at the end;
  the frame is 320 bytes, with the schedule at its foot and seven saved registers above it.
  The proof is in stages, as at `-O1`:

  * two 32-bit cells are one cell of eight bytes that holds their `pair` (`mem_pair`), so
    that a load or a store of eight bytes finds the cell it asks for;
  * the message schedule is `compress_schedule_loop`: the statement and the proof of `-O1`,
    at other addresses;
  * a round is `compress_round_step`, and the 64 rounds `compress_rounds_loop`: the
    statements of `-O1` with the registers of this binary, and their proofs;
  * the function itself is run again, and in three triples where `-O1` had one
    (`compress_head_spec`, to the end of the schedule, `compress_tail_spec`, from the end of
    the rounds, and `sha256_compress_spec`, which joins them): with seven saved registers in
    the frame, one declaration that runs all of the code does not fit in the default limit
    on heartbeats.

  ## Main definitions

  * `pair`: the 64-bit word in two 32-bit cells
  * `HasWords`: the machine has an array of 64-bit words in memory, such as saved registers

  ## Main results

  * `mem_pair`: two 32-bit cells are a cell of eight bytes
  * `sha256_compress_spec`: the specification, with `Sha256.compress`
  * `sha256_compress_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256.O2.Arm.Image
public import Examples.Sha256.Arm.Machine
public import Examples.Sha256.RunTo
import Iris.BI.DerivedLaws
import Braid.BV

public section

namespace Examples.Sha256.O2.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs
open Examples.Sha256.Arm
open Iris Iris.BI

/-! ## Two 32-bit cells as one of eight bytes -/

/-- The 64-bit word whose low half is the low half of `x` and whose high half is the low
half of `y`: what a load of eight bytes finds where two 32-bit cells hold `x` and `y`. -/
@[expose] def pair (x y : Word) : Word := (x.setWidth 32).setWidth 64 ||| y <<< 32

/-- The heap of eight bytes that hold a pair is the heaps of its two halves. -/
theorem Heap.bytes_pair (p x y : Word) (w : Bool) :
    Heap.bytes p 8 (pair x y) w = Heap.bytes p 4 x w ∪ Heap.bytes (p + 4#64) 4 y w := by
  funext l
  cases l with
  | mem a =>
    have e : a - (p + 4#64) = a - p - 4#64 := by bv_omega
    simp only [Heap.union_apply, Heap.bytes, e, pair]
    generalize a - p = d
    by_cases h1 : d.toNat < 4
    · have h8 : d.toNat < 8 := by omega
      have h1' : d < 4#64 := by bv_omega
      simp only [h1, h8, ↓reduceIte]
      congr 3
      bv_auto
    · by_cases h2 : d.toNat < 8
      · have h4 : (d - 4#64).toNat < 4 := by bv_omega
        have h1' : 4#64 ≤ d := by bv_omega
        have h2' : d < 8#64 := by bv_omega
        simp only [h1, h2, h4, ↓reduceIte]
        congr 3
        bv_auto
      · have h4 : ¬ (d - 4#64).toNat < 4 := by bv_omega
        simp only [h1, h2, h4, ↓reduceIte]
  | _ => rfl

/-- The heaps of two adjacent 32-bit cells have no location in common. -/
theorem Heap.disjoint_bytes_pair (p x y : Word) (w : Bool) :
    Heap.Disjoint (Heap.bytes p 4 x w) (Heap.bytes (p + 4#64) 4 y w) := by
  intro l
  cases l with
  | mem a =>
    have e : a - (p + 4#64) = a - p - 4#64 := by bv_omega
    simp only [Heap.bytes, e]
    generalize a - p = d
    by_cases h1 : d.toNat < 4
    · have h4 : ¬ (d - 4#64).toNat < 4 := by bv_omega
      exact .inr (by simp only [h4, ↓reduceIte])
    · exact .inl (by simp only [h1, ↓reduceIte])
  | _ => exact .inl rfl

/-- **Two 32-bit cells as one of eight bytes.** A cell of eight bytes at `p` that holds
`pair x y` is a 32-bit cell at `p` that holds `x` and one at `q`, four bytes on, that holds
`y`. Closing the two cells gives a load or a store of eight bytes the atom it looks for;
opening the cell gives the words back. -/
theorem mem_pair (w : Bool) (p q x y : Word) (h : q = p + 4#64) :
    (Atom.mem p 8 (pair x y) w).interp = Atoms.interp [.mem p 4 x w, .mem q 4 y w] := by
  subst h
  have e : memIs p 8 (pair x y) w = iprop(memIs p 4 x w ∗ memIs (p + 4#64) 4 y w) := by
    funext h
    refine propext ⟨fun hh => ?_, ?_⟩
    · exact ⟨_, _, hh.trans (Heap.bytes_pair p x y w), Heap.disjoint_bytes_pair p x y w, rfl,
        rfl⟩
    · rintro ⟨_, _, rfl, _, rfl, rfl⟩
      exact (Heap.bytes_pair p x y w).symm
  simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil, e]
  exact SProp.ext ⟨sep_mono_right sep_emp.symm.1, sep_mono_right sep_emp.1⟩

/-- Six 64-bit cells, as memory atoms: the registers `x19` to `x24`, saved. -/
theorem saved_cells (p m0 m1 m2 m3 m4 m5 : Word) :
    (Atom.prop (cellsAt 8 true p [m0, m1, m2, m3, m4, m5])).interp =
      Atoms.interp [.mem p 8 m0 true, .mem (p + 8#64) 8 m1 true, .mem (p + 16#64) 8 m2 true,
        .mem (p + 24#64) 8 m3 true, .mem (p + 32#64) 8 m4 true, .mem (p + 40#64) 8 m5 true] := by
  rw [cells_eq_atoms]
  simp only [cellsAtoms, BitVec.add_assoc, BitVec.reduceAdd]

/-- A list of six. -/
theorem eq_of_length_6 {α : Type} {l : List α} (h : l.length = 6) :
    ∃ x0 x1 x2 x3 x4 x5, l = [x0, x1, x2, x3, x4, x5] := by
  match l, h with
  | [x0, x1, x2, x3, x4, x5], _ => exact ⟨x0, x1, x2, x3, x4, x5, rfl⟩

/-! ## The message schedule -/

/-- Forget what the loop of the schedule leaves in the registers it uses and in the flags. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 8; braid_forget 10; braid_forget 11; braid_forget 12
             braid_forget 13; braid_forget 14; braid_forget 15
             braid_forget_flag 0; braid_forget_flag 1; braid_forget_flag 2
             braid_forget_flag 3))

/-- The loop of the message schedule in `sha256_compress`, where `sha256_schedule` is
inlined: with a window of sixteen words of the schedule at `q` and `js.length + 1` cells
after it, fill those cells with the next words of the schedule. -/
theorem compress_schedule_loop : ∀ (js : List Word) (win : List W32) (j : Word)
    (q c t10 t11 t12 t13 t14 t15 : Word) (fn fz fc fv : Bool), win.length = 16 →
    c = BitVec.ofNat 64 (js.length + 1) → js.length + 1 < 2 ^ 64 →
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x1011c#64, .reg x9 c, .reg x8 (q + 64#64),
        .reg x10 t10, .reg x11 t11, .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 true q (w32s win ++ j :: js))])
      (Atoms.interp [.pc 0x10158#64, .reg x9 0#64, .prop (regAny x8),
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
    braid_sym_run_to 0x10158
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
        (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15])
        (j' :: js)
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
  `(tactic| (braid_forget 20; braid_forget 21; braid_forget 22; braid_forget 23; braid_forget 24
             braid_forget_flag 0; braid_forget_flag 1; braid_forget_flag 2
             braid_forget_flag 3))

/-- Name the values a round left in the registers it uses for intermediate values, and in
the flags. -/
local macro "round_name" : tactic =>
  `(tactic| (braid_name_reg 20; braid_name_reg 21; braid_name_reg 22; braid_name_reg 23
             braid_name_reg 24; braid_name_flag 0; braid_name_flag 1; braid_name_flag 2
             braid_name_flag 3))

/-- Give the registers of the working variables the values of the specification's round. -/
local macro "round_values " W:term ", " v:term ", " t:term : tactic =>
  `(tactic| (sha256_reg 19, (round $W $v $t).a.setWidth 64
             sha256_reg 6, (round $W $v $t).b.setWidth 64
             sha256_reg 3, (round $W $v $t).c.setWidth 64
             sha256_reg 4, (round $W $v $t).d.setWidth 64
             sha256_reg 7, (round $W $v $t).e.setWidth 64
             sha256_reg 1, (round $W $v $t).f.setWidth 64
             sha256_reg 17, (round $W $v $t).g.setWidth 64
             sha256_reg 18, (round $W $v $t).h.setWidth 64))

/-- After the instructions of a round: give the registers the values of the specification,
and close the two arrays. -/
local macro "round_finish " kq:term ", " wq:term ", " W:term ", " v:term ", " t:term ", "
    hK:term ", " hW:term : tactic =>
  `(tactic| (round_values $W, $v, $t
             refine Triple.reg_val (r := 12) (BitVec.ofNat 64 (4 * ($t + 1))) (by braid_upd)
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
    (ht : t < 64) (v : Vars) (t20 t21 t22 t23 t24 : Word) (fn fz fc fv : Bool) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x10198#64, .reg x20 t20, .reg x21 t21, .reg x22 t22, .reg x23 t23,
        .reg x24 t24, .reg x12 (BitVec.ofNat 64 (4 * t)), .reg x2 kp, .reg x5 wp,
        .reg x19 (v.a.setWidth 64), .reg x6 (v.b.setWidth 64), .reg x3 (v.c.setWidth 64),
        .reg x4 (v.d.setWidth 64), .reg x7 (v.e.setWidth 64), .reg x1 (v.f.setWidth 64),
        .reg x17 (v.g.setWidth 64), .reg x18 (v.h.setWidth 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 false kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))])
      (Atoms.interp [.pc (if t = 63 then 0x1021c#64 else 0x10198#64),
        .prop (regAny x20), .prop (regAny x21), .prop (regAny x22), .prop (regAny x23),
        .prop (regAny x24), .reg x12 (BitVec.ofNat 64 (4 * (t + 1))), .reg x2 kp, .reg x5 wp,
        .reg x19 ((round W v t).a.setWidth 64),
        .reg x6 ((round W v t).b.setWidth 64), .reg x3 ((round W v t).c.setWidth 64),
        .reg x4 ((round W v t).d.setWidth 64), .reg x7 ((round W v t).e.setWidth 64),
        .reg x1 ((round W v t).f.setWidth 64), .reg x17 ((round W v t).g.setWidth 64),
        .reg x18 ((round W v t).h.setWidth 64),
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
    ∀ (n t : Nat) (v : Vars) (t20 t21 t22 t23 t24 : Word) (fn fz fc fv : Bool), t + n + 1 = 64 →
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x10198#64, .reg x20 t20, .reg x21 t21, .reg x22 t22, .reg x23 t23,
        .reg x24 t24, .reg x12 (BitVec.ofNat 64 (4 * t)), .reg x2 kp, .reg x5 wp,
        .reg x19 (v.a.setWidth 64), .reg x6 (v.b.setWidth 64), .reg x3 (v.c.setWidth 64),
        .reg x4 (v.d.setWidth 64), .reg x7 (v.e.setWidth 64), .reg x1 (v.f.setWidth 64),
        .reg x17 (v.g.setWidth 64), .reg x18 (v.h.setWidth 64),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 false kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))])
      (Atoms.interp [.pc 0x1021c#64,
        .prop (regAny x20), .prop (regAny x21), .prop (regAny x22), .prop (regAny x23),
        .prop (regAny x24), .reg x12 256#64, .reg x2 kp, .reg x5 wp,
        .reg x19 ((roundsFrom W t (n + 1) v).a.setWidth 64),
        .reg x6 ((roundsFrom W t (n + 1) v).b.setWidth 64), .reg x3 ((roundsFrom W t (n + 1)
          v).c.setWidth 64),
        .reg x4 ((roundsFrom W t (n + 1) v).d.setWidth 64), .reg x7 ((roundsFrom W t (n + 1)
          v).e.setWidth 64),
        .reg x1 ((roundsFrom W t (n + 1) v).f.setWidth 64), .reg x17 ((roundsFrom W t (n + 1)
          v).g.setWidth 64),
        .reg x18 ((roundsFrom W t (n + 1) v).h.setWidth 64),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 4 false kp (w32s K)), .prop (cellsAt 4 true wp (w32s W))]) := by
  intro n
  induction n with
  | zero =>
    intro t v t20 t21 t22 t23 t24 fn fz fc fv hn
    obtain rfl : t = 63 := by omega
    rw [roundsFrom_one]
    braid_call compress_round_step kp wp W hW 63 (by omega) v t20 t21 t22 t23 t24 fn fz fc fv
    braid_done
  | succ n ih =>
    intro t v t20 t21 t22 t23 t24 fn fz fc fv hn
    have h63 : t ≠ 63 := by omega
    rw [roundsFrom_succ]
    braid_call compress_round_step kp wp W hW t (by omega) v t20 t21 t22 t23 t24 fn fz fc fv
    simp only [h63, ↓reduceIte]
    round_name
    braid_call ih (t + 1) (round W v t) _ _ _ _ _ _ _ _ _ (by omega)
    braid_done

/-! ## The compression function -/

/-- **The head of `sha256_compress`**, to the end of the message schedule: the frame is made,
the frame pointer and six registers are saved in it, the block is copied to the start of the
schedule, and the schedule is filled. -/
theorem compress_head_spec (mp s fp sv : Word) (M : List W32) (wm : Bool) (fws svs : List Word)
    (t8 t9 t10 t11 t12 t13 t14 t15 v19 v20 v21 v22 v23 v24 : Word) (fn fz fc fv : Bool)
    (hM : M.length = 16) (hfw : fws.length = 64) (hsvs : svs.length = 6)
    (hs : s &&& 15#64 = 0#64) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x100bc#64, .reg x1 mp, .reg x8 t8, .reg x9 t9, .reg x10 t10,
        .reg x11 t11, .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15,
        .reg x19 v19, .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg x23 v23, .reg x24 v24,
        .reg x29 fp, .reg sp s,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 wm mp (w32s M)), .prop (cellsAt 4 true (s - 0x140#64) fws),
        .prop (cellsAt 8 true (s - 0x40#64) [sv]), .prop (cellsAt 8 true (s - 0x30#64) svs)])
      (Atoms.interp [.pc 0x10158#64, .reg x1 mp, .prop (regAny x8), .reg x9 0#64,
        .prop (regAny x10), .prop (regAny x11), .prop (regAny x12), .prop (regAny x13),
        .prop (regAny x14), .prop (regAny x15),
        .reg x19 v19, .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg x23 v23, .reg x24 v24,
        .reg x29 fp, .reg sp (s - 0x140#64),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 true (s - 0x140#64) (w32s (schedule M))),
        .prop (cellsAt 8 true (s - 0x40#64) [fp]),
        .prop (cellsAt 8 true (s - 0x30#64) [v24, v23, v22, v21, v20, v19])]) := by
  obtain ⟨m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15, rfl⟩ :=
    eq_of_length_16 hM
  obtain ⟨f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, js, rfl, hjs⟩ :=
    eq_of_length_16_add (n := 48) hfw
  obtain ⟨j, js', rfl⟩ : ∃ j js', js = j :: js' := by
    cases js with
    | nil => simp at hjs
    | cons a b => exact ⟨a, b, rfl⟩
  have h47 : js'.length = 47 := by simpa using hjs
  obtain ⟨g0, g1, g2, g3, g4, g5, rfl⟩ := eq_of_length_6 hsvs
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨mq, rfl⟩ : ∃ mq : BitVec 64, mp = mq + 1#64 := ⟨mp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 0x141#64 := ⟨s - 0x141#64, by bv_omega⟩
  braid_unfold cells16_w32 wm (mq + 1#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
  braid_unfold cells_pre16 true (sq + 1#64) f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13
    f14 f15 (j :: js')
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 257#64) sv []
  braid_unfold saved_cells (sq + 273#64) g0 g1 g2 g3 g4 g5
  -- The words of the block, and the cells of the schedule, that the code moves in pairs.
  sha256_fold mem_pair wm (mq + 1#64) (mq + 5#64) (m0.setWidth 64) (m1.setWidth 64) (by bv_omega)
  sha256_fold mem_pair wm (mq + 13#64) (mq + 17#64) (m3.setWidth 64) (m4.setWidth 64)
    (by bv_omega)
  sha256_fold mem_pair wm (mq + 25#64) (mq + 29#64) (m6.setWidth 64) (m7.setWidth 64)
    (by bv_omega)
  sha256_fold mem_pair wm (mq + 33#64) (mq + 37#64) (m8.setWidth 64) (m9.setWidth 64)
    (by bv_omega)
  sha256_fold mem_pair true (sq + 1#64) (sq + 5#64) f0 f1 (by bv_omega)
  sha256_fold mem_pair true (sq + 13#64) (sq + 17#64) f3 f4 (by bv_omega)
  sha256_fold mem_pair true (sq + 25#64) (sq + 29#64) f6 f7 (by bv_omega)
  sha256_fold mem_pair true (sq + 33#64) (sq + 37#64) f8 f9 (by bv_omega)
  -- The frame, and the block copied to the start of the schedule.
  braid_sym_run_to 0x1011c
  braid_unfold mem_pair true (sq + 1#64) (sq + 5#64) (m0.setWidth 64) (m1.setWidth 64)
    (by bv_omega)
  braid_unfold mem_pair true (sq + 13#64) (sq + 17#64) (m3.setWidth 64) (m4.setWidth 64)
    (by bv_omega)
  braid_unfold mem_pair true (sq + 25#64) (sq + 29#64) (m6.setWidth 64) (m7.setWidth 64)
    (by bv_omega)
  braid_unfold mem_pair true (sq + 33#64) (sq + 37#64) (m8.setWidth 64) (m9.setWidth 64)
    (by bv_omega)
  braid_unfold mem_pair wm (mq + 1#64) (mq + 5#64) (m0.setWidth 64) (m1.setWidth 64)
    (by bv_omega)
  braid_unfold mem_pair wm (mq + 13#64) (mq + 17#64) (m3.setWidth 64) (m4.setWidth 64)
    (by bv_omega)
  braid_unfold mem_pair wm (mq + 25#64) (mq + 29#64) (m6.setWidth 64) (m7.setWidth 64)
    (by bv_omega)
  braid_unfold mem_pair wm (mq + 33#64) (mq + 37#64) (m8.setWidth 64) (m9.setWidth 64)
    (by bv_omega)
  -- The message schedule.
  sha256_fold cells_win16 true (sq + 1#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
    (j :: js')
  braid_call compress_schedule_loop js' [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12,
    m13, m14, m15] j (sq + 1#64) 48#64 _ _ _ _ _ _ _ _ _ _ rfl
    (by rw [h47]) (by omega)
  simp only [h47, Nat.reduceAdd]
  rw [← schedule_eq_extend [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15]
    rfl]
  sha256_fold cells16_w32 wm (mq + 1#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 257#64) fp []
  sha256_fold saved_cells (sq + 273#64) v24 v23 v22 v21 v20 v19
  braid_done

/-- **The tail of `sha256_compress`**, from the end of the loop of rounds: the working
variables are added to the hash value, which eight registers still hold, the sums are
stored, the frame pointer and the six saved registers are restored, and the frame is
dropped. -/
theorem compress_tail_spec (hp s r fp : Word) (h0 h1 h2 h3 h4 h5 h6 h7 : W32) (R : Vars)
    (t20 t21 t22 t23 t24 v19 v20 v21 v22 v23 v24 : Word) (hs : s &&& 15#64 = 0#64) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x1021c#64, .reg x0 hp, .reg x10 (h0.setWidth 64),
        .reg x11 (h1.setWidth 64), .reg x9 (h2.setWidth 64), .reg x8 (h3.setWidth 64),
        .reg x16 (h4.setWidth 64), .reg x15 (h5.setWidth 64), .reg x14 (h6.setWidth 64),
        .reg x13 (h7.setWidth 64),
        .reg x19 (R.a.setWidth 64), .reg x6 (R.b.setWidth 64), .reg x3 (R.c.setWidth 64),
        .reg x4 (R.d.setWidth 64), .reg x7 (R.e.setWidth 64), .reg x1 (R.f.setWidth 64),
        .reg x17 (R.g.setWidth 64), .reg x18 (R.h.setWidth 64),
        .reg x20 t20, .reg x21 t21, .reg x22 t22, .reg x23 t23, .reg x24 t24,
        .reg x29 fp, .reg lr r, .reg sp (s - 0x140#64),
        .prop (cellsAt 4 true hp (w32s [h0, h1, h2, h3, h4, h5, h6, h7])),
        .prop (cellsAt 8 true (s - 0x40#64) [fp]),
        .prop (cellsAt 8 true (s - 0x30#64) [v24, v23, v22, v21, v20, v19])])
      (Atoms.interp [.pc r, .reg x0 hp, .prop (regAny x10), .prop (regAny x11),
        .prop (regAny x9), .prop (regAny x8), .prop (regAny x16), .prop (regAny x15),
        .prop (regAny x14), .prop (regAny x13),
        .reg x19 v19, .prop (regAny x6), .prop (regAny x3), .prop (regAny x4),
        .prop (regAny x7), .prop (regAny x1), .prop (regAny x17), .prop (regAny x18),
        .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg x23 v23, .reg x24 v24,
        .reg x29 fp, .reg lr r, .reg sp s,
        .prop (cellsAt 4 true hp (w32s [R.a + h0, R.b + h1, R.c + h2, R.d + h3, R.e + h4,
          R.f + h5, R.g + h6, R.h + h7])),
        .prop (cellsAt 8 true (s - 0x40#64) [fp]),
        .prop (cellsAt 8 true (s - 0x30#64) [v24, v23, v22, v21, v20, v19])]) := by
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 0x141#64 := ⟨s - 0x141#64, by bv_omega⟩
  braid_unfold cells8_w32 true (hq + 1#64) h0 h1 h2 h3 h4 h5 h6 h7
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 257#64) fp []
  braid_unfold saved_cells (sq + 273#64) v24 v23 v22 v21 v20 v19
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
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 257#64) fp []
  sha256_fold saved_cells (sq + 273#64) v24 v23 v22 v21 v20 v19
  braid_forget 1
  braid_forget 3
  braid_forget 4
  braid_forget 6
  braid_forget 7
  braid_forget 8
  braid_forget 9
  braid_forget 10
  braid_forget 11
  braid_forget 13
  braid_forget 14
  braid_forget 15
  braid_forget 16
  braid_forget 17
  braid_forget 18
  braid_done

/-- `sha256_compress` replaces the hash value its first argument points to by the
compression of it with the block its second argument points to. It reads the round
constants from read-only data at `0x20264`, and uses 312 of the 320 bytes below the stack
pointer: the message schedule in the lowest 256, the frame pointer above it, and, in the
highest 48, the registers `x19` to `x24`; it restores all seven. -/
theorem sha256_compress_spec (hp mp s r fp sv : Word) (H M : List W32) (wm : Bool)
    (fws svs : List Word) (t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 : Word)
    (v19 v20 v21 v22 v23 v24 : Word)
    (fn fz fc fv : Bool) (hH : H.length = 8) (hM : M.length = 16)
    (hfw : fws.length = 64) (hsvs : svs.length = 6) (hs : s &&& 15#64 = 0#64) :
    Triple sha256_compress.program
      (Atoms.interp (.pc 0x100bc#64 :: .reg x0 hp :: .reg x1 mp :: .reg x2 t2 :: .reg x3 t3 ::
        .reg x4 t4 :: .reg x5 t5 :: .reg x6 t6 :: .reg x7 t7 :: .reg x8 t8 :: .reg x9 t9 ::
        [.reg x10 t10, .reg x11 t11,
        .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15, .reg x16 t16, .reg x17 t17,
        .reg x18 t18, .reg x19 v19, .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg x23 v23,
        .reg x24 v24, .reg x29 fp, .reg lr r, .reg sp s,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 false 0x20264#64 (w32s K)),
        .prop (cellsAt 4 true (s - 0x140#64) fws),
        .prop (cellsAt 8 true (s - 0x40#64) [sv]), .prop (cellsAt 8 true (s - 0x30#64) svs)]))
      (Atoms.interp (.pc r :: .reg x0 hp :: .prop (regAny x1) :: .prop (regAny x2) ::
        .prop (regAny x3) :: .prop (regAny x4) :: .prop (regAny x5) :: .prop (regAny x6) ::
        .prop (regAny x7) :: .prop (regAny x8) ::
        [.prop (regAny x9), .prop (regAny x10), .prop (regAny x11), .prop (regAny x12),
        .prop (regAny x13), .prop (regAny x14), .prop (regAny x15), .prop (regAny x16),
        .prop (regAny x17), .prop (regAny x18), .reg x19 v19, .reg x20 v20, .reg x21 v21,
        .reg x22 v22, .reg x23 v23, .reg x24 v24, .reg x29 fp, .reg lr r, .reg sp s,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 4 true hp (w32s (compress H M))), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 false 0x20264#64 (w32s K)),
        .prop (cellsAt 4 true (s - 0x140#64) (w32s (schedule M))),
        .prop (cellsAt 8 true (s - 0x40#64) [fp]),
        .prop (cellsAt 8 true (s - 0x30#64) [v24, v23, v22, v21, v20, v19])])) := by
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ := eq_of_length_8 hH
  rw [compress_eq]
  -- The frame, the block copied to the start of the schedule, and the message schedule.
  braid_call compress_head_spec mp s fp sv M wm fws svs t8 t9 t10 t11 t12 t13 t14 t15
    v19 v20 v21 v22 v23 v24 fn fz fc fv hM hfw hsvs hs
  braid_name_reg 8
  braid_name_reg 10
  braid_name_reg 11
  braid_name_reg 12
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  braid_name_flag 0
  braid_name_flag 1
  braid_name_flag 2
  braid_name_flag 3
  -- The hash value loaded into registers, and copied to those of the working variables.
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 0x141#64 := ⟨s - 0x141#64, by bv_omega⟩
  braid_unfold cells8_w32 true (hq + 1#64) h0 h1 h2 h3 h4 h5 h6 h7
  braid_sym_run_to 0x10198
  sha256_fold cells8_w32 true (hq + 1#64) h0 h1 h2 h3 h4 h5 h6 h7
  -- The rounds.
  braid_call compress_rounds_loop 0x20264#64 (sq + 1#64) (schedule M)
    (schedule_length _ hM) 63 0 ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ _ _ _ _ _ _ _ _ _ (by omega)
  simp only [Nat.reduceAdd]
  rw [← rounds_eq_roundsFrom]
  generalize rounds (schedule M) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64 = R
  -- The working variables added to the hash value, and the registers restored.
  braid_name_reg 20
  braid_name_reg 21
  braid_name_reg 22
  braid_name_reg 23
  braid_name_reg 24
  braid_call compress_tail_spec (hq + 1#64) (sq + 0x141#64) r fp h0 h1 h2 h3 h4 h5 h6 h7 R
    _ _ _ _ _ v19 v20 v21 v22 v23 v24 hs
  braid_forget 2
  braid_forget 5
  braid_forget 12
  braid_done

/-! ## On the machine -/

/-- The machine has the 64-bit words `xs` in memory from `p` on, little-endian, and may load
and store them. -/
@[expose] def HasWords (s : Arm64.State) (p : Word) (xs : List Word) : Prop :=
  ∀ (i : Nat) (hi : i < xs.length), HasBytes s (p + BitVec.ofNat 64 (8 * i)) 8 xs[i]

theorem HasWords.sat {s : Arm64.State} {p : Word} {xs : List Word} (h : HasWords s p xs) :
    ∀ a ∈ cellsAtoms 8 true p xs, a.sat (abs s) :=
  cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (h i hi)

/-- **`sha256_compress` on the machine.** A running machine whose program holds the words of
`sha256_compress`, with its code loaded and its program counter at the entry, with the hash
value `H` (eight words) in memory where `x0` points, the block `M` (sixteen words) where `x1`
points, and the round constants of SHA-256 in read-only memory at `0x20264`, where the code
looks for them; whose stack pointer is aligned and has 320 bytes of memory below it (here
64 words `fws`, a double word `sv` and, eight bytes further, six double words `svs`, all of
which are overwritten); and where the hash value, the block and those 320 bytes are pairwise
apart; runs to the address in the link register with the compression of `H` with `M` where
`x0` pointed. The block is as it was, and so are the stack pointer, the frame pointer and
the callee-saved registers the code uses, `x19` to `x24`. -/
theorem sha256_compress_correct (prog : Arm64.Program) (s : Arm64.State) (H M fws : List W32)
    (sv : Word) (svs : List Word) (hw : prog.hasWords 0x100bc#64 sha256_compress_words)
    (hc : prog.CodeLoaded s.mem) (hrun : s.status = .Running) (hpc : s.pc = 0x100bc#64)
    (hH : H.length = 8) (hM : M.length = 16) (hfw : fws.length = 64) (hsvl : svs.length = 6)
    (hsp : s.sp &&& 15#64 = 0#64)
    (hh : HasCells s (s.regs.read 0#5) H) (hm : HasCells s (s.regs.read 1#5) M)
    (hk : HasReadOnlyCells s 0x20264#64 K)
    (hws : HasCells s (s.sp - 0x140#64) fws) (hsv : HasBytes s (s.sp - 0x40#64) 8 sv)
    (hsvs : HasWords s (s.sp - 0x30#64) svs)
    (hhm : Apart (s.regs.read 0#5) 32 (s.regs.read 1#5) 64)
    (hhs : Apart (s.regs.read 0#5) 32 (s.sp - 0x140#64) 320)
    (hms : Apart (s.regs.read 1#5) 64 (s.sp - 0x140#64) 320) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      HasCells s' (s.regs.read 0#5) (compress H M) ∧ HasCells s' (s.regs.read 1#5) M ∧
      s'.sp = s.sp ∧ s'.regs.read 29#5 = s.regs.read 29#5 ∧
      s'.regs.read 19#5 = s.regs.read 19#5 ∧ s'.regs.read 20#5 = s.regs.read 20#5 ∧
      s'.regs.read 21#5 = s.regs.read 21#5 ∧ s'.regs.read 22#5 = s.regs.read 22#5 ∧
      s'.regs.read 23#5 = s.regs.read 23#5 ∧ s'.regs.read 24#5 = s.regs.read 24#5 := by
  obtain ⟨hhm1, hhm2⟩ := hhm
  obtain ⟨hhs1, hhs2⟩ := hhs
  obtain ⟨hms1, hms2⟩ := hms
  have hsvw : ∀ a ∈ cellsAtoms 8 true (s.sp - 0x40#64) [sv], a.sat (abs s) := by
    simpa [cellsAtoms] using sat_mem_hasBytes.2 hsv
  have hlK : K.length = 64 := rfl
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat sha256_compress_lowered
    (sha256_compress_spec (s.regs.read 0#5) (s.regs.read 1#5) s.sp (s.regs.read 30#5)
      (s.regs.read 29#5) sv H M true (w32s fws) svs (s.regs.read 2#5)
      (s.regs.read 3#5) (s.regs.read 4#5) (s.regs.read 5#5) (s.regs.read 6#5)
      (s.regs.read 7#5) (s.regs.read 8#5)
      (s.regs.read 9#5) (s.regs.read 10#5) (s.regs.read 11#5) (s.regs.read 12#5)
      (s.regs.read 13#5) (s.regs.read 14#5) (s.regs.read 15#5) (s.regs.read 16#5)
      (s.regs.read 17#5) (s.regs.read 18#5) (s.regs.read 19#5) (s.regs.read 20#5)
      (s.regs.read 21#5) (s.regs.read 22#5) (s.regs.read 23#5) (s.regs.read 24#5)
      s.pstate.n s.pstate.z s.pstate.c s.pstate.v
      hH hM (by simpa using hfw) hsvl hsp) hw hc hrun
    (flat := [.pc 0x100bc#64, .reg x0 (s.regs.read 0#5), .reg x1 (s.regs.read 1#5),
      .reg x2 (s.regs.read 2#5), .reg x3 (s.regs.read 3#5), .reg x4 (s.regs.read 4#5),
      .reg x5 (s.regs.read 5#5), .reg x6 (s.regs.read 6#5), .reg x7 (s.regs.read 7#5),
      .reg x8 (s.regs.read 8#5), .reg x9 (s.regs.read 9#5),
      .reg x10 (s.regs.read 10#5), .reg x11 (s.regs.read 11#5), .reg x12 (s.regs.read 12#5),
      .reg x13 (s.regs.read 13#5), .reg x14 (s.regs.read 14#5), .reg x15 (s.regs.read 15#5),
      .reg x16 (s.regs.read 16#5), .reg x17 (s.regs.read 17#5), .reg x18 (s.regs.read 18#5),
      .reg x19 (s.regs.read 19#5), .reg x20 (s.regs.read 20#5), .reg x21 (s.regs.read 21#5),
      .reg x22 (s.regs.read 22#5), .reg x23 (s.regs.read 23#5), .reg x24 (s.regs.read 24#5),
      .reg x29 (s.regs.read 29#5), .reg lr (s.regs.read 30#5), .reg sp s.sp,
      .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z, .flag Flags.c s.pstate.c,
      .flag Flags.v s.pstate.v] ++
      (cellsAtoms 4 true (s.regs.read 0#5) (w32s H) ++
      (cellsAtoms 4 true (s.regs.read 1#5) (w32s M) ++
      (cellsAtoms 4 false 0x20264#64 (w32s K) ++
      (cellsAtoms 4 true (s.sp - 0x140#64) (w32s fws) ++
      (cellsAtoms 8 true (s.sp - 0x40#64) [sv] ++
      (cellsAtoms 8 true (s.sp - 0x30#64) svs ++ [])))))))
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
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hfw]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hsvl]), .nil, disj_nil_right⟩,
        -- the frame pointer, and what follows it
        disj_append_right (cellsAtoms_disj (by simp; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right⟩,
        -- the schedule, and what follows it
        disj_append_right (cellsAtoms_disj (by simp [hfw]; bv_omega) (by simp; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hfw]; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right)⟩,
        -- the round constants, and what follows them
        disj_append_right (disj_flip (cellsAtoms_disj_readOnly hws.sat hk.sat))
          (disj_append_right (disj_flip (cellsAtoms_disj_readOnly hsvw hk.sat))
          (disj_append_right (disj_flip (cellsAtoms_disj_readOnly hsvs.sat hk.sat))
          disj_nil_right))⟩,
        -- the block, and what follows it
        disj_append_right (cellsAtoms_disj_readOnly hm.sat hk.sat)
          (disj_append_right (cellsAtoms_disj (by simp [hM]; bv_omega) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hM]; bv_omega) (by simp; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hM]; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right)))⟩,
        -- the hash value, and what follows it
        disj_append_right (cellsAtoms_disj (by rw [w32s_length, hH]; exact hhm1)
            (by rw [w32s_length, hM]; exact hhm2))
          (disj_append_right (cellsAtoms_disj_readOnly hh.sat hk.sat)
          (disj_append_right (cellsAtoms_disj (by simp [hH]; bv_omega) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hH]; bv_omega) (by simp; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hH]; bv_omega) (by simp [hsvl]; bv_omega))
          disj_nil_right))))⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
          Flags.v, hpc],
        List.forall_mem_append.2 ⟨hh.sat,
        List.forall_mem_append.2 ⟨hm.sat,
        List.forall_mem_append.2 ⟨hk.sat,
        List.forall_mem_append.2 ⟨hws.sat,
        List.forall_mem_append.2 ⟨hsvw,
        List.forall_mem_append.2 ⟨hsvs.sat, by simp⟩⟩⟩⟩⟩⟩⟩)
  refine ⟨s', hsteps, ?_, hasCells_of_holds hr hq (by braid_at),
    hasCells_of_holds hr hq (by braid_at), ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.sp]; exact Atoms.reg_of_holds (r := 31) hq (by braid_at)
  · rw [← hr.readReg (i := 29#5) (by decide)]
    exact Atoms.reg_of_holds (r := 29) hq (by braid_at)
  · rw [← hr.readReg (i := 19#5) (by decide)]
    exact Atoms.reg_of_holds (r := 19) hq (by braid_at)
  · rw [← hr.readReg (i := 20#5) (by decide)]
    exact Atoms.reg_of_holds (r := 20) hq (by braid_at)
  · rw [← hr.readReg (i := 21#5) (by decide)]
    exact Atoms.reg_of_holds (r := 21) hq (by braid_at)
  · rw [← hr.readReg (i := 22#5) (by decide)]
    exact Atoms.reg_of_holds (r := 22) hq (by braid_at)
  · rw [← hr.readReg (i := 23#5) (by decide)]
    exact Atoms.reg_of_holds (r := 23) hq (by braid_at)
  · rw [← hr.readReg (i := 24#5) (by decide)]
    exact Atoms.reg_of_holds (r := 24) hq (by braid_at)

end Examples.Sha256.O2.Arm
