"braid.module"() ({
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      %bb0_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb0_4 = "braid.and"(%bb0_2, %bb0_3) : (i64, i64) -> i64
      %bb0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_6 = "braid.eq"(%bb0_4, %bb0_5) : (i64, i64) -> i64
      "braid.guard"(%bb0_6) : (i64) -> ()
      %bb0_7 = "braid.load"(%bb0_2) {bytes = 8 : i64} : (i64) -> i64
      %bb0_8 = "braid.zext"(%bb0_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb0_8) {reg = "x12"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      %bb4_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb4_4 = "braid.and"(%bb4_2, %bb4_3) : (i64, i64) -> i64
      %bb4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_6 = "braid.eq"(%bb4_4, %bb4_5) : (i64, i64) -> i64
      "braid.guard"(%bb4_6) : (i64) -> ()
      %bb4_7 = "braid.load"(%bb4_2) {bytes = 8 : i64} : (i64) -> i64
      %bb4_8 = "braid.zext"(%bb4_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb4_8) {reg = "x13"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb8_4 = "braid.and"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      %bb8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_6 = "braid.eq"(%bb8_4, %bb8_5) : (i64, i64) -> i64
      "braid.guard"(%bb8_6) : (i64) -> ()
      %bb8_7 = "braid.get"() {reg = "x12"} : () -> i64
      "braid.store"(%bb8_2, %bb8_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      %bbc_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbc_4 = "braid.and"(%bbc_2, %bbc_3) : (i64, i64) -> i64
      %bbc_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_6 = "braid.eq"(%bbc_4, %bbc_5) : (i64, i64) -> i64
      "braid.guard"(%bbc_6) : (i64) -> ()
      %bbc_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bbc_2, %bbc_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb10_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb10_4 = "braid.and"(%bb10_2, %bb10_3) : (i64, i64) -> i64
      %bb10_5 = "braid.const"() {value = 65556 : i64} : () -> i64
      "braid.br_ind"(%bb10_4) : (i64) -> ()
  }) {sym_name = "swap", entry = 65536 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10014
      %bb0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.eq"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb0_2)[^bb28, ^bb4] : (i64) -> ()
    ^bb4:  // 0x10018
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x12"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1001c
      %bb8_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      "braid.set"(%bb8_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10020
      %bbc_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbc_1 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbc_2 = "braid.shl"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      "braid.set"(%bbc_2) {reg = "x11"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10024
      %bb10_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      "braid.set"(%bb10_2) {reg = "x11"} : (i64) -> ()
      "braid.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10028
      %bb14_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb14_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      %bb14_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb14_4 = "braid.and"(%bb14_2, %bb14_3) : (i64, i64) -> i64
      %bb14_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_6 = "braid.eq"(%bb14_4, %bb14_5) : (i64, i64) -> i64
      "braid.guard"(%bb14_6) : (i64) -> ()
      %bb14_7 = "braid.load"(%bb14_2) {bytes = 8 : i64} : (i64) -> i64
      %bb14_8 = "braid.zext"(%bb14_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb14_8) {reg = "x13"} : (i64) -> ()
      "braid.br"()[^bb18] : () -> ()
    ^bb18:  // 0x1002c
      %bb18_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb18_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      "braid.set"(%bb18_2) {reg = "x12"} : (i64) -> ()
      "braid.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10030
      %bb1c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      "braid.set"(%bb1c_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10034
      %bb20_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb20_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb20_2 = "braid.ne"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb20_2)[^bb14, ^bb24] : (i64) -> ()
    ^bb24:  // 0x10038
      %bb24_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb24_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_2 = "braid.add"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      %bb24_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb24_4 = "braid.and"(%bb24_2, %bb24_3) : (i64, i64) -> i64
      %bb24_5 = "braid.const"() {value = 65596 : i64} : () -> i64
      "braid.br_ind"(%bb24_4) : (i64) -> ()
    ^bb28:  // 0x1003c
      %bb28_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_2 = "braid.add"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      "braid.set"(%bb28_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x10040
      %bb2c_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb2c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_2 = "braid.add"(%bb2c_0, %bb2c_1) : (i64, i64) -> i64
      %bb2c_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb2c_4 = "braid.and"(%bb2c_2, %bb2c_3) : (i64, i64) -> i64
      %bb2c_5 = "braid.const"() {value = 65604 : i64} : () -> i64
      "braid.br_ind"(%bb2c_4) : (i64) -> ()
  }) {sym_name = "sum_array", entry = 65556 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10044
      %bb0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb0_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb0_2 = "braid.ult"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb0_2)[^bb8, ^bb4] : (i64) -> ()
    ^bb4:  // 0x10048
      %bb4_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1004c
      %bb8_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb8_4 = "braid.and"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      %bb8_5 = "braid.const"() {value = 65616 : i64} : () -> i64
      "braid.br_ind"(%bb8_4) : (i64) -> ()
  }) {sym_name = "max2", entry = 65604 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10050
      %bb0_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb0_1 = "braid.const"() {value = -16 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x2"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10054
      %bb4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      %bb4_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb4_4 = "braid.and"(%bb4_2, %bb4_3) : (i64, i64) -> i64
      %bb4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_6 = "braid.eq"(%bb4_4, %bb4_5) : (i64, i64) -> i64
      "braid.guard"(%bb4_6) : (i64) -> ()
      %bb4_7 = "braid.get"() {reg = "x1"} : () -> i64
      "braid.store"(%bb4_2, %bb4_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10058
      %bb8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb8_4 = "braid.and"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      %bb8_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_6 = "braid.eq"(%bb8_4, %bb8_5) : (i64, i64) -> i64
      "braid.guard"(%bb8_6) : (i64) -> ()
      %bb8_7 = "braid.get"() {reg = "x8"} : () -> i64
      "braid.store"(%bb8_2, %bb8_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1005c
      %bbc_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bbc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      "braid.set"(%bbc_2) {reg = "x8"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10060
      %bb10_0 = "braid.const"() {value = 65632 : i64} : () -> i64
      "braid.set"(%bb10_0) {reg = "x1"} : (i64) -> ()
      "braid.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10064
      %bb14_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb14_1 = "braid.const"() {value = -28 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      %bb14_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb14_4 = "braid.and"(%bb14_2, %bb14_3) : (i64, i64) -> i64
      %bb14_5 = "braid.const"() {value = 65640 : i64} : () -> i64
      "braid.set"(%bb14_5) {reg = "x1"} : (i64) -> ()
      "braid.br_ind"(%bb14_4) : (i64) -> ()
    ^bb18:  // 0x10068
      %bb18_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb18_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      "braid.set"(%bb18_2) {reg = "x11"} : (i64) -> ()
      "braid.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1006c
      %bb1c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      %bb1c_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1c_4 = "braid.and"(%bb1c_2, %bb1c_3) : (i64, i64) -> i64
      %bb1c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_6 = "braid.eq"(%bb1c_4, %bb1c_5) : (i64, i64) -> i64
      "braid.guard"(%bb1c_6) : (i64) -> ()
      %bb1c_7 = "braid.load"(%bb1c_2) {bytes = 8 : i64} : (i64) -> i64
      %bb1c_8 = "braid.zext"(%bb1c_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb1c_8) {reg = "x1"} : (i64) -> ()
      "braid.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10070
      %bb20_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb20_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_2 = "braid.add"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      %bb20_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb20_4 = "braid.and"(%bb20_2, %bb20_3) : (i64, i64) -> i64
      %bb20_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_6 = "braid.eq"(%bb20_4, %bb20_5) : (i64, i64) -> i64
      "braid.guard"(%bb20_6) : (i64) -> ()
      %bb20_7 = "braid.load"(%bb20_2) {bytes = 8 : i64} : (i64) -> i64
      %bb20_8 = "braid.zext"(%bb20_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb20_8) {reg = "x8"} : (i64) -> ()
      "braid.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10074
      %bb24_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb24_1 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb24_2 = "braid.add"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      "braid.set"(%bb24_2) {reg = "x2"} : (i64) -> ()
      "braid.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10078
      %bb28_0 = "braid.const"() {value = 65656 : i64} : () -> i64
      "braid.set"(%bb28_0) {reg = "x6"} : (i64) -> ()
      "braid.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x1007c
      %bb2c_0 = "braid.get"() {reg = "x6"} : () -> i64
      %bb2c_1 = "braid.const"() {value = -52 : i64} : () -> i64
      %bb2c_2 = "braid.add"(%bb2c_0, %bb2c_1) : (i64, i64) -> i64
      %bb2c_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb2c_4 = "braid.and"(%bb2c_2, %bb2c_3) : (i64, i64) -> i64
      %bb2c_5 = "braid.const"() {value = 65664 : i64} : () -> i64
      "braid.br_ind"(%bb2c_4) : (i64) -> ()
  }) {sym_name = "max3", entry = 65616 : i64} : () -> ()
}) {arch = "riscv64"} : () -> ()
