"""Write the machine code V8 compiles the functions of basic.js to, as an assembly file.

    python3 emit_s.py out.s js_add3 js_max

Node prints the optimised code of each function as instruction words. The words are written
back as `.word` directives under the function's name, so that an assembler and a linker make
an ELF file of them. The code is for the machine Node runs on; the examples use AArch64.
"""
import re
import subprocess
import sys


def code_of(fn):
    """The instruction words of the last optimised version of `fn`."""
    out = subprocess.run(
        ["node", "--print-opt-code", f"--print-opt-code-filter={fn}", "--no-turbo-inlining",
         "--max-inlined-bytecode-size=0", "basic.js"],
        capture_output=True, text=True, check=True).stdout
    versions = out.split("--- Optimized code ---")[1:]
    words = []
    for line in versions[-1].splitlines():
        m = re.match(r"^0x[0-9a-f]+\s+[0-9a-f]+\s+([0-9a-f]{8})\s", line)
        if m:
            words.append(m.group(1))
        elif words and line.startswith("Inlined functions"):
            break
    return words


def main(out, fns):
    with open(out, "w") as f:
        f.write("\t.text\n")
        for fn in fns:
            f.write(f"\t.globl {fn}\n\t.type {fn}, %function\n\t.p2align 2\n{fn}:\n")
            words = code_of(fn)
            for w in words:
                f.write(f"\t.word 0x{w}\n")
            f.write(f"\t.size {fn}, .-{fn}\n")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2:])
