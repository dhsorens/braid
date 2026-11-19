/-
  Examples.Sha256Main.RiscV.Program

  The whole program on RISC-V, and its link to the proofs about `sha256.c`. The binary of the
  whole program holds the compression function at the addresses it has in the binary of
  `sha256.c` alone (`Examples/build.sh`), so its blocks are the blocks those proofs are about,
  and what they prove holds of the whole program as it stands: the specification and the
  leakage of `sha256_compress`, joined into one traced triple for a call from `main`.

  ## Main definitions

  * `program`: the lowered code of the whole binary

  ## Main results

  * `program_of_compress`: the code of `sha256_compress` is part of the program
  * `compress_call`: a call of `sha256_compress`: what it computes and what it reveals
-/

module

public import Examples.Sha256Main.RiscV.Image
public import Examples.Sha256Main.Shared
public import Examples.Sha256.RiscV.Compress
public import Examples.Sha256.RiscV.LeakCompress

@[expose] public section

namespace Examples.Sha256Main.RiscV

open Braid Examples Examples.Sha256 Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- The lowered code of the whole binary. -/
def program : Program := Program.ofList sha256_main_blocks

/-- The compression function of this binary is that of the binary of `sha256.c`, block for
block. -/
theorem compress_blocks : sha256_compress.blocks = Sha256.RiscV.sha256_compress.blocks := rfl

/-- The code of `sha256_compress` is part of the program. -/
theorem program_of_compress (a : Word) (b : Block)
    (h : Sha256.RiscV.sha256_compress.program a = some b) : program a = some b := by
  refine Program.ofList_mono (fun p hp => ?_) (by decide +kernel) a b h
  rw [sha256_main_blocks, compress_blocks]
  exact List.mem_append_left _ (List.mem_append_left _ hp)

/-- **A call of `sha256_compress`.** The specification of `sha256_compress` and what it
reveals, both proved about the binary of `sha256.c`, as one traced triple about the whole
program, for a call that returns to an address `r` outside the function. -/
theorem compress_call (hp mp s r v8 v9 v18 : Word) (H M : List W32) (wm wk : Bool)
    (fvs fws sv : List Word) (x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 : Word)
    (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 8) (hfw : fws.length = 64)
    (hsv : sv.length = 3) (hhp : hp &&& 3#64 = 0#64) (hmp : mp &&& 3#64 = 0#64)
    (hs : s &&& 7#64 = 0#64)
    (hr : Sha256.RiscV.sha256_compress.program (r &&& ~~~1#64) = none) (t : Trace) :
    TripleT program
      (Atoms.interp [.pc 0x10160#64, .reg a0 hp, .reg a1 mp, .reg a2 x12, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .reg t3 x28, .reg t4 x29, .reg t5 x30, .reg t6 x31, .reg s0 v8,
        .reg s1 v9, .reg s2 v18, .reg sp s, .reg ra r,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x10368#64 (w32s K)),
        .prop (cellsAt 4 true (s - 312#64) fvs), .prop (cellsAt 4 true (s - 280#64) fws),
        .prop (cellsAt 8 true (s - 24#64) sv)]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (hp + 32#64), .prop (regAny a1),
        .prop (regAny a2), .prop (regAny a3), .prop (regAny a4), .prop (regAny a5),
        .prop (regAny a6), .prop (regAny a7), .prop (regAny t0), .prop (regAny t1),
        .prop (regAny t2), .prop (regAny t3), .prop (regAny t4), .prop (regAny t5),
        .prop (regAny t6), .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg sp s, .reg ra r,
        .prop (cellsAt 4 true hp (w32s (compress H M))), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x10368#64 (w32s K)),
        .prop (cellsAt 4 true (s - 312#64)
          (w32s (rounds (schedule M) (Vars.ofList H) 64).toList)),
        .prop (cellsAt 4 true (s - 280#64) (w32s (schedule M))),
        .prop (cellsAt 8 true (s - 24#64) [v18, v9, v8])])
      (t ++ Sha256.RiscV.compressLeak hp mp s r) :=
  (TripleT.of_spec hr (by braid_at) (by braid_at)
    (Sha256.RiscV.sha256_compress_spec hp mp s r v8 v9 v18 H M wm wk fvs fws sv
      x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 hH hM hfv hfw hsv hhp hmp hs)
    (Sha256.RiscV.sha256_compress_trace hp mp s r v8 v9 v18 H M wm wk fvs fws sv
      x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 hH hM hfv hfw hsv hhp hmp hs t)).mono
    program_of_compress

end Examples.Sha256Main.RiscV
