/-
  Examples.Sha256Main.X86.Proofs

  The whole program on the x86-64 machine model. The hypothesis of every theorem here is
  that a machine has the binary loaded (`Lowering.X86.Loaded`) with a message in it: its
  table, its stack, the length of the message and the message are where the binary puts
  them, and the program counter is at the entry point; the code is the model's executable of
  the binary's lines, `exe`. Nothing else is assumed of memory, of the registers or of the
  flags.

  The pinned model has no system call (`docs/ISA.md`), so the program has no event of the
  environment: it leaves the digest in memory, at `digest`, and ends in a loop, a jump to
  itself at `0x402530`. The theorems say that every run reaches that loop.

  ## Main definitions

  * `imageOf`: the binary with a given message in it
  * `HasBytesAt`: a machine has given bytes in memory at an address
  * `inFrame`: a label that is not an event and, if a store, is one into the stack in use
    or `digest`

  ## Main results

  * `sha256_main_run`: every run reaches the loop, with its whole trace and the digest
  * `sha256_main_correct`: every run reaches the loop with SHA-256 of the message at `digest`
  * `sha256_main_abc`: the binary as compiled leaves the digest of `"abc"`
  * `sha256_main_leakage`, `sha256_main_leakage_eq`: the trace is a function of the length
    of the message, and two messages of one length give the same trace
  * `sha256_main_safe`: no state the machine can reach has a byte changed outside the stack
    in use and `digest`
-/

module

public import Examples.Sha256Main.X86.Main
public import Lowering.X86.Safety

public section

namespace Examples.Sha256Main.X86

open Braid hiding Image
open Examples Examples.Sha256 Lowering.X86 Lowering.X86.Regs

/-! ## The binary -/

