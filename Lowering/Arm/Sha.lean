/-
  Lowering.Arm.Sha

  The SHA-256 instructions of the AArch64 lowering are sound. Each is compared with the
  model word by word: the lowered operations leave two words that are named functions of the
  words of the operands, and the model's value is those two words.

  ## Main results

  * `sha256Hash_work`: the model's four rounds are `hashWork`
  * `evalInst_sha256h`, `evalInst_sha256h2`, `evalInst_su0`, `evalInst_su1`: the words the
    model writes, as `sha256hLo`, `sha256hHi`, `sha256h2Lo`, `sha256h2Hi`, `su0Lo`, `su0Hi`,
    `su1Lo` and `su1Hi` of the words of the operands
  * `wp_hashWords`, `wp_hash2Words`, `wp_su0Words`, `wp_su1Words`: the words the lowered
    operations leave
  * `sound_cryptoSha2Reg`, `sound_cryptoSha3Reg`: the instructions are sound
-/

module

public import Lowering.Arm.Simd
import Std.Tactic.BVDecide
import Braid.BV

@[expose] public section

namespace Lowering.Arm

open Braid

/-! ## The model, on words -/

/-- One round of the model's `sha256Hash`, with its message word. -/
def mround (xy : BitVec 128 × BitVec 128) (k : BitVec 32) : BitVec 128 × BitVec 128 :=
  let x := xy.1
  let y := xy.2
  let x0 := x.extractLsb' 0 32
  let x1 := x.extractLsb' 32 32
  let x2 := x.extractLsb' 64 32
  let x3 := x.extractLsb' 96 32
  let y0 := y.extractLsb' 0 32
  let y1 := y.extractLsb' 32 32
  let y2 := y.extractLsb' 64 32
  let y3 := y.extractLsb' 96 32
  let chs := Arm64.shaChoose32 y0 y1 y2
  let maj := Arm64.shaMajority32 x0 x1 x2
  let t := y3 + Arm64.sha256Sigma1 y0 + chs + k
  let x3' := t + x3
  let y3' := t + Arm64.sha256Sigma0 x0 + maj
  (x2 ++ x1 ++ x0 ++ y3', y2 ++ y1 ++ y0 ++ x3')

