"""Write the LLVM IR Numba compiles the functions of basic.py to.

    python emit_ll.py out.ll

Each function keeps Numba's calling convention: the result goes through a pointer in the
first argument, and the function returns a status, zero for success. Its mangled name is
replaced by the plain name in `FUNCTIONS`, so that the decompiler can be asked for it.
"""
import re
import sys

import basic


def main(out):
    chunks = []
    for name, fn in basic.FUNCTIONS.items():
        (sig,) = fn.signatures
        ir = fn.inspect_llvm(sig)
        # The compiled function is the one definition that is not a Python wrapper.
        m = re.search(r'define [^@]*@"?(_ZN[^"(]*)"?\(', ir)
        mangled = m.group(1)
        body = re.search(
            r'(define [^\n]*@"?' + re.escape(mangled) + r'"?\(.*?\n}\n)', ir, re.S
        ).group(1)
        body = body.replace('"' + mangled + '"', name).replace(mangled, name)
        # Attribute groups and symbol visibility belong to Numba's module, not to the function.
        body = re.sub(r" local_unnamed_addr| #\d+", "", body)
        chunks.append(body)
    intrinsics = sorted(set(re.findall(r"@(llvm\.[a-z0-9.]+)\(", "\n".join(chunks))))
    decls = [f"declare i64 @{i}(i64, i64)" for i in intrinsics]
    with open(out, "w") as f:
        f.write("\n".join(chunks + decls) + "\n")


if __name__ == "__main__":
    main(sys.argv[1])
