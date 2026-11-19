/-
  Examples.Mem.RiscV.Leakage

  What the functions of `mem.c` reveal on RISC-V (`docs/Leakage.md`), each as a traced
  triple, as a theorem about the machine alone, and as a statement about two machines.

  * `copy_bytes` reveals the two addresses, the length and the return address, and nothing
    of the bytes it copies (`copyBytesLeak`).
  * `equal_bytes` is not constant-time: it returns at the first byte that differs. Besides
    the two addresses, the length and the return address it reveals exactly the index of the
    first position where the two regions differ, or that there is none (`firstDiff`,
    `equalBytesLeak`).
  * `equal_bytes_ct` reveals the two addresses, the length and the return address, and
    nothing of the bytes it compares (`equalBytesCtLeak`, in `Examples.Mem.RiscV.EqualCt`).

  Every loop is proved by the induction of its functional proof, with what the rounds still
  to run reveal as a function of the number of rounds.

  ## Main definitions

  * `copyBytesLeak`, `equalBytesLeak`: what a run reveals, as a function of what is public
  * `firstDiff`: the index of the first position where two lists differ

  ## Main results

  * `copy_bytes_trace`, `copy_bytes_leakage`, `copy_bytes_leakage_eq`
  * `equal_bytes_trace`, `equal_bytes_leakage`, `equal_bytes_leakage_eq`
  * `equal_bytes_ct_leakage`, `equal_bytes_ct_leakage_eq`
-/

module

public import Examples.Mem.RiscV.EqualCt

public section

namespace Examples.Mem.RiscV

