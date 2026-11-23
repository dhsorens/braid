/-
  Examples.Sha256.Common

  What the proofs of `sha256.c` share between instruction sets: how the data of SHA-256 lies
  in memory, the mathematics that takes the specification (`Examples.Spec.Sha256`) to the
  form the loops of the machine code compute it in, and the tactics that keep symbolic
  execution apart from that mathematics. Nothing here mentions a machine.

  Symbolic execution leaves a register or a cell with the value the code computed, a 64-bit
  expression. `sha256_reg` and `sha256_cell` replace it by a value of the specification, and
  leave the equation between the two as a goal of its own, about bit vectors only, which
  `sha256_bv` proves by unfolding the specification and `bv_decide`. So a term the machine
  code built never outlives the instructions that built it.

  ## Main definitions

  * `w32s`: a list of 32-bit words as the cells of an array
  * `Vars.toList`, `Vars.ofList`, `roundKW`: the working variables in memory order, those a
    hash value starts with, and one round given its constant and its word of the schedule
  * `nextWord`, `extend`: the message schedule as a window of sixteen words that slides
  * `roundsFrom`: rounds `t`, `t + 1`, ..., one at a time
  * `sha256_reg`, `sha256_cell`, `sha256_bv`, `sha256_fold`: the tactics

  ## Main results

  * `schedule_eq_extend`: the schedule of a block is the block, extended by 48 words
  * `rounds_eq_roundsFrom`: the 64 rounds, one at a time
  * `compress_eq`: the compression function in the terms above
  * `cells8`, `cells16`, `cells_win16`, `cells_win17`, `cells_w32_index`: arrays of 32-bit
    words as memory atoms: all of one, the window of the schedule, and one opened at an index
  * `Triple.reg_val`, `Triple.mem4_val`: a value of the symbolic state replaced by an equal one
  * `pairwise_regs_mems`, `cellsAtoms_disj_of_apart`, `cellsAtoms_disj_readOnly`,
    `cell_of_holds`: a state with several arrays written out for a theorem about a machine,
    and an array read off a postcondition
-/

module

public import Examples.Spec.Sha256
public import Braid.Logic
import Iris.BI.DerivedLaws
import Std.Tactic.BVDecide
import Braid.BV

@[expose] public section

namespace Examples.Sha256

open Braid

/-! ## Data in memory -/

/-- A list of 32-bit words, as the cells of an array in memory: each word zero-extended. -/
def w32s (xs : List W32) : List Word := xs.map (BitVec.setWidth 64)

@[simp] theorem w32s_length (xs : List W32) : (w32s xs).length = xs.length := by simp [w32s]

