"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
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
      "braid_cf.br"()[^bb2] : () -> ()
    ^bb2:  // 0x401002
      %bb2_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb2_8 = "braid.get"() {reg = "rcx"} : () -> i64
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
      "braid_cf.cond_br"(%bb5_0)[^bb33, ^bb7] : (i64) -> ()
    ^bb7:  // 0x401007
      %bb7_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb7_0 = "braid.zext"(%bb7_1) {bits = 32 : i64} : (i64) -> i64
      %bb7_9 = "braid.get"() {reg = "r8"} : () -> i64
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
      "braid.set"(%bb7_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bba] : () -> ()
    ^bba:  // 0x40100a
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401010
      %bb10_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb10_3 = "braid.get"() {reg = "r8"} : () -> i64
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
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x401014
      %bb14_0 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb14_8 = "braid.get"() {reg = "r9"} : () -> i64
      %bb14_9 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb14_10 = "braid.and"(%bb14_8, %bb14_9) : (i64, i64) -> i64
      %bb14_11 = "braid.or"(%bb14_10, %bb14_0) : (i64, i64) -> i64
      "braid.set"(%bb14_11) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x401018
      %bb18_2 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb18_3 = "braid.get"() {reg = "r8"} : () -> i64
      %bb18_4 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb18_5 = "braid.mul"(%bb18_3, %bb18_4) : (i64, i64) -> i64
      %bb18_6 = "braid.add"(%bb18_2, %bb18_5) : (i64, i64) -> i64
      %bb18_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18_1 = "braid.add"(%bb18_6, %bb18_7) : (i64, i64) -> i64
      %bb18_0 = "braid.load"(%bb18_1) {bytes = 8 : i64} : (i64) -> i64
      %bb18_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb18_16 = "braid.add"(%bb18_0, %bb18_8) : (i64, i64) -> i64
      %bb18_18 = "braid.ult"(%bb18_16, %bb18_0) : (i64, i64) -> i64
      "braid.setf"(%bb18_18) {flag = "cf"} : (i64) -> ()
      %bb18_19 = "braid.xor"(%bb18_0, %bb18_16) : (i64, i64) -> i64
      %bb18_20 = "braid.xor"(%bb18_8, %bb18_16) : (i64, i64) -> i64
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
      "braid.set"(%bb18_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x40101c
      %bb1c_0 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb1c_8 = "braid.get"() {reg = "r10"} : () -> i64
      %bb1c_9 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb1c_10 = "braid.and"(%bb1c_8, %bb1c_9) : (i64, i64) -> i64
      %bb1c_11 = "braid.or"(%bb1c_10, %bb1c_0) : (i64, i64) -> i64
      "braid.set"(%bb1c_11) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x401020
      %bb20_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb20_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb20_10 = "braid.get"() {reg = "r8"} : () -> i64
      %bb20_11 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb20_12 = "braid.mul"(%bb20_10, %bb20_11) : (i64, i64) -> i64
      %bb20_13 = "braid.add"(%bb20_9, %bb20_12) : (i64, i64) -> i64
      %bb20_14 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_8 = "braid.add"(%bb20_13, %bb20_14) : (i64, i64) -> i64
      "braid.store"(%bb20_8, %bb20_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x401024
      %bb24_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb24_0 = "braid.zext"(%bb24_1) {bits = 8 : i64} : (i64) -> i64
      %bb24_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb24_8 = "braid.zext"(%bb24_9) {bits = 8 : i64} : (i64) -> i64
      %bb24_16 = "braid.or"(%bb24_0, %bb24_8) : (i64, i64) -> i64
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
      %bb24_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb24_40 = "braid.and"(%bb24_16, %bb24_39) : (i64, i64) -> i64
      "braid.setf"(%bb24_40) {flag = "sf"} : (i64) -> ()
      %bb24_48 = "braid.get"() {reg = "r10"} : () -> i64
      %bb24_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb24_50 = "braid.and"(%bb24_48, %bb24_49) : (i64, i64) -> i64
      %bb24_51 = "braid.or"(%bb24_50, %bb24_16) : (i64, i64) -> i64
      "braid.set"(%bb24_51) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb27] : () -> ()
    ^bb27:  // 0x401027
      %bb27_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb27_0 = "braid.zext"(%bb27_1) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bb27_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb2b] : () -> ()
    ^bb2b:  // 0x40102b
      %bb2b_0 = "braid.get"() {reg = "r8"} : () -> i64
      %bb2b_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2b_16 = "braid.add"(%bb2b_0, %bb2b_8) : (i64, i64) -> i64
      %bb2b_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb2b_20 = "braid.eq"(%bb2b_16, %bb2b_19) : (i64, i64) -> i64
      "braid.setf"(%bb2b_20) {flag = "of"} : (i64) -> ()
      %bb2b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb2b_24) {flag = "af"} : (i64) -> ()
      %bb2b_32 = "braid.zext"(%bb2b_16) {bits = 8 : i64} : (i64) -> i64
      %bb2b_33 = "braid.popcnt"(%bb2b_32) : (i64) -> i64
      %bb2b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2b_35 = "braid.and"(%bb2b_33, %bb2b_34) : (i64, i64) -> i64
      %bb2b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2b_37 = "braid.eq"(%bb2b_35, %bb2b_36) : (i64, i64) -> i64
      "braid.setf"(%bb2b_37) {flag = "pf"} : (i64) -> ()
      %bb2b_38 = "braid.eq"(%bb2b_16, %bb2b_36) : (i64, i64) -> i64
      "braid.setf"(%bb2b_38) {flag = "zf"} : (i64) -> ()
      %bb2b_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb2b_40 = "braid.and"(%bb2b_16, %bb2b_39) : (i64, i64) -> i64
      "braid.setf"(%bb2b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb2b_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb2e] : () -> ()
    ^bb2e:  // 0x40102e
      %bb2e_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb2e_8 = "braid.get"() {reg = "r8"} : () -> i64
      %bb2e_16 = "braid.sub"(%bb2e_0, %bb2e_8) : (i64, i64) -> i64
      %bb2e_18 = "braid.ult"(%bb2e_0, %bb2e_8) : (i64, i64) -> i64
      "braid.setf"(%bb2e_18) {flag = "cf"} : (i64) -> ()
      %bb2e_19 = "braid.xor"(%bb2e_0, %bb2e_8) : (i64, i64) -> i64
      %bb2e_20 = "braid.xor"(%bb2e_0, %bb2e_16) : (i64, i64) -> i64
      %bb2e_21 = "braid.and"(%bb2e_19, %bb2e_20) : (i64, i64) -> i64
      %bb2e_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb2e_23 = "braid.and"(%bb2e_21, %bb2e_22) : (i64, i64) -> i64
      "braid.setf"(%bb2e_23) {flag = "of"} : (i64) -> ()
      %bb2e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb2e_24) {flag = "af"} : (i64) -> ()
      %bb2e_32 = "braid.zext"(%bb2e_16) {bits = 8 : i64} : (i64) -> i64
      %bb2e_33 = "braid.popcnt"(%bb2e_32) : (i64) -> i64
      %bb2e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2e_35 = "braid.and"(%bb2e_33, %bb2e_34) : (i64, i64) -> i64
      %bb2e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2e_37 = "braid.eq"(%bb2e_35, %bb2e_36) : (i64, i64) -> i64
      "braid.setf"(%bb2e_37) {flag = "pf"} : (i64) -> ()
      %bb2e_38 = "braid.eq"(%bb2e_16, %bb2e_36) : (i64, i64) -> i64
      "braid.setf"(%bb2e_38) {flag = "zf"} : (i64) -> ()
      %bb2e_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb2e_40 = "braid.and"(%bb2e_16, %bb2e_39) : (i64, i64) -> i64
      "braid.setf"(%bb2e_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb31] : () -> ()
    ^bb31:  // 0x401031
      %bb31_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb31_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb31_0 = "braid.eq"(%bb31_1, %bb31_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb31_0)[^bb10, ^bb33] : (i64) -> ()
    ^bb33:  // 0x401033
      %bb33_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb33_1 = "braid.load"(%bb33_0) {bytes = 8 : i64} : (i64) -> i64
      %bb33_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb33_3 = "braid.add"(%bb33_0, %bb33_2) : (i64, i64) -> i64
      "braid.set"(%bb33_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb33_1) : (i64) -> ()
  }) {sym_name = "add_limbs", entry = 4198400 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
