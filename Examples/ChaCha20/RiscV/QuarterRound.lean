/-
  Examples.ChaCha20.RiscV.QuarterRound

  `quarter_round` of `chacha20.c` on RISC-V: the quarter round of ChaCha20 on four 32-bit
  words in memory.

  On RV64 a 32-bit word lives in a 64-bit register. `lw` sign-extends it, `add`, `xor` and
  `slli` work on all 64 bits, and only `srliw` and `sw` look at the low half alone, so
  between a load and a store the high half of a register holds whatever the arithmetic left
  there. The symbolic execution therefore ends in 64-bit expressions, and a store of 32 bits
  keeps the low half of one: `low` of it. `low_add`, `low_xor`, `low_rot16`, ... push `low`
  down to the words that were loaded, which leaves the code's arithmetic read as arithmetic
  on 32-bit words, `qr`; that `qr` is `ChaCha20.quarter` is a separate lemma, proved by
  `bv_decide`.

  ## Main results

  * `low_add`, `low_xor`, `low_rot16`, `low_rot12`, `low_rot8`, `low_rot7`, `low_sext`: the
    low half of the 64-bit arithmetic of the code, as 32-bit arithmetic
  * `cells4_low`, `cells16_low`: an array of 32-bit cells that were stored from registers
  * `quarter_round_spec`, `quarter_round_correct`: the quarter round on four words in memory
-/

module

public import Examples.ChaCha20.RiscV.Image
public import Examples.ChaCha20.Common
public import Lowering.RiscV.Logic

@[expose] public section

namespace Examples.ChaCha20.RiscV

open Braid Examples Lowering.RiscV Lowering.RiscV.Regs RiscvZkvm.Rv64

/-! ## The low half of a register -/

/-- The low half of the sum of two registers. -/
theorem low_add (x y : Word) :
    BitVec.setWidth 32 (x + y) = BitVec.setWidth 32 x + BitVec.setWidth 32 y := by
  bv_decide

/-- The low half of the exclusive or of two registers. -/
theorem low_xor (x y : Word) :
    BitVec.setWidth 32 (x ^^^ y) = BitVec.setWidth 32 x ^^^ BitVec.setWidth 32 y := by
  bv_decide

/-- The low half of a register that was loaded with a 32-bit word. -/
theorem low_sext (a : W32) : BitVec.setWidth 32 (BitVec.signExtend 64 a) = a := by
  bv_decide

