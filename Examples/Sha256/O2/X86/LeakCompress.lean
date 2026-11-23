/-
  Examples.Sha256.O2.X86.LeakCompress

  What `sha256_compress` reveals on x86-64, compiled at `-O2` (`docs/Leakage.md`): a traced
  triple. The trace is not that of `-O1`, because the code is not: the three loops that copy
  and the loop that adds are gone, and with them their branches and every access to a copy
  of the working variables on the stack, which is not kept; six registers are saved where
  five were; seven words of the hash value are kept below the schedule; the frame is 340
  bytes and the round constants are at `0x402320`. What is left is two loops, of the schedule
  and of the rounds, with straight-line code around them. So `compressLeak` is defined again
  here. It is still a function of the two pointers, the stack pointer and the return address,
  and of nothing else.

  The two loops are those of `Examples.Sha256.X86.LeakCompress`: the loop of the schedule
  with two addresses replaced, and the loop of rounds with its registers renamed and two
  addresses replaced; their proofs are the same text. What each iteration of them reveals
  (`scheduleLoopLeak` of `Examples.Sha256.X86.LeakBase`, `roundsLeak`) is the same function
  at `-O2`, given other addresses. The function itself is run again, with no loop to run out,
  in three triples (`compress_head_trace`, `compress_mid_trace`, `compress_tail_trace`), for
  the reason `sha256_compress_spec` at `-O2` has its exit as a triple of its own: one
  declaration that runs all of the code does not fit in the default limit on heartbeats,
  though nothing is said here of a value the code computes. The cuts are the ends of the two
  loops. The theorem about the machine is in `LeakMachine`.

  ## Main definitions

  * `roundsLeak`: what the loop of rounds reveals
  * `blockCopyLeak`: what the copy of the block to the stack reveals
  * `headLeak`, `midLeak`, `tailLeak`: what each of the three parts reveals
  * `compressLeak`: what `sha256_compress` reveals, from its two pointers, the stack pointer
    and the return address

  ## Main results

  * `compress_schedule_trace`, `compress_rounds_trace`: the loops
  * `compress_head_trace`, `compress_mid_trace`, `compress_tail_trace`: the parts
  * `sha256_compress_trace`: the code reveals `compressLeak`
-/

module

public import Examples.Sha256.O2.X86.Compress
public import Examples.Sha256.X86.LeakBase
import Braid.BV

@[expose] public section

namespace Examples.Sha256.O2.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs
open Examples.Sha256.X86

/-- A sum as the lowering writes it: the stepper finds a memory atom by its address as a
term, and `a + b` as the elaborator reads it may have other type arguments. -/
local notation:65 a:65 " +ₐ " b:66 => @HAdd.hAdd Word Word Word _ a b

/-- A product as the lowering writes it (see `+ₐ`). -/
local notation:70 a:70 " *ₐ " b:71 => @HMul.hMul Word Word Word _ a b

/-! ## What the code reveals -/

