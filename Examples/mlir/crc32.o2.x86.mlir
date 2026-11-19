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
      "braid_cf.cond_br"(%bb5_0)[^bbab, ^bbb] : (i64) -> ()
    ^bbb:  // 0x40100b
      %bbb_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbb_0 = "braid.zext"(%bbb_1) {bits = 32 : i64} : (i64) -> i64
      %bbb_8 = "braid.not"(%bbb_0) : (i64) -> i64
      %bbb_9 = "braid.zext"(%bbb_8) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bbb_9) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbd] : () -> ()
    ^bbd:  // 0x40100d
      %bbd_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbd_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd_16 = "braid.sub"(%bbd_0, %bbd_8) : (i64, i64) -> i64
      %bbd_18 = "braid.ult"(%bbd_0, %bbd_8) : (i64, i64) -> i64
      "braid.setf"(%bbd_18) {flag = "cf"} : (i64) -> ()
      %bbd_19 = "braid.xor"(%bbd_0, %bbd_8) : (i64, i64) -> i64
      %bbd_20 = "braid.xor"(%bbd_0, %bbd_16) : (i64, i64) -> i64
      %bbd_21 = "braid.and"(%bbd_19, %bbd_20) : (i64, i64) -> i64
      %bbd_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbd_23 = "braid.and"(%bbd_21, %bbd_22) : (i64, i64) -> i64
      "braid.setf"(%bbd_23) {flag = "of"} : (i64) -> ()
      %bbd_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbd_24) {flag = "af"} : (i64) -> ()
      %bbd_32 = "braid.zext"(%bbd_16) {bits = 8 : i64} : (i64) -> i64
      %bbd_33 = "braid.popcnt"(%bbd_32) : (i64) -> i64
      %bbd_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd_35 = "braid.and"(%bbd_33, %bbd_34) : (i64, i64) -> i64
      %bbd_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd_37 = "braid.eq"(%bbd_35, %bbd_36) : (i64, i64) -> i64
      "braid.setf"(%bbd_37) {flag = "pf"} : (i64) -> ()
      %bbd_38 = "braid.eq"(%bbd_16, %bbd_36) : (i64, i64) -> i64
      "braid.setf"(%bbd_38) {flag = "zf"} : (i64) -> ()
      %bbd_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbd_40 = "braid.and"(%bbd_16, %bbd_39) : (i64, i64) -> i64
      "braid.setf"(%bbd_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb11] : () -> ()
    ^bb11:  // 0x401011
      %bb11_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb11_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb11_0 = "braid.eq"(%bb11_1, %bb11_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb11_0)[^bb17, ^bb13] : (i64) -> ()
    ^bb13:  // 0x401013
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
    ^bb15:  // 0x401015
      "braid_cf.br"()[^bb86] : () -> ()
    ^bb17:  // 0x401017
      %bb17_0 = "braid.get"() {reg = "rdx"} : () -> i64
      "braid.set"(%bb17_0) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb1a] : () -> ()
    ^bb1a:  // 0x40101a
      %bb1a_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb1a_8 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb1a_16 = "braid.and"(%bb1a_0, %bb1a_8) : (i64, i64) -> i64
      %bb1a_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1a_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1a_17) {flag = "of"} : (i64) -> ()
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
      "braid.set"(%bb1a_16) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb1e] : () -> ()
    ^bb1e:  // 0x40101e
      %bb1e_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1e_0 = "braid.zext"(%bb1e_1) {bits = 32 : i64} : (i64) -> i64
      %bb1e_9 = "braid.get"() {reg = "rcx"} : () -> i64
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
      "braid.set"(%bb1e_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x401020
      %bb20_0 = "braid.const"() {value = 4202672 : i64} : () -> i64
      "braid.set"(%bb20_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb27] : () -> ()
    ^bb27:  // 0x401027
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x401030
      %bb30_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb30_3 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb30_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb30_5 = "braid.mul"(%bb30_3, %bb30_4) : (i64, i64) -> i64
      %bb30_6 = "braid.add"(%bb30_2, %bb30_5) : (i64, i64) -> i64
      %bb30_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb30_1 = "braid.add"(%bb30_6, %bb30_7) : (i64, i64) -> i64
      %bb30_0 = "braid.load"(%bb30_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb30_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb35] : () -> ()
    ^bb35:  // 0x401035
      %bb35_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb35_0 = "braid.zext"(%bb35_1) {bits = 32 : i64} : (i64) -> i64
      %bb35_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb35_8 = "braid.zext"(%bb35_9) {bits = 32 : i64} : (i64) -> i64
      %bb35_16 = "braid.xor"(%bb35_0, %bb35_8) : (i64, i64) -> i64
      %bb35_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb35_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb35_17) {flag = "of"} : (i64) -> ()
      %bb35_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb35_24) {flag = "af"} : (i64) -> ()
      %bb35_32 = "braid.zext"(%bb35_16) {bits = 8 : i64} : (i64) -> i64
      %bb35_33 = "braid.popcnt"(%bb35_32) : (i64) -> i64
      %bb35_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb35_35 = "braid.and"(%bb35_33, %bb35_34) : (i64, i64) -> i64
      %bb35_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb35_37 = "braid.eq"(%bb35_35, %bb35_36) : (i64, i64) -> i64
      "braid.setf"(%bb35_37) {flag = "pf"} : (i64) -> ()
      %bb35_38 = "braid.eq"(%bb35_16, %bb35_36) : (i64, i64) -> i64
      "braid.setf"(%bb35_38) {flag = "zf"} : (i64) -> ()
      %bb35_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb35_40 = "braid.and"(%bb35_16, %bb35_39) : (i64, i64) -> i64
      "braid.setf"(%bb35_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb35_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x401038
      %bb38_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb38_0 = "braid.zext"(%bb38_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb38_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb3b] : () -> ()
    ^bb3b:  // 0x40103b
      %bb3b_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb3b_0 = "braid.zext"(%bb3b_1) {bits = 32 : i64} : (i64) -> i64
      %bb3b_8 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb3b_9 = "braid.lshr"(%bb3b_0, %bb3b_8) : (i64, i64) -> i64
      %bb3b_11 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb3b_12 = "braid.lshr"(%bb3b_0, %bb3b_11) : (i64, i64) -> i64
      %bb3b_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3b_14 = "braid.and"(%bb3b_12, %bb3b_13) : (i64, i64) -> i64
      "braid.setf"(%bb3b_14) {flag = "cf"} : (i64) -> ()
      %bb3b_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb3b_17) {flag = "of"} : (i64) -> ()
      %bb3b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb3b_24) {flag = "af"} : (i64) -> ()
      %bb3b_32 = "braid.zext"(%bb3b_9) {bits = 8 : i64} : (i64) -> i64
      %bb3b_33 = "braid.popcnt"(%bb3b_32) : (i64) -> i64
      %bb3b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb3b_35 = "braid.and"(%bb3b_33, %bb3b_34) : (i64, i64) -> i64
      %bb3b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3b_37 = "braid.eq"(%bb3b_35, %bb3b_36) : (i64, i64) -> i64
      "braid.setf"(%bb3b_37) {flag = "pf"} : (i64) -> ()
      %bb3b_38 = "braid.eq"(%bb3b_9, %bb3b_36) : (i64, i64) -> i64
      "braid.setf"(%bb3b_38) {flag = "zf"} : (i64) -> ()
      %bb3b_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb3b_40 = "braid.and"(%bb3b_9, %bb3b_39) : (i64, i64) -> i64
      "braid.setf"(%bb3b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb3b_9) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb3e] : () -> ()
    ^bb3e:  // 0x40103e
      %bb3e_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb3e_0 = "braid.zext"(%bb3e_1) {bits = 32 : i64} : (i64) -> i64
      %bb3e_8 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb3e_16 = "braid.and"(%bb3e_0, %bb3e_8) : (i64, i64) -> i64
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
      "braid.set"(%bb3e_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb42] : () -> ()
    ^bb42:  // 0x401042
      %bb42_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb42_0 = "braid.zext"(%bb42_1) {bits = 32 : i64} : (i64) -> i64
      %bb42_10 = "braid.get"() {reg = "r8"} : () -> i64
      %bb42_11 = "braid.get"() {reg = "r9"} : () -> i64
      %bb42_12 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb42_13 = "braid.mul"(%bb42_11, %bb42_12) : (i64, i64) -> i64
      %bb42_14 = "braid.add"(%bb42_10, %bb42_13) : (i64, i64) -> i64
      %bb42_15 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb42_9 = "braid.add"(%bb42_14, %bb42_15) : (i64, i64) -> i64
      %bb42_8 = "braid.load"(%bb42_9) {bytes = 4 : i64} : (i64) -> i64
      %bb42_16 = "braid.xor"(%bb42_0, %bb42_8) : (i64, i64) -> i64
      %bb42_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb42_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb42_17) {flag = "of"} : (i64) -> ()
      %bb42_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb42_24) {flag = "af"} : (i64) -> ()
      %bb42_32 = "braid.zext"(%bb42_16) {bits = 8 : i64} : (i64) -> i64
      %bb42_33 = "braid.popcnt"(%bb42_32) : (i64) -> i64
      %bb42_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb42_35 = "braid.and"(%bb42_33, %bb42_34) : (i64, i64) -> i64
      %bb42_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb42_37 = "braid.eq"(%bb42_35, %bb42_36) : (i64, i64) -> i64
      "braid.setf"(%bb42_37) {flag = "pf"} : (i64) -> ()
      %bb42_38 = "braid.eq"(%bb42_16, %bb42_36) : (i64, i64) -> i64
      "braid.setf"(%bb42_38) {flag = "zf"} : (i64) -> ()
      %bb42_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb42_40 = "braid.and"(%bb42_16, %bb42_39) : (i64, i64) -> i64
      "braid.setf"(%bb42_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb42_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb46] : () -> ()
    ^bb46:  // 0x401046
      %bb46_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb46_0 = "braid.zext"(%bb46_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb46_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb49] : () -> ()
    ^bb49:  // 0x401049
      %bb49_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb49_0 = "braid.zext"(%bb49_1) {bits = 32 : i64} : (i64) -> i64
      %bb49_8 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb49_9 = "braid.lshr"(%bb49_0, %bb49_8) : (i64, i64) -> i64
      %bb49_11 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb49_12 = "braid.lshr"(%bb49_0, %bb49_11) : (i64, i64) -> i64
      %bb49_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb49_14 = "braid.and"(%bb49_12, %bb49_13) : (i64, i64) -> i64
      "braid.setf"(%bb49_14) {flag = "cf"} : (i64) -> ()
      %bb49_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb49_17) {flag = "of"} : (i64) -> ()
      %bb49_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb49_24) {flag = "af"} : (i64) -> ()
      %bb49_32 = "braid.zext"(%bb49_9) {bits = 8 : i64} : (i64) -> i64
      %bb49_33 = "braid.popcnt"(%bb49_32) : (i64) -> i64
      %bb49_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb49_35 = "braid.and"(%bb49_33, %bb49_34) : (i64, i64) -> i64
      %bb49_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb49_37 = "braid.eq"(%bb49_35, %bb49_36) : (i64, i64) -> i64
      "braid.setf"(%bb49_37) {flag = "pf"} : (i64) -> ()
      %bb49_38 = "braid.eq"(%bb49_9, %bb49_36) : (i64, i64) -> i64
      "braid.setf"(%bb49_38) {flag = "zf"} : (i64) -> ()
      %bb49_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb49_40 = "braid.and"(%bb49_9, %bb49_39) : (i64, i64) -> i64
      "braid.setf"(%bb49_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb49_9) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb4d] : () -> ()
    ^bb4d:  // 0x40104d
      %bb4d_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb4d_0 = "braid.zext"(%bb4d_1) {bits = 32 : i64} : (i64) -> i64
      %bb4d_8 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb4d_16 = "braid.and"(%bb4d_0, %bb4d_8) : (i64, i64) -> i64
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
      %bb4d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb4d_40 = "braid.and"(%bb4d_16, %bb4d_39) : (i64, i64) -> i64
      "braid.setf"(%bb4d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb4d_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x401050
      %bb50_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb50_0 = "braid.zext"(%bb50_1) {bits = 32 : i64} : (i64) -> i64
      %bb50_10 = "braid.get"() {reg = "r8"} : () -> i64
      %bb50_11 = "braid.get"() {reg = "rax"} : () -> i64
      %bb50_12 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb50_13 = "braid.mul"(%bb50_11, %bb50_12) : (i64, i64) -> i64
      %bb50_14 = "braid.add"(%bb50_10, %bb50_13) : (i64, i64) -> i64
      %bb50_15 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb50_9 = "braid.add"(%bb50_14, %bb50_15) : (i64, i64) -> i64
      %bb50_8 = "braid.load"(%bb50_9) {bytes = 4 : i64} : (i64) -> i64
      %bb50_16 = "braid.xor"(%bb50_0, %bb50_8) : (i64, i64) -> i64
      %bb50_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb50_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb50_17) {flag = "of"} : (i64) -> ()
      %bb50_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb50_24) {flag = "af"} : (i64) -> ()
      %bb50_32 = "braid.zext"(%bb50_16) {bits = 8 : i64} : (i64) -> i64
      %bb50_33 = "braid.popcnt"(%bb50_32) : (i64) -> i64
      %bb50_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb50_35 = "braid.and"(%bb50_33, %bb50_34) : (i64, i64) -> i64
      %bb50_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb50_37 = "braid.eq"(%bb50_35, %bb50_36) : (i64, i64) -> i64
      "braid.setf"(%bb50_37) {flag = "pf"} : (i64) -> ()
      %bb50_38 = "braid.eq"(%bb50_16, %bb50_36) : (i64, i64) -> i64
      "braid.setf"(%bb50_38) {flag = "zf"} : (i64) -> ()
      %bb50_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb50_40 = "braid.and"(%bb50_16, %bb50_39) : (i64, i64) -> i64
      "braid.setf"(%bb50_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb50_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x401054
      %bb54_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb54_3 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb54_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb54_5 = "braid.mul"(%bb54_3, %bb54_4) : (i64, i64) -> i64
      %bb54_6 = "braid.add"(%bb54_2, %bb54_5) : (i64, i64) -> i64
      %bb54_7 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb54_1 = "braid.add"(%bb54_6, %bb54_7) : (i64, i64) -> i64
      %bb54_0 = "braid.load"(%bb54_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb54_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb59] : () -> ()
    ^bb59:  // 0x401059
      %bb59_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb59_0 = "braid.zext"(%bb59_1) {bits = 32 : i64} : (i64) -> i64
      %bb59_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb59_8 = "braid.zext"(%bb59_9) {bits = 32 : i64} : (i64) -> i64
      %bb59_16 = "braid.xor"(%bb59_0, %bb59_8) : (i64, i64) -> i64
      %bb59_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb59_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb59_17) {flag = "of"} : (i64) -> ()
      %bb59_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb59_24) {flag = "af"} : (i64) -> ()
      %bb59_32 = "braid.zext"(%bb59_16) {bits = 8 : i64} : (i64) -> i64
      %bb59_33 = "braid.popcnt"(%bb59_32) : (i64) -> i64
      %bb59_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb59_35 = "braid.and"(%bb59_33, %bb59_34) : (i64, i64) -> i64
      %bb59_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb59_37 = "braid.eq"(%bb59_35, %bb59_36) : (i64, i64) -> i64
      "braid.setf"(%bb59_37) {flag = "pf"} : (i64) -> ()
      %bb59_38 = "braid.eq"(%bb59_16, %bb59_36) : (i64, i64) -> i64
      "braid.setf"(%bb59_38) {flag = "zf"} : (i64) -> ()
      %bb59_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb59_40 = "braid.and"(%bb59_16, %bb59_39) : (i64, i64) -> i64
      "braid.setf"(%bb59_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb59_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x40105c
      %bb5c_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb5c_0 = "braid.zext"(%bb5c_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb5c_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb5f] : () -> ()
    ^bb5f:  // 0x40105f
      %bb5f_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb5f_0 = "braid.zext"(%bb5f_1) {bits = 32 : i64} : (i64) -> i64
      %bb5f_8 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb5f_9 = "braid.lshr"(%bb5f_0, %bb5f_8) : (i64, i64) -> i64
      %bb5f_11 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb5f_12 = "braid.lshr"(%bb5f_0, %bb5f_11) : (i64, i64) -> i64
      %bb5f_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb5f_14 = "braid.and"(%bb5f_12, %bb5f_13) : (i64, i64) -> i64
      "braid.setf"(%bb5f_14) {flag = "cf"} : (i64) -> ()
      %bb5f_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb5f_17) {flag = "of"} : (i64) -> ()
      %bb5f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb5f_24) {flag = "af"} : (i64) -> ()
      %bb5f_32 = "braid.zext"(%bb5f_9) {bits = 8 : i64} : (i64) -> i64
      %bb5f_33 = "braid.popcnt"(%bb5f_32) : (i64) -> i64
      %bb5f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb5f_35 = "braid.and"(%bb5f_33, %bb5f_34) : (i64, i64) -> i64
      %bb5f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb5f_37 = "braid.eq"(%bb5f_35, %bb5f_36) : (i64, i64) -> i64
      "braid.setf"(%bb5f_37) {flag = "pf"} : (i64) -> ()
      %bb5f_38 = "braid.eq"(%bb5f_9, %bb5f_36) : (i64, i64) -> i64
      "braid.setf"(%bb5f_38) {flag = "zf"} : (i64) -> ()
      %bb5f_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb5f_40 = "braid.and"(%bb5f_9, %bb5f_39) : (i64, i64) -> i64
      "braid.setf"(%bb5f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb5f_9) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb63] : () -> ()
    ^bb63:  // 0x401063
      %bb63_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb63_0 = "braid.zext"(%bb63_1) {bits = 32 : i64} : (i64) -> i64
      %bb63_8 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb63_16 = "braid.and"(%bb63_0, %bb63_8) : (i64, i64) -> i64
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
      %bb63_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb63_40 = "braid.and"(%bb63_16, %bb63_39) : (i64, i64) -> i64
      "braid.setf"(%bb63_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb63_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb66] : () -> ()
    ^bb66:  // 0x401066
      %bb66_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb66_0 = "braid.zext"(%bb66_1) {bits = 32 : i64} : (i64) -> i64
      %bb66_10 = "braid.get"() {reg = "r8"} : () -> i64
      %bb66_11 = "braid.get"() {reg = "rax"} : () -> i64
      %bb66_12 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb66_13 = "braid.mul"(%bb66_11, %bb66_12) : (i64, i64) -> i64
      %bb66_14 = "braid.add"(%bb66_10, %bb66_13) : (i64, i64) -> i64
      %bb66_15 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb66_9 = "braid.add"(%bb66_14, %bb66_15) : (i64, i64) -> i64
      %bb66_8 = "braid.load"(%bb66_9) {bytes = 4 : i64} : (i64) -> i64
      %bb66_16 = "braid.xor"(%bb66_0, %bb66_8) : (i64, i64) -> i64
      %bb66_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb66_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb66_17) {flag = "of"} : (i64) -> ()
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
      %bb66_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb66_40 = "braid.and"(%bb66_16, %bb66_39) : (i64, i64) -> i64
      "braid.setf"(%bb66_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb66_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb6a] : () -> ()
    ^bb6a:  // 0x40106a
      %bb6a_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb6a_0 = "braid.zext"(%bb6a_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb6a_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb6d] : () -> ()
    ^bb6d:  // 0x40106d
      %bb6d_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb6d_0 = "braid.zext"(%bb6d_1) {bits = 32 : i64} : (i64) -> i64
      %bb6d_8 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb6d_9 = "braid.lshr"(%bb6d_0, %bb6d_8) : (i64, i64) -> i64
      %bb6d_11 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb6d_12 = "braid.lshr"(%bb6d_0, %bb6d_11) : (i64, i64) -> i64
      %bb6d_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6d_14 = "braid.and"(%bb6d_12, %bb6d_13) : (i64, i64) -> i64
      "braid.setf"(%bb6d_14) {flag = "cf"} : (i64) -> ()
      %bb6d_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb6d_17) {flag = "of"} : (i64) -> ()
      %bb6d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb6d_24) {flag = "af"} : (i64) -> ()
      %bb6d_32 = "braid.zext"(%bb6d_9) {bits = 8 : i64} : (i64) -> i64
      %bb6d_33 = "braid.popcnt"(%bb6d_32) : (i64) -> i64
      %bb6d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6d_35 = "braid.and"(%bb6d_33, %bb6d_34) : (i64, i64) -> i64
      %bb6d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6d_37 = "braid.eq"(%bb6d_35, %bb6d_36) : (i64, i64) -> i64
      "braid.setf"(%bb6d_37) {flag = "pf"} : (i64) -> ()
      %bb6d_38 = "braid.eq"(%bb6d_9, %bb6d_36) : (i64, i64) -> i64
      "braid.setf"(%bb6d_38) {flag = "zf"} : (i64) -> ()
      %bb6d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb6d_40 = "braid.and"(%bb6d_9, %bb6d_39) : (i64, i64) -> i64
      "braid.setf"(%bb6d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb6d_9) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x401070
      %bb70_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb70_0 = "braid.zext"(%bb70_1) {bits = 32 : i64} : (i64) -> i64
      %bb70_8 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb70_16 = "braid.and"(%bb70_0, %bb70_8) : (i64, i64) -> i64
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
      "braid.set"(%bb70_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x401074
      %bb74_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb74_0 = "braid.zext"(%bb74_1) {bits = 32 : i64} : (i64) -> i64
      %bb74_10 = "braid.get"() {reg = "r8"} : () -> i64
      %bb74_11 = "braid.get"() {reg = "r9"} : () -> i64
      %bb74_12 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb74_13 = "braid.mul"(%bb74_11, %bb74_12) : (i64, i64) -> i64
      %bb74_14 = "braid.add"(%bb74_10, %bb74_13) : (i64, i64) -> i64
      %bb74_15 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb74_9 = "braid.add"(%bb74_14, %bb74_15) : (i64, i64) -> i64
      %bb74_8 = "braid.load"(%bb74_9) {bytes = 4 : i64} : (i64) -> i64
      %bb74_16 = "braid.xor"(%bb74_0, %bb74_8) : (i64, i64) -> i64
      %bb74_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb74_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb74_17) {flag = "of"} : (i64) -> ()
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
      %bb74_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb74_40 = "braid.and"(%bb74_16, %bb74_39) : (i64, i64) -> i64
      "braid.setf"(%bb74_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb74_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x401078
      %bb78_0 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb78_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb78_16 = "braid.add"(%bb78_0, %bb78_8) : (i64, i64) -> i64
      %bb78_18 = "braid.ult"(%bb78_16, %bb78_0) : (i64, i64) -> i64
      "braid.setf"(%bb78_18) {flag = "cf"} : (i64) -> ()
      %bb78_19 = "braid.xor"(%bb78_0, %bb78_16) : (i64, i64) -> i64
      %bb78_20 = "braid.xor"(%bb78_8, %bb78_16) : (i64, i64) -> i64
      %bb78_21 = "braid.and"(%bb78_19, %bb78_20) : (i64, i64) -> i64
      %bb78_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb78_23 = "braid.and"(%bb78_21, %bb78_22) : (i64, i64) -> i64
      "braid.setf"(%bb78_23) {flag = "of"} : (i64) -> ()
      %bb78_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb78_24) {flag = "af"} : (i64) -> ()
      %bb78_32 = "braid.zext"(%bb78_16) {bits = 8 : i64} : (i64) -> i64
      %bb78_33 = "braid.popcnt"(%bb78_32) : (i64) -> i64
      %bb78_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb78_35 = "braid.and"(%bb78_33, %bb78_34) : (i64, i64) -> i64
      %bb78_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb78_37 = "braid.eq"(%bb78_35, %bb78_36) : (i64, i64) -> i64
      "braid.setf"(%bb78_37) {flag = "pf"} : (i64) -> ()
      %bb78_38 = "braid.eq"(%bb78_16, %bb78_36) : (i64, i64) -> i64
      "braid.setf"(%bb78_38) {flag = "zf"} : (i64) -> ()
      %bb78_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb78_40 = "braid.and"(%bb78_16, %bb78_39) : (i64, i64) -> i64
      "braid.setf"(%bb78_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb78_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x40107c
      %bb7c_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb7c_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb7c_16 = "braid.sub"(%bb7c_0, %bb7c_8) : (i64, i64) -> i64
      %bb7c_18 = "braid.ult"(%bb7c_0, %bb7c_8) : (i64, i64) -> i64
      "braid.setf"(%bb7c_18) {flag = "cf"} : (i64) -> ()
      %bb7c_19 = "braid.xor"(%bb7c_0, %bb7c_8) : (i64, i64) -> i64
      %bb7c_20 = "braid.xor"(%bb7c_0, %bb7c_16) : (i64, i64) -> i64
      %bb7c_21 = "braid.and"(%bb7c_19, %bb7c_20) : (i64, i64) -> i64
      %bb7c_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb7c_23 = "braid.and"(%bb7c_21, %bb7c_22) : (i64, i64) -> i64
      "braid.setf"(%bb7c_23) {flag = "of"} : (i64) -> ()
      %bb7c_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb7c_24) {flag = "af"} : (i64) -> ()
      %bb7c_32 = "braid.zext"(%bb7c_16) {bits = 8 : i64} : (i64) -> i64
      %bb7c_33 = "braid.popcnt"(%bb7c_32) : (i64) -> i64
      %bb7c_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb7c_35 = "braid.and"(%bb7c_33, %bb7c_34) : (i64, i64) -> i64
      %bb7c_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7c_37 = "braid.eq"(%bb7c_35, %bb7c_36) : (i64, i64) -> i64
      "braid.setf"(%bb7c_37) {flag = "pf"} : (i64) -> ()
      %bb7c_38 = "braid.eq"(%bb7c_16, %bb7c_36) : (i64, i64) -> i64
      "braid.setf"(%bb7c_38) {flag = "zf"} : (i64) -> ()
      %bb7c_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb7c_40 = "braid.and"(%bb7c_16, %bb7c_39) : (i64, i64) -> i64
      "braid.setf"(%bb7c_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb7f] : () -> ()
    ^bb7f:  // 0x40107f
      %bb7f_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb7f_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7f_0 = "braid.eq"(%bb7f_1, %bb7f_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb7f_0)[^bb30, ^bb81] : (i64) -> ()
    ^bb81:  // 0x401081
      %bb81_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb81_0 = "braid.zext"(%bb81_1) {bits = 8 : i64} : (i64) -> i64
      %bb81_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb81_16 = "braid.and"(%bb81_0, %bb81_8) : (i64, i64) -> i64
      %bb81_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb81_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb81_17) {flag = "of"} : (i64) -> ()
      %bb81_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb81_24) {flag = "af"} : (i64) -> ()
      %bb81_32 = "braid.zext"(%bb81_16) {bits = 8 : i64} : (i64) -> i64
      %bb81_33 = "braid.popcnt"(%bb81_32) : (i64) -> i64
      %bb81_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb81_35 = "braid.and"(%bb81_33, %bb81_34) : (i64, i64) -> i64
      %bb81_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb81_37 = "braid.eq"(%bb81_35, %bb81_36) : (i64, i64) -> i64
      "braid.setf"(%bb81_37) {flag = "pf"} : (i64) -> ()
      %bb81_38 = "braid.eq"(%bb81_16, %bb81_36) : (i64, i64) -> i64
      "braid.setf"(%bb81_38) {flag = "zf"} : (i64) -> ()
      %bb81_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb81_40 = "braid.and"(%bb81_16, %bb81_39) : (i64, i64) -> i64
      "braid.setf"(%bb81_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x401084
      %bb84_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb84_0)[^bba9, ^bb86] : (i64) -> ()
    ^bb86:  // 0x401086
      %bb86_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb86_3 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb86_4 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb86_5 = "braid.mul"(%bb86_3, %bb86_4) : (i64, i64) -> i64
      %bb86_6 = "braid.add"(%bb86_2, %bb86_5) : (i64, i64) -> i64
      %bb86_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb86_1 = "braid.add"(%bb86_6, %bb86_7) : (i64, i64) -> i64
      %bb86_0 = "braid.load"(%bb86_1) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bb86_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb8a] : () -> ()
    ^bb8a:  // 0x40108a
      %bb8a_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb8a_0 = "braid.zext"(%bb8a_1) {bits = 32 : i64} : (i64) -> i64
      %bb8a_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb8a_8 = "braid.zext"(%bb8a_9) {bits = 32 : i64} : (i64) -> i64
      %bb8a_16 = "braid.xor"(%bb8a_0, %bb8a_8) : (i64, i64) -> i64
      %bb8a_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb8a_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb8a_17) {flag = "of"} : (i64) -> ()
      %bb8a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb8a_24) {flag = "af"} : (i64) -> ()
      %bb8a_32 = "braid.zext"(%bb8a_16) {bits = 8 : i64} : (i64) -> i64
      %bb8a_33 = "braid.popcnt"(%bb8a_32) : (i64) -> i64
      %bb8a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8a_35 = "braid.and"(%bb8a_33, %bb8a_34) : (i64, i64) -> i64
      %bb8a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8a_37 = "braid.eq"(%bb8a_35, %bb8a_36) : (i64, i64) -> i64
      "braid.setf"(%bb8a_37) {flag = "pf"} : (i64) -> ()
      %bb8a_38 = "braid.eq"(%bb8a_16, %bb8a_36) : (i64, i64) -> i64
      "braid.setf"(%bb8a_38) {flag = "zf"} : (i64) -> ()
      %bb8a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb8a_40 = "braid.and"(%bb8a_16, %bb8a_39) : (i64, i64) -> i64
      "braid.setf"(%bb8a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb8a_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x40108c
      %bb8c_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb8c_0 = "braid.zext"(%bb8c_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb8c_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb8e] : () -> ()
    ^bb8e:  // 0x40108e
      %bb8e_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb8e_0 = "braid.zext"(%bb8e_1) {bits = 32 : i64} : (i64) -> i64
      %bb8e_8 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb8e_9 = "braid.lshr"(%bb8e_0, %bb8e_8) : (i64, i64) -> i64
      %bb8e_11 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb8e_12 = "braid.lshr"(%bb8e_0, %bb8e_11) : (i64, i64) -> i64
      %bb8e_13 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8e_14 = "braid.and"(%bb8e_12, %bb8e_13) : (i64, i64) -> i64
      "braid.setf"(%bb8e_14) {flag = "cf"} : (i64) -> ()
      %bb8e_17 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb8e_17) {flag = "of"} : (i64) -> ()
      %bb8e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb8e_24) {flag = "af"} : (i64) -> ()
      %bb8e_32 = "braid.zext"(%bb8e_9) {bits = 8 : i64} : (i64) -> i64
      %bb8e_33 = "braid.popcnt"(%bb8e_32) : (i64) -> i64
      %bb8e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8e_35 = "braid.and"(%bb8e_33, %bb8e_34) : (i64, i64) -> i64
      %bb8e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8e_37 = "braid.eq"(%bb8e_35, %bb8e_36) : (i64, i64) -> i64
      "braid.setf"(%bb8e_37) {flag = "pf"} : (i64) -> ()
      %bb8e_38 = "braid.eq"(%bb8e_9, %bb8e_36) : (i64, i64) -> i64
      "braid.setf"(%bb8e_38) {flag = "zf"} : (i64) -> ()
      %bb8e_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb8e_40 = "braid.and"(%bb8e_9, %bb8e_39) : (i64, i64) -> i64
      "braid.setf"(%bb8e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb8e_9) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb91] : () -> ()
    ^bb91:  // 0x401091
      %bb91_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb91_0 = "braid.zext"(%bb91_1) {bits = 32 : i64} : (i64) -> i64
      %bb91_8 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb91_16 = "braid.and"(%bb91_0, %bb91_8) : (i64, i64) -> i64
      %bb91_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb91_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb91_17) {flag = "of"} : (i64) -> ()
      %bb91_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb91_24) {flag = "af"} : (i64) -> ()
      %bb91_32 = "braid.zext"(%bb91_16) {bits = 8 : i64} : (i64) -> i64
      %bb91_33 = "braid.popcnt"(%bb91_32) : (i64) -> i64
      %bb91_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb91_35 = "braid.and"(%bb91_33, %bb91_34) : (i64, i64) -> i64
      %bb91_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb91_37 = "braid.eq"(%bb91_35, %bb91_36) : (i64, i64) -> i64
      "braid.setf"(%bb91_37) {flag = "pf"} : (i64) -> ()
      %bb91_38 = "braid.eq"(%bb91_16, %bb91_36) : (i64, i64) -> i64
      "braid.setf"(%bb91_38) {flag = "zf"} : (i64) -> ()
      %bb91_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb91_40 = "braid.and"(%bb91_16, %bb91_39) : (i64, i64) -> i64
      "braid.setf"(%bb91_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb91_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x401094
      %bb94_0 = "braid.const"() {value = 4202672 : i64} : () -> i64
      "braid.set"(%bb94_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb9b] : () -> ()
    ^bb9b:  // 0x40109b
      %bb9b_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb9b_0 = "braid.zext"(%bb9b_1) {bits = 32 : i64} : (i64) -> i64
      %bb9b_10 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb9b_11 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb9b_12 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb9b_13 = "braid.mul"(%bb9b_11, %bb9b_12) : (i64, i64) -> i64
      %bb9b_14 = "braid.add"(%bb9b_10, %bb9b_13) : (i64, i64) -> i64
      %bb9b_15 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9b_9 = "braid.add"(%bb9b_14, %bb9b_15) : (i64, i64) -> i64
      %bb9b_8 = "braid.load"(%bb9b_9) {bytes = 4 : i64} : (i64) -> i64
      %bb9b_16 = "braid.xor"(%bb9b_0, %bb9b_8) : (i64, i64) -> i64
      %bb9b_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb9b_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb9b_17) {flag = "of"} : (i64) -> ()
      %bb9b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb9b_24) {flag = "af"} : (i64) -> ()
      %bb9b_32 = "braid.zext"(%bb9b_16) {bits = 8 : i64} : (i64) -> i64
      %bb9b_33 = "braid.popcnt"(%bb9b_32) : (i64) -> i64
      %bb9b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb9b_35 = "braid.and"(%bb9b_33, %bb9b_34) : (i64, i64) -> i64
      %bb9b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9b_37 = "braid.eq"(%bb9b_35, %bb9b_36) : (i64, i64) -> i64
      "braid.setf"(%bb9b_37) {flag = "pf"} : (i64) -> ()
      %bb9b_38 = "braid.eq"(%bb9b_16, %bb9b_36) : (i64, i64) -> i64
      "braid.setf"(%bb9b_38) {flag = "zf"} : (i64) -> ()
      %bb9b_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb9b_40 = "braid.and"(%bb9b_16, %bb9b_39) : (i64, i64) -> i64
      "braid.setf"(%bb9b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb9b_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb9e] : () -> ()
    ^bb9e:  // 0x40109e
      %bb9e_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb9e_0 = "braid.zext"(%bb9e_1) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bb9e_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x4010a0
      %bba0_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bba0_0 = "braid.zext"(%bba0_1) {bits = 32 : i64} : (i64) -> i64
      %bba0_8 = "braid.const"() {value = 4 : i64} : () -> i64
      %bba0_9 = "braid.lshr"(%bba0_0, %bba0_8) : (i64, i64) -> i64
      %bba0_11 = "braid.const"() {value = 3 : i64} : () -> i64
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
      "braid.set"(%bba0_9) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bba3] : () -> ()
    ^bba3:  // 0x4010a3
      %bba3_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bba3_0 = "braid.zext"(%bba3_1) {bits = 32 : i64} : (i64) -> i64
      %bba3_8 = "braid.const"() {value = 15 : i64} : () -> i64
      %bba3_16 = "braid.and"(%bba3_0, %bba3_8) : (i64, i64) -> i64
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
      "braid.set"(%bba3_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bba6] : () -> ()
    ^bba6:  // 0x4010a6
      %bba6_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bba6_0 = "braid.zext"(%bba6_1) {bits = 32 : i64} : (i64) -> i64
      %bba6_10 = "braid.get"() {reg = "rsi"} : () -> i64
      %bba6_11 = "braid.get"() {reg = "rdx"} : () -> i64
      %bba6_12 = "braid.const"() {value = 4 : i64} : () -> i64
      %bba6_13 = "braid.mul"(%bba6_11, %bba6_12) : (i64, i64) -> i64
      %bba6_14 = "braid.add"(%bba6_10, %bba6_13) : (i64, i64) -> i64
      %bba6_15 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba6_9 = "braid.add"(%bba6_14, %bba6_15) : (i64, i64) -> i64
      %bba6_8 = "braid.load"(%bba6_9) {bytes = 4 : i64} : (i64) -> i64
      %bba6_16 = "braid.xor"(%bba6_0, %bba6_8) : (i64, i64) -> i64
      %bba6_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bba6_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bba6_17) {flag = "of"} : (i64) -> ()
      %bba6_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bba6_24) {flag = "af"} : (i64) -> ()
      %bba6_32 = "braid.zext"(%bba6_16) {bits = 8 : i64} : (i64) -> i64
      %bba6_33 = "braid.popcnt"(%bba6_32) : (i64) -> i64
      %bba6_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bba6_35 = "braid.and"(%bba6_33, %bba6_34) : (i64, i64) -> i64
      %bba6_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba6_37 = "braid.eq"(%bba6_35, %bba6_36) : (i64, i64) -> i64
      "braid.setf"(%bba6_37) {flag = "pf"} : (i64) -> ()
      %bba6_38 = "braid.eq"(%bba6_16, %bba6_36) : (i64, i64) -> i64
      "braid.setf"(%bba6_38) {flag = "zf"} : (i64) -> ()
      %bba6_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bba6_40 = "braid.and"(%bba6_16, %bba6_39) : (i64, i64) -> i64
      "braid.setf"(%bba6_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bba6_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bba9] : () -> ()
    ^bba9:  // 0x4010a9
      %bba9_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bba9_0 = "braid.zext"(%bba9_1) {bits = 32 : i64} : (i64) -> i64
      %bba9_8 = "braid.not"(%bba9_0) : (i64) -> i64
      %bba9_9 = "braid.zext"(%bba9_8) {bits = 32 : i64} : (i64) -> i64
      "braid.set"(%bba9_9) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbab] : () -> ()
    ^bbab:  // 0x4010ab
      %bbab_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbab_1 = "braid.load"(%bbab_0) {bytes = 8 : i64} : (i64) -> i64
      %bbab_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbab_3 = "braid.add"(%bbab_0, %bbab_2) : (i64, i64) -> i64
      "braid.set"(%bbab_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bbab_1) : (i64) -> ()
  }) {sym_name = "crc32", entry = 4198400 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
