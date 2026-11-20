/-
  Examples.ChaCha20Vec.X86.Proofs

  `chacha20_vec.x86.S` on x86-64: the vectorised block function of ChaCha20, written by hand
  in AVX-512VL instructions, proved against the plain Lean specification of
  `Examples.Spec.ChaCha20`, the one the scalar code of `Examples.ChaCha20.X86` and the
  vectorised code of `Examples.ChaCha20Vec.Arm` are proved against, and carried down to the
  machine model.

  ## Main results

  * `rounds_spec`: the loop of ten double rounds on four vector registers, by induction
  * `chacha20_block_vec_spec`, `chacha20_block_vec_inplace_spec`: the block function, for an
    output apart from the input and for an output that is the input
  * `chacha20_block_vec_correct`, `chacha20_block_vec_inplace_correct`: the same, about the
    machine alone
-/

module

public import Examples.ChaCha20Vec.X86.Block

public section

namespace Examples.ChaCha20Vec.X86

open Braid Examples Examples.ChaCha20 Lowering.X86 Lowering.X86.Regs

/-- A machine related to a state with writable cells at the bytes of a word has those
bytes. -/
theorem hasBytes_of_cells {m : MachineState} {σ : State} (hr : Rel m σ) {a v : Word}
    {n : Nat} (hm : ∀ x : Word, (x - a).toNat < n →
      σ.mem x = some ⟨(v >>> ((x - a) <<< 3)).truncate 8, true⟩) : HasBytes m a n v := by
  intro x hx
  have hc := hm x hx
  rw [hr.data.mem] at hc
  obtain ⟨b, hb, hc⟩ := memOf_eq_some hc
  rw [hb]
  simpa using (congrArg Cell.val hc).symm

/-- The registers, flags and program counter of the precondition of `chacha20_block_vec`,
read off a machine state: no atom of them is a memory atom. -/
theorem rest_not_mem (m : MachineState) (o i sp : Word) :
    ∀ b ∈ ([.pc 0x401000#64, .reg rdi o, .reg rsi i, .reg rsp sp,
      .reg rax (m.data.regs.get64 .rax),
      .reg (zmm 0 0) (regOf m.data (zmm 0 0)), .reg (zmm 0 1) (regOf m.data (zmm 0 1)),
      .reg (zmm 0 2) (regOf m.data (zmm 0 2)), .reg (zmm 0 3) (regOf m.data (zmm 0 3)),
      .reg (zmm 0 4) (regOf m.data (zmm 0 4)), .reg (zmm 0 5) (regOf m.data (zmm 0 5)),
      .reg (zmm 0 6) (regOf m.data (zmm 0 6)), .reg (zmm 0 7) (regOf m.data (zmm 0 7)),
      .reg (zmm 1 0) (regOf m.data (zmm 1 0)), .reg (zmm 1 1) (regOf m.data (zmm 1 1)),
      .reg (zmm 1 2) (regOf m.data (zmm 1 2)), .reg (zmm 1 3) (regOf m.data (zmm 1 3)),
      .reg (zmm 1 4) (regOf m.data (zmm 1 4)), .reg (zmm 1 5) (regOf m.data (zmm 1 5)),
      .reg (zmm 1 6) (regOf m.data (zmm 1 6)), .reg (zmm 1 7) (regOf m.data (zmm 1 7)),
      .reg (zmm 2 0) (regOf m.data (zmm 2 0)), .reg (zmm 2 1) (regOf m.data (zmm 2 1)),
      .reg (zmm 2 2) (regOf m.data (zmm 2 2)), .reg (zmm 2 3) (regOf m.data (zmm 2 3)),
      .reg (zmm 2 4) (regOf m.data (zmm 2 4)), .reg (zmm 2 5) (regOf m.data (zmm 2 5)),
      .reg (zmm 2 6) (regOf m.data (zmm 2 6)), .reg (zmm 2 7) (regOf m.data (zmm 2 7)),
      .reg (zmm 3 0) (regOf m.data (zmm 3 0)), .reg (zmm 3 1) (regOf m.data (zmm 3 1)),
      .reg (zmm 3 2) (regOf m.data (zmm 3 2)), .reg (zmm 3 3) (regOf m.data (zmm 3 3)),
      .reg (zmm 3 4) (regOf m.data (zmm 3 4)), .reg (zmm 3 5) (regOf m.data (zmm 3 5)),
      .reg (zmm 3 6) (regOf m.data (zmm 3 6)), .reg (zmm 3 7) (regOf m.data (zmm 3 7)),
      .flag Flags.pf m.data.status.pf, .flag Flags.af m.data.status.af,
      .flag Flags.zf m.data.status.zf, .flag Flags.sf m.data.status.sf,
      .flag Flags.of m.data.status.of] : Atoms),
      ∀ q n v w', Atom.Disj b (.mem q n v w') := by
  braid_not_mem

