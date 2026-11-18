"braid.module"() ({
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb0_6 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb0_0 = "braid.add"(%bb0_1, %bb0_6) : (i64, i64) -> i64
      %bb0_30 = "braid.load"(%bb0_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb0_30) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb4_6 = "braid.const"() {value = 53 : i64} : () -> i64
      %bb4_0 = "braid.add"(%bb4_1, %bb4_6) : (i64, i64) -> i64
      %bb4_30 = "braid.load"(%bb4_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb4_30) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb8_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8_2 = "braid.and"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb8_2)[^bbc, ^bb14] : (i64) -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.const"() {value = 65760 : i64} : () -> i64
      %bbc_1 = "braid.load"(%bbc_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbc_1) {reg = "x17"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x17"} : () -> i64
      "braid.br_ind"(%bb10_0) : (i64) -> ()
    ^bb14:  // 0x10014
      %bb14_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb14_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb14_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb14_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb14_5 = "braid.and"(%bb14_3, %bb14_4) : (i64, i64) -> i64
      %bb14_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_7 = "braid.eq"(%bb14_5, %bb14_6) : (i64, i64) -> i64
      "braid.guard"(%bb14_7) : (i64) -> ()
      %bb14_8 = "braid.const"() {value = -16 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_3, %bb14_8) : (i64, i64) -> i64
      "braid.set"(%bb14_2) {reg = "sp"} : (i64) -> ()
      %bb14_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb14_24 = "braid.add"(%bb14_2, %bb14_23) : (i64, i64) -> i64
      "braid.store"(%bb14_2, %bb14_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb14_24, %bb14_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10018
      %bb18_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb18_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_3 = "braid.add"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      "braid.set"(%bb18_3) {reg = "x29"} : (i64) -> ()
      "braid.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1001c
      %bb1c_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb1c_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1c_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1c_5 = "braid.and"(%bb1c_3, %bb1c_4) : (i64, i64) -> i64
      %bb1c_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_7 = "braid.eq"(%bb1c_5, %bb1c_6) : (i64, i64) -> i64
      "braid.guard"(%bb1c_7) : (i64) -> ()
      %bb1c_8 = "braid.const"() {value = -32 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_3, %bb1c_8) : (i64, i64) -> i64
      "braid.set"(%bb1c_2) {reg = "sp"} : (i64) -> ()
      %bb1c_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c_24 = "braid.add"(%bb1c_2, %bb1c_23) : (i64, i64) -> i64
      "braid.store"(%bb1c_2, %bb1c_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb1c_24, %bb1c_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10020
      %bb20_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb20_1 = "braid.get"() {reg = "x27"} : () -> i64
      %bb20_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb20_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb20_5 = "braid.and"(%bb20_3, %bb20_4) : (i64, i64) -> i64
      %bb20_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_7 = "braid.eq"(%bb20_5, %bb20_6) : (i64, i64) -> i64
      "braid.guard"(%bb20_7) : (i64) -> ()
      %bb20_8 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb20_2 = "braid.add"(%bb20_3, %bb20_8) : (i64, i64) -> i64
      %bb20_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb20_24 = "braid.add"(%bb20_2, %bb20_23) : (i64, i64) -> i64
      "braid.store"(%bb20_2, %bb20_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb20_24, %bb20_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10024
      %bb24_1 = "braid.get"() {reg = "x26"} : () -> i64
      %bb24_6 = "braid.const"() {value = -224 : i64} : () -> i64
      %bb24_0 = "braid.add"(%bb24_1, %bb24_6) : (i64, i64) -> i64
      %bb24_30 = "braid.load"(%bb24_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb24_30) {reg = "x2"} : (i64) -> ()
      "braid.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10028
      %bb28_0 = "braid.get"() {reg = "x27"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb28_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb28_3 = "braid.and"(%bb28_1, %bb28_2) : (i64, i64) -> i64
      %bb28_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_5 = "braid.eq"(%bb28_3, %bb28_4) : (i64, i64) -> i64
      "braid.guard"(%bb28_5) : (i64) -> ()
      "braid.store"(%bb28_1, %bb28_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x1002c
      %bb2c_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb2c_2 = "braid.get"() {reg = "x2"} : () -> i64
      %bb2c_12 = "braid.sub"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      %bb2c_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_13 = "braid.slt"(%bb2c_12, %bb2c_17) : (i64, i64) -> i64
      %bb2c_14 = "braid.eq"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      %bb2c_15 = "braid.ule"(%bb2c_2, %bb2c_0) : (i64, i64) -> i64
      %bb2c_18 = "braid.xor"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      %bb2c_19 = "braid.xor"(%bb2c_0, %bb2c_12) : (i64, i64) -> i64
      %bb2c_20 = "braid.and"(%bb2c_18, %bb2c_19) : (i64, i64) -> i64
      %bb2c_16 = "braid.slt"(%bb2c_20, %bb2c_17) : (i64, i64) -> i64
      "braid.setf"(%bb2c_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb2c_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb2c_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb2c_16) {flag = "v"} : (i64) -> ()
      "braid.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10030
      %bb30_1 = "braid.getf"() {flag = "c"} : () -> i64
      %bb30_2 = "braid.getf"() {flag = "z"} : () -> i64
      %bb30_0 = "braid.ule"(%bb30_1, %bb30_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb30_0)[^bb9c, ^bb34] : (i64) -> ()
    ^bb34:  // 0x10034
      %bb34_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb34_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb34_3 = "braid.and"(%bb34_1, %bb34_2) : (i64, i64) -> i64
      %bb34_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb34_5 = "braid.eq"(%bb34_3, %bb34_4) : (i64, i64) -> i64
      "braid.guard"(%bb34_5) : (i64) -> ()
      %bb34_6 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb34_0 = "braid.add"(%bb34_1, %bb34_6) : (i64, i64) -> i64
      %bb34_30 = "braid.load"(%bb34_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb34_30) {reg = "x2"} : (i64) -> ()
      "braid.br"()[^bb38] : () -> ()
    ^bb38:  // 0x10038
      %bb38_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb38_0 = "braid.zext"(%bb38_1) {bits = 32 : i64} : (i64) -> i64
      %bb38_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb38_3 = "braid.and"(%bb38_0, %bb38_2) : (i64, i64) -> i64
      %bb38_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb38_7 = "braid.sext"(%bb38_3) {bits = 32 : i64} : (i64) -> i64
      %bb38_5 = "braid.slt"(%bb38_7, %bb38_4) : (i64, i64) -> i64
      %bb38_6 = "braid.eq"(%bb38_3, %bb38_4) : (i64, i64) -> i64
      "braid.setf"(%bb38_5) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb38_6) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb38_4) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb38_4) {flag = "v"} : (i64) -> ()
      "braid.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x1003c
      %bb3c_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb3c_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3c_0 = "braid.eq"(%bb3c_1, %bb3c_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb3c_0)[^bb100, ^bb40] : (i64) -> ()
    ^bb40:  // 0x10040
      %bb40_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb40_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb40_3 = "braid.and"(%bb40_1, %bb40_2) : (i64, i64) -> i64
      %bb40_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb40_5 = "braid.eq"(%bb40_3, %bb40_4) : (i64, i64) -> i64
      "braid.guard"(%bb40_5) : (i64) -> ()
      %bb40_6 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb40_0 = "braid.add"(%bb40_1, %bb40_6) : (i64, i64) -> i64
      %bb40_30 = "braid.load"(%bb40_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb40_30) {reg = "x3"} : (i64) -> ()
      "braid.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10044
      %bb44_0 = "braid.get"() {reg = "x3"} : () -> i64
      %bb44_3 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb44_20 = "braid.ashr"(%bb44_0, %bb44_3) : (i64, i64) -> i64
      "braid.set"(%bb44_20) {reg = "x4"} : (i64) -> ()
      "braid.br"()[^bb48] : () -> ()
    ^bb48:  // 0x10048
      %bb48_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb48_3 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb48_20 = "braid.ashr"(%bb48_0, %bb48_3) : (i64, i64) -> i64
      "braid.set"(%bb48_20) {reg = "x5"} : (i64) -> ()
      "braid.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x1004c
      %bb4c_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb4c_0 = "braid.zext"(%bb4c_1) {bits = 32 : i64} : (i64) -> i64
      %bb4c_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4c_3 = "braid.and"(%bb4c_0, %bb4c_2) : (i64, i64) -> i64
      %bb4c_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4c_7 = "braid.sext"(%bb4c_3) {bits = 32 : i64} : (i64) -> i64
      %bb4c_5 = "braid.slt"(%bb4c_7, %bb4c_4) : (i64, i64) -> i64
      %bb4c_6 = "braid.eq"(%bb4c_3, %bb4c_4) : (i64, i64) -> i64
      "braid.setf"(%bb4c_5) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb4c_6) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb4c_4) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb4c_4) {flag = "v"} : (i64) -> ()
      "braid.br"()[^bb50] : () -> ()
    ^bb50:  // 0x10050
      %bb50_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb50_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb50_0 = "braid.eq"(%bb50_1, %bb50_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb50_0)[^bb104, ^bb54] : (i64) -> ()
    ^bb54:  // 0x10054
      %bb54_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb54_0 = "braid.zext"(%bb54_1) {bits = 32 : i64} : (i64) -> i64
      %bb54_3 = "braid.get"() {reg = "x4"} : () -> i64
      %bb54_2 = "braid.zext"(%bb54_3) {bits = 32 : i64} : (i64) -> i64
      %bb54_17 = "braid.add"(%bb54_0, %bb54_2) : (i64, i64) -> i64
      %bb54_12 = "braid.zext"(%bb54_17) {bits = 32 : i64} : (i64) -> i64
      %bb54_18 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb54_19 = "braid.sext"(%bb54_12) {bits = 32 : i64} : (i64) -> i64
      %bb54_13 = "braid.slt"(%bb54_19, %bb54_18) : (i64, i64) -> i64
      %bb54_14 = "braid.eq"(%bb54_12, %bb54_18) : (i64, i64) -> i64
      %bb54_15 = "braid.ne"(%bb54_12, %bb54_17) : (i64, i64) -> i64
      %bb54_20 = "braid.xor"(%bb54_0, %bb54_12) : (i64, i64) -> i64
      %bb54_21 = "braid.xor"(%bb54_2, %bb54_12) : (i64, i64) -> i64
      %bb54_22 = "braid.and"(%bb54_20, %bb54_21) : (i64, i64) -> i64
      %bb54_23 = "braid.sext"(%bb54_22) {bits = 32 : i64} : (i64) -> i64
      %bb54_16 = "braid.slt"(%bb54_23, %bb54_18) : (i64, i64) -> i64
      "braid.setf"(%bb54_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb54_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb54_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb54_16) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb54_12) {reg = "x4"} : (i64) -> ()
      "braid.br"()[^bb58] : () -> ()
    ^bb58:  // 0x10058
      %bb58_0 = "braid.getf"() {flag = "v"} : () -> i64
      "braid.cond_br"(%bb58_0)[^bb108, ^bb5c] : (i64) -> ()
    ^bb5c:  // 0x1005c
      %bb5c_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb5c_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb5c_3 = "braid.and"(%bb5c_1, %bb5c_2) : (i64, i64) -> i64
      %bb5c_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb5c_5 = "braid.eq"(%bb5c_3, %bb5c_4) : (i64, i64) -> i64
      "braid.guard"(%bb5c_5) : (i64) -> ()
      %bb5c_6 = "braid.const"() {value = 72 : i64} : () -> i64
      %bb5c_0 = "braid.add"(%bb5c_1, %bb5c_6) : (i64, i64) -> i64
      %bb5c_30 = "braid.load"(%bb5c_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb5c_30) {reg = "x5"} : (i64) -> ()
      "braid.br"()[^bb60] : () -> ()
    ^bb60:  // 0x10060
      %bb60_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb60_0 = "braid.zext"(%bb60_1) {bits = 32 : i64} : (i64) -> i64
      %bb60_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb60_3 = "braid.and"(%bb60_0, %bb60_2) : (i64, i64) -> i64
      %bb60_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb60_7 = "braid.sext"(%bb60_3) {bits = 32 : i64} : (i64) -> i64
      %bb60_5 = "braid.slt"(%bb60_7, %bb60_4) : (i64, i64) -> i64
      %bb60_6 = "braid.eq"(%bb60_3, %bb60_4) : (i64, i64) -> i64
      "braid.setf"(%bb60_5) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb60_6) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb60_4) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb60_4) {flag = "v"} : (i64) -> ()
      "braid.br"()[^bb64] : () -> ()
    ^bb64:  // 0x10064
      %bb64_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb64_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb64_0 = "braid.eq"(%bb64_1, %bb64_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb64_0)[^bb10c, ^bb68] : (i64) -> ()
    ^bb68:  // 0x10068
      %bb68_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb68_3 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb68_20 = "braid.ashr"(%bb68_0, %bb68_3) : (i64, i64) -> i64
      "braid.set"(%bb68_20) {reg = "x2"} : (i64) -> ()
      "braid.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x1006c
      %bb6c_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bb6c_0 = "braid.zext"(%bb6c_1) {bits = 32 : i64} : (i64) -> i64
      %bb6c_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bb6c_2 = "braid.zext"(%bb6c_3) {bits = 32 : i64} : (i64) -> i64
      %bb6c_13 = "braid.add"(%bb6c_0, %bb6c_2) : (i64, i64) -> i64
      %bb6c_12 = "braid.zext"(%bb6c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb6c_12) {reg = "x2"} : (i64) -> ()
      "braid.br"()[^bb70] : () -> ()
    ^bb70:  // 0x10070
      %bb70_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb70_3 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb70_20 = "braid.shl"(%bb70_0, %bb70_3) : (i64, i64) -> i64
      "braid.set"(%bb70_20) {reg = "x0"} : (i64) -> ()
      "braid.br"()[^bb74] : () -> ()
    ^bb74:  // 0x10074
      %bb74_1 = "braid.get"() {reg = "x29"} : () -> i64
      %bb74_6 = "braid.const"() {value = -24 : i64} : () -> i64
      %bb74_0 = "braid.add"(%bb74_1, %bb74_6) : (i64, i64) -> i64
      %bb74_30 = "braid.load"(%bb74_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb74_30) {reg = "x3"} : (i64) -> ()
      "braid.br"()[^bb78] : () -> ()
    ^bb78:  // 0x10078
      %bb78_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb78_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb78_3 = "braid.add"(%bb78_0, %bb78_2) : (i64, i64) -> i64
      "braid.set"(%bb78_3) {reg = "sp"} : (i64) -> ()
      "braid.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x1007c
      %bb7c_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb7c_1 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb7c_2 = "braid.and"(%bb7c_0, %bb7c_1) : (i64, i64) -> i64
      %bb7c_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7c_4 = "braid.eq"(%bb7c_2, %bb7c_3) : (i64, i64) -> i64
      "braid.guard"(%bb7c_4) : (i64) -> ()
      %bb7c_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb7c_6 = "braid.add"(%bb7c_0, %bb7c_5) : (i64, i64) -> i64
      "braid.set"(%bb7c_6) {reg = "sp"} : (i64) -> ()
      %bb7c_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb7c_22 = "braid.add"(%bb7c_0, %bb7c_21) : (i64, i64) -> i64
      %bb7c_23 = "braid.load"(%bb7c_0) {bytes = 8 : i64} : (i64) -> i64
      %bb7c_26 = "braid.load"(%bb7c_22) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb7c_23) {reg = "x29"} : (i64) -> ()
      "braid.set"(%bb7c_26) {reg = "x30"} : (i64) -> ()
      "braid.br"()[^bb80] : () -> ()
    ^bb80:  // 0x10080
      %bb80_0 = "braid.get"() {reg = "x3"} : () -> i64
      %bb80_2 = "braid.const"() {value = 4 : i64} : () -> i64
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
      "braid.br"()[^bb84] : () -> ()
    ^bb84:  // 0x10084
      %bb84_1 = "braid.getf"() {flag = "n"} : () -> i64
      %bb84_2 = "braid.getf"() {flag = "v"} : () -> i64
      %bb84_0 = "braid.eq"(%bb84_1, %bb84_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb84_0)[^bb8c, ^bb88] : (i64) -> ()
    ^bb88:  // 0x10088
      %bb88_0 = "braid.const"() {value = 4 : i64} : () -> i64
      "braid.set"(%bb88_0) {reg = "x3"} : (i64) -> ()
      "braid.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x1008c
      %bb8c_0 = "braid.get"() {reg = "x3"} : () -> i64
      %bb8c_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8c_3 = "braid.add"(%bb8c_0, %bb8c_2) : (i64, i64) -> i64
      "braid.set"(%bb8c_3) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bb90] : () -> ()
    ^bb90:  // 0x10090
      %bb90_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb90_2 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb90_3 = "braid.and"(%bb90_0, %bb90_2) : (i64, i64) -> i64
      "braid.set"(%bb90_3) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bb94] : () -> ()
    ^bb94:  // 0x10094
      %bb94_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb94_3 = "braid.get"() {reg = "x16"} : () -> i64
      %bb94_4 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb94_2 = "braid.shl"(%bb94_3, %bb94_4) : (i64, i64) -> i64
      %bb94_12 = "braid.add"(%bb94_0, %bb94_2) : (i64, i64) -> i64
      "braid.set"(%bb94_12) {reg = "sp"} : (i64) -> ()
      "braid.br"()[^bb98] : () -> ()
    ^bb98:  // 0x10098
      %bb98_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid.br_ind"(%bb98_0) : (i64) -> ()
    ^bb9c:  // 0x1009c
      %bb9c_0 = "braid.const"() {value = 137438953472 : i64} : () -> i64
      "braid.set"(%bb9c_0) {reg = "x2"} : (i64) -> ()
      "braid.br"()[^bba0] : () -> ()
    ^bba0:  // 0x100a0
      %bba0_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bba0_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bba0_3 = "braid.sub"(%bba0_0, %bba0_2) : (i64, i64) -> i64
      "braid.set"(%bba0_3) {reg = "sp"} : (i64) -> ()
      "braid.br"()[^bba4] : () -> ()
    ^bba4:  // 0x100a4
      %bba4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba4_2 = "braid.get"() {reg = "sp"} : () -> i64
      %bba4_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bba4_4 = "braid.and"(%bba4_2, %bba4_3) : (i64, i64) -> i64
      %bba4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba4_6 = "braid.eq"(%bba4_4, %bba4_5) : (i64, i64) -> i64
      "braid.guard"(%bba4_6) : (i64) -> ()
      %bba4_7 = "braid.const"() {value = 8 : i64} : () -> i64
      %bba4_1 = "braid.add"(%bba4_2, %bba4_7) : (i64, i64) -> i64
      "braid.store"(%bba4_1, %bba4_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bba8] : () -> ()
    ^bba8:  // 0x100a8
      %bba8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bba8_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bba8_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bba8_3 = "braid.and"(%bba8_1, %bba8_2) : (i64, i64) -> i64
      %bba8_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba8_5 = "braid.eq"(%bba8_3, %bba8_4) : (i64, i64) -> i64
      "braid.guard"(%bba8_5) : (i64) -> ()
      "braid.store"(%bba8_1, %bba8_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bbac] : () -> ()
    ^bbac:  // 0x100ac
      %bbac_0 = "braid.const"() {value = 6456 : i64} : () -> i64
      "braid.set"(%bbac_0) {reg = "x1"} : (i64) -> ()
      "braid.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x100b0
      %bbb0_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bbb0_2 = "braid.const"() {value = -4294901761 : i64} : () -> i64
      %bbb0_3 = "braid.and"(%bbb0_0, %bbb0_2) : (i64, i64) -> i64
      %bbb0_4 = "braid.const"() {value = 23265280 : i64} : () -> i64
      %bbb0_5 = "braid.or"(%bbb0_3, %bbb0_4) : (i64, i64) -> i64
      "braid.set"(%bbb0_5) {reg = "x1"} : (i64) -> ()
      "braid.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x100b4
      %bbb4_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bbb4_2 = "braid.const"() {value = -281470681743361 : i64} : () -> i64
      %bbb4_3 = "braid.and"(%bbb4_0, %bbb4_2) : (i64, i64) -> i64
      %bbb4_4 = "braid.const"() {value = 4294967296 : i64} : () -> i64
      %bbb4_5 = "braid.or"(%bbb4_3, %bbb4_4) : (i64, i64) -> i64
      "braid.set"(%bbb4_5) {reg = "x1"} : (i64) -> ()
      "braid.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x100b8
      %bbb8_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bbb8_0) {reg = "x0"} : (i64) -> ()
      "braid.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x100bc
      %bbbc_0 = "braid.const"() {value = 65752 : i64} : () -> i64
      %bbbc_1 = "braid.load"(%bbbc_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbbc_1) {reg = "x27"} : (i64) -> ()
      "braid.br"()[^bbc0] : () -> ()
    ^bbc0:  // 0x100c0
      %bbc0_0 = "braid.const"() {value = 65768 : i64} : () -> i64
      %bbc0_1 = "braid.load"(%bbc0_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbc0_1) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x100c4
      %bbc4_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bbc4_1 = "braid.const"() {value = 65736 : i64} : () -> i64
      "braid.set"(%bbc4_1) {reg = "x30"} : (i64) -> ()
      "braid.br_ind"(%bbc4_0) : (i64) -> ()
    ^bbc8:  // 0x100c8
      "braid.br"()[^bb34] : () -> ()
    ^bbcc:  // 0x100cc
      "braid.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x100d0
      %bbd0_0 = "braid.const"() {value = 65772 : i64} : () -> i64
      %bbd0_1 = "braid.load"(%bbd0_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x100d4
      %bbd4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd4_1 = "braid.const"() {value = 65752 : i64} : () -> i64
      "braid.set"(%bbd4_1) {reg = "x30"} : (i64) -> ()
      "braid.br_ind"(%bbd4_0) : (i64) -> ()
    ^bbd8:  // 0x100d8
      "braid.trap"() {reason = "ldrSimdLit"} : () -> ()
    ^bbdc:  // 0x100dc
      "braid.trap"() {reason = "udf"} : () -> ()
    ^bbe4:  // 0x100e4
      "braid.trap"() {reason = "udf"} : () -> ()
    ^bbec:  // 0x100ec
      "braid.trap"() {reason = "udf"} : () -> ()
    ^bbf0:  // 0x100f0
      %bbf0_1 = "braid.get"() {reg = "x26"} : () -> i64
      %bbf0_6 = "braid.const"() {value = -184 : i64} : () -> i64
      %bbf0_0 = "braid.add"(%bbf0_1, %bbf0_6) : (i64, i64) -> i64
      %bbf0_30 = "braid.load"(%bbf0_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbf0_30) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bbf4] : () -> ()
    ^bbf4:  // 0x100f4
      %bbf4_0 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.br_ind"(%bbf4_0) : (i64) -> ()
    ^bbf8:  // 0x100f8
      %bbf8_1 = "braid.get"() {reg = "x26"} : () -> i64
      %bbf8_6 = "braid.const"() {value = -176 : i64} : () -> i64
      %bbf8_0 = "braid.add"(%bbf8_1, %bbf8_6) : (i64, i64) -> i64
      %bbf8_30 = "braid.load"(%bbf8_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbf8_30) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bbfc] : () -> ()
    ^bbfc:  // 0x100fc
      %bbfc_0 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.br_ind"(%bbfc_0) : (i64) -> ()
    ^bb100:  // 0x10100
      %bb100_0 = "braid.const"() {value = 65796 : i64} : () -> i64
      "braid.set"(%bb100_0) {reg = "x30"} : (i64) -> ()
      "braid.br"()[^bbf0] : () -> ()
    ^bb104:  // 0x10104
      %bb104_0 = "braid.const"() {value = 65800 : i64} : () -> i64
      "braid.set"(%bb104_0) {reg = "x30"} : (i64) -> ()
      "braid.br"()[^bbf0] : () -> ()
    ^bb108:  // 0x10108
      %bb108_0 = "braid.const"() {value = 65804 : i64} : () -> i64
      "braid.set"(%bb108_0) {reg = "x30"} : (i64) -> ()
      "braid.br"()[^bbf0] : () -> ()
    ^bb10c:  // 0x1010c
      %bb10c_0 = "braid.const"() {value = 65808 : i64} : () -> i64
      "braid.set"(%bb10c_0) {reg = "x30"} : (i64) -> ()
      "braid.br"()[^bbf0] : () -> ()
    ^bb110:  // 0x10110
      %bb110_0 = "braid.const"() {value = 65812 : i64} : () -> i64
      "braid.set"(%bb110_0) {reg = "x30"} : (i64) -> ()
      "braid.br"()[^bbf8] : () -> ()
  }) {sym_name = "js_add3", entry = 65536 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10114
      %bb0_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb0_6 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb0_0 = "braid.add"(%bb0_1, %bb0_6) : (i64, i64) -> i64
      %bb0_30 = "braid.load"(%bb0_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb0_30) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10118
      %bb4_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb4_6 = "braid.const"() {value = 53 : i64} : () -> i64
      %bb4_0 = "braid.add"(%bb4_1, %bb4_6) : (i64, i64) -> i64
      %bb4_30 = "braid.load"(%bb4_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb4_30) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1011c
      %bb8_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb8_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8_2 = "braid.and"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb8_2)[^bbc, ^bb14] : (i64) -> ()
    ^bbc:  // 0x10120
      %bbc_0 = "braid.const"() {value = 66012 : i64} : () -> i64
      %bbc_1 = "braid.load"(%bbc_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbc_1) {reg = "x17"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10124
      %bb10_0 = "braid.get"() {reg = "x17"} : () -> i64
      "braid.br_ind"(%bb10_0) : (i64) -> ()
    ^bb14:  // 0x10128
      %bb14_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb14_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb14_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb14_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb14_5 = "braid.and"(%bb14_3, %bb14_4) : (i64, i64) -> i64
      %bb14_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_7 = "braid.eq"(%bb14_5, %bb14_6) : (i64, i64) -> i64
      "braid.guard"(%bb14_7) : (i64) -> ()
      %bb14_8 = "braid.const"() {value = -16 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_3, %bb14_8) : (i64, i64) -> i64
      "braid.set"(%bb14_2) {reg = "sp"} : (i64) -> ()
      %bb14_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb14_24 = "braid.add"(%bb14_2, %bb14_23) : (i64, i64) -> i64
      "braid.store"(%bb14_2, %bb14_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb14_24, %bb14_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb18] : () -> ()
    ^bb18:  // 0x1012c
      %bb18_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb18_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_3 = "braid.add"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      "braid.set"(%bb18_3) {reg = "x29"} : (i64) -> ()
      "braid.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10130
      %bb1c_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb1c_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1c_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1c_5 = "braid.and"(%bb1c_3, %bb1c_4) : (i64, i64) -> i64
      %bb1c_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_7 = "braid.eq"(%bb1c_5, %bb1c_6) : (i64, i64) -> i64
      "braid.guard"(%bb1c_7) : (i64) -> ()
      %bb1c_8 = "braid.const"() {value = -32 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_3, %bb1c_8) : (i64, i64) -> i64
      "braid.set"(%bb1c_2) {reg = "sp"} : (i64) -> ()
      %bb1c_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c_24 = "braid.add"(%bb1c_2, %bb1c_23) : (i64, i64) -> i64
      "braid.store"(%bb1c_2, %bb1c_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb1c_24, %bb1c_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10134
      %bb20_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb20_1 = "braid.get"() {reg = "x27"} : () -> i64
      %bb20_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb20_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb20_5 = "braid.and"(%bb20_3, %bb20_4) : (i64, i64) -> i64
      %bb20_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_7 = "braid.eq"(%bb20_5, %bb20_6) : (i64, i64) -> i64
      "braid.guard"(%bb20_7) : (i64) -> ()
      %bb20_8 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb20_2 = "braid.add"(%bb20_3, %bb20_8) : (i64, i64) -> i64
      %bb20_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb20_24 = "braid.add"(%bb20_2, %bb20_23) : (i64, i64) -> i64
      "braid.store"(%bb20_2, %bb20_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb20_24, %bb20_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10138
      %bb24_1 = "braid.get"() {reg = "x26"} : () -> i64
      %bb24_6 = "braid.const"() {value = -224 : i64} : () -> i64
      %bb24_0 = "braid.add"(%bb24_1, %bb24_6) : (i64, i64) -> i64
      %bb24_30 = "braid.load"(%bb24_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb24_30) {reg = "x2"} : (i64) -> ()
      "braid.br"()[^bb28] : () -> ()
    ^bb28:  // 0x1013c
      %bb28_0 = "braid.get"() {reg = "x27"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb28_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb28_3 = "braid.and"(%bb28_1, %bb28_2) : (i64, i64) -> i64
      %bb28_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_5 = "braid.eq"(%bb28_3, %bb28_4) : (i64, i64) -> i64
      "braid.guard"(%bb28_5) : (i64) -> ()
      "braid.store"(%bb28_1, %bb28_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x10140
      %bb2c_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb2c_2 = "braid.get"() {reg = "x2"} : () -> i64
      %bb2c_12 = "braid.sub"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      %bb2c_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_13 = "braid.slt"(%bb2c_12, %bb2c_17) : (i64, i64) -> i64
      %bb2c_14 = "braid.eq"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      %bb2c_15 = "braid.ule"(%bb2c_2, %bb2c_0) : (i64, i64) -> i64
      %bb2c_18 = "braid.xor"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      %bb2c_19 = "braid.xor"(%bb2c_0, %bb2c_12) : (i64, i64) -> i64
      %bb2c_20 = "braid.and"(%bb2c_18, %bb2c_19) : (i64, i64) -> i64
      %bb2c_16 = "braid.slt"(%bb2c_20, %bb2c_17) : (i64, i64) -> i64
      "braid.setf"(%bb2c_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb2c_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb2c_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb2c_16) {flag = "v"} : (i64) -> ()
      "braid.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10144
      %bb30_1 = "braid.getf"() {flag = "c"} : () -> i64
      %bb30_2 = "braid.getf"() {flag = "z"} : () -> i64
      %bb30_0 = "braid.ule"(%bb30_1, %bb30_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb30_0)[^bb84, ^bb34] : (i64) -> ()
    ^bb34:  // 0x10148
      %bb34_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb34_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb34_3 = "braid.and"(%bb34_1, %bb34_2) : (i64, i64) -> i64
      %bb34_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb34_5 = "braid.eq"(%bb34_3, %bb34_4) : (i64, i64) -> i64
      "braid.guard"(%bb34_5) : (i64) -> ()
      %bb34_6 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb34_0 = "braid.add"(%bb34_1, %bb34_6) : (i64, i64) -> i64
      %bb34_30 = "braid.load"(%bb34_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb34_30) {reg = "x0"} : (i64) -> ()
      "braid.br"()[^bb38] : () -> ()
    ^bb38:  // 0x1014c
      %bb38_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb38_0 = "braid.zext"(%bb38_1) {bits = 32 : i64} : (i64) -> i64
      %bb38_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb38_3 = "braid.and"(%bb38_0, %bb38_2) : (i64, i64) -> i64
      %bb38_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb38_7 = "braid.sext"(%bb38_3) {bits = 32 : i64} : (i64) -> i64
      %bb38_5 = "braid.slt"(%bb38_7, %bb38_4) : (i64, i64) -> i64
      %bb38_6 = "braid.eq"(%bb38_3, %bb38_4) : (i64, i64) -> i64
      "braid.setf"(%bb38_5) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb38_6) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb38_4) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb38_4) {flag = "v"} : (i64) -> ()
      "braid.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x10150
      %bb3c_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb3c_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3c_0 = "braid.eq"(%bb3c_1, %bb3c_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb3c_0)[^bbe8, ^bb40] : (i64) -> ()
    ^bb40:  // 0x10154
      %bb40_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb40_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb40_3 = "braid.and"(%bb40_1, %bb40_2) : (i64, i64) -> i64
      %bb40_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb40_5 = "braid.eq"(%bb40_3, %bb40_4) : (i64, i64) -> i64
      "braid.guard"(%bb40_5) : (i64) -> ()
      %bb40_6 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb40_0 = "braid.add"(%bb40_1, %bb40_6) : (i64, i64) -> i64
      %bb40_30 = "braid.load"(%bb40_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb40_30) {reg = "x2"} : (i64) -> ()
      "braid.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10158
      %bb44_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb44_0 = "braid.zext"(%bb44_1) {bits = 32 : i64} : (i64) -> i64
      %bb44_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb44_3 = "braid.and"(%bb44_0, %bb44_2) : (i64, i64) -> i64
      %bb44_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb44_7 = "braid.sext"(%bb44_3) {bits = 32 : i64} : (i64) -> i64
      %bb44_5 = "braid.slt"(%bb44_7, %bb44_4) : (i64, i64) -> i64
      %bb44_6 = "braid.eq"(%bb44_3, %bb44_4) : (i64, i64) -> i64
      "braid.setf"(%bb44_5) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb44_6) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb44_4) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb44_4) {flag = "v"} : (i64) -> ()
      "braid.br"()[^bb48] : () -> ()
    ^bb48:  // 0x1015c
      %bb48_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb48_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb48_0 = "braid.eq"(%bb48_1, %bb48_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb48_0)[^bbec, ^bb4c] : (i64) -> ()
    ^bb4c:  // 0x10160
      %bb4c_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4c_2 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4c_12 = "braid.sub"(%bb4c_0, %bb4c_2) : (i64, i64) -> i64
      %bb4c_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4c_13 = "braid.slt"(%bb4c_12, %bb4c_17) : (i64, i64) -> i64
      %bb4c_14 = "braid.eq"(%bb4c_0, %bb4c_2) : (i64, i64) -> i64
      %bb4c_15 = "braid.ule"(%bb4c_2, %bb4c_0) : (i64, i64) -> i64
      %bb4c_18 = "braid.xor"(%bb4c_0, %bb4c_2) : (i64, i64) -> i64
      %bb4c_19 = "braid.xor"(%bb4c_0, %bb4c_12) : (i64, i64) -> i64
      %bb4c_20 = "braid.and"(%bb4c_18, %bb4c_19) : (i64, i64) -> i64
      %bb4c_16 = "braid.slt"(%bb4c_20, %bb4c_17) : (i64, i64) -> i64
      "braid.setf"(%bb4c_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb4c_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb4c_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb4c_16) {flag = "v"} : (i64) -> ()
      "braid.br"()[^bb50] : () -> ()
    ^bb50:  // 0x10164
      %bb50_1 = "braid.getf"() {flag = "n"} : () -> i64
      %bb50_2 = "braid.getf"() {flag = "v"} : () -> i64
      %bb50_0 = "braid.ne"(%bb50_1, %bb50_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb50_0)[^bb7c, ^bb54] : (i64) -> ()
    ^bb54:  // 0x10168
      %bb54_1 = "braid.get"() {reg = "x29"} : () -> i64
      %bb54_6 = "braid.const"() {value = -24 : i64} : () -> i64
      %bb54_0 = "braid.add"(%bb54_1, %bb54_6) : (i64, i64) -> i64
      %bb54_30 = "braid.load"(%bb54_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb54_30) {reg = "x3"} : (i64) -> ()
      "braid.br"()[^bb58] : () -> ()
    ^bb58:  // 0x1016c
      %bb58_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb58_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb58_3 = "braid.add"(%bb58_0, %bb58_2) : (i64, i64) -> i64
      "braid.set"(%bb58_3) {reg = "sp"} : (i64) -> ()
      "braid.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x10170
      %bb5c_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb5c_1 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb5c_2 = "braid.and"(%bb5c_0, %bb5c_1) : (i64, i64) -> i64
      %bb5c_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb5c_4 = "braid.eq"(%bb5c_2, %bb5c_3) : (i64, i64) -> i64
      "braid.guard"(%bb5c_4) : (i64) -> ()
      %bb5c_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb5c_6 = "braid.add"(%bb5c_0, %bb5c_5) : (i64, i64) -> i64
      "braid.set"(%bb5c_6) {reg = "sp"} : (i64) -> ()
      %bb5c_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb5c_22 = "braid.add"(%bb5c_0, %bb5c_21) : (i64, i64) -> i64
      %bb5c_23 = "braid.load"(%bb5c_0) {bytes = 8 : i64} : (i64) -> i64
      %bb5c_26 = "braid.load"(%bb5c_22) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb5c_23) {reg = "x29"} : (i64) -> ()
      "braid.set"(%bb5c_26) {reg = "x30"} : (i64) -> ()
      "braid.br"()[^bb60] : () -> ()
    ^bb60:  // 0x10174
      %bb60_0 = "braid.get"() {reg = "x3"} : () -> i64
      %bb60_2 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb60_3 = "braid.sub"(%bb60_0, %bb60_2) : (i64, i64) -> i64
      %bb60_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb60_4 = "braid.slt"(%bb60_3, %bb60_8) : (i64, i64) -> i64
      %bb60_5 = "braid.eq"(%bb60_0, %bb60_2) : (i64, i64) -> i64
      %bb60_6 = "braid.ule"(%bb60_2, %bb60_0) : (i64, i64) -> i64
      %bb60_9 = "braid.xor"(%bb60_0, %bb60_2) : (i64, i64) -> i64
      %bb60_10 = "braid.xor"(%bb60_0, %bb60_3) : (i64, i64) -> i64
      %bb60_11 = "braid.and"(%bb60_9, %bb60_10) : (i64, i64) -> i64
      %bb60_7 = "braid.slt"(%bb60_11, %bb60_8) : (i64, i64) -> i64
      "braid.setf"(%bb60_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb60_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb60_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb60_7) {flag = "v"} : (i64) -> ()
      "braid.br"()[^bb64] : () -> ()
    ^bb64:  // 0x10178
      %bb64_1 = "braid.getf"() {flag = "n"} : () -> i64
      %bb64_2 = "braid.getf"() {flag = "v"} : () -> i64
      %bb64_0 = "braid.eq"(%bb64_1, %bb64_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb64_0)[^bb6c, ^bb68] : (i64) -> ()
    ^bb68:  // 0x1017c
      %bb68_0 = "braid.const"() {value = 3 : i64} : () -> i64
      "braid.set"(%bb68_0) {reg = "x3"} : (i64) -> ()
      "braid.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x10180
      %bb6c_0 = "braid.get"() {reg = "x3"} : () -> i64
      %bb6c_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6c_3 = "braid.add"(%bb6c_0, %bb6c_2) : (i64, i64) -> i64
      "braid.set"(%bb6c_3) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bb70] : () -> ()
    ^bb70:  // 0x10184
      %bb70_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb70_2 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb70_3 = "braid.and"(%bb70_0, %bb70_2) : (i64, i64) -> i64
      "braid.set"(%bb70_3) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bb74] : () -> ()
    ^bb74:  // 0x10188
      %bb74_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb74_3 = "braid.get"() {reg = "x16"} : () -> i64
      %bb74_4 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb74_2 = "braid.shl"(%bb74_3, %bb74_4) : (i64, i64) -> i64
      %bb74_12 = "braid.add"(%bb74_0, %bb74_2) : (i64, i64) -> i64
      "braid.set"(%bb74_12) {reg = "sp"} : (i64) -> ()
      "braid.br"()[^bb78] : () -> ()
    ^bb78:  // 0x1018c
      %bb78_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid.br_ind"(%bb78_0) : (i64) -> ()
    ^bb7c:  // 0x10190
      %bb7c_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7c_2 = "braid.get"() {reg = "x2"} : () -> i64
      %bb7c_12 = "braid.or"(%bb7c_0, %bb7c_2) : (i64, i64) -> i64
      "braid.set"(%bb7c_12) {reg = "x0"} : (i64) -> ()
      "braid.br"()[^bb80] : () -> ()
    ^bb80:  // 0x10194
      "braid.br"()[^bb54] : () -> ()
    ^bb84:  // 0x10198
      %bb84_0 = "braid.const"() {value = 171798691840 : i64} : () -> i64
      "braid.set"(%bb84_0) {reg = "x2"} : (i64) -> ()
      "braid.br"()[^bb88] : () -> ()
    ^bb88:  // 0x1019c
      %bb88_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb88_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb88_3 = "braid.sub"(%bb88_0, %bb88_2) : (i64, i64) -> i64
      "braid.set"(%bb88_3) {reg = "sp"} : (i64) -> ()
      "braid.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x101a0
      %bb8c_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8c_2 = "braid.get"() {reg = "sp"} : () -> i64
      %bb8c_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb8c_4 = "braid.and"(%bb8c_2, %bb8c_3) : (i64, i64) -> i64
      %bb8c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8c_6 = "braid.eq"(%bb8c_4, %bb8c_5) : (i64, i64) -> i64
      "braid.guard"(%bb8c_6) : (i64) -> ()
      %bb8c_7 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8c_1 = "braid.add"(%bb8c_2, %bb8c_7) : (i64, i64) -> i64
      "braid.store"(%bb8c_1, %bb8c_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb90] : () -> ()
    ^bb90:  // 0x101a4
      %bb90_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb90_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb90_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb90_3 = "braid.and"(%bb90_1, %bb90_2) : (i64, i64) -> i64
      %bb90_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb90_5 = "braid.eq"(%bb90_3, %bb90_4) : (i64, i64) -> i64
      "braid.guard"(%bb90_5) : (i64) -> ()
      "braid.store"(%bb90_1, %bb90_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb94] : () -> ()
    ^bb94:  // 0x101a8
      %bb94_0 = "braid.const"() {value = 55608 : i64} : () -> i64
      "braid.set"(%bb94_0) {reg = "x1"} : (i64) -> ()
      "braid.br"()[^bb98] : () -> ()
    ^bb98:  // 0x101ac
      %bb98_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb98_2 = "braid.const"() {value = -4294901761 : i64} : () -> i64
      %bb98_3 = "braid.and"(%bb98_0, %bb98_2) : (i64, i64) -> i64
      %bb98_4 = "braid.const"() {value = 77725696 : i64} : () -> i64
      %bb98_5 = "braid.or"(%bb98_3, %bb98_4) : (i64, i64) -> i64
      "braid.set"(%bb98_5) {reg = "x1"} : (i64) -> ()
      "braid.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x101b0
      %bb9c_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb9c_2 = "braid.const"() {value = -281470681743361 : i64} : () -> i64
      %bb9c_3 = "braid.and"(%bb9c_0, %bb9c_2) : (i64, i64) -> i64
      %bb9c_4 = "braid.const"() {value = 4294967296 : i64} : () -> i64
      %bb9c_5 = "braid.or"(%bb9c_3, %bb9c_4) : (i64, i64) -> i64
      "braid.set"(%bb9c_5) {reg = "x1"} : (i64) -> ()
      "braid.br"()[^bba0] : () -> ()
    ^bba0:  // 0x101b4
      %bba0_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bba0_0) {reg = "x0"} : (i64) -> ()
      "braid.br"()[^bba4] : () -> ()
    ^bba4:  // 0x101b8
      %bba4_0 = "braid.const"() {value = 66004 : i64} : () -> i64
      %bba4_1 = "braid.load"(%bba4_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bba4_1) {reg = "x27"} : (i64) -> ()
      "braid.br"()[^bba8] : () -> ()
    ^bba8:  // 0x101bc
      %bba8_0 = "braid.const"() {value = 66020 : i64} : () -> i64
      %bba8_1 = "braid.load"(%bba8_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bba8_1) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bbac] : () -> ()
    ^bbac:  // 0x101c0
      %bbac_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bbac_1 = "braid.const"() {value = 65988 : i64} : () -> i64
      "braid.set"(%bbac_1) {reg = "x30"} : (i64) -> ()
      "braid.br_ind"(%bbac_0) : (i64) -> ()
    ^bbb0:  // 0x101c4
      "braid.br"()[^bb34] : () -> ()
    ^bbb4:  // 0x101c8
      "braid.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x101cc
      %bbb8_0 = "braid.const"() {value = 66024 : i64} : () -> i64
      %bbb8_1 = "braid.load"(%bbb8_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x101d0
      %bbbc_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbbc_1 = "braid.const"() {value = 66004 : i64} : () -> i64
      "braid.set"(%bbbc_1) {reg = "x30"} : (i64) -> ()
      "braid.br_ind"(%bbbc_0) : (i64) -> ()
    ^bbc4:  // 0x101d8
      "braid.trap"() {reason = "udf"} : () -> ()
    ^bbcc:  // 0x101e0
      "braid.trap"() {reason = "udf"} : () -> ()
    ^bbd4:  // 0x101e8
      "braid.trap"() {reason = "udf"} : () -> ()
    ^bbd8:  // 0x101ec
      %bbd8_1 = "braid.get"() {reg = "x26"} : () -> i64
      %bbd8_6 = "braid.const"() {value = -184 : i64} : () -> i64
      %bbd8_0 = "braid.add"(%bbd8_1, %bbd8_6) : (i64, i64) -> i64
      %bbd8_30 = "braid.load"(%bbd8_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbd8_30) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x101f0
      %bbdc_0 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.br_ind"(%bbdc_0) : (i64) -> ()
    ^bbe0:  // 0x101f4
      %bbe0_1 = "braid.get"() {reg = "x26"} : () -> i64
      %bbe0_6 = "braid.const"() {value = -176 : i64} : () -> i64
      %bbe0_0 = "braid.add"(%bbe0_1, %bbe0_6) : (i64, i64) -> i64
      %bbe0_30 = "braid.load"(%bbe0_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbe0_30) {reg = "x16"} : (i64) -> ()
      "braid.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x101f8
      %bbe4_0 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.br_ind"(%bbe4_0) : (i64) -> ()
    ^bbe8:  // 0x101fc
      %bbe8_0 = "braid.const"() {value = 66048 : i64} : () -> i64
      "braid.set"(%bbe8_0) {reg = "x30"} : (i64) -> ()
      "braid.br"()[^bbd8] : () -> ()
    ^bbec:  // 0x10200
      %bbec_0 = "braid.const"() {value = 66052 : i64} : () -> i64
      "braid.set"(%bbec_0) {reg = "x30"} : (i64) -> ()
      "braid.br"()[^bbd8] : () -> ()
    ^bbf0:  // 0x10204
      %bbf0_0 = "braid.const"() {value = 66056 : i64} : () -> i64
      "braid.set"(%bbf0_0) {reg = "x30"} : (i64) -> ()
      "braid.br"()[^bbe0] : () -> ()
  }) {sym_name = "js_max", entry = 65812 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
