/-
  Braid.Logic.Event

  The rules for the two operations that are events of the environment: `out`, which writes
  bytes of memory out, and `exit`. The bytes `out` writes are those of an array of bytes in
  the symbolic state, so the event in the trace is written with the contents of the array.

  ## Main results

  * `bytesAt_bytes`: an array of bytes is the bytes of the state's memory
  * `OpsSpec.out`, `OpsSpecT.out`: `out`, without and with the trace
  * `TermSpec.exit`, `TermSpecT.exit`: `exit`, without and with the trace
-/

module

public import Braid.Logic.Trace

public section

namespace Braid

open Iris Iris.BI

/-- An array of bytes in the symbolic state is the bytes of the state's memory there. -/
theorem bytesAt_bytes {a : Word} {bs : List (BitVec 8)} {R : SProp} {σ : State}
    (h : (bytesAt a bs).holds R σ) : σ.mem.bytes a bs.length = some bs := by
  induction bs generalizing a R with
  | nil => rfl
  | cons b bs ih =>
    have h₁ : (memIs a 1 (b.zeroExtend 64)).holds iprop(bytesAt (a + 1#64) bs ∗ R) σ :=
      SProp.holds_assoc.1 h
    have h₂ : (bytesAt (a + 1#64) bs).holds iprop(memIs a 1 (b.zeroExtend 64) ∗ R) σ :=
      SProp.holds_assoc.1 (SProp.holds_mono sep_comm.1 h)
    have hc := memIs_cell h₁ (x := a) (by simp)
    have hv : BitVec.truncate 8 (BitVec.zeroExtend 64 b >>> ((a - a) <<< 3)) = b := by
      rw [BitVec.sub_self]
      ext i
      simp
    rw [hv] at hc
    have hi := ih h₂
    simp [Mem.bytes, hc, hi]

/-- What `out` adds to the trace when it writes the bytes `bs`: one event, or nothing if
there are no bytes. -/
@[expose] def outLabels (bs : List (BitVec 8)) : Trace :=
  if bs = [] then [] else [.event (.write bs)]

@[simp] theorem outLabels_nil : outLabels [] = [] := rfl

@[simp] theorem outLabels_cons (b : BitVec 8) (bs : List (BitVec 8)) :
    outLabels (b :: bs) = [.event (.write (b :: bs))] := rfl

theorem Op.leak_out_eq {a n : Var} {ρ : Env} {σ : State} {bs : List (BitVec 8)}
    (hn : ρ n = BitVec.ofNat 64 bs.length) (hlen : bs.length < 2 ^ 64)
    (hb : σ.mem.bytes (ρ a) bs.length = some bs) : (Op.out a n).leak ρ σ = outLabels bs := by
  have e : (ρ n).toNat = bs.length := by rw [hn]; simp; omega
  simp only [Op.leak, e, hb, Option.getD_some, outLabels]
  cases bs with
  | nil => simp [hn]
  | cons b bs =>
    have : ρ n ≠ 0#64 := fun h0 => by rw [h0] at e; simp at e
    simp [this]

/-- `out` of an array of bytes in the symbolic state. -/
theorem OpsSpec.out {ops : List Op} {ρ : Env} {as : Atoms} {Φ : Env → Atoms → Prop}
    {a n : Var} {bs : List (BitVec 8)} (hat : as.At (.prop (bytesAt (ρ a) bs)))
    (hn : ρ n = BitVec.ofNat 64 bs.length) (hlen : bs.length < 2 ^ 64)
    (h : OpsSpec ops ρ as Φ) : OpsSpec (.out a n :: ops) ρ as Φ := by
  refine ⟨fun R σ hs => ?_⟩
  obtain ⟨F, e⟩ := hat.split
  have e' : (ρ n).toNat = bs.length := by rw [hn]; simp; omega
  exact ⟨⟨bs, e' ▸ bytesAt_bytes ((holds_split e).1 hs)⟩, h.run R σ hs⟩

/-- **`out`, with the trace.** The bytes of an array in the symbolic state are written out:
the trace gains the event, and the state is as it was. -/
theorem OpsSpecT.out {ops : List Op} {ρ : Env} {as : Atoms} {t : Trace}
    {Φ : Env → Atoms → Trace → Prop} {a n : Var} {bs : List (BitVec 8)}
    (hat : as.At (.prop (bytesAt (ρ a) bs))) (hn : ρ n = BitVec.ofNat 64 bs.length)
    (hlen : bs.length < 2 ^ 64) (h : OpsSpecT ops ρ as (t ++ outLabels bs) Φ) :
    OpsSpecT (.out a n :: ops) ρ as t Φ := by
  refine ⟨fun R σ hs => ?_⟩
  obtain ⟨F, e⟩ := hat.split
  have hb := bytesAt_bytes ((holds_split e).1 hs)
  have e' : (ρ n).toNat = bs.length := by rw [hn]; simp; omega
  simp only [wpOpsL, Op.wpL, Op.wp, Op.leak_out_eq hn hlen hb]
  exact ⟨⟨bs, e' ▸ hb⟩, h.run R σ hs⟩

/-- `exit`: a branch on whether the program exits. -/
theorem TermSpec.exit {ρ : Env} {as : Atoms} {Φ : Atoms → Prop} {p t f : Word} {c x : Var}
    {as₁ as₂ : Atoms} (h₁ : as.Upd (.pc p) (.pc t) as₁) (h₂ : as.Upd (.pc p) (.pc f) as₂)
    (ht : ρ c ≠ 0#64 → Φ as₁) (hf : ρ c = 0#64 → Φ as₂) : TermSpec (.exit c x t f) ρ as Φ := by
  refine ⟨fun R σ hs => ?_⟩
  simp only [Term.wp]
  by_cases hc : ρ c = 0#64
  · simp only [ne_eq, hc, not_true_eq_false, ↓reduceIte]
    exact ⟨as₂, hf hc, TermSpec.pc_set f h₂ hs⟩
  · simp only [ne_eq, hc, not_false_eq_true, ↓reduceIte]
    exact ⟨as₁, ht hc, TermSpec.pc_set t h₁ hs⟩

/-- **`exit`, when the program exits.** The trace gains the exit event with its code, and
the program counter is where the terminator says an exited program stays. -/
theorem TermSpecT.exit {ρ : Env} {as as' : Atoms} {u : Trace} {Φ : Atoms → Trace → Prop}
    {p t f : Word} {c x : Var} (hc : ρ c ≠ 0#64) (h : as.Upd (.pc p) (.pc t) as')
    (hΦ : Φ as' (u ++ [.event (.exit (ρ x))])) : TermSpecT (.exit c x t f) ρ as u Φ := by
  refine ⟨fun R σ hs => ?_⟩
  simp only [Term.wpL, Term.wp, Term.leak, hc, ne_eq, not_false_eq_true, ↓reduceIte]
  exact ⟨as', hΦ, TermSpec.pc_set t h hs⟩

/-- **`exit`, when the program goes on.** Nothing is added to the trace. -/
theorem TermSpecT.exit_next {ρ : Env} {as as' : Atoms} {u : Trace} {Φ : Atoms → Trace → Prop}
    {p t f : Word} {c x : Var} (hc : ρ c = 0#64) (h : as.Upd (.pc p) (.pc f) as')
    (hΦ : Φ as' u) : TermSpecT (.exit c x t f) ρ as u Φ := by
  refine ⟨fun R σ hs => ?_⟩
  simp only [Term.wpL, Term.wp, Term.leak, hc, ne_eq, not_true_eq_false, ↓reduceIte,
    List.append_nil]
  exact ⟨as', hΦ, TermSpec.pc_set f h hs⟩

end Braid
