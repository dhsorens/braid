/-
  Examples.PyBasic.X86.Proofs

  `basic.py` on x86-64: Python functions compiled to native code by Numba. A compiled
  function returns a status in `eax`, zero for success, and writes its result through the
  pointer it is given in `rdi`. Its Python arguments start at `rdx`. `gcd` divides (`div`),
  which the machine model does not have.
-/

module

public import Examples.PyBasic.X86.Image
public import Examples.Spec

public section

namespace Examples.PyBasic.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- `add3` writes the sum of its arguments through the result pointer, and returns zero. -/
theorem py_add3_spec (p a b d t old s r : Word) (c pf af z sg o : Bool) :
    Triple py_add3.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi p, .reg rdx a, .reg rcx b, .reg r8 d,
        .reg rax t, .mem p 8 old true, .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi p, .reg rdx (d + (b + a)), .reg rcx b, .reg r8 d,
        .reg rax 0#64, .mem p 8 (d + (b + a)) true, .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_run
  x86_forget_flags
  simp only [BitVec.xor_self]
  braid_done

/-- `max_u64` writes the larger of its arguments through the result pointer. -/
theorem py_max_u64_spec (p a b t old s r : Word) (c pf af z sg o : Bool) :
    Triple py_max_u64.program
      (Atoms.interp [.pc 0x401010#64, .reg rdi p, .reg rdx a, .reg rcx b, .reg rax t,
        .mem p 8 old true, .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi p, .reg rdx a, .reg rcx (umax a b), .reg rax 0#64,
        .mem p 8 (umax a b) true, .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_run
  x86_forget_flags
  refine Triple.done_eq ?_
  have e : (if ofBool (a.ult b) ||| ofBool (a - b == 0#64) = 0#64 then a else b) = umax a b := by
    simp only [umax, ofBool]
    by_cases h1 : a.ult b <;> by_cases h2 : a = b <;> simp_all
    all_goals bv_decide
  simp only [e, BitVec.xor_self]

end Examples.PyBasic.X86
