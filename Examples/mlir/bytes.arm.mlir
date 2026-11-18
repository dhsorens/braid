"braid.module"() ({
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_12 = "braid.or"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_12) {reg = "x8"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_6 = "braid.get"() {reg = "x8"} : () -> i64
      %bb4_0 = "braid.add"(%bb4_1, %bb4_6) : (i64, i64) -> i64
      %bb4_30 = "braid.load"(%bb4_0) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb4_30) {reg = "x9"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb8_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8_3 = "braid.add"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_3) {reg = "x8"} : (i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bbc_0 = "braid.zext"(%bbc_1) {bits = 32 : i64} : (i64) -> i64
      "braid.cond_br"(%bbc_0)[^bb4, ^bb10] : (i64) -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb10_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_3 = "braid.sub"(%bb10_0, %bb10_2) : (i64, i64) -> i64
      "braid.set"(%bb10_3) {reg = "x0"} : (i64) -> ()
      "braid.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10014
      %bb14_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid.br_ind"(%bb14_0) : (i64) -> ()
  }) {sym_name = "str_len", entry = 65536 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10018
      %bb0_0 = "braid.get"() {reg = "x1"} : () -> i64
      "braid.cond_br"(%bb0_0)[^bb4, ^bb10] : (i64) -> ()
    ^bb4:  // 0x1001c
      %bb4_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb4_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4_3 = "braid.sub"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      %bb4_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_4 = "braid.slt"(%bb4_3, %bb4_8) : (i64, i64) -> i64
      %bb4_5 = "braid.eq"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      %bb4_6 = "braid.ule"(%bb4_2, %bb4_0) : (i64, i64) -> i64
      %bb4_9 = "braid.xor"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      %bb4_10 = "braid.xor"(%bb4_0, %bb4_3) : (i64, i64) -> i64
      %bb4_11 = "braid.and"(%bb4_9, %bb4_10) : (i64, i64) -> i64
      %bb4_7 = "braid.slt"(%bb4_11, %bb4_8) : (i64, i64) -> i64
      "braid.setf"(%bb4_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb4_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb4_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb4_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb4_3) {reg = "x1"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10020
      %bb8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb8_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb8_6 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8_7 = "braid.add"(%bb8_1, %bb8_6) : (i64, i64) -> i64
      "braid.set"(%bb8_7) {reg = "x0"} : (i64) -> ()
      "braid.store"(%bb8_1, %bb8_0) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10024
      %bbc_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bbc_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_0 = "braid.eq"(%bbc_1, %bbc_2) : (i64, i64) -> i64
      "braid.cond_br"(%bbc_0)[^bb4, ^bb10] : (i64) -> ()
    ^bb10:  // 0x10028
      %bb10_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid.br_ind"(%bb10_0) : (i64) -> ()
  }) {sym_name = "fill", entry = 65560 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x1002c
      %bb0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_12 = "braid.or"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_12) {reg = "x8"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10030
      %bb4_0 = "braid.get"() {reg = "x0"} : () -> i64
      "braid.cond_br"(%bb4_0)[^bb8, ^bb18] : (i64) -> ()
    ^bb8:  // 0x10034
      %bb8_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb8_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8_3 = "braid.and"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_3) {reg = "x9"} : (i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10038
      %bbc_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bbc_3 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc_20 = "braid.lshr"(%bbc_0, %bbc_3) : (i64, i64) -> i64
      "braid.set"(%bbc_20) {reg = "x0"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x1003c
      %bb10_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb10_2 = "braid.get"() {reg = "x9"} : () -> i64
      %bb10_12 = "braid.add"(%bb10_0, %bb10_2) : (i64, i64) -> i64
      "braid.set"(%bb10_12) {reg = "x8"} : (i64) -> ()
      "braid.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10040
      %bb14_0 = "braid.get"() {reg = "x0"} : () -> i64
      "braid.cond_br"(%bb14_0)[^bb8, ^bb18] : (i64) -> ()
    ^bb18:  // 0x10044
      %bb18_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_2 = "braid.get"() {reg = "x8"} : () -> i64
      %bb18_12 = "braid.or"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      "braid.set"(%bb18_12) {reg = "x0"} : (i64) -> ()
      "braid.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10048
      %bb1c_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid.br_ind"(%bb1c_0) : (i64) -> ()
  }) {sym_name = "count_ones", entry = 65580 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
