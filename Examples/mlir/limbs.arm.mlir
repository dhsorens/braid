"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_12 = "braid.or"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x3"} : () -> i64
      "braid_cf.cond_br"(%bb4_0)[^bb8, ^bb2c] : (i64) -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb8_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8_6 = "braid.add"(%bb8_0, %bb8_5) : (i64, i64) -> i64
      "braid.set"(%bb8_6) {reg = "x1"} : (i64) -> ()
      %bb8_30 = "braid.load"(%bb8_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb8_30) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbc_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbc_6 = "braid.add"(%bbc_0, %bbc_5) : (i64, i64) -> i64
      "braid.set"(%bbc_6) {reg = "x2"} : (i64) -> ()
      %bbc_30 = "braid.load"(%bbc_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbc_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb10_2 = "braid.get"() {reg = "x8"} : () -> i64
      %bb10_12 = "braid.add"(%bb10_0, %bb10_2) : (i64, i64) -> i64
      %bb10_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_13 = "braid.slt"(%bb10_12, %bb10_17) : (i64, i64) -> i64
      %bb10_14 = "braid.eq"(%bb10_12, %bb10_17) : (i64, i64) -> i64
      %bb10_15 = "braid.ult"(%bb10_12, %bb10_0) : (i64, i64) -> i64
      %bb10_18 = "braid.xor"(%bb10_0, %bb10_12) : (i64, i64) -> i64
      %bb10_19 = "braid.xor"(%bb10_2, %bb10_12) : (i64, i64) -> i64
      %bb10_20 = "braid.and"(%bb10_18, %bb10_19) : (i64, i64) -> i64
      %bb10_16 = "braid.slt"(%bb10_20, %bb10_17) : (i64, i64) -> i64
      "braid.setf"(%bb10_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb10_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb10_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb10_16) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb10_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10014
      %bb14_1 = "braid.getf"() {flag = "c"} : () -> i64
      %bb14_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_0 = "braid.eq"(%bb14_1, %bb14_2) : (i64, i64) -> i64
      %bb14_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_5 = "braid.zext"(%bb14_6) {bits = 32 : i64} : (i64) -> i64
      %bb14_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_9 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14_10 = "braid.add"(%bb14_8, %bb14_9) : (i64, i64) -> i64
      %bb14_7 = "braid.zext"(%bb14_10) {bits = 32 : i64} : (i64) -> i64
      %bb14_12 = "braid.select"(%bb14_0, %bb14_5, %bb14_7) : (i64, i64, i64) -> i64
      "braid.set"(%bb14_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10018
      %bb18_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb18_2 = "braid.get"() {reg = "x10"} : () -> i64
      %bb18_12 = "braid.add"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      %bb18_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_13 = "braid.slt"(%bb18_12, %bb18_17) : (i64, i64) -> i64
      %bb18_14 = "braid.eq"(%bb18_12, %bb18_17) : (i64, i64) -> i64
      %bb18_15 = "braid.ult"(%bb18_12, %bb18_0) : (i64, i64) -> i64
      %bb18_18 = "braid.xor"(%bb18_0, %bb18_12) : (i64, i64) -> i64
      %bb18_19 = "braid.xor"(%bb18_2, %bb18_12) : (i64, i64) -> i64
      %bb18_20 = "braid.and"(%bb18_18, %bb18_19) : (i64, i64) -> i64
      %bb18_16 = "braid.slt"(%bb18_20, %bb18_17) : (i64, i64) -> i64
      "braid.setf"(%bb18_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb18_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb18_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb18_16) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb18_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1001c
      %bb1c_1 = "braid.getf"() {flag = "c"} : () -> i64
      %bb1c_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_0 = "braid.eq"(%bb1c_1, %bb1c_2) : (i64, i64) -> i64
      %bb1c_6 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1c_5 = "braid.zext"(%bb1c_6) {bits = 32 : i64} : (i64) -> i64
      %bb1c_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_9 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1c_10 = "braid.add"(%bb1c_8, %bb1c_9) : (i64, i64) -> i64
      %bb1c_7 = "braid.zext"(%bb1c_10) {bits = 32 : i64} : (i64) -> i64
      %bb1c_12 = "braid.select"(%bb1c_0, %bb1c_5, %bb1c_7) : (i64, i64, i64) -> i64
      "braid.set"(%bb1c_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10020
      %bb20_0 = "braid.get"() {reg = "x3"} : () -> i64
      %bb20_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb20_3 = "braid.sub"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      %bb20_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_4 = "braid.slt"(%bb20_3, %bb20_8) : (i64, i64) -> i64
      %bb20_5 = "braid.eq"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      %bb20_6 = "braid.ule"(%bb20_2, %bb20_0) : (i64, i64) -> i64
      %bb20_9 = "braid.xor"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      %bb20_10 = "braid.xor"(%bb20_0, %bb20_3) : (i64, i64) -> i64
      %bb20_11 = "braid.and"(%bb20_9, %bb20_10) : (i64, i64) -> i64
      %bb20_7 = "braid.slt"(%bb20_11, %bb20_8) : (i64, i64) -> i64
      "braid.setf"(%bb20_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb20_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb20_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb20_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb20_3) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10024
      %bb24_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb24_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb24_6 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb24_7 = "braid.add"(%bb24_1, %bb24_6) : (i64, i64) -> i64
      "braid.set"(%bb24_7) {reg = "x0"} : (i64) -> ()
      "braid.store"(%bb24_1, %bb24_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10028
      %bb28_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb28_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_0 = "braid.eq"(%bb28_1, %bb28_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb28_0)[^bb8, ^bb2c] : (i64) -> ()
    ^bb2c:  // 0x1002c
      %bb2c_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_2 = "braid.get"() {reg = "x8"} : () -> i64
      %bb2c_12 = "braid.or"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      "braid.set"(%bb2c_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10030
      %bb30_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb30_0) : (i64) -> ()
  }) {sym_name = "add_limbs", entry = 65536 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
