/-
  Examples.Mem.Arm.EqualCt

  `equal_bytes_ct` of `mem.c` on AArch64: comparing bytes in a time that depends on their
  number alone.

  The code reads every byte and branches on none of them: it gathers the XOR of each pair, by
  OR, in `w8`, and compares `w8` with zero after the loop. The loop is proved by induction on
  the list of bytes, with the loop's specification as the invariant: `x8` holds a byte `d`
  gathered so far, and the result is one exactly when `orDiff d as bs`, the byte gathered at
  the end, is zero. That this is so exactly when the lists are the same is `orDiff_zero`. As
  for `equal_bytes`, memory is a set of single bytes (`cellsOn`), so the two regions may
  overlap.

  ## Main results

  * `equal_bytes_ct_spec`: the specification
  * `equal_bytes_ct_correct`: the same, about the machine alone
-/

module

public import Examples.Mem.Arm.Proofs
public import Examples.Mem.EqualCt
import Braid.BV

public section

namespace Examples.Mem.Arm

open Braid Examples Examples.Mem Lowering.Arm Lowering.Arm.Regs

/-- Forget what `equal_bytes_ct` leaves in the registers it uses and in the flags. -/
local macro "equal_bytes_ct_forget" : tactic =>
  `(tactic| (braid_forget 1; braid_forget 2; braid_forget 8; braid_forget 9; braid_forget 10
             braid_forget_flag 0; braid_forget_flag 1; braid_forget_flag 2
             braid_forget_flag 3))

/-- Run the two loads of a round of `equal_bytes_ct`, and the `subs` between them, from the
bytes at `pa` and at `pb` of a set of bytes. -/
local macro "equal_bytes_ct_loads " f:term ", " ha:term ", " hb:term : tactic =>
  `(tactic| (braid_unfold cellsOn_open $f $ha
             braid_sym_step
             braid_fold cellsOn_open $f $ha
             braid_sym_step
             braid_unfold cellsOn_open $f $hb
             braid_sym_step
             braid_fold cellsOn_open $f $hb))

/-- The accumulator after a round: the byte gathered so far, with the XOR of the two bytes
of the round ORed into it. -/
theorem acc_round (a b d : BitVec 8) :
    BitVec.setWidth 64 (BitVec.setWidth 32
        (BitVec.setWidth 64 (BitVec.setWidth 32 (BitVec.setWidth 64 b)) ^^^
          BitVec.setWidth 64 (BitVec.setWidth 32 (BitVec.setWidth 64 a)))) |||
      BitVec.setWidth 64 (BitVec.setWidth 32 (BitVec.setWidth 64 d)) =
    BitVec.zeroExtend 64 (d ||| (a ^^^ b)) := by
  bv_auto

