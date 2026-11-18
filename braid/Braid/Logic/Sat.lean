/-
  Braid.Logic.Sat

  Between a list of atoms and plain facts about a state. Going in, atoms whose locations are
  pairwise disjoint and each true of a state hold of it beside some frame. Coming out, each
  atom of a list that holds of a state is true of it. A theorem about a machine uses the
  first for its hypotheses and the second for its conclusion.

  ## Main definitions

  * `Atom.heap`: the heap of a points-to atom
  * `Atom.Disj`: two atoms have no location in common
  * `Atom.sat`: a points-to atom is true of a state

  ## Main results

  * `Atoms.holds_of_sat`: into the logic
  * `Atoms.reg_of_holds`, `Atoms.flag_of_holds`, `Atoms.pc_of_holds`, `Atoms.mem_of_holds`:
    out of it
-/

module

public import Braid.Logic.Local
public import Braid.Logic.Triple
import Iris.BI.DerivedLaws

@[expose] public section

namespace Braid

open Iris Iris.BI

/-- The heap of a points-to atom. An arbitrary assertion has none. -/
def Atom.heap : Atom → Heap
  | .reg r v => Heap.single (.reg r) (.word v)
  | .flag f b => Heap.single (.flag f) (.bit b)
  | .pc a => Heap.single .pc (.word a)
  | .mem a n v w => Heap.bytes a n v w
  | .prop _ => ∅

/-- The atom is a points-to fact, not an arbitrary assertion. -/
def Atom.IsPointsTo : Atom → Prop
  | .prop _ => False
  | _ => True

theorem Atom.interp_heap {a : Atom} (h : a.IsPointsTo) : a.interp a.heap := by
  cases a <;> first | rfl | exact absurd h id

/-- Two atoms have no location in common. -/
def Atom.Disj (a b : Atom) : Prop := Heap.Disjoint a.heap b.heap

/-- A points-to atom is true of a state. -/
def Atom.sat (σ : State) (a : Atom) : Prop := ∀ l v, a.heap l = some v → σ.heap l = some v

theorem Atom.sat_reg {σ : State} {r : Reg} {v : Word} : (Atom.reg r v).sat σ ↔ σ.regs r = v := by
  constructor
  · intro h
    have := h (.reg r) (.word v) (Heap.single_apply_self _ _)
    simpa [State.heap] using this
  · rintro rfl l v hl
    by_cases e : l = .reg r
    · subst e; rw [← hl]; exact (Heap.single_apply_self _ _).symm
    · rw [Atom.heap, Heap.single_apply_ne _ e] at hl; cases hl

theorem Atom.sat_flag {σ : State} {f : Flag} {b : Bool} :
    (Atom.flag f b).sat σ ↔ σ.flags f = b := by
  constructor
  · intro h
    have := h (.flag f) (.bit b) (Heap.single_apply_self _ _)
    simpa [State.heap] using this
  · rintro rfl l v hl
    by_cases e : l = .flag f
    · subst e; rw [← hl]; exact (Heap.single_apply_self _ _).symm
    · rw [Atom.heap, Heap.single_apply_ne _ e] at hl; cases hl

theorem Atom.sat_pc {σ : State} {a : Word} : (Atom.pc a).sat σ ↔ σ.pc = a := by
  constructor
  · intro h
    have := h .pc (.word a) (Heap.single_apply_self _ _)
    simpa [State.heap] using this
  · rintro rfl l v hl
    by_cases e : l = .pc
    · subst e; rw [← hl]; exact (Heap.single_apply_self _ _).symm
    · rw [Atom.heap, Heap.single_apply_ne _ e] at hl; cases hl

theorem Atom.sat_mem {σ : State} {a v : Word} {n : Nat} {w : Bool} :
    (Atom.mem a n v w).sat σ ↔ ∀ x : Word, (x - a).toNat < n →
      σ.mem x = some ⟨(v >>> ((x - a) <<< 3)).truncate 8, w⟩ := by
  constructor
  · intro h x hx
    have := h (.mem x) (.cell ⟨(v >>> ((x - a) <<< 3)).truncate 8, w⟩)
      (by simp only [Atom.heap, Heap.bytes, hx, ↓reduceIte])
    simp only [State.heap, Option.map_eq_some_iff, Val.cell.injEq] at this
    obtain ⟨c, hc, rfl⟩ := this
    exact hc
  · intro h l v' hl
    cases l with
    | mem x =>
      simp only [Atom.heap, Heap.bytes] at hl
      by_cases hx : (x - a).toNat < n
      · simp only [hx, ↓reduceIte, Option.some.injEq] at hl
        subst hl
        simp only [State.heap, h x hx, Option.map_some]
      · simp only [hx, ↓reduceIte, reduceCtorEq] at hl
    | _ => cases hl

/-- The heap without the locations another holds. -/
def Heap.diff (h k : Heap) : Heap := fun l => if (k l).isSome then none else h l

theorem Heap.union_diff {h k : Heap} (hk : ∀ l v, k l = some v → h l = some v) :
    h = k ∪ h.diff k := by
  funext l
  simp only [Heap.union_apply, Heap.diff]
  cases hl : k l with
  | none => simp
  | some v => simp [hk l v hl]

