/-
  Examples.Sha256Ni.Arm.Insts

  The four SHA-256 instructions of AArch64 as triples: what a block of the lowered code that
  is one such instruction does to the two words of its destination, in the named functions
  of `Lowering.Arm` (`sha256hLo`, `sha256h2Lo`, `su0Lo`, `su1Lo` and their high words).

  The lowering of `sha256h` is 142 operations, four rounds on eight working words, and the
  symbolic stepper leaves in the destination the term those operations build, in which every
  round appears in the next many times over. So the blocks of these instructions are not run
  by the stepper. `Lowering.Arm.Sha` proves of the operations of each instruction that the
  values 200 and 201 they leave are the named functions of the values they start from
  (`wp_hashWords` and the like), as a consequence of their weakest precondition; the
  operations only compute values, so they always run (`wpOps_pure`), and the two together
  are a rule for the operations in a block (`OpsSpec.words`). A triple for each instruction
  follows, for any program that has the block and any registers, and a proof calls it where
  the instruction occurs. Its check does not depend on the size of anything.

  Nothing here is about SHA-256 beyond the names of the functions: what they compute is in
  `Examples.Sha256Ni.Arm.Lanes`.

  ## Main results

  * `wpOps_pure`: operations that only compute values run, to one outcome
  * `OpsSpec.words`: the rule for the operations of an instruction that leave two named words
  * `sha256h_triple`, `sha256h2_triple`, `sha256su0_triple`, `sha256su1_triple`: the
    instructions
-/

module

public import Lowering.Arm.Sha
public import Braid.Logic

public section

namespace Examples.Sha256Ni.Arm

open Braid Lowering.Arm

/-! ## Operations that only compute values -/

/-- An operation that only computes a value from values: no register, flag or memory is read
or written. -/
@[expose] def pureOp : Op → Bool
  | .const .. => true
  | .un .. => true
  | .bin .. => true
  | _ => false

/-- Operations that only compute values run from any state, to one environment and the same
state. -/
theorem wpOps_pure : ∀ (ops : List Op), (∀ op ∈ ops, pureOp op = true) → ∀ (ρ : Env)
    (σ : State), ∃ ρ', ∀ Q : Env → State → Prop, Q ρ' σ → wpOps ops ρ σ Q
  | [], _, ρ, _ => ⟨ρ, fun _ h => h⟩
  | op :: ops, h, ρ, σ => by
    have h0 := h op List.mem_cons_self
    have ih := fun ρ₁ => wpOps_pure ops (fun o ho => h o (List.mem_cons_of_mem _ ho)) ρ₁ σ
    cases op <;> first | (simp [pureOp] at h0; done) | skip
    case const d v =>
      obtain ⟨ρ', h'⟩ := ih (ρ.set d v)
      exact ⟨ρ', fun Q hq => h' Q hq⟩
    case un d o a =>
      obtain ⟨ρ', h'⟩ := ih (ρ.set d (o.eval (ρ a)))
      exact ⟨ρ', fun Q hq => h' Q hq⟩
    case bin d o a b =>
      obtain ⟨ρ', h'⟩ := ih (ρ.set d (o.eval (ρ a) (ρ b)))
      exact ⟨ρ', fun Q hq => h' Q hq⟩

