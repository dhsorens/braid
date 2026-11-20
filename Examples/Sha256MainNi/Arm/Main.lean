/-
  Examples.Sha256MainNi.Arm.Main

  The whole run of the program on AArch64 with the compression function of `sha256_ni.c`, in
  the logic: from the entry point of the binary, with its sections in memory and nothing
  else assumed, to the exit call. The sections are turned into what the code uses (the table
  of round constants, the two addresses the code loads, the stack frame of `main`; the
  callee has no frame, and the stack beneath that of `main` stays as it was), and the run is
  `_start`, the prologue, the loop over the blocks, the loop that writes the digest out as
  bytes (`out_loop`, proved about the own code of the scalar program and carried here with
  `own_le`), the call that writes them out and the call that exits.

  ## Main definitions

  * `mainLeak`: what a run reveals, as a function of the length of the message

  ## Main results

  * `sha256_main_trace`: the whole run, with its trace
-/

module

public import Examples.Sha256MainNi.Arm.Blocks
public import Examples.Sha256Main.Arm.Output

@[expose] public section

namespace Examples.Sha256MainNi.Arm

open Braid Examples Examples.Sha256 Examples.Sha256Main Lowering.Arm Lowering.Arm.Regs
open Examples.Sha256Main.Arm (outLeak out_loop)

/-- The section of read-only data of the binary is the table of round constants. -/
theorem rodata_eq : sha256_main_ni_section_rodata = (w32s K).flatMap (leBytes 4) := by
  decide +kernel

