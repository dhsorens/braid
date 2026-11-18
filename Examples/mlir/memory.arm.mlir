"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb0_30 = "braid.load"(%bb0_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb0_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_30 = "braid.load"(%bb4_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb4_30) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb8_1 = "braid.get"() {reg = "x0"} : () -> i64
      "braid.store"(%bb8_1, %bb8_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bbc_1 = "braid.get"() {reg = "x1"} : () -> i64
      "braid.store"(%bbc_1, %bbc_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb10_0) : (i64) -> ()
  }) {sym_name = "swap", entry = 65536 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10014
      %bb0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_12 = "braid.or"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10018
      %bb4_0 = "braid.get"() {reg = "x1"} : () -> i64
      "braid_cf.cond_br"(%bb4_0)[^bb8, ^bb18] : (i64) -> ()
    ^bb8:  // 0x1001c
      %bb8_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb8_5 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8_6 = "braid.add"(%bb8_0, %bb8_5) : (i64, i64) -> i64
      "braid.set"(%bb8_6) {reg = "x0"} : (i64) -> ()
      %bb8_30 = "braid.load"(%bb8_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb8_30) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10020
      %bbc_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bbc_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc_3 = "braid.sub"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      %bbc_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_4 = "braid.slt"(%bbc_3, %bbc_8) : (i64, i64) -> i64
      %bbc_5 = "braid.eq"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      %bbc_6 = "braid.ule"(%bbc_2, %bbc_0) : (i64, i64) -> i64
      %bbc_9 = "braid.xor"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      %bbc_10 = "braid.xor"(%bbc_0, %bbc_3) : (i64, i64) -> i64
      %bbc_11 = "braid.and"(%bbc_9, %bbc_10) : (i64, i64) -> i64
      %bbc_7 = "braid.slt"(%bbc_11, %bbc_8) : (i64, i64) -> i64
      "braid.setf"(%bbc_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bbc_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bbc_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bbc_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bbc_3) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10024
      %bb10_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb10_2 = "braid.get"() {reg = "x8"} : () -> i64
      %bb10_12 = "braid.add"(%bb10_0, %bb10_2) : (i64, i64) -> i64
      "braid.set"(%bb10_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10028
      %bb14_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb14_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_0 = "braid.eq"(%bb14_1, %bb14_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb14_0)[^bb8, ^bb18] : (i64) -> ()
    ^bb18:  // 0x1002c
      %bb18_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_2 = "braid.get"() {reg = "x8"} : () -> i64
      %bb18_12 = "braid.or"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      "braid.set"(%bb18_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10030
      %bb1c_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb1c_0) : (i64) -> ()
  }) {sym_name = "sum_array", entry = 65556 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10034
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
    ^bb4:  // 0x10038
      %bb4_1 = "braid.getf"() {flag = "c"} : () -> i64
      %bb4_2 = "braid.getf"() {flag = "z"} : () -> i64
      %bb4_0 = "braid.ult"(%bb4_2, %bb4_1) : (i64, i64) -> i64
      %bb4_5 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_7 = "braid.get"() {reg = "x1"} : () -> i64
      %bb4_12 = "braid.select"(%bb4_0, %bb4_5, %bb4_7) : (i64, i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1003c
      %bb8_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb8_0) : (i64) -> ()
  }) {sym_name = "max2", entry = 65588 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10040
      %bb0_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb0_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb0_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb0_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb0_5 = "braid.and"(%bb0_3, %bb0_4) : (i64, i64) -> i64
      %bb0_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_7 = "braid.eq"(%bb0_5, %bb0_6) : (i64, i64) -> i64
      "braid.guard"(%bb0_7) : (i64) -> ()
      %bb0_8 = "braid.const"() {value = -32 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_3, %bb0_8) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "sp"} : (i64) -> ()
      %bb0_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_24 = "braid.add"(%bb0_2, %bb0_23) : (i64, i64) -> i64
      "braid.store"(%bb0_2, %bb0_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb0_24, %bb0_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10044
      %bb4_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb4_2 = "braid.get"() {reg = "sp"} : () -> i64
      %bb4_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb4_4 = "braid.and"(%bb4_2, %bb4_3) : (i64, i64) -> i64
      %bb4_5 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_6 = "braid.eq"(%bb4_4, %bb4_5) : (i64, i64) -> i64
      "braid.guard"(%bb4_6) : (i64) -> ()
      %bb4_7 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb4_1 = "braid.add"(%bb4_2, %bb4_7) : (i64, i64) -> i64
      "braid.store"(%bb4_1, %bb4_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10048
      %bb8_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb8_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_3 = "braid.add"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_3) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1004c
      %bbc_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.get"() {reg = "x2"} : () -> i64
      %bbc_12 = "braid.or"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      "braid.set"(%bbc_12) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10050
      %bb10_0 = "braid.const"() {value = 65620 : i64} : () -> i64
      "braid.set"(%bb10_0) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^ext10034] : () -> ()
    ^bb14:  // 0x10054
      %bb14_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_2 = "braid.get"() {reg = "x19"} : () -> i64
      %bb14_12 = "braid.or"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      "braid.set"(%bb14_12) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10058
      %bb18_1 = "braid.get"() {reg = "sp"} : () -> i64
      %bb18_2 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb18_3 = "braid.and"(%bb18_1, %bb18_2) : (i64, i64) -> i64
      %bb18_4 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_5 = "braid.eq"(%bb18_3, %bb18_4) : (i64, i64) -> i64
      "braid.guard"(%bb18_5) : (i64) -> ()
      %bb18_6 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb18_0 = "braid.add"(%bb18_1, %bb18_6) : (i64, i64) -> i64
      %bb18_30 = "braid.load"(%bb18_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb18_30) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1005c
      %bb1c_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1c_2 = "braid.and"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      %bb1c_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_4 = "braid.eq"(%bb1c_2, %bb1c_3) : (i64, i64) -> i64
      "braid.guard"(%bb1c_4) : (i64) -> ()
      %bb1c_5 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb1c_6 = "braid.add"(%bb1c_0, %bb1c_5) : (i64, i64) -> i64
      "braid.set"(%bb1c_6) {reg = "sp"} : (i64) -> ()
      %bb1c_21 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c_22 = "braid.add"(%bb1c_0, %bb1c_21) : (i64, i64) -> i64
      %bb1c_23 = "braid.load"(%bb1c_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1c_26 = "braid.load"(%bb1c_22) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb1c_23) {reg = "x29"} : (i64) -> ()
      "braid.set"(%bb1c_26) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10060
      "braid_cf.br"()[^ext10034] : () -> ()
    ^ext10034:
      "braid_cf.tail"() {target = 65588 : i64} : () -> ()
  }) {sym_name = "max3", entry = 65600 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
