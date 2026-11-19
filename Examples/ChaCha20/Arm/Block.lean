/-
  Examples.ChaCha20.Arm.Block

  `chacha20_block` of `chacha20.c` on AArch64: the ChaCha20 block function, from sixteen
  32-bit words in memory to sixteen 32-bit words in memory.

  The code makes a frame of 96 bytes, saves four registers in it, copies the input to the
  frame, loads the sixteen words into registers, runs the loop of ten double rounds on the
  registers, stores them to the frame, and adds the input to them, into the output. The two
  loops that copy and add have sixteen rounds each and a counter that is a literal, so they
  are run out: a round is four or five instructions on one cell, and the stepper decides the
  branch. The loop of rounds is `rounds_spec`, proved by induction in
  `Examples.ChaCha20.Arm.Round`, and is used here as a call.

  ## Main results

  * `chacha20_block_spec`: the specification, against `ChaCha20.block`
  * `chacha20_block_correct`: the same, about the machine alone
-/

module

public import Examples.ChaCha20.Arm.Round

public section

namespace Examples.ChaCha20.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-! ## The frame -/

/-- Addition as `BitVec.add_assoc` leaves it: all three types `BitVec 64`. The stepper finds
memory atoms by syntactic equality of addresses, and an address it has folded two offsets
into is written this way. -/
local notation:65 a:65 " +ᵇ " b:66 =>
  @HAdd.hAdd (BitVec 64) (BitVec 64) (BitVec 64) instHAdd a b

/-- Addition as `sub_lit` leaves it, for the stack pointer less a literal. -/
local notation:65 a:65 " +ᵐ " b:66 => @HAdd.hAdd Word (BitVec 64) Word instHAdd a b

