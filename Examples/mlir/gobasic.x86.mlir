"braid.module"() ({
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x47a600
      %bb0_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb0_2 = "braid.get"() {reg = "rax"} : () -> i64
      %bb0_3 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb0_4 = "braid.mul"(%bb0_2, %bb0_3) : (i64, i64) -> i64
      %bb0_5 = "braid.add"(%bb0_1, %bb0_4) : (i64, i64) -> i64
      %bb0_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_0 = "braid.add"(%bb0_5, %bb0_6) : (i64, i64) -> i64
      "braid.set"(%bb0_0) {reg = "rdx"} : (i64) -> ()
      "braid.br"()[^bb4] : () -> ()
    ^bb4:  // 0x47a604
      %bb4_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb4_2 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb4_3 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb4_4 = "braid.mul"(%bb4_2, %bb4_3) : (i64, i64) -> i64
      %bb4_5 = "braid.add"(%bb4_1, %bb4_4) : (i64, i64) -> i64
      %bb4_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_0 = "braid.add"(%bb4_5, %bb4_6) : (i64, i64) -> i64
      "braid.set"(%bb4_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb8] : () -> ()
    ^bb8:  // 0x47a608
      %bb8_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb8_1 = "braid.load"(%bb8_0) {bytes = 8 : i64} : (i64) -> i64
      %bb8_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8_3 = "braid.add"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb8_1) : (i64) -> ()
  }) {sym_name = "main.Add3", entry = 4695552 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x47a620
      %bb0_0 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb0_8 = "braid.get"() {reg = "rax"} : () -> i64
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
      "braid.br"()[^bb3] : () -> ()
    ^bb3:  // 0x47a623
      %bb3_1 = "braid.getf"() {flag = "cf"} : () -> i64
      %bb3_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3_0 = "braid.eq"(%bb3_1, %bb3_2) : (i64, i64) -> i64
      "braid.cond_br"(%bb3_0)[^bb6, ^bb5] : (i64) -> ()
    ^bb5:  // 0x47a625
      %bb5_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb5_1 = "braid.load"(%bb5_0) {bytes = 8 : i64} : (i64) -> i64
      %bb5_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb5_3 = "braid.add"(%bb5_0, %bb5_2) : (i64, i64) -> i64
      "braid.set"(%bb5_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb5_1) : (i64) -> ()
    ^bb6:  // 0x47a626
      %bb6_0 = "braid.get"() {reg = "rbx"} : () -> i64
      "braid.set"(%bb6_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb9] : () -> ()
    ^bb9:  // 0x47a629
      %bb9_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb9_1 = "braid.load"(%bb9_0) {bytes = 8 : i64} : (i64) -> i64
      %bb9_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb9_3 = "braid.add"(%bb9_0, %bb9_2) : (i64, i64) -> i64
      "braid.set"(%bb9_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb9_1) : (i64) -> ()
  }) {sym_name = "main.MaxU64", entry = 4695584 : i64} : () -> ()
  "braid.func"() ({
      "braid.br"()[^bb0] : () -> ()
    ^bb0:  // 0x47a640
      %bb0_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb0_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb0_10 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_8 = "braid.add"(%bb0_9, %bb0_10) : (i64, i64) -> i64
      "braid.store"(%bb0_8, %bb0_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.br"()[^bb5] : () -> ()
    ^bb5:  // 0x47a645
      %bb5_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb5_0 = "braid.zext"(%bb5_1) {bits = 32 : i64} : (i64) -> i64
      %bb5_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb5_8 = "braid.zext"(%bb5_9) {bits = 32 : i64} : (i64) -> i64
      %bb5_16 = "braid.xor"(%bb5_0, %bb5_8) : (i64, i64) -> i64
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
      %bb5_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb5_40 = "braid.and"(%bb5_16, %bb5_39) : (i64, i64) -> i64
      "braid.setf"(%bb5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb5_16) {reg = "rcx"} : (i64) -> ()
      "braid.br"()[^bb7] : () -> ()
    ^bb7:  // 0x47a647
      %bb7_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb7_0 = "braid.zext"(%bb7_1) {bits = 32 : i64} : (i64) -> i64
      %bb7_9 = "braid.get"() {reg = "rdx"} : () -> i64
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
      "braid.set"(%bb7_16) {reg = "rdx"} : (i64) -> ()
      "braid.br"()[^bb9] : () -> ()
    ^bb9:  // 0x47a649
      "braid.br"()[^bb12] : () -> ()
    ^bbb:  // 0x47a64b
      %bbb_2 = "braid.get"() {reg = "rax"} : () -> i64
      %bbb_3 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbb_4 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbb_5 = "braid.mul"(%bbb_3, %bbb_4) : (i64, i64) -> i64
      %bbb_6 = "braid.add"(%bbb_2, %bbb_5) : (i64, i64) -> i64
      %bbb_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb_1 = "braid.add"(%bbb_6, %bbb_7) : (i64, i64) -> i64
      %bbb_0 = "braid.load"(%bbb_1) {bytes = 8 : i64} : (i64) -> i64
      %bbb_8 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbb_16 = "braid.add"(%bbb_0, %bbb_8) : (i64, i64) -> i64
      %bbb_18 = "braid.ult"(%bbb_16, %bbb_0) : (i64, i64) -> i64
      "braid.setf"(%bbb_18) {flag = "cf"} : (i64) -> ()
      %bbb_19 = "braid.xor"(%bbb_0, %bbb_16) : (i64, i64) -> i64
      %bbb_20 = "braid.xor"(%bbb_8, %bbb_16) : (i64, i64) -> i64
      %bbb_21 = "braid.and"(%bbb_19, %bbb_20) : (i64, i64) -> i64
      %bbb_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbb_23 = "braid.and"(%bbb_21, %bbb_22) : (i64, i64) -> i64
      "braid.setf"(%bbb_23) {flag = "of"} : (i64) -> ()
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
      %bbb_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbb_40 = "braid.and"(%bbb_16, %bbb_39) : (i64, i64) -> i64
      "braid.setf"(%bbb_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbb_16) {reg = "rdx"} : (i64) -> ()
      "braid.br"()[^bbf] : () -> ()
    ^bbf:  // 0x47a64f
      %bbf_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbf_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf_16 = "braid.add"(%bbf_0, %bbf_8) : (i64, i64) -> i64
      %bbf_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbf_20 = "braid.eq"(%bbf_16, %bbf_19) : (i64, i64) -> i64
      "braid.setf"(%bbf_20) {flag = "of"} : (i64) -> ()
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
      %bbf_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbf_40 = "braid.and"(%bbf_16, %bbf_39) : (i64, i64) -> i64
      "braid.setf"(%bbf_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbf_16) {reg = "rcx"} : (i64) -> ()
      "braid.br"()[^bb12] : () -> ()
    ^bb12:  // 0x47a652
      %bb12_0 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb12_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb12_16 = "braid.sub"(%bb12_0, %bb12_8) : (i64, i64) -> i64
      %bb12_18 = "braid.ult"(%bb12_0, %bb12_8) : (i64, i64) -> i64
      "braid.setf"(%bb12_18) {flag = "cf"} : (i64) -> ()
      %bb12_19 = "braid.xor"(%bb12_0, %bb12_8) : (i64, i64) -> i64
      %bb12_20 = "braid.xor"(%bb12_0, %bb12_16) : (i64, i64) -> i64
      %bb12_21 = "braid.and"(%bb12_19, %bb12_20) : (i64, i64) -> i64
      %bb12_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb12_23 = "braid.and"(%bb12_21, %bb12_22) : (i64, i64) -> i64
      "braid.setf"(%bb12_23) {flag = "of"} : (i64) -> ()
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
      %bb12_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb12_40 = "braid.and"(%bb12_16, %bb12_39) : (i64, i64) -> i64
      "braid.setf"(%bb12_40) {flag = "sf"} : (i64) -> ()
      "braid.br"()[^bb15] : () -> ()
    ^bb15:  // 0x47a655
      %bb15_1 = "braid.getf"() {flag = "sf"} : () -> i64
      %bb15_2 = "braid.getf"() {flag = "of"} : () -> i64
      %bb15_3 = "braid.xor"(%bb15_1, %bb15_2) : (i64, i64) -> i64
      %bb15_4 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb15_5 = "braid.or"(%bb15_3, %bb15_4) : (i64, i64) -> i64
      %bb15_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15_0 = "braid.eq"(%bb15_5, %bb15_6) : (i64, i64) -> i64
      "braid.cond_br"(%bb15_0)[^bbb, ^bb17] : (i64) -> ()
    ^bb17:  // 0x47a657
      %bb17_0 = "braid.get"() {reg = "rdx"} : () -> i64
      "braid.set"(%bb17_0) {reg = "rax"} : (i64) -> ()
      "braid.br"()[^bb1a] : () -> ()
    ^bb1a:  // 0x47a65a
      %bb1a_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1a_1 = "braid.load"(%bb1a_0) {bytes = 8 : i64} : (i64) -> i64
      %bb1a_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1a_3 = "braid.add"(%bb1a_0, %bb1a_2) : (i64, i64) -> i64
      "braid.set"(%bb1a_3) {reg = "rsp"} : (i64) -> ()
      "braid.br_ind"(%bb1a_1) : (i64) -> ()
  }) {sym_name = "main.SumSlice", entry = 4695616 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