/-- What `cmp w8, #0` and `cset w0, eq` leave in `x0` from the gathered byte. -/
theorem result_eq (x : BitVec 8) :
    (if ¬(BitVec.setWidth 64 (BitVec.setWidth 32 (BitVec.zeroExtend 64 x)) == 0#64) = true
      then 0#64 else 1#64) = if x = 0#8 then 1#64 else 0#64 := by
  bv_auto

/-- The loop of `equal_bytes_ct`: gather into the byte `d` of `x8` the XOR of each of the `n`
pairs of bytes from `pa` and from `pb`, which are read through one set of bytes, and return
one if the byte gathered is zero, and zero otherwise. -/
theorem equal_bytes_ct_loop (f : Word → BitVec 8) (addrs : List Word) (r : Word) :
    ∀ (as bs : List (BitVec 8)) (a b d : BitVec 8) (pa pb n t9 t10 : Word)
    (fn fz fc fv : Bool), bs.length = as.length → n = BitVec.ofNat 64 (as.length + 1) →
    as.length + 1 < 2 ^ 64 → Reads f addrs pa (a :: as) → Reads f addrs pb (b :: bs) →
    Triple equal_bytes_ct.program
      (Atoms.interp [.pc 0x10058#64, .reg x0 pa, .reg x1 pb, .reg x2 n,
        .reg x8 (d.zeroExtend 64), .reg x9 t9, .reg x10 t10, .prop (cellsOn f addrs),
        .reg lr r, .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r,
        .reg x0 (if orDiff d (a :: as) (b :: bs) = 0#8 then 1#64 else 0#64),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .prop (cellsOn f addrs), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  intro as
  induction as with
  | nil =>
    intro bs a b d pa pb n t9 t10 fn fz fc fv hlen he hl hA hB
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    have he' : n = 1#64 := by simpa using he
    subst hbs he'
    obtain ⟨ha, rfl, -⟩ := hA
    obtain ⟨hb, rfl, -⟩ := hB
    equal_bytes_ct_loads f, ha, hb
    braid_sym_run
    rw [acc_round, result_eq, orDiff_cons, orDiff_nil]
    equal_bytes_ct_forget
    braid_done
  | cons c cs ih =>
    intro bs a b d pa pb n t9 t10 fn fz fc fv hlen he hl hA hB
    obtain ⟨e, es, rfl⟩ : ∃ e es, bs = e :: es := by
      cases bs with
      | nil => simp at hlen
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at he hl hlen
    obtain ⟨ha, rfl, hra⟩ := hA
    obtain ⟨hb, rfl, hrb⟩ := hB
    equal_bytes_ct_loads f, ha, hb
    braid_sym_run
    · simp only [acc_round, orDiff_cons d]
      braid_call ih es c e _ (pa + 1#64) (pb + 1#64) (n + 0xffffffffffffffff#64) _ _ _ _ _ _
        (by omega) (by rw [he]; bv_omega) (by omega) hra hrb
      braid_done
    · exfalso
      have : n ≠ 1#64 := by rw [he]; bv_omega
      exact this hbr

/-- `equal_bytes_ct` returns one if the `n` bytes its first argument points to are those its
second argument points to, and zero otherwise. The bytes are read through one set of bytes,
so the two regions may overlap. -/
theorem equal_bytes_ct_spec (f : Word → BitVec 8) (addrs : List Word)
    (pa pb r t8 t9 t10 : Word) (as bs : List (BitVec 8)) (fn fz fc fv : Bool)
    (hlen : bs.length = as.length) (hl : as.length < 2 ^ 64) (hA : Reads f addrs pa as)
    (hB : Reads f addrs pb bs) :
    Triple equal_bytes_ct.program
      (Atoms.interp [.pc 0x10050#64, .reg x0 pa, .reg x1 pb,
        .reg x2 (BitVec.ofNat 64 as.length), .reg x8 t8, .reg x9 t9, .reg x10 t10,
        .prop (cellsOn f addrs), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (if as = bs then 1#64 else 0#64),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .prop (cellsOn f addrs), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  cases as with
  | nil =>
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    subst hbs
    simp only [List.length_nil, ↓reduceIte]
    braid_sym_run
    equal_bytes_ct_forget
    braid_done
  | cons a as =>
    obtain ⟨b, bs', rfl⟩ : ∃ b bs', bs = b :: bs' := by
      cases bs with
      | nil => simp at hlen
      | cons x y => exact ⟨x, y, rfl⟩
    have e : (if a :: as = b :: bs' then 1#64 else 0#64) =
        if orDiff 0#8 (a :: as) (b :: bs') = 0#8 then 1#64 else 0#64 := by
      simp only [orDiff_zero _ _ hlen]
    rw [e]
    simp only [List.length_cons] at hl hlen ⊢
    braid_sym_run
    · braid_call equal_bytes_ct_loop f addrs r as bs' a b 0#8 pa pb _ t9 t10 fn fz fc fv
        (by omega) rfl hl hA hB
      braid_done
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr

/-! ## On the machine -/

/-- **`equal_bytes_ct` on the machine.** A running machine whose program holds the words of
`equal_bytes_ct`, with its code loaded and its program counter at the entry, with the bytes
`as` in memory where `x0` points, as many bytes `bs` where `x1` points, and their number,
below `2 ^ 64`, in `x2`, runs to the address in the link register with one in `x0` if `as`
and `bs` are the same, and zero otherwise. The two regions may overlap. -/
theorem equal_bytes_ct_correct (prog : Arm64.Program) (s : Arm64.State)
    (as bs : List (BitVec 8)) (hw : prog.hasWords 0x10050#64 equal_bytes_ct_words)
    (hc : prog.CodeLoaded s.mem) (hrun : s.status = .Running) (hpc : s.pc = 0x10050#64)
    (hlen : bs.length = as.length) (hl : as.length < 2 ^ 64)
    (hn : s.regs.read 2#5 = BitVec.ofNat 64 as.length)
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes s (s.regs.read 0#5 + BitVec.ofNat 64 i) 1 (as[i].zeroExtend 64))
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.regs.read 1#5 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64)) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      s'.regs.read 0#5 = if as = bs then 1#64 else 0#64 := by
  let f : Word → BitVec 8 := fun x => s.mem.read8 x
  let addrs : List Word :=
    dedup (addrsFrom (s.regs.read 0#5) as.length ++ addrsFrom (s.regs.read 1#5) bs.length)
  have hA : Reads f addrs (s.regs.read 0#5) as := reads_of_forall fun i hi =>
    ⟨mem_dedup.2 (List.mem_append_left _ (mem_addrsFrom.2 ⟨i, hi, rfl⟩)),
      read8_of_hasBytes (ha i hi)⟩
  have hB : Reads f addrs (s.regs.read 1#5) bs := reads_of_forall fun i hi =>
    ⟨mem_dedup.2 (List.mem_append_right _ (mem_addrsFrom.2 ⟨i, hi, rfl⟩)),
      read8_of_hasBytes (hb i hi)⟩
  have hsat : ∀ x ∈ addrs, (Atom.mem x 1 ((f x).zeroExtend 64) true).sat (abs s) := by
    intro x hx
    refine sat_mem_hasBytes.2 ?_
    rcases List.mem_append.1 (mem_dedup.1 hx) with h | h
    · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
      exact hasBytes_read8 (ha i hi)
    · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
      exact hasBytes_read8 (hb i hi)
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat equal_bytes_ct_lowered
    (equal_bytes_ct_spec f addrs (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5)
      (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5) as bs s.pstate.n s.pstate.z
      s.pstate.c s.pstate.v hlen hl hA hB) hw hc hrun
    (flat := [.pc 0x10050#64, .reg x0 (s.regs.read 0#5), .reg x1 (s.regs.read 1#5),
      .reg x2 (BitVec.ofNat 64 as.length), .reg x8 (s.regs.read 8#5),
      .reg x9 (s.regs.read 9#5), .reg x10 (s.regs.read 10#5)] ++ cellsOnAtoms f addrs ++
      [.reg lr (s.regs.read 30#5), .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z,
        .flag Flags.c s.pstate.c, .flag Flags.v s.pstate.v])
    (by rw [cellsOn_eq_interp]
        exact Atoms.interp_flatten [.pc 0x10050#64, .reg x0 (s.regs.read 0#5),
          .reg x1 (s.regs.read 1#5), .reg x2 (BitVec.ofNat 64 as.length),
          .reg x8 (s.regs.read 8#5), .reg x9 (s.regs.read 9#5),
          .reg x10 (s.regs.read 10#5)] _ _)
    (Atoms.forall_flat (by simp [Atom.IsPointsTo]) cellsOnAtoms_isPointsTo)
    (Atoms.pairwise_flat (by braid_disj) (cellsOnAtoms_pairwise (dedup_pairwise _))
      (by
        braid_disj_array
        all_goals first
          | exact disj_reg_cellsOnAtoms | exact disj_pc_cellsOnAtoms
          | exact disj_flag_cellsOnAtoms))
    (Atoms.forall_flat
      (by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
        Flags.v, hpc, hn])
      (cellsOnAtoms_sat hsat))
  refine ⟨s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.readReg (i := 0#5) (by decide)]
    exact Atoms.reg_of_holds (r := 0) hq (by braid_at)

end Examples.Mem.Arm
