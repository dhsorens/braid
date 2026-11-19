/-
  Examples.ChaCha20.O2.RiscV.Block

  `chacha20_block` of `chacha20.c` on RISC-V, compiled at `-O2`: the ChaCha20 block function,
  from sixteen 32-bit words in memory to sixteen 32-bit words in memory.

  At `-O2` the code keeps no copy of the state in its frame. It makes a frame of 48 bytes,
  saves five registers in it, loads the sixteen words of the input into registers, runs the
  loop of ten double rounds on the registers, and then, word by word, loads the input again,
  adds the register and stores the sum to the output: the two loops that `-O1` ran over
  memory are gone, one into the loads and one unrolled. The proof is in three parts, as at
  `-O1`:

  * `block_head_spec`, to the head of the loop of rounds: 23 instructions in a line.
  * `rounds_spec`, the loop of rounds, by induction in `Examples.ChaCha20.O2.RiscV.Round`.
  * `block_tail_spec`, from the end of the loop of rounds: sixteen sums, and the return.

  The specification differs from that of `-O1` in what the code touches below the stack
  pointer: 40 bytes for the saved registers, and no copy of the state. The lemmas about the
  frame and about low halves that still apply (`saved_cells`, `low_add_comm`, `low_rounds`)
  are those of `Examples.ChaCha20.RiscV.Block`, imported and not repeated.

  ## Main results

  * `chacha20_block_spec`: the specification, against `ChaCha20.block`
  * `chacha20_block_correct`: the same, about the machine alone
-/

module

public import Examples.ChaCha20.O2.RiscV.Round
public import Examples.ChaCha20.RiscV.Block

public section

namespace Examples.ChaCha20.O2.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64
open Examples.ChaCha20.RiscV (innerNW length_innerNW low_sext cells16_low saved_cells
  low_add_comm low_rounds hasBytes_of_mem Apart)

/-! ## The code -/

