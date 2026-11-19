/-
  Lowering.Arm.Leak

  What an AArch64 instruction reveals, and the trace of a run of the machine. This is the
  leakage model of `docs/Leakage.md` read on the instructions of the trusted package of
  arm64-semantics: a load or a store reveals its address and its size, a conditional branch
  and a computed jump reveal where they go, and a division reveals its operands. Other
  integer arithmetic, logic, shifts, multiplications and conditional selects reveal nothing:
  with `PSTATE.DIT` set they take a time that does not depend on their operands.

  It also reads the two events of the environment off the model's supervisor call, `SVC #0`
  under the model's Linux system calls (`Arm64.Syscall.standard`): `write` to the standard
  output is the event of writing those bytes, and a machine whose status is `Exited` has
  exited with that code.

  This file is trusted: a theorem about what an AArch64 program leaks says so in these terms
  (`docs/Trust.md`). It is definitions only.

  ## What was chosen

  * **Instructions it does not speak of.** `leak` is `none` for an instruction this file gives
    no labels to, and a run with a trace (`RunL`) does not go through one. These are the
    instructions the lowering turns into a `trap`: floating-point arithmetic and conversions,
    the rest of SIMD, the cryptographic extensions, compare-and-swap, store-exclusive and
    load-exclusive pairs, the loads and stores of several vector registers or of one lane,
    `LDAPUR` and `STLUR`, the literal load of a vector register, `CRC32`, system registers,
    `DC ZVA`, and supervisor calls, breakpoints and undefined instructions. Some of them
    access memory or take a time that depends on their operands, so `[]` would be wrong.
  * **Addresses.** The address of an access is the one the model computes, the first
    component of `Arm64.evalAddrMode`: with pre-indexing the base plus the offset, which is
    also the new value of the base, and with post-indexing the base before it is updated.
    A literal load is at the program counter plus its offset.
  * **Pairs.** A pair is two accesses, each of the size of one register, at the address and at
    the address plus that size, in that order. It is the order of the model's two stores.
  * **Sixteen bytes.** A load or store of a whole vector register is two labels of eight
    bytes, at the address and at the address plus eight, in that order: a label of the
    dialect is one access of at most eight bytes. A pair of them is four labels.
  * **Atomics.** A read-modify-write is a read and then a write at the same address.
  * **Faults.** An instruction has its labels whether or not the model then faults on a
    permission or an alignment. The lowered code has no run through a fault.
  * **Division.** The operands are the registers at the width of the division, as 64-bit
    words: for a 32-bit division the low halves, zero-extended for `UDIV` and sign-extended
    for `SDIV`. Either extension determines the 32-bit operand and is determined by it.
  * **Branches.** A conditional branch reveals the address it goes to, taken or not. `B` and
    `BL` reveal nothing: where they go is in the code.
  * **Prefetch.** `PRFM` has no label. In the model it does nothing. A processor that acts on
    the hint touches its cache at the address, and a theorem here does not say so.
  * **Vector instructions that reveal nothing.** Moves between and within registers (`FMOV`
    that converts nothing, `DUP`, `INS`, `UMOV`, `SMOV`), constants (`MOVI` and the other
    modified immediates, `FMOV` of a constant), the bitwise operations, `ADD` and `SUB` of
    lanes, `ADDP` of the two halves, `CNT`, `NOT`, `RBIT`, and `FCSEL`. That these are
    data-independent is from the same reading of Arm's list as in `docs/Leakage.md`, and
    should be checked against it before it is relied on.
  * **Hooked functions.** A step of the model that is a call to a hooked function
    (`Arm64.Step.extern`) has no labels here, and `RunL` has no such step.
  * **Supervisor calls.** `leak` is `none` for `SVC`; `svcLeak` speaks of `SVC #0`, and only
    in a program whose handler is the model's `Arm64.Syscall.standard`, and only of two
    calls. With `x8 = 64` (`write`) it speaks of the case in which the model writes every
    byte asked for to the standard output: the descriptor in `w0` is 1, the count in `x2` is
    not zero and at most the model's bound on one transfer (`MAX_RW_COUNT`), the buffer at
    `x1` ends within the model's user address space (`USER_VA_LIMIT`), and the model may
    read all of it. The model then appends those bytes to its own trace of output, puts the
    count in `x0` and goes on (`Arm64.execWrite`), and the label is the event of writing
    them. With `x8 = 93` (`exit`) the model sets its status to `Exited` with the code in
    `x0` and does nothing else (`Arm64.execExit`); the step has no label.
  * **The exit.** A machine whose status is `Exited c` takes no step. A run that is there
    may record the event of exiting with the code `c`, and stays where it is.

  ## Main definitions

  * `leak`: the labels of one instruction, from the state it runs in
  * `svcLeak`: the labels of `SVC #0`, for the two calls this file speaks of
  * `RunL`: a run of the machine, with its trace
  * `Reachable`: the states a machine passes through
-/

module

public import Arm64.Trusted.ISA.Semantics
public import Braid.IR.Trace

