/-
  Examples.Sha256Main.RiscV.Main

  The whole run of the program on RISC-V, in the logic: from the entry point of the binary,
  with its sections in memory and nothing else assumed, to the exit call. The sections are
  turned into what the code uses (the table of round constants, the stack frame of `main` and
  that of `sha256_compress`), and the run is `_start`, the prologue, the loop over the
  blocks, the loop that writes the digest out as bytes, the call that writes them out and
  the call that exits.

  ## Main definitions

  * `mainLeak`: what a run reveals, as a function of the length of the message

  ## Main results

  * `total_mask`, `total_shift`: the padded length and the shift of the length's first byte,
    as the code computes them
  * `sha256_main_trace`: the whole run, with its trace
-/

module

public import Examples.Sha256Main.RiscV.Output

@[expose] public section

namespace Examples.Sha256Main.RiscV

open Braid Examples Examples.Sha256 Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- The section of read-only data of the binary is the table of round constants. -/
theorem rodata_eq : sha256_main_section_rodata = (w32s K).flatMap (leBytes 4) := by
  decide +kernel

/-! ## The lengths, as the code computes them -/

/-- Give a 32-bit cell of the symbolic state the 32-bit value `v`, which is its low half:
`main_cell a, v`. -/
local macro "main_cell " a:term ", " v:term : tactic =>
  `(tactic| (refine TripleT.mem4_val (a := $a) (BitVec.setWidth 64 $v) (by braid_upd)
               (by decide) ?_))

/-! ## The whole run -/

/-- What a run of the program on a message of `n` bytes reveals, apart from what it writes
out and its exit: the registers `main` saves, the length read, the initial hash value
written, the blocks, each padded and compressed, and the digest written out as bytes. It is
a function of `n` alone. -/
def mainLeak (n : Nat) : Trace :=
  [.write 0x10e38#64 8, .write 0x10e30#64 8, .write 0x10e28#64 8, .write 0x10e20#64 8,
    .write 0x10e18#64 8, .write 0x10e10#64 8, .write 0x10e08#64 8, .write 0x10e00#64 8,
    .write 0x10df8#64 8, .write 0x10df0#64 8, .read 0x10e40#64 8, .write 0x10dd0#64 4,
    .write 0x10dd4#64 4, .write 0x10dd8#64 4, .write 0x10ddc#64 4, .write 0x10de0#64 4,
    .write 0x10de4#64 4, .write 0x10de8#64 4, .write 0x10dec#64 4, .jump 0x10518#64] ++
  blocksLeak n 0 ((n + 8) / 64) ++ outLeak 0x10d70#64 0x10dd0#64 7

/-- **The whole run of the program, in the logic.** From the entry point, with the sections
of the binary in memory (the table of round constants, 2048 zero bytes of stack, the length
of the message and the message `msg`) and any values in the registers, the program runs to
its exit call and stays there, with 0 in `t0` and in `a0`. Its trace is `mainLeak` of the
length of the message, then
the event of writing out the 32 bytes of the SHA-256 digest of `msg`, then the event of
exiting with code 0. The digest is also left in memory at `0x10d70`. -/
theorem sha256_main_trace (msg : List (BitVec 8)) (hn : msg.length < 2 ^ 32)
    (x1 x2 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20 x21 x22 x23 x24 x28 x29
      x30 x31 : Word) :
    TripleT program
      (Atoms.interp [.pc 0x10468#64, .reg ra x1, .reg sp x2, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .reg s0 x8, .reg s1 x9, .reg a0 x10, .reg a1 x11, .reg a2 x12,
        .reg a3 x13, .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg s2 x18,
        .reg s3 x19, .reg s4 x20, .reg s5 x21, .reg s6 x22, .reg s7 x23, .reg s8 x24,
        .reg t3 x28, .reg t4 x29, .reg t5 x30, .reg t6 x31,
        .prop (bytesAt 0x10368#64 sha256_main_section_rodata),
        .prop (bytesAt 0x10640#64 (List.replicate 2048 0#8)),
        .prop (bytesAt 0x10e40#64 (leBytes 8 (BitVec.ofNat 64 msg.length))),
        .prop (bytesAt 0x10e48#64 msg)]) []
      (Atoms.interp [.pc 0x10634#64, .prop (regAny ra), .prop (regAny sp), .reg t0 0#64,
        .prop (regAny t1), .prop (regAny t2), .prop (regAny s0), .prop (regAny s1),
        .reg a0 0#64, .prop (regAny a1), .prop (regAny a2), .prop (regAny a3),
        .prop (regAny a4), .prop (regAny a5), .prop (regAny a6), .prop (regAny a7),
        .prop (regAny s2), .prop (regAny s3), .prop (regAny s4), .prop (regAny s5),
        .prop (regAny s6), .prop (regAny s7), .prop (regAny s8), .prop (regAny t3),
        .prop (regAny t4), .prop (regAny t5), .prop (regAny t6),
        .prop (cellsAt 4 true 0x10368#64 (w32s K)),
        .prop (bytesAt 0x10640#64 (List.replicate 1528 0#8)),
        .prop (cellsAny 4 true 0x10c38#64 8), .prop (cellsAny 4 true 0x10c58#64 64),
        .prop (cellsAny 8 true 0x10d58#64 3), .prop (bytesAt 0x10d70#64 (sha256 msg)),
        .prop (cellsAny 4 true 0x10d90#64 16), .prop (cellsAny 4 true 0x10dd0#64 8),
        .mem 0x10df0#64 8 x24 true, .mem 0x10df8#64 8 x23 true, .mem 0x10e00#64 8 x22 true,
        .mem 0x10e08#64 8 x21 true, .mem 0x10e10#64 8 x20 true, .mem 0x10e18#64 8 x19 true,
        .mem 0x10e20#64 8 x18 true, .mem 0x10e28#64 8 x9 true, .mem 0x10e30#64 8 x8 true,
        .mem 0x10e38#64 8 x1 true, .mem 0x10e40#64 8 (BitVec.ofNat 64 msg.length) true,
        .prop (bytesAt 0x10e48#64 msg)])
      (mainLeak msg.length ++
        [.event (.write (sha256 msg)), .event (.exit 0#64)]) := by
  braid_unfold bytesAt_interp_cellsAt 0x10368#64 _ (w32s K) 4 (by decide) rodata_eq
  braid_unfold bytesAt_leBytes 0x10e40#64 (BitVec.ofNat 64 msg.length) 8 (by decide)
  braid_unfold bytesAt_zero_split 0x10640#64 2048 1528 520 rfl
  braid_unfold bytesAt_zero_split 0x10c38#64 520 32 488 rfl
  braid_unfold bytesAt_zero_split 0x10c58#64 488 256 232 rfl
  braid_unfold bytesAt_zero_split 0x10d58#64 232 24 208 rfl
  braid_unfold bytesAt_zero_split 0x10d70#64 208 32 176 rfl
  braid_unfold bytesAt_zero_split 0x10d90#64 176 64 112 rfl
  braid_unfold bytesAt_zero_split 0x10dd0#64 112 32 80 rfl
  braid_unfold bytesAt_interp_cellsAt 0x10c38#64 _ (List.replicate 8 0#64) 4 (by decide)
    (flatMap_leBytes_zero 4 8).symm
  braid_unfold bytesAt_interp_cellsAt 0x10c58#64 _ (List.replicate 64 0#64) 4 (by decide)
    (flatMap_leBytes_zero 4 64).symm
  braid_unfold bytesAt_interp_cellsAt 0x10d58#64 _ (List.replicate 3 0#64) 8 (by decide)
    (flatMap_leBytes_zero 8 3).symm
  braid_unfold bytesAt_interp_cellsAt 0x10d90#64 _ (List.replicate 16 0#64) 4 (by decide)
    (flatMap_leBytes_zero 4 16).symm
  braid_unfold bytesAt_interp_cellsAt 0x10dd0#64 _ [0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64]
    4 (by decide) (flatMap_leBytes_zero 4 8).symm
  braid_unfold bytesAt_interp_cellsAt 0x10df0#64 _
    [0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64] 8 (by decide)
    (flatMap_leBytes_zero 8 10).symm
  braid_unfold cells8 true 0x10dd0#64 0#64 0#64 0#64 0#64 0#64 0#64 0#64 0#64
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x10df0#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x10df8#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x10e00#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x10e08#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x10e10#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x10e18#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x10e20#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x10e28#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x10e30#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x10e38#64 0#64 []
  have hT : 64 ≤ total msg.length := by simp only [total]; omega
  have hT' := total_lt msg.length
  braid_sym_run_to 0x10514
  rw [total_mask msg.length hn, show BitVec.ofNat 64 (total msg.length - 64) + 64#64 =
    BitVec.ofNat 64 (total msg.length) from by bv_omega]
  braid_sym_step
  · exfalso; bv_omega
  braid_sym_run_to 0x1055c
  rw [total_shift msg.length hn, shl3, show BitVec.ofNat 64 (total msg.length - 64) + 56#64 =
    BitVec.ofNat 64 (total msg.length - 8) from by bv_omega]
  main_cell 0x10dd0#64, 0x6a09e667#32
  main_cell 0x10dd4#64, 0xbb67ae85#32
  main_cell 0x10dd8#64, 0x3c6ef372#32
  main_cell 0x10ddc#64, 0xa54ff53a#32
  main_cell 0x10de0#64, 0x510e527f#32
  main_cell 0x10de4#64, 0x9b05688c#32
  main_cell 0x10de8#64, 0x1f83d9ab#32
  main_cell 0x10dec#64, 0x5be0cd19#32
  braid_fold cells8_w32 true 0x10dd0#64 0x6a09e667#32 0xbb67ae85#32 0x3c6ef372#32 0xa54ff53a#32
    0x510e527f#32 0x9b05688c#32 0x1f83d9ab#32 0x5be0cd19#32
  rw [← H0_eq]
  have hr : 64 * (0 + (msg.length + 8) / 64 + 1) = total msg.length := by
    simp only [total]; omega
  braid_call blocks_loop msg hn ((msg.length + 8) / 64) 0 H0 (List.replicate 16 0#64)
    (List.replicate 8 0#64)
    (List.replicate 64 0#64) (List.replicate 3 0#64) x1 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 0#64 _ _
    hr rfl (by simp) (by simp) (by simp) (by simp) rfl rfl
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
  braid_name_reg 10
  braid_name_reg 11
  braid_name_reg 12
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  braid_name_reg 16
  braid_sym_run_to 0x105f0
  braid_call out_loop 0x10df0#64 xs x (List.replicate 32 0#8) 0x10d70#64 0x10dd0#64 _ _ _ _ _
    (by simp; omega) (by rw [show xs.length = 7 from by omega]; rfl) (by omega) (by decide)
  rw [← hsha]
  have hl32 : (sha256 msg).length = 32 := by
    rw [hsha, flatMap_wordBytes_length, List.length_cons]; omega
  braid_name_reg 10
  braid_name_reg 11
  braid_name_reg 5
  braid_sym_run_to 0x10628
  refine TripleT.ecall_write (p := 0x10628#64) (a := 0x10d70#64) (bs := sha256 msg) rfl
    (by braid_at) (by braid_at) (by braid_at) (by braid_at) (by rw [hl32]) (by braid_at)
    (by omega) (by braid_upd) ?_
  braid_sym_run_to 0x10634
  refine TripleT.ecall_exit (p := 0x10634#64) (c := 0#64) rfl (by braid_at) (by braid_at)
    (by braid_at) ?_
  braid_unfold cellsAt_nil (k := 8) (w := true) 0x10e40#64
  braid_forget 11
  braid_forget 12
  braid_forget 2
  braid_forget_cells 0x10dd0#64, 8, (by simp; omega)
  have hne : sha256 msg ≠ [] := by intro h; rw [h] at hl32; cases hl32
  have h7 : xs.length = 7 := by omega
  braid_norm
  refine TripleT.done_split (by braid_split) ?_
  simp [mainLeak, outLabels, hne, h7]

end Examples.Sha256Main.RiscV
