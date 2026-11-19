/-
  Lowering.RiscV.Program

  Whole programs on RISC-V. An image is the code of a binary, its data sections and its entry
  point (`Braid.Image`), and `Loaded` says a machine has one loaded and is at its entry. A
  traced triple about the lowered code of an image, from a precondition that is the image's
  sections and the registers, is then a theorem about every machine that has the image
  loaded: there is no hypothesis about memory left in it.

  ## Main definitions

  * `Image`, `Loaded`: an image of RISC-V code, and a machine that has it loaded

  ## Main results

  * `tripleT_soundEnv`: a traced triple about code lowered with its environment holds of the
    machine
  * `program_soundT`: a traced triple about an image, as a theorem about a machine that has
    it loaded
  * `TripleT.ecall_write`, `TripleT.ecall_exit`: the block of `ECALL`, for the write and for
    the exit
-/

module

public import Lowering.RiscV.Env
public import Lowering.RiscV.Logic

@[expose] public section

namespace Lowering.RiscV

open Braid hiding Reg Image
open RiscvZkvm.Rv64
open Iris Iris.BI

/-- An image of RISC-V code: the model holds decoded instructions. -/
abbrev Image := Braid.Image Instr

/-- The machine has the image loaded and is at its entry: its code holds the instructions,
every byte of every section is in valid memory with its contents, and the program counter is
the entry point. -/
structure Loaded (s : MachineState) (img : Image) : Prop where
  code : ∀ p ∈ img.code, s.code p.1 = some p.2
  mem : ∀ d ∈ img.sections, ∀ (i : Nat) (hi : i < d.2.length),
    isValidMemAddr (d.1 + BitVec.ofNat 64 i) = true ∧
      s.getByte (d.1 + BitVec.ofNat 64 i) = d.2[i]
  pc : s.pc = img.entry

theorem Loaded.loadedIn {s : MachineState} {img : Image} (h : Loaded s img) :
    Sections.LoadedIn img.sections (abs s) := by
  intro d hd i hi
  obtain ⟨hv, hb⟩ := h.mem d hd i hi
  simp only [abs, hv, ↓reduceIte, hb]

/-- The lowering of a list of instructions, with its environment, is part of the lowering of
any code memory that holds them. -/
theorem ofList_le_lowerCodeEnv {code : List (Word × Instr)} {mem : Word → Option Instr}
    (hcode : ∀ p ∈ code, mem p.1 = some p.2) (a : Word) (b : Block)
    (h : Program.ofList (code.map fun p => (p.1, lowerEnv p.1 p.2)) a = some b) :
    lowerCodeEnv mem a = some b := by
  simp only [Program.ofList, Option.map_eq_some_iff] at h
  obtain ⟨⟨a', b'⟩, hfind, rfl⟩ := h
  have hmem := List.mem_of_find?_eq_some hfind
  have ha : a' = a := by simpa using List.find?_some hfind
  subst ha
  obtain ⟨p, hp, hpe⟩ := List.mem_map.1 hmem
  cases hpe
  simp [lowerCodeEnv, hcode p hp]

