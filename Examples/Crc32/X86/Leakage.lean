/-
  Examples.Crc32.X86.Leakage

  What `crc32` reveals on x86-64 (`docs/Leakage.md`). It is not constant-time: each byte of
  the message is taken into the register through two lookups in the table, and the address
  of a lookup is the table's address and four times an index that is four bits of the
  register (`xor r9d, [rdi + r8 * 4]`). A run reveals, besides the address and the length of
  the message, the table's address, the stack pointer and the return address, exactly the
  sequence of those indices, two for each byte (`crcIndices`), which is a function of the
  value `crc32` continues from and of the message. The code does not branch on the message:
  its only branches are on the length.

  The indices reveal the message. The first index of a byte is the low four bits of the
  register with the byte added, and the second the low four bits four bits of the division
  later, so, the register before the byte being known, the two give the byte; a watcher who
  knows the starting value recovers every byte in turn (`crcIndices_inj`). A watcher who does
  not know it still learns the low four bits of the register at every lookup.

  The return address is a word on the stack, so `ret` reveals the stack pointer, by the load,
  and the return address, by the jump; both are public inputs.

  ## Main definitions

  * `tableIndices`, `crcIndices`: the table indices of a message, in plain Lean
  * `crc32Leak`: what a run reveals, as a function of what is public and of those indices

  ## Main results

  * `crc32_trace`: the traced triple
  * `crc32_leakage`: the same, about the machine alone
  * `crc32_leakage_eq`: two machines that agree on what is public and on the indices run with
    the same trace
  * `crcIndices_inj`: from the same starting value, the indices determine the message
-/

module

public import Examples.Crc32.X86.Proofs

public section

namespace Examples.Crc32.X86

open Braid Examples Lowering.X86 Lowering.X86.Regs

