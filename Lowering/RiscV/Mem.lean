/-
  Lowering.RiscV.Mem

  The machine model's memory, byte by byte. riscv-zkvm keeps memory as aligned doublewords
  and reads a byte out of the doubleword that holds it. `braid` memory is bytes. These
  lemmas say what each access of the machine model does to the bytes.

  ## Main results

  * `getMem_bytes`, `getWord32_bytes`, `getHalfword_bytes`: an aligned read, from its bytes
  * `getByte_setMem`, `getByte_setWord32`, `getByte_setHalfword`, `getByte_setByte`: the
    bytes after an aligned write
-/

module

public import RiscvZkvm.Rv64.Execution
import Braid.BV

@[expose] public section

namespace Lowering.RiscV

open RiscvZkvm.Rv64

/-- The byte of the doubleword `w` that the address `a` selects. -/
def byteAt (w a : Word) : BitVec 8 := (w >>> ((a &&& 7#64) <<< 3)).truncate 8

theorem shift3_toNat (a : Word) : ((a &&& 7#64) <<< 3).toNat = (a &&& 7#64).toNat * 8 := by
  have h : ∀ k : BitVec 3, ((k.setWidth 64 : Word) <<< 3).toNat = (k.setWidth 64 : Word).toNat * 8 := by
    decide
  have e : a &&& 7#64 = (a.setWidth 3).setWidth 64 := by bv_auto
  rw [e]; exact h _

theorem shift3_toNat_half (a : Word) :
    ((a &&& 6#64) <<< 3).toNat = (a &&& 7#64).toNat / 2 * 16 := by
  have h : ∀ k : BitVec 3, (((k &&& 6#3).setWidth 64 : Word) <<< 3).toNat =
      (k.setWidth 64 : Word).toNat / 2 * 16 := by decide
  have e : a &&& 7#64 = (a.setWidth 3).setWidth 64 := by bv_auto
  have e' : a &&& 6#64 = ((a.setWidth 3) &&& 6#3).setWidth 64 := by bv_auto
  rw [e, e']; exact h _

theorem shift3_toNat_word (a : Word) :
    ((a &&& 4#64) <<< 3).toNat = (a &&& 7#64).toNat / 4 * 32 := by
  have h : ∀ k : BitVec 3, (((k &&& 4#3).setWidth 64 : Word) <<< 3).toNat =
      (k.setWidth 64 : Word).toNat / 4 * 32 := by decide
  have e : a &&& 7#64 = (a.setWidth 3).setWidth 64 := by bv_auto
  have e' : a &&& 4#64 = ((a.setWidth 3) &&& 4#3).setWidth 64 := by bv_auto
  rw [e, e']; exact h _

theorem getByte_eq (s : MachineState) (a : Word) :
    s.getByte a = byteAt (s.mem (a &&& ~~~7#64)) a := by
  simp only [MachineState.getByte, MachineState.getMem, extractByte, byteOffset, alignToDword,
    byteAt, BitVec.ushiftRight_eq', shift3_toNat]

theorem getHalfword_eq (s : MachineState) (a : Word) :
    s.getHalfword a = (s.mem (a &&& ~~~7#64) >>> ((a &&& 6#64) <<< 3)).truncate 16 := by
  simp only [MachineState.getHalfword, MachineState.getMem, extractHalfword, byteOffset,
    alignToDword, BitVec.ushiftRight_eq', shift3_toNat_half]

theorem getWord32_eq (s : MachineState) (a : Word) :
    s.getWord32 a = (s.mem (a &&& ~~~7#64) >>> ((a &&& 4#64) <<< 3)).truncate 32 := by
  simp only [MachineState.getWord32, MachineState.getMem, extractWord32, byteOffset,
    alignToDword, BitVec.ushiftRight_eq', shift3_toNat_word]

/-! ## Aligned reads, from their bytes -/

theorem getMem_bytes (s : MachineState) {a : Word} (ha : a &&& 7#64 = 0#64) :
    s.getMem a = s.getByte (a + 7) ++ s.getByte (a + 6) ++ s.getByte (a + 5) ++
      s.getByte (a + 4) ++ s.getByte (a + 3) ++ s.getByte (a + 2) ++ s.getByte (a + 1) ++
      s.getByte a := by
  have e0 : a &&& ~~~7#64 = a := by bv_auto
  have e1 : (a + 1) &&& ~~~7#64 = a := by bv_auto
  have e2 : (a + 2) &&& ~~~7#64 = a := by bv_auto
  have e3 : (a + 3) &&& ~~~7#64 = a := by bv_auto
  have e4 : (a + 4) &&& ~~~7#64 = a := by bv_auto
  have e5 : (a + 5) &&& ~~~7#64 = a := by bv_auto
  have e6 : (a + 6) &&& ~~~7#64 = a := by bv_auto
  have e7 : (a + 7) &&& ~~~7#64 = a := by bv_auto
  simp only [getByte_eq, e0, e1, e2, e3, e4, e5, e6, e7, MachineState.getMem, byteAt]
  generalize s.mem a = w
  bv_auto

theorem getWord32_bytes (s : MachineState) {a : Word} (ha : a &&& 3#64 = 0#64) :
    s.getWord32 a = s.getByte (a + 3) ++ s.getByte (a + 2) ++ s.getByte (a + 1) ++
      s.getByte a := by
  have e1 : (a + 1) &&& ~~~7#64 = a &&& ~~~7#64 := by bv_auto
  have e2 : (a + 2) &&& ~~~7#64 = a &&& ~~~7#64 := by bv_auto
  have e3 : (a + 3) &&& ~~~7#64 = a &&& ~~~7#64 := by bv_auto
  simp only [getByte_eq, getWord32_eq, e1, e2, e3, byteAt]
  generalize s.mem (a &&& ~~~7#64) = w
  bv_auto

theorem getHalfword_bytes (s : MachineState) {a : Word} (ha : a &&& 1#64 = 0#64) :
    s.getHalfword a = s.getByte (a + 1) ++ s.getByte a := by
  have e1 : (a + 1) &&& ~~~7#64 = a &&& ~~~7#64 := by bv_auto
  simp only [getByte_eq, getHalfword_eq, e1, byteAt]
  generalize s.mem (a &&& ~~~7#64) = w
  bv_auto

/-! ## The bytes after an aligned write -/

theorem mem_setMem (s : MachineState) (a v x : Word) :
    (s.setMem a v).mem x = if x = a then v else s.mem x := by
  simp [MachineState.setMem]

theorem getByte_setMem (s : MachineState) {a : Word} (v x : Word) (ha : a &&& 7#64 = 0#64) :
    (s.setMem a v).getByte x =
      if (x - a).toNat < 8 then (v >>> ((x - a) <<< 3)).truncate 8 else s.getByte x := by
  have hlt : (x - a).toNat < 8 ↔ x - a < 8#64 := Iff.rfl
  simp only [getByte_eq, mem_setMem, hlt, byteAt]
  by_cases hx : x &&& ~~~7#64 = a
  · have : x - a < 8#64 := by bv_auto
    simp only [hx, this, ↓reduceIte]
    bv_auto
  · have : ¬ x - a < 8#64 := by bv_auto
    simp only [hx, this, ↓reduceIte]

theorem setWord32_eq (s : MachineState) (a : Word) (v : BitVec 32) :
    s.setWord32 a v = s.setMem (a &&& ~~~7#64)
      ((s.mem (a &&& ~~~7#64) &&& ~~~(0xFFFFFFFF#64 <<< ((a &&& 4#64) <<< 3))) |||
        (v.zeroExtend 64 <<< ((a &&& 4#64) <<< 3))) := by
  simp only [MachineState.setWord32, MachineState.getMem, replaceWord32, byteOffset,
    alignToDword, BitVec.shiftLeft_eq', shift3_toNat_word]

theorem setHalfword_eq (s : MachineState) (a : Word) (v : BitVec 16) :
    s.setHalfword a v = s.setMem (a &&& ~~~7#64)
      ((s.mem (a &&& ~~~7#64) &&& ~~~(0xFFFF#64 <<< ((a &&& 6#64) <<< 3))) |||
        (v.zeroExtend 64 <<< ((a &&& 6#64) <<< 3))) := by
  simp only [MachineState.setHalfword, MachineState.getMem, replaceHalfword, byteOffset,
    alignToDword, BitVec.shiftLeft_eq', shift3_toNat_half]

theorem setByte_eq (s : MachineState) (a : Word) (v : BitVec 8) :
    s.setByte a v = s.setMem (a &&& ~~~7#64)
      ((s.mem (a &&& ~~~7#64) &&& ~~~(0xFF#64 <<< ((a &&& 7#64) <<< 3))) |||
        (v.zeroExtend 64 <<< ((a &&& 7#64) <<< 3))) := by
  simp only [MachineState.setByte, MachineState.getMem, replaceByte, byteOffset,
    alignToDword, BitVec.shiftLeft_eq', shift3_toNat]

theorem getByte_setWord32 (s : MachineState) {a : Word} (v x : Word) (ha : a &&& 3#64 = 0#64) :
    (s.setWord32 a (v.truncate 32)).getByte x =
      if (x - a).toNat < 4 then (v >>> ((x - a) <<< 3)).truncate 8 else s.getByte x := by
  have hlt : (x - a).toNat < 4 ↔ x - a < 4#64 := Iff.rfl
  simp only [setWord32_eq, getByte_eq, mem_setMem, hlt, byteAt]
  by_cases hx : x &&& ~~~7#64 = a &&& ~~~7#64
  · simp only [hx, ↓reduceIte]
    generalize s.mem (a &&& ~~~7#64) = w
    bv_auto
  · have : ¬ x - a < 4#64 := by bv_auto
    simp only [hx, this, ↓reduceIte]

theorem getByte_setHalfword (s : MachineState) {a : Word} (v x : Word)
    (ha : a &&& 1#64 = 0#64) :
    (s.setHalfword a (v.truncate 16)).getByte x =
      if (x - a).toNat < 2 then (v >>> ((x - a) <<< 3)).truncate 8 else s.getByte x := by
  have hlt : (x - a).toNat < 2 ↔ x - a < 2#64 := Iff.rfl
  simp only [setHalfword_eq, getByte_eq, mem_setMem, hlt, byteAt]
  by_cases hx : x &&& ~~~7#64 = a &&& ~~~7#64
  · simp only [hx, ↓reduceIte]
    generalize s.mem (a &&& ~~~7#64) = w
    bv_auto
  · have : ¬ x - a < 2#64 := by bv_auto
    simp only [hx, this, ↓reduceIte]

theorem getByte_setByte (s : MachineState) (a v x : Word) :
    (s.setByte a (v.truncate 8)).getByte x =
      if (x - a).toNat < 1 then (v >>> ((x - a) <<< 3)).truncate 8 else s.getByte x := by
  have hlt : (x - a).toNat < 1 ↔ x - a < 1#64 := Iff.rfl
  simp only [setByte_eq, getByte_eq, mem_setMem, hlt, byteAt]
  by_cases hx : x &&& ~~~7#64 = a &&& ~~~7#64
  · simp only [hx, ↓reduceIte]
    generalize s.mem (a &&& ~~~7#64) = w
    bv_auto
  · have : ¬ x - a < 1#64 := by bv_auto
    simp only [hx, this, ↓reduceIte]

end Lowering.RiscV
