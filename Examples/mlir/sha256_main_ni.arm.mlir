"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x100bc
      %bb0_0 = "braid.get"() {reg = "x0"} : () -> i64
      %bb0_21 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb0_22 = "braid.add"(%bb0_0, %bb0_21) : (i64, i64) -> i64
      %bb0_23 = "braid.load"(%bb0_0) {bytes = 8 : i64} : (i64) -> i64
      %bb0_25 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_26 = "braid.add"(%bb0_0, %bb0_25) : (i64, i64) -> i64
      %bb0_24 = "braid.load"(%bb0_26) {bytes = 8 : i64} : (i64) -> i64
      %bb0_27 = "braid.load"(%bb0_22) {bytes = 8 : i64} : (i64) -> i64
      %bb0_29 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_30 = "braid.add"(%bb0_22, %bb0_29) : (i64, i64) -> i64
      %bb0_28 = "braid.load"(%bb0_30) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb0_23) {reg = "v1.lo"} : (i64) -> ()
      "braid.set"(%bb0_24) {reg = "v1.hi"} : (i64) -> ()
      "braid.set"(%bb0_27) {reg = "v0.lo"} : (i64) -> ()
      "braid.set"(%bb0_28) {reg = "v0.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x100c0
      %bb4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_12 = "braid.or"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x100c4
      %bb8_0 = "braid.get"() {reg = "x1"} : () -> i64
      %bb8_21 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb8_22 = "braid.add"(%bb8_0, %bb8_21) : (i64, i64) -> i64
      %bb8_23 = "braid.load"(%bb8_0) {bytes = 8 : i64} : (i64) -> i64
      %bb8_25 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8_26 = "braid.add"(%bb8_0, %bb8_25) : (i64, i64) -> i64
      %bb8_24 = "braid.load"(%bb8_26) {bytes = 8 : i64} : (i64) -> i64
      %bb8_27 = "braid.load"(%bb8_22) {bytes = 8 : i64} : (i64) -> i64
      %bb8_29 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb8_30 = "braid.add"(%bb8_22, %bb8_29) : (i64, i64) -> i64
      %bb8_28 = "braid.load"(%bb8_30) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb8_23) {reg = "v16.lo"} : (i64) -> ()
      "braid.set"(%bb8_24) {reg = "v16.hi"} : (i64) -> ()
      "braid.set"(%bb8_27) {reg = "v18.lo"} : (i64) -> ()
      "braid.set"(%bb8_28) {reg = "v18.hi"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x100c8
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x100cc
      %bb10_0 = "braid.const"() {value = 131624 : i64} : () -> i64
      "braid.set"(%bb10_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x100d0
      %bb14_1 = "braid.get"() {reg = "x1"} : () -> i64
      %bb14_6 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb14_0 = "braid.add"(%bb14_1, %bb14_6) : (i64, i64) -> i64
      %bb14_21 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb14_22 = "braid.add"(%bb14_0, %bb14_21) : (i64, i64) -> i64
      %bb14_23 = "braid.load"(%bb14_0) {bytes = 8 : i64} : (i64) -> i64
      %bb14_25 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb14_26 = "braid.add"(%bb14_0, %bb14_25) : (i64, i64) -> i64
      %bb14_24 = "braid.load"(%bb14_26) {bytes = 8 : i64} : (i64) -> i64
      %bb14_27 = "braid.load"(%bb14_22) {bytes = 8 : i64} : (i64) -> i64
      %bb14_29 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb14_30 = "braid.add"(%bb14_22, %bb14_29) : (i64, i64) -> i64
      %bb14_28 = "braid.load"(%bb14_30) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb14_23) {reg = "v17.lo"} : (i64) -> ()
      "braid.set"(%bb14_24) {reg = "v17.hi"} : (i64) -> ()
      "braid.set"(%bb14_27) {reg = "v2.lo"} : (i64) -> ()
      "braid.set"(%bb14_28) {reg = "v2.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x100d4
      %bb18_0 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb18_1 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb18_2 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb18_3 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb18_10 = "braid.or"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      %bb18_20 = "braid.or"(%bb18_1, %bb18_3) : (i64, i64) -> i64
      "braid.set"(%bb18_10) {reg = "v4.lo"} : (i64) -> ()
      "braid.set"(%bb18_20) {reg = "v4.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x100d8
      %bb1c_0 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bb1c_2 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bb1c_3 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bb1c_10 = "braid.or"(%bb1c_0, %bb1c_2) : (i64, i64) -> i64
      %bb1c_20 = "braid.or"(%bb1c_1, %bb1c_3) : (i64, i64) -> i64
      "braid.set"(%bb1c_10) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb1c_20) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x100dc
      %bb20_0 = "braid.get"() {reg = "v18.lo"} : () -> i64
      %bb20_1 = "braid.get"() {reg = "v18.hi"} : () -> i64
      %bb20_2 = "braid.get"() {reg = "v18.lo"} : () -> i64
      %bb20_3 = "braid.get"() {reg = "v18.hi"} : () -> i64
      %bb20_10 = "braid.or"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      %bb20_20 = "braid.or"(%bb20_1, %bb20_3) : (i64, i64) -> i64
      "braid.set"(%bb20_10) {reg = "v5.lo"} : (i64) -> ()
      "braid.set"(%bb20_20) {reg = "v5.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x100e0
      %bb24_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb24_6 = "braid.get"() {reg = "x9"} : () -> i64
      %bb24_0 = "braid.add"(%bb24_1, %bb24_6) : (i64, i64) -> i64
      %bb24_30 = "braid.load"(%bb24_0) {bytes = 8 : i64} : (i64) -> i64
      %bb24_32 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb24_33 = "braid.add"(%bb24_0, %bb24_32) : (i64, i64) -> i64
      %bb24_31 = "braid.load"(%bb24_33) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb24_30) {reg = "v6.lo"} : (i64) -> ()
      "braid.set"(%bb24_31) {reg = "v6.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x100e4
      %bb28_0 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb28_2 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb28_3 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb28_10 = "braid.or"(%bb28_0, %bb28_2) : (i64, i64) -> i64
      %bb28_20 = "braid.or"(%bb28_1, %bb28_3) : (i64, i64) -> i64
      "braid.set"(%bb28_10) {reg = "v19.lo"} : (i64) -> ()
      "braid.set"(%bb28_20) {reg = "v19.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x100e8
      %bb2c_0 = "braid.get"() {reg = "v17.lo"} : () -> i64
      %bb2c_1 = "braid.get"() {reg = "v17.hi"} : () -> i64
      %bb2c_2 = "braid.get"() {reg = "v17.lo"} : () -> i64
      %bb2c_3 = "braid.get"() {reg = "v17.hi"} : () -> i64
      %bb2c_10 = "braid.or"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      %bb2c_20 = "braid.or"(%bb2c_1, %bb2c_3) : (i64, i64) -> i64
      "braid.set"(%bb2c_10) {reg = "v7.lo"} : (i64) -> ()
      "braid.set"(%bb2c_20) {reg = "v7.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x100ec
      %bb30_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb30_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb30_3 = "braid.add"(%bb30_0, %bb30_2) : (i64, i64) -> i64
      "braid.set"(%bb30_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x100f0
      %bb34_0 = "braid.get"() {reg = "v6.lo"} : () -> i64
      %bb34_1 = "braid.get"() {reg = "v6.hi"} : () -> i64
      %bb34_2 = "braid.get"() {reg = "v16.lo"} : () -> i64
      %bb34_3 = "braid.get"() {reg = "v16.hi"} : () -> i64
      %bb34_10 = "braid.lanes"(%bb34_0, %bb34_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb34_20 = "braid.lanes"(%bb34_1, %bb34_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb34_10) {reg = "v18.lo"} : (i64) -> ()
      "braid.set"(%bb34_20) {reg = "v18.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x100f4
      %bb38_0 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb38_1 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb38_2 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb38_3 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb38_10 = "braid.or"(%bb38_0, %bb38_2) : (i64, i64) -> i64
      %bb38_20 = "braid.or"(%bb38_1, %bb38_3) : (i64, i64) -> i64
      "braid.set"(%bb38_10) {reg = "v6.lo"} : (i64) -> ()
      "braid.set"(%bb38_20) {reg = "v6.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x100f8
      %bb3c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb3c_2 = "braid.const"() {value = 192 : i64} : () -> i64
      %bb3c_3 = "braid.sub"(%bb3c_0, %bb3c_2) : (i64, i64) -> i64
      %bb3c_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb3c_4 = "braid.slt"(%bb3c_3, %bb3c_8) : (i64, i64) -> i64
      %bb3c_5 = "braid.eq"(%bb3c_0, %bb3c_2) : (i64, i64) -> i64
      %bb3c_6 = "braid.ule"(%bb3c_2, %bb3c_0) : (i64, i64) -> i64
      %bb3c_9 = "braid.xor"(%bb3c_0, %bb3c_2) : (i64, i64) -> i64
      %bb3c_10 = "braid.xor"(%bb3c_0, %bb3c_3) : (i64, i64) -> i64
      %bb3c_11 = "braid.and"(%bb3c_9, %bb3c_10) : (i64, i64) -> i64
      %bb3c_7 = "braid.slt"(%bb3c_11, %bb3c_8) : (i64, i64) -> i64
      "braid.setf"(%bb3c_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb3c_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb3c_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb3c_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x100fc
      %bb40_0 = "braid.get"() {reg = "v16.lo"} : () -> i64
      %bb40_1 = "braid.get"() {reg = "v16.hi"} : () -> i64
      %bb40_2 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb40_10 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb40_11 = "braid.const"() {value = 144115183814443007 : i64} : () -> i64
      %bb40_12 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb40_13 = "braid.const"() {value = -144115183814443008 : i64} : () -> i64
      %bb40_14 = "braid.const"() {value = 18 : i64} : () -> i64
      %bb40_15 = "braid.const"() {value = 70364449226751 : i64} : () -> i64
      %bb40_16 = "braid.const"() {value = 14 : i64} : () -> i64
      %bb40_17 = "braid.const"() {value = -70364449226752 : i64} : () -> i64
      %bb40_18 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb40_19 = "braid.const"() {value = 2305843005455597567 : i64} : () -> i64
      %bb40_20 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb40_21 = "braid.lshr"(%bb40_0, %bb40_20) : (i64, i64) -> i64
      %bb40_22 = "braid.shl"(%bb40_1, %bb40_20) : (i64, i64) -> i64
      %bb40_23 = "braid.or"(%bb40_21, %bb40_22) : (i64, i64) -> i64
      %bb40_30 = "braid.lshr"(%bb40_23, %bb40_10) : (i64, i64) -> i64
      %bb40_31 = "braid.and"(%bb40_30, %bb40_11) : (i64, i64) -> i64
      %bb40_32 = "braid.shl"(%bb40_23, %bb40_12) : (i64, i64) -> i64
      %bb40_33 = "braid.and"(%bb40_32, %bb40_13) : (i64, i64) -> i64
      %bb40_34 = "braid.or"(%bb40_31, %bb40_33) : (i64, i64) -> i64
      %bb40_35 = "braid.lshr"(%bb40_23, %bb40_14) : (i64, i64) -> i64
      %bb40_36 = "braid.and"(%bb40_35, %bb40_15) : (i64, i64) -> i64
      %bb40_37 = "braid.shl"(%bb40_23, %bb40_16) : (i64, i64) -> i64
      %bb40_38 = "braid.and"(%bb40_37, %bb40_17) : (i64, i64) -> i64
      %bb40_39 = "braid.or"(%bb40_36, %bb40_38) : (i64, i64) -> i64
      %bb40_40 = "braid.lshr"(%bb40_23, %bb40_18) : (i64, i64) -> i64
      %bb40_41 = "braid.and"(%bb40_40, %bb40_19) : (i64, i64) -> i64
      %bb40_42 = "braid.xor"(%bb40_34, %bb40_39) : (i64, i64) -> i64
      %bb40_43 = "braid.xor"(%bb40_42, %bb40_41) : (i64, i64) -> i64
      %bb40_200 = "braid.lanes"(%bb40_0, %bb40_43) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb40_50 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb40_51 = "braid.lshr"(%bb40_1, %bb40_50) : (i64, i64) -> i64
      %bb40_52 = "braid.shl"(%bb40_2, %bb40_50) : (i64, i64) -> i64
      %bb40_53 = "braid.or"(%bb40_51, %bb40_52) : (i64, i64) -> i64
      %bb40_60 = "braid.lshr"(%bb40_53, %bb40_10) : (i64, i64) -> i64
      %bb40_61 = "braid.and"(%bb40_60, %bb40_11) : (i64, i64) -> i64
      %bb40_62 = "braid.shl"(%bb40_53, %bb40_12) : (i64, i64) -> i64
      %bb40_63 = "braid.and"(%bb40_62, %bb40_13) : (i64, i64) -> i64
      %bb40_64 = "braid.or"(%bb40_61, %bb40_63) : (i64, i64) -> i64
      %bb40_65 = "braid.lshr"(%bb40_53, %bb40_14) : (i64, i64) -> i64
      %bb40_66 = "braid.and"(%bb40_65, %bb40_15) : (i64, i64) -> i64
      %bb40_67 = "braid.shl"(%bb40_53, %bb40_16) : (i64, i64) -> i64
      %bb40_68 = "braid.and"(%bb40_67, %bb40_17) : (i64, i64) -> i64
      %bb40_69 = "braid.or"(%bb40_66, %bb40_68) : (i64, i64) -> i64
      %bb40_70 = "braid.lshr"(%bb40_53, %bb40_18) : (i64, i64) -> i64
      %bb40_71 = "braid.and"(%bb40_70, %bb40_19) : (i64, i64) -> i64
      %bb40_72 = "braid.xor"(%bb40_64, %bb40_69) : (i64, i64) -> i64
      %bb40_73 = "braid.xor"(%bb40_72, %bb40_71) : (i64, i64) -> i64
      %bb40_201 = "braid.lanes"(%bb40_1, %bb40_73) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb40_200) {reg = "v16.lo"} : (i64) -> ()
      "braid.set"(%bb40_201) {reg = "v16.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x10100
      %bb44_0 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb44_1 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb44_2 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb44_3 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb44_4 = "braid.get"() {reg = "v18.lo"} : () -> i64
      %bb44_5 = "braid.get"() {reg = "v18.hi"} : () -> i64
      %bb44_10 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb44_11 = "braid.const"() {value = 6 : i64} : () -> i64
      %bb44_12 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb44_13 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb44_14 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb44_15 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb44_16 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb44_17 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bb44_20 = "braid.and"(%bb44_0, %bb44_17) : (i64, i64) -> i64
      %bb44_21 = "braid.lshr"(%bb44_0, %bb44_10) : (i64, i64) -> i64
      %bb44_22 = "braid.lshr"(%bb44_1, %bb44_10) : (i64, i64) -> i64
      %bb44_23 = "braid.and"(%bb44_2, %bb44_17) : (i64, i64) -> i64
      %bb44_24 = "braid.lshr"(%bb44_2, %bb44_10) : (i64, i64) -> i64
      %bb44_25 = "braid.lshr"(%bb44_3, %bb44_10) : (i64, i64) -> i64
      %bb44_26 = "braid.lshr"(%bb44_4, %bb44_10) : (i64, i64) -> i64
      %bb44_27 = "braid.lshr"(%bb44_5, %bb44_10) : (i64, i64) -> i64
      %bb44_30 = "braid.shl"(%bb44_23, %bb44_10) : (i64, i64) -> i64
      %bb44_31 = "braid.or"(%bb44_23, %bb44_30) : (i64, i64) -> i64
      %bb44_32 = "braid.lshr"(%bb44_31, %bb44_11) : (i64, i64) -> i64
      %bb44_33 = "braid.lshr"(%bb44_31, %bb44_12) : (i64, i64) -> i64
      %bb44_34 = "braid.lshr"(%bb44_31, %bb44_13) : (i64, i64) -> i64
      %bb44_35 = "braid.xor"(%bb44_32, %bb44_33) : (i64, i64) -> i64
      %bb44_36 = "braid.xor"(%bb44_35, %bb44_34) : (i64, i64) -> i64
      %bb44_37 = "braid.xor"(%bb44_24, %bb44_3) : (i64, i64) -> i64
      %bb44_38 = "braid.and"(%bb44_23, %bb44_37) : (i64, i64) -> i64
      %bb44_39 = "braid.xor"(%bb44_3, %bb44_38) : (i64, i64) -> i64
      %bb44_40 = "braid.add"(%bb44_39, %bb44_36) : (i64, i64) -> i64
      %bb44_41 = "braid.add"(%bb44_40, %bb44_4) : (i64, i64) -> i64
      %bb44_42 = "braid.add"(%bb44_41, %bb44_25) : (i64, i64) -> i64
      %bb44_43 = "braid.shl"(%bb44_20, %bb44_10) : (i64, i64) -> i64
      %bb44_44 = "braid.or"(%bb44_20, %bb44_43) : (i64, i64) -> i64
      %bb44_45 = "braid.lshr"(%bb44_44, %bb44_14) : (i64, i64) -> i64
      %bb44_46 = "braid.lshr"(%bb44_44, %bb44_15) : (i64, i64) -> i64
      %bb44_47 = "braid.lshr"(%bb44_44, %bb44_16) : (i64, i64) -> i64
      %bb44_48 = "braid.xor"(%bb44_45, %bb44_46) : (i64, i64) -> i64
      %bb44_49 = "braid.xor"(%bb44_48, %bb44_47) : (i64, i64) -> i64
      %bb44_50 = "braid.xor"(%bb44_21, %bb44_1) : (i64, i64) -> i64
      %bb44_51 = "braid.and"(%bb44_20, %bb44_50) : (i64, i64) -> i64
      %bb44_52 = "braid.and"(%bb44_21, %bb44_1) : (i64, i64) -> i64
      %bb44_53 = "braid.xor"(%bb44_51, %bb44_52) : (i64, i64) -> i64
      %bb44_54 = "braid.add"(%bb44_42, %bb44_53) : (i64, i64) -> i64
      %bb44_55 = "braid.add"(%bb44_54, %bb44_49) : (i64, i64) -> i64
      %bb44_57 = "braid.and"(%bb44_55, %bb44_17) : (i64, i64) -> i64
      %bb44_56 = "braid.add"(%bb44_42, %bb44_22) : (i64, i64) -> i64
      %bb44_58 = "braid.and"(%bb44_56, %bb44_17) : (i64, i64) -> i64
      %bb44_60 = "braid.shl"(%bb44_58, %bb44_10) : (i64, i64) -> i64
      %bb44_61 = "braid.or"(%bb44_58, %bb44_60) : (i64, i64) -> i64
      %bb44_62 = "braid.lshr"(%bb44_61, %bb44_11) : (i64, i64) -> i64
      %bb44_63 = "braid.lshr"(%bb44_61, %bb44_12) : (i64, i64) -> i64
      %bb44_64 = "braid.lshr"(%bb44_61, %bb44_13) : (i64, i64) -> i64
      %bb44_65 = "braid.xor"(%bb44_62, %bb44_63) : (i64, i64) -> i64
      %bb44_66 = "braid.xor"(%bb44_65, %bb44_64) : (i64, i64) -> i64
      %bb44_67 = "braid.xor"(%bb44_23, %bb44_24) : (i64, i64) -> i64
      %bb44_68 = "braid.and"(%bb44_58, %bb44_67) : (i64, i64) -> i64
      %bb44_69 = "braid.xor"(%bb44_24, %bb44_68) : (i64, i64) -> i64
      %bb44_70 = "braid.add"(%bb44_69, %bb44_66) : (i64, i64) -> i64
      %bb44_71 = "braid.add"(%bb44_70, %bb44_26) : (i64, i64) -> i64
      %bb44_72 = "braid.add"(%bb44_71, %bb44_3) : (i64, i64) -> i64
      %bb44_73 = "braid.shl"(%bb44_57, %bb44_10) : (i64, i64) -> i64
      %bb44_74 = "braid.or"(%bb44_57, %bb44_73) : (i64, i64) -> i64
      %bb44_75 = "braid.lshr"(%bb44_74, %bb44_14) : (i64, i64) -> i64
      %bb44_76 = "braid.lshr"(%bb44_74, %bb44_15) : (i64, i64) -> i64
      %bb44_77 = "braid.lshr"(%bb44_74, %bb44_16) : (i64, i64) -> i64
      %bb44_78 = "braid.xor"(%bb44_75, %bb44_76) : (i64, i64) -> i64
      %bb44_79 = "braid.xor"(%bb44_78, %bb44_77) : (i64, i64) -> i64
      %bb44_80 = "braid.xor"(%bb44_20, %bb44_21) : (i64, i64) -> i64
      %bb44_81 = "braid.and"(%bb44_57, %bb44_80) : (i64, i64) -> i64
      %bb44_82 = "braid.and"(%bb44_20, %bb44_21) : (i64, i64) -> i64
      %bb44_83 = "braid.xor"(%bb44_81, %bb44_82) : (i64, i64) -> i64
      %bb44_84 = "braid.add"(%bb44_72, %bb44_83) : (i64, i64) -> i64
      %bb44_85 = "braid.add"(%bb44_84, %bb44_79) : (i64, i64) -> i64
      %bb44_87 = "braid.and"(%bb44_85, %bb44_17) : (i64, i64) -> i64
      %bb44_86 = "braid.add"(%bb44_72, %bb44_1) : (i64, i64) -> i64
      %bb44_88 = "braid.and"(%bb44_86, %bb44_17) : (i64, i64) -> i64
      %bb44_90 = "braid.shl"(%bb44_88, %bb44_10) : (i64, i64) -> i64
      %bb44_91 = "braid.or"(%bb44_88, %bb44_90) : (i64, i64) -> i64
      %bb44_92 = "braid.lshr"(%bb44_91, %bb44_11) : (i64, i64) -> i64
      %bb44_93 = "braid.lshr"(%bb44_91, %bb44_12) : (i64, i64) -> i64
      %bb44_94 = "braid.lshr"(%bb44_91, %bb44_13) : (i64, i64) -> i64
      %bb44_95 = "braid.xor"(%bb44_92, %bb44_93) : (i64, i64) -> i64
      %bb44_96 = "braid.xor"(%bb44_95, %bb44_94) : (i64, i64) -> i64
      %bb44_97 = "braid.xor"(%bb44_58, %bb44_23) : (i64, i64) -> i64
      %bb44_98 = "braid.and"(%bb44_88, %bb44_97) : (i64, i64) -> i64
      %bb44_99 = "braid.xor"(%bb44_23, %bb44_98) : (i64, i64) -> i64
      %bb44_100 = "braid.add"(%bb44_99, %bb44_96) : (i64, i64) -> i64
      %bb44_101 = "braid.add"(%bb44_100, %bb44_5) : (i64, i64) -> i64
      %bb44_102 = "braid.add"(%bb44_101, %bb44_24) : (i64, i64) -> i64
      %bb44_103 = "braid.shl"(%bb44_87, %bb44_10) : (i64, i64) -> i64
      %bb44_104 = "braid.or"(%bb44_87, %bb44_103) : (i64, i64) -> i64
      %bb44_105 = "braid.lshr"(%bb44_104, %bb44_14) : (i64, i64) -> i64
      %bb44_106 = "braid.lshr"(%bb44_104, %bb44_15) : (i64, i64) -> i64
      %bb44_107 = "braid.lshr"(%bb44_104, %bb44_16) : (i64, i64) -> i64
      %bb44_108 = "braid.xor"(%bb44_105, %bb44_106) : (i64, i64) -> i64
      %bb44_109 = "braid.xor"(%bb44_108, %bb44_107) : (i64, i64) -> i64
      %bb44_110 = "braid.xor"(%bb44_57, %bb44_20) : (i64, i64) -> i64
      %bb44_111 = "braid.and"(%bb44_87, %bb44_110) : (i64, i64) -> i64
      %bb44_112 = "braid.and"(%bb44_57, %bb44_20) : (i64, i64) -> i64
      %bb44_113 = "braid.xor"(%bb44_111, %bb44_112) : (i64, i64) -> i64
      %bb44_114 = "braid.add"(%bb44_102, %bb44_113) : (i64, i64) -> i64
      %bb44_115 = "braid.add"(%bb44_114, %bb44_109) : (i64, i64) -> i64
      %bb44_117 = "braid.and"(%bb44_115, %bb44_17) : (i64, i64) -> i64
      %bb44_116 = "braid.add"(%bb44_102, %bb44_21) : (i64, i64) -> i64
      %bb44_118 = "braid.and"(%bb44_116, %bb44_17) : (i64, i64) -> i64
      %bb44_120 = "braid.shl"(%bb44_118, %bb44_10) : (i64, i64) -> i64
      %bb44_121 = "braid.or"(%bb44_118, %bb44_120) : (i64, i64) -> i64
      %bb44_122 = "braid.lshr"(%bb44_121, %bb44_11) : (i64, i64) -> i64
      %bb44_123 = "braid.lshr"(%bb44_121, %bb44_12) : (i64, i64) -> i64
      %bb44_124 = "braid.lshr"(%bb44_121, %bb44_13) : (i64, i64) -> i64
      %bb44_125 = "braid.xor"(%bb44_122, %bb44_123) : (i64, i64) -> i64
      %bb44_126 = "braid.xor"(%bb44_125, %bb44_124) : (i64, i64) -> i64
      %bb44_127 = "braid.xor"(%bb44_88, %bb44_58) : (i64, i64) -> i64
      %bb44_128 = "braid.and"(%bb44_118, %bb44_127) : (i64, i64) -> i64
      %bb44_129 = "braid.xor"(%bb44_58, %bb44_128) : (i64, i64) -> i64
      %bb44_130 = "braid.add"(%bb44_129, %bb44_126) : (i64, i64) -> i64
      %bb44_131 = "braid.add"(%bb44_130, %bb44_27) : (i64, i64) -> i64
      %bb44_132 = "braid.add"(%bb44_131, %bb44_23) : (i64, i64) -> i64
      %bb44_133 = "braid.shl"(%bb44_117, %bb44_10) : (i64, i64) -> i64
      %bb44_134 = "braid.or"(%bb44_117, %bb44_133) : (i64, i64) -> i64
      %bb44_135 = "braid.lshr"(%bb44_134, %bb44_14) : (i64, i64) -> i64
      %bb44_136 = "braid.lshr"(%bb44_134, %bb44_15) : (i64, i64) -> i64
      %bb44_137 = "braid.lshr"(%bb44_134, %bb44_16) : (i64, i64) -> i64
      %bb44_138 = "braid.xor"(%bb44_135, %bb44_136) : (i64, i64) -> i64
      %bb44_139 = "braid.xor"(%bb44_138, %bb44_137) : (i64, i64) -> i64
      %bb44_140 = "braid.xor"(%bb44_87, %bb44_57) : (i64, i64) -> i64
      %bb44_141 = "braid.and"(%bb44_117, %bb44_140) : (i64, i64) -> i64
      %bb44_142 = "braid.and"(%bb44_87, %bb44_57) : (i64, i64) -> i64
      %bb44_143 = "braid.xor"(%bb44_141, %bb44_142) : (i64, i64) -> i64
      %bb44_144 = "braid.add"(%bb44_132, %bb44_143) : (i64, i64) -> i64
      %bb44_145 = "braid.add"(%bb44_144, %bb44_139) : (i64, i64) -> i64
      %bb44_147 = "braid.and"(%bb44_145, %bb44_17) : (i64, i64) -> i64
      %bb44_150 = "braid.shl"(%bb44_117, %bb44_10) : (i64, i64) -> i64
      %bb44_200 = "braid.or"(%bb44_147, %bb44_150) : (i64, i64) -> i64
      %bb44_151 = "braid.shl"(%bb44_57, %bb44_10) : (i64, i64) -> i64
      %bb44_201 = "braid.or"(%bb44_87, %bb44_151) : (i64, i64) -> i64
      "braid.set"(%bb44_200) {reg = "v4.lo"} : (i64) -> ()
      "braid.set"(%bb44_201) {reg = "v4.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x10104
      %bb48_0 = "braid.get"() {reg = "v19.lo"} : () -> i64
      %bb48_1 = "braid.get"() {reg = "v19.hi"} : () -> i64
      %bb48_2 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb48_3 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb48_4 = "braid.get"() {reg = "v18.lo"} : () -> i64
      %bb48_5 = "braid.get"() {reg = "v18.hi"} : () -> i64
      %bb48_10 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb48_11 = "braid.const"() {value = 6 : i64} : () -> i64
      %bb48_12 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb48_13 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb48_14 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb48_15 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb48_16 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb48_17 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bb48_20 = "braid.and"(%bb48_0, %bb48_17) : (i64, i64) -> i64
      %bb48_21 = "braid.lshr"(%bb48_0, %bb48_10) : (i64, i64) -> i64
      %bb48_22 = "braid.lshr"(%bb48_1, %bb48_10) : (i64, i64) -> i64
      %bb48_23 = "braid.and"(%bb48_2, %bb48_17) : (i64, i64) -> i64
      %bb48_24 = "braid.lshr"(%bb48_2, %bb48_10) : (i64, i64) -> i64
      %bb48_25 = "braid.lshr"(%bb48_3, %bb48_10) : (i64, i64) -> i64
      %bb48_26 = "braid.lshr"(%bb48_4, %bb48_10) : (i64, i64) -> i64
      %bb48_27 = "braid.lshr"(%bb48_5, %bb48_10) : (i64, i64) -> i64
      %bb48_30 = "braid.shl"(%bb48_23, %bb48_10) : (i64, i64) -> i64
      %bb48_31 = "braid.or"(%bb48_23, %bb48_30) : (i64, i64) -> i64
      %bb48_32 = "braid.lshr"(%bb48_31, %bb48_11) : (i64, i64) -> i64
      %bb48_33 = "braid.lshr"(%bb48_31, %bb48_12) : (i64, i64) -> i64
      %bb48_34 = "braid.lshr"(%bb48_31, %bb48_13) : (i64, i64) -> i64
      %bb48_35 = "braid.xor"(%bb48_32, %bb48_33) : (i64, i64) -> i64
      %bb48_36 = "braid.xor"(%bb48_35, %bb48_34) : (i64, i64) -> i64
      %bb48_37 = "braid.xor"(%bb48_24, %bb48_3) : (i64, i64) -> i64
      %bb48_38 = "braid.and"(%bb48_23, %bb48_37) : (i64, i64) -> i64
      %bb48_39 = "braid.xor"(%bb48_3, %bb48_38) : (i64, i64) -> i64
      %bb48_40 = "braid.add"(%bb48_39, %bb48_36) : (i64, i64) -> i64
      %bb48_41 = "braid.add"(%bb48_40, %bb48_4) : (i64, i64) -> i64
      %bb48_42 = "braid.add"(%bb48_41, %bb48_25) : (i64, i64) -> i64
      %bb48_43 = "braid.shl"(%bb48_20, %bb48_10) : (i64, i64) -> i64
      %bb48_44 = "braid.or"(%bb48_20, %bb48_43) : (i64, i64) -> i64
      %bb48_45 = "braid.lshr"(%bb48_44, %bb48_14) : (i64, i64) -> i64
      %bb48_46 = "braid.lshr"(%bb48_44, %bb48_15) : (i64, i64) -> i64
      %bb48_47 = "braid.lshr"(%bb48_44, %bb48_16) : (i64, i64) -> i64
      %bb48_48 = "braid.xor"(%bb48_45, %bb48_46) : (i64, i64) -> i64
      %bb48_49 = "braid.xor"(%bb48_48, %bb48_47) : (i64, i64) -> i64
      %bb48_50 = "braid.xor"(%bb48_21, %bb48_1) : (i64, i64) -> i64
      %bb48_51 = "braid.and"(%bb48_20, %bb48_50) : (i64, i64) -> i64
      %bb48_52 = "braid.and"(%bb48_21, %bb48_1) : (i64, i64) -> i64
      %bb48_53 = "braid.xor"(%bb48_51, %bb48_52) : (i64, i64) -> i64
      %bb48_54 = "braid.add"(%bb48_42, %bb48_53) : (i64, i64) -> i64
      %bb48_55 = "braid.add"(%bb48_54, %bb48_49) : (i64, i64) -> i64
      %bb48_57 = "braid.and"(%bb48_55, %bb48_17) : (i64, i64) -> i64
      %bb48_56 = "braid.add"(%bb48_42, %bb48_22) : (i64, i64) -> i64
      %bb48_58 = "braid.and"(%bb48_56, %bb48_17) : (i64, i64) -> i64
      %bb48_60 = "braid.shl"(%bb48_58, %bb48_10) : (i64, i64) -> i64
      %bb48_61 = "braid.or"(%bb48_58, %bb48_60) : (i64, i64) -> i64
      %bb48_62 = "braid.lshr"(%bb48_61, %bb48_11) : (i64, i64) -> i64
      %bb48_63 = "braid.lshr"(%bb48_61, %bb48_12) : (i64, i64) -> i64
      %bb48_64 = "braid.lshr"(%bb48_61, %bb48_13) : (i64, i64) -> i64
      %bb48_65 = "braid.xor"(%bb48_62, %bb48_63) : (i64, i64) -> i64
      %bb48_66 = "braid.xor"(%bb48_65, %bb48_64) : (i64, i64) -> i64
      %bb48_67 = "braid.xor"(%bb48_23, %bb48_24) : (i64, i64) -> i64
      %bb48_68 = "braid.and"(%bb48_58, %bb48_67) : (i64, i64) -> i64
      %bb48_69 = "braid.xor"(%bb48_24, %bb48_68) : (i64, i64) -> i64
      %bb48_70 = "braid.add"(%bb48_69, %bb48_66) : (i64, i64) -> i64
      %bb48_71 = "braid.add"(%bb48_70, %bb48_26) : (i64, i64) -> i64
      %bb48_72 = "braid.add"(%bb48_71, %bb48_3) : (i64, i64) -> i64
      %bb48_73 = "braid.shl"(%bb48_57, %bb48_10) : (i64, i64) -> i64
      %bb48_74 = "braid.or"(%bb48_57, %bb48_73) : (i64, i64) -> i64
      %bb48_75 = "braid.lshr"(%bb48_74, %bb48_14) : (i64, i64) -> i64
      %bb48_76 = "braid.lshr"(%bb48_74, %bb48_15) : (i64, i64) -> i64
      %bb48_77 = "braid.lshr"(%bb48_74, %bb48_16) : (i64, i64) -> i64
      %bb48_78 = "braid.xor"(%bb48_75, %bb48_76) : (i64, i64) -> i64
      %bb48_79 = "braid.xor"(%bb48_78, %bb48_77) : (i64, i64) -> i64
      %bb48_80 = "braid.xor"(%bb48_20, %bb48_21) : (i64, i64) -> i64
      %bb48_81 = "braid.and"(%bb48_57, %bb48_80) : (i64, i64) -> i64
      %bb48_82 = "braid.and"(%bb48_20, %bb48_21) : (i64, i64) -> i64
      %bb48_83 = "braid.xor"(%bb48_81, %bb48_82) : (i64, i64) -> i64
      %bb48_84 = "braid.add"(%bb48_72, %bb48_83) : (i64, i64) -> i64
      %bb48_85 = "braid.add"(%bb48_84, %bb48_79) : (i64, i64) -> i64
      %bb48_87 = "braid.and"(%bb48_85, %bb48_17) : (i64, i64) -> i64
      %bb48_86 = "braid.add"(%bb48_72, %bb48_1) : (i64, i64) -> i64
      %bb48_88 = "braid.and"(%bb48_86, %bb48_17) : (i64, i64) -> i64
      %bb48_90 = "braid.shl"(%bb48_88, %bb48_10) : (i64, i64) -> i64
      %bb48_91 = "braid.or"(%bb48_88, %bb48_90) : (i64, i64) -> i64
      %bb48_92 = "braid.lshr"(%bb48_91, %bb48_11) : (i64, i64) -> i64
      %bb48_93 = "braid.lshr"(%bb48_91, %bb48_12) : (i64, i64) -> i64
      %bb48_94 = "braid.lshr"(%bb48_91, %bb48_13) : (i64, i64) -> i64
      %bb48_95 = "braid.xor"(%bb48_92, %bb48_93) : (i64, i64) -> i64
      %bb48_96 = "braid.xor"(%bb48_95, %bb48_94) : (i64, i64) -> i64
      %bb48_97 = "braid.xor"(%bb48_58, %bb48_23) : (i64, i64) -> i64
      %bb48_98 = "braid.and"(%bb48_88, %bb48_97) : (i64, i64) -> i64
      %bb48_99 = "braid.xor"(%bb48_23, %bb48_98) : (i64, i64) -> i64
      %bb48_100 = "braid.add"(%bb48_99, %bb48_96) : (i64, i64) -> i64
      %bb48_101 = "braid.add"(%bb48_100, %bb48_5) : (i64, i64) -> i64
      %bb48_102 = "braid.add"(%bb48_101, %bb48_24) : (i64, i64) -> i64
      %bb48_103 = "braid.shl"(%bb48_87, %bb48_10) : (i64, i64) -> i64
      %bb48_104 = "braid.or"(%bb48_87, %bb48_103) : (i64, i64) -> i64
      %bb48_105 = "braid.lshr"(%bb48_104, %bb48_14) : (i64, i64) -> i64
      %bb48_106 = "braid.lshr"(%bb48_104, %bb48_15) : (i64, i64) -> i64
      %bb48_107 = "braid.lshr"(%bb48_104, %bb48_16) : (i64, i64) -> i64
      %bb48_108 = "braid.xor"(%bb48_105, %bb48_106) : (i64, i64) -> i64
      %bb48_109 = "braid.xor"(%bb48_108, %bb48_107) : (i64, i64) -> i64
      %bb48_110 = "braid.xor"(%bb48_57, %bb48_20) : (i64, i64) -> i64
      %bb48_111 = "braid.and"(%bb48_87, %bb48_110) : (i64, i64) -> i64
      %bb48_112 = "braid.and"(%bb48_57, %bb48_20) : (i64, i64) -> i64
      %bb48_113 = "braid.xor"(%bb48_111, %bb48_112) : (i64, i64) -> i64
      %bb48_114 = "braid.add"(%bb48_102, %bb48_113) : (i64, i64) -> i64
      %bb48_115 = "braid.add"(%bb48_114, %bb48_109) : (i64, i64) -> i64
      %bb48_117 = "braid.and"(%bb48_115, %bb48_17) : (i64, i64) -> i64
      %bb48_116 = "braid.add"(%bb48_102, %bb48_21) : (i64, i64) -> i64
      %bb48_118 = "braid.and"(%bb48_116, %bb48_17) : (i64, i64) -> i64
      %bb48_120 = "braid.shl"(%bb48_118, %bb48_10) : (i64, i64) -> i64
      %bb48_121 = "braid.or"(%bb48_118, %bb48_120) : (i64, i64) -> i64
      %bb48_122 = "braid.lshr"(%bb48_121, %bb48_11) : (i64, i64) -> i64
      %bb48_123 = "braid.lshr"(%bb48_121, %bb48_12) : (i64, i64) -> i64
      %bb48_124 = "braid.lshr"(%bb48_121, %bb48_13) : (i64, i64) -> i64
      %bb48_125 = "braid.xor"(%bb48_122, %bb48_123) : (i64, i64) -> i64
      %bb48_126 = "braid.xor"(%bb48_125, %bb48_124) : (i64, i64) -> i64
      %bb48_127 = "braid.xor"(%bb48_88, %bb48_58) : (i64, i64) -> i64
      %bb48_128 = "braid.and"(%bb48_118, %bb48_127) : (i64, i64) -> i64
      %bb48_129 = "braid.xor"(%bb48_58, %bb48_128) : (i64, i64) -> i64
      %bb48_130 = "braid.add"(%bb48_129, %bb48_126) : (i64, i64) -> i64
      %bb48_131 = "braid.add"(%bb48_130, %bb48_27) : (i64, i64) -> i64
      %bb48_132 = "braid.add"(%bb48_131, %bb48_23) : (i64, i64) -> i64
      %bb48_146 = "braid.add"(%bb48_132, %bb48_20) : (i64, i64) -> i64
      %bb48_148 = "braid.and"(%bb48_146, %bb48_17) : (i64, i64) -> i64
      %bb48_150 = "braid.shl"(%bb48_118, %bb48_10) : (i64, i64) -> i64
      %bb48_200 = "braid.or"(%bb48_148, %bb48_150) : (i64, i64) -> i64
      %bb48_151 = "braid.shl"(%bb48_58, %bb48_10) : (i64, i64) -> i64
      %bb48_201 = "braid.or"(%bb48_88, %bb48_151) : (i64, i64) -> i64
      "braid.set"(%bb48_200) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb48_201) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x10108
      %bb4c_0 = "braid.get"() {reg = "v17.lo"} : () -> i64
      %bb4c_1 = "braid.get"() {reg = "v17.hi"} : () -> i64
      %bb4c_2 = "braid.get"() {reg = "v17.lo"} : () -> i64
      %bb4c_3 = "braid.get"() {reg = "v17.hi"} : () -> i64
      %bb4c_10 = "braid.or"(%bb4c_0, %bb4c_2) : (i64, i64) -> i64
      %bb4c_20 = "braid.or"(%bb4c_1, %bb4c_3) : (i64, i64) -> i64
      "braid.set"(%bb4c_10) {reg = "v18.lo"} : (i64) -> ()
      "braid.set"(%bb4c_20) {reg = "v18.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x1010c
      %bb50_0 = "braid.get"() {reg = "v16.lo"} : () -> i64
      %bb50_1 = "braid.get"() {reg = "v16.hi"} : () -> i64
      %bb50_2 = "braid.get"() {reg = "v16.lo"} : () -> i64
      %bb50_3 = "braid.get"() {reg = "v16.hi"} : () -> i64
      %bb50_10 = "braid.or"(%bb50_0, %bb50_2) : (i64, i64) -> i64
      %bb50_20 = "braid.or"(%bb50_1, %bb50_3) : (i64, i64) -> i64
      "braid.set"(%bb50_10) {reg = "v2.lo"} : (i64) -> ()
      "braid.set"(%bb50_20) {reg = "v2.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x10110
      %bb54_0 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb54_1 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb54_2 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb54_3 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb54_10 = "braid.or"(%bb54_0, %bb54_2) : (i64, i64) -> i64
      %bb54_20 = "braid.or"(%bb54_1, %bb54_3) : (i64, i64) -> i64
      "braid.set"(%bb54_10) {reg = "v16.lo"} : (i64) -> ()
      "braid.set"(%bb54_20) {reg = "v16.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x10114
      %bb58_0 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb58_1 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb58_2 = "braid.get"() {reg = "v17.lo"} : () -> i64
      %bb58_3 = "braid.get"() {reg = "v17.hi"} : () -> i64
      %bb58_4 = "braid.get"() {reg = "v6.lo"} : () -> i64
      %bb58_5 = "braid.get"() {reg = "v6.hi"} : () -> i64
      %bb58_10 = "braid.const"() {value = 17 : i64} : () -> i64
      %bb58_11 = "braid.const"() {value = 140733193420799 : i64} : () -> i64
      %bb58_12 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb58_13 = "braid.const"() {value = -140733193420800 : i64} : () -> i64
      %bb58_14 = "braid.const"() {value = 19 : i64} : () -> i64
      %bb58_15 = "braid.const"() {value = 35180077129727 : i64} : () -> i64
      %bb58_16 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb58_17 = "braid.const"() {value = -35180077129728 : i64} : () -> i64
      %bb58_18 = "braid.const"() {value = 10 : i64} : () -> i64
      %bb58_19 = "braid.const"() {value = 18014394218708991 : i64} : () -> i64
      %bb58_20 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb58_21 = "braid.lshr"(%bb58_2, %bb58_20) : (i64, i64) -> i64
      %bb58_22 = "braid.shl"(%bb58_3, %bb58_20) : (i64, i64) -> i64
      %bb58_23 = "braid.or"(%bb58_21, %bb58_22) : (i64, i64) -> i64
      %bb58_24 = "braid.lanes"(%bb58_0, %bb58_23) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb58_30 = "braid.lshr"(%bb58_5, %bb58_10) : (i64, i64) -> i64
      %bb58_31 = "braid.and"(%bb58_30, %bb58_11) : (i64, i64) -> i64
      %bb58_32 = "braid.shl"(%bb58_5, %bb58_12) : (i64, i64) -> i64
      %bb58_33 = "braid.and"(%bb58_32, %bb58_13) : (i64, i64) -> i64
      %bb58_34 = "braid.or"(%bb58_31, %bb58_33) : (i64, i64) -> i64
      %bb58_35 = "braid.lshr"(%bb58_5, %bb58_14) : (i64, i64) -> i64
      %bb58_36 = "braid.and"(%bb58_35, %bb58_15) : (i64, i64) -> i64
      %bb58_37 = "braid.shl"(%bb58_5, %bb58_16) : (i64, i64) -> i64
      %bb58_38 = "braid.and"(%bb58_37, %bb58_17) : (i64, i64) -> i64
      %bb58_39 = "braid.or"(%bb58_36, %bb58_38) : (i64, i64) -> i64
      %bb58_40 = "braid.lshr"(%bb58_5, %bb58_18) : (i64, i64) -> i64
      %bb58_41 = "braid.and"(%bb58_40, %bb58_19) : (i64, i64) -> i64
      %bb58_42 = "braid.xor"(%bb58_34, %bb58_39) : (i64, i64) -> i64
      %bb58_43 = "braid.xor"(%bb58_42, %bb58_41) : (i64, i64) -> i64
      %bb58_200 = "braid.lanes"(%bb58_24, %bb58_43) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb58_50 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb58_51 = "braid.lshr"(%bb58_3, %bb58_50) : (i64, i64) -> i64
      %bb58_52 = "braid.shl"(%bb58_4, %bb58_50) : (i64, i64) -> i64
      %bb58_53 = "braid.or"(%bb58_51, %bb58_52) : (i64, i64) -> i64
      %bb58_54 = "braid.lanes"(%bb58_1, %bb58_53) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb58_60 = "braid.lshr"(%bb58_200, %bb58_10) : (i64, i64) -> i64
      %bb58_61 = "braid.and"(%bb58_60, %bb58_11) : (i64, i64) -> i64
      %bb58_62 = "braid.shl"(%bb58_200, %bb58_12) : (i64, i64) -> i64
      %bb58_63 = "braid.and"(%bb58_62, %bb58_13) : (i64, i64) -> i64
      %bb58_64 = "braid.or"(%bb58_61, %bb58_63) : (i64, i64) -> i64
      %bb58_65 = "braid.lshr"(%bb58_200, %bb58_14) : (i64, i64) -> i64
      %bb58_66 = "braid.and"(%bb58_65, %bb58_15) : (i64, i64) -> i64
      %bb58_67 = "braid.shl"(%bb58_200, %bb58_16) : (i64, i64) -> i64
      %bb58_68 = "braid.and"(%bb58_67, %bb58_17) : (i64, i64) -> i64
      %bb58_69 = "braid.or"(%bb58_66, %bb58_68) : (i64, i64) -> i64
      %bb58_70 = "braid.lshr"(%bb58_200, %bb58_18) : (i64, i64) -> i64
      %bb58_71 = "braid.and"(%bb58_70, %bb58_19) : (i64, i64) -> i64
      %bb58_72 = "braid.xor"(%bb58_64, %bb58_69) : (i64, i64) -> i64
      %bb58_73 = "braid.xor"(%bb58_72, %bb58_71) : (i64, i64) -> i64
      %bb58_201 = "braid.lanes"(%bb58_54, %bb58_73) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb58_200) {reg = "v2.lo"} : (i64) -> ()
      "braid.set"(%bb58_201) {reg = "v2.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x10118
      %bb5c_0 = "braid.get"() {reg = "v6.lo"} : () -> i64
      %bb5c_1 = "braid.get"() {reg = "v6.hi"} : () -> i64
      %bb5c_2 = "braid.get"() {reg = "v6.lo"} : () -> i64
      %bb5c_3 = "braid.get"() {reg = "v6.hi"} : () -> i64
      %bb5c_10 = "braid.or"(%bb5c_0, %bb5c_2) : (i64, i64) -> i64
      %bb5c_20 = "braid.or"(%bb5c_1, %bb5c_3) : (i64, i64) -> i64
      "braid.set"(%bb5c_10) {reg = "v17.lo"} : (i64) -> ()
      "braid.set"(%bb5c_20) {reg = "v17.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x1011c
      %bb60_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb60_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb60_0 = "braid.eq"(%bb60_1, %bb60_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb60_0)[^bb20, ^bb64] : (i64) -> ()
    ^bb64:  // 0x10120
      %bb64_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb64_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb64_12 = "braid.or"(%bb64_0, %bb64_2) : (i64, i64) -> i64
      "braid.set"(%bb64_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x10124
      %bb68_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb68_2 = "braid.get"() {reg = "x9"} : () -> i64
      %bb68_12 = "braid.add"(%bb68_0, %bb68_2) : (i64, i64) -> i64
      "braid.set"(%bb68_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x10128
      %bb6c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb6c_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb6c_3 = "braid.add"(%bb6c_0, %bb6c_2) : (i64, i64) -> i64
      "braid.set"(%bb6c_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x1012c
      %bb70_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb70_6 = "braid.const"() {value = 192 : i64} : () -> i64
      %bb70_0 = "braid.add"(%bb70_1, %bb70_6) : (i64, i64) -> i64
      %bb70_30 = "braid.load"(%bb70_0) {bytes = 8 : i64} : (i64) -> i64
      %bb70_32 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb70_33 = "braid.add"(%bb70_0, %bb70_32) : (i64, i64) -> i64
      %bb70_31 = "braid.load"(%bb70_33) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb70_30) {reg = "v16.lo"} : (i64) -> ()
      "braid.set"(%bb70_31) {reg = "v16.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x10130
      %bb74_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb74_2 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb74_3 = "braid.sub"(%bb74_0, %bb74_2) : (i64, i64) -> i64
      %bb74_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb74_4 = "braid.slt"(%bb74_3, %bb74_8) : (i64, i64) -> i64
      %bb74_5 = "braid.eq"(%bb74_0, %bb74_2) : (i64, i64) -> i64
      %bb74_6 = "braid.ule"(%bb74_2, %bb74_0) : (i64, i64) -> i64
      %bb74_9 = "braid.xor"(%bb74_0, %bb74_2) : (i64, i64) -> i64
      %bb74_10 = "braid.xor"(%bb74_0, %bb74_3) : (i64, i64) -> i64
      %bb74_11 = "braid.and"(%bb74_9, %bb74_10) : (i64, i64) -> i64
      %bb74_7 = "braid.slt"(%bb74_11, %bb74_8) : (i64, i64) -> i64
      "braid.setf"(%bb74_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb74_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb74_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb74_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x10134
      %bb78_0 = "braid.get"() {reg = "v16.lo"} : () -> i64
      %bb78_1 = "braid.get"() {reg = "v16.hi"} : () -> i64
      %bb78_2 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb78_3 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb78_10 = "braid.lanes"(%bb78_0, %bb78_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb78_20 = "braid.lanes"(%bb78_1, %bb78_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb78_10) {reg = "v5.lo"} : (i64) -> ()
      "braid.set"(%bb78_20) {reg = "v5.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x10138
      %bb7c_0 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb7c_1 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb7c_2 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb7c_3 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb7c_10 = "braid.or"(%bb7c_0, %bb7c_2) : (i64, i64) -> i64
      %bb7c_20 = "braid.or"(%bb7c_1, %bb7c_3) : (i64, i64) -> i64
      "braid.set"(%bb7c_10) {reg = "v16.lo"} : (i64) -> ()
      "braid.set"(%bb7c_20) {reg = "v16.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb80] : () -> ()
    ^bb80:  // 0x1013c
      %bb80_0 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb80_1 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb80_2 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb80_3 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb80_4 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb80_5 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb80_10 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb80_11 = "braid.const"() {value = 6 : i64} : () -> i64
      %bb80_12 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb80_13 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb80_14 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb80_15 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb80_16 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb80_17 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bb80_20 = "braid.and"(%bb80_0, %bb80_17) : (i64, i64) -> i64
      %bb80_21 = "braid.lshr"(%bb80_0, %bb80_10) : (i64, i64) -> i64
      %bb80_22 = "braid.lshr"(%bb80_1, %bb80_10) : (i64, i64) -> i64
      %bb80_23 = "braid.and"(%bb80_2, %bb80_17) : (i64, i64) -> i64
      %bb80_24 = "braid.lshr"(%bb80_2, %bb80_10) : (i64, i64) -> i64
      %bb80_25 = "braid.lshr"(%bb80_3, %bb80_10) : (i64, i64) -> i64
      %bb80_26 = "braid.lshr"(%bb80_4, %bb80_10) : (i64, i64) -> i64
      %bb80_27 = "braid.lshr"(%bb80_5, %bb80_10) : (i64, i64) -> i64
      %bb80_30 = "braid.shl"(%bb80_23, %bb80_10) : (i64, i64) -> i64
      %bb80_31 = "braid.or"(%bb80_23, %bb80_30) : (i64, i64) -> i64
      %bb80_32 = "braid.lshr"(%bb80_31, %bb80_11) : (i64, i64) -> i64
      %bb80_33 = "braid.lshr"(%bb80_31, %bb80_12) : (i64, i64) -> i64
      %bb80_34 = "braid.lshr"(%bb80_31, %bb80_13) : (i64, i64) -> i64
      %bb80_35 = "braid.xor"(%bb80_32, %bb80_33) : (i64, i64) -> i64
      %bb80_36 = "braid.xor"(%bb80_35, %bb80_34) : (i64, i64) -> i64
      %bb80_37 = "braid.xor"(%bb80_24, %bb80_3) : (i64, i64) -> i64
      %bb80_38 = "braid.and"(%bb80_23, %bb80_37) : (i64, i64) -> i64
      %bb80_39 = "braid.xor"(%bb80_3, %bb80_38) : (i64, i64) -> i64
      %bb80_40 = "braid.add"(%bb80_39, %bb80_36) : (i64, i64) -> i64
      %bb80_41 = "braid.add"(%bb80_40, %bb80_4) : (i64, i64) -> i64
      %bb80_42 = "braid.add"(%bb80_41, %bb80_25) : (i64, i64) -> i64
      %bb80_43 = "braid.shl"(%bb80_20, %bb80_10) : (i64, i64) -> i64
      %bb80_44 = "braid.or"(%bb80_20, %bb80_43) : (i64, i64) -> i64
      %bb80_45 = "braid.lshr"(%bb80_44, %bb80_14) : (i64, i64) -> i64
      %bb80_46 = "braid.lshr"(%bb80_44, %bb80_15) : (i64, i64) -> i64
      %bb80_47 = "braid.lshr"(%bb80_44, %bb80_16) : (i64, i64) -> i64
      %bb80_48 = "braid.xor"(%bb80_45, %bb80_46) : (i64, i64) -> i64
      %bb80_49 = "braid.xor"(%bb80_48, %bb80_47) : (i64, i64) -> i64
      %bb80_50 = "braid.xor"(%bb80_21, %bb80_1) : (i64, i64) -> i64
      %bb80_51 = "braid.and"(%bb80_20, %bb80_50) : (i64, i64) -> i64
      %bb80_52 = "braid.and"(%bb80_21, %bb80_1) : (i64, i64) -> i64
      %bb80_53 = "braid.xor"(%bb80_51, %bb80_52) : (i64, i64) -> i64
      %bb80_54 = "braid.add"(%bb80_42, %bb80_53) : (i64, i64) -> i64
      %bb80_55 = "braid.add"(%bb80_54, %bb80_49) : (i64, i64) -> i64
      %bb80_57 = "braid.and"(%bb80_55, %bb80_17) : (i64, i64) -> i64
      %bb80_56 = "braid.add"(%bb80_42, %bb80_22) : (i64, i64) -> i64
      %bb80_58 = "braid.and"(%bb80_56, %bb80_17) : (i64, i64) -> i64
      %bb80_60 = "braid.shl"(%bb80_58, %bb80_10) : (i64, i64) -> i64
      %bb80_61 = "braid.or"(%bb80_58, %bb80_60) : (i64, i64) -> i64
      %bb80_62 = "braid.lshr"(%bb80_61, %bb80_11) : (i64, i64) -> i64
      %bb80_63 = "braid.lshr"(%bb80_61, %bb80_12) : (i64, i64) -> i64
      %bb80_64 = "braid.lshr"(%bb80_61, %bb80_13) : (i64, i64) -> i64
      %bb80_65 = "braid.xor"(%bb80_62, %bb80_63) : (i64, i64) -> i64
      %bb80_66 = "braid.xor"(%bb80_65, %bb80_64) : (i64, i64) -> i64
      %bb80_67 = "braid.xor"(%bb80_23, %bb80_24) : (i64, i64) -> i64
      %bb80_68 = "braid.and"(%bb80_58, %bb80_67) : (i64, i64) -> i64
      %bb80_69 = "braid.xor"(%bb80_24, %bb80_68) : (i64, i64) -> i64
      %bb80_70 = "braid.add"(%bb80_69, %bb80_66) : (i64, i64) -> i64
      %bb80_71 = "braid.add"(%bb80_70, %bb80_26) : (i64, i64) -> i64
      %bb80_72 = "braid.add"(%bb80_71, %bb80_3) : (i64, i64) -> i64
      %bb80_73 = "braid.shl"(%bb80_57, %bb80_10) : (i64, i64) -> i64
      %bb80_74 = "braid.or"(%bb80_57, %bb80_73) : (i64, i64) -> i64
      %bb80_75 = "braid.lshr"(%bb80_74, %bb80_14) : (i64, i64) -> i64
      %bb80_76 = "braid.lshr"(%bb80_74, %bb80_15) : (i64, i64) -> i64
      %bb80_77 = "braid.lshr"(%bb80_74, %bb80_16) : (i64, i64) -> i64
      %bb80_78 = "braid.xor"(%bb80_75, %bb80_76) : (i64, i64) -> i64
      %bb80_79 = "braid.xor"(%bb80_78, %bb80_77) : (i64, i64) -> i64
      %bb80_80 = "braid.xor"(%bb80_20, %bb80_21) : (i64, i64) -> i64
      %bb80_81 = "braid.and"(%bb80_57, %bb80_80) : (i64, i64) -> i64
      %bb80_82 = "braid.and"(%bb80_20, %bb80_21) : (i64, i64) -> i64
      %bb80_83 = "braid.xor"(%bb80_81, %bb80_82) : (i64, i64) -> i64
      %bb80_84 = "braid.add"(%bb80_72, %bb80_83) : (i64, i64) -> i64
      %bb80_85 = "braid.add"(%bb80_84, %bb80_79) : (i64, i64) -> i64
      %bb80_87 = "braid.and"(%bb80_85, %bb80_17) : (i64, i64) -> i64
      %bb80_86 = "braid.add"(%bb80_72, %bb80_1) : (i64, i64) -> i64
      %bb80_88 = "braid.and"(%bb80_86, %bb80_17) : (i64, i64) -> i64
      %bb80_90 = "braid.shl"(%bb80_88, %bb80_10) : (i64, i64) -> i64
      %bb80_91 = "braid.or"(%bb80_88, %bb80_90) : (i64, i64) -> i64
      %bb80_92 = "braid.lshr"(%bb80_91, %bb80_11) : (i64, i64) -> i64
      %bb80_93 = "braid.lshr"(%bb80_91, %bb80_12) : (i64, i64) -> i64
      %bb80_94 = "braid.lshr"(%bb80_91, %bb80_13) : (i64, i64) -> i64
      %bb80_95 = "braid.xor"(%bb80_92, %bb80_93) : (i64, i64) -> i64
      %bb80_96 = "braid.xor"(%bb80_95, %bb80_94) : (i64, i64) -> i64
      %bb80_97 = "braid.xor"(%bb80_58, %bb80_23) : (i64, i64) -> i64
      %bb80_98 = "braid.and"(%bb80_88, %bb80_97) : (i64, i64) -> i64
      %bb80_99 = "braid.xor"(%bb80_23, %bb80_98) : (i64, i64) -> i64
      %bb80_100 = "braid.add"(%bb80_99, %bb80_96) : (i64, i64) -> i64
      %bb80_101 = "braid.add"(%bb80_100, %bb80_5) : (i64, i64) -> i64
      %bb80_102 = "braid.add"(%bb80_101, %bb80_24) : (i64, i64) -> i64
      %bb80_103 = "braid.shl"(%bb80_87, %bb80_10) : (i64, i64) -> i64
      %bb80_104 = "braid.or"(%bb80_87, %bb80_103) : (i64, i64) -> i64
      %bb80_105 = "braid.lshr"(%bb80_104, %bb80_14) : (i64, i64) -> i64
      %bb80_106 = "braid.lshr"(%bb80_104, %bb80_15) : (i64, i64) -> i64
      %bb80_107 = "braid.lshr"(%bb80_104, %bb80_16) : (i64, i64) -> i64
      %bb80_108 = "braid.xor"(%bb80_105, %bb80_106) : (i64, i64) -> i64
      %bb80_109 = "braid.xor"(%bb80_108, %bb80_107) : (i64, i64) -> i64
      %bb80_110 = "braid.xor"(%bb80_57, %bb80_20) : (i64, i64) -> i64
      %bb80_111 = "braid.and"(%bb80_87, %bb80_110) : (i64, i64) -> i64
      %bb80_112 = "braid.and"(%bb80_57, %bb80_20) : (i64, i64) -> i64
      %bb80_113 = "braid.xor"(%bb80_111, %bb80_112) : (i64, i64) -> i64
      %bb80_114 = "braid.add"(%bb80_102, %bb80_113) : (i64, i64) -> i64
      %bb80_115 = "braid.add"(%bb80_114, %bb80_109) : (i64, i64) -> i64
      %bb80_117 = "braid.and"(%bb80_115, %bb80_17) : (i64, i64) -> i64
      %bb80_116 = "braid.add"(%bb80_102, %bb80_21) : (i64, i64) -> i64
      %bb80_118 = "braid.and"(%bb80_116, %bb80_17) : (i64, i64) -> i64
      %bb80_120 = "braid.shl"(%bb80_118, %bb80_10) : (i64, i64) -> i64
      %bb80_121 = "braid.or"(%bb80_118, %bb80_120) : (i64, i64) -> i64
      %bb80_122 = "braid.lshr"(%bb80_121, %bb80_11) : (i64, i64) -> i64
      %bb80_123 = "braid.lshr"(%bb80_121, %bb80_12) : (i64, i64) -> i64
      %bb80_124 = "braid.lshr"(%bb80_121, %bb80_13) : (i64, i64) -> i64
      %bb80_125 = "braid.xor"(%bb80_122, %bb80_123) : (i64, i64) -> i64
      %bb80_126 = "braid.xor"(%bb80_125, %bb80_124) : (i64, i64) -> i64
      %bb80_127 = "braid.xor"(%bb80_88, %bb80_58) : (i64, i64) -> i64
      %bb80_128 = "braid.and"(%bb80_118, %bb80_127) : (i64, i64) -> i64
      %bb80_129 = "braid.xor"(%bb80_58, %bb80_128) : (i64, i64) -> i64
      %bb80_130 = "braid.add"(%bb80_129, %bb80_126) : (i64, i64) -> i64
      %bb80_131 = "braid.add"(%bb80_130, %bb80_27) : (i64, i64) -> i64
      %bb80_132 = "braid.add"(%bb80_131, %bb80_23) : (i64, i64) -> i64
      %bb80_133 = "braid.shl"(%bb80_117, %bb80_10) : (i64, i64) -> i64
      %bb80_134 = "braid.or"(%bb80_117, %bb80_133) : (i64, i64) -> i64
      %bb80_135 = "braid.lshr"(%bb80_134, %bb80_14) : (i64, i64) -> i64
      %bb80_136 = "braid.lshr"(%bb80_134, %bb80_15) : (i64, i64) -> i64
      %bb80_137 = "braid.lshr"(%bb80_134, %bb80_16) : (i64, i64) -> i64
      %bb80_138 = "braid.xor"(%bb80_135, %bb80_136) : (i64, i64) -> i64
      %bb80_139 = "braid.xor"(%bb80_138, %bb80_137) : (i64, i64) -> i64
      %bb80_140 = "braid.xor"(%bb80_87, %bb80_57) : (i64, i64) -> i64
      %bb80_141 = "braid.and"(%bb80_117, %bb80_140) : (i64, i64) -> i64
      %bb80_142 = "braid.and"(%bb80_87, %bb80_57) : (i64, i64) -> i64
      %bb80_143 = "braid.xor"(%bb80_141, %bb80_142) : (i64, i64) -> i64
      %bb80_144 = "braid.add"(%bb80_132, %bb80_143) : (i64, i64) -> i64
      %bb80_145 = "braid.add"(%bb80_144, %bb80_139) : (i64, i64) -> i64
      %bb80_147 = "braid.and"(%bb80_145, %bb80_17) : (i64, i64) -> i64
      %bb80_150 = "braid.shl"(%bb80_117, %bb80_10) : (i64, i64) -> i64
      %bb80_200 = "braid.or"(%bb80_147, %bb80_150) : (i64, i64) -> i64
      %bb80_151 = "braid.shl"(%bb80_57, %bb80_10) : (i64, i64) -> i64
      %bb80_201 = "braid.or"(%bb80_87, %bb80_151) : (i64, i64) -> i64
      "braid.set"(%bb80_200) {reg = "v4.lo"} : (i64) -> ()
      "braid.set"(%bb80_201) {reg = "v4.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x10140
      %bb84_0 = "braid.get"() {reg = "v16.lo"} : () -> i64
      %bb84_1 = "braid.get"() {reg = "v16.hi"} : () -> i64
      %bb84_2 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb84_3 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb84_4 = "braid.get"() {reg = "v5.lo"} : () -> i64
      %bb84_5 = "braid.get"() {reg = "v5.hi"} : () -> i64
      %bb84_10 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb84_11 = "braid.const"() {value = 6 : i64} : () -> i64
      %bb84_12 = "braid.const"() {value = 11 : i64} : () -> i64
      %bb84_13 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb84_14 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb84_15 = "braid.const"() {value = 13 : i64} : () -> i64
      %bb84_16 = "braid.const"() {value = 22 : i64} : () -> i64
      %bb84_17 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bb84_20 = "braid.and"(%bb84_0, %bb84_17) : (i64, i64) -> i64
      %bb84_21 = "braid.lshr"(%bb84_0, %bb84_10) : (i64, i64) -> i64
      %bb84_22 = "braid.lshr"(%bb84_1, %bb84_10) : (i64, i64) -> i64
      %bb84_23 = "braid.and"(%bb84_2, %bb84_17) : (i64, i64) -> i64
      %bb84_24 = "braid.lshr"(%bb84_2, %bb84_10) : (i64, i64) -> i64
      %bb84_25 = "braid.lshr"(%bb84_3, %bb84_10) : (i64, i64) -> i64
      %bb84_26 = "braid.lshr"(%bb84_4, %bb84_10) : (i64, i64) -> i64
      %bb84_27 = "braid.lshr"(%bb84_5, %bb84_10) : (i64, i64) -> i64
      %bb84_30 = "braid.shl"(%bb84_23, %bb84_10) : (i64, i64) -> i64
      %bb84_31 = "braid.or"(%bb84_23, %bb84_30) : (i64, i64) -> i64
      %bb84_32 = "braid.lshr"(%bb84_31, %bb84_11) : (i64, i64) -> i64
      %bb84_33 = "braid.lshr"(%bb84_31, %bb84_12) : (i64, i64) -> i64
      %bb84_34 = "braid.lshr"(%bb84_31, %bb84_13) : (i64, i64) -> i64
      %bb84_35 = "braid.xor"(%bb84_32, %bb84_33) : (i64, i64) -> i64
      %bb84_36 = "braid.xor"(%bb84_35, %bb84_34) : (i64, i64) -> i64
      %bb84_37 = "braid.xor"(%bb84_24, %bb84_3) : (i64, i64) -> i64
      %bb84_38 = "braid.and"(%bb84_23, %bb84_37) : (i64, i64) -> i64
      %bb84_39 = "braid.xor"(%bb84_3, %bb84_38) : (i64, i64) -> i64
      %bb84_40 = "braid.add"(%bb84_39, %bb84_36) : (i64, i64) -> i64
      %bb84_41 = "braid.add"(%bb84_40, %bb84_4) : (i64, i64) -> i64
      %bb84_42 = "braid.add"(%bb84_41, %bb84_25) : (i64, i64) -> i64
      %bb84_43 = "braid.shl"(%bb84_20, %bb84_10) : (i64, i64) -> i64
      %bb84_44 = "braid.or"(%bb84_20, %bb84_43) : (i64, i64) -> i64
      %bb84_45 = "braid.lshr"(%bb84_44, %bb84_14) : (i64, i64) -> i64
      %bb84_46 = "braid.lshr"(%bb84_44, %bb84_15) : (i64, i64) -> i64
      %bb84_47 = "braid.lshr"(%bb84_44, %bb84_16) : (i64, i64) -> i64
      %bb84_48 = "braid.xor"(%bb84_45, %bb84_46) : (i64, i64) -> i64
      %bb84_49 = "braid.xor"(%bb84_48, %bb84_47) : (i64, i64) -> i64
      %bb84_50 = "braid.xor"(%bb84_21, %bb84_1) : (i64, i64) -> i64
      %bb84_51 = "braid.and"(%bb84_20, %bb84_50) : (i64, i64) -> i64
      %bb84_52 = "braid.and"(%bb84_21, %bb84_1) : (i64, i64) -> i64
      %bb84_53 = "braid.xor"(%bb84_51, %bb84_52) : (i64, i64) -> i64
      %bb84_54 = "braid.add"(%bb84_42, %bb84_53) : (i64, i64) -> i64
      %bb84_55 = "braid.add"(%bb84_54, %bb84_49) : (i64, i64) -> i64
      %bb84_57 = "braid.and"(%bb84_55, %bb84_17) : (i64, i64) -> i64
      %bb84_56 = "braid.add"(%bb84_42, %bb84_22) : (i64, i64) -> i64
      %bb84_58 = "braid.and"(%bb84_56, %bb84_17) : (i64, i64) -> i64
      %bb84_60 = "braid.shl"(%bb84_58, %bb84_10) : (i64, i64) -> i64
      %bb84_61 = "braid.or"(%bb84_58, %bb84_60) : (i64, i64) -> i64
      %bb84_62 = "braid.lshr"(%bb84_61, %bb84_11) : (i64, i64) -> i64
      %bb84_63 = "braid.lshr"(%bb84_61, %bb84_12) : (i64, i64) -> i64
      %bb84_64 = "braid.lshr"(%bb84_61, %bb84_13) : (i64, i64) -> i64
      %bb84_65 = "braid.xor"(%bb84_62, %bb84_63) : (i64, i64) -> i64
      %bb84_66 = "braid.xor"(%bb84_65, %bb84_64) : (i64, i64) -> i64
      %bb84_67 = "braid.xor"(%bb84_23, %bb84_24) : (i64, i64) -> i64
      %bb84_68 = "braid.and"(%bb84_58, %bb84_67) : (i64, i64) -> i64
      %bb84_69 = "braid.xor"(%bb84_24, %bb84_68) : (i64, i64) -> i64
      %bb84_70 = "braid.add"(%bb84_69, %bb84_66) : (i64, i64) -> i64
      %bb84_71 = "braid.add"(%bb84_70, %bb84_26) : (i64, i64) -> i64
      %bb84_72 = "braid.add"(%bb84_71, %bb84_3) : (i64, i64) -> i64
      %bb84_73 = "braid.shl"(%bb84_57, %bb84_10) : (i64, i64) -> i64
      %bb84_74 = "braid.or"(%bb84_57, %bb84_73) : (i64, i64) -> i64
      %bb84_75 = "braid.lshr"(%bb84_74, %bb84_14) : (i64, i64) -> i64
      %bb84_76 = "braid.lshr"(%bb84_74, %bb84_15) : (i64, i64) -> i64
      %bb84_77 = "braid.lshr"(%bb84_74, %bb84_16) : (i64, i64) -> i64
      %bb84_78 = "braid.xor"(%bb84_75, %bb84_76) : (i64, i64) -> i64
      %bb84_79 = "braid.xor"(%bb84_78, %bb84_77) : (i64, i64) -> i64
      %bb84_80 = "braid.xor"(%bb84_20, %bb84_21) : (i64, i64) -> i64
      %bb84_81 = "braid.and"(%bb84_57, %bb84_80) : (i64, i64) -> i64
      %bb84_82 = "braid.and"(%bb84_20, %bb84_21) : (i64, i64) -> i64
      %bb84_83 = "braid.xor"(%bb84_81, %bb84_82) : (i64, i64) -> i64
      %bb84_84 = "braid.add"(%bb84_72, %bb84_83) : (i64, i64) -> i64
      %bb84_85 = "braid.add"(%bb84_84, %bb84_79) : (i64, i64) -> i64
      %bb84_87 = "braid.and"(%bb84_85, %bb84_17) : (i64, i64) -> i64
      %bb84_86 = "braid.add"(%bb84_72, %bb84_1) : (i64, i64) -> i64
      %bb84_88 = "braid.and"(%bb84_86, %bb84_17) : (i64, i64) -> i64
      %bb84_90 = "braid.shl"(%bb84_88, %bb84_10) : (i64, i64) -> i64
      %bb84_91 = "braid.or"(%bb84_88, %bb84_90) : (i64, i64) -> i64
      %bb84_92 = "braid.lshr"(%bb84_91, %bb84_11) : (i64, i64) -> i64
      %bb84_93 = "braid.lshr"(%bb84_91, %bb84_12) : (i64, i64) -> i64
      %bb84_94 = "braid.lshr"(%bb84_91, %bb84_13) : (i64, i64) -> i64
      %bb84_95 = "braid.xor"(%bb84_92, %bb84_93) : (i64, i64) -> i64
      %bb84_96 = "braid.xor"(%bb84_95, %bb84_94) : (i64, i64) -> i64
      %bb84_97 = "braid.xor"(%bb84_58, %bb84_23) : (i64, i64) -> i64
      %bb84_98 = "braid.and"(%bb84_88, %bb84_97) : (i64, i64) -> i64
      %bb84_99 = "braid.xor"(%bb84_23, %bb84_98) : (i64, i64) -> i64
      %bb84_100 = "braid.add"(%bb84_99, %bb84_96) : (i64, i64) -> i64
      %bb84_101 = "braid.add"(%bb84_100, %bb84_5) : (i64, i64) -> i64
      %bb84_102 = "braid.add"(%bb84_101, %bb84_24) : (i64, i64) -> i64
      %bb84_103 = "braid.shl"(%bb84_87, %bb84_10) : (i64, i64) -> i64
      %bb84_104 = "braid.or"(%bb84_87, %bb84_103) : (i64, i64) -> i64
      %bb84_105 = "braid.lshr"(%bb84_104, %bb84_14) : (i64, i64) -> i64
      %bb84_106 = "braid.lshr"(%bb84_104, %bb84_15) : (i64, i64) -> i64
      %bb84_107 = "braid.lshr"(%bb84_104, %bb84_16) : (i64, i64) -> i64
      %bb84_108 = "braid.xor"(%bb84_105, %bb84_106) : (i64, i64) -> i64
      %bb84_109 = "braid.xor"(%bb84_108, %bb84_107) : (i64, i64) -> i64
      %bb84_110 = "braid.xor"(%bb84_57, %bb84_20) : (i64, i64) -> i64
      %bb84_111 = "braid.and"(%bb84_87, %bb84_110) : (i64, i64) -> i64
      %bb84_112 = "braid.and"(%bb84_57, %bb84_20) : (i64, i64) -> i64
      %bb84_113 = "braid.xor"(%bb84_111, %bb84_112) : (i64, i64) -> i64
      %bb84_114 = "braid.add"(%bb84_102, %bb84_113) : (i64, i64) -> i64
      %bb84_115 = "braid.add"(%bb84_114, %bb84_109) : (i64, i64) -> i64
      %bb84_117 = "braid.and"(%bb84_115, %bb84_17) : (i64, i64) -> i64
      %bb84_116 = "braid.add"(%bb84_102, %bb84_21) : (i64, i64) -> i64
      %bb84_118 = "braid.and"(%bb84_116, %bb84_17) : (i64, i64) -> i64
      %bb84_120 = "braid.shl"(%bb84_118, %bb84_10) : (i64, i64) -> i64
      %bb84_121 = "braid.or"(%bb84_118, %bb84_120) : (i64, i64) -> i64
      %bb84_122 = "braid.lshr"(%bb84_121, %bb84_11) : (i64, i64) -> i64
      %bb84_123 = "braid.lshr"(%bb84_121, %bb84_12) : (i64, i64) -> i64
      %bb84_124 = "braid.lshr"(%bb84_121, %bb84_13) : (i64, i64) -> i64
      %bb84_125 = "braid.xor"(%bb84_122, %bb84_123) : (i64, i64) -> i64
      %bb84_126 = "braid.xor"(%bb84_125, %bb84_124) : (i64, i64) -> i64
      %bb84_127 = "braid.xor"(%bb84_88, %bb84_58) : (i64, i64) -> i64
      %bb84_128 = "braid.and"(%bb84_118, %bb84_127) : (i64, i64) -> i64
      %bb84_129 = "braid.xor"(%bb84_58, %bb84_128) : (i64, i64) -> i64
      %bb84_130 = "braid.add"(%bb84_129, %bb84_126) : (i64, i64) -> i64
      %bb84_131 = "braid.add"(%bb84_130, %bb84_27) : (i64, i64) -> i64
      %bb84_132 = "braid.add"(%bb84_131, %bb84_23) : (i64, i64) -> i64
      %bb84_146 = "braid.add"(%bb84_132, %bb84_20) : (i64, i64) -> i64
      %bb84_148 = "braid.and"(%bb84_146, %bb84_17) : (i64, i64) -> i64
      %bb84_150 = "braid.shl"(%bb84_118, %bb84_10) : (i64, i64) -> i64
      %bb84_200 = "braid.or"(%bb84_148, %bb84_150) : (i64, i64) -> i64
      %bb84_151 = "braid.shl"(%bb84_58, %bb84_10) : (i64, i64) -> i64
      %bb84_201 = "braid.or"(%bb84_88, %bb84_151) : (i64, i64) -> i64
      "braid.set"(%bb84_200) {reg = "v3.lo"} : (i64) -> ()
      "braid.set"(%bb84_201) {reg = "v3.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x10144
      %bb88_0 = "braid.get"() {reg = "v7.lo"} : () -> i64
      %bb88_1 = "braid.get"() {reg = "v7.hi"} : () -> i64
      %bb88_2 = "braid.get"() {reg = "v7.lo"} : () -> i64
      %bb88_3 = "braid.get"() {reg = "v7.hi"} : () -> i64
      %bb88_10 = "braid.or"(%bb88_0, %bb88_2) : (i64, i64) -> i64
      %bb88_20 = "braid.or"(%bb88_1, %bb88_3) : (i64, i64) -> i64
      "braid.set"(%bb88_10) {reg = "v5.lo"} : (i64) -> ()
      "braid.set"(%bb88_20) {reg = "v5.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x10148
      %bb8c_0 = "braid.get"() {reg = "v6.lo"} : () -> i64
      %bb8c_1 = "braid.get"() {reg = "v6.hi"} : () -> i64
      %bb8c_2 = "braid.get"() {reg = "v6.lo"} : () -> i64
      %bb8c_3 = "braid.get"() {reg = "v6.hi"} : () -> i64
      %bb8c_10 = "braid.or"(%bb8c_0, %bb8c_2) : (i64, i64) -> i64
      %bb8c_20 = "braid.or"(%bb8c_1, %bb8c_3) : (i64, i64) -> i64
      "braid.set"(%bb8c_10) {reg = "v7.lo"} : (i64) -> ()
      "braid.set"(%bb8c_20) {reg = "v7.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x1014c
      %bb90_0 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb90_1 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb90_2 = "braid.get"() {reg = "v2.lo"} : () -> i64
      %bb90_3 = "braid.get"() {reg = "v2.hi"} : () -> i64
      %bb90_10 = "braid.or"(%bb90_0, %bb90_2) : (i64, i64) -> i64
      %bb90_20 = "braid.or"(%bb90_1, %bb90_3) : (i64, i64) -> i64
      "braid.set"(%bb90_10) {reg = "v6.lo"} : (i64) -> ()
      "braid.set"(%bb90_20) {reg = "v6.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x10150
      %bb94_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb94_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb94_0 = "braid.eq"(%bb94_1, %bb94_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb94_0)[^bb68, ^bb98] : (i64) -> ()
    ^bb98:  // 0x10154
      %bb98_0 = "braid.get"() {reg = "v4.lo"} : () -> i64
      %bb98_1 = "braid.get"() {reg = "v4.hi"} : () -> i64
      %bb98_2 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bb98_3 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bb98_10 = "braid.lanes"(%bb98_0, %bb98_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb98_20 = "braid.lanes"(%bb98_1, %bb98_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb98_10) {reg = "v1.lo"} : (i64) -> ()
      "braid.set"(%bb98_20) {reg = "v1.hi"} : (i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x10158
      %bb9c_0 = "braid.get"() {reg = "v3.lo"} : () -> i64
      %bb9c_1 = "braid.get"() {reg = "v3.hi"} : () -> i64
      %bb9c_2 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bb9c_3 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bb9c_10 = "braid.lanes"(%bb9c_0, %bb9c_2) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb9c_20 = "braid.lanes"(%bb9c_1, %bb9c_3) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb9c_10) {reg = "v0.lo"} : (i64) -> ()
      "braid.set"(%bb9c_20) {reg = "v0.hi"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x1015c
      %bba0_0 = "braid.get"() {reg = "v1.lo"} : () -> i64
      %bba0_1 = "braid.get"() {reg = "v1.hi"} : () -> i64
      %bba0_2 = "braid.get"() {reg = "v0.lo"} : () -> i64
      %bba0_3 = "braid.get"() {reg = "v0.hi"} : () -> i64
      %bba0_4 = "braid.get"() {reg = "x0"} : () -> i64
      %bba0_30 = "braid.const"() {value = 16 : i64} : () -> i64
      %bba0_31 = "braid.add"(%bba0_4, %bba0_30) : (i64, i64) -> i64
      "braid.store"(%bba0_4, %bba0_0) {bytes = 8 : i64} : (i64, i64) -> ()
      %bba0_32 = "braid.const"() {value = 8 : i64} : () -> i64
      %bba0_33 = "braid.add"(%bba0_4, %bba0_32) : (i64, i64) -> i64
      "braid.store"(%bba0_33, %bba0_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bba0_31, %bba0_2) {bytes = 8 : i64} : (i64, i64) -> ()
      %bba0_34 = "braid.const"() {value = 8 : i64} : () -> i64
      %bba0_35 = "braid.add"(%bba0_31, %bba0_34) : (i64, i64) -> i64
      "braid.store"(%bba0_35, %bba0_3) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bba4] : () -> ()
    ^bba4:  // 0x10160
      %bba4_0 = "braid.get"() {reg = "x30"} : () -> i64
      "braid_cf.br_ind"(%bba4_0) : (i64) -> ()
  }) {sym_name = "sha256_compress_ni", entry = 65724 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x20328
      %bb0_0 = "braid.const"() {value = 131072 : i64} : () -> i64
      "braid.set"(%bb0_0) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x2032c
      %bb4_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb4_2 = "braid.const"() {value = 3296 : i64} : () -> i64
      %bb4_3 = "braid.add"(%bb4_0, %bb4_2) : (i64, i64) -> i64
      "braid.set"(%bb4_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x20330
      %bb8_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb8_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb8_3 = "braid.add"(%bb8_0, %bb8_2) : (i64, i64) -> i64
      "braid.set"(%bb8_3) {reg = "sp"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x20334
      "braid_cf.br"()[^ext20338] : () -> ()
    ^ext20338:
      "braid_cf.tail"() {target = 131896 : i64} : () -> ()
  }) {sym_name = "_start", entry = 131880 : i64} : () -> ()
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x20338
      %bb0_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb0_2 = "braid.const"() {value = 208 : i64} : () -> i64
      %bb0_3 = "braid.sub"(%bb0_0, %bb0_2) : (i64, i64) -> i64
      "braid.set"(%bb0_3) {reg = "sp"} : (i64) -> ()
      "braid_cf.br"()[^bb4] : () -> ()
    ^bb4:  // 0x2033c
      %bb4_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb4_1 = "braid.get"() {reg = "x30"} : () -> i64
      %bb4_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb4_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb4_5 = "braid.and"(%bb4_3, %bb4_4) : (i64, i64) -> i64
      %bb4_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb4_7 = "braid.eq"(%bb4_5, %bb4_6) : (i64, i64) -> i64
      "braid.guard"(%bb4_7) : (i64) -> ()
      %bb4_8 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb4_2 = "braid.add"(%bb4_3, %bb4_8) : (i64, i64) -> i64
      %bb4_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb4_24 = "braid.add"(%bb4_2, %bb4_23) : (i64, i64) -> i64
      "braid.store"(%bb4_2, %bb4_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb4_24, %bb4_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb8] : () -> ()
    ^bb8:  // 0x20340
      %bb8_0 = "braid.const"() {value = 131072 : i64} : () -> i64
      "braid.set"(%bb8_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bbc] : () -> ()
    ^bbc:  // 0x20344
      %bbc_0 = "braid.const"() {value = 62322 : i64} : () -> i64
      "braid.set"(%bbc_0) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb10] : () -> ()
    ^bb10:  // 0x20348
      %bb10_0 = "braid.get"() {reg = "x26"} : () -> i64
      %bb10_1 = "braid.get"() {reg = "x25"} : () -> i64
      %bb10_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb10_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb10_5 = "braid.and"(%bb10_3, %bb10_4) : (i64, i64) -> i64
      %bb10_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb10_7 = "braid.eq"(%bb10_5, %bb10_6) : (i64, i64) -> i64
      "braid.guard"(%bb10_7) : (i64) -> ()
      %bb10_8 = "braid.const"() {value = 144 : i64} : () -> i64
      %bb10_2 = "braid.add"(%bb10_3, %bb10_8) : (i64, i64) -> i64
      %bb10_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb10_24 = "braid.add"(%bb10_2, %bb10_23) : (i64, i64) -> i64
      "braid.store"(%bb10_2, %bb10_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb10_24, %bb10_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x2034c
      %bb14_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb14_2 = "braid.const"() {value = -4294901761 : i64} : () -> i64
      %bb14_3 = "braid.and"(%bb14_0, %bb14_2) : (i64, i64) -> i64
      %bb14_4 = "braid.const"() {value = 1013841920 : i64} : () -> i64
      %bb14_5 = "braid.or"(%bb14_3, %bb14_4) : (i64, i64) -> i64
      "braid.set"(%bb14_5) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb18] : () -> ()
    ^bb18:  // 0x20350
      %bb18_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb18_2 = "braid.const"() {value = 128 : i64} : () -> i64
      %bb18_3 = "braid.add"(%bb18_0, %bb18_2) : (i64, i64) -> i64
      "braid.set"(%bb18_3) {reg = "x29"} : (i64) -> ()
      "braid_cf.br"()[^bb1c] : () -> ()
    ^bb1c:  // 0x20354
      %bb1c_0 = "braid.get"() {reg = "x24"} : () -> i64
      %bb1c_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bb1c_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb1c_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb1c_5 = "braid.and"(%bb1c_3, %bb1c_4) : (i64, i64) -> i64
      %bb1c_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb1c_7 = "braid.eq"(%bb1c_5, %bb1c_6) : (i64, i64) -> i64
      "braid.guard"(%bb1c_7) : (i64) -> ()
      %bb1c_8 = "braid.const"() {value = 160 : i64} : () -> i64
      %bb1c_2 = "braid.add"(%bb1c_3, %bb1c_8) : (i64, i64) -> i64
      %bb1c_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb1c_24 = "braid.add"(%bb1c_2, %bb1c_23) : (i64, i64) -> i64
      "braid.store"(%bb1c_2, %bb1c_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb1c_24, %bb1c_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x20358
      %bb20_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb20_2 = "braid.const"() {value = -281470681743361 : i64} : () -> i64
      %bb20_3 = "braid.and"(%bb20_0, %bb20_2) : (i64, i64) -> i64
      %bb20_4 = "braid.const"() {value = 269629456908288 : i64} : () -> i64
      %bb20_5 = "braid.or"(%bb20_3, %bb20_4) : (i64, i64) -> i64
      "braid.set"(%bb20_5) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x2035c
      %bb24_0 = "braid.const"() {value = 55723 : i64} : () -> i64
      "braid.set"(%bb24_0) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb28] : () -> ()
    ^bb28:  // 0x20360
      %bb28_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bb28_1 = "braid.get"() {reg = "x21"} : () -> i64
      %bb28_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb28_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb28_5 = "braid.and"(%bb28_3, %bb28_4) : (i64, i64) -> i64
      %bb28_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb28_7 = "braid.eq"(%bb28_5, %bb28_6) : (i64, i64) -> i64
      "braid.guard"(%bb28_7) : (i64) -> ()
      %bb28_8 = "braid.const"() {value = 176 : i64} : () -> i64
      %bb28_2 = "braid.add"(%bb28_3, %bb28_8) : (i64, i64) -> i64
      %bb28_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb28_24 = "braid.add"(%bb28_2, %bb28_23) : (i64, i64) -> i64
      "braid.store"(%bb28_2, %bb28_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb28_24, %bb28_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb2c] : () -> ()
    ^bb2c:  // 0x20364
      %bb2c_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb2c_2 = "braid.const"() {value = 281474976710655 : i64} : () -> i64
      %bb2c_3 = "braid.and"(%bb2c_0, %bb2c_2) : (i64, i64) -> i64
      %bb2c_4 = "braid.const"() {value = -6535004534291300352 : i64} : () -> i64
      %bb2c_5 = "braid.or"(%bb2c_3, %bb2c_4) : (i64, i64) -> i64
      "braid.set"(%bb2c_5) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb30] : () -> ()
    ^bb30:  // 0x20368
      %bb30_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb30_2 = "braid.const"() {value = -4294901761 : i64} : () -> i64
      %bb30_3 = "braid.and"(%bb30_0, %bb30_2) : (i64, i64) -> i64
      %bb30_4 = "braid.const"() {value = 528678912 : i64} : () -> i64
      %bb30_5 = "braid.or"(%bb30_3, %bb30_4) : (i64, i64) -> i64
      "braid.set"(%bb30_5) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb34] : () -> ()
    ^bb34:  // 0x2036c
      %bb34_0 = "braid.get"() {reg = "x20"} : () -> i64
      %bb34_1 = "braid.get"() {reg = "x19"} : () -> i64
      %bb34_3 = "braid.get"() {reg = "sp"} : () -> i64
      %bb34_4 = "braid.const"() {value = 15 : i64} : () -> i64
      %bb34_5 = "braid.and"(%bb34_3, %bb34_4) : (i64, i64) -> i64
      %bb34_6 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb34_7 = "braid.eq"(%bb34_5, %bb34_6) : (i64, i64) -> i64
      "braid.guard"(%bb34_7) : (i64) -> ()
      %bb34_8 = "braid.const"() {value = 192 : i64} : () -> i64
      %bb34_2 = "braid.add"(%bb34_3, %bb34_8) : (i64, i64) -> i64
      %bb34_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb34_24 = "braid.add"(%bb34_2, %bb34_23) : (i64, i64) -> i64
      "braid.store"(%bb34_2, %bb34_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb34_24, %bb34_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb38] : () -> ()
    ^bb38:  // 0x20370
      %bb38_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb38_2 = "braid.const"() {value = -281470681743361 : i64} : () -> i64
      %bb38_3 = "braid.and"(%bb38_0, %bb38_2) : (i64, i64) -> i64
      %bb38_4 = "braid.const"() {value = 225507257876480 : i64} : () -> i64
      %bb38_5 = "braid.or"(%bb38_3, %bb38_4) : (i64, i64) -> i64
      "braid.set"(%bb38_5) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb3c] : () -> ()
    ^bb3c:  // 0x20374
      %bb3c_1 = "braid.get"() {reg = "x8"} : () -> i64
      %bb3c_6 = "braid.const"() {value = 1232 : i64} : () -> i64
      %bb3c_0 = "braid.add"(%bb3c_1, %bb3c_6) : (i64, i64) -> i64
      %bb3c_30 = "braid.load"(%bb3c_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb3c_30) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb40] : () -> ()
    ^bb40:  // 0x20378
      %bb40_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb40_2 = "braid.const"() {value = 281474976710655 : i64} : () -> i64
      %bb40_3 = "braid.and"(%bb40_0, %bb40_2) : (i64, i64) -> i64
      %bb40_4 = "braid.const"() {value = 6620291452234629120 : i64} : () -> i64
      %bb40_5 = "braid.or"(%bb40_3, %bb40_4) : (i64, i64) -> i64
      "braid.set"(%bb40_5) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x2037c
      %bb44_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb44_30 = "braid.load"(%bb44_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb44_30) {reg = "x19"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x20380
      %bb48_0 = "braid.const"() {value = 58983 : i64} : () -> i64
      "braid.set"(%bb48_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb4c] : () -> ()
    ^bb4c:  // 0x20384
      %bb4c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb4c_2 = "braid.const"() {value = -4294901761 : i64} : () -> i64
      %bb4c_3 = "braid.and"(%bb4c_0, %bb4c_2) : (i64, i64) -> i64
      %bb4c_4 = "braid.const"() {value = 1778974720 : i64} : () -> i64
      %bb4c_5 = "braid.or"(%bb4c_3, %bb4c_4) : (i64, i64) -> i64
      "braid.set"(%bb4c_5) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb50] : () -> ()
    ^bb50:  // 0x20388
      %bb50_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb50_2 = "braid.const"() {value = -281470681743361 : i64} : () -> i64
      %bb50_3 = "braid.and"(%bb50_0, %bb50_2) : (i64, i64) -> i64
      %bb50_4 = "braid.const"() {value = 191886253883392 : i64} : () -> i64
      %bb50_5 = "braid.or"(%bb50_3, %bb50_4) : (i64, i64) -> i64
      "braid.set"(%bb50_5) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb54] : () -> ()
    ^bb54:  // 0x2038c
      %bb54_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb54_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb54_3 = "braid.add"(%bb54_0, %bb54_2) : (i64, i64) -> i64
      "braid.set"(%bb54_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb58] : () -> ()
    ^bb58:  // 0x20390
      %bb58_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb58_2 = "braid.const"() {value = 281474976710655 : i64} : () -> i64
      %bb58_3 = "braid.and"(%bb58_0, %bb58_2) : (i64, i64) -> i64
      %bb58_4 = "braid.const"() {value = -4942982066015830016 : i64} : () -> i64
      %bb58_5 = "braid.or"(%bb58_3, %bb58_4) : (i64, i64) -> i64
      "braid.set"(%bb58_5) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb5c] : () -> ()
    ^bb5c:  // 0x20394
      %bb5c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb5c_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb5c_3 = "braid.get"() {reg = "x29"} : () -> i64
      %bb5c_8 = "braid.const"() {value = -32 : i64} : () -> i64
      %bb5c_2 = "braid.add"(%bb5c_3, %bb5c_8) : (i64, i64) -> i64
      %bb5c_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb5c_24 = "braid.add"(%bb5c_2, %bb5c_23) : (i64, i64) -> i64
      "braid.store"(%bb5c_2, %bb5c_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb5c_24, %bb5c_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb60] : () -> ()
    ^bb60:  // 0x20398
      %bb60_0 = "braid.const"() {value = 21119 : i64} : () -> i64
      "braid.set"(%bb60_0) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb64] : () -> ()
    ^bb64:  // 0x2039c
      %bb64_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb64_2 = "braid.const"() {value = -64 : i64} : () -> i64
      %bb64_3 = "braid.and"(%bb64_0, %bb64_2) : (i64, i64) -> i64
      "braid.set"(%bb64_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x203a0
      %bb68_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb68_2 = "braid.const"() {value = -4294901761 : i64} : () -> i64
      %bb68_3 = "braid.and"(%bb68_0, %bb68_2) : (i64, i64) -> i64
      %bb68_4 = "braid.const"() {value = 1359872000 : i64} : () -> i64
      %bb68_5 = "braid.or"(%bb68_3, %bb68_4) : (i64, i64) -> i64
      "braid.set"(%bb68_5) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb6c] : () -> ()
    ^bb6c:  // 0x203a4
      %bb6c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb6c_2 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb6c_3 = "braid.add"(%bb6c_0, %bb6c_2) : (i64, i64) -> i64
      %bb6c_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6c_4 = "braid.slt"(%bb6c_3, %bb6c_8) : (i64, i64) -> i64
      %bb6c_5 = "braid.eq"(%bb6c_3, %bb6c_8) : (i64, i64) -> i64
      %bb6c_6 = "braid.ult"(%bb6c_3, %bb6c_0) : (i64, i64) -> i64
      %bb6c_9 = "braid.xor"(%bb6c_0, %bb6c_3) : (i64, i64) -> i64
      %bb6c_10 = "braid.xor"(%bb6c_2, %bb6c_3) : (i64, i64) -> i64
      %bb6c_11 = "braid.and"(%bb6c_9, %bb6c_10) : (i64, i64) -> i64
      %bb6c_7 = "braid.slt"(%bb6c_11, %bb6c_8) : (i64, i64) -> i64
      "braid.setf"(%bb6c_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb6c_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb6c_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb6c_7) {flag = "v"} : (i64) -> ()
      "braid.set"(%bb6c_3) {reg = "x20"} : (i64) -> ()
      "braid_cf.br"()[^bb70] : () -> ()
    ^bb70:  // 0x203a8
      %bb70_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb70_2 = "braid.const"() {value = -281470681743361 : i64} : () -> i64
      %bb70_3 = "braid.and"(%bb70_0, %bb70_2) : (i64, i64) -> i64
      %bb70_4 = "braid.const"() {value = 114950504710144 : i64} : () -> i64
      %bb70_5 = "braid.or"(%bb70_3, %bb70_4) : (i64, i64) -> i64
      "braid.set"(%bb70_5) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb74] : () -> ()
    ^bb74:  // 0x203ac
      %bb74_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb74_2 = "braid.const"() {value = 281474976710655 : i64} : () -> i64
      %bb74_3 = "braid.and"(%bb74_0, %bb74_2) : (i64, i64) -> i64
      %bb74_4 = "braid.const"() {value = -7276409622947168256 : i64} : () -> i64
      %bb74_5 = "braid.or"(%bb74_3, %bb74_4) : (i64, i64) -> i64
      "braid.set"(%bb74_5) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb78] : () -> ()
    ^bb78:  // 0x203b0
      %bb78_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bb78_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb78_3 = "braid.get"() {reg = "x29"} : () -> i64
      %bb78_8 = "braid.const"() {value = -16 : i64} : () -> i64
      %bb78_2 = "braid.add"(%bb78_3, %bb78_8) : (i64, i64) -> i64
      %bb78_23 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb78_24 = "braid.add"(%bb78_2, %bb78_23) : (i64, i64) -> i64
      "braid.store"(%bb78_2, %bb78_0) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid.store"(%bb78_24, %bb78_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb7c] : () -> ()
    ^bb7c:  // 0x203b4
      %bb7c_0 = "braid.getf"() {flag = "z"} : () -> i64
      "braid_cf.cond_br"(%bb7c_0)[^bb148, ^bb80] : (i64) -> ()
    ^bb80:  // 0x203b8
      %bb80_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb80_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb80_20 = "braid.shl"(%bb80_0, %bb80_3) : (i64, i64) -> i64
      "braid.set"(%bb80_20) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb84] : () -> ()
    ^bb84:  // 0x203bc
      %bb84_0 = "braid.const"() {value = 131072 : i64} : () -> i64
      "braid.set"(%bb84_0) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb88] : () -> ()
    ^bb88:  // 0x203c0
      %bb88_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb88_3 = "braid.const"() {value = 3 : i64} : () -> i64
      %bb88_20 = "braid.shl"(%bb88_0, %bb88_3) : (i64, i64) -> i64
      "braid.set"(%bb88_20) {reg = "x22"} : (i64) -> ()
      "braid_cf.br"()[^bb8c] : () -> ()
    ^bb8c:  // 0x203c4
      %bb8c_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bb8c_6 = "braid.const"() {value = 1240 : i64} : () -> i64
      %bb8c_0 = "braid.add"(%bb8c_1, %bb8c_6) : (i64, i64) -> i64
      %bb8c_30 = "braid.load"(%bb8c_0) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb8c_30) {reg = "x23"} : (i64) -> ()
      "braid_cf.br"()[^bb90] : () -> ()
    ^bb90:  // 0x203c8
      %bb90_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb90_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb90_12 = "braid.or"(%bb90_0, %bb90_2) : (i64, i64) -> i64
      "braid.set"(%bb90_12) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x203cc
      %bb94_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb94_2 = "braid.const"() {value = 56 : i64} : () -> i64
      %bb94_3 = "braid.or"(%bb94_0, %bb94_2) : (i64, i64) -> i64
      "braid.set"(%bb94_3) {reg = "x24"} : (i64) -> ()
      "braid_cf.br"()[^bb98] : () -> ()
    ^bb98:  // 0x203d0
      %bb98_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb98_2 = "braid.const"() {value = 504 : i64} : () -> i64
      %bb98_3 = "braid.or"(%bb98_0, %bb98_2) : (i64, i64) -> i64
      "braid.set"(%bb98_3) {reg = "x25"} : (i64) -> ()
      "braid_cf.br"()[^bb9c] : () -> ()
    ^bb9c:  // 0x203d4
      %bb9c_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb9c_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb9c_3 = "braid.add"(%bb9c_0, %bb9c_2) : (i64, i64) -> i64
      "braid.set"(%bb9c_3) {reg = "x26"} : (i64) -> ()
      "braid_cf.br"()[^bba0] : () -> ()
    ^bba0:  // 0x203d8
      "braid_cf.br"()[^bbc0] : () -> ()
    ^bba4:  // 0x203dc
      %bba4_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bba4_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bba4_3 = "braid.sub"(%bba4_0, %bba4_2) : (i64, i64) -> i64
      "braid.set"(%bba4_3) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bba8] : () -> ()
    ^bba8:  // 0x203e0
      %bba8_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bba8_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bba8_3 = "braid.add"(%bba8_0, %bba8_2) : (i64, i64) -> i64
      "braid.set"(%bba8_3) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bbac] : () -> ()
    ^bbac:  // 0x203e4
      %bbac_0 = "braid.const"() {value = 132072 : i64} : () -> i64
      "braid.set"(%bbac_0) {reg = "x30"} : (i64) -> ()
      "braid_cf.br"()[^ext100bc] : () -> ()
    ^bbb0:  // 0x203e8
      %bbb0_0 = "braid.get"() {reg = "x21"} : () -> i64
      %bbb0_2 = "braid.const"() {value = 64 : i64} : () -> i64
      %bbb0_3 = "braid.add"(%bbb0_0, %bbb0_2) : (i64, i64) -> i64
      "braid.set"(%bbb0_3) {reg = "x21"} : (i64) -> ()
      "braid_cf.br"()[^bbb4] : () -> ()
    ^bbb4:  // 0x203ec
      %bbb4_0 = "braid.get"() {reg = "x25"} : () -> i64
      %bbb4_2 = "braid.const"() {value = 512 : i64} : () -> i64
      %bbb4_3 = "braid.sub"(%bbb4_0, %bbb4_2) : (i64, i64) -> i64
      "braid.set"(%bbb4_3) {reg = "x25"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x203f0
      %bbb8_0 = "braid.get"() {reg = "x21"} : () -> i64
      %bbb8_2 = "braid.get"() {reg = "x20"} : () -> i64
      %bbb8_12 = "braid.sub"(%bbb8_0, %bbb8_2) : (i64, i64) -> i64
      %bbb8_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbb8_13 = "braid.slt"(%bbb8_12, %bbb8_17) : (i64, i64) -> i64
      %bbb8_14 = "braid.eq"(%bbb8_0, %bbb8_2) : (i64, i64) -> i64
      %bbb8_15 = "braid.ule"(%bbb8_2, %bbb8_0) : (i64, i64) -> i64
      %bbb8_18 = "braid.xor"(%bbb8_0, %bbb8_2) : (i64, i64) -> i64
      %bbb8_19 = "braid.xor"(%bbb8_0, %bbb8_12) : (i64, i64) -> i64
      %bbb8_20 = "braid.and"(%bbb8_18, %bbb8_19) : (i64, i64) -> i64
      %bbb8_16 = "braid.slt"(%bbb8_20, %bbb8_17) : (i64, i64) -> i64
      "braid.setf"(%bbb8_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bbb8_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bbb8_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bbb8_16) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bbbc] : () -> ()
    ^bbbc:  // 0x203f4
      %bbbc_0 = "braid.getf"() {flag = "c"} : () -> i64
      "braid_cf.cond_br"(%bbbc_0)[^bb148, ^bbc0] : (i64) -> ()
    ^bbc0:  // 0x203f8
      %bbc0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc0_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc0_12 = "braid.or"(%bbc0_0, %bbc0_2) : (i64, i64) -> i64
      "braid.set"(%bbc0_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x203fc
      %bbc4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc4_2 = "braid.get"() {reg = "x21"} : () -> i64
      %bbc4_12 = "braid.or"(%bbc4_0, %bbc4_2) : (i64, i64) -> i64
      "braid.set"(%bbc4_12) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbc8] : () -> ()
    ^bbc8:  // 0x20400
      %bbc8_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc8_2 = "braid.get"() {reg = "x25"} : () -> i64
      %bbc8_12 = "braid.or"(%bbc8_0, %bbc8_2) : (i64, i64) -> i64
      "braid.set"(%bbc8_12) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbcc] : () -> ()
    ^bbcc:  // 0x20404
      "braid_cf.br"()[^bbe8] : () -> ()
    ^bbd0:  // 0x20408
      %bbd0_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bbd0_2 = "braid.get"() {reg = "x26"} : () -> i64
      %bbd0_8 = "braid.get"() {reg = "x8"} : () -> i64
      %bbd0_9 = "braid.const"() {value = 2 : i64} : () -> i64
      %bbd0_7 = "braid.shl"(%bbd0_8, %bbd0_9) : (i64, i64) -> i64
      %bbd0_1 = "braid.add"(%bbd0_2, %bbd0_7) : (i64, i64) -> i64
      "braid.store"(%bbd0_1, %bbd0_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbd4] : () -> ()
    ^bbd4:  // 0x2040c
      %bbd4_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bbd4_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbd4_3 = "braid.add"(%bbd4_0, %bbd4_2) : (i64, i64) -> i64
      "braid.set"(%bbd4_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bbd8] : () -> ()
    ^bbd8:  // 0x20410
      %bbd8_0 = "braid.get"() {reg = "x10"} : () -> i64
      %bbd8_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbd8_3 = "braid.sub"(%bbd8_0, %bbd8_2) : (i64, i64) -> i64
      "braid.set"(%bbd8_3) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bbdc] : () -> ()
    ^bbdc:  // 0x20414
      %bbdc_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bbdc_2 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbdc_3 = "braid.sub"(%bbdc_0, %bbdc_2) : (i64, i64) -> i64
      %bbdc_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbdc_4 = "braid.slt"(%bbdc_3, %bbdc_8) : (i64, i64) -> i64
      %bbdc_5 = "braid.eq"(%bbdc_0, %bbdc_2) : (i64, i64) -> i64
      %bbdc_6 = "braid.ule"(%bbdc_2, %bbdc_0) : (i64, i64) -> i64
      %bbdc_9 = "braid.xor"(%bbdc_0, %bbdc_2) : (i64, i64) -> i64
      %bbdc_10 = "braid.xor"(%bbdc_0, %bbdc_3) : (i64, i64) -> i64
      %bbdc_11 = "braid.and"(%bbdc_9, %bbdc_10) : (i64, i64) -> i64
      %bbdc_7 = "braid.slt"(%bbdc_11, %bbdc_8) : (i64, i64) -> i64
      "braid.setf"(%bbdc_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bbdc_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bbdc_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bbdc_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bbe0] : () -> ()
    ^bbe0:  // 0x20418
      %bbe0_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bbe0_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bbe0_3 = "braid.add"(%bbe0_0, %bbe0_2) : (i64, i64) -> i64
      "braid.set"(%bbe0_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x2041c
      %bbe4_0 = "braid.getf"() {flag = "z"} : () -> i64
      "braid_cf.cond_br"(%bbe4_0)[^bba4, ^bbe8] : (i64) -> ()
    ^bbe8:  // 0x20420
      %bbe8_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe8_0 = "braid.zext"(%bbe8_1) {bits = 32 : i64} : (i64) -> i64
      %bbe8_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe8_2 = "braid.zext"(%bbe8_3) {bits = 32 : i64} : (i64) -> i64
      %bbe8_12 = "braid.or"(%bbe8_0, %bbe8_2) : (i64, i64) -> i64
      "braid.set"(%bbe8_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bbec] : () -> ()
    ^bbec:  // 0x20424
      %bbec_0 = "braid.const"() {value = -32 : i64} : () -> i64
      "braid.set"(%bbec_0) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bbf0] : () -> ()
    ^bbf0:  // 0x20428
      %bbf0_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf0_2 = "braid.get"() {reg = "x9"} : () -> i64
      %bbf0_12 = "braid.or"(%bbf0_0, %bbf0_2) : (i64, i64) -> i64
      "braid.set"(%bbf0_12) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bbf4] : () -> ()
    ^bbf4:  // 0x2042c
      %bbf4_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf4_2 = "braid.get"() {reg = "x10"} : () -> i64
      %bbf4_12 = "braid.or"(%bbf4_0, %bbf4_2) : (i64, i64) -> i64
      "braid.set"(%bbf4_12) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bbf8] : () -> ()
    ^bbf8:  // 0x20430
      "braid_cf.br"()[^bb114] : () -> ()
    ^bbfc:  // 0x20434
      %bbfc_1 = "braid.get"() {reg = "x23"} : () -> i64
      %bbfc_6 = "braid.get"() {reg = "x13"} : () -> i64
      %bbfc_0 = "braid.add"(%bbfc_1, %bbfc_6) : (i64, i64) -> i64
      %bbfc_30 = "braid.load"(%bbfc_0) {bytes = 1 : i64} : (i64) -> i64
      "braid.set"(%bbfc_30) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb100:  // 0x20438
      %bb100_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb100_0 = "braid.zext"(%bb100_1) {bits = 32 : i64} : (i64) -> i64
      %bb100_3 = "braid.get"() {reg = "x11"} : () -> i64
      %bb100_4 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb100_5 = "braid.shl"(%bb100_3, %bb100_4) : (i64, i64) -> i64
      %bb100_2 = "braid.zext"(%bb100_5) {bits = 32 : i64} : (i64) -> i64
      %bb100_12 = "braid.or"(%bb100_0, %bb100_2) : (i64, i64) -> i64
      "braid.set"(%bb100_12) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb104] : () -> ()
    ^bb104:  // 0x2043c
      %bb104_0 = "braid.get"() {reg = "x12"} : () -> i64
      %bb104_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb104_3 = "braid.add"(%bb104_0, %bb104_2) : (i64, i64) -> i64
      "braid.set"(%bb104_3) {reg = "x12"} : (i64) -> ()
      "braid_cf.br"()[^bb108] : () -> ()
    ^bb108:  // 0x20440
      %bb108_0 = "braid.get"() {reg = "x14"} : () -> i64
      %bb108_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb108_3 = "braid.sub"(%bb108_0, %bb108_2) : (i64, i64) -> i64
      "braid.set"(%bb108_3) {reg = "x14"} : (i64) -> ()
      "braid_cf.br"()[^bb10c] : () -> ()
    ^bb10c:  // 0x20444
      %bb10c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb10c_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb10c_3 = "braid.add"(%bb10c_0, %bb10c_2) : (i64, i64) -> i64
      "braid.set"(%bb10c_3) {reg = "x13"} : (i64) -> ()
      "braid_cf.br"()[^bb110] : () -> ()
    ^bb110:  // 0x20448
      %bb110_0 = "braid.get"() {reg = "x12"} : () -> i64
      "braid_cf.cond_br"(%bb110_0)[^bb114, ^bbd0] : (i64) -> ()
    ^bb114:  // 0x2044c
      %bb114_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb114_2 = "braid.get"() {reg = "x19"} : () -> i64
      %bb114_12 = "braid.sub"(%bb114_0, %bb114_2) : (i64, i64) -> i64
      %bb114_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb114_13 = "braid.slt"(%bb114_12, %bb114_17) : (i64, i64) -> i64
      %bb114_14 = "braid.eq"(%bb114_0, %bb114_2) : (i64, i64) -> i64
      %bb114_15 = "braid.ule"(%bb114_2, %bb114_0) : (i64, i64) -> i64
      %bb114_18 = "braid.xor"(%bb114_0, %bb114_2) : (i64, i64) -> i64
      %bb114_19 = "braid.xor"(%bb114_0, %bb114_12) : (i64, i64) -> i64
      %bb114_20 = "braid.and"(%bb114_18, %bb114_19) : (i64, i64) -> i64
      %bb114_16 = "braid.slt"(%bb114_20, %bb114_17) : (i64, i64) -> i64
      "braid.setf"(%bb114_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb114_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb114_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb114_16) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb118] : () -> ()
    ^bb118:  // 0x20450
      %bb118_1 = "braid.getf"() {flag = "c"} : () -> i64
      %bb118_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb118_0 = "braid.eq"(%bb118_1, %bb118_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb118_0)[^bbfc, ^bb11c] : (i64) -> ()
    ^bb11c:  // 0x20454
      %bb11c_0 = "braid.get"() {reg = "x19"} : () -> i64
      %bb11c_2 = "braid.get"() {reg = "x13"} : () -> i64
      %bb11c_12 = "braid.sub"(%bb11c_0, %bb11c_2) : (i64, i64) -> i64
      %bb11c_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb11c_13 = "braid.slt"(%bb11c_12, %bb11c_17) : (i64, i64) -> i64
      %bb11c_14 = "braid.eq"(%bb11c_0, %bb11c_2) : (i64, i64) -> i64
      %bb11c_15 = "braid.ule"(%bb11c_2, %bb11c_0) : (i64, i64) -> i64
      %bb11c_18 = "braid.xor"(%bb11c_0, %bb11c_2) : (i64, i64) -> i64
      %bb11c_19 = "braid.xor"(%bb11c_0, %bb11c_12) : (i64, i64) -> i64
      %bb11c_20 = "braid.and"(%bb11c_18, %bb11c_19) : (i64, i64) -> i64
      %bb11c_16 = "braid.slt"(%bb11c_20, %bb11c_17) : (i64, i64) -> i64
      "braid.setf"(%bb11c_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb11c_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb11c_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb11c_16) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb120] : () -> ()
    ^bb120:  // 0x20458
      %bb120_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb120_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb120_0 = "braid.eq"(%bb120_1, %bb120_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb120_0)[^bb12c, ^bb124] : (i64) -> ()
    ^bb124:  // 0x2045c
      %bb124_0 = "braid.const"() {value = 128 : i64} : () -> i64
      "braid.set"(%bb124_0) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb128] : () -> ()
    ^bb128:  // 0x20460
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb12c:  // 0x20464
      %bb12c_0 = "braid.get"() {reg = "x13"} : () -> i64
      %bb12c_2 = "braid.get"() {reg = "x24"} : () -> i64
      %bb12c_12 = "braid.sub"(%bb12c_0, %bb12c_2) : (i64, i64) -> i64
      %bb12c_17 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb12c_13 = "braid.slt"(%bb12c_12, %bb12c_17) : (i64, i64) -> i64
      %bb12c_14 = "braid.eq"(%bb12c_0, %bb12c_2) : (i64, i64) -> i64
      %bb12c_15 = "braid.ule"(%bb12c_2, %bb12c_0) : (i64, i64) -> i64
      %bb12c_18 = "braid.xor"(%bb12c_0, %bb12c_2) : (i64, i64) -> i64
      %bb12c_19 = "braid.xor"(%bb12c_0, %bb12c_12) : (i64, i64) -> i64
      %bb12c_20 = "braid.and"(%bb12c_18, %bb12c_19) : (i64, i64) -> i64
      %bb12c_16 = "braid.slt"(%bb12c_20, %bb12c_17) : (i64, i64) -> i64
      "braid.setf"(%bb12c_13) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb12c_14) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb12c_15) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb12c_16) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb130] : () -> ()
    ^bb130:  // 0x20468
      %bb130_0 = "braid.getf"() {flag = "c"} : () -> i64
      "braid_cf.cond_br"(%bb130_0)[^bb13c, ^bb134] : (i64) -> ()
    ^bb134:  // 0x2046c
      %bb134_1 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb134_0 = "braid.zext"(%bb134_1) {bits = 32 : i64} : (i64) -> i64
      %bb134_3 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb134_2 = "braid.zext"(%bb134_3) {bits = 32 : i64} : (i64) -> i64
      %bb134_12 = "braid.or"(%bb134_0, %bb134_2) : (i64, i64) -> i64
      "braid.set"(%bb134_12) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb138] : () -> ()
    ^bb138:  // 0x20470
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb13c:  // 0x20474
      %bb13c_0 = "braid.get"() {reg = "x22"} : () -> i64
      %bb13c_1 = "braid.get"() {reg = "x14"} : () -> i64
      %bb13c_2 = "braid.const"() {value = 63 : i64} : () -> i64
      %bb13c_3 = "braid.and"(%bb13c_1, %bb13c_2) : (i64, i64) -> i64
      %bb13c_9 = "braid.lshr"(%bb13c_0, %bb13c_3) : (i64, i64) -> i64
      "braid.set"(%bb13c_9) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb140] : () -> ()
    ^bb140:  // 0x20478
      %bb140_1 = "braid.get"() {reg = "x15"} : () -> i64
      %bb140_0 = "braid.zext"(%bb140_1) {bits = 32 : i64} : (i64) -> i64
      %bb140_2 = "braid.const"() {value = 255 : i64} : () -> i64
      %bb140_3 = "braid.and"(%bb140_0, %bb140_2) : (i64, i64) -> i64
      "braid.set"(%bb140_3) {reg = "x15"} : (i64) -> ()
      "braid_cf.br"()[^bb144] : () -> ()
    ^bb144:  // 0x2047c
      "braid_cf.br"()[^bb100] : () -> ()
    ^bb148:  // 0x20480
      %bb148_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb148_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb148_3 = "braid.add"(%bb148_0, %bb148_2) : (i64, i64) -> i64
      "braid.set"(%bb148_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb14c] : () -> ()
    ^bb14c:  // 0x20484
      %bb14c_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14c_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14c_12 = "braid.or"(%bb14c_0, %bb14c_2) : (i64, i64) -> i64
      "braid.set"(%bb14c_12) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb150] : () -> ()
    ^bb150:  // 0x20488
      %bb150_0 = "braid.get"() {reg = "x29"} : () -> i64
      %bb150_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb150_3 = "braid.sub"(%bb150_0, %bb150_2) : (i64, i64) -> i64
      "braid.set"(%bb150_3) {reg = "x10"} : (i64) -> ()
      "braid_cf.br"()[^bb154] : () -> ()
    ^bb154:  // 0x2048c
      %bb154_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb154_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb154_3 = "braid.add"(%bb154_0, %bb154_2) : (i64, i64) -> i64
      "braid.set"(%bb154_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb158] : () -> ()
    ^bb158:  // 0x20490
      %bb158_1 = "braid.get"() {reg = "x10"} : () -> i64
      %bb158_7 = "braid.get"() {reg = "x8"} : () -> i64
      %bb158_8 = "braid.const"() {value = 2 : i64} : () -> i64
      %bb158_6 = "braid.shl"(%bb158_7, %bb158_8) : (i64, i64) -> i64
      %bb158_0 = "braid.add"(%bb158_1, %bb158_6) : (i64, i64) -> i64
      %bb158_30 = "braid.load"(%bb158_0) {bytes = 4 : i64} : (i64) -> i64
      "braid.set"(%bb158_30) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb15c] : () -> ()
    ^bb15c:  // 0x20494
      %bb15c_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb15c_2 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb15c_3 = "braid.add"(%bb15c_0, %bb15c_2) : (i64, i64) -> i64
      "braid.set"(%bb15c_3) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb160] : () -> ()
    ^bb160:  // 0x20498
      %bb160_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb160_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb160_3 = "braid.sub"(%bb160_0, %bb160_2) : (i64, i64) -> i64
      %bb160_8 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb160_4 = "braid.slt"(%bb160_3, %bb160_8) : (i64, i64) -> i64
      %bb160_5 = "braid.eq"(%bb160_0, %bb160_2) : (i64, i64) -> i64
      %bb160_6 = "braid.ule"(%bb160_2, %bb160_0) : (i64, i64) -> i64
      %bb160_9 = "braid.xor"(%bb160_0, %bb160_2) : (i64, i64) -> i64
      %bb160_10 = "braid.xor"(%bb160_0, %bb160_3) : (i64, i64) -> i64
      %bb160_11 = "braid.and"(%bb160_9, %bb160_10) : (i64, i64) -> i64
      %bb160_7 = "braid.slt"(%bb160_11, %bb160_8) : (i64, i64) -> i64
      "braid.setf"(%bb160_4) {flag = "n"} : (i64) -> ()
      "braid.setf"(%bb160_5) {flag = "z"} : (i64) -> ()
      "braid.setf"(%bb160_6) {flag = "c"} : (i64) -> ()
      "braid.setf"(%bb160_7) {flag = "v"} : (i64) -> ()
      "braid_cf.br"()[^bb164] : () -> ()
    ^bb164:  // 0x2049c
      %bb164_1 = "braid.get"() {reg = "x11"} : () -> i64
      %bb164_0 = "braid.zext"(%bb164_1) {bits = 32 : i64} : (i64) -> i64
      %bb164_1 = "braid.bswap"(%bb164_0) : (i64) -> i64
      %bb164_2 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb164_9 = "braid.lshr"(%bb164_1, %bb164_2) : (i64, i64) -> i64
      "braid.set"(%bb164_9) {reg = "x11"} : (i64) -> ()
      "braid_cf.br"()[^bb168] : () -> ()
    ^bb168:  // 0x204a0
      %bb168_0 = "braid.get"() {reg = "x11"} : () -> i64
      %bb168_2 = "braid.get"() {reg = "x9"} : () -> i64
      %bb168_7 = "braid.const"() {value = -1 : i64} : () -> i64
      %bb168_1 = "braid.add"(%bb168_2, %bb168_7) : (i64, i64) -> i64
      "braid.store"(%bb168_1, %bb168_0) {bytes = 4 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb16c] : () -> ()
    ^bb16c:  // 0x204a4
      %bb16c_0 = "braid.get"() {reg = "x9"} : () -> i64
      %bb16c_2 = "braid.const"() {value = 4 : i64} : () -> i64
      %bb16c_3 = "braid.add"(%bb16c_0, %bb16c_2) : (i64, i64) -> i64
      "braid.set"(%bb16c_3) {reg = "x9"} : (i64) -> ()
      "braid_cf.br"()[^bb170] : () -> ()
    ^bb170:  // 0x204a8
      %bb170_1 = "braid.getf"() {flag = "z"} : () -> i64
      %bb170_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb170_0 = "braid.eq"(%bb170_1, %bb170_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bb170_0)[^bb158, ^bb174] : (i64) -> ()
    ^bb174:  // 0x204ac
      %bb174_0 = "braid.const"() {value = 1 : i64} : () -> i64
      "braid.set"(%bb174_0) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb178] : () -> ()
    ^bb178:  // 0x204b0
      %bb178_0 = "braid.get"() {reg = "sp"} : () -> i64
      %bb178_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb178_3 = "braid.add"(%bb178_0, %bb178_2) : (i64, i64) -> i64
      "braid.set"(%bb178_3) {reg = "x1"} : (i64) -> ()
      "braid_cf.br"()[^bb17c] : () -> ()
    ^bb17c:  // 0x204b4
      %bb17c_0 = "braid.const"() {value = 32 : i64} : () -> i64
      "braid.set"(%bb17c_0) {reg = "x2"} : (i64) -> ()
      "braid_cf.br"()[^bb180] : () -> ()
    ^bb180:  // 0x204b8
      %bb180_0 = "braid.const"() {value = 64 : i64} : () -> i64
      "braid.set"(%bb180_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb184] : () -> ()
    ^bb184:  // 0x204bc
      %bb184_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb184_1 = "braid.const"() {value = 93 : i64} : () -> i64
      %bb184_2 = "braid.eq"(%bb184_0, %bb184_1) : (i64, i64) -> i64
      %bb184_3 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb184_4 = "braid.eq"(%bb184_0, %bb184_3) : (i64, i64) -> i64
      %bb184_5 = "braid.or"(%bb184_2, %bb184_4) : (i64, i64) -> i64
      "braid.guard"(%bb184_5) : (i64) -> ()
      %bb184_6 = "braid.get"() {reg = "x0"} : () -> i64
      %bb184_7 = "braid.get"() {reg = "x1"} : () -> i64
      %bb184_8 = "braid.get"() {reg = "x2"} : () -> i64
      %bb184_9 = "braid.zext"(%bb184_6) {bits = 32 : i64} : (i64) -> i64
      %bb184_10 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb184_11 = "braid.eq"(%bb184_9, %bb184_10) : (i64, i64) -> i64
      %bb184_12 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb184_13 = "braid.ne"(%bb184_8, %bb184_12) : (i64, i64) -> i64
      %bb184_14 = "braid.const"() {value = 2147479552 : i64} : () -> i64
      %bb184_15 = "braid.ule"(%bb184_8, %bb184_14) : (i64, i64) -> i64
      %bb184_16 = "braid.const"() {value = 281474976710656 : i64} : () -> i64
      %bb184_17 = "braid.sub"(%bb184_16, %bb184_8) : (i64, i64) -> i64
      %bb184_18 = "braid.ule"(%bb184_7, %bb184_17) : (i64, i64) -> i64
      %bb184_19 = "braid.and"(%bb184_11, %bb184_13) : (i64, i64) -> i64
      %bb184_20 = "braid.and"(%bb184_19, %bb184_15) : (i64, i64) -> i64
      %bb184_21 = "braid.and"(%bb184_20, %bb184_18) : (i64, i64) -> i64
      %bb184_22 = "braid.or"(%bb184_2, %bb184_21) : (i64, i64) -> i64
      "braid.guard"(%bb184_22) : (i64) -> ()
      %bb184_23 = "braid.select"(%bb184_4, %bb184_8, %bb184_12) : (i64, i64, i64) -> i64
      "braid.out"(%bb184_7, %bb184_23) : (i64, i64) -> ()
      %bb184_24 = "braid.select"(%bb184_4, %bb184_8, %bb184_6) : (i64, i64, i64) -> i64
      "braid.set"(%bb184_24) {reg = "x0"} : (i64) -> ()
      "braid_cf.exit"(%bb184_2, %bb184_6)[^bb184, ^bb188] : (i64, i64) -> ()
    ^bb188:  // 0x204c0
      %bb188_0 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb188_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb188_12 = "braid.or"(%bb188_0, %bb188_2) : (i64, i64) -> i64
      "braid.set"(%bb188_12) {reg = "x0"} : (i64) -> ()
      "braid_cf.br"()[^bb18c] : () -> ()
    ^bb18c:  // 0x204c4
      %bb18c_0 = "braid.const"() {value = 93 : i64} : () -> i64
      "braid.set"(%bb18c_0) {reg = "x8"} : (i64) -> ()
      "braid_cf.br"()[^bb190] : () -> ()
    ^bb190:  // 0x204c8
      %bb190_0 = "braid.get"() {reg = "x8"} : () -> i64
      %bb190_1 = "braid.const"() {value = 93 : i64} : () -> i64
      %bb190_2 = "braid.eq"(%bb190_0, %bb190_1) : (i64, i64) -> i64
      %bb190_3 = "braid.const"() {value = 64 : i64} : () -> i64
      %bb190_4 = "braid.eq"(%bb190_0, %bb190_3) : (i64, i64) -> i64
      %bb190_5 = "braid.or"(%bb190_2, %bb190_4) : (i64, i64) -> i64
      "braid.guard"(%bb190_5) : (i64) -> ()
      %bb190_6 = "braid.get"() {reg = "x0"} : () -> i64
      %bb190_7 = "braid.get"() {reg = "x1"} : () -> i64
      %bb190_8 = "braid.get"() {reg = "x2"} : () -> i64
      %bb190_9 = "braid.zext"(%bb190_6) {bits = 32 : i64} : (i64) -> i64
      %bb190_10 = "braid.const"() {value = 1 : i64} : () -> i64
      %bb190_11 = "braid.eq"(%bb190_9, %bb190_10) : (i64, i64) -> i64
      %bb190_12 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb190_13 = "braid.ne"(%bb190_8, %bb190_12) : (i64, i64) -> i64
      %bb190_14 = "braid.const"() {value = 2147479552 : i64} : () -> i64
      %bb190_15 = "braid.ule"(%bb190_8, %bb190_14) : (i64, i64) -> i64
      %bb190_16 = "braid.const"() {value = 281474976710656 : i64} : () -> i64
      %bb190_17 = "braid.sub"(%bb190_16, %bb190_8) : (i64, i64) -> i64
      %bb190_18 = "braid.ule"(%bb190_7, %bb190_17) : (i64, i64) -> i64
      %bb190_19 = "braid.and"(%bb190_11, %bb190_13) : (i64, i64) -> i64
      %bb190_20 = "braid.and"(%bb190_19, %bb190_15) : (i64, i64) -> i64
      %bb190_21 = "braid.and"(%bb190_20, %bb190_18) : (i64, i64) -> i64
      %bb190_22 = "braid.or"(%bb190_2, %bb190_21) : (i64, i64) -> i64
      "braid.guard"(%bb190_22) : (i64) -> ()
      %bb190_23 = "braid.select"(%bb190_4, %bb190_8, %bb190_12) : (i64, i64, i64) -> i64
      "braid.out"(%bb190_7, %bb190_23) : (i64, i64) -> ()
      %bb190_24 = "braid.select"(%bb190_4, %bb190_8, %bb190_6) : (i64, i64, i64) -> i64
      "braid.set"(%bb190_24) {reg = "x0"} : (i64) -> ()
      "braid_cf.exit"(%bb190_2, %bb190_6)[^bb190, ^ext204cc] : (i64, i64) -> ()
    ^ext100bc:
      "braid_cf.tail"() {target = 65724 : i64} : () -> ()
  }) {sym_name = "main", entry = 131896 : i64} : () -> ()
}) {arch = "aarch64"} : () -> ()
