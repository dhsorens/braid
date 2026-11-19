/-
  Lowering.X86.Program

  Whole programs on x86-64. An image is the lines of a binary's code, its data sections and
  its entry point (`Braid.Image`). The model's program is the executable of the lines
  (`exeOf`), so a theorem about a whole program is about the runs of that executable from a
  machine state that has the sections in memory and is at the entry point: `Loaded`. A traced
  triple about the lowered code of an image, from a precondition that is the image's sections
  and the registers, is then a theorem about every such state, with no hypothesis about
  memory left in it.

  The pinned model has no system call (`docs/ISA.md`), so a whole program on x86-64 has no
  events of the environment: it leaves its result in memory and stops in a loop.

  ## Main definitions

  * `Image`, `Loaded`: an image of x86-64 code, and a machine state that has it loaded

  ## Main results

  * `program_soundT`: a traced triple about an image, as a theorem about a machine state that
    has it loaded
-/

module

public import Lowering.X86.Logic
public import Braid.Logic.Image

@[expose] public section

namespace Lowering.X86

open Braid hiding Image
open Iris Iris.BI

/-- An image of x86-64 code: the model's programs are assembly, kept here as lines. -/
abbrev Image := Braid.Image Line

/-- The machine state has the image loaded and is at its entry: every byte of every section
is in memory with its contents, and the program counter is the entry point. The code is not
in the state: the model runs the executable of the image's lines. -/
structure Loaded (m : MachineState) (img : Image) : Prop where
  mem : ∀ d ∈ img.sections, ∀ (i : Nat) (hi : i < d.2.length),
    (m.data.dmem[d.1 + BitVec.ofNat 64 i]?).map (·.toBitVec) = some d.2[i]
  pc : m.pc.toBitVec = img.entry

theorem Loaded.loadedIn {m : MachineState} {img : Image} (h : Loaded m img) :
    Sections.LoadedIn img.sections (abs m) := by
  intro d hd i hi
  have hb := h.mem d hd i hi
  simp only [abs, memOf]
  cases hx : m.data.dmem[d.1 + BitVec.ofNat 64 i]? with
  | none => rw [hx] at hb; cases hb
  | some b =>
    rw [hx] at hb
    simp only [Option.map_some, Option.some.injEq] at hb
    simp [hb]

/-- **A traced triple about an image, as a theorem about the machine.** `blocks` are blocks
of the lowering of the executable `e`. If they satisfy a traced triple from the atoms `regs`,
for registers, flags and the program counter, and the sections of the image, then every run
of `e` from a state that has the image loaded and of which `regs` are true reaches, with the
trace `ls`, a state related to one that satisfies `post`. The sections must not overlap,
which a written-out image decides. -/
theorem program_soundT [Layout] {e : Executable} {img : Image} {blocks : List (Word × Block)}
    {regs post : Atoms} {ls : Trace} {m : MachineState}
    (hcode : ∀ p ∈ blocks, lowerProgram e p.1 = some p.2)
    (ht : TripleT (Program.ofList blocks) (Atoms.interp (regs ++ sectionAtoms img.sections)) []
      (Atoms.interp post) ls)
    (hl : Loaded m img) (hap : Sections.Apart img.sections)
    (hpt : ∀ a ∈ regs, a.IsPointsTo)
    (hnm : ∀ a ∈ regs, ∀ q n v w, Atom.Disj a (.mem q n v w))
    (hrd : regs.Pairwise Atom.Disj) (hrs : ∀ a ∈ regs, a.sat (abs m)) :
    RunL e
      (fun m' u => u = ls ∧ ∃ σ', Rel m' σ' ∧ (Atoms.interp post).holds iprop(True) σ')
      m [] :=
  (tripleT_sound hcode ht (rel_abs m)
    (holds_sections hpt hnm hrd hrs hap hl.loadedIn)).mono
    fun _ _ ⟨σ', hr, hq, e⟩ => ⟨e, σ', hr, hq⟩

end Lowering.X86
