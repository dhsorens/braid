/-
  Examples.Sha256Main.X86.Program

  The whole program on x86-64, and its link to the proofs about `sha256.c`. The binary of the
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

public import Examples.Sha256Main.X86.Image
public import Examples.Sha256Main.Shared
public import Examples.Sha256.X86.Compress
public import Examples.Sha256.X86.LeakCompress

@[expose] public section

namespace Examples.Sha256Main.X86

open Braid Examples Examples.Sha256 Lowering.X86 Lowering.X86.Regs

/-- The lowered code of the whole binary. -/
def program : Braid.Program := Braid.Program.ofList sha256_main_blocks

/-- The compression function of this binary is that of the binary of `sha256.c`, block for
block. -/
theorem compress_blocks : sha256_compress.blocks = Sha256.X86.sha256_compress.blocks := rfl

/-- The code of `sha256_compress` is part of the program. -/
theorem program_of_compress (a : Word) (b : Block)
    (h : Sha256.X86.sha256_compress.program a = some b) : program a = some b := by
  refine Braid.Program.ofList_mono (fun p hp => ?_) (by decide +kernel) a b h
  rw [sha256_main_blocks, compress_blocks]
  exact List.mem_append_left _ (List.mem_append_left _ hp)

/-- **A call of `sha256_compress`.** The specification of `sha256_compress` and what it
reveals, both proved about the binary of `sha256.c`, as one traced triple about the whole
program, for a call whose return address `r`, which is on the stack at `s`, is outside the
function. -/
theorem compress_call (hp mp s r vb vp v12 v14 v15 : Word) (H M : List W32)
    (wm wk : Bool) (fvs fws sv : List Word) (t0 t2 t3 t8 t9 t10 t11 : Word)
    (c pf af z sg o : Bool) (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 8)
    (hfw : fws.length = 64) (hsv : sv.length = 5)
    (hr : Sha256.X86.sha256_compress.program r = none) (t : Trace) :
    TripleT program
      (Atoms.interp [.pc 0x401100#64, .reg rdi hp, .reg rsi mp, .reg rax t0, .reg rcx t2,
        .reg rdx t3, .reg r8 t8, .reg r9 t9, .reg r10 t10, .reg r11 t11, .reg rbx vb,
        .reg rbp vp, .reg r12 v12, .reg r14 v14, .reg r15 v15, .reg rsp s,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x4022b0#64 (w32s K)),
        .prop (cellsAt 4 true (s - 328#64) fvs), .prop (cellsAt 4 true (s - 296#64) fws),
        .prop (cellsAt 8 true (s - 40#64) sv), .prop (cellsAt 8 true s [r])]) t
      (Atoms.interp [.pc r, .reg rdi hp, .prop (regAny rsi), .prop (regAny rax),
        .prop (regAny rcx), .prop (regAny rdx), .prop (regAny r8), .prop (regAny r9),
        .prop (regAny r10), .prop (regAny r11), .reg rbx vb, .reg rbp vp, .reg r12 v12,
        .reg r14 v14, .reg r15 v15, .reg rsp (s + 8#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true hp (w32s (compress H M))), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x4022b0#64 (w32s K)),
        .prop (cellsAt 4 true (s - 328#64)
          (w32s (rounds (schedule M) (Vars.ofList H) 64).toList)),
        .prop (cellsAt 4 true (s - 296#64) (w32s (schedule M))),
        .prop (cellsAt 8 true (s - 40#64) [vb, v12, v14, v15, vp]),
        .prop (cellsAt 8 true s [r])])
      (t ++ Sha256.X86.compressLeak hp mp s r) :=
  (TripleT.of_spec hr (by braid_at) (by braid_at)
    (Sha256.X86.sha256_compress_spec hp mp s r vb vp v12 v14 v15 H M wm wk fvs fws sv
      t0 t2 t3 t8 t9 t10 t11 c pf af z sg o hH hM hfv hfw hsv)
    (Sha256.X86.sha256_compress_trace hp mp s r vb vp v12 v14 v15 H M wm wk fvs fws sv
      t0 t2 t3 t8 t9 t10 t11 c pf af z sg o hH hM hfv hfw hsv t)).mono
    program_of_compress

end Examples.Sha256Main.X86
