"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb0_8 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb0_16 = "braid.add"(%bb0_0, %bb0_8) : (i64, i64) -> i64
      %bb0_18 = "braid.ult"(%bb0_16, %bb0_0) : (i64, i64) -> i64
      "braid.setf"(%bb0_18) {flag = "cf"} : (i64) -> ()
      %bb0_19 = "braid.xor"(%bb0_0, %bb0_16) : (i64, i64) -> i64
      %bb0_20 = "braid.xor"(%bb0_8, %bb0_16) : (i64, i64) -> i64
      %bb0_21 = "braid.and"(%bb0_19, %bb0_20) : (i64, i64) -> i64
      %bb0_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb0_23 = "braid.and"(%bb0_21, %bb0_22) : (i64, i64) -> i64
      "braid.setf"(%bb0_23) {flag = "of"} : (i64) -> ()
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
      "braid.set"(%bb0_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401003
      %bb3_0 = "braid.get"() {reg = "r8"} : () -> i64
      %bb3_8 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb3_16 = "braid.add"(%bb3_0, %bb3_8) : (i64, i64) -> i64
      %bb3_18 = "braid.ult"(%bb3_16, %bb3_0) : (i64, i64) -> i64
      "braid.setf"(%bb3_18) {flag = "cf"} : (i64) -> ()
      %bb3_19 = "braid.xor"(%bb3_0, %bb3_16) : (i64, i64) -> i64
      %bb3_20 = "braid.xor"(%bb3_8, %bb3_16) : (i64, i64) -> i64
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
      "braid.set"(%bb3_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb6] : () -> ()
    ^bb6:  // 0x401006
      %bb6_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb6_8 = "braid.get"() {reg = "rdi"} : () -> i64
      "braid.store"(%bb6_8, %bb6_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb9] : () -> ()
    ^bb9:  // 0x401009
      %bb9_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb9_0 = "braid.zext"(%bb9_1) {bits = 32 : i64} : (i64) -> i64
      %bb9_9 = "braid.get"() {reg = "rax"} : () -> i64
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
      "braid.set"(%bb9_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbb] : () -> ()
    ^bbb:  // 0x40100b
      %bbb_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbb_1 = "braid.load"(%bbb_0) {bytes = 8 : i64} : (i64) -> i64
      %bbb_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbb_3 = "braid.add"(%bbb_0, %bbb_2) : (i64, i64) -> i64
      "braid.set"(%bbb_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bbb_1) : (i64) -> ()
    ^bbc:  // 0x40100c
      "braid_cf.br"()[^ext401010] : () -> ()
    ^ext401010:
      "braid_cf.tail"() {target = 4198416 : i64} : () -> ()
  }) {sym_name = "py_add3", entry = 4198400 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401010
      %bb0_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb0_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb0_16 = "braid.sub"(%bb0_0, %bb0_8) : (i64, i64) -> i64
      %bb0_18 = "braid.ult"(%bb0_0, %bb0_8) : (i64, i64) -> i64
      "braid.setf"(%bb0_18) {flag = "cf"} : (i64) -> ()
      %bb0_19 = "braid.xor"(%bb0_0, %bb0_8) : (i64, i64) -> i64
      %bb0_20 = "braid.xor"(%bb0_0, %bb0_16) : (i64, i64) -> i64
      %bb0_21 = "braid.and"(%bb0_19, %bb0_20) : (i64, i64) -> i64
      %bb0_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb0_23 = "braid.and"(%bb0_21, %bb0_22) : (i64, i64) -> i64
      "braid.setf"(%bb0_23) {flag = "of"} : (i64) -> ()
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
    ^bb3:  // 0x401013
      %bb3_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb3_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb3_17 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb3_18 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb3_19 = "braid.or"(%bb3_17, %bb3_18) : (i64, i64) -> i64
      %bb3_20 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3_16 = "braid.eq"(%bb3_19, %bb3_20) : (i64, i64) -> i64
      %bb3_24 = "braid.select"(%bb3_16, %bb3_0, %bb3_8) : (i64, i64, i64) -> i64
      "braid.set"(%bb3_24) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb7] : () -> ()
    ^bb7:  // 0x401017
      %bb7_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb7_8 = "braid.get"() {reg = "rdi"} : () -> i64
      "braid.store"(%bb7_8, %bb7_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bba] : () -> ()
    ^bba:  // 0x40101a
      %bba_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bba_0 = "braid.zext"(%bba_1) {bits = 32 : i64} : (i64) -> i64
      %bba_9 = "braid.get"() {reg = "rax"} : () -> i64
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
      "braid.set"(%bba_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x40101c
      %bbc_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbc_1 = "braid.load"(%bbc_0) {bytes = 8 : i64} : (i64) -> i64
      %bbc_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbc_3 = "braid.add"(%bbc_0, %bbc_2) : (i64, i64) -> i64
      "braid.set"(%bbc_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bbc_1) : (i64) -> ()
    ^bbd:  // 0x40101d
      "braid_cf.br"()[^ext401020] : () -> ()
    ^ext401020:
      "braid_cf.tail"() {target = 4198432 : i64} : () -> ()
  }) {sym_name = "py_max_u64", entry = 4198416 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401020
      %bb0_0 = "braid.get"() {reg = "rdx"} : () -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401023
      %bb3_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb3_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb3_16 = "braid.and"(%bb3_0, %bb3_8) : (i64, i64) -> i64
      %bb3_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb3_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb3_17) {flag = "of"} : (i64) -> ()
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
      "braid_cf.br"()[^bb6] : () -> ()
    ^bb6:  // 0x401026
      %bb6_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid_cf.cond_br"(%bb6_0)[^bb25, ^bb8] : (i64) -> ()
    ^bb8:  // 0x401028
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401030
      %bb10_0 = "braid.get"() {reg = "rcx"} : () -> i64
      "braid.set"(%bb10_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb13] : () -> ()
    ^bb13:  // 0x401033
      %bb13_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb13_0 = "braid.zext"(%bb13_1) {bits = 32 : i64} : (i64) -> i64
      %bb13_9 = "braid.get"() {reg = "rdx"} : () -> i64
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
      "braid.set"(%bb13_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^ext401035] : () -> ()
    ^bb18:  // 0x401038
      %bb18_0 = "braid.get"() {reg = "rcx"} : () -> i64
      "braid.set"(%bb18_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1b] : () -> ()
    ^bb1b:  // 0x40103b
      %bb1b_0 = "braid.get"() {reg = "rdx"} : () -> i64
      "braid.set"(%bb1b_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb1e] : () -> ()
    ^bb1e:  // 0x40103e
      %bb1e_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb1e_8 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb1e_16 = "braid.and"(%bb1e_0, %bb1e_8) : (i64, i64) -> i64
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
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb25:  // 0x401045
      %bb25_0 = "braid.get"() {reg = "rax"} : () -> i64
      "braid.set"(%bb25_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x401048
      %bb28_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb28_8 = "braid.get"() {reg = "rdi"} : () -> i64
      "braid.store"(%bb28_8, %bb28_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb2b] : () -> ()
    ^bb2b:  // 0x40104b
      %bb2b_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb2b_0 = "braid.zext"(%bb2b_1) {bits = 32 : i64} : (i64) -> i64
      %bb2b_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb2b_8 = "braid.zext"(%bb2b_9) {bits = 32 : i64} : (i64) -> i64
      %bb2b_16 = "braid.xor"(%bb2b_0, %bb2b_8) : (i64, i64) -> i64
      %bb2b_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb2b_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb2b_17) {flag = "of"} : (i64) -> ()
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
      %bb2b_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb2b_40 = "braid.and"(%bb2b_16, %bb2b_39) : (i64, i64) -> i64
      "braid.setf"(%bb2b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb2b_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb2d] : () -> ()
    ^bb2d:  // 0x40104d
      %bb2d_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb2d_1 = "braid.load"(%bb2d_0) {bytes = 8 : i64} : (i64) -> i64
      %bb2d_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb2d_3 = "braid.add"(%bb2d_0, %bb2d_2) : (i64, i64) -> i64
      "braid.set"(%bb2d_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb2d_1) : (i64) -> ()
    ^ext401035:
      "braid_cf.tail"() {target = 4198453 : i64} : () -> ()
  }) {sym_name = "py_gcd", entry = 4198432 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
