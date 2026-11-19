/-
  Braid.Pass.Plan

  Simplifying a whole function, proved. The blocks of a lowered function are in address
  order, one for each instruction. `Func.simplifyBy` walks them once: it fuses each block
  into the one before it where a plan says to and the one before it jumps there, then
  removes the flag writes each block overwrites and the operations nothing reads.

  The plan is a list of booleans and is not trusted. A block is fused only where the block
  before it ends in a jump to it, which the function itself checks, and that is all the proof
  needs: fusing two such blocks, and leaving a block out of a program, both give a program
  whose runs are runs of the original. A plan that fuses a block something else jumps to
  gives a program that is stuck where the original was not, and proves less, never something
  false. `Func.fusePlan` is the plan the decompiler uses: fuse a block whose one predecessor
  is the block before it.

  ## Main definitions

  * `Chain`: a block that is consecutive blocks of a list, fused
  * `Func.fuseBy`, `Func.simplifyBy`: fuse by a plan; and then remove dead work
  * `Func.fusePlan`: the plan that fuses straight-line code

  ## Main results

  * `Func.simplifyBy_eventually`: runs of the simplified function are runs of the function
  * `Func.simplifyBy_runs`: the same, from a check that a function is another simplified
-/

module

public import Braid.Pass.Simplify
public import Braid.Pass.DceFast

@[expose] public section

namespace Braid

/-! ## Programs given by lists -/

theorem Program.mem_of_ofList {l : List (Word × Block)} {a : Word} {b : Block}
    (h : Program.ofList l a = some b) : (a, b) ∈ l := by
  simp only [Program.ofList, Option.map_eq_some_iff] at h
  obtain ⟨⟨a', b'⟩, hfind, rfl⟩ := h
  have ha : a' = a := by simpa using List.find?_some hfind
  subst ha
  exact List.mem_of_find?_eq_some hfind

theorem Program.ofList_of_mem {l : List (Word × Block)} (hnd : (l.map (·.1)).Nodup)
    {a : Word} {b : Block} (h : (a, b) ∈ l) : Program.ofList l a = some b := by
  simp only [Program.ofList, Option.map_eq_some_iff]
  refine ⟨(a, b), ?_, rfl⟩
  induction l with
  | nil => cases h
  | cons q qs ih =>
    rw [List.map_cons, List.nodup_cons] at hnd
    rcases List.mem_cons.1 h with rfl | hq
    · simp
    · have hne : q.1 ≠ a := fun e => hnd.1 (e ▸ List.mem_map_of_mem (f := (·.1)) hq)
      rw [List.find?_cons_of_neg (by simpa using hne)]
      exact ih hnd.2 hq

theorem Program.ofList_map (g : Block → Block) (l : List (Word × Block)) (a : Word) :
    Program.ofList (l.map fun ab => (ab.1, g ab.2)) a = (Program.ofList l a).map g := by
  simp only [Program.ofList]
  induction l with
  | nil => rfl
  | cons q qs ih =>
    simp only [List.map_cons, List.find?_cons]
    cases h : q.1 == a
    · simpa only [h] using ih
    · simp only [Option.map_some]

theorem Func.dse_program (f : Func) : f.dse.program = f.program.dse :=
  funext fun a => Program.ofList_map Block.dse f.blocks a

theorem Func.dce_program (f : Func) : f.dce.program = f.program.dce :=
  funext fun a => Program.ofList_map Block.dce f.blocks a

/-! ## Chains -/

/-- `C` is consecutive blocks of the list fused, starting with the block at `a`: each ends
in a jump to the next. -/
inductive Chain (bs : List (Word × Block)) (a : Word) : Block → Prop where
  | one {A : Block} : (a, A) ∈ bs → Chain bs a A
  | snoc {C B : Block} {t : Word} :
      Chain bs a C → C.term = .jump t → (t, B) ∈ bs → Chain bs a (C.seq B)

