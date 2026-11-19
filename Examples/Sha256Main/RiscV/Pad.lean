/-
  Examples.Sha256Main.RiscV.Pad

  The loop of `main` that pads one block of the message, on RISC-V. The C source computes
  each byte of the padded message from its index: a byte of the message, the byte `0x80`, a
  zero, or a byte of the length. The compiled code branches four ways on the index, which
  depends on the length of the message and not on its bytes. This file runs one byte, one
  word of four bytes, and the sixteen words of a block, each with what it reveals.

  ## Main definitions

  * `byteLeak`, `wordLeak`, `wordsLeak`: what a byte, a word and the words of a block reveal

  ## Main results

  * `byte_step`: one byte of the padded message, shifted into the word
  * `word_step`: one word, stored in the block
  * `words_loop`: the sixteen words of block `b`
-/

module

public import Examples.Sha256Main.RiscV.Program

@[expose] public section

namespace Examples.Sha256Main.RiscV

open Braid Examples Examples.Sha256 Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- An array of bytes, opened at index `i`. -/
theorem bytesAt_index (p : Word) (bs : List (BitVec 8)) (i : Nat) (hi : i < bs.length) :
    (Atom.prop (bytesAt p bs)).interp =
      Atoms.interp [.prop (bytesAt p (bs.take i)),
        .mem (p + BitVec.ofNat 64 i) 1 ((bs.getD i 0#8).zeroExtend 64) true,
        .prop (bytesAt (p + BitVec.ofNat 64 i + 1#64) (bs.drop (i + 1)))] := by
  rw [bytesAt_split p bs i (Nat.le_of_lt hi)]
  have hd : bs.drop i = bs.getD i 0#8 :: bs.drop (i + 1) := by
    rw [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hi]
    exact List.drop_eq_getElem_cons hi
  simp only [Atoms.interp_cons, Atoms.interp_nil, Atom.interp, hd, bytesAt]
  exact SProp.ext ⟨Iris.BI.sep_mono_right Iris.BI.sep_assoc.1,
    Iris.BI.sep_mono_right Iris.BI.sep_assoc.2⟩

/-- A byte of a word, as the code takes it: shifted down by a register and masked. -/
theorem srl_byte (v : Word) (m : Nat) (hm : m < 64) :
    v >>> (BitVec.ofNat 64 m &&& 63#64) &&& 255#64 = ((v >>> m).setWidth 8).setWidth 64 := by
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

/-- Close a goal that contradicts an unsigned comparison the code made. -/
local macro "ult_omega " h:ident : tactic =>
  `(tactic| (exfalso
             first
               | rw [BitVec.ult_iff_lt] at $h:ident
               | rw [← Bool.not_eq_true, BitVec.ult_iff_lt] at $h:ident
             bv_omega))

/-- The end of a byte step: the branch back, either way. -/
local macro "byte_done " he:ident hbr:ident : tactic =>
  `(tactic| (braid_forget 6
             rcases $he:ident with h | h
             all_goals
               obtain ⟨h1, h2⟩ := h
               subst h2
               first | exact absurd $hbr h1 | exact absurd h1 $hbr | braid_done))

/-- What one byte of the padding loop reveals: which of the four kinds of byte it is, by the
branches taken, for a byte of the message its address, and where the loop goes on, `e`. -/
def byteLeak (n k : Nat) (e : Word) : Trace :=
  (if k < n then [.jump 0x105a0#64, .read (0x10e48#64 + BitVec.ofNat 64 k) 1]
  else if k = n then [.jump 0x105c0#64, .jump 0x105c4#64]
  else if total n - 8 ≤ k then [.jump 0x105c0#64, .jump 0x105cc#64, .jump 0x105d8#64]
  else [.jump 0x105c0#64, .jump 0x105cc#64, .jump 0x105d0#64]) ++ [.jump e]

theorem byte_step (msg : List (BitVec 8)) (k : Nat) (x14 x16 x17 x5 x6 e : Word)
    (t : Trace) (hn : msg.length < 2 ^ 32) (hk : k < total msg.length)
    (h17 : x17 = BitVec.ofNat 64 k)
    (h5 : x5 = BitVec.ofNat 64 (8 * (total msg.length - 1 - k)))
    (he : (x17 + 1#64 = x16 ∧ e = 0x10570#64) ∨ (x17 + 1#64 ≠ x16 ∧ e = 0x105bc#64)) :
    TripleT program
      (Atoms.interp [.pc 0x105bc#64, .reg a4 x14, .reg a6 x16, .reg a7 x17, .reg t0 x5,
        .reg t1 x6, .reg s0 (BitVec.ofNat 64 msg.length),
        .reg s3 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg s4 (BitVec.ofNat 64 (8 * msg.length)), .reg s5 0x10e48#64,
        .prop (bytesAt 0x10e48#64 msg)]) t
      (Atoms.interp [.pc e, .reg a4 ((padByte msg k).setWidth 64 ||| x14 <<< 8#64),
        .reg a6 x16, .reg a7 (x17 + 1#64), .reg t0 (x5 - 8#64), .prop (regAny t1),
        .reg s0 (BitVec.ofNat 64 msg.length),
        .reg s3 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg s4 (BitVec.ofNat 64 (8 * msg.length)), .reg s5 0x10e48#64,
        .prop (bytesAt 0x10e48#64 msg)]) (t ++ byteLeak msg.length k e) := by
  have hT := le_total msg.length
  have hT' := total_lt msg.length
  subst h17
  by_cases h1 : k < msg.length
  · rw [padByte_lt msg k h1]
    simp only [byteLeak, h1, ↓reduceIte]
    braid_unfold bytesAt_index 0x10e48#64 msg k h1
    braid_sym_step
    · braid_sym_run_to 0x105b8
      braid_sym_step
      all_goals
        braid_fold bytesAt_index 0x10e48#64 msg k h1
        byte_done he hbr
    · ult_omega hbr
  · by_cases h2 : k = msg.length
    · subst h2
      rw [padByte_eq]
      simp only [byteLeak, h1, ↓reduceIte]
      braid_sym_step
      · ult_omega hbr
      · braid_sym_run_to 0x105b8
        braid_sym_step
        all_goals byte_done he hbr
    · by_cases h3 : total msg.length - 8 ≤ k
      · rw [padByte_len msg k (by omega) h3 hk, ← srl_byte _ _ (by omega)]
        simp only [byteLeak, h1, h2, h3, ↓reduceIte]
        subst h5
        braid_sym_step
        · ult_omega hbr
        · braid_sym_step
          · braid_sym_step
            · ult_omega hbr
            · braid_sym_run_to 0x105b8
              braid_sym_step
              all_goals byte_done he hbr
          · exfalso; bv_omega
      · rw [padByte_zero msg k (by omega) (by omega)]
        simp only [byteLeak, h1, h2, h3, ↓reduceIte]
        braid_sym_step
        · ult_omega hbr
        · braid_sym_step
          · braid_sym_step
            · braid_sym_run_to 0x105b8
              braid_sym_step
              all_goals byte_done he hbr
            · ult_omega hbr
          · exfalso; bv_omega

/-! ## One word -/

/-- An array with one more cell at its end, which is at `q`. -/
theorem cellsAt_snoc (p q v : Word) (xs : List Word) (k : Nat) (w : Bool)
    (hq : q = p + BitVec.ofNat 64 (k * xs.length)) :
    (Atom.prop (cellsAt k w p (xs ++ [v]))).interp =
      Atoms.interp [.prop (cellsAt k w p xs), .mem q k v w] := by
  subst hq
  have e : cellsAt k w (p + BitVec.ofNat 64 (k * xs.length)) [v] =
      memIs (p + BitVec.ofNat 64 (k * xs.length)) k v w :=
    SProp.ext ⟨Iris.BI.sep_emp.1, Iris.BI.sep_emp.2⟩
  rw [cellsAt_append, sep_interp_pair, e]
  rfl

/-- An index scaled by four, as the code computes it. -/
theorem shl2 (x : Word) : x <<< 2#64 = x * 4#64 := by bv_decide

/-- Four bytes shifted into a register one after another are their big-endian word. -/
theorem be32_bytes (msg : List (BitVec 8)) (b j : Nat) :
    (padByte msg (64 * b + 4 * j + 3)).setWidth 64 |||
      ((padByte msg (64 * b + 4 * j + 2)).setWidth 64 |||
        ((padByte msg (64 * b + 4 * j + 1)).setWidth 64 |||
          ((padByte msg (64 * b + 4 * j)).setWidth 64 ||| 0#64 <<< 8#64) <<< 8#64) <<<
            8#64) <<< 8#64 = (blockWord msg b j).setWidth 64 := by
  simp only [blockWord, be32]
  generalize padByte msg (64 * b + 4 * j + 3) = d
  generalize padByte msg (64 * b + 4 * j + 2) = c
  generalize padByte msg (64 * b + 4 * j + 1) = b'
  generalize padByte msg (64 * b + 4 * j) = a
  bv_decide

/-- What the four bytes of word `j` of block `b` reveal, the store of the word, and where
the loop goes on, `e`. -/
def wordLeak (n b j : Nat) (e : Word) : Trace :=
  byteLeak n (64 * b + 4 * j) 0x105bc#64 ++ byteLeak n (64 * b + 4 * j + 1) 0x105bc#64 ++
  byteLeak n (64 * b + 4 * j + 2) 0x105bc#64 ++ byteLeak n (64 * b + 4 * j + 3) 0x10570#64 ++
  [.write (0x10d90#64 + BitVec.ofNat 64 (4 * j)) 4, .jump e]

theorem word_step (msg : List (BitVec 8)) (b j : Nat) (x10 x11 x12 x13 x14 x15 x16 x17 x5 x6 q
    e : Word) (done rest : List Word) (c : Word)
    (t : Trace) (hn : msg.length < 2 ^ 32) (hb : 64 * b + 64 ≤ total msg.length) (hj : j < 16)
    (h10 : x10 = BitVec.ofNat 64 j) (h11 : x11 = BitVec.ofNat 64 (64 * b + 4))
    (h12 : x12 = BitVec.ofNat 64 (64 * b + 4 * j))
    (h13 : x13 = BitVec.ofNat 64 (8 * (total msg.length - 1 - (64 * b + 4 * j))))
    (hq : q = 0x10d90#64 + BitVec.ofNat 64 (4 * j)) (hd : done.length = j)
    (he : (x10 + 1#64 = 16#64 ∧ e = 0x10540#64) ∨ (x10 + 1#64 ≠ 16#64 ∧ e = 0x10588#64)) :
    TripleT program
      (Atoms.interp [.pc 0x10588#64, .reg a0 x10, .reg a1 x11, .reg a2 x12, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg s0 (BitVec.ofNat 64 msg.length),
        .reg s3 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg s4 (BitVec.ofNat 64 (8 * msg.length)), .reg s5 0x10e48#64, .reg s6 0x10d90#64,
        .reg s8 16#64, .prop (bytesAt 0x10e48#64 msg),
        .prop (cellsAt 4 true 0x10d90#64 done), .prop (cellsAt 4 true q (c :: rest))]) t
      (Atoms.interp [.pc e, .reg a0 (x10 + 1#64), .reg a1 x11, .reg a2 (x12 + 4#64),
        .reg a3 (x13 - 32#64), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1),
        .reg s0 (BitVec.ofNat 64 msg.length),
        .reg s3 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg s4 (BitVec.ofNat 64 (8 * msg.length)), .reg s5 0x10e48#64, .reg s6 0x10d90#64,
        .reg s8 16#64, .prop (bytesAt 0x10e48#64 msg),
        .prop (cellsAt 4 true 0x10d90#64 (done ++ [(blockWord msg b j).setWidth 64])),
        .prop (cellsAt 4 true (q + 4#64) rest)])
      (t ++ wordLeak msg.length b j e) := by
  have hT := le_total msg.length
  have hT' := total_lt msg.length
  subst hq
  simp only [wordLeak]
  have h16 : x11 + x10 <<< 2#64 = x12 + 4#64 := by rw [shl2]; subst h10 h11 h12; bv_omega
  braid_sym_run_to 0x105bc
  braid_call byte_step msg (64 * b + 4 * j) _ (x11 + x10 <<< 2#64) x12 x13 _ 0x105bc#64 _ hn
    (by omega) h12 h13 (.inr ⟨by rw [h16]; bv_omega, rfl⟩)
  braid_name_reg 6
  braid_call byte_step msg (64 * b + 4 * j + 1) _ (x11 + x10 <<< 2#64) (x12 + 1#64)
    (x13 - 8#64) _ 0x105bc#64 _ hn (by omega) (by rw [h12]; bv_omega)
    (by rw [h13]; bv_omega) (.inr ⟨by rw [h16]; bv_omega, rfl⟩)
  braid_name_reg 6
  braid_call byte_step msg (64 * b + 4 * j + 2) _ (x11 + x10 <<< 2#64) (x12 + 2#64)
    (x13 - 16#64) _ 0x105bc#64 _ hn (by omega) (by rw [h12]; bv_omega)
    (by rw [h13]; bv_omega) (.inr ⟨by rw [h16]; bv_omega, rfl⟩)
  braid_name_reg 6
  braid_call byte_step msg (64 * b + 4 * j + 3) _ (x11 + x10 <<< 2#64) (x12 + 3#64)
    (x13 - 24#64) _ 0x10570#64 _ hn (by omega) (by rw [h12]; bv_omega)
    (by rw [h13]; bv_omega) (.inl ⟨by rw [h16]; bv_omega, rfl⟩)
  braid_sym_run_to 0x1057c
  rw [show 0x10d90#64 + x10 <<< 2#64 = 0x10d90#64 + BitVec.ofNat 64 (4 * j) from by
    rw [shl2, h10]; bv_omega, be32_bytes]
  braid_unfold cellsAt_cons (0x10d90#64 + BitVec.ofNat 64 (4 * j)) c rest
  have hal : (0x10d90#64 + BitVec.ofNat 64 (4 * j)) &&& 3#64 = 0#64 :=
    Sha256.RiscV.and3_add_mul4 0x10d90#64 j
  braid_sym_run_to 0x10584
  braid_sym_step
  all_goals
    braid_fold cellsAt_snoc 0x10d90#64 (0x10d90#64 + BitVec.ofNat 64 (4 * j))
      ((blockWord msg b j).setWidth 64) done 4 true (by rw [hd])
    braid_forget 14
    braid_forget 15
    braid_forget 16
    braid_forget 17
    braid_forget 5
    rcases he with h | h
    all_goals
      obtain ⟨h1, h2⟩ := h
      subst h2
      first | exact absurd hbr h1 | exact absurd h1 hbr | braid_done

/-! ## The sixteen words of a block -/

/-- What the words of block `b` from word `j` on reveal, `r + 1` of them. -/
def wordsLeak (n b : Nat) (j : Nat) : Nat → Trace
  | 0 => wordLeak n b j 0x10540#64
  | r + 1 => wordLeak n b j 0x10588#64 ++ wordsLeak n b (j + 1) r

/-- The words of a block, the first `j` and one more. -/
theorem w32s_range_succ (msg : List (BitVec 8)) (b j : Nat) :
    w32s ((List.range j).map (blockWord msg b)) ++ [(blockWord msg b j).setWidth 64] =
      w32s ((List.range (j + 1)).map (blockWord msg b)) := by
  simp [w32s, List.range_succ]

/-- **The loop that pads a block.** From word `j` on, the loop writes the words of block `b`
of the padded message to the sixteen cells at `0x10d90`, and reveals `wordsLeak`. -/
theorem words_loop (msg : List (BitVec 8)) (b : Nat) (x11 : Word)
    (hn : msg.length < 2 ^ 32) (hb : 64 * b + 64 ≤ total msg.length)
    (h11 : x11 = BitVec.ofNat 64 (64 * b + 4)) :
    ∀ (rest : List Word) (j : Nat) (c : Word) (x10 x12 x13 x14 x15 x16 x17 x5 x6 q : Word)
      (t : Trace), j + rest.length + 1 = 16 → x10 = BitVec.ofNat 64 j →
      x12 = BitVec.ofNat 64 (64 * b + 4 * j) →
      x13 = BitVec.ofNat 64 (8 * (total msg.length - 1 - (64 * b + 4 * j))) →
      q = 0x10d90#64 + BitVec.ofNat 64 (4 * j) →
    TripleT program
      (Atoms.interp [.pc 0x10588#64, .reg a0 x10, .reg a1 x11, .reg a2 x12, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg s0 (BitVec.ofNat 64 msg.length),
        .reg s3 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg s4 (BitVec.ofNat 64 (8 * msg.length)), .reg s5 0x10e48#64, .reg s6 0x10d90#64,
        .reg s8 16#64, .prop (bytesAt 0x10e48#64 msg),
        .prop (cellsAt 4 true 0x10d90#64 (w32s ((List.range j).map (blockWord msg b)))),
        .prop (cellsAt 4 true q (c :: rest))]) t
      (Atoms.interp [.pc 0x10540#64, .prop (regAny a0), .reg a1 x11, .prop (regAny a2),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1),
        .reg s0 (BitVec.ofNat 64 msg.length),
        .reg s3 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg s4 (BitVec.ofNat 64 (8 * msg.length)), .reg s5 0x10e48#64, .reg s6 0x10d90#64,
        .reg s8 16#64, .prop (bytesAt 0x10e48#64 msg),
        .prop (cellsAt 4 true 0x10d90#64 (w32s (block msg b)))])
      (t ++ wordsLeak msg.length b j rest.length) := by
  intro rest
  induction rest with
  | nil =>
    intro j c x10 x12 x13 x14 x15 x16 x17 x5 x6 q t hj h10 h12 h13 hq
    have hj' : j = 15 := by simpa using hj
    subst hj'
    braid_call word_step msg b 15 x10 x11 x12 x13 x14 x15 x16 x17 x5 x6 q 0x10540#64
      (w32s ((List.range 15).map (blockWord msg b))) [] c _ hn hb (by omega) h10 h11 h12 h13 hq
      (by simp) (.inl ⟨by rw [h10]; rfl, rfl⟩)
    rw [w32s_range_succ]
    braid_unfold cellsAt_nil (k := 4) (w := true) (q + 4#64)
    braid_forget 10
    braid_forget 12
    braid_forget 13
    braid_done
  | cons c' rest ih =>
    intro j c x10 x12 x13 x14 x15 x16 x17 x5 x6 q t hj h10 h12 h13 hq
    simp only [List.length_cons] at hj
    have hT := total_lt msg.length
    braid_call word_step msg b j x10 x11 x12 x13 x14 x15 x16 x17 x5 x6 q 0x10588#64
      (w32s ((List.range j).map (blockWord msg b))) (c' :: rest) c _ hn hb (by omega) h10 h11
      h12 h13 hq (by simp) (.inr ⟨by rw [h10]; bv_omega, rfl⟩)
    rw [w32s_range_succ]
    braid_name_reg 14
    braid_name_reg 15
    braid_name_reg 16
    braid_name_reg 17
    braid_name_reg 5
    braid_name_reg 6
    braid_call ih (j + 1) c' (x10 + 1#64) (x12 + 4#64) (x13 - 32#64) _ _ _ _ _ _ (q + 4#64) _
      (by omega) (by rw [h10]; bv_omega) (by rw [h12]; bv_omega) (by rw [h13]; bv_omega)
      (by rw [hq]; bv_omega)
    braid_done

end Examples.Sha256Main.RiscV
