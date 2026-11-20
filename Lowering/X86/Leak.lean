/-
  Lowering.X86.Leak

  What an x86-64 instruction reveals, and the trace of a run of the machine. This is the
  leakage model of `docs/Leakage.md` read on the instructions of Kraken's `X64` model, at the
  64-bit address size:

  * an operand in memory reveals its address and its size, as a `read` when the instruction
    reads it and a `write` when it writes it; `push`, `pop`, `call` and `ret` reveal the
    address on the stack that they use;
  * a conditional jump reveals where it goes, and so do an indirect jump, an indirect call
    and `ret`; a direct `jmp` or `call` reveals no target, which is in the code;
  * every other instruction reveals nothing beyond its memory operands. The model has no
    `div` or `idiv`, so no instruction here reveals its operands. By Intel's data operand
    independent timing, additions, logic, shifts, rotations, multiplications, conditional
    moves and `setcc` take a time that does not depend on their operands; a conditional move
    reads its source whatever the condition. The vector instructions here are on the same
    list: the moves, `paddd` and `vpaddd`, `vprord` and `vpsrld` by an immediate,
    `vpternlogd`, `pshufd`, `pshufb`, `palignr`, `pblendw`, and `sha256rnds2`, `sha256msg1`
    and `sha256msg2`. With register operands they reveal nothing, and with an operand in
    memory they reveal the address and the size of the vector they load or store. `pshufb`
    picks bytes by the bytes of an operand, and its time does not depend on them.
    `sha256rnds2` also reads `xmm0`, a register.

  The labels of one instruction are in the order in which the model's `Operation.interp`
  and `AvxOperation.interp` make the accesses: sources before destinations as the model reads
  them, the write last, and the jump after the accesses. An address is computed in the
  registers the model computes it in: `pop` writes a memory destination at an address taken
  after the stack pointer has moved.

  The accesses are written by cases on the instruction and not read off the model's
  `Effects`. An `Effects` value is a tree that branches on every undefined value, its spans
  split where an access wraps around the address space, and it does not say where control
  goes, so a function from it to a trace would be longer than the cases below.

  A vector in memory is revealed a word at a time: an access to `8 * k` bytes at `a` is the
  `k` labels for 8 bytes at `a`, `a + 8`, and so on, lowest first. That is the same
  information as one label for the whole vector, in the form the lowering emits.

  Where the instruction is outside this file, `leak` is `none`, and `RunL` has no step: the
  string instructions, `adcx`, `adox`, `mulx`, `rcl`, `rcr`, the vector instructions the
  lowering leaves as `trap` (`vzeroupper`, `addps`, `subps`), and any instruction at the
  32-bit address size. A theorem about a trace is then a theorem about a
  run through the other instructions only.

  This file is trusted: a theorem about what an x86-64 program leaks says so in these terms
  (`docs/Trust.md`). It is definitions only.

  ## Main definitions

  * `leak`: the labels of one instruction, from the state it runs in
  * `stepLeak`: the labels of the instruction a machine state is at
  * `RunL`: the runs of the machine, with their trace. The model gives an instruction a set
    of outcomes, one for each value of what it leaves undefined, so `RunL` says that every
    run reaches a postcondition of the state and the trace, as the model's `Eventually` does
    of the state
-/

module

public import Kraken.X64.OmniSemantics
public import Braid.IR.Trace

@[expose] public section

namespace Lowering.X86

open Braid (Word Trace)

section
variable [Labels] (p : Std.Rco Int64)

/-- The address of a memory operand, in the registers `regs`, at the 64-bit address size. -/
def ea (regs : Reg64s) (a : AddrExpr) : Word :=
  (a.interp (address_size := ⟨.W64⟩) regs p).zeroExtend 64

/-- The word the model loads from the eight bytes at `a`. Where memory does not have them
the model has no run, and the word is `0`. -/
def wordAt (s : MachineData) (a : Word) : Word :=
  match Mem.loadInt s.dmem a 8 with
  | some i => .ofInt 64 i
  | none => 0#64

