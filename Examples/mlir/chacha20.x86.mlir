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
      %bba_10 = "braid.const"() {value = -16 : i64} : () -> i64
      %bba_8 = "braid.add"(%bba_9, %bba_10) : (i64, i64) -> i64
      "braid.store"(%bba_8, %bba_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbf] : () -> ()
    ^bbf:  // 0x40104f
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
    ^bb11:  // 0x401051
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x401060
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
    ^bb23:  // 0x401063
      %bb23_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb23_0 = "braid.zext"(%bb23_1) {bits = 32 : i64} : (i64) -> i64
      %bb23_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb23_10 = "braid.get"() {reg = "rax"} : () -> i64
      %bb23_11 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb23_12 = "braid.mul"(%bb23_10, %bb23_11) : (i64, i64) -> i64
      %bb23_13 = "braid.add"(%bb23_9, %bb23_12) : (i64, i64) -> i64
      %bb23_14 = "braid.const"() {value = -88 : i64} : () -> i64
      %bb23_8 = "braid.add"(%bb23_13, %bb23_14) : (i64, i64) -> i64
      "braid.store"(%bb23_8, %bb23_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb27] : () -> ()
    ^bb27:  // 0x401067
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
    ^bb2a:  // 0x40106a
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
    ^bb2e:  // 0x40106e
      %bb2e_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb2e_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2e_0 = "braid.eq"(%bb2e_1, %bb2e_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb2e_0)[^bb20, ^bb30] : (i64) -> ()
    ^bb30:  // 0x401070
      %bb30_0 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb30_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb30_10 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb30_8 = "braid.add"(%bb30_9, %bb30_10) : (i64, i64) -> i64
      "braid.store"(%bb30_8, %bb30_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb35] : () -> ()
    ^bb35:  // 0x401075
      %bb35_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb35_3 = "braid.const"() {value = -72 : i64} : () -> i64
      %bb35_1 = "braid.add"(%bb35_2, %bb35_3) : (i64, i64) -> i64
      %bb35_0 = "braid.load"(%bb35_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb35_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb39] : () -> ()
    ^bb39:  // 0x401079
      %bb39_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb39_3 = "braid.const"() {value = -88 : i64} : () -> i64
      %bb39_1 = "braid.add"(%bb39_2, %bb39_3) : (i64, i64) -> i64
      %bb39_0 = "braid.load"(%bb39_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb39_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb3d] : () -> ()
    ^bb3d:  // 0x40107d
      %bb3d_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb3d_0 = "braid.zext"(%bb3d_1) {bits = 32 : i64} : (i64) -> i64
      %bb3d_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb3d_10 = "braid.const"() {value = -96 : i64} : () -> i64
      %bb3d_8 = "braid.add"(%bb3d_9, %bb3d_10) : (i64, i64) -> i64
      "braid.store"(%bb3d_8, %bb3d_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb41] : () -> ()
    ^bb41:  // 0x401081
      %bb41_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb41_3 = "braid.const"() {value = -84 : i64} : () -> i64
      %bb41_1 = "braid.add"(%bb41_2, %bb41_3) : (i64, i64) -> i64
      %bb41_0 = "braid.load"(%bb41_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb41_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb45] : () -> ()
    ^bb45:  // 0x401085
      %bb45_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb45_0 = "braid.zext"(%bb45_1) {bits = 32 : i64} : (i64) -> i64
      %bb45_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb45_10 = "braid.const"() {value = -92 : i64} : () -> i64
      %bb45_8 = "braid.add"(%bb45_9, %bb45_10) : (i64, i64) -> i64
      "braid.store"(%bb45_8, %bb45_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb49] : () -> ()
    ^bb49:  // 0x401089
      %bb49_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb49_3 = "braid.const"() {value = -40 : i64} : () -> i64
      %bb49_1 = "braid.add"(%bb49_2, %bb49_3) : (i64, i64) -> i64
      %bb49_0 = "braid.load"(%bb49_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb49_0) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb4e] : () -> ()
    ^bb4e:  // 0x40108e
      %bb4e_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb4e_3 = "braid.const"() {value = -56 : i64} : () -> i64
      %bb4e_1 = "braid.add"(%bb4e_2, %bb4e_3) : (i64, i64) -> i64
      %bb4e_0 = "braid.load"(%bb4e_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb4e_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb52] : () -> ()
    ^bb52:  // 0x401092
      %bb52_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb52_3 = "braid.const"() {value = -68 : i64} : () -> i64
      %bb52_1 = "braid.add"(%bb52_2, %bb52_3) : (i64, i64) -> i64
      %bb52_0 = "braid.load"(%bb52_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb52_0) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb56] : () -> ()
    ^bb56:  // 0x401096
      %bb56_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb56_3 = "braid.const"() {value = -36 : i64} : () -> i64
      %bb56_1 = "braid.add"(%bb56_2, %bb56_3) : (i64, i64) -> i64
      %bb56_0 = "braid.load"(%bb56_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb56_0) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb5b] : () -> ()
    ^bb5b:  // 0x40109b
      %bb5b_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb5b_3 = "braid.const"() {value = -52 : i64} : () -> i64
      %bb5b_1 = "braid.add"(%bb5b_2, %bb5b_3) : (i64, i64) -> i64
      %bb5b_0 = "braid.load"(%bb5b_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb5b_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb5f] : () -> ()
    ^bb5f:  // 0x40109f
      %bb5f_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb5f_0 = "braid.zext"(%bb5f_1) {bits = 32 : i64} : (i64) -> i64
      %bb5f_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb5f_10 = "braid.const"() {value = -100 : i64} : () -> i64
      %bb5f_8 = "braid.add"(%bb5f_9, %bb5f_10) : (i64, i64) -> i64
      "braid.store"(%bb5f_8, %bb5f_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb63] : () -> ()
    ^bb63:  // 0x4010a3
      %bb63_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb63_3 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb63_1 = "braid.add"(%bb63_2, %bb63_3) : (i64, i64) -> i64
      %bb63_0 = "braid.load"(%bb63_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb63_0) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x4010a8
      %bb68_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb68_3 = "braid.const"() {value = -80 : i64} : () -> i64
      %bb68_1 = "braid.add"(%bb68_2, %bb68_3) : (i64, i64) -> i64
      %bb68_0 = "braid.load"(%bb68_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb68_0) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb6d] : () -> ()
    ^bb6d:  // 0x4010ad
      %bb6d_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb6d_3 = "braid.const"() {value = -32 : i64} : () -> i64
      %bb6d_1 = "braid.add"(%bb6d_2, %bb6d_3) : (i64, i64) -> i64
      %bb6d_0 = "braid.load"(%bb6d_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb6d_0) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb71] : () -> ()
    ^bb71:  // 0x4010b1
      %bb71_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb71_3 = "braid.const"() {value = -48 : i64} : () -> i64
      %bb71_1 = "braid.add"(%bb71_2, %bb71_3) : (i64, i64) -> i64
      %bb71_0 = "braid.load"(%bb71_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb71_0) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb75] : () -> ()
    ^bb75:  // 0x4010b5
      %bb75_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb75_3 = "braid.const"() {value = -60 : i64} : () -> i64
      %bb75_1 = "braid.add"(%bb75_2, %bb75_3) : (i64, i64) -> i64
      %bb75_0 = "braid.load"(%bb75_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb75_0) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb7a] : () -> ()
    ^bb7a:  // 0x4010ba
      %bb7a_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb7a_3 = "braid.const"() {value = -76 : i64} : () -> i64
      %bb7a_1 = "braid.add"(%bb7a_2, %bb7a_3) : (i64, i64) -> i64
      %bb7a_0 = "braid.load"(%bb7a_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb7a_0) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb7f] : () -> ()
    ^bb7f:  // 0x4010bf
      %bb7f_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb7f_3 = "braid.const"() {value = -28 : i64} : () -> i64
      %bb7f_1 = "braid.add"(%bb7f_2, %bb7f_3) : (i64, i64) -> i64
      %bb7f_0 = "braid.load"(%bb7f_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb7f_0) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x4010c4
      %bb84_0 = "braid.const"() {value = 10 : i64} : () -> i64
      "braid.set"(%bb84_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb89] : () -> ()
    ^bb89:  // 0x4010c9
      %bb89_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb89_3 = "braid.const"() {value = -44 : i64} : () -> i64
      %bb89_1 = "braid.add"(%bb89_2, %bb89_3) : (i64, i64) -> i64
      %bb89_0 = "braid.load"(%bb89_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb89_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb8d] : () -> ()
    ^bb8d:  // 0x4010cd
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x4010d0
      %bb90_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb90_0 = "braid.zext"(%bb90_1) {bits = 32 : i64} : (i64) -> i64
      %bb90_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb90_10 = "braid.const"() {value = -24 : i64} : () -> i64
      %bb90_8 = "braid.add"(%bb90_9, %bb90_10) : (i64, i64) -> i64
      "braid.store"(%bb90_8, %bb90_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb95] : () -> ()
    ^bb95:  // 0x4010d5
      %bb95_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb95_0 = "braid.zext"(%bb95_1) {bits = 32 : i64} : (i64) -> i64
      %bb95_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb95_10 = "braid.const"() {value = -20 : i64} : () -> i64
      %bb95_8 = "braid.add"(%bb95_9, %bb95_10) : (i64, i64) -> i64
      "braid.store"(%bb95_8, %bb95_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb99] : () -> ()
    ^bb99:  // 0x4010d9
      %bb99_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb99_3 = "braid.const"() {value = -96 : i64} : () -> i64
      %bb99_1 = "braid.add"(%bb99_2, %bb99_3) : (i64, i64) -> i64
      %bb99_0 = "braid.load"(%bb99_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb99_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb9e] : () -> ()
    ^bb9e:  // 0x4010de
      %bb9e_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb9e_0 = "braid.zext"(%bb9e_1) {bits = 32 : i64} : (i64) -> i64
      %bb9e_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb9e_8 = "braid.zext"(%bb9e_9) {bits = 32 : i64} : (i64) -> i64
      %bb9e_16 = "braid.add"(%bb9e_0, %bb9e_8) : (i64, i64) -> i64
      %bb9e_17 = "braid.zext"(%bb9e_16) {bits = 32 : i64} : (i64) -> i64
      %bb9e_18 = "braid.ult"(%bb9e_17, %bb9e_0) : (i64, i64) -> i64
      "braid.setf"(%bb9e_18) {flag = "cf"} : (i64) -> ()
      %bb9e_19 = "braid.xor"(%bb9e_0, %bb9e_17) : (i64, i64) -> i64
      %bb9e_20 = "braid.xor"(%bb9e_8, %bb9e_17) : (i64, i64) -> i64
      %bb9e_21 = "braid.and"(%bb9e_19, %bb9e_20) : (i64, i64) -> i64
      %bb9e_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb9e_23 = "braid.and"(%bb9e_21, %bb9e_22) : (i64, i64) -> i64
      "braid.setf"(%bb9e_23) {flag = "of"} : (i64) -> ()
      %bb9e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb9e_24) {flag = "af"} : (i64) -> ()
      %bb9e_32 = "braid.zext"(%bb9e_17) {bits = 8 : i64} : (i64) -> i64
      %bb9e_33 = "braid.popcnt"(%bb9e_32) : (i64) -> i64
      %bb9e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb9e_35 = "braid.and"(%bb9e_33, %bb9e_34) : (i64, i64) -> i64
      %bb9e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9e_37 = "braid.eq"(%bb9e_35, %bb9e_36) : (i64, i64) -> i64
      "braid.setf"(%bb9e_37) {flag = "pf"} : (i64) -> ()
      %bb9e_38 = "braid.eq"(%bb9e_17, %bb9e_36) : (i64, i64) -> i64
      "braid.setf"(%bb9e_38) {flag = "zf"} : (i64) -> ()
      %bb9e_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb9e_40 = "braid.and"(%bb9e_17, %bb9e_39) : (i64, i64) -> i64
      "braid.setf"(%bb9e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb9e_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bba1] : () -> ()
    ^bba1:  // 0x4010e1
      %bba1_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bba1_0 = "braid.zext"(%bba1_1) {bits = 32 : i64} : (i64) -> i64
      %bba1_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bba1_8 = "braid.zext"(%bba1_9) {bits = 32 : i64} : (i64) -> i64
      %bba1_16 = "braid.xor"(%bba1_0, %bba1_8) : (i64, i64) -> i64
      %bba1_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bba1_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bba1_17) {flag = "of"} : (i64) -> ()
      %bba1_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bba1_24) {flag = "af"} : (i64) -> ()
      %bba1_32 = "braid.zext"(%bba1_16) {bits = 8 : i64} : (i64) -> i64
      %bba1_33 = "braid.popcnt"(%bba1_32) : (i64) -> i64
      %bba1_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bba1_35 = "braid.and"(%bba1_33, %bba1_34) : (i64, i64) -> i64
      %bba1_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba1_37 = "braid.eq"(%bba1_35, %bba1_36) : (i64, i64) -> i64
      "braid.setf"(%bba1_37) {flag = "pf"} : (i64) -> ()
      %bba1_38 = "braid.eq"(%bba1_16, %bba1_36) : (i64, i64) -> i64
      "braid.setf"(%bba1_38) {flag = "zf"} : (i64) -> ()
      %bba1_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bba1_40 = "braid.and"(%bba1_16, %bba1_39) : (i64, i64) -> i64
      "braid.setf"(%bba1_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bba1_16) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bba4] : () -> ()
    ^bba4:  // 0x4010e4
      %bba4_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bba4_0 = "braid.zext"(%bba4_1) {bits = 32 : i64} : (i64) -> i64
      %bba4_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bba4_13 = "braid.shl"(%bba4_0, %bba4_12) : (i64, i64) -> i64
      %bba4_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bba4_15 = "braid.lshr"(%bba4_0, %bba4_14) : (i64, i64) -> i64
      %bba4_16 = "braid.or"(%bba4_13, %bba4_15) : (i64, i64) -> i64
      %bba4_17 = "braid.zext"(%bba4_16) {bits = 32 : i64} : (i64) -> i64
      %bba4_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bba4_19 = "braid.and"(%bba4_17, %bba4_18) : (i64, i64) -> i64
      "braid.setf"(%bba4_19) {flag = "cf"} : (i64) -> ()
      %bba4_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bba4_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bba4_17) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x4010e8
      %bba8_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bba8_0 = "braid.zext"(%bba8_1) {bits = 32 : i64} : (i64) -> i64
      %bba8_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bba8_8 = "braid.zext"(%bba8_9) {bits = 32 : i64} : (i64) -> i64
      %bba8_16 = "braid.add"(%bba8_0, %bba8_8) : (i64, i64) -> i64
      %bba8_17 = "braid.zext"(%bba8_16) {bits = 32 : i64} : (i64) -> i64
      %bba8_18 = "braid.ult"(%bba8_17, %bba8_0) : (i64, i64) -> i64
      "braid.setf"(%bba8_18) {flag = "cf"} : (i64) -> ()
      %bba8_19 = "braid.xor"(%bba8_0, %bba8_17) : (i64, i64) -> i64
      %bba8_20 = "braid.xor"(%bba8_8, %bba8_17) : (i64, i64) -> i64
      %bba8_21 = "braid.and"(%bba8_19, %bba8_20) : (i64, i64) -> i64
      %bba8_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bba8_23 = "braid.and"(%bba8_21, %bba8_22) : (i64, i64) -> i64
      "braid.setf"(%bba8_23) {flag = "of"} : (i64) -> ()
      %bba8_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bba8_24) {flag = "af"} : (i64) -> ()
      %bba8_32 = "braid.zext"(%bba8_17) {bits = 8 : i64} : (i64) -> i64
      %bba8_33 = "braid.popcnt"(%bba8_32) : (i64) -> i64
      %bba8_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bba8_35 = "braid.and"(%bba8_33, %bba8_34) : (i64, i64) -> i64
      %bba8_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba8_37 = "braid.eq"(%bba8_35, %bba8_36) : (i64, i64) -> i64
      "braid.setf"(%bba8_37) {flag = "pf"} : (i64) -> ()
      %bba8_38 = "braid.eq"(%bba8_17, %bba8_36) : (i64, i64) -> i64
      "braid.setf"(%bba8_38) {flag = "zf"} : (i64) -> ()
      %bba8_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bba8_40 = "braid.and"(%bba8_17, %bba8_39) : (i64, i64) -> i64
      "braid.setf"(%bba8_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bba8_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbab] : () -> ()
    ^bbab:  // 0x4010eb
      %bbab_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbab_0 = "braid.zext"(%bbab_1) {bits = 32 : i64} : (i64) -> i64
      %bbab_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bbab_8 = "braid.zext"(%bbab_9) {bits = 32 : i64} : (i64) -> i64
      %bbab_16 = "braid.xor"(%bbab_0, %bbab_8) : (i64, i64) -> i64
      %bbab_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbab_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbab_17) {flag = "of"} : (i64) -> ()
      %bbab_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbab_24) {flag = "af"} : (i64) -> ()
      %bbab_32 = "braid.zext"(%bbab_16) {bits = 8 : i64} : (i64) -> i64
      %bbab_33 = "braid.popcnt"(%bbab_32) : (i64) -> i64
      %bbab_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbab_35 = "braid.and"(%bbab_33, %bbab_34) : (i64, i64) -> i64
      %bbab_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbab_37 = "braid.eq"(%bbab_35, %bbab_36) : (i64, i64) -> i64
      "braid.setf"(%bbab_37) {flag = "pf"} : (i64) -> ()
      %bbab_38 = "braid.eq"(%bbab_16, %bbab_36) : (i64, i64) -> i64
      "braid.setf"(%bbab_38) {flag = "zf"} : (i64) -> ()
      %bbab_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbab_40 = "braid.and"(%bbab_16, %bbab_39) : (i64, i64) -> i64
      "braid.setf"(%bbab_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbab_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbad] : () -> ()
    ^bbad:  // 0x4010ed
      %bbad_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbad_0 = "braid.zext"(%bbad_1) {bits = 32 : i64} : (i64) -> i64
      %bbad_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bbad_13 = "braid.shl"(%bbad_0, %bbad_12) : (i64, i64) -> i64
      %bbad_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bbad_15 = "braid.lshr"(%bbad_0, %bbad_14) : (i64, i64) -> i64
      %bbad_16 = "braid.or"(%bbad_13, %bbad_15) : (i64, i64) -> i64
      %bbad_17 = "braid.zext"(%bbad_16) {bits = 32 : i64} : (i64) -> i64
      %bbad_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbad_19 = "braid.and"(%bbad_17, %bbad_18) : (i64, i64) -> i64
      "braid.setf"(%bbad_19) {flag = "cf"} : (i64) -> ()
      %bbad_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbad_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbad_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbb0] : () -> ()
    ^bbb0:  // 0x4010f0
      %bbb0_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbb0_0 = "braid.zext"(%bbb0_1) {bits = 32 : i64} : (i64) -> i64
      %bbb0_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bbb0_8 = "braid.zext"(%bbb0_9) {bits = 32 : i64} : (i64) -> i64
      %bbb0_16 = "braid.add"(%bbb0_0, %bbb0_8) : (i64, i64) -> i64
      %bbb0_17 = "braid.zext"(%bbb0_16) {bits = 32 : i64} : (i64) -> i64
      %bbb0_18 = "braid.ult"(%bbb0_17, %bbb0_0) : (i64, i64) -> i64
      "braid.setf"(%bbb0_18) {flag = "cf"} : (i64) -> ()
      %bbb0_19 = "braid.xor"(%bbb0_0, %bbb0_17) : (i64, i64) -> i64
      %bbb0_20 = "braid.xor"(%bbb0_8, %bbb0_17) : (i64, i64) -> i64
      %bbb0_21 = "braid.and"(%bbb0_19, %bbb0_20) : (i64, i64) -> i64
      %bbb0_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbb0_23 = "braid.and"(%bbb0_21, %bbb0_22) : (i64, i64) -> i64
      "braid.setf"(%bbb0_23) {flag = "of"} : (i64) -> ()
      %bbb0_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbb0_24) {flag = "af"} : (i64) -> ()
      %bbb0_32 = "braid.zext"(%bbb0_17) {bits = 8 : i64} : (i64) -> i64
      %bbb0_33 = "braid.popcnt"(%bbb0_32) : (i64) -> i64
      %bbb0_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbb0_35 = "braid.and"(%bbb0_33, %bbb0_34) : (i64, i64) -> i64
      %bbb0_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb0_37 = "braid.eq"(%bbb0_35, %bbb0_36) : (i64, i64) -> i64
      "braid.setf"(%bbb0_37) {flag = "pf"} : (i64) -> ()
      %bbb0_38 = "braid.eq"(%bbb0_17, %bbb0_36) : (i64, i64) -> i64
      "braid.setf"(%bbb0_38) {flag = "zf"} : (i64) -> ()
      %bbb0_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbb0_40 = "braid.and"(%bbb0_17, %bbb0_39) : (i64, i64) -> i64
      "braid.setf"(%bbb0_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbb0_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bbb3] : () -> ()
    ^bbb3:  // 0x4010f3
      %bbb3_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bbb3_0 = "braid.zext"(%bbb3_1) {bits = 32 : i64} : (i64) -> i64
      %bbb3_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bbb3_8 = "braid.zext"(%bbb3_9) {bits = 32 : i64} : (i64) -> i64
      %bbb3_16 = "braid.xor"(%bbb3_0, %bbb3_8) : (i64, i64) -> i64
      %bbb3_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbb3_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbb3_17) {flag = "of"} : (i64) -> ()
      %bbb3_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbb3_24) {flag = "af"} : (i64) -> ()
      %bbb3_32 = "braid.zext"(%bbb3_16) {bits = 8 : i64} : (i64) -> i64
      %bbb3_33 = "braid.popcnt"(%bbb3_32) : (i64) -> i64
      %bbb3_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbb3_35 = "braid.and"(%bbb3_33, %bbb3_34) : (i64, i64) -> i64
      %bbb3_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb3_37 = "braid.eq"(%bbb3_35, %bbb3_36) : (i64, i64) -> i64
      "braid.setf"(%bbb3_37) {flag = "pf"} : (i64) -> ()
      %bbb3_38 = "braid.eq"(%bbb3_16, %bbb3_36) : (i64, i64) -> i64
      "braid.setf"(%bbb3_38) {flag = "zf"} : (i64) -> ()
      %bbb3_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbb3_40 = "braid.and"(%bbb3_16, %bbb3_39) : (i64, i64) -> i64
      "braid.setf"(%bbb3_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbb3_16) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bbb6] : () -> ()
    ^bbb6:  // 0x4010f6
      %bbb6_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bbb6_0 = "braid.zext"(%bbb6_1) {bits = 32 : i64} : (i64) -> i64
      %bbb6_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbb6_13 = "braid.shl"(%bbb6_0, %bbb6_12) : (i64, i64) -> i64
      %bbb6_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbb6_15 = "braid.lshr"(%bbb6_0, %bbb6_14) : (i64, i64) -> i64
      %bbb6_16 = "braid.or"(%bbb6_13, %bbb6_15) : (i64, i64) -> i64
      %bbb6_17 = "braid.zext"(%bbb6_16) {bits = 32 : i64} : (i64) -> i64
      %bbb6_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbb6_19 = "braid.and"(%bbb6_17, %bbb6_18) : (i64, i64) -> i64
      "braid.setf"(%bbb6_19) {flag = "cf"} : (i64) -> ()
      %bbb6_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbb6_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbb6_17) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bbba] : () -> ()
    ^bbba:  // 0x4010fa
      %bbba_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bbba_0 = "braid.zext"(%bbba_1) {bits = 32 : i64} : (i64) -> i64
      %bbba_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bbba_8 = "braid.zext"(%bbba_9) {bits = 32 : i64} : (i64) -> i64
      %bbba_16 = "braid.add"(%bbba_0, %bbba_8) : (i64, i64) -> i64
      %bbba_17 = "braid.zext"(%bbba_16) {bits = 32 : i64} : (i64) -> i64
      %bbba_18 = "braid.ult"(%bbba_17, %bbba_0) : (i64, i64) -> i64
      "braid.setf"(%bbba_18) {flag = "cf"} : (i64) -> ()
      %bbba_19 = "braid.xor"(%bbba_0, %bbba_17) : (i64, i64) -> i64
      %bbba_20 = "braid.xor"(%bbba_8, %bbba_17) : (i64, i64) -> i64
      %bbba_21 = "braid.and"(%bbba_19, %bbba_20) : (i64, i64) -> i64
      %bbba_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbba_23 = "braid.and"(%bbba_21, %bbba_22) : (i64, i64) -> i64
      "braid.setf"(%bbba_23) {flag = "of"} : (i64) -> ()
      %bbba_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbba_24) {flag = "af"} : (i64) -> ()
      %bbba_32 = "braid.zext"(%bbba_17) {bits = 8 : i64} : (i64) -> i64
      %bbba_33 = "braid.popcnt"(%bbba_32) : (i64) -> i64
      %bbba_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbba_35 = "braid.and"(%bbba_33, %bbba_34) : (i64, i64) -> i64
      %bbba_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbba_37 = "braid.eq"(%bbba_35, %bbba_36) : (i64, i64) -> i64
      "braid.setf"(%bbba_37) {flag = "pf"} : (i64) -> ()
      %bbba_38 = "braid.eq"(%bbba_17, %bbba_36) : (i64, i64) -> i64
      "braid.setf"(%bbba_38) {flag = "zf"} : (i64) -> ()
      %bbba_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbba_40 = "braid.and"(%bbba_17, %bbba_39) : (i64, i64) -> i64
      "braid.setf"(%bbba_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbba_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbbd] : () -> ()
    ^bbbd:  // 0x4010fd
      %bbbd_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbbd_0 = "braid.zext"(%bbbd_1) {bits = 32 : i64} : (i64) -> i64
      %bbbd_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bbbd_8 = "braid.zext"(%bbbd_9) {bits = 32 : i64} : (i64) -> i64
      %bbbd_16 = "braid.xor"(%bbbd_0, %bbbd_8) : (i64, i64) -> i64
      %bbbd_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbbd_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbbd_17) {flag = "of"} : (i64) -> ()
      %bbbd_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbbd_24) {flag = "af"} : (i64) -> ()
      %bbbd_32 = "braid.zext"(%bbbd_16) {bits = 8 : i64} : (i64) -> i64
      %bbbd_33 = "braid.popcnt"(%bbbd_32) : (i64) -> i64
      %bbbd_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbbd_35 = "braid.and"(%bbbd_33, %bbbd_34) : (i64, i64) -> i64
      %bbbd_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbbd_37 = "braid.eq"(%bbbd_35, %bbbd_36) : (i64, i64) -> i64
      "braid.setf"(%bbbd_37) {flag = "pf"} : (i64) -> ()
      %bbbd_38 = "braid.eq"(%bbbd_16, %bbbd_36) : (i64, i64) -> i64
      "braid.setf"(%bbbd_38) {flag = "zf"} : (i64) -> ()
      %bbbd_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbbd_40 = "braid.and"(%bbbd_16, %bbbd_39) : (i64, i64) -> i64
      "braid.setf"(%bbbd_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbbd_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbbf] : () -> ()
    ^bbbf:  // 0x4010ff
      %bbbf_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbbf_0 = "braid.zext"(%bbbf_1) {bits = 32 : i64} : (i64) -> i64
      %bbbf_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbbf_13 = "braid.shl"(%bbbf_0, %bbbf_12) : (i64, i64) -> i64
      %bbbf_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbbf_15 = "braid.lshr"(%bbbf_0, %bbbf_14) : (i64, i64) -> i64
      %bbbf_16 = "braid.or"(%bbbf_13, %bbbf_15) : (i64, i64) -> i64
      %bbbf_17 = "braid.zext"(%bbbf_16) {bits = 32 : i64} : (i64) -> i64
      %bbbf_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbbf_19 = "braid.and"(%bbbf_17, %bbbf_18) : (i64, i64) -> i64
      "braid.setf"(%bbbf_19) {flag = "cf"} : (i64) -> ()
      %bbbf_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbbf_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbbf_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbc2] : () -> ()
    ^bbc2:  // 0x401102
      %bbc2_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbc2_3 = "braid.const"() {value = -92 : i64} : () -> i64
      %bbc2_1 = "braid.add"(%bbc2_2, %bbc2_3) : (i64, i64) -> i64
      %bbc2_0 = "braid.load"(%bbc2_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbc2_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bbc6] : () -> ()
    ^bbc6:  // 0x401106
      %bbc6_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbc6_0 = "braid.zext"(%bbc6_1) {bits = 32 : i64} : (i64) -> i64
      %bbc6_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbc6_8 = "braid.zext"(%bbc6_9) {bits = 32 : i64} : (i64) -> i64
      %bbc6_16 = "braid.add"(%bbc6_0, %bbc6_8) : (i64, i64) -> i64
      %bbc6_17 = "braid.zext"(%bbc6_16) {bits = 32 : i64} : (i64) -> i64
      %bbc6_18 = "braid.ult"(%bbc6_17, %bbc6_0) : (i64, i64) -> i64
      "braid.setf"(%bbc6_18) {flag = "cf"} : (i64) -> ()
      %bbc6_19 = "braid.xor"(%bbc6_0, %bbc6_17) : (i64, i64) -> i64
      %bbc6_20 = "braid.xor"(%bbc6_8, %bbc6_17) : (i64, i64) -> i64
      %bbc6_21 = "braid.and"(%bbc6_19, %bbc6_20) : (i64, i64) -> i64
      %bbc6_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbc6_23 = "braid.and"(%bbc6_21, %bbc6_22) : (i64, i64) -> i64
      "braid.setf"(%bbc6_23) {flag = "of"} : (i64) -> ()
      %bbc6_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc6_24) {flag = "af"} : (i64) -> ()
      %bbc6_32 = "braid.zext"(%bbc6_17) {bits = 8 : i64} : (i64) -> i64
      %bbc6_33 = "braid.popcnt"(%bbc6_32) : (i64) -> i64
      %bbc6_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc6_35 = "braid.and"(%bbc6_33, %bbc6_34) : (i64, i64) -> i64
      %bbc6_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc6_37 = "braid.eq"(%bbc6_35, %bbc6_36) : (i64, i64) -> i64
      "braid.setf"(%bbc6_37) {flag = "pf"} : (i64) -> ()
      %bbc6_38 = "braid.eq"(%bbc6_17, %bbc6_36) : (i64, i64) -> i64
      "braid.setf"(%bbc6_38) {flag = "zf"} : (i64) -> ()
      %bbc6_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbc6_40 = "braid.and"(%bbc6_17, %bbc6_39) : (i64, i64) -> i64
      "braid.setf"(%bbc6_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbc6_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x401108
      %bbc8_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbc8_0 = "braid.zext"(%bbc8_1) {bits = 32 : i64} : (i64) -> i64
      %bbc8_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbc8_8 = "braid.zext"(%bbc8_9) {bits = 32 : i64} : (i64) -> i64
      %bbc8_16 = "braid.xor"(%bbc8_0, %bbc8_8) : (i64, i64) -> i64
      %bbc8_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbc8_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbc8_17) {flag = "of"} : (i64) -> ()
      %bbc8_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbc8_24) {flag = "af"} : (i64) -> ()
      %bbc8_32 = "braid.zext"(%bbc8_16) {bits = 8 : i64} : (i64) -> i64
      %bbc8_33 = "braid.popcnt"(%bbc8_32) : (i64) -> i64
      %bbc8_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbc8_35 = "braid.and"(%bbc8_33, %bbc8_34) : (i64, i64) -> i64
      %bbc8_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc8_37 = "braid.eq"(%bbc8_35, %bbc8_36) : (i64, i64) -> i64
      "braid.setf"(%bbc8_37) {flag = "pf"} : (i64) -> ()
      %bbc8_38 = "braid.eq"(%bbc8_16, %bbc8_36) : (i64, i64) -> i64
      "braid.setf"(%bbc8_38) {flag = "zf"} : (i64) -> ()
      %bbc8_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbc8_40 = "braid.and"(%bbc8_16, %bbc8_39) : (i64, i64) -> i64
      "braid.setf"(%bbc8_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbc8_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bbcb] : () -> ()
    ^bbcb:  // 0x40110b
      %bbcb_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbcb_0 = "braid.zext"(%bbcb_1) {bits = 32 : i64} : (i64) -> i64
      %bbcb_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbcb_13 = "braid.shl"(%bbcb_0, %bbcb_12) : (i64, i64) -> i64
      %bbcb_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbcb_15 = "braid.lshr"(%bbcb_0, %bbcb_14) : (i64, i64) -> i64
      %bbcb_16 = "braid.or"(%bbcb_13, %bbcb_15) : (i64, i64) -> i64
      %bbcb_17 = "braid.zext"(%bbcb_16) {bits = 32 : i64} : (i64) -> i64
      %bbcb_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbcb_19 = "braid.and"(%bbcb_17, %bbcb_18) : (i64, i64) -> i64
      "braid.setf"(%bbcb_19) {flag = "cf"} : (i64) -> ()
      %bbcb_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbcb_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbcb_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bbcf] : () -> ()
    ^bbcf:  // 0x40110f
      %bbcf_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbcf_3 = "braid.const"() {value = -100 : i64} : () -> i64
      %bbcf_1 = "braid.add"(%bbcf_2, %bbcf_3) : (i64, i64) -> i64
      %bbcf_0 = "braid.load"(%bbcf_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbcf_0) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x401114
      %bbd4_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbd4_0 = "braid.zext"(%bbd4_1) {bits = 32 : i64} : (i64) -> i64
      %bbd4_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bbd4_8 = "braid.zext"(%bbd4_9) {bits = 32 : i64} : (i64) -> i64
      %bbd4_16 = "braid.add"(%bbd4_0, %bbd4_8) : (i64, i64) -> i64
      %bbd4_17 = "braid.zext"(%bbd4_16) {bits = 32 : i64} : (i64) -> i64
      %bbd4_18 = "braid.ult"(%bbd4_17, %bbd4_0) : (i64, i64) -> i64
      "braid.setf"(%bbd4_18) {flag = "cf"} : (i64) -> ()
      %bbd4_19 = "braid.xor"(%bbd4_0, %bbd4_17) : (i64, i64) -> i64
      %bbd4_20 = "braid.xor"(%bbd4_8, %bbd4_17) : (i64, i64) -> i64
      %bbd4_21 = "braid.and"(%bbd4_19, %bbd4_20) : (i64, i64) -> i64
      %bbd4_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbd4_23 = "braid.and"(%bbd4_21, %bbd4_22) : (i64, i64) -> i64
      "braid.setf"(%bbd4_23) {flag = "of"} : (i64) -> ()
      %bbd4_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbd4_24) {flag = "af"} : (i64) -> ()
      %bbd4_32 = "braid.zext"(%bbd4_17) {bits = 8 : i64} : (i64) -> i64
      %bbd4_33 = "braid.popcnt"(%bbd4_32) : (i64) -> i64
      %bbd4_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd4_35 = "braid.and"(%bbd4_33, %bbd4_34) : (i64, i64) -> i64
      %bbd4_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd4_37 = "braid.eq"(%bbd4_35, %bbd4_36) : (i64, i64) -> i64
      "braid.setf"(%bbd4_37) {flag = "pf"} : (i64) -> ()
      %bbd4_38 = "braid.eq"(%bbd4_17, %bbd4_36) : (i64, i64) -> i64
      "braid.setf"(%bbd4_38) {flag = "zf"} : (i64) -> ()
      %bbd4_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbd4_40 = "braid.and"(%bbd4_17, %bbd4_39) : (i64, i64) -> i64
      "braid.setf"(%bbd4_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbd4_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bbd7] : () -> ()
    ^bbd7:  // 0x401117
      %bbd7_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbd7_0 = "braid.zext"(%bbd7_1) {bits = 32 : i64} : (i64) -> i64
      %bbd7_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bbd7_8 = "braid.zext"(%bbd7_9) {bits = 32 : i64} : (i64) -> i64
      %bbd7_16 = "braid.xor"(%bbd7_0, %bbd7_8) : (i64, i64) -> i64
      %bbd7_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbd7_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbd7_17) {flag = "of"} : (i64) -> ()
      %bbd7_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbd7_24) {flag = "af"} : (i64) -> ()
      %bbd7_32 = "braid.zext"(%bbd7_16) {bits = 8 : i64} : (i64) -> i64
      %bbd7_33 = "braid.popcnt"(%bbd7_32) : (i64) -> i64
      %bbd7_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd7_35 = "braid.and"(%bbd7_33, %bbd7_34) : (i64, i64) -> i64
      %bbd7_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd7_37 = "braid.eq"(%bbd7_35, %bbd7_36) : (i64, i64) -> i64
      "braid.setf"(%bbd7_37) {flag = "pf"} : (i64) -> ()
      %bbd7_38 = "braid.eq"(%bbd7_16, %bbd7_36) : (i64, i64) -> i64
      "braid.setf"(%bbd7_38) {flag = "zf"} : (i64) -> ()
      %bbd7_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbd7_40 = "braid.and"(%bbd7_16, %bbd7_39) : (i64, i64) -> i64
      "braid.setf"(%bbd7_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbd7_16) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bbda] : () -> ()
    ^bbda:  // 0x40111a
      %bbda_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbda_0 = "braid.zext"(%bbda_1) {bits = 32 : i64} : (i64) -> i64
      %bbda_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bbda_13 = "braid.shl"(%bbda_0, %bbda_12) : (i64, i64) -> i64
      %bbda_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bbda_15 = "braid.lshr"(%bbda_0, %bbda_14) : (i64, i64) -> i64
      %bbda_16 = "braid.or"(%bbda_13, %bbda_15) : (i64, i64) -> i64
      %bbda_17 = "braid.zext"(%bbda_16) {bits = 32 : i64} : (i64) -> i64
      %bbda_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbda_19 = "braid.and"(%bbda_17, %bbda_18) : (i64, i64) -> i64
      "braid.setf"(%bbda_19) {flag = "cf"} : (i64) -> ()
      %bbda_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbda_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbda_17) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bbdd] : () -> ()
    ^bbdd:  // 0x40111d
      %bbdd_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbdd_0 = "braid.zext"(%bbdd_1) {bits = 32 : i64} : (i64) -> i64
      %bbdd_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bbdd_8 = "braid.zext"(%bbdd_9) {bits = 32 : i64} : (i64) -> i64
      %bbdd_16 = "braid.add"(%bbdd_0, %bbdd_8) : (i64, i64) -> i64
      %bbdd_17 = "braid.zext"(%bbdd_16) {bits = 32 : i64} : (i64) -> i64
      %bbdd_18 = "braid.ult"(%bbdd_17, %bbdd_0) : (i64, i64) -> i64
      "braid.setf"(%bbdd_18) {flag = "cf"} : (i64) -> ()
      %bbdd_19 = "braid.xor"(%bbdd_0, %bbdd_17) : (i64, i64) -> i64
      %bbdd_20 = "braid.xor"(%bbdd_8, %bbdd_17) : (i64, i64) -> i64
      %bbdd_21 = "braid.and"(%bbdd_19, %bbdd_20) : (i64, i64) -> i64
      %bbdd_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbdd_23 = "braid.and"(%bbdd_21, %bbdd_22) : (i64, i64) -> i64
      "braid.setf"(%bbdd_23) {flag = "of"} : (i64) -> ()
      %bbdd_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbdd_24) {flag = "af"} : (i64) -> ()
      %bbdd_32 = "braid.zext"(%bbdd_17) {bits = 8 : i64} : (i64) -> i64
      %bbdd_33 = "braid.popcnt"(%bbdd_32) : (i64) -> i64
      %bbdd_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbdd_35 = "braid.and"(%bbdd_33, %bbdd_34) : (i64, i64) -> i64
      %bbdd_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbdd_37 = "braid.eq"(%bbdd_35, %bbdd_36) : (i64, i64) -> i64
      "braid.setf"(%bbdd_37) {flag = "pf"} : (i64) -> ()
      %bbdd_38 = "braid.eq"(%bbdd_17, %bbdd_36) : (i64, i64) -> i64
      "braid.setf"(%bbdd_38) {flag = "zf"} : (i64) -> ()
      %bbdd_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbdd_40 = "braid.and"(%bbdd_17, %bbdd_39) : (i64, i64) -> i64
      "braid.setf"(%bbdd_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbdd_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bbdf] : () -> ()
    ^bbdf:  // 0x40111f
      %bbdf_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbdf_0 = "braid.zext"(%bbdf_1) {bits = 32 : i64} : (i64) -> i64
      %bbdf_9 = "braid.get"() {reg = "rdx"} : () -> i64
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
      "braid.set"(%bbdf_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bbe2] : () -> ()
    ^bbe2:  // 0x401122
      %bbe2_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbe2_0 = "braid.zext"(%bbe2_1) {bits = 32 : i64} : (i64) -> i64
      %bbe2_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbe2_13 = "braid.shl"(%bbe2_0, %bbe2_12) : (i64, i64) -> i64
      %bbe2_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bbe2_15 = "braid.lshr"(%bbe2_0, %bbe2_14) : (i64, i64) -> i64
      %bbe2_16 = "braid.or"(%bbe2_13, %bbe2_15) : (i64, i64) -> i64
      %bbe2_17 = "braid.zext"(%bbe2_16) {bits = 32 : i64} : (i64) -> i64
      %bbe2_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbe2_19 = "braid.and"(%bbe2_17, %bbe2_18) : (i64, i64) -> i64
      "braid.setf"(%bbe2_19) {flag = "cf"} : (i64) -> ()
      %bbe2_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbe2_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbe2_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bbe6] : () -> ()
    ^bbe6:  // 0x401126
      %bbe6_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bbe6_0 = "braid.zext"(%bbe6_1) {bits = 32 : i64} : (i64) -> i64
      %bbe6_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bbe6_8 = "braid.zext"(%bbe6_9) {bits = 32 : i64} : (i64) -> i64
      %bbe6_16 = "braid.add"(%bbe6_0, %bbe6_8) : (i64, i64) -> i64
      %bbe6_17 = "braid.zext"(%bbe6_16) {bits = 32 : i64} : (i64) -> i64
      %bbe6_18 = "braid.ult"(%bbe6_17, %bbe6_0) : (i64, i64) -> i64
      "braid.setf"(%bbe6_18) {flag = "cf"} : (i64) -> ()
      %bbe6_19 = "braid.xor"(%bbe6_0, %bbe6_17) : (i64, i64) -> i64
      %bbe6_20 = "braid.xor"(%bbe6_8, %bbe6_17) : (i64, i64) -> i64
      %bbe6_21 = "braid.and"(%bbe6_19, %bbe6_20) : (i64, i64) -> i64
      %bbe6_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbe6_23 = "braid.and"(%bbe6_21, %bbe6_22) : (i64, i64) -> i64
      "braid.setf"(%bbe6_23) {flag = "of"} : (i64) -> ()
      %bbe6_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbe6_24) {flag = "af"} : (i64) -> ()
      %bbe6_32 = "braid.zext"(%bbe6_17) {bits = 8 : i64} : (i64) -> i64
      %bbe6_33 = "braid.popcnt"(%bbe6_32) : (i64) -> i64
      %bbe6_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbe6_35 = "braid.and"(%bbe6_33, %bbe6_34) : (i64, i64) -> i64
      %bbe6_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe6_37 = "braid.eq"(%bbe6_35, %bbe6_36) : (i64, i64) -> i64
      "braid.setf"(%bbe6_37) {flag = "pf"} : (i64) -> ()
      %bbe6_38 = "braid.eq"(%bbe6_17, %bbe6_36) : (i64, i64) -> i64
      "braid.setf"(%bbe6_38) {flag = "zf"} : (i64) -> ()
      %bbe6_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbe6_40 = "braid.and"(%bbe6_17, %bbe6_39) : (i64, i64) -> i64
      "braid.setf"(%bbe6_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbe6_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bbe9] : () -> ()
    ^bbe9:  // 0x401129
      %bbe9_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bbe9_0 = "braid.zext"(%bbe9_1) {bits = 32 : i64} : (i64) -> i64
      %bbe9_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbe9_10 = "braid.const"() {value = -100 : i64} : () -> i64
      %bbe9_8 = "braid.add"(%bbe9_9, %bbe9_10) : (i64, i64) -> i64
      "braid.store"(%bbe9_8, %bbe9_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbee] : () -> ()
    ^bbee:  // 0x40112e
      %bbee_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbee_0 = "braid.zext"(%bbee_1) {bits = 32 : i64} : (i64) -> i64
      %bbee_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bbee_8 = "braid.zext"(%bbee_9) {bits = 32 : i64} : (i64) -> i64
      %bbee_16 = "braid.xor"(%bbee_0, %bbee_8) : (i64, i64) -> i64
      %bbee_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbee_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbee_17) {flag = "of"} : (i64) -> ()
      %bbee_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbee_24) {flag = "af"} : (i64) -> ()
      %bbee_32 = "braid.zext"(%bbee_16) {bits = 8 : i64} : (i64) -> i64
      %bbee_33 = "braid.popcnt"(%bbee_32) : (i64) -> i64
      %bbee_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbee_35 = "braid.and"(%bbee_33, %bbee_34) : (i64, i64) -> i64
      %bbee_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbee_37 = "braid.eq"(%bbee_35, %bbee_36) : (i64, i64) -> i64
      "braid.setf"(%bbee_37) {flag = "pf"} : (i64) -> ()
      %bbee_38 = "braid.eq"(%bbee_16, %bbee_36) : (i64, i64) -> i64
      "braid.setf"(%bbee_38) {flag = "zf"} : (i64) -> ()
      %bbee_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbee_40 = "braid.and"(%bbee_16, %bbee_39) : (i64, i64) -> i64
      "braid.setf"(%bbee_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbee_16) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bbf1] : () -> ()
    ^bbf1:  // 0x401131
      %bbf1_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bbf1_3 = "braid.const"() {value = -24 : i64} : () -> i64
      %bbf1_1 = "braid.add"(%bbf1_2, %bbf1_3) : (i64, i64) -> i64
      %bbf1_0 = "braid.load"(%bbf1_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bbf1_0) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bbf6] : () -> ()
    ^bbf6:  // 0x401136
      %bbf6_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbf6_0 = "braid.zext"(%bbf6_1) {bits = 32 : i64} : (i64) -> i64
      %bbf6_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbf6_13 = "braid.shl"(%bbf6_0, %bbf6_12) : (i64, i64) -> i64
      %bbf6_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbf6_15 = "braid.lshr"(%bbf6_0, %bbf6_14) : (i64, i64) -> i64
      %bbf6_16 = "braid.or"(%bbf6_13, %bbf6_15) : (i64, i64) -> i64
      %bbf6_17 = "braid.zext"(%bbf6_16) {bits = 32 : i64} : (i64) -> i64
      %bbf6_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf6_19 = "braid.and"(%bbf6_17, %bbf6_18) : (i64, i64) -> i64
      "braid.setf"(%bbf6_19) {flag = "cf"} : (i64) -> ()
      %bbf6_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbf6_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbf6_17) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bbf9] : () -> ()
    ^bbf9:  // 0x401139
      %bbf9_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bbf9_0 = "braid.zext"(%bbf9_1) {bits = 32 : i64} : (i64) -> i64
      %bbf9_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bbf9_8 = "braid.zext"(%bbf9_9) {bits = 32 : i64} : (i64) -> i64
      %bbf9_16 = "braid.add"(%bbf9_0, %bbf9_8) : (i64, i64) -> i64
      %bbf9_17 = "braid.zext"(%bbf9_16) {bits = 32 : i64} : (i64) -> i64
      %bbf9_18 = "braid.ult"(%bbf9_17, %bbf9_0) : (i64, i64) -> i64
      "braid.setf"(%bbf9_18) {flag = "cf"} : (i64) -> ()
      %bbf9_19 = "braid.xor"(%bbf9_0, %bbf9_17) : (i64, i64) -> i64
      %bbf9_20 = "braid.xor"(%bbf9_8, %bbf9_17) : (i64, i64) -> i64
      %bbf9_21 = "braid.and"(%bbf9_19, %bbf9_20) : (i64, i64) -> i64
      %bbf9_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbf9_23 = "braid.and"(%bbf9_21, %bbf9_22) : (i64, i64) -> i64
      "braid.setf"(%bbf9_23) {flag = "of"} : (i64) -> ()
      %bbf9_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbf9_24) {flag = "af"} : (i64) -> ()
      %bbf9_32 = "braid.zext"(%bbf9_17) {bits = 8 : i64} : (i64) -> i64
      %bbf9_33 = "braid.popcnt"(%bbf9_32) : (i64) -> i64
      %bbf9_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbf9_35 = "braid.and"(%bbf9_33, %bbf9_34) : (i64, i64) -> i64
      %bbf9_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf9_37 = "braid.eq"(%bbf9_35, %bbf9_36) : (i64, i64) -> i64
      "braid.setf"(%bbf9_37) {flag = "pf"} : (i64) -> ()
      %bbf9_38 = "braid.eq"(%bbf9_17, %bbf9_36) : (i64, i64) -> i64
      "braid.setf"(%bbf9_38) {flag = "zf"} : (i64) -> ()
      %bbf9_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbf9_40 = "braid.and"(%bbf9_17, %bbf9_39) : (i64, i64) -> i64
      "braid.setf"(%bbf9_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbf9_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bbfc] : () -> ()
    ^bbfc:  // 0x40113c
      %bbfc_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bbfc_0 = "braid.zext"(%bbfc_1) {bits = 32 : i64} : (i64) -> i64
      %bbfc_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bbfc_8 = "braid.zext"(%bbfc_9) {bits = 32 : i64} : (i64) -> i64
      %bbfc_16 = "braid.xor"(%bbfc_0, %bbfc_8) : (i64, i64) -> i64
      %bbfc_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bbfc_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bbfc_17) {flag = "of"} : (i64) -> ()
      %bbfc_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbfc_24) {flag = "af"} : (i64) -> ()
      %bbfc_32 = "braid.zext"(%bbfc_16) {bits = 8 : i64} : (i64) -> i64
      %bbfc_33 = "braid.popcnt"(%bbfc_32) : (i64) -> i64
      %bbfc_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbfc_35 = "braid.and"(%bbfc_33, %bbfc_34) : (i64, i64) -> i64
      %bbfc_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbfc_37 = "braid.eq"(%bbfc_35, %bbfc_36) : (i64, i64) -> i64
      "braid.setf"(%bbfc_37) {flag = "pf"} : (i64) -> ()
      %bbfc_38 = "braid.eq"(%bbfc_16, %bbfc_36) : (i64, i64) -> i64
      "braid.setf"(%bbfc_38) {flag = "zf"} : (i64) -> ()
      %bbfc_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbfc_40 = "braid.and"(%bbfc_16, %bbfc_39) : (i64, i64) -> i64
      "braid.setf"(%bbfc_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbfc_16) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bbff] : () -> ()
    ^bbff:  // 0x40113f
      %bbff_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bbff_0 = "braid.zext"(%bbff_1) {bits = 32 : i64} : (i64) -> i64
      %bbff_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbff_13 = "braid.shl"(%bbff_0, %bbff_12) : (i64, i64) -> i64
      %bbff_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbff_15 = "braid.lshr"(%bbff_0, %bbff_14) : (i64, i64) -> i64
      %bbff_16 = "braid.or"(%bbff_13, %bbff_15) : (i64, i64) -> i64
      %bbff_17 = "braid.zext"(%bbff_16) {bits = 32 : i64} : (i64) -> i64
      %bbff_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbff_19 = "braid.and"(%bbff_17, %bbff_18) : (i64, i64) -> i64
      "braid.setf"(%bbff_19) {flag = "cf"} : (i64) -> ()
      %bbff_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbff_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bbff_17) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb102] : () -> ()
    ^bb102:  // 0x401142
      %bb102_1 = "braid.get"() {reg = "rbx"} : () -> i64
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
      "braid_cf.br"()[^bb104] : () -> ()
    ^bb104:  // 0x401144
      %bb104_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb104_0 = "braid.zext"(%bb104_1) {bits = 32 : i64} : (i64) -> i64
      %bb104_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb104_8 = "braid.zext"(%bb104_9) {bits = 32 : i64} : (i64) -> i64
      %bb104_16 = "braid.xor"(%bb104_0, %bb104_8) : (i64, i64) -> i64
      %bb104_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb104_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb104_17) {flag = "of"} : (i64) -> ()
      %bb104_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb104_24) {flag = "af"} : (i64) -> ()
      %bb104_32 = "braid.zext"(%bb104_16) {bits = 8 : i64} : (i64) -> i64
      %bb104_33 = "braid.popcnt"(%bb104_32) : (i64) -> i64
      %bb104_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb104_35 = "braid.and"(%bb104_33, %bb104_34) : (i64, i64) -> i64
      %bb104_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb104_37 = "braid.eq"(%bb104_35, %bb104_36) : (i64, i64) -> i64
      "braid.setf"(%bb104_37) {flag = "pf"} : (i64) -> ()
      %bb104_38 = "braid.eq"(%bb104_16, %bb104_36) : (i64, i64) -> i64
      "braid.setf"(%bb104_38) {flag = "zf"} : (i64) -> ()
      %bb104_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb104_40 = "braid.and"(%bb104_16, %bb104_39) : (i64, i64) -> i64
      "braid.setf"(%bb104_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb104_16) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb107] : () -> ()
    ^bb107:  // 0x401147
      %bb107_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb107_0 = "braid.zext"(%bb107_1) {bits = 32 : i64} : (i64) -> i64
      %bb107_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb107_13 = "braid.shl"(%bb107_0, %bb107_12) : (i64, i64) -> i64
      %bb107_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb107_15 = "braid.lshr"(%bb107_0, %bb107_14) : (i64, i64) -> i64
      %bb107_16 = "braid.or"(%bb107_13, %bb107_15) : (i64, i64) -> i64
      %bb107_17 = "braid.zext"(%bb107_16) {bits = 32 : i64} : (i64) -> i64
      %bb107_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb107_19 = "braid.and"(%bb107_17, %bb107_18) : (i64, i64) -> i64
      "braid.setf"(%bb107_19) {flag = "cf"} : (i64) -> ()
      %bb107_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb107_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb107_17) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb10b] : () -> ()
    ^bb10b:  // 0x40114b
      %bb10b_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb10b_0 = "braid.zext"(%bb10b_1) {bits = 32 : i64} : (i64) -> i64
      %bb10b_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb10b_8 = "braid.zext"(%bb10b_9) {bits = 32 : i64} : (i64) -> i64
      %bb10b_16 = "braid.add"(%bb10b_0, %bb10b_8) : (i64, i64) -> i64
      %bb10b_17 = "braid.zext"(%bb10b_16) {bits = 32 : i64} : (i64) -> i64
      %bb10b_18 = "braid.ult"(%bb10b_17, %bb10b_0) : (i64, i64) -> i64
      "braid.setf"(%bb10b_18) {flag = "cf"} : (i64) -> ()
      %bb10b_19 = "braid.xor"(%bb10b_0, %bb10b_17) : (i64, i64) -> i64
      %bb10b_20 = "braid.xor"(%bb10b_8, %bb10b_17) : (i64, i64) -> i64
      %bb10b_21 = "braid.and"(%bb10b_19, %bb10b_20) : (i64, i64) -> i64
      %bb10b_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb10b_23 = "braid.and"(%bb10b_21, %bb10b_22) : (i64, i64) -> i64
      "braid.setf"(%bb10b_23) {flag = "of"} : (i64) -> ()
      %bb10b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb10b_24) {flag = "af"} : (i64) -> ()
      %bb10b_32 = "braid.zext"(%bb10b_17) {bits = 8 : i64} : (i64) -> i64
      %bb10b_33 = "braid.popcnt"(%bb10b_32) : (i64) -> i64
      %bb10b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10b_35 = "braid.and"(%bb10b_33, %bb10b_34) : (i64, i64) -> i64
      %bb10b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10b_37 = "braid.eq"(%bb10b_35, %bb10b_36) : (i64, i64) -> i64
      "braid.setf"(%bb10b_37) {flag = "pf"} : (i64) -> ()
      %bb10b_38 = "braid.eq"(%bb10b_17, %bb10b_36) : (i64, i64) -> i64
      "braid.setf"(%bb10b_38) {flag = "zf"} : (i64) -> ()
      %bb10b_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb10b_40 = "braid.and"(%bb10b_17, %bb10b_39) : (i64, i64) -> i64
      "braid.setf"(%bb10b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb10b_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb10e] : () -> ()
    ^bb10e:  // 0x40114e
      %bb10e_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb10e_0 = "braid.zext"(%bb10e_1) {bits = 32 : i64} : (i64) -> i64
      %bb10e_9 = "braid.get"() {reg = "r11"} : () -> i64
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
      "braid.set"(%bb10e_16) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb111] : () -> ()
    ^bb111:  // 0x401151
      %bb111_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb111_0 = "braid.zext"(%bb111_1) {bits = 32 : i64} : (i64) -> i64
      %bb111_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb111_13 = "braid.shl"(%bb111_0, %bb111_12) : (i64, i64) -> i64
      %bb111_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb111_15 = "braid.lshr"(%bb111_0, %bb111_14) : (i64, i64) -> i64
      %bb111_16 = "braid.or"(%bb111_13, %bb111_15) : (i64, i64) -> i64
      %bb111_17 = "braid.zext"(%bb111_16) {bits = 32 : i64} : (i64) -> i64
      %bb111_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb111_19 = "braid.and"(%bb111_17, %bb111_18) : (i64, i64) -> i64
      "braid.setf"(%bb111_19) {flag = "cf"} : (i64) -> ()
      %bb111_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb111_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb111_17) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb114] : () -> ()
    ^bb114:  // 0x401154
      %bb114_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb114_0 = "braid.zext"(%bb114_1) {bits = 32 : i64} : (i64) -> i64
      %bb114_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb114_8 = "braid.zext"(%bb114_9) {bits = 32 : i64} : (i64) -> i64
      %bb114_16 = "braid.add"(%bb114_0, %bb114_8) : (i64, i64) -> i64
      %bb114_17 = "braid.zext"(%bb114_16) {bits = 32 : i64} : (i64) -> i64
      %bb114_18 = "braid.ult"(%bb114_17, %bb114_0) : (i64, i64) -> i64
      "braid.setf"(%bb114_18) {flag = "cf"} : (i64) -> ()
      %bb114_19 = "braid.xor"(%bb114_0, %bb114_17) : (i64, i64) -> i64
      %bb114_20 = "braid.xor"(%bb114_8, %bb114_17) : (i64, i64) -> i64
      %bb114_21 = "braid.and"(%bb114_19, %bb114_20) : (i64, i64) -> i64
      %bb114_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb114_23 = "braid.and"(%bb114_21, %bb114_22) : (i64, i64) -> i64
      "braid.setf"(%bb114_23) {flag = "of"} : (i64) -> ()
      %bb114_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb114_24) {flag = "af"} : (i64) -> ()
      %bb114_32 = "braid.zext"(%bb114_17) {bits = 8 : i64} : (i64) -> i64
      %bb114_33 = "braid.popcnt"(%bb114_32) : (i64) -> i64
      %bb114_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb114_35 = "braid.and"(%bb114_33, %bb114_34) : (i64, i64) -> i64
      %bb114_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb114_37 = "braid.eq"(%bb114_35, %bb114_36) : (i64, i64) -> i64
      "braid.setf"(%bb114_37) {flag = "pf"} : (i64) -> ()
      %bb114_38 = "braid.eq"(%bb114_17, %bb114_36) : (i64, i64) -> i64
      "braid.setf"(%bb114_38) {flag = "zf"} : (i64) -> ()
      %bb114_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb114_40 = "braid.and"(%bb114_17, %bb114_39) : (i64, i64) -> i64
      "braid.setf"(%bb114_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb114_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb116] : () -> ()
    ^bb116:  // 0x401156
      %bb116_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb116_0 = "braid.zext"(%bb116_1) {bits = 32 : i64} : (i64) -> i64
      %bb116_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb116_8 = "braid.zext"(%bb116_9) {bits = 32 : i64} : (i64) -> i64
      %bb116_16 = "braid.xor"(%bb116_0, %bb116_8) : (i64, i64) -> i64
      %bb116_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb116_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb116_17) {flag = "of"} : (i64) -> ()
      %bb116_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb116_24) {flag = "af"} : (i64) -> ()
      %bb116_32 = "braid.zext"(%bb116_16) {bits = 8 : i64} : (i64) -> i64
      %bb116_33 = "braid.popcnt"(%bb116_32) : (i64) -> i64
      %bb116_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb116_35 = "braid.and"(%bb116_33, %bb116_34) : (i64, i64) -> i64
      %bb116_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb116_37 = "braid.eq"(%bb116_35, %bb116_36) : (i64, i64) -> i64
      "braid.setf"(%bb116_37) {flag = "pf"} : (i64) -> ()
      %bb116_38 = "braid.eq"(%bb116_16, %bb116_36) : (i64, i64) -> i64
      "braid.setf"(%bb116_38) {flag = "zf"} : (i64) -> ()
      %bb116_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb116_40 = "braid.and"(%bb116_16, %bb116_39) : (i64, i64) -> i64
      "braid.setf"(%bb116_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb116_16) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb119] : () -> ()
    ^bb119:  // 0x401159
      %bb119_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb119_0 = "braid.zext"(%bb119_1) {bits = 32 : i64} : (i64) -> i64
      %bb119_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb119_13 = "braid.shl"(%bb119_0, %bb119_12) : (i64, i64) -> i64
      %bb119_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb119_15 = "braid.lshr"(%bb119_0, %bb119_14) : (i64, i64) -> i64
      %bb119_16 = "braid.or"(%bb119_13, %bb119_15) : (i64, i64) -> i64
      %bb119_17 = "braid.zext"(%bb119_16) {bits = 32 : i64} : (i64) -> i64
      %bb119_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb119_19 = "braid.and"(%bb119_17, %bb119_18) : (i64, i64) -> i64
      "braid.setf"(%bb119_19) {flag = "cf"} : (i64) -> ()
      %bb119_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb119_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb119_17) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb11d] : () -> ()
    ^bb11d:  // 0x40115d
      %bb11d_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb11d_0 = "braid.zext"(%bb11d_1) {bits = 32 : i64} : (i64) -> i64
      %bb11d_9 = "braid.get"() {reg = "r15"} : () -> i64
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
      "braid.set"(%bb11d_17) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x401160
      %bb120_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb120_0 = "braid.zext"(%bb120_1) {bits = 32 : i64} : (i64) -> i64
      %bb120_9 = "braid.get"() {reg = "r15"} : () -> i64
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
      "braid.set"(%bb120_16) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb123] : () -> ()
    ^bb123:  // 0x401163
      %bb123_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb123_0 = "braid.zext"(%bb123_1) {bits = 32 : i64} : (i64) -> i64
      %bb123_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb123_13 = "braid.shl"(%bb123_0, %bb123_12) : (i64, i64) -> i64
      %bb123_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb123_15 = "braid.lshr"(%bb123_0, %bb123_14) : (i64, i64) -> i64
      %bb123_16 = "braid.or"(%bb123_13, %bb123_15) : (i64, i64) -> i64
      %bb123_17 = "braid.zext"(%bb123_16) {bits = 32 : i64} : (i64) -> i64
      %bb123_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb123_19 = "braid.and"(%bb123_17, %bb123_18) : (i64, i64) -> i64
      "braid.setf"(%bb123_19) {flag = "cf"} : (i64) -> ()
      %bb123_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb123_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb123_17) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb127] : () -> ()
    ^bb127:  // 0x401167
      %bb127_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb127_0 = "braid.zext"(%bb127_1) {bits = 32 : i64} : (i64) -> i64
      %bb127_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb127_8 = "braid.zext"(%bb127_9) {bits = 32 : i64} : (i64) -> i64
      %bb127_16 = "braid.add"(%bb127_0, %bb127_8) : (i64, i64) -> i64
      %bb127_17 = "braid.zext"(%bb127_16) {bits = 32 : i64} : (i64) -> i64
      %bb127_18 = "braid.ult"(%bb127_17, %bb127_0) : (i64, i64) -> i64
      "braid.setf"(%bb127_18) {flag = "cf"} : (i64) -> ()
      %bb127_19 = "braid.xor"(%bb127_0, %bb127_17) : (i64, i64) -> i64
      %bb127_20 = "braid.xor"(%bb127_8, %bb127_17) : (i64, i64) -> i64
      %bb127_21 = "braid.and"(%bb127_19, %bb127_20) : (i64, i64) -> i64
      %bb127_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb127_23 = "braid.and"(%bb127_21, %bb127_22) : (i64, i64) -> i64
      "braid.setf"(%bb127_23) {flag = "of"} : (i64) -> ()
      %bb127_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb127_24) {flag = "af"} : (i64) -> ()
      %bb127_32 = "braid.zext"(%bb127_17) {bits = 8 : i64} : (i64) -> i64
      %bb127_33 = "braid.popcnt"(%bb127_32) : (i64) -> i64
      %bb127_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb127_35 = "braid.and"(%bb127_33, %bb127_34) : (i64, i64) -> i64
      %bb127_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb127_37 = "braid.eq"(%bb127_35, %bb127_36) : (i64, i64) -> i64
      "braid.setf"(%bb127_37) {flag = "pf"} : (i64) -> ()
      %bb127_38 = "braid.eq"(%bb127_17, %bb127_36) : (i64, i64) -> i64
      "braid.setf"(%bb127_38) {flag = "zf"} : (i64) -> ()
      %bb127_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb127_40 = "braid.and"(%bb127_17, %bb127_39) : (i64, i64) -> i64
      "braid.setf"(%bb127_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb127_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb12a] : () -> ()
    ^bb12a:  // 0x40116a
      %bb12a_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb12a_0 = "braid.zext"(%bb12a_1) {bits = 32 : i64} : (i64) -> i64
      %bb12a_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb12a_8 = "braid.zext"(%bb12a_9) {bits = 32 : i64} : (i64) -> i64
      %bb12a_16 = "braid.xor"(%bb12a_0, %bb12a_8) : (i64, i64) -> i64
      %bb12a_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb12a_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb12a_17) {flag = "of"} : (i64) -> ()
      %bb12a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb12a_24) {flag = "af"} : (i64) -> ()
      %bb12a_32 = "braid.zext"(%bb12a_16) {bits = 8 : i64} : (i64) -> i64
      %bb12a_33 = "braid.popcnt"(%bb12a_32) : (i64) -> i64
      %bb12a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb12a_35 = "braid.and"(%bb12a_33, %bb12a_34) : (i64, i64) -> i64
      %bb12a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12a_37 = "braid.eq"(%bb12a_35, %bb12a_36) : (i64, i64) -> i64
      "braid.setf"(%bb12a_37) {flag = "pf"} : (i64) -> ()
      %bb12a_38 = "braid.eq"(%bb12a_16, %bb12a_36) : (i64, i64) -> i64
      "braid.setf"(%bb12a_38) {flag = "zf"} : (i64) -> ()
      %bb12a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb12a_40 = "braid.and"(%bb12a_16, %bb12a_39) : (i64, i64) -> i64
      "braid.setf"(%bb12a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb12a_16) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb12d] : () -> ()
    ^bb12d:  // 0x40116d
      %bb12d_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb12d_0 = "braid.zext"(%bb12d_1) {bits = 32 : i64} : (i64) -> i64
      %bb12d_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb12d_13 = "braid.shl"(%bb12d_0, %bb12d_12) : (i64, i64) -> i64
      %bb12d_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb12d_15 = "braid.lshr"(%bb12d_0, %bb12d_14) : (i64, i64) -> i64
      %bb12d_16 = "braid.or"(%bb12d_13, %bb12d_15) : (i64, i64) -> i64
      %bb12d_17 = "braid.zext"(%bb12d_16) {bits = 32 : i64} : (i64) -> i64
      %bb12d_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb12d_19 = "braid.and"(%bb12d_17, %bb12d_18) : (i64, i64) -> i64
      "braid.setf"(%bb12d_19) {flag = "cf"} : (i64) -> ()
      %bb12d_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb12d_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb12d_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb131] : () -> ()
    ^bb131:  // 0x401171
      %bb131_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb131_0 = "braid.zext"(%bb131_1) {bits = 32 : i64} : (i64) -> i64
      %bb131_9 = "braid.get"() {reg = "r15"} : () -> i64
      %bb131_8 = "braid.zext"(%bb131_9) {bits = 32 : i64} : (i64) -> i64
      %bb131_16 = "braid.add"(%bb131_0, %bb131_8) : (i64, i64) -> i64
      %bb131_17 = "braid.zext"(%bb131_16) {bits = 32 : i64} : (i64) -> i64
      %bb131_18 = "braid.ult"(%bb131_17, %bb131_0) : (i64, i64) -> i64
      "braid.setf"(%bb131_18) {flag = "cf"} : (i64) -> ()
      %bb131_19 = "braid.xor"(%bb131_0, %bb131_17) : (i64, i64) -> i64
      %bb131_20 = "braid.xor"(%bb131_8, %bb131_17) : (i64, i64) -> i64
      %bb131_21 = "braid.and"(%bb131_19, %bb131_20) : (i64, i64) -> i64
      %bb131_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb131_23 = "braid.and"(%bb131_21, %bb131_22) : (i64, i64) -> i64
      "braid.setf"(%bb131_23) {flag = "of"} : (i64) -> ()
      %bb131_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb131_24) {flag = "af"} : (i64) -> ()
      %bb131_32 = "braid.zext"(%bb131_17) {bits = 8 : i64} : (i64) -> i64
      %bb131_33 = "braid.popcnt"(%bb131_32) : (i64) -> i64
      %bb131_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb131_35 = "braid.and"(%bb131_33, %bb131_34) : (i64, i64) -> i64
      %bb131_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb131_37 = "braid.eq"(%bb131_35, %bb131_36) : (i64, i64) -> i64
      "braid.setf"(%bb131_37) {flag = "pf"} : (i64) -> ()
      %bb131_38 = "braid.eq"(%bb131_17, %bb131_36) : (i64, i64) -> i64
      "braid.setf"(%bb131_38) {flag = "zf"} : (i64) -> ()
      %bb131_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb131_40 = "braid.and"(%bb131_17, %bb131_39) : (i64, i64) -> i64
      "braid.setf"(%bb131_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb131_17) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb134] : () -> ()
    ^bb134:  // 0x401174
      %bb134_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb134_0 = "braid.zext"(%bb134_1) {bits = 32 : i64} : (i64) -> i64
      %bb134_9 = "braid.get"() {reg = "r15"} : () -> i64
      %bb134_8 = "braid.zext"(%bb134_9) {bits = 32 : i64} : (i64) -> i64
      %bb134_16 = "braid.xor"(%bb134_0, %bb134_8) : (i64, i64) -> i64
      %bb134_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb134_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb134_17) {flag = "of"} : (i64) -> ()
      %bb134_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb134_24) {flag = "af"} : (i64) -> ()
      %bb134_32 = "braid.zext"(%bb134_16) {bits = 8 : i64} : (i64) -> i64
      %bb134_33 = "braid.popcnt"(%bb134_32) : (i64) -> i64
      %bb134_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb134_35 = "braid.and"(%bb134_33, %bb134_34) : (i64, i64) -> i64
      %bb134_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb134_37 = "braid.eq"(%bb134_35, %bb134_36) : (i64, i64) -> i64
      "braid.setf"(%bb134_37) {flag = "pf"} : (i64) -> ()
      %bb134_38 = "braid.eq"(%bb134_16, %bb134_36) : (i64, i64) -> i64
      "braid.setf"(%bb134_38) {flag = "zf"} : (i64) -> ()
      %bb134_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb134_40 = "braid.and"(%bb134_16, %bb134_39) : (i64, i64) -> i64
      "braid.setf"(%bb134_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb134_16) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb137] : () -> ()
    ^bb137:  // 0x401177
      %bb137_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb137_0 = "braid.zext"(%bb137_1) {bits = 32 : i64} : (i64) -> i64
      %bb137_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb137_13 = "braid.shl"(%bb137_0, %bb137_12) : (i64, i64) -> i64
      %bb137_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb137_15 = "braid.lshr"(%bb137_0, %bb137_14) : (i64, i64) -> i64
      %bb137_16 = "braid.or"(%bb137_13, %bb137_15) : (i64, i64) -> i64
      %bb137_17 = "braid.zext"(%bb137_16) {bits = 32 : i64} : (i64) -> i64
      %bb137_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb137_19 = "braid.and"(%bb137_17, %bb137_18) : (i64, i64) -> i64
      "braid.setf"(%bb137_19) {flag = "cf"} : (i64) -> ()
      %bb137_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb137_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb137_17) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb13b] : () -> ()
    ^bb13b:  // 0x40117b
      %bb13b_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb13b_0 = "braid.zext"(%bb13b_1) {bits = 32 : i64} : (i64) -> i64
      %bb13b_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb13b_8 = "braid.zext"(%bb13b_9) {bits = 32 : i64} : (i64) -> i64
      %bb13b_16 = "braid.add"(%bb13b_0, %bb13b_8) : (i64, i64) -> i64
      %bb13b_17 = "braid.zext"(%bb13b_16) {bits = 32 : i64} : (i64) -> i64
      %bb13b_18 = "braid.ult"(%bb13b_17, %bb13b_0) : (i64, i64) -> i64
      "braid.setf"(%bb13b_18) {flag = "cf"} : (i64) -> ()
      %bb13b_19 = "braid.xor"(%bb13b_0, %bb13b_17) : (i64, i64) -> i64
      %bb13b_20 = "braid.xor"(%bb13b_8, %bb13b_17) : (i64, i64) -> i64
      %bb13b_21 = "braid.and"(%bb13b_19, %bb13b_20) : (i64, i64) -> i64
      %bb13b_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb13b_23 = "braid.and"(%bb13b_21, %bb13b_22) : (i64, i64) -> i64
      "braid.setf"(%bb13b_23) {flag = "of"} : (i64) -> ()
      %bb13b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb13b_24) {flag = "af"} : (i64) -> ()
      %bb13b_32 = "braid.zext"(%bb13b_17) {bits = 8 : i64} : (i64) -> i64
      %bb13b_33 = "braid.popcnt"(%bb13b_32) : (i64) -> i64
      %bb13b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb13b_35 = "braid.and"(%bb13b_33, %bb13b_34) : (i64, i64) -> i64
      %bb13b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb13b_37 = "braid.eq"(%bb13b_35, %bb13b_36) : (i64, i64) -> i64
      "braid.setf"(%bb13b_37) {flag = "pf"} : (i64) -> ()
      %bb13b_38 = "braid.eq"(%bb13b_17, %bb13b_36) : (i64, i64) -> i64
      "braid.setf"(%bb13b_38) {flag = "zf"} : (i64) -> ()
      %bb13b_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb13b_40 = "braid.and"(%bb13b_17, %bb13b_39) : (i64, i64) -> i64
      "braid.setf"(%bb13b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb13b_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb13e] : () -> ()
    ^bb13e:  // 0x40117e
      %bb13e_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb13e_0 = "braid.zext"(%bb13e_1) {bits = 32 : i64} : (i64) -> i64
      %bb13e_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb13e_8 = "braid.zext"(%bb13e_9) {bits = 32 : i64} : (i64) -> i64
      %bb13e_16 = "braid.xor"(%bb13e_0, %bb13e_8) : (i64, i64) -> i64
      %bb13e_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb13e_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb13e_17) {flag = "of"} : (i64) -> ()
      %bb13e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb13e_24) {flag = "af"} : (i64) -> ()
      %bb13e_32 = "braid.zext"(%bb13e_16) {bits = 8 : i64} : (i64) -> i64
      %bb13e_33 = "braid.popcnt"(%bb13e_32) : (i64) -> i64
      %bb13e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb13e_35 = "braid.and"(%bb13e_33, %bb13e_34) : (i64, i64) -> i64
      %bb13e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb13e_37 = "braid.eq"(%bb13e_35, %bb13e_36) : (i64, i64) -> i64
      "braid.setf"(%bb13e_37) {flag = "pf"} : (i64) -> ()
      %bb13e_38 = "braid.eq"(%bb13e_16, %bb13e_36) : (i64, i64) -> i64
      "braid.setf"(%bb13e_38) {flag = "zf"} : (i64) -> ()
      %bb13e_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb13e_40 = "braid.and"(%bb13e_16, %bb13e_39) : (i64, i64) -> i64
      "braid.setf"(%bb13e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb13e_16) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb141] : () -> ()
    ^bb141:  // 0x401181
      %bb141_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb141_0 = "braid.zext"(%bb141_1) {bits = 32 : i64} : (i64) -> i64
      %bb141_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb141_13 = "braid.shl"(%bb141_0, %bb141_12) : (i64, i64) -> i64
      %bb141_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb141_15 = "braid.lshr"(%bb141_0, %bb141_14) : (i64, i64) -> i64
      %bb141_16 = "braid.or"(%bb141_13, %bb141_15) : (i64, i64) -> i64
      %bb141_17 = "braid.zext"(%bb141_16) {bits = 32 : i64} : (i64) -> i64
      %bb141_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb141_19 = "braid.and"(%bb141_17, %bb141_18) : (i64, i64) -> i64
      "braid.setf"(%bb141_19) {flag = "cf"} : (i64) -> ()
      %bb141_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb141_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb141_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb145] : () -> ()
    ^bb145:  // 0x401185
      %bb145_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb145_0 = "braid.zext"(%bb145_1) {bits = 32 : i64} : (i64) -> i64
      %bb145_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb145_8 = "braid.zext"(%bb145_9) {bits = 32 : i64} : (i64) -> i64
      %bb145_16 = "braid.add"(%bb145_0, %bb145_8) : (i64, i64) -> i64
      %bb145_17 = "braid.zext"(%bb145_16) {bits = 32 : i64} : (i64) -> i64
      %bb145_18 = "braid.ult"(%bb145_17, %bb145_0) : (i64, i64) -> i64
      "braid.setf"(%bb145_18) {flag = "cf"} : (i64) -> ()
      %bb145_19 = "braid.xor"(%bb145_0, %bb145_17) : (i64, i64) -> i64
      %bb145_20 = "braid.xor"(%bb145_8, %bb145_17) : (i64, i64) -> i64
      %bb145_21 = "braid.and"(%bb145_19, %bb145_20) : (i64, i64) -> i64
      %bb145_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb145_23 = "braid.and"(%bb145_21, %bb145_22) : (i64, i64) -> i64
      "braid.setf"(%bb145_23) {flag = "of"} : (i64) -> ()
      %bb145_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb145_24) {flag = "af"} : (i64) -> ()
      %bb145_32 = "braid.zext"(%bb145_17) {bits = 8 : i64} : (i64) -> i64
      %bb145_33 = "braid.popcnt"(%bb145_32) : (i64) -> i64
      %bb145_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb145_35 = "braid.and"(%bb145_33, %bb145_34) : (i64, i64) -> i64
      %bb145_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb145_37 = "braid.eq"(%bb145_35, %bb145_36) : (i64, i64) -> i64
      "braid.setf"(%bb145_37) {flag = "pf"} : (i64) -> ()
      %bb145_38 = "braid.eq"(%bb145_17, %bb145_36) : (i64, i64) -> i64
      "braid.setf"(%bb145_38) {flag = "zf"} : (i64) -> ()
      %bb145_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb145_40 = "braid.and"(%bb145_17, %bb145_39) : (i64, i64) -> i64
      "braid.setf"(%bb145_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb145_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb148] : () -> ()
    ^bb148:  // 0x401188
      %bb148_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb148_0 = "braid.zext"(%bb148_1) {bits = 32 : i64} : (i64) -> i64
      %bb148_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb148_8 = "braid.zext"(%bb148_9) {bits = 32 : i64} : (i64) -> i64
      %bb148_16 = "braid.xor"(%bb148_0, %bb148_8) : (i64, i64) -> i64
      %bb148_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb148_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb148_17) {flag = "of"} : (i64) -> ()
      %bb148_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb148_24) {flag = "af"} : (i64) -> ()
      %bb148_32 = "braid.zext"(%bb148_16) {bits = 8 : i64} : (i64) -> i64
      %bb148_33 = "braid.popcnt"(%bb148_32) : (i64) -> i64
      %bb148_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb148_35 = "braid.and"(%bb148_33, %bb148_34) : (i64, i64) -> i64
      %bb148_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb148_37 = "braid.eq"(%bb148_35, %bb148_36) : (i64, i64) -> i64
      "braid.setf"(%bb148_37) {flag = "pf"} : (i64) -> ()
      %bb148_38 = "braid.eq"(%bb148_16, %bb148_36) : (i64, i64) -> i64
      "braid.setf"(%bb148_38) {flag = "zf"} : (i64) -> ()
      %bb148_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb148_40 = "braid.and"(%bb148_16, %bb148_39) : (i64, i64) -> i64
      "braid.setf"(%bb148_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb148_16) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb14b] : () -> ()
    ^bb14b:  // 0x40118b
      %bb14b_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb14b_0 = "braid.zext"(%bb14b_1) {bits = 32 : i64} : (i64) -> i64
      %bb14b_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb14b_13 = "braid.shl"(%bb14b_0, %bb14b_12) : (i64, i64) -> i64
      %bb14b_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb14b_15 = "braid.lshr"(%bb14b_0, %bb14b_14) : (i64, i64) -> i64
      %bb14b_16 = "braid.or"(%bb14b_13, %bb14b_15) : (i64, i64) -> i64
      %bb14b_17 = "braid.zext"(%bb14b_16) {bits = 32 : i64} : (i64) -> i64
      %bb14b_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14b_19 = "braid.and"(%bb14b_17, %bb14b_18) : (i64, i64) -> i64
      "braid.setf"(%bb14b_19) {flag = "cf"} : (i64) -> ()
      %bb14b_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb14b_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb14b_17) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb14f] : () -> ()
    ^bb14f:  // 0x40118f
      %bb14f_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb14f_0 = "braid.zext"(%bb14f_1) {bits = 32 : i64} : (i64) -> i64
      %bb14f_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb14f_8 = "braid.zext"(%bb14f_9) {bits = 32 : i64} : (i64) -> i64
      %bb14f_16 = "braid.add"(%bb14f_0, %bb14f_8) : (i64, i64) -> i64
      %bb14f_17 = "braid.zext"(%bb14f_16) {bits = 32 : i64} : (i64) -> i64
      %bb14f_18 = "braid.ult"(%bb14f_17, %bb14f_0) : (i64, i64) -> i64
      "braid.setf"(%bb14f_18) {flag = "cf"} : (i64) -> ()
      %bb14f_19 = "braid.xor"(%bb14f_0, %bb14f_17) : (i64, i64) -> i64
      %bb14f_20 = "braid.xor"(%bb14f_8, %bb14f_17) : (i64, i64) -> i64
      %bb14f_21 = "braid.and"(%bb14f_19, %bb14f_20) : (i64, i64) -> i64
      %bb14f_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb14f_23 = "braid.and"(%bb14f_21, %bb14f_22) : (i64, i64) -> i64
      "braid.setf"(%bb14f_23) {flag = "of"} : (i64) -> ()
      %bb14f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb14f_24) {flag = "af"} : (i64) -> ()
      %bb14f_32 = "braid.zext"(%bb14f_17) {bits = 8 : i64} : (i64) -> i64
      %bb14f_33 = "braid.popcnt"(%bb14f_32) : (i64) -> i64
      %bb14f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb14f_35 = "braid.and"(%bb14f_33, %bb14f_34) : (i64, i64) -> i64
      %bb14f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14f_37 = "braid.eq"(%bb14f_35, %bb14f_36) : (i64, i64) -> i64
      "braid.setf"(%bb14f_37) {flag = "pf"} : (i64) -> ()
      %bb14f_38 = "braid.eq"(%bb14f_17, %bb14f_36) : (i64, i64) -> i64
      "braid.setf"(%bb14f_38) {flag = "zf"} : (i64) -> ()
      %bb14f_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb14f_40 = "braid.and"(%bb14f_17, %bb14f_39) : (i64, i64) -> i64
      "braid.setf"(%bb14f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb14f_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb152] : () -> ()
    ^bb152:  // 0x401192
      %bb152_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb152_0 = "braid.zext"(%bb152_1) {bits = 32 : i64} : (i64) -> i64
      %bb152_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb152_8 = "braid.zext"(%bb152_9) {bits = 32 : i64} : (i64) -> i64
      %bb152_16 = "braid.xor"(%bb152_0, %bb152_8) : (i64, i64) -> i64
      %bb152_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb152_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb152_17) {flag = "of"} : (i64) -> ()
      %bb152_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb152_24) {flag = "af"} : (i64) -> ()
      %bb152_32 = "braid.zext"(%bb152_16) {bits = 8 : i64} : (i64) -> i64
      %bb152_33 = "braid.popcnt"(%bb152_32) : (i64) -> i64
      %bb152_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb152_35 = "braid.and"(%bb152_33, %bb152_34) : (i64, i64) -> i64
      %bb152_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb152_37 = "braid.eq"(%bb152_35, %bb152_36) : (i64, i64) -> i64
      "braid.setf"(%bb152_37) {flag = "pf"} : (i64) -> ()
      %bb152_38 = "braid.eq"(%bb152_16, %bb152_36) : (i64, i64) -> i64
      "braid.setf"(%bb152_38) {flag = "zf"} : (i64) -> ()
      %bb152_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb152_40 = "braid.and"(%bb152_16, %bb152_39) : (i64, i64) -> i64
      "braid.setf"(%bb152_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb152_16) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb154] : () -> ()
    ^bb154:  // 0x401194
      %bb154_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb154_0 = "braid.zext"(%bb154_1) {bits = 32 : i64} : (i64) -> i64
      %bb154_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb154_13 = "braid.shl"(%bb154_0, %bb154_12) : (i64, i64) -> i64
      %bb154_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb154_15 = "braid.lshr"(%bb154_0, %bb154_14) : (i64, i64) -> i64
      %bb154_16 = "braid.or"(%bb154_13, %bb154_15) : (i64, i64) -> i64
      %bb154_17 = "braid.zext"(%bb154_16) {bits = 32 : i64} : (i64) -> i64
      %bb154_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb154_19 = "braid.and"(%bb154_17, %bb154_18) : (i64, i64) -> i64
      "braid.setf"(%bb154_19) {flag = "cf"} : (i64) -> ()
      %bb154_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb154_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb154_17) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb157] : () -> ()
    ^bb157:  // 0x401197
      %bb157_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb157_0 = "braid.zext"(%bb157_1) {bits = 32 : i64} : (i64) -> i64
      %bb157_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb157_8 = "braid.zext"(%bb157_9) {bits = 32 : i64} : (i64) -> i64
      %bb157_16 = "braid.add"(%bb157_0, %bb157_8) : (i64, i64) -> i64
      %bb157_17 = "braid.zext"(%bb157_16) {bits = 32 : i64} : (i64) -> i64
      %bb157_18 = "braid.ult"(%bb157_17, %bb157_0) : (i64, i64) -> i64
      "braid.setf"(%bb157_18) {flag = "cf"} : (i64) -> ()
      %bb157_19 = "braid.xor"(%bb157_0, %bb157_17) : (i64, i64) -> i64
      %bb157_20 = "braid.xor"(%bb157_8, %bb157_17) : (i64, i64) -> i64
      %bb157_21 = "braid.and"(%bb157_19, %bb157_20) : (i64, i64) -> i64
      %bb157_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb157_23 = "braid.and"(%bb157_21, %bb157_22) : (i64, i64) -> i64
      "braid.setf"(%bb157_23) {flag = "of"} : (i64) -> ()
      %bb157_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb157_24) {flag = "af"} : (i64) -> ()
      %bb157_32 = "braid.zext"(%bb157_17) {bits = 8 : i64} : (i64) -> i64
      %bb157_33 = "braid.popcnt"(%bb157_32) : (i64) -> i64
      %bb157_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb157_35 = "braid.and"(%bb157_33, %bb157_34) : (i64, i64) -> i64
      %bb157_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb157_37 = "braid.eq"(%bb157_35, %bb157_36) : (i64, i64) -> i64
      "braid.setf"(%bb157_37) {flag = "pf"} : (i64) -> ()
      %bb157_38 = "braid.eq"(%bb157_17, %bb157_36) : (i64, i64) -> i64
      "braid.setf"(%bb157_38) {flag = "zf"} : (i64) -> ()
      %bb157_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb157_40 = "braid.and"(%bb157_17, %bb157_39) : (i64, i64) -> i64
      "braid.setf"(%bb157_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb157_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb15a] : () -> ()
    ^bb15a:  // 0x40119a
      %bb15a_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb15a_0 = "braid.zext"(%bb15a_1) {bits = 32 : i64} : (i64) -> i64
      %bb15a_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb15a_10 = "braid.const"() {value = -96 : i64} : () -> i64
      %bb15a_8 = "braid.add"(%bb15a_9, %bb15a_10) : (i64, i64) -> i64
      "braid.store"(%bb15a_8, %bb15a_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb15f] : () -> ()
    ^bb15f:  // 0x40119f
      %bb15f_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb15f_0 = "braid.zext"(%bb15f_1) {bits = 32 : i64} : (i64) -> i64
      %bb15f_9 = "braid.get"() {reg = "r9"} : () -> i64
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
      "braid.set"(%bb15f_16) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb162] : () -> ()
    ^bb162:  // 0x4011a2
      %bb162_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb162_0 = "braid.zext"(%bb162_1) {bits = 32 : i64} : (i64) -> i64
      %bb162_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb162_13 = "braid.shl"(%bb162_0, %bb162_12) : (i64, i64) -> i64
      %bb162_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb162_15 = "braid.lshr"(%bb162_0, %bb162_14) : (i64, i64) -> i64
      %bb162_16 = "braid.or"(%bb162_13, %bb162_15) : (i64, i64) -> i64
      %bb162_17 = "braid.zext"(%bb162_16) {bits = 32 : i64} : (i64) -> i64
      %bb162_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb162_19 = "braid.and"(%bb162_17, %bb162_18) : (i64, i64) -> i64
      "braid.setf"(%bb162_19) {flag = "cf"} : (i64) -> ()
      %bb162_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb162_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb162_17) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb166] : () -> ()
    ^bb166:  // 0x4011a6
      %bb166_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb166_0 = "braid.zext"(%bb166_1) {bits = 32 : i64} : (i64) -> i64
      %bb166_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb166_8 = "braid.zext"(%bb166_9) {bits = 32 : i64} : (i64) -> i64
      %bb166_16 = "braid.add"(%bb166_0, %bb166_8) : (i64, i64) -> i64
      %bb166_17 = "braid.zext"(%bb166_16) {bits = 32 : i64} : (i64) -> i64
      %bb166_18 = "braid.ult"(%bb166_17, %bb166_0) : (i64, i64) -> i64
      "braid.setf"(%bb166_18) {flag = "cf"} : (i64) -> ()
      %bb166_19 = "braid.xor"(%bb166_0, %bb166_17) : (i64, i64) -> i64
      %bb166_20 = "braid.xor"(%bb166_8, %bb166_17) : (i64, i64) -> i64
      %bb166_21 = "braid.and"(%bb166_19, %bb166_20) : (i64, i64) -> i64
      %bb166_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb166_23 = "braid.and"(%bb166_21, %bb166_22) : (i64, i64) -> i64
      "braid.setf"(%bb166_23) {flag = "of"} : (i64) -> ()
      %bb166_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb166_24) {flag = "af"} : (i64) -> ()
      %bb166_32 = "braid.zext"(%bb166_17) {bits = 8 : i64} : (i64) -> i64
      %bb166_33 = "braid.popcnt"(%bb166_32) : (i64) -> i64
      %bb166_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb166_35 = "braid.and"(%bb166_33, %bb166_34) : (i64, i64) -> i64
      %bb166_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb166_37 = "braid.eq"(%bb166_35, %bb166_36) : (i64, i64) -> i64
      "braid.setf"(%bb166_37) {flag = "pf"} : (i64) -> ()
      %bb166_38 = "braid.eq"(%bb166_17, %bb166_36) : (i64, i64) -> i64
      "braid.setf"(%bb166_38) {flag = "zf"} : (i64) -> ()
      %bb166_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb166_40 = "braid.and"(%bb166_17, %bb166_39) : (i64, i64) -> i64
      "braid.setf"(%bb166_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb166_17) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb169] : () -> ()
    ^bb169:  // 0x4011a9
      %bb169_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb169_0 = "braid.zext"(%bb169_1) {bits = 32 : i64} : (i64) -> i64
      %bb169_9 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb169_8 = "braid.zext"(%bb169_9) {bits = 32 : i64} : (i64) -> i64
      %bb169_16 = "braid.xor"(%bb169_0, %bb169_8) : (i64, i64) -> i64
      %bb169_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb169_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb169_17) {flag = "of"} : (i64) -> ()
      %bb169_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb169_24) {flag = "af"} : (i64) -> ()
      %bb169_32 = "braid.zext"(%bb169_16) {bits = 8 : i64} : (i64) -> i64
      %bb169_33 = "braid.popcnt"(%bb169_32) : (i64) -> i64
      %bb169_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb169_35 = "braid.and"(%bb169_33, %bb169_34) : (i64, i64) -> i64
      %bb169_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb169_37 = "braid.eq"(%bb169_35, %bb169_36) : (i64, i64) -> i64
      "braid.setf"(%bb169_37) {flag = "pf"} : (i64) -> ()
      %bb169_38 = "braid.eq"(%bb169_16, %bb169_36) : (i64, i64) -> i64
      "braid.setf"(%bb169_38) {flag = "zf"} : (i64) -> ()
      %bb169_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb169_40 = "braid.and"(%bb169_16, %bb169_39) : (i64, i64) -> i64
      "braid.setf"(%bb169_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb169_16) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb16b] : () -> ()
    ^bb16b:  // 0x4011ab
      %bb16b_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb16b_0 = "braid.zext"(%bb16b_1) {bits = 32 : i64} : (i64) -> i64
      %bb16b_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb16b_13 = "braid.shl"(%bb16b_0, %bb16b_12) : (i64, i64) -> i64
      %bb16b_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb16b_15 = "braid.lshr"(%bb16b_0, %bb16b_14) : (i64, i64) -> i64
      %bb16b_16 = "braid.or"(%bb16b_13, %bb16b_15) : (i64, i64) -> i64
      %bb16b_17 = "braid.zext"(%bb16b_16) {bits = 32 : i64} : (i64) -> i64
      %bb16b_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb16b_19 = "braid.and"(%bb16b_17, %bb16b_18) : (i64, i64) -> i64
      "braid.setf"(%bb16b_19) {flag = "cf"} : (i64) -> ()
      %bb16b_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb16b_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb16b_17) {reg = "rdi"} : (i64) -> ()
      "braid_cf.br"()[^bb16e] : () -> ()
    ^bb16e:  // 0x4011ae
      %bb16e_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb16e_0 = "braid.zext"(%bb16e_1) {bits = 32 : i64} : (i64) -> i64
      %bb16e_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb16e_8 = "braid.zext"(%bb16e_9) {bits = 32 : i64} : (i64) -> i64
      %bb16e_16 = "braid.add"(%bb16e_0, %bb16e_8) : (i64, i64) -> i64
      %bb16e_17 = "braid.zext"(%bb16e_16) {bits = 32 : i64} : (i64) -> i64
      %bb16e_18 = "braid.ult"(%bb16e_17, %bb16e_0) : (i64, i64) -> i64
      "braid.setf"(%bb16e_18) {flag = "cf"} : (i64) -> ()
      %bb16e_19 = "braid.xor"(%bb16e_0, %bb16e_17) : (i64, i64) -> i64
      %bb16e_20 = "braid.xor"(%bb16e_8, %bb16e_17) : (i64, i64) -> i64
      %bb16e_21 = "braid.and"(%bb16e_19, %bb16e_20) : (i64, i64) -> i64
      %bb16e_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb16e_23 = "braid.and"(%bb16e_21, %bb16e_22) : (i64, i64) -> i64
      "braid.setf"(%bb16e_23) {flag = "of"} : (i64) -> ()
      %bb16e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb16e_24) {flag = "af"} : (i64) -> ()
      %bb16e_32 = "braid.zext"(%bb16e_17) {bits = 8 : i64} : (i64) -> i64
      %bb16e_33 = "braid.popcnt"(%bb16e_32) : (i64) -> i64
      %bb16e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb16e_35 = "braid.and"(%bb16e_33, %bb16e_34) : (i64, i64) -> i64
      %bb16e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb16e_37 = "braid.eq"(%bb16e_35, %bb16e_36) : (i64, i64) -> i64
      "braid.setf"(%bb16e_37) {flag = "pf"} : (i64) -> ()
      %bb16e_38 = "braid.eq"(%bb16e_17, %bb16e_36) : (i64, i64) -> i64
      "braid.setf"(%bb16e_38) {flag = "zf"} : (i64) -> ()
      %bb16e_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb16e_40 = "braid.and"(%bb16e_17, %bb16e_39) : (i64, i64) -> i64
      "braid.setf"(%bb16e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb16e_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb171] : () -> ()
    ^bb171:  // 0x4011b1
      %bb171_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb171_0 = "braid.zext"(%bb171_1) {bits = 32 : i64} : (i64) -> i64
      %bb171_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb171_8 = "braid.zext"(%bb171_9) {bits = 32 : i64} : (i64) -> i64
      %bb171_16 = "braid.xor"(%bb171_0, %bb171_8) : (i64, i64) -> i64
      %bb171_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb171_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb171_17) {flag = "of"} : (i64) -> ()
      %bb171_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb171_24) {flag = "af"} : (i64) -> ()
      %bb171_32 = "braid.zext"(%bb171_16) {bits = 8 : i64} : (i64) -> i64
      %bb171_33 = "braid.popcnt"(%bb171_32) : (i64) -> i64
      %bb171_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb171_35 = "braid.and"(%bb171_33, %bb171_34) : (i64, i64) -> i64
      %bb171_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb171_37 = "braid.eq"(%bb171_35, %bb171_36) : (i64, i64) -> i64
      "braid.setf"(%bb171_37) {flag = "pf"} : (i64) -> ()
      %bb171_38 = "braid.eq"(%bb171_16, %bb171_36) : (i64, i64) -> i64
      "braid.setf"(%bb171_38) {flag = "zf"} : (i64) -> ()
      %bb171_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb171_40 = "braid.and"(%bb171_16, %bb171_39) : (i64, i64) -> i64
      "braid.setf"(%bb171_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb171_16) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb174] : () -> ()
    ^bb174:  // 0x4011b4
      %bb174_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb174_0 = "braid.zext"(%bb174_1) {bits = 32 : i64} : (i64) -> i64
      %bb174_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb174_13 = "braid.shl"(%bb174_0, %bb174_12) : (i64, i64) -> i64
      %bb174_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb174_15 = "braid.lshr"(%bb174_0, %bb174_14) : (i64, i64) -> i64
      %bb174_16 = "braid.or"(%bb174_13, %bb174_15) : (i64, i64) -> i64
      %bb174_17 = "braid.zext"(%bb174_16) {bits = 32 : i64} : (i64) -> i64
      %bb174_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb174_19 = "braid.and"(%bb174_17, %bb174_18) : (i64, i64) -> i64
      "braid.setf"(%bb174_19) {flag = "cf"} : (i64) -> ()
      %bb174_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb174_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb174_17) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb178] : () -> ()
    ^bb178:  // 0x4011b8
      %bb178_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb178_0 = "braid.zext"(%bb178_1) {bits = 32 : i64} : (i64) -> i64
      %bb178_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb178_8 = "braid.zext"(%bb178_9) {bits = 32 : i64} : (i64) -> i64
      %bb178_16 = "braid.add"(%bb178_0, %bb178_8) : (i64, i64) -> i64
      %bb178_17 = "braid.zext"(%bb178_16) {bits = 32 : i64} : (i64) -> i64
      %bb178_18 = "braid.ult"(%bb178_17, %bb178_0) : (i64, i64) -> i64
      "braid.setf"(%bb178_18) {flag = "cf"} : (i64) -> ()
      %bb178_19 = "braid.xor"(%bb178_0, %bb178_17) : (i64, i64) -> i64
      %bb178_20 = "braid.xor"(%bb178_8, %bb178_17) : (i64, i64) -> i64
      %bb178_21 = "braid.and"(%bb178_19, %bb178_20) : (i64, i64) -> i64
      %bb178_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb178_23 = "braid.and"(%bb178_21, %bb178_22) : (i64, i64) -> i64
      "braid.setf"(%bb178_23) {flag = "of"} : (i64) -> ()
      %bb178_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb178_24) {flag = "af"} : (i64) -> ()
      %bb178_32 = "braid.zext"(%bb178_17) {bits = 8 : i64} : (i64) -> i64
      %bb178_33 = "braid.popcnt"(%bb178_32) : (i64) -> i64
      %bb178_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb178_35 = "braid.and"(%bb178_33, %bb178_34) : (i64, i64) -> i64
      %bb178_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb178_37 = "braid.eq"(%bb178_35, %bb178_36) : (i64, i64) -> i64
      "braid.setf"(%bb178_37) {flag = "pf"} : (i64) -> ()
      %bb178_38 = "braid.eq"(%bb178_17, %bb178_36) : (i64, i64) -> i64
      "braid.setf"(%bb178_38) {flag = "zf"} : (i64) -> ()
      %bb178_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb178_40 = "braid.and"(%bb178_17, %bb178_39) : (i64, i64) -> i64
      "braid.setf"(%bb178_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb178_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb17b] : () -> ()
    ^bb17b:  // 0x4011bb
      %bb17b_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb17b_0 = "braid.zext"(%bb17b_1) {bits = 32 : i64} : (i64) -> i64
      %bb17b_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb17b_8 = "braid.zext"(%bb17b_9) {bits = 32 : i64} : (i64) -> i64
      %bb17b_16 = "braid.xor"(%bb17b_0, %bb17b_8) : (i64, i64) -> i64
      %bb17b_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb17b_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb17b_17) {flag = "of"} : (i64) -> ()
      %bb17b_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb17b_24) {flag = "af"} : (i64) -> ()
      %bb17b_32 = "braid.zext"(%bb17b_16) {bits = 8 : i64} : (i64) -> i64
      %bb17b_33 = "braid.popcnt"(%bb17b_32) : (i64) -> i64
      %bb17b_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb17b_35 = "braid.and"(%bb17b_33, %bb17b_34) : (i64, i64) -> i64
      %bb17b_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb17b_37 = "braid.eq"(%bb17b_35, %bb17b_36) : (i64, i64) -> i64
      "braid.setf"(%bb17b_37) {flag = "pf"} : (i64) -> ()
      %bb17b_38 = "braid.eq"(%bb17b_16, %bb17b_36) : (i64, i64) -> i64
      "braid.setf"(%bb17b_38) {flag = "zf"} : (i64) -> ()
      %bb17b_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb17b_40 = "braid.and"(%bb17b_16, %bb17b_39) : (i64, i64) -> i64
      "braid.setf"(%bb17b_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb17b_16) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb17e] : () -> ()
    ^bb17e:  // 0x4011be
      %bb17e_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb17e_0 = "braid.zext"(%bb17e_1) {bits = 32 : i64} : (i64) -> i64
      %bb17e_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb17e_13 = "braid.shl"(%bb17e_0, %bb17e_12) : (i64, i64) -> i64
      %bb17e_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb17e_15 = "braid.lshr"(%bb17e_0, %bb17e_14) : (i64, i64) -> i64
      %bb17e_16 = "braid.or"(%bb17e_13, %bb17e_15) : (i64, i64) -> i64
      %bb17e_17 = "braid.zext"(%bb17e_16) {bits = 32 : i64} : (i64) -> i64
      %bb17e_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb17e_19 = "braid.and"(%bb17e_17, %bb17e_18) : (i64, i64) -> i64
      "braid.setf"(%bb17e_19) {flag = "cf"} : (i64) -> ()
      %bb17e_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb17e_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb17e_17) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb182] : () -> ()
    ^bb182:  // 0x4011c2
      %bb182_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb182_0 = "braid.zext"(%bb182_1) {bits = 32 : i64} : (i64) -> i64
      %bb182_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb182_8 = "braid.zext"(%bb182_9) {bits = 32 : i64} : (i64) -> i64
      %bb182_16 = "braid.add"(%bb182_0, %bb182_8) : (i64, i64) -> i64
      %bb182_17 = "braid.zext"(%bb182_16) {bits = 32 : i64} : (i64) -> i64
      %bb182_18 = "braid.ult"(%bb182_17, %bb182_0) : (i64, i64) -> i64
      "braid.setf"(%bb182_18) {flag = "cf"} : (i64) -> ()
      %bb182_19 = "braid.xor"(%bb182_0, %bb182_17) : (i64, i64) -> i64
      %bb182_20 = "braid.xor"(%bb182_8, %bb182_17) : (i64, i64) -> i64
      %bb182_21 = "braid.and"(%bb182_19, %bb182_20) : (i64, i64) -> i64
      %bb182_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb182_23 = "braid.and"(%bb182_21, %bb182_22) : (i64, i64) -> i64
      "braid.setf"(%bb182_23) {flag = "of"} : (i64) -> ()
      %bb182_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb182_24) {flag = "af"} : (i64) -> ()
      %bb182_32 = "braid.zext"(%bb182_17) {bits = 8 : i64} : (i64) -> i64
      %bb182_33 = "braid.popcnt"(%bb182_32) : (i64) -> i64
      %bb182_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb182_35 = "braid.and"(%bb182_33, %bb182_34) : (i64, i64) -> i64
      %bb182_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb182_37 = "braid.eq"(%bb182_35, %bb182_36) : (i64, i64) -> i64
      "braid.setf"(%bb182_37) {flag = "pf"} : (i64) -> ()
      %bb182_38 = "braid.eq"(%bb182_17, %bb182_36) : (i64, i64) -> i64
      "braid.setf"(%bb182_38) {flag = "zf"} : (i64) -> ()
      %bb182_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb182_40 = "braid.and"(%bb182_17, %bb182_39) : (i64, i64) -> i64
      "braid.setf"(%bb182_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb182_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb185] : () -> ()
    ^bb185:  // 0x4011c5
      %bb185_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb185_0 = "braid.zext"(%bb185_1) {bits = 32 : i64} : (i64) -> i64
      %bb185_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb185_10 = "braid.const"() {value = -92 : i64} : () -> i64
      %bb185_8 = "braid.add"(%bb185_9, %bb185_10) : (i64, i64) -> i64
      "braid.store"(%bb185_8, %bb185_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb189] : () -> ()
    ^bb189:  // 0x4011c9
      %bb189_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb189_0 = "braid.zext"(%bb189_1) {bits = 32 : i64} : (i64) -> i64
      %bb189_9 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb189_8 = "braid.zext"(%bb189_9) {bits = 32 : i64} : (i64) -> i64
      %bb189_16 = "braid.xor"(%bb189_0, %bb189_8) : (i64, i64) -> i64
      %bb189_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb189_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb189_17) {flag = "of"} : (i64) -> ()
      %bb189_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb189_24) {flag = "af"} : (i64) -> ()
      %bb189_32 = "braid.zext"(%bb189_16) {bits = 8 : i64} : (i64) -> i64
      %bb189_33 = "braid.popcnt"(%bb189_32) : (i64) -> i64
      %bb189_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb189_35 = "braid.and"(%bb189_33, %bb189_34) : (i64, i64) -> i64
      %bb189_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb189_37 = "braid.eq"(%bb189_35, %bb189_36) : (i64, i64) -> i64
      "braid.setf"(%bb189_37) {flag = "pf"} : (i64) -> ()
      %bb189_38 = "braid.eq"(%bb189_16, %bb189_36) : (i64, i64) -> i64
      "braid.setf"(%bb189_38) {flag = "zf"} : (i64) -> ()
      %bb189_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb189_40 = "braid.and"(%bb189_16, %bb189_39) : (i64, i64) -> i64
      "braid.setf"(%bb189_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb189_16) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb18c] : () -> ()
    ^bb18c:  // 0x4011cc
      %bb18c_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb18c_3 = "braid.const"() {value = -20 : i64} : () -> i64
      %bb18c_1 = "braid.add"(%bb18c_2, %bb18c_3) : (i64, i64) -> i64
      %bb18c_0 = "braid.load"(%bb18c_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb18c_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x4011d0
      %bb190_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb190_0 = "braid.zext"(%bb190_1) {bits = 32 : i64} : (i64) -> i64
      %bb190_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb190_13 = "braid.shl"(%bb190_0, %bb190_12) : (i64, i64) -> i64
      %bb190_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb190_15 = "braid.lshr"(%bb190_0, %bb190_14) : (i64, i64) -> i64
      %bb190_16 = "braid.or"(%bb190_13, %bb190_15) : (i64, i64) -> i64
      %bb190_17 = "braid.zext"(%bb190_16) {bits = 32 : i64} : (i64) -> i64
      %bb190_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb190_19 = "braid.and"(%bb190_17, %bb190_18) : (i64, i64) -> i64
      "braid.setf"(%bb190_19) {flag = "cf"} : (i64) -> ()
      %bb190_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb190_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb190_17) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb194] : () -> ()
    ^bb194:  // 0x4011d4
      %bb194_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb194_0 = "braid.zext"(%bb194_1) {bits = 32 : i64} : (i64) -> i64
      %bb194_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb194_8 = "braid.zext"(%bb194_9) {bits = 32 : i64} : (i64) -> i64
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
      "braid.set"(%bb194_17) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb197] : () -> ()
    ^bb197:  // 0x4011d7
      %bb197_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb197_0 = "braid.zext"(%bb197_1) {bits = 32 : i64} : (i64) -> i64
      %bb197_9 = "braid.get"() {reg = "rsi"} : () -> i64
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
      "braid.set"(%bb197_16) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb19a] : () -> ()
    ^bb19a:  // 0x4011da
      %bb19a_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb19a_0 = "braid.zext"(%bb19a_1) {bits = 32 : i64} : (i64) -> i64
      %bb19a_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb19a_13 = "braid.shl"(%bb19a_0, %bb19a_12) : (i64, i64) -> i64
      %bb19a_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb19a_15 = "braid.lshr"(%bb19a_0, %bb19a_14) : (i64, i64) -> i64
      %bb19a_16 = "braid.or"(%bb19a_13, %bb19a_15) : (i64, i64) -> i64
      %bb19a_17 = "braid.zext"(%bb19a_16) {bits = 32 : i64} : (i64) -> i64
      %bb19a_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb19a_19 = "braid.and"(%bb19a_17, %bb19a_18) : (i64, i64) -> i64
      "braid.setf"(%bb19a_19) {flag = "cf"} : (i64) -> ()
      %bb19a_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb19a_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb19a_17) {reg = "r10"} : (i64) -> ()
      "braid_cf.br"()[^bb19e] : () -> ()
    ^bb19e:  // 0x4011de
      %bb19e_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb19e_0 = "braid.zext"(%bb19e_1) {bits = 32 : i64} : (i64) -> i64
      %bb19e_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb19e_8 = "braid.zext"(%bb19e_9) {bits = 32 : i64} : (i64) -> i64
      %bb19e_16 = "braid.add"(%bb19e_0, %bb19e_8) : (i64, i64) -> i64
      %bb19e_17 = "braid.zext"(%bb19e_16) {bits = 32 : i64} : (i64) -> i64
      %bb19e_18 = "braid.ult"(%bb19e_17, %bb19e_0) : (i64, i64) -> i64
      "braid.setf"(%bb19e_18) {flag = "cf"} : (i64) -> ()
      %bb19e_19 = "braid.xor"(%bb19e_0, %bb19e_17) : (i64, i64) -> i64
      %bb19e_20 = "braid.xor"(%bb19e_8, %bb19e_17) : (i64, i64) -> i64
      %bb19e_21 = "braid.and"(%bb19e_19, %bb19e_20) : (i64, i64) -> i64
      %bb19e_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb19e_23 = "braid.and"(%bb19e_21, %bb19e_22) : (i64, i64) -> i64
      "braid.setf"(%bb19e_23) {flag = "of"} : (i64) -> ()
      %bb19e_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb19e_24) {flag = "af"} : (i64) -> ()
      %bb19e_32 = "braid.zext"(%bb19e_17) {bits = 8 : i64} : (i64) -> i64
      %bb19e_33 = "braid.popcnt"(%bb19e_32) : (i64) -> i64
      %bb19e_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb19e_35 = "braid.and"(%bb19e_33, %bb19e_34) : (i64, i64) -> i64
      %bb19e_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb19e_37 = "braid.eq"(%bb19e_35, %bb19e_36) : (i64, i64) -> i64
      "braid.setf"(%bb19e_37) {flag = "pf"} : (i64) -> ()
      %bb19e_38 = "braid.eq"(%bb19e_17, %bb19e_36) : (i64, i64) -> i64
      "braid.setf"(%bb19e_38) {flag = "zf"} : (i64) -> ()
      %bb19e_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb19e_40 = "braid.and"(%bb19e_17, %bb19e_39) : (i64, i64) -> i64
      "braid.setf"(%bb19e_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb19e_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb1a1] : () -> ()
    ^bb1a1:  // 0x4011e1
      %bb1a1_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb1a1_0 = "braid.zext"(%bb1a1_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a1_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb1a1_8 = "braid.zext"(%bb1a1_9) {bits = 32 : i64} : (i64) -> i64
      %bb1a1_16 = "braid.xor"(%bb1a1_0, %bb1a1_8) : (i64, i64) -> i64
      %bb1a1_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1a1_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1a1_17) {flag = "of"} : (i64) -> ()
      %bb1a1_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1a1_24) {flag = "af"} : (i64) -> ()
      %bb1a1_32 = "braid.zext"(%bb1a1_16) {bits = 8 : i64} : (i64) -> i64
      %bb1a1_33 = "braid.popcnt"(%bb1a1_32) : (i64) -> i64
      %bb1a1_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1a1_35 = "braid.and"(%bb1a1_33, %bb1a1_34) : (i64, i64) -> i64
      %bb1a1_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1a1_37 = "braid.eq"(%bb1a1_35, %bb1a1_36) : (i64, i64) -> i64
      "braid.setf"(%bb1a1_37) {flag = "pf"} : (i64) -> ()
      %bb1a1_38 = "braid.eq"(%bb1a1_16, %bb1a1_36) : (i64, i64) -> i64
      "braid.setf"(%bb1a1_38) {flag = "zf"} : (i64) -> ()
      %bb1a1_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1a1_40 = "braid.and"(%bb1a1_16, %bb1a1_39) : (i64, i64) -> i64
      "braid.setf"(%bb1a1_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1a1_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb1a4] : () -> ()
    ^bb1a4:  // 0x4011e4
      %bb1a4_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb1a4_0 = "braid.zext"(%bb1a4_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a4_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1a4_13 = "braid.shl"(%bb1a4_0, %bb1a4_12) : (i64, i64) -> i64
      %bb1a4_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1a4_15 = "braid.lshr"(%bb1a4_0, %bb1a4_14) : (i64, i64) -> i64
      %bb1a4_16 = "braid.or"(%bb1a4_13, %bb1a4_15) : (i64, i64) -> i64
      %bb1a4_17 = "braid.zext"(%bb1a4_16) {bits = 32 : i64} : (i64) -> i64
      %bb1a4_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1a4_19 = "braid.and"(%bb1a4_17, %bb1a4_18) : (i64, i64) -> i64
      "braid.setf"(%bb1a4_19) {flag = "cf"} : (i64) -> ()
      %bb1a4_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1a4_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb1a4_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb1a8] : () -> ()
    ^bb1a8:  // 0x4011e8
      %bb1a8_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb1a8_0 = "braid.zext"(%bb1a8_1) {bits = 32 : i64} : (i64) -> i64
      %bb1a8_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1a8_8 = "braid.zext"(%bb1a8_9) {bits = 32 : i64} : (i64) -> i64
      %bb1a8_16 = "braid.add"(%bb1a8_0, %bb1a8_8) : (i64, i64) -> i64
      %bb1a8_17 = "braid.zext"(%bb1a8_16) {bits = 32 : i64} : (i64) -> i64
      %bb1a8_18 = "braid.ult"(%bb1a8_17, %bb1a8_0) : (i64, i64) -> i64
      "braid.setf"(%bb1a8_18) {flag = "cf"} : (i64) -> ()
      %bb1a8_19 = "braid.xor"(%bb1a8_0, %bb1a8_17) : (i64, i64) -> i64
      %bb1a8_20 = "braid.xor"(%bb1a8_8, %bb1a8_17) : (i64, i64) -> i64
      %bb1a8_21 = "braid.and"(%bb1a8_19, %bb1a8_20) : (i64, i64) -> i64
      %bb1a8_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1a8_23 = "braid.and"(%bb1a8_21, %bb1a8_22) : (i64, i64) -> i64
      "braid.setf"(%bb1a8_23) {flag = "of"} : (i64) -> ()
      %bb1a8_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1a8_24) {flag = "af"} : (i64) -> ()
      %bb1a8_32 = "braid.zext"(%bb1a8_17) {bits = 8 : i64} : (i64) -> i64
      %bb1a8_33 = "braid.popcnt"(%bb1a8_32) : (i64) -> i64
      %bb1a8_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1a8_35 = "braid.and"(%bb1a8_33, %bb1a8_34) : (i64, i64) -> i64
      %bb1a8_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1a8_37 = "braid.eq"(%bb1a8_35, %bb1a8_36) : (i64, i64) -> i64
      "braid.setf"(%bb1a8_37) {flag = "pf"} : (i64) -> ()
      %bb1a8_38 = "braid.eq"(%bb1a8_17, %bb1a8_36) : (i64, i64) -> i64
      "braid.setf"(%bb1a8_38) {flag = "zf"} : (i64) -> ()
      %bb1a8_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1a8_40 = "braid.and"(%bb1a8_17, %bb1a8_39) : (i64, i64) -> i64
      "braid.setf"(%bb1a8_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1a8_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1ab] : () -> ()
    ^bb1ab:  // 0x4011eb
      %bb1ab_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb1ab_0 = "braid.zext"(%bb1ab_1) {bits = 32 : i64} : (i64) -> i64
      %bb1ab_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1ab_8 = "braid.zext"(%bb1ab_9) {bits = 32 : i64} : (i64) -> i64
      %bb1ab_16 = "braid.xor"(%bb1ab_0, %bb1ab_8) : (i64, i64) -> i64
      %bb1ab_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1ab_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1ab_17) {flag = "of"} : (i64) -> ()
      %bb1ab_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1ab_24) {flag = "af"} : (i64) -> ()
      %bb1ab_32 = "braid.zext"(%bb1ab_16) {bits = 8 : i64} : (i64) -> i64
      %bb1ab_33 = "braid.popcnt"(%bb1ab_32) : (i64) -> i64
      %bb1ab_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1ab_35 = "braid.and"(%bb1ab_33, %bb1ab_34) : (i64, i64) -> i64
      %bb1ab_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1ab_37 = "braid.eq"(%bb1ab_35, %bb1ab_36) : (i64, i64) -> i64
      "braid.setf"(%bb1ab_37) {flag = "pf"} : (i64) -> ()
      %bb1ab_38 = "braid.eq"(%bb1ab_16, %bb1ab_36) : (i64, i64) -> i64
      "braid.setf"(%bb1ab_38) {flag = "zf"} : (i64) -> ()
      %bb1ab_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1ab_40 = "braid.and"(%bb1ab_16, %bb1ab_39) : (i64, i64) -> i64
      "braid.setf"(%bb1ab_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1ab_16) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb1ae] : () -> ()
    ^bb1ae:  // 0x4011ee
      %bb1ae_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb1ae_0 = "braid.zext"(%bb1ae_1) {bits = 32 : i64} : (i64) -> i64
      %bb1ae_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb1ae_13 = "braid.shl"(%bb1ae_0, %bb1ae_12) : (i64, i64) -> i64
      %bb1ae_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb1ae_15 = "braid.lshr"(%bb1ae_0, %bb1ae_14) : (i64, i64) -> i64
      %bb1ae_16 = "braid.or"(%bb1ae_13, %bb1ae_15) : (i64, i64) -> i64
      %bb1ae_17 = "braid.zext"(%bb1ae_16) {bits = 32 : i64} : (i64) -> i64
      %bb1ae_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1ae_19 = "braid.and"(%bb1ae_17, %bb1ae_18) : (i64, i64) -> i64
      "braid.setf"(%bb1ae_19) {flag = "cf"} : (i64) -> ()
      %bb1ae_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1ae_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb1ae_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb1b2] : () -> ()
    ^bb1b2:  // 0x4011f2
      %bb1b2_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb1b2_0 = "braid.zext"(%bb1b2_1) {bits = 32 : i64} : (i64) -> i64
      %bb1b2_9 = "braid.get"() {reg = "r11"} : () -> i64
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
      "braid.set"(%bb1b2_17) {reg = "r11"} : (i64) -> ()
      "braid_cf.br"()[^bb1b5] : () -> ()
    ^bb1b5:  // 0x4011f5
      %bb1b5_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb1b5_0 = "braid.zext"(%bb1b5_1) {bits = 32 : i64} : (i64) -> i64
      %bb1b5_9 = "braid.get"() {reg = "r11"} : () -> i64
      %bb1b5_8 = "braid.zext"(%bb1b5_9) {bits = 32 : i64} : (i64) -> i64
      %bb1b5_16 = "braid.xor"(%bb1b5_0, %bb1b5_8) : (i64, i64) -> i64
      %bb1b5_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1b5_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1b5_17) {flag = "of"} : (i64) -> ()
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
      %bb1b5_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1b5_40 = "braid.and"(%bb1b5_16, %bb1b5_39) : (i64, i64) -> i64
      "braid.setf"(%bb1b5_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1b5_16) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb1b8] : () -> ()
    ^bb1b8:  // 0x4011f8
      %bb1b8_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb1b8_0 = "braid.zext"(%bb1b8_1) {bits = 32 : i64} : (i64) -> i64
      %bb1b8_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1b8_13 = "braid.shl"(%bb1b8_0, %bb1b8_12) : (i64, i64) -> i64
      %bb1b8_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb1b8_15 = "braid.lshr"(%bb1b8_0, %bb1b8_14) : (i64, i64) -> i64
      %bb1b8_16 = "braid.or"(%bb1b8_13, %bb1b8_15) : (i64, i64) -> i64
      %bb1b8_17 = "braid.zext"(%bb1b8_16) {bits = 32 : i64} : (i64) -> i64
      %bb1b8_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1b8_19 = "braid.and"(%bb1b8_17, %bb1b8_18) : (i64, i64) -> i64
      "braid.setf"(%bb1b8_19) {flag = "cf"} : (i64) -> ()
      %bb1b8_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1b8_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb1b8_17) {reg = "r8"} : (i64) -> ()
      "braid_cf.br"()[^bb1bc] : () -> ()
    ^bb1bc:  // 0x4011fc
      %bb1bc_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb1bc_0 = "braid.zext"(%bb1bc_1) {bits = 32 : i64} : (i64) -> i64
      %bb1bc_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1bc_8 = "braid.zext"(%bb1bc_9) {bits = 32 : i64} : (i64) -> i64
      %bb1bc_16 = "braid.add"(%bb1bc_0, %bb1bc_8) : (i64, i64) -> i64
      %bb1bc_17 = "braid.zext"(%bb1bc_16) {bits = 32 : i64} : (i64) -> i64
      %bb1bc_18 = "braid.ult"(%bb1bc_17, %bb1bc_0) : (i64, i64) -> i64
      "braid.setf"(%bb1bc_18) {flag = "cf"} : (i64) -> ()
      %bb1bc_19 = "braid.xor"(%bb1bc_0, %bb1bc_17) : (i64, i64) -> i64
      %bb1bc_20 = "braid.xor"(%bb1bc_8, %bb1bc_17) : (i64, i64) -> i64
      %bb1bc_21 = "braid.and"(%bb1bc_19, %bb1bc_20) : (i64, i64) -> i64
      %bb1bc_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1bc_23 = "braid.and"(%bb1bc_21, %bb1bc_22) : (i64, i64) -> i64
      "braid.setf"(%bb1bc_23) {flag = "of"} : (i64) -> ()
      %bb1bc_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1bc_24) {flag = "af"} : (i64) -> ()
      %bb1bc_32 = "braid.zext"(%bb1bc_17) {bits = 8 : i64} : (i64) -> i64
      %bb1bc_33 = "braid.popcnt"(%bb1bc_32) : (i64) -> i64
      %bb1bc_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1bc_35 = "braid.and"(%bb1bc_33, %bb1bc_34) : (i64, i64) -> i64
      %bb1bc_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1bc_37 = "braid.eq"(%bb1bc_35, %bb1bc_36) : (i64, i64) -> i64
      "braid.setf"(%bb1bc_37) {flag = "pf"} : (i64) -> ()
      %bb1bc_38 = "braid.eq"(%bb1bc_17, %bb1bc_36) : (i64, i64) -> i64
      "braid.setf"(%bb1bc_38) {flag = "zf"} : (i64) -> ()
      %bb1bc_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1bc_40 = "braid.and"(%bb1bc_17, %bb1bc_39) : (i64, i64) -> i64
      "braid.setf"(%bb1bc_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1bc_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb1bf] : () -> ()
    ^bb1bf:  // 0x4011ff
      %bb1bf_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb1bf_0 = "braid.zext"(%bb1bf_1) {bits = 32 : i64} : (i64) -> i64
      %bb1bf_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb1bf_8 = "braid.zext"(%bb1bf_9) {bits = 32 : i64} : (i64) -> i64
      %bb1bf_16 = "braid.xor"(%bb1bf_0, %bb1bf_8) : (i64, i64) -> i64
      %bb1bf_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1bf_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1bf_17) {flag = "of"} : (i64) -> ()
      %bb1bf_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1bf_24) {flag = "af"} : (i64) -> ()
      %bb1bf_32 = "braid.zext"(%bb1bf_16) {bits = 8 : i64} : (i64) -> i64
      %bb1bf_33 = "braid.popcnt"(%bb1bf_32) : (i64) -> i64
      %bb1bf_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1bf_35 = "braid.and"(%bb1bf_33, %bb1bf_34) : (i64, i64) -> i64
      %bb1bf_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1bf_37 = "braid.eq"(%bb1bf_35, %bb1bf_36) : (i64, i64) -> i64
      "braid.setf"(%bb1bf_37) {flag = "pf"} : (i64) -> ()
      %bb1bf_38 = "braid.eq"(%bb1bf_16, %bb1bf_36) : (i64, i64) -> i64
      "braid.setf"(%bb1bf_38) {flag = "zf"} : (i64) -> ()
      %bb1bf_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1bf_40 = "braid.and"(%bb1bf_16, %bb1bf_39) : (i64, i64) -> i64
      "braid.setf"(%bb1bf_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1bf_16) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb1c2] : () -> ()
    ^bb1c2:  // 0x401202
      %bb1c2_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb1c2_0 = "braid.zext"(%bb1c2_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c2_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1c2_13 = "braid.shl"(%bb1c2_0, %bb1c2_12) : (i64, i64) -> i64
      %bb1c2_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1c2_15 = "braid.lshr"(%bb1c2_0, %bb1c2_14) : (i64, i64) -> i64
      %bb1c2_16 = "braid.or"(%bb1c2_13, %bb1c2_15) : (i64, i64) -> i64
      %bb1c2_17 = "braid.zext"(%bb1c2_16) {bits = 32 : i64} : (i64) -> i64
      %bb1c2_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1c2_19 = "braid.and"(%bb1c2_17, %bb1c2_18) : (i64, i64) -> i64
      "braid.setf"(%bb1c2_19) {flag = "cf"} : (i64) -> ()
      %bb1c2_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1c2_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb1c2_17) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb1c6] : () -> ()
    ^bb1c6:  // 0x401206
      %bb1c6_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1c6_0 = "braid.zext"(%bb1c6_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c6_9 = "braid.get"() {reg = "r15"} : () -> i64
      %bb1c6_8 = "braid.zext"(%bb1c6_9) {bits = 32 : i64} : (i64) -> i64
      %bb1c6_16 = "braid.add"(%bb1c6_0, %bb1c6_8) : (i64, i64) -> i64
      %bb1c6_17 = "braid.zext"(%bb1c6_16) {bits = 32 : i64} : (i64) -> i64
      %bb1c6_18 = "braid.ult"(%bb1c6_17, %bb1c6_0) : (i64, i64) -> i64
      "braid.setf"(%bb1c6_18) {flag = "cf"} : (i64) -> ()
      %bb1c6_19 = "braid.xor"(%bb1c6_0, %bb1c6_17) : (i64, i64) -> i64
      %bb1c6_20 = "braid.xor"(%bb1c6_8, %bb1c6_17) : (i64, i64) -> i64
      %bb1c6_21 = "braid.and"(%bb1c6_19, %bb1c6_20) : (i64, i64) -> i64
      %bb1c6_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1c6_23 = "braid.and"(%bb1c6_21, %bb1c6_22) : (i64, i64) -> i64
      "braid.setf"(%bb1c6_23) {flag = "of"} : (i64) -> ()
      %bb1c6_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1c6_24) {flag = "af"} : (i64) -> ()
      %bb1c6_32 = "braid.zext"(%bb1c6_17) {bits = 8 : i64} : (i64) -> i64
      %bb1c6_33 = "braid.popcnt"(%bb1c6_32) : (i64) -> i64
      %bb1c6_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1c6_35 = "braid.and"(%bb1c6_33, %bb1c6_34) : (i64, i64) -> i64
      %bb1c6_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c6_37 = "braid.eq"(%bb1c6_35, %bb1c6_36) : (i64, i64) -> i64
      "braid.setf"(%bb1c6_37) {flag = "pf"} : (i64) -> ()
      %bb1c6_38 = "braid.eq"(%bb1c6_17, %bb1c6_36) : (i64, i64) -> i64
      "braid.setf"(%bb1c6_38) {flag = "zf"} : (i64) -> ()
      %bb1c6_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1c6_40 = "braid.and"(%bb1c6_17, %bb1c6_39) : (i64, i64) -> i64
      "braid.setf"(%bb1c6_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1c6_17) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb1c9] : () -> ()
    ^bb1c9:  // 0x401209
      %bb1c9_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb1c9_0 = "braid.zext"(%bb1c9_1) {bits = 32 : i64} : (i64) -> i64
      %bb1c9_9 = "braid.get"() {reg = "r15"} : () -> i64
      %bb1c9_8 = "braid.zext"(%bb1c9_9) {bits = 32 : i64} : (i64) -> i64
      %bb1c9_16 = "braid.xor"(%bb1c9_0, %bb1c9_8) : (i64, i64) -> i64
      %bb1c9_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1c9_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1c9_17) {flag = "of"} : (i64) -> ()
      %bb1c9_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1c9_24) {flag = "af"} : (i64) -> ()
      %bb1c9_32 = "braid.zext"(%bb1c9_16) {bits = 8 : i64} : (i64) -> i64
      %bb1c9_33 = "braid.popcnt"(%bb1c9_32) : (i64) -> i64
      %bb1c9_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1c9_35 = "braid.and"(%bb1c9_33, %bb1c9_34) : (i64, i64) -> i64
      %bb1c9_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c9_37 = "braid.eq"(%bb1c9_35, %bb1c9_36) : (i64, i64) -> i64
      "braid.setf"(%bb1c9_37) {flag = "pf"} : (i64) -> ()
      %bb1c9_38 = "braid.eq"(%bb1c9_16, %bb1c9_36) : (i64, i64) -> i64
      "braid.setf"(%bb1c9_38) {flag = "zf"} : (i64) -> ()
      %bb1c9_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1c9_40 = "braid.and"(%bb1c9_16, %bb1c9_39) : (i64, i64) -> i64
      "braid.setf"(%bb1c9_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1c9_16) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb1cc] : () -> ()
    ^bb1cc:  // 0x40120c
      %bb1cc_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb1cc_0 = "braid.zext"(%bb1cc_1) {bits = 32 : i64} : (i64) -> i64
      %bb1cc_12 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1cc_13 = "braid.shl"(%bb1cc_0, %bb1cc_12) : (i64, i64) -> i64
      %bb1cc_14 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb1cc_15 = "braid.lshr"(%bb1cc_0, %bb1cc_14) : (i64, i64) -> i64
      %bb1cc_16 = "braid.or"(%bb1cc_13, %bb1cc_15) : (i64, i64) -> i64
      %bb1cc_17 = "braid.zext"(%bb1cc_16) {bits = 32 : i64} : (i64) -> i64
      %bb1cc_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1cc_19 = "braid.and"(%bb1cc_17, %bb1cc_18) : (i64, i64) -> i64
      "braid.setf"(%bb1cc_19) {flag = "cf"} : (i64) -> ()
      %bb1cc_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1cc_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb1cc_17) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb1cf] : () -> ()
    ^bb1cf:  // 0x40120f
      %bb1cf_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1cf_3 = "braid.const"() {value = -100 : i64} : () -> i64
      %bb1cf_1 = "braid.add"(%bb1cf_2, %bb1cf_3) : (i64, i64) -> i64
      %bb1cf_0 = "braid.load"(%bb1cf_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb1cf_0) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb1d4] : () -> ()
    ^bb1d4:  // 0x401214
      %bb1d4_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb1d4_0 = "braid.zext"(%bb1d4_1) {bits = 32 : i64} : (i64) -> i64
      %bb1d4_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb1d4_8 = "braid.zext"(%bb1d4_9) {bits = 32 : i64} : (i64) -> i64
      %bb1d4_16 = "braid.add"(%bb1d4_0, %bb1d4_8) : (i64, i64) -> i64
      %bb1d4_17 = "braid.zext"(%bb1d4_16) {bits = 32 : i64} : (i64) -> i64
      %bb1d4_18 = "braid.ult"(%bb1d4_17, %bb1d4_0) : (i64, i64) -> i64
      "braid.setf"(%bb1d4_18) {flag = "cf"} : (i64) -> ()
      %bb1d4_19 = "braid.xor"(%bb1d4_0, %bb1d4_17) : (i64, i64) -> i64
      %bb1d4_20 = "braid.xor"(%bb1d4_8, %bb1d4_17) : (i64, i64) -> i64
      %bb1d4_21 = "braid.and"(%bb1d4_19, %bb1d4_20) : (i64, i64) -> i64
      %bb1d4_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1d4_23 = "braid.and"(%bb1d4_21, %bb1d4_22) : (i64, i64) -> i64
      "braid.setf"(%bb1d4_23) {flag = "of"} : (i64) -> ()
      %bb1d4_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1d4_24) {flag = "af"} : (i64) -> ()
      %bb1d4_32 = "braid.zext"(%bb1d4_17) {bits = 8 : i64} : (i64) -> i64
      %bb1d4_33 = "braid.popcnt"(%bb1d4_32) : (i64) -> i64
      %bb1d4_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1d4_35 = "braid.and"(%bb1d4_33, %bb1d4_34) : (i64, i64) -> i64
      %bb1d4_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d4_37 = "braid.eq"(%bb1d4_35, %bb1d4_36) : (i64, i64) -> i64
      "braid.setf"(%bb1d4_37) {flag = "pf"} : (i64) -> ()
      %bb1d4_38 = "braid.eq"(%bb1d4_17, %bb1d4_36) : (i64, i64) -> i64
      "braid.setf"(%bb1d4_38) {flag = "zf"} : (i64) -> ()
      %bb1d4_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1d4_40 = "braid.and"(%bb1d4_17, %bb1d4_39) : (i64, i64) -> i64
      "braid.setf"(%bb1d4_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1d4_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb1d7] : () -> ()
    ^bb1d7:  // 0x401217
      %bb1d7_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1d7_0 = "braid.zext"(%bb1d7_1) {bits = 32 : i64} : (i64) -> i64
      %bb1d7_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb1d7_8 = "braid.zext"(%bb1d7_9) {bits = 32 : i64} : (i64) -> i64
      %bb1d7_16 = "braid.xor"(%bb1d7_0, %bb1d7_8) : (i64, i64) -> i64
      %bb1d7_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1d7_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1d7_17) {flag = "of"} : (i64) -> ()
      %bb1d7_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1d7_24) {flag = "af"} : (i64) -> ()
      %bb1d7_32 = "braid.zext"(%bb1d7_16) {bits = 8 : i64} : (i64) -> i64
      %bb1d7_33 = "braid.popcnt"(%bb1d7_32) : (i64) -> i64
      %bb1d7_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1d7_35 = "braid.and"(%bb1d7_33, %bb1d7_34) : (i64, i64) -> i64
      %bb1d7_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d7_37 = "braid.eq"(%bb1d7_35, %bb1d7_36) : (i64, i64) -> i64
      "braid.setf"(%bb1d7_37) {flag = "pf"} : (i64) -> ()
      %bb1d7_38 = "braid.eq"(%bb1d7_16, %bb1d7_36) : (i64, i64) -> i64
      "braid.setf"(%bb1d7_38) {flag = "zf"} : (i64) -> ()
      %bb1d7_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1d7_40 = "braid.and"(%bb1d7_16, %bb1d7_39) : (i64, i64) -> i64
      "braid.setf"(%bb1d7_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1d7_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb1da] : () -> ()
    ^bb1da:  // 0x40121a
      %bb1da_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1da_0 = "braid.zext"(%bb1da_1) {bits = 32 : i64} : (i64) -> i64
      %bb1da_12 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb1da_13 = "braid.shl"(%bb1da_0, %bb1da_12) : (i64, i64) -> i64
      %bb1da_14 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb1da_15 = "braid.lshr"(%bb1da_0, %bb1da_14) : (i64, i64) -> i64
      %bb1da_16 = "braid.or"(%bb1da_13, %bb1da_15) : (i64, i64) -> i64
      %bb1da_17 = "braid.zext"(%bb1da_16) {bits = 32 : i64} : (i64) -> i64
      %bb1da_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1da_19 = "braid.and"(%bb1da_17, %bb1da_18) : (i64, i64) -> i64
      "braid.setf"(%bb1da_19) {flag = "cf"} : (i64) -> ()
      %bb1da_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1da_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb1da_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb1dd] : () -> ()
    ^bb1dd:  // 0x40121d
      %bb1dd_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1dd_0 = "braid.zext"(%bb1dd_1) {bits = 32 : i64} : (i64) -> i64
      %bb1dd_9 = "braid.get"() {reg = "r15"} : () -> i64
      %bb1dd_8 = "braid.zext"(%bb1dd_9) {bits = 32 : i64} : (i64) -> i64
      %bb1dd_16 = "braid.add"(%bb1dd_0, %bb1dd_8) : (i64, i64) -> i64
      %bb1dd_17 = "braid.zext"(%bb1dd_16) {bits = 32 : i64} : (i64) -> i64
      %bb1dd_18 = "braid.ult"(%bb1dd_17, %bb1dd_0) : (i64, i64) -> i64
      "braid.setf"(%bb1dd_18) {flag = "cf"} : (i64) -> ()
      %bb1dd_19 = "braid.xor"(%bb1dd_0, %bb1dd_17) : (i64, i64) -> i64
      %bb1dd_20 = "braid.xor"(%bb1dd_8, %bb1dd_17) : (i64, i64) -> i64
      %bb1dd_21 = "braid.and"(%bb1dd_19, %bb1dd_20) : (i64, i64) -> i64
      %bb1dd_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1dd_23 = "braid.and"(%bb1dd_21, %bb1dd_22) : (i64, i64) -> i64
      "braid.setf"(%bb1dd_23) {flag = "of"} : (i64) -> ()
      %bb1dd_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1dd_24) {flag = "af"} : (i64) -> ()
      %bb1dd_32 = "braid.zext"(%bb1dd_17) {bits = 8 : i64} : (i64) -> i64
      %bb1dd_33 = "braid.popcnt"(%bb1dd_32) : (i64) -> i64
      %bb1dd_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1dd_35 = "braid.and"(%bb1dd_33, %bb1dd_34) : (i64, i64) -> i64
      %bb1dd_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1dd_37 = "braid.eq"(%bb1dd_35, %bb1dd_36) : (i64, i64) -> i64
      "braid.setf"(%bb1dd_37) {flag = "pf"} : (i64) -> ()
      %bb1dd_38 = "braid.eq"(%bb1dd_17, %bb1dd_36) : (i64, i64) -> i64
      "braid.setf"(%bb1dd_38) {flag = "zf"} : (i64) -> ()
      %bb1dd_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1dd_40 = "braid.and"(%bb1dd_17, %bb1dd_39) : (i64, i64) -> i64
      "braid.setf"(%bb1dd_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1dd_17) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb1e0] : () -> ()
    ^bb1e0:  // 0x401220
      %bb1e0_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb1e0_0 = "braid.zext"(%bb1e0_1) {bits = 32 : i64} : (i64) -> i64
      %bb1e0_9 = "braid.get"() {reg = "r15"} : () -> i64
      %bb1e0_8 = "braid.zext"(%bb1e0_9) {bits = 32 : i64} : (i64) -> i64
      %bb1e0_16 = "braid.xor"(%bb1e0_0, %bb1e0_8) : (i64, i64) -> i64
      %bb1e0_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1e0_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1e0_17) {flag = "of"} : (i64) -> ()
      %bb1e0_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1e0_24) {flag = "af"} : (i64) -> ()
      %bb1e0_32 = "braid.zext"(%bb1e0_16) {bits = 8 : i64} : (i64) -> i64
      %bb1e0_33 = "braid.popcnt"(%bb1e0_32) : (i64) -> i64
      %bb1e0_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1e0_35 = "braid.and"(%bb1e0_33, %bb1e0_34) : (i64, i64) -> i64
      %bb1e0_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e0_37 = "braid.eq"(%bb1e0_35, %bb1e0_36) : (i64, i64) -> i64
      "braid.setf"(%bb1e0_37) {flag = "pf"} : (i64) -> ()
      %bb1e0_38 = "braid.eq"(%bb1e0_16, %bb1e0_36) : (i64, i64) -> i64
      "braid.setf"(%bb1e0_38) {flag = "zf"} : (i64) -> ()
      %bb1e0_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1e0_40 = "braid.and"(%bb1e0_16, %bb1e0_39) : (i64, i64) -> i64
      "braid.setf"(%bb1e0_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1e0_16) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb1e3] : () -> ()
    ^bb1e3:  // 0x401223
      %bb1e3_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb1e3_0 = "braid.zext"(%bb1e3_1) {bits = 32 : i64} : (i64) -> i64
      %bb1e3_12 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1e3_13 = "braid.shl"(%bb1e3_0, %bb1e3_12) : (i64, i64) -> i64
      %bb1e3_14 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb1e3_15 = "braid.lshr"(%bb1e3_0, %bb1e3_14) : (i64, i64) -> i64
      %bb1e3_16 = "braid.or"(%bb1e3_13, %bb1e3_15) : (i64, i64) -> i64
      %bb1e3_17 = "braid.zext"(%bb1e3_16) {bits = 32 : i64} : (i64) -> i64
      %bb1e3_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1e3_19 = "braid.and"(%bb1e3_17, %bb1e3_18) : (i64, i64) -> i64
      "braid.setf"(%bb1e3_19) {flag = "cf"} : (i64) -> ()
      %bb1e3_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1e3_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb1e3_17) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb1e6] : () -> ()
    ^bb1e6:  // 0x401226
      %bb1e6_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb1e6_0 = "braid.zext"(%bb1e6_1) {bits = 32 : i64} : (i64) -> i64
      %bb1e6_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb1e6_8 = "braid.zext"(%bb1e6_9) {bits = 32 : i64} : (i64) -> i64
      %bb1e6_16 = "braid.add"(%bb1e6_0, %bb1e6_8) : (i64, i64) -> i64
      %bb1e6_17 = "braid.zext"(%bb1e6_16) {bits = 32 : i64} : (i64) -> i64
      %bb1e6_18 = "braid.ult"(%bb1e6_17, %bb1e6_0) : (i64, i64) -> i64
      "braid.setf"(%bb1e6_18) {flag = "cf"} : (i64) -> ()
      %bb1e6_19 = "braid.xor"(%bb1e6_0, %bb1e6_17) : (i64, i64) -> i64
      %bb1e6_20 = "braid.xor"(%bb1e6_8, %bb1e6_17) : (i64, i64) -> i64
      %bb1e6_21 = "braid.and"(%bb1e6_19, %bb1e6_20) : (i64, i64) -> i64
      %bb1e6_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1e6_23 = "braid.and"(%bb1e6_21, %bb1e6_22) : (i64, i64) -> i64
      "braid.setf"(%bb1e6_23) {flag = "of"} : (i64) -> ()
      %bb1e6_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1e6_24) {flag = "af"} : (i64) -> ()
      %bb1e6_32 = "braid.zext"(%bb1e6_17) {bits = 8 : i64} : (i64) -> i64
      %bb1e6_33 = "braid.popcnt"(%bb1e6_32) : (i64) -> i64
      %bb1e6_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1e6_35 = "braid.and"(%bb1e6_33, %bb1e6_34) : (i64, i64) -> i64
      %bb1e6_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1e6_37 = "braid.eq"(%bb1e6_35, %bb1e6_36) : (i64, i64) -> i64
      "braid.setf"(%bb1e6_37) {flag = "pf"} : (i64) -> ()
      %bb1e6_38 = "braid.eq"(%bb1e6_17, %bb1e6_36) : (i64, i64) -> i64
      "braid.setf"(%bb1e6_38) {flag = "zf"} : (i64) -> ()
      %bb1e6_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1e6_40 = "braid.and"(%bb1e6_17, %bb1e6_39) : (i64, i64) -> i64
      "braid.setf"(%bb1e6_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1e6_17) {reg = "r9"} : (i64) -> ()
      "braid_cf.br"()[^bb1e9] : () -> ()
    ^bb1e9:  // 0x401229
      %bb1e9_1 = "braid.get"() {reg = "r9"} : () -> i64
      %bb1e9_0 = "braid.zext"(%bb1e9_1) {bits = 32 : i64} : (i64) -> i64
      %bb1e9_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1e9_10 = "braid.const"() {value = -100 : i64} : () -> i64
      %bb1e9_8 = "braid.add"(%bb1e9_9, %bb1e9_10) : (i64, i64) -> i64
      "braid.store"(%bb1e9_8, %bb1e9_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb1ee] : () -> ()
    ^bb1ee:  // 0x40122e
      %bb1ee_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1ee_0 = "braid.zext"(%bb1ee_1) {bits = 32 : i64} : (i64) -> i64
      %bb1ee_9 = "braid.get"() {reg = "r9"} : () -> i64
      %bb1ee_8 = "braid.zext"(%bb1ee_9) {bits = 32 : i64} : (i64) -> i64
      %bb1ee_16 = "braid.xor"(%bb1ee_0, %bb1ee_8) : (i64, i64) -> i64
      %bb1ee_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb1ee_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb1ee_17) {flag = "of"} : (i64) -> ()
      %bb1ee_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1ee_24) {flag = "af"} : (i64) -> ()
      %bb1ee_32 = "braid.zext"(%bb1ee_16) {bits = 8 : i64} : (i64) -> i64
      %bb1ee_33 = "braid.popcnt"(%bb1ee_32) : (i64) -> i64
      %bb1ee_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1ee_35 = "braid.and"(%bb1ee_33, %bb1ee_34) : (i64, i64) -> i64
      %bb1ee_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1ee_37 = "braid.eq"(%bb1ee_35, %bb1ee_36) : (i64, i64) -> i64
      "braid.setf"(%bb1ee_37) {flag = "pf"} : (i64) -> ()
      %bb1ee_38 = "braid.eq"(%bb1ee_16, %bb1ee_36) : (i64, i64) -> i64
      "braid.setf"(%bb1ee_38) {flag = "zf"} : (i64) -> ()
      %bb1ee_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1ee_40 = "braid.and"(%bb1ee_16, %bb1ee_39) : (i64, i64) -> i64
      "braid.setf"(%bb1ee_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1ee_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb1f1] : () -> ()
    ^bb1f1:  // 0x401231
      %bb1f1_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1f1_0 = "braid.zext"(%bb1f1_1) {bits = 32 : i64} : (i64) -> i64
      %bb1f1_12 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb1f1_13 = "braid.shl"(%bb1f1_0, %bb1f1_12) : (i64, i64) -> i64
      %bb1f1_14 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb1f1_15 = "braid.lshr"(%bb1f1_0, %bb1f1_14) : (i64, i64) -> i64
      %bb1f1_16 = "braid.or"(%bb1f1_13, %bb1f1_15) : (i64, i64) -> i64
      %bb1f1_17 = "braid.zext"(%bb1f1_16) {bits = 32 : i64} : (i64) -> i64
      %bb1f1_18 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1f1_19 = "braid.and"(%bb1f1_17, %bb1f1_18) : (i64, i64) -> i64
      "braid.setf"(%bb1f1_19) {flag = "cf"} : (i64) -> ()
      %bb1f1_23 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1f1_23) {flag = "of"} : (i64) -> ()
      "braid.set"(%bb1f1_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb1f4] : () -> ()
    ^bb1f4:  // 0x401234
      %bb1f4_1 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb1f4_0 = "braid.zext"(%bb1f4_1) {bits = 32 : i64} : (i64) -> i64
      %bb1f4_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1f4_16 = "braid.sub"(%bb1f4_0, %bb1f4_8) : (i64, i64) -> i64
      %bb1f4_17 = "braid.zext"(%bb1f4_16) {bits = 32 : i64} : (i64) -> i64
      %bb1f4_19 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1f4_20 = "braid.eq"(%bb1f4_0, %bb1f4_19) : (i64, i64) -> i64
      "braid.setf"(%bb1f4_20) {flag = "of"} : (i64) -> ()
      %bb1f4_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb1f4_24) {flag = "af"} : (i64) -> ()
      %bb1f4_32 = "braid.zext"(%bb1f4_17) {bits = 8 : i64} : (i64) -> i64
      %bb1f4_33 = "braid.popcnt"(%bb1f4_32) : (i64) -> i64
      %bb1f4_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb1f4_35 = "braid.and"(%bb1f4_33, %bb1f4_34) : (i64, i64) -> i64
      %bb1f4_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1f4_37 = "braid.eq"(%bb1f4_35, %bb1f4_36) : (i64, i64) -> i64
      "braid.setf"(%bb1f4_37) {flag = "pf"} : (i64) -> ()
      %bb1f4_38 = "braid.eq"(%bb1f4_17, %bb1f4_36) : (i64, i64) -> i64
      "braid.setf"(%bb1f4_38) {flag = "zf"} : (i64) -> ()
      %bb1f4_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb1f4_40 = "braid.and"(%bb1f4_17, %bb1f4_39) : (i64, i64) -> i64
      "braid.setf"(%bb1f4_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb1f4_17) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb1f6] : () -> ()
    ^bb1f6:  // 0x401236
      %bb1f6_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb1f6_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1f6_0 = "braid.eq"(%bb1f6_1, %bb1f6_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb1f6_0)[^bb90, ^bb1fc] : (i64) -> ()
    ^bb1fc:  // 0x40123c
      %bb1fc_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb1fc_0 = "braid.zext"(%bb1fc_1) {bits = 32 : i64} : (i64) -> i64
      %bb1fc_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb1fc_10 = "braid.const"() {value = -72 : i64} : () -> i64
      %bb1fc_8 = "braid.add"(%bb1fc_9, %bb1fc_10) : (i64, i64) -> i64
      "braid.store"(%bb1fc_8, %bb1fc_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb200] : () -> ()
    ^bb200:  // 0x401240
      %bb200_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb200_3 = "braid.const"() {value = -96 : i64} : () -> i64
      %bb200_1 = "braid.add"(%bb200_2, %bb200_3) : (i64, i64) -> i64
      %bb200_0 = "braid.load"(%bb200_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb200_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb204] : () -> ()
    ^bb204:  // 0x401244
      %bb204_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb204_0 = "braid.zext"(%bb204_1) {bits = 32 : i64} : (i64) -> i64
      %bb204_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb204_10 = "braid.const"() {value = -88 : i64} : () -> i64
      %bb204_8 = "braid.add"(%bb204_9, %bb204_10) : (i64, i64) -> i64
      "braid.store"(%bb204_8, %bb204_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb208] : () -> ()
    ^bb208:  // 0x401248
      %bb208_1 = "braid.get"() {reg = "r13"} : () -> i64
      %bb208_0 = "braid.zext"(%bb208_1) {bits = 32 : i64} : (i64) -> i64
      %bb208_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb208_10 = "braid.const"() {value = -40 : i64} : () -> i64
      %bb208_8 = "braid.add"(%bb208_9, %bb208_10) : (i64, i64) -> i64
      "braid.store"(%bb208_8, %bb208_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb20d] : () -> ()
    ^bb20d:  // 0x40124d
      %bb20d_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb20d_0 = "braid.zext"(%bb20d_1) {bits = 32 : i64} : (i64) -> i64
      %bb20d_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb20d_10 = "braid.const"() {value = -56 : i64} : () -> i64
      %bb20d_8 = "braid.add"(%bb20d_9, %bb20d_10) : (i64, i64) -> i64
      "braid.store"(%bb20d_8, %bb20d_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb211] : () -> ()
    ^bb211:  // 0x401251
      %bb211_1 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb211_0 = "braid.zext"(%bb211_1) {bits = 32 : i64} : (i64) -> i64
      %bb211_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb211_10 = "braid.const"() {value = -68 : i64} : () -> i64
      %bb211_8 = "braid.add"(%bb211_9, %bb211_10) : (i64, i64) -> i64
      "braid.store"(%bb211_8, %bb211_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb215] : () -> ()
    ^bb215:  // 0x401255
      %bb215_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb215_3 = "braid.const"() {value = -92 : i64} : () -> i64
      %bb215_1 = "braid.add"(%bb215_2, %bb215_3) : (i64, i64) -> i64
      %bb215_0 = "braid.load"(%bb215_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb215_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb219] : () -> ()
    ^bb219:  // 0x401259
      %bb219_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb219_0 = "braid.zext"(%bb219_1) {bits = 32 : i64} : (i64) -> i64
      %bb219_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb219_10 = "braid.const"() {value = -84 : i64} : () -> i64
      %bb219_8 = "braid.add"(%bb219_9, %bb219_10) : (i64, i64) -> i64
      "braid.store"(%bb219_8, %bb219_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb21d] : () -> ()
    ^bb21d:  // 0x40125d
      %bb21d_1 = "braid.get"() {reg = "r8"} : () -> i64
      %bb21d_0 = "braid.zext"(%bb21d_1) {bits = 32 : i64} : (i64) -> i64
      %bb21d_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb21d_10 = "braid.const"() {value = -36 : i64} : () -> i64
      %bb21d_8 = "braid.add"(%bb21d_9, %bb21d_10) : (i64, i64) -> i64
      "braid.store"(%bb21d_8, %bb21d_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb222] : () -> ()
    ^bb222:  // 0x401262
      %bb222_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb222_3 = "braid.const"() {value = -100 : i64} : () -> i64
      %bb222_1 = "braid.add"(%bb222_2, %bb222_3) : (i64, i64) -> i64
      %bb222_0 = "braid.load"(%bb222_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb222_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb226] : () -> ()
    ^bb226:  // 0x401266
      %bb226_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb226_0 = "braid.zext"(%bb226_1) {bits = 32 : i64} : (i64) -> i64
      %bb226_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb226_10 = "braid.const"() {value = -52 : i64} : () -> i64
      %bb226_8 = "braid.add"(%bb226_9, %bb226_10) : (i64, i64) -> i64
      "braid.store"(%bb226_8, %bb226_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb22a] : () -> ()
    ^bb22a:  // 0x40126a
      %bb22a_1 = "braid.get"() {reg = "r10"} : () -> i64
      %bb22a_0 = "braid.zext"(%bb22a_1) {bits = 32 : i64} : (i64) -> i64
      %bb22a_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb22a_10 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb22a_8 = "braid.add"(%bb22a_9, %bb22a_10) : (i64, i64) -> i64
      "braid.store"(%bb22a_8, %bb22a_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb22f] : () -> ()
    ^bb22f:  // 0x40126f
      %bb22f_1 = "braid.get"() {reg = "r11"} : () -> i64
      %bb22f_0 = "braid.zext"(%bb22f_1) {bits = 32 : i64} : (i64) -> i64
      %bb22f_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb22f_10 = "braid.const"() {value = -80 : i64} : () -> i64
      %bb22f_8 = "braid.add"(%bb22f_9, %bb22f_10) : (i64, i64) -> i64
      "braid.store"(%bb22f_8, %bb22f_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb234] : () -> ()
    ^bb234:  // 0x401274
      %bb234_1 = "braid.get"() {reg = "rbx"} : () -> i64
      %bb234_0 = "braid.zext"(%bb234_1) {bits = 32 : i64} : (i64) -> i64
      %bb234_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb234_10 = "braid.const"() {value = -32 : i64} : () -> i64
      %bb234_8 = "braid.add"(%bb234_9, %bb234_10) : (i64, i64) -> i64
      "braid.store"(%bb234_8, %bb234_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb238] : () -> ()
    ^bb238:  // 0x401278
      %bb238_1 = "braid.get"() {reg = "rbp"} : () -> i64
      %bb238_0 = "braid.zext"(%bb238_1) {bits = 32 : i64} : (i64) -> i64
      %bb238_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb238_10 = "braid.const"() {value = -48 : i64} : () -> i64
      %bb238_8 = "braid.add"(%bb238_9, %bb238_10) : (i64, i64) -> i64
      "braid.store"(%bb238_8, %bb238_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb23c] : () -> ()
    ^bb23c:  // 0x40127c
      %bb23c_1 = "braid.get"() {reg = "r14"} : () -> i64
      %bb23c_0 = "braid.zext"(%bb23c_1) {bits = 32 : i64} : (i64) -> i64
      %bb23c_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb23c_10 = "braid.const"() {value = -60 : i64} : () -> i64
      %bb23c_8 = "braid.add"(%bb23c_9, %bb23c_10) : (i64, i64) -> i64
      "braid.store"(%bb23c_8, %bb23c_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb241] : () -> ()
    ^bb241:  // 0x401281
      %bb241_1 = "braid.get"() {reg = "r15"} : () -> i64
      %bb241_0 = "braid.zext"(%bb241_1) {bits = 32 : i64} : (i64) -> i64
      %bb241_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb241_10 = "braid.const"() {value = -76 : i64} : () -> i64
      %bb241_8 = "braid.add"(%bb241_9, %bb241_10) : (i64, i64) -> i64
      "braid.store"(%bb241_8, %bb241_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb246] : () -> ()
    ^bb246:  // 0x401286
      %bb246_1 = "braid.get"() {reg = "r12"} : () -> i64
      %bb246_0 = "braid.zext"(%bb246_1) {bits = 32 : i64} : (i64) -> i64
      %bb246_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb246_10 = "braid.const"() {value = -28 : i64} : () -> i64
      %bb246_8 = "braid.add"(%bb246_9, %bb246_10) : (i64, i64) -> i64
      "braid.store"(%bb246_8, %bb246_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb24b] : () -> ()
    ^bb24b:  // 0x40128b
      %bb24b_1 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb24b_0 = "braid.zext"(%bb24b_1) {bits = 32 : i64} : (i64) -> i64
      %bb24b_9 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb24b_10 = "braid.const"() {value = -44 : i64} : () -> i64
      %bb24b_8 = "braid.add"(%bb24b_9, %bb24b_10) : (i64, i64) -> i64
      "braid.store"(%bb24b_8, %bb24b_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb24f] : () -> ()
    ^bb24f:  // 0x40128f
      %bb24f_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bb24f_0 = "braid.zext"(%bb24f_1) {bits = 32 : i64} : (i64) -> i64
      %bb24f_9 = "braid.get"() {reg = "rax"} : () -> i64
      %bb24f_8 = "braid.zext"(%bb24f_9) {bits = 32 : i64} : (i64) -> i64
      %bb24f_16 = "braid.xor"(%bb24f_0, %bb24f_8) : (i64, i64) -> i64
      %bb24f_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb24f_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb24f_17) {flag = "of"} : (i64) -> ()
      %bb24f_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb24f_24) {flag = "af"} : (i64) -> ()
      %bb24f_32 = "braid.zext"(%bb24f_16) {bits = 8 : i64} : (i64) -> i64
      %bb24f_33 = "braid.popcnt"(%bb24f_32) : (i64) -> i64
      %bb24f_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb24f_35 = "braid.and"(%bb24f_33, %bb24f_34) : (i64, i64) -> i64
      %bb24f_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb24f_37 = "braid.eq"(%bb24f_35, %bb24f_36) : (i64, i64) -> i64
      "braid.setf"(%bb24f_37) {flag = "pf"} : (i64) -> ()
      %bb24f_38 = "braid.eq"(%bb24f_16, %bb24f_36) : (i64, i64) -> i64
      "braid.setf"(%bb24f_38) {flag = "zf"} : (i64) -> ()
      %bb24f_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb24f_40 = "braid.and"(%bb24f_16, %bb24f_39) : (i64, i64) -> i64
      "braid.setf"(%bb24f_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb24f_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb251] : () -> ()
    ^bb251:  // 0x401291
      %bb251_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb251_3 = "braid.const"() {value = -8 : i64} : () -> i64
      %bb251_1 = "braid.add"(%bb251_2, %bb251_3) : (i64, i64) -> i64
      %bb251_0 = "braid.load"(%bb251_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb251_0) {reg = "rdx"} : (i64) -> ()
      "braid_cf.br"()[^bb256] : () -> ()
    ^bb256:  // 0x401296
      %bb256_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb256_3 = "braid.const"() {value = -16 : i64} : () -> i64
      %bb256_1 = "braid.add"(%bb256_2, %bb256_3) : (i64, i64) -> i64
      %bb256_0 = "braid.load"(%bb256_1) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb256_0) {reg = "rsi"} : (i64) -> ()
      "braid_cf.br"()[^bb25b] : () -> ()
    ^bb25b:  // 0x40129b
      "braid_cf.br"()[^bb260] : () -> ()
    ^bb260:  // 0x4012a0
      %bb260_2 = "braid.get"() {reg = "rdx"} : () -> i64
      %bb260_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb260_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb260_5 = "braid.mul"(%bb260_3, %bb260_4) : (i64, i64) -> i64
      %bb260_6 = "braid.add"(%bb260_2, %bb260_5) : (i64, i64) -> i64
      %bb260_7 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb260_1 = "braid.add"(%bb260_6, %bb260_7) : (i64, i64) -> i64
      %bb260_0 = "braid.load"(%bb260_1) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb260_0) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb263] : () -> ()
    ^bb263:  // 0x4012a3
      %bb263_2 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb263_3 = "braid.get"() {reg = "rax"} : () -> i64
      %bb263_4 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb263_5 = "braid.mul"(%bb263_3, %bb263_4) : (i64, i64) -> i64
      %bb263_6 = "braid.add"(%bb263_2, %bb263_5) : (i64, i64) -> i64
      %bb263_7 = "braid.const"() {value = -88 : i64} : () -> i64
      %bb263_1 = "braid.add"(%bb263_6, %bb263_7) : (i64, i64) -> i64
      %bb263_0 = "braid.load"(%bb263_1) {bytes = 4 : i64} : (i64) -> i64
      %bb263_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb263_8 = "braid.zext"(%bb263_9) {bits = 32 : i64} : (i64) -> i64
      %bb263_16 = "braid.add"(%bb263_0, %bb263_8) : (i64, i64) -> i64
      %bb263_17 = "braid.zext"(%bb263_16) {bits = 32 : i64} : (i64) -> i64
      %bb263_18 = "braid.ult"(%bb263_17, %bb263_0) : (i64, i64) -> i64
      "braid.setf"(%bb263_18) {flag = "cf"} : (i64) -> ()
      %bb263_19 = "braid.xor"(%bb263_0, %bb263_17) : (i64, i64) -> i64
      %bb263_20 = "braid.xor"(%bb263_8, %bb263_17) : (i64, i64) -> i64
      %bb263_21 = "braid.and"(%bb263_19, %bb263_20) : (i64, i64) -> i64
      %bb263_22 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb263_23 = "braid.and"(%bb263_21, %bb263_22) : (i64, i64) -> i64
      "braid.setf"(%bb263_23) {flag = "of"} : (i64) -> ()
      %bb263_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb263_24) {flag = "af"} : (i64) -> ()
      %bb263_32 = "braid.zext"(%bb263_17) {bits = 8 : i64} : (i64) -> i64
      %bb263_33 = "braid.popcnt"(%bb263_32) : (i64) -> i64
      %bb263_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb263_35 = "braid.and"(%bb263_33, %bb263_34) : (i64, i64) -> i64
      %bb263_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb263_37 = "braid.eq"(%bb263_35, %bb263_36) : (i64, i64) -> i64
      "braid.setf"(%bb263_37) {flag = "pf"} : (i64) -> ()
      %bb263_38 = "braid.eq"(%bb263_17, %bb263_36) : (i64, i64) -> i64
      "braid.setf"(%bb263_38) {flag = "zf"} : (i64) -> ()
      %bb263_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb263_40 = "braid.and"(%bb263_17, %bb263_39) : (i64, i64) -> i64
      "braid.setf"(%bb263_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb263_17) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb267] : () -> ()
    ^bb267:  // 0x4012a7
      %bb267_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb267_0 = "braid.zext"(%bb267_1) {bits = 32 : i64} : (i64) -> i64
      %bb267_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb267_10 = "braid.get"() {reg = "rax"} : () -> i64
      %bb267_11 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb267_12 = "braid.mul"(%bb267_10, %bb267_11) : (i64, i64) -> i64
      %bb267_13 = "braid.add"(%bb267_9, %bb267_12) : (i64, i64) -> i64
      %bb267_14 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb267_8 = "braid.add"(%bb267_13, %bb267_14) : (i64, i64) -> i64
      "braid.store"(%bb267_8, %bb267_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb26a] : () -> ()
    ^bb26a:  // 0x4012aa
      %bb26a_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb26a_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb26a_16 = "braid.add"(%bb26a_0, %bb26a_8) : (i64, i64) -> i64
      %bb26a_19 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb26a_20 = "braid.eq"(%bb26a_16, %bb26a_19) : (i64, i64) -> i64
      "braid.setf"(%bb26a_20) {flag = "of"} : (i64) -> ()
      %bb26a_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb26a_24) {flag = "af"} : (i64) -> ()
      %bb26a_32 = "braid.zext"(%bb26a_16) {bits = 8 : i64} : (i64) -> i64
      %bb26a_33 = "braid.popcnt"(%bb26a_32) : (i64) -> i64
      %bb26a_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb26a_35 = "braid.and"(%bb26a_33, %bb26a_34) : (i64, i64) -> i64
      %bb26a_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb26a_37 = "braid.eq"(%bb26a_35, %bb26a_36) : (i64, i64) -> i64
      "braid.setf"(%bb26a_37) {flag = "pf"} : (i64) -> ()
      %bb26a_38 = "braid.eq"(%bb26a_16, %bb26a_36) : (i64, i64) -> i64
      "braid.setf"(%bb26a_38) {flag = "zf"} : (i64) -> ()
      %bb26a_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb26a_40 = "braid.and"(%bb26a_16, %bb26a_39) : (i64, i64) -> i64
      "braid.setf"(%bb26a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb26a_16) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb26d] : () -> ()
    ^bb26d:  // 0x4012ad
      %bb26d_0 = "braid.get"() {reg = "rax"} : () -> i64
      %bb26d_8 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb26d_16 = "braid.sub"(%bb26d_0, %bb26d_8) : (i64, i64) -> i64
      %bb26d_18 = "braid.ult"(%bb26d_0, %bb26d_8) : (i64, i64) -> i64
      "braid.setf"(%bb26d_18) {flag = "cf"} : (i64) -> ()
      %bb26d_19 = "braid.xor"(%bb26d_0, %bb26d_8) : (i64, i64) -> i64
      %bb26d_20 = "braid.xor"(%bb26d_0, %bb26d_16) : (i64, i64) -> i64
      %bb26d_21 = "braid.and"(%bb26d_19, %bb26d_20) : (i64, i64) -> i64
      %bb26d_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb26d_23 = "braid.and"(%bb26d_21, %bb26d_22) : (i64, i64) -> i64
      "braid.setf"(%bb26d_23) {flag = "of"} : (i64) -> ()
      %bb26d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb26d_24) {flag = "af"} : (i64) -> ()
      %bb26d_32 = "braid.zext"(%bb26d_16) {bits = 8 : i64} : (i64) -> i64
      %bb26d_33 = "braid.popcnt"(%bb26d_32) : (i64) -> i64
      %bb26d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb26d_35 = "braid.and"(%bb26d_33, %bb26d_34) : (i64, i64) -> i64
      %bb26d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb26d_37 = "braid.eq"(%bb26d_35, %bb26d_36) : (i64, i64) -> i64
      "braid.setf"(%bb26d_37) {flag = "pf"} : (i64) -> ()
      %bb26d_38 = "braid.eq"(%bb26d_16, %bb26d_36) : (i64, i64) -> i64
      "braid.setf"(%bb26d_38) {flag = "zf"} : (i64) -> ()
      %bb26d_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb26d_40 = "braid.and"(%bb26d_16, %bb26d_39) : (i64, i64) -> i64
      "braid.setf"(%bb26d_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb271] : () -> ()
    ^bb271:  // 0x4012b1
      %bb271_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb271_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb271_0 = "braid.eq"(%bb271_1, %bb271_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb271_0)[^bb260, ^bb273] : (i64) -> ()
    ^bb273:  // 0x4012b3
      %bb273_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb273_1 = "braid.load"(%bb273_0) {bytes = 8 : i64} : (i64) -> i64
      %bb273_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb273_3 = "braid.add"(%bb273_0, %bb273_2) : (i64, i64) -> i64
      "braid.set"(%bb273_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb273_1) {reg = "rbx"} : (i64) -> ()
      "braid_cf.br"()[^bb274] : () -> ()
    ^bb274:  // 0x4012b4
      %bb274_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb274_1 = "braid.load"(%bb274_0) {bytes = 8 : i64} : (i64) -> i64
      %bb274_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb274_3 = "braid.add"(%bb274_0, %bb274_2) : (i64, i64) -> i64
      "braid.set"(%bb274_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb274_1) {reg = "r12"} : (i64) -> ()
      "braid_cf.br"()[^bb276] : () -> ()
    ^bb276:  // 0x4012b6
      %bb276_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb276_1 = "braid.load"(%bb276_0) {bytes = 8 : i64} : (i64) -> i64
      %bb276_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb276_3 = "braid.add"(%bb276_0, %bb276_2) : (i64, i64) -> i64
      "braid.set"(%bb276_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb276_1) {reg = "r13"} : (i64) -> ()
      "braid_cf.br"()[^bb278] : () -> ()
    ^bb278:  // 0x4012b8
      %bb278_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb278_1 = "braid.load"(%bb278_0) {bytes = 8 : i64} : (i64) -> i64
      %bb278_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb278_3 = "braid.add"(%bb278_0, %bb278_2) : (i64, i64) -> i64
      "braid.set"(%bb278_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb278_1) {reg = "r14"} : (i64) -> ()
      "braid_cf.br"()[^bb27a] : () -> ()
    ^bb27a:  // 0x4012ba
      %bb27a_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb27a_1 = "braid.load"(%bb27a_0) {bytes = 8 : i64} : (i64) -> i64
      %bb27a_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb27a_3 = "braid.add"(%bb27a_0, %bb27a_2) : (i64, i64) -> i64
      "braid.set"(%bb27a_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb27a_1) {reg = "r15"} : (i64) -> ()
      "braid_cf.br"()[^bb27c] : () -> ()
    ^bb27c:  // 0x4012bc
      %bb27c_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb27c_1 = "braid.load"(%bb27c_0) {bytes = 8 : i64} : (i64) -> i64
      %bb27c_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb27c_3 = "braid.add"(%bb27c_0, %bb27c_2) : (i64, i64) -> i64
      "braid.set"(%bb27c_3) {reg = "rsp"} : (i64) -> ()
      "braid.set"(%bb27c_1) {reg = "rbp"} : (i64) -> ()
      "braid_cf.br"()[^bb27d] : () -> ()
    ^bb27d:  // 0x4012bd
      %bb27d_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb27d_1 = "braid.load"(%bb27d_0) {bytes = 8 : i64} : (i64) -> i64
      %bb27d_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb27d_3 = "braid.add"(%bb27d_0, %bb27d_2) : (i64, i64) -> i64
      "braid.set"(%bb27d_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb27d_1) : (i64) -> ()
  }) {sym_name = "chacha20_block", entry = 4198464 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
