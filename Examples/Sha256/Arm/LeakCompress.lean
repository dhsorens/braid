/-
  Examples.Sha256.Arm.LeakCompress

  What `sha256_compress` reveals on AArch64 (`docs/Leakage.md`): a traced triple. The
  compiler inlined the schedule and the round, so the function is five loops with
  straight-line code between them. The loop of the schedule walks a pointer and counts down;
  the other four index their arrays by a register that counts up in fours, so each of those
  is one iteration at an index `i` (`…_step`), with its arrays of forgotten contents opened
  there (`cellsAny_index`), and an induction on the iterations left that uses the iteration
  only through its traced triple. No loop is run out, and nothing is said of a value the
  code computes. The theorem about the machine is in `LeakMachine`.

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

public import Examples.Sha256.Arm.Compress
public import Examples.Sha256.Arm.LeakBase

@[expose] public section

namespace Examples.Sha256.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

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
`mp` to the block, the stack pointer `s` and the return address `r`: the frame pointer
saved, the block copied to the stack, the 48 words of the schedule filled, the hash value
copied to the working variables and those read, the 64 rounds, each reading a round constant
and a word of the schedule, the working variables written and added to the hash value, the
frame pointer restored, and the return. Every address is a constant or one of the three
addresses plus a constant. -/
def compressLeak (hp mp s r : Word) : Trace :=
  [.write (s - 16#64) 8] ++
  copyLeak 0x100cc#64 0x100e0#64 mp (s - 272#64) 15 ++
  scheduleLoopLeak 0x100ec#64 0x10128#64 (s - 208#64) 47 ++
  copyLeak 0x10130#64 0x10144#64 hp (s - 304#64) 7 ++
  [.read (s - 304#64) 4, .read (s - 300#64) 4, .read (s - 296#64) 4, .read (s - 292#64) 4,
    .read (s - 288#64) 4, .read (s - 284#64) 4, .read (s - 280#64) 4, .read (s - 276#64) 4] ++
  roundsLeak 0x10164#64 0x101e8#64 0x20228#64 (s - 272#64) 63 ++
  [.write (s - 304#64) 4, .write (s - 300#64) 4, .write (s - 296#64) 4,
    .write (s - 292#64) 4, .write (s - 288#64) 4, .write (s - 284#64) 4,
    .write (s - 280#64) 4, .write (s - 276#64) 4] ++
  addLeak 0x10200#64 0x1021c#64 (s - 304#64) hp 7 ++
  [.read (s - 16#64) 8, .jump r]

/-! ## Tactics -/

/-- Forget the values of the four flags. -/
local macro "flags_forget" : tactic =>
  `(tactic| (braid_forget_flag 0; braid_forget_flag 1; braid_forget_flag 2
             braid_forget_flag 3))

/-- Name the values of the four flags, each of which holds some value. -/
local macro "flags_name" : tactic =>
  `(tactic| (braid_name_flag 0; braid_name_flag 1; braid_name_flag 2; braid_name_flag 3))

/-- Forget the value of the first cell of memory of the symbolic state whose value is
said. -/
local macro "mem_forget" : tactic =>
  `(tactic| (refine TripleT.forget_mem (by braid_upd) ?_))

/-- After the instructions of an iteration of a copy: forget the word it read and the word
it wrote, and what it left in `x10` and the flags, and close the two arrays. -/
local macro "copy_finish " wm:term ", " mq:term ", " dq:term ", " i:term ", " m:term ", "
    n:term : tactic =>
  `(tactic| (mem_forget
             mem_forget
             sha256_fold cellsAny_index $wm ($mq + 1#64) $i $m $n (by omega)
             sha256_fold cellsAny_index true ($dq + 1#64) $i $m $n (by omega)
             braid_forget 10
             flags_forget
             sha256_done))

/-! ## The loop that copies the block -/

/-- One iteration of the loop that copies the block to the start of the schedule: word `i`
of the sixteen at `mp` to word `i` of those at `dp`, whatever the words are. It ends at the
head of the loop, or after it when `i` is the last. -/
theorem compress_copy_block_step (wm : Bool) (mp dp : Word) (i : Nat) (hi : i < 16)
    (t10 : Word) (fn fz fc fv : Bool) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x100cc#64, .reg x1 mp, .reg x9 dp,
        .reg x8 (BitVec.ofNat 64 (4 * i)), .reg x10 t10,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 wm mp 16), .prop (cellsAny 4 true dp 16)]) t
      (Atoms.interp [.pc (if i = 15 then 0x100e0#64 else 0x100cc#64), .reg x1 mp, .reg x9 dp,
        .reg x8 (BitVec.ofNat 64 (4 * (i + 1))), .prop (regAny x10),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 wm mp 16), .prop (cellsAny 4 true dp 16)])
      (t ++ [.read (mp + BitVec.ofNat 64 (4 * i)) 4, .write (dp + BitVec.ofNat 64 (4 * i)) 4,
        .jump (if i = 15 then 0x100e0#64 else 0x100cc#64)]) := by
  obtain ⟨mq, rfl⟩ : ∃ mq : BitVec 64, mp = mq + 1#64 := ⟨mp - 1#64, by bv_omega⟩
  obtain ⟨dq, rfl⟩ : ∃ dq : BitVec 64, dp = dq + 1#64 := ⟨dp - 1#64, by bv_omega⟩
  braid_unfold cellsAny_index wm (mq + 1#64) i (15 - i) 16 (by omega)
  braid_unfold cellsAny_index true (dq + 1#64) i (15 - i) 16 (by omega)
  braid_name_mem (mq + (1#64 + BitVec.ofNat 64 (4 * i)))
  braid_name_mem (dq + (1#64 + BitVec.ofNat 64 (4 * i)))
  braid_sym_run_to 0x100e0
  · have h : i ≠ 15 := by rintro rfl; exact hbr (by decide)
    simp only [h, ↓reduceIte, ofNat_mul4_succ]
    copy_finish wm, mq, dq, i, 15 - i, 16
  · have h : (i = 15) = True := eq_true (by bv_omega)
    simp only [h, ↓reduceIte, ofNat_mul4_succ]
    copy_finish wm, mq, dq, i, 15 - i, 16

/-- The loop that copies the block to the start of the schedule, from word `i` to the last:
`n + 1` words from `src`, which is word `i` of the sixteen at `mp`, to `dst`, which is word
`i` of those at `dp`, whatever the words are. It reveals `copyLeak` of the two addresses and
the number of words. -/
theorem compress_copy_block_trace (wm : Bool) (mp dp : Word) : ∀ (n i : Nat)
    (src dst t10 : Word) (fn fz fc fv : Bool) (t : Trace), i + n + 1 = 16 →
    src = mp + BitVec.ofNat 64 (4 * i) → dst = dp + BitVec.ofNat 64 (4 * i) →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x100cc#64, .reg x1 mp, .reg x9 dp,
        .reg x8 (BitVec.ofNat 64 (4 * i)), .reg x10 t10,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 wm mp 16), .prop (cellsAny 4 true dp 16)]) t
      (Atoms.interp [.pc 0x100e0#64, .reg x1 mp, .reg x9 dp, .reg x8 64#64,
        .prop (regAny x10),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 wm mp 16), .prop (cellsAny 4 true dp 16)])
      (t ++ copyLeak 0x100cc#64 0x100e0#64 src dst n) := by
  intro n
  induction n with
  | zero =>
    intro i src dst t10 fn fz fc fv t hn hs hd
    obtain rfl : i = 15 := by omega
    subst hs hd
    simp only [copyLeak]
    braid_call compress_copy_block_step wm mp dp 15 (by omega) t10 fn fz fc fv _
    sha256_done
  | succ n ih =>
    intro i src dst t10 fn fz fc fv t hn hs hd
    have h15 : i ≠ 15 := by omega
    subst hs hd
    simp only [copyLeak, BitVec.add_assoc, ofNat_mul4_succ]
    braid_call compress_copy_block_step wm mp dp i (by omega) t10 fn fz fc fv _
    simp only [h15, ↓reduceIte]
    braid_name_reg 10
    flags_name
    braid_call ih (i + 1) _ _ _ _ _ _ _ _ (by omega) rfl rfl
    sha256_done

/-! ## The loop of the message schedule -/

/-- Forget what the loop of the schedule leaves in the registers it uses and in the flags. -/
local macro "schedule_forget" : tactic =>
  `(tactic| (braid_forget 8; braid_forget 10; braid_forget 11; braid_forget 12
             braid_forget 13; braid_forget 14; braid_forget 15; flags_forget))

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

/-- The loop of the message schedule in `sha256_compress`, where `sha256_schedule` is
inlined: with a window of sixteen cells at `q` and `n + 1` cells after it, whatever is in
them, and the count `n + 1` of cells left in `x9`. It reveals `scheduleLoopLeak` of the
address of the first cell it fills and the number of cells. -/
theorem compress_schedule_trace : ∀ (n : Nat) (q c t10 t11 t12 t13 t14 t15 : Word)
    (fn fz fc fv : Bool) (t : Trace), c = BitVec.ofNat 64 (n + 1) → n + 1 < 2 ^ 64 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x100ec#64, .reg x9 c, .reg x8 (q + 64#64),
        .reg x10 t10, .reg x11 t11, .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 true q 16), .prop (cellsAny 4 true (q + 64#64) (n + 1))]) t
      (Atoms.interp [.pc 0x10128#64, .reg x9 0#64, .prop (regAny x8),
        .prop (regAny x10), .prop (regAny x11), .prop (regAny x12), .prop (regAny x13),
        .prop (regAny x14), .prop (regAny x15),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 true q 16), .prop (cellsAny 4 true (q + 64#64) (n + 1))])
      (t ++ scheduleLoopLeak 0x100ec#64 0x10128#64 (q + 64#64) n) := by
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
    braid_sym_run_to 0x10128
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
    braid_sym_run_to 0x10128
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

/-! ## The loop that copies the hash value -/

/-- One iteration of the loop that copies the hash value to the working variables: word `i`
of the eight at `hp` to word `i` of those at `dp`, whatever the words are. It ends at the
head of the loop, or after it when `i` is the last. -/
theorem compress_copy_hash_step (hp dp : Word) (i : Nat) (hi : i < 8)
    (t10 : Word) (fn fz fc fv : Bool) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10130#64, .reg x0 hp, .reg x9 dp,
        .reg x8 (BitVec.ofNat 64 (4 * i)), .reg x10 t10,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 true dp 8)]) t
      (Atoms.interp [.pc (if i = 7 then 0x10144#64 else 0x10130#64), .reg x0 hp, .reg x9 dp,
        .reg x8 (BitVec.ofNat 64 (4 * (i + 1))), .prop (regAny x10),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 true dp 8)])
      (t ++ [.read (hp + BitVec.ofNat 64 (4 * i)) 4, .write (dp + BitVec.ofNat 64 (4 * i)) 4,
        .jump (if i = 7 then 0x10144#64 else 0x10130#64)]) := by
  obtain ⟨mq, rfl⟩ : ∃ mq : BitVec 64, hp = mq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨dq, rfl⟩ : ∃ dq : BitVec 64, dp = dq + 1#64 := ⟨dp - 1#64, by bv_omega⟩
  braid_unfold cellsAny_index true (mq + 1#64) i (7 - i) 8 (by omega)
  braid_unfold cellsAny_index true (dq + 1#64) i (7 - i) 8 (by omega)
  braid_name_mem (mq + (1#64 + BitVec.ofNat 64 (4 * i)))
  braid_name_mem (dq + (1#64 + BitVec.ofNat 64 (4 * i)))
  braid_sym_run_to 0x10144
  · have h : i ≠ 7 := by rintro rfl; exact hbr (by decide)
    simp only [h, ↓reduceIte, ofNat_mul4_succ]
    copy_finish true, mq, dq, i, 7 - i, 8
  · have h : (i = 7) = True := eq_true (by bv_omega)
    simp only [h, ↓reduceIte, ofNat_mul4_succ]
    copy_finish true, mq, dq, i, 7 - i, 8

/-- The loop that copies the hash value to the working variables, from word `i` to the
last: `n + 1` words from `src`, which is word `i` of the eight at `hp`, to `dst`, which is
word `i` of those at `dp`, whatever the words are. It reveals `copyLeak` of the two addresses
and the number of words. -/
theorem compress_copy_hash_trace (hp dp : Word) : ∀ (n i : Nat)
    (src dst t10 : Word) (fn fz fc fv : Bool) (t : Trace), i + n + 1 = 8 →
    src = hp + BitVec.ofNat 64 (4 * i) → dst = dp + BitVec.ofNat 64 (4 * i) →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10130#64, .reg x0 hp, .reg x9 dp,
        .reg x8 (BitVec.ofNat 64 (4 * i)), .reg x10 t10,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 true dp 8)]) t
      (Atoms.interp [.pc 0x10144#64, .reg x0 hp, .reg x9 dp, .reg x8 32#64,
        .prop (regAny x10),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 true dp 8)])
      (t ++ copyLeak 0x10130#64 0x10144#64 src dst n) := by
  intro n
  induction n with
  | zero =>
    intro i src dst t10 fn fz fc fv t hn hs hd
    obtain rfl : i = 7 := by omega
    subst hs hd
    simp only [copyLeak]
    braid_call compress_copy_hash_step hp dp 7 (by omega) t10 fn fz fc fv _
    sha256_done
  | succ n ih =>
    intro i src dst t10 fn fz fc fv t hn hs hd
    have h7 : i ≠ 7 := by omega
    subst hs hd
    simp only [copyLeak, BitVec.add_assoc, ofNat_mul4_succ]
    braid_call compress_copy_hash_step hp dp i (by omega) t10 fn fz fc fv _
    simp only [h7, ↓reduceIte]
    braid_name_reg 10
    flags_name
    braid_call ih (i + 1) _ _ _ _ _ _ _ _ (by omega) rfl rfl
    sha256_done

/-! ## The rounds -/

/-- Forget what a round leaves in the registers of its intermediate values and of the
working variables, and in the flags. -/
local macro "round_forget" : tactic =>
  `(tactic| (braid_forget 1; braid_forget 2; braid_forget 3; braid_forget 4; braid_forget 5
             braid_forget 17; braid_forget 9; braid_forget 10; braid_forget 12
             braid_forget 18; braid_forget 11; braid_forget 13; braid_forget 14
             flags_forget))

/-- Name the values a round left in those registers and in the flags. -/
local macro "round_name" : tactic =>
  `(tactic| (braid_name_reg 1; braid_name_reg 2; braid_name_reg 3; braid_name_reg 4
             braid_name_reg 5; braid_name_reg 17; braid_name_reg 9; braid_name_reg 10
             braid_name_reg 12; braid_name_reg 18; braid_name_reg 11; braid_name_reg 13
             braid_name_reg 14; flags_name))

/-- After the instructions of a round: forget the two words it read and what it computed,
and close the two arrays. -/
local macro "round_finish " wk:term ", " kq:term ", " wq:term ", " i:term : tactic =>
  `(tactic| (mem_forget
             mem_forget
             sha256_fold cellsAny_index $wk ($kq + 1#64) $i (63 - $i) 64 (by omega)
             sha256_fold cellsAny_index true ($wq + 1#64) $i (63 - $i) 64 (by omega)
             round_forget
             sha256_done))

/-- One iteration of the loop of rounds in `sha256_compress`, where `sha256_round` is
inlined and the working variables are in registers: round `i`, with the round constants at
`kp` and the schedule at `wp`, whatever the working variables `a` to `h`, the round constants
and the schedule are. It reads its round constant and its word of the schedule, and no
address or branch of it depends on a working variable. It ends at the head of the loop, or
after it when `i` is the last round. -/
theorem compress_round_step_trace (wk : Bool) (kp wp : Word) (i : Nat) (hi : i < 64)
    (a b c d e f g h t1 t2 t3 t4 t5 : Word) (fn fz fc fv : Bool) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10164#64, .reg x1 t1, .reg x2 t2, .reg x3 t3, .reg x4 t4,
        .reg x5 t5, .reg x8 (BitVec.ofNat 64 (4 * i)), .reg x15 kp, .reg x16 wp,
        .reg x17 a, .reg x9 b, .reg x10 c, .reg x12 d, .reg x18 e, .reg x11 f,
        .reg x13 g, .reg x14 h,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 wk kp 64), .prop (cellsAny 4 true wp 64)]) t
      (Atoms.interp [.pc (if i = 63 then 0x101e8#64 else 0x10164#64),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x3), .prop (regAny x4),
        .prop (regAny x5), .reg x8 (BitVec.ofNat 64 (4 * (i + 1))), .reg x15 kp, .reg x16 wp,
        .prop (regAny x17), .prop (regAny x9), .prop (regAny x10), .prop (regAny x12),
        .prop (regAny x18), .prop (regAny x11), .prop (regAny x13), .prop (regAny x14),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 wk kp 64), .prop (cellsAny 4 true wp 64)])
      (t ++ [.read (kp + BitVec.ofNat 64 (4 * i)) 4, .read (wp + BitVec.ofNat 64 (4 * i)) 4,
        .jump (if i = 63 then 0x101e8#64 else 0x10164#64)]) := by
  obtain ⟨kq, rfl⟩ : ∃ kq : BitVec 64, kp = kq + 1#64 := ⟨kp - 1#64, by bv_omega⟩
  obtain ⟨wq, rfl⟩ : ∃ wq : BitVec 64, wp = wq + 1#64 := ⟨wp - 1#64, by bv_omega⟩
  braid_unfold cellsAny_index wk (kq + 1#64) i (63 - i) 64 (by omega)
  braid_unfold cellsAny_index true (wq + 1#64) i (63 - i) 64 (by omega)
  braid_name_mem (kq + (1#64 + BitVec.ofNat 64 (4 * i)))
  braid_name_mem (wq + (1#64 + BitVec.ofNat 64 (4 * i)))
  braid_sym_run_to 0x101e8
  · have h63 : i ≠ 63 := by rintro rfl; exact hbr (by decide)
    simp only [h63, ↓reduceIte, ofNat_mul4_succ]
    round_finish wk, kq, wq, i
  · have h63 : (i = 63) = True := eq_true (by bv_omega)
    simp only [h63, ↓reduceIte, ofNat_mul4_succ]
    round_finish wk, kq, wq, i

/-- The loop of rounds in `sha256_compress`, from round `i` to the last: `n + 1` rounds,
the first of which reads its round constant at `ka`, which is word `i` of the 64 at `kp`,
and its word of the schedule at `wa`, which is word `i` of the 64 at `wp`, whatever the
working variables, the round constants and the schedule are. It reveals `roundsLeak` of the
two addresses and the number of rounds. -/
theorem compress_rounds_trace (wk : Bool) (kp wp : Word) : ∀ (n i : Nat)
    (ka wa a b c d e f g h t1 t2 t3 t4 t5 : Word) (fn fz fc fv : Bool) (t : Trace),
    i + n + 1 = 64 → ka = kp + BitVec.ofNat 64 (4 * i) → wa = wp + BitVec.ofNat 64 (4 * i) →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10164#64, .reg x1 t1, .reg x2 t2, .reg x3 t3, .reg x4 t4,
        .reg x5 t5, .reg x8 (BitVec.ofNat 64 (4 * i)), .reg x15 kp, .reg x16 wp,
        .reg x17 a, .reg x9 b, .reg x10 c, .reg x12 d, .reg x18 e, .reg x11 f,
        .reg x13 g, .reg x14 h,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 wk kp 64), .prop (cellsAny 4 true wp 64)]) t
      (Atoms.interp [.pc 0x101e8#64,
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x3), .prop (regAny x4),
        .prop (regAny x5), .reg x8 256#64, .reg x15 kp, .reg x16 wp,
        .prop (regAny x17), .prop (regAny x9), .prop (regAny x10), .prop (regAny x12),
        .prop (regAny x18), .prop (regAny x11), .prop (regAny x13), .prop (regAny x14),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 wk kp 64), .prop (cellsAny 4 true wp 64)])
      (t ++ roundsLeak 0x10164#64 0x101e8#64 ka wa n) := by
  intro n
  induction n with
  | zero =>
    intro i ka wa a b c d e f g h t1 t2 t3 t4 t5 fn fz fc fv t hn hk hw
    obtain rfl : i = 63 := by omega
    subst hk hw
    simp only [roundsLeak]
    braid_call compress_round_step_trace wk kp wp 63 (by omega) a b c d e f g h t1 t2 t3 t4 t5
      fn fz fc fv _
    sha256_done
  | succ n ih =>
    intro i ka wa a b c d e f g h t1 t2 t3 t4 t5 fn fz fc fv t hn hk hw
    have h63 : i ≠ 63 := by omega
    subst hk hw
    simp only [roundsLeak, BitVec.add_assoc, ofNat_mul4_succ]
    braid_call compress_round_step_trace wk kp wp i (by omega) a b c d e f g h t1 t2 t3 t4 t5
      fn fz fc fv _
    simp only [h63, ↓reduceIte]
    round_name
    braid_call ih (i + 1) _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by omega) rfl rfl
    sha256_done

/-! ## The loop that adds the working variables to the hash value -/

/-- After the instructions of an iteration of the addition: forget the two words it read,
one of which it wrote, and what it left in registers, and close the two arrays. -/
local macro "add_finish " vq:term ", " hq:term ", " i:term : tactic =>
  `(tactic| (mem_forget
             mem_forget
             sha256_fold cellsAny_index true ($vq + 1#64) $i (7 - $i) 8 (by omega)
             sha256_fold cellsAny_index true ($hq + 1#64) $i (7 - $i) 8 (by omega)
             braid_forget 10
             braid_forget 11
             flags_forget
             sha256_done))

/-- One iteration of the loop that adds the working variables to the hash value: word `i`
of the eight at `vp` added to word `i` of those at `hp`, whatever the words are. It ends at
the head of the loop, or after it when `i` is the last. -/
theorem compress_add_step (vp hp : Word) (i : Nat) (hi : i < 8)
    (t10 t11 : Word) (fn fz fc fv : Bool) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10200#64, .reg x9 vp, .reg x0 hp,
        .reg x8 (BitVec.ofNat 64 (4 * i)), .reg x10 t10, .reg x11 t11,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 true vp 8), .prop (cellsAny 4 true hp 8)]) t
      (Atoms.interp [.pc (if i = 7 then 0x1021c#64 else 0x10200#64), .reg x9 vp, .reg x0 hp,
        .reg x8 (BitVec.ofNat 64 (4 * (i + 1))), .prop (regAny x10), .prop (regAny x11),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 true vp 8), .prop (cellsAny 4 true hp 8)])
      (t ++ [.read (vp + BitVec.ofNat 64 (4 * i)) 4, .read (hp + BitVec.ofNat 64 (4 * i)) 4,
        .write (hp + BitVec.ofNat 64 (4 * i)) 4,
        .jump (if i = 7 then 0x1021c#64 else 0x10200#64)]) := by
  obtain ⟨vq, rfl⟩ : ∃ vq : BitVec 64, vp = vq + 1#64 := ⟨vp - 1#64, by bv_omega⟩
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  braid_unfold cellsAny_index true (vq + 1#64) i (7 - i) 8 (by omega)
  braid_unfold cellsAny_index true (hq + 1#64) i (7 - i) 8 (by omega)
  braid_name_mem (vq + (1#64 + BitVec.ofNat 64 (4 * i)))
  braid_name_mem (hq + (1#64 + BitVec.ofNat 64 (4 * i)))
  braid_sym_run_to 0x1021c
  · have h : i ≠ 7 := by rintro rfl; exact hbr (by decide)
    simp only [h, ↓reduceIte, ofNat_mul4_succ]
    add_finish vq, hq, i
  · have h : (i = 7) = True := eq_true (by bv_omega)
    simp only [h, ↓reduceIte, ofNat_mul4_succ]
    add_finish vq, hq, i

/-- The loop that adds the working variables to the hash value, from word `i` to the last:
`n + 1` words from `va`, which is word `i` of the eight at `vp`, added to those from `ha`,
which is word `i` of the eight at `hp`, whatever the words are. It reveals `addLeak` of the
two addresses and the number of words. -/
theorem compress_add_trace (vp hp : Word) : ∀ (n i : Nat)
    (va ha t10 t11 : Word) (fn fz fc fv : Bool) (t : Trace), i + n + 1 = 8 →
    va = vp + BitVec.ofNat 64 (4 * i) → ha = hp + BitVec.ofNat 64 (4 * i) →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x10200#64, .reg x9 vp, .reg x0 hp,
        .reg x8 (BitVec.ofNat 64 (4 * i)), .reg x10 t10, .reg x11 t11,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 true vp 8), .prop (cellsAny 4 true hp 8)]) t
      (Atoms.interp [.pc 0x1021c#64, .reg x9 vp, .reg x0 hp, .reg x8 32#64,
        .prop (regAny x10), .prop (regAny x11),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 true vp 8), .prop (cellsAny 4 true hp 8)])
      (t ++ addLeak 0x10200#64 0x1021c#64 va ha n) := by
  intro n
  induction n with
  | zero =>
    intro i va ha t10 t11 fn fz fc fv t hn hv hh
    obtain rfl : i = 7 := by omega
    subst hv hh
    simp only [addLeak]
    braid_call compress_add_step vp hp 7 (by omega) t10 t11 fn fz fc fv _
    sha256_done
  | succ n ih =>
    intro i va ha t10 t11 fn fz fc fv t hn hv hh
    have h7 : i ≠ 7 := by omega
    subst hv hh
    simp only [addLeak, BitVec.add_assoc, ofNat_mul4_succ]
    braid_call compress_add_step vp hp i (by omega) t10 t11 fn fz fc fv _
    simp only [h7, ↓reduceIte]
    braid_name_reg 10
    braid_name_reg 11
    flags_name
    braid_call ih (i + 1) _ _ _ _ _ _ _ _ _ (by omega) rfl rfl
    sha256_done

/-! ## The compression function -/

/-- Name the values of the eight working variables on the stack. -/
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

/-- **What `sha256_compress` reveals.** From the precondition of `sha256_compress_spec`, the
code runs to its return and reveals `compressLeak` of the two pointers, the stack pointer and
the return address: the hash value `H`, the block `M`, the round constants and what was on
the stack are not in the trace. The postcondition keeps where the arrays are and forgets
what is in them. -/
theorem sha256_compress_trace (hp mp s r fp sv : Word) (H M : List W32) (wm : Bool)
    (fvs fws : List Word) (t2 t3 t4 t5 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 : Word)
    (fn fz fc fv : Bool) (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 8)
    (hfw : fws.length = 64) (hs : s &&& 15#64 = 0#64) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x100bc#64, .reg x0 hp, .reg x1 mp, .reg x2 t2, .reg x3 t3,
        .reg x4 t4, .reg x5 t5, .reg x8 t8, .reg x9 t9, .reg x10 t10, .reg x11 t11,
        .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15, .reg x16 t16, .reg x17 t17,
        .reg x18 t18, .reg x29 fp, .reg lr r, .reg sp s,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 false 0x20228#64 (w32s K)),
        .prop (cellsAt 4 true (s - 0x130#64) fvs), .prop (cellsAt 4 true (s - 0x110#64) fws),
        .prop (cellsAt 8 true (s - 0x10#64) [sv])]) t
      (Atoms.interp [.pc r, .reg x0 hp, .prop (regAny x1), .prop (regAny x2),
        .prop (regAny x3), .prop (regAny x4), .prop (regAny x5), .prop (regAny x8),
        .prop (regAny x9), .prop (regAny x10), .prop (regAny x11), .prop (regAny x12),
        .prop (regAny x13), .prop (regAny x14), .prop (regAny x15), .prop (regAny x16),
        .prop (regAny x17), .prop (regAny x18), .reg x29 fp, .reg lr r, .reg sp s,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 wm mp 16),
        .prop (cellsAny 4 false 0x20228#64 64),
        .prop (cellsAny 4 true (s - 0x130#64) 8), .prop (cellsAny 4 true (s - 0x110#64) 64),
        .prop (cellsAt 8 true (s - 0x10#64) [fp])])
      (t ++ compressLeak hp mp s r) := by
  simp only [compressLeak]
  -- Nothing the code reveals depends on what the arrays hold.
  braid_forget_cells hp, 8, (by simp [hH])
  braid_forget_cells mp, 16, (by simp [hM])
  braid_forget_cells 0x20228#64, 64, (by rw [w32s_length]; rfl)
  braid_forget_cells (s - 0x130#64), 8, hfv
  braid_forget_cells (s - 0x110#64), 64, hfw
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 0x131#64 := ⟨s - 0x131#64, by bv_omega⟩
  braid_unfold cellsAny_pre16 true (sq + 33#64) 48 64 rfl
  sha256_fold cellsAny16 true (sq + 33#64)
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 289#64) sv []
  -- The frame, and the block copied to the start of the schedule.
  braid_sym_run_to 0x100cc
  braid_call compress_copy_block_trace wm mp (sq + 33#64) 15 0 _ _ _ _ _ _ _ _ (by omega)
    rfl rfl
  braid_name_reg 10
  flags_name
  -- The message schedule.
  braid_sym_run_to 0x100ec
  braid_call compress_schedule_trace 47 (sq + 33#64) 48#64 _ _ _ _ _ _ _ _ _ _ _ rfl
    (by omega)
  braid_name_reg 8
  braid_name_reg 10
  braid_name_reg 11
  braid_name_reg 12
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  flags_name
  -- The hash value copied to the working variables, and those loaded into registers.
  braid_sym_run_to 0x10130
  braid_call compress_copy_hash_trace hp (sq + 1#64) 7 0 _ _ _ _ _ _ _ _ (by omega) rfl rfl
  braid_name_reg 10
  flags_name
  braid_unfold cellsAny8 true (sq + 1#64)
  vars_name sq
  braid_sym_run_to 0x10164
  vars_forget sq
  sha256_fold cellsAny8 true (sq + 1#64)
  braid_unfold cellsAny16 true (sq + 33#64)
  sha256_fold cellsAny_pre16 true (sq + 33#64) 48 64 rfl
  -- The rounds.
  braid_call compress_rounds_trace false 0x20228#64 (sq + 33#64) 63 0
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by omega) rfl rfl
  round_name
  -- The working variables stored, and added to the hash value; the frame pointer restored.
  braid_unfold cellsAny8 true (sq + 1#64)
  vars_name sq
  braid_sym_run_to 0x10200
  vars_forget sq
  sha256_fold cellsAny8 true (sq + 1#64)
  braid_call compress_add_trace (sq + 1#64) hp 7 0 _ _ _ _ _ _ _ _ _ (by omega) rfl rfl
  braid_name_reg 10
  braid_name_reg 11
  flags_name
  braid_sym_run
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 289#64) fp []
  braid_forget 1
  braid_forget 2
  braid_forget 3
  braid_forget 4
  braid_forget 5
  braid_forget 8
  braid_forget 9
  braid_forget 10
  braid_forget 11
  braid_forget 12
  braid_forget 13
  braid_forget 14
  braid_forget 15
  braid_forget 16
  braid_forget 17
  braid_forget 18
  flags_forget
  sha256_done

end Examples.Sha256.Arm
