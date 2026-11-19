"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x2"} : () -> i64
      "braid_cf.cond_br"(%bb0_0)[^bb4, ^bb14] : (i64) -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb4_5 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4_6 = "braid.add"(%bb4_0, %bb4_5) : (i64, i64) -> i64
      "braid.set"(%bb4_6) {reg = "x1"} : (i64) -> ()
      %bb4_30 = "braid.load"(%bb4_0) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb4_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb8_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8_3 = "braid.sub"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      %bb8_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_4 = "braid.slt"(%bb8_3, %bb8_8) : (i64, i64) -> i64
      %bb8_5 = "braid.eq"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      %bb8_6 = "braid.ule"(%bb8_2, %bb8_0) : (i64, i64) -> i64
      %bb8_9 = "braid.xor"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      %bb8_10 = "braid.xor"(%bb8_0, %bb8_3) : (i64, i64) -> i64
      %bb8_11 = "braid.and"(%bb8_9, %bb8_10) : (i64, i64) -> i64
      %bb8_7 = "braid.slt"(%bb8_11, %bb8_8) : (i64, i64) -> i64
      "braid.setf"(%bb8_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb8_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb8_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb8_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb8_3) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bbc_1 = "braid.get"() {reg = "x0"} : () -> i64
      %bbc_6 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc_7 = "braid.add"(%bbc_1, %bbc_6) : (i64, i64) -> i64
      "braid.set"(%bbc_7) {reg = "x0"} : (i64) -> ()
      "braid.store"(%bbc_1, %bbc_0) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb10_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_0 = "braid.eq"(%bb10_1, %bb10_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb10_0)[^bb4, ^bb14] : (i64) -> ()
    ^bb14:  // 0x10014
      %bb14_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb14_0) : (i64) -> ()
  }) {sym_name = "copy_bytes", entry = 65536 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10018
      %bb0_0 = "braid.get"() {reg = "x2"} : () -> i64
      "braid_cf.cond_br"(%bb0_0)[^bb4, ^bb28] : (i64) -> ()
    ^bb4:  // 0x1001c
      %bb4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.get"() {reg = "x0"} : () -> i64
      %bb4_12 = "braid.or"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10020
      %bb8_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bb8_0) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10024
      %bbc_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bbc_5 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc_6 = "braid.add"(%bbc_0, %bbc_5) : (i64, i64) -> i64
      "braid.set"(%bbc_6) {reg = "x8"} : (i64) -> ()
      %bbc_30 = "braid.load"(%bbc_0) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bbc_30) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10028
      %bb10_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb10_5 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_6 = "braid.add"(%bb10_0, %bb10_5) : (i64, i64) -> i64
      "braid.set"(%bb10_6) {reg = "x1"} : (i64) -> ()
      %bb10_30 = "braid.load"(%bb10_0) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb10_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x1002c
      %bb14_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb14_0 = "braid.zext"(%bb14_1) {bits = 32 : i64} : (i64) -> i64
      %bb14_3 = "braid.get"() {reg = "x10"} : () -> i64
      %bb14_2 = "braid.zext"(%bb14_3) {bits = 32 : i64} : (i64) -> i64
      %bb14_17 = "braid.sub"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      %bb14_12 = "braid.zext"(%bb14_17) {bits = 32 : i64} : (i64) -> i64
      %bb14_18 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_19 = "braid.sext"(%bb14_12) {bits = 32 : i64} : (i64) -> i64
      %bb14_13 = "braid.slt"(%bb14_19, %bb14_18) : (i64, i64) -> i64
      %bb14_14 = "braid.eq"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      %bb14_15 = "braid.ule"(%bb14_2, %bb14_0) : (i64, i64) -> i64
      %bb14_20 = "braid.xor"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      %bb14_21 = "braid.xor"(%bb14_0, %bb14_12) : (i64, i64) -> i64
      %bb14_22 = "braid.and"(%bb14_20, %bb14_21) : (i64, i64) -> i64
      %bb14_23 = "braid.sext"(%bb14_22) {bits = 32 : i64} : (i64) -> i64
      %bb14_16 = "braid.slt"(%bb14_23, %bb14_18) : (i64, i64) -> i64
      "braid.setf"(%bb14_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb14_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb14_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb14_16) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10030
      %bb18_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb18_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_0 = "braid.eq"(%bb18_1, %bb18_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb18_0)[^bb30, ^bb1c] : (i64) -> ()
    ^bb1c:  // 0x10034
      %bb1c_0 = "braid.get"() {reg = "x2"} : () -> i64
      %bb1c_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1c_3 = "braid.sub"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      %bb1c_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_4 = "braid.slt"(%bb1c_3, %bb1c_8) : (i64, i64) -> i64
      %bb1c_5 = "braid.eq"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      %bb1c_6 = "braid.ule"(%bb1c_2, %bb1c_0) : (i64, i64) -> i64
      %bb1c_9 = "braid.xor"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      %bb1c_10 = "braid.xor"(%bb1c_0, %bb1c_3) : (i64, i64) -> i64
      %bb1c_11 = "braid.and"(%bb1c_9, %bb1c_10) : (i64, i64) -> i64
      %bb1c_7 = "braid.slt"(%bb1c_11, %bb1c_8) : (i64, i64) -> i64
      "braid.setf"(%bb1c_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb1c_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb1c_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb1c_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb1c_3) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10038
      %bb20_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb20_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_0 = "braid.eq"(%bb20_1, %bb20_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb20_0)[^bbc, ^bb24] : (i64) -> ()
    ^bb24:  // 0x1003c
      %bb24_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb24_0) : (i64) -> ()
    ^bb28:  // 0x10040
      %bb28_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bb28_0) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x10044
      %bb2c_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb2c_0) : (i64) -> ()
    ^bb30:  // 0x10048
      %bb30_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb30_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb30_12 = "braid.or"(%bb30_0, %bb30_2) : (i64, i64) -> i64
      "braid.set"(%bb30_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x1004c
      %bb34_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb34_0) : (i64) -> ()
  }) {sym_name = "equal_bytes", entry = 65560 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10050
      %bb0_0 = "braid.get"() {reg = "x2"} : () -> i64
      "braid_cf.cond_br"(%bb0_0)[^bb4, ^bb2c] : (i64) -> ()
    ^bb4:  // 0x10054
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_0 = "braid.zext"(%bb4_1) {bits = 32 : i64} : (i64) -> i64
      %bb4_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.zext"(%bb4_3) {bits = 32 : i64} : (i64) -> i64
      %bb4_12 = "braid.or"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10058
      %bb8_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb8_5 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8_6 = "braid.add"(%bb8_0, %bb8_5) : (i64, i64) -> i64
      "braid.set"(%bb8_6) {reg = "x0"} : (i64) -> ()
      %bb8_30 = "braid.load"(%bb8_0) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb8_30) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1005c
      %bbc_0 = "braid.get"() {reg = "x2"} : () -> i64
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
      "braid.set"(%bbc_3) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10060
      %bb10_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb10_5 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_6 = "braid.add"(%bb10_0, %bb10_5) : (i64, i64) -> i64
      "braid.set"(%bb10_6) {reg = "x1"} : (i64) -> ()
      %bb10_30 = "braid.load"(%bb10_0) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb10_30) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10064
      %bb14_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb14_0 = "braid.zext"(%bb14_1) {bits = 32 : i64} : (i64) -> i64
      %bb14_3 = "braid.get"() {reg = "x9"} : () -> i64
      %bb14_2 = "braid.zext"(%bb14_3) {bits = 32 : i64} : (i64) -> i64
      %bb14_12 = "braid.xor"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      "braid.set"(%bb14_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10068
      %bb18_1 = "braid.get"() {reg = "x9"} : () -> i64
      %bb18_0 = "braid.zext"(%bb18_1) {bits = 32 : i64} : (i64) -> i64
      %bb18_3 = "braid.get"() {reg = "x8"} : () -> i64
      %bb18_2 = "braid.zext"(%bb18_3) {bits = 32 : i64} : (i64) -> i64
      %bb18_12 = "braid.or"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      "braid.set"(%bb18_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1006c
      %bb1c_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb1c_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_0 = "braid.eq"(%bb1c_1, %bb1c_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb1c_0)[^bb8, ^bb20] : (i64) -> ()
    ^bb20:  // 0x10070
      %bb20_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb20_0 = "braid.zext"(%bb20_1) {bits = 32 : i64} : (i64) -> i64
      %bb20_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_8 = "braid.sub"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      %bb20_3 = "braid.zext"(%bb20_8) {bits = 32 : i64} : (i64) -> i64
      %bb20_9 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_10 = "braid.sext"(%bb20_3) {bits = 32 : i64} : (i64) -> i64
      %bb20_4 = "braid.slt"(%bb20_10, %bb20_9) : (i64, i64) -> i64
      %bb20_5 = "braid.eq"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      %bb20_6 = "braid.ule"(%bb20_2, %bb20_0) : (i64, i64) -> i64
      %bb20_11 = "braid.xor"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      %bb20_12 = "braid.xor"(%bb20_0, %bb20_3) : (i64, i64) -> i64
      %bb20_13 = "braid.and"(%bb20_11, %bb20_12) : (i64, i64) -> i64
      %bb20_14 = "braid.sext"(%bb20_13) {bits = 32 : i64} : (i64) -> i64
      %bb20_7 = "braid.slt"(%bb20_14, %bb20_9) : (i64, i64) -> i64
      "braid.setf"(%bb20_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb20_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb20_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb20_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10074
      %bb24_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb24_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_0 = "braid.eq"(%bb24_1, %bb24_2) : (i64, i64) -> i64
      %bb24_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_5 = "braid.zext"(%bb24_6) {bits = 32 : i64} : (i64) -> i64
      %bb24_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_9 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb24_10 = "braid.add"(%bb24_8, %bb24_9) : (i64, i64) -> i64
      %bb24_7 = "braid.zext"(%bb24_10) {bits = 32 : i64} : (i64) -> i64
      %bb24_12 = "braid.select"(%bb24_0, %bb24_5, %bb24_7) : (i64, i64, i64) -> i64
      "braid.set"(%bb24_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x10078
      %bb28_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb28_0) : (i64) -> ()
    ^bb2c:  // 0x1007c
      %bb2c_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bb2c_0) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10080
      %bb30_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bb30_0) : (i64) -> ()
  }) {sym_name = "equal_bytes_ct", entry = 65616 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
