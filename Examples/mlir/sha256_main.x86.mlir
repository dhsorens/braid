"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401100
      %bb0_0 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb0_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb0_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_10 = "braid.sub"(%bb0_8, %bb0_9) : (i64, i64) -> i64
      "braid.set"(%bb0_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb0_10, %bb0_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1] : () -> ()
    ^bb1:  // 0x401101
      %bb1_0 = "braid.get"() {reg = "r15"} : () -> i64
      %bb1_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1_10 = "braid.sub"(%bb1_8, %bb1_9) : (i64, i64) -> i64
      "braid.set"(%bb1_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb1_10, %bb1_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401103
      %bb3_0 = "braid.get"() {reg = "r14"} : () -> i64
      %bb3_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb3_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb3_10 = "braid.sub"(%bb3_8, %bb3_9) : (i64, i64) -> i64
      "braid.set"(%bb3_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb3_10, %bb3_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb5] : () -> ()
    ^bb5:  // 0x401105
      %bb5_0 = "braid.get"() {reg = "r12"} : () -> i64
      %bb5_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb5_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb5_10 = "braid.sub"(%bb5_8, %bb5_9) : (i64, i64) -> i64
      "braid.set"(%bb5_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb5_10, %bb5_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb7] : () -> ()
    ^bb7:  // 0x401107
      %bb7_0 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb7_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb7_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb7_10 = "braid.sub"(%bb7_8, %bb7_9) : (i64, i64) -> i64
      "braid.set"(%bb7_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb7_10, %bb7_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x401108
      %bb8_0 = "braid.const"() {value = 160 : i64} : () -> i64
      %bb8_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb8_16 = "braid.sub"(%bb8_8, %bb8_0) : (i64, i64) -> i64
      %bb8_18 = "braid.ult"(%bb8_8, %bb8_0) : (i64, i64) -> i64
      "braid.setf"(%bb8_18) {flag = "cf"} : (i64) -> ()
      %bb8_19 = "braid.xor"(%bb8_8, %bb8_0) : (i64, i64) -> i64
      %bb8_20 = "braid.xor"(%bb8_8, %bb8_16) : (i64, i64) -> i64
      %bb8_21 = "braid.and"(%bb8_19, %bb8_20) : (i64, i64) -> i64
      %bb8_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb8_23 = "braid.and"(%bb8_21, %bb8_22) : (i64, i64) -> i64
      "braid.setf"(%bb8_23) {flag = "of"} : (i64) -> ()
      %bb8_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb8_24) {flag = "af"} : (i64) -> ()
      %bb8_32 = "braid.zext"(%bb8_16) {bits = 8 : i64} : (i64) -> i64
      %bb8_33 = "braid.popcnt"(%bb8_32) : (i64) -> i64
      %bb8_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8_35 = "braid.and"(%bb8_33, %bb8_34) : (i64, i64) -> i64
      %bb8_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_37 = "braid.eq"(%bb8_35, %bb8_36) : (i64, i64) -> i64
      "braid.setf"(%bb8_37) {flag = "pf"} : (i64) -> ()
      %bb8_38 = "braid.eq"(%bb8_16, %bb8_36) : (i64, i64) -> i64
      "braid.setf"(%bb8_38) {flag = "zf"} : (i64) -> ()
      %bb8_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb8_40 = "braid.and"(%bb8_16, %bb8_39) : (i64, i64) -> i64
      "braid.setf"(%bb8_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb8_16) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br"()[^bbf] : () -> ()
    ^bbf:  // 0x40110f
      %bbf_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbf_0 = "braid.zext"(%bbf_1) {bits = 32 : i64} : (i64) -> i64
      %bbf_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bbf_8 = "braid.zext"(%bbf_9) {bits = 32 : i64} : (i64) -> i64
      %bbf_16 = "braid.xor"(%bbf_0, %bbf_8) : (i64, i64) -> i64
      %bbf_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbf_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbf_17) {flag = "of"} : (i64) -> ()
      %bbf_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbf_24) {flag = "af"} : (i64) -> ()
      %bbf_32 = "braid.zext"(%bbf_16) {bits = 8 : i64} : (i64) -> i64
      %bbf_33 = "braid.popcnt"(%bbf_32) : (i64) -> i64
      %bbf_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf_35 = "braid.and"(%bbf_33, %bbf_34) : (i64, i64) -> i64
      %bbf_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf_37 = "braid.eq"(%bbf_35, %bbf_36) : (i64, i64) -> i64
      "braid.setf"(%bbf_37) {flag = "pf"} : (i64) -> ()
      %bbf_38 = "braid.eq"(%bbf_16, %bbf_36) : (i64, i64) -> i64
      "braid.setf"(%bbf_38) {flag = "zf"} : (i64) -> ()
      %bbf_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbf_40 = "braid.and"(%bbf_16, %bbf_39) : (i64, i64) -> i64
      "braid.setf"(%bbf_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbf_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb11] : () -> ()
    ^bb11:  // 0x401111
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x401120
      %bb20_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb20_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb20_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb20_5 = "braid.mul"(%bb20_3, %bb20_4) : (i64, i64) -> i64
      %bb20_6 = "braid.add"(%bb20_2, %bb20_5) : (i64, i64) -> i64
      %bb20_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_1 = "braid.add"(%bb20_6, %bb20_7) : (i64, i64) -> i64
      %bb20_0 = "braid.load"(%bb20_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb20_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb23] : () -> ()
    ^bb23:  // 0x401123
      %bb23_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb23_0 = "braid.zext"(%bb23_1) {bits = 32 : i64} : (i64) -> i64
      %bb23_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb23_10 = "braid.get"() {reg = "rax"} : () -> i64
      %bb23_11 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb23_12 = "braid.mul"(%bb23_10, %bb23_11) : (i64, i64) -> i64
      %bb23_13 = "braid.add"(%bb23_9, %bb23_12) : (i64, i64) -> i64
      %bb23_14 = "braid.const"() {value = -96 : i64} : () -> i64
      %bb23_8 = "braid.add"(%bb23_13, %bb23_14) : (i64, i64) -> i64
      "braid.store"(%bb23_8, %bb23_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb27] : () -> ()
    ^bb27:  // 0x401127
      %bb27_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb27_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb27_16 = "braid.add"(%bb27_0, %bb27_8) : (i64, i64) -> i64
      %bb27_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb27_20 = "braid.eq"(%bb27_16, %bb27_19) : (i64, i64) -> i64
      "braid.setf"(%bb27_20) {flag = "of"} : (i64) -> ()
      %bb27_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb27_24) {flag = "af"} : (i64) -> ()
      %bb27_32 = "braid.zext"(%bb27_16) {bits = 8 : i64} : (i64) -> i64
      %bb27_33 = "braid.popcnt"(%bb27_32) : (i64) -> i64
      %bb27_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb27_35 = "braid.and"(%bb27_33, %bb27_34) : (i64, i64) -> i64
      %bb27_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb27_37 = "braid.eq"(%bb27_35, %bb27_36) : (i64, i64) -> i64
      "braid.setf"(%bb27_37) {flag = "pf"} : (i64) -> ()
      %bb27_38 = "braid.eq"(%bb27_16, %bb27_36) : (i64, i64) -> i64
      "braid.setf"(%bb27_38) {flag = "zf"} : (i64) -> ()
      %bb27_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb27_40 = "braid.and"(%bb27_16, %bb27_39) : (i64, i64) -> i64
      "braid.setf"(%bb27_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb27_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb2a] : () -> ()
    ^bb2a:  // 0x40112a
      %bb2a_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb2a_8 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb2a_16 = "braid.sub"(%bb2a_0, %bb2a_8) : (i64, i64) -> i64
      %bb2a_18 = "braid.ult"(%bb2a_0, %bb2a_8) : (i64, i64) -> i64
      "braid.setf"(%bb2a_18) {flag = "cf"} : (i64) -> ()
      %bb2a_19 = "braid.xor"(%bb2a_0, %bb2a_8) : (i64, i64) -> i64
      %bb2a_20 = "braid.xor"(%bb2a_0, %bb2a_16) : (i64, i64) -> i64
      %bb2a_21 = "braid.and"(%bb2a_19, %bb2a_20) : (i64, i64) -> i64
      %bb2a_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb2a_23 = "braid.and"(%bb2a_21, %bb2a_22) : (i64, i64) -> i64
      "braid.setf"(%bb2a_23) {flag = "of"} : (i64) -> ()
      %bb2a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb2a_24) {flag = "af"} : (i64) -> ()
      %bb2a_32 = "braid.zext"(%bb2a_16) {bits = 8 : i64} : (i64) -> i64
      %bb2a_33 = "braid.popcnt"(%bb2a_32) : (i64) -> i64
      %bb2a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2a_35 = "braid.and"(%bb2a_33, %bb2a_34) : (i64, i64) -> i64
      %bb2a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2a_37 = "braid.eq"(%bb2a_35, %bb2a_36) : (i64, i64) -> i64
      "braid.setf"(%bb2a_37) {flag = "pf"} : (i64) -> ()
      %bb2a_38 = "braid.eq"(%bb2a_16, %bb2a_36) : (i64, i64) -> i64
      "braid.setf"(%bb2a_38) {flag = "zf"} : (i64) -> ()
      %bb2a_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb2a_40 = "braid.and"(%bb2a_16, %bb2a_39) : (i64, i64) -> i64
      "braid.setf"(%bb2a_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb2e] : () -> ()
    ^bb2e:  // 0x40112e
      %bb2e_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb2e_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2e_0 = "braid.eq"(%bb2e_1, %bb2e_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb2e_0)[^bb20, ^bb30] : (i64) -> ()
    ^bb30:  // 0x401130
      %bb30_0 = "braid.const"() {value = 16 : i64} : () -> i64
      "braid.set"(%bb30_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb35] : () -> ()
    ^bb35:  // 0x401135
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x401140
      %bb40_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb40_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb40_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb40_5 = "braid.mul"(%bb40_3, %bb40_4) : (i64, i64) -> i64
      %bb40_6 = "braid.add"(%bb40_2, %bb40_5) : (i64, i64) -> i64
      %bb40_7 = "braid.const"() {value = -104 : i64} : () -> i64
      %bb40_1 = "braid.add"(%bb40_6, %bb40_7) : (i64, i64) -> i64
      %bb40_0 = "braid.load"(%bb40_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb40_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x401144
      %bb44_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb44_0 = "braid.zext"(%bb44_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb44_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb46] : () -> ()
    ^bb46:  // 0x401146
      %bb46_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb46_0 = "braid.zext"(%bb46_1) {bits = 32 : i64} : (i64) -> i64
      %bb46_12 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb46_13 = "braid.shl"(%bb46_0, %bb46_12) : (i64, i64) -> i64
      %bb46_14 = "braid.const"() {value = 17 : i64} : () -> i64
      %bb46_15 = "braid.lshr"(%bb46_0, %bb46_14) : (i64, i64) -> i64
      %bb46_16 = "braid.or"(%bb46_13, %bb46_15) : (i64, i64) -> i64
      %bb46_17 = "braid.zext"(%bb46_16) {bits = 32 : i64} : (i64) -> i64
      %bb46_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb46_19 = "braid.and"(%bb46_17, %bb46_18) : (i64, i64) -> i64
      "braid.setf"(%bb46_19) {flag = "cf"} : (i64) -> ()
      %bb46_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb46_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb46_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb49] : () -> ()
    ^bb49:  // 0x401149
      %bb49_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb49_0 = "braid.zext"(%bb49_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb49_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb4b] : () -> ()
    ^bb4b:  // 0x40114b
      %bb4b_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb4b_0 = "braid.zext"(%bb4b_1) {bits = 32 : i64} : (i64) -> i64
      %bb4b_12 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb4b_13 = "braid.shl"(%bb4b_0, %bb4b_12) : (i64, i64) -> i64
      %bb4b_14 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb4b_15 = "braid.lshr"(%bb4b_0, %bb4b_14) : (i64, i64) -> i64
      %bb4b_16 = "braid.or"(%bb4b_13, %bb4b_15) : (i64, i64) -> i64
      %bb4b_17 = "braid.zext"(%bb4b_16) {bits = 32 : i64} : (i64) -> i64
      %bb4b_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4b_19 = "braid.and"(%bb4b_17, %bb4b_18) : (i64, i64) -> i64
      "braid.setf"(%bb4b_19) {flag = "cf"} : (i64) -> ()
      %bb4b_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb4b_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb4b_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb4e] : () -> ()
    ^bb4e:  // 0x40114e
      %bb4e_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb4e_0 = "braid.zext"(%bb4e_1) {bits = 32 : i64} : (i64) -> i64
      %bb4e_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb4e_8 = "braid.zext"(%bb4e_9) {bits = 32 : i64} : (i64) -> i64
      %bb4e_16 = "braid.xor"(%bb4e_0, %bb4e_8) : (i64, i64) -> i64
      %bb4e_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb4e_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb4e_17) {flag = "of"} : (i64) -> ()
      %bb4e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb4e_24) {flag = "af"} : (i64) -> ()
      %bb4e_32 = "braid.zext"(%bb4e_16) {bits = 8 : i64} : (i64) -> i64
      %bb4e_33 = "braid.popcnt"(%bb4e_32) : (i64) -> i64
      %bb4e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4e_35 = "braid.and"(%bb4e_33, %bb4e_34) : (i64, i64) -> i64
      %bb4e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4e_37 = "braid.eq"(%bb4e_35, %bb4e_36) : (i64, i64) -> i64
      "braid.setf"(%bb4e_37) {flag = "pf"} : (i64) -> ()
      %bb4e_38 = "braid.eq"(%bb4e_16, %bb4e_36) : (i64, i64) -> i64
      "braid.setf"(%bb4e_38) {flag = "zf"} : (i64) -> ()
      %bb4e_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb4e_40 = "braid.and"(%bb4e_16, %bb4e_39) : (i64, i64) -> i64
      "braid.setf"(%bb4e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb4e_16) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x401150
      %bb50_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb50_0 = "braid.zext"(%bb50_1) {bits = 32 : i64} : (i64) -> i64
      %bb50_8 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb50_9 = "braid.lshr"(%bb50_0, %bb50_8) : (i64, i64) -> i64
      %bb50_11 = "braid.const"() {value = 9 : i64} : () -> i64
      %bb50_12 = "braid.lshr"(%bb50_0, %bb50_11) : (i64, i64) -> i64
      %bb50_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb50_14 = "braid.and"(%bb50_12, %bb50_13) : (i64, i64) -> i64
      "braid.setf"(%bb50_14) {flag = "cf"} : (i64) -> ()
      %bb50_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb50_17) {flag = "of"} : (i64) -> ()
      %bb50_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb50_24) {flag = "af"} : (i64) -> ()
      %bb50_32 = "braid.zext"(%bb50_9) {bits = 8 : i64} : (i64) -> i64
      %bb50_33 = "braid.popcnt"(%bb50_32) : (i64) -> i64
      %bb50_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb50_35 = "braid.and"(%bb50_33, %bb50_34) : (i64, i64) -> i64
      %bb50_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb50_37 = "braid.eq"(%bb50_35, %bb50_36) : (i64, i64) -> i64
      "braid.setf"(%bb50_37) {flag = "pf"} : (i64) -> ()
      %bb50_38 = "braid.eq"(%bb50_9, %bb50_36) : (i64, i64) -> i64
      "braid.setf"(%bb50_38) {flag = "zf"} : (i64) -> ()
      %bb50_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb50_40 = "braid.and"(%bb50_9, %bb50_39) : (i64, i64) -> i64
      "braid.setf"(%bb50_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb50_9) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb53] : () -> ()
    ^bb53:  // 0x401153
      %bb53_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb53_0 = "braid.zext"(%bb53_1) {bits = 32 : i64} : (i64) -> i64
      %bb53_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb53_8 = "braid.zext"(%bb53_9) {bits = 32 : i64} : (i64) -> i64
      %bb53_16 = "braid.xor"(%bb53_0, %bb53_8) : (i64, i64) -> i64
      %bb53_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb53_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb53_17) {flag = "of"} : (i64) -> ()
      %bb53_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb53_24) {flag = "af"} : (i64) -> ()
      %bb53_32 = "braid.zext"(%bb53_16) {bits = 8 : i64} : (i64) -> i64
      %bb53_33 = "braid.popcnt"(%bb53_32) : (i64) -> i64
      %bb53_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb53_35 = "braid.and"(%bb53_33, %bb53_34) : (i64, i64) -> i64
      %bb53_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb53_37 = "braid.eq"(%bb53_35, %bb53_36) : (i64, i64) -> i64
      "braid.setf"(%bb53_37) {flag = "pf"} : (i64) -> ()
      %bb53_38 = "braid.eq"(%bb53_16, %bb53_36) : (i64, i64) -> i64
      "braid.setf"(%bb53_38) {flag = "zf"} : (i64) -> ()
      %bb53_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb53_40 = "braid.and"(%bb53_16, %bb53_39) : (i64, i64) -> i64
      "braid.setf"(%bb53_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb53_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb55] : () -> ()
    ^bb55:  // 0x401155
      %bb55_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb55_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb55_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb55_5 = "braid.mul"(%bb55_3, %bb55_4) : (i64, i64) -> i64
      %bb55_6 = "braid.add"(%bb55_2, %bb55_5) : (i64, i64) -> i64
      %bb55_7 = "braid.const"() {value = -124 : i64} : () -> i64
      %bb55_1 = "braid.add"(%bb55_6, %bb55_7) : (i64, i64) -> i64
      %bb55_0 = "braid.load"(%bb55_1) {bytes = 4 : i64} : (i64) -> i64
      %bb55_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb55_8 = "braid.zext"(%bb55_9) {bits = 32 : i64} : (i64) -> i64
      %bb55_16 = "braid.add"(%bb55_0, %bb55_8) : (i64, i64) -> i64
      %bb55_17 = "braid.zext"(%bb55_16) {bits = 32 : i64} : (i64) -> i64
      %bb55_18 = "braid.ult"(%bb55_17, %bb55_0) : (i64, i64) -> i64
      "braid.setf"(%bb55_18) {flag = "cf"} : (i64) -> ()
      %bb55_19 = "braid.xor"(%bb55_0, %bb55_17) : (i64, i64) -> i64
      %bb55_20 = "braid.xor"(%bb55_8, %bb55_17) : (i64, i64) -> i64
      %bb55_21 = "braid.and"(%bb55_19, %bb55_20) : (i64, i64) -> i64
      %bb55_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb55_23 = "braid.and"(%bb55_21, %bb55_22) : (i64, i64) -> i64
      "braid.setf"(%bb55_23) {flag = "of"} : (i64) -> ()
      %bb55_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb55_24) {flag = "af"} : (i64) -> ()
      %bb55_32 = "braid.zext"(%bb55_17) {bits = 8 : i64} : (i64) -> i64
      %bb55_33 = "braid.popcnt"(%bb55_32) : (i64) -> i64
      %bb55_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb55_35 = "braid.and"(%bb55_33, %bb55_34) : (i64, i64) -> i64
      %bb55_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb55_37 = "braid.eq"(%bb55_35, %bb55_36) : (i64, i64) -> i64
      "braid.setf"(%bb55_37) {flag = "pf"} : (i64) -> ()
      %bb55_38 = "braid.eq"(%bb55_17, %bb55_36) : (i64, i64) -> i64
      "braid.setf"(%bb55_38) {flag = "zf"} : (i64) -> ()
      %bb55_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb55_40 = "braid.and"(%bb55_17, %bb55_39) : (i64, i64) -> i64
      "braid.setf"(%bb55_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb55_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb59] : () -> ()
    ^bb59:  // 0x401159
      %bb59_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb59_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb59_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb59_5 = "braid.mul"(%bb59_3, %bb59_4) : (i64, i64) -> i64
      %bb59_6 = "braid.add"(%bb59_2, %bb59_5) : (i64, i64) -> i64
      %bb59_7 = "braid.const"() {value = -156 : i64} : () -> i64
      %bb59_1 = "braid.add"(%bb59_6, %bb59_7) : (i64, i64) -> i64
      %bb59_0 = "braid.load"(%bb59_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb59_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x401160
      %bb60_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb60_0 = "braid.zext"(%bb60_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb60_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb62] : () -> ()
    ^bb62:  // 0x401162
      %bb62_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb62_0 = "braid.zext"(%bb62_1) {bits = 32 : i64} : (i64) -> i64
      %bb62_12 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb62_13 = "braid.shl"(%bb62_0, %bb62_12) : (i64, i64) -> i64
      %bb62_14 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb62_15 = "braid.lshr"(%bb62_0, %bb62_14) : (i64, i64) -> i64
      %bb62_16 = "braid.or"(%bb62_13, %bb62_15) : (i64, i64) -> i64
      %bb62_17 = "braid.zext"(%bb62_16) {bits = 32 : i64} : (i64) -> i64
      %bb62_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb62_19 = "braid.and"(%bb62_17, %bb62_18) : (i64, i64) -> i64
      "braid.setf"(%bb62_19) {flag = "cf"} : (i64) -> ()
      %bb62_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb62_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb62_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb65] : () -> ()
    ^bb65:  // 0x401165
      %bb65_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb65_0 = "braid.zext"(%bb65_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb65_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x401168
      %bb68_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb68_0 = "braid.zext"(%bb68_1) {bits = 32 : i64} : (i64) -> i64
      %bb68_12 = "braid.const"() {value = 14 : i64} : () -> i64
      %bb68_13 = "braid.shl"(%bb68_0, %bb68_12) : (i64, i64) -> i64
      %bb68_14 = "braid.const"() {value = 18 : i64} : () -> i64
      %bb68_15 = "braid.lshr"(%bb68_0, %bb68_14) : (i64, i64) -> i64
      %bb68_16 = "braid.or"(%bb68_13, %bb68_15) : (i64, i64) -> i64
      %bb68_17 = "braid.zext"(%bb68_16) {bits = 32 : i64} : (i64) -> i64
      %bb68_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb68_19 = "braid.and"(%bb68_17, %bb68_18) : (i64, i64) -> i64
      "braid.setf"(%bb68_19) {flag = "cf"} : (i64) -> ()
      %bb68_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb68_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb68_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x40116c
      %bb6c_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb6c_0 = "braid.zext"(%bb6c_1) {bits = 32 : i64} : (i64) -> i64
      %bb6c_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb6c_8 = "braid.zext"(%bb6c_9) {bits = 32 : i64} : (i64) -> i64
      %bb6c_16 = "braid.xor"(%bb6c_0, %bb6c_8) : (i64, i64) -> i64
      %bb6c_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb6c_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb6c_17) {flag = "of"} : (i64) -> ()
      %bb6c_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb6c_24) {flag = "af"} : (i64) -> ()
      %bb6c_32 = "braid.zext"(%bb6c_16) {bits = 8 : i64} : (i64) -> i64
      %bb6c_33 = "braid.popcnt"(%bb6c_32) : (i64) -> i64
      %bb6c_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6c_35 = "braid.and"(%bb6c_33, %bb6c_34) : (i64, i64) -> i64
      %bb6c_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6c_37 = "braid.eq"(%bb6c_35, %bb6c_36) : (i64, i64) -> i64
      "braid.setf"(%bb6c_37) {flag = "pf"} : (i64) -> ()
      %bb6c_38 = "braid.eq"(%bb6c_16, %bb6c_36) : (i64, i64) -> i64
      "braid.setf"(%bb6c_38) {flag = "zf"} : (i64) -> ()
      %bb6c_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb6c_40 = "braid.and"(%bb6c_16, %bb6c_39) : (i64, i64) -> i64
      "braid.setf"(%bb6c_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb6c_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb6f] : () -> ()
    ^bb6f:  // 0x40116f
      %bb6f_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb6f_0 = "braid.zext"(%bb6f_1) {bits = 32 : i64} : (i64) -> i64
      %bb6f_8 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb6f_9 = "braid.lshr"(%bb6f_0, %bb6f_8) : (i64, i64) -> i64
      %bb6f_11 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb6f_12 = "braid.lshr"(%bb6f_0, %bb6f_11) : (i64, i64) -> i64
      %bb6f_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6f_14 = "braid.and"(%bb6f_12, %bb6f_13) : (i64, i64) -> i64
      "braid.setf"(%bb6f_14) {flag = "cf"} : (i64) -> ()
      %bb6f_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb6f_17) {flag = "of"} : (i64) -> ()
      %bb6f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb6f_24) {flag = "af"} : (i64) -> ()
      %bb6f_32 = "braid.zext"(%bb6f_9) {bits = 8 : i64} : (i64) -> i64
      %bb6f_33 = "braid.popcnt"(%bb6f_32) : (i64) -> i64
      %bb6f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6f_35 = "braid.and"(%bb6f_33, %bb6f_34) : (i64, i64) -> i64
      %bb6f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6f_37 = "braid.eq"(%bb6f_35, %bb6f_36) : (i64, i64) -> i64
      "braid.setf"(%bb6f_37) {flag = "pf"} : (i64) -> ()
      %bb6f_38 = "braid.eq"(%bb6f_9, %bb6f_36) : (i64, i64) -> i64
      "braid.setf"(%bb6f_38) {flag = "zf"} : (i64) -> ()
      %bb6f_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb6f_40 = "braid.and"(%bb6f_9, %bb6f_39) : (i64, i64) -> i64
      "braid.setf"(%bb6f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb6f_9) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb72] : () -> ()
    ^bb72:  // 0x401172
      %bb72_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb72_0 = "braid.zext"(%bb72_1) {bits = 32 : i64} : (i64) -> i64
      %bb72_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bb72_8 = "braid.zext"(%bb72_9) {bits = 32 : i64} : (i64) -> i64
      %bb72_16 = "braid.xor"(%bb72_0, %bb72_8) : (i64, i64) -> i64
      %bb72_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb72_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb72_17) {flag = "of"} : (i64) -> ()
      %bb72_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb72_24) {flag = "af"} : (i64) -> ()
      %bb72_32 = "braid.zext"(%bb72_16) {bits = 8 : i64} : (i64) -> i64
      %bb72_33 = "braid.popcnt"(%bb72_32) : (i64) -> i64
      %bb72_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb72_35 = "braid.and"(%bb72_33, %bb72_34) : (i64, i64) -> i64
      %bb72_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb72_37 = "braid.eq"(%bb72_35, %bb72_36) : (i64, i64) -> i64
      "braid.setf"(%bb72_37) {flag = "pf"} : (i64) -> ()
      %bb72_38 = "braid.eq"(%bb72_16, %bb72_36) : (i64, i64) -> i64
      "braid.setf"(%bb72_38) {flag = "zf"} : (i64) -> ()
      %bb72_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb72_40 = "braid.and"(%bb72_16, %bb72_39) : (i64, i64) -> i64
      "braid.setf"(%bb72_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb72_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb75] : () -> ()
    ^bb75:  // 0x401175
      %bb75_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb75_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb75_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb75_5 = "braid.mul"(%bb75_3, %bb75_4) : (i64, i64) -> i64
      %bb75_6 = "braid.add"(%bb75_2, %bb75_5) : (i64, i64) -> i64
      %bb75_7 = "braid.const"() {value = -160 : i64} : () -> i64
      %bb75_1 = "braid.add"(%bb75_6, %bb75_7) : (i64, i64) -> i64
      %bb75_0 = "braid.load"(%bb75_1) {bytes = 4 : i64} : (i64) -> i64
      %bb75_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb75_8 = "braid.zext"(%bb75_9) {bits = 32 : i64} : (i64) -> i64
      %bb75_16 = "braid.add"(%bb75_0, %bb75_8) : (i64, i64) -> i64
      %bb75_17 = "braid.zext"(%bb75_16) {bits = 32 : i64} : (i64) -> i64
      %bb75_18 = "braid.ult"(%bb75_17, %bb75_0) : (i64, i64) -> i64
      "braid.setf"(%bb75_18) {flag = "cf"} : (i64) -> ()
      %bb75_19 = "braid.xor"(%bb75_0, %bb75_17) : (i64, i64) -> i64
      %bb75_20 = "braid.xor"(%bb75_8, %bb75_17) : (i64, i64) -> i64
      %bb75_21 = "braid.and"(%bb75_19, %bb75_20) : (i64, i64) -> i64
      %bb75_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb75_23 = "braid.and"(%bb75_21, %bb75_22) : (i64, i64) -> i64
      "braid.setf"(%bb75_23) {flag = "of"} : (i64) -> ()
      %bb75_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb75_24) {flag = "af"} : (i64) -> ()
      %bb75_32 = "braid.zext"(%bb75_17) {bits = 8 : i64} : (i64) -> i64
      %bb75_33 = "braid.popcnt"(%bb75_32) : (i64) -> i64
      %bb75_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb75_35 = "braid.and"(%bb75_33, %bb75_34) : (i64, i64) -> i64
      %bb75_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb75_37 = "braid.eq"(%bb75_35, %bb75_36) : (i64, i64) -> i64
      "braid.setf"(%bb75_37) {flag = "pf"} : (i64) -> ()
      %bb75_38 = "braid.eq"(%bb75_17, %bb75_36) : (i64, i64) -> i64
      "braid.setf"(%bb75_38) {flag = "zf"} : (i64) -> ()
      %bb75_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb75_40 = "braid.and"(%bb75_17, %bb75_39) : (i64, i64) -> i64
      "braid.setf"(%bb75_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb75_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x40117c
      %bb7c_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb7c_0 = "braid.zext"(%bb7c_1) {bits = 32 : i64} : (i64) -> i64
      %bb7c_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb7c_8 = "braid.zext"(%bb7c_9) {bits = 32 : i64} : (i64) -> i64
      %bb7c_16 = "braid.add"(%bb7c_0, %bb7c_8) : (i64, i64) -> i64
      %bb7c_17 = "braid.zext"(%bb7c_16) {bits = 32 : i64} : (i64) -> i64
      %bb7c_18 = "braid.ult"(%bb7c_17, %bb7c_0) : (i64, i64) -> i64
      "braid.setf"(%bb7c_18) {flag = "cf"} : (i64) -> ()
      %bb7c_19 = "braid.xor"(%bb7c_0, %bb7c_17) : (i64, i64) -> i64
      %bb7c_20 = "braid.xor"(%bb7c_8, %bb7c_17) : (i64, i64) -> i64
      %bb7c_21 = "braid.and"(%bb7c_19, %bb7c_20) : (i64, i64) -> i64
      %bb7c_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb7c_23 = "braid.and"(%bb7c_21, %bb7c_22) : (i64, i64) -> i64
      "braid.setf"(%bb7c_23) {flag = "of"} : (i64) -> ()
      %bb7c_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb7c_24) {flag = "af"} : (i64) -> ()
      %bb7c_32 = "braid.zext"(%bb7c_17) {bits = 8 : i64} : (i64) -> i64
      %bb7c_33 = "braid.popcnt"(%bb7c_32) : (i64) -> i64
      %bb7c_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb7c_35 = "braid.and"(%bb7c_33, %bb7c_34) : (i64, i64) -> i64
      %bb7c_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7c_37 = "braid.eq"(%bb7c_35, %bb7c_36) : (i64, i64) -> i64
      "braid.setf"(%bb7c_37) {flag = "pf"} : (i64) -> ()
      %bb7c_38 = "braid.eq"(%bb7c_17, %bb7c_36) : (i64, i64) -> i64
      "braid.setf"(%bb7c_38) {flag = "zf"} : (i64) -> ()
      %bb7c_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb7c_40 = "braid.and"(%bb7c_17, %bb7c_39) : (i64, i64) -> i64
      "braid.setf"(%bb7c_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb7c_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb7e] : () -> ()
    ^bb7e:  // 0x40117e
      %bb7e_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb7e_0 = "braid.zext"(%bb7e_1) {bits = 32 : i64} : (i64) -> i64
      %bb7e_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb7e_10 = "braid.get"() {reg = "rax"} : () -> i64
      %bb7e_11 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb7e_12 = "braid.mul"(%bb7e_10, %bb7e_11) : (i64, i64) -> i64
      %bb7e_13 = "braid.add"(%bb7e_9, %bb7e_12) : (i64, i64) -> i64
      %bb7e_14 = "braid.const"() {value = -96 : i64} : () -> i64
      %bb7e_8 = "braid.add"(%bb7e_13, %bb7e_14) : (i64, i64) -> i64
      "braid.store"(%bb7e_8, %bb7e_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb82] : () -> ()
    ^bb82:  // 0x401182
      %bb82_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb82_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb82_16 = "braid.add"(%bb82_0, %bb82_8) : (i64, i64) -> i64
      %bb82_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb82_20 = "braid.eq"(%bb82_16, %bb82_19) : (i64, i64) -> i64
      "braid.setf"(%bb82_20) {flag = "of"} : (i64) -> ()
      %bb82_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb82_24) {flag = "af"} : (i64) -> ()
      %bb82_32 = "braid.zext"(%bb82_16) {bits = 8 : i64} : (i64) -> i64
      %bb82_33 = "braid.popcnt"(%bb82_32) : (i64) -> i64
      %bb82_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb82_35 = "braid.and"(%bb82_33, %bb82_34) : (i64, i64) -> i64
      %bb82_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb82_37 = "braid.eq"(%bb82_35, %bb82_36) : (i64, i64) -> i64
      "braid.setf"(%bb82_37) {flag = "pf"} : (i64) -> ()
      %bb82_38 = "braid.eq"(%bb82_16, %bb82_36) : (i64, i64) -> i64
      "braid.setf"(%bb82_38) {flag = "zf"} : (i64) -> ()
      %bb82_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb82_40 = "braid.and"(%bb82_16, %bb82_39) : (i64, i64) -> i64
      "braid.setf"(%bb82_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb82_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb85] : () -> ()
    ^bb85:  // 0x401185
      %bb85_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb85_8 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb85_16 = "braid.sub"(%bb85_0, %bb85_8) : (i64, i64) -> i64
      %bb85_18 = "braid.ult"(%bb85_0, %bb85_8) : (i64, i64) -> i64
      "braid.setf"(%bb85_18) {flag = "cf"} : (i64) -> ()
      %bb85_19 = "braid.xor"(%bb85_0, %bb85_8) : (i64, i64) -> i64
      %bb85_20 = "braid.xor"(%bb85_0, %bb85_16) : (i64, i64) -> i64
      %bb85_21 = "braid.and"(%bb85_19, %bb85_20) : (i64, i64) -> i64
      %bb85_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb85_23 = "braid.and"(%bb85_21, %bb85_22) : (i64, i64) -> i64
      "braid.setf"(%bb85_23) {flag = "of"} : (i64) -> ()
      %bb85_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb85_24) {flag = "af"} : (i64) -> ()
      %bb85_32 = "braid.zext"(%bb85_16) {bits = 8 : i64} : (i64) -> i64
      %bb85_33 = "braid.popcnt"(%bb85_32) : (i64) -> i64
      %bb85_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb85_35 = "braid.and"(%bb85_33, %bb85_34) : (i64, i64) -> i64
      %bb85_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb85_37 = "braid.eq"(%bb85_35, %bb85_36) : (i64, i64) -> i64
      "braid.setf"(%bb85_37) {flag = "pf"} : (i64) -> ()
      %bb85_38 = "braid.eq"(%bb85_16, %bb85_36) : (i64, i64) -> i64
      "braid.setf"(%bb85_38) {flag = "zf"} : (i64) -> ()
      %bb85_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb85_40 = "braid.and"(%bb85_16, %bb85_39) : (i64, i64) -> i64
      "braid.setf"(%bb85_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb89] : () -> ()
    ^bb89:  // 0x401189
      %bb89_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb89_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb89_0 = "braid.eq"(%bb89_1, %bb89_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb89_0)[^bb40, ^bb8b] : (i64) -> ()
    ^bb8b:  // 0x40118b
      %bb8b_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb8b_0 = "braid.zext"(%bb8b_1) {bits = 32 : i64} : (i64) -> i64
      %bb8b_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb8b_8 = "braid.zext"(%bb8b_9) {bits = 32 : i64} : (i64) -> i64
      %bb8b_16 = "braid.xor"(%bb8b_0, %bb8b_8) : (i64, i64) -> i64
      %bb8b_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb8b_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb8b_17) {flag = "of"} : (i64) -> ()
      %bb8b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb8b_24) {flag = "af"} : (i64) -> ()
      %bb8b_32 = "braid.zext"(%bb8b_16) {bits = 8 : i64} : (i64) -> i64
      %bb8b_33 = "braid.popcnt"(%bb8b_32) : (i64) -> i64
      %bb8b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8b_35 = "braid.and"(%bb8b_33, %bb8b_34) : (i64, i64) -> i64
      %bb8b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8b_37 = "braid.eq"(%bb8b_35, %bb8b_36) : (i64, i64) -> i64
      "braid.setf"(%bb8b_37) {flag = "pf"} : (i64) -> ()
      %bb8b_38 = "braid.eq"(%bb8b_16, %bb8b_36) : (i64, i64) -> i64
      "braid.setf"(%bb8b_38) {flag = "zf"} : (i64) -> ()
      %bb8b_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb8b_40 = "braid.and"(%bb8b_16, %bb8b_39) : (i64, i64) -> i64
      "braid.setf"(%bb8b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb8b_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb8d] : () -> ()
    ^bb8d:  // 0x40118d
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x401190
      %bb90_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb90_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb90_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb90_5 = "braid.mul"(%bb90_3, %bb90_4) : (i64, i64) -> i64
      %bb90_6 = "braid.add"(%bb90_2, %bb90_5) : (i64, i64) -> i64
      %bb90_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb90_1 = "braid.add"(%bb90_6, %bb90_7) : (i64, i64) -> i64
      %bb90_0 = "braid.load"(%bb90_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb90_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb93] : () -> ()
    ^bb93:  // 0x401193
      %bb93_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb93_0 = "braid.zext"(%bb93_1) {bits = 32 : i64} : (i64) -> i64
      %bb93_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb93_10 = "braid.get"() {reg = "rax"} : () -> i64
      %bb93_11 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb93_12 = "braid.mul"(%bb93_10, %bb93_11) : (i64, i64) -> i64
      %bb93_13 = "braid.add"(%bb93_9, %bb93_12) : (i64, i64) -> i64
      %bb93_14 = "braid.const"() {value = -128 : i64} : () -> i64
      %bb93_8 = "braid.add"(%bb93_13, %bb93_14) : (i64, i64) -> i64
      "braid.store"(%bb93_8, %bb93_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb97] : () -> ()
    ^bb97:  // 0x401197
      %bb97_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb97_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb97_16 = "braid.add"(%bb97_0, %bb97_8) : (i64, i64) -> i64
      %bb97_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb97_20 = "braid.eq"(%bb97_16, %bb97_19) : (i64, i64) -> i64
      "braid.setf"(%bb97_20) {flag = "of"} : (i64) -> ()
      %bb97_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb97_24) {flag = "af"} : (i64) -> ()
      %bb97_32 = "braid.zext"(%bb97_16) {bits = 8 : i64} : (i64) -> i64
      %bb97_33 = "braid.popcnt"(%bb97_32) : (i64) -> i64
      %bb97_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb97_35 = "braid.and"(%bb97_33, %bb97_34) : (i64, i64) -> i64
      %bb97_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb97_37 = "braid.eq"(%bb97_35, %bb97_36) : (i64, i64) -> i64
      "braid.setf"(%bb97_37) {flag = "pf"} : (i64) -> ()
      %bb97_38 = "braid.eq"(%bb97_16, %bb97_36) : (i64, i64) -> i64
      "braid.setf"(%bb97_38) {flag = "zf"} : (i64) -> ()
      %bb97_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb97_40 = "braid.and"(%bb97_16, %bb97_39) : (i64, i64) -> i64
      "braid.setf"(%bb97_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb97_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb9a] : () -> ()
    ^bb9a:  // 0x40119a
      %bb9a_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb9a_8 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb9a_16 = "braid.sub"(%bb9a_0, %bb9a_8) : (i64, i64) -> i64
      %bb9a_18 = "braid.ult"(%bb9a_0, %bb9a_8) : (i64, i64) -> i64
      "braid.setf"(%bb9a_18) {flag = "cf"} : (i64) -> ()
      %bb9a_19 = "braid.xor"(%bb9a_0, %bb9a_8) : (i64, i64) -> i64
      %bb9a_20 = "braid.xor"(%bb9a_0, %bb9a_16) : (i64, i64) -> i64
      %bb9a_21 = "braid.and"(%bb9a_19, %bb9a_20) : (i64, i64) -> i64
      %bb9a_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb9a_23 = "braid.and"(%bb9a_21, %bb9a_22) : (i64, i64) -> i64
      "braid.setf"(%bb9a_23) {flag = "of"} : (i64) -> ()
      %bb9a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb9a_24) {flag = "af"} : (i64) -> ()
      %bb9a_32 = "braid.zext"(%bb9a_16) {bits = 8 : i64} : (i64) -> i64
      %bb9a_33 = "braid.popcnt"(%bb9a_32) : (i64) -> i64
      %bb9a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb9a_35 = "braid.and"(%bb9a_33, %bb9a_34) : (i64, i64) -> i64
      %bb9a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9a_37 = "braid.eq"(%bb9a_35, %bb9a_36) : (i64, i64) -> i64
      "braid.setf"(%bb9a_37) {flag = "pf"} : (i64) -> ()
      %bb9a_38 = "braid.eq"(%bb9a_16, %bb9a_36) : (i64, i64) -> i64
      "braid.setf"(%bb9a_38) {flag = "zf"} : (i64) -> ()
      %bb9a_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb9a_40 = "braid.and"(%bb9a_16, %bb9a_39) : (i64, i64) -> i64
      "braid.setf"(%bb9a_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb9e] : () -> ()
    ^bb9e:  // 0x40119e
      %bb9e_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb9e_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9e_0 = "braid.eq"(%bb9e_1, %bb9e_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb9e_0)[^bb90, ^bba0] : (i64) -> ()
    ^bba0:  // 0x4011a0
      %bba0_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba0_3 = "braid.const"() {value = -128 : i64} : () -> i64
      %bba0_1 = "braid.add"(%bba0_2, %bba0_3) : (i64, i64) -> i64
      %bba0_0 = "braid.load"(%bba0_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bba0_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bba4] : () -> ()
    ^bba4:  // 0x4011a4
      %bba4_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba4_3 = "braid.const"() {value = -124 : i64} : () -> i64
      %bba4_1 = "braid.add"(%bba4_2, %bba4_3) : (i64, i64) -> i64
      %bba4_0 = "braid.load"(%bba4_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bba4_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x4011a8
      %bba8_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba8_3 = "braid.const"() {value = -120 : i64} : () -> i64
      %bba8_1 = "braid.add"(%bba8_2, %bba8_3) : (i64, i64) -> i64
      %bba8_0 = "braid.load"(%bba8_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bba8_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x4011ac
      %bbac_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbac_3 = "braid.const"() {value = -116 : i64} : () -> i64
      %bbac_1 = "braid.add"(%bbac_2, %bbac_3) : (i64, i64) -> i64
      %bbac_0 = "braid.load"(%bbac_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbac_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x4011b0
      %bbb0_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbb0_3 = "braid.const"() {value = -112 : i64} : () -> i64
      %bbb0_1 = "braid.add"(%bbb0_2, %bbb0_3) : (i64, i64) -> i64
      %bbb0_0 = "braid.load"(%bbb0_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbb0_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x4011b4
      %bbb4_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbb4_3 = "braid.const"() {value = -108 : i64} : () -> i64
      %bbb4_1 = "braid.add"(%bbb4_2, %bbb4_3) : (i64, i64) -> i64
      %bbb4_0 = "braid.load"(%bbb4_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbb4_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bbb9] : () -> ()
    ^bbb9:  // 0x4011b9
      %bbb9_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbb9_3 = "braid.const"() {value = -104 : i64} : () -> i64
      %bbb9_1 = "braid.add"(%bbb9_2, %bbb9_3) : (i64, i64) -> i64
      %bbb9_0 = "braid.load"(%bbb9_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbb9_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bbbe] : () -> ()
    ^bbbe:  // 0x4011be
      %bbbe_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbbe_3 = "braid.const"() {value = -100 : i64} : () -> i64
      %bbbe_1 = "braid.add"(%bbbe_2, %bbbe_3) : (i64, i64) -> i64
      %bbbe_0 = "braid.load"(%bbbe_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbbe_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bbc3] : () -> ()
    ^bbc3:  // 0x4011c3
      %bbc3_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bbc3_0 = "braid.zext"(%bbc3_1) {bits = 32 : i64} : (i64) -> i64
      %bbc3_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bbc3_8 = "braid.zext"(%bbc3_9) {bits = 32 : i64} : (i64) -> i64
      %bbc3_16 = "braid.xor"(%bbc3_0, %bbc3_8) : (i64, i64) -> i64
      %bbc3_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbc3_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbc3_17) {flag = "of"} : (i64) -> ()
      %bbc3_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc3_24) {flag = "af"} : (i64) -> ()
      %bbc3_32 = "braid.zext"(%bbc3_16) {bits = 8 : i64} : (i64) -> i64
      %bbc3_33 = "braid.popcnt"(%bbc3_32) : (i64) -> i64
      %bbc3_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc3_35 = "braid.and"(%bbc3_33, %bbc3_34) : (i64, i64) -> i64
      %bbc3_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc3_37 = "braid.eq"(%bbc3_35, %bbc3_36) : (i64, i64) -> i64
      "braid.setf"(%bbc3_37) {flag = "pf"} : (i64) -> ()
      %bbc3_38 = "braid.eq"(%bbc3_16, %bbc3_36) : (i64, i64) -> i64
      "braid.setf"(%bbc3_38) {flag = "zf"} : (i64) -> ()
      %bbc3_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbc3_40 = "braid.and"(%bbc3_16, %bbc3_39) : (i64, i64) -> i64
      "braid.setf"(%bbc3_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbc3_16) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bbc6] : () -> ()
    ^bbc6:  // 0x4011c6
      %bbc6_0 = "braid.const"() {value = 4203184 : i64} : () -> i64
      "braid.set"(%bbc6_0) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bbcd] : () -> ()
    ^bbcd:  // 0x4011cd
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x4011d0
      %bbd0_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bbd0_0 = "braid.zext"(%bbd0_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd0_0) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bbd3] : () -> ()
    ^bbd3:  // 0x4011d3
      %bbd3_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bbd3_0 = "braid.zext"(%bbd3_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd3_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bbd6] : () -> ()
    ^bbd6:  // 0x4011d6
      %bbd6_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbd6_0 = "braid.zext"(%bbd6_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd6_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bbd9] : () -> ()
    ^bbd9:  // 0x4011d9
      %bbd9_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbd9_0 = "braid.zext"(%bbd9_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbd9_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x4011dc
      %bbdc_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbdc_0 = "braid.zext"(%bbdc_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbdc_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bbde] : () -> ()
    ^bbde:  // 0x4011de
      %bbde_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbde_0 = "braid.zext"(%bbde_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbde_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bbe0] : () -> ()
    ^bbe0:  // 0x4011e0
      %bbe0_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbe0_0 = "braid.zext"(%bbe0_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbe0_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbe2] : () -> ()
    ^bbe2:  // 0x4011e2
      %bbe2_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bbe2_0 = "braid.zext"(%bbe2_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbe2_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x4011e4
      %bbe4_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbe4_0 = "braid.zext"(%bbe4_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbe4_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bbe7] : () -> ()
    ^bbe7:  // 0x4011e7
      %bbe7_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bbe7_0 = "braid.zext"(%bbe7_1) {bits = 32 : i64} : (i64) -> i64
      %bbe7_12 = "braid.const"() {value = 26 : i64} : () -> i64
      %bbe7_13 = "braid.shl"(%bbe7_0, %bbe7_12) : (i64, i64) -> i64
      %bbe7_14 = "braid.const"() {value = 6 : i64} : () -> i64
      %bbe7_15 = "braid.lshr"(%bbe7_0, %bbe7_14) : (i64, i64) -> i64
      %bbe7_16 = "braid.or"(%bbe7_13, %bbe7_15) : (i64, i64) -> i64
      %bbe7_17 = "braid.zext"(%bbe7_16) {bits = 32 : i64} : (i64) -> i64
      %bbe7_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbe7_19 = "braid.and"(%bbe7_17, %bbe7_18) : (i64, i64) -> i64
      "braid.setf"(%bbe7_19) {flag = "cf"} : (i64) -> ()
      %bbe7_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbe7_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbe7_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bbea] : () -> ()
    ^bbea:  // 0x4011ea
      %bbea_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbea_3 = "braid.get"() {reg = "r11"} : () -> i64
      %bbea_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbea_5 = "braid.mul"(%bbea_3, %bbea_4) : (i64, i64) -> i64
      %bbea_6 = "braid.add"(%bbea_2, %bbea_5) : (i64, i64) -> i64
      %bbea_7 = "braid.const"() {value = -96 : i64} : () -> i64
      %bbea_1 = "braid.add"(%bbea_6, %bbea_7) : (i64, i64) -> i64
      %bbea_0 = "braid.load"(%bbea_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbea_0) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bbef] : () -> ()
    ^bbef:  // 0x4011ef
      %bbef_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbef_0 = "braid.zext"(%bbef_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbef_0) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bbf2] : () -> ()
    ^bbf2:  // 0x4011f2
      %bbf2_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bbf2_0 = "braid.zext"(%bbf2_1) {bits = 32 : i64} : (i64) -> i64
      %bbf2_12 = "braid.const"() {value = 21 : i64} : () -> i64
      %bbf2_13 = "braid.shl"(%bbf2_0, %bbf2_12) : (i64, i64) -> i64
      %bbf2_14 = "braid.const"() {value = 11 : i64} : () -> i64
      %bbf2_15 = "braid.lshr"(%bbf2_0, %bbf2_14) : (i64, i64) -> i64
      %bbf2_16 = "braid.or"(%bbf2_13, %bbf2_15) : (i64, i64) -> i64
      %bbf2_17 = "braid.zext"(%bbf2_16) {bits = 32 : i64} : (i64) -> i64
      %bbf2_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf2_19 = "braid.and"(%bbf2_17, %bbf2_18) : (i64, i64) -> i64
      "braid.setf"(%bbf2_19) {flag = "cf"} : (i64) -> ()
      %bbf2_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbf2_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbf2_17) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bbf6] : () -> ()
    ^bbf6:  // 0x4011f6
      %bbf6_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bbf6_0 = "braid.zext"(%bbf6_1) {bits = 32 : i64} : (i64) -> i64
      %bbf6_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bbf6_8 = "braid.zext"(%bbf6_9) {bits = 32 : i64} : (i64) -> i64
      %bbf6_16 = "braid.xor"(%bbf6_0, %bbf6_8) : (i64, i64) -> i64
      %bbf6_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbf6_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbf6_17) {flag = "of"} : (i64) -> ()
      %bbf6_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbf6_24) {flag = "af"} : (i64) -> ()
      %bbf6_32 = "braid.zext"(%bbf6_16) {bits = 8 : i64} : (i64) -> i64
      %bbf6_33 = "braid.popcnt"(%bbf6_32) : (i64) -> i64
      %bbf6_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf6_35 = "braid.and"(%bbf6_33, %bbf6_34) : (i64, i64) -> i64
      %bbf6_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf6_37 = "braid.eq"(%bbf6_35, %bbf6_36) : (i64, i64) -> i64
      "braid.setf"(%bbf6_37) {flag = "pf"} : (i64) -> ()
      %bbf6_38 = "braid.eq"(%bbf6_16, %bbf6_36) : (i64, i64) -> i64
      "braid.setf"(%bbf6_38) {flag = "zf"} : (i64) -> ()
      %bbf6_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbf6_40 = "braid.and"(%bbf6_16, %bbf6_39) : (i64, i64) -> i64
      "braid.setf"(%bbf6_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbf6_16) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bbf9] : () -> ()
    ^bbf9:  // 0x4011f9
      %bbf9_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbf9_0 = "braid.zext"(%bbf9_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbf9_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bbfc] : () -> ()
    ^bbfc:  // 0x4011fc
      %bbfc_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bbfc_0 = "braid.zext"(%bbfc_1) {bits = 32 : i64} : (i64) -> i64
      %bbfc_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbfc_13 = "braid.shl"(%bbfc_0, %bbfc_12) : (i64, i64) -> i64
      %bbfc_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbfc_15 = "braid.lshr"(%bbfc_0, %bbfc_14) : (i64, i64) -> i64
      %bbfc_16 = "braid.or"(%bbfc_13, %bbfc_15) : (i64, i64) -> i64
      %bbfc_17 = "braid.zext"(%bbfc_16) {bits = 32 : i64} : (i64) -> i64
      %bbfc_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbfc_19 = "braid.and"(%bbfc_17, %bbfc_18) : (i64, i64) -> i64
      "braid.setf"(%bbfc_19) {flag = "cf"} : (i64) -> ()
      %bbfc_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbfc_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbfc_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bbff] : () -> ()
    ^bbff:  // 0x4011ff
      %bbff_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bbff_0 = "braid.zext"(%bbff_1) {bits = 32 : i64} : (i64) -> i64
      %bbff_9 = "braid.get"() {reg = "r12"} : () -> i64
      %bbff_8 = "braid.zext"(%bbff_9) {bits = 32 : i64} : (i64) -> i64
      %bbff_16 = "braid.xor"(%bbff_0, %bbff_8) : (i64, i64) -> i64
      %bbff_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbff_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbff_17) {flag = "of"} : (i64) -> ()
      %bbff_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbff_24) {flag = "af"} : (i64) -> ()
      %bbff_32 = "braid.zext"(%bbff_16) {bits = 8 : i64} : (i64) -> i64
      %bbff_33 = "braid.popcnt"(%bbff_32) : (i64) -> i64
      %bbff_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbff_35 = "braid.and"(%bbff_33, %bbff_34) : (i64, i64) -> i64
      %bbff_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbff_37 = "braid.eq"(%bbff_35, %bbff_36) : (i64, i64) -> i64
      "braid.setf"(%bbff_37) {flag = "pf"} : (i64) -> ()
      %bbff_38 = "braid.eq"(%bbff_16, %bbff_36) : (i64, i64) -> i64
      "braid.setf"(%bbff_38) {flag = "zf"} : (i64) -> ()
      %bbff_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbff_40 = "braid.and"(%bbff_16, %bbff_39) : (i64, i64) -> i64
      "braid.setf"(%bbff_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbff_16) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb102] : () -> ()
    ^bb102:  // 0x401202
      %bb102_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb102_0 = "braid.zext"(%bb102_1) {bits = 32 : i64} : (i64) -> i64
      %bb102_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb102_8 = "braid.zext"(%bb102_9) {bits = 32 : i64} : (i64) -> i64
      %bb102_16 = "braid.add"(%bb102_0, %bb102_8) : (i64, i64) -> i64
      %bb102_17 = "braid.zext"(%bb102_16) {bits = 32 : i64} : (i64) -> i64
      %bb102_18 = "braid.ult"(%bb102_17, %bb102_0) : (i64, i64) -> i64
      "braid.setf"(%bb102_18) {flag = "cf"} : (i64) -> ()
      %bb102_19 = "braid.xor"(%bb102_0, %bb102_17) : (i64, i64) -> i64
      %bb102_20 = "braid.xor"(%bb102_8, %bb102_17) : (i64, i64) -> i64
      %bb102_21 = "braid.and"(%bb102_19, %bb102_20) : (i64, i64) -> i64
      %bb102_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb102_23 = "braid.and"(%bb102_21, %bb102_22) : (i64, i64) -> i64
      "braid.setf"(%bb102_23) {flag = "of"} : (i64) -> ()
      %bb102_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb102_24) {flag = "af"} : (i64) -> ()
      %bb102_32 = "braid.zext"(%bb102_17) {bits = 8 : i64} : (i64) -> i64
      %bb102_33 = "braid.popcnt"(%bb102_32) : (i64) -> i64
      %bb102_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb102_35 = "braid.and"(%bb102_33, %bb102_34) : (i64, i64) -> i64
      %bb102_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb102_37 = "braid.eq"(%bb102_35, %bb102_36) : (i64, i64) -> i64
      "braid.setf"(%bb102_37) {flag = "pf"} : (i64) -> ()
      %bb102_38 = "braid.eq"(%bb102_17, %bb102_36) : (i64, i64) -> i64
      "braid.setf"(%bb102_38) {flag = "zf"} : (i64) -> ()
      %bb102_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb102_40 = "braid.and"(%bb102_17, %bb102_39) : (i64, i64) -> i64
      "braid.setf"(%bb102_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb102_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb105] : () -> ()
    ^bb105:  // 0x401205
      %bb105_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb105_0 = "braid.zext"(%bb105_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb105_0) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x401208
      %bb108_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb108_0 = "braid.zext"(%bb108_1) {bits = 32 : i64} : (i64) -> i64
      %bb108_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb108_8 = "braid.zext"(%bb108_9) {bits = 32 : i64} : (i64) -> i64
      %bb108_16 = "braid.xor"(%bb108_0, %bb108_8) : (i64, i64) -> i64
      %bb108_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb108_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb108_17) {flag = "of"} : (i64) -> ()
      %bb108_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb108_24) {flag = "af"} : (i64) -> ()
      %bb108_32 = "braid.zext"(%bb108_16) {bits = 8 : i64} : (i64) -> i64
      %bb108_33 = "braid.popcnt"(%bb108_32) : (i64) -> i64
      %bb108_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb108_35 = "braid.and"(%bb108_33, %bb108_34) : (i64, i64) -> i64
      %bb108_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb108_37 = "braid.eq"(%bb108_35, %bb108_36) : (i64, i64) -> i64
      "braid.setf"(%bb108_37) {flag = "pf"} : (i64) -> ()
      %bb108_38 = "braid.eq"(%bb108_16, %bb108_36) : (i64, i64) -> i64
      "braid.setf"(%bb108_38) {flag = "zf"} : (i64) -> ()
      %bb108_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb108_40 = "braid.and"(%bb108_16, %bb108_39) : (i64, i64) -> i64
      "braid.setf"(%bb108_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb108_16) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb10b] : () -> ()
    ^bb10b:  // 0x40120b
      %bb10b_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb10b_0 = "braid.zext"(%bb10b_1) {bits = 32 : i64} : (i64) -> i64
      %bb10b_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bb10b_8 = "braid.zext"(%bb10b_9) {bits = 32 : i64} : (i64) -> i64
      %bb10b_16 = "braid.and"(%bb10b_0, %bb10b_8) : (i64, i64) -> i64
      %bb10b_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb10b_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb10b_17) {flag = "of"} : (i64) -> ()
      %bb10b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb10b_24) {flag = "af"} : (i64) -> ()
      %bb10b_32 = "braid.zext"(%bb10b_16) {bits = 8 : i64} : (i64) -> i64
      %bb10b_33 = "braid.popcnt"(%bb10b_32) : (i64) -> i64
      %bb10b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10b_35 = "braid.and"(%bb10b_33, %bb10b_34) : (i64, i64) -> i64
      %bb10b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10b_37 = "braid.eq"(%bb10b_35, %bb10b_36) : (i64, i64) -> i64
      "braid.setf"(%bb10b_37) {flag = "pf"} : (i64) -> ()
      %bb10b_38 = "braid.eq"(%bb10b_16, %bb10b_36) : (i64, i64) -> i64
      "braid.setf"(%bb10b_38) {flag = "zf"} : (i64) -> ()
      %bb10b_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb10b_40 = "braid.and"(%bb10b_16, %bb10b_39) : (i64, i64) -> i64
      "braid.setf"(%bb10b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb10b_16) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb10e] : () -> ()
    ^bb10e:  // 0x40120e
      %bb10e_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb10e_0 = "braid.zext"(%bb10e_1) {bits = 32 : i64} : (i64) -> i64
      %bb10e_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb10e_8 = "braid.zext"(%bb10e_9) {bits = 32 : i64} : (i64) -> i64
      %bb10e_16 = "braid.xor"(%bb10e_0, %bb10e_8) : (i64, i64) -> i64
      %bb10e_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb10e_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb10e_17) {flag = "of"} : (i64) -> ()
      %bb10e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb10e_24) {flag = "af"} : (i64) -> ()
      %bb10e_32 = "braid.zext"(%bb10e_16) {bits = 8 : i64} : (i64) -> i64
      %bb10e_33 = "braid.popcnt"(%bb10e_32) : (i64) -> i64
      %bb10e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10e_35 = "braid.and"(%bb10e_33, %bb10e_34) : (i64, i64) -> i64
      %bb10e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10e_37 = "braid.eq"(%bb10e_35, %bb10e_36) : (i64, i64) -> i64
      "braid.setf"(%bb10e_37) {flag = "pf"} : (i64) -> ()
      %bb10e_38 = "braid.eq"(%bb10e_16, %bb10e_36) : (i64, i64) -> i64
      "braid.setf"(%bb10e_38) {flag = "zf"} : (i64) -> ()
      %bb10e_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb10e_40 = "braid.and"(%bb10e_16, %bb10e_39) : (i64, i64) -> i64
      "braid.setf"(%bb10e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb10e_16) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb111] : () -> ()
    ^bb111:  // 0x401211
      %bb111_2 = "braid.get"() {reg = "r11"} : () -> i64
      %bb111_3 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb111_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb111_5 = "braid.mul"(%bb111_3, %bb111_4) : (i64, i64) -> i64
      %bb111_6 = "braid.add"(%bb111_2, %bb111_5) : (i64, i64) -> i64
      %bb111_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb111_1 = "braid.add"(%bb111_6, %bb111_7) : (i64, i64) -> i64
      %bb111_0 = "braid.load"(%bb111_1) {bytes = 4 : i64} : (i64) -> i64
      %bb111_9 = "braid.get"() {reg = "r14"} : () -> i64
      %bb111_8 = "braid.zext"(%bb111_9) {bits = 32 : i64} : (i64) -> i64
      %bb111_16 = "braid.add"(%bb111_0, %bb111_8) : (i64, i64) -> i64
      %bb111_17 = "braid.zext"(%bb111_16) {bits = 32 : i64} : (i64) -> i64
      %bb111_18 = "braid.ult"(%bb111_17, %bb111_0) : (i64, i64) -> i64
      "braid.setf"(%bb111_18) {flag = "cf"} : (i64) -> ()
      %bb111_19 = "braid.xor"(%bb111_0, %bb111_17) : (i64, i64) -> i64
      %bb111_20 = "braid.xor"(%bb111_8, %bb111_17) : (i64, i64) -> i64
      %bb111_21 = "braid.and"(%bb111_19, %bb111_20) : (i64, i64) -> i64
      %bb111_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb111_23 = "braid.and"(%bb111_21, %bb111_22) : (i64, i64) -> i64
      "braid.setf"(%bb111_23) {flag = "of"} : (i64) -> ()
      %bb111_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb111_24) {flag = "af"} : (i64) -> ()
      %bb111_32 = "braid.zext"(%bb111_17) {bits = 8 : i64} : (i64) -> i64
      %bb111_33 = "braid.popcnt"(%bb111_32) : (i64) -> i64
      %bb111_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb111_35 = "braid.and"(%bb111_33, %bb111_34) : (i64, i64) -> i64
      %bb111_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb111_37 = "braid.eq"(%bb111_35, %bb111_36) : (i64, i64) -> i64
      "braid.setf"(%bb111_37) {flag = "pf"} : (i64) -> ()
      %bb111_38 = "braid.eq"(%bb111_17, %bb111_36) : (i64, i64) -> i64
      "braid.setf"(%bb111_38) {flag = "zf"} : (i64) -> ()
      %bb111_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb111_40 = "braid.and"(%bb111_17, %bb111_39) : (i64, i64) -> i64
      "braid.setf"(%bb111_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb111_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb115] : () -> ()
    ^bb115:  // 0x401215
      %bb115_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb115_0 = "braid.zext"(%bb115_1) {bits = 32 : i64} : (i64) -> i64
      %bb115_9 = "braid.get"() {reg = "r15"} : () -> i64
      %bb115_8 = "braid.zext"(%bb115_9) {bits = 32 : i64} : (i64) -> i64
      %bb115_16 = "braid.add"(%bb115_0, %bb115_8) : (i64, i64) -> i64
      %bb115_17 = "braid.zext"(%bb115_16) {bits = 32 : i64} : (i64) -> i64
      %bb115_18 = "braid.ult"(%bb115_17, %bb115_0) : (i64, i64) -> i64
      "braid.setf"(%bb115_18) {flag = "cf"} : (i64) -> ()
      %bb115_19 = "braid.xor"(%bb115_0, %bb115_17) : (i64, i64) -> i64
      %bb115_20 = "braid.xor"(%bb115_8, %bb115_17) : (i64, i64) -> i64
      %bb115_21 = "braid.and"(%bb115_19, %bb115_20) : (i64, i64) -> i64
      %bb115_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb115_23 = "braid.and"(%bb115_21, %bb115_22) : (i64, i64) -> i64
      "braid.setf"(%bb115_23) {flag = "of"} : (i64) -> ()
      %bb115_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb115_24) {flag = "af"} : (i64) -> ()
      %bb115_32 = "braid.zext"(%bb115_17) {bits = 8 : i64} : (i64) -> i64
      %bb115_33 = "braid.popcnt"(%bb115_32) : (i64) -> i64
      %bb115_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb115_35 = "braid.and"(%bb115_33, %bb115_34) : (i64, i64) -> i64
      %bb115_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb115_37 = "braid.eq"(%bb115_35, %bb115_36) : (i64, i64) -> i64
      "braid.setf"(%bb115_37) {flag = "pf"} : (i64) -> ()
      %bb115_38 = "braid.eq"(%bb115_17, %bb115_36) : (i64, i64) -> i64
      "braid.setf"(%bb115_38) {flag = "zf"} : (i64) -> ()
      %bb115_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb115_40 = "braid.and"(%bb115_17, %bb115_39) : (i64, i64) -> i64
      "braid.setf"(%bb115_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb115_17) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x401218
      %bb118_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb118_0 = "braid.zext"(%bb118_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb118_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb11a] : () -> ()
    ^bb11a:  // 0x40121a
      %bb11a_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb11a_0 = "braid.zext"(%bb11a_1) {bits = 32 : i64} : (i64) -> i64
      %bb11a_12 = "braid.const"() {value = 30 : i64} : () -> i64
      %bb11a_13 = "braid.shl"(%bb11a_0, %bb11a_12) : (i64, i64) -> i64
      %bb11a_14 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb11a_15 = "braid.lshr"(%bb11a_0, %bb11a_14) : (i64, i64) -> i64
      %bb11a_16 = "braid.or"(%bb11a_13, %bb11a_15) : (i64, i64) -> i64
      %bb11a_17 = "braid.zext"(%bb11a_16) {bits = 32 : i64} : (i64) -> i64
      %bb11a_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb11a_19 = "braid.and"(%bb11a_17, %bb11a_18) : (i64, i64) -> i64
      "braid.setf"(%bb11a_19) {flag = "cf"} : (i64) -> ()
      %bb11a_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb11a_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb11a_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb11d] : () -> ()
    ^bb11d:  // 0x40121d
      %bb11d_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb11d_0 = "braid.zext"(%bb11d_1) {bits = 32 : i64} : (i64) -> i64
      %bb11d_9 = "braid.get"() {reg = "r14"} : () -> i64
      %bb11d_8 = "braid.zext"(%bb11d_9) {bits = 32 : i64} : (i64) -> i64
      %bb11d_16 = "braid.add"(%bb11d_0, %bb11d_8) : (i64, i64) -> i64
      %bb11d_17 = "braid.zext"(%bb11d_16) {bits = 32 : i64} : (i64) -> i64
      %bb11d_18 = "braid.ult"(%bb11d_17, %bb11d_0) : (i64, i64) -> i64
      "braid.setf"(%bb11d_18) {flag = "cf"} : (i64) -> ()
      %bb11d_19 = "braid.xor"(%bb11d_0, %bb11d_17) : (i64, i64) -> i64
      %bb11d_20 = "braid.xor"(%bb11d_8, %bb11d_17) : (i64, i64) -> i64
      %bb11d_21 = "braid.and"(%bb11d_19, %bb11d_20) : (i64, i64) -> i64
      %bb11d_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb11d_23 = "braid.and"(%bb11d_21, %bb11d_22) : (i64, i64) -> i64
      "braid.setf"(%bb11d_23) {flag = "of"} : (i64) -> ()
      %bb11d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb11d_24) {flag = "af"} : (i64) -> ()
      %bb11d_32 = "braid.zext"(%bb11d_17) {bits = 8 : i64} : (i64) -> i64
      %bb11d_33 = "braid.popcnt"(%bb11d_32) : (i64) -> i64
      %bb11d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb11d_35 = "braid.and"(%bb11d_33, %bb11d_34) : (i64, i64) -> i64
      %bb11d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb11d_37 = "braid.eq"(%bb11d_35, %bb11d_36) : (i64, i64) -> i64
      "braid.setf"(%bb11d_37) {flag = "pf"} : (i64) -> ()
      %bb11d_38 = "braid.eq"(%bb11d_17, %bb11d_36) : (i64, i64) -> i64
      "braid.setf"(%bb11d_38) {flag = "zf"} : (i64) -> ()
      %bb11d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb11d_40 = "braid.and"(%bb11d_17, %bb11d_39) : (i64, i64) -> i64
      "braid.setf"(%bb11d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb11d_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x401220
      %bb120_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb120_0 = "braid.zext"(%bb120_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb120_0) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb123] : () -> ()
    ^bb123:  // 0x401223
      %bb123_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb123_0 = "braid.zext"(%bb123_1) {bits = 32 : i64} : (i64) -> i64
      %bb123_12 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb123_13 = "braid.shl"(%bb123_0, %bb123_12) : (i64, i64) -> i64
      %bb123_14 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb123_15 = "braid.lshr"(%bb123_0, %bb123_14) : (i64, i64) -> i64
      %bb123_16 = "braid.or"(%bb123_13, %bb123_15) : (i64, i64) -> i64
      %bb123_17 = "braid.zext"(%bb123_16) {bits = 32 : i64} : (i64) -> i64
      %bb123_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb123_19 = "braid.and"(%bb123_17, %bb123_18) : (i64, i64) -> i64
      "braid.setf"(%bb123_19) {flag = "cf"} : (i64) -> ()
      %bb123_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb123_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb123_17) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb127] : () -> ()
    ^bb127:  // 0x401227
      %bb127_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb127_0 = "braid.zext"(%bb127_1) {bits = 32 : i64} : (i64) -> i64
      %bb127_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb127_8 = "braid.zext"(%bb127_9) {bits = 32 : i64} : (i64) -> i64
      %bb127_16 = "braid.xor"(%bb127_0, %bb127_8) : (i64, i64) -> i64
      %bb127_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb127_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb127_17) {flag = "of"} : (i64) -> ()
      %bb127_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb127_24) {flag = "af"} : (i64) -> ()
      %bb127_32 = "braid.zext"(%bb127_16) {bits = 8 : i64} : (i64) -> i64
      %bb127_33 = "braid.popcnt"(%bb127_32) : (i64) -> i64
      %bb127_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb127_35 = "braid.and"(%bb127_33, %bb127_34) : (i64, i64) -> i64
      %bb127_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb127_37 = "braid.eq"(%bb127_35, %bb127_36) : (i64, i64) -> i64
      "braid.setf"(%bb127_37) {flag = "pf"} : (i64) -> ()
      %bb127_38 = "braid.eq"(%bb127_16, %bb127_36) : (i64, i64) -> i64
      "braid.setf"(%bb127_38) {flag = "zf"} : (i64) -> ()
      %bb127_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb127_40 = "braid.and"(%bb127_16, %bb127_39) : (i64, i64) -> i64
      "braid.setf"(%bb127_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb127_16) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb12a] : () -> ()
    ^bb12a:  // 0x40122a
      %bb12a_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb12a_0 = "braid.zext"(%bb12a_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb12a_0) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb12d] : () -> ()
    ^bb12d:  // 0x40122d
      %bb12d_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb12d_0 = "braid.zext"(%bb12d_1) {bits = 32 : i64} : (i64) -> i64
      %bb12d_12 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb12d_13 = "braid.shl"(%bb12d_0, %bb12d_12) : (i64, i64) -> i64
      %bb12d_14 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb12d_15 = "braid.lshr"(%bb12d_0, %bb12d_14) : (i64, i64) -> i64
      %bb12d_16 = "braid.or"(%bb12d_13, %bb12d_15) : (i64, i64) -> i64
      %bb12d_17 = "braid.zext"(%bb12d_16) {bits = 32 : i64} : (i64) -> i64
      %bb12d_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb12d_19 = "braid.and"(%bb12d_17, %bb12d_18) : (i64, i64) -> i64
      "braid.setf"(%bb12d_19) {flag = "cf"} : (i64) -> ()
      %bb12d_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb12d_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb12d_17) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb131] : () -> ()
    ^bb131:  // 0x401231
      %bb131_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb131_0 = "braid.zext"(%bb131_1) {bits = 32 : i64} : (i64) -> i64
      %bb131_9 = "braid.get"() {reg = "r15"} : () -> i64
      %bb131_8 = "braid.zext"(%bb131_9) {bits = 32 : i64} : (i64) -> i64
      %bb131_16 = "braid.xor"(%bb131_0, %bb131_8) : (i64, i64) -> i64
      %bb131_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb131_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb131_17) {flag = "of"} : (i64) -> ()
      %bb131_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb131_24) {flag = "af"} : (i64) -> ()
      %bb131_32 = "braid.zext"(%bb131_16) {bits = 8 : i64} : (i64) -> i64
      %bb131_33 = "braid.popcnt"(%bb131_32) : (i64) -> i64
      %bb131_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb131_35 = "braid.and"(%bb131_33, %bb131_34) : (i64, i64) -> i64
      %bb131_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb131_37 = "braid.eq"(%bb131_35, %bb131_36) : (i64, i64) -> i64
      "braid.setf"(%bb131_37) {flag = "pf"} : (i64) -> ()
      %bb131_38 = "braid.eq"(%bb131_16, %bb131_36) : (i64, i64) -> i64
      "braid.setf"(%bb131_38) {flag = "zf"} : (i64) -> ()
      %bb131_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb131_40 = "braid.and"(%bb131_16, %bb131_39) : (i64, i64) -> i64
      "braid.setf"(%bb131_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb131_16) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb134:  // 0x401234
      %bb134_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb134_0 = "braid.zext"(%bb134_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb134_0) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb137] : () -> ()
    ^bb137:  // 0x401237
      %bb137_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb137_0 = "braid.zext"(%bb137_1) {bits = 32 : i64} : (i64) -> i64
      %bb137_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb137_8 = "braid.zext"(%bb137_9) {bits = 32 : i64} : (i64) -> i64
      %bb137_16 = "braid.xor"(%bb137_0, %bb137_8) : (i64, i64) -> i64
      %bb137_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb137_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb137_17) {flag = "of"} : (i64) -> ()
      %bb137_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb137_24) {flag = "af"} : (i64) -> ()
      %bb137_32 = "braid.zext"(%bb137_16) {bits = 8 : i64} : (i64) -> i64
      %bb137_33 = "braid.popcnt"(%bb137_32) : (i64) -> i64
      %bb137_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb137_35 = "braid.and"(%bb137_33, %bb137_34) : (i64, i64) -> i64
      %bb137_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb137_37 = "braid.eq"(%bb137_35, %bb137_36) : (i64, i64) -> i64
      "braid.setf"(%bb137_37) {flag = "pf"} : (i64) -> ()
      %bb137_38 = "braid.eq"(%bb137_16, %bb137_36) : (i64, i64) -> i64
      "braid.setf"(%bb137_38) {flag = "zf"} : (i64) -> ()
      %bb137_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb137_40 = "braid.and"(%bb137_16, %bb137_39) : (i64, i64) -> i64
      "braid.setf"(%bb137_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb137_16) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb13a] : () -> ()
    ^bb13a:  // 0x40123a
      %bb13a_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb13a_0 = "braid.zext"(%bb13a_1) {bits = 32 : i64} : (i64) -> i64
      %bb13a_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb13a_8 = "braid.zext"(%bb13a_9) {bits = 32 : i64} : (i64) -> i64
      %bb13a_16 = "braid.and"(%bb13a_0, %bb13a_8) : (i64, i64) -> i64
      %bb13a_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb13a_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb13a_17) {flag = "of"} : (i64) -> ()
      %bb13a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb13a_24) {flag = "af"} : (i64) -> ()
      %bb13a_32 = "braid.zext"(%bb13a_16) {bits = 8 : i64} : (i64) -> i64
      %bb13a_33 = "braid.popcnt"(%bb13a_32) : (i64) -> i64
      %bb13a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb13a_35 = "braid.and"(%bb13a_33, %bb13a_34) : (i64, i64) -> i64
      %bb13a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb13a_37 = "braid.eq"(%bb13a_35, %bb13a_36) : (i64, i64) -> i64
      "braid.setf"(%bb13a_37) {flag = "pf"} : (i64) -> ()
      %bb13a_38 = "braid.eq"(%bb13a_16, %bb13a_36) : (i64, i64) -> i64
      "braid.setf"(%bb13a_38) {flag = "zf"} : (i64) -> ()
      %bb13a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb13a_40 = "braid.and"(%bb13a_16, %bb13a_39) : (i64, i64) -> i64
      "braid.setf"(%bb13a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb13a_16) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb13d] : () -> ()
    ^bb13d:  // 0x40123d
      %bb13d_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb13d_0 = "braid.zext"(%bb13d_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb13d_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb13f] : () -> ()
    ^bb13f:  // 0x40123f
      %bb13f_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb13f_0 = "braid.zext"(%bb13f_1) {bits = 32 : i64} : (i64) -> i64
      %bb13f_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb13f_8 = "braid.zext"(%bb13f_9) {bits = 32 : i64} : (i64) -> i64
      %bb13f_16 = "braid.and"(%bb13f_0, %bb13f_8) : (i64, i64) -> i64
      %bb13f_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb13f_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb13f_17) {flag = "of"} : (i64) -> ()
      %bb13f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb13f_24) {flag = "af"} : (i64) -> ()
      %bb13f_32 = "braid.zext"(%bb13f_16) {bits = 8 : i64} : (i64) -> i64
      %bb13f_33 = "braid.popcnt"(%bb13f_32) : (i64) -> i64
      %bb13f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb13f_35 = "braid.and"(%bb13f_33, %bb13f_34) : (i64, i64) -> i64
      %bb13f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb13f_37 = "braid.eq"(%bb13f_35, %bb13f_36) : (i64, i64) -> i64
      "braid.setf"(%bb13f_37) {flag = "pf"} : (i64) -> ()
      %bb13f_38 = "braid.eq"(%bb13f_16, %bb13f_36) : (i64, i64) -> i64
      "braid.setf"(%bb13f_38) {flag = "zf"} : (i64) -> ()
      %bb13f_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb13f_40 = "braid.and"(%bb13f_16, %bb13f_39) : (i64, i64) -> i64
      "braid.setf"(%bb13f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb13f_16) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb141] : () -> ()
    ^bb141:  // 0x401241
      %bb141_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb141_0 = "braid.zext"(%bb141_1) {bits = 32 : i64} : (i64) -> i64
      %bb141_9 = "braid.get"() {reg = "r15"} : () -> i64
      %bb141_8 = "braid.zext"(%bb141_9) {bits = 32 : i64} : (i64) -> i64
      %bb141_16 = "braid.xor"(%bb141_0, %bb141_8) : (i64, i64) -> i64
      %bb141_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb141_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb141_17) {flag = "of"} : (i64) -> ()
      %bb141_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb141_24) {flag = "af"} : (i64) -> ()
      %bb141_32 = "braid.zext"(%bb141_16) {bits = 8 : i64} : (i64) -> i64
      %bb141_33 = "braid.popcnt"(%bb141_32) : (i64) -> i64
      %bb141_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb141_35 = "braid.and"(%bb141_33, %bb141_34) : (i64, i64) -> i64
      %bb141_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb141_37 = "braid.eq"(%bb141_35, %bb141_36) : (i64, i64) -> i64
      "braid.setf"(%bb141_37) {flag = "pf"} : (i64) -> ()
      %bb141_38 = "braid.eq"(%bb141_16, %bb141_36) : (i64, i64) -> i64
      "braid.setf"(%bb141_38) {flag = "zf"} : (i64) -> ()
      %bb141_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb141_40 = "braid.and"(%bb141_16, %bb141_39) : (i64, i64) -> i64
      "braid.setf"(%bb141_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb141_16) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb144] : () -> ()
    ^bb144:  // 0x401244
      %bb144_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb144_0 = "braid.zext"(%bb144_1) {bits = 32 : i64} : (i64) -> i64
      %bb144_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb144_8 = "braid.zext"(%bb144_9) {bits = 32 : i64} : (i64) -> i64
      %bb144_16 = "braid.add"(%bb144_0, %bb144_8) : (i64, i64) -> i64
      %bb144_17 = "braid.zext"(%bb144_16) {bits = 32 : i64} : (i64) -> i64
      %bb144_18 = "braid.ult"(%bb144_17, %bb144_0) : (i64, i64) -> i64
      "braid.setf"(%bb144_18) {flag = "cf"} : (i64) -> ()
      %bb144_19 = "braid.xor"(%bb144_0, %bb144_17) : (i64, i64) -> i64
      %bb144_20 = "braid.xor"(%bb144_8, %bb144_17) : (i64, i64) -> i64
      %bb144_21 = "braid.and"(%bb144_19, %bb144_20) : (i64, i64) -> i64
      %bb144_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb144_23 = "braid.and"(%bb144_21, %bb144_22) : (i64, i64) -> i64
      "braid.setf"(%bb144_23) {flag = "of"} : (i64) -> ()
      %bb144_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb144_24) {flag = "af"} : (i64) -> ()
      %bb144_32 = "braid.zext"(%bb144_17) {bits = 8 : i64} : (i64) -> i64
      %bb144_33 = "braid.popcnt"(%bb144_32) : (i64) -> i64
      %bb144_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb144_35 = "braid.and"(%bb144_33, %bb144_34) : (i64, i64) -> i64
      %bb144_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb144_37 = "braid.eq"(%bb144_35, %bb144_36) : (i64, i64) -> i64
      "braid.setf"(%bb144_37) {flag = "pf"} : (i64) -> ()
      %bb144_38 = "braid.eq"(%bb144_17, %bb144_36) : (i64, i64) -> i64
      "braid.setf"(%bb144_38) {flag = "zf"} : (i64) -> ()
      %bb144_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb144_40 = "braid.and"(%bb144_17, %bb144_39) : (i64, i64) -> i64
      "braid.setf"(%bb144_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb144_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb147] : () -> ()
    ^bb147:  // 0x401247
      %bb147_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb147_0 = "braid.zext"(%bb147_1) {bits = 32 : i64} : (i64) -> i64
      %bb147_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb147_8 = "braid.zext"(%bb147_9) {bits = 32 : i64} : (i64) -> i64
      %bb147_16 = "braid.add"(%bb147_0, %bb147_8) : (i64, i64) -> i64
      %bb147_17 = "braid.zext"(%bb147_16) {bits = 32 : i64} : (i64) -> i64
      %bb147_18 = "braid.ult"(%bb147_17, %bb147_0) : (i64, i64) -> i64
      "braid.setf"(%bb147_18) {flag = "cf"} : (i64) -> ()
      %bb147_19 = "braid.xor"(%bb147_0, %bb147_17) : (i64, i64) -> i64
      %bb147_20 = "braid.xor"(%bb147_8, %bb147_17) : (i64, i64) -> i64
      %bb147_21 = "braid.and"(%bb147_19, %bb147_20) : (i64, i64) -> i64
      %bb147_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb147_23 = "braid.and"(%bb147_21, %bb147_22) : (i64, i64) -> i64
      "braid.setf"(%bb147_23) {flag = "of"} : (i64) -> ()
      %bb147_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb147_24) {flag = "af"} : (i64) -> ()
      %bb147_32 = "braid.zext"(%bb147_17) {bits = 8 : i64} : (i64) -> i64
      %bb147_33 = "braid.popcnt"(%bb147_32) : (i64) -> i64
      %bb147_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb147_35 = "braid.and"(%bb147_33, %bb147_34) : (i64, i64) -> i64
      %bb147_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb147_37 = "braid.eq"(%bb147_35, %bb147_36) : (i64, i64) -> i64
      "braid.setf"(%bb147_37) {flag = "pf"} : (i64) -> ()
      %bb147_38 = "braid.eq"(%bb147_17, %bb147_36) : (i64, i64) -> i64
      "braid.setf"(%bb147_38) {flag = "zf"} : (i64) -> ()
      %bb147_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb147_40 = "braid.and"(%bb147_17, %bb147_39) : (i64, i64) -> i64
      "braid.setf"(%bb147_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb147_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb14a] : () -> ()
    ^bb14a:  // 0x40124a
      %bb14a_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb14a_0 = "braid.zext"(%bb14a_1) {bits = 32 : i64} : (i64) -> i64
      %bb14a_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb14a_8 = "braid.zext"(%bb14a_9) {bits = 32 : i64} : (i64) -> i64
      %bb14a_16 = "braid.add"(%bb14a_0, %bb14a_8) : (i64, i64) -> i64
      %bb14a_17 = "braid.zext"(%bb14a_16) {bits = 32 : i64} : (i64) -> i64
      %bb14a_18 = "braid.ult"(%bb14a_17, %bb14a_0) : (i64, i64) -> i64
      "braid.setf"(%bb14a_18) {flag = "cf"} : (i64) -> ()
      %bb14a_19 = "braid.xor"(%bb14a_0, %bb14a_17) : (i64, i64) -> i64
      %bb14a_20 = "braid.xor"(%bb14a_8, %bb14a_17) : (i64, i64) -> i64
      %bb14a_21 = "braid.and"(%bb14a_19, %bb14a_20) : (i64, i64) -> i64
      %bb14a_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb14a_23 = "braid.and"(%bb14a_21, %bb14a_22) : (i64, i64) -> i64
      "braid.setf"(%bb14a_23) {flag = "of"} : (i64) -> ()
      %bb14a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb14a_24) {flag = "af"} : (i64) -> ()
      %bb14a_32 = "braid.zext"(%bb14a_17) {bits = 8 : i64} : (i64) -> i64
      %bb14a_33 = "braid.popcnt"(%bb14a_32) : (i64) -> i64
      %bb14a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14a_35 = "braid.and"(%bb14a_33, %bb14a_34) : (i64, i64) -> i64
      %bb14a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14a_37 = "braid.eq"(%bb14a_35, %bb14a_36) : (i64, i64) -> i64
      "braid.setf"(%bb14a_37) {flag = "pf"} : (i64) -> ()
      %bb14a_38 = "braid.eq"(%bb14a_17, %bb14a_36) : (i64, i64) -> i64
      "braid.setf"(%bb14a_38) {flag = "zf"} : (i64) -> ()
      %bb14a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb14a_40 = "braid.and"(%bb14a_17, %bb14a_39) : (i64, i64) -> i64
      "braid.setf"(%bb14a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb14a_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb14d] : () -> ()
    ^bb14d:  // 0x40124d
      %bb14d_0 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb14d_8 = "braid.get"() {reg = "r11"} : () -> i64
      %bb14d_16 = "braid.add"(%bb14d_0, %bb14d_8) : (i64, i64) -> i64
      %bb14d_18 = "braid.ult"(%bb14d_16, %bb14d_0) : (i64, i64) -> i64
      "braid.setf"(%bb14d_18) {flag = "cf"} : (i64) -> ()
      %bb14d_19 = "braid.xor"(%bb14d_0, %bb14d_16) : (i64, i64) -> i64
      %bb14d_20 = "braid.xor"(%bb14d_8, %bb14d_16) : (i64, i64) -> i64
      %bb14d_21 = "braid.and"(%bb14d_19, %bb14d_20) : (i64, i64) -> i64
      %bb14d_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb14d_23 = "braid.and"(%bb14d_21, %bb14d_22) : (i64, i64) -> i64
      "braid.setf"(%bb14d_23) {flag = "of"} : (i64) -> ()
      %bb14d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb14d_24) {flag = "af"} : (i64) -> ()
      %bb14d_32 = "braid.zext"(%bb14d_16) {bits = 8 : i64} : (i64) -> i64
      %bb14d_33 = "braid.popcnt"(%bb14d_32) : (i64) -> i64
      %bb14d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14d_35 = "braid.and"(%bb14d_33, %bb14d_34) : (i64, i64) -> i64
      %bb14d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14d_37 = "braid.eq"(%bb14d_35, %bb14d_36) : (i64, i64) -> i64
      "braid.setf"(%bb14d_37) {flag = "pf"} : (i64) -> ()
      %bb14d_38 = "braid.eq"(%bb14d_16, %bb14d_36) : (i64, i64) -> i64
      "braid.setf"(%bb14d_38) {flag = "zf"} : (i64) -> ()
      %bb14d_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb14d_40 = "braid.and"(%bb14d_16, %bb14d_39) : (i64, i64) -> i64
      "braid.setf"(%bb14d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb14d_16) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb151] : () -> ()
    ^bb151:  // 0x401251
      %bb151_0 = "braid.get"() {reg = "r11"} : () -> i64
      %bb151_8 = "braid.const"() {value = 256 : i64} : () -> i64
      %bb151_16 = "braid.sub"(%bb151_0, %bb151_8) : (i64, i64) -> i64
      %bb151_18 = "braid.ult"(%bb151_0, %bb151_8) : (i64, i64) -> i64
      "braid.setf"(%bb151_18) {flag = "cf"} : (i64) -> ()
      %bb151_19 = "braid.xor"(%bb151_0, %bb151_8) : (i64, i64) -> i64
      %bb151_20 = "braid.xor"(%bb151_0, %bb151_16) : (i64, i64) -> i64
      %bb151_21 = "braid.and"(%bb151_19, %bb151_20) : (i64, i64) -> i64
      %bb151_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb151_23 = "braid.and"(%bb151_21, %bb151_22) : (i64, i64) -> i64
      "braid.setf"(%bb151_23) {flag = "of"} : (i64) -> ()
      %bb151_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb151_24) {flag = "af"} : (i64) -> ()
      %bb151_32 = "braid.zext"(%bb151_16) {bits = 8 : i64} : (i64) -> i64
      %bb151_33 = "braid.popcnt"(%bb151_32) : (i64) -> i64
      %bb151_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb151_35 = "braid.and"(%bb151_33, %bb151_34) : (i64, i64) -> i64
      %bb151_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb151_37 = "braid.eq"(%bb151_35, %bb151_36) : (i64, i64) -> i64
      "braid.setf"(%bb151_37) {flag = "pf"} : (i64) -> ()
      %bb151_38 = "braid.eq"(%bb151_16, %bb151_36) : (i64, i64) -> i64
      "braid.setf"(%bb151_38) {flag = "zf"} : (i64) -> ()
      %bb151_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb151_40 = "braid.and"(%bb151_16, %bb151_39) : (i64, i64) -> i64
      "braid.setf"(%bb151_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb158] : () -> ()
    ^bb158:  // 0x401258
      %bb158_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb158_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb158_0 = "braid.eq"(%bb158_1, %bb158_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb158_0)[^bbd0, ^bb15e] : (i64) -> ()
    ^bb15e:  // 0x40125e
      %bb15e_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb15e_0 = "braid.zext"(%bb15e_1) {bits = 32 : i64} : (i64) -> i64
      %bb15e_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb15e_10 = "braid.const"() {value = -128 : i64} : () -> i64
      %bb15e_8 = "braid.add"(%bb15e_9, %bb15e_10) : (i64, i64) -> i64
      "braid.store"(%bb15e_8, %bb15e_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb162] : () -> ()
    ^bb162:  // 0x401262
      %bb162_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb162_0 = "braid.zext"(%bb162_1) {bits = 32 : i64} : (i64) -> i64
      %bb162_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb162_10 = "braid.const"() {value = -124 : i64} : () -> i64
      %bb162_8 = "braid.add"(%bb162_9, %bb162_10) : (i64, i64) -> i64
      "braid.store"(%bb162_8, %bb162_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb166] : () -> ()
    ^bb166:  // 0x401266
      %bb166_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb166_0 = "braid.zext"(%bb166_1) {bits = 32 : i64} : (i64) -> i64
      %bb166_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb166_10 = "braid.const"() {value = -120 : i64} : () -> i64
      %bb166_8 = "braid.add"(%bb166_9, %bb166_10) : (i64, i64) -> i64
      "braid.store"(%bb166_8, %bb166_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb16a] : () -> ()
    ^bb16a:  // 0x40126a
      %bb16a_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb16a_0 = "braid.zext"(%bb16a_1) {bits = 32 : i64} : (i64) -> i64
      %bb16a_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb16a_10 = "braid.const"() {value = -116 : i64} : () -> i64
      %bb16a_8 = "braid.add"(%bb16a_9, %bb16a_10) : (i64, i64) -> i64
      "braid.store"(%bb16a_8, %bb16a_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb16e] : () -> ()
    ^bb16e:  // 0x40126e
      %bb16e_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb16e_0 = "braid.zext"(%bb16e_1) {bits = 32 : i64} : (i64) -> i64
      %bb16e_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb16e_10 = "braid.const"() {value = -112 : i64} : () -> i64
      %bb16e_8 = "braid.add"(%bb16e_9, %bb16e_10) : (i64, i64) -> i64
      "braid.store"(%bb16e_8, %bb16e_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb172] : () -> ()
    ^bb172:  // 0x401272
      %bb172_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb172_0 = "braid.zext"(%bb172_1) {bits = 32 : i64} : (i64) -> i64
      %bb172_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb172_10 = "braid.const"() {value = -108 : i64} : () -> i64
      %bb172_8 = "braid.add"(%bb172_9, %bb172_10) : (i64, i64) -> i64
      "braid.store"(%bb172_8, %bb172_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb177] : () -> ()
    ^bb177:  // 0x401277
      %bb177_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb177_0 = "braid.zext"(%bb177_1) {bits = 32 : i64} : (i64) -> i64
      %bb177_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb177_10 = "braid.const"() {value = -104 : i64} : () -> i64
      %bb177_8 = "braid.add"(%bb177_9, %bb177_10) : (i64, i64) -> i64
      "braid.store"(%bb177_8, %bb177_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb17c] : () -> ()
    ^bb17c:  // 0x40127c
      %bb17c_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb17c_0 = "braid.zext"(%bb17c_1) {bits = 32 : i64} : (i64) -> i64
      %bb17c_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb17c_10 = "braid.const"() {value = -100 : i64} : () -> i64
      %bb17c_8 = "braid.add"(%bb17c_9, %bb17c_10) : (i64, i64) -> i64
      "braid.store"(%bb17c_8, %bb17c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb181] : () -> ()
    ^bb181:  // 0x401281
      %bb181_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb181_0 = "braid.zext"(%bb181_1) {bits = 32 : i64} : (i64) -> i64
      %bb181_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb181_8 = "braid.zext"(%bb181_9) {bits = 32 : i64} : (i64) -> i64
      %bb181_16 = "braid.xor"(%bb181_0, %bb181_8) : (i64, i64) -> i64
      %bb181_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb181_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb181_17) {flag = "of"} : (i64) -> ()
      %bb181_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb181_24) {flag = "af"} : (i64) -> ()
      %bb181_32 = "braid.zext"(%bb181_16) {bits = 8 : i64} : (i64) -> i64
      %bb181_33 = "braid.popcnt"(%bb181_32) : (i64) -> i64
      %bb181_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb181_35 = "braid.and"(%bb181_33, %bb181_34) : (i64, i64) -> i64
      %bb181_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb181_37 = "braid.eq"(%bb181_35, %bb181_36) : (i64, i64) -> i64
      "braid.setf"(%bb181_37) {flag = "pf"} : (i64) -> ()
      %bb181_38 = "braid.eq"(%bb181_16, %bb181_36) : (i64, i64) -> i64
      "braid.setf"(%bb181_38) {flag = "zf"} : (i64) -> ()
      %bb181_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb181_40 = "braid.and"(%bb181_16, %bb181_39) : (i64, i64) -> i64
      "braid.setf"(%bb181_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb181_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb183] : () -> ()
    ^bb183:  // 0x401283
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x401290
      %bb190_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb190_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb190_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb190_5 = "braid.mul"(%bb190_3, %bb190_4) : (i64, i64) -> i64
      %bb190_6 = "braid.add"(%bb190_2, %bb190_5) : (i64, i64) -> i64
      %bb190_7 = "braid.const"() {value = -128 : i64} : () -> i64
      %bb190_1 = "braid.add"(%bb190_6, %bb190_7) : (i64, i64) -> i64
      %bb190_0 = "braid.load"(%bb190_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb190_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb194] : () -> ()
    ^bb194:  // 0x401294
      %bb194_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb194_0 = "braid.zext"(%bb194_1) {bits = 32 : i64} : (i64) -> i64
      %bb194_10 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb194_11 = "braid.get"() {reg = "rax"} : () -> i64
      %bb194_12 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb194_13 = "braid.mul"(%bb194_11, %bb194_12) : (i64, i64) -> i64
      %bb194_14 = "braid.add"(%bb194_10, %bb194_13) : (i64, i64) -> i64
      %bb194_15 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb194_9 = "braid.add"(%bb194_14, %bb194_15) : (i64, i64) -> i64
      %bb194_8 = "braid.load"(%bb194_9) {bytes = 4 : i64} : (i64) -> i64
      %bb194_16 = "braid.add"(%bb194_0, %bb194_8) : (i64, i64) -> i64
      %bb194_17 = "braid.zext"(%bb194_16) {bits = 32 : i64} : (i64) -> i64
      %bb194_18 = "braid.ult"(%bb194_17, %bb194_0) : (i64, i64) -> i64
      "braid.setf"(%bb194_18) {flag = "cf"} : (i64) -> ()
      %bb194_19 = "braid.xor"(%bb194_0, %bb194_17) : (i64, i64) -> i64
      %bb194_20 = "braid.xor"(%bb194_8, %bb194_17) : (i64, i64) -> i64
      %bb194_21 = "braid.and"(%bb194_19, %bb194_20) : (i64, i64) -> i64
      %bb194_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb194_23 = "braid.and"(%bb194_21, %bb194_22) : (i64, i64) -> i64
      "braid.setf"(%bb194_23) {flag = "of"} : (i64) -> ()
      %bb194_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb194_24) {flag = "af"} : (i64) -> ()
      %bb194_32 = "braid.zext"(%bb194_17) {bits = 8 : i64} : (i64) -> i64
      %bb194_33 = "braid.popcnt"(%bb194_32) : (i64) -> i64
      %bb194_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb194_35 = "braid.and"(%bb194_33, %bb194_34) : (i64, i64) -> i64
      %bb194_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb194_37 = "braid.eq"(%bb194_35, %bb194_36) : (i64, i64) -> i64
      "braid.setf"(%bb194_37) {flag = "pf"} : (i64) -> ()
      %bb194_38 = "braid.eq"(%bb194_17, %bb194_36) : (i64, i64) -> i64
      "braid.setf"(%bb194_38) {flag = "zf"} : (i64) -> ()
      %bb194_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb194_40 = "braid.and"(%bb194_17, %bb194_39) : (i64, i64) -> i64
      "braid.setf"(%bb194_40) {flag = "sf"} : (i64) -> ()
      %bb194_49 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb194_50 = "braid.get"() {reg = "rax"} : () -> i64
      %bb194_51 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb194_52 = "braid.mul"(%bb194_50, %bb194_51) : (i64, i64) -> i64
      %bb194_53 = "braid.add"(%bb194_49, %bb194_52) : (i64, i64) -> i64
      %bb194_54 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb194_48 = "braid.add"(%bb194_53, %bb194_54) : (i64, i64) -> i64
      "braid.store"(%bb194_48, %bb194_17) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb197] : () -> ()
    ^bb197:  // 0x401297
      %bb197_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb197_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb197_16 = "braid.add"(%bb197_0, %bb197_8) : (i64, i64) -> i64
      %bb197_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb197_20 = "braid.eq"(%bb197_16, %bb197_19) : (i64, i64) -> i64
      "braid.setf"(%bb197_20) {flag = "of"} : (i64) -> ()
      %bb197_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb197_24) {flag = "af"} : (i64) -> ()
      %bb197_32 = "braid.zext"(%bb197_16) {bits = 8 : i64} : (i64) -> i64
      %bb197_33 = "braid.popcnt"(%bb197_32) : (i64) -> i64
      %bb197_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb197_35 = "braid.and"(%bb197_33, %bb197_34) : (i64, i64) -> i64
      %bb197_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb197_37 = "braid.eq"(%bb197_35, %bb197_36) : (i64, i64) -> i64
      "braid.setf"(%bb197_37) {flag = "pf"} : (i64) -> ()
      %bb197_38 = "braid.eq"(%bb197_16, %bb197_36) : (i64, i64) -> i64
      "braid.setf"(%bb197_38) {flag = "zf"} : (i64) -> ()
      %bb197_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb197_40 = "braid.and"(%bb197_16, %bb197_39) : (i64, i64) -> i64
      "braid.setf"(%bb197_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb197_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb19a] : () -> ()
    ^bb19a:  // 0x40129a
      %bb19a_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb19a_8 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb19a_16 = "braid.sub"(%bb19a_0, %bb19a_8) : (i64, i64) -> i64
      %bb19a_18 = "braid.ult"(%bb19a_0, %bb19a_8) : (i64, i64) -> i64
      "braid.setf"(%bb19a_18) {flag = "cf"} : (i64) -> ()
      %bb19a_19 = "braid.xor"(%bb19a_0, %bb19a_8) : (i64, i64) -> i64
      %bb19a_20 = "braid.xor"(%bb19a_0, %bb19a_16) : (i64, i64) -> i64
      %bb19a_21 = "braid.and"(%bb19a_19, %bb19a_20) : (i64, i64) -> i64
      %bb19a_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb19a_23 = "braid.and"(%bb19a_21, %bb19a_22) : (i64, i64) -> i64
      "braid.setf"(%bb19a_23) {flag = "of"} : (i64) -> ()
      %bb19a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb19a_24) {flag = "af"} : (i64) -> ()
      %bb19a_32 = "braid.zext"(%bb19a_16) {bits = 8 : i64} : (i64) -> i64
      %bb19a_33 = "braid.popcnt"(%bb19a_32) : (i64) -> i64
      %bb19a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb19a_35 = "braid.and"(%bb19a_33, %bb19a_34) : (i64, i64) -> i64
      %bb19a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb19a_37 = "braid.eq"(%bb19a_35, %bb19a_36) : (i64, i64) -> i64
      "braid.setf"(%bb19a_37) {flag = "pf"} : (i64) -> ()
      %bb19a_38 = "braid.eq"(%bb19a_16, %bb19a_36) : (i64, i64) -> i64
      "braid.setf"(%bb19a_38) {flag = "zf"} : (i64) -> ()
      %bb19a_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb19a_40 = "braid.and"(%bb19a_16, %bb19a_39) : (i64, i64) -> i64
      "braid.setf"(%bb19a_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb19e] : () -> ()
    ^bb19e:  // 0x40129e
      %bb19e_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb19e_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb19e_0 = "braid.eq"(%bb19e_1, %bb19e_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb19e_0)[^bb190, ^bb1a0] : (i64) -> ()
    ^bb1a0:  // 0x4012a0
      %bb1a0_0 = "braid.const"() {value = 160 : i64} : () -> i64
      %bb1a0_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1a0_16 = "braid.add"(%bb1a0_0, %bb1a0_8) : (i64, i64) -> i64
      %bb1a0_18 = "braid.ult"(%bb1a0_16, %bb1a0_0) : (i64, i64) -> i64
      "braid.setf"(%bb1a0_18) {flag = "cf"} : (i64) -> ()
      %bb1a0_19 = "braid.xor"(%bb1a0_0, %bb1a0_16) : (i64, i64) -> i64
      %bb1a0_20 = "braid.xor"(%bb1a0_8, %bb1a0_16) : (i64, i64) -> i64
      %bb1a0_21 = "braid.and"(%bb1a0_19, %bb1a0_20) : (i64, i64) -> i64
      %bb1a0_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1a0_23 = "braid.and"(%bb1a0_21, %bb1a0_22) : (i64, i64) -> i64
      "braid.setf"(%bb1a0_23) {flag = "of"} : (i64) -> ()
      %bb1a0_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1a0_24) {flag = "af"} : (i64) -> ()
      %bb1a0_32 = "braid.zext"(%bb1a0_16) {bits = 8 : i64} : (i64) -> i64
      %bb1a0_33 = "braid.popcnt"(%bb1a0_32) : (i64) -> i64
      %bb1a0_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1a0_35 = "braid.and"(%bb1a0_33, %bb1a0_34) : (i64, i64) -> i64
      %bb1a0_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1a0_37 = "braid.eq"(%bb1a0_35, %bb1a0_36) : (i64, i64) -> i64
      "braid.setf"(%bb1a0_37) {flag = "pf"} : (i64) -> ()
      %bb1a0_38 = "braid.eq"(%bb1a0_16, %bb1a0_36) : (i64, i64) -> i64
      "braid.setf"(%bb1a0_38) {flag = "zf"} : (i64) -> ()
      %bb1a0_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1a0_40 = "braid.and"(%bb1a0_16, %bb1a0_39) : (i64, i64) -> i64
      "braid.setf"(%bb1a0_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1a0_16) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br"()[^bb1a7] : () -> ()
    ^bb1a7:  // 0x4012a7
      %bb1a7_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1a7_1 = "braid.load"(%bb1a7_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1a7_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1a7_3 = "braid.add"(%bb1a7_0, %bb1a7_2) : (i64, i64) -> i64
      "braid.set"(%bb1a7_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb1a7_1) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb1a8] : () -> ()
    ^bb1a8:  // 0x4012a8
      %bb1a8_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1a8_1 = "braid.load"(%bb1a8_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1a8_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1a8_3 = "braid.add"(%bb1a8_0, %bb1a8_2) : (i64, i64) -> i64
      "braid.set"(%bb1a8_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb1a8_1) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb1aa] : () -> ()
    ^bb1aa:  // 0x4012aa
      %bb1aa_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1aa_1 = "braid.load"(%bb1aa_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1aa_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1aa_3 = "braid.add"(%bb1aa_0, %bb1aa_2) : (i64, i64) -> i64
      "braid.set"(%bb1aa_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb1aa_1) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb1ac] : () -> ()
    ^bb1ac:  // 0x4012ac
      %bb1ac_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1ac_1 = "braid.load"(%bb1ac_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1ac_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1ac_3 = "braid.add"(%bb1ac_0, %bb1ac_2) : (i64, i64) -> i64
      "braid.set"(%bb1ac_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb1ac_1) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb1ae] : () -> ()
    ^bb1ae:  // 0x4012ae
      %bb1ae_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1ae_1 = "braid.load"(%bb1ae_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1ae_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1ae_3 = "braid.add"(%bb1ae_0, %bb1ae_2) : (i64, i64) -> i64
      "braid.set"(%bb1ae_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb1ae_1) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb1af] : () -> ()
    ^bb1af:  // 0x4012af
      %bb1af_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1af_1 = "braid.load"(%bb1af_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1af_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1af_3 = "braid.add"(%bb1af_0, %bb1af_2) : (i64, i64) -> i64
      "braid.set"(%bb1af_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb1af_1) : (i64) -> ()
  }) {sym_name = "sha256_compress", entry = 4198656 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x4023b0
      %bb0_0 = "braid.const"() {value = 4205888 : i64} : () -> i64
      "braid.set"(%bb0_0) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br"()[^bb7] : () -> ()
    ^bb7:  // 0x4023b7
      "braid_cf.br"()[^ext4023c0] : () -> ()
    ^bbc:  // 0x4023bc
      "braid_cf.br"()[^ext4023c0] : () -> ()
    ^ext4023c0:
      "braid_cf.tail"() {target = 4203456 : i64} : () -> ()
  }) {sym_name = "_start", entry = 4203440 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x4023c0
      %bb0_0 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb0_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb0_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_10 = "braid.sub"(%bb0_8, %bb0_9) : (i64, i64) -> i64
      "braid.set"(%bb0_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb0_10, %bb0_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1] : () -> ()
    ^bb1:  // 0x4023c1
      %bb1_0 = "braid.get"() {reg = "r15"} : () -> i64
      %bb1_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1_10 = "braid.sub"(%bb1_8, %bb1_9) : (i64, i64) -> i64
      "braid.set"(%bb1_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb1_10, %bb1_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb3] : () -> ()
    ^bb3:  // 0x4023c3
      %bb3_0 = "braid.get"() {reg = "r14"} : () -> i64
      %bb3_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb3_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb3_10 = "braid.sub"(%bb3_8, %bb3_9) : (i64, i64) -> i64
      "braid.set"(%bb3_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb3_10, %bb3_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb5] : () -> ()
    ^bb5:  // 0x4023c5
      %bb5_0 = "braid.get"() {reg = "r13"} : () -> i64
      %bb5_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb5_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb5_10 = "braid.sub"(%bb5_8, %bb5_9) : (i64, i64) -> i64
      "braid.set"(%bb5_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb5_10, %bb5_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb7] : () -> ()
    ^bb7:  // 0x4023c7
      %bb7_0 = "braid.get"() {reg = "r12"} : () -> i64
      %bb7_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb7_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb7_10 = "braid.sub"(%bb7_8, %bb7_9) : (i64, i64) -> i64
      "braid.set"(%bb7_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb7_10, %bb7_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb9] : () -> ()
    ^bb9:  // 0x4023c9
      %bb9_0 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb9_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb9_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb9_10 = "braid.sub"(%bb9_8, %bb9_9) : (i64, i64) -> i64
      "braid.set"(%bb9_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb9_10, %bb9_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bba] : () -> ()
    ^bba:  // 0x4023ca
      %bba_0 = "braid.const"() {value = 152 : i64} : () -> i64
      %bba_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba_16 = "braid.sub"(%bba_8, %bba_0) : (i64, i64) -> i64
      %bba_18 = "braid.ult"(%bba_8, %bba_0) : (i64, i64) -> i64
      "braid.setf"(%bba_18) {flag = "cf"} : (i64) -> ()
      %bba_19 = "braid.xor"(%bba_8, %bba_0) : (i64, i64) -> i64
      %bba_20 = "braid.xor"(%bba_8, %bba_16) : (i64, i64) -> i64
      %bba_21 = "braid.and"(%bba_19, %bba_20) : (i64, i64) -> i64
      %bba_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bba_23 = "braid.and"(%bba_21, %bba_22) : (i64, i64) -> i64
      "braid.setf"(%bba_23) {flag = "of"} : (i64) -> ()
      %bba_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bba_24) {flag = "af"} : (i64) -> ()
      %bba_32 = "braid.zext"(%bba_16) {bits = 8 : i64} : (i64) -> i64
      %bba_33 = "braid.popcnt"(%bba_32) : (i64) -> i64
      %bba_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bba_35 = "braid.and"(%bba_33, %bba_34) : (i64, i64) -> i64
      %bba_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba_37 = "braid.eq"(%bba_35, %bba_36) : (i64, i64) -> i64
      "braid.setf"(%bba_37) {flag = "pf"} : (i64) -> ()
      %bba_38 = "braid.eq"(%bba_16, %bba_36) : (i64, i64) -> i64
      "braid.setf"(%bba_38) {flag = "zf"} : (i64) -> ()
      %bba_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bba_40 = "braid.and"(%bba_16, %bba_39) : (i64, i64) -> i64
      "braid.setf"(%bba_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bba_16) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br"()[^bb11] : () -> ()
    ^bb11:  // 0x4023d1
      %bb11_0 = "braid.const"() {value = 4205920 : i64} : () -> i64
      "braid.set"(%bb11_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x4023d8
      %bb18_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb18_0 = "braid.load"(%bb18_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb18_0) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb1b] : () -> ()
    ^bb1b:  // 0x4023db
      %bb1b_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb1b_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1b_0 = "braid.add"(%bb1b_1, %bb1b_2) : (i64, i64) -> i64
      "braid.set"(%bb1b_0) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb1f] : () -> ()
    ^bb1f:  // 0x4023df
      %bb1f_0 = "braid.get"() {reg = "r12"} : () -> i64
      "braid.set"(%bb1f_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb22] : () -> ()
    ^bb22:  // 0x4023e2
      %bb22_0 = "braid.get"() {reg = "r13"} : () -> i64
      %bb22_8 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb22_16 = "braid.and"(%bb22_0, %bb22_8) : (i64, i64) -> i64
      %bb22_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb22_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb22_17) {flag = "of"} : (i64) -> ()
      %bb22_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb22_24) {flag = "af"} : (i64) -> ()
      %bb22_32 = "braid.zext"(%bb22_16) {bits = 8 : i64} : (i64) -> i64
      %bb22_33 = "braid.popcnt"(%bb22_32) : (i64) -> i64
      %bb22_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb22_35 = "braid.and"(%bb22_33, %bb22_34) : (i64, i64) -> i64
      %bb22_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb22_37 = "braid.eq"(%bb22_35, %bb22_36) : (i64, i64) -> i64
      "braid.setf"(%bb22_37) {flag = "pf"} : (i64) -> ()
      %bb22_38 = "braid.eq"(%bb22_16, %bb22_36) : (i64, i64) -> i64
      "braid.setf"(%bb22_38) {flag = "zf"} : (i64) -> ()
      %bb22_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb22_40 = "braid.and"(%bb22_16, %bb22_39) : (i64, i64) -> i64
      "braid.setf"(%bb22_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb22_16) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb26] : () -> ()
    ^bb26:  // 0x4023e6
      %bb26_0 = "braid.get"() {reg = "r15"} : () -> i64
      "braid.set"(%bb26_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb29] : () -> ()
    ^bb29:  // 0x4023e9
      %bb29_0 = "braid.get"() {reg = "r13"} : () -> i64
      "braid.set"(%bb29_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x4023ec
      %bb2c_0 = "braid.const"() {value = -4942790177982912921 : i64} : () -> i64
      "braid.set"(%bb2c_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb36] : () -> ()
    ^bb36:  // 0x4023f6
      %bb36_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb36_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb36_10 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb36_8 = "braid.add"(%bb36_9, %bb36_10) : (i64, i64) -> i64
      "braid.store"(%bb36_8, %bb36_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb3b] : () -> ()
    ^bb3b:  // 0x4023fb
      %bb3b_0 = "braid.const"() {value = -6534734903820487822 : i64} : () -> i64
      "braid.set"(%bb3b_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb45] : () -> ()
    ^bb45:  // 0x402405
      %bb45_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb45_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb45_10 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb45_8 = "braid.add"(%bb45_9, %bb45_10) : (i64, i64) -> i64
      "braid.store"(%bb45_8, %bb45_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb4a] : () -> ()
    ^bb4a:  // 0x40240a
      %bb4a_0 = "braid.const"() {value = -7276294671082564993 : i64} : () -> i64
      "braid.set"(%bb4a_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x402414
      %bb54_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb54_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb54_10 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb54_8 = "braid.add"(%bb54_9, %bb54_10) : (i64, i64) -> i64
      "braid.store"(%bb54_8, %bb54_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb59] : () -> ()
    ^bb59:  // 0x402419
      %bb59_0 = "braid.const"() {value = 6620516960021240235 : i64} : () -> i64
      "braid.set"(%bb59_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb63] : () -> ()
    ^bb63:  // 0x402423
      %bb63_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb63_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb63_10 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb63_8 = "braid.add"(%bb63_9, %bb63_10) : (i64, i64) -> i64
      "braid.store"(%bb63_8, %bb63_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x402428
      %bb68_0 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb68_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb68_16 = "braid.add"(%bb68_0, %bb68_8) : (i64, i64) -> i64
      %bb68_18 = "braid.ult"(%bb68_16, %bb68_0) : (i64, i64) -> i64
      "braid.setf"(%bb68_18) {flag = "cf"} : (i64) -> ()
      %bb68_19 = "braid.xor"(%bb68_0, %bb68_16) : (i64, i64) -> i64
      %bb68_20 = "braid.xor"(%bb68_8, %bb68_16) : (i64, i64) -> i64
      %bb68_21 = "braid.and"(%bb68_19, %bb68_20) : (i64, i64) -> i64
      %bb68_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb68_23 = "braid.and"(%bb68_21, %bb68_22) : (i64, i64) -> i64
      "braid.setf"(%bb68_23) {flag = "of"} : (i64) -> ()
      %bb68_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb68_24) {flag = "af"} : (i64) -> ()
      %bb68_32 = "braid.zext"(%bb68_16) {bits = 8 : i64} : (i64) -> i64
      %bb68_33 = "braid.popcnt"(%bb68_32) : (i64) -> i64
      %bb68_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb68_35 = "braid.and"(%bb68_33, %bb68_34) : (i64, i64) -> i64
      %bb68_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb68_37 = "braid.eq"(%bb68_35, %bb68_36) : (i64, i64) -> i64
      "braid.setf"(%bb68_37) {flag = "pf"} : (i64) -> ()
      %bb68_38 = "braid.eq"(%bb68_16, %bb68_36) : (i64, i64) -> i64
      "braid.setf"(%bb68_38) {flag = "zf"} : (i64) -> ()
      %bb68_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb68_40 = "braid.and"(%bb68_16, %bb68_39) : (i64, i64) -> i64
      "braid.setf"(%bb68_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb68_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x40242c
      %bb6c_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb6c_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb6c_10 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb6c_8 = "braid.add"(%bb6c_9, %bb6c_10) : (i64, i64) -> i64
      "braid.store"(%bb6c_8, %bb6c_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb71] : () -> ()
    ^bb71:  // 0x402431
      %bb71_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb71_0)[^bb12a, ^bb77] : (i64) -> ()
    ^bb77:  // 0x402437
      %bb77_0 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb77_8 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb77_9 = "braid.shl"(%bb77_0, %bb77_8) : (i64, i64) -> i64
      %bb77_11 = "braid.const"() {value = 61 : i64} : () -> i64
      %bb77_12 = "braid.lshr"(%bb77_0, %bb77_11) : (i64, i64) -> i64
      %bb77_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb77_14 = "braid.and"(%bb77_12, %bb77_13) : (i64, i64) -> i64
      "braid.setf"(%bb77_14) {flag = "cf"} : (i64) -> ()
      %bb77_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb77_17) {flag = "of"} : (i64) -> ()
      %bb77_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb77_24) {flag = "af"} : (i64) -> ()
      %bb77_32 = "braid.zext"(%bb77_9) {bits = 8 : i64} : (i64) -> i64
      %bb77_33 = "braid.popcnt"(%bb77_32) : (i64) -> i64
      %bb77_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb77_35 = "braid.and"(%bb77_33, %bb77_34) : (i64, i64) -> i64
      %bb77_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb77_37 = "braid.eq"(%bb77_35, %bb77_36) : (i64, i64) -> i64
      "braid.setf"(%bb77_37) {flag = "pf"} : (i64) -> ()
      %bb77_38 = "braid.eq"(%bb77_9, %bb77_36) : (i64, i64) -> i64
      "braid.setf"(%bb77_38) {flag = "zf"} : (i64) -> ()
      %bb77_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb77_40 = "braid.and"(%bb77_9, %bb77_39) : (i64, i64) -> i64
      "braid.setf"(%bb77_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb77_9) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb7b] : () -> ()
    ^bb7b:  // 0x40243b
      %bb7b_0 = "braid.get"() {reg = "r13"} : () -> i64
      %bb7b_8 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb7b_16 = "braid.or"(%bb7b_0, %bb7b_8) : (i64, i64) -> i64
      %bb7b_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb7b_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb7b_17) {flag = "of"} : (i64) -> ()
      %bb7b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb7b_24) {flag = "af"} : (i64) -> ()
      %bb7b_32 = "braid.zext"(%bb7b_16) {bits = 8 : i64} : (i64) -> i64
      %bb7b_33 = "braid.popcnt"(%bb7b_32) : (i64) -> i64
      %bb7b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb7b_35 = "braid.and"(%bb7b_33, %bb7b_34) : (i64, i64) -> i64
      %bb7b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7b_37 = "braid.eq"(%bb7b_35, %bb7b_36) : (i64, i64) -> i64
      "braid.setf"(%bb7b_37) {flag = "pf"} : (i64) -> ()
      %bb7b_38 = "braid.eq"(%bb7b_16, %bb7b_36) : (i64, i64) -> i64
      "braid.setf"(%bb7b_38) {flag = "zf"} : (i64) -> ()
      %bb7b_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb7b_40 = "braid.and"(%bb7b_16, %bb7b_39) : (i64, i64) -> i64
      "braid.setf"(%bb7b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb7b_16) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb7f] : () -> ()
    ^bb7f:  // 0x40243f
      %bb7f_0 = "braid.get"() {reg = "r12"} : () -> i64
      %bb7f_8 = "braid.const"() {value = 63 : i64} : () -> i64
      %bb7f_16 = "braid.or"(%bb7f_0, %bb7f_8) : (i64, i64) -> i64
      %bb7f_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb7f_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb7f_17) {flag = "of"} : (i64) -> ()
      %bb7f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb7f_24) {flag = "af"} : (i64) -> ()
      %bb7f_32 = "braid.zext"(%bb7f_16) {bits = 8 : i64} : (i64) -> i64
      %bb7f_33 = "braid.popcnt"(%bb7f_32) : (i64) -> i64
      %bb7f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb7f_35 = "braid.and"(%bb7f_33, %bb7f_34) : (i64, i64) -> i64
      %bb7f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7f_37 = "braid.eq"(%bb7f_35, %bb7f_36) : (i64, i64) -> i64
      "braid.setf"(%bb7f_37) {flag = "pf"} : (i64) -> ()
      %bb7f_38 = "braid.eq"(%bb7f_16, %bb7f_36) : (i64, i64) -> i64
      "braid.setf"(%bb7f_38) {flag = "zf"} : (i64) -> ()
      %bb7f_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb7f_40 = "braid.and"(%bb7f_16, %bb7f_39) : (i64, i64) -> i64
      "braid.setf"(%bb7f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb7f_16) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb83] : () -> ()
    ^bb83:  // 0x402443
      %bb83_0 = "braid.get"() {reg = "r12"} : () -> i64
      %bb83_8 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb83_9 = "braid.shl"(%bb83_0, %bb83_8) : (i64, i64) -> i64
      %bb83_11 = "braid.const"() {value = 61 : i64} : () -> i64
      %bb83_12 = "braid.lshr"(%bb83_0, %bb83_11) : (i64, i64) -> i64
      %bb83_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb83_14 = "braid.and"(%bb83_12, %bb83_13) : (i64, i64) -> i64
      "braid.setf"(%bb83_14) {flag = "cf"} : (i64) -> ()
      %bb83_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb83_17) {flag = "of"} : (i64) -> ()
      %bb83_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb83_24) {flag = "af"} : (i64) -> ()
      %bb83_32 = "braid.zext"(%bb83_9) {bits = 8 : i64} : (i64) -> i64
      %bb83_33 = "braid.popcnt"(%bb83_32) : (i64) -> i64
      %bb83_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb83_35 = "braid.and"(%bb83_33, %bb83_34) : (i64, i64) -> i64
      %bb83_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb83_37 = "braid.eq"(%bb83_35, %bb83_36) : (i64, i64) -> i64
      "braid.setf"(%bb83_37) {flag = "pf"} : (i64) -> ()
      %bb83_38 = "braid.eq"(%bb83_9, %bb83_36) : (i64, i64) -> i64
      "braid.setf"(%bb83_38) {flag = "zf"} : (i64) -> ()
      %bb83_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb83_40 = "braid.and"(%bb83_9, %bb83_39) : (i64, i64) -> i64
      "braid.setf"(%bb83_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb83_9) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb87] : () -> ()
    ^bb87:  // 0x402447
      %bb87_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb87_0 = "braid.zext"(%bb87_1) {bits = 32 : i64} : (i64) -> i64
      %bb87_9 = "braid.get"() {reg = "r14"} : () -> i64
      %bb87_8 = "braid.zext"(%bb87_9) {bits = 32 : i64} : (i64) -> i64
      %bb87_16 = "braid.xor"(%bb87_0, %bb87_8) : (i64, i64) -> i64
      %bb87_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb87_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb87_17) {flag = "of"} : (i64) -> ()
      %bb87_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb87_24) {flag = "af"} : (i64) -> ()
      %bb87_32 = "braid.zext"(%bb87_16) {bits = 8 : i64} : (i64) -> i64
      %bb87_33 = "braid.popcnt"(%bb87_32) : (i64) -> i64
      %bb87_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb87_35 = "braid.and"(%bb87_33, %bb87_34) : (i64, i64) -> i64
      %bb87_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb87_37 = "braid.eq"(%bb87_35, %bb87_36) : (i64, i64) -> i64
      "braid.setf"(%bb87_37) {flag = "pf"} : (i64) -> ()
      %bb87_38 = "braid.eq"(%bb87_16, %bb87_36) : (i64, i64) -> i64
      "braid.setf"(%bb87_38) {flag = "zf"} : (i64) -> ()
      %bb87_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb87_40 = "braid.and"(%bb87_16, %bb87_39) : (i64, i64) -> i64
      "braid.setf"(%bb87_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb87_16) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb8a] : () -> ()
    ^bb8a:  // 0x40244a
      %bb8a_0 = "braid.const"() {value = 4205928 : i64} : () -> i64
      "braid.set"(%bb8a_0) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb91] : () -> ()
    ^bb91:  // 0x402451
      "braid_cf.br"()[^bbc1] : () -> ()
    ^bb93:  // 0x402453
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x402460
      %bba0_1 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba0_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bba0_0 = "braid.add"(%bba0_1, %bba0_2) : (i64, i64) -> i64
      "braid.set"(%bba0_0) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bba5] : () -> ()
    ^bba5:  // 0x402465
      %bba5_1 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba5_2 = "braid.const"() {value = 80 : i64} : () -> i64
      %bba5_0 = "braid.add"(%bba5_1, %bba5_2) : (i64, i64) -> i64
      "braid.set"(%bba5_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bbaa] : () -> ()
    ^bbaa:  // 0x40246a
      %bbaa_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbaa_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbaa_10 = "braid.sub"(%bbaa_8, %bbaa_9) : (i64, i64) -> i64
      "braid.set"(%bbaa_10) {reg = "rsp"} : (i64) -> ()
      %bbaa_11 = "braid.const"() {value = 4203631 : i64} : () -> i64
      "braid.store"(%bbaa_10, %bbaa_11) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^ext401100] : () -> ()
    ^bbaf:  // 0x40246f
      %bbaf_0 = "braid.const"() {value = 64 : i64} : () -> i64
      %bbaf_8 = "braid.get"() {reg = "r14"} : () -> i64
      %bbaf_16 = "braid.add"(%bbaf_0, %bbaf_8) : (i64, i64) -> i64
      %bbaf_18 = "braid.ult"(%bbaf_16, %bbaf_0) : (i64, i64) -> i64
      "braid.setf"(%bbaf_18) {flag = "cf"} : (i64) -> ()
      %bbaf_19 = "braid.xor"(%bbaf_0, %bbaf_16) : (i64, i64) -> i64
      %bbaf_20 = "braid.xor"(%bbaf_8, %bbaf_16) : (i64, i64) -> i64
      %bbaf_21 = "braid.and"(%bbaf_19, %bbaf_20) : (i64, i64) -> i64
      %bbaf_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbaf_23 = "braid.and"(%bbaf_21, %bbaf_22) : (i64, i64) -> i64
      "braid.setf"(%bbaf_23) {flag = "of"} : (i64) -> ()
      %bbaf_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbaf_24) {flag = "af"} : (i64) -> ()
      %bbaf_32 = "braid.zext"(%bbaf_16) {bits = 8 : i64} : (i64) -> i64
      %bbaf_33 = "braid.popcnt"(%bbaf_32) : (i64) -> i64
      %bbaf_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbaf_35 = "braid.and"(%bbaf_33, %bbaf_34) : (i64, i64) -> i64
      %bbaf_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbaf_37 = "braid.eq"(%bbaf_35, %bbaf_36) : (i64, i64) -> i64
      "braid.setf"(%bbaf_37) {flag = "pf"} : (i64) -> ()
      %bbaf_38 = "braid.eq"(%bbaf_16, %bbaf_36) : (i64, i64) -> i64
      "braid.setf"(%bbaf_38) {flag = "zf"} : (i64) -> ()
      %bbaf_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbaf_40 = "braid.and"(%bbaf_16, %bbaf_39) : (i64, i64) -> i64
      "braid.setf"(%bbaf_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbaf_16) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bbb3] : () -> ()
    ^bbb3:  // 0x402473
      %bbb3_0 = "braid.const"() {value = -512 : i64} : () -> i64
      %bbb3_8 = "braid.get"() {reg = "r12"} : () -> i64
      %bbb3_16 = "braid.add"(%bbb3_0, %bbb3_8) : (i64, i64) -> i64
      %bbb3_18 = "braid.ult"(%bbb3_16, %bbb3_0) : (i64, i64) -> i64
      "braid.setf"(%bbb3_18) {flag = "cf"} : (i64) -> ()
      %bbb3_19 = "braid.xor"(%bbb3_0, %bbb3_16) : (i64, i64) -> i64
      %bbb3_20 = "braid.xor"(%bbb3_8, %bbb3_16) : (i64, i64) -> i64
      %bbb3_21 = "braid.and"(%bbb3_19, %bbb3_20) : (i64, i64) -> i64
      %bbb3_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbb3_23 = "braid.and"(%bbb3_21, %bbb3_22) : (i64, i64) -> i64
      "braid.setf"(%bbb3_23) {flag = "of"} : (i64) -> ()
      %bbb3_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbb3_24) {flag = "af"} : (i64) -> ()
      %bbb3_32 = "braid.zext"(%bbb3_16) {bits = 8 : i64} : (i64) -> i64
      %bbb3_33 = "braid.popcnt"(%bbb3_32) : (i64) -> i64
      %bbb3_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbb3_35 = "braid.and"(%bbb3_33, %bbb3_34) : (i64, i64) -> i64
      %bbb3_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb3_37 = "braid.eq"(%bbb3_35, %bbb3_36) : (i64, i64) -> i64
      "braid.setf"(%bbb3_37) {flag = "pf"} : (i64) -> ()
      %bbb3_38 = "braid.eq"(%bbb3_16, %bbb3_36) : (i64, i64) -> i64
      "braid.setf"(%bbb3_38) {flag = "zf"} : (i64) -> ()
      %bbb3_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbb3_40 = "braid.and"(%bbb3_16, %bbb3_39) : (i64, i64) -> i64
      "braid.setf"(%bbb3_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbb3_16) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bbba] : () -> ()
    ^bbba:  // 0x40247a
      %bbba_0 = "braid.get"() {reg = "r14"} : () -> i64
      %bbba_10 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbba_11 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbba_9 = "braid.add"(%bbba_10, %bbba_11) : (i64, i64) -> i64
      %bbba_8 = "braid.load"(%bbba_9) {bytes = 8 : i64} : (i64) -> i64
      %bbba_16 = "braid.sub"(%bbba_0, %bbba_8) : (i64, i64) -> i64
      %bbba_18 = "braid.ult"(%bbba_0, %bbba_8) : (i64, i64) -> i64
      "braid.setf"(%bbba_18) {flag = "cf"} : (i64) -> ()
      %bbba_19 = "braid.xor"(%bbba_0, %bbba_8) : (i64, i64) -> i64
      %bbba_20 = "braid.xor"(%bbba_0, %bbba_16) : (i64, i64) -> i64
      %bbba_21 = "braid.and"(%bbba_19, %bbba_20) : (i64, i64) -> i64
      %bbba_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbba_23 = "braid.and"(%bbba_21, %bbba_22) : (i64, i64) -> i64
      "braid.setf"(%bbba_23) {flag = "of"} : (i64) -> ()
      %bbba_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbba_24) {flag = "af"} : (i64) -> ()
      %bbba_32 = "braid.zext"(%bbba_16) {bits = 8 : i64} : (i64) -> i64
      %bbba_33 = "braid.popcnt"(%bbba_32) : (i64) -> i64
      %bbba_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbba_35 = "braid.and"(%bbba_33, %bbba_34) : (i64, i64) -> i64
      %bbba_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbba_37 = "braid.eq"(%bbba_35, %bbba_36) : (i64, i64) -> i64
      "braid.setf"(%bbba_37) {flag = "pf"} : (i64) -> ()
      %bbba_38 = "braid.eq"(%bbba_16, %bbba_36) : (i64, i64) -> i64
      "braid.setf"(%bbba_38) {flag = "zf"} : (i64) -> ()
      %bbba_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbba_40 = "braid.and"(%bbba_16, %bbba_39) : (i64, i64) -> i64
      "braid.setf"(%bbba_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bbbf] : () -> ()
    ^bbbf:  // 0x40247f
      %bbbf_1 = "braid.getf"() {flag = "cf"} : () -> i64
      %bbbf_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbbf_0 = "braid.eq"(%bbbf_1, %bbbf_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bbbf_0)[^bb12a, ^bbc1] : (i64) -> ()
    ^bbc1:  // 0x402481
      %bbc1_0 = "braid.get"() {reg = "r14"} : () -> i64
      "braid.set"(%bbc1_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x402484
      %bbc4_0 = "braid.get"() {reg = "r12"} : () -> i64
      "braid.set"(%bbc4_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bbc7] : () -> ()
    ^bbc7:  // 0x402487
      %bbc7_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbc7_0 = "braid.zext"(%bbc7_1) {bits = 32 : i64} : (i64) -> i64
      %bbc7_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbc7_8 = "braid.zext"(%bbc7_9) {bits = 32 : i64} : (i64) -> i64
      %bbc7_16 = "braid.xor"(%bbc7_0, %bbc7_8) : (i64, i64) -> i64
      %bbc7_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbc7_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbc7_17) {flag = "of"} : (i64) -> ()
      %bbc7_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc7_24) {flag = "af"} : (i64) -> ()
      %bbc7_32 = "braid.zext"(%bbc7_16) {bits = 8 : i64} : (i64) -> i64
      %bbc7_33 = "braid.popcnt"(%bbc7_32) : (i64) -> i64
      %bbc7_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc7_35 = "braid.and"(%bbc7_33, %bbc7_34) : (i64, i64) -> i64
      %bbc7_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc7_37 = "braid.eq"(%bbc7_35, %bbc7_36) : (i64, i64) -> i64
      "braid.setf"(%bbc7_37) {flag = "pf"} : (i64) -> ()
      %bbc7_38 = "braid.eq"(%bbc7_16, %bbc7_36) : (i64, i64) -> i64
      "braid.setf"(%bbc7_38) {flag = "zf"} : (i64) -> ()
      %bbc7_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbc7_40 = "braid.and"(%bbc7_16, %bbc7_39) : (i64, i64) -> i64
      "braid.setf"(%bbc7_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbc7_16) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bbc9] : () -> ()
    ^bbc9:  // 0x402489
      "braid_cf.br"()[^bbe5] : () -> ()
    ^bbcb:  // 0x40248b
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x402490
      %bbd0_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbd0_0 = "braid.zext"(%bbd0_1) {bits = 32 : i64} : (i64) -> i64
      %bbd0_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbd0_10 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbd0_11 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbd0_12 = "braid.mul"(%bbd0_10, %bbd0_11) : (i64, i64) -> i64
      %bbd0_13 = "braid.add"(%bbd0_9, %bbd0_12) : (i64, i64) -> i64
      %bbd0_14 = "braid.const"() {value = 80 : i64} : () -> i64
      %bbd0_8 = "braid.add"(%bbd0_13, %bbd0_14) : (i64, i64) -> i64
      "braid.store"(%bbd0_8, %bbd0_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x402494
      %bbd4_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbd4_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd4_16 = "braid.add"(%bbd4_0, %bbd4_8) : (i64, i64) -> i64
      %bbd4_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbd4_20 = "braid.eq"(%bbd4_16, %bbd4_19) : (i64, i64) -> i64
      "braid.setf"(%bbd4_20) {flag = "of"} : (i64) -> ()
      %bbd4_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbd4_24) {flag = "af"} : (i64) -> ()
      %bbd4_32 = "braid.zext"(%bbd4_16) {bits = 8 : i64} : (i64) -> i64
      %bbd4_33 = "braid.popcnt"(%bbd4_32) : (i64) -> i64
      %bbd4_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd4_35 = "braid.and"(%bbd4_33, %bbd4_34) : (i64, i64) -> i64
      %bbd4_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd4_37 = "braid.eq"(%bbd4_35, %bbd4_36) : (i64, i64) -> i64
      "braid.setf"(%bbd4_37) {flag = "pf"} : (i64) -> ()
      %bbd4_38 = "braid.eq"(%bbd4_16, %bbd4_36) : (i64, i64) -> i64
      "braid.setf"(%bbd4_38) {flag = "zf"} : (i64) -> ()
      %bbd4_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbd4_40 = "braid.and"(%bbd4_16, %bbd4_39) : (i64, i64) -> i64
      "braid.setf"(%bbd4_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbd4_16) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bbd7] : () -> ()
    ^bbd7:  // 0x402497
      %bbd7_0 = "braid.const"() {value = -32 : i64} : () -> i64
      %bbd7_8 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbd7_16 = "braid.add"(%bbd7_0, %bbd7_8) : (i64, i64) -> i64
      %bbd7_18 = "braid.ult"(%bbd7_16, %bbd7_0) : (i64, i64) -> i64
      "braid.setf"(%bbd7_18) {flag = "cf"} : (i64) -> ()
      %bbd7_19 = "braid.xor"(%bbd7_0, %bbd7_16) : (i64, i64) -> i64
      %bbd7_20 = "braid.xor"(%bbd7_8, %bbd7_16) : (i64, i64) -> i64
      %bbd7_21 = "braid.and"(%bbd7_19, %bbd7_20) : (i64, i64) -> i64
      %bbd7_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbd7_23 = "braid.and"(%bbd7_21, %bbd7_22) : (i64, i64) -> i64
      "braid.setf"(%bbd7_23) {flag = "of"} : (i64) -> ()
      %bbd7_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbd7_24) {flag = "af"} : (i64) -> ()
      %bbd7_32 = "braid.zext"(%bbd7_16) {bits = 8 : i64} : (i64) -> i64
      %bbd7_33 = "braid.popcnt"(%bbd7_32) : (i64) -> i64
      %bbd7_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd7_35 = "braid.and"(%bbd7_33, %bbd7_34) : (i64, i64) -> i64
      %bbd7_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd7_37 = "braid.eq"(%bbd7_35, %bbd7_36) : (i64, i64) -> i64
      "braid.setf"(%bbd7_37) {flag = "pf"} : (i64) -> ()
      %bbd7_38 = "braid.eq"(%bbd7_16, %bbd7_36) : (i64, i64) -> i64
      "braid.setf"(%bbd7_38) {flag = "zf"} : (i64) -> ()
      %bbd7_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbd7_40 = "braid.and"(%bbd7_16, %bbd7_39) : (i64, i64) -> i64
      "braid.setf"(%bbd7_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbd7_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bbdb] : () -> ()
    ^bbdb:  // 0x40249b
      %bbdb_0 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbdb_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bbdb_16 = "braid.add"(%bbdb_0, %bbdb_8) : (i64, i64) -> i64
      %bbdb_18 = "braid.ult"(%bbdb_16, %bbdb_0) : (i64, i64) -> i64
      "braid.setf"(%bbdb_18) {flag = "cf"} : (i64) -> ()
      %bbdb_19 = "braid.xor"(%bbdb_0, %bbdb_16) : (i64, i64) -> i64
      %bbdb_20 = "braid.xor"(%bbdb_8, %bbdb_16) : (i64, i64) -> i64
      %bbdb_21 = "braid.and"(%bbdb_19, %bbdb_20) : (i64, i64) -> i64
      %bbdb_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbdb_23 = "braid.and"(%bbdb_21, %bbdb_22) : (i64, i64) -> i64
      "braid.setf"(%bbdb_23) {flag = "of"} : (i64) -> ()
      %bbdb_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbdb_24) {flag = "af"} : (i64) -> ()
      %bbdb_32 = "braid.zext"(%bbdb_16) {bits = 8 : i64} : (i64) -> i64
      %bbdb_33 = "braid.popcnt"(%bbdb_32) : (i64) -> i64
      %bbdb_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbdb_35 = "braid.and"(%bbdb_33, %bbdb_34) : (i64, i64) -> i64
      %bbdb_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbdb_37 = "braid.eq"(%bbdb_35, %bbdb_36) : (i64, i64) -> i64
      "braid.setf"(%bbdb_37) {flag = "pf"} : (i64) -> ()
      %bbdb_38 = "braid.eq"(%bbdb_16, %bbdb_36) : (i64, i64) -> i64
      "braid.setf"(%bbdb_38) {flag = "zf"} : (i64) -> ()
      %bbdb_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbdb_40 = "braid.and"(%bbdb_16, %bbdb_39) : (i64, i64) -> i64
      "braid.setf"(%bbdb_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbdb_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbdf] : () -> ()
    ^bbdf:  // 0x40249f
      %bbdf_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbdf_8 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbdf_16 = "braid.sub"(%bbdf_0, %bbdf_8) : (i64, i64) -> i64
      %bbdf_18 = "braid.ult"(%bbdf_0, %bbdf_8) : (i64, i64) -> i64
      "braid.setf"(%bbdf_18) {flag = "cf"} : (i64) -> ()
      %bbdf_19 = "braid.xor"(%bbdf_0, %bbdf_8) : (i64, i64) -> i64
      %bbdf_20 = "braid.xor"(%bbdf_0, %bbdf_16) : (i64, i64) -> i64
      %bbdf_21 = "braid.and"(%bbdf_19, %bbdf_20) : (i64, i64) -> i64
      %bbdf_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbdf_23 = "braid.and"(%bbdf_21, %bbdf_22) : (i64, i64) -> i64
      "braid.setf"(%bbdf_23) {flag = "of"} : (i64) -> ()
      %bbdf_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbdf_24) {flag = "af"} : (i64) -> ()
      %bbdf_32 = "braid.zext"(%bbdf_16) {bits = 8 : i64} : (i64) -> i64
      %bbdf_33 = "braid.popcnt"(%bbdf_32) : (i64) -> i64
      %bbdf_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbdf_35 = "braid.and"(%bbdf_33, %bbdf_34) : (i64, i64) -> i64
      %bbdf_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbdf_37 = "braid.eq"(%bbdf_35, %bbdf_36) : (i64, i64) -> i64
      "braid.setf"(%bbdf_37) {flag = "pf"} : (i64) -> ()
      %bbdf_38 = "braid.eq"(%bbdf_16, %bbdf_36) : (i64, i64) -> i64
      "braid.setf"(%bbdf_38) {flag = "zf"} : (i64) -> ()
      %bbdf_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbdf_40 = "braid.and"(%bbdf_16, %bbdf_39) : (i64, i64) -> i64
      "braid.setf"(%bbdf_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bbe3] : () -> ()
    ^bbe3:  // 0x4024a3
      %bbe3_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bbe3_0)[^bba0, ^bbe5] : (i64) -> ()
    ^bbe5:  // 0x4024a5
      %bbe5_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbe5_0 = "braid.zext"(%bbe5_1) {bits = 32 : i64} : (i64) -> i64
      %bbe5_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbe5_8 = "braid.zext"(%bbe5_9) {bits = 32 : i64} : (i64) -> i64
      %bbe5_16 = "braid.xor"(%bbe5_0, %bbe5_8) : (i64, i64) -> i64
      %bbe5_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbe5_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbe5_17) {flag = "of"} : (i64) -> ()
      %bbe5_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbe5_24) {flag = "af"} : (i64) -> ()
      %bbe5_32 = "braid.zext"(%bbe5_16) {bits = 8 : i64} : (i64) -> i64
      %bbe5_33 = "braid.popcnt"(%bbe5_32) : (i64) -> i64
      %bbe5_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbe5_35 = "braid.and"(%bbe5_33, %bbe5_34) : (i64, i64) -> i64
      %bbe5_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe5_37 = "braid.eq"(%bbe5_35, %bbe5_36) : (i64, i64) -> i64
      "braid.setf"(%bbe5_37) {flag = "pf"} : (i64) -> ()
      %bbe5_38 = "braid.eq"(%bbe5_16, %bbe5_36) : (i64, i64) -> i64
      "braid.setf"(%bbe5_38) {flag = "zf"} : (i64) -> ()
      %bbe5_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbe5_40 = "braid.and"(%bbe5_16, %bbe5_39) : (i64, i64) -> i64
      "braid.setf"(%bbe5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbe5_16) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bbe7] : () -> ()
    ^bbe7:  // 0x4024a7
      %bbe7_0 = "braid.get"() {reg = "rax"} : () -> i64
      "braid.set"(%bbe7_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bbea] : () -> ()
    ^bbea:  // 0x4024aa
      %bbea_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bbea_0 = "braid.zext"(%bbea_1) {bits = 32 : i64} : (i64) -> i64
      %bbea_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bbea_8 = "braid.zext"(%bbea_9) {bits = 32 : i64} : (i64) -> i64
      %bbea_16 = "braid.xor"(%bbea_0, %bbea_8) : (i64, i64) -> i64
      %bbea_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbea_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbea_17) {flag = "of"} : (i64) -> ()
      %bbea_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbea_24) {flag = "af"} : (i64) -> ()
      %bbea_32 = "braid.zext"(%bbea_16) {bits = 8 : i64} : (i64) -> i64
      %bbea_33 = "braid.popcnt"(%bbea_32) : (i64) -> i64
      %bbea_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbea_35 = "braid.and"(%bbea_33, %bbea_34) : (i64, i64) -> i64
      %bbea_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbea_37 = "braid.eq"(%bbea_35, %bbea_36) : (i64, i64) -> i64
      "braid.setf"(%bbea_37) {flag = "pf"} : (i64) -> ()
      %bbea_38 = "braid.eq"(%bbea_16, %bbea_36) : (i64, i64) -> i64
      "braid.setf"(%bbea_38) {flag = "zf"} : (i64) -> ()
      %bbea_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbea_40 = "braid.and"(%bbea_16, %bbea_39) : (i64, i64) -> i64
      "braid.setf"(%bbea_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbea_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bbed] : () -> ()
    ^bbed:  // 0x4024ad
      "braid_cf.br"()[^bb107] : () -> ()
    ^bbef:  // 0x4024af
      "braid_cf.br"()[^bbf0] : () -> ()
    ^bbf0:  // 0x4024b0
      %bbf0_2 = "braid.get"() {reg = "rbx"} : () -> i64
      %bbf0_3 = "braid.get"() {reg = "r8"} : () -> i64
      %bbf0_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf0_5 = "braid.mul"(%bbf0_3, %bbf0_4) : (i64, i64) -> i64
      %bbf0_6 = "braid.add"(%bbf0_2, %bbf0_5) : (i64, i64) -> i64
      %bbf0_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf0_1 = "braid.add"(%bbf0_6, %bbf0_7) : (i64, i64) -> i64
      %bbf0_0 = "braid.load"(%bbf0_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bbf0_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbf5] : () -> ()
    ^bbf5:  // 0x4024b5
      %bbf5_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbf5_0 = "braid.zext"(%bbf5_1) {bits = 32 : i64} : (i64) -> i64
      %bbf5_8 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbf5_9 = "braid.shl"(%bbf5_0, %bbf5_8) : (i64, i64) -> i64
      %bbf5_10 = "braid.zext"(%bbf5_9) {bits = 32 : i64} : (i64) -> i64
      %bbf5_11 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbf5_12 = "braid.lshr"(%bbf5_0, %bbf5_11) : (i64, i64) -> i64
      %bbf5_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf5_14 = "braid.and"(%bbf5_12, %bbf5_13) : (i64, i64) -> i64
      "braid.setf"(%bbf5_14) {flag = "cf"} : (i64) -> ()
      %bbf5_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbf5_17) {flag = "of"} : (i64) -> ()
      %bbf5_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbf5_24) {flag = "af"} : (i64) -> ()
      %bbf5_32 = "braid.zext"(%bbf5_10) {bits = 8 : i64} : (i64) -> i64
      %bbf5_33 = "braid.popcnt"(%bbf5_32) : (i64) -> i64
      %bbf5_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf5_35 = "braid.and"(%bbf5_33, %bbf5_34) : (i64, i64) -> i64
      %bbf5_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf5_37 = "braid.eq"(%bbf5_35, %bbf5_36) : (i64, i64) -> i64
      "braid.setf"(%bbf5_37) {flag = "pf"} : (i64) -> ()
      %bbf5_38 = "braid.eq"(%bbf5_10, %bbf5_36) : (i64, i64) -> i64
      "braid.setf"(%bbf5_38) {flag = "zf"} : (i64) -> ()
      %bbf5_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbf5_40 = "braid.and"(%bbf5_10, %bbf5_39) : (i64, i64) -> i64
      "braid.setf"(%bbf5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbf5_10) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bbf8] : () -> ()
    ^bbf8:  // 0x4024b8
      %bbf8_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbf8_0 = "braid.zext"(%bbf8_1) {bits = 32 : i64} : (i64) -> i64
      %bbf8_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbf8_8 = "braid.zext"(%bbf8_9) {bits = 32 : i64} : (i64) -> i64
      %bbf8_16 = "braid.or"(%bbf8_0, %bbf8_8) : (i64, i64) -> i64
      %bbf8_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbf8_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbf8_17) {flag = "of"} : (i64) -> ()
      %bbf8_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbf8_24) {flag = "af"} : (i64) -> ()
      %bbf8_32 = "braid.zext"(%bbf8_16) {bits = 8 : i64} : (i64) -> i64
      %bbf8_33 = "braid.popcnt"(%bbf8_32) : (i64) -> i64
      %bbf8_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf8_35 = "braid.and"(%bbf8_33, %bbf8_34) : (i64, i64) -> i64
      %bbf8_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf8_37 = "braid.eq"(%bbf8_35, %bbf8_36) : (i64, i64) -> i64
      "braid.setf"(%bbf8_37) {flag = "pf"} : (i64) -> ()
      %bbf8_38 = "braid.eq"(%bbf8_16, %bbf8_36) : (i64, i64) -> i64
      "braid.setf"(%bbf8_38) {flag = "zf"} : (i64) -> ()
      %bbf8_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbf8_40 = "braid.and"(%bbf8_16, %bbf8_39) : (i64, i64) -> i64
      "braid.setf"(%bbf8_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbf8_16) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bbfa] : () -> ()
    ^bbfa:  // 0x4024ba
      %bbfa_0 = "braid.const"() {value = -8 : i64} : () -> i64
      %bbfa_8 = "braid.get"() {reg = "r9"} : () -> i64
      %bbfa_16 = "braid.add"(%bbfa_0, %bbfa_8) : (i64, i64) -> i64
      %bbfa_18 = "braid.ult"(%bbfa_16, %bbfa_0) : (i64, i64) -> i64
      "braid.setf"(%bbfa_18) {flag = "cf"} : (i64) -> ()
      %bbfa_19 = "braid.xor"(%bbfa_0, %bbfa_16) : (i64, i64) -> i64
      %bbfa_20 = "braid.xor"(%bbfa_8, %bbfa_16) : (i64, i64) -> i64
      %bbfa_21 = "braid.and"(%bbfa_19, %bbfa_20) : (i64, i64) -> i64
      %bbfa_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbfa_23 = "braid.and"(%bbfa_21, %bbfa_22) : (i64, i64) -> i64
      "braid.setf"(%bbfa_23) {flag = "of"} : (i64) -> ()
      %bbfa_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbfa_24) {flag = "af"} : (i64) -> ()
      %bbfa_32 = "braid.zext"(%bbfa_16) {bits = 8 : i64} : (i64) -> i64
      %bbfa_33 = "braid.popcnt"(%bbfa_32) : (i64) -> i64
      %bbfa_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbfa_35 = "braid.and"(%bbfa_33, %bbfa_34) : (i64, i64) -> i64
      %bbfa_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbfa_37 = "braid.eq"(%bbfa_35, %bbfa_36) : (i64, i64) -> i64
      "braid.setf"(%bbfa_37) {flag = "pf"} : (i64) -> ()
      %bbfa_38 = "braid.eq"(%bbfa_16, %bbfa_36) : (i64, i64) -> i64
      "braid.setf"(%bbfa_38) {flag = "zf"} : (i64) -> ()
      %bbfa_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbfa_40 = "braid.and"(%bbfa_16, %bbfa_39) : (i64, i64) -> i64
      "braid.setf"(%bbfa_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbfa_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bbfe] : () -> ()
    ^bbfe:  // 0x4024be
      %bbfe_0 = "braid.get"() {reg = "r8"} : () -> i64
      %bbfe_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbfe_16 = "braid.add"(%bbfe_0, %bbfe_8) : (i64, i64) -> i64
      %bbfe_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbfe_20 = "braid.eq"(%bbfe_16, %bbfe_19) : (i64, i64) -> i64
      "braid.setf"(%bbfe_20) {flag = "of"} : (i64) -> ()
      %bbfe_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbfe_24) {flag = "af"} : (i64) -> ()
      %bbfe_32 = "braid.zext"(%bbfe_16) {bits = 8 : i64} : (i64) -> i64
      %bbfe_33 = "braid.popcnt"(%bbfe_32) : (i64) -> i64
      %bbfe_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbfe_35 = "braid.and"(%bbfe_33, %bbfe_34) : (i64, i64) -> i64
      %bbfe_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbfe_37 = "braid.eq"(%bbfe_35, %bbfe_36) : (i64, i64) -> i64
      "braid.setf"(%bbfe_37) {flag = "pf"} : (i64) -> ()
      %bbfe_38 = "braid.eq"(%bbfe_16, %bbfe_36) : (i64, i64) -> i64
      "braid.setf"(%bbfe_38) {flag = "zf"} : (i64) -> ()
      %bbfe_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbfe_40 = "braid.and"(%bbfe_16, %bbfe_39) : (i64, i64) -> i64
      "braid.setf"(%bbfe_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbfe_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb101] : () -> ()
    ^bb101:  // 0x4024c1
      %bb101_0 = "braid.get"() {reg = "r9"} : () -> i64
      %bb101_8 = "braid.const"() {value = -32 : i64} : () -> i64
      %bb101_16 = "braid.sub"(%bb101_0, %bb101_8) : (i64, i64) -> i64
      %bb101_18 = "braid.ult"(%bb101_0, %bb101_8) : (i64, i64) -> i64
      "braid.setf"(%bb101_18) {flag = "cf"} : (i64) -> ()
      %bb101_19 = "braid.xor"(%bb101_0, %bb101_8) : (i64, i64) -> i64
      %bb101_20 = "braid.xor"(%bb101_0, %bb101_16) : (i64, i64) -> i64
      %bb101_21 = "braid.and"(%bb101_19, %bb101_20) : (i64, i64) -> i64
      %bb101_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb101_23 = "braid.and"(%bb101_21, %bb101_22) : (i64, i64) -> i64
      "braid.setf"(%bb101_23) {flag = "of"} : (i64) -> ()
      %bb101_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb101_24) {flag = "af"} : (i64) -> ()
      %bb101_32 = "braid.zext"(%bb101_16) {bits = 8 : i64} : (i64) -> i64
      %bb101_33 = "braid.popcnt"(%bb101_32) : (i64) -> i64
      %bb101_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb101_35 = "braid.and"(%bb101_33, %bb101_34) : (i64, i64) -> i64
      %bb101_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb101_37 = "braid.eq"(%bb101_35, %bb101_36) : (i64, i64) -> i64
      "braid.setf"(%bb101_37) {flag = "pf"} : (i64) -> ()
      %bb101_38 = "braid.eq"(%bb101_16, %bb101_36) : (i64, i64) -> i64
      "braid.setf"(%bb101_38) {flag = "zf"} : (i64) -> ()
      %bb101_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb101_40 = "braid.and"(%bb101_16, %bb101_39) : (i64, i64) -> i64
      "braid.setf"(%bb101_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb105] : () -> ()
    ^bb105:  // 0x4024c5
      %bb105_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb105_0)[^bbd0, ^bb107] : (i64) -> ()
    ^bb107:  // 0x4024c7
      %bb107_0 = "braid.get"() {reg = "r8"} : () -> i64
      %bb107_8 = "braid.get"() {reg = "r15"} : () -> i64
      %bb107_16 = "braid.sub"(%bb107_0, %bb107_8) : (i64, i64) -> i64
      %bb107_18 = "braid.ult"(%bb107_0, %bb107_8) : (i64, i64) -> i64
      "braid.setf"(%bb107_18) {flag = "cf"} : (i64) -> ()
      %bb107_19 = "braid.xor"(%bb107_0, %bb107_8) : (i64, i64) -> i64
      %bb107_20 = "braid.xor"(%bb107_0, %bb107_16) : (i64, i64) -> i64
      %bb107_21 = "braid.and"(%bb107_19, %bb107_20) : (i64, i64) -> i64
      %bb107_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb107_23 = "braid.and"(%bb107_21, %bb107_22) : (i64, i64) -> i64
      "braid.setf"(%bb107_23) {flag = "of"} : (i64) -> ()
      %bb107_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb107_24) {flag = "af"} : (i64) -> ()
      %bb107_32 = "braid.zext"(%bb107_16) {bits = 8 : i64} : (i64) -> i64
      %bb107_33 = "braid.popcnt"(%bb107_32) : (i64) -> i64
      %bb107_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb107_35 = "braid.and"(%bb107_33, %bb107_34) : (i64, i64) -> i64
      %bb107_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb107_37 = "braid.eq"(%bb107_35, %bb107_36) : (i64, i64) -> i64
      "braid.setf"(%bb107_37) {flag = "pf"} : (i64) -> ()
      %bb107_38 = "braid.eq"(%bb107_16, %bb107_36) : (i64, i64) -> i64
      "braid.setf"(%bb107_38) {flag = "zf"} : (i64) -> ()
      %bb107_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb107_40 = "braid.and"(%bb107_16, %bb107_39) : (i64, i64) -> i64
      "braid.setf"(%bb107_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb10a] : () -> ()
    ^bb10a:  // 0x4024ca
      %bb10a_0 = "braid.getf"() {flag = "cf"} : () -> i64
      "braid_cf.cond_br"(%bb10a_0)[^bbf0, ^bb10c] : (i64) -> ()
    ^bb10c:  // 0x4024cc
      %bb10c_0 = "braid.const"() {value = 128 : i64} : () -> i64
      "braid.set"(%bb10c_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb111] : () -> ()
    ^bb111:  // 0x4024d1
      %bb111_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb111_0)[^bbf5, ^bb113] : (i64) -> ()
    ^bb113:  // 0x4024d3
      %bb113_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb113_0 = "braid.zext"(%bb113_1) {bits = 32 : i64} : (i64) -> i64
      %bb113_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb113_8 = "braid.zext"(%bb113_9) {bits = 32 : i64} : (i64) -> i64
      %bb113_16 = "braid.xor"(%bb113_0, %bb113_8) : (i64, i64) -> i64
      %bb113_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb113_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb113_17) {flag = "of"} : (i64) -> ()
      %bb113_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb113_24) {flag = "af"} : (i64) -> ()
      %bb113_32 = "braid.zext"(%bb113_16) {bits = 8 : i64} : (i64) -> i64
      %bb113_33 = "braid.popcnt"(%bb113_32) : (i64) -> i64
      %bb113_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb113_35 = "braid.and"(%bb113_33, %bb113_34) : (i64, i64) -> i64
      %bb113_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb113_37 = "braid.eq"(%bb113_35, %bb113_36) : (i64, i64) -> i64
      "braid.setf"(%bb113_37) {flag = "pf"} : (i64) -> ()
      %bb113_38 = "braid.eq"(%bb113_16, %bb113_36) : (i64, i64) -> i64
      "braid.setf"(%bb113_38) {flag = "zf"} : (i64) -> ()
      %bb113_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb113_40 = "braid.and"(%bb113_16, %bb113_39) : (i64, i64) -> i64
      "braid.setf"(%bb113_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb113_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb115] : () -> ()
    ^bb115:  // 0x4024d5
      %bb115_0 = "braid.get"() {reg = "r8"} : () -> i64
      %bb115_8 = "braid.get"() {reg = "r13"} : () -> i64
      %bb115_16 = "braid.sub"(%bb115_0, %bb115_8) : (i64, i64) -> i64
      %bb115_18 = "braid.ult"(%bb115_0, %bb115_8) : (i64, i64) -> i64
      "braid.setf"(%bb115_18) {flag = "cf"} : (i64) -> ()
      %bb115_19 = "braid.xor"(%bb115_0, %bb115_8) : (i64, i64) -> i64
      %bb115_20 = "braid.xor"(%bb115_0, %bb115_16) : (i64, i64) -> i64
      %bb115_21 = "braid.and"(%bb115_19, %bb115_20) : (i64, i64) -> i64
      %bb115_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb115_23 = "braid.and"(%bb115_21, %bb115_22) : (i64, i64) -> i64
      "braid.setf"(%bb115_23) {flag = "of"} : (i64) -> ()
      %bb115_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb115_24) {flag = "af"} : (i64) -> ()
      %bb115_32 = "braid.zext"(%bb115_16) {bits = 8 : i64} : (i64) -> i64
      %bb115_33 = "braid.popcnt"(%bb115_32) : (i64) -> i64
      %bb115_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb115_35 = "braid.and"(%bb115_33, %bb115_34) : (i64, i64) -> i64
      %bb115_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb115_37 = "braid.eq"(%bb115_35, %bb115_36) : (i64, i64) -> i64
      "braid.setf"(%bb115_37) {flag = "pf"} : (i64) -> ()
      %bb115_38 = "braid.eq"(%bb115_16, %bb115_36) : (i64, i64) -> i64
      "braid.setf"(%bb115_38) {flag = "zf"} : (i64) -> ()
      %bb115_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb115_40 = "braid.and"(%bb115_16, %bb115_39) : (i64, i64) -> i64
      "braid.setf"(%bb115_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x4024d8
      %bb118_0 = "braid.getf"() {flag = "cf"} : () -> i64
      "braid_cf.cond_br"(%bb118_0)[^bbf5, ^bb11a] : (i64) -> ()
    ^bb11a:  // 0x4024da
      %bb11a_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb11a_2 = "braid.get"() {reg = "r9"} : () -> i64
      %bb11a_3 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb11a_4 = "braid.mul"(%bb11a_2, %bb11a_3) : (i64, i64) -> i64
      %bb11a_5 = "braid.add"(%bb11a_1, %bb11a_4) : (i64, i64) -> i64
      %bb11a_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb11a_0 = "braid.add"(%bb11a_5, %bb11a_6) : (i64, i64) -> i64
      %bb11a_8 = "braid.zext"(%bb11a_0) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb11a_8) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb11e] : () -> ()
    ^bb11e:  // 0x4024de
      %bb11e_0 = "braid.get"() {reg = "rbp"} : () -> i64
      "braid.set"(%bb11e_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb121] : () -> ()
    ^bb121:  // 0x4024e1
      %bb121_0 = "braid.get"() {reg = "r10"} : () -> i64
      %bb121_56 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb121_57 = "braid.const"() {value = 63 : i64} : () -> i64
      %bb121_8 = "braid.and"(%bb121_56, %bb121_57) : (i64, i64) -> i64
      %bb121_28 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb121_29 = "braid.eq"(%bb121_8, %bb121_28) : (i64, i64) -> i64
      %bb121_9 = "braid.lshr"(%bb121_0, %bb121_8) : (i64, i64) -> i64
      %bb121_11 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb121_14 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb121_12 = "braid.sub"(%bb121_8, %bb121_14) : (i64, i64) -> i64
      %bb121_13 = "braid.lshr"(%bb121_0, %bb121_12) : (i64, i64) -> i64
      %bb121_15 = "braid.and"(%bb121_13, %bb121_14) : (i64, i64) -> i64
      %bb121_16 = "braid.havoc"() : () -> i64
      %bb121_18 = "braid.ult"(%bb121_8, %bb121_11) : (i64, i64) -> i64
      %bb121_19 = "braid.select"(%bb121_18, %bb121_15, %bb121_16) : (i64, i64, i64) -> i64
      %bb121_21 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb121_22 = "braid.and"(%bb121_0, %bb121_21) : (i64, i64) -> i64
      %bb121_23 = "braid.havoc"() : () -> i64
      %bb121_26 = "braid.eq"(%bb121_8, %bb121_14) : (i64, i64) -> i64
      %bb121_27 = "braid.select"(%bb121_26, %bb121_22, %bb121_23) : (i64, i64, i64) -> i64
      %bb121_24 = "braid.havoc"() : () -> i64
      %bb121_32 = "braid.zext"(%bb121_9) {bits = 8 : i64} : (i64) -> i64
      %bb121_33 = "braid.popcnt"(%bb121_32) : (i64) -> i64
      %bb121_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb121_35 = "braid.and"(%bb121_33, %bb121_34) : (i64, i64) -> i64
      %bb121_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb121_37 = "braid.eq"(%bb121_35, %bb121_36) : (i64, i64) -> i64
      %bb121_38 = "braid.eq"(%bb121_9, %bb121_36) : (i64, i64) -> i64
      %bb121_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb121_40 = "braid.and"(%bb121_9, %bb121_39) : (i64, i64) -> i64
      %bb121_60 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb121_61 = "braid.select"(%bb121_29, %bb121_60, %bb121_19) : (i64, i64, i64) -> i64
      "braid.setf"(%bb121_61) {flag = "cf"} : (i64) -> ()
      %bb121_62 = "braid.getf"() {flag = "pf"} : () -> i64
      %bb121_63 = "braid.select"(%bb121_29, %bb121_62, %bb121_37) : (i64, i64, i64) -> i64
      "braid.setf"(%bb121_63) {flag = "pf"} : (i64) -> ()
      %bb121_64 = "braid.getf"() {flag = "af"} : () -> i64
      %bb121_65 = "braid.select"(%bb121_29, %bb121_64, %bb121_24) : (i64, i64, i64) -> i64
      "braid.setf"(%bb121_65) {flag = "af"} : (i64) -> ()
      %bb121_66 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb121_67 = "braid.select"(%bb121_29, %bb121_66, %bb121_38) : (i64, i64, i64) -> i64
      "braid.setf"(%bb121_67) {flag = "zf"} : (i64) -> ()
      %bb121_68 = "braid.getf"() {flag = "sf"} : () -> i64
      %bb121_69 = "braid.select"(%bb121_29, %bb121_68, %bb121_40) : (i64, i64, i64) -> i64
      "braid.setf"(%bb121_69) {flag = "sf"} : (i64) -> ()
      %bb121_70 = "braid.getf"() {flag = "of"} : () -> i64
      %bb121_71 = "braid.select"(%bb121_29, %bb121_70, %bb121_27) : (i64, i64, i64) -> i64
      "braid.setf"(%bb121_71) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb121_9) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb124] : () -> ()
    ^bb124:  // 0x4024e4
      %bb124_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb124_0 = "braid.zext"(%bb124_1) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bb124_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb128] : () -> ()
    ^bb128:  // 0x4024e8
      "braid_cf.br"()[^bbf5] : () -> ()
    ^bb12a:  // 0x4024ea
      %bb12a_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb12a_0 = "braid.zext"(%bb12a_1) {bits = 32 : i64} : (i64) -> i64
      %bb12a_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb12a_8 = "braid.zext"(%bb12a_9) {bits = 32 : i64} : (i64) -> i64
      %bb12a_16 = "braid.xor"(%bb12a_0, %bb12a_8) : (i64, i64) -> i64
      %bb12a_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb12a_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb12a_17) {flag = "of"} : (i64) -> ()
      %bb12a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb12a_24) {flag = "af"} : (i64) -> ()
      %bb12a_32 = "braid.zext"(%bb12a_16) {bits = 8 : i64} : (i64) -> i64
      %bb12a_33 = "braid.popcnt"(%bb12a_32) : (i64) -> i64
      %bb12a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb12a_35 = "braid.and"(%bb12a_33, %bb12a_34) : (i64, i64) -> i64
      %bb12a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12a_37 = "braid.eq"(%bb12a_35, %bb12a_36) : (i64, i64) -> i64
      "braid.setf"(%bb12a_37) {flag = "pf"} : (i64) -> ()
      %bb12a_38 = "braid.eq"(%bb12a_16, %bb12a_36) : (i64, i64) -> i64
      "braid.setf"(%bb12a_38) {flag = "zf"} : (i64) -> ()
      %bb12a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb12a_40 = "braid.and"(%bb12a_16, %bb12a_39) : (i64, i64) -> i64
      "braid.setf"(%bb12a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb12a_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb12c] : () -> ()
    ^bb12c:  // 0x4024ec
      "braid_cf.br"()[^bb130] : () -> ()
    ^bb130:  // 0x4024f0
      %bb130_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb130_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb130_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb130_5 = "braid.mul"(%bb130_3, %bb130_4) : (i64, i64) -> i64
      %bb130_6 = "braid.add"(%bb130_2, %bb130_5) : (i64, i64) -> i64
      %bb130_7 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb130_1 = "braid.add"(%bb130_6, %bb130_7) : (i64, i64) -> i64
      %bb130_0 = "braid.load"(%bb130_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb130_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb134:  // 0x4024f4
      %bb134_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb134_0 = "braid.zext"(%bb134_1) {bits = 32 : i64} : (i64) -> i64
      %bb134_8 = "braid.bswap"(%bb134_0) : (i64) -> i64
      %bb134_9 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb134_10 = "braid.lshr"(%bb134_8, %bb134_9) : (i64, i64) -> i64
      "braid.set"(%bb134_10) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb136] : () -> ()
    ^bb136:  // 0x4024f6
      %bb136_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb136_0 = "braid.zext"(%bb136_1) {bits = 32 : i64} : (i64) -> i64
      %bb136_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb136_10 = "braid.get"() {reg = "rax"} : () -> i64
      %bb136_11 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb136_12 = "braid.mul"(%bb136_10, %bb136_11) : (i64, i64) -> i64
      %bb136_13 = "braid.add"(%bb136_9, %bb136_12) : (i64, i64) -> i64
      %bb136_14 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb136_8 = "braid.add"(%bb136_13, %bb136_14) : (i64, i64) -> i64
      "braid.store"(%bb136_8, %bb136_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb13a] : () -> ()
    ^bb13a:  // 0x4024fa
      %bb13a_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb13a_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb13a_16 = "braid.add"(%bb13a_0, %bb13a_8) : (i64, i64) -> i64
      %bb13a_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb13a_20 = "braid.eq"(%bb13a_16, %bb13a_19) : (i64, i64) -> i64
      "braid.setf"(%bb13a_20) {flag = "of"} : (i64) -> ()
      %bb13a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb13a_24) {flag = "af"} : (i64) -> ()
      %bb13a_32 = "braid.zext"(%bb13a_16) {bits = 8 : i64} : (i64) -> i64
      %bb13a_33 = "braid.popcnt"(%bb13a_32) : (i64) -> i64
      %bb13a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb13a_35 = "braid.and"(%bb13a_33, %bb13a_34) : (i64, i64) -> i64
      %bb13a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb13a_37 = "braid.eq"(%bb13a_35, %bb13a_36) : (i64, i64) -> i64
      "braid.setf"(%bb13a_37) {flag = "pf"} : (i64) -> ()
      %bb13a_38 = "braid.eq"(%bb13a_16, %bb13a_36) : (i64, i64) -> i64
      "braid.setf"(%bb13a_38) {flag = "zf"} : (i64) -> ()
      %bb13a_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb13a_40 = "braid.and"(%bb13a_16, %bb13a_39) : (i64, i64) -> i64
      "braid.setf"(%bb13a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb13a_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb13d] : () -> ()
    ^bb13d:  // 0x4024fd
      %bb13d_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb13d_8 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb13d_16 = "braid.sub"(%bb13d_0, %bb13d_8) : (i64, i64) -> i64
      %bb13d_18 = "braid.ult"(%bb13d_0, %bb13d_8) : (i64, i64) -> i64
      "braid.setf"(%bb13d_18) {flag = "cf"} : (i64) -> ()
      %bb13d_19 = "braid.xor"(%bb13d_0, %bb13d_8) : (i64, i64) -> i64
      %bb13d_20 = "braid.xor"(%bb13d_0, %bb13d_16) : (i64, i64) -> i64
      %bb13d_21 = "braid.and"(%bb13d_19, %bb13d_20) : (i64, i64) -> i64
      %bb13d_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb13d_23 = "braid.and"(%bb13d_21, %bb13d_22) : (i64, i64) -> i64
      "braid.setf"(%bb13d_23) {flag = "of"} : (i64) -> ()
      %bb13d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb13d_24) {flag = "af"} : (i64) -> ()
      %bb13d_32 = "braid.zext"(%bb13d_16) {bits = 8 : i64} : (i64) -> i64
      %bb13d_33 = "braid.popcnt"(%bb13d_32) : (i64) -> i64
      %bb13d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb13d_35 = "braid.and"(%bb13d_33, %bb13d_34) : (i64, i64) -> i64
      %bb13d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb13d_37 = "braid.eq"(%bb13d_35, %bb13d_36) : (i64, i64) -> i64
      "braid.setf"(%bb13d_37) {flag = "pf"} : (i64) -> ()
      %bb13d_38 = "braid.eq"(%bb13d_16, %bb13d_36) : (i64, i64) -> i64
      "braid.setf"(%bb13d_38) {flag = "zf"} : (i64) -> ()
      %bb13d_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb13d_40 = "braid.and"(%bb13d_16, %bb13d_39) : (i64, i64) -> i64
      "braid.setf"(%bb13d_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb141] : () -> ()
    ^bb141:  // 0x402501
      %bb141_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb141_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb141_0 = "braid.eq"(%bb141_1, %bb141_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb141_0)[^bb130, ^bb143] : (i64) -> ()
    ^bb143:  // 0x402503
      %bb143_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb143_0 = "braid.zext"(%bb143_1) {bits = 32 : i64} : (i64) -> i64
      %bb143_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb143_8 = "braid.zext"(%bb143_9) {bits = 32 : i64} : (i64) -> i64
      %bb143_16 = "braid.xor"(%bb143_0, %bb143_8) : (i64, i64) -> i64
      %bb143_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb143_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb143_17) {flag = "of"} : (i64) -> ()
      %bb143_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb143_24) {flag = "af"} : (i64) -> ()
      %bb143_32 = "braid.zext"(%bb143_16) {bits = 8 : i64} : (i64) -> i64
      %bb143_33 = "braid.popcnt"(%bb143_32) : (i64) -> i64
      %bb143_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb143_35 = "braid.and"(%bb143_33, %bb143_34) : (i64, i64) -> i64
      %bb143_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb143_37 = "braid.eq"(%bb143_35, %bb143_36) : (i64, i64) -> i64
      "braid.setf"(%bb143_37) {flag = "pf"} : (i64) -> ()
      %bb143_38 = "braid.eq"(%bb143_16, %bb143_36) : (i64, i64) -> i64
      "braid.setf"(%bb143_38) {flag = "zf"} : (i64) -> ()
      %bb143_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb143_40 = "braid.and"(%bb143_16, %bb143_39) : (i64, i64) -> i64
      "braid.setf"(%bb143_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb143_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb145] : () -> ()
    ^bb145:  // 0x402505
      %bb145_0 = "braid.const"() {value = 4205888 : i64} : () -> i64
      "braid.set"(%bb145_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb14c] : () -> ()
    ^bb14c:  // 0x40250c
      "braid_cf.br"()[^bb150] : () -> ()
    ^bb150:  // 0x402510
      %bb150_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb150_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb150_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb150_5 = "braid.mul"(%bb150_3, %bb150_4) : (i64, i64) -> i64
      %bb150_6 = "braid.add"(%bb150_2, %bb150_5) : (i64, i64) -> i64
      %bb150_7 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb150_1 = "braid.add"(%bb150_6, %bb150_7) : (i64, i64) -> i64
      %bb150_0 = "braid.load"(%bb150_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb150_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb155] : () -> ()
    ^bb155:  // 0x402515
      %bb155_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb155_0 = "braid.zext"(%bb155_1) {bits = 8 : i64} : (i64) -> i64
      %bb155_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb155_10 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb155_11 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb155_12 = "braid.mul"(%bb155_10, %bb155_11) : (i64, i64) -> i64
      %bb155_13 = "braid.add"(%bb155_9, %bb155_12) : (i64, i64) -> i64
      %bb155_14 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb155_8 = "braid.add"(%bb155_13, %bb155_14) : (i64, i64) -> i64
      "braid.store"(%bb155_8, %bb155_0) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb158] : () -> ()
    ^bb158:  // 0x402518
      %bb158_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb158_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb158_16 = "braid.add"(%bb158_0, %bb158_8) : (i64, i64) -> i64
      %bb158_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb158_20 = "braid.eq"(%bb158_16, %bb158_19) : (i64, i64) -> i64
      "braid.setf"(%bb158_20) {flag = "of"} : (i64) -> ()
      %bb158_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb158_24) {flag = "af"} : (i64) -> ()
      %bb158_32 = "braid.zext"(%bb158_16) {bits = 8 : i64} : (i64) -> i64
      %bb158_33 = "braid.popcnt"(%bb158_32) : (i64) -> i64
      %bb158_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb158_35 = "braid.and"(%bb158_33, %bb158_34) : (i64, i64) -> i64
      %bb158_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb158_37 = "braid.eq"(%bb158_35, %bb158_36) : (i64, i64) -> i64
      "braid.setf"(%bb158_37) {flag = "pf"} : (i64) -> ()
      %bb158_38 = "braid.eq"(%bb158_16, %bb158_36) : (i64, i64) -> i64
      "braid.setf"(%bb158_38) {flag = "zf"} : (i64) -> ()
      %bb158_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb158_40 = "braid.and"(%bb158_16, %bb158_39) : (i64, i64) -> i64
      "braid.setf"(%bb158_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb158_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb15b] : () -> ()
    ^bb15b:  // 0x40251b
      %bb15b_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb15b_8 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb15b_16 = "braid.sub"(%bb15b_0, %bb15b_8) : (i64, i64) -> i64
      %bb15b_18 = "braid.ult"(%bb15b_0, %bb15b_8) : (i64, i64) -> i64
      "braid.setf"(%bb15b_18) {flag = "cf"} : (i64) -> ()
      %bb15b_19 = "braid.xor"(%bb15b_0, %bb15b_8) : (i64, i64) -> i64
      %bb15b_20 = "braid.xor"(%bb15b_0, %bb15b_16) : (i64, i64) -> i64
      %bb15b_21 = "braid.and"(%bb15b_19, %bb15b_20) : (i64, i64) -> i64
      %bb15b_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb15b_23 = "braid.and"(%bb15b_21, %bb15b_22) : (i64, i64) -> i64
      "braid.setf"(%bb15b_23) {flag = "of"} : (i64) -> ()
      %bb15b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb15b_24) {flag = "af"} : (i64) -> ()
      %bb15b_32 = "braid.zext"(%bb15b_16) {bits = 8 : i64} : (i64) -> i64
      %bb15b_33 = "braid.popcnt"(%bb15b_32) : (i64) -> i64
      %bb15b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb15b_35 = "braid.and"(%bb15b_33, %bb15b_34) : (i64, i64) -> i64
      %bb15b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15b_37 = "braid.eq"(%bb15b_35, %bb15b_36) : (i64, i64) -> i64
      "braid.setf"(%bb15b_37) {flag = "pf"} : (i64) -> ()
      %bb15b_38 = "braid.eq"(%bb15b_16, %bb15b_36) : (i64, i64) -> i64
      "braid.setf"(%bb15b_38) {flag = "zf"} : (i64) -> ()
      %bb15b_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb15b_40 = "braid.and"(%bb15b_16, %bb15b_39) : (i64, i64) -> i64
      "braid.setf"(%bb15b_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb15f] : () -> ()
    ^bb15f:  // 0x40251f
      %bb15f_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb15f_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15f_0 = "braid.eq"(%bb15f_1, %bb15f_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb15f_0)[^bb150, ^bb161] : (i64) -> ()
    ^bb161:  // 0x402521
      "braid_cf.br"()[^bb170] : () -> ()
    ^bb170:  // 0x402530
      "braid_cf.br"()[^bb170] : () -> ()
    ^ext401100:
      "braid_cf.tail"() {target = 4198656 : i64} : () -> ()
  }) {sym_name = "main", entry = 4203456 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