/-- A run of a chain is a run of its blocks, one after another. -/
theorem Chain.eventually {P : Program} {bs : List (Word × Block)} {Q : State → Prop}
    (hP : ∀ a A, (a, A) ∈ bs → P a = some A) {a : Word} {C : Block} (h : Chain bs a C) :
    ∀ (σ : State) (R : State → Prop), σ.pc = a → C.wp σ R →
      (∀ σ', R σ' → Eventually P Q σ') → Eventually P Q σ := by
  induction h with
  | one hA =>
    intro σ R hpc hw hR
    exact .step σ R ⟨_, hpc ▸ hP _ _ hA, hw⟩ hR
  | snoc _ ht hB ih =>
    intro σ R hpc hw hR
    refine ih σ _ hpc (Block.seq_wp ht hw) ?_
    rintro σ₁ ⟨hpc₁, hw₁⟩
    exact .step σ₁ R ⟨_, hpc₁ ▸ hP _ _ hB, hw₁⟩ hR

/-- **A program of chains of another has only runs of the other.** -/
theorem Eventually.of_chains {P P' : Program} {bs : List (Word × Block)} {Q : State → Prop}
    {σ : State} (hP : ∀ a A, (a, A) ∈ bs → P a = some A)
    (hP' : ∀ a C, P' a = some C → Chain bs a C) (h : Eventually P' Q σ) :
    Eventually P Q σ := by
  induction h with
  | done σ hq => exact .done σ hq
  | step σ R hs _ ih =>
    obtain ⟨C, hC, hw⟩ := hs
    exact (hP' _ _ hC).eventually hP σ R rfl hw ih

/-! ## Fusing by a plan -/

/-- Fuse the blocks of a list, in order, into the block `acc` before them: a block is fused
when the plan says so and the block before it ends in a jump to it. -/
def fuseBy : List Bool → Word × Block → List (Word × Block) → List (Word × Block)
  | _, acc, [] => [acc]
  | [], acc, b :: bs => acc :: fuseBy [] b bs
  | f :: fs, acc, b :: bs =>
    if f && decide (acc.2.term = .jump b.1) then fuseBy fs (acc.1, acc.2.seq b.2) bs
    else acc :: fuseBy fs b bs

theorem chain_of_fuseBy {all : List (Word × Block)} :
    ∀ (rest : List (Word × Block)) (plan : List Bool) (acc : Word × Block),
      Chain all acc.1 acc.2 → (∀ x ∈ rest, x ∈ all) →
      ∀ x ∈ fuseBy plan acc rest, Chain all x.1 x.2 := by
  intro rest
  induction rest with
  | nil =>
    intro plan acc hacc _ x hx
    have e : x = acc := by cases plan <;> simpa [fuseBy] using hx
    exact e ▸ hacc
  | cons b bs ih =>
    intro plan acc hacc hall x hx
    have hb : Chain all b.1 b.2 := .one (hall b (List.mem_cons_self))
    have hbs : ∀ x ∈ bs, x ∈ all := fun x hx => hall x (List.mem_cons_of_mem _ hx)
    cases plan with
    | nil =>
      simp only [fuseBy, List.mem_cons] at hx
      rcases hx with rfl | hx
      · exact hacc
      · exact ih [] b hb hbs x hx
    | cons f fs =>
      simp only [fuseBy] at hx
      split at hx
      · rename_i hc
        simp only [Bool.and_eq_true, decide_eq_true_eq] at hc
        exact ih fs _ (.snoc hacc hc.2 (hall b (List.mem_cons_self))) hbs x hx
      · rcases List.mem_cons.1 hx with rfl | hx
        · exact hacc
        · exact ih fs b hb hbs x hx

/-- The function with its blocks fused by a plan. -/
def Func.fuseBy (f : Func) (plan : List Bool) : Func :=
  { f with blocks := match f.blocks with
      | [] => []
      | b :: bs => Braid.fuseBy plan b bs }

theorem Func.chain_of_fuseBy (f : Func) (plan : List Bool) :
    ∀ x ∈ (f.fuseBy plan).blocks, Chain f.blocks x.1 x.2 := by
  intro x hx
  simp only [Func.fuseBy] at hx
  cases hbs : f.blocks with
  | nil => rw [hbs] at hx; cases hx
  | cons b bs =>
    rw [hbs] at hx
    exact Braid.chain_of_fuseBy bs plan b (.one List.mem_cons_self)
      (fun x hx => List.mem_cons_of_mem _ hx) x hx

/-- **Runs of a function fused by a plan are runs of the function**, whatever the plan. -/
theorem Func.fuseBy_eventually (f : Func) (plan : List Bool)
    (hnd : (f.blocks.map (·.1)).Nodup) {Q : State → Prop} {σ : State}
    (h : Eventually (f.fuseBy plan).program Q σ) : Eventually f.program Q σ :=
  Eventually.of_chains (bs := f.blocks) (fun _ _ hA => Program.ofList_of_mem hnd hA)
    (fun _ _ hC => f.chain_of_fuseBy plan _ (Program.mem_of_ofList hC)) h

/-- `Func.dce`, computed by `Block.dceFast`. -/
def Func.dceFast (f : Func) : Func :=
  { f with blocks := f.blocks.map fun ab => (ab.1, ab.2.dceFast) }

theorem Func.dceFast_eq (f : Func) : f.dceFast = f.dce := by
  simp only [Func.dceFast, Func.dce, Block.dceFast_eq]

/-- The function fused by a plan, with its overwritten flag writes and its dead operations
removed. -/
def Func.simplifyBy (f : Func) (plan : List Bool) : Func := ((f.fuseBy plan).dse).dceFast

/-- **Runs of the simplified function are runs of the function.** -/
theorem Func.simplifyBy_eventually (f : Func) (plan : List Bool)
    (hnd : (f.blocks.map (·.1)).Nodup) {Q : State → Prop} {σ : State}
    (h : Eventually (f.simplifyBy plan).program Q σ) : Eventually f.program Q σ := by
  rw [Func.simplifyBy, Func.dceFast_eq, Func.dce_program, Program.dce_eventually,
    Func.dse_program] at h
  exact f.fuseBy_eventually plan hnd (Program.dse_eventually _ h)

/-! ## Certificates

What it takes to use a simplified function written out as a definition of its own: that the
blocks of the function are in address order, and that the definition is the function
simplified by the plan. Both can be checked by evaluation. The decompiler does not write
them: on long functions the kernel's evaluation of the second is slow or runs out of stack
(`docs/Scaling.md`). -/

/-- The addresses of the blocks are strictly increasing. -/
def sortedBlocks : List (Word × Block) → Bool
  | a :: b :: l => decide (a.1.toNat < b.1.toNat) && sortedBlocks (b :: l)
  | _ => true

theorem sortedBlocks_tail {a : Word × Block} {l : List (Word × Block)}
    (h : sortedBlocks (a :: l) = true) : sortedBlocks l = true := by
  cases l with
  | nil => rfl
  | cons b l => simp only [sortedBlocks, Bool.and_eq_true] at h; exact h.2

theorem sortedBlocks_lt {a : Word × Block} {l : List (Word × Block)}
    (h : sortedBlocks (a :: l) = true) : ∀ x ∈ l, a.1.toNat < x.1.toNat := by
  induction l generalizing a with
  | nil => intro x hx; cases hx
  | cons b l ih =>
    intro x hx
    simp only [sortedBlocks, Bool.and_eq_true, decide_eq_true_eq] at h
    rcases List.mem_cons.1 hx with rfl | hx
    · exact h.1
    · exact Nat.lt_trans h.1 (ih h.2 x hx)

/-- Blocks in address order have distinct addresses. -/
theorem sortedBlocks_nodup {l : List (Word × Block)} (h : sortedBlocks l = true) :
    (l.map (·.1)).Nodup := by
  induction l with
  | nil => simp
  | cons a l ih =>
    rw [List.map_cons, List.nodup_cons]
    refine ⟨fun hmem => ?_, ih (sortedBlocks_tail h)⟩
    obtain ⟨x, hx, e⟩ := List.mem_map.1 hmem
    have := sortedBlocks_lt h x hx
    rw [e] at this
    exact Nat.lt_irrefl _ this

/-- **The certificate of a simplified function.** If the blocks of `f` are in address order
and the blocks of `g` are those of `f` simplified by a plan, runs of `g` are runs of `f`. -/
theorem Func.simplifyBy_runs (f : Func) (plan : List Bool) (g : Func)
    (hs : sortedBlocks f.blocks = true) (he : g.blocks = (f.simplifyBy plan).blocks)
    {Q : State → Prop} {σ : State} (h : Eventually g.program Q σ) :
    Eventually f.program Q σ := by
  rw [Func.program, he] at h
  exact f.simplifyBy_eventually plan (sortedBlocks_nodup hs) h

/-! ## The plan for straight-line code -/

/-- For each block after the first: whether the block before it ends in a jump to it, and
nothing else jumps to it, and it is not the entry. -/
def Func.fusePlan (f : Func) : List Bool :=
  let targets := f.blocks.flatMap fun ab => ab.2.term.targets
  match f.blocks with
  | [] => []
  | b :: bs => go targets b bs
where
  /-- The plan for the blocks after `prev`. -/
  go (targets : List Word) : Word × Block → List (Word × Block) → List Bool
    | _, [] => []
    | prev, b :: bs =>
      (decide (prev.2.term = .jump b.1) && b.1 != f.entry && targets.count b.1 == 1) ::
        go targets b bs

end Braid
