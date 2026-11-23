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
import Braid.BV

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
    all_goals bv_auto
  simp only [e, BitVec.xor_self]

/-! ## On the machine -/

/-- A memory atom of a postcondition, read off the machine. -/
private theorem hasBytes_of_holds {as : Atoms} {R : SProp} {σ : State} {m : MachineState}
    {a v : Word} {n : Nat} {w : Bool} (hr : Rel m σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.mem a n v w)) : HasBytes m a n v := by
  intro x hx
  have hc := Atoms.mem_of_holds h hat hx
  rw [hr.data.mem] at hc
  obtain ⟨b, hb, hc⟩ := memOf_eq_some hc
  rw [hb]
  simpa using (congrArg Cell.val hc).symm

/-- **`py_add3` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `py_add3`, has a word of memory where `rdi` points, and has the
return address `r` in the eight bytes at the stack pointer, apart from that word, reaches `r`
on every run, with the sum of `rdx`, `rcx` and `r8` in the word `rdi` pointed to, and zero in
`rax`. -/
theorem py_add3_correct [Layout] (m : MachineState) (old r : Word) (hpc : m.pc = 0x401000)
    (hres : HasBytes m (m.data.regs.get64 .rdi) 8 old)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hsep : 8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsp).toNat ∧
      8 ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧ m'.data.regs.get64 .rax = 0#64 ∧
        HasBytes m' (m.data.regs.get64 .rdi) 8
          (m.data.regs.get64 .rdx + m.data.regs.get64 .rcx +
            m.data.regs.get64 .r8)) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound py_add3_holds
    (py_add3_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rdx) (m.data.regs.get64 .rcx)
      (m.data.regs.get64 .r8) (m.data.regs.get64 .rax) old (m.data.regs.get64 .rsp) r
      m.data.status.cf m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf
      m.data.status.of)
    (by simp [Atom.IsPointsTo])
    (by
      braid_disj
      repeat' constructor
      all_goals first | decide | exact Atom.disj_mem_mem_of_apart hsep)
    (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
      hret, hres]))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    exact Atoms.reg_of_holds (r := 0) hq (by braid_at)
  · have e : m.data.regs.get64 .rdx + m.data.regs.get64 .rcx + m.data.regs.get64 .r8 =
        m.data.regs.get64 .r8 + (m.data.regs.get64 .rcx + m.data.regs.get64 .rdx) := by ac_rfl
    rw [e]
    exact hasBytes_of_holds hr hq (by braid_at)

/-- **`py_max_u64` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `py_max_u64`, has a word of memory where `rdi` points, and has the
return address `r` in the eight bytes at the stack pointer, apart from that word, reaches `r`
on every run, with the larger of `rdx` and `rcx` in the word `rdi` pointed to, and zero in `rax`. -/
theorem py_max_u64_correct [Layout] (m : MachineState) (old r : Word) (hpc : m.pc = 0x401010)
    (hres : HasBytes m (m.data.regs.get64 .rdi) 8 old)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hsep : 8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsp).toNat ∧
      8 ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧ m'.data.regs.get64 .rax = 0#64 ∧
        HasBytes m' (m.data.regs.get64 .rdi) 8
          (umax (m.data.regs.get64 .rdx) (m.data.regs.get64 .rcx))) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound py_max_u64_holds
    (py_max_u64_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rdx) (m.data.regs.get64 .rcx)
    (m.data.regs.get64 .rax) old (m.data.regs.get64 .rsp) r m.data.status.cf m.data.status.pf
      m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of)
    (by simp [Atom.IsPointsTo])
    (by
      braid_disj
      repeat' constructor
      all_goals first | decide | exact Atom.disj_mem_mem_of_apart hsep)
    (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
      hret, hres]))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    exact Atoms.reg_of_holds (r := 0) hq (by braid_at)
  · exact hasBytes_of_holds hr hq (by braid_at)

end Examples.PyBasic.X86
