/-
  Examples.GoBasic.X86.Proofs

  `basic.go` on x86-64, compiled by Go's own back end. Go passes arguments in `rax`, `rbx`
  and `rcx`, and returns in `rax`.
-/

module

public import Examples.GoBasic.X86.Image
public import Examples.Spec

public section

namespace Examples.GoBasic.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- `main.Add3` returns the sum of its arguments. -/
theorem main_Add3_spec (a b d t s r : Word) :
    Triple main_Add3.program
      (Atoms.interp [.pc 0x47a600#64, .reg rax a, .reg rbx b, .reg rcx d, .reg rdx t,
        .reg rsp s, .mem s 8 r true])
      (Atoms.interp [.pc r, .reg rax (d + (b + a)), .reg rbx b, .reg rcx d, .reg rdx (b + a),
        .reg rsp (s + 8#64), .mem s 8 r true]) := by
  braid_run
  refine Triple.done_eq ?_
  simp only [BitVec.mul_one]

/-- `main.MaxU64` returns the larger of its arguments. It branches, where the C compiler
uses a conditional move. -/
theorem main_MaxU64_spec (a b s r : Word) (c pf af z sg o : Bool) :
    Triple main_MaxU64.program
      (Atoms.interp [.pc 0x47a620#64, .reg rax a, .reg rbx b, .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (umax a b), .reg rbx b, .reg rsp (s + 8#64),
        .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_step
  braid_step
  all_goals
    braid_run
    x86_forget_flags
    refine Triple.done_eq ?_
    simp only [umax]
    by_cases h1 : b.ult a <;> simp_all

end Examples.GoBasic.X86
