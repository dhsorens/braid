/-
  Examples.Sha256Main.Arm.Program

  The whole program on AArch64, and its link to the proofs about `sha256.c`. The binary of
  the whole program holds the compression function at the addresses it has in the binary of
  `sha256.c` alone (`Examples/build.sh`), so its blocks are the blocks those proofs are about,
  and what they prove holds of the whole program as it stands: the specification and the
  leakage of `sha256_compress`, joined into one traced triple for a call from `main`.

  ## Main definitions

  * `program`: the lowered code of the whole binary (its own code, `_start` and `main`, is
    `ownProgram` of `Examples.Sha256Main.Arm.Own`)

  ## Main results

  * `blocks_nodup`: no two blocks of the program are at one address
  * `own_le`: the program's own code, `_start` and `main`, is part of the program
  * `program_of_compress`: the code of `sha256_compress` is part of the program
  * `compress_call`: a call of `sha256_compress`: what it computes and what it reveals
-/

module

public import Examples.Sha256Main.Arm.Own
public import Examples.Sha256Main.Shared
public import Examples.Sha256.Arm.Compress
public import Examples.Sha256.Arm.LeakCompress

@[expose] public section

namespace Examples.Sha256Main.Arm

open Braid Examples Examples.Sha256 Lowering.Arm Lowering.Arm.Regs

/-- The lowered code of the whole binary. -/
def program : Program := Program.ofList sha256_main_blocks

/-- No two blocks of the program are at one address. -/
theorem blocks_nodup : (sha256_main_blocks.map (·.1)).Nodup := by decide +kernel

/-- The program's own code is part of the program: what is proved of `ownProgram` holds of
the program (`TripleT.mono`). -/
theorem own_le (a : Word) (b : Block) (h : ownProgram a = some b) : program a = some b := by
  refine Program.ofList_mono (fun p hp => ?_) blocks_nodup a b h
  rw [sha256_main_blocks, List.append_assoc]
  exact List.mem_append_right _ hp

/-- The compression function of this binary is that of the binary of `sha256.c`, block for
block. -/
theorem compress_blocks : sha256_compress.blocks = Sha256.Arm.sha256_compress.blocks := rfl

/-- The code of `sha256_compress` is part of the program. -/
theorem program_of_compress (a : Word) (b : Block)
    (h : Sha256.Arm.sha256_compress.program a = some b) : program a = some b := by
  refine Program.ofList_mono (fun p hp => ?_) blocks_nodup a b h
  rw [sha256_main_blocks, compress_blocks]
  exact List.mem_append_left _ (List.mem_append_left _ hp)

/-- **A call of `sha256_compress`.** The specification of `sha256_compress` and what it
reveals, both proved about the binary of `sha256.c`, as one traced triple about the whole
program, for a call that returns to an address `r` outside the function. -/
theorem compress_call (hp mp s r fp sv : Word) (H M : List W32) (wm : Bool)
    (fvs fws : List Word) (t2 t3 t4 t5 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 : Word)
    (fn fz fc fv : Bool) (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 8)
    (hfw : fws.length = 64) (hs : s &&& 15#64 = 0#64)
    (hr : Sha256.Arm.sha256_compress.program r = none) (t : Trace) :
    TripleT program
      (Atoms.interp [.pc 0x100bc#64, .reg x0 hp, .reg x1 mp, .reg x2 t2, .reg x3 t3,
        .reg x4 t4, .reg x5 t5, .reg x8 t8, .reg x9 t9, .reg x10 t10, .reg x11 t11,
        .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15, .reg x16 t16, .reg x17 t17,
        .reg x18 t18, .reg x29 fp, .reg lr r, .reg sp s,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 false 0x20228#64 (w32s K)),
        .prop (cellsAt 4 true (s - 0x130#64) fvs), .prop (cellsAt 4 true (s - 0x110#64) fws),
        .prop (cellsAt 8 true (s - 0x10#64) [sv])]) t
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
        .prop (cellsAt 8 true (s - 0x10#64) [fp])])
      (t ++ Sha256.Arm.compressLeak hp mp s r) :=
  (TripleT.of_spec hr (by braid_at) (by braid_at)
    (Sha256.Arm.sha256_compress_spec hp mp s r fp sv H M wm fvs fws t2 t3 t4 t5 t8 t9 t10 t11
      t12 t13 t14 t15 t16 t17 t18 fn fz fc fv hH hM hfv hfw hs)
    (Sha256.Arm.sha256_compress_trace hp mp s r fp sv H M wm fvs fws t2 t3 t4 t5 t8 t9 t10 t11
      t12 t13 t14 t15 t16 t17 t18 fn fz fc fv hH hM hfv hfw hs t)).mono
    program_of_compress

end Examples.Sha256Main.Arm
