/-
  Examples.Mem.RiscV.Proofs

  `mem.c` on RISC-V: copying bytes and comparing bytes, the first rung of the scaling
  ladder (`docs/Scaling.md`).

  Both loops are proved by induction on the list of bytes, with the loop's specification as
  the invariant, since the number of rounds is not fixed. `equal_bytes` only reads memory, so
  its two regions may overlap: its memory is a set of single bytes (`cellsOn`), opened at the
  address of each load. Every access is of one byte, so there is no alignment to ask for.

  ## Main results

  * `copy_bytes_spec`, `equal_bytes_spec`: the specifications
  * `copy_bytes_correct`, `equal_bytes_correct`: the same, about the machine alone
-/

module

public import Examples.Mem.RiscV.Image
public import Examples.Mem.Common
public import Lowering.RiscV.Logic
public import Examples.Spec
import Braid.BV

public section

namespace Examples.Mem.RiscV

open Braid Examples Examples.Mem Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- The loop of `copy_bytes`: copy the bytes from `ps` to `pd`, up to the end `e` of the
destination. -/
theorem copy_bytes_loop (r e : Word) : ∀ (ss ds : List (BitVec 8)) (s d : BitVec 8)
    (pd ps t : Word), ds.length = ss.length →
    pd + BitVec.ofNat 64 (ss.length + 1) = e → ss.length + 1 < 2 ^ 64 →
    Triple copy_bytes.program
      (Atoms.interp [.pc 0x10008#64, .reg a0 pd, .reg a1 ps, .reg a2 e, .reg a3 t,
        .prop (bytesAt ps (s :: ss)), .prop (bytesAt pd (d :: ds)), .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .prop (regAny a0), .prop (regAny a1),
        .prop (regAny a2), .prop (regAny a3), .prop (bytesAt ps (s :: ss)),
        .prop (bytesAt pd (s :: ss)), .reg ra r]) := by
  intro ss
  induction ss with
  | nil =>
    intro ds s d pd ps t hlen he hb
    have hds : ds = [] := List.length_eq_zero_iff.1 hlen
    have he' : e = pd + 1#64 := by simpa using he.symm
    subst hds he'
    braid_unfold bytesAt_cons ps s []
    braid_unfold bytesAt_cons pd d []
    braid_sym_run
    braid_fold bytesAt_cons ps s []
    braid_fold bytesAt_cons pd s []
    braid_forget 10
    braid_forget 11
    braid_forget 12
    braid_forget 13
    braid_done
  | cons c cs ih =>
    intro ds s d pd ps t hlen he hb
    obtain ⟨d', ds', rfl⟩ : ∃ d' ds', ds = d' :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at he hb hlen
    braid_unfold bytesAt_cons ps s (c :: cs)
    braid_unfold bytesAt_cons pd d (d' :: ds')
    braid_sym_run
    · braid_call ih ds' c d' (pd + 1#64) (ps + 1#64) _
        (by omega) (by rw [← he]; bv_omega) (by omega)
      braid_fold bytesAt_cons ps s (c :: cs)
      braid_fold bytesAt_cons pd s (c :: cs)
      braid_done
    · exfalso
      have : pd + 1#64 ≠ e := by rw [← he]; bv_omega
      exact this hbr

/-- `copy_bytes` copies the `n` bytes its second argument points to over the `n` bytes its
first argument points to. -/
theorem copy_bytes_spec (pd ps r t : Word) (ss ds : List (BitVec 8))
    (hlen : ds.length = ss.length) (hl : ss.length < 2 ^ 64) :
    Triple copy_bytes.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 pd, .reg a1 ps,
        .reg a2 (BitVec.ofNat 64 ss.length), .reg a3 t,
        .prop (bytesAt ps ss), .prop (bytesAt pd ds), .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .prop (regAny a0), .prop (regAny a1),
        .prop (regAny a2), .prop (regAny a3), .prop (bytesAt ps ss), .prop (bytesAt pd ss),
        .reg ra r]) := by
  cases ss with
  | nil =>
    have hds : ds = [] := List.length_eq_zero_iff.1 hlen
    subst hds
    simp only [List.length_nil]
    braid_sym_run
    braid_forget 10
    braid_forget 11
    braid_forget 12
    braid_forget 13
    braid_done
  | cons s ss =>
    obtain ⟨d, ds', rfl⟩ : ∃ d ds', ds = d :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at hl hlen ⊢
    braid_sym_step
    · exfalso
      have : BitVec.ofNat 64 (ss.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr
    · braid_sym_step
      braid_call copy_bytes_loop r _ ss ds' s d pd ps t (by omega) rfl hl
      braid_done

/-- Two bytes that are equal as words are equal. -/
theorem byte_eq_of_word {a b : BitVec 8}
    (h : BitVec.setWidth 64 a = BitVec.setWidth 64 b) : a = b := by
  bv_auto

/-- Forget what `equal_bytes` leaves in the registers it uses. -/
local macro "equal_bytes_forget" : tactic =>
  `(tactic| (braid_forget 11; braid_forget 12; braid_forget 13; braid_forget 14
             braid_forget 15))

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
    ∀ (as bs : List (BitVec 8)) (a b : BitVec 8) (pa pb n t4 t5 : Word),
    bs.length = as.length → n = BitVec.ofNat 64 (as.length + 1) →
    as.length + 1 < 2 ^ 64 → Reads f addrs pa (a :: as) → Reads f addrs pb (b :: bs) →
    Triple equal_bytes.program
      (Atoms.interp [.pc 0x1002c#64, .reg a0 1#64, .reg a1 pb, .reg a2 n, .reg a3 pa,
        .reg a4 t4, .reg a5 t5, .prop (cellsOn f addrs), .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (if a :: as = b :: bs then 1#64 else 0#64),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4),
        .prop (regAny a5), .prop (cellsOn f addrs), .reg ra r]) := by
  intro as
  induction as with
  | nil =>
    intro bs a b pa pb n t4 t5 hlen he hl hA hB
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
        ite_eq_left (by rw [byte_eq_of_word hbr])
      rw [e]
      braid_sym_run
      equal_bytes_forget
      braid_done
  | cons c cs ih =>
    intro bs a b pa pb n t4 t5 hlen he hl hA hB
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
    · have hab : f pa = f pb := byte_eq_of_word hbr
      braid_sym_run
      · have e : (if f pa :: c :: cs = f pb :: d :: ds then 1#64 else 0#64) =
            if c :: cs = d :: ds then 1#64 else 0#64 := by
          rw [hab]
          simp only [List.cons.injEq, true_and]
        rw [e]
        braid_call ih ds c d (pa + 1#64) (pb + 1#64) (n + 0xffffffffffffffff#64) _ _
          (by omega) (by rw [he]; bv_omega) (by omega) hra hrb
        braid_done
      · exfalso
        have : n + 0xffffffffffffffff#64 ≠ 0#64 := by rw [he]; bv_omega
        exact this hbr

/-- `equal_bytes` returns one if the `n` bytes its first argument points to are those its
second argument points to, and zero otherwise. The bytes are read through one set of bytes,
so the two regions may overlap. -/
theorem equal_bytes_spec (f : Word → BitVec 8) (addrs : List Word) (pa pb r t3 t4 t5 : Word)
    (as bs : List (BitVec 8)) (hlen : bs.length = as.length)
    (hl : as.length < 2 ^ 64) (hA : Reads f addrs pa as) (hB : Reads f addrs pb bs) :
    Triple equal_bytes.program
      (Atoms.interp [.pc 0x10020#64, .reg a0 pa, .reg a1 pb,
        .reg a2 (BitVec.ofNat 64 as.length), .reg a3 t3, .reg a4 t4, .reg a5 t5,
        .prop (cellsOn f addrs), .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (if as = bs then 1#64 else 0#64),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4),
        .prop (regAny a5), .prop (cellsOn f addrs), .reg ra r]) := by
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
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr
    · braid_call equal_bytes_loop f addrs r as bs' a b pa pb _ t4 t5
        (by omega) rfl hl hA hB
      braid_done

/-! ## On the machine -/

/-- The byte the machine has at an address where it has a byte. -/
theorem getByte_of_hasBytes {s : MachineState} {a : Word} {b : BitVec 8}
    (h : HasBytes s a 1 (b.zeroExtend 64)) : s.getByte a = b := by
  have := (h a (by simp)).2
  simpa using this

/-- A machine that has a byte at an address has there the byte its memory reads. -/
theorem hasBytes_getByte {s : MachineState} {a v : Word} (h : HasBytes s a 1 v) :
    HasBytes s a 1 ((s.getByte a).zeroExtend 64) := by
  intro x hx
  have e : x = a := by bv_omega
  subst e
  exact ⟨(h x hx).1, by simp⟩

/-- **An array of bytes, out of the logic.** A machine related to a state of which a list of
atoms holds has each byte of an array in the list. -/
theorem hasBytes_of_bytesAt {s : MachineState} {σ : State} {as : Atoms} {R : SProp} {p : Word}
    {bs : List (BitVec 8)} (hr : Rel s σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.prop (bytesAt p bs))) (i : Nat) (hi : i < bs.length) :
    HasBytes s (p + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64) := by
  obtain ⟨F, e⟩ := hat.split
  rw [e] at h
  intro x hx
  have hx' : x = p + BitVec.ofNat 64 i := by bv_omega
  subst hx'
  obtain ⟨hv, hc⟩ := hr.cell (bytesAt_cell (SProp.holds_assoc.1 h) i hi)
  exact ⟨hv, by simpa using (congrArg Cell.val hc).symm⟩

/-- **`copy_bytes` on the machine.** A machine that holds the code of `copy_bytes`, is at its
entry, and has the bytes `ss` in memory where `a1` points, as many bytes `ds` where `a0`
points, each array starting at or beyond the end of the other, going round the address
space, and their number in `a2`, runs to the return address with the bytes `ss` where `a0`
pointed, and still where `a1` pointed. -/
theorem copy_bytes_correct (s : MachineState) (ss ds : List (BitVec 8))
    (hcode : ∀ p ∈ copy_bytes_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hlen : ds.length = ss.length) (hn : s.getReg .x12 = BitVec.ofNat 64 ss.length)
    (hsrc : ∀ (i : Nat) (hi : i < ss.length),
      HasBytes s (s.getReg .x11 + BitVec.ofNat 64 i) 1 (ss[i].zeroExtend 64))
    (hdst : ∀ (i : Nat) (hi : i < ds.length),
      HasBytes s (s.getReg .x10 + BitVec.ofNat 64 i) 1 (ds[i].zeroExtend 64))
    (hapart : ss.length ≤ (s.getReg .x10 - s.getReg .x11).toNat ∧
      ds.length ≤ (s.getReg .x11 - s.getReg .x10).toNat) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      ∀ (i : Nat) (hi : i < ss.length),
        HasBytes s' (s.getReg .x10 + BitVec.ofNat 64 i) 1 (ss[i].zeroExtend 64) ∧
        HasBytes s' (s.getReg .x11 + BitVec.ofNat 64 i) 1 (ss[i].zeroExtend 64) := by
  have hl : ss.length < 2 ^ 64 := by
    have := (s.getReg .x10 - s.getReg .x11).isLt
    have := hapart.1
    omega
  obtain ⟨n, s', σ', hsteps, hr, hq⟩ := machine_sound_flat copy_bytes_lowered
    (copy_bytes_spec (s.getReg .x10) (s.getReg .x11) (s.getReg .x1) (s.getReg .x13)
      ss ds hlen hl) hcode
    (flat := [.pc 0x10000#64, .reg a0 (s.getReg .x10), .reg a1 (s.getReg .x11),
      .reg a2 (BitVec.ofNat 64 ss.length), .reg a3 (s.getReg .x13)] ++
      (bytesAtoms (s.getReg .x11) ss ++ (bytesAtoms (s.getReg .x10) ds ++
      [.reg ra (s.getReg .x1)])))
    (Flat.interp (by braid_flat))
    (forall_flat₂ (by simp [Atom.IsPointsTo]) bytesAtoms_isPointsTo bytesAtoms_isPointsTo)
    (pairwise_flat₂ (by braid_disj) (bytesAtoms_pairwise (by omega))
      (bytesAtoms_pairwise (by omega)) (bytesAtoms_disj hapart.1 hapart.2)
      (by braid_disj_array) (by braid_disj_array))
    (forall_flat₂
      (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, hn])
      (bytesAtoms_sat fun i hi => sat_mem_abs.2 (hsrc i hi))
      (bytesAtoms_sat fun i hi => sat_mem_abs.2 (hdst i hi)))
  refine ⟨n, s', hsteps, ?_, fun i hi => ⟨?_, ?_⟩⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · exact hasBytes_of_bytesAt (p := s.getReg .x10) (bs := ss) hr hq (by braid_at) i hi
  · exact hasBytes_of_bytesAt (p := s.getReg .x11) (bs := ss) hr hq (by braid_at) i hi

/-- **`equal_bytes` on the machine.** A machine that holds the code of `equal_bytes`, is at
its entry, and has the bytes `as` in memory where `a0` points, as many bytes `bs` where `a1`
points, and their number, below `2 ^ 64`, in `a2`, runs to the return address with one in
`a0` if `as` and `bs` are the same, and zero otherwise. The two regions may overlap. -/
theorem equal_bytes_correct (s : MachineState) (as bs : List (BitVec 8))
    (hcode : ∀ p ∈ equal_bytes_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10020#64)
    (hlen : bs.length = as.length) (hl : as.length < 2 ^ 64)
    (hn : s.getReg .x12 = BitVec.ofNat 64 as.length)
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes s (s.getReg .x10 + BitVec.ofNat 64 i) 1 (as[i].zeroExtend 64))
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.getReg .x11 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64)) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 = if as = bs then 1#64 else 0#64 := by
  let f : Word → BitVec 8 := fun x => s.getByte x
  let addrs : List Word :=
    dedup (addrsFrom (s.getReg .x10) as.length ++ addrsFrom (s.getReg .x11) bs.length)
  have hA : Reads f addrs (s.getReg .x10) as := reads_of_forall fun i hi =>
    ⟨mem_dedup.2 (List.mem_append_left _ (mem_addrsFrom.2 ⟨i, hi, rfl⟩)),
      getByte_of_hasBytes (ha i hi)⟩
  have hB : Reads f addrs (s.getReg .x11) bs := reads_of_forall fun i hi =>
    ⟨mem_dedup.2 (List.mem_append_right _ (mem_addrsFrom.2 ⟨i, hi, rfl⟩)),
      getByte_of_hasBytes (hb i hi)⟩
  have hsat : ∀ x ∈ addrs, (Atom.mem x 1 ((f x).zeroExtend 64) true).sat (abs s) := by
    intro x hx
    refine sat_mem_abs.2 ?_
    rcases List.mem_append.1 (mem_dedup.1 hx) with h | h
    · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
      exact hasBytes_getByte (ha i hi)
    · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
      exact hasBytes_getByte (hb i hi)
  obtain ⟨n, s', σ', hsteps, hr, hq⟩ := machine_sound_flat equal_bytes_lowered
    (equal_bytes_spec f addrs (s.getReg .x10) (s.getReg .x11) (s.getReg .x1)
      (s.getReg .x13) (s.getReg .x14) (s.getReg .x15) as bs hlen hl hA hB) hcode
    (flat := [.pc 0x10020#64, .reg a0 (s.getReg .x10), .reg a1 (s.getReg .x11),
      .reg a2 (BitVec.ofNat 64 as.length), .reg a3 (s.getReg .x13),
      .reg a4 (s.getReg .x14), .reg a5 (s.getReg .x15)] ++ cellsOnAtoms f addrs ++
      [.reg ra (s.getReg .x1)])
    (by rw [cellsOn_eq_interp]
        exact Atoms.interp_flatten [.pc 0x10020#64, .reg a0 (s.getReg .x10),
          .reg a1 (s.getReg .x11), .reg a2 (BitVec.ofNat 64 as.length),
          .reg a3 (s.getReg .x13), .reg a4 (s.getReg .x14),
          .reg a5 (s.getReg .x15)] _ _)
    (Atoms.forall_flat (by simp [Atom.IsPointsTo]) cellsOnAtoms_isPointsTo)
    (Atoms.pairwise_flat (by braid_disj) (cellsOnAtoms_pairwise (dedup_pairwise _))
      (by
        braid_disj_array
        all_goals first
          | exact disj_reg_cellsOnAtoms | exact disj_pc_cellsOnAtoms))
    (Atoms.forall_flat
      (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, hn])
      (cellsOnAtoms_sat hsat))
  refine ⟨n, s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.getReg (r := .x10) (by decide)]
    exact Atoms.reg_of_holds (r := 10) hq (by braid_at)

end Examples.Mem.RiscV
