"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10000
      %bb0_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.eq"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb0_2)[^bb1c, ^bb4] : (i64) -> ()
    ^bb4:  // 0x10004
      %bb4_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb4_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10008
      %bb8_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      %bb8_7 = "braid.load"(%bb8_2) {bytes = 1 : i64} : (i64) -> i64
      %bb8_8 = "braid.zext"(%bb8_7) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bb8_8) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x1000c
      %bbc_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      %bbc_7 = "braid.get"() {reg = "x13"} : () -> i64
      "braid.store"(%bbc_2, %bbc_7) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10010
      %bb10_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb10_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      "braid.set"(%bb10_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10014
      %bb14_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb14_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      "braid.set"(%bb14_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x10018
      %bb18_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb18_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb18_2 = "braid.ne"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb18_2)[^bb8, ^bb1c] : (i64) -> ()
    ^bb1c:  // 0x1001c
      %bb1c_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      %bb1c_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb1c_4 = "braid.and"(%bb1c_2, %bb1c_3) : (i64, i64) -> i64
      %bb1c_5 = "braid.const"() {value = 65568 : i64} : () -> i64
      "braid_cf.br_ind"(%bb1c_4) : (i64) -> ()
  }) {sym_name = "copy_bytes", entry = 65536 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10020
      %bb0_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.add"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid.set"(%bb0_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x10024
      %bb4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x10028
      %bb8_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_2 = "braid.eq"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb8_2)[^bb28, ^bbc] : (i64) -> ()
    ^bbc:  // 0x1002c
      %bbc_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bbc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      %bbc_7 = "braid.load"(%bbc_2) {bytes = 1 : i64} : (i64) -> i64
      %bbc_8 = "braid.zext"(%bbc_7) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bbc_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10030
      %bb10_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb10_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_7 = "braid.load"(%bb10_2) {bytes = 1 : i64} : (i64) -> i64
      %bb10_8 = "braid.zext"(%bb10_7) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bb10_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10034
      %bb14_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb14_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb14_2 = "braid.ne"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb14_2)[^bb2c, ^bb18] : (i64) -> ()
    ^bb18:  // 0x10038
      %bb18_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb18_1 = "braid.const"() {value = -1 : i64} : () -> i64
      %bb18_2 = "braid.add"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      "braid.set"(%bb18_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x1003c
      %bb1c_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb1c_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      "braid.set"(%bb1c_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10040
      %bb20_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb20_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb20_2 = "braid.add"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      "braid.set"(%bb20_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10044
      %bb24_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb24_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_2 = "braid.ne"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb24_2)[^bbc, ^bb28] : (i64) -> ()
    ^bb28:  // 0x10048
      %bb28_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb28_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_2 = "braid.add"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      %bb28_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb28_4 = "braid.and"(%bb28_2, %bb28_3) : (i64, i64) -> i64
      %bb28_5 = "braid.const"() {value = 65612 : i64} : () -> i64
      "braid_cf.br_ind"(%bb28_4) : (i64) -> ()
    ^bb2c:  // 0x1004c
      %bb2c_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_2 = "braid.add"(%bb2c_0, %bb2c_1) : (i64, i64) -> i64
      "braid.set"(%bb2c_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x10050
      %bb30_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb30_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb30_2 = "braid.add"(%bb30_0, %bb30_1) : (i64, i64) -> i64
      %bb30_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb30_4 = "braid.and"(%bb30_2, %bb30_3) : (i64, i64) -> i64
      %bb30_5 = "braid.const"() {value = 65620 : i64} : () -> i64
      "braid_cf.br_ind"(%bb30_4) : (i64) -> ()
  }) {sym_name = "equal_bytes", entry = 65568 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x10054
      %bb0_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb0_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_2 = "braid.eq"(%bb0_0, %bb0_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb0_2)[^bb30, ^bb4] : (i64) -> ()
    ^bb4:  // 0x10058
      %bb4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_0, %bb4_1) : (i64, i64) -> i64
      "braid.set"(%bb4_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x1005c
      %bb8_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb8_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb8_2 = "braid.add"(%bb8_0, %bb8_1) : (i64, i64) -> i64
      "braid.set"(%bb8_2) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x10060
      %bbc_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbc_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc_2 = "braid.add"(%bbc_0, %bbc_1) : (i64, i64) -> i64
      %bbc_7 = "braid.load"(%bbc_2) {bytes = 1 : i64} : (i64) -> i64
      %bbc_8 = "braid.zext"(%bbc_7) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bbc_8) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x10064
      %bb10_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb10_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_0, %bb10_1) : (i64, i64) -> i64
      %bb10_7 = "braid.load"(%bb10_2) {bytes = 1 : i64} : (i64) -> i64
      %bb10_8 = "braid.zext"(%bb10_7) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bb10_8) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x10068
      %bb14_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb14_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14_2 = "braid.add"(%bb14_0, %bb14_1) : (i64, i64) -> i64
      "braid.set"(%bb14_2) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x1006c
      %bb18_0 = "braid.get"() {reg = "x15"} : () -> i64
      %bb18_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb18_2 = "braid.xor"(%bb18_0, %bb18_1) : (i64, i64) -> i64
      "braid.set"(%bb18_2) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x10070
      %bb1c_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "x13"} : () -> i64
      %bb1c_2 = "braid.or"(%bb1c_0, %bb1c_1) : (i64, i64) -> i64
      "braid.set"(%bb1c_2) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x10074
      %bb20_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb20_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb20_2 = "braid.add"(%bb20_0, %bb20_1) : (i64, i64) -> i64
      "braid.set"(%bb20_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x10078
      %bb24_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb24_1 = "braid.get"() {reg = "x12"} : () -> i64
      %bb24_2 = "braid.ne"(%bb24_0, %bb24_1) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb24_2)[^bbc, ^bb28] : (i64) -> ()
    ^bb28:  // 0x1007c
      %bb28_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb28_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb28_2 = "braid.ult"(%bb28_0, %bb28_1) : (i64, i64) -> i64
      "braid.set"(%bb28_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x10080
      %bb2c_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb2c_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2c_2 = "braid.add"(%bb2c_0, %bb2c_1) : (i64, i64) -> i64
      %bb2c_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb2c_4 = "braid.and"(%bb2c_2, %bb2c_3) : (i64, i64) -> i64
      %bb2c_5 = "braid.const"() {value = 65668 : i64} : () -> i64
      "braid_cf.br_ind"(%bb2c_4) : (i64) -> ()
    ^bb30:  // 0x10084
      %bb30_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb30_1 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb30_2 = "braid.add"(%bb30_0, %bb30_1) : (i64, i64) -> i64
      "braid.set"(%bb30_2) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x10088
      %bb34_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb34_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb34_2 = "braid.add"(%bb34_0, %bb34_1) : (i64, i64) -> i64
      %bb34_3 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb34_4 = "braid.and"(%bb34_2, %bb34_3) : (i64, i64) -> i64
      %bb34_5 = "braid.const"() {value = 65676 : i64} : () -> i64
      "braid_cf.br_ind"(%bb34_4) : (i64) -> ()
  }) {sym_name = "equal_bytes_ct", entry = 65620 : i64} : () -> ()
}) {arch = "riscv64"} : () -> ()
