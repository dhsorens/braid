"braid.module"() ({
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb0_3 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb0_4 = "braid.mul"(%bb0_2, %bb0_3) : (i64, i64) -> i64
      %bb0_5 = "braid.add"(%bb0_1, %bb0_4) : (i64, i64) -> i64
      %bb0_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_0 = "braid.add"(%bb0_5, %bb0_6) : (i64, i64) -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x401004
      %bb4_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb4_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb4_16 = "braid.add"(%bb4_0, %bb4_8) : (i64, i64) -> i64
      %bb4_18 = "braid.ult"(%bb4_16, %bb4_0) : (i64, i64) -> i64
      "braid.setf"(%bb4_18) {flag = "cf"} : (i64) -> ()
      %bb4_19 = "braid.xor"(%bb4_0, %bb4_16) : (i64, i64) -> i64
      %bb4_20 = "braid.xor"(%bb4_8, %bb4_16) : (i64, i64) -> i64
      %bb4_21 = "braid.and"(%bb4_19, %bb4_20) : (i64, i64) -> i64
      %bb4_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb4_23 = "braid.and"(%bb4_21, %bb4_22) : (i64, i64) -> i64
      "braid.setf"(%bb4_23) {flag = "of"} : (i64) -> ()
      %bb4_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb4_24) {flag = "af"} : (i64) -> ()
      %bb4_32 = "braid.zext"(%bb4_16) {bits = 8 : i64} : (i64) -> i64
      %bb4_33 = "braid.popcnt"(%bb4_32) : (i64) -> i64
      %bb4_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4_35 = "braid.and"(%bb4_33, %bb4_34) : (i64, i64) -> i64
      %bb4_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_37 = "braid.eq"(%bb4_35, %bb4_36) : (i64, i64) -> i64
      "braid.setf"(%bb4_37) {flag = "pf"} : (i64) -> ()
      %bb4_38 = "braid.eq"(%bb4_16, %bb4_36) : (i64, i64) -> i64
      "braid.setf"(%bb4_38) {flag = "zf"} : (i64) -> ()
      %bb4_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb4_40 = "braid.and"(%bb4_16, %bb4_39) : (i64, i64) -> i64
      "braid.setf"(%bb4_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb4_16) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb7] : () -> ()
    ^bb7:  // 0x401007
      %bb7_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb7_1 = "braid.load"(%bb7_0) {bytes = 8 : i64} : (i64) -> i64
      %bb7_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb7_3 = "braid.add"(%bb7_0, %bb7_2) : (i64, i64) -> i64
      "braid.set"(%bb7_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb7_1) : (i64) -> ()
    ^bb8:  // 0x401008
      "braid.br"()[^ext401010] : () -> ()
    ^ext401010:
      "braid.tail"() {target = 4198416 : i64} : () -> ()
  }) {sym_name = "add3", entry = 4198400 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401010
      %bb0_0 = "braid.get"() {reg = "rsi"} : () -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401013
      %bb3_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb3_8 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb3_16 = "braid.sub"(%bb3_0, %bb3_8) : (i64, i64) -> i64
      %bb3_18 = "braid.ult"(%bb3_0, %bb3_8) : (i64, i64) -> i64
      "braid.setf"(%bb3_18) {flag = "cf"} : (i64) -> ()
      %bb3_19 = "braid.xor"(%bb3_0, %bb3_8) : (i64, i64) -> i64
      %bb3_20 = "braid.xor"(%bb3_0, %bb3_16) : (i64, i64) -> i64
      %bb3_21 = "braid.and"(%bb3_19, %bb3_20) : (i64, i64) -> i64
      %bb3_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb3_23 = "braid.and"(%bb3_21, %bb3_22) : (i64, i64) -> i64
      "braid.setf"(%bb3_23) {flag = "of"} : (i64) -> ()
      %bb3_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb3_24) {flag = "af"} : (i64) -> ()
      %bb3_32 = "braid.zext"(%bb3_16) {bits = 8 : i64} : (i64) -> i64
      %bb3_33 = "braid.popcnt"(%bb3_32) : (i64) -> i64
      %bb3_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3_35 = "braid.and"(%bb3_33, %bb3_34) : (i64, i64) -> i64
      %bb3_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3_37 = "braid.eq"(%bb3_35, %bb3_36) : (i64, i64) -> i64
      "braid.setf"(%bb3_37) {flag = "pf"} : (i64) -> ()
      %bb3_38 = "braid.eq"(%bb3_16, %bb3_36) : (i64, i64) -> i64
      "braid.setf"(%bb3_38) {flag = "zf"} : (i64) -> ()
      %bb3_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb3_40 = "braid.and"(%bb3_16, %bb3_39) : (i64, i64) -> i64
      "braid.setf"(%bb3_40) {flag = "sf"} : (i64) -> ()
      "braid.br"()[^bb6] : () -> ()
    ^bb6:  // 0x401016
      %bb6_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb6_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb6_17 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb6_18 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb6_19 = "braid.or"(%bb6_17, %bb6_18) : (i64, i64) -> i64
      %bb6_20 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6_16 = "braid.eq"(%bb6_19, %bb6_20) : (i64, i64) -> i64
      %bb6_24 = "braid.select"(%bb6_16, %bb6_0, %bb6_8) : (i64, i64, i64) -> i64
      "braid.set"(%bb6_24) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bba] : () -> ()
    ^bba:  // 0x40101a
      %bba_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba_1 = "braid.load"(%bba_0) {bytes = 8 : i64} : (i64) -> i64
      %bba_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bba_3 = "braid.add"(%bba_0, %bba_2) : (i64, i64) -> i64
      "braid.set"(%bba_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bba_1) : (i64) -> ()
    ^bbb:  // 0x40101b
      "braid.br"()[^ext401020] : () -> ()
    ^ext401020:
      "braid.tail"() {target = 4198432 : i64} : () -> ()
  }) {sym_name = "max_u64", entry = 4198416 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401020
      %bb0_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb0_8 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb0_16 = "braid.and"(%bb0_0, %bb0_8) : (i64, i64) -> i64
      %bb0_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb0_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb0_17) {flag = "of"} : (i64) -> ()
      %bb0_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb0_24) {flag = "af"} : (i64) -> ()
      %bb0_32 = "braid.zext"(%bb0_16) {bits = 8 : i64} : (i64) -> i64
      %bb0_33 = "braid.popcnt"(%bb0_32) : (i64) -> i64
      %bb0_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb0_35 = "braid.and"(%bb0_33, %bb0_34) : (i64, i64) -> i64
      %bb0_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_37 = "braid.eq"(%bb0_35, %bb0_36) : (i64, i64) -> i64
      "braid.setf"(%bb0_37) {flag = "pf"} : (i64) -> ()
      %bb0_38 = "braid.eq"(%bb0_16, %bb0_36) : (i64, i64) -> i64
      "braid.setf"(%bb0_38) {flag = "zf"} : (i64) -> ()
      %bb0_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb0_40 = "braid.and"(%bb0_16, %bb0_39) : (i64, i64) -> i64
      "braid.setf"(%bb0_40) {flag = "sf"} : (i64) -> ()
      "braid.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401023
      %bb3_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid.cond_br"(%bb3_0)[^bb29, ^bb5] : (i64) -> ()
    ^bb5:  // 0x401025
      %bb5_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb5_2 = "braid.const"() {value = -1 : i64} : () -> i64
      %bb5_0 = "braid.add"(%bb5_1, %bb5_2) : (i64, i64) -> i64
      "braid.set"(%bb5_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb9] : () -> ()
    ^bb9:  // 0x401029
      %bb9_0 = "braid.get"() {reg = "rax"} : () -> i64
      "braid.set"(%bb9_0) {reg = "rsi"} : (i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x40102c
      %bbc_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbc_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bbc_16 = "braid.mul"(%bbc_0, %bbc_8) : (i64, i64) -> i64
      "braid.set"(%bbc_16) {reg = "rsi"} : (i64) -> ()
      %bbc_40 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc_40) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbc_40) {flag = "of"} : (i64) -> ()
      %bbc_41 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc_41) {flag = "sf"} : (i64) -> ()
      %bbc_42 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc_42) {flag = "zf"} : (i64) -> ()
      %bbc_43 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc_43) {flag = "af"} : (i64) -> ()
      %bbc_44 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc_44) {flag = "pf"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401030
      %bb10_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb10_8 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb10_16 = "braid.add"(%bb10_0, %bb10_8) : (i64, i64) -> i64
      %bb10_18 = "braid.ult"(%bb10_16, %bb10_0) : (i64, i64) -> i64
      "braid.setf"(%bb10_18) {flag = "cf"} : (i64) -> ()
      %bb10_19 = "braid.xor"(%bb10_0, %bb10_16) : (i64, i64) -> i64
      %bb10_20 = "braid.xor"(%bb10_8, %bb10_16) : (i64, i64) -> i64
      %bb10_21 = "braid.and"(%bb10_19, %bb10_20) : (i64, i64) -> i64
      %bb10_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb10_23 = "braid.and"(%bb10_21, %bb10_22) : (i64, i64) -> i64
      "braid.setf"(%bb10_23) {flag = "of"} : (i64) -> ()
      %bb10_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb10_24) {flag = "af"} : (i64) -> ()
      %bb10_32 = "braid.zext"(%bb10_16) {bits = 8 : i64} : (i64) -> i64
      %bb10_33 = "braid.popcnt"(%bb10_32) : (i64) -> i64
      %bb10_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_35 = "braid.and"(%bb10_33, %bb10_34) : (i64, i64) -> i64
      %bb10_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_37 = "braid.eq"(%bb10_35, %bb10_36) : (i64, i64) -> i64
      "braid.setf"(%bb10_37) {flag = "pf"} : (i64) -> ()
      %bb10_38 = "braid.eq"(%bb10_16, %bb10_36) : (i64, i64) -> i64
      "braid.setf"(%bb10_38) {flag = "zf"} : (i64) -> ()
      %bb10_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb10_40 = "braid.and"(%bb10_16, %bb10_39) : (i64, i64) -> i64
      "braid.setf"(%bb10_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb10_16) {reg = "rsi"} : (i64) -> ()
      "braid.br"()[^bb13] : () -> ()
    ^bb13:  // 0x401033
      %bb13_0 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb13_8 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb13_16 = "braid.add"(%bb13_0, %bb13_8) : (i64, i64) -> i64
      %bb13_18 = "braid.ult"(%bb13_16, %bb13_0) : (i64, i64) -> i64
      "braid.setf"(%bb13_18) {flag = "cf"} : (i64) -> ()
      %bb13_19 = "braid.xor"(%bb13_0, %bb13_16) : (i64, i64) -> i64
      %bb13_20 = "braid.xor"(%bb13_8, %bb13_16) : (i64, i64) -> i64
      %bb13_21 = "braid.and"(%bb13_19, %bb13_20) : (i64, i64) -> i64
      %bb13_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb13_23 = "braid.and"(%bb13_21, %bb13_22) : (i64, i64) -> i64
      "braid.setf"(%bb13_23) {flag = "of"} : (i64) -> ()
      %bb13_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb13_24) {flag = "af"} : (i64) -> ()
      %bb13_32 = "braid.zext"(%bb13_16) {bits = 8 : i64} : (i64) -> i64
      %bb13_33 = "braid.popcnt"(%bb13_32) : (i64) -> i64
      %bb13_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb13_35 = "braid.and"(%bb13_33, %bb13_34) : (i64, i64) -> i64
      %bb13_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb13_37 = "braid.eq"(%bb13_35, %bb13_36) : (i64, i64) -> i64
      "braid.setf"(%bb13_37) {flag = "pf"} : (i64) -> ()
      %bb13_38 = "braid.eq"(%bb13_16, %bb13_36) : (i64, i64) -> i64
      "braid.setf"(%bb13_38) {flag = "zf"} : (i64) -> ()
      %bb13_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb13_40 = "braid.and"(%bb13_16, %bb13_39) : (i64, i64) -> i64
      "braid.setf"(%bb13_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb13_16) {reg = "rdi"} : (i64) -> ()
      "braid.br"()[^bb17] : () -> ()
    ^bb17:  // 0x401037
      "braid.trap"() {reason = "mul"} : () -> ()
    ^bb1a:  // 0x40103a
      %bb1a_0 = "braid.get"() {reg = "rax"} : () -> i64
      "braid.set"(%bb1a_0) {reg = "rcx"} : (i64) -> ()
      "braid.br"()[^bb1d] : () -> ()
    ^bb1d:  // 0x40103d
      %bb1d_0 = "braid.get"() {reg = "rsi"} : () -> i64
      "braid.set"(%bb1d_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb20] : () -> ()
    ^bb20:  // 0x401040
      "braid.trap"() {reason = "shld"} : () -> ()
    ^bb25:  // 0x401045
      %bb25_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb25_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb25_16 = "braid.sub"(%bb25_8, %bb25_0) : (i64, i64) -> i64
      %bb25_18 = "braid.ult"(%bb25_8, %bb25_0) : (i64, i64) -> i64
      "braid.setf"(%bb25_18) {flag = "cf"} : (i64) -> ()
      %bb25_19 = "braid.xor"(%bb25_8, %bb25_0) : (i64, i64) -> i64
      %bb25_20 = "braid.xor"(%bb25_8, %bb25_16) : (i64, i64) -> i64
      %bb25_21 = "braid.and"(%bb25_19, %bb25_20) : (i64, i64) -> i64
      %bb25_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb25_23 = "braid.and"(%bb25_21, %bb25_22) : (i64, i64) -> i64
      "braid.setf"(%bb25_23) {flag = "of"} : (i64) -> ()
      %bb25_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb25_24) {flag = "af"} : (i64) -> ()
      %bb25_32 = "braid.zext"(%bb25_16) {bits = 8 : i64} : (i64) -> i64
      %bb25_33 = "braid.popcnt"(%bb25_32) : (i64) -> i64
      %bb25_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb25_35 = "braid.and"(%bb25_33, %bb25_34) : (i64, i64) -> i64
      %bb25_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb25_37 = "braid.eq"(%bb25_35, %bb25_36) : (i64, i64) -> i64
      "braid.setf"(%bb25_37) {flag = "pf"} : (i64) -> ()
      %bb25_38 = "braid.eq"(%bb25_16, %bb25_36) : (i64, i64) -> i64
      "braid.setf"(%bb25_38) {flag = "zf"} : (i64) -> ()
      %bb25_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb25_40 = "braid.and"(%bb25_16, %bb25_39) : (i64, i64) -> i64
      "braid.setf"(%bb25_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb25_16) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb28] : () -> ()
    ^bb28:  // 0x401048
      %bb28_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb28_1 = "braid.load"(%bb28_0) {bytes = 8 : i64} : (i64) -> i64
      %bb28_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb28_3 = "braid.add"(%bb28_0, %bb28_2) : (i64, i64) -> i64
      "braid.set"(%bb28_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb28_1) : (i64) -> ()
    ^bb29:  // 0x401049
      %bb29_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb29_0 = "braid.zext"(%bb29_1) {bits = 32 : i64} : (i64) -> i64
      %bb29_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb29_8 = "braid.zext"(%bb29_9) {bits = 32 : i64} : (i64) -> i64
      %bb29_16 = "braid.xor"(%bb29_0, %bb29_8) : (i64, i64) -> i64
      %bb29_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb29_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb29_17) {flag = "of"} : (i64) -> ()
      %bb29_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb29_24) {flag = "af"} : (i64) -> ()
      %bb29_32 = "braid.zext"(%bb29_16) {bits = 8 : i64} : (i64) -> i64
      %bb29_33 = "braid.popcnt"(%bb29_32) : (i64) -> i64
      %bb29_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb29_35 = "braid.and"(%bb29_33, %bb29_34) : (i64, i64) -> i64
      %bb29_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb29_37 = "braid.eq"(%bb29_35, %bb29_36) : (i64, i64) -> i64
      "braid.setf"(%bb29_37) {flag = "pf"} : (i64) -> ()
      %bb29_38 = "braid.eq"(%bb29_16, %bb29_36) : (i64, i64) -> i64
      "braid.setf"(%bb29_38) {flag = "zf"} : (i64) -> ()
      %bb29_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb29_40 = "braid.and"(%bb29_16, %bb29_39) : (i64, i64) -> i64
      "braid.setf"(%bb29_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb29_16) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb2b] : () -> ()
    ^bb2b:  // 0x40104b
      %bb2b_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb2b_1 = "braid.load"(%bb2b_0) {bytes = 8 : i64} : (i64) -> i64
      %bb2b_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb2b_3 = "braid.add"(%bb2b_0, %bb2b_2) : (i64, i64) -> i64
      "braid.set"(%bb2b_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb2b_1) : (i64) -> ()
  }) {sym_name = "sum_to", entry = 4198432 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
