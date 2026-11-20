/-
  Examples.Sha256Ni.X86.Proofs

  `sha256_ni.c` on x86-64: the compression function of SHA-256 written with the SHA
  instructions, proved against the specification of FIPS 180-4 in `Examples.Spec.Sha256`, the
  one the scalar code of `Examples.Sha256.X86` is proved against, and carried down to the
  machine model.

  The state of a machine at the entry of the function is written out once (`entryFlat`), with
  the three lemmas that a theorem about the machine needs of it, since the theorem of what
  the function computes and the theorem of what it reveals (`Examples.Sha256Ni.X86.Leakage`)
  start from the same state.

  ## Main definitions

  * `entryFlat`: the state at the entry, as points-to atoms

  ## Main results

  * `step_spec`, `loop_spec`, `tail_spec`: the turns of the two loops, and the first loop
  * `sha256_compress_ni_spec`: the specification, with `Sha256.compress`
  * `sha256_compress_ni_correct`: the same, about the machine alone
-/

module

public import Examples.Sha256Ni.X86.Compress
public import Examples.Sha256.X86.Machine

@[expose] public section

namespace Examples.Sha256Ni.X86

open Braid Examples Examples.Sha256 Examples.ChaCha20Vec Lowering.X86 Lowering.X86.Regs
open Examples.Sha256.X86 (HasCells Apart sat_word hasCells_of_holds)

/-! ## The state at the entry -/

/-- The program counter, the registers and the flags of a machine at the entry of
`sha256_compress_ni`, as atoms: those the code reads or writes. -/
def entryRegs (m : MachineState) : Atoms :=
  [.pc 0x401000#64, .reg rdi (m.data.regs.get64 .rdi), .reg rsi (m.data.regs.get64 .rsi),
    .reg rax (m.data.regs.get64 .rax), .reg rcx (m.data.regs.get64 .rcx),
    .reg rsp (m.data.regs.get64 .rsp),
    .reg (zmm 0 0) (regOf m.data (zmm 0 0)), .reg (zmm 0 1) (regOf m.data (zmm 0 1)),
    .reg (zmm 1 0) (regOf m.data (zmm 1 0)), .reg (zmm 1 1) (regOf m.data (zmm 1 1)),
    .reg (zmm 2 0) (regOf m.data (zmm 2 0)), .reg (zmm 2 1) (regOf m.data (zmm 2 1)),
    .reg (zmm 3 0) (regOf m.data (zmm 3 0)), .reg (zmm 3 1) (regOf m.data (zmm 3 1)),
    .reg (zmm 4 0) (regOf m.data (zmm 4 0)), .reg (zmm 4 1) (regOf m.data (zmm 4 1)),
    .reg (zmm 5 0) (regOf m.data (zmm 5 0)), .reg (zmm 5 1) (regOf m.data (zmm 5 1)),
    .reg (zmm 6 0) (regOf m.data (zmm 6 0)), .reg (zmm 6 1) (regOf m.data (zmm 6 1)),
    .reg (zmm 7 0) (regOf m.data (zmm 7 0)), .reg (zmm 7 1) (regOf m.data (zmm 7 1)),
    .reg (zmm 8 0) (regOf m.data (zmm 8 0)), .reg (zmm 8 1) (regOf m.data (zmm 8 1)),
    .reg (zmm 9 0) (regOf m.data (zmm 9 0)), .reg (zmm 9 1) (regOf m.data (zmm 9 1)),
    .flag Flags.cf m.data.status.cf, .flag Flags.pf m.data.status.pf,
    .flag Flags.af m.data.status.af, .flag Flags.zf m.data.status.zf,
    .flag Flags.sf m.data.status.sf, .flag Flags.of m.data.status.of]

/-- The state of a machine at the entry of `sha256_compress_ni`, as points-to atoms: its
registers and flags, and in memory the hash value `H` where `rdi` points, the block `M` where
`rsi` points, the round constants at `0x402110`, and the return address `r` at the stack
pointer. -/
def entryFlat (m : MachineState) (H M : List W32) (r : Word) : Atoms :=
  entryRegs m ++
    (cellsAtoms 4 true (m.data.regs.get64 .rdi) (w32s H) ++
    (cellsAtoms 4 true (m.data.regs.get64 .rsi) (w32s M) ++
    (cellsAtoms 4 true 0x402110#64 (w32s K) ++
    (cellsAtoms 8 true (m.data.regs.get64 .rsp) [r] ++ []))))

theorem entryFlat_pointsTo (m : MachineState) (H M : List W32) (r : Word) :
    ∀ a ∈ entryFlat m H M r, a.IsPointsTo :=
  List.forall_mem_append.2 ⟨by simp [entryRegs, Atom.IsPointsTo],
    List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
    List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
    List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo,
    List.forall_mem_append.2 ⟨cellsAtoms_isPointsTo, by simp⟩⟩⟩⟩⟩

