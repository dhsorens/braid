/-
  Examples.ChaCha20Vec.Arm.Block

  `chacha20_block_vec` of `chacha20_vec.c` on AArch64: the ChaCha20 block function, from
  sixteen 32-bit words in memory to sixteen 32-bit words in memory, on four rows of four
  lanes in vector registers.

  The code loads the four rows, two 64-bit words each, runs the loop of ten double rounds
  on the registers, and then, a row at a time, adds the row of the input and stores the sum.
  It has no frame. The first row of the input stays in `v0` through the loop; the other
  three are loaded again for the sum, each after the row before it has been stored. The loop
  is `rounds_spec`, proved by induction in `Examples.ChaCha20Vec.Arm.Round`, and is used
  here as a call. The state in memory is sixteen 32-bit cells in the specification and eight
  64-bit cells to the code, which are the same (`ChaCha20Vec.cells_packs`).

  Since a row of the input is loaded again after the rows before it have been stored, the
  output may not overlap the input in part. It may be the input: then each row is loaded
  before it is stored to, which is the second specification.

  ## Main results

  * `chacha20_block_vec_spec`: the specification, against `ChaCha20.block`, for an output
    apart from the input
  * `chacha20_block_vec_inplace_spec`: the same, for an output that is the input
-/

module

public import Examples.ChaCha20Vec.Arm.Round

public section

namespace Examples.ChaCha20Vec.Arm

open Braid Examples Examples.ChaCha20 Lowering.Arm Lowering.Arm.Regs

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

/-- **`chacha20_block_vec`** writes the ChaCha20 block function of the sixteen 32-bit words
its second argument points to over the sixteen its first argument points to, which are
apart from them. It uses no stack. It leaves the input, `x0`, `x1` and the link register as
they were, and `w8`, the vector registers `v0` to `v6` and the flags with some values. -/
theorem chacha20_block_vec_spec (out inp r : Word) (s : List W32) (os : List Word)
    (t8 u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' : Word) (fn fz fc fv : Bool)
    (hs : s.length = 16) (hos : os.length = 16) :
    Triple chacha20_block_vec.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) ::
        [.pc 0x10000#64, .reg x0 out, .reg x1 inp, .reg x8 t8,
        .reg (vlo 0) u0, .reg (vhi 0) u0', .reg (vlo 1) u1, .reg (vhi 1) u1',
        .reg (vlo 2) u2, .reg (vhi 2) u2', .reg (vlo 3) u3, .reg (vhi 3) u3',
        .reg (vlo 4) u4, .reg (vhi 4) u4', .reg (vlo 5) u5, .reg (vhi 5) u5',
        .reg (vlo 6) u6, .reg (vhi 6) u6', .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]))
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out ((block s).map (·.zeroExtend 64))) ::
        [.pc r, .reg x0 out, .reg x1 inp, .prop (regAny x8),
        .prop (regAny (vlo 0)), .prop (regAny (vhi 0)), .prop (regAny (vlo 1)),
        .prop (regAny (vhi 1)), .prop (regAny (vlo 2)), .prop (regAny (vhi 2)),
        .prop (regAny (vlo 3)), .prop (regAny (vhi 3)), .prop (regAny (vlo 4)),
        .prop (regAny (vhi 4)), .prop (regAny (vlo 5)), .prop (regAny (vhi 5)),
        .prop (regAny (vlo 6)), .prop (regAny (vhi 6)), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)])) := by
  -- The arrays, as eight 64-bit cells each: the two words of each row.
  rw [cells_packs 8 inp s hs, packs16 s hs, cells_packs_truncate 8 out os hos,
    packs16 (os.map _) (by rw [List.length_map, hos]),
    cells_packs 8 out (block s) (length_block s hs), packs16 (block s) (length_block s hs)]
  generalize os.map _ = os'
  -- The sums of the postcondition, as the code computes them.
  rw [rowLo_block s 0, rowHi_block s 0, rowLo_block_comm s 1, rowHi_block_comm s 1,
    rowLo_block_comm s 2, rowHi_block_comm s 2, rowLo_block_comm s 3, rowHi_block_comm s 3]
  braid_unfold cells8 inp _ _ _ _ _ _ _ _
  braid_unfold cells8 out _ _ _ _ _ _ _ _
  -- The loads of the four rows, the count of rounds, and the copy of the first row.
  iterate 4 braid_sym_step
  simp only [BitVec.or_self]
  -- The ten double rounds.
  have h := rounds_spec 9 s 10#32 u5 u5' u6 u6' fn fz fc fv hs rfl (by decide)
  simp only [Nat.reduceAdd] at h
  braid_call h
  clear h
  -- The sums with the input, the stores, and the return.
  braid_sym_run
  braid_fold cells8 inp _ _ _ _ _ _ _ _
  braid_fold cells8 out _ _ _ _ _ _ _ _
  braid_forget 8
  braid_forget (vlo 0)
  braid_forget (vhi 0)
  braid_forget (vlo 1)
  braid_forget (vhi 1)
  braid_forget (vlo 2)
  braid_forget (vhi 2)
  braid_forget (vlo 3)
  braid_forget (vhi 3)
  braid_forget (vlo 4)
  braid_forget (vhi 4)
  braid_done

