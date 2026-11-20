/-
  Examples.Sha256Ni.X86.LeakCompress

  What `sha256_compress_ni` reveals on x86-64 (`docs/Leakage.md`), with the trace found by
  the run (`Braid.Logic.Traced`).

  The code neither branches nor indexes on the hash value or on the block: its two loops run
  twelve and four times, the table of round constants is read at offsets that are multiples
  of sixteen, and every other address is an offset from one of the two pointers or the stack
  pointer. So the public inputs are the two pointers, the stack pointer and the return
  address, which are bound before the pair of `compress_ni_run`; the hash value, the block
  and what the registers and flags hold are bound inside it, and the trace found cannot
  depend on them. The two loops are `loop_run` and `tail_run` of
  `Examples.Sha256Ni.X86.LeakRound`, used as calls.

  The run leaves the hash value forgotten: what it holds is `sha256_compress_ni_spec`.

  ## Main definitions

  * `compress_ni_run`: the function from its entry to its return, with what it reveals
  * `compressNiLeak`: what `sha256_compress_ni` reveals

  ## Main results

  * `compressNiLeak_eq`: the trace, written out with the traces of the two loops
-/

module

public import Braid.Logic.Any
public import Examples.Sha256Ni.X86.Compress
public import Examples.Sha256Ni.X86.LeakRound
import Iris.BI.DerivedLaws

@[expose] public section

namespace Examples.Sha256Ni.X86

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.X86 Lowering.X86.Regs

