/-
  Examples.ChaCha20.X86.QuarterRound

  `quarter_round` of `chacha20.c` on x86-64: the quarter round of ChaCha20 on four 32-bit
  words in memory. The symbolic execution ends in an expression of the four words, `qr`,
  which is the code's arithmetic read as arithmetic on 32-bit words; that it is
  `ChaCha20.quarter` is a separate lemma, proved by `bv_auto`.
-/

module

public import Examples.ChaCha20.X86.Image
public import Examples.ChaCha20.Common
import Braid.BV

@[expose] public section

namespace Examples.ChaCha20.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-! ## The expression -/

/-- What the code of `quarter_round` computes, as arithmetic on 32-bit words. -/
def qr (a b c d : W32) : W32 × W32 × W32 × W32 :=
  let a := b + a
  let d := (d ^^^ a).rotateLeft 16
  let c := d + c
  let b := (b ^^^ c).rotateLeft 12
  let a := b + a
  let d := (d ^^^ a).rotateLeft 8
  let c := d + c
  let b := (b ^^^ c).rotateLeft 7
  (a, b, c, d)

/-- The expression is the quarter round. -/
theorem qr_eq (a b c d : W32) : qr a b c d = quarter a b c d := by
  simp only [qr, quarter, Prod.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_⟩ <;> bv_auto

/-! ## The code -/

/-- `quarter_round` replaces the four 32-bit words its argument points to by their quarter
round, and returns through the address on the stack. -/
theorem quarter_round_spec (s r t0 t2 t3 t4 sp₀ : Word) (a b c d : W32)
    (fc fp fa fz fs fo : Bool) :
    Triple quarter_round.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi s, .reg rax t0, .reg rcx t2, .reg rdx t3,
        .reg rsi t4, .reg rsp sp₀, .mem sp₀ 8 r true,
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (cellsAt 4 true s ([a, b, c, d].map (·.zeroExtend 64)))])
      (Atoms.interp [.pc r, .reg rdi s, .prop (regAny rax), .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .reg rsp (sp₀ + 8#64), .mem sp₀ 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true s ([(quarter a b c d).1, (quarter a b c d).2.1,
          (quarter a b c d).2.2.1, (quarter a b c d).2.2.2].map (·.zeroExtend 64)))]) := by
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

/-! ## On the machine -/

/-- A machine related to a state with writable cells at the bytes of a word has those
bytes. -/
theorem hasBytes_of_cells {m : MachineState} {σ : State} (hr : Rel m σ) {a v : Word} {n : Nat}
    (hm : ∀ x : Word, (x - a).toNat < n →
      σ.mem x = some ⟨(v >>> ((x - a) <<< 3)).truncate 8, true⟩) : HasBytes m a n v := by
  intro x hx
  have hc := hm x hx
  rw [hr.data.mem] at hc
  obtain ⟨b, hb, hc⟩ := memOf_eq_some hc
  rw [hb]
  simpa using (congrArg Cell.val hc).symm

/-- The return address is disjoint from a 32-bit cell of sixteen bytes it is apart from. The
addresses are variables here: `bv_omega` does not see through the type of a register of the
machine model. -/
theorem disj_ret_cell {p q v v' off : Word} {w w' : Bool} (h₁ : 16 ≤ (q - p).toNat)
    (h₂ : 8 ≤ (p - q).toNat) (hoff : off.toNat ≤ 12) :
    Atom.Disj (.mem q 8 v w) (.mem (p + off) 4 v' w') := by
  refine Atom.disj_mem_mem fun x hx => ?_
  obtain ⟨hx1, hx2⟩ := hx
  bv_omega

theorem disj_ret_cell₀ {p q v v' : Word} {w w' : Bool} (h₁ : 16 ≤ (q - p).toNat)
    (h₂ : 8 ≤ (p - q).toNat) : Atom.Disj (.mem q 8 v w) (.mem p 4 v' w') := by
  refine Atom.disj_mem_mem fun x hx => ?_
  obtain ⟨hx1, hx2⟩ := hx
  bv_omega

theorem disj_cell₀_cell {p v v' off : Word} {w w' : Bool}
    (h : 4 ≤ off.toNat ∧ off.toNat ≤ 2 ^ 64 - 4) :
    Atom.Disj (.mem p 4 v w) (.mem (p + off) 4 v' w') := by
  refine Atom.disj_mem_mem fun x hx => ?_
  obtain ⟨hx1, hx2⟩ := hx
  bv_omega

/-- Two 32-bit cells at different multiples of four from an address are disjoint. -/
theorem disj_cell_cell {p v v' off off' : Word} {w w' : Bool}
    (h : 4 ≤ (off' - off).toNat ∧ 4 ≤ (off - off').toNat) :
    Atom.Disj (.mem (p + off) 4 v w) (.mem (p + off') 4 v' w') := by
  refine Atom.disj_mem_mem fun x hx => ?_
  obtain ⟨hx1, hx2⟩ := hx
  bv_omega

/-- **`quarter_round` on the machine.** A machine of the model that runs the executable of
this image, is at the entry of `quarter_round`, has the 32-bit words `a`, `b`, `c` and `d`
in memory where `rdi` points, and has the return address `r` in the eight bytes at the stack
pointer, apart from the four words, reaches `r` on every run, with the quarter round of the
four words where `rdi` pointed. -/
theorem quarter_round_correct [Layout] (m : MachineState) (a b c d : W32) (r : Word)
    (hpc : m.pc = 0x401000)
    (ha : HasBytes m (m.data.regs.get64 .rdi) 4 (a.zeroExtend 64))
    (hb : HasBytes m (m.data.regs.get64 .rdi + 4#64) 4 (b.zeroExtend 64))
    (hc : HasBytes m (m.data.regs.get64 .rdi + 8#64) 4 (c.zeroExtend 64))
    (hd : HasBytes m (m.data.regs.get64 .rdi + 12#64) 4 (d.zeroExtend 64))
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hsep : 16 ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsp).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        HasBytes m' (m.data.regs.get64 .rdi) 4 ((quarter a b c d).1.zeroExtend 64) ∧
        HasBytes m' (m.data.regs.get64 .rdi + 4#64) 4 ((quarter a b c d).2.1.zeroExtend 64) ∧
        HasBytes m' (m.data.regs.get64 .rdi + 8#64) 4
          ((quarter a b c d).2.2.1.zeroExtend 64) ∧
        HasBytes m' (m.data.regs.get64 .rdi + 12#64) 4
          ((quarter a b c d).2.2.2.zeroExtend 64)) m := by
  obtain ⟨hsep₁, hsep₂⟩ := hsep
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat quarter_round_holds
    (quarter_round_spec (m.data.regs.get64 .rdi) r (m.data.regs.get64 .rax)
      (m.data.regs.get64 .rcx) (m.data.regs.get64 .rdx) (m.data.regs.get64 .rsi)
      (m.data.regs.get64 .rsp) a b c d m.data.status.cf m.data.status.pf m.data.status.af
      m.data.status.zf m.data.status.sf m.data.status.of)
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
      hpc, hret, ha, hb, hc, hd, BitVec.add_assoc]))
  rintro m' ⟨σ', hr, hq⟩
  have h := fun i hi => hasBytes_of_cells hr
    (a := m.data.regs.get64 .rdi + BitVec.ofNat 64 (4 * i)) (n := 4)
    fun x hx => cell_of_holds hq (by braid_at) i hi hx
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · simpa using h 0 (by simp)
  · simpa using h 1 (by simp)
  · simpa using h 2 (by simp)
  · simpa using h 3 (by simp)

end Examples.ChaCha20.X86
