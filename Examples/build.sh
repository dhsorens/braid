#!/bin/sh
# Compile the example sources for each instruction set and lower them with `braid-lower`.
#
#   Examples/build.sh            every example
#   Examples/build.sh basic      one example
#
# For each example and instruction set this writes
#   Examples/bin/<name>.<isa>.elf             the binary (not kept in the repository)
#   Examples/mlir/<name>.<isa>.mlir           the lowered code, as MLIR text
#   Examples/<Module>/<ISA>/Image.lean        the lowered code, as a Lean module
#
# Needs clang with the RISC-V, AArch64 and x86-64 targets, a RISC-V linker, lld, rustc, swiftc
# and go for the Rust, Swift and Go examples, and a Python with Numba (PYTHON) for the Python
# examples. See Examples/README.md.
set -eu
cd "$(dirname "$0")/.."

CLANG=${CLANG:-/opt/homebrew/opt/llvm/bin/clang}
OBJDUMP=${OBJDUMP:-/opt/homebrew/opt/llvm/bin/llvm-objdump}
RV_LD=${RV_LD:-/opt/homebrew/opt/riscv64-elf-binutils/bin/riscv64-elf-ld}
LLD=${LLD:-$(ls "$(rustc --print sysroot)"/lib/rustlib/*/bin/rust-lld | head -1)}
LOWER=.lake/build/bin/braid-lower
CFLAGS="-O1 -fno-vectorize -ffreestanding -nostdlib -fno-builtin"
ISAS=${ISAS:-"rv arm x86"}

mkdir -p Examples/bin Examples/mlir

target() {
  case $1 in
    rv) echo "--target=riscv64-unknown-elf -march=rv64im -mabi=lp64" ;;
    arm) echo "--target=aarch64-unknown-linux-gnu -mgeneral-regs-only" ;;
    x86) echo "--target=x86_64-unknown-linux-gnu -mgeneral-regs-only" ;;
  esac
}

isa_dir() {
  case $1 in rv) echo RiscV ;; arm) echo Arm ;; x86) echo X86 ;; esac
}

# Link an object and lower it: isa, name, module, functions.
link_and_lower() {
  isa=$1; name=$2; module=$3; shift 3
  fns=""; for f in "$@"; do fns="$fns --fn $f"; done
  dir=Examples/$(echo "$module" | tr . /)/$(isa_dir "$isa")
  mkdir -p "$dir"
  obj=Examples/bin/$name.$isa.o
  elf=Examples/bin/$name.$isa.elf
  extra=""
  case $isa in
    rv) "$RV_LD" -Ttext=0x10000 --no-relax -e "$1" "$obj" -o "$elf" ;;
    arm) "$LLD" -flavor gnu --image-base=0 -Ttext=0x10000 -e "$1" "$obj" -o "$elf" ;;
    x86)
      "$LLD" -flavor gnu -Ttext=0x401000 -e "$1" "$obj" -o "$elf"
      "$OBJDUMP" -d "$elf" > "Examples/bin/$name.x86.dis"
      extra="--disasm Examples/bin/$name.x86.dis" ;;
  esac
  # shellcheck disable=SC2086
  "$LOWER" "$elf" $extra $fns --mlir "Examples/mlir/$name.$isa.mlir" \
    --lean "$dir/Image.lean" --module "Examples.$module.$(isa_dir "$isa")"
}

# A C source: name, source, module, functions.
lower_c() {
  name=$1; src=$2; module=$3; shift 3
  for isa in $ISAS; do
    # shellcheck disable=SC2046
    "$CLANG" $(target "$isa") $CFLAGS -c "$src" -o "Examples/bin/$name.$isa.o"
    link_and_lower "$isa" "$name" "$module" "$@"
  done
}

# LLVM IR from another compiler: name, module, functions. The IR is in Examples/bin/<name>.ll.
# What ties it to the host is removed, and clang compiles it for each instruction set, so that
# one back end produces the code for all three.
lower_ll() {
  name=$1; module=$2; shift 2
  sed -E 's/"target-features"="[^"]*"//g; s/"target-cpu"="[^"]*"//g;
          /^target datalayout/d; /^target triple/d; s/"probe-stack"="[^"]*"//g;
          s/"frame-pointer"="[^"]*"//g; s/ swiftcc / /g; /^!llvm.linker.options/d;
          s/, section "[^"]*"//g' "Examples/bin/$name.ll" > "Examples/bin/$name.clean.ll"
  for isa in $ISAS; do
    # shellcheck disable=SC2046
    "$CLANG" $(target "$isa") -O1 -fno-vectorize -Wno-override-module \
      -c "Examples/bin/$name.clean.ll" -o "Examples/bin/$name.$isa.o"
    link_and_lower "$isa" "$name" "$module" "$@"
  done
}

# A Rust source: name, source, module, functions.
lower_rust() {
  name=$1; src=$2; module=$3; shift 3
  rustc --edition 2021 --target riscv64imac-unknown-none-elf -C opt-level=1 -C panic=abort \
    --crate-type=staticlib --emit=llvm-ir -o "Examples/bin/$name.ll" "$src" 2>/dev/null
  lower_ll "$name" "$module" "$@"
}

# A Swift source: name, source, module, functions. The exported functions use the C calling
# convention; the Swift convention on the internal copies is dropped.
lower_swift() {
  name=$1; src=$2; module=$3; shift 3
  swiftc -O -parse-as-library -emit-ir "$src" -o "Examples/bin/$name.ll" 2>/dev/null
  lower_ll "$name" "$module" "$@"
}

# A Python source, compiled by Numba: name, directory, module, functions. `emit_ll.py` in the
# directory writes the LLVM IR Numba produces. PYTHON names an interpreter that has Numba.
lower_python() {
  name=$1; dir=$2; module=$3; shift 3
  (cd "$dir" && "${PYTHON:-python3}" emit_ll.py "$OLDPWD/Examples/bin/$name.ll")
  lower_ll "$name" "$module" "$@"
}

# A JavaScript source, compiled by V8: name, directory, module, functions. `emit_s.py` in the
# directory runs the source under Node and writes the machine code TurboFan produced as an
# assembly file. The code is for the machine Node runs on, which must be AArch64.
lower_js() {
  name=$1; dir=$2; module=$3; shift 3
  fns=""; for f in "$@"; do fns="$fns --fn $f"; done
  # shellcheck disable=SC2086
  (cd "$dir" && python3 emit_s.py "$OLDPWD/Examples/bin/$name.s" "$@")
  out=Examples/$(echo "$module" | tr . /)/Arm
  mkdir -p "$out"
  "$CLANG" --target=aarch64-unknown-linux-gnu -c "Examples/bin/$name.s" -o "Examples/bin/$name.arm.o"
  "$LLD" -flavor gnu --image-base=0 -Ttext=0x10000 -e "$1" "Examples/bin/$name.arm.o" \
    -o "Examples/bin/$name.arm.elf"
  # shellcheck disable=SC2086
  "$LOWER" "Examples/bin/$name.arm.elf" $fns --mlir "Examples/mlir/$name.arm.mlir" \
    --lean "$out/Image.lean" --module "Examples.$module.Arm" 2>/dev/null
}

# The same, for the code an x86-64 build of Node produces (NODE_X64 names it; on an Apple
# machine it runs under Rosetta).
lower_js_x64() {
  name=$1; dir=$2; module=$3; shift 3
  fns=""; for f in "$@"; do fns="$fns --fn $f"; done
  # shellcheck disable=SC2086
  (cd "$dir" && NODE="$NODE_X64" JS_ARCH=x64 python3 emit_s.py "$OLDPWD/Examples/bin/$name.x86.s" "$@")
  out=Examples/$(echo "$module" | tr . /)/X86
  mkdir -p "$out"
  "$CLANG" --target=x86_64-unknown-linux-gnu -c "Examples/bin/$name.x86.s" -o "Examples/bin/$name.x86.o"
  "$LLD" -flavor gnu -Ttext=0x401000 -e "$1" "Examples/bin/$name.x86.o" -o "Examples/bin/$name.x86.elf"
  "$OBJDUMP" -d "Examples/bin/$name.x86.elf" > "Examples/bin/$name.x86.dis"
  # shellcheck disable=SC2086
  "$LOWER" "Examples/bin/$name.x86.elf" --disasm "Examples/bin/$name.x86.dis" $fns \
    --mlir "Examples/mlir/$name.x86.mlir" --lean "$out/Image.lean" \
    --module "Examples.$module.X86" 2>/dev/null
}

# A Go source: name, source, module, functions. Go has its own back ends and linker, and its
# RISC-V back end emits compressed instructions, which the RISC-V model does not have, so Go
# is lowered for AArch64 and x86-64 only. The binary holds the whole Go runtime; only the
# functions named are lowered.
lower_go() {
  name=$1; src=$2; module=$3; shift 3
  fns=""; for f in "$@"; do fns="$fns --fn $f"; done
  for isa in $ISAS; do
    case $isa in arm) goarch=arm64 ;; x86) goarch=amd64 ;; *) continue ;; esac
    dir=Examples/$(echo "$module" | tr . /)/$(isa_dir "$isa")
    mkdir -p "$dir"
    elf=Examples/bin/$name.$isa.elf
    (cd "$(dirname "$src")" && GOOS=linux GOARCH=$goarch go build -o "$OLDPWD/$elf" "$(basename "$src")")
    extra=""
    if [ "$isa" = x86 ]; then
      "$OBJDUMP" -d "$elf" > "Examples/bin/$name.x86.dis"
      extra="--disasm Examples/bin/$name.x86.dis"
    fi
    # shellcheck disable=SC2086
    "$LOWER" "$elf" $extra $fns --mlir "Examples/mlir/$name.$isa.mlir" \
      --lean "$dir/Image.lean" --module "Examples.$module.$(isa_dir "$isa")"
  done
}

want() { [ -z "${ONLY:-}" ] || [ "$ONLY" = "$1" ]; }
ONLY=${1:-}

if want basic; then lower_c basic Examples/src/c/basic.c Basic add3 max_u64 sum_to; fi
if want memory; then lower_c memory Examples/src/c/memory.c Memory swap sum_array max2 max3; fi
if want bytes; then lower_c bytes Examples/src/c/bytes.c Bytes str_len fill count_ones; fi
if want rustbasic; then
  lower_rust rustbasic Examples/src/rust/basic.rs RustBasic add3 max_u64 gcd sum_slice
fi
if want swiftbasic; then
  lower_swift swiftbasic Examples/src/swift/basic.swift SwiftBasic swift_add3 swift_gcd swift_min
fi
if want pybasic; then
  lower_python pybasic Examples/src/python PyBasic py_add3 py_max_u64 py_gcd
fi
if want jsbasic; then
  case " $ISAS " in *" arm "*) lower_js jsbasic Examples/src/js JsBasic js_add3 js_max ;; esac
  if [ -n "${NODE_X64:-}" ]; then
    case " $ISAS " in *" x86 "*) lower_js_x64 jsbasic Examples/src/js JsBasic js_add3 js_max ;; esac
  fi
fi
if want gobasic; then
  lower_go gobasic Examples/src/go/basic.go GoBasic main.Add3 main.MaxU64 main.SumSlice
fi
