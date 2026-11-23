/-
  Examples.Sha256.RiscV.LeakSchedule

  What `sha256_schedule` reveals on RISC-V (`docs/Leakage.md`): a traced triple, by an
  induction on the cells left to fill. The theorem about the machine is in `LeakMachine`.

  ## Main definitions

  * `scheduleLeak`: what `sha256_schedule` reveals, from its pointer and the return address

  ## Main results

  * `schedule_loop_trace`: the loop reveals `scheduleLoopLeak`
  * `sha256_schedule_trace`: the code reveals `scheduleLeak`
-/

module

public import Examples.Sha256.RiscV.Schedule
public import Examples.Sha256.RiscV.LeakBase
import Braid.BV

public section

namespace Examples.Sha256.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- What `sha256_schedule` reveals, given the pointer `p` to the 64 words and the return
address `r`: 48 iterations of its loop, filling the cells from `p + 64` on, and the
return. -/
def scheduleLeak (p r : Word) : Trace :=
  scheduleLoopLeak 0x100ec#64 0x1015c#64 (p + 64#64) 47 ++ [.jump (r &&& ~~~1#64)]

/-- Forget what the loop of the schedule leaves in the registers it uses. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 12; braid_forget 13; braid_forget 14; braid_forget 15
             braid_forget 16; braid_forget 17; braid_forget 5; braid_forget 6))

/-- Name the four words of the window that an iteration reads, and the cell it writes. -/
local macro "schedule_name " q:term : tactic =>
  `(tactic| (sha256_name_mem ($q + 1#64); sha256_name_mem ($q + 5#64)
             sha256_name_mem ($q + 37#64); sha256_name_mem ($q + 57#64)
             sha256_name_mem ($q + 65#64)))

/-- Forget them again. -/
local macro "schedule_forget_mem " q:term : tactic =>
  `(tactic| (sha256_forget_mem ($q + 1#64); sha256_forget_mem ($q + 5#64)
             sha256_forget_mem ($q + 37#64); sha256_forget_mem ($q + 57#64)
             sha256_forget_mem ($q + 65#64)))

/-- The loop of `sha256_schedule`: with a window of sixteen cells at `q` and `n + 1` cells
after it, the last of them just before `e`, whatever is in them, it runs to the return and
reveals `scheduleLoopLeak` of the address of the first cell it fills and the number of
cells, and then the return address. -/
theorem schedule_loop_trace (e r : Word) : ∀ (n : Nat) (q x12 x13 x14 x15 x16 x17 x5 x6 : Word)
    (t : Trace), q &&& 3#64 = 0#64 →
    q + 64#64 + BitVec.ofNat 64 (4 * (n + 1)) = e → n + 1 ≤ 48 →
    TripleT sha256_schedule.program
      (Atoms.interp [.pc 0x100ec#64, .reg a0 e, .reg a1 (q + 64#64), .reg a2 x12,
        .reg a3 x13, .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5,
        .reg t1 x6, .reg ra r, .prop (cellsAny 4 true q 16),
        .prop (cellsAny 4 true (q + 64#64) (n + 1))]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 e, .reg a1 e, .prop (regAny a2),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .reg ra r,
        .prop (cellsAny 4 true q 16), .prop (cellsAny 4 true (q + 64#64) (n + 1))])
      (t ++ (scheduleLoopLeak 0x100ec#64 0x1015c#64 (q + 64#64) n ++
        [.jump (r &&& ~~~1#64)])) := by
  intro n
  induction n with
  | zero =>
    intro q x12 x13 x14 x15 x16 x17 x5 x6 t hq he hb
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    simp only [scheduleLoopLeak, scheduleStepLeak]
    braid_unfold cellsAny16 true (q' + 1#64)
    braid_unfold cellsAny4_cons true (q' + 65#64) 0 (0 + 1) rfl
    schedule_name q'
    braid_sym_run
    · exact absurd (by bv_omega) hbr
    · subst hbr
      braid_sym_run
      schedule_forget_mem q'
      sha256_fold cellsAny16 true (q' + 1#64)
      sha256_fold cellsAny4_cons true (q' + 65#64) 0 (0 + 1) rfl
      schedule_forget
      sha256_done
  | succ n ih =>
    intro q x12 x13 x14 x15 x16 x17 x5 x6 t hq he hb
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    simp only [scheduleLoopLeak, scheduleStepLeak]
    braid_unfold cellsAny16 true (q' + 1#64)
    braid_unfold cellsAny4_cons true (q' + 65#64) (n + 1) (n + 1 + 1) rfl
    schedule_name q'
    braid_sym_run
    · schedule_forget_mem q'
      sha256_fold cellsAny16 true (q' + 5#64)
      braid_call ih (q' + 5#64) _ _ _ _ _ _ _ _ _ (by bv_auto) (by rw [← he]; bv_omega)
        (by omega)
      braid_unfold cellsAny16 true (q' + 5#64)
      sha256_fold cellsAny16 true (q' + 1#64)
      sha256_fold cellsAny4_cons true (q' + 65#64) (n + 1) (n + 1 + 1) rfl
      sha256_done
    · exfalso
      rw [← hbr] at he
      bv_omega

/-- **What `sha256_schedule` reveals.** From the precondition of `sha256_schedule_spec`, the
code runs to its return and reveals `scheduleLeak` of the pointer and the return address:
the block `M` is not in the trace. The postcondition keeps where the 64 words are and
forgets what they hold. -/
theorem sha256_schedule_trace (p r x11 x12 x13 x14 x15 x16 x17 x5 x6 : Word) (M : List W32)
    (js : List Word) (hM : M.length = 16) (hjs : js.length = 48) (hp : p &&& 3#64 = 0#64)
    (t : Trace) :
    TripleT sha256_schedule.program
      (Atoms.interp [.pc 0x100e4#64, .reg a0 p, .reg a1 x11, .reg a2 x12, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg ra r, .prop (cellsAt 4 true p (w32s M ++ js))]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (p + 256#64), .prop (regAny a1),
        .prop (regAny a2), .prop (regAny a3), .prop (regAny a4), .prop (regAny a5),
        .prop (regAny a6), .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .reg ra r,
        .prop (cellsAny 4 true p 64)])
      (t ++ scheduleLeak p r) := by
  simp only [scheduleLeak]
  sha256_forget_cells p, 64, (by simp [hM, hjs])
  braid_unfold cellsAny_pre16 true p 48 64 rfl
  sha256_fold cellsAny16 true p
  braid_sym_run_to 0x100ec
  braid_call schedule_loop_trace (p + 256#64) r 47 p _ _ _ _ _ _ _ _ _ hp (by bv_omega)
    (by omega)
  braid_unfold cellsAny16 true p
  sha256_fold cellsAny_pre16 true p 48 64 rfl
  braid_forget 11
  sha256_done

end Examples.Sha256.RiscV
