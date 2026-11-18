"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10004
      %bb0_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb0_12 = "braid.add"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10008
      %bb4_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb4_2 = "braid.get"() {reg = "x2"} : () -> i64
      %bb4_12 = "braid.add"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1000c
      %bb8_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb8_0) : (i64) -> ()
  }) {sym_name = "add3", entry = 65540 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x1002c
      %bb0_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "x1"} : () -> i64
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
    ^bb4:  // 0x10030
      %bb4_1 = "braid.getf"() {flag = "c"} : () -> i64
      %bb4_2 = "braid.getf"() {flag = "z"} : () -> i64
      %bb4_0 = "braid.ult"(%bb4_2, %bb4_1) : (i64, i64) -> i64
      %bb4_5 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_7 = "braid.get"() {reg = "x1"} : () -> i64
      %bb4_12 = "braid.select"(%bb4_0, %bb4_5, %bb4_7) : (i64, i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10034
      %bb8_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb8_0) : (i64) -> ()
  }) {sym_name = "max_u64", entry = 65580 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10010
      %bb0_0 = "braid.get"() {reg = "x1"} : () -> i64
      "braid_cf.cond_br"(%bb0_0)[^bb4, ^bb18] : (i64) -> ()
    ^bb4:  // 0x10014
      %bb4_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb4_9 = "braid.udiv"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_9) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10018
      %bb8_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb8_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb8_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb8_3 = "braid.mul"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_9 = "braid.sub"(%bb8_2, %bb8_3) : (i64, i64) -> i64
      "braid.set"(%bb8_9) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1001c
      %bbc_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.get"() {reg = "x1"} : () -> i64
      %bbc_12 = "braid.or"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      "braid.set"(%bbc_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10020
      %bb10_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_2 = "braid.get"() {reg = "x8"} : () -> i64
      %bb10_12 = "braid.or"(%bb10_0, %bb10_2) : (i64, i64) -> i64
      "braid.set"(%bb10_12) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10024
      %bb14_0 = "braid.get"() {reg = "x8"} : () -> i64
      "braid_cf.cond_br"(%bb14_0)[^bb4, ^bb18] : (i64) -> ()
    ^bb18:  // 0x10028
      %bb18_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb18_0) : (i64) -> ()
  }) {sym_name = "gcd", entry = 65552 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10038
      %bb0_0 = "braid.get"() {reg = "x1"} : () -> i64
      "braid_cf.cond_br"(%bb0_0)[^bb4, ^bb24] : (i64) -> ()
    ^bb4:  // 0x1003c
      %bb4_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb4_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb4_20 = "braid.shl"(%bb4_0, %bb4_3) : (i64, i64) -> i64
      "braid.set"(%bb4_20) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10040
      %bb8_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_12 = "braid.or"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10044
      %bbc_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bbc_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbc_6 = "braid.add"(%bbc_0, %bbc_5) : (i64, i64) -> i64
      "braid.set"(%bbc_6) {reg = "x0"} : (i64) -> ()
      %bbc_30 = "braid.load"(%bbc_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbc_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10048
      %bb10_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb10_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb10_3 = "braid.sub"(%bb10_0, %bb10_2) : (i64, i64) -> i64
      %bb10_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_4 = "braid.slt"(%bb10_3, %bb10_8) : (i64, i64) -> i64
      %bb10_5 = "braid.eq"(%bb10_0, %bb10_2) : (i64, i64) -> i64
      %bb10_6 = "braid.ule"(%bb10_2, %bb10_0) : (i64, i64) -> i64
      %bb10_9 = "braid.xor"(%bb10_0, %bb10_2) : (i64, i64) -> i64
      %bb10_10 = "braid.xor"(%bb10_0, %bb10_3) : (i64, i64) -> i64
      %bb10_11 = "braid.and"(%bb10_9, %bb10_10) : (i64, i64) -> i64
      %bb10_7 = "braid.slt"(%bb10_11, %bb10_8) : (i64, i64) -> i64
      "braid.setf"(%bb10_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb10_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb10_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb10_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb10_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x1004c
      %bb14_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb14_2 = "braid.get"() {reg = "x8"} : () -> i64
      %bb14_12 = "braid.add"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      "braid.set"(%bb14_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10050
      %bb18_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb18_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_0 = "braid.eq"(%bb18_1, %bb18_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb18_0)[^bbc, ^bb1c] : (i64) -> ()
    ^bb1c:  // 0x10054
      %bb1c_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_2 = "braid.get"() {reg = "x8"} : () -> i64
      %bb1c_12 = "braid.or"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      "braid.set"(%bb1c_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10058
      %bb20_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb20_0) : (i64) -> ()
    ^bb24:  // 0x1005c
      %bb24_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_12 = "braid.or"(%bb24_0, %bb24_2) : (i64, i64) -> i64
      "braid.set"(%bb24_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10060
      %bb28_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_2 = "braid.get"() {reg = "x8"} : () -> i64
      %bb28_12 = "braid.or"(%bb28_0, %bb28_2) : (i64, i64) -> i64
      "braid.set"(%bb28_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x10064
      %bb2c_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb2c_0) : (i64) -> ()
  }) {sym_name = "sum_slice", entry = 65592 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
