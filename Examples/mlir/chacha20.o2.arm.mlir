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
      %bb0_0 = "braid.get"() {reg = "x23"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "sp"} : () -> i64
      %bb0_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb0_4 = "braid.and"(%bb0_2, %bb0_3) : (i64, i64) -> i64
      %bb0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_6 = "braid.eq"(%bb0_4, %bb0_5) : (i64, i64) -> i64
      "braid.guard"(%bb0_6) : (i64) -> ()
      %bb0_7 = "braid.const"() {value = -48 : i64} : () -> i64
      %bb0_1 = "braid.add"(%bb0_2, %bb0_7) : (i64, i64) -> i64
      "braid.set"(%bb0_1) {reg = "sp"} : (i64) -> ()
      "braid.store"(%bb0_1, %bb0_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10048
      %bb4_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb4_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb4_22 = "braid.add"(%bb4_0, %bb4_21) : (i64, i64) -> i64
      %bb4_23 = "braid.load"(%bb4_0) {bytes = 4 : i64} : (i64) -> i64
      %bb4_26 = "braid.load"(%bb4_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb4_23) {reg = "x7"} : (i64) -> ()
      "braid.set"(%bb4_26) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1004c
      %bb8_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb8_6 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8_0 = "braid.add"(%bb8_1, %bb8_6) : (i64, i64) -> i64
      %bb8_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb8_22 = "braid.add"(%bb8_0, %bb8_21) : (i64, i64) -> i64
      %bb8_23 = "braid.load"(%bb8_0) {bytes = 4 : i64} : (i64) -> i64
      %bb8_26 = "braid.load"(%bb8_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb8_23) {reg = "x5"} : (i64) -> ()
      "braid.set"(%bb8_26) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10050
      %bbc_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bbc_6 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbc_0 = "braid.add"(%bbc_1, %bbc_6) : (i64, i64) -> i64
      %bbc_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbc_22 = "braid.add"(%bbc_0, %bbc_21) : (i64, i64) -> i64
      %bbc_23 = "braid.load"(%bbc_0) {bytes = 4 : i64} : (i64) -> i64
      %bbc_26 = "braid.load"(%bbc_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbc_23) {reg = "x4"} : (i64) -> ()
      "braid.set"(%bbc_26) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10054
      %bb10_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb10_6 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb10_0 = "braid.add"(%bb10_1, %bb10_6) : (i64, i64) -> i64
      %bb10_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb10_22 = "braid.add"(%bb10_0, %bb10_21) : (i64, i64) -> i64
      %bb10_23 = "braid.load"(%bb10_0) {bytes = 4 : i64} : (i64) -> i64
      %bb10_26 = "braid.load"(%bb10_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb10_23) {reg = "x2"} : (i64) -> ()
      "braid.set"(%bb10_26) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10058
      %bb14_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb14_6 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb14_0 = "braid.add"(%bb14_1, %bb14_6) : (i64, i64) -> i64
      %bb14_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb14_22 = "braid.add"(%bb14_0, %bb14_21) : (i64, i64) -> i64
      %bb14_23 = "braid.load"(%bb14_0) {bytes = 4 : i64} : (i64) -> i64
      %bb14_26 = "braid.load"(%bb14_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb14_23) {reg = "x15"} : (i64) -> ()
      "braid.set"(%bb14_26) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x1005c
      %bb18_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb18_6 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb18_0 = "braid.add"(%bb18_1, %bb18_6) : (i64, i64) -> i64
      %bb18_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb18_22 = "braid.add"(%bb18_0, %bb18_21) : (i64, i64) -> i64
      %bb18_23 = "braid.load"(%bb18_0) {bytes = 4 : i64} : (i64) -> i64
      %bb18_26 = "braid.load"(%bb18_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb18_23) {reg = "x11"} : (i64) -> ()
      "braid.set"(%bb18_26) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10060
      %bb1c_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb1c_6 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb1c_0 = "braid.add"(%bb1c_1, %bb1c_6) : (i64, i64) -> i64
      %bb1c_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1c_22 = "braid.add"(%bb1c_0, %bb1c_21) : (i64, i64) -> i64
      %bb1c_23 = "braid.load"(%bb1c_0) {bytes = 4 : i64} : (i64) -> i64
      %bb1c_26 = "braid.load"(%bb1c_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1c_23) {reg = "x14"} : (i64) -> ()
      "braid.set"(%bb1c_26) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10064
      %bb20_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb20_6 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb20_0 = "braid.add"(%bb20_1, %bb20_6) : (i64, i64) -> i64
      %bb20_21 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb20_22 = "braid.add"(%bb20_0, %bb20_21) : (i64, i64) -> i64
      %bb20_23 = "braid.load"(%bb20_0) {bytes = 4 : i64} : (i64) -> i64
      %bb20_26 = "braid.load"(%bb20_22) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb20_23) {reg = "x12"} : (i64) -> ()
      "braid.set"(%bb20_26) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10068
      %bb24_0 = "braid.const"() {value = 10 : i64} : () -> i64
      "braid.set"(%bb24_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x1006c
      %bb28_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "x21"} : () -> i64
      %bb28_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb28_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb28_5 = "braid.and"(%bb28_3, %bb28_4) : (i64, i64) -> i64
      %bb28_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_7 = "braid.eq"(%bb28_5, %bb28_6) : (i64, i64) -> i64
      "braid.guard"(%bb28_7) : (i64) -> ()
      %bb28_8 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb28_2 = "braid.add"(%bb28_3, %bb28_8) : (i64, i64) -> i64
      %bb28_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb28_24 = "braid.add"(%bb28_2, %bb28_23) : (i64, i64) -> i64
      "braid.store"(%bb28_2, %bb28_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb28_24, %bb28_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x10070
      %bb2c_0 = "braid.get"() {reg = "x20"} : () -> i64
      %bb2c_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb2c_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb2c_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb2c_5 = "braid.and"(%bb2c_3, %bb2c_4) : (i64, i64) -> i64
      %bb2c_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_7 = "braid.eq"(%bb2c_5, %bb2c_6) : (i64, i64) -> i64
      "braid.guard"(%bb2c_7) : (i64) -> ()
      %bb2c_8 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb2c_2 = "braid.add"(%bb2c_3, %bb2c_8) : (i64, i64) -> i64
      %bb2c_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb2c_24 = "braid.add"(%bb2c_2, %bb2c_23) : (i64, i64) -> i64
      "braid.store"(%bb2c_2, %bb2c_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb2c_24, %bb2c_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10074
      %bb30_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb30_0 = "braid.zext"(%bb30_1) {bits = 32 : i64} : (i64) -> i64
      %bb30_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bb30_2 = "braid.zext"(%bb30_3) {bits = 32 : i64} : (i64) -> i64
      %bb30_13 = "braid.add"(%bb30_0, %bb30_2) : (i64, i64) -> i64
      %bb30_12 = "braid.zext"(%bb30_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb30_12) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10078
      %bb34_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb34_0 = "braid.zext"(%bb34_1) {bits = 32 : i64} : (i64) -> i64
      %bb34_3 = "braid.get"() {reg = "x4"} : () -> i64
      %bb34_2 = "braid.zext"(%bb34_3) {bits = 32 : i64} : (i64) -> i64
      %bb34_13 = "braid.add"(%bb34_0, %bb34_2) : (i64, i64) -> i64
      %bb34_12 = "braid.zext"(%bb34_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb34_12) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x1007c
      %bb38_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb38_0 = "braid.zext"(%bb38_1) {bits = 32 : i64} : (i64) -> i64
      %bb38_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bb38_2 = "braid.zext"(%bb38_3) {bits = 32 : i64} : (i64) -> i64
      %bb38_13 = "braid.add"(%bb38_0, %bb38_2) : (i64, i64) -> i64
      %bb38_12 = "braid.zext"(%bb38_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb38_12) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x10080
      %bb3c_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb3c_0 = "braid.zext"(%bb3c_1) {bits = 32 : i64} : (i64) -> i64
      %bb3c_3 = "braid.get"() {reg = "x16"} : () -> i64
      %bb3c_2 = "braid.zext"(%bb3c_3) {bits = 32 : i64} : (i64) -> i64
      %bb3c_13 = "braid.add"(%bb3c_0, %bb3c_2) : (i64, i64) -> i64
      %bb3c_12 = "braid.zext"(%bb3c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb3c_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x10084
      %bb40_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb40_0 = "braid.zext"(%bb40_1) {bits = 32 : i64} : (i64) -> i64
      %bb40_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bb40_2 = "braid.zext"(%bb40_3) {bits = 32 : i64} : (i64) -> i64
      %bb40_12 = "braid.xor"(%bb40_0, %bb40_2) : (i64, i64) -> i64
      "braid.set"(%bb40_12) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10088
      %bb44_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb44_0 = "braid.zext"(%bb44_1) {bits = 32 : i64} : (i64) -> i64
      %bb44_3 = "braid.get"() {reg = "x7"} : () -> i64
      %bb44_2 = "braid.zext"(%bb44_3) {bits = 32 : i64} : (i64) -> i64
      %bb44_12 = "braid.xor"(%bb44_0, %bb44_2) : (i64, i64) -> i64
      "braid.set"(%bb44_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x1008c
      %bb48_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb48_0 = "braid.zext"(%bb48_1) {bits = 32 : i64} : (i64) -> i64
      %bb48_3 = "braid.get"() {reg = "x5"} : () -> i64
      %bb48_2 = "braid.zext"(%bb48_3) {bits = 32 : i64} : (i64) -> i64
      %bb48_12 = "braid.xor"(%bb48_0, %bb48_2) : (i64, i64) -> i64
      "braid.set"(%bb48_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x10090
      %bb4c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb4c_0 = "braid.zext"(%bb4c_1) {bits = 32 : i64} : (i64) -> i64
      %bb4c_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bb4c_2 = "braid.zext"(%bb4c_3) {bits = 32 : i64} : (i64) -> i64
      %bb4c_12 = "braid.xor"(%bb4c_0, %bb4c_2) : (i64, i64) -> i64
      "braid.set"(%bb4c_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x10094
      %bb50_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb50_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb50_2 = "braid.zext"(%bb50_1) {bits = 32 : i64} : (i64) -> i64
      %bb50_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb50_4 = "braid.lshr"(%bb50_2, %bb50_3) : (i64, i64) -> i64
      %bb50_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb50_6 = "braid.shl"(%bb50_0, %bb50_5) : (i64, i64) -> i64
      %bb50_7 = "braid.or"(%bb50_4, %bb50_6) : (i64, i64) -> i64
      %bb50_9 = "braid.zext"(%bb50_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb50_9) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x10098
      %bb54_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb54_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb54_2 = "braid.zext"(%bb54_1) {bits = 32 : i64} : (i64) -> i64
      %bb54_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb54_4 = "braid.lshr"(%bb54_2, %bb54_3) : (i64, i64) -> i64
      %bb54_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb54_6 = "braid.shl"(%bb54_0, %bb54_5) : (i64, i64) -> i64
      %bb54_7 = "braid.or"(%bb54_4, %bb54_6) : (i64, i64) -> i64
      %bb54_9 = "braid.zext"(%bb54_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb54_9) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x1009c
      %bb58_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb58_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb58_2 = "braid.zext"(%bb58_1) {bits = 32 : i64} : (i64) -> i64
      %bb58_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb58_4 = "braid.lshr"(%bb58_2, %bb58_3) : (i64, i64) -> i64
      %bb58_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb58_6 = "braid.shl"(%bb58_0, %bb58_5) : (i64, i64) -> i64
      %bb58_7 = "braid.or"(%bb58_4, %bb58_6) : (i64, i64) -> i64
      %bb58_9 = "braid.zext"(%bb58_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb58_9) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x100a0
      %bb5c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb5c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb5c_2 = "braid.zext"(%bb5c_1) {bits = 32 : i64} : (i64) -> i64
      %bb5c_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb5c_4 = "braid.lshr"(%bb5c_2, %bb5c_3) : (i64, i64) -> i64
      %bb5c_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb5c_6 = "braid.shl"(%bb5c_0, %bb5c_5) : (i64, i64) -> i64
      %bb5c_7 = "braid.or"(%bb5c_4, %bb5c_6) : (i64, i64) -> i64
      %bb5c_9 = "braid.zext"(%bb5c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb5c_9) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x100a4
      %bb60_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb60_0 = "braid.zext"(%bb60_1) {bits = 32 : i64} : (i64) -> i64
      %bb60_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb60_2 = "braid.zext"(%bb60_3) {bits = 32 : i64} : (i64) -> i64
      %bb60_13 = "braid.add"(%bb60_0, %bb60_2) : (i64, i64) -> i64
      %bb60_12 = "braid.zext"(%bb60_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb60_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x100a8
      %bb64_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb64_0 = "braid.zext"(%bb64_1) {bits = 32 : i64} : (i64) -> i64
      %bb64_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb64_8 = "braid.sub"(%bb64_0, %bb64_2) : (i64, i64) -> i64
      %bb64_3 = "braid.zext"(%bb64_8) {bits = 32 : i64} : (i64) -> i64
      %bb64_9 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb64_10 = "braid.sext"(%bb64_3) {bits = 32 : i64} : (i64) -> i64
      %bb64_4 = "braid.slt"(%bb64_10, %bb64_9) : (i64, i64) -> i64
      %bb64_5 = "braid.eq"(%bb64_0, %bb64_2) : (i64, i64) -> i64
      %bb64_6 = "braid.ule"(%bb64_2, %bb64_0) : (i64, i64) -> i64
      %bb64_11 = "braid.xor"(%bb64_0, %bb64_2) : (i64, i64) -> i64
      %bb64_12 = "braid.xor"(%bb64_0, %bb64_3) : (i64, i64) -> i64
      %bb64_13 = "braid.and"(%bb64_11, %bb64_12) : (i64, i64) -> i64
      %bb64_14 = "braid.sext"(%bb64_13) {bits = 32 : i64} : (i64) -> i64
      %bb64_7 = "braid.slt"(%bb64_14, %bb64_9) : (i64, i64) -> i64
      "braid.setf"(%bb64_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb64_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb64_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb64_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb64_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x100ac
      %bb68_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb68_0 = "braid.zext"(%bb68_1) {bits = 32 : i64} : (i64) -> i64
      %bb68_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bb68_2 = "braid.zext"(%bb68_3) {bits = 32 : i64} : (i64) -> i64
      %bb68_13 = "braid.add"(%bb68_0, %bb68_2) : (i64, i64) -> i64
      %bb68_12 = "braid.zext"(%bb68_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb68_12) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x100b0
      %bb6c_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb6c_0 = "braid.zext"(%bb6c_1) {bits = 32 : i64} : (i64) -> i64
      %bb6c_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bb6c_2 = "braid.zext"(%bb6c_3) {bits = 32 : i64} : (i64) -> i64
      %bb6c_13 = "braid.add"(%bb6c_0, %bb6c_2) : (i64, i64) -> i64
      %bb6c_12 = "braid.zext"(%bb6c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb6c_12) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x100b4
      %bb70_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb70_0 = "braid.zext"(%bb70_1) {bits = 32 : i64} : (i64) -> i64
      %bb70_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bb70_2 = "braid.zext"(%bb70_3) {bits = 32 : i64} : (i64) -> i64
      %bb70_12 = "braid.xor"(%bb70_0, %bb70_2) : (i64, i64) -> i64
      "braid.set"(%bb70_12) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x100b8
      %bb74_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb74_0 = "braid.zext"(%bb74_1) {bits = 32 : i64} : (i64) -> i64
      %bb74_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb74_2 = "braid.zext"(%bb74_3) {bits = 32 : i64} : (i64) -> i64
      %bb74_13 = "braid.add"(%bb74_0, %bb74_2) : (i64, i64) -> i64
      %bb74_12 = "braid.zext"(%bb74_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb74_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x100bc
      %bb78_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb78_0 = "braid.zext"(%bb78_1) {bits = 32 : i64} : (i64) -> i64
      %bb78_3 = "braid.get"() {reg = "x4"} : () -> i64
      %bb78_2 = "braid.zext"(%bb78_3) {bits = 32 : i64} : (i64) -> i64
      %bb78_12 = "braid.xor"(%bb78_0, %bb78_2) : (i64, i64) -> i64
      "braid.set"(%bb78_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x100c0
      %bb7c_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb7c_0 = "braid.zext"(%bb7c_1) {bits = 32 : i64} : (i64) -> i64
      %bb7c_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bb7c_2 = "braid.zext"(%bb7c_3) {bits = 32 : i64} : (i64) -> i64
      %bb7c_12 = "braid.xor"(%bb7c_0, %bb7c_2) : (i64, i64) -> i64
      "braid.set"(%bb7c_12) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x100c4
      %bb80_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb80_0 = "braid.zext"(%bb80_1) {bits = 32 : i64} : (i64) -> i64
      %bb80_3 = "braid.get"() {reg = "x16"} : () -> i64
      %bb80_2 = "braid.zext"(%bb80_3) {bits = 32 : i64} : (i64) -> i64
      %bb80_12 = "braid.xor"(%bb80_0, %bb80_2) : (i64, i64) -> i64
      "braid.set"(%bb80_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x100c8
      %bb84_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb84_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb84_2 = "braid.zext"(%bb84_1) {bits = 32 : i64} : (i64) -> i64
      %bb84_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb84_4 = "braid.lshr"(%bb84_2, %bb84_3) : (i64, i64) -> i64
      %bb84_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb84_6 = "braid.shl"(%bb84_0, %bb84_5) : (i64, i64) -> i64
      %bb84_7 = "braid.or"(%bb84_4, %bb84_6) : (i64, i64) -> i64
      %bb84_9 = "braid.zext"(%bb84_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb84_9) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x100cc
      %bb88_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb88_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb88_2 = "braid.zext"(%bb88_1) {bits = 32 : i64} : (i64) -> i64
      %bb88_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb88_4 = "braid.lshr"(%bb88_2, %bb88_3) : (i64, i64) -> i64
      %bb88_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb88_6 = "braid.shl"(%bb88_0, %bb88_5) : (i64, i64) -> i64
      %bb88_7 = "braid.or"(%bb88_4, %bb88_6) : (i64, i64) -> i64
      %bb88_9 = "braid.zext"(%bb88_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb88_9) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x100d0
      %bb8c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb8c_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb8c_2 = "braid.zext"(%bb8c_1) {bits = 32 : i64} : (i64) -> i64
      %bb8c_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb8c_4 = "braid.lshr"(%bb8c_2, %bb8c_3) : (i64, i64) -> i64
      %bb8c_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb8c_6 = "braid.shl"(%bb8c_0, %bb8c_5) : (i64, i64) -> i64
      %bb8c_7 = "braid.or"(%bb8c_4, %bb8c_6) : (i64, i64) -> i64
      %bb8c_9 = "braid.zext"(%bb8c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb8c_9) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x100d4
      %bb90_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb90_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb90_2 = "braid.zext"(%bb90_1) {bits = 32 : i64} : (i64) -> i64
      %bb90_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb90_4 = "braid.lshr"(%bb90_2, %bb90_3) : (i64, i64) -> i64
      %bb90_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb90_6 = "braid.shl"(%bb90_0, %bb90_5) : (i64, i64) -> i64
      %bb90_7 = "braid.or"(%bb90_4, %bb90_6) : (i64, i64) -> i64
      %bb90_9 = "braid.zext"(%bb90_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb90_9) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x100d8
      %bb94_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bb94_0 = "braid.zext"(%bb94_1) {bits = 32 : i64} : (i64) -> i64
      %bb94_3 = "braid.get"() {reg = "x7"} : () -> i64
      %bb94_2 = "braid.zext"(%bb94_3) {bits = 32 : i64} : (i64) -> i64
      %bb94_13 = "braid.add"(%bb94_0, %bb94_2) : (i64, i64) -> i64
      %bb94_12 = "braid.zext"(%bb94_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb94_12) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x100dc
      %bb98_1 = "braid.get"() {reg = "x21"} : () -> i64
      %bb98_0 = "braid.zext"(%bb98_1) {bits = 32 : i64} : (i64) -> i64
      %bb98_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bb98_2 = "braid.zext"(%bb98_3) {bits = 32 : i64} : (i64) -> i64
      %bb98_13 = "braid.add"(%bb98_0, %bb98_2) : (i64, i64) -> i64
      %bb98_12 = "braid.zext"(%bb98_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb98_12) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x100e0
      %bb9c_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb9c_0 = "braid.zext"(%bb9c_1) {bits = 32 : i64} : (i64) -> i64
      %bb9c_3 = "braid.get"() {reg = "x5"} : () -> i64
      %bb9c_2 = "braid.zext"(%bb9c_3) {bits = 32 : i64} : (i64) -> i64
      %bb9c_13 = "braid.add"(%bb9c_0, %bb9c_2) : (i64, i64) -> i64
      %bb9c_12 = "braid.zext"(%bb9c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb9c_12) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x100e4
      %bba0_1 = "braid.get"() {reg = "x22"} : () -> i64
      %bba0_0 = "braid.zext"(%bba0_1) {bits = 32 : i64} : (i64) -> i64
      %bba0_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bba0_2 = "braid.zext"(%bba0_3) {bits = 32 : i64} : (i64) -> i64
      %bba0_13 = "braid.add"(%bba0_0, %bba0_2) : (i64, i64) -> i64
      %bba0_12 = "braid.zext"(%bba0_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bba0_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bba4] : () -> ()
    ^bba4:  // 0x100e8
      %bba4_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bba4_0 = "braid.zext"(%bba4_1) {bits = 32 : i64} : (i64) -> i64
      %bba4_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bba4_2 = "braid.zext"(%bba4_3) {bits = 32 : i64} : (i64) -> i64
      %bba4_12 = "braid.xor"(%bba4_0, %bba4_2) : (i64, i64) -> i64
      "braid.set"(%bba4_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x100ec
      %bba8_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bba8_0 = "braid.zext"(%bba8_1) {bits = 32 : i64} : (i64) -> i64
      %bba8_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bba8_2 = "braid.zext"(%bba8_3) {bits = 32 : i64} : (i64) -> i64
      %bba8_12 = "braid.xor"(%bba8_0, %bba8_2) : (i64, i64) -> i64
      "braid.set"(%bba8_12) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x100f0
      %bbac_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bbac_0 = "braid.zext"(%bbac_1) {bits = 32 : i64} : (i64) -> i64
      %bbac_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bbac_2 = "braid.zext"(%bbac_3) {bits = 32 : i64} : (i64) -> i64
      %bbac_12 = "braid.xor"(%bbac_0, %bbac_2) : (i64, i64) -> i64
      "braid.set"(%bbac_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x100f4
      %bbb0_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bbb0_0 = "braid.zext"(%bbb0_1) {bits = 32 : i64} : (i64) -> i64
      %bbb0_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bbb0_2 = "braid.zext"(%bbb0_3) {bits = 32 : i64} : (i64) -> i64
      %bbb0_12 = "braid.xor"(%bbb0_0, %bbb0_2) : (i64, i64) -> i64
      "braid.set"(%bbb0_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x100f8
      %bbb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbb4_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bbb4_2 = "braid.zext"(%bbb4_1) {bits = 32 : i64} : (i64) -> i64
      %bbb4_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbb4_4 = "braid.lshr"(%bbb4_2, %bbb4_3) : (i64, i64) -> i64
      %bbb4_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbb4_6 = "braid.shl"(%bbb4_0, %bbb4_5) : (i64, i64) -> i64
      %bbb4_7 = "braid.or"(%bbb4_4, %bbb4_6) : (i64, i64) -> i64
      %bbb4_9 = "braid.zext"(%bbb4_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbb4_9) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x100fc
      %bbb8_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbb8_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bbb8_2 = "braid.zext"(%bbb8_1) {bits = 32 : i64} : (i64) -> i64
      %bbb8_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbb8_4 = "braid.lshr"(%bbb8_2, %bbb8_3) : (i64, i64) -> i64
      %bbb8_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbb8_6 = "braid.shl"(%bbb8_0, %bbb8_5) : (i64, i64) -> i64
      %bbb8_7 = "braid.or"(%bbb8_4, %bbb8_6) : (i64, i64) -> i64
      %bbb8_9 = "braid.zext"(%bbb8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbb8_9) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x10100
      %bbbc_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bbbc_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bbbc_2 = "braid.zext"(%bbbc_1) {bits = 32 : i64} : (i64) -> i64
      %bbbc_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbbc_4 = "braid.lshr"(%bbbc_2, %bbbc_3) : (i64, i64) -> i64
      %bbbc_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbbc_6 = "braid.shl"(%bbbc_0, %bbbc_5) : (i64, i64) -> i64
      %bbbc_7 = "braid.or"(%bbbc_4, %bbbc_6) : (i64, i64) -> i64
      %bbbc_9 = "braid.zext"(%bbbc_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbbc_9) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bbc0:  // 0x10104
      %bbc0_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bbc0_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bbc0_2 = "braid.zext"(%bbc0_1) {bits = 32 : i64} : (i64) -> i64
      %bbc0_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbc0_4 = "braid.lshr"(%bbc0_2, %bbc0_3) : (i64, i64) -> i64
      %bbc0_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbc0_6 = "braid.shl"(%bbc0_0, %bbc0_5) : (i64, i64) -> i64
      %bbc0_7 = "braid.or"(%bbc0_4, %bbc0_6) : (i64, i64) -> i64
      %bbc0_9 = "braid.zext"(%bbc0_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbc0_9) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x10108
      %bbc4_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bbc4_0 = "braid.zext"(%bbc4_1) {bits = 32 : i64} : (i64) -> i64
      %bbc4_3 = "braid.get"() {reg = "x19"} : () -> i64
      %bbc4_2 = "braid.zext"(%bbc4_3) {bits = 32 : i64} : (i64) -> i64
      %bbc4_13 = "braid.add"(%bbc4_0, %bbc4_2) : (i64, i64) -> i64
      %bbc4_12 = "braid.zext"(%bbc4_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbc4_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x1010c
      %bbc8_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bbc8_0 = "braid.zext"(%bbc8_1) {bits = 32 : i64} : (i64) -> i64
      %bbc8_3 = "braid.get"() {reg = "x18"} : () -> i64
      %bbc8_2 = "braid.zext"(%bbc8_3) {bits = 32 : i64} : (i64) -> i64
      %bbc8_13 = "braid.add"(%bbc8_0, %bbc8_2) : (i64, i64) -> i64
      %bbc8_12 = "braid.zext"(%bbc8_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbc8_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x10110
      %bbcc_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bbcc_0 = "braid.zext"(%bbcc_1) {bits = 32 : i64} : (i64) -> i64
      %bbcc_3 = "braid.get"() {reg = "x20"} : () -> i64
      %bbcc_2 = "braid.zext"(%bbcc_3) {bits = 32 : i64} : (i64) -> i64
      %bbcc_13 = "braid.add"(%bbcc_0, %bbcc_2) : (i64, i64) -> i64
      %bbcc_12 = "braid.zext"(%bbcc_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbcc_12) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x10114
      %bbd0_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bbd0_0 = "braid.zext"(%bbd0_1) {bits = 32 : i64} : (i64) -> i64
      %bbd0_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bbd0_2 = "braid.zext"(%bbd0_3) {bits = 32 : i64} : (i64) -> i64
      %bbd0_13 = "braid.add"(%bbd0_0, %bbd0_2) : (i64, i64) -> i64
      %bbd0_12 = "braid.zext"(%bbd0_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd0_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x10118
      %bbd4_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bbd4_0 = "braid.zext"(%bbd4_1) {bits = 32 : i64} : (i64) -> i64
      %bbd4_3 = "braid.get"() {reg = "x4"} : () -> i64
      %bbd4_2 = "braid.zext"(%bbd4_3) {bits = 32 : i64} : (i64) -> i64
      %bbd4_12 = "braid.xor"(%bbd4_0, %bbd4_2) : (i64, i64) -> i64
      "braid.set"(%bbd4_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbd8] : () -> ()
    ^bbd8:  // 0x1011c
      %bbd8_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bbd8_0 = "braid.zext"(%bbd8_1) {bits = 32 : i64} : (i64) -> i64
      %bbd8_3 = "braid.get"() {reg = "x21"} : () -> i64
      %bbd8_2 = "braid.zext"(%bbd8_3) {bits = 32 : i64} : (i64) -> i64
      %bbd8_12 = "braid.xor"(%bbd8_0, %bbd8_2) : (i64, i64) -> i64
      "braid.set"(%bbd8_12) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x10120
      %bbdc_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bbdc_0 = "braid.zext"(%bbdc_1) {bits = 32 : i64} : (i64) -> i64
      %bbdc_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bbdc_2 = "braid.zext"(%bbdc_3) {bits = 32 : i64} : (i64) -> i64
      %bbdc_12 = "braid.xor"(%bbdc_0, %bbdc_2) : (i64, i64) -> i64
      "braid.set"(%bbdc_12) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bbe0] : () -> ()
    ^bbe0:  // 0x10124
      %bbe0_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bbe0_0 = "braid.zext"(%bbe0_1) {bits = 32 : i64} : (i64) -> i64
      %bbe0_3 = "braid.get"() {reg = "x22"} : () -> i64
      %bbe0_2 = "braid.zext"(%bbe0_3) {bits = 32 : i64} : (i64) -> i64
      %bbe0_12 = "braid.xor"(%bbe0_0, %bbe0_2) : (i64, i64) -> i64
      "braid.set"(%bbe0_12) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x10128
      %bbe4_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbe4_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bbe4_2 = "braid.zext"(%bbe4_1) {bits = 32 : i64} : (i64) -> i64
      %bbe4_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbe4_4 = "braid.lshr"(%bbe4_2, %bbe4_3) : (i64, i64) -> i64
      %bbe4_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbe4_6 = "braid.shl"(%bbe4_0, %bbe4_5) : (i64, i64) -> i64
      %bbe4_7 = "braid.or"(%bbe4_4, %bbe4_6) : (i64, i64) -> i64
      %bbe4_9 = "braid.zext"(%bbe4_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbe4_9) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bbe8] : () -> ()
    ^bbe8:  // 0x1012c
      %bbe8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbe8_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bbe8_2 = "braid.zext"(%bbe8_1) {bits = 32 : i64} : (i64) -> i64
      %bbe8_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbe8_4 = "braid.lshr"(%bbe8_2, %bbe8_3) : (i64, i64) -> i64
      %bbe8_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbe8_6 = "braid.shl"(%bbe8_0, %bbe8_5) : (i64, i64) -> i64
      %bbe8_7 = "braid.or"(%bbe8_4, %bbe8_6) : (i64, i64) -> i64
      %bbe8_9 = "braid.zext"(%bbe8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbe8_9) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bbec] : () -> ()
    ^bbec:  // 0x10130
      %bbec_0 = "braid.get"() {reg = "x4"} : () -> i64
      %bbec_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bbec_2 = "braid.zext"(%bbec_1) {bits = 32 : i64} : (i64) -> i64
      %bbec_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbec_4 = "braid.lshr"(%bbec_2, %bbec_3) : (i64, i64) -> i64
      %bbec_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbec_6 = "braid.shl"(%bbec_0, %bbec_5) : (i64, i64) -> i64
      %bbec_7 = "braid.or"(%bbec_4, %bbec_6) : (i64, i64) -> i64
      %bbec_9 = "braid.zext"(%bbec_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbec_9) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bbf0] : () -> ()
    ^bbf0:  // 0x10134
      %bbf0_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bbf0_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bbf0_2 = "braid.zext"(%bbf0_1) {bits = 32 : i64} : (i64) -> i64
      %bbf0_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbf0_4 = "braid.lshr"(%bbf0_2, %bbf0_3) : (i64, i64) -> i64
      %bbf0_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbf0_6 = "braid.shl"(%bbf0_0, %bbf0_5) : (i64, i64) -> i64
      %bbf0_7 = "braid.or"(%bbf0_4, %bbf0_6) : (i64, i64) -> i64
      %bbf0_9 = "braid.zext"(%bbf0_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbf0_9) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbf4] : () -> ()
    ^bbf4:  // 0x10138
      %bbf4_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bbf4_0 = "braid.zext"(%bbf4_1) {bits = 32 : i64} : (i64) -> i64
      %bbf4_3 = "braid.get"() {reg = "x7"} : () -> i64
      %bbf4_2 = "braid.zext"(%bbf4_3) {bits = 32 : i64} : (i64) -> i64
      %bbf4_13 = "braid.add"(%bbf4_0, %bbf4_2) : (i64, i64) -> i64
      %bbf4_12 = "braid.zext"(%bbf4_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbf4_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbf8] : () -> ()
    ^bbf8:  // 0x1013c
      %bbf8_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bbf8_0 = "braid.zext"(%bbf8_1) {bits = 32 : i64} : (i64) -> i64
      %bbf8_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bbf8_2 = "braid.zext"(%bbf8_3) {bits = 32 : i64} : (i64) -> i64
      %bbf8_13 = "braid.add"(%bbf8_0, %bbf8_2) : (i64, i64) -> i64
      %bbf8_12 = "braid.zext"(%bbf8_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbf8_12) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bbfc] : () -> ()
    ^bbfc:  // 0x10140
      %bbfc_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bbfc_0 = "braid.zext"(%bbfc_1) {bits = 32 : i64} : (i64) -> i64
      %bbfc_3 = "braid.get"() {reg = "x5"} : () -> i64
      %bbfc_2 = "braid.zext"(%bbfc_3) {bits = 32 : i64} : (i64) -> i64
      %bbfc_13 = "braid.add"(%bbfc_0, %bbfc_2) : (i64, i64) -> i64
      %bbfc_12 = "braid.zext"(%bbfc_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbfc_12) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb100:  // 0x10144
      %bb100_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb100_0 = "braid.zext"(%bb100_1) {bits = 32 : i64} : (i64) -> i64
      %bb100_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb100_2 = "braid.zext"(%bb100_3) {bits = 32 : i64} : (i64) -> i64
      %bb100_13 = "braid.add"(%bb100_0, %bb100_2) : (i64, i64) -> i64
      %bb100_12 = "braid.zext"(%bb100_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb100_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb104] : () -> ()
    ^bb104:  // 0x10148
      %bb104_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bb104_0 = "braid.zext"(%bb104_1) {bits = 32 : i64} : (i64) -> i64
      %bb104_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bb104_2 = "braid.zext"(%bb104_3) {bits = 32 : i64} : (i64) -> i64
      %bb104_12 = "braid.xor"(%bb104_0, %bb104_2) : (i64, i64) -> i64
      "braid.set"(%bb104_12) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x1014c
      %bb108_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb108_0 = "braid.zext"(%bb108_1) {bits = 32 : i64} : (i64) -> i64
      %bb108_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bb108_2 = "braid.zext"(%bb108_3) {bits = 32 : i64} : (i64) -> i64
      %bb108_12 = "braid.xor"(%bb108_0, %bb108_2) : (i64, i64) -> i64
      "braid.set"(%bb108_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb10c] : () -> ()
    ^bb10c:  // 0x10150
      %bb10c_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb10c_0 = "braid.zext"(%bb10c_1) {bits = 32 : i64} : (i64) -> i64
      %bb10c_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bb10c_2 = "braid.zext"(%bb10c_3) {bits = 32 : i64} : (i64) -> i64
      %bb10c_12 = "braid.xor"(%bb10c_0, %bb10c_2) : (i64, i64) -> i64
      "braid.set"(%bb10c_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb110] : () -> ()
    ^bb110:  // 0x10154
      %bb110_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb110_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb110_2 = "braid.zext"(%bb110_1) {bits = 32 : i64} : (i64) -> i64
      %bb110_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb110_4 = "braid.lshr"(%bb110_2, %bb110_3) : (i64, i64) -> i64
      %bb110_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb110_6 = "braid.shl"(%bb110_0, %bb110_5) : (i64, i64) -> i64
      %bb110_7 = "braid.or"(%bb110_4, %bb110_6) : (i64, i64) -> i64
      %bb110_9 = "braid.zext"(%bb110_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb110_9) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb114] : () -> ()
    ^bb114:  // 0x10158
      %bb114_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb114_0 = "braid.zext"(%bb114_1) {bits = 32 : i64} : (i64) -> i64
      %bb114_3 = "braid.get"() {reg = "x15"} : () -> i64
      %bb114_2 = "braid.zext"(%bb114_3) {bits = 32 : i64} : (i64) -> i64
      %bb114_12 = "braid.xor"(%bb114_0, %bb114_2) : (i64, i64) -> i64
      "braid.set"(%bb114_12) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x1015c
      %bb118_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb118_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb118_2 = "braid.zext"(%bb118_1) {bits = 32 : i64} : (i64) -> i64
      %bb118_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb118_4 = "braid.lshr"(%bb118_2, %bb118_3) : (i64, i64) -> i64
      %bb118_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb118_6 = "braid.shl"(%bb118_0, %bb118_5) : (i64, i64) -> i64
      %bb118_7 = "braid.or"(%bb118_4, %bb118_6) : (i64, i64) -> i64
      %bb118_9 = "braid.zext"(%bb118_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb118_9) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb11c] : () -> ()
    ^bb11c:  // 0x10160
      %bb11c_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb11c_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb11c_2 = "braid.zext"(%bb11c_1) {bits = 32 : i64} : (i64) -> i64
      %bb11c_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb11c_4 = "braid.lshr"(%bb11c_2, %bb11c_3) : (i64, i64) -> i64
      %bb11c_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb11c_6 = "braid.shl"(%bb11c_0, %bb11c_5) : (i64, i64) -> i64
      %bb11c_7 = "braid.or"(%bb11c_4, %bb11c_6) : (i64, i64) -> i64
      %bb11c_9 = "braid.zext"(%bb11c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb11c_9) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x10164
      %bb120_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb120_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb120_2 = "braid.zext"(%bb120_1) {bits = 32 : i64} : (i64) -> i64
      %bb120_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb120_4 = "braid.lshr"(%bb120_2, %bb120_3) : (i64, i64) -> i64
      %bb120_5 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb120_6 = "braid.shl"(%bb120_0, %bb120_5) : (i64, i64) -> i64
      %bb120_7 = "braid.or"(%bb120_4, %bb120_6) : (i64, i64) -> i64
      %bb120_9 = "braid.zext"(%bb120_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb120_9) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb124] : () -> ()
    ^bb124:  // 0x10168
      %bb124_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb124_0 = "braid.zext"(%bb124_1) {bits = 32 : i64} : (i64) -> i64
      %bb124_3 = "braid.get"() {reg = "x16"} : () -> i64
      %bb124_2 = "braid.zext"(%bb124_3) {bits = 32 : i64} : (i64) -> i64
      %bb124_13 = "braid.add"(%bb124_0, %bb124_2) : (i64, i64) -> i64
      %bb124_12 = "braid.zext"(%bb124_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb124_12) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb128] : () -> ()
    ^bb128:  // 0x1016c
      %bb128_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb128_0 = "braid.zext"(%bb128_1) {bits = 32 : i64} : (i64) -> i64
      %bb128_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bb128_2 = "braid.zext"(%bb128_3) {bits = 32 : i64} : (i64) -> i64
      %bb128_13 = "braid.add"(%bb128_0, %bb128_2) : (i64, i64) -> i64
      %bb128_12 = "braid.zext"(%bb128_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb128_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bb12c] : () -> ()
    ^bb12c:  // 0x10170
      %bb12c_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb12c_0 = "braid.zext"(%bb12c_1) {bits = 32 : i64} : (i64) -> i64
      %bb12c_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb12c_2 = "braid.zext"(%bb12c_3) {bits = 32 : i64} : (i64) -> i64
      %bb12c_13 = "braid.add"(%bb12c_0, %bb12c_2) : (i64, i64) -> i64
      %bb12c_12 = "braid.zext"(%bb12c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb12c_12) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb130] : () -> ()
    ^bb130:  // 0x10174
      %bb130_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb130_0 = "braid.zext"(%bb130_1) {bits = 32 : i64} : (i64) -> i64
      %bb130_3 = "braid.get"() {reg = "x18"} : () -> i64
      %bb130_2 = "braid.zext"(%bb130_3) {bits = 32 : i64} : (i64) -> i64
      %bb130_12 = "braid.xor"(%bb130_0, %bb130_2) : (i64, i64) -> i64
      "braid.set"(%bb130_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb134:  // 0x10178
      %bb134_1 = "braid.get"() {reg = "x3"} : () -> i64
      %bb134_0 = "braid.zext"(%bb134_1) {bits = 32 : i64} : (i64) -> i64
      %bb134_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bb134_2 = "braid.zext"(%bb134_3) {bits = 32 : i64} : (i64) -> i64
      %bb134_12 = "braid.xor"(%bb134_0, %bb134_2) : (i64, i64) -> i64
      "braid.set"(%bb134_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb138] : () -> ()
    ^bb138:  // 0x1017c
      %bb138_1 = "braid.get"() {reg = "x21"} : () -> i64
      %bb138_0 = "braid.zext"(%bb138_1) {bits = 32 : i64} : (i64) -> i64
      %bb138_3 = "braid.get"() {reg = "x4"} : () -> i64
      %bb138_2 = "braid.zext"(%bb138_3) {bits = 32 : i64} : (i64) -> i64
      %bb138_12 = "braid.xor"(%bb138_0, %bb138_2) : (i64, i64) -> i64
      "braid.set"(%bb138_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb13c] : () -> ()
    ^bb13c:  // 0x10180
      %bb13c_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb13c_0 = "braid.zext"(%bb13c_1) {bits = 32 : i64} : (i64) -> i64
      %bb13c_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb13c_2 = "braid.zext"(%bb13c_3) {bits = 32 : i64} : (i64) -> i64
      %bb13c_13 = "braid.add"(%bb13c_0, %bb13c_2) : (i64, i64) -> i64
      %bb13c_12 = "braid.zext"(%bb13c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb13c_12) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb140] : () -> ()
    ^bb140:  // 0x10184
      %bb140_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb140_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb140_2 = "braid.zext"(%bb140_1) {bits = 32 : i64} : (i64) -> i64
      %bb140_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb140_4 = "braid.lshr"(%bb140_2, %bb140_3) : (i64, i64) -> i64
      %bb140_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb140_6 = "braid.shl"(%bb140_0, %bb140_5) : (i64, i64) -> i64
      %bb140_7 = "braid.or"(%bb140_4, %bb140_6) : (i64, i64) -> i64
      %bb140_9 = "braid.zext"(%bb140_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb140_9) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bb144] : () -> ()
    ^bb144:  // 0x10188
      %bb144_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb144_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb144_2 = "braid.zext"(%bb144_1) {bits = 32 : i64} : (i64) -> i64
      %bb144_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb144_4 = "braid.lshr"(%bb144_2, %bb144_3) : (i64, i64) -> i64
      %bb144_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb144_6 = "braid.shl"(%bb144_0, %bb144_5) : (i64, i64) -> i64
      %bb144_7 = "braid.or"(%bb144_4, %bb144_6) : (i64, i64) -> i64
      %bb144_9 = "braid.zext"(%bb144_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb144_9) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb148] : () -> ()
    ^bb148:  // 0x1018c
      %bb148_1 = "braid.get"() {reg = "x2"} : () -> i64
      %bb148_0 = "braid.zext"(%bb148_1) {bits = 32 : i64} : (i64) -> i64
      %bb148_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb148_2 = "braid.zext"(%bb148_3) {bits = 32 : i64} : (i64) -> i64
      %bb148_12 = "braid.xor"(%bb148_0, %bb148_2) : (i64, i64) -> i64
      "braid.set"(%bb148_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb14c] : () -> ()
    ^bb14c:  // 0x10190
      %bb14c_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb14c_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb14c_2 = "braid.zext"(%bb14c_1) {bits = 32 : i64} : (i64) -> i64
      %bb14c_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb14c_4 = "braid.lshr"(%bb14c_2, %bb14c_3) : (i64, i64) -> i64
      %bb14c_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb14c_6 = "braid.shl"(%bb14c_0, %bb14c_5) : (i64, i64) -> i64
      %bb14c_7 = "braid.or"(%bb14c_4, %bb14c_6) : (i64, i64) -> i64
      %bb14c_9 = "braid.zext"(%bb14c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb14c_9) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb150] : () -> ()
    ^bb150:  // 0x10194
      %bb150_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb150_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb150_2 = "braid.zext"(%bb150_1) {bits = 32 : i64} : (i64) -> i64
      %bb150_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb150_4 = "braid.lshr"(%bb150_2, %bb150_3) : (i64, i64) -> i64
      %bb150_5 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb150_6 = "braid.shl"(%bb150_0, %bb150_5) : (i64, i64) -> i64
      %bb150_7 = "braid.or"(%bb150_4, %bb150_6) : (i64, i64) -> i64
      %bb150_9 = "braid.zext"(%bb150_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb150_9) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb154] : () -> ()
    ^bb154:  // 0x10198
      %bb154_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bb154_0 = "braid.zext"(%bb154_1) {bits = 32 : i64} : (i64) -> i64
      %bb154_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bb154_2 = "braid.zext"(%bb154_3) {bits = 32 : i64} : (i64) -> i64
      %bb154_13 = "braid.add"(%bb154_0, %bb154_2) : (i64, i64) -> i64
      %bb154_12 = "braid.zext"(%bb154_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb154_12) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb158] : () -> ()
    ^bb158:  // 0x1019c
      %bb158_1 = "braid.get"() {reg = "x22"} : () -> i64
      %bb158_0 = "braid.zext"(%bb158_1) {bits = 32 : i64} : (i64) -> i64
      %bb158_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bb158_2 = "braid.zext"(%bb158_3) {bits = 32 : i64} : (i64) -> i64
      %bb158_13 = "braid.add"(%bb158_0, %bb158_2) : (i64, i64) -> i64
      %bb158_12 = "braid.zext"(%bb158_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb158_12) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb15c] : () -> ()
    ^bb15c:  // 0x101a0
      %bb15c_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb15c_0 = "braid.zext"(%bb15c_1) {bits = 32 : i64} : (i64) -> i64
      %bb15c_3 = "braid.get"() {reg = "x5"} : () -> i64
      %bb15c_2 = "braid.zext"(%bb15c_3) {bits = 32 : i64} : (i64) -> i64
      %bb15c_13 = "braid.add"(%bb15c_0, %bb15c_2) : (i64, i64) -> i64
      %bb15c_12 = "braid.zext"(%bb15c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb15c_12) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb160] : () -> ()
    ^bb160:  // 0x101a4
      %bb160_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb160_0 = "braid.zext"(%bb160_1) {bits = 32 : i64} : (i64) -> i64
      %bb160_3 = "braid.get"() {reg = "x19"} : () -> i64
      %bb160_2 = "braid.zext"(%bb160_3) {bits = 32 : i64} : (i64) -> i64
      %bb160_12 = "braid.xor"(%bb160_0, %bb160_2) : (i64, i64) -> i64
      "braid.set"(%bb160_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb164] : () -> ()
    ^bb164:  // 0x101a8
      %bb164_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bb164_0 = "braid.zext"(%bb164_1) {bits = 32 : i64} : (i64) -> i64
      %bb164_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb164_2 = "braid.zext"(%bb164_3) {bits = 32 : i64} : (i64) -> i64
      %bb164_13 = "braid.add"(%bb164_0, %bb164_2) : (i64, i64) -> i64
      %bb164_12 = "braid.zext"(%bb164_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb164_12) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb168] : () -> ()
    ^bb168:  // 0x101ac
      %bb168_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb168_0 = "braid.zext"(%bb168_1) {bits = 32 : i64} : (i64) -> i64
      %bb168_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bb168_2 = "braid.zext"(%bb168_3) {bits = 32 : i64} : (i64) -> i64
      %bb168_12 = "braid.xor"(%bb168_0, %bb168_2) : (i64, i64) -> i64
      "braid.set"(%bb168_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb16c] : () -> ()
    ^bb16c:  // 0x101b0
      %bb16c_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb16c_0 = "braid.zext"(%bb16c_1) {bits = 32 : i64} : (i64) -> i64
      %bb16c_3 = "braid.get"() {reg = "x20"} : () -> i64
      %bb16c_2 = "braid.zext"(%bb16c_3) {bits = 32 : i64} : (i64) -> i64
      %bb16c_12 = "braid.xor"(%bb16c_0, %bb16c_2) : (i64, i64) -> i64
      "braid.set"(%bb16c_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb170] : () -> ()
    ^bb170:  // 0x101b4
      %bb170_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb170_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb170_2 = "braid.zext"(%bb170_1) {bits = 32 : i64} : (i64) -> i64
      %bb170_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb170_4 = "braid.lshr"(%bb170_2, %bb170_3) : (i64, i64) -> i64
      %bb170_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb170_6 = "braid.shl"(%bb170_0, %bb170_5) : (i64, i64) -> i64
      %bb170_7 = "braid.or"(%bb170_4, %bb170_6) : (i64, i64) -> i64
      %bb170_9 = "braid.zext"(%bb170_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb170_9) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb174] : () -> ()
    ^bb174:  // 0x101b8
      %bb174_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb174_0 = "braid.zext"(%bb174_1) {bits = 32 : i64} : (i64) -> i64
      %bb174_3 = "braid.get"() {reg = "x15"} : () -> i64
      %bb174_2 = "braid.zext"(%bb174_3) {bits = 32 : i64} : (i64) -> i64
      %bb174_12 = "braid.xor"(%bb174_0, %bb174_2) : (i64, i64) -> i64
      "braid.set"(%bb174_12) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb178] : () -> ()
    ^bb178:  // 0x101bc
      %bb178_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb178_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb178_2 = "braid.zext"(%bb178_1) {bits = 32 : i64} : (i64) -> i64
      %bb178_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb178_4 = "braid.lshr"(%bb178_2, %bb178_3) : (i64, i64) -> i64
      %bb178_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb178_6 = "braid.shl"(%bb178_0, %bb178_5) : (i64, i64) -> i64
      %bb178_7 = "braid.or"(%bb178_4, %bb178_6) : (i64, i64) -> i64
      %bb178_9 = "braid.zext"(%bb178_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb178_9) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb17c] : () -> ()
    ^bb17c:  // 0x101c0
      %bb17c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb17c_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb17c_2 = "braid.zext"(%bb17c_1) {bits = 32 : i64} : (i64) -> i64
      %bb17c_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb17c_4 = "braid.lshr"(%bb17c_2, %bb17c_3) : (i64, i64) -> i64
      %bb17c_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb17c_6 = "braid.shl"(%bb17c_0, %bb17c_5) : (i64, i64) -> i64
      %bb17c_7 = "braid.or"(%bb17c_4, %bb17c_6) : (i64, i64) -> i64
      %bb17c_9 = "braid.zext"(%bb17c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb17c_9) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb180] : () -> ()
    ^bb180:  // 0x101c4
      %bb180_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb180_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb180_2 = "braid.zext"(%bb180_1) {bits = 32 : i64} : (i64) -> i64
      %bb180_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb180_4 = "braid.lshr"(%bb180_2, %bb180_3) : (i64, i64) -> i64
      %bb180_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb180_6 = "braid.shl"(%bb180_0, %bb180_5) : (i64, i64) -> i64
      %bb180_7 = "braid.or"(%bb180_4, %bb180_6) : (i64, i64) -> i64
      %bb180_9 = "braid.zext"(%bb180_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb180_9) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb184] : () -> ()
    ^bb184:  // 0x101c8
      %bb184_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb184_0 = "braid.zext"(%bb184_1) {bits = 32 : i64} : (i64) -> i64
      %bb184_3 = "braid.get"() {reg = "x16"} : () -> i64
      %bb184_2 = "braid.zext"(%bb184_3) {bits = 32 : i64} : (i64) -> i64
      %bb184_13 = "braid.add"(%bb184_0, %bb184_2) : (i64, i64) -> i64
      %bb184_12 = "braid.zext"(%bb184_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb184_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb188] : () -> ()
    ^bb188:  // 0x101cc
      %bb188_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb188_0 = "braid.zext"(%bb188_1) {bits = 32 : i64} : (i64) -> i64
      %bb188_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bb188_2 = "braid.zext"(%bb188_3) {bits = 32 : i64} : (i64) -> i64
      %bb188_13 = "braid.add"(%bb188_0, %bb188_2) : (i64, i64) -> i64
      %bb188_12 = "braid.zext"(%bb188_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb188_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb18c] : () -> ()
    ^bb18c:  // 0x101d0
      %bb18c_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb18c_0 = "braid.zext"(%bb18c_1) {bits = 32 : i64} : (i64) -> i64
      %bb18c_3 = "braid.get"() {reg = "x21"} : () -> i64
      %bb18c_2 = "braid.zext"(%bb18c_3) {bits = 32 : i64} : (i64) -> i64
      %bb18c_13 = "braid.add"(%bb18c_0, %bb18c_2) : (i64, i64) -> i64
      %bb18c_12 = "braid.zext"(%bb18c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb18c_12) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x101d4
      %bb190_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb190_0 = "braid.zext"(%bb190_1) {bits = 32 : i64} : (i64) -> i64
      %bb190_3 = "braid.get"() {reg = "x4"} : () -> i64
      %bb190_2 = "braid.zext"(%bb190_3) {bits = 32 : i64} : (i64) -> i64
      %bb190_12 = "braid.xor"(%bb190_0, %bb190_2) : (i64, i64) -> i64
      "braid.set"(%bb190_12) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb194] : () -> ()
    ^bb194:  // 0x101d8
      %bb194_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb194_0 = "braid.zext"(%bb194_1) {bits = 32 : i64} : (i64) -> i64
      %bb194_3 = "braid.get"() {reg = "x22"} : () -> i64
      %bb194_2 = "braid.zext"(%bb194_3) {bits = 32 : i64} : (i64) -> i64
      %bb194_12 = "braid.xor"(%bb194_0, %bb194_2) : (i64, i64) -> i64
      "braid.set"(%bb194_12) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bb198] : () -> ()
    ^bb198:  // 0x101dc
      %bb198_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb198_0 = "braid.zext"(%bb198_1) {bits = 32 : i64} : (i64) -> i64
      %bb198_3 = "braid.get"() {reg = "x18"} : () -> i64
      %bb198_2 = "braid.zext"(%bb198_3) {bits = 32 : i64} : (i64) -> i64
      %bb198_12 = "braid.xor"(%bb198_0, %bb198_2) : (i64, i64) -> i64
      "braid.set"(%bb198_12) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb19c] : () -> ()
    ^bb19c:  // 0x101e0
      %bb19c_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb19c_0 = "braid.zext"(%bb19c_1) {bits = 32 : i64} : (i64) -> i64
      %bb19c_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bb19c_2 = "braid.zext"(%bb19c_3) {bits = 32 : i64} : (i64) -> i64
      %bb19c_13 = "braid.add"(%bb19c_0, %bb19c_2) : (i64, i64) -> i64
      %bb19c_12 = "braid.zext"(%bb19c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb19c_12) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb1a0] : () -> ()
    ^bb1a0:  // 0x101e4
      %bb1a0_0 = "braid.get"() {reg = "x4"} : () -> i64
      %bb1a0_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bb1a0_2 = "braid.zext"(%bb1a0_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a0_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1a0_4 = "braid.lshr"(%bb1a0_2, %bb1a0_3) : (i64, i64) -> i64
      %bb1a0_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1a0_6 = "braid.shl"(%bb1a0_0, %bb1a0_5) : (i64, i64) -> i64
      %bb1a0_7 = "braid.or"(%bb1a0_4, %bb1a0_6) : (i64, i64) -> i64
      %bb1a0_9 = "braid.zext"(%bb1a0_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1a0_9) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb1a4] : () -> ()
    ^bb1a4:  // 0x101e8
      %bb1a4_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb1a4_0 = "braid.zext"(%bb1a4_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a4_3 = "braid.get"() {reg = "x23"} : () -> i64
      %bb1a4_2 = "braid.zext"(%bb1a4_3) {bits = 32 : i64} : (i64) -> i64
      %bb1a4_12 = "braid.xor"(%bb1a4_0, %bb1a4_2) : (i64, i64) -> i64
      "braid.set"(%bb1a4_12) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bb1a8] : () -> ()
    ^bb1a8:  // 0x101ec
      %bb1a8_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb1a8_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb1a8_2 = "braid.zext"(%bb1a8_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a8_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1a8_4 = "braid.lshr"(%bb1a8_2, %bb1a8_3) : (i64, i64) -> i64
      %bb1a8_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1a8_6 = "braid.shl"(%bb1a8_0, %bb1a8_5) : (i64, i64) -> i64
      %bb1a8_7 = "braid.or"(%bb1a8_4, %bb1a8_6) : (i64, i64) -> i64
      %bb1a8_9 = "braid.zext"(%bb1a8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1a8_9) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bb1ac] : () -> ()
    ^bb1ac:  // 0x101f0
      %bb1ac_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb1ac_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb1ac_2 = "braid.zext"(%bb1ac_1) {bits = 32 : i64} : (i64) -> i64
      %bb1ac_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1ac_4 = "braid.lshr"(%bb1ac_2, %bb1ac_3) : (i64, i64) -> i64
      %bb1ac_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1ac_6 = "braid.shl"(%bb1ac_0, %bb1ac_5) : (i64, i64) -> i64
      %bb1ac_7 = "braid.or"(%bb1ac_4, %bb1ac_6) : (i64, i64) -> i64
      %bb1ac_9 = "braid.zext"(%bb1ac_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1ac_9) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb1b0] : () -> ()
    ^bb1b0:  // 0x101f4
      %bb1b0_0 = "braid.get"() {reg = "x4"} : () -> i64
      %bb1b0_1 = "braid.get"() {reg = "x4"} : () -> i64
      %bb1b0_2 = "braid.zext"(%bb1b0_1) {bits = 32 : i64} : (i64) -> i64
      %bb1b0_3 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1b0_4 = "braid.lshr"(%bb1b0_2, %bb1b0_3) : (i64, i64) -> i64
      %bb1b0_5 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1b0_6 = "braid.shl"(%bb1b0_0, %bb1b0_5) : (i64, i64) -> i64
      %bb1b0_7 = "braid.or"(%bb1b0_4, %bb1b0_6) : (i64, i64) -> i64
      %bb1b0_9 = "braid.zext"(%bb1b0_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1b0_9) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bb1b4] : () -> ()
    ^bb1b4:  // 0x101f8
      %bb1b4_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb1b4_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b4_0 = "braid.eq"(%bb1b4_1, %bb1b4_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb1b4_0)[^bb30, ^bb1b8] : (i64) -> ()
    ^bb1b8:  // 0x101fc
      %bb1b8_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb1b8_30 = "braid.load"(%bb1b8_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1b8_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1bc] : () -> ()
    ^bb1bc:  // 0x10200
      %bb1bc_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1bc_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1bc_3 = "braid.and"(%bb1bc_1, %bb1bc_2) : (i64, i64) -> i64
      %bb1bc_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1bc_5 = "braid.eq"(%bb1bc_3, %bb1bc_4) : (i64, i64) -> i64
      "braid.guard"(%bb1bc_5) : (i64) -> ()
      %bb1bc_6 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb1bc_0 = "braid.add"(%bb1bc_1, %bb1bc_6) : (i64, i64) -> i64
      %bb1bc_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1bc_22 = "braid.add"(%bb1bc_0, %bb1bc_21) : (i64, i64) -> i64
      %bb1bc_23 = "braid.load"(%bb1bc_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1bc_26 = "braid.load"(%bb1bc_22) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb1bc_23) {reg = "x20"} : (i64) -> ()
      "braid.set"(%bb1bc_26) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb1c0] : () -> ()
    ^bb1c0:  // 0x10204
      %bb1c0_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1c0_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1c0_3 = "braid.and"(%bb1c0_1, %bb1c0_2) : (i64, i64) -> i64
      %bb1c0_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c0_5 = "braid.eq"(%bb1c0_3, %bb1c0_4) : (i64, i64) -> i64
      "braid.guard"(%bb1c0_5) : (i64) -> ()
      %bb1c0_6 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1c0_0 = "braid.add"(%bb1c0_1, %bb1c0_6) : (i64, i64) -> i64
      %bb1c0_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c0_22 = "braid.add"(%bb1c0_0, %bb1c0_21) : (i64, i64) -> i64
      %bb1c0_23 = "braid.load"(%bb1c0_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1c0_26 = "braid.load"(%bb1c0_22) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb1c0_23) {reg = "x22"} : (i64) -> ()
      "braid.set"(%bb1c0_26) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb1c4] : () -> ()
    ^bb1c4:  // 0x10208
      %bb1c4_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1c4_0 = "braid.zext"(%bb1c4_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c4_3 = "braid.get"() {reg = "x7"} : () -> i64
      %bb1c4_2 = "braid.zext"(%bb1c4_3) {bits = 32 : i64} : (i64) -> i64
      %bb1c4_13 = "braid.add"(%bb1c4_0, %bb1c4_2) : (i64, i64) -> i64
      %bb1c4_12 = "braid.zext"(%bb1c4_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1c4_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1c8] : () -> ()
    ^bb1c8:  // 0x1020c
      %bb1c8_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1c8_1 = "braid.get"() {reg = "x0"} : () -> i64
      "braid.store"(%bb1c8_1, %bb1c8_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1cc] : () -> ()
    ^bb1cc:  // 0x10210
      %bb1cc_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb1cc_6 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1cc_0 = "braid.add"(%bb1cc_1, %bb1cc_6) : (i64, i64) -> i64
      %bb1cc_30 = "braid.load"(%bb1cc_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1cc_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1d0] : () -> ()
    ^bb1d0:  // 0x10214
      %bb1d0_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1d0_0 = "braid.zext"(%bb1d0_1) {bits = 32 : i64} : (i64) -> i64
      %bb1d0_3 = "braid.get"() {reg = "x6"} : () -> i64
      %bb1d0_2 = "braid.zext"(%bb1d0_3) {bits = 32 : i64} : (i64) -> i64
      %bb1d0_13 = "braid.add"(%bb1d0_0, %bb1d0_2) : (i64, i64) -> i64
      %bb1d0_12 = "braid.zext"(%bb1d0_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1d0_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1d4] : () -> ()
    ^bb1d4:  // 0x10218
      %bb1d4_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1d4_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb1d4_7 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1d4_1 = "braid.add"(%bb1d4_2, %bb1d4_7) : (i64, i64) -> i64
      "braid.store"(%bb1d4_1, %bb1d4_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1d8] : () -> ()
    ^bb1d8:  // 0x1021c
      %bb1d8_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb1d8_6 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1d8_0 = "braid.add"(%bb1d8_1, %bb1d8_6) : (i64, i64) -> i64
      %bb1d8_30 = "braid.load"(%bb1d8_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1d8_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1dc] : () -> ()
    ^bb1dc:  // 0x10220
      %bb1dc_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1dc_0 = "braid.zext"(%bb1dc_1) {bits = 32 : i64} : (i64) -> i64
      %bb1dc_3 = "braid.get"() {reg = "x5"} : () -> i64
      %bb1dc_2 = "braid.zext"(%bb1dc_3) {bits = 32 : i64} : (i64) -> i64
      %bb1dc_13 = "braid.add"(%bb1dc_0, %bb1dc_2) : (i64, i64) -> i64
      %bb1dc_12 = "braid.zext"(%bb1dc_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1dc_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1e0] : () -> ()
    ^bb1e0:  // 0x10224
      %bb1e0_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1e0_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb1e0_7 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1e0_1 = "braid.add"(%bb1e0_2, %bb1e0_7) : (i64, i64) -> i64
      "braid.store"(%bb1e0_1, %bb1e0_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1e4] : () -> ()
    ^bb1e4:  // 0x10228
      %bb1e4_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb1e4_6 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb1e4_0 = "braid.add"(%bb1e4_1, %bb1e4_6) : (i64, i64) -> i64
      %bb1e4_30 = "braid.load"(%bb1e4_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1e4_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1e8] : () -> ()
    ^bb1e8:  // 0x1022c
      %bb1e8_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1e8_0 = "braid.zext"(%bb1e8_1) {bits = 32 : i64} : (i64) -> i64
      %bb1e8_3 = "braid.get"() {reg = "x17"} : () -> i64
      %bb1e8_2 = "braid.zext"(%bb1e8_3) {bits = 32 : i64} : (i64) -> i64
      %bb1e8_13 = "braid.add"(%bb1e8_0, %bb1e8_2) : (i64, i64) -> i64
      %bb1e8_12 = "braid.zext"(%bb1e8_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1e8_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1ec] : () -> ()
    ^bb1ec:  // 0x10230
      %bb1ec_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1ec_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb1ec_7 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb1ec_1 = "braid.add"(%bb1ec_2, %bb1ec_7) : (i64, i64) -> i64
      "braid.store"(%bb1ec_1, %bb1ec_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1f0] : () -> ()
    ^bb1f0:  // 0x10234
      %bb1f0_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb1f0_6 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1f0_0 = "braid.add"(%bb1f0_1, %bb1f0_6) : (i64, i64) -> i64
      %bb1f0_30 = "braid.load"(%bb1f0_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1f0_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1f4] : () -> ()
    ^bb1f4:  // 0x10238
      %bb1f4_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1f4_0 = "braid.zext"(%bb1f4_1) {bits = 32 : i64} : (i64) -> i64
      %bb1f4_3 = "braid.get"() {reg = "x4"} : () -> i64
      %bb1f4_2 = "braid.zext"(%bb1f4_3) {bits = 32 : i64} : (i64) -> i64
      %bb1f4_13 = "braid.add"(%bb1f4_0, %bb1f4_2) : (i64, i64) -> i64
      %bb1f4_12 = "braid.zext"(%bb1f4_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1f4_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1f8] : () -> ()
    ^bb1f8:  // 0x1023c
      %bb1f8_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1f8_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb1f8_7 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1f8_1 = "braid.add"(%bb1f8_2, %bb1f8_7) : (i64, i64) -> i64
      "braid.store"(%bb1f8_1, %bb1f8_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1fc] : () -> ()
    ^bb1fc:  // 0x10240
      %bb1fc_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb1fc_6 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb1fc_0 = "braid.add"(%bb1fc_1, %bb1fc_6) : (i64, i64) -> i64
      %bb1fc_30 = "braid.load"(%bb1fc_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1fc_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb200] : () -> ()
    ^bb200:  // 0x10244
      %bb200_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb200_0 = "braid.zext"(%bb200_1) {bits = 32 : i64} : (i64) -> i64
      %bb200_3 = "braid.get"() {reg = "x3"} : () -> i64
      %bb200_2 = "braid.zext"(%bb200_3) {bits = 32 : i64} : (i64) -> i64
      %bb200_13 = "braid.add"(%bb200_0, %bb200_2) : (i64, i64) -> i64
      %bb200_12 = "braid.zext"(%bb200_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb200_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb204] : () -> ()
    ^bb204:  // 0x10248
      %bb204_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb204_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb204_7 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb204_1 = "braid.add"(%bb204_2, %bb204_7) : (i64, i64) -> i64
      "braid.store"(%bb204_1, %bb204_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb208] : () -> ()
    ^bb208:  // 0x1024c
      %bb208_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb208_6 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb208_0 = "braid.add"(%bb208_1, %bb208_6) : (i64, i64) -> i64
      %bb208_30 = "braid.load"(%bb208_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb208_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb20c] : () -> ()
    ^bb20c:  // 0x10250
      %bb20c_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb20c_0 = "braid.zext"(%bb20c_1) {bits = 32 : i64} : (i64) -> i64
      %bb20c_3 = "braid.get"() {reg = "x2"} : () -> i64
      %bb20c_2 = "braid.zext"(%bb20c_3) {bits = 32 : i64} : (i64) -> i64
      %bb20c_13 = "braid.add"(%bb20c_0, %bb20c_2) : (i64, i64) -> i64
      %bb20c_12 = "braid.zext"(%bb20c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb20c_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb210] : () -> ()
    ^bb210:  // 0x10254
      %bb210_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb210_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb210_7 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb210_1 = "braid.add"(%bb210_2, %bb210_7) : (i64, i64) -> i64
      "braid.store"(%bb210_1, %bb210_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb214] : () -> ()
    ^bb214:  // 0x10258
      %bb214_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb214_6 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb214_0 = "braid.add"(%bb214_1, %bb214_6) : (i64, i64) -> i64
      %bb214_30 = "braid.load"(%bb214_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb214_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb218] : () -> ()
    ^bb218:  // 0x1025c
      %bb218_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb218_0 = "braid.zext"(%bb218_1) {bits = 32 : i64} : (i64) -> i64
      %bb218_3 = "braid.get"() {reg = "x16"} : () -> i64
      %bb218_2 = "braid.zext"(%bb218_3) {bits = 32 : i64} : (i64) -> i64
      %bb218_13 = "braid.add"(%bb218_0, %bb218_2) : (i64, i64) -> i64
      %bb218_12 = "braid.zext"(%bb218_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb218_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb21c] : () -> ()
    ^bb21c:  // 0x10260
      %bb21c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb21c_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb21c_7 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb21c_1 = "braid.add"(%bb21c_2, %bb21c_7) : (i64, i64) -> i64
      "braid.store"(%bb21c_1, %bb21c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb220] : () -> ()
    ^bb220:  // 0x10264
      %bb220_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb220_6 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb220_0 = "braid.add"(%bb220_1, %bb220_6) : (i64, i64) -> i64
      %bb220_30 = "braid.load"(%bb220_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb220_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb224] : () -> ()
    ^bb224:  // 0x10268
      %bb224_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb224_0 = "braid.zext"(%bb224_1) {bits = 32 : i64} : (i64) -> i64
      %bb224_3 = "braid.get"() {reg = "x15"} : () -> i64
      %bb224_2 = "braid.zext"(%bb224_3) {bits = 32 : i64} : (i64) -> i64
      %bb224_13 = "braid.add"(%bb224_0, %bb224_2) : (i64, i64) -> i64
      %bb224_12 = "braid.zext"(%bb224_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb224_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb228] : () -> ()
    ^bb228:  // 0x1026c
      %bb228_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb228_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb228_7 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb228_1 = "braid.add"(%bb228_2, %bb228_7) : (i64, i64) -> i64
      "braid.store"(%bb228_1, %bb228_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb22c] : () -> ()
    ^bb22c:  // 0x10270
      %bb22c_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb22c_6 = "braid.const"() {value = 36 : i64} : () -> i64
      %bb22c_0 = "braid.add"(%bb22c_1, %bb22c_6) : (i64, i64) -> i64
      %bb22c_30 = "braid.load"(%bb22c_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb22c_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb230] : () -> ()
    ^bb230:  // 0x10274
      %bb230_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb230_0 = "braid.zext"(%bb230_1) {bits = 32 : i64} : (i64) -> i64
      %bb230_3 = "braid.get"() {reg = "x18"} : () -> i64
      %bb230_2 = "braid.zext"(%bb230_3) {bits = 32 : i64} : (i64) -> i64
      %bb230_13 = "braid.add"(%bb230_0, %bb230_2) : (i64, i64) -> i64
      %bb230_12 = "braid.zext"(%bb230_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb230_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb234] : () -> ()
    ^bb234:  // 0x10278
      %bb234_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb234_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb234_7 = "braid.const"() {value = 36 : i64} : () -> i64
      %bb234_1 = "braid.add"(%bb234_2, %bb234_7) : (i64, i64) -> i64
      "braid.store"(%bb234_1, %bb234_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb238] : () -> ()
    ^bb238:  // 0x1027c
      %bb238_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb238_6 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb238_0 = "braid.add"(%bb238_1, %bb238_6) : (i64, i64) -> i64
      %bb238_30 = "braid.load"(%bb238_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb238_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb23c] : () -> ()
    ^bb23c:  // 0x10280
      %bb23c_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb23c_0 = "braid.zext"(%bb23c_1) {bits = 32 : i64} : (i64) -> i64
      %bb23c_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb23c_2 = "braid.zext"(%bb23c_3) {bits = 32 : i64} : (i64) -> i64
      %bb23c_13 = "braid.add"(%bb23c_0, %bb23c_2) : (i64, i64) -> i64
      %bb23c_12 = "braid.zext"(%bb23c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb23c_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb240] : () -> ()
    ^bb240:  // 0x10284
      %bb240_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb240_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb240_7 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb240_1 = "braid.add"(%bb240_2, %bb240_7) : (i64, i64) -> i64
      "braid.store"(%bb240_1, %bb240_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb244] : () -> ()
    ^bb244:  // 0x10288
      %bb244_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb244_6 = "braid.const"() {value = 44 : i64} : () -> i64
      %bb244_0 = "braid.add"(%bb244_1, %bb244_6) : (i64, i64) -> i64
      %bb244_30 = "braid.load"(%bb244_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb244_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb248] : () -> ()
    ^bb248:  // 0x1028c
      %bb248_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb248_0 = "braid.zext"(%bb248_1) {bits = 32 : i64} : (i64) -> i64
      %bb248_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb248_2 = "braid.zext"(%bb248_3) {bits = 32 : i64} : (i64) -> i64
      %bb248_13 = "braid.add"(%bb248_0, %bb248_2) : (i64, i64) -> i64
      %bb248_12 = "braid.zext"(%bb248_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb248_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb24c] : () -> ()
    ^bb24c:  // 0x10290
      %bb24c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb24c_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb24c_7 = "braid.const"() {value = 44 : i64} : () -> i64
      %bb24c_1 = "braid.add"(%bb24c_2, %bb24c_7) : (i64, i64) -> i64
      "braid.store"(%bb24c_1, %bb24c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb250] : () -> ()
    ^bb250:  // 0x10294
      %bb250_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb250_6 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb250_0 = "braid.add"(%bb250_1, %bb250_6) : (i64, i64) -> i64
      %bb250_30 = "braid.load"(%bb250_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb250_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb254] : () -> ()
    ^bb254:  // 0x10298
      %bb254_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb254_0 = "braid.zext"(%bb254_1) {bits = 32 : i64} : (i64) -> i64
      %bb254_3 = "braid.get"() {reg = "x14"} : () -> i64
      %bb254_2 = "braid.zext"(%bb254_3) {bits = 32 : i64} : (i64) -> i64
      %bb254_13 = "braid.add"(%bb254_0, %bb254_2) : (i64, i64) -> i64
      %bb254_12 = "braid.zext"(%bb254_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb254_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb258] : () -> ()
    ^bb258:  // 0x1029c
      %bb258_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb258_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb258_7 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb258_1 = "braid.add"(%bb258_2, %bb258_7) : (i64, i64) -> i64
      "braid.store"(%bb258_1, %bb258_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb25c] : () -> ()
    ^bb25c:  // 0x102a0
      %bb25c_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb25c_6 = "braid.const"() {value = 52 : i64} : () -> i64
      %bb25c_0 = "braid.add"(%bb25c_1, %bb25c_6) : (i64, i64) -> i64
      %bb25c_30 = "braid.load"(%bb25c_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb25c_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb260] : () -> ()
    ^bb260:  // 0x102a4
      %bb260_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb260_0 = "braid.zext"(%bb260_1) {bits = 32 : i64} : (i64) -> i64
      %bb260_3 = "braid.get"() {reg = "x13"} : () -> i64
      %bb260_2 = "braid.zext"(%bb260_3) {bits = 32 : i64} : (i64) -> i64
      %bb260_13 = "braid.add"(%bb260_0, %bb260_2) : (i64, i64) -> i64
      %bb260_12 = "braid.zext"(%bb260_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb260_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb264] : () -> ()
    ^bb264:  // 0x102a8
      %bb264_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb264_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb264_7 = "braid.const"() {value = 52 : i64} : () -> i64
      %bb264_1 = "braid.add"(%bb264_2, %bb264_7) : (i64, i64) -> i64
      "braid.store"(%bb264_1, %bb264_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb268] : () -> ()
    ^bb268:  // 0x102ac
      %bb268_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb268_6 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb268_0 = "braid.add"(%bb268_1, %bb268_6) : (i64, i64) -> i64
      %bb268_30 = "braid.load"(%bb268_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb268_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb26c] : () -> ()
    ^bb26c:  // 0x102b0
      %bb26c_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb26c_0 = "braid.zext"(%bb26c_1) {bits = 32 : i64} : (i64) -> i64
      %bb26c_3 = "braid.get"() {reg = "x12"} : () -> i64
      %bb26c_2 = "braid.zext"(%bb26c_3) {bits = 32 : i64} : (i64) -> i64
      %bb26c_13 = "braid.add"(%bb26c_0, %bb26c_2) : (i64, i64) -> i64
      %bb26c_12 = "braid.zext"(%bb26c_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb26c_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb270] : () -> ()
    ^bb270:  // 0x102b4
      %bb270_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb270_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb270_7 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb270_1 = "braid.add"(%bb270_2, %bb270_7) : (i64, i64) -> i64
      "braid.store"(%bb270_1, %bb270_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb274] : () -> ()
    ^bb274:  // 0x102b8
      %bb274_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb274_6 = "braid.const"() {value = 60 : i64} : () -> i64
      %bb274_0 = "braid.add"(%bb274_1, %bb274_6) : (i64, i64) -> i64
      %bb274_30 = "braid.load"(%bb274_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb274_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb278] : () -> ()
    ^bb278:  // 0x102bc
      %bb278_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb278_0 = "braid.zext"(%bb278_1) {bits = 32 : i64} : (i64) -> i64
      %bb278_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb278_2 = "braid.zext"(%bb278_3) {bits = 32 : i64} : (i64) -> i64
      %bb278_13 = "braid.add"(%bb278_0, %bb278_2) : (i64, i64) -> i64
      %bb278_12 = "braid.zext"(%bb278_13) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb278_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb27c] : () -> ()
    ^bb27c:  // 0x102c0
      %bb27c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb27c_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb27c_7 = "braid.const"() {value = 60 : i64} : () -> i64
      %bb27c_1 = "braid.add"(%bb27c_2, %bb27c_7) : (i64, i64) -> i64
      "braid.store"(%bb27c_1, %bb27c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb280] : () -> ()
    ^bb280:  // 0x102c4
      %bb280_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb280_1 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb280_2 = "braid.and"(%bb280_0, %bb280_1) : (i64, i64) -> i64
      %bb280_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb280_4 = "braid.eq"(%bb280_2, %bb280_3) : (i64, i64) -> i64
      "braid.guard"(%bb280_4) : (i64) -> ()
      %bb280_5 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb280_6 = "braid.add"(%bb280_0, %bb280_5) : (i64, i64) -> i64
      "braid.set"(%bb280_6) {reg = "sp"} : (i64) -> ()
      %bb280_30 = "braid.load"(%bb280_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb280_30) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb284] : () -> ()
    ^bb284:  // 0x102c8
      %bb284_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb284_0) : (i64) -> ()
  }) {sym_name = "chacha20_block", entry = 65604 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
