/-
  Examples.Crc32.Common

  What the proofs of `crc32.c` share between instruction sets: the lookup table of the C
  source, the fact that a step through the table is four bits of the division, and the table
  as an assertion about read-only memory that can be opened at the entry a nibble selects.

  ## Main definitions

  * `table`: the sixteen entries of the lookup table, as the C source has them
  * `nibble`: four bits of the division
  * `tableAt w t`: the table is in memory at `t`, writable if `w`
  * `tableRest w t i`: the table without its entry `i`

  ## Main results

  * `table_getElem`: entry `i` of the table is four bits of the division of `i`
  * `nibble_step`: a shift by four and an entry of the table are four bits of the division
  * `tableAt_open`: the table, opened at the entry a nibble selects
  * `cellsAt_cell`: the bytes of an array of cells that holds of a state
  * `tableAt_flat`, `forall_flat₂`, `pairwise_flat₂`: a state that ends with the message and
    the table, written out as memory atoms for a theorem about a machine
-/

module

public import Examples.Spec.Crc32
public import Braid
import Iris.BI.DerivedLaws
import Braid.BV

@[expose] public section

namespace Examples.Crc32

open Braid Iris Iris.BI

/-- The lookup table of `crc32.c`: entry `i` is the register after four bits of the division,
starting from `i`. -/
def table : List (BitVec 32) := [
  0x00000000#32, 0x1db71064#32, 0x3b6e20c8#32, 0x26d930ac#32,
  0x76dc4190#32, 0x6b6b51f4#32, 0x4db26158#32, 0x5005713c#32,
  0xedb88320#32, 0xf00f9344#32, 0xd6d6a3e8#32, 0xcb61b38c#32,
  0x9b64c2b0#32, 0x86d3d2d4#32, 0xa00ae278#32, 0xbdbdf21c#32]

/-- Four bits of the division. -/
def nibble (c : BitVec 32) : BitVec 32 := bit (bit (bit (bit c)))

/-- A byte of the message is two nibbles. -/
theorem byte_eq (c : BitVec 32) (b : BitVec 8) :
    byte c b = nibble (nibble (c ^^^ b.zeroExtend 32)) := rfl

theorem update_nil (c : BitVec 32) : update c [] = c := rfl

theorem update_cons (c : BitVec 32) (b : BitVec 8) (bs : List (BitVec 8)) :
    update c (b :: bs) = update (byte c b) bs := rfl

/-- Entry `i` of the table is four bits of the division of `i`. -/
theorem table_getElem : ∀ i : Fin 16, table[i] = nibble (BitVec.ofNat 32 i) := by
  decide

/-- **The table-driven step is four bit steps**: shifting the register right by four and
adding the entry of the table its low four bits select is four bits of the division. -/
theorem nibble_step (x : BitVec 32) : (x >>> 4) ^^^ nibble (x &&& 15#32) = nibble x := by
  simp only [nibble, bit, poly]
  bv_auto

/-! ## The table in memory -/

/-- The entries of the table as words: what a cell of four bytes holds. -/
def tableWords : List Word := table.map (·.zeroExtend 64)

/-- The table is in memory at `t`, in sixteen cells of four bytes; writable if `w`. For a
table in read-only data `w` is `false`. -/
def tableAt (w : Bool) (t : Word) : SProp := cellsAt 4 w t tableWords

/-- The table at `t` without its entry `i`: the entries before it and the entries after. -/
def tableRest (w : Bool) (t : Word) (i : Nat) : SProp :=
  iprop(cellsAt 4 w t (tableWords.take i) ∗
    cellsAt 4 w (t + BitVec.ofNat 64 (4 * (i + 1))) (tableWords.drop (i + 1)))

/-- **The table, opened at the entry a nibble selects.** The entry that the low four bits of
`y` select is a memory atom at `a`, the address the code computes, and holds four bits of
the division of those bits. -/
theorem tableAt_open (w : Bool) (t a : Word) (y : BitVec 32)
    (ha : a = t + ((y &&& 15#32).zeroExtend 64 <<< 2#64)) :
    (Atom.prop (tableAt w t)).interp =
      Atoms.interp [.mem a 4 ((nibble (y &&& 15#32)).zeroExtend 64) w,
        .prop (tableRest w t (y &&& 15#32).toNat)] := by
  have hi : (y &&& 15#32).toNat < 16 := by
    rw [BitVec.toNat_and]
    exact Nat.lt_succ_of_le Nat.and_le_right
  have hv : tableWords[(y &&& 15#32).toNat]'hi = (nibble (y &&& 15#32)).zeroExtend 64 := by
    have h := table_getElem ⟨_, hi⟩
    simp only [Fin.getElem_fin, BitVec.ofNat_toNat, BitVec.setWidth_eq] at h
    simp only [tableWords, List.getElem_map, h]
  have he : t + BitVec.ofNat 64 (4 * (y &&& 15#32).toNat) = a := by
    subst ha
    congr 1
    rw [BitVec.ofNat_mul, BitVec.ofNat_toNat]
    bv_auto
  rw [tableAt, cellsAt_index t tableWords _ hi, hv, he]
  simp only [Atoms.interp_cons, Atoms.interp_nil, Atom.interp, tableRest]
  exact SProp.ext ⟨sep_left_comm.1.trans (sep_mono_right sep_assoc.2),
    (sep_mono_right sep_assoc.1).trans sep_left_comm.2⟩

/-! ## Written out, for theorems about a machine -/

/-- Cell `i` of the table as words is entry `i` of the table. -/
theorem tableWords_getElem (i : Nat) (hi : i < tableWords.length) :
    tableWords[i] = (table[i]'(by simpa [tableWords] using hi)).zeroExtend 64 := by
  simp [tableWords]

/-- The bytes of the cells of an array that holds of a state: byte `x` of cell `i` is in the
state's memory, writable exactly if the array is. It belongs in `Braid.Logic.Cells`. -/
theorem cellsAt_cell {σ : State} {k : Nat} {w : Bool} : ∀ {vs : List Word} {p : Word}
    {R : SProp}, (cellsAt k w p vs).holds R σ → ∀ (i : Nat) (hi : i < vs.length) (x : Word),
      (x - (p + BitVec.ofNat 64 (k * i))).toNat < k → σ.mem x =
        some ⟨(vs[i] >>> ((x - (p + BitVec.ofNat 64 (k * i))) <<< 3)).truncate 8, w⟩
  | [], _, _, _, _, hi, _, _ => absurd hi (by simp)
  | v :: vs, p, R, h, 0, _, x, hx => by
    have := memIs_cell (x := x) (SProp.holds_assoc.1 h) (by simpa using hx)
    simpa using this
  | v :: vs, p, R, h, i + 1, hi, x, hx => by
    have h' : (iprop(cellsAt k w (p + BitVec.ofNat 64 k) vs ∗ memIs p k v w) : SProp).holds
        R σ := SProp.holds_mono sep_comm.1 h
    have := cellsAt_cell (SProp.holds_assoc.1 h') i (by simpa using hi) x
      (by rwa [cells_addr_succ])
    simpa [cells_addr_succ] using this

/-- A state that ends with an array of bytes and the table means the same with both written
out as memory atoms. -/
theorem tableAt_flat {pre flat : Atoms} {w : Bool} {p t : Word} {bs : List (BitVec 8)}
    (h : Flat pre flat) :
    Atoms.interp (pre ++ [.prop (bytesAt p bs), .prop (tableAt w t)]) =
      Atoms.interp (flat ++ (bytesAtoms p bs ++ (cellsAtoms 4 w t tableWords ++ []))) := by
  rw [Atoms.interp_append, Atoms.interp_append, h.interp]
  congr 1
  exact (Flat.bytes (Flat.cells Flat.nil)).interp

/-- A property of every atom of a state that ends with two arrays written out. -/
theorem forall_flat₂ {l m₁ m₂ : Atoms} {P : Atom → Prop} (h : ∀ a ∈ l, P a)
    (h₁ : ∀ a ∈ m₁, P a) (h₂ : ∀ a ∈ m₂, P a) : ∀ a ∈ l ++ (m₁ ++ (m₂ ++ [])), P a := by
  intro a ha
  rw [List.append_nil] at ha
  rcases List.mem_append.1 ha with ha | ha
  · exact h a ha
  · rcases List.mem_append.1 ha with ha | ha
    · exact h₁ a ha
    · exact h₂ a ha

/-- Disjointness of a state that ends with two arrays written out: the rest is pairwise
disjoint, each array is, and the three are disjoint from one another. -/
theorem pairwise_flat₂ {l m₁ m₂ : Atoms} (h : l.Pairwise Atom.Disj)
    (h₁ : m₁.Pairwise Atom.Disj) (h₂ : m₂.Pairwise Atom.Disj)
    (hl₁ : ∀ a ∈ l, ∀ b ∈ m₁, Atom.Disj a b) (hl₂ : ∀ a ∈ l, ∀ b ∈ m₂, Atom.Disj a b)
    (h₁₂ : ∀ a ∈ m₁, ∀ b ∈ m₂, Atom.Disj a b) :
    (l ++ (m₁ ++ (m₂ ++ []))).Pairwise Atom.Disj := by
  rw [List.append_nil]
  refine List.pairwise_append.2 ⟨h, List.pairwise_append.2 ⟨h₁, h₂, h₁₂⟩, fun a ha b hb => ?_⟩
  rcases List.mem_append.1 hb with hb | hb
  · exact hl₁ a ha b hb
  · exact hl₂ a ha b hb

end Examples.Crc32
