/-
  Examples.Mem.X86.EqualCt

  `equal_bytes_ct` of `mem.c` on x86-64: comparing bytes in a time that depends on their
  number alone.

  The code reads every byte and branches on none of them: it gathers the XOR of each pair, by
  OR, in `cl`, and tests `cl` after the loop. The loop is proved by induction on the bytes
  still to visit, at any index `i`, with the loop's specification as the invariant: `rcx`
  holds a byte `d` gathered so far, and the result is one exactly when `orDiff d as bs`, the
  byte gathered at the end, is zero. That this is so exactly when the lists are the same is
  `orDiff_zero`. As for `equal_bytes`, memory is a set of single bytes (`cellsOn`), so the
  two regions may overlap, and the return address is on the stack, apart from the bytes.

  ## Main results

  * `equal_bytes_ct_spec`: the specification
  * `equal_bytes_ct_correct`: the same, about the machine alone
-/

module

public import Examples.Mem.X86.Proofs
public import Examples.Mem.EqualCt
import Braid.BV

public section

namespace Examples.Mem.X86

open Braid Examples Examples.Mem Lowering.X86 Lowering.X86.Regs

/-- Forget what `equal_bytes_ct` leaves in the registers it uses and in the flags, of which
those the last instruction leaves undefined hold no value already. -/
local macro "equal_bytes_ct_forget" : tactic =>
  `(tactic| (braid_forget 2; braid_forget 8
             try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 3
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-- Run the two loads of a round of `equal_bytes_ct`, from the bytes at `pb + i` and at
`pa + i` of a set of bytes. -/
local macro "equal_bytes_ct_loads " f:term ", " ha:term ", " hb:term : tactic =>
  `(tactic| (braid_unfold cellsOn_open $f $hb
             braid_sym_step
             braid_fold cellsOn_open $f $hb
             braid_unfold cellsOn_open $f $ha
             braid_sym_step
             braid_fold cellsOn_open $f $ha))

/-- The accumulator after a round: the byte gathered so far, with the XOR of the two bytes
of the round ORed into it. -/
theorem acc_round (a b d : BitVec 8) :
    BitVec.setWidth 64 d &&& 0xffffffffffffff00#64 |||
      (BitVec.setWidth 64 d ||| BitVec.setWidth 64 (BitVec.setWidth 8
        (BitVec.setWidth 64 b &&& 0xffffffffffffff00#64 |||
          BitVec.setWidth 64 b ^^^ BitVec.setWidth 64 a))) =
    BitVec.zeroExtend 64 (d ||| (a ^^^ b)) := by
  bv_auto

