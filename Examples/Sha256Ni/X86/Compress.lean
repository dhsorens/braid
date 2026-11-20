/-
  Examples.Sha256Ni.X86.Compress

  `sha256_compress_ni` of `sha256_ni.c` on x86-64: the compression function of SHA-256,
  written with the SHA instructions.

  The code has no frame. It loads the hash value as two vectors and shuffles them into the
  two vectors of working variables that `sha256rnds2` works on, `(a, b, e, f)` and
  `(c, d, g, h)`, of which it keeps a copy in `xmm4` and `xmm3` for the sum at the end; loads
  the block as four vectors, the first window of the schedule; runs the two loops of
  `Examples.Sha256Ni.X86.Round`; adds the copies; and shuffles the two vectors back into the
  order of the hash value, which it stores. The hash value, the block and the table of round
  constants are arrays of 32-bit words in the specification and of 64-bit cells to the code,
  which are the same (`Sha256Ni.cells_w32_packs`).

  The proof is in stages, and the terms of one stage do not reach the next: the entry is run
  by the stepper and the four registers it computes are given their values in lanes; the
  first loop is `loop_spec`, used as a call; the four turns of the second loop are
  `tail_spec`, called one after another; and after the exit shuffles the four words to be
  stored are given their values in lanes.

  ## Main results

  * `sha256_compress_ni_spec`: the specification, with `Sha256.compress`
-/

module

public import Examples.Sha256Ni.X86.Round

public section

namespace Examples.Sha256Ni.X86

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.X86 Lowering.X86.Regs

/-- Give a register of the symbolic state the value `v`, two lanes, where the code computed
it with shuffles of lanes: `ni_reg r, v`. That the two are equal is for `bv_decide`. -/
local macro "ni_reg " r:term ", " v:term : tactic =>
  `(tactic| (refine Triple.reg_val (r := $r) $v (by braid_upd) ?_ ?_
             · (simp only [pack]; bv_decide)))

/-- Forget what the ten vector registers the code uses hold. -/
local macro "ni_forget_vectors" : tactic =>
  `(tactic| (braid_forget 32; braid_forget 33; braid_forget 40; braid_forget 41
             braid_forget 48; braid_forget 49; braid_forget 56; braid_forget 57
             braid_forget 64; braid_forget 65; braid_forget 72; braid_forget 73
             braid_forget 80; braid_forget 81; braid_forget 88; braid_forget 89
             braid_forget 96; braid_forget 97; braid_forget 104; braid_forget 105))

