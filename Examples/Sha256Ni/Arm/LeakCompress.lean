/-
  Examples.Sha256Ni.Arm.LeakCompress

  What `sha256_compress_ni` reveals on AArch64 (`docs/Leakage.md`), as a traced triple: the
  addresses of its loads of the hash value, of the block and of the table of round
  constants, where the branches of its two loops go, the addresses of its stores of the hash
  value, and the return address. None of these depends on the hash value or on the block.

  The trace is not written before the proof: `compress_ni_run` is a trace together with the
  traced triple that leaves it, and the run finds the trace (`Braid.Logic.Traced`). It binds
  the two pointers and the return address before the pair, and the hash value, the block and
  what the registers hold inside it, so that the trace is a function of the three addresses
  alone is checked when the definition is. The loops are `loop_run` and `tail_run` of
  `Examples.Sha256Ni.Arm.LeakRound`, used as calls. The traced triple says nothing of what is
  computed, which is `sha256_compress_ni_spec`: the hash value is left with some contents.
  Its precondition is that of `sha256_compress_ni_spec`, so that a caller can join the two
  (`TripleT.of_spec`). The theorems about the machine alone are in
  `Examples.Sha256Ni.Arm.Leakage`.

  ## Main definitions

  * `compress_ni_run`: the function from its entry to its return, and its trace
  * `compressNiLeak`: what `sha256_compress_ni` reveals, the trace of `compress_ni_run`

  ## Main results

  * `compressNiLeak_eq`: the trace, written out with the traces of the two loops
  * `sha256_compress_ni_trace`: the code reveals `compressNiLeak`
-/

module

public import Examples.Sha256Ni.Arm.Compress
public import Examples.Sha256Ni.Arm.LeakRound

@[expose] public section

namespace Examples.Sha256Ni.Arm

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.Arm Lowering.Arm.Regs

/-- **`sha256_compress_ni`, and what it reveals**, from its entry to its return. The two
pointers `hp` and `mp` and the return address `r` are bound before the pair, and they are
all the trace may depend on: the hash value `H`, the block `M`, whether the block is
read-only, and what `x8`, `x9`, `x10`, the vector registers and the flags hold are bound
inside it. The hash value is left with some contents, which `sha256_compress_ni_spec`
gives. -/
def compress_ni_run (hp mp r : Word) : { ls : Trace // ∀ (H M : List W32) (wm : Bool)
    (t8 t9 t10
      u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u16 u16' u17 u17' u18 u18' u19 u19'
      : Word)
    (fn fz fc fv : Bool) (t : Trace), H.length = 8 → M.length = 16 →
    TripleT sha256_compress_ni.program
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
        .prop (cellsAt 4 false 0x20228#64 (w32s K))]) t
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
        .prop (cellsAny 8 true hp 4), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 false 0x20228#64 (w32s K))])
      (t ++ ls) } := by
  braid_traced
  intro H M wm t8 t9 t10
    u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u16 u16' u17 u17' u18 u18' u19 u19'
    fn fz fc fv t hH hM
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ := eq_of_length_8 hH
  obtain ⟨m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15, rfl⟩ :=
    eq_of_length_16 hM
  -- The arrays, as 64-bit cells.
  rw [cells_w32_packs true 4 hp _ rfl, cells_w32_packs wm 8 mp _ rfl,
    cells_w32_packs false 32 0x20228#64 K rfl]
  simp only [packs]
  braid_unfold cells4 true hp _ _ _ _
  braid_unfold cells8x8 wm mp _ _ _ _ _ _ _ _
  -- The hash value and the block loaded, the count cleared, the working variables copied.
  iterate 8 braid_sym_step
  ni_valT 9, BitVec.ofNat 64 (16 * 0), rfl
  -- The first loop.
  braid_call (loop_run 11 0).2 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by omega)
  ni_name_work
  ni_name_flags
  -- The count cleared again, and the second loop.
  braid_sym_step
  ni_valT 9, BitVec.ofNat 64 (16 * 0), rfl
  braid_call (tail_run 3 0).2 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by omega)
  ni_name_work
  braid_name_reg 10
  ni_name_flags
  -- The sum with the hash value, the stores, and the return.
  braid_sym_run
  braid_fold cells4 true hp _ _ _ _
  braid_fold cells8x8 wm mp _ _ _ _ _ _ _ _
  apply TripleT.forget_cells (k := 8) (p := hp) 4
  case hupd => braid_upd
  case hn => rfl
  ni_forget_work
  braid_forget (vlo 0)
  braid_forget (vhi 0)
  braid_forget (vlo 1)
  braid_forget (vhi 1)
  braid_forget 8
  braid_forget 9
  braid_forget 10
  braid_forget_flag 0
  braid_forget_flag 1
  braid_forget_flag 2
  braid_forget_flag 3
  braid_done

/-- **What `sha256_compress_ni` reveals**, from its two arguments and the return address:
the trace that `compress_ni_run` finds. It is the loads of the hash value from `hp` and of
the block from `mp`, eight bytes at a time; the loads of the table of round constants and
the branches of the two loops; the stores of the hash value to `hp`; and the return. -/
def compressNiLeak (hp mp r : Word) : Trace := (compress_ni_run hp mp r).1

/-- **The trace of `sha256_compress_ni`, written out**, with the traces of the two loops,
which `loopLeak_zero`, `loopLeak_succ`, `tailLeak_zero` and `tailLeak_succ` give a turn at a
time: four loads of the hash value and eight of the block, twelve turns of the first loop
and four of the second, four stores of the hash value, and the return. -/
theorem compressNiLeak_eq (hp mp r : Word) : compressNiLeak hp mp r =
    [.read hp 8, .read (hp + 8#64) 8, .read (hp + 16#64) 8, .read (hp + 24#64) 8,
      .read mp 8, .read (mp + 8#64) 8, .read (mp + 16#64) 8, .read (mp + 24#64) 8,
      .read (mp + 32#64) 8, .read (mp + 40#64) 8, .read (mp + 48#64) 8,
      .read (mp + 56#64) 8] ++ loopLeak 11 0 ++ tailLeak 3 0 ++
    [.write hp 8, .write (hp + 8#64) 8, .write (hp + 16#64) 8, .write (hp + 24#64) 8,
      .jump r] := rfl

/-- **What `sha256_compress_ni` reveals.** From the precondition of
`sha256_compress_ni_spec`, the code runs to its return and reveals `compressNiLeak` of the
two pointers and the return address: the hash value `H` and the block `M` are not in the
trace. The postcondition keeps where the hash value is and forgets what is in it. -/
theorem sha256_compress_ni_trace (hp mp r : Word) (H M : List W32) (wm : Bool)
    (t8 t9 t10
      u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u16 u16' u17 u17' u18 u18' u19 u19'
      : Word)
    (fn fz fc fv : Bool) (hH : H.length = 8) (hM : M.length = 16) (t : Trace) :
    TripleT sha256_compress_ni.program
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
        .prop (cellsAt 4 false 0x20228#64 (w32s K))]) t
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
        .prop (cellsAny 8 true hp 4), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 false 0x20228#64 (w32s K))])
      (t ++ compressNiLeak hp mp r) :=
  (compress_ni_run hp mp r).2 H M wm t8 t9 t10
    u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u16 u16' u17 u17' u18 u18' u19 u19'
    fn fz fc fv t hH hM

end Examples.Sha256Ni.Arm