/-- The binary with the message `msg` in it: the code, table and zeroed memory of the binary
`braid-lower` read (`sha256_main_image`), with the length of `msg` in the section `.msglen`
and `msg` in the section `.msg`, which is the last. -/
@[expose] def imageOf (msg : List (BitVec 8)) : Lowering.X86.Image :=
  { entry := 0x4023b0#64,
    code := sha256_main_image.code,
    data := [(0x4022b0#64, sha256_main_section_rodata), (0x402540#64, List.replicate 2080 0#8),
      (0x402d60#64, leBytes 8 (BitVec.ofNat 64 msg.length)), (0x402d68#64, msg)],
    zero := [] }

/-- The binary as it was compiled has the message `"abc"`. -/
theorem imageOf_abc : imageOf [97#8, 98#8, 99#8] = sha256_main_image := rfl

/-! ## What the trace touches -/

/-- Whether a label is one the program emits within its frame: not an event of the
environment and, if it is a store, a store into the 568 bytes the program writes, from
`0x402b28` up to `0x402d60`: the stack in use, and `digest` above it. -/
@[expose] def inFrame : Braid.Label → Bool
  | .write b k => decide (0x402b28 ≤ b.toNat ∧ b.toNat + k ≤ 0x402d60)
  | .event _ => false
  | _ => true

theorem all_byteLeak (n k : Nat) (e : Word) : (byteLeak n k e).all inFrame = true := by
  simp only [byteLeak]
  (repeat' split) <;> rfl

theorem all_wordLeak (n b j : Nat) (e : Word) (hj : j < 16) :
    (wordLeak n b j e).all inFrame = true := by
  simp only [wordLeak, List.all_append, all_byteLeak, Bool.true_and, List.all_cons,
    List.all_nil, Bool.and_true, inFrame, decide_eq_true_eq]
  bv_omega

theorem all_wordsLeak (n b : Nat) : ∀ (r j : Nat), j + r < 16 →
    (wordsLeak n b j r).all inFrame = true := by
  intro r
  induction r with
  | zero => exact fun j hj => all_wordLeak n b j _ (by omega)
  | succ r ih =>
    intro j hj
    simp only [wordsLeak, List.all_append, all_wordLeak n b j _ (by omega), ih (j + 1) (by omega),
      Bool.and_self]

theorem all_compressLeak :
    (Sha256.X86.compressLeak 0x402c88#64 0x402cc8#64 0x402c70#64 0x40246f#64).all inFrame =
      true := by
  decide +kernel

theorem all_blocksLeak (n : Nat) : ∀ (r b : Nat), (blocksLeak n b r).all inFrame = true := by
  intro r
  induction r with
  | zero =>
    intro b
    simp only [blocksLeak, blockLeak, List.all_append, all_wordsLeak n b 15 0 (by omega),
      all_compressLeak]
    rfl
  | succ r ih =>
    intro b
    simp only [blocksLeak, blockLeak, List.all_append, all_wordsLeak n b 15 0 (by omega),
      all_compressLeak, ih]
    rfl

theorem all_outLeak : outLeak.all inFrame = true := by decide +kernel

theorem all_mainLeak (n : Nat) : (mainLeak n).all inFrame = true := by
  simp only [mainLeak, List.all_append, all_blocksLeak, all_outLeak, Bool.and_true]
  decide +kernel

/-- Every store of `mainLeak` is into the frame. -/
theorem mainLeak_write (n : Nat) (b : Word) (k : Nat) (h : Braid.Label.write b k ∈ mainLeak n) :
    0x402b28 ≤ b.toNat ∧ b.toNat + k ≤ 0x402d60 := by
  simpa [inFrame] using List.all_eq_true.1 (all_mainLeak n) _ h

/-! ## Out of the logic -/

/-- The machine has the bytes `bs` in memory from the address `a` on. -/
@[expose] def HasBytesAt (m : MachineState) (a : Word) (bs : List (BitVec 8)) : Prop :=
  ∀ (i : Nat) (hi : i < bs.length),
    (m.data.dmem[a + BitVec.ofNat 64 i]?).map (·.toBitVec) = some bs[i]

/-- An array of bytes of a postcondition, read off the machine. -/
theorem hasBytesAt_of_holds {m : MachineState} {σ : State} {as : Atoms} {R : SProp} {p : Word}
    {bs : List (BitVec 8)} (hr : Rel m σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.prop (bytesAt p bs))) : HasBytesAt m p bs := by
  intro i hi
  obtain ⟨F, e⟩ := hat.split
  rw [e, bytesAt_index p bs i hi] at h
  have hc := Atoms.mem_of_holds (SProp.holds_assoc.1 h) (.there .here)
    (x := p + BitVec.ofNat 64 i) (by simp)
  have hv : BitVec.truncate 8 (BitVec.zeroExtend 64 (bs.getD i 0#8) >>>
      ((p + BitVec.ofNat 64 i - (p + BitVec.ofNat 64 i)) <<< 3)) = bs[i] := by
    rw [BitVec.sub_self, List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hi]
    ext j
    simp
  rw [hv, hr.data.mem] at hc
  obtain ⟨b, hb, hc⟩ := memOf_eq_some hc
  rw [hb]
  simpa using (congrArg Cell.val hc).symm

/-! ## On the machine -/

theorem rodata_length : sha256_main_section_rodata.length = 256 := by decide +kernel

/-- The sections of the binary with a message in it do not overlap. -/
theorem imageOf_apart (msg : List (BitVec 8)) (hn : msg.length < 2 ^ 32) :
    Sections.Apart (imageOf msg).sections := by
  simp only [Sections.Apart, imageOf, Braid.Image.sections, List.map_nil, List.append_nil,
    List.pairwise_cons, List.mem_cons, List.not_mem_nil, or_false, forall_eq_or_imp,
    forall_eq, List.length_replicate, leBytes_length, List.Pairwise.nil, and_true,
    false_imp_iff, implies_true, rodata_length]
  have e : (0x402d68#64).toNat = 0x402d68 := rfl
  repeat' apply And.intro
  all_goals first | decide +kernel | omega

/-- The registers, flags and program counter of a machine state at the entry point, as
atoms. -/
@[expose] def entryAtoms (m : MachineState) : Atoms :=
  [.pc 0x4023b0#64, .reg rax (m.data.regs.get64 .rax), .reg rbx (m.data.regs.get64 .rbx),
    .reg rcx (m.data.regs.get64 .rcx), .reg rdx (m.data.regs.get64 .rdx),
    .reg rsi (m.data.regs.get64 .rsi), .reg rdi (m.data.regs.get64 .rdi),
    .reg rsp (m.data.regs.get64 .rsp), .reg rbp (m.data.regs.get64 .rbp),
    .reg r8 (m.data.regs.get64 .r8), .reg r9 (m.data.regs.get64 .r9),
    .reg r10 (m.data.regs.get64 .r10), .reg r11 (m.data.regs.get64 .r11),
    .reg r12 (m.data.regs.get64 .r12), .reg r13 (m.data.regs.get64 .r13),
    .reg r14 (m.data.regs.get64 .r14), .reg r15 (m.data.regs.get64 .r15),
    .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
    .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
    .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of]

/-- The whole run in the logic, from the registers and flags of a machine state:
`entry_trace m, msg, hn`. -/
local macro "entry_trace " m:term ", " msg:term ", " hn:term : term =>
  `(sha256_main_trace $msg $hn ((MachineState.data $m).regs.get64 .rax)
    ((MachineState.data $m).regs.get64 .rbx) ((MachineState.data $m).regs.get64 .rcx)
    ((MachineState.data $m).regs.get64 .rdx) ((MachineState.data $m).regs.get64 .rsi)
    ((MachineState.data $m).regs.get64 .rdi) ((MachineState.data $m).regs.get64 .rsp)
    ((MachineState.data $m).regs.get64 .rbp) ((MachineState.data $m).regs.get64 .r8)
    ((MachineState.data $m).regs.get64 .r9) ((MachineState.data $m).regs.get64 .r10)
    ((MachineState.data $m).regs.get64 .r11) ((MachineState.data $m).regs.get64 .r12)
    ((MachineState.data $m).regs.get64 .r13) ((MachineState.data $m).regs.get64 .r14)
    ((MachineState.data $m).regs.get64 .r15) (MachineState.data $m).status.cf
    (MachineState.data $m).status.pf (MachineState.data $m).status.af
    (MachineState.data $m).status.zf (MachineState.data $m).status.sf
    (MachineState.data $m).status.of)

theorem entryAtoms_sat (m : MachineState) (hpc : m.pc.toBitVec = 0x4023b0#64) :
    ∀ a ∈ entryAtoms m, a.sat (abs m) := by
  simp [entryAtoms, Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, regOf, flagOf, hpc]

/-- **The whole run, on the machine.** Every run of the executable from a machine state
that has the binary loaded with a message `msg` of fewer than `2 ^ 32` bytes in it reaches
the loop at `0x402530`, with the trace `mainLeak` of the length of the message and with the
32 bytes of the SHA-256 digest of `msg` in memory at `digest`, `0x402d40`. Nothing is asked
of the registers, of the flags, or of memory other than that the binary is loaded. -/
theorem sha256_main_run [Layout] (m : MachineState) (msg : List (BitVec 8))
    (hn : msg.length < 2 ^ 32) (hl : Loaded m (imageOf msg)) :
    RunL exe (fun m' u => u = mainLeak msg.length ∧ m'.pc.toBitVec = 0x402530#64 ∧
      HasBytesAt m' 0x402d40#64 (sha256 msg)) m [] := by
  refine (program_soundT (img := imageOf msg) sha256_main_holds (regs := entryAtoms m)
    (entry_trace m, msg, hn) hl (imageOf_apart msg hn)
    (by simp [entryAtoms, Atom.IsPointsTo])
    (by simp [entryAtoms, Atom.disj_reg_mem, Atom.disj_pc_mem, Atom.disj_flag_mem])
    (by unfold entryAtoms; sha256_disj)
    (entryAtoms_sat m hl.pc)).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_, hasBytesAt_of_holds hr hq (by braid_at)⟩
  rw [← hr.pc]
  exact Atoms.pc_of_holds hq (by braid_at)

/-- **The program computes SHA-256.** Every run of the executable in the model, from a
machine state that has the binary loaded with the message `msg` in it (`hl`; `msg` has fewer
than `2 ^ 32` bytes, `hn`), reaches the loop at `0x402530` in which the program ends, with
the 32 bytes of the SHA-256 digest of `msg` (`Examples.Sha256.sha256`, checked on the
examples of FIPS 180-4) in memory at `digest`, `0x402d40`. There is no event of writing out
or of exit, because the model has no system call: the digest is left in memory, and the
loop is a jump to itself. -/
theorem sha256_main_correct [Layout] (m : MachineState) (msg : List (BitVec 8))
    (hn : msg.length < 2 ^ 32) (hl : Loaded m (imageOf msg)) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = 0x402530#64 ∧ HasBytesAt m' 0x402d40#64 (sha256 msg)) m :=
  eventually_weaken _ _ _ _ (fun _ ⟨_, h⟩ => h.2) (sha256_main_run m msg hn hl).eventually

/-- **The binary as it was compiled leaves the digest of `"abc"`.** Every run from a
machine state that has the binary `braid-lower` read loaded reaches the loop with, at
`digest`, the bytes the standard gives for the message `"abc"`. -/
theorem sha256_main_abc [Layout] (m : MachineState) (hl : Loaded m sha256_main_image) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = 0x402530#64 ∧ HasBytesAt m' 0x402d40#64
        [0xba, 0x78, 0x16, 0xbf, 0x8f, 0x01, 0xcf, 0xea, 0x41, 0x41, 0x40, 0xde, 0x5d, 0xae,
          0x22, 0x23, 0xb0, 0x03, 0x61, 0xa3, 0x96, 0x17, 0x7a, 0x9c, 0xb4, 0x10, 0xff, 0x61,
          0xf2, 0x00, 0x15, 0xad]) m := by
  have h3 : [97#8, 98#8, 99#8].length < 2 ^ 32 := by
    show 3 < 2 ^ 32
    omega
  have h := sha256_main_correct m [97#8, 98#8, 99#8] h3 (by rw [imageOf_abc]; exact hl)
  have habc : asciiBytes "abc" = [97#8, 98#8, 99#8] := by decide +kernel
  rwa [← habc, sha256_abc] at h

/-- **What the program reveals.** Every run from a machine state that has the binary loaded
with the message `msg` in it reaches the loop with the trace `mainLeak` of the length of
`msg`: the branches taken and the addresses read and written are a function of the length
alone. The trace is all leakage: the program has no event of the environment. -/
theorem sha256_main_leakage [Layout] (m : MachineState) (msg : List (BitVec 8))
    (hn : msg.length < 2 ^ 32) (hl : Loaded m (imageOf msg)) :
    RunL exe (fun m' u => u = mainLeak msg.length ∧ m'.pc.toBitVec = 0x402530#64) m [] :=
  (sha256_main_run m msg hn hl).mono fun _ _ h => ⟨h.1, h.2.1⟩

/-- **The program reveals the length of the message and nothing else of it.** Two machine
states that have the binary loaded, with messages `msg₁` and `msg₂` of the same length, have
one trace `tr` such that every run from either reaches the loop with the trace `tr`,
whatever the messages are. -/
theorem sha256_main_leakage_eq [Layout] (m₁ m₂ : MachineState) (msg₁ msg₂ : List (BitVec 8))
    (hn : msg₁.length < 2 ^ 32) (hlen : msg₂.length = msg₁.length)
    (hl₁ : Loaded m₁ (imageOf msg₁)) (hl₂ : Loaded m₂ (imageOf msg₂)) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = 0x402530#64) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = 0x402530#64) m₂ [] := by
  have h₁ := sha256_main_leakage m₁ msg₁ hn hl₁
  have h₂ := sha256_main_leakage m₂ msg₂ (hlen ▸ hn) hl₂
  rw [hlen] at h₂
  exact ⟨_, h₁, h₂⟩

/-- The code at `0x402530`, where the program ends, is a jump to itself and nothing else. -/
theorem loop_lowered :
    lowerProgram exe 0x402530#64 = some { ops := [], term := .jump 0x402530#64 } :=
  sha256_main_holds (0x402530#64, { ops := [], term := .jump 0x402530#64 }) (by decide +kernel)

/-- **No store outside the stack and `digest`.** In every state the machine can reach
(`Lowering.X86.Reachable`), in any number of steps, from a state that has the binary loaded
with the message `msg` in it, every byte of memory outside the 568 bytes from `0x402b28` up
to `0x402d60`, which are the stack in use and `digest`, is as it was at the start: mapped or
not, and with the same contents. In particular the table of round constants, the message
and its length are never written, and this holds for as long as the machine runs, the loop
in which the program ends included. -/
theorem sha256_main_safe [Layout] (m : MachineState) (msg : List (BitVec 8))
    (hn : msg.length < 2 ^ 32) (hl : Loaded m (imageOf msg)) :
    ∀ m', Reachable exe m m' → ∀ a : Word, ¬ (0x402b28 ≤ a.toNat ∧ a.toNat < 0x402d60) →
      m'.data.dmem[a]? = m.data.dmem[a]? := by
  refine program_safeT (img := imageOf msg) sha256_main_holds (regs := entryAtoms m)
    (entry_trace m, msg, hn) hl (imageOf_apart msg hn)
    (by simp [entryAtoms, Atom.IsPointsTo])
    (by simp [entryAtoms, Atom.disj_reg_mem, Atom.disj_pc_mem, Atom.disj_flag_mem])
    (by unfold entryAtoms; sha256_disj)
    (entryAtoms_sat m hl.pc) (stop := 0x402530#64) (by braid_at) loop_lowered ?_
  intro b k hm a ha
  have := mainLeak_write _ b k hm
  bv_omega

end Examples.Sha256Main.X86
