#!/bin/sh
# The scaling benchmark: how long does symbolic execution of a straight-line function of N
# instructions take? For each instruction set and each N this assembles a generated program,
# lowers it, and times Lean checking one symbolic execution of it. See docs/Scaling.md.
#
#   Examples/scaling/run.sh                 N = 10 100 1000, both instruction sets
#   Examples/scaling/run.sh "10 100"        other sizes
#   TACTIC=braid_run Examples/scaling/run.sh   the tactic that runs the function
#
# Prints one line for each run: instruction set, N, seconds for the image alone, seconds for
# the image with the proof, and the difference per instruction in milliseconds.
set -eu
cd "$(dirname "$0")/../.."

CLANG=${CLANG:-/opt/homebrew/opt/llvm/bin/clang}
OBJDUMP=${OBJDUMP:-/opt/homebrew/opt/llvm/bin/llvm-objdump}
LLD=${LLD:-$(ls "$(rustc --print sysroot)"/lib/rustlib/*/bin/rust-lld | head -1)}
LOWER=.lake/build/bin/braid-lower
SIZES=${1:-"10 100 1000"}
ISAS=${ISAS:-"arm x86"}
TACTIC=${TACTIC:-braid_run}
OUT=Examples/bin/scaling
mkdir -p "$OUT"

seconds() { # run a command, print the wall-clock seconds it took
  start=$(python3 -c 'import time; print(time.time())')
  "$@" > "$OUT/last.log" 2>&1 || { cat "$OUT/last.log" | head -20 >&2; echo "FAILED" >&2; }
  python3 -c "import time,sys; print(f'{time.time()-float(sys.argv[1]):.1f}')" "$start"
}

printf '%-5s %6s %10s %10s %12s\n' isa N image_s proof_s ms_per_instr
for isa in $ISAS; do
  for n in $SIZES; do
    b=$OUT/bench_${isa}_$n
    python3 Examples/scaling/gen.py asm "$isa" "$n" > "$b.s"
    case $isa in
      arm)
        "$CLANG" --target=aarch64-unknown-linux-gnu -c "$b.s" -o "$b.o"
        "$LLD" -flavor gnu --image-base=0 -Ttext=0x10000 -e bench "$b.o" -o "$b.elf"
        "$LOWER" "$b.elf" --fn bench --lean "$b.image.lean" --module Bench ;;
      x86)
        "$CLANG" --target=x86_64-unknown-linux-gnu -c "$b.s" -o "$b.o"
        "$LLD" -flavor gnu -Ttext=0x401000 -e bench "$b.o" -o "$b.elf"
        "$OBJDUMP" -d "$b.elf" > "$b.dis"
        "$LOWER" "$b.elf" --disasm "$b.dis" --fn bench --lean "$b.image.lean" --module Bench ;;
    esac
    python3 Examples/scaling/gen.py lean "$isa" "$n" "$b.image.lean" "$TACTIC" > "$b.lean"
    ti=$(seconds lake env lean "$b.image.lean")
    tp=$(seconds lake env lean "$b.lean")
    python3 -c "import sys; i,p,n=float(sys.argv[1]),float(sys.argv[2]),int(sys.argv[3]); print(f'{sys.argv[4]:<5} {n:>6} {i:>10.1f} {p:>10.1f} {1000*(p-i)/n:>12.1f}')" "$ti" "$tp" "$n" "$isa"
  done
done
