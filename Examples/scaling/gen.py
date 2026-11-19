#!/usr/bin/env python3
"""Generate a straight-line program of N instructions, and the Lean proof that runs it.

    gen.py asm  <isa> <n>            print the assembly of the program
    gen.py lean <isa> <n> <image>    print a Lean file: the image, then the benchmark theorem

The program is a function `bench` that mixes additions, exclusive ors, rotations and moves
over eight registers, and returns. The instructions are chosen by a fixed pseudo-random
sequence, so the same N gives the same program. `isa` is `arm` or `x86`.

The theorem says the code runs to its return from an arbitrary state of those registers;
proving it is one symbolic execution of the whole function. With TRACED=1 in the environment
the theorem is a traced triple, and the proof also builds the trace. See docs/Scaling.md.
"""
import os
import sys

ARM_REGS = [f"x{i}" for i in range(8)]
X86_REGS = ["rax", "rbx", "rcx", "rdx", "rsi", "rdi", "r8", "r9"]


def choices(n):
    """A fixed sequence of (operation, destination, source, amount) for n instructions."""
    x = 12345
    out = []
    for _ in range(n):
        x = (x * 1103515245 + 12345) % (1 << 31)
        op = (x >> 4) % 5
        d = (x >> 8) % 8
        s = (x >> 12) % 8
        k = 1 + (x >> 16) % 31
        out.append((op, d, s if s != d else (d + 1) % 8, k))
    return out


def asm(isa, n):
    kind = "%function" if isa == "arm" else "@function"
    lines = ["\t.text", "\t.globl bench", f"\t.type bench, {kind}", "bench:"]
    for op, d, s, k in choices(n):
        if isa == "arm":
            a, b = ARM_REGS[d], ARM_REGS[s]
            lines.append("\t" + [f"add {a}, {a}, {b}", f"eor {a}, {a}, {b}", f"ror {a}, {a}, #{k}",
                                 f"and {a}, {a}, {b}", f"sub {a}, {a}, {b}"][op])
        else:
            a, b = X86_REGS[d], X86_REGS[s]
            lines.append("\t" + [f"addq %{b}, %{a}", f"xorq %{b}, %{a}", f"rolq ${k}, %{a}",
                                 f"andq %{b}, %{a}", f"subq %{b}, %{a}"][op])
    lines.append("\tret")
    lines.append("\t.size bench, .-bench")
    return "\n".join(lines) + "\n"


def theorem(isa, tactic, traced=False):
    """The benchmark theorem; with `traced`, a traced triple, whose proof also builds the trace."""
    vs = " ".join(f"v{i}" for i in range(8))
    if traced:
        end = "[.jump r]" if isa == "arm" else "[.read s 8, .jump r]"
        return (theorem(isa, tactic)
                .replace("Triple bench.program", "TripleT bench.program")
                .replace(" r : Word)", " r : Word) (t : Trace)")
                .replace("lr r]) iprop(True)", f"lr r]) t iprop(True) (t ++ {end})")
                .replace(")\n      iprop(True)", f") t\n      iprop(True) (t ++ {end})")
                .replace("  show Triple _ (Atoms.interp (.pc r :: _)) _\n"
                         "  exact Triple.done fun _ _ => trivial",
                         "  show TripleT _ (Atoms.interp (.pc r :: _)) _ _ _\n"
                         "  exact TripleT.done (fun _ _ => trivial) (by braid_trace)"))
    if isa == "arm":
        regs = ", ".join(f".reg {r} v{i}" for i, r in enumerate(ARM_REGS))
        return f"""
open Braid Iris.BI Lowering.Arm Lowering.Arm.Regs in
set_option maxHeartbeats 0 in
set_option maxRecDepth 100000 in
/-- The benchmark: one symbolic execution of `bench`, to its return. -/
theorem bench_run ({vs} r : Word) :
    Triple bench.program
      (Atoms.interp [.pc 0x10000#64, {regs}, .reg lr r]) iprop(True) := by
  {tactic}
  show Triple _ (Atoms.interp (.pc r :: _)) _
  exact Triple.done fun _ _ => trivial
"""
    regs = ", ".join(f".reg {r} v{i}" for i, r in enumerate(X86_REGS))
    flags = ", ".join(f".flag Flags.{f} b{i}" for i, f in enumerate(["cf", "pf", "af", "zf", "sf", "of"]))
    return f"""
open Braid Iris.BI Lowering.X86 Lowering.X86.Regs in
set_option maxHeartbeats 0 in
set_option maxRecDepth 100000 in
/-- The benchmark: one symbolic execution of `bench`, to its return. -/
theorem bench_run ({vs} s r : Word) (b0 b1 b2 b3 b4 b5 : Bool) :
    Triple bench.program
      (Atoms.interp [.pc 0x401000#64, {regs}, .reg rsp s, .mem s 8 r true, {flags}])
      iprop(True) := by
  {tactic}
  show Triple _ (Atoms.interp (.pc r :: _)) _
  exact Triple.done fun _ _ => trivial
"""


def lean(isa, image, tactic, traced=False):
    text = open(image).read().rstrip("\n").split("\n")
    assert text[-1].startswith("end "), text[-1]
    return "\n".join(text[:-1]) + theorem(isa, tactic, traced) + "\n" + text[-1] + "\n"


if __name__ == "__main__":
    if sys.argv[1] == "asm":
        sys.stdout.write(asm(sys.argv[2], int(sys.argv[3])))
    else:
        tactic = sys.argv[5] if len(sys.argv) > 5 else "braid_run"
        sys.stdout.write(lean(sys.argv[2], sys.argv[4], tactic, os.environ.get("TRACED") == "1"))