/-- The low half of a 32-bit rotation as `srliw`, `slli` and `or` compute it: the shift to
the left is of all 64 bits, and leaves bits of the word in the high half. -/
theorem low_rot16 (x : Word) :
    BitVec.setWidth 32 (x <<< 16#64 ||| BitVec.signExtend 64 (BitVec.setWidth 32
      (BitVec.setWidth 64 (BitVec.setWidth 32 x) >>> 16#64))) =
      (BitVec.setWidth 32 x).rotateLeft 16 := by
  bv_decide

theorem low_rot12 (x : Word) :
    BitVec.setWidth 32 (x <<< 12#64 ||| BitVec.signExtend 64 (BitVec.setWidth 32
      (BitVec.setWidth 64 (BitVec.setWidth 32 x) >>> 20#64))) =
      (BitVec.setWidth 32 x).rotateLeft 12 := by
  bv_decide

theorem low_rot8 (x : Word) :
    BitVec.setWidth 32 (x <<< 8#64 ||| BitVec.signExtend 64 (BitVec.setWidth 32
      (BitVec.setWidth 64 (BitVec.setWidth 32 x) >>> 24#64))) =
      (BitVec.setWidth 32 x).rotateLeft 8 := by
  bv_decide

theorem low_rot7 (x : Word) :
    BitVec.setWidth 32 (x <<< 7#64 ||| BitVec.signExtend 64 (BitVec.setWidth 32
      (BitVec.setWidth 64 (BitVec.setWidth 32 x) >>> 25#64))) =
      (BitVec.setWidth 32 x).rotateLeft 7 := by
  bv_decide

/-! ## Cells stored from registers -/

/-- Four bytes of memory hold only the low half of the word written to them. -/
theorem Heap.bytes_low (a v : Word) (w : Bool) :
    Heap.bytes a 4 v w = Heap.bytes a 4 ((v.setWidth 32).setWidth 64) w := by
  funext l
  cases l with
  | mem x =>
    simp only [Heap.bytes]
    split
    · rename_i hx
      have hx' : x - a < 4#64 := by simpa [BitVec.lt_def] using hx
      generalize x - a = i at hx'
      congr 3
      bv_decide
    · rfl
  | _ => rfl

/-- A 32-bit cell holds only the low half of the word written to it. -/
theorem memIs_low (p v : Word) :
    memIs p 4 ((v.setWidth 32).setWidth 64) true = memIs p 4 v true := by
  funext h
  simp only [memIs, ← Heap.bytes_low p v true]

/-- Addition as the stepper writes it when it evaluates an `add`: all three types `Word`. -/
local notation:65 a:65 " +ʷ " b:66 => @HAdd.hAdd Word Word Word instHAdd a b

/-- Four 32-bit cells that were stored from registers, as memory atoms: each holds the low
half of its register. -/
theorem cells4_low (p v0 v1 v2 v3 : Word) :
    (Atom.prop (cellsAt 4 true p [(v0.setWidth 32).setWidth 64, (v1.setWidth 32).setWidth 64,
      (v2.setWidth 32).setWidth 64, (v3.setWidth 32).setWidth 64])).interp =
      Atoms.interp [.mem p 4 v0 true, .mem (p +ʷ 4#64) 4 v1 true,
        .mem (p +ʷ 8#64) 4 v2 true, .mem (p +ʷ 12#64) 4 v3 true] := by
  rw [cells4]
  simp only [Atoms.interp, Atom.interp, memIs_low]

/-- Sixteen 32-bit cells that were stored from registers, as memory atoms. -/
theorem cells16_low (p v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 : Word) :
    (Atom.prop (cellsAt 4 true p
      [(v0.setWidth 32).setWidth 64, (v1.setWidth 32).setWidth 64, (v2.setWidth 32).setWidth 64,
        (v3.setWidth 32).setWidth 64, (v4.setWidth 32).setWidth 64, (v5.setWidth 32).setWidth 64,
        (v6.setWidth 32).setWidth 64, (v7.setWidth 32).setWidth 64, (v8.setWidth 32).setWidth 64,
        (v9.setWidth 32).setWidth 64, (v10.setWidth 32).setWidth 64, (v11.setWidth 32).setWidth 64,
        (v12.setWidth 32).setWidth 64, (v13.setWidth 32).setWidth 64,
        (v14.setWidth 32).setWidth 64, (v15.setWidth 32).setWidth 64])).interp =
      Atoms.interp [.mem p 4 v0 true, .mem (p +ʷ 4#64) 4 v1 true, .mem (p +ʷ 8#64) 4 v2 true,
        .mem (p +ʷ 12#64) 4 v3 true, .mem (p +ʷ 16#64) 4 v4 true, .mem (p +ʷ 20#64) 4 v5 true,
        .mem (p +ʷ 24#64) 4 v6 true, .mem (p +ʷ 28#64) 4 v7 true, .mem (p +ʷ 32#64) 4 v8 true,
        .mem (p +ʷ 36#64) 4 v9 true, .mem (p +ʷ 40#64) 4 v10 true, .mem (p +ʷ 44#64) 4 v11 true,
        .mem (p +ʷ 48#64) 4 v12 true, .mem (p +ʷ 52#64) 4 v13 true, .mem (p +ʷ 56#64) 4 v14 true,
        .mem (p +ʷ 60#64) 4 v15 true] := by
  rw [cells16]
  simp only [Atoms.interp, Atom.interp, memIs_low]

/-! ## The expression -/

/-- What the code of `quarter_round` computes, as arithmetic on 32-bit words. -/
def qr (a b c d : W32) : W32 × W32 × W32 × W32 :=
  let a := b + a
  let d := (d ^^^ a).rotateLeft 16
  let c := d + c
  let b := (c ^^^ b).rotateLeft 12
  let a := b + a
  let d := (a ^^^ d).rotateLeft 8
  let c := d + c
  let b := (c ^^^ b).rotateLeft 7
  (a, b, c, d)

/-- The expression is the quarter round. -/
theorem qr_eq (a b c d : W32) : qr a b c d = quarter a b c d := by
  simp only [qr, quarter, Prod.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_⟩ <;> bv_decide

/-! ## The code -/

/-- `quarter_round` replaces the four 32-bit words its argument points to, which must be a
multiple of 4, by their quarter round. -/
theorem quarter_round_spec (s r t1 t2 t3 t4 t5 : Word) (a b c d : W32)
    (hs : s &&& 3#64 = 0#64) :
    Triple quarter_round.program
      (Atoms.interp [.pc 0x10000#64, .reg a0 s, .reg a1 t1, .reg a2 t2, .reg a3 t3,
        .reg a4 t4, .reg a5 t5, .reg ra r,
        .prop (cellsAt 4 true s ([a, b, c, d].map (·.zeroExtend 64)))])
      (Atoms.interp [.pc (r &&& ~~~1#64), .reg a0 s, .prop (regAny a1), .prop (regAny a2),
        .prop (regAny a3), .prop (regAny a4), .prop (regAny a5), .reg ra r,
        .prop (cellsAt 4 true s ([(quarter a b c d).1, (quarter a b c d).2.1,
          (quarter a b c d).2.2.1, (quarter a b c d).2.2.2].map (·.zeroExtend 64)))]) := by
  rw [← qr_eq]
  simp only [qr]
  simp only [List.map_cons, List.map_nil]
  braid_unfold cells4 s _ _ _ _
  braid_sym_run
  braid_fold cells4_low s _ _ _ _
  -- From the outside in (`↓`): a rotation is recognized before its argument is rewritten.
  simp only [↓ low_add, ↓ low_xor, ↓ low_rot16, ↓ low_rot12, ↓ low_rot8, ↓ low_rot7,
    ↓ low_sext]
  braid_forget 11
  braid_forget 12
  braid_forget 13
  braid_forget 14
  braid_forget 15
  braid_done

/-! ## On the machine -/

/-- The `n` bytes from `a` and the `m` bytes from `b` have no address in common: each region
starts at or after the end of the other, going round the address space. -/
def Apart (a : Word) (n : Nat) (b : Word) (m : Nat) : Prop :=
  n ≤ (b - a).toNat ∧ m ≤ (a - b).toNat

/-- A machine related to a state with writable cells at the bytes of a word has those
bytes. -/
theorem hasBytes_of_mem {s : MachineState} {σ : State} (h : Rel s σ) {a v : Word} {n : Nat}
    (hm : ∀ x : Word, (x - a).toNat < n →
      σ.mem x = some ⟨(v >>> ((x - a) <<< 3)).truncate 8, true⟩) : HasBytes s a n v := by
  intro x hx
  obtain ⟨hv, hc⟩ := h.cell (hm x hx)
  exact ⟨hv, (congrArg Cell.val hc).symm⟩

/-- **`quarter_round` on the machine.** A machine that holds the code of `quarter_round`, is
at its entry, and has the 32-bit words `a`, `b`, `c` and `d` in valid memory where `a0`
points, `a0` a multiple of 4, runs to the return address with the quarter round of the four
words where `a0` pointed. -/
theorem quarter_round_correct (s : MachineState) (a b c d : W32)
    (hcode : ∀ p ∈ quarter_round_code, s.code p.1 = some p.2) (hpc : s.pc = 0x10000#64)
    (hp : s.getReg .x10 &&& 3#64 = 0#64)
    (ha : HasBytes s (s.getReg .x10) 4 (a.zeroExtend 64))
    (hb : HasBytes s (s.getReg .x10 + 4#64) 4 (b.zeroExtend 64))
    (hc : HasBytes s (s.getReg .x10 + 8#64) 4 (c.zeroExtend 64))
    (hd : HasBytes s (s.getReg .x10 + 12#64) 4 (d.zeroExtend 64)) :
    ∃ n s', stepN n s = some s' ∧ s'.pc = s.getReg .x1 &&& ~~~1#64 ∧
      HasBytes s' (s.getReg .x10) 4 ((quarter a b c d).1.zeroExtend 64) ∧
      HasBytes s' (s.getReg .x10 + 4#64) 4 ((quarter a b c d).2.1.zeroExtend 64) ∧
      HasBytes s' (s.getReg .x10 + 8#64) 4 ((quarter a b c d).2.2.1.zeroExtend 64) ∧
      HasBytes s' (s.getReg .x10 + 12#64) 4 ((quarter a b c d).2.2.2.zeroExtend 64) := by
  obtain ⟨n, s', σ', hn, hr, hq⟩ := machine_sound_flat quarter_round_lowered
    (quarter_round_spec (s.getReg .x10) (s.getReg .x1) (s.getReg .x11) (s.getReg .x12)
      (s.getReg .x13) (s.getReg .x14) (s.getReg .x15) a b c d hp) hcode
    (Flat.interp (by braid_flat))
    (by simp [Atom.IsPointsTo, cellsAtoms])
    (by simp only [List.map_cons, List.map_nil, cellsAtoms]
        braid_disj
        repeat' apply And.intro
        all_goals first
          | decide
          | (refine Atom.disj_mem_mem fun x hx => ?_
             obtain ⟨hx1, hx2⟩ := hx
             bv_omega))
    (by simp only [List.map_cons, List.map_nil, cellsAtoms, List.cons_append, List.nil_append,
          List.forall_mem_cons, sat_mem_abs]
        simp [Atom.sat_reg, Atom.sat_pc, abs, regOfNat, hpc, ha, hb, hc, hd,
          BitVec.add_assoc])
  have h := fun i hi => hasBytes_of_mem hr (a := s.getReg .x10 + BitVec.ofNat 64 (4 * i))
    (n := 4) fun x hx => cell_of_holds hq (by braid_at) i hi hx
  refine ⟨n, s', hn, ?_, ?_, ?_, ?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · simpa using h 0 (by simp)
  · simpa using h 1 (by simp)
  · simpa using h 2 (by simp)
  · simpa using h 3 (by simp)

end Examples.ChaCha20.RiscV
