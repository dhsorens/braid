/-
  Examples.ChaCha20.X86.LeakBlock

  What `chacha20_block` reveals on x86-64 (`docs/Leakage.md`), as a traced triple: the
  addresses of its frame, of the input and of the output, where the branches of its three
  loops go, the stack pointer, where `ret` reads the return address, and the return address.
  None of these depends on the sixteen words of the state, so the function that gives the
  trace, `blockLeak`, does not take them.

  The compiled code differs from the RISC-V one in what it touches, and not in what that
  depends on. It pushes six registers, saves its two arguments in the frame and loads them
  back, and keeps three words of the state and two spills in slots of the frame, so its trace
  has the addresses of those; all are fixed offsets from the stack pointer. It sets flags,
  and the only flag a branch reads is the zero flag of a counter that is a literal. The code
  neither branches nor indexes on a word of the state.

  The code is run in the parts of `Examples.ChaCha20.X86.Block`, with the loop of rounds
  from `Examples.ChaCha20.X86.LeakRound`. The traced triples here say nothing of what is
  computed, which is `chacha20_block_spec`: the output and the frame are left with some
  contents. The theorems about the machine alone are in `Examples.ChaCha20.X86.Leakage`.

  ## Main definitions

  * `entry_run`, `exit_run`: the trace of the code before the loop of rounds, and after it,
    found by its run, with the traced triple
  * `block_run`: the trace of `chacha20_block`, found by its run, with the traced triple; it
    is a function of its two pointers, the stack pointer and the return address
  * `blockLeak`: what `chacha20_block` reveals, which is that trace

  ## Main results

  * `forget_cellsT`, `name_cellsT`, `restateT`, `foldl_snoc_eq`: rules that belong with the
    logic
-/

module

public import Braid.Logic.Traced
public import Examples.ChaCha20.X86.Block
public import Examples.ChaCha20.X86.LeakRound
import all Examples.ChaCha20.Common
import Iris.BI.DerivedLaws

@[expose] public section

namespace Examples.ChaCha20.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- Addition as the stepper writes it when it evaluates an `add`: all three types `Word`. -/
local notation:65 a:65 " +ʷ " b:66 => @HAdd.hAdd Word Word Word instHAdd a b

/-- Addition as `BitVec.add_assoc` leaves it: all three types `BitVec 64`. The stepper finds
memory atoms by syntactic equality of addresses, and an address it has folded two offsets
into is written this way. -/
local notation:65 a:65 " +ᵇ " b:66 =>
  @HAdd.hAdd (BitVec 64) (BitVec 64) (BitVec 64) instHAdd a b

/-- Addition as `sub_lit` leaves it, for the stack pointer less a literal. -/
local notation:65 a:65 " +ᵐ " b:66 => @HAdd.hAdd Word (BitVec 64) Word instHAdd a b

/-! ## Rules that the logic has for triples without a trace, and for traces -/

