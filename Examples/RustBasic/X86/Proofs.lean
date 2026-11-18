/-
  Examples.RustBasic.X86.Proofs

  `basic.rs` on x86-64: straight-line code, a conditional move, and a loop over a slice
  that walks a byte offset. `gcd` divides (`div`), which the machine model does not have.
-/

module

public import Examples.RustBasic.X86.Image
public import Examples.Spec

public section

namespace Examples.RustBasic.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- `add3` returns the sum of its arguments. It sets the flags. -/
theorem add3_spec (a b d t s r : Word) (c pf af z sg o : Bool) :
    Triple add3.program
      (Atoms.interp [.pc 0x401010#64, .reg rdi a, .reg rsi b, .reg rdx d, .reg rax t,
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

/-- `max_u64` returns the larger of its arguments. It sets the flags. -/
theorem max_u64_spec (a b t s r : Word) (c pf af z sg o : Bool) :
    Triple max_u64.program
      (Atoms.interp [.pc 0x401050#64, .reg rdi a, .reg rsi b, .reg rax t, .reg rsp s,
        .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rdi a, .reg rsi b, .reg rax (umax a b), .reg rsp (s + 8#64),
        .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_run
  x86_forget_flags
  refine Triple.done_eq ?_
  simp only [umax, ofBool]
  by_cases h1 : a.ult b <;> by_cases h2 : a = b <;> simp_all
  all_goals bv_decide

/-- The loop of `sum_slice`, at byte offset `i`, with the words `x :: xs` still to add. -/
theorem sum_slice_loop (p e s r : Word) : ∀ (xs : List Word) (x i acc : Word)
    (c pf af z sg o : Bool), i + BitVec.ofNat 64 (8 * (xs.length + 1)) = e →
    i.toNat + 8 * (xs.length + 1) < 2 ^ 64 →
    Triple sum_slice.program
      (Atoms.interp [.pc 0x401070#64, .reg rax acc, .reg rcx i, .reg rdi p, .reg rsi e,
        .prop (wordsAt (p + i * 1#64) (x :: xs)), .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (wsum (x :: xs) acc), .reg rcx e, .reg rdi p, .reg rsi e,
        .prop (wordsAt (p + i * 1#64) (x :: xs)), .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  intro xs
  induction xs with
  | nil =>
    intro x i acc c pf af z sg o he hb
    have hn : e = i + 8#64 := by simpa using he.symm
    subst hn
    braid_unfold wordsAt_cons (p + i * 1#64) x []
    iterate 3 braid_step
    have e8 : 8#64 + i = i + 8#64 := by bv_decide
    braid_step
    · exact absurd (by bv_decide) hbr
    · braid_run
      braid_fold wordsAt_cons (p + i * 1#64) x []
      x86_forget_flags
      simp only [wsum, List.foldl_cons, List.foldl_nil, e8]
      braid_done
  | cons y ys ih =>
    intro x i acc c pf af z sg o he hb
    simp only [List.length_cons] at he hb
    braid_unfold wordsAt_cons (p + i * 1#64) x (y :: ys)
    iterate 3 braid_step
    braid_step
    · have e1 : p + (i * 1#64 + 8#64) = p + (8#64 + i) * 1#64 := by bv_decide
      rw [e1]
      braid_call ih y (8#64 + i) (x + acc) _ _ _ _ _ _ (by rw [← he]; bv_omega) (by bv_omega)
      rw [← e1]
      braid_fold wordsAt_cons (p + i * 1#64) x (y :: ys)
      simp only [wsum, List.foldl_cons]
      braid_done
    · exfalso
      have : e - (8#64 + i) ≠ 0#64 := by rw [← he]; bv_omega
      exact this (by simpa using hbr)

/-- `sum_slice` returns the sum of the words of a slice, given as a pointer and a length. -/
theorem sum_slice_spec (p t0 t1 s r : Word) (xs : List Word) (c pf af z sg o : Bool)
    (hl : xs.length < 2 ^ 61) :
    Triple sum_slice.program
      (Atoms.interp [.pc 0x401060#64, .reg rax t0, .reg rcx t1, .reg rdi p,
        .reg rsi (BitVec.ofNat 64 xs.length), .prop (wordsAt p xs), .reg rsp s,
        .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (wsum xs 0#64), .prop (regAny rcx), .reg rdi p,
        .prop (regAny rsi), .prop (wordsAt p xs), .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  cases xs with
  | nil =>
    simp only [List.length_nil]
    braid_run
    braid_forget 2
    braid_forget 4
    x86_forget_flags
    simp only [wsum, List.foldl_nil, BitVec.xor_self]
    braid_done
  | cons x xs =>
    simp only [List.length_cons] at hl ⊢
    braid_step
    braid_step
    · exfalso
      have : BitVec.ofNat 64 (xs.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · iterate 4 braid_step
      simp only [BitVec.xor_self]
      have he : 0#64 + BitVec.ofNat 64 (8 * (xs.length + 1)) =
          BitVec.ofNat 64 (xs.length + 1) <<< 3#64 := by
        apply BitVec.eq_of_toNat_eq
        simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
        omega
      braid_call sum_slice_loop p _ s r xs x 0#64 0#64 _ _ _ _ _ _ he (by simp; omega)
      braid_forget 2
      braid_forget 4
      braid_done

/-! ## On the machine -/

/-- **`add3` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `add3`, and has the return address `r` in the eight bytes at the
stack pointer, reaches `r` on every run, with the sum of `rdi`, `rsi` and `rdx` in `rax`. -/
theorem add3_correct [Layout] (m : MachineState) (r : Word) (hpc : m.pc = 0x401010)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        m'.data.regs.get64 .rax = 
          (m.data.regs.get64 .rdi) + (m.data.regs.get64 .rsi) + (m.data.regs.get64 .rdx)) m := by
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

/-- **`max_u64` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `max_u64`, and has the return address `r` in the eight bytes at the
stack pointer, reaches `r` on every run, with the larger of `rdi` and `rsi` in `rax`. -/
theorem max_u64_correct [Layout] (m : MachineState) (r : Word) (hpc : m.pc = 0x401050)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        m'.data.regs.get64 .rax = umax (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound max_u64_holds
    (max_u64_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64 .rax)
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

/-- A word that starts at or beyond the end of an array, and ends before the array starts,
does not reach into it. -/
private theorem sep_array {s p : Word} {l : Nat} (h : l ≤ (s - p).toNat ∧ 8 ≤ (p - s).toNat)
    (x : Word) (hx : (x - s).toNat < 8) : ¬ (x - p).toNat < l := by
  bv_omega

/-- **`sum_slice` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `sum_slice`, has the words `xs` in memory where `rdi` points, with
their number in `rsi`, and has the return address `r` in the eight bytes at the stack
pointer, apart from the array, reaches `r` on every run, with the sum of the words in
`rax`. -/
theorem sum_slice_correct [Layout] (m : MachineState) (xs : List Word) (r : Word)
    (hpc : m.pc = 0x401060)
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
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat sum_slice_holds
    (sum_slice_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx)
      (m.data.regs.get64 .rsp) r xs m.data.status.cf m.data.status.pf m.data.status.af
      m.data.status.zf m.data.status.sf m.data.status.of hl)
    (flat := [.pc 0x401060#64, .reg rax (m.data.regs.get64 .rax),
      .reg rcx (m.data.regs.get64 .rcx), .reg rdi (m.data.regs.get64 .rdi),
      .reg rsi (BitVec.ofNat 64 xs.length)] ++ wordsAtoms (m.data.regs.get64 .rdi) xs ++
      [.reg rsp (m.data.regs.get64 .rsp), .mem (m.data.regs.get64 .rsp) 8 r true,
      .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
      .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
      .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of])
    (by rw [wordsAt_eq_interp]
        exact Atoms.interp_flatten [.pc 0x401060#64, .reg rax (m.data.regs.get64 .rax),
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

end Examples.RustBasic.X86
