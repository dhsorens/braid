/-
  Examples.ChaCha20Vec.Arm.LeakBlock

  What `chacha20_block_vec` reveals on AArch64 (`docs/Leakage.md`), as a traced triple: the
  addresses of its loads from the input and of its stores to the output, where the branch
  of its loop goes, and the return address. None of these depends on the sixteen words of
  the state.

  The trace is not written before the proof: `block_vec_run` is a trace together with the
  traced triple that leaves it, and the run finds the trace (`Braid.Logic.Traced`). It binds
  the two pointers and the return address before the pair, and the words of the input, of
  the output and of the vector registers inside it, so that the trace is a function of the
  three addresses alone is checked when the definition is. The loop is `rounds_run` of
  `Examples.ChaCha20Vec.Arm.LeakRound`, used as a call. The traced triple says nothing of
  what is computed, which is `chacha20_block_vec_spec`: the output is left with some
  contents. The theorems about the machine alone are in `Examples.ChaCha20Vec.Arm.Leakage`.

  ## Main definitions

  * `block_vec_run`: the function from its entry to its return, and its trace
  * `blockVecLeak`: what `chacha20_block_vec` reveals, the trace of `block_vec_run`

  ## Main results

  * `blockVecLeak_eq`: the trace, written out: 33 labels
-/

module

public import Examples.ChaCha20Vec.Arm.Block
public import Examples.ChaCha20Vec.Arm.LeakRound
import all Examples.ChaCha20.Common
import Iris.BI.DerivedLaws

@[expose] public section

namespace Examples.ChaCha20Vec.Arm

open Braid Examples Examples.ChaCha20 Lowering.Arm Lowering.Arm.Regs

/-! ## The output, forgotten -/

/-- A word is its two halves, as lanes. -/
theorem pack_halves (w : Word) : pack (w.truncate 32) ((w >>> 32).truncate 32) = w := by
  simp only [pack]
  bv_decide

/-- Eight 64-bit cells are sixteen 32-bit cells, which hold the two halves of each. -/
theorem cells8_halves (p w0 w1 w2 w3 w4 w5 w6 w7 : Word) :
    cellsAt 8 true p [w0, w1, w2, w3, w4, w5, w6, w7] =
      cellsAt 4 true p [w0, w0 >>> 32, w1, w1 >>> 32, w2, w2 >>> 32, w3, w3 >>> 32,
        w4, w4 >>> 32, w5, w5 >>> 32, w6, w6 >>> 32, w7, w7 >>> 32] := by
  rw [cells_packs_truncate 8 p _ rfl]
  simp only [List.map_cons, List.map_nil, packs, pack_halves]