/-- The atoms of the state at the entry are pairwise disjoint, when the hash value, the
block, the round constants and the return address are pairwise apart. -/
theorem entryFlat_disj (m : MachineState) (H M : List W32) (r : Word) (hH : H.length = 8)
    (hM : M.length = 16)
    (hhm : Apart (m.data.regs.get64 .rdi) 32 (m.data.regs.get64 .rsi) 64)
    (hhk : Apart (m.data.regs.get64 .rdi) 32 0x402110#64 256)
    (hhs : Apart (m.data.regs.get64 .rdi) 32 (m.data.regs.get64 .rsp) 8)
    (hmk : Apart (m.data.regs.get64 .rsi) 64 0x402110#64 256)
    (hms : Apart (m.data.regs.get64 .rsi) 64 (m.data.regs.get64 .rsp) 8)
    (hks : Apart 0x402110#64 256 (m.data.regs.get64 .rsp) 8) :
    (entryFlat m H M r).Pairwise Atom.Disj := by
  have hlK : K.length = 64 := rfl
  exact pairwise_regs_mems (by unfold entryRegs; sha256_disj) (by simp [entryRegs, NotMem])
    (List.forall_mem_append.2 ⟨isMem_cellsAtoms,
      List.forall_mem_append.2 ⟨isMem_cellsAtoms,
      List.forall_mem_append.2 ⟨isMem_cellsAtoms,
      List.forall_mem_append.2 ⟨isMem_cellsAtoms, by simp⟩⟩⟩⟩)
    (List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hH]),
      List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hM]),
      List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp [hlK]),
      List.pairwise_append.2 ⟨cellsAtoms_pairwise (by simp), .nil, disj_nil_right⟩,
      -- the round constants, and the return address
      disj_append_right (cellsAtoms_disj_of_apart hks.1 hks.2 (by simp [hlK]) (by simp)
          (by simp [hlK]) (by simp))
        disj_nil_right⟩,
      -- the block, and what follows it
      disj_append_right (cellsAtoms_disj_of_apart hmk.1 hmk.2 (by simp [hM]) (by simp [hlK])
          (by simp [hM]) (by simp [hlK]))
        (disj_append_right (cellsAtoms_disj_of_apart hms.1 hms.2 (by simp [hM]) (by simp)
          (by simp [hM]) (by simp))
        disj_nil_right)⟩,
      -- the hash value, and what follows it
      disj_append_right (cellsAtoms_disj (by rw [w32s_length, hH]; exact hhm.1)
          (by rw [w32s_length, hM]; exact hhm.2))
        (disj_append_right (cellsAtoms_disj_of_apart hhk.1 hhk.2 (by simp [hH]) (by simp [hlK])
          (by simp [hH]) (by simp [hlK]))
        (disj_append_right (cellsAtoms_disj_of_apart hhs.1 hhs.2 (by simp [hH]) (by simp)
          (by simp [hH]) (by simp))
        disj_nil_right))⟩)

