/-
  Examples.Mem.X86.Proofs

  `mem.c` on x86-64: copying bytes and comparing bytes, the first rung of the scaling
  ladder (`docs/Scaling.md`).

  The code keeps an index in a register and addresses each byte as base plus index, so the
  loops are proved by induction on the bytes still to visit, at any index `i`, with the
  stepper. The address the code computes, `p + i * 1`, is the address `p + i` of the
  specification (`bytesAt_index`). `equal_bytes` only reads memory, so its two regions may
  overlap: its memory is a set of single bytes (`cellsOn`), opened at the address of each
  load. The return address is on the stack, apart from the bytes.

  ## Main results

  * `copy_bytes_spec`, `equal_bytes_spec`: the specifications
  * `copy_bytes_correct`, `equal_bytes_correct`: the same, about the machine alone
-/

module

public import Examples.Mem.X86.Image
public import Examples.Mem.Common
public import Examples.Spec
import Braid.BV

public section

namespace Examples.Mem.X86

open Braid Examples Examples.Mem Lowering.X86 Lowering.X86.Regs

/-- The address of byte `i` from `p`, as the code computes it, is `p + i`. -/
theorem index_eq (p i : Word) : p + @HMul.hMul Word Word Word instHMul i 1#64 = p + i := by
  rw [BitVec.mul_one]

