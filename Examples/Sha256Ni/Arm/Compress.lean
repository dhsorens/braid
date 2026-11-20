/-
  Examples.Sha256Ni.Arm.Compress

  `sha256_compress_ni` of `sha256_ni.c` on AArch64: the compression function of SHA-256,
  written with the SHA-2 instructions.

  The code has no frame and uses no stack. It loads the hash value as two vectors, the
  working variables `a` to `d` and `e` to `h`, which `sha256h` and `sha256h2` work on as they
  are, and keeps them in `v1` and `v0` for the sum at the end; loads the block as four
  vectors, the first window of the schedule; runs the two loops of
  `Examples.Sha256Ni.Arm.Round`; adds the hash value; and stores the two sums. The hash
  value, the block and the table of round constants are arrays of 32-bit words in the
  specification and of 64-bit cells to the code, which are the same
  (`Sha256Ni.cells_w32_packs`).

  The proof is in stages, and the terms of one stage do not reach the next: the entry is run
  by the stepper; the first loop is `loop_spec`, used as a call; the four turns of the
  second loop are `tail_spec`, called one after another; and the sums and the stores are run
  by the stepper.

  ## Main results

  * `sha256_compress_ni_spec`: the specification, with `Sha256.compress`
-/

module

public import Examples.Sha256Ni.Arm.Round

public section

namespace Examples.Sha256Ni.Arm

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.Arm Lowering.Arm.Regs

/-- Forget what the vector registers `v0` to `v7` and `v16` to `v18` hold. -/
macro "ni_forget_vectors" : tactic =>
  `(tactic| (
             braid_forget (vlo 0); braid_forget (vhi 0)
             braid_forget (vlo 1); braid_forget (vhi 1)
             braid_forget (vlo 2); braid_forget (vhi 2)
             braid_forget (vlo 3); braid_forget (vhi 3)
             braid_forget (vlo 4); braid_forget (vhi 4)
             braid_forget (vlo 5); braid_forget (vhi 5)
             braid_forget (vlo 6); braid_forget (vhi 6)
             braid_forget (vlo 7); braid_forget (vhi 7)
             braid_forget (vlo 16); braid_forget (vhi 16)
             braid_forget (vlo 17); braid_forget (vhi 17)
             braid_forget (vlo 18); braid_forget (vhi 18)))

/-- Name what the four flags hold. -/
macro "ni_name_flags" : tactic =>
  `(tactic| (braid_name_flag 0; braid_name_flag 1; braid_name_flag 2; braid_name_flag 3))