theorem Heap.disjoint_diff (h k : Heap) : Heap.Disjoint k (h.diff k) := by
  intro l
  simp only [Heap.diff]
  cases k l <;> simp

/-- Points-to atoms that are pairwise disjoint and each inside a heap hold of it, beside
whatever is left. -/
theorem Atoms.holds_of_sub {as : Atoms} {h : Heap} (hpt : ∀ a ∈ as, a.IsPointsTo)
    (hdisj : as.Pairwise Atom.Disj) (hsub : ∀ a ∈ as, ∀ l v, a.heap l = some v → h l = some v) :
    (iprop(Atoms.interp as ∗ True) : SProp) h := by
  induction as generalizing h with
  | nil => exact ⟨∅, h, (Heap.empty_union h).symm, Heap.disjoint_empty_left h, rfl, trivial⟩
  | cons a as ih =>
    have ha := hsub a List.mem_cons_self
    have hd := List.pairwise_cons.1 hdisj
    have hrest : (iprop(Atoms.interp as ∗ True) : SProp) (h.diff a.heap) := by
      refine ih (fun b hb => hpt b (List.mem_cons_of_mem _ hb)) hd.2 fun b hb l v hl => ?_
      have hal : a.heap l = none := by
        rcases hd.1 b hb l with h1 | h1
        · exact h1
        · rw [h1] at hl; cases hl
      simp only [Heap.diff, hal, Option.isSome_none, Bool.false_eq_true, ↓reduceIte]
      exact hsub b (List.mem_cons_of_mem _ hb) l v hl
    refine (sep_assoc.2 : iprop(a.interp ∗ Atoms.interp as ∗ True) ⊢
      iprop((a.interp ∗ Atoms.interp as) ∗ True)) _ ?_
    exact ⟨a.heap, h.diff a.heap, Heap.union_diff ha, Heap.disjoint_diff h a.heap,
      Atom.interp_heap (hpt a List.mem_cons_self), hrest⟩

/-- **Into the logic.** Points-to atoms that are pairwise disjoint and each true of a state
hold of it, beside the rest of the state. -/
theorem Atoms.holds_of_sat {as : Atoms} {σ : State} (hpt : ∀ a ∈ as, a.IsPointsTo)
    (hdisj : as.Pairwise Atom.Disj) (hsat : ∀ a ∈ as, a.sat σ) :
    (iprop(Atoms.interp as ∗ True) : SProp) σ.heap :=
  Atoms.holds_of_sub hpt hdisj hsat

/-! ## Out of the logic -/

theorem Atoms.reg_of_holds {as : Atoms} {R : SProp} {σ : State} {r : Reg} {v : Word}
    (h : (Atoms.interp as).holds R σ) (hat : as.At (.reg r v)) : σ.regs r = v := by
  obtain ⟨F, e⟩ := hat.split
  rw [e] at h
  exact regIs_get (SProp.holds_assoc.1 h)

theorem Atoms.flag_of_holds {as : Atoms} {R : SProp} {σ : State} {f : Flag} {b : Bool}
    (h : (Atoms.interp as).holds R σ) (hat : as.At (.flag f b)) : σ.flags f = b := by
  obtain ⟨F, e⟩ := hat.split
  rw [e] at h
  exact flagIs_get (SProp.holds_assoc.1 h)

theorem Atoms.pc_of_holds {as : Atoms} {R : SProp} {σ : State} {a : Word}
    (h : (Atoms.interp as).holds R σ) (hat : as.At (.pc a)) : σ.pc = a := by
  obtain ⟨F, e⟩ := hat.split
  rw [e] at h
  exact pcIs_get (SProp.holds_assoc.1 h)

theorem Atoms.mem_of_holds {as : Atoms} {R : SProp} {σ : State} {a v : Word} {n : Nat}
    {w : Bool} (h : (Atoms.interp as).holds R σ) (hat : as.At (.mem a n v w)) {x : Word}
    (hx : (x - a).toNat < n) : σ.mem x = some ⟨(v >>> ((x - a) <<< 3)).truncate 8, w⟩ := by
  obtain ⟨F, e⟩ := hat.split
  rw [e] at h
  exact memIs_cell (SProp.holds_assoc.1 h) hx

/-! ## Deciding that atoms are disjoint -/

