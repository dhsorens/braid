/-
  Examples.Sha256Main.RiscV.Output

  The loop of `main` that writes the hash value out as bytes, each word most significant
  byte first, on RISC-V.

  ## Main definitions

  * `outLeak`: what the loop reveals

  ## Main results

  * `TripleT.mem1_val`: a one-byte cell of the symbolic state given a value with the same
    low byte
  * `out_loop`: the words at one address written as the bytes at another
-/

module

public import Examples.Sha256Main.RiscV.Blocks

@[expose] public section

namespace Examples.Sha256Main.RiscV

open Braid Examples Examples.Sha256 Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- Replace the value of a one-byte cell of the symbolic state by one with the same low
byte. -/
theorem _root_.Braid.TripleT.mem1_val {P : Program} {as as' : Atoms} {a v : Word} {w : Bool}
    {t t' : Trace} (v' : Word) {Q : SProp} (hupd : as.Upd (.mem a 1 v w) (.mem a 1 v' w) as')
    (he : v.truncate 8 = v'.truncate 8)
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  obtain ⟨F, e, e'⟩ := hupd.split
  have em : (Atom.mem a 1 v w).interp = (Atom.mem a 1 v' w).interp := by
    show memIs a 1 v w = memIs a 1 v' w
    funext h
    simp only [memIs, Heap.bytes_byte a v w, Heap.bytes_byte a v' w, he]
  rw [e, em]; rw [e'] at h
  exact h

/-- Give a one-byte cell of the symbolic state the byte `b`, which is its low byte:
`out_byte a, b`. -/
local macro "out_byte " a:term ", " b:term : tactic =>
  `(tactic| (refine TripleT.mem1_val (a := $a) (BitVec.zeroExtend 64 $b) (by braid_upd) ?_ ?_
             · bv_decide))

theorem w32s_cons (x : W32) (xs : List W32) : w32s (x :: xs) = x.setWidth 64 :: w32s xs := rfl

theorem flatMap_wordBytes_cons (x : W32) (xs : List W32) :
    (x :: xs).flatMap wordBytes =
      (x >>> 24).setWidth 8 :: (x >>> 16).setWidth 8 :: (x >>> 8).setWidth 8 :: x.setWidth 8 ::
        xs.flatMap wordBytes := rfl

/-- What the loop that writes the digest out as bytes reveals, with `n + 1` words to go: the
word read at `hq`, the four bytes written from `oq` on, and the branch. -/
def outLeak (oq hq : Word) : Nat → Trace
  | 0 => [.read hq 4, .write oq 1, .write (oq + 1#64) 1, .write (oq + 2#64) 1,
      .write (oq + 3#64) 1, .jump 0x1061c#64]
  | n + 1 => [.read hq 4, .write oq 1, .write (oq + 1#64) 1, .write (oq + 2#64) 1,
      .write (oq + 3#64) 1, .jump 0x105f0#64] ++ outLeak (oq + 4#64) (hq + 4#64) n

/-- One word of the digest written as four bytes: run the iteration up to its branch, and
give the four cells the bytes of the word. -/
local macro "out_word " oq:term ", " hq:term ", " x:term ", " xs:term ", " zs:term : tactic =>
  `(tactic| (braid_unfold cellsAt_cons (k := 4) (w := true) $hq (BitVec.setWidth 64 $x) (w32s $xs)
             braid_unfold bytesAt_cons $oq _ _
             braid_unfold bytesAt_cons ($oq + 1#64) _ _
             braid_unfold bytesAt_cons ($oq + 2#64) _ _
             braid_unfold bytesAt_cons ($oq + 3#64) _ $zs
             braid_sym_run_to 0x10618
             out_byte $oq, (BitVec.setWidth 8 ($x >>> 24))
             out_byte ($oq + 1#64), (BitVec.setWidth 8 ($x >>> 16))
             out_byte ($oq + 2#64), (BitVec.setWidth 8 ($x >>> 8))
             out_byte ($oq + 3#64), (BitVec.setWidth 8 $x)
             braid_sym_step))

/-- Put the four bytes of a word and the cell it was read from back into their arrays. -/
local macro "out_fold " oq:term ", " hq:term ", " x:term ", " xs:term ", " bs:term : tactic =>
  `(tactic| (braid_fold bytesAt_cons ($oq + 3#64) (BitVec.setWidth 8 $x) $bs
             braid_fold bytesAt_cons ($oq + 2#64) (BitVec.setWidth 8 ($x >>> 8)) _
             braid_fold bytesAt_cons ($oq + 1#64) (BitVec.setWidth 8 ($x >>> 16)) _
             braid_fold bytesAt_cons $oq (BitVec.setWidth 8 ($x >>> 24)) _
             braid_fold cellsAt_cons (k := 4) (w := true) $hq (BitVec.setWidth 64 $x) (w32s $xs)))

/-- **The loop that writes the digest out as bytes.** The words at `hq` are written, each
most significant byte first, to the bytes at `oq`. -/
theorem out_loop (e : Word) : ∀ (xs : List W32) (x : W32) (zs : List (BitVec 8))
    (oq hq x13 x14 x15 x16 : Word) (t : Trace), zs.length = 4 * (xs.length + 1) →
    hq + BitVec.ofNat 64 (4 * (xs.length + 1)) = e → 4 * (xs.length + 1) < 2 ^ 64 →
    hq &&& 3#64 = 0#64 →
    TripleT program
      (Atoms.interp [.pc 0x105f0#64, .reg a0 (oq + 3#64), .reg a1 hq, .reg a2 e, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .prop (bytesAt oq zs),
        .prop (cellsAt 4 true hq (w32s (x :: xs)))]) t
      (Atoms.interp [.pc 0x1061c#64, .prop (regAny a0), .prop (regAny a1), .reg a2 e,
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (bytesAt oq ((x :: xs).flatMap wordBytes)),
        .prop (cellsAt 4 true hq (w32s (x :: xs)))]) (t ++ outLeak oq hq xs.length) := by
  intro xs
  induction xs with
  | nil =>
    intro x zs oq hq x13 x14 x15 x16 t hz he hl hal
    obtain ⟨z0, z1, z2, z3, rfl⟩ : ∃ z0 z1 z2 z3, zs = [z0, z1, z2, z3] := by
      match zs, hz with
      | [z0, z1, z2, z3], _ => exact ⟨z0, z1, z2, z3, rfl⟩
    rw [flatMap_wordBytes_cons x, w32s_cons x]
    simp only [List.flatMap_nil, List.length_nil, outLeak]
    out_word oq, hq, x, [], []
    · exact absurd (by simpa using he) hbr
    · out_fold oq, hq, x, [], []
      braid_forget 10
      braid_forget 11
      braid_forget 13
      braid_forget 14
      braid_forget 15
      braid_forget 16
      braid_done
  | cons x' xs ih =>
    intro x zs oq hq x13 x14 x15 x16 t hz he hl hal
    obtain ⟨z0, z1, z2, z3, zs, rfl⟩ : ∃ z0 z1 z2 z3 zs', zs = z0 :: z1 :: z2 :: z3 :: zs' := by
      match zs, hz with
      | z0 :: z1 :: z2 :: z3 :: zs', _ => exact ⟨z0, z1, z2, z3, zs', rfl⟩
    simp only [List.length_cons] at hz he hl
    rw [flatMap_wordBytes_cons x, w32s_cons x]
    simp only [List.length_cons, outLeak]
    out_word oq, hq, x, (x' :: xs), zs
    · braid_call ih x' zs (oq + 4#64) (hq + 4#64) _ _ _ _ _ (by omega)
        (by rw [← he]; bv_omega) (by omega) (by bv_decide)
      out_fold oq, hq, x, (x' :: xs), ((x' :: xs).flatMap wordBytes)
      braid_done
    · exfalso
      have : hq + 4#64 ≠ e := by rw [← he]; bv_omega
      exact this hbr

end Examples.Sha256Main.RiscV
