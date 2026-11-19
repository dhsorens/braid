/-
  Examples.Mem.Arm.Proofs

  `mem.c` on AArch64: copying bytes and comparing bytes, the first rung of the scaling
  ladder (`docs/Scaling.md`).

  Both loops are proved by induction on the list of bytes, with the loop's specification as
  the invariant, since the number of rounds is not fixed. `equal_bytes` only reads memory, so
  its two regions may overlap: its memory is a set of single bytes (`cellsOn`), opened at the
  address of each load.

  ## Main results

  * `copy_bytes_spec`, `equal_bytes_spec`: the specifications
  * `copy_bytes_correct`, `equal_bytes_correct`: the same, about the machine alone
-/

module

public import Examples.Mem.Arm.Image
public import Examples.Mem.Common
public import Examples.ArmMachine
public import Examples.Spec

public section

namespace Examples.Mem.Arm

open Braid Examples Examples.Mem Lowering.Arm Lowering.Arm.Regs

/-- The loop of `copy_bytes`: copy the `n` bytes from `ps` to `pd`. -/
theorem copy_bytes_loop (r : Word) : ∀ (ss ds : List (BitVec 8)) (s d : BitVec 8)
    (pd ps n t : Word) (fn fz fc fv : Bool), ds.length = ss.length →
    n = BitVec.ofNat 64 (ss.length + 1) → ss.length + 1 < 2 ^ 64 →
    Triple copy_bytes.program
      (Atoms.interp [.pc 0x10004#64, .reg x0 pd, .reg x1 ps, .reg x2 n, .reg x8 t,
        .prop (bytesAt ps (s :: ss)), .prop (bytesAt pd (d :: ds)), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .prop (regAny x0), .prop (regAny x1), .reg x2 0#64,
        .prop (regAny x8), .prop (bytesAt ps (s :: ss)), .prop (bytesAt pd (s :: ss)),
        .reg lr r, .prop (flagAny Flags.n), .prop (flagAny Flags.z),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) := by
  intro ss
  induction ss with
  | nil =>
    intro ds s d pd ps n t fn fz fc fv hlen he hb
    have hds : ds = [] := List.length_eq_zero_iff.1 hlen
    have he' : n = 1#64 := by simpa using he
    subst hds he'
    braid_unfold bytesAt_cons ps s []
    braid_unfold bytesAt_cons pd d []
    braid_sym_run
    braid_fold bytesAt_cons ps s []
    braid_fold bytesAt_cons pd s []
    braid_forget 0
    braid_forget 1
    braid_forget 8
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    braid_done
  | cons c cs ih =>
    intro ds s d pd ps n t fn fz fc fv hlen he hb
    obtain ⟨d', ds', rfl⟩ : ∃ d' ds', ds = d' :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at he hb hlen
    braid_unfold bytesAt_cons ps s (c :: cs)
    braid_unfold bytesAt_cons pd d (d' :: ds')
    braid_sym_run
    · braid_call ih ds' c d' (pd + 1#64) (ps + 1#64) (n + 0xffffffffffffffff#64) _ _ _ _ _
        (by omega) (by rw [he]; bv_omega) (by omega)
      braid_fold bytesAt_cons ps s (c :: cs)
      braid_fold bytesAt_cons pd s (c :: cs)
      braid_done
    · exfalso
      have : n ≠ 1#64 := by rw [he]; bv_omega
      exact this hbr

/-- `copy_bytes` copies the `n` bytes its second argument points to over the `n` bytes its
first argument points to. -/
theorem copy_bytes_spec (pd ps r t : Word) (ss ds : List (BitVec 8)) (fn fz fc fv : Bool)
    (hlen : ds.length = ss.length) (hl : ss.length < 2 ^ 64) :
    Triple copy_bytes.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 pd, .reg x1 ps,
        .reg x2 (BitVec.ofNat 64 ss.length), .reg x8 t,
        .prop (bytesAt ps ss), .prop (bytesAt pd ds), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .prop (regAny x0), .prop (regAny x1), .reg x2 0#64,
        .prop (regAny x8), .prop (bytesAt ps ss), .prop (bytesAt pd ss),
        .reg lr r, .prop (flagAny Flags.n), .prop (flagAny Flags.z),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) := by
  cases ss with
  | nil =>
    have hds : ds = [] := List.length_eq_zero_iff.1 hlen
    subst hds
    simp only [List.length_nil]
    braid_sym_run
    braid_forget 0
    braid_forget 1
    braid_forget 8
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    braid_done
  | cons s ss =>
    obtain ⟨d, ds', rfl⟩ : ∃ d ds', ds = d :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at hl hlen ⊢
    braid_sym_step
    · braid_call copy_bytes_loop r ss ds' s d pd ps _ t fn fz fc fv (by omega) rfl hl
      braid_done
    · exfalso
      have : BitVec.ofNat 64 (ss.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr

/-- Two bytes that `cmp` finds equal as 32-bit values are equal. -/
theorem byte_eq_of_cmp {a b : BitVec 8}
    (h : BitVec.setWidth 64 (BitVec.setWidth 32 (BitVec.setWidth 64 a)) =
      BitVec.setWidth 64 (BitVec.setWidth 32 (BitVec.setWidth 64 b))) : a = b := by
  bv_decide

/-- Forget what `equal_bytes` leaves in the registers it uses and in the flags. -/
local macro "equal_bytes_forget" : tactic =>
  `(tactic| (braid_forget 1; braid_forget 2; braid_forget 8; braid_forget 9; braid_forget 10
             braid_forget_flag 0; braid_forget_flag 1; braid_forget_flag 2
             braid_forget_flag 3))

/-- Run the two loads of a round of `equal_bytes`, from the bytes at `pa` and at `pb` of a
set of bytes. -/
local macro "equal_bytes_loads " f:term ", " ha:term ", " hb:term : tactic =>
  `(tactic| (braid_unfold cellsOn_open $f $ha
             braid_sym_step
             braid_fold cellsOn_open $f $ha
             braid_unfold cellsOn_open $f $hb
             braid_sym_step
             braid_fold cellsOn_open $f $hb))

/-- The loop of `equal_bytes`: compare the `n` bytes from `pa` with those from `pb`, which
are read through one set of bytes. -/
theorem equal_bytes_loop (f : Word → BitVec 8) (addrs : List Word) (r : Word) :
    ∀ (as bs : List (BitVec 8)) (a b : BitVec 8) (pa pb n t9 t10 : Word)
    (fn fz fc fv : Bool), bs.length = as.length → n = BitVec.ofNat 64 (as.length + 1) →
    as.length + 1 < 2 ^ 64 → Reads f addrs pa (a :: as) → Reads f addrs pb (b :: bs) →
    Triple equal_bytes.program
      (Atoms.interp [.pc 0x10024#64, .reg x0 1#64, .reg x1 pb, .reg x2 n, .reg x8 pa,
        .reg x9 t9, .reg x10 t10, .prop (cellsOn f addrs), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .reg x0 (if a :: as = b :: bs then 1#64 else 0#64),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .prop (cellsOn f addrs), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)]) := by
  intro as
  induction as with
  | nil =>
    intro bs a b pa pb n t9 t10 fn fz fc fv hlen he hl hA hB
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    have he' : n = 1#64 := by simpa using he
    subst hbs he'
    obtain ⟨ha, rfl, -⟩ := hA
    obtain ⟨hb, rfl, -⟩ := hB
    equal_bytes_loads f, ha, hb
    braid_sym_run
    · have e : (if [f pa] = [f pb] then 1#64 else 0#64) = 0#64 :=
        ite_eq_right fun h => hbr (by rw [List.cons.inj h |>.1])
      rw [e]
      braid_sym_run
      equal_bytes_forget
      braid_done
    · have e : (if [f pa] = [f pb] then 1#64 else 0#64) = 1#64 :=
        ite_eq_left (by rw [byte_eq_of_cmp hbr])
      rw [e]
      braid_sym_run
      equal_bytes_forget
      braid_done
  | cons c cs ih =>
    intro bs a b pa pb n t9 t10 fn fz fc fv hlen he hl hA hB
    obtain ⟨d, ds, rfl⟩ : ∃ d ds, bs = d :: ds := by
      cases bs with
      | nil => simp at hlen
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at he hl hlen
    obtain ⟨ha, rfl, hra⟩ := hA
    obtain ⟨hb, rfl, hrb⟩ := hB
    equal_bytes_loads f, ha, hb
    braid_sym_run
    · have e : (if f pa :: c :: cs = f pb :: d :: ds then 1#64 else 0#64) = 0#64 :=
        ite_eq_right fun h => hbr (by rw [List.cons.inj h |>.1])
      rw [e]
      braid_sym_run
      equal_bytes_forget
      braid_done
    · have hab : f pa = f pb := byte_eq_of_cmp hbr
      braid_sym_run
      · have e : (if f pa :: c :: cs = f pb :: d :: ds then 1#64 else 0#64) =
            if c :: cs = d :: ds then 1#64 else 0#64 := by
          rw [hab]
          simp only [List.cons.injEq, true_and]
        rw [e]
        braid_call ih ds c d (pa + 1#64) (pb + 1#64) (n + 0xffffffffffffffff#64) _ _ _ _ _ _
          (by omega) (by rw [he]; bv_omega) (by omega) hra hrb
        braid_done
      · exfalso
        have : n ≠ 1#64 := by rw [he]; bv_omega
        exact this hbr

/-- `equal_bytes` returns one if the `n` bytes its first argument points to are those its
second argument points to, and zero otherwise. The bytes are read through one set of bytes,
so the two regions may overlap. -/
theorem equal_bytes_spec (f : Word → BitVec 8) (addrs : List Word) (pa pb r t8 t9 t10 : Word)
    (as bs : List (BitVec 8)) (fn fz fc fv : Bool) (hlen : bs.length = as.length)
    (hl : as.length < 2 ^ 64) (hA : Reads f addrs pa as) (hB : Reads f addrs pb bs) :
    Triple equal_bytes.program
      (Atoms.interp [.pc 0x10018#64, .reg x0 pa, .reg x1 pb,
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
    equal_bytes_forget
    braid_done
  | cons a as =>
    obtain ⟨b, bs', rfl⟩ : ∃ b bs', bs = b :: bs' := by
      cases bs with
      | nil => simp at hlen
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at hl hlen ⊢
    braid_sym_run
    · braid_call equal_bytes_loop f addrs r as bs' a b pa pb _ t9 t10 fn fz fc fv
        (by omega) rfl hl hA hB
      braid_done
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr

/-! ## On the machine -/

/-- The byte the machine has at an address where it has a byte. -/
theorem read8_of_hasBytes {s : Arm64.State} {a : Word} {b : BitVec 8}
    (h : HasBytes s a 1 (b.zeroExtend 64)) : s.mem.read8 a = b := by
  have := (h a (by simp)).2.1
  simpa using this

/-- A machine that has a byte at an address has there the byte its memory reads. -/
theorem hasBytes_read8 {s : Arm64.State} {a v : Word} (h : HasBytes s a 1 v) :
    HasBytes s a 1 ((s.mem.read8 a).zeroExtend 64) := by
  intro x hx
  have e : x = a := by bv_omega
  subst e
  exact ⟨(h x hx).1, by simp, (h x hx).2.2⟩

/-- **`copy_bytes` on the machine.** A running machine whose program holds the words of
`copy_bytes`, with its code loaded and its program counter at the entry, with the bytes `ss`
in memory where `x1` points, as many bytes `ds` where `x0` points, apart from the first, and
their number in `x2`, runs to the address in the link register with the bytes `ss` where
`x0` pointed, and still where `x1` pointed. -/
theorem copy_bytes_correct (prog : Arm64.Program) (s : Arm64.State) (ss ds : List (BitVec 8))
    (hw : prog.hasWords 0x10000#64 copy_bytes_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64) (hlen : ds.length = ss.length)
    (hn : s.regs.read 2#5 = BitVec.ofNat 64 ss.length)
    (hsrc : ∀ (i : Nat) (hi : i < ss.length),
      HasBytes s (s.regs.read 1#5 + BitVec.ofNat 64 i) 1 (ss[i].zeroExtend 64))
    (hdst : ∀ (i : Nat) (hi : i < ds.length),
      HasBytes s (s.regs.read 0#5 + BitVec.ofNat 64 i) 1 (ds[i].zeroExtend 64))
    (hapart : Apart (s.regs.read 1#5) ss.length (s.regs.read 0#5) ds.length) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      ∀ (i : Nat) (hi : i < ss.length),
        HasBytes s' (s.regs.read 0#5 + BitVec.ofNat 64 i) 1 (ss[i].zeroExtend 64) ∧
        HasBytes s' (s.regs.read 1#5 + BitVec.ofNat 64 i) 1 (ss[i].zeroExtend 64) := by
  have hl : ss.length < 2 ^ 64 := by
    have := (s.regs.read 0#5 - s.regs.read 1#5).isLt
    have := hapart.1
    omega
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat copy_bytes_lowered
    (copy_bytes_spec (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5) (s.regs.read 8#5)
      ss ds s.pstate.n s.pstate.z s.pstate.c s.pstate.v hlen hl) hw hc hrun
    (flat := [.pc 0x10000#64, .reg x0 (s.regs.read 0#5), .reg x1 (s.regs.read 1#5),
      .reg x2 (BitVec.ofNat 64 ss.length), .reg x8 (s.regs.read 8#5)] ++
      (bytesAtoms (s.regs.read 1#5) ss ++ (bytesAtoms (s.regs.read 0#5) ds ++
      [.reg lr (s.regs.read 30#5), .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z,
        .flag Flags.c s.pstate.c, .flag Flags.v s.pstate.v])))
    (Flat.interp (by braid_flat))
    (forall_flat₂ (by simp [Atom.IsPointsTo]) bytesAtoms_isPointsTo bytesAtoms_isPointsTo)
    (pairwise_flat₂ (by braid_disj) (bytesAtoms_pairwise (by omega))
      (bytesAtoms_pairwise (by omega)) (bytesAtoms_disj hapart.1 hapart.2)
      (by braid_disj_array) (by braid_disj_array))
    (forall_flat₂
      (by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
        Flags.v, hpc, hn])
      (bytesAtoms_sat fun i hi => sat_mem_hasBytes.2 (hsrc i hi))
      (bytesAtoms_sat fun i hi => sat_mem_hasBytes.2 (hdst i hi)))
  refine ⟨s', hsteps, ?_, fun i hi => ⟨?_, ?_⟩⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · exact hasBytes_of_bytesAt (p := s.regs.read 0#5) (bs := ss) hr hq (by braid_at) i hi
  · exact hasBytes_of_bytesAt (p := s.regs.read 1#5) (bs := ss) hr hq (by braid_at) i hi

/-- **`equal_bytes` on the machine.** A running machine whose program holds the words of
`equal_bytes`, with its code loaded and its program counter at the entry, with the bytes
`as` in memory where `x0` points, as many bytes `bs` where `x1` points, and their number,
below `2 ^ 64`, in `x2`, runs to the address in the link register with one in `x0` if `as`
and `bs` are the same, and zero otherwise. The two regions may overlap. -/
theorem equal_bytes_correct (prog : Arm64.Program) (s : Arm64.State) (as bs : List (BitVec 8))
    (hw : prog.hasWords 0x10018#64 equal_bytes_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10018#64) (hlen : bs.length = as.length)
    (hl : as.length < 2 ^ 64) (hn : s.regs.read 2#5 = BitVec.ofNat 64 as.length)
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
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat equal_bytes_lowered
    (equal_bytes_spec f addrs (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5)
      (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5) as bs s.pstate.n s.pstate.z
      s.pstate.c s.pstate.v hlen hl hA hB) hw hc hrun
    (flat := [.pc 0x10018#64, .reg x0 (s.regs.read 0#5), .reg x1 (s.regs.read 1#5),
      .reg x2 (BitVec.ofNat 64 as.length), .reg x8 (s.regs.read 8#5),
      .reg x9 (s.regs.read 9#5), .reg x10 (s.regs.read 10#5)] ++ cellsOnAtoms f addrs ++
      [.reg lr (s.regs.read 30#5), .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z,
        .flag Flags.c s.pstate.c, .flag Flags.v s.pstate.v])
    (by rw [cellsOn_eq_interp]
        exact Atoms.interp_flatten [.pc 0x10018#64, .reg x0 (s.regs.read 0#5),
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
