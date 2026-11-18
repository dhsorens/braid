/-
  Examples.JsBasic.X86.Proofs

  `basic.js` on x86-64: the machine code V8's optimising compiler, TurboFan, produced for a
  JavaScript function after it had run on small integers. As on AArch64, the code checks
  that it has not been marked for deoptimisation, that the stack has room, that each argument
  is a Smi and that the first addition does not overflow, and the theorem is about the path
  on which every check passes.

  The code ends with `ret 0x20`, which pops the arguments as it returns. The machine model
  has no `ret` with an operand, so the theorem ends at that instruction, with the result in
  `rax` and the caller's frame restored.
-/

module

public import Examples.JsBasic.X86.Image
public import Examples.Spec

public section

namespace Examples.JsBasic.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- A small integer as V8 holds it on a 64-bit machine without pointer compression: the value
in the upper 32 bits, and zero below. -/
def smi (v : BitVec 32) : Word := v.zeroExtend 64 <<< 32#64

/-- Step once, and close a branch the hypotheses rule out. -/
local macro "js_step" : tactic =>
  `(tactic| (braid_step <;>
      first | (exfalso; (try simp only [smi, ofBool] at *); bv_decide; done) | skip))

/-- The prologue of `js_add3`: the code is not marked for deoptimisation, the frame is set
up, and the stack has room. -/
theorem js_add3_prologue (fn code fl root lim sp0 bp0 vsi vdi t m0 m1 m2 m3 : Word)
    (c pf af z sg o : Bool) (hfl : fl &&& 1#64 = 0#64)
    (hlim : lim.ult (sp0 - 32#64) = true) :
    Triple js_add3.program
      (Atoms.interp [.pc 0x401000#64, .reg rcx fn, .reg rbx t, .reg rsi vsi, .reg rdi vdi,
        .reg rbp bp0, .reg rsp sp0, .reg r13 root,
        .mem (fn - 64#64) 8 code true, .mem (code + 15#64) 1 fl true,
        .mem (root - 32#64) 8 lim true,
        .mem (sp0 - 8#64) 8 m0 true, .mem (sp0 - 16#64) 8 m1 true,
        .mem (sp0 - 24#64) 8 m2 true, .mem (sp0 - 32#64) 8 m3 true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc 0x40102f#64, .reg rcx fn, .reg rbx code, .reg rsi vsi, .reg rdi vdi,
        .reg rbp (sp0 - 8#64), .reg rsp (sp0 - 32#64), .reg r13 root,
        .mem (fn - 64#64) 8 code true, .mem (code + 15#64) 1 fl true,
        .mem (root - 32#64) 8 lim true,
        .mem (sp0 - 8#64) 8 bp0 true, .mem (sp0 - 16#64) 8 vsi true,
        .mem (sp0 - 24#64) 8 vdi true, .mem (sp0 - 32#64) 8 vsi true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  iterate 11 js_step
  x86_forget_flags
  braid_done

/-- The body of `js_add3`: each argument is a Smi, the first sum does not overflow, and the
result is the Smi of the wrapped sum. -/
theorem js_add3_body (a b d : BitVec 32) (f t0 t1 t2 t3 t4 : Word) (c pf af z sg o : Bool)
    (hov : b.saddOverflow a = false) :
    Triple js_add3.program
      (Atoms.interp [.pc 0x40102f#64, .reg rbp f, .reg rax t0, .reg rcx t1, .reg rdx t2,
        .reg rdi t3, .reg r8 t4, .mem (f + 32#64) 8 (smi a) true,
        .mem (f + 24#64) 8 (smi b) true, .mem (f + 16#64) 8 (smi d) true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc 0x40107d#64, .reg rbp f, .reg rax (smi (a + b + d)),
        .prop (regAny rcx), .prop (regAny rdx), .prop (regAny rdi), .prop (regAny r8),
        .mem (f + 32#64) 8 (smi a) true, .mem (f + 24#64) 8 (smi b) true,
        .mem (f + 16#64) 8 (smi d) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  iterate 19 js_step
  braid_forget 2
  braid_forget 3
  braid_forget 5
  braid_forget 8
  x86_forget_flags
  refine Triple.done_eq ?_
  simp only [List.cons.injEq, Atom.reg.injEq, true_and, and_true]
  simp only [smi]
  bv_decide

/-- The epilogue of `js_add3`, up to its return: the frame is taken down. -/
theorem js_add3_epilogue (f bp0 ts : Word) :
    Triple js_add3.program
      (Atoms.interp [.pc 0x40107d#64, .reg rbp f, .reg rsp ts, .mem f 8 bp0 true])
      (Atoms.interp [.pc 0x401081#64, .reg rbp bp0, .reg rsp (f + 8#64), .mem f 8 bp0 true]) := by
  iterate 2 braid_step
  braid_done

/-- **`js_add3`, compiled by TurboFan for x86-64, adds three small integers.** Called by a
closure whose code is not marked for deoptimisation, on a stack with room, with Smi arguments
`a`, `b`, `d` on the stack whose first sum does not overflow, it reaches its return
instruction with the Smi of `(a + b + d) | 0` in `rax` and the caller's frame pointer and
stack pointer restored. -/
theorem js_add3_spec (a b d : BitVec 32) (fn code fl root lim sp0 bp0 vsi vdi r : Word)
    (t0 t1 t2 t3 m0 m1 m2 m3 : Word) (c pf af z sg o : Bool) (hfl : fl &&& 1#64 = 0#64)
    (hlim : lim.ult (sp0 - 32#64) = true) (hov : b.saddOverflow a = false) :
    Triple js_add3.program
      (Atoms.interp [.pc 0x401000#64, .reg rax t0, .reg rcx fn, .reg rbx t1, .reg rdx t2,
        .reg r8 t3, .reg rsi vsi, .reg rdi vdi, .reg rbp bp0, .reg rsp sp0, .reg r13 root,
        .mem (fn - 64#64) 8 code true, .mem (code + 15#64) 1 fl true,
        .mem (root - 32#64) 8 lim true,
        .mem (sp0 - 8#64) 8 m0 true, .mem (sp0 - 16#64) 8 m1 true,
        .mem (sp0 - 24#64) 8 m2 true, .mem (sp0 - 32#64) 8 m3 true,
        .mem sp0 8 r true, .mem (sp0 + 8#64) 8 (smi d) true,
        .mem (sp0 + 16#64) 8 (smi b) true, .mem (sp0 + 24#64) 8 (smi a) true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc 0x401081#64, .reg rax (smi (a + b + d)), .prop (regAny rcx),
        .reg rbx code, .prop (regAny rdx), .prop (regAny r8), .reg rsi vsi,
        .prop (regAny rdi), .reg rbp bp0, .reg rsp sp0, .reg r13 root,
        .mem (fn - 64#64) 8 code true, .mem (code + 15#64) 1 fl true,
        .mem (root - 32#64) 8 lim true,
        .mem (sp0 - 8#64) 8 bp0 true, .mem (sp0 - 16#64) 8 vsi true,
        .mem (sp0 - 24#64) 8 vdi true, .mem (sp0 - 32#64) 8 vsi true,
        .mem sp0 8 r true, .mem (sp0 + 8#64) 8 (smi d) true,
        .mem (sp0 + 16#64) 8 (smi b) true, .mem (sp0 + 24#64) 8 (smi a) true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_call js_add3_prologue fn code fl root lim sp0 bp0 vsi vdi _ _ _ _ _ _ _ _ _ _ _
    hfl hlim
  x86_name_flags
  braid_call js_add3_body a b d (sp0 - 8#64) _ _ _ _ _ _ _ _ _ _ _ hov
  braid_call js_add3_epilogue (sp0 - 8#64) bp0 _
  apply Triple.done_split
  braid_split

end Examples.JsBasic.X86
