"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      %bb0_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb0_4 = "braid.and"(%bb0_2, %bb0_3) : (i64, i64) -> i64
      %bb0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_6 = "braid.eq"(%bb0_4, %bb0_5) : (i64, i64) -> i64
      "braid.guard"(%bb0_6) : (i64) -> ()
      %bb0_7 = "braid.load"(%bb0_2) {bytes = 4 : i64} : (i64) -> i64
      %bb0_8 = "braid.sext"(%bb0_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb0_8) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      %bb4_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb4_4 = "braid.and"(%bb4_2, %bb4_3) : (i64, i64) -> i64
      %bb4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_6 = "braid.eq"(%bb4_4, %bb4_5) : (i64, i64) -> i64
      "braid.guard"(%bb4_6) : (i64) -> ()
      %bb4_7 = "braid.load"(%bb4_2) {bytes = 4 : i64} : (i64) -> i64
      %bb4_8 = "braid.sext"(%bb4_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb4_8) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb8_1 = "braid.const"() {value = 12 : i64} : () -> i64
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
      %bbc_1 = "braid.const"() {value = 8 : i64} : () -> i64
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
      %bb10_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      "braid.set"(%bb10_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10014
      %bb14_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb14_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb14_2 = "braid.xor"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      "braid.set"(%bb14_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10018
      %bb18_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb18_1 = "braid.zext"(%bb18_0) {bits = 32 : i64} : (i64) -> i64
      %bb18_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb18_3 = "braid.lshr"(%bb18_1, %bb18_2) : (i64, i64) -> i64
      %bb18_4 = "braid.sext"(%bb18_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb18_4) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1001c
      %bb1c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1c_2 = "braid.shl"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      "braid.set"(%bb1c_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10020
      %bb20_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb20_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb20_2 = "braid.or"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      "braid.set"(%bb20_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10024
      %bb24_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb24_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb24_2 = "braid.add"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      "braid.set"(%bb24_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10028
      %bb28_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb28_2 = "braid.xor"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      "braid.set"(%bb28_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x1002c
      %bb2c_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb2c_1 = "braid.zext"(%bb2c_0) {bits = 32 : i64} : (i64) -> i64
      %bb2c_2 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb2c_3 = "braid.lshr"(%bb2c_1, %bb2c_2) : (i64, i64) -> i64
      %bb2c_4 = "braid.sext"(%bb2c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2c_4) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10030
      %bb30_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb30_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb30_2 = "braid.shl"(%bb30_0, %bb30_1) : (i64, i64) -> i64
      "braid.set"(%bb30_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10034
      %bb34_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb34_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb34_2 = "braid.or"(%bb34_0, %bb34_1) : (i64, i64) -> i64
      "braid.set"(%bb34_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x10038
      %bb38_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb38_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb38_2 = "braid.add"(%bb38_0, %bb38_1) : (i64, i64) -> i64
      "braid.set"(%bb38_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x1003c
      %bb3c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb3c_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb3c_2 = "braid.xor"(%bb3c_0, %bb3c_1) : (i64, i64) -> i64
      "braid.set"(%bb3c_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x10040
      %bb40_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb40_1 = "braid.zext"(%bb40_0) {bits = 32 : i64} : (i64) -> i64
      %bb40_2 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb40_3 = "braid.lshr"(%bb40_1, %bb40_2) : (i64, i64) -> i64
      %bb40_4 = "braid.sext"(%bb40_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb40_4) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10044
      %bb44_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb44_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb44_2 = "braid.shl"(%bb44_0, %bb44_1) : (i64, i64) -> i64
      "braid.set"(%bb44_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x10048
      %bb48_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb48_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb48_2 = "braid.or"(%bb48_0, %bb48_1) : (i64, i64) -> i64
      "braid.set"(%bb48_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x1004c
      %bb4c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb4c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb4c_2 = "braid.add"(%bb4c_0, %bb4c_1) : (i64, i64) -> i64
      "braid.set"(%bb4c_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x10050
      %bb50_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb50_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb50_2 = "braid.xor"(%bb50_0, %bb50_1) : (i64, i64) -> i64
      "braid.set"(%bb50_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x10054
      %bb54_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb54_1 = "braid.zext"(%bb54_0) {bits = 32 : i64} : (i64) -> i64
      %bb54_2 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb54_3 = "braid.lshr"(%bb54_1, %bb54_2) : (i64, i64) -> i64
      %bb54_4 = "braid.sext"(%bb54_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb54_4) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x10058
      %bb58_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb58_1 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb58_2 = "braid.shl"(%bb58_0, %bb58_1) : (i64, i64) -> i64
      "braid.set"(%bb58_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x1005c
      %bb5c_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb5c_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb5c_2 = "braid.or"(%bb5c_0, %bb5c_1) : (i64, i64) -> i64
      "braid.set"(%bb5c_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x10060
      %bb60_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb60_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb60_2 = "braid.add"(%bb60_0, %bb60_1) : (i64, i64) -> i64
      %bb60_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb60_4 = "braid.and"(%bb60_2, %bb60_3) : (i64, i64) -> i64
      %bb60_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb60_6 = "braid.eq"(%bb60_4, %bb60_5) : (i64, i64) -> i64
      "braid.guard"(%bb60_6) : (i64) -> ()
      %bb60_7 = "braid.get"() {reg = "x11"} : () -> i64
      "braid.store"(%bb60_2, %bb60_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x10064
      %bb64_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb64_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb64_2 = "braid.add"(%bb64_0, %bb64_1) : (i64, i64) -> i64
      %bb64_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb64_4 = "braid.and"(%bb64_2, %bb64_3) : (i64, i64) -> i64
      %bb64_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb64_6 = "braid.eq"(%bb64_4, %bb64_5) : (i64, i64) -> i64
      "braid.guard"(%bb64_6) : (i64) -> ()
      %bb64_7 = "braid.get"() {reg = "x12"} : () -> i64
      "braid.store"(%bb64_2, %bb64_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x10068
      %bb68_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb68_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb68_2 = "braid.add"(%bb68_0, %bb68_1) : (i64, i64) -> i64
      %bb68_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb68_4 = "braid.and"(%bb68_2, %bb68_3) : (i64, i64) -> i64
      %bb68_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb68_6 = "braid.eq"(%bb68_4, %bb68_5) : (i64, i64) -> i64
      "braid.guard"(%bb68_6) : (i64) -> ()
      %bb68_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bb68_2, %bb68_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x1006c
      %bb6c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb6c_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb6c_2 = "braid.add"(%bb6c_0, %bb6c_1) : (i64, i64) -> i64
      %bb6c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb6c_4 = "braid.and"(%bb6c_2, %bb6c_3) : (i64, i64) -> i64
      %bb6c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6c_6 = "braid.eq"(%bb6c_4, %bb6c_5) : (i64, i64) -> i64
      "braid.guard"(%bb6c_6) : (i64) -> ()
      %bb6c_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bb6c_2, %bb6c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x10070
      %bb70_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb70_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb70_2 = "braid.add"(%bb70_0, %bb70_1) : (i64, i64) -> i64
      %bb70_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb70_4 = "braid.and"(%bb70_2, %bb70_3) : (i64, i64) -> i64
      %bb70_5 = "braid.const"() {value = 65652 : i64} : () -> i64
      "braid_cf.br_ind"(%bb70_4) : (i64) -> ()
  }) {sym_name = "quarter_round", entry = 65536 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10074
      %bb0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb0_1 = "braid.const"() {value = -112 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10078
      %bb4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4_1 = "braid.const"() {value = 104 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      %bb4_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb4_4 = "braid.and"(%bb4_2, %bb4_3) : (i64, i64) -> i64
      %bb4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_6 = "braid.eq"(%bb4_4, %bb4_5) : (i64, i64) -> i64
      "braid.guard"(%bb4_6) : (i64) -> ()
      %bb4_7 = "braid.get"() {reg = "x8"} : () -> i64
      "braid.store"(%bb4_2, %bb4_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1007c
      %bb8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb8_1 = "braid.const"() {value = 96 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb8_4 = "braid.and"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      %bb8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_6 = "braid.eq"(%bb8_4, %bb8_5) : (i64, i64) -> i64
      "braid.guard"(%bb8_6) : (i64) -> ()
      %bb8_7 = "braid.get"() {reg = "x9"} : () -> i64
      "braid.store"(%bb8_2, %bb8_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10080
      %bbc_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bbc_1 = "braid.const"() {value = 88 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      %bbc_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbc_4 = "braid.and"(%bbc_2, %bbc_3) : (i64, i64) -> i64
      %bbc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_6 = "braid.eq"(%bbc_4, %bbc_5) : (i64, i64) -> i64
      "braid.guard"(%bbc_6) : (i64) -> ()
      %bbc_7 = "braid.get"() {reg = "x18"} : () -> i64
      "braid.store"(%bbc_2, %bbc_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10084
      %bb10_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb10_1 = "braid.const"() {value = 80 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb10_4 = "braid.and"(%bb10_2, %bb10_3) : (i64, i64) -> i64
      %bb10_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_6 = "braid.eq"(%bb10_4, %bb10_5) : (i64, i64) -> i64
      "braid.guard"(%bb10_6) : (i64) -> ()
      %bb10_7 = "braid.get"() {reg = "x19"} : () -> i64
      "braid.store"(%bb10_2, %bb10_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10088
      %bb14_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb14_1 = "braid.const"() {value = 72 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      %bb14_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb14_4 = "braid.and"(%bb14_2, %bb14_3) : (i64, i64) -> i64
      %bb14_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_6 = "braid.eq"(%bb14_4, %bb14_5) : (i64, i64) -> i64
      "braid.guard"(%bb14_6) : (i64) -> ()
      %bb14_7 = "braid.get"() {reg = "x20"} : () -> i64
      "braid.store"(%bb14_2, %bb14_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x1008c
      %bb18_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb18_1 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      "braid.set"(%bb18_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10090
      %bb1c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      "braid.set"(%bb1c_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10094
      %bb20_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb20_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_2 = "braid.add"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      "braid.set"(%bb20_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10098
      %bb24_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb24_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_2 = "braid.add"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      %bb24_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb24_4 = "braid.and"(%bb24_2, %bb24_3) : (i64, i64) -> i64
      %bb24_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_6 = "braid.eq"(%bb24_4, %bb24_5) : (i64, i64) -> i64
      "braid.guard"(%bb24_6) : (i64) -> ()
      %bb24_7 = "braid.load"(%bb24_2) {bytes = 4 : i64} : (i64) -> i64
      %bb24_8 = "braid.sext"(%bb24_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb24_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x1009c
      %bb28_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb28_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb28_2 = "braid.add"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      "braid.set"(%bb28_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x100a0
      %bb2c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb2c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_2 = "braid.add"(%bb2c_0, %bb2c_1) : (i64, i64) -> i64
      %bb2c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb2c_4 = "braid.and"(%bb2c_2, %bb2c_3) : (i64, i64) -> i64
      %bb2c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_6 = "braid.eq"(%bb2c_4, %bb2c_5) : (i64, i64) -> i64
      "braid.guard"(%bb2c_6) : (i64) -> ()
      %bb2c_7 = "braid.get"() {reg = "x15"} : () -> i64
      "braid.store"(%bb2c_2, %bb2c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x100a4
      %bb30_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb30_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb30_2 = "braid.add"(%bb30_0, %bb30_1) : (i64, i64) -> i64
      "braid.set"(%bb30_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x100a8
      %bb34_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb34_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb34_2 = "braid.ne"(%bb34_0, %bb34_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb34_2)[^bb24, ^bb38] : (i64) -> ()
    ^bb38:  // 0x100ac
      %bb38_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb38_1 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb38_2 = "braid.add"(%bb38_0, %bb38_1) : (i64, i64) -> i64
      %bb38_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb38_4 = "braid.and"(%bb38_2, %bb38_3) : (i64, i64) -> i64
      %bb38_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb38_6 = "braid.eq"(%bb38_4, %bb38_5) : (i64, i64) -> i64
      "braid.guard"(%bb38_6) : (i64) -> ()
      %bb38_7 = "braid.load"(%bb38_2) {bytes = 4 : i64} : (i64) -> i64
      %bb38_8 = "braid.sext"(%bb38_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb38_8) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x100b0
      %bb3c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb3c_1 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb3c_2 = "braid.add"(%bb3c_0, %bb3c_1) : (i64, i64) -> i64
      %bb3c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb3c_4 = "braid.and"(%bb3c_2, %bb3c_3) : (i64, i64) -> i64
      %bb3c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3c_6 = "braid.eq"(%bb3c_4, %bb3c_5) : (i64, i64) -> i64
      "braid.guard"(%bb3c_6) : (i64) -> ()
      %bb3c_7 = "braid.load"(%bb3c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb3c_8 = "braid.sext"(%bb3c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb3c_8) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x100b4
      %bb40_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb40_1 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb40_2 = "braid.add"(%bb40_0, %bb40_1) : (i64, i64) -> i64
      %bb40_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb40_4 = "braid.and"(%bb40_2, %bb40_3) : (i64, i64) -> i64
      %bb40_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb40_6 = "braid.eq"(%bb40_4, %bb40_5) : (i64, i64) -> i64
      "braid.guard"(%bb40_6) : (i64) -> ()
      %bb40_7 = "braid.load"(%bb40_2) {bytes = 4 : i64} : (i64) -> i64
      %bb40_8 = "braid.sext"(%bb40_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb40_8) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x100b8
      %bb44_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb44_1 = "braid.const"() {value = 36 : i64} : () -> i64
      %bb44_2 = "braid.add"(%bb44_0, %bb44_1) : (i64, i64) -> i64
      %bb44_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb44_4 = "braid.and"(%bb44_2, %bb44_3) : (i64, i64) -> i64
      %bb44_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb44_6 = "braid.eq"(%bb44_4, %bb44_5) : (i64, i64) -> i64
      "braid.guard"(%bb44_6) : (i64) -> ()
      %bb44_7 = "braid.load"(%bb44_2) {bytes = 4 : i64} : (i64) -> i64
      %bb44_8 = "braid.sext"(%bb44_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb44_8) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x100bc
      %bb48_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb48_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb48_2 = "braid.add"(%bb48_0, %bb48_1) : (i64, i64) -> i64
      %bb48_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb48_4 = "braid.and"(%bb48_2, %bb48_3) : (i64, i64) -> i64
      %bb48_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb48_6 = "braid.eq"(%bb48_4, %bb48_5) : (i64, i64) -> i64
      "braid.guard"(%bb48_6) : (i64) -> ()
      %bb48_7 = "braid.load"(%bb48_2) {bytes = 4 : i64} : (i64) -> i64
      %bb48_8 = "braid.sext"(%bb48_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb48_8) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x100c0
      %bb4c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4c_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb4c_2 = "braid.add"(%bb4c_0, %bb4c_1) : (i64, i64) -> i64
      %bb4c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb4c_4 = "braid.and"(%bb4c_2, %bb4c_3) : (i64, i64) -> i64
      %bb4c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4c_6 = "braid.eq"(%bb4c_4, %bb4c_5) : (i64, i64) -> i64
      "braid.guard"(%bb4c_6) : (i64) -> ()
      %bb4c_7 = "braid.load"(%bb4c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb4c_8 = "braid.sext"(%bb4c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb4c_8) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x100c4
      %bb50_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb50_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb50_2 = "braid.add"(%bb50_0, %bb50_1) : (i64, i64) -> i64
      %bb50_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb50_4 = "braid.and"(%bb50_2, %bb50_3) : (i64, i64) -> i64
      %bb50_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb50_6 = "braid.eq"(%bb50_4, %bb50_5) : (i64, i64) -> i64
      "braid.guard"(%bb50_6) : (i64) -> ()
      %bb50_7 = "braid.load"(%bb50_2) {bytes = 4 : i64} : (i64) -> i64
      %bb50_8 = "braid.sext"(%bb50_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb50_8) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x100c8
      %bb54_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb54_1 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb54_2 = "braid.add"(%bb54_0, %bb54_1) : (i64, i64) -> i64
      %bb54_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb54_4 = "braid.and"(%bb54_2, %bb54_3) : (i64, i64) -> i64
      %bb54_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb54_6 = "braid.eq"(%bb54_4, %bb54_5) : (i64, i64) -> i64
      "braid.guard"(%bb54_6) : (i64) -> ()
      %bb54_7 = "braid.load"(%bb54_2) {bytes = 4 : i64} : (i64) -> i64
      %bb54_8 = "braid.sext"(%bb54_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb54_8) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x100cc
      %bb58_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb58_1 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb58_2 = "braid.add"(%bb58_0, %bb58_1) : (i64, i64) -> i64
      %bb58_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb58_4 = "braid.and"(%bb58_2, %bb58_3) : (i64, i64) -> i64
      %bb58_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb58_6 = "braid.eq"(%bb58_4, %bb58_5) : (i64, i64) -> i64
      "braid.guard"(%bb58_6) : (i64) -> ()
      %bb58_7 = "braid.load"(%bb58_2) {bytes = 4 : i64} : (i64) -> i64
      %bb58_8 = "braid.sext"(%bb58_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb58_8) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x100d0
      %bb5c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb5c_1 = "braid.const"() {value = 60 : i64} : () -> i64
      %bb5c_2 = "braid.add"(%bb5c_0, %bb5c_1) : (i64, i64) -> i64
      %bb5c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb5c_4 = "braid.and"(%bb5c_2, %bb5c_3) : (i64, i64) -> i64
      %bb5c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb5c_6 = "braid.eq"(%bb5c_4, %bb5c_5) : (i64, i64) -> i64
      "braid.guard"(%bb5c_6) : (i64) -> ()
      %bb5c_7 = "braid.load"(%bb5c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb5c_8 = "braid.sext"(%bb5c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb5c_8) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x100d4
      %bb60_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb60_1 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb60_2 = "braid.add"(%bb60_0, %bb60_1) : (i64, i64) -> i64
      %bb60_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb60_4 = "braid.and"(%bb60_2, %bb60_3) : (i64, i64) -> i64
      %bb60_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb60_6 = "braid.eq"(%bb60_4, %bb60_5) : (i64, i64) -> i64
      "braid.guard"(%bb60_6) : (i64) -> ()
      %bb60_7 = "braid.load"(%bb60_2) {bytes = 4 : i64} : (i64) -> i64
      %bb60_8 = "braid.sext"(%bb60_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb60_8) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x100d8
      %bb64_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb64_1 = "braid.const"() {value = 68 : i64} : () -> i64
      %bb64_2 = "braid.add"(%bb64_0, %bb64_1) : (i64, i64) -> i64
      %bb64_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb64_4 = "braid.and"(%bb64_2, %bb64_3) : (i64, i64) -> i64
      %bb64_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb64_6 = "braid.eq"(%bb64_4, %bb64_5) : (i64, i64) -> i64
      "braid.guard"(%bb64_6) : (i64) -> ()
      %bb64_7 = "braid.load"(%bb64_2) {bytes = 4 : i64} : (i64) -> i64
      %bb64_8 = "braid.sext"(%bb64_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb64_8) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x100dc
      %bb68_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb68_1 = "braid.const"() {value = 40 : i64} : () -> i64
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
    ^bb6c:  // 0x100e0
      %bb6c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb6c_1 = "braid.const"() {value = 44 : i64} : () -> i64
      %bb6c_2 = "braid.add"(%bb6c_0, %bb6c_1) : (i64, i64) -> i64
      %bb6c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb6c_4 = "braid.and"(%bb6c_2, %bb6c_3) : (i64, i64) -> i64
      %bb6c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6c_6 = "braid.eq"(%bb6c_4, %bb6c_5) : (i64, i64) -> i64
      "braid.guard"(%bb6c_6) : (i64) -> ()
      %bb6c_7 = "braid.load"(%bb6c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb6c_8 = "braid.sext"(%bb6c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb6c_8) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x100e4
      %bb70_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb70_1 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb70_2 = "braid.add"(%bb70_0, %bb70_1) : (i64, i64) -> i64
      %bb70_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb70_4 = "braid.and"(%bb70_2, %bb70_3) : (i64, i64) -> i64
      %bb70_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb70_6 = "braid.eq"(%bb70_4, %bb70_5) : (i64, i64) -> i64
      "braid.guard"(%bb70_6) : (i64) -> ()
      %bb70_7 = "braid.load"(%bb70_2) {bytes = 4 : i64} : (i64) -> i64
      %bb70_8 = "braid.sext"(%bb70_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb70_8) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x100e8
      %bb74_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb74_1 = "braid.const"() {value = 52 : i64} : () -> i64
      %bb74_2 = "braid.add"(%bb74_0, %bb74_1) : (i64, i64) -> i64
      %bb74_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb74_4 = "braid.and"(%bb74_2, %bb74_3) : (i64, i64) -> i64
      %bb74_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb74_6 = "braid.eq"(%bb74_4, %bb74_5) : (i64, i64) -> i64
      "braid.guard"(%bb74_6) : (i64) -> ()
      %bb74_7 = "braid.load"(%bb74_2) {bytes = 4 : i64} : (i64) -> i64
      %bb74_8 = "braid.sext"(%bb74_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb74_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x100ec
      %bb78_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb78_1 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb78_2 = "braid.add"(%bb78_0, %bb78_1) : (i64, i64) -> i64
      "braid.set"(%bb78_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x100f0
      %bb7c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb7c_1 = "braid.get"() {reg = "x31"} : () -> i64
      %bb7c_2 = "braid.add"(%bb7c_0, %bb7c_1) : (i64, i64) -> i64
      "braid.set"(%bb7c_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x100f4
      %bb80_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb80_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb80_2 = "braid.add"(%bb80_0, %bb80_1) : (i64, i64) -> i64
      "braid.set"(%bb80_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x100f8
      %bb84_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb84_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb84_2 = "braid.add"(%bb84_0, %bb84_1) : (i64, i64) -> i64
      "braid.set"(%bb84_2) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x100fc
      %bb88_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb88_1 = "braid.get"() {reg = "x28"} : () -> i64
      %bb88_2 = "braid.add"(%bb88_0, %bb88_1) : (i64, i64) -> i64
      "braid.set"(%bb88_2) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x10100
      %bb8c_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb8c_1 = "braid.const"() {value = -1 : i64} : () -> i64
      %bb8c_2 = "braid.add"(%bb8c_0, %bb8c_1) : (i64, i64) -> i64
      %bb8c_3 = "braid.sext"(%bb8c_2) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb8c_3) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x10104
      %bb90_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb90_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb90_2 = "braid.xor"(%bb90_0, %bb90_1) : (i64, i64) -> i64
      "braid.set"(%bb90_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x10108
      %bb94_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb94_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb94_2 = "braid.xor"(%bb94_0, %bb94_1) : (i64, i64) -> i64
      "braid.set"(%bb94_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x1010c
      %bb98_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb98_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb98_2 = "braid.xor"(%bb98_0, %bb98_1) : (i64, i64) -> i64
      "braid.set"(%bb98_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x10110
      %bb9c_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb9c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb9c_2 = "braid.xor"(%bb9c_0, %bb9c_1) : (i64, i64) -> i64
      "braid.set"(%bb9c_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x10114
      %bba0_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bba0_1 = "braid.zext"(%bba0_0) {bits = 32 : i64} : (i64) -> i64
      %bba0_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bba0_3 = "braid.lshr"(%bba0_1, %bba0_2) : (i64, i64) -> i64
      %bba0_4 = "braid.sext"(%bba0_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bba0_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bba4] : () -> ()
    ^bba4:  // 0x10118
      %bba4_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bba4_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bba4_2 = "braid.shl"(%bba4_0, %bba4_1) : (i64, i64) -> i64
      "braid.set"(%bba4_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x1011c
      %bba8_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bba8_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bba8_2 = "braid.or"(%bba8_0, %bba8_1) : (i64, i64) -> i64
      "braid.set"(%bba8_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x10120
      %bbac_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bbac_1 = "braid.zext"(%bbac_0) {bits = 32 : i64} : (i64) -> i64
      %bbac_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbac_3 = "braid.lshr"(%bbac_1, %bbac_2) : (i64, i64) -> i64
      %bbac_4 = "braid.sext"(%bbac_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbac_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x10124
      %bbb0_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bbb0_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbb0_2 = "braid.shl"(%bbb0_0, %bbb0_1) : (i64, i64) -> i64
      "braid.set"(%bbb0_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x10128
      %bbb4_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bbb4_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bbb4_2 = "braid.or"(%bbb4_0, %bbb4_1) : (i64, i64) -> i64
      "braid.set"(%bbb4_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x1012c
      %bbb8_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bbb8_1 = "braid.zext"(%bbb8_0) {bits = 32 : i64} : (i64) -> i64
      %bbb8_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbb8_3 = "braid.lshr"(%bbb8_1, %bbb8_2) : (i64, i64) -> i64
      %bbb8_4 = "braid.sext"(%bbb8_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbb8_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x10130
      %bbbc_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bbbc_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbbc_2 = "braid.shl"(%bbbc_0, %bbbc_1) : (i64, i64) -> i64
      "braid.set"(%bbbc_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bbc0:  // 0x10134
      %bbc0_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bbc0_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bbc0_2 = "braid.or"(%bbc0_0, %bbc0_1) : (i64, i64) -> i64
      "braid.set"(%bbc0_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x10138
      %bbc4_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bbc4_1 = "braid.zext"(%bbc4_0) {bits = 32 : i64} : (i64) -> i64
      %bbc4_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbc4_3 = "braid.lshr"(%bbc4_1, %bbc4_2) : (i64, i64) -> i64
      %bbc4_4 = "braid.sext"(%bbc4_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbc4_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x1013c
      %bbc8_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bbc8_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbc8_2 = "braid.shl"(%bbc8_0, %bbc8_1) : (i64, i64) -> i64
      "braid.set"(%bbc8_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x10140
      %bbcc_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bbcc_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bbcc_2 = "braid.or"(%bbcc_0, %bbcc_1) : (i64, i64) -> i64
      "braid.set"(%bbcc_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x10144
      %bbd0_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bbd0_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bbd0_2 = "braid.add"(%bbd0_0, %bbd0_1) : (i64, i64) -> i64
      "braid.set"(%bbd0_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x10148
      %bbd4_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bbd4_1 = "braid.get"() {reg = "x29"} : () -> i64
      %bbd4_2 = "braid.add"(%bbd4_0, %bbd4_1) : (i64, i64) -> i64
      "braid.set"(%bbd4_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bbd8] : () -> ()
    ^bbd8:  // 0x1014c
      %bbd8_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbd8_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bbd8_2 = "braid.add"(%bbd8_0, %bbd8_1) : (i64, i64) -> i64
      "braid.set"(%bbd8_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x10150
      %bbdc_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bbdc_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bbdc_2 = "braid.add"(%bbdc_0, %bbdc_1) : (i64, i64) -> i64
      "braid.set"(%bbdc_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bbe0] : () -> ()
    ^bbe0:  // 0x10154
      %bbe0_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bbe0_1 = "braid.get"() {reg = "x31"} : () -> i64
      %bbe0_2 = "braid.xor"(%bbe0_0, %bbe0_1) : (i64, i64) -> i64
      "braid.set"(%bbe0_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x10158
      %bbe4_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bbe4_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bbe4_2 = "braid.xor"(%bbe4_0, %bbe4_1) : (i64, i64) -> i64
      "braid.set"(%bbe4_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bbe8] : () -> ()
    ^bbe8:  // 0x1015c
      %bbe8_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbe8_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bbe8_2 = "braid.xor"(%bbe8_0, %bbe8_1) : (i64, i64) -> i64
      "braid.set"(%bbe8_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bbec] : () -> ()
    ^bbec:  // 0x10160
      %bbec_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bbec_1 = "braid.get"() {reg = "x28"} : () -> i64
      %bbec_2 = "braid.xor"(%bbec_0, %bbec_1) : (i64, i64) -> i64
      "braid.set"(%bbec_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bbf0] : () -> ()
    ^bbf0:  // 0x10164
      %bbf0_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bbf0_1 = "braid.zext"(%bbf0_0) {bits = 32 : i64} : (i64) -> i64
      %bbf0_2 = "braid.const"() {value = 20 : i64} : () -> i64
      %bbf0_3 = "braid.lshr"(%bbf0_1, %bbf0_2) : (i64, i64) -> i64
      %bbf0_4 = "braid.sext"(%bbf0_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbf0_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bbf4] : () -> ()
    ^bbf4:  // 0x10168
      %bbf4_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bbf4_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bbf4_2 = "braid.shl"(%bbf4_0, %bbf4_1) : (i64, i64) -> i64
      "braid.set"(%bbf4_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bbf8] : () -> ()
    ^bbf8:  // 0x1016c
      %bbf8_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bbf8_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bbf8_2 = "braid.or"(%bbf8_0, %bbf8_1) : (i64, i64) -> i64
      "braid.set"(%bbf8_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bbfc] : () -> ()
    ^bbfc:  // 0x10170
      %bbfc_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bbfc_1 = "braid.zext"(%bbfc_0) {bits = 32 : i64} : (i64) -> i64
      %bbfc_2 = "braid.const"() {value = 20 : i64} : () -> i64
      %bbfc_3 = "braid.lshr"(%bbfc_1, %bbfc_2) : (i64, i64) -> i64
      %bbfc_4 = "braid.sext"(%bbfc_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbfc_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb100:  // 0x10174
      %bb100_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb100_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb100_2 = "braid.shl"(%bb100_0, %bb100_1) : (i64, i64) -> i64
      "braid.set"(%bb100_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb104] : () -> ()
    ^bb104:  // 0x10178
      %bb104_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb104_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb104_2 = "braid.or"(%bb104_0, %bb104_1) : (i64, i64) -> i64
      "braid.set"(%bb104_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x1017c
      %bb108_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb108_1 = "braid.zext"(%bb108_0) {bits = 32 : i64} : (i64) -> i64
      %bb108_2 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb108_3 = "braid.lshr"(%bb108_1, %bb108_2) : (i64, i64) -> i64
      %bb108_4 = "braid.sext"(%bb108_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb108_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb10c] : () -> ()
    ^bb10c:  // 0x10180
      %bb10c_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb10c_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb10c_2 = "braid.shl"(%bb10c_0, %bb10c_1) : (i64, i64) -> i64
      "braid.set"(%bb10c_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb110] : () -> ()
    ^bb110:  // 0x10184
      %bb110_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb110_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb110_2 = "braid.or"(%bb110_0, %bb110_1) : (i64, i64) -> i64
      "braid.set"(%bb110_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb114] : () -> ()
    ^bb114:  // 0x10188
      %bb114_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb114_1 = "braid.zext"(%bb114_0) {bits = 32 : i64} : (i64) -> i64
      %bb114_2 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb114_3 = "braid.lshr"(%bb114_1, %bb114_2) : (i64, i64) -> i64
      %bb114_4 = "braid.sext"(%bb114_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb114_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x1018c
      %bb118_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb118_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb118_2 = "braid.shl"(%bb118_0, %bb118_1) : (i64, i64) -> i64
      "braid.set"(%bb118_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb11c] : () -> ()
    ^bb11c:  // 0x10190
      %bb11c_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb11c_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb11c_2 = "braid.or"(%bb11c_0, %bb11c_1) : (i64, i64) -> i64
      "braid.set"(%bb11c_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x10194
      %bb120_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb120_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb120_2 = "braid.add"(%bb120_0, %bb120_1) : (i64, i64) -> i64
      "braid.set"(%bb120_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb124] : () -> ()
    ^bb124:  // 0x10198
      %bb124_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb124_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb124_2 = "braid.add"(%bb124_0, %bb124_1) : (i64, i64) -> i64
      "braid.set"(%bb124_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb128] : () -> ()
    ^bb128:  // 0x1019c
      %bb128_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb128_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb128_2 = "braid.add"(%bb128_0, %bb128_1) : (i64, i64) -> i64
      "braid.set"(%bb128_2) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb12c] : () -> ()
    ^bb12c:  // 0x101a0
      %bb12c_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb12c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb12c_2 = "braid.add"(%bb12c_0, %bb12c_1) : (i64, i64) -> i64
      "braid.set"(%bb12c_2) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb130] : () -> ()
    ^bb130:  // 0x101a4
      %bb130_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb130_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb130_2 = "braid.xor"(%bb130_0, %bb130_1) : (i64, i64) -> i64
      "braid.set"(%bb130_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb134:  // 0x101a8
      %bb134_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb134_1 = "braid.get"() {reg = "x29"} : () -> i64
      %bb134_2 = "braid.xor"(%bb134_0, %bb134_1) : (i64, i64) -> i64
      "braid.set"(%bb134_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb138] : () -> ()
    ^bb138:  // 0x101ac
      %bb138_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb138_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb138_2 = "braid.xor"(%bb138_0, %bb138_1) : (i64, i64) -> i64
      "braid.set"(%bb138_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb13c] : () -> ()
    ^bb13c:  // 0x101b0
      %bb13c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb13c_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb13c_2 = "braid.xor"(%bb13c_0, %bb13c_1) : (i64, i64) -> i64
      "braid.set"(%bb13c_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb140] : () -> ()
    ^bb140:  // 0x101b4
      %bb140_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb140_1 = "braid.zext"(%bb140_0) {bits = 32 : i64} : (i64) -> i64
      %bb140_2 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb140_3 = "braid.lshr"(%bb140_1, %bb140_2) : (i64, i64) -> i64
      %bb140_4 = "braid.sext"(%bb140_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb140_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb144] : () -> ()
    ^bb144:  // 0x101b8
      %bb144_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb144_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb144_2 = "braid.shl"(%bb144_0, %bb144_1) : (i64, i64) -> i64
      "braid.set"(%bb144_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb148] : () -> ()
    ^bb148:  // 0x101bc
      %bb148_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb148_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb148_2 = "braid.or"(%bb148_0, %bb148_1) : (i64, i64) -> i64
      "braid.set"(%bb148_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb14c] : () -> ()
    ^bb14c:  // 0x101c0
      %bb14c_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb14c_1 = "braid.zext"(%bb14c_0) {bits = 32 : i64} : (i64) -> i64
      %bb14c_2 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb14c_3 = "braid.lshr"(%bb14c_1, %bb14c_2) : (i64, i64) -> i64
      %bb14c_4 = "braid.sext"(%bb14c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb14c_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb150] : () -> ()
    ^bb150:  // 0x101c4
      %bb150_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb150_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb150_2 = "braid.shl"(%bb150_0, %bb150_1) : (i64, i64) -> i64
      "braid.set"(%bb150_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb154] : () -> ()
    ^bb154:  // 0x101c8
      %bb154_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb154_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb154_2 = "braid.or"(%bb154_0, %bb154_1) : (i64, i64) -> i64
      "braid.set"(%bb154_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb158] : () -> ()
    ^bb158:  // 0x101cc
      %bb158_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb158_1 = "braid.zext"(%bb158_0) {bits = 32 : i64} : (i64) -> i64
      %bb158_2 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb158_3 = "braid.lshr"(%bb158_1, %bb158_2) : (i64, i64) -> i64
      %bb158_4 = "braid.sext"(%bb158_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb158_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb15c] : () -> ()
    ^bb15c:  // 0x101d0
      %bb15c_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb15c_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb15c_2 = "braid.shl"(%bb15c_0, %bb15c_1) : (i64, i64) -> i64
      "braid.set"(%bb15c_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb160] : () -> ()
    ^bb160:  // 0x101d4
      %bb160_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb160_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb160_2 = "braid.or"(%bb160_0, %bb160_1) : (i64, i64) -> i64
      "braid.set"(%bb160_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb164] : () -> ()
    ^bb164:  // 0x101d8
      %bb164_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb164_1 = "braid.zext"(%bb164_0) {bits = 32 : i64} : (i64) -> i64
      %bb164_2 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb164_3 = "braid.lshr"(%bb164_1, %bb164_2) : (i64, i64) -> i64
      %bb164_4 = "braid.sext"(%bb164_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb164_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb168] : () -> ()
    ^bb168:  // 0x101dc
      %bb168_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb168_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb168_2 = "braid.shl"(%bb168_0, %bb168_1) : (i64, i64) -> i64
      "braid.set"(%bb168_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb16c] : () -> ()
    ^bb16c:  // 0x101e0
      %bb16c_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb16c_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb16c_2 = "braid.or"(%bb16c_0, %bb16c_1) : (i64, i64) -> i64
      "braid.set"(%bb16c_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb170] : () -> ()
    ^bb170:  // 0x101e4
      %bb170_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb170_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb170_2 = "braid.add"(%bb170_0, %bb170_1) : (i64, i64) -> i64
      "braid.set"(%bb170_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb174] : () -> ()
    ^bb174:  // 0x101e8
      %bb174_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb174_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb174_2 = "braid.add"(%bb174_0, %bb174_1) : (i64, i64) -> i64
      "braid.set"(%bb174_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb178] : () -> ()
    ^bb178:  // 0x101ec
      %bb178_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb178_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb178_2 = "braid.add"(%bb178_0, %bb178_1) : (i64, i64) -> i64
      "braid.set"(%bb178_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb17c] : () -> ()
    ^bb17c:  // 0x101f0
      %bb17c_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb17c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb17c_2 = "braid.add"(%bb17c_0, %bb17c_1) : (i64, i64) -> i64
      "braid.set"(%bb17c_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb180] : () -> ()
    ^bb180:  // 0x101f4
      %bb180_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb180_1 = "braid.get"() {reg = "x31"} : () -> i64
      %bb180_2 = "braid.xor"(%bb180_0, %bb180_1) : (i64, i64) -> i64
      "braid.set"(%bb180_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb184] : () -> ()
    ^bb184:  // 0x101f8
      %bb184_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb184_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb184_2 = "braid.xor"(%bb184_0, %bb184_1) : (i64, i64) -> i64
      "braid.set"(%bb184_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb188] : () -> ()
    ^bb188:  // 0x101fc
      %bb188_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb188_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb188_2 = "braid.xor"(%bb188_0, %bb188_1) : (i64, i64) -> i64
      "braid.set"(%bb188_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb18c] : () -> ()
    ^bb18c:  // 0x10200
      %bb18c_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb18c_1 = "braid.get"() {reg = "x28"} : () -> i64
      %bb18c_2 = "braid.xor"(%bb18c_0, %bb18c_1) : (i64, i64) -> i64
      "braid.set"(%bb18c_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x10204
      %bb190_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb190_1 = "braid.zext"(%bb190_0) {bits = 32 : i64} : (i64) -> i64
      %bb190_2 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb190_3 = "braid.lshr"(%bb190_1, %bb190_2) : (i64, i64) -> i64
      %bb190_4 = "braid.sext"(%bb190_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb190_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb194] : () -> ()
    ^bb194:  // 0x10208
      %bb194_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb194_1 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb194_2 = "braid.shl"(%bb194_0, %bb194_1) : (i64, i64) -> i64
      "braid.set"(%bb194_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb198] : () -> ()
    ^bb198:  // 0x1020c
      %bb198_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb198_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb198_2 = "braid.or"(%bb198_0, %bb198_1) : (i64, i64) -> i64
      "braid.set"(%bb198_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb19c] : () -> ()
    ^bb19c:  // 0x10210
      %bb19c_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb19c_1 = "braid.zext"(%bb19c_0) {bits = 32 : i64} : (i64) -> i64
      %bb19c_2 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb19c_3 = "braid.lshr"(%bb19c_1, %bb19c_2) : (i64, i64) -> i64
      %bb19c_4 = "braid.sext"(%bb19c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb19c_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb1a0] : () -> ()
    ^bb1a0:  // 0x10214
      %bb1a0_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb1a0_1 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1a0_2 = "braid.shl"(%bb1a0_0, %bb1a0_1) : (i64, i64) -> i64
      "braid.set"(%bb1a0_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb1a4] : () -> ()
    ^bb1a4:  // 0x10218
      %bb1a4_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb1a4_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb1a4_2 = "braid.or"(%bb1a4_0, %bb1a4_1) : (i64, i64) -> i64
      "braid.set"(%bb1a4_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb1a8] : () -> ()
    ^bb1a8:  // 0x1021c
      %bb1a8_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb1a8_1 = "braid.zext"(%bb1a8_0) {bits = 32 : i64} : (i64) -> i64
      %bb1a8_2 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1a8_3 = "braid.lshr"(%bb1a8_1, %bb1a8_2) : (i64, i64) -> i64
      %bb1a8_4 = "braid.sext"(%bb1a8_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1a8_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb1ac] : () -> ()
    ^bb1ac:  // 0x10220
      %bb1ac_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb1ac_1 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1ac_2 = "braid.shl"(%bb1ac_0, %bb1ac_1) : (i64, i64) -> i64
      "braid.set"(%bb1ac_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb1b0] : () -> ()
    ^bb1b0:  // 0x10224
      %bb1b0_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb1b0_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb1b0_2 = "braid.or"(%bb1b0_0, %bb1b0_1) : (i64, i64) -> i64
      "braid.set"(%bb1b0_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb1b4] : () -> ()
    ^bb1b4:  // 0x10228
      %bb1b4_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb1b4_1 = "braid.zext"(%bb1b4_0) {bits = 32 : i64} : (i64) -> i64
      %bb1b4_2 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1b4_3 = "braid.lshr"(%bb1b4_1, %bb1b4_2) : (i64, i64) -> i64
      %bb1b4_4 = "braid.sext"(%bb1b4_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1b4_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb1b8] : () -> ()
    ^bb1b8:  // 0x1022c
      %bb1b8_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb1b8_1 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1b8_2 = "braid.shl"(%bb1b8_0, %bb1b8_1) : (i64, i64) -> i64
      "braid.set"(%bb1b8_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb1bc] : () -> ()
    ^bb1bc:  // 0x10230
      %bb1bc_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb1bc_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb1bc_2 = "braid.or"(%bb1bc_0, %bb1bc_1) : (i64, i64) -> i64
      "braid.set"(%bb1bc_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb1c0] : () -> ()
    ^bb1c0:  // 0x10234
      %bb1c0_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb1c0_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1c0_2 = "braid.add"(%bb1c0_0, %bb1c0_1) : (i64, i64) -> i64
      "braid.set"(%bb1c0_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1c4] : () -> ()
    ^bb1c4:  // 0x10238
      %bb1c4_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb1c4_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb1c4_2 = "braid.add"(%bb1c4_0, %bb1c4_1) : (i64, i64) -> i64
      "braid.set"(%bb1c4_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb1c8] : () -> ()
    ^bb1c8:  // 0x1023c
      %bb1c8_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb1c8_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb1c8_2 = "braid.add"(%bb1c8_0, %bb1c8_1) : (i64, i64) -> i64
      "braid.set"(%bb1c8_2) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb1cc] : () -> ()
    ^bb1cc:  // 0x10240
      %bb1cc_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1cc_1 = "braid.get"() {reg = "x31"} : () -> i64
      %bb1cc_2 = "braid.add"(%bb1cc_0, %bb1cc_1) : (i64, i64) -> i64
      "braid.set"(%bb1cc_2) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb1d0] : () -> ()
    ^bb1d0:  // 0x10244
      %bb1d0_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb1d0_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1d0_2 = "braid.xor"(%bb1d0_0, %bb1d0_1) : (i64, i64) -> i64
      "braid.set"(%bb1d0_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb1d4] : () -> ()
    ^bb1d4:  // 0x10248
      %bb1d4_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb1d4_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb1d4_2 = "braid.xor"(%bb1d4_0, %bb1d4_1) : (i64, i64) -> i64
      "braid.set"(%bb1d4_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb1d8] : () -> ()
    ^bb1d8:  // 0x1024c
      %bb1d8_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb1d8_1 = "braid.get"() {reg = "x29"} : () -> i64
      %bb1d8_2 = "braid.xor"(%bb1d8_0, %bb1d8_1) : (i64, i64) -> i64
      "braid.set"(%bb1d8_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb1dc] : () -> ()
    ^bb1dc:  // 0x10250
      %bb1dc_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb1dc_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb1dc_2 = "braid.xor"(%bb1dc_0, %bb1dc_1) : (i64, i64) -> i64
      "braid.set"(%bb1dc_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb1e0] : () -> ()
    ^bb1e0:  // 0x10254
      %bb1e0_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb1e0_1 = "braid.zext"(%bb1e0_0) {bits = 32 : i64} : (i64) -> i64
      %bb1e0_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1e0_3 = "braid.lshr"(%bb1e0_1, %bb1e0_2) : (i64, i64) -> i64
      %bb1e0_4 = "braid.sext"(%bb1e0_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1e0_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb1e4] : () -> ()
    ^bb1e4:  // 0x10258
      %bb1e4_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb1e4_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1e4_2 = "braid.shl"(%bb1e4_0, %bb1e4_1) : (i64, i64) -> i64
      "braid.set"(%bb1e4_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb1e8] : () -> ()
    ^bb1e8:  // 0x1025c
      %bb1e8_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb1e8_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb1e8_2 = "braid.or"(%bb1e8_0, %bb1e8_1) : (i64, i64) -> i64
      "braid.set"(%bb1e8_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb1ec] : () -> ()
    ^bb1ec:  // 0x10260
      %bb1ec_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb1ec_1 = "braid.zext"(%bb1ec_0) {bits = 32 : i64} : (i64) -> i64
      %bb1ec_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1ec_3 = "braid.lshr"(%bb1ec_1, %bb1ec_2) : (i64, i64) -> i64
      %bb1ec_4 = "braid.sext"(%bb1ec_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1ec_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb1f0] : () -> ()
    ^bb1f0:  // 0x10264
      %bb1f0_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb1f0_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1f0_2 = "braid.shl"(%bb1f0_0, %bb1f0_1) : (i64, i64) -> i64
      "braid.set"(%bb1f0_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb1f4] : () -> ()
    ^bb1f4:  // 0x10268
      %bb1f4_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb1f4_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb1f4_2 = "braid.or"(%bb1f4_0, %bb1f4_1) : (i64, i64) -> i64
      "braid.set"(%bb1f4_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb1f8] : () -> ()
    ^bb1f8:  // 0x1026c
      %bb1f8_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb1f8_1 = "braid.zext"(%bb1f8_0) {bits = 32 : i64} : (i64) -> i64
      %bb1f8_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1f8_3 = "braid.lshr"(%bb1f8_1, %bb1f8_2) : (i64, i64) -> i64
      %bb1f8_4 = "braid.sext"(%bb1f8_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1f8_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb1fc] : () -> ()
    ^bb1fc:  // 0x10270
      %bb1fc_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb1fc_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1fc_2 = "braid.shl"(%bb1fc_0, %bb1fc_1) : (i64, i64) -> i64
      "braid.set"(%bb1fc_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb200] : () -> ()
    ^bb200:  // 0x10274
      %bb200_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb200_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb200_2 = "braid.or"(%bb200_0, %bb200_1) : (i64, i64) -> i64
      "braid.set"(%bb200_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb204] : () -> ()
    ^bb204:  // 0x10278
      %bb204_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb204_1 = "braid.zext"(%bb204_0) {bits = 32 : i64} : (i64) -> i64
      %bb204_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb204_3 = "braid.lshr"(%bb204_1, %bb204_2) : (i64, i64) -> i64
      %bb204_4 = "braid.sext"(%bb204_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb204_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb208] : () -> ()
    ^bb208:  // 0x1027c
      %bb208_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb208_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb208_2 = "braid.shl"(%bb208_0, %bb208_1) : (i64, i64) -> i64
      "braid.set"(%bb208_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb20c] : () -> ()
    ^bb20c:  // 0x10280
      %bb20c_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb20c_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb20c_2 = "braid.or"(%bb20c_0, %bb20c_1) : (i64, i64) -> i64
      "braid.set"(%bb20c_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb210] : () -> ()
    ^bb210:  // 0x10284
      %bb210_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb210_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb210_2 = "braid.add"(%bb210_0, %bb210_1) : (i64, i64) -> i64
      "braid.set"(%bb210_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb214] : () -> ()
    ^bb214:  // 0x10288
      %bb214_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb214_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb214_2 = "braid.add"(%bb214_0, %bb214_1) : (i64, i64) -> i64
      "braid.set"(%bb214_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb218] : () -> ()
    ^bb218:  // 0x1028c
      %bb218_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb218_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb218_2 = "braid.add"(%bb218_0, %bb218_1) : (i64, i64) -> i64
      "braid.set"(%bb218_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb21c] : () -> ()
    ^bb21c:  // 0x10290
      %bb21c_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb21c_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb21c_2 = "braid.add"(%bb21c_0, %bb21c_1) : (i64, i64) -> i64
      "braid.set"(%bb21c_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb220] : () -> ()
    ^bb220:  // 0x10294
      %bb220_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb220_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb220_2 = "braid.xor"(%bb220_0, %bb220_1) : (i64, i64) -> i64
      "braid.set"(%bb220_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb224] : () -> ()
    ^bb224:  // 0x10298
      %bb224_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb224_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb224_2 = "braid.xor"(%bb224_0, %bb224_1) : (i64, i64) -> i64
      "braid.set"(%bb224_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb228] : () -> ()
    ^bb228:  // 0x1029c
      %bb228_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb228_1 = "braid.get"() {reg = "x28"} : () -> i64
      %bb228_2 = "braid.xor"(%bb228_0, %bb228_1) : (i64, i64) -> i64
      "braid.set"(%bb228_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb22c] : () -> ()
    ^bb22c:  // 0x102a0
      %bb22c_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb22c_1 = "braid.get"() {reg = "x31"} : () -> i64
      %bb22c_2 = "braid.xor"(%bb22c_0, %bb22c_1) : (i64, i64) -> i64
      "braid.set"(%bb22c_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb230] : () -> ()
    ^bb230:  // 0x102a4
      %bb230_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb230_1 = "braid.zext"(%bb230_0) {bits = 32 : i64} : (i64) -> i64
      %bb230_2 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb230_3 = "braid.lshr"(%bb230_1, %bb230_2) : (i64, i64) -> i64
      %bb230_4 = "braid.sext"(%bb230_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb230_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb234] : () -> ()
    ^bb234:  // 0x102a8
      %bb234_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb234_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb234_2 = "braid.shl"(%bb234_0, %bb234_1) : (i64, i64) -> i64
      "braid.set"(%bb234_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb238] : () -> ()
    ^bb238:  // 0x102ac
      %bb238_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb238_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb238_2 = "braid.or"(%bb238_0, %bb238_1) : (i64, i64) -> i64
      "braid.set"(%bb238_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb23c] : () -> ()
    ^bb23c:  // 0x102b0
      %bb23c_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb23c_1 = "braid.zext"(%bb23c_0) {bits = 32 : i64} : (i64) -> i64
      %bb23c_2 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb23c_3 = "braid.lshr"(%bb23c_1, %bb23c_2) : (i64, i64) -> i64
      %bb23c_4 = "braid.sext"(%bb23c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb23c_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb240] : () -> ()
    ^bb240:  // 0x102b4
      %bb240_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb240_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb240_2 = "braid.shl"(%bb240_0, %bb240_1) : (i64, i64) -> i64
      "braid.set"(%bb240_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb244] : () -> ()
    ^bb244:  // 0x102b8
      %bb244_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb244_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb244_2 = "braid.or"(%bb244_0, %bb244_1) : (i64, i64) -> i64
      "braid.set"(%bb244_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb248] : () -> ()
    ^bb248:  // 0x102bc
      %bb248_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb248_1 = "braid.zext"(%bb248_0) {bits = 32 : i64} : (i64) -> i64
      %bb248_2 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb248_3 = "braid.lshr"(%bb248_1, %bb248_2) : (i64, i64) -> i64
      %bb248_4 = "braid.sext"(%bb248_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb248_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb24c] : () -> ()
    ^bb24c:  // 0x102c0
      %bb24c_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb24c_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb24c_2 = "braid.shl"(%bb24c_0, %bb24c_1) : (i64, i64) -> i64
      "braid.set"(%bb24c_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb250] : () -> ()
    ^bb250:  // 0x102c4
      %bb250_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb250_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb250_2 = "braid.or"(%bb250_0, %bb250_1) : (i64, i64) -> i64
      "braid.set"(%bb250_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb254] : () -> ()
    ^bb254:  // 0x102c8
      %bb254_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb254_1 = "braid.zext"(%bb254_0) {bits = 32 : i64} : (i64) -> i64
      %bb254_2 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb254_3 = "braid.lshr"(%bb254_1, %bb254_2) : (i64, i64) -> i64
      %bb254_4 = "braid.sext"(%bb254_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb254_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb258] : () -> ()
    ^bb258:  // 0x102cc
      %bb258_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb258_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb258_2 = "braid.shl"(%bb258_0, %bb258_1) : (i64, i64) -> i64
      "braid.set"(%bb258_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb25c] : () -> ()
    ^bb25c:  // 0x102d0
      %bb25c_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb25c_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb25c_2 = "braid.or"(%bb25c_0, %bb25c_1) : (i64, i64) -> i64
      "braid.set"(%bb25c_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb260] : () -> ()
    ^bb260:  // 0x102d4
      %bb260_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb260_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb260_2 = "braid.add"(%bb260_0, %bb260_1) : (i64, i64) -> i64
      "braid.set"(%bb260_2) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb264] : () -> ()
    ^bb264:  // 0x102d8
      %bb264_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb264_1 = "braid.get"() {reg = "x18"} : () -> i64
      %bb264_2 = "braid.add"(%bb264_0, %bb264_1) : (i64, i64) -> i64
      "braid.set"(%bb264_2) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb268] : () -> ()
    ^bb268:  // 0x102dc
      %bb268_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb268_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb268_2 = "braid.add"(%bb268_0, %bb268_1) : (i64, i64) -> i64
      "braid.set"(%bb268_2) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb26c] : () -> ()
    ^bb26c:  // 0x102e0
      %bb26c_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb26c_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb26c_2 = "braid.add"(%bb26c_0, %bb26c_1) : (i64, i64) -> i64
      "braid.set"(%bb26c_2) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb270] : () -> ()
    ^bb270:  // 0x102e4
      %bb270_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb270_1 = "braid.get"() {reg = "x17"} : () -> i64
      %bb270_2 = "braid.xor"(%bb270_0, %bb270_1) : (i64, i64) -> i64
      "braid.set"(%bb270_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb274] : () -> ()
    ^bb274:  // 0x102e8
      %bb274_0 = "braid.get"() {reg = "x18"} : () -> i64
      %bb274_1 = "braid.get"() {reg = "x7"} : () -> i64
      %bb274_2 = "braid.xor"(%bb274_0, %bb274_1) : (i64, i64) -> i64
      "braid.set"(%bb274_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb278] : () -> ()
    ^bb278:  // 0x102ec
      %bb278_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb278_1 = "braid.get"() {reg = "x29"} : () -> i64
      %bb278_2 = "braid.xor"(%bb278_0, %bb278_1) : (i64, i64) -> i64
      "braid.set"(%bb278_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb27c] : () -> ()
    ^bb27c:  // 0x102f0
      %bb27c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb27c_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb27c_2 = "braid.xor"(%bb27c_0, %bb27c_1) : (i64, i64) -> i64
      "braid.set"(%bb27c_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb280] : () -> ()
    ^bb280:  // 0x102f4
      %bb280_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb280_1 = "braid.zext"(%bb280_0) {bits = 32 : i64} : (i64) -> i64
      %bb280_2 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb280_3 = "braid.lshr"(%bb280_1, %bb280_2) : (i64, i64) -> i64
      %bb280_4 = "braid.sext"(%bb280_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb280_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb284] : () -> ()
    ^bb284:  // 0x102f8
      %bb284_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb284_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb284_2 = "braid.shl"(%bb284_0, %bb284_1) : (i64, i64) -> i64
      "braid.set"(%bb284_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb288] : () -> ()
    ^bb288:  // 0x102fc
      %bb288_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb288_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb288_2 = "braid.or"(%bb288_0, %bb288_1) : (i64, i64) -> i64
      "braid.set"(%bb288_2) {reg = "x17"} : (i64) -> ()
      "braid_cf.br"()[^bb28c] : () -> ()
    ^bb28c:  // 0x10300
      %bb28c_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb28c_1 = "braid.zext"(%bb28c_0) {bits = 32 : i64} : (i64) -> i64
      %bb28c_2 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb28c_3 = "braid.lshr"(%bb28c_1, %bb28c_2) : (i64, i64) -> i64
      %bb28c_4 = "braid.sext"(%bb28c_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb28c_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb290] : () -> ()
    ^bb290:  // 0x10304
      %bb290_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb290_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb290_2 = "braid.shl"(%bb290_0, %bb290_1) : (i64, i64) -> i64
      "braid.set"(%bb290_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb294] : () -> ()
    ^bb294:  // 0x10308
      %bb294_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb294_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb294_2 = "braid.or"(%bb294_0, %bb294_1) : (i64, i64) -> i64
      "braid.set"(%bb294_2) {reg = "x7"} : (i64) -> ()
      "braid_cf.br"()[^bb298] : () -> ()
    ^bb298:  // 0x1030c
      %bb298_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb298_1 = "braid.zext"(%bb298_0) {bits = 32 : i64} : (i64) -> i64
      %bb298_2 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb298_3 = "braid.lshr"(%bb298_1, %bb298_2) : (i64, i64) -> i64
      %bb298_4 = "braid.sext"(%bb298_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb298_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb29c] : () -> ()
    ^bb29c:  // 0x10310
      %bb29c_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb29c_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb29c_2 = "braid.shl"(%bb29c_0, %bb29c_1) : (i64, i64) -> i64
      "braid.set"(%bb29c_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb2a0] : () -> ()
    ^bb2a0:  // 0x10314
      %bb2a0_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb2a0_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb2a0_2 = "braid.or"(%bb2a0_0, %bb2a0_1) : (i64, i64) -> i64
      "braid.set"(%bb2a0_2) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb2a4] : () -> ()
    ^bb2a4:  // 0x10318
      %bb2a4_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb2a4_1 = "braid.zext"(%bb2a4_0) {bits = 32 : i64} : (i64) -> i64
      %bb2a4_2 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb2a4_3 = "braid.lshr"(%bb2a4_1, %bb2a4_2) : (i64, i64) -> i64
      %bb2a4_4 = "braid.sext"(%bb2a4_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2a4_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb2a8] : () -> ()
    ^bb2a8:  // 0x1031c
      %bb2a8_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb2a8_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb2a8_2 = "braid.shl"(%bb2a8_0, %bb2a8_1) : (i64, i64) -> i64
      "braid.set"(%bb2a8_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb2ac] : () -> ()
    ^bb2ac:  // 0x10320
      %bb2ac_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb2ac_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb2ac_2 = "braid.or"(%bb2ac_0, %bb2ac_1) : (i64, i64) -> i64
      "braid.set"(%bb2ac_2) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb2b0] : () -> ()
    ^bb2b0:  // 0x10324
      %bb2b0_0 = "braid.get"() {reg = "x17"} : () -> i64
      %bb2b0_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb2b0_2 = "braid.add"(%bb2b0_0, %bb2b0_1) : (i64, i64) -> i64
      "braid.set"(%bb2b0_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb2b4] : () -> ()
    ^bb2b4:  // 0x10328
      %bb2b4_0 = "braid.get"() {reg = "x7"} : () -> i64
      %bb2b4_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb2b4_2 = "braid.add"(%bb2b4_0, %bb2b4_1) : (i64, i64) -> i64
      "braid.set"(%bb2b4_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb2b8] : () -> ()
    ^bb2b8:  // 0x1032c
      %bb2b8_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb2b8_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb2b8_2 = "braid.add"(%bb2b8_0, %bb2b8_1) : (i64, i64) -> i64
      "braid.set"(%bb2b8_2) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb2bc] : () -> ()
    ^bb2bc:  // 0x10330
      %bb2bc_0 = "braid.get"() {reg = "x30"} : () -> i64
      %bb2bc_1 = "braid.get"() {reg = "x16"} : () -> i64
      %bb2bc_2 = "braid.add"(%bb2bc_0, %bb2bc_1) : (i64, i64) -> i64
      "braid.set"(%bb2bc_2) {reg = "x16"} : (i64) -> ()
      "braid_cf.br"()[^bb2c0] : () -> ()
    ^bb2c0:  // 0x10334
      %bb2c0_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb2c0_1 = "braid.get"() {reg = "x5"} : () -> i64
      %bb2c0_2 = "braid.xor"(%bb2c0_0, %bb2c0_1) : (i64, i64) -> i64
      "braid.set"(%bb2c0_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb2c4] : () -> ()
    ^bb2c4:  // 0x10338
      %bb2c4_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb2c4_1 = "braid.get"() {reg = "x6"} : () -> i64
      %bb2c4_2 = "braid.xor"(%bb2c4_0, %bb2c4_1) : (i64, i64) -> i64
      "braid.set"(%bb2c4_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb2c8] : () -> ()
    ^bb2c8:  // 0x1033c
      %bb2c8_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb2c8_1 = "braid.get"() {reg = "x28"} : () -> i64
      %bb2c8_2 = "braid.xor"(%bb2c8_0, %bb2c8_1) : (i64, i64) -> i64
      "braid.set"(%bb2c8_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb2cc] : () -> ()
    ^bb2cc:  // 0x10340
      %bb2cc_0 = "braid.get"() {reg = "x16"} : () -> i64
      %bb2cc_1 = "braid.get"() {reg = "x31"} : () -> i64
      %bb2cc_2 = "braid.xor"(%bb2cc_0, %bb2cc_1) : (i64, i64) -> i64
      "braid.set"(%bb2cc_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb2d0] : () -> ()
    ^bb2d0:  // 0x10344
      %bb2d0_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb2d0_1 = "braid.zext"(%bb2d0_0) {bits = 32 : i64} : (i64) -> i64
      %bb2d0_2 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb2d0_3 = "braid.lshr"(%bb2d0_1, %bb2d0_2) : (i64, i64) -> i64
      %bb2d0_4 = "braid.sext"(%bb2d0_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2d0_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb2d4] : () -> ()
    ^bb2d4:  // 0x10348
      %bb2d4_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb2d4_1 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb2d4_2 = "braid.shl"(%bb2d4_0, %bb2d4_1) : (i64, i64) -> i64
      "braid.set"(%bb2d4_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb2d8] : () -> ()
    ^bb2d8:  // 0x1034c
      %bb2d8_0 = "braid.get"() {reg = "x5"} : () -> i64
      %bb2d8_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb2d8_2 = "braid.or"(%bb2d8_0, %bb2d8_1) : (i64, i64) -> i64
      "braid.set"(%bb2d8_2) {reg = "x5"} : (i64) -> ()
      "braid_cf.br"()[^bb2dc] : () -> ()
    ^bb2dc:  // 0x10350
      %bb2dc_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb2dc_1 = "braid.zext"(%bb2dc_0) {bits = 32 : i64} : (i64) -> i64
      %bb2dc_2 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb2dc_3 = "braid.lshr"(%bb2dc_1, %bb2dc_2) : (i64, i64) -> i64
      %bb2dc_4 = "braid.sext"(%bb2dc_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2dc_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb2e0] : () -> ()
    ^bb2e0:  // 0x10354
      %bb2e0_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb2e0_1 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb2e0_2 = "braid.shl"(%bb2e0_0, %bb2e0_1) : (i64, i64) -> i64
      "braid.set"(%bb2e0_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb2e4] : () -> ()
    ^bb2e4:  // 0x10358
      %bb2e4_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb2e4_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb2e4_2 = "braid.or"(%bb2e4_0, %bb2e4_1) : (i64, i64) -> i64
      "braid.set"(%bb2e4_2) {reg = "x6"} : (i64) -> ()
      "braid_cf.br"()[^bb2e8] : () -> ()
    ^bb2e8:  // 0x1035c
      %bb2e8_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb2e8_1 = "braid.zext"(%bb2e8_0) {bits = 32 : i64} : (i64) -> i64
      %bb2e8_2 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb2e8_3 = "braid.lshr"(%bb2e8_1, %bb2e8_2) : (i64, i64) -> i64
      %bb2e8_4 = "braid.sext"(%bb2e8_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2e8_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb2ec] : () -> ()
    ^bb2ec:  // 0x10360
      %bb2ec_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb2ec_1 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb2ec_2 = "braid.shl"(%bb2ec_0, %bb2ec_1) : (i64, i64) -> i64
      "braid.set"(%bb2ec_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb2f0] : () -> ()
    ^bb2f0:  // 0x10364
      %bb2f0_0 = "braid.get"() {reg = "x28"} : () -> i64
      %bb2f0_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb2f0_2 = "braid.or"(%bb2f0_0, %bb2f0_1) : (i64, i64) -> i64
      "braid.set"(%bb2f0_2) {reg = "x28"} : (i64) -> ()
      "braid_cf.br"()[^bb2f4] : () -> ()
    ^bb2f4:  // 0x10368
      %bb2f4_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb2f4_1 = "braid.zext"(%bb2f4_0) {bits = 32 : i64} : (i64) -> i64
      %bb2f4_2 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb2f4_3 = "braid.lshr"(%bb2f4_1, %bb2f4_2) : (i64, i64) -> i64
      %bb2f4_4 = "braid.sext"(%bb2f4_3) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2f4_4) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb2f8] : () -> ()
    ^bb2f8:  // 0x1036c
      %bb2f8_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb2f8_1 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb2f8_2 = "braid.shl"(%bb2f8_0, %bb2f8_1) : (i64, i64) -> i64
      "braid.set"(%bb2f8_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb2fc] : () -> ()
    ^bb2fc:  // 0x10370
      %bb2fc_0 = "braid.get"() {reg = "x31"} : () -> i64
      %bb2fc_1 = "braid.get"() {reg = "x20"} : () -> i64
      %bb2fc_2 = "braid.or"(%bb2fc_0, %bb2fc_1) : (i64, i64) -> i64
      "braid.set"(%bb2fc_2) {reg = "x31"} : (i64) -> ()
      "braid_cf.br"()[^bb300] : () -> ()
    ^bb300:  // 0x10374
      %bb300_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb300_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb300_2 = "braid.ne"(%bb300_0, %bb300_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb300_2)[^bb7c, ^bb304] : (i64) -> ()
    ^bb304:  // 0x10378
      %bb304_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb304_1 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb304_2 = "braid.add"(%bb304_0, %bb304_1) : (i64, i64) -> i64
      %bb304_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb304_4 = "braid.and"(%bb304_2, %bb304_3) : (i64, i64) -> i64
      %bb304_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb304_6 = "braid.eq"(%bb304_4, %bb304_5) : (i64, i64) -> i64
      "braid.guard"(%bb304_6) : (i64) -> ()
      %bb304_7 = "braid.get"() {reg = "x31"} : () -> i64
      "braid.store"(%bb304_2, %bb304_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb308] : () -> ()
    ^bb308:  // 0x1037c
      %bb308_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb308_1 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb308_2 = "braid.add"(%bb308_0, %bb308_1) : (i64, i64) -> i64
      %bb308_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb308_4 = "braid.and"(%bb308_2, %bb308_3) : (i64, i64) -> i64
      %bb308_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb308_6 = "braid.eq"(%bb308_4, %bb308_5) : (i64, i64) -> i64
      "braid.guard"(%bb308_6) : (i64) -> ()
      %bb308_7 = "braid.get"() {reg = "x5"} : () -> i64
      "braid.store"(%bb308_2, %bb308_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb30c] : () -> ()
    ^bb30c:  // 0x10380
      %bb30c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb30c_1 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb30c_2 = "braid.add"(%bb30c_0, %bb30c_1) : (i64, i64) -> i64
      %bb30c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb30c_4 = "braid.and"(%bb30c_2, %bb30c_3) : (i64, i64) -> i64
      %bb30c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb30c_6 = "braid.eq"(%bb30c_4, %bb30c_5) : (i64, i64) -> i64
      "braid.guard"(%bb30c_6) : (i64) -> ()
      %bb30c_7 = "braid.get"() {reg = "x6"} : () -> i64
      "braid.store"(%bb30c_2, %bb30c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb310] : () -> ()
    ^bb310:  // 0x10384
      %bb310_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb310_1 = "braid.const"() {value = 36 : i64} : () -> i64
      %bb310_2 = "braid.add"(%bb310_0, %bb310_1) : (i64, i64) -> i64
      %bb310_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb310_4 = "braid.and"(%bb310_2, %bb310_3) : (i64, i64) -> i64
      %bb310_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb310_6 = "braid.eq"(%bb310_4, %bb310_5) : (i64, i64) -> i64
      "braid.guard"(%bb310_6) : (i64) -> ()
      %bb310_7 = "braid.get"() {reg = "x28"} : () -> i64
      "braid.store"(%bb310_2, %bb310_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb314] : () -> ()
    ^bb314:  // 0x10388
      %bb314_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb314_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb314_2 = "braid.add"(%bb314_0, %bb314_1) : (i64, i64) -> i64
      %bb314_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb314_4 = "braid.and"(%bb314_2, %bb314_3) : (i64, i64) -> i64
      %bb314_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb314_6 = "braid.eq"(%bb314_4, %bb314_5) : (i64, i64) -> i64
      "braid.guard"(%bb314_6) : (i64) -> ()
      %bb314_7 = "braid.get"() {reg = "x8"} : () -> i64
      "braid.store"(%bb314_2, %bb314_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb318] : () -> ()
    ^bb318:  // 0x1038c
      %bb318_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb318_1 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb318_2 = "braid.add"(%bb318_0, %bb318_1) : (i64, i64) -> i64
      %bb318_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb318_4 = "braid.and"(%bb318_2, %bb318_3) : (i64, i64) -> i64
      %bb318_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb318_6 = "braid.eq"(%bb318_4, %bb318_5) : (i64, i64) -> i64
      "braid.guard"(%bb318_6) : (i64) -> ()
      %bb318_7 = "braid.get"() {reg = "x18"} : () -> i64
      "braid.store"(%bb318_2, %bb318_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb31c] : () -> ()
    ^bb31c:  // 0x10390
      %bb31c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb31c_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb31c_2 = "braid.add"(%bb31c_0, %bb31c_1) : (i64, i64) -> i64
      %bb31c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb31c_4 = "braid.and"(%bb31c_2, %bb31c_3) : (i64, i64) -> i64
      %bb31c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb31c_6 = "braid.eq"(%bb31c_4, %bb31c_5) : (i64, i64) -> i64
      "braid.guard"(%bb31c_6) : (i64) -> ()
      %bb31c_7 = "braid.get"() {reg = "x19"} : () -> i64
      "braid.store"(%bb31c_2, %bb31c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb320] : () -> ()
    ^bb320:  // 0x10394
      %bb320_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb320_1 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb320_2 = "braid.add"(%bb320_0, %bb320_1) : (i64, i64) -> i64
      %bb320_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb320_4 = "braid.and"(%bb320_2, %bb320_3) : (i64, i64) -> i64
      %bb320_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb320_6 = "braid.eq"(%bb320_4, %bb320_5) : (i64, i64) -> i64
      "braid.guard"(%bb320_6) : (i64) -> ()
      %bb320_7 = "braid.get"() {reg = "x9"} : () -> i64
      "braid.store"(%bb320_2, %bb320_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb324] : () -> ()
    ^bb324:  // 0x10398
      %bb324_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb324_1 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb324_2 = "braid.add"(%bb324_0, %bb324_1) : (i64, i64) -> i64
      %bb324_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb324_4 = "braid.and"(%bb324_2, %bb324_3) : (i64, i64) -> i64
      %bb324_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb324_6 = "braid.eq"(%bb324_4, %bb324_5) : (i64, i64) -> i64
      "braid.guard"(%bb324_6) : (i64) -> ()
      %bb324_7 = "braid.get"() {reg = "x7"} : () -> i64
      "braid.store"(%bb324_2, %bb324_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb328] : () -> ()
    ^bb328:  // 0x1039c
      %bb328_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb328_1 = "braid.const"() {value = 60 : i64} : () -> i64
      %bb328_2 = "braid.add"(%bb328_0, %bb328_1) : (i64, i64) -> i64
      %bb328_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb328_4 = "braid.and"(%bb328_2, %bb328_3) : (i64, i64) -> i64
      %bb328_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb328_6 = "braid.eq"(%bb328_4, %bb328_5) : (i64, i64) -> i64
      "braid.guard"(%bb328_6) : (i64) -> ()
      %bb328_7 = "braid.get"() {reg = "x29"} : () -> i64
      "braid.store"(%bb328_2, %bb328_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb32c] : () -> ()
    ^bb32c:  // 0x103a0
      %bb32c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb32c_1 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb32c_2 = "braid.add"(%bb32c_0, %bb32c_1) : (i64, i64) -> i64
      %bb32c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb32c_4 = "braid.and"(%bb32c_2, %bb32c_3) : (i64, i64) -> i64
      %bb32c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb32c_6 = "braid.eq"(%bb32c_4, %bb32c_5) : (i64, i64) -> i64
      "braid.guard"(%bb32c_6) : (i64) -> ()
      %bb32c_7 = "braid.get"() {reg = "x30"} : () -> i64
      "braid.store"(%bb32c_2, %bb32c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb330] : () -> ()
    ^bb330:  // 0x103a4
      %bb330_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb330_1 = "braid.const"() {value = 68 : i64} : () -> i64
      %bb330_2 = "braid.add"(%bb330_0, %bb330_1) : (i64, i64) -> i64
      %bb330_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb330_4 = "braid.and"(%bb330_2, %bb330_3) : (i64, i64) -> i64
      %bb330_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb330_6 = "braid.eq"(%bb330_4, %bb330_5) : (i64, i64) -> i64
      "braid.guard"(%bb330_6) : (i64) -> ()
      %bb330_7 = "braid.get"() {reg = "x17"} : () -> i64
      "braid.store"(%bb330_2, %bb330_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb334] : () -> ()
    ^bb334:  // 0x103a8
      %bb334_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb334_1 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb334_2 = "braid.add"(%bb334_0, %bb334_1) : (i64, i64) -> i64
      %bb334_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb334_4 = "braid.and"(%bb334_2, %bb334_3) : (i64, i64) -> i64
      %bb334_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb334_6 = "braid.eq"(%bb334_4, %bb334_5) : (i64, i64) -> i64
      "braid.guard"(%bb334_6) : (i64) -> ()
      %bb334_7 = "braid.get"() {reg = "x15"} : () -> i64
      "braid.store"(%bb334_2, %bb334_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb338] : () -> ()
    ^bb338:  // 0x103ac
      %bb338_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb338_1 = "braid.const"() {value = 44 : i64} : () -> i64
      %bb338_2 = "braid.add"(%bb338_0, %bb338_1) : (i64, i64) -> i64
      %bb338_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb338_4 = "braid.and"(%bb338_2, %bb338_3) : (i64, i64) -> i64
      %bb338_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb338_6 = "braid.eq"(%bb338_4, %bb338_5) : (i64, i64) -> i64
      "braid.guard"(%bb338_6) : (i64) -> ()
      %bb338_7 = "braid.get"() {reg = "x16"} : () -> i64
      "braid.store"(%bb338_2, %bb338_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb33c] : () -> ()
    ^bb33c:  // 0x103b0
      %bb33c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb33c_1 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb33c_2 = "braid.add"(%bb33c_0, %bb33c_1) : (i64, i64) -> i64
      %bb33c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb33c_4 = "braid.and"(%bb33c_2, %bb33c_3) : (i64, i64) -> i64
      %bb33c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb33c_6 = "braid.eq"(%bb33c_4, %bb33c_5) : (i64, i64) -> i64
      "braid.guard"(%bb33c_6) : (i64) -> ()
      %bb33c_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bb33c_2, %bb33c_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb340] : () -> ()
    ^bb340:  // 0x103b4
      %bb340_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb340_1 = "braid.const"() {value = 52 : i64} : () -> i64
      %bb340_2 = "braid.add"(%bb340_0, %bb340_1) : (i64, i64) -> i64
      %bb340_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb340_4 = "braid.and"(%bb340_2, %bb340_3) : (i64, i64) -> i64
      %bb340_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb340_6 = "braid.eq"(%bb340_4, %bb340_5) : (i64, i64) -> i64
      "braid.guard"(%bb340_6) : (i64) -> ()
      %bb340_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bb340_2, %bb340_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb344] : () -> ()
    ^bb344:  // 0x103b8
      %bb344_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb344_1 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb344_2 = "braid.add"(%bb344_0, %bb344_1) : (i64, i64) -> i64
      "braid.set"(%bb344_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb348] : () -> ()
    ^bb348:  // 0x103bc
      %bb348_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb348_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb348_2 = "braid.add"(%bb348_0, %bb348_1) : (i64, i64) -> i64
      "braid.set"(%bb348_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb34c] : () -> ()
    ^bb34c:  // 0x103c0
      %bb34c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb34c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb34c_2 = "braid.add"(%bb34c_0, %bb34c_1) : (i64, i64) -> i64
      %bb34c_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb34c_4 = "braid.and"(%bb34c_2, %bb34c_3) : (i64, i64) -> i64
      %bb34c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb34c_6 = "braid.eq"(%bb34c_4, %bb34c_5) : (i64, i64) -> i64
      "braid.guard"(%bb34c_6) : (i64) -> ()
      %bb34c_7 = "braid.load"(%bb34c_2) {bytes = 4 : i64} : (i64) -> i64
      %bb34c_8 = "braid.sext"(%bb34c_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb34c_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb350] : () -> ()
    ^bb350:  // 0x103c4
      %bb350_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb350_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb350_2 = "braid.add"(%bb350_0, %bb350_1) : (i64, i64) -> i64
      %bb350_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb350_4 = "braid.and"(%bb350_2, %bb350_3) : (i64, i64) -> i64
      %bb350_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb350_6 = "braid.eq"(%bb350_4, %bb350_5) : (i64, i64) -> i64
      "braid.guard"(%bb350_6) : (i64) -> ()
      %bb350_7 = "braid.load"(%bb350_2) {bytes = 4 : i64} : (i64) -> i64
      %bb350_8 = "braid.sext"(%bb350_7) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb350_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb354] : () -> ()
    ^bb354:  // 0x103c8
      %bb354_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb354_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb354_2 = "braid.add"(%bb354_0, %bb354_1) : (i64, i64) -> i64
      "braid.set"(%bb354_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb358] : () -> ()
    ^bb358:  // 0x103cc
      %bb358_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb358_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb358_2 = "braid.add"(%bb358_0, %bb358_1) : (i64, i64) -> i64
      %bb358_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb358_4 = "braid.and"(%bb358_2, %bb358_3) : (i64, i64) -> i64
      %bb358_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb358_6 = "braid.eq"(%bb358_4, %bb358_5) : (i64, i64) -> i64
      "braid.guard"(%bb358_6) : (i64) -> ()
      %bb358_7 = "braid.get"() {reg = "x14"} : () -> i64
      "braid.store"(%bb358_2, %bb358_7) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb35c] : () -> ()
    ^bb35c:  // 0x103d0
      %bb35c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb35c_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb35c_2 = "braid.add"(%bb35c_0, %bb35c_1) : (i64, i64) -> i64
      "braid.set"(%bb35c_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb360] : () -> ()
    ^bb360:  // 0x103d4
      %bb360_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb360_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb360_2 = "braid.add"(%bb360_0, %bb360_1) : (i64, i64) -> i64
      "braid.set"(%bb360_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb364] : () -> ()
    ^bb364:  // 0x103d8
      %bb364_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb364_1 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb364_2 = "braid.add"(%bb364_0, %bb364_1) : (i64, i64) -> i64
      "braid.set"(%bb364_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb368] : () -> ()
    ^bb368:  // 0x103dc
      %bb368_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb368_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb368_2 = "braid.ne"(%bb368_0, %bb368_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb368_2)[^bb34c, ^bb36c] : (i64) -> ()
    ^bb36c:  // 0x103e0
      %bb36c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb36c_1 = "braid.const"() {value = 104 : i64} : () -> i64
      %bb36c_2 = "braid.add"(%bb36c_0, %bb36c_1) : (i64, i64) -> i64
      %bb36c_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb36c_4 = "braid.and"(%bb36c_2, %bb36c_3) : (i64, i64) -> i64
      %bb36c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb36c_6 = "braid.eq"(%bb36c_4, %bb36c_5) : (i64, i64) -> i64
      "braid.guard"(%bb36c_6) : (i64) -> ()
      %bb36c_7 = "braid.load"(%bb36c_2) {bytes = 8 : i64} : (i64) -> i64
      %bb36c_8 = "braid.zext"(%bb36c_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb36c_8) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb370] : () -> ()
    ^bb370:  // 0x103e4
      %bb370_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb370_1 = "braid.const"() {value = 96 : i64} : () -> i64
      %bb370_2 = "braid.add"(%bb370_0, %bb370_1) : (i64, i64) -> i64
      %bb370_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb370_4 = "braid.and"(%bb370_2, %bb370_3) : (i64, i64) -> i64
      %bb370_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb370_6 = "braid.eq"(%bb370_4, %bb370_5) : (i64, i64) -> i64
      "braid.guard"(%bb370_6) : (i64) -> ()
      %bb370_7 = "braid.load"(%bb370_2) {bytes = 8 : i64} : (i64) -> i64
      %bb370_8 = "braid.zext"(%bb370_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb370_8) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb374] : () -> ()
    ^bb374:  // 0x103e8
      %bb374_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb374_1 = "braid.const"() {value = 88 : i64} : () -> i64
      %bb374_2 = "braid.add"(%bb374_0, %bb374_1) : (i64, i64) -> i64
      %bb374_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb374_4 = "braid.and"(%bb374_2, %bb374_3) : (i64, i64) -> i64
      %bb374_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb374_6 = "braid.eq"(%bb374_4, %bb374_5) : (i64, i64) -> i64
      "braid.guard"(%bb374_6) : (i64) -> ()
      %bb374_7 = "braid.load"(%bb374_2) {bytes = 8 : i64} : (i64) -> i64
      %bb374_8 = "braid.zext"(%bb374_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb374_8) {reg = "x18"} : (i64) -> ()
      "braid_cf.br"()[^bb378] : () -> ()
    ^bb378:  // 0x103ec
      %bb378_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb378_1 = "braid.const"() {value = 80 : i64} : () -> i64
      %bb378_2 = "braid.add"(%bb378_0, %bb378_1) : (i64, i64) -> i64
      %bb378_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb378_4 = "braid.and"(%bb378_2, %bb378_3) : (i64, i64) -> i64
      %bb378_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb378_6 = "braid.eq"(%bb378_4, %bb378_5) : (i64, i64) -> i64
      "braid.guard"(%bb378_6) : (i64) -> ()
      %bb378_7 = "braid.load"(%bb378_2) {bytes = 8 : i64} : (i64) -> i64
      %bb378_8 = "braid.zext"(%bb378_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb378_8) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb37c] : () -> ()
    ^bb37c:  // 0x103f0
      %bb37c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb37c_1 = "braid.const"() {value = 72 : i64} : () -> i64
      %bb37c_2 = "braid.add"(%bb37c_0, %bb37c_1) : (i64, i64) -> i64
      %bb37c_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb37c_4 = "braid.and"(%bb37c_2, %bb37c_3) : (i64, i64) -> i64
      %bb37c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb37c_6 = "braid.eq"(%bb37c_4, %bb37c_5) : (i64, i64) -> i64
      "braid.guard"(%bb37c_6) : (i64) -> ()
      %bb37c_7 = "braid.load"(%bb37c_2) {bytes = 8 : i64} : (i64) -> i64
      %bb37c_8 = "braid.zext"(%bb37c_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb37c_8) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb380] : () -> ()
    ^bb380:  // 0x103f4
      %bb380_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb380_1 = "braid.const"() {value = 112 : i64} : () -> i64
      %bb380_2 = "braid.add"(%bb380_0, %bb380_1) : (i64, i64) -> i64
      "braid.set"(%bb380_2) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb384] : () -> ()
    ^bb384:  // 0x103f8
      %bb384_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb384_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb384_2 = "braid.add"(%bb384_0, %bb384_1) : (i64, i64) -> i64
      %bb384_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb384_4 = "braid.and"(%bb384_2, %bb384_3) : (i64, i64) -> i64
      %bb384_5 = "braid.const"() {value = 66556 : i64} : () -> i64
      "braid_cf.br_ind"(%bb384_4) : (i64) -> ()
  }) {sym_name = "chacha20_block", entry = 65652 : i64} : () -> ()
}) {arch = "riscv64"} : () -> ()
