#!/usr/bin/env python3
"""Measure how much of a proof survives a recompile: for each function of chacha20.c and
sha256.c, compare the proof at -O1 with the proof at -O2 line by line, and time both.

  Examples/continuity/recompile.py [--time] [rv|x86|arm]...

For each pair of files it prints the lines of proof at each level (without the module header
and blank lines) and, of the lines at -O2,
  same     lines that are in the -O1 proof word for word
  renamed  lines that differ from one of the -O1 proof only in a register, a number or an
           address
  changed  other lines that replace lines of the -O1 proof
  new      lines with no counterpart
and, of the lines at -O1 that are not in the -O2 file,
  imported lines the -O2 proof uses by importing the -O1 module
  dropped  lines it has no use for.
With --time it also checks each file with `lake env lean` and prints the processor time
(user and system), in seconds. Run it from the root of the repository.
"""
import difflib, os, re, resource, subprocess, sys

ISA = {"rv": "RiscV", "x86": "X86", "arm": "Arm"}
# function, module, files of the proof
FUNCS = [
    ("quarter_round", "ChaCha20", ["QuarterRound"]),
    ("chacha20_block", "ChaCha20", ["Round", "Block"]),
    ("sha256_round", "Sha256", ["Round"]),
    ("sha256_schedule", "Sha256", ["Schedule"]),
    ("sha256_compress", "Sha256", ["Compress"]),
]


def code(path):
    """The lines of a file, without its header comment and blank lines."""
    text = open(path).read()
    if text.startswith("/-"):
        text = text[text.index("-/") + 2:]
    return [l.rstrip() for l in text.split("\n") if l.strip()]


def shape(line):
    """A line with its registers, numbers and addresses blanked."""
    line = re.sub(r"0x[0-9a-fA-F]+", "N", line)
    line = re.sub(r"\b([astxyuvwr]\d+|r[a-ds][xpi]|e[a-ds][xpi]|[xw]\d+|sp|ra|fp|lr)\b", "R", line)
    return re.sub(r"\d+", "N", line)


def compare(o1, o2):
    a, b = code(o1), code(o2)
    same = renamed = changed = new = gone = 0
    for op, i1, i2, j1, j2 in difflib.SequenceMatcher(None, a, b, autojunk=False).get_opcodes():
        if op == "equal":
            same += j2 - j1
        elif op == "insert":
            new += j2 - j1
        elif op == "delete":
            gone += i2 - i1
        else:
            old = [shape(l) for l in a[i1:i2]]
            for l in b[j1:j2]:
                if shape(l) in old:
                    old.remove(shape(l))
                    renamed += 1
                elif old:
                    old.pop()
                    changed += 1
                else:
                    new += 1
            gone += len(old)
    imports = "import " + os.path.splitext(o1)[0].replace("/", ".") + "\n" in open(o2).read()
    return len(a), len(b), same, renamed, changed, new, gone if imports else 0, 0 if imports else gone


def seconds(path):
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    subprocess.run(["lake", "env", "lean", path], check=True, stdout=subprocess.DEVNULL)
    after = resource.getrusage(resource.RUSAGE_CHILDREN)
    return (after.ru_utime - before.ru_utime) + (after.ru_stime - before.ru_stime)


def main():
    args = sys.argv[1:]
    timed = "--time" in args
    isas = [a for a in args if a in ISA] or list(ISA)
    head = "| ISA | function | file | -O1 | -O2 | same | renamed | changed | new | imported | dropped |"
    if timed:
        head += " -O1 s | -O2 s |"
    print(head)
    print("|" + " --- |" * head.count("|"))
    for isa in isas:
        for fn, module, files in FUNCS:
            for f in files:
                o1 = f"Examples/{module}/{ISA[isa]}/{f}.lean"
                o2 = f"Examples/{module}/O2/{ISA[isa]}/{f}.lean"
                if not os.path.exists(o2):
                    continue
                row = f"| {ISA[isa]} | `{fn}` | `{f}.lean` | " + " | ".join(map(str, compare(o1, o2))) + " |"
                if timed:
                    row += f" {seconds(o1):.1f} | {seconds(o2):.1f} |"
                print(row)


if __name__ == "__main__":
    main()
