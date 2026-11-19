/-
  Braid.Logic.Bytes

  Bytes and cells are the same memory. A loaded binary gives the logic its sections as arrays
  of bytes (`bytesAt`), and the code reads and writes them as cells of four or eight bytes
  (`memIs`, `cellsAt`). This file has the conversions between the two views: a cell of `k`
  bytes is the array of the low `k` bytes of its value, least significant first, and an array
  of cells is the array of the bytes of its cells, one after another. A zeroed section is an
  array of zero cells, and so an array of cells of forgotten contents.

  The equalities come in two forms: between assertions, for rewriting, and between an atom
  and a list of atoms, which is what `braid_unfold` and `braid_fold` take.

  ## Main definitions

  * `leBytes k v`: the low `k` bytes of the word `v`, least significant first

  ## Main results

  * `memIs_eq_bytesAt`, `mem_interp_bytesAt`, `bytesAt_leBytes`: a cell is its bytes
  * `bytesAt_append_eq`, `bytesAt_append`, `bytesAt_split`: an array of bytes, in two parts
  * `cellsAt_eq_bytesAt`, `bytesAt_eq_cellsAt`, `cellsAt_interp_bytesAt`,
    `bytesAt_interp_cellsAt`: an array of cells is the bytes of its cells
  * `bytesAt_zero_eq_cellsAt`, `bytesAt_zero_interp_cellsAt`: zeroed bytes are zero cells
  * `bytesAt_zero_entails_cellsAny`: zeroed bytes are cells of forgotten contents
  * `bytesAt_zero_add`: zeroed bytes, in two parts
-/

module

public import Braid.Logic.Any
import Iris.BI.DerivedLaws

@[expose] public section

namespace Braid

open Iris Iris.BI

/-- The low `k` bytes of the word `v`, least significant first: the order in which memory
holds them. -/
def leBytes : Nat → Word → List (BitVec 8)
  | 0, _ => []
  | k + 1, v => v.truncate 8 :: leBytes k (v >>> 8)

@[simp] theorem leBytes_zero (v : Word) : leBytes 0 v = [] := rfl

theorem leBytes_succ (k : Nat) (v : Word) :
    leBytes (k + 1) v = v.truncate 8 :: leBytes k (v >>> 8) := rfl

/-- A word has `k` low bytes. -/
@[simp] theorem leBytes_length (k : Nat) (v : Word) : (leBytes k v).length = k := by
  induction k generalizing v with
  | zero => rfl
  | succ k ih => simp only [leBytes, List.length_cons, ih]