/-- Finish a traced triple whose trace needs a proof of its own: the symbolic state is the
postcondition, and the equation between the traces is left as the goal. -/
local macro "braid_done_trace" : tactic =>
  `(tactic| (braid_norm; refine TripleT.done_split (by braid_split) ?_))

/-! ## The table indices of a message -/

/-- The indices at which the table is read while the bytes `bs` are taken into the register
`c`, two for each byte: the low four bits of the register with the byte added, and the low
four bits of the register four bits of the division later. -/
def tableIndices (c : BitVec 32) : List (BitVec 8) → List (BitVec 4)
  | [] => []
  | b :: bs =>
    (c ^^^ b.zeroExtend 32).truncate 4 :: (nibble (c ^^^ b.zeroExtend 32)).truncate 4 ::
      tableIndices (byte c b) bs

/-- The indices at which `crc32` reads the table for the bytes `bs`, continuing from `crc`:
the register starts as the complement of `crc`. -/
def crcIndices (crc : BitVec 32) (bs : List (BitVec 8)) : List (BitVec 4) :=
  tableIndices (~~~crc) bs

/-- The address of entry `i` of a table at `tbl`. -/
def entryAddr (tbl : Word) (i : BitVec 4) : Word := tbl + i.zeroExtend 64 * 4#64

/-- What the rounds of the loop of `crc32` reveal, for a message at `p` and a table at `tbl`,
from the table indices of the bytes still to take, two for each: in each round, the address
of the byte read, the addresses of the two entries of the table read, and whether the loop
goes round again, which is whether indices are left. -/
def crcRoundsLeak (tbl p : Word) : List (BitVec 4) → Trace
  | i :: j :: is =>
    [.read p 1, .read (entryAddr tbl i) 4, .read (entryAddr tbl j) 4,
      .jump (if is = [] then 0x40104d#64 else 0x401020#64)] ++ crcRoundsLeak tbl (p + 1#64) is
  | _ => []

/-- What `crc32` reveals: whether there is a message, for each byte its address and the
addresses of the two entries of the table read for it, the stack pointer, where the return
address is read, and the return address, where it goes. It is a function of the table's
address `tbl`, the message's address `p` and length `n`, the stack pointer `sp`, the return
address `r`, and the table indices `is` of the message, two for each byte. It takes nothing
else of the message or of the starting value; but the indices are a function of both, and
with the starting value they give the message back (`crcIndices_inj`). -/
def crc32Leak (tbl p : Word) (n : Nat) (sp r : Word) (is : List (BitVec 4)) : Trace :=
  [.jump (if n = 0 then 0x40104f#64 else 0x401007#64)] ++ crcRoundsLeak tbl p is ++
    [.read sp 8, .jump r]

/-- A byte and the two indices of its lookups: the register before it being the same, bytes
with the same two indices are the same. -/
theorem byte_of_indices (c : BitVec 32) (b b' : BitVec 8)
    (h₁ : (c ^^^ b.zeroExtend 32).truncate 4 = (c ^^^ b'.zeroExtend 32).truncate 4)
    (h₂ : (nibble (c ^^^ b.zeroExtend 32)).truncate 4 =
      (nibble (c ^^^ b'.zeroExtend 32)).truncate 4) : b = b' := by
  simp only [nibble, bit, poly] at h₂
  bv_decide

/-- **The indices reveal the message.** From the same register, two messages with the same
table indices are the same message. -/
theorem tableIndices_inj : ∀ (c : BitVec 32) (bs bs' : List (BitVec 8)),
    tableIndices c bs = tableIndices c bs' → bs = bs'
  | _, [], [], _ => rfl
  | _, [], _ :: _, h => by simp [tableIndices] at h
  | _, _ :: _, [], h => by simp [tableIndices] at h
  | c, b :: bs, b' :: bs', h => by
    simp only [tableIndices, List.cons.injEq] at h
    obtain ⟨h₁, h₂, h₃⟩ := h
    obtain rfl := byte_of_indices c b b' h₁ h₂
    rw [tableIndices_inj _ bs bs' h₃]

/-- **The indices reveal the message**, for `crc32`: continuing from the same value, two
messages at which `crc32` reads the table at the same indices are the same message. -/
theorem crcIndices_inj (crc : BitVec 32) (bs bs' : List (BitVec 8))
    (h : crcIndices crc bs = crcIndices crc bs') : bs = bs' :=
  tableIndices_inj _ bs bs' h

/-- The address of a lookup, as the code computes it from the register `y`. -/
theorem entryAddr_eq (y : BitVec 32) :
    0x402050#64 + (BitVec.setWidth 64 y &&& 15#64) * 4#64 =
      entryAddr 0x402050#64 (BitVec.setWidth 4 y) := by
  unfold entryAddr
  bv_decide

/-! ## The traced triple -/

/-- An array of bytes that starts at index `j` from `p`, opened at its first byte, whose
address is written as the code computes it. -/
theorem bytesAt_index (p j : Word) (b : BitVec 8) (bs : List (BitVec 8)) :
    (Atom.prop (bytesAt (p + j * 1#64) (b :: bs))).interp =
      Atoms.interp [.mem (p + @HMul.hMul Word Word Word instHMul j 1#64) 1 (b.zeroExtend 64) true,
        .prop (bytesAt (p + (j * 1#64 + 1#64)) bs)] := by
  rw [bytesAt_cons, BitVec.add_assoc]

/-- Run the table lookup, an `xor` with the entry of the table the low four bits of `y`
select: open the table at that entry, run the instruction, and close the table. -/
local macro "crc32_lookup " w:term ", " y:term : tactic =>
  `(tactic| (
    braid_unfold tableAt_open $w 0x402050#64
      (0x402050#64 + @HMul.hMul Word Word Word instHMul (BitVec.setWidth 64 $y &&& 15#64) 4#64)
      $y (by bv_decide)
    braid_sym_step
    crc32_forget_flags
    braid_fold tableAt_open $w 0x402050#64
      (0x402050#64 + @HMul.hMul Word Word Word instHMul (BitVec.setWidth 64 $y &&& 15#64) 4#64)
      $y (by bv_decide)
    rw [nibble_reg]))

/-- One round of `crc32`, up to the branch at its end, as in the functional proof. -/
local macro "crc32_round " w:term ", " c:term ", " b:term : tactic =>
  `(tactic| (
    iterate 2 braid_sym_step
    rw [xor_byte_reg]
    crc32_forget_flags
    iterate 3 braid_sym_step
    crc32_forget_flags
    crc32_lookup $w, ($c ^^^ BitVec.zeroExtend 32 $b)
    iterate 3 braid_sym_step
    crc32_forget_flags
    crc32_lookup $w, (nibble ($c ^^^ BitVec.zeroExtend 32 $b))
    rw [← byte_eq]))

/-- The loop of `crc32`, with the index `j` in `rcx`, with what it reveals: the table indices
of the bytes from `p + j` on, taken into the register `c`. -/
theorem crc32_loop_trace (w : Bool) (p n s r : Word) :
    ∀ (bs : List (BitVec 8)) (b : BitVec 8)
    (c : BitVec 32) (j t8 t9 : Word) (fc fp fa fz fs fo : Bool) (t : Trace),
    n = j + BitVec.ofNat 64 (bs.length + 1) → bs.length + 1 < 2 ^ 64 →
    TripleT crc32.program
      (Atoms.interp [.pc 0x401020#64, .reg rax (c.zeroExtend 64), .reg rcx j, .reg rdx n,
        .reg rsi p, .reg rdi 0x402050#64, .reg r8 t8, .reg r9 t9, .reg rsp s, .mem s 8 r true,
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (bytesAt (p + j * 1#64) (b :: bs)), .prop (tableAt w 0x402050#64)]) t
      (Atoms.interp [.pc r, .reg rax ((~~~update c (b :: bs)).zeroExtend 64),
        .prop (regAny rcx), .reg rdx n, .reg rsi p, .reg rdi 0x402050#64, .prop (regAny r8),
        .prop (regAny r9), .reg rsp (s + 8#64), .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (bytesAt (p + j * 1#64) (b :: bs)), .prop (tableAt w 0x402050#64)])
      (t ++ (crcRoundsLeak 0x402050#64 (p + j) (tableIndices c (b :: bs)) ++
        [.read s 8, .jump r])) := by
  intro bs
  induction bs with
  | nil =>
    intro b c j t8 t9 fc fp fa fz fs fo t he hb
    have he' : n = j + 1#64 := by simpa using he
    braid_unfold bytesAt_index p j b []
    crc32_round w, c, b
    iterate 3 braid_sym_step
    · exact absurd (show n - (j + 1#64) = 0#64 by rw [he']; bv_decide) hbr
    · braid_sym_run
      rw [not_reg]
      braid_fold bytesAt_index p j b []
      braid_forget 2
      braid_forget 8
      braid_forget 9
      crc32_forget_flags
      simp only [update_cons, update_nil]
      braid_done_trace
      rw [entryAddr_eq, entryAddr_eq]
      simp [crcRoundsLeak, tableIndices]
  | cons d ds ih =>
    intro b c j t8 t9 fc fp fa fz fs fo t he hb
    simp only [List.length_cons] at he hb
    braid_unfold bytesAt_index p j b (d :: ds)
    crc32_round w, c, b
    iterate 3 braid_sym_step
    · have e : p + (j * 1#64 + 1#64) = p + (j + 1#64) * 1#64 := by bv_decide
      rw [e]
      crc32_name_flags
      braid_call ih d (byte c b) (j + 1#64) _ _ _ _ _ _ _ _ _ (by rw [he]; bv_omega)
        (by omega)
      rw [← e]
      braid_fold bytesAt_index p j b (d :: ds)
      rw [← update_cons]
      braid_done_trace
      rw [entryAddr_eq, entryAddr_eq]
      simp [crcRoundsLeak, tableIndices, BitVec.add_assoc]
    · exfalso
      have : n - (j + 1#64) ≠ 0#64 := by rw [he]; bv_omega
      exact this hbr

/-- `crc32` computes the CRC-32 of `n` bytes and reveals `crc32Leak` of the table's address,
the message's address, `n`, the stack pointer, the return address, and the table indices of
the message, continuing from the low half of the first argument. The lookup table is at
`0x402050`, where the linker put it. -/
theorem crc32_trace (w : Bool) (c p s r a t2 t8 t9 : Word) (bs : List (BitVec 8))
    (fc fp fa fz fs fo : Bool) (hl : bs.length < 2 ^ 64) (t : Trace) :
    TripleT crc32.program
      (Atoms.interp [.pc 0x401000#64, .reg rax a, .reg rcx t2,
        .reg rdx (BitVec.ofNat 64 bs.length), .reg rsi p, .reg rdi c, .reg r8 t8, .reg r9 t9,
        .reg rsp s, .mem s 8 r true,
        .flag Flags.cf fc, .flag Flags.pf fp, .flag Flags.af fa, .flag Flags.zf fz,
        .flag Flags.sf fs, .flag Flags.of fo,
        .prop (bytesAt p bs), .prop (tableAt w 0x402050#64)]) t
      (Atoms.interp [.pc r, .reg rax ((Crc32.crc32 (c.truncate 32) bs).zeroExtend 64),
        .prop (regAny rcx), .reg rdx (BitVec.ofNat 64 bs.length), .reg rsi p,
        .prop (regAny rdi), .prop (regAny r8), .prop (regAny r9), .reg rsp (s + 8#64),
        .mem s 8 r true,
        .prop (flagAny Flags.cf), .prop (flagAny Flags.pf), .prop (flagAny Flags.af),
        .prop (flagAny Flags.zf), .prop (flagAny Flags.sf), .prop (flagAny Flags.of),
        .prop (bytesAt p bs), .prop (tableAt w 0x402050#64)])
      (t ++ crc32Leak 0x402050#64 p bs.length s r (crcIndices (c.truncate 32) bs)) := by
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
    braid_done_trace
    simp [crc32Leak, crcIndices, tableIndices, crcRoundsLeak]
  | cons b bs =>
    simp only [List.length_cons] at hl ⊢
    iterate 3 braid_sym_step
    · exfalso
      have : BitVec.ofNat 64 (bs.length + 1) ≠ 0#64 := by bv_omega
      exact this (by simpa using hbr)
    · iterate 4 braid_sym_step
      rw [not_arg, BitVec.xor_self]
      crc32_name_flags
      have h := crc32_loop_trace w p (BitVec.ofNat 64 (bs.length + 1)) s r bs b
        (~~~c.truncate 32) 0#64 t8 t9
      have e : p + 0#64 * 1#64 = p := by bv_decide
      rw [e, BitVec.add_zero] at h
      braid_call h _ _ _ _ _ _ _ (by simp) hl
      braid_forget 5
      braid_norm
      refine TripleT.done_eq rfl ?_
      simp [crc32Leak, crcIndices]

/-! ## The machine -/

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

/-- **What `crc32` reveals, on the machine.** A machine of the model that runs the executable
of this image, is at the entry of `crc32`, has the bytes `bs` in memory where `rsi` points
(`hmsg`) and their number in `rdx` (`hn`), has the sixteen entries of the lookup table in
memory at `0x402050`, four bytes each (`htab`), and has the return address `r` in the eight
bytes at the stack pointer (`hret`), where the message, the table and those eight bytes are
apart from one another (`hms`, `hmt`, `hts`), reaches `r` on every run, and the trace of the
run is `crc32Leak` of the table's address, `rsi`, the number in `rdx`, the stack pointer,
`r`, and the indices at which the table is read for `bs`, continuing from the low half of
`rdi`. So the run reveals those indices, and through them the message. -/
theorem crc32_leakage [Layout] (m : MachineState) (bs : List (BitVec 8)) (r : Word)
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
    RunL exe
      (fun m' u => u = crc32Leak 0x402050#64 (m.data.regs.get64 .rsi)
        (m.data.regs.get64 .rdx).toNat (m.data.regs.get64 .rsp) r
        (crcIndices ((m.data.regs.get64 .rdi).truncate 32) bs) ∧ m'.pc.toBitVec = r) m [] := by
  have hl : bs.length < 2 ^ 64 := by
    have := (m.data.regs.get64 .rsp - m.data.regs.get64 .rsi).isLt
    omega
  have hnat : (m.data.regs.get64 .rdx).toNat = bs.length := by
    rw [hn, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hl]
  rw [hnat]
  have htab' : ∀ (i : Nat) (hi : i < tableWords.length),
      HasBytes m (0x402050#64 + BitVec.ofNat 64 (4 * i)) 4 tableWords[i] := by
    intro i hi
    rw [tableWords_getElem]
    exact htab i _
  refine (machine_soundT crc32_holds
    (crc32_trace true (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
      (m.data.regs.get64 .rsp) r (m.data.regs.get64 .rax) (m.data.regs.get64 .rcx)
      (m.data.regs.get64 .r8) (m.data.regs.get64 .r9) bs m.data.status.cf m.data.status.pf
      m.data.status.af m.data.status.zf m.data.status.sf m.data.status.of hl [])
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
      (cellsAtoms_sat fun i hi => sat_mem_abs.2 (htab' i hi)))).mono ?_
  rintro m' u ⟨e, σ', hr, hq⟩
  refine ⟨e, ?_⟩
  rw [← hr.pc]
  exact Atoms.pc_of_holds hq (by braid_at)

/-- **`crc32` reveals the table indices of its message, and nothing else of it.** Two
machines that run the executable of this image, are at the entry of `crc32`, each with a
message, the table and the return address `r` on its stack as `crc32_leakage` asks, and that
agree on `rsi`, `rdx`, the stack pointer, and on the indices at which the table is read
(`hidx`), have the same trace on every run.

The last hypothesis is not one about public inputs: the indices are computed from the
starting value and the message. If the two machines continue from the same value, it holds
only if the two messages are the same (`crcIndices_inj`). So `crc32` is not constant-time,
and what it gives away is the message. -/
theorem crc32_leakage_eq [Layout] (m₁ m₂ : MachineState) (bs₁ bs₂ : List (BitVec 8))
    (r : Word)
    (hpc₁ : m₁.pc = 0x401000) (hn₁ : m₁.data.regs.get64 .rdx = BitVec.ofNat 64 bs₁.length)
    (hmsg₁ : ∀ (i : Nat) (hi : i < bs₁.length),
      HasBytes m₁ (m₁.data.regs.get64 .rsi + BitVec.ofNat 64 i) 1 (bs₁[i].zeroExtend 64))
    (htab₁ : ∀ (i : Nat) (hi : i < table.length),
      HasBytes m₁ (0x402050#64 + BitVec.ofNat 64 (4 * i)) 4 (table[i].zeroExtend 64))
    (hret₁ : HasBytes m₁ (m₁.data.regs.get64 .rsp) 8 r)
    (hms₁ : bs₁.length ≤ (m₁.data.regs.get64 .rsp - m₁.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m₁.data.regs.get64 .rsi - m₁.data.regs.get64 .rsp).toNat)
    (hmt₁ : bs₁.length ≤ (0x402050#64 - m₁.data.regs.get64 .rsi).toNat ∧
      64 ≤ (m₁.data.regs.get64 .rsi - 0x402050#64).toNat)
    (hts₁ : 64 ≤ (m₁.data.regs.get64 .rsp - 0x402050#64).toNat ∧
      8 ≤ (0x402050#64 - m₁.data.regs.get64 .rsp).toNat)
    (hpc₂ : m₂.pc = 0x401000) (hn₂ : m₂.data.regs.get64 .rdx = BitVec.ofNat 64 bs₂.length)
    (hmsg₂ : ∀ (i : Nat) (hi : i < bs₂.length),
      HasBytes m₂ (m₂.data.regs.get64 .rsi + BitVec.ofNat 64 i) 1 (bs₂[i].zeroExtend 64))
    (htab₂ : ∀ (i : Nat) (hi : i < table.length),
      HasBytes m₂ (0x402050#64 + BitVec.ofNat 64 (4 * i)) 4 (table[i].zeroExtend 64))
    (hret₂ : HasBytes m₂ (m₂.data.regs.get64 .rsp) 8 r)
    (hms₂ : bs₂.length ≤ (m₂.data.regs.get64 .rsp - m₂.data.regs.get64 .rsi).toNat ∧
      8 ≤ (m₂.data.regs.get64 .rsi - m₂.data.regs.get64 .rsp).toNat)
    (hmt₂ : bs₂.length ≤ (0x402050#64 - m₂.data.regs.get64 .rsi).toNat ∧
      64 ≤ (m₂.data.regs.get64 .rsi - 0x402050#64).toNat)
    (hts₂ : 64 ≤ (m₂.data.regs.get64 .rsp - 0x402050#64).toNat ∧
      8 ≤ (0x402050#64 - m₂.data.regs.get64 .rsp).toNat)
    (esi : m₂.data.regs.get64 .rsi = m₁.data.regs.get64 .rsi)
    (edx : m₂.data.regs.get64 .rdx = m₁.data.regs.get64 .rdx)
    (esp : m₂.data.regs.get64 .rsp = m₁.data.regs.get64 .rsp)
    (hidx : crcIndices ((m₂.data.regs.get64 .rdi).truncate 32) bs₂ =
      crcIndices ((m₁.data.regs.get64 .rdi).truncate 32) bs₁) :
    ∃ tr, RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₁ [] ∧
      RunL exe (fun m' u => u = tr ∧ m'.pc.toBitVec = r) m₂ [] := by
  have h₁ := crc32_leakage m₁ bs₁ r hpc₁ hn₁ hmsg₁ htab₁ hret₁ hms₁ hmt₁ hts₁
  have h₂ := crc32_leakage m₂ bs₂ r hpc₂ hn₂ hmsg₂ htab₂ hret₂ hms₂ hmt₂ hts₂
  rw [esi, edx, esp, hidx] at h₂
  exact ⟨_, h₁, h₂⟩

end Examples.Crc32.X86