open Braid Examples Examples.Mem Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-- Finish a traced triple whose trace needs a proof of its own: the symbolic state is the
postcondition, and the equation between the traces is left as the goal. -/
local macro "braid_done_trace" : tactic =>
  `(tactic| (braid_norm; refine TripleT.done_split (by braid_split) ?_))

/-! ## `copy_bytes` -/

/-- What `n` rounds of the loop of `copy_bytes` reveal: in each, the address of the byte read
and of the byte written, and whether the loop goes round again, which is whether it is the
last of the `n`. -/
def copyRoundsLeak (pd ps : Word) : Nat → Trace
  | 0 => []
  | n + 1 =>
    [.read ps 1, .write pd 1, .jump (if n = 0 then 0x1001c#64 else 0x10008#64)] ++
      copyRoundsLeak (pd + 1#64) (ps + 1#64) n

/-- What `copy_bytes` reveals: whether there is anything to copy, the address of each byte
read and written, in order, and where it returns. It is a function of the destination `pd`,
the source `ps`, the length `n` and the return address `r`. -/
def copyBytesLeak (pd ps : Word) (n : Nat) (r : Word) : Trace :=
  [.jump (if n = 0 then 0x1001c#64 else 0x10004#64)] ++ copyRoundsLeak pd ps n ++
    [.jump (r &&& ~~~1#64)]

/-- The loop of `copy_bytes`, with what it reveals. -/
theorem copy_bytes_loop_trace (r e : Word) : ∀ (ss ds : List (BitVec 8)) (s d : BitVec 8)
    (pd ps t3 : Word) (t : Trace), ds.length = ss.length →
    pd + BitVec.ofNat 64 (ss.length + 1) = e → ss.length + 1 < 2 ^ 64 →
    TripleT copy_bytes.program
      (Atoms.interp [.pc 0x10008#64, .reg a0 pd, .reg a1 ps, .reg a2 e, .reg a3 t3,
        .prop (bytesAt ps (s :: ss)), .prop (bytesAt pd (d :: ds)), .reg ra r]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .prop (regAny a0), .prop (regAny a1),
        .prop (regAny a2), .prop (regAny a3), .prop (bytesAt ps (s :: ss)),
        .prop (bytesAt pd (s :: ss)), .reg ra r])
      (t ++ (copyRoundsLeak pd ps (ss.length + 1) ++ [.jump (r &&& ~~~1#64)])) := by
  intro ss
  induction ss with
  | nil =>
    intro ds s d pd ps t3 t hlen he hb
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
    braid_done_trace
    simp [copyRoundsLeak]
  | cons c cs ih =>
    intro ds s d pd ps t3 t hlen he hb
    obtain ⟨d', ds', rfl⟩ : ∃ d' ds', ds = d' :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at he hb hlen
    braid_unfold bytesAt_cons ps s (c :: cs)
    braid_unfold bytesAt_cons pd d (d' :: ds')
    braid_sym_run
    · braid_call ih ds' c d' (pd + 1#64) (ps + 1#64) _ _
        (by omega) (by rw [← he]; bv_omega) (by omega)
      braid_fold bytesAt_cons ps s (c :: cs)
      braid_fold bytesAt_cons pd s (c :: cs)
      braid_done_trace
      simp [copyRoundsLeak]
    · exfalso
      have : pd + 1#64 ≠ e := by rw [← he]; bv_omega
      exact this hbr

/-- `copy_bytes` copies `n` bytes and reveals `copyBytesLeak` of the two addresses, `n` and
the return address. -/
theorem copy_bytes_trace (pd ps r t3 : Word) (ss ds : List (BitVec 8))
    (hlen : ds.length = ss.length) (hl : ss.length < 2 ^ 64) (t : Trace) :
    TripleT copy_bytes.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 pd, .reg a1 ps,
        .reg a2 (BitVec.ofNat 64 ss.length), .reg a3 t3,
        .prop (bytesAt ps ss), .prop (bytesAt pd ds), .reg ra r]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .prop (regAny a0), .prop (regAny a1),
        .prop (regAny a2), .prop (regAny a3), .prop (bytesAt ps ss), .prop (bytesAt pd ss),
        .reg ra r]) (t ++ copyBytesLeak pd ps ss.length r) := by
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
    braid_done_trace
    simp [copyBytesLeak, copyRoundsLeak]
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
      braid_call copy_bytes_loop_trace r _ ss ds' s d pd ps t3 _ (by omega) rfl hl
      braid_done_trace
      simp [copyBytesLeak]

/-- **What `copy_bytes` reveals, on the machine.** A machine that holds the code of
`copy_bytes`, is at its entry, and has the bytes `ss` in memory where `a1` points (`hsrc`),
as many bytes `ds` where `a0` points (`hlen`, `hdst`), each array starting at or beyond the
end of the other, going round the address space (`hapart`), and their number in `a2` (`hn`),
runs to the return address with the trace `copyBytesLeak` of the two addresses, the number
in `a2` and the return address. -/
theorem copy_bytes_leakage (s : MachineState) (ss ds : List (BitVec 8))
    (hcode : ∀ p ∈ copy_bytes_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hlen : ds.length = ss.length) (hn : s.getReg .x12 = BitVec.ofNat 64 ss.length)
    (hsrc : ∀ (i : Nat) (hi : i < ss.length),
      HasBytes s (s.getReg .x11 + BitVec.ofNat 64 i) 1 (ss[i].zeroExtend 64))
    (hdst : ∀ (i : Nat) (hi : i < ds.length),
      HasBytes s (s.getReg .x10 + BitVec.ofNat 64 i) 1 (ds[i].zeroExtend 64))
    (hapart : ss.length ≤ (s.getReg .x10 - s.getReg .x11).toNat ∧
      ds.length ≤ (s.getReg .x11 - s.getReg .x10).toNat) :
    ∃ s', RunL s (copyBytesLeak (s.getReg .x10) (s.getReg .x11) (s.getReg .x12).toNat
        (s.getReg .x1)) s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 := by
  have hl : ss.length < 2 ^ 64 := by
    have := (s.getReg .x10 - s.getReg .x11).isLt
    have := hapart.1
    omega
  have hnat : (s.getReg .x12).toNat = ss.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  obtain ⟨s', σ', hrun, hr, hq⟩ := machine_soundT copy_bytes_lowered
    (copy_bytes_trace (s.getReg .x10) (s.getReg .x11) (s.getReg .x1) (s.getReg .x13)
      ss ds hlen hl []) hcode
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
  refine ⟨s', hrun, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`copy_bytes` reveals nothing of the bytes it copies.** Two machines that hold the code
of `copy_bytes`, are at its entry, each with a source and a destination as `copy_bytes_leakage`
asks, and that agree on the two addresses, the length and the return address, run with the
same trace, whatever the bytes are. -/
theorem copy_bytes_leakage_eq (s₁ s₂ : MachineState) (ss₁ ds₁ ss₂ ds₂ : List (BitVec 8))
    (hcode₁ : ∀ p ∈ copy_bytes_code, s₁.code p.1 = some p.2)
    (hcode₂ : ∀ p ∈ copy_bytes_code, s₂.code p.1 = some p.2)
    (hpc₁ : s₁.pc = 0x10000#64) (hpc₂ : s₂.pc = 0x10000#64)
    (hlen₁ : ds₁.length = ss₁.length) (hlen₂ : ds₂.length = ss₂.length)
    (hn₁ : s₁.getReg .x12 = BitVec.ofNat 64 ss₁.length)
    (hn₂ : s₂.getReg .x12 = BitVec.ofNat 64 ss₂.length)
    (hsrc₁ : ∀ (i : Nat) (hi : i < ss₁.length),
      HasBytes s₁ (s₁.getReg .x11 + BitVec.ofNat 64 i) 1 (ss₁[i].zeroExtend 64))
    (hdst₁ : ∀ (i : Nat) (hi : i < ds₁.length),
      HasBytes s₁ (s₁.getReg .x10 + BitVec.ofNat 64 i) 1 (ds₁[i].zeroExtend 64))
    (hsrc₂ : ∀ (i : Nat) (hi : i < ss₂.length),
      HasBytes s₂ (s₂.getReg .x11 + BitVec.ofNat 64 i) 1 (ss₂[i].zeroExtend 64))
    (hdst₂ : ∀ (i : Nat) (hi : i < ds₂.length),
      HasBytes s₂ (s₂.getReg .x10 + BitVec.ofNat 64 i) 1 (ds₂[i].zeroExtend 64))
    (hapart₁ : ss₁.length ≤ (s₁.getReg .x10 - s₁.getReg .x11).toNat ∧
      ds₁.length ≤ (s₁.getReg .x11 - s₁.getReg .x10).toNat)
    (hapart₂ : ss₂.length ≤ (s₂.getReg .x10 - s₂.getReg .x11).toNat ∧
      ds₂.length ≤ (s₂.getReg .x11 - s₂.getReg .x10).toNat)
    (e10 : s₂.getReg .x10 = s₁.getReg .x10) (e11 : s₂.getReg .x11 = s₁.getReg .x11)
    (e12 : s₂.getReg .x12 = s₁.getReg .x12) (e1 : s₂.getReg .x1 = s₁.getReg .x1) :
    ∃ tr s₁' s₂', RunL s₁ tr s₁' ∧ RunL s₂ tr s₂' ∧
      s₁'.pc = s₁.getReg .x1 &&& ~~~1#64 ∧ s₂'.pc = s₁.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨s₁', h₁, hp₁⟩ :=
    copy_bytes_leakage s₁ ss₁ ds₁ hcode₁ hpc₁ hlen₁ hn₁ hsrc₁ hdst₁ hapart₁
  obtain ⟨s₂', h₂, hp₂⟩ :=
    copy_bytes_leakage s₂ ss₂ ds₂ hcode₂ hpc₂ hlen₂ hn₂ hsrc₂ hdst₂ hapart₂
  simp only [e10, e11, e12, e1] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

/-! ## `equal_bytes` -/

/-- The index of the first position where two lists of bytes differ, or `none` if they agree
wherever both have a byte. -/
def firstDiff : List (BitVec 8) → List (BitVec 8) → Option Nat
  | a :: as, b :: bs => if a = b then (firstDiff as bs).map (· + 1) else some 0
  | _, _ => none

/-- What the rounds of the loop of `equal_bytes` reveal, with `n` bytes still to compare, of
which the first that differ are at the index `d`, if any do. A round reveals the addresses
of the two bytes it reads and whether they differ; if they do, the loop stops; if they do
not, the round also reveals whether it was the last. -/
def equalRoundsLeak (pa pb : Word) : Nat → Option Nat → Trace
  | 0, _ => []
  | _ + 1, some 0 => [.read pa 1, .read pb 1, .jump 0x1004c#64]
  | n + 1, some (k + 1) =>
    [.read pa 1, .read pb 1, .jump 0x10038#64,
      .jump (if n = 0 then 0x10048#64 else 0x1002c#64)] ++
      equalRoundsLeak (pa + 1#64) (pb + 1#64) n (some k)
  | n + 1, none =>
    [.read pa 1, .read pb 1, .jump 0x10038#64,
      .jump (if n = 0 then 0x10048#64 else 0x1002c#64)] ++
      equalRoundsLeak (pa + 1#64) (pb + 1#64) n none

/-- What `equal_bytes` reveals: whether there is anything to compare, the addresses of the
bytes it reads, up to and including the first two that differ, and where it returns. It is a
function of the two addresses `pa` and `pb`, the length `n`, the return address `r`, and the
index `d` of the first position where the two regions differ, if there is one. It takes
nothing else of the bytes. -/
def equalBytesLeak (pa pb : Word) (n : Nat) (r : Word) (d : Option Nat) : Trace :=
  [.jump (if n = 0 then 0x10048#64 else 0x1002c#64)] ++ equalRoundsLeak pa pb n d ++
    [.jump (r &&& ~~~1#64)]

/-- A round of `equal_bytes` whose two bytes differ is the last. -/
theorem equalRoundsLeak_differ (pa pb : Word) (n : Nat) {a b : BitVec 8}
    (as bs : List (BitVec 8)) (h : a ≠ b) :
    equalRoundsLeak pa pb (n + 1) (firstDiff (a :: as) (b :: bs)) =
      [.read pa 1, .read pb 1, .jump 0x1004c#64] := by
  simp [firstDiff, h, equalRoundsLeak]

/-- A round of `equal_bytes` whose two bytes are the same, and the rounds after it. -/
theorem equalRoundsLeak_same (pa pb : Word) (n : Nat) (a : BitVec 8)
    (as bs : List (BitVec 8)) :
    equalRoundsLeak pa pb (n + 1) (firstDiff (a :: as) (a :: bs)) =
      [.read pa 1, .read pb 1, .jump 0x10038#64,
        .jump (if n = 0 then 0x10048#64 else 0x1002c#64)] ++
        equalRoundsLeak (pa + 1#64) (pb + 1#64) n (firstDiff as bs) := by
  simp only [firstDiff, ↓reduceIte]
  cases firstDiff as bs <;> simp [equalRoundsLeak]

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

/-- The loop of `equal_bytes`, with what it reveals. -/
theorem equal_bytes_loop_trace (f : Word → BitVec 8) (addrs : List Word) (r : Word) :
    ∀ (as bs : List (BitVec 8)) (a b : BitVec 8) (pa pb n t4 t5 : Word) (t : Trace),
    bs.length = as.length → n = BitVec.ofNat 64 (as.length + 1) →
    as.length + 1 < 2 ^ 64 → Reads f addrs pa (a :: as) → Reads f addrs pb (b :: bs) →
    TripleT equal_bytes.program
      (Atoms.interp [.pc 0x1002c#64, .reg a0 1#64, .reg a1 pb, .reg a2 n, .reg a3 pa,
        .reg a4 t4, .reg a5 t5, .prop (cellsOn f addrs), .reg ra r]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (if a :: as = b :: bs then 1#64 else 0#64),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4),
        .prop (regAny a5), .prop (cellsOn f addrs), .reg ra r])
      (t ++ (equalRoundsLeak pa pb (as.length + 1) (firstDiff (a :: as) (b :: bs)) ++
        [.jump (r &&& ~~~1#64)])) := by
  intro as
  induction as with
  | nil =>
    intro bs a b pa pb n t4 t5 t hlen he hl hA hB
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    have he' : n = 1#64 := by simpa using he
    subst hbs he'
    obtain ⟨ha, rfl, -⟩ := hA
    obtain ⟨hb, rfl, -⟩ := hB
    equal_bytes_loads f, ha, hb
    braid_sym_run
    · have hne : f pa ≠ f pb := fun h => hbr (by rw [h])
      have e : (if [f pa] = [f pb] then 1#64 else 0#64) = 0#64 :=
        ite_eq_right fun h => hne (List.cons.inj h |>.1)
      rw [e, equalRoundsLeak_differ pa pb _ [] [] hne]
      braid_sym_run
      equal_bytes_forget
      braid_done
    · have hab : f pa = f pb := byte_eq_of_word hbr
      have e : (if [f pa] = [f pb] then 1#64 else 0#64) = 1#64 :=
        ite_eq_left (by rw [hab])
      rw [e, hab, equalRoundsLeak_same pa pb _ (f pb) [] []]
      braid_sym_run
      equal_bytes_forget
      braid_done_trace
      simp [equalRoundsLeak]
  | cons c cs ih =>
    intro bs a b pa pb n t4 t5 t hlen he hl hA hB
    obtain ⟨d, ds, rfl⟩ : ∃ d ds, bs = d :: ds := by
      cases bs with
      | nil => simp at hlen
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at he hl hlen
    obtain ⟨ha, rfl, hra⟩ := hA
    obtain ⟨hb, rfl, hrb⟩ := hB
    equal_bytes_loads f, ha, hb
    braid_sym_run
    · have hne : f pa ≠ f pb := fun h => hbr (by rw [h])
      have e : (if f pa :: c :: cs = f pb :: d :: ds then 1#64 else 0#64) = 0#64 :=
        ite_eq_right fun h => hne (List.cons.inj h |>.1)
      rw [e, equalRoundsLeak_differ pa pb _ (c :: cs) (d :: ds) hne]
      braid_sym_run
      equal_bytes_forget
      braid_done
    · have hab : f pa = f pb := byte_eq_of_word hbr
      braid_sym_run
      · have e : (if f pa :: c :: cs = f pb :: d :: ds then 1#64 else 0#64) =
            if c :: cs = d :: ds then 1#64 else 0#64 := by
          rw [hab]
          simp only [List.cons.injEq, true_and]
        rw [e, hab, equalRoundsLeak_same pa pb _ (f pb) (c :: cs) (d :: ds)]
        braid_call ih ds c d (pa + 1#64) (pb + 1#64) (n + 0xffffffffffffffff#64) _ _ _
          (by omega) (by rw [he]; bv_omega) (by omega) hra hrb
        braid_done_trace
        simp
      · exfalso
        have : n + 0xffffffffffffffff#64 ≠ 0#64 := by rw [he]; bv_omega
        exact this hbr

/-- `equal_bytes` compares `n` bytes and reveals `equalBytesLeak` of the two addresses, `n`,
the return address, and the index of the first position where the bytes differ. -/
theorem equal_bytes_trace (f : Word → BitVec 8) (addrs : List Word) (pa pb r t3 t4 t5 : Word)
    (as bs : List (BitVec 8)) (hlen : bs.length = as.length)
    (hl : as.length < 2 ^ 64) (hA : Reads f addrs pa as) (hB : Reads f addrs pb bs)
    (t : Trace) :
    TripleT equal_bytes.program
      (Atoms.interp [.pc 0x10020#64, .reg a0 pa, .reg a1 pb,
        .reg a2 (BitVec.ofNat 64 as.length), .reg a3 t3, .reg a4 t4, .reg a5 t5,
        .prop (cellsOn f addrs), .reg ra r]) t
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (if as = bs then 1#64 else 0#64),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4),
        .prop (regAny a5), .prop (cellsOn f addrs), .reg ra r])
      (t ++ equalBytesLeak pa pb as.length r (firstDiff as bs)) := by
  cases as with
  | nil =>
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    subst hbs
    simp only [List.length_nil, ↓reduceIte]
    braid_sym_run
    equal_bytes_forget
    braid_done_trace
    simp [equalBytesLeak, equalRoundsLeak]
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
    · braid_call equal_bytes_loop_trace f addrs r as bs' a b pa pb _ t4 t5 _
        (by omega) rfl hl hA hB
      braid_done_trace
      simp [equalBytesLeak]

/-- **What `equal_bytes` reveals, on the machine.** A machine that holds the code of
`equal_bytes`, is at its entry, and has the bytes `as` in memory where `a0` points (`ha`), as
many bytes `bs` where `a1` points (`hlen`, `hb`), and their number, below `2 ^ 64`, in `a2`
(`hl`, `hn`), runs to the return address with the trace `equalBytesLeak` of the two
addresses, the number in `a2`, the return address, and the index of
the first position where `as` and `bs` differ, if there is one. The two regions may overlap. -/
theorem equal_bytes_leakage (s : MachineState) (as bs : List (BitVec 8))
    (hcode : ∀ p ∈ equal_bytes_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10020#64)
    (hlen : bs.length = as.length) (hl : as.length < 2 ^ 64)
    (hn : s.getReg .x12 = BitVec.ofNat 64 as.length)
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes s (s.getReg .x10 + BitVec.ofNat 64 i) 1 (as[i].zeroExtend 64))
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.getReg .x11 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64)) :
    ∃ s', RunL s (equalBytesLeak (s.getReg .x10) (s.getReg .x11) (s.getReg .x12).toNat
        (s.getReg .x1)
        (firstDiff as bs)) s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 := by
  have hnat : (s.getReg .x12).toNat = as.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  obtain ⟨hA, hB, hsat⟩ := reads_of_hasBytes s (s.getReg .x10) (s.getReg .x11) as bs ha hb
  obtain ⟨s', σ', hrun, hr, hq⟩ := machine_soundT equal_bytes_lowered
    (equal_bytes_trace _ _ (s.getReg .x10) (s.getReg .x11) (s.getReg .x1)
      (s.getReg .x13) (s.getReg .x14) (s.getReg .x15) as bs hlen hl hA hB []) hcode
    (flat := [.pc 0x10020#64, .reg a0 (s.getReg .x10), .reg a1 (s.getReg .x11),
      .reg a2 (BitVec.ofNat 64 as.length), .reg a3 (s.getReg .x13),
      .reg a4 (s.getReg .x14), .reg a5 (s.getReg .x15)] ++ cellsOnAtoms s.getByte _ ++
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
  refine ⟨s', hrun, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`equal_bytes` reveals where its arguments first differ, and nothing else of them.** Two
machines that hold the code of `equal_bytes`, are at its entry, each with two regions as
`equal_bytes_leakage` asks, and that agree on the two addresses, the length, the return
address, and on the index of the first position where their two regions differ, or on there
being none (`hd`), run with the same trace, whatever the bytes are. So the function is not
constant-time, and what it gives away beyond the public inputs is exactly that index. -/
theorem equal_bytes_leakage_eq (s₁ s₂ : MachineState) (as₁ bs₁ as₂ bs₂ : List (BitVec 8))
    (hcode₁ : ∀ p ∈ equal_bytes_code, s₁.code p.1 = some p.2)
    (hcode₂ : ∀ p ∈ equal_bytes_code, s₂.code p.1 = some p.2)
    (hpc₁ : s₁.pc = 0x10020#64) (hpc₂ : s₂.pc = 0x10020#64)
    (hlen₁ : bs₁.length = as₁.length) (hlen₂ : bs₂.length = as₂.length)
    (hl₁ : as₁.length < 2 ^ 64) (hl₂ : as₂.length < 2 ^ 64)
    (hn₁ : s₁.getReg .x12 = BitVec.ofNat 64 as₁.length)
    (hn₂ : s₂.getReg .x12 = BitVec.ofNat 64 as₂.length)
    (ha₁ : ∀ (i : Nat) (hi : i < as₁.length),
      HasBytes s₁ (s₁.getReg .x10 + BitVec.ofNat 64 i) 1 (as₁[i].zeroExtend 64))
    (hb₁ : ∀ (i : Nat) (hi : i < bs₁.length),
      HasBytes s₁ (s₁.getReg .x11 + BitVec.ofNat 64 i) 1 (bs₁[i].zeroExtend 64))
    (ha₂ : ∀ (i : Nat) (hi : i < as₂.length),
      HasBytes s₂ (s₂.getReg .x10 + BitVec.ofNat 64 i) 1 (as₂[i].zeroExtend 64))
    (hb₂ : ∀ (i : Nat) (hi : i < bs₂.length),
      HasBytes s₂ (s₂.getReg .x11 + BitVec.ofNat 64 i) 1 (bs₂[i].zeroExtend 64))
    (e10 : s₂.getReg .x10 = s₁.getReg .x10) (e11 : s₂.getReg .x11 = s₁.getReg .x11)
    (e12 : s₂.getReg .x12 = s₁.getReg .x12) (e1 : s₂.getReg .x1 = s₁.getReg .x1)
    (hd : firstDiff as₂ bs₂ = firstDiff as₁ bs₁) :
    ∃ tr s₁' s₂', RunL s₁ tr s₁' ∧ RunL s₂ tr s₂' ∧
      s₁'.pc = s₁.getReg .x1 &&& ~~~1#64 ∧ s₂'.pc = s₁.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨s₁', h₁, hp₁⟩ := equal_bytes_leakage s₁ as₁ bs₁ hcode₁ hpc₁ hlen₁ hl₁ hn₁ ha₁ hb₁
  obtain ⟨s₂', h₂, hp₂⟩ := equal_bytes_leakage s₂ as₂ bs₂ hcode₂ hpc₂ hlen₂ hl₂ hn₂ ha₂ hb₂
  simp only [e10, e11, e12, e1, hd] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

/-! ## `equal_bytes_ct` -/

/-- **What `equal_bytes_ct` reveals, on the machine.** A machine that holds the code of
`equal_bytes_ct`, is at its entry, and has the bytes `as` in memory where `a0` points (`ha`), as
many bytes `bs` where `a1` points (`hlen`, `hb`), and their number, below `2 ^ 64`, in `a2`
(`hl`, `hn`), runs to the return address with the trace `equalBytesCtLeak` of the two
addresses, the number in `a2` and the return address. The two regions may overlap. -/
theorem equal_bytes_ct_leakage (s : MachineState) (as bs : List (BitVec 8))
    (hcode : ∀ p ∈ equal_bytes_ct_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10054#64)
    (hlen : bs.length = as.length) (hl : as.length < 2 ^ 64)
    (hn : s.getReg .x12 = BitVec.ofNat 64 as.length)
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes s (s.getReg .x10 + BitVec.ofNat 64 i) 1 (as[i].zeroExtend 64))
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.getReg .x11 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64)) :
    ∃ s', RunL s (equalBytesCtLeak (s.getReg .x10) (s.getReg .x11) (s.getReg .x12).toNat
        (s.getReg .x1)) s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 := by
  have hnat : (s.getReg .x12).toNat = as.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  obtain ⟨hA, hB, hsat⟩ := reads_of_hasBytes s (s.getReg .x10) (s.getReg .x11) as bs ha hb
  obtain ⟨s', σ', hrun, hr, hq⟩ := machine_soundT equal_bytes_ct_lowered
    (equal_bytes_ct_trace _ _ (s.getReg .x10) (s.getReg .x11) (s.getReg .x1)
      (s.getReg .x13) (s.getReg .x14) (s.getReg .x15) as bs hlen hl hA hB []) hcode
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
  refine ⟨s', hrun, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`equal_bytes_ct` reveals nothing of the bytes it compares.** Two machines that hold the
code of `equal_bytes_ct`, are at its entry, each with two regions as `equal_bytes_ct_leakage`
asks, and that agree on the two addresses, the length and the return address, run with the
same trace, whatever the bytes are, and whether they are the same or not. -/
theorem equal_bytes_ct_leakage_eq (s₁ s₂ : MachineState) (as₁ bs₁ as₂ bs₂ : List (BitVec 8))
    (hcode₁ : ∀ p ∈ equal_bytes_ct_code, s₁.code p.1 = some p.2)
    (hcode₂ : ∀ p ∈ equal_bytes_ct_code, s₂.code p.1 = some p.2)
    (hpc₁ : s₁.pc = 0x10054#64) (hpc₂ : s₂.pc = 0x10054#64)
    (hlen₁ : bs₁.length = as₁.length) (hlen₂ : bs₂.length = as₂.length)
    (hl₁ : as₁.length < 2 ^ 64) (hl₂ : as₂.length < 2 ^ 64)
    (hn₁ : s₁.getReg .x12 = BitVec.ofNat 64 as₁.length)
    (hn₂ : s₂.getReg .x12 = BitVec.ofNat 64 as₂.length)
    (ha₁ : ∀ (i : Nat) (hi : i < as₁.length),
      HasBytes s₁ (s₁.getReg .x10 + BitVec.ofNat 64 i) 1 (as₁[i].zeroExtend 64))
    (hb₁ : ∀ (i : Nat) (hi : i < bs₁.length),
      HasBytes s₁ (s₁.getReg .x11 + BitVec.ofNat 64 i) 1 (bs₁[i].zeroExtend 64))
    (ha₂ : ∀ (i : Nat) (hi : i < as₂.length),
      HasBytes s₂ (s₂.getReg .x10 + BitVec.ofNat 64 i) 1 (as₂[i].zeroExtend 64))
    (hb₂ : ∀ (i : Nat) (hi : i < bs₂.length),
      HasBytes s₂ (s₂.getReg .x11 + BitVec.ofNat 64 i) 1 (bs₂[i].zeroExtend 64))
    (e10 : s₂.getReg .x10 = s₁.getReg .x10) (e11 : s₂.getReg .x11 = s₁.getReg .x11)
    (e12 : s₂.getReg .x12 = s₁.getReg .x12) (e1 : s₂.getReg .x1 = s₁.getReg .x1) :
    ∃ tr s₁' s₂', RunL s₁ tr s₁' ∧ RunL s₂ tr s₂' ∧
      s₁'.pc = s₁.getReg .x1 &&& ~~~1#64 ∧ s₂'.pc = s₁.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨s₁', h₁, hp₁⟩ := equal_bytes_ct_leakage s₁ as₁ bs₁ hcode₁ hpc₁ hlen₁ hl₁ hn₁ ha₁ hb₁
  obtain ⟨s₂', h₂, hp₂⟩ := equal_bytes_ct_leakage s₂ as₂ bs₂ hcode₂ hpc₂ hlen₂ hl₂ hn₂ ha₂ hb₂
  simp only [e10, e11, e12, e1] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.Mem.RiscV
