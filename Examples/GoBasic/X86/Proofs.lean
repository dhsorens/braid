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

/-- After `cmp a, b`, the condition `g` is the signed comparison. -/
theorem cond_g (a b : Word) :
    ((ofBool (a - b &&& 9223372036854775808#64 != 0#64) ^^^
        ofBool ((a ^^^ b) &&& (a ^^^ a - b) &&& 9223372036854775808#64 != 0#64) |||
      ofBool (a - b == 0#64)) == 0#64) = b.slt a := by
  simp only [ofBool]
  bv_decide

theorem cond_g_iff (a b : Word) :
    (ofBool (a - b &&& 9223372036854775808#64 != 0#64) ^^^
        ofBool ((a ^^^ b) &&& (a ^^^ a - b) &&& 9223372036854775808#64 != 0#64) |||
      ofBool (a - b == 0#64) = 0#64) ↔ b.slt a = true := by
  rw [← cond_g a b, beq_iff_eq]

/-- The loop of `main.SumSlice`, from index `i`, with `rest` still to add. -/
theorem main_SumSlice_loop (p len s r : Word) : ∀ (rest : List Word) (i acc : Word)
    (c pf af z sg o : Bool), i + BitVec.ofNat 64 rest.length = len → len.toNat < 2 ^ 61 →
    i.toNat + rest.length < 2 ^ 61 →
    Triple main_SumSlice.program
      (Atoms.interp [.pc 0x47a652#64, .reg rax p, .reg rbx len, .reg rcx i, .reg rdx acc,
        .prop (wordsAt (p + i * 8#64) rest), .reg rsp s, .mem s 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (wsum rest acc), .reg rbx len, .reg rcx len,
        .reg rdx (wsum rest acc), .prop (wordsAt (p + i * 8#64) rest), .reg rsp (s + 8#64),
        .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  intro rest
  induction rest with
  | nil =>
    intro i acc c pf af z sg o he hlen hi
    have hil : i = len := by simpa using he
    subst hil
    braid_step
    braid_step
    · rw [cond_g_iff] at hbr
      exact absurd hbr (by simp [BitVec.slt])
    · braid_run
      x86_forget_flags
      simp only [wsum, List.foldl_nil]
      braid_done
  | cons x xs ih =>
    intro i acc c pf af z sg o he hlen hi
    simp only [List.length_cons] at he hi
    braid_step
    braid_step
    · braid_unfold wordsAt_cons (p + i * 8#64) x xs
      iterate 2 braid_step
      have e : p + (i * 8#64 + 8#64) = p + (i + 1#64) * 8#64 := by bv_decide
      rw [e]
      braid_call ih (i + 1#64) (x + acc) _ _ _ _ _ _ (by rw [← he]; bv_omega) hlen
        (by bv_omega)
      rw [← e]
      braid_fold wordsAt_cons (p + i * 8#64) x xs
      simp only [wsum, List.foldl_cons]
      braid_done
    · exfalso
      rw [cond_g_iff] at hbr
      have : i.slt len = true := by
        have h1 : i < len := by rw [← he]; bv_omega
        have h2 : len < 2305843009213693952#64 := by bv_omega
        bv_decide
      exact hbr this

/-- `main.SumSlice` returns the sum of the words of a slice, given as a pointer and a length.
It saves the pointer in the caller's frame, above the return address. -/
theorem main_SumSlice_spec (p t0 t1 old s r : Word) (xs : List Word) (c pf af z sg o : Bool)
    (hl : xs.length < 2 ^ 61) :
    Triple main_SumSlice.program
      (Atoms.interp [.pc 0x47a640#64, .reg rax p, .reg rbx (BitVec.ofNat 64 xs.length),
        .reg rcx t0, .reg rdx t1, .prop (wordsAt p xs), .reg rsp s, .mem s 8 r true,
        .mem (s + 8#64) 8 old true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (wsum xs 0#64), .reg rbx (BitVec.ofNat 64 xs.length),
        .prop (regAny rcx), .prop (regAny rdx), .prop (wordsAt p xs), .reg rsp (s + 8#64),
        .mem s 8 r true, .mem (s + 8#64) 8 p true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  iterate 4 braid_step
  simp only [BitVec.xor_self]
  braid_call main_SumSlice_loop p (BitVec.ofNat 64 xs.length) s r xs 0#64 0#64 _ _ _ _ _ _
    (by simp) (by simp; omega) (by simp; omega)
  braid_forget 2
  braid_forget 3
  braid_done

/-! ## On the machine -/

/-- **`main.Add3` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `main.Add3`, and has the return address `r` in the eight bytes at the
stack pointer, reaches `r` on every run, with the sum of `rax`, `rbx` and `rcx`, the
registers Go passes arguments in, in `rax`. -/
theorem main_Add3_correct [Layout] (m : MachineState) (r : Word) (hpc : m.pc = 0x47a600)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        m'.data.regs.get64 .rax = 
          m.data.regs.get64 .rax + m.data.regs.get64 .rbx + m.data.regs.get64 .rcx) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound main_Add3_holds
    (main_Add3_spec (m.data.regs.get64 .rax) (m.data.regs.get64 .rbx) (m.data.regs.get64 .rcx)
      (m.data.regs.get64 .rdx) (m.data.regs.get64 .rsp) r)
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, sat_mem_abs, regOf, hpc,
      hret]))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    refine (Atoms.reg_of_holds (r := 0) hq (by braid_at)).trans ?_
    ac_rfl

/-- **`main.MaxU64` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `main.MaxU64`, and has the return address `r` in the eight bytes at the
stack pointer, reaches `r` on every run, with the larger of `rax` and `rbx` in
`rax`. -/
theorem main_MaxU64_correct [Layout] (m : MachineState) (r : Word) (hpc : m.pc = 0x47a620)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        m'.data.regs.get64 .rax = umax (m.data.regs.get64 .rax) (m.data.regs.get64 .rbx)) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound main_MaxU64_holds
    (main_MaxU64_spec (m.data.regs.get64 .rax) (m.data.regs.get64 .rbx) (m.data.regs.get64 .rsp) r
      m.data.status.cf m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf
      m.data.status.of)
    (by simp [Atom.IsPointsTo]) (by braid_disj)
    (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
      hret]))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    exact Atoms.reg_of_holds (r := 0) (v := umax _ _) hq (by braid_at)

/-- Two memory atoms are disjoint when each starts at or beyond the end of the other, going
round the address space. -/
private theorem disj_apart {a b v v' : Word} {n k : Nat} {w w' : Bool}
    (h : k ≤ (a - b).toNat ∧ n ≤ (b - a).toNat) :
    Atom.Disj (.mem a n v w) (.mem b k v' w') :=
  Atom.disj_mem_mem fun x hx => by bv_omega

/-- Neither of two words one after the other, which start at or beyond the end of an array
and end before the array starts, reaches into it. -/
private theorem sep_array_pair {s p : Word} {l : Nat}
    (h : l ≤ (s - p).toNat ∧ 16 ≤ (p - s).toNat) :
    (∀ x : Word, (x - s).toNat < 8 → ¬ (x - p).toNat < l) ∧
      ∀ x : Word, (x - (s + 8#64)).toNat < 8 → ¬ (x - p).toNat < l := by
  refine ⟨fun x hx => ?_, fun x hx => ?_⟩ <;> bv_omega

/-- **`main.SumSlice` on the machine.** A machine of the model that runs the executable of
this image, is at the entry of `main.SumSlice`, has the words `xs` in memory where `rax`
points, with their number in `rbx`, and has the return address `r` in the eight bytes at the
stack pointer and memory in the eight bytes above them, where Go saves the pointer, those
sixteen bytes apart from the array, reaches `r` on every run, with the sum of the words in
`rax`. -/
theorem main_SumSlice_correct [Layout] (m : MachineState) (xs : List Word) (old r : Word)
    (hpc : m.pc = 0x47a640)
    (hn : m.data.regs.get64 .rbx = BitVec.ofNat 64 xs.length)
    (hmem : ∀ (i : Nat) (hi : i < xs.length),
      HasBytes m (m.data.regs.get64 .rax + BitVec.ofNat 64 (8 * i)) 8 xs[i])
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hsave : HasBytes m (m.data.regs.get64 .rsp + 8#64) 8 old)
    (hsep : 8 * xs.length ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rax).toNat ∧
      16 ≤ (m.data.regs.get64 .rax - m.data.regs.get64 .rsp).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧ m'.data.regs.get64 .rax = wsum xs 0#64) m := by
  have hl : xs.length < 2 ^ 61 := by
    have : (m.data.regs.get64 .rsp - m.data.regs.get64 .rax).toNat < 2 ^ 64 := BitVec.isLt _
    omega
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat main_SumSlice_holds
    (main_SumSlice_spec (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx)
      (m.data.regs.get64 .rdx) old (m.data.regs.get64 .rsp) r xs m.data.status.cf
      m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of hl)
    (flat := [.pc 0x47a640#64, .reg rax (m.data.regs.get64 .rax),
      .reg rbx (BitVec.ofNat 64 xs.length), .reg rcx (m.data.regs.get64 .rcx),
      .reg rdx (m.data.regs.get64 .rdx)] ++ wordsAtoms (m.data.regs.get64 .rax) xs ++
      [.reg rsp (m.data.regs.get64 .rsp), .mem (m.data.regs.get64 .rsp) 8 r true,
      .mem (m.data.regs.get64 .rsp + 8#64) 8 old true,
      .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
      .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
      .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of])
    (by rw [wordsAt_eq_interp]
        exact Atoms.interp_flatten [.pc 0x47a640#64, .reg rax (m.data.regs.get64 .rax),
          .reg rbx (BitVec.ofNat 64 xs.length), .reg rcx (m.data.regs.get64 .rcx),
          .reg rdx (m.data.regs.get64 .rdx)] _ _)
    (Atoms.forall_flat (by simp [Atom.IsPointsTo]) wordsAtoms_isPointsTo)
    (Atoms.pairwise_flat
      (by
        braid_disj
        repeat' constructor
        all_goals first | decide | exact disj_apart (by bv_omega))
      (wordsAtoms_pairwise (by omega))
      (by
        braid_disj_array
        · exact disj_mem_wordsAtoms (sep_array_pair hsep).1 (by omega)
        · exact disj_mem_wordsAtoms (sep_array_pair hsep).2 (by omega)))
    (Atoms.forall_flat
      (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
        hret, hsave, hn])
      (wordsAtoms_sat fun i hi => sat_mem_abs.2 (hmem i hi))))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    exact Atoms.reg_of_holds (r := 0) (v := wsum _ _) hq (by braid_at)

end Examples.GoBasic.X86
