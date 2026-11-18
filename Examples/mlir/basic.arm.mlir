"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb0_12 = "braid.add"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb4_2 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4_12 = "braid.add"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb8_0) : (i64) -> ()
  }) {sym_name = "add3", entry = 65536 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x1000c
      %bb0_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "x1"} : () -> i64
      %bb0_12 = "braid.sub"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      %bb0_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_13 = "braid.slt"(%bb0_12, %bb0_17) : (i64, i64) -> i64
      %bb0_14 = "braid.eq"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      %bb0_15 = "braid.ule"(%bb0_2, %bb0_0) : (i64, i64) -> i64
      %bb0_18 = "braid.xor"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      %bb0_19 = "braid.xor"(%bb0_0, %bb0_12) : (i64, i64) -> i64
      %bb0_20 = "braid.and"(%bb0_18, %bb0_19) : (i64, i64) -> i64
      %bb0_16 = "braid.slt"(%bb0_20, %bb0_17) : (i64, i64) -> i64
      "braid.setf"(%bb0_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb0_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb0_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb0_16) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10010
      %bb4_1 = "braid.getf"() {flag = "c"} : () -> i64
      %bb4_2 = "braid.getf"() {flag = "z"} : () -> i64
      %bb4_0 = "braid.ult"(%bb4_2, %bb4_1) : (i64, i64) -> i64
      %bb4_5 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_7 = "braid.get"() {reg = "x1"} : () -> i64
      %bb4_12 = "braid.select"(%bb4_0, %bb4_5, %bb4_7) : (i64, i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10014
      %bb8_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb8_0) : (i64) -> ()
  }) {sym_name = "max_u64", entry = 65548 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10018
      %bb0_0 = "braid.get"() {reg = "x0"} : () -> i64
      "braid_cf.cond_br"(%bb0_0)[^bb4, ^bb20] : (i64) -> ()
    ^bb4:  // 0x1001c
      %bb4_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4_3 = "braid.sub"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10020
      %bb8_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb8_2 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb8_3 = "braid.sub"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10024
      %bbc_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bbc_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bbc_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_3 = "braid.mul"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      %bbc_9 = "braid.add"(%bbc_2, %bbc_3) : (i64, i64) -> i64
      "braid.set"(%bbc_9) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10028
      %bb10_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb10_9 = "braid.mulhu"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      "braid.set"(%bb10_9) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x1002c
      %bb14_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb14_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb14_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb14_3 = "braid.mul"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      %bb14_9 = "braid.add"(%bb14_2, %bb14_3) : (i64, i64) -> i64
      "braid.set"(%bb14_9) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10030
      %bb18_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb18_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb18_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb18_3 = "braid.lshr"(%bb18_1, %bb18_2) : (i64, i64) -> i64
      %bb18_4 = "braid.const"() {value = 63 : i64} : () -> i64
      %bb18_5 = "braid.shl"(%bb18_0, %bb18_4) : (i64, i64) -> i64
      %bb18_9 = "braid.or"(%bb18_3, %bb18_5) : (i64, i64) -> i64
      "braid.set"(%bb18_9) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10034
      %bb1c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1c_2 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1c_12 = "braid.sub"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      "braid.set"(%bb1c_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10038
      %bb20_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb20_0) : (i64) -> ()
  }) {sym_name = "sum_to", entry = 65560 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
