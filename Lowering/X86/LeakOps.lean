/-
  Lowering.X86.LeakOps

  The labels of a lowered integer instruction of x86-64 are the labels of the instruction
  (`Lowering.X86.Leak`), whatever values the `havoc`s of its block take.

  The labels of a block are those of its pieces in order. A piece that reads or writes an
  operand emits the label of the operand, from any state with the machine's registers
  (`Emits`); every other piece emits nothing (`isQuiet`, `isSilent`). An instruction that goes
  on to the next is those lemmas in order (`x86_leak`). The instructions that jump, and
  `pop`, which moves the stack pointer before it writes, are evaluated one by one.

  Nothing here redoes the proof that the lowering is sound: the labels of a block are a
  function of the state it starts from (`Braid.Block.leak`), and that function is compared
  with the labels of the instruction.

  ## Main definitions

  * `Emits`, `EmitsT`: the labels of a list of operations, from the registers of the machine
  * `OpLeak`: the labels of a lowered instruction are those of the instruction

  ## Main results

  * `addrOps_env`, `ccOps_env`, `load_getD`: an address, a condition and a loaded word, as
    the block computes them and as the model does
  * `leakOp_lower`: every integer instruction
-/

module

public import Lowering.X86.Sound
public import Lowering.X86.Leak
import all Kraken.Mem

@[expose] public section

namespace Lowering.X86

open Braid (Word Var Op Term Block BinOp UnOp Env State Trace runOps runOps_cons runOps_append
  runOps_nil ofBool wpOps)

/-! ## Operations that emit nothing -/

/-- The state has the general registers `regs`. -/
def RegsRel (regs : Reg64s) (σ : State) : Prop := ∀ r, σ.regs (regNum r) = regs.get64 r

theorem RelD.regsRel {s : MachineData} {σ : State} (h : RelD s σ) : RegsRel s.regs σ := h.regs