/-- Forget the values of an array, in a traced triple. -/
theorem TripleT.forget_cells {P : Program} {as as' : Atoms} {k n : Nat} {p : Word}
    {vs : List Word} {Q : SProp} {t t' : Trace} (hn : vs.length = n)
    (hupd : as.Upd (.prop (cellsAt k true p vs)) (.prop (cellsAny k p n)) as')
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h.conseq (Iris.BI.sep_mono_left (fun _ hv => ⟨_, ⟨⟨vs, hn⟩, rfl⟩, hv⟩)) .rfl

/-! ## The code -/

/-- **`chacha20_block_vec`, and what it reveals**, from its entry to its return. The two
pointers `out` and `inp` and the return address `r` are bound before the pair, and they
are all the trace may depend on: the sixteen words `s` of the input, what the output holds,
and what `w8`, the vector registers and the flags hold are bound inside it. The output is
left with some contents, which `chacha20_block_vec_spec` gives. -/
def block_vec_run (out inp r : Word) : { ls : Trace // ∀ (s : List W32) (os : List Word)
    (t8 u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' : Word) (fn fz fc fv : Bool)
    (t : Trace), s.length = 16 → os.length = 16 →
    TripleT chacha20_block_vec.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) ::
        [.pc 0x10000#64, .reg x0 out, .reg x1 inp, .reg x8 t8,
        .reg (vlo 0) u0, .reg (vhi 0) u0', .reg (vlo 1) u1, .reg (vhi 1) u1',
        .reg (vlo 2) u2, .reg (vhi 2) u2', .reg (vlo 3) u3, .reg (vhi 3) u3',
        .reg (vlo 4) u4, .reg (vhi 4) u4', .reg (vlo 5) u5, .reg (vhi 5) u5',
        .reg (vlo 6) u6, .reg (vhi 6) u6', .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])) t
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAny 4 out 16) ::
        [.pc r, .reg x0 out, .reg x1 inp, .prop (regAny x8),
        .prop (regAny (vlo 0)), .prop (regAny (vhi 0)), .prop (regAny (vlo 1)),
        .prop (regAny (vhi 1)), .prop (regAny (vlo 2)), .prop (regAny (vhi 2)),
        .prop (regAny (vlo 3)), .prop (regAny (vhi 3)), .prop (regAny (vlo 4)),
        .prop (regAny (vhi 4)), .prop (regAny (vlo 5)), .prop (regAny (vhi 5)),
        .prop (regAny (vlo 6)), .prop (regAny (vhi 6)), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)])) (t ++ ls) } := by
  braid_traced
  intro s os t8 u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' fn fz fc fv t hs hos
  -- The arrays, as eight 64-bit cells each.
  rw [cells_packs 8 inp s hs, packs16 s hs, cells_packs_truncate 8 out os hos,
    packs16 (os.map _) (by rw [List.length_map, hos])]
  braid_unfold cells8 inp _ _ _ _ _ _ _ _
  braid_unfold cells8 out _ _ _ _ _ _ _ _
  -- The loads of the four rows, the count of rounds, and the copy of the first row.
  iterate 4 braid_sym_step
  -- The ten double rounds.
  braid_call (rounds_run 9).2 _ _ _ _ _ _ _ _ u5 u5' u6 u6' 10#32 fn fz fc fv _ rfl
    (by decide)
  arm_name_rows
  -- The sums with the input, the stores, and the return.
  braid_sym_run
  braid_fold cells8 inp _ _ _ _ _ _ _ _
  braid_fold cells8 out _ _ _ _ _ _ _ _
  rw [cells8_halves out]
  apply TripleT.forget_cells (k := 4) (p := out) (n := 16)
  case hupd => braid_upd
  case hn => rfl
  braid_forget 8
  braid_forget (vlo 0)
  braid_forget (vhi 0)
  arm_forget_rows
  braid_done

/-- **What `chacha20_block_vec` reveals**, from its two arguments and the return address:
the trace that `block_vec_run` finds. It is the loads of the four rows of the state from
`inp`, two 64-bit words each; the branch of the loop, ten times; and then the store of the
first row of the sum to `out` and, for each of the other three rows, the loads of the row
of the input again and the stores of the row of the sum; and the return. -/
def blockVecLeak (out inp r : Word) : Trace := (block_vec_run out inp r).1

/-- **The trace of `chacha20_block_vec`, written out.** Eight loads, the branch back to the
head of the loop nine times and the way out of it, and then two stores, and three times two
loads and two stores, all of eight bytes at offsets from the two pointers that are multiples
of eight; and the return. -/
theorem blockVecLeak_eq (out inp r : Word) : blockVecLeak out inp r =
    [.read inp 8, .read (inp + 8#64) 8, .read (inp + 16#64) 8, .read (inp + 24#64) 8,
      .read (inp + 32#64) 8, .read (inp + 40#64) 8, .read (inp + 48#64) 8,
      .read (inp + 56#64) 8,
      .jump 0x10010#64, .jump 0x10010#64, .jump 0x10010#64, .jump 0x10010#64,
      .jump 0x10010#64, .jump 0x10010#64, .jump 0x10010#64, .jump 0x10010#64,
      .jump 0x10010#64, .jump 0x100a8#64,
      .write out 8, .write (out + 8#64) 8,
      .read (inp + 16#64) 8, .read (inp + 24#64) 8,
      .write (out + 16#64) 8, .write (out + 24#64) 8,
      .read (inp + 32#64) 8, .read (inp + 40#64) 8,
      .write (out + 32#64) 8, .write (out + 40#64) 8,
      .read (inp + 48#64) 8, .read (inp + 56#64) 8,
      .write (out + 48#64) 8, .write (out + 56#64) 8,
      .jump r] := rfl

end Examples.ChaCha20Vec.Arm
