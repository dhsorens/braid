/-
  Examples.Sha256Main.X86.Blocks

  The loop of `main` over the blocks of the padded message, on x86-64: each block is padded
  (`Examples.Sha256Main.X86.Pad`) and compressed into the hash value by a call of
  `sha256_compress`, whose specification and leakage are used as they were proved
  (`compress_call`), not proved again. The call leaves its return address on the stack,
  below the frame of `main`.

  ## Main definitions

  * `blockLeak`, `blocksLeak`: what one block reveals, and the blocks from a block on

  ## Main results

  * `block_step`: one block: padded, compressed, and the loop's branch
  * `blocks_loop`: the blocks from block `b` on
-/

module

public import Examples.Sha256Main.X86.Pad

@[expose] public section

namespace Examples.Sha256Main.X86

open Braid Examples Examples.Sha256 Lowering.X86 Lowering.X86.Regs

/-- What block `b` reveals: its sixteen words, the return address stored by the call of the
compression function, what that function reveals of its arguments, the padded length read
back, and where the loop goes on, `e`. -/
def blockLeak (n b : Nat) (e : Word) : Trace :=
  wordsLeak n b 0 15 ++ [.write 0x402c70#64 8] ++
    Sha256.X86.compressLeak 0x402c88#64 0x402cc8#64 0x402c70#64 0x40246f#64 ++
    [.read 0x402c80#64 8, .jump e]

/-- **One block.** Block `b` of the padded message is written to the sixteen cells at
`0x402cc8` and compressed into the hash value at `0x402c88` by a call of `sha256_compress`,
which leaves its return address at `0x402c70` and uses the 328 bytes below. -/
theorem block_step (msg : List (BitVec 8)) (b : Nat) (H : List W32) (ms fvs fws sv : List Word)
    (x0 x2 x3 x4 x5 x8 x9 x10 x11 x12 x14 ra e : Word) (c pf af z sg o : Bool) (t : Trace)
    (hn : msg.length < 2 ^ 32) (hb : 64 * b + 64 ≤ total msg.length)
    (hH : H.length = 8) (hms : ms.length = 16) (hfv : fvs.length = 8) (hfw : fws.length = 64)
    (hsv : sv.length = 5)
    (h14 : x14 = BitVec.ofNat 64 (64 * b))
    (h12 : x12 = BitVec.ofNat 64 (8 * (total msg.length - 1 - 64 * b)))
    (he : ((x14 + 64#64).ult (BitVec.ofNat 64 (total msg.length)) = false ∧ e = 0x4024ea#64) ∨
      ((x14 + 64#64).ult (BitVec.ofNat 64 (total msg.length)) = true ∧ e = 0x402481#64)) :
    TripleT program
      (Atoms.interp [.pc 0x402481#64, .reg rax x0, .reg rcx x2, .reg rdx x3, .reg rsi x4,
        .reg rdi x5, .reg r8 x8, .reg r9 x9, .reg r10 x10, .reg r11 x11,
        .reg rbx 0x402d68#64, .reg rsp 0x402c78#64,
        .reg rbp (BitVec.ofNat 64 (8 * msg.length)), .reg r12 x12,
        .reg r13 (BitVec.ofNat 64 (total msg.length - 8)), .reg r14 x14,
        .reg r15 (BitVec.ofNat 64 msg.length),
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (bytesAt 0x402d68#64 msg),
        .mem 0x402c80#64 8 (BitVec.ofNat 64 (total msg.length)) true,
        .prop (cellsAt 4 true 0x402cc8#64 ms), .prop (cellsAt 4 true 0x402c88#64 (w32s H)),
        .prop (cellsAt 4 true 0x4022b0#64 (w32s K)),
        .prop (cellsAt 4 true 0x402b28#64 fvs), .prop (cellsAt 4 true 0x402b48#64 fws),
        .prop (cellsAt 8 true 0x402c48#64 sv), .mem 0x402c70#64 8 ra true]) t
      (Atoms.interp [.pc e, .prop (regAny rax), .prop (regAny rcx), .prop (regAny rdx),
        .prop (regAny rsi), .prop (regAny rdi), .prop (regAny r8), .prop (regAny r9),
        .prop (regAny r10), .prop (regAny r11),
        .reg rbx 0x402d68#64, .reg rsp 0x402c78#64,
        .reg rbp (BitVec.ofNat 64 (8 * msg.length)), .reg r12 (x12 - 512#64),
        .reg r13 (BitVec.ofNat 64 (total msg.length - 8)), .reg r14 (x14 + 64#64),
        .reg r15 (BitVec.ofNat 64 msg.length),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (bytesAt 0x402d68#64 msg),
        .mem 0x402c80#64 8 (BitVec.ofNat 64 (total msg.length)) true,
        .prop (cellsAt 4 true 0x402cc8#64 (w32s (block msg b))),
        .prop (cellsAt 4 true 0x402c88#64 (w32s (compress H (block msg b)))),
        .prop (cellsAt 4 true 0x4022b0#64 (w32s K)),
        .prop (cellsAt 4 true 0x402b28#64
          (w32s (rounds (schedule (block msg b)) (Vars.ofList H) 64).toList)),
        .prop (cellsAt 4 true 0x402b48#64 (w32s (schedule (block msg b)))),
        .prop (cellsAt 8 true 0x402c48#64
          [0x402d68#64, x12, x14, BitVec.ofNat 64 msg.length, BitVec.ofNat 64 (8 * msg.length)]),
        .mem 0x402c70#64 8 0x40246f#64 true])
      (t ++ blockLeak msg.length b e) := by
  obtain ⟨cl, rest, rfl⟩ : ∃ cl rest, ms = cl :: rest := by
    cases ms with
    | nil => simp at hms
    | cons cl rest => exact ⟨cl, rest, rfl⟩
  simp only [List.length_cons] at hms
  braid_sym_run_to 0x4024a5
  refine Sha256.X86.tripleT_reg_val (r := 4) 0#64 (by braid_upd) (by bv_decide) ?_
  x86_name_all_flags
  have e0 : (Atom.prop (cellsAt 4 true 0x402cc8#64
      (w32s ((List.range 0).map (blockWord msg b))))).interp = Atoms.interp [] := rfl
  braid_fold e0
  braid_call words_loop msg b hn hb rest 0 cl x14 x2 x12 0#64 x5 x8 x9 x10 0x402cc8#64
    _ _ _ _ _ _ _ (by omega) (by simpa using h14) (by simpa using h12) rfl (by simp)
  have hr : rest.length = 15 := by omega
  rw [hr]
  braid_name_reg 0
  braid_name_reg 2
  braid_name_reg 3
  braid_name_reg 4
  braid_name_reg 5
  braid_name_reg 8
  braid_name_reg 9
  braid_name_reg 10
  x86_name_all_flags
  braid_sym_run_to 0x401100
  braid_fold cellsAt_nil (k := 8) (w := true) 0x402c78#64
  braid_fold cellsAt_cons (k := 8) (w := true) 0x402c70#64 0x40246f#64 []
  braid_call compress_call 0x402c88#64 0x402cc8#64 0x402c70#64 0x40246f#64 0x402d68#64
    (BitVec.ofNat 64 (8 * msg.length)) x12 x14 (BitVec.ofNat 64 msg.length) H (block msg b)
    true true fvs fws sv _ _ _ _ _ _ _ _ _ _ _ _ _ hH (block_length msg b) hfv hfw hsv
    (by decide +kernel) _
  braid_unfold cellsAt_cons (k := 8) (w := true) 0x402c70#64 0x40246f#64 []
  braid_unfold cellsAt_nil (k := 8) (w := true) 0x402c78#64
  braid_sym_run_to 0x40247f
  braid_sym_step
  all_goals
    refine Sha256.X86.tripleT_reg_val (r := 12) (x12 - 512#64) (by braid_upd) (by bv_decide) ?_
    refine Sha256.X86.tripleT_reg_val (r := 14) (x14 + 64#64) (by braid_upd) (by bv_decide) ?_
    braid_forget 5
    x86_forget_all_flags
    rcases he with h | h
    all_goals
      obtain ⟨h1, h2⟩ := h
      subst h2
      first
        | (exfalso; bv_decide)
        | (simp only [blockLeak]; braid_done)

/-! ## The loop over the blocks -/

/-- What the blocks from block `b` on reveal, `r + 1` of them. -/
def blocksLeak (n : Nat) (b : Nat) : Nat → Trace
  | 0 => blockLeak n b 0x4024ea#64
  | r + 1 => blockLeak n b 0x402481#64 ++ blocksLeak n (b + 1) r

/-- Forget what the loop over the blocks leaves behind, but for the hash value. -/
local macro "blocks_forget" : tactic =>
  `(tactic| (braid_forget 1; braid_forget 7; braid_forget 12; braid_forget 13
             braid_forget 14; braid_forget 15
             braid_forget_cells 0x402cc8#64, 16, (by simp)
             braid_forget_cells 0x402b28#64, 8, (by simp [Vars.toList])
             braid_forget_cells 0x402b48#64, 64,
               (by rw [w32s_length]; exact schedule_length _ (block_length _ _))
             braid_forget_cells 0x402c48#64, 5, rfl))

/-- **The loop over the blocks.** From block `b` on, with the hash value `H` so far, the
loop pads each block of the message and compresses it into the hash value, and reveals
`blocksLeak`. -/
theorem blocks_loop (msg : List (BitVec 8)) (hn : msg.length < 2 ^ 32) :
    ∀ (r b : Nat) (H : List W32) (ms fvs fws sv : List Word)
      (x0 x2 x3 x4 x5 x8 x9 x10 x11 x12 x14 ra : Word) (c pf af z sg o : Bool) (t : Trace),
      64 * (b + r + 1) = total msg.length → H.length = 8 → ms.length = 16 → fvs.length = 8 →
      fws.length = 64 → sv.length = 5 → x14 = BitVec.ofNat 64 (64 * b) →
      x12 = BitVec.ofNat 64 (8 * (total msg.length - 1 - 64 * b)) →
    TripleT program
      (Atoms.interp [.pc 0x402481#64, .reg rax x0, .reg rcx x2, .reg rdx x3, .reg rsi x4,
        .reg rdi x5, .reg r8 x8, .reg r9 x9, .reg r10 x10, .reg r11 x11,
        .reg rbx 0x402d68#64, .reg rsp 0x402c78#64,
        .reg rbp (BitVec.ofNat 64 (8 * msg.length)), .reg r12 x12,
        .reg r13 (BitVec.ofNat 64 (total msg.length - 8)), .reg r14 x14,
        .reg r15 (BitVec.ofNat 64 msg.length),
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (bytesAt 0x402d68#64 msg),
        .mem 0x402c80#64 8 (BitVec.ofNat 64 (total msg.length)) true,
        .prop (cellsAt 4 true 0x402cc8#64 ms), .prop (cellsAt 4 true 0x402c88#64 (w32s H)),
        .prop (cellsAt 4 true 0x4022b0#64 (w32s K)),
        .prop (cellsAt 4 true 0x402b28#64 fvs), .prop (cellsAt 4 true 0x402b48#64 fws),
        .prop (cellsAt 8 true 0x402c48#64 sv), .mem 0x402c70#64 8 ra true]) t
      (Atoms.interp [.pc 0x4024ea#64, .prop (regAny rax), .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .prop (regAny rdi), .prop (regAny r8),
        .prop (regAny r9), .prop (regAny r10), .prop (regAny r11), .prop (regAny rbx),
        .reg rsp 0x402c78#64, .prop (regAny rbp), .prop (regAny r12), .prop (regAny r13),
        .prop (regAny r14), .prop (regAny r15),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (bytesAt 0x402d68#64 msg),
        .mem 0x402c80#64 8 (BitVec.ofNat 64 (total msg.length)) true,
        .prop (cellsAny 4 true 0x402cc8#64 16),
        .prop (cellsAt 4 true 0x402c88#64
          (w32s (((List.range' b (r + 1)).map (block msg)).foldl compress H))),
        .prop (cellsAt 4 true 0x4022b0#64 (w32s K)),
        .prop (cellsAny 4 true 0x402b28#64 8), .prop (cellsAny 4 true 0x402b48#64 64),
        .prop (cellsAny 8 true 0x402c48#64 5), .mem 0x402c70#64 8 0x40246f#64 true])
      (t ++ blocksLeak msg.length b r) := by
  have hT := total_lt msg.length
  intro r
  induction r with
  | zero =>
    intro b H ms fvs fws sv x0 x2 x3 x4 x5 x8 x9 x10 x11 x12 x14 ra c pf af z sg o
      t hb hH hms hfv hfw hsv h14 h12
    braid_call block_step msg b H ms fvs fws sv x0 x2 x3 x4 x5 x8 x9 x10 x11 x12 x14 ra
      0x4024ea#64 c pf af z sg o _ hn (by omega) hH hms hfv hfw hsv h14 h12
      (.inl ⟨ult_false (by rw [h14]; bv_omega), rfl⟩)
    blocks_forget
    braid_done
  | succ r ih =>
    intro b H ms fvs fws sv x0 x2 x3 x4 x5 x8 x9 x10 x11 x12 x14 ra c pf af z sg o
      t hb hH hms hfv hfw hsv h14 h12
    braid_call block_step msg b H ms fvs fws sv x0 x2 x3 x4 x5 x8 x9 x10 x11 x12 x14 ra
      0x402481#64 c pf af z sg o _ hn (by omega) hH hms hfv hfw hsv h14 h12
      (.inr ⟨ult_true (by rw [h14]; bv_omega), rfl⟩)
    braid_name_reg 0
    braid_name_reg 2
    braid_name_reg 3
    braid_name_reg 4
    braid_name_reg 5
    braid_name_reg 8
    braid_name_reg 9
    braid_name_reg 10
    braid_name_reg 11
    x86_name_all_flags
    braid_call ih (b + 1) (compress H (block msg b)) (w32s (block msg b))
      (w32s (rounds (schedule (block msg b)) (Vars.ofList H) 64).toList)
      (w32s (schedule (block msg b)))
      [0x402d68#64, x12, x14, BitVec.ofNat 64 msg.length, BitVec.ofNat 64 (8 * msg.length)]
      _ _ _ _ _ _ _ _ _ (x12 - 512#64) (x14 + 64#64) 0x40246f#64 _ _ _ _ _ _ _
      (by omega) (compress_length _ _ hH) (by simp) (by simp [Vars.toList])
      (by rw [w32s_length]; exact schedule_length _ (block_length _ _)) rfl
      (by rw [h14]; bv_omega) (by rw [h12]; bv_omega)
    rw [List.range'_succ (s := b) (n := r + 1), List.map_cons, List.foldl_cons]
    braid_done

end Examples.Sha256Main.X86
