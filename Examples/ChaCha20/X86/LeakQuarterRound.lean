/-
  Examples.ChaCha20.X86.LeakQuarterRound

  What `quarter_round` reveals on x86-64 (`docs/Leakage.md`): the addresses of the four
  words it works on, the stack pointer, where `ret` reads the return address, and the return
  address, where it goes. It reveals nothing of the four words: the code neither branches
  nor indexes on them.

  ## Main definitions

  * `quarter_round_run`: the trace of `quarter_round`, found by its run, with the traced
    triple; the trace is a function of the argument, the stack pointer and the return address
  * `quarterRoundLeak`: what `quarter_round` reveals, which is that trace

  ## Main results

  * `quarter_round_leakage`: the same, about the machine alone
  * `quarter_round_leakage_eq`: two machines that agree on the argument, the stack pointer
    and the return address run with the same trace
-/

module

public import Braid.Logic.Traced
public import Examples.ChaCha20.X86.QuarterRound

public section

namespace Examples.ChaCha20.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- **`quarter_round` and the trace of its run.** It works on the four words its argument
points to, and the trace is found by running it: it is a function of the argument `s`, the
stack pointer `sp₀` and the return address `r` alone, and of nothing the registers, the
flags or the four words hold. -/
def quarter_round_run (s sp₀ r : Word) : { ls : Trace // ∀ (t0 t2 t3 t4 : Word)
    (a b c d : W32) (fc fp fa fz fs fo : Bool) (t : Trace),
    TripleT quarter_round.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi s, .reg rax t0, .reg rcx t2, .reg rdx t3,
        .reg rsi t4, .reg rsp sp₀, .mem sp₀ 8 r true,
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (cellsAt 4 true s ([a, b, c, d].map (·.zeroExtend 64)))]) t
      (Atoms.interp [.pc r, .reg rdi s, .prop (regAny rax), .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .reg rsp (sp₀ + 8#64), .mem sp₀ 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true s ([(quarter a b c d).1, (quarter a b c d).2.1,
          (quarter a b c d).2.2.1, (quarter a b c d).2.2.2].map (·.zeroExtend 64)))])
      (t ++ ls) } := by
  braid_traced
  intro t0 t2 t3 t4 a b c d fc fp fa fz fs fo t
  rw [← qr_eq]
  simp only [qr]
  simp only [List.map_cons, List.map_nil]
  braid_unfold cells4 s _ _ _ _
  braid_sym_run
  simp only [zadd, zxor, trunc32_zext, zrol16, zrol12, zrol8, zrol7]
  braid_fold cells4 s _ _ _ _
  braid_forget 0
  braid_forget 2
  braid_forget 3
  braid_forget 4
  try braid_forget_flag 0
  try braid_forget_flag 1
  try braid_forget_flag 2
  try braid_forget_flag 3
  try braid_forget_flag 4
  try braid_forget_flag 5
  braid_done

/-- What `quarter_round` reveals: the addresses of the four words, each read and then
written, the stack pointer, where the return address is read, and the return address, where
it goes. It is the trace that the run of `quarter_round_run` finds. -/
def quarterRoundLeak (s sp r : Word) : Trace := (quarter_round_run s sp r).1

