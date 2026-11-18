"""Write the machine code V8 compiles the functions of basic.js to, as an assembly file.

    python3 emit_s.py out.s js_add3 js_max

Node prints the optimised code of each function with the bytes of each instruction. They are
written back as data directives under the function's name, so that an assembler and a linker
make an ELF file of them. The code is for the machine Node runs on: `NODE` names the Node to
run (an x86-64 build runs under Rosetta on an Apple machine), and `JS_ARCH=x64` says its
instructions are byte strings and not 32-bit words.
"""
import os
import re
import subprocess
import sys


def code_of(fn):
    """The instruction words of the last optimised version of `fn`."""
    out = subprocess.run(
        [os.environ.get("NODE", "node"), "--print-opt-code", f"--print-opt-code-filter={fn}", "--no-turbo-inlining",
         "--max-inlined-bytecode-size=0", "basic.js"],
        capture_output=True, text=True, check=True).stdout
    versions = out.split("--- Optimized code ---")[1:]
    words = []
    for line in versions[-1].splitlines():
        m = re.match(r"^0x[0-9a-f]+\s+[0-9a-f]+\s+([0-9a-f]+)\s", line)
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
                if os.environ.get("JS_ARCH") == "x64":
                    f.write("\t.byte " + ", ".join(f"0x{w[i:i + 2]}" for i in range(0, len(w), 2)) + "\n")
                else:
                    f.write(f"\t.word 0x{w}\n")
            f.write(f"\t.size {fn}, .-{fn}\n")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2:])
