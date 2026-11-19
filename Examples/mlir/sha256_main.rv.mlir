"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10160
      %bb0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb0_1 = "braid.const"() {value = -320 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10164
      %bb4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4_1 = "braid.const"() {value = 312 : i64} : () -> i64
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
      %bb8_1 = "braid.const"() {value = 304 : i64} : () -> i64
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
      %bbc_1 = "braid.const"() {value = 296 : i64} : () -> i64
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
      %bb10_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb10_1 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      "braid.set"(%bb10_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10174
      %bb14_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb14_1 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      "braid.set"(%bb14_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10178
      %bb18_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb18_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      %bb18_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb18_4 = "braid.and"(%bb18_2, %bb18_3) : (i64, i64) -> i64
      %bb18_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_6 = "braid.eq"(%bb18_4, %bb18_5) : (i64, i64) -> i64
      "braid.guard"(%bb18_6) : (i64) -> ()
      %bb18_7 = "braid.load"(%bb18_2) {bytes = 4 : i64} : (i64) -> i64
      %bb18_8 = "braid.sext"(%bb18_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb18_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1017c
      %bb1c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      "braid.set"(%bb1c_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10180
      %bb20_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb20_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_2 = "braid.add"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      %bb20_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb20_4 = "braid.and"(%bb20_2, %bb20_3) : (i64, i64) -> i64
      %bb20_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_6 = "braid.eq"(%bb20_4, %bb20_5) : (i64, i64) -> i64
      "braid.guard"(%bb20_6) : (i64) -> ()
      %bb20_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bb20_2, %bb20_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10184
      %bb24_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb24_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb24_2 = "braid.add"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      "braid.set"(%bb24_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10188
      %bb28_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb28_2 = "braid.ne"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb28_2)[^bb18, ^bb2c] : (i64) -> ()
    ^bb2c:  // 0x1018c
      %bb2c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb2c_1 = "braid.const"() {value = 104 : i64} : () -> i64
      %bb2c_2 = "braid.add"(%bb2c_0, %bb2c_1) : (i64, i64) -> i64
      "braid.set"(%bb2c_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10190
      %bb30_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb30_1 = "braid.const"() {value = 296 : i64} : () -> i64
      %bb30_2 = "braid.add"(%bb30_0, %bb30_1) : (i64, i64) -> i64
      "braid.set"(%bb30_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10194
      %bb34_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb34_1 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb34_2 = "braid.add"(%bb34_0, %bb34_1) : (i64, i64) -> i64
      %bb34_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb34_4 = "braid.and"(%bb34_2, %bb34_3) : (i64, i64) -> i64
      %bb34_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb34_6 = "braid.eq"(%bb34_4, %bb34_5) : (i64, i64) -> i64
      "braid.guard"(%bb34_6) : (i64) -> ()
      %bb34_7 = "braid.load"(%bb34_2) {bytes = 4 : i64} : (i64) -> i64
      %bb34_8 = "braid.sext"(%bb34_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb34_8) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x10198
      %bb38_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb38_1 = "braid.const"() {value = -28 : i64} : () -> i64
      %bb38_2 = "braid.add"(%bb38_0, %bb38_1) : (i64, i64) -> i64
      %bb38_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb38_4 = "braid.and"(%bb38_2, %bb38_3) : (i64, i64) -> i64
      %bb38_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb38_6 = "braid.eq"(%bb38_4, %bb38_5) : (i64, i64) -> i64
      "braid.guard"(%bb38_6) : (i64) -> ()
      %bb38_7 = "braid.load"(%bb38_2) {bytes = 4 : i64} : (i64) -> i64
      %bb38_8 = "braid.sext"(%bb38_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb38_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x1019c
      %bb3c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb3c_1 = "braid.const"() {value = -60 : i64} : () -> i64
      %bb3c_2 = "braid.add"(%bb3c_0, %bb3c_1) : (i64, i64) -> i64
      %bb3c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb3c_4 = "braid.and"(%bb3c_2, %bb3c_3) : (i64, i64) -> i64
      %bb3c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3c_6 = "braid.eq"(%bb3c_4, %bb3c_5) : (i64, i64) -> i64
      "braid.guard"(%bb3c_6) : (i64) -> ()
      %bb3c_7 = "braid.load"(%bb3c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb3c_8 = "braid.sext"(%bb3c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb3c_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x101a0
      %bb40_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb40_1 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb40_2 = "braid.add"(%bb40_0, %bb40_1) : (i64, i64) -> i64
      %bb40_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb40_4 = "braid.and"(%bb40_2, %bb40_3) : (i64, i64) -> i64
      %bb40_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb40_6 = "braid.eq"(%bb40_4, %bb40_5) : (i64, i64) -> i64
      "braid.guard"(%bb40_6) : (i64) -> ()
      %bb40_7 = "braid.load"(%bb40_2) {bytes = 4 : i64} : (i64) -> i64
      %bb40_8 = "braid.sext"(%bb40_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb40_8) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x101a4
      %bb44_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb44_1 = "braid.zext"(%bb44_0) {bits = 32 : i64} : (i64) -> i64
      %bb44_2 = "braid.const"() {value = 17 : i64} : () -> i64
      %bb44_3 = "braid.lshr"(%bb44_1, %bb44_2) : (i64, i64) -> i64
      %bb44_4 = "braid.sext"(%bb44_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb44_4) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x101a8
      %bb48_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb48_1 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb48_2 = "braid.shl"(%bb48_0, %bb48_1) : (i64, i64) -> i64
      "braid.set"(%bb48_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x101ac
      %bb4c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb4c_1 = "braid.zext"(%bb4c_0) {bits = 32 : i64} : (i64) -> i64
      %bb4c_2 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb4c_3 = "braid.lshr"(%bb4c_1, %bb4c_2) : (i64, i64) -> i64
      %bb4c_4 = "braid.sext"(%bb4c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb4c_4) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x101b0
      %bb50_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb50_1 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb50_2 = "braid.shl"(%bb50_0, %bb50_1) : (i64, i64) -> i64
      "braid.set"(%bb50_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x101b4
      %bb54_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb54_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb54_2 = "braid.add"(%bb54_0, %bb54_1) : (i64, i64) -> i64
      "braid.set"(%bb54_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x101b8
      %bb58_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb58_1 = "braid.zext"(%bb58_0) {bits = 32 : i64} : (i64) -> i64
      %bb58_2 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb58_3 = "braid.lshr"(%bb58_1, %bb58_2) : (i64, i64) -> i64
      %bb58_4 = "braid.sext"(%bb58_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb58_4) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x101bc
      %bb5c_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb5c_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb5c_2 = "braid.or"(%bb5c_0, %bb5c_1) : (i64, i64) -> i64
      "braid.set"(%bb5c_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x101c0
      %bb60_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb60_1 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb60_2 = "braid.shl"(%bb60_0, %bb60_1) : (i64, i64) -> i64
      "braid.set"(%bb60_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x101c4
      %bb64_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb64_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb64_2 = "braid.or"(%bb64_0, %bb64_1) : (i64, i64) -> i64
      "braid.set"(%bb64_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x101c8
      %bb68_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb68_1 = "braid.zext"(%bb68_0) {bits = 32 : i64} : (i64) -> i64
      %bb68_2 = "braid.const"() {value = 18 : i64} : () -> i64
      %bb68_3 = "braid.lshr"(%bb68_1, %bb68_2) : (i64, i64) -> i64
      %bb68_4 = "braid.sext"(%bb68_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb68_4) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x101cc
      %bb6c_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb6c_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb6c_2 = "braid.or"(%bb6c_0, %bb6c_1) : (i64, i64) -> i64
      "braid.set"(%bb6c_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x101d0
      %bb70_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb70_1 = "braid.const"() {value = 14 : i64} : () -> i64
      %bb70_2 = "braid.shl"(%bb70_0, %bb70_1) : (i64, i64) -> i64
      "braid.set"(%bb70_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x101d4
      %bb74_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb74_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb74_2 = "braid.or"(%bb74_0, %bb74_1) : (i64, i64) -> i64
      "braid.set"(%bb74_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x101d8
      %bb78_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb78_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb78_2 = "braid.xor"(%bb78_0, %bb78_1) : (i64, i64) -> i64
      "braid.set"(%bb78_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x101dc
      %bb7c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb7c_1 = "braid.zext"(%bb7c_0) {bits = 32 : i64} : (i64) -> i64
      %bb7c_2 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb7c_3 = "braid.lshr"(%bb7c_1, %bb7c_2) : (i64, i64) -> i64
      %bb7c_4 = "braid.sext"(%bb7c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb7c_4) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x101e0
      %bb80_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb80_1 = "braid.zext"(%bb80_0) {bits = 32 : i64} : (i64) -> i64
      %bb80_2 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb80_3 = "braid.lshr"(%bb80_1, %bb80_2) : (i64, i64) -> i64
      %bb80_4 = "braid.sext"(%bb80_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb80_4) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x101e4
      %bb84_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb84_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb84_2 = "braid.xor"(%bb84_0, %bb84_1) : (i64, i64) -> i64
      "braid.set"(%bb84_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x101e8
      %bb88_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb88_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb88_2 = "braid.xor"(%bb88_0, %bb88_1) : (i64, i64) -> i64
      "braid.set"(%bb88_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x101ec
      %bb8c_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb8c_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb8c_2 = "braid.xor"(%bb8c_0, %bb8c_1) : (i64, i64) -> i64
      "braid.set"(%bb8c_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x101f0
      %bb90_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb90_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb90_2 = "braid.add"(%bb90_0, %bb90_1) : (i64, i64) -> i64
      "braid.set"(%bb90_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x101f4
      %bb94_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb94_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb94_2 = "braid.add"(%bb94_0, %bb94_1) : (i64, i64) -> i64
      "braid.set"(%bb94_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x101f8
      %bb98_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb98_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb98_2 = "braid.add"(%bb98_0, %bb98_1) : (i64, i64) -> i64
      %bb98_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb98_4 = "braid.and"(%bb98_2, %bb98_3) : (i64, i64) -> i64
      %bb98_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb98_6 = "braid.eq"(%bb98_4, %bb98_5) : (i64, i64) -> i64
      "braid.guard"(%bb98_6) : (i64) -> ()
      %bb98_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bb98_2, %bb98_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x101fc
      %bb9c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb9c_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb9c_2 = "braid.add"(%bb9c_0, %bb9c_1) : (i64, i64) -> i64
      "braid.set"(%bb9c_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x10200
      %bba0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bba0_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bba0_2 = "braid.ne"(%bba0_0, %bba0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bba0_2)[^bb34, ^bba4] : (i64) -> ()
    ^bba4:  // 0x10204
      %bba4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bba4_1 = "braid.const"() {value = 32 : i64} : () -> i64
      %bba4_2 = "braid.add"(%bba4_0, %bba4_1) : (i64, i64) -> i64
      "braid.set"(%bba4_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x10208
      %bba8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bba8_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bba8_2 = "braid.add"(%bba8_0, %bba8_1) : (i64, i64) -> i64
      "braid.set"(%bba8_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x1020c
      %bbac_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbac_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbac_2 = "braid.add"(%bbac_0, %bbac_1) : (i64, i64) -> i64
      "braid.set"(%bbac_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x10210
      %bbb0_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb0_2 = "braid.add"(%bbb0_0, %bbb0_1) : (i64, i64) -> i64
      %bbb0_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbb0_4 = "braid.and"(%bbb0_2, %bbb0_3) : (i64, i64) -> i64
      %bbb0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb0_6 = "braid.eq"(%bbb0_4, %bbb0_5) : (i64, i64) -> i64
      "braid.guard"(%bbb0_6) : (i64) -> ()
      %bbb0_7 = "braid.load"(%bbb0_2) {bytes = 4 : i64} : (i64) -> i64
      %bbb0_8 = "braid.sext"(%bbb0_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbb0_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x10214
      %bbb4_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbb4_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbb4_2 = "braid.add"(%bbb4_0, %bbb4_1) : (i64, i64) -> i64
      "braid.set"(%bbb4_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x10218
      %bbb8_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bbb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb8_2 = "braid.add"(%bbb8_0, %bbb8_1) : (i64, i64) -> i64
      %bbb8_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbb8_4 = "braid.and"(%bbb8_2, %bbb8_3) : (i64, i64) -> i64
      %bbb8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb8_6 = "braid.eq"(%bbb8_4, %bbb8_5) : (i64, i64) -> i64
      "braid.guard"(%bbb8_6) : (i64) -> ()
      %bbb8_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bbb8_2, %bbb8_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x1021c
      %bbbc_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bbbc_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbbc_2 = "braid.add"(%bbbc_0, %bbbc_1) : (i64, i64) -> i64
      "braid.set"(%bbbc_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bbc0:  // 0x10220
      %bbc0_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbc0_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bbc0_2 = "braid.ne"(%bbc0_0, %bbc0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bbc0_2)[^bbb0, ^bbc4] : (i64) -> ()
    ^bbc4:  // 0x10224
      %bbc4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbc4_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbc4_2 = "braid.add"(%bbc4_0, %bbc4_1) : (i64, i64) -> i64
      %bbc4_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbc4_4 = "braid.and"(%bbc4_2, %bbc4_3) : (i64, i64) -> i64
      %bbc4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc4_6 = "braid.eq"(%bbc4_4, %bbc4_5) : (i64, i64) -> i64
      "braid.guard"(%bbc4_6) : (i64) -> ()
      %bbc4_7 = "braid.load"(%bbc4_2) {bytes = 4 : i64} : (i64) -> i64
      %bbc4_8 = "braid.sext"(%bbc4_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbc4_8) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x10228
      %bbc8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbc8_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bbc8_2 = "braid.add"(%bbc8_0, %bbc8_1) : (i64, i64) -> i64
      %bbc8_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbc8_4 = "braid.and"(%bbc8_2, %bbc8_3) : (i64, i64) -> i64
      %bbc8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc8_6 = "braid.eq"(%bbc8_4, %bbc8_5) : (i64, i64) -> i64
      "braid.guard"(%bbc8_6) : (i64) -> ()
      %bbc8_7 = "braid.load"(%bbc8_2) {bytes = 4 : i64} : (i64) -> i64
      %bbc8_8 = "braid.sext"(%bbc8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbc8_8) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x1022c
      %bbcc_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbcc_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbcc_2 = "braid.add"(%bbcc_0, %bbcc_1) : (i64, i64) -> i64
      %bbcc_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbcc_4 = "braid.and"(%bbcc_2, %bbcc_3) : (i64, i64) -> i64
      %bbcc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbcc_6 = "braid.eq"(%bbcc_4, %bbcc_5) : (i64, i64) -> i64
      "braid.guard"(%bbcc_6) : (i64) -> ()
      %bbcc_7 = "braid.load"(%bbcc_2) {bytes = 4 : i64} : (i64) -> i64
      %bbcc_8 = "braid.sext"(%bbcc_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbcc_8) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x10230
      %bbd0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbd0_1 = "braid.const"() {value = 20 : i64} : () -> i64
      %bbd0_2 = "braid.add"(%bbd0_0, %bbd0_1) : (i64, i64) -> i64
      %bbd0_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbd0_4 = "braid.and"(%bbd0_2, %bbd0_3) : (i64, i64) -> i64
      %bbd0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd0_6 = "braid.eq"(%bbd0_4, %bbd0_5) : (i64, i64) -> i64
      "braid.guard"(%bbd0_6) : (i64) -> ()
      %bbd0_7 = "braid.load"(%bbd0_2) {bytes = 4 : i64} : (i64) -> i64
      %bbd0_8 = "braid.sext"(%bbd0_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd0_8) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x10234
      %bbd4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbd4_1 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbd4_2 = "braid.add"(%bbd4_0, %bbd4_1) : (i64, i64) -> i64
      %bbd4_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbd4_4 = "braid.and"(%bbd4_2, %bbd4_3) : (i64, i64) -> i64
      %bbd4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd4_6 = "braid.eq"(%bbd4_4, %bbd4_5) : (i64, i64) -> i64
      "braid.guard"(%bbd4_6) : (i64) -> ()
      %bbd4_7 = "braid.load"(%bbd4_2) {bytes = 4 : i64} : (i64) -> i64
      %bbd4_8 = "braid.sext"(%bbd4_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd4_8) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bbd8] : () -> ()
    ^bbd8:  // 0x10238
      %bbd8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbd8_1 = "braid.const"() {value = 28 : i64} : () -> i64
      %bbd8_2 = "braid.add"(%bbd8_0, %bbd8_1) : (i64, i64) -> i64
      %bbd8_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbd8_4 = "braid.and"(%bbd8_2, %bbd8_3) : (i64, i64) -> i64
      %bbd8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd8_6 = "braid.eq"(%bbd8_4, %bbd8_5) : (i64, i64) -> i64
      "braid.guard"(%bbd8_6) : (i64) -> ()
      %bbd8_7 = "braid.load"(%bbd8_2) {bytes = 4 : i64} : (i64) -> i64
      %bbd8_8 = "braid.sext"(%bbd8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd8_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x1023c
      %bbdc_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbdc_1 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbdc_2 = "braid.add"(%bbdc_0, %bbdc_1) : (i64, i64) -> i64
      %bbdc_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbdc_4 = "braid.and"(%bbdc_2, %bbdc_3) : (i64, i64) -> i64
      %bbdc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbdc_6 = "braid.eq"(%bbdc_4, %bbdc_5) : (i64, i64) -> i64
      "braid.guard"(%bbdc_6) : (i64) -> ()
      %bbdc_7 = "braid.load"(%bbdc_2) {bytes = 4 : i64} : (i64) -> i64
      %bbdc_8 = "braid.sext"(%bbdc_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbdc_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bbe0] : () -> ()
    ^bbe0:  // 0x10240
      %bbe0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbe0_1 = "braid.const"() {value = 36 : i64} : () -> i64
      %bbe0_2 = "braid.add"(%bbe0_0, %bbe0_1) : (i64, i64) -> i64
      %bbe0_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbe0_4 = "braid.and"(%bbe0_2, %bbe0_3) : (i64, i64) -> i64
      %bbe0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe0_6 = "braid.eq"(%bbe0_4, %bbe0_5) : (i64, i64) -> i64
      "braid.guard"(%bbe0_6) : (i64) -> ()
      %bbe0_7 = "braid.load"(%bbe0_2) {bytes = 4 : i64} : (i64) -> i64
      %bbe0_8 = "braid.sext"(%bbe0_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbe0_8) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x10244
      %bbe4_0 = "braid.const"() {value = 65536 : i64} : () -> i64
      "braid.set"(%bbe4_0) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbe8] : () -> ()
    ^bbe8:  // 0x10248
      %bbe8_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bbe8_1 = "braid.const"() {value = 872 : i64} : () -> i64
      %bbe8_2 = "braid.add"(%bbe8_0, %bbe8_1) : (i64, i64) -> i64
      "braid.set"(%bbe8_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbec] : () -> ()
    ^bbec:  // 0x1024c
      %bbec_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbec_1 = "braid.const"() {value = 40 : i64} : () -> i64
      %bbec_2 = "braid.add"(%bbec_0, %bbec_1) : (i64, i64) -> i64
      "braid.set"(%bbec_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bbf0] : () -> ()
    ^bbf0:  // 0x10250
      %bbf0_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bbf0_1 = "braid.const"() {value = 256 : i64} : () -> i64
      %bbf0_2 = "braid.add"(%bbf0_0, %bbf0_1) : (i64, i64) -> i64
      "braid.set"(%bbf0_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bbf4] : () -> ()
    ^bbf4:  // 0x10254
      %bbf4_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bbf4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf4_2 = "braid.add"(%bbf4_0, %bbf4_1) : (i64, i64) -> i64
      "braid.set"(%bbf4_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bbf8] : () -> ()
    ^bbf8:  // 0x10258
      %bbf8_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bbf8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf8_2 = "braid.add"(%bbf8_0, %bbf8_1) : (i64, i64) -> i64
      "braid.set"(%bbf8_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bbfc] : () -> ()
    ^bbfc:  // 0x1025c
      %bbfc_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bbfc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbfc_2 = "braid.add"(%bbfc_0, %bbfc_1) : (i64, i64) -> i64
      "braid.set"(%bbfc_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb100:  // 0x10260
      %bb100_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb100_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb100_2 = "braid.add"(%bb100_0, %bb100_1) : (i64, i64) -> i64
      "braid.set"(%bb100_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb104] : () -> ()
    ^bb104:  // 0x10264
      %bb104_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb104_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb104_2 = "braid.add"(%bb104_0, %bb104_1) : (i64, i64) -> i64
      %bb104_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb104_4 = "braid.and"(%bb104_2, %bb104_3) : (i64, i64) -> i64
      %bb104_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb104_6 = "braid.eq"(%bb104_4, %bb104_5) : (i64, i64) -> i64
      "braid.guard"(%bb104_6) : (i64) -> ()
      %bb104_7 = "braid.load"(%bb104_2) {bytes = 4 : i64} : (i64) -> i64
      %bb104_8 = "braid.sext"(%bb104_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb104_8) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x10268
      %bb108_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb108_1 = "braid.zext"(%bb108_0) {bits = 32 : i64} : (i64) -> i64
      %bb108_2 = "braid.const"() {value = 6 : i64} : () -> i64
      %bb108_3 = "braid.lshr"(%bb108_1, %bb108_2) : (i64, i64) -> i64
      %bb108_4 = "braid.sext"(%bb108_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb108_4) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb10c] : () -> ()
    ^bb10c:  // 0x1026c
      %bb10c_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb10c_1 = "braid.const"() {value = 26 : i64} : () -> i64
      %bb10c_2 = "braid.shl"(%bb10c_0, %bb10c_1) : (i64, i64) -> i64
      "braid.set"(%bb10c_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb110] : () -> ()
    ^bb110:  // 0x10270
      %bb110_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb110_1 = "braid.zext"(%bb110_0) {bits = 32 : i64} : (i64) -> i64
      %bb110_2 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb110_3 = "braid.lshr"(%bb110_1, %bb110_2) : (i64, i64) -> i64
      %bb110_4 = "braid.sext"(%bb110_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb110_4) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb114] : () -> ()
    ^bb114:  // 0x10274
      %bb114_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb114_1 = "braid.const"() {value = 21 : i64} : () -> i64
      %bb114_2 = "braid.shl"(%bb114_0, %bb114_1) : (i64, i64) -> i64
      "braid.set"(%bb114_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x10278
      %bb118_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb118_1 = "braid.get"() {reg = "x31"} : () -> i64
      %bb118_2 = "braid.or"(%bb118_0, %bb118_1) : (i64, i64) -> i64
      "braid.set"(%bb118_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb11c] : () -> ()
    ^bb11c:  // 0x1027c
      %bb11c_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb11c_1 = "braid.zext"(%bb11c_0) {bits = 32 : i64} : (i64) -> i64
      %bb11c_2 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb11c_3 = "braid.lshr"(%bb11c_1, %bb11c_2) : (i64, i64) -> i64
      %bb11c_4 = "braid.sext"(%bb11c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb11c_4) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x10280
      %bb120_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb120_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb120_2 = "braid.or"(%bb120_0, %bb120_1) : (i64, i64) -> i64
      "braid.set"(%bb120_2) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb124] : () -> ()
    ^bb124:  // 0x10284
      %bb124_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb124_1 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb124_2 = "braid.shl"(%bb124_0, %bb124_1) : (i64, i64) -> i64
      "braid.set"(%bb124_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb128] : () -> ()
    ^bb128:  // 0x10288
      %bb128_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb128_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb128_2 = "braid.or"(%bb128_0, %bb128_1) : (i64, i64) -> i64
      "braid.set"(%bb128_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb12c] : () -> ()
    ^bb12c:  // 0x1028c
      %bb12c_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb12c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12c_2 = "braid.add"(%bb12c_0, %bb12c_1) : (i64, i64) -> i64
      %bb12c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb12c_4 = "braid.and"(%bb12c_2, %bb12c_3) : (i64, i64) -> i64
      %bb12c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12c_6 = "braid.eq"(%bb12c_4, %bb12c_5) : (i64, i64) -> i64
      "braid.guard"(%bb12c_6) : (i64) -> ()
      %bb12c_7 = "braid.load"(%bb12c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb12c_8 = "braid.sext"(%bb12c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb12c_8) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb130] : () -> ()
    ^bb130:  // 0x10290
      %bb130_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb130_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb130_2 = "braid.xor"(%bb130_0, %bb130_1) : (i64, i64) -> i64
      "braid.set"(%bb130_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb134:  // 0x10294
      %bb134_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb134_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb134_2 = "braid.xor"(%bb134_0, %bb134_1) : (i64, i64) -> i64
      "braid.set"(%bb134_2) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb138] : () -> ()
    ^bb138:  // 0x10298
      %bb138_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb138_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb138_2 = "braid.add"(%bb138_0, %bb138_1) : (i64, i64) -> i64
      "braid.set"(%bb138_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb13c] : () -> ()
    ^bb13c:  // 0x1029c
      %bb13c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb13c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb13c_2 = "braid.and"(%bb13c_0, %bb13c_1) : (i64, i64) -> i64
      "braid.set"(%bb13c_2) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb140] : () -> ()
    ^bb140:  // 0x102a0
      %bb140_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb140_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb140_2 = "braid.xor"(%bb140_0, %bb140_1) : (i64, i64) -> i64
      "braid.set"(%bb140_2) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb144] : () -> ()
    ^bb144:  // 0x102a4
      %bb144_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb144_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb144_2 = "braid.xor"(%bb144_0, %bb144_1) : (i64, i64) -> i64
      "braid.set"(%bb144_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb148] : () -> ()
    ^bb148:  // 0x102a8
      %bb148_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb148_1 = "braid.get"() {reg = "x29"} : () -> i64
      %bb148_2 = "braid.add"(%bb148_0, %bb148_1) : (i64, i64) -> i64
      "braid.set"(%bb148_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb14c] : () -> ()
    ^bb14c:  // 0x102ac
      %bb14c_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb14c_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb14c_2 = "braid.add"(%bb14c_0, %bb14c_1) : (i64, i64) -> i64
      "braid.set"(%bb14c_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb150] : () -> ()
    ^bb150:  // 0x102b0
      %bb150_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb150_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb150_2 = "braid.add"(%bb150_0, %bb150_1) : (i64, i64) -> i64
      "braid.set"(%bb150_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb154] : () -> ()
    ^bb154:  // 0x102b4
      %bb154_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb154_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb154_2 = "braid.add"(%bb154_0, %bb154_1) : (i64, i64) -> i64
      "braid.set"(%bb154_2) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb158] : () -> ()
    ^bb158:  // 0x102b8
      %bb158_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb158_1 = "braid.get"() {reg = "x28"} : () -> i64
      %bb158_2 = "braid.add"(%bb158_0, %bb158_1) : (i64, i64) -> i64
      "braid.set"(%bb158_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb15c] : () -> ()
    ^bb15c:  // 0x102bc
      %bb15c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb15c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15c_2 = "braid.add"(%bb15c_0, %bb15c_1) : (i64, i64) -> i64
      "braid.set"(%bb15c_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb160] : () -> ()
    ^bb160:  // 0x102c0
      %bb160_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb160_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb160_2 = "braid.add"(%bb160_0, %bb160_1) : (i64, i64) -> i64
      "braid.set"(%bb160_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb164] : () -> ()
    ^bb164:  // 0x102c4
      %bb164_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb164_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb164_2 = "braid.add"(%bb164_0, %bb164_1) : (i64, i64) -> i64
      "braid.set"(%bb164_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb168] : () -> ()
    ^bb168:  // 0x102c8
      %bb168_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb168_1 = "braid.zext"(%bb168_0) {bits = 32 : i64} : (i64) -> i64
      %bb168_2 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb168_3 = "braid.lshr"(%bb168_1, %bb168_2) : (i64, i64) -> i64
      %bb168_4 = "braid.sext"(%bb168_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb168_4) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb16c] : () -> ()
    ^bb16c:  // 0x102cc
      %bb16c_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb16c_1 = "braid.const"() {value = 30 : i64} : () -> i64
      %bb16c_2 = "braid.shl"(%bb16c_0, %bb16c_1) : (i64, i64) -> i64
      "braid.set"(%bb16c_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb170] : () -> ()
    ^bb170:  // 0x102d0
      %bb170_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb170_1 = "braid.zext"(%bb170_0) {bits = 32 : i64} : (i64) -> i64
      %bb170_2 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb170_3 = "braid.lshr"(%bb170_1, %bb170_2) : (i64, i64) -> i64
      %bb170_4 = "braid.sext"(%bb170_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb170_4) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb174] : () -> ()
    ^bb174:  // 0x102d4
      %bb174_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb174_1 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb174_2 = "braid.shl"(%bb174_0, %bb174_1) : (i64, i64) -> i64
      "braid.set"(%bb174_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb178] : () -> ()
    ^bb178:  // 0x102d8
      %bb178_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb178_1 = "braid.zext"(%bb178_0) {bits = 32 : i64} : (i64) -> i64
      %bb178_2 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb178_3 = "braid.lshr"(%bb178_1, %bb178_2) : (i64, i64) -> i64
      %bb178_4 = "braid.sext"(%bb178_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb178_4) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb17c] : () -> ()
    ^bb17c:  // 0x102dc
      %bb17c_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb17c_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb17c_2 = "braid.or"(%bb17c_0, %bb17c_1) : (i64, i64) -> i64
      "braid.set"(%bb17c_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb180] : () -> ()
    ^bb180:  // 0x102e0
      %bb180_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb180_1 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb180_2 = "braid.shl"(%bb180_0, %bb180_1) : (i64, i64) -> i64
      "braid.set"(%bb180_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb184] : () -> ()
    ^bb184:  // 0x102e4
      %bb184_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb184_1 = "braid.get"() {reg = "x31"} : () -> i64
      %bb184_2 = "braid.or"(%bb184_0, %bb184_1) : (i64, i64) -> i64
      "braid.set"(%bb184_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb188] : () -> ()
    ^bb188:  // 0x102e8
      %bb188_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb188_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb188_2 = "braid.xor"(%bb188_0, %bb188_1) : (i64, i64) -> i64
      "braid.set"(%bb188_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb18c] : () -> ()
    ^bb18c:  // 0x102ec
      %bb18c_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb18c_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb18c_2 = "braid.or"(%bb18c_0, %bb18c_1) : (i64, i64) -> i64
      "braid.set"(%bb18c_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x102f0
      %bb190_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb190_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb190_2 = "braid.and"(%bb190_0, %bb190_1) : (i64, i64) -> i64
      "braid.set"(%bb190_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb194] : () -> ()
    ^bb194:  // 0x102f4
      %bb194_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb194_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb194_2 = "braid.and"(%bb194_0, %bb194_1) : (i64, i64) -> i64
      "braid.set"(%bb194_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb198] : () -> ()
    ^bb198:  // 0x102f8
      %bb198_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb198_1 = "braid.get"() {reg = "x31"} : () -> i64
      %bb198_2 = "braid.xor"(%bb198_0, %bb198_1) : (i64, i64) -> i64
      "braid.set"(%bb198_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb19c] : () -> ()
    ^bb19c:  // 0x102fc
      %bb19c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb19c_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb19c_2 = "braid.xor"(%bb19c_0, %bb19c_1) : (i64, i64) -> i64
      "braid.set"(%bb19c_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb1a0] : () -> ()
    ^bb1a0:  // 0x10300
      %bb1a0_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb1a0_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb1a0_2 = "braid.xor"(%bb1a0_0, %bb1a0_1) : (i64, i64) -> i64
      "braid.set"(%bb1a0_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb1a4] : () -> ()
    ^bb1a4:  // 0x10304
      %bb1a4_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb1a4_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb1a4_2 = "braid.add"(%bb1a4_0, %bb1a4_1) : (i64, i64) -> i64
      "braid.set"(%bb1a4_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb1a8] : () -> ()
    ^bb1a8:  // 0x10308
      %bb1a8_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb1a8_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1a8_2 = "braid.add"(%bb1a8_0, %bb1a8_1) : (i64, i64) -> i64
      "braid.set"(%bb1a8_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb1ac] : () -> ()
    ^bb1ac:  // 0x1030c
      %bb1ac_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb1ac_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1ac_2 = "braid.add"(%bb1ac_0, %bb1ac_1) : (i64, i64) -> i64
      "braid.set"(%bb1ac_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb1b0] : () -> ()
    ^bb1b0:  // 0x10310
      %bb1b0_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb1b0_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb1b0_2 = "braid.ne"(%bb1b0_0, %bb1b0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb1b0_2)[^bbf4, ^bb1b4] : (i64) -> ()
    ^bb1b4:  // 0x10314
      %bb1b4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1b4_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1b4_2 = "braid.add"(%bb1b4_0, %bb1b4_1) : (i64, i64) -> i64
      %bb1b4_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1b4_4 = "braid.and"(%bb1b4_2, %bb1b4_3) : (i64, i64) -> i64
      %bb1b4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b4_6 = "braid.eq"(%bb1b4_4, %bb1b4_5) : (i64, i64) -> i64
      "braid.guard"(%bb1b4_6) : (i64) -> ()
      %bb1b4_7 = "braid.get"() {reg = "x7"} : () -> i64
      "braid.store"(%bb1b4_2, %bb1b4_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1b8] : () -> ()
    ^bb1b8:  // 0x10318
      %bb1b8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1b8_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb1b8_2 = "braid.add"(%bb1b8_0, %bb1b8_1) : (i64, i64) -> i64
      %bb1b8_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1b8_4 = "braid.and"(%bb1b8_2, %bb1b8_3) : (i64, i64) -> i64
      %bb1b8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b8_6 = "braid.eq"(%bb1b8_4, %bb1b8_5) : (i64, i64) -> i64
      "braid.guard"(%bb1b8_6) : (i64) -> ()
      %bb1b8_7 = "braid.get"() {reg = "x12"} : () -> i64
      "braid.store"(%bb1b8_2, %bb1b8_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1bc] : () -> ()
    ^bb1bc:  // 0x1031c
      %bb1bc_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1bc_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1bc_2 = "braid.add"(%bb1bc_0, %bb1bc_1) : (i64, i64) -> i64
      %bb1bc_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1bc_4 = "braid.and"(%bb1bc_2, %bb1bc_3) : (i64, i64) -> i64
      %bb1bc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1bc_6 = "braid.eq"(%bb1bc_4, %bb1bc_5) : (i64, i64) -> i64
      "braid.guard"(%bb1bc_6) : (i64) -> ()
      %bb1bc_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bb1bc_2, %bb1bc_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1c0] : () -> ()
    ^bb1c0:  // 0x10320
      %bb1c0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1c0_1 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb1c0_2 = "braid.add"(%bb1c0_0, %bb1c0_1) : (i64, i64) -> i64
      %bb1c0_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1c0_4 = "braid.and"(%bb1c0_2, %bb1c0_3) : (i64, i64) -> i64
      %bb1c0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c0_6 = "braid.eq"(%bb1c0_4, %bb1c0_5) : (i64, i64) -> i64
      "braid.guard"(%bb1c0_6) : (i64) -> ()
      %bb1c0_7 = "braid.get"() {reg = "x28"} : () -> i64
      "braid.store"(%bb1c0_2, %bb1c0_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1c4] : () -> ()
    ^bb1c4:  // 0x10324
      %bb1c4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1c4_1 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb1c4_2 = "braid.add"(%bb1c4_0, %bb1c4_1) : (i64, i64) -> i64
      %bb1c4_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1c4_4 = "braid.and"(%bb1c4_2, %bb1c4_3) : (i64, i64) -> i64
      %bb1c4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c4_6 = "braid.eq"(%bb1c4_4, %bb1c4_5) : (i64, i64) -> i64
      "braid.guard"(%bb1c4_6) : (i64) -> ()
      %bb1c4_7 = "braid.get"() {reg = "x29"} : () -> i64
      "braid.store"(%bb1c4_2, %bb1c4_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1c8] : () -> ()
    ^bb1c8:  // 0x10328
      %bb1c8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1c8_1 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb1c8_2 = "braid.add"(%bb1c8_0, %bb1c8_1) : (i64, i64) -> i64
      %bb1c8_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1c8_4 = "braid.and"(%bb1c8_2, %bb1c8_3) : (i64, i64) -> i64
      %bb1c8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c8_6 = "braid.eq"(%bb1c8_4, %bb1c8_5) : (i64, i64) -> i64
      "braid.guard"(%bb1c8_6) : (i64) -> ()
      %bb1c8_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bb1c8_2, %bb1c8_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1cc] : () -> ()
    ^bb1cc:  // 0x1032c
      %bb1cc_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1cc_1 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb1cc_2 = "braid.add"(%bb1cc_0, %bb1cc_1) : (i64, i64) -> i64
      %bb1cc_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1cc_4 = "braid.and"(%bb1cc_2, %bb1cc_3) : (i64, i64) -> i64
      %bb1cc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1cc_6 = "braid.eq"(%bb1cc_4, %bb1cc_5) : (i64, i64) -> i64
      "braid.guard"(%bb1cc_6) : (i64) -> ()
      %bb1cc_7 = "braid.get"() {reg = "x15"} : () -> i64
      "braid.store"(%bb1cc_2, %bb1cc_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1d0] : () -> ()
    ^bb1d0:  // 0x10330
      %bb1d0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1d0_1 = "braid.const"() {value = 36 : i64} : () -> i64
      %bb1d0_2 = "braid.add"(%bb1d0_0, %bb1d0_1) : (i64, i64) -> i64
      %bb1d0_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1d0_4 = "braid.and"(%bb1d0_2, %bb1d0_3) : (i64, i64) -> i64
      %bb1d0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d0_6 = "braid.eq"(%bb1d0_4, %bb1d0_5) : (i64, i64) -> i64
      "braid.guard"(%bb1d0_6) : (i64) -> ()
      %bb1d0_7 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.store"(%bb1d0_2, %bb1d0_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1d4] : () -> ()
    ^bb1d4:  // 0x10334
      %bb1d4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1d4_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1d4_2 = "braid.add"(%bb1d4_0, %bb1d4_1) : (i64, i64) -> i64
      "braid.set"(%bb1d4_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb1d8] : () -> ()
    ^bb1d8:  // 0x10338
      %bb1d8_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb1d8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d8_2 = "braid.add"(%bb1d8_0, %bb1d8_1) : (i64, i64) -> i64
      %bb1d8_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1d8_4 = "braid.and"(%bb1d8_2, %bb1d8_3) : (i64, i64) -> i64
      %bb1d8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d8_6 = "braid.eq"(%bb1d8_4, %bb1d8_5) : (i64, i64) -> i64
      "braid.guard"(%bb1d8_6) : (i64) -> ()
      %bb1d8_7 = "braid.load"(%bb1d8_2) {bytes = 4 : i64} : (i64) -> i64
      %bb1d8_8 = "braid.sext"(%bb1d8_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1d8_8) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb1dc] : () -> ()
    ^bb1dc:  // 0x1033c
      %bb1dc_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1dc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1dc_2 = "braid.add"(%bb1dc_0, %bb1dc_1) : (i64, i64) -> i64
      %bb1dc_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1dc_4 = "braid.and"(%bb1dc_2, %bb1dc_3) : (i64, i64) -> i64
      %bb1dc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1dc_6 = "braid.eq"(%bb1dc_4, %bb1dc_5) : (i64, i64) -> i64
      "braid.guard"(%bb1dc_6) : (i64) -> ()
      %bb1dc_7 = "braid.load"(%bb1dc_2) {bytes = 4 : i64} : (i64) -> i64
      %bb1dc_8 = "braid.sext"(%bb1dc_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1dc_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb1e0] : () -> ()
    ^bb1e0:  // 0x10340
      %bb1e0_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb1e0_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb1e0_2 = "braid.add"(%bb1e0_0, %bb1e0_1) : (i64, i64) -> i64
      "braid.set"(%bb1e0_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb1e4] : () -> ()
    ^bb1e4:  // 0x10344
      %bb1e4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1e4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e4_2 = "braid.add"(%bb1e4_0, %bb1e4_1) : (i64, i64) -> i64
      %bb1e4_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb1e4_4 = "braid.and"(%bb1e4_2, %bb1e4_3) : (i64, i64) -> i64
      %bb1e4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e4_6 = "braid.eq"(%bb1e4_4, %bb1e4_5) : (i64, i64) -> i64
      "braid.guard"(%bb1e4_6) : (i64) -> ()
      %bb1e4_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bb1e4_2, %bb1e4_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1e8] : () -> ()
    ^bb1e8:  // 0x10348
      %bb1e8_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1e8_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1e8_2 = "braid.add"(%bb1e8_0, %bb1e8_1) : (i64, i64) -> i64
      "braid.set"(%bb1e8_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb1ec] : () -> ()
    ^bb1ec:  // 0x1034c
      %bb1ec_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb1ec_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1ec_2 = "braid.add"(%bb1ec_0, %bb1ec_1) : (i64, i64) -> i64
      "braid.set"(%bb1ec_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb1f0] : () -> ()
    ^bb1f0:  // 0x10350
      %bb1f0_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1f0_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb1f0_2 = "braid.ne"(%bb1f0_0, %bb1f0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb1f0_2)[^bb1d8, ^bb1f4] : (i64) -> ()
    ^bb1f4:  // 0x10354
      %bb1f4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1f4_1 = "braid.const"() {value = 312 : i64} : () -> i64
      %bb1f4_2 = "braid.add"(%bb1f4_0, %bb1f4_1) : (i64, i64) -> i64
      %bb1f4_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1f4_4 = "braid.and"(%bb1f4_2, %bb1f4_3) : (i64, i64) -> i64
      %bb1f4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1f4_6 = "braid.eq"(%bb1f4_4, %bb1f4_5) : (i64, i64) -> i64
      "braid.guard"(%bb1f4_6) : (i64) -> ()
      %bb1f4_7 = "braid.load"(%bb1f4_2) {bytes = 8 : i64} : (i64) -> i64
      %bb1f4_8 = "braid.zext"(%bb1f4_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb1f4_8) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1f8] : () -> ()
    ^bb1f8:  // 0x10358
      %bb1f8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1f8_1 = "braid.const"() {value = 304 : i64} : () -> i64
      %bb1f8_2 = "braid.add"(%bb1f8_0, %bb1f8_1) : (i64, i64) -> i64
      %bb1f8_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1f8_4 = "braid.and"(%bb1f8_2, %bb1f8_3) : (i64, i64) -> i64
      %bb1f8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1f8_6 = "braid.eq"(%bb1f8_4, %bb1f8_5) : (i64, i64) -> i64
      "braid.guard"(%bb1f8_6) : (i64) -> ()
      %bb1f8_7 = "braid.load"(%bb1f8_2) {bytes = 8 : i64} : (i64) -> i64
      %bb1f8_8 = "braid.zext"(%bb1f8_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb1f8_8) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb1fc] : () -> ()
    ^bb1fc:  // 0x1035c
      %bb1fc_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1fc_1 = "braid.const"() {value = 296 : i64} : () -> i64
      %bb1fc_2 = "braid.add"(%bb1fc_0, %bb1fc_1) : (i64, i64) -> i64
      %bb1fc_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1fc_4 = "braid.and"(%bb1fc_2, %bb1fc_3) : (i64, i64) -> i64
      %bb1fc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1fc_6 = "braid.eq"(%bb1fc_4, %bb1fc_5) : (i64, i64) -> i64
      "braid.guard"(%bb1fc_6) : (i64) -> ()
      %bb1fc_7 = "braid.load"(%bb1fc_2) {bytes = 8 : i64} : (i64) -> i64
      %bb1fc_8 = "braid.zext"(%bb1fc_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb1fc_8) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb200] : () -> ()
    ^bb200:  // 0x10360
      %bb200_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb200_1 = "braid.const"() {value = 320 : i64} : () -> i64
      %bb200_2 = "braid.add"(%bb200_0, %bb200_1) : (i64, i64) -> i64
      "braid.set"(%bb200_2) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb204] : () -> ()
    ^bb204:  // 0x10364
      %bb204_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb204_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb204_2 = "braid.add"(%bb204_0, %bb204_1) : (i64, i64) -> i64
      %bb204_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb204_4 = "braid.and"(%bb204_2, %bb204_3) : (i64, i64) -> i64
      %bb204_5 = "braid.const"() {value = 66408 : i64} : () -> i64
      "braid_cf.br_ind"(%bb204_4) : (i64) -> ()
  }) {sym_name = "sha256_compress", entry = 65888 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10468
      %bb0_0 = "braid.const"() {value = 69632 : i64} : () -> i64
      "braid.set"(%bb0_0) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x1046c
      %bb4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4_1 = "braid.const"() {value = -448 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10470
      %bb8_0 = "braid.const"() {value = 66676 : i64} : () -> i64
      "braid_cf.br"()[^ext10474] : () -> ()
    ^ext10474:
      "braid_cf.tail"() {target = 66676 : i64} : () -> ()
  }) {sym_name = "_start", entry = 66664 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10474
      %bb0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb0_1 = "braid.const"() {value = -208 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10478
      %bb4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4_1 = "braid.const"() {value = 200 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      %bb4_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb4_4 = "braid.and"(%bb4_2, %bb4_3) : (i64, i64) -> i64
      %bb4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_6 = "braid.eq"(%bb4_4, %bb4_5) : (i64, i64) -> i64
      "braid.guard"(%bb4_6) : (i64) -> ()
      %bb4_7 = "braid.get"() {reg = "x1"} : () -> i64
      "braid.store"(%bb4_2, %bb4_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1047c
      %bb8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb8_1 = "braid.const"() {value = 192 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb8_4 = "braid.and"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      %bb8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_6 = "braid.eq"(%bb8_4, %bb8_5) : (i64, i64) -> i64
      "braid.guard"(%bb8_6) : (i64) -> ()
      %bb8_7 = "braid.get"() {reg = "x8"} : () -> i64
      "braid.store"(%bb8_2, %bb8_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10480
      %bbc_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbc_1 = "braid.const"() {value = 184 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      %bbc_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbc_4 = "braid.and"(%bbc_2, %bbc_3) : (i64, i64) -> i64
      %bbc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_6 = "braid.eq"(%bbc_4, %bbc_5) : (i64, i64) -> i64
      "braid.guard"(%bbc_6) : (i64) -> ()
      %bbc_7 = "braid.get"() {reg = "x9"} : () -> i64
      "braid.store"(%bbc_2, %bbc_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10484
      %bb10_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb10_1 = "braid.const"() {value = 176 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb10_4 = "braid.and"(%bb10_2, %bb10_3) : (i64, i64) -> i64
      %bb10_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_6 = "braid.eq"(%bb10_4, %bb10_5) : (i64, i64) -> i64
      "braid.guard"(%bb10_6) : (i64) -> ()
      %bb10_7 = "braid.get"() {reg = "x18"} : () -> i64
      "braid.store"(%bb10_2, %bb10_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10488
      %bb14_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb14_1 = "braid.const"() {value = 168 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      %bb14_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb14_4 = "braid.and"(%bb14_2, %bb14_3) : (i64, i64) -> i64
      %bb14_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_6 = "braid.eq"(%bb14_4, %bb14_5) : (i64, i64) -> i64
      "braid.guard"(%bb14_6) : (i64) -> ()
      %bb14_7 = "braid.get"() {reg = "x19"} : () -> i64
      "braid.store"(%bb14_2, %bb14_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x1048c
      %bb18_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb18_1 = "braid.const"() {value = 160 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      %bb18_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb18_4 = "braid.and"(%bb18_2, %bb18_3) : (i64, i64) -> i64
      %bb18_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_6 = "braid.eq"(%bb18_4, %bb18_5) : (i64, i64) -> i64
      "braid.guard"(%bb18_6) : (i64) -> ()
      %bb18_7 = "braid.get"() {reg = "x20"} : () -> i64
      "braid.store"(%bb18_2, %bb18_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10490
      %bb1c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 152 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      %bb1c_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1c_4 = "braid.and"(%bb1c_2, %bb1c_3) : (i64, i64) -> i64
      %bb1c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_6 = "braid.eq"(%bb1c_4, %bb1c_5) : (i64, i64) -> i64
      "braid.guard"(%bb1c_6) : (i64) -> ()
      %bb1c_7 = "braid.get"() {reg = "x21"} : () -> i64
      "braid.store"(%bb1c_2, %bb1c_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10494
      %bb20_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb20_1 = "braid.const"() {value = 144 : i64} : () -> i64
      %bb20_2 = "braid.add"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      %bb20_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb20_4 = "braid.and"(%bb20_2, %bb20_3) : (i64, i64) -> i64
      %bb20_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_6 = "braid.eq"(%bb20_4, %bb20_5) : (i64, i64) -> i64
      "braid.guard"(%bb20_6) : (i64) -> ()
      %bb20_7 = "braid.get"() {reg = "x22"} : () -> i64
      "braid.store"(%bb20_2, %bb20_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10498
      %bb24_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb24_1 = "braid.const"() {value = 136 : i64} : () -> i64
      %bb24_2 = "braid.add"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      %bb24_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb24_4 = "braid.and"(%bb24_2, %bb24_3) : (i64, i64) -> i64
      %bb24_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_6 = "braid.eq"(%bb24_4, %bb24_5) : (i64, i64) -> i64
      "braid.guard"(%bb24_6) : (i64) -> ()
      %bb24_7 = "braid.get"() {reg = "x23"} : () -> i64
      "braid.store"(%bb24_2, %bb24_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x1049c
      %bb28_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb28_1 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb28_2 = "braid.add"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      %bb28_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb28_4 = "braid.and"(%bb28_2, %bb28_3) : (i64, i64) -> i64
      %bb28_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_6 = "braid.eq"(%bb28_4, %bb28_5) : (i64, i64) -> i64
      "braid.guard"(%bb28_6) : (i64) -> ()
      %bb28_7 = "braid.get"() {reg = "x24"} : () -> i64
      "braid.store"(%bb28_2, %bb28_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x104a0
      %bb2c_0 = "braid.const"() {value = 69632 : i64} : () -> i64
      "braid.set"(%bb2c_0) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x104a4
      %bb30_0 = "braid.const"() {value = 1779032064 : i64} : () -> i64
      "braid.set"(%bb30_0) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x104a8
      %bb34_0 = "braid.const"() {value = -1150832640 : i64} : () -> i64
      "braid.set"(%bb34_0) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x104ac
      %bb38_0 = "braid.const"() {value = 1013903360 : i64} : () -> i64
      "braid.set"(%bb38_0) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x104b0
      %bb3c_0 = "braid.const"() {value = -1521487872 : i64} : () -> i64
      "braid.set"(%bb3c_0) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x104b4
      %bb40_0 = "braid.const"() {value = 1359892480 : i64} : () -> i64
      "braid.set"(%bb40_0) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x104b8
      %bb44_0 = "braid.const"() {value = -1694142464 : i64} : () -> i64
      "braid.set"(%bb44_0) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x104bc
      %bb48_0 = "braid.const"() {value = 528736256 : i64} : () -> i64
      "braid.set"(%bb48_0) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x104c0
      %bb4c_0 = "braid.const"() {value = 1541459968 : i64} : () -> i64
      "braid.set"(%bb4c_0) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x104c4
      %bb50_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb50_1 = "braid.const"() {value = -448 : i64} : () -> i64
      %bb50_2 = "braid.add"(%bb50_0, %bb50_1) : (i64, i64) -> i64
      %bb50_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb50_4 = "braid.and"(%bb50_2, %bb50_3) : (i64, i64) -> i64
      %bb50_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb50_6 = "braid.eq"(%bb50_4, %bb50_5) : (i64, i64) -> i64
      "braid.guard"(%bb50_6) : (i64) -> ()
      %bb50_7 = "braid.load"(%bb50_2) {bytes = 8 : i64} : (i64) -> i64
      %bb50_8 = "braid.zext"(%bb50_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb50_8) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x104c8
      %bb54_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb54_1 = "braid.const"() {value = 1639 : i64} : () -> i64
      %bb54_2 = "braid.add"(%bb54_0, %bb54_1) : (i64, i64) -> i64
      "braid.set"(%bb54_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x104cc
      %bb58_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb58_1 = "braid.const"() {value = -379 : i64} : () -> i64
      %bb58_2 = "braid.add"(%bb58_0, %bb58_1) : (i64, i64) -> i64
      "braid.set"(%bb58_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x104d0
      %bb5c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb5c_1 = "braid.const"() {value = 882 : i64} : () -> i64
      %bb5c_2 = "braid.add"(%bb5c_0, %bb5c_1) : (i64, i64) -> i64
      "braid.set"(%bb5c_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x104d4
      %bb60_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb60_1 = "braid.const"() {value = 1338 : i64} : () -> i64
      %bb60_2 = "braid.add"(%bb60_0, %bb60_1) : (i64, i64) -> i64
      "braid.set"(%bb60_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x104d8
      %bb64_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb64_1 = "braid.const"() {value = 639 : i64} : () -> i64
      %bb64_2 = "braid.add"(%bb64_0, %bb64_1) : (i64, i64) -> i64
      "braid.set"(%bb64_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x104dc
      %bb68_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb68_1 = "braid.const"() {value = -1908 : i64} : () -> i64
      %bb68_2 = "braid.add"(%bb68_0, %bb68_1) : (i64, i64) -> i64
      "braid.set"(%bb68_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x104e0
      %bb6c_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb6c_1 = "braid.const"() {value = -1621 : i64} : () -> i64
      %bb6c_2 = "braid.add"(%bb6c_0, %bb6c_1) : (i64, i64) -> i64
      "braid.set"(%bb6c_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x104e4
      %bb70_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb70_1 = "braid.const"() {value = -743 : i64} : () -> i64
      %bb70_2 = "braid.add"(%bb70_0, %bb70_1) : (i64, i64) -> i64
      "braid.set"(%bb70_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x104e8
      %bb74_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb74_1 = "braid.const"() {value = 96 : i64} : () -> i64
      %bb74_2 = "braid.add"(%bb74_0, %bb74_1) : (i64, i64) -> i64
      %bb74_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb74_4 = "braid.and"(%bb74_2, %bb74_3) : (i64, i64) -> i64
      %bb74_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb74_6 = "braid.eq"(%bb74_4, %bb74_5) : (i64, i64) -> i64
      "braid.guard"(%bb74_6) : (i64) -> ()
      %bb74_7 = "braid.get"() {reg = "x10"} : () -> i64
      "braid.store"(%bb74_2, %bb74_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x104ec
      %bb78_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb78_1 = "braid.const"() {value = 100 : i64} : () -> i64
      %bb78_2 = "braid.add"(%bb78_0, %bb78_1) : (i64, i64) -> i64
      %bb78_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb78_4 = "braid.and"(%bb78_2, %bb78_3) : (i64, i64) -> i64
      %bb78_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb78_6 = "braid.eq"(%bb78_4, %bb78_5) : (i64, i64) -> i64
      "braid.guard"(%bb78_6) : (i64) -> ()
      %bb78_7 = "braid.get"() {reg = "x11"} : () -> i64
      "braid.store"(%bb78_2, %bb78_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x104f0
      %bb7c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb7c_1 = "braid.const"() {value = 104 : i64} : () -> i64
      %bb7c_2 = "braid.add"(%bb7c_0, %bb7c_1) : (i64, i64) -> i64
      %bb7c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb7c_4 = "braid.and"(%bb7c_2, %bb7c_3) : (i64, i64) -> i64
      %bb7c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7c_6 = "braid.eq"(%bb7c_4, %bb7c_5) : (i64, i64) -> i64
      "braid.guard"(%bb7c_6) : (i64) -> ()
      %bb7c_7 = "braid.get"() {reg = "x12"} : () -> i64
      "braid.store"(%bb7c_2, %bb7c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x104f4
      %bb80_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb80_1 = "braid.const"() {value = 108 : i64} : () -> i64
      %bb80_2 = "braid.add"(%bb80_0, %bb80_1) : (i64, i64) -> i64
      %bb80_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb80_4 = "braid.and"(%bb80_2, %bb80_3) : (i64, i64) -> i64
      %bb80_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb80_6 = "braid.eq"(%bb80_4, %bb80_5) : (i64, i64) -> i64
      "braid.guard"(%bb80_6) : (i64) -> ()
      %bb80_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bb80_2, %bb80_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x104f8
      %bb84_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb84_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb84_2 = "braid.add"(%bb84_0, %bb84_1) : (i64, i64) -> i64
      "braid.set"(%bb84_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x104fc
      %bb88_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb88_1 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb88_2 = "braid.and"(%bb88_0, %bb88_1) : (i64, i64) -> i64
      "braid.set"(%bb88_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x10500
      %bb8c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb8c_1 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb8c_2 = "braid.add"(%bb8c_0, %bb8c_1) : (i64, i64) -> i64
      "braid.set"(%bb8c_2) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x10504
      %bb90_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb90_1 = "braid.const"() {value = 112 : i64} : () -> i64
      %bb90_2 = "braid.add"(%bb90_0, %bb90_1) : (i64, i64) -> i64
      %bb90_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb90_4 = "braid.and"(%bb90_2, %bb90_3) : (i64, i64) -> i64
      %bb90_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb90_6 = "braid.eq"(%bb90_4, %bb90_5) : (i64, i64) -> i64
      "braid.guard"(%bb90_6) : (i64) -> ()
      %bb90_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bb90_2, %bb90_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x10508
      %bb94_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb94_1 = "braid.const"() {value = 116 : i64} : () -> i64
      %bb94_2 = "braid.add"(%bb94_0, %bb94_1) : (i64, i64) -> i64
      %bb94_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb94_4 = "braid.and"(%bb94_2, %bb94_3) : (i64, i64) -> i64
      %bb94_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb94_6 = "braid.eq"(%bb94_4, %bb94_5) : (i64, i64) -> i64
      "braid.guard"(%bb94_6) : (i64) -> ()
      %bb94_7 = "braid.get"() {reg = "x15"} : () -> i64
      "braid.store"(%bb94_2, %bb94_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x1050c
      %bb98_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb98_1 = "braid.const"() {value = 120 : i64} : () -> i64
      %bb98_2 = "braid.add"(%bb98_0, %bb98_1) : (i64, i64) -> i64
      %bb98_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb98_4 = "braid.and"(%bb98_2, %bb98_3) : (i64, i64) -> i64
      %bb98_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb98_6 = "braid.eq"(%bb98_4, %bb98_5) : (i64, i64) -> i64
      "braid.guard"(%bb98_6) : (i64) -> ()
      %bb98_7 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.store"(%bb98_2, %bb98_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x10510
      %bb9c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb9c_1 = "braid.const"() {value = 124 : i64} : () -> i64
      %bb9c_2 = "braid.add"(%bb9c_0, %bb9c_1) : (i64, i64) -> i64
      %bb9c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb9c_4 = "braid.and"(%bb9c_2, %bb9c_3) : (i64, i64) -> i64
      %bb9c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9c_6 = "braid.eq"(%bb9c_4, %bb9c_5) : (i64, i64) -> i64
      "braid.guard"(%bb9c_6) : (i64) -> ()
      %bb9c_7 = "braid.get"() {reg = "x17"} : () -> i64
      "braid.store"(%bb9c_2, %bb9c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x10514
      %bba0_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bba0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba0_2 = "braid.eq"(%bba0_0, %bba0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bba0_2)[^bb170, ^bba4] : (i64) -> ()
    ^bba4:  // 0x10518
      %bba4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba4_2 = "braid.add"(%bba4_0, %bba4_1) : (i64, i64) -> i64
      "braid.set"(%bba4_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x1051c
      %bba8_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bba8_1 = "braid.const"() {value = 56 : i64} : () -> i64
      %bba8_2 = "braid.add"(%bba8_0, %bba8_1) : (i64, i64) -> i64
      "braid.set"(%bba8_2) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x10520
      %bbac_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bbac_1 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbac_2 = "braid.shl"(%bbac_0, %bbac_1) : (i64, i64) -> i64
      "braid.set"(%bbac_2) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x10524
      %bbb0_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbb0_1 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbb0_2 = "braid.shl"(%bbb0_0, %bbb0_1) : (i64, i64) -> i64
      "braid.set"(%bbb0_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x10528
      %bbb4_0 = "braid.const"() {value = 69632 : i64} : () -> i64
      "braid.set"(%bbb4_0) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x1052c
      %bbb8_0 = "braid.get"() {reg = "x21"} : () -> i64
      %bbb8_1 = "braid.const"() {value = -440 : i64} : () -> i64
      %bbb8_2 = "braid.add"(%bbb8_0, %bbb8_1) : (i64, i64) -> i64
      "braid.set"(%bbb8_2) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x10530
      %bbbc_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbbc_1 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbbc_2 = "braid.add"(%bbbc_0, %bbbc_1) : (i64, i64) -> i64
      "braid.set"(%bbbc_2) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bbc0:  // 0x10534
      %bbc0_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbc0_1 = "braid.const"() {value = 504 : i64} : () -> i64
      %bbc0_2 = "braid.or"(%bbc0_0, %bbc0_1) : (i64, i64) -> i64
      "braid.set"(%bbc0_2) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x10538
      %bbc4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc4_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbc4_2 = "braid.add"(%bbc4_0, %bbc4_1) : (i64, i64) -> i64
      "braid.set"(%bbc4_2) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x1053c
      %bbc8_0 = "braid.const"() {value = 66880 : i64} : () -> i64
      "braid_cf.br"()[^bbe8] : () -> ()
    ^bbcc:  // 0x10540
      %bbcc_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbcc_1 = "braid.const"() {value = 96 : i64} : () -> i64
      %bbcc_2 = "braid.add"(%bbcc_0, %bbcc_1) : (i64, i64) -> i64
      "braid.set"(%bbcc_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x10544
      %bbd0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbd0_1 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbd0_2 = "braid.add"(%bbd0_0, %bbd0_1) : (i64, i64) -> i64
      "braid.set"(%bbd0_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x10548
      %bbd4_0 = "braid.const"() {value = 66888 : i64} : () -> i64
      "braid.set"(%bbd4_0) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bbd8] : () -> ()
    ^bbd8:  // 0x1054c
      %bbd8_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bbd8_1 = "braid.const"() {value = -1000 : i64} : () -> i64
      %bbd8_2 = "braid.add"(%bbd8_0, %bbd8_1) : (i64, i64) -> i64
      %bbd8_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bbd8_4 = "braid.and"(%bbd8_2, %bbd8_3) : (i64, i64) -> i64
      %bbd8_5 = "braid.const"() {value = 66896 : i64} : () -> i64
      "braid.set"(%bbd8_5) {reg = "x1"} : (i64) -> ()
      "braid_cf.br_ind"(%bbd8_4) : (i64) -> ()
    ^bbdc:  // 0x10550
      %bbdc_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bbdc_1 = "braid.const"() {value = 64 : i64} : () -> i64
      %bbdc_2 = "braid.add"(%bbdc_0, %bbdc_1) : (i64, i64) -> i64
      "braid.set"(%bbdc_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bbe0] : () -> ()
    ^bbe0:  // 0x10554
      %bbe0_0 = "braid.get"() {reg = "x23"} : () -> i64
      %bbe0_1 = "braid.const"() {value = -512 : i64} : () -> i64
      %bbe0_2 = "braid.add"(%bbe0_0, %bbe0_1) : (i64, i64) -> i64
      "braid.set"(%bbe0_2) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x10558
      %bbe4_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bbe4_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bbe4_2 = "braid.ult"(%bbe4_0, %bbe4_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bbe4_2)[^bbe8, ^bb170] : (i64) -> ()
    ^bbe8:  // 0x1055c
      %bbe8_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe8_2 = "braid.add"(%bbe8_0, %bbe8_1) : (i64, i64) -> i64
      "braid.set"(%bbe8_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbec] : () -> ()
    ^bbec:  // 0x10560
      %bbec_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bbec_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbec_2 = "braid.add"(%bbec_0, %bbec_1) : (i64, i64) -> i64
      "braid.set"(%bbec_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bbf0] : () -> ()
    ^bbf0:  // 0x10564
      %bbf0_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bbf0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf0_2 = "braid.add"(%bbf0_0, %bbf0_1) : (i64, i64) -> i64
      "braid.set"(%bbf0_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbf4] : () -> ()
    ^bbf4:  // 0x10568
      %bbf4_0 = "braid.get"() {reg = "x23"} : () -> i64
      %bbf4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf4_2 = "braid.add"(%bbf4_0, %bbf4_1) : (i64, i64) -> i64
      "braid.set"(%bbf4_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbf8] : () -> ()
    ^bbf8:  // 0x1056c
      %bbf8_0 = "braid.const"() {value = 66928 : i64} : () -> i64
      "braid_cf.br"()[^bb114] : () -> ()
    ^bbfc:  // 0x10570
      %bbfc_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bbfc_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bbfc_2 = "braid.add"(%bbfc_0, %bbfc_1) : (i64, i64) -> i64
      "braid.set"(%bbfc_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb100:  // 0x10574
      %bb100_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb100_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb100_2 = "braid.add"(%bb100_0, %bb100_1) : (i64, i64) -> i64
      "braid.set"(%bb100_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb104] : () -> ()
    ^bb104:  // 0x10578
      %bb104_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb104_1 = "braid.const"() {value = -32 : i64} : () -> i64
      %bb104_2 = "braid.add"(%bb104_0, %bb104_1) : (i64, i64) -> i64
      "braid.set"(%bb104_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x1057c
      %bb108_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb108_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb108_2 = "braid.add"(%bb108_0, %bb108_1) : (i64, i64) -> i64
      %bb108_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb108_4 = "braid.and"(%bb108_2, %bb108_3) : (i64, i64) -> i64
      %bb108_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb108_6 = "braid.eq"(%bb108_4, %bb108_5) : (i64, i64) -> i64
      "braid.guard"(%bb108_6) : (i64) -> ()
      %bb108_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bb108_2, %bb108_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb10c] : () -> ()
    ^bb10c:  // 0x10580
      %bb10c_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb10c_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb10c_2 = "braid.add"(%bb10c_0, %bb10c_1) : (i64, i64) -> i64
      "braid.set"(%bb10c_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb110] : () -> ()
    ^bb110:  // 0x10584
      %bb110_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb110_1 = "braid.get"() {reg = "x24"} : () -> i64
      %bb110_2 = "braid.eq"(%bb110_0, %bb110_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb110_2)[^bbcc, ^bb114] : (i64) -> ()
    ^bb114:  // 0x10588
      %bb114_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb114_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb114_2 = "braid.add"(%bb114_0, %bb114_1) : (i64, i64) -> i64
      "braid.set"(%bb114_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x1058c
      %bb118_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb118_1 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb118_2 = "braid.shl"(%bb118_0, %bb118_1) : (i64, i64) -> i64
      "braid.set"(%bb118_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb11c] : () -> ()
    ^bb11c:  // 0x10590
      %bb11c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb11c_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb11c_2 = "braid.add"(%bb11c_0, %bb11c_1) : (i64, i64) -> i64
      "braid.set"(%bb11c_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x10594
      %bb120_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb120_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb120_2 = "braid.add"(%bb120_0, %bb120_1) : (i64, i64) -> i64
      "braid.set"(%bb120_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb124] : () -> ()
    ^bb124:  // 0x10598
      %bb124_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb124_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb124_2 = "braid.add"(%bb124_0, %bb124_1) : (i64, i64) -> i64
      "braid.set"(%bb124_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb128] : () -> ()
    ^bb128:  // 0x1059c
      %bb128_0 = "braid.const"() {value = 66976 : i64} : () -> i64
      "braid_cf.br"()[^bb148] : () -> ()
    ^bb12c:  // 0x105a0
      %bb12c_0 = "braid.get"() {reg = "x21"} : () -> i64
      %bb12c_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb12c_2 = "braid.add"(%bb12c_0, %bb12c_1) : (i64, i64) -> i64
      "braid.set"(%bb12c_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb130] : () -> ()
    ^bb130:  // 0x105a4
      %bb130_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb130_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb130_2 = "braid.add"(%bb130_0, %bb130_1) : (i64, i64) -> i64
      %bb130_7 = "braid.load"(%bb130_2) {bytes = 1 : i64} : (i64) -> i64
      %bb130_8 = "braid.zext"(%bb130_7) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bb130_8) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb134:  // 0x105a8
      %bb134_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb134_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb134_2 = "braid.shl"(%bb134_0, %bb134_1) : (i64, i64) -> i64
      "braid.set"(%bb134_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb138] : () -> ()
    ^bb138:  // 0x105ac
      %bb138_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb138_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb138_2 = "braid.add"(%bb138_0, %bb138_1) : (i64, i64) -> i64
      "braid.set"(%bb138_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb13c] : () -> ()
    ^bb13c:  // 0x105b0
      %bb13c_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb13c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb13c_2 = "braid.or"(%bb13c_0, %bb13c_1) : (i64, i64) -> i64
      "braid.set"(%bb13c_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb140] : () -> ()
    ^bb140:  // 0x105b4
      %bb140_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb140_1 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb140_2 = "braid.add"(%bb140_0, %bb140_1) : (i64, i64) -> i64
      "braid.set"(%bb140_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb144] : () -> ()
    ^bb144:  // 0x105b8
      %bb144_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb144_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb144_2 = "braid.eq"(%bb144_0, %bb144_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb144_2)[^bbfc, ^bb148] : (i64) -> ()
    ^bb148:  // 0x105bc
      %bb148_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb148_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb148_2 = "braid.ult"(%bb148_0, %bb148_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb148_2)[^bb12c, ^bb14c] : (i64) -> ()
    ^bb14c:  // 0x105c0
      %bb14c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb14c_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb14c_2 = "braid.ne"(%bb14c_0, %bb14c_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb14c_2)[^bb158, ^bb150] : (i64) -> ()
    ^bb150:  // 0x105c4
      %bb150_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb150_1 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb150_2 = "braid.add"(%bb150_0, %bb150_1) : (i64, i64) -> i64
      "braid.set"(%bb150_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb154] : () -> ()
    ^bb154:  // 0x105c8
      %bb154_0 = "braid.const"() {value = 67020 : i64} : () -> i64
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb158:  // 0x105cc
      %bb158_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb158_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb158_2 = "braid.ult"(%bb158_0, %bb158_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb158_2)[^bb15c, ^bb164] : (i64) -> ()
    ^bb15c:  // 0x105d0
      %bb15c_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15c_2 = "braid.add"(%bb15c_0, %bb15c_1) : (i64, i64) -> i64
      "braid.set"(%bb15c_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb160] : () -> ()
    ^bb160:  // 0x105d4
      %bb160_0 = "braid.const"() {value = 67032 : i64} : () -> i64
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb164:  // 0x105d8
      %bb164_0 = "braid.get"() {reg = "x20"} : () -> i64
      %bb164_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb164_2 = "braid.const"() {value = 63 : i64} : () -> i64
      %bb164_3 = "braid.and"(%bb164_1, %bb164_2) : (i64, i64) -> i64
      %bb164_4 = "braid.lshr"(%bb164_0, %bb164_3) : (i64, i64) -> i64
      "braid.set"(%bb164_4) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb168] : () -> ()
    ^bb168:  // 0x105dc
      %bb168_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb168_1 = "braid.const"() {value = 255 : i64} : () -> i64
      %bb168_2 = "braid.and"(%bb168_0, %bb168_1) : (i64, i64) -> i64
      "braid.set"(%bb168_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb16c] : () -> ()
    ^bb16c:  // 0x105e0
      %bb16c_0 = "braid.const"() {value = 67044 : i64} : () -> i64
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb170:  // 0x105e4
      %bb170_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb170_1 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb170_2 = "braid.add"(%bb170_0, %bb170_1) : (i64, i64) -> i64
      "braid.set"(%bb170_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb174] : () -> ()
    ^bb174:  // 0x105e8
      %bb174_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb174_1 = "braid.const"() {value = 96 : i64} : () -> i64
      %bb174_2 = "braid.add"(%bb174_0, %bb174_1) : (i64, i64) -> i64
      "braid.set"(%bb174_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb178] : () -> ()
    ^bb178:  // 0x105ec
      %bb178_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb178_1 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb178_2 = "braid.add"(%bb178_0, %bb178_1) : (i64, i64) -> i64
      "braid.set"(%bb178_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb17c] : () -> ()
    ^bb17c:  // 0x105f0
      %bb17c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb17c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb17c_2 = "braid.add"(%bb17c_0, %bb17c_1) : (i64, i64) -> i64
      %bb17c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb17c_4 = "braid.and"(%bb17c_2, %bb17c_3) : (i64, i64) -> i64
      %bb17c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb17c_6 = "braid.eq"(%bb17c_4, %bb17c_5) : (i64, i64) -> i64
      "braid.guard"(%bb17c_6) : (i64) -> ()
      %bb17c_7 = "braid.load"(%bb17c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb17c_8 = "braid.sext"(%bb17c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb17c_8) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb180] : () -> ()
    ^bb180:  // 0x105f4
      %bb180_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb180_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb180_2 = "braid.add"(%bb180_0, %bb180_1) : (i64, i64) -> i64
      "braid.set"(%bb180_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb184] : () -> ()
    ^bb184:  // 0x105f8
      %bb184_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb184_1 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb184_2 = "braid.lshr"(%bb184_0, %bb184_1) : (i64, i64) -> i64
      "braid.set"(%bb184_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb188] : () -> ()
    ^bb188:  // 0x105fc
      %bb188_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb188_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb188_2 = "braid.lshr"(%bb188_0, %bb188_1) : (i64, i64) -> i64
      "braid.set"(%bb188_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb18c] : () -> ()
    ^bb18c:  // 0x10600
      %bb18c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb18c_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb18c_2 = "braid.lshr"(%bb18c_0, %bb18c_1) : (i64, i64) -> i64
      "braid.set"(%bb18c_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x10604
      %bb190_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb190_1 = "braid.const"() {value = -3 : i64} : () -> i64
      %bb190_2 = "braid.add"(%bb190_0, %bb190_1) : (i64, i64) -> i64
      %bb190_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bb190_2, %bb190_7) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb194] : () -> ()
    ^bb194:  // 0x10608
      %bb194_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb194_1 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb194_2 = "braid.add"(%bb194_0, %bb194_1) : (i64, i64) -> i64
      %bb194_7 = "braid.get"() {reg = "x15"} : () -> i64
      "braid.store"(%bb194_2, %bb194_7) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb198] : () -> ()
    ^bb198:  // 0x1060c
      %bb198_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb198_1 = "braid.const"() {value = -1 : i64} : () -> i64
      %bb198_2 = "braid.add"(%bb198_0, %bb198_1) : (i64, i64) -> i64
      %bb198_7 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.store"(%bb198_2, %bb198_7) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb19c] : () -> ()
    ^bb19c:  // 0x10610
      %bb19c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb19c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb19c_2 = "braid.add"(%bb19c_0, %bb19c_1) : (i64, i64) -> i64
      %bb19c_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bb19c_2, %bb19c_7) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1a0] : () -> ()
    ^bb1a0:  // 0x10614
      %bb1a0_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1a0_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1a0_2 = "braid.add"(%bb1a0_0, %bb1a0_1) : (i64, i64) -> i64
      "braid.set"(%bb1a0_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb1a4] : () -> ()
    ^bb1a4:  // 0x10618
      %bb1a4_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb1a4_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb1a4_2 = "braid.ne"(%bb1a4_0, %bb1a4_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb1a4_2)[^bb17c, ^bb1a8] : (i64) -> ()
    ^bb1a8:  // 0x1061c
      %bb1a8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1a8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1a8_2 = "braid.add"(%bb1a8_0, %bb1a8_1) : (i64, i64) -> i64
      "braid.set"(%bb1a8_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb1ac] : () -> ()
    ^bb1ac:  // 0x10620
      %bb1ac_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1ac_1 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb1ac_2 = "braid.add"(%bb1ac_0, %bb1ac_1) : (i64, i64) -> i64
      "braid.set"(%bb1ac_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb1b0] : () -> ()
    ^bb1b0:  // 0x10624
      %bb1b0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b0_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1b0_2 = "braid.add"(%bb1b0_0, %bb1b0_1) : (i64, i64) -> i64
      "braid.set"(%bb1b0_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb1b4] : () -> ()
    ^bb1b4:  // 0x10628
      %bb1b4_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb1b4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b4_2 = "braid.eq"(%bb1b4_0, %bb1b4_1) : (i64, i64) -> i64
      %bb1b4_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1b4_4 = "braid.eq"(%bb1b4_0, %bb1b4_3) : (i64, i64) -> i64
      %bb1b4_5 = "braid.or"(%bb1b4_2, %bb1b4_4) : (i64, i64) -> i64
      "braid.guard"(%bb1b4_5) : (i64) -> ()
      %bb1b4_6 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1b4_7 = "braid.get"() {reg = "x11"} : () -> i64
      %bb1b4_8 = "braid.select"(%bb1b4_4, %bb1b4_7, %bb1b4_1) : (i64, i64, i64) -> i64
      %bb1b4_9 = "braid.const"() {value = 16777216 : i64} : () -> i64
      %bb1b4_10 = "braid.ule"(%bb1b4_8, %bb1b4_9) : (i64, i64) -> i64
      "braid.guard"(%bb1b4_10) : (i64) -> ()
      "braid.out"(%bb1b4_6, %bb1b4_8) : (i64, i64) -> ()
      "braid_cf.exit"(%bb1b4_2, %bb1b4_6)[^bb1b4, ^bb1b8] : (i64, i64) -> ()
    ^bb1b8:  // 0x1062c
      %bb1b8_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b8_2 = "braid.add"(%bb1b8_0, %bb1b8_1) : (i64, i64) -> i64
      "braid.set"(%bb1b8_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb1bc] : () -> ()
    ^bb1bc:  // 0x10630
      %bb1bc_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1bc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1bc_2 = "braid.add"(%bb1bc_0, %bb1bc_1) : (i64, i64) -> i64
      "braid.set"(%bb1bc_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb1c0] : () -> ()
    ^bb1c0:  // 0x10634
      %bb1c0_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb1c0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c0_2 = "braid.eq"(%bb1c0_0, %bb1c0_1) : (i64, i64) -> i64
      %bb1c0_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1c0_4 = "braid.eq"(%bb1c0_0, %bb1c0_3) : (i64, i64) -> i64
      %bb1c0_5 = "braid.or"(%bb1c0_2, %bb1c0_4) : (i64, i64) -> i64
      "braid.guard"(%bb1c0_5) : (i64) -> ()
      %bb1c0_6 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1c0_7 = "braid.get"() {reg = "x11"} : () -> i64
      %bb1c0_8 = "braid.select"(%bb1c0_4, %bb1c0_7, %bb1c0_1) : (i64, i64, i64) -> i64
      %bb1c0_9 = "braid.const"() {value = 16777216 : i64} : () -> i64
      %bb1c0_10 = "braid.ule"(%bb1c0_8, %bb1c0_9) : (i64, i64) -> i64
      "braid.guard"(%bb1c0_10) : (i64) -> ()
      "braid.out"(%bb1c0_6, %bb1c0_8) : (i64, i64) -> ()
      "braid_cf.exit"(%bb1c0_2, %bb1c0_6)[^bb1c0, ^ext10638] : (i64, i64) -> ()
  }) {sym_name = "main", entry = 66676 : i64} : () -> ()
}) {arch = "riscv64"} : () -> ()
