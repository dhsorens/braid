"braid.module"() ({
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb0_0 = "braid.load"(%bb0_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401003
      %bb3_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb3_0 = "braid.load"(%bb3_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb3_0) {reg = "rcx"} : (i64) -> ()
      "braid.br"()[^bb6] : () -> ()
    ^bb6:  // 0x401006
      %bb6_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb6_8 = "braid.get"() {reg = "rdi"} : () -> i64
      "braid.store"(%bb6_8, %bb6_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb9] : () -> ()
    ^bb9:  // 0x401009
      %bb9_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb9_8 = "braid.get"() {reg = "rsi"} : () -> i64
      "braid.store"(%bb9_8, %bb9_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x40100c
      %bbc_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbc_1 = "braid.load"(%bbc_0) {bytes = 8 : i64} : (i64) -> i64
      %bbc_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbc_3 = "braid.add"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      "braid.set"(%bbc_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bbc_1) : (i64) -> ()
    ^bbd:  // 0x40100d
      "braid.br"()[^ext401010] : () -> ()
    ^ext401010:
      "braid.tail"() {target = 4198416 : i64} : () -> ()
  }) {sym_name = "swap", entry = 4198400 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401010
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
    ^bb2:  // 0x401012
      %bb2_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb2_8 = "braid.get"() {reg = "rsi"} : () -> i64
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
    ^bb5:  // 0x401015
      %bb5_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid.cond_br"(%bb5_0)[^bb1c, ^bb7] : (i64) -> ()
    ^bb7:  // 0x401017
      %bb7_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb7_0 = "braid.zext"(%bb7_1) {bits = 32 : i64} : (i64) -> i64
      %bb7_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb7_8 = "braid.zext"(%bb7_9) {bits = 32 : i64} : (i64) -> i64
      %bb7_16 = "braid.xor"(%bb7_0, %bb7_8) : (i64, i64) -> i64
      %bb7_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb7_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb7_17) {flag = "of"} : (i64) -> ()
      %bb7_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb7_24) {flag = "af"} : (i64) -> ()
      %bb7_32 = "braid.zext"(%bb7_16) {bits = 8 : i64} : (i64) -> i64
      %bb7_33 = "braid.popcnt"(%bb7_32) : (i64) -> i64
      %bb7_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb7_35 = "braid.and"(%bb7_33, %bb7_34) : (i64, i64) -> i64
      %bb7_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7_37 = "braid.eq"(%bb7_35, %bb7_36) : (i64, i64) -> i64
      "braid.setf"(%bb7_37) {flag = "pf"} : (i64) -> ()
      %bb7_38 = "braid.eq"(%bb7_16, %bb7_36) : (i64, i64) -> i64
      "braid.setf"(%bb7_38) {flag = "zf"} : (i64) -> ()
      %bb7_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb7_40 = "braid.and"(%bb7_16, %bb7_39) : (i64, i64) -> i64
      "braid.setf"(%bb7_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb7_16) {reg = "rcx"} : (i64) -> ()
      "braid.br"()[^bb9] : () -> ()
    ^bb9:  // 0x401019
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401020
      %bb10_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb10_3 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb10_4 = "braid.const"() {value = 8 : i64} : () -> i64
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
    ^bb14:  // 0x401024
      %bb14_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb14_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14_16 = "braid.add"(%bb14_0, %bb14_8) : (i64, i64) -> i64
      %bb14_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb14_20 = "braid.eq"(%bb14_16, %bb14_19) : (i64, i64) -> i64
      "braid.setf"(%bb14_20) {flag = "of"} : (i64) -> ()
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
      "braid.br"()[^bb17] : () -> ()
    ^bb17:  // 0x401027
      %bb17_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb17_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb17_16 = "braid.sub"(%bb17_0, %bb17_8) : (i64, i64) -> i64
      %bb17_18 = "braid.ult"(%bb17_0, %bb17_8) : (i64, i64) -> i64
      "braid.setf"(%bb17_18) {flag = "cf"} : (i64) -> ()
      %bb17_19 = "braid.xor"(%bb17_0, %bb17_8) : (i64, i64) -> i64
      %bb17_20 = "braid.xor"(%bb17_0, %bb17_16) : (i64, i64) -> i64
      %bb17_21 = "braid.and"(%bb17_19, %bb17_20) : (i64, i64) -> i64
      %bb17_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb17_23 = "braid.and"(%bb17_21, %bb17_22) : (i64, i64) -> i64
      "braid.setf"(%bb17_23) {flag = "of"} : (i64) -> ()
      %bb17_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb17_24) {flag = "af"} : (i64) -> ()
      %bb17_32 = "braid.zext"(%bb17_16) {bits = 8 : i64} : (i64) -> i64
      %bb17_33 = "braid.popcnt"(%bb17_32) : (i64) -> i64
      %bb17_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb17_35 = "braid.and"(%bb17_33, %bb17_34) : (i64, i64) -> i64
      %bb17_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb17_37 = "braid.eq"(%bb17_35, %bb17_36) : (i64, i64) -> i64
      "braid.setf"(%bb17_37) {flag = "pf"} : (i64) -> ()
      %bb17_38 = "braid.eq"(%bb17_16, %bb17_36) : (i64, i64) -> i64
      "braid.setf"(%bb17_38) {flag = "zf"} : (i64) -> ()
      %bb17_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb17_40 = "braid.and"(%bb17_16, %bb17_39) : (i64, i64) -> i64
      "braid.setf"(%bb17_40) {flag = "sf"} : (i64) -> ()
      "braid.br"()[^bb1a] : () -> ()
    ^bb1a:  // 0x40102a
      %bb1a_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb1a_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1a_0 = "braid.eq"(%bb1a_1, %bb1a_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb1a_0)[^bb10, ^bb1c] : (i64) -> ()
    ^bb1c:  // 0x40102c
      %bb1c_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1c_1 = "braid.load"(%bb1c_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1c_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c_3 = "braid.add"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      "braid.set"(%bb1c_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb1c_1) : (i64) -> ()
    ^bb1d:  // 0x40102d
      "braid.br"()[^ext401030] : () -> ()
    ^ext401030:
      "braid.tail"() {target = 4198448 : i64} : () -> ()
  }) {sym_name = "sum_array", entry = 4198416 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401030
      %bb0_0 = "braid.get"() {reg = "rsi"} : () -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401033
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
    ^bb6:  // 0x401036
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
    ^bba:  // 0x40103a
      %bba_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba_1 = "braid.load"(%bba_0) {bytes = 8 : i64} : (i64) -> i64
      %bba_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bba_3 = "braid.add"(%bba_0, %bba_2) : (i64, i64) -> i64
      "braid.set"(%bba_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bba_1) : (i64) -> ()
    ^bbb:  // 0x40103b
      "braid.br"()[^ext401040] : () -> ()
    ^ext401040:
      "braid.tail"() {target = 4198464 : i64} : () -> ()
  }) {sym_name = "max2", entry = 4198448 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401040
      %bb0_0 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb0_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb0_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_10 = "braid.sub"(%bb0_8, %bb0_9) : (i64, i64) -> i64
      "braid.set"(%bb0_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb0_10, %bb0_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb1] : () -> ()
    ^bb1:  // 0x401041
      %bb1_0 = "braid.get"() {reg = "rdx"} : () -> i64
      "braid.set"(%bb1_0) {reg = "rbx"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x401044
      %bb4_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb4_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb4_10 = "braid.sub"(%bb4_8, %bb4_9) : (i64, i64) -> i64
      "braid.set"(%bb4_10) {reg = "rsp"} : (i64) -> ()
      %bb4_11 = "braid.const"() {value = 4198473 : i64} : () -> i64
      "braid.store"(%bb4_10, %bb4_11) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^ext401030] : () -> ()
    ^bb9:  // 0x401049
      %bb9_0 = "braid.get"() {reg = "rax"} : () -> i64
      "braid.set"(%bb9_0) {reg = "rdi"} : (i64) -> ()
      "braid.br"()[^bbc] : () -> ()
    ^bbc:  // 0x40104c
      %bbc_0 = "braid.get"() {reg = "rbx"} : () -> i64
      "braid.set"(%bbc_0) {reg = "rsi"} : (i64) -> ()
      "braid.br"()[^bbf] : () -> ()
    ^bbf:  // 0x40104f
      %bbf_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbf_1 = "braid.load"(%bbf_0) {bytes = 8 : i64} : (i64) -> i64
      %bbf_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbf_3 = "braid.add"(%bbf_0, %bbf_2) : (i64, i64) -> i64
      "braid.set"(%bbf_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bbf_1) {reg = "rbx"} : (i64) -> ()
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401050
      "braid.br"()[^ext401030] : () -> ()
    ^ext401030:
      "braid.tail"() {target = 4198448 : i64} : () -> ()
  }) {sym_name = "max3", entry = 4198464 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
