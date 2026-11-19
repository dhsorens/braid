/-
  Examples.Sha256Main.X86.Pad

  The loop of `main` that pads one block of the message, on x86-64. The C source computes
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

public import Examples.Sha256Main.X86.Program

@[expose] public section

namespace Examples.Sha256Main.X86

open Braid Examples Examples.Sha256 Lowering.X86 Lowering.X86.Regs

/-- An array of bytes, opened at index `i`, whose address is written as the code computes
it: with the index scaled by one. -/
theorem bytesAt_scaled (p : Word) (bs : List (BitVec 8)) (i : Nat) (hi : i < bs.length) :
    (Atom.prop (bytesAt p bs)).interp =
      Atoms.interp [.prop (bytesAt p (bs.take i)),
        .mem (p + BitVec.ofNat 64 i * 1#64) 1 ((bs.getD i 0#8).zeroExtend 64) true,
        .prop (bytesAt (p + BitVec.ofNat 64 i + 1#64) (bs.drop (i + 1)))] := by
  rw [BitVec.mul_one]
  exact bytesAt_index p bs i hi

/-- A shift by the low byte of a 32-bit sum, as `shr %cl` makes it. -/
theorem shr_cl (v x : Word) (m : Nat) (hm : m < 64) (hx : x = BitVec.ofNat 64 m) :
    v >>> ((x.setWidth 32).setWidth 64 &&& 63#64) = v >>> m := by
  subst hx
  have e : ((BitVec.ofNat 64 m).setWidth 32).setWidth 64 &&& 63#64 = BitVec.ofNat 64 m := by
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_and, show (63#64).toNat = 2 ^ 6 - 1 from rfl,
      Nat.and_two_pow_sub_one_eq_mod]
    simp only [BitVec.toNat_setWidth, BitVec.toNat_ofNat]
    omega
  rw [e, BitVec.ushiftRight_eq', BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]

/-- Close a goal that contradicts an unsigned comparison the code made. -/
local macro "ult_omega " h:ident : tactic =>
  `(tactic| (exfalso
             first
               | rw [BitVec.ult_iff_lt] at $h:ident
               | rw [← Bool.not_eq_true, BitVec.ult_iff_lt] at $h:ident
             bv_omega))

/-- The end of a byte step: the word with the byte `b` shifted in, the counter, and the
branch back, either way. -/
local macro "byte_done " w:ident ", " x9:ident ", " b:term ", " he:ident : tactic =>
  `(tactic| (refine Sha256.X86.tripleT_reg_val (r := 5) (BitVec.setWidth 64 ($w <<< 8 ||| $b))
               (by braid_upd) (by bv_decide) ?_
             refine Sha256.X86.tripleT_reg_val (r := 9) ($x9 - 8#64) (by braid_upd)
               (by bv_decide) ?_
             braid_forget 2
             braid_forget 10
             x86_forget_all_flags
             rcases $he:ident with h | h
             all_goals
               obtain ⟨h1, h2⟩ := h
               subst h2
               first | (exfalso; bv_decide) | braid_done))

def byteLeak (n k : Nat) (e : Word) : Trace :=
  (if k < n then [.jump 0x4024b0#64, .read (0x402d68#64 + BitVec.ofNat 64 k) 1]
  else if k = n then [.jump 0x4024cc#64, .jump 0x4024b5#64]
  else if total n - 8 ≤ k then [.jump 0x4024cc#64, .jump 0x4024d3#64, .jump 0x4024da#64]
  else [.jump 0x4024cc#64, .jump 0x4024d3#64, .jump 0x4024b5#64]) ++ [.jump e]

/-- **One byte of the padded message.** The byte at index `k` is shifted into the low end of
the 32-bit word in `edi`, and the counter in `r9` goes down by eight; `x3 + x9` is the shift
that takes a byte of the length. The trace is `byteLeak` of the length and the index. -/
theorem byte_step (msg : List (BitVec 8)) (k : Nat) (w : W32) (x2 x3 x8 x9 x10 e : Word)
    (c pf af z sg o : Bool)
    (t : Trace) (hn : msg.length < 2 ^ 32) (hk : k < total msg.length)
    (h8 : x8 = BitVec.ofNat 64 k)
    (hx : x3 + x9 = BitVec.ofNat 64 (8 * (total msg.length - 1 - k)))
    (he : (x9 - 8#64 = 0xffffffffffffffe0#64 ∧ e = 0x402490#64) ∨
      (x9 - 8#64 ≠ 0xffffffffffffffe0#64 ∧ e = 0x4024c7#64)) :
    TripleT program
      (Atoms.interp [.pc 0x4024c7#64, .reg rcx x2, .reg rdx x3, .reg rdi (w.setWidth 64),
        .reg r8 x8, .reg r9 x9, .reg r10 x10, .reg rbx 0x402d68#64,
        .reg rbp (BitVec.ofNat 64 (8 * msg.length)),
        .reg r13 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg r15 (BitVec.ofNat 64 msg.length),
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (bytesAt 0x402d68#64 msg)]) t
      (Atoms.interp [.pc e, .prop (regAny rcx), .reg rdx x3,
        .reg rdi ((w <<< 8 ||| (padByte msg k).setWidth 32).setWidth 64),
        .reg r8 (x8 + 1#64), .reg r9 (x9 - 8#64), .prop (regAny r10), .reg rbx 0x402d68#64,
        .reg rbp (BitVec.ofNat 64 (8 * msg.length)),
        .reg r13 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg r15 (BitVec.ofNat 64 msg.length),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (bytesAt 0x402d68#64 msg)]) (t ++ byteLeak msg.length k e) := by
  have hT := le_total msg.length
  have hT' := total_lt msg.length
  subst h8
  by_cases h1 : k < msg.length
  · rw [padByte_lt msg k h1]
    simp only [byteLeak, h1, ↓reduceIte]
    braid_unfold bytesAt_scaled 0x402d68#64 msg k h1
    braid_sym_run_to 0x4024ca
    braid_sym_step
    · braid_sym_run_to 0x4024c5
      braid_sym_step
      all_goals
        braid_fold bytesAt_scaled 0x402d68#64 msg k h1
        simp only [BitVec.mul_one]
        byte_done w, x9, (BitVec.setWidth 32 (msg.getD k 0#8)), he
    · ult_omega hbr
  · by_cases h2 : k = msg.length
    · subst h2
      rw [padByte_eq]
      simp only [byteLeak, h1, ↓reduceIte]
      braid_sym_run_to 0x4024ca
      braid_sym_step
      · ult_omega hbr
      · braid_sym_run_to 0x4024d1
        braid_sym_step
        · braid_sym_run_to 0x4024c5
          braid_sym_step
          all_goals byte_done w, x9, 0x80#32, he
        · exfalso; bv_omega
    · by_cases h3 : total msg.length - 8 ≤ k
      · rw [padByte_len msg k (by omega) h3 hk]
        simp only [byteLeak, h1, h2, h3, ↓reduceIte]
        braid_sym_run_to 0x4024ca
        braid_sym_step
        · ult_omega hbr
        · braid_sym_run_to 0x4024d1
          braid_sym_step
          · exfalso; bv_omega
          · braid_sym_run_to 0x4024d8
            braid_sym_step
            · ult_omega hbr
            · braid_sym_run_to 0x4024e1
              x86_name_all_flags
              braid_sym_run_to 0x4024c5
              rw [BitVec.mul_one, shr_cl _ _ (8 * (total msg.length - 1 - k)) (by omega) hx]
              generalize BitVec.ofNat 64 (8 * msg.length) >>> (8 * (total msg.length - 1 - k)) = v
              braid_sym_step
              all_goals byte_done w, x9, (BitVec.setWidth 32 (BitVec.setWidth 8 v)), he
      · rw [padByte_zero msg k (by omega) (by omega)]
        simp only [byteLeak, h1, h2, h3, ↓reduceIte]
        braid_sym_run_to 0x4024ca
        braid_sym_step
        · ult_omega hbr
        · braid_sym_run_to 0x4024d1
          braid_sym_step
          · exfalso; bv_omega
          · braid_sym_run_to 0x4024d8
            braid_sym_step
            · braid_sym_run_to 0x4024c5
              braid_sym_step
              all_goals byte_done w, x9, 0#32, he
            · ult_omega hbr

/-! ## One word -/

/-- Four bytes shifted into a 32-bit register one after another are their big-endian
word. -/
theorem be32_bytes (msg : List (BitVec 8)) (b j : Nat) :
    (((0#32 <<< 8 ||| (padByte msg (64 * b + 4 * j)).setWidth 32) <<< 8 |||
      (padByte msg (64 * b + 4 * j + 1)).setWidth 32) <<< 8 |||
        (padByte msg (64 * b + 4 * j + 2)).setWidth 32) <<< 8 |||
          (padByte msg (64 * b + 4 * j + 3)).setWidth 32 = blockWord msg b j := by
  simp only [blockWord, be32]
  generalize padByte msg (64 * b + 4 * j + 3) = d
  generalize padByte msg (64 * b + 4 * j + 2) = c
  generalize padByte msg (64 * b + 4 * j + 1) = b'
  generalize padByte msg (64 * b + 4 * j) = a
  bv_decide

/-- What the four bytes of word `j` of block `b` reveal, the store of the word, and where
the loop goes on, `e`. -/
def wordLeak (n b j : Nat) (e : Word) : Trace :=
  byteLeak n (64 * b + 4 * j) 0x4024c7#64 ++ byteLeak n (64 * b + 4 * j + 1) 0x4024c7#64 ++
  byteLeak n (64 * b + 4 * j + 2) 0x4024c7#64 ++ byteLeak n (64 * b + 4 * j + 3) 0x402490#64 ++
  [.write (0x402cc8#64 + BitVec.ofNat 64 (4 * j)) 4, .jump e]

/-- **One word of a block.** Word `j` of block `b` of the padded message is built from its
four bytes and stored in cell `j` of the block on the stack, at `q`. -/
theorem word_step (msg : List (BitVec 8)) (b j : Nat) (x0 x2 x3 x4 x5 x8 x9 x10 q e : Word)
    (c pf af z sg o : Bool) (done rest : List Word) (cl : Word)
    (t : Trace) (hn : msg.length < 2 ^ 32) (hb : 64 * b + 64 ≤ total msg.length) (hj : j < 16)
    (h0 : x0 = BitVec.ofNat 64 (64 * b + 4 * j))
    (h3 : x3 = BitVec.ofNat 64 (8 * (total msg.length - 1 - (64 * b + 4 * j))))
    (h4 : x4 = BitVec.ofNat 64 j)
    (hq : q = 0x402cc8#64 + BitVec.ofNat 64 (4 * j)) (hd : done.length = j)
    (he : (x4 + 1#64 = 16#64 ∧ e = 0x402460#64) ∨ (x4 + 1#64 ≠ 16#64 ∧ e = 0x4024a5#64)) :
    TripleT program
      (Atoms.interp [.pc 0x4024a5#64, .reg rax x0, .reg rcx x2, .reg rdx x3, .reg rsi x4,
        .reg rdi x5, .reg r8 x8, .reg r9 x9, .reg r10 x10, .reg rbx 0x402d68#64,
        .reg rsp 0x402c78#64,
        .reg rbp (BitVec.ofNat 64 (8 * msg.length)),
        .reg r13 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg r15 (BitVec.ofNat 64 msg.length),
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (bytesAt 0x402d68#64 msg),
        .prop (cellsAt 4 true 0x402cc8#64 done), .prop (cellsAt 4 true q (cl :: rest))]) t
      (Atoms.interp [.pc e, .reg rax (x0 + 4#64), .prop (regAny rcx), .reg rdx (x3 - 32#64),
        .reg rsi (x4 + 1#64), .prop (regAny rdi), .prop (regAny r8), .prop (regAny r9),
        .prop (regAny r10), .reg rbx 0x402d68#64, .reg rsp 0x402c78#64,
        .reg rbp (BitVec.ofNat 64 (8 * msg.length)),
        .reg r13 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg r15 (BitVec.ofNat 64 msg.length),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (bytesAt 0x402d68#64 msg),
        .prop (cellsAt 4 true 0x402cc8#64 (done ++ [(blockWord msg b j).setWidth 64])),
        .prop (cellsAt 4 true (q + 4#64) rest)])
      (t ++ wordLeak msg.length b j e) := by
  have hT := le_total msg.length
  have hT' := total_lt msg.length
  obtain rfl : q = 0x402c78#64 + (x4 * 4#64 + 80#64) := by rw [hq, h4]; bv_omega
  simp only [wordLeak]
  braid_sym_run_to 0x4024c7
  refine Sha256.X86.tripleT_reg_val (r := 5) 0#64 (by braid_upd) (by bv_decide) ?_
  refine Sha256.X86.tripleT_reg_val (r := 9) 0#64 (by braid_upd) (by bv_decide) ?_
  x86_name_all_flags
  braid_call byte_step msg (64 * b + 4 * j) 0#32 x2 x3 x0 0#64 x10 0x4024c7#64 _ _ _ _ _ _ _ hn
    (by omega) h0 (by rw [h3]; bv_omega) (.inr ⟨by decide, rfl⟩)
  braid_name_reg 2
  braid_name_reg 10
  x86_name_all_flags
  braid_call byte_step msg (64 * b + 4 * j + 1) _ _ x3 (x0 + 1#64) 0xfffffffffffffff8#64 _
    0x4024c7#64 _ _ _ _ _ _ _ hn (by omega) (by rw [h0]; bv_omega) (by rw [h3]; bv_omega)
    (.inr ⟨by decide, rfl⟩)
  braid_name_reg 2
  braid_name_reg 10
  x86_name_all_flags
  braid_call byte_step msg (64 * b + 4 * j + 2) _ _ x3 (x0 + 2#64) 0xfffffffffffffff0#64 _
    0x4024c7#64 _ _ _ _ _ _ _ hn (by omega) (by rw [h0]; bv_omega) (by rw [h3]; bv_omega)
    (.inr ⟨by decide, rfl⟩)
  braid_name_reg 2
  braid_name_reg 10
  x86_name_all_flags
  braid_call byte_step msg (64 * b + 4 * j + 3) _ _ x3 (x0 + 3#64) 0xffffffffffffffe8#64 _
    0x402490#64 _ _ _ _ _ _ _ hn (by omega) (by rw [h0]; bv_omega) (by rw [h3]; bv_omega)
    (.inl ⟨by decide, rfl⟩)
  rw [be32_bytes]
  braid_unfold cellsAt_cons (0x402c78#64 + (x4 * 4#64 + 80#64)) cl rest
  braid_sym_run_to 0x4024a3
  braid_sym_step
  all_goals
    braid_fold cellsAt_snoc 0x402cc8#64 (0x402c78#64 + (x4 * 4#64 + 80#64))
      ((blockWord msg b j).setWidth 64) done 4 true (by rw [hd, h4]; bv_omega)
    rw [show 0x402c78#64 + (x4 * 4#64 + 80#64) = 0x402cc8#64 + BitVec.ofNat 64 (4 * j) from hq]
    refine Sha256.X86.tripleT_reg_val (r := 0) (x0 + 4#64) (by braid_upd) (by bv_decide) ?_
    refine Sha256.X86.tripleT_reg_val (r := 3) (x3 - 32#64) (by braid_upd) (by bv_decide) ?_
    braid_forget 5
    braid_forget 8
    braid_forget 9
    x86_forget_all_flags
    rcases he with h | h
    all_goals
      obtain ⟨h1, h2⟩ := h
      subst h2
      first | (exfalso; bv_decide) | braid_done

/-! ## The sixteen words of a block -/

/-- What the words of block `b` from word `j` on reveal, `r + 1` of them. -/
def wordsLeak (n b : Nat) (j : Nat) : Nat → Trace
  | 0 => wordLeak n b j 0x402460#64
  | r + 1 => wordLeak n b j 0x4024a5#64 ++ wordsLeak n b (j + 1) r

/-- **The loop that pads a block.** From word `j` on, the loop writes the words of block `b`
of the padded message to the sixteen cells at `0x402cc8`, and reveals `wordsLeak`. -/
theorem words_loop (msg : List (BitVec 8)) (b : Nat) (hn : msg.length < 2 ^ 32)
    (hb : 64 * b + 64 ≤ total msg.length) :
    ∀ (rest : List Word) (j : Nat) (cl : Word) (x0 x2 x3 x4 x5 x8 x9 x10 q : Word)
      (c pf af z sg o : Bool) (t : Trace), j + rest.length + 1 = 16 →
      x0 = BitVec.ofNat 64 (64 * b + 4 * j) →
      x3 = BitVec.ofNat 64 (8 * (total msg.length - 1 - (64 * b + 4 * j))) →
      x4 = BitVec.ofNat 64 j → q = 0x402cc8#64 + BitVec.ofNat 64 (4 * j) →
    TripleT program
      (Atoms.interp [.pc 0x4024a5#64, .reg rax x0, .reg rcx x2, .reg rdx x3, .reg rsi x4,
        .reg rdi x5, .reg r8 x8, .reg r9 x9, .reg r10 x10, .reg rbx 0x402d68#64,
        .reg rsp 0x402c78#64,
        .reg rbp (BitVec.ofNat 64 (8 * msg.length)),
        .reg r13 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg r15 (BitVec.ofNat 64 msg.length),
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (bytesAt 0x402d68#64 msg),
        .prop (cellsAt 4 true 0x402cc8#64 (w32s ((List.range j).map (blockWord msg b)))),
        .prop (cellsAt 4 true q (cl :: rest))]) t
      (Atoms.interp [.pc 0x402460#64, .prop (regAny rax), .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .prop (regAny rdi), .prop (regAny r8),
        .prop (regAny r9), .prop (regAny r10), .reg rbx 0x402d68#64, .reg rsp 0x402c78#64,
        .reg rbp (BitVec.ofNat 64 (8 * msg.length)),
        .reg r13 (BitVec.ofNat 64 (total msg.length - 8)),
        .reg r15 (BitVec.ofNat 64 msg.length),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (bytesAt 0x402d68#64 msg),
        .prop (cellsAt 4 true 0x402cc8#64 (w32s (block msg b)))])
      (t ++ wordsLeak msg.length b j rest.length) := by
  intro rest
  induction rest with
  | nil =>
    intro j cl x0 x2 x3 x4 x5 x8 x9 x10 q c pf af z sg o t hj h0 h3 h4 hq
    have hj' : j = 15 := by simpa using hj
    subst hj'
    braid_call word_step msg b 15 x0 x2 x3 x4 x5 x8 x9 x10 q 0x402460#64 c pf af z sg o
      (w32s ((List.range 15).map (blockWord msg b))) [] cl _ hn hb (by omega) h0 h3 h4 hq
      (by simp) (.inl ⟨by rw [h4]; rfl, rfl⟩)
    rw [w32s_range_succ]
    braid_unfold cellsAt_nil (k := 4) (w := true) (q + 4#64)
    braid_forget 0
    braid_forget 3
    braid_forget 4
    braid_done
  | cons c' rest ih =>
    intro j cl x0 x2 x3 x4 x5 x8 x9 x10 q c pf af z sg o t hj h0 h3 h4 hq
    simp only [List.length_cons] at hj
    have hT := total_lt msg.length
    braid_call word_step msg b j x0 x2 x3 x4 x5 x8 x9 x10 q 0x4024a5#64 c pf af z sg o
      (w32s ((List.range j).map (blockWord msg b))) (c' :: rest) cl _ hn hb (by omega) h0 h3
      h4 hq (by simp) (.inr ⟨by rw [h4]; bv_omega, rfl⟩)
    rw [w32s_range_succ]
    braid_name_reg 2
    braid_name_reg 5
    braid_name_reg 8
    braid_name_reg 9
    braid_name_reg 10
    x86_name_all_flags
    braid_call ih (j + 1) c' (x0 + 4#64) _ (x3 - 32#64) (x4 + 1#64) _ _ _ _ (q + 4#64)
      _ _ _ _ _ _ _
      (by omega) (by rw [h0]; bv_omega) (by rw [h3]; bv_omega) (by rw [h4]; bv_omega)
      (by rw [hq]; bv_omega)
    braid_done

end Examples.Sha256Main.X86
