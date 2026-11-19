/-
  Examples.ChaCha20.O2.Arm.LeakBlock

  What `chacha20_block` reveals on AArch64, compiled at `-O2` (`docs/Leakage.md`), as a traced
  triple: the addresses of the registers it saves, of the input and of the output, where the
  branch of its loop goes, and the return address. None of these depends on the sixteen words
  of the state, so the function that gives the trace, `blockLeak`, does not take them.

  The trace is not that of `-O1`, because the code is not. At `-O2` there is no copy of the
  state in the frame: the loop that copied the input and the loop that added it are gone, and
  with them thirty-two branches and sixty-four accesses to the frame. What is left is five
  saved registers, sixteen loads of the input in order, the loop of rounds, and sixteen times
  a load of the input and a store to the output. So `blockLeak` is defined again here, in two
  parts where `-O1` has three, and it is still a function of the two pointers, the stack
  pointer and the return address.

  The code is run in three parts: the head, to the loop of rounds; the loop, which is
  `rounds_trace` of `Examples.ChaCha20.O2.Arm.LeakRound`; and the sums with the input, with
  the return. The traced triples here say nothing of what is computed, which is
  `chacha20_block_spec`: the output is left with some contents. The theorems about the
  machine alone are in `Examples.ChaCha20.O2.Arm.Leakage`.

  ## Main definitions

  * `headLeak`, `tailLeak`: what each part of the code reveals
  * `blockLeak`: what `chacha20_block` reveals, from its two pointers, the stack pointer and
    the return address

  ## Main results

  * `block_head_trace`, `block_tail_trace`: the parts
  * `chacha20_block_trace`: the function reveals `blockLeak`
-/

module

public import Examples.ChaCha20.O2.Arm.Block
public import Examples.ChaCha20.O2.Arm.LeakRound
import all Examples.ChaCha20.Common
import Iris.BI.DerivedLaws

@[expose] public section

namespace Examples.ChaCha20.O2.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-! ## What is revealed -/

