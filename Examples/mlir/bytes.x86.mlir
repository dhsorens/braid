"braid.module"() ({
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_0 = "braid.const"() {value = -1 : i64} : () -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb7] : () -> ()
    ^bb7:  // 0x401007
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401010
      %bb10_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb10_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb10_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_5 = "braid.mul"(%bb10_3, %bb10_4) : (i64, i64) -> i64
      %bb10_6 = "braid.add"(%bb10_2, %bb10_5) : (i64, i64) -> i64
      %bb10_7 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_1 = "braid.add"(%bb10_6, %bb10_7) : (i64, i64) -> i64
      %bb10_0 = "braid.load"(%bb10_1) {bytes = 1 : i64} : (i64) -> i64
      %bb10_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_16 = "braid.sub"(%bb10_0, %bb10_8) : (i64, i64) -> i64
      %bb10_17 = "braid.zext"(%bb10_16) {bits = 8 : i64} : (i64) -> i64
      %bb10_18 = "braid.ult"(%bb10_0, %bb10_8) : (i64, i64) -> i64
      "braid.setf"(%bb10_18) {flag = "cf"} : (i64) -> ()
      %bb10_19 = "braid.xor"(%bb10_0, %bb10_8) : (i64, i64) -> i64
      %bb10_20 = "braid.xor"(%bb10_0, %bb10_17) : (i64, i64) -> i64
      %bb10_21 = "braid.and"(%bb10_19, %bb10_20) : (i64, i64) -> i64
      %bb10_22 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb10_23 = "braid.and"(%bb10_21, %bb10_22) : (i64, i64) -> i64
      "braid.setf"(%bb10_23) {flag = "of"} : (i64) -> ()
      %bb10_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb10_24) {flag = "af"} : (i64) -> ()
      %bb10_32 = "braid.zext"(%bb10_17) {bits = 8 : i64} : (i64) -> i64
      %bb10_33 = "braid.popcnt"(%bb10_32) : (i64) -> i64
      %bb10_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_35 = "braid.and"(%bb10_33, %bb10_34) : (i64, i64) -> i64
      %bb10_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_37 = "braid.eq"(%bb10_35, %bb10_36) : (i64, i64) -> i64
      "braid.setf"(%bb10_37) {flag = "pf"} : (i64) -> ()
      %bb10_38 = "braid.eq"(%bb10_17, %bb10_36) : (i64, i64) -> i64
      "braid.setf"(%bb10_38) {flag = "zf"} : (i64) -> ()
      %bb10_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb10_40 = "braid.and"(%bb10_17, %bb10_39) : (i64, i64) -> i64
      "braid.setf"(%bb10_40) {flag = "sf"} : (i64) -> ()
      "braid.br"()[^bb15] : () -> ()
    ^bb15:  // 0x401015
      %bb15_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb15_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb15_0 = "braid.add"(%bb15_1, %bb15_2) : (i64, i64) -> i64
      "braid.set"(%bb15_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb19] : () -> ()
    ^bb19:  // 0x401019
      %bb19_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb19_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb19_0 = "braid.eq"(%bb19_1, %bb19_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb19_0)[^bb10, ^bb1b] : (i64) -> ()
    ^bb1b:  // 0x40101b
      %bb1b_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1b_1 = "braid.load"(%bb1b_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1b_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1b_3 = "braid.add"(%bb1b_0, %bb1b_2) : (i64, i64) -> i64
      "braid.set"(%bb1b_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb1b_1) : (i64) -> ()
    ^bb1c:  // 0x40101c
      "braid.br"()[^ext401020] : () -> ()
    ^ext401020:
      "braid.tail"() {target = 4198432 : i64} : () -> ()
  }) {sym_name = "str_len", entry = 4198400 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401020
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
    ^bb3:  // 0x401023
      %bb3_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid.cond_br"(%bb3_0)[^bb1b, ^bb5] : (i64) -> ()
    ^bb5:  // 0x401025
      %bb5_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb5_0 = "braid.zext"(%bb5_1) {bits = 32 : i64} : (i64) -> i64
      %bb5_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb5_8 = "braid.zext"(%bb5_9) {bits = 32 : i64} : (i64) -> i64
      %bb5_16 = "braid.xor"(%bb5_0, %bb5_8) : (i64, i64) -> i64
      %bb5_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb5_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb5_17) {flag = "of"} : (i64) -> ()
      %bb5_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb5_24) {flag = "af"} : (i64) -> ()
      %bb5_32 = "braid.zext"(%bb5_16) {bits = 8 : i64} : (i64) -> i64
      %bb5_33 = "braid.popcnt"(%bb5_32) : (i64) -> i64
      %bb5_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb5_35 = "braid.and"(%bb5_33, %bb5_34) : (i64, i64) -> i64
      %bb5_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb5_37 = "braid.eq"(%bb5_35, %bb5_36) : (i64, i64) -> i64
      "braid.setf"(%bb5_37) {flag = "pf"} : (i64) -> ()
      %bb5_38 = "braid.eq"(%bb5_16, %bb5_36) : (i64, i64) -> i64
      "braid.setf"(%bb5_38) {flag = "zf"} : (i64) -> ()
      %bb5_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb5_40 = "braid.and"(%bb5_16, %bb5_39) : (i64, i64) -> i64
      "braid.setf"(%bb5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb5_16) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb7] : () -> ()
    ^bb7:  // 0x401027
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401030
      %bb10_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb10_0 = "braid.zext"(%bb10_1) {bits = 8 : i64} : (i64) -> i64
      %bb10_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb10_10 = "braid.get"() {reg = "rax"} : () -> i64
      %bb10_11 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_12 = "braid.mul"(%bb10_10, %bb10_11) : (i64, i64) -> i64
      %bb10_13 = "braid.add"(%bb10_9, %bb10_12) : (i64, i64) -> i64
      %bb10_14 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_8 = "braid.add"(%bb10_13, %bb10_14) : (i64, i64) -> i64
      "braid.store"(%bb10_8, %bb10_0) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb13] : () -> ()
    ^bb13:  // 0x401033
      %bb13_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb13_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb13_16 = "braid.add"(%bb13_0, %bb13_8) : (i64, i64) -> i64
      %bb13_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb13_20 = "braid.eq"(%bb13_16, %bb13_19) : (i64, i64) -> i64
      "braid.setf"(%bb13_20) {flag = "of"} : (i64) -> ()
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
      "braid.set"(%bb13_16) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb16] : () -> ()
    ^bb16:  // 0x401036
      %bb16_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb16_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb16_16 = "braid.sub"(%bb16_0, %bb16_8) : (i64, i64) -> i64
      %bb16_18 = "braid.ult"(%bb16_0, %bb16_8) : (i64, i64) -> i64
      "braid.setf"(%bb16_18) {flag = "cf"} : (i64) -> ()
      %bb16_19 = "braid.xor"(%bb16_0, %bb16_8) : (i64, i64) -> i64
      %bb16_20 = "braid.xor"(%bb16_0, %bb16_16) : (i64, i64) -> i64
      %bb16_21 = "braid.and"(%bb16_19, %bb16_20) : (i64, i64) -> i64
      %bb16_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb16_23 = "braid.and"(%bb16_21, %bb16_22) : (i64, i64) -> i64
      "braid.setf"(%bb16_23) {flag = "of"} : (i64) -> ()
      %bb16_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb16_24) {flag = "af"} : (i64) -> ()
      %bb16_32 = "braid.zext"(%bb16_16) {bits = 8 : i64} : (i64) -> i64
      %bb16_33 = "braid.popcnt"(%bb16_32) : (i64) -> i64
      %bb16_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb16_35 = "braid.and"(%bb16_33, %bb16_34) : (i64, i64) -> i64
      %bb16_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb16_37 = "braid.eq"(%bb16_35, %bb16_36) : (i64, i64) -> i64
      "braid.setf"(%bb16_37) {flag = "pf"} : (i64) -> ()
      %bb16_38 = "braid.eq"(%bb16_16, %bb16_36) : (i64, i64) -> i64
      "braid.setf"(%bb16_38) {flag = "zf"} : (i64) -> ()
      %bb16_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb16_40 = "braid.and"(%bb16_16, %bb16_39) : (i64, i64) -> i64
      "braid.setf"(%bb16_40) {flag = "sf"} : (i64) -> ()
      "braid.br"()[^bb19] : () -> ()
    ^bb19:  // 0x401039
      %bb19_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb19_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb19_0 = "braid.eq"(%bb19_1, %bb19_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb19_0)[^bb10, ^bb1b] : (i64) -> ()
    ^bb1b:  // 0x40103b
      %bb1b_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1b_1 = "braid.load"(%bb1b_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1b_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1b_3 = "braid.add"(%bb1b_0, %bb1b_2) : (i64, i64) -> i64
      "braid.set"(%bb1b_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb1b_1) : (i64) -> ()
    ^bb1c:  // 0x40103c
      "braid.br"()[^ext401040] : () -> ()
    ^ext401040:
      "braid.tail"() {target = 4198464 : i64} : () -> ()
  }) {sym_name = "fill", entry = 4198432 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401040
      %bb0_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb0_0 = "braid.zext"(%bb0_1) {bits = 32 : i64} : (i64) -> i64
      %bb0_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb0_8 = "braid.zext"(%bb0_9) {bits = 32 : i64} : (i64) -> i64
      %bb0_16 = "braid.xor"(%bb0_0, %bb0_8) : (i64, i64) -> i64
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
      %bb0_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb0_40 = "braid.and"(%bb0_16, %bb0_39) : (i64, i64) -> i64
      "braid.setf"(%bb0_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb0_16) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb2] : () -> ()
    ^bb2:  // 0x401042
      %bb2_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb2_8 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb2_16 = "braid.and"(%bb2_0, %bb2_8) : (i64, i64) -> i64
      %bb2_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb2_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb2_17) {flag = "of"} : (i64) -> ()
      %bb2_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb2_24) {flag = "af"} : (i64) -> ()
      %bb2_32 = "braid.zext"(%bb2_16) {bits = 8 : i64} : (i64) -> i64
      %bb2_33 = "braid.popcnt"(%bb2_32) : (i64) -> i64
      %bb2_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2_35 = "braid.and"(%bb2_33, %bb2_34) : (i64, i64) -> i64
      %bb2_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2_37 = "braid.eq"(%bb2_35, %bb2_36) : (i64, i64) -> i64
      "braid.setf"(%bb2_37) {flag = "pf"} : (i64) -> ()
      %bb2_38 = "braid.eq"(%bb2_16, %bb2_36) : (i64, i64) -> i64
      "braid.setf"(%bb2_38) {flag = "zf"} : (i64) -> ()
      %bb2_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb2_40 = "braid.and"(%bb2_16, %bb2_39) : (i64, i64) -> i64
      "braid.setf"(%bb2_40) {flag = "sf"} : (i64) -> ()
      "braid.br"()[^bb5] : () -> ()
    ^bb5:  // 0x401045
      %bb5_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid.cond_br"(%bb5_0)[^bb1d, ^bb7] : (i64) -> ()
    ^bb7:  // 0x401047
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401050
      %bb10_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb10_0 = "braid.zext"(%bb10_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb10_0) {reg = "rcx"} : (i64) -> ()
      "braid.br"()[^bb12] : () -> ()
    ^bb12:  // 0x401052
      %bb12_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb12_0 = "braid.zext"(%bb12_1) {bits = 32 : i64} : (i64) -> i64
      %bb12_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb12_16 = "braid.and"(%bb12_0, %bb12_8) : (i64, i64) -> i64
      %bb12_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb12_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb12_17) {flag = "of"} : (i64) -> ()
      %bb12_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb12_24) {flag = "af"} : (i64) -> ()
      %bb12_32 = "braid.zext"(%bb12_16) {bits = 8 : i64} : (i64) -> i64
      %bb12_33 = "braid.popcnt"(%bb12_32) : (i64) -> i64
      %bb12_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb12_35 = "braid.and"(%bb12_33, %bb12_34) : (i64, i64) -> i64
      %bb12_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12_37 = "braid.eq"(%bb12_35, %bb12_36) : (i64, i64) -> i64
      "braid.setf"(%bb12_37) {flag = "pf"} : (i64) -> ()
      %bb12_38 = "braid.eq"(%bb12_16, %bb12_36) : (i64, i64) -> i64
      "braid.setf"(%bb12_38) {flag = "zf"} : (i64) -> ()
      %bb12_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb12_40 = "braid.and"(%bb12_16, %bb12_39) : (i64, i64) -> i64
      "braid.setf"(%bb12_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb12_16) {reg = "rcx"} : (i64) -> ()
      "braid.br"()[^bb15] : () -> ()
    ^bb15:  // 0x401055
      %bb15_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb15_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb15_16 = "braid.add"(%bb15_0, %bb15_8) : (i64, i64) -> i64
      %bb15_18 = "braid.ult"(%bb15_16, %bb15_0) : (i64, i64) -> i64
      "braid.setf"(%bb15_18) {flag = "cf"} : (i64) -> ()
      %bb15_19 = "braid.xor"(%bb15_0, %bb15_16) : (i64, i64) -> i64
      %bb15_20 = "braid.xor"(%bb15_8, %bb15_16) : (i64, i64) -> i64
      %bb15_21 = "braid.and"(%bb15_19, %bb15_20) : (i64, i64) -> i64
      %bb15_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb15_23 = "braid.and"(%bb15_21, %bb15_22) : (i64, i64) -> i64
      "braid.setf"(%bb15_23) {flag = "of"} : (i64) -> ()
      %bb15_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb15_24) {flag = "af"} : (i64) -> ()
      %bb15_32 = "braid.zext"(%bb15_16) {bits = 8 : i64} : (i64) -> i64
      %bb15_33 = "braid.popcnt"(%bb15_32) : (i64) -> i64
      %bb15_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb15_35 = "braid.and"(%bb15_33, %bb15_34) : (i64, i64) -> i64
      %bb15_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15_37 = "braid.eq"(%bb15_35, %bb15_36) : (i64, i64) -> i64
      "braid.setf"(%bb15_37) {flag = "pf"} : (i64) -> ()
      %bb15_38 = "braid.eq"(%bb15_16, %bb15_36) : (i64, i64) -> i64
      "braid.setf"(%bb15_38) {flag = "zf"} : (i64) -> ()
      %bb15_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb15_40 = "braid.and"(%bb15_16, %bb15_39) : (i64, i64) -> i64
      "braid.setf"(%bb15_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb15_16) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb18] : () -> ()
    ^bb18:  // 0x401058
      %bb18_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb18_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb18_9 = "braid.lshr"(%bb18_0, %bb18_8) : (i64, i64) -> i64
      %bb18_11 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_12 = "braid.lshr"(%bb18_0, %bb18_11) : (i64, i64) -> i64
      %bb18_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb18_14 = "braid.and"(%bb18_12, %bb18_13) : (i64, i64) -> i64
      "braid.setf"(%bb18_14) {flag = "cf"} : (i64) -> ()
      %bb18_16 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb18_17 = "braid.and"(%bb18_0, %bb18_16) : (i64, i64) -> i64
      "braid.setf"(%bb18_17) {flag = "of"} : (i64) -> ()
      %bb18_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb18_24) {flag = "af"} : (i64) -> ()
      %bb18_32 = "braid.zext"(%bb18_9) {bits = 8 : i64} : (i64) -> i64
      %bb18_33 = "braid.popcnt"(%bb18_32) : (i64) -> i64
      %bb18_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb18_35 = "braid.and"(%bb18_33, %bb18_34) : (i64, i64) -> i64
      %bb18_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_37 = "braid.eq"(%bb18_35, %bb18_36) : (i64, i64) -> i64
      "braid.setf"(%bb18_37) {flag = "pf"} : (i64) -> ()
      %bb18_38 = "braid.eq"(%bb18_9, %bb18_36) : (i64, i64) -> i64
      "braid.setf"(%bb18_38) {flag = "zf"} : (i64) -> ()
      %bb18_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb18_40 = "braid.and"(%bb18_9, %bb18_39) : (i64, i64) -> i64
      "braid.setf"(%bb18_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb18_9) {reg = "rdi"} : (i64) -> ()
      "braid.br"()[^bb1b] : () -> ()
    ^bb1b:  // 0x40105b
      %bb1b_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb1b_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b_0 = "braid.eq"(%bb1b_1, %bb1b_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb1b_0)[^bb10, ^bb1d] : (i64) -> ()
    ^bb1d:  // 0x40105d
      %bb1d_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1d_1 = "braid.load"(%bb1d_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1d_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1d_3 = "braid.add"(%bb1d_0, %bb1d_2) : (i64, i64) -> i64
      "braid.set"(%bb1d_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb1d_1) : (i64) -> ()
  }) {sym_name = "count_ones", entry = 4198464 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
