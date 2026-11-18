"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb0_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb8_4 = "braid.and"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      %bb8_5 = "braid.const"() {value = 65548 : i64} : () -> i64
      "braid_cf.br_ind"(%bb8_4) : (i64) -> ()
  }) {sym_name = "swift_add3", entry = 65536 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10018
      %bb0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.eq"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb0_2)[^bb18, ^bb4] : (i64) -> ()
    ^bb4:  // 0x1001c
      %bb4_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10020
      %bb8_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb8_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb8_2 = "braid.urem"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_4 = "braid.eq"(%bb8_1, %bb8_3) : (i64, i64) -> i64
      %bb8_6 = "braid.select"(%bb8_4, %bb8_0, %bb8_2) : (i64, i64, i64) -> i64
      "braid.set"(%bb8_6) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10024
      %bbc_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bbc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      "braid.set"(%bbc_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10028
      %bb10_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb10_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_2 = "braid.ne"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb10_2)[^bb4, ^bb14] : (i64) -> ()
    ^bb14:  // 0x1002c
      %bb14_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb14_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      "braid.set"(%bb14_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10030
      %bb18_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb18_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      %bb18_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb18_4 = "braid.and"(%bb18_2, %bb18_3) : (i64, i64) -> i64
      %bb18_5 = "braid.const"() {value = 65588 : i64} : () -> i64
      "braid_cf.br_ind"(%bb18_4) : (i64) -> ()
  }) {sym_name = "swift_gcd", entry = 65560 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10050
      %bb0_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb0_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb0_2 = "braid.ult"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb0_2)[^bb8, ^bb4] : (i64) -> ()
    ^bb4:  // 0x10054
      %bb4_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10058
      %bb8_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb8_4 = "braid.and"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      %bb8_5 = "braid.const"() {value = 65628 : i64} : () -> i64
      "braid_cf.br_ind"(%bb8_4) : (i64) -> ()
  }) {sym_name = "swift_min", entry = 65616 : i64} : () -> ()
}) {arch = "riscv64"} : () -> ()
