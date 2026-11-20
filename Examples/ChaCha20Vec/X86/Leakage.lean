/-
  Examples.ChaCha20Vec.X86.Leakage

  What `chacha20_block_vec` reveals on x86-64, about the machine alone
  (`docs/Leakage.md`). The traced triple is `block_vec_run` of
  `Examples.ChaCha20Vec.X86.LeakBlock`, whose trace the run found; here it is carried to the
  machine model, and the two-run statement is drawn from it.

  The code neither branches nor indexes on the words of the state: its loop runs ten times,
  and every address is an offset from one of the two pointers. It has no frame. On x86-64
  the return address is a word on the stack, which `ret` loads and jumps to. So the public
  inputs are the two pointers, the stack pointer and the return address, and the sixteen
  words of the input are secret, as is whatever the output and the vector registers hold.

  ## Main results

  * `chacha20_block_vec_leakage`: the trace of every run is `blockVecLeak` of the public
    inputs
  * `chacha20_block_vec_leakage_eq`: two machines that agree on the public inputs run with
    the same trace, whatever the input and the output hold
-/

module

public import Examples.ChaCha20Vec.X86.LeakBlock
public import Examples.ChaCha20Vec.X86.Proofs

public section

namespace Examples.ChaCha20Vec.X86

open Braid Examples Examples.ChaCha20 Lowering.X86 Lowering.X86.Regs

/-- `chacha20_block_vec_leakage`, with names for what `rdi`, `rsi` and `rsp` hold. -/
theorem chacha20_block_vec_leakage_aux [Layout] (m : MachineState) (s : List W32)
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
    RunL exe (fun m' u => u = blockVecLeak out inp sp r ∧ m'.pc.toBitVec = r) m [] := by
  have hrest := rest_not_mem m out inp sp
  refine (machine_soundT chacha20_block_vec_holds
    ((block_vec_run out inp sp r).2 s os (m.data.regs.get64 .rax)
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
      m.data.status.of [] hs hos)
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
            | (simp [hpc]; done)⟩⟩)).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_⟩
  rw [← hr.pc]
  exact Atoms.pc_of_holds hq (by braid_at)

/-- **What `chacha20_block_vec` reveals, on the machine.** A machine of the model that runs
the executable of this image reaches the return address `r` on every run, and the trace of
the run is `blockVecLeak` of `rdi`, `rsi`, the stack pointer and `r`, which
`blockVecLeak_eq` writes out. The trace does not mention `s` or `os`. The hypotheses are
those of `chacha20_block_vec_correct`:

* `hpc`: the machine is at the entry of `chacha20_block_vec`;
* `hs`, `hin`: `s` is sixteen 32-bit words, and they are in memory from where `rsi` points,
  four bytes each, least significant byte first;
* `hos`, `hdst`: `os` is sixteen words, and their low four bytes are in memory from where
  `rdi` points, in sixteen cells of four bytes: whatever the output buffer holds;
* `hret`: the eight bytes at the stack pointer hold `r`;
* `hio`: the 64 bytes of the input and the 64 bytes of the output have no address in common;
* `his`, `hos'`: neither has an address in common with the eight bytes of the return
  address. -/
theorem chacha20_block_vec_leakage [Layout] (m : MachineState) (s : List W32)
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
    RunL exe
      (fun m' u => u = blockVecLeak (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
        (m.data.regs.get64 .rsp) r ∧ m'.pc.toBitVec = r) m [] :=
  chacha20_block_vec_leakage_aux m s os r (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
    (m.data.regs.get64 .rsp) hpc rfl rfl rfl hs hos hin hdst hret hio his hos'

/-- **`chacha20_block_vec` reveals nothing of the state it works on.** Two machines that run
the executable of this image, are at the entry of `chacha20_block_vec`, and agree on `rdi`,
`rsi`, the stack pointer (`edi`, `esi`, `esp`) and the return address `r`, which each has at
the stack pointer, have the same trace on every run, whatever sixteen words each has as
input (`s₁`, `s₂`) and whatever each has in the output (`os₁`, `os₂`) and in its other
registers. Of each machine the hypotheses ask what `chacha20_block_vec_leakage` asks: it is
at the entry (`hpc₁`, `hpc₂`), its input is sixteen 32-bit words in memory where `rsi`
points (`hs₁`, `hin₁`, and the same of the second), its output is sixteen cells of four
bytes where `rdi` points (`hos₁`, `hdst₁`), and the return address is at the stack pointer
(`hret₁`). The input, the output and the return address are apart (`hio`, `his`, `hos`),
which is asked of the first machine and holds of the second since its registers are the
first's. -/
theorem chacha20_block_vec_leakage_eq [Layout] (m₁ m₂ : MachineState) (s₁ s₂ : List W32)
    (os₁ os₂ : List Word) (r : Word)
    (hpc₁ : m₁.pc = 0x401000) (hpc₂ : m₂.pc = 0x401000)
    (hs₁ : s₁.length = 16) (hos₁ : os₁.length = 16)
    (hs₂ : s₂.length = 16) (hos₂ : os₂.length = 16)
    (hin₁ : ∀ (i : Nat) (hi : i < s₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rsi + BitVec.ofNat 64 (4 * i)) 4
        (s₁[i].zeroExtend 64))
    (hdst₁ : ∀ (i : Nat) (hi : i < os₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rdi + BitVec.ofNat 64 (4 * i)) 4 os₁[i])
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (hin₂ : ∀ (i : Nat) (hi : i < s₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rsi + BitVec.ofNat 64 (4 * i)) 4
        (s₂[i].zeroExtend 64))
    (hdst₂ : ∀ (i : Nat) (hi : i < os₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rdi + BitVec.ofNat 64 (4 * i)) 4 os₂[i])
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hio : 64 ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rsi).toNat ∧
      64 ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rdi).toNat)
    (his : 64 ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rsp).toNat)
    (hos : 64 ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rsp).toNat)
    (edi : m₂.data.regs.get64 .rdi = m₁.data.regs.get64 .rdi)
    (esi : m₂.data.regs.get64 .rsi = m₁.data.regs.get64 .rsi)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := chacha20_block_vec_leakage m₁ s₁ os₁ r hpc₁ hs₁ hos₁ hin₁ hdst₁ hret₁ hio his
    hos
  have h₂ := chacha20_block_vec_leakage m₂ s₂ os₂ r hpc₂ hs₂ hos₂ hin₂ hdst₂ hret₂
    (by rw [edi, esi]; exact hio) (by rw [esi, esp]; exact his)
    (by rw [edi, esp]; exact hos)
  rw [edi, esi, esp] at h₂
  exact ⟨_, h₁, h₂⟩

end Examples.ChaCha20Vec.X86
