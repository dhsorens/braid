/-
  Examples.Sha256.X86.LeakCompress

  What `sha256_compress` reveals on x86-64 (`docs/Leakage.md`): a traced triple. The
  compiler inlined the schedule and the round, so the function is five loops with
  straight-line code between them. Each loop is an induction on the iterations left, over
  arrays of forgotten contents (`Braid.Logic.Any`), and the function calls the five. The
  code addresses its arrays with an index register, so a loop is stated with the addresses
  of the cells of its first iteration and equations between those addresses and the index.
  No loop is run out, and nothing is said of a value the code computes. The theorem about
  the machine is in `LeakMachine`.

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

public import Examples.Sha256.X86.Compress
public import Examples.Sha256.X86.LeakBase

public section

namespace Examples.Sha256.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- A sum as the lowering writes it: the stepper finds a memory atom by its address as a
term, and `a + b` as the elaborator reads it may have other type arguments. -/
local notation:65 a:65 " +ₐ " b:66 => @HAdd.hAdd Word Word Word _ a b

/-- A product as the lowering writes it (see `+ₐ`). -/
local notation:70 a:70 " *ₐ " b:71 => @HMul.hMul Word Word Word _ a b

/-! ## What the loops reveal -/

/-- What a loop that copies `n + 1` words from `src` to `dst` reveals: each word read and
written, and the branch at the end of each iteration, back to `head` or on to `exit`. -/
def copyLeak (head exit : Word) (src dst : Word) : Nat → Trace
  | 0 => [.read src 4, .write dst 4, .jump exit]
  | n + 1 => [.read src 4, .write dst 4, .jump head] ++
      copyLeak head exit (src + 4#64) (dst + 4#64) n

/-- What the loop of rounds reveals, with `n + 1` rounds left: each reads its word of the
schedule at `wa` and its round constant at `ka`, and branches back to `head` or on to
`exit`. -/
def roundsLeak (head exit : Word) (wa ka : Word) : Nat → Trace
  | 0 => [.read wa 4, .read ka 4, .jump exit]
  | n + 1 => [.read wa 4, .read ka 4, .jump head] ++
      roundsLeak head exit (wa + 4#64) (ka + 4#64) n

/-- What the loop that adds `n + 1` working variables at `va` to the hash value at `ha`
reveals: the two words read, the sum written, and the branch. -/
def addLeak (head exit : Word) (va ha : Word) : Nat → Trace
  | 0 => [.read va 4, .read ha 4, .write ha 4, .jump exit]
  | n + 1 => [.read va 4, .read ha 4, .write ha 4, .jump head] ++
      addLeak head exit (va + 4#64) (ha + 4#64) n

/-- What `sha256_compress` reveals, given the pointer `hp` to the hash value, the pointer
`mp` to the block, the stack pointer `s` and the return address `r`: five registers pushed,
the block copied to the stack, the 48 words of the schedule filled, the hash value copied to
the working variables and those read, the 64 rounds, each reading a word of the schedule and
a round constant, the working variables written and added to the hash value, the registers
popped, the return address read from the stack, and the return. Every address is a constant
or one of the three addresses plus a constant. -/
def compressLeak (hp mp s r : Word) : Trace :=
  [.write (s - 8#64) 8, .write (s - 16#64) 8, .write (s - 24#64) 8, .write (s - 32#64) 8,
    .write (s - 40#64) 8] ++
  copyLeak 0x401120#64 0x401130#64 mp (s - 296#64) 15 ++
  scheduleLoopLeak 0x401140#64 0x40118b#64 (s - 232#64) 47 ++
  copyLeak 0x401190#64 0x4011a0#64 hp (s - 328#64) 7 ++
  [.read (s - 328#64) 4, .read (s - 324#64) 4, .read (s - 320#64) 4, .read (s - 316#64) 4,
    .read (s - 312#64) 4, .read (s - 308#64) 4, .read (s - 304#64) 4, .read (s - 300#64) 4] ++
  roundsLeak 0x4011d0#64 0x40125e#64 (s - 296#64) 0x4022b0#64 63 ++
  [.write (s - 328#64) 4, .write (s - 324#64) 4, .write (s - 320#64) 4,
    .write (s - 316#64) 4, .write (s - 312#64) 4, .write (s - 308#64) 4,
    .write (s - 304#64) 4, .write (s - 300#64) 4] ++
  addLeak 0x401290#64 0x4012a0#64 (s - 328#64) hp 7 ++
  [.read (s - 40#64) 8, .read (s - 32#64) 8, .read (s - 24#64) 8, .read (s - 16#64) 8,
    .read (s - 8#64) 8, .read s 8, .jump r]

/-! ## The loops -/

/-- The loop that copies the block to the start of the schedule: with the index `i` in
`rax`, `n + 1` words from `src`, which is the address the code computes for index `i` of the
block at `mp`, to `dst`, which is the one it computes for index `i` of the schedule 96 bytes
below `sp`, whatever the words are. It reveals `copyLeak` of the two addresses and the
number of words. -/
theorem compress_copy_block_trace (mp sp : Word) (wm : Bool) : ∀ (n : Nat)
    (i src dst t2 : Word) (c pf af z sg o : Bool) (t : Trace),
    mp +ₐ i *ₐ 4#64 = src → sp +ₐ i *ₐ 4#64 - 96#64 = dst →
    i + BitVec.ofNat 64 (n + 1) = 16#64 → n + 1 ≤ 16 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x401120#64, .reg rsi mp, .reg rax i, .reg rcx t2, .reg rsp sp,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAny 4 wm src (n + 1)), .prop (cellsAny 4 true dst (n + 1))]) t
      (Atoms.interp [.pc 0x401130#64, .reg rsi mp, .prop (regAny rax),
        .prop (regAny rcx), .reg rsp sp,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 wm src (n + 1)), .prop (cellsAny 4 true dst (n + 1))])
      (t ++ copyLeak 0x401120#64 0x401130#64 src dst n) := by
  intro n
  induction n with
  | zero =>
    intro i src dst t2 c pf af z sg o t hs hd he hn
    subst hs hd
    simp only [copyLeak]
    braid_unfold cellsAny4_cons wm (mp +ₐ i *ₐ 4#64) 0 (0 + 1) rfl
    braid_unfold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 96#64) 0 (0 + 1) rfl
    braid_name_mem (mp + i *ₐ 4#64)
    braid_name_mem (sp + (i *ₐ 4#64 + 0xffffffffffffffa0#64))
    braid_sym_run_to 0x401130
    · exact absurd (by bv_omega) hbr
    · braid_forget_mem (mp + i *ₐ 4#64)
      braid_forget_mem (sp + (i *ₐ 4#64 + 0xffffffffffffffa0#64))
      sha256_fold cellsAny4_cons wm (mp +ₐ i *ₐ 4#64) 0 (0 + 1) rfl
      sha256_fold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 96#64) 0 (0 + 1) rfl
      braid_forget 0
      braid_forget 2
      x86_forget_all_flags
      sha256_leak_done
  | succ n ih =>
    intro i src dst t2 c pf af z sg o t hs hd he hn
    subst hs hd
    simp only [copyLeak]
    braid_unfold cellsAny4_cons wm (mp +ₐ i *ₐ 4#64) (n + 1) (n + 1 + 1) rfl
    braid_unfold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 96#64) (n + 1) (n + 1 + 1) rfl
    braid_name_mem (mp + i *ₐ 4#64)
    braid_name_mem (sp + (i *ₐ 4#64 + 0xffffffffffffffa0#64))
    braid_sym_run_to 0x401130
    · braid_forget_mem (mp + i *ₐ 4#64)
      braid_forget_mem (sp + (i *ₐ 4#64 + 0xffffffffffffffa0#64))
      x86_name_all_flags
      braid_call ih (i + 1#64) (mp +ₐ i *ₐ 4#64 + 4#64) (sp +ₐ i *ₐ 4#64 - 96#64 + 4#64)
        _ _ _ _ _ _ _ _ (by bv_omega) (by bv_omega) (by bv_omega) (by omega)
      sha256_fold cellsAny4_cons wm (mp +ₐ i *ₐ 4#64) (n + 1) (n + 1 + 1) rfl
      sha256_fold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 96#64) (n + 1) (n + 1 + 1) rfl
      sha256_leak_done
    · exact absurd hbr (by bv_omega)

/-- The loop that copies the hash value to the working variables: with the index `i` in
`rax`, `n + 1` words from `src`, which is the address the code computes for index `i` of the
hash value at `hp`, to `dst`, which is the one it computes for index `i` of the working
variables 128 bytes below `sp`, whatever the words are. It reveals `copyLeak` of the two
addresses and the number of words. -/
theorem compress_copy_hash_trace (hp sp : Word) : ∀ (n : Nat)
    (i src dst t2 : Word) (c pf af z sg o : Bool) (t : Trace),
    hp +ₐ i *ₐ 4#64 = src → sp +ₐ i *ₐ 4#64 - 128#64 = dst →
    i + BitVec.ofNat 64 (n + 1) = 8#64 → n + 1 ≤ 8 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x401190#64, .reg rdi hp, .reg rax i, .reg rcx t2, .reg rsp sp,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAny 4 true src (n + 1)), .prop (cellsAny 4 true dst (n + 1))]) t
      (Atoms.interp [.pc 0x4011a0#64, .reg rdi hp, .prop (regAny rax),
        .prop (regAny rcx), .reg rsp sp,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true src (n + 1)), .prop (cellsAny 4 true dst (n + 1))])
      (t ++ copyLeak 0x401190#64 0x4011a0#64 src dst n) := by
  intro n
  induction n with
  | zero =>
    intro i src dst t2 c pf af z sg o t hs hd he hn
    subst hs hd
    simp only [copyLeak]
    braid_unfold cellsAny4_cons true (hp +ₐ i *ₐ 4#64) 0 (0 + 1) rfl
    braid_unfold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 128#64) 0 (0 + 1) rfl
    braid_name_mem (hp + i *ₐ 4#64)
    braid_name_mem (sp + (i *ₐ 4#64 + 0xffffffffffffff80#64))
    braid_sym_run_to 0x4011a0
    · exact absurd (by bv_omega) hbr
    · braid_forget_mem (hp + i *ₐ 4#64)
      braid_forget_mem (sp + (i *ₐ 4#64 + 0xffffffffffffff80#64))
      sha256_fold cellsAny4_cons true (hp +ₐ i *ₐ 4#64) 0 (0 + 1) rfl
      sha256_fold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 128#64) 0 (0 + 1) rfl
      braid_forget 0
      braid_forget 2
      x86_forget_all_flags
      sha256_leak_done
  | succ n ih =>
    intro i src dst t2 c pf af z sg o t hs hd he hn
    subst hs hd
    simp only [copyLeak]
    braid_unfold cellsAny4_cons true (hp +ₐ i *ₐ 4#64) (n + 1) (n + 1 + 1) rfl
    braid_unfold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 128#64) (n + 1) (n + 1 + 1) rfl
    braid_name_mem (hp + i *ₐ 4#64)
    braid_name_mem (sp + (i *ₐ 4#64 + 0xffffffffffffff80#64))
    braid_sym_run_to 0x4011a0
    · braid_forget_mem (hp + i *ₐ 4#64)
      braid_forget_mem (sp + (i *ₐ 4#64 + 0xffffffffffffff80#64))
      x86_name_all_flags
      braid_call ih (i + 1#64) (hp +ₐ i *ₐ 4#64 + 4#64) (sp +ₐ i *ₐ 4#64 - 128#64 + 4#64)
        _ _ _ _ _ _ _ _ (by bv_omega) (by bv_omega) (by bv_omega) (by omega)
      sha256_fold cellsAny4_cons true (hp +ₐ i *ₐ 4#64) (n + 1) (n + 1 + 1) rfl
      sha256_fold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 128#64) (n + 1) (n + 1 + 1) rfl
      sha256_leak_done
    · exact absurd hbr (by bv_omega)

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
      (Atoms.interp [.pc 0x401140#64, .reg rax i, .reg rcx t2, .reg rdx t3,
        .reg rsi t4, .reg r8 t8, .reg rsp sp,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAny 4 true b 16), .prop (cellsAny 4 true (b + 64#64) (n + 1))]) t
      (Atoms.interp [.pc 0x40118b#64, .prop (regAny rax), .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .prop (regAny r8), .reg rsp sp,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true b 16), .prop (cellsAny 4 true (b + 64#64) (n + 1))])
      (t ++ scheduleLoopLeak 0x401140#64 0x40118b#64 (b + 64#64) n) := by
  intro n
  induction n with
  | zero =>
    intro i b t2 t3 t4 t8 c pf af z sg o t hb he hn
    subst hb
    simp only [scheduleLoopLeak, scheduleStepLeak]
    braid_unfold cellsAny16 true (sp +ₐ i *ₐ 4#64 - 160#64)
    braid_unfold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 160#64 + 64#64) 0 (0 + 1) rfl
    schedule_name sp, i
    braid_sym_run_to 0x40118b
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
    braid_sym_run_to 0x40118b
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
  `(tactic| (braid_forget 12; braid_forget 14; braid_forget 15; braid_forget 11
             braid_forget 7; braid_forget 0; braid_forget 2; braid_forget 3; braid_forget 4
             braid_forget 8; braid_forget 9; braid_forget 10
             x86_forget_all_flags))

/-- The loop of rounds in `sha256_compress`, where `sha256_round` is inlined and the working
variables are in registers: `n + 1` rounds, with the offset `o` of the round in `r11`, the
word of the schedule of the first of them at `wa` and its round constant at `ka`, which are
the addresses the code computes from `o` for the schedule 96 bytes below `sp` and the round
constants at `kp`, whatever the working variables, the round constants and the schedule are.
It reveals `roundsLeak` of the two addresses and the number of rounds: a round reads its
word and its constant, and no address or branch of it depends on a working variable. -/
theorem compress_rounds_trace (kp sp : Word) (wk : Bool) : ∀ (n : Nat)
    (o wa ka xa xb xc xd xe xf xg xh y12 y14 y15 : Word) (c pf af z sg ov : Bool) (t : Trace),
    sp +ₐ o *ₐ 1#64 - 96#64 = wa → o +ₐ kp *ₐ 1#64 = ka →
    o + BitVec.ofNat 64 (4 * (n + 1)) = 256#64 → n + 1 ≤ 64 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x4011d0#64, .reg r12 y12, .reg r14 y14, .reg r15 y15,
        .reg r11 o, .reg rbx kp, .reg rsp sp,
        .reg rbp xa, .reg rax xb, .reg rcx xc, .reg rdx xd, .reg rsi xe, .reg r8 xf,
        .reg r9 xg, .reg r10 xh,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of ov,
        .prop (cellsAny 4 true wa (n + 1)), .prop (cellsAny 4 wk ka (n + 1))]) t
      (Atoms.interp [.pc 0x40125e#64, .prop (regAny r12), .prop (regAny r14),
        .prop (regAny r15), .prop (regAny r11), .reg rbx kp, .reg rsp sp,
        .prop (regAny rbp), .prop (regAny rax), .prop (regAny rcx), .prop (regAny rdx),
        .prop (regAny rsi), .prop (regAny r8), .prop (regAny r9), .prop (regAny r10),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true wa (n + 1)), .prop (cellsAny 4 wk ka (n + 1))])
      (t ++ roundsLeak 0x4011d0#64 0x40125e#64 wa ka n) := by
  intro n
  induction n with
  | zero =>
    intro o wa ka xa xb xc xd xe xf xg xh y12 y14 y15 c pf af z sg ov t hw hk he hn
    subst hw hk
    simp only [roundsLeak]
    braid_unfold cellsAny4_cons true (sp +ₐ o *ₐ 1#64 - 96#64) 0 (0 + 1) rfl
    braid_unfold cellsAny4_cons wk (o +ₐ kp *ₐ 1#64) 0 (0 + 1) rfl
    braid_name_mem (sp + (o *ₐ 1#64 + 0xffffffffffffffa0#64))
    braid_name_mem (o + kp *ₐ 1#64)
    braid_sym_run_to 0x40125e
    · exact absurd (by bv_omega) hbr
    · braid_forget_mem (sp + (o *ₐ 1#64 + 0xffffffffffffffa0#64))
      braid_forget_mem (o + kp *ₐ 1#64)
      sha256_fold cellsAny4_cons true (sp +ₐ o *ₐ 1#64 - 96#64) 0 (0 + 1) rfl
      sha256_fold cellsAny4_cons wk (o +ₐ kp *ₐ 1#64) 0 (0 + 1) rfl
      round_forget
      sha256_leak_done
  | succ n ih =>
    intro o wa ka xa xb xc xd xe xf xg xh y12 y14 y15 c pf af z sg ov t hw hk he hn
    subst hw hk
    simp only [roundsLeak]
    braid_unfold cellsAny4_cons true (sp +ₐ o *ₐ 1#64 - 96#64) (n + 1) (n + 1 + 1) rfl
    braid_unfold cellsAny4_cons wk (o +ₐ kp *ₐ 1#64) (n + 1) (n + 1 + 1) rfl
    braid_name_mem (sp + (o *ₐ 1#64 + 0xffffffffffffffa0#64))
    braid_name_mem (o + kp *ₐ 1#64)
    braid_sym_run_to 0x40125e
    · braid_forget_mem (sp + (o *ₐ 1#64 + 0xffffffffffffffa0#64))
      braid_forget_mem (o + kp *ₐ 1#64)
      x86_name_all_flags
      braid_call ih (4#64 + o) (sp +ₐ o *ₐ 1#64 - 96#64 + 4#64) (o +ₐ kp *ₐ 1#64 + 4#64)
        _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by bv_omega) (by bv_omega) (by bv_omega) (by omega)
      sha256_fold cellsAny4_cons true (sp +ₐ o *ₐ 1#64 - 96#64) (n + 1) (n + 1 + 1) rfl
      sha256_fold cellsAny4_cons wk (o +ₐ kp *ₐ 1#64) (n + 1) (n + 1 + 1) rfl
      sha256_leak_done
    · exact absurd hbr (by bv_omega)

/-- The loop that adds the working variables to the hash value: with the index `i` in
`rax`, `n + 1` words at `va`, which is the address the code computes for index `i` of the
working variables 128 bytes below `sp`, added to those at `ha`, which is the one it computes
for index `i` of the hash value at `hp`, whatever the words are. It reveals `addLeak` of the
two addresses and the number of words. -/
theorem compress_add_trace (hp sp : Word) : ∀ (n : Nat) (i va ha t2 : Word)
    (c pf af z sg o : Bool) (t : Trace),
    sp +ₐ i *ₐ 4#64 - 128#64 = va → hp +ₐ i *ₐ 4#64 = ha →
    i + BitVec.ofNat 64 (n + 1) = 8#64 → n + 1 ≤ 8 →
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x401290#64, .reg rdi hp, .reg rax i, .reg rcx t2, .reg rsp sp,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAny 4 true va (n + 1)), .prop (cellsAny 4 true ha (n + 1))]) t
      (Atoms.interp [.pc 0x4012a0#64, .reg rdi hp, .prop (regAny rax), .prop (regAny rcx),
        .reg rsp sp,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true va (n + 1)), .prop (cellsAny 4 true ha (n + 1))])
      (t ++ addLeak 0x401290#64 0x4012a0#64 va ha n) := by
  intro n
  induction n with
  | zero =>
    intro i va ha t2 c pf af z sg o t hv hh he hn
    subst hv hh
    simp only [addLeak]
    braid_unfold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 128#64) 0 (0 + 1) rfl
    braid_unfold cellsAny4_cons true (hp +ₐ i *ₐ 4#64) 0 (0 + 1) rfl
    braid_name_mem (sp + (i *ₐ 4#64 + 0xffffffffffffff80#64))
    braid_name_mem (hp + i *ₐ 4#64)
    braid_sym_run_to 0x4012a0
    · exact absurd (by bv_omega) hbr
    · braid_forget_mem (sp + (i *ₐ 4#64 + 0xffffffffffffff80#64))
      braid_forget_mem (hp + i *ₐ 4#64)
      sha256_fold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 128#64) 0 (0 + 1) rfl
      sha256_fold cellsAny4_cons true (hp +ₐ i *ₐ 4#64) 0 (0 + 1) rfl
      braid_forget 0
      braid_forget 2
      x86_forget_all_flags
      sha256_leak_done
  | succ n ih =>
    intro i va ha t2 c pf af z sg o t hv hh he hn
    subst hv hh
    simp only [addLeak]
    braid_unfold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 128#64) (n + 1) (n + 1 + 1) rfl
    braid_unfold cellsAny4_cons true (hp +ₐ i *ₐ 4#64) (n + 1) (n + 1 + 1) rfl
    braid_name_mem (sp + (i *ₐ 4#64 + 0xffffffffffffff80#64))
    braid_name_mem (hp + i *ₐ 4#64)
    braid_sym_run_to 0x4012a0
    · braid_forget_mem (sp + (i *ₐ 4#64 + 0xffffffffffffff80#64))
      braid_forget_mem (hp + i *ₐ 4#64)
      x86_name_all_flags
      braid_call ih (i + 1#64) (sp +ₐ i *ₐ 4#64 - 128#64 + 4#64) (hp +ₐ i *ₐ 4#64 + 4#64)
        _ _ _ _ _ _ _ _ (by bv_omega) (by bv_omega) (by bv_omega) (by omega)
      sha256_fold cellsAny4_cons true (sp +ₐ i *ₐ 4#64 - 128#64) (n + 1) (n + 1 + 1) rfl
      sha256_fold cellsAny4_cons true (hp +ₐ i *ₐ 4#64) (n + 1) (n + 1 + 1) rfl
      sha256_leak_done
    · exact absurd hbr (by bv_omega)

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
theorem sha256_compress_trace (hp mp s r vb vp v12 v14 v15 : Word) (H M : List W32)
    (wm wk : Bool) (fvs fws sv : List Word) (t0 t2 t3 t8 t9 t10 t11 : Word)
    (c pf af z sg o : Bool) (hH : H.length = 8) (hM : M.length = 16) (hfv : fvs.length = 8)
    (hfw : fws.length = 64) (hsv : sv.length = 5) (t : Trace) :
    TripleT sha256_compress.program
      (Atoms.interp [.pc 0x401100#64, .reg rdi hp, .reg rsi mp, .reg rax t0, .reg rcx t2,
        .reg rdx t3, .reg r8 t8, .reg r9 t9, .reg r10 t10, .reg r11 t11, .reg rbx vb,
        .reg rbp vp, .reg r12 v12, .reg r14 v14, .reg r15 v15, .reg rsp s,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o,
        .prop (cellsAt 4 true hp (w32s H)), .prop (cellsAt 4 wm mp (w32s M)),
        .prop (cellsAt 4 wk 0x4022b0#64 (w32s K)),
        .prop (cellsAt 4 true (s - 328#64) fvs), .prop (cellsAt 4 true (s - 296#64) fws),
        .prop (cellsAt 8 true (s - 40#64) sv), .prop (cellsAt 8 true s [r])]) t
      (Atoms.interp [.pc r, .reg rdi hp, .prop (regAny rsi), .prop (regAny rax),
        .prop (regAny rcx), .prop (regAny rdx), .prop (regAny r8), .prop (regAny r9),
        .prop (regAny r10), .prop (regAny r11), .reg rbx vb, .reg rbp vp, .reg r12 v12,
        .reg r14 v14, .reg r15 v15, .reg rsp (s + 8#64),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (cellsAny 4 true hp 8), .prop (cellsAny 4 wm mp 16),
        .prop (cellsAny 4 wk 0x4022b0#64 64),
        .prop (cellsAny 4 true (s - 328#64) 8), .prop (cellsAny 4 true (s - 296#64) 64),
        .prop (cellsAt 8 true (s - 40#64) [vb, v12, v14, v15, vp]),
        .prop (cellsAt 8 true s [r])])
      (t ++ compressLeak hp mp s r) := by
  obtain ⟨s0, s1, s2, s3, s4, rfl⟩ : ∃ s0 s1 s2 s3 s4, sv = [s0, s1, s2, s3, s4] := by
    match sv, hsv with
    | [s0, s1, s2, s3, s4], _ => exact ⟨s0, s1, s2, s3, s4, rfl⟩
  simp only [compressLeak]
  -- Nothing the code reveals depends on what the arrays hold.
  braid_forget_cells hp, 8, (by simp [hH])
  braid_forget_cells mp, 16, (by simp [hM])
  braid_forget_cells 0x4022b0#64, 64, (by rw [w32s_length]; rfl)
  braid_forget_cells (s - 328#64), 8, hfv
  braid_forget_cells (s - 296#64), 64, hfw
  -- Every base address as a sum, so that every address the code computes is a folded sum.
  obtain ⟨hq, rfl⟩ : ∃ hq : BitVec 64, hp = hq + 1#64 := ⟨hp - 1#64, by bv_omega⟩
  obtain ⟨mq, rfl⟩ : ∃ mq : BitVec 64, mp = mq + 1#64 := ⟨mp - 1#64, by bv_omega⟩
  obtain ⟨sq, rfl⟩ : ∃ sq : BitVec 64, s = sq + 329#64 := ⟨s - 329#64, by bv_omega⟩
  braid_unfold cellsAny_pre16 true (sq + 33#64) 48 64 rfl
  sha256_fold cellsAny16 true (sq + 33#64)
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 289#64) s0 [s1, s2, s3, s4]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 297#64) s1 [s2, s3, s4]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 305#64) s2 [s3, s4]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 313#64) s3 [s4]
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 321#64) s4 []
  braid_unfold cellsAt_cons (k := 8) (w := true) (sq + 329#64) r []
  -- The registers saved, and the block copied to the start of the schedule.
  braid_sym_run_to 0x401111
  refine tripleT_reg_val (r := 0) 0#64 (by braid_upd) (by bv_decide) ?_
  braid_sym_run_to 0x401120
  x86_name_all_flags
  braid_call compress_copy_block_trace (mq + 1#64) (sq + 129#64) wm 15 0#64 (mq + 1#64)
    (sq + 33#64) _ _ _ _ _ _ _ _ (by bv_omega) (by bv_omega) (by decide) (by omega)
  braid_name_reg 0
  braid_name_reg 2
  -- The message schedule.
  braid_sym_run_to 0x401140
  x86_name_all_flags
  braid_call compress_schedule_trace (sq + 129#64) 47 16#64 (sq + 33#64) _ _ _ _ _ _ _ _ _ _
    _ (by bv_omega) (by decide) (by omega)
  braid_name_reg 0
  braid_name_reg 2
  braid_name_reg 3
  braid_name_reg 4
  braid_name_reg 8
  -- The hash value copied to the working variables, and those loaded into registers.
  braid_sym_run_to 0x40118d
  refine tripleT_reg_val (r := 0) 0#64 (by braid_upd) (by bv_decide) ?_
  braid_sym_run_to 0x401190
  x86_name_all_flags
  braid_call compress_copy_hash_trace (hq + 1#64) (sq + 129#64) 7 0#64 (hq + 1#64)
    (sq + 1#64) _ _ _ _ _ _ _ _ (by bv_omega) (by bv_omega) (by decide) (by omega)
  braid_name_reg 0
  braid_name_reg 2
  braid_unfold cellsAny8 true (sq + 1#64)
  vars_name sq
  braid_sym_run_to 0x4011c6
  refine tripleT_reg_val (r := 11) 0#64 (by braid_upd) (by bv_decide) ?_
  braid_sym_run_to 0x4011d0
  vars_forget sq
  sha256_fold cellsAny8 true (sq + 1#64)
  braid_unfold cellsAny16 true (sq + 33#64)
  sha256_fold cellsAny_pre16 true (sq + 33#64) 48 64 rfl
  x86_name_all_flags
  -- The rounds.
  braid_call compress_rounds_trace 0x4022b0#64 (sq + 129#64) wk 63 0#64 (sq + 33#64)
    0x4022b0#64 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (by bv_omega) (by decide) (by decide)
    (by omega)
  braid_name_reg 12
  braid_name_reg 14
  braid_name_reg 15
  braid_name_reg 7
  braid_name_reg 0
  braid_name_reg 2
  braid_name_reg 3
  braid_name_reg 4
  braid_name_reg 8
  braid_name_reg 9
  braid_name_reg 10
  -- The working variables stored, and added to the hash value; the registers restored.
  braid_unfold cellsAny8 true (sq + 1#64)
  vars_name sq
  braid_sym_run_to 0x401283
  refine tripleT_reg_val (r := 0) 0#64 (by braid_upd) (by bv_decide) ?_
  braid_sym_run_to 0x401290
  vars_forget sq
  sha256_fold cellsAny8 true (sq + 1#64)
  x86_name_all_flags
  braid_call compress_add_trace (hq + 1#64) (sq + 129#64) 7 0#64 (sq + 1#64) (hq + 1#64)
    _ _ _ _ _ _ _ _ (by bv_omega) (by bv_omega) (by decide) (by omega)
  braid_sym_run_to 0x4012a7
  refine tripleT_reg_val (r := 6) (sq + 289#64) (by braid_upd) (by bv_omega) ?_
  braid_sym_run
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 321#64) vp []
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 313#64) v15 [vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 305#64) v14 [v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 297#64) v12 [v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 289#64) vb [v12, v14, v15, vp]
  sha256_fold cellsAt_cons (k := 8) (w := true) (sq + 329#64) r []
  braid_forget 4
  braid_forget 3
  braid_forget 8
  braid_forget 9
  braid_forget 10
  x86_forget_all_flags
  sha256_leak_done

end Examples.Sha256.X86