/-- What the loop of rounds reveals, with `n + 1` rounds left: each reads its word of the
schedule at `wa` and its round constant at `ka`, and branches back to `head` or on to
`exit`. -/
def roundsLeak (head exit : Word) (wa ka : Word) : Nat → Trace
  | 0 => [.read wa 4, .read ka 4, .jump exit]
  | n + 1 => [.read wa 4, .read ka 4, .jump head] ++
      roundsLeak head exit (wa + 4#64) (ka + 4#64) n

/-- What the copy of the block at `mp` to the start of the schedule, 312 bytes below the
stack pointer `s`, reveals: each of the sixteen words read and then written, in a line. -/
def blockCopyLeak (mp s : Word) : Trace :=
  [.read mp 4, .write (s - 312#64) 4, .read (mp + 4#64) 4, .write (s - 308#64) 4,
    .read (mp + 8#64) 4, .write (s - 304#64) 4, .read (mp + 12#64) 4, .write (s - 300#64) 4,
    .read (mp + 16#64) 4, .write (s - 296#64) 4, .read (mp + 20#64) 4, .write (s - 292#64) 4,
    .read (mp + 24#64) 4, .write (s - 288#64) 4, .read (mp + 28#64) 4, .write (s - 284#64) 4,
    .read (mp + 32#64) 4, .write (s - 280#64) 4, .read (mp + 36#64) 4, .write (s - 276#64) 4,
    .read (mp + 40#64) 4, .write (s - 272#64) 4, .read (mp + 44#64) 4, .write (s - 268#64) 4,
    .read (mp + 48#64) 4, .write (s - 264#64) 4, .read (mp + 52#64) 4, .write (s - 260#64) 4,
    .read (mp + 56#64) 4, .write (s - 256#64) 4, .read (mp + 60#64) 4, .write (s - 252#64) 4]

/-- What `sha256_compress` reveals to the end of the message schedule, given the pointer `mp`
to the block and the stack pointer `s`: six registers pushed, the block copied to the stack,
and the 48 words of the schedule filled. -/
def headLeak (mp s : Word) : Trace :=
  [.write (s - 8#64) 8, .write (s - 16#64) 8, .write (s - 24#64) 8, .write (s - 32#64) 8,
    .write (s - 40#64) 8, .write (s - 48#64) 8] ++
  blockCopyLeak mp s ++
  scheduleLoopLeak 0x401190#64 0x4011db#64 (s - 248#64) 47

/-- What `sha256_compress` reveals from the end of the message schedule to the end of the
loop of rounds, given the pointer `hp` to the hash value and the stack pointer `s`: the hash
value read and seven words of it written below the schedule, and the 64 rounds, each reading
a word of the schedule and a round constant. -/
def midLeak (hp s : Word) : Trace :=
  [.read hp 4, .read (hp + 4#64) 4, .read (hp + 8#64) 4, .read (hp + 12#64) 4,
    .read (hp + 16#64) 4, .read (hp + 20#64) 4, .read (hp + 24#64) 4, .read (hp + 28#64) 4,
    .write (s - 340#64) 4, .write (s - 336#64) 4, .write (s - 332#64) 4, .write (s - 328#64) 4,
    .write (s - 324#64) 4, .write (s - 320#64) 4, .write (s - 316#64) 4] ++
  roundsLeak 0x401230#64 0x4012c5#64 (s - 312#64) 0x402320#64 63

/-- What `sha256_compress` reveals from the end of the loop of rounds, given the pointer
`hp` to the hash value, the stack pointer `s` and the return address `r`: the hash value
written, with the seven words of it that were kept below the schedule read back to be added,
the six registers popped, the return address read from the stack, and the return. -/
def tailLeak (hp s r : Word) : Trace :=
  [.write hp 4, .read (s - 340#64) 4, .write (hp + 4#64) 4, .read (s - 336#64) 4,
    .write (hp + 8#64) 4, .read (s - 332#64) 4, .write (hp + 12#64) 4, .read (s - 328#64) 4,
    .write (hp + 16#64) 4, .read (s - 324#64) 4, .write (hp + 20#64) 4, .read (s - 320#64) 4,
    .write (hp + 24#64) 4, .read (s - 316#64) 4, .write (hp + 28#64) 4, .read (s - 48#64) 8,
    .read (s - 40#64) 8, .read (s - 32#64) 8, .read (s - 24#64) 8, .read (s - 16#64) 8,
    .read (s - 8#64) 8, .read s 8, .jump r]

/-- What `sha256_compress` reveals, given the pointer `hp` to the hash value, the pointer
`mp` to the block, the stack pointer `s` and the return address `r`: six registers pushed,
the block copied to the stack, the 48 words of the schedule filled, the hash value read and
seven words of it written below the schedule, the 64 rounds, each reading a word of the
schedule and a round constant, the hash value written, with those seven words read back to
be added, the registers popped, the return address read from the stack, and the return.
Every address is a constant or one of the three addresses plus a constant. -/
def compressLeak (hp mp s r : Word) : Trace :=
  headLeak mp s ++ midLeak hp s ++ tailLeak hp s r

/-! ## The loops -/

/-- Forget what the loop of the schedule leaves in the registers it uses and in the flags. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 0; braid_forget 2; braid_forget 3; braid_forget 4; braid_forget 8
             x86_forget_all_flags))

/-- Name the four words of the window that an iteration reads, and the cell it writes, with
the schedule 96 bytes below `sp` and the index `i`. -/
local macro "schedule_name " sp:term ", " i:term : tactic =>
  `(tactic| (braid_name_mem ($sp + ($i *ₐ 4#64 + 0xffffffffffffff98#64))
             braid_name_mem ($sp + ($i *ₐ 4#64 + 0xffffffffffffff84#64))
             braid_name_mem ($sp + ($i *ₐ 4#64 + 0xffffffffffffff64#64))
             braid_name_mem ($sp + ($i *ₐ 4#64 + 0xffffffffffffff60#64))
             braid_name_mem ($sp + ($i *ₐ 4#64 + 0xffffffffffffffa0#64))))

/-- Forget them again. -/
local macro "schedule_forget_mem " sp:term ", " i:term : tactic =>
  `(tactic| (braid_forget_mem ($sp + ($i *ₐ 4#64 + 0xffffffffffffff98#64))
             braid_forget_mem ($sp + ($i *ₐ 4#64 + 0xffffffffffffff84#64))
             braid_forget_mem ($sp + ($i *ₐ 4#64 + 0xffffffffffffff64#64))
             braid_forget_mem ($sp + ($i *ₐ 4#64 + 0xffffffffffffff60#64))
             braid_forget_mem ($sp + ($i *ₐ 4#64 + 0xffffffffffffffa0#64))))

/-- The loop of the message schedule in `sha256_compress`, where `sha256_schedule` is
inlined and the array is on the stack: with the index `i` in `rax`, a window of sixteen
cells at `b`, which is the address the code computes for index `i - 16` of the schedule 96
bytes below `sp`, and `n + 1` cells after the window, the last of them the last of the
schedule, whatever is in them. It reveals `scheduleLoopLeak` of the address of the first
cell it fills and the number of cells. -/
theorem compress_schedule_trace (sp : Word) : ∀ (n : Nat) (i b t2 t3 t4 t8 : Word)
    (c pf af z sg o : Bool) (t : Trace), sp +ₐ i *ₐ 4#64 - 160#64 = b →
    i + BitVec.ofNat 64 (n + 1) = 64#64 → n + 1 ≤ 48 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x401190#64, .reg rax i, .reg rcx t2, .reg rdx t3,
        .reg rsi t4, .reg r8 t8, .reg rsp sp,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAny 4 true b 16), .prop (cellsAny 4 true (b + 64#64) (n + 1))]) t
      (Atoms.interp [.pc 0x4011db#64, .prop (regAny rax), .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .prop (regAny r8), .reg rsp sp,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true b 16), .prop (cellsAny 4 true (b + 64#64) (n + 1))])
      (t ++ scheduleLoopLeak 0x401190#64 0x4011db#64 (b + 64#64) n) := by
  intro n
  induction n with
  | zero =>
    intro i b t2 t3 t4 t8 c pf af z sg o t hb he hn
    subst hb
    simp only [scheduleLoopLeak, scheduleStepLeak]
    braid_unfold cellsAny16 true (sp +ₐ i *ₐ 4#64 - 160#64)
    braid_unfold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 160#64 + 64#64) 0 (0 + 1) rfl
    schedule_name sp, i
    braid_sym_run_to 0x4011db
    · exact absurd (by bv_omega) hbr
    · schedule_forget_mem sp, i
      sha256_fold cellsAny16 true (sp +ₐ i *ₐ 4#64 - 160#64)
      sha256_fold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 160#64 + 64#64) 0 (0 + 1) rfl
      schedule_forget
      sha256_leak_done
  | succ n ih =>
    intro i b t2 t3 t4 t8 c pf af z sg o t hb he hn
    subst hb
    simp only [scheduleLoopLeak, scheduleStepLeak]
    braid_unfold cellsAny16 true (sp +ₐ i *ₐ 4#64 - 160#64)
    braid_unfold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 160#64 + 64#64) (n + 1) (n + 1 + 1) rfl
    schedule_name sp, i
    braid_sym_run_to 0x4011db
    · schedule_forget_mem sp, i
      sha256_fold cellsAny16 true (sp +ₐ i *ₐ 4#64 - 156#64)
      x86_name_all_flags
      braid_call ih (i + 1#64) (sp +ₐ i *ₐ 4#64 - 156#64) _ _ _ _ _ _ _ _ _ _ _ (by bv_omega)
        (by bv_omega) (by omega)
      braid_unfold cellsAny16 true (sp +ₐ i *ₐ 4#64 - 156#64)
      sha256_fold cellsAny16 true (sp +ₐ i *ₐ 4#64 - 160#64)
      sha256_fold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 160#64 + 64#64) (n + 1) (n + 1 + 1)
        rfl
      sha256_leak_done
    · exact absurd hbr (by bv_omega)

/-- Forget what a round leaves in the registers that hold the working variables, its
intermediate values and its index, and in the flags. -/
local macro "round_forget" : tactic =>
  `(tactic| (braid_forget 9; braid_forget 14; braid_forget 4; braid_forget 0
             braid_forget 8; braid_forget 13; braid_forget 12; braid_forget 2; braid_forget 15
             braid_forget 7; braid_forget 10; braid_forget 1
             x86_forget_all_flags))

/-- The loop of rounds in `sha256_compress`, where `sha256_round` is inlined and the working
variables are in registers: `n + 1` rounds, with the offset `o` of the round in `rax`, the
word of the schedule of the first of them at `wa` and its round constant at `ka`, which are
the addresses the code computes from `o` for the schedule 96 bytes below `sp` and the round
constants at `kp`, whatever the working variables, the round constants and the schedule are.
It reveals `roundsLeak` of the two addresses and the number of rounds: a round reads its
word and its constant, and no address or branch of it depends on a working variable. -/
theorem compress_rounds_trace (kp sp : Word) (wk : Bool) : ∀ (n : Nat)
    (o wa ka xa xb xc xd xe xf xg xh y9 y14 y4 : Word) (c pf af z sg ov : Bool) (t : Trace),
    sp +ₐ o *ₐ 1#64 - 96#64 = wa → o +ₐ kp *ₐ 1#64 = ka →
    o + BitVec.ofNat 64 (4 * (n + 1)) = 256#64 → n + 1 ≤ 64 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x401230#64, .reg r9 y9, .reg r14 y14, .reg rsi y4,
        .reg rax o, .reg rdx kp, .reg rsp sp,
        .reg r8 xa, .reg r13 xb, .reg r12 xc, .reg rcx xd, .reg r15 xe, .reg rbp xf,
        .reg r10 xg, .reg rbx xh,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of ov,
        .prop (cellsAny 4 true wa (n + 1)), .prop (cellsAny 4 wk ka (n + 1))]) t
      (Atoms.interp [.pc 0x4012c5#64, .prop (regAny r9), .prop (regAny r14),
        .prop (regAny rsi), .prop (regAny rax), .reg rdx kp, .reg rsp sp,
        .prop (regAny r8), .prop (regAny r13), .prop (regAny r12), .prop (regAny rcx),
        .prop (regAny r15), .prop (regAny rbp), .prop (regAny r10), .prop (regAny rbx),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true wa (n + 1)), .prop (cellsAny 4 wk ka (n + 1))])
      (t ++ roundsLeak 0x401230#64 0x4012c5#64 wa ka n) := by
  intro n
  induction n with
  | zero =>
    intro o wa ka xa xb xc xd xe xf xg xh y9 y14 y4 c pf af z sg ov t hw hk he hn
    subst hw hk
    simp only [roundsLeak]
    braid_unfold cellsAny4_cons true (sp +ₐ o *ₐ 1#64 - 96#64) 0 (0 + 1) rfl
    braid_unfold cellsAny4_cons wk (o +ₐ kp *ₐ 1#64) 0 (0 + 1) rfl
    braid_name_mem (sp + (o *ₐ 1#64 + 0xffffffffffffffa0#64))
    braid_name_mem (o + kp *ₐ 1#64)
    braid_sym_run_to 0x4012c5
    · exact absurd (by bv_omega) hbr
    · braid_forget_mem (sp + (o *ₐ 1#64 + 0xffffffffffffffa0#64))
      braid_forget_mem (o + kp *ₐ 1#64)
      sha256_fold cellsAny4_cons true (sp +ₐ o *ₐ 1#64 - 96#64) 0 (0 + 1) rfl
      sha256_fold cellsAny4_cons wk (o +ₐ kp *ₐ 1#64) 0 (0 + 1) rfl
      round_forget
      sha256_leak_done
  | succ n ih =>
    intro o wa ka xa xb xc xd xe xf xg xh y9 y14 y4 c pf af z sg ov t hw hk he hn
    subst hw hk
    simp only [roundsLeak]
    braid_unfold cellsAny4_cons true (sp +ₐ o *ₐ 1#64 - 96#64) (n + 1) (n + 1 + 1) rfl
    braid_unfold cellsAny4_cons wk (o +ₐ kp *ₐ 1#64) (n + 1) (n + 1 + 1) rfl
    braid_name_mem (sp + (o *ₐ 1#64 + 0xffffffffffffffa0#64))
    braid_name_mem (o + kp *ₐ 1#64)
    braid_sym_run_to 0x4012c5
    · braid_forget_mem (sp + (o *ₐ 1#64 + 0xffffffffffffffa0#64))
      braid_forget_mem (o + kp *ₐ 1#64)
      x86_name_all_flags
      braid_call ih (4#64 + o) (sp +ₐ o *ₐ 1#64 - 96#64 + 4#64) (o +ₐ kp *ₐ 1#64 + 4#64)
        _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by bv_omega) (by bv_omega) (by bv_omega) (by omega)
      sha256_fold cellsAny4_cons true (sp +ₐ o *ₐ 1#64 - 96#64) (n + 1) (n + 1 + 1) rfl
      sha256_fold cellsAny4_cons wk (o +ₐ kp *ₐ 1#64) (n + 1) (n + 1 + 1) rfl
      sha256_leak_done
    · exact absurd hbr (by bv_omega)

/-! ## The compression function -/

/-- Seven 32-bit cells of forgotten contents, as cells. -/
theorem cellsAny7 (w : Bool) (p : Word) :
    (Atom.prop (cellsAny 4 w p 7)).interp =
      Atoms.interp [.prop (memAny p 4 w), .prop (memAny (p + 4#64) 4 w),
        .prop (memAny (p + 8#64) 4 w), .prop (memAny (p + 12#64) 4 w),
        .prop (memAny (p + 16#64) 4 w), .prop (memAny (p + 20#64) 4 w),
        .prop (memAny (p + 24#64) 4 w)] := by
  show cellsAny 4 w p 7 = _
  simp only [cellsAny, Atoms.interp_cons, Atoms.interp_nil, BitVec.add_assoc, BitVec.reduceAdd]
  rfl

/-- Name the values of the sixteen words of the block. -/
local macro "block_name " q:term : tactic =>
  `(tactic| (braid_name_mem ($q + 1#64); braid_name_mem ($q + 5#64)
             braid_name_mem ($q + 9#64); braid_name_mem ($q + 13#64)
             braid_name_mem ($q + 17#64); braid_name_mem ($q + 21#64)
             braid_name_mem ($q + 25#64); braid_name_mem ($q + 29#64)
             braid_name_mem ($q + 33#64); braid_name_mem ($q + 37#64)
             braid_name_mem ($q + 41#64); braid_name_mem ($q + 45#64)
             braid_name_mem ($q + 49#64); braid_name_mem ($q + 53#64)
             braid_name_mem ($q + 57#64); braid_name_mem ($q + 61#64)))

/-- Forget them again. -/
local macro "block_forget " q:term : tactic =>
  `(tactic| (braid_forget_mem ($q + 1#64); braid_forget_mem ($q + 5#64)
             braid_forget_mem ($q + 9#64); braid_forget_mem ($q + 13#64)
             braid_forget_mem ($q + 17#64); braid_forget_mem ($q + 21#64)
             braid_forget_mem ($q + 25#64); braid_forget_mem ($q + 29#64)
             braid_forget_mem ($q + 33#64); braid_forget_mem ($q + 37#64)
             braid_forget_mem ($q + 41#64); braid_forget_mem ($q + 45#64)
             braid_forget_mem ($q + 49#64); braid_forget_mem ($q + 53#64)
             braid_forget_mem ($q + 57#64); braid_forget_mem ($q + 61#64)))

/-- Name the values of the first sixteen cells of the schedule. -/
local macro "window_name " q:term : tactic =>
  `(tactic| (braid_name_mem ($q + 29#64); braid_name_mem ($q + 33#64)
             braid_name_mem ($q + 37#64); braid_name_mem ($q + 41#64)
             braid_name_mem ($q + 45#64); braid_name_mem ($q + 49#64)
             braid_name_mem ($q + 53#64); braid_name_mem ($q + 57#64)
             braid_name_mem ($q + 61#64); braid_name_mem ($q + 65#64)
             braid_name_mem ($q + 69#64); braid_name_mem ($q + 73#64)
             braid_name_mem ($q + 77#64); braid_name_mem ($q + 81#64)
             braid_name_mem ($q + 85#64); braid_name_mem ($q + 89#64)))

/-- Forget them again. -/
local macro "window_forget " q:term : tactic =>
  `(tactic| (braid_forget_mem ($q + 29#64); braid_forget_mem ($q + 33#64)
             braid_forget_mem ($q + 37#64); braid_forget_mem ($q + 41#64)
             braid_forget_mem ($q + 45#64); braid_forget_mem ($q + 49#64)
             braid_forget_mem ($q + 53#64); braid_forget_mem ($q + 57#64)
             braid_forget_mem ($q + 61#64); braid_forget_mem ($q + 65#64)
             braid_forget_mem ($q + 69#64); braid_forget_mem ($q + 73#64)
             braid_forget_mem ($q + 77#64); braid_forget_mem ($q + 81#64)
             braid_forget_mem ($q + 85#64); braid_forget_mem ($q + 89#64)))

/-- Name the values of the eight words of the hash value. -/
local macro "vars_name " q:term : tactic =>
  `(tactic| (braid_name_mem ($q + 1#64); braid_name_mem ($q + 5#64)
             braid_name_mem ($q + 9#64); braid_name_mem ($q + 13#64)
             braid_name_mem ($q + 17#64); braid_name_mem ($q + 21#64)
             braid_name_mem ($q + 25#64); braid_name_mem ($q + 29#64)))

/-- Forget them again. -/
local macro "vars_forget " q:term : tactic =>
  `(tactic| (braid_forget_mem ($q + 1#64); braid_forget_mem ($q + 5#64)
             braid_forget_mem ($q + 9#64); braid_forget_mem ($q + 13#64)
             braid_forget_mem ($q + 17#64); braid_forget_mem ($q + 21#64)
             braid_forget_mem ($q + 25#64); braid_forget_mem ($q + 29#64)))

/-- Name the values of the seven words of the hash value kept in the frame. -/
local macro "kept_name " q:term : tactic =>
  `(tactic| (braid_name_mem ($q + 1#64); braid_name_mem ($q + 5#64)
             braid_name_mem ($q + 9#64); braid_name_mem ($q + 13#64)
             braid_name_mem ($q + 17#64); braid_name_mem ($q + 21#64)
             braid_name_mem ($q + 25#64)))

/-- Forget them again. -/
local macro "kept_forget " q:term : tactic =>
  `(tactic| (braid_forget_mem ($q + 1#64); braid_forget_mem ($q + 5#64)
             braid_forget_mem ($q + 9#64); braid_forget_mem ($q + 13#64)
             braid_forget_mem ($q + 17#64); braid_forget_mem ($q + 21#64)
             braid_forget_mem ($q + 25#64)))

/-- **What the entry of `sha256_compress` reveals**, to the end of the message schedule:
`headLeak` of the pointer to the block and the stack pointer, whatever the block and the 64
cells of the schedule hold. The six registers are saved below the stack pointer, which is
left 216 bytes down. -/
theorem compress_head_trace (mp s vb vp v12 v13 v14 v15 : Word) (wm : Bool) (sv : List Word)
    (t0 t2 t3 t8 : Word) (c pf af z sg o : Bool) (hsv : sv.length = 6) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x401100#64, .reg rsi mp, .reg rax t0, .reg rcx t2, .reg rdx t3,
        .reg r8 t8, .reg rbx vb, .reg rbp vp, .reg r12 v12, .reg r13 v13, .reg r14 v14,
        .reg r15 v15, .reg rsp s,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAny 4 wm mp 16), .prop (cellsAny 4 true (s - 312#64) 64),
        .prop (cellsAt 8 true (s - 48#64) sv)]) t
      (Atoms.interp [.pc 0x4011db#64, .prop (regAny rsi), .prop (regAny rax),
        .prop (regAny rcx), .prop (regAny rdx), .prop (regAny r8), .reg rbx vb, .reg rbp vp,
        .reg r12 v12, .reg r13 v13, .reg r14 v14, .reg r15 v15, .reg rsp (s - 216#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 wm mp 16), .prop (cellsAny 4 true (s - 312#64) 64),
        .prop (cellsAt 8 true (s - 48#64) [vb, v12, v13, v14, v15, vp])])
      (t ++ headLeak mp s) := by
  obtain ⟨s0, s1, s2, s3, s4, s5, rfl⟩ : ∃ s0 s1 s2 s3 s4 s5, sv = [s0, s1, s2, s3, s4, s5] := by
    match sv, hsv with
    | [s0, s1, s2, s3, s4, s5], _ => exact ⟨s0, s1, s2, s3, s4, s5, rfl⟩
  simp only [headLeak, blockCopyLeak]
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨mq, rfl⟩ : ∃ mq : BitVec 64, mp = mq + 1#64 := ⟨mp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 341#64 := ⟨s - 341#64, by bv_omega⟩
  braid_unfold cellsAny16 wm (mq + 1#64)
  braid_unfold cellsAny_pre16 true (sq + 29#64) 48 64 rfl
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 293#64) s0 [s1, s2, s3, s4, s5]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 301#64) s1 [s2, s3, s4, s5]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 309#64) s2 [s3, s4, s5]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 317#64) s3 [s4, s5]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 325#64) s4 [s5]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 333#64) s5 []
  -- The registers saved, and the block copied to the start of the schedule.
  block_name mq
  window_name sq
  braid_sym_run_to 0x401190
  block_forget mq
  window_forget sq
  sha256_fold cellsAny16 wm (mq + 1#64)
  sha256_fold cellsAny16 true (sq + 29#64)
  x86_name_all_flags
  -- The message schedule.
  braid_call compress_schedule_trace (sq + 125#64) 47 16#64 (sq + 29#64) _ _ _ _ _ _ _ _ _ _
    _ (by bv_omega) (by decide) (by omega)
  braid_unfold cellsAny16 true (sq + 29#64)
  sha256_fold cellsAny_pre16 true (sq + 29#64) 48 64 rfl
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 333#64) vp []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 325#64) v15 [vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 317#64) v14 [v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 309#64) v13 [v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 301#64) v12 [v13, v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 293#64) vb [v12, v13, v14, v15, vp]
  sha256_leak_done

/-- **What the middle of `sha256_compress` reveals**, from the end of the message schedule to
the end of the loop of rounds: `midLeak` of the pointer to the hash value and the stack
pointer, whatever the hash value, the schedule and the round constants are. -/
theorem compress_mid_trace (hp s : Word) (wk : Bool)
    (t0 t2 t3 t4 t8 t9 t10 t11 y1 y7 y12 y13 y14 y15 : Word) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x4011db#64, .reg rdi hp, .reg rsi t4, .reg rax t0, .reg rcx t2,
        .reg rdx t3, .reg r8 t8, .reg r9 t9, .reg r10 t10, .reg r11 t11, .reg rbx y1,
        .reg rbp y7, .reg r12 y12, .reg r13 y13, .reg r14 y14, .reg r15 y15,
        .reg rsp (s - 216#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 wk 0x402320#64 64),
        .prop (cellsAny 4 true (s - 340#64) 7), .prop (cellsAny 4 true (s - 312#64) 64)]) t
      (Atoms.interp [.pc 0x4012c5#64, .reg rdi hp, .prop (regAny rsi), .prop (regAny rax),
        .prop (regAny rcx), .reg rdx 0x402320#64, .prop (regAny r8), .prop (regAny r9),
        .prop (regAny r10), .prop (regAny r11), .prop (regAny rbx), .prop (regAny rbp),
        .prop (regAny r12), .prop (regAny r13), .prop (regAny r14), .prop (regAny r15),
        .reg rsp (s - 216#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 wk 0x402320#64 64),
        .prop (cellsAny 4 true (s - 340#64) 7), .prop (cellsAny 4 true (s - 312#64) 64)])
      (t ++ midLeak hp s) := by
  simp only [midLeak]
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 341#64 := ⟨s - 341#64, by bv_omega⟩
  -- The hash value loaded into registers, and seven words of it stored in the frame.
  braid_unfold cellsAny8 true (hq + 1#64)
  braid_unfold cellsAny7 true (sq + 1#64)
  vars_name hq
  kept_name sq
  braid_sym_run_to 0x4011f9
  refine tripleT_reg_val (r := 0) 0#64 (by braid_upd) (by bv_auto) ?_
  braid_sym_run_to 0x401230
  vars_forget hq
  kept_forget sq
  sha256_fold cellsAny8 true (hq + 1#64)
  sha256_fold cellsAny7 true (sq + 1#64)
  x86_name_all_flags
  -- The rounds.
  braid_call compress_rounds_trace 0x402320#64 (sq + 125#64) wk 63 0#64 (sq + 29#64)
    0x402320#64 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by bv_omega) (by decide) (by decide)
    (by omega)
  braid_forget 11
  sha256_leak_done

/-- **What the exit of `sha256_compress` reveals**, from the end of the loop of rounds:
`tailLeak` of the pointer to the hash value, the stack pointer and the return address,
whatever the working variables, the hash value and the seven words of it in the frame are.
It is a triple of its own for the reason `compress_tail_spec` is: one declaration that runs
all of the code does not fit in the default limit on heartbeats. -/
theorem compress_tail_trace (hp s r : Word)
    (xa xb xc xd xe xf xg xh x11 vb vp v12 v13 v14 v15 t0 t14 : Word) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x4012c5#64, .reg rdi hp, .reg rax t0, .reg r14 t14,
        .reg r11 x11, .reg rsp (s - 216#64),
        .reg r8 xa, .reg r13 xb, .reg r12 xc, .reg rcx xd, .reg r15 xe, .reg rbp xf,
        .reg r10 xg, .reg rbx xh,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 true (s - 340#64) 7),
        .prop (cellsAt 8 true (s - 48#64) [vb, v12, v13, v14, v15, vp]),
        .prop (cellsAt 8 true s [r])]) t
      (Atoms.interp [.pc r, .reg rdi hp, .prop (regAny rax), .reg r14 v14,
        .prop (regAny r11), .reg rsp (s + 8#64),
        .prop (regAny r8), .reg r13 v13, .reg r12 v12, .prop (regAny rcx), .reg r15 v15,
        .reg rbp vp, .prop (regAny r10), .reg rbx vb,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 true (s - 340#64) 7),
        .prop (cellsAt 8 true (s - 48#64) [vb, v12, v13, v14, v15, vp]),
        .prop (cellsAt 8 true s [r])])
      (t ++ tailLeak hp s r) := by
  simp only [tailLeak]
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 341#64 := ⟨s - 341#64, by bv_omega⟩
  braid_unfold cellsAny8 true (hq + 1#64)
  braid_unfold cellsAny7 true (sq + 1#64)
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 293#64) vb [v12, v13, v14, v15, vp]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 301#64) v12 [v13, v14, v15, vp]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 309#64) v13 [v14, v15, vp]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 317#64) v14 [v15, vp]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 325#64) v15 [vp]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 333#64) vp []
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 341#64) r []
  vars_name hq
  kept_name sq
  braid_sym_run_to 0x401315
  refine tripleT_reg_val (r := 6) (sq + 293#64) (by braid_upd) (by bv_omega) ?_
  braid_sym_run
  vars_forget hq
  kept_forget sq
  sha256_fold cellsAny8 true (hq + 1#64)
  sha256_fold cellsAny7 true (sq + 1#64)
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 333#64) vp []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 325#64) v15 [vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 317#64) v14 [v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 309#64) v13 [v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 301#64) v12 [v13, v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 293#64) vb [v12, v13, v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 341#64) r []
  braid_forget 0
  braid_forget 2
  braid_forget 8
  braid_forget 10
  braid_forget 11
  x86_forget_all_flags
  sha256_leak_done

/-- **What `sha256_compress` reveals.** From the precondition of `sha256_compress_spec`, the
code runs to its return and reveals `compressLeak` of the two pointers, the stack pointer and
the return address: the hash value `H`, the block `M`, the round constants and what was on
the stack are not in the trace. The postcondition keeps where the arrays are and forgets
what is in them. -/
theorem sha256_compress_trace (hp mp s r vb vp v12 v13 v14 v15 : Word) (H M : List W32)
    (wm wk : Bool) (fvs fws sv : List Word) (t0 t2 t3 t8 t9 t10 t11 : Word)
    (c pf af z sg o : Bool) (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 7)
    (hfw : fws.length = 64) (hsv : sv.length = 6) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x401100#64, .reg rdi hp, .reg rsi mp, .reg rax t0, .reg rcx t2,
        .reg rdx t3, .reg r8 t8, .reg r9 t9, .reg r10 t10, .reg r11 t11, .reg rbx vb,
        .reg rbp vp, .reg r12 v12, .reg r13 v13, .reg r14 v14, .reg r15 v15, .reg rsp s,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x402320#64 (w32s K)),
        .prop (cellsAt 4 true (s - 340#64) fvs), .prop (cellsAt 4 true (s - 312#64) fws),
        .prop (cellsAt 8 true (s - 48#64) sv), .prop (cellsAt 8 true s [r])]) t
      (Atoms.interp [.pc r, .reg rdi hp, .prop (regAny rsi), .prop (regAny rax),
        .prop (regAny rcx), .prop (regAny rdx), .prop (regAny r8), .prop (regAny r9),
        .prop (regAny r10), .prop (regAny r11), .reg rbx vb, .reg rbp vp, .reg r12 v12,
        .reg r13 v13, .reg r14 v14, .reg r15 v15, .reg rsp (s + 8#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 wm mp 16),
        .prop (cellsAny 4 wk 0x402320#64 64),
        .prop (cellsAny 4 true (s - 340#64) 7), .prop (cellsAny 4 true (s - 312#64) 64),
        .prop (cellsAt 8 true (s - 48#64) [vb, v12, v13, v14, v15, vp]),
        .prop (cellsAt 8 true s [r])])
      (t ++ compressLeak hp mp s r) := by
  simp only [compressLeak]
  -- Nothing the code reveals depends on what the arrays hold.
  braid_forget_cells hp, 8, (by simp [hH])
  braid_forget_cells mp, 16, (by simp [hM])
  braid_forget_cells 0x402320#64, 64, (by rw [w32s_length]; rfl)
  braid_forget_cells (s - 340#64), 7, hfv
  braid_forget_cells (s - 312#64), 64, hfw
  braid_call compress_head_trace mp s vb vp v12 v13 v14 v15 wm sv t0 t2 t3 t8 c pf af z sg o
    hsv t
  braid_name_reg 4
  braid_name_reg 0
  braid_name_reg 2
  braid_name_reg 3
  braid_name_reg 8
  braid_call compress_mid_trace hp s wk _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_name_reg 4
  braid_name_reg 0
  braid_name_reg 2
  braid_name_reg 8
  braid_name_reg 9
  braid_name_reg 10
  braid_name_reg 11
  braid_name_reg 1
  braid_name_reg 7
  braid_name_reg 12
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  braid_call compress_tail_trace hp s r _ _ _ _ _ _ _ _ _ vb vp v12 v13 v14 v15 _ _ _
  braid_forget 4
  braid_forget 3
  braid_forget 9
  sha256_leak_done

end Examples.Sha256.O2.X86