theorem w32s_getElem (xs : List W32) (i : Nat) (h : i < (w32s xs).length) :
    (w32s xs)[i] = (xs.getD i 0).setWidth 64 := by
  have h' : i < xs.length := by simpa using h
  simp [w32s, h']

theorem w32s_append (xs ys : List W32) : w32s (xs ++ ys) = w32s xs ++ w32s ys := by
  simp [w32s]

theorem w32s_cons (x : W32) (xs : List W32) : w32s (x :: xs) = x.setWidth 64 :: w32s xs := rfl

/-- The working variables, in the order they lie in memory. -/
def Vars.toList (v : Vars) : List W32 := [v.a, v.b, v.c, v.d, v.e, v.f, v.g, v.h]

/-- A list of sixteen is sixteen elements. -/
theorem eq_of_length_16 {α : Type} {l : List α} (h : l.length = 16) :
    ∃ x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15,
      l = [x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15] := by
  match l, h with
  | [x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15], _ =>
    exact ⟨x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, rfl⟩

/-- A list of eight is eight elements. -/
theorem eq_of_length_8 {α : Type} {l : List α} (h : l.length = 8) :
    ∃ x0 x1 x2 x3 x4 x5 x6 x7, l = [x0, x1, x2, x3, x4, x5, x6, x7] := by
  match l, h with
  | [x0, x1, x2, x3, x4, x5, x6, x7], _ => exact ⟨x0, x1, x2, x3, x4, x5, x6, x7, rfl⟩

/-- An array is its memory atoms. -/
theorem cells_eq_atoms (k : Nat) (w : Bool) (p : Word) (vs : List Word) :
    (Atom.prop (cellsAt k w p vs)).interp = Atoms.interp (cellsAtoms k w p vs) :=
  cellsAt_eq_interp p vs

/-- An array of eight 32-bit cells, as memory atoms. -/
theorem cells8 (w : Bool) (p v0 v1 v2 v3 v4 v5 v6 v7 : Word) :
    (Atom.prop (cellsAt 4 w p [v0, v1, v2, v3, v4, v5, v6, v7])).interp =
      Atoms.interp [.mem p 4 v0 w, .mem (p + 4#64) 4 v1 w, .mem (p + 8#64) 4 v2 w,
        .mem (p + 12#64) 4 v3 w, .mem (p + 16#64) 4 v4 w, .mem (p + 20#64) 4 v5 w,
        .mem (p + 24#64) 4 v6 w, .mem (p + 28#64) 4 v7 w] := by
  rw [cells_eq_atoms]
  simp only [cellsAtoms, BitVec.add_assoc, BitVec.reduceAdd]

/-- An array of sixteen 32-bit cells, as memory atoms. -/
theorem cells16 (w : Bool) (p v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word) :
    (Atom.prop (cellsAt 4 w p
      [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15])).interp =
      Atoms.interp [.mem p 4 v0 w, .mem (p + 4#64) 4 v1 w, .mem (p + 8#64) 4 v2 w,
        .mem (p + 12#64) 4 v3 w, .mem (p + 16#64) 4 v4 w, .mem (p + 20#64) 4 v5 w,
        .mem (p + 24#64) 4 v6 w, .mem (p + 28#64) 4 v7 w, .mem (p + 32#64) 4 v8 w,
        .mem (p + 36#64) 4 v9 w, .mem (p + 40#64) 4 v10 w, .mem (p + 44#64) 4 v11 w,
        .mem (p + 48#64) 4 v12 w, .mem (p + 52#64) 4 v13 w, .mem (p + 56#64) 4 v14 w,
        .mem (p + 60#64) 4 v15 w] := by
  rw [cells_eq_atoms]
  simp only [cellsAtoms, BitVec.add_assoc, BitVec.reduceAdd]

/-- The working variables in memory, as memory atoms. -/
theorem cells_vars (w : Bool) (p : Word) (v : Vars) :
    (Atom.prop (cellsAt 4 w p (w32s v.toList))).interp =
      Atoms.interp [.mem p 4 (v.a.setWidth 64) w, .mem (p + 4#64) 4 (v.b.setWidth 64) w,
        .mem (p + 8#64) 4 (v.c.setWidth 64) w, .mem (p + 12#64) 4 (v.d.setWidth 64) w,
        .mem (p + 16#64) 4 (v.e.setWidth 64) w, .mem (p + 20#64) 4 (v.f.setWidth 64) w,
        .mem (p + 24#64) 4 (v.g.setWidth 64) w, .mem (p + 28#64) 4 (v.h.setWidth 64) w] :=
  cells8 w p _ _ _ _ _ _ _ _

/-- Eight 32-bit words in memory, as memory atoms. -/
theorem cells8_w32 (w : Bool) (p : Word) (x0 x1 x2 x3 x4 x5 x6 x7 : W32) :
    (Atom.prop (cellsAt 4 w p (w32s [x0, x1, x2, x3, x4, x5, x6, x7]))).interp =
      Atoms.interp [.mem p 4 (x0.setWidth 64) w, .mem (p + 4#64) 4 (x1.setWidth 64) w,
        .mem (p + 8#64) 4 (x2.setWidth 64) w, .mem (p + 12#64) 4 (x3.setWidth 64) w,
        .mem (p + 16#64) 4 (x4.setWidth 64) w, .mem (p + 20#64) 4 (x5.setWidth 64) w,
        .mem (p + 24#64) 4 (x6.setWidth 64) w, .mem (p + 28#64) 4 (x7.setWidth 64) w] :=
  cells8 w p _ _ _ _ _ _ _ _

/-- Sixteen 32-bit words in memory, as memory atoms. -/
theorem cells16_w32 (w : Bool) (p : Word)
    (x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 : W32) :
    (Atom.prop (cellsAt 4 w p (w32s
      [x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15]))).interp =
      Atoms.interp [.mem p 4 (x0.setWidth 64) w, .mem (p + 4#64) 4 (x1.setWidth 64) w,
        .mem (p + 8#64) 4 (x2.setWidth 64) w, .mem (p + 12#64) 4 (x3.setWidth 64) w,
        .mem (p + 16#64) 4 (x4.setWidth 64) w, .mem (p + 20#64) 4 (x5.setWidth 64) w,
        .mem (p + 24#64) 4 (x6.setWidth 64) w, .mem (p + 28#64) 4 (x7.setWidth 64) w,
        .mem (p + 32#64) 4 (x8.setWidth 64) w, .mem (p + 36#64) 4 (x9.setWidth 64) w,
        .mem (p + 40#64) 4 (x10.setWidth 64) w, .mem (p + 44#64) 4 (x11.setWidth 64) w,
        .mem (p + 48#64) 4 (x12.setWidth 64) w, .mem (p + 52#64) 4 (x13.setWidth 64) w,
        .mem (p + 56#64) 4 (x14.setWidth 64) w, .mem (p + 60#64) 4 (x15.setWidth 64) w] :=
  cells16 w p _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- An array that starts with a given list of cells is those cells as memory atoms, and the
rest of the array. -/
theorem cells_prefix (k : Nat) (w : Bool) (p : Word) (pre js : List Word) :
    (Atom.prop (cellsAt k w p (pre ++ js))).interp =
      Atoms.interp (cellsAtoms k w p pre ++
        [.prop (cellsAt k w (p + BitVec.ofNat 64 (k * pre.length)) js)]) := by
  rw [Atoms.interp_append, ← cellsAt_eq_interp]
  show cellsAt k w p (pre ++ js) = _
  rw [cellsAt_append]
  exact SProp.ext ⟨Iris.BI.sep_mono_right Iris.BI.sep_emp.2,
    Iris.BI.sep_mono_right Iris.BI.sep_emp.1⟩

/-- An array that starts with sixteen 32-bit words: the window of the message schedule as
memory atoms, and the rest of the array. -/
theorem cells_win16 (w : Bool) (p : Word) (x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 :
  W32) (js : List Word) :
    (Atom.prop (cellsAt 4 w p (w32s [x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13,
      x14, x15] ++ js))).interp =
      Atoms.interp [.mem p 4 (x0.setWidth 64) w, .mem (p + 4#64) 4 (x1.setWidth 64) w,
        .mem (p + 8#64) 4 (x2.setWidth 64) w, .mem (p + 12#64) 4 (x3.setWidth 64) w,
        .mem (p + 16#64) 4 (x4.setWidth 64) w, .mem (p + 20#64) 4 (x5.setWidth 64) w,
        .mem (p + 24#64) 4 (x6.setWidth 64) w, .mem (p + 28#64) 4 (x7.setWidth 64) w,
        .mem (p + 32#64) 4 (x8.setWidth 64) w, .mem (p + 36#64) 4 (x9.setWidth 64) w,
        .mem (p + 40#64) 4 (x10.setWidth 64) w, .mem (p + 44#64) 4 (x11.setWidth 64) w,
        .mem (p + 48#64) 4 (x12.setWidth 64) w, .mem (p + 52#64) 4 (x13.setWidth 64) w,
        .mem (p + 56#64) 4 (x14.setWidth 64) w, .mem (p + 60#64) 4 (x15.setWidth 64) w,
        .prop (cellsAt 4 w (p + 64#64) js)] := by
  rw [cells_prefix]
  simp only [w32s, List.map, cellsAtoms, List.length_cons, List.length_nil, List.cons_append,
    List.nil_append, BitVec.add_assoc, BitVec.reduceAdd, Nat.reduceMul, Nat.reduceAdd]

/-- An array that starts with sixteen 32-bit words and one more cell: the window of the
message schedule and the cell its next word goes to, as memory atoms, and the rest. -/
theorem cells_win17 (w : Bool) (p : Word) (x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 :
  W32) (j : Word) (js : List Word) :
    (Atom.prop (cellsAt 4 w p (w32s [x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13,
      x14, x15] ++ j :: js))).interp =
      Atoms.interp [.mem p 4 (x0.setWidth 64) w, .mem (p + 4#64) 4 (x1.setWidth 64) w,
        .mem (p + 8#64) 4 (x2.setWidth 64) w, .mem (p + 12#64) 4 (x3.setWidth 64) w,
        .mem (p + 16#64) 4 (x4.setWidth 64) w, .mem (p + 20#64) 4 (x5.setWidth 64) w,
        .mem (p + 24#64) 4 (x6.setWidth 64) w, .mem (p + 28#64) 4 (x7.setWidth 64) w,
        .mem (p + 32#64) 4 (x8.setWidth 64) w, .mem (p + 36#64) 4 (x9.setWidth 64) w,
        .mem (p + 40#64) 4 (x10.setWidth 64) w, .mem (p + 44#64) 4 (x11.setWidth 64) w,
        .mem (p + 48#64) 4 (x12.setWidth 64) w, .mem (p + 52#64) 4 (x13.setWidth 64) w,
        .mem (p + 56#64) 4 (x14.setWidth 64) w, .mem (p + 60#64) 4 (x15.setWidth 64) w,
        .mem (p + 64#64) 4 j w, .prop (cellsAt 4 w (p + 68#64) js)] := by
  rw [List.append_cons, cells_prefix]
  simp only [w32s, List.map, cellsAtoms, List.length_cons, List.length_nil, List.cons_append,
    List.nil_append, BitVec.add_assoc, BitVec.reduceAdd, Nat.reduceMul, Nat.reduceAdd]

/-- `cells_win16`, with the address of the array written another way: for closing an array
at an address that the induction hypothesis of a loop writes differently. -/
theorem cells_win16_at (w : Bool) (p p' : Word) (h : p' = p) (x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11
  x12 x13 x14 x15 : W32)
    (js : List Word) :
    (Atom.prop (cellsAt 4 w p' (w32s [x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13,
      x14, x15] ++ js))).interp =
      Atoms.interp [.mem p 4 (x0.setWidth 64) w, .mem (p + 4#64) 4 (x1.setWidth 64) w,
        .mem (p + 8#64) 4 (x2.setWidth 64) w, .mem (p + 12#64) 4 (x3.setWidth 64) w,
        .mem (p + 16#64) 4 (x4.setWidth 64) w, .mem (p + 20#64) 4 (x5.setWidth 64) w,
        .mem (p + 24#64) 4 (x6.setWidth 64) w, .mem (p + 28#64) 4 (x7.setWidth 64) w,
        .mem (p + 32#64) 4 (x8.setWidth 64) w, .mem (p + 36#64) 4 (x9.setWidth 64) w,
        .mem (p + 40#64) 4 (x10.setWidth 64) w, .mem (p + 44#64) 4 (x11.setWidth 64) w,
        .mem (p + 48#64) 4 (x12.setWidth 64) w, .mem (p + 52#64) 4 (x13.setWidth 64) w,
        .mem (p + 56#64) 4 (x14.setWidth 64) w, .mem (p + 60#64) 4 (x15.setWidth 64) w,
        .prop (cellsAt 4 w (p + 64#64) js)] := by
  subst h
  exact cells_win16 w p' _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ js

/-- `cellsAt_cons` for 32-bit cells, with the address of the rest written another way. -/
theorem cells_cons_at (w : Bool) (p p' : Word) (h : p' = p + 4#64) (v : Word)
    (vs : List Word) :
    (Atom.prop (cellsAt 4 w p (v :: vs))).interp =
      Atoms.interp [.mem p 4 v w, .prop (cellsAt 4 w p' vs)] := by
  subst h
  exact cellsAt_cons p v vs

/-- An array of at least sixteen cells: the first sixteen as memory atoms, and the rest. -/
theorem cells_pre16 (w : Bool) (p : Word) (v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 :
  Word)
    (js : List Word) :
    (Atom.prop (cellsAt 4 w p
      (v0 :: v1 :: v2 :: v3 :: v4 :: v5 :: v6 :: v7 :: v8 :: v9 :: v10 :: v11 :: v12 :: v13 :: v14
        :: v15 ::
        js))).interp =
      Atoms.interp [.mem p 4 v0 w, .mem (p + 4#64) 4 v1 w, .mem (p + 8#64) 4 v2 w,
        .mem (p + 12#64) 4 v3 w, .mem (p + 16#64) 4 v4 w, .mem (p + 20#64) 4 v5 w,
        .mem (p + 24#64) 4 v6 w, .mem (p + 28#64) 4 v7 w, .mem (p + 32#64) 4 v8 w,
        .mem (p + 36#64) 4 v9 w, .mem (p + 40#64) 4 v10 w, .mem (p + 44#64) 4 v11 w,
        .mem (p + 48#64) 4 v12 w, .mem (p + 52#64) 4 v13 w, .mem (p + 56#64) 4 v14 w,
        .mem (p + 60#64) 4 v15 w, .prop (cellsAt 4 w (p + 64#64) js)] := by
  rw [show (v0 :: v1 :: v2 :: v3 :: v4 :: v5 :: v6 :: v7 :: v8 :: v9 :: v10 :: v11 :: v12 :: v13 ::
    v14 :: v15 :: js) =
    [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15] ++ js from rfl,
    cells_prefix]
  simp only [cellsAtoms, List.length_cons, List.length_nil, List.cons_append,
    List.nil_append, BitVec.add_assoc, BitVec.reduceAdd, Nat.reduceMul, Nat.reduceAdd]

/-- A list of at least sixteen is sixteen elements and the rest. -/
theorem eq_of_length_16_add {α : Type} {l : List α} {n : Nat} (h : l.length = 16 + n) :
    ∃ x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 js,
      l = x0 :: x1 :: x2 :: x3 :: x4 :: x5 :: x6 :: x7 :: x8 :: x9 :: x10 :: x11 :: x12 ::
        x13 :: x14 :: x15 :: js ∧ js.length = n := by
  have h1 : (l.take 16).length = 16 := by simp [h]
  obtain ⟨x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, e⟩ :=
    eq_of_length_16 h1
  have := List.take_append_drop 16 l
  rw [e] at this
  exact ⟨x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, l.drop 16,
    this.symm, by simp [h]⟩

/-- The offset of the next 32-bit word. -/
theorem ofNat_mul4_succ (t : Nat) :
    BitVec.ofNat 64 (4 * t) + 4#64 = BitVec.ofNat 64 (4 * (t + 1)) := by
  rw [Nat.mul_succ, BitVec.ofNat_add]

/-- **An array of 32-bit words, opened at index `t`**: the cells before, cell `t` as a
memory atom at the offset `4 * t`, and the cells after. -/
theorem cells_w32_index (w : Bool) (p : Word) (xs : List W32) (t : Nat) (ht : t < xs.length) :
    (Atom.prop (cellsAt 4 w p (w32s xs))).interp =
      Atoms.interp [.prop (cellsAt 4 w p ((w32s xs).take t)),
        .mem (p + BitVec.ofNat 64 (4 * t)) 4 ((xs.getD t 0).setWidth 64) w,
        .prop (cellsAt 4 w (p + BitVec.ofNat 64 (4 * (t + 1))) ((w32s xs).drop (t + 1)))] := by
  have ht' : t < (w32s xs).length := by simpa using ht
  rw [cellsAt_index p (w32s xs) t ht', w32s_getElem xs t ht']

/-- `cells_w32_index`, with the address of cell `t` written another way: the way the code
computes it. -/
theorem cells_w32_index_at (w : Bool) (p addr : Word) (xs : List W32) (t : Nat)
    (ht : t < xs.length) (h : addr = p + BitVec.ofNat 64 (4 * t)) :
    (Atom.prop (cellsAt 4 w p (w32s xs))).interp =
      Atoms.interp [.prop (cellsAt 4 w p ((w32s xs).take t)),
        .mem addr 4 ((xs.getD t 0).setWidth 64) w,
        .prop (cellsAt 4 w (p + BitVec.ofNat 64 (4 * (t + 1))) ((w32s xs).drop (t + 1)))] := by
  subst h
  exact cells_w32_index w p xs t ht

/-- Four bytes of memory hold only the low 32 bits of the word written to them. -/
theorem Heap.bytes_setWidth32 (a v : Word) (w : Bool) :
    Heap.bytes a 4 v w = Heap.bytes a 4 ((v.setWidth 32).setWidth 64) w := by
  funext l
  cases l with
  | mem x =>
    simp only [Heap.bytes]
    split
    · rename_i hx
      have hx' : x - a < 4#64 := by bv_omega
      generalize x - a = d at hx'
      congr 3
      bv_auto
    · rfl
  | _ => rfl

/-! ## One round -/

/-- One round of the compression function, given the round constant `k` and the word `w` of
the schedule. -/
def roundKW (k w : W32) (v : Vars) : Vars :=
  let T₁ := v.h + bigSigma1 v.e + Ch v.e v.f v.g + k + w
  let T₂ := bigSigma0 v.a + Maj v.a v.b v.c
  { h := v.g, g := v.f, f := v.e, e := v.d + T₁, d := v.c, c := v.b, b := v.a, a := T₁ + T₂ }

/-- Round `t` is `roundKW` with the constant and the word of the schedule of index `t`. -/
theorem round_eq_roundKW (W : List W32) (v : Vars) (t : Nat) :
    round W v t = roundKW (K.getD t 0) (W.getD t 0) v := rfl

/-! ## The message schedule, as a sliding window -/

/-- The word of the schedule that follows a window of sixteen. -/
def nextWord (win : List W32) : W32 :=
  smallSigma1 (win.getD 14 0) + win.getD 9 0 + smallSigma0 (win.getD 1 0) + win.getD 0 0

/-- The word that follows a window of sixteen, with the window written out. -/
theorem nextWord_eq (w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 : W32) :
    nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15] =
      smallSigma1 w14 + w9 + smallSigma0 w1 + w0 := rfl

/-- A window of sixteen words of the schedule, followed by the next `n` words: each is
computed from the sixteen before it. -/
def extend : Nat → List W32 → List W32
  | 0, win => win
  | _ + 1, [] => []
  | n + 1, x :: win => x :: extend n (win ++ [nextWord (x :: win)])

/-- One step of `schedule`: the words so far, and word `t`. -/
def scheduleStep (M W : List W32) (t : Nat) : List W32 :=
  W ++ [if t < 16 then M.getD t 0
        else smallSigma1 (W.getD (t - 2) 0) + W.getD (t - 7) 0 +
          smallSigma0 (W.getD (t - 15) 0) + W.getD (t - 16) 0]

theorem scheduleStep_window (M pre win : List W32) :
    scheduleStep M (pre ++ win) (pre.length + 16) = pre ++ win ++ [nextWord win] := by
  have e1 : pre.length + 16 - 2 = pre.length + 14 := by omega
  have e2 : pre.length + 16 - 7 = pre.length + 9 := by omega
  have e3 : pre.length + 16 - 15 = pre.length + 1 := by omega
  have e4 : pre.length + 16 - 16 = pre.length + 0 := by omega
  have hg (i : Nat) : (pre ++ win).getD (pre.length + i) 0 = win.getD i 0 := by
    rw [List.getD_eq_getElem?_getD, List.getD_eq_getElem?_getD,
      List.getElem?_append_right (Nat.le_add_right _ _), Nat.add_sub_cancel_left]
  have hlt : ¬ pre.length + 16 < 16 := by omega
  simp only [scheduleStep, hlt, ↓reduceIte, e1, e2, e3, e4, hg, nextWord]

theorem foldl_scheduleStep (M : List W32) : ∀ (n : Nat) (pre win : List W32),
    win.length = 16 →
    (List.range' (pre.length + 16) n).foldl (scheduleStep M) (pre ++ win) =
      pre ++ extend n win
  | 0, pre, win, _ => rfl
  | n + 1, pre, [], h => by simp at h
  | n + 1, pre, x :: win, h => by
    have ih := foldl_scheduleStep M n (pre ++ [x]) (win ++ [nextWord (x :: win)])
      (by simpa using h)
    simp only [List.length_append, List.length_singleton, List.append_assoc,
      List.singleton_append] at ih
    rw [List.range'_succ, List.foldl_cons, scheduleStep_window M pre (x :: win)]
    simp only [List.append_assoc, List.cons_append, extend]
    rw [Nat.add_right_comm]
    exact ih

/-- **The schedule of a block is the block, extended by 48 words.** -/
theorem schedule_eq_extend (M : List W32) (h : M.length = 16) : schedule M = extend 48 M := by
  have e : schedule M = (List.range 64).foldl (scheduleStep M) [] := rfl
  have hr : List.range 64 = List.range' 0 16 ++ List.range' 16 48 := by decide
  rw [e, hr, List.foldl_append]
  have h16 : (List.range' 0 16).foldl (scheduleStep M) [] = M := by
    obtain ⟨x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, rfl⟩ :=
      eq_of_length_16 h
    rfl
  rw [h16]
  exact foldl_scheduleStep M 48 [] M h

theorem extend_length : ∀ (n : Nat) (win : List W32), win.length = 16 →
    (extend n win).length = 16 + n
  | 0, win, h => h
  | n + 1, [], h => by simp at h
  | n + 1, x :: win, h => by
    have := extend_length n (win ++ [nextWord (x :: win)]) (by simpa using h)
    simp only [extend, List.length_cons, this]
    omega

/-- The schedule of a block is 64 words. -/
theorem schedule_length (M : List W32) (h : M.length = 16) : (schedule M).length = 64 := by
  rw [schedule_eq_extend M h, extend_length 48 M h]

/-- The window slides by one word. -/
theorem w32s_extend_succ (n : Nat) (w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 : W32) :
    w32s (extend (n + 1) [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]) =
      w0.setWidth 64 :: w32s (extend n [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13,
        w14, w15, nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14,
          w15]]) := rfl

/-- A window of sixteen words, extended by one. -/
theorem w32s_extend_one (w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 : W32) :
    w32s (extend 1 [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15]) =
      w32s [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15] ++
        [(nextWord [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14,
          w15]).setWidth 64] := rfl

/-! ## The rounds, one at a time -/

/-- Rounds `t`, `t + 1`, ..., `t + n - 1`, in that order. -/
def roundsFrom (W : List W32) : Nat → Nat → Vars → Vars
  | _, 0, v => v
  | t, n + 1, v => roundsFrom W (t + 1) n (round W v t)

theorem roundsFrom_succ (W : List W32) (t n : Nat) (v : Vars) :
    roundsFrom W t (n + 1) v = roundsFrom W (t + 1) n (round W v t) := rfl

theorem roundsFrom_one (W : List W32) (t : Nat) (v : Vars) :
    roundsFrom W t 1 v = round W v t := rfl

theorem rounds_succ (W : List W32) (v : Vars) (t : Nat) :
    rounds W v (t + 1) = round W (rounds W v t) t := by
  simp [rounds, List.range_succ]

theorem rounds_add (W : List W32) (v : Vars) : ∀ (n t : Nat),
    rounds W v (t + n) = roundsFrom W t n (rounds W v t)
  | 0, _ => rfl
  | n + 1, t => by
    rw [roundsFrom, ← rounds_succ, ← rounds_add W v n (t + 1)]
    congr 1
    omega

/-- **The 64 rounds, one at a time.** -/
theorem rounds_eq_roundsFrom (W : List W32) (v : Vars) : rounds W v 64 = roundsFrom W 0 64 v :=
  rounds_add W v 64 0

/-- The working variables a hash value starts the rounds with. -/
def Vars.ofList (H : List W32) : Vars :=
  ⟨H.getD 0 0, H.getD 1 0, H.getD 2 0, H.getD 3 0, H.getD 4 0, H.getD 5 0, H.getD 6 0, H.getD 7 0⟩

theorem Vars.ofList_eq (h0 h1 h2 h3 h4 h5 h6 h7 : W32) :
    Vars.ofList [h0, h1, h2, h3, h4, h5, h6, h7] = ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ := rfl

/-- The compression function of a hash value given as eight words: the rounds, and each
working variable added to its word of the hash value. -/
theorem compress_eq (h0 h1 h2 h3 h4 h5 h6 h7 : W32) (M : List W32) :
    compress [h0, h1, h2, h3, h4, h5, h6, h7] M =
      [(rounds (schedule M) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).a + h0,
       (rounds (schedule M) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).b + h1,
       (rounds (schedule M) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).c + h2,
       (rounds (schedule M) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).d + h3,
       (rounds (schedule M) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).e + h4,
       (rounds (schedule M) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).f + h5,
       (rounds (schedule M) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).g + h6,
       (rounds (schedule M) ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ 64).h + h7] :=
  rfl

/-! ## A state written out, for a theorem about a machine -/

/-- A points-to atom that is not memory: a register, a flag or the program counter. -/
def NotMem : Atom → Prop
  | .reg _ _ | .flag _ _ | .pc _ => True
  | _ => False

/-- A memory atom. -/
def IsMem : Atom → Prop
  | .mem _ _ _ _ => True
  | _ => False

theorem disj_notMem_isMem {a b : Atom} (ha : NotMem a) (hb : IsMem b) : Atom.Disj a b := by
  cases b with
  | mem q n v w =>
    cases a with
    | reg r x => exact Atom.disj_reg_mem
    | flag f x => exact Atom.disj_flag_mem
    | pc x => exact Atom.disj_pc_mem
    | mem _ _ _ _ => exact ha.elim
    | prop _ => exact ha.elim
  | _ => exact hb.elim

theorem isMem_cellsAtoms {k : Nat} {w : Bool} {p : Word} {vs : List Word} :
    ∀ b ∈ cellsAtoms k w p vs, IsMem b := by
  intro b hb
  obtain ⟨i, hi, rfl⟩ := mem_cellsAtoms.1 hb
  trivial

/-- Disjointness of a state written out as its registers, flags and program counter, and
then its memory. -/
theorem pairwise_regs_mems {l m : Atoms} (hl : l.Pairwise Atom.Disj)
    (hlm : ∀ a ∈ l, NotMem a) (hmm : ∀ b ∈ m, IsMem b) (hm : m.Pairwise Atom.Disj) :
    (l ++ m).Pairwise Atom.Disj :=
  List.pairwise_append.2 ⟨hl, hm, fun a ha b hb => disj_notMem_isMem (hlm a ha) (hmm b hb)⟩

/-- Atoms disjoint from those of two lists are disjoint from those of the two together. -/
theorem disj_append_right {A B C : Atoms} (h₁ : ∀ a ∈ A, ∀ b ∈ B, Atom.Disj a b)
    (h₂ : ∀ a ∈ A, ∀ b ∈ C, Atom.Disj a b) : ∀ a ∈ A, ∀ b ∈ B ++ C, Atom.Disj a b :=
  fun a ha b hb => (List.mem_append.1 hb).elim (h₁ a ha b) (h₂ a ha b)

theorem disj_nil_right {A : Atoms} : ∀ a ∈ A, ∀ b ∈ ([] : Atoms), Atom.Disj a b :=
  fun _ _ _ hb => absurd hb List.not_mem_nil

/-- The atoms of two arrays, with the second before the first. -/
theorem disj_flip {A B : Atoms} (h : ∀ a ∈ A, ∀ b ∈ B, Atom.Disj a b) :
    ∀ b ∈ B, ∀ a ∈ A, Atom.Disj b a :=
  fun b hb a ha => (h a ha b hb).symm

/-- Two regions that are not empty, inside two regions that are apart, are apart: `n'`
bytes at `a'` within the `n` bytes at `a`, and `k'` bytes at `b'` within the `k` bytes at
`b`. -/
theorem apart_sub {a b a' b' : Word} {n k n' k' : Nat} (h1 : n ≤ (b - a).toNat)
    (h2 : k ≤ (a - b).toNat) (hn : 0 < n') (hk : 0 < k') (ha : (a' - a).toNat + n' ≤ n)
    (hb : (b' - b).toNat + k' ≤ k) : n' ≤ (b' - a').toNat ∧ k' ≤ (a' - b').toNat := by
  bv_omega

/-- The atoms of two arrays that are not empty, inside two regions that are apart, are
disjoint. -/
theorem cellsAtoms_disj_of_apart {k k' : Nat} {w w' : Bool} {p q a b : Word} {n m : Nat}
    {xs ys : List Word} (h1 : n ≤ (b - a).toNat) (h2 : m ≤ (a - b).toNat)
    (hx : 0 < k * xs.length) (hy : 0 < k' * ys.length)
    (hp : (p - a).toNat + k * xs.length ≤ n) (hq : (q - b).toNat + k' * ys.length ≤ m) :
    ∀ x ∈ cellsAtoms k w p xs, ∀ y ∈ cellsAtoms k' w' q ys, Atom.Disj x y :=
  cellsAtoms_disj (apart_sub h1 h2 hx hy hp hq).1 (apart_sub h1 h2 hx hy hp hq).2

/-- A writable memory atom and a read-only one that are both true of a state are
disjoint: no byte is both. -/
theorem disj_of_sat_readOnly {σ : State} {a b v v' : Word} {n m : Nat}
    (h : (Atom.mem a n v true).sat σ) (h' : (Atom.mem b m v' false).sat σ) :
    Atom.Disj (.mem a n v true) (.mem b m v' false) :=
  Atom.disj_mem_mem fun x hx => by
    have h1 := Atom.sat_mem.1 h x hx.1
    have h2 := Atom.sat_mem.1 h' x hx.2
    rw [h1] at h2
    simp at h2

/-- The atoms of a writable array and of a read-only one that are all true of a state are
disjoint. -/
theorem cellsAtoms_disj_readOnly {σ : State} {k k' : Nat} {p q : Word} {xs ys : List Word}
    (h : ∀ a ∈ cellsAtoms k true p xs, a.sat σ) (h' : ∀ b ∈ cellsAtoms k' false q ys, b.sat σ) :
    ∀ a ∈ cellsAtoms k true p xs, ∀ b ∈ cellsAtoms k' false q ys, Atom.Disj a b := by
  intro a ha b hb
  have sa := h a ha
  have sb := h' b hb
  obtain ⟨i, hi, rfl⟩ := mem_cellsAtoms.1 ha
  obtain ⟨j, hj, rfl⟩ := mem_cellsAtoms.1 hb
  exact disj_of_sat_readOnly sa sb

/-- An array of a state that holds, opened at an index: the cell there is an atom of a
state that holds. -/
theorem cell_of_holds {as : Atoms} {R : SProp} {σ : State} {k : Nat} {w : Bool} {p : Word}
    {xs : List Word} (h : (Atoms.interp as).holds R σ) (hat : as.At (.prop (cellsAt k w p xs)))
    (i : Nat) (hi : i < xs.length) {x : Word} (hx : (x - (p + BitVec.ofNat 64 (k * i))).toNat < k) :
    σ.mem x = some ⟨(xs[i] >>> ((x - (p + BitVec.ofNat 64 (k * i))) <<< 3)).truncate 8, w⟩ := by
  obtain ⟨F, e⟩ := hat.split
  rw [e, cellsAt_index p xs i hi] at h
  exact Atoms.mem_of_holds (SProp.holds_assoc.1 h) (.there .here) hx

/-! ## Values of the symbolic state -/

/-- Replace the value of a register of the symbolic state by an equal one. -/
theorem _root_.Braid.Triple.reg_val {P : Program} {as as' : Atoms} {r : Reg} {v : Word}
    (v' : Word) {Q : SProp} (hupd : as.Upd (.reg r v) (.reg r v') as') (he : v = v')
    (h : Triple P (Atoms.interp as') Q) : Triple P (Atoms.interp as) Q := by
  subst he
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h

/-- Replace the value of a 32-bit cell of the symbolic state by one with the same low 32
bits. -/
theorem _root_.Braid.Triple.mem4_val {P : Program} {as as' : Atoms} {a v : Word} {w : Bool}
    (v' : Word) {Q : SProp} (hupd : as.Upd (.mem a 4 v w) (.mem a 4 v' w) as')
    (he : v.setWidth 32 = v'.setWidth 32)
    (h : Triple P (Atoms.interp as') Q) : Triple P (Atoms.interp as) Q := by
  obtain ⟨F, e, e'⟩ := hupd.split
  have key (x : Word) : memIs a 4 x w = memIs a 4 ((x.setWidth 32).setWidth 64) w := by
    funext h
    simp only [memIs, ← Heap.bytes_setWidth32 a x w]
  have em : (Atom.mem a 4 v w).interp = (Atom.mem a 4 v' w).interp := by
    show memIs a 4 v w = memIs a 4 v' w
    rw [key v, key v', he]
  rw [e, em]; rw [e'] at h
  exact h

/-- Prove that a value the machine code computed is a value of the specification: unfold
the specification down to bit vectors, and decide. -/
macro "sha256_bv" : tactic =>
  `(tactic| ((try simp only [round, roundKW, nextWord_eq, bigSigma0, bigSigma1, smallSigma0,
               smallSigma1, Ch, Maj, ROTR, SHR, trunc32_zext])
             first | done | rfl | bv_decide))

/-- Give a 32-bit cell of the symbolic state the value `v`, which has the same low 32 bits:
`sha256_cell a, v`. -/
macro "sha256_cell " a:term ", " v:term : tactic =>
  `(tactic| (refine Triple.mem4_val (a := $a) $v (by braid_upd) ?_ ?_
             · sha256_bv))

/-- Give a register of the symbolic state the equal value `v`: `sha256_reg r, v`. -/
macro "sha256_reg " r:term ", " v:term : tactic =>
  `(tactic| (refine Triple.reg_val (r := $r) $v (by braid_upd) ?_ ?_
             · sha256_bv))

/-- `braid_fold`, with the addresses of the lemma put in normal form first: for an array at
an address that is itself a sum. -/
macro "sha256_fold " t:term : tactic =>
  `(tactic| (have hfold := $t
             braid_norm at hfold
             braid_fold hfold
             clear hfold))

/-- Forget the values of the six status flags of x86-64, each of which holds a value or, when
the last instruction to write it left it undefined, already holds some value. -/
macro "x86_forget_all_flags" : tactic =>
  `(tactic| (try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 3
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-- Name the values of those of the six status flags of x86-64 that hold some value. -/
macro "x86_name_all_flags" : tactic =>
  `(tactic| (try braid_name_flag 0
             try braid_name_flag 1
             try braid_name_flag 2
             try braid_name_flag 3
             try braid_name_flag 4
             try braid_name_flag 5))

/-- Prove that register, flag and program-counter atoms are pairwise disjoint: `braid_disj`,
one pair at a time. -/
macro "sha256_disj" : tactic =>
  `(tactic| (braid_disj; all_goals ((repeat' apply And.intro) <;> decide)))

end Examples.Sha256
