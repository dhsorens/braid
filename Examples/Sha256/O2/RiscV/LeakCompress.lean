/-
  Examples.Sha256.O2.RiscV.LeakCompress

  What `sha256_compress` reveals on RISC-V, compiled at `-O2` (`docs/Leakage.md`): a traced
  triple. The trace is not that of `-O1`, because the code is not: the three loops that copy
  and the loop that adds are gone, and with them their branches and every access to a copy
  of the working variables on the stack, which is not kept; ten registers are saved where
  three were; the frame is 336 bytes and the round constants are at `0x10404`. What is left
  is two loops, of the schedule and of the rounds, with straight-line code around them. So
  `compressLeak` is defined again here. It is still a function of the two pointers, the
  stack pointer and the return address, and of nothing else.

  The two loops are those of `Examples.Sha256.RiscV.LeakCompress`: the loop of the schedule
  with two addresses replaced, and the loop of rounds with its registers renamed and two
  addresses replaced; their proofs are the same text. What each iteration of them reveals
  (`scheduleLoopLeak` of `Examples.Sha256.RiscV.LeakBase`, `roundsLeak`) is the same function
  at `-O2`, given other addresses. The function itself is run again, in three triples
  (`compress_head_trace`, `compress_mid_trace`, `compress_tail_trace`) cut where
  `sha256_compress_spec` at `-O2` is cut, and for its reason: one declaration that runs all
  of the code, with ten saved registers in the frame, does not fit in the default limit on
  heartbeats, though nothing is said here of a value the code computes. The theorem about the
  machine is in `LeakMachine`.

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

public import Examples.Sha256.O2.RiscV.Compress
public import Examples.Sha256.RiscV.LeakBase

@[expose] public section

namespace Examples.Sha256.O2.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64
open Examples.Sha256.RiscV

/-! ## What the code reveals -/

