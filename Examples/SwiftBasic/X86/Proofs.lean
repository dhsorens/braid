/-
  Examples.SwiftBasic.X86.Proofs

  `basic.swift` on x86-64: straight-line code and a conditional move. `swift_gcd` divides
  (`div`), which the machine model does not have.
-/

module

public import Examples.SwiftBasic.X86.Image
public import Examples.Spec

public section

namespace Examples.SwiftBasic.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- `swift_add3` returns the sum of its arguments. It sets the flags. -/
theorem swift_add3_spec (a b d t s r : Word) (c pf af z sg o : Bool) :
    Triple swift_add3.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi a, .reg rsi b, .reg rdx d, .reg rax t,
        .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi a, .reg rsi b, .reg rdx d, .reg rax (a + b + d),
        .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_run
  x86_forget_flags
  refine Triple.done_eq ?_
  have e : d + (a + b) = a + (b + d) := by bv_decide
  simp only [BitVec.mul_one, e]

/-- `swift_min` returns the smaller of its arguments. It sets the flags. -/
theorem swift_min_spec (a b t s r : Word) (c pf af z sg o : Bool) :
    Triple swift_min.program
      (Atoms.interp [.pc 0x401080#64, .reg rdi a, .reg rsi b, .reg rax t, .reg rsp s,
        .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi a, .reg rsi b, .reg rax (umin a b), .reg rsp (s + 8#64),
        .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_run
  x86_forget_flags
  refine Triple.done_eq ?_
  simp only [umin]

end Examples.SwiftBasic.X86
