/-
  Lowering.Arm.Program

  Whole programs on AArch64. An image is the code of a binary, as instruction words by
  address, its data sections and its entry point (`Braid.Image`), and `Loaded` says a machine
  has one loaded and is at its entry. A traced triple about the lowered code of an image,
  from a precondition that is the image's sections and the registers, is then a theorem about
  every machine that has the image loaded: there is no hypothesis about memory left in it.
  The sections with contents are loaded read-only and the zeroed ones read-write
  (`Lowering.Arm.ReadOnly`).

  The model fetches code from memory, so `Loaded` says of the code what it says of the data:
  which bytes are where. It does not ask for a code image of the model that holds the whole
  code (`Arm64.Program.CodeLoaded`), which would have to be one range of addresses; a binary
  may have its code in several.

  ## Main definitions

  * `Image`, `Loaded`: an image of AArch64 code, and a machine that has it loaded
  * `wordsAt`, `lowerWordsEnv`, `lowerImage`: the code of an image, and its lowering

  ## Main results

  * `tripleT_soundEnv`: a traced triple about code lowered with its environment holds of the
    machine
  * `program_soundT`: a traced triple about an image, as a theorem about a machine that has
    it loaded
  * `TripleT.svc_write`, `TripleT.svc_exit`: the block of `SVC #0`, for the write and for the
    exit
-/

module

public import Lowering.Arm.Env
public import Lowering.Arm.Logic
public import Lowering.Arm.ReadOnly

@[expose] public section

namespace Lowering.Arm

open Braid hiding Image
open Iris Iris.BI

/-- An image of AArch64 code: the model fetches instruction words from memory. -/
abbrev Image := Braid.Image (BitVec 32)

/-- The machine `prog`, in the state `s`, has the image loaded and is at its entry.

* `svc`: the supervisor calls of `prog` are the model's Linux system calls.
* `running`: the machine is running.
* `code`: at the address of each instruction word of the image, which is a multiple of four,
  `prog` has no hooked function, the four bytes are mapped executable, and they are the
  word. This is what the model's step asks for to fetch the word.
* `data`: every byte of every section with contents is mapped so that it may be loaded and
  may not be stored to, and holds its contents.
* `zero`: every byte of every zeroed section is mapped so that it may be loaded and stored
  to, and is zero.
* `pc`: the program counter is the entry point.

A state with these properties exists for an image whose code and sections do not overlap:
map the code read-execute, the sections with contents read-only and the zeroed ones
read-write, which is how the segments of a linked binary are marked but for data that is
initialised and written, of which the programs here have none. -/
structure Loaded (prog : Arm64.Program) (s : Arm64.State) (img : Image) : Prop where
  svc : prog.svc = Arm64.Syscall.standard
  running : s.status = .Running
  code : ∀ p ∈ img.code, prog.externAt? p.1 = none ∧ p.1.toNat % 4 = 0 ∧
    s.mem.canExec p.1 4 = true ∧ s.mem.read32 p.1 = p.2
  data : ∀ d ∈ img.data, ∀ (i : Nat) (hi : i < d.2.length),
    readable s.mem (d.1 + BitVec.ofNat 64 i) = true ∧
      writable s.mem (d.1 + BitVec.ofNat 64 i) = false ∧
      s.mem.read8 (d.1 + BitVec.ofNat 64 i) = d.2[i]
  zero : ∀ z ∈ img.zero, ∀ i < z.2,
    readable s.mem (z.1 + BitVec.ofNat 64 i) = true ∧
      writable s.mem (z.1 + BitVec.ofNat 64 i) = true ∧
      s.mem.read8 (z.1 + BitVec.ofNat 64 i) = 0#8
  pc : s.pc = img.entry