/-- What the loop of rounds reveals, with `n + 1` rounds left: each reads its round constant
at `ka` and its word of the schedule at `wa`, and branches back to `head` or on to
`exit`. -/
def roundsLeak (head exit : Word) (ka wa : Word) : Nat → Trace
  | 0 => [.read ka 4, .read wa 4, .jump exit]
  | n + 1 => [.read ka 4, .read wa 4, .jump head] ++
      roundsLeak head exit (ka + 4#64) (wa + 4#64) n

/-- What the copy of the block at `mp` to the start of the schedule, 336 bytes below the
stack pointer `s`, reveals: the sixteen words read and the sixteen written, in the order of
the code, which loads eight words and then stores and loads four at a time. -/
def blockCopyLeak (mp s : Word) : Trace :=
  [.read mp 4, .read (mp + 4#64) 4, .read (mp + 8#64) 4, .read (mp + 12#64) 4,
    .read (mp + 16#64) 4, .read (mp + 20#64) 4, .read (mp + 24#64) 4, .read (mp + 28#64) 4,
    .write (s - 336#64) 4, .write (s - 332#64) 4, .write (s - 328#64) 4, .write (s - 324#64) 4,
    .read (mp + 32#64) 4, .read (mp + 36#64) 4, .read (mp + 40#64) 4, .read (mp + 44#64) 4,
    .write (s - 320#64) 4, .write (s - 316#64) 4, .write (s - 312#64) 4, .write (s - 308#64) 4,
    .read (mp + 48#64) 4, .read (mp + 52#64) 4, .read (mp + 56#64) 4, .read (mp + 60#64) 4,
    .write (s - 304#64) 4, .write (s - 300#64) 4, .write (s - 296#64) 4, .write (s - 292#64) 4,
    .write (s - 288#64) 4, .write (s - 284#64) 4, .write (s - 280#64) 4, .write (s - 276#64) 4]

/-- What `sha256_compress` reveals to the end of the message schedule, given the pointer `mp`
to the block and the stack pointer `s`: ten registers saved, the block copied to the stack,
and the 48 words of the schedule filled. -/
def headLeak (mp s : Word) : Trace :=
  [.write (s - 8#64) 8, .write (s - 16#64) 8, .write (s - 24#64) 8, .write (s - 32#64) 8,
    .write (s - 40#64) 8, .write (s - 48#64) 8, .write (s - 56#64) 8, .write (s - 64#64) 8,
    .write (s - 72#64) 8, .write (s - 80#64) 8] ++
  blockCopyLeak mp s ++
  scheduleLoopLeak 0x10214#64 0x10284#64 (s - 272#64) 47

/-- What `sha256_compress` reveals from the end of the message schedule to the end of the
loop of rounds, given the pointer `hp` to the hash value and the stack pointer `s`: the hash
value read, and the 64 rounds, each reading a round constant and a word of the schedule. -/
def midLeak (hp s : Word) : Trace :=
  [.read hp 4, .read (hp + 4#64) 4, .read (hp + 8#64) 4, .read (hp + 12#64) 4,
    .read (hp + 16#64) 4, .read (hp + 20#64) 4, .read (hp + 24#64) 4, .read (hp + 28#64) 4] ++
  roundsLeak 0x102d4#64 0x10394#64 0x10404#64 (s - 336#64) 63

/-- What `sha256_compress` reveals from the end of the loop of rounds, given the pointer `hp`
to the hash value, the stack pointer `s` and the return address `r`: the hash value written,
the ten registers restored, and the return. -/
def tailLeak (hp s r : Word) : Trace :=
  [.write hp 4, .write (hp + 4#64) 4, .write (hp + 8#64) 4, .write (hp + 12#64) 4,
    .write (hp + 16#64) 4, .write (hp + 20#64) 4, .write (hp + 24#64) 4, .write (hp + 28#64) 4,
    .read (s - 8#64) 8, .read (s - 16#64) 8, .read (s - 24#64) 8, .read (s - 32#64) 8,
    .read (s - 40#64) 8, .read (s - 48#64) 8, .read (s - 56#64) 8, .read (s - 64#64) 8,
    .read (s - 72#64) 8, .read (s - 80#64) 8, .jump (r &&& ~~~1#64)]

/-- **What `sha256_compress` reveals**, given the pointer `hp` to the hash value, the pointer
`mp` to the block, the stack pointer `s` and the return address `r`: `headLeak`, `midLeak`
and `tailLeak`, one after the other. Every address in it is a constant or one of the three
addresses plus a constant. -/
def compressLeak (hp mp s r : Word) : Trace :=
  headLeak mp s ++ midLeak hp s ++ tailLeak hp s r

/-! ## The loops -/

/-- Forget what the loop of the schedule leaves in the registers it uses. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 13; braid_forget 14; braid_forget 15; braid_forget 16
             braid_forget 17; braid_forget 5; braid_forget 6; braid_forget 7))

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

/-- The loop of the message schedule in `sha256_compress`, where `sha256_schedule` is
inlined: with a window of sixteen cells at `q` and `n + 1` cells after it, the last of them
just before `e`, whatever is in them. It reveals `scheduleLoopLeak` of the address of the
first cell it fills and the number of cells. -/
theorem compress_schedule_trace (e : Word) : ∀ (n : Nat)
    (q x13 x14 x15 x16 x17 x5 x6 x7 : Word) (t : Trace), q &&& 3#64 = 0#64 →
    q + 64#64 + BitVec.ofNat 64 (4 * (n + 1)) = e → n + 1 ≤ 48 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10214#64, .reg a1 (q + 64#64), .reg a2 e, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .prop (cellsAny 4 true q 16),
        .prop (cellsAny 4 true (q + 64#64) (n + 1))]) t
      (Atoms.interp [.pc 0x10284#64, .reg a1 e, .reg a2 e, .prop (regAny a3),
        .prop (regAny a4), .prop (regAny a5), .prop (regAny a6), .prop (regAny a7),
        .prop (regAny t0), .prop (regAny t1), .prop (regAny t2),
        .prop (cellsAny 4 true q 16), .prop (cellsAny 4 true (q + 64#64) (n + 1))])
      (t ++ scheduleLoopLeak 0x10214#64 0x10284#64 (q + 64#64) n) := by
  intro n
  induction n with
  | zero =>
    intro q x13 x14 x15 x16 x17 x5 x6 x7 t hq he hb
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    simp only [scheduleLoopLeak, scheduleStepLeak]
    braid_unfold cellsAny16 true (q' + 1#64)
    braid_unfold cellsAny4_cons true (q' + 65#64) 0 (0 + 1) rfl
    schedule_name q'
    braid_sym_run_to 0x10284
    · exact absurd (by bv_omega) hbr
    · subst hbr
      schedule_forget_mem q'
      sha256_fold cellsAny16 true (q' + 1#64)
      sha256_fold cellsAny4_cons true (q' + 65#64) 0 (0 + 1) rfl
      schedule_forget
      sha256_done
  | succ n ih =>
    intro q x13 x14 x15 x16 x17 x5 x6 x7 t hq he hb
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    simp only [scheduleLoopLeak, scheduleStepLeak]
    braid_unfold cellsAny16 true (q' + 1#64)
    braid_unfold cellsAny4_cons true (q' + 65#64) (n + 1) (n + 1 + 1) rfl
    schedule_name q'
    braid_sym_run_to 0x10284
    · schedule_forget_mem q'
      sha256_fold cellsAny16 true (q' + 5#64)
      braid_call ih (q' + 5#64) _ _ _ _ _ _ _ _ _ (by bv_decide) (by rw [← he]; bv_omega)
        (by omega)
      braid_unfold cellsAny16 true (q' + 5#64)
      sha256_fold cellsAny16 true (q' + 1#64)
      sha256_fold cellsAny4_cons true (q' + 65#64) (n + 1) (n + 1 + 1) rfl
      sha256_done
    · exfalso
      rw [← hbr] at he
      bv_omega

/-- Forget what a round leaves in the registers that hold the working variables and its
intermediate values. -/
local macro "round_forget" : tactic =>
  `(tactic| (braid_forget 18; braid_forget 9; braid_forget 8; braid_forget 21
             braid_forget 20; braid_forget 28; braid_forget 7; braid_forget 6
             braid_forget 19; braid_forget 22; braid_forget 23; braid_forget 24
             braid_forget 25))

/-- The loop of rounds in `sha256_compress`, where `sha256_round` is inlined: `n + 1` rounds,
with the code's two pointers at the round constant `ka` and the word of the schedule `wa`
of the first of them, the last round constant just before `ke`, whatever the working
variables, the round constants and the schedule are. It reveals `roundsLeak` of the two
addresses and the number of rounds: a round reads its constant and its word, and no address
or branch of it depends on a working variable. -/
theorem compress_rounds_trace (ke : Word) (wk : Bool) : ∀ (n : Nat)
    (ka wa xa xb xc xd xe xf xg xh y19 y22 y23 y24 y25 : Word) (t : Trace),
    ka &&& 3#64 = 0#64 → wa &&& 3#64 = 0#64 →
    ka + BitVec.ofNat 64 (4 * (n + 1)) = ke → n + 1 ≤ 64 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x102d4#64, .reg t4 ka, .reg t5 wa, .reg t6 ke,
        .reg s2 xa, .reg s1 xb, .reg s0 xc, .reg s5 xd, .reg s4 xe, .reg t3 xf, .reg t2 xg,
        .reg t1 xh, .reg s3 y19, .reg s6 y22, .reg s7 y23, .reg s8 y24, .reg s9 y25,
        .prop (cellsAny 4 wk ka (n + 1)), .prop (cellsAny 4 true wa (n + 1))]) t
      (Atoms.interp [.pc 0x10394#64, .reg t4 ke, .prop (regAny t5), .reg t6 ke,
        .prop (regAny s2), .prop (regAny s1), .prop (regAny s0), .prop (regAny s5),
        .prop (regAny s4), .prop (regAny t3), .prop (regAny t2), .prop (regAny t1),
        .prop (regAny s3), .prop (regAny s6), .prop (regAny s7), .prop (regAny s8),
        .prop (regAny s9),
        .prop (cellsAny 4 wk ka (n + 1)), .prop (cellsAny 4 true wa (n + 1))])
      (t ++ roundsLeak 0x102d4#64 0x10394#64 ka wa n) := by
  intro n
  induction n with
  | zero =>
    intro ka wa xa xb xc xd xe xf xg xh y19 y22 y23 y24 y25 t hk hw he hb
    obtain ⟨kq, rfl⟩ : ∃ kq : BitVec 64, ka = kq + 1#64 := ⟨ka - 1#64, by bv_omega⟩
    obtain ⟨wq, rfl⟩ : ∃ wq : BitVec 64, wa = wq + 1#64 := ⟨wa - 1#64, by bv_omega⟩
    simp only [roundsLeak]
    braid_unfold cellsAny4_cons wk (kq + 1#64) 0 (0 + 1) rfl
    braid_unfold cellsAny4_cons true (wq + 1#64) 0 (0 + 1) rfl
    sha256_name_mem (kq + 1#64)
    sha256_name_mem (wq + 1#64)
    braid_sym_run_to 0x10394
    · exact absurd (by bv_omega) hbr
    · subst hbr
      sha256_forget_mem (kq + 1#64)
      sha256_forget_mem (wq + 1#64)
      sha256_fold cellsAny4_cons wk (kq + 1#64) 0 (0 + 1) rfl
      sha256_fold cellsAny4_cons true (wq + 1#64) 0 (0 + 1) rfl
      round_forget
      braid_forget 30
      sha256_done
  | succ n ih =>
    intro ka wa xa xb xc xd xe xf xg xh y19 y22 y23 y24 y25 t hk hw he hb
    obtain ⟨kq, rfl⟩ : ∃ kq : BitVec 64, ka = kq + 1#64 := ⟨ka - 1#64, by bv_omega⟩
    obtain ⟨wq, rfl⟩ : ∃ wq : BitVec 64, wa = wq + 1#64 := ⟨wa - 1#64, by bv_omega⟩
    simp only [roundsLeak]
    braid_unfold cellsAny4_cons wk (kq + 1#64) (n + 1) (n + 1 + 1) rfl
    braid_unfold cellsAny4_cons true (wq + 1#64) (n + 1) (n + 1 + 1) rfl
    sha256_name_mem (kq + 1#64)
    sha256_name_mem (wq + 1#64)
    braid_sym_run_to 0x10394
    · sha256_forget_mem (kq + 1#64)
      sha256_forget_mem (wq + 1#64)
      braid_call ih (kq + 5#64) (wq + 5#64) _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by bv_decide)
        (by bv_decide) (by rw [← he]; bv_omega) (by omega)
      sha256_fold cellsAny4_cons wk (kq + 1#64) (n + 1) (n + 1 + 1) rfl
      sha256_fold cellsAny4_cons true (wq + 1#64) (n + 1) (n + 1 + 1) rfl
      sha256_done
    · exfalso
      rw [← hbr] at he
      bv_omega

/-! ## The compression function -/

/-- Name the values of sixteen cells of four bytes from an address on. -/
local macro "cells16_name " q:term : tactic =>
  `(tactic| (sha256_name_mem ($q + 1#64); sha256_name_mem ($q + 5#64)
             sha256_name_mem ($q + 9#64); sha256_name_mem ($q + 13#64)
             sha256_name_mem ($q + 17#64); sha256_name_mem ($q + 21#64)
             sha256_name_mem ($q + 25#64); sha256_name_mem ($q + 29#64)
             sha256_name_mem ($q + 33#64); sha256_name_mem ($q + 37#64)
             sha256_name_mem ($q + 41#64); sha256_name_mem ($q + 45#64)
             sha256_name_mem ($q + 49#64); sha256_name_mem ($q + 53#64)
             sha256_name_mem ($q + 57#64); sha256_name_mem ($q + 61#64)))

/-- Forget them again. -/
local macro "cells16_forget " q:term : tactic =>
  `(tactic| (sha256_forget_mem ($q + 1#64); sha256_forget_mem ($q + 5#64)
             sha256_forget_mem ($q + 9#64); sha256_forget_mem ($q + 13#64)
             sha256_forget_mem ($q + 17#64); sha256_forget_mem ($q + 21#64)
             sha256_forget_mem ($q + 25#64); sha256_forget_mem ($q + 29#64)
             sha256_forget_mem ($q + 33#64); sha256_forget_mem ($q + 37#64)
             sha256_forget_mem ($q + 41#64); sha256_forget_mem ($q + 45#64)
             sha256_forget_mem ($q + 49#64); sha256_forget_mem ($q + 53#64)
             sha256_forget_mem ($q + 57#64); sha256_forget_mem ($q + 61#64)))

/-- Name the values of the eight words of the hash value. -/
local macro "vars_name " q:term : tactic =>
  `(tactic| (sha256_name_mem ($q + 1#64); sha256_name_mem ($q + 5#64)
             sha256_name_mem ($q + 9#64); sha256_name_mem ($q + 13#64)
             sha256_name_mem ($q + 17#64); sha256_name_mem ($q + 21#64)
             sha256_name_mem ($q + 25#64); sha256_name_mem ($q + 29#64)))

/-- Forget them again. -/
local macro "vars_forget " q:term : tactic =>
  `(tactic| (sha256_forget_mem ($q + 1#64); sha256_forget_mem ($q + 5#64)
             sha256_forget_mem ($q + 9#64); sha256_forget_mem ($q + 13#64)
             sha256_forget_mem ($q + 17#64); sha256_forget_mem ($q + 21#64)
             sha256_forget_mem ($q + 25#64); sha256_forget_mem ($q + 29#64)))

/-- **What the head of `sha256_compress` reveals**, to the end of the message schedule:
`headLeak` of the pointer to the block and the stack pointer, whatever the block and the
64 words of stack hold. -/
theorem compress_head_trace (mp s v8 v9 v18 v19 v20 v21 v22 v23 v24 v25 : Word) (wm : Bool)
    (sv : List Word) (x12 x13 x14 x15 x16 x17 x5 x6 x7 : Word)
    (hsv : sv.length = 10) (hmp : mp &&& 3#64 = 0#64) (hs : s &&& 7#64 = 0#64) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10160#64, .reg a1 mp, .reg a2 x12, .reg a3 x13, .reg a4 x14,
        .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6, .reg t2 x7,
        .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg s3 v19, .reg s4 v20,
        .reg s5 v21, .reg s6 v22, .reg s7 v23, .reg s8 v24, .reg s9 v25, .reg sp s,
        .prop (cellsAny 4 wm mp 16), .prop (cellsAny 4 true (s - 336#64) 64),
        .prop (cellsAt 8 true (s - 80#64) sv)]) t
      (Atoms.interp [.pc 0x10284#64, .reg a1 (s - 80#64), .reg a2 (s - 80#64),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .prop (regAny t2),
        .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg s3 v19, .reg s4 v20,
        .reg s5 v21, .reg s6 v22, .reg s7 v23, .reg s8 v24, .reg s9 v25, .reg sp (s - 336#64),
        .prop (cellsAny 4 wm mp 16), .prop (cellsAny 4 true (s - 336#64) 64),
        .prop (cellsAt 8 true (s - 80#64) [v25, v24, v23, v22, v21, v20, v19, v18, v9, v8])])
      (t ++ headLeak mp s) := by
  obtain ⟨sv0, sv1, sv2, sv3, sv4, sv5, sv6, sv7, sv8, sv9, rfl⟩ :
      ∃ sv0 sv1 sv2 sv3 sv4 sv5 sv6 sv7 sv8 sv9,
        sv = [sv0, sv1, sv2, sv3, sv4, sv5, sv6, sv7, sv8, sv9] := by
    match sv, hsv with
    | [sv0, sv1, sv2, sv3, sv4, sv5, sv6, sv7, sv8, sv9], _ =>
      exact ⟨sv0, sv1, sv2, sv3, sv4, sv5, sv6, sv7, sv8, sv9, rfl⟩
  simp only [headLeak, blockCopyLeak]
  obtain ⟨mq, rfl⟩ : ∃ mq : BitVec 64, mp = mq + 1#64 := ⟨mp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 337#64 := ⟨s - 337#64, by bv_omega⟩
  braid_unfold cellsAny16 wm (mq + 1#64)
  braid_unfold cellsAny_pre16 true (sq + 1#64) 48 64 rfl
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 257#64) sv0 [sv1, sv2, sv3, sv4, sv5, sv6,
    sv7, sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 265#64) sv1 [sv2, sv3, sv4, sv5, sv6, sv7,
    sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 273#64) sv2 [sv3, sv4, sv5, sv6, sv7, sv8,
    sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 281#64) sv3 [sv4, sv5, sv6, sv7, sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 289#64) sv4 [sv5, sv6, sv7, sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 297#64) sv5 [sv6, sv7, sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 305#64) sv6 [sv7, sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 313#64) sv7 [sv8, sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 321#64) sv8 [sv9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 329#64) sv9 []
  -- The frame, and the block copied to the start of the schedule.
  cells16_name mq
  cells16_name sq
  braid_sym_run_to 0x10214
  cells16_forget mq
  cells16_forget sq
  sha256_fold cellsAny16 wm (mq + 1#64)
  sha256_fold cellsAny16 true (sq + 1#64)
  -- The message schedule.
  braid_call compress_schedule_trace (sq + 257#64) 47 (sq + 1#64) _ _ _ _ _ _ _ _ _
    (by bv_decide) (by bv_omega) (by omega)
  braid_unfold cellsAny16 true (sq + 1#64)
  sha256_fold cellsAny_pre16 true (sq + 1#64) 48 64 rfl
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 329#64) v8 []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 321#64) v9 [v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 313#64) v18 [v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 305#64) v19 [v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 297#64) v20 [v19, v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 289#64) v21 [v20, v19, v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 281#64) v22 [v21, v20, v19, v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 273#64) v23 [v22, v21, v20, v19, v18, v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 265#64) v24 [v23, v22, v21, v20, v19, v18,
    v9, v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 257#64) v25 [v24, v23, v22, v21, v20, v19,
    v18, v9, v8]
  sha256_done

/-- **What the rounds of `sha256_compress` reveal**, from the end of the message schedule to
the end of the loop of rounds: `midLeak` of the pointer to the hash value and the stack
pointer, whatever the hash value, the round constants and the schedule hold. -/
theorem compress_mid_trace (hp s : Word) (wk : Bool)
    (x11 x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 : Word)
    (y8 y9 y18 y19 y20 y21 y22 y23 y24 y25 : Word)
    (hhp : hp &&& 3#64 = 0#64) (hs : s &&& 7#64 = 0#64) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10284#64, .reg a0 hp, .reg a1 x11, .reg a2 x12, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .reg t3 x28, .reg t4 x29, .reg t5 x30, .reg t6 x31,
        .reg s0 y8, .reg s1 y9, .reg s2 y18, .reg s3 y19, .reg s4 y20,
        .reg s5 y21, .reg s6 y22, .reg s7 y23, .reg s8 y24, .reg s9 y25, .reg sp (s - 336#64),
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 wk 0x10404#64 64),
        .prop (cellsAny 4 true (s - 336#64) 64)]) t
      (Atoms.interp [.pc 0x10394#64, .reg a0 hp, .prop (regAny a1), .prop (regAny a2),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .prop (regAny t2),
        .prop (regAny t3), .prop (regAny t4), .prop (regAny t5), .prop (regAny t6),
        .prop (regAny s0), .prop (regAny s1), .prop (regAny s2), .prop (regAny s3),
        .prop (regAny s4), .prop (regAny s5), .prop (regAny s6), .prop (regAny s7),
        .prop (regAny s8), .prop (regAny s9), .reg sp (s - 336#64),
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 wk 0x10404#64 64),
        .prop (cellsAny 4 true (s - 336#64) 64)])
      (t ++ midLeak hp s) := by
  simp only [midLeak]
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 337#64 := ⟨s - 337#64, by bv_omega⟩
  -- The hash value loaded into registers, which keep it, and copied to those of the rounds.
  braid_unfold cellsAny8 true (hq + 1#64)
  vars_name hq
  braid_sym_run_to 0x102d4
  vars_forget hq
  sha256_fold cellsAny8 true (hq + 1#64)
  -- The rounds.
  braid_call compress_rounds_trace 0x10504#64 wk 63 0x10404#64 (sq + 1#64)
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by decide) (by bv_decide) (by decide) (by omega)
  braid_forget 11
  braid_forget 12
  braid_forget 13
  braid_forget 14
  braid_forget 15
  braid_forget 16
  braid_forget 17
  braid_forget 5
  braid_forget 29
  braid_forget 31
  sha256_done

/-- **What the end of `sha256_compress` reveals**, from the end of the loop of rounds:
`tailLeak` of the pointer to the hash value, the stack pointer and the return address,
whatever the registers of the hash value and of the working variables hold. -/
theorem compress_tail_trace (hp s r : Word)
    (x11 x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 : Word)
    (y8 y9 y18 y19 y20 y21 y22 y23 y24 y25 m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 : Word)
    (hhp : hp &&& 3#64 = 0#64) (hs : s &&& 7#64 = 0#64) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10394#64, .reg a0 hp, .reg a1 x11, .reg a2 x12, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .reg t3 x28,
        .reg s0 y8, .reg s1 y9, .reg s2 y18, .reg s3 y19, .reg s4 y20,
        .reg s5 y21, .reg s6 y22, .reg s7 y23, .reg s8 y24, .reg s9 y25, .reg sp (s - 336#64),
        .reg ra r, .prop (cellsAny 4 true hp 8),
        .prop (cellsAt 8 true (s - 80#64) [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9])]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 hp, .prop (regAny a1), .prop (regAny a2),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (regAny a7), .prop (regAny t0), .prop (regAny t1), .prop (regAny t2),
        .prop (regAny t3),
        .reg s0 m9, .reg s1 m8, .reg s2 m7, .reg s3 m6, .reg s4 m5,
        .reg s5 m4, .reg s6 m3, .reg s7 m2, .reg s8 m1, .reg s9 m0, .reg sp s,
        .reg ra r, .prop (cellsAny 4 true hp 8),
        .prop (cellsAt 8 true (s - 80#64) [m0, m1, m2, m3, m4, m5, m6, m7, m8, m9])])
      (t ++ tailLeak hp s r) := by
  simp only [tailLeak]
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 337#64 := ⟨s - 337#64, by bv_omega⟩
  braid_unfold cellsAny8 true (hq + 1#64)
  vars_name hq
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 257#64) m0 [m1, m2, m3, m4, m5, m6, m7, m8,
    m9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 265#64) m1 [m2, m3, m4, m5, m6, m7, m8, m9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 273#64) m2 [m3, m4, m5, m6, m7, m8, m9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 281#64) m3 [m4, m5, m6, m7, m8, m9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 289#64) m4 [m5, m6, m7, m8, m9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 297#64) m5 [m6, m7, m8, m9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 305#64) m6 [m7, m8, m9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 313#64) m7 [m8, m9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 321#64) m8 [m9]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 329#64) m9 []
  -- The working variables added to the hash value; the registers restored.
  braid_sym_run
  vars_forget hq
  sha256_fold cellsAny8 true (hq + 1#64)
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 329#64) m9 []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 321#64) m8 [m9]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 313#64) m7 [m8, m9]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 305#64) m6 [m7, m8, m9]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 297#64) m5 [m6, m7, m8, m9]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 289#64) m4 [m5, m6, m7, m8, m9]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 281#64) m3 [m4, m5, m6, m7, m8, m9]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 273#64) m2 [m3, m4, m5, m6, m7, m8, m9]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 265#64) m1 [m2, m3, m4, m5, m6, m7, m8, m9]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 257#64) m0 [m1, m2, m3, m4, m5, m6, m7, m8,
    m9]
  braid_forget 11
  braid_forget 12
  braid_forget 13
  braid_forget 14
  braid_forget 15
  braid_forget 16
  braid_forget 17
  braid_forget 5
  braid_forget 6
  braid_forget 7
  braid_forget 28
  sha256_done

/-- **What `sha256_compress` reveals.** From the precondition of `sha256_compress_spec`, the
code runs to its return and reveals `compressLeak` of the two pointers, the stack pointer and
the return address: the hash value `H`, the block `M`, the round constants and what was on
the stack are not in the trace. The postcondition keeps where the arrays are and forgets
what is in them. -/
theorem sha256_compress_trace (hp mp s r v8 v9 v18 v19 v20 v21 v22 v23 v24 v25 : Word)
    (H M : List W32) (wm wk : Bool)
    (fws sv : List Word) (x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 : Word)
    (hH : H.length = 8) (hM : M.length = 16) (hfw : fws.length = 64)
    (hsv : sv.length = 10) (hhp : hp &&& 3#64 = 0#64) (hmp : mp &&& 3#64 = 0#64)
    (hs : s &&& 7#64 = 0#64) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp (.pc 0x10160#64 :: .reg a0 hp :: .reg a1 mp :: .reg a2 x12 :: .reg a3 x13 ::
        [.reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .reg t3 x28, .reg t4 x29, .reg t5 x30, .reg t6 x31,
        .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg s3 v19, .reg s4 v20,
        .reg s5 v21, .reg s6 v22, .reg s7 v23, .reg s8 v24, .reg s9 v25, .reg sp s, .reg ra r,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x10404#64 (w32s K)),
        .prop (cellsAt 4 true (s - 336#64) fws), .prop (cellsAt 8 true (s - 80#64) sv)])) t
      (Atoms.interp (.pc (r &&& ~~~1#64) :: .reg a0 hp :: .prop (regAny a1) ::
        .prop (regAny a2) :: .prop (regAny a3) :: [.prop (regAny a4), .prop (regAny a5),
        .prop (regAny a6), .prop (regAny a7), .prop (regAny t0), .prop (regAny t1),
        .prop (regAny t2), .prop (regAny t3), .prop (regAny t4), .prop (regAny t5),
        .prop (regAny t6),
        .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg s3 v19, .reg s4 v20,
        .reg s5 v21, .reg s6 v22, .reg s7 v23, .reg s8 v24, .reg s9 v25, .reg sp s, .reg ra r,
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 wm mp 16),
        .prop (cellsAny 4 wk 0x10404#64 64),
        .prop (cellsAny 4 true (s - 336#64) 64),
        .prop (cellsAt 8 true (s - 80#64) [v25, v24, v23, v22, v21, v20, v19, v18, v9, v8])]))
      (t ++ compressLeak hp mp s r) := by
  simp only [compressLeak]
  -- Nothing the code reveals depends on what the arrays hold.
  sha256_forget_cells hp, 8, (by simp [hH])
  sha256_forget_cells mp, 16, (by simp [hM])
  sha256_forget_cells 0x10404#64, 64, (by rw [w32s_length]; rfl)
  sha256_forget_cells (s - 336#64), 64, hfw
  braid_call compress_head_trace mp s v8 v9 v18 v19 v20 v21 v22 v23 v24 v25 wm sv
    x12 x13 x14 x15 x16 x17 x5 x6 x7 hsv hmp hs t
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  braid_name_reg 16
  braid_name_reg 17
  braid_name_reg 5
  braid_name_reg 6
  braid_name_reg 7
  braid_call compress_mid_trace hp s wk _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ hhp hs _
  braid_name_reg 11
  braid_name_reg 12
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  braid_name_reg 16
  braid_name_reg 17
  braid_name_reg 5
  braid_name_reg 6
  braid_name_reg 7
  braid_name_reg 28
  braid_name_reg 8
  braid_name_reg 9
  braid_name_reg 18
  braid_name_reg 19
  braid_name_reg 20
  braid_name_reg 21
  braid_name_reg 22
  braid_name_reg 23
  braid_name_reg 24
  braid_name_reg 25
  braid_call compress_tail_trace hp s r _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    v25 v24 v23 v22 v21 v20 v19 v18 v9 v8 hhp hs _
  sha256_done

end Examples.Sha256.O2.RiscV
