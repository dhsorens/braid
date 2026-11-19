/-
  Examples.ChaCha20.Common

  What the proofs about `chacha20.c` share, on every instruction set: arrays of 32-bit cells
  opened into the memory atoms the stepper looks for, the lemmas that turn the 64-bit
  arithmetic of the lowered code into arithmetic on 32-bit words, facts about the
  specification as a function on lists of sixteen words, and what a theorem about a machine
  needs to state a precondition with several arrays and read an array off a postcondition.

  ## Main results

  * `cells4`, `cells4'`, `cells16`: an array of 32-bit cells, as memory atoms
  * `zadd`, `zxor`, `zror16`, `zrol16`, ...: 64-bit arithmetic on zero-extended words, as
    32-bit arithmetic
  * `eta16`, `length_inner`, `length_innerN`, `map16`, `block16`: states of sixteen words
  * `columns`, `diagonals`, `inner_eq`: a double round as two halves of four quarter rounds
  * `cellsAt_cell`: the bytes of a cell of an array that holds of a state
  * `cellsAny`, `Triple.forget_cells`: an array that holds some values, and forgetting them
  * `Triple.restate`: an atom rewritten as one that means the same
  * `braid_done_perm`: `braid_done`, for a state of many atoms in another order
  * `pairwise_cells_append`, `disj_cellsAtoms_rest`, `disj_append`: disjointness of a state
    with arrays written out
-/

module

public import Braid.Logic.Cells
public import Braid.Logic.Tactic
public import Examples.Spec.ChaCha20
import Iris.BI.DerivedLaws

public section

namespace Examples.ChaCha20

open Braid Iris Iris.BI

/-! ## Arrays of 32-bit cells -/

/-- Addition as the stepper writes it when it evaluates an `add`: all three types `Word`.
(`p + 4#64` elaborates with the type of the literal, `BitVec 64`, in the second place, and
the stepper finds memory atoms by syntactic equality of addresses.) -/
local notation:65 a:65 " +ʷ " b:66 => @HAdd.hAdd Word Word Word instHAdd a b

/-- Addition as `BitVec.add_assoc` leaves it: all three types `BitVec 64`. -/
local notation:65 a:65 " +ᵇ " b:66 =>
  @HAdd.hAdd (BitVec 64) (BitVec 64) (BitVec 64) instHAdd a b

