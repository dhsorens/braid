/-
  Examples.ChaCha20Vec.X86.Block

  `chacha20_block_vec` of `chacha20_vec.x86.S` on x86-64: the ChaCha20 block function, from
  sixteen 32-bit words in memory to sixteen 32-bit words in memory, on four rows of four
  lanes in the vector registers `xmm0` to `xmm3`.

  The code loads the four rows, two 64-bit words each, sets the count of rounds, runs the
  loop of ten double rounds on the registers, adds the four rows of the input, from memory,
  to the rows, stores the four sums, and returns through the address on the stack. It has no
  frame. The loop is `rounds_spec`, proved by induction in `Examples.ChaCha20Vec.X86.Round`,
  and is used here as a call. The state in memory is sixteen 32-bit cells in the
  specification and eight 64-bit cells to the code, which are the same
  (`ChaCha20Vec.cells_packs`).

  Every load of the input comes before the first store to the output, so the output may be
  the input: that is the second specification.

  A vector register of the model is eight 64-bit words, of which a row is the first two.
  The loads, in their EVEX form, write zero to the other six words of `zmm0` to `zmm3`, and
  no later instruction writes anything else there, so the specifications say that those
  words are zero at the return, whatever they were.

  ## Main results

  * `chacha20_block_vec_spec`: the specification, against `ChaCha20.block`, for an output
    apart from the input
  * `chacha20_block_vec_inplace_spec`: the same, for an output that is the input
-/

module

public import Examples.ChaCha20Vec.X86.Round

public section

namespace Examples.ChaCha20Vec.X86

open Braid Examples Examples.ChaCha20 Lowering.X86 Lowering.X86.Regs

/-! ## The rows in memory -/

