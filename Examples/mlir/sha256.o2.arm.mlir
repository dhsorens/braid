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
      %bb0_2 = "braid.const"() {value = 320 : i64} : () -> i64
      %bb0_3 = "braid.sub"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_3) {reg = "sp"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x100c0
      %bb4_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb4_30 = "braid.load"(%bb4_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb4_30) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x100c4
      %bb8_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb8_6 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8_0 = "braid.add"(%bb8_1, %bb8_6) : (i64, i64) -> i64
      %bb8_30 = "braid.load"(%bb8_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb8_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x100c8
      %bbc_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bbc_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_3 = "braid.add"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      "braid.set"(%bbc_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x100cc
      %bb10_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb10_6 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb10_0 = "braid.add"(%bb10_1, %bb10_6) : (i64, i64) -> i64
      %bb10_30 = "braid.load"(%bb10_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb10_30) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x100d0
      %bb14_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb14_2 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb14_3 = "braid.add"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      "braid.set"(%bb14_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x100d4
      %bb18_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb18_2 = "braid.get"() {reg = "sp"} : () -> i64
      %bb18_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb18_4 = "braid.and"(%bb18_2, %bb18_3) : (i64, i64) -> i64
      %bb18_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_6 = "braid.eq"(%bb18_4, %bb18_5) : (i64, i64) -> i64
      "braid.guard"(%bb18_6) : (i64) -> ()
      %bb18_7 = "braid.const"() {value = 256 : i64} : () -> i64
      %bb18_1 = "braid.add"(%bb18_2, %bb18_7) : (i64, i64) -> i64
      "braid.store"(%bb18_1, %bb18_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x100d8
      %bb1c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1c_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1c_3 = "braid.and"(%bb1c_1, %bb1c_2) : (i64, i64) -> i64
      %bb1c_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_5 = "braid.eq"(%bb1c_3, %bb1c_4) : (i64, i64) -> i64
      "braid.guard"(%bb1c_5) : (i64) -> ()
      "braid.store"(%bb1c_1, %bb1c_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x100dc
      %bb20_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb20_6 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb20_0 = "braid.add"(%bb20_1, %bb20_6) : (i64, i64) -> i64
      %bb20_30 = "braid.load"(%bb20_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb20_30) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x100e0
      %bb24_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb24_2 = "braid.get"() {reg = "sp"} : () -> i64
      %bb24_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb24_4 = "braid.and"(%bb24_2, %bb24_3) : (i64, i64) -> i64
      %bb24_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_6 = "braid.eq"(%bb24_4, %bb24_5) : (i64, i64) -> i64
      "braid.guard"(%bb24_6) : (i64) -> ()
      %bb24_7 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb24_1 = "braid.add"(%bb24_2, %bb24_7) : (i64, i64) -> i64
      "braid.store"(%bb24_1, %bb24_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x100e4
      %bb28_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb28_2 = "braid.get"() {reg = "sp"} : () -> i64
      %bb28_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb28_4 = "braid.and"(%bb28_2, %bb28_3) : (i64, i64) -> i64
      %bb28_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_6 = "braid.eq"(%bb28_4, %bb28_5) : (i64, i64) -> i64
      "braid.guard"(%bb28_6) : (i64) -> ()
      %bb28_7 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb28_1 = "braid.add"(%bb28_2, %bb28_7) : (i64, i64) -> i64
      "braid.store"(%bb28_1, %bb28_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x100e8
      %bb2c_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb2c_6 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb2c_0 = "braid.add"(%bb2c_1, %bb2c_6) : (i64, i64) -> i64
      %bb2c_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb2c_22 = "braid.add"(%bb2c_0, %bb2c_21) : (i64, i64) -> i64
      %bb2c_23 = "braid.load"(%bb2c_0) {bytes = 8 : i64} : (i64) -> i64
      %bb2c_26 = "braid.load"(%bb2c_22) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb2c_23) {reg = "x10"} : (i64) -> ()
      "braid.set"(%bb2c_26) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x100ec
      %bb30_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb30_2 = "braid.get"() {reg = "sp"} : () -> i64
      %bb30_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb30_4 = "braid.and"(%bb30_2, %bb30_3) : (i64, i64) -> i64
      %bb30_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb30_6 = "braid.eq"(%bb30_4, %bb30_5) : (i64, i64) -> i64
      "braid.guard"(%bb30_6) : (i64) -> ()
      %bb30_7 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb30_1 = "braid.add"(%bb30_2, %bb30_7) : (i64, i64) -> i64
      "braid.store"(%bb30_1, %bb30_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x100f0
      %bb34_0 = "braid.get"() {reg = "x24"} : () -> i64
      %bb34_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bb34_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb34_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb34_5 = "braid.and"(%bb34_3, %bb34_4) : (i64, i64) -> i64
      %bb34_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb34_7 = "braid.eq"(%bb34_5, %bb34_6) : (i64, i64) -> i64
      "braid.guard"(%bb34_7) : (i64) -> ()
      %bb34_8 = "braid.const"() {value = 272 : i64} : () -> i64
      %bb34_2 = "braid.add"(%bb34_3, %bb34_8) : (i64, i64) -> i64
      %bb34_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb34_24 = "braid.add"(%bb34_2, %bb34_23) : (i64, i64) -> i64
      "braid.store"(%bb34_2, %bb34_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb34_24, %bb34_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x100f4
      %bb38_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb38_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb38_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb38_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb38_5 = "braid.and"(%bb38_3, %bb38_4) : (i64, i64) -> i64
      %bb38_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb38_7 = "braid.eq"(%bb38_5, %bb38_6) : (i64, i64) -> i64
      "braid.guard"(%bb38_7) : (i64) -> ()
      %bb38_8 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb38_2 = "braid.add"(%bb38_3, %bb38_8) : (i64, i64) -> i64
      %bb38_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb38_24 = "braid.add"(%bb38_2, %bb38_23) : (i64, i64) -> i64
      "braid.store"(%bb38_2, %bb38_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb38_24, %bb38_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x100f8
      %bb3c_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb3c_6 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb3c_0 = "braid.add"(%bb3c_1, %bb3c_6) : (i64, i64) -> i64
      %bb3c_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb3c_22 = "braid.add"(%bb3c_0, %bb3c_21) : (i64, i64) -> i64
      %bb3c_23 = "braid.load"(%bb3c_0) {bytes = 4 : i64} : (i64) -> i64
      %bb3c_26 = "braid.load"(%bb3c_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb3c_23) {reg = "x11"} : (i64) -> ()
      "braid.set"(%bb3c_26) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x100fc
      %bb40_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bb40_1 = "braid.get"() {reg = "x21"} : () -> i64
      %bb40_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb40_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb40_5 = "braid.and"(%bb40_3, %bb40_4) : (i64, i64) -> i64
      %bb40_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb40_7 = "braid.eq"(%bb40_5, %bb40_6) : (i64, i64) -> i64
      "braid.guard"(%bb40_7) : (i64) -> ()
      %bb40_8 = "braid.const"() {value = 288 : i64} : () -> i64
      %bb40_2 = "braid.add"(%bb40_3, %bb40_8) : (i64, i64) -> i64
      %bb40_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb40_24 = "braid.add"(%bb40_2, %bb40_23) : (i64, i64) -> i64
      "braid.store"(%bb40_2, %bb40_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb40_24, %bb40_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10100
      %bb44_0 = "braid.get"() {reg = "x20"} : () -> i64
      %bb44_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb44_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb44_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb44_5 = "braid.and"(%bb44_3, %bb44_4) : (i64, i64) -> i64
      %bb44_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb44_7 = "braid.eq"(%bb44_5, %bb44_6) : (i64, i64) -> i64
      "braid.guard"(%bb44_7) : (i64) -> ()
      %bb44_8 = "braid.const"() {value = 304 : i64} : () -> i64
      %bb44_2 = "braid.add"(%bb44_3, %bb44_8) : (i64, i64) -> i64
      %bb44_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb44_24 = "braid.add"(%bb44_2, %bb44_23) : (i64, i64) -> i64
      "braid.store"(%bb44_2, %bb44_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb44_24, %bb44_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x10104
      %bb48_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb48_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb48_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb48_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb48_5 = "braid.and"(%bb48_3, %bb48_4) : (i64, i64) -> i64
      %bb48_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb48_7 = "braid.eq"(%bb48_5, %bb48_6) : (i64, i64) -> i64
      "braid.guard"(%bb48_7) : (i64) -> ()
      %bb48_8 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb48_2 = "braid.add"(%bb48_3, %bb48_8) : (i64, i64) -> i64
      %bb48_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb48_24 = "braid.add"(%bb48_2, %bb48_23) : (i64, i64) -> i64
      "braid.store"(%bb48_2, %bb48_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb48_24, %bb48_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x10108
      %bb4c_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb4c_6 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb4c_0 = "braid.add"(%bb4c_1, %bb4c_6) : (i64, i64) -> i64
      %bb4c_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb4c_22 = "braid.add"(%bb4c_0, %bb4c_21) : (i64, i64) -> i64
      %bb4c_23 = "braid.load"(%bb4c_0) {bytes = 4 : i64} : (i64) -> i64
      %bb4c_26 = "braid.load"(%bb4c_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb4c_23) {reg = "x10"} : (i64) -> ()
      "braid.set"(%bb4c_26) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x1010c
      %bb50_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb50_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb50_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb50_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb50_5 = "braid.and"(%bb50_3, %bb50_4) : (i64, i64) -> i64
      %bb50_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb50_7 = "braid.eq"(%bb50_5, %bb50_6) : (i64, i64) -> i64
      "braid.guard"(%bb50_7) : (i64) -> ()
      %bb50_8 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb50_2 = "braid.add"(%bb50_3, %bb50_8) : (i64, i64) -> i64
      %bb50_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb50_24 = "braid.add"(%bb50_2, %bb50_23) : (i64, i64) -> i64
      "braid.store"(%bb50_2, %bb50_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb50_24, %bb50_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x10110
      %bb54_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb54_6 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb54_0 = "braid.add"(%bb54_1, %bb54_6) : (i64, i64) -> i64
      %bb54_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb54_22 = "braid.add"(%bb54_0, %bb54_21) : (i64, i64) -> i64
      %bb54_23 = "braid.load"(%bb54_0) {bytes = 4 : i64} : (i64) -> i64
      %bb54_26 = "braid.load"(%bb54_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb54_23) {reg = "x11"} : (i64) -> ()
      "braid.set"(%bb54_26) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x10114
      %bb58_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb58_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb58_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb58_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb58_5 = "braid.and"(%bb58_3, %bb58_4) : (i64, i64) -> i64
      %bb58_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb58_7 = "braid.eq"(%bb58_5, %bb58_6) : (i64, i64) -> i64
      "braid.guard"(%bb58_7) : (i64) -> ()
      %bb58_8 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb58_2 = "braid.add"(%bb58_3, %bb58_8) : (i64, i64) -> i64
      %bb58_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb58_24 = "braid.add"(%bb58_2, %bb58_23) : (i64, i64) -> i64
      "braid.store"(%bb58_2, %bb58_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb58_24, %bb58_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x10118
      %bb5c_0 = "braid.const"() {value = 48 : i64} : () -> i64
      "braid.set"(%bb5c_0) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x1011c
      %bb60_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb60_6 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb60_0 = "braid.add"(%bb60_1, %bb60_6) : (i64, i64) -> i64
      %bb60_30 = "braid.load"(%bb60_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb60_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x10120
      %bb64_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb64_6 = "braid.const"() {value = -28 : i64} : () -> i64
      %bb64_0 = "braid.add"(%bb64_1, %bb64_6) : (i64, i64) -> i64
      %bb64_30 = "braid.load"(%bb64_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb64_30) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x10124
      %bb68_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb68_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb68_3 = "braid.sub"(%bb68_0, %bb68_2) : (i64, i64) -> i64
      %bb68_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb68_4 = "braid.slt"(%bb68_3, %bb68_8) : (i64, i64) -> i64
      %bb68_5 = "braid.eq"(%bb68_0, %bb68_2) : (i64, i64) -> i64
      %bb68_6 = "braid.ule"(%bb68_2, %bb68_0) : (i64, i64) -> i64
      %bb68_9 = "braid.xor"(%bb68_0, %bb68_2) : (i64, i64) -> i64
      %bb68_10 = "braid.xor"(%bb68_0, %bb68_3) : (i64, i64) -> i64
      %bb68_11 = "braid.and"(%bb68_9, %bb68_10) : (i64, i64) -> i64
      %bb68_7 = "braid.slt"(%bb68_11, %bb68_8) : (i64, i64) -> i64
      "braid.setf"(%bb68_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb68_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb68_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb68_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb68_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x10128
      %bb6c_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb6c_6 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb6c_0 = "braid.add"(%bb6c_1, %bb6c_6) : (i64, i64) -> i64
      %bb6c_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb6c_22 = "braid.add"(%bb6c_0, %bb6c_21) : (i64, i64) -> i64
      %bb6c_23 = "braid.load"(%bb6c_0) {bytes = 4 : i64} : (i64) -> i64
      %bb6c_26 = "braid.load"(%bb6c_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb6c_23) {reg = "x13"} : (i64) -> ()
      "braid.set"(%bb6c_26) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x1012c
      %bb70_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb70_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb70_2 = "braid.zext"(%bb70_1) {bits = 32 : i64} : (i64) -> i64
      %bb70_3 = "braid.const"() {value = 17 : i64} : () -> i64
      %bb70_4 = "braid.lshr"(%bb70_2, %bb70_3) : (i64, i64) -> i64
      %bb70_5 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb70_6 = "braid.shl"(%bb70_0, %bb70_5) : (i64, i64) -> i64
      %bb70_7 = "braid.or"(%bb70_4, %bb70_6) : (i64, i64) -> i64
      %bb70_9 = "braid.zext"(%bb70_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb70_9) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x10130
      %bb74_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb74_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb74_2 = "braid.zext"(%bb74_1) {bits = 32 : i64} : (i64) -> i64
      %bb74_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb74_4 = "braid.lshr"(%bb74_2, %bb74_3) : (i64, i64) -> i64
      %bb74_5 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb74_6 = "braid.shl"(%bb74_0, %bb74_5) : (i64, i64) -> i64
      %bb74_7 = "braid.or"(%bb74_4, %bb74_6) : (i64, i64) -> i64
      %bb74_9 = "braid.zext"(%bb74_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb74_9) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x10134
      %bb78_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb78_0 = "braid.zext"(%bb78_1) {bits = 32 : i64} : (i64) -> i64
      %bb78_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb78_5 = "braid.zext"(%bb78_3) {bits = 32 : i64} : (i64) -> i64
      %bb78_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb78_7 = "braid.mul"(%bb78_5, %bb78_6) : (i64, i64) -> i64
      %bb78_8 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb78_9 = "braid.lshr"(%bb78_7, %bb78_8) : (i64, i64) -> i64
      %bb78_2 = "braid.zext"(%bb78_9) {bits = 32 : i64} : (i64) -> i64
      %bb78_12 = "braid.xor"(%bb78_0, %bb78_2) : (i64, i64) -> i64
      "braid.set"(%bb78_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x10138
      %bb7c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb7c_0 = "braid.zext"(%bb7c_1) {bits = 32 : i64} : (i64) -> i64
      %bb7c_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb7c_5 = "braid.zext"(%bb7c_3) {bits = 32 : i64} : (i64) -> i64
      %bb7c_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb7c_7 = "braid.mul"(%bb7c_5, %bb7c_6) : (i64, i64) -> i64
      %bb7c_8 = "braid.const"() {value = 18 : i64} : () -> i64
      %bb7c_9 = "braid.lshr"(%bb7c_7, %bb7c_8) : (i64, i64) -> i64
      %bb7c_2 = "braid.zext"(%bb7c_9) {bits = 32 : i64} : (i64) -> i64
      %bb7c_12 = "braid.xor"(%bb7c_0, %bb7c_2) : (i64, i64) -> i64
      "braid.set"(%bb7c_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x1013c
      %bb80_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb80_0 = "braid.zext"(%bb80_1) {bits = 32 : i64} : (i64) -> i64
      %bb80_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb80_5 = "braid.zext"(%bb80_3) {bits = 32 : i64} : (i64) -> i64
      %bb80_6 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb80_2 = "braid.lshr"(%bb80_5, %bb80_6) : (i64, i64) -> i64
      %bb80_12 = "braid.xor"(%bb80_0, %bb80_2) : (i64, i64) -> i64
      "braid.set"(%bb80_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x10140
      %bb84_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb84_0 = "braid.zext"(%bb84_1) {bits = 32 : i64} : (i64) -> i64
      %bb84_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb84_2 = "braid.zext"(%bb84_3) {bits = 32 : i64} : (i64) -> i64
      %bb84_13 = "braid.add"(%bb84_0, %bb84_2) : (i64, i64) -> i64
      %bb84_12 = "braid.zext"(%bb84_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb84_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x10144
      %bb88_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb88_0 = "braid.zext"(%bb88_1) {bits = 32 : i64} : (i64) -> i64
      %bb88_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb88_5 = "braid.zext"(%bb88_3) {bits = 32 : i64} : (i64) -> i64
      %bb88_6 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb88_2 = "braid.lshr"(%bb88_5, %bb88_6) : (i64, i64) -> i64
      %bb88_12 = "braid.xor"(%bb88_0, %bb88_2) : (i64, i64) -> i64
      "braid.set"(%bb88_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x10148
      %bb8c_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb8c_0 = "braid.zext"(%bb8c_1) {bits = 32 : i64} : (i64) -> i64
      %bb8c_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bb8c_2 = "braid.zext"(%bb8c_3) {bits = 32 : i64} : (i64) -> i64
      %bb8c_13 = "braid.add"(%bb8c_0, %bb8c_2) : (i64, i64) -> i64
      %bb8c_12 = "braid.zext"(%bb8c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb8c_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x1014c
      %bb90_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb90_0 = "braid.zext"(%bb90_1) {bits = 32 : i64} : (i64) -> i64
      %bb90_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb90_2 = "braid.zext"(%bb90_3) {bits = 32 : i64} : (i64) -> i64
      %bb90_13 = "braid.add"(%bb90_0, %bb90_2) : (i64, i64) -> i64
      %bb90_12 = "braid.zext"(%bb90_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb90_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x10150
      %bb94_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb94_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb94_6 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb94_7 = "braid.add"(%bb94_1, %bb94_6) : (i64, i64) -> i64
      "braid.set"(%bb94_7) {reg = "x8"} : (i64) -> ()
      "braid.store"(%bb94_1, %bb94_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x10154
      %bb98_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb98_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb98_0 = "braid.eq"(%bb98_1, %bb98_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb98_0)[^bb60, ^bb9c] : (i64) -> ()
    ^bb9c:  // 0x10158
      %bb9c_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb9c_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb9c_22 = "braid.add"(%bb9c_0, %bb9c_21) : (i64, i64) -> i64
      %bb9c_23 = "braid.load"(%bb9c_0) {bytes = 4 : i64} : (i64) -> i64
      %bb9c_26 = "braid.load"(%bb9c_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb9c_23) {reg = "x10"} : (i64) -> ()
      "braid.set"(%bb9c_26) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x1015c
      %bba0_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bba0_6 = "braid.const"() {value = 8 : i64} : () -> i64
      %bba0_0 = "braid.add"(%bba0_1, %bba0_6) : (i64, i64) -> i64
      %bba0_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bba0_22 = "braid.add"(%bba0_0, %bba0_21) : (i64, i64) -> i64
      %bba0_23 = "braid.load"(%bba0_0) {bytes = 4 : i64} : (i64) -> i64
      %bba0_26 = "braid.load"(%bba0_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bba0_23) {reg = "x9"} : (i64) -> ()
      "braid.set"(%bba0_26) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bba4] : () -> ()
    ^bba4:  // 0x10160
      %bba4_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bba4_6 = "braid.const"() {value = 16 : i64} : () -> i64
      %bba4_0 = "braid.add"(%bba4_1, %bba4_6) : (i64, i64) -> i64
      %bba4_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bba4_22 = "braid.add"(%bba4_0, %bba4_21) : (i64, i64) -> i64
      %bba4_23 = "braid.load"(%bba4_0) {bytes = 4 : i64} : (i64) -> i64
      %bba4_26 = "braid.load"(%bba4_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bba4_23) {reg = "x16"} : (i64) -> ()
      "braid.set"(%bba4_26) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x10164
      %bba8_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bba8_6 = "braid.const"() {value = 24 : i64} : () -> i64
      %bba8_0 = "braid.add"(%bba8_1, %bba8_6) : (i64, i64) -> i64
      %bba8_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bba8_22 = "braid.add"(%bba8_0, %bba8_21) : (i64, i64) -> i64
      %bba8_23 = "braid.load"(%bba8_0) {bytes = 4 : i64} : (i64) -> i64
      %bba8_26 = "braid.load"(%bba8_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bba8_23) {reg = "x14"} : (i64) -> ()
      "braid.set"(%bba8_26) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x10168
      %bbac_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbac_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbac_12 = "braid.or"(%bbac_0, %bbac_2) : (i64, i64) -> i64
      "braid.set"(%bbac_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x1016c
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x10170
      %bbb4_0 = "braid.const"() {value = 131684 : i64} : () -> i64
      "braid.set"(%bbb4_0) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x10174
      %bbb8_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bbb8_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb8_3 = "braid.add"(%bbb8_0, %bbb8_2) : (i64, i64) -> i64
      "braid.set"(%bbb8_3) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x10178
      %bbbc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbbc_0 = "braid.zext"(%bbbc_1) {bits = 32 : i64} : (i64) -> i64
      %bbbc_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bbbc_2 = "braid.zext"(%bbbc_3) {bits = 32 : i64} : (i64) -> i64
      %bbbc_12 = "braid.or"(%bbbc_0, %bbbc_2) : (i64, i64) -> i64
      "braid.set"(%bbbc_12) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bbc0:  // 0x1017c
      %bbc0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc0_0 = "braid.zext"(%bbc0_1) {bits = 32 : i64} : (i64) -> i64
      %bbc0_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bbc0_2 = "braid.zext"(%bbc0_3) {bits = 32 : i64} : (i64) -> i64
      %bbc0_12 = "braid.or"(%bbc0_0, %bbc0_2) : (i64, i64) -> i64
      "braid.set"(%bbc0_12) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x10180
      %bbc4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc4_0 = "braid.zext"(%bbc4_1) {bits = 32 : i64} : (i64) -> i64
      %bbc4_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bbc4_2 = "braid.zext"(%bbc4_3) {bits = 32 : i64} : (i64) -> i64
      %bbc4_12 = "braid.or"(%bbc4_0, %bbc4_2) : (i64, i64) -> i64
      "braid.set"(%bbc4_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x10184
      %bbc8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc8_0 = "braid.zext"(%bbc8_1) {bits = 32 : i64} : (i64) -> i64
      %bbc8_3 = "braid.get"() {reg = "x8"} : () -> i64
      %bbc8_2 = "braid.zext"(%bbc8_3) {bits = 32 : i64} : (i64) -> i64
      %bbc8_12 = "braid.or"(%bbc8_0, %bbc8_2) : (i64, i64) -> i64
      "braid.set"(%bbc8_12) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x10188
      %bbcc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbcc_0 = "braid.zext"(%bbcc_1) {bits = 32 : i64} : (i64) -> i64
      %bbcc_3 = "braid.get"() {reg = "x16"} : () -> i64
      %bbcc_2 = "braid.zext"(%bbcc_3) {bits = 32 : i64} : (i64) -> i64
      %bbcc_12 = "braid.or"(%bbcc_0, %bbcc_2) : (i64, i64) -> i64
      "braid.set"(%bbcc_12) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x1018c
      %bbd0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd0_0 = "braid.zext"(%bbd0_1) {bits = 32 : i64} : (i64) -> i64
      %bbd0_3 = "braid.get"() {reg = "x15"} : () -> i64
      %bbd0_2 = "braid.zext"(%bbd0_3) {bits = 32 : i64} : (i64) -> i64
      %bbd0_12 = "braid.or"(%bbd0_0, %bbd0_2) : (i64, i64) -> i64
      "braid.set"(%bbd0_12) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x10190
      %bbd4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd4_0 = "braid.zext"(%bbd4_1) {bits = 32 : i64} : (i64) -> i64
      %bbd4_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bbd4_2 = "braid.zext"(%bbd4_3) {bits = 32 : i64} : (i64) -> i64
      %bbd4_12 = "braid.or"(%bbd4_0, %bbd4_2) : (i64, i64) -> i64
      "braid.set"(%bbd4_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbd8] : () -> ()
    ^bbd8:  // 0x10194
      %bbd8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd8_0 = "braid.zext"(%bbd8_1) {bits = 32 : i64} : (i64) -> i64
      %bbd8_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bbd8_2 = "braid.zext"(%bbd8_3) {bits = 32 : i64} : (i64) -> i64
      %bbd8_12 = "braid.or"(%bbd8_0, %bbd8_2) : (i64, i64) -> i64
      "braid.set"(%bbd8_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x10198
      %bbdc_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bbdc_6 = "braid.get"() {reg = "x12"} : () -> i64
      %bbdc_0 = "braid.add"(%bbdc_1, %bbdc_6) : (i64, i64) -> i64
      %bbdc_30 = "braid.load"(%bbdc_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbdc_30) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bbe0] : () -> ()
    ^bbe0:  // 0x1019c
      %bbe0_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bbe0_6 = "braid.get"() {reg = "x12"} : () -> i64
      %bbe0_0 = "braid.add"(%bbe0_1, %bbe0_6) : (i64, i64) -> i64
      %bbe0_30 = "braid.load"(%bbe0_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbe0_30) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x101a0
      %bbe4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe4_0 = "braid.zext"(%bbe4_1) {bits = 32 : i64} : (i64) -> i64
      %bbe4_3 = "braid.get"() {reg = "x4"} : () -> i64
      %bbe4_2 = "braid.zext"(%bbe4_3) {bits = 32 : i64} : (i64) -> i64
      %bbe4_12 = "braid.or"(%bbe4_0, %bbe4_2) : (i64, i64) -> i64
      "braid.set"(%bbe4_12) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bbe8] : () -> ()
    ^bbe8:  // 0x101a4
      %bbe8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe8_0 = "braid.zext"(%bbe8_1) {bits = 32 : i64} : (i64) -> i64
      %bbe8_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bbe8_2 = "braid.zext"(%bbe8_3) {bits = 32 : i64} : (i64) -> i64
      %bbe8_12 = "braid.or"(%bbe8_0, %bbe8_2) : (i64, i64) -> i64
      "braid.set"(%bbe8_12) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bbec] : () -> ()
    ^bbec:  // 0x101a8
      %bbec_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbec_0 = "braid.zext"(%bbec_1) {bits = 32 : i64} : (i64) -> i64
      %bbec_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bbec_2 = "braid.zext"(%bbec_3) {bits = 32 : i64} : (i64) -> i64
      %bbec_12 = "braid.or"(%bbec_0, %bbec_2) : (i64, i64) -> i64
      "braid.set"(%bbec_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bbf0] : () -> ()
    ^bbf0:  // 0x101ac
      %bbf0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf0_0 = "braid.zext"(%bbf0_1) {bits = 32 : i64} : (i64) -> i64
      %bbf0_3 = "braid.get"() {reg = "x19"} : () -> i64
      %bbf0_2 = "braid.zext"(%bbf0_3) {bits = 32 : i64} : (i64) -> i64
      %bbf0_12 = "braid.or"(%bbf0_0, %bbf0_2) : (i64, i64) -> i64
      "braid.set"(%bbf0_12) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bbf4] : () -> ()
    ^bbf4:  // 0x101b0
      %bbf4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf4_0 = "braid.zext"(%bbf4_1) {bits = 32 : i64} : (i64) -> i64
      %bbf4_3 = "braid.get"() {reg = "x18"} : () -> i64
      %bbf4_2 = "braid.zext"(%bbf4_3) {bits = 32 : i64} : (i64) -> i64
      %bbf4_12 = "braid.or"(%bbf4_0, %bbf4_2) : (i64, i64) -> i64
      "braid.set"(%bbf4_12) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bbf8] : () -> ()
    ^bbf8:  // 0x101b4
      %bbf8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf8_0 = "braid.zext"(%bbf8_1) {bits = 32 : i64} : (i64) -> i64
      %bbf8_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bbf8_2 = "braid.zext"(%bbf8_3) {bits = 32 : i64} : (i64) -> i64
      %bbf8_12 = "braid.or"(%bbf8_0, %bbf8_2) : (i64, i64) -> i64
      "braid.set"(%bbf8_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bbfc] : () -> ()
    ^bbfc:  // 0x101b8
      %bbfc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbfc_0 = "braid.zext"(%bbfc_1) {bits = 32 : i64} : (i64) -> i64
      %bbfc_3 = "braid.get"() {reg = "x1"} : () -> i64
      %bbfc_2 = "braid.zext"(%bbfc_3) {bits = 32 : i64} : (i64) -> i64
      %bbfc_12 = "braid.or"(%bbfc_0, %bbfc_2) : (i64, i64) -> i64
      "braid.set"(%bbfc_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb100:  // 0x101bc
      %bb100_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb100_0 = "braid.zext"(%bb100_1) {bits = 32 : i64} : (i64) -> i64
      %bb100_3 = "braid.get"() {reg = "x7"} : () -> i64
      %bb100_2 = "braid.zext"(%bb100_3) {bits = 32 : i64} : (i64) -> i64
      %bb100_12 = "braid.or"(%bb100_0, %bb100_2) : (i64, i64) -> i64
      "braid.set"(%bb100_12) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bb104] : () -> ()
    ^bb104:  // 0x101c0
      %bb104_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb104_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb104_2 = "braid.zext"(%bb104_1) {bits = 32 : i64} : (i64) -> i64
      %bb104_3 = "braid.const"() {value = 6 : i64} : () -> i64
      %bb104_4 = "braid.lshr"(%bb104_2, %bb104_3) : (i64, i64) -> i64
      %bb104_5 = "braid.const"() {value = 26 : i64} : () -> i64
      %bb104_6 = "braid.shl"(%bb104_0, %bb104_5) : (i64, i64) -> i64
      %bb104_7 = "braid.or"(%bb104_4, %bb104_6) : (i64, i64) -> i64
      %bb104_9 = "braid.zext"(%bb104_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb104_9) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x101c4
      %bb108_1 = "braid.get"() {reg = "x21"} : () -> i64
      %bb108_0 = "braid.zext"(%bb108_1) {bits = 32 : i64} : (i64) -> i64
      %bb108_3 = "braid.get"() {reg = "x20"} : () -> i64
      %bb108_2 = "braid.zext"(%bb108_3) {bits = 32 : i64} : (i64) -> i64
      %bb108_13 = "braid.add"(%bb108_0, %bb108_2) : (i64, i64) -> i64
      %bb108_12 = "braid.zext"(%bb108_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb108_12) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb10c] : () -> ()
    ^bb10c:  // 0x101c8
      %bb10c_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb10c_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb10c_2 = "braid.zext"(%bb10c_1) {bits = 32 : i64} : (i64) -> i64
      %bb10c_3 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb10c_4 = "braid.lshr"(%bb10c_2, %bb10c_3) : (i64, i64) -> i64
      %bb10c_5 = "braid.const"() {value = 30 : i64} : () -> i64
      %bb10c_6 = "braid.shl"(%bb10c_0, %bb10c_5) : (i64, i64) -> i64
      %bb10c_7 = "braid.or"(%bb10c_4, %bb10c_6) : (i64, i64) -> i64
      %bb10c_9 = "braid.zext"(%bb10c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb10c_9) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb110] : () -> ()
    ^bb110:  // 0x101cc
      %bb110_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb110_0 = "braid.zext"(%bb110_1) {bits = 32 : i64} : (i64) -> i64
      %bb110_3 = "braid.get"() {reg = "x22"} : () -> i64
      %bb110_2 = "braid.zext"(%bb110_3) {bits = 32 : i64} : (i64) -> i64
      %bb110_13 = "braid.add"(%bb110_0, %bb110_2) : (i64, i64) -> i64
      %bb110_12 = "braid.zext"(%bb110_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb110_12) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb114] : () -> ()
    ^bb114:  // 0x101d0
      %bb114_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb114_0 = "braid.zext"(%bb114_1) {bits = 32 : i64} : (i64) -> i64
      %bb114_3 = "braid.get"() {reg = "x1"} : () -> i64
      %bb114_2 = "braid.zext"(%bb114_3) {bits = 32 : i64} : (i64) -> i64
      %bb114_12 = "braid.and"(%bb114_0, %bb114_2) : (i64, i64) -> i64
      "braid.set"(%bb114_12) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x101d4
      %bb118_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb118_0 = "braid.zext"(%bb118_1) {bits = 32 : i64} : (i64) -> i64
      %bb118_3 = "braid.get"() {reg = "x1"} : () -> i64
      %bb118_5 = "braid.zext"(%bb118_3) {bits = 32 : i64} : (i64) -> i64
      %bb118_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb118_7 = "braid.mul"(%bb118_5, %bb118_6) : (i64, i64) -> i64
      %bb118_8 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb118_9 = "braid.lshr"(%bb118_7, %bb118_8) : (i64, i64) -> i64
      %bb118_2 = "braid.zext"(%bb118_9) {bits = 32 : i64} : (i64) -> i64
      %bb118_12 = "braid.xor"(%bb118_0, %bb118_2) : (i64, i64) -> i64
      "braid.set"(%bb118_12) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb11c] : () -> ()
    ^bb11c:  // 0x101d8
      %bb11c_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb11c_0 = "braid.zext"(%bb11c_1) {bits = 32 : i64} : (i64) -> i64
      %bb11c_3 = "braid.get"() {reg = "x1"} : () -> i64
      %bb11c_2 = "braid.zext"(%bb11c_3) {bits = 32 : i64} : (i64) -> i64
      %bb11c_13 = "braid.not"(%bb11c_2) : (i64) -> i64
      %bb11c_12 = "braid.and"(%bb11c_0, %bb11c_13) : (i64, i64) -> i64
      "braid.set"(%bb11c_12) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x101dc
      %bb120_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bb120_0 = "braid.zext"(%bb120_1) {bits = 32 : i64} : (i64) -> i64
      %bb120_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bb120_2 = "braid.zext"(%bb120_3) {bits = 32 : i64} : (i64) -> i64
      %bb120_12 = "braid.and"(%bb120_0, %bb120_2) : (i64, i64) -> i64
      "braid.set"(%bb120_12) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bb124] : () -> ()
    ^bb124:  // 0x101e0
      %bb124_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb124_0 = "braid.zext"(%bb124_1) {bits = 32 : i64} : (i64) -> i64
      %bb124_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bb124_5 = "braid.zext"(%bb124_3) {bits = 32 : i64} : (i64) -> i64
      %bb124_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb124_7 = "braid.mul"(%bb124_5, %bb124_6) : (i64, i64) -> i64
      %bb124_8 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb124_9 = "braid.lshr"(%bb124_7, %bb124_8) : (i64, i64) -> i64
      %bb124_2 = "braid.zext"(%bb124_9) {bits = 32 : i64} : (i64) -> i64
      %bb124_12 = "braid.xor"(%bb124_0, %bb124_2) : (i64, i64) -> i64
      "braid.set"(%bb124_12) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb128] : () -> ()
    ^bb128:  // 0x101e4
      %bb128_1 = "braid.get"() {reg = "x22"} : () -> i64
      %bb128_0 = "braid.zext"(%bb128_1) {bits = 32 : i64} : (i64) -> i64
      %bb128_3 = "braid.get"() {reg = "x21"} : () -> i64
      %bb128_2 = "braid.zext"(%bb128_3) {bits = 32 : i64} : (i64) -> i64
      %bb128_12 = "braid.or"(%bb128_0, %bb128_2) : (i64, i64) -> i64
      "braid.set"(%bb128_12) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb12c] : () -> ()
    ^bb12c:  // 0x101e8
      %bb12c_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bb12c_0 = "braid.zext"(%bb12c_1) {bits = 32 : i64} : (i64) -> i64
      %bb12c_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bb12c_2 = "braid.zext"(%bb12c_3) {bits = 32 : i64} : (i64) -> i64
      %bb12c_12 = "braid.xor"(%bb12c_0, %bb12c_2) : (i64, i64) -> i64
      "braid.set"(%bb12c_12) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb130] : () -> ()
    ^bb130:  // 0x101ec
      %bb130_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb130_0 = "braid.zext"(%bb130_1) {bits = 32 : i64} : (i64) -> i64
      %bb130_3 = "braid.get"() {reg = "x1"} : () -> i64
      %bb130_5 = "braid.zext"(%bb130_3) {bits = 32 : i64} : (i64) -> i64
      %bb130_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb130_7 = "braid.mul"(%bb130_5, %bb130_6) : (i64, i64) -> i64
      %bb130_8 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb130_9 = "braid.lshr"(%bb130_7, %bb130_8) : (i64, i64) -> i64
      %bb130_2 = "braid.zext"(%bb130_9) {bits = 32 : i64} : (i64) -> i64
      %bb130_12 = "braid.xor"(%bb130_0, %bb130_2) : (i64, i64) -> i64
      "braid.set"(%bb130_12) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb134:  // 0x101f0
      %bb134_1 = "braid.get"() {reg = "x22"} : () -> i64
      %bb134_0 = "braid.zext"(%bb134_1) {bits = 32 : i64} : (i64) -> i64
      %bb134_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bb134_2 = "braid.zext"(%bb134_3) {bits = 32 : i64} : (i64) -> i64
      %bb134_12 = "braid.and"(%bb134_0, %bb134_2) : (i64, i64) -> i64
      "braid.set"(%bb134_12) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb138] : () -> ()
    ^bb138:  // 0x101f4
      %bb138_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb138_0 = "braid.zext"(%bb138_1) {bits = 32 : i64} : (i64) -> i64
      %bb138_3 = "braid.get"() {reg = "x21"} : () -> i64
      %bb138_2 = "braid.zext"(%bb138_3) {bits = 32 : i64} : (i64) -> i64
      %bb138_13 = "braid.add"(%bb138_0, %bb138_2) : (i64, i64) -> i64
      %bb138_12 = "braid.zext"(%bb138_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb138_12) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb13c] : () -> ()
    ^bb13c:  // 0x101f8
      %bb13c_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb13c_0 = "braid.zext"(%bb13c_1) {bits = 32 : i64} : (i64) -> i64
      %bb13c_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bb13c_5 = "braid.zext"(%bb13c_3) {bits = 32 : i64} : (i64) -> i64
      %bb13c_6 = "braid.const"() {value = 4294967297 : i64} : () -> i64
      %bb13c_7 = "braid.mul"(%bb13c_5, %bb13c_6) : (i64, i64) -> i64
      %bb13c_8 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb13c_9 = "braid.lshr"(%bb13c_7, %bb13c_8) : (i64, i64) -> i64
      %bb13c_2 = "braid.zext"(%bb13c_9) {bits = 32 : i64} : (i64) -> i64
      %bb13c_12 = "braid.xor"(%bb13c_0, %bb13c_2) : (i64, i64) -> i64
      "braid.set"(%bb13c_12) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb140] : () -> ()
    ^bb140:  // 0x101fc
      %bb140_1 = "braid.get"() {reg = "x22"} : () -> i64
      %bb140_0 = "braid.zext"(%bb140_1) {bits = 32 : i64} : (i64) -> i64
      %bb140_3 = "braid.get"() {reg = "x24"} : () -> i64
      %bb140_2 = "braid.zext"(%bb140_3) {bits = 32 : i64} : (i64) -> i64
      %bb140_12 = "braid.xor"(%bb140_0, %bb140_2) : (i64, i64) -> i64
      "braid.set"(%bb140_12) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb144] : () -> ()
    ^bb144:  // 0x10200
      %bb144_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb144_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb144_3 = "braid.add"(%bb144_0, %bb144_2) : (i64, i64) -> i64
      "braid.set"(%bb144_3) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb148] : () -> ()
    ^bb148:  // 0x10204
      %bb148_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb148_0 = "braid.zext"(%bb148_1) {bits = 32 : i64} : (i64) -> i64
      %bb148_3 = "braid.get"() {reg = "x7"} : () -> i64
      %bb148_2 = "braid.zext"(%bb148_3) {bits = 32 : i64} : (i64) -> i64
      %bb148_13 = "braid.add"(%bb148_0, %bb148_2) : (i64, i64) -> i64
      %bb148_12 = "braid.zext"(%bb148_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb148_12) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb14c] : () -> ()
    ^bb14c:  // 0x10208
      %bb14c_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb14c_2 = "braid.const"() {value = 256 : i64} : () -> i64
      %bb14c_3 = "braid.sub"(%bb14c_0, %bb14c_2) : (i64, i64) -> i64
      %bb14c_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14c_4 = "braid.slt"(%bb14c_3, %bb14c_8) : (i64, i64) -> i64
      %bb14c_5 = "braid.eq"(%bb14c_0, %bb14c_2) : (i64, i64) -> i64
      %bb14c_6 = "braid.ule"(%bb14c_2, %bb14c_0) : (i64, i64) -> i64
      %bb14c_9 = "braid.xor"(%bb14c_0, %bb14c_2) : (i64, i64) -> i64
      %bb14c_10 = "braid.xor"(%bb14c_0, %bb14c_3) : (i64, i64) -> i64
      %bb14c_11 = "braid.and"(%bb14c_9, %bb14c_10) : (i64, i64) -> i64
      %bb14c_7 = "braid.slt"(%bb14c_11, %bb14c_8) : (i64, i64) -> i64
      "braid.setf"(%bb14c_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb14c_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb14c_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb14c_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb150] : () -> ()
    ^bb150:  // 0x1020c
      %bb150_1 = "braid.get"() {reg = "x21"} : () -> i64
      %bb150_0 = "braid.zext"(%bb150_1) {bits = 32 : i64} : (i64) -> i64
      %bb150_3 = "braid.get"() {reg = "x20"} : () -> i64
      %bb150_2 = "braid.zext"(%bb150_3) {bits = 32 : i64} : (i64) -> i64
      %bb150_13 = "braid.add"(%bb150_0, %bb150_2) : (i64, i64) -> i64
      %bb150_12 = "braid.zext"(%bb150_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb150_12) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb154] : () -> ()
    ^bb154:  // 0x10210
      %bb154_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb154_0 = "braid.zext"(%bb154_1) {bits = 32 : i64} : (i64) -> i64
      %bb154_3 = "braid.get"() {reg = "x23"} : () -> i64
      %bb154_2 = "braid.zext"(%bb154_3) {bits = 32 : i64} : (i64) -> i64
      %bb154_13 = "braid.add"(%bb154_0, %bb154_2) : (i64, i64) -> i64
      %bb154_12 = "braid.zext"(%bb154_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb154_12) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb158] : () -> ()
    ^bb158:  // 0x10214
      %bb158_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb158_0 = "braid.zext"(%bb158_1) {bits = 32 : i64} : (i64) -> i64
      %bb158_3 = "braid.get"() {reg = "x19"} : () -> i64
      %bb158_2 = "braid.zext"(%bb158_3) {bits = 32 : i64} : (i64) -> i64
      %bb158_13 = "braid.add"(%bb158_0, %bb158_2) : (i64, i64) -> i64
      %bb158_12 = "braid.zext"(%bb158_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb158_12) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb15c] : () -> ()
    ^bb15c:  // 0x10218
      %bb15c_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb15c_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15c_0 = "braid.eq"(%bb15c_1, %bb15c_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb15c_0)[^bbdc, ^bb160] : (i64) -> ()
    ^bb160:  // 0x1021c
      %bb160_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb160_0 = "braid.zext"(%bb160_1) {bits = 32 : i64} : (i64) -> i64
      %bb160_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bb160_2 = "braid.zext"(%bb160_3) {bits = 32 : i64} : (i64) -> i64
      %bb160_13 = "braid.add"(%bb160_0, %bb160_2) : (i64, i64) -> i64
      %bb160_12 = "braid.zext"(%bb160_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb160_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb164] : () -> ()
    ^bb164:  // 0x10220
      %bb164_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb164_0 = "braid.zext"(%bb164_1) {bits = 32 : i64} : (i64) -> i64
      %bb164_3 = "braid.get"() {reg = "x4"} : () -> i64
      %bb164_2 = "braid.zext"(%bb164_3) {bits = 32 : i64} : (i64) -> i64
      %bb164_13 = "braid.add"(%bb164_0, %bb164_2) : (i64, i64) -> i64
      %bb164_12 = "braid.zext"(%bb164_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb164_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb168] : () -> ()
    ^bb168:  // 0x10224
      %bb168_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb168_0 = "braid.zext"(%bb168_1) {bits = 32 : i64} : (i64) -> i64
      %bb168_3 = "braid.get"() {reg = "x19"} : () -> i64
      %bb168_2 = "braid.zext"(%bb168_3) {bits = 32 : i64} : (i64) -> i64
      %bb168_13 = "braid.add"(%bb168_0, %bb168_2) : (i64, i64) -> i64
      %bb168_12 = "braid.zext"(%bb168_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb168_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb16c] : () -> ()
    ^bb16c:  // 0x10228
      %bb16c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb16c_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb16c_3 = "braid.get"() {reg = "x0"} : () -> i64
      %bb16c_8 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb16c_2 = "braid.add"(%bb16c_3, %bb16c_8) : (i64, i64) -> i64
      %bb16c_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb16c_24 = "braid.add"(%bb16c_2, %bb16c_23) : (i64, i64) -> i64
      "braid.store"(%bb16c_2, %bb16c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb16c_24, %bb16c_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb170] : () -> ()
    ^bb170:  // 0x1022c
      %bb170_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb170_0 = "braid.zext"(%bb170_1) {bits = 32 : i64} : (i64) -> i64
      %bb170_3 = "braid.get"() {reg = "x7"} : () -> i64
      %bb170_2 = "braid.zext"(%bb170_3) {bits = 32 : i64} : (i64) -> i64
      %bb170_13 = "braid.add"(%bb170_0, %bb170_2) : (i64, i64) -> i64
      %bb170_12 = "braid.zext"(%bb170_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb170_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb174] : () -> ()
    ^bb174:  // 0x10230
      %bb174_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb174_0 = "braid.zext"(%bb174_1) {bits = 32 : i64} : (i64) -> i64
      %bb174_3 = "braid.get"() {reg = "x1"} : () -> i64
      %bb174_2 = "braid.zext"(%bb174_3) {bits = 32 : i64} : (i64) -> i64
      %bb174_13 = "braid.add"(%bb174_0, %bb174_2) : (i64, i64) -> i64
      %bb174_12 = "braid.zext"(%bb174_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb174_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb178] : () -> ()
    ^bb178:  // 0x10234
      %bb178_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb178_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb178_3 = "braid.and"(%bb178_1, %bb178_2) : (i64, i64) -> i64
      %bb178_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb178_5 = "braid.eq"(%bb178_3, %bb178_4) : (i64, i64) -> i64
      "braid.guard"(%bb178_5) : (i64) -> ()
      %bb178_6 = "braid.const"() {value = 304 : i64} : () -> i64
      %bb178_0 = "braid.add"(%bb178_1, %bb178_6) : (i64, i64) -> i64
      %bb178_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb178_22 = "braid.add"(%bb178_0, %bb178_21) : (i64, i64) -> i64
      %bb178_23 = "braid.load"(%bb178_0) {bytes = 8 : i64} : (i64) -> i64
      %bb178_26 = "braid.load"(%bb178_22) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb178_23) {reg = "x20"} : (i64) -> ()
      "braid.set"(%bb178_26) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb17c] : () -> ()
    ^bb17c:  // 0x10238
      %bb17c_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb17c_0 = "braid.zext"(%bb17c_1) {bits = 32 : i64} : (i64) -> i64
      %bb17c_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bb17c_2 = "braid.zext"(%bb17c_3) {bits = 32 : i64} : (i64) -> i64
      %bb17c_13 = "braid.add"(%bb17c_0, %bb17c_2) : (i64, i64) -> i64
      %bb17c_12 = "braid.zext"(%bb17c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb17c_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb180] : () -> ()
    ^bb180:  // 0x1023c
      %bb180_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb180_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb180_3 = "braid.and"(%bb180_1, %bb180_2) : (i64, i64) -> i64
      %bb180_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb180_5 = "braid.eq"(%bb180_3, %bb180_4) : (i64, i64) -> i64
      "braid.guard"(%bb180_5) : (i64) -> ()
      %bb180_6 = "braid.const"() {value = 288 : i64} : () -> i64
      %bb180_0 = "braid.add"(%bb180_1, %bb180_6) : (i64, i64) -> i64
      %bb180_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb180_22 = "braid.add"(%bb180_0, %bb180_21) : (i64, i64) -> i64
      %bb180_23 = "braid.load"(%bb180_0) {bytes = 8 : i64} : (i64) -> i64
      %bb180_26 = "braid.load"(%bb180_22) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb180_23) {reg = "x22"} : (i64) -> ()
      "braid.set"(%bb180_26) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb184] : () -> ()
    ^bb184:  // 0x10240
      %bb184_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb184_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb184_3 = "braid.get"() {reg = "x0"} : () -> i64
      %bb184_8 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb184_2 = "braid.add"(%bb184_3, %bb184_8) : (i64, i64) -> i64
      %bb184_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb184_24 = "braid.add"(%bb184_2, %bb184_23) : (i64, i64) -> i64
      "braid.store"(%bb184_2, %bb184_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb184_24, %bb184_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb188] : () -> ()
    ^bb188:  // 0x10244
      %bb188_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb188_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb188_3 = "braid.and"(%bb188_1, %bb188_2) : (i64, i64) -> i64
      %bb188_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb188_5 = "braid.eq"(%bb188_3, %bb188_4) : (i64, i64) -> i64
      "braid.guard"(%bb188_5) : (i64) -> ()
      %bb188_6 = "braid.const"() {value = 272 : i64} : () -> i64
      %bb188_0 = "braid.add"(%bb188_1, %bb188_6) : (i64, i64) -> i64
      %bb188_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb188_22 = "braid.add"(%bb188_0, %bb188_21) : (i64, i64) -> i64
      %bb188_23 = "braid.load"(%bb188_0) {bytes = 8 : i64} : (i64) -> i64
      %bb188_26 = "braid.load"(%bb188_22) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb188_23) {reg = "x24"} : (i64) -> ()
      "braid.set"(%bb188_26) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb18c] : () -> ()
    ^bb18c:  // 0x10248
      %bb18c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb18c_0 = "braid.zext"(%bb18c_1) {bits = 32 : i64} : (i64) -> i64
      %bb18c_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bb18c_2 = "braid.zext"(%bb18c_3) {bits = 32 : i64} : (i64) -> i64
      %bb18c_13 = "braid.add"(%bb18c_0, %bb18c_2) : (i64, i64) -> i64
      %bb18c_12 = "braid.zext"(%bb18c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb18c_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x1024c
      %bb190_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb190_0 = "braid.zext"(%bb190_1) {bits = 32 : i64} : (i64) -> i64
      %bb190_3 = "braid.get"() {reg = "x18"} : () -> i64
      %bb190_2 = "braid.zext"(%bb190_3) {bits = 32 : i64} : (i64) -> i64
      %bb190_13 = "braid.add"(%bb190_0, %bb190_2) : (i64, i64) -> i64
      %bb190_12 = "braid.zext"(%bb190_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb190_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb194] : () -> ()
    ^bb194:  // 0x10250
      %bb194_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb194_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb194_3 = "braid.and"(%bb194_1, %bb194_2) : (i64, i64) -> i64
      %bb194_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb194_5 = "braid.eq"(%bb194_3, %bb194_4) : (i64, i64) -> i64
      "braid.guard"(%bb194_5) : (i64) -> ()
      %bb194_6 = "braid.const"() {value = 256 : i64} : () -> i64
      %bb194_0 = "braid.add"(%bb194_1, %bb194_6) : (i64, i64) -> i64
      %bb194_30 = "braid.load"(%bb194_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb194_30) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb198] : () -> ()
    ^bb198:  // 0x10254
      %bb198_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb198_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb198_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb198_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb198_24 = "braid.add"(%bb198_2, %bb198_23) : (i64, i64) -> i64
      "braid.store"(%bb198_2, %bb198_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb198_24, %bb198_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb19c] : () -> ()
    ^bb19c:  // 0x10258
      %bb19c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb19c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb19c_3 = "braid.get"() {reg = "x0"} : () -> i64
      %bb19c_8 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb19c_2 = "braid.add"(%bb19c_3, %bb19c_8) : (i64, i64) -> i64
      %bb19c_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb19c_24 = "braid.add"(%bb19c_2, %bb19c_23) : (i64, i64) -> i64
      "braid.store"(%bb19c_2, %bb19c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb19c_24, %bb19c_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1a0] : () -> ()
    ^bb1a0:  // 0x1025c
      %bb1a0_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1a0_2 = "braid.const"() {value = 320 : i64} : () -> i64
      %bb1a0_3 = "braid.add"(%bb1a0_0, %bb1a0_2) : (i64, i64) -> i64
      "braid.set"(%bb1a0_3) {reg = "sp"} : (i64) -> ()
      "braid_cf.br"()[^bb1a4] : () -> ()
    ^bb1a4:  // 0x10260
      %bb1a4_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb1a4_0) : (i64) -> ()
  }) {sym_name = "sha256_compress", entry = 65724 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
