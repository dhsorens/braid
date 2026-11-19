"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb0_6 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb0_0 = "braid.add"(%bb0_1, %bb0_6) : (i64, i64) -> i64
      %bb0_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb0_22 = "braid.add"(%bb0_0, %bb0_21) : (i64, i64) -> i64
      %bb0_23 = "braid.load"(%bb0_0) {bytes = 4 : i64} : (i64) -> i64
      %bb0_26 = "braid.load"(%bb0_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb0_23) {reg = "x8"} : (i64) -> ()
      "braid.set"(%bb0_26) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb4_22 = "braid.add"(%bb4_0, %bb4_21) : (i64, i64) -> i64
      %bb4_23 = "braid.load"(%bb4_0) {bytes = 4 : i64} : (i64) -> i64
      %bb4_26 = "braid.load"(%bb4_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb4_23) {reg = "x9"} : (i64) -> ()
      "braid.set"(%bb4_26) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb8_6 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb8_0 = "braid.add"(%bb8_1, %bb8_6) : (i64, i64) -> i64
      %bb8_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb8_22 = "braid.add"(%bb8_0, %bb8_21) : (i64, i64) -> i64
      %bb8_23 = "braid.load"(%bb8_0) {bytes = 4 : i64} : (i64) -> i64
      %bb8_26 = "braid.load"(%bb8_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb8_23) {reg = "x12"} : (i64) -> ()
      "braid.set"(%bb8_26) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bbc_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bbc_2 = "braid.zext"(%bbc_1) {bits = 32 : i64} : (i64) -> i64
      %bbc_3 = "braid.const"() {value = 6 : i64} : () -> i64
      %bbc_4 = "braid.lshr"(%bbc_2, %bbc_3) : (i64, i64) -> i64
      %bbc_5 = "braid.const"() {value = 26 : i64} : () -> i64
      %bbc_6 = "braid.shl"(%bbc_0, %bbc_5) : (i64, i64) -> i64
      %bbc_7 = "braid.or"(%bbc_4, %bbc_6) : (i64, i64) -> i64
      %bbc_9 = "braid.zext"(%bbc_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbc_9) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb10_0 = "braid.zext"(%bb10_1) {bits = 32 : i64} : (i64) -> i64
      %bb10_3 = "braid.get"() {reg = "x1"} : () -> i64
      %bb10_2 = "braid.zext"(%bb10_3) {bits = 32 : i64} : (i64) -> i64
      %bb10_13 = "braid.add"(%bb10_0, %bb10_2) : (i64, i64) -> i64
      %bb10_12 = "braid.zext"(%bb10_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb10_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10014
      %bb14_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb14_0 = "braid.zext"(%bb14_1) {bits = 32 : i64} : (i64) -> i64
      %bb14_3 = "braid.get"() {reg = "x8"} : () -> i64
      %bb14_2 = "braid.zext"(%bb14_3) {bits = 32 : i64} : (i64) -> i64
      %bb14_12 = "braid.and"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      "braid.set"(%bb14_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10018
      %bb18_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb18_6 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb18_0 = "braid.add"(%bb18_1, %bb18_6) : (i64, i64) -> i64
      %bb18_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb18_22 = "braid.add"(%bb18_0, %bb18_21) : (i64, i64) -> i64
      %bb18_23 = "braid.load"(%bb18_0) {bytes = 4 : i64} : (i64) -> i64
      %bb18_26 = "braid.load"(%bb18_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb18_23) {reg = "x15"} : (i64) -> ()
      "braid.set"(%bb18_26) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1001c
      %bb1c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb1c_0 = "braid.zext"(%bb1c_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c_3 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1c_5 = "braid.zext"(%bb1c_3) {bits = 32 : i64} : (i64) -> i64
      %bb1c_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb1c_7 = "braid.mul"(%bb1c_5, %bb1c_6) : (i64, i64) -> i64
      %bb1c_8 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb1c_9 = "braid.lshr"(%bb1c_7, %bb1c_8) : (i64, i64) -> i64
      %bb1c_2 = "braid.zext"(%bb1c_9) {bits = 32 : i64} : (i64) -> i64
      %bb1c_12 = "braid.xor"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      "braid.set"(%bb1c_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10020
      %bb20_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb20_0 = "braid.zext"(%bb20_1) {bits = 32 : i64} : (i64) -> i64
      %bb20_3 = "braid.get"() {reg = "x8"} : () -> i64
      %bb20_2 = "braid.zext"(%bb20_3) {bits = 32 : i64} : (i64) -> i64
      %bb20_13 = "braid.not"(%bb20_2) : (i64) -> i64
      %bb20_12 = "braid.and"(%bb20_0, %bb20_13) : (i64, i64) -> i64
      "braid.set"(%bb20_12) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10024
      %bb24_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb24_0 = "braid.zext"(%bb24_1) {bits = 32 : i64} : (i64) -> i64
      %bb24_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb24_2 = "braid.zext"(%bb24_3) {bits = 32 : i64} : (i64) -> i64
      %bb24_13 = "braid.add"(%bb24_0, %bb24_2) : (i64, i64) -> i64
      %bb24_12 = "braid.zext"(%bb24_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb24_12) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10028
      %bb28_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb28_2 = "braid.zext"(%bb28_1) {bits = 32 : i64} : (i64) -> i64
      %bb28_3 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb28_4 = "braid.lshr"(%bb28_2, %bb28_3) : (i64, i64) -> i64
      %bb28_5 = "braid.const"() {value = 30 : i64} : () -> i64
      %bb28_6 = "braid.shl"(%bb28_0, %bb28_5) : (i64, i64) -> i64
      %bb28_7 = "braid.or"(%bb28_4, %bb28_6) : (i64, i64) -> i64
      %bb28_9 = "braid.zext"(%bb28_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb28_9) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x1002c
      %bb2c_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb2c_0 = "braid.zext"(%bb2c_1) {bits = 32 : i64} : (i64) -> i64
      %bb2c_3 = "braid.get"() {reg = "x18"} : () -> i64
      %bb2c_2 = "braid.zext"(%bb2c_3) {bits = 32 : i64} : (i64) -> i64
      %bb2c_12 = "braid.or"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      "braid.set"(%bb2c_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10030
      %bb30_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb30_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb30_3 = "braid.get"() {reg = "x0"} : () -> i64
      %bb30_8 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb30_2 = "braid.add"(%bb30_3, %bb30_8) : (i64, i64) -> i64
      %bb30_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb30_24 = "braid.add"(%bb30_2, %bb30_23) : (i64, i64) -> i64
      "braid.store"(%bb30_2, %bb30_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb30_24, %bb30_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10034
      %bb34_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb34_0 = "braid.zext"(%bb34_1) {bits = 32 : i64} : (i64) -> i64
      %bb34_3 = "braid.get"() {reg = "x8"} : () -> i64
      %bb34_5 = "braid.zext"(%bb34_3) {bits = 32 : i64} : (i64) -> i64
      %bb34_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb34_7 = "braid.mul"(%bb34_5, %bb34_6) : (i64, i64) -> i64
      %bb34_8 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb34_9 = "braid.lshr"(%bb34_7, %bb34_8) : (i64, i64) -> i64
      %bb34_2 = "braid.zext"(%bb34_9) {bits = 32 : i64} : (i64) -> i64
      %bb34_12 = "braid.xor"(%bb34_0, %bb34_2) : (i64, i64) -> i64
      "braid.set"(%bb34_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x10038
      %bb38_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb38_0 = "braid.zext"(%bb38_1) {bits = 32 : i64} : (i64) -> i64
      %bb38_3 = "braid.get"() {reg = "x18"} : () -> i64
      %bb38_2 = "braid.zext"(%bb38_3) {bits = 32 : i64} : (i64) -> i64
      %bb38_13 = "braid.add"(%bb38_0, %bb38_2) : (i64, i64) -> i64
      %bb38_12 = "braid.zext"(%bb38_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb38_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x1003c
      %bb3c_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb3c_0 = "braid.zext"(%bb3c_1) {bits = 32 : i64} : (i64) -> i64
      %bb3c_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb3c_2 = "braid.zext"(%bb3c_3) {bits = 32 : i64} : (i64) -> i64
      %bb3c_12 = "braid.xor"(%bb3c_0, %bb3c_2) : (i64, i64) -> i64
      "braid.set"(%bb3c_12) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x10040
      %bb40_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb40_0 = "braid.zext"(%bb40_1) {bits = 32 : i64} : (i64) -> i64
      %bb40_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb40_5 = "braid.zext"(%bb40_3) {bits = 32 : i64} : (i64) -> i64
      %bb40_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb40_7 = "braid.mul"(%bb40_5, %bb40_6) : (i64, i64) -> i64
      %bb40_8 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb40_9 = "braid.lshr"(%bb40_7, %bb40_8) : (i64, i64) -> i64
      %bb40_2 = "braid.zext"(%bb40_9) {bits = 32 : i64} : (i64) -> i64
      %bb40_12 = "braid.xor"(%bb40_0, %bb40_2) : (i64, i64) -> i64
      "braid.set"(%bb40_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10044
      %bb44_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb44_0 = "braid.zext"(%bb44_1) {bits = 32 : i64} : (i64) -> i64
      %bb44_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb44_2 = "braid.zext"(%bb44_3) {bits = 32 : i64} : (i64) -> i64
      %bb44_12 = "braid.and"(%bb44_0, %bb44_2) : (i64, i64) -> i64
      "braid.set"(%bb44_12) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x10048
      %bb48_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb48_0 = "braid.zext"(%bb48_1) {bits = 32 : i64} : (i64) -> i64
      %bb48_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb48_2 = "braid.zext"(%bb48_3) {bits = 32 : i64} : (i64) -> i64
      %bb48_12 = "braid.and"(%bb48_0, %bb48_2) : (i64, i64) -> i64
      "braid.set"(%bb48_12) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x1004c
      %bb4c_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb4c_0 = "braid.zext"(%bb4c_1) {bits = 32 : i64} : (i64) -> i64
      %bb4c_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bb4c_2 = "braid.zext"(%bb4c_3) {bits = 32 : i64} : (i64) -> i64
      %bb4c_13 = "braid.add"(%bb4c_0, %bb4c_2) : (i64, i64) -> i64
      %bb4c_12 = "braid.zext"(%bb4c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb4c_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x10050
      %bb50_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb50_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb50_3 = "braid.get"() {reg = "x0"} : () -> i64
      %bb50_8 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb50_2 = "braid.add"(%bb50_3, %bb50_8) : (i64, i64) -> i64
      %bb50_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb50_24 = "braid.add"(%bb50_2, %bb50_23) : (i64, i64) -> i64
      "braid.store"(%bb50_2, %bb50_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb50_24, %bb50_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x10054
      %bb54_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb54_0 = "braid.zext"(%bb54_1) {bits = 32 : i64} : (i64) -> i64
      %bb54_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb54_5 = "braid.zext"(%bb54_3) {bits = 32 : i64} : (i64) -> i64
      %bb54_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb54_7 = "braid.mul"(%bb54_5, %bb54_6) : (i64, i64) -> i64
      %bb54_8 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb54_9 = "braid.lshr"(%bb54_7, %bb54_8) : (i64, i64) -> i64
      %bb54_2 = "braid.zext"(%bb54_9) {bits = 32 : i64} : (i64) -> i64
      %bb54_12 = "braid.xor"(%bb54_0, %bb54_2) : (i64, i64) -> i64
      "braid.set"(%bb54_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x10058
      %bb58_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb58_0 = "braid.zext"(%bb58_1) {bits = 32 : i64} : (i64) -> i64
      %bb58_3 = "braid.get"() {reg = "x16"} : () -> i64
      %bb58_2 = "braid.zext"(%bb58_3) {bits = 32 : i64} : (i64) -> i64
      %bb58_13 = "braid.add"(%bb58_0, %bb58_2) : (i64, i64) -> i64
      %bb58_12 = "braid.zext"(%bb58_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb58_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x1005c
      %bb5c_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb5c_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb5c_3 = "braid.get"() {reg = "x0"} : () -> i64
      %bb5c_8 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb5c_2 = "braid.add"(%bb5c_3, %bb5c_8) : (i64, i64) -> i64
      %bb5c_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb5c_24 = "braid.add"(%bb5c_2, %bb5c_23) : (i64, i64) -> i64
      "braid.store"(%bb5c_2, %bb5c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb5c_24, %bb5c_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x10060
      %bb60_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb60_0 = "braid.zext"(%bb60_1) {bits = 32 : i64} : (i64) -> i64
      %bb60_3 = "braid.get"() {reg = "x1"} : () -> i64
      %bb60_2 = "braid.zext"(%bb60_3) {bits = 32 : i64} : (i64) -> i64
      %bb60_12 = "braid.xor"(%bb60_0, %bb60_2) : (i64, i64) -> i64
      "braid.set"(%bb60_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x10064
      %bb64_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb64_0 = "braid.zext"(%bb64_1) {bits = 32 : i64} : (i64) -> i64
      %bb64_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bb64_2 = "braid.zext"(%bb64_3) {bits = 32 : i64} : (i64) -> i64
      %bb64_13 = "braid.add"(%bb64_0, %bb64_2) : (i64, i64) -> i64
      %bb64_12 = "braid.zext"(%bb64_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb64_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x10068
      %bb68_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb68_0 = "braid.zext"(%bb68_1) {bits = 32 : i64} : (i64) -> i64
      %bb68_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb68_2 = "braid.zext"(%bb68_3) {bits = 32 : i64} : (i64) -> i64
      %bb68_13 = "braid.add"(%bb68_0, %bb68_2) : (i64, i64) -> i64
      %bb68_12 = "braid.zext"(%bb68_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb68_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x1006c
      %bb6c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb6c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb6c_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb6c_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb6c_24 = "braid.add"(%bb6c_2, %bb6c_23) : (i64, i64) -> i64
      "braid.store"(%bb6c_2, %bb6c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb6c_24, %bb6c_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x10070
      %bb70_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb70_0) : (i64) -> ()
  }) {sym_name = "sha256_round", entry = 65536 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10074
      %bb0_0 = "braid.const"() {value = 48 : i64} : () -> i64
      "braid.set"(%bb0_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10078
      %bb4_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_2 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb4_3 = "braid.add"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1007c
      %bb8_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb8_6 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb8_0 = "braid.add"(%bb8_1, %bb8_6) : (i64, i64) -> i64
      %bb8_30 = "braid.load"(%bb8_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb8_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10080
      %bbc_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bbc_6 = "braid.const"() {value = -28 : i64} : () -> i64
      %bbc_0 = "braid.add"(%bbc_1, %bbc_6) : (i64, i64) -> i64
      %bbc_30 = "braid.load"(%bbc_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbc_30) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10084
      %bb10_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb10_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_3 = "braid.sub"(%bb10_0, %bb10_2) : (i64, i64) -> i64
      %bb10_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_4 = "braid.slt"(%bb10_3, %bb10_8) : (i64, i64) -> i64
      %bb10_5 = "braid.eq"(%bb10_0, %bb10_2) : (i64, i64) -> i64
      %bb10_6 = "braid.ule"(%bb10_2, %bb10_0) : (i64, i64) -> i64
      %bb10_9 = "braid.xor"(%bb10_0, %bb10_2) : (i64, i64) -> i64
      %bb10_10 = "braid.xor"(%bb10_0, %bb10_3) : (i64, i64) -> i64
      %bb10_11 = "braid.and"(%bb10_9, %bb10_10) : (i64, i64) -> i64
      %bb10_7 = "braid.slt"(%bb10_11, %bb10_8) : (i64, i64) -> i64
      "braid.setf"(%bb10_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb10_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb10_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb10_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb10_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10088
      %bb14_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb14_6 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb14_0 = "braid.add"(%bb14_1, %bb14_6) : (i64, i64) -> i64
      %bb14_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb14_22 = "braid.add"(%bb14_0, %bb14_21) : (i64, i64) -> i64
      %bb14_23 = "braid.load"(%bb14_0) {bytes = 4 : i64} : (i64) -> i64
      %bb14_26 = "braid.load"(%bb14_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb14_23) {reg = "x13"} : (i64) -> ()
      "braid.set"(%bb14_26) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x1008c
      %bb18_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb18_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb18_2 = "braid.zext"(%bb18_1) {bits = 32 : i64} : (i64) -> i64
      %bb18_3 = "braid.const"() {value = 17 : i64} : () -> i64
      %bb18_4 = "braid.lshr"(%bb18_2, %bb18_3) : (i64, i64) -> i64
      %bb18_5 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb18_6 = "braid.shl"(%bb18_0, %bb18_5) : (i64, i64) -> i64
      %bb18_7 = "braid.or"(%bb18_4, %bb18_6) : (i64, i64) -> i64
      %bb18_9 = "braid.zext"(%bb18_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb18_9) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10090
      %bb1c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb1c_2 = "braid.zext"(%bb1c_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1c_4 = "braid.lshr"(%bb1c_2, %bb1c_3) : (i64, i64) -> i64
      %bb1c_5 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1c_6 = "braid.shl"(%bb1c_0, %bb1c_5) : (i64, i64) -> i64
      %bb1c_7 = "braid.or"(%bb1c_4, %bb1c_6) : (i64, i64) -> i64
      %bb1c_9 = "braid.zext"(%bb1c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1c_9) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10094
      %bb20_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb20_0 = "braid.zext"(%bb20_1) {bits = 32 : i64} : (i64) -> i64
      %bb20_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb20_5 = "braid.zext"(%bb20_3) {bits = 32 : i64} : (i64) -> i64
      %bb20_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb20_7 = "braid.mul"(%bb20_5, %bb20_6) : (i64, i64) -> i64
      %bb20_8 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb20_9 = "braid.lshr"(%bb20_7, %bb20_8) : (i64, i64) -> i64
      %bb20_2 = "braid.zext"(%bb20_9) {bits = 32 : i64} : (i64) -> i64
      %bb20_12 = "braid.xor"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      "braid.set"(%bb20_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10098
      %bb24_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb24_0 = "braid.zext"(%bb24_1) {bits = 32 : i64} : (i64) -> i64
      %bb24_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb24_5 = "braid.zext"(%bb24_3) {bits = 32 : i64} : (i64) -> i64
      %bb24_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb24_7 = "braid.mul"(%bb24_5, %bb24_6) : (i64, i64) -> i64
      %bb24_8 = "braid.const"() {value = 18 : i64} : () -> i64
      %bb24_9 = "braid.lshr"(%bb24_7, %bb24_8) : (i64, i64) -> i64
      %bb24_2 = "braid.zext"(%bb24_9) {bits = 32 : i64} : (i64) -> i64
      %bb24_12 = "braid.xor"(%bb24_0, %bb24_2) : (i64, i64) -> i64
      "braid.set"(%bb24_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x1009c
      %bb28_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb28_0 = "braid.zext"(%bb28_1) {bits = 32 : i64} : (i64) -> i64
      %bb28_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb28_5 = "braid.zext"(%bb28_3) {bits = 32 : i64} : (i64) -> i64
      %bb28_6 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb28_2 = "braid.lshr"(%bb28_5, %bb28_6) : (i64, i64) -> i64
      %bb28_12 = "braid.xor"(%bb28_0, %bb28_2) : (i64, i64) -> i64
      "braid.set"(%bb28_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x100a0
      %bb2c_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb2c_0 = "braid.zext"(%bb2c_1) {bits = 32 : i64} : (i64) -> i64
      %bb2c_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb2c_2 = "braid.zext"(%bb2c_3) {bits = 32 : i64} : (i64) -> i64
      %bb2c_13 = "braid.add"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      %bb2c_12 = "braid.zext"(%bb2c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2c_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x100a4
      %bb30_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb30_0 = "braid.zext"(%bb30_1) {bits = 32 : i64} : (i64) -> i64
      %bb30_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb30_5 = "braid.zext"(%bb30_3) {bits = 32 : i64} : (i64) -> i64
      %bb30_6 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb30_2 = "braid.lshr"(%bb30_5, %bb30_6) : (i64, i64) -> i64
      %bb30_12 = "braid.xor"(%bb30_0, %bb30_2) : (i64, i64) -> i64
      "braid.set"(%bb30_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x100a8
      %bb34_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb34_0 = "braid.zext"(%bb34_1) {bits = 32 : i64} : (i64) -> i64
      %bb34_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bb34_2 = "braid.zext"(%bb34_3) {bits = 32 : i64} : (i64) -> i64
      %bb34_13 = "braid.add"(%bb34_0, %bb34_2) : (i64, i64) -> i64
      %bb34_12 = "braid.zext"(%bb34_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb34_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x100ac
      %bb38_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb38_0 = "braid.zext"(%bb38_1) {bits = 32 : i64} : (i64) -> i64
      %bb38_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb38_2 = "braid.zext"(%bb38_3) {bits = 32 : i64} : (i64) -> i64
      %bb38_13 = "braid.add"(%bb38_0, %bb38_2) : (i64, i64) -> i64
      %bb38_12 = "braid.zext"(%bb38_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb38_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x100b0
      %bb3c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb3c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb3c_6 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb3c_7 = "braid.add"(%bb3c_1, %bb3c_6) : (i64, i64) -> i64
      "braid.set"(%bb3c_7) {reg = "x9"} : (i64) -> ()
      "braid.store"(%bb3c_1, %bb3c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x100b4
      %bb40_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb40_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb40_0 = "braid.eq"(%bb40_1, %bb40_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb40_0)[^bb8, ^bb44] : (i64) -> ()
    ^bb44:  // 0x100b8
      %bb44_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb44_0) : (i64) -> ()
  }) {sym_name = "sha256_schedule", entry = 65652 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x100bc
      %bb0_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb0_2 = "braid.const"() {value = 304 : i64} : () -> i64
      %bb0_3 = "braid.sub"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_3) {reg = "sp"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x100c0
      %bb4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_12 = "braid.or"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x100c4
      %bb8_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb8_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb8_3 = "braid.add"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x100c8
      %bbc_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bbc_2 = "braid.get"() {reg = "sp"} : () -> i64
      %bbc_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bbc_4 = "braid.and"(%bbc_2, %bbc_3) : (i64, i64) -> i64
      %bbc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_6 = "braid.eq"(%bbc_4, %bbc_5) : (i64, i64) -> i64
      "braid.guard"(%bbc_6) : (i64) -> ()
      %bbc_7 = "braid.const"() {value = 288 : i64} : () -> i64
      %bbc_1 = "braid.add"(%bbc_2, %bbc_7) : (i64, i64) -> i64
      "braid.store"(%bbc_1, %bbc_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x100cc
      %bb10_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb10_6 = "braid.get"() {reg = "x8"} : () -> i64
      %bb10_0 = "braid.add"(%bb10_1, %bb10_6) : (i64, i64) -> i64
      %bb10_30 = "braid.load"(%bb10_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb10_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x100d0
      %bb14_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb14_2 = "braid.get"() {reg = "x9"} : () -> i64
      %bb14_7 = "braid.get"() {reg = "x8"} : () -> i64
      %bb14_1 = "braid.add"(%bb14_2, %bb14_7) : (i64, i64) -> i64
      "braid.store"(%bb14_1, %bb14_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x100d4
      %bb18_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb18_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb18_3 = "braid.add"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      "braid.set"(%bb18_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x100d8
      %bb1c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1c_2 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb1c_3 = "braid.sub"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      %bb1c_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_4 = "braid.slt"(%bb1c_3, %bb1c_8) : (i64, i64) -> i64
      %bb1c_5 = "braid.eq"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      %bb1c_6 = "braid.ule"(%bb1c_2, %bb1c_0) : (i64, i64) -> i64
      %bb1c_9 = "braid.xor"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      %bb1c_10 = "braid.xor"(%bb1c_0, %bb1c_3) : (i64, i64) -> i64
      %bb1c_11 = "braid.and"(%bb1c_9, %bb1c_10) : (i64, i64) -> i64
      %bb1c_7 = "braid.slt"(%bb1c_11, %bb1c_8) : (i64, i64) -> i64
      "braid.setf"(%bb1c_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb1c_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb1c_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb1c_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x100dc
      %bb20_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb20_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_0 = "braid.eq"(%bb20_1, %bb20_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb20_0)[^bb10, ^bb24] : (i64) -> ()
    ^bb24:  // 0x100e0
      %bb24_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb24_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb24_3 = "braid.add"(%bb24_0, %bb24_2) : (i64, i64) -> i64
      "braid.set"(%bb24_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x100e4
      %bb28_0 = "braid.const"() {value = 48 : i64} : () -> i64
      "braid.set"(%bb28_0) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x100e8
      %bb2c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb2c_2 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb2c_3 = "braid.add"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      "braid.set"(%bb2c_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x100ec
      %bb30_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb30_6 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb30_0 = "braid.add"(%bb30_1, %bb30_6) : (i64, i64) -> i64
      %bb30_30 = "braid.load"(%bb30_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb30_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x100f0
      %bb34_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb34_6 = "braid.const"() {value = -28 : i64} : () -> i64
      %bb34_0 = "braid.add"(%bb34_1, %bb34_6) : (i64, i64) -> i64
      %bb34_30 = "braid.load"(%bb34_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb34_30) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x100f4
      %bb38_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb38_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb38_3 = "braid.sub"(%bb38_0, %bb38_2) : (i64, i64) -> i64
      %bb38_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb38_4 = "braid.slt"(%bb38_3, %bb38_8) : (i64, i64) -> i64
      %bb38_5 = "braid.eq"(%bb38_0, %bb38_2) : (i64, i64) -> i64
      %bb38_6 = "braid.ule"(%bb38_2, %bb38_0) : (i64, i64) -> i64
      %bb38_9 = "braid.xor"(%bb38_0, %bb38_2) : (i64, i64) -> i64
      %bb38_10 = "braid.xor"(%bb38_0, %bb38_3) : (i64, i64) -> i64
      %bb38_11 = "braid.and"(%bb38_9, %bb38_10) : (i64, i64) -> i64
      %bb38_7 = "braid.slt"(%bb38_11, %bb38_8) : (i64, i64) -> i64
      "braid.setf"(%bb38_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb38_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb38_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb38_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb38_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x100f8
      %bb3c_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb3c_6 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb3c_0 = "braid.add"(%bb3c_1, %bb3c_6) : (i64, i64) -> i64
      %bb3c_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb3c_22 = "braid.add"(%bb3c_0, %bb3c_21) : (i64, i64) -> i64
      %bb3c_23 = "braid.load"(%bb3c_0) {bytes = 4 : i64} : (i64) -> i64
      %bb3c_26 = "braid.load"(%bb3c_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb3c_23) {reg = "x13"} : (i64) -> ()
      "braid.set"(%bb3c_26) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x100fc
      %bb40_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb40_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb40_2 = "braid.zext"(%bb40_1) {bits = 32 : i64} : (i64) -> i64
      %bb40_3 = "braid.const"() {value = 17 : i64} : () -> i64
      %bb40_4 = "braid.lshr"(%bb40_2, %bb40_3) : (i64, i64) -> i64
      %bb40_5 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb40_6 = "braid.shl"(%bb40_0, %bb40_5) : (i64, i64) -> i64
      %bb40_7 = "braid.or"(%bb40_4, %bb40_6) : (i64, i64) -> i64
      %bb40_9 = "braid.zext"(%bb40_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb40_9) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10100
      %bb44_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb44_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb44_2 = "braid.zext"(%bb44_1) {bits = 32 : i64} : (i64) -> i64
      %bb44_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb44_4 = "braid.lshr"(%bb44_2, %bb44_3) : (i64, i64) -> i64
      %bb44_5 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb44_6 = "braid.shl"(%bb44_0, %bb44_5) : (i64, i64) -> i64
      %bb44_7 = "braid.or"(%bb44_4, %bb44_6) : (i64, i64) -> i64
      %bb44_9 = "braid.zext"(%bb44_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb44_9) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x10104
      %bb48_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb48_0 = "braid.zext"(%bb48_1) {bits = 32 : i64} : (i64) -> i64
      %bb48_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb48_5 = "braid.zext"(%bb48_3) {bits = 32 : i64} : (i64) -> i64
      %bb48_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb48_7 = "braid.mul"(%bb48_5, %bb48_6) : (i64, i64) -> i64
      %bb48_8 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb48_9 = "braid.lshr"(%bb48_7, %bb48_8) : (i64, i64) -> i64
      %bb48_2 = "braid.zext"(%bb48_9) {bits = 32 : i64} : (i64) -> i64
      %bb48_12 = "braid.xor"(%bb48_0, %bb48_2) : (i64, i64) -> i64
      "braid.set"(%bb48_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x10108
      %bb4c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb4c_0 = "braid.zext"(%bb4c_1) {bits = 32 : i64} : (i64) -> i64
      %bb4c_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb4c_5 = "braid.zext"(%bb4c_3) {bits = 32 : i64} : (i64) -> i64
      %bb4c_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb4c_7 = "braid.mul"(%bb4c_5, %bb4c_6) : (i64, i64) -> i64
      %bb4c_8 = "braid.const"() {value = 18 : i64} : () -> i64
      %bb4c_9 = "braid.lshr"(%bb4c_7, %bb4c_8) : (i64, i64) -> i64
      %bb4c_2 = "braid.zext"(%bb4c_9) {bits = 32 : i64} : (i64) -> i64
      %bb4c_12 = "braid.xor"(%bb4c_0, %bb4c_2) : (i64, i64) -> i64
      "braid.set"(%bb4c_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x1010c
      %bb50_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb50_0 = "braid.zext"(%bb50_1) {bits = 32 : i64} : (i64) -> i64
      %bb50_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb50_5 = "braid.zext"(%bb50_3) {bits = 32 : i64} : (i64) -> i64
      %bb50_6 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb50_2 = "braid.lshr"(%bb50_5, %bb50_6) : (i64, i64) -> i64
      %bb50_12 = "braid.xor"(%bb50_0, %bb50_2) : (i64, i64) -> i64
      "braid.set"(%bb50_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x10110
      %bb54_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb54_0 = "braid.zext"(%bb54_1) {bits = 32 : i64} : (i64) -> i64
      %bb54_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb54_2 = "braid.zext"(%bb54_3) {bits = 32 : i64} : (i64) -> i64
      %bb54_13 = "braid.add"(%bb54_0, %bb54_2) : (i64, i64) -> i64
      %bb54_12 = "braid.zext"(%bb54_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb54_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x10114
      %bb58_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb58_0 = "braid.zext"(%bb58_1) {bits = 32 : i64} : (i64) -> i64
      %bb58_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb58_5 = "braid.zext"(%bb58_3) {bits = 32 : i64} : (i64) -> i64
      %bb58_6 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb58_2 = "braid.lshr"(%bb58_5, %bb58_6) : (i64, i64) -> i64
      %bb58_12 = "braid.xor"(%bb58_0, %bb58_2) : (i64, i64) -> i64
      "braid.set"(%bb58_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x10118
      %bb5c_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb5c_0 = "braid.zext"(%bb5c_1) {bits = 32 : i64} : (i64) -> i64
      %bb5c_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bb5c_2 = "braid.zext"(%bb5c_3) {bits = 32 : i64} : (i64) -> i64
      %bb5c_13 = "braid.add"(%bb5c_0, %bb5c_2) : (i64, i64) -> i64
      %bb5c_12 = "braid.zext"(%bb5c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb5c_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x1011c
      %bb60_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb60_0 = "braid.zext"(%bb60_1) {bits = 32 : i64} : (i64) -> i64
      %bb60_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb60_2 = "braid.zext"(%bb60_3) {bits = 32 : i64} : (i64) -> i64
      %bb60_13 = "braid.add"(%bb60_0, %bb60_2) : (i64, i64) -> i64
      %bb60_12 = "braid.zext"(%bb60_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb60_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x10120
      %bb64_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb64_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb64_6 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb64_7 = "braid.add"(%bb64_1, %bb64_6) : (i64, i64) -> i64
      "braid.set"(%bb64_7) {reg = "x8"} : (i64) -> ()
      "braid.store"(%bb64_1, %bb64_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x10124
      %bb68_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb68_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb68_0 = "braid.eq"(%bb68_1, %bb68_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb68_0)[^bb30, ^bb6c] : (i64) -> ()
    ^bb6c:  // 0x10128
      %bb6c_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6c_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6c_12 = "braid.or"(%bb6c_0, %bb6c_2) : (i64, i64) -> i64
      "braid.set"(%bb6c_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x1012c
      %bb70_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb70_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb70_3 = "braid.add"(%bb70_0, %bb70_2) : (i64, i64) -> i64
      "braid.set"(%bb70_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x10130
      %bb74_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb74_6 = "braid.get"() {reg = "x8"} : () -> i64
      %bb74_0 = "braid.add"(%bb74_1, %bb74_6) : (i64, i64) -> i64
      %bb74_30 = "braid.load"(%bb74_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb74_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x10134
      %bb78_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb78_2 = "braid.get"() {reg = "x9"} : () -> i64
      %bb78_7 = "braid.get"() {reg = "x8"} : () -> i64
      %bb78_1 = "braid.add"(%bb78_2, %bb78_7) : (i64, i64) -> i64
      "braid.store"(%bb78_1, %bb78_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x10138
      %bb7c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb7c_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb7c_3 = "braid.add"(%bb7c_0, %bb7c_2) : (i64, i64) -> i64
      "braid.set"(%bb7c_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x1013c
      %bb80_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb80_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb80_3 = "braid.sub"(%bb80_0, %bb80_2) : (i64, i64) -> i64
      %bb80_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb80_4 = "braid.slt"(%bb80_3, %bb80_8) : (i64, i64) -> i64
      %bb80_5 = "braid.eq"(%bb80_0, %bb80_2) : (i64, i64) -> i64
      %bb80_6 = "braid.ule"(%bb80_2, %bb80_0) : (i64, i64) -> i64
      %bb80_9 = "braid.xor"(%bb80_0, %bb80_2) : (i64, i64) -> i64
      %bb80_10 = "braid.xor"(%bb80_0, %bb80_3) : (i64, i64) -> i64
      %bb80_11 = "braid.and"(%bb80_9, %bb80_10) : (i64, i64) -> i64
      %bb80_7 = "braid.slt"(%bb80_11, %bb80_8) : (i64, i64) -> i64
      "braid.setf"(%bb80_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb80_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb80_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb80_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x10140
      %bb84_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb84_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb84_0 = "braid.eq"(%bb84_1, %bb84_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb84_0)[^bb74, ^bb88] : (i64) -> ()
    ^bb88:  // 0x10144
      %bb88_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb88_1 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb88_2 = "braid.and"(%bb88_0, %bb88_1) : (i64, i64) -> i64
      %bb88_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb88_4 = "braid.eq"(%bb88_2, %bb88_3) : (i64, i64) -> i64
      "braid.guard"(%bb88_4) : (i64) -> ()
      %bb88_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb88_22 = "braid.add"(%bb88_0, %bb88_21) : (i64, i64) -> i64
      %bb88_23 = "braid.load"(%bb88_0) {bytes = 4 : i64} : (i64) -> i64
      %bb88_26 = "braid.load"(%bb88_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb88_23) {reg = "x17"} : (i64) -> ()
      "braid.set"(%bb88_26) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x10148
      %bb8c_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb8c_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb8c_3 = "braid.and"(%bb8c_1, %bb8c_2) : (i64, i64) -> i64
      %bb8c_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8c_5 = "braid.eq"(%bb8c_3, %bb8c_4) : (i64, i64) -> i64
      "braid.guard"(%bb8c_5) : (i64) -> ()
      %bb8c_6 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8c_0 = "braid.add"(%bb8c_1, %bb8c_6) : (i64, i64) -> i64
      %bb8c_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb8c_22 = "braid.add"(%bb8c_0, %bb8c_21) : (i64, i64) -> i64
      %bb8c_23 = "braid.load"(%bb8c_0) {bytes = 4 : i64} : (i64) -> i64
      %bb8c_26 = "braid.load"(%bb8c_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb8c_23) {reg = "x10"} : (i64) -> ()
      "braid.set"(%bb8c_26) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x1014c
      %bb90_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb90_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb90_3 = "braid.and"(%bb90_1, %bb90_2) : (i64, i64) -> i64
      %bb90_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb90_5 = "braid.eq"(%bb90_3, %bb90_4) : (i64, i64) -> i64
      "braid.guard"(%bb90_5) : (i64) -> ()
      %bb90_6 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb90_0 = "braid.add"(%bb90_1, %bb90_6) : (i64, i64) -> i64
      %bb90_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb90_22 = "braid.add"(%bb90_0, %bb90_21) : (i64, i64) -> i64
      %bb90_23 = "braid.load"(%bb90_0) {bytes = 4 : i64} : (i64) -> i64
      %bb90_26 = "braid.load"(%bb90_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb90_23) {reg = "x18"} : (i64) -> ()
      "braid.set"(%bb90_26) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x10150
      %bb94_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb94_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb94_3 = "braid.and"(%bb94_1, %bb94_2) : (i64, i64) -> i64
      %bb94_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb94_5 = "braid.eq"(%bb94_3, %bb94_4) : (i64, i64) -> i64
      "braid.guard"(%bb94_5) : (i64) -> ()
      %bb94_6 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb94_0 = "braid.add"(%bb94_1, %bb94_6) : (i64, i64) -> i64
      %bb94_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb94_22 = "braid.add"(%bb94_0, %bb94_21) : (i64, i64) -> i64
      %bb94_23 = "braid.load"(%bb94_0) {bytes = 4 : i64} : (i64) -> i64
      %bb94_26 = "braid.load"(%bb94_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb94_23) {reg = "x13"} : (i64) -> ()
      "braid.set"(%bb94_26) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x10154
      %bb98_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb98_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb98_12 = "braid.or"(%bb98_0, %bb98_2) : (i64, i64) -> i64
      "braid.set"(%bb98_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x10158
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x1015c
      %bba0_0 = "braid.const"() {value = 131624 : i64} : () -> i64
      "braid.set"(%bba0_0) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bba4] : () -> ()
    ^bba4:  // 0x10160
      %bba4_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bba4_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bba4_3 = "braid.add"(%bba4_0, %bba4_2) : (i64, i64) -> i64
      "braid.set"(%bba4_3) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x10164
      %bba8_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bba8_6 = "braid.get"() {reg = "x8"} : () -> i64
      %bba8_0 = "braid.add"(%bba8_1, %bba8_6) : (i64, i64) -> i64
      %bba8_30 = "braid.load"(%bba8_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bba8_30) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x10168
      %bbac_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bbac_6 = "braid.get"() {reg = "x8"} : () -> i64
      %bbac_0 = "braid.add"(%bbac_1, %bbac_6) : (i64, i64) -> i64
      %bbac_30 = "braid.load"(%bbac_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbac_30) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x1016c
      %bbb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb0_0 = "braid.zext"(%bbb0_1) {bits = 32 : i64} : (i64) -> i64
      %bbb0_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bbb0_2 = "braid.zext"(%bbb0_3) {bits = 32 : i64} : (i64) -> i64
      %bbb0_12 = "braid.or"(%bbb0_0, %bbb0_2) : (i64, i64) -> i64
      "braid.set"(%bbb0_12) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x10170
      %bbb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb4_0 = "braid.zext"(%bbb4_1) {bits = 32 : i64} : (i64) -> i64
      %bbb4_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bbb4_2 = "braid.zext"(%bbb4_3) {bits = 32 : i64} : (i64) -> i64
      %bbb4_12 = "braid.or"(%bbb4_0, %bbb4_2) : (i64, i64) -> i64
      "braid.set"(%bbb4_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x10174
      %bbb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb8_0 = "braid.zext"(%bbb8_1) {bits = 32 : i64} : (i64) -> i64
      %bbb8_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bbb8_2 = "braid.zext"(%bbb8_3) {bits = 32 : i64} : (i64) -> i64
      %bbb8_12 = "braid.or"(%bbb8_0, %bbb8_2) : (i64, i64) -> i64
      "braid.set"(%bbb8_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x10178
      %bbbc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbbc_0 = "braid.zext"(%bbbc_1) {bits = 32 : i64} : (i64) -> i64
      %bbbc_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bbbc_2 = "braid.zext"(%bbbc_3) {bits = 32 : i64} : (i64) -> i64
      %bbbc_12 = "braid.or"(%bbbc_0, %bbbc_2) : (i64, i64) -> i64
      "braid.set"(%bbbc_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bbc0:  // 0x1017c
      %bbc0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc0_0 = "braid.zext"(%bbc0_1) {bits = 32 : i64} : (i64) -> i64
      %bbc0_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bbc0_2 = "braid.zext"(%bbc0_3) {bits = 32 : i64} : (i64) -> i64
      %bbc0_12 = "braid.or"(%bbc0_0, %bbc0_2) : (i64, i64) -> i64
      "braid.set"(%bbc0_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x10180
      %bbc4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc4_0 = "braid.zext"(%bbc4_1) {bits = 32 : i64} : (i64) -> i64
      %bbc4_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bbc4_2 = "braid.zext"(%bbc4_3) {bits = 32 : i64} : (i64) -> i64
      %bbc4_12 = "braid.or"(%bbc4_0, %bbc4_2) : (i64, i64) -> i64
      "braid.set"(%bbc4_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x10184
      %bbc8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc8_0 = "braid.zext"(%bbc8_1) {bits = 32 : i64} : (i64) -> i64
      %bbc8_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bbc8_2 = "braid.zext"(%bbc8_3) {bits = 32 : i64} : (i64) -> i64
      %bbc8_12 = "braid.or"(%bbc8_0, %bbc8_2) : (i64, i64) -> i64
      "braid.set"(%bbc8_12) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x10188
      %bbcc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbcc_0 = "braid.zext"(%bbcc_1) {bits = 32 : i64} : (i64) -> i64
      %bbcc_3 = "braid.get"() {reg = "x18"} : () -> i64
      %bbcc_2 = "braid.zext"(%bbcc_3) {bits = 32 : i64} : (i64) -> i64
      %bbcc_12 = "braid.or"(%bbcc_0, %bbcc_2) : (i64, i64) -> i64
      "braid.set"(%bbcc_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x1018c
      %bbd0_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bbd0_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bbd0_2 = "braid.zext"(%bbd0_1) {bits = 32 : i64} : (i64) -> i64
      %bbd0_3 = "braid.const"() {value = 6 : i64} : () -> i64
      %bbd0_4 = "braid.lshr"(%bbd0_2, %bbd0_3) : (i64, i64) -> i64
      %bbd0_5 = "braid.const"() {value = 26 : i64} : () -> i64
      %bbd0_6 = "braid.shl"(%bbd0_0, %bbd0_5) : (i64, i64) -> i64
      %bbd0_7 = "braid.or"(%bbd0_4, %bbd0_6) : (i64, i64) -> i64
      %bbd0_9 = "braid.zext"(%bbd0_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd0_9) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x10190
      %bbd4_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bbd4_0 = "braid.zext"(%bbd4_1) {bits = 32 : i64} : (i64) -> i64
      %bbd4_3 = "braid.get"() {reg = "x1"} : () -> i64
      %bbd4_2 = "braid.zext"(%bbd4_3) {bits = 32 : i64} : (i64) -> i64
      %bbd4_13 = "braid.add"(%bbd4_0, %bbd4_2) : (i64, i64) -> i64
      %bbd4_12 = "braid.zext"(%bbd4_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd4_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bbd8] : () -> ()
    ^bbd8:  // 0x10194
      %bbd8_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bbd8_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bbd8_2 = "braid.zext"(%bbd8_1) {bits = 32 : i64} : (i64) -> i64
      %bbd8_3 = "braid.const"() {value = 2 : i64} : () -> i64
      %bbd8_4 = "braid.lshr"(%bbd8_2, %bbd8_3) : (i64, i64) -> i64
      %bbd8_5 = "braid.const"() {value = 30 : i64} : () -> i64
      %bbd8_6 = "braid.shl"(%bbd8_0, %bbd8_5) : (i64, i64) -> i64
      %bbd8_7 = "braid.or"(%bbd8_4, %bbd8_6) : (i64, i64) -> i64
      %bbd8_9 = "braid.zext"(%bbd8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd8_9) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x10198
      %bbdc_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bbdc_0 = "braid.zext"(%bbdc_1) {bits = 32 : i64} : (i64) -> i64
      %bbdc_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bbdc_2 = "braid.zext"(%bbdc_3) {bits = 32 : i64} : (i64) -> i64
      %bbdc_13 = "braid.add"(%bbdc_0, %bbdc_2) : (i64, i64) -> i64
      %bbdc_12 = "braid.zext"(%bbdc_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbdc_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bbe0] : () -> ()
    ^bbe0:  // 0x1019c
      %bbe0_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bbe0_0 = "braid.zext"(%bbe0_1) {bits = 32 : i64} : (i64) -> i64
      %bbe0_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bbe0_2 = "braid.zext"(%bbe0_3) {bits = 32 : i64} : (i64) -> i64
      %bbe0_12 = "braid.and"(%bbe0_0, %bbe0_2) : (i64, i64) -> i64
      "braid.set"(%bbe0_12) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x101a0
      %bbe4_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bbe4_0 = "braid.zext"(%bbe4_1) {bits = 32 : i64} : (i64) -> i64
      %bbe4_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bbe4_5 = "braid.zext"(%bbe4_3) {bits = 32 : i64} : (i64) -> i64
      %bbe4_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bbe4_7 = "braid.mul"(%bbe4_5, %bbe4_6) : (i64, i64) -> i64
      %bbe4_8 = "braid.const"() {value = 11 : i64} : () -> i64
      %bbe4_9 = "braid.lshr"(%bbe4_7, %bbe4_8) : (i64, i64) -> i64
      %bbe4_2 = "braid.zext"(%bbe4_9) {bits = 32 : i64} : (i64) -> i64
      %bbe4_12 = "braid.xor"(%bbe4_0, %bbe4_2) : (i64, i64) -> i64
      "braid.set"(%bbe4_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbe8] : () -> ()
    ^bbe8:  // 0x101a4
      %bbe8_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bbe8_0 = "braid.zext"(%bbe8_1) {bits = 32 : i64} : (i64) -> i64
      %bbe8_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bbe8_2 = "braid.zext"(%bbe8_3) {bits = 32 : i64} : (i64) -> i64
      %bbe8_13 = "braid.not"(%bbe8_2) : (i64) -> i64
      %bbe8_12 = "braid.and"(%bbe8_0, %bbe8_13) : (i64, i64) -> i64
      "braid.set"(%bbe8_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bbec] : () -> ()
    ^bbec:  // 0x101a8
      %bbec_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bbec_0 = "braid.zext"(%bbec_1) {bits = 32 : i64} : (i64) -> i64
      %bbec_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bbec_2 = "braid.zext"(%bbec_3) {bits = 32 : i64} : (i64) -> i64
      %bbec_12 = "braid.and"(%bbec_0, %bbec_2) : (i64, i64) -> i64
      "braid.set"(%bbec_12) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bbf0] : () -> ()
    ^bbf0:  // 0x101ac
      %bbf0_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bbf0_0 = "braid.zext"(%bbf0_1) {bits = 32 : i64} : (i64) -> i64
      %bbf0_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bbf0_5 = "braid.zext"(%bbf0_3) {bits = 32 : i64} : (i64) -> i64
      %bbf0_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bbf0_7 = "braid.mul"(%bbf0_5, %bbf0_6) : (i64, i64) -> i64
      %bbf0_8 = "braid.const"() {value = 13 : i64} : () -> i64
      %bbf0_9 = "braid.lshr"(%bbf0_7, %bbf0_8) : (i64, i64) -> i64
      %bbf0_2 = "braid.zext"(%bbf0_9) {bits = 32 : i64} : (i64) -> i64
      %bbf0_12 = "braid.xor"(%bbf0_0, %bbf0_2) : (i64, i64) -> i64
      "braid.set"(%bbf0_12) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bbf4] : () -> ()
    ^bbf4:  // 0x101b0
      %bbf4_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bbf4_0 = "braid.zext"(%bbf4_1) {bits = 32 : i64} : (i64) -> i64
      %bbf4_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bbf4_2 = "braid.zext"(%bbf4_3) {bits = 32 : i64} : (i64) -> i64
      %bbf4_12 = "braid.or"(%bbf4_0, %bbf4_2) : (i64, i64) -> i64
      "braid.set"(%bbf4_12) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bbf8] : () -> ()
    ^bbf8:  // 0x101b4
      %bbf8_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bbf8_0 = "braid.zext"(%bbf8_1) {bits = 32 : i64} : (i64) -> i64
      %bbf8_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bbf8_2 = "braid.zext"(%bbf8_3) {bits = 32 : i64} : (i64) -> i64
      %bbf8_12 = "braid.xor"(%bbf8_0, %bbf8_2) : (i64, i64) -> i64
      "braid.set"(%bbf8_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bbfc] : () -> ()
    ^bbfc:  // 0x101b8
      %bbfc_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bbfc_0 = "braid.zext"(%bbfc_1) {bits = 32 : i64} : (i64) -> i64
      %bbfc_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bbfc_5 = "braid.zext"(%bbfc_3) {bits = 32 : i64} : (i64) -> i64
      %bbfc_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bbfc_7 = "braid.mul"(%bbfc_5, %bbfc_6) : (i64, i64) -> i64
      %bbfc_8 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbfc_9 = "braid.lshr"(%bbfc_7, %bbfc_8) : (i64, i64) -> i64
      %bbfc_2 = "braid.zext"(%bbfc_9) {bits = 32 : i64} : (i64) -> i64
      %bbfc_12 = "braid.xor"(%bbfc_0, %bbfc_2) : (i64, i64) -> i64
      "braid.set"(%bbfc_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb100:  // 0x101bc
      %bb100_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb100_0 = "braid.zext"(%bb100_1) {bits = 32 : i64} : (i64) -> i64
      %bb100_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb100_2 = "braid.zext"(%bb100_3) {bits = 32 : i64} : (i64) -> i64
      %bb100_12 = "braid.and"(%bb100_0, %bb100_2) : (i64, i64) -> i64
      "braid.set"(%bb100_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bb104] : () -> ()
    ^bb104:  // 0x101c0
      %bb104_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb104_0 = "braid.zext"(%bb104_1) {bits = 32 : i64} : (i64) -> i64
      %bb104_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bb104_2 = "braid.zext"(%bb104_3) {bits = 32 : i64} : (i64) -> i64
      %bb104_13 = "braid.add"(%bb104_0, %bb104_2) : (i64, i64) -> i64
      %bb104_12 = "braid.zext"(%bb104_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb104_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x101c4
      %bb108_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb108_0 = "braid.zext"(%bb108_1) {bits = 32 : i64} : (i64) -> i64
      %bb108_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb108_5 = "braid.zext"(%bb108_3) {bits = 32 : i64} : (i64) -> i64
      %bb108_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb108_7 = "braid.mul"(%bb108_5, %bb108_6) : (i64, i64) -> i64
      %bb108_8 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb108_9 = "braid.lshr"(%bb108_7, %bb108_8) : (i64, i64) -> i64
      %bb108_2 = "braid.zext"(%bb108_9) {bits = 32 : i64} : (i64) -> i64
      %bb108_12 = "braid.xor"(%bb108_0, %bb108_2) : (i64, i64) -> i64
      "braid.set"(%bb108_12) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bb10c] : () -> ()
    ^bb10c:  // 0x101c8
      %bb10c_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb10c_0 = "braid.zext"(%bb10c_1) {bits = 32 : i64} : (i64) -> i64
      %bb10c_3 = "braid.get"() {reg = "x5"} : () -> i64
      %bb10c_2 = "braid.zext"(%bb10c_3) {bits = 32 : i64} : (i64) -> i64
      %bb10c_12 = "braid.xor"(%bb10c_0, %bb10c_2) : (i64, i64) -> i64
      "braid.set"(%bb10c_12) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb110] : () -> ()
    ^bb110:  // 0x101cc
      %bb110_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb110_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb110_3 = "braid.add"(%bb110_0, %bb110_2) : (i64, i64) -> i64
      "braid.set"(%bb110_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb114] : () -> ()
    ^bb114:  // 0x101d0
      %bb114_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb114_0 = "braid.zext"(%bb114_1) {bits = 32 : i64} : (i64) -> i64
      %bb114_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bb114_2 = "braid.zext"(%bb114_3) {bits = 32 : i64} : (i64) -> i64
      %bb114_13 = "braid.add"(%bb114_0, %bb114_2) : (i64, i64) -> i64
      %bb114_12 = "braid.zext"(%bb114_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb114_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x101d4
      %bb118_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb118_2 = "braid.const"() {value = 256 : i64} : () -> i64
      %bb118_3 = "braid.sub"(%bb118_0, %bb118_2) : (i64, i64) -> i64
      %bb118_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb118_4 = "braid.slt"(%bb118_3, %bb118_8) : (i64, i64) -> i64
      %bb118_5 = "braid.eq"(%bb118_0, %bb118_2) : (i64, i64) -> i64
      %bb118_6 = "braid.ule"(%bb118_2, %bb118_0) : (i64, i64) -> i64
      %bb118_9 = "braid.xor"(%bb118_0, %bb118_2) : (i64, i64) -> i64
      %bb118_10 = "braid.xor"(%bb118_0, %bb118_3) : (i64, i64) -> i64
      %bb118_11 = "braid.and"(%bb118_9, %bb118_10) : (i64, i64) -> i64
      %bb118_7 = "braid.slt"(%bb118_11, %bb118_8) : (i64, i64) -> i64
      "braid.setf"(%bb118_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb118_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb118_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb118_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb11c] : () -> ()
    ^bb11c:  // 0x101d8
      %bb11c_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb11c_0 = "braid.zext"(%bb11c_1) {bits = 32 : i64} : (i64) -> i64
      %bb11c_3 = "braid.get"() {reg = "x1"} : () -> i64
      %bb11c_2 = "braid.zext"(%bb11c_3) {bits = 32 : i64} : (i64) -> i64
      %bb11c_13 = "braid.add"(%bb11c_0, %bb11c_2) : (i64, i64) -> i64
      %bb11c_12 = "braid.zext"(%bb11c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb11c_12) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x101dc
      %bb120_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb120_0 = "braid.zext"(%bb120_1) {bits = 32 : i64} : (i64) -> i64
      %bb120_3 = "braid.get"() {reg = "x4"} : () -> i64
      %bb120_2 = "braid.zext"(%bb120_3) {bits = 32 : i64} : (i64) -> i64
      %bb120_13 = "braid.add"(%bb120_0, %bb120_2) : (i64, i64) -> i64
      %bb120_12 = "braid.zext"(%bb120_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb120_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb124] : () -> ()
    ^bb124:  // 0x101e0
      %bb124_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb124_0 = "braid.zext"(%bb124_1) {bits = 32 : i64} : (i64) -> i64
      %bb124_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bb124_2 = "braid.zext"(%bb124_3) {bits = 32 : i64} : (i64) -> i64
      %bb124_13 = "braid.add"(%bb124_0, %bb124_2) : (i64, i64) -> i64
      %bb124_12 = "braid.zext"(%bb124_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb124_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb128] : () -> ()
    ^bb128:  // 0x101e4
      %bb128_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb128_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb128_0 = "braid.eq"(%bb128_1, %bb128_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb128_0)[^bba8, ^bb12c] : (i64) -> ()
    ^bb12c:  // 0x101e8
      %bb12c_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12c_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12c_12 = "braid.or"(%bb12c_0, %bb12c_2) : (i64, i64) -> i64
      "braid.set"(%bb12c_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb130] : () -> ()
    ^bb130:  // 0x101ec
      %bb130_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb130_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb130_2 = "braid.get"() {reg = "sp"} : () -> i64
      %bb130_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb130_4 = "braid.and"(%bb130_2, %bb130_3) : (i64, i64) -> i64
      %bb130_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb130_6 = "braid.eq"(%bb130_4, %bb130_5) : (i64, i64) -> i64
      "braid.guard"(%bb130_6) : (i64) -> ()
      %bb130_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb130_24 = "braid.add"(%bb130_2, %bb130_23) : (i64, i64) -> i64
      "braid.store"(%bb130_2, %bb130_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb130_24, %bb130_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb134:  // 0x101f0
      %bb134_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb134_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb134_3 = "braid.add"(%bb134_0, %bb134_2) : (i64, i64) -> i64
      "braid.set"(%bb134_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb138] : () -> ()
    ^bb138:  // 0x101f4
      %bb138_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb138_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb138_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb138_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb138_5 = "braid.and"(%bb138_3, %bb138_4) : (i64, i64) -> i64
      %bb138_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb138_7 = "braid.eq"(%bb138_5, %bb138_6) : (i64, i64) -> i64
      "braid.guard"(%bb138_7) : (i64) -> ()
      %bb138_8 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb138_2 = "braid.add"(%bb138_3, %bb138_8) : (i64, i64) -> i64
      %bb138_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb138_24 = "braid.add"(%bb138_2, %bb138_23) : (i64, i64) -> i64
      "braid.store"(%bb138_2, %bb138_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb138_24, %bb138_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb13c] : () -> ()
    ^bb13c:  // 0x101f8
      %bb13c_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb13c_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb13c_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb13c_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb13c_5 = "braid.and"(%bb13c_3, %bb13c_4) : (i64, i64) -> i64
      %bb13c_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb13c_7 = "braid.eq"(%bb13c_5, %bb13c_6) : (i64, i64) -> i64
      "braid.guard"(%bb13c_7) : (i64) -> ()
      %bb13c_8 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb13c_2 = "braid.add"(%bb13c_3, %bb13c_8) : (i64, i64) -> i64
      %bb13c_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb13c_24 = "braid.add"(%bb13c_2, %bb13c_23) : (i64, i64) -> i64
      "braid.store"(%bb13c_2, %bb13c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb13c_24, %bb13c_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb140] : () -> ()
    ^bb140:  // 0x101fc
      %bb140_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb140_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb140_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb140_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb140_5 = "braid.and"(%bb140_3, %bb140_4) : (i64, i64) -> i64
      %bb140_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb140_7 = "braid.eq"(%bb140_5, %bb140_6) : (i64, i64) -> i64
      "braid.guard"(%bb140_7) : (i64) -> ()
      %bb140_8 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb140_2 = "braid.add"(%bb140_3, %bb140_8) : (i64, i64) -> i64
      %bb140_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb140_24 = "braid.add"(%bb140_2, %bb140_23) : (i64, i64) -> i64
      "braid.store"(%bb140_2, %bb140_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb140_24, %bb140_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb144] : () -> ()
    ^bb144:  // 0x10200
      %bb144_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb144_6 = "braid.get"() {reg = "x8"} : () -> i64
      %bb144_0 = "braid.add"(%bb144_1, %bb144_6) : (i64, i64) -> i64
      %bb144_30 = "braid.load"(%bb144_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb144_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb148] : () -> ()
    ^bb148:  // 0x10204
      %bb148_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb148_6 = "braid.get"() {reg = "x8"} : () -> i64
      %bb148_0 = "braid.add"(%bb148_1, %bb148_6) : (i64, i64) -> i64
      %bb148_30 = "braid.load"(%bb148_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb148_30) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb14c] : () -> ()
    ^bb14c:  // 0x10208
      %bb14c_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb14c_0 = "braid.zext"(%bb14c_1) {bits = 32 : i64} : (i64) -> i64
      %bb14c_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb14c_2 = "braid.zext"(%bb14c_3) {bits = 32 : i64} : (i64) -> i64
      %bb14c_13 = "braid.add"(%bb14c_0, %bb14c_2) : (i64, i64) -> i64
      %bb14c_12 = "braid.zext"(%bb14c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb14c_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb150] : () -> ()
    ^bb150:  // 0x1020c
      %bb150_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb150_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb150_7 = "braid.get"() {reg = "x8"} : () -> i64
      %bb150_1 = "braid.add"(%bb150_2, %bb150_7) : (i64, i64) -> i64
      "braid.store"(%bb150_1, %bb150_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb154] : () -> ()
    ^bb154:  // 0x10210
      %bb154_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb154_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb154_3 = "braid.add"(%bb154_0, %bb154_2) : (i64, i64) -> i64
      "braid.set"(%bb154_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb158] : () -> ()
    ^bb158:  // 0x10214
      %bb158_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb158_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb158_3 = "braid.sub"(%bb158_0, %bb158_2) : (i64, i64) -> i64
      %bb158_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb158_4 = "braid.slt"(%bb158_3, %bb158_8) : (i64, i64) -> i64
      %bb158_5 = "braid.eq"(%bb158_0, %bb158_2) : (i64, i64) -> i64
      %bb158_6 = "braid.ule"(%bb158_2, %bb158_0) : (i64, i64) -> i64
      %bb158_9 = "braid.xor"(%bb158_0, %bb158_2) : (i64, i64) -> i64
      %bb158_10 = "braid.xor"(%bb158_0, %bb158_3) : (i64, i64) -> i64
      %bb158_11 = "braid.and"(%bb158_9, %bb158_10) : (i64, i64) -> i64
      %bb158_7 = "braid.slt"(%bb158_11, %bb158_8) : (i64, i64) -> i64
      "braid.setf"(%bb158_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb158_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb158_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb158_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb15c] : () -> ()
    ^bb15c:  // 0x10218
      %bb15c_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb15c_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15c_0 = "braid.eq"(%bb15c_1, %bb15c_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb15c_0)[^bb144, ^bb160] : (i64) -> ()
    ^bb160:  // 0x1021c
      %bb160_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb160_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb160_3 = "braid.and"(%bb160_1, %bb160_2) : (i64, i64) -> i64
      %bb160_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb160_5 = "braid.eq"(%bb160_3, %bb160_4) : (i64, i64) -> i64
      "braid.guard"(%bb160_5) : (i64) -> ()
      %bb160_6 = "braid.const"() {value = 288 : i64} : () -> i64
      %bb160_0 = "braid.add"(%bb160_1, %bb160_6) : (i64, i64) -> i64
      %bb160_30 = "braid.load"(%bb160_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb160_30) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb164] : () -> ()
    ^bb164:  // 0x10220
      %bb164_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb164_2 = "braid.const"() {value = 304 : i64} : () -> i64
      %bb164_3 = "braid.add"(%bb164_0, %bb164_2) : (i64, i64) -> i64
      "braid.set"(%bb164_3) {reg = "sp"} : (i64) -> ()
      "braid_cf.br"()[^bb168] : () -> ()
    ^bb168:  // 0x10224
      %bb168_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb168_0) : (i64) -> ()
  }) {sym_name = "sha256_compress", entry = 65724 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
