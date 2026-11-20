"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_8 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb0_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_25 = "braid.add"(%bb0_8, %bb0_24) : (i64, i64) -> i64
      %bb0_0 = "braid.load"(%bb0_25) {bytes = 8 : i64} : (i64) -> i64
      %bb0_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_27 = "braid.add"(%bb0_8, %bb0_26) : (i64, i64) -> i64
      %bb0_1 = "braid.load"(%bb0_27) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb0_0) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bb0_1) {reg = "zmm0.1"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x401004
      %bb4_9 = "braid.get"() {reg = "rdi"} : () -> i64
      %bb4_10 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb4_8 = "braid.add"(%bb4_9, %bb4_10) : (i64, i64) -> i64
      %bb4_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_25 = "braid.add"(%bb4_8, %bb4_24) : (i64, i64) -> i64
      %bb4_0 = "braid.load"(%bb4_25) {bytes = 8 : i64} : (i64) -> i64
      %bb4_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb4_27 = "braid.add"(%bb4_8, %bb4_26) : (i64, i64) -> i64
      %bb4_1 = "braid.load"(%bb4_27) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb4_0) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bb4_1) {reg = "zmm1.1"} : (i64) -> ()
      "braid_cf.br"()[^bb9] : () -> ()
    ^bb9:  // 0x401009
      %bb9_0 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb9_1 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb9_40 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb9_41 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bb9_48 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb9_49 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb9_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9_57 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb9_64 = "braid.lshr"(%bb9_0, %bb9_48) : (i64, i64) -> i64
      %bb9_65 = "braid.lshr"(%bb9_1, %bb9_49) : (i64, i64) -> i64
      %bb9_72 = "braid.and"(%bb9_64, %bb9_41) : (i64, i64) -> i64
      %bb9_73 = "braid.and"(%bb9_65, %bb9_41) : (i64, i64) -> i64
      %bb9_80 = "braid.lshr"(%bb9_0, %bb9_56) : (i64, i64) -> i64
      %bb9_81 = "braid.lshr"(%bb9_1, %bb9_57) : (i64, i64) -> i64
      %bb9_88 = "braid.shl"(%bb9_80, %bb9_40) : (i64, i64) -> i64
      %bb9_89 = "braid.shl"(%bb9_81, %bb9_40) : (i64, i64) -> i64
      %bb9_96 = "braid.or"(%bb9_72, %bb9_88) : (i64, i64) -> i64
      %bb9_97 = "braid.or"(%bb9_73, %bb9_89) : (i64, i64) -> i64
      "braid.set"(%bb9_96) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bb9_97) {reg = "zmm0.1"} : (i64) -> ()
      "braid_cf.br"()[^bbe] : () -> ()
    ^bbe:  // 0x40100e
      %bbe_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bbe_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bbe_40 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbe_41 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bbe_48 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbe_49 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbe_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe_57 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe_64 = "braid.lshr"(%bbe_1, %bbe_48) : (i64, i64) -> i64
      %bbe_65 = "braid.lshr"(%bbe_0, %bbe_49) : (i64, i64) -> i64
      %bbe_72 = "braid.and"(%bbe_64, %bbe_41) : (i64, i64) -> i64
      %bbe_73 = "braid.and"(%bbe_65, %bbe_41) : (i64, i64) -> i64
      %bbe_80 = "braid.lshr"(%bbe_1, %bbe_56) : (i64, i64) -> i64
      %bbe_81 = "braid.lshr"(%bbe_0, %bbe_57) : (i64, i64) -> i64
      %bbe_88 = "braid.shl"(%bbe_80, %bbe_40) : (i64, i64) -> i64
      %bbe_89 = "braid.shl"(%bbe_81, %bbe_40) : (i64, i64) -> i64
      %bbe_96 = "braid.or"(%bbe_72, %bbe_88) : (i64, i64) -> i64
      %bbe_97 = "braid.or"(%bbe_73, %bbe_89) : (i64, i64) -> i64
      "braid.set"(%bbe_96) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bbe_97) {reg = "zmm3.1"} : (i64) -> ()
      "braid_cf.br"()[^bb13] : () -> ()
    ^bb13:  // 0x401013
      %bb13_0 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb13_1 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      "braid.set"(%bb13_0) {reg = "zmm4.0"} : (i64) -> ()
      "braid.set"(%bb13_1) {reg = "zmm4.1"} : (i64) -> ()
      "braid_cf.br"()[^bb17] : () -> ()
    ^bb17:  // 0x401017
      %bb17_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb17_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb17_40 = "braid.get"() {reg = "zmm4.0"} : () -> i64
      %bb17_41 = "braid.get"() {reg = "zmm4.1"} : () -> i64
      %bb17_80 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb17_88 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb17_89 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb17_96 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb17_97 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb17_104 = "braid.lshr"(%bb17_1, %bb17_88) : (i64, i64) -> i64
      %bb17_105 = "braid.lshr"(%bb17_40, %bb17_89) : (i64, i64) -> i64
      %bb17_112 = "braid.shl"(%bb17_40, %bb17_96) : (i64, i64) -> i64
      %bb17_113 = "braid.shl"(%bb17_41, %bb17_97) : (i64, i64) -> i64
      %bb17_120 = "braid.or"(%bb17_104, %bb17_112) : (i64, i64) -> i64
      %bb17_121 = "braid.or"(%bb17_105, %bb17_113) : (i64, i64) -> i64
      "braid.set"(%bb17_120) {reg = "zmm4.0"} : (i64) -> ()
      "braid.set"(%bb17_121) {reg = "zmm4.1"} : (i64) -> ()
      "braid_cf.br"()[^bb1d] : () -> ()
    ^bb1d:  // 0x40101d
      %bb1d_0 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb1d_1 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb1d_40 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb1d_41 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb1d_80 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1d_81 = "braid.const"() {value = -1 : i64} : () -> i64
      %bb1d_88 = "braid.xor"(%bb1d_40, %bb1d_0) : (i64, i64) -> i64
      %bb1d_89 = "braid.xor"(%bb1d_41, %bb1d_1) : (i64, i64) -> i64
      %bb1d_96 = "braid.and"(%bb1d_88, %bb1d_80) : (i64, i64) -> i64
      %bb1d_97 = "braid.and"(%bb1d_89, %bb1d_81) : (i64, i64) -> i64
      %bb1d_104 = "braid.xor"(%bb1d_40, %bb1d_96) : (i64, i64) -> i64
      %bb1d_105 = "braid.xor"(%bb1d_41, %bb1d_97) : (i64, i64) -> i64
      "braid.set"(%bb1d_104) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bb1d_105) {reg = "zmm3.1"} : (i64) -> ()
      "braid_cf.br"()[^bb23] : () -> ()
    ^bb23:  // 0x401023
      %bb23_8 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb23_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb23_25 = "braid.add"(%bb23_8, %bb23_24) : (i64, i64) -> i64
      %bb23_0 = "braid.load"(%bb23_25) {bytes = 8 : i64} : (i64) -> i64
      %bb23_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb23_27 = "braid.add"(%bb23_8, %bb23_26) : (i64, i64) -> i64
      %bb23_1 = "braid.load"(%bb23_27) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb23_0) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bb23_1) {reg = "zmm1.1"} : (i64) -> ()
      "braid_cf.br"()[^bb27] : () -> ()
    ^bb27:  // 0x401027
      %bb27_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb27_10 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb27_8 = "braid.add"(%bb27_9, %bb27_10) : (i64, i64) -> i64
      %bb27_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb27_25 = "braid.add"(%bb27_8, %bb27_24) : (i64, i64) -> i64
      %bb27_0 = "braid.load"(%bb27_25) {bytes = 8 : i64} : (i64) -> i64
      %bb27_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb27_27 = "braid.add"(%bb27_8, %bb27_26) : (i64, i64) -> i64
      %bb27_1 = "braid.load"(%bb27_27) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb27_0) {reg = "zmm9.0"} : (i64) -> ()
      "braid.set"(%bb27_1) {reg = "zmm9.1"} : (i64) -> ()
      "braid_cf.br"()[^bb2d] : () -> ()
    ^bb2d:  // 0x40102d
      %bb2d_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb2d_10 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb2d_8 = "braid.add"(%bb2d_9, %bb2d_10) : (i64, i64) -> i64
      %bb2d_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb2d_25 = "braid.add"(%bb2d_8, %bb2d_24) : (i64, i64) -> i64
      %bb2d_0 = "braid.load"(%bb2d_25) {bytes = 8 : i64} : (i64) -> i64
      %bb2d_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb2d_27 = "braid.add"(%bb2d_8, %bb2d_26) : (i64, i64) -> i64
      %bb2d_1 = "braid.load"(%bb2d_27) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb2d_0) {reg = "zmm8.0"} : (i64) -> ()
      "braid.set"(%bb2d_1) {reg = "zmm8.1"} : (i64) -> ()
      "braid_cf.br"()[^bb33] : () -> ()
    ^bb33:  // 0x401033
      %bb33_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb33_10 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb33_8 = "braid.add"(%bb33_9, %bb33_10) : (i64, i64) -> i64
      %bb33_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb33_25 = "braid.add"(%bb33_8, %bb33_24) : (i64, i64) -> i64
      %bb33_0 = "braid.load"(%bb33_25) {bytes = 8 : i64} : (i64) -> i64
      %bb33_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb33_27 = "braid.add"(%bb33_8, %bb33_26) : (i64, i64) -> i64
      %bb33_1 = "braid.load"(%bb33_27) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb33_0) {reg = "zmm6.0"} : (i64) -> ()
      "braid.set"(%bb33_1) {reg = "zmm6.1"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x401038
      %bb38_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb38_0 = "braid.zext"(%bb38_1) {bits = 32 : i64} : (i64) -> i64
      %bb38_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb38_8 = "braid.zext"(%bb38_9) {bits = 32 : i64} : (i64) -> i64
      %bb38_16 = "braid.xor"(%bb38_0, %bb38_8) : (i64, i64) -> i64
      %bb38_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb38_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb38_17) {flag = "of"} : (i64) -> ()
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
      %bb38_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb38_40 = "braid.and"(%bb38_16, %bb38_39) : (i64, i64) -> i64
      "braid.setf"(%bb38_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb38_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb3a] : () -> ()
    ^bb3a:  // 0x40103a
      %bb3a_0 = "braid.const"() {value = 4202768 : i64} : () -> i64
      "braid.set"(%bb3a_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb41] : () -> ()
    ^bb41:  // 0x401041
      %bb41_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb41_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      "braid.set"(%bb41_0) {reg = "zmm5.0"} : (i64) -> ()
      "braid.set"(%bb41_1) {reg = "zmm5.1"} : (i64) -> ()
      "braid_cf.br"()[^bb45] : () -> ()
    ^bb45:  // 0x401045
      %bb45_0 = "braid.get"() {reg = "zmm4.0"} : () -> i64
      %bb45_1 = "braid.get"() {reg = "zmm4.1"} : () -> i64
      "braid.set"(%bb45_0) {reg = "zmm7.0"} : (i64) -> ()
      "braid.set"(%bb45_1) {reg = "zmm7.1"} : (i64) -> ()
      "braid_cf.br"()[^bb49] : () -> ()
    ^bb49:  // 0x401049
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x401050
      %bb50_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb50_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      "braid.set"(%bb50_0) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bb50_1) {reg = "zmm2.1"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x401054
      %bb54_0 = "braid.get"() {reg = "zmm9.0"} : () -> i64
      %bb54_1 = "braid.get"() {reg = "zmm9.1"} : () -> i64
      "braid.set"(%bb54_0) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bb54_1) {reg = "zmm1.1"} : (i64) -> ()
      "braid_cf.br"()[^bb59] : () -> ()
    ^bb59:  // 0x401059
      %bb59_0 = "braid.get"() {reg = "zmm8.0"} : () -> i64
      %bb59_1 = "braid.get"() {reg = "zmm8.1"} : () -> i64
      "braid.set"(%bb59_0) {reg = "zmm9.0"} : (i64) -> ()
      "braid.set"(%bb59_1) {reg = "zmm9.1"} : (i64) -> ()
      "braid_cf.br"()[^bb5e] : () -> ()
    ^bb5e:  // 0x40105e
      %bb5e_0 = "braid.get"() {reg = "zmm6.0"} : () -> i64
      %bb5e_1 = "braid.get"() {reg = "zmm6.1"} : () -> i64
      "braid.set"(%bb5e_0) {reg = "zmm8.0"} : (i64) -> ()
      "braid.set"(%bb5e_1) {reg = "zmm8.1"} : (i64) -> ()
      "braid_cf.br"()[^bb63] : () -> ()
    ^bb63:  // 0x401063
      %bb63_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb63_10 = "braid.get"() {reg = "rax"} : () -> i64
      %bb63_11 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb63_12 = "braid.mul"(%bb63_10, %bb63_11) : (i64, i64) -> i64
      %bb63_13 = "braid.add"(%bb63_9, %bb63_12) : (i64, i64) -> i64
      %bb63_14 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb63_8 = "braid.add"(%bb63_13, %bb63_14) : (i64, i64) -> i64
      %bb63_16 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb63_17 = "braid.and"(%bb63_8, %bb63_16) : (i64, i64) -> i64
      %bb63_18 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb63_19 = "braid.eq"(%bb63_17, %bb63_18) : (i64, i64) -> i64
      "braid.guard"(%bb63_19) : (i64) -> ()
      %bb63_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb63_25 = "braid.add"(%bb63_8, %bb63_24) : (i64, i64) -> i64
      %bb63_0 = "braid.load"(%bb63_25) {bytes = 8 : i64} : (i64) -> i64
      %bb63_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb63_27 = "braid.add"(%bb63_8, %bb63_26) : (i64, i64) -> i64
      %bb63_1 = "braid.load"(%bb63_27) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb63_0) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bb63_1) {reg = "zmm0.1"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x401068
      %bb68_0 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb68_1 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb68_40 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb68_41 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb68_80 = "braid.lanes"(%bb68_40, %bb68_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb68_81 = "braid.lanes"(%bb68_41, %bb68_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb68_80) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bb68_81) {reg = "zmm0.1"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x40106c
      %bb6c_0 = "braid.get"() {reg = "zmm7.0"} : () -> i64
      %bb6c_1 = "braid.get"() {reg = "zmm7.1"} : () -> i64
      %bb6c_40 = "braid.get"() {reg = "zmm5.0"} : () -> i64
      %bb6c_41 = "braid.get"() {reg = "zmm5.1"} : () -> i64
      %bb6c_80 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb6c_81 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb6c_82 = "braid.const"() {value = 6 : i64} : () -> i64
      %bb6c_83 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb6c_84 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb6c_85 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb6c_86 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb6c_87 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb6c_88 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bb6c_90 = "braid.lshr"(%bb6c_0, %bb6c_81) : (i64, i64) -> i64
      %bb6c_91 = "braid.lshr"(%bb6c_40, %bb6c_81) : (i64, i64) -> i64
      %bb6c_92 = "braid.lshr"(%bb6c_1, %bb6c_81) : (i64, i64) -> i64
      %bb6c_93 = "braid.lshr"(%bb6c_41, %bb6c_81) : (i64, i64) -> i64
      %bb6c_94 = "braid.lshr"(%bb6c_80, %bb6c_81) : (i64, i64) -> i64
      %bb6c_96 = "braid.shl"(%bb6c_90, %bb6c_81) : (i64, i64) -> i64
      %bb6c_97 = "braid.or"(%bb6c_90, %bb6c_96) : (i64, i64) -> i64
      %bb6c_98 = "braid.lshr"(%bb6c_97, %bb6c_82) : (i64, i64) -> i64
      %bb6c_99 = "braid.lshr"(%bb6c_97, %bb6c_83) : (i64, i64) -> i64
      %bb6c_100 = "braid.lshr"(%bb6c_97, %bb6c_84) : (i64, i64) -> i64
      %bb6c_101 = "braid.xor"(%bb6c_98, %bb6c_99) : (i64, i64) -> i64
      %bb6c_102 = "braid.xor"(%bb6c_101, %bb6c_100) : (i64, i64) -> i64
      %bb6c_103 = "braid.xor"(%bb6c_0, %bb6c_91) : (i64, i64) -> i64
      %bb6c_104 = "braid.and"(%bb6c_90, %bb6c_103) : (i64, i64) -> i64
      %bb6c_105 = "braid.xor"(%bb6c_91, %bb6c_104) : (i64, i64) -> i64
      %bb6c_106 = "braid.add"(%bb6c_105, %bb6c_102) : (i64, i64) -> i64
      %bb6c_107 = "braid.add"(%bb6c_106, %bb6c_80) : (i64, i64) -> i64
      %bb6c_108 = "braid.add"(%bb6c_107, %bb6c_40) : (i64, i64) -> i64
      %bb6c_109 = "braid.shl"(%bb6c_92, %bb6c_81) : (i64, i64) -> i64
      %bb6c_110 = "braid.or"(%bb6c_92, %bb6c_109) : (i64, i64) -> i64
      %bb6c_111 = "braid.lshr"(%bb6c_110, %bb6c_85) : (i64, i64) -> i64
      %bb6c_112 = "braid.lshr"(%bb6c_110, %bb6c_86) : (i64, i64) -> i64
      %bb6c_113 = "braid.lshr"(%bb6c_110, %bb6c_87) : (i64, i64) -> i64
      %bb6c_114 = "braid.xor"(%bb6c_111, %bb6c_112) : (i64, i64) -> i64
      %bb6c_115 = "braid.xor"(%bb6c_114, %bb6c_113) : (i64, i64) -> i64
      %bb6c_116 = "braid.xor"(%bb6c_1, %bb6c_93) : (i64, i64) -> i64
      %bb6c_117 = "braid.and"(%bb6c_92, %bb6c_116) : (i64, i64) -> i64
      %bb6c_118 = "braid.and"(%bb6c_1, %bb6c_93) : (i64, i64) -> i64
      %bb6c_119 = "braid.xor"(%bb6c_117, %bb6c_118) : (i64, i64) -> i64
      %bb6c_120 = "braid.add"(%bb6c_108, %bb6c_119) : (i64, i64) -> i64
      %bb6c_121 = "braid.add"(%bb6c_120, %bb6c_115) : (i64, i64) -> i64
      %bb6c_122 = "braid.add"(%bb6c_108, %bb6c_41) : (i64, i64) -> i64
      %bb6c_123 = "braid.and"(%bb6c_121, %bb6c_88) : (i64, i64) -> i64
      %bb6c_124 = "braid.and"(%bb6c_122, %bb6c_88) : (i64, i64) -> i64
      %bb6c_128 = "braid.shl"(%bb6c_124, %bb6c_81) : (i64, i64) -> i64
      %bb6c_129 = "braid.or"(%bb6c_124, %bb6c_128) : (i64, i64) -> i64
      %bb6c_130 = "braid.lshr"(%bb6c_129, %bb6c_82) : (i64, i64) -> i64
      %bb6c_131 = "braid.lshr"(%bb6c_129, %bb6c_83) : (i64, i64) -> i64
      %bb6c_132 = "braid.lshr"(%bb6c_129, %bb6c_84) : (i64, i64) -> i64
      %bb6c_133 = "braid.xor"(%bb6c_130, %bb6c_131) : (i64, i64) -> i64
      %bb6c_134 = "braid.xor"(%bb6c_133, %bb6c_132) : (i64, i64) -> i64
      %bb6c_135 = "braid.xor"(%bb6c_90, %bb6c_0) : (i64, i64) -> i64
      %bb6c_136 = "braid.and"(%bb6c_124, %bb6c_135) : (i64, i64) -> i64
      %bb6c_137 = "braid.xor"(%bb6c_0, %bb6c_136) : (i64, i64) -> i64
      %bb6c_138 = "braid.add"(%bb6c_137, %bb6c_134) : (i64, i64) -> i64
      %bb6c_139 = "braid.add"(%bb6c_138, %bb6c_94) : (i64, i64) -> i64
      %bb6c_140 = "braid.add"(%bb6c_139, %bb6c_91) : (i64, i64) -> i64
      %bb6c_141 = "braid.shl"(%bb6c_123, %bb6c_81) : (i64, i64) -> i64
      %bb6c_142 = "braid.or"(%bb6c_123, %bb6c_141) : (i64, i64) -> i64
      %bb6c_143 = "braid.lshr"(%bb6c_142, %bb6c_85) : (i64, i64) -> i64
      %bb6c_144 = "braid.lshr"(%bb6c_142, %bb6c_86) : (i64, i64) -> i64
      %bb6c_145 = "braid.lshr"(%bb6c_142, %bb6c_87) : (i64, i64) -> i64
      %bb6c_146 = "braid.xor"(%bb6c_143, %bb6c_144) : (i64, i64) -> i64
      %bb6c_147 = "braid.xor"(%bb6c_146, %bb6c_145) : (i64, i64) -> i64
      %bb6c_148 = "braid.xor"(%bb6c_92, %bb6c_1) : (i64, i64) -> i64
      %bb6c_149 = "braid.and"(%bb6c_123, %bb6c_148) : (i64, i64) -> i64
      %bb6c_150 = "braid.and"(%bb6c_92, %bb6c_1) : (i64, i64) -> i64
      %bb6c_151 = "braid.xor"(%bb6c_149, %bb6c_150) : (i64, i64) -> i64
      %bb6c_152 = "braid.add"(%bb6c_140, %bb6c_151) : (i64, i64) -> i64
      %bb6c_153 = "braid.add"(%bb6c_152, %bb6c_147) : (i64, i64) -> i64
      %bb6c_154 = "braid.add"(%bb6c_140, %bb6c_93) : (i64, i64) -> i64
      %bb6c_155 = "braid.shl"(%bb6c_154, %bb6c_81) : (i64, i64) -> i64
      %bb6c_200 = "braid.or"(%bb6c_124, %bb6c_155) : (i64, i64) -> i64
      %bb6c_156 = "braid.shl"(%bb6c_153, %bb6c_81) : (i64, i64) -> i64
      %bb6c_201 = "braid.or"(%bb6c_123, %bb6c_156) : (i64, i64) -> i64
      "braid.set"(%bb6c_200) {reg = "zmm5.0"} : (i64) -> ()
      "braid.set"(%bb6c_201) {reg = "zmm5.1"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x401070
      %bb70_0 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb70_1 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb70_40 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb70_41 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bb70_48 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb70_49 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb70_56 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb70_57 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb70_64 = "braid.lshr"(%bb70_1, %bb70_48) : (i64, i64) -> i64
      %bb70_65 = "braid.lshr"(%bb70_0, %bb70_49) : (i64, i64) -> i64
      %bb70_72 = "braid.and"(%bb70_64, %bb70_41) : (i64, i64) -> i64
      %bb70_73 = "braid.and"(%bb70_65, %bb70_41) : (i64, i64) -> i64
      %bb70_80 = "braid.lshr"(%bb70_1, %bb70_56) : (i64, i64) -> i64
      %bb70_81 = "braid.lshr"(%bb70_0, %bb70_57) : (i64, i64) -> i64
      %bb70_88 = "braid.shl"(%bb70_80, %bb70_40) : (i64, i64) -> i64
      %bb70_89 = "braid.shl"(%bb70_81, %bb70_40) : (i64, i64) -> i64
      %bb70_96 = "braid.or"(%bb70_72, %bb70_88) : (i64, i64) -> i64
      %bb70_97 = "braid.or"(%bb70_73, %bb70_89) : (i64, i64) -> i64
      "braid.set"(%bb70_96) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bb70_97) {reg = "zmm0.1"} : (i64) -> ()
      "braid_cf.br"()[^bb75] : () -> ()
    ^bb75:  // 0x401075
      %bb75_0 = "braid.get"() {reg = "zmm5.0"} : () -> i64
      %bb75_1 = "braid.get"() {reg = "zmm5.1"} : () -> i64
      %bb75_40 = "braid.get"() {reg = "zmm7.0"} : () -> i64
      %bb75_41 = "braid.get"() {reg = "zmm7.1"} : () -> i64
      %bb75_80 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb75_81 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb75_82 = "braid.const"() {value = 6 : i64} : () -> i64
      %bb75_83 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb75_84 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb75_85 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb75_86 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb75_87 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb75_88 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bb75_90 = "braid.lshr"(%bb75_0, %bb75_81) : (i64, i64) -> i64
      %bb75_91 = "braid.lshr"(%bb75_40, %bb75_81) : (i64, i64) -> i64
      %bb75_92 = "braid.lshr"(%bb75_1, %bb75_81) : (i64, i64) -> i64
      %bb75_93 = "braid.lshr"(%bb75_41, %bb75_81) : (i64, i64) -> i64
      %bb75_94 = "braid.lshr"(%bb75_80, %bb75_81) : (i64, i64) -> i64
      %bb75_96 = "braid.shl"(%bb75_90, %bb75_81) : (i64, i64) -> i64
      %bb75_97 = "braid.or"(%bb75_90, %bb75_96) : (i64, i64) -> i64
      %bb75_98 = "braid.lshr"(%bb75_97, %bb75_82) : (i64, i64) -> i64
      %bb75_99 = "braid.lshr"(%bb75_97, %bb75_83) : (i64, i64) -> i64
      %bb75_100 = "braid.lshr"(%bb75_97, %bb75_84) : (i64, i64) -> i64
      %bb75_101 = "braid.xor"(%bb75_98, %bb75_99) : (i64, i64) -> i64
      %bb75_102 = "braid.xor"(%bb75_101, %bb75_100) : (i64, i64) -> i64
      %bb75_103 = "braid.xor"(%bb75_0, %bb75_91) : (i64, i64) -> i64
      %bb75_104 = "braid.and"(%bb75_90, %bb75_103) : (i64, i64) -> i64
      %bb75_105 = "braid.xor"(%bb75_91, %bb75_104) : (i64, i64) -> i64
      %bb75_106 = "braid.add"(%bb75_105, %bb75_102) : (i64, i64) -> i64
      %bb75_107 = "braid.add"(%bb75_106, %bb75_80) : (i64, i64) -> i64
      %bb75_108 = "braid.add"(%bb75_107, %bb75_40) : (i64, i64) -> i64
      %bb75_109 = "braid.shl"(%bb75_92, %bb75_81) : (i64, i64) -> i64
      %bb75_110 = "braid.or"(%bb75_92, %bb75_109) : (i64, i64) -> i64
      %bb75_111 = "braid.lshr"(%bb75_110, %bb75_85) : (i64, i64) -> i64
      %bb75_112 = "braid.lshr"(%bb75_110, %bb75_86) : (i64, i64) -> i64
      %bb75_113 = "braid.lshr"(%bb75_110, %bb75_87) : (i64, i64) -> i64
      %bb75_114 = "braid.xor"(%bb75_111, %bb75_112) : (i64, i64) -> i64
      %bb75_115 = "braid.xor"(%bb75_114, %bb75_113) : (i64, i64) -> i64
      %bb75_116 = "braid.xor"(%bb75_1, %bb75_93) : (i64, i64) -> i64
      %bb75_117 = "braid.and"(%bb75_92, %bb75_116) : (i64, i64) -> i64
      %bb75_118 = "braid.and"(%bb75_1, %bb75_93) : (i64, i64) -> i64
      %bb75_119 = "braid.xor"(%bb75_117, %bb75_118) : (i64, i64) -> i64
      %bb75_120 = "braid.add"(%bb75_108, %bb75_119) : (i64, i64) -> i64
      %bb75_121 = "braid.add"(%bb75_120, %bb75_115) : (i64, i64) -> i64
      %bb75_122 = "braid.add"(%bb75_108, %bb75_41) : (i64, i64) -> i64
      %bb75_123 = "braid.and"(%bb75_121, %bb75_88) : (i64, i64) -> i64
      %bb75_124 = "braid.and"(%bb75_122, %bb75_88) : (i64, i64) -> i64
      %bb75_128 = "braid.shl"(%bb75_124, %bb75_81) : (i64, i64) -> i64
      %bb75_129 = "braid.or"(%bb75_124, %bb75_128) : (i64, i64) -> i64
      %bb75_130 = "braid.lshr"(%bb75_129, %bb75_82) : (i64, i64) -> i64
      %bb75_131 = "braid.lshr"(%bb75_129, %bb75_83) : (i64, i64) -> i64
      %bb75_132 = "braid.lshr"(%bb75_129, %bb75_84) : (i64, i64) -> i64
      %bb75_133 = "braid.xor"(%bb75_130, %bb75_131) : (i64, i64) -> i64
      %bb75_134 = "braid.xor"(%bb75_133, %bb75_132) : (i64, i64) -> i64
      %bb75_135 = "braid.xor"(%bb75_90, %bb75_0) : (i64, i64) -> i64
      %bb75_136 = "braid.and"(%bb75_124, %bb75_135) : (i64, i64) -> i64
      %bb75_137 = "braid.xor"(%bb75_0, %bb75_136) : (i64, i64) -> i64
      %bb75_138 = "braid.add"(%bb75_137, %bb75_134) : (i64, i64) -> i64
      %bb75_139 = "braid.add"(%bb75_138, %bb75_94) : (i64, i64) -> i64
      %bb75_140 = "braid.add"(%bb75_139, %bb75_91) : (i64, i64) -> i64
      %bb75_141 = "braid.shl"(%bb75_123, %bb75_81) : (i64, i64) -> i64
      %bb75_142 = "braid.or"(%bb75_123, %bb75_141) : (i64, i64) -> i64
      %bb75_143 = "braid.lshr"(%bb75_142, %bb75_85) : (i64, i64) -> i64
      %bb75_144 = "braid.lshr"(%bb75_142, %bb75_86) : (i64, i64) -> i64
      %bb75_145 = "braid.lshr"(%bb75_142, %bb75_87) : (i64, i64) -> i64
      %bb75_146 = "braid.xor"(%bb75_143, %bb75_144) : (i64, i64) -> i64
      %bb75_147 = "braid.xor"(%bb75_146, %bb75_145) : (i64, i64) -> i64
      %bb75_148 = "braid.xor"(%bb75_92, %bb75_1) : (i64, i64) -> i64
      %bb75_149 = "braid.and"(%bb75_123, %bb75_148) : (i64, i64) -> i64
      %bb75_150 = "braid.and"(%bb75_92, %bb75_1) : (i64, i64) -> i64
      %bb75_151 = "braid.xor"(%bb75_149, %bb75_150) : (i64, i64) -> i64
      %bb75_152 = "braid.add"(%bb75_140, %bb75_151) : (i64, i64) -> i64
      %bb75_153 = "braid.add"(%bb75_152, %bb75_147) : (i64, i64) -> i64
      %bb75_154 = "braid.add"(%bb75_140, %bb75_93) : (i64, i64) -> i64
      %bb75_155 = "braid.shl"(%bb75_154, %bb75_81) : (i64, i64) -> i64
      %bb75_200 = "braid.or"(%bb75_124, %bb75_155) : (i64, i64) -> i64
      %bb75_156 = "braid.shl"(%bb75_153, %bb75_81) : (i64, i64) -> i64
      %bb75_201 = "braid.or"(%bb75_123, %bb75_156) : (i64, i64) -> i64
      "braid.set"(%bb75_200) {reg = "zmm7.0"} : (i64) -> ()
      "braid.set"(%bb75_201) {reg = "zmm7.1"} : (i64) -> ()
      "braid_cf.br"()[^bb79] : () -> ()
    ^bb79:  // 0x401079
      %bb79_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb79_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bb79_40 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb79_41 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb79_82 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb79_83 = "braid.const"() {value = 144115183814443007 : i64} : () -> i64
      %bb79_84 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb79_85 = "braid.const"() {value = -144115183814443008 : i64} : () -> i64
      %bb79_86 = "braid.const"() {value = 18 : i64} : () -> i64
      %bb79_87 = "braid.const"() {value = 70364449226751 : i64} : () -> i64
      %bb79_88 = "braid.const"() {value = 14 : i64} : () -> i64
      %bb79_89 = "braid.const"() {value = -70364449226752 : i64} : () -> i64
      %bb79_90 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb79_91 = "braid.const"() {value = 2305843005455597567 : i64} : () -> i64
      %bb79_92 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb79_93 = "braid.lshr"(%bb79_40, %bb79_92) : (i64, i64) -> i64
      %bb79_94 = "braid.shl"(%bb79_41, %bb79_92) : (i64, i64) -> i64
      %bb79_95 = "braid.or"(%bb79_93, %bb79_94) : (i64, i64) -> i64
      %bb79_96 = "braid.lshr"(%bb79_95, %bb79_82) : (i64, i64) -> i64
      %bb79_97 = "braid.and"(%bb79_96, %bb79_83) : (i64, i64) -> i64
      %bb79_98 = "braid.shl"(%bb79_95, %bb79_84) : (i64, i64) -> i64
      %bb79_99 = "braid.and"(%bb79_98, %bb79_85) : (i64, i64) -> i64
      %bb79_100 = "braid.or"(%bb79_97, %bb79_99) : (i64, i64) -> i64
      %bb79_101 = "braid.lshr"(%bb79_95, %bb79_86) : (i64, i64) -> i64
      %bb79_102 = "braid.and"(%bb79_101, %bb79_87) : (i64, i64) -> i64
      %bb79_103 = "braid.shl"(%bb79_95, %bb79_88) : (i64, i64) -> i64
      %bb79_104 = "braid.and"(%bb79_103, %bb79_89) : (i64, i64) -> i64
      %bb79_105 = "braid.or"(%bb79_102, %bb79_104) : (i64, i64) -> i64
      %bb79_106 = "braid.lshr"(%bb79_95, %bb79_90) : (i64, i64) -> i64
      %bb79_107 = "braid.and"(%bb79_106, %bb79_91) : (i64, i64) -> i64
      %bb79_108 = "braid.xor"(%bb79_100, %bb79_105) : (i64, i64) -> i64
      %bb79_109 = "braid.xor"(%bb79_108, %bb79_107) : (i64, i64) -> i64
      %bb79_200 = "braid.lanes"(%bb79_40, %bb79_109) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb79_110 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb79_111 = "braid.lshr"(%bb79_41, %bb79_110) : (i64, i64) -> i64
      %bb79_112 = "braid.shl"(%bb79_0, %bb79_110) : (i64, i64) -> i64
      %bb79_113 = "braid.or"(%bb79_111, %bb79_112) : (i64, i64) -> i64
      %bb79_120 = "braid.lshr"(%bb79_113, %bb79_82) : (i64, i64) -> i64
      %bb79_121 = "braid.and"(%bb79_120, %bb79_83) : (i64, i64) -> i64
      %bb79_122 = "braid.shl"(%bb79_113, %bb79_84) : (i64, i64) -> i64
      %bb79_123 = "braid.and"(%bb79_122, %bb79_85) : (i64, i64) -> i64
      %bb79_124 = "braid.or"(%bb79_121, %bb79_123) : (i64, i64) -> i64
      %bb79_125 = "braid.lshr"(%bb79_113, %bb79_86) : (i64, i64) -> i64
      %bb79_126 = "braid.and"(%bb79_125, %bb79_87) : (i64, i64) -> i64
      %bb79_127 = "braid.shl"(%bb79_113, %bb79_88) : (i64, i64) -> i64
      %bb79_128 = "braid.and"(%bb79_127, %bb79_89) : (i64, i64) -> i64
      %bb79_129 = "braid.or"(%bb79_126, %bb79_128) : (i64, i64) -> i64
      %bb79_130 = "braid.lshr"(%bb79_113, %bb79_90) : (i64, i64) -> i64
      %bb79_131 = "braid.and"(%bb79_130, %bb79_91) : (i64, i64) -> i64
      %bb79_132 = "braid.xor"(%bb79_124, %bb79_129) : (i64, i64) -> i64
      %bb79_133 = "braid.xor"(%bb79_132, %bb79_131) : (i64, i64) -> i64
      %bb79_201 = "braid.lanes"(%bb79_41, %bb79_133) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb79_200) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bb79_201) {reg = "zmm2.1"} : (i64) -> ()
      "braid_cf.br"()[^bb7d] : () -> ()
    ^bb7d:  // 0x40107d
      %bb7d_0 = "braid.get"() {reg = "zmm9.0"} : () -> i64
      %bb7d_1 = "braid.get"() {reg = "zmm9.1"} : () -> i64
      %bb7d_40 = "braid.get"() {reg = "zmm6.0"} : () -> i64
      %bb7d_41 = "braid.get"() {reg = "zmm6.1"} : () -> i64
      %bb7d_80 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb7d_88 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb7d_89 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb7d_96 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb7d_97 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb7d_104 = "braid.lshr"(%bb7d_0, %bb7d_88) : (i64, i64) -> i64
      %bb7d_105 = "braid.lshr"(%bb7d_1, %bb7d_89) : (i64, i64) -> i64
      %bb7d_112 = "braid.shl"(%bb7d_1, %bb7d_96) : (i64, i64) -> i64
      %bb7d_113 = "braid.shl"(%bb7d_40, %bb7d_97) : (i64, i64) -> i64
      %bb7d_120 = "braid.or"(%bb7d_104, %bb7d_112) : (i64, i64) -> i64
      %bb7d_121 = "braid.or"(%bb7d_105, %bb7d_113) : (i64, i64) -> i64
      "braid.set"(%bb7d_120) {reg = "zmm6.0"} : (i64) -> ()
      "braid.set"(%bb7d_121) {reg = "zmm6.1"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x401084
      %bb84_0 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb84_1 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb84_40 = "braid.get"() {reg = "zmm6.0"} : () -> i64
      %bb84_41 = "braid.get"() {reg = "zmm6.1"} : () -> i64
      %bb84_80 = "braid.lanes"(%bb84_40, %bb84_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb84_81 = "braid.lanes"(%bb84_41, %bb84_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb84_80) {reg = "zmm6.0"} : (i64) -> ()
      "braid.set"(%bb84_81) {reg = "zmm6.1"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x401088
      %bb88_0 = "braid.get"() {reg = "zmm8.0"} : () -> i64
      %bb88_1 = "braid.get"() {reg = "zmm8.1"} : () -> i64
      %bb88_40 = "braid.get"() {reg = "zmm6.0"} : () -> i64
      %bb88_41 = "braid.get"() {reg = "zmm6.1"} : () -> i64
      %bb88_80 = "braid.const"() {value = 17 : i64} : () -> i64
      %bb88_81 = "braid.const"() {value = 140733193420799 : i64} : () -> i64
      %bb88_82 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb88_83 = "braid.const"() {value = -140733193420800 : i64} : () -> i64
      %bb88_84 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb88_85 = "braid.const"() {value = 35180077129727 : i64} : () -> i64
      %bb88_86 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb88_87 = "braid.const"() {value = -35180077129728 : i64} : () -> i64
      %bb88_88 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb88_89 = "braid.const"() {value = 18014394218708991 : i64} : () -> i64
      %bb88_96 = "braid.lshr"(%bb88_1, %bb88_80) : (i64, i64) -> i64
      %bb88_97 = "braid.and"(%bb88_96, %bb88_81) : (i64, i64) -> i64
      %bb88_98 = "braid.shl"(%bb88_1, %bb88_82) : (i64, i64) -> i64
      %bb88_99 = "braid.and"(%bb88_98, %bb88_83) : (i64, i64) -> i64
      %bb88_100 = "braid.or"(%bb88_97, %bb88_99) : (i64, i64) -> i64
      %bb88_101 = "braid.lshr"(%bb88_1, %bb88_84) : (i64, i64) -> i64
      %bb88_102 = "braid.and"(%bb88_101, %bb88_85) : (i64, i64) -> i64
      %bb88_103 = "braid.shl"(%bb88_1, %bb88_86) : (i64, i64) -> i64
      %bb88_104 = "braid.and"(%bb88_103, %bb88_87) : (i64, i64) -> i64
      %bb88_105 = "braid.or"(%bb88_102, %bb88_104) : (i64, i64) -> i64
      %bb88_106 = "braid.lshr"(%bb88_1, %bb88_88) : (i64, i64) -> i64
      %bb88_107 = "braid.and"(%bb88_106, %bb88_89) : (i64, i64) -> i64
      %bb88_108 = "braid.xor"(%bb88_100, %bb88_105) : (i64, i64) -> i64
      %bb88_109 = "braid.xor"(%bb88_108, %bb88_107) : (i64, i64) -> i64
      %bb88_200 = "braid.lanes"(%bb88_40, %bb88_109) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb88_112 = "braid.lshr"(%bb88_200, %bb88_80) : (i64, i64) -> i64
      %bb88_113 = "braid.and"(%bb88_112, %bb88_81) : (i64, i64) -> i64
      %bb88_114 = "braid.shl"(%bb88_200, %bb88_82) : (i64, i64) -> i64
      %bb88_115 = "braid.and"(%bb88_114, %bb88_83) : (i64, i64) -> i64
      %bb88_116 = "braid.or"(%bb88_113, %bb88_115) : (i64, i64) -> i64
      %bb88_117 = "braid.lshr"(%bb88_200, %bb88_84) : (i64, i64) -> i64
      %bb88_118 = "braid.and"(%bb88_117, %bb88_85) : (i64, i64) -> i64
      %bb88_119 = "braid.shl"(%bb88_200, %bb88_86) : (i64, i64) -> i64
      %bb88_120 = "braid.and"(%bb88_119, %bb88_87) : (i64, i64) -> i64
      %bb88_121 = "braid.or"(%bb88_118, %bb88_120) : (i64, i64) -> i64
      %bb88_122 = "braid.lshr"(%bb88_200, %bb88_88) : (i64, i64) -> i64
      %bb88_123 = "braid.and"(%bb88_122, %bb88_89) : (i64, i64) -> i64
      %bb88_124 = "braid.xor"(%bb88_116, %bb88_121) : (i64, i64) -> i64
      %bb88_125 = "braid.xor"(%bb88_124, %bb88_123) : (i64, i64) -> i64
      %bb88_201 = "braid.lanes"(%bb88_41, %bb88_125) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb88_200) {reg = "zmm6.0"} : (i64) -> ()
      "braid.set"(%bb88_201) {reg = "zmm6.1"} : (i64) -> ()
      "braid_cf.br"()[^bb8d] : () -> ()
    ^bb8d:  // 0x40108d
      %bb8d_0 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb8d_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb8d_16 = "braid.add"(%bb8d_0, %bb8d_8) : (i64, i64) -> i64
      %bb8d_18 = "braid.ult"(%bb8d_16, %bb8d_0) : (i64, i64) -> i64
      "braid.setf"(%bb8d_18) {flag = "cf"} : (i64) -> ()
      %bb8d_19 = "braid.xor"(%bb8d_0, %bb8d_16) : (i64, i64) -> i64
      %bb8d_20 = "braid.xor"(%bb8d_8, %bb8d_16) : (i64, i64) -> i64
      %bb8d_21 = "braid.and"(%bb8d_19, %bb8d_20) : (i64, i64) -> i64
      %bb8d_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb8d_23 = "braid.and"(%bb8d_21, %bb8d_22) : (i64, i64) -> i64
      "braid.setf"(%bb8d_23) {flag = "of"} : (i64) -> ()
      %bb8d_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bb8d_24) {flag = "af"} : (i64) -> ()
      %bb8d_32 = "braid.zext"(%bb8d_16) {bits = 8 : i64} : (i64) -> i64
      %bb8d_33 = "braid.popcnt"(%bb8d_32) : (i64) -> i64
      %bb8d_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb8d_35 = "braid.and"(%bb8d_33, %bb8d_34) : (i64, i64) -> i64
      %bb8d_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8d_37 = "braid.eq"(%bb8d_35, %bb8d_36) : (i64, i64) -> i64
      "braid.setf"(%bb8d_37) {flag = "pf"} : (i64) -> ()
      %bb8d_38 = "braid.eq"(%bb8d_16, %bb8d_36) : (i64, i64) -> i64
      "braid.setf"(%bb8d_38) {flag = "zf"} : (i64) -> ()
      %bb8d_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb8d_40 = "braid.and"(%bb8d_16, %bb8d_39) : (i64, i64) -> i64
      "braid.setf"(%bb8d_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb8d_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb91] : () -> ()
    ^bb91:  // 0x401091
      %bb91_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb91_8 = "braid.const"() {value = 192 : i64} : () -> i64
      %bb91_16 = "braid.sub"(%bb91_0, %bb91_8) : (i64, i64) -> i64
      %bb91_18 = "braid.ult"(%bb91_0, %bb91_8) : (i64, i64) -> i64
      "braid.setf"(%bb91_18) {flag = "cf"} : (i64) -> ()
      %bb91_19 = "braid.xor"(%bb91_0, %bb91_8) : (i64, i64) -> i64
      %bb91_20 = "braid.xor"(%bb91_0, %bb91_16) : (i64, i64) -> i64
      %bb91_21 = "braid.and"(%bb91_19, %bb91_20) : (i64, i64) -> i64
      %bb91_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb91_23 = "braid.and"(%bb91_21, %bb91_22) : (i64, i64) -> i64
      "braid.setf"(%bb91_23) {flag = "of"} : (i64) -> ()
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
      %bb91_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bb91_40 = "braid.and"(%bb91_16, %bb91_39) : (i64, i64) -> i64
      "braid.setf"(%bb91_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x401098
      %bb98_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bb98_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb98_0 = "braid.eq"(%bb98_1, %bb98_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb98_0)[^bb50, ^bb9a] : (i64) -> ()
    ^bb9a:  // 0x40109a
      %bb9a_1 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb9a_0 = "braid.zext"(%bb9a_1) {bits = 32 : i64} : (i64) -> i64
      %bb9a_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bb9a_8 = "braid.zext"(%bb9a_9) {bits = 32 : i64} : (i64) -> i64
      %bb9a_16 = "braid.xor"(%bb9a_0, %bb9a_8) : (i64, i64) -> i64
      %bb9a_17 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.setf"(%bb9a_17) {flag = "cf"} : (i64) -> ()
      "braid.setf"(%bb9a_17) {flag = "of"} : (i64) -> ()
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
      %bb9a_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bb9a_40 = "braid.and"(%bb9a_16, %bb9a_39) : (i64, i64) -> i64
      "braid.setf"(%bb9a_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bb9a_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x40109c
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x4010a0
      %bba0_9 = "braid.get"() {reg = "rcx"} : () -> i64
      %bba0_10 = "braid.get"() {reg = "rax"} : () -> i64
      %bba0_11 = "braid.const"() {value = 1 : i64} : () -> i64
      %bba0_12 = "braid.mul"(%bba0_10, %bba0_11) : (i64, i64) -> i64
      %bba0_13 = "braid.add"(%bba0_9, %bba0_12) : (i64, i64) -> i64
      %bba0_14 = "braid.const"() {value = 192 : i64} : () -> i64
      %bba0_8 = "braid.add"(%bba0_13, %bba0_14) : (i64, i64) -> i64
      %bba0_16 = "braid.const"() {value = 15 : i64} : () -> i64
      %bba0_17 = "braid.and"(%bba0_8, %bba0_16) : (i64, i64) -> i64
      %bba0_18 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba0_19 = "braid.eq"(%bba0_17, %bba0_18) : (i64, i64) -> i64
      "braid.guard"(%bba0_19) : (i64) -> ()
      %bba0_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba0_25 = "braid.add"(%bba0_8, %bba0_24) : (i64, i64) -> i64
      %bba0_0 = "braid.load"(%bba0_25) {bytes = 8 : i64} : (i64) -> i64
      %bba0_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bba0_27 = "braid.add"(%bba0_8, %bba0_26) : (i64, i64) -> i64
      %bba0_1 = "braid.load"(%bba0_27) {bytes = 8 : i64} : (i64) -> i64
      %bba0_40 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bba0_41 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bba0_80 = "braid.lanes"(%bba0_40, %bba0_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bba0_81 = "braid.lanes"(%bba0_41, %bba0_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bba0_80) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bba0_81) {reg = "zmm1.1"} : (i64) -> ()
      "braid_cf.br"()[^bba9] : () -> ()
    ^bba9:  // 0x4010a9
      %bba9_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bba9_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bba9_40 = "braid.const"() {value = 32 : i64} : () -> i64
      %bba9_41 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bba9_48 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba9_49 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba9_56 = "braid.const"() {value = 32 : i64} : () -> i64
      %bba9_57 = "braid.const"() {value = 0 : i64} : () -> i64
      %bba9_64 = "braid.lshr"(%bba9_1, %bba9_48) : (i64, i64) -> i64
      %bba9_65 = "braid.lshr"(%bba9_0, %bba9_49) : (i64, i64) -> i64
      %bba9_72 = "braid.and"(%bba9_64, %bba9_41) : (i64, i64) -> i64
      %bba9_73 = "braid.and"(%bba9_65, %bba9_41) : (i64, i64) -> i64
      %bba9_80 = "braid.lshr"(%bba9_1, %bba9_56) : (i64, i64) -> i64
      %bba9_81 = "braid.lshr"(%bba9_0, %bba9_57) : (i64, i64) -> i64
      %bba9_88 = "braid.shl"(%bba9_80, %bba9_40) : (i64, i64) -> i64
      %bba9_89 = "braid.shl"(%bba9_81, %bba9_40) : (i64, i64) -> i64
      %bba9_96 = "braid.or"(%bba9_72, %bba9_88) : (i64, i64) -> i64
      %bba9_97 = "braid.or"(%bba9_73, %bba9_89) : (i64, i64) -> i64
      "braid.set"(%bba9_96) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bba9_97) {reg = "zmm2.1"} : (i64) -> ()
      "braid_cf.br"()[^bbae] : () -> ()
    ^bbae:  // 0x4010ae
      %bbae_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bbae_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      "braid.set"(%bbae_0) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bbae_1) {reg = "zmm0.1"} : (i64) -> ()
      "braid_cf.br"()[^bbb2] : () -> ()
    ^bbb2:  // 0x4010b2
      %bbb2_0 = "braid.get"() {reg = "zmm9.0"} : () -> i64
      %bbb2_1 = "braid.get"() {reg = "zmm9.1"} : () -> i64
      "braid.set"(%bbb2_0) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bbb2_1) {reg = "zmm1.1"} : (i64) -> ()
      "braid_cf.br"()[^bbb7] : () -> ()
    ^bbb7:  // 0x4010b7
      %bbb7_0 = "braid.get"() {reg = "zmm8.0"} : () -> i64
      %bbb7_1 = "braid.get"() {reg = "zmm8.1"} : () -> i64
      "braid.set"(%bbb7_0) {reg = "zmm9.0"} : (i64) -> ()
      "braid.set"(%bbb7_1) {reg = "zmm9.1"} : (i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x4010bc
      %bbbc_0 = "braid.get"() {reg = "zmm7.0"} : () -> i64
      %bbbc_1 = "braid.get"() {reg = "zmm7.1"} : () -> i64
      %bbbc_40 = "braid.get"() {reg = "zmm5.0"} : () -> i64
      %bbbc_41 = "braid.get"() {reg = "zmm5.1"} : () -> i64
      %bbbc_80 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bbbc_81 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbbc_82 = "braid.const"() {value = 6 : i64} : () -> i64
      %bbbc_83 = "braid.const"() {value = 11 : i64} : () -> i64
      %bbbc_84 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbbc_85 = "braid.const"() {value = 2 : i64} : () -> i64
      %bbbc_86 = "braid.const"() {value = 13 : i64} : () -> i64
      %bbbc_87 = "braid.const"() {value = 22 : i64} : () -> i64
      %bbbc_88 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bbbc_90 = "braid.lshr"(%bbbc_0, %bbbc_81) : (i64, i64) -> i64
      %bbbc_91 = "braid.lshr"(%bbbc_40, %bbbc_81) : (i64, i64) -> i64
      %bbbc_92 = "braid.lshr"(%bbbc_1, %bbbc_81) : (i64, i64) -> i64
      %bbbc_93 = "braid.lshr"(%bbbc_41, %bbbc_81) : (i64, i64) -> i64
      %bbbc_94 = "braid.lshr"(%bbbc_80, %bbbc_81) : (i64, i64) -> i64
      %bbbc_96 = "braid.shl"(%bbbc_90, %bbbc_81) : (i64, i64) -> i64
      %bbbc_97 = "braid.or"(%bbbc_90, %bbbc_96) : (i64, i64) -> i64
      %bbbc_98 = "braid.lshr"(%bbbc_97, %bbbc_82) : (i64, i64) -> i64
      %bbbc_99 = "braid.lshr"(%bbbc_97, %bbbc_83) : (i64, i64) -> i64
      %bbbc_100 = "braid.lshr"(%bbbc_97, %bbbc_84) : (i64, i64) -> i64
      %bbbc_101 = "braid.xor"(%bbbc_98, %bbbc_99) : (i64, i64) -> i64
      %bbbc_102 = "braid.xor"(%bbbc_101, %bbbc_100) : (i64, i64) -> i64
      %bbbc_103 = "braid.xor"(%bbbc_0, %bbbc_91) : (i64, i64) -> i64
      %bbbc_104 = "braid.and"(%bbbc_90, %bbbc_103) : (i64, i64) -> i64
      %bbbc_105 = "braid.xor"(%bbbc_91, %bbbc_104) : (i64, i64) -> i64
      %bbbc_106 = "braid.add"(%bbbc_105, %bbbc_102) : (i64, i64) -> i64
      %bbbc_107 = "braid.add"(%bbbc_106, %bbbc_80) : (i64, i64) -> i64
      %bbbc_108 = "braid.add"(%bbbc_107, %bbbc_40) : (i64, i64) -> i64
      %bbbc_109 = "braid.shl"(%bbbc_92, %bbbc_81) : (i64, i64) -> i64
      %bbbc_110 = "braid.or"(%bbbc_92, %bbbc_109) : (i64, i64) -> i64
      %bbbc_111 = "braid.lshr"(%bbbc_110, %bbbc_85) : (i64, i64) -> i64
      %bbbc_112 = "braid.lshr"(%bbbc_110, %bbbc_86) : (i64, i64) -> i64
      %bbbc_113 = "braid.lshr"(%bbbc_110, %bbbc_87) : (i64, i64) -> i64
      %bbbc_114 = "braid.xor"(%bbbc_111, %bbbc_112) : (i64, i64) -> i64
      %bbbc_115 = "braid.xor"(%bbbc_114, %bbbc_113) : (i64, i64) -> i64
      %bbbc_116 = "braid.xor"(%bbbc_1, %bbbc_93) : (i64, i64) -> i64
      %bbbc_117 = "braid.and"(%bbbc_92, %bbbc_116) : (i64, i64) -> i64
      %bbbc_118 = "braid.and"(%bbbc_1, %bbbc_93) : (i64, i64) -> i64
      %bbbc_119 = "braid.xor"(%bbbc_117, %bbbc_118) : (i64, i64) -> i64
      %bbbc_120 = "braid.add"(%bbbc_108, %bbbc_119) : (i64, i64) -> i64
      %bbbc_121 = "braid.add"(%bbbc_120, %bbbc_115) : (i64, i64) -> i64
      %bbbc_122 = "braid.add"(%bbbc_108, %bbbc_41) : (i64, i64) -> i64
      %bbbc_123 = "braid.and"(%bbbc_121, %bbbc_88) : (i64, i64) -> i64
      %bbbc_124 = "braid.and"(%bbbc_122, %bbbc_88) : (i64, i64) -> i64
      %bbbc_128 = "braid.shl"(%bbbc_124, %bbbc_81) : (i64, i64) -> i64
      %bbbc_129 = "braid.or"(%bbbc_124, %bbbc_128) : (i64, i64) -> i64
      %bbbc_130 = "braid.lshr"(%bbbc_129, %bbbc_82) : (i64, i64) -> i64
      %bbbc_131 = "braid.lshr"(%bbbc_129, %bbbc_83) : (i64, i64) -> i64
      %bbbc_132 = "braid.lshr"(%bbbc_129, %bbbc_84) : (i64, i64) -> i64
      %bbbc_133 = "braid.xor"(%bbbc_130, %bbbc_131) : (i64, i64) -> i64
      %bbbc_134 = "braid.xor"(%bbbc_133, %bbbc_132) : (i64, i64) -> i64
      %bbbc_135 = "braid.xor"(%bbbc_90, %bbbc_0) : (i64, i64) -> i64
      %bbbc_136 = "braid.and"(%bbbc_124, %bbbc_135) : (i64, i64) -> i64
      %bbbc_137 = "braid.xor"(%bbbc_0, %bbbc_136) : (i64, i64) -> i64
      %bbbc_138 = "braid.add"(%bbbc_137, %bbbc_134) : (i64, i64) -> i64
      %bbbc_139 = "braid.add"(%bbbc_138, %bbbc_94) : (i64, i64) -> i64
      %bbbc_140 = "braid.add"(%bbbc_139, %bbbc_91) : (i64, i64) -> i64
      %bbbc_141 = "braid.shl"(%bbbc_123, %bbbc_81) : (i64, i64) -> i64
      %bbbc_142 = "braid.or"(%bbbc_123, %bbbc_141) : (i64, i64) -> i64
      %bbbc_143 = "braid.lshr"(%bbbc_142, %bbbc_85) : (i64, i64) -> i64
      %bbbc_144 = "braid.lshr"(%bbbc_142, %bbbc_86) : (i64, i64) -> i64
      %bbbc_145 = "braid.lshr"(%bbbc_142, %bbbc_87) : (i64, i64) -> i64
      %bbbc_146 = "braid.xor"(%bbbc_143, %bbbc_144) : (i64, i64) -> i64
      %bbbc_147 = "braid.xor"(%bbbc_146, %bbbc_145) : (i64, i64) -> i64
      %bbbc_148 = "braid.xor"(%bbbc_92, %bbbc_1) : (i64, i64) -> i64
      %bbbc_149 = "braid.and"(%bbbc_123, %bbbc_148) : (i64, i64) -> i64
      %bbbc_150 = "braid.and"(%bbbc_92, %bbbc_1) : (i64, i64) -> i64
      %bbbc_151 = "braid.xor"(%bbbc_149, %bbbc_150) : (i64, i64) -> i64
      %bbbc_152 = "braid.add"(%bbbc_140, %bbbc_151) : (i64, i64) -> i64
      %bbbc_153 = "braid.add"(%bbbc_152, %bbbc_147) : (i64, i64) -> i64
      %bbbc_154 = "braid.add"(%bbbc_140, %bbbc_93) : (i64, i64) -> i64
      %bbbc_155 = "braid.shl"(%bbbc_154, %bbbc_81) : (i64, i64) -> i64
      %bbbc_200 = "braid.or"(%bbbc_124, %bbbc_155) : (i64, i64) -> i64
      %bbbc_156 = "braid.shl"(%bbbc_153, %bbbc_81) : (i64, i64) -> i64
      %bbbc_201 = "braid.or"(%bbbc_123, %bbbc_156) : (i64, i64) -> i64
      "braid.set"(%bbbc_200) {reg = "zmm5.0"} : (i64) -> ()
      "braid.set"(%bbbc_201) {reg = "zmm5.1"} : (i64) -> ()
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bbc0:  // 0x4010c0
      %bbc0_0 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bbc0_1 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      "braid.set"(%bbc0_0) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bbc0_1) {reg = "zmm0.1"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x4010c4
      %bbc4_0 = "braid.get"() {reg = "zmm5.0"} : () -> i64
      %bbc4_1 = "braid.get"() {reg = "zmm5.1"} : () -> i64
      %bbc4_40 = "braid.get"() {reg = "zmm7.0"} : () -> i64
      %bbc4_41 = "braid.get"() {reg = "zmm7.1"} : () -> i64
      %bbc4_80 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bbc4_81 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbc4_82 = "braid.const"() {value = 6 : i64} : () -> i64
      %bbc4_83 = "braid.const"() {value = 11 : i64} : () -> i64
      %bbc4_84 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbc4_85 = "braid.const"() {value = 2 : i64} : () -> i64
      %bbc4_86 = "braid.const"() {value = 13 : i64} : () -> i64
      %bbc4_87 = "braid.const"() {value = 22 : i64} : () -> i64
      %bbc4_88 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bbc4_90 = "braid.lshr"(%bbc4_0, %bbc4_81) : (i64, i64) -> i64
      %bbc4_91 = "braid.lshr"(%bbc4_40, %bbc4_81) : (i64, i64) -> i64
      %bbc4_92 = "braid.lshr"(%bbc4_1, %bbc4_81) : (i64, i64) -> i64
      %bbc4_93 = "braid.lshr"(%bbc4_41, %bbc4_81) : (i64, i64) -> i64
      %bbc4_94 = "braid.lshr"(%bbc4_80, %bbc4_81) : (i64, i64) -> i64
      %bbc4_96 = "braid.shl"(%bbc4_90, %bbc4_81) : (i64, i64) -> i64
      %bbc4_97 = "braid.or"(%bbc4_90, %bbc4_96) : (i64, i64) -> i64
      %bbc4_98 = "braid.lshr"(%bbc4_97, %bbc4_82) : (i64, i64) -> i64
      %bbc4_99 = "braid.lshr"(%bbc4_97, %bbc4_83) : (i64, i64) -> i64
      %bbc4_100 = "braid.lshr"(%bbc4_97, %bbc4_84) : (i64, i64) -> i64
      %bbc4_101 = "braid.xor"(%bbc4_98, %bbc4_99) : (i64, i64) -> i64
      %bbc4_102 = "braid.xor"(%bbc4_101, %bbc4_100) : (i64, i64) -> i64
      %bbc4_103 = "braid.xor"(%bbc4_0, %bbc4_91) : (i64, i64) -> i64
      %bbc4_104 = "braid.and"(%bbc4_90, %bbc4_103) : (i64, i64) -> i64
      %bbc4_105 = "braid.xor"(%bbc4_91, %bbc4_104) : (i64, i64) -> i64
      %bbc4_106 = "braid.add"(%bbc4_105, %bbc4_102) : (i64, i64) -> i64
      %bbc4_107 = "braid.add"(%bbc4_106, %bbc4_80) : (i64, i64) -> i64
      %bbc4_108 = "braid.add"(%bbc4_107, %bbc4_40) : (i64, i64) -> i64
      %bbc4_109 = "braid.shl"(%bbc4_92, %bbc4_81) : (i64, i64) -> i64
      %bbc4_110 = "braid.or"(%bbc4_92, %bbc4_109) : (i64, i64) -> i64
      %bbc4_111 = "braid.lshr"(%bbc4_110, %bbc4_85) : (i64, i64) -> i64
      %bbc4_112 = "braid.lshr"(%bbc4_110, %bbc4_86) : (i64, i64) -> i64
      %bbc4_113 = "braid.lshr"(%bbc4_110, %bbc4_87) : (i64, i64) -> i64
      %bbc4_114 = "braid.xor"(%bbc4_111, %bbc4_112) : (i64, i64) -> i64
      %bbc4_115 = "braid.xor"(%bbc4_114, %bbc4_113) : (i64, i64) -> i64
      %bbc4_116 = "braid.xor"(%bbc4_1, %bbc4_93) : (i64, i64) -> i64
      %bbc4_117 = "braid.and"(%bbc4_92, %bbc4_116) : (i64, i64) -> i64
      %bbc4_118 = "braid.and"(%bbc4_1, %bbc4_93) : (i64, i64) -> i64
      %bbc4_119 = "braid.xor"(%bbc4_117, %bbc4_118) : (i64, i64) -> i64
      %bbc4_120 = "braid.add"(%bbc4_108, %bbc4_119) : (i64, i64) -> i64
      %bbc4_121 = "braid.add"(%bbc4_120, %bbc4_115) : (i64, i64) -> i64
      %bbc4_122 = "braid.add"(%bbc4_108, %bbc4_41) : (i64, i64) -> i64
      %bbc4_123 = "braid.and"(%bbc4_121, %bbc4_88) : (i64, i64) -> i64
      %bbc4_124 = "braid.and"(%bbc4_122, %bbc4_88) : (i64, i64) -> i64
      %bbc4_128 = "braid.shl"(%bbc4_124, %bbc4_81) : (i64, i64) -> i64
      %bbc4_129 = "braid.or"(%bbc4_124, %bbc4_128) : (i64, i64) -> i64
      %bbc4_130 = "braid.lshr"(%bbc4_129, %bbc4_82) : (i64, i64) -> i64
      %bbc4_131 = "braid.lshr"(%bbc4_129, %bbc4_83) : (i64, i64) -> i64
      %bbc4_132 = "braid.lshr"(%bbc4_129, %bbc4_84) : (i64, i64) -> i64
      %bbc4_133 = "braid.xor"(%bbc4_130, %bbc4_131) : (i64, i64) -> i64
      %bbc4_134 = "braid.xor"(%bbc4_133, %bbc4_132) : (i64, i64) -> i64
      %bbc4_135 = "braid.xor"(%bbc4_90, %bbc4_0) : (i64, i64) -> i64
      %bbc4_136 = "braid.and"(%bbc4_124, %bbc4_135) : (i64, i64) -> i64
      %bbc4_137 = "braid.xor"(%bbc4_0, %bbc4_136) : (i64, i64) -> i64
      %bbc4_138 = "braid.add"(%bbc4_137, %bbc4_134) : (i64, i64) -> i64
      %bbc4_139 = "braid.add"(%bbc4_138, %bbc4_94) : (i64, i64) -> i64
      %bbc4_140 = "braid.add"(%bbc4_139, %bbc4_91) : (i64, i64) -> i64
      %bbc4_141 = "braid.shl"(%bbc4_123, %bbc4_81) : (i64, i64) -> i64
      %bbc4_142 = "braid.or"(%bbc4_123, %bbc4_141) : (i64, i64) -> i64
      %bbc4_143 = "braid.lshr"(%bbc4_142, %bbc4_85) : (i64, i64) -> i64
      %bbc4_144 = "braid.lshr"(%bbc4_142, %bbc4_86) : (i64, i64) -> i64
      %bbc4_145 = "braid.lshr"(%bbc4_142, %bbc4_87) : (i64, i64) -> i64
      %bbc4_146 = "braid.xor"(%bbc4_143, %bbc4_144) : (i64, i64) -> i64
      %bbc4_147 = "braid.xor"(%bbc4_146, %bbc4_145) : (i64, i64) -> i64
      %bbc4_148 = "braid.xor"(%bbc4_92, %bbc4_1) : (i64, i64) -> i64
      %bbc4_149 = "braid.and"(%bbc4_123, %bbc4_148) : (i64, i64) -> i64
      %bbc4_150 = "braid.and"(%bbc4_92, %bbc4_1) : (i64, i64) -> i64
      %bbc4_151 = "braid.xor"(%bbc4_149, %bbc4_150) : (i64, i64) -> i64
      %bbc4_152 = "braid.add"(%bbc4_140, %bbc4_151) : (i64, i64) -> i64
      %bbc4_153 = "braid.add"(%bbc4_152, %bbc4_147) : (i64, i64) -> i64
      %bbc4_154 = "braid.add"(%bbc4_140, %bbc4_93) : (i64, i64) -> i64
      %bbc4_155 = "braid.shl"(%bbc4_154, %bbc4_81) : (i64, i64) -> i64
      %bbc4_200 = "braid.or"(%bbc4_124, %bbc4_155) : (i64, i64) -> i64
      %bbc4_156 = "braid.shl"(%bbc4_153, %bbc4_81) : (i64, i64) -> i64
      %bbc4_201 = "braid.or"(%bbc4_123, %bbc4_156) : (i64, i64) -> i64
      "braid.set"(%bbc4_200) {reg = "zmm7.0"} : (i64) -> ()
      "braid.set"(%bbc4_201) {reg = "zmm7.1"} : (i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x4010c8
      %bbc8_0 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbc8_8 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbc8_16 = "braid.add"(%bbc8_0, %bbc8_8) : (i64, i64) -> i64
      %bbc8_18 = "braid.ult"(%bbc8_16, %bbc8_0) : (i64, i64) -> i64
      "braid.setf"(%bbc8_18) {flag = "cf"} : (i64) -> ()
      %bbc8_19 = "braid.xor"(%bbc8_0, %bbc8_16) : (i64, i64) -> i64
      %bbc8_20 = "braid.xor"(%bbc8_8, %bbc8_16) : (i64, i64) -> i64
      %bbc8_21 = "braid.and"(%bbc8_19, %bbc8_20) : (i64, i64) -> i64
      %bbc8_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbc8_23 = "braid.and"(%bbc8_21, %bbc8_22) : (i64, i64) -> i64
      "braid.setf"(%bbc8_23) {flag = "of"} : (i64) -> ()
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
      %bbc8_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbc8_40 = "braid.and"(%bbc8_16, %bbc8_39) : (i64, i64) -> i64
      "braid.setf"(%bbc8_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbc8_16) {reg = "rcx"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x4010cc
      %bbcc_0 = "braid.get"() {reg = "zmm6.0"} : () -> i64
      %bbcc_1 = "braid.get"() {reg = "zmm6.1"} : () -> i64
      "braid.set"(%bbcc_0) {reg = "zmm8.0"} : (i64) -> ()
      "braid.set"(%bbcc_1) {reg = "zmm8.1"} : (i64) -> ()
      "braid_cf.br"()[^bbd1] : () -> ()
    ^bbd1:  // 0x4010d1
      %bbd1_0 = "braid.get"() {reg = "rcx"} : () -> i64
      %bbd1_8 = "braid.const"() {value = 64 : i64} : () -> i64
      %bbd1_16 = "braid.sub"(%bbd1_0, %bbd1_8) : (i64, i64) -> i64
      %bbd1_18 = "braid.ult"(%bbd1_0, %bbd1_8) : (i64, i64) -> i64
      "braid.setf"(%bbd1_18) {flag = "cf"} : (i64) -> ()
      %bbd1_19 = "braid.xor"(%bbd1_0, %bbd1_8) : (i64, i64) -> i64
      %bbd1_20 = "braid.xor"(%bbd1_0, %bbd1_16) : (i64, i64) -> i64
      %bbd1_21 = "braid.and"(%bbd1_19, %bbd1_20) : (i64, i64) -> i64
      %bbd1_22 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbd1_23 = "braid.and"(%bbd1_21, %bbd1_22) : (i64, i64) -> i64
      "braid.setf"(%bbd1_23) {flag = "of"} : (i64) -> ()
      %bbd1_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbd1_24) {flag = "af"} : (i64) -> ()
      %bbd1_32 = "braid.zext"(%bbd1_16) {bits = 8 : i64} : (i64) -> i64
      %bbd1_33 = "braid.popcnt"(%bbd1_32) : (i64) -> i64
      %bbd1_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd1_35 = "braid.and"(%bbd1_33, %bbd1_34) : (i64, i64) -> i64
      %bbd1_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd1_37 = "braid.eq"(%bbd1_35, %bbd1_36) : (i64, i64) -> i64
      "braid.setf"(%bbd1_37) {flag = "pf"} : (i64) -> ()
      %bbd1_38 = "braid.eq"(%bbd1_16, %bbd1_36) : (i64, i64) -> i64
      "braid.setf"(%bbd1_38) {flag = "zf"} : (i64) -> ()
      %bbd1_39 = "braid.const"() {value = -9223372036854775808 : i64} : () -> i64
      %bbd1_40 = "braid.and"(%bbd1_16, %bbd1_39) : (i64, i64) -> i64
      "braid.setf"(%bbd1_40) {flag = "sf"} : (i64) -> ()
      "braid_cf.br"()[^bbd5] : () -> ()
    ^bbd5:  // 0x4010d5
      %bbd5_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bbd5_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd5_0 = "braid.eq"(%bbd5_1, %bbd5_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bbd5_0)[^bba0, ^bbd7] : (i64) -> ()
    ^bbd7:  // 0x4010d7
      %bbd7_0 = "braid.get"() {reg = "zmm4.0"} : () -> i64
      %bbd7_1 = "braid.get"() {reg = "zmm4.1"} : () -> i64
      %bbd7_40 = "braid.get"() {reg = "zmm7.0"} : () -> i64
      %bbd7_41 = "braid.get"() {reg = "zmm7.1"} : () -> i64
      %bbd7_80 = "braid.lanes"(%bbd7_40, %bbd7_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bbd7_81 = "braid.lanes"(%bbd7_41, %bbd7_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bbd7_80) {reg = "zmm7.0"} : (i64) -> ()
      "braid.set"(%bbd7_81) {reg = "zmm7.1"} : (i64) -> ()
      "braid_cf.br"()[^bbdb] : () -> ()
    ^bbdb:  // 0x4010db
      %bbdb_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bbdb_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bbdb_40 = "braid.get"() {reg = "zmm5.0"} : () -> i64
      %bbdb_41 = "braid.get"() {reg = "zmm5.1"} : () -> i64
      %bbdb_80 = "braid.lanes"(%bbdb_40, %bbdb_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bbdb_81 = "braid.lanes"(%bbdb_41, %bbdb_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bbdb_80) {reg = "zmm5.0"} : (i64) -> ()
      "braid.set"(%bbdb_81) {reg = "zmm5.1"} : (i64) -> ()
      "braid_cf.br"()[^bbdf] : () -> ()
    ^bbdf:  // 0x4010df
      %bbdf_0 = "braid.get"() {reg = "zmm7.0"} : () -> i64
      %bbdf_1 = "braid.get"() {reg = "zmm7.1"} : () -> i64
      %bbdf_40 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbdf_41 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bbdf_48 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbdf_49 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbdf_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbdf_57 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbdf_64 = "braid.lshr"(%bbdf_1, %bbdf_48) : (i64, i64) -> i64
      %bbdf_65 = "braid.lshr"(%bbdf_0, %bbdf_49) : (i64, i64) -> i64
      %bbdf_72 = "braid.and"(%bbdf_64, %bbdf_41) : (i64, i64) -> i64
      %bbdf_73 = "braid.and"(%bbdf_65, %bbdf_41) : (i64, i64) -> i64
      %bbdf_80 = "braid.lshr"(%bbdf_1, %bbdf_56) : (i64, i64) -> i64
      %bbdf_81 = "braid.lshr"(%bbdf_0, %bbdf_57) : (i64, i64) -> i64
      %bbdf_88 = "braid.shl"(%bbdf_80, %bbdf_40) : (i64, i64) -> i64
      %bbdf_89 = "braid.shl"(%bbdf_81, %bbdf_40) : (i64, i64) -> i64
      %bbdf_96 = "braid.or"(%bbdf_72, %bbdf_88) : (i64, i64) -> i64
      %bbdf_97 = "braid.or"(%bbdf_73, %bbdf_89) : (i64, i64) -> i64
      "braid.set"(%bbdf_96) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bbdf_97) {reg = "zmm0.1"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x4010e4
      %bbe4_0 = "braid.get"() {reg = "zmm5.0"} : () -> i64
      %bbe4_1 = "braid.get"() {reg = "zmm5.1"} : () -> i64
      %bbe4_40 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbe4_41 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bbe4_48 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbe4_49 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbe4_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe4_57 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe4_64 = "braid.lshr"(%bbe4_0, %bbe4_48) : (i64, i64) -> i64
      %bbe4_65 = "braid.lshr"(%bbe4_1, %bbe4_49) : (i64, i64) -> i64
      %bbe4_72 = "braid.and"(%bbe4_64, %bbe4_41) : (i64, i64) -> i64
      %bbe4_73 = "braid.and"(%bbe4_65, %bbe4_41) : (i64, i64) -> i64
      %bbe4_80 = "braid.lshr"(%bbe4_0, %bbe4_56) : (i64, i64) -> i64
      %bbe4_81 = "braid.lshr"(%bbe4_1, %bbe4_57) : (i64, i64) -> i64
      %bbe4_88 = "braid.shl"(%bbe4_80, %bbe4_40) : (i64, i64) -> i64
      %bbe4_89 = "braid.shl"(%bbe4_81, %bbe4_40) : (i64, i64) -> i64
      %bbe4_96 = "braid.or"(%bbe4_72, %bbe4_88) : (i64, i64) -> i64
      %bbe4_97 = "braid.or"(%bbe4_73, %bbe4_89) : (i64, i64) -> i64
      "braid.set"(%bbe4_96) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bbe4_97) {reg = "zmm1.1"} : (i64) -> ()
      "braid_cf.br"()[^bbe9] : () -> ()
    ^bbe9:  // 0x4010e9
      %bbe9_0 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bbe9_1 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      "braid.set"(%bbe9_0) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bbe9_1) {reg = "zmm2.1"} : (i64) -> ()
      "braid_cf.br"()[^bbed] : () -> ()
    ^bbed:  // 0x4010ed
      %bbed_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bbed_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bbed_40 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bbed_41 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bbed_80 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbed_81 = "braid.const"() {value = -1 : i64} : () -> i64
      %bbed_88 = "braid.xor"(%bbed_40, %bbed_0) : (i64, i64) -> i64
      %bbed_89 = "braid.xor"(%bbed_41, %bbed_1) : (i64, i64) -> i64
      %bbed_96 = "braid.and"(%bbed_88, %bbed_80) : (i64, i64) -> i64
      %bbed_97 = "braid.and"(%bbed_89, %bbed_81) : (i64, i64) -> i64
      %bbed_104 = "braid.xor"(%bbed_40, %bbed_96) : (i64, i64) -> i64
      %bbed_105 = "braid.xor"(%bbed_41, %bbed_97) : (i64, i64) -> i64
      "braid.set"(%bbed_104) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bbed_105) {reg = "zmm2.1"} : (i64) -> ()
      "braid_cf.br"()[^bbf3] : () -> ()
    ^bbf3:  // 0x4010f3
      %bbf3_0 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bbf3_1 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bbf3_40 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bbf3_41 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bbf3_80 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf3_88 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf3_89 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf3_96 = "braid.const"() {value = 64 : i64} : () -> i64
      %bbf3_97 = "braid.const"() {value = 64 : i64} : () -> i64
      %bbf3_104 = "braid.lshr"(%bbf3_1, %bbf3_88) : (i64, i64) -> i64
      %bbf3_105 = "braid.lshr"(%bbf3_40, %bbf3_89) : (i64, i64) -> i64
      %bbf3_112 = "braid.shl"(%bbf3_40, %bbf3_96) : (i64, i64) -> i64
      %bbf3_113 = "braid.shl"(%bbf3_41, %bbf3_97) : (i64, i64) -> i64
      %bbf3_120 = "braid.or"(%bbf3_104, %bbf3_112) : (i64, i64) -> i64
      %bbf3_121 = "braid.or"(%bbf3_105, %bbf3_113) : (i64, i64) -> i64
      "braid.set"(%bbf3_120) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bbf3_121) {reg = "zmm1.1"} : (i64) -> ()
      "braid_cf.br"()[^bbf9] : () -> ()
    ^bbf9:  // 0x4010f9
      %bbf9_0 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bbf9_1 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bbf9_40 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbf9_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf9_57 = "braid.add"(%bbf9_40, %bbf9_56) : (i64, i64) -> i64
      "braid.store"(%bbf9_57, %bbf9_0) {bytes = 8 : i64} : (i64, i64) -> ()
      %bbf9_58 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbf9_59 = "braid.add"(%bbf9_40, %bbf9_58) : (i64, i64) -> i64
      "braid.store"(%bbf9_59, %bbf9_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbfd] : () -> ()
    ^bbfd:  // 0x4010fd
      %bbfd_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bbfd_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bbfd_41 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbfd_42 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbfd_40 = "braid.add"(%bbfd_41, %bbfd_42) : (i64, i64) -> i64
      %bbfd_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbfd_57 = "braid.add"(%bbfd_40, %bbfd_56) : (i64, i64) -> i64
      "braid.store"(%bbfd_57, %bbfd_0) {bytes = 8 : i64} : (i64, i64) -> ()
      %bbfd_58 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbfd_59 = "braid.add"(%bbfd_40, %bbfd_58) : (i64, i64) -> i64
      "braid.store"(%bbfd_59, %bbfd_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb102] : () -> ()
    ^bb102:  // 0x401102
      %bb102_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb102_1 = "braid.load"(%bb102_0) {bytes = 8 : i64} : (i64) -> i64
      %bb102_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb102_3 = "braid.add"(%bb102_0, %bb102_2) : (i64, i64) -> i64
      "braid.set"(%bb102_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb102_1) : (i64) -> ()
  }) {sym_name = "sha256_compress_ni", entry = 4198400 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
