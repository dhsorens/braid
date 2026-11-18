/-
  Lowering.Arm.Logic

  The separation logic, for AArch64. A triple about lowered code is a statement about the
  machine: `triple_sound` carries it down through the lowering, and `machine_sound` states
  it of the machine alone.

  ## Main definitions

  * `Regs`, `Flags`: the names of the registers and flags
  * `lowerWords`: the blocks of a list of instruction words
  * `abs`: the `braid` state of a machine state

  ## Main results

  * `ofList_le_lowerProgram`: the blocks of words a program holds are blocks of its lowering
  * `triple_sound`: a triple about the lowered code of a function, for the machine
  * `machine_sound`: the same, from facts about the machine state alone
-/

module

public import Lowering.Arm.Sound
public import Braid.Logic
import Iris.BI.DerivedLaws

@[expose] public section

namespace Lowering.Arm

open Braid

/-! The names of the registers and flags, as `braid` registers and flags. -/

namespace Regs

abbrev x0 : Braid.Reg := 0
abbrev x1 : Braid.Reg := 1
abbrev x2 : Braid.Reg := 2
abbrev x3 : Braid.Reg := 3
abbrev x4 : Braid.Reg := 4
abbrev x5 : Braid.Reg := 5
abbrev x6 : Braid.Reg := 6
abbrev x7 : Braid.Reg := 7
abbrev x8 : Braid.Reg := 8
abbrev x9 : Braid.Reg := 9
abbrev x10 : Braid.Reg := 10
abbrev x11 : Braid.Reg := 11
abbrev x12 : Braid.Reg := 12
abbrev x13 : Braid.Reg := 13
abbrev x14 : Braid.Reg := 14
abbrev x15 : Braid.Reg := 15
abbrev x16 : Braid.Reg := 16
abbrev x17 : Braid.Reg := 17
abbrev x18 : Braid.Reg := 18
abbrev x19 : Braid.Reg := 19
abbrev x20 : Braid.Reg := 20
abbrev x21 : Braid.Reg := 21
abbrev x22 : Braid.Reg := 22
abbrev x23 : Braid.Reg := 23
abbrev x24 : Braid.Reg := 24
abbrev x25 : Braid.Reg := 25
abbrev x26 : Braid.Reg := 26
abbrev x27 : Braid.Reg := 27
abbrev x28 : Braid.Reg := 28
abbrev x29 : Braid.Reg := 29
abbrev x30 : Braid.Reg := 30
abbrev sp : Braid.Reg := 31
abbrev lr : Braid.Reg := 30
abbrev fp : Braid.Reg := 29

end Regs

namespace Flags

abbrev n : Braid.Flag := 0
abbrev z : Braid.Flag := 1
abbrev c : Braid.Flag := 2
abbrev v : Braid.Flag := 3

end Flags

/-! ## Code -/

/-- The blocks of a list of instruction words placed at `base`: word `i` is at
`base + 4 * i`. A word that does not decode has no block. -/
def lowerWords (base : Word) (ws : List (BitVec 32)) : List (Word × Block) :=
  (ws.zipIdx).filterMap fun (w, i) =>
    (Arm64.decode w).map fun ins =>
      (base + BitVec.ofNat 64 (4 * i), lower (base + BitVec.ofNat 64 (4 * i)) ins)

/-- No hook has its entry at an offset that `hookFree` covers. -/
theorem hookAtOff?_of_hookFree {prog : Arm64.Program} {off len o : Nat}
    (hf : prog.hookFree off len) (h1 : off ≤ o) (h2 : o < off + len) :
    prog.hookAtOff? o = none := by
  obtain ⟨hs, hy⟩ := hf
  simp only [Arm64.Program.hookAtOff?, Option.or_eq_none_iff, List.findSome?_eq_none_iff]
  simp only [List.all_eq_true] at hs hy
  refine ⟨fun p hp => ?_, fun p hp => ?_⟩
  · have := hs p hp
    by_cases e : p.2 = o
    · simpa [e, h1, h2] using this
    · simp [e]
  · have := hy p hp
    by_cases e : p.2 = o
    · simpa [e, h1, h2] using this
    · simp [e]