theorem Heap.disjoint_single {l l' : Loc} {v v' : Val} (h : l ≠ l') :
    Heap.Disjoint (Heap.single l v) (Heap.single l' v') := by
  intro x
  by_cases hx : x = l
  · subst hx; exact .inr (Heap.single_apply_ne v' h)
  · exact .inl (Heap.single_apply_ne v hx)

theorem Heap.disjoint_single_iff {l l' : Loc} {v v' : Val} :
    Heap.Disjoint (Heap.single l v) (Heap.single l' v') ↔ l ≠ l' := by
  refine ⟨fun h e => ?_, Heap.disjoint_single⟩
  subst e
  rcases h l with h | h <;> rw [Heap.single_apply_self] at h <;> cases h

@[simp] theorem Atom.disj_reg_reg {r r' : Reg} {v v' : Word} :
    Atom.Disj (.reg r v) (.reg r' v') ↔ r ≠ r' := by
  simp [Atom.Disj, Atom.heap, Heap.disjoint_single_iff]

@[simp] theorem Atom.disj_flag_flag {f f' : Flag} {b b' : Bool} :
    Atom.Disj (.flag f b) (.flag f' b') ↔ f ≠ f' := by
  simp [Atom.Disj, Atom.heap, Heap.disjoint_single_iff]

@[simp] theorem Atom.disj_reg_flag {r : Reg} {v : Word} {f : Flag} {b : Bool} :
    Atom.Disj (.reg r v) (.flag f b) := Heap.disjoint_single (by simp)

@[simp] theorem Atom.disj_flag_reg {r : Reg} {v : Word} {f : Flag} {b : Bool} :
    Atom.Disj (.flag f b) (.reg r v) := Heap.disjoint_single (by simp)

@[simp] theorem Atom.disj_reg_pc {r : Reg} {v a : Word} : Atom.Disj (.reg r v) (.pc a) :=
  Heap.disjoint_single (by simp)

@[simp] theorem Atom.disj_pc_reg {r : Reg} {v a : Word} : Atom.Disj (.pc a) (.reg r v) :=
  Heap.disjoint_single (by simp)

@[simp] theorem Atom.disj_flag_pc {f : Flag} {b : Bool} {a : Word} :
    Atom.Disj (.flag f b) (.pc a) := Heap.disjoint_single (by simp)

@[simp] theorem Atom.disj_pc_flag {f : Flag} {b : Bool} {a : Word} :
    Atom.Disj (.pc a) (.flag f b) := Heap.disjoint_single (by simp)

theorem Heap.bytes_apply_ne_mem {a : Word} {n : Nat} {v : Word} {w : Bool} {l : Loc}
    (h : ∀ x, l ≠ .mem x) : Heap.bytes a n v w l = none := by
  cases l with
  | mem x => exact absurd rfl (h x)
  | _ => rfl

@[simp] theorem Atom.disj_mem_reg {a v : Word} {n : Nat} {w : Bool} {r : Reg} {v' : Word} :
    Atom.Disj (.mem a n v w) (.reg r v') := fun l => by
  by_cases h : l = .reg r
  · subst h; exact .inl rfl
  · exact .inr (Heap.single_apply_ne _ h)

@[simp] theorem Atom.disj_reg_mem {a v : Word} {n : Nat} {w : Bool} {r : Reg} {v' : Word} :
    Atom.Disj (.reg r v') (.mem a n v w) := Atom.disj_mem_reg.symm

@[simp] theorem Atom.disj_mem_flag {a v : Word} {n : Nat} {w : Bool} {f : Flag} {b : Bool} :
    Atom.Disj (.mem a n v w) (.flag f b) := fun l => by
  by_cases h : l = .flag f
  · subst h; exact .inl rfl
  · exact .inr (Heap.single_apply_ne _ h)

@[simp] theorem Atom.disj_flag_mem {a v : Word} {n : Nat} {w : Bool} {f : Flag} {b : Bool} :
    Atom.Disj (.flag f b) (.mem a n v w) := Atom.disj_mem_flag.symm

@[simp] theorem Atom.disj_mem_pc {a v : Word} {n : Nat} {w : Bool} {p : Word} :
    Atom.Disj (.mem a n v w) (.pc p) := fun l => by
  by_cases h : l = .pc
  · subst h; exact .inl rfl
  · exact .inr (Heap.single_apply_ne _ h)

@[simp] theorem Atom.disj_pc_mem {a v : Word} {n : Nat} {w : Bool} {p : Word} :
    Atom.Disj (.pc p) (.mem a n v w) := Atom.disj_mem_pc.symm

/-- Two memory atoms are disjoint when no address is within both. -/
theorem Atom.disj_mem_mem {a a' v v' : Word} {n n' : Nat} {w w' : Bool}
    (h : ∀ x : Word, ¬ ((x - a).toNat < n ∧ (x - a').toNat < n')) :
    Atom.Disj (.mem a n v w) (.mem a' n' v' w') := by
  intro l
  cases l with
  | mem x =>
    simp only [Atom.heap, Heap.bytes]
    by_cases h1 : (x - a).toNat < n
    · have h2 : ¬ (x - a').toNat < n' := fun h2 => h x ⟨h1, h2⟩
      exact .inr (by simp only [h2, ↓reduceIte])
    · exact .inl (by simp only [h1, ↓reduceIte])
  | _ => exact .inl rfl

/-- Two memory atoms are disjoint when each starts at or beyond the end of the other, going
round the address space. -/
theorem Atom.disj_mem_mem_of_apart {a b v v' : Word} {n k : Nat} {w w' : Bool}
    (h : k ≤ (a - b).toNat ∧ n ≤ (b - a).toNat) :
    Atom.Disj (.mem a n v w) (.mem b k v' w') :=
  Atom.disj_mem_mem fun x hx => by bv_omega

end Braid
