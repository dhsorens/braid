"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.eq"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb4_2)[^bb40, ^bb8] : (i64) -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb8_1 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb8_2 = "braid.shl"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      "braid.set"(%bb8_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbc_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      "braid.set"(%bbc_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb10_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb10_4 = "braid.and"(%bb10_2, %bb10_3) : (i64, i64) -> i64
      %bb10_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_6 = "braid.eq"(%bb10_4, %bb10_5) : (i64, i64) -> i64
      "braid.guard"(%bb10_6) : (i64) -> ()
      %bb10_7 = "braid.load"(%bb10_2) {bytes = 8 : i64} : (i64) -> i64
      %bb10_8 = "braid.zext"(%bb10_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb10_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10014
      %bb14_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb14_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      %bb14_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb14_4 = "braid.and"(%bb14_2, %bb14_3) : (i64, i64) -> i64
      %bb14_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_6 = "braid.eq"(%bb14_4, %bb14_5) : (i64, i64) -> i64
      "braid.guard"(%bb14_6) : (i64) -> ()
      %bb14_7 = "braid.load"(%bb14_2) {bytes = 8 : i64} : (i64) -> i64
      %bb14_8 = "braid.zext"(%bb14_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb14_8) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10018
      %bb18_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb18_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      "braid.set"(%bb18_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1001c
      %bb1c_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      "braid.set"(%bb1c_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10020
      %bb20_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb20_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb20_2 = "braid.ult"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      "braid.set"(%bb20_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10024
      %bb24_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb24_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb24_2 = "braid.add"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      "braid.set"(%bb24_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10028
      %bb28_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb28_2 = "braid.ult"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      "braid.set"(%bb28_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x1002c
      %bb2c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb2c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_2 = "braid.add"(%bb2c_0, %bb2c_1) : (i64, i64) -> i64
      %bb2c_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb2c_4 = "braid.and"(%bb2c_2, %bb2c_3) : (i64, i64) -> i64
      %bb2c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_6 = "braid.eq"(%bb2c_4, %bb2c_5) : (i64, i64) -> i64
      "braid.guard"(%bb2c_6) : (i64) -> ()
      %bb2c_7 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.store"(%bb2c_2, %bb2c_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10030
      %bb30_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb30_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb30_2 = "braid.add"(%bb30_0, %bb30_1) : (i64, i64) -> i64
      "braid.set"(%bb30_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10034
      %bb34_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb34_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb34_2 = "braid.or"(%bb34_0, %bb34_1) : (i64, i64) -> i64
      "braid.set"(%bb34_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x10038
      %bb38_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb38_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb38_2 = "braid.add"(%bb38_0, %bb38_1) : (i64, i64) -> i64
      "braid.set"(%bb38_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x1003c
      %bb3c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb3c_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb3c_2 = "braid.ne"(%bb3c_0, %bb3c_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb3c_2)[^bb10, ^bb40] : (i64) -> ()
    ^bb40:  // 0x10040
      %bb40_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb40_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb40_2 = "braid.add"(%bb40_0, %bb40_1) : (i64, i64) -> i64
      "braid.set"(%bb40_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10044
      %bb44_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb44_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb44_2 = "braid.add"(%bb44_0, %bb44_1) : (i64, i64) -> i64
      %bb44_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb44_4 = "braid.and"(%bb44_2, %bb44_3) : (i64, i64) -> i64
      %bb44_5 = "braid.const"() {value = 65608 : i64} : () -> i64
      "braid_cf.br_ind"(%bb44_4) : (i64) -> ()
  }) {sym_name = "add_limbs", entry = 65536 : i64} : () -> ()
}) {arch = "riscv64"} : () -> ()