/-- The model's four rounds, one after the other. -/
theorem sha256Hash_eq (x y w : BitVec 128) (p : Bool) :
    Arm64.sha256Hash x y w p =
      if p then (mround (mround (mround (mround (x, y) (w.extractLsb' 0 32))
        (w.extractLsb' 32 32)) (w.extractLsb' 64 32)) (w.extractLsb' 96 32)).1
      else (mround (mround (mround (mround (x, y) (w.extractLsb' 0 32))
        (w.extractLsb' 32 32)) (w.extractLsb' 64 32)) (w.extractLsb' 96 32)).2 := by
  cases p <;> rfl

/-- The vector register that holds the working words `a` to `d` in its lanes. -/
def Work.x (s : Work) : BitVec 128 :=
  s.d.setWidth 32 ++ s.c.setWidth 32 ++ s.b.setWidth 32 ++ s.a.setWidth 32

/-- The vector register that holds the working words `e` to `h` in its lanes. -/
def Work.y (s : Work) : BitVec 128 :=
  s.h.setWidth 32 ++ s.g.setWidth 32 ++ s.f.setWidth 32 ++ s.e.setWidth 32

/-- A round of the model, of working words that are the low halves of words, is `Work.step`.
The first and the fifth working word must be below `2 ^ 32`. -/
theorem mround_step (s : Work) (k : Word) (ha : s.a >>> 32#64 = 0#64)
    (he : s.e >>> 32#64 = 0#64) :
    mround (s.x, s.y) (k.setWidth 32) = ((s.step k).x, (s.step k).y) := by
  obtain ⟨a, b, c, d, e, f, g, h⟩ := s
  simp only [mround, Work.x, Work.y, Work.step, Arm64.shaChoose32, Arm64.shaMajority32,
    Arm64.sha256Sigma0, Arm64.sha256Sigma1, rndA, rndE, rndT, bigSig, dupLo, Prod.mk.injEq]
    at ha he ⊢
  constructor <;> bv_decide

theorem init_a_lt (x0 x1 y0 y1 : Word) : (Work.init x0 x1 y0 y1).a >>> 32#64 = 0#64 := by
  simp only [Work.init]
  bv_auto

theorem init_e_lt (x0 x1 y0 y1 : Word) : (Work.init x0 x1 y0 y1).e >>> 32#64 = 0#64 := by
  simp only [Work.init]
  bv_auto

theorem step_a_lt (s : Work) (k : Word) : (s.step k).a >>> 32#64 = 0#64 := by
  simp only [Work.step]
  generalize rndA _ _ _ _ _ _ _ _ = t
  bv_auto

theorem step_e_lt (s : Work) (k : Word) : (s.step k).e >>> 32#64 = 0#64 := by
  simp only [Work.step]
  generalize rndE _ _ _ _ _ _ = t
  bv_auto

/-- Two vector registers are the working words of `Work.init` of their words. -/
theorem init_x (x0 x1 y0 y1 : Word) : (x1 ++ x0 : BitVec 128) = (Work.init x0 x1 y0 y1).x := by
  simp only [Work.init, Work.x]
  bv_auto

theorem init_y (x0 x1 y0 y1 : Word) : (y1 ++ y0 : BitVec 128) = (Work.init x0 x1 y0 y1).y := by
  simp only [Work.init, Work.y]
  bv_auto

/-- The words of the register that holds `a` to `d`, where `a` and `c` are below
`2 ^ 32`. -/
theorem work_x (s : Work) (ha : s.a >>> 32#64 = 0#64) (hc : s.c >>> 32#64 = 0#64) :
    s.x = (s.c ||| s.d <<< 32#64) ++ (s.a ||| s.b <<< 32#64) := by
  obtain ⟨a, b, c, d, e, f, g, h⟩ := s
  simp only [Work.x] at ha hc ⊢
  bv_decide

/-- The words of the register that holds `e` to `h`, where `e` and `g` are below
`2 ^ 32`. -/
theorem work_y (s : Work) (he : s.e >>> 32#64 = 0#64) (hg : s.g >>> 32#64 = 0#64) :
    s.y = (s.g ||| s.h <<< 32#64) ++ (s.e ||| s.f <<< 32#64) := by
  obtain ⟨a, b, c, d, e, f, g, h⟩ := s
  simp only [Work.y] at he hg ⊢
  bv_decide

theorem lane0 (w0 w1 : Word) : (w1 ++ w0 : BitVec 128).extractLsb' 0 32 = w0.setWidth 32 := by
  bv_auto

theorem lane1 (w0 w1 : Word) :
    (w1 ++ w0 : BitVec 128).extractLsb' 32 32 = (w0 >>> 32#64).setWidth 32 := by
  bv_auto

theorem lane2 (w0 w1 : Word) : (w1 ++ w0 : BitVec 128).extractLsb' 64 32 = w1.setWidth 32 := by
  bv_auto

theorem lane3 (w0 w1 : Word) :
    (w1 ++ w0 : BitVec 128).extractLsb' 96 32 = (w1 >>> 32#64).setWidth 32 := by
  bv_auto

/-- **The model's four rounds are `hashWork`.** The registers that hold `a` to `d` and `e`
to `h` after `sha256Hash` are those of the working words after four steps. -/
theorem sha256Hash_work (x0 x1 y0 y1 w0 w1 : Word) (p : Bool) :
    Arm64.sha256Hash (x1 ++ x0) (y1 ++ y0) (w1 ++ w0) p =
      if p then (hashWork x0 x1 y0 y1 w0 w1).x else (hashWork x0 x1 y0 y1 w0 w1).y := by
  rw [sha256Hash_eq, lane0, lane1, lane2, lane3, init_x x0 x1 y0 y1, init_y x0 x1 y0 y1,
    mround_step _ _ (init_a_lt ..) (init_e_lt ..),
    mround_step _ _ (step_a_lt ..) (step_e_lt ..),
    mround_step _ _ (step_a_lt ..) (step_e_lt ..),
    mround_step _ _ (step_a_lt ..) (step_e_lt ..)]
  rfl

/-- The model's `SHA256H`, on words. -/
theorem sha256Hash_h (vd vn vm : BitVec 128) :
    Arm64.sha256Hash vd vn vm true =
      sha256hHi (vd.truncate 64) (vd.extractLsb' 64 64) (vn.truncate 64) (vn.extractLsb' 64 64)
          (vm.truncate 64) (vm.extractLsb' 64 64) ++
        sha256hLo (vd.truncate 64) (vd.extractLsb' 64 64) (vn.truncate 64)
          (vn.extractLsb' 64 64) (vm.truncate 64) (vm.extractLsb' 64 64) := by
  have h := sha256Hash_work (vd.truncate 64) (vd.extractLsb' 64 64) (vn.truncate 64)
    (vn.extractLsb' 64 64) (vm.truncate 64) (vm.extractLsb' 64 64) true
  rw [halves_append, halves_append, halves_append] at h
  rw [h]
  exact work_x _ (step_a_lt ..) (step_a_lt ..)

/-- The model's `SHA256H2`, on words: `vd` holds `e` to `h` and `vn` holds `a` to `d`. -/
theorem sha256Hash_h2 (vd vn vm : BitVec 128) :
    Arm64.sha256Hash vn vd vm false =
      sha256h2Hi (vd.truncate 64) (vd.extractLsb' 64 64) (vn.truncate 64)
          (vn.extractLsb' 64 64) (vm.truncate 64) (vm.extractLsb' 64 64) ++
        sha256h2Lo (vd.truncate 64) (vd.extractLsb' 64 64) (vn.truncate 64)
          (vn.extractLsb' 64 64) (vm.truncate 64) (vm.extractLsb' 64 64) := by
  have h := sha256Hash_work (vn.truncate 64) (vn.extractLsb' 64 64) (vd.truncate 64)
    (vd.extractLsb' 64 64) (vm.truncate 64) (vm.extractLsb' 64 64) false
  rw [halves_append, halves_append, halves_append] at h
  rw [h]
  exact work_y _ (step_e_lt ..) (step_e_lt ..)

variable {s : Arm64.State} (prog : Arm64.Program) (rm rn rd : BitVec 5)

/-- The model's `SHA256H` writes `sha256hLo` and `sha256hHi` of the words of its operands. -/
theorem evalInst_sha256h (s : Arm64.State) :
    prog.evalInst (.cryptoSha3Reg 4#3 rm rn rd) s =
      (s.writeVReg128 rd
        (sha256hHi ((s.vregs.read rd).truncate 64) ((s.vregs.read rd).extractLsb' 64 64)
            ((s.vregs.read rn).truncate 64) ((s.vregs.read rn).extractLsb' 64 64)
            ((s.vregs.read rm).truncate 64) ((s.vregs.read rm).extractLsb' 64 64) ++
          sha256hLo ((s.vregs.read rd).truncate 64) ((s.vregs.read rd).extractLsb' 64 64)
            ((s.vregs.read rn).truncate 64) ((s.vregs.read rn).extractLsb' 64 64)
            ((s.vregs.read rm).truncate 64) ((s.vregs.read rm).extractLsb' 64 64))).advancePC := by
  rw [← sha256Hash_h]
  rfl

/-- The model's `SHA256H2` writes `sha256h2Lo` and `sha256h2Hi` of the words of its
operands. -/
theorem evalInst_sha256h2 (s : Arm64.State) :
    prog.evalInst (.cryptoSha3Reg 5#3 rm rn rd) s =
      (s.writeVReg128 rd
        (sha256h2Hi ((s.vregs.read rd).truncate 64) ((s.vregs.read rd).extractLsb' 64 64)
            ((s.vregs.read rn).truncate 64) ((s.vregs.read rn).extractLsb' 64 64)
            ((s.vregs.read rm).truncate 64) ((s.vregs.read rm).extractLsb' 64 64) ++
          sha256h2Lo ((s.vregs.read rd).truncate 64) ((s.vregs.read rd).extractLsb' 64 64)
            ((s.vregs.read rn).truncate 64) ((s.vregs.read rn).extractLsb' 64 64)
            ((s.vregs.read rm).truncate 64) ((s.vregs.read rm).extractLsb' 64 64))).advancePC := by
  rw [← sha256Hash_h2]
  rfl

/-- Unfold a schedule update on both sides, down to words. -/
macro "su_simp" : tactic => `(tactic|
  simp [su0Lo, su0Hi, su1Lo, su1Hi, sigLanes, shlMask, shrMask, laneOnes, BinOp.eval_lanes,
    List.range, List.range.loop, Arm64.State.readVReg128])

/-- The model's `SHA256SU0` writes `su0Lo` and `su0Hi` of the words of its operands. -/
theorem evalInst_su0 (s : Arm64.State) :
    prog.evalInst (.cryptoSha2Reg 2#5 rn rd) s =
      (s.writeVReg128 rd
        (su0Hi ((s.vregs.read rd).extractLsb' 64 64) ((s.vregs.read rn).truncate 64) ++
          su0Lo ((s.vregs.read rd).truncate 64)
            ((s.vregs.read rd).extractLsb' 64 64))).advancePC := by
  refine (rfl : prog.evalInst _ s = (s.writeVReg128 rd _).advancePC).trans
    (congrArg (fun v => (s.writeVReg128 rd v).advancePC) ?_)
  su_simp
  generalize s.vregs.read rd = d
  generalize s.vregs.read rn = n
  bv_decide

/-- The model's `SHA256SU1` writes `su1Lo`, and `su1Hi` of it, of the words of its
operands. -/
theorem evalInst_su1 (s : Arm64.State) :
    prog.evalInst (.cryptoSha3Reg 6#3 rm rn rd) s =
      (s.writeVReg128 rd
        (su1Hi ((s.vregs.read rd).extractLsb' 64 64) ((s.vregs.read rn).extractLsb' 64 64)
            ((s.vregs.read rm).truncate 64)
            (su1Lo ((s.vregs.read rd).truncate 64) ((s.vregs.read rn).truncate 64)
              ((s.vregs.read rn).extractLsb' 64 64) ((s.vregs.read rm).extractLsb' 64 64)) ++
          su1Lo ((s.vregs.read rd).truncate 64) ((s.vregs.read rn).truncate 64)
            ((s.vregs.read rn).extractLsb' 64 64)
            ((s.vregs.read rm).extractLsb' 64 64))).advancePC := by
  refine (rfl : prog.evalInst _ s = (s.writeVReg128 rd _).advancePC).trans
    (congrArg (fun v => (s.writeVReg128 rd v).advancePC) ?_)
  su_simp
  generalize s.vregs.read rd = d
  generalize s.vregs.read rn = n
  generalize s.vregs.read rm = m
  bv_decide

/-! ## The lowered operations, piece by piece -/

section
variable {ρ : Env} {σ : State} {Q : Env → State → Prop}

theorem set_ne (ρ : Env) {x y : Nat} (v : Word) (h : y ≠ x) : ρ.set x v y = ρ y :=
  Env.set_other ρ v h

/-- The constants of a mixing of lanes are in the values `k` up. -/
def SigConsts (ρ : Env) (k r1 r2 s : Nat) : Prop :=
  ρ k = BitVec.ofNat 64 r1 ∧ ρ (k + 1) = shrMask 32 r1 ∧
    ρ (k + 2) = BitVec.ofNat 64 (32 - r1) ∧ ρ (k + 3) = shlMask 32 (32 - r1) ∧
    ρ (k + 4) = BitVec.ofNat 64 r2 ∧ ρ (k + 5) = shrMask 32 r2 ∧
    ρ (k + 6) = BitVec.ofNat 64 (32 - r2) ∧ ρ (k + 7) = shlMask 32 (32 - r2) ∧
    ρ (k + 8) = BitVec.ofNat 64 s ∧ ρ (k + 9) = shrMask 32 s

/-- The constants of a mixing of lanes are in the values `k` up, and no other value is
set. -/
theorem wp_sigConsts {k r1 r2 s : Nat} (hw : wpOps (sigConsts k r1 r2 s) ρ σ Q) :
    ∃ ρ', (∀ y : Nat, ¬ (k ≤ y ∧ y < k + 10) → ρ' y = ρ y) ∧
      SigConsts ρ' k r1 r2 s ∧ Q ρ' σ := by
  simp only [sigConsts, wpOps, Op.wp] at hw
  refine ⟨_, fun y hy => ?_, ?_, hw⟩
  · simp (disch := omega) only [set_ne]
  · unfold SigConsts
    simp (disch := omega) only [set_ne, Env.set_same, and_self]

/-- The mixing of lanes and the addition set the value `d` to the value `a` plus, lane by
lane, `sigLanes` of the value `x`, and no other value outside `n` to `n + 13`. -/
theorem wp_sigOps {n k x d a : Nat} (r1 r2 s : Nat) (hk : k + 10 ≤ n)
    (hx : ¬ (n ≤ x ∧ x < n + 14)) (ha : ¬ (n ≤ a ∧ a < n + 14)) (hd : n + 14 ≤ d)
    (hc : SigConsts ρ k r1 r2 s) (hw : wpOps (sigOps n k x d a) ρ σ Q) :
    ∃ ρ', (∀ y : Nat, ¬ (n ≤ y ∧ y < n + 14) → y ≠ d → ρ' y = ρ y) ∧
      ρ' d = (BinOp.lanes 32 .add).eval (ρ a) (sigLanes r1 r2 s (ρ x)) ∧ Q ρ' σ := by
  obtain ⟨c0, c1, c2, c3, c4, c5, c6, c7, c8, c9⟩ := hc
  simp only [sigOps, wpOps, Op.wp] at hw
  refine ⟨_, fun y hy hy' => ?_, ?_, hw⟩
  · simp (disch := omega) only [set_ne]
  · simp (disch := omega) only [set_ne, Env.set_same, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9,
      BinOp.eval_or, BinOp.eval_and, BinOp.eval_xor, BinOp.eval_shl, BinOp.eval_lshr]
    rfl

/-- The join sets the value `n + 3` to the high half of the value `x` below the low half of
the value `y`, and no value outside `n` to `n + 3`. -/
theorem wp_joinOps {n x y : Nat} (hx : x < n) (hy : y < n) (hw : wpOps (joinOps n x y) ρ σ Q) :
    ∃ ρ', (∀ z : Nat, ¬ (n ≤ z ∧ z < n + 4) → ρ' z = ρ z) ∧
      ρ' (n + 3) = ρ x >>> 32#64 ||| ρ y <<< 32#64 ∧ Q ρ' σ := by
  simp only [joinOps, wpOps, Op.wp] at hw
  refine ⟨_, fun z hz => ?_, ?_, hw⟩
  · simp (disch := omega) only [set_ne]
  · simp (disch := omega) only [set_ne, Env.set_same, BinOp.eval_or, BinOp.eval_shl,
      BinOp.eval_lshr]

/-- An addition of lanes sets the value `d`, and no other. -/
theorem wp_lanesAdd {d a b : Nat} (hw : wpOps [.bin d (.lanes 32 .add) a b] ρ σ Q) :
    ∃ ρ', (∀ y : Nat, y ≠ d → ρ' y = ρ y) ∧
      ρ' d = (BinOp.lanes 32 .add).eval (ρ a) (ρ b) ∧ Q ρ' σ := by
  simp only [wpOps, Op.wp] at hw
  exact ⟨_, fun y hy => set_ne _ _ hy, Env.set_same .., hw⟩

/-- The operations of `SHA256SU0` set the values 200 and 201 to `su0Lo` and `su0Hi`. -/
theorem wp_su0Words (hw : wpOps su0Words ρ σ Q) :
    ∃ ρ', ρ' 200 = su0Lo (ρ 0) (ρ 1) ∧ ρ' 201 = su0Hi (ρ 1) (ρ 2) ∧ Q ρ' σ := by
  simp only [su0Words, Braid.wpOps_append] at hw
  obtain ⟨ρ0, f0, hc, hw⟩ := wp_sigConsts hw
  obtain ⟨c0, c1, c2, c3, c4, c5, c6, c7, c8, c9⟩ := hc
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_joinOps (by omega) (by omega) hw
  simp only [Nat.reduceAdd] at v1
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_sigOps 7 18 3 (by omega) (by omega) (by omega) (by omega)
    (by unfold SigConsts
        simp (disch := omega) only [f1, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, and_self]) hw
  obtain ⟨ρ3, f3, v3, hw⟩ := wp_joinOps (by omega) (by omega) hw
  simp only [Nat.reduceAdd] at v3
  obtain ⟨ρ4, f4, v4, hw⟩ := wp_sigOps 7 18 3 (by omega) (by omega) (by omega) (by omega)
    (by unfold SigConsts
        simp (disch := omega) only [f3, f2, f1, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9,
          and_self]) hw
  refine ⟨ρ4, ?_, ?_, hw⟩
  · simp (disch := omega) only [f4, f3, f1, f0, v2, v1]
    rfl
  · simp (disch := omega) only [f3, f2, f1, f0, v4, v3]
    rfl

/-- The operations of `SHA256SU1` set the values 200 and 201 to `su1Lo` and `su1Hi`. -/
theorem wp_su1Words (hw : wpOps su1Words ρ σ Q) :
    ∃ ρ', ρ' 200 = su1Lo (ρ 0) (ρ 2) (ρ 3) (ρ 5) ∧
      ρ' 201 = su1Hi (ρ 1) (ρ 3) (ρ 4) (su1Lo (ρ 0) (ρ 2) (ρ 3) (ρ 5)) ∧ Q ρ' σ := by
  simp only [su1Words, Braid.wpOps_append] at hw
  obtain ⟨ρ0, f0, hc, hw⟩ := wp_sigConsts hw
  obtain ⟨c0, c1, c2, c3, c4, c5, c6, c7, c8, c9⟩ := hc
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_joinOps (by omega) (by omega) hw
  simp only [Nat.reduceAdd] at v1
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_lanesAdd hw
  obtain ⟨ρ3, f3, v3, hw⟩ := wp_sigOps 17 19 10 (by omega) (by omega) (by omega) (by omega)
    (by unfold SigConsts
        simp (disch := omega) only [f2, f1, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9,
          and_self]) hw
  obtain ⟨ρ4, f4, v4, hw⟩ := wp_joinOps (by omega) (by omega) hw
  simp only [Nat.reduceAdd] at v4
  obtain ⟨ρ5, f5, v5, hw⟩ := wp_lanesAdd hw
  obtain ⟨ρ6, f6, v6, hw⟩ := wp_sigOps 17 19 10 (by omega) (by omega) (by omega) (by omega)
    (by unfold SigConsts
        simp (disch := omega) only [f5, f4, f3, f2, f1, c0, c1, c2, c3, c4, c5, c6, c7, c8,
          c9, and_self]) hw
  have e200 : ρ3 200 = su1Lo (ρ 0) (ρ 2) (ρ 3) (ρ 5) := by
    simp (disch := omega) only [f2, f1, f0, v3, v2, v1]
    rfl
  refine ⟨ρ6, ?_, ?_, hw⟩
  · simp (disch := omega) only [f6, f5, f4, e200]
  · simp (disch := omega) only [f5, f4, f3, f2, f1, f0, v6, v5, v4, e200]
    rfl

/-- The constants of the rounds are in the values 10 to 17. -/
def HashConsts (ρ : Env) : Prop :=
  ρ 10 = 32#64 ∧ ρ 11 = 6#64 ∧ ρ 12 = 11#64 ∧ ρ 13 = 25#64 ∧ ρ 14 = 2#64 ∧
    ρ 15 = 13#64 ∧ ρ 16 = 22#64 ∧ ρ 17 = 0xffffffff#64

/-- The working words `w` are in the values `a` to `h`. -/
def InWork (ρ : Env) (a b c d e f g h : Nat) (w : Work) : Prop :=
  ρ a = w.a ∧ ρ b = w.b ∧ ρ c = w.c ∧ ρ d = w.d ∧ ρ e = w.e ∧ ρ f = w.f ∧
    ρ g = w.g ∧ ρ h = w.h

/-- What the four rounds start from: the constants, the working words of `Work.init`, and
the second and fourth message words. -/
theorem wp_hashPre (hw : wpOps hashPre ρ σ Q) :
    ∃ ρ', (∀ y : Nat, y < 10 → ρ' y = ρ y) ∧ HashConsts ρ' ∧
      InWork ρ' 20 21 1 22 23 24 3 25 (Work.init (ρ 0) (ρ 1) (ρ 2) (ρ 3)) ∧
      ρ' 26 = ρ 4 >>> 32#64 ∧ ρ' 27 = ρ 5 >>> 32#64 ∧ Q ρ' σ := by
  simp only [hashPre, wpOps, Op.wp] at hw
  refine ⟨_, fun y hy => ?_, ?_, ?_, ?_, ?_, hw⟩
  · simp (disch := omega) only [set_ne]
  all_goals
    simp (disch := omega) only [HashConsts, InWork, Work.init, set_ne, Env.set_same,
      BinOp.eval_lshr, BinOp.eval_and, and_self]

/-- `rndT` is in the value `n + 12`, and no value below `n` is set. -/
theorem wp_rndTOps {n e f g h k : Nat} (hn : 18 ≤ n)
    (hin : e < n ∧ f < n ∧ g < n ∧ h < n ∧ k < n) (hc : HashConsts ρ)
    (hw : wpOps (rndTOps n e f g h k) ρ σ Q) :
    ∃ ρ', (∀ y : Nat, y < n → ρ' y = ρ y) ∧
      ρ' (n + 12) = rndT (ρ e) (ρ f) (ρ g) (ρ h) (ρ k) ∧ Q ρ' σ := by
  obtain ⟨c0, c1, c2, c3, -, -, -, -⟩ := hc
  obtain ⟨he, hf, hg, hh, hk⟩ := hin
  simp only [rndTOps, wpOps, Op.wp] at hw
  refine ⟨_, fun y hy => ?_, ?_, hw⟩
  · simp (disch := omega) only [set_ne]
  · simp (disch := omega) only [set_ne, Env.set_same, c0, c1, c2, c3, BinOp.eval_or,
      BinOp.eval_and, BinOp.eval_xor, BinOp.eval_shl, BinOp.eval_lshr, BinOp.eval_add]
    rfl

/-- The new first working word is in the value `n + 27`, and no value below `n + 13` is
set. -/
theorem wp_rndAPart {n a b c : Nat} (hn : 18 ≤ n) (hin : a < n ∧ b < n ∧ c < n)
    (hc : HashConsts ρ) (hw : wpOps (rndAPart n a b c) ρ σ Q) :
    ∃ ρ', (∀ y : Nat, y < n + 13 → ρ' y = ρ y) ∧
      ρ' (n + 27) = (ρ (n + 12) + ((ρ a &&& (ρ b ^^^ ρ c)) ^^^ (ρ b &&& ρ c)) +
        bigSig 2#64 13#64 22#64 (ρ a)) &&& 0xffffffff#64 ∧ Q ρ' σ := by
  obtain ⟨c0, -, -, -, c4, c5, c6, c7⟩ := hc
  obtain ⟨ha, hb, hc⟩ := hin
  simp only [rndAPart, wpOps, Op.wp] at hw
  refine ⟨_, fun y hy => ?_, ?_, hw⟩
  · simp (disch := omega) only [set_ne]
  · simp (disch := omega) only [set_ne, Env.set_same, c0, c4, c5, c6, c7, BinOp.eval_or,
      BinOp.eval_and, BinOp.eval_xor, BinOp.eval_shl, BinOp.eval_lshr, BinOp.eval_add]
    rfl

/-- The new fifth working word is in the value `n + 28`, and no value below `n + 26` is
set. -/
theorem wp_rndEPart {n d : Nat} (hn : 18 ≤ n) (hd : d < n) (hc : HashConsts ρ)
    (hw : wpOps (rndEPart n d) ρ σ Q) :
    ∃ ρ', (∀ y : Nat, y < n + 26 → ρ' y = ρ y) ∧ ρ' (n + 27) = ρ (n + 27) ∧
      ρ' (n + 28) = (ρ (n + 12) + ρ d) &&& 0xffffffff#64 ∧ Q ρ' σ := by
  obtain ⟨-, -, -, -, -, -, -, c7⟩ := hc
  have hd' : d ≠ n + 26 := Nat.ne_of_lt (Nat.lt_add_right 26 hd)
  simp only [rndEPart, wpOps, Op.wp] at hw
  refine ⟨_, fun y hy => ?_, ?_, ?_, hw⟩
  all_goals simp (disch := omega) only [set_ne, Env.set_same, c7, BinOp.eval_and,
    BinOp.eval_add]

/-- The constants of the rounds, in an environment that agrees below `n`. -/
theorem HashConsts.of_agree {ρ' : Env} {n : Nat} (hc : HashConsts ρ) (hn : 18 ≤ n)
    (f : ∀ y : Nat, y < n → ρ' y = ρ y) : HashConsts ρ' := by
  obtain ⟨c0, c1, c2, c3, c4, c5, c6, c7⟩ := hc
  unfold HashConsts
  simp (disch := omega) only [f, c0, c1, c2, c3, c4, c5, c6, c7, and_self]

/-- A round leaves the working words of `Work.step`: the new first one in the value `n + 27`,
the new fifth in `n + 28`, and the others where they were. No value below `n` is set. -/
theorem wp_rndOps {n a b c d e f g h k : Nat} {w : Work} {kv : Word} (hn : 18 ≤ n)
    (hin : a < n ∧ b < n ∧ c < n ∧ d < n ∧ e < n ∧ f < n ∧ g < n ∧ h < n ∧ k < n)
    (hc : HashConsts ρ) (hs : InWork ρ a b c d e f g h w) (hk : ρ k = kv)
    (hw : wpOps (rndOps n a b c d e f g h k) ρ σ Q) :
    ∃ ρ', (∀ y : Nat, y < n → ρ' y = ρ y) ∧
      InWork ρ' (n + 27) a b c (n + 28) e f g (w.step kv) ∧ Q ρ' σ := by
  obtain ⟨ha, hb, hc', hd, he, hf, hg, hh, hk'⟩ := hin
  obtain ⟨sa, sb, sc, sd, se, sf, sg, sh⟩ := hs
  simp only [rndOps, Braid.wpOps_append] at hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_rndTOps hn ⟨he, hf, hg, hh, hk'⟩ hc hw
  have hc1 := hc.of_agree hn f1
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_rndAPart hn ⟨ha, hb, hc'⟩ hc1 hw
  have hc2 := hc1.of_agree (show 18 ≤ n + 13 by omega) f2
  obtain ⟨ρ3, f3, k3, v3, hw⟩ := wp_rndEPart hn hd hc2 hw
  refine ⟨ρ3, fun y hy => ?_, ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩, hw⟩
  · simp (disch := omega) only [f3, f2, f1]
  · simp (disch := omega) only [k3, v2, f1, v1, sa, sb, sc, se, sf, sg, sh, hk]
    rfl
  · simp (disch := omega) only [f3, f2, f1, sa, Work.step]
  · simp (disch := omega) only [f3, f2, f1, sb, Work.step]
  · simp (disch := omega) only [f3, f2, f1, sc, Work.step]
  · simp (disch := omega) only [v3, f2, f1, v1, sd, se, sf, sg, sh, hk]
    rfl
  · simp (disch := omega) only [f3, f2, f1, se, Work.step]
  · simp (disch := omega) only [f3, f2, f1, sf, Work.step]
  · simp (disch := omega) only [f3, f2, f1, sg, Work.step]

/-- A round of which only the new first working word is wanted leaves it in the value
`n + 27`. No value below `n` is set. -/
theorem wp_rndAOps {n a b c d e f g h k : Nat} {w : Work} {kv : Word} (hn : 18 ≤ n)
    (hin : a < n ∧ b < n ∧ c < n ∧ e < n ∧ f < n ∧ g < n ∧ h < n ∧ k < n)
    (hc : HashConsts ρ) (hs : InWork ρ a b c d e f g h w) (hk : ρ k = kv)
    (hw : wpOps (rndAOps n a b c e f g h k) ρ σ Q) :
    ∃ ρ', (∀ y : Nat, y < n → ρ' y = ρ y) ∧ ρ' (n + 27) = (w.step kv).a ∧
      Q ρ' σ := by
  obtain ⟨ha, hb, hc', he, hf, hg, hh, hk'⟩ := hin
  obtain ⟨sa, sb, sc, -, se, sf, sg, sh⟩ := hs
  simp only [rndAOps, Braid.wpOps_append] at hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_rndTOps hn ⟨he, hf, hg, hh, hk'⟩ hc hw
  obtain ⟨ρ2, f2, v2, hw⟩ := wp_rndAPart hn ⟨ha, hb, hc'⟩ (hc.of_agree hn f1) hw
  refine ⟨ρ2, fun y hy => ?_, ?_, hw⟩
  · simp (disch := omega) only [f2, f1]
  · simp (disch := omega) only [v2, f1, v1, sa, sb, sc, se, sf, sg, sh, hk]
    rfl

/-- A round of which only the new fifth working word is wanted leaves it in the value
`n + 28`. No value below `n` is set. -/
theorem wp_rndEOps {n a b c d e f g h k : Nat} {w : Work} {kv : Word} (hn : 18 ≤ n)
    (hin : d < n ∧ e < n ∧ f < n ∧ g < n ∧ h < n ∧ k < n)
    (hc : HashConsts ρ) (hs : InWork ρ a b c d e f g h w) (hk : ρ k = kv)
    (hw : wpOps (rndEOps n d e f g h k) ρ σ Q) :
    ∃ ρ', (∀ y : Nat, y < n → ρ' y = ρ y) ∧ ρ' (n + 28) = (w.step kv).e ∧
      Q ρ' σ := by
  obtain ⟨hd, he, hf, hg, hh, hk'⟩ := hin
  obtain ⟨-, -, -, sd, se, sf, sg, sh⟩ := hs
  simp only [rndEOps, Braid.wpOps_append] at hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_rndTOps hn ⟨he, hf, hg, hh, hk'⟩ hc hw
  obtain ⟨ρ2, f2, -, v2, hw⟩ := wp_rndEPart hn hd (hc.of_agree hn f1) hw
  refine ⟨ρ2, fun y hy => ?_, ?_, hw⟩
  · simp (disch := omega) only [f2, f1]
  · simp (disch := omega) only [v2, f1, v1, sd, se, sf, sg, sh, hk]
    rfl

/-- The two result words are in the values 200 and 201. -/
theorem wp_packOps {a b c d : Nat} (hc : HashConsts ρ)
    (hin : a < 150 ∧ b < 150 ∧ c < 150 ∧ d < 150) (hw : wpOps (packOps a b c d) ρ σ Q) :
    ∃ ρ', ρ' 200 = ρ a ||| ρ b <<< 32#64 ∧ ρ' 201 = ρ c ||| ρ d <<< 32#64 ∧
      Q ρ' σ := by
  obtain ⟨c0, -⟩ := hc
  obtain ⟨ha, hb, hc', hd⟩ := hin
  simp only [packOps, wpOps, Op.wp] at hw
  refine ⟨_, ?_, ?_, hw⟩
  all_goals simp (disch := omega) only [set_ne, Env.set_same, c0, BinOp.eval_or,
    BinOp.eval_shl]

/-- The first three rounds leave the constants, the working words after three steps, and
the fourth message word. No value below 10 is set. -/
theorem wp_hashRounds (hw : wpOps hashRounds ρ σ Q) :
    ∃ ρ', (∀ y : Nat, y < 10 → ρ' y = ρ y) ∧ HashConsts ρ' ∧
      InWork ρ' 117 87 57 20 118 88 58 23
        ((((Work.init (ρ 0) (ρ 1) (ρ 2) (ρ 3)).step (ρ 4)).step (ρ 4 >>> 32#64)).step
          (ρ 5)) ∧
      ρ' 27 = ρ 5 >>> 32#64 ∧ Q ρ' σ := by
  simp only [hashRounds, Braid.wpOps_append] at hw
  obtain ⟨ρ0, f0, hc0, s0, k1, k3, hw⟩ := wp_hashPre hw
  obtain ⟨ρ1, f1, s1, hw⟩ := wp_rndOps (by omega)
    ⟨by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega⟩
    hc0 s0 (f0 4 (by omega)) hw
  have hc1 := hc0.of_agree (show 18 ≤ 30 by omega) f1
  obtain ⟨ρ2, f2, s2, hw⟩ := wp_rndOps (by omega)
    ⟨by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega⟩
    hc1 s1 ((f1 26 (by omega)).trans k1) hw
  have hc2 := hc1.of_agree (show 18 ≤ 60 by omega) f2
  obtain ⟨ρ3, f3, s3, hw⟩ := wp_rndOps (by omega)
    ⟨by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega⟩
    hc2 s2 ((f2 5 (by omega)).trans ((f1 5 (by omega)).trans (f0 5 (by omega)))) hw
  refine ⟨ρ3, fun y hy => ?_, hc2.of_agree (show 18 ≤ 90 by omega) f3, s3, ?_, hw⟩
  · simp (disch := omega) only [f3, f2, f1, f0]
  · simp (disch := omega) only [f3, f2, f1, k3]

/-- The operations of `SHA256H` set the values 200 and 201 to the words that hold `a` to `d`
after four steps, and no value below 10. -/
theorem wp_hashWords (hw : wpOps hashWords ρ σ Q) :
    ∃ ρ', ρ' 200 = sha256hLo (ρ 0) (ρ 1) (ρ 2) (ρ 3) (ρ 4) (ρ 5) ∧
      ρ' 201 = sha256hHi (ρ 0) (ρ 1) (ρ 2) (ρ 3) (ρ 4) (ρ 5) ∧ Q ρ' σ := by
  simp only [hashWords, Braid.wpOps_append] at hw
  obtain ⟨ρ0, -, hc0, s0, k3, hw⟩ := wp_hashRounds hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_rndAOps (by omega)
    ⟨by omega, by omega, by omega, by omega, by omega, by omega, by omega, by omega⟩
    hc0 s0 k3 hw
  obtain ⟨sa, sb, sc, -⟩ := s0
  obtain ⟨ρ2, v200, v201, hw⟩ := wp_packOps (hc0.of_agree (show 18 ≤ 120 by omega) f1)
    ⟨by omega, by omega, by omega, by omega⟩ hw
  refine ⟨ρ2, ?_, ?_, hw⟩
  · simp (disch := omega) only [v200, v1, f1, sa]
    rfl
  · simp (disch := omega) only [v201, f1, sb, sc]
    rfl

/-- The operations of `SHA256H2` set the values 200 and 201 to the words that hold `e` to
`h` after four steps, of the working words `a` to `d` in the values 0 and 1 and `e` to `h` in
2 and 3. -/
theorem wp_hash2Words (hw : wpOps hash2Words ρ σ Q) :
    ∃ ρ', ρ' 200 = sha256h2Lo (ρ 2) (ρ 3) (ρ 0) (ρ 1) (ρ 4) (ρ 5) ∧
      ρ' 201 = sha256h2Hi (ρ 2) (ρ 3) (ρ 0) (ρ 1) (ρ 4) (ρ 5) ∧ Q ρ' σ := by
  simp only [hash2Words, Braid.wpOps_append] at hw
  obtain ⟨ρ0, -, hc0, s0, k3, hw⟩ := wp_hashRounds hw
  obtain ⟨ρ1, f1, v1, hw⟩ := wp_rndEOps (by omega)
    ⟨by omega, by omega, by omega, by omega, by omega, by omega⟩ hc0 s0 k3 hw
  obtain ⟨-, -, -, -, se, sf, sg, -⟩ := s0
  obtain ⟨ρ2, v200, v201, hw⟩ := wp_packOps (hc0.of_agree (show 18 ≤ 120 by omega) f1)
    ⟨by omega, by omega, by omega, by omega⟩ hw
  refine ⟨ρ2, ?_, ?_, hw⟩
  · simp (disch := omega) only [v200, v1, f1, se]
    rfl
  · simp (disch := omega) only [v201, f1, sf, sg]
    rfl

end

/-! ## The instructions -/

variable {σ : State} {Q : State → Prop}

/-- Reading the low half of a vector register gives the low half of the machine's value. -/
theorem wp_getLo (h : Rel s σ) {d : Var} {k : BitVec 5} {ρ : Env} {Q : Env → State → Prop}
    {rest : List Op} (hw : wpOps (.get d (vregLo k) :: rest) ρ σ Q) :
    wpOps rest (ρ.set d ((s.vregs.read k).truncate 64)) σ Q := by
  simpa only [wpOps, Op.wp, vregLo, h.vlo] using hw

/-- Find the two words the operations of an instruction leave, after its operands are read,
and write them: the block is sound if the model writes those words. -/
macro "sha_words" h:ident hw:ident lem:ident e:term : tactic => `(tactic|
  (rw [Braid.wpOps_append] at $hw:ident
   obtain ⟨ρ', v200, v201, $hw:ident⟩ := $lem $hw
   obtain ⟨σ', h', $hw:ident⟩ := wp_vset' $h $hw
   simp only [Term.wp] at $hw:ident
   rw [v200, v201] at h'
   simp only [Env.set_apply, Nat.reduceEqDiff, Nat.reduceAdd, ↓reduceIte] at h'
   exact step_done (Rel.setPC h' _) $hw $e))

/-- Read the three operands of an instruction, then `sha_words`. -/
macro "sha_block" h:ident hw:ident lem:ident e:term : tactic => `(tactic|
  (simp only [Block.wp, List.append_assoc] at $hw:ident
   have $hw:ident := wp_vget $h $hw
   have $hw:ident := wp_vget $h $hw
   have $hw:ident := wp_vget $h $hw
   sha_words $h $hw $lem $e))

/-- `SHA256SU0` is sound. -/
theorem sound_cryptoSha2Reg {opcode : BitVec 5} (h : Rel s σ)
    (hw : (lower s.pc (.cryptoSha2Reg opcode rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.cryptoSha2Reg opcode rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.cryptoSha2Reg opcode rn rd) s).mem := by
  simp only [lower] at hw
  generalize hops : sha2Ops opcode rn rd = o at hw
  cases o with
  | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
  | some ops =>
    simp only [sha2Ops] at hops
    split at hops
    · rename_i ho
      subst ho
      cases hops
      simp only [Block.wp, List.append_assoc, List.cons_append, List.nil_append] at hw
      have hw := wp_vget h hw
      have hw := wp_getLo h hw
      sha_words h hw wp_su0Words (evalInst_su0 prog rn rd s)
    · cases hops

/-- `SHA256H`, `SHA256H2` and `SHA256SU1` are sound. -/
theorem sound_cryptoSha3Reg {opcode : BitVec 3} (h : Rel s σ)
    (hw : (lower s.pc (.cryptoSha3Reg opcode rm rn rd)).wp σ Q) :
    ∃ σ', Rel (prog.evalInst (.cryptoSha3Reg opcode rm rn rd) s) σ' ∧ Q σ' ∧
      KeepsCode s.mem (prog.evalInst (.cryptoSha3Reg opcode rm rn rd) s).mem := by
  simp only [lower] at hw
  generalize hops : sha3Ops opcode rm rn rd = o at hw
  cases o with
  | none => exact absurd hw (by simp [Block.wp, wpOps, Term.wp])
  | some ops =>
    simp only [sha3Ops] at hops
    split at hops
    · rename_i ho
      subst ho
      cases hops
      sha_block h hw wp_hashWords (evalInst_sha256h prog rm rn rd s)
    split at hops
    · rename_i ho
      subst ho
      cases hops
      sha_block h hw wp_hash2Words (evalInst_sha256h2 prog rm rn rd s)
    split at hops
    · rename_i ho
      subst ho
      cases hops
      sha_block h hw wp_su1Words (evalInst_su1 prog rm rn rd s)
    · cases hops

end Lowering.Arm