/-- The registers, flags and program counter of the precondition of `chacha20_block_vec` are
apart from one another. -/
theorem rest_pairwise (m : MachineState) (o i sp : Word) :
    ([.pc 0x401000#64, .reg rdi o, .reg rsi i, .reg rsp sp,
      .reg rax (m.data.regs.get64 .rax),
      .reg (zmm 0 0) (regOf m.data (zmm 0 0)), .reg (zmm 0 1) (regOf m.data (zmm 0 1)),
      .reg (zmm 0 2) (regOf m.data (zmm 0 2)), .reg (zmm 0 3) (regOf m.data (zmm 0 3)),
      .reg (zmm 0 4) (regOf m.data (zmm 0 4)), .reg (zmm 0 5) (regOf m.data (zmm 0 5)),
      .reg (zmm 0 6) (regOf m.data (zmm 0 6)), .reg (zmm 0 7) (regOf m.data (zmm 0 7)),
      .reg (zmm 1 0) (regOf m.data (zmm 1 0)), .reg (zmm 1 1) (regOf m.data (zmm 1 1)),
      .reg (zmm 1 2) (regOf m.data (zmm 1 2)), .reg (zmm 1 3) (regOf m.data (zmm 1 3)),
      .reg (zmm 1 4) (regOf m.data (zmm 1 4)), .reg (zmm 1 5) (regOf m.data (zmm 1 5)),
      .reg (zmm 1 6) (regOf m.data (zmm 1 6)), .reg (zmm 1 7) (regOf m.data (zmm 1 7)),
      .reg (zmm 2 0) (regOf m.data (zmm 2 0)), .reg (zmm 2 1) (regOf m.data (zmm 2 1)),
      .reg (zmm 2 2) (regOf m.data (zmm 2 2)), .reg (zmm 2 3) (regOf m.data (zmm 2 3)),
      .reg (zmm 2 4) (regOf m.data (zmm 2 4)), .reg (zmm 2 5) (regOf m.data (zmm 2 5)),
      .reg (zmm 2 6) (regOf m.data (zmm 2 6)), .reg (zmm 2 7) (regOf m.data (zmm 2 7)),
      .reg (zmm 3 0) (regOf m.data (zmm 3 0)), .reg (zmm 3 1) (regOf m.data (zmm 3 1)),
      .reg (zmm 3 2) (regOf m.data (zmm 3 2)), .reg (zmm 3 3) (regOf m.data (zmm 3 3)),
      .reg (zmm 3 4) (regOf m.data (zmm 3 4)), .reg (zmm 3 5) (regOf m.data (zmm 3 5)),
      .reg (zmm 3 6) (regOf m.data (zmm 3 6)), .reg (zmm 3 7) (regOf m.data (zmm 3 7)),
      .flag Flags.pf m.data.status.pf, .flag Flags.af m.data.status.af,
      .flag Flags.zf m.data.status.zf, .flag Flags.sf m.data.status.sf,
      .flag Flags.of m.data.status.of] : Atoms).Pairwise Atom.Disj := by
  braid_disj
  repeat' apply And.intro
  all_goals decide

