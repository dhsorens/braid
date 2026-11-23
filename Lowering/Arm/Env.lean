/-
  Lowering.Arm.Env

  AArch64 with its environment. `lower` gives `SVC` a `trap`, since a theorem about a function
  has no use for it. A whole program ends in one, and writes its result out by another, so
  this file lowers `SVC #0` to the two events of the environment that are read off the model
  (`Lowering.Arm.Leak`): with `x8 = 64` the `x2` bytes at `x1` are written to the standard
  output, and with `x8 = 93` the program exits with the code in `x0`. Any other call faults.
  The lowering with `SVC #0` read this way is `lowerEnv`, and it is proved to preserve traces
  as `lower` is, for a program whose supervisor calls are the model's Linux system calls.

  The run the proof builds says a little more than a `RunL`: each of its steps keeps the
  bytes the machine may load, outside the stores in the step's labels (`RunS`). That is what
  memory safety of a whole run is read off (`Lowering.Arm.Safety`).

  ## Main definitions

  * `svc`: the block of `SVC #0`
  * `lowerEnv`, `lowerCodeEnv`: the lowering with `SVC #0` as the environment's two calls
  * `Kept`, `RunS`: a run whose steps keep memory outside their stores
  * `RelE`: `Rel`, or its like for a machine that has exited

  ## Main results

  * `standard_exit`, `standard_write`: what the model does at the two calls
  * `Block.wpL_kept`: a block changes no byte of memory outside its `write` labels
  * `svc_sound`: the block of `SVC #0` against the model and the reading of its events
  * `lowerCodeEnv_soundS`, `lowerCodeEnv_soundL`: every labelled run, `EventuallyL` to `RunS`
    and to `RunL`
-/

module

public import Lowering.Arm.LeakSound
import Braid.BV

@[expose] public section

namespace Lowering.Arm

open Braid
open Arm64 (Instr)

/-- The block of `SVC #0` at `pc`. Value 2 is whether the call is the exit (`x8 = 93`) and
value 4 whether it is the write (`x8 = 64`); it is one of the two. A write is one of a count
that is not zero and at most the model's bound on a transfer, to the standard output, from a
buffer that ends within the model's user address space: value 21. Value 23 is the number of
bytes written out, `x2` for the write and none for the exit. A write leaves its count in
`x0`. An exit stays at `pc`. -/
def svc (pc : Word) : Block :=
  ⟨[.get 0 8, .const 1 93, .bin 2 .eq 0 1, .const 3 64, .bin 4 .eq 0 3, .bin 5 .or 2 4,
    .guard 5, .get 6 0, .get 7 1, .get 8 2,
    .un 9 (.zext 32) 6, .const 10 1, .bin 11 .eq 9 10,
    .const 12 0, .bin 13 .ne 8 12,
    .const 14 0x7ffff000, .bin 15 .ule 8 14,
    .const 16 0x1000000000000, .bin 17 .sub 16 8, .bin 18 .ule 7 17,
    .bin 19 .and 11 13, .bin 20 .and 19 15, .bin 21 .and 20 18,
    .bin 22 .or 2 21, .guard 22,
    .select 23 4 8 12, .out 7 23, .select 24 4 8 6, .set 0 24],
   .exit 2 6 pc (pc + 4)⟩

/-- The block of an instruction at `pc`, with `SVC #0` as a call of the environment. -/
def lowerEnv (pc : Word) (i : Instr) : Block :=
  if i = .system false 0#16 then svc pc else lower pc i

/-- The program of a code memory, with `SVC #0` as a call of the environment. -/
def lowerCodeEnv (code : Word → Option Instr) : Program :=
  fun a => (code a).map (lowerEnv a)

variable {s : Arm64.State} {σ : State}

/-! ## The model at the two calls -/

