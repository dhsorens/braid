/-
  Examples.Sha256MainNi.Arm.Proofs

  The whole program with the compression function of `sha256_ni.c` on the AArch64 machine
  model. The hypothesis of every theorem here is that a machine has the binary loaded
  (`Lowering.Arm.Loaded`) with a message in it: its code, its table, the two addresses its
  code loads, the length of the message and the message are where the binary puts them,
  read-only, its stack is zeroed and writable, the program counter is at the entry point,
  and the supervisor calls are the model's Linux system calls. Nothing else is assumed of
  memory, of the registers or of the flags.

  The theorems are those of `Examples.Sha256Main.Arm.Proofs`, about this binary. The stack
  in use is smaller, 208 bytes and not 512: the callee has no frame.

  ## Main definitions

  * `image`: the binary with a given message in it
  * `inFrame`: a label that is not an event and, if a store, is one into the stack in use

  ## Main results

  * `sha256_main_run`: the run to the exit, with its whole trace
  * `sha256_main_correct`: the run ends in the exit event, and the bytes written out are
    SHA-256 of the message
  * `sha256_main_abc`: the binary as compiled writes out the digest of `"abc"`
  * `sha256_main_leakage`, `sha256_main_leakage_eq`: the leakage is a function of the length
    of the message, and two messages of one length give the same leakage
  * `sha256_main_safe`: no state the machine passes through has a byte changed outside the
    stack in use
-/

module

public import Examples.Sha256MainNi.Arm.Main
public import Lowering.Arm.Safety

public section

namespace Examples.Sha256MainNi.Arm

open Braid Examples Examples.Sha256 Examples.Sha256Main Lowering.Arm Lowering.Arm.Regs
open Examples.Sha256Main.Arm (byteLeak wordLeak wordsLeak outLeak)

/-! ## The binary -/

