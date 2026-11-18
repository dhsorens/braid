"""The first Python examples, compiled to native code by Numba.

Numba compiles a Python function with typed arguments through LLVM. `emit_ll.py` writes the
LLVM IR of each function here, and `Examples/build.sh` compiles it for each instruction set.
"""
from numba import njit, uint64


@njit(uint64(uint64, uint64, uint64), nogil=True)
def add3(a, b, c):
    return a + b + c


@njit(uint64(uint64, uint64), nogil=True)
def max_u64(a, b):
    return a if a > b else b


@njit(uint64(uint64, uint64), nogil=True)
def gcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a


FUNCTIONS = {"py_add3": add3, "py_max_u64": max_u64, "py_gcd": gcd}
