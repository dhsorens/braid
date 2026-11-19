/-
  Examples.Mem.X86.Leakage

  What the functions of `mem.c` reveal on x86-64 (`docs/Leakage.md`), each as a traced
  triple, as a theorem about the machine alone, and as a statement about two machines.

  * `copy_bytes` reveals the two addresses, the length, the stack pointer and the return
    address, and nothing of the bytes it copies (`copyBytesLeak`).
  * `equal_bytes` is not constant-time: it returns at the first byte that differs. Besides
    the two addresses, the length, the stack pointer and the return address it reveals
    exactly the index of the first position where the two regions differ, or that there is
    none (`firstDiff`, `equalBytesLeak`).
  * `equal_bytes_ct` reveals the two addresses, the length, the stack pointer and the return
    address, and nothing of the bytes it compares (`equalBytesCtLeak`): it gathers the
    differences without a branch and turns them into its result with `sete`.

  On x86-64 the return address is a word on the stack, so `ret` reveals the stack pointer,
  by the load, and the return address, by the jump; both are public inputs. The code
  addresses each byte as base plus index, and the leak functions give the same addresses
  from the base alone.

  Every loop is proved by the induction of its functional proof, with what the rounds still
  to run reveal as a function of the number of rounds.

  ## Main definitions

  * `copyBytesLeak`, `equalBytesLeak`, `equalBytesCtLeak`: what a run reveals, as a function
    of what is public
  * `firstDiff`: the index of the first position where two lists differ

  ## Main results

  * `copy_bytes_trace`, `copy_bytes_leakage`, `copy_bytes_leakage_eq`
  * `equal_bytes_trace`, `equal_bytes_leakage`, `equal_bytes_leakage_eq`
  * `equal_bytes_ct_trace`, `equal_bytes_ct_leakage`, `equal_bytes_ct_leakage_eq`
-/

module

public import Examples.Mem.X86.EqualCt

public section

namespace Examples.Mem.X86

open Braid Examples Examples.Mem Lowering.X86 Lowering.X86.Regs

/-- Finish a traced triple whose trace needs a proof of its own: the symbolic state is the
postcondition, and the equation between the traces is left as the goal. -/
local macro "braid_done_trace" : tactic =>
  `(tactic| (braid_norm; refine TripleT.done_split (by braid_split) ?_))

/-- Forget the values of the six status flags, of which those the last instruction leaves
undefined hold no value already. -/
local macro "forget_flags" : tactic =>
  `(tactic| (try braid_forget_flag 0
             try braid_forget_flag 1
             try braid_forget_flag 2
             try braid_forget_flag 3
             try braid_forget_flag 4
             try braid_forget_flag 5))

/-! ## `copy_bytes` -/

