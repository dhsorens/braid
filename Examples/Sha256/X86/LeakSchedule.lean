/-
  Examples.Sha256.X86.LeakSchedule

  What `sha256_schedule` reveals on x86-64 (`docs/Leakage.md`): a traced triple, by an
  induction on the cells left to fill. The code addresses the array from its start, with the
  index in `rax` scaled, so the loop is stated with the address of its window and an equation
  between that address and the index. The theorem about the machine is in `LeakMachine`.

  ## Main definitions

  * `scheduleLeak`: what `sha256_schedule` reveals, from its pointer, the stack pointer and
    the return address

  ## Main results

  * `schedule_loop_trace`: the loop reveals `scheduleLoopLeak`
  * `sha256_schedule_trace`: the code reveals `scheduleLeak`
-/

module

public import Examples.Sha256.X86.Schedule
public import Examples.Sha256.X86.LeakBase

public section

namespace Examples.Sha256.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- An index scaled by four, as the lowering writes it: the stepper finds a memory atom by
its address as a term, and `i * 4#64` as the elaborator reads it has another type
argument. -/
local notation:70 i:70 " *₄ " => @HMul.hMul Word Word Word _ i (BitVec.ofNat 64 4)

/-- What `sha256_schedule` reveals, given the pointer `p` to the 64 words, the stack pointer
`s` and the return address `r`: 48 iterations of its loop, filling the cells from `p + 64`
on, the return address read from the stack, and the return. -/
def scheduleLeak (p s r : Word) : Trace :=
  scheduleLoopLeak 0x4010b0#64 0x4010f4#64 (p + 64#64) 47 ++ [.read s 8, .jump r]

/-- Forget what the loop of the schedule leaves in the registers it uses and in the flags. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 2; braid_forget 3; braid_forget 4; braid_forget 8
             x86_forget_all_flags))

