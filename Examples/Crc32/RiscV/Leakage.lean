/-
  Examples.Crc32.RiscV.Leakage

  What `crc32` reveals on RISC-V (`docs/Leakage.md`). It is not constant-time: each byte of
  the message is taken into the register through two lookups in the table, and the address
  of a lookup is the table's address and an index that is four bits of the register. A run
  reveals, besides the address and the length of the message, the table's address and the
  return address, exactly the sequence of those indices, two for each byte
  (`crcIndices`), which is a function of the value `crc32` continues from and of the message.

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

public import Examples.Crc32.RiscV.Proofs
import Braid.BV

public section

namespace Examples.Crc32.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

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
      .jump (if is = [] then 0x10054#64 else 0x10014#64)] ++ crcRoundsLeak tbl (p + 1#64) is
  | _ => []

/-- What `crc32` reveals: whether there is a message, for each byte its address and the
addresses of the two entries of the table read for it, and where it returns. It is a
function of the table's address `tbl`, the message's address `p` and length `n`, the return
address `r`, and the table indices `is` of the message, two for each byte. It takes nothing
else of the message or of the starting value; but the indices are a function of both, and
with the starting value they give the message back (`crcIndices_inj`). -/
def crc32Leak (tbl p : Word) (n : Nat) (r : Word) (is : List (BitVec 4)) : Trace :=
  [.jump (if n = 0 then 0x10058#64 else 0x10004#64)] ++ crcRoundsLeak tbl p is ++
    [.jump (r &&& ~~~1#64)]

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

/-- The address of the first lookup of a round, as the code computes it. -/
theorem entryAddr₁ (v : Word) (b : BitVec 8) :
    0x1005c#64 + ((v ^^^ BitVec.setWidth 64 b) &&& 15#64) <<< 2#64 =
      entryAddr 0x1005c#64
        (BitVec.setWidth 4 (BitVec.setWidth 32 v ^^^ BitVec.setWidth 32 b)) := by
  unfold entryAddr
  bv_auto

/-- The address of the second lookup of a round, as the code computes it. -/
theorem entryAddr₂ (y : BitVec 32) :
    0x1005c#64 + (BitVec.signExtend 64 y &&& 15#64) <<< 2#64 =
      entryAddr 0x1005c#64 (BitVec.setWidth 4 y) := by
  unfold entryAddr
  bv_auto

/-! ## The traced triple -/

/-- Run a table lookup and the `srliw` and `xor` after it, as in the functional proof. -/
local macro "crc32_nibble " w:term ", " a3:term ", " y:term : tactic =>
  `(tactic| (
    braid_unfold tableAt_open $w 0x1005c#64 (0x1005c#64 + ($a3 &&& 15#64) <<< 2#64) $y
      (by bv_auto)
    iterate 3 braid_sym_step
    braid_fold tableAt_open $w 0x1005c#64 (0x1005c#64 + ($a3 &&& 15#64) <<< 2#64) $y
      (by bv_auto)))

/-- One round of `crc32`, up to the branch at its end, as in the functional proof. -/
local macro "crc32_round " w:term ", " v:term ", " b:term : tactic =>
  `(tactic| (
    iterate 6 braid_sym_step
    crc32_nibble $w, ($v ^^^ BitVec.setWidth 64 $b),
      (BitVec.setWidth 32 $v ^^^ BitVec.setWidth 32 $b)
    rw [nibble_reg₁]
    iterate 3 braid_sym_step
    crc32_nibble $w,
      (BitVec.signExtend 64 (nibble (BitVec.setWidth 32 $v ^^^ BitVec.setWidth 32 $b))),
      (nibble (BitVec.setWidth 32 $v ^^^ BitVec.setWidth 32 $b))
    simp only [low_signExtend, nibble_reg₂]
    rw [← byte_eq]))

/-- The loop of `crc32`, with what it reveals: the table indices of the bytes from `p` on,
taken into the low half of `v`. -/
theorem crc32_loop_trace (w : Bool) (e r : Word) : ∀ (bs : List (BitVec 8)) (b : BitVec 8)
    (v p t4 : Word) (t : Trace), p + BitVec.ofNat 64 (bs.length + 1) = e →
    bs.length + 1 < 2 ^ 64 →
    TripleT crc32.program
      (Atoms.interp [.pc 0x10014#64, .reg a0 0x1005c#64, .reg a1 p, .reg a2 e, .reg a3 v,
        .reg a4 t4, .reg ra r,
        .prop (bytesAt p (b :: bs)), .prop (tableAt w 0x1005c#64)]) t
      (Atoms.interp [.pc (r &&& ~~~1#64),
        .reg a0 ((~~~update (v.truncate 32) (b :: bs)).signExtend 64),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4), .reg ra r,
        .prop (bytesAt p (b :: bs)), .prop (tableAt w 0x1005c#64)])
      (t ++ (crcRoundsLeak 0x1005c#64 p (tableIndices (v.truncate 32) (b :: bs)) ++
        [.jump (r &&& ~~~1#64)])) := by
  intro bs
  induction bs with
  | nil =>
    intro b v p t4 t he hb
    have he' : e = p + 1#64 := by simpa using he.symm
    subst he'
    braid_unfold bytesAt_cons p b []
    crc32_round w, v, b
    braid_sym_run
    rw [not_reg]
    braid_fold bytesAt_cons p b []
    braid_forget 11
    braid_forget 12
    braid_forget 13
    braid_forget 14
    simp only [update_cons, update_nil]
    braid_done_trace
    rw [entryAddr₁, entryAddr₂]
    simp [crcRoundsLeak, tableIndices]
  | cons d ds ih =>
    intro b v p t4 t he hb
    simp only [List.length_cons] at he hb
    braid_unfold bytesAt_cons p b (d :: ds)
    crc32_round w, v, b
    braid_sym_step
    · braid_call ih d (BitVec.signExtend 64 (byte (BitVec.setWidth 32 v) b))
        (p + 1#64) _ _ (by rw [← he]; bv_omega) (by omega)
      braid_fold bytesAt_cons p b (d :: ds)
      simp only [low_signExtend, ← update_cons]
      braid_done_trace
      rw [entryAddr₁, entryAddr₂]
      simp [crcRoundsLeak, tableIndices]
    · exfalso
      have : p + 1#64 ≠ e := by rw [← he]; bv_omega
      exact this hbr

/-- `crc32` computes the CRC-32 of `n` bytes and reveals `crc32Leak` of the table's address,
the message's address, `n`, the return address, and the table indices of the message. What
it leaves in `a0` is `crcReg`, written out. -/
theorem crc32_trace (w : Bool) (c p r t3 t4 : Word) (bs : List (BitVec 8))
    (hl : bs.length < 2 ^ 64) (t : Trace) :
    TripleT crc32.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 c, .reg a1 p,
        .reg a2 (BitVec.ofNat 64 bs.length), .reg a3 t3, .reg a4 t4, .reg ra r,
        .prop (bytesAt p bs), .prop (tableAt w 0x1005c#64)]) t
      (Atoms.interp [.pc (r &&& ~~~1#64),
        .reg a0 (if bs = [] then c else (Crc32.crc32 (c.truncate 32) bs).signExtend 64),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4), .reg ra r,
        .prop (bytesAt p bs), .prop (tableAt w 0x1005c#64)])
      (t ++ crc32Leak 0x1005c#64 p bs.length r (crcIndices (c.truncate 32) bs)) := by
  cases bs with
  | nil =>
    simp only [List.length_nil, ↓reduceIte]
    braid_sym_run
    braid_forget 11
    braid_forget 12
    braid_forget 13
    braid_forget 14
    braid_done_trace
    simp [crc32Leak, crcIndices, tableIndices, crcRoundsLeak]
  | cons b bs =>
    simp only [List.length_cons] at hl ⊢
    braid_sym_step
    · exfalso
      have : BitVec.ofNat 64 (bs.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr
    · iterate 4 braid_sym_step
      braid_call crc32_loop_trace w _ r bs b _ p t4 _ rfl hl
      have e : BitVec.signExtend 64 (Crc32.crc32 (BitVec.setWidth 32 c) (b :: bs)) =
          BitVec.signExtend 64 (~~~update (BitVec.setWidth 32 (c ^^^ 0xffffffffffffffff#64))
            (b :: bs)) := by
        rw [not_arg]
        rfl
      rw [e]
      braid_done_trace
      rw [not_arg]
      simp [crc32Leak, crcIndices]

/-! ## The machine -/

/-- A byte of a region that ends at or before the table, and starts at or beyond its end, is
not in the table. -/
private theorem sep_byte {p t x : Word} {l i : Nat}
    (h : l ≤ (t - p).toNat ∧ 64 ≤ (p - t).toNat) (hi : i < l)
    (hx : (x - (p + BitVec.ofNat 64 i)).toNat < 1) : ¬ (x - t).toNat < 64 := by
  bv_omega

/-- The table takes sixty-four bytes. -/
private theorem table_size : 4 * tableWords.length = 64 := by decide

/-- The registers and program counter of a state are disjoint from the cells of an array
written out. -/
local macro "crc32_disj_cells" : tactic =>
  `(tactic| (simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
               and_true]
             repeat' constructor
             all_goals first
               | exact disj_reg_cellsAtoms | exact disj_pc_cellsAtoms))

/-- **What `crc32` reveals, on the machine.** A machine that holds the code of `crc32`, is at
its entry, has the bytes `bs` in memory where `a1` points (`hmsg`) and their number in `a2`
(`hn`), and has the sixteen entries of the lookup table in memory at `0x1005c`, four bytes
each (`htab`), the message apart from the table (`hmt`), runs to the return address with the
trace `crc32Leak` of the table's address, the address in `a1`, the number in `a2`, the return
address, and the indices at which the table is read for `bs`, continuing from the low half
of `a0`. So the run reveals those indices, and through them the message. -/
theorem crc32_leakage (s : MachineState) (bs : List (BitVec 8))
    (hcode : ∀ p ∈ crc32_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hn : s.getReg .x12 = BitVec.ofNat 64 bs.length)
    (hmsg : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.getReg .x11 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64))
    (htab : ∀ (i : Nat) (hi : i < table.length),
      HasBytes s (0x1005c#64 + BitVec.ofNat 64 (4 * i)) 4 (table[i].zeroExtend 64))
    (hmt : bs.length ≤ (0x1005c#64 - s.getReg .x11).toNat ∧
      64 ≤ (s.getReg .x11 - 0x1005c#64).toNat) :
    ∃ s', RunL s (crc32Leak 0x1005c#64 (s.getReg .x11) (s.getReg .x12).toNat (s.getReg .x1)
        (crcIndices ((s.getReg .x10).truncate 32) bs)) s' ∧
      s'.pc = s.getReg .x1 &&& ~~~1#64 := by
  have hl : bs.length < 2 ^ 64 := by
    have := (0x1005c#64 - s.getReg .x11).isLt
    omega
  have hnat : (s.getReg .x12).toNat = bs.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  have htab' : ∀ (i : Nat) (hi : i < tableWords.length),
      HasBytes s (0x1005c#64 + BitVec.ofNat 64 (4 * i)) 4 tableWords[i] := by
    intro i hi
    rw [tableWords_getElem]
    exact htab i _
  obtain ⟨s', σ', hrun, hr, hq⟩ := machine_soundT crc32_lowered
    (crc32_trace true (s.getReg .x10) (s.getReg .x11) (s.getReg .x1) (s.getReg .x13)
      (s.getReg .x14) bs hl []) hcode
    (tableAt_flat (pre := [.pc 0x10000#64, .reg a0 (s.getReg .x10), .reg a1 (s.getReg .x11),
      .reg a2 (BitVec.ofNat 64 bs.length), .reg a3 (s.getReg .x13), .reg a4 (s.getReg .x14),
      .reg ra (s.getReg .x1)]) (by braid_flat))
    (forall_flat₂ (by simp [Atom.IsPointsTo]) bytesAtoms_isPointsTo cellsAtoms_isPointsTo)
    (pairwise_flat₂ (by braid_disj) (bytesAtoms_pairwise (by omega))
      (cellsAtoms_pairwise (by decide))
      (by braid_disj_array)
      (by crc32_disj_cells)
      (by
        intro a ha b hb
        obtain ⟨i, hi, rfl⟩ := mem_bytesAtoms.1 ha
        refine disj_mem_cellsAtoms (fun x hx => ?_) (by decide) b hb
        rw [table_size]
        exact sep_byte hmt hi hx))
    (forall_flat₂
      (by simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, hn])
      (bytesAtoms_sat fun i hi => sat_mem_abs.2 (hmsg i hi))
      (cellsAtoms_sat fun i hi => sat_mem_abs.2 (htab' i hi)))
  refine ⟨s', hrun, ?_⟩
  rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)

/-- **`crc32` reveals the table indices of its message, and nothing else of it.** Two
machines that hold the code of `crc32`, are at its entry, each with a message and the table
as `crc32_leakage` asks, and that agree on the message's address and length, on the return
address, and on the indices at which the table is read (`hidx`), run with the same trace.

The last hypothesis is not one about public inputs: the indices are computed from the
starting value and the message. If the two machines continue from the same value, it holds
only if the two messages are the same (`crcIndices_inj`). So `crc32` is not constant-time,
and what it gives away is the message. -/
theorem crc32_leakage_eq (s₁ s₂ : MachineState) (bs₁ bs₂ : List (BitVec 8))
    (hcode₁ : ∀ p ∈ crc32_code, s₁.code p.1 = some p.2)
    (hcode₂ : ∀ p ∈ crc32_code, s₂.code p.1 = some p.2)
    (hpc₁ : s₁.pc = 0x10000#64) (hpc₂ : s₂.pc = 0x10000#64)
    (hn₁ : s₁.getReg .x12 = BitVec.ofNat 64 bs₁.length)
    (hn₂ : s₂.getReg .x12 = BitVec.ofNat 64 bs₂.length)
    (hmsg₁ : ∀ (i : Nat) (hi : i < bs₁.length),
      HasBytes s₁ (s₁.getReg .x11 + BitVec.ofNat 64 i) 1 (bs₁[i].zeroExtend 64))
    (hmsg₂ : ∀ (i : Nat) (hi : i < bs₂.length),
      HasBytes s₂ (s₂.getReg .x11 + BitVec.ofNat 64 i) 1 (bs₂[i].zeroExtend 64))
    (htab₁ : ∀ (i : Nat) (hi : i < table.length),
      HasBytes s₁ (0x1005c#64 + BitVec.ofNat 64 (4 * i)) 4 (table[i].zeroExtend 64))
    (htab₂ : ∀ (i : Nat) (hi : i < table.length),
      HasBytes s₂ (0x1005c#64 + BitVec.ofNat 64 (4 * i)) 4 (table[i].zeroExtend 64))
    (hmt₁ : bs₁.length ≤ (0x1005c#64 - s₁.getReg .x11).toNat ∧
      64 ≤ (s₁.getReg .x11 - 0x1005c#64).toNat)
    (hmt₂ : bs₂.length ≤ (0x1005c#64 - s₂.getReg .x11).toNat ∧
      64 ≤ (s₂.getReg .x11 - 0x1005c#64).toNat)
    (e11 : s₂.getReg .x11 = s₁.getReg .x11) (e12 : s₂.getReg .x12 = s₁.getReg .x12)
    (e1 : s₂.getReg .x1 = s₁.getReg .x1)
    (hidx : crcIndices ((s₂.getReg .x10).truncate 32) bs₂ =
      crcIndices ((s₁.getReg .x10).truncate 32) bs₁) :
    ∃ tr s₁' s₂', RunL s₁ tr s₁' ∧ RunL s₂ tr s₂' ∧
      s₁'.pc = s₁.getReg .x1 &&& ~~~1#64 ∧ s₂'.pc = s₁.getReg .x1 &&& ~~~1#64 := by
  obtain ⟨s₁', h₁, hp₁⟩ := crc32_leakage s₁ bs₁ hcode₁ hpc₁ hn₁ hmsg₁ htab₁ hmt₁
  obtain ⟨s₂', h₂, hp₂⟩ := crc32_leakage s₂ bs₂ hcode₂ hpc₂ hn₂ hmsg₂ htab₂ hmt₂
  simp only [e11, e12, e1, hidx] at h₂ hp₂
  exact ⟨_, s₁', s₂', h₁, h₂, hp₁, hp₂⟩

end Examples.Crc32.RiscV