/-- Forget the values of an array: `Triple.forget_cells`, with a trace. -/
theorem forget_cellsT {P : Braid.Program} {as as' : Atoms} {k n : Nat} {p : Word}
    {vs : List Word} {Q : SProp} {t t' : Trace} (hn : vs.length = n)
    (hupd : as.Upd (.prop (cellsAt k true p vs)) (.prop (cellsAny k p n)) as')
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h.conseq (Iris.BI.sep_mono_left (fun _ hv => ⟨_, ⟨⟨vs, hn⟩, rfl⟩, hv⟩)) .rfl

/-- Name the values of an array that holds some values. -/
theorem name_cellsT {P : Braid.Program} {as rest : Atoms} {k n : Nat} {p : Word} {Q : SProp}
    {t t' : Trace} (hext : as.Extract (.prop (cellsAny k p n)) rest)
    (h : ∀ vs : List Word, vs.length = n →
      TripleT P (Atoms.interp (.prop (cellsAt k true p vs) :: rest)) t Q t') :
    TripleT P (Atoms.interp as) t Q t' := by
  rw [hext.interp]
  exact (TripleT.exists_pre fun vs : { l : List Word // l.length = n } =>
    h vs.1 vs.2).conseq Iris.BI.sep_exists_right.1 .rfl

/-- `Triple.restate`, with a trace: replace an atom of the symbolic state by one that means
the same. -/
theorem restateT {P : Braid.Program} {as as' : Atoms} {a a' : Atom} {Q : SProp} {t t' : Trace}
    (he : a.interp = a'.interp) (hupd : as.Upd a a' as')
    (h : TripleT P (Atoms.interp as') t Q t') : TripleT P (Atoms.interp as) t Q t' := by
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e, he]; rw [e'] at h
  exact h

/-- A trace to which labels were added one at a time, as the stepper adds them, is the
trace with the list of them appended. -/
theorem foldl_snoc_eq (t ls : Trace) : ls.foldl (fun acc l => acc ++ [l]) t = t ++ ls := by
  induction ls generalizing t with
  | nil => simp
  | cons l ls ih => simp [ih]

/-- Forget the values of the status flags that have one. -/
local macro "forget_flags" : tactic =>
  `(tactic| (try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 3
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-- Name what the thirteen registers of the state hold. -/
local macro "name_regs" : tactic =>
  `(tactic| (braid_name_reg 11; braid_name_reg 15; braid_name_reg 2; braid_name_reg 5
             braid_name_reg 10; braid_name_reg 14; braid_name_reg 0; braid_name_reg 7
             braid_name_reg 4; braid_name_reg 13; braid_name_reg 8; braid_name_reg 1
             braid_name_reg 12))

/-- Forget the thirteen registers of the state. -/
local macro "forget_regs" : tactic =>
  `(tactic| (braid_forget 11; braid_forget 15; braid_forget 2; braid_forget 5
             braid_forget 10; braid_forget 14; braid_forget 0; braid_forget 7
             braid_forget 4; braid_forget 13; braid_forget 8; braid_forget 1
             braid_forget 12))

/-- `braid_name_mem`, for the body of a definition that is exposed: the side condition is a
goal of its own, since a `by` block inside a term waits there for as long as its goal has a
metavariable. -/
local macro "name_mem " a:term : tactic =>
  `(tactic| (apply TripleT.mem_any (a := $a)
             case hext => braid_extract
             intro _))

/-! ## The code -/

/-- **The entry of `chacha20_block` and the trace of its run**, as far as the loop of
rounds. The trace found is a function of the address of the input and the stack pointer:
the six pushes below the stack pointer and the store of the first argument; for each of the
sixteen words, the address it is read from in the input, the address it is written to in
the frame, and where the branch of the loop that copies goes, which is back to its head but
for the last; the store of the second argument; and the loads of the words from the frame
into registers, with the stores of three of them to slots. The frame is left with some
contents and the thirteen registers of the state with some values, which the trace does not
need. -/
def entry_run (inp sp₀ : Word) : { ls : Trace // ∀ (out : Word)
    (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : W32)
    (f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 : Word)
    (m0 m1 m2 m3 m4 m5 m6 m7 t0 v1 t2 t3 v7 t8 t10 t11 v12 v13 v14 v15 : Word)
    (fc fp fa fz fs fo : Bool) (t : Trace),
    TripleT chacha20_block.program
      (Atoms.interp [.prop (cellsAt 4 true inp
          [a0.zeroExtend 64, a1.zeroExtend 64, a2.zeroExtend 64, a3.zeroExtend 64,
           a4.zeroExtend 64, a5.zeroExtend 64, a6.zeroExtend 64, a7.zeroExtend 64,
           a8.zeroExtend 64, a9.zeroExtend 64, a10.zeroExtend 64, a11.zeroExtend 64,
           a12.zeroExtend 64, a13.zeroExtend 64, a14.zeroExtend 64, a15.zeroExtend 64]),
        .prop (cellsAt 4 true (sp₀ - 148#64)
          [f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18,
           f19, f20]),
        .prop (cellsAt 8 true (sp₀ - 64#64) [m0, m1, m2, m3, m4, m5, m6, m7]),
        .pc 0x401040#64, .reg rax t0, .reg rbx v1, .reg rcx t2, .reg rdx t3, .reg rsi inp,
        .reg rdi out, .reg rsp sp₀, .reg rbp v7, .reg r8 t8, .reg r10 t10, .reg r11 t11,
        .reg r12 v12, .reg r13 v13, .reg r14 v14, .reg r15 v15, .flag Flags.cf fc,
        .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz, .flag Flags.sf fs,
        .flag Flags.of fo]) t
      (Atoms.interp [.prop (cellsAt 4 true inp
          [a0.zeroExtend 64, a1.zeroExtend 64, a2.zeroExtend 64, a3.zeroExtend 64,
           a4.zeroExtend 64, a5.zeroExtend 64, a6.zeroExtend 64, a7.zeroExtend 64,
           a8.zeroExtend 64, a9.zeroExtend 64, a10.zeroExtend 64, a11.zeroExtend 64,
           a12.zeroExtend 64, a13.zeroExtend 64, a14.zeroExtend 64, a15.zeroExtend 64]),
        .prop (cellsAny 4 (sp₀ - 148#64) 21),
        .prop (cellsAt 8 true (sp₀ - 64#64) [out, inp, v1, v12, v13, v14, v15, v7]),
        .pc 0x4010d0#64, .reg rsp (sp₀ +ᵇ 18446744073709551568#64),
        .prop (regAny r11), .prop (regAny r15), .prop (regAny rcx), .prop (regAny rdi),
        .prop (regAny r10), .prop (regAny r14), .prop (regAny rax), .prop (regAny rbp),
        .prop (regAny rsi), .prop (regAny r13), .prop (regAny r8), .prop (regAny rbx),
        .prop (regAny r12),
        .reg rdx 10#64, .prop (flagAny Flags.cf), .prop (flagAny Flags.pf),
        .prop (flagAny Flags.af), .prop (flagAny Flags.zf), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) (t ++ ls) } := by
  braid_traced
  intro out a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15
    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20
    m0 m1 m2 m3 m4 m5 m6 m7 t0 v1 t2 t3 v7 t8 t10 t11 v12 v13 v14 v15 fc fp fa fz fs fo t
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold saved_cells sp₀ _ _ _ _ _ _ _ _
  iterate 8 braid_sym_step
  simp only [BitVec.xor_self]
  iterate 81 braid_sym_step
  apply restateT (a := .mem (sp₀ +ʷ 18446744073709551528#64) 4 _ true)
    (a' := .mem (sp₀ +ᵇ 18446744073709551528#64) 4 _ true) rfl
  case hupd => braid_upd
  iterate 22 braid_sym_step
  forget_flags
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold saved_cells sp₀ _ _ _ _ _ _ _ _
  apply forget_cellsT (k := 4) (p := sp₀ + 18446744073709551468#64) (n := 21)
  case hupd => braid_upd
  case hn => rfl
  forget_regs
  braid_done_traced 25

/-- **The exit of `chacha20_block` and the trace of its run**, from the end of the loop of
rounds, whatever the registers of the state, the frame and the input hold. The trace found
is a function of the two pointers, the stack pointer and the return address `r`: the stores
of the words of the state to the frame, with the loads of three of them from slots; the
loads of the two arguments; for each of the sixteen words, the address it is read from in
the input, the address it is read from in the frame, the address it is written to in the
output, and where the branch of the loop that adds goes, which is back to its head but for
the last; the six pops; and the load of `r` at the stack pointer, and `r`, where it goes.
The output and the frame are left with some contents. -/
def exit_run (out inp sp₀ r : Word) : { ls : Trace // ∀
    (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : W32)
    (o0 o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 o11 o12 o13 o14 o15 : Word)
    (g0 g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 g11 g12 g13 g14 g15 g16 g17 g18 g19 g20 : Word)
    (x2 x3 x4 x5 x6 x7 x8 x10 x11 x12 x13 x14 x15 : Word)
    (t3 v1 v7 v12 v13 v14 v15 : Word) (t : Trace),
    TripleT chacha20_block.program
      (Atoms.interp [.prop (cellsAt 4 true inp
          [a0.zeroExtend 64, a1.zeroExtend 64, a2.zeroExtend 64, a3.zeroExtend 64,
           a4.zeroExtend 64, a5.zeroExtend 64, a6.zeroExtend 64, a7.zeroExtend 64,
           a8.zeroExtend 64, a9.zeroExtend 64, a10.zeroExtend 64, a11.zeroExtend 64,
           a12.zeroExtend 64, a13.zeroExtend 64, a14.zeroExtend 64, a15.zeroExtend 64]),
        .prop (cellsAt 4 true out
          [o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13, o14, o15]),
        .prop (cellsAt 4 true (sp₀ - 148#64)
          [g0, g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12, g13, g14, g15, g16, g17, g18,
           g19, g20]),
        .prop (cellsAt 8 true (sp₀ - 64#64) [out, inp, v1, v12, v13, v14, v15, v7]),
        .mem sp₀ 8 r true, .pc 0x40123c#64, .reg rsp (sp₀ +ᵇ 18446744073709551568#64),
        .reg r11 x2, .reg r15 x3, .reg rcx x4, .reg rdi x5, .reg r10 x6, .reg r14 x7,
        .reg rax x8, .reg rbp x10, .reg rsi x11, .reg r13 x12, .reg r8 x13, .reg rbx x14,
        .reg r12 x15,
        .reg rdx t3, .prop (flagAny Flags.cf), .prop (flagAny Flags.pf),
        .prop (flagAny Flags.af), .prop (flagAny Flags.zf), .prop (flagAny Flags.sf),
        .prop (flagAny Flags.of)]) t
      (Atoms.interp [.prop (cellsAt 4 true inp
          [a0.zeroExtend 64, a1.zeroExtend 64, a2.zeroExtend 64, a3.zeroExtend 64,
           a4.zeroExtend 64, a5.zeroExtend 64, a6.zeroExtend 64, a7.zeroExtend 64,
           a8.zeroExtend 64, a9.zeroExtend 64, a10.zeroExtend 64, a11.zeroExtend 64,
           a12.zeroExtend 64, a13.zeroExtend 64, a14.zeroExtend 64, a15.zeroExtend 64]),
        .prop (cellsAny 4 out 16),
        .prop (cellsAny 4 (sp₀ - 148#64) 21),
        .prop (cellsAt 8 true (sp₀ - 64#64) [out, inp, v1, v12, v13, v14, v15, v7]),
        .mem sp₀ 8 r true, .pc r, .reg rsp (sp₀ + 8#64), .reg rbx v1, .reg rbp v7,
        .reg r12 v12, .reg r13 v13, .reg r14 v14, .reg r15 v15, .prop (regAny rax),
        .prop (regAny rcx), .prop (regAny rdx), .prop (regAny rsi), .prop (regAny rdi),
        .prop (regAny r8), .prop (regAny r10), .prop (regAny r11),
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (t ++ ls) } := by
  braid_traced
  intro a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15
    o0 o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 o11 o12 o13 o14 o15
    g0 g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 g11 g12 g13 g14 g15 g16 g17 g18 g19 g20
    x2 x3 x4 x5 x6 x7 x8 x10 x11 x12 x13 x14 x15 t3 v1 v7 v12 v13 v14 v15 t
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold saved_cells sp₀ _ _ _ _ _ _ _ _
  apply restateT (a := .mem (sp₀ +ᵐ 18446744073709551608#64) 8 _ true)
    (a' := .mem (sp₀ +ᵇ 18446744073709551608#64) 8 _ true) rfl
  case hupd => braid_upd
  apply restateT (a := .mem (sp₀ +ʷ 18446744073709551528#64) 4 _ true)
    (a' := .mem (sp₀ +ᵇ 18446744073709551528#64) 4 _ true) rfl
  case hupd => braid_upd
  braid_sym_run
  simp only [BitVec.xor_self]
  apply restateT (a := .mem (sp₀ +ᵇ 18446744073709551528#64) 4 _ true)
    (a' := .mem (sp₀ +ʷ 18446744073709551528#64) 4 _ true) rfl
  case hupd => braid_upd
  braid_sym_run
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold saved_cells sp₀ _ _ _ _ _ _ _ _
  apply forget_cellsT (k := 4) (p := sp₀ + 18446744073709551468#64) (n := 21)
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
  braid_forget 10
  braid_forget 11
  forget_flags
  braid_done_traced 27

/-- **`chacha20_block` and the trace of its run**, whatever the sixteen words of the input
are. The trace found is a function of its two arguments, the stack pointer and the return
address, which are bound before it, and of nothing else. The return address is in the eight
bytes at the stack pointer, with 148 bytes below it. The output and the frame are left with
some contents, which `chacha20_block_spec` gives; the registers `rbx`, `rbp` and `r12` to
`r15` are restored, and the stack pointer is past the return address. -/
def block_run (out inp sp₀ r : Word) : { ls : Trace // ∀ (s : List W32)
    (os fr sv : List Word)
    (t0 v1 t2 t3 v7 t8 t9 t10 t11 v12 v13 v14 v15 : Word) (fc fp fa fz fs fo : Bool)
    (_ : s.length = 16) (_ : os.length = 16) (_ : fr.length = 21) (_ : sv.length = 8)
    (t : Trace),
    TripleT chacha20_block.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) :: .prop (cellsAt 4 true (sp₀ - 148#64) fr) ::
        .prop (cellsAt 8 true (sp₀ - 64#64) sv) ::
        [.mem sp₀ 8 r true, .pc 0x401040#64, .reg rax t0, .reg rbx v1, .reg rcx t2,
        .reg rdx t3, .reg rsi inp, .reg rdi out, .reg rsp sp₀, .reg rbp v7, .reg r8 t8,
        .reg r9 t9, .reg r10 t10, .reg r11 t11, .reg r12 v12, .reg r13 v13, .reg r14 v14,
        .reg r15 v15, .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa,
        .flag Flags.zf fz, .flag Flags.sf fs, .flag Flags.of fo])) t
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAny 4 out 16) ::
        .prop (cellsAny 4 (sp₀ - 148#64) 21) ::
        .prop (cellsAt 8 true (sp₀ - 64#64) [out, inp, v1, v12, v13, v14, v15, v7]) ::
        [.mem sp₀ 8 r true, .pc r, .prop (regAny rax), .reg rbx v1, .prop (regAny rcx),
        .prop (regAny rdx), .prop (regAny rsi), .prop (regAny rdi), .reg rsp (sp₀ + 8#64),
        .reg rbp v7, .prop (regAny r8), .prop (regAny r9), .prop (regAny r10),
        .prop (regAny r11), .reg r12 v12, .reg r13 v13, .reg r14 v14, .reg r15 v15,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]))
      (t ++ ls) } := by
  braid_traced
  intro s os fr sv t0 v1 t2 t3 v7 t8 t9 t10 t11 v12 v13 v14 v15 fc fp fa fz fs fo hs hos hfr
    hsv t
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
  obtain ⟨f3, fr3, rfl, hfr3⟩ := exists_cons_of_length hfr2
  obtain ⟨f4, fr4, rfl, hfr4⟩ := exists_cons_of_length hfr3
  obtain ⟨f5, fr5, rfl, hfr5⟩ := exists_cons_of_length hfr4
  obtain ⟨f6, fr6, rfl, hfr6⟩ := exists_cons_of_length hfr5
  obtain ⟨f7, fr7, rfl, hfr7⟩ := exists_cons_of_length hfr6
  obtain ⟨f8, fr8, rfl, hfr8⟩ := exists_cons_of_length hfr7
  obtain ⟨f9, fr9, rfl, hfr9⟩ := exists_cons_of_length hfr8
  obtain ⟨f10, fr10, rfl, hfr10⟩ := exists_cons_of_length hfr9
  obtain ⟨f11, fr11, rfl, hfr11⟩ := exists_cons_of_length hfr10
  obtain ⟨f12, fr12, rfl, hfr12⟩ := exists_cons_of_length hfr11
  obtain ⟨f13, fr13, rfl, hfr13⟩ := exists_cons_of_length hfr12
  obtain ⟨f14, fr14, rfl, hfr14⟩ := exists_cons_of_length hfr13
  obtain ⟨f15, fr15, rfl, hfr15⟩ := exists_cons_of_length hfr14
  obtain ⟨f16, fr16, rfl, hfr16⟩ := exists_cons_of_length hfr15
  obtain ⟨f17, fr17, rfl, hfr17⟩ := exists_cons_of_length hfr16
  obtain ⟨f18, fr18, rfl, hfr18⟩ := exists_cons_of_length hfr17
  obtain ⟨f19, fr19, rfl, hfr19⟩ := exists_cons_of_length hfr18
  obtain ⟨f20, fr20, rfl, hfr20⟩ := exists_cons_of_length hfr19
  obtain rfl := List.length_eq_zero_iff.1 hfr20
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
  braid_call (entry_run inp sp₀).2 out a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15
    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20
    m0 m1 m2 m3 m4 m5 m6 m7 t0 v1 t2 t3 v7 t8 t10 t11 v12 v13 v14 v15 fc fp fa fz fs fo t
  -- The frame, which the entry left with some contents.
  apply name_cellsT (k := 4) (p := sp₀ + 18446744073709551468#64) (n := 21)
  case hext => braid_extract
  intro gs hgs
  obtain ⟨g0, gs0, rfl, hgs0⟩ := exists_cons_of_length hgs
  obtain ⟨g1, gs1, rfl, hgs1⟩ := exists_cons_of_length hgs0
  obtain ⟨g2, gs2, rfl, hgs2⟩ := exists_cons_of_length hgs1
  obtain ⟨g3, gs3, rfl, hgs3⟩ := exists_cons_of_length hgs2
  obtain ⟨g4, gs4, rfl, hgs4⟩ := exists_cons_of_length hgs3
  obtain ⟨g5, gs5, rfl, hgs5⟩ := exists_cons_of_length hgs4
  obtain ⟨g6, gs6, rfl, hgs6⟩ := exists_cons_of_length hgs5
  obtain ⟨g7, gs7, rfl, hgs7⟩ := exists_cons_of_length hgs6
  obtain ⟨g8, gs8, rfl, hgs8⟩ := exists_cons_of_length hgs7
  obtain ⟨g9, gs9, rfl, hgs9⟩ := exists_cons_of_length hgs8
  obtain ⟨g10, gs10, rfl, hgs10⟩ := exists_cons_of_length hgs9
  obtain ⟨g11, gs11, rfl, hgs11⟩ := exists_cons_of_length hgs10
  obtain ⟨g12, gs12, rfl, hgs12⟩ := exists_cons_of_length hgs11
  obtain ⟨g13, gs13, rfl, hgs13⟩ := exists_cons_of_length hgs12
  obtain ⟨g14, gs14, rfl, hgs14⟩ := exists_cons_of_length hgs13
  obtain ⟨g15, gs15, rfl, hgs15⟩ := exists_cons_of_length hgs14
  obtain ⟨g16, gs16, rfl, hgs16⟩ := exists_cons_of_length hgs15
  obtain ⟨g17, gs17, rfl, hgs17⟩ := exists_cons_of_length hgs16
  obtain ⟨g18, gs18, rfl, hgs18⟩ := exists_cons_of_length hgs17
  obtain ⟨g19, gs19, rfl, hgs19⟩ := exists_cons_of_length hgs18
  obtain ⟨g20, gs20, rfl, hgs20⟩ := exists_cons_of_length hgs19
  obtain rfl := List.length_eq_zero_iff.1 hgs20
  braid_unfold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  -- The ten double rounds, on the slots of the frame.
  name_regs
  have h := fun v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 t =>
    (rounds_run (sp₀ +ᵇ 18446744073709551568#64) 9).2 v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11
      v12 v13 v14 v15 10#32 t9 g19 g20 t rfl (by decide)
  braid_call h _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  clear h
  name_regs
  braid_name_reg 9
  name_mem (sp₀ + 18446744073709551472#64)
  name_mem (sp₀ + 18446744073709551476#64)
  name_mem (sp₀ + 18446744073709551468#64)
  name_mem (sp₀ + 18446744073709551544#64)
  name_mem (sp₀ + 18446744073709551548#64)
  braid_fold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  -- The stores, the sum with the input, and the return.
  braid_call (exit_run out inp sp₀ r).2 a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15
    o0 o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 o11 o12 o13 o14 o15
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ v1 v7 v12 v13 v14 v15 _
  braid_forget 9
  braid_done_traced 28

/-- **What `chacha20_block` reveals**: the addresses it works at, which are those of the
output, of the input and of its frame below the stack pointer, where the branches of its
three loops go, which is the same on every run, the stack pointer, where `ret` reads the
return address, and the return address. It is the trace that the run of `block_run` finds,
a function of the two pointers, the stack pointer and the return address, and of nothing
else: not of the sixteen words of the state. -/
def blockLeak (out inp sp r : Word) : Trace := (block_run out inp sp r).1

/-- The trace found is those of the three parts, one after another, with ten rounds on the
frame the entry has made, whose stack pointer is 48 below. -/
example (out inp sp r : Word) : blockLeak out inp sp r =
    (entry_run inp sp).1 ++ ((rounds_run (sp + -48#64) 9).1 ++ (exit_run out inp sp r).1) :=
  rfl

end Examples.ChaCha20.X86
