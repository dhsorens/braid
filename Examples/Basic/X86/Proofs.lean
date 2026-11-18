/-
  Examples.Basic.X86.Proofs

  `basic.c` on x86-64: straight-line code and a conditional move. The compiler turns the
  loop of `sum_to` into a closed form with a 128-bit product (`mul`, `shld`), which the
  lowering does not cover yet.
-/

module

public import Examples.Basic.X86.Image
public import Examples.Spec

public section

namespace Examples.Basic.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- `add3` returns the sum of its arguments. It sets the flags. -/
theorem add3_spec (a b d t s r : Word) (c p x z n o : Bool) :
    Triple add3.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi a, .reg rsi b, .reg rdx d, .reg rax t,
        .reg rsp s, .mem s 8 r true, .flag Flags.cf c, .flag Flags.pf p, .flag Flags.af x,
        .flag Flags.zf z, .flag Flags.sf n, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi a, .reg rsi b, .reg rdx d, .reg rax (a + b + d),
        .reg rsp (s + 8#64), .mem s 8 r true, .prop (flagAny Flags.cf),
        .prop (flagAny Flags.pf), .prop (flagAny Flags.af), .prop (flagAny Flags.zf),
        .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_run
  x86_forget_flags
  refine Triple.done_eq ?_
  have e : d + (a + b) = a + (b + d) := by bv_decide
  simp only [BitVec.mul_one, e]

/-- `max_u64` returns the larger of its arguments. It sets the flags. -/
theorem max_u64_spec (a b t s r : Word) (c p x z n o : Bool) :
    Triple max_u64.program
      (Atoms.interp [.pc 0x401010#64, .reg rdi a, .reg rsi b, .reg rax t, .reg rsp s,
        .mem s 8 r true, .flag Flags.cf c, .flag Flags.pf p, .flag Flags.af x,
        .flag Flags.zf z, .flag Flags.sf n, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi a, .reg rsi b, .reg rax (umax a b), .reg rsp (s + 8#64),
        .mem s 8 r true, .prop (flagAny Flags.cf), .prop (flagAny Flags.pf),
        .prop (flagAny Flags.af), .prop (flagAny Flags.zf), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) := by
  braid_run
  x86_forget_flags
  refine Triple.done_eq ?_
  simp only [umax, ofBool]
  by_cases h1 : a.ult b <;> by_cases h2 : a = b <;> simp_all
  all_goals bv_decide

/-- **`add3` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `add3`, and has the return address `r` in the eight bytes at the
stack pointer, reaches `r` on every run, with the sum of `rdi`, `rsi` and `rdx` in `rax`. -/
theorem add3_correct [Layout] (m : MachineState) (r : Word) (hpc : m.pc = 0x401000)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        m'.data.regs.get64 .rax =
          m.data.regs.get64 .rdi + m.data.regs.get64 .rsi + m.data.regs.get64 .rdx) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound add3_holds
    (add3_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64 .rdx)
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

/-- `sum_to` returns `1 + 2 + ... + n`. The compiler has replaced the loop of the source by a
closed form with a 128-bit product (`mul`) and a double shift (`shld`). -/
theorem sum_to_spec (n t0 t1 t2 t3 s r : Word) (c p x z sg o : Bool) :
    Triple sum_to.program
      (Atoms.interp [.pc 0x401020#64, .reg rdi n, .reg rax t0, .reg rsi t1, .reg rcx t2,
        .reg rdx t3, .reg rsp s, .mem s 8 r true, .flag Flags.cf c, .flag Flags.pf p,
        .flag Flags.af x, .flag Flags.zf z, .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .prop (regAny rdi), .reg rax (tri n), .prop (regAny rsi),
        .prop (regAny rcx), .prop (regAny rdx), .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_step
  braid_step
  · have hn : n = 0#64 := by simpa using hbr
    subst hn
    braid_run
    braid_forget 5
    braid_forget 4
    braid_forget 2
    braid_forget 3
    x86_forget_flags
    simp only [BitVec.xor_self, tri_zero]
    braid_done
  · have hn : n ≠ 0#64 := by simpa using hbr
    braid_run
    braid_forget 5
    braid_forget 4
    braid_forget 2
    braid_forget 3
    x86_forget_flags
    refine Triple.done_eq ?_
    have a1 : n + 18446744073709551615#64 = n - 1#64 := by bv_decide
    have a2 : 18446744073709551614#64 + n = n - 2#64 := by bv_decide
    have hw : BitVec.setWidth 128 (n - 1#64) * BitVec.setWidth 128 (n - 2#64) =
        wide (n - 1#64) (n - 2#64) := rfl
    rw [a1, a2, hw, ← tri_closed n hn, ← wide_lo (n - 1#64) (n - 2#64)]
    generalize wide (n - 1#64) (n - 2#64) = X
    simp only [List.cons.injEq, Atom.reg.injEq, true_and, and_true]
    bv_decide

end Examples.Basic.X86
