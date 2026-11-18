#!/bin/sh
# The continuity experiment: how much does the lowered code change when the source changes a
# little? Each variant of base.c is compiled and lowered for each instruction set, and compared
# with the base, in lines of source, of disassembly, and of position-independent braid text.
# See docs/Continuity.md.
set -eu
cd "$(dirname "$0")"
CLANG=${CLANG:-/opt/homebrew/opt/llvm/bin/clang}
OBJDUMP=${OBJDUMP:-/opt/homebrew/opt/llvm/bin/llvm-objdump}
RV_LD=${RV_LD:-/opt/homebrew/opt/riscv64-elf-binutils/bin/riscv64-elf-ld}
LLD=${LLD:-$(ls "$(rustc --print sysroot)"/lib/rustlib/*/bin/rust-lld | head -1)}
LOWER=../../.lake/build/bin/braid-lower
OUT=../bin/continuity
CFLAGS="-O1 -fno-vectorize -ffreestanding -nostdlib -fno-builtin"
mkdir -p "$OUT"

# The disassembly of a binary without addresses, so that moving code costs nothing.
asm() {
  "$OBJDUMP" -d --no-show-raw-insn --no-leading-addr "$1" \
    | sed -E 's/0x[0-9a-f]+ <([^>]*)>/<\1>/; /^$/d; /file format/d; /Disassembly/d'
}

build() {
  n=$1
  # shellcheck disable=SC2086
  "$CLANG" --target=riscv64-unknown-elf -march=rv64im -mabi=lp64 $CFLAGS -c "$n.c" -o "$OUT/$n.rv.o"
  "$RV_LD" -Ttext=0x10000 --no-relax -e clamp "$OUT/$n.rv.o" -o "$OUT/$n.rv.elf"
  asm "$OUT/$n.rv.elf" > "$OUT/$n.rv.asm"
  "$LOWER" "$OUT/$n.rv.elf" --norm "$OUT/$n.rv.norm"

  # shellcheck disable=SC2086
  "$CLANG" --target=aarch64-unknown-linux-gnu -mgeneral-regs-only $CFLAGS -c "$n.c" -o "$OUT/$n.arm.o"
  "$LLD" -flavor gnu --image-base=0 -Ttext=0x10000 -e clamp "$OUT/$n.arm.o" -o "$OUT/$n.arm.elf"
  asm "$OUT/$n.arm.elf" > "$OUT/$n.arm.asm"
  "$LOWER" "$OUT/$n.arm.elf" --norm "$OUT/$n.arm.norm"

  # shellcheck disable=SC2086
  "$CLANG" --target=x86_64-unknown-linux-gnu -mgeneral-regs-only $CFLAGS -c "$n.c" -o "$OUT/$n.x86.o"
  "$LLD" -flavor gnu -Ttext=0x401000 -e clamp "$OUT/$n.x86.o" -o "$OUT/$n.x86.elf"
  asm "$OUT/$n.x86.elf" > "$OUT/$n.x86.asm"
  "$OBJDUMP" -d "$OUT/$n.x86.elf" > "$OUT/$n.x86.dis"
  "$LOWER" "$OUT/$n.x86.elf" --disasm "$OUT/$n.x86.dis" --norm "$OUT/$n.x86.norm" 2>/dev/null
}

build base
variants=""
for f in v*.c; do
  n=${f%.c}
  build "$n"
  variants="$variants $n"
done
# shellcheck disable=SC2086
python3 measure.py "$OUT" rv,arm,x86 $variants