/-- **The head of `chacha20_block`**, to the head of the loop of rounds: the frame is made,
five registers are saved in it, and the sixteen words of the input are loaded, sign-extended,
into the registers of the state, with the count of rounds, ten, in `a2`. -/
theorem block_head_spec (inp sp₀ : Word) (s : List W32) (sv : List Word)
    (u5 u6 u7 v8 v9 u12 u13 u14 u15 u16 u17 v18 v19 v20 u28 u29 u30 u31 : Word)
    (hs : s.length = 16) (hsv : sv.length = 5)
    (hsp : sp₀ &&& 7#64 = 0#64) (hinp : inp &&& 3#64 = 0#64) :
    Triple chacha20_block.program
      (Atoms.interp [.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))),
        .prop (cellsAt 8 true (sp₀ - 40#64) sv),
        .pc 0x10074#64, .reg a1 inp, .reg a2 u12, .reg a3 u13, .reg a4 u14,
        .reg a5 u15, .reg a6 u16, .reg a7 u17, .reg t0 u5, .reg t1 u6, .reg t2 u7,
        .reg t3 u28, .reg t4 u29, .reg t5 u30, .reg t6 u31, .reg s0 v8, .reg s1 v9,
        .reg s2 v18, .reg s3 v19, .reg s4 v20, .reg sp sp₀])
      (Atoms.interp [.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))),
        .prop (cellsAt 8 true (sp₀ - 40#64) [v20, v19, v18, v9, v8]),
        .pc 0x100d0#64, .reg a1 inp, .reg a2 10#64,
        .reg s0 ((s.map (BitVec.signExtend 64)).getD 0 0),
        .reg s1 ((s.map (BitVec.signExtend 64)).getD 1 0),
        .reg s3 ((s.map (BitVec.signExtend 64)).getD 2 0),
        .reg s2 ((s.map (BitVec.signExtend 64)).getD 3 0),
        .reg t6 ((s.map (BitVec.signExtend 64)).getD 4 0),
        .reg t3 ((s.map (BitVec.signExtend 64)).getD 5 0),
        .reg t4 ((s.map (BitVec.signExtend 64)).getD 6 0),
        .reg t5 ((s.map (BitVec.signExtend 64)).getD 7 0),
        .reg t2 ((s.map (BitVec.signExtend 64)).getD 8 0),
        .reg a6 ((s.map (BitVec.signExtend 64)).getD 9 0),
        .reg a5 ((s.map (BitVec.signExtend 64)).getD 10 0),
        .reg a4 ((s.map (BitVec.signExtend 64)).getD 11 0),
        .reg a7 ((s.map (BitVec.signExtend 64)).getD 12 0),
        .reg t0 ((s.map (BitVec.signExtend 64)).getD 13 0),
        .reg t1 ((s.map (BitVec.signExtend 64)).getD 14 0),
        .reg a3 ((s.map (BitVec.signExtend 64)).getD 15 0),
        .reg s4 v20, .reg sp (sp₀ - 48#64)]) := by
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
  obtain ⟨m0, sv0, rfl, hsv0⟩ := exists_cons_of_length hsv
  obtain ⟨m1, sv1, rfl, hsv1⟩ := exists_cons_of_length hsv0
  obtain ⟨m2, sv2, rfl, hsv2⟩ := exists_cons_of_length hsv1
  obtain ⟨m3, sv3, rfl, hsv3⟩ := exists_cons_of_length hsv2
  obtain ⟨m4, sv4, rfl, hsv4⟩ := exists_cons_of_length hsv3
  obtain rfl := List.length_eq_zero_iff.1 hsv4
  simp only [List.map_cons, List.map_nil, List.getD_cons_zero, List.getD_cons_succ]
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold saved_cells sp₀ _ _ _ _ _
  -- The frame; the loads.
  iterate 23 braid_sym_step
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold saved_cells sp₀ _ _ _ _ _
  braid_done_perm 23

/-- **The tail of `chacha20_block`**, from the end of the loop of rounds: each word of the
input is loaded again and added to its register, and the low half of the sum is stored to
the output; the five saved registers are restored, and the frame is dropped. -/
theorem block_tail_spec (out inp r sp₀ : Word) (s : List W32) (os X : List Word)
    (m0 m1 m2 m3 m4 u12 u20 : Word)
    (hs : s.length = 16) (hos : os.length = 16) (hX : X.length = 16)
    (hsp : sp₀ &&& 7#64 = 0#64) (hinp : inp &&& 3#64 = 0#64) (hout : out &&& 3#64 = 0#64) :
    Triple chacha20_block.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) ::
        .prop (cellsAt 8 true (sp₀ - 40#64) [m0, m1, m2, m3, m4]) ::
        [.pc 0x10358#64, .reg a0 out, .reg a1 inp, .reg a2 u12,
        .reg s0 (X.getD 0 0), .reg s1 (X.getD 1 0), .reg s3 (X.getD 2 0), .reg s2 (X.getD 3 0),
        .reg t6 (X.getD 4 0), .reg t3 (X.getD 5 0), .reg t4 (X.getD 6 0), .reg t5 (X.getD 7 0),
        .reg t2 (X.getD 8 0), .reg a6 (X.getD 9 0), .reg a5 (X.getD 10 0), .reg a4 (X.getD 11 0),
        .reg a7 (X.getD 12 0), .reg t0 (X.getD 13 0), .reg t1 (X.getD 14 0),
        .reg a3 (X.getD 15 0),
        .reg s4 u20, .reg sp (sp₀ - 48#64), .reg ra r]))
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out
          ((List.zipWith (· + ·) (X.map (BitVec.setWidth 32)) s).map (·.zeroExtend 64))) ::
        .prop (cellsAt 8 true (sp₀ - 40#64) [m0, m1, m2, m3, m4]) ::
        [.pc (r &&& ~~~1#64),
        .prop (regAny a0), .prop (regAny a1), .prop (regAny a2), .prop (regAny a3),
        .prop (regAny a4), .prop (regAny a5), .prop (regAny a6), .prop (regAny a7),
        .prop (regAny t0), .prop (regAny t1), .prop (regAny t2), .prop (regAny t3),
        .prop (regAny t4), .prop (regAny t5), .prop (regAny t6),
        .reg s0 m4, .reg s1 m3, .reg s2 m2, .reg s3 m1, .reg s4 m0, .reg sp sp₀,
        .reg ra r])) := by
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
  obtain ⟨x0, X0, rfl, hX0⟩ := exists_cons_of_length hX
  obtain ⟨x1, X1, rfl, hX1⟩ := exists_cons_of_length hX0
  obtain ⟨x2, X2, rfl, hX2⟩ := exists_cons_of_length hX1
  obtain ⟨x3, X3, rfl, hX3⟩ := exists_cons_of_length hX2
  obtain ⟨x4, X4, rfl, hX4⟩ := exists_cons_of_length hX3
  obtain ⟨x5, X5, rfl, hX5⟩ := exists_cons_of_length hX4
  obtain ⟨x6, X6, rfl, hX6⟩ := exists_cons_of_length hX5
  obtain ⟨x7, X7, rfl, hX7⟩ := exists_cons_of_length hX6
  obtain ⟨x8, X8, rfl, hX8⟩ := exists_cons_of_length hX7
  obtain ⟨x9, X9, rfl, hX9⟩ := exists_cons_of_length hX8
  obtain ⟨x10, X10, rfl, hX10⟩ := exists_cons_of_length hX9
  obtain ⟨x11, X11, rfl, hX11⟩ := exists_cons_of_length hX10
  obtain ⟨x12, X12, rfl, hX12⟩ := exists_cons_of_length hX11
  obtain ⟨x13, X13, rfl, hX13⟩ := exists_cons_of_length hX12
  obtain ⟨x14, X14, rfl, hX14⟩ := exists_cons_of_length hX13
  obtain ⟨x15, X15, rfl, hX15⟩ := exists_cons_of_length hX14
  obtain rfl := List.length_eq_zero_iff.1 hX15
  simp only [List.map_cons, List.map_nil, List.zipWith_cons_cons, List.zipWith_nil_left,
    List.getD_cons_zero, List.getD_cons_succ]
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold saved_cells sp₀ _ _ _ _ _
  -- The sums with the input, sixteen of them; the return.
  braid_sym_run
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold cells16_low out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold saved_cells sp₀ _ _ _ _ _
  simp only [↓ low_add_comm, low_sext]
  braid_forget 10
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
  braid_forget 29
  braid_forget 30
  braid_forget 31
  braid_done_perm 26

/-- **`chacha20_block`** writes the ChaCha20 block function of the sixteen 32-bit words its
second argument points to over the sixteen its first argument points to; both arguments must
be multiples of 4. It uses 40 bytes below the stack pointer, which must be a multiple of 8,
for the registers `s0` to `s4`, which it restores. -/
theorem chacha20_block_spec (out inp r sp₀ : Word) (s : List W32) (os sv : List Word)
    (u5 u6 u7 v8 v9 u12 u13 u14 u15 u16 u17 v18 v19 v20 u28 u29 u30 u31 : Word)
    (hs : s.length = 16) (hos : os.length = 16) (hsv : sv.length = 5)
    (hsp : sp₀ &&& 7#64 = 0#64) (hinp : inp &&& 3#64 = 0#64) (hout : out &&& 3#64 = 0#64) :
    Triple chacha20_block.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) ::
        .prop (cellsAt 8 true (sp₀ - 40#64) sv) ::
        [.pc 0x10074#64, .reg a0 out, .reg a1 inp, .reg a2 u12, .reg a3 u13, .reg a4 u14,
        .reg a5 u15, .reg a6 u16, .reg a7 u17, .reg t0 u5, .reg t1 u6, .reg t2 u7,
        .reg t3 u28, .reg t4 u29, .reg t5 u30, .reg t6 u31, .reg s0 v8, .reg s1 v9,
        .reg s2 v18, .reg s3 v19, .reg s4 v20, .reg sp sp₀, .reg ra r]))
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out ((block s).map (·.zeroExtend 64))) ::
        .prop (cellsAt 8 true (sp₀ - 40#64) [v20, v19, v18, v9, v8]) ::
        [.pc (r &&& ~~~1#64),
        .prop (regAny a0), .prop (regAny a1), .prop (regAny a2), .prop (regAny a3),
        .prop (regAny a4), .prop (regAny a5), .prop (regAny a6), .prop (regAny a7),
        .prop (regAny t0), .prop (regAny t1), .prop (regAny t2), .prop (regAny t3),
        .prop (regAny t4), .prop (regAny t5), .prop (regAny t6),
        .reg s0 v8, .reg s1 v9, .reg s2 v18, .reg s3 v19, .reg s4 v20, .reg sp sp₀,
        .reg ra r])) := by
  rw [block]
  braid_call block_head_spec inp sp₀ s sv u5 u6 u7 v8 v9 u12 u13 u14 u15 u16 u17 v18 v19 v20
    u28 u29 u30 u31 hs hsv hsp hinp
  -- The ten double rounds.
  have h := rounds_spec 9 (s.map (BitVec.signExtend 64)) 10#32 v20 rfl (by decide)
  simp only [Nat.reduceAdd, show BitVec.signExtend 64 10#32 = 10#64 from by decide] at h
  braid_call h
  clear h
  braid_name_reg 20
  rename_i w20
  have h := block_tail_spec out inp r sp₀ s os
    (innerNW 10 (s.map (BitVec.signExtend 64))) v20 v19 v18 v9 v8 0#64 w20 hs hos
    (length_innerNW 10 _ (by rw [List.length_map, hs])) hsp hinp hout
  rw [low_rounds s hs] at h
  braid_call h
  braid_done

/-! ## On the machine -/

/-- **`chacha20_block` on the machine.** A machine that holds the code of `chacha20_block`
and is at its entry, with the sixteen 32-bit words `s` in valid memory where `a1` points,
sixteen 32-bit cells `os` where `a0` points, both pointers multiples of 4, and a stack
pointer that is a multiple of 8 with 40 bytes of valid memory below it (the five 64-bit
cells `sv`), the three regions apart from one another, runs to the return address with the
ChaCha20 block function of `s` where `a0` pointed, `s` still where `a1` pointed, and the
stack pointer and the registers `s0` to `s4` as they were. -/
theorem chacha20_block_correct (st : MachineState) (s : List W32) (os sv : List Word)
    (hcode : ∀ p ∈ chacha20_block_code, st.code p.1 = some p.2) (hpc : st.pc = 0x10074#64)
    (hsp : st.getReg .x2 &&& 7#64 = 0#64) (hinp : st.getReg .x11 &&& 3#64 = 0#64)
    (hout : st.getReg .x10 &&& 3#64 = 0#64) (hs : s.length = 16) (hos : os.length = 16)
    (hsv : sv.length = 5)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes st (st.getReg .x11 + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hout' : ∀ (i : Nat) (hi : i < os.length),
      HasBytes st (st.getReg .x10 + BitVec.ofNat 64 (4 * i)) 4 os[i])
    (hsaved : ∀ (i : Nat) (hi : i < sv.length),
      HasBytes st (st.getReg .x2 - 40#64 + BitVec.ofNat 64 (8 * i)) 8 sv[i])
    (hio : Apart (st.getReg .x11) 64 (st.getReg .x10) 64)
    (his : Apart (st.getReg .x11) 64 (st.getReg .x2 - 40#64) 40)
    (hos' : Apart (st.getReg .x10) 64 (st.getReg .x2 - 40#64) 40) :
    ∃ n st', stepN n st = some st' ∧ st'.pc = st.getReg .x1 &&& ~~~1#64 ∧
      (∀ (i : Nat) (hi : i < (block s).length),
        HasBytes st' (st.getReg .x10 + BitVec.ofNat 64 (4 * i)) 4
          ((block s)[i].zeroExtend 64)) ∧
      (∀ (i : Nat) (hi : i < s.length),
        HasBytes st' (st.getReg .x11 + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64)) ∧
      st'.getReg .x2 = st.getReg .x2 ∧ st'.getReg .x8 = st.getReg .x8 ∧
      st'.getReg .x9 = st.getReg .x9 ∧ st'.getReg .x18 = st.getReg .x18 ∧
      st'.getReg .x19 = st.getReg .x19 ∧ st'.getReg .x20 = st.getReg .x20 := by
  obtain ⟨hio₁, hio₂⟩ := hio
  obtain ⟨his₁, his₂⟩ := his
  obtain ⟨hos₁, hos₂⟩ := hos'
  have hrest : ∀ b ∈ ([.pc 0x10074#64, .reg a0 (st.getReg .x10), .reg a1 (st.getReg .x11),
      .reg a2 (st.getReg .x12), .reg a3 (st.getReg .x13), .reg a4 (st.getReg .x14),
      .reg a5 (st.getReg .x15), .reg a6 (st.getReg .x16), .reg a7 (st.getReg .x17),
      .reg t0 (st.getReg .x5), .reg t1 (st.getReg .x6), .reg t2 (st.getReg .x7),
      .reg t3 (st.getReg .x28), .reg t4 (st.getReg .x29), .reg t5 (st.getReg .x30),
      .reg t6 (st.getReg .x31), .reg s0 (st.getReg .x8), .reg s1 (st.getReg .x9),
      .reg s2 (st.getReg .x18), .reg s3 (st.getReg .x19), .reg s4 (st.getReg .x20),
      .reg sp (st.getReg .x2), .reg ra (st.getReg .x1)] : Atoms),
      ∀ q n v w', Atom.Disj b (.mem q n v w') := by
    braid_not_mem
  obtain ⟨n, st', σ', hn, hr, hq⟩ := machine_sound_flat chacha20_block_lowered
    (chacha20_block_spec (st.getReg .x10) (st.getReg .x11) (st.getReg .x1) (st.getReg .x2) s os
      sv (st.getReg .x5) (st.getReg .x6) (st.getReg .x7) (st.getReg .x8) (st.getReg .x9)
      (st.getReg .x12) (st.getReg .x13) (st.getReg .x14) (st.getReg .x15) (st.getReg .x16)
      (st.getReg .x17) (st.getReg .x18) (st.getReg .x19) (st.getReg .x20) (st.getReg .x28)
      (st.getReg .x29) (st.getReg .x30) (st.getReg .x31) hs hos hsv hsp hinp hout) hcode
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2
      ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
        by simp [Atom.IsPointsTo]⟩⟩⟩)
    (pairwise_cells_append (by simp [hs])
      (pairwise_cells_append (by simp [hos])
        (pairwise_cells_append (by simp [hsv])
          (by braid_disj; repeat' apply And.intro
              all_goals decide)
          (disj_cellsAtoms_rest hrest))
        (disj_append
          (cellsAtoms_disj (by rw [hos]; exact hos₁) (by rw [hsv]; exact hos₂))
          (disj_cellsAtoms_rest hrest)))
      (disj_append
        (cellsAtoms_disj (by rw [List.length_map, hs]; exact hio₁) (by rw [hos]; exact hio₂))
        (disj_append
          (cellsAtoms_disj (by rw [List.length_map, hs]; exact his₁) (by rw [hsv]; exact his₂))
          (disj_cellsAtoms_rest hrest))))
    (List.forall_mem_append.2
      ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (by simpa using hin i (by simpa using hi)),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (hout' i hi),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_abs.2 (hsaved i hi),
        by
          simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
            and_true, Atom.sat_reg, Atom.sat_pc]
          repeat' apply And.intro
          all_goals first | exact hpc | rfl⟩⟩⟩)
  refine ⟨n, st', hn, ?_, fun i hi => ?_, fun i hi => ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · have hc := fun x => cell_of_holds (k := 4) (p := st.getReg .x10)
      (vs := (block s).map (·.zeroExtend 64)) hq (by braid_at) i (by simpa using hi) (x := x)
    have h := hasBytes_of_mem hr (a := st.getReg .x10 + BitVec.ofNat 64 (4 * i)) (n := 4) hc
    simpa using h
  · have hc := fun x => cell_of_holds (k := 4) (p := st.getReg .x11)
      (vs := s.map (·.zeroExtend 64)) hq (by braid_at) i (by simpa using hi) (x := x)
    have h := hasBytes_of_mem hr (a := st.getReg .x11 + BitVec.ofNat 64 (4 * i)) (n := 4) hc
    simpa using h
  · rw [← hr.getReg (r := .x2) (by decide)]; exact Atoms.reg_of_holds (r := 2) hq (by braid_at)
  · rw [← hr.getReg (r := .x8) (by decide)]; exact Atoms.reg_of_holds (r := 8) hq (by braid_at)
  · rw [← hr.getReg (r := .x9) (by decide)]; exact Atoms.reg_of_holds (r := 9) hq (by braid_at)
  · rw [← hr.getReg (r := .x18) (by decide)]
    exact Atoms.reg_of_holds (r := 18) hq (by braid_at)
  · rw [← hr.getReg (r := .x19) (by decide)]
    exact Atoms.reg_of_holds (r := 19) hq (by braid_at)
  · rw [← hr.getReg (r := .x20) (by decide)]
    exact Atoms.reg_of_holds (r := 20) hq (by braid_at)

end Examples.ChaCha20.O2.RiscV
