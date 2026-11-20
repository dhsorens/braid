/-
  Examples.Sha256Main.Arm.Blocks

  The loop of `main` over the blocks of the padded message, on AArch64: each turn pads a
  block (`words_loop`, proved about the program's own code and carried to the whole program
  with `own_le`) and calls the compression function on it (`compress_call`, which is the
  specification and the leakage of `sha256_compress` as they are proved about the binary of
  `sha256.c`).

  ## Main definitions

  * `blockLeak`, `blocksLeak`: what one block and all the blocks reveal

  ## Main results

  * `block_step`: one block, padded and compressed into the hash value
  * `blocks_loop`: the blocks from block `b` on
-/

module

public import Examples.Sha256Main.Arm.Program
public import Examples.Sha256Main.Arm.Pad

@[expose] public section

namespace Examples.Sha256Main.Arm

open Braid Examples Examples.Sha256 Lowering.Arm Lowering.Arm.Regs

/-- What block `b` reveals: its sixteen words, what the compression function reveals when it
is called with its arguments, and where the loop goes on, `e`. -/
def blockLeak (n b : Nat) (e : Word) : Trace :=
  wordsLeak n b 0 15 ++
    Sha256.Arm.compressLeak 0x20c70#64 0x20c30#64 0x20c10#64 0x203e8#64 ++ [.jump e]