/-- What `n` rounds of the loop of `copy_bytes` reveal: in each, the address of the byte read
and of the byte written, and whether the loop goes round again, which is whether it is the
last of the `n`. -/
def copyRoundsLeak (pd ps : Word) : Nat → Trace
  | 0 => []
  | n + 1 =>
    [.read ps 1, .write pd 1, .jump (if n = 0 then 0x40101f#64 else 0x401010#64)] ++
      copyRoundsLeak (pd + 1#64) (ps + 1#64) n

/-- What `copy_bytes` reveals: whether there is anything to copy, the address of each byte
read and written, in order, the stack pointer, where the return address is read, and the
return address, where it goes. It is a function of the destination `pd`, the source `ps`,
the length `n`, the stack pointer `sp` and the return address `r`. -/
def copyBytesLeak (pd ps : Word) (n : Nat) (sp r : Word) : Trace :=
  [.jump (if n = 0 then 0x40101f#64 else 0x401005#64)] ++ copyRoundsLeak pd ps n ++
    [.read sp 8, .jump r]

/-- The loop of `copy_bytes`, at index `i`, with what it reveals. -/
theorem copy_bytes_loop_trace (pd ps n sp r : Word) :
    ∀ (ss ds : List (BitVec 8)) (s d : BitVec 8)
    (i t0 : Word) (c pf af z sg o : Bool) (t : Trace), ds.length = ss.length →
    i + BitVec.ofNat 64 (ss.length + 1) = n → i.toNat + ss.length + 1 < 2 ^ 64 →
    TripleT copy_bytes.program
      (Atoms.interp [.pc 0x401010#64, .reg rax i, .reg rcx t0, .reg rdx n, .reg rsi ps,
        .reg rdi pd, .prop (bytesAt (ps + i) (s :: ss)), .prop (bytesAt (pd + i) (d :: ds)),
        .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o]) t
      (Atoms.interp [.pc r, .prop (regAny rax), .prop (regAny rcx), .reg rdx n, .reg rsi ps,
        .reg rdi pd, .prop (bytesAt (ps + i) (s :: ss)), .prop (bytesAt (pd + i) (s :: ss)),
        .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (t ++ (copyRoundsLeak (pd + i) (ps + i) (ss.length + 1) ++ [.read sp 8, .jump r])) := by
  intro ss
  induction ss with
  | nil =>
    intro ds s d i t0 c pf af z sg o t hlen he hb
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
      braid_done_trace
      simp [copyRoundsLeak]
  | cons c' cs ih =>
    intro ds s d i t0 c pf af z sg o t hlen he hb
    obtain ⟨d', ds', rfl⟩ : ∃ d' ds', ds = d' :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at he hb hlen
    braid_unfold bytesAt_index ps i s (c' :: cs)
    braid_unfold bytesAt_index pd i d (d' :: ds')
    braid_sym_run
    · try braid_name_flag 2
      braid_call ih ds' c' d' (i + 1#64) _ _ _ _ _ _ _ _ (by omega) (by rw [← he]; bv_omega)
        (by bv_omega)
      braid_fold bytesAt_index ps i s (c' :: cs)
      braid_fold bytesAt_index pd i s (c' :: cs)
      braid_done_trace
      simp [copyRoundsLeak, BitVec.add_assoc]
    · exfalso
      have : n - (i + 1#64) ≠ 0#64 := by rw [← he]; bv_omega
      exact this hbr

/-- `copy_bytes` copies `n` bytes and reveals `copyBytesLeak` of the two addresses, `n`, the
stack pointer and the return address. -/
theorem copy_bytes_trace (pd ps sp r t0 t1 : Word) (ss ds : List (BitVec 8))
    (c pf af z sg o : Bool) (hlen : ds.length = ss.length) (hl : ss.length < 2 ^ 64)
    (t : Trace) :
    TripleT copy_bytes.program
      (Atoms.interp [.pc 0x401000#64, .reg rax t0, .reg rcx t1,
        .reg rdx (BitVec.ofNat 64 ss.length), .reg rsi ps, .reg rdi pd,
        .prop (bytesAt ps ss), .prop (bytesAt pd ds), .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o]) t
      (Atoms.interp [.pc r, .prop (regAny rax), .prop (regAny rcx),
        .reg rdx (BitVec.ofNat 64 ss.length), .reg rsi ps, .reg rdi pd,
        .prop (bytesAt ps ss), .prop (bytesAt pd ss), .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (t ++ copyBytesLeak pd ps ss.length sp r) := by
  cases ss with
  | nil =>
    have hds : ds = [] := List.length_eq_zero_iff.1 hlen
    subst hds
    simp only [List.length_nil]
    braid_sym_run
    braid_forget 0
    braid_forget 2
    forget_flags
    braid_done_trace
    simp [copyBytesLeak, copyRoundsLeak]
  | cons s ss =>
    obtain ⟨d, ds', rfl⟩ : ∃ d ds', ds = d :: ds' := by
      cases ds with
      | nil => simp at hlen
      | cons a b => exact ⟨a, b, rfl⟩
    simp only [List.length_cons] at hl hlen ⊢
    have hloop := copy_bytes_loop_trace pd ps (BitVec.ofNat 64 (ss.length + 1)) sp r ss ds' s d
      0#64
    simp only [BitVec.add_zero, BitVec.zero_add] at hloop
    braid_sym_run
    · exfalso
      have : BitVec.ofNat 64 (ss.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · braid_sym_step
      braid_sym_step
      simp only [BitVec.xor_self]
      try braid_name_flag 2
      braid_call hloop _ _ _ _ _ _ _ _ (by omega) trivial (by simpa using hl)
      braid_done_trace
      simp [copyBytesLeak]

/-- **What `copy_bytes` reveals, on the machine.** A machine of the model that runs the
executable of this image, is at the entry of `copy_bytes`, has the bytes `ss` in memory where
`rsi` points (`hsrc`), as many bytes `ds` where `rdi` points (`hlen`, `hdst`), their number in
`rdx` (`hn`), and the return address `r` in the eight bytes at the stack pointer (`hret`),
the two arrays and the return address apart from one another, going round the address space
(`hapart`, `hsrcsp`, `hdstsp`), reaches `r` on every run, and the trace of the run is
`copyBytesLeak` of `rdi`, `rsi`, the number in `rdx`, the stack pointer and `r`. -/
theorem copy_bytes_leakage [Layout] (m : MachineState) (ss ds : List (BitVec 8)) (r : Word)
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
    RunL exe
      (fun m' u => u = copyBytesLeak (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
        (m.data.regs.get64 .rdx).toNat (m.data.regs.get64 .rsp) r ∧ m'.pc.toBitVec = r)
      m [] := by
  have hl : ss.length < 2 ^ 64 := by
    have : (m.data.regs.get64 .rdi - m.data.regs.get64 .rsi).toNat < 2 ^ 64 := BitVec.isLt _
    omega
  have hnat : (m.data.regs.get64 .rdx).toNat = ss.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  refine (machine_soundT copy_bytes_holds
    (copy_bytes_trace (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) (m.data.regs.get64 .rsp)
      r (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx) ss ds m.data.status.cf
      m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of
      hlen hl [])
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
      (bytesAtoms_sat fun i hi => sat_mem_abs.2 (hdst i hi)))).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_⟩
  rw [← hr.pc]
  exact Atoms.pc_of_holds hq (by braid_at)

/-- **`copy_bytes` reveals nothing of the bytes it copies.** Two machines that run the
executable of this image, are at the entry of `copy_bytes`, each with a source, a
destination and the return address `r` on its stack as `copy_bytes_leakage` asks, and that
agree on `rdi`, `rsi`, `rdx` and the stack pointer, have the same trace on every run,
whatever the bytes are. -/
theorem copy_bytes_leakage_eq [Layout] (m₁ m₂ : MachineState)
    (ss₁ ds₁ ss₂ ds₂ : List (BitVec 8)) (r : Word)
    (hpc₁ : m₁.pc = 0x401000) (hpc₂ : m₂.pc = 0x401000)
    (hlen₁ : ds₁.length = ss₁.length) (hlen₂ : ds₂.length = ss₂.length)
    (hn₁ : m₁.data.regs.get64 .rdx = BitVec.ofNat 64 ss₁.length)
    (hn₂ : m₂.data.regs.get64 .rdx = BitVec.ofNat 64 ss₂.length)
    (hsrc₁ : ∀ (i : Nat) (hi : i < ss₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rsi + BitVec.ofNat 64 i) 1 (ss₁[i].zeroExtend 64))
    (hdst₁ : ∀ (i : Nat) (hi : i < ds₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rdi + BitVec.ofNat 64 i) 1 (ds₁[i].zeroExtend 64))
    (hsrc₂ : ∀ (i : Nat) (hi : i < ss₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rsi + BitVec.ofNat 64 i) 1 (ss₂[i].zeroExtend 64))
    (hdst₂ : ∀ (i : Nat) (hi : i < ds₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rdi + BitVec.ofNat 64 i) 1 (ds₂[i].zeroExtend 64))
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hapart₁ : ss₁.length ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rsi).toNat ∧
      ds₁.length ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rdi).toNat)
    (hapart₂ : ss₂.length ≤ (m₂.data.regs.get64 .rdi - m₂.data.regs.get64 .rsi).toNat ∧
      ds₂.length ≤ (m₂.data.regs.get64 .rsi - m₂.data.regs.get64 .rdi).toNat)
    (hsrcsp₁ : ss₁.length ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rsp).toNat)
    (hsrcsp₂ : ss₂.length ≤ (m₂.data.regs.get64 .rsp - m₂.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m₂.data.regs.get64 .rsi - m₂.data.regs.get64 .rsp).toNat)
    (hdstsp₁ : ds₁.length ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rsp).toNat)
    (hdstsp₂ : ds₂.length ≤ (m₂.data.regs.get64 .rsp - m₂.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m₂.data.regs.get64 .rdi - m₂.data.regs.get64 .rsp).toNat)
    (edi : m₂.data.regs.get64 .rdi = m₁.data.regs.get64 .rdi)
    (esi : m₂.data.regs.get64 .rsi = m₁.data.regs.get64 .rsi)
    (edx : m₂.data.regs.get64 .rdx = m₁.data.regs.get64 .rdx)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := copy_bytes_leakage m₁ ss₁ ds₁ r hpc₁ hlen₁ hn₁ hsrc₁ hdst₁ hret₁ hapart₁ hsrcsp₁
    hdstsp₁
  have h₂ := copy_bytes_leakage m₂ ss₂ ds₂ r hpc₂ hlen₂ hn₂ hsrc₂ hdst₂ hret₂ hapart₂ hsrcsp₂
    hdstsp₂
  rw [edi, esi, edx, esp] at h₂
  exact ⟨_, h₁, h₂⟩

/-! ## `equal_bytes` -/

/-- The index of the first position where two lists of bytes differ, or `none` if they agree
wherever both have a byte. -/
def firstDiff : List (BitVec 8) → List (BitVec 8) → Option Nat
  | a :: as, b :: bs => if a = b then (firstDiff as bs).map (· + 1) else some 0
  | _, _ => none

/-- What the rounds of the loop of `equal_bytes` reveal, with `n` bytes still to compare, of
which the first that differ are at the index `d`, if any do. A round reveals the addresses
of the two bytes it reads and whether they differ; if they do, the loop stops; if they do
not, the round also reveals whether it was the last. -/
def equalRoundsLeak (pa pb : Word) : Nat → Option Nat → Trace
  | 0, _ => []
  | _ + 1, some 0 => [.read pa 1, .read pb 1, .jump 0x401044#64]
  | n + 1, some (k + 1) =>
    [.read pa 1, .read pb 1, .jump 0x40103b#64,
      .jump (if n = 0 then 0x401043#64 else 0x401030#64)] ++
      equalRoundsLeak (pa + 1#64) (pb + 1#64) n (some k)
  | n + 1, none =>
    [.read pa 1, .read pb 1, .jump 0x40103b#64,
      .jump (if n = 0 then 0x401043#64 else 0x401030#64)] ++
      equalRoundsLeak (pa + 1#64) (pb + 1#64) n none

/-- What `equal_bytes` reveals: whether there is anything to compare, the addresses of the
bytes it reads, up to and including the first two that differ, the stack pointer, where the
return address is read, and the return address, where it goes. It is a function of the two
addresses `pa` and `pb`, the length `n`, the stack pointer `sp`, the return address `r`,
and the index `d` of the first position where the two regions differ, if there is one. It
takes nothing else of the bytes. -/
def equalBytesLeak (pa pb : Word) (n : Nat) (sp r : Word) (d : Option Nat) : Trace :=
  [.jump (if n = 0 then 0x401043#64 else 0x40102a#64)] ++ equalRoundsLeak pa pb n d ++
    [.read sp 8, .jump r]

/-- A round of `equal_bytes` whose two bytes differ is the last. -/
theorem equalRoundsLeak_differ (pa pb : Word) (n : Nat) {a b : BitVec 8}
    (as bs : List (BitVec 8)) (h : a ≠ b) :
    equalRoundsLeak pa pb (n + 1) (firstDiff (a :: as) (b :: bs)) =
      [.read pa 1, .read pb 1, .jump 0x401044#64] := by
  simp [firstDiff, h, equalRoundsLeak]

/-- A round of `equal_bytes` whose two bytes are the same, and the rounds after it. -/
theorem equalRoundsLeak_same (pa pb : Word) (n : Nat) (a : BitVec 8)
    (as bs : List (BitVec 8)) :
    equalRoundsLeak pa pb (n + 1) (firstDiff (a :: as) (a :: bs)) =
      [.read pa 1, .read pb 1, .jump 0x40103b#64,
        .jump (if n = 0 then 0x401043#64 else 0x401030#64)] ++
        equalRoundsLeak (pa + 1#64) (pb + 1#64) n (firstDiff as bs) := by
  simp only [firstDiff, ↓reduceIte]
  cases firstDiff as bs <;> simp [equalRoundsLeak]

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

/-- The loop of `equal_bytes`, at index `i`, with what it reveals. -/
theorem equal_bytes_loop_trace (f : Word → BitVec 8) (addrs : List Word)
    (pa pb n sp r : Word) :
    ∀ (as bs : List (BitVec 8)) (a b : BitVec 8) (i t8 : Word) (c pf af z sg o : Bool)
    (t : Trace),
    bs.length = as.length → i + BitVec.ofNat 64 (as.length + 1) = n →
    i.toNat + as.length + 1 < 2 ^ 64 → Reads f addrs (pa + i) (a :: as) →
    Reads f addrs (pb + i) (b :: bs) →
    TripleT equal_bytes.program
      (Atoms.interp [.pc 0x401030#64, .reg rax 1#64, .reg rcx i, .reg rdx n, .reg rsi pb,
        .reg rdi pa, .reg r8 t8, .prop (cellsOn f addrs), .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o]) t
      (Atoms.interp [.pc r, .reg rax (if a :: as = b :: bs then 1#64 else 0#64),
        .prop (regAny rcx), .reg rdx n, .reg rsi pb, .reg rdi pa, .prop (regAny r8),
        .prop (cellsOn f addrs), .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (t ++ (equalRoundsLeak (pa + i) (pb + i) (as.length + 1)
        (firstDiff (a :: as) (b :: bs)) ++ [.read sp 8, .jump r])) := by
  intro as
  induction as with
  | nil =>
    intro bs a b i t8 c pf af z sg o t hlen he hl hA hB
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
      rw [e, equalRoundsLeak_differ (pa + i) (pb + i) _ [] [] hbr]
      equal_bytes_forget
      braid_done_trace
      simp
    · simp only [index_eq, byte_cmp] at hbr
      have e : (if [f (pa + i)] = [f (pb + i)] then 1#64 else 0#64) = 1#64 :=
        ite_eq_left (by rw [hbr])
      rw [e, hbr, equalRoundsLeak_same (pa + i) (pb + i) _ (f (pb + i)) [] []]
      braid_sym_run
      · exact absurd (BitVec.sub_self _) hbr
      · braid_sym_run
        equal_bytes_forget
        braid_done_trace
        simp [equalRoundsLeak]
  | cons c' cs ih =>
    intro bs a b i t8 c pf af z sg o t hlen he hl hA hB
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
      rw [e, equalRoundsLeak_differ (pa + i) (pb + i) _ (c' :: cs) (d :: ds) hbr]
      equal_bytes_forget
      braid_done_trace
      simp
    · simp only [index_eq, byte_cmp] at hbr
      have e : (if f (pa + i) :: c' :: cs = f (pb + i) :: d :: ds then 1#64 else 0#64) =
          if c' :: cs = d :: ds then 1#64 else 0#64 := by
        rw [hbr]
        simp only [List.cons.injEq, true_and]
      rw [e, hbr, equalRoundsLeak_same (pa + i) (pb + i) _ (f (pb + i)) (c' :: cs) (d :: ds)]
      braid_sym_run
      · try braid_name_flag 2
        braid_call ih ds c' d (i + 1#64) _ _ _ _ _ _ _ _ (by omega) (by rw [← he]; bv_omega)
          (by bv_omega) hra hrb
        braid_done_trace
        simp
      · exfalso
        have : n - (i + 1#64) ≠ 0#64 := by rw [← he]; bv_omega
        exact this hbr

/-- `equal_bytes` compares `n` bytes and reveals `equalBytesLeak` of the two addresses, `n`,
the stack pointer, the return address, and the index of the first position where the bytes
differ. The bytes are read through one set of bytes, so the two regions may overlap. -/
theorem equal_bytes_trace (f : Word → BitVec 8) (addrs : List Word)
    (pa pb sp r t0 t2 t8 : Word) (as bs : List (BitVec 8)) (c pf af z sg o : Bool)
    (hlen : bs.length = as.length) (hl : as.length < 2 ^ 64) (hA : Reads f addrs pa as)
    (hB : Reads f addrs pb bs) (t : Trace) :
    TripleT equal_bytes.program
      (Atoms.interp [.pc 0x401020#64, .reg rax t0, .reg rcx t2,
        .reg rdx (BitVec.ofNat 64 as.length), .reg rsi pb, .reg rdi pa, .reg r8 t8,
        .prop (cellsOn f addrs), .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o]) t
      (Atoms.interp [.pc r, .reg rax (if as = bs then 1#64 else 0#64), .prop (regAny rcx),
        .reg rdx (BitVec.ofNat 64 as.length), .reg rsi pb, .reg rdi pa, .prop (regAny r8),
        .prop (cellsOn f addrs), .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (t ++ equalBytesLeak pa pb as.length sp r (firstDiff as bs)) := by
  cases as with
  | nil =>
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    subst hbs
    simp only [List.length_nil, ↓reduceIte]
    braid_sym_run
    equal_bytes_forget
    braid_done_trace
    simp [equalBytesLeak, equalRoundsLeak]
  | cons a as =>
    obtain ⟨b, bs', rfl⟩ : ∃ b bs', bs = b :: bs' := by
      cases bs with
      | nil => simp at hlen
      | cons x y => exact ⟨x, y, rfl⟩
    simp only [List.length_cons] at hl hlen ⊢
    have hloop := equal_bytes_loop_trace f addrs pa pb (BitVec.ofNat 64 (as.length + 1)) sp r
      as bs' a b 0#64
    simp only [BitVec.add_zero, BitVec.zero_add] at hloop
    braid_sym_run
    · exfalso
      have : BitVec.ofNat 64 (as.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · braid_sym_step
      braid_sym_step
      simp only [BitVec.xor_self]
      try braid_name_flag 2
      braid_call hloop _ _ _ _ _ _ _ _ (by omega) trivial (by simpa using hl) hA hB
      braid_done_trace
      simp [equalBytesLeak]

/-- **Two regions of a machine's memory, as one set of bytes.** If the machine has the bytes
`as` from `pa` on and the bytes `bs` from `pb` on, both are read through the set of the
machine's bytes at the addresses of the two regions, each address once, and every byte of
that set is in the machine's memory. The regions may overlap. -/
theorem reads_of_hasBytes (m : MachineState) (pa pb : Word) (as bs : List (BitVec 8))
    (ha : ∀ (i : Nat) (hi : i < as.length),
      HasBytes m (pa + BitVec.ofNat 64 i) 1 (as[i].zeroExtend 64))
    (hb : ∀ (i : Nat) (hi : i < bs.length),
      HasBytes m (pb + BitVec.ofNat 64 i) 1 (bs[i].zeroExtend 64)) :
    Reads (byteAt m) (dedup (addrsFrom pa as.length ++ addrsFrom pb bs.length)) pa as ∧
    Reads (byteAt m) (dedup (addrsFrom pa as.length ++ addrsFrom pb bs.length)) pb bs ∧
    ∀ x ∈ dedup (addrsFrom pa as.length ++ addrsFrom pb bs.length),
      (Atom.mem x 1 ((byteAt m x).zeroExtend 64) true).sat (abs m) := by
  refine ⟨reads_of_forall fun i hi => ⟨mem_dedup.2 (List.mem_append_left _
      (mem_addrsFrom.2 ⟨i, hi, rfl⟩)), byteAt_of_hasBytes (ha i hi)⟩,
    reads_of_forall fun i hi => ⟨mem_dedup.2 (List.mem_append_right _
      (mem_addrsFrom.2 ⟨i, hi, rfl⟩)), byteAt_of_hasBytes (hb i hi)⟩, fun x hx => ?_⟩
  refine sat_mem_abs.2 ?_
  rcases List.mem_append.1 (mem_dedup.1 hx) with h | h
  · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
    exact hasBytes_byteAt (ha i hi)
  · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
    exact hasBytes_byteAt (hb i hi)

/-- No address of two regions is one of the eight of a word that starts at or beyond the end
of each region, and ends before each starts. -/
theorem regions_apart {pa pb sp : Word} {la lb : Nat}
    (hasp : la ≤ (sp - pa).toNat ∧ 8 ≤ (pa - sp).toNat)
    (hbsp : lb ≤ (sp - pb).toNat ∧ 8 ≤ (pb - sp).toNat) :
    ∀ x ∈ dedup (addrsFrom pa la ++ addrsFrom pb lb), ¬ (x - sp).toNat < 8 := by
  intro x hx
  rcases List.mem_append.1 (mem_dedup.1 hx) with h | h
  · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
    exact sep_index hasp hi
  · obtain ⟨i, hi, rfl⟩ := mem_addrsFrom.1 h
    exact sep_index hbsp hi

/-- **What `equal_bytes` reveals, on the machine.** A machine of the model that runs the
executable of this image, is at the entry of `equal_bytes`, has the bytes `as` in memory
where `rdi` points (`ha`), as many bytes `bs` where `rsi` points (`hlen`, `hb`), their number
in `rdx` (`hn`), and the return address `r` in the eight bytes at the stack pointer (`hret`),
apart from both regions (`hasp`, `hbsp`), reaches `r` on every run, and the trace of the run
is `equalBytesLeak` of `rdi`, `rsi`, the number in `rdx`, the stack pointer, `r`, and the
index of the first position where `as` and `bs` differ, if there is one. The two regions may
overlap. -/
theorem equal_bytes_leakage [Layout] (m : MachineState) (as bs : List (BitVec 8)) (r : Word)
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
    RunL exe
      (fun m' u => u = equalBytesLeak (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
        (m.data.regs.get64 .rdx).toNat (m.data.regs.get64 .rsp) r (firstDiff as bs) ∧
        m'.pc.toBitVec = r) m [] := by
  have hl : as.length < 2 ^ 64 := by
    have : (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat < 2 ^ 64 := BitVec.isLt _
    omega
  have hnat : (m.data.regs.get64 .rdx).toNat = as.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  obtain ⟨hA, hB, hsat⟩ :=
    reads_of_hasBytes m (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) as bs ha hb
  refine (machine_soundT equal_bytes_holds
    (equal_bytes_trace _ _ (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
      (m.data.regs.get64 .rsp) r (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx)
      (m.data.regs.get64 .r8) as bs m.data.status.cf m.data.status.pf m.data.status.af
      m.data.status.zf m.data.status.sf m.data.status.of hlen hl hA hB [])
    (flat := [.pc 0x401020#64, .reg rax (m.data.regs.get64 .rax),
      .reg rcx (m.data.regs.get64 .rcx), .reg rdx (BitVec.ofNat 64 as.length),
      .reg rsi (m.data.regs.get64 .rsi), .reg rdi (m.data.regs.get64 .rdi),
      .reg r8 (m.data.regs.get64 .r8)] ++ cellsOnAtoms (byteAt m) _ ++
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
          | exact disj_flag_cellsOnAtoms
          | exact disj_mem_cellsOnAtoms (regions_apart hasp hbsp)))
    (Atoms.forall_flat
      (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
        hret, hn])
      (cellsOnAtoms_sat hsat))).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_⟩
  rw [← hr.pc]
  exact Atoms.pc_of_holds hq (by braid_at)

/-- **`equal_bytes` reveals where its arguments first differ, and nothing else of them.** Two
machines that run the executable of this image, are at the entry of `equal_bytes`, each with
two regions and the return address `r` on its stack as `equal_bytes_leakage` asks, and that
agree on `rdi`, `rsi`, `rdx`, the stack pointer, and on the index of the first position
where their two regions differ, or on there being none (`hd`), have the same trace on every
run, whatever the bytes are. So the function is not constant-time, and what it gives away
beyond the public inputs is exactly that index. -/
theorem equal_bytes_leakage_eq [Layout] (m₁ m₂ : MachineState)
    (as₁ bs₁ as₂ bs₂ : List (BitVec 8)) (r : Word)
    (hpc₁ : m₁.pc = 0x401020) (hpc₂ : m₂.pc = 0x401020)
    (hlen₁ : bs₁.length = as₁.length) (hlen₂ : bs₂.length = as₂.length)
    (hn₁ : m₁.data.regs.get64 .rdx = BitVec.ofNat 64 as₁.length)
    (hn₂ : m₂.data.regs.get64 .rdx = BitVec.ofNat 64 as₂.length)
    (ha₁ : ∀ (i : Nat) (hi : i < as₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rdi + BitVec.ofNat 64 i) 1 (as₁[i].zeroExtend 64))
    (hb₁ : ∀ (i : Nat) (hi : i < bs₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rsi + BitVec.ofNat 64 i) 1 (bs₁[i].zeroExtend 64))
    (ha₂ : ∀ (i : Nat) (hi : i < as₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rdi + BitVec.ofNat 64 i) 1 (as₂[i].zeroExtend 64))
    (hb₂ : ∀ (i : Nat) (hi : i < bs₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rsi + BitVec.ofNat 64 i) 1 (bs₂[i].zeroExtend 64))
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hasp₁ : as₁.length ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rsp).toNat)
    (hbsp₁ : bs₁.length ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rsp).toNat)
    (hasp₂ : as₂.length ≤ (m₂.data.regs.get64 .rsp - m₂.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m₂.data.regs.get64 .rdi - m₂.data.regs.get64 .rsp).toNat)
    (hbsp₂ : bs₂.length ≤ (m₂.data.regs.get64 .rsp - m₂.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m₂.data.regs.get64 .rsi - m₂.data.regs.get64 .rsp).toNat)
    (edi : m₂.data.regs.get64 .rdi = m₁.data.regs.get64 .rdi)
    (esi : m₂.data.regs.get64 .rsi = m₁.data.regs.get64 .rsi)
    (edx : m₂.data.regs.get64 .rdx = m₁.data.regs.get64 .rdx)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp)
    (hd : firstDiff as₂ bs₂ = firstDiff as₁ bs₁) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := equal_bytes_leakage m₁ as₁ bs₁ r hpc₁ hlen₁ hn₁ ha₁ hb₁ hret₁ hasp₁ hbsp₁
  have h₂ := equal_bytes_leakage m₂ as₂ bs₂ r hpc₂ hlen₂ hn₂ ha₂ hb₂ hret₂ hasp₂ hbsp₂
  rw [edi, esi, edx, esp, hd] at h₂
  exact ⟨_, h₁, h₂⟩

/-! ## `equal_bytes_ct` -/

/-- What `n` rounds of the loop of `equal_bytes_ct` reveal: in each, the addresses of the two
bytes it reads, and whether the loop goes round again, which is whether it is the last of
the `n`. -/
def ctRoundsLeak (pa pb : Word) : Nat → Trace
  | 0 => []
  | n + 1 =>
    [.read pb 1, .read pa 1, .jump (if n = 0 then 0x401074#64 else 0x401060#64)] ++
      ctRoundsLeak (pa + 1#64) (pb + 1#64) n

/-- What `equal_bytes_ct` reveals: whether there is anything to compare, the addresses of all
the bytes, in order, the stack pointer, where the return address is read, and the return
address, where it goes. It is a function of the two addresses `pa` and `pb`, the length
`n`, the stack pointer `sp` and the return address `r`, and takes nothing of the bytes. -/
def equalBytesCtLeak (pa pb : Word) (n : Nat) (sp r : Word) : Trace :=
  [.jump (if n = 0 then 0x40107c#64 else 0x401055#64)] ++ ctRoundsLeak pa pb n ++
    [.read sp 8, .jump r]

/-- Forget what `equal_bytes_ct` leaves in the registers it uses and in the flags. -/
local macro "equal_bytes_ct_forget" : tactic =>
  `(tactic| (braid_forget 2; braid_forget 8; forget_flags))

/-- Run the two loads of a round of `equal_bytes_ct`, from the bytes at `pb + i` and at
`pa + i` of a set of bytes. -/
local macro "equal_bytes_ct_loads " f:term ", " ha:term ", " hb:term : tactic =>
  `(tactic| (braid_unfold cellsOn_open $f $hb
             braid_sym_step
             braid_fold cellsOn_open $f $hb
             braid_unfold cellsOn_open $f $ha
             braid_sym_step
             braid_fold cellsOn_open $f $ha))

/-- The loop of `equal_bytes_ct`, at index `i`, with what it reveals: `ctRoundsLeak`, which
does not mention the bytes. -/
theorem equal_bytes_ct_loop_trace (f : Word → BitVec 8) (addrs : List Word)
    (pa pb n sp r : Word) :
    ∀ (as bs : List (BitVec 8)) (a b d : BitVec 8) (i t8 : Word) (c pf af z sg o : Bool)
    (t : Trace),
    bs.length = as.length → i + BitVec.ofNat 64 (as.length + 1) = n →
    i.toNat + as.length + 1 < 2 ^ 64 → Reads f addrs (pa + i) (a :: as) →
    Reads f addrs (pb + i) (b :: bs) →
    TripleT equal_bytes_ct.program
      (Atoms.interp [.pc 0x401060#64, .reg rax i, .reg rcx (d.zeroExtend 64), .reg rdx n,
        .reg rsi pb, .reg rdi pa, .reg r8 t8, .prop (cellsOn f addrs), .reg rsp sp,
        .mem sp 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o]) t
      (Atoms.interp [.pc r,
        .reg rax (if orDiff d (a :: as) (b :: bs) = 0#8 then 1#64 else 0#64),
        .prop (regAny rcx), .reg rdx n, .reg rsi pb, .reg rdi pa, .prop (regAny r8),
        .prop (cellsOn f addrs), .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (t ++ (ctRoundsLeak (pa + i) (pb + i) (as.length + 1) ++ [.read sp 8, .jump r])) := by
  intro as
  induction as with
  | nil =>
    intro bs a b d i t8 c pf af z sg o t hlen he hl hA hB
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
      braid_done_trace
      simp [ctRoundsLeak]
  | cons c' cs ih =>
    intro bs a b d i t8 c pf af z sg o t hlen he hl hA hB
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
      braid_call ih es c' e _ (i + 1#64) _ _ _ _ _ _ _ _ (by omega) (by rw [← he]; bv_omega)
        (by bv_omega) hra hrb
      braid_done_trace
      simp [ctRoundsLeak, BitVec.add_assoc]
    · exfalso
      have : n - (i + 1#64) ≠ 0#64 := by rw [← he]; bv_omega
      exact this hbr

/-- `equal_bytes_ct` returns one if the `n` bytes its first argument points to are those its
second argument points to, and zero otherwise, and reveals `equalBytesCtLeak` of the two
addresses, `n`, the stack pointer and the return address. The bytes are read through one set
of bytes, so the two regions may overlap. -/
theorem equal_bytes_ct_trace (f : Word → BitVec 8) (addrs : List Word)
    (pa pb sp r t0 t2 t8 : Word) (as bs : List (BitVec 8)) (c pf af z sg o : Bool)
    (hlen : bs.length = as.length) (hl : as.length < 2 ^ 64) (hA : Reads f addrs pa as)
    (hB : Reads f addrs pb bs) (t : Trace) :
    TripleT equal_bytes_ct.program
      (Atoms.interp [.pc 0x401050#64, .reg rax t0, .reg rcx t2,
        .reg rdx (BitVec.ofNat 64 as.length), .reg rsi pb, .reg rdi pa, .reg r8 t8,
        .prop (cellsOn f addrs), .reg rsp sp, .mem sp 8 r true,
        .flag Flags.cf c, .flag Flags.pf pf, .flag Flags.af af, .flag Flags.zf z,
        .flag Flags.sf sg, .flag Flags.of o]) t
      (Atoms.interp [.pc r, .reg rax (if as = bs then 1#64 else 0#64), .prop (regAny rcx),
        .reg rdx (BitVec.ofNat 64 as.length), .reg rsi pb, .reg rdi pa, .prop (regAny r8),
        .prop (cellsOn f addrs), .reg rsp (sp + 8#64), .mem sp 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of)])
      (t ++ equalBytesCtLeak pa pb as.length sp r) := by
  cases as with
  | nil =>
    have hbs : bs = [] := List.length_eq_zero_iff.1 hlen
    subst hbs
    simp only [List.length_nil, ↓reduceIte]
    braid_sym_run
    equal_bytes_ct_forget
    braid_done_trace
    simp [equalBytesCtLeak, ctRoundsLeak]
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
    have hloop := equal_bytes_ct_loop_trace f addrs pa pb (BitVec.ofNat 64 (as.length + 1)) sp
      r as bs' a b 0#8 0#64
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
      braid_call hloop _ _ _ _ _ _ _ _ (by omega) trivial (by simpa using hl) hA hB
      braid_done_trace
      simp [equalBytesCtLeak]

/-- **What `equal_bytes_ct` reveals, on the machine.** A machine of the model that runs the
executable of this image, is at the entry of `equal_bytes_ct`, has the bytes `as` in memory
where `rdi` points (`ha`), as many bytes `bs` where `rsi` points (`hlen`, `hb`), their number
in `rdx` (`hn`), and the return address `r` in the eight bytes at the stack pointer (`hret`),
apart from both regions (`hasp`, `hbsp`), reaches `r` on every run, and the trace of the run
is `equalBytesCtLeak` of `rdi`, `rsi`, the number in `rdx`, the stack pointer and `r`. The
two regions may overlap. -/
theorem equal_bytes_ct_leakage [Layout] (m : MachineState) (as bs : List (BitVec 8))
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
    RunL exe
      (fun m' u => u = equalBytesCtLeak (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
        (m.data.regs.get64 .rdx).toNat (m.data.regs.get64 .rsp) r ∧ m'.pc.toBitVec = r)
      m [] := by
  have hl : as.length < 2 ^ 64 := by
    have : (m.data.regs.get64 .rsp - m.data.regs.get64 .rdi).toNat < 2 ^ 64 := BitVec.isLt _
    omega
  have hnat : (m.data.regs.get64 .rdx).toNat = as.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  obtain ⟨hA, hB, hsat⟩ :=
    reads_of_hasBytes m (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi) as bs ha hb
  refine (machine_soundT equal_bytes_ct_holds
    (equal_bytes_ct_trace _ _ (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
      (m.data.regs.get64 .rsp) r (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx)
      (m.data.regs.get64 .r8) as bs m.data.status.cf m.data.status.pf m.data.status.af
      m.data.status.zf m.data.status.sf m.data.status.of hlen hl hA hB [])
    (flat := [.pc 0x401050#64, .reg rax (m.data.regs.get64 .rax),
      .reg rcx (m.data.regs.get64 .rcx), .reg rdx (BitVec.ofNat 64 as.length),
      .reg rsi (m.data.regs.get64 .rsi), .reg rdi (m.data.regs.get64 .rdi),
      .reg r8 (m.data.regs.get64 .r8)] ++ cellsOnAtoms (byteAt m) _ ++
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
          | exact disj_flag_cellsOnAtoms
          | exact disj_mem_cellsOnAtoms (regions_apart hasp hbsp)))
    (Atoms.forall_flat
      (by simp [Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, sat_mem_abs, regOf, flagOf, hpc,
        hret, hn])
      (cellsOnAtoms_sat hsat))).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_⟩
  rw [← hr.pc]
  exact Atoms.pc_of_holds hq (by braid_at)

/-- **`equal_bytes_ct` reveals nothing of the bytes it compares.** Two machines that run the
executable of this image, are at the entry of `equal_bytes_ct`, each with two regions and the
return address `r` on its stack as `equal_bytes_ct_leakage` asks, and that agree on `rdi`,
`rsi`, `rdx` and the stack pointer, have the same trace on every run, whatever the bytes
are, and whether they are the same or not. -/
theorem equal_bytes_ct_leakage_eq [Layout] (m₁ m₂ : MachineState)
    (as₁ bs₁ as₂ bs₂ : List (BitVec 8)) (r : Word)
    (hpc₁ : m₁.pc = 0x401050) (hpc₂ : m₂.pc = 0x401050)
    (hlen₁ : bs₁.length = as₁.length) (hlen₂ : bs₂.length = as₂.length)
    (hn₁ : m₁.data.regs.get64 .rdx = BitVec.ofNat 64 as₁.length)
    (hn₂ : m₂.data.regs.get64 .rdx = BitVec.ofNat 64 as₂.length)
    (ha₁ : ∀ (i : Nat) (hi : i < as₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rdi + BitVec.ofNat 64 i) 1 (as₁[i].zeroExtend 64))
    (hb₁ : ∀ (i : Nat) (hi : i < bs₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rsi + BitVec.ofNat 64 i) 1 (bs₁[i].zeroExtend 64))
    (ha₂ : ∀ (i : Nat) (hi : i < as₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rdi + BitVec.ofNat 64 i) 1 (as₂[i].zeroExtend 64))
    (hb₂ : ∀ (i : Nat) (hi : i < bs₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rsi + BitVec.ofNat 64 i) 1 (bs₂[i].zeroExtend 64))
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hasp₁ : as₁.length ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rdi - m₁.data.regs.get64 .rsp).toNat)
    (hbsp₁ : bs₁.length ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rsp).toNat)
    (hasp₂ : as₂.length ≤ (m₂.data.regs.get64 .rsp - m₂.data.regs.get64 .rdi).toNat ∧
      8 ≤ (m₂.data.regs.get64 .rdi - m₂.data.regs.get64 .rsp).toNat)
    (hbsp₂ : bs₂.length ≤ (m₂.data.regs.get64 .rsp - m₂.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m₂.data.regs.get64 .rsi - m₂.data.regs.get64 .rsp).toNat)
    (edi : m₂.data.regs.get64 .rdi = m₁.data.regs.get64 .rdi)
    (esi : m₂.data.regs.get64 .rsi = m₁.data.regs.get64 .rsi)
    (edx : m₂.data.regs.get64 .rdx = m₁.data.regs.get64 .rdx)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := equal_bytes_ct_leakage m₁ as₁ bs₁ r hpc₁ hlen₁ hn₁ ha₁ hb₁ hret₁ hasp₁ hbsp₁
  have h₂ := equal_bytes_ct_leakage m₂ as₂ bs₂ r hpc₂ hlen₂ hn₂ ha₂ hb₂ hret₂ hasp₂ hbsp₂
  rw [edi, esi, edx, esp] at h₂
  exact ⟨_, h₁, h₂⟩

end Examples.Mem.X86
