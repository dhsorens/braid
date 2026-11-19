"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb0_8 = "braid.get"() {reg = "rcx"} : () -> i64
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
      "braid_cf.cond_br"(%bb3_0)[^bb12, ^bb5] : (i64) -> ()
    ^bb5:  // 0x401005
      %bb5_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb5_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb5_16 = "braid.sub"(%bb5_0, %bb5_8) : (i64, i64) -> i64
      %bb5_18 = "braid.ult"(%bb5_0, %bb5_8) : (i64, i64) -> i64
      "braid.setf"(%bb5_18) {flag = "cf"} : (i64) -> ()
      %bb5_19 = "braid.xor"(%bb5_0, %bb5_8) : (i64, i64) -> i64
      %bb5_20 = "braid.xor"(%bb5_0, %bb5_16) : (i64, i64) -> i64
      %bb5_21 = "braid.and"(%bb5_19, %bb5_20) : (i64, i64) -> i64
      %bb5_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb5_23 = "braid.and"(%bb5_21, %bb5_22) : (i64, i64) -> i64
      "braid.setf"(%bb5_23) {flag = "of"} : (i64) -> ()
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
      "braid_cf.br"()[^bb9] : () -> ()
    ^bb9:  // 0x401009
      %bb9_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb9_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9_0 = "braid.eq"(%bb9_1, %bb9_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb9_0)[^bb15, ^bbb] : (i64) -> ()
    ^bbb:  // 0x40100b
      %bbb_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbb_0 = "braid.zext"(%bbb_1) {bits = 32 : i64} : (i64) -> i64
      %bbb_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bbb_8 = "braid.zext"(%bbb_9) {bits = 32 : i64} : (i64) -> i64
      %bbb_16 = "braid.xor"(%bbb_0, %bbb_8) : (i64, i64) -> i64
      %bbb_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbb_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbb_17) {flag = "of"} : (i64) -> ()
      %bbb_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbb_24) {flag = "af"} : (i64) -> ()
      %bbb_32 = "braid.zext"(%bbb_16) {bits = 8 : i64} : (i64) -> i64
      %bbb_33 = "braid.popcnt"(%bbb_32) : (i64) -> i64
      %bbb_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbb_35 = "braid.and"(%bbb_33, %bbb_34) : (i64, i64) -> i64
      %bbb_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb_37 = "braid.eq"(%bbb_35, %bbb_36) : (i64, i64) -> i64
      "braid.setf"(%bbb_37) {flag = "pf"} : (i64) -> ()
      %bbb_38 = "braid.eq"(%bbb_16, %bbb_36) : (i64, i64) -> i64
      "braid.setf"(%bbb_38) {flag = "zf"} : (i64) -> ()
      %bbb_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbb_40 = "braid.and"(%bbb_16, %bbb_39) : (i64, i64) -> i64
      "braid.setf"(%bbb_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbb_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbd] : () -> ()
    ^bbd:  // 0x40100d
      %bbd_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbd_0 = "braid.zext"(%bbd_1) {bits = 32 : i64} : (i64) -> i64
      %bbd_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bbd_8 = "braid.zext"(%bbd_9) {bits = 32 : i64} : (i64) -> i64
      %bbd_16 = "braid.xor"(%bbd_0, %bbd_8) : (i64, i64) -> i64
      %bbd_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbd_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbd_17) {flag = "of"} : (i64) -> ()
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
      %bbd_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbd_40 = "braid.and"(%bbd_16, %bbd_39) : (i64, i64) -> i64
      "braid.setf"(%bbd_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbd_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401010
      "braid_cf.br"()[^bb77] : () -> ()
    ^bb12:  // 0x401012
      %bb12_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb12_0 = "braid.zext"(%bb12_1) {bits = 32 : i64} : (i64) -> i64
      %bb12_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb12_8 = "braid.zext"(%bb12_9) {bits = 32 : i64} : (i64) -> i64
      %bb12_16 = "braid.xor"(%bb12_0, %bb12_8) : (i64, i64) -> i64
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
      "braid.set"(%bb12_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x401014
      %bb14_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb14_1 = "braid.load"(%bb14_0) {bytes = 8 : i64} : (i64) -> i64
      %bb14_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb14_3 = "braid.add"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      "braid.set"(%bb14_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb14_1) : (i64) -> ()
    ^bb15:  // 0x401015
      %bb15_0 = "braid.get"() {reg = "rcx"} : () -> i64
      "braid.set"(%bb15_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x401018
      %bb18_0 = "braid.get"() {reg = "r9"} : () -> i64
      %bb18_8 = "braid.const"() {value = -2 : i64} : () -> i64
      %bb18_16 = "braid.and"(%bb18_0, %bb18_8) : (i64, i64) -> i64
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
      %bb18_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb18_40 = "braid.and"(%bb18_16, %bb18_39) : (i64, i64) -> i64
      "braid.setf"(%bb18_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb18_16) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x40101c
      %bb1c_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1c_0 = "braid.zext"(%bb1c_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1c_8 = "braid.zext"(%bb1c_9) {bits = 32 : i64} : (i64) -> i64
      %bb1c_16 = "braid.xor"(%bb1c_0, %bb1c_8) : (i64, i64) -> i64
      %bb1c_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1c_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1c_17) {flag = "of"} : (i64) -> ()
      %bb1c_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1c_24) {flag = "af"} : (i64) -> ()
      %bb1c_32 = "braid.zext"(%bb1c_16) {bits = 8 : i64} : (i64) -> i64
      %bb1c_33 = "braid.popcnt"(%bb1c_32) : (i64) -> i64
      %bb1c_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1c_35 = "braid.and"(%bb1c_33, %bb1c_34) : (i64, i64) -> i64
      %bb1c_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_37 = "braid.eq"(%bb1c_35, %bb1c_36) : (i64, i64) -> i64
      "braid.setf"(%bb1c_37) {flag = "pf"} : (i64) -> ()
      %bb1c_38 = "braid.eq"(%bb1c_16, %bb1c_36) : (i64, i64) -> i64
      "braid.setf"(%bb1c_38) {flag = "zf"} : (i64) -> ()
      %bb1c_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1c_40 = "braid.and"(%bb1c_16, %bb1c_39) : (i64, i64) -> i64
      "braid.setf"(%bb1c_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1c_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1e] : () -> ()
    ^bb1e:  // 0x40101e
      %bb1e_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb1e_0 = "braid.zext"(%bb1e_1) {bits = 32 : i64} : (i64) -> i64
      %bb1e_9 = "braid.get"() {reg = "r8"} : () -> i64
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
      "braid.set"(%bb1e_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb21] : () -> ()
    ^bb21:  // 0x401021
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x401030
      %bb30_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb30_3 = "braid.get"() {reg = "r8"} : () -> i64
      %bb30_4 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb30_5 = "braid.mul"(%bb30_3, %bb30_4) : (i64, i64) -> i64
      %bb30_6 = "braid.add"(%bb30_2, %bb30_5) : (i64, i64) -> i64
      %bb30_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb30_1 = "braid.add"(%bb30_6, %bb30_7) : (i64, i64) -> i64
      %bb30_0 = "braid.load"(%bb30_1) {bytes = 8 : i64} : (i64) -> i64
      %bb30_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb30_16 = "braid.add"(%bb30_0, %bb30_8) : (i64, i64) -> i64
      %bb30_18 = "braid.ult"(%bb30_16, %bb30_0) : (i64, i64) -> i64
      "braid.setf"(%bb30_18) {flag = "cf"} : (i64) -> ()
      %bb30_19 = "braid.xor"(%bb30_0, %bb30_16) : (i64, i64) -> i64
      %bb30_20 = "braid.xor"(%bb30_8, %bb30_16) : (i64, i64) -> i64
      %bb30_21 = "braid.and"(%bb30_19, %bb30_20) : (i64, i64) -> i64
      %bb30_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb30_23 = "braid.and"(%bb30_21, %bb30_22) : (i64, i64) -> i64
      "braid.setf"(%bb30_23) {flag = "of"} : (i64) -> ()
      %bb30_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb30_24) {flag = "af"} : (i64) -> ()
      %bb30_32 = "braid.zext"(%bb30_16) {bits = 8 : i64} : (i64) -> i64
      %bb30_33 = "braid.popcnt"(%bb30_32) : (i64) -> i64
      %bb30_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb30_35 = "braid.and"(%bb30_33, %bb30_34) : (i64, i64) -> i64
      %bb30_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb30_37 = "braid.eq"(%bb30_35, %bb30_36) : (i64, i64) -> i64
      "braid.setf"(%bb30_37) {flag = "pf"} : (i64) -> ()
      %bb30_38 = "braid.eq"(%bb30_16, %bb30_36) : (i64, i64) -> i64
      "braid.setf"(%bb30_38) {flag = "zf"} : (i64) -> ()
      %bb30_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb30_40 = "braid.and"(%bb30_16, %bb30_39) : (i64, i64) -> i64
      "braid.setf"(%bb30_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb30_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x401034
      %bb34_0 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb34_8 = "braid.get"() {reg = "r10"} : () -> i64
      %bb34_9 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb34_10 = "braid.and"(%bb34_8, %bb34_9) : (i64, i64) -> i64
      %bb34_11 = "braid.or"(%bb34_10, %bb34_0) : (i64, i64) -> i64
      "braid.set"(%bb34_11) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x401038
      %bb38_2 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb38_3 = "braid.get"() {reg = "r8"} : () -> i64
      %bb38_4 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb38_5 = "braid.mul"(%bb38_3, %bb38_4) : (i64, i64) -> i64
      %bb38_6 = "braid.add"(%bb38_2, %bb38_5) : (i64, i64) -> i64
      %bb38_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb38_1 = "braid.add"(%bb38_6, %bb38_7) : (i64, i64) -> i64
      %bb38_0 = "braid.load"(%bb38_1) {bytes = 8 : i64} : (i64) -> i64
      %bb38_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb38_16 = "braid.add"(%bb38_0, %bb38_8) : (i64, i64) -> i64
      %bb38_18 = "braid.ult"(%bb38_16, %bb38_0) : (i64, i64) -> i64
      "braid.setf"(%bb38_18) {flag = "cf"} : (i64) -> ()
      %bb38_19 = "braid.xor"(%bb38_0, %bb38_16) : (i64, i64) -> i64
      %bb38_20 = "braid.xor"(%bb38_8, %bb38_16) : (i64, i64) -> i64
      %bb38_21 = "braid.and"(%bb38_19, %bb38_20) : (i64, i64) -> i64
      %bb38_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb38_23 = "braid.and"(%bb38_21, %bb38_22) : (i64, i64) -> i64
      "braid.setf"(%bb38_23) {flag = "of"} : (i64) -> ()
      %bb38_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb38_24) {flag = "af"} : (i64) -> ()
      %bb38_32 = "braid.zext"(%bb38_16) {bits = 8 : i64} : (i64) -> i64
      %bb38_33 = "braid.popcnt"(%bb38_32) : (i64) -> i64
      %bb38_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb38_35 = "braid.and"(%bb38_33, %bb38_34) : (i64, i64) -> i64
      %bb38_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb38_37 = "braid.eq"(%bb38_35, %bb38_36) : (i64, i64) -> i64
      "braid.setf"(%bb38_37) {flag = "pf"} : (i64) -> ()
      %bb38_38 = "braid.eq"(%bb38_16, %bb38_36) : (i64, i64) -> i64
      "braid.setf"(%bb38_38) {flag = "zf"} : (i64) -> ()
      %bb38_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb38_40 = "braid.and"(%bb38_16, %bb38_39) : (i64, i64) -> i64
      "braid.setf"(%bb38_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb38_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x40103c
      %bb3c_0 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb3c_8 = "braid.get"() {reg = "r11"} : () -> i64
      %bb3c_9 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb3c_10 = "braid.and"(%bb3c_8, %bb3c_9) : (i64, i64) -> i64
      %bb3c_11 = "braid.or"(%bb3c_10, %bb3c_0) : (i64, i64) -> i64
      "braid.set"(%bb3c_11) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x401040
      %bb40_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb40_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb40_10 = "braid.get"() {reg = "r8"} : () -> i64
      %bb40_11 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb40_12 = "braid.mul"(%bb40_10, %bb40_11) : (i64, i64) -> i64
      %bb40_13 = "braid.add"(%bb40_9, %bb40_12) : (i64, i64) -> i64
      %bb40_14 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb40_8 = "braid.add"(%bb40_13, %bb40_14) : (i64, i64) -> i64
      "braid.store"(%bb40_8, %bb40_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x401044
      %bb44_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb44_0 = "braid.zext"(%bb44_1) {bits = 8 : i64} : (i64) -> i64
      %bb44_9 = "braid.get"() {reg = "r10"} : () -> i64
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
      %bb44_48 = "braid.get"() {reg = "r11"} : () -> i64
      %bb44_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb44_50 = "braid.and"(%bb44_48, %bb44_49) : (i64, i64) -> i64
      %bb44_51 = "braid.or"(%bb44_50, %bb44_16) : (i64, i64) -> i64
      "braid.set"(%bb44_51) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb47] : () -> ()
    ^bb47:  // 0x401047
      %bb47_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb47_0 = "braid.zext"(%bb47_1) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bb47_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb4b] : () -> ()
    ^bb4b:  // 0x40104b
      %bb4b_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb4b_3 = "braid.get"() {reg = "r8"} : () -> i64
      %bb4b_4 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb4b_5 = "braid.mul"(%bb4b_3, %bb4b_4) : (i64, i64) -> i64
      %bb4b_6 = "braid.add"(%bb4b_2, %bb4b_5) : (i64, i64) -> i64
      %bb4b_7 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb4b_1 = "braid.add"(%bb4b_6, %bb4b_7) : (i64, i64) -> i64
      %bb4b_0 = "braid.load"(%bb4b_1) {bytes = 8 : i64} : (i64) -> i64
      %bb4b_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb4b_16 = "braid.add"(%bb4b_0, %bb4b_8) : (i64, i64) -> i64
      %bb4b_18 = "braid.ult"(%bb4b_16, %bb4b_0) : (i64, i64) -> i64
      "braid.setf"(%bb4b_18) {flag = "cf"} : (i64) -> ()
      %bb4b_19 = "braid.xor"(%bb4b_0, %bb4b_16) : (i64, i64) -> i64
      %bb4b_20 = "braid.xor"(%bb4b_8, %bb4b_16) : (i64, i64) -> i64
      %bb4b_21 = "braid.and"(%bb4b_19, %bb4b_20) : (i64, i64) -> i64
      %bb4b_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb4b_23 = "braid.and"(%bb4b_21, %bb4b_22) : (i64, i64) -> i64
      "braid.setf"(%bb4b_23) {flag = "of"} : (i64) -> ()
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
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x401050
      %bb50_0 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb50_8 = "braid.get"() {reg = "r10"} : () -> i64
      %bb50_9 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb50_10 = "braid.and"(%bb50_8, %bb50_9) : (i64, i64) -> i64
      %bb50_11 = "braid.or"(%bb50_10, %bb50_0) : (i64, i64) -> i64
      "braid.set"(%bb50_11) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x401054
      %bb54_2 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb54_3 = "braid.get"() {reg = "r8"} : () -> i64
      %bb54_4 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb54_5 = "braid.mul"(%bb54_3, %bb54_4) : (i64, i64) -> i64
      %bb54_6 = "braid.add"(%bb54_2, %bb54_5) : (i64, i64) -> i64
      %bb54_7 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb54_1 = "braid.add"(%bb54_6, %bb54_7) : (i64, i64) -> i64
      %bb54_0 = "braid.load"(%bb54_1) {bytes = 8 : i64} : (i64) -> i64
      %bb54_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb54_16 = "braid.add"(%bb54_0, %bb54_8) : (i64, i64) -> i64
      %bb54_18 = "braid.ult"(%bb54_16, %bb54_0) : (i64, i64) -> i64
      "braid.setf"(%bb54_18) {flag = "cf"} : (i64) -> ()
      %bb54_19 = "braid.xor"(%bb54_0, %bb54_16) : (i64, i64) -> i64
      %bb54_20 = "braid.xor"(%bb54_8, %bb54_16) : (i64, i64) -> i64
      %bb54_21 = "braid.and"(%bb54_19, %bb54_20) : (i64, i64) -> i64
      %bb54_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb54_23 = "braid.and"(%bb54_21, %bb54_22) : (i64, i64) -> i64
      "braid.setf"(%bb54_23) {flag = "of"} : (i64) -> ()
      %bb54_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb54_24) {flag = "af"} : (i64) -> ()
      %bb54_32 = "braid.zext"(%bb54_16) {bits = 8 : i64} : (i64) -> i64
      %bb54_33 = "braid.popcnt"(%bb54_32) : (i64) -> i64
      %bb54_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb54_35 = "braid.and"(%bb54_33, %bb54_34) : (i64, i64) -> i64
      %bb54_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb54_37 = "braid.eq"(%bb54_35, %bb54_36) : (i64, i64) -> i64
      "braid.setf"(%bb54_37) {flag = "pf"} : (i64) -> ()
      %bb54_38 = "braid.eq"(%bb54_16, %bb54_36) : (i64, i64) -> i64
      "braid.setf"(%bb54_38) {flag = "zf"} : (i64) -> ()
      %bb54_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb54_40 = "braid.and"(%bb54_16, %bb54_39) : (i64, i64) -> i64
      "braid.setf"(%bb54_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb54_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb59] : () -> ()
    ^bb59:  // 0x401059
      %bb59_0 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb59_8 = "braid.get"() {reg = "r11"} : () -> i64
      %bb59_9 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb59_10 = "braid.and"(%bb59_8, %bb59_9) : (i64, i64) -> i64
      %bb59_11 = "braid.or"(%bb59_10, %bb59_0) : (i64, i64) -> i64
      "braid.set"(%bb59_11) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb5d] : () -> ()
    ^bb5d:  // 0x40105d
      %bb5d_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb5d_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb5d_10 = "braid.get"() {reg = "r8"} : () -> i64
      %bb5d_11 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb5d_12 = "braid.mul"(%bb5d_10, %bb5d_11) : (i64, i64) -> i64
      %bb5d_13 = "braid.add"(%bb5d_9, %bb5d_12) : (i64, i64) -> i64
      %bb5d_14 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb5d_8 = "braid.add"(%bb5d_13, %bb5d_14) : (i64, i64) -> i64
      "braid.store"(%bb5d_8, %bb5d_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb62] : () -> ()
    ^bb62:  // 0x401062
      %bb62_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb62_0 = "braid.zext"(%bb62_1) {bits = 8 : i64} : (i64) -> i64
      %bb62_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb62_8 = "braid.zext"(%bb62_9) {bits = 8 : i64} : (i64) -> i64
      %bb62_16 = "braid.or"(%bb62_0, %bb62_8) : (i64, i64) -> i64
      %bb62_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb62_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb62_17) {flag = "of"} : (i64) -> ()
      %bb62_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb62_24) {flag = "af"} : (i64) -> ()
      %bb62_32 = "braid.zext"(%bb62_16) {bits = 8 : i64} : (i64) -> i64
      %bb62_33 = "braid.popcnt"(%bb62_32) : (i64) -> i64
      %bb62_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb62_35 = "braid.and"(%bb62_33, %bb62_34) : (i64, i64) -> i64
      %bb62_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb62_37 = "braid.eq"(%bb62_35, %bb62_36) : (i64, i64) -> i64
      "braid.setf"(%bb62_37) {flag = "pf"} : (i64) -> ()
      %bb62_38 = "braid.eq"(%bb62_16, %bb62_36) : (i64, i64) -> i64
      "braid.setf"(%bb62_38) {flag = "zf"} : (i64) -> ()
      %bb62_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb62_40 = "braid.and"(%bb62_16, %bb62_39) : (i64, i64) -> i64
      "braid.setf"(%bb62_40) {flag = "sf"} : (i64) -> ()
      %bb62_48 = "braid.get"() {reg = "r11"} : () -> i64
      %bb62_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb62_50 = "braid.and"(%bb62_48, %bb62_49) : (i64, i64) -> i64
      %bb62_51 = "braid.or"(%bb62_50, %bb62_16) : (i64, i64) -> i64
      "braid.set"(%bb62_51) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb65] : () -> ()
    ^bb65:  // 0x401065
      %bb65_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb65_0 = "braid.zext"(%bb65_1) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bb65_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb69] : () -> ()
    ^bb69:  // 0x401069
      %bb69_0 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb69_8 = "braid.get"() {reg = "r8"} : () -> i64
      %bb69_16 = "braid.add"(%bb69_0, %bb69_8) : (i64, i64) -> i64
      %bb69_18 = "braid.ult"(%bb69_16, %bb69_0) : (i64, i64) -> i64
      "braid.setf"(%bb69_18) {flag = "cf"} : (i64) -> ()
      %bb69_19 = "braid.xor"(%bb69_0, %bb69_16) : (i64, i64) -> i64
      %bb69_20 = "braid.xor"(%bb69_8, %bb69_16) : (i64, i64) -> i64
      %bb69_21 = "braid.and"(%bb69_19, %bb69_20) : (i64, i64) -> i64
      %bb69_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb69_23 = "braid.and"(%bb69_21, %bb69_22) : (i64, i64) -> i64
      "braid.setf"(%bb69_23) {flag = "of"} : (i64) -> ()
      %bb69_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb69_24) {flag = "af"} : (i64) -> ()
      %bb69_32 = "braid.zext"(%bb69_16) {bits = 8 : i64} : (i64) -> i64
      %bb69_33 = "braid.popcnt"(%bb69_32) : (i64) -> i64
      %bb69_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb69_35 = "braid.and"(%bb69_33, %bb69_34) : (i64, i64) -> i64
      %bb69_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb69_37 = "braid.eq"(%bb69_35, %bb69_36) : (i64, i64) -> i64
      "braid.setf"(%bb69_37) {flag = "pf"} : (i64) -> ()
      %bb69_38 = "braid.eq"(%bb69_16, %bb69_36) : (i64, i64) -> i64
      "braid.setf"(%bb69_38) {flag = "zf"} : (i64) -> ()
      %bb69_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb69_40 = "braid.and"(%bb69_16, %bb69_39) : (i64, i64) -> i64
      "braid.setf"(%bb69_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb69_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb6d] : () -> ()
    ^bb6d:  // 0x40106d
      %bb6d_0 = "braid.get"() {reg = "r9"} : () -> i64
      %bb6d_8 = "braid.get"() {reg = "r8"} : () -> i64
      %bb6d_16 = "braid.sub"(%bb6d_0, %bb6d_8) : (i64, i64) -> i64
      %bb6d_18 = "braid.ult"(%bb6d_0, %bb6d_8) : (i64, i64) -> i64
      "braid.setf"(%bb6d_18) {flag = "cf"} : (i64) -> ()
      %bb6d_19 = "braid.xor"(%bb6d_0, %bb6d_8) : (i64, i64) -> i64
      %bb6d_20 = "braid.xor"(%bb6d_0, %bb6d_16) : (i64, i64) -> i64
      %bb6d_21 = "braid.and"(%bb6d_19, %bb6d_20) : (i64, i64) -> i64
      %bb6d_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb6d_23 = "braid.and"(%bb6d_21, %bb6d_22) : (i64, i64) -> i64
      "braid.setf"(%bb6d_23) {flag = "of"} : (i64) -> ()
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
      %bb6d_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb6d_40 = "braid.and"(%bb6d_16, %bb6d_39) : (i64, i64) -> i64
      "braid.setf"(%bb6d_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x401070
      %bb70_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb70_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb70_0 = "braid.eq"(%bb70_1, %bb70_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb70_0)[^bb30, ^bb72] : (i64) -> ()
    ^bb72:  // 0x401072
      %bb72_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb72_0 = "braid.zext"(%bb72_1) {bits = 8 : i64} : (i64) -> i64
      %bb72_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb72_16 = "braid.and"(%bb72_0, %bb72_8) : (i64, i64) -> i64
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
      %bb72_39 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb72_40 = "braid.and"(%bb72_16, %bb72_39) : (i64, i64) -> i64
      "braid.setf"(%bb72_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb75] : () -> ()
    ^bb75:  // 0x401075
      %bb75_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb75_0)[^bb8e, ^bb77] : (i64) -> ()
    ^bb77:  // 0x401077
      %bb77_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb77_3 = "braid.get"() {reg = "r8"} : () -> i64
      %bb77_4 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb77_5 = "braid.mul"(%bb77_3, %bb77_4) : (i64, i64) -> i64
      %bb77_6 = "braid.add"(%bb77_2, %bb77_5) : (i64, i64) -> i64
      %bb77_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb77_1 = "braid.add"(%bb77_6, %bb77_7) : (i64, i64) -> i64
      %bb77_0 = "braid.load"(%bb77_1) {bytes = 8 : i64} : (i64) -> i64
      %bb77_8 = "braid.get"() {reg = "rax"} : () -> i64
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
      "braid.set"(%bb77_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb7b] : () -> ()
    ^bb7b:  // 0x40107b
      %bb7b_0 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb7b_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb7b_9 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb7b_10 = "braid.and"(%bb7b_8, %bb7b_9) : (i64, i64) -> i64
      %bb7b_11 = "braid.or"(%bb7b_10, %bb7b_0) : (i64, i64) -> i64
      "braid.set"(%bb7b_11) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb7e] : () -> ()
    ^bb7e:  // 0x40107e
      %bb7e_2 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb7e_3 = "braid.get"() {reg = "r8"} : () -> i64
      %bb7e_4 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb7e_5 = "braid.mul"(%bb7e_3, %bb7e_4) : (i64, i64) -> i64
      %bb7e_6 = "braid.add"(%bb7e_2, %bb7e_5) : (i64, i64) -> i64
      %bb7e_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7e_1 = "braid.add"(%bb7e_6, %bb7e_7) : (i64, i64) -> i64
      %bb7e_0 = "braid.load"(%bb7e_1) {bytes = 8 : i64} : (i64) -> i64
      %bb7e_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb7e_16 = "braid.add"(%bb7e_0, %bb7e_8) : (i64, i64) -> i64
      %bb7e_18 = "braid.ult"(%bb7e_16, %bb7e_0) : (i64, i64) -> i64
      "braid.setf"(%bb7e_18) {flag = "cf"} : (i64) -> ()
      %bb7e_19 = "braid.xor"(%bb7e_0, %bb7e_16) : (i64, i64) -> i64
      %bb7e_20 = "braid.xor"(%bb7e_8, %bb7e_16) : (i64, i64) -> i64
      %bb7e_21 = "braid.and"(%bb7e_19, %bb7e_20) : (i64, i64) -> i64
      %bb7e_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb7e_23 = "braid.and"(%bb7e_21, %bb7e_22) : (i64, i64) -> i64
      "braid.setf"(%bb7e_23) {flag = "of"} : (i64) -> ()
      %bb7e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb7e_24) {flag = "af"} : (i64) -> ()
      %bb7e_32 = "braid.zext"(%bb7e_16) {bits = 8 : i64} : (i64) -> i64
      %bb7e_33 = "braid.popcnt"(%bb7e_32) : (i64) -> i64
      %bb7e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb7e_35 = "braid.and"(%bb7e_33, %bb7e_34) : (i64, i64) -> i64
      %bb7e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7e_37 = "braid.eq"(%bb7e_35, %bb7e_36) : (i64, i64) -> i64
      "braid.setf"(%bb7e_37) {flag = "pf"} : (i64) -> ()
      %bb7e_38 = "braid.eq"(%bb7e_16, %bb7e_36) : (i64, i64) -> i64
      "braid.setf"(%bb7e_38) {flag = "zf"} : (i64) -> ()
      %bb7e_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb7e_40 = "braid.and"(%bb7e_16, %bb7e_39) : (i64, i64) -> i64
      "braid.setf"(%bb7e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb7e_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb82] : () -> ()
    ^bb82:  // 0x401082
      %bb82_0 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb82_8 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb82_9 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb82_10 = "braid.and"(%bb82_8, %bb82_9) : (i64, i64) -> i64
      %bb82_11 = "braid.or"(%bb82_10, %bb82_0) : (i64, i64) -> i64
      "braid.set"(%bb82_11) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb85] : () -> ()
    ^bb85:  // 0x401085
      %bb85_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb85_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb85_10 = "braid.get"() {reg = "r8"} : () -> i64
      %bb85_11 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb85_12 = "braid.mul"(%bb85_10, %bb85_11) : (i64, i64) -> i64
      %bb85_13 = "braid.add"(%bb85_9, %bb85_12) : (i64, i64) -> i64
      %bb85_14 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb85_8 = "braid.add"(%bb85_13, %bb85_14) : (i64, i64) -> i64
      "braid.store"(%bb85_8, %bb85_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb89] : () -> ()
    ^bb89:  // 0x401089
      %bb89_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb89_0 = "braid.zext"(%bb89_1) {bits = 8 : i64} : (i64) -> i64
      %bb89_9 = "braid.get"() {reg = "rcx"} : () -> i64
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
      %bb89_48 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb89_49 = "braid.const"() {value = -256 : i64} : () -> i64
      %bb89_50 = "braid.and"(%bb89_48, %bb89_49) : (i64, i64) -> i64
      %bb89_51 = "braid.or"(%bb89_50, %bb89_16) : (i64, i64) -> i64
      "braid.set"(%bb89_51) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb8b] : () -> ()
    ^bb8b:  // 0x40108b
      %bb8b_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb8b_0 = "braid.zext"(%bb8b_1) {bits = 8 : i64} : (i64) -> i64
      "braid.set"(%bb8b_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb8e] : () -> ()
    ^bb8e:  // 0x40108e
      %bb8e_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb8e_1 = "braid.load"(%bb8e_0) {bytes = 8 : i64} : (i64) -> i64
      %bb8e_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8e_3 = "braid.add"(%bb8e_0, %bb8e_2) : (i64, i64) -> i64
      "braid.set"(%bb8e_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb8e_1) : (i64) -> ()
  }) {sym_name = "add_limbs", entry = 4198400 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
