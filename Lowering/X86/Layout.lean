/-
  Lowering.X86.Layout

  The code of a binary, as an executable of the machine model. The model's programs are
  assembly: directives with sizes, laid out from a start address, and found again by address
  when the machine steps. A binary's code is a list of lines, each an instruction with its
  address, its size and a label. `exeOf` is the executable of a list of lines, and for lines
  that follow one another without a gap (`wf`, which `decide` checks) the lowering of that
  executable at the address of a line is the lowering of the line.

  ## Main definitions

  * `Line`: one instruction of a binary
  * `exeOf`: the executable of the lines of a binary
  * `labelsOf`: the addresses of the labels of the lines
  * `lowerLines`: the blocks of a list of lines
  * `wf`: the lines follow one another, each with room, below `2 ^ 64`

  ## Main results

  * `labels_exeOf`: the labels of the executable are those of the lines
  * `lowerProgram_exeOf`: the block of the executable at a line is the lowering of the line
  * `holds_exeOf`: the blocks of lines of a binary are blocks of its lowering
-/

module

public import Lowering.X86.Lower

@[expose] public section

namespace Lowering.X86

open Braid (Word Block)

/-- One line of the code of a binary: what is at an address, and how much room it takes.
`instr` is `none` for bytes that are not an instruction of the model. -/
structure Line where
  addr : Nat
  size : Nat
  label : Label
  instr : Option Instr
  deriving DecidableEq, Repr

/-- The directive of a line. Execution that reaches a line without an instruction is not
defined. -/
def Line.dir (l : Line) : Directive :=
  match l.instr with
  | some i => .instr i
  | none => .byteArray .empty

/-- The directives of a list of lines: for each, its label and then the line. -/
def progOf : List Line → List (Kraken.Sized Directive)
  | [] => []
  | l :: ls => ⟨.label l.label, 0⟩ :: ⟨l.dir, l.size⟩ :: progOf ls

/-- The executable of a list of lines, starting at the address of the first. -/
def exeOf (ls : List Line) : Executable :=
  { startAddr := .ofNat ((ls.head?.map (·.addr)).getD 0), program := progOf ls }

/-- The labels of a list of lines: the address of the first line with the label. -/
@[instance_reducible]
def labelsOf (ls : List Line) : Labels where
  label l := ((ls.find? (·.label == l)).map fun ln => Int64.ofNat ln.addr).getD (-1)

/-- The blocks of a list of lines, with labels resolved by `L`. -/
def lowerLines (L : Labels) (code : List Line) : List (Word × Block) :=
  code.filterMap fun ln => ln.instr.map fun i =>
    (BitVec.ofNat 64 ln.addr, @lower L ⟨.ofNat ln.addr, .ofNat ln.addr + .ofNat ln.size⟩ i)

/-- The lines follow one another from `a`, each with room, and end below `2 ^ 64`. -/
def chain (a : Nat) : List Line → Bool
  | [] => a < 2 ^ 64
  | l :: ls => l.addr == a && 0 < l.size && chain (a + l.size) ls

/-- The lines follow one another, each with room, below `2 ^ 64`. -/
def wf (ls : List Line) : Bool :=
  match ls with
  | [] => true
  | l :: _ => chain l.addr ls

/-! ## The layout of the executable -/

/-- The directives of lines from `a`, each with its address. -/
def wa (a : Nat) : List Line → List (Kraken.Addressable Directive)
  | [] => []
  | l :: ls =>
    ⟨⟨.label l.label, 0⟩, .ofNat a⟩ :: ⟨⟨l.dir, l.size⟩, .ofNat a⟩ :: wa (a + l.size) ls

theorem withAddresses_progOf (a : Nat) (ls : List Line) :
    Kraken.Executable.withAddresses ⟨.ofNat a, progOf ls⟩ = wa a ls := by
  induction ls generalizing a with
  | nil => rw [progOf, Kraken.Executable.withAddresses]; rfl
  | cons l ls ih =>
    rw [progOf, Kraken.Executable.withAddresses]
    simp only
    rw [Kraken.Executable.withAddresses]
    simp only
    have e0 : Int64.ofNat a + Int64.ofNat 0 = Int64.ofNat a := by simp
    have e1 : Int64.ofNat a + Int64.ofNat l.size = Int64.ofNat (a + l.size) := by
      rw [Int64.ofNat_add]
    rw [e0, e1, ih]
    rfl

