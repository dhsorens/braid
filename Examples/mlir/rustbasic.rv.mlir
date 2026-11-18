"braid.module"() ({
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10004
      %bb0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb0_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10008
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1000c
      %bb8_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb8_4 = "braid.and"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      %bb8_5 = "braid.const"() {value = 65552 : i64} : () -> i64
      "braid.br_ind"(%bb8_4) : (i64) -> ()
  }) {sym_name = "add3", entry = 65540 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10028
      %bb0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb0_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb0_2 = "braid.ult"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb0_2)[^bb8, ^bb4] : (i64) -> ()
    ^bb4:  // 0x1002c
      %bb4_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10030
      %bb8_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb8_4 = "braid.and"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      %bb8_5 = "braid.const"() {value = 65588 : i64} : () -> i64
      "braid.br_ind"(%bb8_4) : (i64) -> ()
  }) {sym_name = "max_u64", entry = 65576 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10010
      %bb0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.eq"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb0_2)[^bb14, ^bb4] : (i64) -> ()
    ^bb4:  // 0x10014
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb4_2 = "braid.urem"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      %bb4_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_4 = "braid.eq"(%bb4_1, %bb4_3) : (i64, i64) -> i64
      %bb4_6 = "braid.select"(%bb4_4, %bb4_0, %bb4_2) : (i64, i64, i64) -> i64
      "braid.set"(%bb4_6) {reg = "x12"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10018
      %bb8_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      "braid.set"(%bb8_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1001c
      %bbc_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bbc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      "braid.set"(%bbc_2) {reg = "x11"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10020
      %bb10_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb10_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_2 = "braid.ne"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb10_2)[^bb4, ^bb14] : (i64) -> ()
    ^bb14:  // 0x10024
      %bb14_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb14_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      %bb14_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb14_4 = "braid.and"(%bb14_2, %bb14_3) : (i64, i64) -> i64
      %bb14_5 = "braid.const"() {value = 65576 : i64} : () -> i64
      "braid.br_ind"(%bb14_4) : (i64) -> ()
  }) {sym_name = "gcd", entry = 65552 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10034
      %bb0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.eq"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb0_2)[^bb28, ^bb4] : (i64) -> ()
    ^bb4:  // 0x10038
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x12"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1003c
      %bb8_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      "braid.set"(%bb8_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10040
      %bbc_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbc_1 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbc_2 = "braid.shl"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      "braid.set"(%bbc_2) {reg = "x11"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10044
      %bb10_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb10_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb10_4 = "braid.and"(%bb10_2, %bb10_3) : (i64, i64) -> i64
      %bb10_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_6 = "braid.eq"(%bb10_4, %bb10_5) : (i64, i64) -> i64
      "braid.guard"(%bb10_6) : (i64) -> ()
      %bb10_7 = "braid.load"(%bb10_2) {bytes = 8 : i64} : (i64) -> i64
      %bb10_8 = "braid.zext"(%bb10_7) {bits = 64 : i64} : (i64) -> i64
      "braid.set"(%bb10_8) {reg = "x13"} : (i64) -> ()
      "braid.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10048
      %bb14_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb14_1 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      "braid.set"(%bb14_2) {reg = "x12"} : (i64) -> ()
      "braid.br"()[^bb18] : () -> ()
    ^bb18:  // 0x1004c
      %bb18_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb18_1 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      "braid.set"(%bb18_2) {reg = "x11"} : (i64) -> ()
      "braid.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10050
      %bb1c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      "braid.set"(%bb1c_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10054
      %bb20_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb20_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_2 = "braid.ne"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb20_2)[^bb10, ^bb24] : (i64) -> ()
    ^bb24:  // 0x10058
      %bb24_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb24_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_2 = "braid.add"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      %bb24_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb24_4 = "braid.and"(%bb24_2, %bb24_3) : (i64, i64) -> i64
      %bb24_5 = "braid.const"() {value = 65628 : i64} : () -> i64
      "braid.br_ind"(%bb24_4) : (i64) -> ()
    ^bb28:  // 0x1005c
      %bb28_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_2 = "braid.add"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      "braid.set"(%bb28_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x10060
      %bb2c_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb2c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_2 = "braid.add"(%bb2c_0, %bb2c_1) : (i64, i64) -> i64
      %bb2c_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb2c_4 = "braid.and"(%bb2c_2, %bb2c_3) : (i64, i64) -> i64
      %bb2c_5 = "braid.const"() {value = 65636 : i64} : () -> i64
      "braid.br_ind"(%bb2c_4) : (i64) -> ()
  }) {sym_name = "sum_slice", entry = 65588 : i64} : () -> ()
}) {arch = "riscv64"} : () -> ()
