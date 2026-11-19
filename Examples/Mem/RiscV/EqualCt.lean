/-
  Examples.Mem.RiscV.EqualCt

  `equal_bytes_ct` of `mem.c` on RISC-V: the comparison of two regions of bytes that reads
  every byte and does not branch on any. The code keeps in `a3` the bitwise or of the
  differences of the bytes read so far, and returns whether it is zero.

  The loop is proved once, as a traced triple that carries both the result and what the run
  reveals (`docs/Leakage.md`): the specification `equal_bytes_ct_spec` is that triple with
  its trace forgotten. As for `equal_bytes`, memory is a set of single bytes (`cellsOn`), so
  the two regions may overlap.

  ## Main definitions

  * `equalBytesCtLeak`: what a run reveals, as a function of the two addresses, the length
    and the return address
  * `ctResult`: what the loop returns, from the differences so far and the bytes still to read

  ## Main results

  * `equal_bytes_ct_trace`: the traced triple, with the result and the trace
  * `equal_bytes_ct_spec`, `equal_bytes_ct_correct`: the specification, and the same about
    the machine alone
  * `reads_of_hasBytes`: two regions of a machine's memory, as one set of bytes
-/

module

public import Examples.Mem.RiscV.Proofs

public section

namespace Examples.Mem.RiscV

open Braid Examples Examples.Mem Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-! ## What the code computes -/

/-- What the loop of `equal_bytes_ct` returns, from the differences `d` it has gathered and
the bytes it has still to read: one if there was no difference and there will be none. -/
def ctResult (d : Word) (as bs : List (BitVec 8)) : Word :=
  if d = 0#64 ∧ as = bs then 1#64 else 0#64

/-- The differences gathered after a round are none exactly when there were none before and
the two bytes of the round are the same. -/
theorem acc_eq_zero (d : Word) (a b : BitVec 8) :
    BitVec.setWidth 64 b ^^^ BitVec.setWidth 64 a ||| d = 0#64 ↔ d = 0#64 ∧ a = b := by
  constructor
  · intro h
    constructor <;> bv_decide
  · rintro ⟨rfl, rfl⟩
    simp

