/-
  Examples.Crc32.X86.Proofs

  `crc32.c` on x86-64: CRC-32 of a message, four bits at a time through a lookup table in
  read-only data, the third rung of the scaling ladder (`docs/Scaling.md`). The loop is
  proved by induction on the message, with the index in `rcx`; each of its two table lookups
  opens the table at the entry the low four bits of the register select (`tableAt_open`),
  and that a lookup is four bits of the division is the pure lemma `nibble_step`.

  ## Main results

  * `crc32_spec`: `crc32` computes `Crc32.crc32`, as a triple
  * `crc32_correct`: the same, about the machine alone
-/

module

public import Examples.Crc32.X86.Image
public import Examples.Crc32.Common
import Braid.BV
import Braid.BV
import Braid.BV
import Braid.BV
import Braid.BV

public section

namespace Examples.Crc32.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-! ## The values of the registers, as the code computes them -/

/-- Forget the values of the status flags that still have one. -/
macro "crc32_forget_flags" : tactic =>
  `(tactic| (try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 3
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-- Name the values of the status flags that hold some value. -/
macro "crc32_name_flags" : tactic =>
  `(tactic| (try braid_name_flag 0
             try braid_name_flag 1
             try braid_name_flag 2
             try braid_name_flag 3
             try braid_name_flag 4
             try braid_name_flag 5))

/-- `not eax`: the result is the complement of the register. -/
theorem not_reg (c : BitVec 32) :
    BitVec.setWidth 64 (BitVec.setWidth 32 (~~~BitVec.setWidth 64 c)) =
      BitVec.setWidth 64 (~~~c) := by
  bv_auto

/-- `not eax` after `mov eax, edi`: the register starts as the complement of the low half of
the argument. -/
theorem not_arg (c : Word) :
    BitVec.setWidth 64 (BitVec.setWidth 32 (~~~BitVec.setWidth 64 (BitVec.setWidth 32 c))) =
      BitVec.setWidth 64 (~~~BitVec.setWidth 32 c) := by
  bv_auto

/-- `xor r8d, eax` after `movzx`: the byte is added to the register. -/
theorem xor_byte_reg (c : BitVec 32) (b : BitVec 8) :
    BitVec.setWidth 64 (BitVec.setWidth 32 (BitVec.setWidth 64 b)) ^^^ BitVec.setWidth 64 c =
      BitVec.setWidth 64 (c ^^^ b.zeroExtend 32) := by
  bv_auto

