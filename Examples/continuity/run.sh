#!/bin/sh
# The continuity experiment: how much does the lowered code change when the source changes a
# little? Each variant of base.c is compiled and lowered, and compared with the base, in lines
# of source, of disassembly, and of position-independent braid text. See docs/Continuity.md.
set -eu
cd "$(dirname "$0")"
CLANG=${CLANG:-/opt/homebrew/opt/llvm/bin/clang}
OBJDUMP=${OBJDUMP:-/opt/homebrew/opt/llvm/bin/llvm-objdump}
RV_LD=${RV_LD:-/opt/homebrew/opt/riscv64-elf-binutils/bin/riscv64-elf-ld}
LOWER=../../.lake/build/bin/braid-lower
OUT=../bin/continuity
mkdir -p "$OUT"

build() {
  n=$1
  "$CLANG" --target=riscv64-unknown-elf -march=rv64im -mabi=lp64 -O1 -fno-vectorize \
    -ffreestanding -nostdlib -fno-builtin -c "$n.c" -o "$OUT/$n.rv.o"
  "$RV_LD" -Ttext=0x10000 --no-relax -e clamp "$OUT/$n.rv.o" -o "$OUT/$n.rv.elf"
  "$OBJDUMP" -d --no-show-raw-insn --no-leading-addr "$OUT/$n.rv.elf" \
    | sed -E 's/0x[0-9a-f]+ <([^>]*)>/<\1>/; /^$/d; /file format/d; /Disassembly/d' > "$OUT/$n.rv.asm"
  "$LOWER" "$OUT/$n.rv.elf" --norm "$OUT/$n.rv.norm"
}

build base
variants=""
for f in v*.c; do
  n=${f%.c}
  build "$n"
  variants="$variants $n"
done
# shellcheck disable=SC2086
python3 measure.py "$OUT" rv $variants
