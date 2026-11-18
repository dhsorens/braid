/-
  Lowering.X86.Logic

  The separation logic, for x86-64. A triple about lowered code is a statement about the
  machine: `triple_sound` carries it down through the lowering, and `machine_sound` states
  it of the machine alone.

  ## Main definitions

  * `Regs`, `Flags`: the names of the registers and flags
  * `abs`: the `braid` state of a machine state
  * `HasBytes`: the machine has bytes of a word in memory

  ## Main results

  * `triple_sound`: a triple about the lowered code of a function, for the machine
  * `machine_sound`: the same, from facts about the machine state alone
-/

module

public import Lowering.X86.Sound
public import Lowering.X86.Layout
public import Braid.Logic
import Iris.BI.DerivedLaws

@[expose] public section

namespace Lowering.X86

open Braid

/-! The names of the registers and flags, as `braid` registers and flags. -/

namespace Regs

abbrev rax : Braid.Reg := 0
abbrev rbx : Braid.Reg := 1
abbrev rcx : Braid.Reg := 2
abbrev rdx : Braid.Reg := 3
abbrev rsi : Braid.Reg := 4
abbrev rdi : Braid.Reg := 5
abbrev rsp : Braid.Reg := 6
abbrev rbp : Braid.Reg := 7
abbrev r8 : Braid.Reg := 8
abbrev r9 : Braid.Reg := 9
abbrev r10 : Braid.Reg := 10
abbrev r11 : Braid.Reg := 11
abbrev r12 : Braid.Reg := 12
abbrev r13 : Braid.Reg := 13
abbrev r14 : Braid.Reg := 14
abbrev r15 : Braid.Reg := 15

end Regs

namespace Flags

abbrev cf : Braid.Flag := 0
abbrev pf : Braid.Flag := 1
abbrev af : Braid.Flag := 2
abbrev zf : Braid.Flag := 3
abbrev sf : Braid.Flag := 4
abbrev of : Braid.Flag := 5
abbrev df : Braid.Flag := 6

end Flags

/-! ## Code -/

/-- A program whose blocks are all blocks of the lowering of an executable. -/
theorem ofList_le_lowerProgram {e : Executable} {blocks : List (Word × Block)}
    (hcode : ∀ p ∈ blocks, lowerProgram e p.1 = some p.2) (a : Word) (b : Block)
    (h : Program.ofList blocks a = some b) : lowerProgram e a = some b := by
  simp only [Program.ofList, Option.map_eq_some_iff] at h
  obtain ⟨⟨a', b'⟩, hfind, rfl⟩ := h
  have ha : a' = a := by simpa using List.find?_some hfind
  subst ha
  exact hcode _ (List.mem_of_find?_eq_some hfind)