/-- **`chacha20_block_vec`, in place.** When both arguments point to the same sixteen 32-bit
words, the code writes their ChaCha20 block function over them: each row is loaded for the
sum before it is stored to. -/
theorem chacha20_block_vec_inplace_spec (p r : Word) (s : List W32)
    (t8 u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' : Word) (fn fz fc fv : Bool)
    (hs : s.length = 16) :
    Triple chacha20_block_vec.program
      (Atoms.interp (.prop (cellsAt 4 true p (s.map (·.zeroExtend 64))) ::
        [.pc 0x10000#64, .reg x0 p, .reg x1 p, .reg x8 t8,
        .reg (vlo 0) u0, .reg (vhi 0) u0', .reg (vlo 1) u1, .reg (vhi 1) u1',
        .reg (vlo 2) u2, .reg (vhi 2) u2', .reg (vlo 3) u3, .reg (vhi 3) u3',
        .reg (vlo 4) u4, .reg (vhi 4) u4', .reg (vlo 5) u5, .reg (vhi 5) u5',
        .reg (vlo 6) u6, .reg (vhi 6) u6', .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]))
      (Atoms.interp (.prop (cellsAt 4 true p ((block s).map (·.zeroExtend 64))) ::
        [.pc r, .reg x0 p, .reg x1 p, .prop (regAny x8),
        .prop (regAny (vlo 0)), .prop (regAny (vhi 0)), .prop (regAny (vlo 1)),
        .prop (regAny (vhi 1)), .prop (regAny (vlo 2)), .prop (regAny (vhi 2)),
        .prop (regAny (vlo 3)), .prop (regAny (vhi 3)), .prop (regAny (vlo 4)),
        .prop (regAny (vhi 4)), .prop (regAny (vlo 5)), .prop (regAny (vhi 5)),
        .prop (regAny (vlo 6)), .prop (regAny (vhi 6)), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)])) := by
  rw [cells_packs 8 p s hs, packs16 s hs, cells_packs 8 p (block s) (length_block s hs),
    packs16 (block s) (length_block s hs)]
  rw [rowLo_block s 0, rowHi_block s 0, rowLo_block_comm s 1, rowHi_block_comm s 1,
    rowLo_block_comm s 2, rowHi_block_comm s 2, rowLo_block_comm s 3, rowHi_block_comm s 3]
  braid_unfold cells8 p _ _ _ _ _ _ _ _
  iterate 4 braid_sym_step
  simp only [BitVec.or_self]
  have h := rounds_spec 9 s 10#32 u5 u5' u6 u6' fn fz fc fv hs rfl (by decide)
  simp only [Nat.reduceAdd] at h
  braid_call h
  clear h
  braid_sym_run
  braid_fold cells8 p _ _ _ _ _ _ _ _
  braid_forget 8
  braid_forget (vlo 0)
  braid_forget (vhi 0)
  braid_forget (vlo 1)
  braid_forget (vhi 1)
  braid_forget (vlo 2)
  braid_forget (vhi 2)
  braid_forget (vlo 3)
  braid_forget (vhi 3)
  braid_forget (vlo 4)
  braid_forget (vhi 4)
  braid_done

end Examples.ChaCha20Vec.Arm
