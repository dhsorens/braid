/-
  Examples.Sha256Main.X86.Output

  The loops of `main` that write the digest out, on x86-64. The compiled code does it in two
  loops: the first reverses the bytes of each word of the hash value (`bswapl`) into eight
  cells of the stack, which makes the 32 bytes there the digest, each word most significant
  byte first; the second copies those bytes to `digest`, which is how this program writes
  out, the model having no system call.

  ## Main definitions

  * `swap32`: a 32-bit word with its bytes in reverse order
  * `swapLeak`, `copyLeak`, `outLeak`: what the two loops reveal

  ## Main results

  * `flatMap_leBytes_swap32`: the cells of the reversed words are the bytes of the digest
  * `swap_loop`: the words of the hash value, reversed
  * `copy_loop`: bytes at one address copied to another
  * `out_loop`: the two loops: the digest at `digest`
-/

module

public import Examples.Sha256Main.X86.Blocks

@[expose] public section

namespace Examples.Sha256Main.X86

open Braid Examples Examples.Sha256 Lowering.X86 Lowering.X86.Regs

/-! ## Words with their bytes reversed -/

/-- A 32-bit word with its bytes in reverse order, as `bswap` leaves it. -/
def swap32 (x : W32) : W32 :=
  x.setWidth 8 ++ (x >>> 8).setWidth 8 ++ (x >>> 16).setWidth 8 ++ (x >>> 24).setWidth 8

/-- The bytes of a reversed word in memory are the bytes of the word, most significant
first. -/
theorem leBytes_swap32 (x : W32) : leBytes 4 ((swap32 x).setWidth 64) = wordBytes x := by
  simp only [leBytes, wordBytes, swap32, List.cons.injEq, and_true]
  refine ⟨?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- The cells of the reversed words of a hash value are the bytes of its digest. -/
theorem flatMap_leBytes_swap32 (H : List W32) :
    (w32s (H.map swap32)).flatMap (leBytes 4) = H.flatMap wordBytes := by
  induction H with
  | nil => rfl
  | cons x xs ih =>
    rw [List.map_cons, w32s_cons, List.flatMap_cons, List.flatMap_cons, leBytes_swap32, ih]

