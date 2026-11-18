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

# Link a RISC-V object and lower it: name, module, functions.
lower_rv() {
  name=$1; module=$2; shift 2
  fns=""; for f in "$@"; do fns="$fns --fn $f"; done
  dir=Examples/$(echo "$module" | tr . /)
  mkdir -p "$dir/RiscV"
  "$RV_LD" -Ttext=0x10000 --no-relax -e "$1" "Examples/bin/$name.rv.o" -o "Examples/bin/$name.rv.elf"
  # shellcheck disable=SC2086
  "$LOWER" "Examples/bin/$name.rv.elf" $fns --mlir "Examples/mlir/$name.rv.mlir" \
    --lean "$dir/RiscV/Image.lean" --module "Examples.$module.RiscV"
}

# A C source: name, source, module, functions.
lower_c() {
  name=$1; src=$2; module=$3; shift 3
  "$CLANG" --target=riscv64-unknown-elf -march=rv64im -mabi=lp64 $CFLAGS -c "$src" \
    -o "Examples/bin/$name.rv.o"
  lower_rv "$name" "$module" "$@"
}

# A Rust source: name, source, module, functions. Rust goes through LLVM IR, so that one
# compiler back end (clang's) produces the code for every instruction set.
lower_rust() {
  name=$1; src=$2; module=$3; shift 3
  rustc --edition 2021 --target riscv64imac-unknown-none-elf -C opt-level=1 -C panic=abort \
    --crate-type=staticlib --emit=llvm-ir -o "Examples/bin/$name.ll" "$src" 2>/dev/null
  sed -E 's/"target-features"="[^"]*"/"target-features"="+m"/; s/"target-cpu"="[^"]*"//' \
    "Examples/bin/$name.ll" > "Examples/bin/$name.rv.ll"
  "$CLANG" --target=riscv64-unknown-elf -march=rv64im -mabi=lp64 -O1 -Wno-override-module \
    -c "Examples/bin/$name.rv.ll" -o "Examples/bin/$name.rv.o"
  lower_rv "$name" "$module" "$@"
}

# A Swift source: name, source, module, functions. As for Rust, through LLVM IR. The Swift
# calling convention and Apple's linker metadata are removed: the exported functions use the
# C convention.
lower_swift() {
  name=$1; src=$2; module=$3; shift 3
  swiftc -O -parse-as-library -emit-ir "$src" -o "Examples/bin/$name.ll" 2>/dev/null
  sed -E 's/"target-features"="[^"]*"/"target-features"="+m"/g; s/"target-cpu"="[^"]*"//g;
          /^target datalayout/d; /^target triple/d; s/"probe-stack"="[^"]*"//g;
          s/"frame-pointer"="[^"]*"//g; s/ swiftcc / /g; /^!llvm.linker.options/d;
          s/, section "[^"]*"//g' "Examples/bin/$name.ll" > "Examples/bin/$name.rv.ll"
  "$CLANG" --target=riscv64-unknown-elf -march=rv64im -mabi=lp64 -O1 -Wno-override-module \
    -c "Examples/bin/$name.rv.ll" -o "Examples/bin/$name.rv.o"
  lower_rv "$name" "$module" "$@"
}

if [ $# -eq 0 ] || [ "$1" = basic ]; then
  lower_c basic Examples/src/c/basic.c Basic add3 max_u64 sum_to
fi
if [ $# -eq 0 ] || [ "$1" = memory ]; then
  lower_c memory Examples/src/c/memory.c Memory swap sum_array max2 max3
fi
if [ $# -eq 0 ] || [ "$1" = rustbasic ]; then
  lower_rust rustbasic Examples/src/rust/basic.rs RustBasic add3 max_u64 gcd sum_slice
fi
if [ $# -eq 0 ] || [ "$1" = swiftbasic ]; then
  lower_swift swiftbasic Examples/src/swift/basic.swift SwiftBasic swift_add3 swift_gcd swift_min
fi
