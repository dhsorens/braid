// The value operations of the `braid` dialect, in IRDL.
//
// With this file `mlir-opt` checks the operand and result types of every value operation
// in a lowered module, and the attributes each one carries:
//
//   mlir-opt --irdl-file=braid/mlir/braid.irdl.mlir --allow-unregistered-dialect f.mlir
//
// Every value is `i64`. The terminators (`br`, `cond_br`, `br_ind`, `trap`, `tail`) and the
// containers (`func`, `module`) are in a second namespace, `braid_cf`: IRDL cannot yet say
// that an operation is a terminator or that a region needs none, so those stay unregistered
// and `--allow-unregistered-dialect` is still needed for them. The meaning of each operation
// is in `braid/Braid/IR/Semantics.lean`.

irdl.dialect @braid {
  irdl.operation @const {
    %i64 = irdl.is i64
    %value = irdl.any
    irdl.attributes {"value" = %value}
    irdl.results(res: %i64)
  }
  irdl.operation @not {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @neg {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @clz {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @popcnt {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @rbit {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @bswap {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @sext {
    %i64 = irdl.is i64
    %bits = irdl.any
    irdl.operands(a0: %i64)
    irdl.attributes {"bits" = %bits}
    irdl.results(res: %i64)
  }
  irdl.operation @zext {
    %i64 = irdl.is i64
    %bits = irdl.any
    irdl.operands(a0: %i64)
    irdl.attributes {"bits" = %bits}
    irdl.results(res: %i64)
  }
  irdl.operation @add {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @sub {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @mul {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @mulhu {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @mulhs {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @mulhsu {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @udiv {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @urem {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @sdiv {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @srem {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @and {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @or {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @xor {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @shl {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @lshr {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @ashr {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @rotr {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @eq {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @ne {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @ult {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @ule {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @slt {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @sle {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @lanes {
    %i64 = irdl.is i64
    %op = irdl.any
    %bits = irdl.any
    irdl.operands(a0: %i64, a1: %i64)
    irdl.attributes {"op" = %op, "bits" = %bits}
    irdl.results(res: %i64)
  }
  irdl.operation @select {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64, a1: %i64, a2: %i64)
    irdl.results(res: %i64)
  }
  irdl.operation @get {
    %i64 = irdl.is i64
    %reg = irdl.any
    irdl.attributes {"reg" = %reg}
    irdl.results(res: %i64)
  }
  irdl.operation @set {
    %i64 = irdl.is i64
    %reg = irdl.any
    irdl.operands(a0: %i64)
    irdl.attributes {"reg" = %reg}
  }
  irdl.operation @getf {
    %i64 = irdl.is i64
    %flag = irdl.any
    irdl.attributes {"flag" = %flag}
    irdl.results(res: %i64)
  }
  irdl.operation @setf {
    %i64 = irdl.is i64
    %flag = irdl.any
    irdl.operands(a0: %i64)
    irdl.attributes {"flag" = %flag}
  }
  irdl.operation @load {
    %i64 = irdl.is i64
    %bytes = irdl.any
    irdl.operands(a0: %i64)
    irdl.attributes {"bytes" = %bytes}
    irdl.results(res: %i64)
  }
  irdl.operation @store {
    %i64 = irdl.is i64
    %bytes = irdl.any
    irdl.operands(a0: %i64, a1: %i64)
    irdl.attributes {"bytes" = %bytes}
  }
  irdl.operation @havoc {
    %i64 = irdl.is i64
    irdl.results(res: %i64)
  }
  irdl.operation @guard {
    %i64 = irdl.is i64
    irdl.operands(a0: %i64)
  }
}
