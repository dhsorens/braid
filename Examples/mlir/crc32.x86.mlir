"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb0_0 = "braid.zext"(%bb0_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb2] : () -> ()
    ^bb2:  // 0x401002
      %bb2_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb2_8 = "braid.get"() {reg = "rdx"} : () -> i64
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
      "braid_cf.br"()[^bb5] : () -> ()
    ^bb5:  // 0x401005
      %bb5_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb5_0)[^bb4f, ^bb7] : (i64) -> ()
    ^bb7:  // 0x401007
      %bb7_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb7_0 = "braid.zext"(%bb7_1) {bits = 32 : i64} : (i64) -> i64
      %bb7_8 = "braid.not"(%bb7_0) : (i64) -> i64
      %bb7_9 = "braid.zext"(%bb7_8) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb7_9) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb9] : () -> ()
    ^bb9:  // 0x401009
      %bb9_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb9_0 = "braid.zext"(%bb9_1) {bits = 32 : i64} : (i64) -> i64
      %bb9_9 = "braid.get"() {reg = "rcx"} : () -> i64
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
      "braid.set"(%bb9_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbb] : () -> ()
    ^bbb:  // 0x40100b
      %bbb_0 = "braid.const"() {value = 4202576 : i64} : () -> i64
      "braid.set"(%bbb_0) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb12] : () -> ()
    ^bb12:  // 0x401012
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x401020
      %bb20_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb20_3 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb20_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb20_5 = "braid.mul"(%bb20_3, %bb20_4) : (i64, i64) -> i64
      %bb20_6 = "braid.add"(%bb20_2, %bb20_5) : (i64, i64) -> i64
      %bb20_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_1 = "braid.add"(%bb20_6, %bb20_7) : (i64, i64) -> i64
      %bb20_0 = "braid.load"(%bb20_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb20_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb25] : () -> ()
    ^bb25:  // 0x401025
      %bb25_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb25_0 = "braid.zext"(%bb25_1) {bits = 32 : i64} : (i64) -> i64
      %bb25_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb25_8 = "braid.zext"(%bb25_9) {bits = 32 : i64} : (i64) -> i64
      %bb25_16 = "braid.xor"(%bb25_0, %bb25_8) : (i64, i64) -> i64
      %bb25_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb25_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb25_17) {flag = "of"} : (i64) -> ()
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
      %bb25_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb25_40 = "braid.and"(%bb25_16, %bb25_39) : (i64, i64) -> i64
      "braid.setf"(%bb25_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb25_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x401028
      %bb28_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb28_0 = "braid.zext"(%bb28_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb28_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb2b] : () -> ()
    ^bb2b:  // 0x40102b
      %bb2b_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb2b_0 = "braid.zext"(%bb2b_1) {bits = 32 : i64} : (i64) -> i64
      %bb2b_8 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb2b_9 = "braid.lshr"(%bb2b_0, %bb2b_8) : (i64, i64) -> i64
      %bb2b_11 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb2b_12 = "braid.lshr"(%bb2b_0, %bb2b_11) : (i64, i64) -> i64
      %bb2b_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2b_14 = "braid.and"(%bb2b_12, %bb2b_13) : (i64, i64) -> i64
      "braid.setf"(%bb2b_14) {flag = "cf"} : (i64) -> ()
      %bb2b_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb2b_17) {flag = "of"} : (i64) -> ()
      %bb2b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb2b_24) {flag = "af"} : (i64) -> ()
      %bb2b_32 = "braid.zext"(%bb2b_9) {bits = 8 : i64} : (i64) -> i64
      %bb2b_33 = "braid.popcnt"(%bb2b_32) : (i64) -> i64
      %bb2b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2b_35 = "braid.and"(%bb2b_33, %bb2b_34) : (i64, i64) -> i64
      %bb2b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2b_37 = "braid.eq"(%bb2b_35, %bb2b_36) : (i64, i64) -> i64
      "braid.setf"(%bb2b_37) {flag = "pf"} : (i64) -> ()
      %bb2b_38 = "braid.eq"(%bb2b_9, %bb2b_36) : (i64, i64) -> i64
      "braid.setf"(%bb2b_38) {flag = "zf"} : (i64) -> ()
      %bb2b_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb2b_40 = "braid.and"(%bb2b_9, %bb2b_39) : (i64, i64) -> i64
      "braid.setf"(%bb2b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb2b_9) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb2f] : () -> ()
    ^bb2f:  // 0x40102f
      %bb2f_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb2f_0 = "braid.zext"(%bb2f_1) {bits = 32 : i64} : (i64) -> i64
      %bb2f_8 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb2f_16 = "braid.and"(%bb2f_0, %bb2f_8) : (i64, i64) -> i64
      %bb2f_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb2f_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb2f_17) {flag = "of"} : (i64) -> ()
      %bb2f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb2f_24) {flag = "af"} : (i64) -> ()
      %bb2f_32 = "braid.zext"(%bb2f_16) {bits = 8 : i64} : (i64) -> i64
      %bb2f_33 = "braid.popcnt"(%bb2f_32) : (i64) -> i64
      %bb2f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2f_35 = "braid.and"(%bb2f_33, %bb2f_34) : (i64, i64) -> i64
      %bb2f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2f_37 = "braid.eq"(%bb2f_35, %bb2f_36) : (i64, i64) -> i64
      "braid.setf"(%bb2f_37) {flag = "pf"} : (i64) -> ()
      %bb2f_38 = "braid.eq"(%bb2f_16, %bb2f_36) : (i64, i64) -> i64
      "braid.setf"(%bb2f_38) {flag = "zf"} : (i64) -> ()
      %bb2f_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb2f_40 = "braid.and"(%bb2f_16, %bb2f_39) : (i64, i64) -> i64
      "braid.setf"(%bb2f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb2f_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb33] : () -> ()
    ^bb33:  // 0x401033
      %bb33_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb33_0 = "braid.zext"(%bb33_1) {bits = 32 : i64} : (i64) -> i64
      %bb33_10 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb33_11 = "braid.get"() {reg = "r8"} : () -> i64
      %bb33_12 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb33_13 = "braid.mul"(%bb33_11, %bb33_12) : (i64, i64) -> i64
      %bb33_14 = "braid.add"(%bb33_10, %bb33_13) : (i64, i64) -> i64
      %bb33_15 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb33_9 = "braid.add"(%bb33_14, %bb33_15) : (i64, i64) -> i64
      %bb33_8 = "braid.load"(%bb33_9) {bytes = 4 : i64} : (i64) -> i64
      %bb33_16 = "braid.xor"(%bb33_0, %bb33_8) : (i64, i64) -> i64
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
      %bb33_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb33_40 = "braid.and"(%bb33_16, %bb33_39) : (i64, i64) -> i64
      "braid.setf"(%bb33_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb33_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb37] : () -> ()
    ^bb37:  // 0x401037
      %bb37_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb37_0 = "braid.zext"(%bb37_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb37_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb3a] : () -> ()
    ^bb3a:  // 0x40103a
      %bb3a_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb3a_0 = "braid.zext"(%bb3a_1) {bits = 32 : i64} : (i64) -> i64
      %bb3a_8 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb3a_9 = "braid.lshr"(%bb3a_0, %bb3a_8) : (i64, i64) -> i64
      %bb3a_11 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb3a_12 = "braid.lshr"(%bb3a_0, %bb3a_11) : (i64, i64) -> i64
      %bb3a_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3a_14 = "braid.and"(%bb3a_12, %bb3a_13) : (i64, i64) -> i64
      "braid.setf"(%bb3a_14) {flag = "cf"} : (i64) -> ()
      %bb3a_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb3a_17) {flag = "of"} : (i64) -> ()
      %bb3a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb3a_24) {flag = "af"} : (i64) -> ()
      %bb3a_32 = "braid.zext"(%bb3a_9) {bits = 8 : i64} : (i64) -> i64
      %bb3a_33 = "braid.popcnt"(%bb3a_32) : (i64) -> i64
      %bb3a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3a_35 = "braid.and"(%bb3a_33, %bb3a_34) : (i64, i64) -> i64
      %bb3a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3a_37 = "braid.eq"(%bb3a_35, %bb3a_36) : (i64, i64) -> i64
      "braid.setf"(%bb3a_37) {flag = "pf"} : (i64) -> ()
      %bb3a_38 = "braid.eq"(%bb3a_9, %bb3a_36) : (i64, i64) -> i64
      "braid.setf"(%bb3a_38) {flag = "zf"} : (i64) -> ()
      %bb3a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb3a_40 = "braid.and"(%bb3a_9, %bb3a_39) : (i64, i64) -> i64
      "braid.setf"(%bb3a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb3a_9) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb3d] : () -> ()
    ^bb3d:  // 0x40103d
      %bb3d_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb3d_0 = "braid.zext"(%bb3d_1) {bits = 32 : i64} : (i64) -> i64
      %bb3d_8 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb3d_16 = "braid.and"(%bb3d_0, %bb3d_8) : (i64, i64) -> i64
      %bb3d_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb3d_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb3d_17) {flag = "of"} : (i64) -> ()
      %bb3d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb3d_24) {flag = "af"} : (i64) -> ()
      %bb3d_32 = "braid.zext"(%bb3d_16) {bits = 8 : i64} : (i64) -> i64
      %bb3d_33 = "braid.popcnt"(%bb3d_32) : (i64) -> i64
      %bb3d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3d_35 = "braid.and"(%bb3d_33, %bb3d_34) : (i64, i64) -> i64
      %bb3d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3d_37 = "braid.eq"(%bb3d_35, %bb3d_36) : (i64, i64) -> i64
      "braid.setf"(%bb3d_37) {flag = "pf"} : (i64) -> ()
      %bb3d_38 = "braid.eq"(%bb3d_16, %bb3d_36) : (i64, i64) -> i64
      "braid.setf"(%bb3d_38) {flag = "zf"} : (i64) -> ()
      %bb3d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb3d_40 = "braid.and"(%bb3d_16, %bb3d_39) : (i64, i64) -> i64
      "braid.setf"(%bb3d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb3d_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb41] : () -> ()
    ^bb41:  // 0x401041
      %bb41_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb41_0 = "braid.zext"(%bb41_1) {bits = 32 : i64} : (i64) -> i64
      %bb41_10 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb41_11 = "braid.get"() {reg = "r9"} : () -> i64
      %bb41_12 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb41_13 = "braid.mul"(%bb41_11, %bb41_12) : (i64, i64) -> i64
      %bb41_14 = "braid.add"(%bb41_10, %bb41_13) : (i64, i64) -> i64
      %bb41_15 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb41_9 = "braid.add"(%bb41_14, %bb41_15) : (i64, i64) -> i64
      %bb41_8 = "braid.load"(%bb41_9) {bytes = 4 : i64} : (i64) -> i64
      %bb41_16 = "braid.xor"(%bb41_0, %bb41_8) : (i64, i64) -> i64
      %bb41_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb41_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb41_17) {flag = "of"} : (i64) -> ()
      %bb41_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb41_24) {flag = "af"} : (i64) -> ()
      %bb41_32 = "braid.zext"(%bb41_16) {bits = 8 : i64} : (i64) -> i64
      %bb41_33 = "braid.popcnt"(%bb41_32) : (i64) -> i64
      %bb41_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb41_35 = "braid.and"(%bb41_33, %bb41_34) : (i64, i64) -> i64
      %bb41_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb41_37 = "braid.eq"(%bb41_35, %bb41_36) : (i64, i64) -> i64
      "braid.setf"(%bb41_37) {flag = "pf"} : (i64) -> ()
      %bb41_38 = "braid.eq"(%bb41_16, %bb41_36) : (i64, i64) -> i64
      "braid.setf"(%bb41_38) {flag = "zf"} : (i64) -> ()
      %bb41_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb41_40 = "braid.and"(%bb41_16, %bb41_39) : (i64, i64) -> i64
      "braid.setf"(%bb41_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb41_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb45] : () -> ()
    ^bb45:  // 0x401045
      %bb45_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb45_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb45_16 = "braid.add"(%bb45_0, %bb45_8) : (i64, i64) -> i64
      %bb45_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb45_20 = "braid.eq"(%bb45_16, %bb45_19) : (i64, i64) -> i64
      "braid.setf"(%bb45_20) {flag = "of"} : (i64) -> ()
      %bb45_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb45_24) {flag = "af"} : (i64) -> ()
      %bb45_32 = "braid.zext"(%bb45_16) {bits = 8 : i64} : (i64) -> i64
      %bb45_33 = "braid.popcnt"(%bb45_32) : (i64) -> i64
      %bb45_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb45_35 = "braid.and"(%bb45_33, %bb45_34) : (i64, i64) -> i64
      %bb45_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb45_37 = "braid.eq"(%bb45_35, %bb45_36) : (i64, i64) -> i64
      "braid.setf"(%bb45_37) {flag = "pf"} : (i64) -> ()
      %bb45_38 = "braid.eq"(%bb45_16, %bb45_36) : (i64, i64) -> i64
      "braid.setf"(%bb45_38) {flag = "zf"} : (i64) -> ()
      %bb45_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb45_40 = "braid.and"(%bb45_16, %bb45_39) : (i64, i64) -> i64
      "braid.setf"(%bb45_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb45_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x401048
      %bb48_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb48_8 = "braid.get"() {reg = "rcx"} : () -> i64
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
    ^bb4b:  // 0x40104b
      %bb4b_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb4b_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4b_0 = "braid.eq"(%bb4b_1, %bb4b_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb4b_0)[^bb20, ^bb4d] : (i64) -> ()
    ^bb4d:  // 0x40104d
      %bb4d_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb4d_0 = "braid.zext"(%bb4d_1) {bits = 32 : i64} : (i64) -> i64
      %bb4d_8 = "braid.not"(%bb4d_0) : (i64) -> i64
      %bb4d_9 = "braid.zext"(%bb4d_8) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb4d_9) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb4f] : () -> ()
    ^bb4f:  // 0x40104f
      %bb4f_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb4f_1 = "braid.load"(%bb4f_0) {bytes = 8 : i64} : (i64) -> i64
      %bb4f_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb4f_3 = "braid.add"(%bb4f_0, %bb4f_2) : (i64, i64) -> i64
      "braid.set"(%bb4f_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb4f_1) : (i64) -> ()
  }) {sym_name = "crc32", entry = 4198400 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