/-- The sixteen 32-bit cells of the frame, as memory atoms at the addresses the stepper
computes. -/
theorem frame_cells (sp₀ f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 : Word) :
    (Atom.prop (cellsAt 4 true (sp₀ - 96#64)
      [f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15])).interp =
      Atoms.interp [.mem (sp₀ +ᵐ 18446744073709551520#64) 4 f0 true,
        .mem (sp₀ +ᵇ 18446744073709551524#64) 4 f1 true,
        .mem (sp₀ +ᵇ 18446744073709551528#64) 4 f2 true,
        .mem (sp₀ +ᵇ 18446744073709551532#64) 4 f3 true,
        .mem (sp₀ +ᵇ 18446744073709551536#64) 4 f4 true,
        .mem (sp₀ +ᵇ 18446744073709551540#64) 4 f5 true,
        .mem (sp₀ +ᵇ 18446744073709551544#64) 4 f6 true,
        .mem (sp₀ +ᵇ 18446744073709551548#64) 4 f7 true,
        .mem (sp₀ +ᵇ 18446744073709551552#64) 4 f8 true,
        .mem (sp₀ +ᵇ 18446744073709551556#64) 4 f9 true,
        .mem (sp₀ +ᵇ 18446744073709551560#64) 4 f10 true,
        .mem (sp₀ +ᵇ 18446744073709551564#64) 4 f11 true,
        .mem (sp₀ +ᵇ 18446744073709551568#64) 4 f12 true,
        .mem (sp₀ +ᵇ 18446744073709551572#64) 4 f13 true,
        .mem (sp₀ +ᵇ 18446744073709551576#64) 4 f14 true,
        .mem (sp₀ +ᵇ 18446744073709551580#64) 4 f15 true] := by
  simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil, cellsAt, sub_lit,
    BitVec.reduceNeg, BitVec.add_assoc, BitVec.reduceAdd]

/-- The four 64-bit cells of the frame that hold saved registers, as memory atoms. -/
theorem saved_cells (sp₀ m0 m1 m2 m3 : Word) :
    (Atom.prop (cellsAt 8 true (sp₀ - 32#64) [m0, m1, m2, m3])).interp =
      Atoms.interp [.mem (sp₀ +ᵇ 18446744073709551584#64) 8 m0 true,
        .mem (sp₀ +ᵇ 18446744073709551592#64) 8 m1 true,
        .mem (sp₀ +ᵇ 18446744073709551600#64) 8 m2 true,
        .mem (sp₀ +ᵇ 18446744073709551608#64) 8 m3 true] := by
  simp only [Atom.interp, Atoms.interp_cons, Atoms.interp_nil, cellsAt, sub_lit,
    BitVec.reduceNeg, BitVec.add_assoc, BitVec.reduceAdd]

/-! ## The code -/

/-- **`chacha20_block`** writes the ChaCha20 block function of the sixteen 32-bit words its
second argument points to over the sixteen its first argument points to. It uses 96 bytes
below the stack pointer, which must be a multiple of 16: 64 for a copy of the state, which
it leaves there, and 32 for the registers `x19` to `x22`, which it restores. -/
theorem chacha20_block_spec (out inp r sp₀ : Word) (s : List W32) (os fr sv : List Word)
    (t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 v19 v20 v21 v22 : Word)
    (fn fz fc fv : Bool) (hs : s.length = 16) (hos : os.length = 16) (hfr : fr.length = 16)
    (hsv : sv.length = 4) (hsp : sp₀ &&& 15#64 = 0#64) :
    Triple chacha20_block.program
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out os) :: .prop (cellsAt 4 true (sp₀ - 96#64) fr) ::
        .prop (cellsAt 8 true (sp₀ - 32#64) sv) ::
        [.pc 0x10044#64, .reg x0 out, .reg x1 inp,
        .reg x2 t2, .reg x3 t3, .reg x4 t4, .reg x5 t5, .reg x6 t6, .reg x7 t7, .reg x8 t8,
        .reg x9 t9, .reg x10 t10, .reg x11 t11, .reg x12 t12, .reg x13 t13, .reg x14 t14,
        .reg x15 t15, .reg x16 t16, .reg x17 t17, .reg x18 t18,
        .reg x19 v19, .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg sp sp₀, .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]))
      (Atoms.interp (.prop (cellsAt 4 true inp (s.map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true out ((block s).map (·.zeroExtend 64))) ::
        .prop (cellsAt 4 true (sp₀ - 96#64) ((innerN 10 s).map (·.zeroExtend 64))) ::
        .prop (cellsAt 8 true (sp₀ - 32#64) [v22, v21, v20, v19]) ::
        [.pc r, .reg x0 out, .reg x1 inp,
        .prop (regAny x2), .prop (regAny x3), .prop (regAny x4), .prop (regAny x5),
        .prop (regAny x6), .prop (regAny x7), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .prop (regAny x11), .prop (regAny x12), .prop (regAny x13),
        .prop (regAny x14), .prop (regAny x15), .prop (regAny x16), .prop (regAny x17),
        .prop (regAny x18),
        .reg x19 v19, .reg x20 v20, .reg x21 v21, .reg x22 v22, .reg sp sp₀, .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)])) := by
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
  obtain rfl := List.length_eq_zero_iff.1 hfr15
  obtain ⟨m0, sv0, rfl, hsv0⟩ := exists_cons_of_length hsv
  obtain ⟨m1, sv1, rfl, hsv1⟩ := exists_cons_of_length hsv0
  obtain ⟨m2, sv2, rfl, hsv2⟩ := exists_cons_of_length hsv1
  obtain ⟨m3, sv3, rfl, hsv3⟩ := exists_cons_of_length hsv2
  obtain rfl := List.length_eq_zero_iff.1 hsv3
  rw [block16 _ rfl, map16 _ (innerN 10 _) (by rw [length_innerN]; rfl)]
  simp only [List.map_cons, List.map_nil, List.getD_cons_zero, List.getD_cons_succ]
  braid_unfold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_unfold saved_cells sp₀ _ _ _ _
  -- The frame, the copy of the input (sixteen rounds, run out), and the loads.
  iterate 94 braid_sym_step
  -- The ten double rounds.
  have h := rounds_spec 9 [a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15]
    10#32 v19 v20 v21 v22 false true true false rfl rfl (by decide)
  simp only [List.getD_cons_zero, List.getD_cons_succ, Nat.reduceAdd] at h
  braid_call h
  clear h
  braid_name_reg 19
  braid_name_reg 20
  braid_name_reg 21
  braid_name_reg 22
  -- The stores, the sum with the input (sixteen rounds, run out), and the return.
  braid_sym_run
  simp only [zadd_comm]
  braid_fold cells16 inp _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold cells16 out _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold frame_cells sp₀ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  braid_fold saved_cells sp₀ _ _ _ _
  braid_forget 2
  braid_forget 3
  braid_forget 4
  braid_forget 5
  braid_forget 6
  braid_forget 7
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
  braid_forget_flag 0
  braid_forget_flag 1
  braid_forget_flag 2
  braid_forget_flag 3
  braid_done_perm 34

/-! ## On the machine -/

/-- **`chacha20_block` on the machine.** A running machine whose program holds the words of
`chacha20_block`, with its code loaded and its program counter at the entry, with the
sixteen 32-bit words `s` in memory where `x1` points, sixteen 32-bit cells `os` where `x0`
points, and a stack pointer that is a multiple of 16 with 96 bytes of memory below it (the
sixteen 32-bit cells `fr` and the four 64-bit cells `sv`), the three regions apart from one
another, runs to the address in the link register with the ChaCha20 block function of `s`
where `x0` pointed, `s` still where `x1` pointed, and the stack pointer and the registers
`x19` to `x22` as they were. -/
theorem chacha20_block_correct (prog : Arm64.Program) (st : Arm64.State) (s : List W32)
    (os fr sv : List Word) (hw : prog.hasWords 0x10044#64 chacha20_block_words)
    (hc : prog.CodeLoaded st.mem) (hrun : st.status = .Running) (hpc : st.pc = 0x10044#64)
    (hsp : st.sp &&& 15#64 = 0#64) (hs : s.length = 16) (hos : os.length = 16)
    (hfr : fr.length = 16) (hsv : sv.length = 4)
    (hin : ∀ (i : Nat) (hi : i < s.length),
      HasBytes st (st.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64))
    (hout : ∀ (i : Nat) (hi : i < os.length),
      HasBytes st (st.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) 4 os[i])
    (hframe : ∀ (i : Nat) (hi : i < fr.length),
      HasBytes st (st.sp - 96#64 + BitVec.ofNat 64 (4 * i)) 4 fr[i])
    (hsaved : ∀ (i : Nat) (hi : i < sv.length),
      HasBytes st (st.sp - 32#64 + BitVec.ofNat 64 (8 * i)) 8 sv[i])
    (hio : Apart (st.regs.read 1#5) 64 (st.regs.read 0#5) 64)
    (his : Apart (st.regs.read 1#5) 64 (st.sp - 96#64) 96)
    (hos' : Apart (st.regs.read 0#5) 64 (st.sp - 96#64) 96) :
    ∃ st', Arm64.Steps prog st st' ∧ st'.pc = st.regs.read 30#5 ∧
      (∀ (i : Nat) (hi : i < (block s).length),
        HasBytes st' (st.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) 4
          ((block s)[i].zeroExtend 64)) ∧
      (∀ (i : Nat) (hi : i < s.length),
        HasBytes st' (st.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) 4 (s[i].zeroExtend 64)) ∧
      st'.sp = st.sp ∧ st'.regs.read 19#5 = st.regs.read 19#5 ∧
      st'.regs.read 20#5 = st.regs.read 20#5 ∧ st'.regs.read 21#5 = st.regs.read 21#5 ∧
      st'.regs.read 22#5 = st.regs.read 22#5 := by
  obtain ⟨hio₁, hio₂⟩ := hio
  obtain ⟨his₁, his₂⟩ := his
  obtain ⟨hos₁, hos₂⟩ := hos'
  have hrest : ∀ b ∈ ([.pc 0x10044#64, .reg x0 (st.regs.read 0#5), .reg x1 (st.regs.read 1#5),
      .reg x2 (st.regs.read 2#5), .reg x3 (st.regs.read 3#5), .reg x4 (st.regs.read 4#5),
      .reg x5 (st.regs.read 5#5), .reg x6 (st.regs.read 6#5), .reg x7 (st.regs.read 7#5),
      .reg x8 (st.regs.read 8#5), .reg x9 (st.regs.read 9#5), .reg x10 (st.regs.read 10#5),
      .reg x11 (st.regs.read 11#5), .reg x12 (st.regs.read 12#5), .reg x13 (st.regs.read 13#5),
      .reg x14 (st.regs.read 14#5), .reg x15 (st.regs.read 15#5), .reg x16 (st.regs.read 16#5),
      .reg x17 (st.regs.read 17#5), .reg x18 (st.regs.read 18#5),
      .reg x19 (st.regs.read 19#5), .reg x20 (st.regs.read 20#5),
      .reg x21 (st.regs.read 21#5), .reg x22 (st.regs.read 22#5), .reg sp st.sp,
      .reg lr (st.regs.read 30#5), .flag Flags.n st.pstate.n, .flag Flags.z st.pstate.z,
      .flag Flags.c st.pstate.c, .flag Flags.v st.pstate.v] : Atoms),
      ∀ q n v w', Atom.Disj b (.mem q n v w') := by
    braid_not_mem
  obtain ⟨st', σ', hsteps, hr, hq⟩ := machine_sound_flat chacha20_block_lowered
    (chacha20_block_spec (st.regs.read 0#5) (st.regs.read 1#5) (st.regs.read 30#5) st.sp s os
      fr sv
      (st.regs.read 2#5) (st.regs.read 3#5) (st.regs.read 4#5) (st.regs.read 5#5)
      (st.regs.read 6#5) (st.regs.read 7#5) (st.regs.read 8#5) (st.regs.read 9#5)
      (st.regs.read 10#5) (st.regs.read 11#5) (st.regs.read 12#5) (st.regs.read 13#5)
      (st.regs.read 14#5) (st.regs.read 15#5) (st.regs.read 16#5) (st.regs.read 17#5)
      (st.regs.read 18#5)
      (st.regs.read 19#5) (st.regs.read 20#5) (st.regs.read 21#5) (st.regs.read 22#5)
      st.pstate.n st.pstate.z st.pstate.c st.pstate.v hs hos hfr hsv hsp) hw hc hrun
    (Flat.interp (by braid_flat))
    (List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2
      ⟨cellsAtoms_isPointsTo, List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
        List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp [Atom.IsPointsTo]⟩⟩⟩⟩)
    (pairwise_cells_append (by simp [hs])
      (pairwise_cells_append (by simp [hos])
        (pairwise_cells_append (by simp [hfr])
          (pairwise_cells_append (by simp [hsv])
            (by braid_disj; repeat' apply And.intro
                all_goals decide)
            (disj_cellsAtoms_rest hrest))
          (disj_append
            (cellsAtoms_disj (by rw [hfr]; bv_omega) (by rw [hsv]; bv_omega))
            (disj_cellsAtoms_rest hrest)))
        (disj_append
          (cellsAtoms_disj (by rw [hos]; exact hos₁) (by rw [hfr]; bv_omega))
          (disj_append
            (cellsAtoms_disj (by rw [hos]; bv_omega) (by rw [hsv]; bv_omega))
            (disj_cellsAtoms_rest hrest))))
      (disj_append
        (cellsAtoms_disj (by rw [List.length_map, hs]; exact hio₁) (by rw [hos]; exact hio₂))
        (disj_append
          (cellsAtoms_disj (by rw [List.length_map, hs]; exact his₁) (by rw [hfr]; bv_omega))
          (disj_append
            (cellsAtoms_disj (by rw [List.length_map, hs]; bv_omega) (by rw [hsv]; bv_omega))
            (disj_cellsAtoms_rest hrest)))))
    (List.forall_mem_append.2
      ⟨cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (by simpa using hin i (by simpa using hi)),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (hout i hi),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (hframe i hi),
      List.forall_mem_append.2 ⟨cellsAtoms_sat fun i hi => sat_mem_hasBytes.2 (hsaved i hi),
        by
          simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
            and_true, Atom.sat_reg, Atom.sat_flag, Atom.sat_pc]
          repeat' apply And.intro
          all_goals first | exact hpc | rfl⟩⟩⟩⟩)
  refine ⟨st', hsteps, ?_, fun i hi => ?_, fun i hi => ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · have hc := fun x => cell_of_holds (k := 4) (p := st.regs.read 0#5)
      (vs := (block s).map (·.zeroExtend 64)) hq (by braid_at) i (by simpa using hi) (x := x)
    have h := hr.hasBytes (a := st.regs.read 0#5 + BitVec.ofNat 64 (4 * i)) (n := 4) hc
    simpa using h
  · have hc := fun x => cell_of_holds (k := 4) (p := st.regs.read 1#5)
      (vs := s.map (·.zeroExtend 64)) hq (by braid_at) i (by simpa using hi) (x := x)
    have h := hr.hasBytes (a := st.regs.read 1#5 + BitVec.ofNat 64 (4 * i)) (n := 4) hc
    simpa using h
  · rw [← hr.sp]; exact Atoms.reg_of_holds (r := 31) hq (by braid_at)
  · rw [← hr.readReg (i := 19#5) (by decide)]
    exact Atoms.reg_of_holds (r := 19) hq (by braid_at)
  · rw [← hr.readReg (i := 20#5) (by decide)]
    exact Atoms.reg_of_holds (r := 20) hq (by braid_at)
  · rw [← hr.readReg (i := 21#5) (by decide)]
    exact Atoms.reg_of_holds (r := 21) hq (by braid_at)
  · rw [← hr.readReg (i := 22#5) (by decide)]
    exact Atoms.reg_of_holds (r := 22) hq (by braid_at)

end Examples.ChaCha20.Arm
