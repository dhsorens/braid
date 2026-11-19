/-
  Examples.Crc32.RiscV.Proofs

  `crc32.c` on RISC-V: CRC-32 of a message, four bits at a time through a lookup table, the
  third rung of the scaling ladder (`docs/Scaling.md`). The loop is proved by induction on
  the message, with the pointer into it in `a1` and its end in `a2`; each of its two table
  lookups opens the table at the entry the low four bits of the register select
  (`tableAt_open`), and that a lookup is four bits of the division is the pure lemma
  `nibble_step`.

  The register of the division is the low half of `a3`: the code works on the whole of `a3`,
  and what the upper half holds changes from round to round (the complement of the argument
  at first, the sign of the low half afterwards), so the loop is stated for any word in `a3`.
  An entry of the table is loaded as a word of four bytes, which the machine model only does
  at a multiple of four: the table is at `0x1005c`, where the linker put it, and the stepper
  proves the alignment of each lookup by itself.

  ## Main definitions

  * `crcReg`: what `crc32` leaves in `a0`

  ## Main results

  * `crc32_spec`: `crc32` computes `Crc32.crc32`, as a triple
  * `crc32_correct`: the same, about the machine alone
-/

module

public import Examples.Crc32.RiscV.Image
public import Examples.Crc32.Common
public import Lowering.RiscV.Logic

public section

namespace Examples.Crc32.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-! ## The values of the registers, as the code computes them -/

