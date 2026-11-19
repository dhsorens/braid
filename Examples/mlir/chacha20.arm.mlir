"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb0_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb0_22 = "braid.add"(%bb0_0, %bb0_21) : (i64, i64) -> i64
      %bb0_23 = "braid.load"(%bb0_0) {bytes = 4 : i64} : (i64) -> i64
      %bb0_26 = "braid.load"(%bb0_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb0_23) {reg = "x8"} : (i64) -> ()
      "braid.set"(%bb0_26) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_6 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb4_0 = "braid.add"(%bb4_1, %bb4_6) : (i64, i64) -> i64
      %bb4_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb4_22 = "braid.add"(%bb4_0, %bb4_21) : (i64, i64) -> i64
      %bb4_23 = "braid.load"(%bb4_0) {bytes = 4 : i64} : (i64) -> i64
      %bb4_26 = "braid.load"(%bb4_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb4_23) {reg = "x11"} : (i64) -> ()
      "braid.set"(%bb4_26) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb8_0 = "braid.zext"(%bb8_1) {bits = 32 : i64} : (i64) -> i64
      %bb8_3 = "braid.get"() {reg = "x8"} : () -> i64
      %bb8_2 = "braid.zext"(%bb8_3) {bits = 32 : i64} : (i64) -> i64
      %bb8_13 = "braid.add"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      %bb8_12 = "braid.zext"(%bb8_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb8_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bbc_0 = "braid.zext"(%bbc_1) {bits = 32 : i64} : (i64) -> i64
      %bbc_3 = "braid.get"() {reg = "x8"} : () -> i64
      %bbc_2 = "braid.zext"(%bbc_3) {bits = 32 : i64} : (i64) -> i64
      %bbc_12 = "braid.xor"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      "braid.set"(%bbc_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb10_2 = "braid.zext"(%bb10_1) {bits = 32 : i64} : (i64) -> i64
      %bb10_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb10_4 = "braid.lshr"(%bb10_2, %bb10_3) : (i64, i64) -> i64
      %bb10_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb10_6 = "braid.shl"(%bb10_0, %bb10_5) : (i64, i64) -> i64
      %bb10_7 = "braid.or"(%bb10_4, %bb10_6) : (i64, i64) -> i64
      %bb10_9 = "braid.zext"(%bb10_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb10_9) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10014
      %bb14_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb14_0 = "braid.zext"(%bb14_1) {bits = 32 : i64} : (i64) -> i64
      %bb14_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb14_2 = "braid.zext"(%bb14_3) {bits = 32 : i64} : (i64) -> i64
      %bb14_13 = "braid.add"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      %bb14_12 = "braid.zext"(%bb14_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb14_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10018
      %bb18_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb18_0 = "braid.zext"(%bb18_1) {bits = 32 : i64} : (i64) -> i64
      %bb18_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb18_2 = "braid.zext"(%bb18_3) {bits = 32 : i64} : (i64) -> i64
      %bb18_12 = "braid.xor"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      "braid.set"(%bb18_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1001c
      %bb1c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1c_2 = "braid.zext"(%bb1c_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb1c_4 = "braid.lshr"(%bb1c_2, %bb1c_3) : (i64, i64) -> i64
      %bb1c_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb1c_6 = "braid.shl"(%bb1c_0, %bb1c_5) : (i64, i64) -> i64
      %bb1c_7 = "braid.or"(%bb1c_4, %bb1c_6) : (i64, i64) -> i64
      %bb1c_9 = "braid.zext"(%bb1c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1c_9) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10020
      %bb20_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb20_0 = "braid.zext"(%bb20_1) {bits = 32 : i64} : (i64) -> i64
      %bb20_3 = "braid.get"() {reg = "x8"} : () -> i64
      %bb20_2 = "braid.zext"(%bb20_3) {bits = 32 : i64} : (i64) -> i64
      %bb20_13 = "braid.add"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      %bb20_12 = "braid.zext"(%bb20_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb20_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10024
      %bb24_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb24_0 = "braid.zext"(%bb24_1) {bits = 32 : i64} : (i64) -> i64
      %bb24_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb24_2 = "braid.zext"(%bb24_3) {bits = 32 : i64} : (i64) -> i64
      %bb24_12 = "braid.xor"(%bb24_0, %bb24_2) : (i64, i64) -> i64
      "braid.set"(%bb24_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10028
      %bb28_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb28_2 = "braid.zext"(%bb28_1) {bits = 32 : i64} : (i64) -> i64
      %bb28_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb28_4 = "braid.lshr"(%bb28_2, %bb28_3) : (i64, i64) -> i64
      %bb28_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb28_6 = "braid.shl"(%bb28_0, %bb28_5) : (i64, i64) -> i64
      %bb28_7 = "braid.or"(%bb28_4, %bb28_6) : (i64, i64) -> i64
      %bb28_9 = "braid.zext"(%bb28_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb28_9) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x1002c
      %bb2c_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb2c_0 = "braid.zext"(%bb2c_1) {bits = 32 : i64} : (i64) -> i64
      %bb2c_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb2c_2 = "braid.zext"(%bb2c_3) {bits = 32 : i64} : (i64) -> i64
      %bb2c_13 = "braid.add"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      %bb2c_12 = "braid.zext"(%bb2c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2c_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10030
      %bb30_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb30_0 = "braid.zext"(%bb30_1) {bits = 32 : i64} : (i64) -> i64
      %bb30_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb30_2 = "braid.zext"(%bb30_3) {bits = 32 : i64} : (i64) -> i64
      %bb30_12 = "braid.xor"(%bb30_0, %bb30_2) : (i64, i64) -> i64
      "braid.set"(%bb30_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10034
      %bb34_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb34_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb34_3 = "braid.get"() {reg = "x0"} : () -> i64
      %bb34_8 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb34_2 = "braid.add"(%bb34_3, %bb34_8) : (i64, i64) -> i64
      %bb34_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb34_24 = "braid.add"(%bb34_2, %bb34_23) : (i64, i64) -> i64
      "braid.store"(%bb34_2, %bb34_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb34_24, %bb34_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x10038
      %bb38_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb38_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb38_2 = "braid.zext"(%bb38_1) {bits = 32 : i64} : (i64) -> i64
      %bb38_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb38_4 = "braid.lshr"(%bb38_2, %bb38_3) : (i64, i64) -> i64
      %bb38_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb38_6 = "braid.shl"(%bb38_0, %bb38_5) : (i64, i64) -> i64
      %bb38_7 = "braid.or"(%bb38_4, %bb38_6) : (i64, i64) -> i64
      %bb38_9 = "braid.zext"(%bb38_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb38_9) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x1003c
      %bb3c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb3c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb3c_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb3c_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb3c_24 = "braid.add"(%bb3c_2, %bb3c_23) : (i64, i64) -> i64
      "braid.store"(%bb3c_2, %bb3c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb3c_24, %bb3c_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x10040
      %bb40_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb40_0) : (i64) -> ()
  }) {sym_name = "quarter_round", entry = 65536 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10044
      %bb0_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb0_2 = "braid.const"() {value = 96 : i64} : () -> i64
      %bb0_3 = "braid.sub"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_3) {reg = "sp"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10048
      %bb4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_12 = "braid.or"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1004c
      %bb8_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb8_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_3 = "braid.add"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10050
      %bbc_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bbc_1 = "braid.get"() {reg = "x21"} : () -> i64
      %bbc_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bbc_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bbc_5 = "braid.and"(%bbc_3, %bbc_4) : (i64, i64) -> i64
      %bbc_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_7 = "braid.eq"(%bbc_5, %bbc_6) : (i64, i64) -> i64
      "braid.guard"(%bbc_7) : (i64) -> ()
      %bbc_8 = "braid.const"() {value = 64 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_3, %bbc_8) : (i64, i64) -> i64
      %bbc_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbc_24 = "braid.add"(%bbc_2, %bbc_23) : (i64, i64) -> i64
      "braid.store"(%bbc_2, %bbc_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bbc_24, %bbc_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10054
      %bb10_0 = "braid.get"() {reg = "x20"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb10_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb10_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb10_5 = "braid.and"(%bb10_3, %bb10_4) : (i64, i64) -> i64
      %bb10_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_7 = "braid.eq"(%bb10_5, %bb10_6) : (i64, i64) -> i64
      "braid.guard"(%bb10_7) : (i64) -> ()
      %bb10_8 = "braid.const"() {value = 80 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_3, %bb10_8) : (i64, i64) -> i64
      %bb10_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb10_24 = "braid.add"(%bb10_2, %bb10_23) : (i64, i64) -> i64
      "braid.store"(%bb10_2, %bb10_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb10_24, %bb10_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10058
      %bb14_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb14_6 = "braid.get"() {reg = "x8"} : () -> i64
      %bb14_0 = "braid.add"(%bb14_1, %bb14_6) : (i64, i64) -> i64
      %bb14_30 = "braid.load"(%bb14_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb14_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x1005c
      %bb18_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb18_2 = "braid.get"() {reg = "x9"} : () -> i64
      %bb18_7 = "braid.get"() {reg = "x8"} : () -> i64
      %bb18_1 = "braid.add"(%bb18_2, %bb18_7) : (i64, i64) -> i64
      "braid.store"(%bb18_1, %bb18_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10060
      %bb1c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1c_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1c_3 = "braid.add"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      "braid.set"(%bb1c_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10064
      %bb20_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb20_2 = "braid.const"() {value = 64 : i64} : () -> i64
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
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10068
      %bb24_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb24_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_0 = "braid.eq"(%bb24_1, %bb24_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb24_0)[^bb14, ^bb28] : (i64) -> ()
    ^bb28:  // 0x1006c
      %bb28_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb28_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb28_3 = "braid.and"(%bb28_1, %bb28_2) : (i64, i64) -> i64
      %bb28_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_5 = "braid.eq"(%bb28_3, %bb28_4) : (i64, i64) -> i64
      "braid.guard"(%bb28_5) : (i64) -> ()
      %bb28_6 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb28_0 = "braid.add"(%bb28_1, %bb28_6) : (i64, i64) -> i64
      %bb28_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb28_22 = "braid.add"(%bb28_0, %bb28_21) : (i64, i64) -> i64
      %bb28_23 = "braid.load"(%bb28_0) {bytes = 4 : i64} : (i64) -> i64
      %bb28_26 = "braid.load"(%bb28_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb28_23) {reg = "x13"} : (i64) -> ()
      "braid.set"(%bb28_26) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x10070
      %bb2c_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb2c_1 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb2c_2 = "braid.and"(%bb2c_0, %bb2c_1) : (i64, i64) -> i64
      %bb2c_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_4 = "braid.eq"(%bb2c_2, %bb2c_3) : (i64, i64) -> i64
      "braid.guard"(%bb2c_4) : (i64) -> ()
      %bb2c_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb2c_22 = "braid.add"(%bb2c_0, %bb2c_21) : (i64, i64) -> i64
      %bb2c_23 = "braid.load"(%bb2c_0) {bytes = 4 : i64} : (i64) -> i64
      %bb2c_26 = "braid.load"(%bb2c_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb2c_23) {reg = "x7"} : (i64) -> ()
      "braid.set"(%bb2c_26) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10074
      %bb30_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb30_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb30_3 = "braid.and"(%bb30_1, %bb30_2) : (i64, i64) -> i64
      %bb30_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb30_5 = "braid.eq"(%bb30_3, %bb30_4) : (i64, i64) -> i64
      "braid.guard"(%bb30_5) : (i64) -> ()
      %bb30_6 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb30_0 = "braid.add"(%bb30_1, %bb30_6) : (i64, i64) -> i64
      %bb30_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb30_22 = "braid.add"(%bb30_0, %bb30_21) : (i64, i64) -> i64
      %bb30_23 = "braid.load"(%bb30_0) {bytes = 4 : i64} : (i64) -> i64
      %bb30_26 = "braid.load"(%bb30_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb30_23) {reg = "x14"} : (i64) -> ()
      "braid.set"(%bb30_26) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10078
      %bb34_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb34_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb34_3 = "braid.and"(%bb34_1, %bb34_2) : (i64, i64) -> i64
      %bb34_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb34_5 = "braid.eq"(%bb34_3, %bb34_4) : (i64, i64) -> i64
      "braid.guard"(%bb34_5) : (i64) -> ()
      %bb34_6 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb34_0 = "braid.add"(%bb34_1, %bb34_6) : (i64, i64) -> i64
      %bb34_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb34_22 = "braid.add"(%bb34_0, %bb34_21) : (i64, i64) -> i64
      %bb34_23 = "braid.load"(%bb34_0) {bytes = 4 : i64} : (i64) -> i64
      %bb34_26 = "braid.load"(%bb34_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb34_23) {reg = "x9"} : (i64) -> ()
      "braid.set"(%bb34_26) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x1007c
      %bb38_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb38_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb38_3 = "braid.and"(%bb38_1, %bb38_2) : (i64, i64) -> i64
      %bb38_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb38_5 = "braid.eq"(%bb38_3, %bb38_4) : (i64, i64) -> i64
      "braid.guard"(%bb38_5) : (i64) -> ()
      %bb38_6 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb38_0 = "braid.add"(%bb38_1, %bb38_6) : (i64, i64) -> i64
      %bb38_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb38_22 = "braid.add"(%bb38_0, %bb38_21) : (i64, i64) -> i64
      %bb38_23 = "braid.load"(%bb38_0) {bytes = 4 : i64} : (i64) -> i64
      %bb38_26 = "braid.load"(%bb38_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb38_23) {reg = "x11"} : (i64) -> ()
      "braid.set"(%bb38_26) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x10080
      %bb3c_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb3c_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb3c_3 = "braid.and"(%bb3c_1, %bb3c_2) : (i64, i64) -> i64
      %bb3c_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3c_5 = "braid.eq"(%bb3c_3, %bb3c_4) : (i64, i64) -> i64
      "braid.guard"(%bb3c_5) : (i64) -> ()
      %bb3c_6 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb3c_0 = "braid.add"(%bb3c_1, %bb3c_6) : (i64, i64) -> i64
      %bb3c_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb3c_22 = "braid.add"(%bb3c_0, %bb3c_21) : (i64, i64) -> i64
      %bb3c_23 = "braid.load"(%bb3c_0) {bytes = 4 : i64} : (i64) -> i64
      %bb3c_26 = "braid.load"(%bb3c_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb3c_23) {reg = "x5"} : (i64) -> ()
      "braid.set"(%bb3c_26) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x10084
      %bb40_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb40_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb40_3 = "braid.and"(%bb40_1, %bb40_2) : (i64, i64) -> i64
      %bb40_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb40_5 = "braid.eq"(%bb40_3, %bb40_4) : (i64, i64) -> i64
      "braid.guard"(%bb40_5) : (i64) -> ()
      %bb40_6 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb40_0 = "braid.add"(%bb40_1, %bb40_6) : (i64, i64) -> i64
      %bb40_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb40_22 = "braid.add"(%bb40_0, %bb40_21) : (i64, i64) -> i64
      %bb40_23 = "braid.load"(%bb40_0) {bytes = 4 : i64} : (i64) -> i64
      %bb40_26 = "braid.load"(%bb40_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb40_23) {reg = "x3"} : (i64) -> ()
      "braid.set"(%bb40_26) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10088
      %bb44_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb44_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb44_3 = "braid.and"(%bb44_1, %bb44_2) : (i64, i64) -> i64
      %bb44_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb44_5 = "braid.eq"(%bb44_3, %bb44_4) : (i64, i64) -> i64
      "braid.guard"(%bb44_5) : (i64) -> ()
      %bb44_6 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb44_0 = "braid.add"(%bb44_1, %bb44_6) : (i64, i64) -> i64
      %bb44_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb44_22 = "braid.add"(%bb44_0, %bb44_21) : (i64, i64) -> i64
      %bb44_23 = "braid.load"(%bb44_0) {bytes = 4 : i64} : (i64) -> i64
      %bb44_26 = "braid.load"(%bb44_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb44_23) {reg = "x4"} : (i64) -> ()
      "braid.set"(%bb44_26) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x1008c
      %bb48_0 = "braid.const"() {value = 10 : i64} : () -> i64
      "braid.set"(%bb48_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x10090
      %bb4c_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb4c_0 = "braid.zext"(%bb4c_1) {bits = 32 : i64} : (i64) -> i64
      %bb4c_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb4c_2 = "braid.zext"(%bb4c_3) {bits = 32 : i64} : (i64) -> i64
      %bb4c_13 = "braid.add"(%bb4c_0, %bb4c_2) : (i64, i64) -> i64
      %bb4c_12 = "braid.zext"(%bb4c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb4c_12) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x10094
      %bb50_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb50_0 = "braid.zext"(%bb50_1) {bits = 32 : i64} : (i64) -> i64
      %bb50_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb50_2 = "braid.zext"(%bb50_3) {bits = 32 : i64} : (i64) -> i64
      %bb50_13 = "braid.add"(%bb50_0, %bb50_2) : (i64, i64) -> i64
      %bb50_12 = "braid.zext"(%bb50_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb50_12) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x10098
      %bb54_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb54_0 = "braid.zext"(%bb54_1) {bits = 32 : i64} : (i64) -> i64
      %bb54_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb54_2 = "braid.zext"(%bb54_3) {bits = 32 : i64} : (i64) -> i64
      %bb54_13 = "braid.add"(%bb54_0, %bb54_2) : (i64, i64) -> i64
      %bb54_12 = "braid.zext"(%bb54_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb54_12) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x1009c
      %bb58_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb58_0 = "braid.zext"(%bb58_1) {bits = 32 : i64} : (i64) -> i64
      %bb58_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bb58_2 = "braid.zext"(%bb58_3) {bits = 32 : i64} : (i64) -> i64
      %bb58_13 = "braid.add"(%bb58_0, %bb58_2) : (i64, i64) -> i64
      %bb58_12 = "braid.zext"(%bb58_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb58_12) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x100a0
      %bb5c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb5c_0 = "braid.zext"(%bb5c_1) {bits = 32 : i64} : (i64) -> i64
      %bb5c_3 = "braid.get"() {reg = "x7"} : () -> i64
      %bb5c_2 = "braid.zext"(%bb5c_3) {bits = 32 : i64} : (i64) -> i64
      %bb5c_12 = "braid.xor"(%bb5c_0, %bb5c_2) : (i64, i64) -> i64
      "braid.set"(%bb5c_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x100a4
      %bb60_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb60_0 = "braid.zext"(%bb60_1) {bits = 32 : i64} : (i64) -> i64
      %bb60_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bb60_2 = "braid.zext"(%bb60_3) {bits = 32 : i64} : (i64) -> i64
      %bb60_12 = "braid.xor"(%bb60_0, %bb60_2) : (i64, i64) -> i64
      "braid.set"(%bb60_12) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x100a8
      %bb64_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb64_0 = "braid.zext"(%bb64_1) {bits = 32 : i64} : (i64) -> i64
      %bb64_3 = "braid.get"() {reg = "x5"} : () -> i64
      %bb64_2 = "braid.zext"(%bb64_3) {bits = 32 : i64} : (i64) -> i64
      %bb64_12 = "braid.xor"(%bb64_0, %bb64_2) : (i64, i64) -> i64
      "braid.set"(%bb64_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x100ac
      %bb68_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb68_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb68_2 = "braid.zext"(%bb68_1) {bits = 32 : i64} : (i64) -> i64
      %bb68_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb68_4 = "braid.lshr"(%bb68_2, %bb68_3) : (i64, i64) -> i64
      %bb68_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb68_6 = "braid.shl"(%bb68_0, %bb68_5) : (i64, i64) -> i64
      %bb68_7 = "braid.or"(%bb68_4, %bb68_6) : (i64, i64) -> i64
      %bb68_9 = "braid.zext"(%bb68_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb68_9) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x100b0
      %bb6c_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb6c_0 = "braid.zext"(%bb6c_1) {bits = 32 : i64} : (i64) -> i64
      %bb6c_3 = "braid.get"() {reg = "x16"} : () -> i64
      %bb6c_2 = "braid.zext"(%bb6c_3) {bits = 32 : i64} : (i64) -> i64
      %bb6c_12 = "braid.xor"(%bb6c_0, %bb6c_2) : (i64, i64) -> i64
      "braid.set"(%bb6c_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x100b4
      %bb70_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb70_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb70_2 = "braid.zext"(%bb70_1) {bits = 32 : i64} : (i64) -> i64
      %bb70_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb70_4 = "braid.lshr"(%bb70_2, %bb70_3) : (i64, i64) -> i64
      %bb70_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb70_6 = "braid.shl"(%bb70_0, %bb70_5) : (i64, i64) -> i64
      %bb70_7 = "braid.or"(%bb70_4, %bb70_6) : (i64, i64) -> i64
      %bb70_9 = "braid.zext"(%bb70_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb70_9) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x100b8
      %bb74_0 = "braid.get"() {reg = "x3"} : () -> i64
      %bb74_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb74_2 = "braid.zext"(%bb74_1) {bits = 32 : i64} : (i64) -> i64
      %bb74_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb74_4 = "braid.lshr"(%bb74_2, %bb74_3) : (i64, i64) -> i64
      %bb74_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb74_6 = "braid.shl"(%bb74_0, %bb74_5) : (i64, i64) -> i64
      %bb74_7 = "braid.or"(%bb74_4, %bb74_6) : (i64, i64) -> i64
      %bb74_9 = "braid.zext"(%bb74_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb74_9) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x100bc
      %bb78_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb78_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb78_2 = "braid.zext"(%bb78_1) {bits = 32 : i64} : (i64) -> i64
      %bb78_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb78_4 = "braid.lshr"(%bb78_2, %bb78_3) : (i64, i64) -> i64
      %bb78_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb78_6 = "braid.shl"(%bb78_0, %bb78_5) : (i64, i64) -> i64
      %bb78_7 = "braid.or"(%bb78_4, %bb78_6) : (i64, i64) -> i64
      %bb78_9 = "braid.zext"(%bb78_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb78_9) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x100c0
      %bb7c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb7c_0 = "braid.zext"(%bb7c_1) {bits = 32 : i64} : (i64) -> i64
      %bb7c_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bb7c_2 = "braid.zext"(%bb7c_3) {bits = 32 : i64} : (i64) -> i64
      %bb7c_13 = "braid.add"(%bb7c_0, %bb7c_2) : (i64, i64) -> i64
      %bb7c_12 = "braid.zext"(%bb7c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb7c_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x100c4
      %bb80_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb80_0 = "braid.zext"(%bb80_1) {bits = 32 : i64} : (i64) -> i64
      %bb80_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb80_8 = "braid.sub"(%bb80_0, %bb80_2) : (i64, i64) -> i64
      %bb80_3 = "braid.zext"(%bb80_8) {bits = 32 : i64} : (i64) -> i64
      %bb80_9 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb80_10 = "braid.sext"(%bb80_3) {bits = 32 : i64} : (i64) -> i64
      %bb80_4 = "braid.slt"(%bb80_10, %bb80_9) : (i64, i64) -> i64
      %bb80_5 = "braid.eq"(%bb80_0, %bb80_2) : (i64, i64) -> i64
      %bb80_6 = "braid.ule"(%bb80_2, %bb80_0) : (i64, i64) -> i64
      %bb80_11 = "braid.xor"(%bb80_0, %bb80_2) : (i64, i64) -> i64
      %bb80_12 = "braid.xor"(%bb80_0, %bb80_3) : (i64, i64) -> i64
      %bb80_13 = "braid.and"(%bb80_11, %bb80_12) : (i64, i64) -> i64
      %bb80_14 = "braid.sext"(%bb80_13) {bits = 32 : i64} : (i64) -> i64
      %bb80_7 = "braid.slt"(%bb80_14, %bb80_9) : (i64, i64) -> i64
      "braid.setf"(%bb80_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb80_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb80_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb80_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb80_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x100c8
      %bb84_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb84_0 = "braid.zext"(%bb84_1) {bits = 32 : i64} : (i64) -> i64
      %bb84_3 = "braid.get"() {reg = "x15"} : () -> i64
      %bb84_2 = "braid.zext"(%bb84_3) {bits = 32 : i64} : (i64) -> i64
      %bb84_13 = "braid.add"(%bb84_0, %bb84_2) : (i64, i64) -> i64
      %bb84_12 = "braid.zext"(%bb84_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb84_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x100cc
      %bb88_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bb88_0 = "braid.zext"(%bb88_1) {bits = 32 : i64} : (i64) -> i64
      %bb88_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bb88_2 = "braid.zext"(%bb88_3) {bits = 32 : i64} : (i64) -> i64
      %bb88_13 = "braid.add"(%bb88_0, %bb88_2) : (i64, i64) -> i64
      %bb88_12 = "braid.zext"(%bb88_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb88_12) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x100d0
      %bb8c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb8c_0 = "braid.zext"(%bb8c_1) {bits = 32 : i64} : (i64) -> i64
      %bb8c_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb8c_2 = "braid.zext"(%bb8c_3) {bits = 32 : i64} : (i64) -> i64
      %bb8c_12 = "braid.xor"(%bb8c_0, %bb8c_2) : (i64, i64) -> i64
      "braid.set"(%bb8c_12) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x100d4
      %bb90_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb90_0 = "braid.zext"(%bb90_1) {bits = 32 : i64} : (i64) -> i64
      %bb90_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb90_2 = "braid.zext"(%bb90_3) {bits = 32 : i64} : (i64) -> i64
      %bb90_12 = "braid.xor"(%bb90_0, %bb90_2) : (i64, i64) -> i64
      "braid.set"(%bb90_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x100d8
      %bb94_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb94_0 = "braid.zext"(%bb94_1) {bits = 32 : i64} : (i64) -> i64
      %bb94_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bb94_2 = "braid.zext"(%bb94_3) {bits = 32 : i64} : (i64) -> i64
      %bb94_13 = "braid.add"(%bb94_0, %bb94_2) : (i64, i64) -> i64
      %bb94_12 = "braid.zext"(%bb94_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb94_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x100dc
      %bb98_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bb98_0 = "braid.zext"(%bb98_1) {bits = 32 : i64} : (i64) -> i64
      %bb98_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb98_2 = "braid.zext"(%bb98_3) {bits = 32 : i64} : (i64) -> i64
      %bb98_12 = "braid.xor"(%bb98_0, %bb98_2) : (i64, i64) -> i64
      "braid.set"(%bb98_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x100e0
      %bb9c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb9c_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb9c_2 = "braid.zext"(%bb9c_1) {bits = 32 : i64} : (i64) -> i64
      %bb9c_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb9c_4 = "braid.lshr"(%bb9c_2, %bb9c_3) : (i64, i64) -> i64
      %bb9c_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb9c_6 = "braid.shl"(%bb9c_0, %bb9c_5) : (i64, i64) -> i64
      %bb9c_7 = "braid.or"(%bb9c_4, %bb9c_6) : (i64, i64) -> i64
      %bb9c_9 = "braid.zext"(%bb9c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb9c_9) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x100e4
      %bba0_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bba0_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bba0_2 = "braid.zext"(%bba0_1) {bits = 32 : i64} : (i64) -> i64
      %bba0_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bba0_4 = "braid.lshr"(%bba0_2, %bba0_3) : (i64, i64) -> i64
      %bba0_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bba0_6 = "braid.shl"(%bba0_0, %bba0_5) : (i64, i64) -> i64
      %bba0_7 = "braid.or"(%bba0_4, %bba0_6) : (i64, i64) -> i64
      %bba0_9 = "braid.zext"(%bba0_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bba0_9) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bba4] : () -> ()
    ^bba4:  // 0x100e8
      %bba4_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bba4_0 = "braid.zext"(%bba4_1) {bits = 32 : i64} : (i64) -> i64
      %bba4_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bba4_2 = "braid.zext"(%bba4_3) {bits = 32 : i64} : (i64) -> i64
      %bba4_12 = "braid.xor"(%bba4_0, %bba4_2) : (i64, i64) -> i64
      "braid.set"(%bba4_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x100ec
      %bba8_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bba8_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bba8_2 = "braid.zext"(%bba8_1) {bits = 32 : i64} : (i64) -> i64
      %bba8_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bba8_4 = "braid.lshr"(%bba8_2, %bba8_3) : (i64, i64) -> i64
      %bba8_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bba8_6 = "braid.shl"(%bba8_0, %bba8_5) : (i64, i64) -> i64
      %bba8_7 = "braid.or"(%bba8_4, %bba8_6) : (i64, i64) -> i64
      %bba8_9 = "braid.zext"(%bba8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bba8_9) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x100f0
      %bbac_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbac_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bbac_2 = "braid.zext"(%bbac_1) {bits = 32 : i64} : (i64) -> i64
      %bbac_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bbac_4 = "braid.lshr"(%bbac_2, %bbac_3) : (i64, i64) -> i64
      %bbac_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bbac_6 = "braid.shl"(%bbac_0, %bbac_5) : (i64, i64) -> i64
      %bbac_7 = "braid.or"(%bbac_4, %bbac_6) : (i64, i64) -> i64
      %bbac_9 = "braid.zext"(%bbac_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbac_9) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x100f4
      %bbb0_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bbb0_0 = "braid.zext"(%bbb0_1) {bits = 32 : i64} : (i64) -> i64
      %bbb0_3 = "braid.get"() {reg = "x7"} : () -> i64
      %bbb0_2 = "braid.zext"(%bbb0_3) {bits = 32 : i64} : (i64) -> i64
      %bbb0_13 = "braid.add"(%bbb0_0, %bbb0_2) : (i64, i64) -> i64
      %bbb0_12 = "braid.zext"(%bbb0_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbb0_12) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x100f8
      %bbb4_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bbb4_0 = "braid.zext"(%bbb4_1) {bits = 32 : i64} : (i64) -> i64
      %bbb4_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bbb4_2 = "braid.zext"(%bbb4_3) {bits = 32 : i64} : (i64) -> i64
      %bbb4_13 = "braid.add"(%bbb4_0, %bbb4_2) : (i64, i64) -> i64
      %bbb4_12 = "braid.zext"(%bbb4_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbb4_12) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x100fc
      %bbb8_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bbb8_0 = "braid.zext"(%bbb8_1) {bits = 32 : i64} : (i64) -> i64
      %bbb8_3 = "braid.get"() {reg = "x5"} : () -> i64
      %bbb8_2 = "braid.zext"(%bbb8_3) {bits = 32 : i64} : (i64) -> i64
      %bbb8_13 = "braid.add"(%bbb8_0, %bbb8_2) : (i64, i64) -> i64
      %bbb8_12 = "braid.zext"(%bbb8_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbb8_12) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x10100
      %bbbc_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bbbc_0 = "braid.zext"(%bbbc_1) {bits = 32 : i64} : (i64) -> i64
      %bbbc_3 = "braid.get"() {reg = "x16"} : () -> i64
      %bbbc_2 = "braid.zext"(%bbbc_3) {bits = 32 : i64} : (i64) -> i64
      %bbbc_13 = "braid.add"(%bbbc_0, %bbbc_2) : (i64, i64) -> i64
      %bbbc_12 = "braid.zext"(%bbbc_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbbc_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bbc0:  // 0x10104
      %bbc0_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bbc0_0 = "braid.zext"(%bbc0_1) {bits = 32 : i64} : (i64) -> i64
      %bbc0_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bbc0_2 = "braid.zext"(%bbc0_3) {bits = 32 : i64} : (i64) -> i64
      %bbc0_12 = "braid.xor"(%bbc0_0, %bbc0_2) : (i64, i64) -> i64
      "braid.set"(%bbc0_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x10108
      %bbc4_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bbc4_0 = "braid.zext"(%bbc4_1) {bits = 32 : i64} : (i64) -> i64
      %bbc4_3 = "braid.get"() {reg = "x15"} : () -> i64
      %bbc4_2 = "braid.zext"(%bbc4_3) {bits = 32 : i64} : (i64) -> i64
      %bbc4_12 = "braid.xor"(%bbc4_0, %bbc4_2) : (i64, i64) -> i64
      "braid.set"(%bbc4_12) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x1010c
      %bbc8_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bbc8_0 = "braid.zext"(%bbc8_1) {bits = 32 : i64} : (i64) -> i64
      %bbc8_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bbc8_2 = "braid.zext"(%bbc8_3) {bits = 32 : i64} : (i64) -> i64
      %bbc8_12 = "braid.xor"(%bbc8_0, %bbc8_2) : (i64, i64) -> i64
      "braid.set"(%bbc8_12) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x10110
      %bbcc_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbcc_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bbcc_2 = "braid.zext"(%bbcc_1) {bits = 32 : i64} : (i64) -> i64
      %bbcc_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbcc_4 = "braid.lshr"(%bbcc_2, %bbcc_3) : (i64, i64) -> i64
      %bbcc_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbcc_6 = "braid.shl"(%bbcc_0, %bbcc_5) : (i64, i64) -> i64
      %bbcc_7 = "braid.or"(%bbcc_4, %bbcc_6) : (i64, i64) -> i64
      %bbcc_9 = "braid.zext"(%bbcc_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbcc_9) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x10114
      %bbd0_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bbd0_0 = "braid.zext"(%bbd0_1) {bits = 32 : i64} : (i64) -> i64
      %bbd0_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bbd0_2 = "braid.zext"(%bbd0_3) {bits = 32 : i64} : (i64) -> i64
      %bbd0_12 = "braid.xor"(%bbd0_0, %bbd0_2) : (i64, i64) -> i64
      "braid.set"(%bbd0_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x10118
      %bbd4_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bbd4_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bbd4_2 = "braid.zext"(%bbd4_1) {bits = 32 : i64} : (i64) -> i64
      %bbd4_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbd4_4 = "braid.lshr"(%bbd4_2, %bbd4_3) : (i64, i64) -> i64
      %bbd4_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbd4_6 = "braid.shl"(%bbd4_0, %bbd4_5) : (i64, i64) -> i64
      %bbd4_7 = "braid.or"(%bbd4_4, %bbd4_6) : (i64, i64) -> i64
      %bbd4_9 = "braid.zext"(%bbd4_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd4_9) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbd8] : () -> ()
    ^bbd8:  // 0x1011c
      %bbd8_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bbd8_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bbd8_2 = "braid.zext"(%bbd8_1) {bits = 32 : i64} : (i64) -> i64
      %bbd8_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbd8_4 = "braid.lshr"(%bbd8_2, %bbd8_3) : (i64, i64) -> i64
      %bbd8_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbd8_6 = "braid.shl"(%bbd8_0, %bbd8_5) : (i64, i64) -> i64
      %bbd8_7 = "braid.or"(%bbd8_4, %bbd8_6) : (i64, i64) -> i64
      %bbd8_9 = "braid.zext"(%bbd8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd8_9) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x10120
      %bbdc_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbdc_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bbdc_2 = "braid.zext"(%bbdc_1) {bits = 32 : i64} : (i64) -> i64
      %bbdc_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbdc_4 = "braid.lshr"(%bbdc_2, %bbdc_3) : (i64, i64) -> i64
      %bbdc_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbdc_6 = "braid.shl"(%bbdc_0, %bbdc_5) : (i64, i64) -> i64
      %bbdc_7 = "braid.or"(%bbdc_4, %bbdc_6) : (i64, i64) -> i64
      %bbdc_9 = "braid.zext"(%bbdc_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbdc_9) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bbe0] : () -> ()
    ^bbe0:  // 0x10124
      %bbe0_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bbe0_0 = "braid.zext"(%bbe0_1) {bits = 32 : i64} : (i64) -> i64
      %bbe0_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bbe0_2 = "braid.zext"(%bbe0_3) {bits = 32 : i64} : (i64) -> i64
      %bbe0_13 = "braid.add"(%bbe0_0, %bbe0_2) : (i64, i64) -> i64
      %bbe0_12 = "braid.zext"(%bbe0_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbe0_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x10128
      %bbe4_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bbe4_0 = "braid.zext"(%bbe4_1) {bits = 32 : i64} : (i64) -> i64
      %bbe4_3 = "braid.get"() {reg = "x18"} : () -> i64
      %bbe4_2 = "braid.zext"(%bbe4_3) {bits = 32 : i64} : (i64) -> i64
      %bbe4_13 = "braid.add"(%bbe4_0, %bbe4_2) : (i64, i64) -> i64
      %bbe4_12 = "braid.zext"(%bbe4_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbe4_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbe8] : () -> ()
    ^bbe8:  // 0x1012c
      %bbe8_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bbe8_0 = "braid.zext"(%bbe8_1) {bits = 32 : i64} : (i64) -> i64
      %bbe8_3 = "braid.get"() {reg = "x4"} : () -> i64
      %bbe8_2 = "braid.zext"(%bbe8_3) {bits = 32 : i64} : (i64) -> i64
      %bbe8_13 = "braid.add"(%bbe8_0, %bbe8_2) : (i64, i64) -> i64
      %bbe8_12 = "braid.zext"(%bbe8_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbe8_12) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bbec] : () -> ()
    ^bbec:  // 0x10130
      %bbec_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bbec_0 = "braid.zext"(%bbec_1) {bits = 32 : i64} : (i64) -> i64
      %bbec_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bbec_2 = "braid.zext"(%bbec_3) {bits = 32 : i64} : (i64) -> i64
      %bbec_12 = "braid.xor"(%bbec_0, %bbec_2) : (i64, i64) -> i64
      "braid.set"(%bbec_12) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbf0] : () -> ()
    ^bbf0:  // 0x10134
      %bbf0_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bbf0_0 = "braid.zext"(%bbf0_1) {bits = 32 : i64} : (i64) -> i64
      %bbf0_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bbf0_2 = "braid.zext"(%bbf0_3) {bits = 32 : i64} : (i64) -> i64
      %bbf0_13 = "braid.add"(%bbf0_0, %bbf0_2) : (i64, i64) -> i64
      %bbf0_12 = "braid.zext"(%bbf0_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbf0_12) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bbf4] : () -> ()
    ^bbf4:  // 0x10138
      %bbf4_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bbf4_0 = "braid.zext"(%bbf4_1) {bits = 32 : i64} : (i64) -> i64
      %bbf4_3 = "braid.get"() {reg = "x19"} : () -> i64
      %bbf4_2 = "braid.zext"(%bbf4_3) {bits = 32 : i64} : (i64) -> i64
      %bbf4_12 = "braid.xor"(%bbf4_0, %bbf4_2) : (i64, i64) -> i64
      "braid.set"(%bbf4_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bbf8] : () -> ()
    ^bbf8:  // 0x1013c
      %bbf8_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bbf8_0 = "braid.zext"(%bbf8_1) {bits = 32 : i64} : (i64) -> i64
      %bbf8_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bbf8_2 = "braid.zext"(%bbf8_3) {bits = 32 : i64} : (i64) -> i64
      %bbf8_12 = "braid.xor"(%bbf8_0, %bbf8_2) : (i64, i64) -> i64
      "braid.set"(%bbf8_12) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bbfc] : () -> ()
    ^bbfc:  // 0x10140
      %bbfc_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bbfc_0 = "braid.zext"(%bbfc_1) {bits = 32 : i64} : (i64) -> i64
      %bbfc_3 = "braid.get"() {reg = "x20"} : () -> i64
      %bbfc_2 = "braid.zext"(%bbfc_3) {bits = 32 : i64} : (i64) -> i64
      %bbfc_12 = "braid.xor"(%bbfc_0, %bbfc_2) : (i64, i64) -> i64
      "braid.set"(%bbfc_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb100:  // 0x10144
      %bb100_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb100_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb100_2 = "braid.zext"(%bb100_1) {bits = 32 : i64} : (i64) -> i64
      %bb100_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb100_4 = "braid.lshr"(%bb100_2, %bb100_3) : (i64, i64) -> i64
      %bb100_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb100_6 = "braid.shl"(%bb100_0, %bb100_5) : (i64, i64) -> i64
      %bb100_7 = "braid.or"(%bb100_4, %bb100_6) : (i64, i64) -> i64
      %bb100_9 = "braid.zext"(%bb100_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb100_9) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb104] : () -> ()
    ^bb104:  // 0x10148
      %bb104_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb104_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb104_2 = "braid.zext"(%bb104_1) {bits = 32 : i64} : (i64) -> i64
      %bb104_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb104_4 = "braid.lshr"(%bb104_2, %bb104_3) : (i64, i64) -> i64
      %bb104_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb104_6 = "braid.shl"(%bb104_0, %bb104_5) : (i64, i64) -> i64
      %bb104_7 = "braid.or"(%bb104_4, %bb104_6) : (i64, i64) -> i64
      %bb104_9 = "braid.zext"(%bb104_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb104_9) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x1014c
      %bb108_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb108_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb108_2 = "braid.zext"(%bb108_1) {bits = 32 : i64} : (i64) -> i64
      %bb108_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb108_4 = "braid.lshr"(%bb108_2, %bb108_3) : (i64, i64) -> i64
      %bb108_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb108_6 = "braid.shl"(%bb108_0, %bb108_5) : (i64, i64) -> i64
      %bb108_7 = "braid.or"(%bb108_4, %bb108_6) : (i64, i64) -> i64
      %bb108_9 = "braid.zext"(%bb108_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb108_9) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb10c] : () -> ()
    ^bb10c:  // 0x10150
      %bb10c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb10c_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb10c_2 = "braid.zext"(%bb10c_1) {bits = 32 : i64} : (i64) -> i64
      %bb10c_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb10c_4 = "braid.lshr"(%bb10c_2, %bb10c_3) : (i64, i64) -> i64
      %bb10c_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb10c_6 = "braid.shl"(%bb10c_0, %bb10c_5) : (i64, i64) -> i64
      %bb10c_7 = "braid.or"(%bb10c_4, %bb10c_6) : (i64, i64) -> i64
      %bb10c_9 = "braid.zext"(%bb10c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb10c_9) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb110] : () -> ()
    ^bb110:  // 0x10154
      %bb110_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb110_0 = "braid.zext"(%bb110_1) {bits = 32 : i64} : (i64) -> i64
      %bb110_3 = "braid.get"() {reg = "x7"} : () -> i64
      %bb110_2 = "braid.zext"(%bb110_3) {bits = 32 : i64} : (i64) -> i64
      %bb110_13 = "braid.add"(%bb110_0, %bb110_2) : (i64, i64) -> i64
      %bb110_12 = "braid.zext"(%bb110_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb110_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb114] : () -> ()
    ^bb114:  // 0x10158
      %bb114_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb114_0 = "braid.zext"(%bb114_1) {bits = 32 : i64} : (i64) -> i64
      %bb114_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bb114_2 = "braid.zext"(%bb114_3) {bits = 32 : i64} : (i64) -> i64
      %bb114_13 = "braid.add"(%bb114_0, %bb114_2) : (i64, i64) -> i64
      %bb114_12 = "braid.zext"(%bb114_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb114_12) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x1015c
      %bb118_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb118_0 = "braid.zext"(%bb118_1) {bits = 32 : i64} : (i64) -> i64
      %bb118_3 = "braid.get"() {reg = "x5"} : () -> i64
      %bb118_2 = "braid.zext"(%bb118_3) {bits = 32 : i64} : (i64) -> i64
      %bb118_13 = "braid.add"(%bb118_0, %bb118_2) : (i64, i64) -> i64
      %bb118_12 = "braid.zext"(%bb118_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb118_12) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb11c] : () -> ()
    ^bb11c:  // 0x10160
      %bb11c_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb11c_0 = "braid.zext"(%bb11c_1) {bits = 32 : i64} : (i64) -> i64
      %bb11c_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb11c_2 = "braid.zext"(%bb11c_3) {bits = 32 : i64} : (i64) -> i64
      %bb11c_13 = "braid.add"(%bb11c_0, %bb11c_2) : (i64, i64) -> i64
      %bb11c_12 = "braid.zext"(%bb11c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb11c_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x10164
      %bb120_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb120_0 = "braid.zext"(%bb120_1) {bits = 32 : i64} : (i64) -> i64
      %bb120_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bb120_2 = "braid.zext"(%bb120_3) {bits = 32 : i64} : (i64) -> i64
      %bb120_12 = "braid.xor"(%bb120_0, %bb120_2) : (i64, i64) -> i64
      "braid.set"(%bb120_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bb124] : () -> ()
    ^bb124:  // 0x10168
      %bb124_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb124_0 = "braid.zext"(%bb124_1) {bits = 32 : i64} : (i64) -> i64
      %bb124_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bb124_2 = "braid.zext"(%bb124_3) {bits = 32 : i64} : (i64) -> i64
      %bb124_12 = "braid.xor"(%bb124_0, %bb124_2) : (i64, i64) -> i64
      "braid.set"(%bb124_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb128] : () -> ()
    ^bb128:  // 0x1016c
      %bb128_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb128_0 = "braid.zext"(%bb128_1) {bits = 32 : i64} : (i64) -> i64
      %bb128_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bb128_2 = "braid.zext"(%bb128_3) {bits = 32 : i64} : (i64) -> i64
      %bb128_12 = "braid.xor"(%bb128_0, %bb128_2) : (i64, i64) -> i64
      "braid.set"(%bb128_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb12c] : () -> ()
    ^bb12c:  // 0x10170
      %bb12c_0 = "braid.get"() {reg = "x3"} : () -> i64
      %bb12c_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb12c_2 = "braid.zext"(%bb12c_1) {bits = 32 : i64} : (i64) -> i64
      %bb12c_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb12c_4 = "braid.lshr"(%bb12c_2, %bb12c_3) : (i64, i64) -> i64
      %bb12c_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb12c_6 = "braid.shl"(%bb12c_0, %bb12c_5) : (i64, i64) -> i64
      %bb12c_7 = "braid.or"(%bb12c_4, %bb12c_6) : (i64, i64) -> i64
      %bb12c_9 = "braid.zext"(%bb12c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb12c_9) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bb130] : () -> ()
    ^bb130:  // 0x10174
      %bb130_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb130_0 = "braid.zext"(%bb130_1) {bits = 32 : i64} : (i64) -> i64
      %bb130_3 = "braid.get"() {reg = "x15"} : () -> i64
      %bb130_2 = "braid.zext"(%bb130_3) {bits = 32 : i64} : (i64) -> i64
      %bb130_12 = "braid.xor"(%bb130_0, %bb130_2) : (i64, i64) -> i64
      "braid.set"(%bb130_12) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb134:  // 0x10178
      %bb134_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb134_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb134_2 = "braid.zext"(%bb134_1) {bits = 32 : i64} : (i64) -> i64
      %bb134_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb134_4 = "braid.lshr"(%bb134_2, %bb134_3) : (i64, i64) -> i64
      %bb134_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb134_6 = "braid.shl"(%bb134_0, %bb134_5) : (i64, i64) -> i64
      %bb134_7 = "braid.or"(%bb134_4, %bb134_6) : (i64, i64) -> i64
      %bb134_9 = "braid.zext"(%bb134_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb134_9) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb138] : () -> ()
    ^bb138:  // 0x1017c
      %bb138_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb138_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb138_2 = "braid.zext"(%bb138_1) {bits = 32 : i64} : (i64) -> i64
      %bb138_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb138_4 = "braid.lshr"(%bb138_2, %bb138_3) : (i64, i64) -> i64
      %bb138_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb138_6 = "braid.shl"(%bb138_0, %bb138_5) : (i64, i64) -> i64
      %bb138_7 = "braid.or"(%bb138_4, %bb138_6) : (i64, i64) -> i64
      %bb138_9 = "braid.zext"(%bb138_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb138_9) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb13c] : () -> ()
    ^bb13c:  // 0x10180
      %bb13c_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb13c_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb13c_2 = "braid.zext"(%bb13c_1) {bits = 32 : i64} : (i64) -> i64
      %bb13c_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb13c_4 = "braid.lshr"(%bb13c_2, %bb13c_3) : (i64, i64) -> i64
      %bb13c_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb13c_6 = "braid.shl"(%bb13c_0, %bb13c_5) : (i64, i64) -> i64
      %bb13c_7 = "braid.or"(%bb13c_4, %bb13c_6) : (i64, i64) -> i64
      %bb13c_9 = "braid.zext"(%bb13c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb13c_9) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb140] : () -> ()
    ^bb140:  // 0x10184
      %bb140_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb140_0 = "braid.zext"(%bb140_1) {bits = 32 : i64} : (i64) -> i64
      %bb140_3 = "braid.get"() {reg = "x16"} : () -> i64
      %bb140_2 = "braid.zext"(%bb140_3) {bits = 32 : i64} : (i64) -> i64
      %bb140_13 = "braid.add"(%bb140_0, %bb140_2) : (i64, i64) -> i64
      %bb140_12 = "braid.zext"(%bb140_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb140_12) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb144] : () -> ()
    ^bb144:  // 0x10188
      %bb144_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bb144_0 = "braid.zext"(%bb144_1) {bits = 32 : i64} : (i64) -> i64
      %bb144_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bb144_2 = "braid.zext"(%bb144_3) {bits = 32 : i64} : (i64) -> i64
      %bb144_13 = "braid.add"(%bb144_0, %bb144_2) : (i64, i64) -> i64
      %bb144_12 = "braid.zext"(%bb144_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb144_12) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb148] : () -> ()
    ^bb148:  // 0x1018c
      %bb148_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb148_0 = "braid.zext"(%bb148_1) {bits = 32 : i64} : (i64) -> i64
      %bb148_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb148_2 = "braid.zext"(%bb148_3) {bits = 32 : i64} : (i64) -> i64
      %bb148_13 = "braid.add"(%bb148_0, %bb148_2) : (i64, i64) -> i64
      %bb148_12 = "braid.zext"(%bb148_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb148_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb14c] : () -> ()
    ^bb14c:  // 0x10190
      %bb14c_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb14c_0 = "braid.zext"(%bb14c_1) {bits = 32 : i64} : (i64) -> i64
      %bb14c_3 = "braid.get"() {reg = "x18"} : () -> i64
      %bb14c_2 = "braid.zext"(%bb14c_3) {bits = 32 : i64} : (i64) -> i64
      %bb14c_12 = "braid.xor"(%bb14c_0, %bb14c_2) : (i64, i64) -> i64
      "braid.set"(%bb14c_12) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb150] : () -> ()
    ^bb150:  // 0x10194
      %bb150_1 = "braid.get"() {reg = "x21"} : () -> i64
      %bb150_0 = "braid.zext"(%bb150_1) {bits = 32 : i64} : (i64) -> i64
      %bb150_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bb150_2 = "braid.zext"(%bb150_3) {bits = 32 : i64} : (i64) -> i64
      %bb150_12 = "braid.xor"(%bb150_0, %bb150_2) : (i64, i64) -> i64
      "braid.set"(%bb150_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb154] : () -> ()
    ^bb154:  // 0x10198
      %bb154_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb154_0 = "braid.zext"(%bb154_1) {bits = 32 : i64} : (i64) -> i64
      %bb154_3 = "braid.get"() {reg = "x19"} : () -> i64
      %bb154_2 = "braid.zext"(%bb154_3) {bits = 32 : i64} : (i64) -> i64
      %bb154_12 = "braid.xor"(%bb154_0, %bb154_2) : (i64, i64) -> i64
      "braid.set"(%bb154_12) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb158] : () -> ()
    ^bb158:  // 0x1019c
      %bb158_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb158_0 = "braid.zext"(%bb158_1) {bits = 32 : i64} : (i64) -> i64
      %bb158_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb158_2 = "braid.zext"(%bb158_3) {bits = 32 : i64} : (i64) -> i64
      %bb158_13 = "braid.add"(%bb158_0, %bb158_2) : (i64, i64) -> i64
      %bb158_12 = "braid.zext"(%bb158_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb158_12) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb15c] : () -> ()
    ^bb15c:  // 0x101a0
      %bb15c_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb15c_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb15c_2 = "braid.zext"(%bb15c_1) {bits = 32 : i64} : (i64) -> i64
      %bb15c_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb15c_4 = "braid.lshr"(%bb15c_2, %bb15c_3) : (i64, i64) -> i64
      %bb15c_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb15c_6 = "braid.shl"(%bb15c_0, %bb15c_5) : (i64, i64) -> i64
      %bb15c_7 = "braid.or"(%bb15c_4, %bb15c_6) : (i64, i64) -> i64
      %bb15c_9 = "braid.zext"(%bb15c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb15c_9) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb160] : () -> ()
    ^bb160:  // 0x101a4
      %bb160_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb160_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb160_2 = "braid.zext"(%bb160_1) {bits = 32 : i64} : (i64) -> i64
      %bb160_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb160_4 = "braid.lshr"(%bb160_2, %bb160_3) : (i64, i64) -> i64
      %bb160_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb160_6 = "braid.shl"(%bb160_0, %bb160_5) : (i64, i64) -> i64
      %bb160_7 = "braid.or"(%bb160_4, %bb160_6) : (i64, i64) -> i64
      %bb160_9 = "braid.zext"(%bb160_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb160_9) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb164] : () -> ()
    ^bb164:  // 0x101a8
      %bb164_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb164_0 = "braid.zext"(%bb164_1) {bits = 32 : i64} : (i64) -> i64
      %bb164_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb164_2 = "braid.zext"(%bb164_3) {bits = 32 : i64} : (i64) -> i64
      %bb164_12 = "braid.xor"(%bb164_0, %bb164_2) : (i64, i64) -> i64
      "braid.set"(%bb164_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb168] : () -> ()
    ^bb168:  // 0x101ac
      %bb168_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb168_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb168_2 = "braid.zext"(%bb168_1) {bits = 32 : i64} : (i64) -> i64
      %bb168_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb168_4 = "braid.lshr"(%bb168_2, %bb168_3) : (i64, i64) -> i64
      %bb168_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb168_6 = "braid.shl"(%bb168_0, %bb168_5) : (i64, i64) -> i64
      %bb168_7 = "braid.or"(%bb168_4, %bb168_6) : (i64, i64) -> i64
      %bb168_9 = "braid.zext"(%bb168_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb168_9) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb16c] : () -> ()
    ^bb16c:  // 0x101b0
      %bb16c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb16c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb16c_2 = "braid.zext"(%bb16c_1) {bits = 32 : i64} : (i64) -> i64
      %bb16c_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb16c_4 = "braid.lshr"(%bb16c_2, %bb16c_3) : (i64, i64) -> i64
      %bb16c_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb16c_6 = "braid.shl"(%bb16c_0, %bb16c_5) : (i64, i64) -> i64
      %bb16c_7 = "braid.or"(%bb16c_4, %bb16c_6) : (i64, i64) -> i64
      %bb16c_9 = "braid.zext"(%bb16c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb16c_9) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb170] : () -> ()
    ^bb170:  // 0x101b4
      %bb170_1 = "braid.get"() {reg = "x22"} : () -> i64
      %bb170_0 = "braid.zext"(%bb170_1) {bits = 32 : i64} : (i64) -> i64
      %bb170_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bb170_2 = "braid.zext"(%bb170_3) {bits = 32 : i64} : (i64) -> i64
      %bb170_13 = "braid.add"(%bb170_0, %bb170_2) : (i64, i64) -> i64
      %bb170_12 = "braid.zext"(%bb170_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb170_12) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb174] : () -> ()
    ^bb174:  // 0x101b8
      %bb174_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb174_0 = "braid.zext"(%bb174_1) {bits = 32 : i64} : (i64) -> i64
      %bb174_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bb174_2 = "braid.zext"(%bb174_3) {bits = 32 : i64} : (i64) -> i64
      %bb174_13 = "braid.add"(%bb174_0, %bb174_2) : (i64, i64) -> i64
      %bb174_12 = "braid.zext"(%bb174_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb174_12) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb178] : () -> ()
    ^bb178:  // 0x101bc
      %bb178_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb178_0 = "braid.zext"(%bb178_1) {bits = 32 : i64} : (i64) -> i64
      %bb178_3 = "braid.get"() {reg = "x5"} : () -> i64
      %bb178_2 = "braid.zext"(%bb178_3) {bits = 32 : i64} : (i64) -> i64
      %bb178_13 = "braid.add"(%bb178_0, %bb178_2) : (i64, i64) -> i64
      %bb178_12 = "braid.zext"(%bb178_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb178_12) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb17c] : () -> ()
    ^bb17c:  // 0x101c0
      %bb17c_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb17c_0 = "braid.zext"(%bb17c_1) {bits = 32 : i64} : (i64) -> i64
      %bb17c_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb17c_2 = "braid.zext"(%bb17c_3) {bits = 32 : i64} : (i64) -> i64
      %bb17c_13 = "braid.add"(%bb17c_0, %bb17c_2) : (i64, i64) -> i64
      %bb17c_12 = "braid.zext"(%bb17c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb17c_12) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb180] : () -> ()
    ^bb180:  // 0x101c4
      %bb180_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb180_0 = "braid.zext"(%bb180_1) {bits = 32 : i64} : (i64) -> i64
      %bb180_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bb180_2 = "braid.zext"(%bb180_3) {bits = 32 : i64} : (i64) -> i64
      %bb180_12 = "braid.xor"(%bb180_0, %bb180_2) : (i64, i64) -> i64
      "braid.set"(%bb180_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb184] : () -> ()
    ^bb184:  // 0x101c8
      %bb184_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb184_0 = "braid.zext"(%bb184_1) {bits = 32 : i64} : (i64) -> i64
      %bb184_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bb184_2 = "braid.zext"(%bb184_3) {bits = 32 : i64} : (i64) -> i64
      %bb184_12 = "braid.xor"(%bb184_0, %bb184_2) : (i64, i64) -> i64
      "braid.set"(%bb184_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb188] : () -> ()
    ^bb188:  // 0x101cc
      %bb188_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb188_0 = "braid.zext"(%bb188_1) {bits = 32 : i64} : (i64) -> i64
      %bb188_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bb188_2 = "braid.zext"(%bb188_3) {bits = 32 : i64} : (i64) -> i64
      %bb188_12 = "braid.xor"(%bb188_0, %bb188_2) : (i64, i64) -> i64
      "braid.set"(%bb188_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb18c] : () -> ()
    ^bb18c:  // 0x101d0
      %bb18c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb18c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb18c_2 = "braid.zext"(%bb18c_1) {bits = 32 : i64} : (i64) -> i64
      %bb18c_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb18c_4 = "braid.lshr"(%bb18c_2, %bb18c_3) : (i64, i64) -> i64
      %bb18c_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb18c_6 = "braid.shl"(%bb18c_0, %bb18c_5) : (i64, i64) -> i64
      %bb18c_7 = "braid.or"(%bb18c_4, %bb18c_6) : (i64, i64) -> i64
      %bb18c_9 = "braid.zext"(%bb18c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb18c_9) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x101d4
      %bb190_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb190_0 = "braid.zext"(%bb190_1) {bits = 32 : i64} : (i64) -> i64
      %bb190_3 = "braid.get"() {reg = "x15"} : () -> i64
      %bb190_2 = "braid.zext"(%bb190_3) {bits = 32 : i64} : (i64) -> i64
      %bb190_12 = "braid.xor"(%bb190_0, %bb190_2) : (i64, i64) -> i64
      "braid.set"(%bb190_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb194] : () -> ()
    ^bb194:  // 0x101d8
      %bb194_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb194_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb194_2 = "braid.zext"(%bb194_1) {bits = 32 : i64} : (i64) -> i64
      %bb194_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb194_4 = "braid.lshr"(%bb194_2, %bb194_3) : (i64, i64) -> i64
      %bb194_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb194_6 = "braid.shl"(%bb194_0, %bb194_5) : (i64, i64) -> i64
      %bb194_7 = "braid.or"(%bb194_4, %bb194_6) : (i64, i64) -> i64
      %bb194_9 = "braid.zext"(%bb194_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb194_9) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb198] : () -> ()
    ^bb198:  // 0x101dc
      %bb198_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb198_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb198_2 = "braid.zext"(%bb198_1) {bits = 32 : i64} : (i64) -> i64
      %bb198_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb198_4 = "braid.lshr"(%bb198_2, %bb198_3) : (i64, i64) -> i64
      %bb198_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb198_6 = "braid.shl"(%bb198_0, %bb198_5) : (i64, i64) -> i64
      %bb198_7 = "braid.or"(%bb198_4, %bb198_6) : (i64, i64) -> i64
      %bb198_9 = "braid.zext"(%bb198_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb198_9) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb19c] : () -> ()
    ^bb19c:  // 0x101e0
      %bb19c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb19c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb19c_2 = "braid.zext"(%bb19c_1) {bits = 32 : i64} : (i64) -> i64
      %bb19c_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb19c_4 = "braid.lshr"(%bb19c_2, %bb19c_3) : (i64, i64) -> i64
      %bb19c_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb19c_6 = "braid.shl"(%bb19c_0, %bb19c_5) : (i64, i64) -> i64
      %bb19c_7 = "braid.or"(%bb19c_4, %bb19c_6) : (i64, i64) -> i64
      %bb19c_9 = "braid.zext"(%bb19c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb19c_9) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bb1a0] : () -> ()
    ^bb1a0:  // 0x101e4
      %bb1a0_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb1a0_0 = "braid.zext"(%bb1a0_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a0_3 = "braid.get"() {reg = "x20"} : () -> i64
      %bb1a0_2 = "braid.zext"(%bb1a0_3) {bits = 32 : i64} : (i64) -> i64
      %bb1a0_13 = "braid.add"(%bb1a0_0, %bb1a0_2) : (i64, i64) -> i64
      %bb1a0_12 = "braid.zext"(%bb1a0_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1a0_12) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bb1a4] : () -> ()
    ^bb1a4:  // 0x101e8
      %bb1a4_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb1a4_0 = "braid.zext"(%bb1a4_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a4_3 = "braid.get"() {reg = "x21"} : () -> i64
      %bb1a4_2 = "braid.zext"(%bb1a4_3) {bits = 32 : i64} : (i64) -> i64
      %bb1a4_13 = "braid.add"(%bb1a4_0, %bb1a4_2) : (i64, i64) -> i64
      %bb1a4_12 = "braid.zext"(%bb1a4_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1a4_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb1a8] : () -> ()
    ^bb1a8:  // 0x101ec
      %bb1a8_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb1a8_0 = "braid.zext"(%bb1a8_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a8_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1a8_2 = "braid.zext"(%bb1a8_3) {bits = 32 : i64} : (i64) -> i64
      %bb1a8_13 = "braid.add"(%bb1a8_0, %bb1a8_2) : (i64, i64) -> i64
      %bb1a8_12 = "braid.zext"(%bb1a8_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1a8_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb1ac] : () -> ()
    ^bb1ac:  // 0x101f0
      %bb1ac_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bb1ac_0 = "braid.zext"(%bb1ac_1) {bits = 32 : i64} : (i64) -> i64
      %bb1ac_3 = "braid.get"() {reg = "x22"} : () -> i64
      %bb1ac_2 = "braid.zext"(%bb1ac_3) {bits = 32 : i64} : (i64) -> i64
      %bb1ac_12 = "braid.xor"(%bb1ac_0, %bb1ac_2) : (i64, i64) -> i64
      "braid.set"(%bb1ac_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb1b0] : () -> ()
    ^bb1b0:  // 0x101f4
      %bb1b0_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb1b0_0 = "braid.zext"(%bb1b0_1) {bits = 32 : i64} : (i64) -> i64
      %bb1b0_3 = "braid.get"() {reg = "x18"} : () -> i64
      %bb1b0_2 = "braid.zext"(%bb1b0_3) {bits = 32 : i64} : (i64) -> i64
      %bb1b0_12 = "braid.xor"(%bb1b0_0, %bb1b0_2) : (i64, i64) -> i64
      "braid.set"(%bb1b0_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb1b4] : () -> ()
    ^bb1b4:  // 0x101f8
      %bb1b4_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb1b4_0 = "braid.zext"(%bb1b4_1) {bits = 32 : i64} : (i64) -> i64
      %bb1b4_3 = "braid.get"() {reg = "x19"} : () -> i64
      %bb1b4_2 = "braid.zext"(%bb1b4_3) {bits = 32 : i64} : (i64) -> i64
      %bb1b4_13 = "braid.add"(%bb1b4_0, %bb1b4_2) : (i64, i64) -> i64
      %bb1b4_12 = "braid.zext"(%bb1b4_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1b4_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb1b8] : () -> ()
    ^bb1b8:  // 0x101fc
      %bb1b8_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1b8_0 = "braid.zext"(%bb1b8_1) {bits = 32 : i64} : (i64) -> i64
      %bb1b8_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb1b8_2 = "braid.zext"(%bb1b8_3) {bits = 32 : i64} : (i64) -> i64
      %bb1b8_12 = "braid.xor"(%bb1b8_0, %bb1b8_2) : (i64, i64) -> i64
      "braid.set"(%bb1b8_12) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb1bc] : () -> ()
    ^bb1bc:  // 0x10200
      %bb1bc_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb1bc_0 = "braid.zext"(%bb1bc_1) {bits = 32 : i64} : (i64) -> i64
      %bb1bc_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1bc_2 = "braid.zext"(%bb1bc_3) {bits = 32 : i64} : (i64) -> i64
      %bb1bc_12 = "braid.xor"(%bb1bc_0, %bb1bc_2) : (i64, i64) -> i64
      "braid.set"(%bb1bc_12) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb1c0] : () -> ()
    ^bb1c0:  // 0x10204
      %bb1c0_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1c0_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1c0_2 = "braid.zext"(%bb1c0_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c0_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1c0_4 = "braid.lshr"(%bb1c0_2, %bb1c0_3) : (i64, i64) -> i64
      %bb1c0_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1c0_6 = "braid.shl"(%bb1c0_0, %bb1c0_5) : (i64, i64) -> i64
      %bb1c0_7 = "braid.or"(%bb1c0_4, %bb1c0_6) : (i64, i64) -> i64
      %bb1c0_9 = "braid.zext"(%bb1c0_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1c0_9) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb1c4] : () -> ()
    ^bb1c4:  // 0x10208
      %bb1c4_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb1c4_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb1c4_2 = "braid.zext"(%bb1c4_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c4_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1c4_4 = "braid.lshr"(%bb1c4_2, %bb1c4_3) : (i64, i64) -> i64
      %bb1c4_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1c4_6 = "braid.shl"(%bb1c4_0, %bb1c4_5) : (i64, i64) -> i64
      %bb1c4_7 = "braid.or"(%bb1c4_4, %bb1c4_6) : (i64, i64) -> i64
      %bb1c4_9 = "braid.zext"(%bb1c4_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1c4_9) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb1c8] : () -> ()
    ^bb1c8:  // 0x1020c
      %bb1c8_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb1c8_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb1c8_2 = "braid.zext"(%bb1c8_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c8_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1c8_4 = "braid.lshr"(%bb1c8_2, %bb1c8_3) : (i64, i64) -> i64
      %bb1c8_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1c8_6 = "braid.shl"(%bb1c8_0, %bb1c8_5) : (i64, i64) -> i64
      %bb1c8_7 = "braid.or"(%bb1c8_4, %bb1c8_6) : (i64, i64) -> i64
      %bb1c8_9 = "braid.zext"(%bb1c8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1c8_9) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb1cc] : () -> ()
    ^bb1cc:  // 0x10210
      %bb1cc_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb1cc_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb1cc_2 = "braid.zext"(%bb1cc_1) {bits = 32 : i64} : (i64) -> i64
      %bb1cc_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1cc_4 = "braid.lshr"(%bb1cc_2, %bb1cc_3) : (i64, i64) -> i64
      %bb1cc_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1cc_6 = "braid.shl"(%bb1cc_0, %bb1cc_5) : (i64, i64) -> i64
      %bb1cc_7 = "braid.or"(%bb1cc_4, %bb1cc_6) : (i64, i64) -> i64
      %bb1cc_9 = "braid.zext"(%bb1cc_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1cc_9) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb1d0] : () -> ()
    ^bb1d0:  // 0x10214
      %bb1d0_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb1d0_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d0_0 = "braid.eq"(%bb1d0_1, %bb1d0_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb1d0_0)[^bb4c, ^bb1d4] : (i64) -> ()
    ^bb1d4:  // 0x10218
      %bb1d4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d4_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d4_12 = "braid.or"(%bb1d4_0, %bb1d4_2) : (i64, i64) -> i64
      "braid.set"(%bb1d4_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1d8] : () -> ()
    ^bb1d8:  // 0x1021c
      %bb1d8_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1d8_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb1d8_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1d8_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1d8_5 = "braid.and"(%bb1d8_3, %bb1d8_4) : (i64, i64) -> i64
      %bb1d8_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d8_7 = "braid.eq"(%bb1d8_5, %bb1d8_6) : (i64, i64) -> i64
      "braid.guard"(%bb1d8_7) : (i64) -> ()
      %bb1d8_8 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb1d8_2 = "braid.add"(%bb1d8_3, %bb1d8_8) : (i64, i64) -> i64
      %bb1d8_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1d8_24 = "braid.add"(%bb1d8_2, %bb1d8_23) : (i64, i64) -> i64
      "braid.store"(%bb1d8_2, %bb1d8_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb1d8_24, %bb1d8_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1dc] : () -> ()
    ^bb1dc:  // 0x10220
      %bb1dc_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1dc_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1dc_3 = "braid.add"(%bb1dc_0, %bb1dc_2) : (i64, i64) -> i64
      "braid.set"(%bb1dc_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb1e0] : () -> ()
    ^bb1e0:  // 0x10224
      %bb1e0_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb1e0_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1e0_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1e0_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1e0_5 = "braid.and"(%bb1e0_3, %bb1e0_4) : (i64, i64) -> i64
      %bb1e0_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e0_7 = "braid.eq"(%bb1e0_5, %bb1e0_6) : (i64, i64) -> i64
      "braid.guard"(%bb1e0_7) : (i64) -> ()
      %bb1e0_8 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1e0_2 = "braid.add"(%bb1e0_3, %bb1e0_8) : (i64, i64) -> i64
      %bb1e0_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1e0_24 = "braid.add"(%bb1e0_2, %bb1e0_23) : (i64, i64) -> i64
      "braid.store"(%bb1e0_2, %bb1e0_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb1e0_24, %bb1e0_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1e4] : () -> ()
    ^bb1e4:  // 0x10228
      %bb1e4_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb1e4_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb1e4_2 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1e4_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1e4_4 = "braid.and"(%bb1e4_2, %bb1e4_3) : (i64, i64) -> i64
      %bb1e4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e4_6 = "braid.eq"(%bb1e4_4, %bb1e4_5) : (i64, i64) -> i64
      "braid.guard"(%bb1e4_6) : (i64) -> ()
      %bb1e4_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1e4_24 = "braid.add"(%bb1e4_2, %bb1e4_23) : (i64, i64) -> i64
      "braid.store"(%bb1e4_2, %bb1e4_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb1e4_24, %bb1e4_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1e8] : () -> ()
    ^bb1e8:  // 0x1022c
      %bb1e8_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb1e8_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb1e8_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1e8_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1e8_5 = "braid.and"(%bb1e8_3, %bb1e8_4) : (i64, i64) -> i64
      %bb1e8_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e8_7 = "braid.eq"(%bb1e8_5, %bb1e8_6) : (i64, i64) -> i64
      "braid.guard"(%bb1e8_7) : (i64) -> ()
      %bb1e8_8 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb1e8_2 = "braid.add"(%bb1e8_3, %bb1e8_8) : (i64, i64) -> i64
      %bb1e8_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1e8_24 = "braid.add"(%bb1e8_2, %bb1e8_23) : (i64, i64) -> i64
      "braid.store"(%bb1e8_2, %bb1e8_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb1e8_24, %bb1e8_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1ec] : () -> ()
    ^bb1ec:  // 0x10230
      %bb1ec_0 = "braid.get"() {reg = "x4"} : () -> i64
      %bb1ec_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb1ec_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1ec_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1ec_5 = "braid.and"(%bb1ec_3, %bb1ec_4) : (i64, i64) -> i64
      %bb1ec_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1ec_7 = "braid.eq"(%bb1ec_5, %bb1ec_6) : (i64, i64) -> i64
      "braid.guard"(%bb1ec_7) : (i64) -> ()
      %bb1ec_8 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb1ec_2 = "braid.add"(%bb1ec_3, %bb1ec_8) : (i64, i64) -> i64
      %bb1ec_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1ec_24 = "braid.add"(%bb1ec_2, %bb1ec_23) : (i64, i64) -> i64
      "braid.store"(%bb1ec_2, %bb1ec_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb1ec_24, %bb1ec_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1f0] : () -> ()
    ^bb1f0:  // 0x10234
      %bb1f0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb1f0_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1f0_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1f0_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1f0_5 = "braid.and"(%bb1f0_3, %bb1f0_4) : (i64, i64) -> i64
      %bb1f0_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1f0_7 = "braid.eq"(%bb1f0_5, %bb1f0_6) : (i64, i64) -> i64
      "braid.guard"(%bb1f0_7) : (i64) -> ()
      %bb1f0_8 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb1f0_2 = "braid.add"(%bb1f0_3, %bb1f0_8) : (i64, i64) -> i64
      %bb1f0_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1f0_24 = "braid.add"(%bb1f0_2, %bb1f0_23) : (i64, i64) -> i64
      "braid.store"(%bb1f0_2, %bb1f0_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb1f0_24, %bb1f0_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1f4] : () -> ()
    ^bb1f4:  // 0x10238
      %bb1f4_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb1f4_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb1f4_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1f4_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1f4_5 = "braid.and"(%bb1f4_3, %bb1f4_4) : (i64, i64) -> i64
      %bb1f4_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1f4_7 = "braid.eq"(%bb1f4_5, %bb1f4_6) : (i64, i64) -> i64
      "braid.guard"(%bb1f4_7) : (i64) -> ()
      %bb1f4_8 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1f4_2 = "braid.add"(%bb1f4_3, %bb1f4_8) : (i64, i64) -> i64
      %bb1f4_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1f4_24 = "braid.add"(%bb1f4_2, %bb1f4_23) : (i64, i64) -> i64
      "braid.store"(%bb1f4_2, %bb1f4_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb1f4_24, %bb1f4_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1f8] : () -> ()
    ^bb1f8:  // 0x1023c
      %bb1f8_0 = "braid.get"() {reg = "x3"} : () -> i64
      %bb1f8_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb1f8_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1f8_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1f8_5 = "braid.and"(%bb1f8_3, %bb1f8_4) : (i64, i64) -> i64
      %bb1f8_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1f8_7 = "braid.eq"(%bb1f8_5, %bb1f8_6) : (i64, i64) -> i64
      "braid.guard"(%bb1f8_7) : (i64) -> ()
      %bb1f8_8 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb1f8_2 = "braid.add"(%bb1f8_3, %bb1f8_8) : (i64, i64) -> i64
      %bb1f8_23 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1f8_24 = "braid.add"(%bb1f8_2, %bb1f8_23) : (i64, i64) -> i64
      "braid.store"(%bb1f8_2, %bb1f8_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid.store"(%bb1f8_24, %bb1f8_1) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1fc] : () -> ()
    ^bb1fc:  // 0x10240
      %bb1fc_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1fc_6 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1fc_0 = "braid.add"(%bb1fc_1, %bb1fc_6) : (i64, i64) -> i64
      %bb1fc_30 = "braid.load"(%bb1fc_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1fc_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb200] : () -> ()
    ^bb200:  // 0x10244
      %bb200_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb200_6 = "braid.get"() {reg = "x8"} : () -> i64
      %bb200_0 = "braid.add"(%bb200_1, %bb200_6) : (i64, i64) -> i64
      %bb200_30 = "braid.load"(%bb200_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb200_30) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb204] : () -> ()
    ^bb204:  // 0x10248
      %bb204_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb204_0 = "braid.zext"(%bb204_1) {bits = 32 : i64} : (i64) -> i64
      %bb204_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb204_2 = "braid.zext"(%bb204_3) {bits = 32 : i64} : (i64) -> i64
      %bb204_13 = "braid.add"(%bb204_0, %bb204_2) : (i64, i64) -> i64
      %bb204_12 = "braid.zext"(%bb204_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb204_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb208] : () -> ()
    ^bb208:  // 0x1024c
      %bb208_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb208_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb208_7 = "braid.get"() {reg = "x8"} : () -> i64
      %bb208_1 = "braid.add"(%bb208_2, %bb208_7) : (i64, i64) -> i64
      "braid.store"(%bb208_1, %bb208_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb20c] : () -> ()
    ^bb20c:  // 0x10250
      %bb20c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb20c_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb20c_3 = "braid.add"(%bb20c_0, %bb20c_2) : (i64, i64) -> i64
      "braid.set"(%bb20c_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb210] : () -> ()
    ^bb210:  // 0x10254
      %bb210_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb210_2 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb210_3 = "braid.sub"(%bb210_0, %bb210_2) : (i64, i64) -> i64
      %bb210_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb210_4 = "braid.slt"(%bb210_3, %bb210_8) : (i64, i64) -> i64
      %bb210_5 = "braid.eq"(%bb210_0, %bb210_2) : (i64, i64) -> i64
      %bb210_6 = "braid.ule"(%bb210_2, %bb210_0) : (i64, i64) -> i64
      %bb210_9 = "braid.xor"(%bb210_0, %bb210_2) : (i64, i64) -> i64
      %bb210_10 = "braid.xor"(%bb210_0, %bb210_3) : (i64, i64) -> i64
      %bb210_11 = "braid.and"(%bb210_9, %bb210_10) : (i64, i64) -> i64
      %bb210_7 = "braid.slt"(%bb210_11, %bb210_8) : (i64, i64) -> i64
      "braid.setf"(%bb210_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb210_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb210_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb210_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb214] : () -> ()
    ^bb214:  // 0x10258
      %bb214_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb214_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb214_0 = "braid.eq"(%bb214_1, %bb214_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb214_0)[^bb1fc, ^bb218] : (i64) -> ()
    ^bb218:  // 0x1025c
      %bb218_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb218_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb218_3 = "braid.and"(%bb218_1, %bb218_2) : (i64, i64) -> i64
      %bb218_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb218_5 = "braid.eq"(%bb218_3, %bb218_4) : (i64, i64) -> i64
      "braid.guard"(%bb218_5) : (i64) -> ()
      %bb218_6 = "braid.const"() {value = 80 : i64} : () -> i64
      %bb218_0 = "braid.add"(%bb218_1, %bb218_6) : (i64, i64) -> i64
      %bb218_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb218_22 = "braid.add"(%bb218_0, %bb218_21) : (i64, i64) -> i64
      %bb218_23 = "braid.load"(%bb218_0) {bytes = 8 : i64} : (i64) -> i64
      %bb218_26 = "braid.load"(%bb218_22) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb218_23) {reg = "x20"} : (i64) -> ()
      "braid.set"(%bb218_26) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb21c] : () -> ()
    ^bb21c:  // 0x10260
      %bb21c_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb21c_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb21c_3 = "braid.and"(%bb21c_1, %bb21c_2) : (i64, i64) -> i64
      %bb21c_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb21c_5 = "braid.eq"(%bb21c_3, %bb21c_4) : (i64, i64) -> i64
      "braid.guard"(%bb21c_5) : (i64) -> ()
      %bb21c_6 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb21c_0 = "braid.add"(%bb21c_1, %bb21c_6) : (i64, i64) -> i64
      %bb21c_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb21c_22 = "braid.add"(%bb21c_0, %bb21c_21) : (i64, i64) -> i64
      %bb21c_23 = "braid.load"(%bb21c_0) {bytes = 8 : i64} : (i64) -> i64
      %bb21c_26 = "braid.load"(%bb21c_22) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb21c_23) {reg = "x22"} : (i64) -> ()
      "braid.set"(%bb21c_26) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb220] : () -> ()
    ^bb220:  // 0x10264
      %bb220_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb220_2 = "braid.const"() {value = 96 : i64} : () -> i64
      %bb220_3 = "braid.add"(%bb220_0, %bb220_2) : (i64, i64) -> i64
      "braid.set"(%bb220_3) {reg = "sp"} : (i64) -> ()
      "braid_cf.br"()[^bb224] : () -> ()
    ^bb224:  // 0x10268
      %bb224_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb224_0) : (i64) -> ()
  }) {sym_name = "chacha20_block", entry = 65604 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
