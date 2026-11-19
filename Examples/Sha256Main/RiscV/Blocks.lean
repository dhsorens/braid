/-
  Examples.Sha256Main.RiscV.Blocks

  The loop of `main` over the blocks of the padded message, on RISC-V: each block is padded
  (`Examples.Sha256Main.RiscV.Pad`) and compressed into the hash value by a call of
  `sha256_compress`, whose specification and leakage are used as they were proved
  (`compress_call`), not proved again.

  ## Main definitions

  * `blockLeak`, `blocksLeak`: what one block reveals, and the blocks from a block on

  ## Main results

  * `block_step`: one block: padded, compressed, and the loop's branch
  * `blocks_loop`: the blocks from block `b` on
-/

module

public import Examples.Sha256Main.RiscV.Pad

@[expose] public section

namespace Examples.Sha256Main.RiscV

open Braid Examples Examples.Sha256 Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- What block `b` reveals: its sixteen words, the call of the compression function with its
arguments, and where the loop goes on, `e`. -/
def blockLeak (n b : Nat) (e : Word) : Trace :=
  wordsLeak n b 0 15 ++ [.jump 0x10160#64] ++
    Sha256.RiscV.compressLeak 0x10dd0#64 0x10d90#64 0x10d70#64 0x10550#64 ++ [.jump e]

theorem block_step (msg : List (BitVec 8)) (b : Nat) (H : List W32) (ms fvs fws sv : List Word)
    (x1 x10 x11 x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 x18 x23 e : Word) (t : Trace)
    (hn : msg.length < 2 ^ 32) (hb : 64 * b + 64 ≤ total msg.length)
    (hH : H.length = 8) (hms : ms.length = 16) (hfv : fvs.length = 8) (hfw : fws.length = 64)
    (hsv : sv.length = 3)
    (h18 : x18 = BitVec.ofNat 64 (64 * b))
    (h23 : x23 = BitVec.ofNat 64 (8 * (total msg.length - 1 - 64 * b)))
    (he : ((x18 + 64#64).ult (BitVec.ofNat 64 (total msg.length)) = false ∧ e = 0x105e4#64) ∨
      ((x18 + 64#64).ult (BitVec.ofNat 64 (total msg.length)) = true ∧ e = 0x1055c#64)) :
    TripleT program
      (Atoms.interp [.pc 0x1055c#64, .reg ra x1, .reg sp 0x10d70#64, .reg a0 x10, .reg a1 x11,
        .reg a2 x12, .reg a3 x13, .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17,
        .reg t0 x5, .reg t1 x6, .reg t2 x7, .reg t3 x28, .reg t4 x29, .reg t5 x30, .reg t6 x31,
        .reg s0 (BitVec.ofNat 64 msg.length), .reg s1 (BitVec.ofNat 64 (total msg.length)),
        .reg s2 x18, .reg s3 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg s4 (BitVec.ofNat 64 (8 * msg.length)), .reg s5 0x10e48#64, .reg s6 0x10d90#64,
        .reg s7 x23, .reg s8 16#64, .prop (bytesAt 0x10e48#64 msg),
        .prop (cellsAt 4 true 0x10d90#64 ms), .prop (cellsAt 4 true 0x10dd0#64 (w32s H)),
        .prop (cellsAt 4 true 0x10368#64 (w32s K)),
        .prop (cellsAt 4 true 0x10c38#64 fvs), .prop (cellsAt 4 true 0x10c58#64 fws),
        .prop (cellsAt 8 true 0x10d58#64 sv)]) t
      (Atoms.interp [.pc e, .reg ra 0x10550#64, .reg sp 0x10d70#64, .prop (regAny a0),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4),
        .prop (regAny a5), .prop (regAny a6), .prop (regAny a7), .prop (regAny t0),
        .prop (regAny t1), .prop (regAny t2), .prop (regAny t3), .prop (regAny t4),
        .prop (regAny t5), .prop (regAny t6),
        .reg s0 (BitVec.ofNat 64 msg.length), .reg s1 (BitVec.ofNat 64 (total msg.length)),
        .reg s2 (x18 + 64#64), .reg s3 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg s4 (BitVec.ofNat 64 (8 * msg.length)), .reg s5 0x10e48#64, .reg s6 0x10d90#64,
        .reg s7 (x23 - 512#64), .reg s8 16#64, .prop (bytesAt 0x10e48#64 msg),
        .prop (cellsAt 4 true 0x10d90#64 (w32s (block msg b))),
        .prop (cellsAt 4 true 0x10dd0#64 (w32s (compress H (block msg b)))),
        .prop (cellsAt 4 true 0x10368#64 (w32s K)),
        .prop (cellsAt 4 true 0x10c38#64
          (w32s (rounds (schedule (block msg b)) (Vars.ofList H) 64).toList)),
        .prop (cellsAt 4 true 0x10c58#64 (w32s (schedule (block msg b)))),
        .prop (cellsAt 8 true 0x10d58#64
          [x18, BitVec.ofNat 64 (total msg.length), BitVec.ofNat 64 msg.length])])
      (t ++ blockLeak msg.length b e) := by
  obtain ⟨c, rest, rfl⟩ : ∃ c rest, ms = c :: rest := by
    cases ms with
    | nil => simp at hms
    | cons c rest => exact ⟨c, rest, rfl⟩
  simp only [List.length_cons] at hms
  braid_sym_run_to 0x10588
  have e0 : (Atom.prop (cellsAt 4 true 0x10d90#64
      (w32s ((List.range 0).map (blockWord msg b))))).interp = Atoms.interp [] := rfl
  braid_fold e0
  braid_call words_loop msg b (x18 + 4#64) hn hb (by rw [h18]; bv_omega) rest 0 c 0#64 x18 x23
    _ _ _ _ _ _ 0x10d90#64 _ (by omega) rfl (by simpa using h18) (by simpa using h23)
    (by simp)
  have hr : rest.length = 15 := by omega
  rw [hr]
  braid_name_reg 10
  braid_name_reg 12
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  braid_name_reg 16
  braid_name_reg 17
  braid_name_reg 5
  braid_name_reg 6
  braid_sym_run_to 0x10160
  braid_call compress_call 0x10dd0#64 0x10d90#64 0x10d70#64 0x10550#64
    (BitVec.ofNat 64 msg.length) (BitVec.ofNat 64 (total msg.length)) x18 H (block msg b)
    true true fvs fws sv _ _ _ _ _ _ _ _ _ _ _ _ _ hH (block_length msg b) hfv hfw hsv
    (by decide) (by decide) (by decide) (by decide +kernel) _
  braid_sym_run_to 0x10558
  braid_sym_step
  all_goals
    braid_forget 10
    rcases he with h | h
    all_goals
      obtain ⟨h1, h2⟩ := h
      subst h2
      first
        | (rw [h1] at hbr; exact absurd hbr (by decide))
        | (simp only [blockLeak]; braid_done)

/-! ## The loop over the blocks -/

/-- What the blocks from block `b` on reveal, `r + 1` of them. -/
def blocksLeak (n : Nat) (b : Nat) : Nat → Trace
  | 0 => blockLeak n b 0x105e4#64
  | r + 1 => blockLeak n b 0x1055c#64 ++ blocksLeak n (b + 1) r

/-- The compression of a hash value of eight words is eight words. -/
theorem compress_length (H M : List W32) (h : H.length = 8) : (compress H M).length = 8 := by
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ := eq_of_length_8 h
  rfl

theorem ult_false {a b : Word} (h : b.toNat ≤ a.toNat) : a.ult b = false := by
  rw [← Bool.not_eq_true, BitVec.ult_iff_lt]
  bv_omega

theorem ult_true {a b : Word} (h : a.toNat < b.toNat) : a.ult b = true := by
  rw [BitVec.ult_iff_lt]
  bv_omega

/-- Forget what the loop over the blocks leaves behind, but for the hash value. -/
local macro "blocks_forget" : tactic =>
  `(tactic| (braid_forget 1; braid_forget 8; braid_forget 9; braid_forget 18; braid_forget 19
             braid_forget 20; braid_forget 21; braid_forget 22; braid_forget 23
             braid_forget 24
             braid_forget_cells 0x10d90#64, 16, (by simp)
             braid_forget_cells 0x10c38#64, 8, (by simp [Vars.toList])
             braid_forget_cells 0x10c58#64, 64,
               (by rw [w32s_length]; exact schedule_length _ (block_length _ _))
             braid_forget_cells 0x10d58#64, 3, rfl))

/-- **The loop over the blocks.** From block `b` on, with the hash value `H` so far, the
loop pads each block of the message and compresses it into the hash value, and reveals
`blocksLeak`. -/
theorem blocks_loop (msg : List (BitVec 8)) (hn : msg.length < 2 ^ 32) :
    ∀ (r b : Nat) (H : List W32) (ms fvs fws sv : List Word)
      (x1 x10 x11 x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 x18 x23 : Word) (t : Trace),
      64 * (b + r + 1) = total msg.length → H.length = 8 → ms.length = 16 → fvs.length = 8 →
      fws.length = 64 → sv.length = 3 → x18 = BitVec.ofNat 64 (64 * b) →
      x23 = BitVec.ofNat 64 (8 * (total msg.length - 1 - 64 * b)) →
    TripleT program
      (Atoms.interp [.pc 0x1055c#64, .reg ra x1, .reg sp 0x10d70#64, .reg a0 x10, .reg a1 x11,
        .reg a2 x12, .reg a3 x13, .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17,
        .reg t0 x5, .reg t1 x6, .reg t2 x7, .reg t3 x28, .reg t4 x29, .reg t5 x30, .reg t6 x31,
        .reg s0 (BitVec.ofNat 64 msg.length), .reg s1 (BitVec.ofNat 64 (total msg.length)),
        .reg s2 x18, .reg s3 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg s4 (BitVec.ofNat 64 (8 * msg.length)), .reg s5 0x10e48#64, .reg s6 0x10d90#64,
        .reg s7 x23, .reg s8 16#64, .prop (bytesAt 0x10e48#64 msg),
        .prop (cellsAt 4 true 0x10d90#64 ms), .prop (cellsAt 4 true 0x10dd0#64 (w32s H)),
        .prop (cellsAt 4 true 0x10368#64 (w32s K)),
        .prop (cellsAt 4 true 0x10c38#64 fvs), .prop (cellsAt 4 true 0x10c58#64 fws),
        .prop (cellsAt 8 true 0x10d58#64 sv)]) t
      (Atoms.interp [.pc 0x105e4#64, .prop (regAny ra), .reg sp 0x10d70#64, .prop (regAny a0),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4),
        .prop (regAny a5), .prop (regAny a6), .prop (regAny a7), .prop (regAny t0),
        .prop (regAny t1), .prop (regAny t2), .prop (regAny t3), .prop (regAny t4),
        .prop (regAny t5), .prop (regAny t6), .prop (regAny s0), .prop (regAny s1),
        .prop (regAny s2), .prop (regAny s3), .prop (regAny s4), .prop (regAny s5),
        .prop (regAny s6), .prop (regAny s7), .prop (regAny s8),
        .prop (bytesAt 0x10e48#64 msg), .prop (cellsAny 4 true 0x10d90#64 16),
        .prop (cellsAt 4 true 0x10dd0#64
          (w32s (((List.range' b (r + 1)).map (block msg)).foldl compress H))),
        .prop (cellsAt 4 true 0x10368#64 (w32s K)),
        .prop (cellsAny 4 true 0x10c38#64 8), .prop (cellsAny 4 true 0x10c58#64 64),
        .prop (cellsAny 8 true 0x10d58#64 3)])
      (t ++ blocksLeak msg.length b r) := by
  have hT := total_lt msg.length
  intro r
  induction r with
  | zero =>
    intro b H ms fvs fws sv x1 x10 x11 x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 x18 x23
      t hb hH hms hfv hfw hsv h18 h23
    braid_call block_step msg b H ms fvs fws sv x1 x10 x11 x12 x13 x14 x15 x16 x17 x5 x6 x7
      x28 x29 x30 x31 x18 x23 0x105e4#64 _ hn (by omega) hH hms hfv hfw hsv h18 h23
      (.inl ⟨ult_false (by rw [h18]; bv_omega), rfl⟩)
    blocks_forget
    braid_done
  | succ r ih =>
    intro b H ms fvs fws sv x1 x10 x11 x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 x18 x23
      t hb hH hms hfv hfw hsv h18 h23
    braid_call block_step msg b H ms fvs fws sv x1 x10 x11 x12 x13 x14 x15 x16 x17 x5 x6 x7
      x28 x29 x30 x31 x18 x23 0x1055c#64 _ hn (by omega) hH hms hfv hfw hsv h18 h23
      (.inr ⟨ult_true (by rw [h18]; bv_omega), rfl⟩)
    braid_name_reg 10
    braid_name_reg 11
    braid_name_reg 12
    braid_name_reg 13
    braid_name_reg 14
    braid_name_reg 15
    braid_name_reg 16
    braid_name_reg 17
    braid_name_reg 5
    braid_name_reg 6
    braid_name_reg 7
    braid_name_reg 28
    braid_name_reg 29
    braid_name_reg 30
    braid_name_reg 31
    braid_call ih (b + 1) (compress H (block msg b)) (w32s (block msg b))
      (w32s (rounds (schedule (block msg b)) (Vars.ofList H) 64).toList)
      (w32s (schedule (block msg b)))
      [x18, BitVec.ofNat 64 (total msg.length), BitVec.ofNat 64 msg.length]
      0x10550#64 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (x18 + 64#64) (x23 - 512#64) _
      (by omega) (compress_length _ _ hH) (by simp) (by simp [Vars.toList])
      (by rw [w32s_length]; exact schedule_length _ (block_length _ _)) rfl
      (by rw [h18]; bv_omega) (by rw [h23]; bv_omega)
    rw [List.range'_succ (s := b) (n := r + 1), List.map_cons, List.foldl_cons]
    braid_done

end Examples.Sha256Main.RiscV
