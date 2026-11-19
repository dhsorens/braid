/-
  Examples.Sha256.Arm.LeakSchedule

  What `sha256_schedule` reveals on AArch64 (`docs/Leakage.md`): a traced triple, by an
  induction on the cells left to fill. The theorem about the machine is in `LeakMachine`.

  ## Main definitions

  * `scheduleLeak`: what `sha256_schedule` reveals, from its pointer and the return address

  ## Main results

  * `schedule_loop_trace`: the loop reveals `scheduleLoopLeak`
  * `sha256_schedule_trace`: the code reveals `scheduleLeak`
-/

module

public import Examples.Sha256.Arm.Schedule
public import Examples.Sha256.Arm.LeakBase

public section

namespace Examples.Sha256.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- What `sha256_schedule` reveals, given the pointer `p` to the 64 words and the return
address `r`: 48 iterations of its loop, filling the cells from `p + 64` on, and the
return. -/
def scheduleLeak (p r : Word) : Trace :=
  scheduleLoopLeak 0x1007c#64 0x100b8#64 (p + 64#64) 47 ++ [.jump r]

/-- Forget what the loop of the schedule leaves in the registers it uses and in the flags. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 9; braid_forget 10; braid_forget 11; braid_forget 12
             braid_forget 13; braid_forget 14; braid_forget 15
             braid_forget_flag 0; braid_forget_flag 1; braid_forget_flag 2
             braid_forget_flag 3))

/-- Name the four words of the window that an iteration reads, and the cell it writes. -/
local macro "schedule_name " q:term : tactic =>
  `(tactic| (braid_name_mem ($q + 1#64); braid_name_mem ($q + 5#64)
             braid_name_mem ($q + 37#64); braid_name_mem ($q + 57#64)
             braid_name_mem ($q + 65#64)))

/-- Forget them again. -/
local macro "schedule_forget_mem " q:term : tactic =>
  `(tactic| (braid_forget_mem ($q + 1#64); braid_forget_mem ($q + 5#64)
             braid_forget_mem ($q + 37#64); braid_forget_mem ($q + 57#64)
             braid_forget_mem ($q + 65#64)))

/-- The loop of `sha256_schedule`: with a window of sixteen cells at `q` and `n + 1` cells
after it, whatever is in them, and the count `n + 1` of cells left in `x8`, it runs to the
return and reveals `scheduleLoopLeak` of the address of the first cell it fills and the
number of cells, and then the return address. -/
theorem schedule_loop_trace (p r : Word) : ∀ (n : Nat) (q c t10 t11 t12 t13 t14 t15 : Word)
    (fn fz fc fv : Bool) (t : Trace), c = BitVec.ofNat 64 (n + 1) → n + 1 < 2 ^ 64 →
    TripleT sha256_schedule.program
      (Atoms.interp [.pc 0x1007c#64, .reg x0 p, .reg x8 c, .reg x9 (q + 64#64),
        .reg x10 t10, .reg x11 t11, .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15,
        .reg lr r, .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 true q 16), .prop (cellsAny 4 true (q + 64#64) (n + 1))]) t
      (Atoms.interp [.pc r, .reg x0 p, .reg x8 0#64, .prop (regAny x9),
        .prop (regAny x10), .prop (regAny x11), .prop (regAny x12), .prop (regAny x13),
        .prop (regAny x14), .prop (regAny x15), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 true q 16), .prop (cellsAny 4 true (q + 64#64) (n + 1))])
      (t ++ (scheduleLoopLeak 0x1007c#64 0x100b8#64 (q + 64#64) n ++ [.jump r])) := by
  intro n
  induction n with
  | zero =>
    intro q c t10 t11 t12 t13 t14 t15 fn fz fc fv t he hb
    have he' : c = 1#64 := by simpa using he
    subst he'
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    simp only [scheduleLoopLeak, scheduleStepLeak]
    braid_unfold cellsAny16 true (q' + 1#64)
    braid_unfold cellsAny4_cons true (q' + 65#64) 0 (0 + 1) rfl
    schedule_name q'
    braid_sym_run
    schedule_forget_mem q'
    sha256_fold cellsAny16 true (q' + 1#64)
    sha256_fold cellsAny4_cons true (q' + 65#64) 0 (0 + 1) rfl
    schedule_forget
    sha256_done
  | succ n ih =>
    intro q c t10 t11 t12 t13 t14 t15 fn fz fc fv t he hb
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    simp only [scheduleLoopLeak, scheduleStepLeak]
    braid_unfold cellsAny16 true (q' + 1#64)
    braid_unfold cellsAny4_cons true (q' + 65#64) (n + 1) (n + 1 + 1) rfl
    schedule_name q'
    braid_sym_run
    · schedule_forget_mem q'
      sha256_fold cellsAny16 true (q' + 5#64)
      braid_call ih (q' + 5#64) (c + 18446744073709551615#64) _ _ _ _ _ _ _ _ _ _ _
        (by rw [he]; bv_omega) (by omega)
      braid_unfold cellsAny16 true (q' + 5#64)
      sha256_fold cellsAny16 true (q' + 1#64)
      sha256_fold cellsAny4_cons true (q' + 65#64) (n + 1) (n + 1 + 1) rfl
      sha256_done
    · exfalso
      have : c ≠ 1#64 := by rw [he]; bv_omega
      exact this hbr

/-- **What `sha256_schedule` reveals.** From the precondition of `sha256_schedule_spec`, the
code runs to its return and reveals `scheduleLeak` of the pointer and the return address:
the block `M` is not in the trace. The postcondition keeps where the 64 words are and
forgets what they hold. -/
theorem sha256_schedule_trace (p r t8 t9 t10 t11 t12 t13 t14 t15 : Word) (M : List W32)
    (js : List Word) (fn fz fc fv : Bool) (hM : M.length = 16) (hjs : js.length = 48)
    (t : Trace) :
    TripleT sha256_schedule.program
      (Atoms.interp [.pc 0x10074#64, .reg x0 p, .reg x8 t8, .reg x9 t9,
        .reg x10 t10, .reg x11 t11, .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15,
        .reg lr r, .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 true p (w32s M ++ js))]) t
      (Atoms.interp [.pc r, .reg x0 p, .reg x8 0#64, .prop (regAny x9),
        .prop (regAny x10), .prop (regAny x11), .prop (regAny x12), .prop (regAny x13),
        .prop (regAny x14), .prop (regAny x15), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v), .prop (cellsAny 4 true p 64)])
      (t ++ scheduleLeak p r) := by
  simp only [scheduleLeak]
  braid_forget_cells p, 64, (by simp [hM, hjs])
  braid_unfold cellsAny_pre16 true p 48 64 rfl
  sha256_fold cellsAny16 true p
  braid_sym_run_to 0x1007c
  braid_call schedule_loop_trace p r 47 p 48#64 _ _ _ _ _ _ _ _ _ _ _ rfl (by omega)
  braid_unfold cellsAny16 true p
  sha256_fold cellsAny_pre16 true p 48 64 rfl
  sha256_done

end Examples.Sha256.Arm
