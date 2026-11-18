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

/-- A memory atom apart from the sixty-four bytes around the stack pointer is disjoint from
each word of them. -/
private theorem disj_stack {a b sp v v' : Word} {n : Nat} {w w' : Bool}
    (h : 64 ≤ (a - (sp - 32#64)).toNat ∧ n ≤ (sp - 32#64 - a).toNat)
    (hb : (b - (sp - 32#64)).toNat ≤ 56) : Atom.Disj (.mem a n v w) (.mem b 8 v' w') :=
  Atom.disj_mem_mem fun x hx => by bv_omega

/-- **`js_add3` on the machine.** A machine of the model that runs the executable of this
image and is at the entry of `js_add3` as V8 calls it: the closure in `rcx`, whose code
object `code` is not marked for deoptimisation; the stack limit `lim`, read through the root
register `r13`, below the frame; the return address `r` in the eight bytes at the stack
pointer, the Smi arguments `d`, `b` and `a` in the words above them, where the sum of `a` and
`b` does not overflow, and memory in the thirty-two bytes below; the closure's word, the
flag byte and the limit apart from one another and from those sixty-four bytes of stack.
On every run it reaches its return instruction, with the Smi of `a + b + d` in `rax`, the
stack pointer and frame pointer as they were, and the return address still at the stack
pointer. -/
theorem js_add3_correct [Layout] (m : MachineState) (a b d : BitVec 32)
    (code fl lim r m0 m1 m2 m3 : Word) (hpc : m.pc = 0x401000)
    (hcode : HasBytes m (m.data.regs.get64 .rcx - 64#64) 8 code)
    (hflag : HasBytes m (code + 15#64) 1 fl) (hfl : fl &&& 1#64 = 0#64)
    (hlimit : HasBytes m (m.data.regs.get64 .r13 - 32#64) 8 lim)
    (hlim : lim.ult (m.data.regs.get64 .rsp - 32#64) = true)
    (hs0 : HasBytes m (m.data.regs.get64 .rsp - 8#64) 8 m0)
    (hs1 : HasBytes m (m.data.regs.get64 .rsp - 16#64) 8 m1)
    (hs2 : HasBytes m (m.data.regs.get64 .rsp - 24#64) 8 m2)
    (hs3 : HasBytes m (m.data.regs.get64 .rsp - 32#64) 8 m3)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hd : HasBytes m (m.data.regs.get64 .rsp + 8#64) 8 (smi d))
    (hb : HasBytes m (m.data.regs.get64 .rsp + 16#64) 8 (smi b))
    (ha : HasBytes m (m.data.regs.get64 .rsp + 24#64) 8 (smi a))
    (hov : b.saddOverflow a = false)
    (hcf : 1 ≤ (m.data.regs.get64 .rcx - 64#64 - (code + 15#64)).toNat ∧
      8 ≤ (code + 15#64 - (m.data.regs.get64 .rcx - 64#64)).toNat)
    (hcl : 8 ≤ (m.data.regs.get64 .rcx - 64#64 - (m.data.regs.get64 .r13 - 32#64)).toNat ∧
      8 ≤ (m.data.regs.get64 .r13 - 32#64 - (m.data.regs.get64 .rcx - 64#64)).toNat)
    (hfll : 8 ≤ (code + 15#64 - (m.data.regs.get64 .r13 - 32#64)).toNat ∧
      1 ≤ (m.data.regs.get64 .r13 - 32#64 - (code + 15#64)).toNat)
    (hcs : 64 ≤ (m.data.regs.get64 .rcx - 64#64 - (m.data.regs.get64 .rsp - 32#64)).toNat ∧
      8 ≤ (m.data.regs.get64 .rsp - 32#64 - (m.data.regs.get64 .rcx - 64#64)).toNat)
    (hfs : 64 ≤ (code + 15#64 - (m.data.regs.get64 .rsp - 32#64)).toNat ∧
      1 ≤ (m.data.regs.get64 .rsp - 32#64 - (code + 15#64)).toNat)
    (hls : 64 ≤ (m.data.regs.get64 .r13 - 32#64 - (m.data.regs.get64 .rsp - 32#64)).toNat ∧
      8 ≤ (m.data.regs.get64 .rsp - 32#64 - (m.data.regs.get64 .r13 - 32#64)).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = 0x401081#64 ∧
        m'.data.regs.get64 .rax = smi (a + b + d) ∧
        m'.data.regs.get64 .rsp = m.data.regs.get64 .rsp ∧
        m'.data.regs.get64 .rbp = m.data.regs.get64 .rbp ∧
        HasBytes m' (m.data.regs.get64 .rsp) 8 r) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound js_add3_holds
    (js_add3_spec a b d (m.data.regs.get64 .rcx) code fl (m.data.regs.get64 .r13) lim
      (m.data.regs.get64 .rsp) (m.data.regs.get64 .rbp) (m.data.regs.get64 .rsi)
      (m.data.regs.get64 .rdi) r (m.data.regs.get64 .rax) (m.data.regs.get64 .rbx)
      (m.data.regs.get64 .rdx) (m.data.regs.get64 .r8) m0 m1 m2 m3 m.data.status.cf m.data.status.pf
      m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of hfl hlim hov)
    (by simp [Atom.IsPointsTo])
    (by
      braid_disj
      repeat' constructor
      all_goals try decide
      · exact Atom.disj_mem_mem_of_apart hcf
      · exact Atom.disj_mem_mem_of_apart hcl
      iterate 8 exact disj_stack hcs (by bv_omega)
      · exact Atom.disj_mem_mem_of_apart hfll
      iterate 8 exact disj_stack hfs (by bv_omega)
      iterate 8 exact disj_stack hls (by bv_omega)
      all_goals exact Atom.disj_mem_mem_of_apart (by bv_omega))
    (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
      hret, hcode, hflag, hlimit, hs0, hs1, hs2, hs3, hd, hb, ha]))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    exact Atoms.reg_of_holds (r := 0) (v := smi _) hq (by braid_at)
  · rw [← hr.reg .rsp]
    exact Atoms.reg_of_holds (r := 6) hq (by braid_at)
  · rw [← hr.reg .rbp]
    exact Atoms.reg_of_holds (r := 7) hq (by braid_at)
  · exact hasBytes_of_holds hr hq (by braid_at)

end Examples.JsBasic.X86
