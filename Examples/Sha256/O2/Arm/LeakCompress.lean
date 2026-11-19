/-
  Examples.Sha256.O2.Arm.LeakCompress

  What `sha256_compress` reveals on AArch64, compiled at `-O2` (`docs/Leakage.md`): a traced
  triple. The trace is not that of `-O1`, because the code is not: the three loops that copy
  and the loop that adds are gone, and with them their branches and every access to a copy
  of the working variables on the stack, which is not kept; the block is copied by loads and
  stores in a line, four of them of eight bytes; seven registers are saved where one was; the
  frame is 320 bytes and the round constants are at `0x20264`. What is left is two loops, of
  the schedule and of the rounds, with straight-line code around them. So `compressLeak` is
  defined again here. It is still a function of the two pointers, the stack pointer and the
  return address, and of nothing else.

  The two loops are those of `Examples.Sha256.Arm.LeakCompress`: the loop of the schedule
  with two addresses replaced, and the loop of rounds with its registers renamed and two
  addresses replaced; their proofs are the same text. What each iteration of them reveals
  (`scheduleLoopLeak` of `Examples.Sha256.Arm.LeakBase`, `roundsLeak`) is the same function
  at `-O2`, given other addresses. The function itself is run again, in three triples
  (`compress_head_trace`, `compress_tail_trace` and `sha256_compress_trace`, which joins
  them) cut where `sha256_compress_spec` at `-O2` is cut. A load or a store of eight bytes
  over two 32-bit cells of forgotten contents finds one cell of eight bytes of forgotten
  contents (`memAny_pair`). Nothing is said of a value the code computes. The theorem about
  the machine is in `LeakMachine`.

  ## Main definitions

  * `roundsLeak`: what the loop of rounds reveals
  * `headLeak`, `tailLeak`: what the code before the loops and after them reveals
  * `compressLeak`: what `sha256_compress` reveals, from its two pointers, the stack pointer
    and the return address

  ## Main results

  * `memAny_pair`: two 32-bit cells of forgotten contents are a cell of eight bytes
  * `compress_schedule_trace`, `compress_rounds_trace`: the loops
  * `compress_head_trace`, `compress_tail_trace`: the parts
  * `sha256_compress_trace`: the code reveals `compressLeak`
-/

module

public import Examples.Sha256.O2.Arm.Compress
public import Examples.Sha256.Arm.LeakBase
import Iris.BI.DerivedLaws

@[expose] public section

namespace Examples.Sha256.O2.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs
open Examples.Sha256.Arm
open Iris Iris.BI

/-! ## What the code reveals -/