/-- What `xor eax, eax`, `test cl, cl` and `sete al` leave in `rax` from the gathered byte. -/
theorem result_eq (w : Word) (x : BitVec 8) :
    (BitVec.setWidth 64 (BitVec.setWidth 32 w) ^^^ BitVec.setWidth 64 (BitVec.setWidth 32 w)) &&&
        0xffffffffffffff00#64 |||
      ofBool (BitVec.setWidth 64 x &&& BitVec.setWidth 64 x == 0#64) =
    if x = 0#8 then 1#64 else 0#64 := by
  simp only [ofBool]
  bv_auto

/-- The loop of `equal_bytes_ct`, at index `i`: gather into the byte `d` of `rcx` the XOR of
each pair of bytes from index `i` on, which are read through one set of bytes, and return one
if the byte gathered is zero, and zero otherwise. -/
theorem equal_bytes_ct_loop (f : Word → BitVec 8) (addrs : List Word) (pa pb n sp r : Word) :
    ∀ (as bs : List (BitVec 8)) (a b d : BitVec 8) (i t8 : Word) (c pf af z sg o : Bool),
    bs.length = as.length → i + BitVec.ofNat 64 (as.length + 1) = n →
    i.toNat + as.length + 1 < 2 ^ 64 → Reads f addrs (pa + i) (a :: as) →
    Reads f addrs (pb + i) (b :: bs) →
    Triple equal_bytes_ct.program
      (Atoms.interp [.pc 0x401060#64, .reg rax i, .reg rcx (d.zeroExtend 64), .reg rdx n,
        .reg rsi pb, .reg rdi pa, .reg r8 t8, .prop (cellsOn f addrs), .reg rsp sp,
        .mem sp 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o])
      (Atoms.interp [.pc r,
        .reg rax (if orDiff d (a :: as) (b :: bs) = 0#8 then 1#64 else 0#64),
        .prop (regAny rcx), .reg rdx n, .reg rsi pb, .reg rdi pa, .prop (regAny r8),
        .prop (cellsOn f addrs), .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)]) := by
  intro as
  induction as with
  | nil =>
    intro bs a b d i t8 c pf af z sg o hlen he hl hA hB
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    have hn : n = i + 1#64 := by simpa using he.symm
    subst hbs hn
    obtain ⟨ha, rfl, -⟩ := hA
    obtain ⟨hb, rfl, -⟩ := hB
    rw [← index_eq pa i] at ha
    rw [← index_eq pb i] at hb
    equal_bytes_ct_loads f, ha, hb
    braid_sym_run
    · exact absurd (BitVec.sub_self _) hbr
    · rw [index_eq pb i, index_eq pa i, acc_round]
      braid_sym_run
      rw [result_eq, orDiff_cons, orDiff_nil]
      equal_bytes_ct_forget
      braid_done
  | cons c' cs ih =>
    intro bs a b d i t8 c pf af z sg o hlen he hl hA hB
    obtain ⟨e, es, rfl⟩ : ∃ e es, bs = e :: es := by
      cases bs with
      | nil => simp at hlen
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at he hl hlen
    obtain ⟨ha, rfl, hra⟩ := hA
    obtain ⟨hb, rfl, hrb⟩ := hB
    rw [← index_eq pa i] at ha
    rw [← index_eq pb i] at hb
    rw [BitVec.add_assoc] at hra hrb
    equal_bytes_ct_loads f, ha, hb
    braid_sym_run
    · rw [index_eq pb i, index_eq pa i, acc_round, orDiff_cons]
      try braid_name_flag 2
      braid_call ih es c' e _ (i + 1#64) _ _ _ _ _ _ _ (by omega) (by rw [← he]; bv_omega)
        (by bv_omega) hra hrb
      braid_done
    · exfalso
      have : n - (i + 1#64) ≠ 0#64 := by rw [← he]; bv_omega
      exact this hbr

/-- `equal_bytes_ct` returns one if the `n` bytes its first argument points to are those its
second argument points to, and zero otherwise. The bytes are read through one set of bytes,
so the two regions may overlap. -/
theorem equal_bytes_ct_spec (f : Word → BitVec 8) (addrs : List Word)
    (pa pb sp r t0 t2 t8 : Word) (as bs : List (BitVec 8)) (c pf af z sg o : Bool)
    (hlen : bs.length = as.length) (hl : as.length < 2 ^ 64) (hA : Reads f addrs pa as)
    (hB : Reads f addrs pb bs) :
    Triple equal_bytes_ct.program
      (Atoms.interp [.pc 0x401050#64, .reg rax t0, .reg rcx t2,
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
    equal_bytes_ct_forget
    braid_done
  | cons a as =>
    obtain ⟨b, bs', rfl⟩ : ∃ b bs', bs = b :: bs' := by
      cases bs with
      | nil => simp at hlen
      | cons x y => exact ⟨x, y, rfl⟩
    have e : (if a :: as = b :: bs' then 1#64 else 0#64) =
        if orDiff 0#8 (a :: as) (b :: bs') = 0#8 then 1#64 else 0#64 := by
      simp only [orDiff_zero _ _ hlen]
    rw [e]
    simp only [List.length_cons] at hl hlen ⊢
    have hloop := equal_bytes_ct_loop f addrs pa pb (BitVec.ofNat 64 (as.length + 1)) sp r as
      bs' a b 0#8 0#64
    simp only [BitVec.add_zero, BitVec.zero_add] at hloop
    braid_sym_run
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · braid_sym_step
      braid_sym_step
      braid_sym_step
      simp only [BitVec.xor_self]
      try braid_name_flag 2
      braid_call hloop _ _ _ _ _ _ _ (by omega) trivial (by simpa using hl) hA hB
      braid_done

/-! ## On the machine -/

/-- **`equal_bytes_ct` on the machine.** A machine of the model that runs the executable of this
image, is at the entry of `equal_bytes_ct`, has the bytes `as` in memory where `rdi` points, as
many bytes `bs` where `rsi` points, and their number in `rdx`, and has the return address
`r` in the eight bytes at the stack pointer, apart from both regions, reaches `r` on every
run, with one in `rax` if `as` and `bs` are the same, and zero otherwise. The two regions
may overlap. -/
theorem equal_bytes_ct_correct [Layout] (m : MachineState) (as bs : List (BitVec 8))
    (r : Word) (hpc : m.pc = 0x401050) (hlen : bs.length = as.length)
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
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat equal_bytes_ct_holds
    (equal_bytes_ct_spec f addrs (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
      (m.data.regs.get64 .rsp) r (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx)
      (m.data.regs.get64 .r8) as bs m.data.status.cf m.data.status.pf m.data.status.af
      m.data.status.zf m.data.status.sf m.data.status.of hlen hl hA hB)
    (flat := [.pc 0x401050#64, .reg rax (m.data.regs.get64 .rax),
      .reg rcx (m.data.regs.get64 .rcx), .reg rdx (BitVec.ofNat 64 as.length),
      .reg rsi (m.data.regs.get64 .rsi), .reg rdi (m.data.regs.get64 .rdi),
      .reg r8 (m.data.regs.get64 .r8)] ++ cellsOnAtoms f addrs ++
      [.reg rsp (m.data.regs.get64 .rsp), .mem (m.data.regs.get64 .rsp) 8 r true,
        .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
        .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
        .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of])
    (by rw [cellsOn_eq_interp]
        exact Atoms.interp_flatten [.pc 0x401050#64, .reg rax (m.data.regs.get64 .rax),
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