/-- `sltiu` with one: whether a word is zero. -/
theorem ult_one (x : Word) : ofBool (BitVec.ult x 1#64) = if x = 0#64 then 1#64 else 0#64 := by
  unfold ofBool
  bv_decide

/-- The result after the last round. -/
theorem ctResult_last (d : Word) (a b : BitVec 8) :
    ofBool (BitVec.ult (BitVec.setWidth 64 b ^^^ BitVec.setWidth 64 a ||| d) 1#64) =
      ctResult d [a] [b] := by
  simp only [ult_one, ctResult, acc_eq_zero, List.cons.injEq, and_true]

/-- The result of the rounds after one, from what that round adds to the differences. -/
theorem ctResult_cons (d : Word) (a b : BitVec 8) (as bs : List (BitVec 8)) :
    ctResult (BitVec.setWidth 64 b ^^^ BitVec.setWidth 64 a ||| d) as bs =
      ctResult d (a :: as) (b :: bs) := by
  simp only [ctResult, acc_eq_zero, List.cons.injEq, and_assoc]

/-- With no difference so far, the result is whether the bytes are the same. -/
theorem ctResult_zero (as bs : List (BitVec 8)) :
    ctResult 0#64 as bs = if as = bs then 1#64 else 0#64 := by
  simp only [ctResult, true_and]

/-! ## What the code reveals -/

/-- What `n` rounds of the loop of `equal_bytes_ct` reveal: in each, the addresses of the two
bytes read, and whether the loop goes round again, which is whether it is the last of the
`n`. -/
def ctRoundsLeak (pa pb : Word) : Nat → Trace
  | 0 => []
  | n + 1 =>
    [.read pa 1, .read pb 1, .jump (if n = 0 then 0x1007c#64 else 0x10060#64)] ++
      ctRoundsLeak (pa + 1#64) (pb + 1#64) n

/-- What `equal_bytes_ct` reveals: whether there is anything to compare, the addresses of all
the bytes, in order, and where it returns. It is a function of the two addresses `pa` and
`pb`, the length `n` and the return address `r`, and of nothing else. -/
def equalBytesCtLeak (pa pb : Word) (n : Nat) (r : Word) : Trace :=
  [.jump (if n = 0 then 0x10084#64 else 0x10058#64)] ++ ctRoundsLeak pa pb n ++
    [.jump (r &&& ~~~1#64)]

/-- Finish a traced triple whose trace needs a proof of its own: the symbolic state is the
postcondition, and the equation between the traces is left as the goal. -/
local macro "braid_done_trace" : tactic =>
  `(tactic| (braid_norm; refine TripleT.done_split (by braid_split) ?_))

/-- Forget what `equal_bytes_ct` leaves in the registers it uses. -/
local macro "equal_bytes_ct_forget" : tactic =>
  `(tactic| (braid_forget 11; braid_forget 12; braid_forget 13; braid_forget 14
             braid_forget 15))

/-- Run the two loads of a round of `equal_bytes_ct`, from the bytes at `pa` and at `pb` of a
set of bytes. -/
local macro "equal_bytes_ct_loads " f:term ", " ha:term ", " hb:term : tactic =>
  `(tactic| (braid_unfold cellsOn_open $f $ha
             braid_sym_step
             braid_fold cellsOn_open $f $ha
             braid_unfold cellsOn_open $f $hb
             braid_sym_step
             braid_fold cellsOn_open $f $hb))

/-- The loop of `equal_bytes_ct`: gather the differences of the bytes from `pa` and from
`pb`, up to the end `e` of the second region, into the differences `d` so far, and return
whether there is none. It reveals `ctRoundsLeak`, which does not mention the bytes. -/
theorem equal_bytes_ct_loop (f : Word → BitVec 8) (addrs : List Word) (r e : Word) :
    ∀ (as bs : List (BitVec 8)) (a b : BitVec 8) (pa pb d t4 t5 : Word) (t : Trace),
    bs.length = as.length → pb + BitVec.ofNat 64 (as.length + 1) = e →
    as.length + 1 < 2 ^ 64 → Reads f addrs pa (a :: as) → Reads f addrs pb (b :: bs) →
    TripleT equal_bytes_ct.program
      (Atoms.interp [.pc 0x10060#64, .reg a0 pa, .reg a1 pb, .reg a2 e, .reg a3 d,
        .reg a4 t4, .reg a5 t5, .prop (cellsOn f addrs), .reg ra r]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (ctResult d (a :: as) (b :: bs)),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4),
        .prop (regAny a5), .prop (cellsOn f addrs), .reg ra r])
      (t ++ (ctRoundsLeak pa pb (as.length + 1) ++ [.jump (r &&& ~~~1#64)])) := by
  intro as
  induction as with
  | nil =>
    intro bs a b pa pb d t4 t5 t hlen he hl hA hB
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    have he' : e = pb + 1#64 := by simpa using he.symm
    subst hbs he'
    obtain ⟨ha, rfl, -⟩ := hA
    obtain ⟨hb, rfl, -⟩ := hB
    equal_bytes_ct_loads f, ha, hb
    braid_sym_run
    rw [ctResult_last]
    equal_bytes_ct_forget
    braid_done_trace
    simp [ctRoundsLeak]
  | cons c cs ih =>
    intro bs a b pa pb d t4 t5 t hlen he hl hA hB
    obtain ⟨d', ds, rfl⟩ : ∃ d' ds, bs = d' :: ds := by
      cases bs with
      | nil => simp at hlen
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at he hl hlen
    obtain ⟨ha, rfl, hra⟩ := hA
    obtain ⟨hb, rfl, hrb⟩ := hB
    equal_bytes_ct_loads f, ha, hb
    braid_sym_run
    · rw [← ctResult_cons]
      braid_call ih ds c d' (pa + 1#64) (pb + 1#64) _ _ _ _
        (by omega) (by rw [← he]; bv_omega) (by omega) hra hrb
      braid_done_trace
      simp [ctRoundsLeak]
    · exfalso
      have : pb + 1#64 ≠ e := by rw [← he]; bv_omega
      exact this hbr

/-- `equal_bytes_ct` returns one if the `n` bytes its first argument points to are those its
second argument points to, and zero otherwise, and reveals `equalBytesCtLeak` of the two
addresses, `n` and the return address. The bytes are read through one set of bytes, so the
two regions may overlap. -/
theorem equal_bytes_ct_trace (f : Word → BitVec 8) (addrs : List Word)
    (pa pb r t3 t4 t5 : Word) (as bs : List (BitVec 8)) (hlen : bs.length = as.length)
    (hl : as.length < 2 ^ 64) (hA : Reads f addrs pa as) (hB : Reads f addrs pb bs)
    (t : Trace) :
    TripleT equal_bytes_ct.program
      (Atoms.interp [.pc 0x10054#64, .reg a0 pa, .reg a1 pb,
        .reg a2 (BitVec.ofNat 64 as.length), .reg a3 t3, .reg a4 t4, .reg a5 t5,
        .prop (cellsOn f addrs), .reg ra r]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (if as = bs then 1#64 else 0#64),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4),
        .prop (regAny a5), .prop (cellsOn f addrs), .reg ra r])
      (t ++ equalBytesCtLeak pa pb as.length r) := by
  cases as with
  | nil =>
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    subst hbs
    simp only [List.length_nil, ↓reduceIte]
    braid_sym_run
    equal_bytes_ct_forget
    braid_done_trace
    simp [equalBytesCtLeak, ctRoundsLeak]
  | cons a as =>
    obtain ⟨b, bs', rfl⟩ : ∃ b bs', bs = b :: bs' := by
      cases bs with
      | nil => simp at hlen
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at hl hlen ⊢
    braid_sym_step
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr
    · braid_sym_step
      braid_sym_step
      rw [← ctResult_zero]
      braid_call equal_bytes_ct_loop f addrs r _ as bs' a b pa pb 0#64 t4 t5 _
        (by omega) rfl hl hA hB
      braid_done_trace
      simp [equalBytesCtLeak]

/-- `equal_bytes_ct` returns one if the `n` bytes its first argument points to are those its
second argument points to, and zero otherwise. The bytes are read through one set of bytes,
so the two regions may overlap. -/
theorem equal_bytes_ct_spec (f : Word → BitVec 8) (addrs : List Word)
    (pa pb r t3 t4 t5 : Word) (as bs : List (BitVec 8)) (hlen : bs.length = as.length)
    (hl : as.length < 2 ^ 64) (hA : Reads f addrs pa as) (hB : Reads f addrs pb bs) :
    Triple equal_bytes_ct.program
      (Atoms.interp [.pc 0x10054#64, .reg a0 pa, .reg a1 pb,
        .reg a2 (BitVec.ofNat 64 as.length), .reg a3 t3, .reg a4 t4, .reg a5 t5,
        .prop (cellsOn f addrs), .reg ra r])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (if as = bs then 1#64 else 0#64),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4),
        .prop (regAny a5), .prop (cellsOn f addrs), .reg ra r]) :=
  (equal_bytes_ct_trace f addrs pa pb r t3 t4 t5 as bs hlen hl hA hB []).triple

/-! ## On the machine -/

/-- **Two regions of a machine's memory, as one set of bytes.** If the machine has the bytes
`as` from `pa` on and the bytes `bs` from `pb` on, both are read through the set of the
machine's bytes at the addresses of the two regions, each address once, and every byte of
that set is in the machine's memory. The regions may overlap. -/
theorem reads_of_hasBytes (s : MachineState) (pa pb : Word) (as bs : List (BitVec 8))
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes s (pa + BitVec.ofNat 64 i) 1 (as[i].zeroExtend 64))
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (pb + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64)) :
    Reads s.getByte (dedup (addrsFrom pa as.length ++ addrsFrom pb bs.length)) pa as ∧
    Reads s.getByte (dedup (addrsFrom pa as.length ++ addrsFrom pb bs.length)) pb bs ∧
    ∀ x ∈ dedup (addrsFrom pa as.length ++ addrsFrom pb bs.length),
      (Atom.mem x 1 ((s.getByte x).zeroExtend 64) true).sat (abs s) := by
  refine ⟨reads_of_forall fun i hi => ⟨mem_dedup.2 (List.mem_append_left _
      (mem_addrsFrom.2 ⟨i, hi, rfl⟩)), getByte_of_hasBytes (ha i hi)⟩,
    reads_of_forall fun i hi => ⟨mem_dedup.2 (List.mem_append_right _
      (mem_addrsFrom.2 ⟨i, hi, rfl⟩)), getByte_of_hasBytes (hb i hi)⟩, fun x hx => ?_⟩
  refine sat_mem_abs.2 ?_
  rcases List.mem_append.1 (mem_dedup.1 hx) with h | h
  · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
    exact hasBytes_getByte (ha i hi)
  · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
    exact hasBytes_getByte (hb i hi)

/-- **`equal_bytes_ct` on the machine.** A machine that holds the code of `equal_bytes_ct`,
is at its entry, and has the bytes `as` in memory where `a0` points (`ha`), as many bytes
`bs` where `a1` points (`hlen`, `hb`), and their number, below `2 ^ 64`, in `a2` (`hl`,
`hn`), runs to the return address with one in `a0` if `as` and `bs` are the same, and zero
otherwise. The two regions may overlap. -/
theorem equal_bytes_ct_correct (s : MachineState) (as bs : List (BitVec 8))
    (hcode : ∀ p ∈ equal_bytes_ct_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10054#64)
    (hlen : bs.length = as.length) (hl : as.length < 2 ^ 64)
    (hn : s.getReg .x12 = BitVec.ofNat 64 as.length)
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes s (s.getReg .x10 + BitVec.ofNat 64 i) 1 (as[i].zeroExtend 64))
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.getReg .x11 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64)) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      s'.getReg .x10 = if as = bs then 1#64 else 0#64 := by
  obtain ⟨hA, hB, hsat⟩ := reads_of_hasBytes s (s.getReg .x10) (s.getReg .x11) as bs ha hb
  obtain ⟨n, s', σ', hsteps, hr, hq⟩ := machine_sound_flat equal_bytes_ct_lowered
    (equal_bytes_ct_spec _ _ (s.getReg .x10) (s.getReg .x11) (s.getReg .x1)
      (s.getReg .x13) (s.getReg .x14) (s.getReg .x15) as bs hlen hl hA hB) hcode
    (flat := [.pc 0x10054#64, .reg a0 (s.getReg .x10), .reg a1 (s.getReg .x11),
      .reg a2 (BitVec.ofNat 64 as.length), .reg a3 (s.getReg .x13),
      .reg a4 (s.getReg .x14), .reg a5 (s.getReg .x15)] ++ cellsOnAtoms s.getByte _ ++
      [.reg ra (s.getReg .x1)])
    (by rw [cellsOn_eq_interp]
        exact Atoms.interp_flatten [.pc 0x10054#64, .reg a0 (s.getReg .x10),
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