/-- A program that holds words at an address fetches the instruction each decodes to. -/
theorem fetch_of_hasWords {prog : Arm64.Program} {base : Word} {ws : List (BitVec 32)}
    (hw : prog.hasWords base ws) {i : Nat} (hi : i < ws.length) {ins : Arm64.Instr}
    (hd : Arm64.decode ws[i] = some ins) :
    prog.fetch (base + BitVec.ofNat 64 (4 * i)) = some ins := by
  obtain ⟨hlen, hread, hfree⟩ := hw
  have hoff : (base + BitVec.ofNat 64 (4 * i) - prog.base).toNat =
      (base - prog.base).toNat + 4 * i := by
    have e : base + BitVec.ofNat 64 (4 * i) - prog.base =
        (base - prog.base) + BitVec.ofNat 64 (4 * i) := by
      generalize BitVec.ofNat 64 (4 * i) = k
      bv_omega
    rw [e, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hx : prog.externAt? (base + BitVec.ofNat 64 (4 * i)) = none := by
    rw [Arm64.Program.externAt?, hoff]
    exact hookAtOff?_of_hookFree hfree (by omega) (by omega)
  simp only [Arm64.Program.fetch, hx, Option.isSome_none, Bool.false_eq_true, ↓reduceIte, hoff,
    hread i hi, Option.bind_some, hd]

/-- The blocks of the words a program holds are blocks of its lowering. -/
theorem ofList_le_lowerProgram {prog : Arm64.Program} {base : Word} {ws : List (BitVec 32)}
    (hw : prog.hasWords base ws) (a : Word) (b : Block)
    (h : Program.ofList (lowerWords base ws) a = some b) : lowerProgram prog a = some b := by
  simp only [Program.ofList, Option.map_eq_some_iff] at h
  obtain ⟨⟨a', b'⟩, hfind, rfl⟩ := h
  have hmem := List.mem_of_find?_eq_some hfind
  have ha : a' = a := by simpa using List.find?_some hfind
  subst ha
  simp only [lowerWords, List.mem_filterMap, Option.map_eq_some_iff] at hmem
  obtain ⟨⟨w, i⟩, hwi, ins, hd, he⟩ := hmem
  cases he
  obtain ⟨hi, rfl⟩ : ∃ hi : i < ws.length, w = ws[i] := by
    have := List.mem_zipIdx hwi
    exact ⟨by omega, by simpa using this.2.2⟩
  simp [lowerProgram, fetch_of_hasWords hw hi hd]

/-- **A triple about lowered AArch64 code holds of the machine.** Let a program hold the
words `ws` at `base`, with its code loaded in a machine state related to a `braid` state
part of which satisfies `pre`. If the lowering of `ws` satisfies the triple from `pre` to
`post`, then the machine runs, executing an instruction at each step, to a running state
related to one part of which satisfies `post`. -/
theorem triple_sound {prog : Arm64.Program} {base : Word} {ws : List (BitVec 32)}
    {blocks : List (Word × Block)} {pre post : SProp} {s : Arm64.State} {σ : State}
    (hlow : blocks = lowerWords base ws) (ht : Triple (Program.ofList blocks) pre post)
    (hw : prog.hasWords base ws) (hc : prog.CodeLoaded s.mem) (h : Rel s σ)
    (hp : (iprop(pre ∗ True) : SProp) σ.heap) :
    ∃ s' σ', Arm64.Steps prog s s' ∧ Rel s' σ' ∧ (iprop(post ∗ True) : SProp) σ'.heap := by
  subst hlow
  exact lowerProgram_sound hc h ((ht.sound hp).of_le (ofList_le_lowerProgram hw))

/-! ## Theorems about the machine alone -/

/-- The value of the `braid` register `n` in a machine state: `Xn` below 31, and `SP` at
31. -/
def regOf (s : Arm64.State) : Nat → Word
  | 0 => s.regs.read 0#5
  | 1 => s.regs.read 1#5
  | 2 => s.regs.read 2#5
  | 3 => s.regs.read 3#5
  | 4 => s.regs.read 4#5
  | 5 => s.regs.read 5#5
  | 6 => s.regs.read 6#5
  | 7 => s.regs.read 7#5
  | 8 => s.regs.read 8#5
  | 9 => s.regs.read 9#5
  | 10 => s.regs.read 10#5
  | 11 => s.regs.read 11#5
  | 12 => s.regs.read 12#5
  | 13 => s.regs.read 13#5
  | 14 => s.regs.read 14#5
  | 15 => s.regs.read 15#5
  | 16 => s.regs.read 16#5
  | 17 => s.regs.read 17#5
  | 18 => s.regs.read 18#5
  | 19 => s.regs.read 19#5
  | 20 => s.regs.read 20#5
  | 21 => s.regs.read 21#5
  | 22 => s.regs.read 22#5
  | 23 => s.regs.read 23#5
  | 24 => s.regs.read 24#5
  | 25 => s.regs.read 25#5
  | 26 => s.regs.read 26#5
  | 27 => s.regs.read 27#5
  | 28 => s.regs.read 28#5
  | 29 => s.regs.read 29#5
  | 30 => s.regs.read 30#5
  | 31 => s.sp
  | _ => 0#64

theorem regOf_toNat (s : Arm64.State) {i : BitVec 5} (hi : i ≠ 31#5) :
    regOf s i.toNat = s.regs.read i := by
  have key : ∀ n (hn : n < 31), regOf s n = s.regs.read (BitVec.ofNat 5 n) := fun n hn =>
    match n, hn with
    | 0, _ => rfl
    | 1, _ => rfl
    | 2, _ => rfl
    | 3, _ => rfl
    | 4, _ => rfl
    | 5, _ => rfl
    | 6, _ => rfl
    | 7, _ => rfl
    | 8, _ => rfl
    | 9, _ => rfl
    | 10, _ => rfl
    | 11, _ => rfl
    | 12, _ => rfl
    | 13, _ => rfl
    | 14, _ => rfl
    | 15, _ => rfl
    | 16, _ => rfl
    | 17, _ => rfl
    | 18, _ => rfl
    | 19, _ => rfl
    | 20, _ => rfl
    | 21, _ => rfl
    | 22, _ => rfl
    | 23, _ => rfl
    | 24, _ => rfl
    | 25, _ => rfl
    | 26, _ => rfl
    | 27, _ => rfl
    | 28, _ => rfl
    | 29, _ => rfl
    | 30, _ => rfl
    | n + 31, h => absurd h (by omega)
  have hlt : i.toNat < 31 := by have := i.isLt; have := toNat_ne_31 hi; omega
  rw [key _ hlt, BitVec.ofNat_toNat, BitVec.setWidth_eq]

/-- The `braid` state of a machine state: its registers, stack pointer, flags and program
counter, and a cell at each byte the machine may load, writable where it may store. -/
def abs (s : Arm64.State) : State where
  regs := regOf s
  flags f :=
    if f = 0 then s.pstate.n else if f = 1 then s.pstate.z else if f = 2 then s.pstate.c
    else if f = 3 then s.pstate.v else false
  mem a := if readable s.mem a then some ⟨s.mem.read8 a, writable s.mem a⟩ else none
  pc := s.pc

@[simp] theorem abs_regs (s : Arm64.State) (n : Nat) : (abs s).regs n = regOf s n := rfl

@[simp] theorem abs_flags (s : Arm64.State) (f : Nat) :
    (abs s).flags f = if f = 0 then s.pstate.n else if f = 1 then s.pstate.z
      else if f = 2 then s.pstate.c else if f = 3 then s.pstate.v else false := rfl

@[simp] theorem abs_pc (s : Arm64.State) : (abs s).pc = s.pc := rfl

theorem abs_mem (s : Arm64.State) (a : Word) :
    (abs s).mem a =
      if readable s.mem a then some ⟨s.mem.read8 a, writable s.mem a⟩ else none := rfl

/-- A running machine state is related to its `braid` state. -/
theorem rel_abs {s : Arm64.State} (h : s.status = .Running) : Rel s (abs s) := by
  refine ⟨fun i hi => ?_, rfl, rfl, rfl, rfl, rfl, rfl, h, fun _ => rfl⟩
  exact regOf_toNat s hi

/-- A memory atom is true of the state of a machine when the machine may load each of its
bytes, the byte is the atom's, and it may be stored to exactly if the atom says so. -/
theorem sat_mem_abs {s : Arm64.State} {a v : Word} {n : Nat} {w : Bool} :
    (Atom.mem a n v w).sat (abs s) ↔ ∀ x : Word, (x - a).toNat < n →
      readable s.mem x = true ∧ s.mem.read8 x = (v >>> ((x - a) <<< 3)).truncate 8 ∧
        writable s.mem x = w := by
  rw [Atom.sat_mem]
  refine forall_congr' fun x => imp_congr_right fun _ => ?_
  rw [abs_mem]
  cases readable s.mem x <;> simp

/-! Reading the machine off a related state. -/

theorem Rel.readReg {s : Arm64.State} {σ : State} (h : Rel s σ) {i : BitVec 5}
    (hi : i ≠ 31#5) : σ.regs i.toNat = s.regs.read i :=
  h.regs i hi

theorem Rel.readReg64 {s : Arm64.State} {σ : State} (h : Rel s σ) {i : BitVec 5}
    (hi : i ≠ 31#5) : σ.regs i.toNat = s.readReg64 (.gpr i) := by
  simp [Arm64.State.readReg64, hi, h.regs i hi]

/-- A cell of a related state is a byte the machine may load, and holds the machine's
byte. -/
theorem Rel.read8 {s : Arm64.State} {σ : State} (h : Rel s σ) {a : Word} {c : Cell}
    (hc : σ.mem a = some c) : s.mem.canRead a 1 = true ∧ s.mem.read8 a = c.val := by
  obtain ⟨hr, rfl⟩ := h.cell hc
  exact ⟨canRead_of (by decide) fun x hx => by
    have : x = a := by bv_omega
    rw [this]; exact hr, rfl⟩

/-- **A triple about lowered AArch64 code, as a theorem about the machine.** If a program
holds the words `ws` at `base`, its code is loaded, and the running machine state satisfies
the atoms `pre`, the machine runs, executing an instruction at each step, to a running
state related to one that satisfies the atoms `post`. Read the conclusion off with
`Atoms.reg_of_holds` and its companions, and `Rel`. -/
theorem machine_sound {prog : Arm64.Program} {base : Word} {ws : List (BitVec 32)}
    {blocks : List (Word × Block)} {pre post : Atoms} {s : Arm64.State}
    (hlow : blocks = lowerWords base ws)
    (ht : Triple (Program.ofList blocks) (Atoms.interp pre) (Atoms.interp post))
    (hw : prog.hasWords base ws) (hc : prog.CodeLoaded s.mem) (hrun : s.status = .Running)
    (hpt : ∀ a ∈ pre, a.IsPointsTo) (hdisj : pre.Pairwise Atom.Disj)
    (hsat : ∀ a ∈ pre, a.sat (abs s)) :
    ∃ s' σ', Arm64.Steps prog s s' ∧ Rel s' σ' ∧ (Atoms.interp post).holds iprop(True) σ' :=
  triple_sound hlow ht hw hc (rel_abs hrun) (Atoms.holds_of_sat hpt hdisj hsat)

end Lowering.Arm
