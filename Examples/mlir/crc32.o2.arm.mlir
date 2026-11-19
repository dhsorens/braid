"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x2"} : () -> i64
      "braid_cf.cond_br"(%bb0_0)[^bb4, ^bb3c] : (i64) -> ()
    ^bb4:  // 0x10004
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_0 = "braid.zext"(%bb4_1) {bits = 32 : i64} : (i64) -> i64
      %bb4_3 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_2 = "braid.zext"(%bb4_3) {bits = 32 : i64} : (i64) -> i64
      %bb4_13 = "braid.not"(%bb4_2) : (i64) -> i64
      %bb4_14 = "braid.or"(%bb4_0, %bb4_13) : (i64, i64) -> i64
      %bb4_12 = "braid.zext"(%bb4_14) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb4_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.const"() {value = 131136 : i64} : () -> i64
      "braid.set"(%bbc_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb10_5 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_6 = "braid.add"(%bb10_0, %bb10_5) : (i64, i64) -> i64
      "braid.set"(%bb10_6) {reg = "x1"} : (i64) -> ()
      %bb10_30 = "braid.load"(%bb10_0) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb10_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10014
      %bb14_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb14_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14_3 = "braid.sub"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      %bb14_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_4 = "braid.slt"(%bb14_3, %bb14_8) : (i64, i64) -> i64
      %bb14_5 = "braid.eq"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      %bb14_6 = "braid.ule"(%bb14_2, %bb14_0) : (i64, i64) -> i64
      %bb14_9 = "braid.xor"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      %bb14_10 = "braid.xor"(%bb14_0, %bb14_3) : (i64, i64) -> i64
      %bb14_11 = "braid.and"(%bb14_9, %bb14_10) : (i64, i64) -> i64
      %bb14_7 = "braid.slt"(%bb14_11, %bb14_8) : (i64, i64) -> i64
      "braid.setf"(%bb14_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb14_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb14_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb14_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb14_3) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10018
      %bb18_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb18_0 = "braid.zext"(%bb18_1) {bits = 32 : i64} : (i64) -> i64
      %bb18_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb18_2 = "braid.zext"(%bb18_3) {bits = 32 : i64} : (i64) -> i64
      %bb18_12 = "braid.xor"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      "braid.set"(%bb18_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1001c
      %bb1c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1c_0 = "braid.zext"(%bb1c_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1c_3 = "braid.and"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      "braid.set"(%bb1c_3) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10020
      %bb20_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb20_7 = "braid.get"() {reg = "x10"} : () -> i64
      %bb20_9 = "braid.zext"(%bb20_7) {bits = 32 : i64} : (i64) -> i64
      %bb20_10 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb20_6 = "braid.shl"(%bb20_9, %bb20_10) : (i64, i64) -> i64
      %bb20_0 = "braid.add"(%bb20_1, %bb20_6) : (i64, i64) -> i64
      %bb20_30 = "braid.load"(%bb20_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb20_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10024
      %bb24_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb24_0 = "braid.zext"(%bb24_1) {bits = 32 : i64} : (i64) -> i64
      %bb24_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb24_5 = "braid.zext"(%bb24_3) {bits = 32 : i64} : (i64) -> i64
      %bb24_6 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb24_2 = "braid.lshr"(%bb24_5, %bb24_6) : (i64, i64) -> i64
      %bb24_12 = "braid.xor"(%bb24_0, %bb24_2) : (i64, i64) -> i64
      "braid.set"(%bb24_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10028
      %bb28_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb28_0 = "braid.zext"(%bb28_1) {bits = 32 : i64} : (i64) -> i64
      %bb28_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb28_3 = "braid.and"(%bb28_0, %bb28_2) : (i64, i64) -> i64
      "braid.set"(%bb28_3) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x1002c
      %bb2c_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb2c_7 = "braid.get"() {reg = "x10"} : () -> i64
      %bb2c_9 = "braid.zext"(%bb2c_7) {bits = 32 : i64} : (i64) -> i64
      %bb2c_10 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb2c_6 = "braid.shl"(%bb2c_9, %bb2c_10) : (i64, i64) -> i64
      %bb2c_0 = "braid.add"(%bb2c_1, %bb2c_6) : (i64, i64) -> i64
      %bb2c_30 = "braid.load"(%bb2c_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb2c_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10030
      %bb30_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb30_0 = "braid.zext"(%bb30_1) {bits = 32 : i64} : (i64) -> i64
      %bb30_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb30_5 = "braid.zext"(%bb30_3) {bits = 32 : i64} : (i64) -> i64
      %bb30_6 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb30_2 = "braid.lshr"(%bb30_5, %bb30_6) : (i64, i64) -> i64
      %bb30_12 = "braid.xor"(%bb30_0, %bb30_2) : (i64, i64) -> i64
      "braid.set"(%bb30_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10034
      %bb34_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb34_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb34_0 = "braid.eq"(%bb34_1, %bb34_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb34_0)[^bb10, ^bb38] : (i64) -> ()
    ^bb38:  // 0x10038
      %bb38_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb38_0 = "braid.zext"(%bb38_1) {bits = 32 : i64} : (i64) -> i64
      %bb38_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb38_2 = "braid.zext"(%bb38_3) {bits = 32 : i64} : (i64) -> i64
      %bb38_13 = "braid.not"(%bb38_2) : (i64) -> i64
      %bb38_14 = "braid.or"(%bb38_0, %bb38_13) : (i64, i64) -> i64
      %bb38_12 = "braid.zext"(%bb38_14) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb38_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x1003c
      %bb3c_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb3c_0) : (i64) -> ()
  }) {sym_name = "crc32", entry = 65536 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
