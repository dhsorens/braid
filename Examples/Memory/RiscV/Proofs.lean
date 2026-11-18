/-
  Examples.Memory.RiscV.Proofs

  `memory.c` on RISC-V: loads and stores, a call with a stack frame, and a tail call.
-/

module

public import Examples.Memory.RiscV.Image
public import Lowering.RiscV.Logic

public section

namespace Examples.Memory.RiscV

open Braid Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- `swap` exchanges the two words its arguments point to. -/
theorem swap_spec (p q x y t2 t3 r : Word) (hp : p &&& 7#64 = 0#64) (hq : q &&& 7#64 = 0#64) :
    Triple swap.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 p, .reg a1 q, .reg a2 t2, .reg a3 t3,
        .mem p 8 x true, .mem q 8 y true, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 p, .reg a1 q, .reg a2 y, .reg a3 x,
        .mem p 8 y true, .mem q 8 x true, .reg ra r]) := by
  braid_run
  braid_done

/-- The larger of two words, unsigned. -/
def umax (a b : Word) : Word := if b.ult a then a else b

/-- `max2` returns the larger of its arguments. -/
theorem max2_spec (a b r : Word) :
    Triple max2.program
      (Atoms.interp [.pc 0x10044#64, .reg a0 a, .reg a1 b, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (umax a b), .reg a1 b, .reg ra r]) := by
  braid_step
  · braid_run
    exact Triple.done_eq (by simp [umax, hbr])
  · braid_run
    exact Triple.done_eq (by simp [umax, hbr])

/-- `max2` and `max3` together. -/
def prog : Program := Program.ofList (max2.blocks ++ max3.blocks)

theorem max2_spec' (a b r : Word) :
    Triple prog
      (Atoms.interp [.pc 0x10044#64, .reg a0 a, .reg a1 b, .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (umax a b), .reg a1 b, .reg ra r]) :=
  (max2_spec a b r).mono (Program.ofList_mono (fun _ h => List.mem_append_left _ h) (by decide))

/-- `max3` returns the largest of its arguments. It calls `max2`, keeping its third argument
in a callee-saved register across the call, and returns through a tail call. -/
theorem max3_spec (a b c s r v0 vt m0 m1 : Word) (hs : s &&& 7#64 = 0#64) :
    Triple prog
      (Atoms.interp [.pc 0x10050#64, .reg a0 a, .reg a1 b, .reg a2 c, .reg sp s, .reg ra r,
        .reg s0 v0, .reg t1 vt, .mem (s - 16#64) 8 m0 true, .mem (s - 8#64) 8 m1 true])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (umax (umax a b) c), .reg a1 c, .reg a2 c,
        .reg sp s, .reg ra r, .reg s0 v0, .reg t1 0x10078#64, .mem (s - 16#64) 8 v0 true,
        .mem (s - 8#64) 8 r true]) := by
  iterate 6 braid_step
  braid_call max2_spec' _ _ _
  iterate 6 braid_step
  braid_call max2_spec' _ _ _
  braid_done

end Examples.Memory.RiscV