/-- `chacha20_block_vec_correct`, with names for what `rdi`, `rsi` and `rsp` hold. -/
theorem chacha20_block_vec_correct_aux [Layout] (m : MachineState) (s : List W32)
    (os : List Word) (r out inp sp : Word) (hpc : m.pc = 0x401000)
    (hout : m.data.regs.get64 .rdi = out) (hinp : m.data.regs.get64 .rsi = inp)
    (hsp : m.data.regs.get64 .rsp = sp) (hs : s.length = 16) (hos : os.length = 16)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes m (inp + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hdst : ∀ (i : Nat) (hi : i < os.length),
      HasBytes m (out + BitVec.ofNat 64 (4 * i)) 4 os[i])
    (hret : HasBytes m sp 8 r)
    (hio : 64 ≤ (out - inp).toNat ∧ 64 ≤ (inp - out).toNat)
    (his : 64 ≤ (sp - inp).toNat ∧ 8 ≤ (inp - sp).toNat)
    (hos' : 64 ≤ (sp - out).toNat ∧ 8 ≤ (out - sp).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        (∀ (i : Nat) (hi : i < (block s).length),
          HasBytes m' (out + BitVec.ofNat 64 (4 * i)) 4 ((block s)[i].zeroExtend 64)) ∧
        (∀ (i : Nat) (hi : i < s.length),
          HasBytes m' (inp + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64)) ∧
        m'.data.regs.get64 .rsp = sp + 8#64) m := by
  have hrest := rest_not_mem m out inp sp
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat chacha20_block_vec_holds
    (chacha20_block_vec_spec out inp r sp s os (m.data.regs.get64 .rax)
      (regOf m.data (zmm 0 0)) (regOf m.data (zmm 0 1)) (regOf m.data (zmm 0 2))
      (regOf m.data (zmm 0 3)) (regOf m.data (zmm 0 4)) (regOf m.data (zmm 0 5))
      (regOf m.data (zmm 0 6)) (regOf m.data (zmm 0 7))
      (regOf m.data (zmm 1 0)) (regOf m.data (zmm 1 1)) (regOf m.data (zmm 1 2))
      (regOf m.data (zmm 1 3)) (regOf m.data (zmm 1 4)) (regOf m.data (zmm 1 5))
      (regOf m.data (zmm 1 6)) (regOf m.data (zmm 1 7))
      (regOf m.data (zmm 2 0)) (regOf m.data (zmm 2 1)) (regOf m.data (zmm 2 2))
      (regOf m.data (zmm 2 3)) (regOf m.data (zmm 2 4)) (regOf m.data (zmm 2 5))
      (regOf m.data (zmm 2 6)) (regOf m.data (zmm 2 7))
      (regOf m.data (zmm 3 0)) (regOf m.data (zmm 3 1)) (regOf m.data (zmm 3 2))
      (regOf m.data (zmm 3 3)) (regOf m.data (zmm 3 4)) (regOf m.data (zmm 3 5))
      (regOf m.data (zmm 3 6)) (regOf m.data (zmm 3 7))
      m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf
      m.data.status.of hs hos)
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2
      ⟨cellsAtoms_isPointsTo, by simp [Atom.IsPointsTo]⟩⟩)
    (pairwise_cells_append (by simp [hs])
      (pairwise_cells_append (by simp [hos])
        (List.pairwise_cons.2 ⟨fun b hb => (hrest b hb _ _ _ _).symm,
          rest_pairwise m out inp sp⟩)
        (disj_cons (disj_cellsAtoms_mem (by rw [hos]; exact hos'.1) hos'.2)
          (disj_cellsAtoms_rest hrest)))
      (disj_append
        (cellsAtoms_disj (by rw [List.length_map, hs]; exact hio.1) (by rw [hos]; exact hio.2))
        (disj_cons (disj_cellsAtoms_mem (by rw [List.length_map, hs]; exact his.1) his.2)
          (disj_cellsAtoms_rest hrest))))
    (List.forall_mem_append.2
      ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (by simpa using hin i (by simpa using hi)),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (hdst i hi),
        by
          simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
            and_true, Atom.sat_reg, Atom.sat_flag, Atom.sat_pc]
          repeat' apply And.intro
          all_goals first
            | exact sat_mem_abs.2 hret | exact hout | exact hinp | exact hsp | rfl
            | (simp [hpc]; done)⟩⟩))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, fun i hi => ?_, fun i hi => ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · have hc := fun x => cell_of_holds (k := 4) (p := out)
      (vs := (block s).map (·.zeroExtend 64)) hq (by braid_at) i (by simpa using hi) (x := x)
    have h := hasBytes_of_cells hr (a := out + BitVec.ofNat 64 (4 * i)) (n := 4) hc
    simpa using h
  · have hc := fun x => cell_of_holds (k := 4) (p := inp)
      (vs := s.map (·.zeroExtend 64)) hq (by braid_at) i (by simpa using hi) (x := x)
    have h := hasBytes_of_cells hr (a := inp + BitVec.ofNat 64 (4 * i)) (n := 4) hc
    simpa using h
  · rw [← hr.reg .rsp]; exact Atoms.reg_of_holds (r := 6) hq (by braid_at)

