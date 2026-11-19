"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.eq"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb0_2)[^bb58, ^bb4] : (i64) -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.const"() {value = -1 : i64} : () -> i64
      %bb4_2 = "braid.xor"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb8_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      "braid.set"(%bb8_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.const"() {value = 65536 : i64} : () -> i64
      "braid.set"(%bbc_0) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb10_1 = "braid.const"() {value = 92 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      "braid.set"(%bb10_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10014
      %bb14_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb14_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      %bb14_7 = "braid.load"(%bb14_2) {bytes = 1 : i64} : (i64) -> i64
      %bb14_8 = "braid.zext"(%bb14_7) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bb14_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10018
      %bb18_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb18_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      "braid.set"(%bb18_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1001c
      %bb1c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb1c_2 = "braid.xor"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      "braid.set"(%bb1c_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10020
      %bb20_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb20_1 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb20_2 = "braid.and"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      "braid.set"(%bb20_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10024
      %bb24_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb24_1 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb24_2 = "braid.shl"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      "braid.set"(%bb24_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10028
      %bb28_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb28_2 = "braid.add"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      "braid.set"(%bb28_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x1002c
      %bb2c_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb2c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_2 = "braid.add"(%bb2c_0, %bb2c_1) : (i64, i64) -> i64
      %bb2c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb2c_4 = "braid.and"(%bb2c_2, %bb2c_3) : (i64, i64) -> i64
      %bb2c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_6 = "braid.eq"(%bb2c_4, %bb2c_5) : (i64, i64) -> i64
      "braid.guard"(%bb2c_6) : (i64) -> ()
      %bb2c_7 = "braid.load"(%bb2c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb2c_8 = "braid.sext"(%bb2c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2c_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10030
      %bb30_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb30_1 = "braid.zext"(%bb30_0) {bits = 32 : i64} : (i64) -> i64
      %bb30_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb30_3 = "braid.lshr"(%bb30_1, %bb30_2) : (i64, i64) -> i64
      %bb30_4 = "braid.sext"(%bb30_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb30_4) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10034
      %bb34_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb34_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb34_2 = "braid.xor"(%bb34_0, %bb34_1) : (i64, i64) -> i64
      "braid.set"(%bb34_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x10038
      %bb38_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb38_1 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb38_2 = "braid.and"(%bb38_0, %bb38_1) : (i64, i64) -> i64
      "braid.set"(%bb38_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x1003c
      %bb3c_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb3c_1 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb3c_2 = "braid.shl"(%bb3c_0, %bb3c_1) : (i64, i64) -> i64
      "braid.set"(%bb3c_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x10040
      %bb40_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb40_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb40_2 = "braid.add"(%bb40_0, %bb40_1) : (i64, i64) -> i64
      "braid.set"(%bb40_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10044
      %bb44_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb44_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb44_2 = "braid.add"(%bb44_0, %bb44_1) : (i64, i64) -> i64
      %bb44_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb44_4 = "braid.and"(%bb44_2, %bb44_3) : (i64, i64) -> i64
      %bb44_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb44_6 = "braid.eq"(%bb44_4, %bb44_5) : (i64, i64) -> i64
      "braid.guard"(%bb44_6) : (i64) -> ()
      %bb44_7 = "braid.load"(%bb44_2) {bytes = 4 : i64} : (i64) -> i64
      %bb44_8 = "braid.sext"(%bb44_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb44_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x10048
      %bb48_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb48_1 = "braid.zext"(%bb48_0) {bits = 32 : i64} : (i64) -> i64
      %bb48_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb48_3 = "braid.lshr"(%bb48_1, %bb48_2) : (i64, i64) -> i64
      %bb48_4 = "braid.sext"(%bb48_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb48_4) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x1004c
      %bb4c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb4c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb4c_2 = "braid.xor"(%bb4c_0, %bb4c_1) : (i64, i64) -> i64
      "braid.set"(%bb4c_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x10050
      %bb50_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb50_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb50_2 = "braid.ne"(%bb50_0, %bb50_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb50_2)[^bb14, ^bb54] : (i64) -> ()
    ^bb54:  // 0x10054
      %bb54_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb54_1 = "braid.const"() {value = -1 : i64} : () -> i64
      %bb54_2 = "braid.xor"(%bb54_0, %bb54_1) : (i64, i64) -> i64
      "braid.set"(%bb54_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x10058
      %bb58_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb58_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb58_2 = "braid.add"(%bb58_0, %bb58_1) : (i64, i64) -> i64
      %bb58_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb58_4 = "braid.and"(%bb58_2, %bb58_3) : (i64, i64) -> i64
      %bb58_5 = "braid.const"() {value = 65628 : i64} : () -> i64
      "braid_cf.br_ind"(%bb58_4) : (i64) -> ()
  }) {sym_name = "crc32", entry = 65536 : i64} : () -> ()
}) {arch = "riscv64"} : () -> ()