/-- **The exit, in the model.** With `x8 = 93` the model's Linux system calls set the status
to `Exited` with the code in `x0`, and change nothing else. -/
theorem standard_exit (h8 : s.readReg64 .x8 = 93#64) :
    Arm64.Syscall.standard s = s.setStatus (.Exited (s.readReg64 .x0)) := by
  simp only [Arm64.Syscall.standard, Arm64.Syscall.dispatch, h8]
  rfl

/-- **The write, in the model.** In the case `svcLeak` speaks of, the model's Linux system
calls append the bytes of the buffer to the machine's output, as bytes written to the
standard output, put the count in `x0` and go on to the next instruction. -/
theorem standard_write (h8 : s.readReg64 .x8 = 64#64) (h0 : s.readReg32 .x0 = 1#32)
    (h2 : s.readReg64 .x2 ≠ 0#64) (hmax : (s.readReg64 .x2).toNat ≤ Arm64.MAX_RW_COUNT)
    (hva : (s.readReg64 .x1).toNat + (s.readReg64 .x2).toNat ≤ Arm64.USER_VA_LIMIT)
    (hr : s.mem.canRead (s.readReg64 .x1) (s.readReg64 .x2).toNat = true) :
    Arm64.Syscall.standard s =
      ((s.appendTrace (Arm64.TraceEvent.ofBytes .stdout
        (s.mem.readBytes (s.readReg64 .x1) (s.readReg64 .x2).toNat))).writeReg64 .x0
          (s.readReg64 .x2)).advancePC := by
  have e : Arm64.Syscall.standard s = Arm64.execWrite s := by
    simp only [Arm64.Syscall.standard, Arm64.Syscall.dispatch, h8]
    rfl
  rw [e]
  simp [Arm64.execWrite, h0, Nat.not_lt.2 hva, h2, Nat.min_eq_left hmax, hr,
    Arm64.OutputStream.ofFd]

/-- The step of the exit: the status, and nothing else. -/
theorem evalInst_exit {prog : Arm64.Program} (hsvc : prog.svc = Arm64.Syscall.standard)
    (h8 : s.readReg64 .x8 = 93#64) :
    prog.evalInst (.system false 0#16) s = s.setStatus (.Exited (s.readReg64 .x0)) := by
  simp [Arm64.Program.evalInst, Arm64.execInstWithSvc, Arm64.evalSvc, hsvc, standard_exit h8,
    Arm64.State.setStatus]

/-- The step of the write: the output, the count in `x0`, and the next instruction. -/
theorem evalInst_write {prog : Arm64.Program} (hsvc : prog.svc = Arm64.Syscall.standard)
    (h8 : s.readReg64 .x8 = 64#64) (h0 : s.readReg32 .x0 = 1#32)
    (h2 : s.readReg64 .x2 ≠ 0#64) (hmax : (s.readReg64 .x2).toNat ≤ Arm64.MAX_RW_COUNT)
    (hva : (s.readReg64 .x1).toNat + (s.readReg64 .x2).toNat ≤ Arm64.USER_VA_LIMIT)
    (hr : s.mem.canRead (s.readReg64 .x1) (s.readReg64 .x2).toNat = true) :
    prog.evalInst (.system false 0#16) s =
      ((s.appendTrace (Arm64.TraceEvent.ofBytes .stdout
        (s.mem.readBytes (s.readReg64 .x1) (s.readReg64 .x2).toNat))).writeReg64 .x0
          (s.readReg64 .x2)).advancePC := by
  simp [Arm64.Program.evalInst, Arm64.execInstWithSvc, Arm64.evalSvc, hsvc,
    standard_write h8 h0 h2 hmax hva hr, Arm64.State.advancePC, Arm64.State.writeReg64,
    Arm64.State.appendTrace]

/-! ## What a block leaves in memory -/

/-- The state `σ'` has the memory of `σ` outside the stores among the labels `u`. -/
def MemKept (σ σ' : State) (u : Trace) : Prop :=
  ∀ a, (∀ b n, Label.write b n ∈ u → ¬ (a - b).toNat < n) → σ'.mem a = σ.mem a

theorem MemKept.refl (σ : State) (u : Trace) : MemKept σ σ u := fun _ _ => rfl

theorem MemKept.trans {σ₁ σ₂ σ₃ : State} {u v : Trace} (h₁ : MemKept σ₁ σ₂ u)
    (h₂ : MemKept σ₂ σ₃ v) : MemKept σ₁ σ₃ (u ++ v) := fun a ha =>
  (h₂ a fun b n hm => ha b n (List.mem_append_right _ hm)).trans
    (h₁ a fun b n hm => ha b n (List.mem_append_left _ hm))

/-- An operation changes no byte of memory outside its `write` label. -/
theorem Op.wp_kept {op : Op} {ρ : Env} {σ : State} {Q : Env → State → Prop}
    (h : op.wp ρ σ Q) :
    op.wp ρ σ fun ρ' σ' => Q ρ' σ' ∧ MemKept σ σ' (op.leak ρ σ) := by
  cases op <;> simp only [Op.wp] at h ⊢
  case load => obtain ⟨v, hv, hq⟩ := h; exact ⟨v, hv, hq, .refl _ _⟩
  case store w a v =>
    obtain ⟨m, hm, hq⟩ := h
    refine ⟨m, hm, hq, fun x hx => ?_⟩
    have hn : w.bytes ≤ 8 := by cases w <;> decide
    obtain ⟨_, rfl⟩ := (Mem.storeN_spec hn).1 hm
    have := hx (ρ a) w.bytes (by simp)
    simp only [this, ↓reduceIte]
  case havoc => exact fun v => ⟨h v, .refl _ _⟩
  case guard => exact ⟨h.1, h.2, .refl _ _⟩
  case out => exact ⟨h.1, h.2, .refl _ _⟩
  all_goals exact ⟨h, fun _ _ => rfl⟩

/-- A list of operations changes no byte of memory outside its `write` labels. -/
theorem wpOpsL_kept {ops : List Op} {ρ : Env} {σ : State} {t : Trace}
    {Q : Env → State → Trace → Prop} (h : wpOpsL ops ρ σ t Q) :
    wpOpsL ops ρ σ t fun ρ' σ' t' =>
      Q ρ' σ' t' ∧ ∃ u, t' = t ++ u ∧ MemKept σ σ' u := by
  induction ops generalizing ρ σ t with
  | nil => exact ⟨h, [], by simp, .refl _ _⟩
  | cons op ops ih =>
    simp only [wpOpsL, Op.wpL] at h ⊢
    refine Op.wp_mono (Op.wp_kept h) ?_
    rintro ρ₁ σ₁ ⟨h₁, k₁⟩
    refine wpOpsL_mono (ih h₁) ?_
    rintro ρ₂ σ₂ t₂ ⟨hq, u, rfl, k₂⟩
    exact ⟨hq, op.leak ρ σ ++ u, by simp, k₁.trans k₂⟩

/-- A terminator changes no memory. -/
theorem Term.wp_kept {tm : Term} {ρ : Env} {σ : State} {Q : State → Prop} (h : tm.wp ρ σ Q) :
    tm.wp ρ σ fun σ' => Q σ' ∧ σ'.mem = σ.mem := by
  cases tm <;> simp only [Term.wp] at h ⊢ <;> exact ⟨h, rfl⟩

/-- **A block changes no byte of memory outside its `write` labels.** -/
theorem Block.wpL_kept {b : Block} {σ : State} {t : Trace} {Q : State → Trace → Prop}
    (h : b.wpL σ t Q) :
    b.wpL σ t fun σ' t' => Q σ' t' ∧ ∃ u, t' = t ++ u ∧ MemKept σ σ' u := by
  refine wpOpsL_mono (wpOpsL_kept h) ?_
  rintro ρ σ₁ t₁ ⟨hq, u, rfl, k⟩
  simp only [Term.wpL] at hq ⊢
  refine Term.wp_mono (Term.wp_kept hq) ?_
  rintro σ₂ ⟨hq₂, e⟩
  exact ⟨hq₂, u ++ b.term.leak ρ, by simp, fun a ha =>
    (congrFun e a).trans (k a fun b n hm => ha b n (List.mem_append_left _ hm))⟩

/-- The machine state `s'` has, at every byte `s` may load outside the stores among the
labels `u`, a byte it may load, with the same value. -/
def Kept (s s' : Arm64.State) (u : Trace) : Prop :=
  ∀ a, readable s.mem a = true → (∀ b n, Label.write b n ∈ u → ¬ (a - b).toNat < n) →
    readable s'.mem a = true ∧ s'.mem.read8 a = s.mem.read8 a

theorem kept_of_rel {s' : Arm64.State} {σ' : State} {u : Trace} (h : Rel s σ)
    (h' : Rel s' σ') (k : MemKept σ σ' u) : Kept s s' u := by
  intro a hr ha
  have e := k a ha
  rw [h.mem, h'.mem, hr] at e
  split at e
  · rename_i hr'
    simp only [↓reduceIte, Option.some.injEq, Cell.mk.injEq] at e
    exact ⟨hr', e.1⟩
  · cases e

/-! ## The block of `SVC #0` -/

/-- Bytes the dialect reads from memory are the bytes the machine reads, and it may read
them. -/
theorem bytes_eq_readBytes (h : Rel s σ) {a : Word} {n : Nat} {bs : List (BitVec 8)}
    (hb : σ.mem.bytes a n = some bs) :
    bs = s.mem.readBytes a n ∧ s.mem.canRead a n = true := by
  induction n generalizing a bs with
  | zero =>
    simp only [Mem.bytes, Option.some.injEq] at hb
    exact ⟨hb ▸ rfl, rfl⟩
  | succ n ih =>
    simp only [Mem.bytes] at hb
    split at hb
    · rename_i c bs' hc hbs
      cases hb
      obtain ⟨hr, rfl⟩ := h.cell hc
      obtain ⟨e, hcr⟩ := ih hbs
      exact ⟨by rw [e]; rfl, by rw [canRead_succ, hr]; exact hcr⟩
    · cases hb

/-- The machine's output is no part of the relation. -/
theorem Rel.appendTrace (h : Rel s σ) (evs : List Arm64.TraceEvent) :
    Rel (s.appendTrace evs) σ :=
  ⟨h.regs, h.sp, h.n, h.z, h.c, h.v, h.pc, h.status, h.mem, h.vlo, h.vhi⟩

theorem and4_of_ne {a b c d : Bool}
    (h : ¬ ofBool a &&& ofBool b &&& ofBool c &&& ofBool d = 0#64) :
    a = true ∧ b = true ∧ c = true ∧ d = true := by
  revert h
  cases a <;> cases b <;> cases c <;> cases d <;> decide

theorem end_le {b c : Word} (h1 : c.toNat ≤ 0x7ffff000)
    (h2 : b.ule (281474976710656#64 - c) = true) : b.toNat + c.toNat ≤ 2 ^ 48 := by
  have h3 : b ≤ 281474976710656#64 - c := BitVec.ule_iff_le.1 h2
  bv_omega

theorem readReg64_gpr (s : Arm64.State) {i : BitVec 5} (hi : i ≠ 31#5) :
    s.readReg64 (.gpr i) = s.regs.read i := by
  simp [Arm64.State.readReg64, hi]

/-- **The block of `SVC #0`, against the model.** If the block runs after the trace `t` and
establishes `R`, then either the call is the exit and `R` holds of the state as it is with
the exit event added to the trace, or it is the write `svcLeak` speaks of: the machine takes
its step into a related state with the same memory, of which `R` holds with the labels of
the call added. -/
theorem svc_sound {prog : Arm64.Program} {t : Trace} {R : State → Trace → Prop}
    (hsvc : prog.svc = Arm64.Syscall.standard) (h : Rel s σ) (hw : (svc s.pc).wpL σ t R) :
    (s.readReg64 .x8 = 93#64 ∧ R σ (t ++ [.event (.exit (s.readReg64 .x0))])) ∨
    ∃ ls σ₁, svcLeak s = some ls ∧ Rel (prog.evalInst (.system false 0#16) s) σ₁ ∧
      (prog.evalInst (.system false 0#16) s).mem = s.mem ∧ R σ₁ (t ++ ls) := by
  have reg : ∀ i : BitVec 5, i ≠ 31#5 → σ.regs i.toNat = s.readReg64 (.gpr i) := by
    intro i hi
    rw [readReg64_gpr s hi]; exact h.regs i hi
  have r8 : σ.regs 8 = s.readReg64 .x8 := reg 8#5 (by decide)
  have r0 : σ.regs 0 = s.readReg64 .x0 := reg 0#5 (by decide)
  have r1 : σ.regs 1 = s.readReg64 .x1 := reg 1#5 (by decide)
  have r2 : σ.regs 2 = s.readReg64 .x2 := reg 2#5 (by decide)
  simp [svc, Block.wpL, wpOpsL, Op.wpL, Op.wp, Term.wpL, Term.wp, Op.leak, Term.leak,
    BinOp.leaks, Env.set, r8, r0, r1, r2] at hw
  obtain ⟨h64, hcond, ⟨bs, hbs⟩, hr⟩ := hw
  by_cases h93 : s.readReg64 .x8 = 93#64
  · left
    have e : (σ.setReg 0 (s.readReg64 .x0)).setPc s.pc = σ := by
      rw [← r0, setReg_self, ← h.pc]; rfl
    refine ⟨h93, ?_⟩
    simpa [h93, e] using hr
  · right
    have h8 := h64 h93
    obtain ⟨c0, c2, cmax, cva⟩ := and4_of_ne (hcond h93)
    simp only [h8, ↓reduceIte] at hbs hr
    obtain ⟨e, hcr⟩ := bytes_eq_readBytes h hbs
    have h0 : s.readReg32 .x0 = 1#32 := by
      simp only [Arm64.State.readReg32]
      generalize s.readReg64 .x0 = x at c0
      bv_auto
    have h2 : s.readReg64 .x2 ≠ 0#64 := by simpa using c2
    have hmax : (s.readReg64 .x2).toNat ≤ Arm64.MAX_RW_COUNT := by
      have := BitVec.ule_iff_toNat_le.1 cmax
      simpa [Arm64.MAX_RW_COUNT] using this
    have hva : (s.readReg64 .x1).toNat + (s.readReg64 .x2).toNat ≤ Arm64.USER_VA_LIMIT := by
      exact end_le hmax cva
    refine ⟨[.event (.write (s.mem.readBytes (s.readReg64 .x1) (s.readReg64 .x2).toNat))],
      (σ.setReg 0 (s.readReg64 .x2)).setPc (s.pc + 4#64), ?_, ?_, ?_, ?_⟩
    · simp [svcLeak, h8, h0, h2, hmax, hva, hcr]
    · rw [evalInst_write hsvc h8 h0 h2 hmax hva hcr]
      exact ((h.appendTrace _).writeGpr (i := 0#5) (by decide) (s.readReg64 .x2)).advancePC
    · rw [evalInst_write hsvc h8 h0 h2 hmax hva hcr]
      rfl
    · simpa [h2, hbs, e] using hr

/-! ## Runs -/

/-- A run of the machine with its trace, as `RunL`, each step of which keeps the bytes the
machine may load, outside the stores among the step's labels. -/
inductive RunS (prog : Arm64.Program) : Arm64.State → Trace → Arm64.State → Prop where
  | refl (s : Arm64.State) : RunS prog s [] s
  | step {s s' : Arm64.State} {i : Instr} {ls tr : Trace} :
      s.status = .Running → prog.fetchMem s.mem s.pc = some i → leak s i = some ls →
      Kept s (prog.evalInst i s) ls →
      RunS prog (prog.evalInst i s) tr s' → RunS prog s (ls ++ tr) s'
  | svc {s s' : Arm64.State} {ls tr : Trace} :
      s.status = .Running → prog.fetchMem s.mem s.pc = some (.system false 0#16) →
      prog.svc = Arm64.Syscall.standard → svcLeak s = some ls →
      Kept s (prog.evalInst (.system false 0#16) s) ls →
      RunS prog (prog.evalInst (.system false 0#16) s) tr s' → RunS prog s (ls ++ tr) s'
  | exited {s s' : Arm64.State} {c : Word} {tr : Trace} :
      s.status = .Exited c → RunS prog s tr s' → RunS prog s (.event (.exit c) :: tr) s'

/-- Such a run is a run with its trace. -/
theorem RunS.runL {prog : Arm64.Program} {s s' : Arm64.State} {tr : Trace}
    (h : RunS prog s tr s') : RunL prog s tr s' := by
  induction h with
  | refl s => exact .refl s
  | step hs hf hl _ _ ih => exact .step hs hf hl ih
  | svc hs hf hv hl _ _ ih => exact .svc hs hf hv hl ih
  | exited hs _ ih => exact .exited hs ih

/-- The machine state `s` and the `braid` state `σ` describe the same machine, which runs or
has exited: they are related by `Rel`, or `s` is a state related to `σ` but for its status,
which is `Exited` with the code in `x0`. -/
def RelE (s : Arm64.State) (σ : State) : Prop :=
  Rel s σ ∨ ∃ s₀, Rel s₀ σ ∧ s = s₀.setStatus (.Exited (s₀.readReg64 .x0))

/-- The machine fetches from the memory `m` the instructions of `code`, at their
addresses. -/
def Fetches (prog : Arm64.Program) (code : Word → Option Instr) (m : Arm64.Memory) : Prop :=
  ∀ a i, code a = some i → prog.fetchMem m a = some i

/-- An instruction that is fetched is still fetched from a memory that keeps the bytes that
may not be stored to: it is fetched from executable bytes, and no store reaches them. -/
theorem fetchMem_of_keepsCode {prog : Arm64.Program} {m m' : Arm64.Memory} {pc : Word}
    {i : Instr} (hk : KeepsCode m m') (hf : prog.fetchMem m pc = some i) :
    prog.fetchMem m' pc = some i := by
  simp only [Arm64.Program.fetchMem] at hf ⊢
  split at hf
  · cases hf
  split at hf
  · cases hf
  split at hf
  · cases hf
  rename_i hext hal hx
  have e2 : pc + 1#64 + 1#64 = pc + 2#64 := by bv_omega
  have e3 : pc + 2#64 + 1#64 = pc + 3#64 := by bv_omega
  simp only [Arm64.Memory.canExec, Arm64.Memory.allPerm, Bool.and_true, e2, e3,
    Bool.not_eq_true, Bool.not_eq_false', Bool.and_eq_true] at hx
  obtain ⟨x0, x1, x2, x3⟩ := hx
  have key : ∀ a, (m.perm a).x = true → m'.read8 a = m.read8 a ∧ m'.perm a = m.perm a :=
    fun a ha => let ⟨r, p, _⟩ := hk a (by simp [writable, ha]); ⟨r, p⟩
  have e0 : pc + 0#64 = pc := by simp
  simp only [Arm64.Memory.read32, e0] at hf
  simp only [hext, hal, Arm64.Memory.canExec, Arm64.Memory.allPerm, Arm64.Memory.read32, e0, e2,
    e3, (key _ x0).1, (key _ x1).1, (key _ x2).1, (key _ x3).1, (key _ x0).2, (key _ x1).2,
    (key _ x2).2, (key _ x3).2, x0, x1, x2, x3, hf, Bool.and_self, Bool.not_true,
    Bool.false_eq_true, ↓reduceIte]

theorem Fetches.of_keepsCode {prog : Arm64.Program} {code : Word → Option Instr}
    {m m' : Arm64.Memory} (h : Fetches prog code m) (hk : KeepsCode m m') :
    Fetches prog code m' :=
  fun a i hi => fetchMem_of_keepsCode hk (h a i hi)

/-- A machine that has exited stays where it is: from the state of the exit call, every
labelled run of the lowered code records only exits, which the machine records too. -/
theorem exited_soundS {prog : Arm64.Program} {code : Word → Option Instr}
    {Q : State → Trace → Prop} {t : Trace} (hsvc : prog.svc = Arm64.Syscall.standard)
    (h : Rel s σ) (hf : code s.pc = some (.system false 0#16))
    (h8 : s.readReg64 .x8 = 93#64) (hw : EventuallyL (lowerCodeEnv code) Q σ t) :
    ∃ tr, RunS prog (s.setStatus (.Exited (s.readReg64 .x0))) tr
      (s.setStatus (.Exited (s.readReg64 .x0))) ∧ Q σ (t ++ tr) := by
  induction hw with
  | done σ t hq => exact ⟨[], .refl _, by simpa using hq⟩
  | step σ t R hs _ ih =>
    obtain ⟨b, hb, hwp⟩ := hs
    rw [h.pc] at hb
    simp only [lowerCodeEnv, hf, Option.map_some, Option.some.injEq] at hb
    subst hb
    simp only [lowerEnv, ↓reduceIte] at hwp
    rcases svc_sound hsvc h hwp with ⟨_, hr⟩ | ⟨ls, σ₁, _, h₁, _, _⟩
    · obtain ⟨tr, hrun, hq⟩ := ih σ _ hr h
      exact ⟨_ :: tr, .exited rfl hrun, by simpa using hq⟩
    · rw [evalInst_exit hsvc h8] at h₁
      cases h₁.status

/-- **The AArch64 lowering with its environment preserves traces.** Let `prog` be a program
whose supervisor calls are the model's Linux system calls, and let the machine fetch the
instructions of `code` from its memory. If every labelled run of the lowered code reaches
`Q`, the machine runs, with some trace, to a state and that trace added to the one it
started after, of which `Q` holds; the state is running, or it has exited. Each step of the
run keeps the bytes the machine may load, outside its stores. -/
theorem lowerCodeEnv_soundS {prog : Arm64.Program} {code : Word → Option Instr}
    {Q : State → Trace → Prop} {t : Trace} (hsvc : prog.svc = Arm64.Syscall.standard)
    (hc : Fetches prog code s.mem) (h : Rel s σ) (hw : EventuallyL (lowerCodeEnv code) Q σ t) :
    ∃ s' σ' tr, RunS prog s tr s' ∧ RelE s' σ' ∧ Q σ' (t ++ tr) := by
  induction hw generalizing s with
  | done σ t hq => exact ⟨s, σ, [], .refl s, .inl h, by simpa using hq⟩
  | step σ t R hs hnext ih =>
    obtain ⟨b, hb, hwp⟩ := hs
    simp only [lowerCodeEnv, Option.map_eq_some_iff] at hb
    obtain ⟨i, hi, rfl⟩ := hb
    rw [h.pc] at hi hwp
    by_cases hsys : i = .system false 0#16
    · subst hsys
      simp only [lowerEnv, ↓reduceIte] at hwp
      rcases svc_sound hsvc h hwp with ⟨h93, hr⟩ | ⟨ls, σ₁, hl, h₁, hm, hr⟩
      · obtain ⟨tr, hrun, hq⟩ := exited_soundS hsvc h hi h93 (hnext σ _ hr)
        have he := evalInst_exit hsvc h93
        have hrun' : RunS prog (prog.evalInst (.system false 0#16) s)
            (.event (.exit (s.readReg64 .x0)) :: tr) (prog.evalInst (.system false 0#16) s) := by
          rw [he]
          exact .exited rfl hrun
        refine ⟨_, σ, [] ++ .event (.exit (s.readReg64 .x0)) :: tr,
          .svc h.status (hc _ _ hi) hsvc (by simp [svcLeak, h93]) ?_ hrun', .inr ⟨s, h, he⟩,
          by simpa using hq⟩
        rw [he]
        exact fun a hr _ => ⟨hr, rfl⟩
      · obtain ⟨s', σ', tr, hrun, h', hq⟩ := ih σ₁ _ hr (by rw [hm]; exact hc) h₁
        refine ⟨s', σ', ls ++ tr, .svc h.status (hc _ _ hi) hsvc hl ?_ hrun, h',
          by rw [← List.append_assoc]; exact hq⟩
        intro a hr _
        rw [hm]
        exact ⟨hr, rfl⟩
    · simp only [lowerEnv, hsys, ↓reduceIte] at hwp
      obtain ⟨σ₁, h₁, ⟨hv, hr, u, hu, hk⟩, hkc⟩ :=
        lower_step prog h (Block.wp_of_wpL (Block.wpL_kept hwp))
      obtain rfl := List.append_cancel_left hu
      obtain ⟨s', σ', tr, hrun, h', hq⟩ := ih σ₁ _ hr (hc.of_keepsCode hkc) h₁
      exact ⟨s', σ', _, .step h.status (hc _ _ hi)
        (leak_lower h i hv (Block.wp_of_wpL hwp)) (kept_of_rel h h₁ hk) hrun, h',
        by rw [← List.append_assoc]; exact hq⟩

/-- **The AArch64 lowering with its environment preserves traces**, as a run with its
trace. -/
theorem lowerCodeEnv_soundL {prog : Arm64.Program} {code : Word → Option Instr}
    {Q : State → Trace → Prop} {t : Trace} (hsvc : prog.svc = Arm64.Syscall.standard)
    (hc : Fetches prog code s.mem) (h : Rel s σ) (hw : EventuallyL (lowerCodeEnv code) Q σ t) :
    ∃ s' σ' tr, RunL prog s tr s' ∧ RelE s' σ' ∧ Q σ' (t ++ tr) :=
  let ⟨s', σ', tr, hrun, h', hq⟩ := lowerCodeEnv_soundS hsvc hc h hw
  ⟨s', σ', tr, hrun.runL, h', hq⟩

end Lowering.Arm