/-- **`chacha20_block_vec` on the machine.** A machine of the model that runs the executable
of this image reaches the return address `r` on every run, with the ChaCha20 block function
of `s` where `rdi` pointed, `s` still where `rsi` pointed, and the stack pointer past the
return address. The hypotheses ask that

* `hpc`: the machine is at the entry of `chacha20_block_vec`;
* `hs`, `hin`: `s` is sixteen 32-bit words, and they are in memory from where `rsi` points,
  four bytes each, least significant byte first;
* `hos`, `hdst`: `os` is sixteen words, and their low four bytes are in memory from where
  `rdi` points, in sixteen cells of four bytes: whatever the output buffer holds;
* `hret`: the eight bytes at the stack pointer hold `r`;
* `hio`: the 64 bytes of the input and the 64 bytes of the output have no address in common;
* `his`, `hos'`: neither has an address in common with the eight bytes of the return
  address.

Each is of the form `n ≤ (b - a).toNat ∧ k ≤ (a - b).toNat`, which says that the `n` bytes
from `a` and the `k` bytes from `b` are apart, going round the address space. The code uses
no stack below the return address and asks no alignment. It loads every row of the input
before it stores any row of the output, and for an output that is the input there is
`chacha20_block_vec_inplace_correct`; an output that overlaps the input in part is not
covered. -/
theorem chacha20_block_vec_correct [Layout] (m : MachineState) (s : List W32)
    (os : List Word) (r : Word) (hpc : m.pc = 0x401000) (hs : s.length = 16)
    (hos : os.length = 16)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes m (m.data.regs.get64 .rsi + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hdst : ∀ (i : Nat) (hi : i < os.length),
      HasBytes m (m.data.regs.get64 .rdi + BitVec.ofNat 64 (4 * i)) 4 os[i])
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hio : 64 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsi).toNat ∧
      64 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rdi).toNat)
    (his : 64 ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rsp).toNat)
    (hos' : 64 ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsp).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        (∀ (i : Nat) (hi : i < (block s).length),
          HasBytes m' (m.data.regs.get64 .rdi + BitVec.ofNat 64 (4 * i)) 4
            ((block s)[i].zeroExtend 64)) ∧
        (∀ (i : Nat) (hi : i < s.length),
          HasBytes m' (m.data.regs.get64 .rsi + BitVec.ofNat 64 (4 * i)) 4
            (s[i].zeroExtend 64)) ∧
        m'.data.regs.get64 .rsp = m.data.regs.get64 .rsp + 8#64) m :=
  chacha20_block_vec_correct_aux m s os r (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
    (m.data.regs.get64 .rsp) hpc rfl rfl rfl hs hos hin hdst hret hio his hos'

/-- `chacha20_block_vec_inplace_correct`, with names for what `rsi` and `rsp` hold. -/
theorem chacha20_block_vec_inplace_correct_aux [Layout] (m : MachineState) (s : List W32)
    (r p sp : Word) (hpc : m.pc = 0x401000) (hout : m.data.regs.get64 .rdi = p)
    (hinp : m.data.regs.get64 .rsi = p) (hsp : m.data.regs.get64 .rsp = sp)
    (hs : s.length = 16)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes m (p + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hret : HasBytes m sp 8 r)
    (his : 64 ≤ (sp - p).toNat ∧ 8 ≤ (p - sp).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        (∀ (i : Nat) (hi : i < (block s).length),
          HasBytes m' (p + BitVec.ofNat 64 (4 * i)) 4 ((block s)[i].zeroExtend 64)) ∧
        m'.data.regs.get64 .rsp = sp + 8#64) m := by
  have hrest := rest_not_mem m p p sp
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat chacha20_block_vec_holds
    (chacha20_block_vec_inplace_spec p r sp s (m.data.regs.get64 .rax)
      (regOf m.data (zmm 0 0)) (regOf m.data (zmm 0 1)) (regOf m.data (zmm 0 2))
      (regOf m.data (zmm 0 3)) (regOf m.data (zmm 0 4)) (regOf m.data (zmm 0 5))
      (regOf m.data (zmm 0 6)) (regOf m.data (zmm 0 7))
      (regOf m.data (zmm 1 0)) (regOf m.data (zmm 1 1)) (regOf m.data (zmm 1 2))
      (regOf m.data (zmm 1 3)) (regOf m.data (zmm 1 4)) (regOf m.data (zmm 1 5))
      (regOf m.data (zmm 1 6)) (regOf m.data (zmm 1 7))
      (regOf m.data (zmm 2 0)) (regOf m.data (zmm 2 1)) (regOf m.data (zmm 2 2))
      (regOf m.data (zmm 2 3)) (regOf m.data (zmm 2 4)) (regOf m.data (zmm 2 5))
      (regOf m.data (zmm 2 6)) (regOf m.data (zmm 2 7))
      (regOf m.data (zmm 3 0)) (regOf m.data (zmm 3 1)) (regOf m.data (zmm 3 2))
      (regOf m.data (zmm 3 3)) (regOf m.data (zmm 3 4)) (regOf m.data (zmm 3 5))
      (regOf m.data (zmm 3 6)) (regOf m.data (zmm 3 7))
      m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf
      m.data.status.of hs)
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp [Atom.IsPointsTo]⟩)
    (pairwise_cells_append (by simp [hs])
      (List.pairwise_cons.2 ⟨fun b hb => (hrest b hb _ _ _ _).symm, rest_pairwise m p p sp⟩)
      (disj_cons (disj_cellsAtoms_mem (by rw [List.length_map, hs]; exact his.1) his.2)
        (disj_cellsAtoms_rest hrest)))
    (List.forall_mem_append.2
      ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (by simpa using hin i (by simpa using hi)),
        by
          simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
            and_true, Atom.sat_reg, Atom.sat_flag, Atom.sat_pc]
          repeat' apply And.intro
          all_goals first
            | exact sat_mem_abs.2 hret | exact hout | exact hinp | exact hsp | rfl
            | (simp [hpc]; done)⟩))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, fun i hi => ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · have hc := fun x => cell_of_holds (k := 4) (p := p)
      (vs := (block s).map (·.zeroExtend 64)) hq (by braid_at) i (by simpa using hi) (x := x)
    have h := hasBytes_of_cells hr (a := p + BitVec.ofNat 64 (4 * i)) (n := 4) hc
    simpa using h
  · rw [← hr.reg .rsp]; exact Atoms.reg_of_holds (r := 6) hq (by braid_at)

