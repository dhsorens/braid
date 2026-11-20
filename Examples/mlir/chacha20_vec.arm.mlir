"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb0_21 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb0_22 = "braid.add"(%bb0_0, %bb0_21) : (i64, i64) -> i64
      %bb0_23 = "braid.load"(%bb0_0) {bytes = 8 : i64} : (i64) -> i64
      %bb0_25 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_26 = "braid.add"(%bb0_0, %bb0_25) : (i64, i64) -> i64
      %bb0_24 = "braid.load"(%bb0_26) {bytes = 8 : i64} : (i64) -> i64
      %bb0_27 = "braid.load"(%bb0_22) {bytes = 8 : i64} : (i64) -> i64
      %bb0_29 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_30 = "braid.add"(%bb0_22, %bb0_29) : (i64, i64) -> i64
      %bb0_28 = "braid.load"(%bb0_30) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb0_23) {reg = "v0.lo"} : (i64) -> ()
      "braid.set"(%bb0_24) {reg = "v0.hi"} : (i64) -> ()
      "braid.set"(%bb0_27) {reg = "v2.lo"} : (i64) -> ()
      "braid.set"(%bb0_28) {reg = "v2.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.const"() {value = 10 : i64} : () -> i64
      "braid.set"(%bb4_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb8_6 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb8_0 = "braid.add"(%bb8_1, %bb8_6) : (i64, i64) -> i64
      %bb8_21 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb8_22 = "braid.add"(%bb8_0, %bb8_21) : (i64, i64) -> i64
      %bb8_23 = "braid.load"(%bb8_0) {bytes = 8 : i64} : (i64) -> i64
      %bb8_25 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8_26 = "braid.add"(%bb8_0, %bb8_25) : (i64, i64) -> i64
      %bb8_24 = "braid.load"(%bb8_26) {bytes = 8 : i64} : (i64) -> i64
      %bb8_27 = "braid.load"(%bb8_22) {bytes = 8 : i64} : (i64) -> i64
      %bb8_29 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8_30 = "braid.add"(%bb8_22, %bb8_29) : (i64, i64) -> i64
      %bb8_28 = "braid.load"(%bb8_30) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb8_23) {reg = "v1.lo"} : (i64) -> ()
      "braid.set"(%bb8_24) {reg = "v1.hi"} : (i64) -> ()
      "braid.set"(%bb8_27) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb8_28) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bbc_1 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bbc_2 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bbc_3 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bbc_10 = "braid.or"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      %bbc_20 = "braid.or"(%bbc_1, %bbc_3) : (i64, i64) -> i64
      "braid.set"(%bbc_10) {reg = "v4.lo"} : (i64) -> ()
      "braid.set"(%bbc_20) {reg = "v4.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb10_2 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb10_3 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb10_10 = "braid.lanes"(%bb10_0, %bb10_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb10_20 = "braid.lanes"(%bb10_1, %bb10_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb10_10) {reg = "v4.lo"} : (i64) -> ()
      "braid.set"(%bb10_20) {reg = "v4.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10014
      %bb14_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb14_0 = "braid.zext"(%bb14_1) {bits = 32 : i64} : (i64) -> i64
      %bb14_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14_8 = "braid.sub"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      %bb14_3 = "braid.zext"(%bb14_8) {bits = 32 : i64} : (i64) -> i64
      %bb14_9 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_10 = "braid.sext"(%bb14_3) {bits = 32 : i64} : (i64) -> i64
      %bb14_4 = "braid.slt"(%bb14_10, %bb14_9) : (i64, i64) -> i64
      %bb14_5 = "braid.eq"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      %bb14_6 = "braid.ule"(%bb14_2, %bb14_0) : (i64, i64) -> i64
      %bb14_11 = "braid.xor"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      %bb14_12 = "braid.xor"(%bb14_0, %bb14_3) : (i64, i64) -> i64
      %bb14_13 = "braid.and"(%bb14_11, %bb14_12) : (i64, i64) -> i64
      %bb14_14 = "braid.sext"(%bb14_13) {bits = 32 : i64} : (i64) -> i64
      %bb14_7 = "braid.slt"(%bb14_14, %bb14_9) : (i64, i64) -> i64
      "braid.setf"(%bb14_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb14_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb14_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb14_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb14_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10018
      %bb18_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb18_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb18_2 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb18_3 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb18_10 = "braid.xor"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      %bb18_20 = "braid.xor"(%bb18_1, %bb18_3) : (i64, i64) -> i64
      "braid.set"(%bb18_10) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb18_20) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1001c
      %bb1c_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb1c_11 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1c_12 = "braid.lshr"(%bb1c_0, %bb1c_11) : (i64, i64) -> i64
      %bb1c_13 = "braid.const"() {value = 281470681808895 : i64} : () -> i64
      %bb1c_14 = "braid.and"(%bb1c_12, %bb1c_13) : (i64, i64) -> i64
      %bb1c_15 = "braid.shl"(%bb1c_0, %bb1c_11) : (i64, i64) -> i64
      %bb1c_16 = "braid.not"(%bb1c_13) : (i64) -> i64
      %bb1c_17 = "braid.and"(%bb1c_15, %bb1c_16) : (i64, i64) -> i64
      %bb1c_10 = "braid.or"(%bb1c_14, %bb1c_17) : (i64, i64) -> i64
      %bb1c_51 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1c_52 = "braid.lshr"(%bb1c_1, %bb1c_51) : (i64, i64) -> i64
      %bb1c_53 = "braid.const"() {value = 281470681808895 : i64} : () -> i64
      %bb1c_54 = "braid.and"(%bb1c_52, %bb1c_53) : (i64, i64) -> i64
      %bb1c_55 = "braid.shl"(%bb1c_1, %bb1c_51) : (i64, i64) -> i64
      %bb1c_56 = "braid.not"(%bb1c_53) : (i64) -> i64
      %bb1c_57 = "braid.and"(%bb1c_55, %bb1c_56) : (i64, i64) -> i64
      %bb1c_50 = "braid.or"(%bb1c_54, %bb1c_57) : (i64, i64) -> i64
      "braid.set"(%bb1c_10) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb1c_50) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10020
      %bb20_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb20_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb20_2 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb20_3 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb20_10 = "braid.lanes"(%bb20_0, %bb20_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb20_20 = "braid.lanes"(%bb20_1, %bb20_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb20_10) {reg = "v1.lo"} : (i64) -> ()
      "braid.set"(%bb20_20) {reg = "v1.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10024
      %bb24_0 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb24_1 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb24_2 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb24_3 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb24_10 = "braid.xor"(%bb24_0, %bb24_2) : (i64, i64) -> i64
      %bb24_20 = "braid.xor"(%bb24_1, %bb24_3) : (i64, i64) -> i64
      "braid.set"(%bb24_10) {reg = "v2.lo"} : (i64) -> ()
      "braid.set"(%bb24_20) {reg = "v2.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10028
      %bb28_0 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb28_11 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb28_12 = "braid.shl"(%bb28_0, %bb28_11) : (i64, i64) -> i64
      %bb28_13 = "braid.const"() {value = -17587891081216 : i64} : () -> i64
      %bb28_10 = "braid.and"(%bb28_12, %bb28_13) : (i64, i64) -> i64
      %bb28_21 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb28_22 = "braid.shl"(%bb28_1, %bb28_21) : (i64, i64) -> i64
      %bb28_23 = "braid.const"() {value = -17587891081216 : i64} : () -> i64
      %bb28_20 = "braid.and"(%bb28_22, %bb28_23) : (i64, i64) -> i64
      "braid.set"(%bb28_10) {reg = "v5.lo"} : (i64) -> ()
      "braid.set"(%bb28_20) {reg = "v5.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x1002c
      %bb2c_0 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb2c_1 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb2c_2 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb2c_3 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb2c_11 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb2c_12 = "braid.lshr"(%bb2c_0, %bb2c_11) : (i64, i64) -> i64
      %bb2c_13 = "braid.const"() {value = 17587891081215 : i64} : () -> i64
      %bb2c_14 = "braid.and"(%bb2c_12, %bb2c_13) : (i64, i64) -> i64
      %bb2c_10 = "braid.lanes"(%bb2c_2, %bb2c_14) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb2c_21 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb2c_22 = "braid.lshr"(%bb2c_1, %bb2c_21) : (i64, i64) -> i64
      %bb2c_23 = "braid.const"() {value = 17587891081215 : i64} : () -> i64
      %bb2c_24 = "braid.and"(%bb2c_22, %bb2c_23) : (i64, i64) -> i64
      %bb2c_20 = "braid.lanes"(%bb2c_3, %bb2c_24) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb2c_10) {reg = "v5.lo"} : (i64) -> ()
      "braid.set"(%bb2c_20) {reg = "v5.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10030
      %bb30_0 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb30_1 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb30_2 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb30_3 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb30_10 = "braid.lanes"(%bb30_0, %bb30_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb30_20 = "braid.lanes"(%bb30_1, %bb30_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb30_10) {reg = "v2.lo"} : (i64) -> ()
      "braid.set"(%bb30_20) {reg = "v2.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10034
      %bb34_0 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb34_1 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb34_2 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb34_3 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb34_10 = "braid.xor"(%bb34_0, %bb34_2) : (i64, i64) -> i64
      %bb34_20 = "braid.xor"(%bb34_1, %bb34_3) : (i64, i64) -> i64
      "braid.set"(%bb34_10) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb34_20) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x10038
      %bb38_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb38_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb38_11 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb38_12 = "braid.shl"(%bb38_0, %bb38_11) : (i64, i64) -> i64
      %bb38_13 = "braid.const"() {value = -1095216660736 : i64} : () -> i64
      %bb38_10 = "braid.and"(%bb38_12, %bb38_13) : (i64, i64) -> i64
      %bb38_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb38_22 = "braid.shl"(%bb38_1, %bb38_21) : (i64, i64) -> i64
      %bb38_23 = "braid.const"() {value = -1095216660736 : i64} : () -> i64
      %bb38_20 = "braid.and"(%bb38_22, %bb38_23) : (i64, i64) -> i64
      "braid.set"(%bb38_10) {reg = "v4.lo"} : (i64) -> ()
      "braid.set"(%bb38_20) {reg = "v4.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x1003c
      %bb3c_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb3c_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb3c_2 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb3c_3 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb3c_11 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb3c_12 = "braid.lshr"(%bb3c_0, %bb3c_11) : (i64, i64) -> i64
      %bb3c_13 = "braid.const"() {value = 1095216660735 : i64} : () -> i64
      %bb3c_14 = "braid.and"(%bb3c_12, %bb3c_13) : (i64, i64) -> i64
      %bb3c_10 = "braid.lanes"(%bb3c_2, %bb3c_14) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb3c_21 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb3c_22 = "braid.lshr"(%bb3c_1, %bb3c_21) : (i64, i64) -> i64
      %bb3c_23 = "braid.const"() {value = 1095216660735 : i64} : () -> i64
      %bb3c_24 = "braid.and"(%bb3c_22, %bb3c_23) : (i64, i64) -> i64
      %bb3c_20 = "braid.lanes"(%bb3c_3, %bb3c_24) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb3c_10) {reg = "v4.lo"} : (i64) -> ()
      "braid.set"(%bb3c_20) {reg = "v4.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x10040
      %bb40_0 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb40_1 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb40_2 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb40_3 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb40_10 = "braid.lanes"(%bb40_0, %bb40_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb40_20 = "braid.lanes"(%bb40_1, %bb40_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb40_10) {reg = "v1.lo"} : (i64) -> ()
      "braid.set"(%bb40_20) {reg = "v1.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10044
      %bb44_0 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb44_1 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb44_2 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb44_3 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb44_11 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb44_12 = "braid.lshr"(%bb44_1, %bb44_11) : (i64, i64) -> i64
      %bb44_13 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb44_14 = "braid.shl"(%bb44_2, %bb44_13) : (i64, i64) -> i64
      %bb44_10 = "braid.or"(%bb44_12, %bb44_14) : (i64, i64) -> i64
      %bb44_21 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb44_22 = "braid.lshr"(%bb44_2, %bb44_21) : (i64, i64) -> i64
      %bb44_23 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb44_24 = "braid.shl"(%bb44_3, %bb44_23) : (i64, i64) -> i64
      %bb44_20 = "braid.or"(%bb44_22, %bb44_24) : (i64, i64) -> i64
      "braid.set"(%bb44_10) {reg = "v4.lo"} : (i64) -> ()
      "braid.set"(%bb44_20) {reg = "v4.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x10048
      %bb48_0 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb48_1 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb48_2 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb48_3 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb48_10 = "braid.xor"(%bb48_0, %bb48_2) : (i64, i64) -> i64
      %bb48_20 = "braid.xor"(%bb48_1, %bb48_3) : (i64, i64) -> i64
      "braid.set"(%bb48_10) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb48_20) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x1004c
      %bb4c_0 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb4c_1 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb4c_2 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb4c_3 = "braid.get"() {reg = "v1.hi"} : () -> i64
      "braid.set"(%bb4c_1) {reg = "v1.lo"} : (i64) -> ()
      "braid.set"(%bb4c_2) {reg = "v1.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x10050
      %bb50_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb50_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb50_11 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb50_12 = "braid.shl"(%bb50_0, %bb50_11) : (i64, i64) -> i64
      %bb50_13 = "braid.const"() {value = -545460846720 : i64} : () -> i64
      %bb50_10 = "braid.and"(%bb50_12, %bb50_13) : (i64, i64) -> i64
      %bb50_21 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb50_22 = "braid.shl"(%bb50_1, %bb50_21) : (i64, i64) -> i64
      %bb50_23 = "braid.const"() {value = -545460846720 : i64} : () -> i64
      %bb50_20 = "braid.and"(%bb50_22, %bb50_23) : (i64, i64) -> i64
      "braid.set"(%bb50_10) {reg = "v5.lo"} : (i64) -> ()
      "braid.set"(%bb50_20) {reg = "v5.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x10054
      %bb54_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb54_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb54_2 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb54_3 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb54_11 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb54_12 = "braid.lshr"(%bb54_0, %bb54_11) : (i64, i64) -> i64
      %bb54_13 = "braid.const"() {value = 545460846719 : i64} : () -> i64
      %bb54_14 = "braid.and"(%bb54_12, %bb54_13) : (i64, i64) -> i64
      %bb54_10 = "braid.lanes"(%bb54_2, %bb54_14) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb54_21 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb54_22 = "braid.lshr"(%bb54_1, %bb54_21) : (i64, i64) -> i64
      %bb54_23 = "braid.const"() {value = 545460846719 : i64} : () -> i64
      %bb54_24 = "braid.and"(%bb54_22, %bb54_23) : (i64, i64) -> i64
      %bb54_20 = "braid.lanes"(%bb54_3, %bb54_24) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb54_10) {reg = "v5.lo"} : (i64) -> ()
      "braid.set"(%bb54_20) {reg = "v5.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x10058
      %bb58_0 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb58_1 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb58_2 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb58_3 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb58_11 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb58_12 = "braid.lshr"(%bb58_0, %bb58_11) : (i64, i64) -> i64
      %bb58_13 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb58_14 = "braid.shl"(%bb58_1, %bb58_13) : (i64, i64) -> i64
      %bb58_10 = "braid.or"(%bb58_12, %bb58_14) : (i64, i64) -> i64
      %bb58_21 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb58_22 = "braid.lshr"(%bb58_1, %bb58_21) : (i64, i64) -> i64
      %bb58_23 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb58_24 = "braid.shl"(%bb58_2, %bb58_23) : (i64, i64) -> i64
      %bb58_20 = "braid.or"(%bb58_22, %bb58_24) : (i64, i64) -> i64
      "braid.set"(%bb58_10) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb58_20) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x1005c
      %bb5c_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb5c_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb5c_2 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb5c_3 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb5c_10 = "braid.lanes"(%bb5c_0, %bb5c_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb5c_20 = "braid.lanes"(%bb5c_1, %bb5c_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb5c_10) {reg = "v2.lo"} : (i64) -> ()
      "braid.set"(%bb5c_20) {reg = "v2.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x10060
      %bb60_0 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb60_1 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb60_2 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb60_3 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb60_10 = "braid.xor"(%bb60_0, %bb60_2) : (i64, i64) -> i64
      %bb60_20 = "braid.xor"(%bb60_1, %bb60_3) : (i64, i64) -> i64
      "braid.set"(%bb60_10) {reg = "v4.lo"} : (i64) -> ()
      "braid.set"(%bb60_20) {reg = "v4.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x10064
      %bb64_0 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb64_1 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb64_11 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb64_12 = "braid.lshr"(%bb64_0, %bb64_11) : (i64, i64) -> i64
      %bb64_13 = "braid.const"() {value = 281470681808895 : i64} : () -> i64
      %bb64_14 = "braid.and"(%bb64_12, %bb64_13) : (i64, i64) -> i64
      %bb64_15 = "braid.shl"(%bb64_0, %bb64_11) : (i64, i64) -> i64
      %bb64_16 = "braid.not"(%bb64_13) : (i64) -> i64
      %bb64_17 = "braid.and"(%bb64_15, %bb64_16) : (i64, i64) -> i64
      %bb64_10 = "braid.or"(%bb64_14, %bb64_17) : (i64, i64) -> i64
      %bb64_51 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb64_52 = "braid.lshr"(%bb64_1, %bb64_51) : (i64, i64) -> i64
      %bb64_53 = "braid.const"() {value = 281470681808895 : i64} : () -> i64
      %bb64_54 = "braid.and"(%bb64_52, %bb64_53) : (i64, i64) -> i64
      %bb64_55 = "braid.shl"(%bb64_1, %bb64_51) : (i64, i64) -> i64
      %bb64_56 = "braid.not"(%bb64_53) : (i64) -> i64
      %bb64_57 = "braid.and"(%bb64_55, %bb64_56) : (i64, i64) -> i64
      %bb64_50 = "braid.or"(%bb64_54, %bb64_57) : (i64, i64) -> i64
      "braid.set"(%bb64_10) {reg = "v5.lo"} : (i64) -> ()
      "braid.set"(%bb64_50) {reg = "v5.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x10068
      %bb68_0 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb68_1 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb68_2 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb68_3 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb68_10 = "braid.lanes"(%bb68_0, %bb68_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb68_20 = "braid.lanes"(%bb68_1, %bb68_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb68_10) {reg = "v1.lo"} : (i64) -> ()
      "braid.set"(%bb68_20) {reg = "v1.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x1006c
      %bb6c_0 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb6c_1 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb6c_2 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb6c_3 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb6c_10 = "braid.xor"(%bb6c_0, %bb6c_2) : (i64, i64) -> i64
      %bb6c_20 = "braid.xor"(%bb6c_1, %bb6c_3) : (i64, i64) -> i64
      "braid.set"(%bb6c_10) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb6c_20) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x10070
      %bb70_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb70_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb70_11 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb70_12 = "braid.shl"(%bb70_0, %bb70_11) : (i64, i64) -> i64
      %bb70_13 = "braid.const"() {value = -17587891081216 : i64} : () -> i64
      %bb70_10 = "braid.and"(%bb70_12, %bb70_13) : (i64, i64) -> i64
      %bb70_21 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb70_22 = "braid.shl"(%bb70_1, %bb70_21) : (i64, i64) -> i64
      %bb70_23 = "braid.const"() {value = -17587891081216 : i64} : () -> i64
      %bb70_20 = "braid.and"(%bb70_22, %bb70_23) : (i64, i64) -> i64
      "braid.set"(%bb70_10) {reg = "v6.lo"} : (i64) -> ()
      "braid.set"(%bb70_20) {reg = "v6.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x10074
      %bb74_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb74_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb74_2 = "braid.get"() {reg = "v6.lo"} : () -> i64
      %bb74_3 = "braid.get"() {reg = "v6.hi"} : () -> i64
      %bb74_11 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb74_12 = "braid.lshr"(%bb74_0, %bb74_11) : (i64, i64) -> i64
      %bb74_13 = "braid.const"() {value = 17587891081215 : i64} : () -> i64
      %bb74_14 = "braid.and"(%bb74_12, %bb74_13) : (i64, i64) -> i64
      %bb74_10 = "braid.lanes"(%bb74_2, %bb74_14) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb74_21 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb74_22 = "braid.lshr"(%bb74_1, %bb74_21) : (i64, i64) -> i64
      %bb74_23 = "braid.const"() {value = 17587891081215 : i64} : () -> i64
      %bb74_24 = "braid.and"(%bb74_22, %bb74_23) : (i64, i64) -> i64
      %bb74_20 = "braid.lanes"(%bb74_3, %bb74_24) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb74_10) {reg = "v6.lo"} : (i64) -> ()
      "braid.set"(%bb74_20) {reg = "v6.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x10078
      %bb78_0 = "braid.get"() {reg = "v6.lo"} : () -> i64
      %bb78_1 = "braid.get"() {reg = "v6.hi"} : () -> i64
      %bb78_2 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb78_3 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb78_10 = "braid.lanes"(%bb78_0, %bb78_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb78_20 = "braid.lanes"(%bb78_1, %bb78_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb78_10) {reg = "v4.lo"} : (i64) -> ()
      "braid.set"(%bb78_20) {reg = "v4.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x1007c
      %bb7c_0 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb7c_1 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb7c_2 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb7c_3 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb7c_10 = "braid.xor"(%bb7c_0, %bb7c_2) : (i64, i64) -> i64
      %bb7c_20 = "braid.xor"(%bb7c_1, %bb7c_3) : (i64, i64) -> i64
      "braid.set"(%bb7c_10) {reg = "v2.lo"} : (i64) -> ()
      "braid.set"(%bb7c_20) {reg = "v2.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x10080
      %bb80_0 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb80_1 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb80_11 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb80_12 = "braid.shl"(%bb80_0, %bb80_11) : (i64, i64) -> i64
      %bb80_13 = "braid.const"() {value = -1095216660736 : i64} : () -> i64
      %bb80_10 = "braid.and"(%bb80_12, %bb80_13) : (i64, i64) -> i64
      %bb80_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb80_22 = "braid.shl"(%bb80_1, %bb80_21) : (i64, i64) -> i64
      %bb80_23 = "braid.const"() {value = -1095216660736 : i64} : () -> i64
      %bb80_20 = "braid.and"(%bb80_22, %bb80_23) : (i64, i64) -> i64
      "braid.set"(%bb80_10) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb80_20) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x10084
      %bb84_0 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb84_1 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb84_2 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb84_3 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb84_11 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb84_12 = "braid.lshr"(%bb84_0, %bb84_11) : (i64, i64) -> i64
      %bb84_13 = "braid.const"() {value = 1095216660735 : i64} : () -> i64
      %bb84_14 = "braid.and"(%bb84_12, %bb84_13) : (i64, i64) -> i64
      %bb84_10 = "braid.lanes"(%bb84_2, %bb84_14) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb84_21 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb84_22 = "braid.lshr"(%bb84_1, %bb84_21) : (i64, i64) -> i64
      %bb84_23 = "braid.const"() {value = 1095216660735 : i64} : () -> i64
      %bb84_24 = "braid.and"(%bb84_22, %bb84_23) : (i64, i64) -> i64
      %bb84_20 = "braid.lanes"(%bb84_3, %bb84_24) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb84_10) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb84_20) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x10088
      %bb88_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb88_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb88_2 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb88_3 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb88_10 = "braid.lanes"(%bb88_0, %bb88_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb88_20 = "braid.lanes"(%bb88_1, %bb88_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb88_10) {reg = "v1.lo"} : (i64) -> ()
      "braid.set"(%bb88_20) {reg = "v1.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x1008c
      %bb8c_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb8c_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb8c_2 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb8c_3 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb8c_11 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb8c_12 = "braid.lshr"(%bb8c_0, %bb8c_11) : (i64, i64) -> i64
      %bb8c_13 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb8c_14 = "braid.shl"(%bb8c_1, %bb8c_13) : (i64, i64) -> i64
      %bb8c_10 = "braid.or"(%bb8c_12, %bb8c_14) : (i64, i64) -> i64
      %bb8c_21 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb8c_22 = "braid.lshr"(%bb8c_1, %bb8c_21) : (i64, i64) -> i64
      %bb8c_23 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb8c_24 = "braid.shl"(%bb8c_2, %bb8c_23) : (i64, i64) -> i64
      %bb8c_20 = "braid.or"(%bb8c_22, %bb8c_24) : (i64, i64) -> i64
      "braid.set"(%bb8c_10) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb8c_20) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x10090
      %bb90_0 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb90_1 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb90_2 = "braid.get"() {reg = "v6.lo"} : () -> i64
      %bb90_3 = "braid.get"() {reg = "v6.hi"} : () -> i64
      %bb90_10 = "braid.xor"(%bb90_0, %bb90_2) : (i64, i64) -> i64
      %bb90_20 = "braid.xor"(%bb90_1, %bb90_3) : (i64, i64) -> i64
      "braid.set"(%bb90_10) {reg = "v2.lo"} : (i64) -> ()
      "braid.set"(%bb90_20) {reg = "v2.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x10094
      %bb94_0 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb94_1 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb94_2 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb94_3 = "braid.get"() {reg = "v1.hi"} : () -> i64
      "braid.set"(%bb94_1) {reg = "v1.lo"} : (i64) -> ()
      "braid.set"(%bb94_2) {reg = "v1.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x10098
      %bb98_0 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb98_1 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb98_11 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb98_12 = "braid.shl"(%bb98_0, %bb98_11) : (i64, i64) -> i64
      %bb98_13 = "braid.const"() {value = -545460846720 : i64} : () -> i64
      %bb98_10 = "braid.and"(%bb98_12, %bb98_13) : (i64, i64) -> i64
      %bb98_21 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb98_22 = "braid.shl"(%bb98_1, %bb98_21) : (i64, i64) -> i64
      %bb98_23 = "braid.const"() {value = -545460846720 : i64} : () -> i64
      %bb98_20 = "braid.and"(%bb98_22, %bb98_23) : (i64, i64) -> i64
      "braid.set"(%bb98_10) {reg = "v5.lo"} : (i64) -> ()
      "braid.set"(%bb98_20) {reg = "v5.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x1009c
      %bb9c_0 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb9c_1 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb9c_2 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb9c_3 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb9c_11 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb9c_12 = "braid.lshr"(%bb9c_0, %bb9c_11) : (i64, i64) -> i64
      %bb9c_13 = "braid.const"() {value = 545460846719 : i64} : () -> i64
      %bb9c_14 = "braid.and"(%bb9c_12, %bb9c_13) : (i64, i64) -> i64
      %bb9c_10 = "braid.lanes"(%bb9c_2, %bb9c_14) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb9c_21 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb9c_22 = "braid.lshr"(%bb9c_1, %bb9c_21) : (i64, i64) -> i64
      %bb9c_23 = "braid.const"() {value = 545460846719 : i64} : () -> i64
      %bb9c_24 = "braid.and"(%bb9c_22, %bb9c_23) : (i64, i64) -> i64
      %bb9c_20 = "braid.lanes"(%bb9c_3, %bb9c_24) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb9c_10) {reg = "v5.lo"} : (i64) -> ()
      "braid.set"(%bb9c_20) {reg = "v5.hi"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x100a0
      %bba0_0 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bba0_1 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bba0_2 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bba0_3 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bba0_11 = "braid.const"() {value = 32 : i64} : () -> i64
      %bba0_12 = "braid.lshr"(%bba0_1, %bba0_11) : (i64, i64) -> i64
      %bba0_13 = "braid.const"() {value = 32 : i64} : () -> i64
      %bba0_14 = "braid.shl"(%bba0_2, %bba0_13) : (i64, i64) -> i64
      %bba0_10 = "braid.or"(%bba0_12, %bba0_14) : (i64, i64) -> i64
      %bba0_21 = "braid.const"() {value = 32 : i64} : () -> i64
      %bba0_22 = "braid.lshr"(%bba0_2, %bba0_21) : (i64, i64) -> i64
      %bba0_23 = "braid.const"() {value = 32 : i64} : () -> i64
      %bba0_24 = "braid.shl"(%bba0_3, %bba0_23) : (i64, i64) -> i64
      %bba0_20 = "braid.or"(%bba0_22, %bba0_24) : (i64, i64) -> i64
      "braid.set"(%bba0_10) {reg = "v2.lo"} : (i64) -> ()
      "braid.set"(%bba0_20) {reg = "v2.hi"} : (i64) -> ()
      "braid_cf.br"()[^bba4] : () -> ()
    ^bba4:  // 0x100a4
      %bba4_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bba4_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba4_0 = "braid.eq"(%bba4_1, %bba4_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bba4_0)[^bb10, ^bba8] : (i64) -> ()
    ^bba8:  // 0x100a8
      %bba8_0 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bba8_1 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bba8_2 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bba8_3 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bba8_10 = "braid.lanes"(%bba8_0, %bba8_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bba8_20 = "braid.lanes"(%bba8_1, %bba8_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bba8_10) {reg = "v0.lo"} : (i64) -> ()
      "braid.set"(%bba8_20) {reg = "v0.hi"} : (i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x100ac
      %bbac_0 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bbac_1 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bbac_2 = "braid.get"() {reg = "x0"} : () -> i64
      "braid.store"(%bbac_2, %bbac_0) {bytes = 8 : i64} : (i64, i64) -> ()
      %bbac_30 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbac_31 = "braid.add"(%bbac_2, %bbac_30) : (i64, i64) -> i64
      "braid.store"(%bbac_31, %bbac_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x100b0
      %bbb0_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bbb0_6 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbb0_0 = "braid.add"(%bbb0_1, %bbb0_6) : (i64, i64) -> i64
      %bbb0_30 = "braid.load"(%bbb0_0) {bytes = 8 : i64} : (i64) -> i64
      %bbb0_32 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbb0_33 = "braid.add"(%bbb0_0, %bbb0_32) : (i64, i64) -> i64
      %bbb0_31 = "braid.load"(%bbb0_33) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbb0_30) {reg = "v0.lo"} : (i64) -> ()
      "braid.set"(%bbb0_31) {reg = "v0.hi"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x100b4
      %bbb4_0 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bbb4_1 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bbb4_2 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bbb4_3 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bbb4_10 = "braid.lanes"(%bbb4_0, %bbb4_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bbb4_20 = "braid.lanes"(%bbb4_1, %bbb4_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bbb4_10) {reg = "v0.lo"} : (i64) -> ()
      "braid.set"(%bbb4_20) {reg = "v0.hi"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x100b8
      %bbb8_0 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bbb8_1 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bbb8_3 = "braid.get"() {reg = "x0"} : () -> i64
      %bbb8_8 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbb8_2 = "braid.add"(%bbb8_3, %bbb8_8) : (i64, i64) -> i64
      "braid.store"(%bbb8_2, %bbb8_0) {bytes = 8 : i64} : (i64, i64) -> ()
      %bbb8_30 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbb8_31 = "braid.add"(%bbb8_2, %bbb8_30) : (i64, i64) -> i64
      "braid.store"(%bbb8_31, %bbb8_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x100bc
      %bbbc_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bbbc_6 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbbc_0 = "braid.add"(%bbbc_1, %bbbc_6) : (i64, i64) -> i64
      %bbbc_30 = "braid.load"(%bbbc_0) {bytes = 8 : i64} : (i64) -> i64
      %bbbc_32 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbbc_33 = "braid.add"(%bbbc_0, %bbbc_32) : (i64, i64) -> i64
      %bbbc_31 = "braid.load"(%bbbc_33) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbbc_30) {reg = "v0.lo"} : (i64) -> ()
      "braid.set"(%bbbc_31) {reg = "v0.hi"} : (i64) -> ()
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bbc0:  // 0x100c0
      %bbc0_0 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bbc0_1 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bbc0_2 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bbc0_3 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bbc0_10 = "braid.lanes"(%bbc0_0, %bbc0_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bbc0_20 = "braid.lanes"(%bbc0_1, %bbc0_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bbc0_10) {reg = "v0.lo"} : (i64) -> ()
      "braid.set"(%bbc0_20) {reg = "v0.hi"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x100c4
      %bbc4_0 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bbc4_1 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bbc4_3 = "braid.get"() {reg = "x0"} : () -> i64
      %bbc4_8 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbc4_2 = "braid.add"(%bbc4_3, %bbc4_8) : (i64, i64) -> i64
      "braid.store"(%bbc4_2, %bbc4_0) {bytes = 8 : i64} : (i64, i64) -> ()
      %bbc4_30 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbc4_31 = "braid.add"(%bbc4_2, %bbc4_30) : (i64, i64) -> i64
      "braid.store"(%bbc4_31, %bbc4_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x100c8
      %bbc8_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bbc8_6 = "braid.const"() {value = 48 : i64} : () -> i64
      %bbc8_0 = "braid.add"(%bbc8_1, %bbc8_6) : (i64, i64) -> i64
      %bbc8_30 = "braid.load"(%bbc8_0) {bytes = 8 : i64} : (i64) -> i64
      %bbc8_32 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbc8_33 = "braid.add"(%bbc8_0, %bbc8_32) : (i64, i64) -> i64
      %bbc8_31 = "braid.load"(%bbc8_33) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbc8_30) {reg = "v0.lo"} : (i64) -> ()
      "braid.set"(%bbc8_31) {reg = "v0.hi"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x100cc
      %bbcc_0 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bbcc_1 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bbcc_2 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bbcc_3 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bbcc_10 = "braid.lanes"(%bbcc_0, %bbcc_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bbcc_20 = "braid.lanes"(%bbcc_1, %bbcc_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bbcc_10) {reg = "v0.lo"} : (i64) -> ()
      "braid.set"(%bbcc_20) {reg = "v0.hi"} : (i64) -> ()
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x100d0
      %bbd0_0 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bbd0_1 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bbd0_3 = "braid.get"() {reg = "x0"} : () -> i64
      %bbd0_8 = "braid.const"() {value = 48 : i64} : () -> i64
      %bbd0_2 = "braid.add"(%bbd0_3, %bbd0_8) : (i64, i64) -> i64
      "braid.store"(%bbd0_2, %bbd0_0) {bytes = 8 : i64} : (i64, i64) -> ()
      %bbd0_30 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbd0_31 = "braid.add"(%bbd0_2, %bbd0_30) : (i64, i64) -> i64
      "braid.store"(%bbd0_31, %bbd0_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x100d4
      %bbd4_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bbd4_0) : (i64) -> ()
  }) {sym_name = "chacha20_block_vec", entry = 65536 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
