"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x84500
      %bb0_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb0_12 = "braid.add"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_12) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x84504
      %bb4_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4_2 = "braid.get"() {reg = "x1"} : () -> i64
      %bb4_12 = "braid.add"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x84508
      %bb8_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb8_0) : (i64) -> ()
  }) {sym_name = "main.Add3", entry = 541952 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x84510
      %bb0_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb0_12 = "braid.sub"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      %bb0_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_13 = "braid.slt"(%bb0_12, %bb0_17) : (i64, i64) -> i64
      %bb0_14 = "braid.eq"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      %bb0_15 = "braid.ule"(%bb0_2, %bb0_0) : (i64, i64) -> i64
      %bb0_18 = "braid.xor"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      %bb0_19 = "braid.xor"(%bb0_0, %bb0_12) : (i64, i64) -> i64
      %bb0_20 = "braid.and"(%bb0_18, %bb0_19) : (i64, i64) -> i64
      %bb0_16 = "braid.slt"(%bb0_20, %bb0_17) : (i64, i64) -> i64
      "braid.setf"(%bb0_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb0_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb0_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb0_16) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x84514
      %bb4_0 = "braid.getf"() {flag = "c"} : () -> i64
      "braid_cf.cond_br"(%bb4_0)[^bbc, ^bb8] : (i64) -> ()
    ^bb8:  // 0x84518
      %bb8_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb8_0) : (i64) -> ()
    ^bbc:  // 0x8451c
      %bbc_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.get"() {reg = "x1"} : () -> i64
      %bbc_12 = "braid.or"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      "braid.set"(%bbc_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x84520
      %bb10_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb10_0) : (i64) -> ()
  }) {sym_name = "main.MaxU64", entry = 541968 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x84530
      %bb0_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "sp"} : () -> i64
      %bb0_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb0_4 = "braid.and"(%bb0_2, %bb0_3) : (i64, i64) -> i64
      %bb0_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_6 = "braid.eq"(%bb0_4, %bb0_5) : (i64, i64) -> i64
      "braid.guard"(%bb0_6) : (i64) -> ()
      %bb0_7 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_1 = "braid.add"(%bb0_2, %bb0_7) : (i64, i64) -> i64
      "braid.store"(%bb0_1, %bb0_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x84534
      %bb4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_12 = "braid.or"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x84538
      %bb8_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_12 = "braid.or"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x8453c
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb10:  // 0x84540
      %bb10_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bb10_7 = "braid.get"() {reg = "x2"} : () -> i64
      %bb10_8 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb10_6 = "braid.shl"(%bb10_7, %bb10_8) : (i64, i64) -> i64
      %bb10_0 = "braid.add"(%bb10_1, %bb10_6) : (i64, i64) -> i64
      %bb10_30 = "braid.load"(%bb10_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb10_30) {reg = "x4"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x84544
      %bb14_0 = "braid.get"() {reg = "x3"} : () -> i64
      %bb14_2 = "braid.get"() {reg = "x4"} : () -> i64
      %bb14_12 = "braid.add"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      "braid.set"(%bb14_12) {reg = "x3"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x84548
      %bb18_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb18_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb18_3 = "braid.add"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      "braid.set"(%bb18_3) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x8454c
      %bb1c_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb1c_2 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1c_12 = "braid.sub"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      %bb1c_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_13 = "braid.slt"(%bb1c_12, %bb1c_17) : (i64, i64) -> i64
      %bb1c_14 = "braid.eq"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      %bb1c_15 = "braid.ule"(%bb1c_2, %bb1c_0) : (i64, i64) -> i64
      %bb1c_18 = "braid.xor"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      %bb1c_19 = "braid.xor"(%bb1c_0, %bb1c_12) : (i64, i64) -> i64
      %bb1c_20 = "braid.and"(%bb1c_18, %bb1c_19) : (i64, i64) -> i64
      %bb1c_16 = "braid.slt"(%bb1c_20, %bb1c_17) : (i64, i64) -> i64
      "braid.setf"(%bb1c_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb1c_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb1c_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb1c_16) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x84550
      %bb20_1 = "braid.getf"() {flag = "n"} : () -> i64
      %bb20_2 = "braid.getf"() {flag = "v"} : () -> i64
      %bb20_3 = "braid.eq"(%bb20_1, %bb20_2) : (i64, i64) -> i64
      %bb20_4 = "braid.getf"() {flag = "z"} : () -> i64
      %bb20_0 = "braid.ult"(%bb20_4, %bb20_3) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb20_0)[^bb10, ^bb24] : (i64) -> ()
    ^bb24:  // 0x84554
      %bb24_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_2 = "braid.get"() {reg = "x3"} : () -> i64
      %bb24_12 = "braid.or"(%bb24_0, %bb24_2) : (i64, i64) -> i64
      "braid.set"(%bb24_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x84558
      %bb28_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb28_0) : (i64) -> ()
  }) {sym_name = "main.SumSlice", entry = 542000 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