/-- **`chacha20_block_vec` on the machine, in place.** A machine of the model that runs the
executable of this image and whose two arguments are the same address reaches the return
address `r` on every run, with the ChaCha20 block function of `s` where `s` was, and the
stack pointer past the return address. The hypotheses ask that

* `hpc`: the machine is at the entry of `chacha20_block_vec`;
* `hsame`: `rdi` and `rsi` hold the same address;
* `hs`, `hin`: `s` is sixteen 32-bit words, and they are in memory from where `rsi` points,
  four bytes each, least significant byte first;
* `hret`: the eight bytes at the stack pointer hold `r`;
* `his`: the 64 bytes of the state and the eight bytes of the return address have no address
  in common. -/
theorem chacha20_block_vec_inplace_correct [Layout] (m : MachineState) (s : List W32)
    (r : Word) (hpc : m.pc = 0x401000)
    (hsame : m.data.regs.get64 .rdi = m.data.regs.get64 .rsi) (hs : s.length = 16)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes m (m.data.regs.get64 .rsi + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (his : 64 ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rsp).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        (∀ (i : Nat) (hi : i < (block s).length),
          HasBytes m' (m.data.regs.get64 .rsi + BitVec.ofNat 64 (4 * i)) 4
            ((block s)[i].zeroExtend 64)) ∧
        m'.data.regs.get64 .rsp = m.data.regs.get64 .rsp + 8#64) m :=
  chacha20_block_vec_inplace_correct_aux m s r (m.data.regs.get64 .rsi)
    (m.data.regs.get64 .rsp) hpc hsame rfl rfl hs hin hret his

end Examples.ChaCha20Vec.X86