/-- Reading a register or memory operand. -/
def rmRead (regs : Reg64s) {w : Width} : RegOrMem w → Trace
  | .reg _ => []
  | .mem a => [.read (ea p regs a) w.bytes]

/-- Writing a register or memory operand. -/
def rmWrite (regs : Reg64s) {w : Width} : RegOrMem w → Trace
  | .reg _ => []
  | .mem a => [.write (ea p regs a) w.bytes]

/-- Reading an operand. -/
def opRead (regs : Reg64s) {w : Width} : Operand w → Trace
  | .regOrMem o => rmRead p regs o
  | .imm _ => []

/-- Reading a vector operand, a word at a time. -/
def vecRead (regs : Reg64s) {w : AvxWidth} : AvxRegOrMem w → Trace
  | .avx _ => []
  | .mem a => (List.range (w.bytes / 8)).map fun j =>
      .read (ea p regs a + BitVec.ofNat 64 (8 * j)) 8

/-- Writing a vector operand, a word at a time. -/
def vecWrite (regs : Reg64s) {w : AvxWidth} : AvxRegOrMem w → Trace
  | .avx _ => []
  | .mem a => (List.range (w.bytes / 8)).map fun j =>
      .write (ea p regs a + BitVec.ofNat 64 (8 * j)) 8

/-- Reading the target of a jump or a call. -/
def targetRead (s : MachineData) : RelRegOrMem → Trace
  | .rel _ | .reg _ => []
  | .mem a => [.read (ea p s.regs a) 8]

/-- Going to the target of a jump or a call: nothing if it is in the code. -/
def targetJump (s : MachineData) : RelRegOrMem → Trace
  | .rel _ => []
  | .reg r => [.jump (s.regs.get r)]
  | .mem a => [.jump (wordAt s (ea p s.regs a))]

