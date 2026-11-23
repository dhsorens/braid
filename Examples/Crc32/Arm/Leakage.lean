/-
  Examples.Crc32.Arm.Leakage

  What `crc32` reveals on AArch64 (`docs/Leakage.md`). It is not constant-time: each byte of
  the message is taken into the register through two lookups in the table, and the address
  of a lookup (`ldr w10, [x8, w10, uxtw #2]`) is the table's address and an index that is
  four bits of the register. A run reveals, besides the address and the length of the
  message, the table's address and the return address, exactly the sequence of those
  indices, two for each byte (`crcIndices`), which is a function of the value `crc32`
  continues from and of the message.

  The indices reveal the message. The first index of a byte is the low four bits of the
  register with the byte added, and the second the low four bits four bits of the division
  later, so, the register before the byte being known, the two give the byte; a watcher who
  knows the starting value recovers every byte in turn (`crcIndices_inj`). A watcher who does
  not know it still learns the low four bits of the register at every lookup.

  ## Main definitions

  * `tableIndices`, `crcIndices`: the table indices of a message, in plain Lean
  * `crc32Leak`: what a run reveals, as a function of what is public and of those indices

  ## Main results

  * `crc32_trace`: the traced triple
  * `crc32_leakage`: the same, about the machine alone
  * `crc32_leakage_eq`: two machines that agree on what is public and on the indices run with
    the same trace
  * `crcIndices_inj`: from the same starting value, the indices determine the message
-/

module

public import Examples.Crc32.Arm.Proofs

public section

namespace Examples.Crc32.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- Finish a traced triple whose trace needs a proof of its own: the symbolic state is the
postcondition, and the equation between the traces is left as the goal. -/
local macro "braid_done_trace" : tactic =>
  `(tactic| (braid_norm; refine TripleT.done_split (by braid_split) ?_))

/-! ## The table indices of a message -/

/-- The indices at which the table is read while the bytes `bs` are taken into the register
`c`, two for each byte: the low four bits of the register with the byte added, and the low
four bits of the register four bits of the division later. -/
def tableIndices (c : BitVec 32) : List (BitVec 8) → List (BitVec 4)
  | [] => []
  | b :: bs =>
    (c ^^^ b.zeroExtend 32).truncate 4 :: (nibble (c ^^^ b.zeroExtend 32)).truncate 4 ::
      tableIndices (byte c b) bs

/-- The indices at which `crc32` reads the table for the bytes `bs`, continuing from `crc`:
the register starts as the complement of `crc`. -/
def crcIndices (crc : BitVec 32) (bs : List (BitVec 8)) : List (BitVec 4) :=
  tableIndices (~~~crc) bs

/-- The address of entry `i` of a table at `tbl`. -/
def entryAddr (tbl : Word) (i : BitVec 4) : Word := tbl + i.zeroExtend 64 <<< 2#64

/-- What the rounds of the loop of `crc32` reveal, for a message at `p` and a table at `tbl`,
from the table indices of the bytes still to take, two for each: in each round, the address
of the byte read, the addresses of the two entries of the table read, and whether the loop
goes round again, which is whether indices are left. -/
def crcRoundsLeak (tbl p : Word) : List (BitVec 4) → Trace
  | i :: j :: is =>
    [.read p 1, .read (entryAddr tbl i) 4, .read (entryAddr tbl j) 4,
      .jump (if is = [] then 0x10038#64 else 0x10010#64)] ++ crcRoundsLeak tbl (p + 1#64) is
  | _ => []

/-- What `crc32` reveals: whether there is a message, for each byte its address and the
addresses of the two entries of the table read for it, and where it returns. It is a
function of the table's address `tbl`, the message's address `p` and length `n`, the return
address `r`, and the table indices `is` of the message, two for each byte. It takes nothing
else of the message or of the starting value; but the indices are a function of both, and
with the starting value they give the message back (`crcIndices_inj`). -/
def crc32Leak (tbl p : Word) (n : Nat) (r : Word) (is : List (BitVec 4)) : Trace :=
  [.jump (if n = 0 then 0x1003c#64 else 0x10004#64)] ++ crcRoundsLeak tbl p is ++ [.jump r]

/-- **The indices reveal the message.** From the same register, two messages with the same
table indices are the same message. -/
theorem tableIndices_inj : ∀ (c : BitVec 32) (bs bs' : List (BitVec 8)),
    tableIndices c bs = tableIndices c bs' → bs = bs'
  | _, [], [], _ => rfl
  | _, [], _ :: _, h => by simp [tableIndices] at h
  | _, _ :: _, [], h => by simp [tableIndices] at h
  | c, b :: bs, b' :: bs', h => by
    simp only [tableIndices, List.cons.injEq] at h
    obtain ⟨h₁, h₂, h₃⟩ := h
    obtain rfl := byte_of_indices c b b' h₁ h₂
    rw [tableIndices_inj _ bs bs' h₃]

/-- **The indices reveal the message**, for `crc32`: continuing from the same value, two
messages at which `crc32` reads the table at the same indices are the same message. -/
theorem crcIndices_inj (crc : BitVec 32) (bs bs' : List (BitVec 8))
    (h : crcIndices crc bs = crcIndices crc bs') : bs = bs' :=
  tableIndices_inj _ bs bs' h

/-- The address of a lookup, as the code computes it from the register `y`: the entry the low
four bits of `y` select. -/
theorem entryAddr_reg (y : BitVec 32) :
    0x20040#64 + BitVec.setWidth 64
        (BitVec.setWidth 32 (BitVec.setWidth 64 y &&& 15#64)) <<< 2#64 =
      entryAddr 0x20040#64 (BitVec.setWidth 4 y) := by
  unfold entryAddr
  bv_decide

/-! ## The traced triple -/

/-- Forget what `crc32` leaves in the registers it uses and in the flags. -/
local macro "crc32_forget" : tactic =>
  `(tactic| (braid_forget 1; braid_forget 2; braid_forget 8; braid_forget 9; braid_forget 10
             braid_forget_flag 0; braid_forget_flag 1; braid_forget_flag 2
             braid_forget_flag 3))