/-- **Operations that leave two named words.** If the operations `ws` only compute values,
and their weakest precondition says that the values 200 and 201 they leave are `f` and `g`
of the environment they start from, then the operations after them run from an environment
with those two values. -/
theorem OpsSpec.words {ws ops : List Op} {ρ : Env} {as : Atoms} {Φ : Env → Atoms → Prop}
    {f g : Env → Word} (hp : ∀ op ∈ ws, pureOp op = true)
    (hw : ∀ (ρ : Env) (σ : State) (Q : Env → State → Prop), wpOps ws ρ σ Q →
      ∃ ρ', ρ' 200 = f ρ ∧ ρ' 201 = g ρ ∧ Q ρ' σ)
    (h : ∀ ρ', ρ' 200 = f ρ → ρ' 201 = g ρ → OpsSpec ops ρ' as Φ) :
    OpsSpec (ws ++ ops) ρ as Φ := by
  refine ⟨fun R σ hs => wpOps_append.2 ?_⟩
  obtain ⟨ρ₁, h₁⟩ := wpOps_pure ws hp ρ σ
  obtain ⟨ρ', e0, e1, rfl, -⟩ :=
    hw ρ σ _ (h₁ (fun ρ'' σ'' => ρ'' = ρ₁ ∧ σ'' = σ) ⟨rfl, rfl⟩)
  exact h₁ _ ((h ρ' e0 e1).run R σ hs)

theorem hashWords_pure : ∀ op ∈ hashWords, pureOp op = true := by decide +kernel

theorem hash2Words_pure : ∀ op ∈ hash2Words, pureOp op = true := by decide +kernel

theorem su0Words_pure : ∀ op ∈ su0Words, pureOp op = true := by decide +kernel

theorem su1Words_pure : ∀ op ∈ su1Words, pureOp op = true := by decide +kernel

/-! ## The instructions -/

/-- After the operations of an instruction: write its two words, go on to the next
instruction, and say what the destination holds. -/
local macro "inst_finish " e0:ident e1:ident : tactic =>
  `(tactic| (apply OpsSpec.set (by braid_upd)
             apply OpsSpec.set (by braid_upd)
             apply OpsSpec.nil
             apply TermSpec.jump (by braid_upd)
             rw [$e0:ident, $e1:ident]
             exact Triple.done_eq rfl))

/-- **`sha256h`**: a block that is this instruction, in any program, writes `sha256hLo` and
`sha256hHi` to the two words of its destination, which holds the working variables `a` to
`d`. The first source holds `e` to `h`, and the second the four sums of a round constant and
a word of the schedule. -/
theorem sha256h_triple {P : Program} {p q : Word} {dl dh nl nh ml mh : Reg}
    (hb : P p = some ⟨.get 0 dl :: .get 1 dh :: .get 2 nl :: .get 3 nh :: .get 4 ml ::
      .get 5 mh :: (hashWords ++ [.set dl 200, .set dh 201]), .jump q⟩)
    (d0 d1 n0 n1 m0 m1 : Word) :
    Triple P
      (Atoms.interp [.pc p, .reg dl d0, .reg dh d1, .reg nl n0, .reg nh n1, .reg ml m0,
        .reg mh m1])
      (Atoms.interp [.pc q, .reg dl (sha256hLo d0 d1 n0 n1 m0 m1),
        .reg dh (sha256hHi d0 d1 n0 n1 m0 m1), .reg nl n0, .reg nh n1, .reg ml m0,
        .reg mh m1]) := by
  refine Triple.step (by braid_at) hb (BlockSpec.intro ?_)
  iterate 6 apply OpsSpec.get (by braid_at)
  refine OpsSpec.words hashWords_pure (fun _ _ _ => wp_hashWords) fun ρ' e0 e1 => ?_
  inst_finish e0 e1

/-- **`sha256h2`**: a block that is this instruction writes `sha256h2Lo` and `sha256h2Hi` to
the two words of its destination, which holds the working variables `e` to `h`. The first
source holds `a` to `d` as they were before `sha256h`, and the second the four sums. -/
theorem sha256h2_triple {P : Program} {p q : Word} {dl dh nl nh ml mh : Reg}
    (hb : P p = some ⟨.get 0 nl :: .get 1 nh :: .get 2 dl :: .get 3 dh :: .get 4 ml ::
      .get 5 mh :: (hash2Words ++ [.set dl 200, .set dh 201]), .jump q⟩)
    (d0 d1 n0 n1 m0 m1 : Word) :
    Triple P
      (Atoms.interp [.pc p, .reg dl d0, .reg dh d1, .reg nl n0, .reg nh n1, .reg ml m0,
        .reg mh m1])
      (Atoms.interp [.pc q, .reg dl (sha256h2Lo d0 d1 n0 n1 m0 m1),
        .reg dh (sha256h2Hi d0 d1 n0 n1 m0 m1), .reg nl n0, .reg nh n1, .reg ml m0,
        .reg mh m1]) := by
  refine Triple.step (by braid_at) hb (BlockSpec.intro ?_)
  iterate 6 apply OpsSpec.get (by braid_at)
  refine OpsSpec.words hash2Words_pure (fun _ _ _ => wp_hash2Words) fun ρ' e0 e1 => ?_
  inst_finish e0 e1

/-- **`sha256su0`**: a block that is this instruction writes `su0Lo` and `su0Hi` to the two
words of its destination, four words of the schedule. Of its source, the four words after
them, it reads the low word. -/
theorem sha256su0_triple {P : Program} {p q : Word} {dl dh nl : Reg}
    (hb : P p = some ⟨.get 0 dl :: .get 1 dh :: .get 2 nl ::
      (su0Words ++ [.set dl 200, .set dh 201]), .jump q⟩) (d0 d1 n0 : Word) :
    Triple P
      (Atoms.interp [.pc p, .reg dl d0, .reg dh d1, .reg nl n0])
      (Atoms.interp [.pc q, .reg dl (su0Lo d0 d1), .reg dh (su0Hi d1 n0), .reg nl n0]) := by
  refine Triple.step (by braid_at) hb (BlockSpec.intro ?_)
  iterate 3 apply OpsSpec.get (by braid_at)
  refine OpsSpec.words su0Words_pure (fun _ _ _ => wp_su0Words) fun ρ' e0 e1 => ?_
  inst_finish e0 e1

/-- **`sha256su1`**: a block that is this instruction writes `su1Lo`, and `su1Hi` of it, to
the two words of its destination, which `sha256su0` left. Its sources are the last eight
words of the schedule. -/
theorem sha256su1_triple {P : Program} {p q : Word} {dl dh nl nh ml mh : Reg}
    (hb : P p = some ⟨.get 0 dl :: .get 1 dh :: .get 2 nl :: .get 3 nh :: .get 4 ml ::
      .get 5 mh :: (su1Words ++ [.set dl 200, .set dh 201]), .jump q⟩)
    (d0 d1 n0 n1 m0 m1 : Word) :
    Triple P
      (Atoms.interp [.pc p, .reg dl d0, .reg dh d1, .reg nl n0, .reg nh n1, .reg ml m0,
        .reg mh m1])
      (Atoms.interp [.pc q, .reg dl (su1Lo d0 n0 n1 m1),
        .reg dh (su1Hi d1 n1 m0 (su1Lo d0 n0 n1 m1)), .reg nl n0, .reg nh n1, .reg ml m0,
        .reg mh m1]) := by
  refine Triple.step (by braid_at) hb (BlockSpec.intro ?_)
  iterate 3 apply OpsSpec.get (by braid_at)
  iterate 3 apply OpsSpec.get (by braid_at)
  refine OpsSpec.words su1Words_pure (fun _ _ _ => wp_su1Words) fun ρ' e0 e1 => ?_
  inst_finish e0 e1

end Examples.Sha256Ni.Arm
