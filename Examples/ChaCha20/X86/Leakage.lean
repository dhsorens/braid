/-
  Examples.ChaCha20.X86.Leakage

  What `chacha20_block` reveals on x86-64, about the machine alone (`docs/Leakage.md`). The
  traced triple is `chacha20_block_trace` of `Examples.ChaCha20.X86.LeakBlock`; here it is
  carried to the machine model, and the two-run statement is drawn from it.

  The code neither branches nor indexes on the words of the state: its three loops run a
  fixed number of times, and every address is an offset from one of the two pointers or
  from the stack pointer. On x86-64 the return address is a word on the stack, which `ret`
  loads and jumps to. So the public inputs are the two pointers, the stack pointer and the
  return address, and the sixteen words of the input are secret, with whatever the output
  and the frame hold.

  ## Main results

  * `chacha20_block_leakage`: the trace of every run is `blockLeak` of the public inputs
  * `chacha20_block_leakage_eq`: two machines that agree on the public inputs run with the
    same trace, whatever the input, the output and the frame hold
-/

module

public import Examples.ChaCha20.X86.LeakBlock

public section

namespace Examples.ChaCha20.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- `chacha20_block_leakage`, with names for what `rdi`, `rsi` and `rsp` hold. -/
theorem chacha20_block_leakage_aux [Layout] (m : MachineState) (s : List W32)
    (os fr sv : List Word) (r out inp sp₀ : Word) (hpc : m.pc = 0x401040)
    (hout : m.data.regs.get64 .rdi = out) (hinp : m.data.regs.get64 .rsi = inp)
    (hsp : m.data.regs.get64 .rsp = sp₀) (hs : s.length = 16) (hos : os.length = 16)
    (hfr : fr.length = 21) (hsv : sv.length = 8)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes m (inp + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hdst : ∀ (i : Nat) (hi : i < os.length),
      HasBytes m (out + BitVec.ofNat 64 (4 * i)) 4 os[i])
    (hframe : ∀ (i : Nat) (hi : i < fr.length),
      HasBytes m (sp₀ - 148#64 + BitVec.ofNat 64 (4 * i)) 4 fr[i])
    (hsaved : ∀ (i : Nat) (hi : i < sv.length),
      HasBytes m (sp₀ - 64#64 + BitVec.ofNat 64 (8 * i)) 8 sv[i])
    (hret : HasBytes m sp₀ 8 r)
    (hio : 64 ≤ (out - inp).toNat ∧ 64 ≤ (inp - out).toNat)
    (his : 64 ≤ (sp₀ - 148#64 - inp).toNat ∧ 156 ≤ (inp - (sp₀ - 148#64)).toNat)
    (hos' : 64 ≤ (sp₀ - 148#64 - out).toNat ∧ 156 ≤ (out - (sp₀ - 148#64)).toNat) :
    RunL exe (fun m' u => u = blockLeak out inp sp₀ r ∧ m'.pc.toBitVec = r) m [] := by
  obtain ⟨⟨hi8₁, hi8₂⟩, hir₁, hir₂⟩ := apart_frame his.2
  obtain ⟨⟨ho8₁, ho8₂⟩, hor₁, hor₂⟩ := apart_frame hos'.2
  obtain ⟨⟨hf₁, hf₂⟩, ⟨hfr₁, hfr₂⟩, hsr₁, hsr₂⟩ := frame_apart sp₀
  have hrest : ∀ b ∈ ([.pc 0x401040#64, .reg rax (m.data.regs.get64 .rax),
      .reg rbx (m.data.regs.get64 .rbx), .reg rcx (m.data.regs.get64 .rcx),
      .reg rdx (m.data.regs.get64 .rdx), .reg rsi inp, .reg rdi out, .reg rsp sp₀,
      .reg rbp (m.data.regs.get64 .rbp), .reg r8 (m.data.regs.get64 .r8),
      .reg r9 (m.data.regs.get64 .r9), .reg r10 (m.data.regs.get64 .r10),
      .reg r11 (m.data.regs.get64 .r11), .reg r12 (m.data.regs.get64 .r12),
      .reg r13 (m.data.regs.get64 .r13), .reg r14 (m.data.regs.get64 .r14),
      .reg r15 (m.data.regs.get64 .r15), .flag Flags.cf m.data.status.cf,
      .flag Flags.pf m.data.status.pf, .flag Flags.af m.data.status.af,
      .flag Flags.zf m.data.status.zf, .flag Flags.sf m.data.status.sf,
      .flag Flags.of m.data.status.of] : Atoms), ∀ q n v w', Atom.Disj b (.mem q n v w') := by
    braid_not_mem
  refine (machine_soundT chacha20_block_holds
    (chacha20_block_trace out inp r sp₀ s os fr sv (m.data.regs.get64 .rax)
      (m.data.regs.get64 .rbx) (m.data.regs.get64 .rcx) (m.data.regs.get64 .rdx)
      (m.data.regs.get64 .rbp) (m.data.regs.get64 .r8) (m.data.regs.get64 .r9)
      (m.data.regs.get64 .r10) (m.data.regs.get64 .r11) (m.data.regs.get64 .r12)
      (m.data.regs.get64 .r13) (m.data.regs.get64 .r14) (m.data.regs.get64 .r15)
      m.data.status.cf m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf
      m.data.status.of hs hos hfr hsv [])
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2
      ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
        List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp [Atom.IsPointsTo]⟩⟩⟩⟩)
    (pairwise_cells_append (by simp [hs])
      (pairwise_cells_append (by simp [hos])
        (pairwise_cells_append (by simp [hfr])
          (pairwise_cells_append (by simp [hsv])
            (List.pairwise_cons.2 ⟨fun b hb => (hrest b hb _ _ _ _).symm, by
              braid_disj
              repeat' apply And.intro
              all_goals decide⟩)
            (disj_cons (disj_cellsAtoms_mem (by rw [hsv]; exact hsr₁) hsr₂)
              (disj_cellsAtoms_rest hrest)))
          (disj_append (cellsAtoms_disj (by rw [hfr]; exact hf₁) (by rw [hsv]; exact hf₂))
            (disj_cons (disj_cellsAtoms_mem (by rw [hfr]; exact hfr₁) hfr₂)
              (disj_cellsAtoms_rest hrest))))
        (disj_append
          (cellsAtoms_disj (by rw [hos]; exact hos'.1)
            (by rw [hfr]; exact Nat.le_trans (by decide) hos'.2))
          (disj_append (cellsAtoms_disj (by rw [hos]; exact ho8₁) (by rw [hsv]; exact ho8₂))
            (disj_cons (disj_cellsAtoms_mem (by rw [hos]; exact hor₁) hor₂)
              (disj_cellsAtoms_rest hrest)))))
      (disj_append
        (cellsAtoms_disj (by rw [List.length_map, hs]; exact hio.1) (by rw [hos]; exact hio.2))
        (disj_append
          (cellsAtoms_disj (by rw [List.length_map, hs]; exact his.1)
            (by rw [hfr]; exact Nat.le_trans (by decide) his.2))
          (disj_append
            (cellsAtoms_disj (by rw [List.length_map, hs]; exact hi8₁)
              (by rw [hsv]; exact hi8₂))
            (disj_cons (disj_cellsAtoms_mem (by rw [List.length_map, hs]; exact hir₁) hir₂)
              (disj_cellsAtoms_rest hrest))))))
    (List.forall_mem_append.2
      ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (by simpa using hin i (by simpa using hi)),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (hdst i hi),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (hframe i hi),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (hsaved i hi),
        by
          simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
            and_true, Atom.sat_reg, Atom.sat_flag, Atom.sat_pc]
          repeat' apply And.intro
          all_goals first
            | exact sat_mem_abs.2 hret | exact hout | exact hinp | exact hsp | rfl
            | (simp [hpc]; done)⟩⟩⟩⟩)).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_⟩
  rw [← hr.pc]
  exact Atoms.pc_of_holds hq (by braid_at)

/-- **What `chacha20_block` reveals, on the machine.** A machine of the model that runs the
executable of this image, is at the entry of `chacha20_block`, has the sixteen 32-bit words
`s` in memory where `rsi` points, sixteen 32-bit cells `os` where `rdi` points, the return
address `r` in the eight bytes at the stack pointer, and 148 bytes of memory below it (the
twenty-one 32-bit cells `fr` and the eight 64-bit cells `sv`), the input, the output and the
stack apart from one another, reaches `r` on every run, and the trace of the run is
`blockLeak` of `rdi`, `rsi`, the stack pointer and `r`. The trace does not mention `s`,
`os`, `fr` or `sv`. -/
theorem chacha20_block_leakage [Layout] (m : MachineState) (s : List W32)
    (os fr sv : List Word) (r : Word) (hpc : m.pc = 0x401040) (hs : s.length = 16)
    (hos : os.length = 16) (hfr : fr.length = 21) (hsv : sv.length = 8)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes m (m.data.regs.get64 .rsi + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hdst : ∀ (i : Nat) (hi : i < os.length),
      HasBytes m (m.data.regs.get64 .rdi + BitVec.ofNat 64 (4 * i)) 4 os[i])
    (hframe : ∀ (i : Nat) (hi : i < fr.length),
      HasBytes m (m.data.regs.get64 .rsp - 148#64 + BitVec.ofNat 64 (4 * i)) 4 fr[i])
    (hsaved : ∀ (i : Nat) (hi : i < sv.length),
      HasBytes m (m.data.regs.get64 .rsp - 64#64 + BitVec.ofNat 64 (8 * i)) 8 sv[i])
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hio : 64 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsi).toNat ∧
      64 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rdi).toNat)
    (his : 64 ≤ (m.data.regs.get64 .rsp - 148#64 - m.data.regs.get64 .rsi).toNat ∧
      156 ≤ (m.data.regs.get64 .rsi - (m.data.regs.get64 .rsp - 148#64)).toNat)
    (hos' : 64 ≤ (m.data.regs.get64 .rsp - 148#64 - m.data.regs.get64 .rdi).toNat ∧
      156 ≤ (m.data.regs.get64 .rdi - (m.data.regs.get64 .rsp - 148#64)).toNat) :
    RunL exe
      (fun m' u => u = blockLeak (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
        (m.data.regs.get64 .rsp) r ∧ m'.pc.toBitVec = r) m [] :=
  chacha20_block_leakage_aux m s os fr sv r (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
    (m.data.regs.get64 .rsp) hpc rfl rfl rfl hs hos hfr hsv hin hdst hframe hsaved hret hio
    his hos'

/-- **`chacha20_block` reveals nothing of the state it works on.** Two machines that run the
executable of this image, are at the entry of `chacha20_block`, and agree on `rdi`, `rsi`,
the stack pointer and the return address `r`, which each has at the stack pointer, with the
input, the output and the 148 bytes below the stack pointer in memory and apart as
`chacha20_block_leakage` asks, have the same trace on every run, whatever sixteen words each
has as input (`s₁`, `s₂`), and whatever each has in the output and below the stack
pointer. The second machine's regions are apart because its registers are the first's. -/
theorem chacha20_block_leakage_eq [Layout] (m₁ m₂ : MachineState) (s₁ s₂ : List W32)
    (os₁ fr₁ sv₁ os₂ fr₂ sv₂ : List Word) (r : Word)
    (hpc₁ : m₁.pc = 0x401040) (hpc₂ : m₂.pc = 0x401040)
    (hs₁ : s₁.length = 16) (hos₁ : os₁.length = 16) (hfr₁ : fr₁.length = 21)
    (hsv₁ : sv₁.length = 8)
    (hs₂ : s₂.length = 16) (hos₂ : os₂.length = 16) (hfr₂ : fr₂.length = 21)
    (hsv₂ : sv₂.length = 8)
    (hin₁ : ∀ (i : Nat) (hi : i < s₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rsi + BitVec.ofNat 64 (4 * i)) 4 (s₁[i].zeroExtend 64))
    (hdst₁ : ∀ (i : Nat) (hi : i < os₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rdi + BitVec.ofNat 64 (4 * i)) 4 os₁[i])
    (hframe₁ : ∀ (i : Nat) (hi : i < fr₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rsp - 148#64 + BitVec.ofNat 64 (4 * i)) 4 fr₁[i])
    (hsaved₁ : ∀ (i : Nat) (hi : i < sv₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rsp - 64#64 + BitVec.ofNat 64 (8 * i)) 8 sv₁[i])
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (hin₂ : ∀ (i : Nat) (hi : i < s₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rsi + BitVec.ofNat 64 (4 * i)) 4 (s₂[i].zeroExtend 64))
    (hdst₂ : ∀ (i : Nat) (hi : i < os₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rdi + BitVec.ofNat 64 (4 * i)) 4 os₂[i])
    (hframe₂ : ∀ (i : Nat) (hi : i < fr₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rsp - 148#64 + BitVec.ofNat 64 (4 * i)) 4 fr₂[i])
    (hsaved₂ : ∀ (i : Nat) (hi : i < sv₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rsp - 64#64 + BitVec.ofNat 64 (8 * i)) 8 sv₂[i])
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hio : 64 ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rsi).toNat ∧
      64 ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rdi).toNat)
    (his : 64 ≤ (m₁.data.regs.get64 .rsp - 148#64 - m₁.data.regs.get64 .rsi).toNat ∧
      156 ≤ (m₁.data.regs.get64 .rsi - (m₁.data.regs.get64 .rsp - 148#64)).toNat)
    (hos : 64 ≤ (m₁.data.regs.get64 .rsp - 148#64 - m₁.data.regs.get64 .rdi).toNat ∧
      156 ≤ (m₁.data.regs.get64 .rdi - (m₁.data.regs.get64 .rsp - 148#64)).toNat)
    (edi : m₂.data.regs.get64 .rdi = m₁.data.regs.get64 .rdi)
    (esi : m₂.data.regs.get64 .rsi = m₁.data.regs.get64 .rsi)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := chacha20_block_leakage m₁ s₁ os₁ fr₁ sv₁ r hpc₁ hs₁ hos₁ hfr₁ hsv₁ hin₁ hdst₁
    hframe₁ hsaved₁ hret₁ hio his hos
  have h₂ := chacha20_block_leakage m₂ s₂ os₂ fr₂ sv₂ r hpc₂ hs₂ hos₂ hfr₂ hsv₂ hin₂ hdst₂
    hframe₂ hsaved₂ hret₂ (by rw [edi, esi]; exact hio) (by rw [esi, esp]; exact his)
    (by rw [edi, esp]; exact hos)
  rw [edi, esi, esp] at h₂
  exact ⟨_, h₁, h₂⟩

end Examples.ChaCha20.X86
