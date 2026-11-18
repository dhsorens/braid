"braid.module"() ({
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb0_3 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb0_4 = "braid.mul"(%bb0_2, %bb0_3) : (i64, i64) -> i64
      %bb0_5 = "braid.add"(%bb0_1, %bb0_4) : (i64, i64) -> i64
      %bb0_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_0 = "braid.add"(%bb0_5, %bb0_6) : (i64, i64) -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x401004
      %bb4_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb4_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb4_16 = "braid.add"(%bb4_0, %bb4_8) : (i64, i64) -> i64
      %bb4_18 = "braid.ult"(%bb4_16, %bb4_0) : (i64, i64) -> i64
      "braid.setf"(%bb4_18) {flag = "cf"} : (i64) -> ()
      %bb4_19 = "braid.xor"(%bb4_0, %bb4_16) : (i64, i64) -> i64
      %bb4_20 = "braid.xor"(%bb4_8, %bb4_16) : (i64, i64) -> i64
      %bb4_21 = "braid.and"(%bb4_19, %bb4_20) : (i64, i64) -> i64
      %bb4_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb4_23 = "braid.and"(%bb4_21, %bb4_22) : (i64, i64) -> i64
      "braid.setf"(%bb4_23) {flag = "of"} : (i64) -> ()
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
      %bb4_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb4_40 = "braid.and"(%bb4_16, %bb4_39) : (i64, i64) -> i64
      "braid.setf"(%bb4_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb4_16) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb7] : () -> ()
    ^bb7:  // 0x401007
      %bb7_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb7_1 = "braid.load"(%bb7_0) {bytes = 8 : i64} : (i64) -> i64
      %bb7_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb7_3 = "braid.add"(%bb7_0, %bb7_2) : (i64, i64) -> i64
      "braid.set"(%bb7_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb7_1) : (i64) -> ()
  }) {sym_name = "swift_add3", entry = 4198400 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401020
      %bb0_0 = "braid.get"() {reg = "rdi"} : () -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401023
      %bb3_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb3_8 = "braid.get"() {reg = "rsi"} : () -> i64
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
      "braid.br"()[^bb6] : () -> ()
    ^bb6:  // 0x401026
      %bb6_0 = "braid.getf"() {flag = "zf"} : () -> i64
      "braid.cond_br"(%bb6_0)[^bb23, ^bb8] : (i64) -> ()
    ^bb8:  // 0x401028
      %bb8_0 = "braid.get"() {reg = "rsi"} : () -> i64
      "braid.set"(%bb8_0) {reg = "rdx"} : (i64) -> ()
      "braid.br"()[^bbb] : () -> ()
    ^bbb:  // 0x40102b
      "braid.br"()[^bb10] : () -> ()
    ^bb10:  // 0x401030
      %bb10_0 = "braid.get"() {reg = "rdx"} : () -> i64
      "braid.set"(%bb10_0) {reg = "rcx"} : (i64) -> ()
      "braid.br"()[^bb13] : () -> ()
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
      "braid.br"()[^ext401035] : () -> ()
    ^bb18:  // 0x401038
      %bb18_0 = "braid.get"() {reg = "rcx"} : () -> i64
      "braid.set"(%bb18_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb1b] : () -> ()
    ^bb1b:  // 0x40103b
      %bb1b_0 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb1b_8 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb1b_16 = "braid.and"(%bb1b_0, %bb1b_8) : (i64, i64) -> i64
      %bb1b_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1b_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1b_17) {flag = "of"} : (i64) -> ()
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
      "braid.br"()[^bb1e] : () -> ()
    ^bb1e:  // 0x40103e
      %bb1e_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb1e_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e_0 = "braid.eq"(%bb1e_1, %bb1e_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb1e_0)[^bb10, ^bb20] : (i64) -> ()
    ^bb20:  // 0x401040
      %bb20_0 = "braid.get"() {reg = "rcx"} : () -> i64
      "braid.set"(%bb20_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb23] : () -> ()
    ^bb23:  // 0x401043
      %bb23_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb23_1 = "braid.load"(%bb23_0) {bytes = 8 : i64} : (i64) -> i64
      %bb23_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb23_3 = "braid.add"(%bb23_0, %bb23_2) : (i64, i64) -> i64
      "braid.set"(%bb23_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb23_1) : (i64) -> ()
    ^ext401035:
      "braid.tail"() {target = 4198453 : i64} : () -> ()
  }) {sym_name = "swift_gcd", entry = 4198432 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401080
      %bb0_0 = "braid.get"() {reg = "rsi"} : () -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401083
      %bb3_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb3_8 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb3_16 = "braid.sub"(%bb3_0, %bb3_8) : (i64, i64) -> i64
      %bb3_18 = "braid.ult"(%bb3_0, %bb3_8) : (i64, i64) -> i64
      "braid.setf"(%bb3_18) {flag = "cf"} : (i64) -> ()
      %bb3_19 = "braid.xor"(%bb3_0, %bb3_8) : (i64, i64) -> i64
      %bb3_20 = "braid.xor"(%bb3_0, %bb3_16) : (i64, i64) -> i64
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
      "braid.br"()[^bb6] : () -> ()
    ^bb6:  // 0x401086
      %bb6_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb6_8 = "braid.get"() {reg = "rax"} : () -> i64
      %bb6_16 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb6_24 = "braid.select"(%bb6_16, %bb6_0, %bb6_8) : (i64, i64, i64) -> i64
      "braid.set"(%bb6_24) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bba] : () -> ()
    ^bba:  // 0x40108a
      %bba_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba_1 = "braid.load"(%bba_0) {bytes = 8 : i64} : (i64) -> i64
      %bba_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bba_3 = "braid.add"(%bba_0, %bba_2) : (i64, i64) -> i64
      "braid.set"(%bba_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bba_1) : (i64) -> ()
  }) {sym_name = "swift_min", entry = 4198528 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
