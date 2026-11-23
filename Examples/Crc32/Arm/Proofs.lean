/-
  Examples.Crc32.Arm.Proofs

  `crc32.c` on AArch64: CRC-32 of a message, four bits at a time through a lookup table in
  read-only data, the third rung of the scaling ladder (`docs/Scaling.md`). The loop is
  proved by induction on the message; each of its two table lookups opens the table at the
  entry the low four bits of the register select (`tableAt_open`), and that a lookup is four
  bits of the division is the pure lemma `nibble_step`.

  ## Main definitions

  * `result`: what `crc32` leaves in `x0`

  ## Main results

  * `crc32_spec`: `crc32` computes `Crc32.crc32`, as a triple
  * `crc32_correct`: the same, about the machine alone, with the table in read-only memory
-/

module

public import Examples.Crc32.Arm.Image
public import Examples.Crc32.Arm.Machine
public import Examples.Crc32.Common
import Braid.BV
import Braid.BV
import Braid.BV
import Braid.BV
import Braid.BV
import Braid.BV
import Braid.BV

public section

namespace Examples.Crc32.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-! ## The values of the registers, as the code computes them -/

/-- `mvn w0, w9`: the result is the complement of the register. -/
theorem mvn_reg (c : BitVec 32) :
    BitVec.setWidth 64 (BitVec.setWidth 32 (~~~BitVec.setWidth 64 c)) =
      BitVec.setWidth 64 (~~~c) := by
  bv_auto

/-- `mvn w9, w0`: the register starts as the complement of the low half of the argument. -/
theorem mvn_arg (c : Word) :
    BitVec.setWidth 64 (BitVec.setWidth 32 (~~~BitVec.setWidth 64 (BitVec.setWidth 32 c))) =
      BitVec.setWidth 64 (~~~BitVec.setWidth 32 c) := by
  bv_auto

/-- `eor w9, w9, w10` after `ldrb`: the byte is added to the register. -/
theorem xor_byte_reg (c : BitVec 32) (b : BitVec 8) :
    BitVec.setWidth 64 c ^^^ BitVec.setWidth 64 (BitVec.setWidth 32 (BitVec.setWidth 64 b)) =
      BitVec.setWidth 64 (c ^^^ b.zeroExtend 32) := by
  bv_auto

