#!/bin/sh
# Compile the example sources for each instruction set and lower them with `braid-lower`.
#
#   Examples/build.sh            every example
#   Examples/build.sh basic      one example
#
# Needs clang with the RISC-V target and a RISC-V linker (see Examples/README.md).
set -eu
cd "$(dirname "$0")/.."

CLANG=${CLANG:-/opt/homebrew/opt/llvm/bin/clang}
RV_LD=${RV_LD:-/opt/homebrew/opt/riscv64-elf-binutils/bin/riscv64-elf-ld}
LOWER=.lake/build/bin/braid-lower
CFLAGS="-O1 -fno-vectorize -ffreestanding -nostdlib -fno-builtin"

mkdir -p Examples/bin Examples/mlir

# name, source, module, functions
lower_c() {
  name=$1; src=$2; module=$3; shift 3
  fns=""; for f in "$@"; do fns="$fns --fn $f"; done
  dir=Examples/$(echo "$module" | tr . /)
  mkdir -p "$dir/RiscV"
  "$CLANG" --target=riscv64-unknown-elf -march=rv64im -mabi=lp64 $CFLAGS -c "$src" \
    -o "Examples/bin/$name.rv.o"
  "$RV_LD" -Ttext=0x10000 --no-relax -e "$1" "Examples/bin/$name.rv.o" -o "Examples/bin/$name.rv.elf"
  # shellcheck disable=SC2086
  "$LOWER" "Examples/bin/$name.rv.elf" $fns --mlir "Examples/mlir/$name.rv.mlir" \
    --lean "$dir/RiscV/Image.lean" --module "Examples.$module.RiscV"
}

want() { [ $# -eq 0 ] || [ "$1" = "$2" ]; }

if [ $# -eq 0 ] || [ "$1" = basic ]; then
  lower_c basic Examples/src/c/basic.c Basic add3 max_u64 sum_to
fi
if [ $# -eq 0 ] || [ "$1" = memory ]; then
  lower_c memory Examples/src/c/memory.c Memory swap sum_array max2 max3
fi