/-- A turn of the second loop: `tail_spec` for turn `j`, with `rcx` holding `c` and the
working variables `v`, on the window `W` written out. -/
local macro "ni_tail " wk:term ", " j:term ", " c:term ", " v:term ", " W:term : tactic =>
  `(tactic| (have ht := tail_spec $wk $j (by omega) $c rfl $W $v
             simp only [rowLo, rowHi, abefLo, abefHi, cdghLo, cdghHi, List.getD_cons_succ,
               List.getD_cons_zero, Nat.reduceMul, Nat.reduceAdd] at ht
             braid_call ht _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
             clear ht
             braid_name_reg 32
             braid_name_reg 33
             braid_name_reg 48
             braid_name_reg 49
             x86_name_all_flags))

/-- **`sha256_compress_ni`** replaces the hash value its first argument points to by the
compression of it with the block its second argument points to, and returns through the
address on the stack. It reads the round constants from the data of the image at `0x402110`,
sixteen bytes at a time, and uses no stack below the return address. It leaves `rdi`, `rsi`,
the block and the table as they were, the stack pointer above the return address, and
`rax`, `rcx`, the vector registers `xmm0` to `xmm9` and the flags with some values. -/
theorem sha256_compress_ni_spec (hp mp s r : Word) (H M : List W32) (wm wk : Bool)
    (t0 t2 u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u8 u8' u9 u9' : Word)
    (c pf af z sg o : Bool) (hH : H.length = 8) (hM : M.length = 16) :
    Triple sha256_compress_ni.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi hp, .reg rsi mp, .reg rax t0, .reg rcx t2,
        .reg rsp s,
        .reg (zmm 0 0) u0, .reg (zmm 0 1) u0', .reg (zmm 1 0) u1, .reg (zmm 1 1) u1',
        .reg (zmm 2 0) u2, .reg (zmm 2 1) u2', .reg (zmm 3 0) u3, .reg (zmm 3 1) u3',
        .reg (zmm 4 0) u4, .reg (zmm 4 1) u4', .reg (zmm 5 0) u5, .reg (zmm 5 1) u5',
        .reg (zmm 6 0) u6, .reg (zmm 6 1) u6', .reg (zmm 7 0) u7, .reg (zmm 7 1) u7',
        .reg (zmm 8 0) u8, .reg (zmm 8 1) u8', .reg (zmm 9 0) u9, .reg (zmm 9 1) u9',
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x402110#64 (w32s K)), .prop (cellsAt 8 true s [r])])
      (Atoms.interp [.pc r, .reg rdi hp, .reg rsi mp, .prop (regAny rax), .prop (regAny rcx),
        .reg rsp (s + 8#64),
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)), .prop (regAny (zmm 1 0)),
        .prop (regAny (zmm 1 1)), .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .prop (regAny (zmm 3 0)), .prop (regAny (zmm 3 1)), .prop (regAny (zmm 4 0)),
        .prop (regAny (zmm 4 1)), .prop (regAny (zmm 5 0)), .prop (regAny (zmm 5 1)),
        .prop (regAny (zmm 6 0)), .prop (regAny (zmm 6 1)), .prop (regAny (zmm 7 0)),
        .prop (regAny (zmm 7 1)), .prop (regAny (zmm 8 0)), .prop (regAny (zmm 8 1)),
        .prop (regAny (zmm 9 0)), .prop (regAny (zmm 9 1)),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true hp (w32s (compress H M))), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x402110#64 (w32s K)), .prop (cellsAt 8 true s [r])]) := by
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ := eq_of_length_8 hH
  obtain ⟨m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15, rfl⟩ :=
    eq_of_length_16 hM
  -- The arrays, as 64-bit cells; the compression function, four rounds at a time.
  rw [compress_eq_steps h0 h1 h2 h3 h4 h5 h6 h7 _ rfl, cells_w32_packs true 4 hp _ rfl,
    cells_w32_packs true 4 hp _ rfl, cells_w32_packs wm 8 mp _ rfl,
    cells_w32_packs wk 32 0x402110#64 K rfl]
  simp only [packs, rounds16At, Nat.reduceAdd]
  -- The first loop, and the window and the working variables it leaves.
  have hl := fun x0 x0' x2 x2' fc fp fa fz fs fo => loop_spec wk 11 0 0#64
    [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15]
    ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ x0 x0' x2 x2' fc fp fa fz fs fo (by omega) rfl rfl
  simp only [Nat.reduceMul, Nat.reduceAdd] at hl
  have hSl := steps_length 12 0 [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13,
    m14, m15] ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ rfl
  generalize steps 0 12 [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15]
    ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ = S at hl hSl ⊢
  obtain ⟨W, v⟩ := S
  obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
    eq_of_length_16 hSl
  simp only [rowLo, rowHi, abefLo, abefHi, cdghLo, cdghHi, List.getD_cons_succ,
    List.getD_cons_zero, Nat.reduceMul, Nat.reduceAdd] at hl
  braid_unfold cells4 true hp _ _ _ _
  braid_unfold cells8x8 wm mp _ _ _ _ _ _ _ _
  braid_unfold cellsAt_cons (k := 8) (w := true) s r []
  -- The hash value loaded and shuffled into the two vectors of working variables.
  iterate 7 braid_sym_step
  ni_reg 64, pack h5 h4
  ni_reg 65, pack h1 h0
  ni_reg 56, pack h7 h6
  ni_reg 57, pack h3 h2
  -- The block loaded, the count cleared, and the working variables copied.
  iterate 5 braid_sym_step
  sha256_reg 2, 0#64
  braid_sym_run_to 0x401050
  x86_name_all_flags
  braid_call hl _ _ _ _ _ _ _ _ _ _
  clear hl
  braid_name_reg 32
  braid_name_reg 33
  braid_name_reg 48
  braid_name_reg 49
  x86_name_all_flags
  -- The count cleared again, and the four turns of the second loop.
  braid_sym_step
  sha256_reg 2, 0#64
  braid_sym_step
  x86_name_all_flags
  ni_tail wk, 0, 0#64, v, [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]
  generalize rounds4At 48 0 _ v = v1
  ni_tail wk, 1, 16#64, v1, [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]
  generalize rounds4At 52 4 _ v1 = v2
  ni_tail wk, 2, 32#64, v2, [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]
  generalize rounds4At 56 8 _ v2 = v3
  ni_tail wk, 3, 48#64, v3, [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]
  generalize rounds4At 60 12 _ v3 = R
  -- The sum with the hash value, and the two vectors shuffled back into its order.
  iterate 2 braid_sym_step
  simp only [pack_add]
  iterate 5 braid_sym_step
  ni_reg 48, pack (R.a + h0) (R.b + h1)
  ni_reg 49, pack (R.c + h2) (R.d + h3)
  ni_reg 40, pack (R.e + h4) (R.f + h5)
  ni_reg 41, pack (R.g + h6) (R.h + h7)
  -- The stores, and the return.
  braid_sym_run
  sha256_fold cells4 true hp (pack (R.a + h0) (R.b + h1)) (pack (R.c + h2) (R.d + h3))
    (pack (R.e + h4) (R.f + h5)) (pack (R.g + h6) (R.h + h7))
  sha256_fold cells8x8 wm mp (pack m0 m1) (pack m2 m3) (pack m4 m5) (pack m6 m7) (pack m8 m9)
    (pack m10 m11) (pack m12 m13) (pack m14 m15)
  sha256_fold cellsAt_cons (k := 8) (w := true) s r []
  ni_forget_vectors
  braid_forget 0
  braid_forget 2
  x86_forget_all_flags
  braid_done

end Examples.Sha256Ni.X86