/-- `xor r9d, [rdi + r8 * 4]` after the lookup: four bits of the division. -/
theorem nibble_reg (y : BitVec 32) :
    BitVec.setWidth 64 (BitVec.setWidth 32 (BitVec.setWidth 64 y >>> 4#64)) ^^^
        BitVec.setWidth 64 (nibble (y &&& 15#32)) =
      BitVec.setWidth 64 (nibble y) := by
  rw [← nibble_step y]
  generalize nibble (y &&& 15#32) = v
  bv_auto

/-- Run the table lookup, an `xor` with the entry of the table the low four bits of `y`
select: open the table at that entry, run the instruction, and close the table. The
instruction is run with `braid_step`, which finds the entry's atom up to the unfolding of
`Word`, and needs every flag to hold a value. -/
macro "crc32_nibble " w:term ", " y:term : tactic =>
  `(tactic| (
    braid_unfold tableAt_open $w 0x402050#64
      (0x402050#64 + (BitVec.setWidth 64 $y &&& 15#64) * 4#64) $y (by bv_decide)
    crc32_name_flags
    braid_step
    crc32_forget_flags
    braid_fold tableAt_open $w 0x402050#64
      (0x402050#64 + (BitVec.setWidth 64 $y &&& 15#64) * 4#64) $y (by bv_decide)
    rw [nibble_reg]))

/-! ## The triple -/

/-- The loop of `crc32`: with the index `j` in `rcx` and the end `n` in `rdx`, take the bytes
from `p + j` on into the register `c`, and return its complement. -/
theorem crc32_loop (w : Bool) (p n s r : Word) : ∀ (bs : List (BitVec 8)) (b : BitVec 8)
    (c : BitVec 32) (j t8 t9 : Word) (fc fp fa fz fs fo : Bool),
    n = j + BitVec.ofNat 64 (bs.length + 1) → bs.length + 1 < 2 ^ 64 →
    Triple crc32.program
      (Atoms.interp [.pc 0x401020#64, .reg rax (c.zeroExtend 64), .reg rcx j, .reg rdx n,
        .reg rsi p, .reg rdi 0x402050#64, .reg r8 t8, .reg r9 t9, .reg rsp s, .mem s 8 r true,
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (bytesAt (p + j * 1#64) (b :: bs)), .prop (tableAt w 0x402050#64)])
      (Atoms.interp [.pc r, .reg rax ((~~~update c (b :: bs)).zeroExtend 64),
        .prop (regAny rcx), .reg rdx n, .reg rsi p, .reg rdi 0x402050#64, .prop (regAny r8),
        .prop (regAny r9), .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (bytesAt (p + j * 1#64) (b :: bs)), .prop (tableAt w 0x402050#64)]) := by
  intro bs
  induction bs with
  | nil =>
    intro b c j t8 t9 fc fp fa fz fs fo he hb
    have he' : n = j + 1#64 := by simpa using he
    braid_unfold bytesAt_cons (p + j * 1#64) b []
    braid_step
    braid_sym_step
    rw [xor_byte_reg]
    crc32_forget_flags
    iterate 3 braid_sym_step
    crc32_forget_flags
    crc32_nibble w, (c ^^^ b.zeroExtend 32)
    iterate 3 braid_sym_step
    crc32_forget_flags
    crc32_nibble w, (nibble (c ^^^ b.zeroExtend 32))
    rw [← byte_eq]
    iterate 3 braid_sym_step
    · exact absurd (show n - (j + 1#64) = 0#64 by rw [he']; bv_auto) hbr
    · braid_sym_run
      rw [not_reg]
      braid_fold bytesAt_cons (p + j * 1#64) b []
      braid_forget 2
      braid_forget 8
      braid_forget 9
      crc32_forget_flags
      simp only [update_cons, update_nil]
      braid_done
  | cons d ds ih =>
    intro b c j t8 t9 fc fp fa fz fs fo he hb
    simp only [List.length_cons] at he hb
    braid_unfold bytesAt_cons (p + j * 1#64) b (d :: ds)
    braid_step
    braid_sym_step
    rw [xor_byte_reg]
    crc32_forget_flags
    iterate 3 braid_sym_step
    crc32_forget_flags
    crc32_nibble w, (c ^^^ b.zeroExtend 32)
    iterate 3 braid_sym_step
    crc32_forget_flags
    crc32_nibble w, (nibble (c ^^^ b.zeroExtend 32))
    rw [← byte_eq]
    iterate 3 braid_sym_step
    · have e : p + (j * 1#64 + 1#64) = p + (j + 1#64) * 1#64 := by bv_auto
      rw [e]
      crc32_name_flags
      braid_call ih d (byte c b) (j + 1#64) _ _ _ _ _ _ _ _ (by rw [he]; bv_omega) (by omega)
      rw [← e]
      braid_fold bytesAt_cons (p + j * 1#64) b (d :: ds)
      rw [← update_cons]
      braid_done
    · exfalso
      have : n - (j + 1#64) ≠ 0#64 := by rw [he]; bv_omega
      exact this hbr

/-- `crc32` returns the CRC-32 of the `n` bytes its second argument points to, continuing
from its first argument, in `eax`. The lookup table is at `0x402050`, where the linker put
it; it is only read, so the triple holds whether it is writable or not, and for read-only
data `w` is `false`. -/
theorem crc32_spec (w : Bool) (c p s r a t2 t8 t9 : Word) (bs : List (BitVec 8))
    (fc fp fa fz fs fo : Bool) (hl : bs.length < 2 ^ 64) :
    Triple crc32.program
      (Atoms.interp [.pc 0x401000#64, .reg rax a, .reg rcx t2,
        .reg rdx (BitVec.ofNat 64 bs.length), .reg rsi p, .reg rdi c, .reg r8 t8, .reg r9 t9,
        .reg rsp s, .mem s 8 r true,
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (bytesAt p bs), .prop (tableAt w 0x402050#64)])
      (Atoms.interp [.pc r, .reg rax ((Crc32.crc32 (c.truncate 32) bs).zeroExtend 64),
        .prop (regAny rcx), .reg rdx (BitVec.ofNat 64 bs.length), .reg rsi p,
        .prop (regAny rdi), .prop (regAny r8), .prop (regAny r9), .reg rsp (s + 8#64),
        .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (bytesAt p bs), .prop (tableAt w 0x402050#64)]) := by
  cases bs with
  | nil =>
    simp only [List.length_nil]
    braid_sym_run
    braid_forget 2
    braid_forget 5
    braid_forget 8
    braid_forget 9
    crc32_forget_flags
    rw [crc32_nil]
    braid_done
  | cons b bs =>
    simp only [List.length_cons] at hl ⊢
    iterate 3 braid_sym_step
    · exfalso
      have : BitVec.ofNat 64 (bs.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · iterate 4 braid_sym_step
      rw [not_arg, BitVec.xor_self]
      crc32_name_flags
      have h := crc32_loop w p (BitVec.ofNat 64 (bs.length + 1)) s r bs b (~~~c.truncate 32)
        0#64 t8 t9
      have e : p + 0#64 * 1#64 = p := by bv_auto
      rw [e] at h
      braid_call h _ _ _ _ _ _ (by simp) hl
      braid_forget 5
      braid_done

/-! ## The machine -/

/-- The registers, flags and program counter of a state are disjoint from the cells of an
array written out. A memory atom leaves a goal. -/
macro "crc32_disj_cells" : tactic =>
  `(tactic| (simp only [List.forall_mem_cons, List.not_mem_nil, false_imp_iff, implies_true,
               and_true]
             repeat' constructor
             all_goals first
               | exact disj_reg_cellsAtoms | exact disj_pc_cellsAtoms
               | exact disj_flag_cellsAtoms | skip))

/-- A word that starts at or beyond the end of a region, and ends before the region starts,
does not reach into it. -/
private theorem sep_word {s p : Word} {l : Nat} (h : l ≤ (s - p).toNat ∧ 8 ≤ (p - s).toNat)
    (x : Word) (hx : (x - s).toNat < 8) : ¬ (x - p).toNat < l := by
  bv_omega

/-- A byte of a region that ends at or before the table, and starts at or beyond its end, is
not in the table. -/
private theorem sep_byte {p t x : Word} {l i : Nat}
    (h : l ≤ (t - p).toNat ∧ 64 ≤ (p - t).toNat) (hi : i < l)
    (hx : (x - (p + BitVec.ofNat 64 i)).toNat < 1) : ¬ (x - t).toNat < 64 := by
  bv_omega

/-- The table takes sixty-four bytes. -/
private theorem table_size : 4 * tableWords.length = 64 := by decide

/-- **`crc32` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `crc32`, has the bytes `bs` in memory where `rsi` points (`hmsg`)
and their number in `rdx` (`hn`), has the sixteen entries of the lookup table in memory at
`0x402050`, four bytes each (`htab`), and has the return address `r` in the eight bytes at
the stack pointer (`hret`), where the message, the table and those eight bytes are apart
from one another (`hms`, `hmt`, `hts`), reaches `r` on every run, with the CRC-32 of `bs`,
continuing from the low half of `rdi`, in `rax`. The memory of the model has no permissions,
so the table is not said to be read-only here; the code does not store to it. -/
theorem crc32_correct [Layout] (m : MachineState) (bs : List (BitVec 8)) (r : Word)
    (hpc : m.pc = 0x401000) (hn : m.data.regs.get64 .rdx = BitVec.ofNat 64 bs.length)
    (hmsg : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes m (m.data.regs.get64 .rsi + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64))
    (htab : ∀ (i : Nat) (hi : i < table.length),
      HasBytes m (0x402050#64 + BitVec.ofNat 64 (4 * i)) 4 (table[i].zeroExtend 64))
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hms : bs.length ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rsp).toNat)
    (hmt : bs.length ≤ (0x402050#64 - m.data.regs.get64 .rsi).toNat ∧
      64 ≤ (m.data.regs.get64 .rsi - 0x402050#64).toNat)
    (hts : 64 ≤ (m.data.regs.get64 .rsp - 0x402050#64).toNat ∧
      8 ≤ (0x402050#64 - m.data.regs.get64 .rsp).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧ m'.data.regs.get64 .rax =
        (Crc32.crc32 ((m.data.regs.get64 .rdi).truncate 32) bs).zeroExtend 64) m := by
  have hl : bs.length < 2 ^ 64 := by
    have := (m.data.regs.get64 .rsp - m.data.regs.get64 .rsi).isLt
    omega
  have htab' : ∀ (i : Nat) (hi : i < tableWords.length),
      HasBytes m (0x402050#64 + BitVec.ofNat 64 (4 * i)) 4 tableWords[i] := by
    intro i hi
    rw [tableWords_getElem]
    exact htab i _
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat crc32_holds
    (crc32_spec true (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
      (m.data.regs.get64 .rsp) r (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx)
      (m.data.regs.get64 .r8) (m.data.regs.get64 .r9) bs m.data.status.cf m.data.status.pf
      m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of hl)
    (tableAt_flat (pre := [.pc 0x401000#64, .reg rax (m.data.regs.get64 .rax),
      .reg rcx (m.data.regs.get64 .rcx), .reg rdx (BitVec.ofNat 64 bs.length),
      .reg rsi (m.data.regs.get64 .rsi), .reg rdi (m.data.regs.get64 .rdi),
      .reg r8 (m.data.regs.get64 .r8), .reg r9 (m.data.regs.get64 .r9),
      .reg rsp (m.data.regs.get64 .rsp), .mem (m.data.regs.get64 .rsp) 8 r true,
      .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
      .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
      .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of]) (by braid_flat))
    (forall_flat₂ (by simp [Atom.IsPointsTo]) bytesAtoms_isPointsTo cellsAtoms_isPointsTo)
    (pairwise_flat₂ (by braid_disj) (bytesAtoms_pairwise (by omega))
      (cellsAtoms_pairwise (by decide))
      (by
        braid_disj_array
        exact disj_mem_bytesAtoms (sep_word hms) (by omega))
      (by
        crc32_disj_cells
        exact disj_mem_cellsAtoms (sep_word (by rw [table_size]; exact hts)) (by decide))
      (by
        intro a ha b hb
        obtain ⟨i, hi, rfl⟩ := mem_bytesAtoms.1 ha
        refine disj_mem_cellsAtoms (fun x hx => ?_) (by decide) b hb
        rw [table_size]
        exact sep_byte hmt hi hx))
    (forall_flat₂
      (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
        hret, hn])
      (bytesAtoms_sat fun i hi => sat_mem_abs.2 (hmsg i hi))
      (cellsAtoms_sat fun i hi => sat_mem_abs.2 (htab' i hi))))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    exact Atoms.reg_of_holds (r := 0) hq (by braid_at)

end Examples.Crc32.X86
