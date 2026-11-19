/-
  Examples.ChaCha20.O2.X86.Block

  `chacha20_block` of `chacha20.c` on x86-64, compiled at `-O2`: the ChaCha20 block function,
  from sixteen 32-bit words in memory to sixteen 32-bit words in memory.

  The code pushes six registers, and uses 28 bytes below them without moving the stack
  pointer (the red zone): its two arguments, the count of rounds, a word of the state and a
  spill slot. At `-O1` it kept a copy of the state there as well, and the frame was 148
  bytes; here it is 76, and there is no loop but that of the rounds. The code loads the
  sixteen words of the input into fifteen registers and a slot, runs the loop of ten double
  rounds, and adds the input to each word from memory, into the output. The loop of rounds is
  `rounds_spec`, proved by induction in `Examples.ChaCha20.O2.X86.Round`, and is used here as
  a call.

  The proof is in three parts, each a theorem of its own, as at `-O1`: the entry as far as
  the loop of rounds, the exit from it, and the whole, which calls the two and `rounds_spec`.
  The lemmas about cells of the machine are those of `Examples.ChaCha20.X86.QuarterRound`.

  ## Main results

  * `entry_spec`, `exit_spec`: the code before the loop of rounds, and after it
  * `chacha20_block_spec`: the specification, against `ChaCha20.block`
  * `chacha20_block_correct`: the same, about the machine alone
-/

module

public import Examples.ChaCha20.O2.X86.Round
public import Examples.ChaCha20.O2.X86.QuarterRound

public section

namespace Examples.ChaCha20.O2.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs
open Examples.ChaCha20.X86 (hasBytes_of_cells)

/-! ## The frame -/

/-- Addition as `BitVec.add_assoc` leaves it: all three types `BitVec 64`. The stepper finds
memory atoms by syntactic equality of addresses, and an address it has folded two offsets
into is written this way. -/
local notation:65 a:65 " +ᵇ " b:66 =>
  @HAdd.hAdd (BitVec 64) (BitVec 64) (BitVec 64) instHAdd a b

/-- Addition as `sub_lit` leaves it, for the stack pointer less a literal. -/
local notation:65 a:65 " +ᵐ " b:66 => @HAdd.hAdd Word (BitVec 64) Word instHAdd a b

