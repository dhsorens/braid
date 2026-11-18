/-
  Examples.JsBasic.Arm.Proofs

  `basic.js` on AArch64: the machine code V8's optimising compiler, TurboFan, produced for a
  JavaScript function after it had run on small integers. The code is not the function alone.
  It first checks that it has not been marked for deoptimisation and that the stack has room,
  then that each argument is a small integer (a Smi: a 32-bit value in the upper half of a
  word, the lower half zero) and that the first addition does not overflow, and it leaves for
  the interpreter if any check fails. The theorem is about the path on which every check
  passes.
-/

module

public import Examples.JsBasic.Arm.Image
public import Examples.Spec

public section

namespace Examples.JsBasic.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- A small integer as V8 holds it on a 64-bit machine without pointer compression: the value
in the upper 32 bits, and zero below. -/
def smi (v : BitVec 32) : Word := v.zeroExtend 64 <<< 32#64

/-- Step once, and close a branch the hypotheses rule out. -/
local macro "js_step" : tactic =>
  `(tactic| (braid_step <;> first | (exfalso; (try simp only [smi, ofBool] at *); bv_decide; done) | skip))

/-- The prologue of `js_add3`: the code is not marked for deoptimisation, the frame is set
up, and the stack has room. -/
theorem js_add3_prologue (fn code fl root lim sp0 fp0 cp0 v1 r t16 m0 m1 m2 m3 m4 m5 : Word)
    (fn' fz fc fv : Bool) (hsp : sp0 &&& 15#64 = 0#64) (hfl : fl &&& 1#64 = 0#64)
    (hlim : lim.ult (sp0 - 48#64) = true) :
    Triple js_add3.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 4#64, .reg x1 v1, .reg x2 fn, .reg x16 t16,
        .reg x26 root, .reg x27 cp0, .reg x29 fp0, .reg lr r, .reg sp sp0,
        .mem (fn - 8#64) 8 code true, .mem (code + 53#64) 4 fl true,
        .mem (root - 224#64) 8 lim true,
        .mem (sp0 - 48#64) 8 m0 true, .mem (sp0 - 40#64) 8 m1 true,
        .mem (sp0 - 32#64) 8 m2 true, .mem (sp0 - 24#64) 8 m3 true,
        .mem (sp0 - 16#64) 8 m4 true, .mem (sp0 - 8#64) 8 m5 true,
        .flag Flags.n fn', .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc 0x10034#64, .reg x0 4#64, .reg x1 v1, .reg x2 lim,
        .prop (regAny x16), .reg x26 root, .reg x27 cp0, .reg x29 (sp0 - 16#64), .reg lr r,
        .reg sp (sp0 - 48#64),
        .mem (fn - 8#64) 8 code true, .mem (code + 53#64) 4 fl true,
        .mem (root - 224#64) 8 lim true,
        .mem (sp0 - 48#64) 8 cp0 true, .mem (sp0 - 40#64) 8 4#64 true,
        .mem (sp0 - 32#64) 8 v1 true, .mem (sp0 - 24#64) 8 cp0 true,
        .mem (sp0 - 16#64) 8 fp0 true, .mem (sp0 - 8#64) 8 r true,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  iterate 11 js_step
  braid_forget 16
  braid_forget_flag 0
  braid_forget_flag 1
  braid_forget_flag 2
  braid_forget_flag 3
  braid_done

/-- The body of `js_add3`: each argument is a Smi, the first sum does not overflow, and the
result is the Smi of the wrapped sum. -/
theorem js_add3_body (a b c : BitVec 32) (s t0 t2 t3 t4 t5 : Word) (fn' fz fc fv : Bool)
    (hs : s &&& 15#64 = 0#64) (hov : a.saddOverflow b = false) :
    Triple js_add3.program
      (Atoms.interp [.pc 0x10034#64, .reg x0 t0, .reg x2 t2, .reg x3 t3, .reg x4 t4,
        .reg x5 t5, .reg sp s, .mem (s + 56#64) 8 (smi a) true,
        .mem (s + 64#64) 8 (smi b) true, .mem (s + 72#64) 8 (smi c) true,
        .flag Flags.n fn', .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc 0x10074#64, .reg x0 (smi (a + b + c)), .prop (regAny x2),
        .prop (regAny x3), .prop (regAny x4), .prop (regAny x5), .reg sp s,
        .mem (s + 56#64) 8 (smi a) true, .mem (s + 64#64) 8 (smi b) true,
        .mem (s + 72#64) 8 (smi c) true,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  iterate 16 js_step
  braid_forget 2
  braid_forget 3
  braid_forget 4
  braid_forget 5
  braid_forget_flag 0
  braid_forget_flag 1
  braid_forget_flag 2
  braid_forget_flag 3
  refine Triple.done_eq ?_
  simp only [List.cons.injEq, Atom.reg.injEq, true_and, and_true]
  simp only [smi]
  bv_decide

/-- The epilogue of `js_add3`: the frame is taken down, and the four words of arguments and
receiver are popped. -/
theorem js_add3_epilogue (f fp0 r t3 t16 tlr ts : Word) (fn' fz fc fv : Bool)
    (hf : f &&& 15#64 = 0#64) :
    Triple js_add3.program
      (Atoms.interp [.pc 0x10074#64, .reg x3 t3, .reg x16 t16, .reg x29 f, .reg lr tlr,
        .reg sp ts, .mem (f - 24#64) 8 4#64 true, .mem f 8 fp0 true, .mem (f + 8#64) 8 r true,
        .flag Flags.n fn', .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .prop (regAny x3), .prop (regAny x16), .reg x29 fp0, .reg lr r,
        .reg sp (f + 48#64), .mem (f - 24#64) 8 4#64 true, .mem f 8 fp0 true,
        .mem (f + 8#64) 8 r true,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  repeat js_step
  braid_forget 3
  braid_forget 16
  braid_forget_flag 0
  braid_forget_flag 1
  braid_forget_flag 2
  braid_forget_flag 3
  braid_done

/-- **`js_add3`, compiled by TurboFan, adds three small integers.** Called with three
arguments and a receiver (`x0 = 4`), on a stack with room, by a closure whose code is not
marked for deoptimisation, with Smi arguments `a`, `b`, `c` whose first sum does not
overflow, it returns the Smi of `(a + b + c) | 0` in `x0`, restores the frame pointer and
the link register, and pops its arguments. -/
theorem js_add3_spec (a b c : BitVec 32) (fn code fl root lim sp0 fp0 cp0 v1 r : Word)
    (t3 t4 t5 t16 m0 m1 m2 m3 m4 m5 recv : Word) (fn' fz fc fv : Bool)
    (hsp : sp0 &&& 15#64 = 0#64) (hfl : fl &&& 1#64 = 0#64)
    (hlim : lim.ult (sp0 - 48#64) = true) (hov : a.saddOverflow b = false) :
    Triple js_add3.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 4#64, .reg x1 v1, .reg x2 fn, .reg x3 t3,
        .reg x4 t4, .reg x5 t5, .reg x16 t16, .reg x26 root, .reg x27 cp0, .reg x29 fp0,
        .reg lr r, .reg sp sp0,
        .mem (fn - 8#64) 8 code true, .mem (code + 53#64) 4 fl true,
        .mem (root - 224#64) 8 lim true,
        .mem (sp0 - 48#64) 8 m0 true, .mem (sp0 - 40#64) 8 m1 true,
        .mem (sp0 - 32#64) 8 m2 true, .mem (sp0 - 24#64) 8 m3 true,
        .mem (sp0 - 16#64) 8 m4 true, .mem (sp0 - 8#64) 8 m5 true,
        .mem sp0 8 recv true, .mem (sp0 + 8#64) 8 (smi a) true,
        .mem (sp0 + 16#64) 8 (smi b) true, .mem (sp0 + 24#64) 8 (smi c) true,
        .flag Flags.n fn', .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (smi (a + b + c)), .reg x1 v1, .prop (regAny x2),
        .prop (regAny x3), .prop (regAny x4), .prop (regAny x5), .prop (regAny x16),
        .reg x26 root, .reg x27 cp0, .reg x29 fp0, .reg lr r, .reg sp (sp0 + 32#64),
        .mem (fn - 8#64) 8 code true, .mem (code + 53#64) 4 fl true,
        .mem (root - 224#64) 8 lim true,
        .mem (sp0 - 48#64) 8 cp0 true, .mem (sp0 - 40#64) 8 4#64 true,
        .mem (sp0 - 32#64) 8 v1 true, .mem (sp0 - 24#64) 8 cp0 true,
        .mem (sp0 - 16#64) 8 fp0 true, .mem (sp0 - 8#64) 8 r true,
        .mem sp0 8 recv true, .mem (sp0 + 8#64) 8 (smi a) true,
        .mem (sp0 + 16#64) 8 (smi b) true, .mem (sp0 + 24#64) 8 (smi c) true,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  braid_call js_add3_prologue fn code fl root lim sp0 fp0 cp0 v1 r _ _ _ _ _ _ _ _ _ _ _
    hsp hfl hlim
  braid_name_flag 0
  braid_name_flag 1
  braid_name_flag 2
  braid_name_flag 3
  braid_call js_add3_body a b c (sp0 - 48#64) _ _ _ _ _ _ _ _ _ (by bv_decide) hov
  braid_name_reg 3
  braid_name_reg 16
  braid_name_flag 0
  braid_name_flag 1
  braid_name_flag 2
  braid_name_flag 3
  braid_call js_add3_epilogue (sp0 - 16#64) fp0 r _ _ _ _ _ _ _ _ (by bv_decide)
  apply Triple.done_split
  braid_split

end Examples.JsBasic.Arm
