"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_0 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb0_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb0_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_10 = "braid.sub"(%bb0_8, %bb0_9) : (i64, i64) -> i64
      "braid.set"(%bb0_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb0_10, %bb0_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1] : () -> ()
    ^bb1:  // 0x401001
      %bb1_0 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb1_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1_10 = "braid.sub"(%bb1_8, %bb1_9) : (i64, i64) -> i64
      "braid.set"(%bb1_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb1_10, %bb1_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb2] : () -> ()
    ^bb2:  // 0x401002
      %bb2_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb2_0 = "braid.load"(%bb2_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb2_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x401004
      %bb4_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb4_3 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb4_1 = "braid.add"(%bb4_2, %bb4_3) : (i64, i64) -> i64
      %bb4_0 = "braid.load"(%bb4_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb4_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb7] : () -> ()
    ^bb7:  // 0x401007
      %bb7_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb7_3 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb7_1 = "braid.add"(%bb7_2, %bb7_3) : (i64, i64) -> i64
      %bb7_0 = "braid.load"(%bb7_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb7_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bbb] : () -> ()
    ^bbb:  // 0x40100b
      %bbb_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbb_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbb_1 = "braid.add"(%bbb_2, %bbb_3) : (i64, i64) -> i64
      %bbb_0 = "braid.load"(%bbb_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbb_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bbf] : () -> ()
    ^bbf:  // 0x40100f
      %bbf_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bbf_0 = "braid.zext"(%bbf_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbf_0) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb12] : () -> ()
    ^bb12:  // 0x401012
      %bb12_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb12_0 = "braid.zext"(%bb12_1) {bits = 32 : i64} : (i64) -> i64
      %bb12_12 = "braid.const"() {value = 26 : i64} : () -> i64
      %bb12_13 = "braid.shl"(%bb12_0, %bb12_12) : (i64, i64) -> i64
      %bb12_14 = "braid.const"() {value = 6 : i64} : () -> i64
      %bb12_15 = "braid.lshr"(%bb12_0, %bb12_14) : (i64, i64) -> i64
      %bb12_16 = "braid.or"(%bb12_13, %bb12_15) : (i64, i64) -> i64
      %bb12_17 = "braid.zext"(%bb12_16) {bits = 32 : i64} : (i64) -> i64
      %bb12_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb12_19 = "braid.and"(%bb12_17, %bb12_18) : (i64, i64) -> i64
      "braid.setf"(%bb12_19) {flag = "cf"} : (i64) -> ()
      %bb12_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb12_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb12_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb16] : () -> ()
    ^bb16:  // 0x401016
      %bb16_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb16_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb16_1 = "braid.add"(%bb16_2, %bb16_3) : (i64, i64) -> i64
      %bb16_0 = "braid.load"(%bb16_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb16_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb1a] : () -> ()
    ^bb1a:  // 0x40101a
      %bb1a_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb1a_0 = "braid.zext"(%bb1a_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1a_0) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb1d] : () -> ()
    ^bb1d:  // 0x40101d
      %bb1d_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb1d_0 = "braid.zext"(%bb1d_1) {bits = 32 : i64} : (i64) -> i64
      %bb1d_12 = "braid.const"() {value = 21 : i64} : () -> i64
      %bb1d_13 = "braid.shl"(%bb1d_0, %bb1d_12) : (i64, i64) -> i64
      %bb1d_14 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb1d_15 = "braid.lshr"(%bb1d_0, %bb1d_14) : (i64, i64) -> i64
      %bb1d_16 = "braid.or"(%bb1d_13, %bb1d_15) : (i64, i64) -> i64
      %bb1d_17 = "braid.zext"(%bb1d_16) {bits = 32 : i64} : (i64) -> i64
      %bb1d_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1d_19 = "braid.and"(%bb1d_17, %bb1d_18) : (i64, i64) -> i64
      "braid.setf"(%bb1d_19) {flag = "cf"} : (i64) -> ()
      %bb1d_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1d_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb1d_17) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x401020
      %bb20_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb20_0 = "braid.zext"(%bb20_1) {bits = 32 : i64} : (i64) -> i64
      %bb20_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb20_8 = "braid.zext"(%bb20_9) {bits = 32 : i64} : (i64) -> i64
      %bb20_16 = "braid.xor"(%bb20_0, %bb20_8) : (i64, i64) -> i64
      %bb20_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb20_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb20_17) {flag = "of"} : (i64) -> ()
      %bb20_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb20_24) {flag = "af"} : (i64) -> ()
      %bb20_32 = "braid.zext"(%bb20_16) {bits = 8 : i64} : (i64) -> i64
      %bb20_33 = "braid.popcnt"(%bb20_32) : (i64) -> i64
      %bb20_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb20_35 = "braid.and"(%bb20_33, %bb20_34) : (i64, i64) -> i64
      %bb20_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_37 = "braid.eq"(%bb20_35, %bb20_36) : (i64, i64) -> i64
      "braid.setf"(%bb20_37) {flag = "pf"} : (i64) -> ()
      %bb20_38 = "braid.eq"(%bb20_16, %bb20_36) : (i64, i64) -> i64
      "braid.setf"(%bb20_38) {flag = "zf"} : (i64) -> ()
      %bb20_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb20_40 = "braid.and"(%bb20_16, %bb20_39) : (i64, i64) -> i64
      "braid.setf"(%bb20_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb20_16) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb23] : () -> ()
    ^bb23:  // 0x401023
      %bb23_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb23_0 = "braid.zext"(%bb23_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb23_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb26] : () -> ()
    ^bb26:  // 0x401026
      %bb26_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb26_0 = "braid.zext"(%bb26_1) {bits = 32 : i64} : (i64) -> i64
      %bb26_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb26_13 = "braid.shl"(%bb26_0, %bb26_12) : (i64, i64) -> i64
      %bb26_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb26_15 = "braid.lshr"(%bb26_0, %bb26_14) : (i64, i64) -> i64
      %bb26_16 = "braid.or"(%bb26_13, %bb26_15) : (i64, i64) -> i64
      %bb26_17 = "braid.zext"(%bb26_16) {bits = 32 : i64} : (i64) -> i64
      %bb26_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb26_19 = "braid.and"(%bb26_17, %bb26_18) : (i64, i64) -> i64
      "braid.setf"(%bb26_19) {flag = "cf"} : (i64) -> ()
      %bb26_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb26_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb26_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb29] : () -> ()
    ^bb29:  // 0x401029
      %bb29_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb29_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb29_1 = "braid.add"(%bb29_2, %bb29_3) : (i64, i64) -> i64
      %bb29_0 = "braid.load"(%bb29_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb29_0) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb2d] : () -> ()
    ^bb2d:  // 0x40102d
      %bb2d_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb2d_0 = "braid.zext"(%bb2d_1) {bits = 32 : i64} : (i64) -> i64
      %bb2d_9 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb2d_8 = "braid.zext"(%bb2d_9) {bits = 32 : i64} : (i64) -> i64
      %bb2d_16 = "braid.xor"(%bb2d_0, %bb2d_8) : (i64, i64) -> i64
      %bb2d_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb2d_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb2d_17) {flag = "of"} : (i64) -> ()
      %bb2d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb2d_24) {flag = "af"} : (i64) -> ()
      %bb2d_32 = "braid.zext"(%bb2d_16) {bits = 8 : i64} : (i64) -> i64
      %bb2d_33 = "braid.popcnt"(%bb2d_32) : (i64) -> i64
      %bb2d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2d_35 = "braid.and"(%bb2d_33, %bb2d_34) : (i64, i64) -> i64
      %bb2d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2d_37 = "braid.eq"(%bb2d_35, %bb2d_36) : (i64, i64) -> i64
      "braid.setf"(%bb2d_37) {flag = "pf"} : (i64) -> ()
      %bb2d_38 = "braid.eq"(%bb2d_16, %bb2d_36) : (i64, i64) -> i64
      "braid.setf"(%bb2d_38) {flag = "zf"} : (i64) -> ()
      %bb2d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb2d_40 = "braid.and"(%bb2d_16, %bb2d_39) : (i64, i64) -> i64
      "braid.setf"(%bb2d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb2d_16) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb2f] : () -> ()
    ^bb2f:  // 0x40102f
      %bb2f_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb2f_0 = "braid.zext"(%bb2f_1) {bits = 32 : i64} : (i64) -> i64
      %bb2f_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb2f_8 = "braid.zext"(%bb2f_9) {bits = 32 : i64} : (i64) -> i64
      %bb2f_16 = "braid.add"(%bb2f_0, %bb2f_8) : (i64, i64) -> i64
      %bb2f_17 = "braid.zext"(%bb2f_16) {bits = 32 : i64} : (i64) -> i64
      %bb2f_18 = "braid.ult"(%bb2f_17, %bb2f_0) : (i64, i64) -> i64
      "braid.setf"(%bb2f_18) {flag = "cf"} : (i64) -> ()
      %bb2f_19 = "braid.xor"(%bb2f_0, %bb2f_17) : (i64, i64) -> i64
      %bb2f_20 = "braid.xor"(%bb2f_8, %bb2f_17) : (i64, i64) -> i64
      %bb2f_21 = "braid.and"(%bb2f_19, %bb2f_20) : (i64, i64) -> i64
      %bb2f_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb2f_23 = "braid.and"(%bb2f_21, %bb2f_22) : (i64, i64) -> i64
      "braid.setf"(%bb2f_23) {flag = "of"} : (i64) -> ()
      %bb2f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb2f_24) {flag = "af"} : (i64) -> ()
      %bb2f_32 = "braid.zext"(%bb2f_17) {bits = 8 : i64} : (i64) -> i64
      %bb2f_33 = "braid.popcnt"(%bb2f_32) : (i64) -> i64
      %bb2f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2f_35 = "braid.and"(%bb2f_33, %bb2f_34) : (i64, i64) -> i64
      %bb2f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2f_37 = "braid.eq"(%bb2f_35, %bb2f_36) : (i64, i64) -> i64
      "braid.setf"(%bb2f_37) {flag = "pf"} : (i64) -> ()
      %bb2f_38 = "braid.eq"(%bb2f_17, %bb2f_36) : (i64, i64) -> i64
      "braid.setf"(%bb2f_38) {flag = "zf"} : (i64) -> ()
      %bb2f_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb2f_40 = "braid.and"(%bb2f_17, %bb2f_39) : (i64, i64) -> i64
      "braid.setf"(%bb2f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb2f_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb31] : () -> ()
    ^bb31:  // 0x401031
      %bb31_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb31_0 = "braid.zext"(%bb31_1) {bits = 32 : i64} : (i64) -> i64
      %bb31_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb31_8 = "braid.zext"(%bb31_9) {bits = 32 : i64} : (i64) -> i64
      %bb31_16 = "braid.add"(%bb31_0, %bb31_8) : (i64, i64) -> i64
      %bb31_17 = "braid.zext"(%bb31_16) {bits = 32 : i64} : (i64) -> i64
      %bb31_18 = "braid.ult"(%bb31_17, %bb31_0) : (i64, i64) -> i64
      "braid.setf"(%bb31_18) {flag = "cf"} : (i64) -> ()
      %bb31_19 = "braid.xor"(%bb31_0, %bb31_17) : (i64, i64) -> i64
      %bb31_20 = "braid.xor"(%bb31_8, %bb31_17) : (i64, i64) -> i64
      %bb31_21 = "braid.and"(%bb31_19, %bb31_20) : (i64, i64) -> i64
      %bb31_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb31_23 = "braid.and"(%bb31_21, %bb31_22) : (i64, i64) -> i64
      "braid.setf"(%bb31_23) {flag = "of"} : (i64) -> ()
      %bb31_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb31_24) {flag = "af"} : (i64) -> ()
      %bb31_32 = "braid.zext"(%bb31_17) {bits = 8 : i64} : (i64) -> i64
      %bb31_33 = "braid.popcnt"(%bb31_32) : (i64) -> i64
      %bb31_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb31_35 = "braid.and"(%bb31_33, %bb31_34) : (i64, i64) -> i64
      %bb31_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb31_37 = "braid.eq"(%bb31_35, %bb31_36) : (i64, i64) -> i64
      "braid.setf"(%bb31_37) {flag = "pf"} : (i64) -> ()
      %bb31_38 = "braid.eq"(%bb31_17, %bb31_36) : (i64, i64) -> i64
      "braid.setf"(%bb31_38) {flag = "zf"} : (i64) -> ()
      %bb31_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb31_40 = "braid.and"(%bb31_17, %bb31_39) : (i64, i64) -> i64
      "braid.setf"(%bb31_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb31_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb33] : () -> ()
    ^bb33:  // 0x401033
      %bb33_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb33_3 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb33_1 = "braid.add"(%bb33_2, %bb33_3) : (i64, i64) -> i64
      %bb33_0 = "braid.load"(%bb33_1) {bytes = 4 : i64} : (i64) -> i64
      %bb33_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb33_8 = "braid.zext"(%bb33_9) {bits = 32 : i64} : (i64) -> i64
      %bb33_16 = "braid.add"(%bb33_0, %bb33_8) : (i64, i64) -> i64
      %bb33_17 = "braid.zext"(%bb33_16) {bits = 32 : i64} : (i64) -> i64
      %bb33_18 = "braid.ult"(%bb33_17, %bb33_0) : (i64, i64) -> i64
      "braid.setf"(%bb33_18) {flag = "cf"} : (i64) -> ()
      %bb33_19 = "braid.xor"(%bb33_0, %bb33_17) : (i64, i64) -> i64
      %bb33_20 = "braid.xor"(%bb33_8, %bb33_17) : (i64, i64) -> i64
      %bb33_21 = "braid.and"(%bb33_19, %bb33_20) : (i64, i64) -> i64
      %bb33_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb33_23 = "braid.and"(%bb33_21, %bb33_22) : (i64, i64) -> i64
      "braid.setf"(%bb33_23) {flag = "of"} : (i64) -> ()
      %bb33_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb33_24) {flag = "af"} : (i64) -> ()
      %bb33_32 = "braid.zext"(%bb33_17) {bits = 8 : i64} : (i64) -> i64
      %bb33_33 = "braid.popcnt"(%bb33_32) : (i64) -> i64
      %bb33_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb33_35 = "braid.and"(%bb33_33, %bb33_34) : (i64, i64) -> i64
      %bb33_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb33_37 = "braid.eq"(%bb33_35, %bb33_36) : (i64, i64) -> i64
      "braid.setf"(%bb33_37) {flag = "pf"} : (i64) -> ()
      %bb33_38 = "braid.eq"(%bb33_17, %bb33_36) : (i64, i64) -> i64
      "braid.setf"(%bb33_38) {flag = "zf"} : (i64) -> ()
      %bb33_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb33_40 = "braid.and"(%bb33_17, %bb33_39) : (i64, i64) -> i64
      "braid.setf"(%bb33_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb33_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb36] : () -> ()
    ^bb36:  // 0x401036
      %bb36_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb36_0 = "braid.zext"(%bb36_1) {bits = 32 : i64} : (i64) -> i64
      %bb36_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb36_10 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb36_8 = "braid.add"(%bb36_9, %bb36_10) : (i64, i64) -> i64
      "braid.store"(%bb36_8, %bb36_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb3a] : () -> ()
    ^bb3a:  // 0x40103a
      %bb3a_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb3a_0 = "braid.zext"(%bb3a_1) {bits = 32 : i64} : (i64) -> i64
      %bb3a_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb3a_10 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb3a_8 = "braid.add"(%bb3a_9, %bb3a_10) : (i64, i64) -> i64
      "braid.store"(%bb3a_8, %bb3a_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb3e] : () -> ()
    ^bb3e:  // 0x40103e
      %bb3e_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb3e_0 = "braid.zext"(%bb3e_1) {bits = 32 : i64} : (i64) -> i64
      %bb3e_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb3e_8 = "braid.zext"(%bb3e_9) {bits = 32 : i64} : (i64) -> i64
      %bb3e_16 = "braid.xor"(%bb3e_0, %bb3e_8) : (i64, i64) -> i64
      %bb3e_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb3e_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb3e_17) {flag = "of"} : (i64) -> ()
      %bb3e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb3e_24) {flag = "af"} : (i64) -> ()
      %bb3e_32 = "braid.zext"(%bb3e_16) {bits = 8 : i64} : (i64) -> i64
      %bb3e_33 = "braid.popcnt"(%bb3e_32) : (i64) -> i64
      %bb3e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3e_35 = "braid.and"(%bb3e_33, %bb3e_34) : (i64, i64) -> i64
      %bb3e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3e_37 = "braid.eq"(%bb3e_35, %bb3e_36) : (i64, i64) -> i64
      "braid.setf"(%bb3e_37) {flag = "pf"} : (i64) -> ()
      %bb3e_38 = "braid.eq"(%bb3e_16, %bb3e_36) : (i64, i64) -> i64
      "braid.setf"(%bb3e_38) {flag = "zf"} : (i64) -> ()
      %bb3e_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb3e_40 = "braid.and"(%bb3e_16, %bb3e_39) : (i64, i64) -> i64
      "braid.setf"(%bb3e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb3e_16) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb41] : () -> ()
    ^bb41:  // 0x401041
      %bb41_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb41_0 = "braid.zext"(%bb41_1) {bits = 32 : i64} : (i64) -> i64
      %bb41_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb41_8 = "braid.zext"(%bb41_9) {bits = 32 : i64} : (i64) -> i64
      %bb41_16 = "braid.and"(%bb41_0, %bb41_8) : (i64, i64) -> i64
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
      "braid.set"(%bb41_16) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x401044
      %bb44_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb44_0 = "braid.zext"(%bb44_1) {bits = 32 : i64} : (i64) -> i64
      %bb44_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb44_8 = "braid.zext"(%bb44_9) {bits = 32 : i64} : (i64) -> i64
      %bb44_16 = "braid.xor"(%bb44_0, %bb44_8) : (i64, i64) -> i64
      %bb44_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb44_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb44_17) {flag = "of"} : (i64) -> ()
      %bb44_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb44_24) {flag = "af"} : (i64) -> ()
      %bb44_32 = "braid.zext"(%bb44_16) {bits = 8 : i64} : (i64) -> i64
      %bb44_33 = "braid.popcnt"(%bb44_32) : (i64) -> i64
      %bb44_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb44_35 = "braid.and"(%bb44_33, %bb44_34) : (i64, i64) -> i64
      %bb44_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb44_37 = "braid.eq"(%bb44_35, %bb44_36) : (i64, i64) -> i64
      "braid.setf"(%bb44_37) {flag = "pf"} : (i64) -> ()
      %bb44_38 = "braid.eq"(%bb44_16, %bb44_36) : (i64, i64) -> i64
      "braid.setf"(%bb44_38) {flag = "zf"} : (i64) -> ()
      %bb44_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb44_40 = "braid.and"(%bb44_16, %bb44_39) : (i64, i64) -> i64
      "braid.setf"(%bb44_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb44_16) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb47] : () -> ()
    ^bb47:  // 0x401047
      %bb47_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb47_0 = "braid.zext"(%bb47_1) {bits = 32 : i64} : (i64) -> i64
      %bb47_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb47_8 = "braid.zext"(%bb47_9) {bits = 32 : i64} : (i64) -> i64
      %bb47_16 = "braid.add"(%bb47_0, %bb47_8) : (i64, i64) -> i64
      %bb47_17 = "braid.zext"(%bb47_16) {bits = 32 : i64} : (i64) -> i64
      %bb47_18 = "braid.ult"(%bb47_17, %bb47_0) : (i64, i64) -> i64
      "braid.setf"(%bb47_18) {flag = "cf"} : (i64) -> ()
      %bb47_19 = "braid.xor"(%bb47_0, %bb47_17) : (i64, i64) -> i64
      %bb47_20 = "braid.xor"(%bb47_8, %bb47_17) : (i64, i64) -> i64
      %bb47_21 = "braid.and"(%bb47_19, %bb47_20) : (i64, i64) -> i64
      %bb47_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb47_23 = "braid.and"(%bb47_21, %bb47_22) : (i64, i64) -> i64
      "braid.setf"(%bb47_23) {flag = "of"} : (i64) -> ()
      %bb47_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb47_24) {flag = "af"} : (i64) -> ()
      %bb47_32 = "braid.zext"(%bb47_17) {bits = 8 : i64} : (i64) -> i64
      %bb47_33 = "braid.popcnt"(%bb47_32) : (i64) -> i64
      %bb47_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb47_35 = "braid.and"(%bb47_33, %bb47_34) : (i64, i64) -> i64
      %bb47_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb47_37 = "braid.eq"(%bb47_35, %bb47_36) : (i64, i64) -> i64
      "braid.setf"(%bb47_37) {flag = "pf"} : (i64) -> ()
      %bb47_38 = "braid.eq"(%bb47_17, %bb47_36) : (i64, i64) -> i64
      "braid.setf"(%bb47_38) {flag = "zf"} : (i64) -> ()
      %bb47_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb47_40 = "braid.and"(%bb47_17, %bb47_39) : (i64, i64) -> i64
      "braid.setf"(%bb47_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb47_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb4a] : () -> ()
    ^bb4a:  // 0x40104a
      %bb4a_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb4a_0 = "braid.zext"(%bb4a_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb4a_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x40104c
      %bb4c_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb4c_0 = "braid.zext"(%bb4c_1) {bits = 32 : i64} : (i64) -> i64
      %bb4c_12 = "braid.const"() {value = 30 : i64} : () -> i64
      %bb4c_13 = "braid.shl"(%bb4c_0, %bb4c_12) : (i64, i64) -> i64
      %bb4c_14 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb4c_15 = "braid.lshr"(%bb4c_0, %bb4c_14) : (i64, i64) -> i64
      %bb4c_16 = "braid.or"(%bb4c_13, %bb4c_15) : (i64, i64) -> i64
      %bb4c_17 = "braid.zext"(%bb4c_16) {bits = 32 : i64} : (i64) -> i64
      %bb4c_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4c_19 = "braid.and"(%bb4c_17, %bb4c_18) : (i64, i64) -> i64
      "braid.setf"(%bb4c_19) {flag = "cf"} : (i64) -> ()
      %bb4c_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb4c_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb4c_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb4f] : () -> ()
    ^bb4f:  // 0x40104f
      %bb4f_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb4f_0 = "braid.zext"(%bb4f_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb4f_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb52] : () -> ()
    ^bb52:  // 0x401052
      %bb52_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb52_0 = "braid.zext"(%bb52_1) {bits = 32 : i64} : (i64) -> i64
      %bb52_12 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb52_13 = "braid.shl"(%bb52_0, %bb52_12) : (i64, i64) -> i64
      %bb52_14 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb52_15 = "braid.lshr"(%bb52_0, %bb52_14) : (i64, i64) -> i64
      %bb52_16 = "braid.or"(%bb52_13, %bb52_15) : (i64, i64) -> i64
      %bb52_17 = "braid.zext"(%bb52_16) {bits = 32 : i64} : (i64) -> i64
      %bb52_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb52_19 = "braid.and"(%bb52_17, %bb52_18) : (i64, i64) -> i64
      "braid.setf"(%bb52_19) {flag = "cf"} : (i64) -> ()
      %bb52_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb52_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb52_17) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb56] : () -> ()
    ^bb56:  // 0x401056
      %bb56_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb56_0 = "braid.zext"(%bb56_1) {bits = 32 : i64} : (i64) -> i64
      %bb56_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb56_8 = "braid.zext"(%bb56_9) {bits = 32 : i64} : (i64) -> i64
      %bb56_16 = "braid.xor"(%bb56_0, %bb56_8) : (i64, i64) -> i64
      %bb56_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb56_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb56_17) {flag = "of"} : (i64) -> ()
      %bb56_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb56_24) {flag = "af"} : (i64) -> ()
      %bb56_32 = "braid.zext"(%bb56_16) {bits = 8 : i64} : (i64) -> i64
      %bb56_33 = "braid.popcnt"(%bb56_32) : (i64) -> i64
      %bb56_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb56_35 = "braid.and"(%bb56_33, %bb56_34) : (i64, i64) -> i64
      %bb56_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb56_37 = "braid.eq"(%bb56_35, %bb56_36) : (i64, i64) -> i64
      "braid.setf"(%bb56_37) {flag = "pf"} : (i64) -> ()
      %bb56_38 = "braid.eq"(%bb56_16, %bb56_36) : (i64, i64) -> i64
      "braid.setf"(%bb56_38) {flag = "zf"} : (i64) -> ()
      %bb56_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb56_40 = "braid.and"(%bb56_16, %bb56_39) : (i64, i64) -> i64
      "braid.setf"(%bb56_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb56_16) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb59] : () -> ()
    ^bb59:  // 0x401059
      %bb59_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb59_0 = "braid.zext"(%bb59_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb59_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb5b] : () -> ()
    ^bb5b:  // 0x40105b
      %bb5b_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb5b_0 = "braid.zext"(%bb5b_1) {bits = 32 : i64} : (i64) -> i64
      %bb5b_12 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb5b_13 = "braid.shl"(%bb5b_0, %bb5b_12) : (i64, i64) -> i64
      %bb5b_14 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb5b_15 = "braid.lshr"(%bb5b_0, %bb5b_14) : (i64, i64) -> i64
      %bb5b_16 = "braid.or"(%bb5b_13, %bb5b_15) : (i64, i64) -> i64
      %bb5b_17 = "braid.zext"(%bb5b_16) {bits = 32 : i64} : (i64) -> i64
      %bb5b_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb5b_19 = "braid.and"(%bb5b_17, %bb5b_18) : (i64, i64) -> i64
      "braid.setf"(%bb5b_19) {flag = "cf"} : (i64) -> ()
      %bb5b_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb5b_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb5b_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb5e] : () -> ()
    ^bb5e:  // 0x40105e
      %bb5e_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb5e_0 = "braid.zext"(%bb5e_1) {bits = 32 : i64} : (i64) -> i64
      %bb5e_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb5e_8 = "braid.zext"(%bb5e_9) {bits = 32 : i64} : (i64) -> i64
      %bb5e_16 = "braid.xor"(%bb5e_0, %bb5e_8) : (i64, i64) -> i64
      %bb5e_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb5e_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb5e_17) {flag = "of"} : (i64) -> ()
      %bb5e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb5e_24) {flag = "af"} : (i64) -> ()
      %bb5e_32 = "braid.zext"(%bb5e_16) {bits = 8 : i64} : (i64) -> i64
      %bb5e_33 = "braid.popcnt"(%bb5e_32) : (i64) -> i64
      %bb5e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb5e_35 = "braid.and"(%bb5e_33, %bb5e_34) : (i64, i64) -> i64
      %bb5e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb5e_37 = "braid.eq"(%bb5e_35, %bb5e_36) : (i64, i64) -> i64
      "braid.setf"(%bb5e_37) {flag = "pf"} : (i64) -> ()
      %bb5e_38 = "braid.eq"(%bb5e_16, %bb5e_36) : (i64, i64) -> i64
      "braid.setf"(%bb5e_38) {flag = "zf"} : (i64) -> ()
      %bb5e_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb5e_40 = "braid.and"(%bb5e_16, %bb5e_39) : (i64, i64) -> i64
      "braid.setf"(%bb5e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb5e_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb61] : () -> ()
    ^bb61:  // 0x401061
      %bb61_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb61_0 = "braid.zext"(%bb61_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb61_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x401064
      %bb64_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb64_0 = "braid.zext"(%bb64_1) {bits = 32 : i64} : (i64) -> i64
      %bb64_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb64_8 = "braid.zext"(%bb64_9) {bits = 32 : i64} : (i64) -> i64
      %bb64_16 = "braid.xor"(%bb64_0, %bb64_8) : (i64, i64) -> i64
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
      %bb64_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb64_40 = "braid.and"(%bb64_16, %bb64_39) : (i64, i64) -> i64
      "braid.setf"(%bb64_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb64_16) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb67] : () -> ()
    ^bb67:  // 0x401067
      %bb67_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb67_0 = "braid.zext"(%bb67_1) {bits = 32 : i64} : (i64) -> i64
      %bb67_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb67_8 = "braid.zext"(%bb67_9) {bits = 32 : i64} : (i64) -> i64
      %bb67_16 = "braid.and"(%bb67_0, %bb67_8) : (i64, i64) -> i64
      %bb67_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb67_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb67_17) {flag = "of"} : (i64) -> ()
      %bb67_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb67_24) {flag = "af"} : (i64) -> ()
      %bb67_32 = "braid.zext"(%bb67_16) {bits = 8 : i64} : (i64) -> i64
      %bb67_33 = "braid.popcnt"(%bb67_32) : (i64) -> i64
      %bb67_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb67_35 = "braid.and"(%bb67_33, %bb67_34) : (i64, i64) -> i64
      %bb67_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb67_37 = "braid.eq"(%bb67_35, %bb67_36) : (i64, i64) -> i64
      "braid.setf"(%bb67_37) {flag = "pf"} : (i64) -> ()
      %bb67_38 = "braid.eq"(%bb67_16, %bb67_36) : (i64, i64) -> i64
      "braid.setf"(%bb67_38) {flag = "zf"} : (i64) -> ()
      %bb67_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb67_40 = "braid.and"(%bb67_16, %bb67_39) : (i64, i64) -> i64
      "braid.setf"(%bb67_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb67_16) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb6a] : () -> ()
    ^bb6a:  // 0x40106a
      %bb6a_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb6a_0 = "braid.zext"(%bb6a_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb6a_0) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb6d] : () -> ()
    ^bb6d:  // 0x40106d
      %bb6d_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb6d_0 = "braid.zext"(%bb6d_1) {bits = 32 : i64} : (i64) -> i64
      %bb6d_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb6d_8 = "braid.zext"(%bb6d_9) {bits = 32 : i64} : (i64) -> i64
      %bb6d_16 = "braid.and"(%bb6d_0, %bb6d_8) : (i64, i64) -> i64
      %bb6d_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb6d_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb6d_17) {flag = "of"} : (i64) -> ()
      %bb6d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb6d_24) {flag = "af"} : (i64) -> ()
      %bb6d_32 = "braid.zext"(%bb6d_16) {bits = 8 : i64} : (i64) -> i64
      %bb6d_33 = "braid.popcnt"(%bb6d_32) : (i64) -> i64
      %bb6d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6d_35 = "braid.and"(%bb6d_33, %bb6d_34) : (i64, i64) -> i64
      %bb6d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6d_37 = "braid.eq"(%bb6d_35, %bb6d_36) : (i64, i64) -> i64
      "braid.setf"(%bb6d_37) {flag = "pf"} : (i64) -> ()
      %bb6d_38 = "braid.eq"(%bb6d_16, %bb6d_36) : (i64, i64) -> i64
      "braid.setf"(%bb6d_38) {flag = "zf"} : (i64) -> ()
      %bb6d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb6d_40 = "braid.and"(%bb6d_16, %bb6d_39) : (i64, i64) -> i64
      "braid.setf"(%bb6d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb6d_16) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x401070
      %bb70_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb70_0 = "braid.zext"(%bb70_1) {bits = 32 : i64} : (i64) -> i64
      %bb70_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb70_8 = "braid.zext"(%bb70_9) {bits = 32 : i64} : (i64) -> i64
      %bb70_16 = "braid.xor"(%bb70_0, %bb70_8) : (i64, i64) -> i64
      %bb70_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb70_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb70_17) {flag = "of"} : (i64) -> ()
      %bb70_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb70_24) {flag = "af"} : (i64) -> ()
      %bb70_32 = "braid.zext"(%bb70_16) {bits = 8 : i64} : (i64) -> i64
      %bb70_33 = "braid.popcnt"(%bb70_32) : (i64) -> i64
      %bb70_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb70_35 = "braid.and"(%bb70_33, %bb70_34) : (i64, i64) -> i64
      %bb70_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb70_37 = "braid.eq"(%bb70_35, %bb70_36) : (i64, i64) -> i64
      "braid.setf"(%bb70_37) {flag = "pf"} : (i64) -> ()
      %bb70_38 = "braid.eq"(%bb70_16, %bb70_36) : (i64, i64) -> i64
      "braid.setf"(%bb70_38) {flag = "zf"} : (i64) -> ()
      %bb70_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb70_40 = "braid.and"(%bb70_16, %bb70_39) : (i64, i64) -> i64
      "braid.setf"(%bb70_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb70_16) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb73] : () -> ()
    ^bb73:  // 0x401073
      %bb73_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb73_0 = "braid.zext"(%bb73_1) {bits = 32 : i64} : (i64) -> i64
      %bb73_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb73_8 = "braid.zext"(%bb73_9) {bits = 32 : i64} : (i64) -> i64
      %bb73_16 = "braid.add"(%bb73_0, %bb73_8) : (i64, i64) -> i64
      %bb73_17 = "braid.zext"(%bb73_16) {bits = 32 : i64} : (i64) -> i64
      %bb73_18 = "braid.ult"(%bb73_17, %bb73_0) : (i64, i64) -> i64
      "braid.setf"(%bb73_18) {flag = "cf"} : (i64) -> ()
      %bb73_19 = "braid.xor"(%bb73_0, %bb73_17) : (i64, i64) -> i64
      %bb73_20 = "braid.xor"(%bb73_8, %bb73_17) : (i64, i64) -> i64
      %bb73_21 = "braid.and"(%bb73_19, %bb73_20) : (i64, i64) -> i64
      %bb73_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb73_23 = "braid.and"(%bb73_21, %bb73_22) : (i64, i64) -> i64
      "braid.setf"(%bb73_23) {flag = "of"} : (i64) -> ()
      %bb73_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb73_24) {flag = "af"} : (i64) -> ()
      %bb73_32 = "braid.zext"(%bb73_17) {bits = 8 : i64} : (i64) -> i64
      %bb73_33 = "braid.popcnt"(%bb73_32) : (i64) -> i64
      %bb73_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb73_35 = "braid.and"(%bb73_33, %bb73_34) : (i64, i64) -> i64
      %bb73_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb73_37 = "braid.eq"(%bb73_35, %bb73_36) : (i64, i64) -> i64
      "braid.setf"(%bb73_37) {flag = "pf"} : (i64) -> ()
      %bb73_38 = "braid.eq"(%bb73_17, %bb73_36) : (i64, i64) -> i64
      "braid.setf"(%bb73_38) {flag = "zf"} : (i64) -> ()
      %bb73_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb73_40 = "braid.and"(%bb73_17, %bb73_39) : (i64, i64) -> i64
      "braid.setf"(%bb73_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb73_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb76] : () -> ()
    ^bb76:  // 0x401076
      %bb76_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb76_0 = "braid.zext"(%bb76_1) {bits = 32 : i64} : (i64) -> i64
      %bb76_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb76_10 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb76_8 = "braid.add"(%bb76_9, %bb76_10) : (i64, i64) -> i64
      "braid.store"(%bb76_8, %bb76_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb7a] : () -> ()
    ^bb7a:  // 0x40107a
      %bb7a_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb7a_0 = "braid.zext"(%bb7a_1) {bits = 32 : i64} : (i64) -> i64
      %bb7a_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb7a_8 = "braid.zext"(%bb7a_9) {bits = 32 : i64} : (i64) -> i64
      %bb7a_16 = "braid.add"(%bb7a_0, %bb7a_8) : (i64, i64) -> i64
      %bb7a_17 = "braid.zext"(%bb7a_16) {bits = 32 : i64} : (i64) -> i64
      %bb7a_18 = "braid.ult"(%bb7a_17, %bb7a_0) : (i64, i64) -> i64
      "braid.setf"(%bb7a_18) {flag = "cf"} : (i64) -> ()
      %bb7a_19 = "braid.xor"(%bb7a_0, %bb7a_17) : (i64, i64) -> i64
      %bb7a_20 = "braid.xor"(%bb7a_8, %bb7a_17) : (i64, i64) -> i64
      %bb7a_21 = "braid.and"(%bb7a_19, %bb7a_20) : (i64, i64) -> i64
      %bb7a_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb7a_23 = "braid.and"(%bb7a_21, %bb7a_22) : (i64, i64) -> i64
      "braid.setf"(%bb7a_23) {flag = "of"} : (i64) -> ()
      %bb7a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb7a_24) {flag = "af"} : (i64) -> ()
      %bb7a_32 = "braid.zext"(%bb7a_17) {bits = 8 : i64} : (i64) -> i64
      %bb7a_33 = "braid.popcnt"(%bb7a_32) : (i64) -> i64
      %bb7a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb7a_35 = "braid.and"(%bb7a_33, %bb7a_34) : (i64, i64) -> i64
      %bb7a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7a_37 = "braid.eq"(%bb7a_35, %bb7a_36) : (i64, i64) -> i64
      "braid.setf"(%bb7a_37) {flag = "pf"} : (i64) -> ()
      %bb7a_38 = "braid.eq"(%bb7a_17, %bb7a_36) : (i64, i64) -> i64
      "braid.setf"(%bb7a_38) {flag = "zf"} : (i64) -> ()
      %bb7a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb7a_40 = "braid.and"(%bb7a_17, %bb7a_39) : (i64, i64) -> i64
      "braid.setf"(%bb7a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb7a_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb7d] : () -> ()
    ^bb7d:  // 0x40107d
      %bb7d_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb7d_3 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb7d_1 = "braid.add"(%bb7d_2, %bb7d_3) : (i64, i64) -> i64
      %bb7d_0 = "braid.load"(%bb7d_1) {bytes = 4 : i64} : (i64) -> i64
      %bb7d_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb7d_8 = "braid.zext"(%bb7d_9) {bits = 32 : i64} : (i64) -> i64
      %bb7d_16 = "braid.add"(%bb7d_0, %bb7d_8) : (i64, i64) -> i64
      %bb7d_17 = "braid.zext"(%bb7d_16) {bits = 32 : i64} : (i64) -> i64
      %bb7d_18 = "braid.ult"(%bb7d_17, %bb7d_0) : (i64, i64) -> i64
      "braid.setf"(%bb7d_18) {flag = "cf"} : (i64) -> ()
      %bb7d_19 = "braid.xor"(%bb7d_0, %bb7d_17) : (i64, i64) -> i64
      %bb7d_20 = "braid.xor"(%bb7d_8, %bb7d_17) : (i64, i64) -> i64
      %bb7d_21 = "braid.and"(%bb7d_19, %bb7d_20) : (i64, i64) -> i64
      %bb7d_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb7d_23 = "braid.and"(%bb7d_21, %bb7d_22) : (i64, i64) -> i64
      "braid.setf"(%bb7d_23) {flag = "of"} : (i64) -> ()
      %bb7d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb7d_24) {flag = "af"} : (i64) -> ()
      %bb7d_32 = "braid.zext"(%bb7d_17) {bits = 8 : i64} : (i64) -> i64
      %bb7d_33 = "braid.popcnt"(%bb7d_32) : (i64) -> i64
      %bb7d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb7d_35 = "braid.and"(%bb7d_33, %bb7d_34) : (i64, i64) -> i64
      %bb7d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7d_37 = "braid.eq"(%bb7d_35, %bb7d_36) : (i64, i64) -> i64
      "braid.setf"(%bb7d_37) {flag = "pf"} : (i64) -> ()
      %bb7d_38 = "braid.eq"(%bb7d_17, %bb7d_36) : (i64, i64) -> i64
      "braid.setf"(%bb7d_38) {flag = "zf"} : (i64) -> ()
      %bb7d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb7d_40 = "braid.and"(%bb7d_17, %bb7d_39) : (i64, i64) -> i64
      "braid.setf"(%bb7d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb7d_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x401080
      %bb80_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb80_0 = "braid.zext"(%bb80_1) {bits = 32 : i64} : (i64) -> i64
      %bb80_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb80_10 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb80_8 = "braid.add"(%bb80_9, %bb80_10) : (i64, i64) -> i64
      "braid.store"(%bb80_8, %bb80_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb83] : () -> ()
    ^bb83:  // 0x401083
      %bb83_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb83_0 = "braid.zext"(%bb83_1) {bits = 32 : i64} : (i64) -> i64
      %bb83_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb83_10 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb83_8 = "braid.add"(%bb83_9, %bb83_10) : (i64, i64) -> i64
      "braid.store"(%bb83_8, %bb83_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb87] : () -> ()
    ^bb87:  // 0x401087
      %bb87_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb87_0 = "braid.zext"(%bb87_1) {bits = 32 : i64} : (i64) -> i64
      %bb87_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb87_10 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb87_8 = "braid.add"(%bb87_9, %bb87_10) : (i64, i64) -> i64
      "braid.store"(%bb87_8, %bb87_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb8a] : () -> ()
    ^bb8a:  // 0x40108a
      %bb8a_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb8a_0 = "braid.zext"(%bb8a_1) {bits = 32 : i64} : (i64) -> i64
      %bb8a_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb8a_10 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb8a_8 = "braid.add"(%bb8a_9, %bb8a_10) : (i64, i64) -> i64
      "braid.store"(%bb8a_8, %bb8a_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb8d] : () -> ()
    ^bb8d:  // 0x40108d
      %bb8d_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb8d_0 = "braid.zext"(%bb8d_1) {bits = 32 : i64} : (i64) -> i64
      %bb8d_8 = "braid.get"() {reg = "rdi"} : () -> i64
      "braid.store"(%bb8d_8, %bb8d_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x401090
      %bb90_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb90_1 = "braid.load"(%bb90_0) {bytes = 8 : i64} : (i64) -> i64
      %bb90_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb90_3 = "braid.add"(%bb90_0, %bb90_2) : (i64, i64) -> i64
      "braid.set"(%bb90_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb90_1) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb91] : () -> ()
    ^bb91:  // 0x401091
      %bb91_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb91_1 = "braid.load"(%bb91_0) {bytes = 8 : i64} : (i64) -> i64
      %bb91_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb91_3 = "braid.add"(%bb91_0, %bb91_2) : (i64, i64) -> i64
      "braid.set"(%bb91_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb91_1) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb92] : () -> ()
    ^bb92:  // 0x401092
      %bb92_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb92_1 = "braid.load"(%bb92_0) {bytes = 8 : i64} : (i64) -> i64
      %bb92_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb92_3 = "braid.add"(%bb92_0, %bb92_2) : (i64, i64) -> i64
      "braid.set"(%bb92_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb92_1) : (i64) -> ()
    ^bb93:  // 0x401093
      "braid_cf.br"()[^ext4010a0] : () -> ()
    ^ext4010a0:
      "braid_cf.tail"() {target = 4198560 : i64} : () -> ()
  }) {sym_name = "sha256_round", entry = 4198400 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x4010a0
      %bb0_0 = "braid.const"() {value = 16 : i64} : () -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb5] : () -> ()
    ^bb5:  // 0x4010a5
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x4010b0
      %bb10_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb10_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb10_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb10_5 = "braid.mul"(%bb10_3, %bb10_4) : (i64, i64) -> i64
      %bb10_6 = "braid.add"(%bb10_2, %bb10_5) : (i64, i64) -> i64
      %bb10_7 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb10_1 = "braid.add"(%bb10_6, %bb10_7) : (i64, i64) -> i64
      %bb10_0 = "braid.load"(%bb10_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb10_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x4010b4
      %bb14_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb14_0 = "braid.zext"(%bb14_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb14_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb16] : () -> ()
    ^bb16:  // 0x4010b6
      %bb16_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb16_0 = "braid.zext"(%bb16_1) {bits = 32 : i64} : (i64) -> i64
      %bb16_12 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb16_13 = "braid.shl"(%bb16_0, %bb16_12) : (i64, i64) -> i64
      %bb16_14 = "braid.const"() {value = 17 : i64} : () -> i64
      %bb16_15 = "braid.lshr"(%bb16_0, %bb16_14) : (i64, i64) -> i64
      %bb16_16 = "braid.or"(%bb16_13, %bb16_15) : (i64, i64) -> i64
      %bb16_17 = "braid.zext"(%bb16_16) {bits = 32 : i64} : (i64) -> i64
      %bb16_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb16_19 = "braid.and"(%bb16_17, %bb16_18) : (i64, i64) -> i64
      "braid.setf"(%bb16_19) {flag = "cf"} : (i64) -> ()
      %bb16_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb16_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb16_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb19] : () -> ()
    ^bb19:  // 0x4010b9
      %bb19_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb19_0 = "braid.zext"(%bb19_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb19_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb1b] : () -> ()
    ^bb1b:  // 0x4010bb
      %bb1b_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1b_0 = "braid.zext"(%bb1b_1) {bits = 32 : i64} : (i64) -> i64
      %bb1b_12 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb1b_13 = "braid.shl"(%bb1b_0, %bb1b_12) : (i64, i64) -> i64
      %bb1b_14 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb1b_15 = "braid.lshr"(%bb1b_0, %bb1b_14) : (i64, i64) -> i64
      %bb1b_16 = "braid.or"(%bb1b_13, %bb1b_15) : (i64, i64) -> i64
      %bb1b_17 = "braid.zext"(%bb1b_16) {bits = 32 : i64} : (i64) -> i64
      %bb1b_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1b_19 = "braid.and"(%bb1b_17, %bb1b_18) : (i64, i64) -> i64
      "braid.setf"(%bb1b_19) {flag = "cf"} : (i64) -> ()
      %bb1b_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1b_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb1b_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb1e] : () -> ()
    ^bb1e:  // 0x4010be
      %bb1e_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1e_0 = "braid.zext"(%bb1e_1) {bits = 32 : i64} : (i64) -> i64
      %bb1e_9 = "braid.get"() {reg = "rdx"} : () -> i64
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
      "braid.set"(%bb1e_16) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x4010c0
      %bb20_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb20_0 = "braid.zext"(%bb20_1) {bits = 32 : i64} : (i64) -> i64
      %bb20_8 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb20_9 = "braid.lshr"(%bb20_0, %bb20_8) : (i64, i64) -> i64
      %bb20_11 = "braid.const"() {value = 9 : i64} : () -> i64
      %bb20_12 = "braid.lshr"(%bb20_0, %bb20_11) : (i64, i64) -> i64
      %bb20_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb20_14 = "braid.and"(%bb20_12, %bb20_13) : (i64, i64) -> i64
      "braid.setf"(%bb20_14) {flag = "cf"} : (i64) -> ()
      %bb20_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb20_17) {flag = "of"} : (i64) -> ()
      %bb20_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb20_24) {flag = "af"} : (i64) -> ()
      %bb20_32 = "braid.zext"(%bb20_9) {bits = 8 : i64} : (i64) -> i64
      %bb20_33 = "braid.popcnt"(%bb20_32) : (i64) -> i64
      %bb20_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb20_35 = "braid.and"(%bb20_33, %bb20_34) : (i64, i64) -> i64
      %bb20_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_37 = "braid.eq"(%bb20_35, %bb20_36) : (i64, i64) -> i64
      "braid.setf"(%bb20_37) {flag = "pf"} : (i64) -> ()
      %bb20_38 = "braid.eq"(%bb20_9, %bb20_36) : (i64, i64) -> i64
      "braid.setf"(%bb20_38) {flag = "zf"} : (i64) -> ()
      %bb20_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb20_40 = "braid.and"(%bb20_9, %bb20_39) : (i64, i64) -> i64
      "braid.setf"(%bb20_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb20_9) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb23] : () -> ()
    ^bb23:  // 0x4010c3
      %bb23_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb23_0 = "braid.zext"(%bb23_1) {bits = 32 : i64} : (i64) -> i64
      %bb23_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb23_8 = "braid.zext"(%bb23_9) {bits = 32 : i64} : (i64) -> i64
      %bb23_16 = "braid.xor"(%bb23_0, %bb23_8) : (i64, i64) -> i64
      %bb23_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb23_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb23_17) {flag = "of"} : (i64) -> ()
      %bb23_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb23_24) {flag = "af"} : (i64) -> ()
      %bb23_32 = "braid.zext"(%bb23_16) {bits = 8 : i64} : (i64) -> i64
      %bb23_33 = "braid.popcnt"(%bb23_32) : (i64) -> i64
      %bb23_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb23_35 = "braid.and"(%bb23_33, %bb23_34) : (i64, i64) -> i64
      %bb23_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb23_37 = "braid.eq"(%bb23_35, %bb23_36) : (i64, i64) -> i64
      "braid.setf"(%bb23_37) {flag = "pf"} : (i64) -> ()
      %bb23_38 = "braid.eq"(%bb23_16, %bb23_36) : (i64, i64) -> i64
      "braid.setf"(%bb23_38) {flag = "zf"} : (i64) -> ()
      %bb23_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb23_40 = "braid.and"(%bb23_16, %bb23_39) : (i64, i64) -> i64
      "braid.setf"(%bb23_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb23_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb25] : () -> ()
    ^bb25:  // 0x4010c5
      %bb25_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb25_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb25_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb25_5 = "braid.mul"(%bb25_3, %bb25_4) : (i64, i64) -> i64
      %bb25_6 = "braid.add"(%bb25_2, %bb25_5) : (i64, i64) -> i64
      %bb25_7 = "braid.const"() {value = -28 : i64} : () -> i64
      %bb25_1 = "braid.add"(%bb25_6, %bb25_7) : (i64, i64) -> i64
      %bb25_0 = "braid.load"(%bb25_1) {bytes = 4 : i64} : (i64) -> i64
      %bb25_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb25_8 = "braid.zext"(%bb25_9) {bits = 32 : i64} : (i64) -> i64
      %bb25_16 = "braid.add"(%bb25_0, %bb25_8) : (i64, i64) -> i64
      %bb25_17 = "braid.zext"(%bb25_16) {bits = 32 : i64} : (i64) -> i64
      %bb25_18 = "braid.ult"(%bb25_17, %bb25_0) : (i64, i64) -> i64
      "braid.setf"(%bb25_18) {flag = "cf"} : (i64) -> ()
      %bb25_19 = "braid.xor"(%bb25_0, %bb25_17) : (i64, i64) -> i64
      %bb25_20 = "braid.xor"(%bb25_8, %bb25_17) : (i64, i64) -> i64
      %bb25_21 = "braid.and"(%bb25_19, %bb25_20) : (i64, i64) -> i64
      %bb25_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb25_23 = "braid.and"(%bb25_21, %bb25_22) : (i64, i64) -> i64
      "braid.setf"(%bb25_23) {flag = "of"} : (i64) -> ()
      %bb25_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb25_24) {flag = "af"} : (i64) -> ()
      %bb25_32 = "braid.zext"(%bb25_17) {bits = 8 : i64} : (i64) -> i64
      %bb25_33 = "braid.popcnt"(%bb25_32) : (i64) -> i64
      %bb25_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb25_35 = "braid.and"(%bb25_33, %bb25_34) : (i64, i64) -> i64
      %bb25_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb25_37 = "braid.eq"(%bb25_35, %bb25_36) : (i64, i64) -> i64
      "braid.setf"(%bb25_37) {flag = "pf"} : (i64) -> ()
      %bb25_38 = "braid.eq"(%bb25_17, %bb25_36) : (i64, i64) -> i64
      "braid.setf"(%bb25_38) {flag = "zf"} : (i64) -> ()
      %bb25_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb25_40 = "braid.and"(%bb25_17, %bb25_39) : (i64, i64) -> i64
      "braid.setf"(%bb25_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb25_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb29] : () -> ()
    ^bb29:  // 0x4010c9
      %bb29_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb29_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb29_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb29_5 = "braid.mul"(%bb29_3, %bb29_4) : (i64, i64) -> i64
      %bb29_6 = "braid.add"(%bb29_2, %bb29_5) : (i64, i64) -> i64
      %bb29_7 = "braid.const"() {value = -60 : i64} : () -> i64
      %bb29_1 = "braid.add"(%bb29_6, %bb29_7) : (i64, i64) -> i64
      %bb29_0 = "braid.load"(%bb29_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb29_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb2d] : () -> ()
    ^bb2d:  // 0x4010cd
      %bb2d_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb2d_0 = "braid.zext"(%bb2d_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb2d_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb2f] : () -> ()
    ^bb2f:  // 0x4010cf
      %bb2f_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb2f_0 = "braid.zext"(%bb2f_1) {bits = 32 : i64} : (i64) -> i64
      %bb2f_12 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb2f_13 = "braid.shl"(%bb2f_0, %bb2f_12) : (i64, i64) -> i64
      %bb2f_14 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb2f_15 = "braid.lshr"(%bb2f_0, %bb2f_14) : (i64, i64) -> i64
      %bb2f_16 = "braid.or"(%bb2f_13, %bb2f_15) : (i64, i64) -> i64
      %bb2f_17 = "braid.zext"(%bb2f_16) {bits = 32 : i64} : (i64) -> i64
      %bb2f_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2f_19 = "braid.and"(%bb2f_17, %bb2f_18) : (i64, i64) -> i64
      "braid.setf"(%bb2f_19) {flag = "cf"} : (i64) -> ()
      %bb2f_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb2f_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb2f_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb32] : () -> ()
    ^bb32:  // 0x4010d2
      %bb32_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb32_0 = "braid.zext"(%bb32_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb32_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb35] : () -> ()
    ^bb35:  // 0x4010d5
      %bb35_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb35_0 = "braid.zext"(%bb35_1) {bits = 32 : i64} : (i64) -> i64
      %bb35_12 = "braid.const"() {value = 14 : i64} : () -> i64
      %bb35_13 = "braid.shl"(%bb35_0, %bb35_12) : (i64, i64) -> i64
      %bb35_14 = "braid.const"() {value = 18 : i64} : () -> i64
      %bb35_15 = "braid.lshr"(%bb35_0, %bb35_14) : (i64, i64) -> i64
      %bb35_16 = "braid.or"(%bb35_13, %bb35_15) : (i64, i64) -> i64
      %bb35_17 = "braid.zext"(%bb35_16) {bits = 32 : i64} : (i64) -> i64
      %bb35_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb35_19 = "braid.and"(%bb35_17, %bb35_18) : (i64, i64) -> i64
      "braid.setf"(%bb35_19) {flag = "cf"} : (i64) -> ()
      %bb35_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb35_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb35_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb39] : () -> ()
    ^bb39:  // 0x4010d9
      %bb39_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb39_0 = "braid.zext"(%bb39_1) {bits = 32 : i64} : (i64) -> i64
      %bb39_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb39_8 = "braid.zext"(%bb39_9) {bits = 32 : i64} : (i64) -> i64
      %bb39_16 = "braid.xor"(%bb39_0, %bb39_8) : (i64, i64) -> i64
      %bb39_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb39_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb39_17) {flag = "of"} : (i64) -> ()
      %bb39_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb39_24) {flag = "af"} : (i64) -> ()
      %bb39_32 = "braid.zext"(%bb39_16) {bits = 8 : i64} : (i64) -> i64
      %bb39_33 = "braid.popcnt"(%bb39_32) : (i64) -> i64
      %bb39_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb39_35 = "braid.and"(%bb39_33, %bb39_34) : (i64, i64) -> i64
      %bb39_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb39_37 = "braid.eq"(%bb39_35, %bb39_36) : (i64, i64) -> i64
      "braid.setf"(%bb39_37) {flag = "pf"} : (i64) -> ()
      %bb39_38 = "braid.eq"(%bb39_16, %bb39_36) : (i64, i64) -> i64
      "braid.setf"(%bb39_38) {flag = "zf"} : (i64) -> ()
      %bb39_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb39_40 = "braid.and"(%bb39_16, %bb39_39) : (i64, i64) -> i64
      "braid.setf"(%bb39_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb39_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x4010dc
      %bb3c_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb3c_0 = "braid.zext"(%bb3c_1) {bits = 32 : i64} : (i64) -> i64
      %bb3c_8 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb3c_9 = "braid.lshr"(%bb3c_0, %bb3c_8) : (i64, i64) -> i64
      %bb3c_11 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb3c_12 = "braid.lshr"(%bb3c_0, %bb3c_11) : (i64, i64) -> i64
      %bb3c_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3c_14 = "braid.and"(%bb3c_12, %bb3c_13) : (i64, i64) -> i64
      "braid.setf"(%bb3c_14) {flag = "cf"} : (i64) -> ()
      %bb3c_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb3c_17) {flag = "of"} : (i64) -> ()
      %bb3c_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb3c_24) {flag = "af"} : (i64) -> ()
      %bb3c_32 = "braid.zext"(%bb3c_9) {bits = 8 : i64} : (i64) -> i64
      %bb3c_33 = "braid.popcnt"(%bb3c_32) : (i64) -> i64
      %bb3c_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3c_35 = "braid.and"(%bb3c_33, %bb3c_34) : (i64, i64) -> i64
      %bb3c_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3c_37 = "braid.eq"(%bb3c_35, %bb3c_36) : (i64, i64) -> i64
      "braid.setf"(%bb3c_37) {flag = "pf"} : (i64) -> ()
      %bb3c_38 = "braid.eq"(%bb3c_9, %bb3c_36) : (i64, i64) -> i64
      "braid.setf"(%bb3c_38) {flag = "zf"} : (i64) -> ()
      %bb3c_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb3c_40 = "braid.and"(%bb3c_9, %bb3c_39) : (i64, i64) -> i64
      "braid.setf"(%bb3c_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb3c_9) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb3f] : () -> ()
    ^bb3f:  // 0x4010df
      %bb3f_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb3f_0 = "braid.zext"(%bb3f_1) {bits = 32 : i64} : (i64) -> i64
      %bb3f_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bb3f_8 = "braid.zext"(%bb3f_9) {bits = 32 : i64} : (i64) -> i64
      %bb3f_16 = "braid.xor"(%bb3f_0, %bb3f_8) : (i64, i64) -> i64
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
      %bb3f_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb3f_40 = "braid.and"(%bb3f_16, %bb3f_39) : (i64, i64) -> i64
      "braid.setf"(%bb3f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb3f_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb42] : () -> ()
    ^bb42:  // 0x4010e2
      %bb42_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb42_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb42_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb42_5 = "braid.mul"(%bb42_3, %bb42_4) : (i64, i64) -> i64
      %bb42_6 = "braid.add"(%bb42_2, %bb42_5) : (i64, i64) -> i64
      %bb42_7 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb42_1 = "braid.add"(%bb42_6, %bb42_7) : (i64, i64) -> i64
      %bb42_0 = "braid.load"(%bb42_1) {bytes = 4 : i64} : (i64) -> i64
      %bb42_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb42_8 = "braid.zext"(%bb42_9) {bits = 32 : i64} : (i64) -> i64
      %bb42_16 = "braid.add"(%bb42_0, %bb42_8) : (i64, i64) -> i64
      %bb42_17 = "braid.zext"(%bb42_16) {bits = 32 : i64} : (i64) -> i64
      %bb42_18 = "braid.ult"(%bb42_17, %bb42_0) : (i64, i64) -> i64
      "braid.setf"(%bb42_18) {flag = "cf"} : (i64) -> ()
      %bb42_19 = "braid.xor"(%bb42_0, %bb42_17) : (i64, i64) -> i64
      %bb42_20 = "braid.xor"(%bb42_8, %bb42_17) : (i64, i64) -> i64
      %bb42_21 = "braid.and"(%bb42_19, %bb42_20) : (i64, i64) -> i64
      %bb42_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb42_23 = "braid.and"(%bb42_21, %bb42_22) : (i64, i64) -> i64
      "braid.setf"(%bb42_23) {flag = "of"} : (i64) -> ()
      %bb42_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb42_24) {flag = "af"} : (i64) -> ()
      %bb42_32 = "braid.zext"(%bb42_17) {bits = 8 : i64} : (i64) -> i64
      %bb42_33 = "braid.popcnt"(%bb42_32) : (i64) -> i64
      %bb42_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb42_35 = "braid.and"(%bb42_33, %bb42_34) : (i64, i64) -> i64
      %bb42_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb42_37 = "braid.eq"(%bb42_35, %bb42_36) : (i64, i64) -> i64
      "braid.setf"(%bb42_37) {flag = "pf"} : (i64) -> ()
      %bb42_38 = "braid.eq"(%bb42_17, %bb42_36) : (i64, i64) -> i64
      "braid.setf"(%bb42_38) {flag = "zf"} : (i64) -> ()
      %bb42_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb42_40 = "braid.and"(%bb42_17, %bb42_39) : (i64, i64) -> i64
      "braid.setf"(%bb42_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb42_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb46] : () -> ()
    ^bb46:  // 0x4010e6
      %bb46_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb46_0 = "braid.zext"(%bb46_1) {bits = 32 : i64} : (i64) -> i64
      %bb46_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb46_8 = "braid.zext"(%bb46_9) {bits = 32 : i64} : (i64) -> i64
      %bb46_16 = "braid.add"(%bb46_0, %bb46_8) : (i64, i64) -> i64
      %bb46_17 = "braid.zext"(%bb46_16) {bits = 32 : i64} : (i64) -> i64
      %bb46_18 = "braid.ult"(%bb46_17, %bb46_0) : (i64, i64) -> i64
      "braid.setf"(%bb46_18) {flag = "cf"} : (i64) -> ()
      %bb46_19 = "braid.xor"(%bb46_0, %bb46_17) : (i64, i64) -> i64
      %bb46_20 = "braid.xor"(%bb46_8, %bb46_17) : (i64, i64) -> i64
      %bb46_21 = "braid.and"(%bb46_19, %bb46_20) : (i64, i64) -> i64
      %bb46_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb46_23 = "braid.and"(%bb46_21, %bb46_22) : (i64, i64) -> i64
      "braid.setf"(%bb46_23) {flag = "of"} : (i64) -> ()
      %bb46_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb46_24) {flag = "af"} : (i64) -> ()
      %bb46_32 = "braid.zext"(%bb46_17) {bits = 8 : i64} : (i64) -> i64
      %bb46_33 = "braid.popcnt"(%bb46_32) : (i64) -> i64
      %bb46_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb46_35 = "braid.and"(%bb46_33, %bb46_34) : (i64, i64) -> i64
      %bb46_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb46_37 = "braid.eq"(%bb46_35, %bb46_36) : (i64, i64) -> i64
      "braid.setf"(%bb46_37) {flag = "pf"} : (i64) -> ()
      %bb46_38 = "braid.eq"(%bb46_17, %bb46_36) : (i64, i64) -> i64
      "braid.setf"(%bb46_38) {flag = "zf"} : (i64) -> ()
      %bb46_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb46_40 = "braid.and"(%bb46_17, %bb46_39) : (i64, i64) -> i64
      "braid.setf"(%bb46_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb46_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x4010e8
      %bb48_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb48_0 = "braid.zext"(%bb48_1) {bits = 32 : i64} : (i64) -> i64
      %bb48_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb48_10 = "braid.get"() {reg = "rax"} : () -> i64
      %bb48_11 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb48_12 = "braid.mul"(%bb48_10, %bb48_11) : (i64, i64) -> i64
      %bb48_13 = "braid.add"(%bb48_9, %bb48_12) : (i64, i64) -> i64
      %bb48_14 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb48_8 = "braid.add"(%bb48_13, %bb48_14) : (i64, i64) -> i64
      "braid.store"(%bb48_8, %bb48_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb4b] : () -> ()
    ^bb4b:  // 0x4010eb
      %bb4b_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb4b_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4b_16 = "braid.add"(%bb4b_0, %bb4b_8) : (i64, i64) -> i64
      %bb4b_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb4b_20 = "braid.eq"(%bb4b_16, %bb4b_19) : (i64, i64) -> i64
      "braid.setf"(%bb4b_20) {flag = "of"} : (i64) -> ()
      %bb4b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb4b_24) {flag = "af"} : (i64) -> ()
      %bb4b_32 = "braid.zext"(%bb4b_16) {bits = 8 : i64} : (i64) -> i64
      %bb4b_33 = "braid.popcnt"(%bb4b_32) : (i64) -> i64
      %bb4b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4b_35 = "braid.and"(%bb4b_33, %bb4b_34) : (i64, i64) -> i64
      %bb4b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4b_37 = "braid.eq"(%bb4b_35, %bb4b_36) : (i64, i64) -> i64
      "braid.setf"(%bb4b_37) {flag = "pf"} : (i64) -> ()
      %bb4b_38 = "braid.eq"(%bb4b_16, %bb4b_36) : (i64, i64) -> i64
      "braid.setf"(%bb4b_38) {flag = "zf"} : (i64) -> ()
      %bb4b_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb4b_40 = "braid.and"(%bb4b_16, %bb4b_39) : (i64, i64) -> i64
      "braid.setf"(%bb4b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb4b_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb4e] : () -> ()
    ^bb4e:  // 0x4010ee
      %bb4e_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb4e_8 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb4e_16 = "braid.sub"(%bb4e_0, %bb4e_8) : (i64, i64) -> i64
      %bb4e_18 = "braid.ult"(%bb4e_0, %bb4e_8) : (i64, i64) -> i64
      "braid.setf"(%bb4e_18) {flag = "cf"} : (i64) -> ()
      %bb4e_19 = "braid.xor"(%bb4e_0, %bb4e_8) : (i64, i64) -> i64
      %bb4e_20 = "braid.xor"(%bb4e_0, %bb4e_16) : (i64, i64) -> i64
      %bb4e_21 = "braid.and"(%bb4e_19, %bb4e_20) : (i64, i64) -> i64
      %bb4e_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb4e_23 = "braid.and"(%bb4e_21, %bb4e_22) : (i64, i64) -> i64
      "braid.setf"(%bb4e_23) {flag = "of"} : (i64) -> ()
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
      %bb4e_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb4e_40 = "braid.and"(%bb4e_16, %bb4e_39) : (i64, i64) -> i64
      "braid.setf"(%bb4e_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb52] : () -> ()
    ^bb52:  // 0x4010f2
      %bb52_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb52_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb52_0 = "braid.eq"(%bb52_1, %bb52_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb52_0)[^bb10, ^bb54] : (i64) -> ()
    ^bb54:  // 0x4010f4
      %bb54_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb54_1 = "braid.load"(%bb54_0) {bytes = 8 : i64} : (i64) -> i64
      %bb54_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb54_3 = "braid.add"(%bb54_0, %bb54_2) : (i64, i64) -> i64
      "braid.set"(%bb54_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb54_1) : (i64) -> ()
    ^bb55:  // 0x4010f5
      "braid_cf.br"()[^ext401100] : () -> ()
    ^ext401100:
      "braid_cf.tail"() {target = 4198656 : i64} : () -> ()
  }) {sym_name = "sha256_schedule", entry = 4198560 : i64} : () -> ()
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
      %bb5_0 = "braid.get"() {reg = "r13"} : () -> i64
      %bb5_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb5_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb5_10 = "braid.sub"(%bb5_8, %bb5_9) : (i64, i64) -> i64
      "braid.set"(%bb5_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb5_10, %bb5_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb7] : () -> ()
    ^bb7:  // 0x401107
      %bb7_0 = "braid.get"() {reg = "r12"} : () -> i64
      %bb7_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb7_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb7_10 = "braid.sub"(%bb7_8, %bb7_9) : (i64, i64) -> i64
      "braid.set"(%bb7_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb7_10, %bb7_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb9] : () -> ()
    ^bb9:  // 0x401109
      %bb9_0 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb9_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb9_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb9_10 = "braid.sub"(%bb9_8, %bb9_9) : (i64, i64) -> i64
      "braid.set"(%bb9_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb9_10, %bb9_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bba] : () -> ()
    ^bba:  // 0x40110a
      %bba_0 = "braid.const"() {value = 168 : i64} : () -> i64
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
    ^bb11:  // 0x401111
      %bb11_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb11_0 = "braid.load"(%bb11_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb11_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb13] : () -> ()
    ^bb13:  // 0x401113
      %bb13_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb13_0 = "braid.zext"(%bb13_1) {bits = 32 : i64} : (i64) -> i64
      %bb13_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb13_10 = "braid.const"() {value = -96 : i64} : () -> i64
      %bb13_8 = "braid.add"(%bb13_9, %bb13_10) : (i64, i64) -> i64
      "braid.store"(%bb13_8, %bb13_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb17] : () -> ()
    ^bb17:  // 0x401117
      %bb17_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb17_3 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb17_1 = "braid.add"(%bb17_2, %bb17_3) : (i64, i64) -> i64
      %bb17_0 = "braid.load"(%bb17_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb17_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1a] : () -> ()
    ^bb1a:  // 0x40111a
      %bb1a_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1a_0 = "braid.zext"(%bb1a_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1a_10 = "braid.const"() {value = -92 : i64} : () -> i64
      %bb1a_8 = "braid.add"(%bb1a_9, %bb1a_10) : (i64, i64) -> i64
      "braid.store"(%bb1a_8, %bb1a_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1e] : () -> ()
    ^bb1e:  // 0x40111e
      %bb1e_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1e_3 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1e_1 = "braid.add"(%bb1e_2, %bb1e_3) : (i64, i64) -> i64
      %bb1e_0 = "braid.load"(%bb1e_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1e_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb21] : () -> ()
    ^bb21:  // 0x401121
      %bb21_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb21_0 = "braid.zext"(%bb21_1) {bits = 32 : i64} : (i64) -> i64
      %bb21_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb21_10 = "braid.const"() {value = -88 : i64} : () -> i64
      %bb21_8 = "braid.add"(%bb21_9, %bb21_10) : (i64, i64) -> i64
      "braid.store"(%bb21_8, %bb21_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb25] : () -> ()
    ^bb25:  // 0x401125
      %bb25_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb25_3 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb25_1 = "braid.add"(%bb25_2, %bb25_3) : (i64, i64) -> i64
      %bb25_0 = "braid.load"(%bb25_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb25_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x401128
      %bb28_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb28_0 = "braid.zext"(%bb28_1) {bits = 32 : i64} : (i64) -> i64
      %bb28_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb28_10 = "braid.const"() {value = -84 : i64} : () -> i64
      %bb28_8 = "braid.add"(%bb28_9, %bb28_10) : (i64, i64) -> i64
      "braid.store"(%bb28_8, %bb28_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x40112c
      %bb2c_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb2c_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb2c_1 = "braid.add"(%bb2c_2, %bb2c_3) : (i64, i64) -> i64
      %bb2c_0 = "braid.load"(%bb2c_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb2c_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb2f] : () -> ()
    ^bb2f:  // 0x40112f
      %bb2f_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb2f_0 = "braid.zext"(%bb2f_1) {bits = 32 : i64} : (i64) -> i64
      %bb2f_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb2f_10 = "braid.const"() {value = -80 : i64} : () -> i64
      %bb2f_8 = "braid.add"(%bb2f_9, %bb2f_10) : (i64, i64) -> i64
      "braid.store"(%bb2f_8, %bb2f_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb33] : () -> ()
    ^bb33:  // 0x401133
      %bb33_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb33_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb33_1 = "braid.add"(%bb33_2, %bb33_3) : (i64, i64) -> i64
      %bb33_0 = "braid.load"(%bb33_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb33_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb36] : () -> ()
    ^bb36:  // 0x401136
      %bb36_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb36_0 = "braid.zext"(%bb36_1) {bits = 32 : i64} : (i64) -> i64
      %bb36_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb36_10 = "braid.const"() {value = -76 : i64} : () -> i64
      %bb36_8 = "braid.add"(%bb36_9, %bb36_10) : (i64, i64) -> i64
      "braid.store"(%bb36_8, %bb36_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb3a] : () -> ()
    ^bb3a:  // 0x40113a
      %bb3a_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb3a_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb3a_1 = "braid.add"(%bb3a_2, %bb3a_3) : (i64, i64) -> i64
      %bb3a_0 = "braid.load"(%bb3a_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb3a_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb3d] : () -> ()
    ^bb3d:  // 0x40113d
      %bb3d_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb3d_0 = "braid.zext"(%bb3d_1) {bits = 32 : i64} : (i64) -> i64
      %bb3d_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb3d_10 = "braid.const"() {value = -72 : i64} : () -> i64
      %bb3d_8 = "braid.add"(%bb3d_9, %bb3d_10) : (i64, i64) -> i64
      "braid.store"(%bb3d_8, %bb3d_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb41] : () -> ()
    ^bb41:  // 0x401141
      %bb41_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb41_3 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb41_1 = "braid.add"(%bb41_2, %bb41_3) : (i64, i64) -> i64
      %bb41_0 = "braid.load"(%bb41_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb41_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x401144
      %bb44_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb44_0 = "braid.zext"(%bb44_1) {bits = 32 : i64} : (i64) -> i64
      %bb44_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb44_10 = "braid.const"() {value = -68 : i64} : () -> i64
      %bb44_8 = "braid.add"(%bb44_9, %bb44_10) : (i64, i64) -> i64
      "braid.store"(%bb44_8, %bb44_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x401148
      %bb48_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb48_3 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb48_1 = "braid.add"(%bb48_2, %bb48_3) : (i64, i64) -> i64
      %bb48_0 = "braid.load"(%bb48_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb48_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb4b] : () -> ()
    ^bb4b:  // 0x40114b
      %bb4b_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb4b_0 = "braid.zext"(%bb4b_1) {bits = 32 : i64} : (i64) -> i64
      %bb4b_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb4b_10 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb4b_8 = "braid.add"(%bb4b_9, %bb4b_10) : (i64, i64) -> i64
      "braid.store"(%bb4b_8, %bb4b_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb4f] : () -> ()
    ^bb4f:  // 0x40114f
      %bb4f_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb4f_3 = "braid.const"() {value = 36 : i64} : () -> i64
      %bb4f_1 = "braid.add"(%bb4f_2, %bb4f_3) : (i64, i64) -> i64
      %bb4f_0 = "braid.load"(%bb4f_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb4f_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb52] : () -> ()
    ^bb52:  // 0x401152
      %bb52_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb52_0 = "braid.zext"(%bb52_1) {bits = 32 : i64} : (i64) -> i64
      %bb52_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb52_10 = "braid.const"() {value = -60 : i64} : () -> i64
      %bb52_8 = "braid.add"(%bb52_9, %bb52_10) : (i64, i64) -> i64
      "braid.store"(%bb52_8, %bb52_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb56] : () -> ()
    ^bb56:  // 0x401156
      %bb56_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb56_3 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb56_1 = "braid.add"(%bb56_2, %bb56_3) : (i64, i64) -> i64
      %bb56_0 = "braid.load"(%bb56_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb56_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb59] : () -> ()
    ^bb59:  // 0x401159
      %bb59_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb59_0 = "braid.zext"(%bb59_1) {bits = 32 : i64} : (i64) -> i64
      %bb59_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb59_10 = "braid.const"() {value = -56 : i64} : () -> i64
      %bb59_8 = "braid.add"(%bb59_9, %bb59_10) : (i64, i64) -> i64
      "braid.store"(%bb59_8, %bb59_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb5d] : () -> ()
    ^bb5d:  // 0x40115d
      %bb5d_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb5d_3 = "braid.const"() {value = 44 : i64} : () -> i64
      %bb5d_1 = "braid.add"(%bb5d_2, %bb5d_3) : (i64, i64) -> i64
      %bb5d_0 = "braid.load"(%bb5d_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb5d_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x401160
      %bb60_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb60_0 = "braid.zext"(%bb60_1) {bits = 32 : i64} : (i64) -> i64
      %bb60_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb60_10 = "braid.const"() {value = -52 : i64} : () -> i64
      %bb60_8 = "braid.add"(%bb60_9, %bb60_10) : (i64, i64) -> i64
      "braid.store"(%bb60_8, %bb60_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x401164
      %bb64_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb64_3 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb64_1 = "braid.add"(%bb64_2, %bb64_3) : (i64, i64) -> i64
      %bb64_0 = "braid.load"(%bb64_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb64_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb67] : () -> ()
    ^bb67:  // 0x401167
      %bb67_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb67_0 = "braid.zext"(%bb67_1) {bits = 32 : i64} : (i64) -> i64
      %bb67_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb67_10 = "braid.const"() {value = -48 : i64} : () -> i64
      %bb67_8 = "braid.add"(%bb67_9, %bb67_10) : (i64, i64) -> i64
      "braid.store"(%bb67_8, %bb67_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb6b] : () -> ()
    ^bb6b:  // 0x40116b
      %bb6b_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb6b_3 = "braid.const"() {value = 52 : i64} : () -> i64
      %bb6b_1 = "braid.add"(%bb6b_2, %bb6b_3) : (i64, i64) -> i64
      %bb6b_0 = "braid.load"(%bb6b_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb6b_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb6e] : () -> ()
    ^bb6e:  // 0x40116e
      %bb6e_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb6e_0 = "braid.zext"(%bb6e_1) {bits = 32 : i64} : (i64) -> i64
      %bb6e_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb6e_10 = "braid.const"() {value = -44 : i64} : () -> i64
      %bb6e_8 = "braid.add"(%bb6e_9, %bb6e_10) : (i64, i64) -> i64
      "braid.store"(%bb6e_8, %bb6e_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb72] : () -> ()
    ^bb72:  // 0x401172
      %bb72_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb72_3 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb72_1 = "braid.add"(%bb72_2, %bb72_3) : (i64, i64) -> i64
      %bb72_0 = "braid.load"(%bb72_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb72_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb75] : () -> ()
    ^bb75:  // 0x401175
      %bb75_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb75_0 = "braid.zext"(%bb75_1) {bits = 32 : i64} : (i64) -> i64
      %bb75_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb75_10 = "braid.const"() {value = -40 : i64} : () -> i64
      %bb75_8 = "braid.add"(%bb75_9, %bb75_10) : (i64, i64) -> i64
      "braid.store"(%bb75_8, %bb75_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb79] : () -> ()
    ^bb79:  // 0x401179
      %bb79_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb79_3 = "braid.const"() {value = 60 : i64} : () -> i64
      %bb79_1 = "braid.add"(%bb79_2, %bb79_3) : (i64, i64) -> i64
      %bb79_0 = "braid.load"(%bb79_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb79_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x40117c
      %bb7c_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb7c_0 = "braid.zext"(%bb7c_1) {bits = 32 : i64} : (i64) -> i64
      %bb7c_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb7c_10 = "braid.const"() {value = -36 : i64} : () -> i64
      %bb7c_8 = "braid.add"(%bb7c_9, %bb7c_10) : (i64, i64) -> i64
      "braid.store"(%bb7c_8, %bb7c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x401180
      %bb80_0 = "braid.const"() {value = 16 : i64} : () -> i64
      "braid.set"(%bb80_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb85] : () -> ()
    ^bb85:  // 0x401185
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x401190
      %bb90_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb90_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb90_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb90_5 = "braid.mul"(%bb90_3, %bb90_4) : (i64, i64) -> i64
      %bb90_6 = "braid.add"(%bb90_2, %bb90_5) : (i64, i64) -> i64
      %bb90_7 = "braid.const"() {value = -104 : i64} : () -> i64
      %bb90_1 = "braid.add"(%bb90_6, %bb90_7) : (i64, i64) -> i64
      %bb90_0 = "braid.load"(%bb90_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb90_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x401194
      %bb94_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb94_0 = "braid.zext"(%bb94_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb94_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb96] : () -> ()
    ^bb96:  // 0x401196
      %bb96_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb96_0 = "braid.zext"(%bb96_1) {bits = 32 : i64} : (i64) -> i64
      %bb96_12 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb96_13 = "braid.shl"(%bb96_0, %bb96_12) : (i64, i64) -> i64
      %bb96_14 = "braid.const"() {value = 17 : i64} : () -> i64
      %bb96_15 = "braid.lshr"(%bb96_0, %bb96_14) : (i64, i64) -> i64
      %bb96_16 = "braid.or"(%bb96_13, %bb96_15) : (i64, i64) -> i64
      %bb96_17 = "braid.zext"(%bb96_16) {bits = 32 : i64} : (i64) -> i64
      %bb96_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb96_19 = "braid.and"(%bb96_17, %bb96_18) : (i64, i64) -> i64
      "braid.setf"(%bb96_19) {flag = "cf"} : (i64) -> ()
      %bb96_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb96_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb96_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb99] : () -> ()
    ^bb99:  // 0x401199
      %bb99_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb99_0 = "braid.zext"(%bb99_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb99_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb9b] : () -> ()
    ^bb9b:  // 0x40119b
      %bb9b_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb9b_0 = "braid.zext"(%bb9b_1) {bits = 32 : i64} : (i64) -> i64
      %bb9b_12 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb9b_13 = "braid.shl"(%bb9b_0, %bb9b_12) : (i64, i64) -> i64
      %bb9b_14 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb9b_15 = "braid.lshr"(%bb9b_0, %bb9b_14) : (i64, i64) -> i64
      %bb9b_16 = "braid.or"(%bb9b_13, %bb9b_15) : (i64, i64) -> i64
      %bb9b_17 = "braid.zext"(%bb9b_16) {bits = 32 : i64} : (i64) -> i64
      %bb9b_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb9b_19 = "braid.and"(%bb9b_17, %bb9b_18) : (i64, i64) -> i64
      "braid.setf"(%bb9b_19) {flag = "cf"} : (i64) -> ()
      %bb9b_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb9b_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb9b_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb9e] : () -> ()
    ^bb9e:  // 0x40119e
      %bb9e_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb9e_0 = "braid.zext"(%bb9e_1) {bits = 32 : i64} : (i64) -> i64
      %bb9e_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb9e_8 = "braid.zext"(%bb9e_9) {bits = 32 : i64} : (i64) -> i64
      %bb9e_16 = "braid.xor"(%bb9e_0, %bb9e_8) : (i64, i64) -> i64
      %bb9e_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb9e_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb9e_17) {flag = "of"} : (i64) -> ()
      %bb9e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb9e_24) {flag = "af"} : (i64) -> ()
      %bb9e_32 = "braid.zext"(%bb9e_16) {bits = 8 : i64} : (i64) -> i64
      %bb9e_33 = "braid.popcnt"(%bb9e_32) : (i64) -> i64
      %bb9e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb9e_35 = "braid.and"(%bb9e_33, %bb9e_34) : (i64, i64) -> i64
      %bb9e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9e_37 = "braid.eq"(%bb9e_35, %bb9e_36) : (i64, i64) -> i64
      "braid.setf"(%bb9e_37) {flag = "pf"} : (i64) -> ()
      %bb9e_38 = "braid.eq"(%bb9e_16, %bb9e_36) : (i64, i64) -> i64
      "braid.setf"(%bb9e_38) {flag = "zf"} : (i64) -> ()
      %bb9e_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb9e_40 = "braid.and"(%bb9e_16, %bb9e_39) : (i64, i64) -> i64
      "braid.setf"(%bb9e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb9e_16) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x4011a0
      %bba0_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bba0_0 = "braid.zext"(%bba0_1) {bits = 32 : i64} : (i64) -> i64
      %bba0_8 = "braid.const"() {value = 10 : i64} : () -> i64
      %bba0_9 = "braid.lshr"(%bba0_0, %bba0_8) : (i64, i64) -> i64
      %bba0_11 = "braid.const"() {value = 9 : i64} : () -> i64
      %bba0_12 = "braid.lshr"(%bba0_0, %bba0_11) : (i64, i64) -> i64
      %bba0_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bba0_14 = "braid.and"(%bba0_12, %bba0_13) : (i64, i64) -> i64
      "braid.setf"(%bba0_14) {flag = "cf"} : (i64) -> ()
      %bba0_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bba0_17) {flag = "of"} : (i64) -> ()
      %bba0_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bba0_24) {flag = "af"} : (i64) -> ()
      %bba0_32 = "braid.zext"(%bba0_9) {bits = 8 : i64} : (i64) -> i64
      %bba0_33 = "braid.popcnt"(%bba0_32) : (i64) -> i64
      %bba0_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bba0_35 = "braid.and"(%bba0_33, %bba0_34) : (i64, i64) -> i64
      %bba0_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba0_37 = "braid.eq"(%bba0_35, %bba0_36) : (i64, i64) -> i64
      "braid.setf"(%bba0_37) {flag = "pf"} : (i64) -> ()
      %bba0_38 = "braid.eq"(%bba0_9, %bba0_36) : (i64, i64) -> i64
      "braid.setf"(%bba0_38) {flag = "zf"} : (i64) -> ()
      %bba0_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bba0_40 = "braid.and"(%bba0_9, %bba0_39) : (i64, i64) -> i64
      "braid.setf"(%bba0_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bba0_9) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bba3] : () -> ()
    ^bba3:  // 0x4011a3
      %bba3_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bba3_0 = "braid.zext"(%bba3_1) {bits = 32 : i64} : (i64) -> i64
      %bba3_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bba3_8 = "braid.zext"(%bba3_9) {bits = 32 : i64} : (i64) -> i64
      %bba3_16 = "braid.xor"(%bba3_0, %bba3_8) : (i64, i64) -> i64
      %bba3_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bba3_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bba3_17) {flag = "of"} : (i64) -> ()
      %bba3_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bba3_24) {flag = "af"} : (i64) -> ()
      %bba3_32 = "braid.zext"(%bba3_16) {bits = 8 : i64} : (i64) -> i64
      %bba3_33 = "braid.popcnt"(%bba3_32) : (i64) -> i64
      %bba3_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bba3_35 = "braid.and"(%bba3_33, %bba3_34) : (i64, i64) -> i64
      %bba3_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba3_37 = "braid.eq"(%bba3_35, %bba3_36) : (i64, i64) -> i64
      "braid.setf"(%bba3_37) {flag = "pf"} : (i64) -> ()
      %bba3_38 = "braid.eq"(%bba3_16, %bba3_36) : (i64, i64) -> i64
      "braid.setf"(%bba3_38) {flag = "zf"} : (i64) -> ()
      %bba3_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bba3_40 = "braid.and"(%bba3_16, %bba3_39) : (i64, i64) -> i64
      "braid.setf"(%bba3_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bba3_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bba5] : () -> ()
    ^bba5:  // 0x4011a5
      %bba5_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba5_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bba5_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bba5_5 = "braid.mul"(%bba5_3, %bba5_4) : (i64, i64) -> i64
      %bba5_6 = "braid.add"(%bba5_2, %bba5_5) : (i64, i64) -> i64
      %bba5_7 = "braid.const"() {value = -124 : i64} : () -> i64
      %bba5_1 = "braid.add"(%bba5_6, %bba5_7) : (i64, i64) -> i64
      %bba5_0 = "braid.load"(%bba5_1) {bytes = 4 : i64} : (i64) -> i64
      %bba5_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bba5_8 = "braid.zext"(%bba5_9) {bits = 32 : i64} : (i64) -> i64
      %bba5_16 = "braid.add"(%bba5_0, %bba5_8) : (i64, i64) -> i64
      %bba5_17 = "braid.zext"(%bba5_16) {bits = 32 : i64} : (i64) -> i64
      %bba5_18 = "braid.ult"(%bba5_17, %bba5_0) : (i64, i64) -> i64
      "braid.setf"(%bba5_18) {flag = "cf"} : (i64) -> ()
      %bba5_19 = "braid.xor"(%bba5_0, %bba5_17) : (i64, i64) -> i64
      %bba5_20 = "braid.xor"(%bba5_8, %bba5_17) : (i64, i64) -> i64
      %bba5_21 = "braid.and"(%bba5_19, %bba5_20) : (i64, i64) -> i64
      %bba5_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bba5_23 = "braid.and"(%bba5_21, %bba5_22) : (i64, i64) -> i64
      "braid.setf"(%bba5_23) {flag = "of"} : (i64) -> ()
      %bba5_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bba5_24) {flag = "af"} : (i64) -> ()
      %bba5_32 = "braid.zext"(%bba5_17) {bits = 8 : i64} : (i64) -> i64
      %bba5_33 = "braid.popcnt"(%bba5_32) : (i64) -> i64
      %bba5_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bba5_35 = "braid.and"(%bba5_33, %bba5_34) : (i64, i64) -> i64
      %bba5_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba5_37 = "braid.eq"(%bba5_35, %bba5_36) : (i64, i64) -> i64
      "braid.setf"(%bba5_37) {flag = "pf"} : (i64) -> ()
      %bba5_38 = "braid.eq"(%bba5_17, %bba5_36) : (i64, i64) -> i64
      "braid.setf"(%bba5_38) {flag = "zf"} : (i64) -> ()
      %bba5_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bba5_40 = "braid.and"(%bba5_17, %bba5_39) : (i64, i64) -> i64
      "braid.setf"(%bba5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bba5_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bba9] : () -> ()
    ^bba9:  // 0x4011a9
      %bba9_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba9_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bba9_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bba9_5 = "braid.mul"(%bba9_3, %bba9_4) : (i64, i64) -> i64
      %bba9_6 = "braid.add"(%bba9_2, %bba9_5) : (i64, i64) -> i64
      %bba9_7 = "braid.const"() {value = -156 : i64} : () -> i64
      %bba9_1 = "braid.add"(%bba9_6, %bba9_7) : (i64, i64) -> i64
      %bba9_0 = "braid.load"(%bba9_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bba9_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x4011b0
      %bbb0_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbb0_0 = "braid.zext"(%bbb0_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbb0_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bbb2] : () -> ()
    ^bbb2:  // 0x4011b2
      %bbb2_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbb2_0 = "braid.zext"(%bbb2_1) {bits = 32 : i64} : (i64) -> i64
      %bbb2_12 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbb2_13 = "braid.shl"(%bbb2_0, %bbb2_12) : (i64, i64) -> i64
      %bbb2_14 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbb2_15 = "braid.lshr"(%bbb2_0, %bbb2_14) : (i64, i64) -> i64
      %bbb2_16 = "braid.or"(%bbb2_13, %bbb2_15) : (i64, i64) -> i64
      %bbb2_17 = "braid.zext"(%bbb2_16) {bits = 32 : i64} : (i64) -> i64
      %bbb2_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbb2_19 = "braid.and"(%bbb2_17, %bbb2_18) : (i64, i64) -> i64
      "braid.setf"(%bbb2_19) {flag = "cf"} : (i64) -> ()
      %bbb2_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbb2_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbb2_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bbb5] : () -> ()
    ^bbb5:  // 0x4011b5
      %bbb5_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbb5_0 = "braid.zext"(%bbb5_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbb5_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x4011b8
      %bbb8_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbb8_0 = "braid.zext"(%bbb8_1) {bits = 32 : i64} : (i64) -> i64
      %bbb8_12 = "braid.const"() {value = 14 : i64} : () -> i64
      %bbb8_13 = "braid.shl"(%bbb8_0, %bbb8_12) : (i64, i64) -> i64
      %bbb8_14 = "braid.const"() {value = 18 : i64} : () -> i64
      %bbb8_15 = "braid.lshr"(%bbb8_0, %bbb8_14) : (i64, i64) -> i64
      %bbb8_16 = "braid.or"(%bbb8_13, %bbb8_15) : (i64, i64) -> i64
      %bbb8_17 = "braid.zext"(%bbb8_16) {bits = 32 : i64} : (i64) -> i64
      %bbb8_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbb8_19 = "braid.and"(%bbb8_17, %bbb8_18) : (i64, i64) -> i64
      "braid.setf"(%bbb8_19) {flag = "cf"} : (i64) -> ()
      %bbb8_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbb8_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbb8_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x4011bc
      %bbbc_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbbc_0 = "braid.zext"(%bbbc_1) {bits = 32 : i64} : (i64) -> i64
      %bbbc_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbbc_8 = "braid.zext"(%bbbc_9) {bits = 32 : i64} : (i64) -> i64
      %bbbc_16 = "braid.xor"(%bbbc_0, %bbbc_8) : (i64, i64) -> i64
      %bbbc_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbbc_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbbc_17) {flag = "of"} : (i64) -> ()
      %bbbc_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbbc_24) {flag = "af"} : (i64) -> ()
      %bbbc_32 = "braid.zext"(%bbbc_16) {bits = 8 : i64} : (i64) -> i64
      %bbbc_33 = "braid.popcnt"(%bbbc_32) : (i64) -> i64
      %bbbc_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbbc_35 = "braid.and"(%bbbc_33, %bbbc_34) : (i64, i64) -> i64
      %bbbc_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbbc_37 = "braid.eq"(%bbbc_35, %bbbc_36) : (i64, i64) -> i64
      "braid.setf"(%bbbc_37) {flag = "pf"} : (i64) -> ()
      %bbbc_38 = "braid.eq"(%bbbc_16, %bbbc_36) : (i64, i64) -> i64
      "braid.setf"(%bbbc_38) {flag = "zf"} : (i64) -> ()
      %bbbc_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbbc_40 = "braid.and"(%bbbc_16, %bbbc_39) : (i64, i64) -> i64
      "braid.setf"(%bbbc_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbbc_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bbbf] : () -> ()
    ^bbbf:  // 0x4011bf
      %bbbf_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbbf_0 = "braid.zext"(%bbbf_1) {bits = 32 : i64} : (i64) -> i64
      %bbbf_8 = "braid.const"() {value = 3 : i64} : () -> i64
      %bbbf_9 = "braid.lshr"(%bbbf_0, %bbbf_8) : (i64, i64) -> i64
      %bbbf_11 = "braid.const"() {value = 2 : i64} : () -> i64
      %bbbf_12 = "braid.lshr"(%bbbf_0, %bbbf_11) : (i64, i64) -> i64
      %bbbf_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbbf_14 = "braid.and"(%bbbf_12, %bbbf_13) : (i64, i64) -> i64
      "braid.setf"(%bbbf_14) {flag = "cf"} : (i64) -> ()
      %bbbf_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbbf_17) {flag = "of"} : (i64) -> ()
      %bbbf_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbbf_24) {flag = "af"} : (i64) -> ()
      %bbbf_32 = "braid.zext"(%bbbf_9) {bits = 8 : i64} : (i64) -> i64
      %bbbf_33 = "braid.popcnt"(%bbbf_32) : (i64) -> i64
      %bbbf_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbbf_35 = "braid.and"(%bbbf_33, %bbbf_34) : (i64, i64) -> i64
      %bbbf_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbbf_37 = "braid.eq"(%bbbf_35, %bbbf_36) : (i64, i64) -> i64
      "braid.setf"(%bbbf_37) {flag = "pf"} : (i64) -> ()
      %bbbf_38 = "braid.eq"(%bbbf_9, %bbbf_36) : (i64, i64) -> i64
      "braid.setf"(%bbbf_38) {flag = "zf"} : (i64) -> ()
      %bbbf_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbbf_40 = "braid.and"(%bbbf_9, %bbbf_39) : (i64, i64) -> i64
      "braid.setf"(%bbbf_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbbf_9) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bbc2] : () -> ()
    ^bbc2:  // 0x4011c2
      %bbc2_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbc2_0 = "braid.zext"(%bbc2_1) {bits = 32 : i64} : (i64) -> i64
      %bbc2_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bbc2_8 = "braid.zext"(%bbc2_9) {bits = 32 : i64} : (i64) -> i64
      %bbc2_16 = "braid.xor"(%bbc2_0, %bbc2_8) : (i64, i64) -> i64
      %bbc2_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbc2_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbc2_17) {flag = "of"} : (i64) -> ()
      %bbc2_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc2_24) {flag = "af"} : (i64) -> ()
      %bbc2_32 = "braid.zext"(%bbc2_16) {bits = 8 : i64} : (i64) -> i64
      %bbc2_33 = "braid.popcnt"(%bbc2_32) : (i64) -> i64
      %bbc2_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc2_35 = "braid.and"(%bbc2_33, %bbc2_34) : (i64, i64) -> i64
      %bbc2_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc2_37 = "braid.eq"(%bbc2_35, %bbc2_36) : (i64, i64) -> i64
      "braid.setf"(%bbc2_37) {flag = "pf"} : (i64) -> ()
      %bbc2_38 = "braid.eq"(%bbc2_16, %bbc2_36) : (i64, i64) -> i64
      "braid.setf"(%bbc2_38) {flag = "zf"} : (i64) -> ()
      %bbc2_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbc2_40 = "braid.and"(%bbc2_16, %bbc2_39) : (i64, i64) -> i64
      "braid.setf"(%bbc2_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbc2_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bbc5] : () -> ()
    ^bbc5:  // 0x4011c5
      %bbc5_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbc5_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bbc5_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbc5_5 = "braid.mul"(%bbc5_3, %bbc5_4) : (i64, i64) -> i64
      %bbc5_6 = "braid.add"(%bbc5_2, %bbc5_5) : (i64, i64) -> i64
      %bbc5_7 = "braid.const"() {value = -160 : i64} : () -> i64
      %bbc5_1 = "braid.add"(%bbc5_6, %bbc5_7) : (i64, i64) -> i64
      %bbc5_0 = "braid.load"(%bbc5_1) {bytes = 4 : i64} : (i64) -> i64
      %bbc5_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbc5_8 = "braid.zext"(%bbc5_9) {bits = 32 : i64} : (i64) -> i64
      %bbc5_16 = "braid.add"(%bbc5_0, %bbc5_8) : (i64, i64) -> i64
      %bbc5_17 = "braid.zext"(%bbc5_16) {bits = 32 : i64} : (i64) -> i64
      %bbc5_18 = "braid.ult"(%bbc5_17, %bbc5_0) : (i64, i64) -> i64
      "braid.setf"(%bbc5_18) {flag = "cf"} : (i64) -> ()
      %bbc5_19 = "braid.xor"(%bbc5_0, %bbc5_17) : (i64, i64) -> i64
      %bbc5_20 = "braid.xor"(%bbc5_8, %bbc5_17) : (i64, i64) -> i64
      %bbc5_21 = "braid.and"(%bbc5_19, %bbc5_20) : (i64, i64) -> i64
      %bbc5_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbc5_23 = "braid.and"(%bbc5_21, %bbc5_22) : (i64, i64) -> i64
      "braid.setf"(%bbc5_23) {flag = "of"} : (i64) -> ()
      %bbc5_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc5_24) {flag = "af"} : (i64) -> ()
      %bbc5_32 = "braid.zext"(%bbc5_17) {bits = 8 : i64} : (i64) -> i64
      %bbc5_33 = "braid.popcnt"(%bbc5_32) : (i64) -> i64
      %bbc5_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc5_35 = "braid.and"(%bbc5_33, %bbc5_34) : (i64, i64) -> i64
      %bbc5_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc5_37 = "braid.eq"(%bbc5_35, %bbc5_36) : (i64, i64) -> i64
      "braid.setf"(%bbc5_37) {flag = "pf"} : (i64) -> ()
      %bbc5_38 = "braid.eq"(%bbc5_17, %bbc5_36) : (i64, i64) -> i64
      "braid.setf"(%bbc5_38) {flag = "zf"} : (i64) -> ()
      %bbc5_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbc5_40 = "braid.and"(%bbc5_17, %bbc5_39) : (i64, i64) -> i64
      "braid.setf"(%bbc5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbc5_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x4011cc
      %bbcc_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbcc_0 = "braid.zext"(%bbcc_1) {bits = 32 : i64} : (i64) -> i64
      %bbcc_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbcc_8 = "braid.zext"(%bbcc_9) {bits = 32 : i64} : (i64) -> i64
      %bbcc_16 = "braid.add"(%bbcc_0, %bbcc_8) : (i64, i64) -> i64
      %bbcc_17 = "braid.zext"(%bbcc_16) {bits = 32 : i64} : (i64) -> i64
      %bbcc_18 = "braid.ult"(%bbcc_17, %bbcc_0) : (i64, i64) -> i64
      "braid.setf"(%bbcc_18) {flag = "cf"} : (i64) -> ()
      %bbcc_19 = "braid.xor"(%bbcc_0, %bbcc_17) : (i64, i64) -> i64
      %bbcc_20 = "braid.xor"(%bbcc_8, %bbcc_17) : (i64, i64) -> i64
      %bbcc_21 = "braid.and"(%bbcc_19, %bbcc_20) : (i64, i64) -> i64
      %bbcc_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbcc_23 = "braid.and"(%bbcc_21, %bbcc_22) : (i64, i64) -> i64
      "braid.setf"(%bbcc_23) {flag = "of"} : (i64) -> ()
      %bbcc_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbcc_24) {flag = "af"} : (i64) -> ()
      %bbcc_32 = "braid.zext"(%bbcc_17) {bits = 8 : i64} : (i64) -> i64
      %bbcc_33 = "braid.popcnt"(%bbcc_32) : (i64) -> i64
      %bbcc_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbcc_35 = "braid.and"(%bbcc_33, %bbcc_34) : (i64, i64) -> i64
      %bbcc_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbcc_37 = "braid.eq"(%bbcc_35, %bbcc_36) : (i64, i64) -> i64
      "braid.setf"(%bbcc_37) {flag = "pf"} : (i64) -> ()
      %bbcc_38 = "braid.eq"(%bbcc_17, %bbcc_36) : (i64, i64) -> i64
      "braid.setf"(%bbcc_38) {flag = "zf"} : (i64) -> ()
      %bbcc_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbcc_40 = "braid.and"(%bbcc_17, %bbcc_39) : (i64, i64) -> i64
      "braid.setf"(%bbcc_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbcc_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbce] : () -> ()
    ^bbce:  // 0x4011ce
      %bbce_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbce_0 = "braid.zext"(%bbce_1) {bits = 32 : i64} : (i64) -> i64
      %bbce_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbce_10 = "braid.get"() {reg = "rax"} : () -> i64
      %bbce_11 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbce_12 = "braid.mul"(%bbce_10, %bbce_11) : (i64, i64) -> i64
      %bbce_13 = "braid.add"(%bbce_9, %bbce_12) : (i64, i64) -> i64
      %bbce_14 = "braid.const"() {value = -96 : i64} : () -> i64
      %bbce_8 = "braid.add"(%bbce_13, %bbce_14) : (i64, i64) -> i64
      "braid.store"(%bbce_8, %bbce_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbd2] : () -> ()
    ^bbd2:  // 0x4011d2
      %bbd2_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bbd2_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd2_16 = "braid.add"(%bbd2_0, %bbd2_8) : (i64, i64) -> i64
      %bbd2_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbd2_20 = "braid.eq"(%bbd2_16, %bbd2_19) : (i64, i64) -> i64
      "braid.setf"(%bbd2_20) {flag = "of"} : (i64) -> ()
      %bbd2_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbd2_24) {flag = "af"} : (i64) -> ()
      %bbd2_32 = "braid.zext"(%bbd2_16) {bits = 8 : i64} : (i64) -> i64
      %bbd2_33 = "braid.popcnt"(%bbd2_32) : (i64) -> i64
      %bbd2_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd2_35 = "braid.and"(%bbd2_33, %bbd2_34) : (i64, i64) -> i64
      %bbd2_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd2_37 = "braid.eq"(%bbd2_35, %bbd2_36) : (i64, i64) -> i64
      "braid.setf"(%bbd2_37) {flag = "pf"} : (i64) -> ()
      %bbd2_38 = "braid.eq"(%bbd2_16, %bbd2_36) : (i64, i64) -> i64
      "braid.setf"(%bbd2_38) {flag = "zf"} : (i64) -> ()
      %bbd2_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbd2_40 = "braid.and"(%bbd2_16, %bbd2_39) : (i64, i64) -> i64
      "braid.setf"(%bbd2_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbd2_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbd5] : () -> ()
    ^bbd5:  // 0x4011d5
      %bbd5_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bbd5_8 = "braid.const"() {value = 64 : i64} : () -> i64
      %bbd5_16 = "braid.sub"(%bbd5_0, %bbd5_8) : (i64, i64) -> i64
      %bbd5_18 = "braid.ult"(%bbd5_0, %bbd5_8) : (i64, i64) -> i64
      "braid.setf"(%bbd5_18) {flag = "cf"} : (i64) -> ()
      %bbd5_19 = "braid.xor"(%bbd5_0, %bbd5_8) : (i64, i64) -> i64
      %bbd5_20 = "braid.xor"(%bbd5_0, %bbd5_16) : (i64, i64) -> i64
      %bbd5_21 = "braid.and"(%bbd5_19, %bbd5_20) : (i64, i64) -> i64
      %bbd5_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbd5_23 = "braid.and"(%bbd5_21, %bbd5_22) : (i64, i64) -> i64
      "braid.setf"(%bbd5_23) {flag = "of"} : (i64) -> ()
      %bbd5_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbd5_24) {flag = "af"} : (i64) -> ()
      %bbd5_32 = "braid.zext"(%bbd5_16) {bits = 8 : i64} : (i64) -> i64
      %bbd5_33 = "braid.popcnt"(%bbd5_32) : (i64) -> i64
      %bbd5_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd5_35 = "braid.and"(%bbd5_33, %bbd5_34) : (i64, i64) -> i64
      %bbd5_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd5_37 = "braid.eq"(%bbd5_35, %bbd5_36) : (i64, i64) -> i64
      "braid.setf"(%bbd5_37) {flag = "pf"} : (i64) -> ()
      %bbd5_38 = "braid.eq"(%bbd5_16, %bbd5_36) : (i64, i64) -> i64
      "braid.setf"(%bbd5_38) {flag = "zf"} : (i64) -> ()
      %bbd5_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbd5_40 = "braid.and"(%bbd5_16, %bbd5_39) : (i64, i64) -> i64
      "braid.setf"(%bbd5_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bbd9] : () -> ()
    ^bbd9:  // 0x4011d9
      %bbd9_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bbd9_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd9_0 = "braid.eq"(%bbd9_1, %bbd9_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bbd9_0)[^bb90, ^bbdb] : (i64) -> ()
    ^bbdb:  // 0x4011db
      %bbdb_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbdb_0 = "braid.load"(%bbdb_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbdb_0) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bbde] : () -> ()
    ^bbde:  // 0x4011de
      %bbde_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbde_3 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbde_1 = "braid.add"(%bbde_2, %bbde_3) : (i64, i64) -> i64
      %bbde_0 = "braid.load"(%bbde_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbde_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bbe2] : () -> ()
    ^bbe2:  // 0x4011e2
      %bbe2_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbe2_3 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbe2_1 = "braid.add"(%bbe2_2, %bbe2_3) : (i64, i64) -> i64
      %bbe2_0 = "braid.load"(%bbe2_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbe2_0) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bbe6] : () -> ()
    ^bbe6:  // 0x4011e6
      %bbe6_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbe6_3 = "braid.const"() {value = 12 : i64} : () -> i64
      %bbe6_1 = "braid.add"(%bbe6_2, %bbe6_3) : (i64, i64) -> i64
      %bbe6_0 = "braid.load"(%bbe6_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbe6_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbe9] : () -> ()
    ^bbe9:  // 0x4011e9
      %bbe9_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbe9_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbe9_1 = "braid.add"(%bbe9_2, %bbe9_3) : (i64, i64) -> i64
      %bbe9_0 = "braid.load"(%bbe9_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbe9_0) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bbed] : () -> ()
    ^bbed:  // 0x4011ed
      %bbed_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbed_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bbed_1 = "braid.add"(%bbed_2, %bbed_3) : (i64, i64) -> i64
      %bbed_0 = "braid.load"(%bbed_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbed_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bbf0] : () -> ()
    ^bbf0:  // 0x4011f0
      %bbf0_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbf0_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbf0_1 = "braid.add"(%bbf0_2, %bbf0_3) : (i64, i64) -> i64
      %bbf0_0 = "braid.load"(%bbf0_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbf0_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bbf4] : () -> ()
    ^bbf4:  // 0x4011f4
      %bbf4_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbf4_3 = "braid.const"() {value = 28 : i64} : () -> i64
      %bbf4_1 = "braid.add"(%bbf4_2, %bbf4_3) : (i64, i64) -> i64
      %bbf4_0 = "braid.load"(%bbf4_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbf4_0) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bbf7] : () -> ()
    ^bbf7:  // 0x4011f7
      %bbf7_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbf7_0 = "braid.zext"(%bbf7_1) {bits = 32 : i64} : (i64) -> i64
      %bbf7_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bbf7_8 = "braid.zext"(%bbf7_9) {bits = 32 : i64} : (i64) -> i64
      %bbf7_16 = "braid.xor"(%bbf7_0, %bbf7_8) : (i64, i64) -> i64
      %bbf7_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbf7_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbf7_17) {flag = "of"} : (i64) -> ()
      %bbf7_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbf7_24) {flag = "af"} : (i64) -> ()
      %bbf7_32 = "braid.zext"(%bbf7_16) {bits = 8 : i64} : (i64) -> i64
      %bbf7_33 = "braid.popcnt"(%bbf7_32) : (i64) -> i64
      %bbf7_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf7_35 = "braid.and"(%bbf7_33, %bbf7_34) : (i64, i64) -> i64
      %bbf7_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf7_37 = "braid.eq"(%bbf7_35, %bbf7_36) : (i64, i64) -> i64
      "braid.setf"(%bbf7_37) {flag = "pf"} : (i64) -> ()
      %bbf7_38 = "braid.eq"(%bbf7_16, %bbf7_36) : (i64, i64) -> i64
      "braid.setf"(%bbf7_38) {flag = "zf"} : (i64) -> ()
      %bbf7_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbf7_40 = "braid.and"(%bbf7_16, %bbf7_39) : (i64, i64) -> i64
      "braid.setf"(%bbf7_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbf7_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbf9] : () -> ()
    ^bbf9:  // 0x4011f9
      %bbf9_0 = "braid.const"() {value = 4203296 : i64} : () -> i64
      "braid.set"(%bbf9_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb100:  // 0x401200
      %bb100_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb100_0 = "braid.zext"(%bb100_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb100_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb103] : () -> ()
    ^bb103:  // 0x401203
      %bb103_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb103_0 = "braid.zext"(%bb103_1) {bits = 32 : i64} : (i64) -> i64
      %bb103_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb103_10 = "braid.const"() {value = -124 : i64} : () -> i64
      %bb103_8 = "braid.add"(%bb103_9, %bb103_10) : (i64, i64) -> i64
      "braid.store"(%bb103_8, %bb103_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x401208
      %bb108_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb108_0 = "braid.zext"(%bb108_1) {bits = 32 : i64} : (i64) -> i64
      %bb108_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb108_10 = "braid.const"() {value = -120 : i64} : () -> i64
      %bb108_8 = "braid.add"(%bb108_9, %bb108_10) : (i64, i64) -> i64
      "braid.store"(%bb108_8, %bb108_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb10d] : () -> ()
    ^bb10d:  // 0x40120d
      %bb10d_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb10d_0 = "braid.zext"(%bb10d_1) {bits = 32 : i64} : (i64) -> i64
      %bb10d_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb10d_10 = "braid.const"() {value = -116 : i64} : () -> i64
      %bb10d_8 = "braid.add"(%bb10d_9, %bb10d_10) : (i64, i64) -> i64
      "braid.store"(%bb10d_8, %bb10d_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb111] : () -> ()
    ^bb111:  // 0x401211
      %bb111_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb111_0 = "braid.zext"(%bb111_1) {bits = 32 : i64} : (i64) -> i64
      %bb111_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb111_10 = "braid.const"() {value = -112 : i64} : () -> i64
      %bb111_8 = "braid.add"(%bb111_9, %bb111_10) : (i64, i64) -> i64
      "braid.store"(%bb111_8, %bb111_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb116] : () -> ()
    ^bb116:  // 0x401216
      %bb116_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb116_0 = "braid.zext"(%bb116_1) {bits = 32 : i64} : (i64) -> i64
      %bb116_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb116_10 = "braid.const"() {value = -108 : i64} : () -> i64
      %bb116_8 = "braid.add"(%bb116_9, %bb116_10) : (i64, i64) -> i64
      "braid.store"(%bb116_8, %bb116_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb11a] : () -> ()
    ^bb11a:  // 0x40121a
      %bb11a_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb11a_0 = "braid.zext"(%bb11a_1) {bits = 32 : i64} : (i64) -> i64
      %bb11a_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb11a_10 = "braid.const"() {value = -104 : i64} : () -> i64
      %bb11a_8 = "braid.add"(%bb11a_9, %bb11a_10) : (i64, i64) -> i64
      "braid.store"(%bb11a_8, %bb11a_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb11f] : () -> ()
    ^bb11f:  // 0x40121f
      %bb11f_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb11f_0 = "braid.zext"(%bb11f_1) {bits = 32 : i64} : (i64) -> i64
      %bb11f_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb11f_10 = "braid.const"() {value = -100 : i64} : () -> i64
      %bb11f_8 = "braid.add"(%bb11f_9, %bb11f_10) : (i64, i64) -> i64
      "braid.store"(%bb11f_8, %bb11f_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb123] : () -> ()
    ^bb123:  // 0x401223
      "braid_cf.br"()[^bb130] : () -> ()
    ^bb130:  // 0x401230
      %bb130_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb130_0 = "braid.zext"(%bb130_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb130_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb133] : () -> ()
    ^bb133:  // 0x401233
      %bb133_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb133_0 = "braid.zext"(%bb133_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb133_0) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb136] : () -> ()
    ^bb136:  // 0x401236
      %bb136_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb136_0 = "braid.zext"(%bb136_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb136_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb139] : () -> ()
    ^bb139:  // 0x401239
      %bb139_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb139_0 = "braid.zext"(%bb139_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb139_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb13c] : () -> ()
    ^bb13c:  // 0x40123c
      %bb13c_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb13c_0 = "braid.zext"(%bb13c_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb13c_0) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb13f] : () -> ()
    ^bb13f:  // 0x40123f
      %bb13f_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb13f_0 = "braid.zext"(%bb13f_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb13f_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb142] : () -> ()
    ^bb142:  // 0x401242
      %bb142_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb142_0 = "braid.zext"(%bb142_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb142_0) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb145] : () -> ()
    ^bb145:  // 0x401245
      %bb145_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb145_0 = "braid.zext"(%bb145_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb145_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb148] : () -> ()
    ^bb148:  // 0x401248
      %bb148_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb148_0 = "braid.zext"(%bb148_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb148_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb14b] : () -> ()
    ^bb14b:  // 0x40124b
      %bb14b_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb14b_0 = "braid.zext"(%bb14b_1) {bits = 32 : i64} : (i64) -> i64
      %bb14b_12 = "braid.const"() {value = 26 : i64} : () -> i64
      %bb14b_13 = "braid.shl"(%bb14b_0, %bb14b_12) : (i64, i64) -> i64
      %bb14b_14 = "braid.const"() {value = 6 : i64} : () -> i64
      %bb14b_15 = "braid.lshr"(%bb14b_0, %bb14b_14) : (i64, i64) -> i64
      %bb14b_16 = "braid.or"(%bb14b_13, %bb14b_15) : (i64, i64) -> i64
      %bb14b_17 = "braid.zext"(%bb14b_16) {bits = 32 : i64} : (i64) -> i64
      %bb14b_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14b_19 = "braid.and"(%bb14b_17, %bb14b_18) : (i64, i64) -> i64
      "braid.setf"(%bb14b_19) {flag = "cf"} : (i64) -> ()
      %bb14b_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb14b_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb14b_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb14f] : () -> ()
    ^bb14f:  // 0x40124f
      %bb14f_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb14f_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb14f_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14f_5 = "braid.mul"(%bb14f_3, %bb14f_4) : (i64, i64) -> i64
      %bb14f_6 = "braid.add"(%bb14f_2, %bb14f_5) : (i64, i64) -> i64
      %bb14f_7 = "braid.const"() {value = -96 : i64} : () -> i64
      %bb14f_1 = "braid.add"(%bb14f_6, %bb14f_7) : (i64, i64) -> i64
      %bb14f_0 = "braid.load"(%bb14f_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb14f_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb153] : () -> ()
    ^bb153:  // 0x401253
      %bb153_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb153_0 = "braid.zext"(%bb153_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb153_0) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb156] : () -> ()
    ^bb156:  // 0x401256
      %bb156_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb156_0 = "braid.zext"(%bb156_1) {bits = 32 : i64} : (i64) -> i64
      %bb156_12 = "braid.const"() {value = 21 : i64} : () -> i64
      %bb156_13 = "braid.shl"(%bb156_0, %bb156_12) : (i64, i64) -> i64
      %bb156_14 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb156_15 = "braid.lshr"(%bb156_0, %bb156_14) : (i64, i64) -> i64
      %bb156_16 = "braid.or"(%bb156_13, %bb156_15) : (i64, i64) -> i64
      %bb156_17 = "braid.zext"(%bb156_16) {bits = 32 : i64} : (i64) -> i64
      %bb156_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb156_19 = "braid.and"(%bb156_17, %bb156_18) : (i64, i64) -> i64
      "braid.setf"(%bb156_19) {flag = "cf"} : (i64) -> ()
      %bb156_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb156_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb156_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb15a] : () -> ()
    ^bb15a:  // 0x40125a
      %bb15a_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb15a_0 = "braid.zext"(%bb15a_1) {bits = 32 : i64} : (i64) -> i64
      %bb15a_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bb15a_8 = "braid.zext"(%bb15a_9) {bits = 32 : i64} : (i64) -> i64
      %bb15a_16 = "braid.xor"(%bb15a_0, %bb15a_8) : (i64, i64) -> i64
      %bb15a_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb15a_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb15a_17) {flag = "of"} : (i64) -> ()
      %bb15a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb15a_24) {flag = "af"} : (i64) -> ()
      %bb15a_32 = "braid.zext"(%bb15a_16) {bits = 8 : i64} : (i64) -> i64
      %bb15a_33 = "braid.popcnt"(%bb15a_32) : (i64) -> i64
      %bb15a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb15a_35 = "braid.and"(%bb15a_33, %bb15a_34) : (i64, i64) -> i64
      %bb15a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15a_37 = "braid.eq"(%bb15a_35, %bb15a_36) : (i64, i64) -> i64
      "braid.setf"(%bb15a_37) {flag = "pf"} : (i64) -> ()
      %bb15a_38 = "braid.eq"(%bb15a_16, %bb15a_36) : (i64, i64) -> i64
      "braid.setf"(%bb15a_38) {flag = "zf"} : (i64) -> ()
      %bb15a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb15a_40 = "braid.and"(%bb15a_16, %bb15a_39) : (i64, i64) -> i64
      "braid.setf"(%bb15a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb15a_16) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb15d] : () -> ()
    ^bb15d:  // 0x40125d
      %bb15d_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb15d_0 = "braid.zext"(%bb15d_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb15d_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb160] : () -> ()
    ^bb160:  // 0x401260
      %bb160_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb160_0 = "braid.zext"(%bb160_1) {bits = 32 : i64} : (i64) -> i64
      %bb160_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb160_13 = "braid.shl"(%bb160_0, %bb160_12) : (i64, i64) -> i64
      %bb160_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb160_15 = "braid.lshr"(%bb160_0, %bb160_14) : (i64, i64) -> i64
      %bb160_16 = "braid.or"(%bb160_13, %bb160_15) : (i64, i64) -> i64
      %bb160_17 = "braid.zext"(%bb160_16) {bits = 32 : i64} : (i64) -> i64
      %bb160_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb160_19 = "braid.and"(%bb160_17, %bb160_18) : (i64, i64) -> i64
      "braid.setf"(%bb160_19) {flag = "cf"} : (i64) -> ()
      %bb160_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb160_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb160_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb164] : () -> ()
    ^bb164:  // 0x401264
      %bb164_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb164_0 = "braid.zext"(%bb164_1) {bits = 32 : i64} : (i64) -> i64
      %bb164_9 = "braid.get"() {reg = "r14"} : () -> i64
      %bb164_8 = "braid.zext"(%bb164_9) {bits = 32 : i64} : (i64) -> i64
      %bb164_16 = "braid.xor"(%bb164_0, %bb164_8) : (i64, i64) -> i64
      %bb164_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb164_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb164_17) {flag = "of"} : (i64) -> ()
      %bb164_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb164_24) {flag = "af"} : (i64) -> ()
      %bb164_32 = "braid.zext"(%bb164_16) {bits = 8 : i64} : (i64) -> i64
      %bb164_33 = "braid.popcnt"(%bb164_32) : (i64) -> i64
      %bb164_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb164_35 = "braid.and"(%bb164_33, %bb164_34) : (i64, i64) -> i64
      %bb164_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb164_37 = "braid.eq"(%bb164_35, %bb164_36) : (i64, i64) -> i64
      "braid.setf"(%bb164_37) {flag = "pf"} : (i64) -> ()
      %bb164_38 = "braid.eq"(%bb164_16, %bb164_36) : (i64, i64) -> i64
      "braid.setf"(%bb164_38) {flag = "zf"} : (i64) -> ()
      %bb164_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb164_40 = "braid.and"(%bb164_16, %bb164_39) : (i64, i64) -> i64
      "braid.setf"(%bb164_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb164_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb167] : () -> ()
    ^bb167:  // 0x401267
      %bb167_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb167_0 = "braid.zext"(%bb167_1) {bits = 32 : i64} : (i64) -> i64
      %bb167_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bb167_8 = "braid.zext"(%bb167_9) {bits = 32 : i64} : (i64) -> i64
      %bb167_16 = "braid.add"(%bb167_0, %bb167_8) : (i64, i64) -> i64
      %bb167_17 = "braid.zext"(%bb167_16) {bits = 32 : i64} : (i64) -> i64
      %bb167_18 = "braid.ult"(%bb167_17, %bb167_0) : (i64, i64) -> i64
      "braid.setf"(%bb167_18) {flag = "cf"} : (i64) -> ()
      %bb167_19 = "braid.xor"(%bb167_0, %bb167_17) : (i64, i64) -> i64
      %bb167_20 = "braid.xor"(%bb167_8, %bb167_17) : (i64, i64) -> i64
      %bb167_21 = "braid.and"(%bb167_19, %bb167_20) : (i64, i64) -> i64
      %bb167_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb167_23 = "braid.and"(%bb167_21, %bb167_22) : (i64, i64) -> i64
      "braid.setf"(%bb167_23) {flag = "of"} : (i64) -> ()
      %bb167_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb167_24) {flag = "af"} : (i64) -> ()
      %bb167_32 = "braid.zext"(%bb167_17) {bits = 8 : i64} : (i64) -> i64
      %bb167_33 = "braid.popcnt"(%bb167_32) : (i64) -> i64
      %bb167_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb167_35 = "braid.and"(%bb167_33, %bb167_34) : (i64, i64) -> i64
      %bb167_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb167_37 = "braid.eq"(%bb167_35, %bb167_36) : (i64, i64) -> i64
      "braid.setf"(%bb167_37) {flag = "pf"} : (i64) -> ()
      %bb167_38 = "braid.eq"(%bb167_17, %bb167_36) : (i64, i64) -> i64
      "braid.setf"(%bb167_38) {flag = "zf"} : (i64) -> ()
      %bb167_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb167_40 = "braid.and"(%bb167_17, %bb167_39) : (i64, i64) -> i64
      "braid.setf"(%bb167_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb167_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb16a] : () -> ()
    ^bb16a:  // 0x40126a
      %bb16a_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb16a_0 = "braid.zext"(%bb16a_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb16a_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb16d] : () -> ()
    ^bb16d:  // 0x40126d
      %bb16d_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb16d_0 = "braid.zext"(%bb16d_1) {bits = 32 : i64} : (i64) -> i64
      %bb16d_9 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb16d_8 = "braid.zext"(%bb16d_9) {bits = 32 : i64} : (i64) -> i64
      %bb16d_16 = "braid.xor"(%bb16d_0, %bb16d_8) : (i64, i64) -> i64
      %bb16d_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb16d_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb16d_17) {flag = "of"} : (i64) -> ()
      %bb16d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb16d_24) {flag = "af"} : (i64) -> ()
      %bb16d_32 = "braid.zext"(%bb16d_16) {bits = 8 : i64} : (i64) -> i64
      %bb16d_33 = "braid.popcnt"(%bb16d_32) : (i64) -> i64
      %bb16d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb16d_35 = "braid.and"(%bb16d_33, %bb16d_34) : (i64, i64) -> i64
      %bb16d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb16d_37 = "braid.eq"(%bb16d_35, %bb16d_36) : (i64, i64) -> i64
      "braid.setf"(%bb16d_37) {flag = "pf"} : (i64) -> ()
      %bb16d_38 = "braid.eq"(%bb16d_16, %bb16d_36) : (i64, i64) -> i64
      "braid.setf"(%bb16d_38) {flag = "zf"} : (i64) -> ()
      %bb16d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb16d_40 = "braid.and"(%bb16d_16, %bb16d_39) : (i64, i64) -> i64
      "braid.setf"(%bb16d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb16d_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb170] : () -> ()
    ^bb170:  // 0x401270
      %bb170_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb170_0 = "braid.zext"(%bb170_1) {bits = 32 : i64} : (i64) -> i64
      %bb170_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb170_8 = "braid.zext"(%bb170_9) {bits = 32 : i64} : (i64) -> i64
      %bb170_16 = "braid.and"(%bb170_0, %bb170_8) : (i64, i64) -> i64
      %bb170_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb170_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb170_17) {flag = "of"} : (i64) -> ()
      %bb170_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb170_24) {flag = "af"} : (i64) -> ()
      %bb170_32 = "braid.zext"(%bb170_16) {bits = 8 : i64} : (i64) -> i64
      %bb170_33 = "braid.popcnt"(%bb170_32) : (i64) -> i64
      %bb170_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb170_35 = "braid.and"(%bb170_33, %bb170_34) : (i64, i64) -> i64
      %bb170_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb170_37 = "braid.eq"(%bb170_35, %bb170_36) : (i64, i64) -> i64
      "braid.setf"(%bb170_37) {flag = "pf"} : (i64) -> ()
      %bb170_38 = "braid.eq"(%bb170_16, %bb170_36) : (i64, i64) -> i64
      "braid.setf"(%bb170_38) {flag = "zf"} : (i64) -> ()
      %bb170_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb170_40 = "braid.and"(%bb170_16, %bb170_39) : (i64, i64) -> i64
      "braid.setf"(%bb170_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb170_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb173] : () -> ()
    ^bb173:  // 0x401273
      %bb173_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb173_0 = "braid.zext"(%bb173_1) {bits = 32 : i64} : (i64) -> i64
      %bb173_9 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb173_8 = "braid.zext"(%bb173_9) {bits = 32 : i64} : (i64) -> i64
      %bb173_16 = "braid.xor"(%bb173_0, %bb173_8) : (i64, i64) -> i64
      %bb173_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb173_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb173_17) {flag = "of"} : (i64) -> ()
      %bb173_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb173_24) {flag = "af"} : (i64) -> ()
      %bb173_32 = "braid.zext"(%bb173_16) {bits = 8 : i64} : (i64) -> i64
      %bb173_33 = "braid.popcnt"(%bb173_32) : (i64) -> i64
      %bb173_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb173_35 = "braid.and"(%bb173_33, %bb173_34) : (i64, i64) -> i64
      %bb173_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb173_37 = "braid.eq"(%bb173_35, %bb173_36) : (i64, i64) -> i64
      "braid.setf"(%bb173_37) {flag = "pf"} : (i64) -> ()
      %bb173_38 = "braid.eq"(%bb173_16, %bb173_36) : (i64, i64) -> i64
      "braid.setf"(%bb173_38) {flag = "zf"} : (i64) -> ()
      %bb173_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb173_40 = "braid.and"(%bb173_16, %bb173_39) : (i64, i64) -> i64
      "braid.setf"(%bb173_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb173_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb176] : () -> ()
    ^bb176:  // 0x401276
      %bb176_2 = "braid.get"() {reg = "rax"} : () -> i64
      %bb176_3 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb176_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb176_5 = "braid.mul"(%bb176_3, %bb176_4) : (i64, i64) -> i64
      %bb176_6 = "braid.add"(%bb176_2, %bb176_5) : (i64, i64) -> i64
      %bb176_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb176_1 = "braid.add"(%bb176_6, %bb176_7) : (i64, i64) -> i64
      %bb176_0 = "braid.load"(%bb176_1) {bytes = 4 : i64} : (i64) -> i64
      %bb176_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb176_8 = "braid.zext"(%bb176_9) {bits = 32 : i64} : (i64) -> i64
      %bb176_16 = "braid.add"(%bb176_0, %bb176_8) : (i64, i64) -> i64
      %bb176_17 = "braid.zext"(%bb176_16) {bits = 32 : i64} : (i64) -> i64
      %bb176_18 = "braid.ult"(%bb176_17, %bb176_0) : (i64, i64) -> i64
      "braid.setf"(%bb176_18) {flag = "cf"} : (i64) -> ()
      %bb176_19 = "braid.xor"(%bb176_0, %bb176_17) : (i64, i64) -> i64
      %bb176_20 = "braid.xor"(%bb176_8, %bb176_17) : (i64, i64) -> i64
      %bb176_21 = "braid.and"(%bb176_19, %bb176_20) : (i64, i64) -> i64
      %bb176_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb176_23 = "braid.and"(%bb176_21, %bb176_22) : (i64, i64) -> i64
      "braid.setf"(%bb176_23) {flag = "of"} : (i64) -> ()
      %bb176_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb176_24) {flag = "af"} : (i64) -> ()
      %bb176_32 = "braid.zext"(%bb176_17) {bits = 8 : i64} : (i64) -> i64
      %bb176_33 = "braid.popcnt"(%bb176_32) : (i64) -> i64
      %bb176_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb176_35 = "braid.and"(%bb176_33, %bb176_34) : (i64, i64) -> i64
      %bb176_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb176_37 = "braid.eq"(%bb176_35, %bb176_36) : (i64, i64) -> i64
      "braid.setf"(%bb176_37) {flag = "pf"} : (i64) -> ()
      %bb176_38 = "braid.eq"(%bb176_17, %bb176_36) : (i64, i64) -> i64
      "braid.setf"(%bb176_38) {flag = "zf"} : (i64) -> ()
      %bb176_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb176_40 = "braid.and"(%bb176_17, %bb176_39) : (i64, i64) -> i64
      "braid.setf"(%bb176_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb176_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb179] : () -> ()
    ^bb179:  // 0x401279
      %bb179_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb179_0 = "braid.zext"(%bb179_1) {bits = 32 : i64} : (i64) -> i64
      %bb179_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb179_8 = "braid.zext"(%bb179_9) {bits = 32 : i64} : (i64) -> i64
      %bb179_16 = "braid.add"(%bb179_0, %bb179_8) : (i64, i64) -> i64
      %bb179_17 = "braid.zext"(%bb179_16) {bits = 32 : i64} : (i64) -> i64
      %bb179_18 = "braid.ult"(%bb179_17, %bb179_0) : (i64, i64) -> i64
      "braid.setf"(%bb179_18) {flag = "cf"} : (i64) -> ()
      %bb179_19 = "braid.xor"(%bb179_0, %bb179_17) : (i64, i64) -> i64
      %bb179_20 = "braid.xor"(%bb179_8, %bb179_17) : (i64, i64) -> i64
      %bb179_21 = "braid.and"(%bb179_19, %bb179_20) : (i64, i64) -> i64
      %bb179_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb179_23 = "braid.and"(%bb179_21, %bb179_22) : (i64, i64) -> i64
      "braid.setf"(%bb179_23) {flag = "of"} : (i64) -> ()
      %bb179_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb179_24) {flag = "af"} : (i64) -> ()
      %bb179_32 = "braid.zext"(%bb179_17) {bits = 8 : i64} : (i64) -> i64
      %bb179_33 = "braid.popcnt"(%bb179_32) : (i64) -> i64
      %bb179_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb179_35 = "braid.and"(%bb179_33, %bb179_34) : (i64, i64) -> i64
      %bb179_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb179_37 = "braid.eq"(%bb179_35, %bb179_36) : (i64, i64) -> i64
      "braid.setf"(%bb179_37) {flag = "pf"} : (i64) -> ()
      %bb179_38 = "braid.eq"(%bb179_17, %bb179_36) : (i64, i64) -> i64
      "braid.setf"(%bb179_38) {flag = "zf"} : (i64) -> ()
      %bb179_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb179_40 = "braid.and"(%bb179_17, %bb179_39) : (i64, i64) -> i64
      "braid.setf"(%bb179_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb179_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb17c] : () -> ()
    ^bb17c:  // 0x40127c
      %bb17c_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb17c_0 = "braid.zext"(%bb17c_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb17c_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb17f] : () -> ()
    ^bb17f:  // 0x40127f
      %bb17f_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb17f_0 = "braid.zext"(%bb17f_1) {bits = 32 : i64} : (i64) -> i64
      %bb17f_12 = "braid.const"() {value = 30 : i64} : () -> i64
      %bb17f_13 = "braid.shl"(%bb17f_0, %bb17f_12) : (i64, i64) -> i64
      %bb17f_14 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb17f_15 = "braid.lshr"(%bb17f_0, %bb17f_14) : (i64, i64) -> i64
      %bb17f_16 = "braid.or"(%bb17f_13, %bb17f_15) : (i64, i64) -> i64
      %bb17f_17 = "braid.zext"(%bb17f_16) {bits = 32 : i64} : (i64) -> i64
      %bb17f_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb17f_19 = "braid.and"(%bb17f_17, %bb17f_18) : (i64, i64) -> i64
      "braid.setf"(%bb17f_19) {flag = "cf"} : (i64) -> ()
      %bb17f_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb17f_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb17f_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb183] : () -> ()
    ^bb183:  // 0x401283
      %bb183_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb183_0 = "braid.zext"(%bb183_1) {bits = 32 : i64} : (i64) -> i64
      %bb183_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb183_8 = "braid.zext"(%bb183_9) {bits = 32 : i64} : (i64) -> i64
      %bb183_16 = "braid.add"(%bb183_0, %bb183_8) : (i64, i64) -> i64
      %bb183_17 = "braid.zext"(%bb183_16) {bits = 32 : i64} : (i64) -> i64
      %bb183_18 = "braid.ult"(%bb183_17, %bb183_0) : (i64, i64) -> i64
      "braid.setf"(%bb183_18) {flag = "cf"} : (i64) -> ()
      %bb183_19 = "braid.xor"(%bb183_0, %bb183_17) : (i64, i64) -> i64
      %bb183_20 = "braid.xor"(%bb183_8, %bb183_17) : (i64, i64) -> i64
      %bb183_21 = "braid.and"(%bb183_19, %bb183_20) : (i64, i64) -> i64
      %bb183_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb183_23 = "braid.and"(%bb183_21, %bb183_22) : (i64, i64) -> i64
      "braid.setf"(%bb183_23) {flag = "of"} : (i64) -> ()
      %bb183_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb183_24) {flag = "af"} : (i64) -> ()
      %bb183_32 = "braid.zext"(%bb183_17) {bits = 8 : i64} : (i64) -> i64
      %bb183_33 = "braid.popcnt"(%bb183_32) : (i64) -> i64
      %bb183_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb183_35 = "braid.and"(%bb183_33, %bb183_34) : (i64, i64) -> i64
      %bb183_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb183_37 = "braid.eq"(%bb183_35, %bb183_36) : (i64, i64) -> i64
      "braid.setf"(%bb183_37) {flag = "pf"} : (i64) -> ()
      %bb183_38 = "braid.eq"(%bb183_17, %bb183_36) : (i64, i64) -> i64
      "braid.setf"(%bb183_38) {flag = "zf"} : (i64) -> ()
      %bb183_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb183_40 = "braid.and"(%bb183_17, %bb183_39) : (i64, i64) -> i64
      "braid.setf"(%bb183_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb183_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb186] : () -> ()
    ^bb186:  // 0x401286
      %bb186_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb186_0 = "braid.zext"(%bb186_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb186_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb189] : () -> ()
    ^bb189:  // 0x401289
      %bb189_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb189_0 = "braid.zext"(%bb189_1) {bits = 32 : i64} : (i64) -> i64
      %bb189_12 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb189_13 = "braid.shl"(%bb189_0, %bb189_12) : (i64, i64) -> i64
      %bb189_14 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb189_15 = "braid.lshr"(%bb189_0, %bb189_14) : (i64, i64) -> i64
      %bb189_16 = "braid.or"(%bb189_13, %bb189_15) : (i64, i64) -> i64
      %bb189_17 = "braid.zext"(%bb189_16) {bits = 32 : i64} : (i64) -> i64
      %bb189_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb189_19 = "braid.and"(%bb189_17, %bb189_18) : (i64, i64) -> i64
      "braid.setf"(%bb189_19) {flag = "cf"} : (i64) -> ()
      %bb189_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb189_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb189_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb18d] : () -> ()
    ^bb18d:  // 0x40128d
      %bb18d_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb18d_0 = "braid.zext"(%bb18d_1) {bits = 32 : i64} : (i64) -> i64
      %bb18d_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bb18d_8 = "braid.zext"(%bb18d_9) {bits = 32 : i64} : (i64) -> i64
      %bb18d_16 = "braid.xor"(%bb18d_0, %bb18d_8) : (i64, i64) -> i64
      %bb18d_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb18d_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb18d_17) {flag = "of"} : (i64) -> ()
      %bb18d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb18d_24) {flag = "af"} : (i64) -> ()
      %bb18d_32 = "braid.zext"(%bb18d_16) {bits = 8 : i64} : (i64) -> i64
      %bb18d_33 = "braid.popcnt"(%bb18d_32) : (i64) -> i64
      %bb18d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb18d_35 = "braid.and"(%bb18d_33, %bb18d_34) : (i64, i64) -> i64
      %bb18d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18d_37 = "braid.eq"(%bb18d_35, %bb18d_36) : (i64, i64) -> i64
      "braid.setf"(%bb18d_37) {flag = "pf"} : (i64) -> ()
      %bb18d_38 = "braid.eq"(%bb18d_16, %bb18d_36) : (i64, i64) -> i64
      "braid.setf"(%bb18d_38) {flag = "zf"} : (i64) -> ()
      %bb18d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb18d_40 = "braid.and"(%bb18d_16, %bb18d_39) : (i64, i64) -> i64
      "braid.setf"(%bb18d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb18d_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x401290
      %bb190_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb190_0 = "braid.zext"(%bb190_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb190_0) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb193] : () -> ()
    ^bb193:  // 0x401293
      %bb193_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb193_0 = "braid.zext"(%bb193_1) {bits = 32 : i64} : (i64) -> i64
      %bb193_12 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb193_13 = "braid.shl"(%bb193_0, %bb193_12) : (i64, i64) -> i64
      %bb193_14 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb193_15 = "braid.lshr"(%bb193_0, %bb193_14) : (i64, i64) -> i64
      %bb193_16 = "braid.or"(%bb193_13, %bb193_15) : (i64, i64) -> i64
      %bb193_17 = "braid.zext"(%bb193_16) {bits = 32 : i64} : (i64) -> i64
      %bb193_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb193_19 = "braid.and"(%bb193_17, %bb193_18) : (i64, i64) -> i64
      "braid.setf"(%bb193_19) {flag = "cf"} : (i64) -> ()
      %bb193_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb193_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb193_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb197] : () -> ()
    ^bb197:  // 0x401297
      %bb197_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb197_0 = "braid.zext"(%bb197_1) {bits = 32 : i64} : (i64) -> i64
      %bb197_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb197_8 = "braid.zext"(%bb197_9) {bits = 32 : i64} : (i64) -> i64
      %bb197_16 = "braid.xor"(%bb197_0, %bb197_8) : (i64, i64) -> i64
      %bb197_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb197_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb197_17) {flag = "of"} : (i64) -> ()
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
      %bb197_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb197_40 = "braid.and"(%bb197_16, %bb197_39) : (i64, i64) -> i64
      "braid.setf"(%bb197_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb197_16) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb19a] : () -> ()
    ^bb19a:  // 0x40129a
      %bb19a_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb19a_0 = "braid.zext"(%bb19a_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb19a_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb19d] : () -> ()
    ^bb19d:  // 0x40129d
      %bb19d_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb19d_0 = "braid.zext"(%bb19d_1) {bits = 32 : i64} : (i64) -> i64
      %bb19d_9 = "braid.get"() {reg = "r12"} : () -> i64
      %bb19d_8 = "braid.zext"(%bb19d_9) {bits = 32 : i64} : (i64) -> i64
      %bb19d_16 = "braid.xor"(%bb19d_0, %bb19d_8) : (i64, i64) -> i64
      %bb19d_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb19d_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb19d_17) {flag = "of"} : (i64) -> ()
      %bb19d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb19d_24) {flag = "af"} : (i64) -> ()
      %bb19d_32 = "braid.zext"(%bb19d_16) {bits = 8 : i64} : (i64) -> i64
      %bb19d_33 = "braid.popcnt"(%bb19d_32) : (i64) -> i64
      %bb19d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb19d_35 = "braid.and"(%bb19d_33, %bb19d_34) : (i64, i64) -> i64
      %bb19d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb19d_37 = "braid.eq"(%bb19d_35, %bb19d_36) : (i64, i64) -> i64
      "braid.setf"(%bb19d_37) {flag = "pf"} : (i64) -> ()
      %bb19d_38 = "braid.eq"(%bb19d_16, %bb19d_36) : (i64, i64) -> i64
      "braid.setf"(%bb19d_38) {flag = "zf"} : (i64) -> ()
      %bb19d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb19d_40 = "braid.and"(%bb19d_16, %bb19d_39) : (i64, i64) -> i64
      "braid.setf"(%bb19d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb19d_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb1a0] : () -> ()
    ^bb1a0:  // 0x4012a0
      %bb1a0_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb1a0_0 = "braid.zext"(%bb1a0_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a0_9 = "braid.get"() {reg = "r13"} : () -> i64
      %bb1a0_8 = "braid.zext"(%bb1a0_9) {bits = 32 : i64} : (i64) -> i64
      %bb1a0_16 = "braid.and"(%bb1a0_0, %bb1a0_8) : (i64, i64) -> i64
      %bb1a0_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1a0_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1a0_17) {flag = "of"} : (i64) -> ()
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
      %bb1a0_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1a0_40 = "braid.and"(%bb1a0_16, %bb1a0_39) : (i64, i64) -> i64
      "braid.setf"(%bb1a0_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1a0_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb1a3] : () -> ()
    ^bb1a3:  // 0x4012a3
      %bb1a3_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1a3_0 = "braid.zext"(%bb1a3_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb1a3_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb1a6] : () -> ()
    ^bb1a6:  // 0x4012a6
      %bb1a6_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb1a6_0 = "braid.zext"(%bb1a6_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a6_9 = "braid.get"() {reg = "r12"} : () -> i64
      %bb1a6_8 = "braid.zext"(%bb1a6_9) {bits = 32 : i64} : (i64) -> i64
      %bb1a6_16 = "braid.and"(%bb1a6_0, %bb1a6_8) : (i64, i64) -> i64
      %bb1a6_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1a6_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1a6_17) {flag = "of"} : (i64) -> ()
      %bb1a6_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1a6_24) {flag = "af"} : (i64) -> ()
      %bb1a6_32 = "braid.zext"(%bb1a6_16) {bits = 8 : i64} : (i64) -> i64
      %bb1a6_33 = "braid.popcnt"(%bb1a6_32) : (i64) -> i64
      %bb1a6_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1a6_35 = "braid.and"(%bb1a6_33, %bb1a6_34) : (i64, i64) -> i64
      %bb1a6_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1a6_37 = "braid.eq"(%bb1a6_35, %bb1a6_36) : (i64, i64) -> i64
      "braid.setf"(%bb1a6_37) {flag = "pf"} : (i64) -> ()
      %bb1a6_38 = "braid.eq"(%bb1a6_16, %bb1a6_36) : (i64, i64) -> i64
      "braid.setf"(%bb1a6_38) {flag = "zf"} : (i64) -> ()
      %bb1a6_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1a6_40 = "braid.and"(%bb1a6_16, %bb1a6_39) : (i64, i64) -> i64
      "braid.setf"(%bb1a6_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1a6_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb1a9] : () -> ()
    ^bb1a9:  // 0x4012a9
      %bb1a9_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb1a9_0 = "braid.zext"(%bb1a9_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a9_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb1a9_8 = "braid.zext"(%bb1a9_9) {bits = 32 : i64} : (i64) -> i64
      %bb1a9_16 = "braid.xor"(%bb1a9_0, %bb1a9_8) : (i64, i64) -> i64
      %bb1a9_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1a9_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1a9_17) {flag = "of"} : (i64) -> ()
      %bb1a9_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1a9_24) {flag = "af"} : (i64) -> ()
      %bb1a9_32 = "braid.zext"(%bb1a9_16) {bits = 8 : i64} : (i64) -> i64
      %bb1a9_33 = "braid.popcnt"(%bb1a9_32) : (i64) -> i64
      %bb1a9_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1a9_35 = "braid.and"(%bb1a9_33, %bb1a9_34) : (i64, i64) -> i64
      %bb1a9_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1a9_37 = "braid.eq"(%bb1a9_35, %bb1a9_36) : (i64, i64) -> i64
      "braid.setf"(%bb1a9_37) {flag = "pf"} : (i64) -> ()
      %bb1a9_38 = "braid.eq"(%bb1a9_16, %bb1a9_36) : (i64, i64) -> i64
      "braid.setf"(%bb1a9_38) {flag = "zf"} : (i64) -> ()
      %bb1a9_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1a9_40 = "braid.and"(%bb1a9_16, %bb1a9_39) : (i64, i64) -> i64
      "braid.setf"(%bb1a9_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1a9_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb1ac] : () -> ()
    ^bb1ac:  // 0x4012ac
      %bb1ac_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb1ac_0 = "braid.zext"(%bb1ac_1) {bits = 32 : i64} : (i64) -> i64
      %bb1ac_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bb1ac_8 = "braid.zext"(%bb1ac_9) {bits = 32 : i64} : (i64) -> i64
      %bb1ac_16 = "braid.add"(%bb1ac_0, %bb1ac_8) : (i64, i64) -> i64
      %bb1ac_17 = "braid.zext"(%bb1ac_16) {bits = 32 : i64} : (i64) -> i64
      %bb1ac_18 = "braid.ult"(%bb1ac_17, %bb1ac_0) : (i64, i64) -> i64
      "braid.setf"(%bb1ac_18) {flag = "cf"} : (i64) -> ()
      %bb1ac_19 = "braid.xor"(%bb1ac_0, %bb1ac_17) : (i64, i64) -> i64
      %bb1ac_20 = "braid.xor"(%bb1ac_8, %bb1ac_17) : (i64, i64) -> i64
      %bb1ac_21 = "braid.and"(%bb1ac_19, %bb1ac_20) : (i64, i64) -> i64
      %bb1ac_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1ac_23 = "braid.and"(%bb1ac_21, %bb1ac_22) : (i64, i64) -> i64
      "braid.setf"(%bb1ac_23) {flag = "of"} : (i64) -> ()
      %bb1ac_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1ac_24) {flag = "af"} : (i64) -> ()
      %bb1ac_32 = "braid.zext"(%bb1ac_17) {bits = 8 : i64} : (i64) -> i64
      %bb1ac_33 = "braid.popcnt"(%bb1ac_32) : (i64) -> i64
      %bb1ac_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1ac_35 = "braid.and"(%bb1ac_33, %bb1ac_34) : (i64, i64) -> i64
      %bb1ac_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1ac_37 = "braid.eq"(%bb1ac_35, %bb1ac_36) : (i64, i64) -> i64
      "braid.setf"(%bb1ac_37) {flag = "pf"} : (i64) -> ()
      %bb1ac_38 = "braid.eq"(%bb1ac_17, %bb1ac_36) : (i64, i64) -> i64
      "braid.setf"(%bb1ac_38) {flag = "zf"} : (i64) -> ()
      %bb1ac_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1ac_40 = "braid.and"(%bb1ac_17, %bb1ac_39) : (i64, i64) -> i64
      "braid.setf"(%bb1ac_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1ac_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb1af] : () -> ()
    ^bb1af:  // 0x4012af
      %bb1af_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1af_0 = "braid.zext"(%bb1af_1) {bits = 32 : i64} : (i64) -> i64
      %bb1af_9 = "braid.get"() {reg = "r15"} : () -> i64
      %bb1af_8 = "braid.zext"(%bb1af_9) {bits = 32 : i64} : (i64) -> i64
      %bb1af_16 = "braid.add"(%bb1af_0, %bb1af_8) : (i64, i64) -> i64
      %bb1af_17 = "braid.zext"(%bb1af_16) {bits = 32 : i64} : (i64) -> i64
      %bb1af_18 = "braid.ult"(%bb1af_17, %bb1af_0) : (i64, i64) -> i64
      "braid.setf"(%bb1af_18) {flag = "cf"} : (i64) -> ()
      %bb1af_19 = "braid.xor"(%bb1af_0, %bb1af_17) : (i64, i64) -> i64
      %bb1af_20 = "braid.xor"(%bb1af_8, %bb1af_17) : (i64, i64) -> i64
      %bb1af_21 = "braid.and"(%bb1af_19, %bb1af_20) : (i64, i64) -> i64
      %bb1af_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1af_23 = "braid.and"(%bb1af_21, %bb1af_22) : (i64, i64) -> i64
      "braid.setf"(%bb1af_23) {flag = "of"} : (i64) -> ()
      %bb1af_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1af_24) {flag = "af"} : (i64) -> ()
      %bb1af_32 = "braid.zext"(%bb1af_17) {bits = 8 : i64} : (i64) -> i64
      %bb1af_33 = "braid.popcnt"(%bb1af_32) : (i64) -> i64
      %bb1af_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1af_35 = "braid.and"(%bb1af_33, %bb1af_34) : (i64, i64) -> i64
      %bb1af_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1af_37 = "braid.eq"(%bb1af_35, %bb1af_36) : (i64, i64) -> i64
      "braid.setf"(%bb1af_37) {flag = "pf"} : (i64) -> ()
      %bb1af_38 = "braid.eq"(%bb1af_17, %bb1af_36) : (i64, i64) -> i64
      "braid.setf"(%bb1af_38) {flag = "zf"} : (i64) -> ()
      %bb1af_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1af_40 = "braid.and"(%bb1af_17, %bb1af_39) : (i64, i64) -> i64
      "braid.setf"(%bb1af_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1af_17) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb1b2] : () -> ()
    ^bb1b2:  // 0x4012b2
      %bb1b2_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1b2_0 = "braid.zext"(%bb1b2_1) {bits = 32 : i64} : (i64) -> i64
      %bb1b2_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bb1b2_8 = "braid.zext"(%bb1b2_9) {bits = 32 : i64} : (i64) -> i64
      %bb1b2_16 = "braid.add"(%bb1b2_0, %bb1b2_8) : (i64, i64) -> i64
      %bb1b2_17 = "braid.zext"(%bb1b2_16) {bits = 32 : i64} : (i64) -> i64
      %bb1b2_18 = "braid.ult"(%bb1b2_17, %bb1b2_0) : (i64, i64) -> i64
      "braid.setf"(%bb1b2_18) {flag = "cf"} : (i64) -> ()
      %bb1b2_19 = "braid.xor"(%bb1b2_0, %bb1b2_17) : (i64, i64) -> i64
      %bb1b2_20 = "braid.xor"(%bb1b2_8, %bb1b2_17) : (i64, i64) -> i64
      %bb1b2_21 = "braid.and"(%bb1b2_19, %bb1b2_20) : (i64, i64) -> i64
      %bb1b2_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1b2_23 = "braid.and"(%bb1b2_21, %bb1b2_22) : (i64, i64) -> i64
      "braid.setf"(%bb1b2_23) {flag = "of"} : (i64) -> ()
      %bb1b2_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1b2_24) {flag = "af"} : (i64) -> ()
      %bb1b2_32 = "braid.zext"(%bb1b2_17) {bits = 8 : i64} : (i64) -> i64
      %bb1b2_33 = "braid.popcnt"(%bb1b2_32) : (i64) -> i64
      %bb1b2_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1b2_35 = "braid.and"(%bb1b2_33, %bb1b2_34) : (i64, i64) -> i64
      %bb1b2_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b2_37 = "braid.eq"(%bb1b2_35, %bb1b2_36) : (i64, i64) -> i64
      "braid.setf"(%bb1b2_37) {flag = "pf"} : (i64) -> ()
      %bb1b2_38 = "braid.eq"(%bb1b2_17, %bb1b2_36) : (i64, i64) -> i64
      "braid.setf"(%bb1b2_38) {flag = "zf"} : (i64) -> ()
      %bb1b2_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1b2_40 = "braid.and"(%bb1b2_17, %bb1b2_39) : (i64, i64) -> i64
      "braid.setf"(%bb1b2_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1b2_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb1b5] : () -> ()
    ^bb1b5:  // 0x4012b5
      %bb1b5_0 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1b5_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1b5_16 = "braid.add"(%bb1b5_0, %bb1b5_8) : (i64, i64) -> i64
      %bb1b5_18 = "braid.ult"(%bb1b5_16, %bb1b5_0) : (i64, i64) -> i64
      "braid.setf"(%bb1b5_18) {flag = "cf"} : (i64) -> ()
      %bb1b5_19 = "braid.xor"(%bb1b5_0, %bb1b5_16) : (i64, i64) -> i64
      %bb1b5_20 = "braid.xor"(%bb1b5_8, %bb1b5_16) : (i64, i64) -> i64
      %bb1b5_21 = "braid.and"(%bb1b5_19, %bb1b5_20) : (i64, i64) -> i64
      %bb1b5_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1b5_23 = "braid.and"(%bb1b5_21, %bb1b5_22) : (i64, i64) -> i64
      "braid.setf"(%bb1b5_23) {flag = "of"} : (i64) -> ()
      %bb1b5_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1b5_24) {flag = "af"} : (i64) -> ()
      %bb1b5_32 = "braid.zext"(%bb1b5_16) {bits = 8 : i64} : (i64) -> i64
      %bb1b5_33 = "braid.popcnt"(%bb1b5_32) : (i64) -> i64
      %bb1b5_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1b5_35 = "braid.and"(%bb1b5_33, %bb1b5_34) : (i64, i64) -> i64
      %bb1b5_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b5_37 = "braid.eq"(%bb1b5_35, %bb1b5_36) : (i64, i64) -> i64
      "braid.setf"(%bb1b5_37) {flag = "pf"} : (i64) -> ()
      %bb1b5_38 = "braid.eq"(%bb1b5_16, %bb1b5_36) : (i64, i64) -> i64
      "braid.setf"(%bb1b5_38) {flag = "zf"} : (i64) -> ()
      %bb1b5_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1b5_40 = "braid.and"(%bb1b5_16, %bb1b5_39) : (i64, i64) -> i64
      "braid.setf"(%bb1b5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1b5_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1b9] : () -> ()
    ^bb1b9:  // 0x4012b9
      %bb1b9_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1b9_8 = "braid.const"() {value = 256 : i64} : () -> i64
      %bb1b9_16 = "braid.sub"(%bb1b9_0, %bb1b9_8) : (i64, i64) -> i64
      %bb1b9_18 = "braid.ult"(%bb1b9_0, %bb1b9_8) : (i64, i64) -> i64
      "braid.setf"(%bb1b9_18) {flag = "cf"} : (i64) -> ()
      %bb1b9_19 = "braid.xor"(%bb1b9_0, %bb1b9_8) : (i64, i64) -> i64
      %bb1b9_20 = "braid.xor"(%bb1b9_0, %bb1b9_16) : (i64, i64) -> i64
      %bb1b9_21 = "braid.and"(%bb1b9_19, %bb1b9_20) : (i64, i64) -> i64
      %bb1b9_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1b9_23 = "braid.and"(%bb1b9_21, %bb1b9_22) : (i64, i64) -> i64
      "braid.setf"(%bb1b9_23) {flag = "of"} : (i64) -> ()
      %bb1b9_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1b9_24) {flag = "af"} : (i64) -> ()
      %bb1b9_32 = "braid.zext"(%bb1b9_16) {bits = 8 : i64} : (i64) -> i64
      %bb1b9_33 = "braid.popcnt"(%bb1b9_32) : (i64) -> i64
      %bb1b9_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1b9_35 = "braid.and"(%bb1b9_33, %bb1b9_34) : (i64, i64) -> i64
      %bb1b9_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1b9_37 = "braid.eq"(%bb1b9_35, %bb1b9_36) : (i64, i64) -> i64
      "braid.setf"(%bb1b9_37) {flag = "pf"} : (i64) -> ()
      %bb1b9_38 = "braid.eq"(%bb1b9_16, %bb1b9_36) : (i64, i64) -> i64
      "braid.setf"(%bb1b9_38) {flag = "zf"} : (i64) -> ()
      %bb1b9_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb1b9_40 = "braid.and"(%bb1b9_16, %bb1b9_39) : (i64, i64) -> i64
      "braid.setf"(%bb1b9_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb1bf] : () -> ()
    ^bb1bf:  // 0x4012bf
      %bb1bf_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb1bf_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1bf_0 = "braid.eq"(%bb1bf_1, %bb1bf_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb1bf_0)[^bb130, ^bb1c5] : (i64) -> ()
    ^bb1c5:  // 0x4012c5
      %bb1c5_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb1c5_0 = "braid.zext"(%bb1c5_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c5_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb1c5_8 = "braid.zext"(%bb1c5_9) {bits = 32 : i64} : (i64) -> i64
      %bb1c5_16 = "braid.add"(%bb1c5_0, %bb1c5_8) : (i64, i64) -> i64
      %bb1c5_17 = "braid.zext"(%bb1c5_16) {bits = 32 : i64} : (i64) -> i64
      %bb1c5_18 = "braid.ult"(%bb1c5_17, %bb1c5_0) : (i64, i64) -> i64
      "braid.setf"(%bb1c5_18) {flag = "cf"} : (i64) -> ()
      %bb1c5_19 = "braid.xor"(%bb1c5_0, %bb1c5_17) : (i64, i64) -> i64
      %bb1c5_20 = "braid.xor"(%bb1c5_8, %bb1c5_17) : (i64, i64) -> i64
      %bb1c5_21 = "braid.and"(%bb1c5_19, %bb1c5_20) : (i64, i64) -> i64
      %bb1c5_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1c5_23 = "braid.and"(%bb1c5_21, %bb1c5_22) : (i64, i64) -> i64
      "braid.setf"(%bb1c5_23) {flag = "of"} : (i64) -> ()
      %bb1c5_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1c5_24) {flag = "af"} : (i64) -> ()
      %bb1c5_32 = "braid.zext"(%bb1c5_17) {bits = 8 : i64} : (i64) -> i64
      %bb1c5_33 = "braid.popcnt"(%bb1c5_32) : (i64) -> i64
      %bb1c5_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1c5_35 = "braid.and"(%bb1c5_33, %bb1c5_34) : (i64, i64) -> i64
      %bb1c5_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c5_37 = "braid.eq"(%bb1c5_35, %bb1c5_36) : (i64, i64) -> i64
      "braid.setf"(%bb1c5_37) {flag = "pf"} : (i64) -> ()
      %bb1c5_38 = "braid.eq"(%bb1c5_17, %bb1c5_36) : (i64, i64) -> i64
      "braid.setf"(%bb1c5_38) {flag = "zf"} : (i64) -> ()
      %bb1c5_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1c5_40 = "braid.and"(%bb1c5_17, %bb1c5_39) : (i64, i64) -> i64
      "braid.setf"(%bb1c5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1c5_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb1c8] : () -> ()
    ^bb1c8:  // 0x4012c8
      %bb1c8_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb1c8_0 = "braid.zext"(%bb1c8_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c8_8 = "braid.get"() {reg = "rdi"} : () -> i64
      "braid.store"(%bb1c8_8, %bb1c8_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1cb] : () -> ()
    ^bb1cb:  // 0x4012cb
      %bb1cb_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1cb_3 = "braid.const"() {value = -124 : i64} : () -> i64
      %bb1cb_1 = "braid.add"(%bb1cb_2, %bb1cb_3) : (i64, i64) -> i64
      %bb1cb_0 = "braid.load"(%bb1cb_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1cb_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1cf] : () -> ()
    ^bb1cf:  // 0x4012cf
      %bb1cf_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb1cf_0 = "braid.zext"(%bb1cf_1) {bits = 32 : i64} : (i64) -> i64
      %bb1cf_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1cf_8 = "braid.zext"(%bb1cf_9) {bits = 32 : i64} : (i64) -> i64
      %bb1cf_16 = "braid.add"(%bb1cf_0, %bb1cf_8) : (i64, i64) -> i64
      %bb1cf_17 = "braid.zext"(%bb1cf_16) {bits = 32 : i64} : (i64) -> i64
      %bb1cf_18 = "braid.ult"(%bb1cf_17, %bb1cf_0) : (i64, i64) -> i64
      "braid.setf"(%bb1cf_18) {flag = "cf"} : (i64) -> ()
      %bb1cf_19 = "braid.xor"(%bb1cf_0, %bb1cf_17) : (i64, i64) -> i64
      %bb1cf_20 = "braid.xor"(%bb1cf_8, %bb1cf_17) : (i64, i64) -> i64
      %bb1cf_21 = "braid.and"(%bb1cf_19, %bb1cf_20) : (i64, i64) -> i64
      %bb1cf_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1cf_23 = "braid.and"(%bb1cf_21, %bb1cf_22) : (i64, i64) -> i64
      "braid.setf"(%bb1cf_23) {flag = "of"} : (i64) -> ()
      %bb1cf_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1cf_24) {flag = "af"} : (i64) -> ()
      %bb1cf_32 = "braid.zext"(%bb1cf_17) {bits = 8 : i64} : (i64) -> i64
      %bb1cf_33 = "braid.popcnt"(%bb1cf_32) : (i64) -> i64
      %bb1cf_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1cf_35 = "braid.and"(%bb1cf_33, %bb1cf_34) : (i64, i64) -> i64
      %bb1cf_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1cf_37 = "braid.eq"(%bb1cf_35, %bb1cf_36) : (i64, i64) -> i64
      "braid.setf"(%bb1cf_37) {flag = "pf"} : (i64) -> ()
      %bb1cf_38 = "braid.eq"(%bb1cf_17, %bb1cf_36) : (i64, i64) -> i64
      "braid.setf"(%bb1cf_38) {flag = "zf"} : (i64) -> ()
      %bb1cf_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1cf_40 = "braid.and"(%bb1cf_17, %bb1cf_39) : (i64, i64) -> i64
      "braid.setf"(%bb1cf_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1cf_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1d2] : () -> ()
    ^bb1d2:  // 0x4012d2
      %bb1d2_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1d2_0 = "braid.zext"(%bb1d2_1) {bits = 32 : i64} : (i64) -> i64
      %bb1d2_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb1d2_10 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1d2_8 = "braid.add"(%bb1d2_9, %bb1d2_10) : (i64, i64) -> i64
      "braid.store"(%bb1d2_8, %bb1d2_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1d5] : () -> ()
    ^bb1d5:  // 0x4012d5
      %bb1d5_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1d5_3 = "braid.const"() {value = -120 : i64} : () -> i64
      %bb1d5_1 = "braid.add"(%bb1d5_2, %bb1d5_3) : (i64, i64) -> i64
      %bb1d5_0 = "braid.load"(%bb1d5_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1d5_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1d9] : () -> ()
    ^bb1d9:  // 0x4012d9
      %bb1d9_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb1d9_0 = "braid.zext"(%bb1d9_1) {bits = 32 : i64} : (i64) -> i64
      %bb1d9_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1d9_8 = "braid.zext"(%bb1d9_9) {bits = 32 : i64} : (i64) -> i64
      %bb1d9_16 = "braid.add"(%bb1d9_0, %bb1d9_8) : (i64, i64) -> i64
      %bb1d9_17 = "braid.zext"(%bb1d9_16) {bits = 32 : i64} : (i64) -> i64
      %bb1d9_18 = "braid.ult"(%bb1d9_17, %bb1d9_0) : (i64, i64) -> i64
      "braid.setf"(%bb1d9_18) {flag = "cf"} : (i64) -> ()
      %bb1d9_19 = "braid.xor"(%bb1d9_0, %bb1d9_17) : (i64, i64) -> i64
      %bb1d9_20 = "braid.xor"(%bb1d9_8, %bb1d9_17) : (i64, i64) -> i64
      %bb1d9_21 = "braid.and"(%bb1d9_19, %bb1d9_20) : (i64, i64) -> i64
      %bb1d9_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1d9_23 = "braid.and"(%bb1d9_21, %bb1d9_22) : (i64, i64) -> i64
      "braid.setf"(%bb1d9_23) {flag = "of"} : (i64) -> ()
      %bb1d9_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1d9_24) {flag = "af"} : (i64) -> ()
      %bb1d9_32 = "braid.zext"(%bb1d9_17) {bits = 8 : i64} : (i64) -> i64
      %bb1d9_33 = "braid.popcnt"(%bb1d9_32) : (i64) -> i64
      %bb1d9_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1d9_35 = "braid.and"(%bb1d9_33, %bb1d9_34) : (i64, i64) -> i64
      %bb1d9_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d9_37 = "braid.eq"(%bb1d9_35, %bb1d9_36) : (i64, i64) -> i64
      "braid.setf"(%bb1d9_37) {flag = "pf"} : (i64) -> ()
      %bb1d9_38 = "braid.eq"(%bb1d9_17, %bb1d9_36) : (i64, i64) -> i64
      "braid.setf"(%bb1d9_38) {flag = "zf"} : (i64) -> ()
      %bb1d9_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1d9_40 = "braid.and"(%bb1d9_17, %bb1d9_39) : (i64, i64) -> i64
      "braid.setf"(%bb1d9_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1d9_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1dc] : () -> ()
    ^bb1dc:  // 0x4012dc
      %bb1dc_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1dc_0 = "braid.zext"(%bb1dc_1) {bits = 32 : i64} : (i64) -> i64
      %bb1dc_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb1dc_10 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1dc_8 = "braid.add"(%bb1dc_9, %bb1dc_10) : (i64, i64) -> i64
      "braid.store"(%bb1dc_8, %bb1dc_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1df] : () -> ()
    ^bb1df:  // 0x4012df
      %bb1df_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1df_3 = "braid.const"() {value = -116 : i64} : () -> i64
      %bb1df_1 = "braid.add"(%bb1df_2, %bb1df_3) : (i64, i64) -> i64
      %bb1df_0 = "braid.load"(%bb1df_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1df_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1e3] : () -> ()
    ^bb1e3:  // 0x4012e3
      %bb1e3_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1e3_0 = "braid.zext"(%bb1e3_1) {bits = 32 : i64} : (i64) -> i64
      %bb1e3_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1e3_8 = "braid.zext"(%bb1e3_9) {bits = 32 : i64} : (i64) -> i64
      %bb1e3_16 = "braid.add"(%bb1e3_0, %bb1e3_8) : (i64, i64) -> i64
      %bb1e3_17 = "braid.zext"(%bb1e3_16) {bits = 32 : i64} : (i64) -> i64
      %bb1e3_18 = "braid.ult"(%bb1e3_17, %bb1e3_0) : (i64, i64) -> i64
      "braid.setf"(%bb1e3_18) {flag = "cf"} : (i64) -> ()
      %bb1e3_19 = "braid.xor"(%bb1e3_0, %bb1e3_17) : (i64, i64) -> i64
      %bb1e3_20 = "braid.xor"(%bb1e3_8, %bb1e3_17) : (i64, i64) -> i64
      %bb1e3_21 = "braid.and"(%bb1e3_19, %bb1e3_20) : (i64, i64) -> i64
      %bb1e3_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1e3_23 = "braid.and"(%bb1e3_21, %bb1e3_22) : (i64, i64) -> i64
      "braid.setf"(%bb1e3_23) {flag = "of"} : (i64) -> ()
      %bb1e3_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1e3_24) {flag = "af"} : (i64) -> ()
      %bb1e3_32 = "braid.zext"(%bb1e3_17) {bits = 8 : i64} : (i64) -> i64
      %bb1e3_33 = "braid.popcnt"(%bb1e3_32) : (i64) -> i64
      %bb1e3_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1e3_35 = "braid.and"(%bb1e3_33, %bb1e3_34) : (i64, i64) -> i64
      %bb1e3_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e3_37 = "braid.eq"(%bb1e3_35, %bb1e3_36) : (i64, i64) -> i64
      "braid.setf"(%bb1e3_37) {flag = "pf"} : (i64) -> ()
      %bb1e3_38 = "braid.eq"(%bb1e3_17, %bb1e3_36) : (i64, i64) -> i64
      "braid.setf"(%bb1e3_38) {flag = "zf"} : (i64) -> ()
      %bb1e3_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1e3_40 = "braid.and"(%bb1e3_17, %bb1e3_39) : (i64, i64) -> i64
      "braid.setf"(%bb1e3_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1e3_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1e5] : () -> ()
    ^bb1e5:  // 0x4012e5
      %bb1e5_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1e5_0 = "braid.zext"(%bb1e5_1) {bits = 32 : i64} : (i64) -> i64
      %bb1e5_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb1e5_10 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb1e5_8 = "braid.add"(%bb1e5_9, %bb1e5_10) : (i64, i64) -> i64
      "braid.store"(%bb1e5_8, %bb1e5_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1e8] : () -> ()
    ^bb1e8:  // 0x4012e8
      %bb1e8_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1e8_3 = "braid.const"() {value = -112 : i64} : () -> i64
      %bb1e8_1 = "braid.add"(%bb1e8_2, %bb1e8_3) : (i64, i64) -> i64
      %bb1e8_0 = "braid.load"(%bb1e8_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1e8_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1ec] : () -> ()
    ^bb1ec:  // 0x4012ec
      %bb1ec_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb1ec_0 = "braid.zext"(%bb1ec_1) {bits = 32 : i64} : (i64) -> i64
      %bb1ec_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1ec_8 = "braid.zext"(%bb1ec_9) {bits = 32 : i64} : (i64) -> i64
      %bb1ec_16 = "braid.add"(%bb1ec_0, %bb1ec_8) : (i64, i64) -> i64
      %bb1ec_17 = "braid.zext"(%bb1ec_16) {bits = 32 : i64} : (i64) -> i64
      %bb1ec_18 = "braid.ult"(%bb1ec_17, %bb1ec_0) : (i64, i64) -> i64
      "braid.setf"(%bb1ec_18) {flag = "cf"} : (i64) -> ()
      %bb1ec_19 = "braid.xor"(%bb1ec_0, %bb1ec_17) : (i64, i64) -> i64
      %bb1ec_20 = "braid.xor"(%bb1ec_8, %bb1ec_17) : (i64, i64) -> i64
      %bb1ec_21 = "braid.and"(%bb1ec_19, %bb1ec_20) : (i64, i64) -> i64
      %bb1ec_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1ec_23 = "braid.and"(%bb1ec_21, %bb1ec_22) : (i64, i64) -> i64
      "braid.setf"(%bb1ec_23) {flag = "of"} : (i64) -> ()
      %bb1ec_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1ec_24) {flag = "af"} : (i64) -> ()
      %bb1ec_32 = "braid.zext"(%bb1ec_17) {bits = 8 : i64} : (i64) -> i64
      %bb1ec_33 = "braid.popcnt"(%bb1ec_32) : (i64) -> i64
      %bb1ec_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1ec_35 = "braid.and"(%bb1ec_33, %bb1ec_34) : (i64, i64) -> i64
      %bb1ec_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1ec_37 = "braid.eq"(%bb1ec_35, %bb1ec_36) : (i64, i64) -> i64
      "braid.setf"(%bb1ec_37) {flag = "pf"} : (i64) -> ()
      %bb1ec_38 = "braid.eq"(%bb1ec_17, %bb1ec_36) : (i64, i64) -> i64
      "braid.setf"(%bb1ec_38) {flag = "zf"} : (i64) -> ()
      %bb1ec_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1ec_40 = "braid.and"(%bb1ec_17, %bb1ec_39) : (i64, i64) -> i64
      "braid.setf"(%bb1ec_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1ec_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1ef] : () -> ()
    ^bb1ef:  // 0x4012ef
      %bb1ef_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1ef_0 = "braid.zext"(%bb1ef_1) {bits = 32 : i64} : (i64) -> i64
      %bb1ef_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb1ef_10 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1ef_8 = "braid.add"(%bb1ef_9, %bb1ef_10) : (i64, i64) -> i64
      "braid.store"(%bb1ef_8, %bb1ef_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1f2] : () -> ()
    ^bb1f2:  // 0x4012f2
      %bb1f2_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1f2_3 = "braid.const"() {value = -108 : i64} : () -> i64
      %bb1f2_1 = "braid.add"(%bb1f2_2, %bb1f2_3) : (i64, i64) -> i64
      %bb1f2_0 = "braid.load"(%bb1f2_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1f2_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1f6] : () -> ()
    ^bb1f6:  // 0x4012f6
      %bb1f6_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb1f6_0 = "braid.zext"(%bb1f6_1) {bits = 32 : i64} : (i64) -> i64
      %bb1f6_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1f6_8 = "braid.zext"(%bb1f6_9) {bits = 32 : i64} : (i64) -> i64
      %bb1f6_16 = "braid.add"(%bb1f6_0, %bb1f6_8) : (i64, i64) -> i64
      %bb1f6_17 = "braid.zext"(%bb1f6_16) {bits = 32 : i64} : (i64) -> i64
      %bb1f6_18 = "braid.ult"(%bb1f6_17, %bb1f6_0) : (i64, i64) -> i64
      "braid.setf"(%bb1f6_18) {flag = "cf"} : (i64) -> ()
      %bb1f6_19 = "braid.xor"(%bb1f6_0, %bb1f6_17) : (i64, i64) -> i64
      %bb1f6_20 = "braid.xor"(%bb1f6_8, %bb1f6_17) : (i64, i64) -> i64
      %bb1f6_21 = "braid.and"(%bb1f6_19, %bb1f6_20) : (i64, i64) -> i64
      %bb1f6_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1f6_23 = "braid.and"(%bb1f6_21, %bb1f6_22) : (i64, i64) -> i64
      "braid.setf"(%bb1f6_23) {flag = "of"} : (i64) -> ()
      %bb1f6_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1f6_24) {flag = "af"} : (i64) -> ()
      %bb1f6_32 = "braid.zext"(%bb1f6_17) {bits = 8 : i64} : (i64) -> i64
      %bb1f6_33 = "braid.popcnt"(%bb1f6_32) : (i64) -> i64
      %bb1f6_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1f6_35 = "braid.and"(%bb1f6_33, %bb1f6_34) : (i64, i64) -> i64
      %bb1f6_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1f6_37 = "braid.eq"(%bb1f6_35, %bb1f6_36) : (i64, i64) -> i64
      "braid.setf"(%bb1f6_37) {flag = "pf"} : (i64) -> ()
      %bb1f6_38 = "braid.eq"(%bb1f6_17, %bb1f6_36) : (i64, i64) -> i64
      "braid.setf"(%bb1f6_38) {flag = "zf"} : (i64) -> ()
      %bb1f6_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1f6_40 = "braid.and"(%bb1f6_17, %bb1f6_39) : (i64, i64) -> i64
      "braid.setf"(%bb1f6_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1f6_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1f8] : () -> ()
    ^bb1f8:  // 0x4012f8
      %bb1f8_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1f8_0 = "braid.zext"(%bb1f8_1) {bits = 32 : i64} : (i64) -> i64
      %bb1f8_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb1f8_10 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb1f8_8 = "braid.add"(%bb1f8_9, %bb1f8_10) : (i64, i64) -> i64
      "braid.store"(%bb1f8_8, %bb1f8_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1fb] : () -> ()
    ^bb1fb:  // 0x4012fb
      %bb1fb_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1fb_3 = "braid.const"() {value = -104 : i64} : () -> i64
      %bb1fb_1 = "braid.add"(%bb1fb_2, %bb1fb_3) : (i64, i64) -> i64
      %bb1fb_0 = "braid.load"(%bb1fb_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1fb_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1ff] : () -> ()
    ^bb1ff:  // 0x4012ff
      %bb1ff_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb1ff_0 = "braid.zext"(%bb1ff_1) {bits = 32 : i64} : (i64) -> i64
      %bb1ff_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1ff_8 = "braid.zext"(%bb1ff_9) {bits = 32 : i64} : (i64) -> i64
      %bb1ff_16 = "braid.add"(%bb1ff_0, %bb1ff_8) : (i64, i64) -> i64
      %bb1ff_17 = "braid.zext"(%bb1ff_16) {bits = 32 : i64} : (i64) -> i64
      %bb1ff_18 = "braid.ult"(%bb1ff_17, %bb1ff_0) : (i64, i64) -> i64
      "braid.setf"(%bb1ff_18) {flag = "cf"} : (i64) -> ()
      %bb1ff_19 = "braid.xor"(%bb1ff_0, %bb1ff_17) : (i64, i64) -> i64
      %bb1ff_20 = "braid.xor"(%bb1ff_8, %bb1ff_17) : (i64, i64) -> i64
      %bb1ff_21 = "braid.and"(%bb1ff_19, %bb1ff_20) : (i64, i64) -> i64
      %bb1ff_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1ff_23 = "braid.and"(%bb1ff_21, %bb1ff_22) : (i64, i64) -> i64
      "braid.setf"(%bb1ff_23) {flag = "of"} : (i64) -> ()
      %bb1ff_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1ff_24) {flag = "af"} : (i64) -> ()
      %bb1ff_32 = "braid.zext"(%bb1ff_17) {bits = 8 : i64} : (i64) -> i64
      %bb1ff_33 = "braid.popcnt"(%bb1ff_32) : (i64) -> i64
      %bb1ff_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1ff_35 = "braid.and"(%bb1ff_33, %bb1ff_34) : (i64, i64) -> i64
      %bb1ff_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1ff_37 = "braid.eq"(%bb1ff_35, %bb1ff_36) : (i64, i64) -> i64
      "braid.setf"(%bb1ff_37) {flag = "pf"} : (i64) -> ()
      %bb1ff_38 = "braid.eq"(%bb1ff_17, %bb1ff_36) : (i64, i64) -> i64
      "braid.setf"(%bb1ff_38) {flag = "zf"} : (i64) -> ()
      %bb1ff_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1ff_40 = "braid.and"(%bb1ff_17, %bb1ff_39) : (i64, i64) -> i64
      "braid.setf"(%bb1ff_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1ff_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb202] : () -> ()
    ^bb202:  // 0x401302
      %bb202_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb202_0 = "braid.zext"(%bb202_1) {bits = 32 : i64} : (i64) -> i64
      %bb202_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb202_10 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb202_8 = "braid.add"(%bb202_9, %bb202_10) : (i64, i64) -> i64
      "braid.store"(%bb202_8, %bb202_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb205] : () -> ()
    ^bb205:  // 0x401305
      %bb205_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb205_3 = "braid.const"() {value = -100 : i64} : () -> i64
      %bb205_1 = "braid.add"(%bb205_2, %bb205_3) : (i64, i64) -> i64
      %bb205_0 = "braid.load"(%bb205_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb205_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb209] : () -> ()
    ^bb209:  // 0x401309
      %bb209_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb209_0 = "braid.zext"(%bb209_1) {bits = 32 : i64} : (i64) -> i64
      %bb209_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb209_8 = "braid.zext"(%bb209_9) {bits = 32 : i64} : (i64) -> i64
      %bb209_16 = "braid.add"(%bb209_0, %bb209_8) : (i64, i64) -> i64
      %bb209_17 = "braid.zext"(%bb209_16) {bits = 32 : i64} : (i64) -> i64
      %bb209_18 = "braid.ult"(%bb209_17, %bb209_0) : (i64, i64) -> i64
      "braid.setf"(%bb209_18) {flag = "cf"} : (i64) -> ()
      %bb209_19 = "braid.xor"(%bb209_0, %bb209_17) : (i64, i64) -> i64
      %bb209_20 = "braid.xor"(%bb209_8, %bb209_17) : (i64, i64) -> i64
      %bb209_21 = "braid.and"(%bb209_19, %bb209_20) : (i64, i64) -> i64
      %bb209_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb209_23 = "braid.and"(%bb209_21, %bb209_22) : (i64, i64) -> i64
      "braid.setf"(%bb209_23) {flag = "of"} : (i64) -> ()
      %bb209_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb209_24) {flag = "af"} : (i64) -> ()
      %bb209_32 = "braid.zext"(%bb209_17) {bits = 8 : i64} : (i64) -> i64
      %bb209_33 = "braid.popcnt"(%bb209_32) : (i64) -> i64
      %bb209_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb209_35 = "braid.and"(%bb209_33, %bb209_34) : (i64, i64) -> i64
      %bb209_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb209_37 = "braid.eq"(%bb209_35, %bb209_36) : (i64, i64) -> i64
      "braid.setf"(%bb209_37) {flag = "pf"} : (i64) -> ()
      %bb209_38 = "braid.eq"(%bb209_17, %bb209_36) : (i64, i64) -> i64
      "braid.setf"(%bb209_38) {flag = "zf"} : (i64) -> ()
      %bb209_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb209_40 = "braid.and"(%bb209_17, %bb209_39) : (i64, i64) -> i64
      "braid.setf"(%bb209_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb209_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb20b] : () -> ()
    ^bb20b:  // 0x40130b
      %bb20b_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb20b_0 = "braid.zext"(%bb20b_1) {bits = 32 : i64} : (i64) -> i64
      %bb20b_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb20b_10 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb20b_8 = "braid.add"(%bb20b_9, %bb20b_10) : (i64, i64) -> i64
      "braid.store"(%bb20b_8, %bb20b_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb20e] : () -> ()
    ^bb20e:  // 0x40130e
      %bb20e_0 = "braid.const"() {value = 168 : i64} : () -> i64
      %bb20e_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb20e_16 = "braid.add"(%bb20e_0, %bb20e_8) : (i64, i64) -> i64
      %bb20e_18 = "braid.ult"(%bb20e_16, %bb20e_0) : (i64, i64) -> i64
      "braid.setf"(%bb20e_18) {flag = "cf"} : (i64) -> ()
      %bb20e_19 = "braid.xor"(%bb20e_0, %bb20e_16) : (i64, i64) -> i64
      %bb20e_20 = "braid.xor"(%bb20e_8, %bb20e_16) : (i64, i64) -> i64
      %bb20e_21 = "braid.and"(%bb20e_19, %bb20e_20) : (i64, i64) -> i64
      %bb20e_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb20e_23 = "braid.and"(%bb20e_21, %bb20e_22) : (i64, i64) -> i64
      "braid.setf"(%bb20e_23) {flag = "of"} : (i64) -> ()
      %bb20e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb20e_24) {flag = "af"} : (i64) -> ()
      %bb20e_32 = "braid.zext"(%bb20e_16) {bits = 8 : i64} : (i64) -> i64
      %bb20e_33 = "braid.popcnt"(%bb20e_32) : (i64) -> i64
      %bb20e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb20e_35 = "braid.and"(%bb20e_33, %bb20e_34) : (i64, i64) -> i64
      %bb20e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20e_37 = "braid.eq"(%bb20e_35, %bb20e_36) : (i64, i64) -> i64
      "braid.setf"(%bb20e_37) {flag = "pf"} : (i64) -> ()
      %bb20e_38 = "braid.eq"(%bb20e_16, %bb20e_36) : (i64, i64) -> i64
      "braid.setf"(%bb20e_38) {flag = "zf"} : (i64) -> ()
      %bb20e_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb20e_40 = "braid.and"(%bb20e_16, %bb20e_39) : (i64, i64) -> i64
      "braid.setf"(%bb20e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb20e_16) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br"()[^bb215] : () -> ()
    ^bb215:  // 0x401315
      %bb215_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb215_1 = "braid.load"(%bb215_0) {bytes = 8 : i64} : (i64) -> i64
      %bb215_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb215_3 = "braid.add"(%bb215_0, %bb215_2) : (i64, i64) -> i64
      "braid.set"(%bb215_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb215_1) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb216] : () -> ()
    ^bb216:  // 0x401316
      %bb216_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb216_1 = "braid.load"(%bb216_0) {bytes = 8 : i64} : (i64) -> i64
      %bb216_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb216_3 = "braid.add"(%bb216_0, %bb216_2) : (i64, i64) -> i64
      "braid.set"(%bb216_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb216_1) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb218] : () -> ()
    ^bb218:  // 0x401318
      %bb218_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb218_1 = "braid.load"(%bb218_0) {bytes = 8 : i64} : (i64) -> i64
      %bb218_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb218_3 = "braid.add"(%bb218_0, %bb218_2) : (i64, i64) -> i64
      "braid.set"(%bb218_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb218_1) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb21a] : () -> ()
    ^bb21a:  // 0x40131a
      %bb21a_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb21a_1 = "braid.load"(%bb21a_0) {bytes = 8 : i64} : (i64) -> i64
      %bb21a_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb21a_3 = "braid.add"(%bb21a_0, %bb21a_2) : (i64, i64) -> i64
      "braid.set"(%bb21a_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb21a_1) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb21c] : () -> ()
    ^bb21c:  // 0x40131c
      %bb21c_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb21c_1 = "braid.load"(%bb21c_0) {bytes = 8 : i64} : (i64) -> i64
      %bb21c_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb21c_3 = "braid.add"(%bb21c_0, %bb21c_2) : (i64, i64) -> i64
      "braid.set"(%bb21c_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb21c_1) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb21e] : () -> ()
    ^bb21e:  // 0x40131e
      %bb21e_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb21e_1 = "braid.load"(%bb21e_0) {bytes = 8 : i64} : (i64) -> i64
      %bb21e_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb21e_3 = "braid.add"(%bb21e_0, %bb21e_2) : (i64, i64) -> i64
      "braid.set"(%bb21e_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb21e_1) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb21f] : () -> ()
    ^bb21f:  // 0x40131f
      %bb21f_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb21f_1 = "braid.load"(%bb21f_0) {bytes = 8 : i64} : (i64) -> i64
      %bb21f_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb21f_3 = "braid.add"(%bb21f_0, %bb21f_2) : (i64, i64) -> i64
      "braid.set"(%bb21f_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb21f_1) : (i64) -> ()
  }) {sym_name = "sha256_compress", entry = 4198656 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