/-- Forget the values of an array, in a traced triple. -/
theorem TripleT.forget_cells {P : Braid.Program} {as as' : Atoms} {k n : Nat} {p : Word}
    {vs : List Word} {Q : SProp} {t t' : Trace} (hn : vs.length = n)
    (hupd : as.Upd (.prop (cellsAt k true p vs)) (.prop (cellsAny k true p n)) as')
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  subst hn
  exact h.conseq (Iris.BI.sep_mono_left (cellsAt_entails_cellsAny p vs)) .rfl

/-- **`sha256_compress_ni`, and what it reveals**, from its entry to its return. The two
pointers `hp` and `mp`, the stack pointer `s` and the return address `r` are bound before
the pair, and they are all the trace may depend on: the hash value `H`, the block `M`,
whether the block and the table are read-only, and what `rax`, `rcx`, the vector registers
and the flags hold are bound inside it. The hash value is left with some contents, which
`sha256_compress_ni_spec` gives. -/
def compress_ni_run (hp mp s r : Word) : { ls : Trace // ∀ (H M : List W32) (wm wk : Bool)
    (t0 t2 u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u8 u8' u9 u9' : Word)
    (c pf af z sg o : Bool) (t : Trace), H.length = 8 → M.length = 16 →
    TripleT sha256_compress_ni.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi hp, .reg rsi mp, .reg rax t0, .reg rcx t2,
        .reg rsp s,
        .reg (zmm 0 0) u0, .reg (zmm 0 1) u0', .reg (zmm 1 0) u1, .reg (zmm 1 1) u1',
        .reg (zmm 2 0) u2, .reg (zmm 2 1) u2', .reg (zmm 3 0) u3, .reg (zmm 3 1) u3',
        .reg (zmm 4 0) u4, .reg (zmm 4 1) u4', .reg (zmm 5 0) u5, .reg (zmm 5 1) u5',
        .reg (zmm 6 0) u6, .reg (zmm 6 1) u6', .reg (zmm 7 0) u7, .reg (zmm 7 1) u7',
        .reg (zmm 8 0) u8, .reg (zmm 8 1) u8', .reg (zmm 9 0) u9, .reg (zmm 9 1) u9',
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x402110#64 (w32s K)), .prop (cellsAt 8 true s [r])]) t
      (Atoms.interp [.pc r, .reg rdi hp, .reg rsi mp, .prop (regAny rax), .prop (regAny rcx),
        .reg rsp (s + 8#64),
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)), .prop (regAny (zmm 1 0)),
        .prop (regAny (zmm 1 1)), .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .prop (regAny (zmm 3 0)), .prop (regAny (zmm 3 1)), .prop (regAny (zmm 4 0)),
        .prop (regAny (zmm 4 1)), .prop (regAny (zmm 5 0)), .prop (regAny (zmm 5 1)),
        .prop (regAny (zmm 6 0)), .prop (regAny (zmm 6 1)), .prop (regAny (zmm 7 0)),
        .prop (regAny (zmm 7 1)), .prop (regAny (zmm 8 0)), .prop (regAny (zmm 8 1)),
        .prop (regAny (zmm 9 0)), .prop (regAny (zmm 9 1)),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 8 true hp 4), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x402110#64 (w32s K)), .prop (cellsAt 8 true s [r])])
      (t ++ ls) } := by
  braid_traced
  intro H M wm wk t0 t2 u0 u0' u1 u1' u2 u2' u3 u3' u4 u4' u5 u5' u6 u6' u7 u7' u8 u8' u9 u9'
    c pf af z sg o t hH hM
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, rfl⟩ := eq_of_length_8 hH
  obtain ⟨m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15, rfl⟩ :=
    eq_of_length_16 hM
  -- The arrays, as 64-bit cells.
  rw [cells_w32_packs true 4 hp _ rfl, cells_w32_packs wm 8 mp _ rfl,
    cells_w32_packs wk 32 0x402110#64 K rfl]
  simp only [packs]
  braid_unfold cells4 true hp _ _ _ _
  braid_unfold cells8x8 wm mp _ _ _ _ _ _ _ _
  braid_unfold cellsAt_cons (k := 8) (w := true) s r []
  -- The hash value and the block loaded, and the count cleared.
  iterate 12 braid_sym_step
  ni_valT 2, BitVec.ofNat 64 (16 * 0), BitVec.xor_self
  braid_sym_run_to 0x401050
  x86_name_all_flags
  -- The first loop.
  braid_call (loop_run 11 0).2 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by omega)
  ni_name_work
  x86_name_all_flags
  -- The count cleared again, and the second loop.
  braid_sym_step
  ni_valT 2, BitVec.ofNat 64 (16 * 0), (by decide)
  braid_sym_step
  x86_name_all_flags
  braid_call (tail_run 3 0).2 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by omega)
  ni_name_work
  x86_name_all_flags
  -- The sum with the hash value, the shuffles, the stores, and the return.
  braid_sym_run
  braid_fold cells4 true hp _ _ _ _
  braid_fold cells8x8 wm mp _ _ _ _ _ _ _ _
  braid_fold cellsAt_cons (k := 8) (w := true) s r []
  apply TripleT.forget_cells (k := 8) (p := hp) (n := 4)
  case hupd => braid_upd
  case hn => rfl
  ni_forget_work
  braid_forget 56
  braid_forget 57
  braid_forget 64
  braid_forget 65
  braid_forget 0
  braid_forget 2
  x86_forget_all_flags
  braid_done

/-- **What `sha256_compress_ni` reveals**, from its two arguments, the stack pointer and the
return address: the trace that `compress_ni_run` finds. It is the loads of the hash value
from `hp` and of the block from `mp`, eight bytes at a time; the loads of the table of
round constants and the branches of the two loops; the stores of the hash value to `hp`; and
the load of the return address from the stack, and the return. -/
def compressNiLeak (hp mp s r : Word) : Trace := (compress_ni_run hp mp s r).1

/-- **The trace of `sha256_compress_ni`, written out**, with the traces of the two loops,
which `loopLeak_zero`, `loopLeak_succ`, `tailLeak_zero` and `tailLeak_succ` give a turn at a
time: four loads of the hash value and eight of the block, twelve turns of the first loop
and four of the second, four stores of the hash value, and the return. -/
theorem compressNiLeak_eq (hp mp s r : Word) : compressNiLeak hp mp s r =
    [.read hp 8, .read (hp + 8#64) 8, .read (hp + 16#64) 8, .read (hp + 24#64) 8,
      .read mp 8, .read (mp + 8#64) 8, .read (mp + 16#64) 8, .read (mp + 24#64) 8,
      .read (mp + 32#64) 8, .read (mp + 40#64) 8, .read (mp + 48#64) 8,
      .read (mp + 56#64) 8] ++ loopLeak 11 0 ++ tailLeak 3 0 ++
    [.write hp 8, .write (hp + 8#64) 8, .write (hp + 16#64) 8, .write (hp + 24#64) 8,
      .read s 8, .jump r] := rfl

end Examples.Sha256Ni.X86
