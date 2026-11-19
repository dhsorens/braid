/-
  Examples.Sha256.RiscV.LeakCompress

  What `sha256_compress` reveals on RISC-V (`docs/Leakage.md`): a traced triple. The
  compiler inlined the schedule and the round, so the function is five loops with
  straight-line code between them. Each loop is an induction on the iterations left, over
  arrays of forgotten contents (`LeakBase`), and the function calls the five. No loop is run
  out, and nothing is said of a value the code computes, so the proof is shorter than that
  of `sha256_compress_spec` and checks faster. The theorem about the machine is in
  `LeakMachine`.

  ## Main definitions

  * `copyLeak`, `roundsLeak`, `addLeak`: what the loops reveal
  * `compressLeak`: what `sha256_compress` reveals, from its two pointers, the stack pointer
    and the return address

  ## Main results

  * `compress_copy_block_trace`, `compress_schedule_trace`, `compress_copy_hash_trace`,
    `compress_rounds_trace`, `compress_add_trace`: the loops
  * `sha256_compress_trace`: the code reveals `compressLeak`
-/

module

public import Examples.Sha256.RiscV.Compress
public import Examples.Sha256.RiscV.LeakBase

@[expose] public section

namespace Examples.Sha256.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-! ## What the loops reveal -/

/-- What a loop that copies `n + 1` words from `src` to `dst` reveals: each word read and
written, and the branch at the end of each iteration, back to `head` or on to `exit`. -/
def copyLeak (head exit : Word) (src dst : Word) : Nat → Trace
  | 0 => [.read src 4, .write dst 4, .jump exit]
  | n + 1 => [.read src 4, .write dst 4, .jump head] ++
      copyLeak head exit (src + 4#64) (dst + 4#64) n

/-- What the loop of rounds reveals, with `n + 1` rounds left: each reads its round constant
at `ka` and its word of the schedule at `wa`, and branches back to `head` or on to
`exit`. -/
def roundsLeak (head exit : Word) (ka wa : Word) : Nat → Trace
  | 0 => [.read ka 4, .read wa 4, .jump exit]
  | n + 1 => [.read ka 4, .read wa 4, .jump head] ++
      roundsLeak head exit (ka + 4#64) (wa + 4#64) n

/-- What the loop that adds `n + 1` working variables at `va` to the hash value at `ha`
reveals: the two words read, the sum written, and the branch. -/
def addLeak (head exit : Word) (va ha : Word) : Nat → Trace
  | 0 => [.read va 4, .read ha 4, .write ha 4, .jump exit]
  | n + 1 => [.read va 4, .read ha 4, .write ha 4, .jump head] ++
      addLeak head exit (va + 4#64) (ha + 4#64) n

/-- What `sha256_compress` reveals, given the pointer `hp` to the hash value, the pointer
`mp` to the block, the stack pointer `s` and the return address `r`: three registers saved,
the block copied to the stack, the 48 words of the schedule filled, the hash value copied to
the working variables and those read, the 64 rounds, each reading a round constant and a
word of the schedule, the working variables written and added to the hash value, the
registers restored, and the return. Every address is a constant or one of the three
addresses plus a constant. -/
def compressLeak (hp mp s r : Word) : Trace :=
  [.write (s - 8#64) 8, .write (s - 16#64) 8, .write (s - 24#64) 8] ++
  copyLeak 0x10178#64 0x1018c#64 mp (s - 280#64) 15 ++
  scheduleLoopLeak 0x10194#64 0x10204#64 (s - 216#64) 47 ++
  copyLeak 0x10210#64 0x10224#64 hp (s - 312#64) 7 ++
  [.read (s - 312#64) 4, .read (s - 308#64) 4, .read (s - 304#64) 4, .read (s - 300#64) 4,
    .read (s - 296#64) 4, .read (s - 292#64) 4, .read (s - 288#64) 4, .read (s - 284#64) 4] ++
  roundsLeak 0x10254#64 0x10314#64 0x10368#64 (s - 280#64) 63 ++
  [.write (s - 312#64) 4, .write (s - 308#64) 4, .write (s - 304#64) 4,
    .write (s - 300#64) 4, .write (s - 296#64) 4, .write (s - 292#64) 4,
    .write (s - 288#64) 4, .write (s - 284#64) 4] ++
  addLeak 0x10338#64 0x10354#64 (s - 312#64) hp 7 ++
  [.read (s - 8#64) 8, .read (s - 16#64) 8, .read (s - 24#64) 8, .jump (r &&& ~~~1#64)]

/-! ## The loops -/

/-- The loop that copies the block to the start of the schedule: `n + 1` words from `src`,
the last of them just before `e`, to `dst`, whatever the words are. It reveals `copyLeak` of
the two addresses and the number of words. -/
theorem compress_copy_block_trace (e : Word) (wm : Bool) : ∀ (n : Nat) (src dst x14 : Word)
    (t : Trace), src &&& 3#64 = 0#64 → dst &&& 3#64 = 0#64 →
    src + BitVec.ofNat 64 (4 * (n + 1)) = e → n + 1 ≤ 16 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10178#64, .reg a1 src, .reg a2 e, .reg a3 dst, .reg a4 x14,
        .prop (cellsAny 4 wm src (n + 1)), .prop (cellsAny 4 true dst (n + 1))]) t
      (Atoms.interp [.pc 0x1018c#64, .reg a1 e, .reg a2 e, .prop (regAny a3),
        .prop (regAny a4),
        .prop (cellsAny 4 wm src (n + 1)), .prop (cellsAny 4 true dst (n + 1))])
      (t ++ copyLeak 0x10178#64 0x1018c#64 src dst n) := by
  intro n
  induction n with
  | zero =>
    intro src dst x14 t hs hd he hb
    obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, src = sq + 1#64 := ⟨src - 1#64, by bv_omega⟩
    obtain ⟨dq, rfl⟩ : ∃ dq : BitVec 64, dst = dq + 1#64 := ⟨dst - 1#64, by bv_omega⟩
    simp only [copyLeak]
    braid_unfold cellsAny4_cons wm (sq + 1#64) 0 (0 + 1) rfl
    braid_unfold cellsAny4_cons true (dq + 1#64) 0 (0 + 1) rfl
    sha256_name_mem (sq + 1#64)
    sha256_name_mem (dq + 1#64)
    braid_sym_run_to 0x1018c
    · exact absurd (by bv_omega) hbr
    · subst hbr
      sha256_forget_mem (sq + 1#64)
      sha256_forget_mem (dq + 1#64)
      sha256_fold cellsAny4_cons wm (sq + 1#64) 0 (0 + 1) rfl
      sha256_fold cellsAny4_cons true (dq + 1#64) 0 (0 + 1) rfl
      braid_forget 13
      braid_forget 14
      sha256_done
  | succ n ih =>
    intro src dst x14 t hs hd he hb
    obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, src = sq + 1#64 := ⟨src - 1#64, by bv_omega⟩
    obtain ⟨dq, rfl⟩ : ∃ dq : BitVec 64, dst = dq + 1#64 := ⟨dst - 1#64, by bv_omega⟩
    simp only [copyLeak]
    braid_unfold cellsAny4_cons wm (sq + 1#64) (n + 1) (n + 1 + 1) rfl
    braid_unfold cellsAny4_cons true (dq + 1#64) (n + 1) (n + 1 + 1) rfl
    sha256_name_mem (sq + 1#64)
    sha256_name_mem (dq + 1#64)
    braid_sym_run_to 0x1018c
    · sha256_forget_mem (sq + 1#64)
      sha256_forget_mem (dq + 1#64)
      braid_call ih (sq + 5#64) (dq + 5#64) _ _ (by bv_decide) (by bv_decide)
        (by rw [← he]; bv_omega) (by omega)
      sha256_fold cellsAny4_cons wm (sq + 1#64) (n + 1) (n + 1 + 1) rfl
      sha256_fold cellsAny4_cons true (dq + 1#64) (n + 1) (n + 1 + 1) rfl
      sha256_done
    · exfalso
      rw [← hbr] at he
      bv_omega

/-- The loop that copies the hash value to the working variables: `n + 1` words from `src`,
the last of them just before `e`, to `dst`, whatever the words are. It reveals `copyLeak` of
the two addresses and the number of words. -/
theorem compress_copy_hash_trace (e : Word) : ∀ (n : Nat) (src dst x14 : Word)
    (t : Trace), src &&& 3#64 = 0#64 → dst &&& 3#64 = 0#64 →
    src + BitVec.ofNat 64 (4 * (n + 1)) = e → n + 1 ≤ 16 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10210#64, .reg a3 src, .reg a1 e, .reg a2 dst, .reg a4 x14,
        .prop (cellsAny 4 true src (n + 1)), .prop (cellsAny 4 true dst (n + 1))]) t
      (Atoms.interp [.pc 0x10224#64, .reg a3 e, .reg a1 e, .prop (regAny a2),
        .prop (regAny a4),
        .prop (cellsAny 4 true src (n + 1)), .prop (cellsAny 4 true dst (n + 1))])
      (t ++ copyLeak 0x10210#64 0x10224#64 src dst n) := by
  intro n
  induction n with
  | zero =>
    intro src dst x14 t hs hd he hb
    obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, src = sq + 1#64 := ⟨src - 1#64, by bv_omega⟩
    obtain ⟨dq, rfl⟩ : ∃ dq : BitVec 64, dst = dq + 1#64 := ⟨dst - 1#64, by bv_omega⟩
    simp only [copyLeak]
    braid_unfold cellsAny4_cons true (sq + 1#64) 0 (0 + 1) rfl
    braid_unfold cellsAny4_cons true (dq + 1#64) 0 (0 + 1) rfl
    sha256_name_mem (sq + 1#64)
    sha256_name_mem (dq + 1#64)
    braid_sym_run_to 0x10224
    · exact absurd (by bv_omega) hbr
    · subst hbr
      sha256_forget_mem (sq + 1#64)
      sha256_forget_mem (dq + 1#64)
      sha256_fold cellsAny4_cons true (sq + 1#64) 0 (0 + 1) rfl
      sha256_fold cellsAny4_cons true (dq + 1#64) 0 (0 + 1) rfl
      braid_forget 12
      braid_forget 14
      sha256_done
  | succ n ih =>
    intro src dst x14 t hs hd he hb
    obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, src = sq + 1#64 := ⟨src - 1#64, by bv_omega⟩
    obtain ⟨dq, rfl⟩ : ∃ dq : BitVec 64, dst = dq + 1#64 := ⟨dst - 1#64, by bv_omega⟩
    simp only [copyLeak]
    braid_unfold cellsAny4_cons true (sq + 1#64) (n + 1) (n + 1 + 1) rfl
    braid_unfold cellsAny4_cons true (dq + 1#64) (n + 1) (n + 1 + 1) rfl
    sha256_name_mem (sq + 1#64)
    sha256_name_mem (dq + 1#64)
    braid_sym_run_to 0x10224
    · sha256_forget_mem (sq + 1#64)
      sha256_forget_mem (dq + 1#64)
      braid_call ih (sq + 5#64) (dq + 5#64) _ _ (by bv_decide) (by bv_decide)
        (by rw [← he]; bv_omega) (by omega)
      sha256_fold cellsAny4_cons true (sq + 1#64) (n + 1) (n + 1 + 1) rfl
      sha256_fold cellsAny4_cons true (dq + 1#64) (n + 1) (n + 1 + 1) rfl
      sha256_done
    · exfalso
      rw [← hbr] at he
      bv_omega

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
      (Atoms.interp [.pc 0x10194#64, .reg a1 (q + 64#64), .reg a2 e, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .prop (cellsAny 4 true q 16),
        .prop (cellsAny 4 true (q + 64#64) (n + 1))]) t
      (Atoms.interp [.pc 0x10204#64, .reg a1 e, .reg a2 e, .prop (regAny a3),
        .prop (regAny a4), .prop (regAny a5), .prop (regAny a6), .prop (regAny a7),
        .prop (regAny t0), .prop (regAny t1), .prop (regAny t2),
        .prop (cellsAny 4 true q 16), .prop (cellsAny 4 true (q + 64#64) (n + 1))])
      (t ++ scheduleLoopLeak 0x10194#64 0x10204#64 (q + 64#64) n) := by
  intro n
  induction n with
  | zero =>
    intro q x13 x14 x15 x16 x17 x5 x6 x7 t hq he hb
    obtain ⟨q', rfl⟩ : ∃ q' : BitVec 64, q = q' + 1#64 := ⟨q - 1#64, by bv_omega⟩
    simp only [scheduleLoopLeak, scheduleStepLeak]
    braid_unfold cellsAny16 true (q' + 1#64)
    braid_unfold cellsAny4_cons true (q' + 65#64) 0 (0 + 1) rfl
    schedule_name q'
    braid_sym_run_to 0x10204
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
    braid_sym_run_to 0x10204
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
  `(tactic| (braid_forget 7; braid_forget 12; braid_forget 13; braid_forget 28
             braid_forget 29; braid_forget 14; braid_forget 15; braid_forget 16
             braid_forget 30; braid_forget 31; braid_forget 8; braid_forget 9
             braid_forget 18))

/-- The loop of rounds in `sha256_compress`, where `sha256_round` is inlined: `n + 1` rounds,
with the code's two pointers at the round constant `ka` and the word of the schedule `wa`
of the first of them, the last round constant just before `ke`, whatever the working
variables, the round constants and the schedule are. It reveals `roundsLeak` of the two
addresses and the number of rounds: a round reads its constant and its word, and no address
or branch of it depends on a working variable. -/
theorem compress_rounds_trace (ke : Word) (wk : Bool) : ∀ (n : Nat)
    (ka wa xa xb xc xd xe xf xg xh y30 y31 y8 y9 y18 : Word) (t : Trace),
    ka &&& 3#64 = 0#64 → wa &&& 3#64 = 0#64 →
    ka + BitVec.ofNat 64 (4 * (n + 1)) = ke → n + 1 ≤ 64 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10254#64, .reg a7 ka, .reg t0 wa, .reg t1 ke,
        .reg t2 xa, .reg a2 xb, .reg a3 xc, .reg t3 xd, .reg t4 xe, .reg a4 xf, .reg a5 xg,
        .reg a6 xh, .reg t5 y30, .reg t6 y31, .reg s0 y8, .reg s1 y9, .reg s2 y18,
        .prop (cellsAny 4 wk ka (n + 1)), .prop (cellsAny 4 true wa (n + 1))]) t
      (Atoms.interp [.pc 0x10314#64, .reg a7 ke, .prop (regAny t0), .reg t1 ke,
        .prop (regAny t2), .prop (regAny a2), .prop (regAny a3), .prop (regAny t3),
        .prop (regAny t4), .prop (regAny a4), .prop (regAny a5), .prop (regAny a6),
        .prop (regAny t5), .prop (regAny t6), .prop (regAny s0), .prop (regAny s1),
        .prop (regAny s2),
        .prop (cellsAny 4 wk ka (n + 1)), .prop (cellsAny 4 true wa (n + 1))])
      (t ++ roundsLeak 0x10254#64 0x10314#64 ka wa n) := by
  intro n
  induction n with
  | zero =>
    intro ka wa xa xb xc xd xe xf xg xh y30 y31 y8 y9 y18 t hk hw he hb
    obtain ⟨kq, rfl⟩ : ∃ kq : BitVec 64, ka = kq + 1#64 := ⟨ka - 1#64, by bv_omega⟩
    obtain ⟨wq, rfl⟩ : ∃ wq : BitVec 64, wa = wq + 1#64 := ⟨wa - 1#64, by bv_omega⟩
    simp only [roundsLeak]
    braid_unfold cellsAny4_cons wk (kq + 1#64) 0 (0 + 1) rfl
    braid_unfold cellsAny4_cons true (wq + 1#64) 0 (0 + 1) rfl
    sha256_name_mem (kq + 1#64)
    sha256_name_mem (wq + 1#64)
    braid_sym_run_to 0x10314
    · exact absurd (by bv_omega) hbr
    · subst hbr
      sha256_forget_mem (kq + 1#64)
      sha256_forget_mem (wq + 1#64)
      sha256_fold cellsAny4_cons wk (kq + 1#64) 0 (0 + 1) rfl
      sha256_fold cellsAny4_cons true (wq + 1#64) 0 (0 + 1) rfl
      round_forget
      braid_forget 5
      sha256_done
  | succ n ih =>
    intro ka wa xa xb xc xd xe xf xg xh y30 y31 y8 y9 y18 t hk hw he hb
    obtain ⟨kq, rfl⟩ : ∃ kq : BitVec 64, ka = kq + 1#64 := ⟨ka - 1#64, by bv_omega⟩
    obtain ⟨wq, rfl⟩ : ∃ wq : BitVec 64, wa = wq + 1#64 := ⟨wa - 1#64, by bv_omega⟩
    simp only [roundsLeak]
    braid_unfold cellsAny4_cons wk (kq + 1#64) (n + 1) (n + 1 + 1) rfl
    braid_unfold cellsAny4_cons true (wq + 1#64) (n + 1) (n + 1 + 1) rfl
    sha256_name_mem (kq + 1#64)
    sha256_name_mem (wq + 1#64)
    braid_sym_run_to 0x10314
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

/-- The loop that adds the working variables to the hash value: `n + 1` words at `va` added
to those at `ha`, the last of which is just before `e`, whatever the words are. It reveals
`addLeak` of the two addresses and the number of words. -/
theorem compress_add_trace (e : Word) : ∀ (n : Nat) (va ha x13 x14 : Word) (t : Trace),
    va &&& 3#64 = 0#64 → ha &&& 3#64 = 0#64 →
    ha + BitVec.ofNat 64 (4 * (n + 1)) = e → n + 1 ≤ 16 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10338#64, .reg a2 va, .reg a0 ha, .reg a1 e, .reg a3 x13,
        .reg a4 x14,
        .prop (cellsAny 4 true va (n + 1)), .prop (cellsAny 4 true ha (n + 1))]) t
      (Atoms.interp [.pc 0x10354#64, .prop (regAny a2), .reg a0 e, .reg a1 e,
        .prop (regAny a3), .prop (regAny a4),
        .prop (cellsAny 4 true va (n + 1)), .prop (cellsAny 4 true ha (n + 1))])
      (t ++ addLeak 0x10338#64 0x10354#64 va ha n) := by
  intro n
  induction n with
  | zero =>
    intro va ha x13 x14 t hv hh he hb
    obtain ⟨vq, rfl⟩ : ∃ vq : BitVec 64, va = vq + 1#64 := ⟨va - 1#64, by bv_omega⟩
    obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, ha = hq + 1#64 := ⟨ha - 1#64, by bv_omega⟩
    simp only [addLeak]
    braid_unfold cellsAny4_cons true (vq + 1#64) 0 (0 + 1) rfl
    braid_unfold cellsAny4_cons true (hq + 1#64) 0 (0 + 1) rfl
    sha256_name_mem (vq + 1#64)
    sha256_name_mem (hq + 1#64)
    braid_sym_run_to 0x10354
    · exact absurd (by bv_omega) hbr
    · subst hbr
      sha256_forget_mem (vq + 1#64)
      sha256_forget_mem (hq + 1#64)
      sha256_fold cellsAny4_cons true (vq + 1#64) 0 (0 + 1) rfl
      sha256_fold cellsAny4_cons true (hq + 1#64) 0 (0 + 1) rfl
      braid_forget 12
      braid_forget 13
      braid_forget 14
      sha256_done
  | succ n ih =>
    intro va ha x13 x14 t hv hh he hb
    obtain ⟨vq, rfl⟩ : ∃ vq : BitVec 64, va = vq + 1#64 := ⟨va - 1#64, by bv_omega⟩
    obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, ha = hq + 1#64 := ⟨ha - 1#64, by bv_omega⟩
    simp only [addLeak]
    braid_unfold cellsAny4_cons true (vq + 1#64) (n + 1) (n + 1 + 1) rfl
    braid_unfold cellsAny4_cons true (hq + 1#64) (n + 1) (n + 1 + 1) rfl
    sha256_name_mem (vq + 1#64)
    sha256_name_mem (hq + 1#64)
    braid_sym_run_to 0x10354
    · sha256_forget_mem (vq + 1#64)
      sha256_forget_mem (hq + 1#64)
      braid_call ih (vq + 5#64) (hq + 5#64) _ _ _ (by bv_decide) (by bv_decide)
        (by rw [← he]; bv_omega) (by omega)
      sha256_fold cellsAny4_cons true (vq + 1#64) (n + 1) (n + 1 + 1) rfl
      sha256_fold cellsAny4_cons true (hq + 1#64) (n + 1) (n + 1 + 1) rfl
      sha256_done
    · exfalso
      rw [← hbr] at he
      bv_omega

/-! ## The compression function -/

/-- Name the values of the eight working variables on the stack. -/
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

/-- **What `sha256_compress` reveals.** From the precondition of `sha256_compress_spec`, the
code runs to its return and reveals `compressLeak` of the two pointers, the stack pointer and
the return address: the hash value `H`, the block `M`, the round constants and what was on
the stack are not in the trace. The postcondition keeps where the arrays are and forgets
what is in them. -/
theorem sha256_compress_trace (hp mp s r v8 v9 v18 : Word) (H M : List W32) (wm wk : Bool)
    (fvs fws sv : List Word) (x12 x13 x14 x15 x16 x17 x5 x6 x7 x28 x29 x30 x31 : Word)
    (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 8) (hfw : fws.length = 64)
    (hsv : sv.length = 3) (hhp : hp &&& 3#64 = 0#64) (hmp : mp &&& 3#64 = 0#64)
    (hs : s &&& 7#64 = 0#64) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10160#64, .reg a0 hp, .reg a1 mp, .reg a2 x12, .reg a3 x13,
        .reg a4 x14, .reg a5 x15, .reg a6 x16, .reg a7 x17, .reg t0 x5, .reg t1 x6,
        .reg t2 x7, .reg t3 x28, .reg t4 x29, .reg t5 x30, .reg t6 x31, .reg s0 v8,
        .reg s1 v9, .reg s2 v18, .reg sp s, .reg ra r,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x10368#64 (w32s K)),
        .prop (cellsAt 4 true (s - 312#64) fvs), .prop (cellsAt 4 true (s - 280#64) fws),
        .prop (cellsAt 8 true (s - 24#64) sv)]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (hp + 32#64), .prop (regAny a1),
        .prop (regAny a2), .prop (regAny a3), .prop (regAny a4), .prop (regAny a5),
        .prop (regAny a6), .prop (regAny a7), .prop (regAny t0), .prop (regAny t1),
        .prop (regAny t2), .prop (regAny t3), .prop (regAny t4), .prop (regAny t5),
        .prop (regAny t6), .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg sp s, .reg ra r,
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 wm mp 16),
        .prop (cellsAny 4 wk 0x10368#64 64),
        .prop (cellsAny 4 true (s - 312#64) 8), .prop (cellsAny 4 true (s - 280#64) 64),
        .prop (cellsAt 8 true (s - 24#64) [v18, v9, v8])])
      (t ++ compressLeak hp mp s r) := by
  obtain ⟨sv0, sv1, sv2, rfl⟩ : ∃ sv0 sv1 sv2, sv = [sv0, sv1, sv2] := by
    match sv, hsv with
    | [sv0, sv1, sv2], _ => exact ⟨sv0, sv1, sv2, rfl⟩
  simp only [compressLeak]
  -- Nothing the code reveals depends on what the arrays hold.
  sha256_forget_cells hp, 8, (by simp [hH])
  sha256_forget_cells mp, 16, (by simp [hM])
  sha256_forget_cells 0x10368#64, 64, (by rw [w32s_length]; rfl)
  sha256_forget_cells (s - 312#64), 8, hfv
  sha256_forget_cells (s - 280#64), 64, hfw
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨mq, rfl⟩ : ∃ mq : BitVec 64, mp = mq + 1#64 := ⟨mp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 313#64 := ⟨s - 313#64, by bv_omega⟩
  braid_unfold cellsAny_pre16 true (sq + 33#64) 48 64 rfl
  sha256_fold cellsAny16 true (sq + 33#64)
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 289#64) sv0 [sv1, sv2]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 297#64) sv1 [sv2]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 305#64) sv2 []
  -- The frame, and the block copied to the start of the schedule.
  braid_sym_run_to 0x10178
  braid_call compress_copy_block_trace (mq + 65#64) wm 15 (mq + 1#64) (sq + 33#64) _ _
    (by bv_decide) (by bv_decide) (by bv_omega) (by omega)
  braid_name_reg 13
  braid_name_reg 14
  -- The message schedule.
  braid_sym_run_to 0x10194
  braid_call compress_schedule_trace (sq + 289#64) 47 (sq + 33#64) _ _ _ _ _ _ _ _ _
    (by bv_decide) (by bv_omega) (by omega)
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  braid_name_reg 16
  braid_name_reg 17
  braid_name_reg 5
  braid_name_reg 6
  braid_name_reg 7
  -- The hash value copied to the working variables, and those loaded into registers.
  braid_sym_run_to 0x10210
  braid_call compress_copy_hash_trace (hq + 33#64) 7 (hq + 1#64) (sq + 1#64) _ _
    (by bv_decide) (by bv_decide) (by bv_omega) (by omega)
  braid_name_reg 12
  braid_name_reg 14
  braid_unfold cellsAny8 true (sq + 1#64)
  vars_name sq
  braid_sym_run_to 0x10254
  vars_forget sq
  sha256_fold cellsAny8 true (sq + 1#64)
  braid_unfold cellsAny16 true (sq + 33#64)
  sha256_fold cellsAny_pre16 true (sq + 33#64) 48 64 rfl
  -- The rounds.
  braid_call compress_rounds_trace 0x10468#64 wk 63 0x10368#64 (sq + 33#64)
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by decide) (by bv_decide) (by decide) (by omega)
  braid_name_reg 7
  braid_name_reg 12
  braid_name_reg 13
  braid_name_reg 28
  braid_name_reg 29
  braid_name_reg 14
  braid_name_reg 15
  braid_name_reg 16
  -- The working variables stored, and added to the hash value; the registers restored.
  braid_unfold cellsAny8 true (sq + 1#64)
  vars_name sq
  braid_sym_run_to 0x10338
  vars_forget sq
  sha256_fold cellsAny8 true (sq + 1#64)
  braid_call compress_add_trace (hq + 33#64) 7 (sq + 1#64) (hq + 1#64) _ _ _
    (by bv_decide) (by bv_decide) (by bv_omega) (by omega)
  braid_name_reg 8
  braid_name_reg 9
  braid_name_reg 18
  braid_sym_run
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 305#64) v8 []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 297#64) v9 [v8]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 289#64) v18 [v9, v8]
  braid_forget 11
  braid_forget 15
  braid_forget 16
  braid_forget 17
  braid_forget 6
  braid_forget 7
  braid_forget 28
  braid_forget 29
  sha256_done

end Examples.Sha256.RiscV