theorem block_step (msg : List (BitVec 8)) (b : Nat) (H : List W32) (ms fvs fws : List Word)
    (sv v0 v1 v2 v3 v4 v5 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v21 v25 v30 e : Word)
    (fn fz fc fv : Bool) (t : Trace)
    (hn : msg.length < 2 ^ 32) (hb : 64 * b + 64 ≤ total msg.length)
    (hH : H.length = 8) (hms : ms.length = 16) (hfv : fvs.length = 8) (hfw : fws.length = 64)
    (h21 : v21 = BitVec.ofNat 64 (64 * b))
    (h25 : v25 = BitVec.ofNat 64 (8 * (total msg.length - 1 - 64 * b)))
    (he : ((BitVec.ofNat 64 (total msg.length)).ule (v21 + 64#64) = true ∧ e = 0x20480#64) ∨
      ((BitVec.ofNat 64 (total msg.length)).ule (v21 + 64#64) = false ∧ e = 0x203f8#64)) :
    TripleT program
      (Atoms.interp [.pc 0x203f8#64, .reg x0 v0, .reg x1 v1, .reg x2 v2, .reg x3 v3,
        .reg x4 v4, .reg x5 v5, .reg x8 v8, .reg x9 v9, .reg x10 v10, .reg x11 v11,
        .reg x12 v12, .reg x13 v13, .reg x14 v14, .reg x15 v15, .reg x16 v16, .reg x17 v17,
        .reg x18 v18, .reg x19 (BitVec.ofNat 64 msg.length),
        .reg x20 (BitVec.ofNat 64 (total msg.length)), .reg x21 v21,
        .reg x22 (BitVec.ofNat 64 (8 * msg.length)), .reg x23 0x20ce8#64,
        .reg x24 (BitVec.ofNat 64 (total msg.length - 8)), .reg x25 v25, .reg x26 0x20c30#64,
        .reg x29 0x20c90#64, .reg lr v30, .reg sp 0x20c10#64,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (bytesW false 0x20ce8#64 msg),
        .prop (cellsAt 4 true 0x20c30#64 ms), .prop (cellsAt 4 true 0x20c70#64 (w32s H)),
        .prop (cellsAt 4 false 0x20228#64 (w32s K)),
        .prop (cellsAt 4 true 0x20ae0#64 fvs), .prop (cellsAt 4 true 0x20b00#64 fws),
        .prop (cellsAt 8 true 0x20c00#64 [sv])]) t
      (Atoms.interp [.pc e, .prop (regAny x0), .prop (regAny x1), .prop (regAny x2),
        .prop (regAny x3), .prop (regAny x4), .prop (regAny x5), .prop (regAny x8),
        .prop (regAny x9), .prop (regAny x10), .prop (regAny x11), .prop (regAny x12),
        .prop (regAny x13), .prop (regAny x14), .prop (regAny x15), .prop (regAny x16),
        .prop (regAny x17), .prop (regAny x18), .reg x19 (BitVec.ofNat 64 msg.length),
        .reg x20 (BitVec.ofNat 64 (total msg.length)), .reg x21 (v21 + 64#64),
        .reg x22 (BitVec.ofNat 64 (8 * msg.length)), .reg x23 0x20ce8#64,
        .reg x24 (BitVec.ofNat 64 (total msg.length - 8)), .reg x25 (v25 - 512#64),
        .reg x26 0x20c30#64, .reg x29 0x20c90#64, .reg lr 0x203e8#64, .reg sp 0x20c10#64,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v), .prop (bytesW false 0x20ce8#64 msg),
        .prop (cellsAt 4 true 0x20c30#64 (w32s (block msg b))),
        .prop (cellsAt 4 true 0x20c70#64 (w32s (compress H (block msg b)))),
        .prop (cellsAt 4 false 0x20228#64 (w32s K)),
        .prop (cellsAt 4 true 0x20ae0#64
          (w32s (rounds (schedule (block msg b)) (Vars.ofList H) 64).toList)),
        .prop (cellsAt 4 true 0x20b00#64 (w32s (schedule (block msg b)))),
        .prop (cellsAt 8 true 0x20c00#64 [0x20c90#64])])
      (t ++ blockLeak msg.length b e) := by
  obtain ⟨c, rest, rfl⟩ : ∃ c rest, ms = c :: rest := by
    cases ms with
    | nil => simp at hms
    | cons c rest => exact ⟨c, rest, rfl⟩
  simp only [List.length_cons] at hms
  braid_sym_run_to 0x20420
  have e0 : (Atom.prop (cellsAt 4 true 0x20c30#64
      (w32s ((List.range 0).map (blockWord msg b))))).interp = Atoms.interp [] := rfl
  braid_fold e0
  braid_call (words_loop msg b hn hb rest 0 c 0#64 v21 v25 _ _ _ _ _ 0x20c30#64 _ _ _ _ _
    (by omega) rfl (by simpa using h21) (by simpa using h25) (by simp)).mono own_le
  have hr : rest.length = 15 := by omega
  rw [hr]
  braid_name_reg 8
  braid_name_reg 9
  braid_name_reg 10
  braid_name_reg 11
  braid_name_reg 12
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  braid_name_flag 0
  braid_name_flag 1
  braid_name_flag 2
  braid_name_flag 3
  braid_sym_run_to 0x100bc
  braid_call compress_call 0x20c70#64 0x20c30#64 0x20c10#64 0x203e8#64 0x20c90#64 sv H
    (block msg b) true fvs fws _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ hH (block_length msg b)
    hfv hfw (by decide) (by decide +kernel) _
  braid_sym_run_to 0x203f4
  braid_sym_step
  all_goals
    braid_forget 0
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
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
  | 0 => blockLeak n b 0x20480#64
  | r + 1 => blockLeak n b 0x203f8#64 ++ blocksLeak n (b + 1) r

/-- Forget what the loop over the blocks leaves behind, but for the hash value. -/
local macro "blocks_forget" : tactic =>
  `(tactic| (braid_forget 19; braid_forget 20; braid_forget 21; braid_forget 22
             braid_forget 23; braid_forget 24; braid_forget 25; braid_forget 26
             braid_forget 30
             braid_forget_cells 0x20c30#64, 16, (by simp)
             braid_forget_cells 0x20ae0#64, 8, (by simp [Vars.toList])
             braid_forget_cells 0x20b00#64, 64,
               (by rw [w32s_length]; exact schedule_length _ (block_length _ _))
             braid_forget_cells 0x20c00#64, 1, rfl))

/-- Name what a block leaves in the registers it clobbers and the flags. -/
local macro "block_name" : tactic =>
  `(tactic| (braid_name_reg 0; braid_name_reg 1; braid_name_reg 2; braid_name_reg 3
             braid_name_reg 4; braid_name_reg 5; braid_name_reg 8; braid_name_reg 9
             braid_name_reg 10; braid_name_reg 11; braid_name_reg 12; braid_name_reg 13
             braid_name_reg 14; braid_name_reg 15; braid_name_reg 16; braid_name_reg 17
             braid_name_reg 18; braid_name_flag 0; braid_name_flag 1; braid_name_flag 2
             braid_name_flag 3))

/-- **The loop over the blocks.** From block `b` on, with the hash value `H` so far, the
loop pads each block of the message and compresses it into the hash value, and reveals
`blocksLeak`. -/
theorem blocks_loop (msg : List (BitVec 8)) (hn : msg.length < 2 ^ 32) :
    ∀ (r b : Nat) (H : List W32) (ms fvs fws : List Word)
      (sv v0 v1 v2 v3 v4 v5 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v21 v25 v30 : Word)
      (fn fz fc fv : Bool) (t : Trace),
      64 * (b + r + 1) = total msg.length → H.length = 8 → ms.length = 16 → fvs.length = 8 →
      fws.length = 64 → v21 = BitVec.ofNat 64 (64 * b) →
      v25 = BitVec.ofNat 64 (8 * (total msg.length - 1 - 64 * b)) →
    TripleT program
      (Atoms.interp [.pc 0x203f8#64, .reg x0 v0, .reg x1 v1, .reg x2 v2, .reg x3 v3,
        .reg x4 v4, .reg x5 v5, .reg x8 v8, .reg x9 v9, .reg x10 v10, .reg x11 v11,
        .reg x12 v12, .reg x13 v13, .reg x14 v14, .reg x15 v15, .reg x16 v16, .reg x17 v17,
        .reg x18 v18, .reg x19 (BitVec.ofNat 64 msg.length),
        .reg x20 (BitVec.ofNat 64 (total msg.length)), .reg x21 v21,
        .reg x22 (BitVec.ofNat 64 (8 * msg.length)), .reg x23 0x20ce8#64,
        .reg x24 (BitVec.ofNat 64 (total msg.length - 8)), .reg x25 v25, .reg x26 0x20c30#64,
        .reg x29 0x20c90#64, .reg lr v30, .reg sp 0x20c10#64,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (bytesW false 0x20ce8#64 msg),
        .prop (cellsAt 4 true 0x20c30#64 ms), .prop (cellsAt 4 true 0x20c70#64 (w32s H)),
        .prop (cellsAt 4 false 0x20228#64 (w32s K)),
        .prop (cellsAt 4 true 0x20ae0#64 fvs), .prop (cellsAt 4 true 0x20b00#64 fws),
        .prop (cellsAt 8 true 0x20c00#64 [sv])]) t
      (Atoms.interp [.pc 0x20480#64, .prop (regAny x0), .prop (regAny x1), .prop (regAny x2),
        .prop (regAny x3), .prop (regAny x4), .prop (regAny x5), .prop (regAny x8),
        .prop (regAny x9), .prop (regAny x10), .prop (regAny x11), .prop (regAny x12),
        .prop (regAny x13), .prop (regAny x14), .prop (regAny x15), .prop (regAny x16),
        .prop (regAny x17), .prop (regAny x18), .prop (regAny x19), .prop (regAny x20),
        .prop (regAny x21), .prop (regAny x22), .prop (regAny x23), .prop (regAny x24),
        .prop (regAny x25), .prop (regAny x26), .reg x29 0x20c90#64, .prop (regAny lr),
        .reg sp 0x20c10#64,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v), .prop (bytesW false 0x20ce8#64 msg),
        .prop (cellsAny 4 true 0x20c30#64 16),
        .prop (cellsAt 4 true 0x20c70#64
          (w32s (((List.range' b (r + 1)).map (block msg)).foldl compress H))),
        .prop (cellsAt 4 false 0x20228#64 (w32s K)),
        .prop (cellsAny 4 true 0x20ae0#64 8), .prop (cellsAny 4 true 0x20b00#64 64),
        .prop (cellsAny 8 true 0x20c00#64 1)])
      (t ++ blocksLeak msg.length b r) := by
  have hT := total_lt msg.length
  intro r
  induction r with
  | zero =>
    intro b H ms fvs fws sv v0 v1 v2 v3 v4 v5 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v21
      v25 v30 fn fz fc fv t hb hH hms hfv hfw h21 h25
    braid_call block_step msg b H ms fvs fws sv v0 v1 v2 v3 v4 v5 v8 v9 v10 v11 v12 v13 v14
      v15 v16 v17 v18 v21 v25 v30 0x20480#64 fn fz fc fv _ hn (by omega) hH hms hfv hfw h21
      h25 (.inl ⟨by rw [BitVec.ule_iff_le, h21]; bv_omega, rfl⟩)
    blocks_forget
    braid_done
  | succ r ih =>
    intro b H ms fvs fws sv v0 v1 v2 v3 v4 v5 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v21
      v25 v30 fn fz fc fv t hb hH hms hfv hfw h21 h25
    braid_call block_step msg b H ms fvs fws sv v0 v1 v2 v3 v4 v5 v8 v9 v10 v11 v12 v13 v14
      v15 v16 v17 v18 v21 v25 v30 0x203f8#64 fn fz fc fv _ hn (by omega) hH hms hfv hfw h21
      h25 (.inr ⟨by rw [← Bool.not_eq_true, BitVec.ule_iff_le, h21]; bv_omega, rfl⟩)
    block_name
    braid_call ih (b + 1) (compress H (block msg b)) (w32s (block msg b))
      (w32s (rounds (schedule (block msg b)) (Vars.ofList H) 64).toList)
      (w32s (schedule (block msg b))) 0x20c90#64
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (v21 + 64#64) (v25 - 512#64) 0x203e8#64 _ _ _ _ _
      (by omega) (compress_length _ _ hH) (by simp) (by simp [Vars.toList])
      (by rw [w32s_length]; exact schedule_length _ (block_length _ _))
      (by rw [h21]; bv_omega) (by rw [h25]; bv_omega)
    rw [List.range'_succ (s := b) (n := r + 1), List.map_cons, List.foldl_cons]
    braid_done

end Examples.Sha256Main.Arm
