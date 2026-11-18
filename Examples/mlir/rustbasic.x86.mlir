"braid.module"() ({
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401010
      %bb0_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb0_3 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb0_4 = "braid.mul"(%bb0_2, %bb0_3) : (i64, i64) -> i64
      %bb0_5 = "braid.add"(%bb0_1, %bb0_4) : (i64, i64) -> i64
      %bb0_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_0 = "braid.add"(%bb0_5, %bb0_6) : (i64, i64) -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x401014
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
    ^bb7:  // 0x401017
      %bb7_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb7_1 = "braid.load"(%bb7_0) {bytes = 8 : i64} : (i64) -> i64
      %bb7_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb7_3 = "braid.add"(%bb7_0, %bb7_2) : (i64, i64) -> i64
      "braid.set"(%bb7_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb7_1) : (i64) -> ()
    ^bb8:  // 0x401018
      "braid.br"()[^ext401020] : () -> ()
    ^ext401020:
      "braid.tail"() {target = 4198432 : i64} : () -> ()
  }) {sym_name = "add3", entry = 4198416 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401020
      %bb0_0 = "braid.get"() {reg = "rdi"} : () -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401023
      %bb3_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb3_8 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb3_16 = "braid.and"(%bb3_0, %bb3_8) : (i64, i64) -> i64
      %bb3_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb3_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb3_17) {flag = "of"} : (i64) -> ()
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
    ^bb6:  // 0x401026
      %bb6_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid.cond_br"(%bb6_0)[^bb20, ^bb8] : (i64) -> ()
    ^bb8:  // 0x401028
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401030
      %bb10_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb10_0 = "braid.zext"(%bb10_1) {bits = 32 : i64} : (i64) -> i64
      %bb10_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb10_8 = "braid.zext"(%bb10_9) {bits = 32 : i64} : (i64) -> i64
      %bb10_16 = "braid.xor"(%bb10_0, %bb10_8) : (i64, i64) -> i64
      %bb10_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb10_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb10_17) {flag = "of"} : (i64) -> ()
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
      %bb10_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb10_40 = "braid.and"(%bb10_16, %bb10_39) : (i64, i64) -> i64
      "braid.setf"(%bb10_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb10_16) {reg = "rdx"} : (i64) -> ()
      "braid.br"()[^ext401032] : () -> ()
    ^bb15:  // 0x401035
      %bb15_0 = "braid.get"() {reg = "rsi"} : () -> i64
      "braid.set"(%bb15_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb18] : () -> ()
    ^bb18:  // 0x401038
      %bb18_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb18_8 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb18_16 = "braid.and"(%bb18_0, %bb18_8) : (i64, i64) -> i64
      %bb18_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb18_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb18_17) {flag = "of"} : (i64) -> ()
      %bb18_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb18_24) {flag = "af"} : (i64) -> ()
      %bb18_32 = "braid.zext"(%bb18_16) {bits = 8 : i64} : (i64) -> i64
      %bb18_33 = "braid.popcnt"(%bb18_32) : (i64) -> i64
      %bb18_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb18_35 = "braid.and"(%bb18_33, %bb18_34) : (i64, i64) -> i64
      %bb18_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_37 = "braid.eq"(%bb18_35, %bb18_36) : (i64, i64) -> i64
      "braid.setf"(%bb18_37) {flag = "pf"} : (i64) -> ()
      %bb18_38 = "braid.eq"(%bb18_16, %bb18_36) : (i64, i64) -> i64
      "braid.setf"(%bb18_38) {flag = "zf"} : (i64) -> ()
      %bb18_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb18_40 = "braid.and"(%bb18_16, %bb18_39) : (i64, i64) -> i64
      "braid.setf"(%bb18_40) {flag = "sf"} : (i64) -> ()
      "braid.br"()[^bb1b] : () -> ()
    ^bb1b:  // 0x40103b
      %bb1b_0 = "braid.get"() {reg = "rdx"} : () -> i64
      "braid.set"(%bb1b_0) {reg = "rsi"} : (i64) -> ()
      "braid.br"()[^bb1e] : () -> ()
    ^bb1e:  // 0x40103e
      %bb1e_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb1e_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e_0 = "braid.eq"(%bb1e_1, %bb1e_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb1e_0)[^bb10, ^bb20] : (i64) -> ()
    ^bb20:  // 0x401040
      %bb20_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb20_1 = "braid.load"(%bb20_0) {bytes = 8 : i64} : (i64) -> i64
      %bb20_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb20_3 = "braid.add"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      "braid.set"(%bb20_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb20_1) : (i64) -> ()
    ^bb21:  // 0x401041
      "braid.br"()[^ext401050] : () -> ()
    ^ext401032:
      "braid.tail"() {target = 4198450 : i64} : () -> ()
    ^ext401050:
      "braid.tail"() {target = 4198480 : i64} : () -> ()
  }) {sym_name = "gcd", entry = 4198432 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401050
      %bb0_0 = "braid.get"() {reg = "rsi"} : () -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401053
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
    ^bb6:  // 0x401056
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
    ^bba:  // 0x40105a
      %bba_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba_1 = "braid.load"(%bba_0) {bytes = 8 : i64} : (i64) -> i64
      %bba_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bba_3 = "braid.add"(%bba_0, %bba_2) : (i64, i64) -> i64
      "braid.set"(%bba_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bba_1) : (i64) -> ()
    ^bbb:  // 0x40105b
      "braid.br"()[^ext401060] : () -> ()
    ^ext401060:
      "braid.tail"() {target = 4198496 : i64} : () -> ()
  }) {sym_name = "max_u64", entry = 4198480 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401060
      %bb0_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb0_8 = "braid.get"() {reg = "rsi"} : () -> i64
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
    ^bb3:  // 0x401063
      %bb3_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid.cond_br"(%bb3_0)[^bb1e, ^bb5] : (i64) -> ()
    ^bb5:  // 0x401065
      %bb5_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb5_8 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb5_9 = "braid.shl"(%bb5_0, %bb5_8) : (i64, i64) -> i64
      %bb5_11 = "braid.const"() {value = 61 : i64} : () -> i64
      %bb5_12 = "braid.lshr"(%bb5_0, %bb5_11) : (i64, i64) -> i64
      %bb5_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb5_14 = "braid.and"(%bb5_12, %bb5_13) : (i64, i64) -> i64
      "braid.setf"(%bb5_14) {flag = "cf"} : (i64) -> ()
      %bb5_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb5_17) {flag = "of"} : (i64) -> ()
      %bb5_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb5_24) {flag = "af"} : (i64) -> ()
      %bb5_32 = "braid.zext"(%bb5_9) {bits = 8 : i64} : (i64) -> i64
      %bb5_33 = "braid.popcnt"(%bb5_32) : (i64) -> i64
      %bb5_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb5_35 = "braid.and"(%bb5_33, %bb5_34) : (i64, i64) -> i64
      %bb5_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb5_37 = "braid.eq"(%bb5_35, %bb5_36) : (i64, i64) -> i64
      "braid.setf"(%bb5_37) {flag = "pf"} : (i64) -> ()
      %bb5_38 = "braid.eq"(%bb5_9, %bb5_36) : (i64, i64) -> i64
      "braid.setf"(%bb5_38) {flag = "zf"} : (i64) -> ()
      %bb5_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb5_40 = "braid.and"(%bb5_9, %bb5_39) : (i64, i64) -> i64
      "braid.setf"(%bb5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb5_9) {reg = "rsi"} : (i64) -> ()
      "braid.br"()[^bb9] : () -> ()
    ^bb9:  // 0x401069
      %bb9_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb9_0 = "braid.zext"(%bb9_1) {bits = 32 : i64} : (i64) -> i64
      %bb9_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb9_8 = "braid.zext"(%bb9_9) {bits = 32 : i64} : (i64) -> i64
      %bb9_16 = "braid.xor"(%bb9_0, %bb9_8) : (i64, i64) -> i64
      %bb9_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb9_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb9_17) {flag = "of"} : (i64) -> ()
      %bb9_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb9_24) {flag = "af"} : (i64) -> ()
      %bb9_32 = "braid.zext"(%bb9_16) {bits = 8 : i64} : (i64) -> i64
      %bb9_33 = "braid.popcnt"(%bb9_32) : (i64) -> i64
      %bb9_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb9_35 = "braid.and"(%bb9_33, %bb9_34) : (i64, i64) -> i64
      %bb9_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9_37 = "braid.eq"(%bb9_35, %bb9_36) : (i64, i64) -> i64
      "braid.setf"(%bb9_37) {flag = "pf"} : (i64) -> ()
      %bb9_38 = "braid.eq"(%bb9_16, %bb9_36) : (i64, i64) -> i64
      "braid.setf"(%bb9_38) {flag = "zf"} : (i64) -> ()
      %bb9_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb9_40 = "braid.and"(%bb9_16, %bb9_39) : (i64, i64) -> i64
      "braid.setf"(%bb9_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb9_16) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bbb] : () -> ()
    ^bbb:  // 0x40106b
      %bbb_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbb_0 = "braid.zext"(%bbb_1) {bits = 32 : i64} : (i64) -> i64
      %bbb_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbb_8 = "braid.zext"(%bbb_9) {bits = 32 : i64} : (i64) -> i64
      %bbb_16 = "braid.xor"(%bbb_0, %bbb_8) : (i64, i64) -> i64
      %bbb_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbb_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbb_17) {flag = "of"} : (i64) -> ()
      %bbb_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbb_24) {flag = "af"} : (i64) -> ()
      %bbb_32 = "braid.zext"(%bbb_16) {bits = 8 : i64} : (i64) -> i64
      %bbb_33 = "braid.popcnt"(%bbb_32) : (i64) -> i64
      %bbb_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbb_35 = "braid.and"(%bbb_33, %bbb_34) : (i64, i64) -> i64
      %bbb_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb_37 = "braid.eq"(%bbb_35, %bbb_36) : (i64, i64) -> i64
      "braid.setf"(%bbb_37) {flag = "pf"} : (i64) -> ()
      %bbb_38 = "braid.eq"(%bbb_16, %bbb_36) : (i64, i64) -> i64
      "braid.setf"(%bbb_38) {flag = "zf"} : (i64) -> ()
      %bbb_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbb_40 = "braid.and"(%bbb_16, %bbb_39) : (i64, i64) -> i64
      "braid.setf"(%bbb_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbb_16) {reg = "rcx"} : (i64) -> ()
      "braid.br"()[^bbd] : () -> ()
    ^bbd:  // 0x40106d
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401070
      %bb10_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb10_3 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb10_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_5 = "braid.mul"(%bb10_3, %bb10_4) : (i64, i64) -> i64
      %bb10_6 = "braid.add"(%bb10_2, %bb10_5) : (i64, i64) -> i64
      %bb10_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_1 = "braid.add"(%bb10_6, %bb10_7) : (i64, i64) -> i64
      %bb10_0 = "braid.load"(%bb10_1) {bytes = 8 : i64} : (i64) -> i64
      %bb10_8 = "braid.get"() {reg = "rax"} : () -> i64
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
      "braid.set"(%bb10_16) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb14] : () -> ()
    ^bb14:  // 0x401074
      %bb14_0 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb14_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb14_16 = "braid.add"(%bb14_0, %bb14_8) : (i64, i64) -> i64
      %bb14_18 = "braid.ult"(%bb14_16, %bb14_0) : (i64, i64) -> i64
      "braid.setf"(%bb14_18) {flag = "cf"} : (i64) -> ()
      %bb14_19 = "braid.xor"(%bb14_0, %bb14_16) : (i64, i64) -> i64
      %bb14_20 = "braid.xor"(%bb14_8, %bb14_16) : (i64, i64) -> i64
      %bb14_21 = "braid.and"(%bb14_19, %bb14_20) : (i64, i64) -> i64
      %bb14_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb14_23 = "braid.and"(%bb14_21, %bb14_22) : (i64, i64) -> i64
      "braid.setf"(%bb14_23) {flag = "of"} : (i64) -> ()
      %bb14_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb14_24) {flag = "af"} : (i64) -> ()
      %bb14_32 = "braid.zext"(%bb14_16) {bits = 8 : i64} : (i64) -> i64
      %bb14_33 = "braid.popcnt"(%bb14_32) : (i64) -> i64
      %bb14_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14_35 = "braid.and"(%bb14_33, %bb14_34) : (i64, i64) -> i64
      %bb14_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_37 = "braid.eq"(%bb14_35, %bb14_36) : (i64, i64) -> i64
      "braid.setf"(%bb14_37) {flag = "pf"} : (i64) -> ()
      %bb14_38 = "braid.eq"(%bb14_16, %bb14_36) : (i64, i64) -> i64
      "braid.setf"(%bb14_38) {flag = "zf"} : (i64) -> ()
      %bb14_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb14_40 = "braid.and"(%bb14_16, %bb14_39) : (i64, i64) -> i64
      "braid.setf"(%bb14_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb14_16) {reg = "rcx"} : (i64) -> ()
      "braid.br"()[^bb18] : () -> ()
    ^bb18:  // 0x401078
      %bb18_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb18_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb18_16 = "braid.sub"(%bb18_0, %bb18_8) : (i64, i64) -> i64
      %bb18_18 = "braid.ult"(%bb18_0, %bb18_8) : (i64, i64) -> i64
      "braid.setf"(%bb18_18) {flag = "cf"} : (i64) -> ()
      %bb18_19 = "braid.xor"(%bb18_0, %bb18_8) : (i64, i64) -> i64
      %bb18_20 = "braid.xor"(%bb18_0, %bb18_16) : (i64, i64) -> i64
      %bb18_21 = "braid.and"(%bb18_19, %bb18_20) : (i64, i64) -> i64
      %bb18_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb18_23 = "braid.and"(%bb18_21, %bb18_22) : (i64, i64) -> i64
      "braid.setf"(%bb18_23) {flag = "of"} : (i64) -> ()
      %bb18_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb18_24) {flag = "af"} : (i64) -> ()
      %bb18_32 = "braid.zext"(%bb18_16) {bits = 8 : i64} : (i64) -> i64
      %bb18_33 = "braid.popcnt"(%bb18_32) : (i64) -> i64
      %bb18_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb18_35 = "braid.and"(%bb18_33, %bb18_34) : (i64, i64) -> i64
      %bb18_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_37 = "braid.eq"(%bb18_35, %bb18_36) : (i64, i64) -> i64
      "braid.setf"(%bb18_37) {flag = "pf"} : (i64) -> ()
      %bb18_38 = "braid.eq"(%bb18_16, %bb18_36) : (i64, i64) -> i64
      "braid.setf"(%bb18_38) {flag = "zf"} : (i64) -> ()
      %bb18_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb18_40 = "braid.and"(%bb18_16, %bb18_39) : (i64, i64) -> i64
      "braid.setf"(%bb18_40) {flag = "sf"} : (i64) -> ()
      "braid.br"()[^bb1b] : () -> ()
    ^bb1b:  // 0x40107b
      %bb1b_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb1b_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b_0 = "braid.eq"(%bb1b_1, %bb1b_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb1b_0)[^bb10, ^bb1d] : (i64) -> ()
    ^bb1d:  // 0x40107d
      %bb1d_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1d_1 = "braid.load"(%bb1d_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1d_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1d_3 = "braid.add"(%bb1d_0, %bb1d_2) : (i64, i64) -> i64
      "braid.set"(%bb1d_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb1d_1) : (i64) -> ()
    ^bb1e:  // 0x40107e
      %bb1e_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1e_0 = "braid.zext"(%bb1e_1) {bits = 32 : i64} : (i64) -> i64
      %bb1e_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1e_8 = "braid.zext"(%bb1e_9) {bits = 32 : i64} : (i64) -> i64
      %bb1e_16 = "braid.xor"(%bb1e_0, %bb1e_8) : (i64, i64) -> i64
      %bb1e_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1e_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1e_17) {flag = "of"} : (i64) -> ()
      %bb1e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1e_24) {flag = "af"} : (i64) -> ()
      %bb1e_32 = "braid.zext"(%bb1e_16) {bits = 8 : i64} : (i64) -> i64
      %bb1e_33 = "braid.popcnt"(%bb1e_32) : (i64) -> i64
      %bb1e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1e_35 = "braid.and"(%bb1e_33, %bb1e_34) : (i64, i64) -> i64
      %bb1e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e_37 = "braid.eq"(%bb1e_35, %bb1e_36) : (i64, i64) -> i64
      "braid.setf"(%bb1e_37) {flag = "pf"} : (i64) -> ()
      %bb1e_38 = "braid.eq"(%bb1e_16, %bb1e_36) : (i64, i64) -> i64
      "braid.setf"(%bb1e_38) {flag = "zf"} : (i64) -> ()
      %bb1e_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1e_40 = "braid.and"(%bb1e_16, %bb1e_39) : (i64, i64) -> i64
      "braid.setf"(%bb1e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1e_16) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb20] : () -> ()
    ^bb20:  // 0x401080
      %bb20_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb20_1 = "braid.load"(%bb20_0) {bytes = 8 : i64} : (i64) -> i64
      %bb20_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb20_3 = "braid.add"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      "braid.set"(%bb20_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb20_1) : (i64) -> ()
  }) {sym_name = "sum_slice", entry = 4198496 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
