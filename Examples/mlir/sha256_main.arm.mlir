"braid_cf.module"() ({
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
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x20328
      %bb0_0 = "braid.const"() {value = 131072 : i64} : () -> i64
      "braid.set"(%bb0_0) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x2032c
      %bb4_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb4_2 = "braid.const"() {value = 3296 : i64} : () -> i64
      %bb4_3 = "braid.add"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x20330
      %bb8_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb8_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_3 = "braid.add"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_3) {reg = "sp"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x20334
      "braid_cf.br"()[^ext20338] : () -> ()
    ^ext20338:
      "braid_cf.tail"() {target = 131896 : i64} : () -> ()
  }) {sym_name = "_start", entry = 131880 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x20338
      %bb0_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb0_2 = "braid.const"() {value = 208 : i64} : () -> i64
      %bb0_3 = "braid.sub"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_3) {reg = "sp"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x2033c
      %bb4_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb4_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb4_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb4_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb4_5 = "braid.and"(%bb4_3, %bb4_4) : (i64, i64) -> i64
      %bb4_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_7 = "braid.eq"(%bb4_5, %bb4_6) : (i64, i64) -> i64
      "braid.guard"(%bb4_7) : (i64) -> ()
      %bb4_8 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_3, %bb4_8) : (i64, i64) -> i64
      %bb4_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb4_24 = "braid.add"(%bb4_2, %bb4_23) : (i64, i64) -> i64
      "braid.store"(%bb4_2, %bb4_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb4_24, %bb4_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x20340
      %bb8_0 = "braid.const"() {value = 131072 : i64} : () -> i64
      "braid.set"(%bb8_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x20344
      %bbc_0 = "braid.const"() {value = 62322 : i64} : () -> i64
      "braid.set"(%bbc_0) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x20348
      %bb10_0 = "braid.get"() {reg = "x26"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "x25"} : () -> i64
      %bb10_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb10_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb10_5 = "braid.and"(%bb10_3, %bb10_4) : (i64, i64) -> i64
      %bb10_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_7 = "braid.eq"(%bb10_5, %bb10_6) : (i64, i64) -> i64
      "braid.guard"(%bb10_7) : (i64) -> ()
      %bb10_8 = "braid.const"() {value = 144 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_3, %bb10_8) : (i64, i64) -> i64
      %bb10_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb10_24 = "braid.add"(%bb10_2, %bb10_23) : (i64, i64) -> i64
      "braid.store"(%bb10_2, %bb10_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb10_24, %bb10_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x2034c
      %bb14_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb14_2 = "braid.const"() {value = -4294901761 : i64} : () -> i64
      %bb14_3 = "braid.and"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      %bb14_4 = "braid.const"() {value = 1013841920 : i64} : () -> i64
      %bb14_5 = "braid.or"(%bb14_3, %bb14_4) : (i64, i64) -> i64
      "braid.set"(%bb14_5) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x20350
      %bb18_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb18_2 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb18_3 = "braid.add"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      "braid.set"(%bb18_3) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x20354
      %bb1c_0 = "braid.get"() {reg = "x24"} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bb1c_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1c_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1c_5 = "braid.and"(%bb1c_3, %bb1c_4) : (i64, i64) -> i64
      %bb1c_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_7 = "braid.eq"(%bb1c_5, %bb1c_6) : (i64, i64) -> i64
      "braid.guard"(%bb1c_7) : (i64) -> ()
      %bb1c_8 = "braid.const"() {value = 160 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_3, %bb1c_8) : (i64, i64) -> i64
      %bb1c_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c_24 = "braid.add"(%bb1c_2, %bb1c_23) : (i64, i64) -> i64
      "braid.store"(%bb1c_2, %bb1c_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb1c_24, %bb1c_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x20358
      %bb20_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb20_2 = "braid.const"() {value = -281470681743361 : i64} : () -> i64
      %bb20_3 = "braid.and"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      %bb20_4 = "braid.const"() {value = 269629456908288 : i64} : () -> i64
      %bb20_5 = "braid.or"(%bb20_3, %bb20_4) : (i64, i64) -> i64
      "braid.set"(%bb20_5) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x2035c
      %bb24_0 = "braid.const"() {value = 55723 : i64} : () -> i64
      "braid.set"(%bb24_0) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x20360
      %bb28_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "x21"} : () -> i64
      %bb28_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb28_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb28_5 = "braid.and"(%bb28_3, %bb28_4) : (i64, i64) -> i64
      %bb28_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_7 = "braid.eq"(%bb28_5, %bb28_6) : (i64, i64) -> i64
      "braid.guard"(%bb28_7) : (i64) -> ()
      %bb28_8 = "braid.const"() {value = 176 : i64} : () -> i64
      %bb28_2 = "braid.add"(%bb28_3, %bb28_8) : (i64, i64) -> i64
      %bb28_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb28_24 = "braid.add"(%bb28_2, %bb28_23) : (i64, i64) -> i64
      "braid.store"(%bb28_2, %bb28_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb28_24, %bb28_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x20364
      %bb2c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb2c_2 = "braid.const"() {value = 281474976710655 : i64} : () -> i64
      %bb2c_3 = "braid.and"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      %bb2c_4 = "braid.const"() {value = -6535004534291300352 : i64} : () -> i64
      %bb2c_5 = "braid.or"(%bb2c_3, %bb2c_4) : (i64, i64) -> i64
      "braid.set"(%bb2c_5) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x20368
      %bb30_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb30_2 = "braid.const"() {value = -4294901761 : i64} : () -> i64
      %bb30_3 = "braid.and"(%bb30_0, %bb30_2) : (i64, i64) -> i64
      %bb30_4 = "braid.const"() {value = 528678912 : i64} : () -> i64
      %bb30_5 = "braid.or"(%bb30_3, %bb30_4) : (i64, i64) -> i64
      "braid.set"(%bb30_5) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x2036c
      %bb34_0 = "braid.get"() {reg = "x20"} : () -> i64
      %bb34_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb34_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb34_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb34_5 = "braid.and"(%bb34_3, %bb34_4) : (i64, i64) -> i64
      %bb34_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb34_7 = "braid.eq"(%bb34_5, %bb34_6) : (i64, i64) -> i64
      "braid.guard"(%bb34_7) : (i64) -> ()
      %bb34_8 = "braid.const"() {value = 192 : i64} : () -> i64
      %bb34_2 = "braid.add"(%bb34_3, %bb34_8) : (i64, i64) -> i64
      %bb34_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb34_24 = "braid.add"(%bb34_2, %bb34_23) : (i64, i64) -> i64
      "braid.store"(%bb34_2, %bb34_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb34_24, %bb34_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x20370
      %bb38_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb38_2 = "braid.const"() {value = -281470681743361 : i64} : () -> i64
      %bb38_3 = "braid.and"(%bb38_0, %bb38_2) : (i64, i64) -> i64
      %bb38_4 = "braid.const"() {value = 225507257876480 : i64} : () -> i64
      %bb38_5 = "braid.or"(%bb38_3, %bb38_4) : (i64, i64) -> i64
      "braid.set"(%bb38_5) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x20374
      %bb3c_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb3c_6 = "braid.const"() {value = 1232 : i64} : () -> i64
      %bb3c_0 = "braid.add"(%bb3c_1, %bb3c_6) : (i64, i64) -> i64
      %bb3c_30 = "braid.load"(%bb3c_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb3c_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x20378
      %bb40_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb40_2 = "braid.const"() {value = 281474976710655 : i64} : () -> i64
      %bb40_3 = "braid.and"(%bb40_0, %bb40_2) : (i64, i64) -> i64
      %bb40_4 = "braid.const"() {value = 6620291452234629120 : i64} : () -> i64
      %bb40_5 = "braid.or"(%bb40_3, %bb40_4) : (i64, i64) -> i64
      "braid.set"(%bb40_5) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x2037c
      %bb44_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb44_30 = "braid.load"(%bb44_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb44_30) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x20380
      %bb48_0 = "braid.const"() {value = 58983 : i64} : () -> i64
      "braid.set"(%bb48_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x20384
      %bb4c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb4c_2 = "braid.const"() {value = -4294901761 : i64} : () -> i64
      %bb4c_3 = "braid.and"(%bb4c_0, %bb4c_2) : (i64, i64) -> i64
      %bb4c_4 = "braid.const"() {value = 1778974720 : i64} : () -> i64
      %bb4c_5 = "braid.or"(%bb4c_3, %bb4c_4) : (i64, i64) -> i64
      "braid.set"(%bb4c_5) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x20388
      %bb50_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb50_2 = "braid.const"() {value = -281470681743361 : i64} : () -> i64
      %bb50_3 = "braid.and"(%bb50_0, %bb50_2) : (i64, i64) -> i64
      %bb50_4 = "braid.const"() {value = 191886253883392 : i64} : () -> i64
      %bb50_5 = "braid.or"(%bb50_3, %bb50_4) : (i64, i64) -> i64
      "braid.set"(%bb50_5) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x2038c
      %bb54_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb54_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb54_3 = "braid.add"(%bb54_0, %bb54_2) : (i64, i64) -> i64
      "braid.set"(%bb54_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x20390
      %bb58_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb58_2 = "braid.const"() {value = 281474976710655 : i64} : () -> i64
      %bb58_3 = "braid.and"(%bb58_0, %bb58_2) : (i64, i64) -> i64
      %bb58_4 = "braid.const"() {value = -4942982066015830016 : i64} : () -> i64
      %bb58_5 = "braid.or"(%bb58_3, %bb58_4) : (i64, i64) -> i64
      "braid.set"(%bb58_5) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x20394
      %bb5c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb5c_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb5c_3 = "braid.get"() {reg = "x29"} : () -> i64
      %bb5c_8 = "braid.const"() {value = -32 : i64} : () -> i64
      %bb5c_2 = "braid.add"(%bb5c_3, %bb5c_8) : (i64, i64) -> i64
      %bb5c_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb5c_24 = "braid.add"(%bb5c_2, %bb5c_23) : (i64, i64) -> i64
      "braid.store"(%bb5c_2, %bb5c_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb5c_24, %bb5c_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x20398
      %bb60_0 = "braid.const"() {value = 21119 : i64} : () -> i64
      "braid.set"(%bb60_0) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x2039c
      %bb64_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb64_2 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb64_3 = "braid.and"(%bb64_0, %bb64_2) : (i64, i64) -> i64
      "braid.set"(%bb64_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x203a0
      %bb68_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb68_2 = "braid.const"() {value = -4294901761 : i64} : () -> i64
      %bb68_3 = "braid.and"(%bb68_0, %bb68_2) : (i64, i64) -> i64
      %bb68_4 = "braid.const"() {value = 1359872000 : i64} : () -> i64
      %bb68_5 = "braid.or"(%bb68_3, %bb68_4) : (i64, i64) -> i64
      "braid.set"(%bb68_5) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x203a4
      %bb6c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb6c_2 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb6c_3 = "braid.add"(%bb6c_0, %bb6c_2) : (i64, i64) -> i64
      %bb6c_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6c_4 = "braid.slt"(%bb6c_3, %bb6c_8) : (i64, i64) -> i64
      %bb6c_5 = "braid.eq"(%bb6c_3, %bb6c_8) : (i64, i64) -> i64
      %bb6c_6 = "braid.ult"(%bb6c_3, %bb6c_0) : (i64, i64) -> i64
      %bb6c_9 = "braid.xor"(%bb6c_0, %bb6c_3) : (i64, i64) -> i64
      %bb6c_10 = "braid.xor"(%bb6c_2, %bb6c_3) : (i64, i64) -> i64
      %bb6c_11 = "braid.and"(%bb6c_9, %bb6c_10) : (i64, i64) -> i64
      %bb6c_7 = "braid.slt"(%bb6c_11, %bb6c_8) : (i64, i64) -> i64
      "braid.setf"(%bb6c_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb6c_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb6c_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb6c_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb6c_3) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x203a8
      %bb70_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb70_2 = "braid.const"() {value = -281470681743361 : i64} : () -> i64
      %bb70_3 = "braid.and"(%bb70_0, %bb70_2) : (i64, i64) -> i64
      %bb70_4 = "braid.const"() {value = 114950504710144 : i64} : () -> i64
      %bb70_5 = "braid.or"(%bb70_3, %bb70_4) : (i64, i64) -> i64
      "braid.set"(%bb70_5) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x203ac
      %bb74_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb74_2 = "braid.const"() {value = 281474976710655 : i64} : () -> i64
      %bb74_3 = "braid.and"(%bb74_0, %bb74_2) : (i64, i64) -> i64
      %bb74_4 = "braid.const"() {value = -7276409622947168256 : i64} : () -> i64
      %bb74_5 = "braid.or"(%bb74_3, %bb74_4) : (i64, i64) -> i64
      "braid.set"(%bb74_5) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x203b0
      %bb78_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb78_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb78_3 = "braid.get"() {reg = "x29"} : () -> i64
      %bb78_8 = "braid.const"() {value = -16 : i64} : () -> i64
      %bb78_2 = "braid.add"(%bb78_3, %bb78_8) : (i64, i64) -> i64
      %bb78_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb78_24 = "braid.add"(%bb78_2, %bb78_23) : (i64, i64) -> i64
      "braid.store"(%bb78_2, %bb78_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb78_24, %bb78_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x203b4
      %bb7c_0 = "braid.getf"() {flag = "z"} : () -> i64
      "braid_cf.cond_br"(%bb7c_0)[^bb148, ^bb80] : (i64) -> ()
    ^bb80:  // 0x203b8
      %bb80_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb80_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb80_20 = "braid.shl"(%bb80_0, %bb80_3) : (i64, i64) -> i64
      "braid.set"(%bb80_20) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x203bc
      %bb84_0 = "braid.const"() {value = 131072 : i64} : () -> i64
      "braid.set"(%bb84_0) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x203c0
      %bb88_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb88_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb88_20 = "braid.shl"(%bb88_0, %bb88_3) : (i64, i64) -> i64
      "braid.set"(%bb88_20) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x203c4
      %bb8c_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bb8c_6 = "braid.const"() {value = 1240 : i64} : () -> i64
      %bb8c_0 = "braid.add"(%bb8c_1, %bb8c_6) : (i64, i64) -> i64
      %bb8c_30 = "braid.load"(%bb8c_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb8c_30) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x203c8
      %bb90_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb90_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb90_12 = "braid.or"(%bb90_0, %bb90_2) : (i64, i64) -> i64
      "braid.set"(%bb90_12) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x203cc
      %bb94_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb94_2 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb94_3 = "braid.or"(%bb94_0, %bb94_2) : (i64, i64) -> i64
      "braid.set"(%bb94_3) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x203d0
      %bb98_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb98_2 = "braid.const"() {value = 504 : i64} : () -> i64
      %bb98_3 = "braid.or"(%bb98_0, %bb98_2) : (i64, i64) -> i64
      "braid.set"(%bb98_3) {reg = "x25"} : (i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x203d4
      %bb9c_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb9c_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb9c_3 = "braid.add"(%bb9c_0, %bb9c_2) : (i64, i64) -> i64
      "braid.set"(%bb9c_3) {reg = "x26"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x203d8
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bba4:  // 0x203dc
      %bba4_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bba4_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bba4_3 = "braid.sub"(%bba4_0, %bba4_2) : (i64, i64) -> i64
      "braid.set"(%bba4_3) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x203e0
      %bba8_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bba8_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bba8_3 = "braid.add"(%bba8_0, %bba8_2) : (i64, i64) -> i64
      "braid.set"(%bba8_3) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x203e4
      %bbac_0 = "braid.const"() {value = 132072 : i64} : () -> i64
      "braid.set"(%bbac_0) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^ext100bc] : () -> ()
    ^bbb0:  // 0x203e8
      %bbb0_0 = "braid.get"() {reg = "x21"} : () -> i64
      %bbb0_2 = "braid.const"() {value = 64 : i64} : () -> i64
      %bbb0_3 = "braid.add"(%bbb0_0, %bbb0_2) : (i64, i64) -> i64
      "braid.set"(%bbb0_3) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x203ec
      %bbb4_0 = "braid.get"() {reg = "x25"} : () -> i64
      %bbb4_2 = "braid.const"() {value = 512 : i64} : () -> i64
      %bbb4_3 = "braid.sub"(%bbb4_0, %bbb4_2) : (i64, i64) -> i64
      "braid.set"(%bbb4_3) {reg = "x25"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x203f0
      %bbb8_0 = "braid.get"() {reg = "x21"} : () -> i64
      %bbb8_2 = "braid.get"() {reg = "x20"} : () -> i64
      %bbb8_12 = "braid.sub"(%bbb8_0, %bbb8_2) : (i64, i64) -> i64
      %bbb8_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb8_13 = "braid.slt"(%bbb8_12, %bbb8_17) : (i64, i64) -> i64
      %bbb8_14 = "braid.eq"(%bbb8_0, %bbb8_2) : (i64, i64) -> i64
      %bbb8_15 = "braid.ule"(%bbb8_2, %bbb8_0) : (i64, i64) -> i64
      %bbb8_18 = "braid.xor"(%bbb8_0, %bbb8_2) : (i64, i64) -> i64
      %bbb8_19 = "braid.xor"(%bbb8_0, %bbb8_12) : (i64, i64) -> i64
      %bbb8_20 = "braid.and"(%bbb8_18, %bbb8_19) : (i64, i64) -> i64
      %bbb8_16 = "braid.slt"(%bbb8_20, %bbb8_17) : (i64, i64) -> i64
      "braid.setf"(%bbb8_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bbb8_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bbb8_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bbb8_16) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x203f4
      %bbbc_0 = "braid.getf"() {flag = "c"} : () -> i64
      "braid_cf.cond_br"(%bbbc_0)[^bb148, ^bbc0] : (i64) -> ()
    ^bbc0:  // 0x203f8
      %bbc0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc0_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc0_12 = "braid.or"(%bbc0_0, %bbc0_2) : (i64, i64) -> i64
      "braid.set"(%bbc0_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x203fc
      %bbc4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc4_2 = "braid.get"() {reg = "x21"} : () -> i64
      %bbc4_12 = "braid.or"(%bbc4_0, %bbc4_2) : (i64, i64) -> i64
      "braid.set"(%bbc4_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x20400
      %bbc8_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc8_2 = "braid.get"() {reg = "x25"} : () -> i64
      %bbc8_12 = "braid.or"(%bbc8_0, %bbc8_2) : (i64, i64) -> i64
      "braid.set"(%bbc8_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x20404
      "braid_cf.br"()[^bbe8] : () -> ()
    ^bbd0:  // 0x20408
      %bbd0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbd0_2 = "braid.get"() {reg = "x26"} : () -> i64
      %bbd0_8 = "braid.get"() {reg = "x8"} : () -> i64
      %bbd0_9 = "braid.const"() {value = 2 : i64} : () -> i64
      %bbd0_7 = "braid.shl"(%bbd0_8, %bbd0_9) : (i64, i64) -> i64
      %bbd0_1 = "braid.add"(%bbd0_2, %bbd0_7) : (i64, i64) -> i64
      "braid.store"(%bbd0_1, %bbd0_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x2040c
      %bbd4_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bbd4_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd4_3 = "braid.add"(%bbd4_0, %bbd4_2) : (i64, i64) -> i64
      "braid.set"(%bbd4_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bbd8] : () -> ()
    ^bbd8:  // 0x20410
      %bbd8_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbd8_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbd8_3 = "braid.sub"(%bbd8_0, %bbd8_2) : (i64, i64) -> i64
      "braid.set"(%bbd8_3) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x20414
      %bbdc_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bbdc_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbdc_3 = "braid.sub"(%bbdc_0, %bbdc_2) : (i64, i64) -> i64
      %bbdc_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbdc_4 = "braid.slt"(%bbdc_3, %bbdc_8) : (i64, i64) -> i64
      %bbdc_5 = "braid.eq"(%bbdc_0, %bbdc_2) : (i64, i64) -> i64
      %bbdc_6 = "braid.ule"(%bbdc_2, %bbdc_0) : (i64, i64) -> i64
      %bbdc_9 = "braid.xor"(%bbdc_0, %bbdc_2) : (i64, i64) -> i64
      %bbdc_10 = "braid.xor"(%bbdc_0, %bbdc_3) : (i64, i64) -> i64
      %bbdc_11 = "braid.and"(%bbdc_9, %bbdc_10) : (i64, i64) -> i64
      %bbdc_7 = "braid.slt"(%bbdc_11, %bbdc_8) : (i64, i64) -> i64
      "braid.setf"(%bbdc_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bbdc_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bbdc_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bbdc_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bbe0] : () -> ()
    ^bbe0:  // 0x20418
      %bbe0_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bbe0_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbe0_3 = "braid.add"(%bbe0_0, %bbe0_2) : (i64, i64) -> i64
      "braid.set"(%bbe0_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x2041c
      %bbe4_0 = "braid.getf"() {flag = "z"} : () -> i64
      "braid_cf.cond_br"(%bbe4_0)[^bba4, ^bbe8] : (i64) -> ()
    ^bbe8:  // 0x20420
      %bbe8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe8_0 = "braid.zext"(%bbe8_1) {bits = 32 : i64} : (i64) -> i64
      %bbe8_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe8_2 = "braid.zext"(%bbe8_3) {bits = 32 : i64} : (i64) -> i64
      %bbe8_12 = "braid.or"(%bbe8_0, %bbe8_2) : (i64, i64) -> i64
      "braid.set"(%bbe8_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bbec] : () -> ()
    ^bbec:  // 0x20424
      %bbec_0 = "braid.const"() {value = -32 : i64} : () -> i64
      "braid.set"(%bbec_0) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbf0] : () -> ()
    ^bbf0:  // 0x20428
      %bbf0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf0_2 = "braid.get"() {reg = "x9"} : () -> i64
      %bbf0_12 = "braid.or"(%bbf0_0, %bbf0_2) : (i64, i64) -> i64
      "braid.set"(%bbf0_12) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbf4] : () -> ()
    ^bbf4:  // 0x2042c
      %bbf4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf4_2 = "braid.get"() {reg = "x10"} : () -> i64
      %bbf4_12 = "braid.or"(%bbf4_0, %bbf4_2) : (i64, i64) -> i64
      "braid.set"(%bbf4_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bbf8] : () -> ()
    ^bbf8:  // 0x20430
      "braid_cf.br"()[^bb114] : () -> ()
    ^bbfc:  // 0x20434
      %bbfc_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bbfc_6 = "braid.get"() {reg = "x13"} : () -> i64
      %bbfc_0 = "braid.add"(%bbfc_1, %bbfc_6) : (i64, i64) -> i64
      %bbfc_30 = "braid.load"(%bbfc_0) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bbfc_30) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb100:  // 0x20438
      %bb100_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb100_0 = "braid.zext"(%bb100_1) {bits = 32 : i64} : (i64) -> i64
      %bb100_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb100_4 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb100_5 = "braid.shl"(%bb100_3, %bb100_4) : (i64, i64) -> i64
      %bb100_2 = "braid.zext"(%bb100_5) {bits = 32 : i64} : (i64) -> i64
      %bb100_12 = "braid.or"(%bb100_0, %bb100_2) : (i64, i64) -> i64
      "braid.set"(%bb100_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb104] : () -> ()
    ^bb104:  // 0x2043c
      %bb104_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb104_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb104_3 = "braid.add"(%bb104_0, %bb104_2) : (i64, i64) -> i64
      "braid.set"(%bb104_3) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x20440
      %bb108_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb108_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb108_3 = "braid.sub"(%bb108_0, %bb108_2) : (i64, i64) -> i64
      "braid.set"(%bb108_3) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb10c] : () -> ()
    ^bb10c:  // 0x20444
      %bb10c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb10c_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10c_3 = "braid.add"(%bb10c_0, %bb10c_2) : (i64, i64) -> i64
      "braid.set"(%bb10c_3) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb110] : () -> ()
    ^bb110:  // 0x20448
      %bb110_0 = "braid.get"() {reg = "x12"} : () -> i64
      "braid_cf.cond_br"(%bb110_0)[^bb114, ^bbd0] : (i64) -> ()
    ^bb114:  // 0x2044c
      %bb114_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb114_2 = "braid.get"() {reg = "x19"} : () -> i64
      %bb114_12 = "braid.sub"(%bb114_0, %bb114_2) : (i64, i64) -> i64
      %bb114_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb114_13 = "braid.slt"(%bb114_12, %bb114_17) : (i64, i64) -> i64
      %bb114_14 = "braid.eq"(%bb114_0, %bb114_2) : (i64, i64) -> i64
      %bb114_15 = "braid.ule"(%bb114_2, %bb114_0) : (i64, i64) -> i64
      %bb114_18 = "braid.xor"(%bb114_0, %bb114_2) : (i64, i64) -> i64
      %bb114_19 = "braid.xor"(%bb114_0, %bb114_12) : (i64, i64) -> i64
      %bb114_20 = "braid.and"(%bb114_18, %bb114_19) : (i64, i64) -> i64
      %bb114_16 = "braid.slt"(%bb114_20, %bb114_17) : (i64, i64) -> i64
      "braid.setf"(%bb114_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb114_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb114_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb114_16) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x20450
      %bb118_1 = "braid.getf"() {flag = "c"} : () -> i64
      %bb118_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb118_0 = "braid.eq"(%bb118_1, %bb118_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb118_0)[^bbfc, ^bb11c] : (i64) -> ()
    ^bb11c:  // 0x20454
      %bb11c_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb11c_2 = "braid.get"() {reg = "x13"} : () -> i64
      %bb11c_12 = "braid.sub"(%bb11c_0, %bb11c_2) : (i64, i64) -> i64
      %bb11c_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb11c_13 = "braid.slt"(%bb11c_12, %bb11c_17) : (i64, i64) -> i64
      %bb11c_14 = "braid.eq"(%bb11c_0, %bb11c_2) : (i64, i64) -> i64
      %bb11c_15 = "braid.ule"(%bb11c_2, %bb11c_0) : (i64, i64) -> i64
      %bb11c_18 = "braid.xor"(%bb11c_0, %bb11c_2) : (i64, i64) -> i64
      %bb11c_19 = "braid.xor"(%bb11c_0, %bb11c_12) : (i64, i64) -> i64
      %bb11c_20 = "braid.and"(%bb11c_18, %bb11c_19) : (i64, i64) -> i64
      %bb11c_16 = "braid.slt"(%bb11c_20, %bb11c_17) : (i64, i64) -> i64
      "braid.setf"(%bb11c_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb11c_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb11c_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb11c_16) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x20458
      %bb120_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb120_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb120_0 = "braid.eq"(%bb120_1, %bb120_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb120_0)[^bb12c, ^bb124] : (i64) -> ()
    ^bb124:  // 0x2045c
      %bb124_0 = "braid.const"() {value = 128 : i64} : () -> i64
      "braid.set"(%bb124_0) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb128] : () -> ()
    ^bb128:  // 0x20460
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb12c:  // 0x20464
      %bb12c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb12c_2 = "braid.get"() {reg = "x24"} : () -> i64
      %bb12c_12 = "braid.sub"(%bb12c_0, %bb12c_2) : (i64, i64) -> i64
      %bb12c_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12c_13 = "braid.slt"(%bb12c_12, %bb12c_17) : (i64, i64) -> i64
      %bb12c_14 = "braid.eq"(%bb12c_0, %bb12c_2) : (i64, i64) -> i64
      %bb12c_15 = "braid.ule"(%bb12c_2, %bb12c_0) : (i64, i64) -> i64
      %bb12c_18 = "braid.xor"(%bb12c_0, %bb12c_2) : (i64, i64) -> i64
      %bb12c_19 = "braid.xor"(%bb12c_0, %bb12c_12) : (i64, i64) -> i64
      %bb12c_20 = "braid.and"(%bb12c_18, %bb12c_19) : (i64, i64) -> i64
      %bb12c_16 = "braid.slt"(%bb12c_20, %bb12c_17) : (i64, i64) -> i64
      "braid.setf"(%bb12c_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb12c_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb12c_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb12c_16) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb130] : () -> ()
    ^bb130:  // 0x20468
      %bb130_0 = "braid.getf"() {flag = "c"} : () -> i64
      "braid_cf.cond_br"(%bb130_0)[^bb13c, ^bb134] : (i64) -> ()
    ^bb134:  // 0x2046c
      %bb134_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb134_0 = "braid.zext"(%bb134_1) {bits = 32 : i64} : (i64) -> i64
      %bb134_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb134_2 = "braid.zext"(%bb134_3) {bits = 32 : i64} : (i64) -> i64
      %bb134_12 = "braid.or"(%bb134_0, %bb134_2) : (i64, i64) -> i64
      "braid.set"(%bb134_12) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb138] : () -> ()
    ^bb138:  // 0x20470
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb13c:  // 0x20474
      %bb13c_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bb13c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb13c_2 = "braid.const"() {value = 63 : i64} : () -> i64
      %bb13c_3 = "braid.and"(%bb13c_1, %bb13c_2) : (i64, i64) -> i64
      %bb13c_9 = "braid.lshr"(%bb13c_0, %bb13c_3) : (i64, i64) -> i64
      "braid.set"(%bb13c_9) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb140] : () -> ()
    ^bb140:  // 0x20478
      %bb140_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb140_0 = "braid.zext"(%bb140_1) {bits = 32 : i64} : (i64) -> i64
      %bb140_2 = "braid.const"() {value = 255 : i64} : () -> i64
      %bb140_3 = "braid.and"(%bb140_0, %bb140_2) : (i64, i64) -> i64
      "braid.set"(%bb140_3) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb144] : () -> ()
    ^bb144:  // 0x2047c
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb148:  // 0x20480
      %bb148_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb148_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb148_3 = "braid.add"(%bb148_0, %bb148_2) : (i64, i64) -> i64
      "braid.set"(%bb148_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb14c] : () -> ()
    ^bb14c:  // 0x20484
      %bb14c_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14c_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14c_12 = "braid.or"(%bb14c_0, %bb14c_2) : (i64, i64) -> i64
      "braid.set"(%bb14c_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb150] : () -> ()
    ^bb150:  // 0x20488
      %bb150_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb150_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb150_3 = "braid.sub"(%bb150_0, %bb150_2) : (i64, i64) -> i64
      "braid.set"(%bb150_3) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb154] : () -> ()
    ^bb154:  // 0x2048c
      %bb154_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb154_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb154_3 = "braid.add"(%bb154_0, %bb154_2) : (i64, i64) -> i64
      "braid.set"(%bb154_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb158] : () -> ()
    ^bb158:  // 0x20490
      %bb158_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb158_7 = "braid.get"() {reg = "x8"} : () -> i64
      %bb158_8 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb158_6 = "braid.shl"(%bb158_7, %bb158_8) : (i64, i64) -> i64
      %bb158_0 = "braid.add"(%bb158_1, %bb158_6) : (i64, i64) -> i64
      %bb158_30 = "braid.load"(%bb158_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb158_30) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb15c] : () -> ()
    ^bb15c:  // 0x20494
      %bb15c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb15c_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb15c_3 = "braid.add"(%bb15c_0, %bb15c_2) : (i64, i64) -> i64
      "braid.set"(%bb15c_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb160] : () -> ()
    ^bb160:  // 0x20498
      %bb160_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb160_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb160_3 = "braid.sub"(%bb160_0, %bb160_2) : (i64, i64) -> i64
      %bb160_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb160_4 = "braid.slt"(%bb160_3, %bb160_8) : (i64, i64) -> i64
      %bb160_5 = "braid.eq"(%bb160_0, %bb160_2) : (i64, i64) -> i64
      %bb160_6 = "braid.ule"(%bb160_2, %bb160_0) : (i64, i64) -> i64
      %bb160_9 = "braid.xor"(%bb160_0, %bb160_2) : (i64, i64) -> i64
      %bb160_10 = "braid.xor"(%bb160_0, %bb160_3) : (i64, i64) -> i64
      %bb160_11 = "braid.and"(%bb160_9, %bb160_10) : (i64, i64) -> i64
      %bb160_7 = "braid.slt"(%bb160_11, %bb160_8) : (i64, i64) -> i64
      "braid.setf"(%bb160_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb160_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb160_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb160_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb164] : () -> ()
    ^bb164:  // 0x2049c
      %bb164_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb164_0 = "braid.zext"(%bb164_1) {bits = 32 : i64} : (i64) -> i64
      %bb164_1 = "braid.bswap"(%bb164_0) : (i64) -> i64
      %bb164_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb164_9 = "braid.lshr"(%bb164_1, %bb164_2) : (i64, i64) -> i64
      "braid.set"(%bb164_9) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb168] : () -> ()
    ^bb168:  // 0x204a0
      %bb168_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb168_2 = "braid.get"() {reg = "x9"} : () -> i64
      %bb168_7 = "braid.const"() {value = -1 : i64} : () -> i64
      %bb168_1 = "braid.add"(%bb168_2, %bb168_7) : (i64, i64) -> i64
      "braid.store"(%bb168_1, %bb168_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb16c] : () -> ()
    ^bb16c:  // 0x204a4
      %bb16c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb16c_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb16c_3 = "braid.add"(%bb16c_0, %bb16c_2) : (i64, i64) -> i64
      "braid.set"(%bb16c_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb170] : () -> ()
    ^bb170:  // 0x204a8
      %bb170_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb170_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb170_0 = "braid.eq"(%bb170_1, %bb170_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb170_0)[^bb158, ^bb174] : (i64) -> ()
    ^bb174:  // 0x204ac
      %bb174_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bb174_0) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb178] : () -> ()
    ^bb178:  // 0x204b0
      %bb178_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb178_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb178_3 = "braid.add"(%bb178_0, %bb178_2) : (i64, i64) -> i64
      "braid.set"(%bb178_3) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bb17c] : () -> ()
    ^bb17c:  // 0x204b4
      %bb17c_0 = "braid.const"() {value = 32 : i64} : () -> i64
      "braid.set"(%bb17c_0) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb180] : () -> ()
    ^bb180:  // 0x204b8
      %bb180_0 = "braid.const"() {value = 64 : i64} : () -> i64
      "braid.set"(%bb180_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb184] : () -> ()
    ^bb184:  // 0x204bc
      %bb184_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb184_1 = "braid.const"() {value = 93 : i64} : () -> i64
      %bb184_2 = "braid.eq"(%bb184_0, %bb184_1) : (i64, i64) -> i64
      %bb184_3 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb184_4 = "braid.eq"(%bb184_0, %bb184_3) : (i64, i64) -> i64
      %bb184_5 = "braid.or"(%bb184_2, %bb184_4) : (i64, i64) -> i64
      "braid.guard"(%bb184_5) : (i64) -> ()
      %bb184_6 = "braid.get"() {reg = "x0"} : () -> i64
      %bb184_7 = "braid.get"() {reg = "x1"} : () -> i64
      %bb184_8 = "braid.get"() {reg = "x2"} : () -> i64
      %bb184_9 = "braid.zext"(%bb184_6) {bits = 32 : i64} : (i64) -> i64
      %bb184_10 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb184_11 = "braid.eq"(%bb184_9, %bb184_10) : (i64, i64) -> i64
      %bb184_12 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb184_13 = "braid.ne"(%bb184_8, %bb184_12) : (i64, i64) -> i64
      %bb184_14 = "braid.const"() {value = 2147479552 : i64} : () -> i64
      %bb184_15 = "braid.ule"(%bb184_8, %bb184_14) : (i64, i64) -> i64
      %bb184_16 = "braid.const"() {value = 281474976710656 : i64} : () -> i64
      %bb184_17 = "braid.sub"(%bb184_16, %bb184_8) : (i64, i64) -> i64
      %bb184_18 = "braid.ule"(%bb184_7, %bb184_17) : (i64, i64) -> i64
      %bb184_19 = "braid.and"(%bb184_11, %bb184_13) : (i64, i64) -> i64
      %bb184_20 = "braid.and"(%bb184_19, %bb184_15) : (i64, i64) -> i64
      %bb184_21 = "braid.and"(%bb184_20, %bb184_18) : (i64, i64) -> i64
      %bb184_22 = "braid.or"(%bb184_2, %bb184_21) : (i64, i64) -> i64
      "braid.guard"(%bb184_22) : (i64) -> ()
      %bb184_23 = "braid.select"(%bb184_4, %bb184_8, %bb184_12) : (i64, i64, i64) -> i64
      "braid.out"(%bb184_7, %bb184_23) : (i64, i64) -> ()
      %bb184_24 = "braid.select"(%bb184_4, %bb184_8, %bb184_6) : (i64, i64, i64) -> i64
      "braid.set"(%bb184_24) {reg = "x0"} : (i64) -> ()
      "braid_cf.exit"(%bb184_2, %bb184_6)[^bb184, ^bb188] : (i64, i64) -> ()
    ^bb188:  // 0x204c0
      %bb188_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb188_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb188_12 = "braid.or"(%bb188_0, %bb188_2) : (i64, i64) -> i64
      "braid.set"(%bb188_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb18c] : () -> ()
    ^bb18c:  // 0x204c4
      %bb18c_0 = "braid.const"() {value = 93 : i64} : () -> i64
      "braid.set"(%bb18c_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x204c8
      %bb190_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb190_1 = "braid.const"() {value = 93 : i64} : () -> i64
      %bb190_2 = "braid.eq"(%bb190_0, %bb190_1) : (i64, i64) -> i64
      %bb190_3 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb190_4 = "braid.eq"(%bb190_0, %bb190_3) : (i64, i64) -> i64
      %bb190_5 = "braid.or"(%bb190_2, %bb190_4) : (i64, i64) -> i64
      "braid.guard"(%bb190_5) : (i64) -> ()
      %bb190_6 = "braid.get"() {reg = "x0"} : () -> i64
      %bb190_7 = "braid.get"() {reg = "x1"} : () -> i64
      %bb190_8 = "braid.get"() {reg = "x2"} : () -> i64
      %bb190_9 = "braid.zext"(%bb190_6) {bits = 32 : i64} : (i64) -> i64
      %bb190_10 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb190_11 = "braid.eq"(%bb190_9, %bb190_10) : (i64, i64) -> i64
      %bb190_12 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb190_13 = "braid.ne"(%bb190_8, %bb190_12) : (i64, i64) -> i64
      %bb190_14 = "braid.const"() {value = 2147479552 : i64} : () -> i64
      %bb190_15 = "braid.ule"(%bb190_8, %bb190_14) : (i64, i64) -> i64
      %bb190_16 = "braid.const"() {value = 281474976710656 : i64} : () -> i64
      %bb190_17 = "braid.sub"(%bb190_16, %bb190_8) : (i64, i64) -> i64
      %bb190_18 = "braid.ule"(%bb190_7, %bb190_17) : (i64, i64) -> i64
      %bb190_19 = "braid.and"(%bb190_11, %bb190_13) : (i64, i64) -> i64
      %bb190_20 = "braid.and"(%bb190_19, %bb190_15) : (i64, i64) -> i64
      %bb190_21 = "braid.and"(%bb190_20, %bb190_18) : (i64, i64) -> i64
      %bb190_22 = "braid.or"(%bb190_2, %bb190_21) : (i64, i64) -> i64
      "braid.guard"(%bb190_22) : (i64) -> ()
      %bb190_23 = "braid.select"(%bb190_4, %bb190_8, %bb190_12) : (i64, i64, i64) -> i64
      "braid.out"(%bb190_7, %bb190_23) : (i64, i64) -> ()
      %bb190_24 = "braid.select"(%bb190_4, %bb190_8, %bb190_6) : (i64, i64, i64) -> i64
      "braid.set"(%bb190_24) {reg = "x0"} : (i64) -> ()
      "braid_cf.exit"(%bb190_2, %bb190_6)[^bb190, ^ext204cc] : (i64, i64) -> ()
    ^ext100bc:
      "braid_cf.tail"() {target = 65724 : i64} : () -> ()
  }) {sym_name = "main", entry = 131896 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