/-- **A triple about lowered x86-64 code holds of the machine.** Let the blocks be blocks of
the lowering of an executable, and let a machine state be related to a `braid` state part of
which satisfies `pre`. If the blocks satisfy the triple from `pre` to `post`, then every run
of the executable from the machine state reaches a state related to one part of which
satisfies `post`. -/
theorem triple_sound [Layout] {e : Executable} {blocks : List (Word × Block)} {pre post : SProp}
    {m : MachineState} {σ : State}
    (hcode : ∀ p ∈ blocks, lowerProgram e p.1 = some p.2)
    (ht : Triple (Program.ofList blocks) pre post) (h : Rel m σ)
    (hp : (iprop(pre ∗ True) : SProp) σ.heap) :
    Eventually (step1 e)
      (fun m' => ∃ σ', Rel m' σ' ∧ (iprop(post ∗ True) : SProp) σ'.heap) m :=
  lowerProgram_sound h ((ht.sound hp).of_le (ofList_le_lowerProgram hcode))

/-! ## Theorems about the machine alone -/

/-- The value of the `braid` register `n` in machine data. -/
def regOf (s : MachineData) : Nat → Word
  | 0 => s.regs.get64 .rax
  | 1 => s.regs.get64 .rbx
  | 2 => s.regs.get64 .rcx
  | 3 => s.regs.get64 .rdx
  | 4 => s.regs.get64 .rsi
  | 5 => s.regs.get64 .rdi
  | 6 => s.regs.get64 .rsp
  | 7 => s.regs.get64 .rbp
  | 8 => s.regs.get64 .r8
  | 9 => s.regs.get64 .r9
  | 10 => s.regs.get64 .r10
  | 11 => s.regs.get64 .r11
  | 12 => s.regs.get64 .r12
  | 13 => s.regs.get64 .r13
  | 14 => s.regs.get64 .r14
  | 15 => s.regs.get64 .r15
  | _ => 0#64

theorem regOf_regNum (s : MachineData) (r : Reg64) : regOf s (regNum r) = s.regs.get64 r := by
  cases r <;> rfl

/-- The flag `n` of machine data. -/
def flagOf (s : MachineData) : Nat → Bool
  | 0 => s.status.cf
  | 1 => s.status.pf
  | 2 => s.status.af
  | 3 => s.status.zf
  | 4 => s.status.sf
  | 5 => s.status.of
  | 6 => s.df
  | _ => false

/-- The `braid` state of a machine state: its registers, flags and program counter, and a
writable cell at each byte of its memory. -/
def abs (m : MachineState) : State where
  regs := regOf m.data
  flags := flagOf m.data
  mem := memOf m.data.dmem
  pc := m.pc.toBitVec

@[simp] theorem abs_regs (m : MachineState) : (abs m).regs = regOf m.data := rfl

@[simp] theorem abs_flags (m : MachineState) : (abs m).flags = flagOf m.data := rfl

@[simp] theorem abs_pc (m : MachineState) : (abs m).pc = m.pc.toBitVec := rfl

/-- A machine state is related to its `braid` state. -/
theorem rel_abs (m : MachineState) : Rel m (abs m) :=
  ⟨⟨regOf_regNum m.data, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩, rfl⟩

/-- A register of a related state is the machine's. -/
theorem Rel.reg {m : MachineState} {σ : State} (h : Rel m σ) (r : Reg64) :
    σ.regs (regNum r) = m.data.regs.get64 r :=
  h.data.regs r

/-- The machine has the low `n` bytes of `v` in memory at `a`, little-endian. -/
def HasBytes (m : MachineState) (a : Word) (n : Nat) (v : Word) : Prop :=
  ∀ x : Word, (x - a).toNat < n →
    (m.data.dmem[x]?).map (·.toBitVec) = some ((v >>> ((x - a) <<< 3)).truncate 8)

/-- A writable memory atom is true of the state of a machine exactly when the machine has
its bytes. -/
theorem sat_mem_abs {m : MachineState} {a v : Word} {n : Nat} :
    (Atom.mem a n v true).sat (abs m) ↔ HasBytes m a n v := by
  rw [Atom.sat_mem]
  refine forall_congr' fun x => imp_congr_right fun _ => ?_
  simp only [abs, memOf]
  cases m.data.dmem[x]? <;> simp

/-- **A triple about lowered x86-64 code, as a theorem about the machine.** If the blocks
are blocks of the lowering of an executable and the machine state satisfies the atoms `pre`,
every run of the executable from it reaches a state related to one that satisfies the atoms
`post`. Read the conclusion off with `Atoms.reg_of_holds` and its companions, and `Rel`. -/
theorem machine_sound [Layout] {e : Executable} {blocks : List (Word × Block)}
    {pre post : Atoms} {m : MachineState}
    (hcode : ∀ p ∈ blocks, lowerProgram e p.1 = some p.2)
    (ht : Triple (Program.ofList blocks) (Atoms.interp pre) (Atoms.interp post))
    (hpt : ∀ a ∈ pre, a.IsPointsTo) (hdisj : pre.Pairwise Atom.Disj)
    (hsat : ∀ a ∈ pre, a.sat (abs m)) :
    Eventually (step1 e)
      (fun m' => ∃ σ', Rel m' σ' ∧ (Atoms.interp post).holds iprop(True) σ') m :=
  triple_sound hcode ht (rel_abs m) (Atoms.holds_of_sat hpt hdisj hsat)

end Lowering.X86
