"braid.module"() ({
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x11"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x12"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_7 = "braid.load"(%bb8_2) {bytes = 1 : i64} : (i64) -> i64
      %bb8_8 = "braid.zext"(%bb8_7) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bb8_8) {reg = "x12"} : (i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbc_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      "braid.set"(%bbc_2) {reg = "x11"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb10_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_2 = "braid.ne"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb10_2)[^bb4, ^bb14] : (i64) -> ()
    ^bb14:  // 0x10014
      %bb14_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb14_1 = "braid.const"() {value = -1 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      "braid.set"(%bb14_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10018
      %bb18_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb18_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      %bb18_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb18_4 = "braid.and"(%bb18_2, %bb18_3) : (i64, i64) -> i64
      %bb18_5 = "braid.const"() {value = 65564 : i64} : () -> i64
      "braid.br_ind"(%bb18_4) : (i64) -> ()
  }) {sym_name = "str_len", entry = 65536 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x1001c
      %bb0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.eq"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb0_2)[^bb14, ^bb4] : (i64) -> ()
    ^bb4:  // 0x10020
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x11"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10024
      %bb8_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_7 = "braid.get"() {reg = "x12"} : () -> i64
      "braid.store"(%bb8_2, %bb8_7) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10028
      %bbc_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbc_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      "braid.set"(%bbc_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x1002c
      %bb10_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb10_2 = "braid.ne"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb10_2)[^bb8, ^bb14] : (i64) -> ()
    ^bb14:  // 0x10030
      %bb14_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb14_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      %bb14_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb14_4 = "braid.and"(%bb14_2, %bb14_3) : (i64, i64) -> i64
      %bb14_5 = "braid.const"() {value = 65588 : i64} : () -> i64
      "braid.br_ind"(%bb14_4) : (i64) -> ()
  }) {sym_name = "fill", entry = 65564 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10034
      %bb0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x11"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10038
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.eq"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb4_2)[^bb18, ^bb8] : (i64) -> ()
    ^bb8:  // 0x1003c
      %bb8_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb8_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8_2 = "braid.and"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      "braid.set"(%bb8_2) {reg = "x12"} : (i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10040
      %bbc_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbc_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc_2 = "braid.lshr"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      "braid.set"(%bbc_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10044
      %bb10_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      "braid.set"(%bb10_2) {reg = "x11"} : (i64) -> ()
      "braid.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10048
      %bb14_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb14_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_2 = "braid.ne"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      "braid.cond_br"(%bb14_2)[^bb8, ^bb18] : (i64) -> ()
    ^bb18:  // 0x1004c
      %bb18_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb18_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      "braid.set"(%bb18_2) {reg = "x10"} : (i64) -> ()
      "braid.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10050
      %bb1c_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      %bb1c_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb1c_4 = "braid.and"(%bb1c_2, %bb1c_3) : (i64, i64) -> i64
      %bb1c_5 = "braid.const"() {value = 65620 : i64} : () -> i64
      "braid.br_ind"(%bb1c_4) : (i64) -> ()
  }) {sym_name = "count_ones", entry = 65588 : i64} : () -> ()
}) {arch = "riscv64"} : () -> ()
