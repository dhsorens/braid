/-
  Examples.SwiftBasic.X86.Proofs

  `basic.swift` on x86-64: straight-line code and a conditional move. `swift_gcd` divides
  (`div`), which the machine model does not have.
-/

module

public import Examples.SwiftBasic.X86.Image
public import Examples.Spec
import Braid.BV

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
  have e : d + (a + b) = a + (b + d) := by bv_auto
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

/-! ## On the machine -/

/-- **`swift_add3` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `swift_add3`, and has the return address `r` in the eight bytes at the
stack pointer, reaches `r` on every run, with the sum of `rdi`, `rsi` and `rdx` in `rax`. -/
theorem swift_add3_correct [Layout] (m : MachineState) (r : Word) (hpc : m.pc = 0x401000)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        m'.data.regs.get64 .rax = 
          (m.data.regs.get64 .rdi) + (m.data.regs.get64 .rsi) + (m.data.regs.get64 .rdx)) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound swift_add3_holds
    (swift_add3_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64 .rdx)
      (m.data.regs.get64 .rax) (m.data.regs.get64 .rsp) r m.data.status.cf m.data.status.pf
      m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of)
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
      hret]))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    exact Atoms.reg_of_holds (r := 0) hq (by braid_at)

/-- **`swift_min` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `swift_min`, and has the return address `r` in the eight bytes at the
stack pointer, reaches `r` on every run, with the smaller of `rdi` and `rsi` in `rax`. -/
theorem swift_min_correct [Layout] (m : MachineState) (r : Word) (hpc : m.pc = 0x401080)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        m'.data.regs.get64 .rax = umin (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound swift_min_holds
    (swift_min_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64 .rax)
      (m.data.regs.get64 .rsp) r m.data.status.cf m.data.status.pf m.data.status.af
      m.data.status.zf m.data.status.sf m.data.status.of)
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
      hret]))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    exact Atoms.reg_of_holds (r := 0) (v := umin _ _) hq (by braid_at)

end Examples.SwiftBasic.X86
