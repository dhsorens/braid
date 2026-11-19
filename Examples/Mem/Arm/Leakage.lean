/-
  Examples.Mem.Arm.Leakage

  What the functions of `mem.c` reveal on AArch64 (`docs/Leakage.md`), each as a traced
  triple, as a theorem about the machine alone, and as a statement about two machines.

  * `copy_bytes` reveals the two addresses, the length and the return address, and nothing
    of the bytes it copies (`copyBytesLeak`).
  * `equal_bytes` is not constant-time: after each pair of bytes it branches on whether they
    differ (`b.ne`), and returns at the first pair that does. Besides the two addresses, the
    length and the return address it reveals exactly the index of the first position where
    the two regions differ, or that there is none (`firstDiff`, `equalBytesLeak`).
  * `equal_bytes_ct` reveals the two addresses, the length and the return address, and
    nothing of the bytes it compares (`equalBytesCtLeak`): its only branches are on the
    length, and its result is made by a conditional set, which reveals nothing.

  Every loop is proved by the induction of its functional proof, with what the rounds still
  to run reveal as a function of the number of rounds. The traced triples carry the
  functional postcondition as well.

  ## Main definitions

  * `copyBytesLeak`, `equalBytesLeak`, `equalBytesCtLeak`: what a run reveals, as a function
    of what is public
  * `firstDiff`: the index of the first position where two lists differ

  ## Main results

  * `copy_bytes_trace`, `copy_bytes_leakage`, `copy_bytes_leakage_eq`
  * `equal_bytes_trace`, `equal_bytes_leakage`, `equal_bytes_leakage_eq`
  * `equal_bytes_ct_trace`, `equal_bytes_ct_leakage`, `equal_bytes_ct_leakage_eq`
  * `reads_of_hasBytes`: two regions of a machine's memory, as one set of bytes
-/

module

public import Examples.Mem.Arm.EqualCt

public section

namespace Examples.Mem.Arm

