/-
  Examples.Sha256.X86.Round

  `sha256_round` of `sha256.c` on x86-64: one round of the compression function of SHA-256,
  on the eight working variables in memory.

  The code is straight-line, between two pushes and two pops of callee-saved registers.
  Symbolic execution leaves each cell with the value the machine computed, a 64-bit
  expression; that its low 32 bits are the specification's is a separate goal about bit
  vectors for each cell, which `bv_auto` proves (`sha256_cell`).

  ## Main results

  * `sha256_round_spec`: the specification, with `roundKW`
  * `sha256_round_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256.X86.Image
public import Examples.Sha256.X86.Machine
public import Examples.Sha256.RunTo
import Braid.BV

public section

namespace Examples.Sha256.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- `sha256_round` replaces the working variables its first argument points to by one round
of them, with the round constant in the low half of its second argument and the word of the
schedule in the low half of its third. It saves `rbp` and `rbx` in the two words below the
stack pointer, and returns through the address on the stack. -/
theorem sha256_round_spec (p kk ww s r vb vp : Word) (v : Vars) (sv : List Word)
    (t0 t2 t8 t9 t10 t11 : Word) (c pf af z sg o : Bool) (hsv : sv.length = 2) :
    Triple sha256_round.program
      (Atoms.interp [.pc 0x401000#64, .reg rdi p, .reg rsi kk, .reg rdx ww, .reg rax t0,
        .reg rcx t2, .reg r8 t8, .reg r9 t9, .reg r10 t10, .reg r11 t11, .reg rbx vb,
        .reg rbp vp, .reg rsp s,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true p (w32s v.toList)), .prop (cellsAt 8 true (s - 16#64) sv),
        .prop (cellsAt 8 true s [r])])
      (Atoms.interp [.pc r, .reg rdi p, .prop (regAny rsi), .prop (regAny rdx),
        .prop (regAny rax), .prop (regAny rcx), .prop (regAny r8), .prop (regAny r9),
        .prop (regAny r10), .prop (regAny r11), .reg rbx vb, .reg rbp vp, .reg rsp (s + 8#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAt 4 true p (w32s (roundKW (kk.setWidth 32) (ww.setWidth 32) v).toList)),
        .prop (cellsAt 8 true (s - 16#64) [vb, vp]), .prop (cellsAt 8 true s [r])]) := by
  obtain ⟨m1, m0, rfl⟩ : ∃ m1 m0, sv = [m1, m0] := by
    match sv, hsv with
    | [m1, m0], _ => exact ⟨m1, m0, rfl⟩
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨q, rfl⟩ : ∃ q : BitVec 64, p = q + 1#64 := ⟨p - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 17#64 := ⟨s - 17#64, by bv_omega⟩
  braid_unfold cells_vars true (q + 1#64) v
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 1#64) m1 [m0]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 9#64) m0 []
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 17#64) r []
  braid_sym_run
  sha256_cell (q + 1#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).a.setWidth 64
  sha256_cell (q + 5#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).b.setWidth 64
  sha256_cell (q + 9#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).c.setWidth 64
  sha256_cell (q + 13#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).d.setWidth 64
  sha256_cell (q + 17#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).e.setWidth 64
  sha256_cell (q + 21#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).f.setWidth 64
  sha256_cell (q + 25#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).g.setWidth 64
  sha256_cell (q + 29#64), (roundKW (kk.setWidth 32) (ww.setWidth 32) v).h.setWidth 64
  sha256_fold cells_vars true (q + 1#64) (roundKW (kk.setWidth 32) (ww.setWidth 32) v)
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 9#64) vp []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 1#64) vb [vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 17#64) r []
  braid_forget 4
  braid_forget 3
  braid_forget 0
  braid_forget 2
  braid_forget 8
  braid_forget 9
  braid_forget 10
  braid_forget 11
  x86_forget_all_flags
  braid_done

/-! ## On the machine -/

/-- **`sha256_round` on the machine.** A machine of the model that runs the executable of
this image, is at the entry of `sha256_round`, has the eight working variables `v` in memory
where `rdi` points, the return address `r` in the eight bytes at the stack pointer and two
words of memory below them, the working variables apart from those 24 bytes of stack,
reaches `r` on every run, with one round of the working variables where `rdi` pointed: the
round whose constant is the low half of `rsi` and whose word of the schedule is the low half
of `rdx`. -/
theorem sha256_round_correct [Layout] (m : MachineState) (v : Vars) (r : Word) (sv : List Word)
    (hpc : m.pc = 0x401000) (hsv : sv.length = 2)
    (hv : HasCells m (m.data.regs.get64 .rdi) v.toList)
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hstk : HasWords m ((m.data.regs.get64 .rsp) - 16#64) sv)
    (hsep : Apart (m.data.regs.get64 .rdi) 32 ((m.data.regs.get64 .rsp) - 16#64) 24) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        HasCells m' (m.data.regs.get64 .rdi)
          (roundKW ((m.data.regs.get64 .rsi).setWidth 32) ((m.data.regs.get64 .rdx).setWidth 32)
            v).toList ∧
        m'.data.regs.get64 .rsp = (m.data.regs.get64 .rsp) + 8#64) m := by
  obtain ⟨hsep1, hsep2⟩ := hsep
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat sha256_round_holds
    (sha256_round_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64 .rdx)
      (m.data.regs.get64 .rsp) r (m.data.regs.get64 .rbx) (m.data.regs.get64 .rbp) v sv
      (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx) (m.data.regs.get64 .r8) (m.data.regs.get64
        .r9)
      (m.data.regs.get64 .r10) (m.data.regs.get64 .r11) m.data.status.cf m.data.status.pf
      m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of hsv)
    (flat := [.pc 0x401000#64, .reg rdi (m.data.regs.get64 .rdi), .reg rsi (m.data.regs.get64 .rsi),
      .reg rdx (m.data.regs.get64 .rdx), .reg rax (m.data.regs.get64 .rax),
      .reg rcx (m.data.regs.get64 .rcx), .reg r8 (m.data.regs.get64 .r8),
      .reg r9 (m.data.regs.get64 .r9), .reg r10 (m.data.regs.get64 .r10),
      .reg r11 (m.data.regs.get64 .r11), .reg rbx (m.data.regs.get64 .rbx),
      .reg rbp (m.data.regs.get64 .rbp), .reg rsp (m.data.regs.get64 .rsp),
      .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
      .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
      .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of] ++
      (cellsAtoms 4 true (m.data.regs.get64 .rdi) (w32s v.toList) ++
      (cellsAtoms 8 true ((m.data.regs.get64 .rsp) - 16#64) sv ++
      (cellsAtoms 8 true (m.data.regs.get64 .rsp) [r] ++ []))))
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨by simp [Atom.IsPointsTo],
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
      List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩⟩⟩)
    (pairwise_regs_mems (by sha256_disj) (by simp [NotMem])
      (List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms,
        List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩⟩⟩)
      (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [Vars.toList]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hsv]),
        List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp), .nil, disj_nil_right⟩,
        disj_append_right (cellsAtoms_disj (by simp [hsv]; bv_omega) (by simp; bv_omega))
          disj_nil_right⟩,
        disj_append_right
          (cellsAtoms_disj (by simp [Vars.toList]; bv_omega) (by simp [hsv]; bv_omega))
          (disj_append_right
            (cellsAtoms_disj (by simp [Vars.toList]; bv_omega) (by simp; bv_omega))
            disj_nil_right)⟩))
    (List.forall_mem_append.2
      ⟨by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, regOf, flagOf, hpc],
        List.forall_mem_append.2 ⟨hv.sat,
        List.forall_mem_append.2 ⟨hstk.sat,
        List.forall_mem_append.2 ⟨sat_word hret, by simp⟩⟩⟩⟩))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, hasCells_of_holds hr hq (by braid_at), ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rsp]
    exact Atoms.reg_of_holds (r := 6) hq (by braid_at)

end Examples.Sha256.X86
