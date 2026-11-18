/-
  Braid.Logic.Data

  Assertions about data in memory and registers beyond single points-to facts: arrays of
  words, and a register whose value is not known. Each comes with rules to open it into
  atoms inside a symbolic state and to close it again.

  ## Main definitions

  * `wordsAt`, `bytesAt`: an array of 64-bit words, and of bytes
  * `regAny`: a register holding some value

  ## Main results

  * `Triple.unfold`, `Triple.fold`: replace an atom by atoms that mean the same, and back
  * `Triple.forget_reg`, `Triple.reg_any`: forget the value of a register, and name it
-/

module

public import Braid.Logic.Exec
import Iris.BI.DerivedLaws

@[expose] public section

namespace Braid

open Iris Iris.BI

/-- The 64-bit words `xs` are in memory from `p` on, writable. -/
def wordsAt (p : Word) : List Word → SProp
  | [] => iprop(emp)
  | x :: xs => iprop(memIs p 8 x ∗ wordsAt (p + 8#64) xs)

/-- The bytes `bs` are in memory from `p` on, writable. -/
def bytesAt (p : Word) : List (BitVec 8) → SProp
  | [] => iprop(emp)
  | b :: bs => iprop(memIs p 1 (b.zeroExtend 64) ∗ bytesAt (p + 1#64) bs)

/-- Register `r` holds some value. -/
def regAny (r : Reg) : SProp := iprop(∃ v, regIs r v)

theorem wordsAt_nil (p : Word) : (Atom.prop (wordsAt p [])).interp = Atoms.interp [] := rfl

/-- A nonempty array is its first word and the rest. -/
theorem wordsAt_cons (p x : Word) (xs : List Word) :
    (Atom.prop (wordsAt p (x :: xs))).interp =
      Atoms.interp [.mem p 8 x true, .prop (wordsAt (p + 8#64) xs)] :=
  SProp.ext (sep_mono_right sep_emp.symm.1 |> fun h => ⟨h, sep_mono_right sep_emp.1⟩)

theorem bytesAt_nil (p : Word) : (Atom.prop (bytesAt p [])).interp = Atoms.interp [] := rfl

/-- A nonempty array of bytes is its first byte and the rest. -/
theorem bytesAt_cons (p : Word) (b : BitVec 8) (bs : List (BitVec 8)) :
    (Atom.prop (bytesAt p (b :: bs))).interp =
      Atoms.interp [.mem p 1 (b.zeroExtend 64) true, .prop (bytesAt (p + 1#64) bs)] :=
  SProp.ext (sep_mono_right sep_emp.symm.1 |> fun h => ⟨h, sep_mono_right sep_emp.1⟩)

/-- Replace an atom of the symbolic state by atoms that mean the same. -/
theorem Triple.unfold {P : Program} {as rest bs : Atoms} {a : Atom} {Q : SProp}
    (hext : as.Extract a rest) (heq : a.interp = Atoms.interp bs)
    (h : Triple P (Atoms.interp (bs ++ rest)) Q) : Triple P (Atoms.interp as) Q := by
  rw [hext.interp, heq, ← Atoms.interp_append]; exact h

/-- Replace atoms of the symbolic state by one atom that means the same. -/
theorem Triple.fold {P : Program} {as rest bs : Atoms} (a : Atom) {Q : SProp}
    (hsplit : as.Split bs rest) (heq : a.interp = Atoms.interp bs)
    (h : Triple P (Atoms.interp (a :: rest)) Q) : Triple P (Atoms.interp as) Q := by
  rw [hsplit.interp, Atoms.interp_append, ← heq]; exact h

/-- Forget the value of a register. -/
theorem Triple.forget_reg {P : Program} {as as' : Atoms} {r : Reg} {v : Word} {Q : SProp}
    (hupd : as.Upd (.reg r v) (.prop (regAny r)) as')
    (h : Triple P (Atoms.interp as') Q) : Triple P (Atoms.interp as) Q := by
  obtain ⟨F, e, e'⟩ := hupd.split
  rw [e]; rw [e'] at h
  exact h.conseq (sep_mono_left (fun _ hv => ⟨_, ⟨v, rfl⟩, hv⟩)) .rfl

/-- Name the value of a register that holds some value. -/
theorem Triple.reg_any {P : Program} {as rest : Atoms} {r : Reg} {Q : SProp}
    (hext : as.Extract (.prop (regAny r)) rest)
    (h : ∀ v, Triple P (Atoms.interp (.reg r v :: rest)) Q) : Triple P (Atoms.interp as) Q := by
  rw [hext.interp]
  exact (Triple.exists_pre h).conseq sep_exists_right.1 .rfl

end Braid