open Braid Examples Examples.Mem Lowering.Arm Lowering.Arm.Regs

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
    [.read ps 1, .write pd 1, .jump (if n = 0 then 0x10014#64 else 0x10004#64)] ++
      copyRoundsLeak (pd + 1#64) (ps + 1#64) n

/-- What `copy_bytes` reveals: whether there is anything to copy, the address of each byte
read and written, in order, and where it returns. It is a function of the destination `pd`,
the source `ps`, the length `n` and the return address `r`. -/
def copyBytesLeak (pd ps : Word) (n : Nat) (r : Word) : Trace :=
  [.jump (if n = 0 then 0x10014#64 else 0x10004#64)] ++ copyRoundsLeak pd ps n ++ [.jump r]

/-- Forget what `copy_bytes` leaves in the registers it uses and in the flags. -/
local macro "copy_bytes_forget" : tactic =>
  `(tactic| (braid_forget 0; braid_forget 1; braid_forget 8
             braid_forget_flag 0; braid_forget_flag 1; braid_forget_flag 2
             braid_forget_flag 3))

/-- The loop of `copy_bytes`, with what it reveals. -/
theorem copy_bytes_loop_trace (r : Word) : ∀ (ss ds : List (BitVec 8)) (s d : BitVec 8)
    (pd ps n t8 : Word) (fn fz fc fv : Bool) (t : Trace), ds.length = ss.length →
    n = BitVec.ofNat 64 (ss.length + 1) → ss.length + 1 < 2 ^ 64 →
    TripleT copy_bytes.program
      (Atoms.interp [.pc 0x10004#64, .reg x0 pd, .reg x1 ps, .reg x2 n, .reg x8 t8,
        .prop (bytesAt ps (s :: ss)), .prop (bytesAt pd (d :: ds)), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]) t
      (Atoms.interp [.pc r, .prop (regAny x0), .prop (regAny x1), .reg x2 0#64,
        .prop (regAny x8), .prop (bytesAt ps (s :: ss)), .prop (bytesAt pd (s :: ss)),
        .reg lr r, .prop (flagAny Flags.n), .prop (flagAny Flags.z),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)])
      (t ++ (copyRoundsLeak pd ps (ss.length + 1) ++ [.jump r])) := by
  intro ss
  induction ss with
  | nil =>
    intro ds s d pd ps n t8 fn fz fc fv t hlen he hb
    have hds : ds = [] := List.length_eq_zero_iff.1 hlen
    have he' : n = 1#64 := by simpa using he
    subst hds he'
    braid_unfold bytesAt_cons ps s []
    braid_unfold bytesAt_cons pd d []
    braid_sym_run
    braid_fold bytesAt_cons ps s []
    braid_fold bytesAt_cons pd s []
    copy_bytes_forget
    braid_done_trace
    simp [copyRoundsLeak]
  | cons c cs ih =>
    intro ds s d pd ps n t8 fn fz fc fv t hlen he hb
    obtain ⟨d', ds', rfl⟩ : ∃ d' ds', ds = d' :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at he hb hlen
    braid_unfold bytesAt_cons ps s (c :: cs)
    braid_unfold bytesAt_cons pd d (d' :: ds')
    braid_sym_run
    · braid_call ih ds' c d' (pd + 1#64) (ps + 1#64) (n + 0xffffffffffffffff#64) _ _ _ _ _ _
        (by omega) (by rw [he]; bv_omega) (by omega)
      braid_fold bytesAt_cons ps s (c :: cs)
      braid_fold bytesAt_cons pd s (c :: cs)
      braid_done_trace
      simp [copyRoundsLeak]
    · exfalso
      have : n ≠ 1#64 := by rw [he]; bv_omega
      exact this hbr

/-- `copy_bytes` copies `n` bytes and reveals `copyBytesLeak` of the two addresses, `n` and
the return address. -/
theorem copy_bytes_trace (pd ps r t8 : Word) (ss ds : List (BitVec 8)) (fn fz fc fv : Bool)
    (hlen : ds.length = ss.length) (hl : ss.length < 2 ^ 64) (t : Trace) :
    TripleT copy_bytes.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 pd, .reg x1 ps,
        .reg x2 (BitVec.ofNat 64 ss.length), .reg x8 t8,
        .prop (bytesAt ps ss), .prop (bytesAt pd ds), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]) t
      (Atoms.interp [.pc r, .prop (regAny x0), .prop (regAny x1), .reg x2 0#64,
        .prop (regAny x8), .prop (bytesAt ps ss), .prop (bytesAt pd ss),
        .reg lr r, .prop (flagAny Flags.n), .prop (flagAny Flags.z),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)])
      (t ++ copyBytesLeak pd ps ss.length r) := by
  cases ss with
  | nil =>
    have hds : ds = [] := List.length_eq_zero_iff.1 hlen
    subst hds
    simp only [List.length_nil]
    braid_sym_run
    copy_bytes_forget
    braid_done_trace
    simp [copyBytesLeak, copyRoundsLeak]
  | cons s ss =>
    obtain ⟨d, ds', rfl⟩ : ∃ d ds', ds = d :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at hl hlen ⊢
    braid_sym_step
    · braid_call copy_bytes_loop_trace r ss ds' s d pd ps _ t8 fn fz fc fv _ (by omega) rfl hl
      braid_done_trace
      simp [copyBytesLeak]
    · exfalso
      have : BitVec.ofNat 64 (ss.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr

/-- **What `copy_bytes` reveals, on the machine.** A running machine whose program holds the
words of `copy_bytes` (`hw`), with its code loaded (`hc`) and its program counter at the
entry (`hpc`), with the bytes `ss` in memory where `x1` points (`hsrc`), as many bytes `ds`
where `x0` points (`hlen`, `hdst`), apart from the first (`hapart`), and their number in `x2`
(`hn`), runs to the address in the link register with the trace `copyBytesLeak` of the two
addresses, the number in `x2` and the link register. -/
theorem copy_bytes_leakage (prog : Arm64.Program) (s : Arm64.State) (ss ds : List (BitVec 8))
    (hw : prog.hasWords 0x10000#64 copy_bytes_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64) (hlen : ds.length = ss.length)
    (hn : s.regs.read 2#5 = BitVec.ofNat 64 ss.length)
    (hsrc : ∀ (i : Nat) (hi : i < ss.length),
      HasBytes s (s.regs.read 1#5 + BitVec.ofNat 64 i) 1 (ss[i].zeroExtend 64))
    (hdst : ∀ (i : Nat) (hi : i < ds.length),
      HasBytes s (s.regs.read 0#5 + BitVec.ofNat 64 i) 1 (ds[i].zeroExtend 64))
    (hapart : Apart (s.regs.read 1#5) ss.length (s.regs.read 0#5) ds.length) :
    ∃ s', RunL prog s (copyBytesLeak (s.regs.read 0#5) (s.regs.read 1#5)
        (s.regs.read 2#5).toNat (s.regs.read 30#5)) s' ∧ s'.pc = s.regs.read 30#5 := by
  have hl : ss.length < 2 ^ 64 := by
    have := (s.regs.read 0#5 - s.regs.read 1#5).isLt
    have := hapart.1
    omega
  have hnat : (s.regs.read 2#5).toNat = ss.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_soundT copy_bytes_lowered
    (copy_bytes_trace (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5) (s.regs.read 8#5)
      ss ds s.pstate.n s.pstate.z s.pstate.c s.pstate.v hlen hl []) hw hc hrun
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
  refine ⟨s', hsteps, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`copy_bytes` reveals nothing of the bytes it copies.** Two running machines that hold
the words of `copy_bytes`, with their code loaded and at its entry, each with a source and a
destination as `copy_bytes_leakage` asks, and that agree on the two addresses, the length
and the link register, run with the same trace, whatever the bytes are. -/
theorem copy_bytes_leakage_eq (prog₁ prog₂ : Arm64.Program) (s₁ s₂ : Arm64.State)
    (ss₁ ds₁ ss₂ ds₂ : List (BitVec 8))
    (hw₁ : prog₁.hasWords 0x10000#64 copy_bytes_words) (hc₁ : prog₁.CodeLoaded s₁.mem)
    (hw₂ : prog₂.hasWords 0x10000#64 copy_bytes_words) (hc₂ : prog₂.CodeLoaded s₂.mem)
    (hrun₁ : s₁.status = .Running) (hrun₂ : s₂.status = .Running)
    (hpc₁ : s₁.pc = 0x10000#64) (hpc₂ : s₂.pc = 0x10000#64)
    (hlen₁ : ds₁.length = ss₁.length) (hlen₂ : ds₂.length = ss₂.length)
    (hn₁ : s₁.regs.read 2#5 = BitVec.ofNat 64 ss₁.length)
    (hn₂ : s₂.regs.read 2#5 = BitVec.ofNat 64 ss₂.length)
    (hsrc₁ : ∀ (i : Nat) (hi : i < ss₁.length),
      HasBytes s₁ (s₁.regs.read 1#5 + BitVec.ofNat 64 i) 1 (ss₁[i].zeroExtend 64))
    (hdst₁ : ∀ (i : Nat) (hi : i < ds₁.length),
      HasBytes s₁ (s₁.regs.read 0#5 + BitVec.ofNat 64 i) 1 (ds₁[i].zeroExtend 64))
    (hsrc₂ : ∀ (i : Nat) (hi : i < ss₂.length),
      HasBytes s₂ (s₂.regs.read 1#5 + BitVec.ofNat 64 i) 1 (ss₂[i].zeroExtend 64))
    (hdst₂ : ∀ (i : Nat) (hi : i < ds₂.length),
      HasBytes s₂ (s₂.regs.read 0#5 + BitVec.ofNat 64 i) 1 (ds₂[i].zeroExtend 64))
    (hapart₁ : Apart (s₁.regs.read 1#5) ss₁.length (s₁.regs.read 0#5) ds₁.length)
    (hapart₂ : Apart (s₂.regs.read 1#5) ss₂.length (s₂.regs.read 0#5) ds₂.length)
    (e0 : s₂.regs.read 0#5 = s₁.regs.read 0#5) (e1 : s₂.regs.read 1#5 = s₁.regs.read 1#5)
    (e2 : s₂.regs.read 2#5 = s₁.regs.read 2#5)
    (e30 : s₂.regs.read 30#5 = s₁.regs.read 30#5) :
    ∃ tr s₁' s₂', RunL prog₁ s₁ tr s₁' ∧ RunL prog₂ s₂ tr s₂' ∧
      s₁'.pc = s₁.regs.read 30#5 ∧ s₂'.pc = s₁.regs.read 30#5 := by
  obtain ⟨s₁', h₁, hp₁⟩ := copy_bytes_leakage prog₁ s₁ ss₁ ds₁ hw₁ hc₁ hrun₁ hpc₁ hlen₁ hn₁
    hsrc₁ hdst₁ hapart₁
  obtain ⟨s₂', h₂, hp₂⟩ := copy_bytes_leakage prog₂ s₂ ss₂ ds₂ hw₂ hc₂ hrun₂ hpc₂ hlen₂ hn₂
    hsrc₂ hdst₂ hapart₂
  simp only [e0, e1, e2, e30] at h₂ hp₂
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
  | _ + 1, some 0 => [.read pa 1, .read pb 1, .jump 0x10048#64]
  | n + 1, some (k + 1) =>
    [.read pa 1, .read pb 1, .jump 0x10034#64,
      .jump (if n = 0 then 0x1003c#64 else 0x10024#64)] ++
      equalRoundsLeak (pa + 1#64) (pb + 1#64) n (some k)
  | n + 1, none =>
    [.read pa 1, .read pb 1, .jump 0x10034#64,
      .jump (if n = 0 then 0x1003c#64 else 0x10024#64)] ++
      equalRoundsLeak (pa + 1#64) (pb + 1#64) n none

/-- What `equal_bytes` reveals: whether there is anything to compare, the addresses of the
bytes it reads, up to and including the first two that differ, and where it returns. It is a
function of the two addresses `pa` and `pb`, the length `n`, the return address `r`, and the
index `d` of the first position where the two regions differ, if there is one. It takes
nothing else of the bytes. -/
def equalBytesLeak (pa pb : Word) (n : Nat) (r : Word) (d : Option Nat) : Trace :=
  [.jump (if n = 0 then 0x10040#64 else 0x1001c#64)] ++ equalRoundsLeak pa pb n d ++
    [.jump r]

/-- A round of `equal_bytes` whose two bytes differ is the last. -/
theorem equalRoundsLeak_differ (pa pb : Word) (n : Nat) {a b : BitVec 8}
    (as bs : List (BitVec 8)) (h : a ≠ b) :
    equalRoundsLeak pa pb (n + 1) (firstDiff (a :: as) (b :: bs)) =
      [.read pa 1, .read pb 1, .jump 0x10048#64] := by
  simp [firstDiff, h, equalRoundsLeak]

/-- A round of `equal_bytes` whose two bytes are the same, and the rounds after it. -/
theorem equalRoundsLeak_same (pa pb : Word) (n : Nat) (a : BitVec 8)
    (as bs : List (BitVec 8)) :
    equalRoundsLeak pa pb (n + 1) (firstDiff (a :: as) (a :: bs)) =
      [.read pa 1, .read pb 1, .jump 0x10034#64,
        .jump (if n = 0 then 0x1003c#64 else 0x10024#64)] ++
        equalRoundsLeak (pa + 1#64) (pb + 1#64) n (firstDiff as bs) := by
  simp only [firstDiff, ↓reduceIte]
  cases firstDiff as bs <;> simp [equalRoundsLeak]

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

/-- The loop of `equal_bytes`, with what it reveals. -/
theorem equal_bytes_loop_trace (f : Word → BitVec 8) (addrs : List Word) (r : Word) :
    ∀ (as bs : List (BitVec 8)) (a b : BitVec 8) (pa pb n t9 t10 : Word)
    (fn fz fc fv : Bool) (t : Trace), bs.length = as.length →
    n = BitVec.ofNat 64 (as.length + 1) →
    as.length + 1 < 2 ^ 64 → Reads f addrs pa (a :: as) → Reads f addrs pb (b :: bs) →
    TripleT equal_bytes.program
      (Atoms.interp [.pc 0x10024#64, .reg x0 1#64, .reg x1 pb, .reg x2 n, .reg x8 pa,
        .reg x9 t9, .reg x10 t10, .prop (cellsOn f addrs), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]) t
      (Atoms.interp [.pc r, .reg x0 (if a :: as = b :: bs then 1#64 else 0#64),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .prop (cellsOn f addrs), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)])
      (t ++ (equalRoundsLeak pa pb (as.length + 1) (firstDiff (a :: as) (b :: bs)) ++
        [.jump r])) := by
  intro as
  induction as with
  | nil =>
    intro bs a b pa pb n t9 t10 fn fz fc fv t hlen he hl hA hB
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
      braid_done_trace
      simp
    · have hab : f pa = f pb := byte_eq_of_cmp hbr
      have e : (if [f pa] = [f pb] then 1#64 else 0#64) = 1#64 :=
        ite_eq_left (by rw [hab])
      rw [e, hab, equalRoundsLeak_same pa pb _ (f pb) [] []]
      braid_sym_run
      equal_bytes_forget
      braid_done_trace
      simp [equalRoundsLeak]
  | cons c cs ih =>
    intro bs a b pa pb n t9 t10 fn fz fc fv t hlen he hl hA hB
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
      braid_done_trace
      simp
    · have hab : f pa = f pb := byte_eq_of_cmp hbr
      braid_sym_run
      · have e : (if f pa :: c :: cs = f pb :: d :: ds then 1#64 else 0#64) =
            if c :: cs = d :: ds then 1#64 else 0#64 := by
          rw [hab]
          simp only [List.cons.injEq, true_and]
        rw [e, hab, equalRoundsLeak_same pa pb _ (f pb) (c :: cs) (d :: ds)]
        braid_call ih ds c d (pa + 1#64) (pb + 1#64) (n + 0xffffffffffffffff#64) _ _ _ _ _ _
          _ (by omega) (by rw [he]; bv_omega) (by omega) hra hrb
        braid_done_trace
        simp
      · exfalso
        have : n ≠ 1#64 := by rw [he]; bv_omega
        exact this hbr

/-- `equal_bytes` compares `n` bytes and reveals `equalBytesLeak` of the two addresses, `n`,
the return address, and the index of the first position where the bytes differ. -/
theorem equal_bytes_trace (f : Word → BitVec 8) (addrs : List Word)
    (pa pb r t8 t9 t10 : Word) (as bs : List (BitVec 8)) (fn fz fc fv : Bool)
    (hlen : bs.length = as.length) (hl : as.length < 2 ^ 64) (hA : Reads f addrs pa as)
    (hB : Reads f addrs pb bs) (t : Trace) :
    TripleT equal_bytes.program
      (Atoms.interp [.pc 0x10018#64, .reg x0 pa, .reg x1 pb,
        .reg x2 (BitVec.ofNat 64 as.length), .reg x8 t8, .reg x9 t9, .reg x10 t10,
        .prop (cellsOn f addrs), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]) t
      (Atoms.interp [.pc r, .reg x0 (if as = bs then 1#64 else 0#64),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .prop (cellsOn f addrs), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)])
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
    · braid_call equal_bytes_loop_trace f addrs r as bs' a b pa pb _ t9 t10 fn fz fc fv _
        (by omega) rfl hl hA hB
      braid_done_trace
      simp [equalBytesLeak]
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr

/-! ## Two regions that may overlap, on the machine -/

/-- **Two regions of a machine's memory, as one set of bytes.** If the machine has the bytes
`as` from `pa` on and the bytes `bs` from `pb` on, both are read through the set of the
machine's bytes at the addresses of the two regions, each address once, and every byte of
that set is in the machine's memory. The regions may overlap. -/
theorem reads_of_hasBytes (s : Arm64.State) (pa pb : Word) (as bs : List (BitVec 8))
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes s (pa + BitVec.ofNat 64 i) 1 (as[i].zeroExtend 64))
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (pb + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64)) :
    Reads s.mem.read8 (dedup (addrsFrom pa as.length ++ addrsFrom pb bs.length)) pa as ∧
    Reads s.mem.read8 (dedup (addrsFrom pa as.length ++ addrsFrom pb bs.length)) pb bs ∧
    ∀ x ∈ dedup (addrsFrom pa as.length ++ addrsFrom pb bs.length),
      (Atom.mem x 1 ((s.mem.read8 x).zeroExtend 64) true).sat (abs s) := by
  refine ⟨reads_of_forall fun i hi => ⟨mem_dedup.2 (List.mem_append_left _
      (mem_addrsFrom.2 ⟨i, hi, rfl⟩)), read8_of_hasBytes (ha i hi)⟩,
    reads_of_forall fun i hi => ⟨mem_dedup.2 (List.mem_append_right _
      (mem_addrsFrom.2 ⟨i, hi, rfl⟩)), read8_of_hasBytes (hb i hi)⟩, fun x hx => ?_⟩
  refine sat_mem_hasBytes.2 ?_
  rcases List.mem_append.1 (mem_dedup.1 hx) with h | h
  · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
    exact hasBytes_read8 (ha i hi)
  · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
    exact hasBytes_read8 (hb i hi)

/-- **What `equal_bytes` reveals, on the machine.** A running machine whose program holds
the words of `equal_bytes` (`hw`), with its code loaded (`hc`) and its program counter at
the entry (`hpc`), with the bytes `as` in memory where `x0` points (`ha`), as many bytes `bs`
where `x1` points (`hlen`, `hb`), and their number, below `2 ^ 64`, in `x2` (`hl`, `hn`),
runs to the address in the link register with the trace `equalBytesLeak` of the two
addresses, the number in `x2`, the link register, and the index of the first position where
`as` and `bs` differ, if there is one. The two regions may overlap. -/
theorem equal_bytes_leakage (prog : Arm64.Program) (s : Arm64.State) (as bs : List (BitVec 8))
    (hw : prog.hasWords 0x10018#64 equal_bytes_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10018#64) (hlen : bs.length = as.length)
    (hl : as.length < 2 ^ 64) (hn : s.regs.read 2#5 = BitVec.ofNat 64 as.length)
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes s (s.regs.read 0#5 + BitVec.ofNat 64 i) 1 (as[i].zeroExtend 64))
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.regs.read 1#5 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64)) :
    ∃ s', RunL prog s (equalBytesLeak (s.regs.read 0#5) (s.regs.read 1#5)
        (s.regs.read 2#5).toNat (s.regs.read 30#5) (firstDiff as bs)) s' ∧
      s'.pc = s.regs.read 30#5 := by
  have hnat : (s.regs.read 2#5).toNat = as.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  obtain ⟨hA, hB, hsat⟩ := reads_of_hasBytes s (s.regs.read 0#5) (s.regs.read 1#5) as bs ha hb
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_soundT equal_bytes_lowered
    (equal_bytes_trace _ _ (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5)
      (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5) as bs s.pstate.n s.pstate.z
      s.pstate.c s.pstate.v hlen hl hA hB []) hw hc hrun
    (flat := [.pc 0x10018#64, .reg x0 (s.regs.read 0#5), .reg x1 (s.regs.read 1#5),
      .reg x2 (BitVec.ofNat 64 as.length), .reg x8 (s.regs.read 8#5),
      .reg x9 (s.regs.read 9#5), .reg x10 (s.regs.read 10#5)] ++
      cellsOnAtoms s.mem.read8 _ ++
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
  refine ⟨s', hsteps, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`equal_bytes` reveals where its arguments first differ, and nothing else of them.** Two
running machines that hold the words of `equal_bytes`, with their code loaded and at its
entry, each with two regions as `equal_bytes_leakage` asks, and that agree on the two
addresses, the length, the link register, and on the index of the first position where their
two regions differ, or on there being none (`hd`), run with the same trace, whatever the
bytes are. So the function is not constant-time, and what it gives away beyond the public
inputs is exactly that index. -/
theorem equal_bytes_leakage_eq (prog₁ prog₂ : Arm64.Program) (s₁ s₂ : Arm64.State)
    (as₁ bs₁ as₂ bs₂ : List (BitVec 8))
    (hw₁ : prog₁.hasWords 0x10018#64 equal_bytes_words) (hc₁ : prog₁.CodeLoaded s₁.mem)
    (hw₂ : prog₂.hasWords 0x10018#64 equal_bytes_words) (hc₂ : prog₂.CodeLoaded s₂.mem)
    (hrun₁ : s₁.status = .Running) (hrun₂ : s₂.status = .Running)
    (hpc₁ : s₁.pc = 0x10018#64) (hpc₂ : s₂.pc = 0x10018#64)
    (hlen₁ : bs₁.length = as₁.length) (hlen₂ : bs₂.length = as₂.length)
    (hl₁ : as₁.length < 2 ^ 64) (hl₂ : as₂.length < 2 ^ 64)
    (hn₁ : s₁.regs.read 2#5 = BitVec.ofNat 64 as₁.length)
    (hn₂ : s₂.regs.read 2#5 = BitVec.ofNat 64 as₂.length)
    (ha₁ : ∀ (i : Nat) (hi : i < as₁.length),
      HasBytes s₁ (s₁.regs.read 0#5 + BitVec.ofNat 64 i) 1 (as₁[i].zeroExtend 64))
    (hb₁ : ∀ (i : Nat) (hi : i < bs₁.length),
      HasBytes s₁ (s₁.regs.read 1#5 + BitVec.ofNat 64 i) 1 (bs₁[i].zeroExtend 64))
    (ha₂ : ∀ (i : Nat) (hi : i < as₂.length),
      HasBytes s₂ (s₂.regs.read 0#5 + BitVec.ofNat 64 i) 1 (as₂[i].zeroExtend 64))
    (hb₂ : ∀ (i : Nat) (hi : i < bs₂.length),
      HasBytes s₂ (s₂.regs.read 1#5 + BitVec.ofNat 64 i) 1 (bs₂[i].zeroExtend 64))
    (e0 : s₂.regs.read 0#5 = s₁.regs.read 0#5) (e1 : s₂.regs.read 1#5 = s₁.regs.read 1#5)
    (e2 : s₂.regs.read 2#5 = s₁.regs.read 2#5)
    (e30 : s₂.regs.read 30#5 = s₁.regs.read 30#5)
    (hd : firstDiff as₂ bs₂ = firstDiff as₁ bs₁) :
    ∃ tr s₁' s₂', RunL prog₁ s₁ tr s₁' ∧ RunL prog₂ s₂ tr s₂' ∧
      s₁'.pc = s₁.regs.read 30#5 ∧ s₂'.pc = s₁.regs.read 30#5 := by
  obtain ⟨s₁', h₁, hp₁⟩ := equal_bytes_leakage prog₁ s₁ as₁ bs₁ hw₁ hc₁ hrun₁ hpc₁ hlen₁ hl₁
    hn₁ ha₁ hb₁
  obtain ⟨s₂', h₂, hp₂⟩ := equal_bytes_leakage prog₂ s₂ as₂ bs₂ hw₂ hc₂ hrun₂ hpc₂ hlen₂ hl₂
    hn₂ ha₂ hb₂
  simp only [e0, e1, e2, e30, hd] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

/-! ## `equal_bytes_ct` -/

/-- What `n` rounds of the loop of `equal_bytes_ct` reveal: in each, the addresses of the two
bytes read, and whether the loop goes round again, which is whether it is the last of the
`n`. -/
def ctRoundsLeak (pa pb : Word) : Nat → Trace
  | 0 => []
  | n + 1 =>
    [.read pa 1, .read pb 1, .jump (if n = 0 then 0x10070#64 else 0x10058#64)] ++
      ctRoundsLeak (pa + 1#64) (pb + 1#64) n

/-- What `equal_bytes_ct` reveals: whether there is anything to compare, the addresses of all
the bytes, in order, and where it returns. It is a function of the two addresses `pa` and
`pb`, the length `n` and the return address `r`, and of nothing else. -/
def equalBytesCtLeak (pa pb : Word) (n : Nat) (r : Word) : Trace :=
  [.jump (if n = 0 then 0x1007c#64 else 0x10054#64)] ++ ctRoundsLeak pa pb n ++ [.jump r]

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

/-- The loop of `equal_bytes_ct`, with what it reveals: `ctRoundsLeak`, which does not
mention the bytes. -/
theorem equal_bytes_ct_loop_trace (f : Word → BitVec 8) (addrs : List Word) (r : Word) :
    ∀ (as bs : List (BitVec 8)) (a b d : BitVec 8) (pa pb n t9 t10 : Word)
    (fn fz fc fv : Bool) (t : Trace), bs.length = as.length →
    n = BitVec.ofNat 64 (as.length + 1) →
    as.length + 1 < 2 ^ 64 → Reads f addrs pa (a :: as) → Reads f addrs pb (b :: bs) →
    TripleT equal_bytes_ct.program
      (Atoms.interp [.pc 0x10058#64, .reg x0 pa, .reg x1 pb, .reg x2 n,
        .reg x8 (d.zeroExtend 64), .reg x9 t9, .reg x10 t10, .prop (cellsOn f addrs),
        .reg lr r, .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]) t
      (Atoms.interp [.pc r,
        .reg x0 (if orDiff d (a :: as) (b :: bs) = 0#8 then 1#64 else 0#64),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .prop (cellsOn f addrs), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)])
      (t ++ (ctRoundsLeak pa pb (as.length + 1) ++ [.jump r])) := by
  intro as
  induction as with
  | nil =>
    intro bs a b d pa pb n t9 t10 fn fz fc fv t hlen he hl hA hB
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    have he' : n = 1#64 := by simpa using he
    subst hbs he'
    obtain ⟨ha, rfl, -⟩ := hA
    obtain ⟨hb, rfl, -⟩ := hB
    equal_bytes_ct_loads f, ha, hb
    braid_sym_run
    rw [acc_round, result_eq, orDiff_cons, orDiff_nil]
    equal_bytes_ct_forget
    braid_done_trace
    simp [ctRoundsLeak]
  | cons c cs ih =>
    intro bs a b d pa pb n t9 t10 fn fz fc fv t hlen he hl hA hB
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
        _ (by omega) (by rw [he]; bv_omega) (by omega) hra hrb
      braid_norm
      refine TripleT.done_eq rfl ?_
      simp [ctRoundsLeak]
    · exfalso
      have : n ≠ 1#64 := by rw [he]; bv_omega
      exact this hbr

/-- `equal_bytes_ct` returns one if the `n` bytes its first argument points to are those its
second argument points to, and zero otherwise, and reveals `equalBytesCtLeak` of the two
addresses, `n` and the return address. The bytes are read through one set of bytes, so the
two regions may overlap. -/
theorem equal_bytes_ct_trace (f : Word → BitVec 8) (addrs : List Word)
    (pa pb r t8 t9 t10 : Word) (as bs : List (BitVec 8)) (fn fz fc fv : Bool)
    (hlen : bs.length = as.length) (hl : as.length < 2 ^ 64) (hA : Reads f addrs pa as)
    (hB : Reads f addrs pb bs) (t : Trace) :
    TripleT equal_bytes_ct.program
      (Atoms.interp [.pc 0x10050#64, .reg x0 pa, .reg x1 pb,
        .reg x2 (BitVec.ofNat 64 as.length), .reg x8 t8, .reg x9 t9, .reg x10 t10,
        .prop (cellsOn f addrs), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv]) t
      (Atoms.interp [.pc r, .reg x0 (if as = bs then 1#64 else 0#64),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .prop (cellsOn f addrs), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v)])
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
    have e : (if a :: as = b :: bs' then 1#64 else 0#64) =
        if orDiff 0#8 (a :: as) (b :: bs') = 0#8 then 1#64 else 0#64 := by
      simp only [orDiff_zero _ _ hlen]
    rw [e]
    simp only [List.length_cons] at hl hlen ⊢
    braid_sym_run
    · braid_call equal_bytes_ct_loop_trace f addrs r as bs' a b 0#8 pa pb _ t9 t10 fn fz fc fv
        _ (by omega) rfl hl hA hB
      braid_done_trace
      simp [equalBytesCtLeak]
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr

/-- **What `equal_bytes_ct` reveals, on the machine.** A running machine whose program holds
the words of `equal_bytes_ct` (`hw`), with its code loaded (`hc`) and its program counter at
the entry (`hpc`), with the bytes `as` in memory where `x0` points (`ha`), as many bytes `bs`
where `x1` points (`hlen`, `hb`), and their number, below `2 ^ 64`, in `x2` (`hl`, `hn`),
runs to the address in the link register with the trace `equalBytesCtLeak` of the two
addresses, the number in `x2` and the link register. The two regions may overlap. -/
theorem equal_bytes_ct_leakage (prog : Arm64.Program) (s : Arm64.State)
    (as bs : List (BitVec 8)) (hw : prog.hasWords 0x10050#64 equal_bytes_ct_words)
    (hc : prog.CodeLoaded s.mem) (hrun : s.status = .Running) (hpc : s.pc = 0x10050#64)
    (hlen : bs.length = as.length) (hl : as.length < 2 ^ 64)
    (hn : s.regs.read 2#5 = BitVec.ofNat 64 as.length)
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes s (s.regs.read 0#5 + BitVec.ofNat 64 i) 1 (as[i].zeroExtend 64))
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.regs.read 1#5 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64)) :
    ∃ s', RunL prog s (equalBytesCtLeak (s.regs.read 0#5) (s.regs.read 1#5)
        (s.regs.read 2#5).toNat (s.regs.read 30#5)) s' ∧ s'.pc = s.regs.read 30#5 := by
  have hnat : (s.regs.read 2#5).toNat = as.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  obtain ⟨hA, hB, hsat⟩ := reads_of_hasBytes s (s.regs.read 0#5) (s.regs.read 1#5) as bs ha hb
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_soundT equal_bytes_ct_lowered
    (equal_bytes_ct_trace _ _ (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5)
      (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5) as bs s.pstate.n s.pstate.z
      s.pstate.c s.pstate.v hlen hl hA hB []) hw hc hrun
    (flat := [.pc 0x10050#64, .reg x0 (s.regs.read 0#5), .reg x1 (s.regs.read 1#5),
      .reg x2 (BitVec.ofNat 64 as.length), .reg x8 (s.regs.read 8#5),
      .reg x9 (s.regs.read 9#5), .reg x10 (s.regs.read 10#5)] ++
      cellsOnAtoms s.mem.read8 _ ++
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
  refine ⟨s', hsteps, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`equal_bytes_ct` reveals nothing of the bytes it compares.** Two running machines that
hold the words of `equal_bytes_ct`, with their code loaded and at its entry, each with two
regions as `equal_bytes_ct_leakage` asks, and that agree on the two addresses, the length
and the link register, run with the same trace, whatever the bytes are, and whether they are
the same or not. -/
theorem equal_bytes_ct_leakage_eq (prog₁ prog₂ : Arm64.Program) (s₁ s₂ : Arm64.State)
    (as₁ bs₁ as₂ bs₂ : List (BitVec 8))
    (hw₁ : prog₁.hasWords 0x10050#64 equal_bytes_ct_words) (hc₁ : prog₁.CodeLoaded s₁.mem)
    (hw₂ : prog₂.hasWords 0x10050#64 equal_bytes_ct_words) (hc₂ : prog₂.CodeLoaded s₂.mem)
    (hrun₁ : s₁.status = .Running) (hrun₂ : s₂.status = .Running)
    (hpc₁ : s₁.pc = 0x10050#64) (hpc₂ : s₂.pc = 0x10050#64)
    (hlen₁ : bs₁.length = as₁.length) (hlen₂ : bs₂.length = as₂.length)
    (hl₁ : as₁.length < 2 ^ 64) (hl₂ : as₂.length < 2 ^ 64)
    (hn₁ : s₁.regs.read 2#5 = BitVec.ofNat 64 as₁.length)
    (hn₂ : s₂.regs.read 2#5 = BitVec.ofNat 64 as₂.length)
    (ha₁ : ∀ (i : Nat) (hi : i < as₁.length),
      HasBytes s₁ (s₁.regs.read 0#5 + BitVec.ofNat 64 i) 1 (as₁[i].zeroExtend 64))
    (hb₁ : ∀ (i : Nat) (hi : i < bs₁.length),
      HasBytes s₁ (s₁.regs.read 1#5 + BitVec.ofNat 64 i) 1 (bs₁[i].zeroExtend 64))
    (ha₂ : ∀ (i : Nat) (hi : i < as₂.length),
      HasBytes s₂ (s₂.regs.read 0#5 + BitVec.ofNat 64 i) 1 (as₂[i].zeroExtend 64))
    (hb₂ : ∀ (i : Nat) (hi : i < bs₂.length),
      HasBytes s₂ (s₂.regs.read 1#5 + BitVec.ofNat 64 i) 1 (bs₂[i].zeroExtend 64))
    (e0 : s₂.regs.read 0#5 = s₁.regs.read 0#5) (e1 : s₂.regs.read 1#5 = s₁.regs.read 1#5)
    (e2 : s₂.regs.read 2#5 = s₁.regs.read 2#5)
    (e30 : s₂.regs.read 30#5 = s₁.regs.read 30#5) :
    ∃ tr s₁' s₂', RunL prog₁ s₁ tr s₁' ∧ RunL prog₂ s₂ tr s₂' ∧
      s₁'.pc = s₁.regs.read 30#5 ∧ s₂'.pc = s₁.regs.read 30#5 := by
  obtain ⟨s₁', h₁, hp₁⟩ := equal_bytes_ct_leakage prog₁ s₁ as₁ bs₁ hw₁ hc₁ hrun₁ hpc₁ hlen₁
    hl₁ hn₁ ha₁ hb₁
  obtain ⟨s₂', h₂, hp₂⟩ := equal_bytes_ct_leakage prog₂ s₂ as₂ bs₂ hw₂ hc₂ hrun₂ hpc₂ hlen₂
    hl₂ hn₂ ha₂ hb₂
  simp only [e0, e1, e2, e30] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.Mem.Arm