theorem Loaded.loadedIn {prog : Arm64.Program} {s : Arm64.State} {img : Image}
    (h : Loaded prog s img) : Image.LoadedIn img (abs s) := by
  refine ⟨fun d hd i hi => ?_, fun z hz i hi => ?_⟩
  · obtain ⟨hr, hw, hb⟩ := h.data d hd i hi
    simp only [abs, hr, ↓reduceIte, hw, hb]
  · obtain ⟨hr, hw, hb⟩ := h.zero z hz i hi
    simp only [abs, hr, ↓reduceIte, hw, hb]

/-- A machine that has an image loaded fetches the instruction each word of its code
decodes to. -/
theorem Loaded.fetchMem {prog : Arm64.Program} {s : Arm64.State} {img : Image}
    (h : Loaded prog s img) {p : Word × BitVec 32} (hp : p ∈ img.code) :
    prog.fetchMem s.mem p.1 = Arm64.decode p.2 := by
  obtain ⟨hx, hal, hc, hr⟩ := h.code p hp
  simp [Arm64.Program.fetchMem, hx, hal, hc, hr]

/-! ## Code -/

/-- A list of instruction words placed at `base`, by address: word `i` is at
`base + 4 * i`. -/
def wordsAt (base : Word) (ws : List (BitVec 32)) : List (Word × BitVec 32) :=
  ws.zipIdx.map fun (w, i) => (base + BitVec.ofNat 64 (4 * i), w)

/-- The blocks of instruction words by address, with `SVC #0` as a call of the environment.
A word that does not decode has no block. -/
def lowerImage (code : List (Word × BitVec 32)) : List (Word × Block) :=
  code.filterMap fun p => (Arm64.decode p.2).map fun ins => (p.1, lowerEnv p.1 ins)

/-- The blocks of a list of instruction words placed at `base`, with `SVC #0` as a call of
the environment: `lowerWords`, with `lowerEnv`. -/
def lowerWordsEnv (base : Word) (ws : List (BitVec 32)) : List (Word × Block) :=
  (ws.zipIdx).filterMap fun (w, i) =>
    (Arm64.decode w).map fun ins =>
      (base + BitVec.ofNat 64 (4 * i), lowerEnv (base + BitVec.ofNat 64 (4 * i)) ins)

theorem lowerImage_append (c d : List (Word × BitVec 32)) :
    lowerImage (c ++ d) = lowerImage c ++ lowerImage d :=
  List.filterMap_append ..

theorem lowerImage_wordsAt (base : Word) (ws : List (BitVec 32)) :
    lowerImage (wordsAt base ws) = lowerWordsEnv base ws := by
  simp only [lowerImage, wordsAt, lowerWordsEnv, List.filterMap_map]
  rfl

/-- The lowering of the code of an image is part of the lowering, with its environment, of
what a machine that has the image loaded fetches. -/
theorem ofList_le_lowerCodeEnv {prog : Arm64.Program} {s : Arm64.State} {img : Image}
    (hl : Loaded prog s img) (a : Word) (b : Block)
    (h : Program.ofList (lowerImage img.code) a = some b) :
    lowerCodeEnv (prog.fetchMem s.mem) a = some b := by
  simp only [Program.ofList, Option.map_eq_some_iff] at h
  obtain ⟨⟨a', b'⟩, hfind, rfl⟩ := h
  have hmem := List.mem_of_find?_eq_some hfind
  have ha : a' = a := by simpa using List.find?_some hfind
  subst ha
  simp only [lowerImage, List.mem_filterMap, Option.map_eq_some_iff] at hmem
  obtain ⟨p, hp, ins, hd, he⟩ := hmem
  cases he
  simp [lowerCodeEnv, hl.fetchMem hp, hd]

