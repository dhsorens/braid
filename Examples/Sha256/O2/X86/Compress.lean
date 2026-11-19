/-
  Examples.Sha256.O2.X86.Compress

  `sha256_compress` of `sha256.c` on x86-64, compiled at `-O2`: the compression function of
  SHA-256. As at `-O1` the compiler inlined `sha256_schedule` and `sha256_round` into it and
  keeps the eight working variables in registers through the 64 rounds. What `-O2` changes:

  * the three short copying loops and the loop that adds are gone. The block is copied to
    the start of the schedule by sixteen loads and sixteen stores in a line; the hash value
    is loaded into eight registers, its first word stays in `r11` and the other seven are
    stored below the schedule, to be added to the working variables at the end by eight
    additions and eight stores to the hash value;
  * the frame is 340 bytes where it was 328: seven words of the hash value, the schedule,
    eight bytes the code does not touch, and six saved registers (`r13` is new);
  * the loop of the schedule is the same instructions at other addresses;
  * a round is the same computation with the working variables, the index and the pointer
    to the round constants in other registers, and other registers for intermediate values;
  * the round constants are at `0x402320`, where they were at `0x4022b0`.

  The stages of the proof are those of `Examples.Sha256.X86.Compress`. The two loops
  (`compress_schedule_loop`, `compress_round_step`, `compress_rounds_loop`) are its
  statements with the addresses and the registers of this binary, and its proofs with the
  numbers of the registers changed and nothing else. The function itself is run again, with
  no loop to run out.

  ## Main results

  * `sha256_compress_spec`: the specification, with `Sha256.compress`
  * `sha256_compress_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256.O2.X86.Image
public import Examples.Sha256.X86.Machine
public import Examples.Sha256.RunTo

public section

namespace Examples.Sha256.O2.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs
open Examples.Sha256.X86

/-- A sum and a product as the lowering writes them: the stepper finds a memory atom by its
address as a term, and `a + b` as the elaborator reads it may have other type arguments. -/
local notation:65 a:65 " +ₐ " b:66 => @HAdd.hAdd Word Word Word _ a b

/-- A product as the lowering writes it (see `+ₐ`). -/
local notation:70 a:70 " *ₐ " b:71 => @HMul.hMul Word Word Word _ a b

/-! ## The message schedule -/

/-- Forget what the loop of the schedule leaves in the registers it uses and in the flags. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 2; braid_forget 3; braid_forget 4; braid_forget 8
             x86_forget_all_flags))

/-- The loop of the message schedule in `sha256_compress`, where `sha256_schedule` is
inlined and the array is on the stack: with a window of sixteen words of the schedule before
index `i` of the array 96 bytes below `sp`, and `js.length + 1` cells from that index on,
fill those cells with the next words of the schedule. -/
theorem compress_schedule_loop (sp : Word) : ∀ (js : List Word) (win : List W32)
    (j i t2 t3 t4 t8 : Word) (c pf af z sg o : Bool), win.length = 16 →
    i + BitVec.ofNat 64 (js.length + 1) = 64#64 → js.length + 1 ≤ 48 →
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x401190#64, .reg rax i, .reg rcx t2, .reg rdx t3,
        .reg rsi t4, .reg r8 t8, .reg rsp sp,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true (sp + i *ₐ 4#64 - 160#64) (w32s win ++ j :: js))])
      (Atoms.interp [.pc 0x4011db#64, .reg rax 64#64, .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .prop (regAny r8), .reg rsp sp,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true (sp + i *ₐ 4#64 - 160#64)
          (w32s (extend (js.length + 1) win)))]) := by
  intro js
  induction js with
  | nil =>
    intro win j i t2 t3 t4 t8 c pf af z sg o hw he hb
    obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
      eq_of_length_16 hw
    simp only [List.length_nil, Nat.zero_add] at he ⊢
    rw [w32s_extend_one]
    obtain ⟨q, rfl⟩ : ∃ q : BitVec 64, sp = q + 1#64 := ⟨sp - 1#64, by bv_omega⟩
    braid_unfold cells_win17 true (q + 1#64 + i *ₐ 4#64 - 160#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10
      w11 w12 w13 w14 w15 j []
    braid_sym_run
    · exact absurd (by bv_omega) hbr
    · sha256_cell (q + (1#64 + (i *ₐ 4#64 + 0xffffffffffffffa0#64))),
        (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]).setWidth
          64
      refine Triple.reg_val (r := 0) 64#64 (by braid_upd) he ?_
      sha256_fold cells_win17 true (q + 1#64 + i *ₐ 4#64 - 160#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9
        w10 w11 w12 w13 w14 w15
        ((nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]).setWidth
          64) []
      schedule_forget
      braid_done
  | cons j' js ih =>
    intro win j i t2 t3 t4 t8 c pf af z sg o hw he hb
    obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
      eq_of_length_16 hw
    simp only [List.length_cons] at he hb ⊢
    rw [w32s_extend_succ]
    obtain ⟨q, rfl⟩ : ∃ q : BitVec 64, sp = q + 1#64 := ⟨sp - 1#64, by bv_omega⟩
    braid_unfold cells_win17 true (q + 1#64 + i *ₐ 4#64 - 160#64) w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10
      w11 w12 w13 w14 w15 j (j' :: js)
    braid_sym_run
    · sha256_cell (q + (1#64 + (i *ₐ 4#64 + 0xffffffffffffffa0#64))),
        (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]).setWidth
          64
      sha256_fold cells_win16_at true (q + 1#64 + i *ₐ 4#64 - 156#64)
        (q + 1#64 + (i + 1#64) *ₐ 4#64 - 160#64) (by bv_omega) w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11
          w12 w13 w14 w15
        (nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]) (j' :: js)
      x86_name_all_flags
      braid_call ih [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, nextWord
        [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]]
        j' (i + 1#64) _ _ _ _ _ _ _ _ _ _ rfl (by bv_omega) (by omega)
      sha256_fold cells_cons_at true (q + 1#64 + i *ₐ 4#64 - 160#64)
        (q + 1#64 + (i + 1#64) *ₐ 4#64 - 160#64) (by bv_omega) (w0.setWidth 64)
        (w32s (extend (js.length + 1) [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14,
          w15,
          nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]]))
      braid_done
    · exact absurd hbr (by bv_omega)

/-! ## The rounds -/

/-- After the instructions of a round: give the registers the values of the specification,
close the two arrays, and forget the intermediate values. -/
local macro "round_finish " kp:term ", " sp:term ", " wk:term ", " W:term ", " v:term ", "
    t:term ", " hK:term ", " hW:term : tactic =>
  `(tactic| (sha256_reg 8, (round $W $v $t).a.setWidth 64
             sha256_reg 13, (round $W $v $t).b.setWidth 64
             sha256_reg 12, (round $W $v $t).c.setWidth 64
             sha256_reg 2, (round $W $v $t).d.setWidth 64
             sha256_reg 15, (round $W $v $t).e.setWidth 64
             sha256_reg 7, (round $W $v $t).f.setWidth 64
             sha256_reg 10, (round $W $v $t).g.setWidth 64
             sha256_reg 1, (round $W $v $t).h.setWidth 64
             refine Triple.reg_val (r := 0) (BitVec.ofNat 64 (4 * ($t + 1))) (by braid_upd)
               (by rw [BitVec.add_comm]; exact ofNat_mul4_succ $t) ?_
             sha256_fold cells_w32_index_at $wk $kp (BitVec.ofNat 64 (4 * $t) +ₐ $kp *ₐ 1#64) K
               $t $hK (by bv_omega)
             sha256_fold cells_w32_index_at true ($sp - 96#64)
               ($sp +ₐ BitVec.ofNat 64 (4 * $t) *ₐ 1#64 +ₐ 0xffffffffffffffa0#64) $W $t $hW
               (by bv_omega)
             braid_forget 9
             braid_forget 14
             braid_forget 4
             x86_forget_all_flags
             braid_done))

/-- One iteration of the loop of rounds in `sha256_compress`, where `sha256_round` is
inlined and the working variables are in registers: round `t`, with the round constants at
`kp` and the schedule 96 bytes below `sp`. It ends at the head of the loop, or after it when
`t` is the last round. -/
theorem compress_round_step (kp sp : Word) (wk : Bool) (W : List W32) (hW : W.length = 64)
    (t : Nat) (ht : t < 64) (v : Vars) (t9 t14 t4 : Word) (c pf af z sg o : Bool) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x401230#64, .reg r9 t9, .reg r14 t14, .reg rsi t4,
        .reg rax (BitVec.ofNat 64 (4 * t)), .reg rdx kp, .reg rsp sp,
        .reg r8 (v.a.setWidth 64), .reg r13 (v.b.setWidth 64), .reg r12 (v.c.setWidth 64),
        .reg rcx (v.d.setWidth 64), .reg r15 (v.e.setWidth 64), .reg rbp (v.f.setWidth 64),
        .reg r10 (v.g.setWidth 64), .reg rbx (v.h.setWidth 64),
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 wk kp (w32s K)), .prop (cellsAt 4 true (sp - 96#64) (w32s W))])
      (Atoms.interp [.pc (if t = 63 then 0x4012c5#64 else 0x401230#64),
        .prop (regAny r9), .prop (regAny r14), .prop (regAny rsi),
        .reg rax (BitVec.ofNat 64 (4 * (t + 1))), .reg rdx kp, .reg rsp sp,
        .reg r8 ((round W v t).a.setWidth 64),
        .reg r13 ((round W v t).b.setWidth 64), .reg r12 ((round W v t).c.setWidth 64),
        .reg rcx ((round W v t).d.setWidth 64), .reg r15 ((round W v t).e.setWidth 64),
        .reg rbp ((round W v t).f.setWidth 64), .reg r10 ((round W v t).g.setWidth 64),
        .reg rbx ((round W v t).h.setWidth 64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 wk kp (w32s K)), .prop (cellsAt 4 true (sp - 96#64) (w32s W))]) := by
  have hK : t < K.length := ht
  braid_unfold cells_w32_index_at wk kp (BitVec.ofNat 64 (4 * t) +ₐ kp *ₐ 1#64) K t hK
    (by bv_omega)
  braid_unfold cells_w32_index_at true (sp - 96#64)
    (sp +ₐ BitVec.ofNat 64 (4 * t) *ₐ 1#64 +ₐ 0xffffffffffffffa0#64) W t (hW ▸ ht)
    (by bv_omega)
  braid_sym_run
  · have h63 : t ≠ 63 := by rintro rfl; exact hbr (by decide)
    simp only [h63, ↓reduceIte]
    round_finish kp, sp, wk, W, v, t, hK, hW ▸ ht
  · obtain rfl : t = 63 := by bv_omega
    simp only [↓reduceIte]
    round_finish kp, sp, wk, W, v, 63, hK, hW ▸ ht

/-- The loop of rounds in `sha256_compress`, from round `t` to the last: an induction on
the number of rounds left, each of them `compress_round_step`. -/
theorem compress_rounds_loop (kp sp : Word) (wk : Bool) (W : List W32) (hW : W.length = 64) :
    ∀ (n t : Nat) (v : Vars) (t9 t14 t4 : Word) (c pf af z sg o : Bool), t + n + 1 = 64 →
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x401230#64, .reg r9 t9, .reg r14 t14, .reg rsi t4,
        .reg rax (BitVec.ofNat 64 (4 * t)), .reg rdx kp, .reg rsp sp,
        .reg r8 (v.a.setWidth 64), .reg r13 (v.b.setWidth 64), .reg r12 (v.c.setWidth 64),
        .reg rcx (v.d.setWidth 64), .reg r15 (v.e.setWidth 64), .reg rbp (v.f.setWidth 64),
        .reg r10 (v.g.setWidth 64), .reg rbx (v.h.setWidth 64),
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 wk kp (w32s K)), .prop (cellsAt 4 true (sp - 96#64) (w32s W))])
      (Atoms.interp [.pc 0x4012c5#64,
        .prop (regAny r9), .prop (regAny r14), .prop (regAny rsi),
        .reg rax 256#64, .reg rdx kp, .reg rsp sp,
        .reg r8 ((roundsFrom W t (n + 1) v).a.setWidth 64),
        .reg r13 ((roundsFrom W t (n + 1) v).b.setWidth 64), .reg r12 ((roundsFrom W t (n + 1)
          v).c.setWidth 64),
        .reg rcx ((roundsFrom W t (n + 1) v).d.setWidth 64), .reg r15 ((roundsFrom W t (n + 1)
          v).e.setWidth 64),
        .reg rbp ((roundsFrom W t (n + 1) v).f.setWidth 64), .reg r10 ((roundsFrom W t (n + 1)
          v).g.setWidth 64),
        .reg rbx ((roundsFrom W t (n + 1) v).h.setWidth 64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 wk kp (w32s K)), .prop (cellsAt 4 true (sp - 96#64) (w32s W))]) := by
  intro n
  induction n with
  | zero =>
    intro t v t9 t14 t4 c pf af z sg o hn
    obtain rfl : t = 63 := by omega
    rw [roundsFrom_one]
    braid_call compress_round_step kp sp wk W hW 63 (by omega) v t9 t14 t4 c pf af z sg o
    braid_done
  | succ n ih =>
    intro t v t9 t14 t4 c pf af z sg o hn
    have h63 : t ≠ 63 := by omega
    rw [roundsFrom_succ]
    braid_call compress_round_step kp sp wk W hW t (by omega) v t9 t14 t4 c pf af z sg o
    simp only [h63, ↓reduceIte]
    braid_name_reg 9
    braid_name_reg 14
    braid_name_reg 4
    x86_name_all_flags
    braid_call ih (t + 1) (round W v t) _ _ _ _ _ _ _ _ _ (by omega)
    braid_done

/-! ## The compression function -/

/-- An array of seven 32-bit cells, as memory atoms. -/
theorem cells7 (w : Bool) (p v0 v1 v2 v3 v4 v5 v6 : Word) :
    (Atom.prop (cellsAt 4 w p [v0, v1, v2, v3, v4, v5, v6])).interp =
      Atoms.interp [.mem p 4 v0 w, .mem (p + 4#64) 4 v1 w, .mem (p + 8#64) 4 v2 w,
        .mem (p + 12#64) 4 v3 w, .mem (p + 16#64) 4 v4 w, .mem (p + 20#64) 4 v5 w,
        .mem (p + 24#64) 4 v6 w] := by
  rw [cells_eq_atoms]
  simp only [cellsAtoms, BitVec.add_assoc, BitVec.reduceAdd]

/-- Seven 32-bit words in memory, as memory atoms. -/
theorem cells7_w32 (w : Bool) (p : Word) (x0 x1 x2 x3 x4 x5 x6 : W32) :
    (Atom.prop (cellsAt 4 w p (w32s [x0, x1, x2, x3, x4, x5, x6]))).interp =
      Atoms.interp [.mem p 4 (x0.setWidth 64) w, .mem (p + 4#64) 4 (x1.setWidth 64) w,
        .mem (p + 8#64) 4 (x2.setWidth 64) w, .mem (p + 12#64) 4 (x3.setWidth 64) w,
        .mem (p + 16#64) 4 (x4.setWidth 64) w, .mem (p + 20#64) 4 (x5.setWidth 64) w,
        .mem (p + 24#64) 4 (x6.setWidth 64) w] :=
  cells7 w p _ _ _ _ _ _ _

/-- **The exit of `sha256_compress`**, from the end of the loop of rounds: it adds each
working variable to its word of the hash value, the first from `r11` and the other seven
from the frame, stores the sums to the hash value, pops the six registers and returns. It is
a triple of its own because one declaration that runs all of the code does not fit in the
default limit on heartbeats. -/
theorem compress_tail_spec (hp s r : Word) (h0 h1 h2 h3 h4 h5 h6 h7 : W32) (R : Vars)
    (vb vp v12 v13 v14 v15 t0 t14 : Word) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x4012c5#64, .reg rdi hp, .reg rax t0, .reg r14 t14,
        .reg r11 (h0.setWidth 64), .reg rsp (s - 216#64),
        .reg r8 (R.a.setWidth 64), .reg r13 (R.b.setWidth 64), .reg r12 (R.c.setWidth 64),
        .reg rcx (R.d.setWidth 64), .reg r15 (R.e.setWidth 64), .reg rbp (R.f.setWidth 64),
        .reg r10 (R.g.setWidth 64), .reg rbx (R.h.setWidth 64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true hp (w32s [h0, h1, h2, h3, h4, h5, h6, h7])),
        .prop (cellsAt 4 true (s - 340#64) (w32s [h1, h2, h3, h4, h5, h6, h7])),
        .prop (cellsAt 8 true (s - 48#64) [vb, v12, v13, v14, v15, vp]),
        .prop (cellsAt 8 true s [r])])
      (Atoms.interp [.pc r, .reg rdi hp, .prop (regAny rax), .reg r14 v14,
        .prop (regAny r11), .reg rsp (s + 8#64),
        .prop (regAny r8), .reg r13 v13, .reg r12 v12, .prop (regAny rcx), .reg r15 v15,
        .reg rbp vp, .prop (regAny r10), .reg rbx vb,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true hp (w32s [R.a + h0, R.b + h1, R.c + h2, R.d + h3, R.e + h4,
          R.f + h5, R.g + h6, R.h + h7])),
        .prop (cellsAt 4 true (s - 340#64) (w32s [h1, h2, h3, h4, h5, h6, h7])),
        .prop (cellsAt 8 true (s - 48#64) [vb, v12, v13, v14, v15, vp]),
        .prop (cellsAt 8 true s [r])]) := by
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 341#64 := ⟨s - 341#64, by bv_omega⟩
  braid_unfold cells8_w32 true (hq + 1#64) h0 h1 h2 h3 h4 h5 h6 h7
  braid_unfold cells7_w32 true (sq + 1#64) h1 h2 h3 h4 h5 h6 h7
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 293#64) vb [v12, v13, v14, v15, vp]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 301#64) v12 [v13, v14, v15, vp]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 309#64) v13 [v14, v15, vp]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 317#64) v14 [v15, vp]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 325#64) v15 [vp]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 333#64) vp []
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 341#64) r []
  braid_sym_run_to 0x401315
  sha256_reg 6, sq + 293#64
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
  sha256_fold cells7_w32 true (sq + 1#64) h1 h2 h3 h4 h5 h6 h7
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 333#64) vp []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 325#64) v15 [vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 317#64) v14 [v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 309#64) v13 [v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 301#64) v12 [v13, v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 293#64) vb [v12, v13, v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 341#64) r []
  braid_forget 0
  braid_forget 2
  braid_forget 8
  braid_forget 10
  braid_forget 11
  x86_forget_all_flags
  braid_done

/-- `sha256_compress` replaces the hash value its first argument points to by the
compression of it with the block its second argument points to, and returns through the
address on the stack. It reads the round constants from the data of the image at
`0x402320`, and uses 340 bytes below the stack pointer, less the eight between the schedule
and the saved registers: six callee-saved registers, which it saves and restores, the
message schedule, and the last seven words of the hash value it was given. -/
theorem sha256_compress_spec (hp mp s r vb vp v12 v13 v14 v15 : Word) (H M : List W32)
    (wm wk : Bool) (fvs fws sv : List Word) (t0 t2 t3 t8 t9 t10 t11 : Word)
    (c pf af z sg o : Bool) (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 7)
    (hfw : fws.length = 64) (hsv : sv.length = 6) :
    Triple sha256_compress.program
      (Atoms.interp [.pc 0x401100#64, .reg rdi hp, .reg rsi mp, .reg rax t0, .reg rcx t2,
        .reg rdx t3, .reg r8 t8, .reg r9 t9, .reg r10 t10, .reg r11 t11, .reg rbx vb,
        .reg rbp vp, .reg r12 v12, .reg r13 v13, .reg r14 v14, .reg r15 v15, .reg rsp s,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x402320#64 (w32s K)),
        .prop (cellsAt 4 true (s - 340#64) fvs), .prop (cellsAt 4 true (s - 312#64) fws),
        .prop (cellsAt 8 true (s - 48#64) sv), .prop (cellsAt 8 true s [r])])
      (Atoms.interp [.pc r, .reg rdi hp, .prop (regAny rsi), .prop (regAny rax),
        .prop (regAny rcx), .prop (regAny rdx), .prop (regAny r8), .prop (regAny r9),
        .prop (regAny r10), .prop (regAny r11), .reg rbx vb, .reg rbp vp, .reg r12 v12,
        .reg r13 v13, .reg r14 v14, .reg r15 v15, .reg rsp (s + 8#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true hp (w32s (compress H M))), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x402320#64 (w32s K)),
        .prop (cellsAt 4 true (s - 340#64) (w32s H.tail)),
        .prop (cellsAt 4 true (s - 312#64) (w32s (schedule M))),
        .prop (cellsAt 8 true (s - 48#64) [vb, v12, v13, v14, v15, vp]),
        .prop (cellsAt 8 true s [r])]) := by
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ := eq_of_length_8 hH
  obtain ⟨m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15, rfl⟩ :=
    eq_of_length_16 hM
  obtain ⟨v1, v2, v3, v4, v5, v6, v7, rfl⟩ :
      ∃ v1 v2 v3 v4 v5 v6 v7, fvs = [v1, v2, v3, v4, v5, v6, v7] := by
    match fvs, hfv with
    | [v1, v2, v3, v4, v5, v6, v7], _ => exact ⟨v1, v2, v3, v4, v5, v6, v7, rfl⟩
  obtain ⟨f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, js, rfl, hjs⟩ :=
    eq_of_length_16_add (n := 48) hfw
  obtain ⟨j, js', rfl⟩ : ∃ j js', js = j :: js' := by
    cases js with
    | nil => simp at hjs
    | cons a b => exact ⟨a, b, rfl⟩
  obtain ⟨s0, s1, s2, s3, s4, s5, rfl⟩ : ∃ s0 s1 s2 s3 s4 s5, sv = [s0, s1, s2, s3, s4, s5] := by
    match sv, hsv with
    | [s0, s1, s2, s3, s4, s5], _ => exact ⟨s0, s1, s2, s3, s4, s5, rfl⟩
  have h47 : js'.length = 47 := by simpa using hjs
  rw [compress_eq, List.tail_cons]
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨mq, rfl⟩ : ∃ mq : BitVec 64, mp = mq + 1#64 := ⟨mp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 341#64 := ⟨s - 341#64, by bv_omega⟩
  braid_unfold cells8_w32 true (hq + 1#64) h0 h1 h2 h3 h4 h5 h6 h7
  braid_unfold cells16_w32 wm (mq + 1#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
  braid_unfold cells7 true (sq + 1#64) v1 v2 v3 v4 v5 v6 v7
  braid_unfold cells_pre16 true (sq + 29#64) f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13
    f14 f15 (j :: js')
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 293#64) s0 [s1, s2, s3, s4, s5]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 301#64) s1 [s2, s3, s4, s5]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 309#64) s2 [s3, s4, s5]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 317#64) s3 [s4, s5]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 325#64) s4 [s5]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 333#64) s5 []
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 341#64) r []
  -- The registers saved, and the block copied to the start of the schedule.
  braid_sym_run_to 0x401190
  -- The message schedule.
  sha256_fold cells_win16 true (sq + 29#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
    (j :: js')
  x86_name_all_flags
  braid_call compress_schedule_loop (sq + 125#64) js' [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10,
    m11, m12, m13, m14, m15] j 16#64 _ _ _ _ _ _ _ _ _ _ rfl
    (by rw [h47]; rfl) (by omega)
  simp only [h47, Nat.reduceAdd]
  rw [← schedule_eq_extend [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15]
    rfl]
  braid_name_reg 2
  braid_name_reg 3
  braid_name_reg 4
  braid_name_reg 8
  -- The hash value loaded into registers, and seven words of it stored in the frame.
  braid_sym_run_to 0x4011f9
  sha256_reg 0, 0#64
  braid_sym_run_to 0x401230
  x86_name_all_flags
  -- The rounds.
  braid_call compress_rounds_loop 0x402320#64 (sq + 125#64) wk (schedule [m0, m1, m2, m3, m4, m5,
    m6, m7, m8, m9, m10, m11, m12, m13, m14, m15])
    (schedule_length _ rfl) 63 0 ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ _ _ _ _ _ _ _ _ _ (by omega)
  simp only [Nat.reduceAdd]
  rw [← rounds_eq_roundsFrom]
  generalize rounds (schedule [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14,
    m15]) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64 = R
  braid_name_reg 14
  -- The working variables added to the hash value; the registers restored.
  sha256_fold cells8_w32 true (hq + 1#64) h0 h1 h2 h3 h4 h5 h6 h7
  sha256_fold cells7_w32 true (sq + 1#64) h1 h2 h3 h4 h5 h6 h7
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 333#64) vp []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 325#64) v15 [vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 317#64) v14 [v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 309#64) v13 [v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 301#64) v12 [v13, v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 293#64) vb [v12, v13, v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 341#64) r []
  braid_call compress_tail_spec (hq + 1#64) (sq + 341#64) r h0 h1 h2 h3 h4 h5 h6 h7 R vb vp v12
    v13 v14 v15 _ _
  sha256_fold cells16_w32 wm (mq + 1#64) m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15
  braid_forget 3
  braid_done

/-! ## On the machine -/

/-- **`sha256_compress` on the machine.** A machine of the model that runs the executable of
this image, is at the entry of `sha256_compress`, and has in memory the hash value `H` (eight
words) where `rdi` points, the block `M` (sixteen words) where `rsi` points, the round
constants of SHA-256 at `0x402320`, where the code looks for them, the return address `r` in
the eight bytes at the stack pointer and, in the 340 bytes below them, seven words `fvs`,
64 words `fws` and, eight bytes further, six double words `sv`, all of which are
overwritten, where the hash value, the block, the round constants and those 348 bytes of
stack are pairwise apart, reaches `r` on every run, with the compression of `H` with `M`
where `rdi` pointed. The block is as it
was, the stack pointer is above the return address, and the callee-saved registers the code
uses are as they were. -/
theorem sha256_compress_correct [Layout] (m : MachineState) (H M fvs fws : List W32)
    (sv : List Word) (r : Word) (hpc : m.pc = 0x401100)
    (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 7) (hfw : fws.length = 64)
    (hsvl : sv.length = 6)
    (hh : HasCells m (m.data.regs.get64 .rdi) H) (hm : HasCells m (m.data.regs.get64 .rsi) M)
    (hk : HasCells m 0x402320#64 K)
    (hv : HasCells m ((m.data.regs.get64 .rsp) - 340#64) fvs)
    (hws : HasCells m ((m.data.regs.get64 .rsp) - 312#64) fws)
    (hsv : HasWords m ((m.data.regs.get64 .rsp) - 48#64) sv)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hhm : Apart (m.data.regs.get64 .rdi) 32 (m.data.regs.get64 .rsi) 64)
    (hhk : Apart (m.data.regs.get64 .rdi) 32 0x402320#64 256)
    (hhs : Apart (m.data.regs.get64 .rdi) 32 ((m.data.regs.get64 .rsp) - 340#64) 348)
    (hmk : Apart (m.data.regs.get64 .rsi) 64 0x402320#64 256)
    (hms : Apart (m.data.regs.get64 .rsi) 64 ((m.data.regs.get64 .rsp) - 340#64) 348)
    (hks : Apart 0x402320#64 256 ((m.data.regs.get64 .rsp) - 340#64) 348) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        HasCells m' (m.data.regs.get64 .rdi) (compress H M) ∧
        HasCells m' (m.data.regs.get64 .rsi) M ∧
        m'.data.regs.get64 .rsp = (m.data.regs.get64 .rsp) + 8#64 ∧
        m'.data.regs.get64 .rbx = (m.data.regs.get64 .rbx) ∧
        m'.data.regs.get64 .rbp = (m.data.regs.get64 .rbp) ∧
        m'.data.regs.get64 .r12 = (m.data.regs.get64 .r12) ∧
        m'.data.regs.get64 .r13 = (m.data.regs.get64 .r13) ∧
        m'.data.regs.get64 .r14 = (m.data.regs.get64 .r14) ∧
        m'.data.regs.get64 .r15 = (m.data.regs.get64 .r15)) m := by
  have hlK : K.length = 64 := rfl
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat sha256_compress_holds
    (sha256_compress_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64
      .rsp) r
      (m.data.regs.get64 .rbx) (m.data.regs.get64 .rbp) (m.data.regs.get64 .r12) (m.data.regs.get64
        .r13) (m.data.regs.get64 .r14)
      (m.data.regs.get64 .r15) H M true true (w32s fvs) (w32s fws) sv (m.data.regs.get64 .rax)
      (m.data.regs.get64 .rcx) (m.data.regs.get64 .rdx) (m.data.regs.get64 .r8) (m.data.regs.get64
        .r9)
      (m.data.regs.get64 .r10) (m.data.regs.get64 .r11) m.data.status.cf m.data.status.pf
      m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of hH hM
      (by simpa using hfv) (by simpa using hfw) hsvl)
    (flat := [.pc 0x401100#64, .reg rdi (m.data.regs.get64 .rdi), .reg rsi (m.data.regs.get64 .rsi),
      .reg rax (m.data.regs.get64 .rax), .reg rcx (m.data.regs.get64 .rcx),
      .reg rdx (m.data.regs.get64 .rdx), .reg r8 (m.data.regs.get64 .r8),
      .reg r9 (m.data.regs.get64 .r9), .reg r10 (m.data.regs.get64 .r10),
      .reg r11 (m.data.regs.get64 .r11), .reg rbx (m.data.regs.get64 .rbx),
      .reg rbp (m.data.regs.get64 .rbp), .reg r12 (m.data.regs.get64 .r12),
      .reg r13 (m.data.regs.get64 .r13), .reg r14 (m.data.regs.get64 .r14),
      .reg r15 (m.data.regs.get64 .r15), .reg rsp (m.data.regs.get64 .rsp),
      .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
      .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
      .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of] ++
      (cellsAtoms 4 true (m.data.regs.get64 .rdi) (w32s H) ++
      (cellsAtoms 4 true (m.data.regs.get64 .rsi) (w32s M) ++
      (cellsAtoms 4 true 0x402320#64 (w32s K) ++
      (cellsAtoms 4 true ((m.data.regs.get64 .rsp) - 340#64) (w32s fvs) ++
      (cellsAtoms 4 true ((m.data.regs.get64 .rsp) - 312#64) (w32s fws) ++
      (cellsAtoms 8 true ((m.data.regs.get64 .rsp) - 48#64) sv ++
      (cellsAtoms 8 true (m.data.regs.get64 .rsp) [r] ++ []))))))))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩⟩⟩⟩⟩⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩⟩⟩⟩⟩⟩⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hH]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hM]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hlK]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hfv]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hfw]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hsvl]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp), .nil, disj_nil_right⟩,
        -- the saved registers, and the return address
        disj_append_right (cellsAtoms_disj (by simp [hsvl]; bv_omega) (by simp; bv_omega))
          disj_nil_right⟩,
        -- the schedule, and what follows it
        disj_append_right (cellsAtoms_disj (by simp [hfw]; bv_omega) (by simp [hsvl]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hfw]; bv_omega) (by simp; bv_omega))
          disj_nil_right)⟩,
        -- the working variables, and what follows them
        disj_append_right (cellsAtoms_disj (by simp [hfv]; bv_omega) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hfv]; bv_omega) (by simp [hsvl]; bv_omega))
          (disj_append_right (cellsAtoms_disj (by simp [hfv]; bv_omega) (by simp; bv_omega))
          disj_nil_right))⟩,
        -- the round constants, and what follows them
        disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hfv])
            (by simp [hlK]) (by simp [hfv]))
          (disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hfw])
            (by simp [hlK]) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp [hsvl])
            (by simp [hlK]) (by simp [hsvl]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp)
            (by simp [hlK]) (by simp; bv_omega))
          disj_nil_right)))⟩,
        -- the block, and what follows it
        disj_append_right (cellsAtoms_disj_of_apart hmk.1 hmk.2 (by simp [hM]) (by simp [hlK])
            (by simp [hM]) (by simp [hlK]))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hfv])
            (by simp [hM]) (by simp [hfv]))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hfw])
            (by simp [hM]) (by simp [hfw]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp [hsvl])
            (by simp [hM]) (by simp [hsvl]; bv_omega))
          (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp)
            (by simp [hM]) (by simp; bv_omega))
          disj_nil_right))))⟩,
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
          (disj_append_right (cellsAtoms_disj_of_apart hhs.1 hhs.2 (by simp [hH]) (by simp)
            (by simp [hH]) (by simp; bv_omega))
          disj_nil_right)))))⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, regOf, flagOf, hpc],
        List.forall_mem_append.2 ⟨hh.sat,
        List.forall_mem_append.2 ⟨hm.sat,
        List.forall_mem_append.2 ⟨hk.sat,
        List.forall_mem_append.2 ⟨hv.sat,
        List.forall_mem_append.2 ⟨hws.sat,
        List.forall_mem_append.2 ⟨hsv.sat,
        List.forall_mem_append.2 ⟨sat_word hret, by simp⟩⟩⟩⟩⟩⟩⟩⟩))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, hasCells_of_holds hr hq (by braid_at), hasCells_of_holds hr hq (by braid_at),
    ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rsp]; exact Atoms.reg_of_holds (r := 6) hq (by braid_at)
  · rw [← hr.reg .rbx]; exact Atoms.reg_of_holds (r := 1) hq (by braid_at)
  · rw [← hr.reg .rbp]; exact Atoms.reg_of_holds (r := 7) hq (by braid_at)
  · rw [← hr.reg .r12]; exact Atoms.reg_of_holds (r := 12) hq (by braid_at)
  · rw [← hr.reg .r13]; exact Atoms.reg_of_holds (r := 13) hq (by braid_at)
  · rw [← hr.reg .r14]; exact Atoms.reg_of_holds (r := 14) hq (by braid_at)
  · rw [← hr.reg .r15]; exact Atoms.reg_of_holds (r := 15) hq (by braid_at)

end Examples.Sha256.O2.X86