/-- Name the four words of the window that an iteration reads, and the cell it writes, with
`a` the address of the array less one and `i` the index. -/
local macro "schedule_name " a:term ", " i:term : tactic =>
  `(tactic| (braid_name_mem ($a + (1#64 + ($i *₄ + 0xfffffffffffffff8#64)))
             braid_name_mem ($a + (1#64 + ($i *₄ + 0xffffffffffffffe4#64)))
             braid_name_mem ($a + (1#64 + ($i *₄ + 0xffffffffffffffc4#64)))
             braid_name_mem ($a + (1#64 + ($i *₄ + 0xffffffffffffffc0#64)))
             braid_name_mem ($a + (1#64 + $i *₄))))

/-- Forget them again. -/
local macro "schedule_forget_mem " a:term ", " i:term : tactic =>
  `(tactic| (braid_forget_mem ($a + (1#64 + ($i *₄ + 0xfffffffffffffff8#64)))
             braid_forget_mem ($a + (1#64 + ($i *₄ + 0xffffffffffffffe4#64)))
             braid_forget_mem ($a + (1#64 + ($i *₄ + 0xffffffffffffffc4#64)))
             braid_forget_mem ($a + (1#64 + ($i *₄ + 0xffffffffffffffc0#64)))
             braid_forget_mem ($a + (1#64 + $i *₄))))

/-- The loop of `sha256_schedule`: with the index `i` in `rax`, a window of sixteen cells at
`b`, which is the address the code computes for index `i - 16` of the array at `p`, and
`n + 1` cells after the window, the last of them the last of the array, whatever is in them,
it runs to the return and reveals `scheduleLoopLeak` of the address of the first cell it
fills and the number of cells, and then the stack pointer and the return address. -/
theorem schedule_loop_trace (p s r : Word) : ∀ (n : Nat) (i b t2 t3 t4 t8 : Word)
    (c pf af z sg o : Bool) (t : Trace), p + i *₄ - 64#64 = b →
    i + BitVec.ofNat 64 (n + 1) = 64#64 → n + 1 ≤ 48 →
    TripleT sha256_schedule.program
      (Atoms.interp [.pc 0x4010b0#64, .reg rdi p, .reg rax i, .reg rcx t2, .reg rdx t3,
        .reg rsi t4, .reg r8 t8, .reg rsp s,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAny 4 true b 16), .prop (cellsAny 4 true (b + 64#64) (n + 1)),
        .prop (cellsAt 8 true s [r])]) t
      (Atoms.interp [.pc r, .reg rdi p, .reg rax 64#64, .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .prop (regAny r8), .reg rsp (s + 8#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true b 16), .prop (cellsAny 4 true (b + 64#64) (n + 1)),
        .prop (cellsAt 8 true s [r])])
      (t ++ (scheduleLoopLeak 0x4010b0#64 0x4010f4#64 (b + 64#64) n ++
        [.read s 8, .jump r])) := by
  intro n
  induction n with
  | zero =>
    intro i b t2 t3 t4 t8 c pf af z sg o t hb he hn
    subst hb
    obtain ⟨q, rfl⟩ : ∃ q : BitVec 64, p = q + 1#64 := ⟨p - 1#64, by bv_omega⟩
    simp only [scheduleLoopLeak, scheduleStepLeak]
    braid_unfold cellsAny16 true (q + 1#64 + i *₄ - 64#64)
    braid_unfold cellsAny4_cons true (q + 1#64 + i *₄ - 64#64 + 64#64) 0 (0 + 1) rfl
    braid_unfold cellsAt_cons (k := 8) (w := true) s r []
    schedule_name q, i
    braid_sym_run
    · exact absurd (by bv_omega) hbr
    · braid_sym_run
      schedule_forget_mem q, i
      refine tripleT_reg_val (r := 0) 64#64 (by braid_upd) (by bv_omega) ?_
      sha256_fold cellsAny16 true (q + 1#64 + i *₄ - 64#64)
      sha256_fold cellsAny4_cons true (q + 1#64 + i *₄ - 64#64 + 64#64) 0 (0 + 1) rfl
      sha256_fold cellsAt_cons (k := 8) (w := true) s r []
      schedule_forget
      sha256_leak_done
  | succ n ih =>
    intro i b t2 t3 t4 t8 c pf af z sg o t hb he hn
    subst hb
    obtain ⟨q, rfl⟩ : ∃ q : BitVec 64, p = q + 1#64 := ⟨p - 1#64, by bv_omega⟩
    simp only [scheduleLoopLeak, scheduleStepLeak]
    braid_unfold cellsAny16 true (q + 1#64 + i *₄ - 64#64)
    braid_unfold cellsAny4_cons true (q + 1#64 + i *₄ - 64#64 + 64#64) (n + 1) (n + 1 + 1) rfl
    schedule_name q, i
    braid_sym_run
    · schedule_forget_mem q, i
      sha256_fold cellsAny16 true (q + 1#64 + i *₄ - 60#64)
      x86_name_all_flags
      braid_call ih (i + 1#64) (q + 1#64 + i *₄ - 60#64) _ _ _ _ _ _ _ _ _ _ _ (by bv_omega)
        (by bv_omega) (by omega)
      braid_unfold cellsAny16 true (q + 1#64 + i *₄ - 60#64)
      sha256_fold cellsAny16 true (q + 1#64 + i *₄ - 64#64)
      sha256_fold cellsAny4_cons true (q + 1#64 + i *₄ - 64#64 + 64#64) (n + 1) (n + 1 + 1) rfl
      sha256_leak_done
    · exact absurd hbr (by bv_omega)

/-- **What `sha256_schedule` reveals.** From the precondition of `sha256_schedule_spec`, the
code runs to its return and reveals `scheduleLeak` of the pointer, the stack pointer and the
return address: the block `M` is not in the trace. The postcondition keeps where the 64
words are and forgets what they hold. -/
theorem sha256_schedule_trace (p s r t0 t2 t3 t4 t8 : Word) (M : List W32) (js : List Word)
    (c pf af z sg o : Bool) (hM : M.length = 16) (hjs : js.length = 48) (t : Trace) :
    TripleT sha256_schedule.program
      (Atoms.interp [.pc 0x4010a0#64, .reg rdi p, .reg rax t0, .reg rcx t2, .reg rdx t3,
        .reg rsi t4, .reg r8 t8, .reg rsp s,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true p (w32s M ++ js)), .prop (cellsAt 8 true s [r])]) t
      (Atoms.interp [.pc r, .reg rdi p, .reg rax 64#64, .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .prop (regAny r8), .reg rsp (s + 8#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true p 64), .prop (cellsAt 8 true s [r])])
      (t ++ scheduleLeak p s r) := by
  simp only [scheduleLeak]
  braid_forget_cells p, 64, (by simp [hM, hjs])
  braid_unfold cellsAny_pre16 true p 48 64 rfl
  sha256_fold cellsAny16 true p
  braid_sym_run_to 0x4010b0
  braid_call schedule_loop_trace p s r 47 16#64 p _ _ _ _ c pf af z sg o _ (by bv_omega)
    (by decide) (by omega)
  braid_unfold cellsAny16 true p
  sha256_fold cellsAny_pre16 true p 48 64 rfl
  sha256_leak_done

end Examples.Sha256.X86
