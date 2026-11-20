/-
  Examples.Sha256MainNi.Arm.Program

  The whole program on AArch64 with the compression function of `sha256_ni.c`, and its links
  to two sets of proofs made apart from it. The binary holds `sha256_compress_ni` at the
  addresses it has in the binary of `sha256_ni.c` alone (`Examples/build.sh`), so its blocks
  are the blocks those proofs are about, and what they prove holds of the whole program as
  it stands: the specification and the leakage of `sha256_compress_ni`, joined into one
  traced triple for a call from `main`. Its `_start` and its `main` are, block for block,
  those of the program with the scalar compression function (`Examples.Sha256Main.Arm.Own`),
  so what is proved of `ownProgram` there holds of this program too.

  ## Main definitions

  * `program`: the lowered code of the whole binary (its own code, `_start` and `main`, is
    `ownProgram` of `Examples.Sha256Main.Arm.Own`)

  ## Main results

  * `blocks_nodup`: no two blocks of the program are at one address
  * `start_blocks`, `main_blocks`: `_start` and `main` are those of the scalar program
  * `own_le`: the own code of the scalar program, `_start` and `main`, is part of the program
  * `program_of_compress`: the code of `sha256_compress_ni` is part of the program
  * `compress_call`: a call of `sha256_compress_ni`: what it computes and what it reveals
-/

module

public import Examples.Sha256MainNi.Arm.Image
public import Examples.Sha256Main.Arm.Own
public import Examples.Sha256Main.Shared
public import Examples.Sha256Ni.Arm.Compress
public import Examples.Sha256Ni.Arm.LeakCompress

@[expose] public section

namespace Examples.Sha256MainNi.Arm

open Braid Examples Examples.Sha256 Lowering.Arm Lowering.Arm.Regs
open Examples.Sha256Main.Arm (ownProgram)

/-- The lowered code of the whole binary. -/
def program : Program := Program.ofList sha256_main_ni_blocks

/-- No two blocks of the program are at one address. -/
theorem blocks_nodup : (sha256_main_ni_blocks.map (·.1)).Nodup := by decide +kernel

/-- `_start` of this binary is that of the scalar program, block for block. -/
theorem start_blocks : _start.blocks = Sha256Main.Arm._start.blocks := rfl

/-- `main` of this binary is that of the scalar program, block for block. -/
theorem main_blocks : main.blocks = Sha256Main.Arm.main.blocks := rfl

/-- The program's own code, which is that of the scalar program, is part of the program:
what is proved of `ownProgram` holds of the program (`TripleT.mono`). -/
theorem own_le (a : Word) (b : Block) (h : ownProgram a = some b) : program a = some b := by
  refine Program.ofList_mono (fun p hp => ?_) blocks_nodup a b h
  rw [sha256_main_ni_blocks, List.append_assoc, start_blocks, main_blocks]
  exact List.mem_append_right _ hp

/-- The compression function of this binary is that of the binary of `sha256_ni.c`, block
for block. -/
theorem compress_blocks :
    sha256_compress_ni.blocks = Sha256Ni.Arm.sha256_compress_ni.blocks := rfl

/-- The code of `sha256_compress_ni` is part of the program. -/
theorem program_of_compress (a : Word) (b : Block)
    (h : Sha256Ni.Arm.sha256_compress_ni.program a = some b) : program a = some b := by
  refine Program.ofList_mono (fun p hp => ?_) blocks_nodup a b h
  rw [sha256_main_ni_blocks, compress_blocks]
  exact List.mem_append_left _ (List.mem_append_left _ hp)

/-- **A call of `sha256_compress_ni`.** The specification of `sha256_compress_ni` and what
it reveals, both proved about the binary of `sha256_ni.c`, as one traced triple about the
whole program, for a call that returns to an address `r` outside the function. The function
has no frame: nothing is asked of the stack. -/
theorem compress_call (hp mp r : Word) (H M : List W32) (wm : Bool)
    (t8 t9 t10
      u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u16 u16' u17 u17' u18 u18' u19 u19'
      : Word)
    (fn fz fc fv : Bool) (hH : H.length = 8) (hM : M.length = 16)
    (hr : Sha256Ni.Arm.sha256_compress_ni.program r = none) (t : Trace) :
    TripleT program
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
        .prop (cellsAt 4 true hp (w32s (compress H M))), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 false 0x20228#64 (w32s K))])
      (t ++ Sha256Ni.Arm.compressNiLeak hp mp r) :=
  (TripleT.of_spec hr (by braid_at) (by braid_at)
    (Sha256Ni.Arm.sha256_compress_ni_spec hp mp r H M wm t8 t9 t10
      u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u16 u16' u17 u17' u18 u18' u19
      u19' fn fz fc fv hH hM)
    (Sha256Ni.Arm.sha256_compress_ni_trace hp mp r H M wm t8 t9 t10
      u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u16 u16' u17 u17' u18 u18' u19
      u19' fn fz fc fv hH hM t)).mono
    program_of_compress

end Examples.Sha256MainNi.Arm
