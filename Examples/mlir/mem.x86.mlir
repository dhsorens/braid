"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb0_8 = "braid.get"() {reg = "rdx"} : () -> i64
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
      "braid_cf.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401003
      %bb3_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb3_0)[^bb1f, ^bb5] : (i64) -> ()
    ^bb5:  // 0x401005
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
      "braid_cf.br"()[^bb7] : () -> ()
    ^bb7:  // 0x401007
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401010
      %bb10_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb10_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb10_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_5 = "braid.mul"(%bb10_3, %bb10_4) : (i64, i64) -> i64
      %bb10_6 = "braid.add"(%bb10_2, %bb10_5) : (i64, i64) -> i64
      %bb10_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_1 = "braid.add"(%bb10_6, %bb10_7) : (i64, i64) -> i64
      %bb10_0 = "braid.load"(%bb10_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb10_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x401014
      %bb14_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb14_0 = "braid.zext"(%bb14_1) {bits = 8 : i64} : (i64) -> i64
      %bb14_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb14_10 = "braid.get"() {reg = "rax"} : () -> i64
      %bb14_11 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14_12 = "braid.mul"(%bb14_10, %bb14_11) : (i64, i64) -> i64
      %bb14_13 = "braid.add"(%bb14_9, %bb14_12) : (i64, i64) -> i64
      %bb14_14 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_8 = "braid.add"(%bb14_13, %bb14_14) : (i64, i64) -> i64
      "braid.store"(%bb14_8, %bb14_0) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb17] : () -> ()
    ^bb17:  // 0x401017
      %bb17_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb17_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb17_16 = "braid.add"(%bb17_0, %bb17_8) : (i64, i64) -> i64
      %bb17_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb17_20 = "braid.eq"(%bb17_16, %bb17_19) : (i64, i64) -> i64
      "braid.setf"(%bb17_20) {flag = "of"} : (i64) -> ()
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
      "braid.set"(%bb17_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1a] : () -> ()
    ^bb1a:  // 0x40101a
      %bb1a_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb1a_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1a_16 = "braid.sub"(%bb1a_0, %bb1a_8) : (i64, i64) -> i64
      %bb1a_18 = "braid.ult"(%bb1a_0, %bb1a_8) : (i64, i64) -> i64
      "braid.setf"(%bb1a_18) {flag = "cf"} : (i64) -> ()
      %bb1a_19 = "braid.xor"(%bb1a_0, %bb1a_8) : (i64, i64) -> i64
      %bb1a_20 = "braid.xor"(%bb1a_0, %bb1a_16) : (i64, i64) -> i64
      %bb1a_21 = "braid.and"(%bb1a_19, %bb1a_20) : (i64, i64) -> i64
      %bb1a_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1a_23 = "braid.and"(%bb1a_21, %bb1a_22) : (i64, i64) -> i64
      "braid.setf"(%bb1a_23) {flag = "of"} : (i64) -> ()
      %bb1a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1a_24) {flag = "af"} : (i64) -> ()
      %bb1a_32 = "braid.zext"(%bb1a_16) {bits = 8 : i64} : (i64) -> i64
      %bb1a_33 = "braid.popcnt"(%bb1a_32) : (i64) -> i64
      %bb1a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1a_35 = "braid.and"(%bb1a_33, %bb1a_34) : (i64, i64) -> i64
      %bb1a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1a_37 = "braid.eq"(%bb1a_35, %bb1a_36) : (i64, i64) -> i64
      "braid.setf"(%bb1a_37) {flag = "pf"} : (i64) -> ()
      %bb1a_38 = "braid.eq"(%bb1a_16, %bb1a_36) : (i64, i64) -> i64
      "braid.setf"(%bb1a_38) {flag = "zf"} : (i64) -> ()
      %bb1a_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1a_40 = "braid.and"(%bb1a_16, %bb1a_39) : (i64, i64) -> i64
      "braid.setf"(%bb1a_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb1d] : () -> ()
    ^bb1d:  // 0x40101d
      %bb1d_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb1d_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d_0 = "braid.eq"(%bb1d_1, %bb1d_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb1d_0)[^bb10, ^bb1f] : (i64) -> ()
    ^bb1f:  // 0x40101f
      %bb1f_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1f_1 = "braid.load"(%bb1f_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1f_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1f_3 = "braid.add"(%bb1f_0, %bb1f_2) : (i64, i64) -> i64
      "braid.set"(%bb1f_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb1f_1) : (i64) -> ()
  }) {sym_name = "copy_bytes", entry = 4198400 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401020
      %bb0_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb5] : () -> ()
    ^bb5:  // 0x401025
      %bb5_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb5_8 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb5_16 = "braid.and"(%bb5_0, %bb5_8) : (i64, i64) -> i64
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
      %bb5_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb5_40 = "braid.and"(%bb5_16, %bb5_39) : (i64, i64) -> i64
      "braid.setf"(%bb5_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x401028
      %bb8_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb8_0)[^bb23, ^bba] : (i64) -> ()
    ^bba:  // 0x40102a
      %bba_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bba_0 = "braid.zext"(%bba_1) {bits = 32 : i64} : (i64) -> i64
      %bba_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bba_8 = "braid.zext"(%bba_9) {bits = 32 : i64} : (i64) -> i64
      %bba_16 = "braid.xor"(%bba_0, %bba_8) : (i64, i64) -> i64
      %bba_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bba_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bba_17) {flag = "of"} : (i64) -> ()
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
      %bba_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bba_40 = "braid.and"(%bba_16, %bba_39) : (i64, i64) -> i64
      "braid.setf"(%bba_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bba_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x40102c
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401030
      %bb10_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb10_3 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb10_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10_5 = "braid.mul"(%bb10_3, %bb10_4) : (i64, i64) -> i64
      %bb10_6 = "braid.add"(%bb10_2, %bb10_5) : (i64, i64) -> i64
      %bb10_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_1 = "braid.add"(%bb10_6, %bb10_7) : (i64, i64) -> i64
      %bb10_0 = "braid.load"(%bb10_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb10_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb15] : () -> ()
    ^bb15:  // 0x401035
      %bb15_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb15_0 = "braid.zext"(%bb15_1) {bits = 8 : i64} : (i64) -> i64
      %bb15_10 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb15_11 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb15_12 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb15_13 = "braid.mul"(%bb15_11, %bb15_12) : (i64, i64) -> i64
      %bb15_14 = "braid.add"(%bb15_10, %bb15_13) : (i64, i64) -> i64
      %bb15_15 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15_9 = "braid.add"(%bb15_14, %bb15_15) : (i64, i64) -> i64
      %bb15_8 = "braid.load"(%bb15_9) {bytes = 1 : i64} : (i64) -> i64
      %bb15_16 = "braid.sub"(%bb15_0, %bb15_8) : (i64, i64) -> i64
      %bb15_17 = "braid.zext"(%bb15_16) {bits = 8 : i64} : (i64) -> i64
      %bb15_18 = "braid.ult"(%bb15_0, %bb15_8) : (i64, i64) -> i64
      "braid.setf"(%bb15_18) {flag = "cf"} : (i64) -> ()
      %bb15_19 = "braid.xor"(%bb15_0, %bb15_8) : (i64, i64) -> i64
      %bb15_20 = "braid.xor"(%bb15_0, %bb15_17) : (i64, i64) -> i64
      %bb15_21 = "braid.and"(%bb15_19, %bb15_20) : (i64, i64) -> i64
      %bb15_22 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb15_23 = "braid.and"(%bb15_21, %bb15_22) : (i64, i64) -> i64
      "braid.setf"(%bb15_23) {flag = "of"} : (i64) -> ()
      %bb15_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb15_24) {flag = "af"} : (i64) -> ()
      %bb15_32 = "braid.zext"(%bb15_17) {bits = 8 : i64} : (i64) -> i64
      %bb15_33 = "braid.popcnt"(%bb15_32) : (i64) -> i64
      %bb15_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb15_35 = "braid.and"(%bb15_33, %bb15_34) : (i64, i64) -> i64
      %bb15_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15_37 = "braid.eq"(%bb15_35, %bb15_36) : (i64, i64) -> i64
      "braid.setf"(%bb15_37) {flag = "pf"} : (i64) -> ()
      %bb15_38 = "braid.eq"(%bb15_17, %bb15_36) : (i64, i64) -> i64
      "braid.setf"(%bb15_38) {flag = "zf"} : (i64) -> ()
      %bb15_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb15_40 = "braid.and"(%bb15_17, %bb15_39) : (i64, i64) -> i64
      "braid.setf"(%bb15_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb19] : () -> ()
    ^bb19:  // 0x401039
      %bb19_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb19_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb19_0 = "braid.eq"(%bb19_1, %bb19_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb19_0)[^bb24, ^bb1b] : (i64) -> ()
    ^bb1b:  // 0x40103b
      %bb1b_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1b_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1b_16 = "braid.add"(%bb1b_0, %bb1b_8) : (i64, i64) -> i64
      %bb1b_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1b_20 = "braid.eq"(%bb1b_16, %bb1b_19) : (i64, i64) -> i64
      "braid.setf"(%bb1b_20) {flag = "of"} : (i64) -> ()
      %bb1b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1b_24) {flag = "af"} : (i64) -> ()
      %bb1b_32 = "braid.zext"(%bb1b_16) {bits = 8 : i64} : (i64) -> i64
      %bb1b_33 = "braid.popcnt"(%bb1b_32) : (i64) -> i64
      %bb1b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1b_35 = "braid.and"(%bb1b_33, %bb1b_34) : (i64, i64) -> i64
      %bb1b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b_37 = "braid.eq"(%bb1b_35, %bb1b_36) : (i64, i64) -> i64
      "braid.setf"(%bb1b_37) {flag = "pf"} : (i64) -> ()
      %bb1b_38 = "braid.eq"(%bb1b_16, %bb1b_36) : (i64, i64) -> i64
      "braid.setf"(%bb1b_38) {flag = "zf"} : (i64) -> ()
      %bb1b_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1b_40 = "braid.and"(%bb1b_16, %bb1b_39) : (i64, i64) -> i64
      "braid.setf"(%bb1b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1b_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb1e] : () -> ()
    ^bb1e:  // 0x40103e
      %bb1e_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb1e_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1e_16 = "braid.sub"(%bb1e_0, %bb1e_8) : (i64, i64) -> i64
      %bb1e_18 = "braid.ult"(%bb1e_0, %bb1e_8) : (i64, i64) -> i64
      "braid.setf"(%bb1e_18) {flag = "cf"} : (i64) -> ()
      %bb1e_19 = "braid.xor"(%bb1e_0, %bb1e_8) : (i64, i64) -> i64
      %bb1e_20 = "braid.xor"(%bb1e_0, %bb1e_16) : (i64, i64) -> i64
      %bb1e_21 = "braid.and"(%bb1e_19, %bb1e_20) : (i64, i64) -> i64
      %bb1e_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1e_23 = "braid.and"(%bb1e_21, %bb1e_22) : (i64, i64) -> i64
      "braid.setf"(%bb1e_23) {flag = "of"} : (i64) -> ()
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
      %bb1e_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1e_40 = "braid.and"(%bb1e_16, %bb1e_39) : (i64, i64) -> i64
      "braid.setf"(%bb1e_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb21] : () -> ()
    ^bb21:  // 0x401041
      %bb21_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb21_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb21_0 = "braid.eq"(%bb21_1, %bb21_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb21_0)[^bb10, ^bb23] : (i64) -> ()
    ^bb23:  // 0x401043
      %bb23_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb23_1 = "braid.load"(%bb23_0) {bytes = 8 : i64} : (i64) -> i64
      %bb23_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb23_3 = "braid.add"(%bb23_0, %bb23_2) : (i64, i64) -> i64
      "braid.set"(%bb23_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb23_1) : (i64) -> ()
    ^bb24:  // 0x401044
      %bb24_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb24_0 = "braid.zext"(%bb24_1) {bits = 32 : i64} : (i64) -> i64
      %bb24_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb24_8 = "braid.zext"(%bb24_9) {bits = 32 : i64} : (i64) -> i64
      %bb24_16 = "braid.xor"(%bb24_0, %bb24_8) : (i64, i64) -> i64
      %bb24_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb24_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb24_17) {flag = "of"} : (i64) -> ()
      %bb24_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb24_24) {flag = "af"} : (i64) -> ()
      %bb24_32 = "braid.zext"(%bb24_16) {bits = 8 : i64} : (i64) -> i64
      %bb24_33 = "braid.popcnt"(%bb24_32) : (i64) -> i64
      %bb24_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb24_35 = "braid.and"(%bb24_33, %bb24_34) : (i64, i64) -> i64
      %bb24_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24_37 = "braid.eq"(%bb24_35, %bb24_36) : (i64, i64) -> i64
      "braid.setf"(%bb24_37) {flag = "pf"} : (i64) -> ()
      %bb24_38 = "braid.eq"(%bb24_16, %bb24_36) : (i64, i64) -> i64
      "braid.setf"(%bb24_38) {flag = "zf"} : (i64) -> ()
      %bb24_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb24_40 = "braid.and"(%bb24_16, %bb24_39) : (i64, i64) -> i64
      "braid.setf"(%bb24_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb24_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb26] : () -> ()
    ^bb26:  // 0x401046
      %bb26_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb26_1 = "braid.load"(%bb26_0) {bytes = 8 : i64} : (i64) -> i64
      %bb26_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb26_3 = "braid.add"(%bb26_0, %bb26_2) : (i64, i64) -> i64
      "braid.set"(%bb26_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb26_1) : (i64) -> ()
  }) {sym_name = "equal_bytes", entry = 4198432 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