/-- What the integer instruction `i`, which occupies the addresses `p`, reveals when it runs
in the state `s`. -/
def leakOp (s : MachineData) {w : Width} : Operation w → Option Trace
  | .mov dst src => some (opRead p s.regs src ++ rmWrite p s.regs dst)
  | .movzx dst src => some (rmRead p s.regs src ++ rmWrite p s.regs dst)
  | .movsx dst src => some (rmRead p s.regs src ++ rmWrite p s.regs dst)
  | .push src =>
    some (opRead p s.regs src ++ [.write (s.regs.get64 .rsp - w.bytesv) w.bytes])
  | .pop dst =>
    some ([.read (s.regs.get64 .rsp) w.bytes] ++
      rmWrite p (s.regs.set64 .rsp (s.regs.get64 .rsp + w.bytesv)) dst)
  | .setcc _ dst => some (rmWrite p s.regs dst)
  | .cmovcc _ _ src => some (rmRead p s.regs src)
  | .lea _ _ | .bswap _ | .cld | .std | .nop _ | .nopalign _ _ => some []
  | .add dst src | .sub dst src | .adc dst src | .sbb dst src =>
    some (opRead p s.regs src ++ rmRead p s.regs dst ++ rmWrite p s.regs dst)
  | .and dst src | .or dst src | .xor dst src =>
    some (rmRead p s.regs dst ++ opRead p s.regs src ++ rmWrite p s.regs dst)
  | .cmp a b | .test a b => some (rmRead p s.regs a ++ opRead p s.regs b)
  | .inc dst | .dec dst | .neg dst | .not dst =>
    some (rmRead p s.regs dst ++ rmWrite p s.regs dst)
  | .shl dst _ | .shr dst _ | .sar dst _ | .rol dst _ | .ror dst _
  | .shld dst _ _ | .shrd dst _ _ =>
    some (rmRead p s.regs dst ++ rmWrite p s.regs dst)
  | .mul src | .imul1 src => some (rmRead p s.regs src)
  | .imul dst src1 src2 =>
    some (rmRead p s.regs src1 ++ opRead p s.regs src2 ++
      rmWrite p s.regs (dst.getD src1))
  | .jcc cc l =>
    some [.jump (if cc.interp s.status then (label l).toBitVec else p.upper.toBitVec)]
  | .jmp tgt => some (targetRead p s tgt ++ targetJump p s tgt)
  | .call tgt =>
    some (targetRead p s tgt ++ [.write (s.regs.get64 .rsp - 8#64) 8] ++ targetJump p s tgt)
  | .ret => some [.read (s.regs.get64 .rsp) 8, .jump (wordAt s (s.regs.get64 .rsp))]
  | .movs _ | .stos _ | .adcx _ _ | .adox _ _ | .mulx _ _ _ | .rcl _ _ | .rcr _ _ => none

/-- What the vector instruction `i` reveals when it runs in the state `s`. -/
def leakAvx (s : MachineData) {w : AvxWidth} : AvxOperation w → Option Trace
  | .movups dst src | .movaps dst src | .movdqu dst src | .movdqa dst src
  | .vmovups dst src | .vmovdqu dst src | .vmovdqu32 dst src | .vmovdqa32 dst src =>
    some (vecRead p s.regs src ++ vecWrite p s.regs dst)
  | .paddd dst src | .pshufb dst src | .palignr dst src _ | .pblendw dst src _
  | .sha256rnds2 dst src | .sha256msg1 dst src | .sha256msg2 dst src =>
    some (vecRead p s.regs src ++ vecRead p s.regs dst ++ vecWrite p s.regs dst)
  | .vpaddd dst src1 src2 =>
    some (vecRead p s.regs src2 ++ vecRead p s.regs src1 ++ vecWrite p s.regs dst)
  | .vprord dst src _ | .vpsrld dst src _ | .pshufd dst src _ =>
    some (vecRead p s.regs src ++ vecWrite p s.regs dst)
  | .vpternlogd dst src2 src3 _ =>
    some (vecRead p s.regs src3 ++ vecRead p s.regs src2 ++ vecRead p s.regs dst ++
      vecWrite p s.regs dst)
  | .vmovq _ _ => some []
  | .vmovIn _ _ src => some (rmRead p s.regs src)
  | .vmovOut _ dst _ => some (rmWrite p s.regs dst)
  | _ => none

/-- What the instruction `i`, which occupies the addresses `p`, reveals when it runs in the
state `s`; `none` if the instruction is outside this file. -/
def leak (s : MachineData) : Instr → Option Trace
  | .regular .W64 _ op => leakOp p s op
  | .avx .W64 _ op => leakAvx p s op
  | _ => none

/-- What the directives at the address `pc` reveal: labels, which take no room and reveal
nothing, and then one instruction. -/
def leakDirs (s : MachineData) (pc : Int64) : List (Kraken.Sized Directive) → Option Trace
  | [⟨.instr i, sz⟩] => leak ⟨pc, pc + .ofNat sz⟩ s i
  | ⟨.label _, 0⟩ :: ds => leakDirs s pc ds
  | _ => none

end

/-- What the step of the executable `e` from the state `m` reveals. -/
def stepLeak (e : Executable) (m : MachineState) : Option Trace :=
  let := Executable.labels e
  leakDirs m.data m.pc (e.directivesAtAddress m.pc)

/-- Every run of the executable from the state `m`, after the trace `t`, reaches a state and
a trace satisfying `post`. The trace of a run is the labels of each instruction it executes,
in order. This is the model's `Eventually (step1 e)` with the trace carried along. -/
inductive RunL [Layout] (e : Executable) (post : MachineState → Trace → Prop) :
    MachineState → Trace → Prop where
  | done (m : MachineState) (t : Trace) : post m t → RunL e post m t
  | step (m : MachineState) (t ls : Trace) (mid : MachineState → Prop) :
      stepLeak e m = some ls → step1 e m mid →
      (∀ m', mid m' → RunL e post m' (t ++ ls)) → RunL e post m t

end Lowering.X86