/-- The head of `chacha20_block`, to the loop of rounds, reveals: the store that saves `x23`
at the foot of the frame, 48 bytes below the stack pointer `sp`; the address each of the
sixteen words of the input is read from, in order; and the four stores, in two pairs, that
save `x19` to `x22`. -/
def headLeak (inp sp : Word) : Trace :=
  [.write (sp - 48#64) 8] ++
  ((List.range 16).map fun i => .read (inp + BitVec.ofNat 64 (4 * i)) 4) ++
  [.write (sp - 32#64) 8, .write (sp - 24#64) 8, .write (sp - 16#64) 8,
    .write (sp - 8#64) 8]

/-- The end of `chacha20_block`, from the end of the loop of rounds, reveals: for each of the
sixteen words, the address it is read from in the input and the address it is written to in
the output, with the four loads, in two pairs, that restore `x19` to `x22` between the first
read and the first write; the load that restores `x23`; and the return address. -/
def tailLeak (out inp sp r : Word) : Trace :=
  [.read inp 4, .read (sp - 16#64) 8, .read (sp - 8#64) 8, .read (sp - 32#64) 8,
    .read (sp - 24#64) 8, .write out 4] ++
  ((List.range 15).flatMap fun i =>
    [.read (inp + BitVec.ofNat 64 (4 * (i + 1))) 4,
      .write (out + BitVec.ofNat 64 (4 * (i + 1))) 4]) ++
  [.read (sp - 48#64) 8, .jump r]

/-- **What `chacha20_block` reveals**: the addresses it works at, which are those of the
output, of the input and of the registers it saves below the stack pointer, where the branch
of its loop goes, which is the same on every run, and the return address. It is a function of
the two pointers, the stack pointer and the return address, and of nothing else: not of the
sixteen words of the state. -/
def blockLeak (out inp sp r : Word) : Trace :=
  headLeak inp sp ++ (roundsLeak 9 ++ tailLeak out inp sp r)

/-! ## Rules that the logic has for triples without a trace -/

/-- Forget the values of an array: `Triple.forget_cells`, with a trace. -/
theorem TripleT.forget_cells {P : Program} {as as' : Atoms} {k n : Nat} {p : Word}
    {vs : List Word} {Q : SProp} {t t' : Trace} (hn : vs.length = n)
    (hupd : as.Upd (.prop (cellsAt k true p vs)) (.prop (cellsAny k p n)) as')
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h.conseq (Iris.BI.sep_mono_left (fun _ hv => ⟨_, ⟨⟨vs, hn⟩, rfl⟩, hv⟩)) .rfl

/-- The symbolic state is the `n` atoms of the postcondition in another order:
`braid_done_perm`, for a traced triple. It leaves the equation between the traces. -/
local macro "done_perm " n:num : tactic =>
  `(tactic| (braid_norm
             refine TripleT.done_split ?_ ?_
             · iterate $n (apply Atoms.Split.cons; · braid_extract)
               exact Atoms.Split.nil))

/-- A trace to which labels were added one at a time, as the stepper adds them, is the
trace with the list of them appended. -/
theorem foldl_snoc_eq (t ls : Trace) : ls.foldl (fun acc l => acc ++ [l]) t = t ++ ls := by
  induction ls generalizing t with
  | nil => simp
  | cons l ls ih => simp [ih]

/-- The trace the stepper has left is the one a specification gives: the specification
alone is written out, with its addresses as the stepper computes them, and the trace the
stepper has left is compared with it label by label, without reassociating it. -/
local macro "leak_eq " d:ident : tactic =>
  `(tactic| (conv =>
               rhs
               arg 2
               simp only [$d:ident, List.range_succ, List.range_zero,
                 List.flatMap_cons, List.flatMap_nil, List.map_cons, List.map_nil,
                 List.append_assoc, List.cons_append, List.nil_append,
                 sub_lit, BitVec.add_assoc, BitVec.reduceAdd, BitVec.reduceNeg, BitVec.reduceNot,
                 BitVec.add_zero, Nat.reduceMul, Nat.reduceAdd, Nat.reduceLT, ↓reduceIte,
                 BitVec.ofNat_eq_ofNat]
             refine Eq.trans ?_ (foldl_snoc_eq _ _)
             simp only [List.foldl_cons, List.foldl_nil]))

/-! ## The code -/

/-- **What the head of `chacha20_block` reveals**, to the head of the loop of rounds:
`headLeak` of the address of the input and the stack pointer, which must be a multiple
of 16. The registers of the state are left with what was loaded, which the trace does not
need. -/
theorem block_head_trace (inp sp₀ : Word) (s : List W32) (sv : List Word)
    (m t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 v19 v20 v21 v22 v23 : Word)
    (hs : s.length = 16) (hsv : sv.length = 4)
    (hsp : sp₀ &&& 15#64 = 0#64) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp [.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))),
        .prop (cellsAt 8 true (sp₀ - 48#64) [m]), .prop (cellsAt 8 true (sp₀ - 32#64) sv),
        .pc 0x10044#64, .reg x1 inp, .reg x8 t8,
        .reg x7 t7, .reg x6 t6, .reg x5 t5, .reg x17 t17, .reg x4 t4, .reg x3 t3,
        .reg x2 t2, .reg x16 t16, .reg x15 t15, .reg x18 t18, .reg x11 t11, .reg x10 t10,
        .reg x14 t14, .reg x13 t13, .reg x12 t12, .reg x9 t9,
        .reg x19 v19, .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg x23 v23,
        .reg sp sp₀]) t
      (Atoms.interp [.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))),
        .prop (cellsAt 8 true (sp₀ - 48#64) [v23]),
        .prop (cellsAt 8 true (sp₀ - 32#64) [v22, v21, v20, v19]),
        .pc 0x10074#64, .reg x1 inp, .reg x8 10#64,
        .prop (regAny x7), .prop (regAny x6), .prop (regAny x5), .prop (regAny x17),
        .prop (regAny x4), .prop (regAny x3), .prop (regAny x2), .prop (regAny x16),
        .prop (regAny x15), .prop (regAny x18), .prop (regAny x11), .prop (regAny x10),
        .prop (regAny x14), .prop (regAny x13), .prop (regAny x12), .prop (regAny x9),
        .reg x19 v19, .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg x23 v23,
        .reg sp (sp₀ - 48#64)]) (t ++ headLeak inp sp₀) := by
  obtain ⟨a0, s0, rfl, hs0⟩ := exists_cons_of_length hs
  obtain ⟨a1, s1, rfl, hs1⟩ := exists_cons_of_length hs0
  obtain ⟨a2, s2, rfl, hs2⟩ := exists_cons_of_length hs1
  obtain ⟨a3, s3, rfl, hs3⟩ := exists_cons_of_length hs2
  obtain ⟨a4, s4, rfl, hs4⟩ := exists_cons_of_length hs3
  obtain ⟨a5, s5, rfl, hs5⟩ := exists_cons_of_length hs4
  obtain ⟨a6, s6, rfl, hs6⟩ := exists_cons_of_length hs5
  obtain ⟨a7, s7, rfl, hs7⟩ := exists_cons_of_length hs6
  obtain ⟨a8, s8, rfl, hs8⟩ := exists_cons_of_length hs7
  obtain ⟨a9, s9, rfl, hs9⟩ := exists_cons_of_length hs8
  obtain ⟨a10, s10, rfl, hs10⟩ := exists_cons_of_length hs9
  obtain ⟨a11, s11, rfl, hs11⟩ := exists_cons_of_length hs10
  obtain ⟨a12, s12, rfl, hs12⟩ := exists_cons_of_length hs11
  obtain ⟨a13, s13, rfl, hs13⟩ := exists_cons_of_length hs12
  obtain ⟨a14, s14, rfl, hs14⟩ := exists_cons_of_length hs13
  obtain ⟨a15, s15, rfl, hs15⟩ := exists_cons_of_length hs14
  obtain rfl := List.length_eq_zero_iff.1 hs15
  obtain ⟨m0, sv0, rfl, hsv0⟩ := exists_cons_of_length hsv
  obtain ⟨m1, sv1, rfl, hsv1⟩ := exists_cons_of_length hsv0
  obtain ⟨m2, sv2, rfl, hsv2⟩ := exists_cons_of_length hsv1
  obtain ⟨m3, sv3, rfl, hsv3⟩ := exists_cons_of_length hsv2
  obtain rfl := List.length_eq_zero_iff.1 hsv3
  simp only [List.map_cons, List.map_nil]
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold foot_cell sp₀ _
  braid_unfold saved_cells sp₀ _ _ _ _
  -- The frame and the loads.
  iterate 12 braid_sym_step
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold foot_cell sp₀ _
  braid_fold saved_cells sp₀ _ _ _ _
  arm_forget_state
  done_perm 28
  leak_eq headLeak

/-- **What the end of `chacha20_block` reveals**, from the end of the loop of rounds:
`tailLeak` of the two pointers, the stack pointer and the return address, whatever is in the
registers of the state and in the input. The output is left with some contents. -/
theorem block_tail_trace (out inp r sp₀ : Word) (s : List W32) (os : List Word)
    (m0 m1 m2 m3 m4 u8 w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 : Word)
    (u19 u20 u21 u22 u23 : Word)
    (hs : s.length = 16) (hos : os.length = 16)
    (hsp : sp₀ &&& 15#64 = 0#64) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) :: .prop (cellsAt 8 true (sp₀ - 48#64) [m4]) ::
        .prop (cellsAt 8 true (sp₀ - 32#64) [m0, m1, m2, m3]) ::
        [.pc 0x101fc#64, .reg x0 out, .reg x1 inp, .reg x8 u8,
        .reg x7 w0, .reg x6 w1, .reg x5 w2, .reg x17 w3, .reg x4 w4, .reg x3 w5,
        .reg x2 w6, .reg x16 w7, .reg x15 w8, .reg x18 w9, .reg x11 w10, .reg x10 w11,
        .reg x14 w12, .reg x13 w13, .reg x12 w14, .reg x9 w15,
        .reg x19 u19, .reg x20 u20, .reg x21 u21, .reg x22 u22, .reg x23 u23,
        .reg sp (sp₀ - 48#64), .reg lr r])) t
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAny 4 out 16) :: .prop (cellsAt 8 true (sp₀ - 48#64) [m4]) ::
        .prop (cellsAt 8 true (sp₀ - 32#64) [m0, m1, m2, m3]) ::
        [.pc r, .reg x0 out, .reg x1 inp, .prop (regAny x8),
        .reg x7 w0, .reg x6 w1, .reg x5 w2, .reg x17 w3, .reg x4 w4, .reg x3 w5,
        .reg x2 w6, .reg x16 w7, .reg x15 w8, .reg x18 w9, .reg x11 w10, .reg x10 w11,
        .reg x14 w12, .reg x13 w13, .reg x12 w14, .reg x9 w15,
        .reg x19 m3, .reg x20 m2, .reg x21 m1, .reg x22 m0, .reg x23 m4, .reg sp sp₀,
        .reg lr r])) (t ++ tailLeak out inp sp₀ r) := by
  obtain ⟨a0, s0, rfl, hs0⟩ := exists_cons_of_length hs
  obtain ⟨a1, s1, rfl, hs1⟩ := exists_cons_of_length hs0
  obtain ⟨a2, s2, rfl, hs2⟩ := exists_cons_of_length hs1
  obtain ⟨a3, s3, rfl, hs3⟩ := exists_cons_of_length hs2
  obtain ⟨a4, s4, rfl, hs4⟩ := exists_cons_of_length hs3
  obtain ⟨a5, s5, rfl, hs5⟩ := exists_cons_of_length hs4
  obtain ⟨a6, s6, rfl, hs6⟩ := exists_cons_of_length hs5
  obtain ⟨a7, s7, rfl, hs7⟩ := exists_cons_of_length hs6
  obtain ⟨a8, s8, rfl, hs8⟩ := exists_cons_of_length hs7
  obtain ⟨a9, s9, rfl, hs9⟩ := exists_cons_of_length hs8
  obtain ⟨a10, s10, rfl, hs10⟩ := exists_cons_of_length hs9
  obtain ⟨a11, s11, rfl, hs11⟩ := exists_cons_of_length hs10
  obtain ⟨a12, s12, rfl, hs12⟩ := exists_cons_of_length hs11
  obtain ⟨a13, s13, rfl, hs13⟩ := exists_cons_of_length hs12
  obtain ⟨a14, s14, rfl, hs14⟩ := exists_cons_of_length hs13
  obtain ⟨a15, s15, rfl, hs15⟩ := exists_cons_of_length hs14
  obtain rfl := List.length_eq_zero_iff.1 hs15
  obtain ⟨o0, os0, rfl, hos0⟩ := exists_cons_of_length hos
  obtain ⟨o1, os1, rfl, hos1⟩ := exists_cons_of_length hos0
  obtain ⟨o2, os2, rfl, hos2⟩ := exists_cons_of_length hos1
  obtain ⟨o3, os3, rfl, hos3⟩ := exists_cons_of_length hos2
  obtain ⟨o4, os4, rfl, hos4⟩ := exists_cons_of_length hos3
  obtain ⟨o5, os5, rfl, hos5⟩ := exists_cons_of_length hos4
  obtain ⟨o6, os6, rfl, hos6⟩ := exists_cons_of_length hos5
  obtain ⟨o7, os7, rfl, hos7⟩ := exists_cons_of_length hos6
  obtain ⟨o8, os8, rfl, hos8⟩ := exists_cons_of_length hos7
  obtain ⟨o9, os9, rfl, hos9⟩ := exists_cons_of_length hos8
  obtain ⟨o10, os10, rfl, hos10⟩ := exists_cons_of_length hos9
  obtain ⟨o11, os11, rfl, hos11⟩ := exists_cons_of_length hos10
  obtain ⟨o12, os12, rfl, hos12⟩ := exists_cons_of_length hos11
  obtain ⟨o13, os13, rfl, hos13⟩ := exists_cons_of_length hos12
  obtain ⟨o14, os14, rfl, hos14⟩ := exists_cons_of_length hos13
  obtain ⟨o15, os15, rfl, hos15⟩ := exists_cons_of_length hos14
  obtain rfl := List.length_eq_zero_iff.1 hos15
  simp only [List.map_cons, List.map_nil]
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold foot_cell sp₀ _
  braid_unfold saved_cells sp₀ _ _ _ _
  -- The sums with the input, sixteen of them, and the return.
  braid_sym_run
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold foot_cell sp₀ _
  braid_fold saved_cells sp₀ _ _ _ _
  apply TripleT.forget_cells (k := 4) (p := out) (n := 16)
  case hupd => braid_upd
  case hn => rfl
  braid_forget 8
  done_perm 31
  leak_eq tailLeak

/-- **What `chacha20_block` reveals**: `blockLeak` of its two arguments, the stack pointer
and the return address, whatever the sixteen words of the input are. The stack pointer must
be a multiple of 16, with 48 bytes below it. The output is left with some contents, which
`chacha20_block_spec` gives; the registers `x19` to `x23` and the stack pointer are
restored. -/
theorem chacha20_block_trace (out inp r sp₀ : Word) (s : List W32) (os sv : List Word)
    (m t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 v19 v20 v21 v22 v23 : Word)
    (fn fz fc fv : Bool) (hs : s.length = 16) (hos : os.length = 16)
    (hsv : sv.length = 4) (hsp : sp₀ &&& 15#64 = 0#64) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) :: .prop (cellsAt 8 true (sp₀ - 48#64) [m]) ::
        .prop (cellsAt 8 true (sp₀ - 32#64) sv) ::
        [.pc 0x10044#64, .reg x0 out, .reg x1 inp,
        .reg x2 t2, .reg x3 t3, .reg x4 t4, .reg x5 t5, .reg x6 t6, .reg x7 t7, .reg x8 t8,
        .reg x9 t9, .reg x10 t10, .reg x11 t11, .reg x12 t12, .reg x13 t13, .reg x14 t14,
        .reg x15 t15, .reg x16 t16, .reg x17 t17, .reg x18 t18,
        .reg x19 v19, .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg x23 v23, .reg sp sp₀,
        .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])) t
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAny 4 out 16) :: .prop (cellsAt 8 true (sp₀ - 48#64) [v23]) ::
        .prop (cellsAt 8 true (sp₀ - 32#64) [v22, v21, v20, v19]) ::
        [.pc r, .reg x0 out, .reg x1 inp,
        .prop (regAny x2), .prop (regAny x3), .prop (regAny x4), .prop (regAny x5),
        .prop (regAny x6), .prop (regAny x7), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .prop (regAny x11), .prop (regAny x12), .prop (regAny x13),
        .prop (regAny x14), .prop (regAny x15), .prop (regAny x16), .prop (regAny x17),
        .prop (regAny x18),
        .reg x19 v19, .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg x23 v23, .reg sp sp₀,
        .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)])) (t ++ blockLeak out inp sp₀ r) := by
  simp only [blockLeak]
  braid_call block_head_trace inp sp₀ s sv m t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14
    t15 t16 t17 t18 v19 v20 v21 v22 v23 hs hsv hsp t
  -- The ten double rounds.
  arm_name_state
  have h := fun v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 fn fz fc fv t =>
    rounds_trace 9 v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 10#32 v19 v20 v21
      v22 v23 fn fz fc fv t rfl (by decide)
  simp only [show BitVec.zeroExtend 64 10#32 = 10#64 from by decide] at h
  braid_call h _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  clear h
  -- The sums with the input.
  arm_name_state
  arm_name_saved
  braid_call block_tail_trace out inp r sp₀ s os v22 v21 v20 v19 v23 _ _ _ _ _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _ _ _ hs hos hsp _
  arm_forget_state
  done_perm 35
  simp only [List.append_assoc]

end Examples.ChaCha20.O2.Arm
