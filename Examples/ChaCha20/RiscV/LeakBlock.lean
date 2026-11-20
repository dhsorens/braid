/-
  Examples.ChaCha20.RiscV.LeakBlock

  What `chacha20_block` reveals on RISC-V (`docs/Leakage.md`), as a traced triple: the
  addresses of its frame, of the input and of the output, where the branches of its three
  loops go, and the return address. None of these depends on the sixteen words of the state,
  so the function that gives the trace, `blockLeak`, does not take them.

  The code is run in the four parts of `Examples.ChaCha20.RiscV.Block`, with the loop of
  rounds from `Examples.ChaCha20.RiscV.LeakRound`. The traced triples here say nothing of
  what is computed, which is `chacha20_block_spec`: the output and the frame are left with
  some contents. The theorems about the machine alone are in
  `Examples.ChaCha20.RiscV.Leakage`.

  ## Main definitions

  * `block_head_run`, `block_stores_run`, `block_sum_run`: the trace of each part of the
    code, found by its run, with the traced triple
  * `block_run`: the trace of `chacha20_block`, found by its run, with the traced triple; it
    is a function of its two pointers, the stack pointer and the return address
  * `blockLeak`: what `chacha20_block` reveals, which is that trace

  ## Main results

  * `TripleT.forget_cells`: forget the values of an array, a rule that belongs with the logic
  * `trace_start`, `trace_snoc`: the labels of a long run, gathered one at a time
-/

module

public import Braid.Logic.Traced
public import Examples.ChaCha20.RiscV.Block
public import Examples.ChaCha20.RiscV.LeakRound
import all Examples.ChaCha20.Common
import Iris.BI.DerivedLaws

@[expose] public section

namespace Examples.ChaCha20.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- A round of the loop that copies the input to the frame: five instructions, the last a
branch, and the side of it that leaves the loop, which is refuted. The trace to be found is
among the goals, after these two, so the side that stays is brought back to the front. -/
local macro "copy_round" : tactic =>
  `(tactic| (iterate 5 braid_sym_step
             rotate_left
             focus (exact add_lit_ne (by decide) $(Lean.mkIdent `hbr))
             rotate_right))

/-- A round of the loop that adds the input to the state: eight instructions, the last a
branch, and the side of it that leaves the loop, which is refuted. The trace to be found is
among the goals, after these two, so the side that stays is brought back to the front. -/
local macro "add_round" : tactic =>
  `(tactic| (iterate 8 braid_sym_step
             rotate_left
             focus (exact add_lit_ne (by decide) $(Lean.mkIdent `hbr))
             rotate_right))

/-! ## Rules that the logic has for triples without a trace -/