/-- The low bytes of zero are zero. -/
theorem leBytes_zero_word (k : Nat) : leBytes k 0#64 = List.replicate k 0#8 := by
  induction k with
  | zero => rfl
  | succ k ih =>
    have e : (0#64 >>> 8 : Word) = 0#64 := by simp
    simp only [leBytes, e, ih, List.replicate_succ]
    simp

/-- The bytes of `n` zero cells of `k` bytes are `k * n` zero bytes. -/
theorem flatMap_leBytes_zero (k n : Nat) :
    (List.replicate n 0#64).flatMap (leBytes k) = List.replicate (k * n) 0#8 := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [List.replicate_succ, List.flatMap_cons, ih, leBytes_zero_word, Nat.mul_succ,
      Nat.add_comm, List.replicate_append_replicate]

/-! ## A cell is its bytes -/

/-- No bytes of memory are the empty heap. -/
theorem Heap.bytes_zero (a v : Word) (w : Bool) : Heap.bytes a 0 v w = ∅ := by
  funext l
  cases l <;> simp [Heap.bytes]

/-- The heap of a cell is the heap of its lowest byte and that of the bytes above it. -/
theorem Heap.bytes_succ (a v : Word) (k : Nat) (w : Bool) (hk : k < 8) :
    Heap.bytes a (k + 1) v w = Heap.bytes a 1 v w ∪ Heap.bytes (a + 1#64) k (v >>> 8) w := by
  funext l
  cases l with
  | mem x =>
    simp only [Heap.union_apply, Heap.bytes]
    by_cases h0 : (x - a).toNat < 1
    · have h1 : (x - a).toNat < k + 1 := by omega
      simp only [h0, h1, ↓reduceIte]
    · by_cases h1 : (x - a).toNat < k + 1
      · have h2 : (x - (a + 1#64)).toNat < k := by bv_omega
        have e : ((x - a) <<< 3).toNat = 8 + ((x - (a + 1#64)) <<< 3).toNat := by bv_omega
        simp only [h0, h1, h2, ↓reduceIte]
        rw [BitVec.ushiftRight_eq' v, BitVec.ushiftRight_eq' (v >>> 8), e,
          BitVec.shiftRight_add]
      · have h2 : ¬ (x - (a + 1#64)).toNat < k := by bv_omega
        simp only [h0, h1, h2, ↓reduceIte]
  | _ => rfl

/-- The lowest byte of a cell and the bytes above it do not overlap. -/
theorem Heap.bytes_disjoint_succ (a v v' : Word) (k : Nat) (w : Bool) (hk : k < 8) :
    Heap.Disjoint (Heap.bytes a 1 v w) (Heap.bytes (a + 1#64) k v' w) := by
  intro l
  cases l with
  | mem x =>
    simp only [Heap.bytes]
    by_cases h0 : (x - a).toNat < 1
    · have h2 : ¬ (x - (a + 1#64)).toNat < k := by bv_omega
      exact .inr (ite_eq_right h2)
    · exact .inl (ite_eq_right h0)
  | _ => exact .inl rfl

/-- A cell of no bytes is nothing. -/
theorem memIs_zero (a v : Word) (w : Bool) : memIs a 0 v w = iprop(emp) := by
  funext h
  show (h = Heap.bytes a 0 v w) = (h = ∅)
  rw [Heap.bytes_zero]

/-- A cell is its lowest byte beside the bytes above it, which hold the value shifted down. -/
theorem memIs_succ (a v : Word) (k : Nat) (w : Bool) (hk : k < 8) :
    memIs a (k + 1) v w = iprop(memIs a 1 v w ∗ memIs (a + 1#64) k (v >>> 8) w) := by
  funext h
  refine propext ⟨fun e => ?_, ?_⟩
  · have e : h = Heap.bytes a (k + 1) v w := e
    exact ⟨_, _, e.trans (Heap.bytes_succ a v k w hk), Heap.bytes_disjoint_succ a v _ k w hk,
      rfl, rfl⟩
  · rintro ⟨h₁, h₂, e, _, e₁, e₂⟩
    have e₁ : h₁ = Heap.bytes a 1 v w := e₁
    have e₂ : h₂ = Heap.bytes (a + 1#64) k (v >>> 8) w := e₂
    subst e₁ e₂
    exact e.trans (Heap.bytes_succ a v k w hk).symm

/-- One byte of memory holding a word holds the word's low byte. -/
theorem memIs_byte (a v : Word) (w : Bool) :
    memIs a 1 ((v.truncate 8).zeroExtend 64) w = memIs a 1 v w := by
  funext h
  simp only [memIs, ← Heap.bytes_byte a v w]

/-- **A cell is its bytes.** A writable cell of at most eight bytes holding `v` is the array
of the low bytes of `v`, least significant first. -/
theorem memIs_eq_bytesAt (a v : Word) (k : Nat) (hk : k ≤ 8) :
    memIs a k v true = bytesAt a (leBytes k v) := by
  induction k generalizing a v with
  | zero => exact memIs_zero a v true
  | succ k ih =>
    rw [memIs_succ a v k true (by omega), ih (a + 1#64) (v >>> 8) (by omega), leBytes_succ]
    simp only [bytesAt, memIs_byte]

/-- A memory atom, as the array of its bytes: opens a cell into bytes with `braid_unfold`,
and closes bytes into a cell with `braid_fold`. -/
theorem mem_interp_bytesAt (a v : Word) (k : Nat) (hk : k ≤ 8) :
    (Atom.mem a k v true).interp = Atoms.interp [.prop (bytesAt a (leBytes k v))] := by
  rw [← prop_interp_singleton]
  exact memIs_eq_bytesAt a v k hk

/-- The array of the bytes of a word, as a memory atom: opens bytes into a cell with
`braid_unfold`, and closes a cell into bytes with `braid_fold`. -/
theorem bytesAt_leBytes (a v : Word) (k : Nat) (hk : k ≤ 8) :
    (Atom.prop (bytesAt a (leBytes k v))).interp = Atoms.interp [.mem a k v true] := by
  show bytesAt a (leBytes k v) = iprop(memIs a k v true ∗ emp)
  rw [← memIs_eq_bytesAt a v k hk]
  exact SProp.ext ⟨sep_emp.2, sep_emp.1⟩

/-- An array of bytes known to be those of a word, as a memory atom. -/
theorem bytesAt_interp_mem (a v : Word) (k : Nat) (bs : List (BitVec 8)) (hk : k ≤ 8)
    (h : bs = leBytes k v) :
    (Atom.prop (bytesAt a bs)).interp = Atoms.interp [.mem a k v true] := by
  subst h
  exact bytesAt_leBytes a v k hk

/-! ## An array of bytes, in two parts -/

theorem bytes_addr_succ (p : Word) (n : Nat) :
    p + 1#64 + BitVec.ofNat 64 n = p + BitVec.ofNat 64 (n + 1) := by
  rw [BitVec.add_assoc, Nat.add_comm n 1, BitVec.ofNat_add]

/-- An array of two lists of bytes is the first and then the second, as assertions. -/
theorem bytesAt_append_eq (p : Word) (xs ys : List (BitVec 8)) :
    bytesAt p (xs ++ ys) =
      iprop(bytesAt p xs ∗ bytesAt (p + BitVec.ofNat 64 xs.length) ys) := by
  induction xs generalizing p with
  | nil =>
    have e : p + BitVec.ofNat 64 ([] : List (BitVec 8)).length = p := by simp
    rw [e]
    exact SProp.ext emp_sep.symm
  | cons x xs ih =>
    simp only [List.cons_append, bytesAt, ih, List.length_cons, bytes_addr_succ]
    exact SProp.ext sep_assoc.symm

/-- Two assertions side by side are the list of the two. -/
theorem sep_interp_pair (A B : SProp) :
    (Atom.prop iprop(A ∗ B)).interp = Atoms.interp [.prop A, .prop B] :=
  prop_sep_interp A B _ (prop_interp_singleton B)

/-- **An array of two lists of bytes is the first and then the second.** -/
theorem bytesAt_append (p : Word) (xs ys : List (BitVec 8)) :
    (Atom.prop (bytesAt p (xs ++ ys))).interp =
      Atoms.interp [.prop (bytesAt p xs),
        .prop (bytesAt (p + BitVec.ofNat 64 xs.length) ys)] := by
  rw [bytesAt_append_eq]
  exact sep_interp_pair _ _

/-- An array of bytes, split at `i`. -/
theorem bytesAt_split (p : Word) (bs : List (BitVec 8)) (i : Nat) (hi : i ≤ bs.length) :
    (Atom.prop (bytesAt p bs)).interp =
      Atoms.interp [.prop (bytesAt p (bs.take i)),
        .prop (bytesAt (p + BitVec.ofNat 64 i) (bs.drop i))] := by
  have e := bytesAt_append p (bs.take i) (bs.drop i)
  rwa [List.take_append_drop, List.length_take, Nat.min_eq_left hi] at e

/-- Zeroed bytes, in two parts, as assertions. -/
theorem bytesAt_zero_add_eq (p : Word) (m n : Nat) :
    bytesAt p (List.replicate (m + n) 0#8) =
      iprop(bytesAt p (List.replicate m 0#8) ∗
        bytesAt (p + BitVec.ofNat 64 m) (List.replicate n 0#8)) := by
  rw [← List.replicate_append_replicate, bytesAt_append_eq, List.length_replicate]

/-- **Zeroed bytes, in two parts**: `m + n` zero bytes at `p` are `m` at `p` and `n` at
`p + m`. -/
theorem bytesAt_zero_add (p : Word) (m n : Nat) :
    (Atom.prop (bytesAt p (List.replicate (m + n) 0#8))).interp =
      Atoms.interp [.prop (bytesAt p (List.replicate m 0#8)),
        .prop (bytesAt (p + BitVec.ofNat 64 m) (List.replicate n 0#8))] := by
  rw [bytesAt_zero_add_eq]
  exact sep_interp_pair _ _

/-- Zeroed bytes of a length that is a sum, in two parts: `bytesAt_zero_add` with the length
written another way. -/
theorem bytesAt_zero_split (p : Word) (l m n : Nat) (h : l = m + n) :
    (Atom.prop (bytesAt p (List.replicate l 0#8))).interp =
      Atoms.interp [.prop (bytesAt p (List.replicate m 0#8)),
        .prop (bytesAt (p + BitVec.ofNat 64 m) (List.replicate n 0#8))] := by
  subst h
  exact bytesAt_zero_add p m n

/-! ## An array of cells is the bytes of its cells -/

/-- **An array of cells is the bytes of its cells.** A writable array of cells of at most
eight bytes is the array of the low bytes of each cell, one cell after another. -/
theorem cellsAt_eq_bytesAt (p : Word) (vs : List Word) (k : Nat) (hk : k ≤ 8) :
    cellsAt k true p vs = bytesAt p (vs.flatMap (leBytes k)) := by
  induction vs generalizing p with
  | nil => rfl
  | cons v vs ih =>
    simp only [cellsAt, List.flatMap_cons, bytesAt_append_eq, leBytes_length,
      memIs_eq_bytesAt p v k hk, ih]

/-- **An array of bytes that are those of cells is the array of the cells.** With `k = 4`
and `vs` the little-endian 32-bit groupings of `bs`, this reads a section of a binary as an
array of 32-bit values. -/
theorem bytesAt_eq_cellsAt (p : Word) (bs : List (BitVec 8)) (vs : List Word) (k : Nat)
    (hk : k ≤ 8) (h : bs = vs.flatMap (leBytes k)) :
    bytesAt p bs = cellsAt k true p vs := by
  subst h
  exact (cellsAt_eq_bytesAt p vs k hk).symm

/-- An array of cells, as the array of its bytes: for `braid_unfold` and `braid_fold`. -/
theorem cellsAt_interp_bytesAt (p : Word) (vs : List Word) (k : Nat) (hk : k ≤ 8) :
    (Atom.prop (cellsAt k true p vs)).interp =
      Atoms.interp [.prop (bytesAt p (vs.flatMap (leBytes k)))] := by
  rw [← prop_interp_singleton]
  exact cellsAt_eq_bytesAt p vs k hk

/-- An array of bytes that are those of cells, as the array of the cells: for `braid_unfold`
and `braid_fold`. -/
theorem bytesAt_interp_cellsAt (p : Word) (bs : List (BitVec 8)) (vs : List Word) (k : Nat)
    (hk : k ≤ 8) (h : bs = vs.flatMap (leBytes k)) :
    (Atom.prop (bytesAt p bs)).interp = Atoms.interp [.prop (cellsAt k true p vs)] := by
  rw [← prop_interp_singleton]
  exact bytesAt_eq_cellsAt p bs vs k hk h

/-! ## Zeroed memory -/

/-- **Zeroed bytes are zero cells.** -/
theorem bytesAt_zero_eq_cellsAt (p : Word) (k n : Nat) (hk : k ≤ 8) :
    bytesAt p (List.replicate (k * n) 0#8) = cellsAt k true p (List.replicate n 0#64) :=
  bytesAt_eq_cellsAt p _ _ k hk (flatMap_leBytes_zero k n).symm

/-- Zeroed bytes, as the array of zero cells: for `braid_unfold` and `braid_fold`. -/
theorem bytesAt_zero_interp_cellsAt (p : Word) (k n : Nat) (hk : k ≤ 8) :
    (Atom.prop (bytesAt p (List.replicate (k * n) 0#8))).interp =
      Atoms.interp [.prop (cellsAt k true p (List.replicate n 0#64))] := by
  rw [← prop_interp_singleton]
  exact bytesAt_zero_eq_cellsAt p k n hk

/-- **Zeroed bytes are cells of forgotten contents.** -/
theorem bytesAt_zero_entails_cellsAny (p : Word) (k n : Nat) (hk : k ≤ 8) :
    bytesAt p (List.replicate (k * n) 0#8) ⊢ cellsAny k true p n := by
  rw [bytesAt_zero_eq_cellsAt p k n hk]
  have h := cellsAt_entails_cellsAny (k := k) (w := true) p (List.replicate n 0#64)
  rwa [List.length_replicate] at h

end Braid
