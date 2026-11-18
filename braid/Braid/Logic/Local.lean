/-
  Braid.Logic.Local

  What a points-to fact beside a frame says about a state, and how each kind of write keeps
  the frame. These are the facts that make the operations of the dialect local: an operation
  touches the locations it names and nothing else.

  ## Main results

  * `regIs_get`, `regIs_set`, and the same for flags and the program counter
  * `memIs_load`: a load of mapped bytes gives their value
  * `memIs_store`: a store to writable bytes succeeds and replaces their value
-/

module

public import Braid.Logic.Atom
public import Braid.IR.Mem
import Std.Tactic.BVDecide

@[expose] public section

namespace Braid

open Iris Iris.BI

theorem State.heap_setReg (σ : State) (r : Reg) (v : Word) :
    (σ.setReg r v).heap = σ.heap.update (.reg r) (.word v) := by
  funext l
  cases l <;> simp only [State.heap, State.setReg, Heap.update, reduceCtorEq, ↓reduceIte,
    Loc.reg.injEq]
  split <;> rfl

theorem State.heap_setFlag (σ : State) (f : Flag) (b : Bool) :
    (σ.setFlag f b).heap = σ.heap.update (.flag f) (.bit b) := by
  funext l
  cases l <;> simp only [State.heap, State.setFlag, Heap.update, reduceCtorEq, ↓reduceIte,
    Loc.flag.injEq]
  split <;> rfl

theorem State.heap_setPc (σ : State) (a : Word) :
    (σ.setPc a).heap = σ.heap.update .pc (.word a) := by
  funext l
  cases l <;> simp [State.heap, State.setPc, Heap.update]