/-- The three 32-bit cells of the frame, as memory atoms at the addresses the stepper
computes: a spill slot, a word of the state, and the count of rounds. -/
theorem frame_cells (sp₀ f0 f1 f2 : Word) :
    (Atom.prop (cellsAt 4 true (sp₀ - 76#64) [f0, f1, f2])).interp =
      Atoms.interp [.mem (sp₀ +ᵇ 18446744073709551540#64) 4 f0 true,
        .mem (sp₀ +ᵇ 18446744073709551544#64) 4 f1 true,
        .mem (sp₀ +ᵇ 18446744073709551548#64) 4 f2 true] := by
  simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil, cellsAt, sub_lit,
    BitVec.reduceNeg, BitVec.add_assoc, BitVec.reduceAdd]

/-- The eight 64-bit cells of the frame, as memory atoms: the two arguments, and the six
registers pushed. -/
theorem saved_cells (sp₀ m0 m1 m2 m3 m4 m5 m6 m7 : Word) :
    (Atom.prop (cellsAt 8 true (sp₀ - 64#64) [m0, m1, m2, m3, m4, m5, m6, m7])).interp =
      Atoms.interp [.mem (sp₀ +ᵇ 18446744073709551552#64) 8 m0 true,
        .mem (sp₀ +ᵇ 18446744073709551560#64) 8 m1 true,
        .mem (sp₀ +ᵇ 18446744073709551568#64) 8 m2 true,
        .mem (sp₀ +ᵇ 18446744073709551576#64) 8 m3 true,
        .mem (sp₀ +ᵇ 18446744073709551584#64) 8 m4 true,
        .mem (sp₀ +ᵇ 18446744073709551592#64) 8 m5 true,
        .mem (sp₀ +ᵇ 18446744073709551600#64) 8 m6 true,
        .mem (sp₀ +ᵐ 18446744073709551608#64) 8 m7 true] := by
  simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil, cellsAt, sub_lit,
    BitVec.reduceNeg, BitVec.add_assoc, BitVec.reduceAdd]

/-! ## The code -/

/-- Forget the values of the status flags that have one. -/
local macro "forget_flags" : tactic =>
  `(tactic| (try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 3
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-- **The entry of `chacha20_block`**, as far as the loop of rounds: it pushes six registers,
saves its two arguments, loads the sixteen words into fifteen registers and a slot, and
sets the count of rounds, which is in a slot, to ten. -/
theorem entry_spec (out inp sp₀ : Word)
    (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : W32)
    (f0 f1 f2 : Word)
    (m0 m1 m2 m3 m4 m5 m6 m7 t0 v1 t2 t3 v7 t8 t9 t10 t11 v12 v13 v14 v15 : Word)
    (fc fp fa fz fs fo : Bool) :
    Triple chacha20_block.program
      (Atoms.interp [.prop (cellsAt 4 true inp
          [a0.zeroExtend 64, a1.zeroExtend 64, a2.zeroExtend 64, a3.zeroExtend 64,
           a4.zeroExtend 64, a5.zeroExtend 64, a6.zeroExtend 64, a7.zeroExtend 64,
           a8.zeroExtend 64, a9.zeroExtend 64, a10.zeroExtend 64, a11.zeroExtend 64,
           a12.zeroExtend 64, a13.zeroExtend 64, a14.zeroExtend 64, a15.zeroExtend 64]),
        .prop (cellsAt 4 true (sp₀ - 76#64) [f0, f1, f2]),
        .prop (cellsAt 8 true (sp₀ - 64#64) [m0, m1, m2, m3, m4, m5, m6, m7]),
        .pc 0x401040#64, .reg rax t0, .reg rbx v1, .reg rcx t2, .reg rdx t3, .reg rsi inp,
        .reg rdi out, .reg rsp sp₀, .reg rbp v7, .reg r8 t8, .reg r9 t9, .reg r10 t10,
        .reg r11 t11, .reg r12 v12, .reg r13 v13, .reg r14 v14, .reg r15 v15,
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo])
      (Atoms.interp [.prop (cellsAt 4 true inp
          [a0.zeroExtend 64, a1.zeroExtend 64, a2.zeroExtend 64, a3.zeroExtend 64,
           a4.zeroExtend 64, a5.zeroExtend 64, a6.zeroExtend 64, a7.zeroExtend 64,
           a8.zeroExtend 64, a9.zeroExtend 64, a10.zeroExtend 64, a11.zeroExtend 64,
           a12.zeroExtend 64, a13.zeroExtend 64, a14.zeroExtend 64, a15.zeroExtend 64]),
        .prop (cellsAt 4 true (sp₀ - 76#64)
          [a11.zeroExtend 64, a10.zeroExtend 64, (10#32).zeroExtend 64]),
        .prop (cellsAt 8 true (sp₀ - 64#64) [inp, out, v1, v12, v13, v14, v15, v7]),
        .pc 0x4010a0#64, .reg rsp (sp₀ +ᵇ 18446744073709551568#64),
        .reg r10 (a0.zeroExtend 64), .reg rdi (a1.zeroExtend 64), .reg r9 (a2.zeroExtend 64),
        .reg r13 (a3.zeroExtend 64), .reg r12 (a4.zeroExtend 64), .reg r15 (a5.zeroExtend 64),
        .reg r14 (a6.zeroExtend 64), .reg rbp (a7.zeroExtend 64), .reg rbx (a8.zeroExtend 64),
        .reg r11 (a9.zeroExtend 64), .reg rsi (a11.zeroExtend 64), .reg r8 (a12.zeroExtend 64),
        .reg rdx (a13.zeroExtend 64), .reg rcx (a14.zeroExtend 64),
        .reg rax (a15.zeroExtend 64), .prop (flagAny Flags.cf), .prop (flagAny Flags.pf),
        .prop (flagAny Flags.af), .prop (flagAny Flags.zf), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) := by
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold frame_cells sp₀ _ _ _
  braid_unfold saved_cells sp₀ _ _ _ _ _ _ _ _
  -- The pushes, the loads and the count of rounds.
  iterate 29 braid_sym_step
  forget_flags
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold frame_cells sp₀ _ _ _
  braid_fold saved_cells sp₀ _ _ _ _ _ _ _ _
  braid_done_perm 26

/-- **The exit of `chacha20_block`**, from the end of the loop of rounds: it adds the input
to each of the sixteen words, from memory, stores the sum to the output, pops the six
registers and returns. -/
theorem exit_spec (out inp r sp₀ : Word)
    (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : W32)
    (b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 : W32)
    (o0 o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 o11 o12 o13 o14 o15 : Word)
    (g0 g2 v1 v7 v12 v13 v14 v15 : Word) :
    Triple chacha20_block.program
      (Atoms.interp [.prop (cellsAt 4 true inp
          [a0.zeroExtend 64, a1.zeroExtend 64, a2.zeroExtend 64, a3.zeroExtend 64,
           a4.zeroExtend 64, a5.zeroExtend 64, a6.zeroExtend 64, a7.zeroExtend 64,
           a8.zeroExtend 64, a9.zeroExtend 64, a10.zeroExtend 64, a11.zeroExtend 64,
           a12.zeroExtend 64, a13.zeroExtend 64, a14.zeroExtend 64, a15.zeroExtend 64]),
        .prop (cellsAt 4 true out
          [o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13, o14, o15]),
        .prop (cellsAt 4 true (sp₀ - 76#64) [g0, b10.zeroExtend 64, g2]),
        .prop (cellsAt 8 true (sp₀ - 64#64) [inp, out, v1, v12, v13, v14, v15, v7]),
        .mem sp₀ 8 r true, .pc 0x4011e4#64, .reg rsp (sp₀ +ᵇ 18446744073709551568#64),
        .reg r10 (b0.zeroExtend 64), .reg rdi (b1.zeroExtend 64), .reg r9 (b2.zeroExtend 64),
        .reg r13 (b3.zeroExtend 64), .reg r12 (b4.zeroExtend 64), .reg r15 (b5.zeroExtend 64),
        .reg r14 (b6.zeroExtend 64), .reg rbp (b7.zeroExtend 64), .reg rbx (b8.zeroExtend 64),
        .reg r11 (b9.zeroExtend 64), .reg rsi (b11.zeroExtend 64), .reg r8 (b12.zeroExtend 64),
        .reg rdx (b13.zeroExtend 64), .reg rcx (b14.zeroExtend 64),
        .reg rax (b15.zeroExtend 64), .prop (flagAny Flags.cf), .prop (flagAny Flags.pf),
        .prop (flagAny Flags.af), .prop (flagAny Flags.zf), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)])
      (Atoms.interp [.prop (cellsAt 4 true inp
          [a0.zeroExtend 64, a1.zeroExtend 64, a2.zeroExtend 64, a3.zeroExtend 64,
           a4.zeroExtend 64, a5.zeroExtend 64, a6.zeroExtend 64, a7.zeroExtend 64,
           a8.zeroExtend 64, a9.zeroExtend 64, a10.zeroExtend 64, a11.zeroExtend 64,
           a12.zeroExtend 64, a13.zeroExtend 64, a14.zeroExtend 64, a15.zeroExtend 64]),
        .prop (cellsAt 4 true out
          [(b0 + a0).zeroExtend 64, (b1 + a1).zeroExtend 64, (b2 + a2).zeroExtend 64,
           (b3 + a3).zeroExtend 64, (b4 + a4).zeroExtend 64, (b5 + a5).zeroExtend 64,
           (b6 + a6).zeroExtend 64, (b7 + a7).zeroExtend 64, (b8 + a8).zeroExtend 64,
           (b9 + a9).zeroExtend 64, (b10 + a10).zeroExtend 64, (b11 + a11).zeroExtend 64,
           (b12 + a12).zeroExtend 64, (b13 + a13).zeroExtend 64, (b14 + a14).zeroExtend 64,
           (b15 + a15).zeroExtend 64]),
        .prop (cellsAny 4 (sp₀ - 76#64) 3),
        .prop (cellsAt 8 true (sp₀ - 64#64) [inp, out, v1, v12, v13, v14, v15, v7]),
        .mem sp₀ 8 r true, .pc r, .reg rsp (sp₀ + 8#64), .reg rbx v1, .reg rbp v7,
        .reg r12 v12, .reg r13 v13, .reg r14 v14, .reg r15 v15, .prop (regAny rax),
        .prop (regAny rcx), .prop (regAny rdx), .prop (regAny rsi), .prop (regAny rdi),
        .prop (regAny r8), .prop (regAny r9), .prop (regAny r10), .prop (regAny r11),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold frame_cells sp₀ _ _ _
  braid_unfold saved_cells sp₀ _ _ _ _ _ _ _ _
  -- The sum with the input, the pops and the return.
  braid_sym_run
  simp only [zadd]
  -- An `add` from memory has the word of the input on the left.
  rw [BitVec.add_comm a0 b0, BitVec.add_comm a1 b1, BitVec.add_comm a2 b2,
    BitVec.add_comm a3 b3, BitVec.add_comm a4 b4, BitVec.add_comm a5 b5,
    BitVec.add_comm a6 b6, BitVec.add_comm a7 b7, BitVec.add_comm a8 b8,
    BitVec.add_comm a9 b9, BitVec.add_comm a10 b10, BitVec.add_comm a11 b11,
    BitVec.add_comm a12 b12, BitVec.add_comm a13 b13, BitVec.add_comm a14 b14,
    BitVec.add_comm a15 b15]
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold frame_cells sp₀ _ _ _
  braid_fold saved_cells sp₀ _ _ _ _ _ _ _ _
  apply Triple.forget_cells (k := 4) (p := sp₀ + 18446744073709551540#64) (n := 3)
  case hupd => braid_upd
  case hn => rfl
  braid_forget 0
  braid_forget 2
  braid_forget 3
  braid_forget 4
  braid_forget 5
  braid_forget 8
  braid_forget 9
  braid_forget 10
  braid_forget 11
  forget_flags
  braid_done_perm 28

/-- **`chacha20_block`** writes the ChaCha20 block function of the sixteen 32-bit words its
second argument points to over the sixteen its first argument points to, and returns through
the address on the stack. It uses 76 bytes below the stack pointer: 12 for a spill slot, a
word of the state and the count of rounds, which it leaves with some values, and 64 for its
two arguments and the registers `rbx`, `r12` to `r15` and `rbp`, which it restores. -/
theorem chacha20_block_spec (out inp r sp₀ : Word) (s : List W32) (os fr sv : List Word)
    (t0 v1 t2 t3 v7 t8 t9 t10 t11 v12 v13 v14 v15 : Word) (fc fp fa fz fs fo : Bool)
    (hs : s.length = 16) (hos : os.length = 16) (hfr : fr.length = 3) (hsv : sv.length = 8) :
    Triple chacha20_block.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) :: .prop (cellsAt 4 true (sp₀ - 76#64) fr) ::
        .prop (cellsAt 8 true (sp₀ - 64#64) sv) ::
        [.mem sp₀ 8 r true, .pc 0x401040#64, .reg rax t0, .reg rbx v1, .reg rcx t2,
        .reg rdx t3, .reg rsi inp, .reg rdi out, .reg rsp sp₀, .reg rbp v7, .reg r8 t8,
        .reg r9 t9, .reg r10 t10, .reg r11 t11, .reg r12 v12, .reg r13 v13, .reg r14 v14,
        .reg r15 v15, .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa,
        .flag Flags.zf fz, .flag Flags.sf fs, .flag Flags.of fo]))
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out ((block s).map (·.zeroExtend 64))) ::
        .prop (cellsAny 4 (sp₀ - 76#64) 3) ::
        .prop (cellsAt 8 true (sp₀ - 64#64) [inp, out, v1, v12, v13, v14, v15, v7]) ::
        [.mem sp₀ 8 r true, .pc r, .prop (regAny rax), .reg rbx v1, .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .prop (regAny rdi), .reg rsp (sp₀ + 8#64),
        .reg rbp v7, .prop (regAny r8), .prop (regAny r9), .prop (regAny r10),
        .prop (regAny r11), .reg r12 v12, .reg r13 v13, .reg r14 v14, .reg r15 v15,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])) := by
  obtain ⟨a0, s0, rfl, hs0⟩ := exists_cons_of_length hs
  obtain ⟨a1, s1, rfl, hs1⟩ := exists_cons_of_length hs0
  obtain ⟨a2, s2, rfl, hs2⟩ := exists_cons_of_length hs1
  obtain ⟨a3, s3, rfl, hs3⟩ := exists_cons_of_length hs2
  obtain ⟨a4, s4, rfl, hs4⟩ := exists_cons_of_length hs3
  obtain ⟨a5, s5, rfl, hs5⟩ := exists_cons_of_length hs4
  obtain ⟨a6, s6, rfl, hs6⟩ := exists_cons_of_length hs5
  obtain ⟨a7, s7, rfl, hs7⟩ := exists_cons_of_length hs6
  obtain ⟨a8, s8, rfl, hs8⟩ := exists_cons_of_length hs7
  obtain ⟨a9, s9, rfl, hs9⟩ := exists_cons_of_length hs8
  obtain ⟨a10, s10, rfl, hs10⟩ := exists_cons_of_length hs9
  obtain ⟨a11, s11, rfl, hs11⟩ := exists_cons_of_length hs10
  obtain ⟨a12, s12, rfl, hs12⟩ := exists_cons_of_length hs11
  obtain ⟨a13, s13, rfl, hs13⟩ := exists_cons_of_length hs12
  obtain ⟨a14, s14, rfl, hs14⟩ := exists_cons_of_length hs13
  obtain ⟨a15, s15, rfl, hs15⟩ := exists_cons_of_length hs14
  obtain rfl := List.length_eq_zero_iff.1 hs15
  obtain ⟨o0, os0, rfl, hos0⟩ := exists_cons_of_length hos
  obtain ⟨o1, os1, rfl, hos1⟩ := exists_cons_of_length hos0
  obtain ⟨o2, os2, rfl, hos2⟩ := exists_cons_of_length hos1
  obtain ⟨o3, os3, rfl, hos3⟩ := exists_cons_of_length hos2
  obtain ⟨o4, os4, rfl, hos4⟩ := exists_cons_of_length hos3
  obtain ⟨o5, os5, rfl, hos5⟩ := exists_cons_of_length hos4
  obtain ⟨o6, os6, rfl, hos6⟩ := exists_cons_of_length hos5
  obtain ⟨o7, os7, rfl, hos7⟩ := exists_cons_of_length hos6
  obtain ⟨o8, os8, rfl, hos8⟩ := exists_cons_of_length hos7
  obtain ⟨o9, os9, rfl, hos9⟩ := exists_cons_of_length hos8
  obtain ⟨o10, os10, rfl, hos10⟩ := exists_cons_of_length hos9
  obtain ⟨o11, os11, rfl, hos11⟩ := exists_cons_of_length hos10
  obtain ⟨o12, os12, rfl, hos12⟩ := exists_cons_of_length hos11
  obtain ⟨o13, os13, rfl, hos13⟩ := exists_cons_of_length hos12
  obtain ⟨o14, os14, rfl, hos14⟩ := exists_cons_of_length hos13
  obtain ⟨o15, os15, rfl, hos15⟩ := exists_cons_of_length hos14
  obtain rfl := List.length_eq_zero_iff.1 hos15
  obtain ⟨f0, fr0, rfl, hfr0⟩ := exists_cons_of_length hfr
  obtain ⟨f1, fr1, rfl, hfr1⟩ := exists_cons_of_length hfr0
  obtain ⟨f2, fr2, rfl, hfr2⟩ := exists_cons_of_length hfr1
  obtain rfl := List.length_eq_zero_iff.1 hfr2
  obtain ⟨m0, sv0, rfl, hsv0⟩ := exists_cons_of_length hsv
  obtain ⟨m1, sv1, rfl, hsv1⟩ := exists_cons_of_length hsv0
  obtain ⟨m2, sv2, rfl, hsv2⟩ := exists_cons_of_length hsv1
  obtain ⟨m3, sv3, rfl, hsv3⟩ := exists_cons_of_length hsv2
  obtain ⟨m4, sv4, rfl, hsv4⟩ := exists_cons_of_length hsv3
  obtain ⟨m5, sv5, rfl, hsv5⟩ := exists_cons_of_length hsv4
  obtain ⟨m6, sv6, rfl, hsv6⟩ := exists_cons_of_length hsv5
  obtain ⟨m7, sv7, rfl, hsv7⟩ := exists_cons_of_length hsv6
  obtain rfl := List.length_eq_zero_iff.1 hsv7
  rw [block16 _ rfl]
  simp only [List.map_cons, List.map_nil, List.getD_cons_zero, List.getD_cons_succ]
  braid_call entry_spec out inp sp₀ a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15
    f0 f1 f2
    m0 m1 m2 m3 m4 m5 m6 m7 t0 v1 t2 t3 v7 t8 t9 t10 t11 v12 v13 v14 v15 fc fp fa fz fs fo
  -- The ten double rounds, on the slots of the frame.
  braid_unfold frame_cells sp₀ _ _ _
  have h := rounds_spec 9 [a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15]
    10#32 (sp₀ +ᵇ 18446744073709551568#64) (a11.zeroExtend 64) rfl rfl (by decide)
  simp only [List.getD_cons_zero, List.getD_cons_succ, Nat.reduceAdd] at h
  braid_call h
  clear h
  braid_fold frame_cells sp₀ _ _ _
  generalize innerN 10 [a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15] = x
  braid_call exit_spec out inp r sp₀ a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15
    (x.getD 0 0) (x.getD 1 0) (x.getD 2 0) (x.getD 3 0) (x.getD 4 0) (x.getD 5 0) (x.getD 6 0)
    (x.getD 7 0) (x.getD 8 0) (x.getD 9 0) (x.getD 10 0) (x.getD 11 0) (x.getD 12 0) (x.getD 13 0)
    (x.getD 14 0) (x.getD 15 0)
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ v1 v7 v12 v13 v14 v15
  braid_done_perm 28

/-! ## On the machine -/

/-- A region of 64 bytes that ends at or before the start of the frame and starts 84 bytes or
more beyond it, going round the address space, is apart from the 64 bytes of saved
registers, and from the return address. At `-O1` the second condition was enough, the frame
below the saved registers being longer than the region. The addresses are variables here:
`bv_omega` does not see through the type of a register of the machine model. -/
theorem apart_frame {p sp₀ : Word} (h₁ : 64 ≤ (sp₀ - 76#64 - p).toNat)
    (h : 84 ≤ (p - (sp₀ - 76#64)).toNat) :
    (64 ≤ (sp₀ - 64#64 - p).toNat ∧ 64 ≤ (p - (sp₀ - 64#64)).toNat) ∧
      64 ≤ (sp₀ - p).toNat ∧ 8 ≤ (p - sp₀).toNat := by
  refine ⟨⟨?_, ?_⟩, ?_, ?_⟩ <;> bv_omega

/-- The three parts of the frame are apart from one another. -/
theorem frame_apart (sp₀ : Word) :
    (12 ≤ (sp₀ - 64#64 - (sp₀ - 76#64)).toNat ∧ 64 ≤ (sp₀ - 76#64 - (sp₀ - 64#64)).toNat) ∧
      (12 ≤ (sp₀ - (sp₀ - 76#64)).toNat ∧ 8 ≤ (sp₀ - 76#64 - sp₀).toNat) ∧
      64 ≤ (sp₀ - (sp₀ - 64#64)).toNat ∧ 8 ≤ (sp₀ - 64#64 - sp₀).toNat := by
  refine ⟨⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_, ?_⟩ <;> bv_omega

/-- `chacha20_block_correct`, with names for what `rdi`, `rsi` and `rsp` hold. -/
theorem chacha20_block_correct_aux [Layout] (m : MachineState) (s : List W32)
    (os fr sv : List Word) (r out inp sp₀ : Word) (hpc : m.pc = 0x401040)
    (hout : m.data.regs.get64 .rdi = out) (hinp : m.data.regs.get64 .rsi = inp)
    (hsp : m.data.regs.get64 .rsp = sp₀) (hs : s.length = 16) (hos : os.length = 16)
    (hfr : fr.length = 3) (hsv : sv.length = 8)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes m (inp + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hdst : ∀ (i : Nat) (hi : i < os.length),
      HasBytes m (out + BitVec.ofNat 64 (4 * i)) 4 os[i])
    (hframe : ∀ (i : Nat) (hi : i < fr.length),
      HasBytes m (sp₀ - 76#64 + BitVec.ofNat 64 (4 * i)) 4 fr[i])
    (hsaved : ∀ (i : Nat) (hi : i < sv.length),
      HasBytes m (sp₀ - 64#64 + BitVec.ofNat 64 (8 * i)) 8 sv[i])
    (hret : HasBytes m sp₀ 8 r)
    (hio : 64 ≤ (out - inp).toNat ∧ 64 ≤ (inp - out).toNat)
    (his : 64 ≤ (sp₀ - 76#64 - inp).toNat ∧ 84 ≤ (inp - (sp₀ - 76#64)).toNat)
    (hos' : 64 ≤ (sp₀ - 76#64 - out).toNat ∧ 84 ≤ (out - (sp₀ - 76#64)).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        (∀ (i : Nat) (hi : i < (block s).length),
          HasBytes m' (out + BitVec.ofNat 64 (4 * i)) 4 ((block s)[i].zeroExtend 64)) ∧
        (∀ (i : Nat) (hi : i < s.length),
          HasBytes m' (inp + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64)) ∧
        m'.data.regs.get64 .rsp = sp₀ + 8#64 ∧
        m'.data.regs.get64 .rbx = m.data.regs.get64 .rbx ∧
        m'.data.regs.get64 .rbp = m.data.regs.get64 .rbp ∧
        m'.data.regs.get64 .r12 = m.data.regs.get64 .r12 ∧
        m'.data.regs.get64 .r13 = m.data.regs.get64 .r13 ∧
        m'.data.regs.get64 .r14 = m.data.regs.get64 .r14 ∧
        m'.data.regs.get64 .r15 = m.data.regs.get64 .r15) m := by
  obtain ⟨⟨hi8₁, hi8₂⟩, hir₁, hir₂⟩ := apart_frame his.1 his.2
  obtain ⟨⟨ho8₁, ho8₂⟩, hor₁, hor₂⟩ := apart_frame hos'.1 hos'.2
  obtain ⟨⟨hf₁, hf₂⟩, ⟨hfr₁, hfr₂⟩, hsr₁, hsr₂⟩ := frame_apart sp₀
  have hrest : ∀ b ∈ ([.pc 0x401040#64, .reg rax (m.data.regs.get64 .rax),
      .reg rbx (m.data.regs.get64 .rbx), .reg rcx (m.data.regs.get64 .rcx),
      .reg rdx (m.data.regs.get64 .rdx), .reg rsi inp, .reg rdi out, .reg rsp sp₀,
      .reg rbp (m.data.regs.get64 .rbp), .reg r8 (m.data.regs.get64 .r8),
      .reg r9 (m.data.regs.get64 .r9), .reg r10 (m.data.regs.get64 .r10),
      .reg r11 (m.data.regs.get64 .r11), .reg r12 (m.data.regs.get64 .r12),
      .reg r13 (m.data.regs.get64 .r13), .reg r14 (m.data.regs.get64 .r14),
      .reg r15 (m.data.regs.get64 .r15), .flag Flags.cf m.data.status.cf,
      .flag Flags.pf m.data.status.pf, .flag Flags.af m.data.status.af,
      .flag Flags.zf m.data.status.zf, .flag Flags.sf m.data.status.sf,
      .flag Flags.of m.data.status.of] : Atoms), ∀ q n v w', Atom.Disj b (.mem q n v w') := by
    braid_not_mem
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat chacha20_block_holds
    (chacha20_block_spec out inp r sp₀ s os fr sv (m.data.regs.get64 .rax)
      (m.data.regs.get64 .rbx) (m.data.regs.get64 .rcx) (m.data.regs.get64 .rdx)
      (m.data.regs.get64 .rbp) (m.data.regs.get64 .r8) (m.data.regs.get64 .r9)
      (m.data.regs.get64 .r10) (m.data.regs.get64 .r11) (m.data.regs.get64 .r12)
      (m.data.regs.get64 .r13) (m.data.regs.get64 .r14) (m.data.regs.get64 .r15)
      m.data.status.cf m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf
      m.data.status.of hs hos hfr hsv)
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2
      ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
        List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp [Atom.IsPointsTo]⟩⟩⟩⟩)
    (pairwise_cells_append (by simp [hs])
      (pairwise_cells_append (by simp [hos])
        (pairwise_cells_append (by simp [hfr])
          (pairwise_cells_append (by simp [hsv])
            (List.pairwise_cons.2 ⟨fun b hb => (hrest b hb _ _ _ _).symm, by
              braid_disj
              repeat' apply And.intro
              all_goals decide⟩)
            (disj_cons (disj_cellsAtoms_mem (by rw [hsv]; exact hsr₁) hsr₂)
              (disj_cellsAtoms_rest hrest)))
          (disj_append (cellsAtoms_disj (by rw [hfr]; exact hf₁) (by rw [hsv]; exact hf₂))
            (disj_cons (disj_cellsAtoms_mem (by rw [hfr]; exact hfr₁) hfr₂)
              (disj_cellsAtoms_rest hrest))))
        (disj_append
          (cellsAtoms_disj (by rw [hos]; exact hos'.1)
            (by rw [hfr]; exact Nat.le_trans (by decide) hos'.2))
          (disj_append (cellsAtoms_disj (by rw [hos]; exact ho8₁) (by rw [hsv]; exact ho8₂))
            (disj_cons (disj_cellsAtoms_mem (by rw [hos]; exact hor₁) hor₂)
              (disj_cellsAtoms_rest hrest)))))
      (disj_append
        (cellsAtoms_disj (by rw [List.length_map, hs]; exact hio.1) (by rw [hos]; exact hio.2))
        (disj_append
          (cellsAtoms_disj (by rw [List.length_map, hs]; exact his.1)
            (by rw [hfr]; exact Nat.le_trans (by decide) his.2))
          (disj_append
            (cellsAtoms_disj (by rw [List.length_map, hs]; exact hi8₁)
              (by rw [hsv]; exact hi8₂))
            (disj_cons (disj_cellsAtoms_mem (by rw [List.length_map, hs]; exact hir₁) hir₂)
              (disj_cellsAtoms_rest hrest))))))
    (List.forall_mem_append.2
      ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (by simpa using hin i (by simpa using hi)),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (hdst i hi),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (hframe i hi),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (hsaved i hi),
        by
          simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
            and_true, Atom.sat_reg, Atom.sat_flag, Atom.sat_pc]
          repeat' apply And.intro
          all_goals first
            | exact sat_mem_abs.2 hret | exact hout | exact hinp | exact hsp | rfl
            | (simp [hpc]; done)⟩⟩⟩⟩))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, fun i hi => ?_, fun i hi => ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · have hc := fun x => cell_of_holds (k := 4) (p := out)
      (vs := (block s).map (·.zeroExtend 64)) hq (by braid_at) i (by simpa using hi) (x := x)
    have h := hasBytes_of_cells hr (a := out + BitVec.ofNat 64 (4 * i)) (n := 4) hc
    simpa using h
  · have hc := fun x => cell_of_holds (k := 4) (p := inp)
      (vs := s.map (·.zeroExtend 64)) hq (by braid_at) i (by simpa using hi) (x := x)
    have h := hasBytes_of_cells hr (a := inp + BitVec.ofNat 64 (4 * i)) (n := 4) hc
    simpa using h
  · rw [← hr.reg .rsp]; exact Atoms.reg_of_holds (r := 6) hq (by braid_at)
  · rw [← hr.reg .rbx]; exact Atoms.reg_of_holds (r := 1) hq (by braid_at)
  · rw [← hr.reg .rbp]; exact Atoms.reg_of_holds (r := 7) hq (by braid_at)
  · rw [← hr.reg .r12]; exact Atoms.reg_of_holds (r := 12) hq (by braid_at)
  · rw [← hr.reg .r13]; exact Atoms.reg_of_holds (r := 13) hq (by braid_at)
  · rw [← hr.reg .r14]; exact Atoms.reg_of_holds (r := 14) hq (by braid_at)
  · rw [← hr.reg .r15]; exact Atoms.reg_of_holds (r := 15) hq (by braid_at)

/-- **`chacha20_block` on the machine.** A machine of the model that runs the executable of
this image, is at the entry of `chacha20_block`, has the sixteen 32-bit words `s` in memory
where `rsi` points, sixteen 32-bit cells `os` where `rdi` points, the return address `r` in
the eight bytes at the stack pointer, and 76 bytes of memory below it (the three
32-bit cells `fr` and the eight 64-bit cells `sv`), the input, the output and the stack
apart from one another, reaches `r` on every run, with the ChaCha20 block function of `s`
where `rdi` pointed, `s` still where `rsi` pointed, the stack pointer past the return
address, and the registers `rbx`, `rbp` and `r12` to `r15` as they were. -/
theorem chacha20_block_correct [Layout] (m : MachineState) (s : List W32)
    (os fr sv : List Word) (r : Word) (hpc : m.pc = 0x401040) (hs : s.length = 16)
    (hos : os.length = 16) (hfr : fr.length = 3) (hsv : sv.length = 8)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes m (m.data.regs.get64 .rsi + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hdst : ∀ (i : Nat) (hi : i < os.length),
      HasBytes m (m.data.regs.get64 .rdi + BitVec.ofNat 64 (4 * i)) 4 os[i])
    (hframe : ∀ (i : Nat) (hi : i < fr.length),
      HasBytes m (m.data.regs.get64 .rsp - 76#64 + BitVec.ofNat 64 (4 * i)) 4 fr[i])
    (hsaved : ∀ (i : Nat) (hi : i < sv.length),
      HasBytes m (m.data.regs.get64 .rsp - 64#64 + BitVec.ofNat 64 (8 * i)) 8 sv[i])
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hio : 64 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsi).toNat ∧
      64 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rdi).toNat)
    (his : 64 ≤ (m.data.regs.get64 .rsp - 76#64 - m.data.regs.get64 .rsi).toNat ∧
      84 ≤ (m.data.regs.get64 .rsi - (m.data.regs.get64 .rsp - 76#64)).toNat)
    (hos' : 64 ≤ (m.data.regs.get64 .rsp - 76#64 - m.data.regs.get64 .rdi).toNat ∧
      84 ≤ (m.data.regs.get64 .rdi - (m.data.regs.get64 .rsp - 76#64)).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        (∀ (i : Nat) (hi : i < (block s).length),
          HasBytes m' (m.data.regs.get64 .rdi + BitVec.ofNat 64 (4 * i)) 4
            ((block s)[i].zeroExtend 64)) ∧
        (∀ (i : Nat) (hi : i < s.length),
          HasBytes m' (m.data.regs.get64 .rsi + BitVec.ofNat 64 (4 * i)) 4
            (s[i].zeroExtend 64)) ∧
        m'.data.regs.get64 .rsp = m.data.regs.get64 .rsp + 8#64 ∧
        m'.data.regs.get64 .rbx = m.data.regs.get64 .rbx ∧
        m'.data.regs.get64 .rbp = m.data.regs.get64 .rbp ∧
        m'.data.regs.get64 .r12 = m.data.regs.get64 .r12 ∧
        m'.data.regs.get64 .r13 = m.data.regs.get64 .r13 ∧
        m'.data.regs.get64 .r14 = m.data.regs.get64 .r14 ∧
        m'.data.regs.get64 .r15 = m.data.regs.get64 .r15) m :=
  chacha20_block_correct_aux m s os fr sv r (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
    (m.data.regs.get64 .rsp) hpc rfl rfl rfl hs hos hfr hsv hin hdst hframe hsaved hret hio
    his hos'

end Examples.ChaCha20.O2.X86
