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
}) {arch = "x86_64"} : () -> ()