/-- What `bswapl` leaves in a 32-bit cell is the reversed word. -/
theorem bswap_swap32 (x : W32) :
    BitVec.setWidth 64 (BitVec.setWidth 32 (bswap (BitVec.setWidth 64 x) >>> 32#64)) =
      BitVec.setWidth 64 (swap32 x) := by
  simp only [Braid.bswap, swap32]
  bv_decide

/-! ## The loop that reverses the bytes of each word -/

/-- What the loop that reverses the words reveals, with `n + 1` words to go: the word read
at `hq`, the word written at `oq`, and the branch. -/
def swapLeak (hq oq : Word) : Nat → Trace
  | 0 => [.read hq 4, .write oq 4, .jump 0x402503#64]
  | n + 1 => [.read hq 4, .write oq 4, .jump 0x4024f0#64] ++ swapLeak (hq + 4#64) (oq + 4#64) n

/-- **The loop that reverses the words.** From index `i` on, each word of the hash value at
`hq` is written with its bytes reversed to the cell at `oq`. -/
theorem swap_loop : ∀ (xs : List W32) (x : W32) (zs : List Word) (z : Word) (i : Nat)
    (x0 x2 hq oq : Word) (c pf af zf sg o : Bool) (t : Trace), zs.length = xs.length →
    i + xs.length + 1 = 8 → x0 = BitVec.ofNat 64 i →
    hq = 0x402c88#64 + BitVec.ofNat 64 (4 * i) →
    oq = 0x402ca8#64 + BitVec.ofNat 64 (4 * i) →
    TripleT program
      (Atoms.interp [.pc 0x4024f0#64, .reg rax x0, .reg rcx x2, .reg rsp 0x402c78#64,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf zf,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true hq (w32s (x :: xs))), .prop (cellsAt 4 true oq (z :: zs))]) t
      (Atoms.interp [.pc 0x402503#64, .prop (regAny rax), .prop (regAny rcx),
        .reg rsp 0x402c78#64,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true hq (w32s (x :: xs))),
        .prop (cellsAt 4 true oq (w32s ((x :: xs).map swap32)))])
      (t ++ swapLeak hq oq xs.length) := by
  intro xs
  induction xs with
  | nil =>
    intro x zs z i x0 x2 hq oq c pf af zf sg o t hz hi h0 hh ho
    obtain rfl : zs = [] := List.length_eq_zero_iff.1 hz
    obtain rfl : i = 7 := by simpa using hi
    obtain rfl : hq = 0x402c78#64 + (x0 * 4#64 + 16#64) := by rw [hh, h0]; decide
    obtain rfl : oq = 0x402c78#64 + (x0 * 4#64 + 48#64) := by rw [ho, h0]; decide
    simp only [List.map_cons, List.map_nil, w32s, List.length_nil, swapLeak]
    braid_unfold cellsAt_cons (k := 4) (w := true) (0x402c78#64 + (x0 * 4#64 + 16#64))
      (BitVec.setWidth 64 x) []
    braid_unfold cellsAt_cons (k := 4) (w := true) (0x402c78#64 + (x0 * 4#64 + 48#64)) z []
    braid_sym_run_to 0x402501
    rw [bswap_swap32]
    braid_sym_step
    · exfalso; bv_decide
    · braid_fold cellsAt_cons (k := 4) (w := true) (0x402c78#64 + (x0 * 4#64 + 48#64))
        (BitVec.setWidth 64 (swap32 x)) []
      braid_fold cellsAt_cons (k := 4) (w := true) (0x402c78#64 + (x0 * 4#64 + 16#64))
        (BitVec.setWidth 64 x) []
      braid_forget 0
      braid_forget 2
      x86_forget_all_flags
      braid_done
  | cons x' xs ih =>
    intro x zs z i x0 x2 hq oq c pf af zf sg o t hz hi h0 hh ho
    obtain ⟨z', zs, rfl⟩ : ∃ z' zs', zs = z' :: zs' := by
      cases zs with
      | nil => simp at hz
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at hz hi
    obtain rfl : hq = 0x402c78#64 + (x0 * 4#64 + 16#64) := by rw [hh, h0]; bv_omega
    obtain rfl : oq = 0x402c78#64 + (x0 * 4#64 + 48#64) := by rw [ho, h0]; bv_omega
    rw [List.map_cons, w32s_cons x, w32s_cons (swap32 x)]
    simp only [List.length_cons, swapLeak]
    braid_unfold cellsAt_cons (k := 4) (w := true) (0x402c78#64 + (x0 * 4#64 + 16#64))
      (BitVec.setWidth 64 x) (w32s (x' :: xs))
    braid_unfold cellsAt_cons (k := 4) (w := true) (0x402c78#64 + (x0 * 4#64 + 48#64)) z
      (z' :: zs)
    braid_sym_run_to 0x402501
    rw [bswap_swap32]
    braid_sym_step
    · x86_name_all_flags
      braid_call ih x' zs z' (i + 1) (x0 + 1#64) _
        (0x402c78#64 + (x0 * 4#64 + 16#64) + 4#64) (0x402c78#64 + (x0 * 4#64 + 48#64) + 4#64)
        _ _ _ _ _ _ _ (by omega) (by omega) (by rw [h0]; bv_omega) (by rw [hh]; bv_omega)
        (by rw [ho]; bv_omega)
      braid_fold cellsAt_cons (k := 4) (w := true) (0x402c78#64 + (x0 * 4#64 + 48#64))
        (BitVec.setWidth 64 (swap32 x)) (w32s ((x' :: xs).map swap32))
      braid_fold cellsAt_cons (k := 4) (w := true) (0x402c78#64 + (x0 * 4#64 + 16#64))
        (BitVec.setWidth 64 x) (w32s (x' :: xs))
      braid_done
    · exfalso; bv_omega

/-! ## The loop that copies the digest out -/

/-- What the loop that copies the digest reveals, with `n + 1` bytes to go: the byte read at
`sq`, the byte written at `dq`, and the branch. -/
def copyLeak (sq dq : Word) : Nat → Trace
  | 0 => [.read sq 1, .write dq 1, .jump 0x402521#64]
  | n + 1 => [.read sq 1, .write dq 1, .jump 0x402510#64] ++ copyLeak (sq + 1#64) (dq + 1#64) n

/-- **The loop that copies the digest.** From index `i` on, the bytes at `sq` are copied to
`dq`. -/
theorem copy_loop : ∀ (ss ds : List (BitVec 8)) (s d : BitVec 8) (i : Nat)
    (x0 x3 sq dq : Word) (c pf af zf sg o : Bool) (t : Trace), ds.length = ss.length →
    i + ss.length + 1 = 32 → x0 = BitVec.ofNat 64 i → sq = 0x402ca8#64 + BitVec.ofNat 64 i →
    dq = 0x402d40#64 + BitVec.ofNat 64 i →
    TripleT program
      (Atoms.interp [.pc 0x402510#64, .reg rax x0, .reg rcx 0x402d40#64, .reg rdx x3,
        .reg rsp 0x402c78#64,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf zf,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (bytesAt sq (s :: ss)), .prop (bytesAt dq (d :: ds))]) t
      (Atoms.interp [.pc 0x402521#64, .prop (regAny rax), .reg rcx 0x402d40#64,
        .prop (regAny rdx), .reg rsp 0x402c78#64,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (bytesAt sq (s :: ss)), .prop (bytesAt dq (s :: ss))])
      (t ++ copyLeak sq dq ss.length) := by
  intro ss
  induction ss with
  | nil =>
    intro ds s d i x0 x3 sq dq c pf af zf sg o t hd hi h0 hs hq
    obtain rfl : ds = [] := List.length_eq_zero_iff.1 hd
    obtain rfl : i = 31 := by simpa using hi
    obtain rfl : sq = 0x402c78#64 + (x0 * 1#64 + 48#64) := by rw [hs, h0]; decide
    obtain rfl : dq = x0 + 0x402d40#64 := by rw [hq, h0]; decide
    simp only [List.length_nil, copyLeak]
    braid_unfold bytesAt_cons (0x402c78#64 + (x0 * 1#64 + 48#64)) s []
    braid_unfold bytesAt_cons (x0 + 0x402d40#64) d []
    braid_sym_run_to 0x40251f
    braid_sym_step
    · exfalso; bv_decide
    · braid_fold bytesAt_cons (x0 + 0x402d40#64) s []
      braid_fold bytesAt_cons (0x402c78#64 + (x0 * 1#64 + 48#64)) s []
      braid_forget 0
      braid_forget 3
      x86_forget_all_flags
      braid_done
  | cons s' ss ih =>
    intro ds s d i x0 x3 sq dq c pf af zf sg o t hd hi h0 hs hq
    obtain ⟨d', ds, rfl⟩ : ∃ d' ds', ds = d' :: ds' := by
      cases ds with
      | nil => simp at hd
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at hd hi
    obtain rfl : sq = 0x402c78#64 + (x0 * 1#64 + 48#64) := by rw [hs, h0]; bv_omega
    obtain rfl : dq = x0 + 0x402d40#64 := by rw [hq, h0]; bv_omega
    simp only [List.length_cons, copyLeak]
    braid_unfold bytesAt_cons (0x402c78#64 + (x0 * 1#64 + 48#64)) s (s' :: ss)
    braid_unfold bytesAt_cons (x0 + 0x402d40#64) d (d' :: ds)
    braid_sym_run_to 0x40251f
    braid_sym_step
    · x86_name_all_flags
      braid_call ih ds s' d' (i + 1) (x0 + 1#64) _
        (0x402c78#64 + (x0 * 1#64 + 48#64) + 1#64) (x0 + 0x402d40#64 + 1#64)
        _ _ _ _ _ _ _ (by omega) (by omega) (by rw [h0]; bv_omega) (by rw [hs]; bv_omega)
        (by rw [hq]; bv_omega)
      braid_fold bytesAt_cons (x0 + 0x402d40#64) s (s' :: ss)
      braid_fold bytesAt_cons (0x402c78#64 + (x0 * 1#64 + 48#64)) s (s' :: ss)
      braid_done
    · exfalso; bv_omega

/-! ## The digest, written out -/

/-- What writing the digest out reveals: the eight words of the hash value read and their
reversals written, and the 32 bytes copied to `digest`. -/
def outLeak : Trace :=
  swapLeak 0x402c88#64 0x402ca8#64 7 ++ copyLeak 0x402ca8#64 0x402d40#64 31

/-- **The loops that write the digest out.** The eight words of the hash value at `0x402c88`
are written with their bytes reversed to `0x402ca8`, which makes the bytes there the digest,
each word most significant byte first, and those 32 bytes are copied to `digest`, at
`0x402d40`. -/
theorem out_loop (H : List W32) (zs : List Word) (ds : List (BitVec 8)) (x2 x3 : Word)
    (c pf af zf sg o : Bool) (t : Trace) (hH : H.length = 8) (hz : zs.length = 8)
    (hd : ds.length = 32) :
    TripleT program
      (Atoms.interp [.pc 0x4024f0#64, .reg rax 0#64, .reg rcx x2, .reg rdx x3,
        .reg rsp 0x402c78#64,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf zf,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true 0x402c88#64 (w32s H)), .prop (cellsAt 4 true 0x402ca8#64 zs),
        .prop (bytesAt 0x402d40#64 ds)]) t
      (Atoms.interp [.pc 0x402521#64, .prop (regAny rax), .reg rcx 0x402d40#64,
        .prop (regAny rdx), .reg rsp 0x402c78#64,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true 0x402c88#64 (w32s H)),
        .prop (bytesAt 0x402ca8#64 (H.flatMap wordBytes)),
        .prop (bytesAt 0x402d40#64 (H.flatMap wordBytes))]) (t ++ outLeak) := by
  obtain ⟨x, xs, rfl⟩ : ∃ x xs, H = x :: xs := by
    cases H with
    | nil => simp at hH
    | cons x xs => exact ⟨x, xs, rfl⟩
  obtain ⟨z, zs, rfl⟩ : ∃ z zs', zs = z :: zs' := by
    cases zs with
    | nil => simp at hz
    | cons z zs => exact ⟨z, zs, rfl⟩
  obtain ⟨d, ds, rfl⟩ : ∃ d ds', ds = d :: ds' := by
    cases ds with
    | nil => simp at hd
    | cons d ds => exact ⟨d, ds, rfl⟩
  simp only [List.length_cons] at hH hz hd
  have hl : ((x :: xs).flatMap wordBytes).length = 32 := by
    rw [flatMap_wordBytes_length, List.length_cons]; omega
  braid_call swap_loop xs x zs z 0 0#64 x2 0x402c88#64 0x402ca8#64 _ _ _ _ _ _ _ (by omega)
    (by omega) rfl rfl rfl
  braid_fold bytesAt_interp_cellsAt 0x402ca8#64 ((x :: xs).flatMap wordBytes)
    (w32s ((x :: xs).map swap32)) 4 (by decide) (flatMap_leBytes_swap32 (x :: xs)).symm
  obtain ⟨s, ss, hs⟩ : ∃ s ss, (x :: xs).flatMap wordBytes = s :: ss := by
    cases h : (x :: xs).flatMap wordBytes with
    | nil => rw [h] at hl; cases hl
    | cons s ss => exact ⟨s, ss, rfl⟩
  rw [hs] at hl ⊢
  simp only [List.length_cons] at hl
  braid_name_reg 0
  braid_name_reg 2
  x86_name_all_flags
  braid_sym_run_to 0x402510
  refine Sha256.X86.tripleT_reg_val (r := 0) 0#64 (by braid_upd) (by bv_decide) ?_
  x86_name_all_flags
  braid_call copy_loop ss ds s d 0 0#64 x3 0x402ca8#64 0x402d40#64 _ _ _ _ _ _ _ (by omega)
    (by omega) rfl rfl rfl
  rw [show xs.length = 7 from by omega, show ss.length = 31 from by omega]
  simp only [outLeak]
  braid_done

end Examples.Sha256Main.X86
