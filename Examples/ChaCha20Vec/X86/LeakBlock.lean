/-
  Examples.ChaCha20Vec.X86.LeakBlock

  What `chacha20_block_vec` reveals on x86-64 (`docs/Leakage.md`), as a traced triple: the
  addresses of its loads from the input and of its stores to the output, where the branch
  of its loop goes, the stack pointer, where `ret` reads the return address, and the return
  address. None of these depends on the sixteen words of the state.

  The trace is not written before the proof: `block_vec_run` is a trace together with the
  traced triple that leaves it, and the run finds the trace (`Braid.Logic.Traced`). It binds
  the two pointers, the stack pointer and the return address before the pair, and the words
  of the input, of the output and of the registers inside it, so that the trace is a
  function of the four addresses alone is checked when the definition is. The loop is
  `rounds_run` of `Examples.ChaCha20Vec.X86.LeakRound`, used as a call. The traced triple
  says nothing of what is computed, which is `chacha20_block_vec_spec`: the output is left
  with some contents. The theorems about the machine alone are in
  `Examples.ChaCha20Vec.X86.Leakage`.

  ## Main definitions

  * `block_vec_run`: the function from its entry to its return, and its trace
  * `blockVecLeak`: what `chacha20_block_vec` reveals, the trace of `block_vec_run`

  ## Main results

  * `pack_halves`, `cells8_halves`: eight 64-bit cells as sixteen 32-bit cells
  * `blockVecLeak_eq`: the trace, written out: 36 labels
-/

module

public import Braid.Logic.Any
public import Examples.ChaCha20Vec.X86.LeakRound
import Braid.BV

@[expose] public section

namespace Examples.ChaCha20Vec.X86

open Braid Examples Examples.ChaCha20 Lowering.X86 Lowering.X86.Regs

/-! ## The output, forgotten -/

/-- A word is its two halves, as lanes. -/
theorem pack_halves (w : Word) : pack (w.truncate 32) ((w >>> 32).truncate 32) = w := by
  simp only [pack]
  bv_auto

/-- Eight 64-bit cells are sixteen 32-bit cells, which hold the two halves of each. -/
theorem cells8_halves (p w0 w1 w2 w3 w4 w5 w6 w7 : Word) :
    cellsAt 8 true p [w0, w1, w2, w3, w4, w5, w6, w7] =
      cellsAt 4 true p [w0, w0 >>> 32, w1, w1 >>> 32, w2, w2 >>> 32, w3, w3 >>> 32,
        w4, w4 >>> 32, w5, w5 >>> 32, w6, w6 >>> 32, w7, w7 >>> 32] := by
  rw [cells_packs_truncate 8 p _ rfl]
  simp only [List.map_cons, List.map_nil, packs, pack_halves]

/-! ## The code -/