/-- Four 32-bit cells, as memory atoms. -/
theorem cells4 (p v0 v1 v2 v3 : Word) :
    (Atom.prop (cellsAt 4 true p [v0, v1, v2, v3])).interp =
      Atoms.interp [.mem p 4 v0 true, .mem (p +ʷ 4#64) 4 v1 true,
        .mem (p +ʷ 8#64) 4 v2 true, .mem (p +ʷ 12#64) 4 v3 true] := by
  simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil, cellsAt, BitVec.add_assoc,
    BitVec.reduceAdd]

/-- Four 32-bit cells, as memory atoms, the last at the address the stepper computes for the
second word of a pair at offset 8. -/
theorem cells4' (p v0 v1 v2 v3 : Word) :
    (Atom.prop (cellsAt 4 true p [v0, v1, v2, v3])).interp =
      Atoms.interp [.mem p 4 v0 true, .mem (p +ʷ 4#64) 4 v1 true,
        .mem (p +ʷ 8#64) 4 v2 true, .mem (p +ᵇ 12#64) 4 v3 true] := by
  simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil, cellsAt, BitVec.add_assoc,
    BitVec.reduceAdd]

/-- Sixteen 32-bit cells, as memory atoms. -/
theorem cells16 (p v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word) :
    (Atom.prop (cellsAt 4 true p
      [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15])).interp =
      Atoms.interp [.mem p 4 v0 true,
        .mem (p +ʷ 4#64) 4 v1 true, .mem (p +ʷ 8#64) 4 v2 true, .mem (p +ʷ 12#64) 4 v3 true,
        .mem (p +ʷ 16#64) 4 v4 true, .mem (p +ʷ 20#64) 4 v5 true, .mem (p +ʷ 24#64) 4 v6 true,
        .mem (p +ʷ 28#64) 4 v7 true, .mem (p +ʷ 32#64) 4 v8 true, .mem (p +ʷ 36#64) 4 v9 true,
        .mem (p +ʷ 40#64) 4 v10 true, .mem (p +ʷ 44#64) 4 v11 true, .mem (p +ʷ 48#64) 4 v12 true,
        .mem (p +ʷ 52#64) 4 v13 true, .mem (p +ʷ 56#64) 4 v14 true,
        .mem (p +ʷ 60#64) 4 v15 true] := by
  simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil, cellsAt, BitVec.add_assoc,
    BitVec.reduceAdd]

/-! ## Machine words and 32-bit words -/

/-- A 32-bit addition of two zero-extended words. -/
theorem zadd (x y : W32) :
    BitVec.setWidth 64 (BitVec.setWidth 32 (BitVec.setWidth 64 x + BitVec.setWidth 64 y)) =
      BitVec.setWidth 64 (x + y) := by
  bv_decide

/-- A 32-bit addition of two zero-extended words, the other way round. -/
theorem zadd_comm (x y : W32) :
    BitVec.setWidth 64 (BitVec.setWidth 32 (BitVec.setWidth 64 x + BitVec.setWidth 64 y)) =
      BitVec.setWidth 64 (y + x) := by
  bv_decide

/-- An exclusive or of two zero-extended words. -/
theorem zxor (x y : W32) :
    BitVec.setWidth 64 x ^^^ BitVec.setWidth 64 y = BitVec.setWidth 64 (x ^^^ y) := by
  bv_decide

/-- A 32-bit rotation of a zero-extended word, as AArch64's `ror` is lowered. -/
theorem zror16 (x : W32) :
    BitVec.setWidth 64 (BitVec.setWidth 32
      (BitVec.setWidth 64 x >>> 16#64 ||| BitVec.setWidth 64 x <<< 16#64)) =
      BitVec.setWidth 64 (x.rotateLeft 16) := by
  bv_decide

theorem zror20 (x : W32) :
    BitVec.setWidth 64 (BitVec.setWidth 32
      (BitVec.setWidth 64 x >>> 20#64 ||| BitVec.setWidth 64 x <<< 12#64)) =
      BitVec.setWidth 64 (x.rotateLeft 12) := by
  bv_decide

theorem zror24 (x : W32) :
    BitVec.setWidth 64 (BitVec.setWidth 32
      (BitVec.setWidth 64 x >>> 24#64 ||| BitVec.setWidth 64 x <<< 8#64)) =
      BitVec.setWidth 64 (x.rotateLeft 8) := by
  bv_decide

theorem zror25 (x : W32) :
    BitVec.setWidth 64 (BitVec.setWidth 32
      (BitVec.setWidth 64 x >>> 25#64 ||| BitVec.setWidth 64 x <<< 7#64)) =
      BitVec.setWidth 64 (x.rotateLeft 7) := by
  bv_decide

/-- A 32-bit rotation of a zero-extended word, as x86-64's `rol` is lowered. -/
theorem zrol16 (x : W32) :
    BitVec.setWidth 64 (BitVec.setWidth 32
      (BitVec.setWidth 64 x <<< 16#64 ||| BitVec.setWidth 64 x >>> 16#64)) =
      BitVec.setWidth 64 (x.rotateLeft 16) := by
  bv_decide

theorem zrol12 (x : W32) :
    BitVec.setWidth 64 (BitVec.setWidth 32
      (BitVec.setWidth 64 x <<< 12#64 ||| BitVec.setWidth 64 x >>> 20#64)) =
      BitVec.setWidth 64 (x.rotateLeft 12) := by
  bv_decide

theorem zrol8 (x : W32) :
    BitVec.setWidth 64 (BitVec.setWidth 32
      (BitVec.setWidth 64 x <<< 8#64 ||| BitVec.setWidth 64 x >>> 24#64)) =
      BitVec.setWidth 64 (x.rotateLeft 8) := by
  bv_decide

theorem zrol7 (x : W32) :
    BitVec.setWidth 64 (BitVec.setWidth 32
      (BitVec.setWidth 64 x <<< 7#64 ||| BitVec.setWidth 64 x >>> 25#64)) =
      BitVec.setWidth 64 (x.rotateLeft 7) := by
  bv_decide

/-- A 32-bit decrement of a zero-extended word, as `subs w, w, #1` is lowered. -/
theorem zdec (x : W32) :
    BitVec.setWidth 64
      (BitVec.setWidth 32 (BitVec.setWidth 64 x + 18446744073709551615#64)) =
      BitVec.setWidth 64 (x - 1) := by
  bv_decide

/-! ## States of sixteen words -/

/-- A list of sixteen words is its sixteen words. -/
theorem eta16 (s : List W32) (h : s.length = 16) :
    [s.getD 0 0, s.getD 1 0, s.getD 2 0, s.getD 3 0, s.getD 4 0, s.getD 5 0, s.getD 6 0,
      s.getD 7 0, s.getD 8 0, s.getD 9 0, s.getD 10 0, s.getD 11 0, s.getD 12 0, s.getD 13 0,
      s.getD 14 0, s.getD 15 0] = s := by
  apply List.ext_getElem
  · simp [h]
  · intro i h₁ h₂
    simp only [List.length_cons, List.length_nil] at h₁
    have : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 ∨ i = 4 ∨ i = 5 ∨ i = 6 ∨ i = 7 ∨ i = 8 ∨ i = 9 ∨
        i = 10 ∨ i = 11 ∨ i = 12 ∨ i = 13 ∨ i = 14 ∨ i = 15 := by omega
    rcases this with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
      rfl | rfl | rfl | rfl <;> simp [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem h₂]

theorem length_quarterAt (s : List W32) (i j k l : Nat) :
    (quarterAt s i j k l).length = s.length := by
  simp [quarterAt]

theorem length_inner (s : List W32) : (inner s).length = s.length := by
  simp [inner, length_quarterAt]

theorem length_innerN (n : Nat) (s : List W32) : (innerN n s).length = s.length := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => rw [innerN, ih, length_inner]

/-- The four quarter rounds on the columns of a state: the first half of `inner`. The
compilers run the four side by side, so the code is proved against this. -/
@[expose] def columns (s : List W32) : List W32 :=
  let q0 := quarter (s.getD 0 0) (s.getD 4 0) (s.getD 8 0) (s.getD 12 0)
  let q1 := quarter (s.getD 1 0) (s.getD 5 0) (s.getD 9 0) (s.getD 13 0)
  let q2 := quarter (s.getD 2 0) (s.getD 6 0) (s.getD 10 0) (s.getD 14 0)
  let q3 := quarter (s.getD 3 0) (s.getD 7 0) (s.getD 11 0) (s.getD 15 0)
  [q0.1, q1.1, q2.1, q3.1, q0.2.1, q1.2.1, q2.2.1, q3.2.1,
    q0.2.2.1, q1.2.2.1, q2.2.2.1, q3.2.2.1, q0.2.2.2, q1.2.2.2, q2.2.2.2, q3.2.2.2]

/-- The four quarter rounds on the diagonals of a state: the second half of `inner`. -/
@[expose] def diagonals (s : List W32) : List W32 :=
  let q0 := quarter (s.getD 0 0) (s.getD 5 0) (s.getD 10 0) (s.getD 15 0)
  let q1 := quarter (s.getD 1 0) (s.getD 6 0) (s.getD 11 0) (s.getD 12 0)
  let q2 := quarter (s.getD 2 0) (s.getD 7 0) (s.getD 8 0) (s.getD 13 0)
  let q3 := quarter (s.getD 3 0) (s.getD 4 0) (s.getD 9 0) (s.getD 14 0)
  [q0.1, q1.1, q2.1, q3.1, q3.2.1, q0.2.1, q1.2.1, q2.2.1,
    q2.2.2.1, q3.2.2.1, q0.2.2.1, q1.2.2.1, q1.2.2.2, q2.2.2.2, q3.2.2.2, q0.2.2.2]

theorem length_columns (s : List W32) : (columns s).length = 16 := rfl

theorem length_diagonals (s : List W32) : (diagonals s).length = 16 := rfl

/-- A double round is the quarter rounds on the columns and then those on the diagonals. -/
theorem inner_eq (s : List W32) (h : s.length = 16) : inner s = diagonals (columns s) := by
  rw [← eta16 s h]
  generalize s.getD 0 0 = x0, s.getD 1 0 = x1, s.getD 2 0 = x2, s.getD 3 0 = x3, s.getD 4 0 = x4,
    s.getD 5 0 = x5, s.getD 6 0 = x6, s.getD 7 0 = x7, s.getD 8 0 = x8, s.getD 9 0 = x9,
    s.getD 10 0 = x10, s.getD 11 0 = x11, s.getD 12 0 = x12, s.getD 13 0 = x13, s.getD 14 0 = x14,
    s.getD 15 0 = x15
  simp [inner, quarterAt, columns, diagonals]

/-- A list of `n + 1` elements is an element and a list of `n`. -/
theorem exists_cons_of_length {α : Type} {l : List α} {n : Nat} (h : l.length = n + 1) :
    ∃ x t, l = x :: t ∧ t.length = n := by
  cases l with
  | nil => simp at h
  | cons x t => exact ⟨x, t, rfl, by simpa using h⟩

/-- A function mapped over a state, word by word. -/
theorem map16 {β : Type} (f : W32 → β) (t : List W32) (h : t.length = 16) :
    t.map f = [f (t.getD 0 0), f (t.getD 1 0), f (t.getD 2 0), f (t.getD 3 0), f (t.getD 4 0),
      f (t.getD 5 0), f (t.getD 6 0), f (t.getD 7 0), f (t.getD 8 0), f (t.getD 9 0),
      f (t.getD 10 0), f (t.getD 11 0), f (t.getD 12 0), f (t.getD 13 0), f (t.getD 14 0),
      f (t.getD 15 0)] := by
  conv => lhs; rw [← eta16 t h]
  rfl

/-- The block function, word by word. -/
theorem block16 (s : List W32) (h : s.length = 16) :
    block s = [(innerN 10 s).getD 0 0 + s.getD 0 0, (innerN 10 s).getD 1 0 + s.getD 1 0,
      (innerN 10 s).getD 2 0 + s.getD 2 0, (innerN 10 s).getD 3 0 + s.getD 3 0,
      (innerN 10 s).getD 4 0 + s.getD 4 0, (innerN 10 s).getD 5 0 + s.getD 5 0,
      (innerN 10 s).getD 6 0 + s.getD 6 0, (innerN 10 s).getD 7 0 + s.getD 7 0,
      (innerN 10 s).getD 8 0 + s.getD 8 0, (innerN 10 s).getD 9 0 + s.getD 9 0,
      (innerN 10 s).getD 10 0 + s.getD 10 0, (innerN 10 s).getD 11 0 + s.getD 11 0,
      (innerN 10 s).getD 12 0 + s.getD 12 0, (innerN 10 s).getD 13 0 + s.getD 13 0,
      (innerN 10 s).getD 14 0 + s.getD 14 0, (innerN 10 s).getD 15 0 + s.getD 15 0] := by
  have et := eta16 (innerN 10 s) (by rw [length_innerN, h])
  have es := eta16 s h
  rw [block]
  generalize innerN 10 s = t at et ⊢
  generalize t.getD 0 0 = t0, t.getD 1 0 = t1, t.getD 2 0 = t2, t.getD 3 0 = t3, t.getD 4 0 = t4,
    t.getD 5 0 = t5, t.getD 6 0 = t6, t.getD 7 0 = t7, t.getD 8 0 = t8, t.getD 9 0 = t9,
    t.getD 10 0 = t10, t.getD 11 0 = t11, t.getD 12 0 = t12, t.getD 13 0 = t13, t.getD 14 0 = t14,
    t.getD 15 0 = t15 at et ⊢
  generalize s.getD 0 0 = x0, s.getD 1 0 = x1, s.getD 2 0 = x2, s.getD 3 0 = x3, s.getD 4 0 = x4,
    s.getD 5 0 = x5, s.getD 6 0 = x6, s.getD 7 0 = x7, s.getD 8 0 = x8, s.getD 9 0 = x9,
    s.getD 10 0 = x10, s.getD 11 0 = x11, s.getD 12 0 = x12, s.getD 13 0 = x13, s.getD 14 0 = x14,
    s.getD 15 0 = x15 at es ⊢
  subst et es
  rfl

theorem length_block (s : List W32) (h : s.length = 16) : (block s).length = 16 := by
  simp [block, length_innerN, h]

/-! ## For theorems about a machine -/

/-- The bytes of a cell of an array that holds of a state. -/
theorem cellsAt_cell {k : Nat} {σ : State} : ∀ {vs : List Word} {p : Word} {R : SProp},
    (cellsAt k true p vs).holds R σ → ∀ (i : Nat) (hi : i < vs.length) {x : Word},
      (x - (p + BitVec.ofNat 64 (k * i))).toNat < k →
      σ.mem x =
        some ⟨(vs[i] >>> ((x - (p + BitVec.ofNat 64 (k * i))) <<< 3)).truncate 8, true⟩
  | [], _, _, _, _, hi, _, _ => absurd hi (by simp)
  | v :: vs, p, R, h, 0, _, x, hx => by
    have := memIs_cell (x := x) (SProp.holds_assoc.1 h) (by simpa using hx)
    simpa using this
  | v :: vs, p, R, h, i + 1, hi, x, hx => by
    have h' : (iprop(cellsAt k true (p + BitVec.ofNat 64 k) vs ∗ memIs p k v true) :
        SProp).holds R σ := SProp.holds_mono sep_comm.1 h
    have := cellsAt_cell (SProp.holds_assoc.1 h') i (by simpa using hi) (x := x)
      (by rwa [cells_addr_succ])
    simpa [cells_addr_succ] using this

/-- The bytes of a cell of an array in a list of atoms that holds of a state. -/
theorem cell_of_holds {k : Nat} {σ : State} {as : Atoms} {R : SProp} {p : Word}
    {vs : List Word} (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.prop (cellsAt k true p vs))) (i : Nat) (hi : i < vs.length) {x : Word}
    (hx : (x - (p + BitVec.ofNat 64 (k * i))).toNat < k) :
    σ.mem x =
      some ⟨(vs[i] >>> ((x - (p + BitVec.ofNat 64 (k * i))) <<< 3)).truncate 8, true⟩ := by
  obtain ⟨F, e⟩ := hat.split
  rw [e] at h
  exact cellsAt_cell (SProp.holds_assoc.1 h) i hi hx

/-- Disjointness of a state that begins with an array written out. -/
theorem pairwise_cells_append {k : Nat} {w : Bool} {p : Word} {vs : List Word} {l : Atoms}
    (hlen : k * vs.length ≤ 2 ^ 64) (hl : l.Pairwise Atom.Disj)
    (hc : ∀ a ∈ cellsAtoms k w p vs, ∀ b ∈ l, Atom.Disj a b) :
    (cellsAtoms k w p vs ++ l).Pairwise Atom.Disj :=
  List.pairwise_append.2 ⟨cellsAtoms_pairwise hlen, hl, hc⟩

/-- An array of `n` writable cells of `k` bytes from `p` on, which hold some values: what a
function leaves of the part of its frame that it does not restore. -/
def cellsAny (k : Nat) (p : Word) (n : Nat) : SProp :=
  iprop(∃ vs : { l : List Word // l.length = n }, cellsAt k true p vs.1)

/-- Forget the values of an array. -/
theorem Triple.forget_cells {P : Program} {as as' : Atoms} {k n : Nat} {p : Word}
    {vs : List Word} {Q : SProp} (hn : vs.length = n)
    (hupd : as.Upd (.prop (cellsAt k true p vs)) (.prop (cellsAny k p n)) as')
    (h : Triple P (Atoms.interp as') Q) : Triple P (Atoms.interp as) Q := by
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h.conseq (sep_mono_left (fun _ hv => ⟨_, ⟨⟨vs, hn⟩, rfl⟩, hv⟩)) .rfl

/-- Replace an atom of the symbolic state by one that means the same: for a memory atom
whose address the stepper computes in two ways that are equal by definition but are not
written the same, since it finds memory atoms by syntactic equality of addresses. -/
theorem Triple.restate {P : Program} {as as' : Atoms} {a a' : Atom} {Q : SProp}
    (he : a.interp = a'.interp) (hupd : as.Upd a a' as')
    (h : Triple P (Atoms.interp as') Q) : Triple P (Atoms.interp as) Q := by
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e, he]; rw [e'] at h
  exact h

/-- Finish, when the symbolic state is the `n` atoms of the postcondition in another order.
`braid_done` does this by a `repeat` inside a `repeat`, which reaches the limit on the depth
of recursion on a state of about thirty atoms; here the outer loop is counted instead. -/
macro "braid_done_perm " n:num : tactic =>
  `(tactic| (braid_norm
             apply Triple.done_split
             iterate $n (apply Atoms.Split.cons; · braid_extract)
             exact Atoms.Split.nil))

/-- Every atom of an array is disjoint from every atom of a list that has no memory atom. -/
theorem disj_cellsAtoms_rest {k : Nat} {w : Bool} {p : Word} {vs : List Word} {l : Atoms}
    (h : ∀ b ∈ l, ∀ q n v w', Atom.Disj b (.mem q n v w')) :
    ∀ a ∈ cellsAtoms k w p vs, ∀ b ∈ l, Atom.Disj a b :=
  fun a ha b hb => (disj_cellsAtoms_of_not_mem (h b hb) a ha).symm

/-- Every atom of an array is disjoint from a memory atom that the array is apart from. -/
theorem disj_cellsAtoms_mem {k n : Nat} {w w' : Bool} {p q v : Word} {vs : List Word}
    (h₁ : k * vs.length ≤ (q - p).toNat) (h₂ : n ≤ (p - q).toNat) :
    ∀ a ∈ cellsAtoms k w p vs, Atom.Disj a (.mem q n v w') :=
  fun a ha => cellsAtoms_disj (k' := n) (w' := w') (ys := [v]) h₁ (by simpa using h₂) a ha _
    (by simp [cellsAtoms])

/-- Atoms disjoint from an atom and from those of a list are disjoint from those of the list
with the atom in front. -/
theorem disj_cons {as l : Atoms} {b : Atom} (h₁ : ∀ a ∈ as, Atom.Disj a b)
    (h₂ : ∀ a ∈ as, ∀ b ∈ l, Atom.Disj a b) : ∀ a ∈ as, ∀ c ∈ b :: l, Atom.Disj a c := by
  intro a ha c hc
  rcases List.mem_cons.1 hc with rfl | hc
  · exact h₁ a ha
  · exact h₂ a ha c hc

/-- Atoms disjoint from those of two lists are disjoint from those of the two appended. -/
theorem disj_append {as xs ys : Atoms} (h₁ : ∀ a ∈ as, ∀ b ∈ xs, Atom.Disj a b)
    (h₂ : ∀ a ∈ as, ∀ b ∈ ys, Atom.Disj a b) : ∀ a ∈ as, ∀ b ∈ xs ++ ys, Atom.Disj a b :=
  fun a ha b hb => (List.mem_append.1 hb).elim (h₁ a ha b) (h₂ a ha b)

/-- Prove that no atom of a list written out, of registers, flags and the program counter,
overlaps a memory atom. -/
macro "braid_not_mem" : tactic =>
  `(tactic| (simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
               and_true]
             repeat' apply And.intro
             all_goals first
               | exact fun _ _ _ _ => Atom.disj_reg_mem
               | exact fun _ _ _ _ => Atom.disj_flag_mem
               | exact fun _ _ _ _ => Atom.disj_pc_mem))

/-- Every atom of an array is disjoint from a register. -/
theorem disj_cellsAtoms_reg {k : Nat} {w : Bool} {p : Word} {vs : List Word} {r : Reg}
    {v : Word} : ∀ a ∈ cellsAtoms k w p vs, Atom.Disj a (.reg r v) :=
  fun a ha => (disj_reg_cellsAtoms a ha).symm

/-- Every atom of an array is disjoint from a flag. -/
theorem disj_cellsAtoms_flag {k : Nat} {w : Bool} {p : Word} {vs : List Word} {f : Flag}
    {c : Bool} : ∀ a ∈ cellsAtoms k w p vs, Atom.Disj a (.flag f c) :=
  fun a ha => (disj_flag_cellsAtoms a ha).symm

/-- Every atom of an array is disjoint from the program counter. -/
theorem disj_cellsAtoms_pc {k : Nat} {w : Bool} {p : Word} {vs : List Word} {x : Word} :
    ∀ a ∈ cellsAtoms k w p vs, Atom.Disj a (.pc x) :=
  fun a ha => (disj_pc_cellsAtoms a ha).symm

end Examples.ChaCha20