/-- **A traced triple about RISC-V code lowered with its environment holds of the machine.**
The machine runs to a state related to one part of which satisfies `post`, and the trace of
the run, after `t`, is `t'`. -/
theorem tripleT_soundEnv {code : List (Word × Instr)} {blocks : List (Word × Block)}
    {pre post : SProp} {t t' : Trace} {s : MachineState} {σ : State}
    (hlow : blocks = code.map fun p => (p.1, lowerEnv p.1 p.2))
    (ht : TripleT (Program.ofList blocks) pre t post t')
    (hcode : ∀ p ∈ code, s.code p.1 = some p.2) (h : Rel s σ)
    (hp : (iprop(pre ∗ True) : SProp) σ.heap) :
    ∃ s' σ' tr, RunL s tr s' ∧ Rel s' σ' ∧ (iprop(post ∗ True) : SProp) σ'.heap ∧
      t ++ tr = t' := by
  subst hlow
  obtain ⟨s', σ', tr, hrun, hr, hq, e⟩ :=
    lowerCodeEnv_soundL rfl h ((ht.sound hp).of_le (ofList_le_lowerCodeEnv hcode))
  exact ⟨s', σ', tr, hrun, hr, hq, e⟩

/-- **A traced triple about an image, as a theorem about the machine.** `blocks` are the
lowered code of the image, by the certificate `hlow`. If they satisfy a traced triple from
the atoms `regs`, for registers and the program counter, and the sections of the image, then
a machine that has the image loaded and of which `regs` are true runs, with the trace `ls`,
to a state related to one that satisfies `post`. The sections must not overlap, which a
written-out image decides. -/
theorem program_soundT {img : Image} {blocks : List (Word × Block)} {regs post : Atoms}
    {ls : Trace} {s : MachineState}
    (hlow : blocks = img.code.map fun p => (p.1, lowerEnv p.1 p.2))
    (ht : TripleT (Program.ofList blocks) (Atoms.interp (regs ++ sectionAtoms img.sections)) []
      (Atoms.interp post) ls)
    (hl : Loaded s img) (hap : Sections.Apart img.sections)
    (hpt : ∀ a ∈ regs, a.IsPointsTo)
    (hnm : ∀ a ∈ regs, ∀ q n v w, Atom.Disj a (.mem q n v w))
    (hrd : regs.Pairwise Atom.Disj) (hrs : ∀ a ∈ regs, a.sat (abs s)) :
    ∃ s' σ', RunL s ls s' ∧ Rel s' σ' ∧ (Atoms.interp post).holds iprop(True) σ' := by
  obtain ⟨s', σ', tr, hrun, hr, hq, e⟩ := tripleT_soundEnv hlow ht hl.code (rel_abs s)
    (holds_sections hpt hnm hrd hrs hap hl.loadedIn)
  rw [List.nil_append] at e
  exact ⟨s', σ', e ▸ hrun, hr, hq⟩

/-! ## The block of `ECALL`, in the logic -/

/-- **The write.** With `t0 = 0x10`, `a0` at an array of bytes in the symbolic state and
`a1` its length, `ECALL` writes the array out: the trace gains the event, and the program
goes on at the next instruction. -/
theorem TripleT.ecall_write {P : Program} {as as' : Atoms} {post : SProp} {t t' : Trace}
    {p a v1 : Word} {bs : List (BitVec 8)} (hb : P p = some (ecall p))
    (hpc : as.At (.pc p)) (h5 : as.At (.reg 5 0x10#64)) (h10 : as.At (.reg 10 a))
    (h11 : as.At (.reg 11 v1)) (hv1 : v1 = BitVec.ofNat 64 bs.length)
    (hbs : as.At (.prop (bytesAt a bs))) (hlen : bs.length ≤ 0x1000000)
    (hupd : as.Upd (.pc p) (.pc (p + 4#64)) as')
    (h : TripleT P (Atoms.interp as') (t ++ outLabels bs) post t') :
    TripleT P (Atoms.interp as) t post t' := by
  intro R σ hs
  have hp : σ.pc = p := Atoms.pc_of_holds hs hpc
  have r5 := Atoms.reg_of_holds hs h5
  have r10 := Atoms.reg_of_holds hs h10
  have r11 := Atoms.reg_of_holds hs h11
  obtain ⟨F, e⟩ := hbs.split
  have hbytes := bytesAt_bytes (SProp.holds_assoc.1 (e ▸ hs))
  have e1 : v1.toNat = bs.length := by subst hv1; simp; omega
  refine .step σ t (fun σ' u => σ' = σ.setPc (p + 4#64) ∧ u = t ++ outLabels bs)
    ⟨ecall p, hp ▸ hb, ?_⟩ ?_
  · have hle : v1.ule 16777216#64 = true := by
      rw [BitVec.ule_iff_toNat_le, e1]; simpa using hlen
    have hz : (v1 = 0#64) ↔ bs = [] := by
      constructor
      · intro h0; rw [h0] at e1; exact List.eq_nil_of_length_eq_zero (by simpa using e1.symm)
      · rintro rfl; simpa using hv1
    simp [ecall, Block.wpL, wpOpsL, Op.wpL, Op.wp, Term.wpL, Term.wp, Op.leak, Term.leak,
      BinOp.leaks, Env.set, r5, r10, r11, e1, hbytes, hle, outLabels, hz]
  · rintro σ' u ⟨rfl, rfl⟩
    exact h R _ (TermSpec.pc_set (p + 4#64) hupd hs)

/-- **The exit.** With `t0 = 0`, `ECALL` is the exit with the code in `a0`: the trace gains
the event, and the program stays where it is. -/
theorem TripleT.ecall_exit {P : Program} {as : Atoms} {post : SProp} {t t' : Trace}
    {p c : Word} (hb : P p = some (ecall p))
    (hpc : as.At (.pc p)) (h5 : as.At (.reg 5 0#64)) (h10 : as.At (.reg 10 c))
    (h : TripleT P (Atoms.interp as) (t ++ [.event (.exit c)]) post t') :
    TripleT P (Atoms.interp as) t post t' := by
  intro R σ hs
  have hp : σ.pc = p := Atoms.pc_of_holds hs hpc
  have r5 := Atoms.reg_of_holds hs h5
  have r10 := Atoms.reg_of_holds hs h10
  refine .step σ t (fun σ' u => σ' = σ ∧ u = t ++ [.event (.exit c)])
    ⟨ecall p, hp ▸ hb, ?_⟩ ?_
  · have e : σ.setPc p = σ := by rw [← hp]; rfl
    simp [ecall, Block.wpL, wpOpsL, Op.wpL, Op.wp, Term.wpL, Term.wp, Op.leak, Term.leak,
      BinOp.leaks, Env.set, r5, r10, Mem.bytes, e]
  · rintro σ' u ⟨rfl, rfl⟩
    exact h R _ hs

end Lowering.RiscV