/-- **A traced triple about AArch64 code lowered with its environment holds of the
machine.** The machine runs to a state related to one part of which satisfies `post`, running
or exited, and the trace of the run, after `t`, is `t'`. -/
theorem tripleT_soundEnv {prog : Arm64.Program} {img : Image} {blocks : List (Word × Block)}
    {pre post : SProp} {t t' : Trace} {s : Arm64.State} {σ : State}
    (hlow : blocks = lowerImage img.code)
    (ht : TripleT (Program.ofList blocks) pre t post t')
    (hl : Loaded prog s img) (h : Rel s σ) (hp : (iprop(pre ∗ True) : SProp) σ.heap) :
    ∃ s' σ' tr, RunS prog s tr s' ∧ RelE s' σ' ∧ (iprop(post ∗ True) : SProp) σ'.heap ∧
      t ++ tr = t' := by
  subst hlow
  obtain ⟨s', σ', tr, hrun, hr, hq, e⟩ :=
    lowerCodeEnv_soundS hl.svc (fun _ _ h => h) h ((ht.sound hp).of_le (ofList_le_lowerCodeEnv hl))
  exact ⟨s', σ', tr, hrun, hr, hq, e⟩

/-- **A traced triple about an image, as a theorem about the machine.** `blocks` are the
lowered code of the image, by the certificate `hlow`. If they satisfy a traced triple from
the atoms `regs`, for registers, flags and the program counter, and the sections of the
image, those with contents read-only and the zeroed ones writable, then a machine that has
the image loaded and of which `regs` are true runs, with the trace `ls`, to a state related
to one that satisfies `post`, running or exited. Each step of the run keeps the bytes the
machine may load, outside its stores (`RunS`); it is a run with its trace by `RunS.runL`.
The sections must not overlap, which a written-out image decides. -/
theorem program_soundT {prog : Arm64.Program} {img : Image} {blocks : List (Word × Block)}
    {regs post : Atoms} {ls : Trace} {s : Arm64.State}
    (hlow : blocks = lowerImage img.code)
    (ht : TripleT (Program.ofList blocks)
      (Atoms.interp (regs ++ dataAtoms img ++ zeroAtoms img)) [] (Atoms.interp post) ls)
    (hl : Loaded prog s img) (hap : Image.Apart img)
    (hpt : ∀ a ∈ regs, a.IsPointsTo)
    (hnm : ∀ a ∈ regs, ∀ q n v w, Atom.Disj a (.mem q n v w))
    (hrd : regs.Pairwise Atom.Disj) (hrs : ∀ a ∈ regs, a.sat (abs s)) :
    ∃ s' σ', RunS prog s ls s' ∧ RelE s' σ' ∧
      (Atoms.interp post).holds iprop(True) σ' := by
  obtain ⟨s', σ', tr, hrun, hr, hq, e⟩ := tripleT_soundEnv hlow ht hl (rel_abs hl.running)
    (holds_image hpt hnm hrd hrs hap hl.loadedIn)
  rw [List.nil_append] at e
  exact ⟨s', σ', e ▸ hrun, hr, hq⟩

/-! ## The block of `SVC #0`, in the logic -/

/-- **The write.** With `x8 = 64`, 1 in `x0`, `x1` at an array of bytes in the symbolic
state, which is not empty, is no longer than the model's bound on a transfer and ends within
the model's user address space, and `x2` its length, `SVC #0` writes the array out: the trace
gains the event, `x0` holds the length, and the program goes on at the next instruction. -/
theorem TripleT.svc_write {P : Program} {as as₁ as' : Atoms} {post : SProp} {t t' : Trace}
    {p a v2 : Word} {bs : List (BitVec 8)} (hb : P p = some (svc p))
    (hpc : as.At (.pc p)) (h8 : as.At (.reg 8 64#64)) (h0 : as.At (.reg 0 1#64))
    (h1 : as.At (.reg 1 a)) (h2 : as.At (.reg 2 v2)) (hv2 : v2 = BitVec.ofNat 64 bs.length)
    (hbs : as.At (.prop (bytesAt a bs))) (hne : bs ≠ []) (hlen : bs.length ≤ 0x7ffff000)
    (hva : a.toNat + bs.length ≤ 2 ^ 48)
    (hreg : as.Upd (.reg 0 1#64) (.reg 0 v2) as₁) (hupd : as₁.Upd (.pc p) (.pc (p + 4#64)) as')
    (h : TripleT P (Atoms.interp as') (t ++ [.event (.write bs)]) post t') :
    TripleT P (Atoms.interp as) t post t' := by
  intro R σ hs
  have hp : σ.pc = p := Atoms.pc_of_holds hs hpc
  have r8 := Atoms.reg_of_holds hs h8
  have r0 := Atoms.reg_of_holds hs h0
  have r1 := Atoms.reg_of_holds hs h1
  have r2 := Atoms.reg_of_holds hs h2
  obtain ⟨F, e⟩ := hbs.split
  have hbytes := bytesAt_bytes (SProp.holds_assoc.1 (e ▸ hs))
  have e1 : v2.toNat = bs.length := by subst hv2; simp; omega
  obtain ⟨F₁, f, f'⟩ := hreg.split
  have hs₁ : (Atoms.interp as₁).holds R (σ.setReg 0 v2) :=
    (holds_split f').2 (regIs_set _ ((holds_split f).1 hs))
  refine .step σ t (fun σ' u => σ' = (σ.setReg 0 v2).setPc (p + 4#64) ∧
    u = t ++ [.event (.write bs)]) ⟨svc p, hp ▸ hb, ?_⟩ ?_
  · have hz : v2 ≠ 0#64 := by
      intro h0
      rw [h0] at e1
      exact hne (List.eq_nil_of_length_eq_zero (by simpa using e1.symm))
    have hz' : (v2 != 0#64) = true := by simpa using hz
    have hle : v2.ule 2147479552#64 = true := by
      rw [BitVec.ule_iff_toNat_le, e1]; simpa using hlen
    have hend : a.ule (281474976710656#64 - v2) = true := by
      rw [BitVec.ule_iff_toNat_le]
      have : v2.toNat ≤ 2147479552 := by omega
      bv_omega
    simp [svc, Block.wpL, wpOpsL, Op.wpL, Op.wp, Term.wpL, Term.wp, Op.leak, Term.leak,
      BinOp.leaks, Env.set, r8, r0, r1, r2, e1, hbytes, hle, hend, hz, hz']
  · rintro σ' u ⟨rfl, rfl⟩
    exact h R _ (TermSpec.pc_set (p + 4#64) hupd hs₁)

/-- **The exit.** With `x8 = 93`, `SVC #0` is the exit with the code in `x0`: the trace gains
the event, and the program stays where it is. -/
theorem TripleT.svc_exit {P : Program} {as : Atoms} {post : SProp} {t t' : Trace}
    {p c : Word} (hb : P p = some (svc p))
    (hpc : as.At (.pc p)) (h8 : as.At (.reg 8 93#64)) (h0 : as.At (.reg 0 c))
    (h : TripleT P (Atoms.interp as) (t ++ [.event (.exit c)]) post t') :
    TripleT P (Atoms.interp as) t post t' := by
  intro R σ hs
  have hp : σ.pc = p := Atoms.pc_of_holds hs hpc
  have r8 := Atoms.reg_of_holds hs h8
  have r0 := Atoms.reg_of_holds hs h0
  refine .step σ t (fun σ' u => σ' = σ ∧ u = t ++ [.event (.exit c)])
    ⟨svc p, hp ▸ hb, ?_⟩ ?_
  · have e : (σ.setReg 0 c).setPc p = σ := by rw [← r0, setReg_self, ← hp]; rfl
    simp [svc, Block.wpL, wpOpsL, Op.wpL, Op.wp, Term.wpL, Term.wp, Op.leak, Term.leak,
      BinOp.leaks, Env.set, r8, r0, Mem.bytes, e]
  · rintro σ' u ⟨rfl, rfl⟩
    exact h R _ hs

end Lowering.Arm