/-- The atoms of the state at the entry are true of a machine that is there and has the
four arrays. -/
theorem entryFlat_sat (m : MachineState) (H M : List W32) (r : Word) (hpc : m.pc = 0x401000)
    (hh : HasCells m (m.data.regs.get64 .rdi) H) (hm : HasCells m (m.data.regs.get64 .rsi) M)
    (hk : HasCells m 0x402110#64 K) (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r) :
    ∀ a ∈ entryFlat m H M r, a.sat (abs m) :=
  List.forall_mem_append.2
    ⟨by simp [entryRegs, Atom.sat_reg, Atom.sat_pc, Atom.sat_flag, regOf, flagOf, hpc],
      List.forall_mem_append.2 ⟨hh.sat,
      List.forall_mem_append.2 ⟨hm.sat,
      List.forall_mem_append.2 ⟨hk.sat,
      List.forall_mem_append.2 ⟨sat_word hret, by simp⟩⟩⟩⟩⟩

/-! ## On the machine -/

/-- **`sha256_compress_ni` on the machine.** A machine of the model that runs the executable
of this image reaches the return address `r` on every run, with the compression of `H` with
`M` where `rdi` pointed, the block as it was, and the stack pointer above the return
address. The hypotheses ask that

* `hpc`: the machine is at the entry of `sha256_compress_ni`;
* `hH`, `hh`: `H` is eight 32-bit words, and they are in memory from where `rdi` points,
  four bytes each, least significant byte first;
* `hM`, `hm`: `M` is sixteen 32-bit words, in memory in the same way from where `rsi`
  points;
* `hk`: the 64 round constants of SHA-256 are in memory from `0x402110`, in the same way.
  That is where the linker put the table `K` of `sha256_ni.c`, and its 256 bytes there are
  these words (`Examples/bin/sha256_ni.x86.dis`), so a machine that has the data of the
  binary loaded satisfies it;
* `hret`: the return address `r` is in the eight bytes at the stack pointer;
* `hhm`, `hhk`, `hhs`, `hmk`, `hms`, `hks`: the 32 bytes of the hash value, the 64 of the
  block, the 256 of the table and the eight of the return address are pairwise apart. The
  model's memory has no permissions, so that the table is not written is a hypothesis of
  this form and not a fact about read-only data.

The code needs no stack below the return address, and no alignment of the hash value or the
block: it loads and stores them with `movdqu`. It reads the table with `movdqa` and with
`paddd` from memory, which fault on an address that is not a multiple of sixteen; the model
checks this and the lowering keeps the check as a `guard`. The table is at `0x402110` and is
read at offsets that are multiples of sixteen, so the check is met and is not a
hypothesis. -/
theorem sha256_compress_ni_correct [Layout] (m : MachineState) (H M : List W32) (r : Word)
    (hpc : m.pc = 0x401000) (hH : H.length = 8) (hM : M.length = 16)
    (hh : HasCells m (m.data.regs.get64 .rdi) H) (hm : HasCells m (m.data.regs.get64 .rsi) M)
    (hk : HasCells m 0x402110#64 K) (hret : HasBytes m (m.data.regs.get64 .rsp) 8 r)
    (hhm : Apart (m.data.regs.get64 .rdi) 32 (m.data.regs.get64 .rsi) 64)
    (hhk : Apart (m.data.regs.get64 .rdi) 32 0x402110#64 256)
    (hhs : Apart (m.data.regs.get64 .rdi) 32 (m.data.regs.get64 .rsp) 8)
    (hmk : Apart (m.data.regs.get64 .rsi) 64 0x402110#64 256)
    (hms : Apart (m.data.regs.get64 .rsi) 64 (m.data.regs.get64 .rsp) 8)
    (hks : Apart 0x402110#64 256 (m.data.regs.get64 .rsp) 8) :
    Eventually (step1 exe)
      (fun m' => m'.pc.toBitVec = r ∧
        HasCells m' (m.data.regs.get64 .rdi) (compress H M) ∧
        HasCells m' (m.data.regs.get64 .rsi) M ∧
        m'.data.regs.get64 .rsp = (m.data.regs.get64 .rsp) + 8#64) m := by
  refine eventually_weaken _ _ _ _ ?_ (machine_sound_flat sha256_compress_ni_holds
    (sha256_compress_ni_spec (m.data.regs.get64 .rdi) (m.data.regs.get64 .rsi)
      (m.data.regs.get64 .rsp) r H M true true (m.data.regs.get64 .rax)
      (m.data.regs.get64 .rcx)
      (regOf m.data (zmm 0 0)) (regOf m.data (zmm 0 1)) (regOf m.data (zmm 1 0))
      (regOf m.data (zmm 1 1)) (regOf m.data (zmm 2 0)) (regOf m.data (zmm 2 1))
      (regOf m.data (zmm 3 0)) (regOf m.data (zmm 3 1)) (regOf m.data (zmm 4 0))
      (regOf m.data (zmm 4 1)) (regOf m.data (zmm 5 0)) (regOf m.data (zmm 5 1))
      (regOf m.data (zmm 6 0)) (regOf m.data (zmm 6 1)) (regOf m.data (zmm 7 0))
      (regOf m.data (zmm 7 1)) (regOf m.data (zmm 8 0)) (regOf m.data (zmm 8 1))
      (regOf m.data (zmm 9 0)) (regOf m.data (zmm 9 1))
      m.data.status.cf m.data.status.pf m.data.status.af m.data.status.zf m.data.status.sf
      m.data.status.of hH hM)
    (flat := entryFlat m H M r)
    (Flat.interp (by unfold entryFlat entryRegs; braid_flat))
    (entryFlat_pointsTo m H M r) (entryFlat_disj m H M r hH hM hhm hhk hhs hmk hms hks)
    (entryFlat_sat m H M r hpc hh hm hk hret))
  rintro m' ⟨σ', hr, hq⟩
  refine ⟨?_, hasCells_of_holds hr hq (by braid_at), hasCells_of_holds hr hq (by braid_at), ?_⟩
  · rw [← hr.pc]; exact Atoms.pc_of_holds hq (by braid_at)
  · rw [← hr.reg .rsp]; exact Atoms.reg_of_holds (r := 6) hq (by braid_at)

end Examples.Sha256Ni.X86
