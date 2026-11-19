"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb0_1 = "braid.const"() {value = -16 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      %bb4_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb4_4 = "braid.and"(%bb4_2, %bb4_3) : (i64, i64) -> i64
      %bb4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_6 = "braid.eq"(%bb4_4, %bb4_5) : (i64, i64) -> i64
      "braid.guard"(%bb4_6) : (i64) -> ()
      %bb4_7 = "braid.get"() {reg = "x8"} : () -> i64
      "braid.store"(%bb4_2, %bb4_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb8_4 = "braid.and"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      %bb8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_6 = "braid.eq"(%bb8_4, %bb8_5) : (i64, i64) -> i64
      "braid.guard"(%bb8_6) : (i64) -> ()
      %bb8_7 = "braid.load"(%bb8_2) {bytes = 4 : i64} : (i64) -> i64
      %bb8_8 = "braid.sext"(%bb8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb8_8) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbc_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      %bbc_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbc_4 = "braid.and"(%bbc_2, %bbc_3) : (i64, i64) -> i64
      %bbc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_6 = "braid.eq"(%bbc_4, %bbc_5) : (i64, i64) -> i64
      "braid.guard"(%bbc_6) : (i64) -> ()
      %bbc_7 = "braid.load"(%bbc_2) {bytes = 4 : i64} : (i64) -> i64
      %bbc_8 = "braid.sext"(%bbc_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbc_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb10_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb10_4 = "braid.and"(%bb10_2, %bb10_3) : (i64, i64) -> i64
      %bb10_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_6 = "braid.eq"(%bb10_4, %bb10_5) : (i64, i64) -> i64
      "braid.guard"(%bb10_6) : (i64) -> ()
      %bb10_7 = "braid.load"(%bb10_2) {bytes = 4 : i64} : (i64) -> i64
      %bb10_8 = "braid.sext"(%bb10_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb10_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10014
      %bb14_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb14_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      %bb14_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb14_4 = "braid.and"(%bb14_2, %bb14_3) : (i64, i64) -> i64
      %bb14_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_6 = "braid.eq"(%bb14_4, %bb14_5) : (i64, i64) -> i64
      "braid.guard"(%bb14_6) : (i64) -> ()
      %bb14_7 = "braid.load"(%bb14_2) {bytes = 4 : i64} : (i64) -> i64
      %bb14_8 = "braid.sext"(%bb14_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb14_8) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10018
      %bb18_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb18_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      %bb18_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb18_4 = "braid.and"(%bb18_2, %bb18_3) : (i64, i64) -> i64
      %bb18_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_6 = "braid.eq"(%bb18_4, %bb18_5) : (i64, i64) -> i64
      "braid.guard"(%bb18_6) : (i64) -> ()
      %bb18_7 = "braid.load"(%bb18_2) {bytes = 4 : i64} : (i64) -> i64
      %bb18_8 = "braid.sext"(%bb18_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb18_8) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1001c
      %bb1c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      %bb1c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1c_4 = "braid.and"(%bb1c_2, %bb1c_3) : (i64, i64) -> i64
      %bb1c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_6 = "braid.eq"(%bb1c_4, %bb1c_5) : (i64, i64) -> i64
      "braid.guard"(%bb1c_6) : (i64) -> ()
      %bb1c_7 = "braid.load"(%bb1c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb1c_8 = "braid.sext"(%bb1c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1c_8) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10020
      %bb20_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb20_1 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb20_2 = "braid.add"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      %bb20_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb20_4 = "braid.and"(%bb20_2, %bb20_3) : (i64, i64) -> i64
      %bb20_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_6 = "braid.eq"(%bb20_4, %bb20_5) : (i64, i64) -> i64
      "braid.guard"(%bb20_6) : (i64) -> ()
      %bb20_7 = "braid.load"(%bb20_2) {bytes = 4 : i64} : (i64) -> i64
      %bb20_8 = "braid.sext"(%bb20_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb20_8) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10024
      %bb24_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb24_1 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb24_2 = "braid.add"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      %bb24_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb24_4 = "braid.and"(%bb24_2, %bb24_3) : (i64, i64) -> i64
      %bb24_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_6 = "braid.eq"(%bb24_4, %bb24_5) : (i64, i64) -> i64
      "braid.guard"(%bb24_6) : (i64) -> ()
      %bb24_7 = "braid.load"(%bb24_2) {bytes = 4 : i64} : (i64) -> i64
      %bb24_8 = "braid.sext"(%bb24_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb24_8) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10028
      %bb28_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb28_2 = "braid.add"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      "braid.set"(%bb28_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x1002c
      %bb2c_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb2c_1 = "braid.zext"(%bb2c_0) {bits = 32 : i64} : (i64) -> i64
      %bb2c_2 = "braid.const"() {value = 6 : i64} : () -> i64
      %bb2c_3 = "braid.lshr"(%bb2c_1, %bb2c_2) : (i64, i64) -> i64
      %bb2c_4 = "braid.sext"(%bb2c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2c_4) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10030
      %bb30_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb30_1 = "braid.const"() {value = 26 : i64} : () -> i64
      %bb30_2 = "braid.shl"(%bb30_0, %bb30_1) : (i64, i64) -> i64
      "braid.set"(%bb30_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10034
      %bb34_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb34_1 = "braid.zext"(%bb34_0) {bits = 32 : i64} : (i64) -> i64
      %bb34_2 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb34_3 = "braid.lshr"(%bb34_1, %bb34_2) : (i64, i64) -> i64
      %bb34_4 = "braid.sext"(%bb34_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb34_4) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x10038
      %bb38_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb38_1 = "braid.const"() {value = 21 : i64} : () -> i64
      %bb38_2 = "braid.shl"(%bb38_0, %bb38_1) : (i64, i64) -> i64
      "braid.set"(%bb38_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x1003c
      %bb3c_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb3c_1 = "braid.zext"(%bb3c_0) {bits = 32 : i64} : (i64) -> i64
      %bb3c_2 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb3c_3 = "braid.lshr"(%bb3c_1, %bb3c_2) : (i64, i64) -> i64
      %bb3c_4 = "braid.sext"(%bb3c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb3c_4) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x10040
      %bb40_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb40_1 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb40_2 = "braid.shl"(%bb40_0, %bb40_1) : (i64, i64) -> i64
      "braid.set"(%bb40_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10044
      %bb44_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb44_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb44_2 = "braid.add"(%bb44_0, %bb44_1) : (i64, i64) -> i64
      "braid.set"(%bb44_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x10048
      %bb48_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb48_1 = "braid.zext"(%bb48_0) {bits = 32 : i64} : (i64) -> i64
      %bb48_2 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb48_3 = "braid.lshr"(%bb48_1, %bb48_2) : (i64, i64) -> i64
      %bb48_4 = "braid.sext"(%bb48_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb48_4) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x1004c
      %bb4c_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb4c_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb4c_2 = "braid.or"(%bb4c_0, %bb4c_1) : (i64, i64) -> i64
      "braid.set"(%bb4c_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x10050
      %bb50_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb50_1 = "braid.const"() {value = 30 : i64} : () -> i64
      %bb50_2 = "braid.shl"(%bb50_0, %bb50_1) : (i64, i64) -> i64
      "braid.set"(%bb50_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x10054
      %bb54_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb54_1 = "braid.get"() {reg = "x29"} : () -> i64
      %bb54_2 = "braid.or"(%bb54_0, %bb54_1) : (i64, i64) -> i64
      "braid.set"(%bb54_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x10058
      %bb58_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb58_1 = "braid.zext"(%bb58_0) {bits = 32 : i64} : (i64) -> i64
      %bb58_2 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb58_3 = "braid.lshr"(%bb58_1, %bb58_2) : (i64, i64) -> i64
      %bb58_4 = "braid.sext"(%bb58_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb58_4) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x1005c
      %bb5c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb5c_1 = "braid.get"() {reg = "x31"} : () -> i64
      %bb5c_2 = "braid.or"(%bb5c_0, %bb5c_1) : (i64, i64) -> i64
      "braid.set"(%bb5c_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x10060
      %bb60_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb60_1 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb60_2 = "braid.shl"(%bb60_0, %bb60_1) : (i64, i64) -> i64
      "braid.set"(%bb60_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x10064
      %bb64_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb64_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb64_2 = "braid.or"(%bb64_0, %bb64_1) : (i64, i64) -> i64
      "braid.set"(%bb64_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x10068
      %bb68_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb68_1 = "braid.zext"(%bb68_0) {bits = 32 : i64} : (i64) -> i64
      %bb68_2 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb68_3 = "braid.lshr"(%bb68_1, %bb68_2) : (i64, i64) -> i64
      %bb68_4 = "braid.sext"(%bb68_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb68_4) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x1006c
      %bb6c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb6c_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb6c_2 = "braid.or"(%bb6c_0, %bb6c_1) : (i64, i64) -> i64
      "braid.set"(%bb6c_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x10070
      %bb70_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb70_1 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb70_2 = "braid.shl"(%bb70_0, %bb70_1) : (i64, i64) -> i64
      "braid.set"(%bb70_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x10074
      %bb74_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb74_1 = "braid.get"() {reg = "x28"} : () -> i64
      %bb74_2 = "braid.or"(%bb74_0, %bb74_1) : (i64, i64) -> i64
      "braid.set"(%bb74_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x10078
      %bb78_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb78_1 = "braid.get"() {reg = "x29"} : () -> i64
      %bb78_2 = "braid.xor"(%bb78_0, %bb78_1) : (i64, i64) -> i64
      "braid.set"(%bb78_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x1007c
      %bb7c_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb7c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb7c_2 = "braid.xor"(%bb7c_0, %bb7c_1) : (i64, i64) -> i64
      "braid.set"(%bb7c_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x10080
      %bb80_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb80_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb80_2 = "braid.xor"(%bb80_0, %bb80_1) : (i64, i64) -> i64
      "braid.set"(%bb80_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x10084
      %bb84_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb84_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb84_2 = "braid.and"(%bb84_0, %bb84_1) : (i64, i64) -> i64
      "braid.set"(%bb84_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x10088
      %bb88_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb88_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb88_2 = "braid.and"(%bb88_0, %bb88_1) : (i64, i64) -> i64
      "braid.set"(%bb88_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x1008c
      %bb8c_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb8c_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb8c_2 = "braid.xor"(%bb8c_0, %bb8c_1) : (i64, i64) -> i64
      "braid.set"(%bb8c_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x10090
      %bb90_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb90_1 = "braid.get"() {reg = "x31"} : () -> i64
      %bb90_2 = "braid.xor"(%bb90_0, %bb90_1) : (i64, i64) -> i64
      "braid.set"(%bb90_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x10094
      %bb94_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb94_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb94_2 = "braid.xor"(%bb94_0, %bb94_1) : (i64, i64) -> i64
      "braid.set"(%bb94_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x10098
      %bb98_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb98_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb98_2 = "braid.and"(%bb98_0, %bb98_1) : (i64, i64) -> i64
      "braid.set"(%bb98_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x1009c
      %bb9c_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb9c_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb9c_2 = "braid.xor"(%bb9c_0, %bb9c_1) : (i64, i64) -> i64
      "braid.set"(%bb9c_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x100a0
      %bba0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bba0_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bba0_2 = "braid.add"(%bba0_0, %bba0_1) : (i64, i64) -> i64
      "braid.set"(%bba0_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bba4] : () -> ()
    ^bba4:  // 0x100a4
      %bba4_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bba4_1 = "braid.get"() {reg = "x28"} : () -> i64
      %bba4_2 = "braid.xor"(%bba4_0, %bba4_1) : (i64, i64) -> i64
      "braid.set"(%bba4_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x100a8
      %bba8_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bba8_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bba8_2 = "braid.add"(%bba8_0, %bba8_1) : (i64, i64) -> i64
      "braid.set"(%bba8_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x100ac
      %bbac_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bbac_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bbac_2 = "braid.add"(%bbac_0, %bbac_1) : (i64, i64) -> i64
      "braid.set"(%bbac_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x100b0
      %bbb0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbb0_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bbb0_2 = "braid.add"(%bbb0_0, %bbb0_1) : (i64, i64) -> i64
      "braid.set"(%bbb0_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x100b4
      %bbb4_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bbb4_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bbb4_2 = "braid.add"(%bbb4_0, %bbb4_1) : (i64, i64) -> i64
      "braid.set"(%bbb4_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x100b8
      %bbb8_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbb8_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbb8_2 = "braid.add"(%bbb8_0, %bbb8_1) : (i64, i64) -> i64
      %bbb8_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbb8_4 = "braid.and"(%bbb8_2, %bbb8_3) : (i64, i64) -> i64
      %bbb8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb8_6 = "braid.eq"(%bbb8_4, %bbb8_5) : (i64, i64) -> i64
      "braid.guard"(%bbb8_6) : (i64) -> ()
      %bbb8_7 = "braid.get"() {reg = "x6"} : () -> i64
      "braid.store"(%bbb8_2, %bbb8_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x100bc
      %bbbc_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbbc_1 = "braid.const"() {value = 20 : i64} : () -> i64
      %bbbc_2 = "braid.add"(%bbbc_0, %bbbc_1) : (i64, i64) -> i64
      %bbbc_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbbc_4 = "braid.and"(%bbbc_2, %bbbc_3) : (i64, i64) -> i64
      %bbbc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbbc_6 = "braid.eq"(%bbbc_4, %bbbc_5) : (i64, i64) -> i64
      "braid.guard"(%bbbc_6) : (i64) -> ()
      %bbbc_7 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.store"(%bbbc_2, %bbbc_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bbc0:  // 0x100c0
      %bbc0_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbc0_1 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbc0_2 = "braid.add"(%bbc0_0, %bbc0_1) : (i64, i64) -> i64
      %bbc0_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbc0_4 = "braid.and"(%bbc0_2, %bbc0_3) : (i64, i64) -> i64
      %bbc0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc0_6 = "braid.eq"(%bbc0_4, %bbc0_5) : (i64, i64) -> i64
      "braid.guard"(%bbc0_6) : (i64) -> ()
      %bbc0_7 = "braid.get"() {reg = "x17"} : () -> i64
      "braid.store"(%bbc0_2, %bbc0_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x100c4
      %bbc4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbc4_1 = "braid.const"() {value = 28 : i64} : () -> i64
      %bbc4_2 = "braid.add"(%bbc4_0, %bbc4_1) : (i64, i64) -> i64
      %bbc4_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbc4_4 = "braid.and"(%bbc4_2, %bbc4_3) : (i64, i64) -> i64
      %bbc4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc4_6 = "braid.eq"(%bbc4_4, %bbc4_5) : (i64, i64) -> i64
      "braid.guard"(%bbc4_6) : (i64) -> ()
      %bbc4_7 = "braid.get"() {reg = "x5"} : () -> i64
      "braid.store"(%bbc4_2, %bbc4_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x100c8
      %bbc8_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbc8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc8_2 = "braid.add"(%bbc8_0, %bbc8_1) : (i64, i64) -> i64
      %bbc8_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbc8_4 = "braid.and"(%bbc8_2, %bbc8_3) : (i64, i64) -> i64
      %bbc8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc8_6 = "braid.eq"(%bbc8_4, %bbc8_5) : (i64, i64) -> i64
      "braid.guard"(%bbc8_6) : (i64) -> ()
      %bbc8_7 = "braid.get"() {reg = "x11"} : () -> i64
      "braid.store"(%bbc8_2, %bbc8_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x100cc
      %bbcc_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbcc_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbcc_2 = "braid.add"(%bbcc_0, %bbcc_1) : (i64, i64) -> i64
      %bbcc_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbcc_4 = "braid.and"(%bbcc_2, %bbcc_3) : (i64, i64) -> i64
      %bbcc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbcc_6 = "braid.eq"(%bbcc_4, %bbcc_5) : (i64, i64) -> i64
      "braid.guard"(%bbcc_6) : (i64) -> ()
      %bbcc_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bbcc_2, %bbcc_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x100d0
      %bbd0_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbd0_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbd0_2 = "braid.add"(%bbd0_0, %bbd0_1) : (i64, i64) -> i64
      %bbd0_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbd0_4 = "braid.and"(%bbd0_2, %bbd0_3) : (i64, i64) -> i64
      %bbd0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd0_6 = "braid.eq"(%bbd0_4, %bbd0_5) : (i64, i64) -> i64
      "braid.guard"(%bbd0_6) : (i64) -> ()
      %bbd0_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bbd0_2, %bbd0_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x100d4
      %bbd4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbd4_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bbd4_2 = "braid.add"(%bbd4_0, %bbd4_1) : (i64, i64) -> i64
      %bbd4_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbd4_4 = "braid.and"(%bbd4_2, %bbd4_3) : (i64, i64) -> i64
      %bbd4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd4_6 = "braid.eq"(%bbd4_4, %bbd4_5) : (i64, i64) -> i64
      "braid.guard"(%bbd4_6) : (i64) -> ()
      %bbd4_7 = "braid.get"() {reg = "x15"} : () -> i64
      "braid.store"(%bbd4_2, %bbd4_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbd8] : () -> ()
    ^bbd8:  // 0x100d8
      %bbd8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbd8_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbd8_2 = "braid.add"(%bbd8_0, %bbd8_1) : (i64, i64) -> i64
      %bbd8_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbd8_4 = "braid.and"(%bbd8_2, %bbd8_3) : (i64, i64) -> i64
      %bbd8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd8_6 = "braid.eq"(%bbd8_4, %bbd8_5) : (i64, i64) -> i64
      "braid.guard"(%bbd8_6) : (i64) -> ()
      %bbd8_7 = "braid.load"(%bbd8_2) {bytes = 8 : i64} : (i64) -> i64
      %bbd8_8 = "braid.zext"(%bbd8_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bbd8_8) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x100dc
      %bbdc_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbdc_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbdc_2 = "braid.add"(%bbdc_0, %bbdc_1) : (i64, i64) -> i64
      "braid.set"(%bbdc_2) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bbe0] : () -> ()
    ^bbe0:  // 0x100e0
      %bbe0_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bbe0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe0_2 = "braid.add"(%bbe0_0, %bbe0_1) : (i64, i64) -> i64
      %bbe0_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bbe0_4 = "braid.and"(%bbe0_2, %bbe0_3) : (i64, i64) -> i64
      %bbe0_5 = "braid.const"() {value = 65764 : i64} : () -> i64
      "braid_cf.br_ind"(%bbe0_4) : (i64) -> ()
  }) {sym_name = "sha256_round", entry = 65536 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x100e4
      %bb0_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb0_1 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x100e8
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.const"() {value = 256 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x100ec
      %bb8_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb8_1 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb8_4 = "braid.and"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      %bb8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_6 = "braid.eq"(%bb8_4, %bb8_5) : (i64, i64) -> i64
      "braid.guard"(%bb8_6) : (i64) -> ()
      %bb8_7 = "braid.load"(%bb8_2) {bytes = 4 : i64} : (i64) -> i64
      %bb8_8 = "braid.sext"(%bb8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb8_8) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x100f0
      %bbc_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbc_1 = "braid.const"() {value = -28 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      %bbc_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbc_4 = "braid.and"(%bbc_2, %bbc_3) : (i64, i64) -> i64
      %bbc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_6 = "braid.eq"(%bbc_4, %bbc_5) : (i64, i64) -> i64
      "braid.guard"(%bbc_6) : (i64) -> ()
      %bbc_7 = "braid.load"(%bbc_2) {bytes = 4 : i64} : (i64) -> i64
      %bbc_8 = "braid.sext"(%bbc_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbc_8) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x100f4
      %bb10_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb10_1 = "braid.const"() {value = -60 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb10_4 = "braid.and"(%bb10_2, %bb10_3) : (i64, i64) -> i64
      %bb10_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_6 = "braid.eq"(%bb10_4, %bb10_5) : (i64, i64) -> i64
      "braid.guard"(%bb10_6) : (i64) -> ()
      %bb10_7 = "braid.load"(%bb10_2) {bytes = 4 : i64} : (i64) -> i64
      %bb10_8 = "braid.sext"(%bb10_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb10_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x100f8
      %bb14_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb14_1 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      %bb14_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb14_4 = "braid.and"(%bb14_2, %bb14_3) : (i64, i64) -> i64
      %bb14_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_6 = "braid.eq"(%bb14_4, %bb14_5) : (i64, i64) -> i64
      "braid.guard"(%bb14_6) : (i64) -> ()
      %bb14_7 = "braid.load"(%bb14_2) {bytes = 4 : i64} : (i64) -> i64
      %bb14_8 = "braid.sext"(%bb14_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb14_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x100fc
      %bb18_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb18_1 = "braid.zext"(%bb18_0) {bits = 32 : i64} : (i64) -> i64
      %bb18_2 = "braid.const"() {value = 17 : i64} : () -> i64
      %bb18_3 = "braid.lshr"(%bb18_1, %bb18_2) : (i64, i64) -> i64
      %bb18_4 = "braid.sext"(%bb18_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb18_4) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10100
      %bb1c_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1c_2 = "braid.shl"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      "braid.set"(%bb1c_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10104
      %bb20_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb20_1 = "braid.zext"(%bb20_0) {bits = 32 : i64} : (i64) -> i64
      %bb20_2 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb20_3 = "braid.lshr"(%bb20_1, %bb20_2) : (i64, i64) -> i64
      %bb20_4 = "braid.sext"(%bb20_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb20_4) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10108
      %bb24_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb24_1 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb24_2 = "braid.shl"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      "braid.set"(%bb24_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x1010c
      %bb28_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb28_2 = "braid.add"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      "braid.set"(%bb28_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x10110
      %bb2c_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb2c_1 = "braid.zext"(%bb2c_0) {bits = 32 : i64} : (i64) -> i64
      %bb2c_2 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb2c_3 = "braid.lshr"(%bb2c_1, %bb2c_2) : (i64, i64) -> i64
      %bb2c_4 = "braid.sext"(%bb2c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2c_4) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10114
      %bb30_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb30_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb30_2 = "braid.or"(%bb30_0, %bb30_1) : (i64, i64) -> i64
      "braid.set"(%bb30_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10118
      %bb34_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb34_1 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb34_2 = "braid.shl"(%bb34_0, %bb34_1) : (i64, i64) -> i64
      "braid.set"(%bb34_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x1011c
      %bb38_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb38_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb38_2 = "braid.or"(%bb38_0, %bb38_1) : (i64, i64) -> i64
      "braid.set"(%bb38_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x10120
      %bb3c_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb3c_1 = "braid.zext"(%bb3c_0) {bits = 32 : i64} : (i64) -> i64
      %bb3c_2 = "braid.const"() {value = 18 : i64} : () -> i64
      %bb3c_3 = "braid.lshr"(%bb3c_1, %bb3c_2) : (i64, i64) -> i64
      %bb3c_4 = "braid.sext"(%bb3c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb3c_4) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x10124
      %bb40_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb40_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb40_2 = "braid.or"(%bb40_0, %bb40_1) : (i64, i64) -> i64
      "braid.set"(%bb40_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10128
      %bb44_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb44_1 = "braid.const"() {value = 14 : i64} : () -> i64
      %bb44_2 = "braid.shl"(%bb44_0, %bb44_1) : (i64, i64) -> i64
      "braid.set"(%bb44_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x1012c
      %bb48_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb48_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb48_2 = "braid.or"(%bb48_0, %bb48_1) : (i64, i64) -> i64
      "braid.set"(%bb48_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x10130
      %bb4c_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb4c_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb4c_2 = "braid.xor"(%bb4c_0, %bb4c_1) : (i64, i64) -> i64
      "braid.set"(%bb4c_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x10134
      %bb50_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb50_1 = "braid.zext"(%bb50_0) {bits = 32 : i64} : (i64) -> i64
      %bb50_2 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb50_3 = "braid.lshr"(%bb50_1, %bb50_2) : (i64, i64) -> i64
      %bb50_4 = "braid.sext"(%bb50_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb50_4) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x10138
      %bb54_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb54_1 = "braid.zext"(%bb54_0) {bits = 32 : i64} : (i64) -> i64
      %bb54_2 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb54_3 = "braid.lshr"(%bb54_1, %bb54_2) : (i64, i64) -> i64
      %bb54_4 = "braid.sext"(%bb54_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb54_4) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x1013c
      %bb58_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb58_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb58_2 = "braid.xor"(%bb58_0, %bb58_1) : (i64, i64) -> i64
      "braid.set"(%bb58_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x10140
      %bb5c_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb5c_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb5c_2 = "braid.xor"(%bb5c_0, %bb5c_1) : (i64, i64) -> i64
      "braid.set"(%bb5c_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x10144
      %bb60_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb60_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb60_2 = "braid.xor"(%bb60_0, %bb60_1) : (i64, i64) -> i64
      "braid.set"(%bb60_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x10148
      %bb64_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb64_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb64_2 = "braid.add"(%bb64_0, %bb64_1) : (i64, i64) -> i64
      "braid.set"(%bb64_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x1014c
      %bb68_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb68_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb68_2 = "braid.add"(%bb68_0, %bb68_1) : (i64, i64) -> i64
      "braid.set"(%bb68_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x10150
      %bb6c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb6c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6c_2 = "braid.add"(%bb6c_0, %bb6c_1) : (i64, i64) -> i64
      %bb6c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb6c_4 = "braid.and"(%bb6c_2, %bb6c_3) : (i64, i64) -> i64
      %bb6c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6c_6 = "braid.eq"(%bb6c_4, %bb6c_5) : (i64, i64) -> i64
      "braid.guard"(%bb6c_6) : (i64) -> ()
      %bb6c_7 = "braid.get"() {reg = "x12"} : () -> i64
      "braid.store"(%bb6c_2, %bb6c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x10154
      %bb70_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb70_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb70_2 = "braid.add"(%bb70_0, %bb70_1) : (i64, i64) -> i64
      "braid.set"(%bb70_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x10158
      %bb74_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb74_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb74_2 = "braid.ne"(%bb74_0, %bb74_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb74_2)[^bb8, ^bb78] : (i64) -> ()
    ^bb78:  // 0x1015c
      %bb78_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb78_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb78_2 = "braid.add"(%bb78_0, %bb78_1) : (i64, i64) -> i64
      %bb78_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb78_4 = "braid.and"(%bb78_2, %bb78_3) : (i64, i64) -> i64
      %bb78_5 = "braid.const"() {value = 65888 : i64} : () -> i64
      "braid_cf.br_ind"(%bb78_4) : (i64) -> ()
  }) {sym_name = "sha256_schedule", entry = 65764 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10160
      %bb0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb0_1 = "braid.const"() {value = -336 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10164
      %bb4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4_1 = "braid.const"() {value = 328 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      %bb4_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb4_4 = "braid.and"(%bb4_2, %bb4_3) : (i64, i64) -> i64
      %bb4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_6 = "braid.eq"(%bb4_4, %bb4_5) : (i64, i64) -> i64
      "braid.guard"(%bb4_6) : (i64) -> ()
      %bb4_7 = "braid.get"() {reg = "x8"} : () -> i64
      "braid.store"(%bb4_2, %bb4_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10168
      %bb8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb8_1 = "braid.const"() {value = 320 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb8_4 = "braid.and"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      %bb8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_6 = "braid.eq"(%bb8_4, %bb8_5) : (i64, i64) -> i64
      "braid.guard"(%bb8_6) : (i64) -> ()
      %bb8_7 = "braid.get"() {reg = "x9"} : () -> i64
      "braid.store"(%bb8_2, %bb8_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1016c
      %bbc_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbc_1 = "braid.const"() {value = 312 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      %bbc_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbc_4 = "braid.and"(%bbc_2, %bbc_3) : (i64, i64) -> i64
      %bbc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_6 = "braid.eq"(%bbc_4, %bbc_5) : (i64, i64) -> i64
      "braid.guard"(%bbc_6) : (i64) -> ()
      %bbc_7 = "braid.get"() {reg = "x18"} : () -> i64
      "braid.store"(%bbc_2, %bbc_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10170
      %bb10_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb10_1 = "braid.const"() {value = 304 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb10_4 = "braid.and"(%bb10_2, %bb10_3) : (i64, i64) -> i64
      %bb10_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_6 = "braid.eq"(%bb10_4, %bb10_5) : (i64, i64) -> i64
      "braid.guard"(%bb10_6) : (i64) -> ()
      %bb10_7 = "braid.get"() {reg = "x19"} : () -> i64
      "braid.store"(%bb10_2, %bb10_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10174
      %bb14_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb14_1 = "braid.const"() {value = 296 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      %bb14_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb14_4 = "braid.and"(%bb14_2, %bb14_3) : (i64, i64) -> i64
      %bb14_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_6 = "braid.eq"(%bb14_4, %bb14_5) : (i64, i64) -> i64
      "braid.guard"(%bb14_6) : (i64) -> ()
      %bb14_7 = "braid.get"() {reg = "x20"} : () -> i64
      "braid.store"(%bb14_2, %bb14_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10178
      %bb18_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb18_1 = "braid.const"() {value = 288 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      %bb18_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb18_4 = "braid.and"(%bb18_2, %bb18_3) : (i64, i64) -> i64
      %bb18_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_6 = "braid.eq"(%bb18_4, %bb18_5) : (i64, i64) -> i64
      "braid.guard"(%bb18_6) : (i64) -> ()
      %bb18_7 = "braid.get"() {reg = "x21"} : () -> i64
      "braid.store"(%bb18_2, %bb18_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1017c
      %bb1c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 280 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      %bb1c_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1c_4 = "braid.and"(%bb1c_2, %bb1c_3) : (i64, i64) -> i64
      %bb1c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_6 = "braid.eq"(%bb1c_4, %bb1c_5) : (i64, i64) -> i64
      "braid.guard"(%bb1c_6) : (i64) -> ()
      %bb1c_7 = "braid.get"() {reg = "x22"} : () -> i64
      "braid.store"(%bb1c_2, %bb1c_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10180
      %bb20_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb20_1 = "braid.const"() {value = 272 : i64} : () -> i64
      %bb20_2 = "braid.add"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      %bb20_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb20_4 = "braid.and"(%bb20_2, %bb20_3) : (i64, i64) -> i64
      %bb20_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_6 = "braid.eq"(%bb20_4, %bb20_5) : (i64, i64) -> i64
      "braid.guard"(%bb20_6) : (i64) -> ()
      %bb20_7 = "braid.get"() {reg = "x23"} : () -> i64
      "braid.store"(%bb20_2, %bb20_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10184
      %bb24_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb24_1 = "braid.const"() {value = 264 : i64} : () -> i64
      %bb24_2 = "braid.add"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      %bb24_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb24_4 = "braid.and"(%bb24_2, %bb24_3) : (i64, i64) -> i64
      %bb24_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_6 = "braid.eq"(%bb24_4, %bb24_5) : (i64, i64) -> i64
      "braid.guard"(%bb24_6) : (i64) -> ()
      %bb24_7 = "braid.get"() {reg = "x24"} : () -> i64
      "braid.store"(%bb24_2, %bb24_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10188
      %bb28_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb28_1 = "braid.const"() {value = 256 : i64} : () -> i64
      %bb28_2 = "braid.add"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      %bb28_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb28_4 = "braid.and"(%bb28_2, %bb28_3) : (i64, i64) -> i64
      %bb28_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_6 = "braid.eq"(%bb28_4, %bb28_5) : (i64, i64) -> i64
      "braid.guard"(%bb28_6) : (i64) -> ()
      %bb28_7 = "braid.get"() {reg = "x25"} : () -> i64
      "braid.store"(%bb28_2, %bb28_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x1018c
      %bb2c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb2c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_2 = "braid.add"(%bb2c_0, %bb2c_1) : (i64, i64) -> i64
      %bb2c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb2c_4 = "braid.and"(%bb2c_2, %bb2c_3) : (i64, i64) -> i64
      %bb2c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_6 = "braid.eq"(%bb2c_4, %bb2c_5) : (i64, i64) -> i64
      "braid.guard"(%bb2c_6) : (i64) -> ()
      %bb2c_7 = "braid.load"(%bb2c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb2c_8 = "braid.sext"(%bb2c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2c_8) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10190
      %bb30_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb30_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb30_2 = "braid.add"(%bb30_0, %bb30_1) : (i64, i64) -> i64
      %bb30_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb30_4 = "braid.and"(%bb30_2, %bb30_3) : (i64, i64) -> i64
      %bb30_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb30_6 = "braid.eq"(%bb30_4, %bb30_5) : (i64, i64) -> i64
      "braid.guard"(%bb30_6) : (i64) -> ()
      %bb30_7 = "braid.load"(%bb30_2) {bytes = 4 : i64} : (i64) -> i64
      %bb30_8 = "braid.sext"(%bb30_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb30_8) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10194
      %bb34_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb34_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb34_2 = "braid.add"(%bb34_0, %bb34_1) : (i64, i64) -> i64
      %bb34_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb34_4 = "braid.and"(%bb34_2, %bb34_3) : (i64, i64) -> i64
      %bb34_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb34_6 = "braid.eq"(%bb34_4, %bb34_5) : (i64, i64) -> i64
      "braid.guard"(%bb34_6) : (i64) -> ()
      %bb34_7 = "braid.load"(%bb34_2) {bytes = 4 : i64} : (i64) -> i64
      %bb34_8 = "braid.sext"(%bb34_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb34_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x10198
      %bb38_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb38_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb38_2 = "braid.add"(%bb38_0, %bb38_1) : (i64, i64) -> i64
      %bb38_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb38_4 = "braid.and"(%bb38_2, %bb38_3) : (i64, i64) -> i64
      %bb38_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb38_6 = "braid.eq"(%bb38_4, %bb38_5) : (i64, i64) -> i64
      "braid.guard"(%bb38_6) : (i64) -> ()
      %bb38_7 = "braid.load"(%bb38_2) {bytes = 4 : i64} : (i64) -> i64
      %bb38_8 = "braid.sext"(%bb38_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb38_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x1019c
      %bb3c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb3c_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb3c_2 = "braid.add"(%bb3c_0, %bb3c_1) : (i64, i64) -> i64
      %bb3c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb3c_4 = "braid.and"(%bb3c_2, %bb3c_3) : (i64, i64) -> i64
      %bb3c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3c_6 = "braid.eq"(%bb3c_4, %bb3c_5) : (i64, i64) -> i64
      "braid.guard"(%bb3c_6) : (i64) -> ()
      %bb3c_7 = "braid.load"(%bb3c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb3c_8 = "braid.sext"(%bb3c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb3c_8) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x101a0
      %bb40_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb40_1 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb40_2 = "braid.add"(%bb40_0, %bb40_1) : (i64, i64) -> i64
      %bb40_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb40_4 = "braid.and"(%bb40_2, %bb40_3) : (i64, i64) -> i64
      %bb40_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb40_6 = "braid.eq"(%bb40_4, %bb40_5) : (i64, i64) -> i64
      "braid.guard"(%bb40_6) : (i64) -> ()
      %bb40_7 = "braid.load"(%bb40_2) {bytes = 4 : i64} : (i64) -> i64
      %bb40_8 = "braid.sext"(%bb40_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb40_8) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x101a4
      %bb44_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb44_1 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb44_2 = "braid.add"(%bb44_0, %bb44_1) : (i64, i64) -> i64
      %bb44_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb44_4 = "braid.and"(%bb44_2, %bb44_3) : (i64, i64) -> i64
      %bb44_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb44_6 = "braid.eq"(%bb44_4, %bb44_5) : (i64, i64) -> i64
      "braid.guard"(%bb44_6) : (i64) -> ()
      %bb44_7 = "braid.load"(%bb44_2) {bytes = 4 : i64} : (i64) -> i64
      %bb44_8 = "braid.sext"(%bb44_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb44_8) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x101a8
      %bb48_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb48_1 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb48_2 = "braid.add"(%bb48_0, %bb48_1) : (i64, i64) -> i64
      %bb48_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb48_4 = "braid.and"(%bb48_2, %bb48_3) : (i64, i64) -> i64
      %bb48_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb48_6 = "braid.eq"(%bb48_4, %bb48_5) : (i64, i64) -> i64
      "braid.guard"(%bb48_6) : (i64) -> ()
      %bb48_7 = "braid.load"(%bb48_2) {bytes = 4 : i64} : (i64) -> i64
      %bb48_8 = "braid.sext"(%bb48_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb48_8) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x101ac
      %bb4c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4c_2 = "braid.add"(%bb4c_0, %bb4c_1) : (i64, i64) -> i64
      %bb4c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb4c_4 = "braid.and"(%bb4c_2, %bb4c_3) : (i64, i64) -> i64
      %bb4c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4c_6 = "braid.eq"(%bb4c_4, %bb4c_5) : (i64, i64) -> i64
      "braid.guard"(%bb4c_6) : (i64) -> ()
      %bb4c_7 = "braid.get"() {reg = "x12"} : () -> i64
      "braid.store"(%bb4c_2, %bb4c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x101b0
      %bb50_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb50_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb50_2 = "braid.add"(%bb50_0, %bb50_1) : (i64, i64) -> i64
      %bb50_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb50_4 = "braid.and"(%bb50_2, %bb50_3) : (i64, i64) -> i64
      %bb50_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb50_6 = "braid.eq"(%bb50_4, %bb50_5) : (i64, i64) -> i64
      "braid.guard"(%bb50_6) : (i64) -> ()
      %bb50_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bb50_2, %bb50_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x101b4
      %bb54_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb54_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb54_2 = "braid.add"(%bb54_0, %bb54_1) : (i64, i64) -> i64
      %bb54_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb54_4 = "braid.and"(%bb54_2, %bb54_3) : (i64, i64) -> i64
      %bb54_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb54_6 = "braid.eq"(%bb54_4, %bb54_5) : (i64, i64) -> i64
      "braid.guard"(%bb54_6) : (i64) -> ()
      %bb54_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bb54_2, %bb54_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x101b8
      %bb58_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb58_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb58_2 = "braid.add"(%bb58_0, %bb58_1) : (i64, i64) -> i64
      %bb58_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb58_4 = "braid.and"(%bb58_2, %bb58_3) : (i64, i64) -> i64
      %bb58_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb58_6 = "braid.eq"(%bb58_4, %bb58_5) : (i64, i64) -> i64
      "braid.guard"(%bb58_6) : (i64) -> ()
      %bb58_7 = "braid.get"() {reg = "x15"} : () -> i64
      "braid.store"(%bb58_2, %bb58_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x101bc
      %bb5c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb5c_1 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb5c_2 = "braid.add"(%bb5c_0, %bb5c_1) : (i64, i64) -> i64
      %bb5c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb5c_4 = "braid.and"(%bb5c_2, %bb5c_3) : (i64, i64) -> i64
      %bb5c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb5c_6 = "braid.eq"(%bb5c_4, %bb5c_5) : (i64, i64) -> i64
      "braid.guard"(%bb5c_6) : (i64) -> ()
      %bb5c_7 = "braid.load"(%bb5c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb5c_8 = "braid.sext"(%bb5c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb5c_8) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x101c0
      %bb60_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb60_1 = "braid.const"() {value = 36 : i64} : () -> i64
      %bb60_2 = "braid.add"(%bb60_0, %bb60_1) : (i64, i64) -> i64
      %bb60_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb60_4 = "braid.and"(%bb60_2, %bb60_3) : (i64, i64) -> i64
      %bb60_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb60_6 = "braid.eq"(%bb60_4, %bb60_5) : (i64, i64) -> i64
      "braid.guard"(%bb60_6) : (i64) -> ()
      %bb60_7 = "braid.load"(%bb60_2) {bytes = 4 : i64} : (i64) -> i64
      %bb60_8 = "braid.sext"(%bb60_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb60_8) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x101c4
      %bb64_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb64_1 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb64_2 = "braid.add"(%bb64_0, %bb64_1) : (i64, i64) -> i64
      %bb64_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb64_4 = "braid.and"(%bb64_2, %bb64_3) : (i64, i64) -> i64
      %bb64_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb64_6 = "braid.eq"(%bb64_4, %bb64_5) : (i64, i64) -> i64
      "braid.guard"(%bb64_6) : (i64) -> ()
      %bb64_7 = "braid.load"(%bb64_2) {bytes = 4 : i64} : (i64) -> i64
      %bb64_8 = "braid.sext"(%bb64_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb64_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x101c8
      %bb68_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb68_1 = "braid.const"() {value = 44 : i64} : () -> i64
      %bb68_2 = "braid.add"(%bb68_0, %bb68_1) : (i64, i64) -> i64
      %bb68_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb68_4 = "braid.and"(%bb68_2, %bb68_3) : (i64, i64) -> i64
      %bb68_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb68_6 = "braid.eq"(%bb68_4, %bb68_5) : (i64, i64) -> i64
      "braid.guard"(%bb68_6) : (i64) -> ()
      %bb68_7 = "braid.load"(%bb68_2) {bytes = 4 : i64} : (i64) -> i64
      %bb68_8 = "braid.sext"(%bb68_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb68_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x101cc
      %bb6c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb6c_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb6c_2 = "braid.add"(%bb6c_0, %bb6c_1) : (i64, i64) -> i64
      %bb6c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb6c_4 = "braid.and"(%bb6c_2, %bb6c_3) : (i64, i64) -> i64
      %bb6c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6c_6 = "braid.eq"(%bb6c_4, %bb6c_5) : (i64, i64) -> i64
      "braid.guard"(%bb6c_6) : (i64) -> ()
      %bb6c_7 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.store"(%bb6c_2, %bb6c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x101d0
      %bb70_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb70_1 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb70_2 = "braid.add"(%bb70_0, %bb70_1) : (i64, i64) -> i64
      %bb70_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb70_4 = "braid.and"(%bb70_2, %bb70_3) : (i64, i64) -> i64
      %bb70_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb70_6 = "braid.eq"(%bb70_4, %bb70_5) : (i64, i64) -> i64
      "braid.guard"(%bb70_6) : (i64) -> ()
      %bb70_7 = "braid.get"() {reg = "x17"} : () -> i64
      "braid.store"(%bb70_2, %bb70_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x101d4
      %bb74_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb74_1 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb74_2 = "braid.add"(%bb74_0, %bb74_1) : (i64, i64) -> i64
      %bb74_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb74_4 = "braid.and"(%bb74_2, %bb74_3) : (i64, i64) -> i64
      %bb74_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb74_6 = "braid.eq"(%bb74_4, %bb74_5) : (i64, i64) -> i64
      "braid.guard"(%bb74_6) : (i64) -> ()
      %bb74_7 = "braid.get"() {reg = "x5"} : () -> i64
      "braid.store"(%bb74_2, %bb74_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x101d8
      %bb78_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb78_1 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb78_2 = "braid.add"(%bb78_0, %bb78_1) : (i64, i64) -> i64
      %bb78_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb78_4 = "braid.and"(%bb78_2, %bb78_3) : (i64, i64) -> i64
      %bb78_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb78_6 = "braid.eq"(%bb78_4, %bb78_5) : (i64, i64) -> i64
      "braid.guard"(%bb78_6) : (i64) -> ()
      %bb78_7 = "braid.get"() {reg = "x6"} : () -> i64
      "braid.store"(%bb78_2, %bb78_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x101dc
      %bb7c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb7c_1 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb7c_2 = "braid.add"(%bb7c_0, %bb7c_1) : (i64, i64) -> i64
      %bb7c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb7c_4 = "braid.and"(%bb7c_2, %bb7c_3) : (i64, i64) -> i64
      %bb7c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7c_6 = "braid.eq"(%bb7c_4, %bb7c_5) : (i64, i64) -> i64
      "braid.guard"(%bb7c_6) : (i64) -> ()
      %bb7c_7 = "braid.load"(%bb7c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb7c_8 = "braid.sext"(%bb7c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb7c_8) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x101e0
      %bb80_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb80_1 = "braid.const"() {value = 52 : i64} : () -> i64
      %bb80_2 = "braid.add"(%bb80_0, %bb80_1) : (i64, i64) -> i64
      %bb80_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb80_4 = "braid.and"(%bb80_2, %bb80_3) : (i64, i64) -> i64
      %bb80_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb80_6 = "braid.eq"(%bb80_4, %bb80_5) : (i64, i64) -> i64
      "braid.guard"(%bb80_6) : (i64) -> ()
      %bb80_7 = "braid.load"(%bb80_2) {bytes = 4 : i64} : (i64) -> i64
      %bb80_8 = "braid.sext"(%bb80_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb80_8) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x101e4
      %bb84_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb84_1 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb84_2 = "braid.add"(%bb84_0, %bb84_1) : (i64, i64) -> i64
      %bb84_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb84_4 = "braid.and"(%bb84_2, %bb84_3) : (i64, i64) -> i64
      %bb84_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb84_6 = "braid.eq"(%bb84_4, %bb84_5) : (i64, i64) -> i64
      "braid.guard"(%bb84_6) : (i64) -> ()
      %bb84_7 = "braid.load"(%bb84_2) {bytes = 4 : i64} : (i64) -> i64
      %bb84_8 = "braid.sext"(%bb84_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb84_8) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x101e8
      %bb88_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb88_1 = "braid.const"() {value = 60 : i64} : () -> i64
      %bb88_2 = "braid.add"(%bb88_0, %bb88_1) : (i64, i64) -> i64
      %bb88_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb88_4 = "braid.and"(%bb88_2, %bb88_3) : (i64, i64) -> i64
      %bb88_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb88_6 = "braid.eq"(%bb88_4, %bb88_5) : (i64, i64) -> i64
      "braid.guard"(%bb88_6) : (i64) -> ()
      %bb88_7 = "braid.load"(%bb88_2) {bytes = 4 : i64} : (i64) -> i64
      %bb88_8 = "braid.sext"(%bb88_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb88_8) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x101ec
      %bb8c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb8c_1 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb8c_2 = "braid.add"(%bb8c_0, %bb8c_1) : (i64, i64) -> i64
      %bb8c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb8c_4 = "braid.and"(%bb8c_2, %bb8c_3) : (i64, i64) -> i64
      %bb8c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8c_6 = "braid.eq"(%bb8c_4, %bb8c_5) : (i64, i64) -> i64
      "braid.guard"(%bb8c_6) : (i64) -> ()
      %bb8c_7 = "braid.get"() {reg = "x12"} : () -> i64
      "braid.store"(%bb8c_2, %bb8c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x101f0
      %bb90_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb90_1 = "braid.const"() {value = 36 : i64} : () -> i64
      %bb90_2 = "braid.add"(%bb90_0, %bb90_1) : (i64, i64) -> i64
      %bb90_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb90_4 = "braid.and"(%bb90_2, %bb90_3) : (i64, i64) -> i64
      %bb90_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb90_6 = "braid.eq"(%bb90_4, %bb90_5) : (i64, i64) -> i64
      "braid.guard"(%bb90_6) : (i64) -> ()
      %bb90_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bb90_2, %bb90_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x101f4
      %bb94_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb94_1 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb94_2 = "braid.add"(%bb94_0, %bb94_1) : (i64, i64) -> i64
      %bb94_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb94_4 = "braid.and"(%bb94_2, %bb94_3) : (i64, i64) -> i64
      %bb94_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb94_6 = "braid.eq"(%bb94_4, %bb94_5) : (i64, i64) -> i64
      "braid.guard"(%bb94_6) : (i64) -> ()
      %bb94_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bb94_2, %bb94_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x101f8
      %bb98_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb98_1 = "braid.const"() {value = 44 : i64} : () -> i64
      %bb98_2 = "braid.add"(%bb98_0, %bb98_1) : (i64, i64) -> i64
      %bb98_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb98_4 = "braid.and"(%bb98_2, %bb98_3) : (i64, i64) -> i64
      %bb98_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb98_6 = "braid.eq"(%bb98_4, %bb98_5) : (i64, i64) -> i64
      "braid.guard"(%bb98_6) : (i64) -> ()
      %bb98_7 = "braid.get"() {reg = "x15"} : () -> i64
      "braid.store"(%bb98_2, %bb98_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x101fc
      %bb9c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb9c_1 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb9c_2 = "braid.add"(%bb9c_0, %bb9c_1) : (i64, i64) -> i64
      "braid.set"(%bb9c_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x10200
      %bba0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bba0_1 = "braid.const"() {value = 48 : i64} : () -> i64
      %bba0_2 = "braid.add"(%bba0_0, %bba0_1) : (i64, i64) -> i64
      %bba0_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bba0_4 = "braid.and"(%bba0_2, %bba0_3) : (i64, i64) -> i64
      %bba0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba0_6 = "braid.eq"(%bba0_4, %bba0_5) : (i64, i64) -> i64
      "braid.guard"(%bba0_6) : (i64) -> ()
      %bba0_7 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.store"(%bba0_2, %bba0_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bba4] : () -> ()
    ^bba4:  // 0x10204
      %bba4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bba4_1 = "braid.const"() {value = 52 : i64} : () -> i64
      %bba4_2 = "braid.add"(%bba4_0, %bba4_1) : (i64, i64) -> i64
      %bba4_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bba4_4 = "braid.and"(%bba4_2, %bba4_3) : (i64, i64) -> i64
      %bba4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba4_6 = "braid.eq"(%bba4_4, %bba4_5) : (i64, i64) -> i64
      "braid.guard"(%bba4_6) : (i64) -> ()
      %bba4_7 = "braid.get"() {reg = "x17"} : () -> i64
      "braid.store"(%bba4_2, %bba4_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x10208
      %bba8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bba8_1 = "braid.const"() {value = 56 : i64} : () -> i64
      %bba8_2 = "braid.add"(%bba8_0, %bba8_1) : (i64, i64) -> i64
      %bba8_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bba8_4 = "braid.and"(%bba8_2, %bba8_3) : (i64, i64) -> i64
      %bba8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba8_6 = "braid.eq"(%bba8_4, %bba8_5) : (i64, i64) -> i64
      "braid.guard"(%bba8_6) : (i64) -> ()
      %bba8_7 = "braid.get"() {reg = "x5"} : () -> i64
      "braid.store"(%bba8_2, %bba8_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x1020c
      %bbac_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbac_1 = "braid.const"() {value = 60 : i64} : () -> i64
      %bbac_2 = "braid.add"(%bbac_0, %bbac_1) : (i64, i64) -> i64
      %bbac_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbac_4 = "braid.and"(%bbac_2, %bbac_3) : (i64, i64) -> i64
      %bbac_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbac_6 = "braid.eq"(%bbac_4, %bbac_5) : (i64, i64) -> i64
      "braid.guard"(%bbac_6) : (i64) -> ()
      %bbac_7 = "braid.get"() {reg = "x6"} : () -> i64
      "braid.store"(%bbac_2, %bbac_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x10210
      %bbb0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbb0_1 = "braid.const"() {value = 256 : i64} : () -> i64
      %bbb0_2 = "braid.add"(%bbb0_0, %bbb0_1) : (i64, i64) -> i64
      "braid.set"(%bbb0_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x10214
      %bbb4_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbb4_1 = "braid.const"() {value = -8 : i64} : () -> i64
      %bbb4_2 = "braid.add"(%bbb4_0, %bbb4_1) : (i64, i64) -> i64
      %bbb4_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbb4_4 = "braid.and"(%bbb4_2, %bbb4_3) : (i64, i64) -> i64
      %bbb4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb4_6 = "braid.eq"(%bbb4_4, %bbb4_5) : (i64, i64) -> i64
      "braid.guard"(%bbb4_6) : (i64) -> ()
      %bbb4_7 = "braid.load"(%bbb4_2) {bytes = 4 : i64} : (i64) -> i64
      %bbb4_8 = "braid.sext"(%bbb4_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbb4_8) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x10218
      %bbb8_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbb8_1 = "braid.const"() {value = -28 : i64} : () -> i64
      %bbb8_2 = "braid.add"(%bbb8_0, %bbb8_1) : (i64, i64) -> i64
      %bbb8_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbb8_4 = "braid.and"(%bbb8_2, %bbb8_3) : (i64, i64) -> i64
      %bbb8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb8_6 = "braid.eq"(%bbb8_4, %bbb8_5) : (i64, i64) -> i64
      "braid.guard"(%bbb8_6) : (i64) -> ()
      %bbb8_7 = "braid.load"(%bbb8_2) {bytes = 4 : i64} : (i64) -> i64
      %bbb8_8 = "braid.sext"(%bbb8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbb8_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x1021c
      %bbbc_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbbc_1 = "braid.const"() {value = -60 : i64} : () -> i64
      %bbbc_2 = "braid.add"(%bbbc_0, %bbbc_1) : (i64, i64) -> i64
      %bbbc_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbbc_4 = "braid.and"(%bbbc_2, %bbbc_3) : (i64, i64) -> i64
      %bbbc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbbc_6 = "braid.eq"(%bbbc_4, %bbbc_5) : (i64, i64) -> i64
      "braid.guard"(%bbbc_6) : (i64) -> ()
      %bbbc_7 = "braid.load"(%bbbc_2) {bytes = 4 : i64} : (i64) -> i64
      %bbbc_8 = "braid.sext"(%bbbc_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbbc_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bbc0:  // 0x10220
      %bbc0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbc0_1 = "braid.const"() {value = -64 : i64} : () -> i64
      %bbc0_2 = "braid.add"(%bbc0_0, %bbc0_1) : (i64, i64) -> i64
      %bbc0_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbc0_4 = "braid.and"(%bbc0_2, %bbc0_3) : (i64, i64) -> i64
      %bbc0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc0_6 = "braid.eq"(%bbc0_4, %bbc0_5) : (i64, i64) -> i64
      "braid.guard"(%bbc0_6) : (i64) -> ()
      %bbc0_7 = "braid.load"(%bbc0_2) {bytes = 4 : i64} : (i64) -> i64
      %bbc0_8 = "braid.sext"(%bbc0_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbc0_8) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x10224
      %bbc4_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbc4_1 = "braid.zext"(%bbc4_0) {bits = 32 : i64} : (i64) -> i64
      %bbc4_2 = "braid.const"() {value = 17 : i64} : () -> i64
      %bbc4_3 = "braid.lshr"(%bbc4_1, %bbc4_2) : (i64, i64) -> i64
      %bbc4_4 = "braid.sext"(%bbc4_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbc4_4) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x10228
      %bbc8_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbc8_1 = "braid.const"() {value = 15 : i64} : () -> i64
      %bbc8_2 = "braid.shl"(%bbc8_0, %bbc8_1) : (i64, i64) -> i64
      "braid.set"(%bbc8_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x1022c
      %bbcc_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbcc_1 = "braid.zext"(%bbcc_0) {bits = 32 : i64} : (i64) -> i64
      %bbcc_2 = "braid.const"() {value = 19 : i64} : () -> i64
      %bbcc_3 = "braid.lshr"(%bbcc_1, %bbcc_2) : (i64, i64) -> i64
      %bbcc_4 = "braid.sext"(%bbcc_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbcc_4) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x10230
      %bbd0_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbd0_1 = "braid.const"() {value = 13 : i64} : () -> i64
      %bbd0_2 = "braid.shl"(%bbd0_0, %bbd0_1) : (i64, i64) -> i64
      "braid.set"(%bbd0_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x10234
      %bbd4_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bbd4_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bbd4_2 = "braid.add"(%bbd4_0, %bbd4_1) : (i64, i64) -> i64
      "braid.set"(%bbd4_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bbd8] : () -> ()
    ^bbd8:  // 0x10238
      %bbd8_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bbd8_1 = "braid.zext"(%bbd8_0) {bits = 32 : i64} : (i64) -> i64
      %bbd8_2 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbd8_3 = "braid.lshr"(%bbd8_1, %bbd8_2) : (i64, i64) -> i64
      %bbd8_4 = "braid.sext"(%bbd8_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd8_4) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x1023c
      %bbdc_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bbdc_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bbdc_2 = "braid.or"(%bbdc_0, %bbdc_1) : (i64, i64) -> i64
      "braid.set"(%bbdc_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbe0] : () -> ()
    ^bbe0:  // 0x10240
      %bbe0_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bbe0_1 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbe0_2 = "braid.shl"(%bbe0_0, %bbe0_1) : (i64, i64) -> i64
      "braid.set"(%bbe0_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x10244
      %bbe4_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bbe4_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bbe4_2 = "braid.or"(%bbe4_0, %bbe4_1) : (i64, i64) -> i64
      "braid.set"(%bbe4_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bbe8] : () -> ()
    ^bbe8:  // 0x10248
      %bbe8_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bbe8_1 = "braid.zext"(%bbe8_0) {bits = 32 : i64} : (i64) -> i64
      %bbe8_2 = "braid.const"() {value = 18 : i64} : () -> i64
      %bbe8_3 = "braid.lshr"(%bbe8_1, %bbe8_2) : (i64, i64) -> i64
      %bbe8_4 = "braid.sext"(%bbe8_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbe8_4) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bbec] : () -> ()
    ^bbec:  // 0x1024c
      %bbec_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bbec_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bbec_2 = "braid.or"(%bbec_0, %bbec_1) : (i64, i64) -> i64
      "braid.set"(%bbec_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bbf0] : () -> ()
    ^bbf0:  // 0x10250
      %bbf0_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bbf0_1 = "braid.const"() {value = 14 : i64} : () -> i64
      %bbf0_2 = "braid.shl"(%bbf0_0, %bbf0_1) : (i64, i64) -> i64
      "braid.set"(%bbf0_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bbf4] : () -> ()
    ^bbf4:  // 0x10254
      %bbf4_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bbf4_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bbf4_2 = "braid.or"(%bbf4_0, %bbf4_1) : (i64, i64) -> i64
      "braid.set"(%bbf4_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bbf8] : () -> ()
    ^bbf8:  // 0x10258
      %bbf8_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bbf8_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bbf8_2 = "braid.xor"(%bbf8_0, %bbf8_1) : (i64, i64) -> i64
      "braid.set"(%bbf8_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbfc] : () -> ()
    ^bbfc:  // 0x1025c
      %bbfc_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbfc_1 = "braid.zext"(%bbfc_0) {bits = 32 : i64} : (i64) -> i64
      %bbfc_2 = "braid.const"() {value = 10 : i64} : () -> i64
      %bbfc_3 = "braid.lshr"(%bbfc_1, %bbfc_2) : (i64, i64) -> i64
      %bbfc_4 = "braid.sext"(%bbfc_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbfc_4) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb100:  // 0x10260
      %bb100_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb100_1 = "braid.zext"(%bb100_0) {bits = 32 : i64} : (i64) -> i64
      %bb100_2 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb100_3 = "braid.lshr"(%bb100_1, %bb100_2) : (i64, i64) -> i64
      %bb100_4 = "braid.sext"(%bb100_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb100_4) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb104] : () -> ()
    ^bb104:  // 0x10264
      %bb104_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb104_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb104_2 = "braid.xor"(%bb104_0, %bb104_1) : (i64, i64) -> i64
      "braid.set"(%bb104_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x10268
      %bb108_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb108_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb108_2 = "braid.xor"(%bb108_0, %bb108_1) : (i64, i64) -> i64
      "braid.set"(%bb108_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb10c] : () -> ()
    ^bb10c:  // 0x1026c
      %bb10c_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb10c_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb10c_2 = "braid.xor"(%bb10c_0, %bb10c_1) : (i64, i64) -> i64
      "braid.set"(%bb10c_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb110] : () -> ()
    ^bb110:  // 0x10270
      %bb110_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb110_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb110_2 = "braid.add"(%bb110_0, %bb110_1) : (i64, i64) -> i64
      "braid.set"(%bb110_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb114] : () -> ()
    ^bb114:  // 0x10274
      %bb114_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb114_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb114_2 = "braid.add"(%bb114_0, %bb114_1) : (i64, i64) -> i64
      "braid.set"(%bb114_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x10278
      %bb118_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb118_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb118_2 = "braid.add"(%bb118_0, %bb118_1) : (i64, i64) -> i64
      %bb118_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb118_4 = "braid.and"(%bb118_2, %bb118_3) : (i64, i64) -> i64
      %bb118_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb118_6 = "braid.eq"(%bb118_4, %bb118_5) : (i64, i64) -> i64
      "braid.guard"(%bb118_6) : (i64) -> ()
      %bb118_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bb118_2, %bb118_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb11c] : () -> ()
    ^bb11c:  // 0x1027c
      %bb11c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb11c_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb11c_2 = "braid.add"(%bb11c_0, %bb11c_1) : (i64, i64) -> i64
      "braid.set"(%bb11c_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x10280
      %bb120_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb120_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb120_2 = "braid.ne"(%bb120_0, %bb120_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb120_2)[^bbb4, ^bb124] : (i64) -> ()
    ^bb124:  // 0x10284
      %bb124_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb124_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb124_2 = "braid.add"(%bb124_0, %bb124_1) : (i64, i64) -> i64
      %bb124_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb124_4 = "braid.and"(%bb124_2, %bb124_3) : (i64, i64) -> i64
      %bb124_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb124_6 = "braid.eq"(%bb124_4, %bb124_5) : (i64, i64) -> i64
      "braid.guard"(%bb124_6) : (i64) -> ()
      %bb124_7 = "braid.load"(%bb124_2) {bytes = 4 : i64} : (i64) -> i64
      %bb124_8 = "braid.sext"(%bb124_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb124_8) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb128] : () -> ()
    ^bb128:  // 0x10288
      %bb128_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb128_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb128_2 = "braid.add"(%bb128_0, %bb128_1) : (i64, i64) -> i64
      %bb128_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb128_4 = "braid.and"(%bb128_2, %bb128_3) : (i64, i64) -> i64
      %bb128_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb128_6 = "braid.eq"(%bb128_4, %bb128_5) : (i64, i64) -> i64
      "braid.guard"(%bb128_6) : (i64) -> ()
      %bb128_7 = "braid.load"(%bb128_2) {bytes = 4 : i64} : (i64) -> i64
      %bb128_8 = "braid.sext"(%bb128_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb128_8) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb12c] : () -> ()
    ^bb12c:  // 0x1028c
      %bb12c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb12c_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb12c_2 = "braid.add"(%bb12c_0, %bb12c_1) : (i64, i64) -> i64
      %bb12c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb12c_4 = "braid.and"(%bb12c_2, %bb12c_3) : (i64, i64) -> i64
      %bb12c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12c_6 = "braid.eq"(%bb12c_4, %bb12c_5) : (i64, i64) -> i64
      "braid.guard"(%bb12c_6) : (i64) -> ()
      %bb12c_7 = "braid.load"(%bb12c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb12c_8 = "braid.sext"(%bb12c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb12c_8) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb130] : () -> ()
    ^bb130:  // 0x10290
      %bb130_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb130_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb130_2 = "braid.add"(%bb130_0, %bb130_1) : (i64, i64) -> i64
      %bb130_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb130_4 = "braid.and"(%bb130_2, %bb130_3) : (i64, i64) -> i64
      %bb130_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb130_6 = "braid.eq"(%bb130_4, %bb130_5) : (i64, i64) -> i64
      "braid.guard"(%bb130_6) : (i64) -> ()
      %bb130_7 = "braid.load"(%bb130_2) {bytes = 4 : i64} : (i64) -> i64
      %bb130_8 = "braid.sext"(%bb130_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb130_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb134:  // 0x10294
      %bb134_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb134_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb134_2 = "braid.add"(%bb134_0, %bb134_1) : (i64, i64) -> i64
      %bb134_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb134_4 = "braid.and"(%bb134_2, %bb134_3) : (i64, i64) -> i64
      %bb134_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb134_6 = "braid.eq"(%bb134_4, %bb134_5) : (i64, i64) -> i64
      "braid.guard"(%bb134_6) : (i64) -> ()
      %bb134_7 = "braid.load"(%bb134_2) {bytes = 4 : i64} : (i64) -> i64
      %bb134_8 = "braid.sext"(%bb134_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb134_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb138] : () -> ()
    ^bb138:  // 0x10298
      %bb138_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb138_1 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb138_2 = "braid.add"(%bb138_0, %bb138_1) : (i64, i64) -> i64
      %bb138_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb138_4 = "braid.and"(%bb138_2, %bb138_3) : (i64, i64) -> i64
      %bb138_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb138_6 = "braid.eq"(%bb138_4, %bb138_5) : (i64, i64) -> i64
      "braid.guard"(%bb138_6) : (i64) -> ()
      %bb138_7 = "braid.load"(%bb138_2) {bytes = 4 : i64} : (i64) -> i64
      %bb138_8 = "braid.sext"(%bb138_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb138_8) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb13c] : () -> ()
    ^bb13c:  // 0x1029c
      %bb13c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb13c_1 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb13c_2 = "braid.add"(%bb13c_0, %bb13c_1) : (i64, i64) -> i64
      %bb13c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb13c_4 = "braid.and"(%bb13c_2, %bb13c_3) : (i64, i64) -> i64
      %bb13c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb13c_6 = "braid.eq"(%bb13c_4, %bb13c_5) : (i64, i64) -> i64
      "braid.guard"(%bb13c_6) : (i64) -> ()
      %bb13c_7 = "braid.load"(%bb13c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb13c_8 = "braid.sext"(%bb13c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb13c_8) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb140] : () -> ()
    ^bb140:  // 0x102a0
      %bb140_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb140_1 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb140_2 = "braid.add"(%bb140_0, %bb140_1) : (i64, i64) -> i64
      %bb140_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb140_4 = "braid.and"(%bb140_2, %bb140_3) : (i64, i64) -> i64
      %bb140_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb140_6 = "braid.eq"(%bb140_4, %bb140_5) : (i64, i64) -> i64
      "braid.guard"(%bb140_6) : (i64) -> ()
      %bb140_7 = "braid.load"(%bb140_2) {bytes = 4 : i64} : (i64) -> i64
      %bb140_8 = "braid.sext"(%bb140_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb140_8) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb144] : () -> ()
    ^bb144:  // 0x102a4
      %bb144_0 = "braid.const"() {value = 65536 : i64} : () -> i64
      "braid.set"(%bb144_0) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb148] : () -> ()
    ^bb148:  // 0x102a8
      %bb148_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb148_1 = "braid.const"() {value = 1028 : i64} : () -> i64
      %bb148_2 = "braid.add"(%bb148_0, %bb148_1) : (i64, i64) -> i64
      "braid.set"(%bb148_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb14c] : () -> ()
    ^bb14c:  // 0x102ac
      %bb14c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb14c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14c_2 = "braid.add"(%bb14c_0, %bb14c_1) : (i64, i64) -> i64
      "braid.set"(%bb14c_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb150] : () -> ()
    ^bb150:  // 0x102b0
      %bb150_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb150_1 = "braid.const"() {value = 256 : i64} : () -> i64
      %bb150_2 = "braid.add"(%bb150_0, %bb150_1) : (i64, i64) -> i64
      "braid.set"(%bb150_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb154] : () -> ()
    ^bb154:  // 0x102b4
      %bb154_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb154_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb154_2 = "braid.add"(%bb154_0, %bb154_1) : (i64, i64) -> i64
      "braid.set"(%bb154_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb158] : () -> ()
    ^bb158:  // 0x102b8
      %bb158_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb158_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb158_2 = "braid.add"(%bb158_0, %bb158_1) : (i64, i64) -> i64
      "braid.set"(%bb158_2) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb15c] : () -> ()
    ^bb15c:  // 0x102bc
      %bb15c_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb15c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15c_2 = "braid.add"(%bb15c_0, %bb15c_1) : (i64, i64) -> i64
      "braid.set"(%bb15c_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb160] : () -> ()
    ^bb160:  // 0x102c0
      %bb160_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb160_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb160_2 = "braid.add"(%bb160_0, %bb160_1) : (i64, i64) -> i64
      "braid.set"(%bb160_2) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb164] : () -> ()
    ^bb164:  // 0x102c4
      %bb164_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb164_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb164_2 = "braid.add"(%bb164_0, %bb164_1) : (i64, i64) -> i64
      "braid.set"(%bb164_2) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb168] : () -> ()
    ^bb168:  // 0x102c8
      %bb168_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb168_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb168_2 = "braid.add"(%bb168_0, %bb168_1) : (i64, i64) -> i64
      "braid.set"(%bb168_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb16c] : () -> ()
    ^bb16c:  // 0x102cc
      %bb16c_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb16c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb16c_2 = "braid.add"(%bb16c_0, %bb16c_1) : (i64, i64) -> i64
      "braid.set"(%bb16c_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb170] : () -> ()
    ^bb170:  // 0x102d0
      %bb170_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb170_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb170_2 = "braid.add"(%bb170_0, %bb170_1) : (i64, i64) -> i64
      "braid.set"(%bb170_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb174] : () -> ()
    ^bb174:  // 0x102d4
      %bb174_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb174_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb174_2 = "braid.add"(%bb174_0, %bb174_1) : (i64, i64) -> i64
      "braid.set"(%bb174_2) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb178] : () -> ()
    ^bb178:  // 0x102d8
      %bb178_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb178_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb178_2 = "braid.add"(%bb178_0, %bb178_1) : (i64, i64) -> i64
      "braid.set"(%bb178_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb17c] : () -> ()
    ^bb17c:  // 0x102dc
      %bb17c_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb17c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb17c_2 = "braid.add"(%bb17c_0, %bb17c_1) : (i64, i64) -> i64
      "braid.set"(%bb17c_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb180] : () -> ()
    ^bb180:  // 0x102e0
      %bb180_0 = "braid.get"() {reg = "x20"} : () -> i64
      %bb180_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb180_2 = "braid.add"(%bb180_0, %bb180_1) : (i64, i64) -> i64
      "braid.set"(%bb180_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb184] : () -> ()
    ^bb184:  // 0x102e4
      %bb184_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb184_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb184_2 = "braid.add"(%bb184_0, %bb184_1) : (i64, i64) -> i64
      %bb184_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb184_4 = "braid.and"(%bb184_2, %bb184_3) : (i64, i64) -> i64
      %bb184_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb184_6 = "braid.eq"(%bb184_4, %bb184_5) : (i64, i64) -> i64
      "braid.guard"(%bb184_6) : (i64) -> ()
      %bb184_7 = "braid.load"(%bb184_2) {bytes = 4 : i64} : (i64) -> i64
      %bb184_8 = "braid.sext"(%bb184_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb184_8) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb188] : () -> ()
    ^bb188:  // 0x102e8
      %bb188_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb188_1 = "braid.zext"(%bb188_0) {bits = 32 : i64} : (i64) -> i64
      %bb188_2 = "braid.const"() {value = 6 : i64} : () -> i64
      %bb188_3 = "braid.lshr"(%bb188_1, %bb188_2) : (i64, i64) -> i64
      %bb188_4 = "braid.sext"(%bb188_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb188_4) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb18c] : () -> ()
    ^bb18c:  // 0x102ec
      %bb18c_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb18c_1 = "braid.const"() {value = 26 : i64} : () -> i64
      %bb18c_2 = "braid.shl"(%bb18c_0, %bb18c_1) : (i64, i64) -> i64
      "braid.set"(%bb18c_2) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x102f0
      %bb190_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb190_1 = "braid.zext"(%bb190_0) {bits = 32 : i64} : (i64) -> i64
      %bb190_2 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb190_3 = "braid.lshr"(%bb190_1, %bb190_2) : (i64, i64) -> i64
      %bb190_4 = "braid.sext"(%bb190_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb190_4) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bb194] : () -> ()
    ^bb194:  // 0x102f4
      %bb194_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb194_1 = "braid.const"() {value = 21 : i64} : () -> i64
      %bb194_2 = "braid.shl"(%bb194_0, %bb194_1) : (i64, i64) -> i64
      "braid.set"(%bb194_2) {reg = "x25"} : (i64) -> ()
      "braid_cf.br"()[^bb198] : () -> ()
    ^bb198:  // 0x102f8
      %bb198_0 = "braid.get"() {reg = "x23"} : () -> i64
      %bb198_1 = "braid.get"() {reg = "x22"} : () -> i64
      %bb198_2 = "braid.or"(%bb198_0, %bb198_1) : (i64, i64) -> i64
      "braid.set"(%bb198_2) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb19c] : () -> ()
    ^bb19c:  // 0x102fc
      %bb19c_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb19c_1 = "braid.zext"(%bb19c_0) {bits = 32 : i64} : (i64) -> i64
      %bb19c_2 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb19c_3 = "braid.lshr"(%bb19c_1, %bb19c_2) : (i64, i64) -> i64
      %bb19c_4 = "braid.sext"(%bb19c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb19c_4) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb1a0] : () -> ()
    ^bb1a0:  // 0x10300
      %bb1a0_0 = "braid.get"() {reg = "x25"} : () -> i64
      %bb1a0_1 = "braid.get"() {reg = "x24"} : () -> i64
      %bb1a0_2 = "braid.or"(%bb1a0_0, %bb1a0_1) : (i64, i64) -> i64
      "braid.set"(%bb1a0_2) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bb1a4] : () -> ()
    ^bb1a4:  // 0x10304
      %bb1a4_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb1a4_1 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1a4_2 = "braid.shl"(%bb1a4_0, %bb1a4_1) : (i64, i64) -> i64
      "braid.set"(%bb1a4_2) {reg = "x25"} : (i64) -> ()
      "braid_cf.br"()[^bb1a8] : () -> ()
    ^bb1a8:  // 0x10308
      %bb1a8_0 = "braid.get"() {reg = "x25"} : () -> i64
      %bb1a8_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bb1a8_2 = "braid.or"(%bb1a8_0, %bb1a8_1) : (i64, i64) -> i64
      "braid.set"(%bb1a8_2) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb1ac] : () -> ()
    ^bb1ac:  // 0x1030c
      %bb1ac_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb1ac_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1ac_2 = "braid.add"(%bb1ac_0, %bb1ac_1) : (i64, i64) -> i64
      %bb1ac_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1ac_4 = "braid.and"(%bb1ac_2, %bb1ac_3) : (i64, i64) -> i64
      %bb1ac_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1ac_6 = "braid.eq"(%bb1ac_4, %bb1ac_5) : (i64, i64) -> i64
      "braid.guard"(%bb1ac_6) : (i64) -> ()
      %bb1ac_7 = "braid.load"(%bb1ac_2) {bytes = 4 : i64} : (i64) -> i64
      %bb1ac_8 = "braid.sext"(%bb1ac_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1ac_8) {reg = "x25"} : (i64) -> ()
      "braid_cf.br"()[^bb1b0] : () -> ()
    ^bb1b0:  // 0x10310
      %bb1b0_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bb1b0_1 = "braid.get"() {reg = "x24"} : () -> i64
      %bb1b0_2 = "braid.xor"(%bb1b0_0, %bb1b0_1) : (i64, i64) -> i64
      "braid.set"(%bb1b0_2) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb1b4] : () -> ()
    ^bb1b4:  // 0x10314
      %bb1b4_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb1b4_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb1b4_2 = "braid.xor"(%bb1b4_0, %bb1b4_1) : (i64, i64) -> i64
      "braid.set"(%bb1b4_2) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bb1b8] : () -> ()
    ^bb1b8:  // 0x10318
      %bb1b8_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb1b8_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1b8_2 = "braid.add"(%bb1b8_0, %bb1b8_1) : (i64, i64) -> i64
      "braid.set"(%bb1b8_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb1bc] : () -> ()
    ^bb1bc:  // 0x1031c
      %bb1bc_0 = "braid.get"() {reg = "x24"} : () -> i64
      %bb1bc_1 = "braid.get"() {reg = "x28"} : () -> i64
      %bb1bc_2 = "braid.and"(%bb1bc_0, %bb1bc_1) : (i64, i64) -> i64
      "braid.set"(%bb1bc_2) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bb1c0] : () -> ()
    ^bb1c0:  // 0x10320
      %bb1c0_0 = "braid.get"() {reg = "x24"} : () -> i64
      %bb1c0_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb1c0_2 = "braid.xor"(%bb1c0_0, %bb1c0_1) : (i64, i64) -> i64
      "braid.set"(%bb1c0_2) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bb1c4] : () -> ()
    ^bb1c4:  // 0x10324
      %bb1c4_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bb1c4_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bb1c4_2 = "braid.xor"(%bb1c4_0, %bb1c4_1) : (i64, i64) -> i64
      "braid.set"(%bb1c4_2) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb1c8] : () -> ()
    ^bb1c8:  // 0x10328
      %bb1c8_0 = "braid.get"() {reg = "x25"} : () -> i64
      %bb1c8_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb1c8_2 = "braid.add"(%bb1c8_0, %bb1c8_1) : (i64, i64) -> i64
      "braid.set"(%bb1c8_2) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb1cc] : () -> ()
    ^bb1cc:  // 0x1032c
      %bb1cc_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bb1cc_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb1cc_2 = "braid.add"(%bb1cc_0, %bb1cc_1) : (i64, i64) -> i64
      "braid.set"(%bb1cc_2) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb1d0] : () -> ()
    ^bb1d0:  // 0x10330
      %bb1d0_0 = "braid.get"() {reg = "x20"} : () -> i64
      %bb1d0_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb1d0_2 = "braid.add"(%bb1d0_0, %bb1d0_1) : (i64, i64) -> i64
      "braid.set"(%bb1d0_2) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb1d4] : () -> ()
    ^bb1d4:  // 0x10334
      %bb1d4_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb1d4_1 = "braid.get"() {reg = "x24"} : () -> i64
      %bb1d4_2 = "braid.add"(%bb1d4_0, %bb1d4_1) : (i64, i64) -> i64
      "braid.set"(%bb1d4_2) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb1d8] : () -> ()
    ^bb1d8:  // 0x10338
      %bb1d8_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb1d8_1 = "braid.get"() {reg = "x21"} : () -> i64
      %bb1d8_2 = "braid.add"(%bb1d8_0, %bb1d8_1) : (i64, i64) -> i64
      "braid.set"(%bb1d8_2) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb1dc] : () -> ()
    ^bb1dc:  // 0x1033c
      %bb1dc_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1dc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1dc_2 = "braid.add"(%bb1dc_0, %bb1dc_1) : (i64, i64) -> i64
      "braid.set"(%bb1dc_2) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb1e0] : () -> ()
    ^bb1e0:  // 0x10340
      %bb1e0_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1e0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e0_2 = "braid.add"(%bb1e0_0, %bb1e0_1) : (i64, i64) -> i64
      "braid.set"(%bb1e0_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1e4] : () -> ()
    ^bb1e4:  // 0x10344
      %bb1e4_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb1e4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e4_2 = "braid.add"(%bb1e4_0, %bb1e4_1) : (i64, i64) -> i64
      "braid.set"(%bb1e4_2) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb1e8] : () -> ()
    ^bb1e8:  // 0x10348
      %bb1e8_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb1e8_1 = "braid.zext"(%bb1e8_0) {bits = 32 : i64} : (i64) -> i64
      %bb1e8_2 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb1e8_3 = "braid.lshr"(%bb1e8_1, %bb1e8_2) : (i64, i64) -> i64
      %bb1e8_4 = "braid.sext"(%bb1e8_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1e8_4) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb1ec] : () -> ()
    ^bb1ec:  // 0x1034c
      %bb1ec_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1ec_1 = "braid.const"() {value = 30 : i64} : () -> i64
      %bb1ec_2 = "braid.shl"(%bb1ec_0, %bb1ec_1) : (i64, i64) -> i64
      "braid.set"(%bb1ec_2) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb1f0] : () -> ()
    ^bb1f0:  // 0x10350
      %bb1f0_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1f0_1 = "braid.zext"(%bb1f0_0) {bits = 32 : i64} : (i64) -> i64
      %bb1f0_2 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb1f0_3 = "braid.lshr"(%bb1f0_1, %bb1f0_2) : (i64, i64) -> i64
      %bb1f0_4 = "braid.sext"(%bb1f0_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1f0_4) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb1f4] : () -> ()
    ^bb1f4:  // 0x10354
      %bb1f4_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1f4_1 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb1f4_2 = "braid.shl"(%bb1f4_0, %bb1f4_1) : (i64, i64) -> i64
      "braid.set"(%bb1f4_2) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bb1f8] : () -> ()
    ^bb1f8:  // 0x10358
      %bb1f8_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1f8_1 = "braid.zext"(%bb1f8_0) {bits = 32 : i64} : (i64) -> i64
      %bb1f8_2 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb1f8_3 = "braid.lshr"(%bb1f8_1, %bb1f8_2) : (i64, i64) -> i64
      %bb1f8_4 = "braid.sext"(%bb1f8_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1f8_4) {reg = "x25"} : (i64) -> ()
      "braid_cf.br"()[^bb1fc] : () -> ()
    ^bb1fc:  // 0x1035c
      %bb1fc_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bb1fc_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb1fc_2 = "braid.or"(%bb1fc_0, %bb1fc_1) : (i64, i64) -> i64
      "braid.set"(%bb1fc_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb200] : () -> ()
    ^bb200:  // 0x10360
      %bb200_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb200_1 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb200_2 = "braid.shl"(%bb200_0, %bb200_1) : (i64, i64) -> i64
      "braid.set"(%bb200_2) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb204] : () -> ()
    ^bb204:  // 0x10364
      %bb204_0 = "braid.get"() {reg = "x24"} : () -> i64
      %bb204_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bb204_2 = "braid.or"(%bb204_0, %bb204_1) : (i64, i64) -> i64
      "braid.set"(%bb204_2) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb208] : () -> ()
    ^bb208:  // 0x10368
      %bb208_0 = "braid.get"() {reg = "x21"} : () -> i64
      %bb208_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb208_2 = "braid.xor"(%bb208_0, %bb208_1) : (i64, i64) -> i64
      "braid.set"(%bb208_2) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bb20c] : () -> ()
    ^bb20c:  // 0x1036c
      %bb20c_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bb20c_1 = "braid.get"() {reg = "x25"} : () -> i64
      %bb20c_2 = "braid.or"(%bb20c_0, %bb20c_1) : (i64, i64) -> i64
      "braid.set"(%bb20c_2) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb210] : () -> ()
    ^bb210:  // 0x10370
      %bb210_0 = "braid.get"() {reg = "x21"} : () -> i64
      %bb210_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb210_2 = "braid.and"(%bb210_0, %bb210_1) : (i64, i64) -> i64
      "braid.set"(%bb210_2) {reg = "x25"} : (i64) -> ()
      "braid_cf.br"()[^bb214] : () -> ()
    ^bb214:  // 0x10374
      %bb214_0 = "braid.get"() {reg = "x24"} : () -> i64
      %bb214_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb214_2 = "braid.and"(%bb214_0, %bb214_1) : (i64, i64) -> i64
      "braid.set"(%bb214_2) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bb218] : () -> ()
    ^bb218:  // 0x10378
      %bb218_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb218_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bb218_2 = "braid.xor"(%bb218_0, %bb218_1) : (i64, i64) -> i64
      "braid.set"(%bb218_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb21c] : () -> ()
    ^bb21c:  // 0x1037c
      %bb21c_0 = "braid.get"() {reg = "x24"} : () -> i64
      %bb21c_1 = "braid.get"() {reg = "x25"} : () -> i64
      %bb21c_2 = "braid.xor"(%bb21c_0, %bb21c_1) : (i64, i64) -> i64
      "braid.set"(%bb21c_2) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb220] : () -> ()
    ^bb220:  // 0x10380
      %bb220_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb220_1 = "braid.get"() {reg = "x22"} : () -> i64
      %bb220_2 = "braid.xor"(%bb220_0, %bb220_1) : (i64, i64) -> i64
      "braid.set"(%bb220_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb224] : () -> ()
    ^bb224:  // 0x10384
      %bb224_0 = "braid.get"() {reg = "x23"} : () -> i64
      %bb224_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb224_2 = "braid.add"(%bb224_0, %bb224_1) : (i64, i64) -> i64
      "braid.set"(%bb224_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb228] : () -> ()
    ^bb228:  // 0x10388
      %bb228_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb228_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb228_2 = "braid.add"(%bb228_0, %bb228_1) : (i64, i64) -> i64
      "braid.set"(%bb228_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb22c] : () -> ()
    ^bb22c:  // 0x1038c
      %bb22c_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb22c_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb22c_2 = "braid.add"(%bb22c_0, %bb22c_1) : (i64, i64) -> i64
      "braid.set"(%bb22c_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb230] : () -> ()
    ^bb230:  // 0x10390
      %bb230_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb230_1 = "braid.get"() {reg = "x31"} : () -> i64
      %bb230_2 = "braid.ne"(%bb230_0, %bb230_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb230_2)[^bb174, ^bb234] : (i64) -> ()
    ^bb234:  // 0x10394
      %bb234_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb234_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb234_2 = "braid.add"(%bb234_0, %bb234_1) : (i64, i64) -> i64
      "braid.set"(%bb234_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb238] : () -> ()
    ^bb238:  // 0x10398
      %bb238_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb238_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb238_2 = "braid.add"(%bb238_0, %bb238_1) : (i64, i64) -> i64
      "braid.set"(%bb238_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb23c] : () -> ()
    ^bb23c:  // 0x1039c
      %bb23c_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb23c_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb23c_2 = "braid.add"(%bb23c_0, %bb23c_1) : (i64, i64) -> i64
      "braid.set"(%bb23c_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb240] : () -> ()
    ^bb240:  // 0x103a0
      %bb240_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb240_1 = "braid.get"() {reg = "x21"} : () -> i64
      %bb240_2 = "braid.add"(%bb240_0, %bb240_1) : (i64, i64) -> i64
      "braid.set"(%bb240_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb244] : () -> ()
    ^bb244:  // 0x103a4
      %bb244_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb244_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb244_2 = "braid.add"(%bb244_0, %bb244_1) : (i64, i64) -> i64
      "braid.set"(%bb244_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb248] : () -> ()
    ^bb248:  // 0x103a8
      %bb248_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb248_1 = "braid.get"() {reg = "x28"} : () -> i64
      %bb248_2 = "braid.add"(%bb248_0, %bb248_1) : (i64, i64) -> i64
      "braid.set"(%bb248_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb24c] : () -> ()
    ^bb24c:  // 0x103ac
      %bb24c_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb24c_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb24c_2 = "braid.add"(%bb24c_0, %bb24c_1) : (i64, i64) -> i64
      "braid.set"(%bb24c_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb250] : () -> ()
    ^bb250:  // 0x103b0
      %bb250_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb250_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb250_2 = "braid.add"(%bb250_0, %bb250_1) : (i64, i64) -> i64
      "braid.set"(%bb250_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb254] : () -> ()
    ^bb254:  // 0x103b4
      %bb254_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb254_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb254_2 = "braid.add"(%bb254_0, %bb254_1) : (i64, i64) -> i64
      %bb254_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb254_4 = "braid.and"(%bb254_2, %bb254_3) : (i64, i64) -> i64
      %bb254_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb254_6 = "braid.eq"(%bb254_4, %bb254_5) : (i64, i64) -> i64
      "braid.guard"(%bb254_6) : (i64) -> ()
      %bb254_7 = "braid.get"() {reg = "x5"} : () -> i64
      "braid.store"(%bb254_2, %bb254_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb258] : () -> ()
    ^bb258:  // 0x103b8
      %bb258_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb258_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb258_2 = "braid.add"(%bb258_0, %bb258_1) : (i64, i64) -> i64
      %bb258_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb258_4 = "braid.and"(%bb258_2, %bb258_3) : (i64, i64) -> i64
      %bb258_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb258_6 = "braid.eq"(%bb258_4, %bb258_5) : (i64, i64) -> i64
      "braid.guard"(%bb258_6) : (i64) -> ()
      %bb258_7 = "braid.get"() {reg = "x17"} : () -> i64
      "braid.store"(%bb258_2, %bb258_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb25c] : () -> ()
    ^bb25c:  // 0x103bc
      %bb25c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb25c_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb25c_2 = "braid.add"(%bb25c_0, %bb25c_1) : (i64, i64) -> i64
      %bb25c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb25c_4 = "braid.and"(%bb25c_2, %bb25c_3) : (i64, i64) -> i64
      %bb25c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb25c_6 = "braid.eq"(%bb25c_4, %bb25c_5) : (i64, i64) -> i64
      "braid.guard"(%bb25c_6) : (i64) -> ()
      %bb25c_7 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.store"(%bb25c_2, %bb25c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb260] : () -> ()
    ^bb260:  // 0x103c0
      %bb260_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb260_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb260_2 = "braid.add"(%bb260_0, %bb260_1) : (i64, i64) -> i64
      %bb260_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb260_4 = "braid.and"(%bb260_2, %bb260_3) : (i64, i64) -> i64
      %bb260_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb260_6 = "braid.eq"(%bb260_4, %bb260_5) : (i64, i64) -> i64
      "braid.guard"(%bb260_6) : (i64) -> ()
      %bb260_7 = "braid.get"() {reg = "x15"} : () -> i64
      "braid.store"(%bb260_2, %bb260_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb264] : () -> ()
    ^bb264:  // 0x103c4
      %bb264_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb264_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb264_2 = "braid.add"(%bb264_0, %bb264_1) : (i64, i64) -> i64
      %bb264_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb264_4 = "braid.and"(%bb264_2, %bb264_3) : (i64, i64) -> i64
      %bb264_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb264_6 = "braid.eq"(%bb264_4, %bb264_5) : (i64, i64) -> i64
      "braid.guard"(%bb264_6) : (i64) -> ()
      %bb264_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bb264_2, %bb264_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb268] : () -> ()
    ^bb268:  // 0x103c8
      %bb268_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb268_1 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb268_2 = "braid.add"(%bb268_0, %bb268_1) : (i64, i64) -> i64
      %bb268_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb268_4 = "braid.and"(%bb268_2, %bb268_3) : (i64, i64) -> i64
      %bb268_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb268_6 = "braid.eq"(%bb268_4, %bb268_5) : (i64, i64) -> i64
      "braid.guard"(%bb268_6) : (i64) -> ()
      %bb268_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bb268_2, %bb268_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb26c] : () -> ()
    ^bb26c:  // 0x103cc
      %bb26c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb26c_1 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb26c_2 = "braid.add"(%bb26c_0, %bb26c_1) : (i64, i64) -> i64
      %bb26c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb26c_4 = "braid.and"(%bb26c_2, %bb26c_3) : (i64, i64) -> i64
      %bb26c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb26c_6 = "braid.eq"(%bb26c_4, %bb26c_5) : (i64, i64) -> i64
      "braid.guard"(%bb26c_6) : (i64) -> ()
      %bb26c_7 = "braid.get"() {reg = "x12"} : () -> i64
      "braid.store"(%bb26c_2, %bb26c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb270] : () -> ()
    ^bb270:  // 0x103d0
      %bb270_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb270_1 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb270_2 = "braid.add"(%bb270_0, %bb270_1) : (i64, i64) -> i64
      %bb270_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb270_4 = "braid.and"(%bb270_2, %bb270_3) : (i64, i64) -> i64
      %bb270_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb270_6 = "braid.eq"(%bb270_4, %bb270_5) : (i64, i64) -> i64
      "braid.guard"(%bb270_6) : (i64) -> ()
      %bb270_7 = "braid.get"() {reg = "x11"} : () -> i64
      "braid.store"(%bb270_2, %bb270_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb274] : () -> ()
    ^bb274:  // 0x103d4
      %bb274_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb274_1 = "braid.const"() {value = 328 : i64} : () -> i64
      %bb274_2 = "braid.add"(%bb274_0, %bb274_1) : (i64, i64) -> i64
      %bb274_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb274_4 = "braid.and"(%bb274_2, %bb274_3) : (i64, i64) -> i64
      %bb274_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb274_6 = "braid.eq"(%bb274_4, %bb274_5) : (i64, i64) -> i64
      "braid.guard"(%bb274_6) : (i64) -> ()
      %bb274_7 = "braid.load"(%bb274_2) {bytes = 8 : i64} : (i64) -> i64
      %bb274_8 = "braid.zext"(%bb274_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb274_8) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb278] : () -> ()
    ^bb278:  // 0x103d8
      %bb278_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb278_1 = "braid.const"() {value = 320 : i64} : () -> i64
      %bb278_2 = "braid.add"(%bb278_0, %bb278_1) : (i64, i64) -> i64
      %bb278_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb278_4 = "braid.and"(%bb278_2, %bb278_3) : (i64, i64) -> i64
      %bb278_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb278_6 = "braid.eq"(%bb278_4, %bb278_5) : (i64, i64) -> i64
      "braid.guard"(%bb278_6) : (i64) -> ()
      %bb278_7 = "braid.load"(%bb278_2) {bytes = 8 : i64} : (i64) -> i64
      %bb278_8 = "braid.zext"(%bb278_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb278_8) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb27c] : () -> ()
    ^bb27c:  // 0x103dc
      %bb27c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb27c_1 = "braid.const"() {value = 312 : i64} : () -> i64
      %bb27c_2 = "braid.add"(%bb27c_0, %bb27c_1) : (i64, i64) -> i64
      %bb27c_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb27c_4 = "braid.and"(%bb27c_2, %bb27c_3) : (i64, i64) -> i64
      %bb27c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb27c_6 = "braid.eq"(%bb27c_4, %bb27c_5) : (i64, i64) -> i64
      "braid.guard"(%bb27c_6) : (i64) -> ()
      %bb27c_7 = "braid.load"(%bb27c_2) {bytes = 8 : i64} : (i64) -> i64
      %bb27c_8 = "braid.zext"(%bb27c_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb27c_8) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb280] : () -> ()
    ^bb280:  // 0x103e0
      %bb280_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb280_1 = "braid.const"() {value = 304 : i64} : () -> i64
      %bb280_2 = "braid.add"(%bb280_0, %bb280_1) : (i64, i64) -> i64
      %bb280_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb280_4 = "braid.and"(%bb280_2, %bb280_3) : (i64, i64) -> i64
      %bb280_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb280_6 = "braid.eq"(%bb280_4, %bb280_5) : (i64, i64) -> i64
      "braid.guard"(%bb280_6) : (i64) -> ()
      %bb280_7 = "braid.load"(%bb280_2) {bytes = 8 : i64} : (i64) -> i64
      %bb280_8 = "braid.zext"(%bb280_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb280_8) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb284] : () -> ()
    ^bb284:  // 0x103e4
      %bb284_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb284_1 = "braid.const"() {value = 296 : i64} : () -> i64
      %bb284_2 = "braid.add"(%bb284_0, %bb284_1) : (i64, i64) -> i64
      %bb284_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb284_4 = "braid.and"(%bb284_2, %bb284_3) : (i64, i64) -> i64
      %bb284_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb284_6 = "braid.eq"(%bb284_4, %bb284_5) : (i64, i64) -> i64
      "braid.guard"(%bb284_6) : (i64) -> ()
      %bb284_7 = "braid.load"(%bb284_2) {bytes = 8 : i64} : (i64) -> i64
      %bb284_8 = "braid.zext"(%bb284_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb284_8) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb288] : () -> ()
    ^bb288:  // 0x103e8
      %bb288_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb288_1 = "braid.const"() {value = 288 : i64} : () -> i64
      %bb288_2 = "braid.add"(%bb288_0, %bb288_1) : (i64, i64) -> i64
      %bb288_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb288_4 = "braid.and"(%bb288_2, %bb288_3) : (i64, i64) -> i64
      %bb288_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb288_6 = "braid.eq"(%bb288_4, %bb288_5) : (i64, i64) -> i64
      "braid.guard"(%bb288_6) : (i64) -> ()
      %bb288_7 = "braid.load"(%bb288_2) {bytes = 8 : i64} : (i64) -> i64
      %bb288_8 = "braid.zext"(%bb288_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb288_8) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb28c] : () -> ()
    ^bb28c:  // 0x103ec
      %bb28c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb28c_1 = "braid.const"() {value = 280 : i64} : () -> i64
      %bb28c_2 = "braid.add"(%bb28c_0, %bb28c_1) : (i64, i64) -> i64
      %bb28c_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb28c_4 = "braid.and"(%bb28c_2, %bb28c_3) : (i64, i64) -> i64
      %bb28c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28c_6 = "braid.eq"(%bb28c_4, %bb28c_5) : (i64, i64) -> i64
      "braid.guard"(%bb28c_6) : (i64) -> ()
      %bb28c_7 = "braid.load"(%bb28c_2) {bytes = 8 : i64} : (i64) -> i64
      %bb28c_8 = "braid.zext"(%bb28c_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb28c_8) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb290] : () -> ()
    ^bb290:  // 0x103f0
      %bb290_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb290_1 = "braid.const"() {value = 272 : i64} : () -> i64
      %bb290_2 = "braid.add"(%bb290_0, %bb290_1) : (i64, i64) -> i64
      %bb290_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb290_4 = "braid.and"(%bb290_2, %bb290_3) : (i64, i64) -> i64
      %bb290_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb290_6 = "braid.eq"(%bb290_4, %bb290_5) : (i64, i64) -> i64
      "braid.guard"(%bb290_6) : (i64) -> ()
      %bb290_7 = "braid.load"(%bb290_2) {bytes = 8 : i64} : (i64) -> i64
      %bb290_8 = "braid.zext"(%bb290_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb290_8) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb294] : () -> ()
    ^bb294:  // 0x103f4
      %bb294_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb294_1 = "braid.const"() {value = 264 : i64} : () -> i64
      %bb294_2 = "braid.add"(%bb294_0, %bb294_1) : (i64, i64) -> i64
      %bb294_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb294_4 = "braid.and"(%bb294_2, %bb294_3) : (i64, i64) -> i64
      %bb294_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb294_6 = "braid.eq"(%bb294_4, %bb294_5) : (i64, i64) -> i64
      "braid.guard"(%bb294_6) : (i64) -> ()
      %bb294_7 = "braid.load"(%bb294_2) {bytes = 8 : i64} : (i64) -> i64
      %bb294_8 = "braid.zext"(%bb294_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb294_8) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bb298] : () -> ()
    ^bb298:  // 0x103f8
      %bb298_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb298_1 = "braid.const"() {value = 256 : i64} : () -> i64
      %bb298_2 = "braid.add"(%bb298_0, %bb298_1) : (i64, i64) -> i64
      %bb298_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb298_4 = "braid.and"(%bb298_2, %bb298_3) : (i64, i64) -> i64
      %bb298_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb298_6 = "braid.eq"(%bb298_4, %bb298_5) : (i64, i64) -> i64
      "braid.guard"(%bb298_6) : (i64) -> ()
      %bb298_7 = "braid.load"(%bb298_2) {bytes = 8 : i64} : (i64) -> i64
      %bb298_8 = "braid.zext"(%bb298_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb298_8) {reg = "x25"} : (i64) -> ()
      "braid_cf.br"()[^bb29c] : () -> ()
    ^bb29c:  // 0x103fc
      %bb29c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb29c_1 = "braid.const"() {value = 336 : i64} : () -> i64
      %bb29c_2 = "braid.add"(%bb29c_0, %bb29c_1) : (i64, i64) -> i64
      "braid.set"(%bb29c_2) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb2a0] : () -> ()
    ^bb2a0:  // 0x10400
      %bb2a0_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb2a0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2a0_2 = "braid.add"(%bb2a0_0, %bb2a0_1) : (i64, i64) -> i64
      %bb2a0_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb2a0_4 = "braid.and"(%bb2a0_2, %bb2a0_3) : (i64, i64) -> i64
      %bb2a0_5 = "braid.const"() {value = 66564 : i64} : () -> i64
      "braid_cf.br_ind"(%bb2a0_4) : (i64) -> ()
  }) {sym_name = "sha256_compress", entry = 65888 : i64} : () -> ()
}) {arch = "riscv64"} : () -> ()