/-- Forget the values of an array: `Triple.forget_cells`, with a trace. -/
theorem TripleT.forget_cells {P : Program} {as as' : Atoms} {k n : Nat} {p : Word}
    {vs : List Word} {Q : SProp} {t t' : Trace} (hn : vs.length = n)
    (hupd : as.Upd (.prop (cellsAt k true p vs)) (.prop (cellsAny k p n)) as')
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h.conseq (Iris.BI.sep_mono_left (fun _ hv => ⟨_, ⟨⟨vs, hn⟩, rfl⟩, hv⟩)) .rfl

/-- The trace a run has left, `x`, is `t` and then some labels, if it is so with no labels
after it: the first step of finding the labels of a long run. -/
theorem trace_start {x t ls : Trace} (h : x ++ [] = t ++ ls) : x = t ++ ls := by
  rwa [List.append_nil] at h

/-- The last label the stepper added goes to the front of the labels already gathered. -/
theorem trace_snoc {x t ls acc : Trace} {l : Label} (h : x ++ l :: acc = t ++ ls) :
    x ++ [l] ++ acc = t ++ ls := by
  rwa [List.append_assoc]

/-- `braid_done` for a long run, whose state is the `n` atoms of the postcondition in
another order. The labels are gathered from the last to the first, one rule for each, so
that the trace the stepper has left is not reassociated as a whole. -/
local macro "done_long " n:num : tactic =>
  `(tactic| (braid_norm
             refine TripleT.done_split ?_ ?_
             · iterate $n (apply Atoms.Split.cons; · braid_extract)
               exact Atoms.Split.nil
             · apply trace_start
               repeat apply trace_snoc
               rfl))

/-! ## The code -/

/-- **The head of `chacha20_block` and the trace of its run**, to the head of the loop of
rounds. The trace found is a function of the address of the input and the stack pointer:
the five stores that save registers below the stack pointer; for each of the sixteen words,
the address it is read from in the input, the address it is written to in the frame, and
where the branch of the loop that copies goes, which is back to its head but for the last;
and the sixteen loads from the frame. The registers of the state are left with what was
loaded, which the trace does not need. -/
def block_head_run (inp sp₀ : Word) : { ls : Trace // ∀ (s : List W32) (fr sv : List Word)
    (u5 u6 u7 v8 v9 u12 u13 u14 u15 u16 u17 v18 v19 v20 u28 u29 u30 u31 : Word)
    (_ : s.length = 16) (_ : fr.length = 16) (_ : sv.length = 5)
    (_ : sp₀ &&& 7#64 = 0#64) (_ : inp &&& 3#64 = 0#64) (t : Trace),
    TripleT chacha20_block.program
      (Atoms.interp [.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))),
        .prop (cellsAt 4 true (sp₀ - 104#64) fr), .prop (cellsAt 8 true (sp₀ - 40#64) sv),
        .pc 0x10074#64, .reg a1 inp, .reg a2 u12, .reg a3 u13, .reg a4 u14,
        .reg a5 u15, .reg a6 u16, .reg a7 u17, .reg t0 u5, .reg t1 u6, .reg t2 u7,
        .reg t3 u28, .reg t4 u29, .reg t5 u30, .reg t6 u31, .reg s0 v8, .reg s1 v9,
        .reg s2 v18, .reg s3 v19, .reg s4 v20, .reg sp sp₀]) t
      (Atoms.interp [.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))),
        .prop (cellsAt 4 true (sp₀ - 104#64) (s.map (BitVec.signExtend 64))),
        .prop (cellsAt 8 true (sp₀ - 40#64) [v20, v19, v18, v9, v8]),
        .pc 0x100f0#64, .reg a1 inp, .reg a2 10#64,
        .prop (regAny s0), .prop (regAny s2), .prop (regAny s3), .prop (regAny s1),
        .prop (regAny t6), .prop (regAny t0), .prop (regAny t1), .prop (regAny t3),
        .prop (regAny a5), .prop (regAny a6), .prop (regAny a3), .prop (regAny a4),
        .prop (regAny t2), .prop (regAny t4), .prop (regAny t5), .prop (regAny a7),
        .reg s4 v20, .reg sp (sp₀ - 112#64)]) (t ++ ls) } := by
  braid_traced
  intro s fr sv u5 u6 u7 v8 v9 u12 u13 u14 u15 u16 u17 v18 v19 v20 u28 u29 u30 u31 hs hfr hsv
    hsp hinp t
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
  obtain ⟨f0, fr0, rfl, hfr0⟩ := exists_cons_of_length hfr
  obtain ⟨f1, fr1, rfl, hfr1⟩ := exists_cons_of_length hfr0
  obtain ⟨f2, fr2, rfl, hfr2⟩ := exists_cons_of_length hfr1
  obtain ⟨f3, fr3, rfl, hfr3⟩ := exists_cons_of_length hfr2
  obtain ⟨f4, fr4, rfl, hfr4⟩ := exists_cons_of_length hfr3
  obtain ⟨f5, fr5, rfl, hfr5⟩ := exists_cons_of_length hfr4
  obtain ⟨f6, fr6, rfl, hfr6⟩ := exists_cons_of_length hfr5
  obtain ⟨f7, fr7, rfl, hfr7⟩ := exists_cons_of_length hfr6
  obtain ⟨f8, fr8, rfl, hfr8⟩ := exists_cons_of_length hfr7
  obtain ⟨f9, fr9, rfl, hfr9⟩ := exists_cons_of_length hfr8
  obtain ⟨f10, fr10, rfl, hfr10⟩ := exists_cons_of_length hfr9
  obtain ⟨f11, fr11, rfl, hfr11⟩ := exists_cons_of_length hfr10
  obtain ⟨f12, fr12, rfl, hfr12⟩ := exists_cons_of_length hfr11
  obtain ⟨f13, fr13, rfl, hfr13⟩ := exists_cons_of_length hfr12
  obtain ⟨f14, fr14, rfl, hfr14⟩ := exists_cons_of_length hfr13
  obtain ⟨f15, fr15, rfl, hfr15⟩ := exists_cons_of_length hfr14
  obtain rfl := List.length_eq_zero_iff.1 hfr15
  obtain ⟨m0, sv0, rfl, hsv0⟩ := exists_cons_of_length hsv
  obtain ⟨m1, sv1, rfl, hsv1⟩ := exists_cons_of_length hsv0
  obtain ⟨m2, sv2, rfl, hsv2⟩ := exists_cons_of_length hsv1
  obtain ⟨m3, sv3, rfl, hsv3⟩ := exists_cons_of_length hsv2
  obtain ⟨m4, sv4, rfl, hsv4⟩ := exists_cons_of_length hsv3
  obtain rfl := List.length_eq_zero_iff.1 hsv4
  simp only [List.map_cons, List.map_nil]
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold saved_cells sp₀ _ _ _ _ _
  -- The frame; the copy of the input, sixteen rounds; the loads.
  iterate 9 braid_sym_step
  iterate 15 copy_round
  iterate 22 braid_sym_step
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold saved_cells sp₀ _ _ _ _ _
  rv_forget_state
  done_long 24

/-- **The stores after the loop of rounds and the trace of their run.** The sixteen
registers of the state are stored to the frame, and `a2` and `a3` are set for the loop that
adds. The trace found is the sixteen addresses in the frame, a function of the stack pointer
alone. -/
def block_stores_run (sp₀ : Word) : { ls : Trace // ∀ (out : Word) (fr : List Word)
    (x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 u12 : Word)
    (_ : fr.length = 16) (_ : sp₀ &&& 7#64 = 0#64) (t : Trace),
    TripleT chacha20_block.program
      (Atoms.interp [.prop (cellsAt 4 true (sp₀ - 104#64) fr),
        .pc 0x10378#64, .reg a0 out, .reg a2 u12,
        .reg s0 x0, .reg s2 x1, .reg s3 x2, .reg s1 x3, .reg t6 x4, .reg t0 x5, .reg t1 x6,
        .reg t3 x7, .reg a5 x8, .reg a6 x9, .reg a3 x10, .reg a4 x11, .reg t2 x12,
        .reg t4 x13, .reg t5 x14, .reg a7 x15, .reg sp (sp₀ - 112#64)]) t
      (Atoms.interp [.prop (cellsAt 4 true (sp₀ - 104#64)
          [x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15]),
        .pc 0x103c0#64, .reg a0 out, .reg a2 (out + 64#64),
        .reg s0 x0, .reg s2 x1, .reg s3 x2, .reg s1 x3, .reg t6 x4, .reg t0 x5, .reg t1 x6,
        .reg t3 x7, .reg a5 x8, .reg a6 x9, .reg a3 (sp₀ - 104#64), .reg a4 x11, .reg t2 x12,
        .reg t4 x13, .reg t5 x14, .reg a7 x15, .reg sp (sp₀ - 112#64)])
      (t ++ ls) } := by
  braid_traced
  intro out fr x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 u12 hfr hsp t
  obtain ⟨f0, fr0, rfl, hfr0⟩ := exists_cons_of_length hfr
  obtain ⟨f1, fr1, rfl, hfr1⟩ := exists_cons_of_length hfr0
  obtain ⟨f2, fr2, rfl, hfr2⟩ := exists_cons_of_length hfr1
  obtain ⟨f3, fr3, rfl, hfr3⟩ := exists_cons_of_length hfr2
  obtain ⟨f4, fr4, rfl, hfr4⟩ := exists_cons_of_length hfr3
  obtain ⟨f5, fr5, rfl, hfr5⟩ := exists_cons_of_length hfr4
  obtain ⟨f6, fr6, rfl, hfr6⟩ := exists_cons_of_length hfr5
  obtain ⟨f7, fr7, rfl, hfr7⟩ := exists_cons_of_length hfr6
  obtain ⟨f8, fr8, rfl, hfr8⟩ := exists_cons_of_length hfr7
  obtain ⟨f9, fr9, rfl, hfr9⟩ := exists_cons_of_length hfr8
  obtain ⟨f10, fr10, rfl, hfr10⟩ := exists_cons_of_length hfr9
  obtain ⟨f11, fr11, rfl, hfr11⟩ := exists_cons_of_length hfr10
  obtain ⟨f12, fr12, rfl, hfr12⟩ := exists_cons_of_length hfr11
  obtain ⟨f13, fr13, rfl, hfr13⟩ := exists_cons_of_length hfr12
  obtain ⟨f14, fr14, rfl, hfr14⟩ := exists_cons_of_length hfr13
  obtain ⟨f15, fr15, rfl, hfr15⟩ := exists_cons_of_length hfr14
  obtain rfl := List.length_eq_zero_iff.1 hfr15
  braid_unfold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  iterate 18 braid_sym_step
  braid_fold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_done

/-- **The end of `chacha20_block` and the trace of its run**, from the loop that adds,
whatever is in the frame and in the input. The trace found is a function of the two
pointers, the stack pointer and the return address: for each of the sixteen words, the
address it is read from in the frame, the address it is read from in the input, the address
it is written to in the output, and where the branch of the loop goes, which is back to its
head but for the last; the five loads that restore registers; and the return address. The
output and the frame are left with some contents. -/
def block_sum_run (out inp sp₀ r : Word) : { ls : Trace // ∀ (s : List W32)
    (os fr : List Word) (m0 m1 m2 m3 m4 u8 u9 u14 u15 u18 u19 u20 : Word)
    (_ : s.length = 16) (_ : os.length = 16) (_ : fr.length = 16)
    (_ : sp₀ &&& 7#64 = 0#64) (_ : inp &&& 3#64 = 0#64) (_ : out &&& 3#64 = 0#64)
    (t : Trace),
    TripleT chacha20_block.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) :: .prop (cellsAt 4 true (sp₀ - 104#64) fr) ::
        .prop (cellsAt 8 true (sp₀ - 40#64) [m0, m1, m2, m3, m4]) ::
        [.pc 0x103c0#64, .reg a0 out, .reg a1 inp, .reg a2 (out + 64#64),
        .reg a3 (sp₀ - 104#64), .reg a4 u14, .reg a5 u15, .reg s0 u8, .reg s1 u9,
        .reg s2 u18, .reg s3 u19, .reg s4 u20, .reg sp (sp₀ - 112#64), .reg ra r])) t
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAny 4 out 16) :: .prop (cellsAny 4 (sp₀ - 104#64) 16) ::
        .prop (cellsAt 8 true (sp₀ - 40#64) [m0, m1, m2, m3, m4]) ::
        [.pc (r &&& ~~~1#64),
        .prop (regAny a0), .prop (regAny a1), .prop (regAny a2), .prop (regAny a3),
        .prop (regAny a4), .prop (regAny a5),
        .reg s0 m4, .reg s1 m3, .reg s2 m2, .reg s3 m1, .reg s4 m0, .reg sp sp₀,
        .reg ra r])) (t ++ ls) } := by
  braid_traced
  intro s os fr m0 m1 m2 m3 m4 u8 u9 u14 u15 u18 u19 u20 hs hos hfr hsp hinp hout t
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
  obtain ⟨f0, fr0, rfl, hfr0⟩ := exists_cons_of_length hfr
  obtain ⟨f1, fr1, rfl, hfr1⟩ := exists_cons_of_length hfr0
  obtain ⟨f2, fr2, rfl, hfr2⟩ := exists_cons_of_length hfr1
  obtain ⟨f3, fr3, rfl, hfr3⟩ := exists_cons_of_length hfr2
  obtain ⟨f4, fr4, rfl, hfr4⟩ := exists_cons_of_length hfr3
  obtain ⟨f5, fr5, rfl, hfr5⟩ := exists_cons_of_length hfr4
  obtain ⟨f6, fr6, rfl, hfr6⟩ := exists_cons_of_length hfr5
  obtain ⟨f7, fr7, rfl, hfr7⟩ := exists_cons_of_length hfr6
  obtain ⟨f8, fr8, rfl, hfr8⟩ := exists_cons_of_length hfr7
  obtain ⟨f9, fr9, rfl, hfr9⟩ := exists_cons_of_length hfr8
  obtain ⟨f10, fr10, rfl, hfr10⟩ := exists_cons_of_length hfr9
  obtain ⟨f11, fr11, rfl, hfr11⟩ := exists_cons_of_length hfr10
  obtain ⟨f12, fr12, rfl, hfr12⟩ := exists_cons_of_length hfr11
  obtain ⟨f13, fr13, rfl, hfr13⟩ := exists_cons_of_length hfr12
  obtain ⟨f14, fr14, rfl, hfr14⟩ := exists_cons_of_length hfr13
  obtain ⟨f15, fr15, rfl, hfr15⟩ := exists_cons_of_length hfr14
  obtain rfl := List.length_eq_zero_iff.1 hfr15
  simp only [List.map_cons, List.map_nil]
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold saved_cells sp₀ _ _ _ _ _
  -- The sum with the input, sixteen rounds; the return.
  iterate 15 add_round
  braid_sym_run
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold saved_cells sp₀ _ _ _ _ _
  apply TripleT.forget_cells (k := 4) (p := out) (n := 16)
  case hupd => braid_upd
  case hn => rfl
  apply TripleT.forget_cells (k := 4) (p := sp₀ + 18446744073709551512#64) (n := 16)
  case hupd => braid_upd
  case hn => rfl
  braid_forget 10
  braid_forget 11
  braid_forget 12
  braid_forget 13
  braid_forget 14
  braid_forget 15
  done_long 18

/-- **`chacha20_block` and the trace of its run**, whatever the sixteen words of the input
are. The trace found is a function of its two arguments, the stack pointer and the return
address, which are bound before it, and of nothing else. Both arguments must be multiples
of 4 and the stack pointer a multiple of 8, with 104 bytes below it. The output and the
frame are left with some contents, which `chacha20_block_spec` gives; the registers `s0` to
`s4` and the stack pointer are restored. -/
def block_run (out inp sp₀ r : Word) : { ls : Trace // ∀ (s : List W32)
    (os fr sv : List Word)
    (u5 u6 u7 v8 v9 u12 u13 u14 u15 u16 u17 v18 v19 v20 u28 u29 u30 u31 : Word)
    (_ : s.length = 16) (_ : os.length = 16) (_ : fr.length = 16) (_ : sv.length = 5)
    (_ : sp₀ &&& 7#64 = 0#64) (_ : inp &&& 3#64 = 0#64) (_ : out &&& 3#64 = 0#64)
    (t : Trace),
    TripleT chacha20_block.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) :: .prop (cellsAt 4 true (sp₀ - 104#64) fr) ::
        .prop (cellsAt 8 true (sp₀ - 40#64) sv) ::
        [.pc 0x10074#64, .reg a0 out, .reg a1 inp, .reg a2 u12, .reg a3 u13, .reg a4 u14,
        .reg a5 u15, .reg a6 u16, .reg a7 u17, .reg t0 u5, .reg t1 u6, .reg t2 u7,
        .reg t3 u28, .reg t4 u29, .reg t5 u30, .reg t6 u31, .reg s0 v8, .reg s1 v9,
        .reg s2 v18, .reg s3 v19, .reg s4 v20, .reg sp sp₀, .reg ra r])) t
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAny 4 out 16) :: .prop (cellsAny 4 (sp₀ - 104#64) 16) ::
        .prop (cellsAt 8 true (sp₀ - 40#64) [v20, v19, v18, v9, v8]) ::
        [.pc (r &&& ~~~1#64),
        .prop (regAny a0), .prop (regAny a1), .prop (regAny a2), .prop (regAny a3),
        .prop (regAny a4), .prop (regAny a5), .prop (regAny a6), .prop (regAny a7),
        .prop (regAny t0), .prop (regAny t1), .prop (regAny t2), .prop (regAny t3),
        .prop (regAny t4), .prop (regAny t5), .prop (regAny t6),
        .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg s3 v19, .reg s4 v20, .reg sp sp₀,
        .reg ra r])) (t ++ ls) } := by
  braid_traced
  intro s os fr sv u5 u6 u7 v8 v9 u12 u13 u14 u15 u16 u17 v18 v19 v20 u28 u29 u30 u31 hs hos
    hfr hsv hsp hinp hout t
  braid_call (block_head_run inp sp₀).2 s fr sv u5 u6 u7 v8 v9 u12 u13 u14 u15 u16 u17 v18 v19
    v20 u28 u29 u30 u31 hs hfr hsv hsp hinp t
  -- The ten double rounds.
  rv_name_state
  have h := fun v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 t =>
    (rounds_run 9).2 v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 10#32 v20 t rfl
      (by decide)
  simp only [show BitVec.signExtend 64 10#32 = 10#64 from by decide] at h
  braid_call h _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  clear h
  -- The stores, and the sum with the input.
  rv_name_state
  braid_name_reg 20
  braid_call (block_stores_run sp₀).2 out (s.map (BitVec.signExtend 64)) _ _ _ _ _ _ _ _ _ _ _
    _ _ _ _ _ _ (by rw [List.length_map, hs]) hsp _
  braid_call (block_sum_run out inp sp₀ r).2 s os
    [_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _]
    v20 v19 v18 v9 v8 _ _ _ _ _ _ _ hs hos rfl hsp hinp hout _
  braid_forget 16
  braid_forget 17
  braid_forget 5
  braid_forget 6
  braid_forget 7
  braid_forget 28
  braid_forget 29
  braid_forget 30
  braid_forget 31
  braid_done

/-- **What `chacha20_block` reveals**: the addresses it works at, which are those of the
output, of the input and of its frame below the stack pointer, where the branches of its
three loops go, which is the same on every run, and the return address. It is the trace
that the run of `block_run` finds, a function of the two pointers, the stack pointer and
the return address, and of nothing else: not of the sixteen words of the state. -/
def blockLeak (out inp sp r : Word) : Trace := (block_run out inp sp r).1

/-- The trace found is those of the four parts, one after another, with ten rounds. -/
example (out inp sp r : Word) : blockLeak out inp sp r =
    (block_head_run inp sp).1 ++ ((rounds_run 9).1 ++
      ((block_stores_run sp).1 ++ (block_sum_run out inp sp r).1)) := rfl


end Examples.ChaCha20.RiscV