/-- Run the three instructions of a table lookup, `and`, `ldr` and `eor`, with `y` in `w9`,
on a traced triple: open the table at the entry the low four bits of `y` select, load it,
and close the table. -/
local macro "crc32_nibble_trace " w:term ", " y:term : tactic =>
  `(tactic| (
    braid_sym_step
    braid_unfold tableAt_open $w 0x20040#64 (0x20040#64 + BitVec.setWidth 64
      (BitVec.setWidth 32 (BitVec.setWidth 64 $y &&& 15#64)) <<< 2#64) $y (by bv_decide)
    braid_sym_step
    braid_sym_step
    braid_fold tableAt_open $w 0x20040#64 (0x20040#64 + BitVec.setWidth 64
      (BitVec.setWidth 32 (BitVec.setWidth 64 $y &&& 15#64)) <<< 2#64) $y (by bv_decide)
    rw [nibble_reg]))

/-- The loop of `crc32`, with what it reveals: the table indices of the bytes from `q` on,
taken into the register `c`. -/
theorem crc32_loop_trace (w : Bool) (r : Word) : ∀ (bs : List (BitVec 8)) (b : BitVec 8)
    (c : BitVec 32) (q n a t10 : Word) (fn fz fc fv : Bool) (t : Trace),
    n = BitVec.ofNat 64 (bs.length + 1) → bs.length + 1 < 2 ^ 64 →
    TripleT crc32.program
      (Atoms.interp [.pc 0x10010#64, .reg x0 a, .reg x1 q, .reg x2 n, .reg x8 0x20040#64,
        .reg x9 (c.zeroExtend 64), .reg x10 t10, .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (bytesAt q (b :: bs)), .prop (tableAt w 0x20040#64)]) t
      (Atoms.interp [.pc r, .reg x0 ((~~~update c (b :: bs)).zeroExtend 64),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (bytesAt q (b :: bs)), .prop (tableAt w 0x20040#64)])
      (t ++ (crcRoundsLeak 0x20040#64 q (tableIndices c (b :: bs)) ++ [.jump r])) := by
  intro bs
  induction bs with
  | nil =>
    intro b c q n a t10 fn fz fc fv t he hb
    have he' : n = 1#64 := by simpa using he
    braid_unfold bytesAt_cons q b []
    iterate 3 braid_sym_step
    rw [xor_byte_reg]
    crc32_nibble_trace w, (c ^^^ b.zeroExtend 32)
    crc32_nibble_trace w, (nibble (c ^^^ b.zeroExtend 32))
    rw [← byte_eq]
    braid_sym_step
    · exact absurd he' hbr
    braid_sym_run
    rw [mvn_reg]
    braid_fold bytesAt_cons q b []
    crc32_forget
    simp only [update_cons, update_nil]
    braid_done_trace
    simp only [entryAddr_reg]
    simp [crcRoundsLeak, tableIndices]
  | cons d ds ih =>
    intro b c q n a t10 fn fz fc fv t he hb
    simp only [List.length_cons] at he hb
    braid_unfold bytesAt_cons q b (d :: ds)
    iterate 3 braid_sym_step
    rw [xor_byte_reg]
    crc32_nibble_trace w, (c ^^^ b.zeroExtend 32)
    crc32_nibble_trace w, (nibble (c ^^^ b.zeroExtend 32))
    rw [← byte_eq]
    braid_sym_step
    · braid_call ih d (byte c b) (q + 1#64) (n + 0xffffffffffffffff#64) a _ _ _ _ _ _
        (by rw [he]; bv_omega) (by omega)
      braid_fold bytesAt_cons q b (d :: ds)
      rw [← update_cons]
      braid_done_trace
      simp only [entryAddr_reg]
      simp [crcRoundsLeak, tableIndices]
    · exfalso
      have : n ≠ 1#64 := by rw [he]; bv_omega
      exact this hbr

/-- `crc32` computes the CRC-32 of `n` bytes and reveals `crc32Leak` of the table's address,
the message's address, `n`, the return address, and the table indices of the message,
continuing from the low half of its first argument. What it leaves in `x0` is `result`,
written out. -/
theorem crc32_trace (w : Bool) (c p r t8 t9 t10 : Word) (bs : List (BitVec 8))
    (fn fz fc fv : Bool) (hl : bs.length < 2 ^ 64) (t : Trace) :
    TripleT crc32.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 c, .reg x1 p, .reg x2 (BitVec.ofNat 64 bs.length),
        .reg x8 t8, .reg x9 t9, .reg x10 t10, .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (bytesAt p bs), .prop (tableAt w 0x20040#64)]) t
      (Atoms.interp [.pc r,
        .reg x0 (if bs = [] then c else (Crc32.crc32 (c.truncate 32) bs).zeroExtend 64),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (bytesAt p bs), .prop (tableAt w 0x20040#64)])
      (t ++ crc32Leak 0x20040#64 p bs.length r (crcIndices (c.truncate 32) bs)) := by
  cases bs with
  | nil =>
    simp only [List.length_nil, ↓reduceIte]
    braid_sym_run
    crc32_forget
    braid_done_trace
    simp [crc32Leak, crcIndices, tableIndices, crcRoundsLeak]
  | cons b bs =>
    simp only [List.length_cons, reduceCtorEq, ↓reduceIte] at hl ⊢
    braid_sym_step
    · iterate 3 braid_sym_step
      rw [mvn_arg]
      braid_call crc32_loop_trace w r bs b (~~~c.truncate 32) p _ c t10 fn fz fc fv _ rfl hl
      braid_norm
      refine TripleT.done_eq rfl ?_
      simp [crc32Leak, crcIndices]
    · exfalso
      have : BitVec.ofNat 64 (bs.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr

/-! ## The machine -/

/-- **What `crc32` reveals, on the machine.** A running machine whose program holds the
words of `crc32` (`hw`), with its code loaded (`hc`) and its program counter at the entry
(`hpc`), with the bytes `bs` in memory where `x1` points (`hmsg`), their number, below
`2 ^ 64`, in `x2` (`hl`, `hn`), and the sixteen entries of the lookup table in read-only
memory at `0x20040`, four bytes each (`htab`), runs to the address in the link register with
the trace `crc32Leak` of the table's address, the address in `x1`, the number in `x2`, the
link register, and the indices at which the table is read for `bs`, continuing from the low
half of `x0`. So the run reveals those indices, and through them the message. The message
has to be in memory the machine may store to, which is also what keeps it apart from the
table. -/
theorem crc32_leakage (prog : Arm64.Program) (s : Arm64.State) (bs : List (BitVec 8))
    (hw : prog.hasWords 0x10000#64 crc32_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64) (hl : bs.length < 2 ^ 64)
    (hn : s.regs.read 2#5 = BitVec.ofNat 64 bs.length)
    (hmsg : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.regs.read 1#5 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64))
    (htab : ∀ (i : Nat) (hi : i < table.length),
      HasReadOnlyBytes s (0x20040#64 + BitVec.ofNat 64 (4 * i)) 4 (table[i].zeroExtend 64)) :
    ∃ s', RunL prog s (crc32Leak 0x20040#64 (s.regs.read 1#5) (s.regs.read 2#5).toNat
        (s.regs.read 30#5) (crcIndices ((s.regs.read 0#5).truncate 32) bs)) s' ∧
      s'.pc = s.regs.read 30#5 := by
  have hnat : (s.regs.read 2#5).toNat = bs.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  have htab' : ∀ (i : Nat) (hi : i < tableWords.length),
      HasReadOnlyBytes s (0x20040#64 + BitVec.ofNat 64 (4 * i)) 4 tableWords[i] := by
    intro i hi
    rw [tableWords_getElem]
    exact htab i _
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_soundT crc32_lowered
    (crc32_trace false (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5)
      (s.regs.read 8#5) (s.regs.read 9#5) (s.regs.read 10#5) bs s.pstate.n s.pstate.z
      s.pstate.c s.pstate.v hl [])
    hw hc hrun
    (tableAt_flat (pre := [.pc 0x10000#64, .reg x0 (s.regs.read 0#5),
      .reg x1 (s.regs.read 1#5), .reg x2 (BitVec.ofNat 64 bs.length),
      .reg x8 (s.regs.read 8#5), .reg x9 (s.regs.read 9#5), .reg x10 (s.regs.read 10#5),
      .reg lr (s.regs.read 30#5), .flag Flags.n s.pstate.n, .flag Flags.z s.pstate.z,
      .flag Flags.c s.pstate.c, .flag Flags.v s.pstate.v]) (by braid_flat))
    (forall_flat₂ (by simp [Atom.IsPointsTo]) bytesAtoms_isPointsTo cellsAtoms_isPointsTo)
    (pairwise_flat₂ (by braid_disj) (bytesAtoms_pairwise (by omega))
      (cellsAtoms_pairwise (by decide)) (by braid_disj_array) (by crc32_disj_cells)
      (by
        intro a ha b hb
        obtain ⟨i, hi, rfl⟩ := mem_bytesAtoms.1 ha
        obtain ⟨j, hj, rfl⟩ := mem_cellsAtoms.1 hb
        exact (hmsg i hi).not_readOnly (htab' j hj)))
    (forall_flat₂
      (by simp [Atom.sat_reg, Atom.sat_flag, Atom.sat_pc, regOf, Flags.n, Flags.z, Flags.c,
        Flags.v, hpc, hn])
      (bytesAtoms_sat fun i hi => sat_mem_hasBytes.2 (hmsg i hi))
      (cellsAtoms_sat fun i hi => sat_mem_hasReadOnlyBytes.2 (htab' i hi)))
  refine ⟨s', hsteps, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`crc32` reveals the table indices of its message, and nothing else of it.** Two
running machines that hold the words of `crc32`, with their code loaded and at its entry,
each with a message and the table as `crc32_leakage` asks, and that agree on the message's
address and length, on the link register, and on the indices at which the table is read
(`hidx`), run with the same trace.

The last hypothesis is not one about public inputs: the indices are computed from the
starting value and the message. If the two machines continue from the same value, it holds
only if the two messages are the same (`crcIndices_inj`). So `crc32` is not constant-time,
and what it gives away is the message. -/
theorem crc32_leakage_eq (prog₁ prog₂ : Arm64.Program) (s₁ s₂ : Arm64.State)
    (bs₁ bs₂ : List (BitVec 8))
    (hw₁ : prog₁.hasWords 0x10000#64 crc32_words) (hc₁ : prog₁.CodeLoaded s₁.mem)
    (hw₂ : prog₂.hasWords 0x10000#64 crc32_words) (hc₂ : prog₂.CodeLoaded s₂.mem)
    (hrun₁ : s₁.status = .Running) (hrun₂ : s₂.status = .Running)
    (hpc₁ : s₁.pc = 0x10000#64) (hpc₂ : s₂.pc = 0x10000#64)
    (hl₁ : bs₁.length < 2 ^ 64) (hl₂ : bs₂.length < 2 ^ 64)
    (hn₁ : s₁.regs.read 2#5 = BitVec.ofNat 64 bs₁.length)
    (hn₂ : s₂.regs.read 2#5 = BitVec.ofNat 64 bs₂.length)
    (hmsg₁ : ∀ (i : Nat) (hi : i < bs₁.length),
      HasBytes s₁ (s₁.regs.read 1#5 + BitVec.ofNat 64 i) 1 (bs₁[i].zeroExtend 64))
    (hmsg₂ : ∀ (i : Nat) (hi : i < bs₂.length),
      HasBytes s₂ (s₂.regs.read 1#5 + BitVec.ofNat 64 i) 1 (bs₂[i].zeroExtend 64))
    (htab₁ : ∀ (i : Nat) (hi : i < table.length),
      HasReadOnlyBytes s₁ (0x20040#64 + BitVec.ofNat 64 (4 * i)) 4 (table[i].zeroExtend 64))
    (htab₂ : ∀ (i : Nat) (hi : i < table.length),
      HasReadOnlyBytes s₂ (0x20040#64 + BitVec.ofNat 64 (4 * i)) 4 (table[i].zeroExtend 64))
    (e1 : s₂.regs.read 1#5 = s₁.regs.read 1#5) (e2 : s₂.regs.read 2#5 = s₁.regs.read 2#5)
    (e30 : s₂.regs.read 30#5 = s₁.regs.read 30#5)
    (hidx : crcIndices ((s₂.regs.read 0#5).truncate 32) bs₂ =
      crcIndices ((s₁.regs.read 0#5).truncate 32) bs₁) :
    ∃ tr s₁' s₂', RunL prog₁ s₁ tr s₁' ∧ RunL prog₂ s₂ tr s₂' ∧
      s₁'.pc = s₁.regs.read 30#5 ∧ s₂'.pc = s₁.regs.read 30#5 := by
  obtain ⟨s₁', h₁, hp₁⟩ := crc32_leakage prog₁ s₁ bs₁ hw₁ hc₁ hrun₁ hpc₁ hl₁ hn₁ hmsg₁ htab₁
  obtain ⟨s₂', h₂, hp₂⟩ := crc32_leakage prog₂ s₂ bs₂ hw₂ hc₂ hrun₂ hpc₂ hl₂ hn₂ hmsg₂ htab₂
  simp only [e1, e2, e30, hidx] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.Crc32.Arm