/-- A state holding `x` at `l` beside a frame holds `y` there, beside the same frame, once
`l` is updated. -/
theorem single_update {l : Loc} {x y : Val} {R : SProp} {σ σ' : State}
    (h : SProp.holds (fun h => h = Heap.single l x) R σ) (hσ : σ'.heap = σ.heap.update l y) :
    SProp.holds (fun h => h = Heap.single l y) R σ' := by
  obtain ⟨h₁, h₂, e, d, rfl, hr⟩ := h
  refine ⟨Heap.single l y, h₂, ?_, ?_, rfl, hr⟩
  · rw [hσ, e, Heap.update_union]
    congr 1
    funext l'
    simp only [Heap.update, Heap.single]
    split <;> rfl
  · have := d.update y (l := l) (by rw [Heap.single_apply_self]; rfl)
    have e' : (Heap.single l x).update l y = Heap.single l y := by
      funext l'; simp only [Heap.update, Heap.single]; split <;> rfl
    rwa [e'] at this

/-- A state holding `x` at `l` beside a frame has `x` at `l`. -/
theorem single_get {l : Loc} {x : Val} {R : SProp} {σ : State}
    (h : SProp.holds (fun h => h = Heap.single l x) R σ) : σ.heap l = some x := by
  obtain ⟨h₁, h₂, e, _, rfl, _⟩ := h
  rw [e]; exact Heap.union_apply_left (Heap.single_apply_self l x)

variable {R : SProp} {σ : State}

theorem regIs_get {r : Reg} {v : Word} (h : (regIs r v).holds R σ) : σ.regs r = v := by
  have := single_get h
  simpa [State.heap] using this

theorem regIs_set {r : Reg} {v : Word} (v' : Word) (h : (regIs r v).holds R σ) :
    (regIs r v').holds R (σ.setReg r v') :=
  single_update h (σ.heap_setReg r v')

theorem flagIs_get {f : Flag} {b : Bool} (h : (flagIs f b).holds R σ) : σ.flags f = b := by
  have := single_get h
  simpa [State.heap] using this

theorem flagIs_set {f : Flag} {b : Bool} (b' : Bool) (h : (flagIs f b).holds R σ) :
    (flagIs f b').holds R (σ.setFlag f b') :=
  single_update h (σ.heap_setFlag f b')

theorem pcIs_get {a : Word} (h : (pcIs a).holds R σ) : σ.pc = a := by
  have := single_get h
  simpa [State.heap] using this

theorem pcIs_set {a : Word} (a' : Word) (h : (pcIs a).holds R σ) :
    (pcIs a').holds R (σ.setPc a') :=
  single_update h (σ.heap_setPc a')

/-! ## Memory -/

/-- The bytes of a memory points-to are in the state's memory. -/
theorem memIs_cell {a : Word} {n : Nat} {v : Word} {w : Bool} (h : (memIs a n v w).holds R σ)
    {x : Word} (hx : (x - a).toNat < n) :
    σ.mem x = some ⟨(v >>> ((x - a) <<< 3)).truncate 8, w⟩ := by
  obtain ⟨h₁, h₂, e, _, rfl, _⟩ := h
  have : σ.heap (.mem x) = some (.cell ⟨(v >>> ((x - a) <<< 3)).truncate 8, w⟩) := by
    rw [e]; exact Heap.union_apply_left (by simp only [Heap.bytes, hx, ↓reduceIte])
  simp only [State.heap, Option.map_eq_some_iff, Val.cell.injEq] at this
  obtain ⟨c, hc, rfl⟩ := this
  exact hc

theorem memIs_load8 {a v : Word} {w : Bool} (h : (memIs a 1 v w).holds R σ) :
    σ.mem.load a .w8 = some ((v.truncate 8).zeroExtend 64) := by
  have h0 := memIs_cell h (x := a) (by simp)
  refine Mem.load_w8.2 ⟨_, h0, ?_⟩
  simp

theorem memIs_load16 {a v : Word} {w : Bool} (h : (memIs a 2 v w).holds R σ) :
    σ.mem.load a .w16 = some ((v.truncate 16).zeroExtend 64) := by
  have e1 : a + 1 - a = 1#64 := by bv_decide
  have h0 := memIs_cell h (x := a) (by simp)
  have h1 := memIs_cell h (x := a + 1) (by rw [e1]; decide)
  refine Mem.load_w16.2 ⟨_, _, h0, h1, ?_⟩
  simp only [BitVec.sub_self, e1]
  bv_decide

theorem memIs_load32 {a v : Word} {w : Bool} (h : (memIs a 4 v w).holds R σ) :
    σ.mem.load a .w32 = some ((v.truncate 32).zeroExtend 64) := by
  have e1 : a + 1 - a = 1#64 := by bv_decide
  have e2 : a + 2 - a = 2#64 := by bv_decide
  have e3 : a + 3 - a = 3#64 := by bv_decide
  have h0 := memIs_cell h (x := a) (by simp)
  have h1 := memIs_cell h (x := a + 1) (by rw [e1]; decide)
  have h2 := memIs_cell h (x := a + 2) (by rw [e2]; decide)
  have h3 := memIs_cell h (x := a + 3) (by rw [e3]; decide)
  refine Mem.load_w32.2 ⟨_, _, _, _, h0, h1, h2, h3, ?_⟩
  simp only [BitVec.sub_self, e1, e2, e3]
  bv_decide

theorem memIs_load64 {a v : Word} {w : Bool} (h : (memIs a 8 v w).holds R σ) :
    σ.mem.load a .w64 = some v := by
  have e1 : a + 1 - a = 1#64 := by bv_decide
  have e2 : a + 2 - a = 2#64 := by bv_decide
  have e3 : a + 3 - a = 3#64 := by bv_decide
  have e4 : a + 4 - a = 4#64 := by bv_decide
  have e5 : a + 5 - a = 5#64 := by bv_decide
  have e6 : a + 6 - a = 6#64 := by bv_decide
  have e7 : a + 7 - a = 7#64 := by bv_decide
  have h0 := memIs_cell h (x := a) (by simp)
  have h1 := memIs_cell h (x := a + 1) (by rw [e1]; decide)
  have h2 := memIs_cell h (x := a + 2) (by rw [e2]; decide)
  have h3 := memIs_cell h (x := a + 3) (by rw [e3]; decide)
  have h4 := memIs_cell h (x := a + 4) (by rw [e4]; decide)
  have h5 := memIs_cell h (x := a + 5) (by rw [e5]; decide)
  have h6 := memIs_cell h (x := a + 6) (by rw [e6]; decide)
  have h7 := memIs_cell h (x := a + 7) (by rw [e7]; decide)
  refine Mem.load_w64.2 ⟨_, _, _, _, _, _, _, _, h0, h1, h2, h3, h4, h5, h6, h7, ?_⟩
  simp only [BitVec.sub_self, e1, e2, e3, e4, e5, e6, e7]
  bv_decide

/-- A load of the bytes of a memory points-to gives their value, zero-extended. -/
theorem memIs_load {a v : Word} {w : Bool} (W : Width) (h : (memIs a W.bytes v w).holds R σ) :
    σ.mem.load a W = some ((v.truncate W.bits).zeroExtend 64) := by
  cases W
  · exact memIs_load8 h
  · exact memIs_load16 h
  · exact memIs_load32 h
  · rw [memIs_load64 h]; simp [Width.bits, Width.bytes]

/-- A store to the bytes of a writable memory points-to succeeds, and they hold the value
stored, beside the same frame. -/
theorem memIs_store {a v : Word} {n : Nat} (hn : n ≤ 8) (v' : Word)
    (h : (memIs a n v true).holds R σ) :
    ∃ m, σ.mem.storeN a v' n = some m ∧ (memIs a n v' true).holds R { σ with mem := m } := by
  refine ⟨_, (Mem.storeN_spec hn).2 ⟨fun x hx => ⟨_, memIs_cell h hx, rfl⟩, rfl⟩, ?_⟩
  obtain ⟨h₁, h₂, e, d, rfl, hr⟩ := h
  have hdom : ∀ l, (Heap.bytes a n v true l).isSome = (Heap.bytes a n v' true l).isSome := by
    intro l; cases l <;> simp only [Heap.bytes]
    split <;> rfl
  refine ⟨Heap.bytes a n v' true, h₂, ?_, ?_, rfl, hr⟩
  · funext l
    have el := congrFun e l
    cases l with
    | mem x =>
      simp only [State.heap, Heap.union_apply, Heap.bytes] at el ⊢
      by_cases hx : (x - a).toNat < n
      · simp only [hx, ↓reduceIte, Option.map_some]
      · simp only [hx, ↓reduceIte] at el ⊢; exact el
    | _ => simpa [State.heap, Heap.union_apply, Heap.bytes] using el
  · intro l
    rcases d l with h | h
    · left
      have := hdom l
      rw [h] at this
      cases hb : Heap.bytes a n v' true l
      · rfl
      · rw [hb] at this; cases this
    · exact .inr h

end Braid
