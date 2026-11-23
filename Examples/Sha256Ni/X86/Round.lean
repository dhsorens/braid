/-
  Examples.Sha256Ni.X86.Round

  The two loops of `sha256_compress_ni` of `sha256_ni.c` on x86-64. A turn of either is four
  rounds of SHA-256, as two `sha256rnds2`. The compiler keeps the working variables in
  `xmm7`, the vector `(a, b, e, f)`, and `xmm5`, the vector `(c, d, g, h)`, and each
  `sha256rnds2` writes the one that the other reads. The last sixteen words of the schedule
  are in `xmm1`, `xmm9`, `xmm8` and `xmm6`, four words each, oldest first, at the head of
  both loops; `rcx` is sixteen times the number of turns taken, and `rax` the address of the
  table of round constants.

  A turn of the first loop (`step_spec`) adds four round constants to the oldest four words,
  runs four rounds, and computes four new words with `sha256msg1`, `palignr`, `paddd` and
  `sha256msg2`, moving the window on by four. A turn of the second (`tail_spec`) runs four
  rounds and moves the window on without a new word, so that its last register is repeated.
  Each is run symbolically once, with the registers given values of the specification after
  every instruction that computes one, so that no term outlives the instruction that built
  it. The first loop is an induction on the turns left (`loop_spec`), whose invariant is
  `Sha256Ni.steps`; the four turns of the second are called one after another in
  `Examples.Sha256Ni.X86.Compress`.

  ## Main definitions

  * `abefLo`, `abefHi`, `cdghLo`, `cdghHi`: the words of the two vectors of working variables

  ## Main results

  * `step_spec`: a turn of the first loop
  * `loop_spec`: the first loop, from any turn to its end
  * `tail_spec`: a turn of the second loop
-/

module

public import Examples.Sha256Ni.X86.Image
public import Examples.Sha256Ni.X86.Lanes
public import Examples.Sha256.RunTo
import Braid.BV

@[expose] public section

namespace Examples.Sha256Ni.X86

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.X86 Lowering.X86.Regs

/-! ## The working variables in two vector registers -/

/-- The low word of the vector `(a, b, e, f)` of working variables: `f` and `e`. -/
def abefLo (v : Vars) : Word := pack v.f v.e

/-- The high word of the vector `(a, b, e, f)` of working variables: `b` and `a`. -/
def abefHi (v : Vars) : Word := pack v.b v.a

/-- The low word of the vector `(c, d, g, h)` of working variables: `h` and `g`. -/
def cdghLo (v : Vars) : Word := pack v.h v.g

/-- The high word of the vector `(c, d, g, h)` of working variables: `d` and `c`. -/
def cdghHi (v : Vars) : Word := pack v.d v.c

/-! ## Tactics -/

/-- Give a register of the symbolic state the value `v`, which `h` proves equal to the one it
holds: `ni_val r, v, h`. -/
macro "ni_val " r:term ", " v:term ", " h:term : tactic =>
  `(tactic| refine Triple.reg_val (r := $r) $v (by braid_upd) $h ?_)

/-- After a `sha256rnds2`: give the two words `lo` and `hi` of its destination the values of
`h`, a pair of equations for `rnds2Lo` and `rnds2Hi` of the operands. The stepper leaves the
sums of a round associated its own way, and `rnds2Lo` and `rnds2Hi` are brought to the same
form. -/
macro "ni_rnds2 " lo:term ", " hi:term ", " h:term : tactic =>
  `(tactic| (refine Triple.reg_val (r := $lo) _ (by braid_upd) (Eq.trans ?_ ($h).1) ?_
             · simp only [rnds2Lo, rnds2E, rndE, rndT, bigSig, dupLo, BitVec.add_assoc]
             refine Triple.reg_val (r := $hi) _ (by braid_upd) (Eq.trans ?_ ($h).2) ?_
             · simp only [rnds2Hi, rnds2A, rnds2E, rndA, rndE, rndT, bigSig, dupLo,
                 BitVec.add_assoc]))