/-- The trace found, written out. -/
example (s sp r : Word) : quarterRoundLeak s sp r =
    [.read (s + 4#64) 4, .read s 4, .read (s + 12#64) 4, .read (s + 8#64) 4,
      .write s 4, .write (s + 4#64) 4, .write (s + 8#64) 4, .write (s + 12#64) 4,
      .read sp 8, .jump r] := rfl

/-- **What `quarter_round` reveals, on the machine.** A machine of the model that runs the
executable of this image, is at the entry of `quarter_round`, has the 32-bit words `a`, `b`,
`c` and `d` in memory where `rdi` points, and has the return address `r` in the eight bytes
at the stack pointer, apart from the four words, reaches `r` on every run, and the trace of
the run is `quarterRoundLeak` of `rdi`, the stack pointer and `r`. -/
theorem quarter_round_leakage [Layout] (m : MachineState) (a b c d : W32) (r : Word)
    (hpc : m.pc = 0x401000)
    (ha : HasBytes m (m.data.regs.get64 .rdi) 4 (a.zeroExtend 64))
    (hb : HasBytes m (m.data.regs.get64 .rdi + 4#64) 4 (b.zeroExtend 64))
    (hc : HasBytes m (m.data.regs.get64 .rdi + 8#64) 4 (c.zeroExtend 64))
    (hd : HasBytes m (m.data.regs.get64 .rdi + 12#64) 4 (d.zeroExtend 64))
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hsep : 16 ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsp).toNat) :
    RunL exe
      (fun m' u => u = quarterRoundLeak (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsp) r ∧
        m'.pc.toBitVec = r) m [] := by
  obtain ⟨hsep₁, hsep₂⟩ := hsep
  refine (machine_soundT quarter_round_holds
    ((quarter_round_run (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsp) r).2
      (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx) (m.data.regs.get64 .rdx)
      (m.data.regs.get64 .rsi) a b c d m.data.status.cf m.data.status.pf m.data.status.af
      m.data.status.zf m.data.status.sf m.data.status.of [])
    (Flat.interp (by braid_flat))
    (by simp [Atom.IsPointsTo, cellsAtoms])
    (by
      simp only [List.map_cons, List.map_nil, cellsAtoms, BitVec.add_assoc, BitVec.reduceAdd]
      braid_disj
      repeat' apply And.intro
      all_goals first
        | decide
        | with_reducible exact disj_ret_cell₀ hsep₁ hsep₂
        | ((with_reducible refine disj_ret_cell hsep₁ hsep₂ ?_); decide)
        | ((with_reducible refine disj_cell₀_cell ?_); decide)
        | ((with_reducible refine disj_cell_cell ?_); decide))
    (by simp [cellsAtoms, Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf,
      hpc, hret, ha, hb, hc, hd, BitVec.add_assoc])).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_⟩
  rw [← hr.pc]
  exact Atoms.pc_of_holds hq (by braid_at)

/-- **`quarter_round` reveals nothing of the words it works on.** Two machines that run the
executable of this image, are at the entry of `quarter_round`, and agree on `rdi`, the stack
pointer and the return address `r`, which each has at the stack pointer, apart from the
four words, have the same trace on every run, whatever four words each has where `rdi`
points. -/
theorem quarter_round_leakage_eq [Layout] (m₁ m₂ : MachineState)
    (a₁ b₁ c₁ d₁ a₂ b₂ c₂ d₂ : W32) (r : Word)
    (hpc₁ : m₁.pc = 0x401000) (hpc₂ : m₂.pc = 0x401000)
    (ha₁ : HasBytes m₁ (m₁.data.regs.get64 .rdi) 4 (a₁.zeroExtend 64))
    (hb₁ : HasBytes m₁ (m₁.data.regs.get64 .rdi + 4#64) 4 (b₁.zeroExtend 64))
    (hc₁ : HasBytes m₁ (m₁.data.regs.get64 .rdi + 8#64) 4 (c₁.zeroExtend 64))
    (hd₁ : HasBytes m₁ (m₁.data.regs.get64 .rdi + 12#64) 4 (d₁.zeroExtend 64))
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (ha₂ : HasBytes m₂ (m₂.data.regs.get64 .rdi) 4 (a₂.zeroExtend 64))
    (hb₂ : HasBytes m₂ (m₂.data.regs.get64 .rdi + 4#64) 4 (b₂.zeroExtend 64))
    (hc₂ : HasBytes m₂ (m₂.data.regs.get64 .rdi + 8#64) 4 (c₂.zeroExtend 64))
    (hd₂ : HasBytes m₂ (m₂.data.regs.get64 .rdi + 12#64) 4 (d₂.zeroExtend 64))
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hsep : 16 ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rsp).toNat)
    (edi : m₂.data.regs.get64 .rdi = m₁.data.regs.get64 .rdi)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := quarter_round_leakage m₁ a₁ b₁ c₁ d₁ r hpc₁ ha₁ hb₁ hc₁ hd₁ hret₁ hsep
  have h₂ := quarter_round_leakage m₂ a₂ b₂ c₂ d₂ r hpc₂ ha₂ hb₂ hc₂ hd₂ hret₂
    (by rw [edi, esp]; exact hsep)
  rw [edi, esp] at h₂
  exact ⟨_, h₁, h₂⟩

end Examples.ChaCha20.X86
