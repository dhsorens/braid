/-
  Examples.Memory.X86.Proofs

  `memory.c` on x86-64: loads and stores, a loop over an array with an indexed load, a call
  with a stack frame, and a tail call. The specifications are those of the RISC-V proofs,
  with the x86-64 registers, the status flags, and the return address on the stack.
-/

module

public import Examples.Memory.X86.Image
public import Examples.Spec

public section

namespace Examples.Memory.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- `swap` exchanges the two words its arguments point to, and returns through the address
on the stack. -/
theorem swap_spec (p q x y t0 t1 s r : Word) :
    Triple swap.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi p, .reg rsi q, .reg rax t0, .reg rcx t1,
        .mem p 8 x true, .mem q 8 y true, .reg rsp s, .mem s 8 r true])
      (Atoms.interp [.pc r, .reg rdi p, .reg rsi q, .reg rax x, .reg rcx y,
        .mem p 8 y true, .mem q 8 x true, .reg rsp (s + 8#64), .mem s 8 r true]) := by
  braid_run
  braid_done

/-- `max2` returns the larger of its arguments. It sets the flags. -/
theorem max2_spec (a b t s r : Word) (c p x z n o : Bool) :
    Triple max2.program
      (Atoms.interp [.pc 0x401030#64, .reg rdi a, .reg rsi b, .reg rax t, .reg rsp s,
        .mem s 8 r true, .flag Flags.cf c, .flag Flags.pf p, .flag Flags.af x,
        .flag Flags.zf z, .flag Flags.sf n, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi a, .reg rsi b, .reg rax (umax a b), .reg rsp (s + 8#64),
        .mem s 8 r true, .prop (flagAny Flags.cf), .prop (flagAny Flags.pf),
        .prop (flagAny Flags.af), .prop (flagAny Flags.zf), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) := by
  braid_run
  braid_forget_flag 0
  braid_forget_flag 1
  braid_forget_flag 2
  braid_forget_flag 3
  braid_forget_flag 4
  braid_forget_flag 5
  refine Triple.done_eq ?_
  simp only [umax, ofBool]
  by_cases h1 : a.ult b <;> by_cases h2 : a = b <;> simp_all
  all_goals bv_decide

/-- `max2` and `max3` together. -/
def prog : Braid.Program := Braid.Program.ofList (max2.blocks ++ max3.blocks)

theorem max2_spec' (a b t s r : Word) (c p x z n o : Bool) :
    Triple prog
      (Atoms.interp [.pc 0x401030#64, .reg rdi a, .reg rsi b, .reg rax t, .reg rsp s,
        .mem s 8 r true, .flag Flags.cf c, .flag Flags.pf p, .flag Flags.af x,
        .flag Flags.zf z, .flag Flags.sf n, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi a, .reg rsi b, .reg rax (umax a b), .reg rsp (s + 8#64),
        .mem s 8 r true, .prop (flagAny Flags.cf), .prop (flagAny Flags.pf),
        .prop (flagAny Flags.af), .prop (flagAny Flags.zf), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) :=
  (max2_spec a b t s r c p x z n o).mono
    (Braid.Program.ofList_mono (fun _ h => List.mem_append_left _ h) (by decide))

/-- `max3` returns the largest of its arguments. It keeps its third argument in a
callee-saved register, which it saves on the stack, across a call of `max2`, and returns
through a tail call. -/
theorem max3_spec (a b d t v0 s r m0 m1 : Word) (c p x z n o : Bool) :
    Triple prog
      (Atoms.interp [.pc 0x401040#64, .reg rdi a, .reg rsi b, .reg rdx d, .reg rax t,
        .reg rbx v0, .reg rsp s, .mem s 8 r true, .mem (s - 8#64) 8 m0 true,
        .mem (s - 16#64) 8 m1 true, .flag Flags.cf c, .flag Flags.pf p, .flag Flags.af x,
        .flag Flags.zf z, .flag Flags.sf n, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi (umax a b), .reg rsi d, .reg rdx d,
        .reg rax (umax (umax a b) d), .reg rbx v0, .reg rsp (s + 8#64), .mem s 8 r true,
        .mem (s - 8#64) 8 v0 true, .mem (s - 16#64) 8 0x401049#64 true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  iterate 3 braid_step
  braid_call max2_spec' _ _ _ _ _ _ _ _ _ _ _
  iterate 4 braid_step
  braid_name_flag 0
  braid_name_flag 1
  braid_name_flag 2
  braid_name_flag 3
  braid_name_flag 4
  braid_name_flag 5
  braid_call max2_spec' _ _ _ _ _ _ _ _ _ _ _
  braid_done

/-- The loop of `sum_array`, from index `i`, with the words `x :: xs` still to add. -/
theorem sum_array_loop (p n s r : Word) : ∀ (xs : List Word) (x i acc : Word)
    (c pf af z sg o : Bool), i + BitVec.ofNat 64 (xs.length + 1) = n →
    i.toNat + xs.length + 1 < 2 ^ 61 →
    Triple sum_array.program
      (Atoms.interp [.pc 0x401020#64, .reg rax acc, .reg rcx i, .reg rdi p, .reg rsi n,
        .prop (wordsAt (p + i * 8#64) (x :: xs)), .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (wsum (x :: xs) acc), .reg rcx n, .reg rdi p, .reg rsi n,
        .prop (wordsAt (p + i * 8#64) (x :: xs)), .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  intro xs
  induction xs with
  | nil =>
    intro x i acc c pf af z sg o he hb
    have hn : n = i + 1#64 := by simpa using he.symm
    subst hn
    braid_unfold wordsAt_cons (p + i * 8#64) x []
    iterate 3 braid_step
    braid_step
    · exact absurd hbr (by simp)
    · braid_run
      braid_fold wordsAt_cons (p + i * 8#64) x []
      braid_forget_flag 0
      braid_forget_flag 1
      braid_forget_flag 2
      braid_forget_flag 3
      braid_forget_flag 4
      braid_forget_flag 5
      simp only [wsum, List.foldl_cons, List.foldl_nil]
      braid_done
  | cons y ys ih =>
    intro x i acc c pf af z sg o he hb
    simp only [List.length_cons] at he hb
    braid_unfold wordsAt_cons (p + i * 8#64) x (y :: ys)
    iterate 3 braid_step
    braid_step
    · have e : p + (i * 8#64 + 8#64) = p + (i + 1#64) * 8#64 := by bv_decide
      rw [e]
      braid_call ih y (i + 1#64) (x + acc) _ _ _ _ _ _ (by rw [← he]; bv_omega) (by bv_omega)
      rw [← e]
      braid_fold wordsAt_cons (p + i * 8#64) x (y :: ys)
      simp only [wsum, List.foldl_cons]
      braid_done
    · exfalso
      have : n - (i + 1#64) ≠ 0#64 := by rw [← he]; bv_omega
      exact this (by simpa using hbr)

/-- `sum_array` returns the sum of the `n` words its first argument points to. -/
theorem sum_array_spec (p t0 t1 s r : Word) (xs : List Word) (c pf af z sg o : Bool)
    (hl : xs.length < 2 ^ 61) :
    Triple sum_array.program
      (Atoms.interp [.pc 0x401010#64, .reg rax t0, .reg rcx t1, .reg rdi p,
        .reg rsi (BitVec.ofNat 64 xs.length), .prop (wordsAt p xs), .reg rsp s,
        .mem s 8 r true, .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af,
        .flag Flags.zf z, .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (wsum xs 0#64), .prop (regAny rcx), .reg rdi p,
        .reg rsi (BitVec.ofNat 64 xs.length), .prop (wordsAt p xs), .reg rsp (s + 8#64),
        .mem s 8 r true, .prop (flagAny Flags.cf), .prop (flagAny Flags.pf),
        .prop (flagAny Flags.af), .prop (flagAny Flags.zf), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) := by
  cases xs with
  | nil =>
    iterate 2 braid_step
    braid_step
    · braid_run
      braid_forget 2
      braid_forget_flag 0
      braid_forget_flag 1
      braid_forget_flag 2
      braid_forget_flag 3
      braid_forget_flag 4
      braid_forget_flag 5
      simp only [wsum, List.foldl_nil, BitVec.xor_self]
      braid_done
    · exact absurd hbr (by simp)
  | cons x xs =>
    simp only [List.length_cons] at hl ⊢
    iterate 2 braid_step
    braid_step
    · exfalso
      have : BitVec.ofNat 64 (xs.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · iterate 2 braid_step
      simp only [BitVec.xor_self]
      braid_call sum_array_loop p (BitVec.ofNat 64 (xs.length + 1)) s r xs x 0#64 0#64
        _ _ _ _ _ _ (by simp) (by simp; omega)
      braid_forget 2
      braid_done

/-! ## On the machine -/

/-- **`max2` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `max2`, and has the return address `r` in the eight bytes at the
stack pointer, reaches `r` on every run, with the larger of `rdi` and `rsi` in `rax`. -/
theorem max2_correct [Layout] (m : MachineState) (r : Word) (hpc : m.pc = 0x401030)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        m'.data.regs.get64 .rax = umax (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound max2_holds
    (max2_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64 .rax)
      (m.data.regs.get64 .rsp) r m.data.status.cf m.data.status.pf m.data.status.af
      m.data.status.zf m.data.status.sf m.data.status.of)
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
      hret]))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    exact Atoms.reg_of_holds (r := 0) (v := umax _ _) hq (by braid_at)

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

/-- **`swap` on the machine.** A machine of the model that runs the executable of this image,
is at the entry of `swap`, has the words `x` and `y` in memory where `rdi` and `rsi` point,
and has the return address `r` in the eight bytes at the stack pointer, the three words
apart from one another, reaches `r` on every run, with `y` where `rdi` points and `x` where
`rsi` points. -/
theorem swap_correct [Layout] (m : MachineState) (x y r : Word) (hpc : m.pc = 0x401000)
    (hx : HasBytes m (m.data.regs.get64 .rdi) 8 x)
    (hy : HasBytes m (m.data.regs.get64 .rsi) 8 y)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hpq : 8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rdi).toNat)
    (hps : 8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsp).toNat ∧
      8 ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat)
    (hqs : 8 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rsp).toNat ∧
      8 ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rsi).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        HasBytes m' (m.data.regs.get64 .rdi) 8 y ∧
        HasBytes m' (m.data.regs.get64 .rsi) 8 x) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound swap_holds
    (swap_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) x y (m.data.regs.get64 .rax)
      (m.data.regs.get64 .rcx) (m.data.regs.get64 .rsp) r)
    (by simp [Atom.IsPointsTo])
    (by
      braid_disj
      repeat' constructor
      all_goals first | decide | exact Atom.disj_mem_mem_of_apart (by assumption))
    (by simp [Atom.sat_reg, Atom.sat_pc, sat_mem_abs, regOf, hpc, hret, hx, hy]))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · exact hasBytes_of_holds hr hq (by braid_at)
  · exact hasBytes_of_holds hr hq (by braid_at)

/-- **`max3` on the machine.** A machine of the model that runs the executable of this image,
is at the entry of `max3`, has the return address `r` in the eight bytes at the stack
pointer, and has memory in the sixteen bytes below them, reaches `r` on every run, with the
largest of `rdi`, `rsi` and `rdx` in `rax`, and `rbx` as it was. -/
theorem max3_correct [Layout] (m : MachineState) (r m0 m1 : Word) (hpc : m.pc = 0x401040)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hs0 : HasBytes m (m.data.regs.get64 .rsp - 8#64) 8 m0)
    (hs1 : HasBytes m (m.data.regs.get64 .rsp - 16#64) 8 m1) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        m'.data.regs.get64 .rax =
          umax (umax (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi))
            (m.data.regs.get64 .rdx) ∧
        m'.data.regs.get64 .rbx = m.data.regs.get64 .rbx) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound
    (fun p hp => (List.mem_append.1 hp).elim (max2_holds p) (max3_holds p))
    (max3_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64 .rdx)
      (m.data.regs.get64 .rax) (m.data.regs.get64 .rbx) (m.data.regs.get64 .rsp) r m0 m1
      m.data.status.cf m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf
      m.data.status.of)
    (by simp [Atom.IsPointsTo])
    (by
      braid_disj
      repeat' constructor
      all_goals first | decide | exact Atom.disj_mem_mem_of_apart (by bv_omega))
    (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
      hret, hs0, hs1]))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    exact Atoms.reg_of_holds (r := 0) (v := umax (umax _ _) _) hq (by braid_at)
  · rw [← hr.reg .rbx]
    exact Atoms.reg_of_holds (r := 1) hq (by braid_at)

/-- A word that starts at or beyond the end of an array, and ends before the array starts,
does not reach into it. -/
private theorem sep_array {s p : Word} {l : Nat} (h : l ≤ (s - p).toNat ∧ 8 ≤ (p - s).toNat)
    (x : Word) (hx : (x - s).toNat < 8) : ¬ (x - p).toNat < l := by
  bv_omega

/-- **`sum_array` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `sum_array`, has the words `xs` in memory where `rdi` points, with
their number in `rsi`, and has the return address `r` in the eight bytes at the stack
pointer, apart from the array, reaches `r` on every run, with the sum of the words in
`rax`. -/
theorem sum_array_correct [Layout] (m : MachineState) (xs : List Word) (r : Word)
    (hpc : m.pc = 0x401010)
    (hn : m.data.regs.get64 .rsi = BitVec.ofNat 64 xs.length)
    (hmem : ∀ (i : Nat) (hi : i < xs.length),
      HasBytes m (m.data.regs.get64 .rdi + BitVec.ofNat 64 (8 * i)) 8 xs[i])
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hsep : 8 * xs.length ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsp).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧ m'.data.regs.get64 .rax = wsum xs 0#64) m := by
  have hl : xs.length < 2 ^ 61 := by
    have : (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat < 2 ^ 64 := BitVec.isLt _
    omega
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat sum_array_holds
    (sum_array_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx)
      (m.data.regs.get64 .rsp) r xs m.data.status.cf m.data.status.pf m.data.status.af
      m.data.status.zf m.data.status.sf m.data.status.of hl)
    (flat := [.pc 0x401010#64, .reg rax (m.data.regs.get64 .rax),
      .reg rcx (m.data.regs.get64 .rcx), .reg rdi (m.data.regs.get64 .rdi),
      .reg rsi (BitVec.ofNat 64 xs.length)] ++ wordsAtoms (m.data.regs.get64 .rdi) xs ++
      [.reg rsp (m.data.regs.get64 .rsp), .mem (m.data.regs.get64 .rsp) 8 r true,
      .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
      .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
      .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of])
    (by rw [wordsAt_eq_interp]
        exact Atoms.interp_flatten [.pc 0x401010#64, .reg rax (m.data.regs.get64 .rax),
          .reg rcx (m.data.regs.get64 .rcx), .reg rdi (m.data.regs.get64 .rdi),
          .reg rsi (BitVec.ofNat 64 xs.length)] _ _)
    (Atoms.forall_flat (by simp [Atom.IsPointsTo]) wordsAtoms_isPointsTo)
    (Atoms.pairwise_flat (by braid_disj) (wordsAtoms_pairwise (by omega))
      (by
        braid_disj_array
        exact disj_mem_wordsAtoms (sep_array hsep) (by omega)))
    (Atoms.forall_flat
      (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
        hret, hn])
      (wordsAtoms_sat fun i hi => sat_mem_abs.2 (hmem i hi))))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    exact Atoms.reg_of_holds (r := 0) (v := wsum _ _) hq (by braid_at)

end Examples.Memory.X86