/-- A turn of the second loop: `tail_spec` for turn `j`, with `x9` holding `c` and the
working variables `v`, on the window `W` written out. -/
local macro "ni_tail " wk:term ", " j:term ", " c:term ", " v:term ", " W:term : tactic =>
  `(tactic| (have ht := tail_spec $wk $j (by omega) $c rfl $W $v
             simp only [rowLo, rowHi, abcdLo, abcdHi, efghLo, efghHi, List.getD_cons_succ,
               List.getD_cons_zero, Nat.reduceMul, Nat.reduceAdd] at ht
             braid_call ht _ _ _ _ _ _ _ _ _ _ _ _ _
             clear ht
             braid_name_reg 10
             braid_name_reg (vlo 16)
             braid_name_reg (vhi 16)
             ni_name_flags))

/-- **`sha256_compress_ni`** replaces the hash value its first argument points to by the
compression of it with the block its second argument points to, and returns to the address
in the link register. It reads the round constants from read-only data at `0x20228`, sixteen
bytes at a time, and uses no stack. It leaves `x0`, `x1`, the link register, the block and
the table as they were, and `x8`, `x9`, `x10`, the vector registers `v0` to `v7` and `v16`
to `v19` and the flags with some values. -/
theorem sha256_compress_ni_spec (hp mp r : Word) (H M : List W32) (wm : Bool)
    (t8 t9 t10
      u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u16 u16' u17 u17' u18 u18' u19 u19'
      : Word)
    (fn fz fc fv : Bool) (hH : H.length = 8) (hM : M.length = 16) :
    Triple sha256_compress_ni.program
      (Atoms.interp [.pc 0x100bc#64, .reg x0 hp, .reg x1 mp, .reg x8 t8, .reg x9 t9,
        .reg x10 t10,
        .reg (vlo 0) u0, .reg (vhi 0) u0', .reg (vlo 1) u1, .reg (vhi 1) u1',
        .reg (vlo 2) u2, .reg (vhi 2) u2', .reg (vlo 3) u3, .reg (vhi 3) u3',
        .reg (vlo 4) u4, .reg (vhi 4) u4', .reg (vlo 5) u5, .reg (vhi 5) u5',
        .reg (vlo 6) u6, .reg (vhi 6) u6', .reg (vlo 7) u7, .reg (vhi 7) u7',
        .reg (vlo 16) u16, .reg (vhi 16) u16', .reg (vlo 17) u17, .reg (vhi 17) u17',
        .reg (vlo 18) u18, .reg (vhi 18) u18', .reg (vlo 19) u19, .reg (vhi 19) u19',
        .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 false 0x20228#64 (w32s K))])
      (Atoms.interp [.pc r, .reg x0 hp, .reg x1 mp, .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10),
        .prop (regAny (vlo 0)), .prop (regAny (vhi 0)),
        .prop (regAny (vlo 1)), .prop (regAny (vhi 1)),
        .prop (regAny (vlo 2)), .prop (regAny (vhi 2)),
        .prop (regAny (vlo 3)), .prop (regAny (vhi 3)),
        .prop (regAny (vlo 4)), .prop (regAny (vhi 4)),
        .prop (regAny (vlo 5)), .prop (regAny (vhi 5)),
        .prop (regAny (vlo 6)), .prop (regAny (vhi 6)),
        .prop (regAny (vlo 7)), .prop (regAny (vhi 7)),
        .prop (regAny (vlo 16)), .prop (regAny (vhi 16)),
        .prop (regAny (vlo 17)), .prop (regAny (vhi 17)),
        .prop (regAny (vlo 18)), .prop (regAny (vhi 18)),
        .prop (regAny (vlo 19)), .prop (regAny (vhi 19)),
        .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 4 true hp (w32s (compress H M))), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 false 0x20228#64 (w32s K))]) := by
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ := eq_of_length_8 hH
  obtain ⟨m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15, rfl⟩ :=
    eq_of_length_16 hM
  -- The arrays, as 64-bit cells; the compression function, four rounds at a time.
  rw [compress_eq_steps h0 h1 h2 h3 h4 h5 h6 h7 _ rfl, cells_w32_packs true 4 hp _ rfl,
    cells_w32_packs true 4 hp _ rfl, cells_w32_packs wm 8 mp _ rfl,
    cells_w32_packs false 32 0x20228#64 K rfl]
  simp only [packs, rounds16At, Nat.reduceAdd]
  -- The first loop, and the window and the working variables it leaves.
  have hl := fun y5 y5' y6 y6' y7 y7' y19 y19' fn fz fc fv => loop_spec false 11 0 0#64
    [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15]
    ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ y5 y5' y6 y6' y7 y7' y19 y19' fn fz fc fv (by omega)
    rfl rfl
  simp only [Nat.reduceMul, Nat.reduceAdd] at hl
  have hSl := steps_length 12 0 [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13,
    m14, m15] ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ rfl
  generalize steps 0 12 [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15]
    ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ = S at hl hSl ⊢
  obtain ⟨W, v⟩ := S
  obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
    eq_of_length_16 hSl
  simp only [rowLo, rowHi, abcdLo, abcdHi, efghLo, efghHi, List.getD_cons_succ,
    List.getD_cons_zero, Nat.reduceMul, Nat.reduceAdd] at hl
  braid_unfold cells4 true hp _ _ _ _
  braid_unfold cells8x8 wm mp _ _ _ _ _ _ _ _
  -- The hash value and the block loaded, the count cleared, the working variables copied.
  iterate 8 braid_sym_step
  simp only [BitVec.or_self]
  braid_call hl _ _ _ _ _ _ _ _ _ _ _ _
  clear hl
  ni_name_flags
  -- The count cleared again, and the four turns of the second loop.
  braid_sym_step
  ni_tail false, 0, 0#64, v,
    [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]
  generalize rounds4At 48 0 _ v = v1
  ni_tail false, 1, 16#64, v1,
    [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]
  generalize rounds4At 52 4 _ v1 = v2
  ni_tail false, 2, 32#64, v2,
    [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]
  generalize rounds4At 56 8 _ v2 = v3
  ni_tail false, 3, 48#64, v3,
    [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]
  generalize rounds4At 60 12 _ v3 = R
  -- The sum with the hash value, the stores, and the return.
  iterate 2 braid_sym_step
  simp only [pack_add]
  braid_sym_run
  sha256_fold cells4 true hp (pack (R.a + h0) (R.b + h1)) (pack (R.c + h2) (R.d + h3))
    (pack (R.e + h4) (R.f + h5)) (pack (R.g + h6) (R.h + h7))
  sha256_fold cells8x8 wm mp (pack m0 m1) (pack m2 m3) (pack m4 m5) (pack m6 m7) (pack m8 m9)
    (pack m10 m11) (pack m12 m13) (pack m14 m15)
  ni_forget_vectors
  braid_forget 8
  braid_forget 9
  braid_forget 10
  braid_forget_flag 0
  braid_forget_flag 1
  braid_forget_flag 2
  braid_forget_flag 3
  braid_done

end Examples.Sha256Ni.Arm
