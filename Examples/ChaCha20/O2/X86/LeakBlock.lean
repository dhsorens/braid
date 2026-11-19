/-
  Examples.ChaCha20.O2.X86.LeakBlock

  What `chacha20_block` reveals on x86-64, compiled at `-O2` (`docs/Leakage.md`), as a traced
  triple: the addresses of its frame, of the input and of the output, where the branch of
  its loop goes, the stack pointer, where `ret` reads the return address, and the return
  address. None of these depends on the sixteen words of the state, so the function that
  gives the trace, `blockLeak`, does not take them.

  At `-O2` the code keeps no copy of the state in its frame: the loop that copied the input
  and the loop that added it are gone, and the entry is sixteen loads and the exit sixteen
  additions from memory, each with a store. It pushes six registers, saves its two arguments
  below them, and keeps a word of the state, a spill and the count of rounds in three slots,
  so its trace has the addresses of those; all are fixed offsets from the stack pointer. The
  only flag a branch reads is the zero flag of the count of rounds, which the code sets to
  ten. The code neither branches nor indexes on a word of the state. So `entryLeak` and
  `exitLeak` are new, with the statements of the two traced triples about them, and
  `blockLeak` is made of them as at `-O1`.

  The code is run in the parts of `Examples.ChaCha20.O2.X86.Block`, with the loop of rounds
  from `Examples.ChaCha20.O2.X86.LeakRound`. The traced triples here say nothing of what is
  computed, which is `chacha20_block_spec`: the output and the frame are left with some
  contents. The rules for traced triples are those of `Examples.ChaCha20.X86.LeakBlock`,
  imported and not repeated. The theorems about the machine alone are in
  `Examples.ChaCha20.O2.X86.Leakage`.

  ## Main definitions

  * `entryLeak`, `exitLeak`: what the code before the loop of rounds, and after it, reveals
  * `blockLeak`: what `chacha20_block` reveals, from its two pointers, the stack pointer and
    the return address

  ## Main results

  * `entry_trace`, `exit_trace`: the parts
  * `chacha20_block_trace`: the function reveals `blockLeak`
-/

module

public import Examples.ChaCha20.O2.X86.Block
public import Examples.ChaCha20.O2.X86.LeakRound
public import Examples.ChaCha20.X86.LeakBlock
import all Examples.ChaCha20.Common
import Iris.BI.DerivedLaws

@[expose] public section

namespace Examples.ChaCha20.O2.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs
open Examples.ChaCha20.X86 (forget_cellsT foldl_snoc_eq)

/-- Addition as `BitVec.add_assoc` leaves it: all three types `BitVec 64`. The stepper finds
memory atoms by syntactic equality of addresses, and an address it has folded two offsets
into is written this way. -/
local notation:65 a:65 " +ᵇ " b:66 =>
  @HAdd.hAdd (BitVec 64) (BitVec 64) (BitVec 64) instHAdd a b

/-! ## What is revealed -/

