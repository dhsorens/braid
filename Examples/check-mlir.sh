#!/bin/sh
# Check the MLIR text of every example with other MLIR tools.
#
#   Examples/check-mlir.sh
#
# 1. mlir-opt reads each module and checks its value operations against the IRDL definition
#    of the dialect (braid/mlir/braid.irdl.mlir).
# 2. If VEIR_OPT names a veir-opt binary (https://github.com/opencompl/veir), each module is
#    also read and printed by VeIR, and mlir-opt checks what VeIR printed. VeIR's verifier is
#    off for this: it does not know the terminators of the dialect.
set -eu
cd "$(dirname "$0")/.."

MLIR_OPT=${MLIR_OPT:-/opt/homebrew/opt/llvm/bin/mlir-opt}
IRDL=braid/mlir/braid.irdl.mlir
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

n=0
for f in Examples/mlir/*.mlir; do
  "$MLIR_OPT" --irdl-file="$IRDL" --allow-unregistered-dialect "$f" -o /dev/null
  if [ -n "${VEIR_OPT:-}" ]; then
    "$VEIR_OPT" "$f" --allow-unregistered-dialect --disable-verifiers > "$tmp"
    "$MLIR_OPT" --irdl-file="$IRDL" --allow-unregistered-dialect "$tmp" -o /dev/null
  fi
  n=$((n + 1))
done
if [ -n "${VEIR_OPT:-}" ]; then
  echo "$n modules: checked by mlir-opt, and round-tripped through veir-opt"
else
  echo "$n modules: checked by mlir-opt (set VEIR_OPT to round-trip through VeIR)"
fi
