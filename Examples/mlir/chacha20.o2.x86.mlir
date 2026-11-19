"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb0_3 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb0_1 = "braid.add"(%bb0_2, %bb0_3) : (i64, i64) -> i64
      %bb0_0 = "braid.load"(%bb0_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb0_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401003
      %bb3_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb3_0 = "braid.load"(%bb3_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb3_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb5] : () -> ()
    ^bb5:  // 0x401005
      %bb5_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb5_0 = "braid.zext"(%bb5_1) {bits = 32 : i64} : (i64) -> i64
      %bb5_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb5_8 = "braid.zext"(%bb5_9) {bits = 32 : i64} : (i64) -> i64
      %bb5_16 = "braid.add"(%bb5_0, %bb5_8) : (i64, i64) -> i64
      %bb5_17 = "braid.zext"(%bb5_16) {bits = 32 : i64} : (i64) -> i64
      %bb5_18 = "braid.ult"(%bb5_17, %bb5_0) : (i64, i64) -> i64
      "braid.setf"(%bb5_18) {flag = "cf"} : (i64) -> ()
      %bb5_19 = "braid.xor"(%bb5_0, %bb5_17) : (i64, i64) -> i64
      %bb5_20 = "braid.xor"(%bb5_8, %bb5_17) : (i64, i64) -> i64
      %bb5_21 = "braid.and"(%bb5_19, %bb5_20) : (i64, i64) -> i64
      %bb5_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb5_23 = "braid.and"(%bb5_21, %bb5_22) : (i64, i64) -> i64
      "braid.setf"(%bb5_23) {flag = "of"} : (i64) -> ()
      %bb5_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb5_24) {flag = "af"} : (i64) -> ()
      %bb5_32 = "braid.zext"(%bb5_17) {bits = 8 : i64} : (i64) -> i64
      %bb5_33 = "braid.popcnt"(%bb5_32) : (i64) -> i64
      %bb5_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb5_35 = "braid.and"(%bb5_33, %bb5_34) : (i64, i64) -> i64
      %bb5_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb5_37 = "braid.eq"(%bb5_35, %bb5_36) : (i64, i64) -> i64
      "braid.setf"(%bb5_37) {flag = "pf"} : (i64) -> ()
      %bb5_38 = "braid.eq"(%bb5_17, %bb5_36) : (i64, i64) -> i64
      "braid.setf"(%bb5_38) {flag = "zf"} : (i64) -> ()
      %bb5_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb5_40 = "braid.and"(%bb5_17, %bb5_39) : (i64, i64) -> i64
      "braid.setf"(%bb5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb5_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb7] : () -> ()
    ^bb7:  // 0x401007
      %bb7_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb7_3 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb7_1 = "braid.add"(%bb7_2, %bb7_3) : (i64, i64) -> i64
      %bb7_0 = "braid.load"(%bb7_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb7_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bba] : () -> ()
    ^bba:  // 0x40100a
      %bba_1 = "braid.get"() {reg = "rdx"} : () -> i64
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
      "braid.set"(%bba_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x40100c
      %bbc_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbc_0 = "braid.zext"(%bbc_1) {bits = 32 : i64} : (i64) -> i64
      %bbc_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbc_13 = "braid.shl"(%bbc_0, %bbc_12) : (i64, i64) -> i64
      %bbc_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbc_15 = "braid.lshr"(%bbc_0, %bbc_14) : (i64, i64) -> i64
      %bbc_16 = "braid.or"(%bbc_13, %bbc_15) : (i64, i64) -> i64
      %bbc_17 = "braid.zext"(%bbc_16) {bits = 32 : i64} : (i64) -> i64
      %bbc_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc_19 = "braid.and"(%bbc_17, %bbc_18) : (i64, i64) -> i64
      "braid.setf"(%bbc_19) {flag = "cf"} : (i64) -> ()
      %bbc_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbc_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bbf] : () -> ()
    ^bbf:  // 0x40100f
      %bbf_2 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbf_3 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbf_1 = "braid.add"(%bbf_2, %bbf_3) : (i64, i64) -> i64
      %bbf_0 = "braid.load"(%bbf_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbf_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb12] : () -> ()
    ^bb12:  // 0x401012
      %bb12_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb12_0 = "braid.zext"(%bb12_1) {bits = 32 : i64} : (i64) -> i64
      %bb12_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb12_8 = "braid.zext"(%bb12_9) {bits = 32 : i64} : (i64) -> i64
      %bb12_16 = "braid.add"(%bb12_0, %bb12_8) : (i64, i64) -> i64
      %bb12_17 = "braid.zext"(%bb12_16) {bits = 32 : i64} : (i64) -> i64
      %bb12_18 = "braid.ult"(%bb12_17, %bb12_0) : (i64, i64) -> i64
      "braid.setf"(%bb12_18) {flag = "cf"} : (i64) -> ()
      %bb12_19 = "braid.xor"(%bb12_0, %bb12_17) : (i64, i64) -> i64
      %bb12_20 = "braid.xor"(%bb12_8, %bb12_17) : (i64, i64) -> i64
      %bb12_21 = "braid.and"(%bb12_19, %bb12_20) : (i64, i64) -> i64
      %bb12_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb12_23 = "braid.and"(%bb12_21, %bb12_22) : (i64, i64) -> i64
      "braid.setf"(%bb12_23) {flag = "of"} : (i64) -> ()
      %bb12_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb12_24) {flag = "af"} : (i64) -> ()
      %bb12_32 = "braid.zext"(%bb12_17) {bits = 8 : i64} : (i64) -> i64
      %bb12_33 = "braid.popcnt"(%bb12_32) : (i64) -> i64
      %bb12_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb12_35 = "braid.and"(%bb12_33, %bb12_34) : (i64, i64) -> i64
      %bb12_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12_37 = "braid.eq"(%bb12_35, %bb12_36) : (i64, i64) -> i64
      "braid.setf"(%bb12_37) {flag = "pf"} : (i64) -> ()
      %bb12_38 = "braid.eq"(%bb12_17, %bb12_36) : (i64, i64) -> i64
      "braid.setf"(%bb12_38) {flag = "zf"} : (i64) -> ()
      %bb12_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb12_40 = "braid.and"(%bb12_17, %bb12_39) : (i64, i64) -> i64
      "braid.setf"(%bb12_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb12_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x401014
      %bb14_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb14_0 = "braid.zext"(%bb14_1) {bits = 32 : i64} : (i64) -> i64
      %bb14_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb14_8 = "braid.zext"(%bb14_9) {bits = 32 : i64} : (i64) -> i64
      %bb14_16 = "braid.xor"(%bb14_0, %bb14_8) : (i64, i64) -> i64
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
      %bb14_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb14_40 = "braid.and"(%bb14_16, %bb14_39) : (i64, i64) -> i64
      "braid.setf"(%bb14_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb14_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb16] : () -> ()
    ^bb16:  // 0x401016
      %bb16_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb16_0 = "braid.zext"(%bb16_1) {bits = 32 : i64} : (i64) -> i64
      %bb16_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb16_13 = "braid.shl"(%bb16_0, %bb16_12) : (i64, i64) -> i64
      %bb16_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb16_15 = "braid.lshr"(%bb16_0, %bb16_14) : (i64, i64) -> i64
      %bb16_16 = "braid.or"(%bb16_13, %bb16_15) : (i64, i64) -> i64
      %bb16_17 = "braid.zext"(%bb16_16) {bits = 32 : i64} : (i64) -> i64
      %bb16_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb16_19 = "braid.and"(%bb16_17, %bb16_18) : (i64, i64) -> i64
      "braid.setf"(%bb16_19) {flag = "cf"} : (i64) -> ()
      %bb16_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb16_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb16_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb19] : () -> ()
    ^bb19:  // 0x401019
      %bb19_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb19_0 = "braid.zext"(%bb19_1) {bits = 32 : i64} : (i64) -> i64
      %bb19_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb19_8 = "braid.zext"(%bb19_9) {bits = 32 : i64} : (i64) -> i64
      %bb19_16 = "braid.add"(%bb19_0, %bb19_8) : (i64, i64) -> i64
      %bb19_17 = "braid.zext"(%bb19_16) {bits = 32 : i64} : (i64) -> i64
      %bb19_18 = "braid.ult"(%bb19_17, %bb19_0) : (i64, i64) -> i64
      "braid.setf"(%bb19_18) {flag = "cf"} : (i64) -> ()
      %bb19_19 = "braid.xor"(%bb19_0, %bb19_17) : (i64, i64) -> i64
      %bb19_20 = "braid.xor"(%bb19_8, %bb19_17) : (i64, i64) -> i64
      %bb19_21 = "braid.and"(%bb19_19, %bb19_20) : (i64, i64) -> i64
      %bb19_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb19_23 = "braid.and"(%bb19_21, %bb19_22) : (i64, i64) -> i64
      "braid.setf"(%bb19_23) {flag = "of"} : (i64) -> ()
      %bb19_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb19_24) {flag = "af"} : (i64) -> ()
      %bb19_32 = "braid.zext"(%bb19_17) {bits = 8 : i64} : (i64) -> i64
      %bb19_33 = "braid.popcnt"(%bb19_32) : (i64) -> i64
      %bb19_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb19_35 = "braid.and"(%bb19_33, %bb19_34) : (i64, i64) -> i64
      %bb19_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb19_37 = "braid.eq"(%bb19_35, %bb19_36) : (i64, i64) -> i64
      "braid.setf"(%bb19_37) {flag = "pf"} : (i64) -> ()
      %bb19_38 = "braid.eq"(%bb19_17, %bb19_36) : (i64, i64) -> i64
      "braid.setf"(%bb19_38) {flag = "zf"} : (i64) -> ()
      %bb19_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb19_40 = "braid.and"(%bb19_17, %bb19_39) : (i64, i64) -> i64
      "braid.setf"(%bb19_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb19_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb1b] : () -> ()
    ^bb1b:  // 0x40101b
      %bb1b_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb1b_0 = "braid.zext"(%bb1b_1) {bits = 32 : i64} : (i64) -> i64
      %bb1b_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1b_8 = "braid.zext"(%bb1b_9) {bits = 32 : i64} : (i64) -> i64
      %bb1b_16 = "braid.xor"(%bb1b_0, %bb1b_8) : (i64, i64) -> i64
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
      %bb1b_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1b_40 = "braid.and"(%bb1b_16, %bb1b_39) : (i64, i64) -> i64
      "braid.setf"(%bb1b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1b_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb1d] : () -> ()
    ^bb1d:  // 0x40101d
      %bb1d_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb1d_0 = "braid.zext"(%bb1d_1) {bits = 32 : i64} : (i64) -> i64
      %bb1d_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1d_13 = "braid.shl"(%bb1d_0, %bb1d_12) : (i64, i64) -> i64
      %bb1d_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb1d_15 = "braid.lshr"(%bb1d_0, %bb1d_14) : (i64, i64) -> i64
      %bb1d_16 = "braid.or"(%bb1d_13, %bb1d_15) : (i64, i64) -> i64
      %bb1d_17 = "braid.zext"(%bb1d_16) {bits = 32 : i64} : (i64) -> i64
      %bb1d_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1d_19 = "braid.and"(%bb1d_17, %bb1d_18) : (i64, i64) -> i64
      "braid.setf"(%bb1d_19) {flag = "cf"} : (i64) -> ()
      %bb1d_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1d_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb1d_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x401020
      %bb20_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb20_0 = "braid.zext"(%bb20_1) {bits = 32 : i64} : (i64) -> i64
      %bb20_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb20_8 = "braid.zext"(%bb20_9) {bits = 32 : i64} : (i64) -> i64
      %bb20_16 = "braid.add"(%bb20_0, %bb20_8) : (i64, i64) -> i64
      %bb20_17 = "braid.zext"(%bb20_16) {bits = 32 : i64} : (i64) -> i64
      %bb20_18 = "braid.ult"(%bb20_17, %bb20_0) : (i64, i64) -> i64
      "braid.setf"(%bb20_18) {flag = "cf"} : (i64) -> ()
      %bb20_19 = "braid.xor"(%bb20_0, %bb20_17) : (i64, i64) -> i64
      %bb20_20 = "braid.xor"(%bb20_8, %bb20_17) : (i64, i64) -> i64
      %bb20_21 = "braid.and"(%bb20_19, %bb20_20) : (i64, i64) -> i64
      %bb20_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb20_23 = "braid.and"(%bb20_21, %bb20_22) : (i64, i64) -> i64
      "braid.setf"(%bb20_23) {flag = "of"} : (i64) -> ()
      %bb20_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb20_24) {flag = "af"} : (i64) -> ()
      %bb20_32 = "braid.zext"(%bb20_17) {bits = 8 : i64} : (i64) -> i64
      %bb20_33 = "braid.popcnt"(%bb20_32) : (i64) -> i64
      %bb20_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb20_35 = "braid.and"(%bb20_33, %bb20_34) : (i64, i64) -> i64
      %bb20_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20_37 = "braid.eq"(%bb20_35, %bb20_36) : (i64, i64) -> i64
      "braid.setf"(%bb20_37) {flag = "pf"} : (i64) -> ()
      %bb20_38 = "braid.eq"(%bb20_17, %bb20_36) : (i64, i64) -> i64
      "braid.setf"(%bb20_38) {flag = "zf"} : (i64) -> ()
      %bb20_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb20_40 = "braid.and"(%bb20_17, %bb20_39) : (i64, i64) -> i64
      "braid.setf"(%bb20_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb20_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb22] : () -> ()
    ^bb22:  // 0x401022
      %bb22_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb22_0 = "braid.zext"(%bb22_1) {bits = 32 : i64} : (i64) -> i64
      %bb22_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb22_8 = "braid.zext"(%bb22_9) {bits = 32 : i64} : (i64) -> i64
      %bb22_16 = "braid.xor"(%bb22_0, %bb22_8) : (i64, i64) -> i64
      %bb22_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb22_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb22_17) {flag = "of"} : (i64) -> ()
      %bb22_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb22_24) {flag = "af"} : (i64) -> ()
      %bb22_32 = "braid.zext"(%bb22_16) {bits = 8 : i64} : (i64) -> i64
      %bb22_33 = "braid.popcnt"(%bb22_32) : (i64) -> i64
      %bb22_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb22_35 = "braid.and"(%bb22_33, %bb22_34) : (i64, i64) -> i64
      %bb22_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb22_37 = "braid.eq"(%bb22_35, %bb22_36) : (i64, i64) -> i64
      "braid.setf"(%bb22_37) {flag = "pf"} : (i64) -> ()
      %bb22_38 = "braid.eq"(%bb22_16, %bb22_36) : (i64, i64) -> i64
      "braid.setf"(%bb22_38) {flag = "zf"} : (i64) -> ()
      %bb22_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb22_40 = "braid.and"(%bb22_16, %bb22_39) : (i64, i64) -> i64
      "braid.setf"(%bb22_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb22_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x401024
      %bb24_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb24_0 = "braid.zext"(%bb24_1) {bits = 32 : i64} : (i64) -> i64
      %bb24_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb24_13 = "braid.shl"(%bb24_0, %bb24_12) : (i64, i64) -> i64
      %bb24_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb24_15 = "braid.lshr"(%bb24_0, %bb24_14) : (i64, i64) -> i64
      %bb24_16 = "braid.or"(%bb24_13, %bb24_15) : (i64, i64) -> i64
      %bb24_17 = "braid.zext"(%bb24_16) {bits = 32 : i64} : (i64) -> i64
      %bb24_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb24_19 = "braid.and"(%bb24_17, %bb24_18) : (i64, i64) -> i64
      "braid.setf"(%bb24_19) {flag = "cf"} : (i64) -> ()
      %bb24_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb24_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb24_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb27] : () -> ()
    ^bb27:  // 0x401027
      %bb27_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb27_0 = "braid.zext"(%bb27_1) {bits = 32 : i64} : (i64) -> i64
      %bb27_8 = "braid.get"() {reg = "rdi"} : () -> i64
      "braid.store"(%bb27_8, %bb27_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb29] : () -> ()
    ^bb29:  // 0x401029
      %bb29_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb29_0 = "braid.zext"(%bb29_1) {bits = 32 : i64} : (i64) -> i64
      %bb29_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb29_10 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb29_8 = "braid.add"(%bb29_9, %bb29_10) : (i64, i64) -> i64
      "braid.store"(%bb29_8, %bb29_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x40102c
      %bb2c_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb2c_0 = "braid.zext"(%bb2c_1) {bits = 32 : i64} : (i64) -> i64
      %bb2c_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb2c_10 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb2c_8 = "braid.add"(%bb2c_9, %bb2c_10) : (i64, i64) -> i64
      "braid.store"(%bb2c_8, %bb2c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb2f] : () -> ()
    ^bb2f:  // 0x40102f
      %bb2f_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb2f_0 = "braid.zext"(%bb2f_1) {bits = 32 : i64} : (i64) -> i64
      %bb2f_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb2f_10 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb2f_8 = "braid.add"(%bb2f_9, %bb2f_10) : (i64, i64) -> i64
      "braid.store"(%bb2f_8, %bb2f_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb32] : () -> ()
    ^bb32:  // 0x401032
      %bb32_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb32_1 = "braid.load"(%bb32_0) {bytes = 8 : i64} : (i64) -> i64
      %bb32_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb32_3 = "braid.add"(%bb32_0, %bb32_2) : (i64, i64) -> i64
      "braid.set"(%bb32_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb32_1) : (i64) -> ()
    ^bb33:  // 0x401033
      "braid_cf.br"()[^ext401040] : () -> ()
    ^ext401040:
      "braid_cf.tail"() {target = 4198464 : i64} : () -> ()
  }) {sym_name = "quarter_round", entry = 4198400 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401040
      %bb0_0 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb0_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb0_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_10 = "braid.sub"(%bb0_8, %bb0_9) : (i64, i64) -> i64
      "braid.set"(%bb0_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb0_10, %bb0_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1] : () -> ()
    ^bb1:  // 0x401041
      %bb1_0 = "braid.get"() {reg = "r15"} : () -> i64
      %bb1_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1_10 = "braid.sub"(%bb1_8, %bb1_9) : (i64, i64) -> i64
      "braid.set"(%bb1_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb1_10, %bb1_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb3] : () -> ()
    ^bb3:  // 0x401043
      %bb3_0 = "braid.get"() {reg = "r14"} : () -> i64
      %bb3_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb3_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb3_10 = "braid.sub"(%bb3_8, %bb3_9) : (i64, i64) -> i64
      "braid.set"(%bb3_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb3_10, %bb3_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb5] : () -> ()
    ^bb5:  // 0x401045
      %bb5_0 = "braid.get"() {reg = "r13"} : () -> i64
      %bb5_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb5_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb5_10 = "braid.sub"(%bb5_8, %bb5_9) : (i64, i64) -> i64
      "braid.set"(%bb5_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb5_10, %bb5_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb7] : () -> ()
    ^bb7:  // 0x401047
      %bb7_0 = "braid.get"() {reg = "r12"} : () -> i64
      %bb7_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb7_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb7_10 = "braid.sub"(%bb7_8, %bb7_9) : (i64, i64) -> i64
      "braid.set"(%bb7_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb7_10, %bb7_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb9] : () -> ()
    ^bb9:  // 0x401049
      %bb9_0 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb9_8 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb9_9 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb9_10 = "braid.sub"(%bb9_8, %bb9_9) : (i64, i64) -> i64
      "braid.set"(%bb9_10) {reg = "rsp"} : (i64) -> ()
      "braid.store"(%bb9_10, %bb9_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bba] : () -> ()
    ^bba:  // 0x40104a
      %bba_0 = "braid.get"() {reg = "rdi"} : () -> i64
      %bba_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba_10 = "braid.const"() {value = -8 : i64} : () -> i64
      %bba_8 = "braid.add"(%bba_9, %bba_10) : (i64, i64) -> i64
      "braid.store"(%bba_8, %bba_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbf] : () -> ()
    ^bbf:  // 0x40104f
      %bbf_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbf_0 = "braid.load"(%bbf_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbf_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb12] : () -> ()
    ^bb12:  // 0x401052
      %bb12_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb12_3 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb12_1 = "braid.add"(%bb12_2, %bb12_3) : (i64, i64) -> i64
      %bb12_0 = "braid.load"(%bb12_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb12_0) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb15] : () -> ()
    ^bb15:  // 0x401055
      %bb15_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb15_3 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb15_1 = "braid.add"(%bb15_2, %bb15_3) : (i64, i64) -> i64
      %bb15_0 = "braid.load"(%bb15_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb15_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb19] : () -> ()
    ^bb19:  // 0x401059
      %bb19_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb19_3 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb19_1 = "braid.add"(%bb19_2, %bb19_3) : (i64, i64) -> i64
      %bb19_0 = "braid.load"(%bb19_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb19_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb1d] : () -> ()
    ^bb1d:  // 0x40105d
      %bb1d_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1d_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1d_1 = "braid.add"(%bb1d_2, %bb1d_3) : (i64, i64) -> i64
      %bb1d_0 = "braid.load"(%bb1d_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1d_0) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb21] : () -> ()
    ^bb21:  // 0x401061
      %bb21_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb21_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb21_1 = "braid.add"(%bb21_2, %bb21_3) : (i64, i64) -> i64
      %bb21_0 = "braid.load"(%bb21_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb21_0) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb25] : () -> ()
    ^bb25:  // 0x401065
      %bb25_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb25_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb25_1 = "braid.add"(%bb25_2, %bb25_3) : (i64, i64) -> i64
      %bb25_0 = "braid.load"(%bb25_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb25_0) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb29] : () -> ()
    ^bb29:  // 0x401069
      %bb29_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb29_3 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb29_1 = "braid.add"(%bb29_2, %bb29_3) : (i64, i64) -> i64
      %bb29_0 = "braid.load"(%bb29_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb29_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x40106c
      %bb2c_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb2c_3 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb2c_1 = "braid.add"(%bb2c_2, %bb2c_3) : (i64, i64) -> i64
      %bb2c_0 = "braid.load"(%bb2c_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb2c_0) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb2f] : () -> ()
    ^bb2f:  // 0x40106f
      %bb2f_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb2f_3 = "braid.const"() {value = 36 : i64} : () -> i64
      %bb2f_1 = "braid.add"(%bb2f_2, %bb2f_3) : (i64, i64) -> i64
      %bb2f_0 = "braid.load"(%bb2f_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb2f_0) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb33] : () -> ()
    ^bb33:  // 0x401073
      %bb33_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb33_3 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb33_1 = "braid.add"(%bb33_2, %bb33_3) : (i64, i64) -> i64
      %bb33_0 = "braid.load"(%bb33_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb33_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb36] : () -> ()
    ^bb36:  // 0x401076
      %bb36_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb36_0 = "braid.zext"(%bb36_1) {bits = 32 : i64} : (i64) -> i64
      %bb36_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb36_10 = "braid.const"() {value = -24 : i64} : () -> i64
      %bb36_8 = "braid.add"(%bb36_9, %bb36_10) : (i64, i64) -> i64
      "braid.store"(%bb36_8, %bb36_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb3a] : () -> ()
    ^bb3a:  // 0x40107a
      %bb3a_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb3a_3 = "braid.const"() {value = 44 : i64} : () -> i64
      %bb3a_1 = "braid.add"(%bb3a_2, %bb3a_3) : (i64, i64) -> i64
      %bb3a_0 = "braid.load"(%bb3a_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb3a_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb3d] : () -> ()
    ^bb3d:  // 0x40107d
      %bb3d_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb3d_0 = "braid.zext"(%bb3d_1) {bits = 32 : i64} : (i64) -> i64
      %bb3d_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb3d_10 = "braid.const"() {value = -28 : i64} : () -> i64
      %bb3d_8 = "braid.add"(%bb3d_9, %bb3d_10) : (i64, i64) -> i64
      "braid.store"(%bb3d_8, %bb3d_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb41] : () -> ()
    ^bb41:  // 0x401081
      %bb41_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb41_3 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb41_1 = "braid.add"(%bb41_2, %bb41_3) : (i64, i64) -> i64
      %bb41_0 = "braid.load"(%bb41_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb41_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb45] : () -> ()
    ^bb45:  // 0x401085
      %bb45_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb45_3 = "braid.const"() {value = 52 : i64} : () -> i64
      %bb45_1 = "braid.add"(%bb45_2, %bb45_3) : (i64, i64) -> i64
      %bb45_0 = "braid.load"(%bb45_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb45_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x401088
      %bb48_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb48_3 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb48_1 = "braid.add"(%bb48_2, %bb48_3) : (i64, i64) -> i64
      %bb48_0 = "braid.load"(%bb48_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb48_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb4b] : () -> ()
    ^bb4b:  // 0x40108b
      %bb4b_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb4b_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb4b_10 = "braid.const"() {value = -16 : i64} : () -> i64
      %bb4b_8 = "braid.add"(%bb4b_9, %bb4b_10) : (i64, i64) -> i64
      "braid.store"(%bb4b_8, %bb4b_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x401090
      %bb50_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb50_3 = "braid.const"() {value = 60 : i64} : () -> i64
      %bb50_1 = "braid.add"(%bb50_2, %bb50_3) : (i64, i64) -> i64
      %bb50_0 = "braid.load"(%bb50_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb50_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb53] : () -> ()
    ^bb53:  // 0x401093
      %bb53_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb53_3 = "braid.const"() {value = -28 : i64} : () -> i64
      %bb53_1 = "braid.add"(%bb53_2, %bb53_3) : (i64, i64) -> i64
      %bb53_0 = "braid.load"(%bb53_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb53_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb57] : () -> ()
    ^bb57:  // 0x401097
      %bb57_0 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb57_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb57_10 = "braid.const"() {value = -20 : i64} : () -> i64
      %bb57_8 = "braid.add"(%bb57_9, %bb57_10) : (i64, i64) -> i64
      "braid.store"(%bb57_8, %bb57_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb5f] : () -> ()
    ^bb5f:  // 0x40109f
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x4010a0
      %bb60_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb60_0 = "braid.zext"(%bb60_1) {bits = 32 : i64} : (i64) -> i64
      %bb60_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb60_8 = "braid.zext"(%bb60_9) {bits = 32 : i64} : (i64) -> i64
      %bb60_16 = "braid.add"(%bb60_0, %bb60_8) : (i64, i64) -> i64
      %bb60_17 = "braid.zext"(%bb60_16) {bits = 32 : i64} : (i64) -> i64
      %bb60_18 = "braid.ult"(%bb60_17, %bb60_0) : (i64, i64) -> i64
      "braid.setf"(%bb60_18) {flag = "cf"} : (i64) -> ()
      %bb60_19 = "braid.xor"(%bb60_0, %bb60_17) : (i64, i64) -> i64
      %bb60_20 = "braid.xor"(%bb60_8, %bb60_17) : (i64, i64) -> i64
      %bb60_21 = "braid.and"(%bb60_19, %bb60_20) : (i64, i64) -> i64
      %bb60_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb60_23 = "braid.and"(%bb60_21, %bb60_22) : (i64, i64) -> i64
      "braid.setf"(%bb60_23) {flag = "of"} : (i64) -> ()
      %bb60_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb60_24) {flag = "af"} : (i64) -> ()
      %bb60_32 = "braid.zext"(%bb60_17) {bits = 8 : i64} : (i64) -> i64
      %bb60_33 = "braid.popcnt"(%bb60_32) : (i64) -> i64
      %bb60_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb60_35 = "braid.and"(%bb60_33, %bb60_34) : (i64, i64) -> i64
      %bb60_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb60_37 = "braid.eq"(%bb60_35, %bb60_36) : (i64, i64) -> i64
      "braid.setf"(%bb60_37) {flag = "pf"} : (i64) -> ()
      %bb60_38 = "braid.eq"(%bb60_17, %bb60_36) : (i64, i64) -> i64
      "braid.setf"(%bb60_38) {flag = "zf"} : (i64) -> ()
      %bb60_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb60_40 = "braid.and"(%bb60_17, %bb60_39) : (i64, i64) -> i64
      "braid.setf"(%bb60_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb60_17) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb63] : () -> ()
    ^bb63:  // 0x4010a3
      %bb63_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb63_0 = "braid.zext"(%bb63_1) {bits = 32 : i64} : (i64) -> i64
      %bb63_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb63_8 = "braid.zext"(%bb63_9) {bits = 32 : i64} : (i64) -> i64
      %bb63_16 = "braid.xor"(%bb63_0, %bb63_8) : (i64, i64) -> i64
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
      "braid.set"(%bb63_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb66] : () -> ()
    ^bb66:  // 0x4010a6
      %bb66_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb66_0 = "braid.zext"(%bb66_1) {bits = 32 : i64} : (i64) -> i64
      %bb66_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb66_13 = "braid.shl"(%bb66_0, %bb66_12) : (i64, i64) -> i64
      %bb66_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb66_15 = "braid.lshr"(%bb66_0, %bb66_14) : (i64, i64) -> i64
      %bb66_16 = "braid.or"(%bb66_13, %bb66_15) : (i64, i64) -> i64
      %bb66_17 = "braid.zext"(%bb66_16) {bits = 32 : i64} : (i64) -> i64
      %bb66_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb66_19 = "braid.and"(%bb66_17, %bb66_18) : (i64, i64) -> i64
      "braid.setf"(%bb66_19) {flag = "cf"} : (i64) -> ()
      %bb66_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb66_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb66_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb6a] : () -> ()
    ^bb6a:  // 0x4010aa
      %bb6a_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb6a_0 = "braid.zext"(%bb6a_1) {bits = 32 : i64} : (i64) -> i64
      %bb6a_9 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb6a_8 = "braid.zext"(%bb6a_9) {bits = 32 : i64} : (i64) -> i64
      %bb6a_16 = "braid.add"(%bb6a_0, %bb6a_8) : (i64, i64) -> i64
      %bb6a_17 = "braid.zext"(%bb6a_16) {bits = 32 : i64} : (i64) -> i64
      %bb6a_18 = "braid.ult"(%bb6a_17, %bb6a_0) : (i64, i64) -> i64
      "braid.setf"(%bb6a_18) {flag = "cf"} : (i64) -> ()
      %bb6a_19 = "braid.xor"(%bb6a_0, %bb6a_17) : (i64, i64) -> i64
      %bb6a_20 = "braid.xor"(%bb6a_8, %bb6a_17) : (i64, i64) -> i64
      %bb6a_21 = "braid.and"(%bb6a_19, %bb6a_20) : (i64, i64) -> i64
      %bb6a_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb6a_23 = "braid.and"(%bb6a_21, %bb6a_22) : (i64, i64) -> i64
      "braid.setf"(%bb6a_23) {flag = "of"} : (i64) -> ()
      %bb6a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb6a_24) {flag = "af"} : (i64) -> ()
      %bb6a_32 = "braid.zext"(%bb6a_17) {bits = 8 : i64} : (i64) -> i64
      %bb6a_33 = "braid.popcnt"(%bb6a_32) : (i64) -> i64
      %bb6a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb6a_35 = "braid.and"(%bb6a_33, %bb6a_34) : (i64, i64) -> i64
      %bb6a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6a_37 = "braid.eq"(%bb6a_35, %bb6a_36) : (i64, i64) -> i64
      "braid.setf"(%bb6a_37) {flag = "pf"} : (i64) -> ()
      %bb6a_38 = "braid.eq"(%bb6a_17, %bb6a_36) : (i64, i64) -> i64
      "braid.setf"(%bb6a_38) {flag = "zf"} : (i64) -> ()
      %bb6a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb6a_40 = "braid.and"(%bb6a_17, %bb6a_39) : (i64, i64) -> i64
      "braid.setf"(%bb6a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb6a_17) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb6d] : () -> ()
    ^bb6d:  // 0x4010ad
      %bb6d_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb6d_0 = "braid.zext"(%bb6d_1) {bits = 32 : i64} : (i64) -> i64
      %bb6d_9 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb6d_8 = "braid.zext"(%bb6d_9) {bits = 32 : i64} : (i64) -> i64
      %bb6d_16 = "braid.xor"(%bb6d_0, %bb6d_8) : (i64, i64) -> i64
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
      "braid.set"(%bb6d_16) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x4010b0
      %bb70_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb70_0 = "braid.zext"(%bb70_1) {bits = 32 : i64} : (i64) -> i64
      %bb70_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb70_13 = "braid.shl"(%bb70_0, %bb70_12) : (i64, i64) -> i64
      %bb70_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb70_15 = "braid.lshr"(%bb70_0, %bb70_14) : (i64, i64) -> i64
      %bb70_16 = "braid.or"(%bb70_13, %bb70_15) : (i64, i64) -> i64
      %bb70_17 = "braid.zext"(%bb70_16) {bits = 32 : i64} : (i64) -> i64
      %bb70_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb70_19 = "braid.and"(%bb70_17, %bb70_18) : (i64, i64) -> i64
      "braid.setf"(%bb70_19) {flag = "cf"} : (i64) -> ()
      %bb70_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb70_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb70_17) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x4010b4
      %bb74_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb74_0 = "braid.zext"(%bb74_1) {bits = 32 : i64} : (i64) -> i64
      %bb74_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb74_8 = "braid.zext"(%bb74_9) {bits = 32 : i64} : (i64) -> i64
      %bb74_16 = "braid.add"(%bb74_0, %bb74_8) : (i64, i64) -> i64
      %bb74_17 = "braid.zext"(%bb74_16) {bits = 32 : i64} : (i64) -> i64
      %bb74_18 = "braid.ult"(%bb74_17, %bb74_0) : (i64, i64) -> i64
      "braid.setf"(%bb74_18) {flag = "cf"} : (i64) -> ()
      %bb74_19 = "braid.xor"(%bb74_0, %bb74_17) : (i64, i64) -> i64
      %bb74_20 = "braid.xor"(%bb74_8, %bb74_17) : (i64, i64) -> i64
      %bb74_21 = "braid.and"(%bb74_19, %bb74_20) : (i64, i64) -> i64
      %bb74_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb74_23 = "braid.and"(%bb74_21, %bb74_22) : (i64, i64) -> i64
      "braid.setf"(%bb74_23) {flag = "of"} : (i64) -> ()
      %bb74_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb74_24) {flag = "af"} : (i64) -> ()
      %bb74_32 = "braid.zext"(%bb74_17) {bits = 8 : i64} : (i64) -> i64
      %bb74_33 = "braid.popcnt"(%bb74_32) : (i64) -> i64
      %bb74_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb74_35 = "braid.and"(%bb74_33, %bb74_34) : (i64, i64) -> i64
      %bb74_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb74_37 = "braid.eq"(%bb74_35, %bb74_36) : (i64, i64) -> i64
      "braid.setf"(%bb74_37) {flag = "pf"} : (i64) -> ()
      %bb74_38 = "braid.eq"(%bb74_17, %bb74_36) : (i64, i64) -> i64
      "braid.setf"(%bb74_38) {flag = "zf"} : (i64) -> ()
      %bb74_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb74_40 = "braid.and"(%bb74_17, %bb74_39) : (i64, i64) -> i64
      "braid.setf"(%bb74_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb74_17) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb77] : () -> ()
    ^bb77:  // 0x4010b7
      %bb77_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb77_0 = "braid.zext"(%bb77_1) {bits = 32 : i64} : (i64) -> i64
      %bb77_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb77_8 = "braid.zext"(%bb77_9) {bits = 32 : i64} : (i64) -> i64
      %bb77_16 = "braid.xor"(%bb77_0, %bb77_8) : (i64, i64) -> i64
      %bb77_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb77_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb77_17) {flag = "of"} : (i64) -> ()
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
      %bb77_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb77_40 = "braid.and"(%bb77_16, %bb77_39) : (i64, i64) -> i64
      "braid.setf"(%bb77_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb77_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb7a] : () -> ()
    ^bb7a:  // 0x4010ba
      %bb7a_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb7a_0 = "braid.zext"(%bb7a_1) {bits = 32 : i64} : (i64) -> i64
      %bb7a_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb7a_13 = "braid.shl"(%bb7a_0, %bb7a_12) : (i64, i64) -> i64
      %bb7a_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb7a_15 = "braid.lshr"(%bb7a_0, %bb7a_14) : (i64, i64) -> i64
      %bb7a_16 = "braid.or"(%bb7a_13, %bb7a_15) : (i64, i64) -> i64
      %bb7a_17 = "braid.zext"(%bb7a_16) {bits = 32 : i64} : (i64) -> i64
      %bb7a_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb7a_19 = "braid.and"(%bb7a_17, %bb7a_18) : (i64, i64) -> i64
      "braid.setf"(%bb7a_19) {flag = "cf"} : (i64) -> ()
      %bb7a_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb7a_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb7a_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb7e] : () -> ()
    ^bb7e:  // 0x4010be
      %bb7e_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb7e_0 = "braid.zext"(%bb7e_1) {bits = 32 : i64} : (i64) -> i64
      %bb7e_9 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb7e_8 = "braid.zext"(%bb7e_9) {bits = 32 : i64} : (i64) -> i64
      %bb7e_16 = "braid.add"(%bb7e_0, %bb7e_8) : (i64, i64) -> i64
      %bb7e_17 = "braid.zext"(%bb7e_16) {bits = 32 : i64} : (i64) -> i64
      %bb7e_18 = "braid.ult"(%bb7e_17, %bb7e_0) : (i64, i64) -> i64
      "braid.setf"(%bb7e_18) {flag = "cf"} : (i64) -> ()
      %bb7e_19 = "braid.xor"(%bb7e_0, %bb7e_17) : (i64, i64) -> i64
      %bb7e_20 = "braid.xor"(%bb7e_8, %bb7e_17) : (i64, i64) -> i64
      %bb7e_21 = "braid.and"(%bb7e_19, %bb7e_20) : (i64, i64) -> i64
      %bb7e_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb7e_23 = "braid.and"(%bb7e_21, %bb7e_22) : (i64, i64) -> i64
      "braid.setf"(%bb7e_23) {flag = "of"} : (i64) -> ()
      %bb7e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb7e_24) {flag = "af"} : (i64) -> ()
      %bb7e_32 = "braid.zext"(%bb7e_17) {bits = 8 : i64} : (i64) -> i64
      %bb7e_33 = "braid.popcnt"(%bb7e_32) : (i64) -> i64
      %bb7e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb7e_35 = "braid.and"(%bb7e_33, %bb7e_34) : (i64, i64) -> i64
      %bb7e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7e_37 = "braid.eq"(%bb7e_35, %bb7e_36) : (i64, i64) -> i64
      "braid.setf"(%bb7e_37) {flag = "pf"} : (i64) -> ()
      %bb7e_38 = "braid.eq"(%bb7e_17, %bb7e_36) : (i64, i64) -> i64
      "braid.setf"(%bb7e_38) {flag = "zf"} : (i64) -> ()
      %bb7e_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb7e_40 = "braid.and"(%bb7e_17, %bb7e_39) : (i64, i64) -> i64
      "braid.setf"(%bb7e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb7e_17) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb81] : () -> ()
    ^bb81:  // 0x4010c1
      %bb81_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb81_0 = "braid.zext"(%bb81_1) {bits = 32 : i64} : (i64) -> i64
      %bb81_9 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb81_8 = "braid.zext"(%bb81_9) {bits = 32 : i64} : (i64) -> i64
      %bb81_16 = "braid.xor"(%bb81_0, %bb81_8) : (i64, i64) -> i64
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
      %bb81_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb81_40 = "braid.and"(%bb81_16, %bb81_39) : (i64, i64) -> i64
      "braid.setf"(%bb81_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb81_16) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x4010c4
      %bb84_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb84_0 = "braid.zext"(%bb84_1) {bits = 32 : i64} : (i64) -> i64
      %bb84_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb84_13 = "braid.shl"(%bb84_0, %bb84_12) : (i64, i64) -> i64
      %bb84_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb84_15 = "braid.lshr"(%bb84_0, %bb84_14) : (i64, i64) -> i64
      %bb84_16 = "braid.or"(%bb84_13, %bb84_15) : (i64, i64) -> i64
      %bb84_17 = "braid.zext"(%bb84_16) {bits = 32 : i64} : (i64) -> i64
      %bb84_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb84_19 = "braid.and"(%bb84_17, %bb84_18) : (i64, i64) -> i64
      "braid.setf"(%bb84_19) {flag = "cf"} : (i64) -> ()
      %bb84_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb84_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb84_17) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x4010c8
      %bb88_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb88_0 = "braid.zext"(%bb88_1) {bits = 32 : i64} : (i64) -> i64
      %bb88_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb88_8 = "braid.zext"(%bb88_9) {bits = 32 : i64} : (i64) -> i64
      %bb88_16 = "braid.add"(%bb88_0, %bb88_8) : (i64, i64) -> i64
      %bb88_17 = "braid.zext"(%bb88_16) {bits = 32 : i64} : (i64) -> i64
      %bb88_18 = "braid.ult"(%bb88_17, %bb88_0) : (i64, i64) -> i64
      "braid.setf"(%bb88_18) {flag = "cf"} : (i64) -> ()
      %bb88_19 = "braid.xor"(%bb88_0, %bb88_17) : (i64, i64) -> i64
      %bb88_20 = "braid.xor"(%bb88_8, %bb88_17) : (i64, i64) -> i64
      %bb88_21 = "braid.and"(%bb88_19, %bb88_20) : (i64, i64) -> i64
      %bb88_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb88_23 = "braid.and"(%bb88_21, %bb88_22) : (i64, i64) -> i64
      "braid.setf"(%bb88_23) {flag = "of"} : (i64) -> ()
      %bb88_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb88_24) {flag = "af"} : (i64) -> ()
      %bb88_32 = "braid.zext"(%bb88_17) {bits = 8 : i64} : (i64) -> i64
      %bb88_33 = "braid.popcnt"(%bb88_32) : (i64) -> i64
      %bb88_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb88_35 = "braid.and"(%bb88_33, %bb88_34) : (i64, i64) -> i64
      %bb88_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb88_37 = "braid.eq"(%bb88_35, %bb88_36) : (i64, i64) -> i64
      "braid.setf"(%bb88_37) {flag = "pf"} : (i64) -> ()
      %bb88_38 = "braid.eq"(%bb88_17, %bb88_36) : (i64, i64) -> i64
      "braid.setf"(%bb88_38) {flag = "zf"} : (i64) -> ()
      %bb88_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb88_40 = "braid.and"(%bb88_17, %bb88_39) : (i64, i64) -> i64
      "braid.setf"(%bb88_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb88_17) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb8b] : () -> ()
    ^bb8b:  // 0x4010cb
      %bb8b_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb8b_0 = "braid.zext"(%bb8b_1) {bits = 32 : i64} : (i64) -> i64
      %bb8b_9 = "braid.get"() {reg = "rdi"} : () -> i64
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
      "braid.set"(%bb8b_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb8d] : () -> ()
    ^bb8d:  // 0x4010cd
      %bb8d_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb8d_0 = "braid.zext"(%bb8d_1) {bits = 32 : i64} : (i64) -> i64
      %bb8d_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb8d_13 = "braid.shl"(%bb8d_0, %bb8d_12) : (i64, i64) -> i64
      %bb8d_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb8d_15 = "braid.lshr"(%bb8d_0, %bb8d_14) : (i64, i64) -> i64
      %bb8d_16 = "braid.or"(%bb8d_13, %bb8d_15) : (i64, i64) -> i64
      %bb8d_17 = "braid.zext"(%bb8d_16) {bits = 32 : i64} : (i64) -> i64
      %bb8d_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8d_19 = "braid.and"(%bb8d_17, %bb8d_18) : (i64, i64) -> i64
      "braid.setf"(%bb8d_19) {flag = "cf"} : (i64) -> ()
      %bb8d_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb8d_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb8d_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x4010d0
      %bb90_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb90_0 = "braid.zext"(%bb90_1) {bits = 32 : i64} : (i64) -> i64
      %bb90_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb90_8 = "braid.zext"(%bb90_9) {bits = 32 : i64} : (i64) -> i64
      %bb90_16 = "braid.add"(%bb90_0, %bb90_8) : (i64, i64) -> i64
      %bb90_17 = "braid.zext"(%bb90_16) {bits = 32 : i64} : (i64) -> i64
      %bb90_18 = "braid.ult"(%bb90_17, %bb90_0) : (i64, i64) -> i64
      "braid.setf"(%bb90_18) {flag = "cf"} : (i64) -> ()
      %bb90_19 = "braid.xor"(%bb90_0, %bb90_17) : (i64, i64) -> i64
      %bb90_20 = "braid.xor"(%bb90_8, %bb90_17) : (i64, i64) -> i64
      %bb90_21 = "braid.and"(%bb90_19, %bb90_20) : (i64, i64) -> i64
      %bb90_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb90_23 = "braid.and"(%bb90_21, %bb90_22) : (i64, i64) -> i64
      "braid.setf"(%bb90_23) {flag = "of"} : (i64) -> ()
      %bb90_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb90_24) {flag = "af"} : (i64) -> ()
      %bb90_32 = "braid.zext"(%bb90_17) {bits = 8 : i64} : (i64) -> i64
      %bb90_33 = "braid.popcnt"(%bb90_32) : (i64) -> i64
      %bb90_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb90_35 = "braid.and"(%bb90_33, %bb90_34) : (i64, i64) -> i64
      %bb90_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb90_37 = "braid.eq"(%bb90_35, %bb90_36) : (i64, i64) -> i64
      "braid.setf"(%bb90_37) {flag = "pf"} : (i64) -> ()
      %bb90_38 = "braid.eq"(%bb90_17, %bb90_36) : (i64, i64) -> i64
      "braid.setf"(%bb90_38) {flag = "zf"} : (i64) -> ()
      %bb90_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb90_40 = "braid.and"(%bb90_17, %bb90_39) : (i64, i64) -> i64
      "braid.setf"(%bb90_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb90_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb93] : () -> ()
    ^bb93:  // 0x4010d3
      %bb93_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb93_0 = "braid.zext"(%bb93_1) {bits = 32 : i64} : (i64) -> i64
      %bb93_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb93_8 = "braid.zext"(%bb93_9) {bits = 32 : i64} : (i64) -> i64
      %bb93_16 = "braid.xor"(%bb93_0, %bb93_8) : (i64, i64) -> i64
      %bb93_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb93_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb93_17) {flag = "of"} : (i64) -> ()
      %bb93_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb93_24) {flag = "af"} : (i64) -> ()
      %bb93_32 = "braid.zext"(%bb93_16) {bits = 8 : i64} : (i64) -> i64
      %bb93_33 = "braid.popcnt"(%bb93_32) : (i64) -> i64
      %bb93_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb93_35 = "braid.and"(%bb93_33, %bb93_34) : (i64, i64) -> i64
      %bb93_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb93_37 = "braid.eq"(%bb93_35, %bb93_36) : (i64, i64) -> i64
      "braid.setf"(%bb93_37) {flag = "pf"} : (i64) -> ()
      %bb93_38 = "braid.eq"(%bb93_16, %bb93_36) : (i64, i64) -> i64
      "braid.setf"(%bb93_38) {flag = "zf"} : (i64) -> ()
      %bb93_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb93_40 = "braid.and"(%bb93_16, %bb93_39) : (i64, i64) -> i64
      "braid.setf"(%bb93_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb93_16) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb96] : () -> ()
    ^bb96:  // 0x4010d6
      %bb96_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb96_0 = "braid.zext"(%bb96_1) {bits = 32 : i64} : (i64) -> i64
      %bb96_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb96_13 = "braid.shl"(%bb96_0, %bb96_12) : (i64, i64) -> i64
      %bb96_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb96_15 = "braid.lshr"(%bb96_0, %bb96_14) : (i64, i64) -> i64
      %bb96_16 = "braid.or"(%bb96_13, %bb96_15) : (i64, i64) -> i64
      %bb96_17 = "braid.zext"(%bb96_16) {bits = 32 : i64} : (i64) -> i64
      %bb96_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb96_19 = "braid.and"(%bb96_17, %bb96_18) : (i64, i64) -> i64
      "braid.setf"(%bb96_19) {flag = "cf"} : (i64) -> ()
      %bb96_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb96_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb96_17) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb9a] : () -> ()
    ^bb9a:  // 0x4010da
      %bb9a_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb9a_0 = "braid.zext"(%bb9a_1) {bits = 32 : i64} : (i64) -> i64
      %bb9a_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb9a_8 = "braid.zext"(%bb9a_9) {bits = 32 : i64} : (i64) -> i64
      %bb9a_16 = "braid.add"(%bb9a_0, %bb9a_8) : (i64, i64) -> i64
      %bb9a_17 = "braid.zext"(%bb9a_16) {bits = 32 : i64} : (i64) -> i64
      %bb9a_18 = "braid.ult"(%bb9a_17, %bb9a_0) : (i64, i64) -> i64
      "braid.setf"(%bb9a_18) {flag = "cf"} : (i64) -> ()
      %bb9a_19 = "braid.xor"(%bb9a_0, %bb9a_17) : (i64, i64) -> i64
      %bb9a_20 = "braid.xor"(%bb9a_8, %bb9a_17) : (i64, i64) -> i64
      %bb9a_21 = "braid.and"(%bb9a_19, %bb9a_20) : (i64, i64) -> i64
      %bb9a_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb9a_23 = "braid.and"(%bb9a_21, %bb9a_22) : (i64, i64) -> i64
      "braid.setf"(%bb9a_23) {flag = "of"} : (i64) -> ()
      %bb9a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb9a_24) {flag = "af"} : (i64) -> ()
      %bb9a_32 = "braid.zext"(%bb9a_17) {bits = 8 : i64} : (i64) -> i64
      %bb9a_33 = "braid.popcnt"(%bb9a_32) : (i64) -> i64
      %bb9a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb9a_35 = "braid.and"(%bb9a_33, %bb9a_34) : (i64, i64) -> i64
      %bb9a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9a_37 = "braid.eq"(%bb9a_35, %bb9a_36) : (i64, i64) -> i64
      "braid.setf"(%bb9a_37) {flag = "pf"} : (i64) -> ()
      %bb9a_38 = "braid.eq"(%bb9a_17, %bb9a_36) : (i64, i64) -> i64
      "braid.setf"(%bb9a_38) {flag = "zf"} : (i64) -> ()
      %bb9a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb9a_40 = "braid.and"(%bb9a_17, %bb9a_39) : (i64, i64) -> i64
      "braid.setf"(%bb9a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb9a_17) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb9d] : () -> ()
    ^bb9d:  // 0x4010dd
      %bb9d_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb9d_0 = "braid.zext"(%bb9d_1) {bits = 32 : i64} : (i64) -> i64
      %bb9d_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb9d_8 = "braid.zext"(%bb9d_9) {bits = 32 : i64} : (i64) -> i64
      %bb9d_16 = "braid.xor"(%bb9d_0, %bb9d_8) : (i64, i64) -> i64
      %bb9d_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb9d_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb9d_17) {flag = "of"} : (i64) -> ()
      %bb9d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb9d_24) {flag = "af"} : (i64) -> ()
      %bb9d_32 = "braid.zext"(%bb9d_16) {bits = 8 : i64} : (i64) -> i64
      %bb9d_33 = "braid.popcnt"(%bb9d_32) : (i64) -> i64
      %bb9d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb9d_35 = "braid.and"(%bb9d_33, %bb9d_34) : (i64, i64) -> i64
      %bb9d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9d_37 = "braid.eq"(%bb9d_35, %bb9d_36) : (i64, i64) -> i64
      "braid.setf"(%bb9d_37) {flag = "pf"} : (i64) -> ()
      %bb9d_38 = "braid.eq"(%bb9d_16, %bb9d_36) : (i64, i64) -> i64
      "braid.setf"(%bb9d_38) {flag = "zf"} : (i64) -> ()
      %bb9d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb9d_40 = "braid.and"(%bb9d_16, %bb9d_39) : (i64, i64) -> i64
      "braid.setf"(%bb9d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb9d_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb9f] : () -> ()
    ^bb9f:  // 0x4010df
      %bb9f_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb9f_0 = "braid.zext"(%bb9f_1) {bits = 32 : i64} : (i64) -> i64
      %bb9f_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb9f_13 = "braid.shl"(%bb9f_0, %bb9f_12) : (i64, i64) -> i64
      %bb9f_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb9f_15 = "braid.lshr"(%bb9f_0, %bb9f_14) : (i64, i64) -> i64
      %bb9f_16 = "braid.or"(%bb9f_13, %bb9f_15) : (i64, i64) -> i64
      %bb9f_17 = "braid.zext"(%bb9f_16) {bits = 32 : i64} : (i64) -> i64
      %bb9f_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb9f_19 = "braid.and"(%bb9f_17, %bb9f_18) : (i64, i64) -> i64
      "braid.setf"(%bb9f_19) {flag = "cf"} : (i64) -> ()
      %bb9f_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb9f_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb9f_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bba2] : () -> ()
    ^bba2:  // 0x4010e2
      %bba2_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bba2_0 = "braid.zext"(%bba2_1) {bits = 32 : i64} : (i64) -> i64
      %bba2_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bba2_8 = "braid.zext"(%bba2_9) {bits = 32 : i64} : (i64) -> i64
      %bba2_16 = "braid.add"(%bba2_0, %bba2_8) : (i64, i64) -> i64
      %bba2_17 = "braid.zext"(%bba2_16) {bits = 32 : i64} : (i64) -> i64
      %bba2_18 = "braid.ult"(%bba2_17, %bba2_0) : (i64, i64) -> i64
      "braid.setf"(%bba2_18) {flag = "cf"} : (i64) -> ()
      %bba2_19 = "braid.xor"(%bba2_0, %bba2_17) : (i64, i64) -> i64
      %bba2_20 = "braid.xor"(%bba2_8, %bba2_17) : (i64, i64) -> i64
      %bba2_21 = "braid.and"(%bba2_19, %bba2_20) : (i64, i64) -> i64
      %bba2_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bba2_23 = "braid.and"(%bba2_21, %bba2_22) : (i64, i64) -> i64
      "braid.setf"(%bba2_23) {flag = "of"} : (i64) -> ()
      %bba2_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bba2_24) {flag = "af"} : (i64) -> ()
      %bba2_32 = "braid.zext"(%bba2_17) {bits = 8 : i64} : (i64) -> i64
      %bba2_33 = "braid.popcnt"(%bba2_32) : (i64) -> i64
      %bba2_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bba2_35 = "braid.and"(%bba2_33, %bba2_34) : (i64, i64) -> i64
      %bba2_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba2_37 = "braid.eq"(%bba2_35, %bba2_36) : (i64, i64) -> i64
      "braid.setf"(%bba2_37) {flag = "pf"} : (i64) -> ()
      %bba2_38 = "braid.eq"(%bba2_17, %bba2_36) : (i64, i64) -> i64
      "braid.setf"(%bba2_38) {flag = "zf"} : (i64) -> ()
      %bba2_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bba2_40 = "braid.and"(%bba2_17, %bba2_39) : (i64, i64) -> i64
      "braid.setf"(%bba2_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bba2_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bba5] : () -> ()
    ^bba5:  // 0x4010e5
      %bba5_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bba5_0 = "braid.zext"(%bba5_1) {bits = 32 : i64} : (i64) -> i64
      %bba5_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bba5_10 = "braid.const"() {value = -28 : i64} : () -> i64
      %bba5_8 = "braid.add"(%bba5_9, %bba5_10) : (i64, i64) -> i64
      "braid.store"(%bba5_8, %bba5_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbaa] : () -> ()
    ^bbaa:  // 0x4010ea
      %bbaa_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bbaa_0 = "braid.zext"(%bbaa_1) {bits = 32 : i64} : (i64) -> i64
      %bbaa_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bbaa_8 = "braid.zext"(%bbaa_9) {bits = 32 : i64} : (i64) -> i64
      %bbaa_16 = "braid.xor"(%bbaa_0, %bbaa_8) : (i64, i64) -> i64
      %bbaa_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbaa_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbaa_17) {flag = "of"} : (i64) -> ()
      %bbaa_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbaa_24) {flag = "af"} : (i64) -> ()
      %bbaa_32 = "braid.zext"(%bbaa_16) {bits = 8 : i64} : (i64) -> i64
      %bbaa_33 = "braid.popcnt"(%bbaa_32) : (i64) -> i64
      %bbaa_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbaa_35 = "braid.and"(%bbaa_33, %bbaa_34) : (i64, i64) -> i64
      %bbaa_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbaa_37 = "braid.eq"(%bbaa_35, %bbaa_36) : (i64, i64) -> i64
      "braid.setf"(%bbaa_37) {flag = "pf"} : (i64) -> ()
      %bbaa_38 = "braid.eq"(%bbaa_16, %bbaa_36) : (i64, i64) -> i64
      "braid.setf"(%bbaa_38) {flag = "zf"} : (i64) -> ()
      %bbaa_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbaa_40 = "braid.and"(%bbaa_16, %bbaa_39) : (i64, i64) -> i64
      "braid.setf"(%bbaa_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbaa_16) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bbad] : () -> ()
    ^bbad:  // 0x4010ed
      %bbad_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bbad_0 = "braid.zext"(%bbad_1) {bits = 32 : i64} : (i64) -> i64
      %bbad_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbad_13 = "braid.shl"(%bbad_0, %bbad_12) : (i64, i64) -> i64
      %bbad_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbad_15 = "braid.lshr"(%bbad_0, %bbad_14) : (i64, i64) -> i64
      %bbad_16 = "braid.or"(%bbad_13, %bbad_15) : (i64, i64) -> i64
      %bbad_17 = "braid.zext"(%bbad_16) {bits = 32 : i64} : (i64) -> i64
      %bbad_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbad_19 = "braid.and"(%bbad_17, %bbad_18) : (i64, i64) -> i64
      "braid.setf"(%bbad_19) {flag = "cf"} : (i64) -> ()
      %bbad_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbad_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbad_17) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bbb1] : () -> ()
    ^bbb1:  // 0x4010f1
      %bbb1_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bbb1_0 = "braid.zext"(%bbb1_1) {bits = 32 : i64} : (i64) -> i64
      %bbb1_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bbb1_8 = "braid.zext"(%bbb1_9) {bits = 32 : i64} : (i64) -> i64
      %bbb1_16 = "braid.add"(%bbb1_0, %bbb1_8) : (i64, i64) -> i64
      %bbb1_17 = "braid.zext"(%bbb1_16) {bits = 32 : i64} : (i64) -> i64
      %bbb1_18 = "braid.ult"(%bbb1_17, %bbb1_0) : (i64, i64) -> i64
      "braid.setf"(%bbb1_18) {flag = "cf"} : (i64) -> ()
      %bbb1_19 = "braid.xor"(%bbb1_0, %bbb1_17) : (i64, i64) -> i64
      %bbb1_20 = "braid.xor"(%bbb1_8, %bbb1_17) : (i64, i64) -> i64
      %bbb1_21 = "braid.and"(%bbb1_19, %bbb1_20) : (i64, i64) -> i64
      %bbb1_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbb1_23 = "braid.and"(%bbb1_21, %bbb1_22) : (i64, i64) -> i64
      "braid.setf"(%bbb1_23) {flag = "of"} : (i64) -> ()
      %bbb1_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbb1_24) {flag = "af"} : (i64) -> ()
      %bbb1_32 = "braid.zext"(%bbb1_17) {bits = 8 : i64} : (i64) -> i64
      %bbb1_33 = "braid.popcnt"(%bbb1_32) : (i64) -> i64
      %bbb1_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbb1_35 = "braid.and"(%bbb1_33, %bbb1_34) : (i64, i64) -> i64
      %bbb1_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb1_37 = "braid.eq"(%bbb1_35, %bbb1_36) : (i64, i64) -> i64
      "braid.setf"(%bbb1_37) {flag = "pf"} : (i64) -> ()
      %bbb1_38 = "braid.eq"(%bbb1_17, %bbb1_36) : (i64, i64) -> i64
      "braid.setf"(%bbb1_38) {flag = "zf"} : (i64) -> ()
      %bbb1_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbb1_40 = "braid.and"(%bbb1_17, %bbb1_39) : (i64, i64) -> i64
      "braid.setf"(%bbb1_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbb1_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x4010f4
      %bbb4_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbb4_0 = "braid.zext"(%bbb4_1) {bits = 32 : i64} : (i64) -> i64
      %bbb4_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bbb4_8 = "braid.zext"(%bbb4_9) {bits = 32 : i64} : (i64) -> i64
      %bbb4_16 = "braid.xor"(%bbb4_0, %bbb4_8) : (i64, i64) -> i64
      %bbb4_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbb4_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbb4_17) {flag = "of"} : (i64) -> ()
      %bbb4_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbb4_24) {flag = "af"} : (i64) -> ()
      %bbb4_32 = "braid.zext"(%bbb4_16) {bits = 8 : i64} : (i64) -> i64
      %bbb4_33 = "braid.popcnt"(%bbb4_32) : (i64) -> i64
      %bbb4_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbb4_35 = "braid.and"(%bbb4_33, %bbb4_34) : (i64, i64) -> i64
      %bbb4_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb4_37 = "braid.eq"(%bbb4_35, %bbb4_36) : (i64, i64) -> i64
      "braid.setf"(%bbb4_37) {flag = "pf"} : (i64) -> ()
      %bbb4_38 = "braid.eq"(%bbb4_16, %bbb4_36) : (i64, i64) -> i64
      "braid.setf"(%bbb4_38) {flag = "zf"} : (i64) -> ()
      %bbb4_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbb4_40 = "braid.and"(%bbb4_16, %bbb4_39) : (i64, i64) -> i64
      "braid.setf"(%bbb4_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbb4_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbb7] : () -> ()
    ^bbb7:  // 0x4010f7
      %bbb7_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbb7_0 = "braid.zext"(%bbb7_1) {bits = 32 : i64} : (i64) -> i64
      %bbb7_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbb7_13 = "braid.shl"(%bbb7_0, %bbb7_12) : (i64, i64) -> i64
      %bbb7_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbb7_15 = "braid.lshr"(%bbb7_0, %bbb7_14) : (i64, i64) -> i64
      %bbb7_16 = "braid.or"(%bbb7_13, %bbb7_15) : (i64, i64) -> i64
      %bbb7_17 = "braid.zext"(%bbb7_16) {bits = 32 : i64} : (i64) -> i64
      %bbb7_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbb7_19 = "braid.and"(%bbb7_17, %bbb7_18) : (i64, i64) -> i64
      "braid.setf"(%bbb7_19) {flag = "cf"} : (i64) -> ()
      %bbb7_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbb7_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbb7_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbba] : () -> ()
    ^bbba:  // 0x4010fa
      %bbba_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbba_3 = "braid.const"() {value = -24 : i64} : () -> i64
      %bbba_1 = "braid.add"(%bbba_2, %bbba_3) : (i64, i64) -> i64
      %bbba_0 = "braid.load"(%bbba_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbba_0) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bbbf] : () -> ()
    ^bbbf:  // 0x4010ff
      %bbbf_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbbf_0 = "braid.zext"(%bbbf_1) {bits = 32 : i64} : (i64) -> i64
      %bbbf_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bbbf_8 = "braid.zext"(%bbbf_9) {bits = 32 : i64} : (i64) -> i64
      %bbbf_16 = "braid.add"(%bbbf_0, %bbbf_8) : (i64, i64) -> i64
      %bbbf_17 = "braid.zext"(%bbbf_16) {bits = 32 : i64} : (i64) -> i64
      %bbbf_18 = "braid.ult"(%bbbf_17, %bbbf_0) : (i64, i64) -> i64
      "braid.setf"(%bbbf_18) {flag = "cf"} : (i64) -> ()
      %bbbf_19 = "braid.xor"(%bbbf_0, %bbbf_17) : (i64, i64) -> i64
      %bbbf_20 = "braid.xor"(%bbbf_8, %bbbf_17) : (i64, i64) -> i64
      %bbbf_21 = "braid.and"(%bbbf_19, %bbbf_20) : (i64, i64) -> i64
      %bbbf_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbbf_23 = "braid.and"(%bbbf_21, %bbbf_22) : (i64, i64) -> i64
      "braid.setf"(%bbbf_23) {flag = "of"} : (i64) -> ()
      %bbbf_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbbf_24) {flag = "af"} : (i64) -> ()
      %bbbf_32 = "braid.zext"(%bbbf_17) {bits = 8 : i64} : (i64) -> i64
      %bbbf_33 = "braid.popcnt"(%bbbf_32) : (i64) -> i64
      %bbbf_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbbf_35 = "braid.and"(%bbbf_33, %bbbf_34) : (i64, i64) -> i64
      %bbbf_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbbf_37 = "braid.eq"(%bbbf_35, %bbbf_36) : (i64, i64) -> i64
      "braid.setf"(%bbbf_37) {flag = "pf"} : (i64) -> ()
      %bbbf_38 = "braid.eq"(%bbbf_17, %bbbf_36) : (i64, i64) -> i64
      "braid.setf"(%bbbf_38) {flag = "zf"} : (i64) -> ()
      %bbbf_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbbf_40 = "braid.and"(%bbbf_17, %bbbf_39) : (i64, i64) -> i64
      "braid.setf"(%bbbf_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbbf_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bbc2] : () -> ()
    ^bbc2:  // 0x401102
      %bbc2_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bbc2_0 = "braid.zext"(%bbc2_1) {bits = 32 : i64} : (i64) -> i64
      %bbc2_9 = "braid.get"() {reg = "r11"} : () -> i64
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
      "braid.set"(%bbc2_16) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bbc5] : () -> ()
    ^bbc5:  // 0x401105
      %bbc5_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bbc5_0 = "braid.zext"(%bbc5_1) {bits = 32 : i64} : (i64) -> i64
      %bbc5_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bbc5_13 = "braid.shl"(%bbc5_0, %bbc5_12) : (i64, i64) -> i64
      %bbc5_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bbc5_15 = "braid.lshr"(%bbc5_0, %bbc5_14) : (i64, i64) -> i64
      %bbc5_16 = "braid.or"(%bbc5_13, %bbc5_15) : (i64, i64) -> i64
      %bbc5_17 = "braid.zext"(%bbc5_16) {bits = 32 : i64} : (i64) -> i64
      %bbc5_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc5_19 = "braid.and"(%bbc5_17, %bbc5_18) : (i64, i64) -> i64
      "braid.setf"(%bbc5_19) {flag = "cf"} : (i64) -> ()
      %bbc5_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc5_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbc5_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bbc9] : () -> ()
    ^bbc9:  // 0x401109
      %bbc9_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bbc9_0 = "braid.zext"(%bbc9_1) {bits = 32 : i64} : (i64) -> i64
      %bbc9_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bbc9_8 = "braid.zext"(%bbc9_9) {bits = 32 : i64} : (i64) -> i64
      %bbc9_16 = "braid.add"(%bbc9_0, %bbc9_8) : (i64, i64) -> i64
      %bbc9_17 = "braid.zext"(%bbc9_16) {bits = 32 : i64} : (i64) -> i64
      %bbc9_18 = "braid.ult"(%bbc9_17, %bbc9_0) : (i64, i64) -> i64
      "braid.setf"(%bbc9_18) {flag = "cf"} : (i64) -> ()
      %bbc9_19 = "braid.xor"(%bbc9_0, %bbc9_17) : (i64, i64) -> i64
      %bbc9_20 = "braid.xor"(%bbc9_8, %bbc9_17) : (i64, i64) -> i64
      %bbc9_21 = "braid.and"(%bbc9_19, %bbc9_20) : (i64, i64) -> i64
      %bbc9_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbc9_23 = "braid.and"(%bbc9_21, %bbc9_22) : (i64, i64) -> i64
      "braid.setf"(%bbc9_23) {flag = "of"} : (i64) -> ()
      %bbc9_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc9_24) {flag = "af"} : (i64) -> ()
      %bbc9_32 = "braid.zext"(%bbc9_17) {bits = 8 : i64} : (i64) -> i64
      %bbc9_33 = "braid.popcnt"(%bbc9_32) : (i64) -> i64
      %bbc9_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc9_35 = "braid.and"(%bbc9_33, %bbc9_34) : (i64, i64) -> i64
      %bbc9_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc9_37 = "braid.eq"(%bbc9_35, %bbc9_36) : (i64, i64) -> i64
      "braid.setf"(%bbc9_37) {flag = "pf"} : (i64) -> ()
      %bbc9_38 = "braid.eq"(%bbc9_17, %bbc9_36) : (i64, i64) -> i64
      "braid.setf"(%bbc9_38) {flag = "zf"} : (i64) -> ()
      %bbc9_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbc9_40 = "braid.and"(%bbc9_17, %bbc9_39) : (i64, i64) -> i64
      "braid.setf"(%bbc9_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbc9_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x40110c
      %bbcc_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbcc_0 = "braid.zext"(%bbcc_1) {bits = 32 : i64} : (i64) -> i64
      %bbcc_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bbcc_8 = "braid.zext"(%bbcc_9) {bits = 32 : i64} : (i64) -> i64
      %bbcc_16 = "braid.xor"(%bbcc_0, %bbcc_8) : (i64, i64) -> i64
      %bbcc_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbcc_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbcc_17) {flag = "of"} : (i64) -> ()
      %bbcc_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbcc_24) {flag = "af"} : (i64) -> ()
      %bbcc_32 = "braid.zext"(%bbcc_16) {bits = 8 : i64} : (i64) -> i64
      %bbcc_33 = "braid.popcnt"(%bbcc_32) : (i64) -> i64
      %bbcc_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbcc_35 = "braid.and"(%bbcc_33, %bbcc_34) : (i64, i64) -> i64
      %bbcc_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbcc_37 = "braid.eq"(%bbcc_35, %bbcc_36) : (i64, i64) -> i64
      "braid.setf"(%bbcc_37) {flag = "pf"} : (i64) -> ()
      %bbcc_38 = "braid.eq"(%bbcc_16, %bbcc_36) : (i64, i64) -> i64
      "braid.setf"(%bbcc_38) {flag = "zf"} : (i64) -> ()
      %bbcc_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbcc_40 = "braid.and"(%bbcc_16, %bbcc_39) : (i64, i64) -> i64
      "braid.setf"(%bbcc_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbcc_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbcf] : () -> ()
    ^bbcf:  // 0x40110f
      %bbcf_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbcf_0 = "braid.zext"(%bbcf_1) {bits = 32 : i64} : (i64) -> i64
      %bbcf_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbcf_13 = "braid.shl"(%bbcf_0, %bbcf_12) : (i64, i64) -> i64
      %bbcf_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbcf_15 = "braid.lshr"(%bbcf_0, %bbcf_14) : (i64, i64) -> i64
      %bbcf_16 = "braid.or"(%bbcf_13, %bbcf_15) : (i64, i64) -> i64
      %bbcf_17 = "braid.zext"(%bbcf_16) {bits = 32 : i64} : (i64) -> i64
      %bbcf_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbcf_19 = "braid.and"(%bbcf_17, %bbcf_18) : (i64, i64) -> i64
      "braid.setf"(%bbcf_19) {flag = "cf"} : (i64) -> ()
      %bbcf_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbcf_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbcf_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbd2] : () -> ()
    ^bbd2:  // 0x401112
      %bbd2_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbd2_0 = "braid.zext"(%bbd2_1) {bits = 32 : i64} : (i64) -> i64
      %bbd2_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bbd2_8 = "braid.zext"(%bbd2_9) {bits = 32 : i64} : (i64) -> i64
      %bbd2_16 = "braid.add"(%bbd2_0, %bbd2_8) : (i64, i64) -> i64
      %bbd2_17 = "braid.zext"(%bbd2_16) {bits = 32 : i64} : (i64) -> i64
      %bbd2_18 = "braid.ult"(%bbd2_17, %bbd2_0) : (i64, i64) -> i64
      "braid.setf"(%bbd2_18) {flag = "cf"} : (i64) -> ()
      %bbd2_19 = "braid.xor"(%bbd2_0, %bbd2_17) : (i64, i64) -> i64
      %bbd2_20 = "braid.xor"(%bbd2_8, %bbd2_17) : (i64, i64) -> i64
      %bbd2_21 = "braid.and"(%bbd2_19, %bbd2_20) : (i64, i64) -> i64
      %bbd2_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbd2_23 = "braid.and"(%bbd2_21, %bbd2_22) : (i64, i64) -> i64
      "braid.setf"(%bbd2_23) {flag = "of"} : (i64) -> ()
      %bbd2_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbd2_24) {flag = "af"} : (i64) -> ()
      %bbd2_32 = "braid.zext"(%bbd2_17) {bits = 8 : i64} : (i64) -> i64
      %bbd2_33 = "braid.popcnt"(%bbd2_32) : (i64) -> i64
      %bbd2_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd2_35 = "braid.and"(%bbd2_33, %bbd2_34) : (i64, i64) -> i64
      %bbd2_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd2_37 = "braid.eq"(%bbd2_35, %bbd2_36) : (i64, i64) -> i64
      "braid.setf"(%bbd2_37) {flag = "pf"} : (i64) -> ()
      %bbd2_38 = "braid.eq"(%bbd2_17, %bbd2_36) : (i64, i64) -> i64
      "braid.setf"(%bbd2_38) {flag = "zf"} : (i64) -> ()
      %bbd2_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbd2_40 = "braid.and"(%bbd2_17, %bbd2_39) : (i64, i64) -> i64
      "braid.setf"(%bbd2_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbd2_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bbd5] : () -> ()
    ^bbd5:  // 0x401115
      %bbd5_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bbd5_0 = "braid.zext"(%bbd5_1) {bits = 32 : i64} : (i64) -> i64
      %bbd5_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bbd5_8 = "braid.zext"(%bbd5_9) {bits = 32 : i64} : (i64) -> i64
      %bbd5_16 = "braid.xor"(%bbd5_0, %bbd5_8) : (i64, i64) -> i64
      %bbd5_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbd5_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbd5_17) {flag = "of"} : (i64) -> ()
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
      %bbd5_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbd5_40 = "braid.and"(%bbd5_16, %bbd5_39) : (i64, i64) -> i64
      "braid.setf"(%bbd5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbd5_16) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bbd8] : () -> ()
    ^bbd8:  // 0x401118
      %bbd8_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bbd8_0 = "braid.zext"(%bbd8_1) {bits = 32 : i64} : (i64) -> i64
      %bbd8_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbd8_13 = "braid.shl"(%bbd8_0, %bbd8_12) : (i64, i64) -> i64
      %bbd8_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbd8_15 = "braid.lshr"(%bbd8_0, %bbd8_14) : (i64, i64) -> i64
      %bbd8_16 = "braid.or"(%bbd8_13, %bbd8_15) : (i64, i64) -> i64
      %bbd8_17 = "braid.zext"(%bbd8_16) {bits = 32 : i64} : (i64) -> i64
      %bbd8_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd8_19 = "braid.and"(%bbd8_17, %bbd8_18) : (i64, i64) -> i64
      "braid.setf"(%bbd8_19) {flag = "cf"} : (i64) -> ()
      %bbd8_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbd8_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbd8_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x40111c
      %bbdc_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bbdc_0 = "braid.zext"(%bbdc_1) {bits = 32 : i64} : (i64) -> i64
      %bbdc_9 = "braid.get"() {reg = "r13"} : () -> i64
      %bbdc_8 = "braid.zext"(%bbdc_9) {bits = 32 : i64} : (i64) -> i64
      %bbdc_16 = "braid.add"(%bbdc_0, %bbdc_8) : (i64, i64) -> i64
      %bbdc_17 = "braid.zext"(%bbdc_16) {bits = 32 : i64} : (i64) -> i64
      %bbdc_18 = "braid.ult"(%bbdc_17, %bbdc_0) : (i64, i64) -> i64
      "braid.setf"(%bbdc_18) {flag = "cf"} : (i64) -> ()
      %bbdc_19 = "braid.xor"(%bbdc_0, %bbdc_17) : (i64, i64) -> i64
      %bbdc_20 = "braid.xor"(%bbdc_8, %bbdc_17) : (i64, i64) -> i64
      %bbdc_21 = "braid.and"(%bbdc_19, %bbdc_20) : (i64, i64) -> i64
      %bbdc_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbdc_23 = "braid.and"(%bbdc_21, %bbdc_22) : (i64, i64) -> i64
      "braid.setf"(%bbdc_23) {flag = "of"} : (i64) -> ()
      %bbdc_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbdc_24) {flag = "af"} : (i64) -> ()
      %bbdc_32 = "braid.zext"(%bbdc_17) {bits = 8 : i64} : (i64) -> i64
      %bbdc_33 = "braid.popcnt"(%bbdc_32) : (i64) -> i64
      %bbdc_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbdc_35 = "braid.and"(%bbdc_33, %bbdc_34) : (i64, i64) -> i64
      %bbdc_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbdc_37 = "braid.eq"(%bbdc_35, %bbdc_36) : (i64, i64) -> i64
      "braid.setf"(%bbdc_37) {flag = "pf"} : (i64) -> ()
      %bbdc_38 = "braid.eq"(%bbdc_17, %bbdc_36) : (i64, i64) -> i64
      "braid.setf"(%bbdc_38) {flag = "zf"} : (i64) -> ()
      %bbdc_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbdc_40 = "braid.and"(%bbdc_17, %bbdc_39) : (i64, i64) -> i64
      "braid.setf"(%bbdc_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbdc_17) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bbdf] : () -> ()
    ^bbdf:  // 0x40111f
      %bbdf_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbdf_0 = "braid.zext"(%bbdf_1) {bits = 32 : i64} : (i64) -> i64
      %bbdf_9 = "braid.get"() {reg = "r13"} : () -> i64
      %bbdf_8 = "braid.zext"(%bbdf_9) {bits = 32 : i64} : (i64) -> i64
      %bbdf_16 = "braid.xor"(%bbdf_0, %bbdf_8) : (i64, i64) -> i64
      %bbdf_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbdf_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbdf_17) {flag = "of"} : (i64) -> ()
      %bbdf_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbdf_24) {flag = "af"} : (i64) -> ()
      %bbdf_32 = "braid.zext"(%bbdf_16) {bits = 8 : i64} : (i64) -> i64
      %bbdf_33 = "braid.popcnt"(%bbdf_32) : (i64) -> i64
      %bbdf_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbdf_35 = "braid.and"(%bbdf_33, %bbdf_34) : (i64, i64) -> i64
      %bbdf_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbdf_37 = "braid.eq"(%bbdf_35, %bbdf_36) : (i64, i64) -> i64
      "braid.setf"(%bbdf_37) {flag = "pf"} : (i64) -> ()
      %bbdf_38 = "braid.eq"(%bbdf_16, %bbdf_36) : (i64, i64) -> i64
      "braid.setf"(%bbdf_38) {flag = "zf"} : (i64) -> ()
      %bbdf_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbdf_40 = "braid.and"(%bbdf_16, %bbdf_39) : (i64, i64) -> i64
      "braid.setf"(%bbdf_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbdf_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbe2] : () -> ()
    ^bbe2:  // 0x401122
      %bbe2_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbe2_0 = "braid.zext"(%bbe2_1) {bits = 32 : i64} : (i64) -> i64
      %bbe2_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbe2_13 = "braid.shl"(%bbe2_0, %bbe2_12) : (i64, i64) -> i64
      %bbe2_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbe2_15 = "braid.lshr"(%bbe2_0, %bbe2_14) : (i64, i64) -> i64
      %bbe2_16 = "braid.or"(%bbe2_13, %bbe2_15) : (i64, i64) -> i64
      %bbe2_17 = "braid.zext"(%bbe2_16) {bits = 32 : i64} : (i64) -> i64
      %bbe2_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbe2_19 = "braid.and"(%bbe2_17, %bbe2_18) : (i64, i64) -> i64
      "braid.setf"(%bbe2_19) {flag = "cf"} : (i64) -> ()
      %bbe2_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbe2_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbe2_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbe5] : () -> ()
    ^bbe5:  // 0x401125
      %bbe5_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbe5_0 = "braid.zext"(%bbe5_1) {bits = 32 : i64} : (i64) -> i64
      %bbe5_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbe5_8 = "braid.zext"(%bbe5_9) {bits = 32 : i64} : (i64) -> i64
      %bbe5_16 = "braid.add"(%bbe5_0, %bbe5_8) : (i64, i64) -> i64
      %bbe5_17 = "braid.zext"(%bbe5_16) {bits = 32 : i64} : (i64) -> i64
      %bbe5_18 = "braid.ult"(%bbe5_17, %bbe5_0) : (i64, i64) -> i64
      "braid.setf"(%bbe5_18) {flag = "cf"} : (i64) -> ()
      %bbe5_19 = "braid.xor"(%bbe5_0, %bbe5_17) : (i64, i64) -> i64
      %bbe5_20 = "braid.xor"(%bbe5_8, %bbe5_17) : (i64, i64) -> i64
      %bbe5_21 = "braid.and"(%bbe5_19, %bbe5_20) : (i64, i64) -> i64
      %bbe5_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbe5_23 = "braid.and"(%bbe5_21, %bbe5_22) : (i64, i64) -> i64
      "braid.setf"(%bbe5_23) {flag = "of"} : (i64) -> ()
      %bbe5_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbe5_24) {flag = "af"} : (i64) -> ()
      %bbe5_32 = "braid.zext"(%bbe5_17) {bits = 8 : i64} : (i64) -> i64
      %bbe5_33 = "braid.popcnt"(%bbe5_32) : (i64) -> i64
      %bbe5_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbe5_35 = "braid.and"(%bbe5_33, %bbe5_34) : (i64, i64) -> i64
      %bbe5_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe5_37 = "braid.eq"(%bbe5_35, %bbe5_36) : (i64, i64) -> i64
      "braid.setf"(%bbe5_37) {flag = "pf"} : (i64) -> ()
      %bbe5_38 = "braid.eq"(%bbe5_17, %bbe5_36) : (i64, i64) -> i64
      "braid.setf"(%bbe5_38) {flag = "zf"} : (i64) -> ()
      %bbe5_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbe5_40 = "braid.and"(%bbe5_17, %bbe5_39) : (i64, i64) -> i64
      "braid.setf"(%bbe5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbe5_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bbe7] : () -> ()
    ^bbe7:  // 0x401127
      %bbe7_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bbe7_0 = "braid.zext"(%bbe7_1) {bits = 32 : i64} : (i64) -> i64
      %bbe7_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbe7_8 = "braid.zext"(%bbe7_9) {bits = 32 : i64} : (i64) -> i64
      %bbe7_16 = "braid.xor"(%bbe7_0, %bbe7_8) : (i64, i64) -> i64
      %bbe7_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbe7_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbe7_17) {flag = "of"} : (i64) -> ()
      %bbe7_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbe7_24) {flag = "af"} : (i64) -> ()
      %bbe7_32 = "braid.zext"(%bbe7_16) {bits = 8 : i64} : (i64) -> i64
      %bbe7_33 = "braid.popcnt"(%bbe7_32) : (i64) -> i64
      %bbe7_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbe7_35 = "braid.and"(%bbe7_33, %bbe7_34) : (i64, i64) -> i64
      %bbe7_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe7_37 = "braid.eq"(%bbe7_35, %bbe7_36) : (i64, i64) -> i64
      "braid.setf"(%bbe7_37) {flag = "pf"} : (i64) -> ()
      %bbe7_38 = "braid.eq"(%bbe7_16, %bbe7_36) : (i64, i64) -> i64
      "braid.setf"(%bbe7_38) {flag = "zf"} : (i64) -> ()
      %bbe7_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbe7_40 = "braid.and"(%bbe7_16, %bbe7_39) : (i64, i64) -> i64
      "braid.setf"(%bbe7_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbe7_16) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bbe9] : () -> ()
    ^bbe9:  // 0x401129
      %bbe9_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bbe9_0 = "braid.zext"(%bbe9_1) {bits = 32 : i64} : (i64) -> i64
      %bbe9_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bbe9_13 = "braid.shl"(%bbe9_0, %bbe9_12) : (i64, i64) -> i64
      %bbe9_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bbe9_15 = "braid.lshr"(%bbe9_0, %bbe9_14) : (i64, i64) -> i64
      %bbe9_16 = "braid.or"(%bbe9_13, %bbe9_15) : (i64, i64) -> i64
      %bbe9_17 = "braid.zext"(%bbe9_16) {bits = 32 : i64} : (i64) -> i64
      %bbe9_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbe9_19 = "braid.and"(%bbe9_17, %bbe9_18) : (i64, i64) -> i64
      "braid.setf"(%bbe9_19) {flag = "cf"} : (i64) -> ()
      %bbe9_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbe9_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbe9_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bbec] : () -> ()
    ^bbec:  // 0x40112c
      %bbec_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bbec_0 = "braid.zext"(%bbec_1) {bits = 32 : i64} : (i64) -> i64
      %bbec_9 = "braid.get"() {reg = "r13"} : () -> i64
      %bbec_8 = "braid.zext"(%bbec_9) {bits = 32 : i64} : (i64) -> i64
      %bbec_16 = "braid.add"(%bbec_0, %bbec_8) : (i64, i64) -> i64
      %bbec_17 = "braid.zext"(%bbec_16) {bits = 32 : i64} : (i64) -> i64
      %bbec_18 = "braid.ult"(%bbec_17, %bbec_0) : (i64, i64) -> i64
      "braid.setf"(%bbec_18) {flag = "cf"} : (i64) -> ()
      %bbec_19 = "braid.xor"(%bbec_0, %bbec_17) : (i64, i64) -> i64
      %bbec_20 = "braid.xor"(%bbec_8, %bbec_17) : (i64, i64) -> i64
      %bbec_21 = "braid.and"(%bbec_19, %bbec_20) : (i64, i64) -> i64
      %bbec_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbec_23 = "braid.and"(%bbec_21, %bbec_22) : (i64, i64) -> i64
      "braid.setf"(%bbec_23) {flag = "of"} : (i64) -> ()
      %bbec_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbec_24) {flag = "af"} : (i64) -> ()
      %bbec_32 = "braid.zext"(%bbec_17) {bits = 8 : i64} : (i64) -> i64
      %bbec_33 = "braid.popcnt"(%bbec_32) : (i64) -> i64
      %bbec_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbec_35 = "braid.and"(%bbec_33, %bbec_34) : (i64, i64) -> i64
      %bbec_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbec_37 = "braid.eq"(%bbec_35, %bbec_36) : (i64, i64) -> i64
      "braid.setf"(%bbec_37) {flag = "pf"} : (i64) -> ()
      %bbec_38 = "braid.eq"(%bbec_17, %bbec_36) : (i64, i64) -> i64
      "braid.setf"(%bbec_38) {flag = "zf"} : (i64) -> ()
      %bbec_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbec_40 = "braid.and"(%bbec_17, %bbec_39) : (i64, i64) -> i64
      "braid.setf"(%bbec_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbec_17) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bbef] : () -> ()
    ^bbef:  // 0x40112f
      %bbef_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbef_0 = "braid.zext"(%bbef_1) {bits = 32 : i64} : (i64) -> i64
      %bbef_9 = "braid.get"() {reg = "r13"} : () -> i64
      %bbef_8 = "braid.zext"(%bbef_9) {bits = 32 : i64} : (i64) -> i64
      %bbef_16 = "braid.xor"(%bbef_0, %bbef_8) : (i64, i64) -> i64
      %bbef_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbef_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbef_17) {flag = "of"} : (i64) -> ()
      %bbef_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbef_24) {flag = "af"} : (i64) -> ()
      %bbef_32 = "braid.zext"(%bbef_16) {bits = 8 : i64} : (i64) -> i64
      %bbef_33 = "braid.popcnt"(%bbef_32) : (i64) -> i64
      %bbef_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbef_35 = "braid.and"(%bbef_33, %bbef_34) : (i64, i64) -> i64
      %bbef_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbef_37 = "braid.eq"(%bbef_35, %bbef_36) : (i64, i64) -> i64
      "braid.setf"(%bbef_37) {flag = "pf"} : (i64) -> ()
      %bbef_38 = "braid.eq"(%bbef_16, %bbef_36) : (i64, i64) -> i64
      "braid.setf"(%bbef_38) {flag = "zf"} : (i64) -> ()
      %bbef_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbef_40 = "braid.and"(%bbef_16, %bbef_39) : (i64, i64) -> i64
      "braid.setf"(%bbef_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbef_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbf2] : () -> ()
    ^bbf2:  // 0x401132
      %bbf2_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbf2_0 = "braid.zext"(%bbf2_1) {bits = 32 : i64} : (i64) -> i64
      %bbf2_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbf2_13 = "braid.shl"(%bbf2_0, %bbf2_12) : (i64, i64) -> i64
      %bbf2_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbf2_15 = "braid.lshr"(%bbf2_0, %bbf2_14) : (i64, i64) -> i64
      %bbf2_16 = "braid.or"(%bbf2_13, %bbf2_15) : (i64, i64) -> i64
      %bbf2_17 = "braid.zext"(%bbf2_16) {bits = 32 : i64} : (i64) -> i64
      %bbf2_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf2_19 = "braid.and"(%bbf2_17, %bbf2_18) : (i64, i64) -> i64
      "braid.setf"(%bbf2_19) {flag = "cf"} : (i64) -> ()
      %bbf2_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbf2_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbf2_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbf5] : () -> ()
    ^bbf5:  // 0x401135
      %bbf5_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbf5_0 = "braid.zext"(%bbf5_1) {bits = 32 : i64} : (i64) -> i64
      %bbf5_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbf5_8 = "braid.zext"(%bbf5_9) {bits = 32 : i64} : (i64) -> i64
      %bbf5_16 = "braid.add"(%bbf5_0, %bbf5_8) : (i64, i64) -> i64
      %bbf5_17 = "braid.zext"(%bbf5_16) {bits = 32 : i64} : (i64) -> i64
      %bbf5_18 = "braid.ult"(%bbf5_17, %bbf5_0) : (i64, i64) -> i64
      "braid.setf"(%bbf5_18) {flag = "cf"} : (i64) -> ()
      %bbf5_19 = "braid.xor"(%bbf5_0, %bbf5_17) : (i64, i64) -> i64
      %bbf5_20 = "braid.xor"(%bbf5_8, %bbf5_17) : (i64, i64) -> i64
      %bbf5_21 = "braid.and"(%bbf5_19, %bbf5_20) : (i64, i64) -> i64
      %bbf5_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbf5_23 = "braid.and"(%bbf5_21, %bbf5_22) : (i64, i64) -> i64
      "braid.setf"(%bbf5_23) {flag = "of"} : (i64) -> ()
      %bbf5_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbf5_24) {flag = "af"} : (i64) -> ()
      %bbf5_32 = "braid.zext"(%bbf5_17) {bits = 8 : i64} : (i64) -> i64
      %bbf5_33 = "braid.popcnt"(%bbf5_32) : (i64) -> i64
      %bbf5_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf5_35 = "braid.and"(%bbf5_33, %bbf5_34) : (i64, i64) -> i64
      %bbf5_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf5_37 = "braid.eq"(%bbf5_35, %bbf5_36) : (i64, i64) -> i64
      "braid.setf"(%bbf5_37) {flag = "pf"} : (i64) -> ()
      %bbf5_38 = "braid.eq"(%bbf5_17, %bbf5_36) : (i64, i64) -> i64
      "braid.setf"(%bbf5_38) {flag = "zf"} : (i64) -> ()
      %bbf5_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbf5_40 = "braid.and"(%bbf5_17, %bbf5_39) : (i64, i64) -> i64
      "braid.setf"(%bbf5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbf5_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bbf7] : () -> ()
    ^bbf7:  // 0x401137
      %bbf7_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bbf7_0 = "braid.zext"(%bbf7_1) {bits = 32 : i64} : (i64) -> i64
      %bbf7_9 = "braid.get"() {reg = "rsi"} : () -> i64
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
      "braid.set"(%bbf7_16) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bbf9] : () -> ()
    ^bbf9:  // 0x401139
      %bbf9_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bbf9_0 = "braid.zext"(%bbf9_1) {bits = 32 : i64} : (i64) -> i64
      %bbf9_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbf9_13 = "braid.shl"(%bbf9_0, %bbf9_12) : (i64, i64) -> i64
      %bbf9_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbf9_15 = "braid.lshr"(%bbf9_0, %bbf9_14) : (i64, i64) -> i64
      %bbf9_16 = "braid.or"(%bbf9_13, %bbf9_15) : (i64, i64) -> i64
      %bbf9_17 = "braid.zext"(%bbf9_16) {bits = 32 : i64} : (i64) -> i64
      %bbf9_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf9_19 = "braid.and"(%bbf9_17, %bbf9_18) : (i64, i64) -> i64
      "braid.setf"(%bbf9_19) {flag = "cf"} : (i64) -> ()
      %bbf9_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbf9_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbf9_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bbfc] : () -> ()
    ^bbfc:  // 0x40113c
      %bbfc_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bbfc_0 = "braid.zext"(%bbfc_1) {bits = 32 : i64} : (i64) -> i64
      %bbfc_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bbfc_8 = "braid.zext"(%bbfc_9) {bits = 32 : i64} : (i64) -> i64
      %bbfc_16 = "braid.add"(%bbfc_0, %bbfc_8) : (i64, i64) -> i64
      %bbfc_17 = "braid.zext"(%bbfc_16) {bits = 32 : i64} : (i64) -> i64
      %bbfc_18 = "braid.ult"(%bbfc_17, %bbfc_0) : (i64, i64) -> i64
      "braid.setf"(%bbfc_18) {flag = "cf"} : (i64) -> ()
      %bbfc_19 = "braid.xor"(%bbfc_0, %bbfc_17) : (i64, i64) -> i64
      %bbfc_20 = "braid.xor"(%bbfc_8, %bbfc_17) : (i64, i64) -> i64
      %bbfc_21 = "braid.and"(%bbfc_19, %bbfc_20) : (i64, i64) -> i64
      %bbfc_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbfc_23 = "braid.and"(%bbfc_21, %bbfc_22) : (i64, i64) -> i64
      "braid.setf"(%bbfc_23) {flag = "of"} : (i64) -> ()
      %bbfc_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbfc_24) {flag = "af"} : (i64) -> ()
      %bbfc_32 = "braid.zext"(%bbfc_17) {bits = 8 : i64} : (i64) -> i64
      %bbfc_33 = "braid.popcnt"(%bbfc_32) : (i64) -> i64
      %bbfc_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbfc_35 = "braid.and"(%bbfc_33, %bbfc_34) : (i64, i64) -> i64
      %bbfc_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbfc_37 = "braid.eq"(%bbfc_35, %bbfc_36) : (i64, i64) -> i64
      "braid.setf"(%bbfc_37) {flag = "pf"} : (i64) -> ()
      %bbfc_38 = "braid.eq"(%bbfc_17, %bbfc_36) : (i64, i64) -> i64
      "braid.setf"(%bbfc_38) {flag = "zf"} : (i64) -> ()
      %bbfc_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbfc_40 = "braid.and"(%bbfc_17, %bbfc_39) : (i64, i64) -> i64
      "braid.setf"(%bbfc_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbfc_17) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bbff] : () -> ()
    ^bbff:  // 0x40113f
      %bbff_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbff_0 = "braid.zext"(%bbff_1) {bits = 32 : i64} : (i64) -> i64
      %bbff_9 = "braid.get"() {reg = "r10"} : () -> i64
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
      "braid.set"(%bbff_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb102] : () -> ()
    ^bb102:  // 0x401142
      %bb102_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb102_0 = "braid.zext"(%bb102_1) {bits = 32 : i64} : (i64) -> i64
      %bb102_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb102_13 = "braid.shl"(%bb102_0, %bb102_12) : (i64, i64) -> i64
      %bb102_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb102_15 = "braid.lshr"(%bb102_0, %bb102_14) : (i64, i64) -> i64
      %bb102_16 = "braid.or"(%bb102_13, %bb102_15) : (i64, i64) -> i64
      %bb102_17 = "braid.zext"(%bb102_16) {bits = 32 : i64} : (i64) -> i64
      %bb102_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb102_19 = "braid.and"(%bb102_17, %bb102_18) : (i64, i64) -> i64
      "braid.setf"(%bb102_19) {flag = "cf"} : (i64) -> ()
      %bb102_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb102_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb102_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb105] : () -> ()
    ^bb105:  // 0x401145
      %bb105_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb105_0 = "braid.zext"(%bb105_1) {bits = 32 : i64} : (i64) -> i64
      %bb105_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb105_8 = "braid.zext"(%bb105_9) {bits = 32 : i64} : (i64) -> i64
      %bb105_16 = "braid.add"(%bb105_0, %bb105_8) : (i64, i64) -> i64
      %bb105_17 = "braid.zext"(%bb105_16) {bits = 32 : i64} : (i64) -> i64
      %bb105_18 = "braid.ult"(%bb105_17, %bb105_0) : (i64, i64) -> i64
      "braid.setf"(%bb105_18) {flag = "cf"} : (i64) -> ()
      %bb105_19 = "braid.xor"(%bb105_0, %bb105_17) : (i64, i64) -> i64
      %bb105_20 = "braid.xor"(%bb105_8, %bb105_17) : (i64, i64) -> i64
      %bb105_21 = "braid.and"(%bb105_19, %bb105_20) : (i64, i64) -> i64
      %bb105_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb105_23 = "braid.and"(%bb105_21, %bb105_22) : (i64, i64) -> i64
      "braid.setf"(%bb105_23) {flag = "of"} : (i64) -> ()
      %bb105_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb105_24) {flag = "af"} : (i64) -> ()
      %bb105_32 = "braid.zext"(%bb105_17) {bits = 8 : i64} : (i64) -> i64
      %bb105_33 = "braid.popcnt"(%bb105_32) : (i64) -> i64
      %bb105_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb105_35 = "braid.and"(%bb105_33, %bb105_34) : (i64, i64) -> i64
      %bb105_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb105_37 = "braid.eq"(%bb105_35, %bb105_36) : (i64, i64) -> i64
      "braid.setf"(%bb105_37) {flag = "pf"} : (i64) -> ()
      %bb105_38 = "braid.eq"(%bb105_17, %bb105_36) : (i64, i64) -> i64
      "braid.setf"(%bb105_38) {flag = "zf"} : (i64) -> ()
      %bb105_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb105_40 = "braid.and"(%bb105_17, %bb105_39) : (i64, i64) -> i64
      "braid.setf"(%bb105_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb105_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x401148
      %bb108_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb108_0 = "braid.zext"(%bb108_1) {bits = 32 : i64} : (i64) -> i64
      %bb108_9 = "braid.get"() {reg = "r11"} : () -> i64
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
    ^bb10b:  // 0x40114b
      %bb10b_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb10b_0 = "braid.zext"(%bb10b_1) {bits = 32 : i64} : (i64) -> i64
      %bb10b_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb10b_13 = "braid.shl"(%bb10b_0, %bb10b_12) : (i64, i64) -> i64
      %bb10b_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb10b_15 = "braid.lshr"(%bb10b_0, %bb10b_14) : (i64, i64) -> i64
      %bb10b_16 = "braid.or"(%bb10b_13, %bb10b_15) : (i64, i64) -> i64
      %bb10b_17 = "braid.zext"(%bb10b_16) {bits = 32 : i64} : (i64) -> i64
      %bb10b_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10b_19 = "braid.and"(%bb10b_17, %bb10b_18) : (i64, i64) -> i64
      "braid.setf"(%bb10b_19) {flag = "cf"} : (i64) -> ()
      %bb10b_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb10b_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb10b_17) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb10f] : () -> ()
    ^bb10f:  // 0x40114f
      %bb10f_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb10f_0 = "braid.zext"(%bb10f_1) {bits = 32 : i64} : (i64) -> i64
      %bb10f_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb10f_8 = "braid.zext"(%bb10f_9) {bits = 32 : i64} : (i64) -> i64
      %bb10f_16 = "braid.add"(%bb10f_0, %bb10f_8) : (i64, i64) -> i64
      %bb10f_17 = "braid.zext"(%bb10f_16) {bits = 32 : i64} : (i64) -> i64
      %bb10f_18 = "braid.ult"(%bb10f_17, %bb10f_0) : (i64, i64) -> i64
      "braid.setf"(%bb10f_18) {flag = "cf"} : (i64) -> ()
      %bb10f_19 = "braid.xor"(%bb10f_0, %bb10f_17) : (i64, i64) -> i64
      %bb10f_20 = "braid.xor"(%bb10f_8, %bb10f_17) : (i64, i64) -> i64
      %bb10f_21 = "braid.and"(%bb10f_19, %bb10f_20) : (i64, i64) -> i64
      %bb10f_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb10f_23 = "braid.and"(%bb10f_21, %bb10f_22) : (i64, i64) -> i64
      "braid.setf"(%bb10f_23) {flag = "of"} : (i64) -> ()
      %bb10f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb10f_24) {flag = "af"} : (i64) -> ()
      %bb10f_32 = "braid.zext"(%bb10f_17) {bits = 8 : i64} : (i64) -> i64
      %bb10f_33 = "braid.popcnt"(%bb10f_32) : (i64) -> i64
      %bb10f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10f_35 = "braid.and"(%bb10f_33, %bb10f_34) : (i64, i64) -> i64
      %bb10f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10f_37 = "braid.eq"(%bb10f_35, %bb10f_36) : (i64, i64) -> i64
      "braid.setf"(%bb10f_37) {flag = "pf"} : (i64) -> ()
      %bb10f_38 = "braid.eq"(%bb10f_17, %bb10f_36) : (i64, i64) -> i64
      "braid.setf"(%bb10f_38) {flag = "zf"} : (i64) -> ()
      %bb10f_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb10f_40 = "braid.and"(%bb10f_17, %bb10f_39) : (i64, i64) -> i64
      "braid.setf"(%bb10f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb10f_17) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb112] : () -> ()
    ^bb112:  // 0x401152
      %bb112_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb112_0 = "braid.zext"(%bb112_1) {bits = 32 : i64} : (i64) -> i64
      %bb112_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb112_8 = "braid.zext"(%bb112_9) {bits = 32 : i64} : (i64) -> i64
      %bb112_16 = "braid.xor"(%bb112_0, %bb112_8) : (i64, i64) -> i64
      %bb112_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb112_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb112_17) {flag = "of"} : (i64) -> ()
      %bb112_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb112_24) {flag = "af"} : (i64) -> ()
      %bb112_32 = "braid.zext"(%bb112_16) {bits = 8 : i64} : (i64) -> i64
      %bb112_33 = "braid.popcnt"(%bb112_32) : (i64) -> i64
      %bb112_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb112_35 = "braid.and"(%bb112_33, %bb112_34) : (i64, i64) -> i64
      %bb112_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb112_37 = "braid.eq"(%bb112_35, %bb112_36) : (i64, i64) -> i64
      "braid.setf"(%bb112_37) {flag = "pf"} : (i64) -> ()
      %bb112_38 = "braid.eq"(%bb112_16, %bb112_36) : (i64, i64) -> i64
      "braid.setf"(%bb112_38) {flag = "zf"} : (i64) -> ()
      %bb112_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb112_40 = "braid.and"(%bb112_16, %bb112_39) : (i64, i64) -> i64
      "braid.setf"(%bb112_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb112_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb115] : () -> ()
    ^bb115:  // 0x401155
      %bb115_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb115_0 = "braid.zext"(%bb115_1) {bits = 32 : i64} : (i64) -> i64
      %bb115_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb115_13 = "braid.shl"(%bb115_0, %bb115_12) : (i64, i64) -> i64
      %bb115_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb115_15 = "braid.lshr"(%bb115_0, %bb115_14) : (i64, i64) -> i64
      %bb115_16 = "braid.or"(%bb115_13, %bb115_15) : (i64, i64) -> i64
      %bb115_17 = "braid.zext"(%bb115_16) {bits = 32 : i64} : (i64) -> i64
      %bb115_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb115_19 = "braid.and"(%bb115_17, %bb115_18) : (i64, i64) -> i64
      "braid.setf"(%bb115_19) {flag = "cf"} : (i64) -> ()
      %bb115_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb115_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb115_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x401158
      %bb118_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb118_0 = "braid.zext"(%bb118_1) {bits = 32 : i64} : (i64) -> i64
      %bb118_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb118_8 = "braid.zext"(%bb118_9) {bits = 32 : i64} : (i64) -> i64
      %bb118_16 = "braid.add"(%bb118_0, %bb118_8) : (i64, i64) -> i64
      %bb118_17 = "braid.zext"(%bb118_16) {bits = 32 : i64} : (i64) -> i64
      %bb118_18 = "braid.ult"(%bb118_17, %bb118_0) : (i64, i64) -> i64
      "braid.setf"(%bb118_18) {flag = "cf"} : (i64) -> ()
      %bb118_19 = "braid.xor"(%bb118_0, %bb118_17) : (i64, i64) -> i64
      %bb118_20 = "braid.xor"(%bb118_8, %bb118_17) : (i64, i64) -> i64
      %bb118_21 = "braid.and"(%bb118_19, %bb118_20) : (i64, i64) -> i64
      %bb118_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb118_23 = "braid.and"(%bb118_21, %bb118_22) : (i64, i64) -> i64
      "braid.setf"(%bb118_23) {flag = "of"} : (i64) -> ()
      %bb118_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb118_24) {flag = "af"} : (i64) -> ()
      %bb118_32 = "braid.zext"(%bb118_17) {bits = 8 : i64} : (i64) -> i64
      %bb118_33 = "braid.popcnt"(%bb118_32) : (i64) -> i64
      %bb118_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb118_35 = "braid.and"(%bb118_33, %bb118_34) : (i64, i64) -> i64
      %bb118_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb118_37 = "braid.eq"(%bb118_35, %bb118_36) : (i64, i64) -> i64
      "braid.setf"(%bb118_37) {flag = "pf"} : (i64) -> ()
      %bb118_38 = "braid.eq"(%bb118_17, %bb118_36) : (i64, i64) -> i64
      "braid.setf"(%bb118_38) {flag = "zf"} : (i64) -> ()
      %bb118_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb118_40 = "braid.and"(%bb118_17, %bb118_39) : (i64, i64) -> i64
      "braid.setf"(%bb118_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb118_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb11b] : () -> ()
    ^bb11b:  // 0x40115b
      %bb11b_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb11b_0 = "braid.zext"(%bb11b_1) {bits = 32 : i64} : (i64) -> i64
      %bb11b_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb11b_10 = "braid.const"() {value = -24 : i64} : () -> i64
      %bb11b_8 = "braid.add"(%bb11b_9, %bb11b_10) : (i64, i64) -> i64
      "braid.store"(%bb11b_8, %bb11b_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x401160
      %bb120_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb120_0 = "braid.zext"(%bb120_1) {bits = 32 : i64} : (i64) -> i64
      %bb120_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb120_8 = "braid.zext"(%bb120_9) {bits = 32 : i64} : (i64) -> i64
      %bb120_16 = "braid.xor"(%bb120_0, %bb120_8) : (i64, i64) -> i64
      %bb120_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb120_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb120_17) {flag = "of"} : (i64) -> ()
      %bb120_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb120_24) {flag = "af"} : (i64) -> ()
      %bb120_32 = "braid.zext"(%bb120_16) {bits = 8 : i64} : (i64) -> i64
      %bb120_33 = "braid.popcnt"(%bb120_32) : (i64) -> i64
      %bb120_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb120_35 = "braid.and"(%bb120_33, %bb120_34) : (i64, i64) -> i64
      %bb120_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb120_37 = "braid.eq"(%bb120_35, %bb120_36) : (i64, i64) -> i64
      "braid.setf"(%bb120_37) {flag = "pf"} : (i64) -> ()
      %bb120_38 = "braid.eq"(%bb120_16, %bb120_36) : (i64, i64) -> i64
      "braid.setf"(%bb120_38) {flag = "zf"} : (i64) -> ()
      %bb120_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb120_40 = "braid.and"(%bb120_16, %bb120_39) : (i64, i64) -> i64
      "braid.setf"(%bb120_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb120_16) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb123] : () -> ()
    ^bb123:  // 0x401163
      %bb123_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb123_3 = "braid.const"() {value = -28 : i64} : () -> i64
      %bb123_1 = "braid.add"(%bb123_2, %bb123_3) : (i64, i64) -> i64
      %bb123_0 = "braid.load"(%bb123_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb123_0) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb128] : () -> ()
    ^bb128:  // 0x401168
      %bb128_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb128_0 = "braid.zext"(%bb128_1) {bits = 32 : i64} : (i64) -> i64
      %bb128_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb128_13 = "braid.shl"(%bb128_0, %bb128_12) : (i64, i64) -> i64
      %bb128_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb128_15 = "braid.lshr"(%bb128_0, %bb128_14) : (i64, i64) -> i64
      %bb128_16 = "braid.or"(%bb128_13, %bb128_15) : (i64, i64) -> i64
      %bb128_17 = "braid.zext"(%bb128_16) {bits = 32 : i64} : (i64) -> i64
      %bb128_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb128_19 = "braid.and"(%bb128_17, %bb128_18) : (i64, i64) -> i64
      "braid.setf"(%bb128_19) {flag = "cf"} : (i64) -> ()
      %bb128_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb128_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb128_17) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb12c] : () -> ()
    ^bb12c:  // 0x40116c
      %bb12c_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb12c_0 = "braid.zext"(%bb12c_1) {bits = 32 : i64} : (i64) -> i64
      %bb12c_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb12c_8 = "braid.zext"(%bb12c_9) {bits = 32 : i64} : (i64) -> i64
      %bb12c_16 = "braid.add"(%bb12c_0, %bb12c_8) : (i64, i64) -> i64
      %bb12c_17 = "braid.zext"(%bb12c_16) {bits = 32 : i64} : (i64) -> i64
      %bb12c_18 = "braid.ult"(%bb12c_17, %bb12c_0) : (i64, i64) -> i64
      "braid.setf"(%bb12c_18) {flag = "cf"} : (i64) -> ()
      %bb12c_19 = "braid.xor"(%bb12c_0, %bb12c_17) : (i64, i64) -> i64
      %bb12c_20 = "braid.xor"(%bb12c_8, %bb12c_17) : (i64, i64) -> i64
      %bb12c_21 = "braid.and"(%bb12c_19, %bb12c_20) : (i64, i64) -> i64
      %bb12c_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb12c_23 = "braid.and"(%bb12c_21, %bb12c_22) : (i64, i64) -> i64
      "braid.setf"(%bb12c_23) {flag = "of"} : (i64) -> ()
      %bb12c_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb12c_24) {flag = "af"} : (i64) -> ()
      %bb12c_32 = "braid.zext"(%bb12c_17) {bits = 8 : i64} : (i64) -> i64
      %bb12c_33 = "braid.popcnt"(%bb12c_32) : (i64) -> i64
      %bb12c_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb12c_35 = "braid.and"(%bb12c_33, %bb12c_34) : (i64, i64) -> i64
      %bb12c_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12c_37 = "braid.eq"(%bb12c_35, %bb12c_36) : (i64, i64) -> i64
      "braid.setf"(%bb12c_37) {flag = "pf"} : (i64) -> ()
      %bb12c_38 = "braid.eq"(%bb12c_17, %bb12c_36) : (i64, i64) -> i64
      "braid.setf"(%bb12c_38) {flag = "zf"} : (i64) -> ()
      %bb12c_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb12c_40 = "braid.and"(%bb12c_17, %bb12c_39) : (i64, i64) -> i64
      "braid.setf"(%bb12c_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb12c_17) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb12f] : () -> ()
    ^bb12f:  // 0x40116f
      %bb12f_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb12f_0 = "braid.zext"(%bb12f_1) {bits = 32 : i64} : (i64) -> i64
      %bb12f_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb12f_8 = "braid.zext"(%bb12f_9) {bits = 32 : i64} : (i64) -> i64
      %bb12f_16 = "braid.xor"(%bb12f_0, %bb12f_8) : (i64, i64) -> i64
      %bb12f_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb12f_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb12f_17) {flag = "of"} : (i64) -> ()
      %bb12f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb12f_24) {flag = "af"} : (i64) -> ()
      %bb12f_32 = "braid.zext"(%bb12f_16) {bits = 8 : i64} : (i64) -> i64
      %bb12f_33 = "braid.popcnt"(%bb12f_32) : (i64) -> i64
      %bb12f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb12f_35 = "braid.and"(%bb12f_33, %bb12f_34) : (i64, i64) -> i64
      %bb12f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12f_37 = "braid.eq"(%bb12f_35, %bb12f_36) : (i64, i64) -> i64
      "braid.setf"(%bb12f_37) {flag = "pf"} : (i64) -> ()
      %bb12f_38 = "braid.eq"(%bb12f_16, %bb12f_36) : (i64, i64) -> i64
      "braid.setf"(%bb12f_38) {flag = "zf"} : (i64) -> ()
      %bb12f_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb12f_40 = "braid.and"(%bb12f_16, %bb12f_39) : (i64, i64) -> i64
      "braid.setf"(%bb12f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb12f_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb132] : () -> ()
    ^bb132:  // 0x401172
      %bb132_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb132_0 = "braid.zext"(%bb132_1) {bits = 32 : i64} : (i64) -> i64
      %bb132_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb132_13 = "braid.shl"(%bb132_0, %bb132_12) : (i64, i64) -> i64
      %bb132_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb132_15 = "braid.lshr"(%bb132_0, %bb132_14) : (i64, i64) -> i64
      %bb132_16 = "braid.or"(%bb132_13, %bb132_15) : (i64, i64) -> i64
      %bb132_17 = "braid.zext"(%bb132_16) {bits = 32 : i64} : (i64) -> i64
      %bb132_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb132_19 = "braid.and"(%bb132_17, %bb132_18) : (i64, i64) -> i64
      "braid.setf"(%bb132_19) {flag = "cf"} : (i64) -> ()
      %bb132_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb132_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb132_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb136] : () -> ()
    ^bb136:  // 0x401176
      %bb136_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb136_0 = "braid.zext"(%bb136_1) {bits = 32 : i64} : (i64) -> i64
      %bb136_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb136_8 = "braid.zext"(%bb136_9) {bits = 32 : i64} : (i64) -> i64
      %bb136_16 = "braid.add"(%bb136_0, %bb136_8) : (i64, i64) -> i64
      %bb136_17 = "braid.zext"(%bb136_16) {bits = 32 : i64} : (i64) -> i64
      %bb136_18 = "braid.ult"(%bb136_17, %bb136_0) : (i64, i64) -> i64
      "braid.setf"(%bb136_18) {flag = "cf"} : (i64) -> ()
      %bb136_19 = "braid.xor"(%bb136_0, %bb136_17) : (i64, i64) -> i64
      %bb136_20 = "braid.xor"(%bb136_8, %bb136_17) : (i64, i64) -> i64
      %bb136_21 = "braid.and"(%bb136_19, %bb136_20) : (i64, i64) -> i64
      %bb136_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb136_23 = "braid.and"(%bb136_21, %bb136_22) : (i64, i64) -> i64
      "braid.setf"(%bb136_23) {flag = "of"} : (i64) -> ()
      %bb136_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb136_24) {flag = "af"} : (i64) -> ()
      %bb136_32 = "braid.zext"(%bb136_17) {bits = 8 : i64} : (i64) -> i64
      %bb136_33 = "braid.popcnt"(%bb136_32) : (i64) -> i64
      %bb136_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb136_35 = "braid.and"(%bb136_33, %bb136_34) : (i64, i64) -> i64
      %bb136_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb136_37 = "braid.eq"(%bb136_35, %bb136_36) : (i64, i64) -> i64
      "braid.setf"(%bb136_37) {flag = "pf"} : (i64) -> ()
      %bb136_38 = "braid.eq"(%bb136_17, %bb136_36) : (i64, i64) -> i64
      "braid.setf"(%bb136_38) {flag = "zf"} : (i64) -> ()
      %bb136_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb136_40 = "braid.and"(%bb136_17, %bb136_39) : (i64, i64) -> i64
      "braid.setf"(%bb136_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb136_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb139] : () -> ()
    ^bb139:  // 0x401179
      %bb139_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb139_0 = "braid.zext"(%bb139_1) {bits = 32 : i64} : (i64) -> i64
      %bb139_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb139_8 = "braid.zext"(%bb139_9) {bits = 32 : i64} : (i64) -> i64
      %bb139_16 = "braid.xor"(%bb139_0, %bb139_8) : (i64, i64) -> i64
      %bb139_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb139_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb139_17) {flag = "of"} : (i64) -> ()
      %bb139_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb139_24) {flag = "af"} : (i64) -> ()
      %bb139_32 = "braid.zext"(%bb139_16) {bits = 8 : i64} : (i64) -> i64
      %bb139_33 = "braid.popcnt"(%bb139_32) : (i64) -> i64
      %bb139_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb139_35 = "braid.and"(%bb139_33, %bb139_34) : (i64, i64) -> i64
      %bb139_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb139_37 = "braid.eq"(%bb139_35, %bb139_36) : (i64, i64) -> i64
      "braid.setf"(%bb139_37) {flag = "pf"} : (i64) -> ()
      %bb139_38 = "braid.eq"(%bb139_16, %bb139_36) : (i64, i64) -> i64
      "braid.setf"(%bb139_38) {flag = "zf"} : (i64) -> ()
      %bb139_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb139_40 = "braid.and"(%bb139_16, %bb139_39) : (i64, i64) -> i64
      "braid.setf"(%bb139_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb139_16) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb13c] : () -> ()
    ^bb13c:  // 0x40117c
      %bb13c_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb13c_0 = "braid.zext"(%bb13c_1) {bits = 32 : i64} : (i64) -> i64
      %bb13c_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb13c_13 = "braid.shl"(%bb13c_0, %bb13c_12) : (i64, i64) -> i64
      %bb13c_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb13c_15 = "braid.lshr"(%bb13c_0, %bb13c_14) : (i64, i64) -> i64
      %bb13c_16 = "braid.or"(%bb13c_13, %bb13c_15) : (i64, i64) -> i64
      %bb13c_17 = "braid.zext"(%bb13c_16) {bits = 32 : i64} : (i64) -> i64
      %bb13c_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb13c_19 = "braid.and"(%bb13c_17, %bb13c_18) : (i64, i64) -> i64
      "braid.setf"(%bb13c_19) {flag = "cf"} : (i64) -> ()
      %bb13c_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb13c_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb13c_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb140] : () -> ()
    ^bb140:  // 0x401180
      %bb140_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb140_0 = "braid.zext"(%bb140_1) {bits = 32 : i64} : (i64) -> i64
      %bb140_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb140_8 = "braid.zext"(%bb140_9) {bits = 32 : i64} : (i64) -> i64
      %bb140_16 = "braid.add"(%bb140_0, %bb140_8) : (i64, i64) -> i64
      %bb140_17 = "braid.zext"(%bb140_16) {bits = 32 : i64} : (i64) -> i64
      %bb140_18 = "braid.ult"(%bb140_17, %bb140_0) : (i64, i64) -> i64
      "braid.setf"(%bb140_18) {flag = "cf"} : (i64) -> ()
      %bb140_19 = "braid.xor"(%bb140_0, %bb140_17) : (i64, i64) -> i64
      %bb140_20 = "braid.xor"(%bb140_8, %bb140_17) : (i64, i64) -> i64
      %bb140_21 = "braid.and"(%bb140_19, %bb140_20) : (i64, i64) -> i64
      %bb140_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb140_23 = "braid.and"(%bb140_21, %bb140_22) : (i64, i64) -> i64
      "braid.setf"(%bb140_23) {flag = "of"} : (i64) -> ()
      %bb140_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb140_24) {flag = "af"} : (i64) -> ()
      %bb140_32 = "braid.zext"(%bb140_17) {bits = 8 : i64} : (i64) -> i64
      %bb140_33 = "braid.popcnt"(%bb140_32) : (i64) -> i64
      %bb140_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb140_35 = "braid.and"(%bb140_33, %bb140_34) : (i64, i64) -> i64
      %bb140_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb140_37 = "braid.eq"(%bb140_35, %bb140_36) : (i64, i64) -> i64
      "braid.setf"(%bb140_37) {flag = "pf"} : (i64) -> ()
      %bb140_38 = "braid.eq"(%bb140_17, %bb140_36) : (i64, i64) -> i64
      "braid.setf"(%bb140_38) {flag = "zf"} : (i64) -> ()
      %bb140_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb140_40 = "braid.and"(%bb140_17, %bb140_39) : (i64, i64) -> i64
      "braid.setf"(%bb140_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb140_17) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb143] : () -> ()
    ^bb143:  // 0x401183
      %bb143_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb143_0 = "braid.zext"(%bb143_1) {bits = 32 : i64} : (i64) -> i64
      %bb143_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb143_8 = "braid.zext"(%bb143_9) {bits = 32 : i64} : (i64) -> i64
      %bb143_16 = "braid.xor"(%bb143_0, %bb143_8) : (i64, i64) -> i64
      %bb143_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb143_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb143_17) {flag = "of"} : (i64) -> ()
      %bb143_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb143_24) {flag = "af"} : (i64) -> ()
      %bb143_32 = "braid.zext"(%bb143_16) {bits = 8 : i64} : (i64) -> i64
      %bb143_33 = "braid.popcnt"(%bb143_32) : (i64) -> i64
      %bb143_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb143_35 = "braid.and"(%bb143_33, %bb143_34) : (i64, i64) -> i64
      %bb143_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb143_37 = "braid.eq"(%bb143_35, %bb143_36) : (i64, i64) -> i64
      "braid.setf"(%bb143_37) {flag = "pf"} : (i64) -> ()
      %bb143_38 = "braid.eq"(%bb143_16, %bb143_36) : (i64, i64) -> i64
      "braid.setf"(%bb143_38) {flag = "zf"} : (i64) -> ()
      %bb143_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb143_40 = "braid.and"(%bb143_16, %bb143_39) : (i64, i64) -> i64
      "braid.setf"(%bb143_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb143_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb146] : () -> ()
    ^bb146:  // 0x401186
      %bb146_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb146_0 = "braid.zext"(%bb146_1) {bits = 32 : i64} : (i64) -> i64
      %bb146_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb146_13 = "braid.shl"(%bb146_0, %bb146_12) : (i64, i64) -> i64
      %bb146_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb146_15 = "braid.lshr"(%bb146_0, %bb146_14) : (i64, i64) -> i64
      %bb146_16 = "braid.or"(%bb146_13, %bb146_15) : (i64, i64) -> i64
      %bb146_17 = "braid.zext"(%bb146_16) {bits = 32 : i64} : (i64) -> i64
      %bb146_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb146_19 = "braid.and"(%bb146_17, %bb146_18) : (i64, i64) -> i64
      "braid.setf"(%bb146_19) {flag = "cf"} : (i64) -> ()
      %bb146_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb146_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb146_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb14a] : () -> ()
    ^bb14a:  // 0x40118a
      %bb14a_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb14a_0 = "braid.zext"(%bb14a_1) {bits = 32 : i64} : (i64) -> i64
      %bb14a_9 = "braid.get"() {reg = "rsi"} : () -> i64
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
      "braid.set"(%bb14a_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb14d] : () -> ()
    ^bb14d:  // 0x40118d
      %bb14d_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb14d_0 = "braid.zext"(%bb14d_1) {bits = 32 : i64} : (i64) -> i64
      %bb14d_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb14d_8 = "braid.zext"(%bb14d_9) {bits = 32 : i64} : (i64) -> i64
      %bb14d_16 = "braid.xor"(%bb14d_0, %bb14d_8) : (i64, i64) -> i64
      %bb14d_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb14d_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb14d_17) {flag = "of"} : (i64) -> ()
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
      %bb14d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb14d_40 = "braid.and"(%bb14d_16, %bb14d_39) : (i64, i64) -> i64
      "braid.setf"(%bb14d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb14d_16) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb150] : () -> ()
    ^bb150:  // 0x401190
      %bb150_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb150_0 = "braid.zext"(%bb150_1) {bits = 32 : i64} : (i64) -> i64
      %bb150_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb150_13 = "braid.shl"(%bb150_0, %bb150_12) : (i64, i64) -> i64
      %bb150_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb150_15 = "braid.lshr"(%bb150_0, %bb150_14) : (i64, i64) -> i64
      %bb150_16 = "braid.or"(%bb150_13, %bb150_15) : (i64, i64) -> i64
      %bb150_17 = "braid.zext"(%bb150_16) {bits = 32 : i64} : (i64) -> i64
      %bb150_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb150_19 = "braid.and"(%bb150_17, %bb150_18) : (i64, i64) -> i64
      "braid.setf"(%bb150_19) {flag = "cf"} : (i64) -> ()
      %bb150_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb150_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb150_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb154] : () -> ()
    ^bb154:  // 0x401194
      %bb154_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb154_0 = "braid.zext"(%bb154_1) {bits = 32 : i64} : (i64) -> i64
      %bb154_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb154_8 = "braid.zext"(%bb154_9) {bits = 32 : i64} : (i64) -> i64
      %bb154_16 = "braid.add"(%bb154_0, %bb154_8) : (i64, i64) -> i64
      %bb154_17 = "braid.zext"(%bb154_16) {bits = 32 : i64} : (i64) -> i64
      %bb154_18 = "braid.ult"(%bb154_17, %bb154_0) : (i64, i64) -> i64
      "braid.setf"(%bb154_18) {flag = "cf"} : (i64) -> ()
      %bb154_19 = "braid.xor"(%bb154_0, %bb154_17) : (i64, i64) -> i64
      %bb154_20 = "braid.xor"(%bb154_8, %bb154_17) : (i64, i64) -> i64
      %bb154_21 = "braid.and"(%bb154_19, %bb154_20) : (i64, i64) -> i64
      %bb154_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb154_23 = "braid.and"(%bb154_21, %bb154_22) : (i64, i64) -> i64
      "braid.setf"(%bb154_23) {flag = "of"} : (i64) -> ()
      %bb154_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb154_24) {flag = "af"} : (i64) -> ()
      %bb154_32 = "braid.zext"(%bb154_17) {bits = 8 : i64} : (i64) -> i64
      %bb154_33 = "braid.popcnt"(%bb154_32) : (i64) -> i64
      %bb154_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb154_35 = "braid.and"(%bb154_33, %bb154_34) : (i64, i64) -> i64
      %bb154_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb154_37 = "braid.eq"(%bb154_35, %bb154_36) : (i64, i64) -> i64
      "braid.setf"(%bb154_37) {flag = "pf"} : (i64) -> ()
      %bb154_38 = "braid.eq"(%bb154_17, %bb154_36) : (i64, i64) -> i64
      "braid.setf"(%bb154_38) {flag = "zf"} : (i64) -> ()
      %bb154_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb154_40 = "braid.and"(%bb154_17, %bb154_39) : (i64, i64) -> i64
      "braid.setf"(%bb154_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb154_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb157] : () -> ()
    ^bb157:  // 0x401197
      %bb157_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb157_0 = "braid.zext"(%bb157_1) {bits = 32 : i64} : (i64) -> i64
      %bb157_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb157_8 = "braid.zext"(%bb157_9) {bits = 32 : i64} : (i64) -> i64
      %bb157_16 = "braid.xor"(%bb157_0, %bb157_8) : (i64, i64) -> i64
      %bb157_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb157_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb157_17) {flag = "of"} : (i64) -> ()
      %bb157_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb157_24) {flag = "af"} : (i64) -> ()
      %bb157_32 = "braid.zext"(%bb157_16) {bits = 8 : i64} : (i64) -> i64
      %bb157_33 = "braid.popcnt"(%bb157_32) : (i64) -> i64
      %bb157_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb157_35 = "braid.and"(%bb157_33, %bb157_34) : (i64, i64) -> i64
      %bb157_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb157_37 = "braid.eq"(%bb157_35, %bb157_36) : (i64, i64) -> i64
      "braid.setf"(%bb157_37) {flag = "pf"} : (i64) -> ()
      %bb157_38 = "braid.eq"(%bb157_16, %bb157_36) : (i64, i64) -> i64
      "braid.setf"(%bb157_38) {flag = "zf"} : (i64) -> ()
      %bb157_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb157_40 = "braid.and"(%bb157_16, %bb157_39) : (i64, i64) -> i64
      "braid.setf"(%bb157_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb157_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb15a] : () -> ()
    ^bb15a:  // 0x40119a
      %bb15a_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb15a_0 = "braid.zext"(%bb15a_1) {bits = 32 : i64} : (i64) -> i64
      %bb15a_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb15a_13 = "braid.shl"(%bb15a_0, %bb15a_12) : (i64, i64) -> i64
      %bb15a_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb15a_15 = "braid.lshr"(%bb15a_0, %bb15a_14) : (i64, i64) -> i64
      %bb15a_16 = "braid.or"(%bb15a_13, %bb15a_15) : (i64, i64) -> i64
      %bb15a_17 = "braid.zext"(%bb15a_16) {bits = 32 : i64} : (i64) -> i64
      %bb15a_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb15a_19 = "braid.and"(%bb15a_17, %bb15a_18) : (i64, i64) -> i64
      "braid.setf"(%bb15a_19) {flag = "cf"} : (i64) -> ()
      %bb15a_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb15a_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb15a_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb15d] : () -> ()
    ^bb15d:  // 0x40119d
      %bb15d_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb15d_0 = "braid.zext"(%bb15d_1) {bits = 32 : i64} : (i64) -> i64
      %bb15d_9 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb15d_8 = "braid.zext"(%bb15d_9) {bits = 32 : i64} : (i64) -> i64
      %bb15d_16 = "braid.add"(%bb15d_0, %bb15d_8) : (i64, i64) -> i64
      %bb15d_17 = "braid.zext"(%bb15d_16) {bits = 32 : i64} : (i64) -> i64
      %bb15d_18 = "braid.ult"(%bb15d_17, %bb15d_0) : (i64, i64) -> i64
      "braid.setf"(%bb15d_18) {flag = "cf"} : (i64) -> ()
      %bb15d_19 = "braid.xor"(%bb15d_0, %bb15d_17) : (i64, i64) -> i64
      %bb15d_20 = "braid.xor"(%bb15d_8, %bb15d_17) : (i64, i64) -> i64
      %bb15d_21 = "braid.and"(%bb15d_19, %bb15d_20) : (i64, i64) -> i64
      %bb15d_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb15d_23 = "braid.and"(%bb15d_21, %bb15d_22) : (i64, i64) -> i64
      "braid.setf"(%bb15d_23) {flag = "of"} : (i64) -> ()
      %bb15d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb15d_24) {flag = "af"} : (i64) -> ()
      %bb15d_32 = "braid.zext"(%bb15d_17) {bits = 8 : i64} : (i64) -> i64
      %bb15d_33 = "braid.popcnt"(%bb15d_32) : (i64) -> i64
      %bb15d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb15d_35 = "braid.and"(%bb15d_33, %bb15d_34) : (i64, i64) -> i64
      %bb15d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15d_37 = "braid.eq"(%bb15d_35, %bb15d_36) : (i64, i64) -> i64
      "braid.setf"(%bb15d_37) {flag = "pf"} : (i64) -> ()
      %bb15d_38 = "braid.eq"(%bb15d_17, %bb15d_36) : (i64, i64) -> i64
      "braid.setf"(%bb15d_38) {flag = "zf"} : (i64) -> ()
      %bb15d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb15d_40 = "braid.and"(%bb15d_17, %bb15d_39) : (i64, i64) -> i64
      "braid.setf"(%bb15d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb15d_17) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb15f] : () -> ()
    ^bb15f:  // 0x40119f
      %bb15f_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb15f_0 = "braid.zext"(%bb15f_1) {bits = 32 : i64} : (i64) -> i64
      %bb15f_9 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb15f_8 = "braid.zext"(%bb15f_9) {bits = 32 : i64} : (i64) -> i64
      %bb15f_16 = "braid.xor"(%bb15f_0, %bb15f_8) : (i64, i64) -> i64
      %bb15f_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb15f_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb15f_17) {flag = "of"} : (i64) -> ()
      %bb15f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb15f_24) {flag = "af"} : (i64) -> ()
      %bb15f_32 = "braid.zext"(%bb15f_16) {bits = 8 : i64} : (i64) -> i64
      %bb15f_33 = "braid.popcnt"(%bb15f_32) : (i64) -> i64
      %bb15f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb15f_35 = "braid.and"(%bb15f_33, %bb15f_34) : (i64, i64) -> i64
      %bb15f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb15f_37 = "braid.eq"(%bb15f_35, %bb15f_36) : (i64, i64) -> i64
      "braid.setf"(%bb15f_37) {flag = "pf"} : (i64) -> ()
      %bb15f_38 = "braid.eq"(%bb15f_16, %bb15f_36) : (i64, i64) -> i64
      "braid.setf"(%bb15f_38) {flag = "zf"} : (i64) -> ()
      %bb15f_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb15f_40 = "braid.and"(%bb15f_16, %bb15f_39) : (i64, i64) -> i64
      "braid.setf"(%bb15f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb15f_16) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb161] : () -> ()
    ^bb161:  // 0x4011a1
      %bb161_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb161_0 = "braid.zext"(%bb161_1) {bits = 32 : i64} : (i64) -> i64
      %bb161_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb161_13 = "braid.shl"(%bb161_0, %bb161_12) : (i64, i64) -> i64
      %bb161_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb161_15 = "braid.lshr"(%bb161_0, %bb161_14) : (i64, i64) -> i64
      %bb161_16 = "braid.or"(%bb161_13, %bb161_15) : (i64, i64) -> i64
      %bb161_17 = "braid.zext"(%bb161_16) {bits = 32 : i64} : (i64) -> i64
      %bb161_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb161_19 = "braid.and"(%bb161_17, %bb161_18) : (i64, i64) -> i64
      "braid.setf"(%bb161_19) {flag = "cf"} : (i64) -> ()
      %bb161_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb161_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb161_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb164] : () -> ()
    ^bb164:  // 0x4011a4
      %bb164_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb164_0 = "braid.zext"(%bb164_1) {bits = 32 : i64} : (i64) -> i64
      %bb164_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb164_8 = "braid.zext"(%bb164_9) {bits = 32 : i64} : (i64) -> i64
      %bb164_16 = "braid.add"(%bb164_0, %bb164_8) : (i64, i64) -> i64
      %bb164_17 = "braid.zext"(%bb164_16) {bits = 32 : i64} : (i64) -> i64
      %bb164_18 = "braid.ult"(%bb164_17, %bb164_0) : (i64, i64) -> i64
      "braid.setf"(%bb164_18) {flag = "cf"} : (i64) -> ()
      %bb164_19 = "braid.xor"(%bb164_0, %bb164_17) : (i64, i64) -> i64
      %bb164_20 = "braid.xor"(%bb164_8, %bb164_17) : (i64, i64) -> i64
      %bb164_21 = "braid.and"(%bb164_19, %bb164_20) : (i64, i64) -> i64
      %bb164_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb164_23 = "braid.and"(%bb164_21, %bb164_22) : (i64, i64) -> i64
      "braid.setf"(%bb164_23) {flag = "of"} : (i64) -> ()
      %bb164_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb164_24) {flag = "af"} : (i64) -> ()
      %bb164_32 = "braid.zext"(%bb164_17) {bits = 8 : i64} : (i64) -> i64
      %bb164_33 = "braid.popcnt"(%bb164_32) : (i64) -> i64
      %bb164_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb164_35 = "braid.and"(%bb164_33, %bb164_34) : (i64, i64) -> i64
      %bb164_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb164_37 = "braid.eq"(%bb164_35, %bb164_36) : (i64, i64) -> i64
      "braid.setf"(%bb164_37) {flag = "pf"} : (i64) -> ()
      %bb164_38 = "braid.eq"(%bb164_17, %bb164_36) : (i64, i64) -> i64
      "braid.setf"(%bb164_38) {flag = "zf"} : (i64) -> ()
      %bb164_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb164_40 = "braid.and"(%bb164_17, %bb164_39) : (i64, i64) -> i64
      "braid.setf"(%bb164_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb164_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb167] : () -> ()
    ^bb167:  // 0x4011a7
      %bb167_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb167_0 = "braid.zext"(%bb167_1) {bits = 32 : i64} : (i64) -> i64
      %bb167_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb167_8 = "braid.zext"(%bb167_9) {bits = 32 : i64} : (i64) -> i64
      %bb167_16 = "braid.xor"(%bb167_0, %bb167_8) : (i64, i64) -> i64
      %bb167_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb167_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb167_17) {flag = "of"} : (i64) -> ()
      %bb167_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb167_24) {flag = "af"} : (i64) -> ()
      %bb167_32 = "braid.zext"(%bb167_16) {bits = 8 : i64} : (i64) -> i64
      %bb167_33 = "braid.popcnt"(%bb167_32) : (i64) -> i64
      %bb167_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb167_35 = "braid.and"(%bb167_33, %bb167_34) : (i64, i64) -> i64
      %bb167_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb167_37 = "braid.eq"(%bb167_35, %bb167_36) : (i64, i64) -> i64
      "braid.setf"(%bb167_37) {flag = "pf"} : (i64) -> ()
      %bb167_38 = "braid.eq"(%bb167_16, %bb167_36) : (i64, i64) -> i64
      "braid.setf"(%bb167_38) {flag = "zf"} : (i64) -> ()
      %bb167_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb167_40 = "braid.and"(%bb167_16, %bb167_39) : (i64, i64) -> i64
      "braid.setf"(%bb167_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb167_16) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb16a] : () -> ()
    ^bb16a:  // 0x4011aa
      %bb16a_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb16a_0 = "braid.zext"(%bb16a_1) {bits = 32 : i64} : (i64) -> i64
      %bb16a_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb16a_13 = "braid.shl"(%bb16a_0, %bb16a_12) : (i64, i64) -> i64
      %bb16a_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb16a_15 = "braid.lshr"(%bb16a_0, %bb16a_14) : (i64, i64) -> i64
      %bb16a_16 = "braid.or"(%bb16a_13, %bb16a_15) : (i64, i64) -> i64
      %bb16a_17 = "braid.zext"(%bb16a_16) {bits = 32 : i64} : (i64) -> i64
      %bb16a_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb16a_19 = "braid.and"(%bb16a_17, %bb16a_18) : (i64, i64) -> i64
      "braid.setf"(%bb16a_19) {flag = "cf"} : (i64) -> ()
      %bb16a_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb16a_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb16a_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb16d] : () -> ()
    ^bb16d:  // 0x4011ad
      %bb16d_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb16d_0 = "braid.zext"(%bb16d_1) {bits = 32 : i64} : (i64) -> i64
      %bb16d_9 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb16d_8 = "braid.zext"(%bb16d_9) {bits = 32 : i64} : (i64) -> i64
      %bb16d_16 = "braid.add"(%bb16d_0, %bb16d_8) : (i64, i64) -> i64
      %bb16d_17 = "braid.zext"(%bb16d_16) {bits = 32 : i64} : (i64) -> i64
      %bb16d_18 = "braid.ult"(%bb16d_17, %bb16d_0) : (i64, i64) -> i64
      "braid.setf"(%bb16d_18) {flag = "cf"} : (i64) -> ()
      %bb16d_19 = "braid.xor"(%bb16d_0, %bb16d_17) : (i64, i64) -> i64
      %bb16d_20 = "braid.xor"(%bb16d_8, %bb16d_17) : (i64, i64) -> i64
      %bb16d_21 = "braid.and"(%bb16d_19, %bb16d_20) : (i64, i64) -> i64
      %bb16d_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb16d_23 = "braid.and"(%bb16d_21, %bb16d_22) : (i64, i64) -> i64
      "braid.setf"(%bb16d_23) {flag = "of"} : (i64) -> ()
      %bb16d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb16d_24) {flag = "af"} : (i64) -> ()
      %bb16d_32 = "braid.zext"(%bb16d_17) {bits = 8 : i64} : (i64) -> i64
      %bb16d_33 = "braid.popcnt"(%bb16d_32) : (i64) -> i64
      %bb16d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb16d_35 = "braid.and"(%bb16d_33, %bb16d_34) : (i64, i64) -> i64
      %bb16d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb16d_37 = "braid.eq"(%bb16d_35, %bb16d_36) : (i64, i64) -> i64
      "braid.setf"(%bb16d_37) {flag = "pf"} : (i64) -> ()
      %bb16d_38 = "braid.eq"(%bb16d_17, %bb16d_36) : (i64, i64) -> i64
      "braid.setf"(%bb16d_38) {flag = "zf"} : (i64) -> ()
      %bb16d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb16d_40 = "braid.and"(%bb16d_17, %bb16d_39) : (i64, i64) -> i64
      "braid.setf"(%bb16d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb16d_17) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb16f] : () -> ()
    ^bb16f:  // 0x4011af
      %bb16f_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb16f_0 = "braid.zext"(%bb16f_1) {bits = 32 : i64} : (i64) -> i64
      %bb16f_9 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb16f_8 = "braid.zext"(%bb16f_9) {bits = 32 : i64} : (i64) -> i64
      %bb16f_16 = "braid.xor"(%bb16f_0, %bb16f_8) : (i64, i64) -> i64
      %bb16f_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb16f_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb16f_17) {flag = "of"} : (i64) -> ()
      %bb16f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb16f_24) {flag = "af"} : (i64) -> ()
      %bb16f_32 = "braid.zext"(%bb16f_16) {bits = 8 : i64} : (i64) -> i64
      %bb16f_33 = "braid.popcnt"(%bb16f_32) : (i64) -> i64
      %bb16f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb16f_35 = "braid.and"(%bb16f_33, %bb16f_34) : (i64, i64) -> i64
      %bb16f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb16f_37 = "braid.eq"(%bb16f_35, %bb16f_36) : (i64, i64) -> i64
      "braid.setf"(%bb16f_37) {flag = "pf"} : (i64) -> ()
      %bb16f_38 = "braid.eq"(%bb16f_16, %bb16f_36) : (i64, i64) -> i64
      "braid.setf"(%bb16f_38) {flag = "zf"} : (i64) -> ()
      %bb16f_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb16f_40 = "braid.and"(%bb16f_16, %bb16f_39) : (i64, i64) -> i64
      "braid.setf"(%bb16f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb16f_16) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb171] : () -> ()
    ^bb171:  // 0x4011b1
      %bb171_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb171_0 = "braid.zext"(%bb171_1) {bits = 32 : i64} : (i64) -> i64
      %bb171_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb171_13 = "braid.shl"(%bb171_0, %bb171_12) : (i64, i64) -> i64
      %bb171_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb171_15 = "braid.lshr"(%bb171_0, %bb171_14) : (i64, i64) -> i64
      %bb171_16 = "braid.or"(%bb171_13, %bb171_15) : (i64, i64) -> i64
      %bb171_17 = "braid.zext"(%bb171_16) {bits = 32 : i64} : (i64) -> i64
      %bb171_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb171_19 = "braid.and"(%bb171_17, %bb171_18) : (i64, i64) -> i64
      "braid.setf"(%bb171_19) {flag = "cf"} : (i64) -> ()
      %bb171_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb171_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb171_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb174] : () -> ()
    ^bb174:  // 0x4011b4
      %bb174_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb174_0 = "braid.zext"(%bb174_1) {bits = 32 : i64} : (i64) -> i64
      %bb174_9 = "braid.get"() {reg = "r13"} : () -> i64
      %bb174_8 = "braid.zext"(%bb174_9) {bits = 32 : i64} : (i64) -> i64
      %bb174_16 = "braid.add"(%bb174_0, %bb174_8) : (i64, i64) -> i64
      %bb174_17 = "braid.zext"(%bb174_16) {bits = 32 : i64} : (i64) -> i64
      %bb174_18 = "braid.ult"(%bb174_17, %bb174_0) : (i64, i64) -> i64
      "braid.setf"(%bb174_18) {flag = "cf"} : (i64) -> ()
      %bb174_19 = "braid.xor"(%bb174_0, %bb174_17) : (i64, i64) -> i64
      %bb174_20 = "braid.xor"(%bb174_8, %bb174_17) : (i64, i64) -> i64
      %bb174_21 = "braid.and"(%bb174_19, %bb174_20) : (i64, i64) -> i64
      %bb174_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb174_23 = "braid.and"(%bb174_21, %bb174_22) : (i64, i64) -> i64
      "braid.setf"(%bb174_23) {flag = "of"} : (i64) -> ()
      %bb174_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb174_24) {flag = "af"} : (i64) -> ()
      %bb174_32 = "braid.zext"(%bb174_17) {bits = 8 : i64} : (i64) -> i64
      %bb174_33 = "braid.popcnt"(%bb174_32) : (i64) -> i64
      %bb174_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb174_35 = "braid.and"(%bb174_33, %bb174_34) : (i64, i64) -> i64
      %bb174_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb174_37 = "braid.eq"(%bb174_35, %bb174_36) : (i64, i64) -> i64
      "braid.setf"(%bb174_37) {flag = "pf"} : (i64) -> ()
      %bb174_38 = "braid.eq"(%bb174_17, %bb174_36) : (i64, i64) -> i64
      "braid.setf"(%bb174_38) {flag = "zf"} : (i64) -> ()
      %bb174_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb174_40 = "braid.and"(%bb174_17, %bb174_39) : (i64, i64) -> i64
      "braid.setf"(%bb174_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb174_17) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb177] : () -> ()
    ^bb177:  // 0x4011b7
      %bb177_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb177_0 = "braid.zext"(%bb177_1) {bits = 32 : i64} : (i64) -> i64
      %bb177_9 = "braid.get"() {reg = "r13"} : () -> i64
      %bb177_8 = "braid.zext"(%bb177_9) {bits = 32 : i64} : (i64) -> i64
      %bb177_16 = "braid.xor"(%bb177_0, %bb177_8) : (i64, i64) -> i64
      %bb177_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb177_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb177_17) {flag = "of"} : (i64) -> ()
      %bb177_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb177_24) {flag = "af"} : (i64) -> ()
      %bb177_32 = "braid.zext"(%bb177_16) {bits = 8 : i64} : (i64) -> i64
      %bb177_33 = "braid.popcnt"(%bb177_32) : (i64) -> i64
      %bb177_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb177_35 = "braid.and"(%bb177_33, %bb177_34) : (i64, i64) -> i64
      %bb177_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb177_37 = "braid.eq"(%bb177_35, %bb177_36) : (i64, i64) -> i64
      "braid.setf"(%bb177_37) {flag = "pf"} : (i64) -> ()
      %bb177_38 = "braid.eq"(%bb177_16, %bb177_36) : (i64, i64) -> i64
      "braid.setf"(%bb177_38) {flag = "zf"} : (i64) -> ()
      %bb177_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb177_40 = "braid.and"(%bb177_16, %bb177_39) : (i64, i64) -> i64
      "braid.setf"(%bb177_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb177_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb17a] : () -> ()
    ^bb17a:  // 0x4011ba
      %bb17a_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb17a_0 = "braid.zext"(%bb17a_1) {bits = 32 : i64} : (i64) -> i64
      %bb17a_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb17a_13 = "braid.shl"(%bb17a_0, %bb17a_12) : (i64, i64) -> i64
      %bb17a_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb17a_15 = "braid.lshr"(%bb17a_0, %bb17a_14) : (i64, i64) -> i64
      %bb17a_16 = "braid.or"(%bb17a_13, %bb17a_15) : (i64, i64) -> i64
      %bb17a_17 = "braid.zext"(%bb17a_16) {bits = 32 : i64} : (i64) -> i64
      %bb17a_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb17a_19 = "braid.and"(%bb17a_17, %bb17a_18) : (i64, i64) -> i64
      "braid.setf"(%bb17a_19) {flag = "cf"} : (i64) -> ()
      %bb17a_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb17a_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb17a_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb17d] : () -> ()
    ^bb17d:  // 0x4011bd
      %bb17d_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb17d_0 = "braid.zext"(%bb17d_1) {bits = 32 : i64} : (i64) -> i64
      %bb17d_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb17d_8 = "braid.zext"(%bb17d_9) {bits = 32 : i64} : (i64) -> i64
      %bb17d_16 = "braid.add"(%bb17d_0, %bb17d_8) : (i64, i64) -> i64
      %bb17d_17 = "braid.zext"(%bb17d_16) {bits = 32 : i64} : (i64) -> i64
      %bb17d_18 = "braid.ult"(%bb17d_17, %bb17d_0) : (i64, i64) -> i64
      "braid.setf"(%bb17d_18) {flag = "cf"} : (i64) -> ()
      %bb17d_19 = "braid.xor"(%bb17d_0, %bb17d_17) : (i64, i64) -> i64
      %bb17d_20 = "braid.xor"(%bb17d_8, %bb17d_17) : (i64, i64) -> i64
      %bb17d_21 = "braid.and"(%bb17d_19, %bb17d_20) : (i64, i64) -> i64
      %bb17d_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb17d_23 = "braid.and"(%bb17d_21, %bb17d_22) : (i64, i64) -> i64
      "braid.setf"(%bb17d_23) {flag = "of"} : (i64) -> ()
      %bb17d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb17d_24) {flag = "af"} : (i64) -> ()
      %bb17d_32 = "braid.zext"(%bb17d_17) {bits = 8 : i64} : (i64) -> i64
      %bb17d_33 = "braid.popcnt"(%bb17d_32) : (i64) -> i64
      %bb17d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb17d_35 = "braid.and"(%bb17d_33, %bb17d_34) : (i64, i64) -> i64
      %bb17d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb17d_37 = "braid.eq"(%bb17d_35, %bb17d_36) : (i64, i64) -> i64
      "braid.setf"(%bb17d_37) {flag = "pf"} : (i64) -> ()
      %bb17d_38 = "braid.eq"(%bb17d_17, %bb17d_36) : (i64, i64) -> i64
      "braid.setf"(%bb17d_38) {flag = "zf"} : (i64) -> ()
      %bb17d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb17d_40 = "braid.and"(%bb17d_17, %bb17d_39) : (i64, i64) -> i64
      "braid.setf"(%bb17d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb17d_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb180] : () -> ()
    ^bb180:  // 0x4011c0
      %bb180_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb180_0 = "braid.zext"(%bb180_1) {bits = 32 : i64} : (i64) -> i64
      %bb180_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb180_8 = "braid.zext"(%bb180_9) {bits = 32 : i64} : (i64) -> i64
      %bb180_16 = "braid.xor"(%bb180_0, %bb180_8) : (i64, i64) -> i64
      %bb180_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb180_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb180_17) {flag = "of"} : (i64) -> ()
      %bb180_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb180_24) {flag = "af"} : (i64) -> ()
      %bb180_32 = "braid.zext"(%bb180_16) {bits = 8 : i64} : (i64) -> i64
      %bb180_33 = "braid.popcnt"(%bb180_32) : (i64) -> i64
      %bb180_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb180_35 = "braid.and"(%bb180_33, %bb180_34) : (i64, i64) -> i64
      %bb180_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb180_37 = "braid.eq"(%bb180_35, %bb180_36) : (i64, i64) -> i64
      "braid.setf"(%bb180_37) {flag = "pf"} : (i64) -> ()
      %bb180_38 = "braid.eq"(%bb180_16, %bb180_36) : (i64, i64) -> i64
      "braid.setf"(%bb180_38) {flag = "zf"} : (i64) -> ()
      %bb180_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb180_40 = "braid.and"(%bb180_16, %bb180_39) : (i64, i64) -> i64
      "braid.setf"(%bb180_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb180_16) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb183] : () -> ()
    ^bb183:  // 0x4011c3
      %bb183_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb183_0 = "braid.zext"(%bb183_1) {bits = 32 : i64} : (i64) -> i64
      %bb183_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb183_13 = "braid.shl"(%bb183_0, %bb183_12) : (i64, i64) -> i64
      %bb183_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb183_15 = "braid.lshr"(%bb183_0, %bb183_14) : (i64, i64) -> i64
      %bb183_16 = "braid.or"(%bb183_13, %bb183_15) : (i64, i64) -> i64
      %bb183_17 = "braid.zext"(%bb183_16) {bits = 32 : i64} : (i64) -> i64
      %bb183_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb183_19 = "braid.and"(%bb183_17, %bb183_18) : (i64, i64) -> i64
      "braid.setf"(%bb183_19) {flag = "cf"} : (i64) -> ()
      %bb183_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb183_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb183_17) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb187] : () -> ()
    ^bb187:  // 0x4011c7
      %bb187_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb187_0 = "braid.zext"(%bb187_1) {bits = 32 : i64} : (i64) -> i64
      %bb187_9 = "braid.get"() {reg = "r13"} : () -> i64
      %bb187_8 = "braid.zext"(%bb187_9) {bits = 32 : i64} : (i64) -> i64
      %bb187_16 = "braid.add"(%bb187_0, %bb187_8) : (i64, i64) -> i64
      %bb187_17 = "braid.zext"(%bb187_16) {bits = 32 : i64} : (i64) -> i64
      %bb187_18 = "braid.ult"(%bb187_17, %bb187_0) : (i64, i64) -> i64
      "braid.setf"(%bb187_18) {flag = "cf"} : (i64) -> ()
      %bb187_19 = "braid.xor"(%bb187_0, %bb187_17) : (i64, i64) -> i64
      %bb187_20 = "braid.xor"(%bb187_8, %bb187_17) : (i64, i64) -> i64
      %bb187_21 = "braid.and"(%bb187_19, %bb187_20) : (i64, i64) -> i64
      %bb187_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb187_23 = "braid.and"(%bb187_21, %bb187_22) : (i64, i64) -> i64
      "braid.setf"(%bb187_23) {flag = "of"} : (i64) -> ()
      %bb187_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb187_24) {flag = "af"} : (i64) -> ()
      %bb187_32 = "braid.zext"(%bb187_17) {bits = 8 : i64} : (i64) -> i64
      %bb187_33 = "braid.popcnt"(%bb187_32) : (i64) -> i64
      %bb187_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb187_35 = "braid.and"(%bb187_33, %bb187_34) : (i64, i64) -> i64
      %bb187_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb187_37 = "braid.eq"(%bb187_35, %bb187_36) : (i64, i64) -> i64
      "braid.setf"(%bb187_37) {flag = "pf"} : (i64) -> ()
      %bb187_38 = "braid.eq"(%bb187_17, %bb187_36) : (i64, i64) -> i64
      "braid.setf"(%bb187_38) {flag = "zf"} : (i64) -> ()
      %bb187_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb187_40 = "braid.and"(%bb187_17, %bb187_39) : (i64, i64) -> i64
      "braid.setf"(%bb187_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb187_17) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb18a] : () -> ()
    ^bb18a:  // 0x4011ca
      %bb18a_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb18a_0 = "braid.zext"(%bb18a_1) {bits = 32 : i64} : (i64) -> i64
      %bb18a_9 = "braid.get"() {reg = "r13"} : () -> i64
      %bb18a_8 = "braid.zext"(%bb18a_9) {bits = 32 : i64} : (i64) -> i64
      %bb18a_16 = "braid.xor"(%bb18a_0, %bb18a_8) : (i64, i64) -> i64
      %bb18a_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb18a_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb18a_17) {flag = "of"} : (i64) -> ()
      %bb18a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb18a_24) {flag = "af"} : (i64) -> ()
      %bb18a_32 = "braid.zext"(%bb18a_16) {bits = 8 : i64} : (i64) -> i64
      %bb18a_33 = "braid.popcnt"(%bb18a_32) : (i64) -> i64
      %bb18a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb18a_35 = "braid.and"(%bb18a_33, %bb18a_34) : (i64, i64) -> i64
      %bb18a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb18a_37 = "braid.eq"(%bb18a_35, %bb18a_36) : (i64, i64) -> i64
      "braid.setf"(%bb18a_37) {flag = "pf"} : (i64) -> ()
      %bb18a_38 = "braid.eq"(%bb18a_16, %bb18a_36) : (i64, i64) -> i64
      "braid.setf"(%bb18a_38) {flag = "zf"} : (i64) -> ()
      %bb18a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb18a_40 = "braid.and"(%bb18a_16, %bb18a_39) : (i64, i64) -> i64
      "braid.setf"(%bb18a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb18a_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb18d] : () -> ()
    ^bb18d:  // 0x4011cd
      %bb18d_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb18d_0 = "braid.zext"(%bb18d_1) {bits = 32 : i64} : (i64) -> i64
      %bb18d_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb18d_13 = "braid.shl"(%bb18d_0, %bb18d_12) : (i64, i64) -> i64
      %bb18d_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb18d_15 = "braid.lshr"(%bb18d_0, %bb18d_14) : (i64, i64) -> i64
      %bb18d_16 = "braid.or"(%bb18d_13, %bb18d_15) : (i64, i64) -> i64
      %bb18d_17 = "braid.zext"(%bb18d_16) {bits = 32 : i64} : (i64) -> i64
      %bb18d_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb18d_19 = "braid.and"(%bb18d_17, %bb18d_18) : (i64, i64) -> i64
      "braid.setf"(%bb18d_19) {flag = "cf"} : (i64) -> ()
      %bb18d_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb18d_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb18d_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x4011d0
      %bb190_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb190_0 = "braid.zext"(%bb190_1) {bits = 32 : i64} : (i64) -> i64
      %bb190_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb190_8 = "braid.zext"(%bb190_9) {bits = 32 : i64} : (i64) -> i64
      %bb190_16 = "braid.add"(%bb190_0, %bb190_8) : (i64, i64) -> i64
      %bb190_17 = "braid.zext"(%bb190_16) {bits = 32 : i64} : (i64) -> i64
      %bb190_18 = "braid.ult"(%bb190_17, %bb190_0) : (i64, i64) -> i64
      "braid.setf"(%bb190_18) {flag = "cf"} : (i64) -> ()
      %bb190_19 = "braid.xor"(%bb190_0, %bb190_17) : (i64, i64) -> i64
      %bb190_20 = "braid.xor"(%bb190_8, %bb190_17) : (i64, i64) -> i64
      %bb190_21 = "braid.and"(%bb190_19, %bb190_20) : (i64, i64) -> i64
      %bb190_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb190_23 = "braid.and"(%bb190_21, %bb190_22) : (i64, i64) -> i64
      "braid.setf"(%bb190_23) {flag = "of"} : (i64) -> ()
      %bb190_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb190_24) {flag = "af"} : (i64) -> ()
      %bb190_32 = "braid.zext"(%bb190_17) {bits = 8 : i64} : (i64) -> i64
      %bb190_33 = "braid.popcnt"(%bb190_32) : (i64) -> i64
      %bb190_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb190_35 = "braid.and"(%bb190_33, %bb190_34) : (i64, i64) -> i64
      %bb190_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb190_37 = "braid.eq"(%bb190_35, %bb190_36) : (i64, i64) -> i64
      "braid.setf"(%bb190_37) {flag = "pf"} : (i64) -> ()
      %bb190_38 = "braid.eq"(%bb190_17, %bb190_36) : (i64, i64) -> i64
      "braid.setf"(%bb190_38) {flag = "zf"} : (i64) -> ()
      %bb190_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb190_40 = "braid.and"(%bb190_17, %bb190_39) : (i64, i64) -> i64
      "braid.setf"(%bb190_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb190_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb193] : () -> ()
    ^bb193:  // 0x4011d3
      %bb193_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb193_0 = "braid.zext"(%bb193_1) {bits = 32 : i64} : (i64) -> i64
      %bb193_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb193_8 = "braid.zext"(%bb193_9) {bits = 32 : i64} : (i64) -> i64
      %bb193_16 = "braid.xor"(%bb193_0, %bb193_8) : (i64, i64) -> i64
      %bb193_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb193_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb193_17) {flag = "of"} : (i64) -> ()
      %bb193_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb193_24) {flag = "af"} : (i64) -> ()
      %bb193_32 = "braid.zext"(%bb193_16) {bits = 8 : i64} : (i64) -> i64
      %bb193_33 = "braid.popcnt"(%bb193_32) : (i64) -> i64
      %bb193_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb193_35 = "braid.and"(%bb193_33, %bb193_34) : (i64, i64) -> i64
      %bb193_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb193_37 = "braid.eq"(%bb193_35, %bb193_36) : (i64, i64) -> i64
      "braid.setf"(%bb193_37) {flag = "pf"} : (i64) -> ()
      %bb193_38 = "braid.eq"(%bb193_16, %bb193_36) : (i64, i64) -> i64
      "braid.setf"(%bb193_38) {flag = "zf"} : (i64) -> ()
      %bb193_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb193_40 = "braid.and"(%bb193_16, %bb193_39) : (i64, i64) -> i64
      "braid.setf"(%bb193_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb193_16) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb196] : () -> ()
    ^bb196:  // 0x4011d6
      %bb196_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb196_0 = "braid.zext"(%bb196_1) {bits = 32 : i64} : (i64) -> i64
      %bb196_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb196_13 = "braid.shl"(%bb196_0, %bb196_12) : (i64, i64) -> i64
      %bb196_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb196_15 = "braid.lshr"(%bb196_0, %bb196_14) : (i64, i64) -> i64
      %bb196_16 = "braid.or"(%bb196_13, %bb196_15) : (i64, i64) -> i64
      %bb196_17 = "braid.zext"(%bb196_16) {bits = 32 : i64} : (i64) -> i64
      %bb196_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb196_19 = "braid.and"(%bb196_17, %bb196_18) : (i64, i64) -> i64
      "braid.setf"(%bb196_19) {flag = "cf"} : (i64) -> ()
      %bb196_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb196_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb196_17) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb19a] : () -> ()
    ^bb19a:  // 0x4011da
      %bb19a_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb19a_3 = "braid.const"() {value = -20 : i64} : () -> i64
      %bb19a_1 = "braid.add"(%bb19a_2, %bb19a_3) : (i64, i64) -> i64
      %bb19a_0 = "braid.load"(%bb19a_1) {bytes = 4 : i64} : (i64) -> i64
      %bb19a_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb19a_16 = "braid.sub"(%bb19a_0, %bb19a_8) : (i64, i64) -> i64
      %bb19a_17 = "braid.zext"(%bb19a_16) {bits = 32 : i64} : (i64) -> i64
      %bb19a_19 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb19a_20 = "braid.eq"(%bb19a_0, %bb19a_19) : (i64, i64) -> i64
      "braid.setf"(%bb19a_20) {flag = "of"} : (i64) -> ()
      %bb19a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb19a_24) {flag = "af"} : (i64) -> ()
      %bb19a_32 = "braid.zext"(%bb19a_17) {bits = 8 : i64} : (i64) -> i64
      %bb19a_33 = "braid.popcnt"(%bb19a_32) : (i64) -> i64
      %bb19a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb19a_35 = "braid.and"(%bb19a_33, %bb19a_34) : (i64, i64) -> i64
      %bb19a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb19a_37 = "braid.eq"(%bb19a_35, %bb19a_36) : (i64, i64) -> i64
      "braid.setf"(%bb19a_37) {flag = "pf"} : (i64) -> ()
      %bb19a_38 = "braid.eq"(%bb19a_17, %bb19a_36) : (i64, i64) -> i64
      "braid.setf"(%bb19a_38) {flag = "zf"} : (i64) -> ()
      %bb19a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb19a_40 = "braid.and"(%bb19a_17, %bb19a_39) : (i64, i64) -> i64
      "braid.setf"(%bb19a_40) {flag = "sf"} : (i64) -> ()
      %bb19a_49 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb19a_50 = "braid.const"() {value = -20 : i64} : () -> i64
      %bb19a_48 = "braid.add"(%bb19a_49, %bb19a_50) : (i64, i64) -> i64
      "braid.store"(%bb19a_48, %bb19a_17) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb19e] : () -> ()
    ^bb19e:  // 0x4011de
      %bb19e_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb19e_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb19e_0 = "braid.eq"(%bb19e_1, %bb19e_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb19e_0)[^bb60, ^bb1a4] : (i64) -> ()
    ^bb1a4:  // 0x4011e4
      %bb1a4_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1a4_0 = "braid.zext"(%bb1a4_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a4_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1a4_10 = "braid.const"() {value = -28 : i64} : () -> i64
      %bb1a4_8 = "braid.add"(%bb1a4_9, %bb1a4_10) : (i64, i64) -> i64
      "braid.store"(%bb1a4_8, %bb1a4_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1a8] : () -> ()
    ^bb1a8:  // 0x4011e8
      %bb1a8_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1a8_3 = "braid.const"() {value = -16 : i64} : () -> i64
      %bb1a8_1 = "braid.add"(%bb1a8_2, %bb1a8_3) : (i64, i64) -> i64
      %bb1a8_0 = "braid.load"(%bb1a8_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb1a8_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb1ad] : () -> ()
    ^bb1ad:  // 0x4011ed
      %bb1ad_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1ad_0 = "braid.load"(%bb1ad_1) {bytes = 4 : i64} : (i64) -> i64
      %bb1ad_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb1ad_8 = "braid.zext"(%bb1ad_9) {bits = 32 : i64} : (i64) -> i64
      %bb1ad_16 = "braid.add"(%bb1ad_0, %bb1ad_8) : (i64, i64) -> i64
      %bb1ad_17 = "braid.zext"(%bb1ad_16) {bits = 32 : i64} : (i64) -> i64
      %bb1ad_18 = "braid.ult"(%bb1ad_17, %bb1ad_0) : (i64, i64) -> i64
      "braid.setf"(%bb1ad_18) {flag = "cf"} : (i64) -> ()
      %bb1ad_19 = "braid.xor"(%bb1ad_0, %bb1ad_17) : (i64, i64) -> i64
      %bb1ad_20 = "braid.xor"(%bb1ad_8, %bb1ad_17) : (i64, i64) -> i64
      %bb1ad_21 = "braid.and"(%bb1ad_19, %bb1ad_20) : (i64, i64) -> i64
      %bb1ad_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1ad_23 = "braid.and"(%bb1ad_21, %bb1ad_22) : (i64, i64) -> i64
      "braid.setf"(%bb1ad_23) {flag = "of"} : (i64) -> ()
      %bb1ad_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1ad_24) {flag = "af"} : (i64) -> ()
      %bb1ad_32 = "braid.zext"(%bb1ad_17) {bits = 8 : i64} : (i64) -> i64
      %bb1ad_33 = "braid.popcnt"(%bb1ad_32) : (i64) -> i64
      %bb1ad_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1ad_35 = "braid.and"(%bb1ad_33, %bb1ad_34) : (i64, i64) -> i64
      %bb1ad_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1ad_37 = "braid.eq"(%bb1ad_35, %bb1ad_36) : (i64, i64) -> i64
      "braid.setf"(%bb1ad_37) {flag = "pf"} : (i64) -> ()
      %bb1ad_38 = "braid.eq"(%bb1ad_17, %bb1ad_36) : (i64, i64) -> i64
      "braid.setf"(%bb1ad_38) {flag = "zf"} : (i64) -> ()
      %bb1ad_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1ad_40 = "braid.and"(%bb1ad_17, %bb1ad_39) : (i64, i64) -> i64
      "braid.setf"(%bb1ad_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1ad_17) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb1b0] : () -> ()
    ^bb1b0:  // 0x4011f0
      %bb1b0_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1b0_3 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb1b0_1 = "braid.add"(%bb1b0_2, %bb1b0_3) : (i64, i64) -> i64
      %bb1b0_0 = "braid.load"(%bb1b0_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb1b0_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb1b5] : () -> ()
    ^bb1b5:  // 0x4011f5
      %bb1b5_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb1b5_0 = "braid.zext"(%bb1b5_1) {bits = 32 : i64} : (i64) -> i64
      %bb1b5_8 = "braid.get"() {reg = "rsi"} : () -> i64
      "braid.store"(%bb1b5_8, %bb1b5_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1b8] : () -> ()
    ^bb1b8:  // 0x4011f8
      %bb1b8_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1b8_3 = "braid.const"() {value = -16 : i64} : () -> i64
      %bb1b8_1 = "braid.add"(%bb1b8_2, %bb1b8_3) : (i64, i64) -> i64
      %bb1b8_0 = "braid.load"(%bb1b8_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb1b8_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb1bd] : () -> ()
    ^bb1bd:  // 0x4011fd
      %bb1bd_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1bd_3 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1bd_1 = "braid.add"(%bb1bd_2, %bb1bd_3) : (i64, i64) -> i64
      %bb1bd_0 = "braid.load"(%bb1bd_1) {bytes = 4 : i64} : (i64) -> i64
      %bb1bd_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb1bd_8 = "braid.zext"(%bb1bd_9) {bits = 32 : i64} : (i64) -> i64
      %bb1bd_16 = "braid.add"(%bb1bd_0, %bb1bd_8) : (i64, i64) -> i64
      %bb1bd_17 = "braid.zext"(%bb1bd_16) {bits = 32 : i64} : (i64) -> i64
      %bb1bd_18 = "braid.ult"(%bb1bd_17, %bb1bd_0) : (i64, i64) -> i64
      "braid.setf"(%bb1bd_18) {flag = "cf"} : (i64) -> ()
      %bb1bd_19 = "braid.xor"(%bb1bd_0, %bb1bd_17) : (i64, i64) -> i64
      %bb1bd_20 = "braid.xor"(%bb1bd_8, %bb1bd_17) : (i64, i64) -> i64
      %bb1bd_21 = "braid.and"(%bb1bd_19, %bb1bd_20) : (i64, i64) -> i64
      %bb1bd_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1bd_23 = "braid.and"(%bb1bd_21, %bb1bd_22) : (i64, i64) -> i64
      "braid.setf"(%bb1bd_23) {flag = "of"} : (i64) -> ()
      %bb1bd_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1bd_24) {flag = "af"} : (i64) -> ()
      %bb1bd_32 = "braid.zext"(%bb1bd_17) {bits = 8 : i64} : (i64) -> i64
      %bb1bd_33 = "braid.popcnt"(%bb1bd_32) : (i64) -> i64
      %bb1bd_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1bd_35 = "braid.and"(%bb1bd_33, %bb1bd_34) : (i64, i64) -> i64
      %bb1bd_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1bd_37 = "braid.eq"(%bb1bd_35, %bb1bd_36) : (i64, i64) -> i64
      "braid.setf"(%bb1bd_37) {flag = "pf"} : (i64) -> ()
      %bb1bd_38 = "braid.eq"(%bb1bd_17, %bb1bd_36) : (i64, i64) -> i64
      "braid.setf"(%bb1bd_38) {flag = "zf"} : (i64) -> ()
      %bb1bd_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1bd_40 = "braid.and"(%bb1bd_17, %bb1bd_39) : (i64, i64) -> i64
      "braid.setf"(%bb1bd_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1bd_17) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb1c0] : () -> ()
    ^bb1c0:  // 0x401200
      %bb1c0_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1c0_3 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb1c0_1 = "braid.add"(%bb1c0_2, %bb1c0_3) : (i64, i64) -> i64
      %bb1c0_0 = "braid.load"(%bb1c0_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb1c0_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb1c5] : () -> ()
    ^bb1c5:  // 0x401205
      %bb1c5_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb1c5_0 = "braid.zext"(%bb1c5_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c5_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb1c5_10 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb1c5_8 = "braid.add"(%bb1c5_9, %bb1c5_10) : (i64, i64) -> i64
      "braid.store"(%bb1c5_8, %bb1c5_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1c9] : () -> ()
    ^bb1c9:  // 0x401209
      %bb1c9_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1c9_3 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c9_1 = "braid.add"(%bb1c9_2, %bb1c9_3) : (i64, i64) -> i64
      %bb1c9_0 = "braid.load"(%bb1c9_1) {bytes = 4 : i64} : (i64) -> i64
      %bb1c9_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb1c9_8 = "braid.zext"(%bb1c9_9) {bits = 32 : i64} : (i64) -> i64
      %bb1c9_16 = "braid.add"(%bb1c9_0, %bb1c9_8) : (i64, i64) -> i64
      %bb1c9_17 = "braid.zext"(%bb1c9_16) {bits = 32 : i64} : (i64) -> i64
      %bb1c9_18 = "braid.ult"(%bb1c9_17, %bb1c9_0) : (i64, i64) -> i64
      "braid.setf"(%bb1c9_18) {flag = "cf"} : (i64) -> ()
      %bb1c9_19 = "braid.xor"(%bb1c9_0, %bb1c9_17) : (i64, i64) -> i64
      %bb1c9_20 = "braid.xor"(%bb1c9_8, %bb1c9_17) : (i64, i64) -> i64
      %bb1c9_21 = "braid.and"(%bb1c9_19, %bb1c9_20) : (i64, i64) -> i64
      %bb1c9_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1c9_23 = "braid.and"(%bb1c9_21, %bb1c9_22) : (i64, i64) -> i64
      "braid.setf"(%bb1c9_23) {flag = "of"} : (i64) -> ()
      %bb1c9_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1c9_24) {flag = "af"} : (i64) -> ()
      %bb1c9_32 = "braid.zext"(%bb1c9_17) {bits = 8 : i64} : (i64) -> i64
      %bb1c9_33 = "braid.popcnt"(%bb1c9_32) : (i64) -> i64
      %bb1c9_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1c9_35 = "braid.and"(%bb1c9_33, %bb1c9_34) : (i64, i64) -> i64
      %bb1c9_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c9_37 = "braid.eq"(%bb1c9_35, %bb1c9_36) : (i64, i64) -> i64
      "braid.setf"(%bb1c9_37) {flag = "pf"} : (i64) -> ()
      %bb1c9_38 = "braid.eq"(%bb1c9_17, %bb1c9_36) : (i64, i64) -> i64
      "braid.setf"(%bb1c9_38) {flag = "zf"} : (i64) -> ()
      %bb1c9_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1c9_40 = "braid.and"(%bb1c9_17, %bb1c9_39) : (i64, i64) -> i64
      "braid.setf"(%bb1c9_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1c9_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb1cd] : () -> ()
    ^bb1cd:  // 0x40120d
      %bb1cd_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb1cd_0 = "braid.zext"(%bb1cd_1) {bits = 32 : i64} : (i64) -> i64
      %bb1cd_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb1cd_10 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1cd_8 = "braid.add"(%bb1cd_9, %bb1cd_10) : (i64, i64) -> i64
      "braid.store"(%bb1cd_8, %bb1cd_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1d1] : () -> ()
    ^bb1d1:  // 0x401211
      %bb1d1_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1d1_3 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb1d1_1 = "braid.add"(%bb1d1_2, %bb1d1_3) : (i64, i64) -> i64
      %bb1d1_0 = "braid.load"(%bb1d1_1) {bytes = 4 : i64} : (i64) -> i64
      %bb1d1_9 = "braid.get"() {reg = "r13"} : () -> i64
      %bb1d1_8 = "braid.zext"(%bb1d1_9) {bits = 32 : i64} : (i64) -> i64
      %bb1d1_16 = "braid.add"(%bb1d1_0, %bb1d1_8) : (i64, i64) -> i64
      %bb1d1_17 = "braid.zext"(%bb1d1_16) {bits = 32 : i64} : (i64) -> i64
      %bb1d1_18 = "braid.ult"(%bb1d1_17, %bb1d1_0) : (i64, i64) -> i64
      "braid.setf"(%bb1d1_18) {flag = "cf"} : (i64) -> ()
      %bb1d1_19 = "braid.xor"(%bb1d1_0, %bb1d1_17) : (i64, i64) -> i64
      %bb1d1_20 = "braid.xor"(%bb1d1_8, %bb1d1_17) : (i64, i64) -> i64
      %bb1d1_21 = "braid.and"(%bb1d1_19, %bb1d1_20) : (i64, i64) -> i64
      %bb1d1_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1d1_23 = "braid.and"(%bb1d1_21, %bb1d1_22) : (i64, i64) -> i64
      "braid.setf"(%bb1d1_23) {flag = "of"} : (i64) -> ()
      %bb1d1_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1d1_24) {flag = "af"} : (i64) -> ()
      %bb1d1_32 = "braid.zext"(%bb1d1_17) {bits = 8 : i64} : (i64) -> i64
      %bb1d1_33 = "braid.popcnt"(%bb1d1_32) : (i64) -> i64
      %bb1d1_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1d1_35 = "braid.and"(%bb1d1_33, %bb1d1_34) : (i64, i64) -> i64
      %bb1d1_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d1_37 = "braid.eq"(%bb1d1_35, %bb1d1_36) : (i64, i64) -> i64
      "braid.setf"(%bb1d1_37) {flag = "pf"} : (i64) -> ()
      %bb1d1_38 = "braid.eq"(%bb1d1_17, %bb1d1_36) : (i64, i64) -> i64
      "braid.setf"(%bb1d1_38) {flag = "zf"} : (i64) -> ()
      %bb1d1_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1d1_40 = "braid.and"(%bb1d1_17, %bb1d1_39) : (i64, i64) -> i64
      "braid.setf"(%bb1d1_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1d1_17) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb1d5] : () -> ()
    ^bb1d5:  // 0x401215
      %bb1d5_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb1d5_0 = "braid.zext"(%bb1d5_1) {bits = 32 : i64} : (i64) -> i64
      %bb1d5_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb1d5_10 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb1d5_8 = "braid.add"(%bb1d5_9, %bb1d5_10) : (i64, i64) -> i64
      "braid.store"(%bb1d5_8, %bb1d5_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1d9] : () -> ()
    ^bb1d9:  // 0x401219
      %bb1d9_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1d9_3 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1d9_1 = "braid.add"(%bb1d9_2, %bb1d9_3) : (i64, i64) -> i64
      %bb1d9_0 = "braid.load"(%bb1d9_1) {bytes = 4 : i64} : (i64) -> i64
      %bb1d9_9 = "braid.get"() {reg = "r12"} : () -> i64
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
      "braid.set"(%bb1d9_17) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb1dd] : () -> ()
    ^bb1dd:  // 0x40121d
      %bb1dd_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb1dd_0 = "braid.zext"(%bb1dd_1) {bits = 32 : i64} : (i64) -> i64
      %bb1dd_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb1dd_10 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1dd_8 = "braid.add"(%bb1dd_9, %bb1dd_10) : (i64, i64) -> i64
      "braid.store"(%bb1dd_8, %bb1dd_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1e1] : () -> ()
    ^bb1e1:  // 0x401221
      %bb1e1_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1e1_3 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb1e1_1 = "braid.add"(%bb1e1_2, %bb1e1_3) : (i64, i64) -> i64
      %bb1e1_0 = "braid.load"(%bb1e1_1) {bytes = 4 : i64} : (i64) -> i64
      %bb1e1_9 = "braid.get"() {reg = "r15"} : () -> i64
      %bb1e1_8 = "braid.zext"(%bb1e1_9) {bits = 32 : i64} : (i64) -> i64
      %bb1e1_16 = "braid.add"(%bb1e1_0, %bb1e1_8) : (i64, i64) -> i64
      %bb1e1_17 = "braid.zext"(%bb1e1_16) {bits = 32 : i64} : (i64) -> i64
      %bb1e1_18 = "braid.ult"(%bb1e1_17, %bb1e1_0) : (i64, i64) -> i64
      "braid.setf"(%bb1e1_18) {flag = "cf"} : (i64) -> ()
      %bb1e1_19 = "braid.xor"(%bb1e1_0, %bb1e1_17) : (i64, i64) -> i64
      %bb1e1_20 = "braid.xor"(%bb1e1_8, %bb1e1_17) : (i64, i64) -> i64
      %bb1e1_21 = "braid.and"(%bb1e1_19, %bb1e1_20) : (i64, i64) -> i64
      %bb1e1_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1e1_23 = "braid.and"(%bb1e1_21, %bb1e1_22) : (i64, i64) -> i64
      "braid.setf"(%bb1e1_23) {flag = "of"} : (i64) -> ()
      %bb1e1_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1e1_24) {flag = "af"} : (i64) -> ()
      %bb1e1_32 = "braid.zext"(%bb1e1_17) {bits = 8 : i64} : (i64) -> i64
      %bb1e1_33 = "braid.popcnt"(%bb1e1_32) : (i64) -> i64
      %bb1e1_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1e1_35 = "braid.and"(%bb1e1_33, %bb1e1_34) : (i64, i64) -> i64
      %bb1e1_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e1_37 = "braid.eq"(%bb1e1_35, %bb1e1_36) : (i64, i64) -> i64
      "braid.setf"(%bb1e1_37) {flag = "pf"} : (i64) -> ()
      %bb1e1_38 = "braid.eq"(%bb1e1_17, %bb1e1_36) : (i64, i64) -> i64
      "braid.setf"(%bb1e1_38) {flag = "zf"} : (i64) -> ()
      %bb1e1_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1e1_40 = "braid.and"(%bb1e1_17, %bb1e1_39) : (i64, i64) -> i64
      "braid.setf"(%bb1e1_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1e1_17) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb1e5] : () -> ()
    ^bb1e5:  // 0x401225
      %bb1e5_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb1e5_0 = "braid.zext"(%bb1e5_1) {bits = 32 : i64} : (i64) -> i64
      %bb1e5_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb1e5_10 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb1e5_8 = "braid.add"(%bb1e5_9, %bb1e5_10) : (i64, i64) -> i64
      "braid.store"(%bb1e5_8, %bb1e5_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1e9] : () -> ()
    ^bb1e9:  // 0x401229
      %bb1e9_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1e9_3 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb1e9_1 = "braid.add"(%bb1e9_2, %bb1e9_3) : (i64, i64) -> i64
      %bb1e9_0 = "braid.load"(%bb1e9_1) {bytes = 4 : i64} : (i64) -> i64
      %bb1e9_9 = "braid.get"() {reg = "r14"} : () -> i64
      %bb1e9_8 = "braid.zext"(%bb1e9_9) {bits = 32 : i64} : (i64) -> i64
      %bb1e9_16 = "braid.add"(%bb1e9_0, %bb1e9_8) : (i64, i64) -> i64
      %bb1e9_17 = "braid.zext"(%bb1e9_16) {bits = 32 : i64} : (i64) -> i64
      %bb1e9_18 = "braid.ult"(%bb1e9_17, %bb1e9_0) : (i64, i64) -> i64
      "braid.setf"(%bb1e9_18) {flag = "cf"} : (i64) -> ()
      %bb1e9_19 = "braid.xor"(%bb1e9_0, %bb1e9_17) : (i64, i64) -> i64
      %bb1e9_20 = "braid.xor"(%bb1e9_8, %bb1e9_17) : (i64, i64) -> i64
      %bb1e9_21 = "braid.and"(%bb1e9_19, %bb1e9_20) : (i64, i64) -> i64
      %bb1e9_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1e9_23 = "braid.and"(%bb1e9_21, %bb1e9_22) : (i64, i64) -> i64
      "braid.setf"(%bb1e9_23) {flag = "of"} : (i64) -> ()
      %bb1e9_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1e9_24) {flag = "af"} : (i64) -> ()
      %bb1e9_32 = "braid.zext"(%bb1e9_17) {bits = 8 : i64} : (i64) -> i64
      %bb1e9_33 = "braid.popcnt"(%bb1e9_32) : (i64) -> i64
      %bb1e9_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1e9_35 = "braid.and"(%bb1e9_33, %bb1e9_34) : (i64, i64) -> i64
      %bb1e9_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e9_37 = "braid.eq"(%bb1e9_35, %bb1e9_36) : (i64, i64) -> i64
      "braid.setf"(%bb1e9_37) {flag = "pf"} : (i64) -> ()
      %bb1e9_38 = "braid.eq"(%bb1e9_17, %bb1e9_36) : (i64, i64) -> i64
      "braid.setf"(%bb1e9_38) {flag = "zf"} : (i64) -> ()
      %bb1e9_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1e9_40 = "braid.and"(%bb1e9_17, %bb1e9_39) : (i64, i64) -> i64
      "braid.setf"(%bb1e9_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1e9_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb1ed] : () -> ()
    ^bb1ed:  // 0x40122d
      %bb1ed_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb1ed_0 = "braid.zext"(%bb1ed_1) {bits = 32 : i64} : (i64) -> i64
      %bb1ed_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb1ed_10 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb1ed_8 = "braid.add"(%bb1ed_9, %bb1ed_10) : (i64, i64) -> i64
      "braid.store"(%bb1ed_8, %bb1ed_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1f1] : () -> ()
    ^bb1f1:  // 0x401231
      %bb1f1_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1f1_3 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb1f1_1 = "braid.add"(%bb1f1_2, %bb1f1_3) : (i64, i64) -> i64
      %bb1f1_0 = "braid.load"(%bb1f1_1) {bytes = 4 : i64} : (i64) -> i64
      %bb1f1_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb1f1_8 = "braid.zext"(%bb1f1_9) {bits = 32 : i64} : (i64) -> i64
      %bb1f1_16 = "braid.add"(%bb1f1_0, %bb1f1_8) : (i64, i64) -> i64
      %bb1f1_17 = "braid.zext"(%bb1f1_16) {bits = 32 : i64} : (i64) -> i64
      %bb1f1_18 = "braid.ult"(%bb1f1_17, %bb1f1_0) : (i64, i64) -> i64
      "braid.setf"(%bb1f1_18) {flag = "cf"} : (i64) -> ()
      %bb1f1_19 = "braid.xor"(%bb1f1_0, %bb1f1_17) : (i64, i64) -> i64
      %bb1f1_20 = "braid.xor"(%bb1f1_8, %bb1f1_17) : (i64, i64) -> i64
      %bb1f1_21 = "braid.and"(%bb1f1_19, %bb1f1_20) : (i64, i64) -> i64
      %bb1f1_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1f1_23 = "braid.and"(%bb1f1_21, %bb1f1_22) : (i64, i64) -> i64
      "braid.setf"(%bb1f1_23) {flag = "of"} : (i64) -> ()
      %bb1f1_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1f1_24) {flag = "af"} : (i64) -> ()
      %bb1f1_32 = "braid.zext"(%bb1f1_17) {bits = 8 : i64} : (i64) -> i64
      %bb1f1_33 = "braid.popcnt"(%bb1f1_32) : (i64) -> i64
      %bb1f1_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1f1_35 = "braid.and"(%bb1f1_33, %bb1f1_34) : (i64, i64) -> i64
      %bb1f1_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1f1_37 = "braid.eq"(%bb1f1_35, %bb1f1_36) : (i64, i64) -> i64
      "braid.setf"(%bb1f1_37) {flag = "pf"} : (i64) -> ()
      %bb1f1_38 = "braid.eq"(%bb1f1_17, %bb1f1_36) : (i64, i64) -> i64
      "braid.setf"(%bb1f1_38) {flag = "zf"} : (i64) -> ()
      %bb1f1_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1f1_40 = "braid.and"(%bb1f1_17, %bb1f1_39) : (i64, i64) -> i64
      "braid.setf"(%bb1f1_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1f1_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb1f4] : () -> ()
    ^bb1f4:  // 0x401234
      %bb1f4_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb1f4_0 = "braid.zext"(%bb1f4_1) {bits = 32 : i64} : (i64) -> i64
      %bb1f4_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb1f4_10 = "braid.const"() {value = 28 : i64} : () -> i64
      %bb1f4_8 = "braid.add"(%bb1f4_9, %bb1f4_10) : (i64, i64) -> i64
      "braid.store"(%bb1f4_8, %bb1f4_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1f8] : () -> ()
    ^bb1f8:  // 0x401238
      %bb1f8_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1f8_3 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb1f8_1 = "braid.add"(%bb1f8_2, %bb1f8_3) : (i64, i64) -> i64
      %bb1f8_0 = "braid.load"(%bb1f8_1) {bytes = 4 : i64} : (i64) -> i64
      %bb1f8_9 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb1f8_8 = "braid.zext"(%bb1f8_9) {bits = 32 : i64} : (i64) -> i64
      %bb1f8_16 = "braid.add"(%bb1f8_0, %bb1f8_8) : (i64, i64) -> i64
      %bb1f8_17 = "braid.zext"(%bb1f8_16) {bits = 32 : i64} : (i64) -> i64
      %bb1f8_18 = "braid.ult"(%bb1f8_17, %bb1f8_0) : (i64, i64) -> i64
      "braid.setf"(%bb1f8_18) {flag = "cf"} : (i64) -> ()
      %bb1f8_19 = "braid.xor"(%bb1f8_0, %bb1f8_17) : (i64, i64) -> i64
      %bb1f8_20 = "braid.xor"(%bb1f8_8, %bb1f8_17) : (i64, i64) -> i64
      %bb1f8_21 = "braid.and"(%bb1f8_19, %bb1f8_20) : (i64, i64) -> i64
      %bb1f8_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1f8_23 = "braid.and"(%bb1f8_21, %bb1f8_22) : (i64, i64) -> i64
      "braid.setf"(%bb1f8_23) {flag = "of"} : (i64) -> ()
      %bb1f8_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1f8_24) {flag = "af"} : (i64) -> ()
      %bb1f8_32 = "braid.zext"(%bb1f8_17) {bits = 8 : i64} : (i64) -> i64
      %bb1f8_33 = "braid.popcnt"(%bb1f8_32) : (i64) -> i64
      %bb1f8_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1f8_35 = "braid.and"(%bb1f8_33, %bb1f8_34) : (i64, i64) -> i64
      %bb1f8_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1f8_37 = "braid.eq"(%bb1f8_35, %bb1f8_36) : (i64, i64) -> i64
      "braid.setf"(%bb1f8_37) {flag = "pf"} : (i64) -> ()
      %bb1f8_38 = "braid.eq"(%bb1f8_17, %bb1f8_36) : (i64, i64) -> i64
      "braid.setf"(%bb1f8_38) {flag = "zf"} : (i64) -> ()
      %bb1f8_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1f8_40 = "braid.and"(%bb1f8_17, %bb1f8_39) : (i64, i64) -> i64
      "braid.setf"(%bb1f8_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1f8_17) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb1fb] : () -> ()
    ^bb1fb:  // 0x40123b
      %bb1fb_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb1fb_0 = "braid.zext"(%bb1fb_1) {bits = 32 : i64} : (i64) -> i64
      %bb1fb_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb1fb_10 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb1fb_8 = "braid.add"(%bb1fb_9, %bb1fb_10) : (i64, i64) -> i64
      "braid.store"(%bb1fb_8, %bb1fb_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1ff] : () -> ()
    ^bb1ff:  // 0x40123f
      %bb1ff_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb1ff_3 = "braid.const"() {value = 36 : i64} : () -> i64
      %bb1ff_1 = "braid.add"(%bb1ff_2, %bb1ff_3) : (i64, i64) -> i64
      %bb1ff_0 = "braid.load"(%bb1ff_1) {bytes = 4 : i64} : (i64) -> i64
      %bb1ff_9 = "braid.get"() {reg = "r11"} : () -> i64
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
      "braid.set"(%bb1ff_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb203] : () -> ()
    ^bb203:  // 0x401243
      %bb203_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb203_0 = "braid.zext"(%bb203_1) {bits = 32 : i64} : (i64) -> i64
      %bb203_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb203_10 = "braid.const"() {value = 36 : i64} : () -> i64
      %bb203_8 = "braid.add"(%bb203_9, %bb203_10) : (i64, i64) -> i64
      "braid.store"(%bb203_8, %bb203_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb207] : () -> ()
    ^bb207:  // 0x401247
      %bb207_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb207_3 = "braid.const"() {value = -24 : i64} : () -> i64
      %bb207_1 = "braid.add"(%bb207_2, %bb207_3) : (i64, i64) -> i64
      %bb207_0 = "braid.load"(%bb207_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb207_0) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb20b] : () -> ()
    ^bb20b:  // 0x40124b
      %bb20b_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb20b_3 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb20b_1 = "braid.add"(%bb20b_2, %bb20b_3) : (i64, i64) -> i64
      %bb20b_0 = "braid.load"(%bb20b_1) {bytes = 4 : i64} : (i64) -> i64
      %bb20b_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb20b_8 = "braid.zext"(%bb20b_9) {bits = 32 : i64} : (i64) -> i64
      %bb20b_16 = "braid.add"(%bb20b_0, %bb20b_8) : (i64, i64) -> i64
      %bb20b_17 = "braid.zext"(%bb20b_16) {bits = 32 : i64} : (i64) -> i64
      %bb20b_18 = "braid.ult"(%bb20b_17, %bb20b_0) : (i64, i64) -> i64
      "braid.setf"(%bb20b_18) {flag = "cf"} : (i64) -> ()
      %bb20b_19 = "braid.xor"(%bb20b_0, %bb20b_17) : (i64, i64) -> i64
      %bb20b_20 = "braid.xor"(%bb20b_8, %bb20b_17) : (i64, i64) -> i64
      %bb20b_21 = "braid.and"(%bb20b_19, %bb20b_20) : (i64, i64) -> i64
      %bb20b_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb20b_23 = "braid.and"(%bb20b_21, %bb20b_22) : (i64, i64) -> i64
      "braid.setf"(%bb20b_23) {flag = "of"} : (i64) -> ()
      %bb20b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb20b_24) {flag = "af"} : (i64) -> ()
      %bb20b_32 = "braid.zext"(%bb20b_17) {bits = 8 : i64} : (i64) -> i64
      %bb20b_33 = "braid.popcnt"(%bb20b_32) : (i64) -> i64
      %bb20b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb20b_35 = "braid.and"(%bb20b_33, %bb20b_34) : (i64, i64) -> i64
      %bb20b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb20b_37 = "braid.eq"(%bb20b_35, %bb20b_36) : (i64, i64) -> i64
      "braid.setf"(%bb20b_37) {flag = "pf"} : (i64) -> ()
      %bb20b_38 = "braid.eq"(%bb20b_17, %bb20b_36) : (i64, i64) -> i64
      "braid.setf"(%bb20b_38) {flag = "zf"} : (i64) -> ()
      %bb20b_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb20b_40 = "braid.and"(%bb20b_17, %bb20b_39) : (i64, i64) -> i64
      "braid.setf"(%bb20b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb20b_17) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb20e] : () -> ()
    ^bb20e:  // 0x40124e
      %bb20e_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb20e_0 = "braid.zext"(%bb20e_1) {bits = 32 : i64} : (i64) -> i64
      %bb20e_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb20e_10 = "braid.const"() {value = 40 : i64} : () -> i64
      %bb20e_8 = "braid.add"(%bb20e_9, %bb20e_10) : (i64, i64) -> i64
      "braid.store"(%bb20e_8, %bb20e_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb212] : () -> ()
    ^bb212:  // 0x401252
      %bb212_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb212_3 = "braid.const"() {value = -28 : i64} : () -> i64
      %bb212_1 = "braid.add"(%bb212_2, %bb212_3) : (i64, i64) -> i64
      %bb212_0 = "braid.load"(%bb212_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb212_0) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb216] : () -> ()
    ^bb216:  // 0x401256
      %bb216_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb216_3 = "braid.const"() {value = 44 : i64} : () -> i64
      %bb216_1 = "braid.add"(%bb216_2, %bb216_3) : (i64, i64) -> i64
      %bb216_0 = "braid.load"(%bb216_1) {bytes = 4 : i64} : (i64) -> i64
      %bb216_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb216_8 = "braid.zext"(%bb216_9) {bits = 32 : i64} : (i64) -> i64
      %bb216_16 = "braid.add"(%bb216_0, %bb216_8) : (i64, i64) -> i64
      %bb216_17 = "braid.zext"(%bb216_16) {bits = 32 : i64} : (i64) -> i64
      %bb216_18 = "braid.ult"(%bb216_17, %bb216_0) : (i64, i64) -> i64
      "braid.setf"(%bb216_18) {flag = "cf"} : (i64) -> ()
      %bb216_19 = "braid.xor"(%bb216_0, %bb216_17) : (i64, i64) -> i64
      %bb216_20 = "braid.xor"(%bb216_8, %bb216_17) : (i64, i64) -> i64
      %bb216_21 = "braid.and"(%bb216_19, %bb216_20) : (i64, i64) -> i64
      %bb216_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb216_23 = "braid.and"(%bb216_21, %bb216_22) : (i64, i64) -> i64
      "braid.setf"(%bb216_23) {flag = "of"} : (i64) -> ()
      %bb216_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb216_24) {flag = "af"} : (i64) -> ()
      %bb216_32 = "braid.zext"(%bb216_17) {bits = 8 : i64} : (i64) -> i64
      %bb216_33 = "braid.popcnt"(%bb216_32) : (i64) -> i64
      %bb216_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb216_35 = "braid.and"(%bb216_33, %bb216_34) : (i64, i64) -> i64
      %bb216_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb216_37 = "braid.eq"(%bb216_35, %bb216_36) : (i64, i64) -> i64
      "braid.setf"(%bb216_37) {flag = "pf"} : (i64) -> ()
      %bb216_38 = "braid.eq"(%bb216_17, %bb216_36) : (i64, i64) -> i64
      "braid.setf"(%bb216_38) {flag = "zf"} : (i64) -> ()
      %bb216_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb216_40 = "braid.and"(%bb216_17, %bb216_39) : (i64, i64) -> i64
      "braid.setf"(%bb216_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb216_17) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb219] : () -> ()
    ^bb219:  // 0x401259
      %bb219_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb219_0 = "braid.zext"(%bb219_1) {bits = 32 : i64} : (i64) -> i64
      %bb219_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb219_10 = "braid.const"() {value = 44 : i64} : () -> i64
      %bb219_8 = "braid.add"(%bb219_9, %bb219_10) : (i64, i64) -> i64
      "braid.store"(%bb219_8, %bb219_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb21d] : () -> ()
    ^bb21d:  // 0x40125d
      %bb21d_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb21d_3 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb21d_1 = "braid.add"(%bb21d_2, %bb21d_3) : (i64, i64) -> i64
      %bb21d_0 = "braid.load"(%bb21d_1) {bytes = 4 : i64} : (i64) -> i64
      %bb21d_9 = "braid.get"() {reg = "r8"} : () -> i64
      %bb21d_8 = "braid.zext"(%bb21d_9) {bits = 32 : i64} : (i64) -> i64
      %bb21d_16 = "braid.add"(%bb21d_0, %bb21d_8) : (i64, i64) -> i64
      %bb21d_17 = "braid.zext"(%bb21d_16) {bits = 32 : i64} : (i64) -> i64
      %bb21d_18 = "braid.ult"(%bb21d_17, %bb21d_0) : (i64, i64) -> i64
      "braid.setf"(%bb21d_18) {flag = "cf"} : (i64) -> ()
      %bb21d_19 = "braid.xor"(%bb21d_0, %bb21d_17) : (i64, i64) -> i64
      %bb21d_20 = "braid.xor"(%bb21d_8, %bb21d_17) : (i64, i64) -> i64
      %bb21d_21 = "braid.and"(%bb21d_19, %bb21d_20) : (i64, i64) -> i64
      %bb21d_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb21d_23 = "braid.and"(%bb21d_21, %bb21d_22) : (i64, i64) -> i64
      "braid.setf"(%bb21d_23) {flag = "of"} : (i64) -> ()
      %bb21d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb21d_24) {flag = "af"} : (i64) -> ()
      %bb21d_32 = "braid.zext"(%bb21d_17) {bits = 8 : i64} : (i64) -> i64
      %bb21d_33 = "braid.popcnt"(%bb21d_32) : (i64) -> i64
      %bb21d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb21d_35 = "braid.and"(%bb21d_33, %bb21d_34) : (i64, i64) -> i64
      %bb21d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb21d_37 = "braid.eq"(%bb21d_35, %bb21d_36) : (i64, i64) -> i64
      "braid.setf"(%bb21d_37) {flag = "pf"} : (i64) -> ()
      %bb21d_38 = "braid.eq"(%bb21d_17, %bb21d_36) : (i64, i64) -> i64
      "braid.setf"(%bb21d_38) {flag = "zf"} : (i64) -> ()
      %bb21d_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb21d_40 = "braid.and"(%bb21d_17, %bb21d_39) : (i64, i64) -> i64
      "braid.setf"(%bb21d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb21d_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb221] : () -> ()
    ^bb221:  // 0x401261
      %bb221_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb221_0 = "braid.zext"(%bb221_1) {bits = 32 : i64} : (i64) -> i64
      %bb221_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb221_10 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb221_8 = "braid.add"(%bb221_9, %bb221_10) : (i64, i64) -> i64
      "braid.store"(%bb221_8, %bb221_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb225] : () -> ()
    ^bb225:  // 0x401265
      %bb225_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb225_3 = "braid.const"() {value = 52 : i64} : () -> i64
      %bb225_1 = "braid.add"(%bb225_2, %bb225_3) : (i64, i64) -> i64
      %bb225_0 = "braid.load"(%bb225_1) {bytes = 4 : i64} : (i64) -> i64
      %bb225_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb225_8 = "braid.zext"(%bb225_9) {bits = 32 : i64} : (i64) -> i64
      %bb225_16 = "braid.add"(%bb225_0, %bb225_8) : (i64, i64) -> i64
      %bb225_17 = "braid.zext"(%bb225_16) {bits = 32 : i64} : (i64) -> i64
      %bb225_18 = "braid.ult"(%bb225_17, %bb225_0) : (i64, i64) -> i64
      "braid.setf"(%bb225_18) {flag = "cf"} : (i64) -> ()
      %bb225_19 = "braid.xor"(%bb225_0, %bb225_17) : (i64, i64) -> i64
      %bb225_20 = "braid.xor"(%bb225_8, %bb225_17) : (i64, i64) -> i64
      %bb225_21 = "braid.and"(%bb225_19, %bb225_20) : (i64, i64) -> i64
      %bb225_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb225_23 = "braid.and"(%bb225_21, %bb225_22) : (i64, i64) -> i64
      "braid.setf"(%bb225_23) {flag = "of"} : (i64) -> ()
      %bb225_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb225_24) {flag = "af"} : (i64) -> ()
      %bb225_32 = "braid.zext"(%bb225_17) {bits = 8 : i64} : (i64) -> i64
      %bb225_33 = "braid.popcnt"(%bb225_32) : (i64) -> i64
      %bb225_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb225_35 = "braid.and"(%bb225_33, %bb225_34) : (i64, i64) -> i64
      %bb225_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb225_37 = "braid.eq"(%bb225_35, %bb225_36) : (i64, i64) -> i64
      "braid.setf"(%bb225_37) {flag = "pf"} : (i64) -> ()
      %bb225_38 = "braid.eq"(%bb225_17, %bb225_36) : (i64, i64) -> i64
      "braid.setf"(%bb225_38) {flag = "zf"} : (i64) -> ()
      %bb225_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb225_40 = "braid.and"(%bb225_17, %bb225_39) : (i64, i64) -> i64
      "braid.setf"(%bb225_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb225_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb228] : () -> ()
    ^bb228:  // 0x401268
      %bb228_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb228_0 = "braid.zext"(%bb228_1) {bits = 32 : i64} : (i64) -> i64
      %bb228_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb228_10 = "braid.const"() {value = 52 : i64} : () -> i64
      %bb228_8 = "braid.add"(%bb228_9, %bb228_10) : (i64, i64) -> i64
      "braid.store"(%bb228_8, %bb228_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb22c] : () -> ()
    ^bb22c:  // 0x40126c
      %bb22c_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb22c_3 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb22c_1 = "braid.add"(%bb22c_2, %bb22c_3) : (i64, i64) -> i64
      %bb22c_0 = "braid.load"(%bb22c_1) {bytes = 4 : i64} : (i64) -> i64
      %bb22c_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb22c_8 = "braid.zext"(%bb22c_9) {bits = 32 : i64} : (i64) -> i64
      %bb22c_16 = "braid.add"(%bb22c_0, %bb22c_8) : (i64, i64) -> i64
      %bb22c_17 = "braid.zext"(%bb22c_16) {bits = 32 : i64} : (i64) -> i64
      %bb22c_18 = "braid.ult"(%bb22c_17, %bb22c_0) : (i64, i64) -> i64
      "braid.setf"(%bb22c_18) {flag = "cf"} : (i64) -> ()
      %bb22c_19 = "braid.xor"(%bb22c_0, %bb22c_17) : (i64, i64) -> i64
      %bb22c_20 = "braid.xor"(%bb22c_8, %bb22c_17) : (i64, i64) -> i64
      %bb22c_21 = "braid.and"(%bb22c_19, %bb22c_20) : (i64, i64) -> i64
      %bb22c_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb22c_23 = "braid.and"(%bb22c_21, %bb22c_22) : (i64, i64) -> i64
      "braid.setf"(%bb22c_23) {flag = "of"} : (i64) -> ()
      %bb22c_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb22c_24) {flag = "af"} : (i64) -> ()
      %bb22c_32 = "braid.zext"(%bb22c_17) {bits = 8 : i64} : (i64) -> i64
      %bb22c_33 = "braid.popcnt"(%bb22c_32) : (i64) -> i64
      %bb22c_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb22c_35 = "braid.and"(%bb22c_33, %bb22c_34) : (i64, i64) -> i64
      %bb22c_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb22c_37 = "braid.eq"(%bb22c_35, %bb22c_36) : (i64, i64) -> i64
      "braid.setf"(%bb22c_37) {flag = "pf"} : (i64) -> ()
      %bb22c_38 = "braid.eq"(%bb22c_17, %bb22c_36) : (i64, i64) -> i64
      "braid.setf"(%bb22c_38) {flag = "zf"} : (i64) -> ()
      %bb22c_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb22c_40 = "braid.and"(%bb22c_17, %bb22c_39) : (i64, i64) -> i64
      "braid.setf"(%bb22c_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb22c_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb22f] : () -> ()
    ^bb22f:  // 0x40126f
      %bb22f_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb22f_0 = "braid.zext"(%bb22f_1) {bits = 32 : i64} : (i64) -> i64
      %bb22f_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb22f_10 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb22f_8 = "braid.add"(%bb22f_9, %bb22f_10) : (i64, i64) -> i64
      "braid.store"(%bb22f_8, %bb22f_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb233] : () -> ()
    ^bb233:  // 0x401273
      %bb233_2 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb233_3 = "braid.const"() {value = 60 : i64} : () -> i64
      %bb233_1 = "braid.add"(%bb233_2, %bb233_3) : (i64, i64) -> i64
      %bb233_0 = "braid.load"(%bb233_1) {bytes = 4 : i64} : (i64) -> i64
      %bb233_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb233_8 = "braid.zext"(%bb233_9) {bits = 32 : i64} : (i64) -> i64
      %bb233_16 = "braid.add"(%bb233_0, %bb233_8) : (i64, i64) -> i64
      %bb233_17 = "braid.zext"(%bb233_16) {bits = 32 : i64} : (i64) -> i64
      %bb233_18 = "braid.ult"(%bb233_17, %bb233_0) : (i64, i64) -> i64
      "braid.setf"(%bb233_18) {flag = "cf"} : (i64) -> ()
      %bb233_19 = "braid.xor"(%bb233_0, %bb233_17) : (i64, i64) -> i64
      %bb233_20 = "braid.xor"(%bb233_8, %bb233_17) : (i64, i64) -> i64
      %bb233_21 = "braid.and"(%bb233_19, %bb233_20) : (i64, i64) -> i64
      %bb233_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb233_23 = "braid.and"(%bb233_21, %bb233_22) : (i64, i64) -> i64
      "braid.setf"(%bb233_23) {flag = "of"} : (i64) -> ()
      %bb233_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb233_24) {flag = "af"} : (i64) -> ()
      %bb233_32 = "braid.zext"(%bb233_17) {bits = 8 : i64} : (i64) -> i64
      %bb233_33 = "braid.popcnt"(%bb233_32) : (i64) -> i64
      %bb233_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb233_35 = "braid.and"(%bb233_33, %bb233_34) : (i64, i64) -> i64
      %bb233_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb233_37 = "braid.eq"(%bb233_35, %bb233_36) : (i64, i64) -> i64
      "braid.setf"(%bb233_37) {flag = "pf"} : (i64) -> ()
      %bb233_38 = "braid.eq"(%bb233_17, %bb233_36) : (i64, i64) -> i64
      "braid.setf"(%bb233_38) {flag = "zf"} : (i64) -> ()
      %bb233_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb233_40 = "braid.and"(%bb233_17, %bb233_39) : (i64, i64) -> i64
      "braid.setf"(%bb233_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb233_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb236] : () -> ()
    ^bb236:  // 0x401276
      %bb236_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb236_0 = "braid.zext"(%bb236_1) {bits = 32 : i64} : (i64) -> i64
      %bb236_9 = "braid.get"() {reg = "r10"} : () -> i64
      %bb236_10 = "braid.const"() {value = 60 : i64} : () -> i64
      %bb236_8 = "braid.add"(%bb236_9, %bb236_10) : (i64, i64) -> i64
      "braid.store"(%bb236_8, %bb236_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb23a] : () -> ()
    ^bb23a:  // 0x40127a
      %bb23a_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb23a_1 = "braid.load"(%bb23a_0) {bytes = 8 : i64} : (i64) -> i64
      %bb23a_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb23a_3 = "braid.add"(%bb23a_0, %bb23a_2) : (i64, i64) -> i64
      "braid.set"(%bb23a_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb23a_1) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb23b] : () -> ()
    ^bb23b:  // 0x40127b
      %bb23b_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb23b_1 = "braid.load"(%bb23b_0) {bytes = 8 : i64} : (i64) -> i64
      %bb23b_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb23b_3 = "braid.add"(%bb23b_0, %bb23b_2) : (i64, i64) -> i64
      "braid.set"(%bb23b_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb23b_1) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb23d] : () -> ()
    ^bb23d:  // 0x40127d
      %bb23d_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb23d_1 = "braid.load"(%bb23d_0) {bytes = 8 : i64} : (i64) -> i64
      %bb23d_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb23d_3 = "braid.add"(%bb23d_0, %bb23d_2) : (i64, i64) -> i64
      "braid.set"(%bb23d_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb23d_1) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb23f] : () -> ()
    ^bb23f:  // 0x40127f
      %bb23f_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb23f_1 = "braid.load"(%bb23f_0) {bytes = 8 : i64} : (i64) -> i64
      %bb23f_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb23f_3 = "braid.add"(%bb23f_0, %bb23f_2) : (i64, i64) -> i64
      "braid.set"(%bb23f_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb23f_1) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb241] : () -> ()
    ^bb241:  // 0x401281
      %bb241_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb241_1 = "braid.load"(%bb241_0) {bytes = 8 : i64} : (i64) -> i64
      %bb241_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb241_3 = "braid.add"(%bb241_0, %bb241_2) : (i64, i64) -> i64
      "braid.set"(%bb241_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb241_1) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb243] : () -> ()
    ^bb243:  // 0x401283
      %bb243_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb243_1 = "braid.load"(%bb243_0) {bytes = 8 : i64} : (i64) -> i64
      %bb243_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb243_3 = "braid.add"(%bb243_0, %bb243_2) : (i64, i64) -> i64
      "braid.set"(%bb243_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb243_1) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb244] : () -> ()
    ^bb244:  // 0x401284
      %bb244_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb244_1 = "braid.load"(%bb244_0) {bytes = 8 : i64} : (i64) -> i64
      %bb244_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb244_3 = "braid.add"(%bb244_0, %bb244_2) : (i64, i64) -> i64
      "braid.set"(%bb244_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb244_1) : (i64) -> ()
  }) {sym_name = "chacha20_block", entry = 4198464 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
