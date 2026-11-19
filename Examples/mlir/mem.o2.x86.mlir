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
      "braid_cf.cond_br"(%bb3_0)[^bb6f, ^bb5] : (i64) -> ()
    ^bb5:  // 0x401005
      %bb5_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb5_0 = "braid.zext"(%bb5_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb5_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb7] : () -> ()
    ^bb7:  // 0x401007
      %bb7_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb7_0 = "braid.zext"(%bb7_1) {bits = 32 : i64} : (i64) -> i64
      %bb7_8 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb7_16 = "braid.and"(%bb7_0, %bb7_8) : (i64, i64) -> i64
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
      "braid.set"(%bb7_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bba] : () -> ()
    ^bba:  // 0x40100a
      %bba_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bba_8 = "braid.const"() {value = 4 : i64} : () -> i64
      %bba_16 = "braid.sub"(%bba_0, %bba_8) : (i64, i64) -> i64
      %bba_18 = "braid.ult"(%bba_0, %bba_8) : (i64, i64) -> i64
      "braid.setf"(%bba_18) {flag = "cf"} : (i64) -> ()
      %bba_19 = "braid.xor"(%bba_0, %bba_8) : (i64, i64) -> i64
      %bba_20 = "braid.xor"(%bba_0, %bba_16) : (i64, i64) -> i64
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
      "braid_cf.br"()[^bbe] : () -> ()
    ^bbe:  // 0x40100e
      %bbe_1 = "braid.getf"() {flag = "cf"} : () -> i64
      %bbe_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe_0 = "braid.eq"(%bbe_1, %bbe_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bbe_0)[^bb14, ^bb10] : (i64) -> ()
    ^bb10:  // 0x401010
      %bb10_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb10_0 = "braid.zext"(%bb10_1) {bits = 32 : i64} : (i64) -> i64
      %bb10_9 = "braid.get"() {reg = "rcx"} : () -> i64
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
      "braid.set"(%bb10_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb12] : () -> ()
    ^bb12:  // 0x401012
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb14:  // 0x401014
      %bb14_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb14_8 = "braid.const"() {value = -4 : i64} : () -> i64
      %bb14_16 = "braid.and"(%bb14_0, %bb14_8) : (i64, i64) -> i64
      %bb14_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb14_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb14_17) {flag = "of"} : (i64) -> ()
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
      "braid.set"(%bb14_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x401018
      %bb18_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb18_0 = "braid.zext"(%bb18_1) {bits = 32 : i64} : (i64) -> i64
      %bb18_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb18_8 = "braid.zext"(%bb18_9) {bits = 32 : i64} : (i64) -> i64
      %bb18_16 = "braid.xor"(%bb18_0, %bb18_8) : (i64, i64) -> i64
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
      %bb18_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb18_40 = "braid.and"(%bb18_16, %bb18_39) : (i64, i64) -> i64
      "braid.setf"(%bb18_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb18_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb1a] : () -> ()
    ^bb1a:  // 0x40101a
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
      %bb25_0 = "braid.zext"(%bb25_1) {bits = 8 : i64} : (i64) -> i64
      %bb25_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb25_10 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb25_11 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb25_12 = "braid.mul"(%bb25_10, %bb25_11) : (i64, i64) -> i64
      %bb25_13 = "braid.add"(%bb25_9, %bb25_12) : (i64, i64) -> i64
      %bb25_14 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb25_8 = "braid.add"(%bb25_13, %bb25_14) : (i64, i64) -> i64
      "braid.store"(%bb25_8, %bb25_0) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb29] : () -> ()
    ^bb29:  // 0x401029
      %bb29_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb29_3 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb29_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb29_5 = "braid.mul"(%bb29_3, %bb29_4) : (i64, i64) -> i64
      %bb29_6 = "braid.add"(%bb29_2, %bb29_5) : (i64, i64) -> i64
      %bb29_7 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb29_1 = "braid.add"(%bb29_6, %bb29_7) : (i64, i64) -> i64
      %bb29_0 = "braid.load"(%bb29_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb29_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb2f] : () -> ()
    ^bb2f:  // 0x40102f
      %bb2f_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb2f_0 = "braid.zext"(%bb2f_1) {bits = 8 : i64} : (i64) -> i64
      %bb2f_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb2f_10 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb2f_11 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2f_12 = "braid.mul"(%bb2f_10, %bb2f_11) : (i64, i64) -> i64
      %bb2f_13 = "braid.add"(%bb2f_9, %bb2f_12) : (i64, i64) -> i64
      %bb2f_14 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb2f_8 = "braid.add"(%bb2f_13, %bb2f_14) : (i64, i64) -> i64
      "braid.store"(%bb2f_8, %bb2f_0) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x401034
      %bb34_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb34_3 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb34_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb34_5 = "braid.mul"(%bb34_3, %bb34_4) : (i64, i64) -> i64
      %bb34_6 = "braid.add"(%bb34_2, %bb34_5) : (i64, i64) -> i64
      %bb34_7 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb34_1 = "braid.add"(%bb34_6, %bb34_7) : (i64, i64) -> i64
      %bb34_0 = "braid.load"(%bb34_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb34_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb3a] : () -> ()
    ^bb3a:  // 0x40103a
      %bb3a_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb3a_0 = "braid.zext"(%bb3a_1) {bits = 8 : i64} : (i64) -> i64
      %bb3a_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb3a_10 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb3a_11 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3a_12 = "braid.mul"(%bb3a_10, %bb3a_11) : (i64, i64) -> i64
      %bb3a_13 = "braid.add"(%bb3a_9, %bb3a_12) : (i64, i64) -> i64
      %bb3a_14 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb3a_8 = "braid.add"(%bb3a_13, %bb3a_14) : (i64, i64) -> i64
      "braid.store"(%bb3a_8, %bb3a_0) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb3f] : () -> ()
    ^bb3f:  // 0x40103f
      %bb3f_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb3f_3 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb3f_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3f_5 = "braid.mul"(%bb3f_3, %bb3f_4) : (i64, i64) -> i64
      %bb3f_6 = "braid.add"(%bb3f_2, %bb3f_5) : (i64, i64) -> i64
      %bb3f_7 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb3f_1 = "braid.add"(%bb3f_6, %bb3f_7) : (i64, i64) -> i64
      %bb3f_0 = "braid.load"(%bb3f_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb3f_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb45] : () -> ()
    ^bb45:  // 0x401045
      %bb45_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb45_0 = "braid.zext"(%bb45_1) {bits = 8 : i64} : (i64) -> i64
      %bb45_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb45_10 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb45_11 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb45_12 = "braid.mul"(%bb45_10, %bb45_11) : (i64, i64) -> i64
      %bb45_13 = "braid.add"(%bb45_9, %bb45_12) : (i64, i64) -> i64
      %bb45_14 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb45_8 = "braid.add"(%bb45_13, %bb45_14) : (i64, i64) -> i64
      "braid.store"(%bb45_8, %bb45_0) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb4a] : () -> ()
    ^bb4a:  // 0x40104a
      %bb4a_0 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb4a_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb4a_16 = "braid.add"(%bb4a_0, %bb4a_8) : (i64, i64) -> i64
      %bb4a_18 = "braid.ult"(%bb4a_16, %bb4a_0) : (i64, i64) -> i64
      "braid.setf"(%bb4a_18) {flag = "cf"} : (i64) -> ()
      %bb4a_19 = "braid.xor"(%bb4a_0, %bb4a_16) : (i64, i64) -> i64
      %bb4a_20 = "braid.xor"(%bb4a_8, %bb4a_16) : (i64, i64) -> i64
      %bb4a_21 = "braid.and"(%bb4a_19, %bb4a_20) : (i64, i64) -> i64
      %bb4a_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb4a_23 = "braid.and"(%bb4a_21, %bb4a_22) : (i64, i64) -> i64
      "braid.setf"(%bb4a_23) {flag = "of"} : (i64) -> ()
      %bb4a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb4a_24) {flag = "af"} : (i64) -> ()
      %bb4a_32 = "braid.zext"(%bb4a_16) {bits = 8 : i64} : (i64) -> i64
      %bb4a_33 = "braid.popcnt"(%bb4a_32) : (i64) -> i64
      %bb4a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4a_35 = "braid.and"(%bb4a_33, %bb4a_34) : (i64, i64) -> i64
      %bb4a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4a_37 = "braid.eq"(%bb4a_35, %bb4a_36) : (i64, i64) -> i64
      "braid.setf"(%bb4a_37) {flag = "pf"} : (i64) -> ()
      %bb4a_38 = "braid.eq"(%bb4a_16, %bb4a_36) : (i64, i64) -> i64
      "braid.setf"(%bb4a_38) {flag = "zf"} : (i64) -> ()
      %bb4a_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb4a_40 = "braid.and"(%bb4a_16, %bb4a_39) : (i64, i64) -> i64
      "braid.setf"(%bb4a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb4a_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb4e] : () -> ()
    ^bb4e:  // 0x40104e
      %bb4e_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb4e_8 = "braid.get"() {reg = "rcx"} : () -> i64
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
      "braid_cf.br"()[^bb51] : () -> ()
    ^bb51:  // 0x401051
      %bb51_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb51_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb51_0 = "braid.eq"(%bb51_1, %bb51_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb51_0)[^bb20, ^bb53] : (i64) -> ()
    ^bb53:  // 0x401053
      %bb53_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb53_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb53_16 = "braid.and"(%bb53_0, %bb53_8) : (i64, i64) -> i64
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
      %bb53_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb53_40 = "braid.and"(%bb53_16, %bb53_39) : (i64, i64) -> i64
      "braid.setf"(%bb53_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb56] : () -> ()
    ^bb56:  // 0x401056
      %bb56_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb56_0)[^bb6f, ^bb58] : (i64) -> ()
    ^bb58:  // 0x401058
      %bb58_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb58_8 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb58_16 = "braid.add"(%bb58_0, %bb58_8) : (i64, i64) -> i64
      %bb58_18 = "braid.ult"(%bb58_16, %bb58_0) : (i64, i64) -> i64
      "braid.setf"(%bb58_18) {flag = "cf"} : (i64) -> ()
      %bb58_19 = "braid.xor"(%bb58_0, %bb58_16) : (i64, i64) -> i64
      %bb58_20 = "braid.xor"(%bb58_8, %bb58_16) : (i64, i64) -> i64
      %bb58_21 = "braid.and"(%bb58_19, %bb58_20) : (i64, i64) -> i64
      %bb58_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb58_23 = "braid.and"(%bb58_21, %bb58_22) : (i64, i64) -> i64
      "braid.setf"(%bb58_23) {flag = "of"} : (i64) -> ()
      %bb58_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb58_24) {flag = "af"} : (i64) -> ()
      %bb58_32 = "braid.zext"(%bb58_16) {bits = 8 : i64} : (i64) -> i64
      %bb58_33 = "braid.popcnt"(%bb58_32) : (i64) -> i64
      %bb58_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb58_35 = "braid.and"(%bb58_33, %bb58_34) : (i64, i64) -> i64
      %bb58_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb58_37 = "braid.eq"(%bb58_35, %bb58_36) : (i64, i64) -> i64
      "braid.setf"(%bb58_37) {flag = "pf"} : (i64) -> ()
      %bb58_38 = "braid.eq"(%bb58_16, %bb58_36) : (i64, i64) -> i64
      "braid.setf"(%bb58_38) {flag = "zf"} : (i64) -> ()
      %bb58_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb58_40 = "braid.and"(%bb58_16, %bb58_39) : (i64, i64) -> i64
      "braid.setf"(%bb58_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb58_16) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb5b] : () -> ()
    ^bb5b:  // 0x40105b
      %bb5b_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb5b_8 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb5b_16 = "braid.add"(%bb5b_0, %bb5b_8) : (i64, i64) -> i64
      %bb5b_18 = "braid.ult"(%bb5b_16, %bb5b_0) : (i64, i64) -> i64
      "braid.setf"(%bb5b_18) {flag = "cf"} : (i64) -> ()
      %bb5b_19 = "braid.xor"(%bb5b_0, %bb5b_16) : (i64, i64) -> i64
      %bb5b_20 = "braid.xor"(%bb5b_8, %bb5b_16) : (i64, i64) -> i64
      %bb5b_21 = "braid.and"(%bb5b_19, %bb5b_20) : (i64, i64) -> i64
      %bb5b_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb5b_23 = "braid.and"(%bb5b_21, %bb5b_22) : (i64, i64) -> i64
      "braid.setf"(%bb5b_23) {flag = "of"} : (i64) -> ()
      %bb5b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb5b_24) {flag = "af"} : (i64) -> ()
      %bb5b_32 = "braid.zext"(%bb5b_16) {bits = 8 : i64} : (i64) -> i64
      %bb5b_33 = "braid.popcnt"(%bb5b_32) : (i64) -> i64
      %bb5b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb5b_35 = "braid.and"(%bb5b_33, %bb5b_34) : (i64, i64) -> i64
      %bb5b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb5b_37 = "braid.eq"(%bb5b_35, %bb5b_36) : (i64, i64) -> i64
      "braid.setf"(%bb5b_37) {flag = "pf"} : (i64) -> ()
      %bb5b_38 = "braid.eq"(%bb5b_16, %bb5b_36) : (i64, i64) -> i64
      "braid.setf"(%bb5b_38) {flag = "zf"} : (i64) -> ()
      %bb5b_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb5b_40 = "braid.and"(%bb5b_16, %bb5b_39) : (i64, i64) -> i64
      "braid.setf"(%bb5b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb5b_16) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb5e] : () -> ()
    ^bb5e:  // 0x40105e
      %bb5e_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb5e_0 = "braid.zext"(%bb5e_1) {bits = 32 : i64} : (i64) -> i64
      %bb5e_9 = "braid.get"() {reg = "rcx"} : () -> i64
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
      "braid.set"(%bb5e_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x401060
      %bb60_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb60_3 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb60_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb60_5 = "braid.mul"(%bb60_3, %bb60_4) : (i64, i64) -> i64
      %bb60_6 = "braid.add"(%bb60_2, %bb60_5) : (i64, i64) -> i64
      %bb60_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb60_1 = "braid.add"(%bb60_6, %bb60_7) : (i64, i64) -> i64
      %bb60_0 = "braid.load"(%bb60_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb60_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x401064
      %bb64_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb64_0 = "braid.zext"(%bb64_1) {bits = 8 : i64} : (i64) -> i64
      %bb64_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb64_10 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb64_11 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb64_12 = "braid.mul"(%bb64_10, %bb64_11) : (i64, i64) -> i64
      %bb64_13 = "braid.add"(%bb64_9, %bb64_12) : (i64, i64) -> i64
      %bb64_14 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb64_8 = "braid.add"(%bb64_13, %bb64_14) : (i64, i64) -> i64
      "braid.store"(%bb64_8, %bb64_0) {bytes = 1 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb67] : () -> ()
    ^bb67:  // 0x401067
      %bb67_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb67_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb67_16 = "braid.add"(%bb67_0, %bb67_8) : (i64, i64) -> i64
      %bb67_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb67_20 = "braid.eq"(%bb67_16, %bb67_19) : (i64, i64) -> i64
      "braid.setf"(%bb67_20) {flag = "of"} : (i64) -> ()
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
      %bb67_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb67_40 = "braid.and"(%bb67_16, %bb67_39) : (i64, i64) -> i64
      "braid.setf"(%bb67_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb67_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb6a] : () -> ()
    ^bb6a:  // 0x40106a
      %bb6a_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb6a_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb6a_16 = "braid.sub"(%bb6a_0, %bb6a_8) : (i64, i64) -> i64
      %bb6a_18 = "braid.ult"(%bb6a_0, %bb6a_8) : (i64, i64) -> i64
      "braid.setf"(%bb6a_18) {flag = "cf"} : (i64) -> ()
      %bb6a_19 = "braid.xor"(%bb6a_0, %bb6a_8) : (i64, i64) -> i64
      %bb6a_20 = "braid.xor"(%bb6a_0, %bb6a_16) : (i64, i64) -> i64
      %bb6a_21 = "braid.and"(%bb6a_19, %bb6a_20) : (i64, i64) -> i64
      %bb6a_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb6a_23 = "braid.and"(%bb6a_21, %bb6a_22) : (i64, i64) -> i64
      "braid.setf"(%bb6a_23) {flag = "of"} : (i64) -> ()
      %bb6a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb6a_24) {flag = "af"} : (i64) -> ()
      %bb6a_32 = "braid.zext"(%bb6a_16) {bits = 8 : i64} : (i64) -> i64
      %bb6a_33 = "braid.popcnt"(%bb6a_32) : (i64) -> i64
      %bb6a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6a_35 = "braid.and"(%bb6a_33, %bb6a_34) : (i64, i64) -> i64
      %bb6a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6a_37 = "braid.eq"(%bb6a_35, %bb6a_36) : (i64, i64) -> i64
      "braid.setf"(%bb6a_37) {flag = "pf"} : (i64) -> ()
      %bb6a_38 = "braid.eq"(%bb6a_16, %bb6a_36) : (i64, i64) -> i64
      "braid.setf"(%bb6a_38) {flag = "zf"} : (i64) -> ()
      %bb6a_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb6a_40 = "braid.and"(%bb6a_16, %bb6a_39) : (i64, i64) -> i64
      "braid.setf"(%bb6a_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb6d] : () -> ()
    ^bb6d:  // 0x40106d
      %bb6d_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb6d_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6d_0 = "braid.eq"(%bb6d_1, %bb6d_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb6d_0)[^bb60, ^bb6f] : (i64) -> ()
    ^bb6f:  // 0x40106f
      %bb6f_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb6f_1 = "braid.load"(%bb6f_0) {bytes = 8 : i64} : (i64) -> i64
      %bb6f_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb6f_3 = "braid.add"(%bb6f_0, %bb6f_2) : (i64, i64) -> i64
      "braid.set"(%bb6f_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb6f_1) : (i64) -> ()
  }) {sym_name = "copy_bytes", entry = 4198400 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401070
      %bb0_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb5] : () -> ()
    ^bb5:  // 0x401075
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
    ^bb8:  // 0x401078
      %bb8_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb8_0)[^bb23, ^bba] : (i64) -> ()
    ^bba:  // 0x40107a
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
    ^bbc:  // 0x40107c
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401080
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
    ^bb15:  // 0x401085
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
    ^bb19:  // 0x401089
      %bb19_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb19_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb19_0 = "braid.eq"(%bb19_1, %bb19_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb19_0)[^bb24, ^bb1b] : (i64) -> ()
    ^bb1b:  // 0x40108b
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
    ^bb1e:  // 0x40108e
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
    ^bb21:  // 0x401091
      %bb21_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb21_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb21_0 = "braid.eq"(%bb21_1, %bb21_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb21_0)[^bb10, ^bb23] : (i64) -> ()
    ^bb23:  // 0x401093
      %bb23_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb23_1 = "braid.load"(%bb23_0) {bytes = 8 : i64} : (i64) -> i64
      %bb23_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb23_3 = "braid.add"(%bb23_0, %bb23_2) : (i64, i64) -> i64
      "braid.set"(%bb23_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb23_1) : (i64) -> ()
    ^bb24:  // 0x401094
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
    ^bb26:  // 0x401096
      %bb26_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb26_1 = "braid.load"(%bb26_0) {bytes = 8 : i64} : (i64) -> i64
      %bb26_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb26_3 = "braid.add"(%bb26_0, %bb26_2) : (i64, i64) -> i64
      "braid.set"(%bb26_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb26_1) : (i64) -> ()
    ^bb27:  // 0x401097
      "braid_cf.br"()[^ext4010a0] : () -> ()
    ^ext4010a0:
      "braid_cf.tail"() {target = 4198560 : i64} : () -> ()
  }) {sym_name = "equal_bytes", entry = 4198512 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x4010a0
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
    ^bb3:  // 0x4010a3
      %bb3_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb3_0)[^bb17, ^bb5] : (i64) -> ()
    ^bb5:  // 0x4010a5
      %bb5_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb5_0 = "braid.zext"(%bb5_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb5_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb7] : () -> ()
    ^bb7:  // 0x4010a7
      %bb7_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb7_0 = "braid.zext"(%bb7_1) {bits = 32 : i64} : (i64) -> i64
      %bb7_8 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb7_16 = "braid.and"(%bb7_0, %bb7_8) : (i64, i64) -> i64
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
      "braid.set"(%bb7_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bba] : () -> ()
    ^bba:  // 0x4010aa
      %bba_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bba_8 = "braid.const"() {value = 4 : i64} : () -> i64
      %bba_16 = "braid.sub"(%bba_0, %bba_8) : (i64, i64) -> i64
      %bba_18 = "braid.ult"(%bba_0, %bba_8) : (i64, i64) -> i64
      "braid.setf"(%bba_18) {flag = "cf"} : (i64) -> ()
      %bba_19 = "braid.xor"(%bba_0, %bba_8) : (i64, i64) -> i64
      %bba_20 = "braid.xor"(%bba_0, %bba_16) : (i64, i64) -> i64
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
      "braid_cf.br"()[^bbe] : () -> ()
    ^bbe:  // 0x4010ae
      %bbe_1 = "braid.getf"() {flag = "cf"} : () -> i64
      %bbe_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe_0 = "braid.eq"(%bbe_1, %bbe_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bbe_0)[^bb1d, ^bb10] : (i64) -> ()
    ^bb10:  // 0x4010b0
      %bb10_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb10_0 = "braid.zext"(%bb10_1) {bits = 32 : i64} : (i64) -> i64
      %bb10_9 = "braid.get"() {reg = "r8"} : () -> i64
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
      "braid.set"(%bb10_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb13] : () -> ()
    ^bb13:  // 0x4010b3
      %bb13_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb13_0 = "braid.zext"(%bb13_1) {bits = 32 : i64} : (i64) -> i64
      %bb13_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb13_8 = "braid.zext"(%bb13_9) {bits = 32 : i64} : (i64) -> i64
      %bb13_16 = "braid.xor"(%bb13_0, %bb13_8) : (i64, i64) -> i64
      %bb13_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb13_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb13_17) {flag = "of"} : (i64) -> ()
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
      %bb13_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb13_40 = "braid.and"(%bb13_16, %bb13_39) : (i64, i64) -> i64
      "braid.setf"(%bb13_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb13_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb15] : () -> ()
    ^bb15:  // 0x4010b5
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb17:  // 0x4010b7
      %bb17_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bb17_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x4010bc
      %bb1c_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1c_1 = "braid.load"(%bb1c_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1c_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c_3 = "braid.add"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      "braid.set"(%bb1c_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb1c_1) : (i64) -> ()
    ^bb1d:  // 0x4010bd
      %bb1d_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb1d_8 = "braid.const"() {value = -4 : i64} : () -> i64
      %bb1d_16 = "braid.and"(%bb1d_0, %bb1d_8) : (i64, i64) -> i64
      %bb1d_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1d_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1d_17) {flag = "of"} : (i64) -> ()
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
      "braid.set"(%bb1d_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb21] : () -> ()
    ^bb21:  // 0x4010c1
      %bb21_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb21_0 = "braid.zext"(%bb21_1) {bits = 32 : i64} : (i64) -> i64
      %bb21_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bb21_8 = "braid.zext"(%bb21_9) {bits = 32 : i64} : (i64) -> i64
      %bb21_16 = "braid.xor"(%bb21_0, %bb21_8) : (i64, i64) -> i64
      %bb21_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb21_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb21_17) {flag = "of"} : (i64) -> ()
      %bb21_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb21_24) {flag = "af"} : (i64) -> ()
      %bb21_32 = "braid.zext"(%bb21_16) {bits = 8 : i64} : (i64) -> i64
      %bb21_33 = "braid.popcnt"(%bb21_32) : (i64) -> i64
      %bb21_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb21_35 = "braid.and"(%bb21_33, %bb21_34) : (i64, i64) -> i64
      %bb21_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb21_37 = "braid.eq"(%bb21_35, %bb21_36) : (i64, i64) -> i64
      "braid.setf"(%bb21_37) {flag = "pf"} : (i64) -> ()
      %bb21_38 = "braid.eq"(%bb21_16, %bb21_36) : (i64, i64) -> i64
      "braid.setf"(%bb21_38) {flag = "zf"} : (i64) -> ()
      %bb21_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb21_40 = "braid.and"(%bb21_16, %bb21_39) : (i64, i64) -> i64
      "braid.setf"(%bb21_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb21_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x4010c4
      %bb24_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb24_0 = "braid.zext"(%bb24_1) {bits = 32 : i64} : (i64) -> i64
      %bb24_9 = "braid.get"() {reg = "rcx"} : () -> i64
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
      "braid.set"(%bb24_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb26] : () -> ()
    ^bb26:  // 0x4010c6
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x4010d0
      %bb30_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb30_3 = "braid.get"() {reg = "r8"} : () -> i64
      %bb30_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb30_5 = "braid.mul"(%bb30_3, %bb30_4) : (i64, i64) -> i64
      %bb30_6 = "braid.add"(%bb30_2, %bb30_5) : (i64, i64) -> i64
      %bb30_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb30_1 = "braid.add"(%bb30_6, %bb30_7) : (i64, i64) -> i64
      %bb30_0 = "braid.load"(%bb30_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb30_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb35] : () -> ()
    ^bb35:  // 0x4010d5
      %bb35_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb35_3 = "braid.get"() {reg = "r8"} : () -> i64
      %bb35_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb35_5 = "braid.mul"(%bb35_3, %bb35_4) : (i64, i64) -> i64
      %bb35_6 = "braid.add"(%bb35_2, %bb35_5) : (i64, i64) -> i64
      %bb35_7 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb35_1 = "braid.add"(%bb35_6, %bb35_7) : (i64, i64) -> i64
      %bb35_0 = "braid.load"(%bb35_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb35_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb3b] : () -> ()
    ^bb3b:  // 0x4010db
      %bb3b_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb3b_0 = "braid.zext"(%bb3b_1) {bits = 8 : i64} : (i64) -> i64
      %bb3b_10 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb3b_11 = "braid.get"() {reg = "r8"} : () -> i64
      %bb3b_12 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3b_13 = "braid.mul"(%bb3b_11, %bb3b_12) : (i64, i64) -> i64
      %bb3b_14 = "braid.add"(%bb3b_10, %bb3b_13) : (i64, i64) -> i64
      %bb3b_15 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3b_9 = "braid.add"(%bb3b_14, %bb3b_15) : (i64, i64) -> i64
      %bb3b_8 = "braid.load"(%bb3b_9) {bytes = 1 : i64} : (i64) -> i64
      %bb3b_16 = "braid.xor"(%bb3b_0, %bb3b_8) : (i64, i64) -> i64
      %bb3b_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb3b_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb3b_17) {flag = "of"} : (i64) -> ()
      %bb3b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb3b_24) {flag = "af"} : (i64) -> ()
      %bb3b_32 = "braid.zext"(%bb3b_16) {bits = 8 : i64} : (i64) -> i64
      %bb3b_33 = "braid.popcnt"(%bb3b_32) : (i64) -> i64
      %bb3b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3b_35 = "braid.and"(%bb3b_33, %bb3b_34) : (i64, i64) -> i64
      %bb3b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3b_37 = "braid.eq"(%bb3b_35, %bb3b_36) : (i64, i64) -> i64
      "braid.setf"(%bb3b_37) {flag = "pf"} : (i64) -> ()
      %bb3b_38 = "braid.eq"(%bb3b_16, %bb3b_36) : (i64, i64) -> i64
      "braid.setf"(%bb3b_38) {flag = "zf"} : (i64) -> ()
      %bb3b_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb3b_40 = "braid.and"(%bb3b_16, %bb3b_39) : (i64, i64) -> i64
      "braid.setf"(%bb3b_40) {flag = "sf"} : (i64) -> ()
      %bb3b_48 = "braid.get"() {reg = "r9"} : () -> i64
      %bb3b_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb3b_50 = "braid.and"(%bb3b_48, %bb3b_49) : (i64, i64) -> i64
      %bb3b_51 = "braid.or"(%bb3b_50, %bb3b_16) : (i64, i64) -> i64
      "braid.set"(%bb3b_51) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb3f] : () -> ()
    ^bb3f:  // 0x4010df
      %bb3f_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb3f_0 = "braid.zext"(%bb3f_1) {bits = 8 : i64} : (i64) -> i64
      %bb3f_10 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb3f_11 = "braid.get"() {reg = "r8"} : () -> i64
      %bb3f_12 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3f_13 = "braid.mul"(%bb3f_11, %bb3f_12) : (i64, i64) -> i64
      %bb3f_14 = "braid.add"(%bb3f_10, %bb3f_13) : (i64, i64) -> i64
      %bb3f_15 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3f_9 = "braid.add"(%bb3f_14, %bb3f_15) : (i64, i64) -> i64
      %bb3f_8 = "braid.load"(%bb3f_9) {bytes = 1 : i64} : (i64) -> i64
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
      %bb3f_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb3f_40 = "braid.and"(%bb3f_16, %bb3f_39) : (i64, i64) -> i64
      "braid.setf"(%bb3f_40) {flag = "sf"} : (i64) -> ()
      %bb3f_48 = "braid.get"() {reg = "r10"} : () -> i64
      %bb3f_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb3f_50 = "braid.and"(%bb3f_48, %bb3f_49) : (i64, i64) -> i64
      %bb3f_51 = "braid.or"(%bb3f_50, %bb3f_16) : (i64, i64) -> i64
      "braid.set"(%bb3f_51) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x4010e4
      %bb44_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb44_0 = "braid.zext"(%bb44_1) {bits = 8 : i64} : (i64) -> i64
      %bb44_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb44_8 = "braid.zext"(%bb44_9) {bits = 8 : i64} : (i64) -> i64
      %bb44_16 = "braid.or"(%bb44_0, %bb44_8) : (i64, i64) -> i64
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
      %bb44_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb44_40 = "braid.and"(%bb44_16, %bb44_39) : (i64, i64) -> i64
      "braid.setf"(%bb44_40) {flag = "sf"} : (i64) -> ()
      %bb44_48 = "braid.get"() {reg = "r9"} : () -> i64
      %bb44_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb44_50 = "braid.and"(%bb44_48, %bb44_49) : (i64, i64) -> i64
      %bb44_51 = "braid.or"(%bb44_50, %bb44_16) : (i64, i64) -> i64
      "braid.set"(%bb44_51) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb47] : () -> ()
    ^bb47:  // 0x4010e7
      %bb47_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb47_3 = "braid.get"() {reg = "r8"} : () -> i64
      %bb47_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb47_5 = "braid.mul"(%bb47_3, %bb47_4) : (i64, i64) -> i64
      %bb47_6 = "braid.add"(%bb47_2, %bb47_5) : (i64, i64) -> i64
      %bb47_7 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb47_1 = "braid.add"(%bb47_6, %bb47_7) : (i64, i64) -> i64
      %bb47_0 = "braid.load"(%bb47_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb47_0) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb4d] : () -> ()
    ^bb4d:  // 0x4010ed
      %bb4d_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb4d_0 = "braid.zext"(%bb4d_1) {bits = 8 : i64} : (i64) -> i64
      %bb4d_10 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb4d_11 = "braid.get"() {reg = "r8"} : () -> i64
      %bb4d_12 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4d_13 = "braid.mul"(%bb4d_11, %bb4d_12) : (i64, i64) -> i64
      %bb4d_14 = "braid.add"(%bb4d_10, %bb4d_13) : (i64, i64) -> i64
      %bb4d_15 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb4d_9 = "braid.add"(%bb4d_14, %bb4d_15) : (i64, i64) -> i64
      %bb4d_8 = "braid.load"(%bb4d_9) {bytes = 1 : i64} : (i64) -> i64
      %bb4d_16 = "braid.xor"(%bb4d_0, %bb4d_8) : (i64, i64) -> i64
      %bb4d_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb4d_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb4d_17) {flag = "of"} : (i64) -> ()
      %bb4d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb4d_24) {flag = "af"} : (i64) -> ()
      %bb4d_32 = "braid.zext"(%bb4d_16) {bits = 8 : i64} : (i64) -> i64
      %bb4d_33 = "braid.popcnt"(%bb4d_32) : (i64) -> i64
      %bb4d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4d_35 = "braid.and"(%bb4d_33, %bb4d_34) : (i64, i64) -> i64
      %bb4d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4d_37 = "braid.eq"(%bb4d_35, %bb4d_36) : (i64, i64) -> i64
      "braid.setf"(%bb4d_37) {flag = "pf"} : (i64) -> ()
      %bb4d_38 = "braid.eq"(%bb4d_16, %bb4d_36) : (i64, i64) -> i64
      "braid.setf"(%bb4d_38) {flag = "zf"} : (i64) -> ()
      %bb4d_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb4d_40 = "braid.and"(%bb4d_16, %bb4d_39) : (i64, i64) -> i64
      "braid.setf"(%bb4d_40) {flag = "sf"} : (i64) -> ()
      %bb4d_48 = "braid.get"() {reg = "r11"} : () -> i64
      %bb4d_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb4d_50 = "braid.and"(%bb4d_48, %bb4d_49) : (i64, i64) -> i64
      %bb4d_51 = "braid.or"(%bb4d_50, %bb4d_16) : (i64, i64) -> i64
      "braid.set"(%bb4d_51) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb52] : () -> ()
    ^bb52:  // 0x4010f2
      %bb52_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb52_0 = "braid.zext"(%bb52_1) {bits = 8 : i64} : (i64) -> i64
      %bb52_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb52_8 = "braid.zext"(%bb52_9) {bits = 8 : i64} : (i64) -> i64
      %bb52_16 = "braid.or"(%bb52_0, %bb52_8) : (i64, i64) -> i64
      %bb52_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb52_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb52_17) {flag = "of"} : (i64) -> ()
      %bb52_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb52_24) {flag = "af"} : (i64) -> ()
      %bb52_32 = "braid.zext"(%bb52_16) {bits = 8 : i64} : (i64) -> i64
      %bb52_33 = "braid.popcnt"(%bb52_32) : (i64) -> i64
      %bb52_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb52_35 = "braid.and"(%bb52_33, %bb52_34) : (i64, i64) -> i64
      %bb52_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb52_37 = "braid.eq"(%bb52_35, %bb52_36) : (i64, i64) -> i64
      "braid.setf"(%bb52_37) {flag = "pf"} : (i64) -> ()
      %bb52_38 = "braid.eq"(%bb52_16, %bb52_36) : (i64, i64) -> i64
      "braid.setf"(%bb52_38) {flag = "zf"} : (i64) -> ()
      %bb52_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb52_40 = "braid.and"(%bb52_16, %bb52_39) : (i64, i64) -> i64
      "braid.setf"(%bb52_40) {flag = "sf"} : (i64) -> ()
      %bb52_48 = "braid.get"() {reg = "r11"} : () -> i64
      %bb52_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb52_50 = "braid.and"(%bb52_48, %bb52_49) : (i64, i64) -> i64
      %bb52_51 = "braid.or"(%bb52_50, %bb52_16) : (i64, i64) -> i64
      "braid.set"(%bb52_51) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb55] : () -> ()
    ^bb55:  // 0x4010f5
      %bb55_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb55_3 = "braid.get"() {reg = "r8"} : () -> i64
      %bb55_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb55_5 = "braid.mul"(%bb55_3, %bb55_4) : (i64, i64) -> i64
      %bb55_6 = "braid.add"(%bb55_2, %bb55_5) : (i64, i64) -> i64
      %bb55_7 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb55_1 = "braid.add"(%bb55_6, %bb55_7) : (i64, i64) -> i64
      %bb55_0 = "braid.load"(%bb55_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb55_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb5b] : () -> ()
    ^bb5b:  // 0x4010fb
      %bb5b_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb5b_0 = "braid.zext"(%bb5b_1) {bits = 8 : i64} : (i64) -> i64
      %bb5b_10 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb5b_11 = "braid.get"() {reg = "r8"} : () -> i64
      %bb5b_12 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb5b_13 = "braid.mul"(%bb5b_11, %bb5b_12) : (i64, i64) -> i64
      %bb5b_14 = "braid.add"(%bb5b_10, %bb5b_13) : (i64, i64) -> i64
      %bb5b_15 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb5b_9 = "braid.add"(%bb5b_14, %bb5b_15) : (i64, i64) -> i64
      %bb5b_8 = "braid.load"(%bb5b_9) {bytes = 1 : i64} : (i64) -> i64
      %bb5b_16 = "braid.xor"(%bb5b_0, %bb5b_8) : (i64, i64) -> i64
      %bb5b_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb5b_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb5b_17) {flag = "of"} : (i64) -> ()
      %bb5b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb5b_24) {flag = "af"} : (i64) -> ()
      %bb5b_32 = "braid.zext"(%bb5b_16) {bits = 8 : i64} : (i64) -> i64
      %bb5b_33 = "braid.popcnt"(%bb5b_32) : (i64) -> i64
      %bb5b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb5b_35 = "braid.and"(%bb5b_33, %bb5b_34) : (i64, i64) -> i64
      %bb5b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb5b_37 = "braid.eq"(%bb5b_35, %bb5b_36) : (i64, i64) -> i64
      "braid.setf"(%bb5b_37) {flag = "pf"} : (i64) -> ()
      %bb5b_38 = "braid.eq"(%bb5b_16, %bb5b_36) : (i64, i64) -> i64
      "braid.setf"(%bb5b_38) {flag = "zf"} : (i64) -> ()
      %bb5b_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb5b_40 = "braid.and"(%bb5b_16, %bb5b_39) : (i64, i64) -> i64
      "braid.setf"(%bb5b_40) {flag = "sf"} : (i64) -> ()
      %bb5b_48 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb5b_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb5b_50 = "braid.and"(%bb5b_48, %bb5b_49) : (i64, i64) -> i64
      %bb5b_51 = "braid.or"(%bb5b_50, %bb5b_16) : (i64, i64) -> i64
      "braid.set"(%bb5b_51) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x401100
      %bb60_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb60_0 = "braid.zext"(%bb60_1) {bits = 8 : i64} : (i64) -> i64
      %bb60_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb60_8 = "braid.zext"(%bb60_9) {bits = 8 : i64} : (i64) -> i64
      %bb60_16 = "braid.or"(%bb60_0, %bb60_8) : (i64, i64) -> i64
      %bb60_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb60_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb60_17) {flag = "of"} : (i64) -> ()
      %bb60_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb60_24) {flag = "af"} : (i64) -> ()
      %bb60_32 = "braid.zext"(%bb60_16) {bits = 8 : i64} : (i64) -> i64
      %bb60_33 = "braid.popcnt"(%bb60_32) : (i64) -> i64
      %bb60_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb60_35 = "braid.and"(%bb60_33, %bb60_34) : (i64, i64) -> i64
      %bb60_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb60_37 = "braid.eq"(%bb60_35, %bb60_36) : (i64, i64) -> i64
      "braid.setf"(%bb60_37) {flag = "pf"} : (i64) -> ()
      %bb60_38 = "braid.eq"(%bb60_16, %bb60_36) : (i64, i64) -> i64
      "braid.setf"(%bb60_38) {flag = "zf"} : (i64) -> ()
      %bb60_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb60_40 = "braid.and"(%bb60_16, %bb60_39) : (i64, i64) -> i64
      "braid.setf"(%bb60_40) {flag = "sf"} : (i64) -> ()
      %bb60_48 = "braid.get"() {reg = "r11"} : () -> i64
      %bb60_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb60_50 = "braid.and"(%bb60_48, %bb60_49) : (i64, i64) -> i64
      %bb60_51 = "braid.or"(%bb60_50, %bb60_16) : (i64, i64) -> i64
      "braid.set"(%bb60_51) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb63] : () -> ()
    ^bb63:  // 0x401103
      %bb63_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb63_0 = "braid.zext"(%bb63_1) {bits = 8 : i64} : (i64) -> i64
      %bb63_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb63_8 = "braid.zext"(%bb63_9) {bits = 8 : i64} : (i64) -> i64
      %bb63_16 = "braid.or"(%bb63_0, %bb63_8) : (i64, i64) -> i64
      %bb63_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb63_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb63_17) {flag = "of"} : (i64) -> ()
      %bb63_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb63_24) {flag = "af"} : (i64) -> ()
      %bb63_32 = "braid.zext"(%bb63_16) {bits = 8 : i64} : (i64) -> i64
      %bb63_33 = "braid.popcnt"(%bb63_32) : (i64) -> i64
      %bb63_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb63_35 = "braid.and"(%bb63_33, %bb63_34) : (i64, i64) -> i64
      %bb63_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb63_37 = "braid.eq"(%bb63_35, %bb63_36) : (i64, i64) -> i64
      "braid.setf"(%bb63_37) {flag = "pf"} : (i64) -> ()
      %bb63_38 = "braid.eq"(%bb63_16, %bb63_36) : (i64, i64) -> i64
      "braid.setf"(%bb63_38) {flag = "zf"} : (i64) -> ()
      %bb63_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb63_40 = "braid.and"(%bb63_16, %bb63_39) : (i64, i64) -> i64
      "braid.setf"(%bb63_40) {flag = "sf"} : (i64) -> ()
      %bb63_48 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb63_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb63_50 = "braid.and"(%bb63_48, %bb63_49) : (i64, i64) -> i64
      %bb63_51 = "braid.or"(%bb63_50, %bb63_16) : (i64, i64) -> i64
      "braid.set"(%bb63_51) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb66] : () -> ()
    ^bb66:  // 0x401106
      %bb66_0 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb66_8 = "braid.get"() {reg = "r8"} : () -> i64
      %bb66_16 = "braid.add"(%bb66_0, %bb66_8) : (i64, i64) -> i64
      %bb66_18 = "braid.ult"(%bb66_16, %bb66_0) : (i64, i64) -> i64
      "braid.setf"(%bb66_18) {flag = "cf"} : (i64) -> ()
      %bb66_19 = "braid.xor"(%bb66_0, %bb66_16) : (i64, i64) -> i64
      %bb66_20 = "braid.xor"(%bb66_8, %bb66_16) : (i64, i64) -> i64
      %bb66_21 = "braid.and"(%bb66_19, %bb66_20) : (i64, i64) -> i64
      %bb66_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb66_23 = "braid.and"(%bb66_21, %bb66_22) : (i64, i64) -> i64
      "braid.setf"(%bb66_23) {flag = "of"} : (i64) -> ()
      %bb66_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb66_24) {flag = "af"} : (i64) -> ()
      %bb66_32 = "braid.zext"(%bb66_16) {bits = 8 : i64} : (i64) -> i64
      %bb66_33 = "braid.popcnt"(%bb66_32) : (i64) -> i64
      %bb66_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb66_35 = "braid.and"(%bb66_33, %bb66_34) : (i64, i64) -> i64
      %bb66_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb66_37 = "braid.eq"(%bb66_35, %bb66_36) : (i64, i64) -> i64
      "braid.setf"(%bb66_37) {flag = "pf"} : (i64) -> ()
      %bb66_38 = "braid.eq"(%bb66_16, %bb66_36) : (i64, i64) -> i64
      "braid.setf"(%bb66_38) {flag = "zf"} : (i64) -> ()
      %bb66_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb66_40 = "braid.and"(%bb66_16, %bb66_39) : (i64, i64) -> i64
      "braid.setf"(%bb66_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb66_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb6a] : () -> ()
    ^bb6a:  // 0x40110a
      %bb6a_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb6a_8 = "braid.get"() {reg = "r8"} : () -> i64
      %bb6a_16 = "braid.sub"(%bb6a_0, %bb6a_8) : (i64, i64) -> i64
      %bb6a_18 = "braid.ult"(%bb6a_0, %bb6a_8) : (i64, i64) -> i64
      "braid.setf"(%bb6a_18) {flag = "cf"} : (i64) -> ()
      %bb6a_19 = "braid.xor"(%bb6a_0, %bb6a_8) : (i64, i64) -> i64
      %bb6a_20 = "braid.xor"(%bb6a_0, %bb6a_16) : (i64, i64) -> i64
      %bb6a_21 = "braid.and"(%bb6a_19, %bb6a_20) : (i64, i64) -> i64
      %bb6a_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb6a_23 = "braid.and"(%bb6a_21, %bb6a_22) : (i64, i64) -> i64
      "braid.setf"(%bb6a_23) {flag = "of"} : (i64) -> ()
      %bb6a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb6a_24) {flag = "af"} : (i64) -> ()
      %bb6a_32 = "braid.zext"(%bb6a_16) {bits = 8 : i64} : (i64) -> i64
      %bb6a_33 = "braid.popcnt"(%bb6a_32) : (i64) -> i64
      %bb6a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6a_35 = "braid.and"(%bb6a_33, %bb6a_34) : (i64, i64) -> i64
      %bb6a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6a_37 = "braid.eq"(%bb6a_35, %bb6a_36) : (i64, i64) -> i64
      "braid.setf"(%bb6a_37) {flag = "pf"} : (i64) -> ()
      %bb6a_38 = "braid.eq"(%bb6a_16, %bb6a_36) : (i64, i64) -> i64
      "braid.setf"(%bb6a_38) {flag = "zf"} : (i64) -> ()
      %bb6a_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb6a_40 = "braid.and"(%bb6a_16, %bb6a_39) : (i64, i64) -> i64
      "braid.setf"(%bb6a_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb6d] : () -> ()
    ^bb6d:  // 0x40110d
      %bb6d_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb6d_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6d_0 = "braid.eq"(%bb6d_1, %bb6d_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb6d_0)[^bb30, ^bb6f] : (i64) -> ()
    ^bb6f:  // 0x40110f
      %bb6f_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb6f_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb6f_16 = "braid.and"(%bb6f_0, %bb6f_8) : (i64, i64) -> i64
      %bb6f_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb6f_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb6f_17) {flag = "of"} : (i64) -> ()
      %bb6f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb6f_24) {flag = "af"} : (i64) -> ()
      %bb6f_32 = "braid.zext"(%bb6f_16) {bits = 8 : i64} : (i64) -> i64
      %bb6f_33 = "braid.popcnt"(%bb6f_32) : (i64) -> i64
      %bb6f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6f_35 = "braid.and"(%bb6f_33, %bb6f_34) : (i64, i64) -> i64
      %bb6f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6f_37 = "braid.eq"(%bb6f_35, %bb6f_36) : (i64, i64) -> i64
      "braid.setf"(%bb6f_37) {flag = "pf"} : (i64) -> ()
      %bb6f_38 = "braid.eq"(%bb6f_16, %bb6f_36) : (i64, i64) -> i64
      "braid.setf"(%bb6f_38) {flag = "zf"} : (i64) -> ()
      %bb6f_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb6f_40 = "braid.and"(%bb6f_16, %bb6f_39) : (i64, i64) -> i64
      "braid.setf"(%bb6f_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb72] : () -> ()
    ^bb72:  // 0x401112
      %bb72_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb72_0)[^bb94, ^bb74] : (i64) -> ()
    ^bb74:  // 0x401114
      %bb74_0 = "braid.get"() {reg = "r8"} : () -> i64
      %bb74_8 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb74_16 = "braid.add"(%bb74_0, %bb74_8) : (i64, i64) -> i64
      %bb74_18 = "braid.ult"(%bb74_16, %bb74_0) : (i64, i64) -> i64
      "braid.setf"(%bb74_18) {flag = "cf"} : (i64) -> ()
      %bb74_19 = "braid.xor"(%bb74_0, %bb74_16) : (i64, i64) -> i64
      %bb74_20 = "braid.xor"(%bb74_8, %bb74_16) : (i64, i64) -> i64
      %bb74_21 = "braid.and"(%bb74_19, %bb74_20) : (i64, i64) -> i64
      %bb74_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb74_23 = "braid.and"(%bb74_21, %bb74_22) : (i64, i64) -> i64
      "braid.setf"(%bb74_23) {flag = "of"} : (i64) -> ()
      %bb74_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb74_24) {flag = "af"} : (i64) -> ()
      %bb74_32 = "braid.zext"(%bb74_16) {bits = 8 : i64} : (i64) -> i64
      %bb74_33 = "braid.popcnt"(%bb74_32) : (i64) -> i64
      %bb74_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb74_35 = "braid.and"(%bb74_33, %bb74_34) : (i64, i64) -> i64
      %bb74_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb74_37 = "braid.eq"(%bb74_35, %bb74_36) : (i64, i64) -> i64
      "braid.setf"(%bb74_37) {flag = "pf"} : (i64) -> ()
      %bb74_38 = "braid.eq"(%bb74_16, %bb74_36) : (i64, i64) -> i64
      "braid.setf"(%bb74_38) {flag = "zf"} : (i64) -> ()
      %bb74_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb74_40 = "braid.and"(%bb74_16, %bb74_39) : (i64, i64) -> i64
      "braid.setf"(%bb74_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb74_16) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb77] : () -> ()
    ^bb77:  // 0x401117
      %bb77_0 = "braid.get"() {reg = "r8"} : () -> i64
      %bb77_8 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb77_16 = "braid.add"(%bb77_0, %bb77_8) : (i64, i64) -> i64
      %bb77_18 = "braid.ult"(%bb77_16, %bb77_0) : (i64, i64) -> i64
      "braid.setf"(%bb77_18) {flag = "cf"} : (i64) -> ()
      %bb77_19 = "braid.xor"(%bb77_0, %bb77_16) : (i64, i64) -> i64
      %bb77_20 = "braid.xor"(%bb77_8, %bb77_16) : (i64, i64) -> i64
      %bb77_21 = "braid.and"(%bb77_19, %bb77_20) : (i64, i64) -> i64
      %bb77_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb77_23 = "braid.and"(%bb77_21, %bb77_22) : (i64, i64) -> i64
      "braid.setf"(%bb77_23) {flag = "of"} : (i64) -> ()
      %bb77_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb77_24) {flag = "af"} : (i64) -> ()
      %bb77_32 = "braid.zext"(%bb77_16) {bits = 8 : i64} : (i64) -> i64
      %bb77_33 = "braid.popcnt"(%bb77_32) : (i64) -> i64
      %bb77_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb77_35 = "braid.and"(%bb77_33, %bb77_34) : (i64, i64) -> i64
      %bb77_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb77_37 = "braid.eq"(%bb77_35, %bb77_36) : (i64, i64) -> i64
      "braid.setf"(%bb77_37) {flag = "pf"} : (i64) -> ()
      %bb77_38 = "braid.eq"(%bb77_16, %bb77_36) : (i64, i64) -> i64
      "braid.setf"(%bb77_38) {flag = "zf"} : (i64) -> ()
      %bb77_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb77_40 = "braid.and"(%bb77_16, %bb77_39) : (i64, i64) -> i64
      "braid.setf"(%bb77_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb77_16) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb7a] : () -> ()
    ^bb7a:  // 0x40111a
      %bb7a_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb7a_0 = "braid.zext"(%bb7a_1) {bits = 32 : i64} : (i64) -> i64
      %bb7a_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb7a_8 = "braid.zext"(%bb7a_9) {bits = 32 : i64} : (i64) -> i64
      %bb7a_16 = "braid.xor"(%bb7a_0, %bb7a_8) : (i64, i64) -> i64
      %bb7a_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb7a_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb7a_17) {flag = "of"} : (i64) -> ()
      %bb7a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb7a_24) {flag = "af"} : (i64) -> ()
      %bb7a_32 = "braid.zext"(%bb7a_16) {bits = 8 : i64} : (i64) -> i64
      %bb7a_33 = "braid.popcnt"(%bb7a_32) : (i64) -> i64
      %bb7a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb7a_35 = "braid.and"(%bb7a_33, %bb7a_34) : (i64, i64) -> i64
      %bb7a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7a_37 = "braid.eq"(%bb7a_35, %bb7a_36) : (i64, i64) -> i64
      "braid.setf"(%bb7a_37) {flag = "pf"} : (i64) -> ()
      %bb7a_38 = "braid.eq"(%bb7a_16, %bb7a_36) : (i64, i64) -> i64
      "braid.setf"(%bb7a_38) {flag = "zf"} : (i64) -> ()
      %bb7a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb7a_40 = "braid.and"(%bb7a_16, %bb7a_39) : (i64, i64) -> i64
      "braid.setf"(%bb7a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb7a_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x40111c
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x401120
      %bb80_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb80_3 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb80_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb80_5 = "braid.mul"(%bb80_3, %bb80_4) : (i64, i64) -> i64
      %bb80_6 = "braid.add"(%bb80_2, %bb80_5) : (i64, i64) -> i64
      %bb80_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb80_1 = "braid.add"(%bb80_6, %bb80_7) : (i64, i64) -> i64
      %bb80_0 = "braid.load"(%bb80_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb80_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb85] : () -> ()
    ^bb85:  // 0x401125
      %bb85_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb85_0 = "braid.zext"(%bb85_1) {bits = 8 : i64} : (i64) -> i64
      %bb85_10 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb85_11 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb85_12 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb85_13 = "braid.mul"(%bb85_11, %bb85_12) : (i64, i64) -> i64
      %bb85_14 = "braid.add"(%bb85_10, %bb85_13) : (i64, i64) -> i64
      %bb85_15 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb85_9 = "braid.add"(%bb85_14, %bb85_15) : (i64, i64) -> i64
      %bb85_8 = "braid.load"(%bb85_9) {bytes = 1 : i64} : (i64) -> i64
      %bb85_16 = "braid.xor"(%bb85_0, %bb85_8) : (i64, i64) -> i64
      %bb85_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb85_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb85_17) {flag = "of"} : (i64) -> ()
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
      %bb85_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb85_40 = "braid.and"(%bb85_16, %bb85_39) : (i64, i64) -> i64
      "braid.setf"(%bb85_40) {flag = "sf"} : (i64) -> ()
      %bb85_48 = "braid.get"() {reg = "r8"} : () -> i64
      %bb85_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb85_50 = "braid.and"(%bb85_48, %bb85_49) : (i64, i64) -> i64
      %bb85_51 = "braid.or"(%bb85_50, %bb85_16) : (i64, i64) -> i64
      "braid.set"(%bb85_51) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb89] : () -> ()
    ^bb89:  // 0x401129
      %bb89_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb89_0 = "braid.zext"(%bb89_1) {bits = 8 : i64} : (i64) -> i64
      %bb89_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bb89_8 = "braid.zext"(%bb89_9) {bits = 8 : i64} : (i64) -> i64
      %bb89_16 = "braid.or"(%bb89_0, %bb89_8) : (i64, i64) -> i64
      %bb89_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb89_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb89_17) {flag = "of"} : (i64) -> ()
      %bb89_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb89_24) {flag = "af"} : (i64) -> ()
      %bb89_32 = "braid.zext"(%bb89_16) {bits = 8 : i64} : (i64) -> i64
      %bb89_33 = "braid.popcnt"(%bb89_32) : (i64) -> i64
      %bb89_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb89_35 = "braid.and"(%bb89_33, %bb89_34) : (i64, i64) -> i64
      %bb89_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb89_37 = "braid.eq"(%bb89_35, %bb89_36) : (i64, i64) -> i64
      "braid.setf"(%bb89_37) {flag = "pf"} : (i64) -> ()
      %bb89_38 = "braid.eq"(%bb89_16, %bb89_36) : (i64, i64) -> i64
      "braid.setf"(%bb89_38) {flag = "zf"} : (i64) -> ()
      %bb89_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb89_40 = "braid.and"(%bb89_16, %bb89_39) : (i64, i64) -> i64
      "braid.setf"(%bb89_40) {flag = "sf"} : (i64) -> ()
      %bb89_48 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb89_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb89_50 = "braid.and"(%bb89_48, %bb89_49) : (i64, i64) -> i64
      %bb89_51 = "braid.or"(%bb89_50, %bb89_16) : (i64, i64) -> i64
      "braid.set"(%bb89_51) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x40112c
      %bb8c_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb8c_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8c_16 = "braid.add"(%bb8c_0, %bb8c_8) : (i64, i64) -> i64
      %bb8c_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb8c_20 = "braid.eq"(%bb8c_16, %bb8c_19) : (i64, i64) -> i64
      "braid.setf"(%bb8c_20) {flag = "of"} : (i64) -> ()
      %bb8c_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb8c_24) {flag = "af"} : (i64) -> ()
      %bb8c_32 = "braid.zext"(%bb8c_16) {bits = 8 : i64} : (i64) -> i64
      %bb8c_33 = "braid.popcnt"(%bb8c_32) : (i64) -> i64
      %bb8c_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8c_35 = "braid.and"(%bb8c_33, %bb8c_34) : (i64, i64) -> i64
      %bb8c_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8c_37 = "braid.eq"(%bb8c_35, %bb8c_36) : (i64, i64) -> i64
      "braid.setf"(%bb8c_37) {flag = "pf"} : (i64) -> ()
      %bb8c_38 = "braid.eq"(%bb8c_16, %bb8c_36) : (i64, i64) -> i64
      "braid.setf"(%bb8c_38) {flag = "zf"} : (i64) -> ()
      %bb8c_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb8c_40 = "braid.and"(%bb8c_16, %bb8c_39) : (i64, i64) -> i64
      "braid.setf"(%bb8c_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb8c_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb8f] : () -> ()
    ^bb8f:  // 0x40112f
      %bb8f_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb8f_8 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb8f_16 = "braid.sub"(%bb8f_0, %bb8f_8) : (i64, i64) -> i64
      %bb8f_18 = "braid.ult"(%bb8f_0, %bb8f_8) : (i64, i64) -> i64
      "braid.setf"(%bb8f_18) {flag = "cf"} : (i64) -> ()
      %bb8f_19 = "braid.xor"(%bb8f_0, %bb8f_8) : (i64, i64) -> i64
      %bb8f_20 = "braid.xor"(%bb8f_0, %bb8f_16) : (i64, i64) -> i64
      %bb8f_21 = "braid.and"(%bb8f_19, %bb8f_20) : (i64, i64) -> i64
      %bb8f_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb8f_23 = "braid.and"(%bb8f_21, %bb8f_22) : (i64, i64) -> i64
      "braid.setf"(%bb8f_23) {flag = "of"} : (i64) -> ()
      %bb8f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb8f_24) {flag = "af"} : (i64) -> ()
      %bb8f_32 = "braid.zext"(%bb8f_16) {bits = 8 : i64} : (i64) -> i64
      %bb8f_33 = "braid.popcnt"(%bb8f_32) : (i64) -> i64
      %bb8f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8f_35 = "braid.and"(%bb8f_33, %bb8f_34) : (i64, i64) -> i64
      %bb8f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8f_37 = "braid.eq"(%bb8f_35, %bb8f_36) : (i64, i64) -> i64
      "braid.setf"(%bb8f_37) {flag = "pf"} : (i64) -> ()
      %bb8f_38 = "braid.eq"(%bb8f_16, %bb8f_36) : (i64, i64) -> i64
      "braid.setf"(%bb8f_38) {flag = "zf"} : (i64) -> ()
      %bb8f_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb8f_40 = "braid.and"(%bb8f_16, %bb8f_39) : (i64, i64) -> i64
      "braid.setf"(%bb8f_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb92] : () -> ()
    ^bb92:  // 0x401132
      %bb92_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb92_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb92_0 = "braid.eq"(%bb92_1, %bb92_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb92_0)[^bb80, ^bb94] : (i64) -> ()
    ^bb94:  // 0x401134
      %bb94_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb94_0 = "braid.zext"(%bb94_1) {bits = 32 : i64} : (i64) -> i64
      %bb94_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb94_8 = "braid.zext"(%bb94_9) {bits = 32 : i64} : (i64) -> i64
      %bb94_16 = "braid.xor"(%bb94_0, %bb94_8) : (i64, i64) -> i64
      %bb94_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb94_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb94_17) {flag = "of"} : (i64) -> ()
      %bb94_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb94_24) {flag = "af"} : (i64) -> ()
      %bb94_32 = "braid.zext"(%bb94_16) {bits = 8 : i64} : (i64) -> i64
      %bb94_33 = "braid.popcnt"(%bb94_32) : (i64) -> i64
      %bb94_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb94_35 = "braid.and"(%bb94_33, %bb94_34) : (i64, i64) -> i64
      %bb94_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb94_37 = "braid.eq"(%bb94_35, %bb94_36) : (i64, i64) -> i64
      "braid.setf"(%bb94_37) {flag = "pf"} : (i64) -> ()
      %bb94_38 = "braid.eq"(%bb94_16, %bb94_36) : (i64, i64) -> i64
      "braid.setf"(%bb94_38) {flag = "zf"} : (i64) -> ()
      %bb94_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb94_40 = "braid.and"(%bb94_16, %bb94_39) : (i64, i64) -> i64
      "braid.setf"(%bb94_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb94_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb96] : () -> ()
    ^bb96:  // 0x401136
      %bb96_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb96_0 = "braid.zext"(%bb96_1) {bits = 8 : i64} : (i64) -> i64
      %bb96_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb96_8 = "braid.zext"(%bb96_9) {bits = 8 : i64} : (i64) -> i64
      %bb96_16 = "braid.and"(%bb96_0, %bb96_8) : (i64, i64) -> i64
      %bb96_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb96_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb96_17) {flag = "of"} : (i64) -> ()
      %bb96_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb96_24) {flag = "af"} : (i64) -> ()
      %bb96_32 = "braid.zext"(%bb96_16) {bits = 8 : i64} : (i64) -> i64
      %bb96_33 = "braid.popcnt"(%bb96_32) : (i64) -> i64
      %bb96_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb96_35 = "braid.and"(%bb96_33, %bb96_34) : (i64, i64) -> i64
      %bb96_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb96_37 = "braid.eq"(%bb96_35, %bb96_36) : (i64, i64) -> i64
      "braid.setf"(%bb96_37) {flag = "pf"} : (i64) -> ()
      %bb96_38 = "braid.eq"(%bb96_16, %bb96_36) : (i64, i64) -> i64
      "braid.setf"(%bb96_38) {flag = "zf"} : (i64) -> ()
      %bb96_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb96_40 = "braid.and"(%bb96_16, %bb96_39) : (i64, i64) -> i64
      "braid.setf"(%bb96_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x401138
      %bb98_0 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb98_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb98_9 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb98_10 = "braid.and"(%bb98_8, %bb98_9) : (i64, i64) -> i64
      %bb98_11 = "braid.or"(%bb98_10, %bb98_0) : (i64, i64) -> i64
      "braid.set"(%bb98_11) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb9b] : () -> ()
    ^bb9b:  // 0x40113b
      %bb9b_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb9b_1 = "braid.load"(%bb9b_0) {bytes = 8 : i64} : (i64) -> i64
      %bb9b_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb9b_3 = "braid.add"(%bb9b_0, %bb9b_2) : (i64, i64) -> i64
      "braid.set"(%bb9b_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb9b_1) : (i64) -> ()
  }) {sym_name = "equal_bytes_ct", entry = 4198560 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
