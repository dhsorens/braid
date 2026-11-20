/-
  Examples.Sha256Main.Arm.Output

  The loop of `main` that writes the digest out as bytes, on AArch64: each word of the hash
  value, most significant byte first. The compiled code reverses the bytes of the word and
  stores it as one word of four bytes, at an address that is not a multiple of four.

  The triple is about `ownProgram`, the code of `_start` and `main` alone, and this file
  imports nothing about the compression function: it holds of any binary with this `main`.

  ## Main definitions

  * `outLeak`: what the loop reveals

  ## Main results

  * `out_loop`: the words of the hash value, written as bytes
-/

module

public import Examples.Sha256Main.Arm.Own
public import Examples.Sha256Main.Shared
public import Examples.Sha256.RunTo

@[expose] public section

namespace Examples.Sha256Main.Arm

open Braid Examples Examples.Sha256 Lowering.Arm Lowering.Arm.Regs

/-- What the loop that writes the digest out as bytes reveals, with `n + 1` words to go: the
word read at `hq`, the four bytes written at `oq`, and the branch. -/
def outLeak (oq hq : Word) : Nat → Trace
  | 0 => [.read hq 4, .write oq 4, .jump 0x204ac#64]
  | n + 1 => [.read hq 4, .write oq 4, .jump 0x20490#64] ++ outLeak (oq + 4#64) (hq + 4#64) n

/-- The bytes of a word and then more bytes: the word's four, and the rest four further
on. -/
theorem bytesAt_wordBytes (oq : Word) (x : W32) (bs : List (BitVec 8)) :
    (Atom.prop (bytesAt oq (wordBytes x ++ bs))).interp =
      Atoms.interp [.prop (bytesAt oq (wordBytes x)), .prop (bytesAt (oq + 4#64) bs)] :=
  bytesAt_append oq (wordBytes x) bs

/-- The bytes of a word with its bytes reversed, least significant first, are the bytes of
the word, most significant first. -/
theorem leBytes_rev (x : W32) :
    leBytes 4 (bswap (BitVec.setWidth 64 x) >>> 32#64) = wordBytes x := by
  simp only [leBytes, wordBytes, bswap, List.cons.injEq, and_true]
  refine ⟨?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- One word of the digest written as four bytes: run the iteration up to its branch, and
read the cell written as the bytes of the word. -/
local macro "out_word " oq:term ", " hq:term ", " x:term ", " xs:term ", " c:term ", "
    cs:term : tactic =>
  `(tactic| (braid_unfold cellsAt_cons (k := 4) (w := true) $hq (BitVec.setWidth 64 $x)
               (w32s $xs)
             braid_unfold cellsAt_cons (k := 4) (w := true) $oq $c $cs
             braid_sym_run_to 0x204a8
             braid_unfold mem_interp_bytesAt $oq (bswap (BitVec.setWidth 64 $x) >>> 32#64) 4
               (by decide)
             rw [leBytes_rev $x]
             braid_sym_step))

/-- Forget what the loop leaves in its registers and the flags. -/
local macro "out_forget" : tactic =>
  `(tactic| (braid_forget 8; braid_forget 9; braid_forget 11; braid_forget_flag 0
             braid_forget_flag 1; braid_forget_flag 2; braid_forget_flag 3))

/-- **The loop that writes the digest out as bytes.** The words of the hash value from word
`i` on, at `hq`, are written, each most significant byte first, to the bytes at `oq`. -/
theorem out_loop : ∀ (xs : List W32) (x : W32) (cs : List Word) (c : Word) (i : Nat)
    (oq hq v8 v11 : Word) (fn fz fc fv : Bool) (t : Trace), cs.length = xs.length →
    i + xs.length + 1 = 8 → v8 = BitVec.ofNat 64 i →
    hq = 0x20c70#64 + BitVec.ofNat 64 (4 * i) →
    TripleT ownProgram
      (Atoms.interp [.pc 0x20490#64, .reg x8 v8, .reg x9 (oq + 1#64), .reg x10 0x20c70#64,
        .reg x11 v11, .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 true oq (c :: cs)), .prop (cellsAt 4 true hq (w32s (x :: xs)))]) t
      (Atoms.interp [.pc 0x204ac#64, .prop (regAny x8), .prop (regAny x9),
        .reg x10 0x20c70#64, .prop (regAny x11), .prop (flagAny Flags.n),
        .prop (flagAny Flags.z), .prop (flagAny Flags.c), .prop (flagAny Flags.v),
        .prop (bytesAt oq ((x :: xs).flatMap wordBytes)),
        .prop (cellsAt 4 true hq (w32s (x :: xs)))]) (t ++ outLeak oq hq xs.length) := by
  intro xs
  induction xs with
  | nil =>
    intro x cs c i oq hq v8 v11 fn fz fc fv t hc hi h8 hhq
    have hcs : cs = [] := List.length_eq_zero_iff.1 hc
    subst hcs
    have hq' : hq = 0x20c70#64 + v8 <<< 2#64 := by rw [hhq, shl2, h8]; bv_omega
    subst hq'
    rw [w32s_cons x]
    simp only [List.flatMap_cons, List.flatMap_nil, List.append_nil, List.length_nil, outLeak]
    out_word oq, (0x20c70#64 + v8 <<< 2#64), x, [], c, []
    · exfalso
      simp only [List.length_nil] at hi
      have : v8 + 1#64 = 8#64 := by rw [h8]; bv_omega
      exact hbr this
    · braid_unfold cellsAt_nil (k := 4) (w := true) (oq + 4#64)
      braid_fold cellsAt_cons (k := 4) (w := true) (0x20c70#64 + v8 <<< 2#64)
        (BitVec.setWidth 64 x) (w32s [])
      out_forget
      braid_done
  | cons x' xs ih =>
    intro x cs c i oq hq v8 v11 fn fz fc fv t hc hi h8 hhq
    obtain ⟨c', cs, rfl⟩ : ∃ c' cs', cs = c' :: cs' := by
      cases cs with
      | nil => simp at hc
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at hc hi
    have hq' : hq = 0x20c70#64 + v8 <<< 2#64 := by rw [hhq, shl2, h8]; bv_omega
    subst hq'
    rw [w32s_cons x]
    rw [List.flatMap_cons]
    simp only [List.length_cons, outLeak]
    out_word oq, (0x20c70#64 + v8 <<< 2#64), x, (x' :: xs), c, (c' :: cs)
    · braid_call ih x' cs c' (i + 1) (oq + 4#64) (0x20c70#64 + v8 <<< 2#64 + 4#64) (v8 + 1#64)
        _ _ _ _ _ _ (by omega) (by omega) (by rw [h8]; bv_omega) (by rw [hhq]; bv_omega)
      braid_fold bytesAt_wordBytes oq x ((x' :: xs).flatMap wordBytes)
      braid_fold cellsAt_cons (k := 4) (w := true) (0x20c70#64 + v8 <<< 2#64)
        (BitVec.setWidth 64 x) (w32s (x' :: xs))
      braid_done
    · exfalso
      have : v8 + 1#64 ≠ 8#64 := by rw [h8]; bv_omega
      exact this hbr

end Examples.Sha256Main.Arm
