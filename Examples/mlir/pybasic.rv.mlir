"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb0_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb4_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
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
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      "braid.set"(%bbc_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb10_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb10_4 = "braid.and"(%bb10_2, %bb10_3) : (i64, i64) -> i64
      %bb10_5 = "braid.const"() {value = 65556 : i64} : () -> i64
      "braid_cf.br_ind"(%bb10_4) : (i64) -> ()
  }) {sym_name = "py_add3", entry = 65536 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10014
      %bb0_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb0_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb0_2 = "braid.ult"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb0_2)[^bb8, ^bb4] : (i64) -> ()
    ^bb4:  // 0x10018
      %bb4_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1001c
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
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10020
      %bbc_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      "braid.set"(%bbc_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10024
      %bb10_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb10_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb10_4 = "braid.and"(%bb10_2, %bb10_3) : (i64, i64) -> i64
      %bb10_5 = "braid.const"() {value = 65576 : i64} : () -> i64
      "braid_cf.br_ind"(%bb10_4) : (i64) -> ()
  }) {sym_name = "py_max_u64", entry = 65556 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10028
      %bb0_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.eq"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb0_2)[^bb18, ^bb4] : (i64) -> ()
    ^bb4:  // 0x1002c
      %bb4_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10030
      %bb8_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb8_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb8_2 = "braid.urem"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_4 = "braid.eq"(%bb8_1, %bb8_3) : (i64, i64) -> i64
      %bb8_6 = "braid.select"(%bb8_4, %bb8_0, %bb8_2) : (i64, i64, i64) -> i64
      "braid.set"(%bb8_6) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10034
      %bbc_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      "braid.set"(%bbc_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10038
      %bb10_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb10_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_2 = "braid.ne"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb10_2)[^bb4, ^bb14] : (i64) -> ()
    ^bb14:  // 0x1003c
      %bb14_0 = "braid.const"() {value = 65600 : i64} : () -> i64
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb18:  // 0x10040
      %bb18_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb18_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      "braid.set"(%bb18_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10044
      %bb1c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      %bb1c_3 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1c_4 = "braid.and"(%bb1c_2, %bb1c_3) : (i64, i64) -> i64
      %bb1c_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_6 = "braid.eq"(%bb1c_4, %bb1c_5) : (i64, i64) -> i64
      "braid.guard"(%bb1c_6) : (i64) -> ()
      %bb1c_7 = "braid.get"() {reg = "x11"} : () -> i64
      "braid.store"(%bb1c_2, %bb1c_7) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10048
      %bb20_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_2 = "braid.add"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      "braid.set"(%bb20_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x1004c
      %bb24_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb24_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_2 = "braid.add"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      %bb24_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb24_4 = "braid.and"(%bb24_2, %bb24_3) : (i64, i64) -> i64
      %bb24_5 = "braid.const"() {value = 65616 : i64} : () -> i64
      "braid_cf.br_ind"(%bb24_4) : (i64) -> ()
  }) {sym_name = "py_gcd", entry = 65576 : i64} : () -> ()
}) {arch = "riscv64"} : () -> ()
