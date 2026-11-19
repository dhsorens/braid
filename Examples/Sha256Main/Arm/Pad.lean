/-
  Examples.Sha256Main.Arm.Pad

  The loop of `main` that pads one block of the message, on AArch64. The C source computes
  each byte of the padded message from its index: a byte of the message, the byte `0x80`, a
  zero, or a byte of the length. The compiled code branches four ways on the index, which
  depends on the length of the message and not on its bytes. This file runs one byte, one
  word of four bytes, and the sixteen words of a block, each with what it reveals.

  ## Main definitions

  * `accByte`: a byte shifted into the low half of a register
  * `byteLeak`, `wordLeak`, `wordsLeak`: what a byte, a word and the words of a block reveal

  ## Main results

  * `byte_step`: one byte of the padded message, shifted into the word
  * `word_step`: one word, stored in the block
  * `words_loop`: the sixteen words of block `b`
-/

module

public import Examples.Sha256Main.Arm.Program

@[expose] public section

namespace Examples.Sha256Main.Arm

open Braid Examples Examples.Sha256 Lowering.Arm Lowering.Arm.Regs

/-- The low half of a register after the byte `b` is shifted into it from below: what
`orr w11, w15, w11, lsl #8` leaves. -/
def accByte (b : BitVec 8) (v : Word) : Word :=
  BitVec.setWidth 64 (BitVec.setWidth 32 (b.setWidth 64)) |||
    BitVec.setWidth 64 (BitVec.setWidth 32 (v <<< 8#64))

/-- A byte of a word, as the code takes it: shifted down by a register, and masked in the
low half of a register. -/
theorem lsr_byte (v : Word) (m : Nat) (hm : m < 64) :
    BitVec.setWidth 64 (BitVec.setWidth 32 (v >>> (BitVec.ofNat 64 m &&& 63#64))) &&& 255#64 =
      ((v >>> m).setWidth 8).setWidth 64 := by
  have e : BitVec.ofNat 64 m &&& 63#64 = BitVec.ofNat 64 m := by
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_and, BitVec.toNat_ofNat, show (63#64).toNat = 2 ^ 6 - 1 from rfl,
      Nat.and_two_pow_sub_one_eq_mod]
    omega
  have e' : v >>> BitVec.ofNat 64 m = v >>> m := by
    rw [BitVec.ushiftRight_eq', BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  rw [e, e']
  generalize v >>> m = x
  bv_decide

/-- Close a goal that contradicts a comparison the code made. -/
local macro "cmp_omega " h:ident : tactic =>
  `(tactic| (exfalso
             first
               | rw [BitVec.ule_iff_le] at $h:ident
               | rw [← Bool.not_eq_true, BitVec.ule_iff_le] at $h:ident
               | skip
             bv_omega))

/-- The end of a byte step: the branch back, either way. -/
local macro "byte_done " he:ident hbr:ident : tactic =>
  `(tactic| (braid_forget 15
             braid_forget_flag 0
             braid_forget_flag 1
             braid_forget_flag 2
             braid_forget_flag 3
             rcases $he:ident with h | h
             all_goals
               obtain ⟨h1, h2⟩ := h
               subst h2
               first | exact absurd $hbr h1 | exact absurd h1 $hbr | braid_done))

/-- What one byte of the padding loop reveals: which of the four kinds of byte it is, by the
branches taken, for a byte of the message its address, and where the loop goes on, `e`. -/
def byteLeak (n k : Nat) (e : Word) : Trace :=
  (if k < n then [.jump 0x20434#64, .read (0x20ce8#64 + BitVec.ofNat 64 k) 1]
  else if k = n then [.jump 0x20454#64, .jump 0x2045c#64]
  else if total n - 8 ≤ k then [.jump 0x20454#64, .jump 0x20464#64, .jump 0x20474#64]
  else [.jump 0x20454#64, .jump 0x20464#64, .jump 0x2046c#64]) ++ [.jump e]

theorem byte_step (msg : List (BitVec 8)) (k : Nat) (v11 v12 v13 v14 v15 e : Word)
    (fn fz fc fv : Bool) (t : Trace) (hn : msg.length < 2 ^ 32) (hk : k < total msg.length)
    (h13 : v13 = BitVec.ofNat 64 k)
    (h14 : v14 = BitVec.ofNat 64 (8 * (total msg.length - 1 - k)))
    (he : (v12 + 8#64 = 0#64 ∧ e = 0x20408#64) ∨ (v12 + 8#64 ≠ 0#64 ∧ e = 0x2044c#64)) :
    TripleT program
      (Atoms.interp [.pc 0x2044c#64, .reg x11 v11, .reg x12 v12, .reg x13 v13, .reg x14 v14,
        .reg x15 v15, .reg x19 (BitVec.ofNat 64 msg.length),
        .reg x22 (BitVec.ofNat 64 (8 * msg.length)), .reg x23 0x20ce8#64,
        .reg x24 (BitVec.ofNat 64 (total msg.length - 8)),
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (bytesW false 0x20ce8#64 msg)]) t
      (Atoms.interp [.pc e, .reg x11 (accByte (padByte msg k) v11), .reg x12 (v12 + 8#64),
        .reg x13 (v13 + 1#64), .reg x14 (v14 - 8#64), .prop (regAny x15),
        .reg x19 (BitVec.ofNat 64 msg.length),
        .reg x22 (BitVec.ofNat 64 (8 * msg.length)), .reg x23 0x20ce8#64,
        .reg x24 (BitVec.ofNat 64 (total msg.length - 8)),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v), .prop (bytesW false 0x20ce8#64 msg)])
      (t ++ byteLeak msg.length k e) := by
  have hT := le_total msg.length
  have hT' := total_lt msg.length
  subst h13
  simp only [accByte]
  by_cases h1 : k < msg.length
  · rw [padByte_lt msg k h1]
    simp only [byteLeak, h1, ↓reduceIte]
    braid_unfold bytesW_index 0x20ce8#64 msg k h1
    braid_sym_step
    braid_sym_step
    · braid_sym_step
      braid_sym_run_to 0x20448
      braid_sym_step
      all_goals
        braid_fold bytesW_index 0x20ce8#64 msg k h1
        byte_done he hbr
    · cmp_omega hbr
  · by_cases h2 : k = msg.length
    · subst h2
      rw [padByte_eq]
      simp only [byteLeak, h1, ↓reduceIte]
      braid_sym_step
      braid_sym_step
      · cmp_omega hbr
      · braid_sym_step
        braid_sym_step
        braid_sym_step
        braid_sym_step
        braid_sym_run_to 0x20448
        braid_sym_step
        all_goals byte_done he hbr
    · by_cases h3 : total msg.length - 8 ≤ k
      · rw [padByte_len msg k (by omega) h3 hk, ← lsr_byte _ _ (by omega)]
        simp only [byteLeak, h1, h2, h3, ↓reduceIte]
        subst h14
        braid_sym_step
        braid_sym_step
        · cmp_omega hbr
        · braid_sym_step
          braid_sym_step
          · braid_sym_step
            braid_sym_step
            · braid_sym_run_to 0x20448
              braid_sym_step
              all_goals byte_done he hbr
            · cmp_omega hbr
          · cmp_omega hbr
      · rw [padByte_zero msg k (by omega) (by omega)]
        simp only [byteLeak, h1, h2, h3, ↓reduceIte]
        braid_sym_step
        braid_sym_step
        · cmp_omega hbr
        · braid_sym_step
          braid_sym_step
          · braid_sym_step
            braid_sym_step
            · cmp_omega hbr
            · braid_sym_run_to 0x20448
              braid_sym_step
              all_goals byte_done he hbr
          · cmp_omega hbr

/-! ## One word -/

/-- Four bytes shifted into a register one after another are their big-endian word. -/
theorem be32_acc (msg : List (BitVec 8)) (b j : Nat) :
    accByte (padByte msg (64 * b + 4 * j + 3)) (accByte (padByte msg (64 * b + 4 * j + 2))
      (accByte (padByte msg (64 * b + 4 * j + 1)) (accByte (padByte msg (64 * b + 4 * j)) 0#64))) =
      (blockWord msg b j).setWidth 64 := by
  simp only [blockWord, be32, accByte]
  generalize padByte msg (64 * b + 4 * j + 3) = d
  generalize padByte msg (64 * b + 4 * j + 2) = c
  generalize padByte msg (64 * b + 4 * j + 1) = b'
  generalize padByte msg (64 * b + 4 * j) = a
  bv_decide

/-- Name what a byte step leaves in the scratch register and the flags. -/
local macro "byte_name" : tactic =>
  `(tactic| (braid_name_reg 15; braid_name_flag 0; braid_name_flag 1; braid_name_flag 2
             braid_name_flag 3))

/-- What the four bytes of word `j` of block `b` reveal, the store of the word, and where
the loop goes on, `e`. -/
def wordLeak (n b j : Nat) (e : Word) : Trace :=
  byteLeak n (64 * b + 4 * j) 0x2044c#64 ++ byteLeak n (64 * b + 4 * j + 1) 0x2044c#64 ++
  byteLeak n (64 * b + 4 * j + 2) 0x2044c#64 ++ byteLeak n (64 * b + 4 * j + 3) 0x20408#64 ++
  [.write (0x20c30#64 + BitVec.ofNat 64 (4 * j)) 4, .jump e]

theorem word_step (msg : List (BitVec 8)) (b j : Nat) (v8 v9 v10 v11 v12 v13 v14 v15 q
    e : Word) (fn fz fc fv : Bool) (done rest : List Word) (c : Word)
    (t : Trace) (hn : msg.length < 2 ^ 32) (hb : 64 * b + 64 ≤ total msg.length) (hj : j < 16)
    (h8 : v8 = BitVec.ofNat 64 j) (h9 : v9 = BitVec.ofNat 64 (64 * b + 4 * j))
    (h10 : v10 = BitVec.ofNat 64 (8 * (total msg.length - 1 - (64 * b + 4 * j))))
    (hq : q = 0x20c30#64 + BitVec.ofNat 64 (4 * j)) (hd : done.length = j)
    (he : (v8 + 1#64 = 16#64 ∧ e = 0x203dc#64) ∨ (v8 + 1#64 ≠ 16#64 ∧ e = 0x20420#64)) :
    TripleT program
      (Atoms.interp [.pc 0x20420#64, .reg x8 v8, .reg x9 v9, .reg x10 v10, .reg x11 v11,
        .reg x12 v12, .reg x13 v13, .reg x14 v14, .reg x15 v15,
        .reg x19 (BitVec.ofNat 64 msg.length),
        .reg x22 (BitVec.ofNat 64 (8 * msg.length)), .reg x23 0x20ce8#64,
        .reg x24 (BitVec.ofNat 64 (total msg.length - 8)), .reg x26 0x20c30#64,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (bytesW false 0x20ce8#64 msg),
        .prop (cellsAt 4 true 0x20c30#64 done), .prop (cellsAt 4 true q (c :: rest))]) t
      (Atoms.interp [.pc e, .reg x8 (v8 + 1#64), .reg x9 (v9 + 4#64), .reg x10 (v10 - 32#64),
        .prop (regAny x11), .prop (regAny x12), .prop (regAny x13), .prop (regAny x14),
        .prop (regAny x15), .reg x19 (BitVec.ofNat 64 msg.length),
        .reg x22 (BitVec.ofNat 64 (8 * msg.length)), .reg x23 0x20ce8#64,
        .reg x24 (BitVec.ofNat 64 (total msg.length - 8)), .reg x26 0x20c30#64,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v), .prop (bytesW false 0x20ce8#64 msg),
        .prop (cellsAt 4 true 0x20c30#64 (done ++ [(blockWord msg b j).setWidth 64])),
        .prop (cellsAt 4 true (q + 4#64) rest)])
      (t ++ wordLeak msg.length b j e) := by
  have hT := le_total msg.length
  have hT' := total_lt msg.length
  simp only [wordLeak]
  rw [← hq]
  have hq' : q = 0x20c30#64 + v8 <<< 2#64 := by rw [hq, shl2, h8]; bv_omega
  subst hq'
  braid_sym_run_to 0x2044c
  braid_call byte_step msg (64 * b + 4 * j) 0#64 0xffffffffffffffe0#64 v9 v10 v15 0x2044c#64
    _ _ _ _ _ hn (by omega) h9 h10 (.inr ⟨by decide, rfl⟩)
  byte_name
  braid_call byte_step msg (64 * b + 4 * j + 1) _ 0xffffffffffffffe8#64 (v9 + 1#64)
    (v10 - 8#64) _ 0x2044c#64 _ _ _ _ _ hn (by omega) (by rw [h9]; bv_omega)
    (by rw [h10]; bv_omega) (.inr ⟨by decide, rfl⟩)
  byte_name
  braid_call byte_step msg (64 * b + 4 * j + 2) _ 0xfffffffffffffff0#64 (v9 + 2#64)
    (v10 - 16#64) _ 0x2044c#64 _ _ _ _ _ hn (by omega) (by rw [h9]; bv_omega)
    (by rw [h10]; bv_omega) (.inr ⟨by decide, rfl⟩)
  byte_name
  braid_call byte_step msg (64 * b + 4 * j + 3) _ 0xfffffffffffffff8#64 (v9 + 3#64)
    (v10 - 24#64) _ 0x20408#64 _ _ _ _ _ hn (by omega) (by rw [h9]; bv_omega)
    (by rw [h10]; bv_omega) (.inl ⟨by decide, rfl⟩)
  rw [be32_acc]
  braid_unfold cellsAt_cons (0x20c30#64 + v8 <<< 2#64) c rest
  braid_sym_run_to 0x2041c
  braid_sym_step
  all_goals
    braid_fold cellsAt_snoc 0x20c30#64 (0x20c30#64 + v8 <<< 2#64)
      ((blockWord msg b j).setWidth 64) done 4 true (by rw [hd, shl2, h8]; bv_omega)
    braid_forget 11
    braid_forget 12
    braid_forget 13
    braid_forget 14
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    rcases he with h | h
    all_goals
      obtain ⟨h1, h2⟩ := h
      subst h2
      first | exact absurd hbr h1 | exact absurd h1 hbr | braid_done

/-! ## The sixteen words of a block -/

/-- What the words of block `b` from word `j` on reveal, `r + 1` of them. -/
def wordsLeak (n b : Nat) (j : Nat) : Nat → Trace
  | 0 => wordLeak n b j 0x203dc#64
  | r + 1 => wordLeak n b j 0x20420#64 ++ wordsLeak n b (j + 1) r

/-- Name what a word step leaves in the scratch registers and the flags. -/
local macro "word_name" : tactic =>
  `(tactic| (braid_name_reg 11; braid_name_reg 12; braid_name_reg 13; braid_name_reg 14
             braid_name_reg 15; braid_name_flag 0; braid_name_flag 1; braid_name_flag 2
             braid_name_flag 3))

/-- **The loop that pads a block.** From word `j` on, the loop writes the words of block `b`
of the padded message to the sixteen cells at `0x20c30`, and reveals `wordsLeak`. -/
theorem words_loop (msg : List (BitVec 8)) (b : Nat)
    (hn : msg.length < 2 ^ 32) (hb : 64 * b + 64 ≤ total msg.length) :
    ∀ (rest : List Word) (j : Nat) (c : Word) (v8 v9 v10 v11 v12 v13 v14 v15 q : Word)
      (fn fz fc fv : Bool) (t : Trace), j + rest.length + 1 = 16 → v8 = BitVec.ofNat 64 j →
      v9 = BitVec.ofNat 64 (64 * b + 4 * j) →
      v10 = BitVec.ofNat 64 (8 * (total msg.length - 1 - (64 * b + 4 * j))) →
      q = 0x20c30#64 + BitVec.ofNat 64 (4 * j) →
    TripleT program
      (Atoms.interp [.pc 0x20420#64, .reg x8 v8, .reg x9 v9, .reg x10 v10, .reg x11 v11,
        .reg x12 v12, .reg x13 v13, .reg x14 v14, .reg x15 v15,
        .reg x19 (BitVec.ofNat 64 msg.length),
        .reg x22 (BitVec.ofNat 64 (8 * msg.length)), .reg x23 0x20ce8#64,
        .reg x24 (BitVec.ofNat 64 (total msg.length - 8)), .reg x26 0x20c30#64,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (bytesW false 0x20ce8#64 msg),
        .prop (cellsAt 4 true 0x20c30#64 (w32s ((List.range j).map (blockWord msg b)))),
        .prop (cellsAt 4 true q (c :: rest))]) t
      (Atoms.interp [.pc 0x203dc#64, .prop (regAny x8), .prop (regAny x9), .prop (regAny x10),
        .prop (regAny x11), .prop (regAny x12), .prop (regAny x13), .prop (regAny x14),
        .prop (regAny x15), .reg x19 (BitVec.ofNat 64 msg.length),
        .reg x22 (BitVec.ofNat 64 (8 * msg.length)), .reg x23 0x20ce8#64,
        .reg x24 (BitVec.ofNat 64 (total msg.length - 8)), .reg x26 0x20c30#64,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v), .prop (bytesW false 0x20ce8#64 msg),
        .prop (cellsAt 4 true 0x20c30#64 (w32s (block msg b)))])
      (t ++ wordsLeak msg.length b j rest.length) := by
  intro rest
  induction rest with
  | nil =>
    intro j c v8 v9 v10 v11 v12 v13 v14 v15 q fn fz fc fv t hj h8 h9 h10 hq
    have hj' : j = 15 := by simpa using hj
    subst hj'
    braid_call word_step msg b 15 v8 v9 v10 v11 v12 v13 v14 v15 q 0x203dc#64 fn fz fc fv
      (w32s ((List.range 15).map (blockWord msg b))) [] c _ hn hb (by omega) h8 h9 h10 hq
      (by simp) (.inl ⟨by rw [h8]; rfl, rfl⟩)
    rw [w32s_range_succ]
    braid_unfold cellsAt_nil (k := 4) (w := true) (q + 4#64)
    braid_forget 8
    braid_forget 9
    braid_forget 10
    braid_done
  | cons c' rest ih =>
    intro j c v8 v9 v10 v11 v12 v13 v14 v15 q fn fz fc fv t hj h8 h9 h10 hq
    simp only [List.length_cons] at hj
    have hT := total_lt msg.length
    braid_call word_step msg b j v8 v9 v10 v11 v12 v13 v14 v15 q 0x20420#64 fn fz fc fv
      (w32s ((List.range j).map (blockWord msg b))) (c' :: rest) c _ hn hb (by omega) h8 h9
      h10 hq (by simp) (.inr ⟨by rw [h8]; bv_omega, rfl⟩)
    rw [w32s_range_succ]
    word_name
    braid_call ih (j + 1) c' (v8 + 1#64) (v9 + 4#64) (v10 - 32#64) _ _ _ _ _ (q + 4#64)
      _ _ _ _ _ (by omega) (by rw [h8]; bv_omega) (by rw [h9]; bv_omega)
      (by rw [h10]; bv_omega) (by rw [hq]; bv_omega)
    braid_done

end Examples.Sha256Main.Arm
