/-
  Examples.Sha256Main.RiscV.Proofs

  The whole program on the RISC-V machine model. The hypothesis of every theorem here is
  that a machine has the binary loaded (`Lowering.RiscV.Loaded`) with a message in it: its
  code, its table, its stack, the length of the message and the message are where the binary
  puts them, and the program counter is at the entry point. Nothing else is assumed of
  memory or of the registers.

  ## Main definitions

  * `image`: the binary with a given message in it
  * `inFrame`: a label that is not an event and, if a store, is one into the stack in use

  ## Main results

  * `sha256_main_run`: the run to the exit call, with its whole trace
  * `sha256_main_correct`: the run ends in the exit event, and the bytes written out are
    SHA-256 of the message
  * `sha256_main_abc`: the binary as compiled writes out the digest of `"abc"`
  * `sha256_main_leakage`, `sha256_main_leakage_eq`: the leakage is a function of the length
    of the message, and two messages of one length give the same leakage
  * `sha256_main_safe`: no state the machine passes through has a byte changed outside the
    stack in use
-/

module

public import Examples.Sha256Main.RiscV.Main
public import Lowering.RiscV.Safety

public section

namespace Examples.Sha256Main.RiscV

open Braid Examples Examples.Sha256 Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-! ## The binary -/

/-- The binary with the message `msg` in it: the code, table and stack of the binary
`braid-lower` read (`sha256_main_image`), with the length of `msg` in the section `.msglen`
and `msg` in the section `.msg`, which is the last. -/
@[expose] def image (msg : List (BitVec 8)) : Image :=
  { entry := 0x10468#64,
    code := sha256_main_image.code,
    data := [(0x10368#64, sha256_main_section_rodata), (0x10640#64, List.replicate 2048 0#8),
      (0x10e40#64, leBytes 8 (BitVec.ofNat 64 msg.length)), (0x10e48#64, msg)],
    zero := [] }

/-- The binary as it was compiled has the message `"abc"`. -/
theorem image_abc : image [97#8, 98#8, 99#8] = sha256_main_image := rfl

/-! ## What the trace touches -/

/-- Whether a label is one the program emits within its frame: not an event of the
environment and, if it is a store, a store into the 520 bytes of stack the program uses,
from `0x10c38` up to `0x10e40`. -/
@[expose] def inFrame : Label → Bool
  | .write b k => decide (0x10c38 ≤ b.toNat ∧ b.toNat + k ≤ 0x10e40)
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
    (Sha256.RiscV.compressLeak 0x10dd0#64 0x10d90#64 0x10d70#64 0x10550#64).all inFrame =
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

theorem all_mainLeak (n : Nat) : (mainLeak n).all inFrame = true := by
  simp only [mainLeak, List.all_append, all_blocksLeak, Bool.and_true]
  decide +kernel

/-- No label of `mainLeak` is an event. -/
theorem mainLeak_isEvent (n : Nat) : ∀ l ∈ mainLeak n, l.isEvent = false := by
  intro l hl
  have := List.all_eq_true.1 (all_mainLeak n) l hl
  cases l <;> first | rfl | exact absurd this (by simp [inFrame])

/-- Every store of `mainLeak` is into the frame. -/
theorem mainLeak_write (n : Nat) (b : Word) (k : Nat) (h : Label.write b k ∈ mainLeak n) :
    0x10c38 ≤ b.toNat ∧ b.toNat + k ≤ 0x10e40 := by
  simpa [inFrame] using List.all_eq_true.1 (all_mainLeak n) _ h

/-! ## On the machine -/

theorem rodata_length : sha256_main_section_rodata.length = 256 := by decide +kernel

/-- A run does not change the code. -/
theorem code_runL {s s' : MachineState} {tr : Trace} (h : RunL s tr s') : s'.code = s.code := by
  induction h with
  | refl => rfl
  | step _ _ hs _ ih => exact ih.trans (code_step hs)
  | halt _ _ _ ih => exact ih

/-- **The whole run, on the machine.** A machine that has the binary loaded, with a message
`msg` of fewer than `2 ^ 32` bytes in it, and is at its entry point, runs to its exit call,
where it stays: the program counter is at the `ECALL` at `0x10634` with 0 in `t0`, which is
the halt, and 0 in `a0`, the exit code. The trace of the run is `mainLeak` of the length of
the message, then the event of writing out the SHA-256 digest of `msg`, then the event of
exiting with code 0. Nothing is asked of the registers or of memory other than that the
binary is loaded. -/
theorem sha256_main_run (s : MachineState) (msg : List (BitVec 8)) (hn : msg.length < 2 ^ 32)
    (hl : Loaded s (image msg)) :
    ∃ s', RunL s (mainLeak msg.length ++
        [.event (.write (sha256 msg)), .event (.exit 0#64)]) s' ∧
      s'.code s'.pc = some .ECALL ∧ s'.getReg .x5 = 0#64 := by
  have hpc0 : s.pc = 0x10468#64 := hl.pc
  obtain ⟨s', σ', hrun, hr, hq⟩ := program_soundT (img := image msg) sha256_main_lowered
    (regs := [.pc 0x10468#64, .reg ra (s.getReg .x1), .reg sp (s.getReg .x2),
      .reg t0 (s.getReg .x5), .reg t1 (s.getReg .x6), .reg t2 (s.getReg .x7),
      .reg s0 (s.getReg .x8), .reg s1 (s.getReg .x9), .reg a0 (s.getReg .x10),
      .reg a1 (s.getReg .x11), .reg a2 (s.getReg .x12), .reg a3 (s.getReg .x13),
      .reg a4 (s.getReg .x14), .reg a5 (s.getReg .x15), .reg a6 (s.getReg .x16),
      .reg a7 (s.getReg .x17), .reg s2 (s.getReg .x18), .reg s3 (s.getReg .x19),
      .reg s4 (s.getReg .x20), .reg s5 (s.getReg .x21), .reg s6 (s.getReg .x22),
      .reg s7 (s.getReg .x23), .reg s8 (s.getReg .x24), .reg t3 (s.getReg .x28),
      .reg t4 (s.getReg .x29), .reg t5 (s.getReg .x30), .reg t6 (s.getReg .x31)])
    (sha256_main_trace msg hn (s.getReg .x1) (s.getReg .x2) (s.getReg .x5) (s.getReg .x6)
      (s.getReg .x7) (s.getReg .x8) (s.getReg .x9) (s.getReg .x10) (s.getReg .x11)
      (s.getReg .x12) (s.getReg .x13) (s.getReg .x14) (s.getReg .x15) (s.getReg .x16)
      (s.getReg .x17) (s.getReg .x18) (s.getReg .x19) (s.getReg .x20) (s.getReg .x21)
      (s.getReg .x22) (s.getReg .x23) (s.getReg .x24) (s.getReg .x28) (s.getReg .x29)
      (s.getReg .x30) (s.getReg .x31)) hl
    (by
      simp only [Sections.Apart, image, Image.sections, List.map_nil, List.append_nil,
        List.pairwise_cons, List.mem_cons, List.not_mem_nil, or_false, forall_eq_or_imp,
        forall_eq, List.length_replicate, leBytes_length, List.Pairwise.nil, and_true,
        false_imp_iff, implies_true, rodata_length]
      have e : (0x10e48#64).toNat = 0x10e48 := rfl
      repeat' apply And.intro
      all_goals first | decide +kernel | omega)
    (by simp [Atom.IsPointsTo])
    (by simp [Atom.disj_reg_mem, Atom.disj_pc_mem])
    (by sha256_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc0])
  refine ⟨s', hrun, ?_, ?_⟩
  · have hpc : s'.pc = 0x10634#64 := by rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
    rw [hpc, code_runL hrun]
    exact hl.code (0x10634#64, .ECALL)
      (show (0x10634#64, Instr.ECALL) ∈ sha256_main_image.code from by decide +kernel)
  · rw [← hr.getReg (r := .x5) (by decide)]
    exact Atoms.reg_of_holds (r := 5) hq (by braid_at)

/-- **The program computes SHA-256.** A machine that has the binary loaded with the message
`msg` in it (`hl`; `msg` has fewer than `2 ^ 32` bytes, `hn`) runs from the entry point to
its exit call, where the machine halts. The events of the run are two: the 32 bytes of the
SHA-256 digest of `msg` (`Examples.Sha256.sha256`, checked on the examples of FIPS 180-4)
written out, and then the exit with code 0. -/
theorem sha256_main_correct (s : MachineState) (msg : List (BitVec 8))
    (hn : msg.length < 2 ^ 32) (hl : Loaded s (image msg)) :
    ∃ tr s', RunL s tr s' ∧ tr.events = [.write (sha256 msg), .exit 0#64] ∧
      s'.code s'.pc = some .ECALL ∧ s'.getReg .x5 = 0#64 := by
  obtain ⟨s', hrun, hf, h5⟩ := sha256_main_run s msg hn hl
  refine ⟨_, s', hrun, ?_, hf, h5⟩
  rw [Trace.events_append, Trace.events_eq_nil (mainLeak_isEvent _)]
  rfl

/-- **The binary as it was compiled writes out the digest of `"abc"`.** A machine that has
the binary `braid-lower` read loaded runs to its exit, and the bytes it writes out are those
the standard gives for the message `"abc"`. -/
theorem sha256_main_abc (s : MachineState) (hl : Loaded s sha256_main_image) :
    ∃ tr s', RunL s tr s' ∧ tr.events =
      [.write [0xba, 0x78, 0x16, 0xbf, 0x8f, 0x01, 0xcf, 0xea, 0x41, 0x41, 0x40, 0xde, 0x5d, 0xae,
        0x22, 0x23, 0xb0, 0x03, 0x61, 0xa3, 0x96, 0x17, 0x7a, 0x9c, 0xb4, 0x10, 0xff, 0x61,
        0xf2, 0x00, 0x15, 0xad], .exit 0#64] := by
  have h3 : [97#8, 98#8, 99#8].length < 2 ^ 32 := by
    show 3 < 2 ^ 32
    omega
  obtain ⟨tr, s', hrun, he, _⟩ := sha256_main_correct s [97#8, 98#8, 99#8] h3
    (by rw [image_abc]; exact hl)
  have habc : asciiBytes "abc" = [97#8, 98#8, 99#8] := by decide +kernel
  exact ⟨tr, s', hrun, by rw [he, ← sha256_abc, habc]⟩

/-- **What the program reveals.** A machine that has the binary loaded with the message
`msg` in it runs to its exit call with a trace whose leakage, which is every label of it
that is not an event of the environment, is `mainLeak` of the length of `msg`: the branches
taken and the addresses read and written are a function of the length alone. -/
theorem sha256_main_leakage (s : MachineState) (msg : List (BitVec 8))
    (hn : msg.length < 2 ^ 32) (hl : Loaded s (image msg)) :
    ∃ tr s', RunL s tr s' ∧ tr.leakage = mainLeak msg.length ∧
      s'.code s'.pc = some .ECALL ∧ s'.getReg .x5 = 0#64 := by
  obtain ⟨s', hrun, hf, h5⟩ := sha256_main_run s msg hn hl
  refine ⟨_, s', hrun, ?_, hf, h5⟩
  rw [Trace.leakage_append, Trace.leakage_eq_self (mainLeak_isEvent _),
    Trace.leakage_cons_event, Trace.leakage_cons_event, Trace.leakage_nil, List.append_nil]

/-- **The program reveals the length of the message and nothing else of it.** Two machines
that have the binary loaded, with messages `msg₁` and `msg₂` of the same length, run to
their exit calls with traces that have the same leakage, whatever the messages are. -/
theorem sha256_main_leakage_eq (s₁ s₂ : MachineState) (msg₁ msg₂ : List (BitVec 8))
    (hn : msg₁.length < 2 ^ 32) (hlen : msg₂.length = msg₁.length)
    (hl₁ : Loaded s₁ (image msg₁)) (hl₂ : Loaded s₂ (image msg₂)) :
    ∃ tr₁ tr₂ s₁' s₂', RunL s₁ tr₁ s₁' ∧ RunL s₂ tr₂ s₂' ∧ tr₁.leakage = tr₂.leakage ∧
      (s₁'.code s₁'.pc = some .ECALL ∧ s₁'.getReg .x5 = 0#64) ∧
      (s₂'.code s₂'.pc = some .ECALL ∧ s₂'.getReg .x5 = 0#64) := by
  obtain ⟨tr₁, s₁', h₁, e₁, hf₁⟩ := sha256_main_leakage s₁ msg₁ hn hl₁
  obtain ⟨tr₂, s₂', h₂, e₂, hf₂⟩ := sha256_main_leakage s₂ msg₂ (hlen ▸ hn) hl₂
  exact ⟨tr₁, tr₂, s₁', s₂', h₁, h₂, by rw [e₁, e₂, hlen], hf₁, hf₂⟩

/-- **No store outside the stack.** A machine that has the binary loaded with the message
`msg` in it never stores outside the 520 bytes of stack it uses, from `0x10c38` up to
`0x10e40`: in every state it passes through, every byte of memory outside that range is as
it was at the start. In particular the code's table, the message and its length are never
written. -/
theorem sha256_main_safe (s : MachineState) (msg : List (BitVec 8))
    (hn : msg.length < 2 ^ 32) (hl : Loaded s (image msg)) :
    ∀ s', Reachable s s' → ∀ a : Word, ¬ (0x10c38 ≤ a.toNat ∧ a.toNat < 0x10e40) →
      s'.getByte a = s.getByte a := by
  obtain ⟨sf, hrun, hf, h5⟩ := sha256_main_run s msg hn hl
  refine RunL.safe hrun hf h5 fun b k hm a ha => ?_
  rcases List.mem_append.1 hm with hm | hm
  · have := mainLeak_write _ b k hm
    bv_omega
  · simp at hm

end Examples.Sha256Main.RiscV