@[expose] public section

namespace Lowering.Arm

open Braid
open Arm64 (Instr RegWidth MemWidth AddrMode SimdMemSize)

/-- The address of a load or a store: the one the model computes. -/
def ea (s : Arm64.State) (addr : AddrMode) : Word :=
  (Arm64.evalAddrMode s addr).1

/-- Where a conditional branch goes. -/
def target (s : Arm64.State) (taken : Bool) (offset : Word) : Word :=
  if taken then s.pc + offset else s.pc + 4#64

/-- The number of bytes of a load or store of a register of width `w`, or of a signed word
when `signed`. -/
def regSize (w : RegWidth) (signed : Bool) : Nat :=
  if signed then 4 else match w with | .W32 => 4 | .W64 => 8

/-- The two accesses of a pair: `n` bytes at `a`, then `n` bytes at `a + n`. `acc` is
`Label.read` or `Label.write`. -/
def pairLeak (acc : Word → Nat → Label) (a : Word) (n : Nat) : Trace :=
  [acc a n, acc (a + BitVec.ofNat 64 n) n]

/-- The accesses of a load or store of a vector register of size `sz` at `a`: one access, or
for sixteen bytes two of eight, the lower address first. -/
def vecLeak (acc : Word → Nat → Label) (a : Word) : SimdMemSize → Trace
  | .Q128 => [acc a 8, acc (a + 8#64) 8]
  | sz => [acc a sz.bytes]

/-- The accesses of a pair of vector registers: those of the first at `a`, then those of the
second at `a` plus the size. -/
def vecPairLeak (acc : Word → Nat → Label) (a : Word) (sz : SimdMemSize) : Trace :=
  vecLeak acc a sz ++ vecLeak acc (a + BitVec.ofNat 64 sz.bytes) sz

/-- An operand of a division, as it is revealed: the register at the width of the division.
The low half is sign-extended for a signed 32-bit division and zero-extended for an unsigned
one. -/
def divArg (s : Arm64.State) (w : RegWidth) (signed : Bool) (r : Arm64.Reg) : Word :=
  match w, signed with
  | .W64, _ => s.readReg64 r
  | .W32, false => (s.readReg32 r).zeroExtend 64
  | .W32, true => (s.readReg32 r).signExtend 64

/-- What the instruction `i` reveals when it runs in the state `s`, or `none` if this file
does not say. -/
def leak (s : Arm64.State) : Instr → Option Trace
  -- Loads and stores of general registers.
  | .ldr _ sz _ _ addr => some [.read (ea s addr) sz.bytes]
  | .str sz _ addr => some [.write (ea s addr) sz.bytes]
  | .ldrLit w signed _ offset => some [.read (s.pc + offset) (regSize w signed)]
  | .ldp w signed _ _ addr => some (pairLeak .read (ea s addr) (regSize w signed))
  | .stp w _ _ addr => some (pairLeak .write (ea s addr) (regSize w false))
  | .ldnp sz rn _ _ offset =>
    some (pairLeak .read (s.readReg64 rn + offset) (match sz with | .X64 => 8 | _ => 4))
  | .stnp sz rn _ _ offset =>
    some (pairLeak .write (s.readReg64 rn + offset) (match sz with | .X64 => 8 | _ => 4))
  -- Load-acquire, store-release, load-exclusive, and the atomic read-modify-writes.
  | .ldarStlr sz isLoad rn _ =>
    some [if isLoad then .read (s.readReg64 rn) sz.bytes else .write (s.readReg64 rn) sz.bytes]
  | .ldxr sz _ rn _ => some [.read (s.readReg64 rn) sz.bytes]
  | .ldapr sz rn _ => some [.read (s.readReg64 rn) sz.bytes]
  | .atomicRmw _ sz _ _ _ rn _ =>
    some [.read (s.readReg64 rn) sz.bytes, .write (s.readReg64 rn) sz.bytes]
  -- Loads and stores of vector registers.
  | .ldrSimd sz _ addr => some (vecLeak .read (ea s addr) sz)
  | .strSimd sz _ addr => some (vecLeak .write (ea s addr) sz)
  | .ldpSimd sz _ _ addr => some (vecPairLeak .read (ea s addr) sz)
  | .stpSimd sz _ _ addr => some (vecPairLeak .write (ea s addr) sz)
  | .ldnpSimd sz _ _ rn offset => some (vecPairLeak .read (s.readReg64 rn + offset) sz)
  | .stnpSimd sz _ _ rn offset => some (vecPairLeak .write (s.readReg64 rn + offset) sz)
  -- Conditional branches: the address they go to.
  | .bCond cond offset => some [.jump (target s (Arm64.ConditionHolds cond s.pstate) offset)]
  | .cbz w isNonZero rt offset =>
    some [.jump (target s
      (if isNonZero then s.readReg w rt != 0#64 else s.readReg w rt == 0#64) offset)]
  | .tbz _ isNonZero rt bit offset =>
    some [.jump (target s ((s.readReg64 rt).getLsbD bit == isNonZero) offset)]
  -- Computed jumps.
  | .br rn => some [.jump (s.readReg64 rn)]
  | .blr rn => some [.jump (s.readReg64 rn)]
  | .ret rn => some [.jump (s.readReg64 rn)]
  -- Division.
  | .dataProc2 w .UDIV _ rn rm => some [.operands (divArg s w false rn) (divArg s w false rm)]
  | .dataProc2 w .SDIV _ rn rm => some [.operands (divArg s w true rn) (divArg s w true rm)]
  -- Integer instructions that reveal nothing.
  | .nop | .hint _ | .barrier _ _ | .prfm _ _ | .prfmLit _ _ => some []
  | .b _ | .bl _ | .adr _ _ _ => some []
  | .addSubImm .. | .addSubShift .. | .addSubExt .. | .addSubCarry .. => some []
  | .logicalImm .. | .logicalShift .. | .moveWide .. | .bitfield .. | .extr .. => some []
  | .condCompareReg .. | .condCompareImm .. | .condSelect .. => some []
  | .dataProc1 .. | .dataProc2 .. | .dataProc3 .. => some []
  -- Vector instructions that reveal nothing: moves, constants, bitwise operations, and the
  -- addition and subtraction of lanes. The conditions select them by their encoding.
  | .fmovGprVec _ _ _ opcode _ _ => if opcode = 6#3 ∨ opcode = 7#3 then some [] else none
  | .fpDataProc1 _ opcode _ _ => if opcode = 0#6 then some [] else none
  | .fpImm .. | .fpCondSelect .. | .simdInsDup .. | .simdAddpScalar .. => some []
  | .simdImmShift _ _ immh _ _ _ _ => if immh = 0#4 then some [] else none
  | .simdThreeSame _ _ _ _ opcode _ _ =>
    if opcode = 3#5 ∨ opcode = 16#5 then some [] else none
  | .simdTwoRegMisc _ _ _ opcode _ _ => if opcode = 5#5 then some [] else none
  -- Everything else: this file does not say.
  | _ => none

/-- What `SVC #0` reveals when it runs in the state `s` under the model's Linux system calls,
or `none` if this file does not say. The exit (`x8 = 93`) has no label: the step leaves the
status `Exited`, and `RunL` records the event there. The write (`x8 = 64`) of every byte
asked for to the standard output is the event of writing the bytes the model reads from the
buffer and appends to its output. -/
def svcLeak (s : Arm64.State) : Option Trace :=
  if s.readReg64 .x8 = 93#64 then some []
  else if s.readReg64 .x8 = 64#64 ∧ s.readReg32 .x0 = 1#32 ∧ s.readReg64 .x2 ≠ 0#64 ∧
      (s.readReg64 .x2).toNat ≤ Arm64.MAX_RW_COUNT ∧
      (s.readReg64 .x1).toNat + (s.readReg64 .x2).toNat ≤ Arm64.USER_VA_LIMIT ∧
      s.mem.canRead (s.readReg64 .x1) (s.readReg64 .x2).toNat = true then
    some [.event (.write (s.mem.readBytes (s.readReg64 .x1) (s.readReg64 .x2).toNat))]
  else none

/-- A run of the machine `prog` from `s` to `s'`, with its trace: the labels of each
instruction it executes, in order, and the exit event where it has exited. A step is the
execution of an instruction fetched from memory in a running state, `Arm64.Step.exec`: of an
instruction `leak` speaks of (`step`), or of `SVC #0` in a case `svcLeak` speaks of, in a
program whose supervisor calls are the model's Linux system calls (`svc`). A machine that
has exited takes no step: `exited` records its exit with the code of its status and leaves
it where it is. -/
inductive RunL (prog : Arm64.Program) : Arm64.State → Trace → Arm64.State → Prop where
  | refl (s : Arm64.State) : RunL prog s [] s
  | step {s s' : Arm64.State} {i : Instr} {ls tr : Trace} :
      s.status = .Running → prog.fetchMem s.mem s.pc = some i → leak s i = some ls →
      RunL prog (prog.evalInst i s) tr s' → RunL prog s (ls ++ tr) s'
  | svc {s s' : Arm64.State} {ls tr : Trace} :
      s.status = .Running → prog.fetchMem s.mem s.pc = some (.system false 0#16) →
      prog.svc = Arm64.Syscall.standard → svcLeak s = some ls →
      RunL prog (prog.evalInst (.system false 0#16) s) tr s' → RunL prog s (ls ++ tr) s'
  | exited {s s' : Arm64.State} {c : Word} {tr : Trace} :
      s.status = .Exited c → RunL prog s tr s' → RunL prog s (.event (.exit c) :: tr) s'

/-- The states the machine `prog` passes through, running from `s`. -/
def Reachable (prog : Arm64.Program) (s s' : Arm64.State) : Prop := ∃ tr, RunL prog s tr s'

end Lowering.Arm