/-- What the entry of `chacha20_block` reveals, as far as the loop of rounds: the six pushes
below the stack pointer `sp` and the store of the first argument; the loads of the sixteen
words of the input, with the store of the eleventh to its slot and of the twelfth to the
spill slot; the store of the second argument; and the load of the twelfth word from the
spill slot and the store of the count of rounds to its slot. -/
def entryLeak (inp sp : Word) : Trace :=
  [.write (sp - 8#64) 8, .write (sp - 16#64) 8, .write (sp - 24#64) 8, .write (sp - 32#64) 8,
    .write (sp - 40#64) 8, .write (sp - 48#64) 8, .write (sp - 56#64) 8, .read inp 4,
    .read (inp + 4#64) 4, .read (inp + 8#64) 4, .read (inp + 12#64) 4, .read (inp + 16#64) 4,
    .read (inp + 20#64) 4, .read (inp + 24#64) 4, .read (inp + 28#64) 4, .read (inp + 32#64) 4,
    .read (inp + 36#64) 4, .read (inp + 40#64) 4, .write (sp - 72#64) 4, .read (inp + 44#64) 4,
    .write (sp - 76#64) 4, .read (inp + 48#64) 4, .read (inp + 52#64) 4, .read (inp + 56#64) 4,
    .write (sp - 64#64) 8, .read (inp + 60#64) 4, .read (sp - 76#64) 4, .write (sp - 68#64) 4]

/-- What the exit of `chacha20_block` reveals, from the end of the loop of rounds: the store
of a word of the state to the spill slot; for each of the sixteen words, the address it is
read from in the input and the address it is written to in the output, with the loads of the
two arguments before the first two, and the loads of two words of the state from their
slots; the six pops; and the load of the return address `r` at the stack pointer, and `r`,
where it goes. -/
def exitLeak (out inp sp r : Word) : Trace :=
  [.write (sp - 76#64) 4, .read (sp - 64#64) 8, .read inp 4, .read (sp - 56#64) 8, .write out 4,
    .read (sp - 64#64) 8, .read (inp + 4#64) 4, .read (sp - 56#64) 8, .write (out + 4#64) 4,
    .read (inp + 8#64) 4, .write (out + 8#64) 4, .read (inp + 12#64) 4, .write (out + 12#64) 4,
    .read (inp + 16#64) 4, .write (out + 16#64) 4, .read (inp + 20#64) 4, .write (out + 20#64) 4,
    .read (inp + 24#64) 4, .write (out + 24#64) 4, .read (inp + 28#64) 4, .write (out + 28#64) 4,
    .read (inp + 32#64) 4, .write (out + 32#64) 4, .read (inp + 36#64) 4, .write (out + 36#64) 4,
    .read (sp - 72#64) 4, .read (inp + 40#64) 4, .write (out + 40#64) 4, .read (sp - 76#64) 4,
    .read (inp + 44#64) 4, .write (out + 44#64) 4, .read (inp + 48#64) 4, .write (out + 48#64) 4,
    .read (inp + 52#64) 4, .write (out + 52#64) 4, .read (inp + 56#64) 4, .write (out + 56#64) 4,
    .read (inp + 60#64) 4, .write (out + 60#64) 4, .read (sp - 48#64) 8, .read (sp - 40#64) 8,
    .read (sp - 32#64) 8, .read (sp - 24#64) 8, .read (sp - 16#64) 8, .read (sp - 8#64) 8,
    .read sp 8, .jump r]

/-- **What `chacha20_block` reveals**: the addresses it works at, which are those of the
output, of the input and of its frame below the stack pointer, where the branch of its loop
goes, which is the same on every run, the stack pointer, where `ret` reads the return
address, and the return address. It is a function of the two pointers, the stack pointer
and the return address, and of nothing else: not of the sixteen words of the state. -/
def blockLeak (out inp sp r : Word) : Trace :=
  entryLeak inp sp ++ (roundsLeak (sp - 48#64) 9 ++ exitLeak out inp sp r)

/-! ## Tactics -/

/-- The symbolic state is the `n` atoms of the postcondition in another order:
`braid_done_perm`, for a traced triple. It leaves the equation between the traces. -/
local macro "done_perm " n:num : tactic =>
  `(tactic| (braid_norm
             refine TripleT.done_split ?_ ?_
             · iterate $n (apply Atoms.Split.cons; · braid_extract)
               exact Atoms.Split.nil))

/-- The trace the stepper has left is the one a specification gives. The specification alone
is written out, with its addresses as the stepper computes them, and the trace the stepper
has left is compared with it label by label, without reassociating it. -/
local macro "leak_eq_long " d:ident : tactic =>
  `(tactic| (conv =>
               rhs
               arg 2
               simp only [$d:ident, List.range_succ, List.range_zero, List.flatMap_cons,
                 List.flatMap_nil, List.append_assoc, List.cons_append, List.nil_append,
                 sub_lit, BitVec.add_assoc, BitVec.reduceAdd, BitVec.reduceNeg,
                 BitVec.add_zero, Nat.reduceMul, Nat.reduceAdd, Nat.reduceLT, ↓reduceIte,
                 BitVec.ofNat_eq_ofNat]
             refine Eq.trans ?_ (foldl_snoc_eq _ _)
             simp only [List.foldl_cons, List.foldl_nil]))

/-- Forget the values of the status flags that have one. -/
local macro "forget_flags" : tactic =>
  `(tactic| (try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 3
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-- Name what the fifteen registers of the state hold. -/
local macro "name_regs" : tactic =>
  `(tactic| (braid_name_reg 10; braid_name_reg 5; braid_name_reg 9; braid_name_reg 13
             braid_name_reg 12; braid_name_reg 15; braid_name_reg 14; braid_name_reg 7
             braid_name_reg 1; braid_name_reg 11; braid_name_reg 4; braid_name_reg 8
             braid_name_reg 3; braid_name_reg 2; braid_name_reg 0))

/-- Forget the fifteen registers of the state. -/
local macro "forget_regs" : tactic =>
  `(tactic| (braid_forget 10; braid_forget 5; braid_forget 9; braid_forget 13
             braid_forget 12; braid_forget 15; braid_forget 14; braid_forget 7
             braid_forget 1; braid_forget 11; braid_forget 4; braid_forget 8
             braid_forget 3; braid_forget 2; braid_forget 0))

/-! ## The code -/

/-- **What the entry of `chacha20_block` reveals**, as far as the loop of rounds: `entryLeak`
of the address of the input and the stack pointer. The spill slot and the slot of the state
are left with some contents and the fifteen registers of the state with some values, which
the trace does not need; the count of rounds, in its slot, is ten. -/
theorem entry_trace (out inp sp₀ : Word)
    (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : W32)
    (f0 f1 f2 : Word)
    (m0 m1 m2 m3 m4 m5 m6 m7 t0 v1 t2 t3 v7 t8 t9 t10 t11 v12 v13 v14 v15 : Word)
    (fc fp fa fz fs fo : Bool) (t : Trace) :
    TripleT chacha20_block.program
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
        .flag Flags.sf fs, .flag Flags.of fo]) t
      (Atoms.interp [.prop (cellsAt 4 true inp
          [a0.zeroExtend 64, a1.zeroExtend 64, a2.zeroExtend 64, a3.zeroExtend 64,
           a4.zeroExtend 64, a5.zeroExtend 64, a6.zeroExtend 64, a7.zeroExtend 64,
           a8.zeroExtend 64, a9.zeroExtend 64, a10.zeroExtend 64, a11.zeroExtend 64,
           a12.zeroExtend 64, a13.zeroExtend 64, a14.zeroExtend 64, a15.zeroExtend 64]),
        .prop (memAny (sp₀ +ᵇ 18446744073709551540#64) 4 true),
        .prop (memAny (sp₀ +ᵇ 18446744073709551544#64) 4 true),
        .mem (sp₀ +ᵇ 18446744073709551548#64) 4 ((10#32).zeroExtend 64) true,
        .prop (cellsAt 8 true (sp₀ - 64#64) [inp, out, v1, v12, v13, v14, v15, v7]),
        .pc 0x4010a0#64, .reg rsp (sp₀ +ᵇ 18446744073709551568#64),
        .prop (regAny r10), .prop (regAny rdi), .prop (regAny r9), .prop (regAny r13),
        .prop (regAny r12), .prop (regAny r15), .prop (regAny r14), .prop (regAny rbp),
        .prop (regAny rbx), .prop (regAny r11), .prop (regAny rsi), .prop (regAny r8),
        .prop (regAny rdx), .prop (regAny rcx), .prop (regAny rax),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf),
        .prop (flagAny Flags.af), .prop (flagAny Flags.zf), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) (t ++ entryLeak inp sp₀) := by
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold frame_cells sp₀ _ _ _
  braid_unfold saved_cells sp₀ _ _ _ _ _ _ _ _
  -- The pushes, the loads and the count of rounds.
  iterate 29 braid_sym_step
  forget_flags
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold saved_cells sp₀ _ _ _ _ _ _ _ _
  braid_forget_mem (sp₀ +ᵇ 18446744073709551540#64)
  braid_forget_mem (sp₀ +ᵇ 18446744073709551544#64)
  forget_regs
  done_perm 28
  leak_eq_long entryLeak

/-- **What the exit of `chacha20_block` reveals**, from the end of the loop of rounds:
`exitLeak` of the two pointers, the stack pointer and the return address, whatever the
registers of the state, the frame and the input hold. The output and the frame are left with
some contents. -/
theorem exit_trace (out inp r sp₀ : Word)
    (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : W32)
    (o0 o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 o11 o12 o13 o14 o15 : Word)
    (g0 g1 g2 : Word)
    (x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x11 x12 x13 x14 x15 : Word)
    (v1 v7 v12 v13 v14 v15 : Word) (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp [.prop (cellsAt 4 true inp
          [a0.zeroExtend 64, a1.zeroExtend 64, a2.zeroExtend 64, a3.zeroExtend 64,
           a4.zeroExtend 64, a5.zeroExtend 64, a6.zeroExtend 64, a7.zeroExtend 64,
           a8.zeroExtend 64, a9.zeroExtend 64, a10.zeroExtend 64, a11.zeroExtend 64,
           a12.zeroExtend 64, a13.zeroExtend 64, a14.zeroExtend 64, a15.zeroExtend 64]),
        .prop (cellsAt 4 true out
          [o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13, o14, o15]),
        .prop (cellsAt 4 true (sp₀ - 76#64) [g0, g1, g2]),
        .prop (cellsAt 8 true (sp₀ - 64#64) [inp, out, v1, v12, v13, v14, v15, v7]),
        .mem sp₀ 8 r true, .pc 0x4011e4#64, .reg rsp (sp₀ +ᵇ 18446744073709551568#64),
        .reg r10 x0, .reg rdi x1, .reg r9 x2, .reg r13 x3, .reg r12 x4, .reg r15 x5,
        .reg r14 x6, .reg rbp x7, .reg rbx x8, .reg r11 x9, .reg rsi x11, .reg r8 x12,
        .reg rdx x13, .reg rcx x14, .reg rax x15,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf),
        .prop (flagAny Flags.af), .prop (flagAny Flags.zf), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) t
      (Atoms.interp [.prop (cellsAt 4 true inp
          [a0.zeroExtend 64, a1.zeroExtend 64, a2.zeroExtend 64, a3.zeroExtend 64,
           a4.zeroExtend 64, a5.zeroExtend 64, a6.zeroExtend 64, a7.zeroExtend 64,
           a8.zeroExtend 64, a9.zeroExtend 64, a10.zeroExtend 64, a11.zeroExtend 64,
           a12.zeroExtend 64, a13.zeroExtend 64, a14.zeroExtend 64, a15.zeroExtend 64]),
        .prop (cellsAny 4 out 16),
        .prop (cellsAny 4 (sp₀ - 76#64) 3),
        .prop (cellsAt 8 true (sp₀ - 64#64) [inp, out, v1, v12, v13, v14, v15, v7]),
        .mem sp₀ 8 r true, .pc r, .reg rsp (sp₀ + 8#64), .reg rbx v1, .reg rbp v7,
        .reg r12 v12, .reg r13 v13, .reg r14 v14, .reg r15 v15, .prop (regAny rax),
        .prop (regAny rcx), .prop (regAny rdx), .prop (regAny rsi), .prop (regAny rdi),
        .prop (regAny r8), .prop (regAny r9), .prop (regAny r10), .prop (regAny r11),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (t ++ exitLeak out inp sp₀ r) := by
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold frame_cells sp₀ _ _ _
  braid_unfold saved_cells sp₀ _ _ _ _ _ _ _ _
  -- The sum with the input, the pops and the return.
  braid_sym_run
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold frame_cells sp₀ _ _ _
  braid_fold saved_cells sp₀ _ _ _ _ _ _ _ _
  apply forget_cellsT (k := 4) (p := sp₀ + 18446744073709551540#64) (n := 3)
  case hupd => braid_upd
  case hn => rfl
  apply forget_cellsT (k := 4) (p := out) (n := 16)
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
  done_perm 28
  leak_eq_long exitLeak

/-- **What `chacha20_block` reveals**: `blockLeak` of its two arguments, the stack pointer
and the return address, whatever the sixteen words of the input are. The return address is
in the eight bytes at the stack pointer, with 76 bytes below it. The output and the frame
are left with some contents, which `chacha20_block_spec` gives; the registers `rbx`, `rbp`
and `r12` to `r15` are restored, and the stack pointer is past the return address. -/
theorem chacha20_block_trace (out inp r sp₀ : Word) (s : List W32) (os fr sv : List Word)
    (t0 v1 t2 t3 v7 t8 t9 t10 t11 v12 v13 v14 v15 : Word) (fc fp fa fz fs fo : Bool)
    (hs : s.length = 16) (hos : os.length = 16) (hfr : fr.length = 3) (hsv : sv.length = 8)
    (t : Trace) :
    TripleT chacha20_block.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) :: .prop (cellsAt 4 true (sp₀ - 76#64) fr) ::
        .prop (cellsAt 8 true (sp₀ - 64#64) sv) ::
        [.mem sp₀ 8 r true, .pc 0x401040#64, .reg rax t0, .reg rbx v1, .reg rcx t2,
        .reg rdx t3, .reg rsi inp, .reg rdi out, .reg rsp sp₀, .reg rbp v7, .reg r8 t8,
        .reg r9 t9, .reg r10 t10, .reg r11 t11, .reg r12 v12, .reg r13 v13, .reg r14 v14,
        .reg r15 v15, .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa,
        .flag Flags.zf fz, .flag Flags.sf fs, .flag Flags.of fo])) t
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAny 4 out 16) ::
        .prop (cellsAny 4 (sp₀ - 76#64) 3) ::
        .prop (cellsAt 8 true (sp₀ - 64#64) [inp, out, v1, v12, v13, v14, v15, v7]) ::
        [.mem sp₀ 8 r true, .pc r, .prop (regAny rax), .reg rbx v1, .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .prop (regAny rdi), .reg rsp (sp₀ + 8#64),
        .reg rbp v7, .prop (regAny r8), .prop (regAny r9), .prop (regAny r10),
        .prop (regAny r11), .reg r12 v12, .reg r13 v13, .reg r14 v14, .reg r15 v15,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]))
      (t ++ blockLeak out inp sp₀ r) := by
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
  simp only [List.map_cons, List.map_nil]
  braid_call entry_trace out inp sp₀ a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15
    f0 f1 f2
    m0 m1 m2 m3 m4 m5 m6 m7 t0 v1 t2 t3 v7 t8 t9 t10 t11 v12 v13 v14 v15 fc fp fa fz fs fo t
  -- The ten double rounds, on the slots of the frame.
  name_regs
  braid_name_mem (sp₀ + 18446744073709551540#64)
  braid_name_mem (sp₀ + 18446744073709551544#64)
  have h := fun v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 u t =>
    rounds_trace 9 v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 10#32
      (sp₀ +ᵇ 18446744073709551568#64) u t rfl (by decide)
  braid_call h _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  clear h
  name_regs
  braid_name_mem (sp₀ + 18446744073709551540#64)
  braid_name_mem (sp₀ + 18446744073709551544#64)
  braid_fold frame_cells sp₀ _ _ _
  -- The sum with the input, and the return.
  braid_call exit_trace out inp r sp₀ a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15
    o0 o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 o11 o12 o13 o14 o15
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ v1 v7 v12 v13 v14 v15 _
  done_perm 28
  simp only [blockLeak, List.append_assoc, sub_lit, BitVec.reduceNeg]

end Examples.ChaCha20.O2.X86
