"braid.module"() ({
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x3"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "x2"} : () -> i64
      %bb0_12 = "braid.add"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_12) {reg = "x9"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_12 = "braid.or"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x8"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_0 = "braid.zext"(%bb8_1) {bits = 32 : i64} : (i64) -> i64
      %bb8_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.zext"(%bb8_3) {bits = 32 : i64} : (i64) -> i64
      %bb8_12 = "braid.or"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_12) {reg = "x0"} : (i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bbc_2 = "braid.get"() {reg = "x4"} : () -> i64
      %bbc_12 = "braid.add"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      "braid.set"(%bbc_12) {reg = "x9"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "x8"} : () -> i64
      "braid.store"(%bb10_1, %bb10_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10014
      %bb14_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid.br_ind"(%bb14_0) : (i64) -> ()
  }) {sym_name = "py_add3", entry = 65536 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10018
      %bb0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "x3"} : () -> i64
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
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x1001c
      %bb4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_12 = "braid.or"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x8"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10020
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_0 = "braid.zext"(%bb8_1) {bits = 32 : i64} : (i64) -> i64
      %bb8_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.zext"(%bb8_3) {bits = 32 : i64} : (i64) -> i64
      %bb8_12 = "braid.or"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_12) {reg = "x0"} : (i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10024
      %bbc_1 = "braid.getf"() {flag = "c"} : () -> i64
      %bbc_2 = "braid.getf"() {flag = "z"} : () -> i64
      %bbc_0 = "braid.ult"(%bbc_2, %bbc_1) : (i64, i64) -> i64
      %bbc_5 = "braid.get"() {reg = "x2"} : () -> i64
      %bbc_7 = "braid.get"() {reg = "x3"} : () -> i64
      %bbc_12 = "braid.select"(%bbc_0, %bbc_5, %bbc_7) : (i64, i64, i64) -> i64
      "braid.set"(%bbc_12) {reg = "x9"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10028
      %bb10_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "x8"} : () -> i64
      "braid.store"(%bb10_1, %bb10_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb14] : () -> ()
    ^bb14:  // 0x1002c
      %bb14_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid.br_ind"(%bb14_0) : (i64) -> ()
  }) {sym_name = "py_max_u64", entry = 65560 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10030
      %bb0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb0_12 = "braid.or"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_12) {reg = "x8"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10034
      %bb4_0 = "braid.get"() {reg = "x3"} : () -> i64
      "braid.cond_br"(%bb4_0)[^bb8, ^bb20] : (i64) -> ()
    ^bb8:  // 0x10038
      %bb8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb8_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb8_9 = "braid.udiv"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      "braid.set"(%bb8_9) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1003c
      %bbc_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.get"() {reg = "x3"} : () -> i64
      %bbc_12 = "braid.or"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      "braid.set"(%bbc_12) {reg = "x9"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10040
      %bb10_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb10_2 = "braid.get"() {reg = "x2"} : () -> i64
      %bb10_3 = "braid.mul"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_9 = "braid.sub"(%bb10_2, %bb10_3) : (i64, i64) -> i64
      "braid.set"(%bb10_9) {reg = "x3"} : (i64) -> ()
      "braid.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10044
      %bb14_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_2 = "braid.get"() {reg = "x9"} : () -> i64
      %bb14_12 = "braid.or"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      "braid.set"(%bb14_12) {reg = "x2"} : (i64) -> ()
      "braid.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10048
      %bb18_0 = "braid.get"() {reg = "x3"} : () -> i64
      "braid.cond_br"(%bb18_0)[^bb8, ^bb1c] : (i64) -> ()
    ^bb1c:  // 0x1004c
      "braid.br"()[^bb24] : () -> ()
    ^bb20:  // 0x10050
      %bb20_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_2 = "braid.get"() {reg = "x2"} : () -> i64
      %bb20_12 = "braid.or"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      "braid.set"(%bb20_12) {reg = "x9"} : (i64) -> ()
      "braid.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10054
      %bb24_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_0 = "braid.zext"(%bb24_1) {bits = 32 : i64} : (i64) -> i64
      %bb24_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_2 = "braid.zext"(%bb24_3) {bits = 32 : i64} : (i64) -> i64
      %bb24_12 = "braid.or"(%bb24_0, %bb24_2) : (i64, i64) -> i64
      "braid.set"(%bb24_12) {reg = "x0"} : (i64) -> ()
      "braid.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10058
      %bb28_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "x8"} : () -> i64
      "braid.store"(%bb28_1, %bb28_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x1005c
      %bb2c_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid.br_ind"(%bb2c_0) : (i64) -> ()
  }) {sym_name = "py_gcd", entry = 65584 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