/-- **`chacha20_block_vec`, and what it reveals**, from its entry to its return. The two
pointers `out` and `inp`, the stack pointer `sp` and the return address `r` are bound before
the pair, and they are all the trace may depend on: the sixteen words `s` of the input, what
the output holds, and what `eax`, the vector registers and the flags hold are bound inside
it. The output is left with some contents, which `chacha20_block_vec_spec` gives. -/
def block_vec_run (out inp sp r : Word) : { ls : Trace // ∀ (s : List W32) (os : List Word)
    (t0 : Word)
    (v00 v01 v02 v03 v04 v05 v06 v07 v10 v11 v12 v13 v14 v15 v16 v17 : Word)
    (v20 v21 v22 v23 v24 v25 v26 v27 v30 v31 v32 v33 v34 v35 v36 v37 : Word)
    (fp fa fz fs fo : Bool) (t : Trace), s.length = 16 → os.length = 16 →
    TripleT chacha20_block_vec.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) ::
        [.mem sp 8 r true, .pc 0x401000#64, .reg rdi out, .reg rsi inp, .reg rsp sp,
        .reg rax t0,
        .reg (zmm 0 0) v00, .reg (zmm 0 1) v01, .reg (zmm 0 2) v02, .reg (zmm 0 3) v03,
        .reg (zmm 0 4) v04, .reg (zmm 0 5) v05, .reg (zmm 0 6) v06, .reg (zmm 0 7) v07,
        .reg (zmm 1 0) v10, .reg (zmm 1 1) v11, .reg (zmm 1 2) v12, .reg (zmm 1 3) v13,
        .reg (zmm 1 4) v14, .reg (zmm 1 5) v15, .reg (zmm 1 6) v16, .reg (zmm 1 7) v17,
        .reg (zmm 2 0) v20, .reg (zmm 2 1) v21, .reg (zmm 2 2) v22, .reg (zmm 2 3) v23,
        .reg (zmm 2 4) v24, .reg (zmm 2 5) v25, .reg (zmm 2 6) v26, .reg (zmm 2 7) v27,
        .reg (zmm 3 0) v30, .reg (zmm 3 1) v31, .reg (zmm 3 2) v32, .reg (zmm 3 3) v33,
        .reg (zmm 3 4) v34, .reg (zmm 3 5) v35, .reg (zmm 3 6) v36, .reg (zmm 3 7) v37,
        .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz, .flag Flags.sf fs,
        .flag Flags.of fo])) t
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (Braid.cellsAny 4 true out 16) ::
        [.mem sp 8 r true, .pc r, .reg rdi out, .reg rsi inp, .reg rsp (sp + 8#64),
        .prop (regAny rax),
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)),
        .reg (zmm 0 2) 0#64, .reg (zmm 0 3) 0#64, .reg (zmm 0 4) 0#64, .reg (zmm 0 5) 0#64,
        .reg (zmm 0 6) 0#64, .reg (zmm 0 7) 0#64,
        .prop (regAny (zmm 1 0)), .prop (regAny (zmm 1 1)),
        .reg (zmm 1 2) 0#64, .reg (zmm 1 3) 0#64, .reg (zmm 1 4) 0#64, .reg (zmm 1 5) 0#64,
        .reg (zmm 1 6) 0#64, .reg (zmm 1 7) 0#64,
        .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .reg (zmm 2 2) 0#64, .reg (zmm 2 3) 0#64, .reg (zmm 2 4) 0#64, .reg (zmm 2 5) 0#64,
        .reg (zmm 2 6) 0#64, .reg (zmm 2 7) 0#64,
        .prop (regAny (zmm 3 0)), .prop (regAny (zmm 3 1)),
        .reg (zmm 3 2) 0#64, .reg (zmm 3 3) 0#64, .reg (zmm 3 4) 0#64, .reg (zmm 3 5) 0#64,
        .reg (zmm 3 6) 0#64, .reg (zmm 3 7) 0#64,
        .prop (flagAny Flags.pf), .prop (flagAny Flags.af), .prop (flagAny Flags.zf),
        .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])) (t ++ ls) } := by
  braid_traced
  intro s os t0 v00 v01 v02 v03 v04 v05 v06 v07 v10 v11 v12 v13 v14 v15 v16 v17
    v20 v21 v22 v23 v24 v25 v26 v27 v30 v31 v32 v33 v34 v35 v36 v37 fp fa fz fs fo t hs hos
  -- The arrays, as eight 64-bit cells each.
  rw [cells_packs 8 inp s hs, packs16 s hs, cells_packs_truncate 8 out os hos,
    packs16 (os.map _) (by rw [List.length_map, hos])]
  braid_unfold cells8 inp _ _ _ _ _ _ _ _
  braid_unfold cells8 out _ _ _ _ _ _ _ _
  -- The loads of the four rows and the count of rounds.
  iterate 5 braid_sym_step
  -- The ten double rounds.
  braid_call (rounds_run 9).2 _ _ _ _ _ _ _ _ 10#32 fp fa fz fs fo _ rfl (by decide)
  x86_name_rows
  -- The sums with the input, the stores, and the return.
  braid_sym_run
  braid_fold cells8 inp _ _ _ _ _ _ _ _
  braid_fold cells8 out _ _ _ _ _ _ _ _
  rw [cells8_halves out]
  apply TripleT.forget_cells (k := 4) (p := out) 16
  case hupd => braid_upd
  case hn => rfl
  braid_forget 0
  x86_forget_rows
  braid_done

/-- **What `chacha20_block_vec` reveals**, from its two arguments, the stack pointer and the
return address: the trace that `block_vec_run` finds. It is the loads of the four rows of
the state from `inp`, two 64-bit words each; the branch of the loop, ten times; the loads of
the four rows from `inp` again, for the sum; the stores of the four rows of the sum to
`out`; the load of the return address from the stack; and the return. -/
def blockVecLeak (out inp sp r : Word) : Trace := (block_vec_run out inp sp r).1

/-- **The trace of `chacha20_block_vec`, written out.** Eight loads from the input, the
branch back to the head of the loop nine times and the way out of it, the eight loads from
the input again, and eight stores to the output, all of eight bytes at offsets from the two
pointers that are multiples of eight; the load of the return address, eight bytes at the
stack pointer; and the return. -/
theorem blockVecLeak_eq (out inp sp r : Word) : blockVecLeak out inp sp r =
    [.read inp 8, .read (inp + 8#64) 8, .read (inp + 16#64) 8, .read (inp + 24#64) 8,
      .read (inp + 32#64) 8, .read (inp + 40#64) 8, .read (inp + 48#64) 8,
      .read (inp + 56#64) 8,
      .jump 0x401020#64, .jump 0x401020#64, .jump 0x401020#64, .jump 0x401020#64,
      .jump 0x401020#64, .jump 0x401020#64, .jump 0x401020#64, .jump 0x401020#64,
      .jump 0x401020#64, .jump 0x4010d6#64,
      .read inp 8, .read (inp + 8#64) 8, .read (inp + 16#64) 8, .read (inp + 24#64) 8,
      .read (inp + 32#64) 8, .read (inp + 40#64) 8, .read (inp + 48#64) 8,
      .read (inp + 56#64) 8,
      .write out 8, .write (out + 8#64) 8, .write (out + 16#64) 8, .write (out + 24#64) 8,
      .write (out + 32#64) 8, .write (out + 40#64) 8, .write (out + 48#64) 8,
      .write (out + 56#64) 8,
      .read sp 8, .jump r] := rfl

end Examples.ChaCha20Vec.X86