/-- After the instructions of a turn of either loop: give `rcx` its value, close the table of
round constants, and forget the registers and flags the turn leaves with values of no
use. -/
local macro "turn_finish " wk:term ", " c:term ", " K:term ", " i:term ", " hq:term ", "
    hq0:term ", " hq1:term : tactic =>
  `(tactic| (ni_val 2, ($c + 16#64), (BitVec.add_comm _ _)
             subst_vars
             sha256_fold cells_quad_at $wk 0x402110#64 _ _ $K $i $hq $hq0 $hq1
             braid_forget 32
             braid_forget 33
             braid_forget 48
             braid_forget 49
             x86_forget_all_flags
             braid_done))

/-- An offset into the table of round constants that is a multiple of sixteen is aligned. -/
theorem aligned16 (i : Nat) : BitVec.ofNat 64 (16 * i) &&& 15#64 = 0#64 := by
  rw [BitVec.ofNat_mul]
  generalize BitVec.ofNat 64 i = j
  bv_auto

/-- **A turn of the first loop**, turn `i` of twelve: rounds `4 * i` to `4 * i + 3` on the
working variables `v`, with the first four words of the window `win`, and the window moved
on by four words. It ends at the head of the loop, or after it when `i` is the last turn. -/
theorem step_spec (wk : Bool) (i : Nat) (hi : i < 12) (c : Word)
    (hc : c = BitVec.ofNat 64 (16 * i)) (win : List W32) (hw : win.length = 16) (v : Vars)
    (x0 x0' x2 x2' : Word) (fc fp fa fz fs fo : Bool) :
    Triple sha256_compress_ni.program
      (Atoms.interp [.pc 0x401050#64, .reg rax 0x402110#64, .reg rcx c,
        .reg (zmm 0 0) x0, .reg (zmm 0 1) x0', .reg (zmm 2 0) x2, .reg (zmm 2 1) x2',
        .reg (zmm 1 0) (rowLo win 0), .reg (zmm 1 1) (rowHi win 0),
        .reg (zmm 9 0) (rowLo win 1), .reg (zmm 9 1) (rowHi win 1),
        .reg (zmm 8 0) (rowLo win 2), .reg (zmm 8 1) (rowHi win 2),
        .reg (zmm 6 0) (rowLo win 3), .reg (zmm 6 1) (rowHi win 3),
        .reg (zmm 5 0) (cdghLo v), .reg (zmm 5 1) (cdghHi v),
        .reg (zmm 7 0) (abefLo v), .reg (zmm 7 1) (abefHi v),
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (cellsAt 8 wk 0x402110#64 (packs K))])
      (Atoms.interp [.pc (if i = 11 then 0x40109a#64 else 0x401050#64),
        .reg rax 0x402110#64, .reg rcx (c + 16#64),
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)),
        .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .reg (zmm 1 0) (rowLo (slide4 win) 0), .reg (zmm 1 1) (rowHi (slide4 win) 0),
        .reg (zmm 9 0) (rowLo (slide4 win) 1), .reg (zmm 9 1) (rowHi (slide4 win) 1),
        .reg (zmm 8 0) (rowLo (slide4 win) 2), .reg (zmm 8 1) (rowHi (slide4 win) 2),
        .reg (zmm 6 0) (rowLo (slide4 win) 3), .reg (zmm 6 1) (rowHi (slide4 win) 3),
        .reg (zmm 5 0) (cdghLo (rounds4At (4 * i) 0 win v)),
        .reg (zmm 5 1) (cdghHi (rounds4At (4 * i) 0 win v)),
        .reg (zmm 7 0) (abefLo (rounds4At (4 * i) 0 win v)),
        .reg (zmm 7 1) (abefHi (rounds4At (4 * i) 0 win v)),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 8 wk 0x402110#64 (packs K))]) := by
  obtain ⟨w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, rfl⟩ :=
    eq_of_length_16 hw
  obtain ⟨a, b, cc, d, e, f, g, h⟩ := v
  have ha : c &&& 15#64 = 0#64 := hc ▸ aligned16 i
  rw [slide4_eq]
  simp only [rowLo, rowHi, abefLo, abefHi, cdghLo, cdghHi, rounds4At, List.getD_cons_succ,
    List.getD_cons_zero, Nat.reduceMul, Nat.reduceAdd]
  have hq : 4 * i + 3 < K.length := by show 4 * i + 3 < 64; omega
  have hq0 : c + 0x402110#64 = 0x402110#64 + BitVec.ofNat 64 (16 * i) := by
    rw [hc, BitVec.add_comm]
  have hq1 : c + 0x402118#64 = 0x402110#64 + BitVec.ofNat 64 (16 * i + 8) := by
    rw [hc, BitVec.ofNat_add]
    generalize BitVec.ofNat 64 (16 * i) = z
    bv_auto
  braid_unfold cells_quad_at wk 0x402110#64 (c + 0x402110#64) (c + 0x402118#64) K i hq hq0 hq1
  generalize hk0 : K.getD (4 * i) 0 = k0
  generalize hk1 : K.getD (4 * i + 1) 0 = k1
  generalize hk2 : K.getD (4 * i + 2) 0 = k2
  generalize hk3 : K.getD (4 * i + 3) 0 = k3
  obtain ⟨V, hV⟩ : ∃ V, V = rounds4 (k0 + w0) (k1 + w1) (k2 + w2) (k3 + w3)
    ⟨a, b, cc, d, e, f, g, h⟩ := ⟨_, rfl⟩
  rw [← hV]
  -- The four sums, and the first two rounds.
  iterate 6 braid_sym_step
  simp only [pack_add]
  braid_sym_step
  have h1 := rnds2_pack a b cc d e f g h (k0 + w0) (k1 + w1)
  ni_rnds2 72, 73, h1
  clear h1
  obtain ⟨R, hR⟩ : ∃ R, R = roundS (k1 + w1) (roundS (k0 + w0)
    ⟨a, b, cc, d, e, f, g, h⟩) := ⟨_, rfl⟩
  rw [← hR]
  -- The other two sums brought down, and the last two rounds.
  braid_sym_step
  ni_val 32, _, shuf_high _
  braid_sym_step
  have h2 : rnds2Lo (pack R.f R.e) (pack f e) (pack b a) (pack (k2 + w2) (k3 + w3)) =
        pack V.f V.e ∧
      rnds2Hi (pack R.f R.e) (pack R.b R.a) (pack f e) (pack b a)
          (pack (k2 + w2) (k3 + w3)) = pack V.b V.a := by
    rw [hV, hR]
    exact rnds2_pack _ _ a b _ _ e f (k2 + w2) (k3 + w3)
  ni_rnds2 88, 89, h2
  clear h2
  ni_val 72, pack V.h V.g, (by rw [hV, hR]; rfl)
  ni_val 73, pack V.d V.c, (by rw [hV, hR]; rfl)
  -- Four new words of the schedule.
  iterate 4 braid_sym_step
  simp only [pack_ext, sig0_pack, sig1_pack, pack_add]
  ni_val 80, pack (smallSigma1 w14 + w9 + smallSigma0 w1 + w0)
    (smallSigma1 w15 + w10 + smallSigma0 w2 + w1), (by ac_rfl)
  ni_val 81, pack
    (smallSigma1 (smallSigma1 w14 + w9 + smallSigma0 w1 + w0) + w11 + smallSigma0 w3 + w2)
    (smallSigma1 (smallSigma1 w15 + w10 + smallSigma0 w2 + w1) + w12 + smallSigma0 w4 + w3),
    (by ac_rfl)
  braid_sym_run
  · have h11 : i ≠ 11 := by
      rintro rfl
      exact hbr (by subst hc; decide)
    simp only [h11, ↓reduceIte]
    turn_finish wk, c, K, i, hq, hq0, hq1
  · obtain rfl : i = 11 := by bv_omega
    simp only [↓reduceIte]
    turn_finish wk, c, K, 11, hq, hq0, hq1

/-- **The first loop**, from turn `i` to the last, with `n` turns after this one: an induction
on `n`, each turn `step_spec`. It leaves the window and the working variables that
`Sha256Ni.steps` gives. -/
theorem loop_spec (wk : Bool) : ∀ (n i : Nat) (c : Word) (win : List W32) (v : Vars)
    (x0 x0' x2 x2' : Word) (fc fp fa fz fs fo : Bool), i + n + 1 = 12 →
    c = BitVec.ofNat 64 (16 * i) → win.length = 16 →
    Triple sha256_compress_ni.program
      (Atoms.interp [.pc 0x401050#64, .reg rax 0x402110#64, .reg rcx c,
        .reg (zmm 0 0) x0, .reg (zmm 0 1) x0', .reg (zmm 2 0) x2, .reg (zmm 2 1) x2',
        .reg (zmm 1 0) (rowLo win 0), .reg (zmm 1 1) (rowHi win 0),
        .reg (zmm 9 0) (rowLo win 1), .reg (zmm 9 1) (rowHi win 1),
        .reg (zmm 8 0) (rowLo win 2), .reg (zmm 8 1) (rowHi win 2),
        .reg (zmm 6 0) (rowLo win 3), .reg (zmm 6 1) (rowHi win 3),
        .reg (zmm 5 0) (cdghLo v), .reg (zmm 5 1) (cdghHi v),
        .reg (zmm 7 0) (abefLo v), .reg (zmm 7 1) (abefHi v),
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (cellsAt 8 wk 0x402110#64 (packs K))])
      (Atoms.interp [.pc 0x40109a#64, .reg rax 0x402110#64, .reg rcx 192#64,
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)),
        .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .reg (zmm 1 0) (rowLo (steps (4 * i) (n + 1) win v).1 0),
        .reg (zmm 1 1) (rowHi (steps (4 * i) (n + 1) win v).1 0),
        .reg (zmm 9 0) (rowLo (steps (4 * i) (n + 1) win v).1 1),
        .reg (zmm 9 1) (rowHi (steps (4 * i) (n + 1) win v).1 1),
        .reg (zmm 8 0) (rowLo (steps (4 * i) (n + 1) win v).1 2),
        .reg (zmm 8 1) (rowHi (steps (4 * i) (n + 1) win v).1 2),
        .reg (zmm 6 0) (rowLo (steps (4 * i) (n + 1) win v).1 3),
        .reg (zmm 6 1) (rowHi (steps (4 * i) (n + 1) win v).1 3),
        .reg (zmm 5 0) (cdghLo (steps (4 * i) (n + 1) win v).2),
        .reg (zmm 5 1) (cdghHi (steps (4 * i) (n + 1) win v).2),
        .reg (zmm 7 0) (abefLo (steps (4 * i) (n + 1) win v).2),
        .reg (zmm 7 1) (abefHi (steps (4 * i) (n + 1) win v).2),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 8 wk 0x402110#64 (packs K))]) := by
  intro n
  induction n with
  | zero =>
    intro i c win v x0 x0' x2 x2' fc fp fa fz fs fo hn hc hw
    obtain rfl : i = 11 := by omega
    rw [steps_succ, steps_zero]
    braid_call step_spec wk 11 (by omega) c hc win hw v x0 x0' x2 x2' fc fp fa fz fs fo
    ni_val 2, 192#64, (by subst hc; decide)
    braid_done
  | succ n ih =>
    intro i c win v x0 x0' x2 x2' fc fp fa fz fs fo hn hc hw
    have h11 : i ≠ 11 := by omega
    rw [steps_succ, show 4 * i + 4 = 4 * (i + 1) by omega]
    braid_call step_spec wk i (by omega) c hc win hw v x0 x0' x2 x2' fc fp fa fz fs fo
    simp only [h11, ↓reduceIte]
    braid_name_reg 32
    braid_name_reg 33
    braid_name_reg 48
    braid_name_reg 49
    x86_name_all_flags
    braid_call ih (i + 1) (c + 16#64) (slide4 win) (rounds4At (4 * i) 0 win v) _ _ _ _ _ _ _ _
      _ _ (by omega) (by rw [hc, Nat.mul_succ, BitVec.ofNat_add]) (slide4_length win hw)
    braid_done

/-- **A turn of the second loop**, turn `j` of four: rounds `4 * (12 + j)` to
`4 * (12 + j) + 3` on the working variables `v`, with the words `4 * j` to `4 * j + 3` of
the list `W`, which `xmm1` holds. No word of the schedule is computed: the registers of the
window move on by one, whatever they hold, and the last is repeated. It ends at the head of
the loop, or after it when `j` is the last turn. -/
theorem tail_spec (wk : Bool) (j : Nat) (hj : j < 4) (c : Word)
    (hc : c = BitVec.ofNat 64 (16 * j)) (W : List W32) (v : Vars)
    (x0 x0' x2 x2' y9 y9' y8 y8' y6 y6' : Word) (fc fp fa fz fs fo : Bool) :
    Triple sha256_compress_ni.program
      (Atoms.interp [.pc 0x4010a0#64, .reg rax 0x402110#64, .reg rcx c,
        .reg (zmm 0 0) x0, .reg (zmm 0 1) x0', .reg (zmm 2 0) x2, .reg (zmm 2 1) x2',
        .reg (zmm 1 0) (rowLo W j), .reg (zmm 1 1) (rowHi W j),
        .reg (zmm 9 0) y9, .reg (zmm 9 1) y9', .reg (zmm 8 0) y8, .reg (zmm 8 1) y8',
        .reg (zmm 6 0) y6, .reg (zmm 6 1) y6',
        .reg (zmm 5 0) (cdghLo v), .reg (zmm 5 1) (cdghHi v),
        .reg (zmm 7 0) (abefLo v), .reg (zmm 7 1) (abefHi v),
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (cellsAt 8 wk 0x402110#64 (packs K))])
      (Atoms.interp [.pc (if j = 3 then 0x4010d7#64 else 0x4010a0#64),
        .reg rax 0x402110#64, .reg rcx (c + 16#64),
        .prop (regAny (zmm 0 0)), .prop (regAny (zmm 0 1)),
        .prop (regAny (zmm 2 0)), .prop (regAny (zmm 2 1)),
        .reg (zmm 1 0) y9, .reg (zmm 1 1) y9', .reg (zmm 9 0) y8, .reg (zmm 9 1) y8',
        .reg (zmm 8 0) y6, .reg (zmm 8 1) y6', .reg (zmm 6 0) y6, .reg (zmm 6 1) y6',
        .reg (zmm 5 0) (cdghLo (rounds4At (4 * (12 + j)) (4 * j) W v)),
        .reg (zmm 5 1) (cdghHi (rounds4At (4 * (12 + j)) (4 * j) W v)),
        .reg (zmm 7 0) (abefLo (rounds4At (4 * (12 + j)) (4 * j) W v)),
        .reg (zmm 7 1) (abefHi (rounds4At (4 * (12 + j)) (4 * j) W v)),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 8 wk 0x402110#64 (packs K))]) := by
  obtain ⟨a, b, cc, d, e, f, g, h⟩ := v
  have ha : c &&& 15#64 = 0#64 := hc ▸ aligned16 j
  simp only [rowLo, rowHi, abefLo, abefHi, cdghLo, cdghHi, rounds4At]
  have hq : 4 * (12 + j) + 3 < K.length := by show 4 * (12 + j) + 3 < 64; omega
  have hq0 : c + 0x4021d0#64 = 0x402110#64 + BitVec.ofNat 64 (16 * (12 + j)) := by
    rw [hc, Nat.mul_add, BitVec.ofNat_add]
    generalize BitVec.ofNat 64 (16 * j) = z
    bv_auto
  have hq1 : c + 0x4021d8#64 = 0x402110#64 + BitVec.ofNat 64 (16 * (12 + j) + 8) := by
    rw [hc, Nat.mul_add, BitVec.ofNat_add, BitVec.ofNat_add]
    generalize BitVec.ofNat 64 (16 * j) = z
    bv_auto
  braid_unfold cells_quad_at wk 0x402110#64 (c + 0x4021d0#64) (c + 0x4021d8#64) K (12 + j)
    hq hq0 hq1
  generalize hk0 : K.getD (4 * (12 + j)) 0 = k0
  generalize hk1 : K.getD (4 * (12 + j) + 1) 0 = k1
  generalize hk2 : K.getD (4 * (12 + j) + 2) 0 = k2
  generalize hk3 : K.getD (4 * (12 + j) + 3) 0 = k3
  generalize hp0 : W.getD (4 * j) 0 = p0
  generalize hp1 : W.getD (4 * j + 1) 0 = p1
  generalize hp2 : W.getD (4 * j + 2) 0 = p2
  generalize hp3 : W.getD (4 * j + 3) 0 = p3
  obtain ⟨V, hV⟩ : ∃ V, V = rounds4 (k0 + p0) (k1 + p1) (k2 + p2) (k3 + p3)
    ⟨a, b, cc, d, e, f, g, h⟩ := ⟨_, rfl⟩
  rw [← hV]
  -- The four sums, and the last two of them brought down.
  braid_sym_step
  ni_val 40, pack (k0 + p0) (k1 + p1), (by rw [lanes_add_comm, pack_add])
  ni_val 41, pack (k2 + p2) (k3 + p3), (by rw [lanes_add_comm, pack_add])
  braid_sym_step
  ni_val 48, _, shuf_high _
  -- The window moved on, and the first two rounds.
  iterate 4 braid_sym_step
  have h1 := rnds2_pack a b cc d e f g h (k0 + p0) (k1 + p1)
  ni_rnds2 72, 73, h1
  clear h1
  obtain ⟨R, hR⟩ : ∃ R, R = roundS (k1 + p1) (roundS (k0 + p0)
    ⟨a, b, cc, d, e, f, g, h⟩) := ⟨_, rfl⟩
  rw [← hR]
  -- The last two rounds.
  iterate 2 braid_sym_step
  have h2 : rnds2Lo (pack R.f R.e) (pack f e) (pack b a) (pack (k2 + p2) (k3 + p3)) =
        pack V.f V.e ∧
      rnds2Hi (pack R.f R.e) (pack R.b R.a) (pack f e) (pack b a)
          (pack (k2 + p2) (k3 + p3)) = pack V.b V.a := by
    rw [hV, hR]
    exact rnds2_pack _ _ a b _ _ e f (k2 + p2) (k3 + p3)
  ni_rnds2 88, 89, h2
  clear h2
  ni_val 72, pack V.h V.g, (by rw [hV, hR]; rfl)
  ni_val 73, pack V.d V.c, (by rw [hV, hR]; rfl)
  braid_sym_run
  · have h3 : j ≠ 3 := by
      rintro rfl
      exact hbr (by subst hc; decide)
    simp only [h3, ↓reduceIte]
    turn_finish wk, c, K, (12 + j), hq, hq0, hq1
  · obtain rfl : j = 3 := by bv_omega
    simp only [↓reduceIte]
    turn_finish wk, c, K, (12 + 3), hq, hq0, hq1

end Examples.Sha256Ni.X86