/-- `eor w9, w10, w9, lsr #4` after the lookup: four bits of the division. -/
theorem nibble_reg (y : BitVec 32) :
    BitVec.setWidth 64 (nibble (y &&& 15#32)) ^^^ BitVec.setWidth 64 y >>> 4#64 =
      BitVec.setWidth 64 (nibble y) := by
  rw [← nibble_step y]
  generalize nibble (y &&& 15#32) = v
  bv_auto

/-- Run the three instructions of a table lookup, `and`, `ldr` and `eor`, with `y` in `w9`:
open the table at the entry the low four bits of `y` select, load it, and close the table.
The load is run with `braid_step`, which finds the entry's atom up to the unfolding of
`Word`. -/
macro "crc32_nibble " w:term ", " y:term : tactic =>
  `(tactic| (
    braid_sym_step
    braid_unfold tableAt_open $w 0x20040#64 (0x20040#64 + BitVec.setWidth 64
      (BitVec.setWidth 32 (BitVec.setWidth 64 $y &&& 15#64)) <<< 2#64) $y (by bv_decide)
    braid_step
    braid_sym_step
    braid_fold tableAt_open $w 0x20040#64 (0x20040#64 + BitVec.setWidth 64
      (BitVec.setWidth 32 (BitVec.setWidth 64 $y &&& 15#64)) <<< 2#64) $y (by bv_decide)
    rw [nibble_reg]))

/-! ## The triple -/

/-- The loop of `crc32`: take the `n` bytes from `q` into the register `c`, and return its
complement. -/
theorem crc32_loop (w : Bool) (r : Word) : ∀ (bs : List (BitVec 8)) (b : BitVec 8)
    (c : BitVec 32) (q n a t : Word) (fn fz fc fv : Bool),
    n = BitVec.ofNat 64 (bs.length + 1) → bs.length + 1 < 2 ^ 64 →
    Triple crc32.program
      (Atoms.interp [.pc 0x10010#64, .reg x0 a, .reg x1 q, .reg x2 n, .reg x8 0x20040#64,
        .reg x9 (c.zeroExtend 64), .reg x10 t, .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (bytesAt q (b :: bs)), .prop (tableAt w 0x20040#64)])
      (Atoms.interp [.pc r, .reg x0 ((~~~update c (b :: bs)).zeroExtend 64),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (bytesAt q (b :: bs)), .prop (tableAt w 0x20040#64)]) := by
  intro bs
  induction bs with
  | nil =>
    intro b c q n a t fn fz fc fv he hb
    have he' : n = 1#64 := by simpa using he
    braid_unfold bytesAt_cons q b []
    iterate 3 braid_sym_step
    rw [xor_byte_reg]
    crc32_nibble w, (c ^^^ b.zeroExtend 32)
    crc32_nibble w, (nibble (c ^^^ b.zeroExtend 32))
    rw [← byte_eq]
    braid_sym_step
    · exact absurd he' hbr
    braid_sym_run
    rw [mvn_reg]
    braid_fold bytesAt_cons q b []
    braid_forget 1
    braid_forget 2
    braid_forget 8
    braid_forget 9
    braid_forget 10
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    simp only [update_cons, update_nil]
    braid_done
  | cons d ds ih =>
    intro b c q n a t fn fz fc fv he hb
    simp only [List.length_cons] at he hb
    braid_unfold bytesAt_cons q b (d :: ds)
    iterate 3 braid_sym_step
    rw [xor_byte_reg]
    crc32_nibble w, (c ^^^ b.zeroExtend 32)
    crc32_nibble w, (nibble (c ^^^ b.zeroExtend 32))
    rw [← byte_eq]
    braid_sym_step
    · braid_call ih d (byte c b) (q + 1#64) (n + 0xffffffffffffffff#64) a _ _ _ _ _
        (by rw [he]; bv_omega) (by omega)
      braid_fold bytesAt_cons q b (d :: ds)
      rw [← update_cons]
      braid_done
    · exfalso
      have : n ≠ 1#64 := by rw [he]; bv_omega
      exact this hbr

/-- What `crc32` leaves in `x0`: its low half is the CRC-32. Its high half is zero, unless
there are no bytes: the code then returns at once, with `x0` as it was. -/
def result (c : Word) : List (BitVec 8) → Word
  | [] => c
  | b :: bs => (Crc32.crc32 (c.truncate 32) (b :: bs)).zeroExtend 64

/-- The low half of what `crc32` leaves in `x0` is the CRC-32 of the bytes, continuing from
the low half of its first argument. -/
theorem result_truncate (c : Word) (bs : List (BitVec 8)) :
    (result c bs).truncate 32 = Crc32.crc32 (c.truncate 32) bs := by
  cases bs with
  | nil => rw [crc32_nil]; rfl
  | cons b bs => simp [result]

/-- `crc32` returns the CRC-32 of the `n` bytes its second argument points to, continuing
from its first argument, in the low half of `x0`. The lookup table is at `0x20040`, where the
linker put it; it is only read, so the triple holds whether it is writable or not, and for
read-only data `w` is `false`. -/
theorem crc32_spec (w : Bool) (c p r t8 t9 t10 : Word) (bs : List (BitVec 8))
    (fn fz fc fv : Bool) (hl : bs.length < 2 ^ 64) :
    Triple crc32.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 c, .reg x1 p, .reg x2 (BitVec.ofNat 64 bs.length),
        .reg x8 t8, .reg x9 t9, .reg x10 t10, .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv,
        .prop (bytesAt p bs), .prop (tableAt w 0x20040#64)])
      (Atoms.interp [.pc r, .reg x0 (result c bs),
        .prop (regAny x1), .prop (regAny x2), .prop (regAny x8), .prop (regAny x9),
        .prop (regAny x10), .reg lr r,
        .prop (flagAny Flags.n), .prop (flagAny Flags.z), .prop (flagAny Flags.c),
        .prop (flagAny Flags.v),
        .prop (bytesAt p bs), .prop (tableAt w 0x20040#64)]) := by
  cases bs with
  | nil =>
    simp only [List.length_nil]
    braid_sym_run
    braid_forget 1
    braid_forget 2
    braid_forget 8
    braid_forget 9
    braid_forget 10
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    braid_done
  | cons b bs =>
    simp only [List.length_cons] at hl ⊢
    braid_sym_step
    · iterate 3 braid_sym_step
      rw [mvn_arg]
      braid_call crc32_loop w r bs b (~~~c.truncate 32) p _ c t10 fn fz fc fv rfl hl
      braid_done
    · exfalso
      have : BitVec.ofNat 64 (bs.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr

/-! ## The machine -/

/-- The registers, flags and program counter of a state are disjoint from the cells of an
array written out. -/
macro "crc32_disj_cells" : tactic =>
  `(tactic| (simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
               and_true]
             repeat' constructor
             all_goals first
               | exact disj_reg_cellsAtoms | exact disj_pc_cellsAtoms
               | exact disj_flag_cellsAtoms))

/-- **`crc32` on the machine.** A running machine whose program holds the words of `crc32`,
with its code loaded and its program counter at the entry, with the bytes `bs` in memory
where `x1` points (`hmsg`), their number, below `2 ^ 64`, in `x2` (`hl`, `hn`), and the
sixteen entries of the lookup table in read-only memory at `0x20040`, four bytes each
(`htab`), runs to the address in the link register with the CRC-32 of `bs`, continuing from
the low half of `x0`, in the low half of `x0`. The message and the table are in memory as
they were. The message has to be in memory the machine may store to, as `bytesAt` says, which
is also what keeps it apart from the table. -/
theorem crc32_correct (prog : Arm64.Program) (s : Arm64.State) (bs : List (BitVec 8))
    (hw : prog.hasWords 0x10000#64 crc32_words) (hc : prog.CodeLoaded s.mem)
    (hrun : s.status = .Running) (hpc : s.pc = 0x10000#64) (hl : bs.length < 2 ^ 64)
    (hn : s.regs.read 2#5 = BitVec.ofNat 64 bs.length)
    (hmsg : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.regs.read 1#5 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64))
    (htab : ∀ (i : Nat) (hi : i < table.length),
      HasReadOnlyBytes s (0x20040#64 + BitVec.ofNat 64 (4 * i)) 4 (table[i].zeroExtend 64)) :
    ∃ s', Arm64.Steps prog s s' ∧ s'.pc = s.regs.read 30#5 ∧
      (s'.regs.read 0#5).truncate 32 = Crc32.crc32 ((s.regs.read 0#5).truncate 32) bs ∧
      (∀ (i : Nat) (hi : i < bs.length),
        HasBytes s' (s.regs.read 1#5 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64)) ∧
      ∀ (i : Nat) (hi : i < table.length),
        HasReadOnlyBytes s' (0x20040#64 + BitVec.ofNat 64 (4 * i)) 4
          (table[i].zeroExtend 64) := by
  have htab' : ∀ (i : Nat) (hi : i < tableWords.length),
      HasReadOnlyBytes s (0x20040#64 + BitVec.ofNat 64 (4 * i)) 4 tableWords[i] := by
    intro i hi
    rw [tableWords_getElem]
    exact htab i _
  obtain ⟨s', σ', hsteps, hr, hq⟩ := machine_sound_flat crc32_lowered
    (crc32_spec false (s.regs.read 0#5) (s.regs.read 1#5) (s.regs.read 30#5) (s.regs.read 8#5)
      (s.regs.read 9#5) (s.regs.read 10#5) bs s.pstate.n s.pstate.z s.pstate.c s.pstate.v hl)
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
  refine ⟨s', hsteps, ?_, ?_, fun i hi => ?_, fun i hi => ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← result_truncate, ← hr.readReg (i := 0#5) (by decide)]
    exact congrArg _ (Atoms.reg_of_holds (r := 0) hq (by braid_at))
  · exact hasBytes_of_bytesAt (p := s.regs.read 1#5) (bs := bs) hr hq (by braid_at) i hi
  · have h := hasReadOnlyBytes_of_cells (k := 4) (p := 0x20040#64) (vs := tableWords) hr hq
      (by show Atoms.At _ (.prop (tableAt false 0x20040#64)); braid_at) i
      (by simpa [tableWords] using hi)
    rwa [tableWords_getElem] at h

end Examples.Crc32.Arm