/-- An array of bytes that starts at index `i` from `p`, opened at its first byte, whose
address is written as the code computes it. -/
theorem bytesAt_index (p i : Word) (b : BitVec 8) (bs : List (BitVec 8)) :
    (Atom.prop (bytesAt (p + i) (b :: bs))).interp =
      Atoms.interp [.mem (p + @HMul.hMul Word Word Word instHMul i 1#64) 1 (b.zeroExtend 64) true,
        .prop (bytesAt (p + (i + 1#64)) bs)] := by
  rw [index_eq, bytesAt_cons, BitVec.add_assoc]

/-- The same, when the first byte was just stored. -/
theorem bytesAt_index_store (p i v : Word) (bs : List (BitVec 8)) :
    (Atom.prop (bytesAt (p + i) (v.truncate 8 :: bs))).interp =
      Atoms.interp [.mem (p + @HMul.hMul Word Word Word instHMul i 1#64) 1 v true,
        .prop (bytesAt (p + (i + 1#64)) bs)] := by
  rw [index_eq, bytesAt_cons_store, BitVec.add_assoc]

/-- Forget the values of the six status flags, of which those the last instruction leaves
undefined hold no value already. -/
local macro "forget_flags" : tactic =>
  `(tactic| (try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 3
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-- The loop of `copy_bytes`, at index `i`: copy the bytes from index `i` on. -/
theorem copy_bytes_loop (pd ps n sp r : Word) : ∀ (ss ds : List (BitVec 8)) (s d : BitVec 8)
    (i t : Word) (c pf af z sg o : Bool), ds.length = ss.length →
    i + BitVec.ofNat 64 (ss.length + 1) = n → i.toNat + ss.length + 1 < 2 ^ 64 →
    Triple copy_bytes.program
      (Atoms.interp [.pc 0x401010#64, .reg rax i, .reg rcx t, .reg rdx n, .reg rsi ps,
        .reg rdi pd, .prop (bytesAt (ps + i) (s :: ss)), .prop (bytesAt (pd + i) (d :: ds)),
        .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .prop (regAny rax), .prop (regAny rcx), .reg rdx n, .reg rsi ps,
        .reg rdi pd, .prop (bytesAt (ps + i) (s :: ss)), .prop (bytesAt (pd + i) (s :: ss)),
        .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  intro ss
  induction ss with
  | nil =>
    intro ds s d i t c pf af z sg o hlen he hb
    have hds : ds = [] := List.length_eq_zero_iff.1 hlen
    have hn : n = i + 1#64 := by simpa using he.symm
    subst hds hn
    braid_unfold bytesAt_index ps i s []
    braid_unfold bytesAt_index pd i d []
    braid_sym_run
    · exact absurd (BitVec.sub_self _) hbr
    · braid_sym_run
      braid_fold bytesAt_index ps i s []
      braid_fold bytesAt_index pd i s []
      braid_forget 0
      braid_forget 2
      forget_flags
      braid_done
  | cons c' cs ih =>
    intro ds s d i t c pf af z sg o hlen he hb
    obtain ⟨d', ds', rfl⟩ : ∃ d' ds', ds = d' :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at he hb hlen
    braid_unfold bytesAt_index ps i s (c' :: cs)
    braid_unfold bytesAt_index pd i d (d' :: ds')
    braid_sym_run
    · try braid_name_flag 2
      braid_call ih ds' c' d' (i + 1#64) _ _ _ _ _ _ _ (by omega) (by rw [← he]; bv_omega)
        (by bv_omega)
      braid_fold bytesAt_index ps i s (c' :: cs)
      braid_fold bytesAt_index pd i s (c' :: cs)
      braid_done
    · exfalso
      have : n - (i + 1#64) ≠ 0#64 := by rw [← he]; bv_omega
      exact this hbr

/-- `copy_bytes` copies the `n` bytes its second argument points to over the `n` bytes its
first argument points to. -/
theorem copy_bytes_spec (pd ps sp r t0 t : Word) (ss ds : List (BitVec 8))
    (c pf af z sg o : Bool) (hlen : ds.length = ss.length) (hl : ss.length < 2 ^ 64) :
    Triple copy_bytes.program
      (Atoms.interp [.pc 0x401000#64, .reg rax t0, .reg rcx t,
        .reg rdx (BitVec.ofNat 64 ss.length), .reg rsi ps, .reg rdi pd,
        .prop (bytesAt ps ss), .prop (bytesAt pd ds), .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .prop (regAny rax), .prop (regAny rcx),
        .reg rdx (BitVec.ofNat 64 ss.length), .reg rsi ps, .reg rdi pd,
        .prop (bytesAt ps ss), .prop (bytesAt pd ss), .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  cases ss with
  | nil =>
    have hds : ds = [] := List.length_eq_zero_iff.1 hlen
    subst hds
    simp only [List.length_nil]
    braid_sym_run
    braid_forget 0
    braid_forget 2
    forget_flags
    braid_done
  | cons s ss =>
    obtain ⟨d, ds', rfl⟩ : ∃ d ds', ds = d :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at hl hlen ⊢
    have hloop := copy_bytes_loop pd ps (BitVec.ofNat 64 (ss.length + 1)) sp r ss ds' s d 0#64
    simp only [BitVec.add_zero, BitVec.zero_add] at hloop
    braid_sym_run
    · exfalso
      have : BitVec.ofNat 64 (ss.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · braid_sym_step
      braid_sym_step
      simp only [BitVec.xor_self]
      try braid_name_flag 2
      braid_call hloop _ _ _ _ _ _ _ (by omega) trivial (by simpa using hl)
      braid_done

/-- The eight-bit `cmp` of two bytes finds them equal exactly when they are. -/
theorem byte_cmp (a b : BitVec 8) :
    BitVec.setWidth 64 (BitVec.setWidth 8 (BitVec.setWidth 64 a - BitVec.setWidth 64 b)) = 0#64 ↔
      a = b := by
  constructor
  · intro h; bv_auto
  · rintro rfl; simp

/-- Forget what `equal_bytes` leaves in the registers it uses and in the flags. -/
local macro "equal_bytes_forget" : tactic =>
  `(tactic| (braid_forget 2; braid_forget 8; forget_flags))

/-- Run the two loads of a round of `equal_bytes`, from the bytes at `pa + i` and at `pb + i`
of a set of bytes. -/
local macro "equal_bytes_loads " f:term ", " ha:term ", " hb:term : tactic =>
  `(tactic| (braid_unfold cellsOn_open $f $ha
             braid_sym_step
             braid_fold cellsOn_open $f $ha
             braid_unfold cellsOn_open $f $hb
             braid_sym_step
             braid_fold cellsOn_open $f $hb))

/-- The loop of `equal_bytes`, at index `i`: compare the bytes from index `i` on, which are
read through one set of bytes. -/
theorem equal_bytes_loop (f : Word → BitVec 8) (addrs : List Word) (pa pb n sp r : Word) :
    ∀ (as bs : List (BitVec 8)) (a b : BitVec 8) (i t8 : Word) (c pf af z sg o : Bool),
    bs.length = as.length → i + BitVec.ofNat 64 (as.length + 1) = n →
    i.toNat + as.length + 1 < 2 ^ 64 → Reads f addrs (pa + i) (a :: as) →
    Reads f addrs (pb + i) (b :: bs) →
    Triple equal_bytes.program
      (Atoms.interp [.pc 0x401030#64, .reg rax 1#64, .reg rcx i, .reg rdx n, .reg rsi pb,
        .reg rdi pa, .reg r8 t8, .prop (cellsOn f addrs), .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (if a :: as = b :: bs then 1#64 else 0#64),
        .prop (regAny rcx), .reg rdx n, .reg rsi pb, .reg rdi pa, .prop (regAny r8),
        .prop (cellsOn f addrs), .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  intro as
  induction as with
  | nil =>
    intro bs a b i t8 c pf af z sg o hlen he hl hA hB
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    have hn : n = i + 1#64 := by simpa using he.symm
    subst hbs hn
    obtain ⟨ha, rfl, -⟩ := hA
    obtain ⟨hb, rfl, -⟩ := hB
    rw [← index_eq pa i] at ha
    rw [← index_eq pb i] at hb
    equal_bytes_loads f, ha, hb
    braid_sym_run
    · simp only [index_eq, byte_cmp] at hbr
      have e : (if [f (pa + i)] = [f (pb + i)] then 1#64 else 0#64) = 0#64 :=
        ite_eq_right fun h => hbr (List.cons.inj h).1
      rw [e]
      equal_bytes_forget
      braid_done
    · simp only [index_eq, byte_cmp] at hbr
      have e : (if [f (pa + i)] = [f (pb + i)] then 1#64 else 0#64) = 1#64 :=
        ite_eq_left (by rw [hbr])
      rw [e]
      braid_sym_run
      · exact absurd (BitVec.sub_self _) hbr
      · braid_sym_run
        equal_bytes_forget
        braid_done
  | cons c' cs ih =>
    intro bs a b i t8 c pf af z sg o hlen he hl hA hB
    obtain ⟨d, ds, rfl⟩ : ∃ d ds, bs = d :: ds := by
      cases bs with
      | nil => simp at hlen
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at he hl hlen
    obtain ⟨ha, rfl, hra⟩ := hA
    obtain ⟨hb, rfl, hrb⟩ := hB
    rw [← index_eq pa i] at ha
    rw [← index_eq pb i] at hb
    rw [BitVec.add_assoc] at hra hrb
    equal_bytes_loads f, ha, hb
    braid_sym_run
    · simp only [index_eq, byte_cmp] at hbr
      have e : (if f (pa + i) :: c' :: cs = f (pb + i) :: d :: ds then 1#64 else 0#64) = 0#64 :=
        ite_eq_right fun h => hbr (List.cons.inj h).1
      rw [e]
      equal_bytes_forget
      braid_done
    · simp only [index_eq, byte_cmp] at hbr
      have e : (if f (pa + i) :: c' :: cs = f (pb + i) :: d :: ds then 1#64 else 0#64) =
          if c' :: cs = d :: ds then 1#64 else 0#64 := by
        rw [hbr]
        simp only [List.cons.injEq, true_and]
      rw [e]
      braid_sym_run
      · try braid_name_flag 2
        braid_call ih ds c' d (i + 1#64) _ _ _ _ _ _ _ (by omega) (by rw [← he]; bv_omega)
          (by bv_omega) hra hrb
        braid_done
      · exfalso
        have : n - (i + 1#64) ≠ 0#64 := by rw [← he]; bv_omega
        exact this hbr

/-- `equal_bytes` returns one if the `n` bytes its first argument points to are those its
second argument points to, and zero otherwise. The bytes are read through one set of bytes,
so the two regions may overlap. -/
theorem equal_bytes_spec (f : Word → BitVec 8) (addrs : List Word) (pa pb sp r t0 t2 t8 : Word)
    (as bs : List (BitVec 8)) (c pf af z sg o : Bool) (hlen : bs.length = as.length)
    (hl : as.length < 2 ^ 64) (hA : Reads f addrs pa as) (hB : Reads f addrs pb bs) :
    Triple equal_bytes.program
      (Atoms.interp [.pc 0x401020#64, .reg rax t0, .reg rcx t2,
        .reg rdx (BitVec.ofNat 64 as.length), .reg rsi pb, .reg rdi pa, .reg r8 t8,
        .prop (cellsOn f addrs), .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r, .reg rax (if as = bs then 1#64 else 0#64), .prop (regAny rcx),
        .reg rdx (BitVec.ofNat 64 as.length), .reg rsi pb, .reg rdi pa, .prop (regAny r8),
        .prop (cellsOn f addrs), .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  cases as with
  | nil =>
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    subst hbs
    simp only [List.length_nil, ↓reduceIte]
    braid_sym_run
    equal_bytes_forget
    braid_done
  | cons a as =>
    obtain ⟨b, bs', rfl⟩ : ∃ b bs', bs = b :: bs' := by
      cases bs with
      | nil => simp at hlen
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at hl hlen ⊢
    have hloop := equal_bytes_loop f addrs pa pb (BitVec.ofNat 64 (as.length + 1)) sp r as bs'
      a b 0#64
    simp only [BitVec.add_zero, BitVec.zero_add] at hloop
    braid_sym_run
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · braid_sym_step
      braid_sym_step
      simp only [BitVec.xor_self]
      try braid_name_flag 2
      braid_call hloop _ _ _ _ _ _ _ (by omega) trivial (by simpa using hl) hA hB
      braid_done

/-! ## On the machine -/

/-- A memory atom of a postcondition, read off the machine. -/
theorem hasBytes_of_cells {m : MachineState} {σ : State} (hr : Rel m σ) {a v : Word} {n : Nat}
    (hm : ∀ x : Word, (x - a).toNat < n →
      σ.mem x = some ⟨(v >>> ((x - a) <<< 3)).truncate 8, true⟩) : HasBytes m a n v := by
  intro x hx
  have hc := hm x hx
  rw [hr.data.mem] at hc
  obtain ⟨b, hb, hc⟩ := memOf_eq_some hc
  rw [hb]
  simpa using (congrArg Cell.val hc).symm

/-- **An array of bytes, out of the logic.** A machine related to a state of which a list of
atoms holds has each byte of an array in the list. -/
theorem hasBytes_of_bytesAt {m : MachineState} {σ : State} {as : Atoms} {R : SProp} {p : Word}
    {bs : List (BitVec 8)} (hr : Rel m σ) (h : (Atoms.interp as).holds R σ)
    (hat : as.At (.prop (bytesAt p bs))) (i : Nat) (hi : i < bs.length) :
    HasBytes m (p + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64) := by
  obtain ⟨F, e⟩ := hat.split
  rw [e] at h
  refine hasBytes_of_cells hr fun x hx => ?_
  have hx' : x = p + BitVec.ofNat 64 i := by bv_omega
  subst hx'
  simpa using bytesAt_cell (SProp.holds_assoc.1 h) i hi

/-- A word that starts at or beyond the end of an array, and ends before the array starts,
does not reach into it. -/
theorem sep_array {s p : Word} {l : Nat} (h : l ≤ (s - p).toNat ∧ 8 ≤ (p - s).toNat)
    (x : Word) (hx : (x - s).toNat < 8) : ¬ (x - p).toNat < l := by
  bv_omega

/-- A byte of an array is not one of the eight of a word that starts at or beyond the end of
the array, and ends before the array starts. -/
theorem sep_index {s p : Word} {l i : Nat} (h : l ≤ (s - p).toNat ∧ 8 ≤ (p - s).toNat)
    (hi : i < l) : ¬ (p + BitVec.ofNat 64 i - s).toNat < 8 := by
  bv_omega

/-- **`copy_bytes` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `copy_bytes`, has the bytes `ss` in memory where `rsi` points, as
many bytes `ds` where `rdi` points, and their number in `rdx`, and has the return address
`r` in the eight bytes at the stack pointer, the two arrays and the return address apart
from one another, reaches `r` on every run, with the bytes `ss` where `rdi` pointed, and
still where `rsi` pointed. -/
theorem copy_bytes_correct [Layout] (m : MachineState) (ss ds : List (BitVec 8)) (r : Word)
    (hpc : m.pc = 0x401000) (hlen : ds.length = ss.length)
    (hn : m.data.regs.get64 .rdx = BitVec.ofNat 64 ss.length)
    (hsrc : ∀ (i : Nat) (hi : i < ss.length),
      HasBytes m (m.data.regs.get64 .rsi + BitVec.ofNat 64 i) 1 (ss[i].zeroExtend 64))
    (hdst : ∀ (i : Nat) (hi : i < ds.length),
      HasBytes m (m.data.regs.get64 .rdi + BitVec.ofNat 64 i) 1 (ds[i].zeroExtend 64))
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hapart : ss.length ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsi).toNat ∧
      ds.length ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rdi).toNat)
    (hsrcsp : ss.length ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rsp).toNat)
    (hdstsp : ds.length ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsp).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        ∀ (i : Nat) (hi : i < ss.length),
          HasBytes m' (m.data.regs.get64 .rdi + BitVec.ofNat 64 i) 1 (ss[i].zeroExtend 64) ∧
          HasBytes m' (m.data.regs.get64 .rsi + BitVec.ofNat 64 i) 1 (ss[i].zeroExtend 64)) m := by
  have hl : ss.length < 2 ^ 64 := by
    have : (m.data.regs.get64 .rdi - m.data.regs.get64 .rsi).toNat < 2 ^ 64 := BitVec.isLt _
    omega
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat copy_bytes_holds
    (copy_bytes_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64 .rsp)
      r (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx) ss ds m.data.status.cf
      m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of
      hlen hl)
    (flat := [.pc 0x401000#64, .reg rax (m.data.regs.get64 .rax),
      .reg rcx (m.data.regs.get64 .rcx), .reg rdx (BitVec.ofNat 64 ss.length),
      .reg rsi (m.data.regs.get64 .rsi), .reg rdi (m.data.regs.get64 .rdi)] ++
      (bytesAtoms (m.data.regs.get64 .rsi) ss ++ (bytesAtoms (m.data.regs.get64 .rdi) ds ++
      [.reg rsp (m.data.regs.get64 .rsp), .mem (m.data.regs.get64 .rsp) 8 r true,
        .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
        .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
        .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of])))
    (Flat.interp (by braid_flat))
    (forall_flat₂ (by simp [Atom.IsPointsTo]) bytesAtoms_isPointsTo bytesAtoms_isPointsTo)
    (pairwise_flat₂ (by braid_disj) (bytesAtoms_pairwise (by omega))
      (bytesAtoms_pairwise (by omega)) (bytesAtoms_disj hapart.1 hapart.2)
      (by
        braid_disj_array
        exact disj_mem_bytesAtoms (sep_array hsrcsp) (by omega))
      (by
        braid_disj_array
        exact disj_mem_bytesAtoms (sep_array hdstsp) (by omega)))
    (forall_flat₂
      (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
        hret, hn])
      (bytesAtoms_sat fun i hi => sat_mem_abs.2 (hsrc i hi))
      (bytesAtoms_sat fun i hi => sat_mem_abs.2 (hdst i hi))))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, fun i hi => ⟨?_, ?_⟩⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · exact hasBytes_of_bytesAt (p := m.data.regs.get64 .rdi) (bs := ss) hr hq (by braid_at) i hi
  · exact hasBytes_of_bytesAt (p := m.data.regs.get64 .rsi) (bs := ss) hr hq (by braid_at) i hi

/-- The byte the machine has at an address, and zero where it has none. -/
def byteAt (m : MachineState) (x : Word) : BitVec 8 :=
  ((m.data.dmem[x]?).map (·.toBitVec)).getD 0#8

/-- The byte the machine has at an address where it has a byte. -/
theorem byteAt_of_hasBytes {m : MachineState} {a : Word} {b : BitVec 8}
    (h : HasBytes m a 1 (b.zeroExtend 64)) : byteAt m a = b := by
  have := h a (by simp)
  simp only [byteAt, this]
  simp

/-- A machine that has a byte at an address has there the byte its memory holds. -/
theorem hasBytes_byteAt {m : MachineState} {a v : Word} (h : HasBytes m a 1 v) :
    HasBytes m a 1 ((byteAt m a).zeroExtend 64) := by
  intro x hx
  have e : x = a := by bv_omega
  subst e
  have := h x hx
  simp only [byteAt, this]
  simp

/-- **`equal_bytes` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `equal_bytes`, has the bytes `as` in memory where `rdi` points, as
many bytes `bs` where `rsi` points, and their number in `rdx`, and has the return address
`r` in the eight bytes at the stack pointer, apart from both regions, reaches `r` on every
run, with one in `rax` if `as` and `bs` are the same, and zero otherwise. The two regions
may overlap. -/
theorem equal_bytes_correct [Layout] (m : MachineState) (as bs : List (BitVec 8)) (r : Word)
    (hpc : m.pc = 0x401020) (hlen : bs.length = as.length)
    (hn : m.data.regs.get64 .rdx = BitVec.ofNat 64 as.length)
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes m (m.data.regs.get64 .rdi + BitVec.ofNat 64 i) 1 (as[i].zeroExtend 64))
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes m (m.data.regs.get64 .rsi + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64))
    (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hasp : as.length ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m.data.regs.get64 .rdi - m.data.regs.get64 .rsp).toNat)
    (hbsp : bs.length ≤ (m.data.regs.get64 .rsp - m.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m.data.regs.get64 .rsi - m.data.regs.get64 .rsp).toNat) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        m'.data.regs.get64 .rax = if as = bs then 1#64 else 0#64) m := by
  have hl : as.length < 2 ^ 64 := by
    have : (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat < 2 ^ 64 := BitVec.isLt _
    omega
  let f : Word → BitVec 8 := byteAt m
  let addrs : List Word := dedup (addrsFrom (m.data.regs.get64 .rdi) as.length ++
    addrsFrom (m.data.regs.get64 .rsi) bs.length)
  have hA : Reads f addrs (m.data.regs.get64 .rdi) as := reads_of_forall fun i hi =>
    ⟨mem_dedup.2 (List.mem_append_left _ (mem_addrsFrom.2 ⟨i, hi, rfl⟩)),
      byteAt_of_hasBytes (ha i hi)⟩
  have hB : Reads f addrs (m.data.regs.get64 .rsi) bs := reads_of_forall fun i hi =>
    ⟨mem_dedup.2 (List.mem_append_right _ (mem_addrsFrom.2 ⟨i, hi, rfl⟩)),
      byteAt_of_hasBytes (hb i hi)⟩
  have hsat : ∀ x ∈ addrs, (Atom.mem x 1 ((f x).zeroExtend 64) true).sat (abs m) := by
    intro x hx
    refine sat_mem_abs.2 ?_
    rcases List.mem_append.1 (mem_dedup.1 hx) with h | h
    · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
      exact hasBytes_byteAt (ha i hi)
    · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
      exact hasBytes_byteAt (hb i hi)
  have hsp : ∀ x ∈ addrs, ¬ (x - m.data.regs.get64 .rsp).toNat < 8 := by
    intro x hx
    rcases List.mem_append.1 (mem_dedup.1 hx) with h | h
    · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
      exact sep_index hasp hi
    · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
      exact sep_index hbsp hi
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat equal_bytes_holds
    (equal_bytes_spec f addrs (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
      (m.data.regs.get64 .rsp) r (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx)
      (m.data.regs.get64 .r8) as bs m.data.status.cf m.data.status.pf m.data.status.af
      m.data.status.zf m.data.status.sf m.data.status.of hlen hl hA hB)
    (flat := [.pc 0x401020#64, .reg rax (m.data.regs.get64 .rax),
      .reg rcx (m.data.regs.get64 .rcx), .reg rdx (BitVec.ofNat 64 as.length),
      .reg rsi (m.data.regs.get64 .rsi), .reg rdi (m.data.regs.get64 .rdi),
      .reg r8 (m.data.regs.get64 .r8)] ++ cellsOnAtoms f addrs ++
      [.reg rsp (m.data.regs.get64 .rsp), .mem (m.data.regs.get64 .rsp) 8 r true,
        .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
        .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
        .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of])
    (by rw [cellsOn_eq_interp]
        exact Atoms.interp_flatten [.pc 0x401020#64, .reg rax (m.data.regs.get64 .rax),
          .reg rcx (m.data.regs.get64 .rcx), .reg rdx (BitVec.ofNat 64 as.length),
          .reg rsi (m.data.regs.get64 .rsi), .reg rdi (m.data.regs.get64 .rdi),
          .reg r8 (m.data.regs.get64 .r8)] _ _)
    (Atoms.forall_flat (by simp [Atom.IsPointsTo]) cellsOnAtoms_isPointsTo)
    (Atoms.pairwise_flat (by braid_disj) (cellsOnAtoms_pairwise (dedup_pairwise _))
      (by
        braid_disj_array
        all_goals first
          | exact disj_reg_cellsOnAtoms | exact disj_pc_cellsOnAtoms
          | exact disj_flag_cellsOnAtoms | exact disj_mem_cellsOnAtoms hsp))
    (Atoms.forall_flat
      (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
        hret, hn])
      (cellsOnAtoms_sat hsat)))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rax]
    exact Atoms.reg_of_holds (r := 0) (v := if as = bs then 1#64 else 0#64) hq (by braid_at)

end Examples.Mem.X86