/-- The binary with the message `msg` in it: the code, table, addresses and stack of the
binary `braid-lower` read (`sha256_main_ni_image`), with the length of `msg` in the section
`.msglen` and `msg` in the section `.msg`, which is the last. -/
@[expose] def image (msg : List (BitVec 8)) : Image :=
  { entry := 0x20328#64,
    code := sha256_main_ni_image.code,
    data := [(0x20228#64, sha256_main_ni_section_rodata), (0x204d0#64, sha256_main_ni_section_got),
      (0x20ce0#64, leBytes 8 (BitVec.ofNat 64 msg.length)), (0x20ce8#64, msg)],
    zero := [(0x204e0#64, 2048)] }

/-- The binary as it was compiled has the message `"abc"`. -/
theorem image_abc : image [97#8, 98#8, 99#8] = sha256_main_ni_image := rfl

/-! ## What the trace touches -/

/-- Whether a label is one the program emits within its frame: not an event of the
environment and, if it is a store, a store into the 208 bytes of stack the program uses,
the frame of `main`, from `0x20c10` up to `0x20ce0`. -/
@[expose] def inFrame : Label → Bool
  | .write b k => decide (0x20c10 ≤ b.toNat ∧ b.toNat + k ≤ 0x20ce0)
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

theorem all_loopLeak : ∀ (n i : Nat), (Sha256Ni.Arm.loopLeak n i).all inFrame = true := by
  intro n
  induction n with
  | zero => exact fun i => by rw [Sha256Ni.Arm.loopLeak_zero]; rfl
  | succ n ih => exact fun i => by rw [Sha256Ni.Arm.loopLeak_succ]; exact ih (i + 1)

theorem all_tailLeak : ∀ (n i : Nat), (Sha256Ni.Arm.tailLeak n i).all inFrame = true := by
  intro n
  induction n with
  | zero => exact fun i => by rw [Sha256Ni.Arm.tailLeak_zero]; rfl
  | succ n ih => exact fun i => by rw [Sha256Ni.Arm.tailLeak_succ]; exact ih (i + 1)

/-- The stores of the compression function, as `main` calls it, are the four of the hash
value, which is in the frame of `main`: the callee has no frame of its own. -/
theorem all_compressNiLeak :
    (Sha256Ni.Arm.compressNiLeak 0x20c70#64 0x20c30#64 0x203e8#64).all inFrame = true := by
  rw [Sha256Ni.Arm.compressNiLeak_eq]
  simp only [List.all_append, all_loopLeak, all_tailLeak, Bool.and_true]
  decide +kernel

theorem all_blocksLeak (n : Nat) : ∀ (r b : Nat), (blocksLeak n b r).all inFrame = true := by
  intro r
  induction r with
  | zero =>
    intro b
    simp only [blocksLeak, blockLeak, List.all_append, all_wordsLeak n b 15 0 (by omega),
      all_compressNiLeak]
    rfl
  | succ r ih =>
    intro b
    simp only [blocksLeak, blockLeak, List.all_append, all_wordsLeak n b 15 0 (by omega),
      all_compressNiLeak, ih]
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
    0x20c10 ≤ b.toNat ∧ b.toNat + k ≤ 0x20ce0 := by
  simpa [inFrame] using List.all_eq_true.1 (all_mainLeak n) _ h

/-! ## On the machine -/

theorem rodata_length : sha256_main_ni_section_rodata.length = 256 := by decide +kernel

theorem got_length : sha256_main_ni_section_got.length = 16 := by decide +kernel

/-- The sections of the binary do not overlap, whatever message of fewer than `2 ^ 32` bytes
is in it. -/
theorem image_apart (msg : List (BitVec 8)) (hn : msg.length < 2 ^ 32) :
    Image.Apart (image msg) := by
  simp only [Image.Apart, Sections.Apart, image, zeros, List.map_cons, List.map_nil,
    List.pairwise_cons, List.mem_cons, List.not_mem_nil, or_false, forall_eq_or_imp,
    forall_eq, List.length_replicate, leBytes_length, List.Pairwise.nil, and_true,
    false_imp_iff, implies_true, rodata_length, got_length]
  have e1 : (0x20ce8#64).toNat = 0x20ce8 := rfl
  have e2 : (0x204e0#64).toNat = 0x204e0 := rfl
  have e3 : (0x20ce0#64).toNat = 0x20ce0 := rfl
  have e4 : (0x204d0#64).toNat = 0x204d0 := rfl
  have e5 : (0x20228#64).toNat = 0x20228 := rfl
  repeat' apply And.intro
  all_goals first | decide +kernel | omega

/-- **The whole run, on the machine.** A machine that has the binary loaded, with a message
`msg` of fewer than `2 ^ 32` bytes in it, and is at its entry point, runs until it has
exited with code 0. The trace of the run is `mainLeak` of the length of the message, then
the event of writing out the SHA-256 digest of `msg`, then the event of exiting with code 0.
Each step of the run keeps the bytes the machine may load, outside its stores (`RunS`).
Nothing is asked of the registers or of memory other than that the binary is loaded. -/
theorem sha256_main_run (prog : Arm64.Program) (s : Arm64.State) (msg : List (BitVec 8))
    (hn : msg.length < 2 ^ 32) (hl : Loaded prog s (image msg)) :
    ∃ s', RunS prog s (mainLeak msg.length ++
        [.event (.write (sha256 msg)), .event (.exit 0#64)]) s' ∧
      s'.status = .Exited 0#64 := by
  have hpc0 : s.pc = 0x20328#64 := hl.pc
  have ht := sha256_main_trace msg hn (regOf s 0) (regOf s 1) (regOf s 2)
    (regOf s 8) (regOf s 9) (regOf s 10) (regOf s 11) (regOf s 12)
    (regOf s 13) (regOf s 14) (regOf s 15)
    (regOf s (vlo 0)) (regOf s (vhi 0)) (regOf s (vlo 1)) (regOf s (vhi 1))
    (regOf s (vlo 2)) (regOf s (vhi 2)) (regOf s (vlo 3)) (regOf s (vhi 3))
    (regOf s (vlo 4)) (regOf s (vhi 4)) (regOf s (vlo 5)) (regOf s (vhi 5))
    (regOf s (vlo 6)) (regOf s (vhi 6)) (regOf s (vlo 7)) (regOf s (vhi 7))
    (regOf s (vlo 16)) (regOf s (vhi 16)) (regOf s (vlo 17)) (regOf s (vhi 17))
    (regOf s (vlo 18)) (regOf s (vhi 18)) (regOf s (vlo 19)) (regOf s (vhi 19))
    (regOf s 19)
    (regOf s 20) (regOf s 21) (regOf s 22) (regOf s 23) (regOf s 24) (regOf s 25) (regOf s 26)
    (regOf s 29) (regOf s 30) (regOf s 31) s.pstate.n s.pstate.z s.pstate.c s.pstate.v
  obtain ⟨s', σ', hrun, -, -⟩ := program_soundT (img := image msg) sha256_main_ni_lowered
    (regs := [.pc 0x20328#64, .reg x0 (regOf s 0), .reg x1 (regOf s 1), .reg x2 (regOf s 2),
      .reg x8 (regOf s 8),
      .reg x9 (regOf s 9), .reg x10 (regOf s 10), .reg x11 (regOf s 11),
      .reg x12 (regOf s 12), .reg x13 (regOf s 13), .reg x14 (regOf s 14),
      .reg x15 (regOf s 15),
      .reg (vlo 0) (regOf s (vlo 0)), .reg (vhi 0) (regOf s (vhi 0)),
      .reg (vlo 1) (regOf s (vlo 1)), .reg (vhi 1) (regOf s (vhi 1)),
      .reg (vlo 2) (regOf s (vlo 2)), .reg (vhi 2) (regOf s (vhi 2)),
      .reg (vlo 3) (regOf s (vlo 3)), .reg (vhi 3) (regOf s (vhi 3)),
      .reg (vlo 4) (regOf s (vlo 4)), .reg (vhi 4) (regOf s (vhi 4)),
      .reg (vlo 5) (regOf s (vlo 5)), .reg (vhi 5) (regOf s (vhi 5)),
      .reg (vlo 6) (regOf s (vlo 6)), .reg (vhi 6) (regOf s (vhi 6)),
      .reg (vlo 7) (regOf s (vlo 7)), .reg (vhi 7) (regOf s (vhi 7)),
      .reg (vlo 16) (regOf s (vlo 16)), .reg (vhi 16) (regOf s (vhi 16)),
      .reg (vlo 17) (regOf s (vlo 17)), .reg (vhi 17) (regOf s (vhi 17)),
      .reg (vlo 18) (regOf s (vlo 18)), .reg (vhi 18) (regOf s (vhi 18)),
      .reg (vlo 19) (regOf s (vlo 19)), .reg (vhi 19) (regOf s (vhi 19)),
      .reg x19 (regOf s 19), .reg x20 (regOf s 20),
      .reg x21 (regOf s 21), .reg x22 (regOf s 22), .reg x23 (regOf s 23),
      .reg x24 (regOf s 24), .reg x25 (regOf s 25), .reg x26 (regOf s 26),
      .reg x29 (regOf s 29), .reg lr (regOf s 30), .reg sp (regOf s 31),
      .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z, .flag Flags.c s.pstate.c,
      .flag Flags.v s.pstate.v])
    (by
      simp only [dataAtoms, zeroAtoms, secAtoms, sectionAtoms, zeros, image, List.map_cons,
        List.map_nil, List.cons_append, List.nil_append]
      exact ht)
    hl (image_apart msg hn)
    (by simp [Atom.IsPointsTo])
    (by simp [Atom.disj_reg_mem, Atom.disj_pc_mem, Atom.disj_flag_mem])
    (by sha256_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, hpc0, Flags.n, Flags.z, Flags.c,
      Flags.v])
  exact ⟨s', hrun, hrun.runL.status_of_exit (by simp)⟩

/-- **The program computes SHA-256.** A machine that has the binary loaded with the message
`msg` in it (`hl`; `msg` has fewer than `2 ^ 32` bytes, `hn`) runs from the entry point until
it has exited with code 0. The events of the run are two: the 32 bytes of the SHA-256 digest
of `msg` (`Examples.Sha256.sha256`, checked on the examples of FIPS 180-4) written to the
standard output, and then the exit with code 0. -/
theorem sha256_main_correct (prog : Arm64.Program) (s : Arm64.State) (msg : List (BitVec 8))
    (hn : msg.length < 2 ^ 32) (hl : Loaded prog s (image msg)) :
    ∃ tr s', RunL prog s tr s' ∧ tr.events = [.write (sha256 msg), .exit 0#64] ∧
      s'.status = .Exited 0#64 := by
  obtain ⟨s', hrun, hx⟩ := sha256_main_run prog s msg hn hl
  refine ⟨_, s', hrun.runL, ?_, hx⟩
  rw [Trace.events_append, Trace.events_eq_nil (mainLeak_isEvent _)]
  rfl

/-- **The binary as it was compiled writes out the digest of `"abc"`.** A machine that has
the binary `braid-lower` read loaded runs until it has exited, and the bytes it writes out
are those the standard gives for the message `"abc"`. -/
theorem sha256_main_abc (prog : Arm64.Program) (s : Arm64.State)
    (hl : Loaded prog s sha256_main_ni_image) :
    ∃ tr s', RunL prog s tr s' ∧ tr.events =
      [.write [0xba, 0x78, 0x16, 0xbf, 0x8f, 0x01, 0xcf, 0xea, 0x41, 0x41, 0x40, 0xde, 0x5d, 0xae,
        0x22, 0x23, 0xb0, 0x03, 0x61, 0xa3, 0x96, 0x17, 0x7a, 0x9c, 0xb4, 0x10, 0xff, 0x61,
        0xf2, 0x00, 0x15, 0xad], .exit 0#64] := by
  have h3 : [97#8, 98#8, 99#8].length < 2 ^ 32 := by
    show 3 < 2 ^ 32
    omega
  obtain ⟨tr, s', hrun, he, _⟩ := sha256_main_correct prog s [97#8, 98#8, 99#8] h3
    (by rw [image_abc]; exact hl)
  have habc : asciiBytes "abc" = [97#8, 98#8, 99#8] := by decide +kernel
  exact ⟨tr, s', hrun, by rw [he, ← sha256_abc, habc]⟩

/-- **What the program reveals.** A machine that has the binary loaded with the message
`msg` in it runs until it has exited, with a trace whose leakage, which is every label of it
that is not an event of the environment, is `mainLeak` of the length of `msg`: the branches
taken and the addresses read and written are a function of the length alone. -/
theorem sha256_main_leakage (prog : Arm64.Program) (s : Arm64.State) (msg : List (BitVec 8))
    (hn : msg.length < 2 ^ 32) (hl : Loaded prog s (image msg)) :
    ∃ tr s', RunL prog s tr s' ∧ tr.leakage = mainLeak msg.length ∧
      s'.status = .Exited 0#64 := by
  obtain ⟨s', hrun, hx⟩ := sha256_main_run prog s msg hn hl
  refine ⟨_, s', hrun.runL, ?_, hx⟩
  rw [Trace.leakage_append, Trace.leakage_eq_self (mainLeak_isEvent _),
    Trace.leakage_cons_event, Trace.leakage_cons_event, Trace.leakage_nil, List.append_nil]

/-- **The program reveals the length of the message and nothing else of it.** Two machines
that have the binary loaded, with messages `msg₁` and `msg₂` of the same length, run until
they have exited, with traces that have the same leakage, whatever the messages are. -/
theorem sha256_main_leakage_eq (prog₁ prog₂ : Arm64.Program) (s₁ s₂ : Arm64.State)
    (msg₁ msg₂ : List (BitVec 8)) (hn : msg₁.length < 2 ^ 32)
    (hlen : msg₂.length = msg₁.length)
    (hl₁ : Loaded prog₁ s₁ (image msg₁)) (hl₂ : Loaded prog₂ s₂ (image msg₂)) :
    ∃ tr₁ tr₂ s₁' s₂', RunL prog₁ s₁ tr₁ s₁' ∧ RunL prog₂ s₂ tr₂ s₂' ∧
      tr₁.leakage = tr₂.leakage ∧ s₁'.status = .Exited 0#64 ∧
      s₂'.status = .Exited 0#64 := by
  obtain ⟨tr₁, s₁', h₁, e₁, hx₁⟩ := sha256_main_leakage prog₁ s₁ msg₁ hn hl₁
  obtain ⟨tr₂, s₂', h₂, e₂, hx₂⟩ :=
    sha256_main_leakage prog₂ s₂ msg₂ (hlen ▸ hn) hl₂
  exact ⟨tr₁, tr₂, s₁', s₂', h₁, h₂, by rw [e₁, e₂, hlen], hx₁, hx₂⟩

/-- **No store outside the stack.** A machine that has the binary loaded with the message
`msg` in it never stores outside the 208 bytes of stack it uses, from `0x20c10` up to
`0x20ce0`: in every state it passes through, every byte outside that range that the machine
could load at the start can still be loaded, and is as it was at the start. In particular
the code, its table, the message and its length are never written. The range is the frame of
`main` alone, and not the 512 bytes of the program with the scalar compression function:
`sha256_compress_ni` has no frame, and its only stores are of the hash value, which is in
the frame of `main`. -/
theorem sha256_main_safe (prog : Arm64.Program) (s : Arm64.State) (msg : List (BitVec 8))
    (hn : msg.length < 2 ^ 32) (hl : Loaded prog s (image msg)) :
    ∀ s', Reachable prog s s' → ∀ a : Word, ¬ (0x20c10 ≤ a.toNat ∧ a.toNat < 0x20ce0) →
      s.mem.canRead a 1 = true →
      s'.mem.canRead a 1 = true ∧ s'.mem.read8 a = s.mem.read8 a := by
  obtain ⟨sf, hrun, hx⟩ := sha256_main_run prog s msg hn hl
  refine RunS.safe hrun hx fun b k hm a ha => ?_
  rcases List.mem_append.1 hm with hm | hm
  · have := mainLeak_write _ b k hm
    bv_omega
  · simp at hm

end Examples.Sha256MainNi.Arm
