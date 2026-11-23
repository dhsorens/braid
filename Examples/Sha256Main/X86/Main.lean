/-
  Examples.Sha256Main.X86.Main

  The whole run of the program on x86-64, in the logic: from the entry point of the binary,
  with its sections in memory and nothing else assumed, to the loop in which it ends. The
  sections are turned into what the code uses (the table of round constants, the stack frame
  of `main`, that of `sha256_compress` and the return address between them, and `digest`),
  and the run is `_start`, the prologue, the loop over the blocks, and the loops that write
  the digest out.

  ## Main definitions

  * `mainLeak`: what a run reveals, as a function of the length of the message

  ## Main results

  * `total_or`, `total_shift_or`: the padded length less eight and the shift of the length's
    first byte, as the code computes them
  * `sha256_main_trace`: the whole run, with its trace
-/

module

public import Examples.Sha256Main.X86.Output
import Braid.BV

@[expose] public section

namespace Examples.Sha256Main.X86

open Braid Examples Examples.Sha256 Lowering.X86 Lowering.X86.Regs

/-- The section of read-only data of the binary is the table of round constants. -/
theorem rodata_eq : sha256_main_section_rodata = (w32s K).flatMap (leBytes 4) := by
  decide +kernel

/-- The initial hash value, as the four 64-bit words the code stores. -/
theorem H0_bytes : [0xbb67ae856a09e667#64, 0xa54ff53a3c6ef372#64, 0x9b05688c510e527f#64,
    0x5be0cd191f83d9ab#64].flatMap (leBytes 8) = (w32s H0).flatMap (leBytes 4) := by
  decide +kernel

/-! ## The lengths, as the code computes them -/

/-- The padded length less eight, as the code computes it. -/
theorem total_or (n : Nat) (hn : n < 2 ^ 32) :
    BitVec.ofNat 64 n + 8#64 &&& 18446744073709551552#64 ||| 56#64 =
      BitVec.ofNat 64 (total n - 8) := by
  have key : ∀ x : Word, x &&& 18446744073709551552#64 ||| 56#64 =
      (x &&& 18446744073709551552#64) + 56#64 := by
    intro x; bv_auto
  have hT : 64 ≤ total n := by simp only [total]; omega
  have hT' := total_lt n
  rw [key, total_mask n hn]
  bv_omega

/-- The shift of the first byte of the length, as the code computes it. -/
theorem total_shift_or (n : Nat) (hn : n < 2 ^ 32) :
    (BitVec.ofNat 64 n + 8#64 ||| 63#64) <<< 3#64 =
      BitVec.ofNat 64 (8 * (total n - 1 - 64 * 0)) := by
  have key : ∀ x : Word, (x ||| 63#64) <<< 3#64 = x <<< 3#64 ||| 504#64 := by
    intro x; bv_auto
  rw [key, total_shift n hn]

/-! ## The whole run -/

/-- What a run of the program on a message of `n` bytes reveals: the registers `main`
saves, the length read, the initial hash value and the padded length written, the blocks,
each padded and compressed, and the digest written out. It is a function of `n` alone. -/
def mainLeak (n : Nat) : Trace :=
  [.write 0x402d38#64 8, .write 0x402d30#64 8, .write 0x402d28#64 8, .write 0x402d20#64 8,
    .write 0x402d18#64 8, .write 0x402d10#64 8, .read 0x402d60#64 8, .write 0x402c88#64 8,
    .write 0x402c90#64 8, .write 0x402c98#64 8, .write 0x402ca0#64 8, .write 0x402c80#64 8,
    .jump 0x402437#64] ++
  blocksLeak n 0 ((n + 8) / 64) ++ outLeak

/-- **The whole run of the program, in the logic.** From the entry point, with the sections
of the binary in memory (the table of round constants, 2080 zero bytes for the stack and
`digest`, the length of the message and the message `msg`) and any values in the registers
and flags, the program runs to the loop at `0x402530` in which it ends, with the 32 bytes of
the SHA-256 digest of `msg` at `digest`, `0x402d40`. Its trace is `mainLeak` of the length of
the message. There is no event: the model has no system call. Of the zero bytes, the 1512
lowest are never touched. -/
theorem sha256_main_trace (msg : List (BitVec 8)) (hn : msg.length < 2 ^ 32)
    (x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 : Word) (c pf af z sg o : Bool) :
    TripleT program
      (Atoms.interp [.pc 0x4023b0#64, .reg rax x0, .reg rbx x1, .reg rcx x2, .reg rdx x3,
        .reg rsi x4, .reg rdi x5, .reg rsp x6, .reg rbp x7, .reg r8 x8, .reg r9 x9,
        .reg r10 x10, .reg r11 x11, .reg r12 x12, .reg r13 x13, .reg r14 x14, .reg r15 x15,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (bytesAt 0x4022b0#64 sha256_main_section_rodata),
        .prop (bytesAt 0x402540#64 (List.replicate 2080 0#8)),
        .prop (bytesAt 0x402d60#64 (leBytes 8 (BitVec.ofNat 64 msg.length))),
        .prop (bytesAt 0x402d68#64 msg)]) []
      (Atoms.interp [.pc 0x402530#64, .prop (regAny rax), .prop (regAny rbx),
        .prop (regAny rcx), .prop (regAny rdx), .prop (regAny rsi), .prop (regAny rdi),
        .reg rsp 0x402c78#64, .prop (regAny rbp), .prop (regAny r8), .prop (regAny r9),
        .prop (regAny r10), .prop (regAny r11), .prop (regAny r12), .prop (regAny r13),
        .prop (regAny r14), .prop (regAny r15),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true 0x4022b0#64 (w32s K)),
        .prop (bytesAt 0x402540#64 (List.replicate 1512 0#8)),
        .prop (cellsAny 4 true 0x402b28#64 8), .prop (cellsAny 4 true 0x402b48#64 64),
        .prop (cellsAny 8 true 0x402c48#64 5), .mem 0x402c70#64 8 0x40246f#64 true,
        .prop (bytesAt 0x402c78#64 (List.replicate 8 0#8)),
        .mem 0x402c80#64 8 (BitVec.ofNat 64 (total msg.length)) true,
        .prop (cellsAny 4 true 0x402c88#64 8), .prop (bytesAt 0x402ca8#64 (sha256 msg)),
        .prop (cellsAny 4 true 0x402cc8#64 16),
        .prop (bytesAt 0x402d08#64 (List.replicate 8 0#8)),
        .mem 0x402d10#64 8 x1 true, .mem 0x402d18#64 8 x12 true, .mem 0x402d20#64 8 x13 true,
        .mem 0x402d28#64 8 x14 true, .mem 0x402d30#64 8 x15 true, .mem 0x402d38#64 8 x7 true,
        .prop (bytesAt 0x402d40#64 (sha256 msg)),
        .mem 0x402d60#64 8 (BitVec.ofNat 64 msg.length) true,
        .prop (bytesAt 0x402d68#64 msg)]) (mainLeak msg.length) := by
  braid_unfold bytesAt_interp_cellsAt 0x4022b0#64 _ (w32s K) 4 (by decide) rodata_eq
  braid_unfold bytesAt_leBytes 0x402d60#64 (BitVec.ofNat 64 msg.length) 8 (by decide)
  braid_unfold bytesAt_zero_split 0x402540#64 2080 1512 568 rfl
  braid_unfold bytesAt_zero_split 0x402b28#64 568 32 536 rfl
  braid_unfold bytesAt_zero_split 0x402b48#64 536 256 280 rfl
  braid_unfold bytesAt_zero_split 0x402c48#64 280 40 240 rfl
  braid_unfold bytesAt_zero_split 0x402c70#64 240 8 232 rfl
  braid_unfold bytesAt_zero_split 0x402c78#64 232 8 224 rfl
  braid_unfold bytesAt_zero_split 0x402c80#64 224 8 216 rfl
  braid_unfold bytesAt_zero_split 0x402c88#64 216 32 184 rfl
  braid_unfold bytesAt_zero_split 0x402ca8#64 184 32 152 rfl
  braid_unfold bytesAt_zero_split 0x402cc8#64 152 64 88 rfl
  braid_unfold bytesAt_zero_split 0x402d08#64 88 8 80 rfl
  braid_unfold bytesAt_zero_split 0x402d10#64 80 48 32 rfl
  braid_unfold bytesAt_interp_cellsAt 0x402b28#64 _ (List.replicate 8 0#64) 4 (by decide)
    (flatMap_leBytes_zero 4 8).symm
  braid_unfold bytesAt_interp_cellsAt 0x402b48#64 _ (List.replicate 64 0#64) 4 (by decide)
    (flatMap_leBytes_zero 4 64).symm
  braid_unfold bytesAt_interp_cellsAt 0x402c48#64 _ (List.replicate 5 0#64) 8 (by decide)
    (flatMap_leBytes_zero 8 5).symm
  braid_unfold bytesAt_interp_mem 0x402c70#64 0#64 8 _ (by decide) (leBytes_zero_word 8).symm
  braid_unfold bytesAt_interp_mem 0x402c80#64 0#64 8 _ (by decide) (leBytes_zero_word 8).symm
  braid_unfold bytesAt_interp_cellsAt 0x402c88#64 _ [0#64, 0#64, 0#64, 0#64] 8 (by decide)
    (flatMap_leBytes_zero 8 4).symm
  braid_unfold bytesAt_interp_cellsAt 0x402ca8#64 _ (List.replicate 8 0#64) 4 (by decide)
    (flatMap_leBytes_zero 4 8).symm
  braid_unfold bytesAt_interp_cellsAt 0x402cc8#64 _ (List.replicate 16 0#64) 4 (by decide)
    (flatMap_leBytes_zero 4 16).symm
  braid_unfold bytesAt_interp_cellsAt 0x402d10#64 _ [0#64, 0#64, 0#64, 0#64, 0#64, 0#64] 8
    (by decide) (flatMap_leBytes_zero 8 6).symm
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x402c88#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x402c90#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x402c98#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x402ca0#64 0#64 []
  braid_unfold cellsAt_nil (k := 8) (w := true) 0x402ca8#64
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x402d10#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x402d18#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x402d20#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x402d28#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x402d30#64 0#64 _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x402d38#64 0#64 []
  braid_unfold cellsAt_nil (k := 8) (w := true) 0x402d40#64
  have hT : 64 ≤ total msg.length := by simp only [total]; omega
  have hT' := total_lt msg.length
  braid_sym_run_to 0x402431
  have hTm : 64#64 + (BitVec.ofNat 64 msg.length + 8#64 &&& 18446744073709551552#64) =
      BitVec.ofNat 64 (total msg.length) := by
    rw [total_mask msg.length hn]; bv_omega
  rw [hTm]
  braid_sym_step
  · exfalso; bv_omega
  braid_sym_run_to 0x402481
  refine Sha256.X86.tripleT_reg_val (r := 7) (BitVec.ofNat 64 (8 * msg.length)) (by braid_upd)
    (shl3 _) ?_
  refine Sha256.X86.tripleT_reg_val (r := 13) (BitVec.ofNat 64 (total msg.length - 8))
    (by braid_upd) (total_or _ hn) ?_
  refine Sha256.X86.tripleT_reg_val (r := 12)
    (BitVec.ofNat 64 (8 * (total msg.length - 1 - 64 * 0))) (by braid_upd)
    (total_shift_or _ hn) ?_
  refine Sha256.X86.tripleT_reg_val (r := 14) 0#64 (by braid_upd) (by bv_auto) ?_
  braid_fold cellsAt_nil (k := 8) (w := true) 0x402ca8#64
  braid_fold cellsAt_cons (k := 8) (w := true) 0x402ca0#64 0x5be0cd191f83d9ab#64 []
  braid_fold cellsAt_cons (k := 8) (w := true) 0x402c98#64 0x9b05688c510e527f#64 _
  braid_fold cellsAt_cons (k := 8) (w := true) 0x402c90#64 0xa54ff53a3c6ef372#64 _
  braid_fold cellsAt_cons (k := 8) (w := true) 0x402c88#64 0xbb67ae856a09e667#64 _
  braid_fold bytesAt_interp_cellsAt 0x402c88#64 ((w32s H0).flatMap (leBytes 4))
    [0xbb67ae856a09e667#64, 0xa54ff53a3c6ef372#64, 0x9b05688c510e527f#64,
      0x5be0cd191f83d9ab#64] 8 (by decide) H0_bytes.symm
  braid_unfold bytesAt_interp_cellsAt 0x402c88#64 _ (w32s H0) 4 (by decide) rfl
  x86_name_all_flags
  have hr : 64 * (0 + (msg.length + 8) / 64 + 1) = total msg.length := by
    simp only [total]; omega
  braid_call blocks_loop msg hn ((msg.length + 8) / 64) 0 H0 (List.replicate 16 0#64)
    (List.replicate 8 0#64) (List.replicate 64 0#64) (List.replicate 5 0#64)
    _ _ _ _ _ _ _ _ _ (BitVec.ofNat 64 (8 * (total msg.length - 1 - 64 * 0))) 0#64 0#64
    _ _ _ _ _ _ _ hr rfl (by simp) (by simp) (by simp) (by simp) rfl rfl
  have hsha := sha256_eq_foldl msg _ hr
  have hlen := foldl_compress_length
    ((List.range' 0 ((msg.length + 8) / 64 + 1)).map (block msg)) H0 rfl
  generalize List.foldl compress H0
      (List.map (block msg) (List.range' 0 ((msg.length + 8) / 64 + 1))) = Hf
    at hsha hlen ⊢
  braid_name_reg 0
  braid_name_reg 2
  braid_name_reg 3
  x86_name_all_flags
  braid_sym_run_to 0x4024f0
  refine Sha256.X86.tripleT_reg_val (r := 0) 0#64 (by braid_upd) (by bv_auto) ?_
  x86_name_all_flags
  braid_call out_loop Hf (List.replicate 8 0#64) (List.replicate 32 0#8) _ _ _ _ _ _ _ _ _
    hlen (by simp) (by simp)
  rw [← hsha]
  braid_sym_run_to 0x402530
  braid_forget 2
  braid_forget_cells 0x402c88#64, 8, (by simp [hlen])
  simp only [mainLeak]
  braid_done

end Examples.Sha256Main.X86