theorem chain_bound {a : Nat} {ls : List Line} (hc : chain a ls = true) :
    a < 2 ^ 64 ∧ ∀ l ∈ ls, a ≤ l.addr ∧ l.addr < 2 ^ 64 := by
  induction ls generalizing a with
  | nil => exact ⟨by simpa [chain] using hc, by simp⟩
  | cons l ls ih =>
    simp only [chain, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at hc
    obtain ⟨⟨ha, hs⟩, hc⟩ := hc
    obtain ⟨hb, hall⟩ := ih hc
    refine ⟨by omega, fun l' hl' => ?_⟩
    rcases List.mem_cons.1 hl' with rfl | hl'
    · omega
    · have := hall l' hl'; omega

theorem ofNat_ne {x y : Nat} (hx : x < 2 ^ 64) (hy : y < 2 ^ 64) (h : x ≠ y) :
    Int64.ofNat x ≠ Int64.ofNat y := by
  intro e
  have := congrArg (fun v => v.toBitVec.toNat) e
  simp only [Int64.toBitVec_ofNat', BitVec.toNat_ofNat] at this
  rw [Nat.mod_eq_of_lt hx, Nat.mod_eq_of_lt hy] at this
  exact h this

/-- The directives of the executable at the address of a line: its label and the line. -/
theorem dirs_wa {a : Nat} {ls : List Line} (hc : chain a ls = true) {l : Line} (hl : l ∈ ls) :
    (((wa a ls).dropWhile (·.addr ≠ Int64.ofNat l.addr)).takeWhile
      (·.addr = Int64.ofNat l.addr)).map (·.toSized) =
      [⟨.label l.label, 0⟩, ⟨l.dir, l.size⟩] := by
  induction ls generalizing a with
  | nil => cases hl
  | cons l0 ls ih =>
    have hcc := hc
    simp only [chain, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at hc
    obtain ⟨⟨ha, hs⟩, hc'⟩ := hc
    obtain ⟨hb, hall⟩ := chain_bound hc'
    by_cases e : l.addr = a
    · have hl0 : l = l0 := by
        rcases List.mem_cons.1 hl with h | h
        · exact h
        · have := (hall l h).1; omega
      subst hl0
      subst e
      have hstop : (wa (l.addr + l.size) ls).takeWhile (·.addr = Int64.ofNat l.addr) = [] := by
        cases ls with
        | nil => rfl
        | cons l1 ls =>
          have hne : Int64.ofNat (l.addr + l.size) ≠ Int64.ofNat l.addr :=
            ofNat_ne hb (by omega) (by omega)
          exact List.takeWhile_cons_of_neg (by simpa only [decide_eq_true_eq] using hne)
      simp [wa, hstop, -Int64.ofNat_add]
    · have hl' : l ∈ ls := by
        rcases List.mem_cons.1 hl with h | h
        · subst h; exact absurd ha e
        · exact h
      have hne : Int64.ofNat a ≠ Int64.ofNat l.addr :=
        ofNat_ne (by omega) (hall l hl').2 (Ne.symm e)
      simp only [wa, ne_eq, hne, not_false_eq_true, decide_true, List.dropWhile_cons_of_pos]
      exact ih hc' hl'

theorem dir_ne_label (l : Line) (x : Label) : l.dir ≠ .label x := by
  unfold Line.dir
  cases l.instr <;> simp

/-- The first label directive of the executable with a name is at the first line with it. -/
theorem labels_wa {a : Nat} {ls : List Line} (hc : chain a ls = true) (x : Label)
    (f : Kraken.Addressable Directive → Option Int64)
    (hf : ∀ y, f y = if y.directive = .label x then some y.addr else none) :
    (wa a ls).findSome? f = (ls.find? (·.label == x)).map fun ln => Int64.ofNat ln.addr := by
  induction ls generalizing a with
  | nil => rfl
  | cons l ls ih =>
    simp only [chain, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at hc
    obtain ⟨⟨ha, hs⟩, hc'⟩ := hc
    by_cases e : l.label = x
    · simp [wa, hf, e, ha]
    · have e' : (Kraken.Directive.label l.label : Directive) ≠ .label x := by simpa using e
      simp [wa, hf, e, e', dir_ne_label l x, ih hc']

/-- The labels of the executable of well-formed lines are the labels of the lines. -/
theorem labels_exeOf {ls : List Line} (hwf : wf ls = true) :
    Executable.labels (exeOf ls) = labelsOf ls := by
  have hc : chain ((ls.head?.map (·.addr)).getD 0) ls = true := by
    cases ls with
    | nil => decide
    | cons l ls => exact hwf
  simp only [Executable.labels, labelsOf]
  congr 1
  funext x
  congr 1
  exact (congrArg (List.findSome? _) (withAddresses_progOf _ ls)).trans
    (labels_wa hc x _ fun y => by rfl)

/-- **The block of the executable at a line is the lowering of the line.** -/
theorem lowerProgram_exeOf {ls : List Line} (hwf : wf ls = true) {l : Line} (hl : l ∈ ls)
    {i : Instr} (hi : l.instr = some i) :
    lowerProgram (exeOf ls) (BitVec.ofNat 64 l.addr) =
      some (@lower (labelsOf ls) ⟨.ofNat l.addr, .ofNat l.addr + .ofNat l.size⟩ i) := by
  cases ls with
  | nil => cases hl
  | cons l0 ls =>
    have hpc : Int64.ofBitVec (BitVec.ofNat 64 l.addr) = Int64.ofNat l.addr := rfl
    have hd : (exeOf (l0 :: ls)).directivesAtAddress (Int64.ofNat l.addr) =
        [⟨.label l.label, 0⟩, ⟨l.dir, l.size⟩] :=
      (congrArg (fun w => ((w.dropWhile (·.addr ≠ Int64.ofNat l.addr)).takeWhile
        (·.addr = Int64.ofNat l.addr)).map (·.toSized))
        (withAddresses_progOf l0.addr (l0 :: ls))).trans (dirs_wa hwf hl)
    simp only [lowerProgram, hpc, hd, Line.dir, hi, lowerDirs]
    rw [labels_exeOf hwf]

/-- **The blocks of lines of a binary are blocks of its lowering.** If `code` is part of the
well-formed lines `image`, each block of the lowering of `code` is the block of the
executable of `image` at its address. -/
theorem holds_exeOf {image code : List Line} {blocks : List (Word × Block)}
    (hwf : wf image = true) (hsub : ∀ ln ∈ code, ln ∈ image)
    (hlow : blocks = lowerLines (labelsOf image) code) :
    ∀ p ∈ blocks, lowerProgram (exeOf image) p.1 = some p.2 := by
  subst hlow
  intro p hp
  simp only [lowerLines, List.mem_filterMap, Option.map_eq_some_iff] at hp
  obtain ⟨ln, hln, i, hi, rfl⟩ := hp
  exact lowerProgram_exeOf hwf (hsub ln hln) hi

end Lowering.X86