/-- The table of addresses of the binary holds where the length of the message is, and where
the message is. -/
theorem got_eq :
    sha256_main_ni_section_got = [0x20ce0#64, 0x20ce8#64].flatMap (leBytes 8) := by
  decide +kernel

/-- The two supervisor calls of the program. -/
theorem svc_at_write : program 0x204bc#64 = some (svc 0x204bc#64) := by decide +kernel

theorem svc_at_exit : program 0x204c8#64 = some (svc 0x204c8#64) := by decide +kernel

/-- Give a 32-bit cell of the symbolic state the 32-bit value `v`, which is its low half:
`main_cell a, v`. -/
local macro "main_cell " a:term ", " v:term : tactic =>
  `(tactic| (refine TripleT.mem4_val (a := $a) (BitVec.setWidth 64 $v) (by braid_upd)
               (by decide) ?_))

/-! ## The whole run -/

/-- What a run of the program on a message of `n` bytes reveals, apart from what it writes
out and its exit: the registers `main` saves, the address of the length and the length read,
the initial hash value written, the address of the message read, the blocks, each padded and
compressed, and the digest written out as bytes. It is a function of `n` alone. -/
def mainLeak (n : Nat) : Trace :=
  [.write 0x20c90#64 8, .write 0x20c98#64 8, .write 0x20ca0#64 8, .write 0x20ca8#64 8,
    .write 0x20cb0#64 8, .write 0x20cb8#64 8, .write 0x20cc0#64 8, .write 0x20cc8#64 8,
    .write 0x20cd0#64 8, .write 0x20cd8#64 8, .read 0x204d0#64 8, .read 0x20ce0#64 8,
    .write 0x20c70#64 8, .write 0x20c78#64 8, .write 0x20c80#64 8, .write 0x20c88#64 8,
    .jump 0x203b8#64, .read 0x204d8#64 8] ++
  blocksLeak n 0 ((n + 8) / 64) ++ outLeak 0x20c10#64 0x20c70#64 7

/-- **The whole run of the program, in the logic.** From the entry point, with the sections
of the binary in memory (read-only, the table of round constants, the two addresses the code
loads, the length of the message and the message `msg`; writable, 2048 zero bytes of stack)
and any values in the registers and the flags, the program runs to its exit call and stays
there, with 93 in `x8` and 0 in `x0`. The registers are those the program reads or writes,
the vector registers of `sha256_compress_ni` among them. Of the stack it uses the last 208
bytes, the frame of `main`, and leaves the 1840 bytes beneath them zero. Its trace is
`mainLeak` of the length of the message, then the event of writing out the 32 bytes of the
SHA-256 digest of `msg`, then the event of exiting with code 0. The digest is also left in
memory at `0x20c10`. -/
theorem sha256_main_trace (msg : List (BitVec 8)) (hn : msg.length < 2 ^ 32)
    (r0 r1 r2 r8 r9 r10 r11 r12 r13 r14 r15
      u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u16 u16' u17 u17' u18 u18' u19 u19'
      r19 r20 r21 r22 r23 r24 r25 r26 r29 r30 rsp : Word) (fn fz fc fv : Bool) :
    TripleT program
      (Atoms.interp [.pc 0x20328#64, .reg x0 r0, .reg x1 r1, .reg x2 r2,
        .reg x8 r8, .reg x9 r9, .reg x10 r10, .reg x11 r11,
        .reg x12 r12, .reg x13 r13, .reg x14 r14, .reg x15 r15,
        .reg (vlo 0) u0, .reg (vhi 0) u0', .reg (vlo 1) u1, .reg (vhi 1) u1',
        .reg (vlo 2) u2, .reg (vhi 2) u2', .reg (vlo 3) u3, .reg (vhi 3) u3',
        .reg (vlo 4) u4, .reg (vhi 4) u4', .reg (vlo 5) u5, .reg (vhi 5) u5',
        .reg (vlo 6) u6, .reg (vhi 6) u6', .reg (vlo 7) u7, .reg (vhi 7) u7',
        .reg (vlo 16) u16, .reg (vhi 16) u16', .reg (vlo 17) u17, .reg (vhi 17) u17',
        .reg (vlo 18) u18, .reg (vhi 18) u18', .reg (vlo 19) u19, .reg (vhi 19) u19',
        .reg x19 r19, .reg x20 r20, .reg x21 r21, .reg x22 r22, .reg x23 r23,
        .reg x24 r24, .reg x25 r25, .reg x26 r26, .reg x29 r29, .reg lr r30, .reg sp rsp,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (bytesW false 0x20228#64 sha256_main_ni_section_rodata),
        .prop (bytesW false 0x204d0#64 sha256_main_ni_section_got),
        .prop (bytesW false 0x20ce0#64 (leBytes 8 (BitVec.ofNat 64 msg.length))),
        .prop (bytesW false 0x20ce8#64 msg),
        .prop (bytesAt 0x204e0#64 (List.replicate 2048 0#8))]) []
      (Atoms.interp [.pc 0x204c8#64, .reg x0 0#64, .prop (regAny x1), .prop (regAny x2),
        .reg x8 93#64,
        .prop (regAny x9), .prop (regAny x10), .prop (regAny x11), .prop (regAny x12),
        .prop (regAny x13), .prop (regAny x14), .prop (regAny x15),
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
        .prop (regAny x19), .prop (regAny x20),
        .prop (regAny x21), .prop (regAny x22), .prop (regAny x23), .prop (regAny x24),
        .prop (regAny x25), .prop (regAny x26), .prop (regAny x29), .prop (regAny lr),
        .prop (regAny sp),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAt 4 false 0x20228#64 (w32s K)),
        .mem 0x204d0#64 8 0x20ce0#64 false, .mem 0x204d8#64 8 0x20ce8#64 false,
        .mem 0x20ce0#64 8 (BitVec.ofNat 64 msg.length) false,
        .prop (bytesW false 0x20ce8#64 msg),
        .prop (bytesAt 0x204e0#64 (List.replicate 1840 0#8)),
        .prop (bytesAt 0x20c10#64 (sha256 msg)), .prop (cellsAny 4 true 0x20c30#64 16),
        .prop (cellsAny 4 true 0x20c70#64 8),
        .mem 0x20c90#64 8 r29 true, .mem 0x20c98#64 8 r30 true, .mem 0x20ca0#64 8 r26 true,
        .mem 0x20ca8#64 8 r25 true, .mem 0x20cb0#64 8 r24 true, .mem 0x20cb8#64 8 r23 true,
        .mem 0x20cc0#64 8 r22 true, .mem 0x20cc8#64 8 r21 true, .mem 0x20cd0#64 8 r20 true,
        .mem 0x20cd8#64 8 r19 true])
      (mainLeak msg.length ++
        [.event (.write (sha256 msg)), .event (.exit 0#64)]) := by
  braid_unfold bytesW_interp_cellsAt 0x20228#64 _ (w32s K) 4 (by decide) rodata_eq
  braid_unfold bytesW_interp_cellsAt 0x204d0#64 _ [0x20ce0#64, 0x20ce8#64] 8 (by decide) got_eq
  braid_unfold cellsAt_cons (k := 8) (w := false) 0x204d0#64 0x20ce0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := false) 0x204d8#64 0x20ce8#64 []
  braid_unfold cellsAt_nil (k := 8) (w := false) 0x204e0#64
  braid_unfold bytesW_interp_mem 0x20ce0#64 (BitVec.ofNat 64 msg.length) 8 _ (by decide) rfl
  braid_unfold bytesAt_zero_split 0x204e0#64 2048 1840 208 rfl
  braid_unfold bytesAt_zero_split 0x20c10#64 208 32 176 rfl
  braid_unfold bytesAt_zero_split 0x20c30#64 176 64 112 rfl
  braid_unfold bytesAt_zero_split 0x20c70#64 112 32 80 rfl
  braid_unfold bytesAt_interp_cellsAt 0x20c10#64 _ (0#64 :: List.replicate 7 0#64) 4
    (by decide) (flatMap_leBytes_zero 4 8).symm
  braid_unfold bytesAt_interp_cellsAt 0x20c30#64 _ (List.replicate 16 0#64) 4 (by decide)
    (flatMap_leBytes_zero 4 16).symm
  braid_unfold bytesAt_interp_cellsAt 0x20c70#64 _ [0#64, 0#64, 0#64, 0#64] 8 (by decide)
    (flatMap_leBytes_zero 8 4).symm
  braid_unfold bytesAt_interp_cellsAt 0x20c90#64 _
    [0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64] 8 (by decide)
    (flatMap_leBytes_zero 8 10).symm
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20c70#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20c78#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20c80#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20c88#64 0#64 []
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20c90#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20c98#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20ca0#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20ca8#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20cb0#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20cb8#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20cc0#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20cc8#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20cd0#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x20cd8#64 0#64 []
  have hT : 64 ≤ total msg.length := by simp only [Sha256Main.total]; omega
  have hT' := total_lt msg.length
  braid_sym_run_to 0x203b4
  rw [total_mask msg.length hn, show BitVec.ofNat 64 (total msg.length - 64) + 64#64 =
    BitVec.ofNat 64 (total msg.length) from by bv_omega]
  braid_sym_step
  · exfalso; bv_omega
  braid_sym_run_to 0x203f8
  rw [total_shift msg.length hn, shl3, total_or msg.length hn]
  braid_unfold cellsAt_nil (k := 8) (w := true) 0x20c90#64
  braid_unfold cellsAt_nil (k := 8) (w := true) 0x20ce0#64
  braid_unfold mem8_split 0x20c70#64 _
  braid_unfold mem8_split 0x20c78#64 _
  braid_unfold mem8_split 0x20c80#64 _
  braid_unfold mem8_split 0x20c88#64 _
  main_cell 0x20c70#64, 0x6a09e667#32
  main_cell 0x20c74#64, 0xbb67ae85#32
  main_cell 0x20c78#64, 0x3c6ef372#32
  main_cell 0x20c7c#64, 0xa54ff53a#32
  main_cell 0x20c80#64, 0x510e527f#32
  main_cell 0x20c84#64, 0x9b05688c#32
  main_cell 0x20c88#64, 0x1f83d9ab#32
  main_cell 0x20c8c#64, 0x5be0cd19#32
  braid_fold cells8_w32 true 0x20c70#64 0x6a09e667#32 0xbb67ae85#32 0x3c6ef372#32 0xa54ff53a#32
    0x510e527f#32 0x9b05688c#32 0x1f83d9ab#32 0x5be0cd19#32
  rw [← H0_eq]
  have hr : 64 * (0 + (msg.length + 8) / 64 + 1) = total msg.length := by
    simp only [Sha256Main.total]; omega
  braid_call blocks_loop msg hn ((msg.length + 8) / 64) 0 H0 (List.replicate 16 0#64)
    r0 r1 r2 _ _ _ _ r12 r13 r14 r15
    u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u16 u16' u17 u17' u18 u18' u19 u19'
    0#64 _ _ _ _ _ _ _ hr rfl (by simp) rfl rfl
  have hsha := sha256_eq_foldl msg _ hr
  have hlen := foldl_compress_length
    ((List.range' 0 ((msg.length + 8) / 64 + 1)).map (block msg)) H0 rfl
  generalize List.foldl compress H0
      (List.map (block msg) (List.range' 0 ((msg.length + 8) / 64 + 1))) = Hf
    at hsha hlen ⊢
  obtain ⟨x, xs, rfl⟩ : ∃ x xs, Hf = x :: xs := by
    cases Hf with
    | nil => simp at hlen
    | cons x xs => exact ⟨x, xs, rfl⟩
  simp only [List.length_cons] at hlen
  braid_name_reg 8
  braid_name_reg 9
  braid_name_reg 10
  braid_name_reg 11
  braid_name_flag 0
  braid_name_flag 1
  braid_name_flag 2
  braid_name_flag 3
  braid_sym_run_to 0x20490
  braid_call (out_loop xs x (List.replicate 7 0#64) 0#64 0 0x20c10#64 0x20c70#64 0#64 _
    _ _ _ _ _ (by simp; omega) (by omega) rfl rfl).mono own_le
  rw [← hsha]
  have hl32 : (sha256 msg).length = 32 := by
    rw [hsha, flatMap_wordBytes_length, List.length_cons]; omega
  have hne : sha256 msg ≠ [] := by intro h; rw [h] at hl32; cases hl32
  braid_name_reg 0
  braid_name_reg 1
  braid_name_reg 2
  braid_name_reg 8
  braid_sym_run_to 0x204bc
  refine TripleT.svc_write (p := 0x204bc#64) (a := 0x20c10#64) (bs := sha256 msg) svc_at_write
    (by braid_at) (by braid_at) (by braid_at) (by braid_at) (by braid_at) (by rw [hl32])
    (by braid_at) hne (by omega) (by rw [hl32]; decide) (by braid_upd) (by braid_upd) ?_
  braid_sym_run_to 0x204c8
  refine TripleT.svc_exit (p := 0x204c8#64) (c := 0#64) svc_at_exit (by braid_at) (by braid_at)
    (by braid_at) ?_
  braid_forget 1
  braid_forget 2
  braid_forget 10
  braid_forget 29
  braid_forget 31
  braid_forget_cells 0x20c70#64, 8, (by simp; omega)
  have h7 : xs.length = 7 := by omega
  braid_norm
  refine TripleT.done_split (by braid_split) ?_
  simp [mainLeak, h7]

end Examples.Sha256MainNi.Arm
