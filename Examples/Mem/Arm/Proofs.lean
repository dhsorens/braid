/-
  Examples.Mem.Arm.Proofs

  `mem.c` on AArch64: copying bytes and comparing bytes, the first rung of the scaling
  ladder (`docs/Scaling.md`).
-/

module

public import Examples.Mem.Arm.Image
public import Examples.ArmMachine
public import Examples.Spec

public section

namespace Examples.Mem.Arm

open Braid Examples Lowering.Arm Lowering.Arm.Regs

/-- The loop of `copy_bytes`: copy the `n` bytes from `ps` to `pd`. -/
theorem copy_bytes_loop (r : Word) : ∀ (ss ds : List (BitVec 8)) (s d : BitVec 8)
    (pd ps n t : Word) (fn fz fc fv : Bool), ds.length = ss.length →
    n = BitVec.ofNat 64 (ss.length + 1) → ss.length + 1 < 2 ^ 64 →
    Triple copy_bytes.program
      (Atoms.interp [.pc 0x10004#64, .reg x0 pd, .reg x1 ps, .reg x2 n, .reg x8 t,
        .prop (bytesAt ps (s :: ss)), .prop (bytesAt pd (d :: ds)), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .prop (regAny x0), .prop (regAny x1), .reg x2 0#64,
        .prop (regAny x8), .prop (bytesAt ps (s :: ss)), .prop (bytesAt pd (s :: ss)),
        .reg lr r, .prop (flagAny Flags.n), .prop (flagAny Flags.z),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) := by
  intro ss
  induction ss with
  | nil =>
    intro ds s d pd ps n t fn fz fc fv hlen he hb
    have hds : ds = [] := List.length_eq_zero_iff.1 hlen
    have he' : n = 1#64 := by simpa using he
    subst hds he'
    braid_unfold bytesAt_cons ps s []
    braid_unfold bytesAt_cons pd d []
    braid_sym_run
    braid_fold bytesAt_cons ps s []
    braid_fold bytesAt_cons pd s []
    braid_forget 0
    braid_forget 1
    braid_forget 8
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    braid_done
  | cons c cs ih =>
    intro ds s d pd ps n t fn fz fc fv hlen he hb
    obtain ⟨d', ds', rfl⟩ : ∃ d' ds', ds = d' :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at he hb hlen
    braid_unfold bytesAt_cons ps s (c :: cs)
    braid_unfold bytesAt_cons pd d (d' :: ds')
    braid_sym_run
    · braid_call ih ds' c d' (pd + 1#64) (ps + 1#64) (n + 0xffffffffffffffff#64) _ _ _ _ _
        (by omega) (by rw [he]; bv_omega) (by omega)
      braid_fold bytesAt_cons ps s (c :: cs)
      braid_fold bytesAt_cons pd s (c :: cs)
      braid_done
    · exfalso
      have : n ≠ 1#64 := by rw [he]; bv_omega
      exact this hbr

/-- `copy_bytes` copies the `n` bytes its second argument points to over the `n` bytes its
first argument points to. -/
theorem copy_bytes_spec (pd ps r t : Word) (ss ds : List (BitVec 8)) (fn fz fc fv : Bool)
    (hlen : ds.length = ss.length) (hl : ss.length < 2 ^ 64) :
    Triple copy_bytes.program
      (Atoms.interp [.pc 0x10000#64, .reg x0 pd, .reg x1 ps,
        .reg x2 (BitVec.ofNat 64 ss.length), .reg x8 t,
        .prop (bytesAt ps ss), .prop (bytesAt pd ds), .reg lr r,
        .flag Flags.n fn, .flag Flags.z fz, .flag Flags.c fc, .flag Flags.v fv])
      (Atoms.interp [.pc r, .prop (regAny x0), .prop (regAny x1), .reg x2 0#64,
        .prop (regAny x8), .prop (bytesAt ps ss), .prop (bytesAt pd ss),
        .reg lr r, .prop (flagAny Flags.n), .prop (flagAny Flags.z),
        .prop (flagAny Flags.c), .prop (flagAny Flags.v)]) := by
  cases ss with
  | nil =>
    have hds : ds = [] := List.length_eq_zero_iff.1 hlen
    subst hds
    simp only [List.length_nil]
    braid_sym_run
    braid_forget 0
    braid_forget 1
    braid_forget 8
    braid_forget_flag 0
    braid_forget_flag 1
    braid_forget_flag 2
    braid_forget_flag 3
    braid_done
  | cons s ss =>
    obtain ⟨d, ds', rfl⟩ : ∃ d ds', ds = d :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at hl hlen ⊢
    braid_sym_step
    · braid_call copy_bytes_loop r ss ds' s d pd ps _ t fn fz fc fv (by omega) rfl hl
      braid_done
    · exfalso
      have : BitVec.ofNat 64 (ss.length + 1) ≠ 0#64 := by bv_omega
      exact this hbr

end Examples.Mem.Arm