/-- What the loop of rounds reveals, with `n + 1` rounds left: each reads its round constant
at `ka` and its word of the schedule at `wa`, and branches back to `head` or on to
`exit`. -/
def roundsLeak (head exit : Word) (ka wa : Word) : Nat → Trace
  | 0 => [.read ka 4, .read wa 4, .jump exit]
  | n + 1 => [.read ka 4, .read wa 4, .jump head] ++
      roundsLeak head exit (ka + 4#64) (wa + 4#64) n

/-- What `sha256_compress` reveals to the end of the message schedule, given the pointer `mp`
to the block and the stack pointer `s`: the frame pointer and six registers saved, the block
copied to the stack, four times as eight bytes and eight times as four, and the 48 words of
the schedule filled. -/
def headLeak (mp s : Word) : Trace :=
  [.read mp 8, .read (mp + 8#64) 4, .read (mp + 12#64) 8, .write (s - 64#64) 8,
    .write (s - 320#64) 8, .read (mp + 20#64) 4, .write (s - 312#64) 4,
    .write (s - 300#64) 4, .read (mp + 24#64) 8, .read (mp + 32#64) 8,
    .write (s - 308#64) 8, .write (s - 48#64) 8, .write (s - 40#64) 8,
    .write (s - 296#64) 8, .write (s - 288#64) 8, .read (mp + 40#64) 4,
    .read (mp + 44#64) 4, .write (s - 32#64) 8, .write (s - 24#64) 8, .write (s - 16#64) 8,
    .write (s - 8#64) 8, .write (s - 280#64) 4, .write (s - 276#64) 4,
    .read (mp + 48#64) 4, .read (mp + 52#64) 4, .write (s - 272#64) 4,
    .write (s - 268#64) 4, .read (mp + 56#64) 4, .read (mp + 60#64) 4,
    .write (s - 264#64) 4, .write (s - 260#64) 4] ++
  scheduleLoopLeak 0x1011c#64 0x10158#64 (s - 256#64) 47

/-- What `sha256_compress` reveals from the end of the loop of rounds, given the pointer `hp`
to the hash value, the stack pointer `s` and the return address `r`: the hash value written,
two words at a time, the six registers and the frame pointer restored between the stores,
and the return. -/
def tailLeak (hp s r : Word) : Trace :=
  [.write (hp + 8#64) 4, .write (hp + 12#64) 4, .read (s - 16#64) 8, .read (s - 8#64) 8,
    .read (s - 32#64) 8, .read (s - 24#64) 8, .write (hp + 16#64) 4, .write (hp + 20#64) 4,
    .read (s - 48#64) 8, .read (s - 40#64) 8, .read (s - 64#64) 8, .write hp 4,
    .write (hp + 4#64) 4, .write (hp + 24#64) 4, .write (hp + 28#64) 4, .jump r]

/-- **What `sha256_compress` reveals**, given the pointer `hp` to the hash value, the pointer
`mp` to the block, the stack pointer `s` and the return address `r`: `headLeak`, the hash
value read, the 64 rounds, each reading a round constant and a word of the schedule, and
`tailLeak`. Every address in it is a constant or one of the three addresses plus a
constant. -/
def compressLeak (hp mp s r : Word) : Trace :=
  headLeak mp s ++
  [.read hp 4, .read (hp + 4#64) 4, .read (hp + 8#64) 4, .read (hp + 12#64) 4,
    .read (hp + 16#64) 4, .read (hp + 20#64) 4, .read (hp + 24#64) 4, .read (hp + 28#64) 4] ++
  roundsLeak 0x10198#64 0x1021c#64 0x20264#64 (s - 320#64) 63 ++
  tailLeak hp s r

/-! ## Two 32-bit cells of forgotten contents as one of eight bytes -/

/-- **Two 32-bit cells of forgotten contents as one of eight bytes.** A cell of eight bytes
at `p`, whatever it holds, is a 32-bit cell at `p` and one at `q`, four bytes on, whatever
they hold: `mem_pair`, with the contents forgotten. -/
theorem memAny_pair (w : Bool) (p q : Word) (h : q = p + 4#64) :
    (Atom.prop (memAny p 8 w)).interp =
      Atoms.interp [.prop (memAny p 4 w), .prop (memAny q 4 w)] := by
  have e : ∀ x y : Word, memIs p 8 (pair x y) w =
      iprop(memIs p 4 x w ∗ memIs q 4 y w ∗ emp) := fun x y => by
    have := mem_pair w p q x y h
    simpa only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil] using this
  have hv : ∀ v : Word, pair v (v >>> 32) = v := fun v => by unfold pair; bv_decide
  simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil, memAny]
  refine SProp.ext ⟨exists_elim fun v => ?_, ?_⟩
  · rw [← hv v, e]
    exact sep_mono (exists_intro (Ψ := fun v => memIs p 4 v w) _)
      (sep_mono_left (exists_intro (Ψ := fun v => memIs q 4 v w) _))
  · refine sep_exists_right.1.trans (exists_elim fun x => ?_)
    refine (sep_mono_right sep_exists_right.1).trans ?_
    refine sep_exists_left.1.trans (exists_elim fun y => ?_)
    rw [← e x y]
    exact exists_intro (Ψ := fun v => memIs p 8 v w) _

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
      (Atoms.interp [.pc 0x1011c#64, .reg x9 c, .reg x8 (q + 64#64),
        .reg x10 t10, .reg x11 t11, .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 true q 16), .prop (cellsAny 4 true (q + 64#64) (n + 1))]) t
      (Atoms.interp [.pc 0x10158#64, .reg x9 0#64, .prop (regAny x8),
        .prop (regAny x10), .prop (regAny x11), .prop (regAny x12), .prop (regAny x13),
        .prop (regAny x14), .prop (regAny x15),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 true q 16), .prop (cellsAny 4 true (q + 64#64) (n + 1))])
      (t ++ scheduleLoopLeak 0x1011c#64 0x10158#64 (q + 64#64) n) := by
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
    braid_sym_run_to 0x10158
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
    braid_sym_run_to 0x10158
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

/-! ## The rounds -/

/-- Forget what a round leaves in the registers of its intermediate values and of the
working variables, and in the flags. -/
local macro "round_forget" : tactic =>
  `(tactic| (braid_forget 20; braid_forget 21; braid_forget 22; braid_forget 23; braid_forget 24
             braid_forget 19; braid_forget 6; braid_forget 3; braid_forget 4
             braid_forget 7; braid_forget 1; braid_forget 17; braid_forget 18
             flags_forget))

/-- Name the values a round left in those registers and in the flags. -/
local macro "round_name" : tactic =>
  `(tactic| (braid_name_reg 20; braid_name_reg 21; braid_name_reg 22; braid_name_reg 23
             braid_name_reg 24; braid_name_reg 19; braid_name_reg 6; braid_name_reg 3
             braid_name_reg 4; braid_name_reg 7; braid_name_reg 1; braid_name_reg 17
             braid_name_reg 18; flags_name))

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
      (Atoms.interp [.pc 0x10198#64, .reg x20 t1, .reg x21 t2, .reg x22 t3, .reg x23 t4,
        .reg x24 t5, .reg x12 (BitVec.ofNat 64 (4 * i)), .reg x2 kp, .reg x5 wp,
        .reg x19 a, .reg x6 b, .reg x3 c, .reg x4 d, .reg x7 e, .reg x1 f,
        .reg x17 g, .reg x18 h,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 wk kp 64), .prop (cellsAny 4 true wp 64)]) t
      (Atoms.interp [.pc (if i = 63 then 0x1021c#64 else 0x10198#64),
        .prop (regAny x20), .prop (regAny x21), .prop (regAny x22), .prop (regAny x23),
        .prop (regAny x24), .reg x12 (BitVec.ofNat 64 (4 * (i + 1))), .reg x2 kp, .reg x5 wp,
        .prop (regAny x19), .prop (regAny x6), .prop (regAny x3), .prop (regAny x4),
        .prop (regAny x7), .prop (regAny x1), .prop (regAny x17), .prop (regAny x18),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 wk kp 64), .prop (cellsAny 4 true wp 64)])
      (t ++ [.read (kp + BitVec.ofNat 64 (4 * i)) 4, .read (wp + BitVec.ofNat 64 (4 * i)) 4,
        .jump (if i = 63 then 0x1021c#64 else 0x10198#64)]) := by
  obtain ⟨kq, rfl⟩ : ∃ kq : BitVec 64, kp = kq + 1#64 := ⟨kp - 1#64, by bv_omega⟩
  obtain ⟨wq, rfl⟩ : ∃ wq : BitVec 64, wp = wq + 1#64 := ⟨wp - 1#64, by bv_omega⟩
  braid_unfold cellsAny_index wk (kq + 1#64) i (63 - i) 64 (by omega)
  braid_unfold cellsAny_index true (wq + 1#64) i (63 - i) 64 (by omega)
  braid_name_mem (kq + (1#64 + BitVec.ofNat 64 (4 * i)))
  braid_name_mem (wq + (1#64 + BitVec.ofNat 64 (4 * i)))
  braid_sym_run_to 0x1021c
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
      (Atoms.interp [.pc 0x10198#64, .reg x20 t1, .reg x21 t2, .reg x22 t3, .reg x23 t4,
        .reg x24 t5, .reg x12 (BitVec.ofNat 64 (4 * i)), .reg x2 kp, .reg x5 wp,
        .reg x19 a, .reg x6 b, .reg x3 c, .reg x4 d, .reg x7 e, .reg x1 f,
        .reg x17 g, .reg x18 h,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 wk kp 64), .prop (cellsAny 4 true wp 64)]) t
      (Atoms.interp [.pc 0x1021c#64,
        .prop (regAny x20), .prop (regAny x21), .prop (regAny x22), .prop (regAny x23),
        .prop (regAny x24), .reg x12 256#64, .reg x2 kp, .reg x5 wp,
        .prop (regAny x19), .prop (regAny x6), .prop (regAny x3), .prop (regAny x4),
        .prop (regAny x7), .prop (regAny x1), .prop (regAny x17), .prop (regAny x18),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 wk kp 64), .prop (cellsAny 4 true wp 64)])
      (t ++ roundsLeak 0x10198#64 0x1021c#64 ka wa n) := by
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

/-! ## The compression function -/

/-- Close four pairs of 32-bit cells of the sixteen at `q + 1`, those the code moves as eight
bytes: words 0 and 1, 3 and 4, 6 and 7, 8 and 9. -/
local macro "pairs_fold " w:term ", " q:term : tactic =>
  `(tactic| (sha256_fold memAny_pair $w ($q + 1#64) ($q + 5#64) (by bv_omega)
             sha256_fold memAny_pair $w ($q + 13#64) ($q + 17#64) (by bv_omega)
             sha256_fold memAny_pair $w ($q + 25#64) ($q + 29#64) (by bv_omega)
             sha256_fold memAny_pair $w ($q + 33#64) ($q + 37#64) (by bv_omega)))

/-- Open them again. -/
local macro "pairs_unfold " w:term ", " q:term : tactic =>
  `(tactic| (braid_unfold memAny_pair $w ($q + 1#64) ($q + 5#64) (by bv_omega)
             braid_unfold memAny_pair $w ($q + 13#64) ($q + 17#64) (by bv_omega)
             braid_unfold memAny_pair $w ($q + 25#64) ($q + 29#64) (by bv_omega)
             braid_unfold memAny_pair $w ($q + 33#64) ($q + 37#64) (by bv_omega)))

/-- Name the values of the sixteen words at `q + 1`, as the code moves them: four cells of
eight bytes and eight of four. -/
local macro "block_name " q:term : tactic =>
  `(tactic| (braid_name_mem ($q + 1#64); braid_name_mem ($q + 9#64)
             braid_name_mem ($q + 13#64); braid_name_mem ($q + 21#64)
             braid_name_mem ($q + 25#64); braid_name_mem ($q + 33#64)
             braid_name_mem ($q + 41#64); braid_name_mem ($q + 45#64)
             braid_name_mem ($q + 49#64); braid_name_mem ($q + 53#64)
             braid_name_mem ($q + 57#64); braid_name_mem ($q + 61#64)))

/-- Forget them again. -/
local macro "block_forget " q:term : tactic =>
  `(tactic| (braid_forget_mem ($q + 1#64); braid_forget_mem ($q + 9#64)
             braid_forget_mem ($q + 13#64); braid_forget_mem ($q + 21#64)
             braid_forget_mem ($q + 25#64); braid_forget_mem ($q + 33#64)
             braid_forget_mem ($q + 41#64); braid_forget_mem ($q + 45#64)
             braid_forget_mem ($q + 49#64); braid_forget_mem ($q + 53#64)
             braid_forget_mem ($q + 57#64); braid_forget_mem ($q + 61#64)))

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

/-- **What the head of `sha256_compress` reveals**, to the end of the message schedule:
`headLeak` of the pointer to the block and the stack pointer, whatever the block and the 256
bytes of the schedule hold. -/
theorem compress_head_trace (mp s fp sv : Word) (wm : Bool) (svs : List Word)
    (t8 t9 t10 t11 t12 t13 t14 t15 v19 v20 v21 v22 v23 v24 : Word) (fn fz fc fv : Bool)
    (hsvs : svs.length = 6) (hs : s &&& 15#64 = 0#64) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x100bc#64, .reg x1 mp, .reg x8 t8, .reg x9 t9, .reg x10 t10,
        .reg x11 t11, .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15,
        .reg x19 v19, .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg x23 v23, .reg x24 v24,
        .reg x29 fp, .reg sp s,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAny 4 wm mp 16), .prop (cellsAny 4 true (s - 0x140#64) 64),
        .prop (cellsAt 8 true (s - 0x40#64) [sv]), .prop (cellsAt 8 true (s - 0x30#64) svs)]) t
      (Atoms.interp [.pc 0x10158#64, .reg x1 mp, .prop (regAny x8), .reg x9 0#64,
        .prop (regAny x10), .prop (regAny x11), .prop (regAny x12), .prop (regAny x13),
        .prop (regAny x14), .prop (regAny x15),
        .reg x19 v19, .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg x23 v23, .reg x24 v24,
        .reg x29 fp, .reg sp (s - 0x140#64),
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 wm mp 16), .prop (cellsAny 4 true (s - 0x140#64) 64),
        .prop (cellsAt 8 true (s - 0x40#64) [fp]),
        .prop (cellsAt 8 true (s - 0x30#64) [v24, v23, v22, v21, v20, v19])])
      (t ++ headLeak mp s) := by
  simp only [headLeak]
  obtain ⟨g0, g1, g2, g3, g4, g5, rfl⟩ := eq_of_length_6 hsvs
  obtain ⟨mq, rfl⟩ : ∃ mq : BitVec 64, mp = mq + 1#64 := ⟨mp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 0x141#64 := ⟨s - 0x141#64, by bv_omega⟩
  braid_unfold cellsAny16 wm (mq + 1#64)
  braid_unfold cellsAny_pre16 true (sq + 1#64) 48 64 rfl
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 257#64) sv []
  braid_unfold saved_cells (sq + 273#64) g0 g1 g2 g3 g4 g5
  -- The words of the block, and the cells of the schedule, that the code moves in pairs.
  pairs_fold wm, mq
  pairs_fold true, sq
  block_name mq
  block_name sq
  -- The frame, and the block copied to the start of the schedule.
  braid_sym_run_to 0x1011c
  block_forget mq
  block_forget sq
  pairs_unfold wm, mq
  pairs_unfold true, sq
  sha256_fold cellsAny16 wm (mq + 1#64)
  sha256_fold cellsAny16 true (sq + 1#64)
  -- The message schedule.
  braid_call compress_schedule_trace 47 (sq + 1#64) 48#64 _ _ _ _ _ _ _ _ _ _ _ rfl
    (by omega)
  braid_unfold cellsAny16 true (sq + 1#64)
  sha256_fold cellsAny_pre16 true (sq + 1#64) 48 64 rfl
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 257#64) fp []
  sha256_fold saved_cells (sq + 273#64) v24 v23 v22 v21 v20 v19
  sha256_done

/-- **What the tail of `sha256_compress` reveals**, from the end of the loop of rounds:
`tailLeak` of the pointer to the hash value, the stack pointer and the return address,
whatever the registers of the hash value and of the working variables hold. -/
theorem compress_tail_trace (hp s r fp : Word)
    (y10 y11 y9 y8 y16 y15 y14 y13 a b c d e f g h t20 t21 t22 t23 t24 : Word)
    (v19 v20 v21 v22 v23 v24 : Word) (hs : s &&& 15#64 = 0#64) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x1021c#64, .reg x0 hp, .reg x10 y10, .reg x11 y11, .reg x9 y9,
        .reg x8 y8, .reg x16 y16, .reg x15 y15, .reg x14 y14, .reg x13 y13,
        .reg x19 a, .reg x6 b, .reg x3 c, .reg x4 d, .reg x7 e, .reg x1 f,
        .reg x17 g, .reg x18 h,
        .reg x20 t20, .reg x21 t21, .reg x22 t22, .reg x23 t23, .reg x24 t24,
        .reg x29 fp, .reg lr r, .reg sp (s - 0x140#64),
        .prop (cellsAny 4 true hp 8),
        .prop (cellsAt 8 true (s - 0x40#64) [fp]),
        .prop (cellsAt 8 true (s - 0x30#64) [v24, v23, v22, v21, v20, v19])]) t
      (Atoms.interp [.pc r, .reg x0 hp, .prop (regAny x10), .prop (regAny x11),
        .prop (regAny x9), .prop (regAny x8), .prop (regAny x16), .prop (regAny x15),
        .prop (regAny x14), .prop (regAny x13),
        .reg x19 v19, .prop (regAny x6), .prop (regAny x3), .prop (regAny x4),
        .prop (regAny x7), .prop (regAny x1), .prop (regAny x17), .prop (regAny x18),
        .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg x23 v23, .reg x24 v24,
        .reg x29 fp, .reg lr r, .reg sp s,
        .prop (cellsAny 4 true hp 8),
        .prop (cellsAt 8 true (s - 0x40#64) [fp]),
        .prop (cellsAt 8 true (s - 0x30#64) [v24, v23, v22, v21, v20, v19])])
      (t ++ tailLeak hp s r) := by
  simp only [tailLeak]
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 0x141#64 := ⟨s - 0x141#64, by bv_omega⟩
  braid_unfold cellsAny8 true (hq + 1#64)
  vars_name hq
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 257#64) fp []
  braid_unfold saved_cells (sq + 273#64) v24 v23 v22 v21 v20 v19
  -- The working variables added to the hash value, and the registers restored.
  braid_sym_run
  vars_forget hq
  sha256_fold cellsAny8 true (hq + 1#64)
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 257#64) fp []
  sha256_fold saved_cells (sq + 273#64) v24 v23 v22 v21 v20 v19
  braid_forget 1
  braid_forget 3
  braid_forget 4
  braid_forget 6
  braid_forget 7
  braid_forget 8
  braid_forget 9
  braid_forget 10
  braid_forget 11
  braid_forget 13
  braid_forget 14
  braid_forget 15
  braid_forget 16
  braid_forget 17
  braid_forget 18
  sha256_done

/-- **What `sha256_compress` reveals.** From the precondition of `sha256_compress_spec`, the
code runs to its return and reveals `compressLeak` of the two pointers, the stack pointer and
the return address: the hash value `H`, the block `M`, the round constants and what was on
the stack are not in the trace. The postcondition keeps where the arrays are and forgets
what is in them. -/
theorem sha256_compress_trace (hp mp s r fp sv : Word) (H M : List W32) (wm : Bool)
    (fws svs : List Word) (t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 : Word)
    (v19 v20 v21 v22 v23 v24 : Word)
    (fn fz fc fv : Bool) (hH : H.length = 8) (hM : M.length = 16)
    (hfw : fws.length = 64) (hsvs : svs.length = 6) (hs : s &&& 15#64 = 0#64) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp (.pc 0x100bc#64 :: .reg x0 hp :: .reg x1 mp :: .reg x2 t2 :: .reg x3 t3 ::
        .reg x4 t4 :: .reg x5 t5 :: .reg x6 t6 :: .reg x7 t7 :: .reg x8 t8 :: .reg x9 t9 ::
        [.reg x10 t10, .reg x11 t11,
        .reg x12 t12, .reg x13 t13, .reg x14 t14, .reg x15 t15, .reg x16 t16, .reg x17 t17,
        .reg x18 t18, .reg x19 v19, .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg x23 v23,
        .reg x24 v24, .reg x29 fp, .reg lr r, .reg sp s,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 false 0x20264#64 (w32s K)),
        .prop (cellsAt 4 true (s - 0x140#64) fws),
        .prop (cellsAt 8 true (s - 0x40#64) [sv]), .prop (cellsAt 8 true (s - 0x30#64) svs)])) t
      (Atoms.interp (.pc r :: .reg x0 hp :: .prop (regAny x1) :: .prop (regAny x2) ::
        .prop (regAny x3) :: .prop (regAny x4) :: .prop (regAny x5) :: .prop (regAny x6) ::
        .prop (regAny x7) :: .prop (regAny x8) ::
        [.prop (regAny x9), .prop (regAny x10), .prop (regAny x11), .prop (regAny x12),
        .prop (regAny x13), .prop (regAny x14), .prop (regAny x15), .prop (regAny x16),
        .prop (regAny x17), .prop (regAny x18), .reg x19 v19, .reg x20 v20, .reg x21 v21,
        .reg x22 v22, .reg x23 v23, .reg x24 v24, .reg x29 fp, .reg lr r, .reg sp s,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 wm mp 16),
        .prop (cellsAny 4 false 0x20264#64 64),
        .prop (cellsAny 4 true (s - 0x140#64) 64),
        .prop (cellsAt 8 true (s - 0x40#64) [fp]),
        .prop (cellsAt 8 true (s - 0x30#64) [v24, v23, v22, v21, v20, v19])]))
      (t ++ compressLeak hp mp s r) := by
  simp only [compressLeak]
  -- Nothing the code reveals depends on what the arrays hold.
  braid_forget_cells hp, 8, (by simp [hH])
  braid_forget_cells mp, 16, (by simp [hM])
  braid_forget_cells 0x20264#64, 64, (by rw [w32s_length]; rfl)
  braid_forget_cells (s - 0x140#64), 64, hfw
  -- The frame, the block copied to the start of the schedule, and the message schedule.
  braid_call compress_head_trace mp s fp sv wm svs t8 t9 t10 t11 t12 t13 t14 t15
    v19 v20 v21 v22 v23 v24 fn fz fc fv hsvs hs t
  braid_name_reg 8
  braid_name_reg 10
  braid_name_reg 11
  braid_name_reg 12
  braid_name_reg 13
  braid_name_reg 14
  braid_name_reg 15
  flags_name
  -- The hash value loaded into registers, and copied to those of the working variables.
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 0x141#64 := ⟨s - 0x141#64, by bv_omega⟩
  braid_unfold cellsAny8 true (hq + 1#64)
  vars_name hq
  braid_sym_run_to 0x10198
  vars_forget hq
  sha256_fold cellsAny8 true (hq + 1#64)
  -- The rounds.
  braid_call compress_rounds_trace false 0x20264#64 (sq + 1#64) 63 0
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by omega) rfl rfl
  round_name
  -- The working variables added to the hash value, and the registers restored.
  braid_call compress_tail_trace (hq + 1#64) (sq + 0x141#64) r fp
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ v19 v20 v21 v22 v23 v24 hs _
  braid_forget 2
  braid_forget 5
  braid_forget 12
  flags_forget
  sha256_done

end Examples.Sha256.O2.Arm
