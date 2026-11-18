"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_2 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb0_3 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb0_1 = "braid.add"(%bb0_2, %bb0_3) : (i64, i64) -> i64
      %bb0_0 = "braid.load"(%bb0_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb0_0) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x401004
      %bb4_2 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb4_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb4_1 = "braid.add"(%bb4_2, %bb4_3) : (i64, i64) -> i64
      %bb4_0 = "braid.load"(%bb4_1) {bytes = 1 : i64} : (i64) -> i64
      %bb4_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4_16 = "braid.and"(%bb4_0, %bb4_8) : (i64, i64) -> i64
      %bb4_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb4_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb4_17) {flag = "of"} : (i64) -> ()
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
      %bb4_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb4_40 = "braid.and"(%bb4_16, %bb4_39) : (i64, i64) -> i64
      "braid.setf"(%bb4_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x401008
      %bb8_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb8_0)[^bb17, ^bba] : (i64) -> ()
    ^bba:  // 0x40100a
      %bba_0 = "braid.const"() {value = 4305610400 : i64} : () -> i64
      "braid.set"(%bba_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x401014
      %bb14_0 = "braid.get"() {reg = "r10"} : () -> i64
      "braid_cf.br_ind"(%bb14_0) : (i64) -> ()
    ^bb17:  // 0x401017
      %bb17_0 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb17_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb17_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb17_10 = "braid.sub"(%bb17_8, %bb17_9) : (i64, i64) -> i64
      "braid.set"(%bb17_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb17_10, %bb17_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x401018
      %bb18_0 = "braid.get"() {reg = "rsp"} : () -> i64
      "braid.set"(%bb18_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb1b] : () -> ()
    ^bb1b:  // 0x40101b
      %bb1b_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1b_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1b_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1b_10 = "braid.sub"(%bb1b_8, %bb1b_9) : (i64, i64) -> i64
      "braid.set"(%bb1b_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb1b_10, %bb1b_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x40101c
      %bb1c_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb1c_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1c_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c_10 = "braid.sub"(%bb1c_8, %bb1c_9) : (i64, i64) -> i64
      "braid.set"(%bb1c_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb1c_10, %bb1c_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1d] : () -> ()
    ^bb1d:  // 0x40101d
      %bb1d_0 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1d_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1d_16 = "braid.sub"(%bb1d_8, %bb1d_0) : (i64, i64) -> i64
      %bb1d_18 = "braid.ult"(%bb1d_8, %bb1d_0) : (i64, i64) -> i64
      "braid.setf"(%bb1d_18) {flag = "cf"} : (i64) -> ()
      %bb1d_19 = "braid.xor"(%bb1d_8, %bb1d_0) : (i64, i64) -> i64
      %bb1d_20 = "braid.xor"(%bb1d_8, %bb1d_16) : (i64, i64) -> i64
      %bb1d_21 = "braid.and"(%bb1d_19, %bb1d_20) : (i64, i64) -> i64
      %bb1d_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1d_23 = "braid.and"(%bb1d_21, %bb1d_22) : (i64, i64) -> i64
      "braid.setf"(%bb1d_23) {flag = "of"} : (i64) -> ()
      %bb1d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1d_24) {flag = "af"} : (i64) -> ()
      %bb1d_32 = "braid.zext"(%bb1d_16) {bits = 8 : i64} : (i64) -> i64
      %bb1d_33 = "braid.popcnt"(%bb1d_32) : (i64) -> i64
      %bb1d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1d_35 = "braid.and"(%bb1d_33, %bb1d_34) : (i64, i64) -> i64
      %bb1d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d_37 = "braid.eq"(%bb1d_35, %bb1d_36) : (i64, i64) -> i64
      "braid.setf"(%bb1d_37) {flag = "pf"} : (i64) -> ()
      %bb1d_38 = "braid.eq"(%bb1d_16, %bb1d_36) : (i64, i64) -> i64
      "braid.setf"(%bb1d_38) {flag = "zf"} : (i64) -> ()
      %bb1d_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1d_40 = "braid.and"(%bb1d_16, %bb1d_39) : (i64, i64) -> i64
      "braid.setf"(%bb1d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1d_16) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br"()[^bb21] : () -> ()
    ^bb21:  // 0x401021
      %bb21_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb21_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb21_10 = "braid.const"() {value = -24 : i64} : () -> i64
      %bb21_8 = "braid.add"(%bb21_9, %bb21_10) : (i64, i64) -> i64
      "braid.store"(%bb21_8, %bb21_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb25] : () -> ()
    ^bb25:  // 0x401025
      %bb25_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb25_10 = "braid.get"() {reg = "r13"} : () -> i64
      %bb25_11 = "braid.const"() {value = -32 : i64} : () -> i64
      %bb25_9 = "braid.add"(%bb25_10, %bb25_11) : (i64, i64) -> i64
      %bb25_8 = "braid.load"(%bb25_9) {bytes = 8 : i64} : (i64) -> i64
      %bb25_16 = "braid.sub"(%bb25_0, %bb25_8) : (i64, i64) -> i64
      %bb25_18 = "braid.ult"(%bb25_0, %bb25_8) : (i64, i64) -> i64
      "braid.setf"(%bb25_18) {flag = "cf"} : (i64) -> ()
      %bb25_19 = "braid.xor"(%bb25_0, %bb25_8) : (i64, i64) -> i64
      %bb25_20 = "braid.xor"(%bb25_0, %bb25_16) : (i64, i64) -> i64
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
      "braid_cf.br"()[^bb29] : () -> ()
    ^bb29:  // 0x401029
      %bb29_1 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb29_2 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb29_0 = "braid.or"(%bb29_1, %bb29_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb29_0)[^bb84, ^bb2f] : (i64) -> ()
    ^bb2f:  // 0x40102f
      %bb2f_2 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb2f_3 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb2f_1 = "braid.add"(%bb2f_2, %bb2f_3) : (i64, i64) -> i64
      %bb2f_0 = "braid.load"(%bb2f_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb2f_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb33] : () -> ()
    ^bb33:  // 0x401033
      %bb33_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb33_0 = "braid.zext"(%bb33_1) {bits = 8 : i64} : (i64) -> i64
      %bb33_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb33_16 = "braid.and"(%bb33_0, %bb33_8) : (i64, i64) -> i64
      %bb33_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb33_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb33_17) {flag = "of"} : (i64) -> ()
      %bb33_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb33_24) {flag = "af"} : (i64) -> ()
      %bb33_32 = "braid.zext"(%bb33_16) {bits = 8 : i64} : (i64) -> i64
      %bb33_33 = "braid.popcnt"(%bb33_32) : (i64) -> i64
      %bb33_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb33_35 = "braid.and"(%bb33_33, %bb33_34) : (i64, i64) -> i64
      %bb33_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb33_37 = "braid.eq"(%bb33_35, %bb33_36) : (i64, i64) -> i64
      "braid.setf"(%bb33_37) {flag = "pf"} : (i64) -> ()
      %bb33_38 = "braid.eq"(%bb33_16, %bb33_36) : (i64, i64) -> i64
      "braid.setf"(%bb33_38) {flag = "zf"} : (i64) -> ()
      %bb33_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb33_40 = "braid.and"(%bb33_16, %bb33_39) : (i64, i64) -> i64
      "braid.setf"(%bb33_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb36] : () -> ()
    ^bb36:  // 0x401036
      %bb36_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb36_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb36_0 = "braid.eq"(%bb36_1, %bb36_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb36_0)[^bbbb, ^bb3c] : (i64) -> ()
    ^bb3c:  // 0x40103c
      %bb3c_2 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb3c_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb3c_1 = "braid.add"(%bb3c_2, %bb3c_3) : (i64, i64) -> i64
      %bb3c_0 = "braid.load"(%bb3c_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb3c_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x401040
      %bb40_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb40_0 = "braid.zext"(%bb40_1) {bits = 8 : i64} : (i64) -> i64
      %bb40_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb40_16 = "braid.and"(%bb40_0, %bb40_8) : (i64, i64) -> i64
      %bb40_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb40_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb40_17) {flag = "of"} : (i64) -> ()
      %bb40_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb40_24) {flag = "af"} : (i64) -> ()
      %bb40_32 = "braid.zext"(%bb40_16) {bits = 8 : i64} : (i64) -> i64
      %bb40_33 = "braid.popcnt"(%bb40_32) : (i64) -> i64
      %bb40_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb40_35 = "braid.and"(%bb40_33, %bb40_34) : (i64, i64) -> i64
      %bb40_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb40_37 = "braid.eq"(%bb40_35, %bb40_36) : (i64, i64) -> i64
      "braid.setf"(%bb40_37) {flag = "pf"} : (i64) -> ()
      %bb40_38 = "braid.eq"(%bb40_16, %bb40_36) : (i64, i64) -> i64
      "braid.setf"(%bb40_38) {flag = "zf"} : (i64) -> ()
      %bb40_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb40_40 = "braid.and"(%bb40_16, %bb40_39) : (i64, i64) -> i64
      "braid.setf"(%bb40_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb43] : () -> ()
    ^bb43:  // 0x401043
      %bb43_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb43_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb43_0 = "braid.eq"(%bb43_1, %bb43_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb43_0)[^bbc7, ^bb49] : (i64) -> ()
    ^bb49:  // 0x401049
      %bb49_0 = "braid.get"() {reg = "rcx"} : () -> i64
      "braid.set"(%bb49_0) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x40104c
      %bb4c_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb4c_8 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb4c_9 = "braid.lshr"(%bb4c_0, %bb4c_8) : (i64, i64) -> i64
      %bb4c_11 = "braid.const"() {value = 31 : i64} : () -> i64
      %bb4c_12 = "braid.lshr"(%bb4c_0, %bb4c_11) : (i64, i64) -> i64
      %bb4c_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4c_14 = "braid.and"(%bb4c_12, %bb4c_13) : (i64, i64) -> i64
      "braid.setf"(%bb4c_14) {flag = "cf"} : (i64) -> ()
      %bb4c_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb4c_17) {flag = "of"} : (i64) -> ()
      %bb4c_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb4c_24) {flag = "af"} : (i64) -> ()
      %bb4c_32 = "braid.zext"(%bb4c_9) {bits = 8 : i64} : (i64) -> i64
      %bb4c_33 = "braid.popcnt"(%bb4c_32) : (i64) -> i64
      %bb4c_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4c_35 = "braid.and"(%bb4c_33, %bb4c_34) : (i64, i64) -> i64
      %bb4c_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4c_37 = "braid.eq"(%bb4c_35, %bb4c_36) : (i64, i64) -> i64
      "braid.setf"(%bb4c_37) {flag = "pf"} : (i64) -> ()
      %bb4c_38 = "braid.eq"(%bb4c_9, %bb4c_36) : (i64, i64) -> i64
      "braid.setf"(%bb4c_38) {flag = "zf"} : (i64) -> ()
      %bb4c_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb4c_40 = "braid.and"(%bb4c_9, %bb4c_39) : (i64, i64) -> i64
      "braid.setf"(%bb4c_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb4c_9) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x401050
      %bb50_0 = "braid.get"() {reg = "rdx"} : () -> i64
      "braid.set"(%bb50_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb53] : () -> ()
    ^bb53:  // 0x401053
      %bb53_0 = "braid.get"() {reg = "r8"} : () -> i64
      %bb53_8 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb53_9 = "braid.lshr"(%bb53_0, %bb53_8) : (i64, i64) -> i64
      %bb53_11 = "braid.const"() {value = 31 : i64} : () -> i64
      %bb53_12 = "braid.lshr"(%bb53_0, %bb53_11) : (i64, i64) -> i64
      %bb53_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb53_14 = "braid.and"(%bb53_12, %bb53_13) : (i64, i64) -> i64
      "braid.setf"(%bb53_14) {flag = "cf"} : (i64) -> ()
      %bb53_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb53_17) {flag = "of"} : (i64) -> ()
      %bb53_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb53_24) {flag = "af"} : (i64) -> ()
      %bb53_32 = "braid.zext"(%bb53_9) {bits = 8 : i64} : (i64) -> i64
      %bb53_33 = "braid.popcnt"(%bb53_32) : (i64) -> i64
      %bb53_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb53_35 = "braid.and"(%bb53_33, %bb53_34) : (i64, i64) -> i64
      %bb53_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb53_37 = "braid.eq"(%bb53_35, %bb53_36) : (i64, i64) -> i64
      "braid.setf"(%bb53_37) {flag = "pf"} : (i64) -> ()
      %bb53_38 = "braid.eq"(%bb53_9, %bb53_36) : (i64, i64) -> i64
      "braid.setf"(%bb53_38) {flag = "zf"} : (i64) -> ()
      %bb53_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb53_40 = "braid.and"(%bb53_9, %bb53_39) : (i64, i64) -> i64
      "braid.setf"(%bb53_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb53_9) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb57] : () -> ()
    ^bb57:  // 0x401057
      %bb57_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb57_0 = "braid.zext"(%bb57_1) {bits = 32 : i64} : (i64) -> i64
      %bb57_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb57_8 = "braid.zext"(%bb57_9) {bits = 32 : i64} : (i64) -> i64
      %bb57_16 = "braid.add"(%bb57_0, %bb57_8) : (i64, i64) -> i64
      %bb57_17 = "braid.zext"(%bb57_16) {bits = 32 : i64} : (i64) -> i64
      %bb57_18 = "braid.ult"(%bb57_17, %bb57_0) : (i64, i64) -> i64
      "braid.setf"(%bb57_18) {flag = "cf"} : (i64) -> ()
      %bb57_19 = "braid.xor"(%bb57_0, %bb57_17) : (i64, i64) -> i64
      %bb57_20 = "braid.xor"(%bb57_8, %bb57_17) : (i64, i64) -> i64
      %bb57_21 = "braid.and"(%bb57_19, %bb57_20) : (i64, i64) -> i64
      %bb57_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb57_23 = "braid.and"(%bb57_21, %bb57_22) : (i64, i64) -> i64
      "braid.setf"(%bb57_23) {flag = "of"} : (i64) -> ()
      %bb57_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb57_24) {flag = "af"} : (i64) -> ()
      %bb57_32 = "braid.zext"(%bb57_17) {bits = 8 : i64} : (i64) -> i64
      %bb57_33 = "braid.popcnt"(%bb57_32) : (i64) -> i64
      %bb57_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb57_35 = "braid.and"(%bb57_33, %bb57_34) : (i64, i64) -> i64
      %bb57_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb57_37 = "braid.eq"(%bb57_35, %bb57_36) : (i64, i64) -> i64
      "braid.setf"(%bb57_37) {flag = "pf"} : (i64) -> ()
      %bb57_38 = "braid.eq"(%bb57_17, %bb57_36) : (i64, i64) -> i64
      "braid.setf"(%bb57_38) {flag = "zf"} : (i64) -> ()
      %bb57_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb57_40 = "braid.and"(%bb57_17, %bb57_39) : (i64, i64) -> i64
      "braid.setf"(%bb57_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb57_17) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb5a] : () -> ()
    ^bb5a:  // 0x40105a
      %bb5a_0 = "braid.getf"() {flag = "of"} : () -> i64
      "braid_cf.cond_br"(%bb5a_0)[^bbd3, ^bb60] : (i64) -> ()
    ^bb60:  // 0x401060
      %bb60_2 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb60_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb60_1 = "braid.add"(%bb60_2, %bb60_3) : (i64, i64) -> i64
      %bb60_0 = "braid.load"(%bb60_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb60_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x401064
      %bb64_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb64_0 = "braid.zext"(%bb64_1) {bits = 8 : i64} : (i64) -> i64
      %bb64_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb64_16 = "braid.and"(%bb64_0, %bb64_8) : (i64, i64) -> i64
      %bb64_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb64_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb64_17) {flag = "of"} : (i64) -> ()
      %bb64_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb64_24) {flag = "af"} : (i64) -> ()
      %bb64_32 = "braid.zext"(%bb64_16) {bits = 8 : i64} : (i64) -> i64
      %bb64_33 = "braid.popcnt"(%bb64_32) : (i64) -> i64
      %bb64_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb64_35 = "braid.and"(%bb64_33, %bb64_34) : (i64, i64) -> i64
      %bb64_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb64_37 = "braid.eq"(%bb64_35, %bb64_36) : (i64, i64) -> i64
      "braid.setf"(%bb64_37) {flag = "pf"} : (i64) -> ()
      %bb64_38 = "braid.eq"(%bb64_16, %bb64_36) : (i64, i64) -> i64
      "braid.setf"(%bb64_38) {flag = "zf"} : (i64) -> ()
      %bb64_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb64_40 = "braid.and"(%bb64_16, %bb64_39) : (i64, i64) -> i64
      "braid.setf"(%bb64_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x401068
      %bb68_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb68_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb68_0 = "braid.eq"(%bb68_1, %bb68_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb68_0)[^bbdf, ^bb6e] : (i64) -> ()
    ^bb6e:  // 0x40106e
      %bb6e_0 = "braid.get"() {reg = "r8"} : () -> i64
      %bb6e_7 = "braid.sext"(%bb6e_0) {bits = 64 : i64} : (i64) -> i64
      %bb6e_8 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb6e_9 = "braid.ashr"(%bb6e_7, %bb6e_8) : (i64, i64) -> i64
      %bb6e_11 = "braid.const"() {value = 31 : i64} : () -> i64
      %bb6e_12 = "braid.ashr"(%bb6e_7, %bb6e_11) : (i64, i64) -> i64
      %bb6e_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6e_14 = "braid.and"(%bb6e_12, %bb6e_13) : (i64, i64) -> i64
      "braid.setf"(%bb6e_14) {flag = "cf"} : (i64) -> ()
      %bb6e_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb6e_17) {flag = "of"} : (i64) -> ()
      %bb6e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb6e_24) {flag = "af"} : (i64) -> ()
      %bb6e_32 = "braid.zext"(%bb6e_9) {bits = 8 : i64} : (i64) -> i64
      %bb6e_33 = "braid.popcnt"(%bb6e_32) : (i64) -> i64
      %bb6e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6e_35 = "braid.and"(%bb6e_33, %bb6e_34) : (i64, i64) -> i64
      %bb6e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6e_37 = "braid.eq"(%bb6e_35, %bb6e_36) : (i64, i64) -> i64
      "braid.setf"(%bb6e_37) {flag = "pf"} : (i64) -> ()
      %bb6e_38 = "braid.eq"(%bb6e_9, %bb6e_36) : (i64, i64) -> i64
      "braid.setf"(%bb6e_38) {flag = "zf"} : (i64) -> ()
      %bb6e_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb6e_40 = "braid.and"(%bb6e_9, %bb6e_39) : (i64, i64) -> i64
      "braid.setf"(%bb6e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb6e_9) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb72] : () -> ()
    ^bb72:  // 0x401072
      %bb72_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb72_2 = "braid.get"() {reg = "r8"} : () -> i64
      %bb72_3 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb72_4 = "braid.mul"(%bb72_2, %bb72_3) : (i64, i64) -> i64
      %bb72_5 = "braid.add"(%bb72_1, %bb72_4) : (i64, i64) -> i64
      %bb72_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb72_0 = "braid.add"(%bb72_5, %bb72_6) : (i64, i64) -> i64
      %bb72_8 = "braid.zext"(%bb72_0) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb72_8) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb76] : () -> ()
    ^bb76:  // 0x401076
      %bb76_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb76_8 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb76_9 = "braid.shl"(%bb76_0, %bb76_8) : (i64, i64) -> i64
      %bb76_11 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb76_12 = "braid.lshr"(%bb76_0, %bb76_11) : (i64, i64) -> i64
      %bb76_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb76_14 = "braid.and"(%bb76_12, %bb76_13) : (i64, i64) -> i64
      "braid.setf"(%bb76_14) {flag = "cf"} : (i64) -> ()
      %bb76_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb76_17) {flag = "of"} : (i64) -> ()
      %bb76_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb76_24) {flag = "af"} : (i64) -> ()
      %bb76_32 = "braid.zext"(%bb76_9) {bits = 8 : i64} : (i64) -> i64
      %bb76_33 = "braid.popcnt"(%bb76_32) : (i64) -> i64
      %bb76_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb76_35 = "braid.and"(%bb76_33, %bb76_34) : (i64, i64) -> i64
      %bb76_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb76_37 = "braid.eq"(%bb76_35, %bb76_36) : (i64, i64) -> i64
      "braid.setf"(%bb76_37) {flag = "pf"} : (i64) -> ()
      %bb76_38 = "braid.eq"(%bb76_9, %bb76_36) : (i64, i64) -> i64
      "braid.setf"(%bb76_38) {flag = "zf"} : (i64) -> ()
      %bb76_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb76_40 = "braid.and"(%bb76_9, %bb76_39) : (i64, i64) -> i64
      "braid.setf"(%bb76_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb76_9) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb7a] : () -> ()
    ^bb7a:  // 0x40107a
      %bb7a_0 = "braid.get"() {reg = "rdx"} : () -> i64
      "braid.set"(%bb7a_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb7d] : () -> ()
    ^bb7d:  // 0x40107d
      %bb7d_0 = "braid.get"() {reg = "rbp"} : () -> i64
      "braid.set"(%bb7d_0) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x401080
      %bb80_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb80_1 = "braid.load"(%bb80_0) {bytes = 8 : i64} : (i64) -> i64
      %bb80_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb80_3 = "braid.add"(%bb80_0, %bb80_2) : (i64, i64) -> i64
      "braid.set"(%bb80_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb80_1) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^ext401081] : () -> ()
    ^bb84:  // 0x401084
      %bb84_0 = "braid.const"() {value = 240518168576 : i64} : () -> i64
      "braid.set"(%bb84_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb8e] : () -> ()
    ^bb8e:  // 0x40108e
      %bb8e_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb8e_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb8e_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8e_10 = "braid.sub"(%bb8e_8, %bb8e_9) : (i64, i64) -> i64
      "braid.set"(%bb8e_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb8e_10, %bb8e_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb8f] : () -> ()
    ^bb8f:  // 0x40108f
      %bb8f_0 = "braid.const"() {value = 4302332736 : i64} : () -> i64
      "braid.set"(%bb8f_0) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb99] : () -> ()
    ^bb99:  // 0x401099
      %bb99_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bb99_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb9e] : () -> ()
    ^bb9e:  // 0x40109e
      %bb9e_0 = "braid.const"() {value = 21790333600033 : i64} : () -> i64
      "braid.set"(%bb9e_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x4010a8
      %bba8_0 = "braid.const"() {value = 4306038848 : i64} : () -> i64
      "braid.set"(%bba8_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bbb2] : () -> ()
    ^bbb2:  // 0x4010b2
      %bbb2_0 = "braid.get"() {reg = "r10"} : () -> i64
      %bbb2_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbb2_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbb2_10 = "braid.sub"(%bbb2_8, %bbb2_9) : (i64, i64) -> i64
      "braid.set"(%bbb2_10) {reg = "rsp"} : (i64) -> ()
      %bbb2_11 = "braid.const"() {value = 4198581 : i64} : () -> i64
      "braid.store"(%bbb2_10, %bbb2_11) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br_ind"(%bbb2_0) : (i64) -> ()
    ^bbb5:  // 0x4010b5
      "braid_cf.br"()[^bb2f] : () -> ()
    ^bbba:  // 0x4010ba
      "braid_cf.br"()[^bbbb] : () -> ()
    ^bbbb:  // 0x4010bb
      %bbbb_0 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bbbb_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bbc2] : () -> ()
    ^bbc2:  // 0x4010c2
      %bbc2_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbc2_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbc2_10 = "braid.sub"(%bbc2_8, %bbc2_9) : (i64, i64) -> i64
      "braid.set"(%bbc2_10) {reg = "rsp"} : (i64) -> ()
      %bbc2_11 = "braid.const"() {value = 4198599 : i64} : () -> i64
      "braid.store"(%bbc2_10, %bbc2_11) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^ext43fac0] : () -> ()
    ^bbc7:  // 0x4010c7
      %bbc7_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bbc7_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bbce] : () -> ()
    ^bbce:  // 0x4010ce
      %bbce_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbce_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbce_10 = "braid.sub"(%bbce_8, %bbce_9) : (i64, i64) -> i64
      "braid.set"(%bbce_10) {reg = "rsp"} : (i64) -> ()
      %bbce_11 = "braid.const"() {value = 4198611 : i64} : () -> i64
      "braid.store"(%bbce_10, %bbce_11) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^ext43fac0] : () -> ()
    ^bbd3:  // 0x4010d3
      %bbd3_0 = "braid.const"() {value = 2 : i64} : () -> i64
      "braid.set"(%bbd3_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bbda] : () -> ()
    ^bbda:  // 0x4010da
      %bbda_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbda_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbda_10 = "braid.sub"(%bbda_8, %bbda_9) : (i64, i64) -> i64
      "braid.set"(%bbda_10) {reg = "rsp"} : (i64) -> ()
      %bbda_11 = "braid.const"() {value = 4198623 : i64} : () -> i64
      "braid.store"(%bbda_10, %bbda_11) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^ext43fac0] : () -> ()
    ^bbdf:  // 0x4010df
      %bbdf_0 = "braid.const"() {value = 3 : i64} : () -> i64
      "braid.set"(%bbdf_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bbe6] : () -> ()
    ^bbe6:  // 0x4010e6
      %bbe6_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbe6_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbe6_10 = "braid.sub"(%bbe6_8, %bbe6_9) : (i64, i64) -> i64
      "braid.set"(%bbe6_10) {reg = "rsp"} : (i64) -> ()
      %bbe6_11 = "braid.const"() {value = 4198635 : i64} : () -> i64
      "braid.store"(%bbe6_10, %bbe6_11) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^ext43fac0] : () -> ()
    ^bbeb:  // 0x4010eb
      %bbeb_0 = "braid.const"() {value = 4 : i64} : () -> i64
      "braid.set"(%bbeb_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bbf2] : () -> ()
    ^bbf2:  // 0x4010f2
      %bbf2_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbf2_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbf2_10 = "braid.sub"(%bbf2_8, %bbf2_9) : (i64, i64) -> i64
      "braid.set"(%bbf2_10) {reg = "rsp"} : (i64) -> ()
      %bbf2_11 = "braid.const"() {value = 4198647 : i64} : () -> i64
      "braid.store"(%bbf2_10, %bbf2_11) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^ext47fac0] : () -> ()
    ^bbf7:  // 0x4010f7
      "braid_cf.br"()[^ext4010f8] : () -> ()
    ^ext401081:
      "braid_cf.tail"() {target = 4198529 : i64} : () -> ()
    ^ext43fac0:
      "braid_cf.tail"() {target = 4455104 : i64} : () -> ()
    ^ext47fac0:
      "braid_cf.tail"() {target = 4717248 : i64} : () -> ()
    ^ext4010f8:
      "braid_cf.tail"() {target = 4198648 : i64} : () -> ()
  }) {sym_name = "js_add3", entry = 4198400 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x4010f8
      %bb0_2 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb0_3 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb0_1 = "braid.add"(%bb0_2, %bb0_3) : (i64, i64) -> i64
      %bb0_0 = "braid.load"(%bb0_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb0_0) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x4010fc
      %bb4_2 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb4_3 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb4_1 = "braid.add"(%bb4_2, %bb4_3) : (i64, i64) -> i64
      %bb4_0 = "braid.load"(%bb4_1) {bytes = 1 : i64} : (i64) -> i64
      %bb4_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4_16 = "braid.and"(%bb4_0, %bb4_8) : (i64, i64) -> i64
      %bb4_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb4_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb4_17) {flag = "of"} : (i64) -> ()
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
      %bb4_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb4_40 = "braid.and"(%bb4_16, %bb4_39) : (i64, i64) -> i64
      "braid.setf"(%bb4_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x401100
      %bb8_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb8_0)[^bb17, ^bba] : (i64) -> ()
    ^bba:  // 0x401102
      %bba_0 = "braid.const"() {value = 4305610400 : i64} : () -> i64
      "braid.set"(%bba_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x40110c
      %bb14_0 = "braid.get"() {reg = "r10"} : () -> i64
      "braid_cf.br_ind"(%bb14_0) : (i64) -> ()
    ^bb17:  // 0x40110f
      %bb17_0 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb17_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb17_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb17_10 = "braid.sub"(%bb17_8, %bb17_9) : (i64, i64) -> i64
      "braid.set"(%bb17_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb17_10, %bb17_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x401110
      %bb18_0 = "braid.get"() {reg = "rsp"} : () -> i64
      "braid.set"(%bb18_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb1b] : () -> ()
    ^bb1b:  // 0x401113
      %bb1b_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1b_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1b_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1b_10 = "braid.sub"(%bb1b_8, %bb1b_9) : (i64, i64) -> i64
      "braid.set"(%bb1b_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb1b_10, %bb1b_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x401114
      %bb1c_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb1c_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1c_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c_10 = "braid.sub"(%bb1c_8, %bb1c_9) : (i64, i64) -> i64
      "braid.set"(%bb1c_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb1c_10, %bb1c_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1d] : () -> ()
    ^bb1d:  // 0x401115
      %bb1d_0 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1d_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1d_16 = "braid.sub"(%bb1d_8, %bb1d_0) : (i64, i64) -> i64
      %bb1d_18 = "braid.ult"(%bb1d_8, %bb1d_0) : (i64, i64) -> i64
      "braid.setf"(%bb1d_18) {flag = "cf"} : (i64) -> ()
      %bb1d_19 = "braid.xor"(%bb1d_8, %bb1d_0) : (i64, i64) -> i64
      %bb1d_20 = "braid.xor"(%bb1d_8, %bb1d_16) : (i64, i64) -> i64
      %bb1d_21 = "braid.and"(%bb1d_19, %bb1d_20) : (i64, i64) -> i64
      %bb1d_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1d_23 = "braid.and"(%bb1d_21, %bb1d_22) : (i64, i64) -> i64
      "braid.setf"(%bb1d_23) {flag = "of"} : (i64) -> ()
      %bb1d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1d_24) {flag = "af"} : (i64) -> ()
      %bb1d_32 = "braid.zext"(%bb1d_16) {bits = 8 : i64} : (i64) -> i64
      %bb1d_33 = "braid.popcnt"(%bb1d_32) : (i64) -> i64
      %bb1d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1d_35 = "braid.and"(%bb1d_33, %bb1d_34) : (i64, i64) -> i64
      %bb1d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d_37 = "braid.eq"(%bb1d_35, %bb1d_36) : (i64, i64) -> i64
      "braid.setf"(%bb1d_37) {flag = "pf"} : (i64) -> ()
      %bb1d_38 = "braid.eq"(%bb1d_16, %bb1d_36) : (i64, i64) -> i64
      "braid.setf"(%bb1d_38) {flag = "zf"} : (i64) -> ()
      %bb1d_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1d_40 = "braid.and"(%bb1d_16, %bb1d_39) : (i64, i64) -> i64
      "braid.setf"(%bb1d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1d_16) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br"()[^bb21] : () -> ()
    ^bb21:  // 0x401119
      %bb21_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb21_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb21_10 = "braid.const"() {value = -24 : i64} : () -> i64
      %bb21_8 = "braid.add"(%bb21_9, %bb21_10) : (i64, i64) -> i64
      "braid.store"(%bb21_8, %bb21_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb25] : () -> ()
    ^bb25:  // 0x40111d
      %bb25_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb25_10 = "braid.get"() {reg = "r13"} : () -> i64
      %bb25_11 = "braid.const"() {value = -32 : i64} : () -> i64
      %bb25_9 = "braid.add"(%bb25_10, %bb25_11) : (i64, i64) -> i64
      %bb25_8 = "braid.load"(%bb25_9) {bytes = 8 : i64} : (i64) -> i64
      %bb25_16 = "braid.sub"(%bb25_0, %bb25_8) : (i64, i64) -> i64
      %bb25_18 = "braid.ult"(%bb25_0, %bb25_8) : (i64, i64) -> i64
      "braid.setf"(%bb25_18) {flag = "cf"} : (i64) -> ()
      %bb25_19 = "braid.xor"(%bb25_0, %bb25_8) : (i64, i64) -> i64
      %bb25_20 = "braid.xor"(%bb25_0, %bb25_16) : (i64, i64) -> i64
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
      "braid_cf.br"()[^bb29] : () -> ()
    ^bb29:  // 0x401121
      %bb29_1 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb29_2 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb29_0 = "braid.or"(%bb29_1, %bb29_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb29_0)[^bb5d, ^bb2f] : (i64) -> ()
    ^bb2f:  // 0x401127
      %bb2f_2 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb2f_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb2f_1 = "braid.add"(%bb2f_2, %bb2f_3) : (i64, i64) -> i64
      %bb2f_0 = "braid.load"(%bb2f_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb2f_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb33] : () -> ()
    ^bb33:  // 0x40112b
      %bb33_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb33_0 = "braid.zext"(%bb33_1) {bits = 8 : i64} : (i64) -> i64
      %bb33_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb33_16 = "braid.and"(%bb33_0, %bb33_8) : (i64, i64) -> i64
      %bb33_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb33_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb33_17) {flag = "of"} : (i64) -> ()
      %bb33_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb33_24) {flag = "af"} : (i64) -> ()
      %bb33_32 = "braid.zext"(%bb33_16) {bits = 8 : i64} : (i64) -> i64
      %bb33_33 = "braid.popcnt"(%bb33_32) : (i64) -> i64
      %bb33_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb33_35 = "braid.and"(%bb33_33, %bb33_34) : (i64, i64) -> i64
      %bb33_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb33_37 = "braid.eq"(%bb33_35, %bb33_36) : (i64, i64) -> i64
      "braid.setf"(%bb33_37) {flag = "pf"} : (i64) -> ()
      %bb33_38 = "braid.eq"(%bb33_16, %bb33_36) : (i64, i64) -> i64
      "braid.setf"(%bb33_38) {flag = "zf"} : (i64) -> ()
      %bb33_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb33_40 = "braid.and"(%bb33_16, %bb33_39) : (i64, i64) -> i64
      "braid.setf"(%bb33_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb35] : () -> ()
    ^bb35:  // 0x40112d
      %bb35_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb35_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb35_0 = "braid.eq"(%bb35_1, %bb35_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb35_0)[^bb91, ^bb3b] : (i64) -> ()
    ^bb3b:  // 0x401133
      %bb3b_2 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb3b_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb3b_1 = "braid.add"(%bb3b_2, %bb3b_3) : (i64, i64) -> i64
      %bb3b_0 = "braid.load"(%bb3b_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb3b_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb3f] : () -> ()
    ^bb3f:  // 0x401137
      %bb3f_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb3f_0 = "braid.zext"(%bb3f_1) {bits = 8 : i64} : (i64) -> i64
      %bb3f_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3f_16 = "braid.and"(%bb3f_0, %bb3f_8) : (i64, i64) -> i64
      %bb3f_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb3f_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb3f_17) {flag = "of"} : (i64) -> ()
      %bb3f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb3f_24) {flag = "af"} : (i64) -> ()
      %bb3f_32 = "braid.zext"(%bb3f_16) {bits = 8 : i64} : (i64) -> i64
      %bb3f_33 = "braid.popcnt"(%bb3f_32) : (i64) -> i64
      %bb3f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3f_35 = "braid.and"(%bb3f_33, %bb3f_34) : (i64, i64) -> i64
      %bb3f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3f_37 = "braid.eq"(%bb3f_35, %bb3f_36) : (i64, i64) -> i64
      "braid.setf"(%bb3f_37) {flag = "pf"} : (i64) -> ()
      %bb3f_38 = "braid.eq"(%bb3f_16, %bb3f_36) : (i64, i64) -> i64
      "braid.setf"(%bb3f_38) {flag = "zf"} : (i64) -> ()
      %bb3f_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb3f_40 = "braid.and"(%bb3f_16, %bb3f_39) : (i64, i64) -> i64
      "braid.setf"(%bb3f_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb42] : () -> ()
    ^bb42:  // 0x40113a
      %bb42_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb42_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb42_0 = "braid.eq"(%bb42_1, %bb42_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb42_0)[^bb9d, ^bb48] : (i64) -> ()
    ^bb48:  // 0x401140
      %bb48_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb48_8 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb48_16 = "braid.sub"(%bb48_0, %bb48_8) : (i64, i64) -> i64
      %bb48_18 = "braid.ult"(%bb48_0, %bb48_8) : (i64, i64) -> i64
      "braid.setf"(%bb48_18) {flag = "cf"} : (i64) -> ()
      %bb48_19 = "braid.xor"(%bb48_0, %bb48_8) : (i64, i64) -> i64
      %bb48_20 = "braid.xor"(%bb48_0, %bb48_16) : (i64, i64) -> i64
      %bb48_21 = "braid.and"(%bb48_19, %bb48_20) : (i64, i64) -> i64
      %bb48_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb48_23 = "braid.and"(%bb48_21, %bb48_22) : (i64, i64) -> i64
      "braid.setf"(%bb48_23) {flag = "of"} : (i64) -> ()
      %bb48_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb48_24) {flag = "af"} : (i64) -> ()
      %bb48_32 = "braid.zext"(%bb48_16) {bits = 8 : i64} : (i64) -> i64
      %bb48_33 = "braid.popcnt"(%bb48_32) : (i64) -> i64
      %bb48_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb48_35 = "braid.and"(%bb48_33, %bb48_34) : (i64, i64) -> i64
      %bb48_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb48_37 = "braid.eq"(%bb48_35, %bb48_36) : (i64, i64) -> i64
      "braid.setf"(%bb48_37) {flag = "pf"} : (i64) -> ()
      %bb48_38 = "braid.eq"(%bb48_16, %bb48_36) : (i64, i64) -> i64
      "braid.setf"(%bb48_38) {flag = "zf"} : (i64) -> ()
      %bb48_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb48_40 = "braid.and"(%bb48_16, %bb48_39) : (i64, i64) -> i64
      "braid.setf"(%bb48_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb4b] : () -> ()
    ^bb4b:  // 0x401143
      %bb4b_1 = "braid.getf"() {flag = "sf"} : () -> i64
      %bb4b_2 = "braid.getf"() {flag = "of"} : () -> i64
      %bb4b_0 = "braid.xor"(%bb4b_1, %bb4b_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb4b_0)[^bb58, ^bb51] : (i64) -> ()
    ^bb51:  // 0x401149
      %bb51_0 = "braid.get"() {reg = "rbp"} : () -> i64
      "braid.set"(%bb51_0) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x40114c
      %bb54_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb54_1 = "braid.load"(%bb54_0) {bytes = 8 : i64} : (i64) -> i64
      %bb54_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb54_3 = "braid.add"(%bb54_0, %bb54_2) : (i64, i64) -> i64
      "braid.set"(%bb54_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb54_1) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^ext40114d] : () -> ()
    ^bb58:  // 0x401150
      %bb58_0 = "braid.get"() {reg = "rdx"} : () -> i64
      "braid.set"(%bb58_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb5b] : () -> ()
    ^bb5b:  // 0x401153
      "braid_cf.br"()[^bb51] : () -> ()
    ^bb5d:  // 0x401155
      %bb5d_0 = "braid.const"() {value = 171798691840 : i64} : () -> i64
      "braid.set"(%bb5d_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb67] : () -> ()
    ^bb67:  // 0x40115f
      %bb67_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb67_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb67_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb67_10 = "braid.sub"(%bb67_8, %bb67_9) : (i64, i64) -> i64
      "braid.set"(%bb67_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb67_10, %bb67_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x401160
      %bb68_0 = "braid.const"() {value = 4302332736 : i64} : () -> i64
      "braid.set"(%bb68_0) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb72] : () -> ()
    ^bb72:  // 0x40116a
      %bb72_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bb72_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb77] : () -> ()
    ^bb77:  // 0x40116f
      %bb77_0 = "braid.const"() {value = 51815395623201 : i64} : () -> i64
      "braid.set"(%bb77_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb81] : () -> ()
    ^bb81:  // 0x401179
      %bb81_0 = "braid.const"() {value = 4306038848 : i64} : () -> i64
      "braid.set"(%bb81_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb8b] : () -> ()
    ^bb8b:  // 0x401183
      %bb8b_0 = "braid.get"() {reg = "r10"} : () -> i64
      %bb8b_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb8b_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8b_10 = "braid.sub"(%bb8b_8, %bb8b_9) : (i64, i64) -> i64
      "braid.set"(%bb8b_10) {reg = "rsp"} : (i64) -> ()
      %bb8b_11 = "braid.const"() {value = 4198790 : i64} : () -> i64
      "braid.store"(%bb8b_10, %bb8b_11) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br_ind"(%bb8b_0) : (i64) -> ()
    ^bb8e:  // 0x401186
      "braid_cf.br"()[^bb2f] : () -> ()
    ^bb90:  // 0x401188
      "braid_cf.br"()[^bb91] : () -> ()
    ^bb91:  // 0x401189
      %bb91_0 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb91_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x401190
      %bb98_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb98_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb98_10 = "braid.sub"(%bb98_8, %bb98_9) : (i64, i64) -> i64
      "braid.set"(%bb98_10) {reg = "rsp"} : (i64) -> ()
      %bb98_11 = "braid.const"() {value = 4198805 : i64} : () -> i64
      "braid.store"(%bb98_10, %bb98_11) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^ext43fa38] : () -> ()
    ^bb9d:  // 0x401195
      %bb9d_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bb9d_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bba4] : () -> ()
    ^bba4:  // 0x40119c
      %bba4_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba4_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bba4_10 = "braid.sub"(%bba4_8, %bba4_9) : (i64, i64) -> i64
      "braid.set"(%bba4_10) {reg = "rsp"} : (i64) -> ()
      %bba4_11 = "braid.const"() {value = 4198817 : i64} : () -> i64
      "braid.store"(%bba4_10, %bba4_11) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^ext43fa38] : () -> ()
    ^bba9:  // 0x4011a1
      %bba9_0 = "braid.const"() {value = 2 : i64} : () -> i64
      "braid.set"(%bba9_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x4011a8
      %bbb0_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbb0_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbb0_10 = "braid.sub"(%bbb0_8, %bbb0_9) : (i64, i64) -> i64
      "braid.set"(%bbb0_10) {reg = "rsp"} : (i64) -> ()
      %bbb0_11 = "braid.const"() {value = 4198829 : i64} : () -> i64
      "braid.store"(%bbb0_10, %bbb0_11) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^ext47fa38] : () -> ()
    ^bbb5:  // 0x4011ad
      "braid_cf.br"()[^ext4011b0] : () -> ()
    ^ext40114d:
      "braid_cf.tail"() {target = 4198733 : i64} : () -> ()
    ^ext43fa38:
      "braid_cf.tail"() {target = 4454968 : i64} : () -> ()
    ^ext47fa38:
      "braid_cf.tail"() {target = 4717112 : i64} : () -> ()
    ^ext4011b0:
      "braid_cf.tail"() {target = 4198832 : i64} : () -> ()
  }) {sym_name = "js_max", entry = 4198648 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
