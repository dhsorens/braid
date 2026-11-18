#!/usr/bin/env python3
"""Compare each variant of base.c with the base, function by function.

For every variant this prints how many lines differ in the source, in the disassembly and in
the position-independent braid text. Functions are matched by name, so moving a function
costs nothing, and a new function counts in full. Run by run.sh.
"""
import difflib
import re
import sys


def functions(path, header):
    """The text of a file, split into its functions: name -> lines."""
    out, name = {}, None
    for line in open(path).read().splitlines():
        m = re.match(header, line)
        if m:
            name = m.group(1)
            out[name] = []
        elif name is not None:
            out[name].append(line)
    return out


def changed(a, b):
    """Lines of `a` and of `b` that a line diff reports as removed or added."""
    return sum(1 for d in difflib.ndiff(a, b) if d[:2] in ("- ", "+ "))


def by_function(base, variant, header):
    fa, fb = functions(base, header), functions(variant, header)
    return sum(changed(fa.get(n, []), fb.get(n, [])) for n in sorted(set(fa) | set(fb)))


def main(out, arches, variants):
    lines = lambda p: open(p).read().splitlines()
    head = ["variant", "source"] + [f"{a} asm" for a in arches] + [f"{a} braid" for a in arches]
    rows = []
    sizes = [len(lines("base.c"))]
    sizes += [len(lines(f"{out}/base.{a}.asm")) for a in arches]
    sizes += [len(lines(f"{out}/base.{a}.norm")) for a in arches]
    rows.append(["(size of base)"] + [str(s) for s in sizes])
    for v in variants:
        row = [v, str(changed(lines("base.c"), lines(f"{v}.c")))]
        row += [str(by_function(f"{out}/base.{a}.asm", f"{out}/{v}.{a}.asm", r"^<(.*)>:$"))
                for a in arches]
        row += [str(by_function(f"{out}/base.{a}.norm", f"{out}/{v}.{a}.norm", r"^func (.*)$"))
                for a in arches]
        rows.append(row)
    widths = [max(len(r[i]) for r in [head] + rows) for i in range(len(head))]
    fmt = lambda r: "| " + " | ".join(c.ljust(w) for c, w in zip(r, widths)) + " |"
    print(fmt(head))
    print("|" + "|".join("-" * (w + 2) for w in widths) + "|")
    for r in rows:
        print(fmt(r))


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2].split(","), sys.argv[3:])