/-- Eight 64-bit cells, as memory atoms. -/
theorem cells8 (p w0 w1 w2 w3 w4 w5 w6 w7 : Word) :
    (Atom.prop (cellsAt 8 true p [w0, w1, w2, w3, w4, w5, w6, w7])).interp =
      Atoms.interp [.mem p 8 w0 true, .mem (p + 8#64) 8 w1 true, .mem (p + 16#64) 8 w2 true,
        .mem (p + 24#64) 8 w3 true, .mem (p + 32#64) 8 w4 true, .mem (p + 40#64) 8 w5 true,
        .mem (p + 48#64) 8 w6 true, .mem (p + 56#64) 8 w7 true] := by
  simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil, cellsAt, BitVec.add_assoc,
    BitVec.reduceAdd]

/-! ## The code -/

/-- Forget what the rows hold: the first two words of `zmm0` to `zmm3`. -/
macro "x86_forget_rows" : tactic =>
  `(tactic| (braid_forget (zmm 0 0); braid_forget (zmm 0 1); braid_forget (zmm 1 0)
             braid_forget (zmm 1 1); braid_forget (zmm 2 0); braid_forget (zmm 2 1)
             braid_forget (zmm 3 0); braid_forget (zmm 3 1)))

/-- **`chacha20_block_vec`** writes the ChaCha20 block function of the sixteen 32-bit words
`rsi` points to over the sixteen `rdi` points to, which are apart from them, and returns
through the address `r` in the eight bytes at the stack pointer, which it leaves past them.
It uses no other stack. It leaves the input, `rdi` and `rsi` as they were; `eax` and the
rows, which are the first two words of each of `zmm0` to `zmm3`, with some values; the other
six words of each of `zmm0` to `zmm3` zero; and the status flags but the carry flag, which
it does not write, with some values. -/
theorem chacha20_block_vec_spec (out inp r sp : Word) (s : List W32) (os : List Word)
    (t0 : Word)
    (v00 v01 v02 v03 v04 v05 v06 v07 v10 v11 v12 v13 v14 v15 v16 v17 : Word)
    (v20 v21 v22 v23 v24 v25 v26 v27 v30 v31 v32 v33 v34 v35 v36 v37 : Word)
    (fp fa fz fs fo : Bool) (hs : s.length = 16) (hos : os.length = 16) :
    Triple chacha20_block_vec.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) ::
        [.mem sp 8 r true, .pc 0x401000#64, .reg rdi out, .reg rsi inp, .reg rsp sp,
        .reg rax t0,
        .reg (zmm 0 0) v00, .reg (zmm 0 1) v01, .reg (zmm 0 2) v02, .reg (zmm 0 3) v03,
        .reg (zmm 0 4) v04, .reg (zmm 0 5) v05, .reg (zmm 0 6) v06, .reg (zmm 0 7) v07,
        .reg (zmm 1 0) v10, .reg (zmm 1 1) v11, .reg (zmm 1 2) v12, .reg (zmm 1 3) v13,
        .reg (zmm 1 4) v14, .reg (zmm 1 5) v15, .reg (zmm 1 6) v16, .reg (zmm 1 7) v17,
        .reg (zmm 2 0) v20, .reg (zmm 2 1) v21, .reg (zmm 2 2) v22, .reg (zmm 2 3) v23,
        .reg (zmm 2 4) v24, .reg (zmm 2 5) v25, .reg (zmm 2 6) v26, .reg (zmm 2 7) v27,
        .reg (zmm 3 0) v30, .reg (zmm 3 1) v31, .reg (zmm 3 2) v32, .reg (zmm 3 3) v33,
        .reg (zmm 3 4) v34, .reg (zmm 3 5) v35, .reg (zmm 3 6) v36, .reg (zmm 3 7) v37,
        .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz, .flag Flags.sf fs,
        .flag Flags.of fo]))
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out ((block s).map (·.zeroExtend 64))) ::
        [.mem sp 8 r true, .pc r, .reg rdi out, .reg rsi inp, .reg rsp (sp + 8#64),
        .prop (regAny rax),
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .prop (regAny (zmm 1 0)), .prop (regAny (zmm 1 1)),
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .prop (regAny (zmm 3 0)), .prop (regAny (zmm 3 1)),
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .prop (flagAny Flags.pf), .prop (flagAny Flags.af), .prop (flagAny Flags.zf),
        .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])) := by
  -- The arrays, as eight 64-bit cells each: the two words of each row.
  rw [cells_packs 8 inp s hs, packs16 s hs, cells_packs_truncate 8 out os hos,
    packs16 (os.map _) (by rw [List.length_map, hos]),
    cells_packs 8 out (block s) (length_block s hs), packs16 (block s) (length_block s hs)]
  generalize os.map _ = os'
  -- The sums of the postcondition, as the code computes them.
  rw [rowLo_block s 0, rowHi_block s 0, rowLo_block s 1, rowHi_block s 1, rowLo_block s 2,
    rowHi_block s 2, rowLo_block s 3, rowHi_block s 3]
  braid_unfold cells8 inp _ _ _ _ _ _ _ _
  braid_unfold cells8 out _ _ _ _ _ _ _ _
  -- The loads of the four rows and the count of rounds.
  iterate 5 braid_sym_step
  -- The ten double rounds.
  have h := rounds_spec 9 s 10#32 fp fa fz fs fo hs rfl (by decide)
  simp only [Nat.reduceAdd] at h
  braid_call h
  clear h
  -- The sums with the input, the stores, and the return.
  braid_sym_run
  braid_fold cells8 inp _ _ _ _ _ _ _ _
  braid_fold cells8 out _ _ _ _ _ _ _ _
  braid_forget 0
  x86_forget_rows
  braid_done_perm 45

/-- **`chacha20_block_vec`, in place.** When `rdi` and `rsi` point to the same sixteen
32-bit words, the code writes their ChaCha20 block function over them: every row is loaded
for the sum before any is stored to. -/
theorem chacha20_block_vec_inplace_spec (p r sp : Word) (s : List W32) (t0 : Word)
    (v00 v01 v02 v03 v04 v05 v06 v07 v10 v11 v12 v13 v14 v15 v16 v17 : Word)
    (v20 v21 v22 v23 v24 v25 v26 v27 v30 v31 v32 v33 v34 v35 v36 v37 : Word)
    (fp fa fz fs fo : Bool) (hs : s.length = 16) :
    Triple chacha20_block_vec.program
      (Atoms.interp (.prop (cellsAt 4 true p (s.map (·.zeroExtend 64))) ::
        [.mem sp 8 r true, .pc 0x401000#64, .reg rdi p, .reg rsi p, .reg rsp sp,
        .reg rax t0,
        .reg (zmm 0 0) v00, .reg (zmm 0 1) v01, .reg (zmm 0 2) v02, .reg (zmm 0 3) v03,
        .reg (zmm 0 4) v04, .reg (zmm 0 5) v05, .reg (zmm 0 6) v06, .reg (zmm 0 7) v07,
        .reg (zmm 1 0) v10, .reg (zmm 1 1) v11, .reg (zmm 1 2) v12, .reg (zmm 1 3) v13,
        .reg (zmm 1 4) v14, .reg (zmm 1 5) v15, .reg (zmm 1 6) v16, .reg (zmm 1 7) v17,
        .reg (zmm 2 0) v20, .reg (zmm 2 1) v21, .reg (zmm 2 2) v22, .reg (zmm 2 3) v23,
        .reg (zmm 2 4) v24, .reg (zmm 2 5) v25, .reg (zmm 2 6) v26, .reg (zmm 2 7) v27,
        .reg (zmm 3 0) v30, .reg (zmm 3 1) v31, .reg (zmm 3 2) v32, .reg (zmm 3 3) v33,
        .reg (zmm 3 4) v34, .reg (zmm 3 5) v35, .reg (zmm 3 6) v36, .reg (zmm 3 7) v37,
        .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz, .flag Flags.sf fs,
        .flag Flags.of fo]))
      (Atoms.interp (.prop (cellsAt 4 true p ((block s).map (·.zeroExtend 64))) ::
        [.mem sp 8 r true, .pc r, .reg rdi p, .reg rsi p, .reg rsp (sp + 8#64),
        .prop (regAny rax),
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .prop (regAny (zmm 1 0)), .prop (regAny (zmm 1 1)),
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .prop (regAny (zmm 3 0)), .prop (regAny (zmm 3 1)),
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .prop (flagAny Flags.pf), .prop (flagAny Flags.af), .prop (flagAny Flags.zf),
        .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])) := by
  rw [cells_packs 8 p s hs, packs16 s hs, cells_packs 8 p (block s) (length_block s hs),
    packs16 (block s) (length_block s hs)]
  rw [rowLo_block s 0, rowHi_block s 0, rowLo_block s 1, rowHi_block s 1, rowLo_block s 2,
    rowHi_block s 2, rowLo_block s 3, rowHi_block s 3]
  braid_unfold cells8 p _ _ _ _ _ _ _ _
  iterate 5 braid_sym_step
  have h := rounds_spec 9 s 10#32 fp fa fz fs fo hs rfl (by decide)
  simp only [Nat.reduceAdd] at h
  braid_call h
  clear h
  braid_sym_run
  braid_fold cells8 p _ _ _ _ _ _ _ _
  braid_forget 0
  x86_forget_rows
  braid_done_perm 44

end Examples.ChaCha20Vec.X86