theorem RegsRel.set64 {regs : Reg64s} {σ : State} (h : RegsRel regs σ) (r : Reg64) (v : Word) :
    RegsRel (regs.set64 r v) (σ.setReg (regNum r) v) := fun r' => by
  simp only [State.setReg, get64_set64]
  by_cases hr : r' = r
  · subst hr; simp
  · have : regNum r' ≠ regNum r := fun e => hr (regNum_inj e)
    simp [hr, this, h r']

/-- Setting a register that is not a general register keeps the general registers. -/
theorem RegsRel.setReg {regs : Reg64s} {σ : State} (h : RegsRel regs σ) {r : Braid.Reg}
    (hr : 16 ≤ r) (v : Word) : RegsRel regs (σ.setReg r v) := fun r' => by
  have hlt := regNum_lt r'
  have hne : regNum r' ≠ r := Nat.ne_of_lt (Nat.lt_of_lt_of_le hlt hr)
  simp [State.setReg, hne, h r']

/-- The operation emits no label and leaves memory and the general registers as they
were. -/
def isQuiet : Op → Bool
  | .bin _ op _ _ => !op.leaks
  | .load .. | .store .. | .out .. => false
  | .set r _ => decide (16 ≤ r)
  | _ => true

/-- The operation emits no label. -/
def isSilent : Op → Bool
  | .bin _ op _ _ => !op.leaks
  | .load .. | .store .. | .out .. => false
  | _ => true

/-- The operation cannot fault and takes no value from outside. -/
def isPure : Op → Bool
  | .load .. | .store .. | .out .. | .havoc _ | .guard _ => false
  | _ => true

theorem silent_of_quiet {op : Op} (h : isQuiet op = true) : isSilent op = true := by
  cases op <;> first | exact h | rfl

theorem all_silent_of_quiet {ops : List Op} (h : ops.all isQuiet = true) :
    ops.all isSilent = true := by
  rw [List.all_eq_true] at h ⊢
  exact fun op hop => silent_of_quiet (h op hop)

theorem leak_of_silent {op : Op} (h : isSilent op = true) (ρ : Env) (σ : State) :
    op.leak ρ σ = [] := by
  cases op <;> simp_all [isSilent, Op.leak]

theorem next_of_quiet {op : Op} (h : isQuiet op = true) (ρ : Env) (σ : State) (x : Word) :
    (op.next ρ σ x).2.mem = σ.mem ∧
      ∀ regs, RegsRel regs σ → RegsRel regs (op.next ρ σ x).2 := by
  cases op <;> first | exact ⟨rfl, fun _ hr => hr⟩ | cases h | skip
  case set r a =>
    exact ⟨rfl, fun _ hr => hr.setReg (by simpa [isQuiet] using h) _⟩

theorem runOps_silent {ops : List Op} (h : ops.all isSilent = true) (ρ : Env) (σ : State)
    (hv : Nat → Word) : (runOps ops ρ σ hv).2.2 = [] := by
  induction ops generalizing ρ σ hv with
  | nil => rfl
  | cons op ops ih =>
    simp only [List.all_cons, Bool.and_eq_true] at h
    rw [runOps_cons, leak_of_silent h.1, ih h.2]
    rfl

theorem runOps_quiet {ops : List Op} (h : ops.all isQuiet = true) (ρ : Env) (σ : State)
    (hv : Nat → Word) :
    (runOps ops ρ σ hv).2.1.mem = σ.mem ∧
      ∀ regs, RegsRel regs σ → RegsRel regs (runOps ops ρ σ hv).2.1 := by
  induction ops generalizing ρ σ hv with
  | nil => exact ⟨rfl, fun _ hr => hr⟩
  | cons op ops ih =>
    simp only [List.all_cons, Bool.and_eq_true] at h
    rw [runOps_cons]
    obtain ⟨h1, h2⟩ := next_of_quiet h.1 ρ σ (hv 0)
    obtain ⟨h3, h4⟩ := ih h.2 (op.next ρ σ (hv 0)).1 (op.next ρ σ (hv 0)).2 fun i => hv (i + 1)
    exact ⟨h3.trans h1, fun regs hr => h4 regs (h2 regs hr)⟩

/-- Pure operations run, to the values and the state `runOps` computes. -/
theorem wpOps_of_pure {ops : List Op} (h : ops.all isPure = true) {ρ : Env} {σ : State}
    (hv : Nat → Word) {Q : Env → State → Prop}
    (hq : Q (runOps ops ρ σ hv).1 (runOps ops ρ σ hv).2.1) : wpOps ops ρ σ Q := by
  induction ops generalizing ρ σ hv with
  | nil => exact hq
  | cons op ops ih =>
    simp only [List.all_cons, Bool.and_eq_true] at h
    rw [runOps_cons] at hq
    cases op <;> first | exact ih h.2 _ hq | exact absurd h.1 (by simp [isPure])

/-! ## Labels from the registers of the machine -/

/-- From any state with the registers `regs`, the operations emit the labels `ls` and leave
the registers as they were. -/
structure Emits (ops : List Op) (regs : Reg64s) (ls : Trace) : Prop where
  run : ∀ (ρ : Env) (σ : State) (hv : Nat → Word), RegsRel regs σ →
    (runOps ops ρ σ hv).2.2 = ls ∧ RegsRel regs (runOps ops ρ σ hv).2.1

/-- From any state with the registers `regs`, the operations emit the labels `ls`. -/
structure EmitsT (ops : List Op) (regs : Reg64s) (ls : Trace) : Prop where
  run : ∀ (ρ : Env) (σ : State) (hv : Nat → Word), RegsRel regs σ →
    (runOps ops ρ σ hv).2.2 = ls

variable {regs : Reg64s} {ops ops₁ ops₂ : List Op} {ls ls₁ ls₂ : Trace}

theorem Emits.toT (h : Emits ops regs ls) : EmitsT ops regs ls :=
  ⟨fun ρ σ hv hr => (h.run ρ σ hv hr).1⟩

theorem Emits.quiet (h : ops.all isQuiet = true) : Emits ops regs [] :=
  ⟨fun ρ σ hv hr => ⟨runOps_silent (all_silent_of_quiet h) ρ σ hv,
    (runOps_quiet h ρ σ hv).2 regs hr⟩⟩

theorem EmitsT.silent (h : ops.all isSilent = true) : EmitsT ops regs [] :=
  ⟨fun ρ σ hv _ => runOps_silent h ρ σ hv⟩

theorem Emits.append (h₁ : Emits ops₁ regs ls₁) (h₂ : Emits ops₂ regs ls₂) :
    Emits (ops₁ ++ ops₂) regs (ls₁ ++ ls₂) := ⟨fun ρ σ hv hr => by
  obtain ⟨e₁, hr₁⟩ := h₁.run ρ σ hv hr
  obtain ⟨e₂, hr₂⟩ := h₂.run (runOps ops₁ ρ σ hv).1 _ (fun i => hv (i + ops₁.length)) hr₁
  rw [runOps_append]
  exact ⟨by rw [e₁, e₂], hr₂⟩⟩

theorem Emits.appendT (h₁ : Emits ops₁ regs ls₁) (h₂ : EmitsT ops₂ regs ls₂) :
    EmitsT (ops₁ ++ ops₂) regs (ls₁ ++ ls₂) := ⟨fun ρ σ hv hr => by
  obtain ⟨e₁, hr₁⟩ := h₁.run ρ σ hv hr
  have e₂ := h₂.run (runOps ops₁ ρ σ hv).1 _ (fun i => hv (i + ops₁.length)) hr₁
  rw [runOps_append, e₁, e₂]⟩

theorem EmitsT.append_silent (h₁ : EmitsT ops₁ regs ls) (h₂ : ops₂.all isSilent = true) :
    EmitsT (ops₁ ++ ops₂) regs ls := ⟨fun ρ σ hv hr => by
  rw [runOps_append]
  simp only [h₁.run ρ σ hv hr, runOps_silent h₂, List.append_nil]⟩

/-! ## Registers, conditions, addresses and operands -/

theorem readReg_quiet (n : Var) {w : Width} (r : Reg w) : (readReg n r).all isQuiet = true := by
  unfold readReg
  split
  · cases w <;> rfl
  · rfl

theorem writeReg_silent (n : Var) {w : Width} (r : Reg w) (v : Var) :
    (writeReg n r v).all isSilent = true := by
  unfold writeReg
  split
  · cases w <;> rfl
  · rfl

theorem ccOps_quiet (n : Var) (cc : CondCode) : (ccOps n cc).all isQuiet = true := by
  cases cc <;> rfl

theorem ccOps_pure (n : Var) (cc : CondCode) : (ccOps n cc).all isPure = true := by
  cases cc <;> rfl

/-- The value the operations of a condition code compute is the model's. -/
theorem ccOps_env {s : MachineData} {σ : State} (h : RelD s σ) (n : Nat) (cc : CondCode)
    (ρ : Env) (hv : Nat → Word) :
    (runOps (ccOps n cc) ρ σ hv).1 n = ofBool (cc.interp s.status) := by
  obtain ⟨ρ', _, hval, e⟩ := wp_cc (Q := fun ρ' _ => ρ' = (runOps (ccOps n cc) ρ σ hv).1) h
    (wpOps_of_pure (ccOps_pure n cc) hv rfl)
  rw [← e]
  exact hval

/-- The word a `braid` load of eight bytes gives, or `0` if it faults, is the word the
model loads. -/
theorem load_getD {s : MachineData} {σ : State} (h : RelD s σ) (a : Word) :
    (σ.mem.load a .w64).getD 0#64 = wordAt s a := by
  have hsome : ∀ {n : Nat} {a : Word} {bs : List UInt8}, Mem.loadBytes s.dmem a n = some bs →
      ((memOf s.dmem).loadN a n).isSome := by
    intro n
    induction n with
    | zero => intros; rfl
    | succ n ih =>
      intro a bs hb
      rw [loadBytes_succ] at hb
      cases hm : s.dmem[a]? with
      | none => simp [hm] at hb
      | some b =>
        simp only [hm, Option.bind_some, Option.map_eq_some_iff] at hb
        obtain ⟨bs', hbs', _⟩ := hb
        obtain ⟨r, hr⟩ := Option.isSome_iff_exists.1 (ih hbs')
        have hr' : (memOf s.dmem).loadN (a + 1#64) n = some r := hr
        simp [Braid.Mem.loadN, memOf, hm, hr']
  rw [h.mem, Braid.Mem.load]
  cases hl : (memOf s.dmem).loadN a Braid.Width.w64.bytes with
  | some v =>
    obtain ⟨hi, _⟩ := loadInt_of_loadN (by decide) hl
    have hi' : Mem.loadInt s.dmem a 8 = some (v.toNat : Int) := hi
    simp [wordAt, hi']
  | none =>
    have hb : Mem.loadBytes s.dmem a 8 = none := by
      cases hb : Mem.loadBytes s.dmem a 8 with
      | none => rfl
      | some bs =>
        have := hsome hb
        have hl' : (memOf s.dmem).loadN a 8 = none := hl
        simp [hl'] at this
    simp [wordAt, Mem.loadInt, hb]

section
variable [Labels] {p : Std.Rco Int64}

theorem addrOps_quiet (n : Var) (a : AddrExpr) : (addrOps p n a).all isQuiet = true := by
  obtain ⟨base, idx, disp⟩ := a
  rcases base with _ | r | _ <;> rcases idx with _ | ⟨ir, ic⟩ <;> simp only [addrOps, baseOps]
  case some.reg.none => split <;> rfl
  all_goals rfl

/-- The address the operations of a memory operand compute is the model's. -/
theorem addrOps_env {σ : State} (hr : RegsRel regs σ) (n : Nat) (a : AddrExpr) (ρ : Env)
    (hv : Nat → Word) : (runOps (addrOps p n a) ρ σ hv).1 n = ea p regs a := by
  have e : ea p regs a = addrVal p a { regs := regs } := rfl
  rw [e, addrVal_eq]
  obtain ⟨base, idx, disp⟩ := a
  rcases base with _ | r | _ <;> rcases idx with _ | ⟨ir, ic⟩ <;> simp only [addrOps, baseOps]
  case some.reg.none =>
    split
    · rename_i hd
      subst hd
      simp [runOps_cons, hr r, ConstExpr.interp]
    · simp [runOps_cons, hr r]
  all_goals simp [runOps_cons, hr _]

omit [Labels] in
theorem bw_bytes (w : Width) : (bw w).bytes = w.bytes := by cases w <;> rfl

theorem readRM_emits (n : Var) {w : Width} (o : RegOrMem w) :
    Emits (readRM p n o) regs (rmRead p regs o) := by
  cases o with
  | reg r => exact Emits.quiet (readReg_quiet n r)
  | mem a =>
    refine ⟨fun ρ σ hv hr => ?_⟩
    have hq := addrOps_quiet (p := p) (n + 1) a
    simp only [readRM, rmRead, runOps_append, runOps_cons, runOps_nil, Op.leak_load,
      runOps_silent (all_silent_of_quiet hq), addrOps_env hr, bw_bytes, List.nil_append,
      List.append_nil, Op.next_load, true_and]
    exact (runOps_quiet hq ρ σ hv).2 regs hr

theorem readOp_emits (n : Var) {w : Width} (o : Operand w) :
    Emits (readOp p n o) regs (opRead p regs o) := by
  cases o with
  | regOrMem o => exact readRM_emits n o
  | imm c => exact Emits.quiet (by rfl)

theorem writeRM_emits (n : Var) {w : Width} (d : RegOrMem w) (v : Var) :
    EmitsT (writeRM p n d v) regs (rmWrite p regs d) := by
  cases d with
  | reg r => exact EmitsT.silent (writeReg_silent n r v)
  | mem a =>
    refine ⟨fun ρ σ hv hr => ?_⟩
    have hq := addrOps_quiet (p := p) n a
    simp only [writeRM, rmWrite, runOps_append, runOps_cons, runOps_nil, Op.leak_store,
      runOps_silent (all_silent_of_quiet hq), addrOps_env hr, bw_bytes, List.nil_append,
      List.append_nil]

omit [Labels] in
/-- The stack pointer moves down and the operand is stored where it points. -/
theorem push_emits (w : Width) (v : Var) :
    EmitsT [.get 8 (regNum .rsp), .const 9 (BitVec.ofNat 64 w.bytes), .bin 10 .sub 8 9,
      .set (regNum .rsp) 10, .store (bw w) 10 v] regs
      [.write (regs.get64 .rsp - w.bytesv) w.bytes] := by
  refine ⟨fun ρ σ hv hr => ?_⟩
  simp [runOps_cons, hr .rsp, bw_bytes, BinOp.leaks]

omit [Labels] in
/-- A word is loaded from where the stack pointer points, and the stack pointer moves up. -/
theorem pop_emits (w : Width) :
    ∀ (ρ : Env) (σ : State) (hv : Nat → Word), RegsRel regs σ →
      let r := runOps [.get 0 (regNum .rsp), .load 1 (bw w) 0,
        .const 2 (BitVec.ofNat 64 w.bytes), .bin 3 .add 0 2, .set (regNum .rsp) 3] ρ σ hv
      r.2.2 = [.read (regs.get64 .rsp) w.bytes] ∧
        RegsRel (regs.set64 .rsp (regs.get64 .rsp + w.bytesv)) r.2.1 := by
  intro ρ σ hv hr
  refine ⟨by simp [runOps_cons, hr .rsp, bw_bytes, BinOp.leaks], ?_⟩
  have e := hr.set64 .rsp (regs.get64 .rsp + w.bytesv)
  simpa [runOps_cons, hr .rsp] using e

/-- Find the labels of a list of operations that is the pieces of a lowered instruction. -/
macro "x86_emits" : tactic => `(tactic|
  repeat' first
    | apply Emits.append
    | apply EmitsT.append_silent (h₂ := by rfl)
    | apply EmitsT.append_silent (h₂ := writeReg_silent _ _ _)
    | apply Emits.appendT
    | exact Emits.quiet (by rfl)
    | exact readRM_emits _ _
    | exact readOp_emits _ _
    | exact Emits.quiet (readReg_quiet _ _)
    | exact Emits.quiet (ccOps_quiet _ _)
    | exact Emits.quiet (addrOps_quiet _ _)
    | exact EmitsT.silent (by rfl)
    | exact EmitsT.silent (writeReg_silent _ _ _)
    | exact writeRM_emits _ _ _
    | exact push_emits _ _
    | apply Emits.toT)

/-! ## Instructions -/

omit [Labels] in
/-- The labels of a block that ends in a direct jump are those of its operations. -/
theorem leak_jump {σ : State} {tr : Trace} {a : Word} {hv : Nat → Word}
    (hr : RegsRel regs σ) (he : EmitsT ops regs ls) (e : tr = ls) :
    some tr = some (Block.leak ⟨ops, .jump a⟩ σ hv) := by
  simp [Block.leak, he.run _ σ hv hr, e]

/-- The labels of the lowered instruction `i` are those of `i`, whatever values the `havoc`s
of its block take. -/
def OpLeak (p : Std.Rco Int64) {w : Width} (i : Operation w) : Prop :=
  ∀ {s : MachineData} {σ : State} {ops : List Op} {t : Term} (hv : Nat → Word),
    RelD s σ → lowerOp p i = some (ops, t) → leakOp p s i = some (Block.leak ⟨ops, t⟩ σ hv)

/-- Prove `OpLeak` of an instruction whose block is pieces in a row and a direct jump, or
which is not lowered. -/
macro "x86_leak" h:ident hl:ident : tactic => `(tactic|
  (simp only [lowerOp, cut] at $hl:ident
   repeat' split at $hl:ident
   all_goals cases $hl:ident
   all_goals
     simp only [leakOp]
     apply leak_jump (RelD.regsRel $h)
     case he => x86_emits
     case e =>
       first
         | rfl
         | simp only [List.append_nil, List.nil_append, List.append_assoc, Option.getD_some,
             Option.getD_none]))

theorem pop_leak {w : Width} (dst : Dst w) : OpLeak p (.pop dst : Operation w) := by
  intro s σ ops t hv h hl
  simp only [lowerOp] at hl
  cases hl
  obtain ⟨e, hr⟩ := pop_emits w (fun _ => 0#64) σ hv h.regsRel
  simp only [leakOp, Block.leak, Term.leak_jump, List.append_nil, runOps_append, e,
    (writeRM_emits 8 dst 1).run _ _ _ hr]

theorem jcc_leak {w : Width} (cc : CondCode) (l : Label) :
    OpLeak p (.jcc cc l : Operation w) := by
  intro s σ ops t hv h hl
  simp only [lowerOp] at hl
  cases hl
  simp only [leakOp, Block.leak, Term.leak_branch, ccOps_env h, List.nil_append,
    runOps_silent (all_silent_of_quiet (ccOps_quiet 0 cc))]
  cases cc.interp s.status <;> simp [ofBool]

theorem jmp_leak {w : Width} (tgt : RelRegOrMem) : OpLeak p (.jmp tgt : Operation w) := by
  intro s σ ops t hv h hl
  cases tgt with
  | rel c =>
    simp only [lowerOp] at hl
    cases hl
    rfl
  | reg r =>
    cases r with
    | low r w =>
      simp only [lowerOp] at hl
      cases hl
      simp [leakOp, targetRead, targetJump, Block.leak, readReg, Reg.offset, Reg.base,
        runOps_cons, h.regs, get_low64]
  | mem a =>
    simp only [lowerOp] at hl
    cases hl
    have hq := addrOps_quiet (p := p) 1 a
    have hm := (runOps_quiet hq (fun _ => 0#64) σ hv).1
    simp [leakOp, targetRead, targetJump, Block.leak, runOps_append, runOps_cons,
      runOps_silent (all_silent_of_quiet hq), addrOps_env h.regsRel, hm, load_getD h]

theorem call_leak {w : Width} (tgt : RelRegOrMem) : OpLeak p (.call tgt : Operation w) := by
  intro s σ ops t hv h hl
  cases tgt with
  | rel c =>
    simp only [lowerOp] at hl
    cases hl
    simp [leakOp, targetRead, targetJump, Block.leak, pushRet, runOps_cons, h.regs,
      BinOp.leaks]
  | reg r =>
    cases r with
    | low r w =>
      simp only [lowerOp] at hl
      cases hl
      simp [leakOp, targetRead, targetJump, Block.leak, pushRet, readReg, Reg.offset, Reg.base,
        runOps_cons, h.regs, get_low64, BinOp.leaks]
  | mem a =>
    simp only [lowerOp] at hl
    cases hl
    have hq := addrOps_quiet (p := p) 1 a
    obtain ⟨hm, hr⟩ := runOps_quiet hq (fun _ => 0#64) σ hv
    simp [leakOp, targetRead, targetJump, Block.leak, pushRet, runOps_append, runOps_cons,
      runOps_silent (all_silent_of_quiet hq), addrOps_env h.regsRel, hm, load_getD h,
      hr _ h.regsRel .rsp, BinOp.leaks]

theorem ret_leak {w : Width} : OpLeak p (.ret : Operation w) := by
  intro s σ ops t hv h hl
  simp only [lowerOp] at hl
  cases hl
  simp [leakOp, Block.leak, runOps_cons, h.regs, load_getD h, BinOp.leaks]

theorem mov_leak {w : Width} (dst : Dst w) (src : Operand w) :
    OpLeak p (.mov dst src : Operation w) := by
  intro s σ ops t hv h hl; x86_leak h hl

/-- **The labels of a lowered integer instruction are those of the instruction.** -/
theorem leakOp_lower {w : Width} (i : Operation w) : OpLeak p i := by
  cases i
  case pop dst => exact pop_leak dst
  case jcc cc l => exact jcc_leak cc l
  case jmp tgt => exact jmp_leak tgt
  case call tgt => exact call_leak tgt
  case ret => exact ret_leak
  case shl dst c => intro s σ ops t hv h hl; cases c <;> cases w <;> x86_leak h hl
  case shr dst c => intro s σ ops t hv h hl; cases c <;> cases w <;> x86_leak h hl
  case sar dst c => intro s σ ops t hv h hl; cases c <;> cases w <;> x86_leak h hl
  case shld dst src c => intro s σ ops t hv h hl; cases c <;> cases w <;> x86_leak h hl
  case shrd dst src c => intro s σ ops t hv h hl; cases c <;> cases w <;> x86_leak h hl
  case rol dst c => intro s σ ops t hv h hl; cases c <;> cases w <;> x86_leak h hl
  case ror dst c => intro s σ ops t hv h hl; cases c <;> cases w <;> x86_leak h hl
  all_goals intro s σ ops t hv h hl; cases w <;> x86_leak h hl

end

end Lowering.X86