/-- `srliw` and `xor` after the first lookup of a round: four bits of the division of the
register with the byte added. -/
theorem nibble_reg₁ (v : Word) (b : BitVec 8) :
    BitVec.signExtend 64 (BitVec.setWidth 32
        (BitVec.setWidth 64 (BitVec.setWidth 32 (v ^^^ BitVec.setWidth 64 b)) >>> 4#64)) ^^^
      BitVec.signExtend 64 (nibble ((BitVec.setWidth 32 v ^^^ BitVec.setWidth 32 b) &&& 15#32)) =
    BitVec.signExtend 64 (nibble (BitVec.setWidth 32 v ^^^ BitVec.setWidth 32 b)) := by
  rw [← nibble_step (BitVec.setWidth 32 v ^^^ BitVec.setWidth 32 b)]
  generalize nibble ((BitVec.setWidth 32 v ^^^ BitVec.setWidth 32 b) &&& 15#32) = n
  bv_decide

/-- `srliw` and `xor` after the second lookup of a round: four more bits of the division. -/
theorem nibble_reg₂ (y : BitVec 32) :
    BitVec.signExtend 64 (BitVec.setWidth 32 (BitVec.setWidth 64 y >>> 4#64)) ^^^
      BitVec.signExtend 64 (nibble (y &&& 15#32)) = BitVec.signExtend 64 (nibble y) := by
  rw [← nibble_step y]
  generalize nibble (y &&& 15#32) = n
  bv_decide

/-- `xori` with minus one: the complement of the register, in the low half. -/
theorem not_reg (y : BitVec 32) :
    BitVec.signExtend 64 y ^^^ 0xffffffffffffffff#64 = BitVec.signExtend 64 (~~~y) := by
  bv_decide

/-- `xori` with minus one: the register starts as the complement of the low half of the
argument. -/
theorem not_arg (c : Word) :
    BitVec.setWidth 32 (c ^^^ 0xffffffffffffffff#64) = ~~~BitVec.setWidth 32 c := by
  bv_decide

/-- The low half of a word that is the sign extension of a register is the register. -/
theorem low_signExtend (y : BitVec 32) : BitVec.setWidth 32 (BitVec.signExtend 64 y) = y := by
  bv_decide

/-- What `crc32` leaves in `a0`: the CRC-32, sign extended as RISC-V keeps a value of 32 bits
in a register, if there is a message; the argument as it was if there is none, since the
code then returns at once. -/
def crcReg (c : Word) (bs : List (BitVec 8)) : Word :=
  if bs = [] then c else (Crc32.crc32 (c.truncate 32) bs).signExtend 64

/-- The low half of what `crc32` leaves in `a0` is the CRC-32. -/
theorem crcReg_truncate (c : Word) (bs : List (BitVec 8)) :
    (crcReg c bs).truncate 32 = Crc32.crc32 (c.truncate 32) bs := by
  unfold crcReg
  split
  · rename_i h
    rw [h, crc32_nil]
  · exact low_signExtend _

/-- Run a table lookup and the `srliw` and `xor` after it, for a register `a3` whose low
half is `y`: open the table at the entry the low four bits of `y` select, run the three
instructions, and close the table. -/
local macro "crc32_nibble " w:term ", " a3:term ", " y:term : tactic =>
  `(tactic| (
    braid_unfold tableAt_open $w 0x1005c#64 (0x1005c#64 + ($a3 &&& 15#64) <<< 2#64) $y
      (by bv_decide)
    iterate 3 braid_sym_step
    braid_fold tableAt_open $w 0x1005c#64 (0x1005c#64 + ($a3 &&& 15#64) <<< 2#64) $y
      (by bv_decide)))

/-- One round of `crc32`, up to the branch at its end: take the byte `b` into the
register. -/
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

/-! ## The triple -/

/-- The loop of `crc32`: with the pointer `p` in `a1` and the end `e` of the message in `a2`,
take the bytes from `p` on into the register, the low half of `v`, and return its
complement. -/
theorem crc32_loop (w : Bool) (e r : Word) : ∀ (bs : List (BitVec 8)) (b : BitVec 8)
    (v p t4 : Word), p + BitVec.ofNat 64 (bs.length + 1) = e → bs.length + 1 < 2 ^ 64 →
    Triple crc32.program
      (Atoms.interp [.pc 0x10014#64, .reg a0 0x1005c#64, .reg a1 p, .reg a2 e, .reg a3 v,
        .reg a4 t4, .reg ra r,
        .prop (bytesAt p (b :: bs)), .prop (tableAt w 0x1005c#64)])
      (Atoms.interp [.pc (r &&& ~~~1#64),
        .reg a0 ((~~~update (v.truncate 32) (b :: bs)).signExtend 64),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4), .reg ra r,
        .prop (bytesAt p (b :: bs)), .prop (tableAt w 0x1005c#64)]) := by
  intro bs
  induction bs with
  | nil =>
    intro b v p t4 he hb
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
    braid_done
  | cons d ds ih =>
    intro b v p t4 he hb
    simp only [List.length_cons] at he hb
    braid_unfold bytesAt_cons p b (d :: ds)
    crc32_round w, v, b
    braid_sym_step
    · braid_call ih d (BitVec.signExtend 64 (byte (BitVec.setWidth 32 v) b))
        (p + 1#64) _ (by rw [← he]; bv_omega) (by omega)
      braid_fold bytesAt_cons p b (d :: ds)
      simp only [low_signExtend, ← update_cons]
      braid_done
    · exfalso
      have : p + 1#64 ≠ e := by rw [← he]; bv_omega
      exact this hbr

/-- `crc32` returns the CRC-32 of the `n` bytes its second argument points to, continuing
from the low half of its first argument, in the low half of `a0` (`crcReg`,
`crcReg_truncate`). The lookup table is at `0x1005c`, where the linker put it; it is only
read, so the triple holds whether it is writable or not. -/
theorem crc32_spec (w : Bool) (c p r t3 t4 : Word) (bs : List (BitVec 8))
    (hl : bs.length < 2 ^ 64) :
    Triple crc32.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 c, .reg a1 p,
        .reg a2 (BitVec.ofNat 64 bs.length), .reg a3 t3, .reg a4 t4, .reg ra r,
        .prop (bytesAt p bs), .prop (tableAt w 0x1005c#64)])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 (crcReg c bs),
        .prop (regAny a1), .prop (regAny a2), .prop (regAny a3), .prop (regAny a4), .reg ra r,
        .prop (bytesAt p bs), .prop (tableAt w 0x1005c#64)]) := by
  cases bs with
  | nil =>
    simp only [List.length_nil, crcReg, ↓reduceIte]
    braid_sym_run
    braid_forget 11
    braid_forget 12
    braid_forget 13
    braid_forget 14
    braid_done
  | cons b bs =>
    simp only [List.length_cons] at hl ⊢
    braid_sym_step
    · exfalso
      have : BitVec.ofNat 64 (bs.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr
    · iterate 4 braid_sym_step
      braid_call crc32_loop w _ r bs b _ p t4 rfl hl
      have e : crcReg c (b :: bs) =
          BitVec.signExtend 64 (~~~update (BitVec.setWidth 32 (c ^^^ 0xffffffffffffffff#64))
            (b :: bs)) := by
        rw [not_arg]
        simp [crcReg, Crc32.crc32]
      rw [e]
      braid_done

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

/-- **`crc32` on the machine.** A machine that holds the code of `crc32`, is at its entry,
has the bytes `bs` in memory where `a1` points (`hmsg`) and their number in `a2` (`hn`), and
has the sixteen entries of the lookup table in memory at `0x1005c`, four bytes each
(`htab`), the message apart from the table (`hmt`), runs to the return address with the
CRC-32 of `bs`, continuing from the low half of `a0`, in the low half of `a0`.

The machine model keeps instructions and data in two memories, and its data memory has no
permissions: the table is sixty-four bytes of ordinary memory here, which are not said to be
read-only, nor to be apart from the code. The code does not store to them. -/
theorem crc32_correct (s : MachineState) (bs : List (BitVec 8))
    (hcode : ∀ p ∈ crc32_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hn : s.getReg .x12 = BitVec.ofNat 64 bs.length)
    (hmsg : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes s (s.getReg .x11 + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64))
    (htab : ∀ (i : Nat) (hi : i < table.length),
      HasBytes s (0x1005c#64 + BitVec.ofNat 64 (4 * i)) 4 (table[i].zeroExtend 64))
    (hmt : bs.length ≤ (0x1005c#64 - s.getReg .x11).toNat ∧
      64 ≤ (s.getReg .x11 - 0x1005c#64).toNat) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      (s'.getReg .x10).truncate 32 = Crc32.crc32 ((s.getReg .x10).truncate 32) bs := by
  have hl : bs.length < 2 ^ 64 := by
    have := (0x1005c#64 - s.getReg .x11).isLt
    omega
  have htab' : ∀ (i : Nat) (hi : i < tableWords.length),
      HasBytes s (0x1005c#64 + BitVec.ofNat 64 (4 * i)) 4 tableWords[i] := by
    intro i hi
    rw [tableWords_getElem]
    exact htab i _
  obtain ⟨n, s', σ', hsteps, hr, hq⟩ := machine_sound_flat crc32_lowered
    (crc32_spec true (s.getReg .x10) (s.getReg .x11) (s.getReg .x1) (s.getReg .x13)
      (s.getReg .x14) bs hl) hcode
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
  refine ⟨n, s', hsteps, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← crcReg_truncate, ← hr.getReg (r := .x10) (by decide)]
    exact congrArg (BitVec.truncate 32) (Atoms.reg_of_holds (r := 10) hq (by braid_at))

end Examples.Crc32.RiscV
