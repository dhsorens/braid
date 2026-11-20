"braid_cf.module"() ({
  "braid_cf.func"() ({
      "braid_cf.br"()[^bb0] : () -> ()
    ^bb0:  // 0x401000
      %bb0_8 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb0_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb0_25 = "braid.add"(%bb0_8, %bb0_24) : (i64, i64) -> i64
      %bb0_0 = "braid.load"(%bb0_25) {bytes = 8 : i64} : (i64) -> i64
      %bb0_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb0_27 = "braid.add"(%bb0_8, %bb0_26) : (i64, i64) -> i64
      %bb0_1 = "braid.load"(%bb0_27) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb0_0) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bb0_1) {reg = "zmm0.1"} : (i64) -> ()
      %bb0_40 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb0_40) {reg = "zmm0.2"} : (i64) -> ()
      "braid.set"(%bb0_40) {reg = "zmm0.3"} : (i64) -> ()
      "braid.set"(%bb0_40) {reg = "zmm0.4"} : (i64) -> ()
      "braid.set"(%bb0_40) {reg = "zmm0.5"} : (i64) -> ()
      "braid.set"(%bb0_40) {reg = "zmm0.6"} : (i64) -> ()
      "braid.set"(%bb0_40) {reg = "zmm0.7"} : (i64) -> ()
      "braid_cf.br"()[^bb6] : () -> ()
    ^bb6:  // 0x401006
      %bb6_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb6_10 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb6_8 = "braid.add"(%bb6_9, %bb6_10) : (i64, i64) -> i64
      %bb6_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6_25 = "braid.add"(%bb6_8, %bb6_24) : (i64, i64) -> i64
      %bb6_0 = "braid.load"(%bb6_25) {bytes = 8 : i64} : (i64) -> i64
      %bb6_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb6_27 = "braid.add"(%bb6_8, %bb6_26) : (i64, i64) -> i64
      %bb6_1 = "braid.load"(%bb6_27) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb6_0) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bb6_1) {reg = "zmm1.1"} : (i64) -> ()
      %bb6_40 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb6_40) {reg = "zmm1.2"} : (i64) -> ()
      "braid.set"(%bb6_40) {reg = "zmm1.3"} : (i64) -> ()
      "braid.set"(%bb6_40) {reg = "zmm1.4"} : (i64) -> ()
      "braid.set"(%bb6_40) {reg = "zmm1.5"} : (i64) -> ()
      "braid.set"(%bb6_40) {reg = "zmm1.6"} : (i64) -> ()
      "braid.set"(%bb6_40) {reg = "zmm1.7"} : (i64) -> ()
      "braid_cf.br"()[^bbd] : () -> ()
    ^bbd:  // 0x40100d
      %bbd_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbd_10 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbd_8 = "braid.add"(%bbd_9, %bbd_10) : (i64, i64) -> i64
      %bbd_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd_25 = "braid.add"(%bbd_8, %bbd_24) : (i64, i64) -> i64
      %bbd_0 = "braid.load"(%bbd_25) {bytes = 8 : i64} : (i64) -> i64
      %bbd_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbd_27 = "braid.add"(%bbd_8, %bbd_26) : (i64, i64) -> i64
      %bbd_1 = "braid.load"(%bbd_27) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bbd_0) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bbd_1) {reg = "zmm2.1"} : (i64) -> ()
      %bbd_40 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bbd_40) {reg = "zmm2.2"} : (i64) -> ()
      "braid.set"(%bbd_40) {reg = "zmm2.3"} : (i64) -> ()
      "braid.set"(%bbd_40) {reg = "zmm2.4"} : (i64) -> ()
      "braid.set"(%bbd_40) {reg = "zmm2.5"} : (i64) -> ()
      "braid.set"(%bbd_40) {reg = "zmm2.6"} : (i64) -> ()
      "braid.set"(%bbd_40) {reg = "zmm2.7"} : (i64) -> ()
      "braid_cf.br"()[^bb14] : () -> ()
    ^bb14:  // 0x401014
      %bb14_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bb14_10 = "braid.const"() {value = 48 : i64} : () -> i64
      %bb14_8 = "braid.add"(%bb14_9, %bb14_10) : (i64, i64) -> i64
      %bb14_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb14_25 = "braid.add"(%bb14_8, %bb14_24) : (i64, i64) -> i64
      %bb14_0 = "braid.load"(%bb14_25) {bytes = 8 : i64} : (i64) -> i64
      %bb14_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb14_27 = "braid.add"(%bb14_8, %bb14_26) : (i64, i64) -> i64
      %bb14_1 = "braid.load"(%bb14_27) {bytes = 8 : i64} : (i64) -> i64
      "braid.set"(%bb14_0) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bb14_1) {reg = "zmm3.1"} : (i64) -> ()
      %bb14_40 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb14_40) {reg = "zmm3.2"} : (i64) -> ()
      "braid.set"(%bb14_40) {reg = "zmm3.3"} : (i64) -> ()
      "braid.set"(%bb14_40) {reg = "zmm3.4"} : (i64) -> ()
      "braid.set"(%bb14_40) {reg = "zmm3.5"} : (i64) -> ()
      "braid.set"(%bb14_40) {reg = "zmm3.6"} : (i64) -> ()
      "braid.set"(%bb14_40) {reg = "zmm3.7"} : (i64) -> ()
      "braid_cf.br"()[^bb1b] : () -> ()
    ^bb1b:  // 0x40101b
      %bb1b_0 = "braid.const"() {value = 10 : i64} : () -> i64
      "braid.set"(%bb1b_0) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bb20] : () -> ()
    ^bb20:  // 0x401020
      %bb20_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb20_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bb20_40 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb20_41 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb20_80 = "braid.lanes"(%bb20_40, %bb20_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb20_81 = "braid.lanes"(%bb20_41, %bb20_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb20_80) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bb20_81) {reg = "zmm0.1"} : (i64) -> ()
      %bb20_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb20_96) {reg = "zmm0.2"} : (i64) -> ()
      "braid.set"(%bb20_96) {reg = "zmm0.3"} : (i64) -> ()
      "braid.set"(%bb20_96) {reg = "zmm0.4"} : (i64) -> ()
      "braid.set"(%bb20_96) {reg = "zmm0.5"} : (i64) -> ()
      "braid.set"(%bb20_96) {reg = "zmm0.6"} : (i64) -> ()
      "braid.set"(%bb20_96) {reg = "zmm0.7"} : (i64) -> ()
      "braid_cf.br"()[^bb24] : () -> ()
    ^bb24:  // 0x401024
      %bb24_0 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb24_1 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb24_40 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb24_41 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb24_80 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb24_81 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb24_256 = "braid.xor"(%bb24_80, %bb24_0) : (i64, i64) -> i64
      %bb24_257 = "braid.xor"(%bb24_81, %bb24_1) : (i64, i64) -> i64
      "braid.set"(%bb24_256) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bb24_257) {reg = "zmm3.1"} : (i64) -> ()
      %bb24_264 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb24_264) {reg = "zmm3.2"} : (i64) -> ()
      "braid.set"(%bb24_264) {reg = "zmm3.3"} : (i64) -> ()
      "braid.set"(%bb24_264) {reg = "zmm3.4"} : (i64) -> ()
      "braid.set"(%bb24_264) {reg = "zmm3.5"} : (i64) -> ()
      "braid.set"(%bb24_264) {reg = "zmm3.6"} : (i64) -> ()
      "braid.set"(%bb24_264) {reg = "zmm3.7"} : (i64) -> ()
      "braid_cf.br"()[^bb2b] : () -> ()
    ^bb2b:  // 0x40102b
      %bb2b_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb2b_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb2b_40 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb2b_41 = "braid.const"() {value = 281470681808895 : i64} : () -> i64
      %bb2b_42 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb2b_43 = "braid.const"() {value = -281470681808896 : i64} : () -> i64
      %bb2b_48 = "braid.lshr"(%bb2b_0, %bb2b_40) : (i64, i64) -> i64
      %bb2b_49 = "braid.lshr"(%bb2b_1, %bb2b_40) : (i64, i64) -> i64
      %bb2b_56 = "braid.and"(%bb2b_48, %bb2b_41) : (i64, i64) -> i64
      %bb2b_57 = "braid.and"(%bb2b_49, %bb2b_41) : (i64, i64) -> i64
      %bb2b_64 = "braid.shl"(%bb2b_0, %bb2b_42) : (i64, i64) -> i64
      %bb2b_65 = "braid.shl"(%bb2b_1, %bb2b_42) : (i64, i64) -> i64
      %bb2b_72 = "braid.and"(%bb2b_64, %bb2b_43) : (i64, i64) -> i64
      %bb2b_73 = "braid.and"(%bb2b_65, %bb2b_43) : (i64, i64) -> i64
      %bb2b_80 = "braid.or"(%bb2b_56, %bb2b_72) : (i64, i64) -> i64
      %bb2b_81 = "braid.or"(%bb2b_57, %bb2b_73) : (i64, i64) -> i64
      "braid.set"(%bb2b_80) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bb2b_81) {reg = "zmm3.1"} : (i64) -> ()
      %bb2b_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb2b_96) {reg = "zmm3.2"} : (i64) -> ()
      "braid.set"(%bb2b_96) {reg = "zmm3.3"} : (i64) -> ()
      "braid.set"(%bb2b_96) {reg = "zmm3.4"} : (i64) -> ()
      "braid.set"(%bb2b_96) {reg = "zmm3.5"} : (i64) -> ()
      "braid.set"(%bb2b_96) {reg = "zmm3.6"} : (i64) -> ()
      "braid.set"(%bb2b_96) {reg = "zmm3.7"} : (i64) -> ()
      "braid_cf.br"()[^bb32] : () -> ()
    ^bb32:  // 0x401032
      %bb32_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb32_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb32_40 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb32_41 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb32_80 = "braid.lanes"(%bb32_40, %bb32_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb32_81 = "braid.lanes"(%bb32_41, %bb32_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb32_80) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bb32_81) {reg = "zmm2.1"} : (i64) -> ()
      %bb32_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb32_96) {reg = "zmm2.2"} : (i64) -> ()
      "braid.set"(%bb32_96) {reg = "zmm2.3"} : (i64) -> ()
      "braid.set"(%bb32_96) {reg = "zmm2.4"} : (i64) -> ()
      "braid.set"(%bb32_96) {reg = "zmm2.5"} : (i64) -> ()
      "braid.set"(%bb32_96) {reg = "zmm2.6"} : (i64) -> ()
      "braid.set"(%bb32_96) {reg = "zmm2.7"} : (i64) -> ()
      "braid_cf.br"()[^bb36] : () -> ()
    ^bb36:  // 0x401036
      %bb36_0 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb36_1 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb36_40 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb36_41 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb36_80 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb36_81 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bb36_256 = "braid.xor"(%bb36_80, %bb36_0) : (i64, i64) -> i64
      %bb36_257 = "braid.xor"(%bb36_81, %bb36_1) : (i64, i64) -> i64
      "braid.set"(%bb36_256) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bb36_257) {reg = "zmm1.1"} : (i64) -> ()
      %bb36_264 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb36_264) {reg = "zmm1.2"} : (i64) -> ()
      "braid.set"(%bb36_264) {reg = "zmm1.3"} : (i64) -> ()
      "braid.set"(%bb36_264) {reg = "zmm1.4"} : (i64) -> ()
      "braid.set"(%bb36_264) {reg = "zmm1.5"} : (i64) -> ()
      "braid.set"(%bb36_264) {reg = "zmm1.6"} : (i64) -> ()
      "braid.set"(%bb36_264) {reg = "zmm1.7"} : (i64) -> ()
      "braid_cf.br"()[^bb3d] : () -> ()
    ^bb3d:  // 0x40103d
      %bb3d_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb3d_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bb3d_40 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb3d_41 = "braid.const"() {value = 17587891081215 : i64} : () -> i64
      %bb3d_42 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb3d_43 = "braid.const"() {value = -17587891081216 : i64} : () -> i64
      %bb3d_48 = "braid.lshr"(%bb3d_0, %bb3d_40) : (i64, i64) -> i64
      %bb3d_49 = "braid.lshr"(%bb3d_1, %bb3d_40) : (i64, i64) -> i64
      %bb3d_56 = "braid.and"(%bb3d_48, %bb3d_41) : (i64, i64) -> i64
      %bb3d_57 = "braid.and"(%bb3d_49, %bb3d_41) : (i64, i64) -> i64
      %bb3d_64 = "braid.shl"(%bb3d_0, %bb3d_42) : (i64, i64) -> i64
      %bb3d_65 = "braid.shl"(%bb3d_1, %bb3d_42) : (i64, i64) -> i64
      %bb3d_72 = "braid.and"(%bb3d_64, %bb3d_43) : (i64, i64) -> i64
      %bb3d_73 = "braid.and"(%bb3d_65, %bb3d_43) : (i64, i64) -> i64
      %bb3d_80 = "braid.or"(%bb3d_56, %bb3d_72) : (i64, i64) -> i64
      %bb3d_81 = "braid.or"(%bb3d_57, %bb3d_73) : (i64, i64) -> i64
      "braid.set"(%bb3d_80) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bb3d_81) {reg = "zmm1.1"} : (i64) -> ()
      %bb3d_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb3d_96) {reg = "zmm1.2"} : (i64) -> ()
      "braid.set"(%bb3d_96) {reg = "zmm1.3"} : (i64) -> ()
      "braid.set"(%bb3d_96) {reg = "zmm1.4"} : (i64) -> ()
      "braid.set"(%bb3d_96) {reg = "zmm1.5"} : (i64) -> ()
      "braid.set"(%bb3d_96) {reg = "zmm1.6"} : (i64) -> ()
      "braid.set"(%bb3d_96) {reg = "zmm1.7"} : (i64) -> ()
      "braid_cf.br"()[^bb44] : () -> ()
    ^bb44:  // 0x401044
      %bb44_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb44_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bb44_40 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb44_41 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb44_80 = "braid.lanes"(%bb44_40, %bb44_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb44_81 = "braid.lanes"(%bb44_41, %bb44_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb44_80) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bb44_81) {reg = "zmm0.1"} : (i64) -> ()
      %bb44_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb44_96) {reg = "zmm0.2"} : (i64) -> ()
      "braid.set"(%bb44_96) {reg = "zmm0.3"} : (i64) -> ()
      "braid.set"(%bb44_96) {reg = "zmm0.4"} : (i64) -> ()
      "braid.set"(%bb44_96) {reg = "zmm0.5"} : (i64) -> ()
      "braid.set"(%bb44_96) {reg = "zmm0.6"} : (i64) -> ()
      "braid.set"(%bb44_96) {reg = "zmm0.7"} : (i64) -> ()
      "braid_cf.br"()[^bb48] : () -> ()
    ^bb48:  // 0x401048
      %bb48_0 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb48_1 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb48_40 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb48_41 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb48_80 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb48_81 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb48_256 = "braid.xor"(%bb48_80, %bb48_0) : (i64, i64) -> i64
      %bb48_257 = "braid.xor"(%bb48_81, %bb48_1) : (i64, i64) -> i64
      "braid.set"(%bb48_256) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bb48_257) {reg = "zmm3.1"} : (i64) -> ()
      %bb48_264 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb48_264) {reg = "zmm3.2"} : (i64) -> ()
      "braid.set"(%bb48_264) {reg = "zmm3.3"} : (i64) -> ()
      "braid.set"(%bb48_264) {reg = "zmm3.4"} : (i64) -> ()
      "braid.set"(%bb48_264) {reg = "zmm3.5"} : (i64) -> ()
      "braid.set"(%bb48_264) {reg = "zmm3.6"} : (i64) -> ()
      "braid.set"(%bb48_264) {reg = "zmm3.7"} : (i64) -> ()
      "braid_cf.br"()[^bb4f] : () -> ()
    ^bb4f:  // 0x40104f
      %bb4f_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb4f_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb4f_40 = "braid.const"() {value = 24 : i64} : () -> i64
      %bb4f_41 = "braid.const"() {value = 1095216660735 : i64} : () -> i64
      %bb4f_42 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb4f_43 = "braid.const"() {value = -1095216660736 : i64} : () -> i64
      %bb4f_48 = "braid.lshr"(%bb4f_0, %bb4f_40) : (i64, i64) -> i64
      %bb4f_49 = "braid.lshr"(%bb4f_1, %bb4f_40) : (i64, i64) -> i64
      %bb4f_56 = "braid.and"(%bb4f_48, %bb4f_41) : (i64, i64) -> i64
      %bb4f_57 = "braid.and"(%bb4f_49, %bb4f_41) : (i64, i64) -> i64
      %bb4f_64 = "braid.shl"(%bb4f_0, %bb4f_42) : (i64, i64) -> i64
      %bb4f_65 = "braid.shl"(%bb4f_1, %bb4f_42) : (i64, i64) -> i64
      %bb4f_72 = "braid.and"(%bb4f_64, %bb4f_43) : (i64, i64) -> i64
      %bb4f_73 = "braid.and"(%bb4f_65, %bb4f_43) : (i64, i64) -> i64
      %bb4f_80 = "braid.or"(%bb4f_56, %bb4f_72) : (i64, i64) -> i64
      %bb4f_81 = "braid.or"(%bb4f_57, %bb4f_73) : (i64, i64) -> i64
      "braid.set"(%bb4f_80) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bb4f_81) {reg = "zmm3.1"} : (i64) -> ()
      %bb4f_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb4f_96) {reg = "zmm3.2"} : (i64) -> ()
      "braid.set"(%bb4f_96) {reg = "zmm3.3"} : (i64) -> ()
      "braid.set"(%bb4f_96) {reg = "zmm3.4"} : (i64) -> ()
      "braid.set"(%bb4f_96) {reg = "zmm3.5"} : (i64) -> ()
      "braid.set"(%bb4f_96) {reg = "zmm3.6"} : (i64) -> ()
      "braid.set"(%bb4f_96) {reg = "zmm3.7"} : (i64) -> ()
      "braid_cf.br"()[^bb56] : () -> ()
    ^bb56:  // 0x401056
      %bb56_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb56_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb56_40 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb56_41 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb56_80 = "braid.lanes"(%bb56_40, %bb56_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb56_81 = "braid.lanes"(%bb56_41, %bb56_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb56_80) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bb56_81) {reg = "zmm2.1"} : (i64) -> ()
      %bb56_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb56_96) {reg = "zmm2.2"} : (i64) -> ()
      "braid.set"(%bb56_96) {reg = "zmm2.3"} : (i64) -> ()
      "braid.set"(%bb56_96) {reg = "zmm2.4"} : (i64) -> ()
      "braid.set"(%bb56_96) {reg = "zmm2.5"} : (i64) -> ()
      "braid.set"(%bb56_96) {reg = "zmm2.6"} : (i64) -> ()
      "braid.set"(%bb56_96) {reg = "zmm2.7"} : (i64) -> ()
      "braid_cf.br"()[^bb5a] : () -> ()
    ^bb5a:  // 0x40105a
      %bb5a_0 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb5a_1 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb5a_40 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb5a_41 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb5a_80 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb5a_81 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bb5a_256 = "braid.xor"(%bb5a_80, %bb5a_0) : (i64, i64) -> i64
      %bb5a_257 = "braid.xor"(%bb5a_81, %bb5a_1) : (i64, i64) -> i64
      "braid.set"(%bb5a_256) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bb5a_257) {reg = "zmm1.1"} : (i64) -> ()
      %bb5a_264 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb5a_264) {reg = "zmm1.2"} : (i64) -> ()
      "braid.set"(%bb5a_264) {reg = "zmm1.3"} : (i64) -> ()
      "braid.set"(%bb5a_264) {reg = "zmm1.4"} : (i64) -> ()
      "braid.set"(%bb5a_264) {reg = "zmm1.5"} : (i64) -> ()
      "braid.set"(%bb5a_264) {reg = "zmm1.6"} : (i64) -> ()
      "braid.set"(%bb5a_264) {reg = "zmm1.7"} : (i64) -> ()
      "braid_cf.br"()[^bb61] : () -> ()
    ^bb61:  // 0x401061
      %bb61_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb61_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bb61_40 = "braid.const"() {value = 25 : i64} : () -> i64
      %bb61_41 = "braid.const"() {value = 545460846719 : i64} : () -> i64
      %bb61_42 = "braid.const"() {value = 7 : i64} : () -> i64
      %bb61_43 = "braid.const"() {value = -545460846720 : i64} : () -> i64
      %bb61_48 = "braid.lshr"(%bb61_0, %bb61_40) : (i64, i64) -> i64
      %bb61_49 = "braid.lshr"(%bb61_1, %bb61_40) : (i64, i64) -> i64
      %bb61_56 = "braid.and"(%bb61_48, %bb61_41) : (i64, i64) -> i64
      %bb61_57 = "braid.and"(%bb61_49, %bb61_41) : (i64, i64) -> i64
      %bb61_64 = "braid.shl"(%bb61_0, %bb61_42) : (i64, i64) -> i64
      %bb61_65 = "braid.shl"(%bb61_1, %bb61_42) : (i64, i64) -> i64
      %bb61_72 = "braid.and"(%bb61_64, %bb61_43) : (i64, i64) -> i64
      %bb61_73 = "braid.and"(%bb61_65, %bb61_43) : (i64, i64) -> i64
      %bb61_80 = "braid.or"(%bb61_56, %bb61_72) : (i64, i64) -> i64
      %bb61_81 = "braid.or"(%bb61_57, %bb61_73) : (i64, i64) -> i64
      "braid.set"(%bb61_80) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bb61_81) {reg = "zmm1.1"} : (i64) -> ()
      %bb61_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb61_96) {reg = "zmm1.2"} : (i64) -> ()
      "braid.set"(%bb61_96) {reg = "zmm1.3"} : (i64) -> ()
      "braid.set"(%bb61_96) {reg = "zmm1.4"} : (i64) -> ()
      "braid.set"(%bb61_96) {reg = "zmm1.5"} : (i64) -> ()
      "braid.set"(%bb61_96) {reg = "zmm1.6"} : (i64) -> ()
      "braid.set"(%bb61_96) {reg = "zmm1.7"} : (i64) -> ()
      "braid_cf.br"()[^bb68] : () -> ()
    ^bb68:  // 0x401068
      %bb68_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb68_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bb68_40 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb68_41 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bb68_48 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb68_49 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb68_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb68_57 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb68_64 = "braid.lshr"(%bb68_0, %bb68_48) : (i64, i64) -> i64
      %bb68_65 = "braid.lshr"(%bb68_1, %bb68_49) : (i64, i64) -> i64
      %bb68_72 = "braid.and"(%bb68_64, %bb68_41) : (i64, i64) -> i64
      %bb68_73 = "braid.and"(%bb68_65, %bb68_41) : (i64, i64) -> i64
      %bb68_80 = "braid.lshr"(%bb68_1, %bb68_56) : (i64, i64) -> i64
      %bb68_81 = "braid.lshr"(%bb68_0, %bb68_57) : (i64, i64) -> i64
      %bb68_88 = "braid.shl"(%bb68_80, %bb68_40) : (i64, i64) -> i64
      %bb68_89 = "braid.shl"(%bb68_81, %bb68_40) : (i64, i64) -> i64
      %bb68_96 = "braid.or"(%bb68_72, %bb68_88) : (i64, i64) -> i64
      %bb68_97 = "braid.or"(%bb68_73, %bb68_89) : (i64, i64) -> i64
      "braid.set"(%bb68_96) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bb68_97) {reg = "zmm1.1"} : (i64) -> ()
      "braid_cf.br"()[^bb6d] : () -> ()
    ^bb6d:  // 0x40106d
      %bb6d_0 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb6d_1 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb6d_40 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb6d_41 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bb6d_48 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6d_49 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb6d_56 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb6d_57 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb6d_64 = "braid.lshr"(%bb6d_1, %bb6d_48) : (i64, i64) -> i64
      %bb6d_65 = "braid.lshr"(%bb6d_0, %bb6d_49) : (i64, i64) -> i64
      %bb6d_72 = "braid.and"(%bb6d_64, %bb6d_41) : (i64, i64) -> i64
      %bb6d_73 = "braid.and"(%bb6d_65, %bb6d_41) : (i64, i64) -> i64
      %bb6d_80 = "braid.lshr"(%bb6d_1, %bb6d_56) : (i64, i64) -> i64
      %bb6d_81 = "braid.lshr"(%bb6d_0, %bb6d_57) : (i64, i64) -> i64
      %bb6d_88 = "braid.shl"(%bb6d_80, %bb6d_40) : (i64, i64) -> i64
      %bb6d_89 = "braid.shl"(%bb6d_81, %bb6d_40) : (i64, i64) -> i64
      %bb6d_96 = "braid.or"(%bb6d_72, %bb6d_88) : (i64, i64) -> i64
      %bb6d_97 = "braid.or"(%bb6d_73, %bb6d_89) : (i64, i64) -> i64
      "braid.set"(%bb6d_96) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bb6d_97) {reg = "zmm2.1"} : (i64) -> ()
      "braid_cf.br"()[^bb72] : () -> ()
    ^bb72:  // 0x401072
      %bb72_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb72_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb72_40 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb72_41 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bb72_48 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb72_49 = "braid.const"() {value = 32 : i64} : () -> i64
      %bb72_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb72_57 = "braid.const"() {value = 0 : i64} : () -> i64
      %bb72_64 = "braid.lshr"(%bb72_1, %bb72_48) : (i64, i64) -> i64
      %bb72_65 = "braid.lshr"(%bb72_0, %bb72_49) : (i64, i64) -> i64
      %bb72_72 = "braid.and"(%bb72_64, %bb72_41) : (i64, i64) -> i64
      %bb72_73 = "braid.and"(%bb72_65, %bb72_41) : (i64, i64) -> i64
      %bb72_80 = "braid.lshr"(%bb72_0, %bb72_56) : (i64, i64) -> i64
      %bb72_81 = "braid.lshr"(%bb72_1, %bb72_57) : (i64, i64) -> i64
      %bb72_88 = "braid.shl"(%bb72_80, %bb72_40) : (i64, i64) -> i64
      %bb72_89 = "braid.shl"(%bb72_81, %bb72_40) : (i64, i64) -> i64
      %bb72_96 = "braid.or"(%bb72_72, %bb72_88) : (i64, i64) -> i64
      %bb72_97 = "braid.or"(%bb72_73, %bb72_89) : (i64, i64) -> i64
      "braid.set"(%bb72_96) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bb72_97) {reg = "zmm3.1"} : (i64) -> ()
      "braid_cf.br"()[^bb77] : () -> ()
    ^bb77:  // 0x401077
      %bb77_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb77_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bb77_40 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb77_41 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb77_80 = "braid.lanes"(%bb77_40, %bb77_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb77_81 = "braid.lanes"(%bb77_41, %bb77_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb77_80) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bb77_81) {reg = "zmm0.1"} : (i64) -> ()
      %bb77_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb77_96) {reg = "zmm0.2"} : (i64) -> ()
      "braid.set"(%bb77_96) {reg = "zmm0.3"} : (i64) -> ()
      "braid.set"(%bb77_96) {reg = "zmm0.4"} : (i64) -> ()
      "braid.set"(%bb77_96) {reg = "zmm0.5"} : (i64) -> ()
      "braid.set"(%bb77_96) {reg = "zmm0.6"} : (i64) -> ()
      "braid.set"(%bb77_96) {reg = "zmm0.7"} : (i64) -> ()
      "braid_cf.br"()[^bb7b] : () -> ()
    ^bb7b:  // 0x40107b
      %bb7b_0 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb7b_1 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb7b_40 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb7b_41 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb7b_80 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb7b_81 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb7b_256 = "braid.xor"(%bb7b_80, %bb7b_0) : (i64, i64) -> i64
      %bb7b_257 = "braid.xor"(%bb7b_81, %bb7b_1) : (i64, i64) -> i64
      "braid.set"(%bb7b_256) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bb7b_257) {reg = "zmm3.1"} : (i64) -> ()
      %bb7b_264 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb7b_264) {reg = "zmm3.2"} : (i64) -> ()
      "braid.set"(%bb7b_264) {reg = "zmm3.3"} : (i64) -> ()
      "braid.set"(%bb7b_264) {reg = "zmm3.4"} : (i64) -> ()
      "braid.set"(%bb7b_264) {reg = "zmm3.5"} : (i64) -> ()
      "braid.set"(%bb7b_264) {reg = "zmm3.6"} : (i64) -> ()
      "braid.set"(%bb7b_264) {reg = "zmm3.7"} : (i64) -> ()
      "braid_cf.br"()[^bb82] : () -> ()
    ^bb82:  // 0x401082
      %bb82_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb82_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb82_40 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb82_41 = "braid.const"() {value = 281470681808895 : i64} : () -> i64
      %bb82_42 = "braid.const"() {value = 16 : i64} : () -> i64
      %bb82_43 = "braid.const"() {value = -281470681808896 : i64} : () -> i64
      %bb82_48 = "braid.lshr"(%bb82_0, %bb82_40) : (i64, i64) -> i64
      %bb82_49 = "braid.lshr"(%bb82_1, %bb82_40) : (i64, i64) -> i64
      %bb82_56 = "braid.and"(%bb82_48, %bb82_41) : (i64, i64) -> i64
      %bb82_57 = "braid.and"(%bb82_49, %bb82_41) : (i64, i64) -> i64
      %bb82_64 = "braid.shl"(%bb82_0, %bb82_42) : (i64, i64) -> i64
      %bb82_65 = "braid.shl"(%bb82_1, %bb82_42) : (i64, i64) -> i64
      %bb82_72 = "braid.and"(%bb82_64, %bb82_43) : (i64, i64) -> i64
      %bb82_73 = "braid.and"(%bb82_65, %bb82_43) : (i64, i64) -> i64
      %bb82_80 = "braid.or"(%bb82_56, %bb82_72) : (i64, i64) -> i64
      %bb82_81 = "braid.or"(%bb82_57, %bb82_73) : (i64, i64) -> i64
      "braid.set"(%bb82_80) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bb82_81) {reg = "zmm3.1"} : (i64) -> ()
      %bb82_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb82_96) {reg = "zmm3.2"} : (i64) -> ()
      "braid.set"(%bb82_96) {reg = "zmm3.3"} : (i64) -> ()
      "braid.set"(%bb82_96) {reg = "zmm3.4"} : (i64) -> ()
      "braid.set"(%bb82_96) {reg = "zmm3.5"} : (i64) -> ()
      "braid.set"(%bb82_96) {reg = "zmm3.6"} : (i64) -> ()
      "braid.set"(%bb82_96) {reg = "zmm3.7"} : (i64) -> ()
      "braid_cf.br"()[^bb89] : () -> ()
    ^bb89:  // 0x401089
      %bb89_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb89_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb89_40 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb89_41 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb89_80 = "braid.lanes"(%bb89_40, %bb89_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb89_81 = "braid.lanes"(%bb89_41, %bb89_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb89_80) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bb89_81) {reg = "zmm2.1"} : (i64) -> ()
      %bb89_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb89_96) {reg = "zmm2.2"} : (i64) -> ()
      "braid.set"(%bb89_96) {reg = "zmm2.3"} : (i64) -> ()
      "braid.set"(%bb89_96) {reg = "zmm2.4"} : (i64) -> ()
      "braid.set"(%bb89_96) {reg = "zmm2.5"} : (i64) -> ()
      "braid.set"(%bb89_96) {reg = "zmm2.6"} : (i64) -> ()
      "braid.set"(%bb89_96) {reg = "zmm2.7"} : (i64) -> ()
      "braid_cf.br"()[^bb8d] : () -> ()
    ^bb8d:  // 0x40108d
      %bb8d_0 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb8d_1 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb8d_40 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bb8d_41 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bb8d_80 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb8d_81 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bb8d_256 = "braid.xor"(%bb8d_80, %bb8d_0) : (i64, i64) -> i64
      %bb8d_257 = "braid.xor"(%bb8d_81, %bb8d_1) : (i64, i64) -> i64
      "braid.set"(%bb8d_256) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bb8d_257) {reg = "zmm1.1"} : (i64) -> ()
      %bb8d_264 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb8d_264) {reg = "zmm1.2"} : (i64) -> ()
      "braid.set"(%bb8d_264) {reg = "zmm1.3"} : (i64) -> ()
      "braid.set"(%bb8d_264) {reg = "zmm1.4"} : (i64) -> ()
      "braid.set"(%bb8d_264) {reg = "zmm1.5"} : (i64) -> ()
      "braid.set"(%bb8d_264) {reg = "zmm1.6"} : (i64) -> ()
      "braid.set"(%bb8d_264) {reg = "zmm1.7"} : (i64) -> ()
      "braid_cf.br"()[^bb94] : () -> ()
    ^bb94:  // 0x401094
      %bb94_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb94_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bb94_40 = "braid.const"() {value = 20 : i64} : () -> i64
      %bb94_41 = "braid.const"() {value = 17587891081215 : i64} : () -> i64
      %bb94_42 = "braid.const"() {value = 12 : i64} : () -> i64
      %bb94_43 = "braid.const"() {value = -17587891081216 : i64} : () -> i64
      %bb94_48 = "braid.lshr"(%bb94_0, %bb94_40) : (i64, i64) -> i64
      %bb94_49 = "braid.lshr"(%bb94_1, %bb94_40) : (i64, i64) -> i64
      %bb94_56 = "braid.and"(%bb94_48, %bb94_41) : (i64, i64) -> i64
      %bb94_57 = "braid.and"(%bb94_49, %bb94_41) : (i64, i64) -> i64
      %bb94_64 = "braid.shl"(%bb94_0, %bb94_42) : (i64, i64) -> i64
      %bb94_65 = "braid.shl"(%bb94_1, %bb94_42) : (i64, i64) -> i64
      %bb94_72 = "braid.and"(%bb94_64, %bb94_43) : (i64, i64) -> i64
      %bb94_73 = "braid.and"(%bb94_65, %bb94_43) : (i64, i64) -> i64
      %bb94_80 = "braid.or"(%bb94_56, %bb94_72) : (i64, i64) -> i64
      %bb94_81 = "braid.or"(%bb94_57, %bb94_73) : (i64, i64) -> i64
      "braid.set"(%bb94_80) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bb94_81) {reg = "zmm1.1"} : (i64) -> ()
      %bb94_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb94_96) {reg = "zmm1.2"} : (i64) -> ()
      "braid.set"(%bb94_96) {reg = "zmm1.3"} : (i64) -> ()
      "braid.set"(%bb94_96) {reg = "zmm1.4"} : (i64) -> ()
      "braid.set"(%bb94_96) {reg = "zmm1.5"} : (i64) -> ()
      "braid.set"(%bb94_96) {reg = "zmm1.6"} : (i64) -> ()
      "braid.set"(%bb94_96) {reg = "zmm1.7"} : (i64) -> ()
      "braid_cf.br"()[^bb9b] : () -> ()
    ^bb9b:  // 0x40109b
      %bb9b_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bb9b_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bb9b_40 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb9b_41 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb9b_80 = "braid.lanes"(%bb9b_40, %bb9b_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bb9b_81 = "braid.lanes"(%bb9b_41, %bb9b_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bb9b_80) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bb9b_81) {reg = "zmm0.1"} : (i64) -> ()
      %bb9b_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb9b_96) {reg = "zmm0.2"} : (i64) -> ()
      "braid.set"(%bb9b_96) {reg = "zmm0.3"} : (i64) -> ()
      "braid.set"(%bb9b_96) {reg = "zmm0.4"} : (i64) -> ()
      "braid.set"(%bb9b_96) {reg = "zmm0.5"} : (i64) -> ()
      "braid.set"(%bb9b_96) {reg = "zmm0.6"} : (i64) -> ()
      "braid.set"(%bb9b_96) {reg = "zmm0.7"} : (i64) -> ()
      "braid_cf.br"()[^bb9f] : () -> ()
    ^bb9f:  // 0x40109f
      %bb9f_0 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb9f_1 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb9f_40 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bb9f_41 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bb9f_80 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bb9f_81 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bb9f_256 = "braid.xor"(%bb9f_80, %bb9f_0) : (i64, i64) -> i64
      %bb9f_257 = "braid.xor"(%bb9f_81, %bb9f_1) : (i64, i64) -> i64
      "braid.set"(%bb9f_256) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bb9f_257) {reg = "zmm3.1"} : (i64) -> ()
      %bb9f_264 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bb9f_264) {reg = "zmm3.2"} : (i64) -> ()
      "braid.set"(%bb9f_264) {reg = "zmm3.3"} : (i64) -> ()
      "braid.set"(%bb9f_264) {reg = "zmm3.4"} : (i64) -> ()
      "braid.set"(%bb9f_264) {reg = "zmm3.5"} : (i64) -> ()
      "braid.set"(%bb9f_264) {reg = "zmm3.6"} : (i64) -> ()
      "braid.set"(%bb9f_264) {reg = "zmm3.7"} : (i64) -> ()
      "braid_cf.br"()[^bba6] : () -> ()
    ^bba6:  // 0x4010a6
      %bba6_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bba6_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bba6_40 = "braid.const"() {value = 24 : i64} : () -> i64
      %bba6_41 = "braid.const"() {value = 1095216660735 : i64} : () -> i64
      %bba6_42 = "braid.const"() {value = 8 : i64} : () -> i64
      %bba6_43 = "braid.const"() {value = -1095216660736 : i64} : () -> i64
      %bba6_48 = "braid.lshr"(%bba6_0, %bba6_40) : (i64, i64) -> i64
      %bba6_49 = "braid.lshr"(%bba6_1, %bba6_40) : (i64, i64) -> i64
      %bba6_56 = "braid.and"(%bba6_48, %bba6_41) : (i64, i64) -> i64
      %bba6_57 = "braid.and"(%bba6_49, %bba6_41) : (i64, i64) -> i64
      %bba6_64 = "braid.shl"(%bba6_0, %bba6_42) : (i64, i64) -> i64
      %bba6_65 = "braid.shl"(%bba6_1, %bba6_42) : (i64, i64) -> i64
      %bba6_72 = "braid.and"(%bba6_64, %bba6_43) : (i64, i64) -> i64
      %bba6_73 = "braid.and"(%bba6_65, %bba6_43) : (i64, i64) -> i64
      %bba6_80 = "braid.or"(%bba6_56, %bba6_72) : (i64, i64) -> i64
      %bba6_81 = "braid.or"(%bba6_57, %bba6_73) : (i64, i64) -> i64
      "braid.set"(%bba6_80) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bba6_81) {reg = "zmm3.1"} : (i64) -> ()
      %bba6_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bba6_96) {reg = "zmm3.2"} : (i64) -> ()
      "braid.set"(%bba6_96) {reg = "zmm3.3"} : (i64) -> ()
      "braid.set"(%bba6_96) {reg = "zmm3.4"} : (i64) -> ()
      "braid.set"(%bba6_96) {reg = "zmm3.5"} : (i64) -> ()
      "braid.set"(%bba6_96) {reg = "zmm3.6"} : (i64) -> ()
      "braid.set"(%bba6_96) {reg = "zmm3.7"} : (i64) -> ()
      "braid_cf.br"()[^bbad] : () -> ()
    ^bbad:  // 0x4010ad
      %bbad_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bbad_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bbad_40 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bbad_41 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bbad_80 = "braid.lanes"(%bbad_40, %bbad_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bbad_81 = "braid.lanes"(%bbad_41, %bbad_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bbad_80) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bbad_81) {reg = "zmm2.1"} : (i64) -> ()
      %bbad_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bbad_96) {reg = "zmm2.2"} : (i64) -> ()
      "braid.set"(%bbad_96) {reg = "zmm2.3"} : (i64) -> ()
      "braid.set"(%bbad_96) {reg = "zmm2.4"} : (i64) -> ()
      "braid.set"(%bbad_96) {reg = "zmm2.5"} : (i64) -> ()
      "braid.set"(%bbad_96) {reg = "zmm2.6"} : (i64) -> ()
      "braid.set"(%bbad_96) {reg = "zmm2.7"} : (i64) -> ()
      "braid_cf.br"()[^bbb1] : () -> ()
    ^bbb1:  // 0x4010b1
      %bbb1_0 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bbb1_1 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bbb1_40 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bbb1_41 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bbb1_80 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bbb1_81 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bbb1_256 = "braid.xor"(%bbb1_80, %bbb1_0) : (i64, i64) -> i64
      %bbb1_257 = "braid.xor"(%bbb1_81, %bbb1_1) : (i64, i64) -> i64
      "braid.set"(%bbb1_256) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bbb1_257) {reg = "zmm1.1"} : (i64) -> ()
      %bbb1_264 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bbb1_264) {reg = "zmm1.2"} : (i64) -> ()
      "braid.set"(%bbb1_264) {reg = "zmm1.3"} : (i64) -> ()
      "braid.set"(%bbb1_264) {reg = "zmm1.4"} : (i64) -> ()
      "braid.set"(%bbb1_264) {reg = "zmm1.5"} : (i64) -> ()
      "braid.set"(%bbb1_264) {reg = "zmm1.6"} : (i64) -> ()
      "braid.set"(%bbb1_264) {reg = "zmm1.7"} : (i64) -> ()
      "braid_cf.br"()[^bbb8] : () -> ()
    ^bbb8:  // 0x4010b8
      %bbb8_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bbb8_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bbb8_40 = "braid.const"() {value = 25 : i64} : () -> i64
      %bbb8_41 = "braid.const"() {value = 545460846719 : i64} : () -> i64
      %bbb8_42 = "braid.const"() {value = 7 : i64} : () -> i64
      %bbb8_43 = "braid.const"() {value = -545460846720 : i64} : () -> i64
      %bbb8_48 = "braid.lshr"(%bbb8_0, %bbb8_40) : (i64, i64) -> i64
      %bbb8_49 = "braid.lshr"(%bbb8_1, %bbb8_40) : (i64, i64) -> i64
      %bbb8_56 = "braid.and"(%bbb8_48, %bbb8_41) : (i64, i64) -> i64
      %bbb8_57 = "braid.and"(%bbb8_49, %bbb8_41) : (i64, i64) -> i64
      %bbb8_64 = "braid.shl"(%bbb8_0, %bbb8_42) : (i64, i64) -> i64
      %bbb8_65 = "braid.shl"(%bbb8_1, %bbb8_42) : (i64, i64) -> i64
      %bbb8_72 = "braid.and"(%bbb8_64, %bbb8_43) : (i64, i64) -> i64
      %bbb8_73 = "braid.and"(%bbb8_65, %bbb8_43) : (i64, i64) -> i64
      %bbb8_80 = "braid.or"(%bbb8_56, %bbb8_72) : (i64, i64) -> i64
      %bbb8_81 = "braid.or"(%bbb8_57, %bbb8_73) : (i64, i64) -> i64
      "braid.set"(%bbb8_80) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bbb8_81) {reg = "zmm1.1"} : (i64) -> ()
      %bbb8_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bbb8_96) {reg = "zmm1.2"} : (i64) -> ()
      "braid.set"(%bbb8_96) {reg = "zmm1.3"} : (i64) -> ()
      "braid.set"(%bbb8_96) {reg = "zmm1.4"} : (i64) -> ()
      "braid.set"(%bbb8_96) {reg = "zmm1.5"} : (i64) -> ()
      "braid.set"(%bbb8_96) {reg = "zmm1.6"} : (i64) -> ()
      "braid.set"(%bbb8_96) {reg = "zmm1.7"} : (i64) -> ()
      "braid_cf.br"()[^bbbf] : () -> ()
    ^bbbf:  // 0x4010bf
      %bbbf_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bbbf_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bbbf_40 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbbf_41 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bbbf_48 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbbf_49 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbbf_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbbf_57 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbbf_64 = "braid.lshr"(%bbbf_1, %bbbf_48) : (i64, i64) -> i64
      %bbbf_65 = "braid.lshr"(%bbbf_0, %bbbf_49) : (i64, i64) -> i64
      %bbbf_72 = "braid.and"(%bbbf_64, %bbbf_41) : (i64, i64) -> i64
      %bbbf_73 = "braid.and"(%bbbf_65, %bbbf_41) : (i64, i64) -> i64
      %bbbf_80 = "braid.lshr"(%bbbf_0, %bbbf_56) : (i64, i64) -> i64
      %bbbf_81 = "braid.lshr"(%bbbf_1, %bbbf_57) : (i64, i64) -> i64
      %bbbf_88 = "braid.shl"(%bbbf_80, %bbbf_40) : (i64, i64) -> i64
      %bbbf_89 = "braid.shl"(%bbbf_81, %bbbf_40) : (i64, i64) -> i64
      %bbbf_96 = "braid.or"(%bbbf_72, %bbbf_88) : (i64, i64) -> i64
      %bbbf_97 = "braid.or"(%bbbf_73, %bbbf_89) : (i64, i64) -> i64
      "braid.set"(%bbbf_96) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bbbf_97) {reg = "zmm1.1"} : (i64) -> ()
      "braid_cf.br"()[^bbc4] : () -> ()
    ^bbc4:  // 0x4010c4
      %bbc4_0 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bbc4_1 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bbc4_40 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbc4_41 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bbc4_48 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc4_49 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc4_56 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbc4_57 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbc4_64 = "braid.lshr"(%bbc4_1, %bbc4_48) : (i64, i64) -> i64
      %bbc4_65 = "braid.lshr"(%bbc4_0, %bbc4_49) : (i64, i64) -> i64
      %bbc4_72 = "braid.and"(%bbc4_64, %bbc4_41) : (i64, i64) -> i64
      %bbc4_73 = "braid.and"(%bbc4_65, %bbc4_41) : (i64, i64) -> i64
      %bbc4_80 = "braid.lshr"(%bbc4_1, %bbc4_56) : (i64, i64) -> i64
      %bbc4_81 = "braid.lshr"(%bbc4_0, %bbc4_57) : (i64, i64) -> i64
      %bbc4_88 = "braid.shl"(%bbc4_80, %bbc4_40) : (i64, i64) -> i64
      %bbc4_89 = "braid.shl"(%bbc4_81, %bbc4_40) : (i64, i64) -> i64
      %bbc4_96 = "braid.or"(%bbc4_72, %bbc4_88) : (i64, i64) -> i64
      %bbc4_97 = "braid.or"(%bbc4_73, %bbc4_89) : (i64, i64) -> i64
      "braid.set"(%bbc4_96) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bbc4_97) {reg = "zmm2.1"} : (i64) -> ()
      "braid_cf.br"()[^bbc9] : () -> ()
    ^bbc9:  // 0x4010c9
      %bbc9_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bbc9_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bbc9_40 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbc9_41 = "braid.const"() {value = 4294967295 : i64} : () -> i64
      %bbc9_48 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbc9_49 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbc9_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc9_57 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbc9_64 = "braid.lshr"(%bbc9_0, %bbc9_48) : (i64, i64) -> i64
      %bbc9_65 = "braid.lshr"(%bbc9_1, %bbc9_49) : (i64, i64) -> i64
      %bbc9_72 = "braid.and"(%bbc9_64, %bbc9_41) : (i64, i64) -> i64
      %bbc9_73 = "braid.and"(%bbc9_65, %bbc9_41) : (i64, i64) -> i64
      %bbc9_80 = "braid.lshr"(%bbc9_1, %bbc9_56) : (i64, i64) -> i64
      %bbc9_81 = "braid.lshr"(%bbc9_0, %bbc9_57) : (i64, i64) -> i64
      %bbc9_88 = "braid.shl"(%bbc9_80, %bbc9_40) : (i64, i64) -> i64
      %bbc9_89 = "braid.shl"(%bbc9_81, %bbc9_40) : (i64, i64) -> i64
      %bbc9_96 = "braid.or"(%bbc9_72, %bbc9_88) : (i64, i64) -> i64
      %bbc9_97 = "braid.or"(%bbc9_73, %bbc9_89) : (i64, i64) -> i64
      "braid.set"(%bbc9_96) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bbc9_97) {reg = "zmm3.1"} : (i64) -> ()
      "braid_cf.br"()[^bbce] : () -> ()
    ^bbce:  // 0x4010ce
      %bbce_1 = "braid.get"() {reg = "rax"} : () -> i64
      %bbce_0 = "braid.zext"(%bbce_1) {bits = 32 : i64} : (i64) -> i64
      %bbce_8 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbce_16 = "braid.sub"(%bbce_0, %bbce_8) : (i64, i64) -> i64
      %bbce_17 = "braid.zext"(%bbce_16) {bits = 32 : i64} : (i64) -> i64
      %bbce_19 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbce_20 = "braid.eq"(%bbce_0, %bbce_19) : (i64, i64) -> i64
      "braid.setf"(%bbce_20) {flag = "of"} : (i64) -> ()
      %bbce_24 = "braid.havoc"() : () -> i64
      "braid.setf"(%bbce_24) {flag = "af"} : (i64) -> ()
      %bbce_32 = "braid.zext"(%bbce_17) {bits = 8 : i64} : (i64) -> i64
      %bbce_33 = "braid.popcnt"(%bbce_32) : (i64) -> i64
      %bbce_34 = "braid.const"() {value = 1 : i64} : () -> i64
      %bbce_35 = "braid.and"(%bbce_33, %bbce_34) : (i64, i64) -> i64
      %bbce_36 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbce_37 = "braid.eq"(%bbce_35, %bbce_36) : (i64, i64) -> i64
      "braid.setf"(%bbce_37) {flag = "pf"} : (i64) -> ()
      %bbce_38 = "braid.eq"(%bbce_17, %bbce_36) : (i64, i64) -> i64
      "braid.setf"(%bbce_38) {flag = "zf"} : (i64) -> ()
      %bbce_39 = "braid.const"() {value = 2147483648 : i64} : () -> i64
      %bbce_40 = "braid.and"(%bbce_17, %bbce_39) : (i64, i64) -> i64
      "braid.setf"(%bbce_40) {flag = "sf"} : (i64) -> ()
      "braid.set"(%bbce_17) {reg = "rax"} : (i64) -> ()
      "braid_cf.br"()[^bbd0] : () -> ()
    ^bbd0:  // 0x4010d0
      %bbd0_1 = "braid.getf"() {flag = "zf"} : () -> i64
      %bbd0_2 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd0_0 = "braid.eq"(%bbd0_1, %bbd0_2) : (i64, i64) -> i64
      "braid_cf.cond_br"(%bbd0_0)[^bb20, ^bbd6] : (i64) -> ()
    ^bbd6:  // 0x4010d6
      %bbd6_8 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbd6_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbd6_25 = "braid.add"(%bbd6_8, %bbd6_24) : (i64, i64) -> i64
      %bbd6_0 = "braid.load"(%bbd6_25) {bytes = 8 : i64} : (i64) -> i64
      %bbd6_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbd6_27 = "braid.add"(%bbd6_8, %bbd6_26) : (i64, i64) -> i64
      %bbd6_1 = "braid.load"(%bbd6_27) {bytes = 8 : i64} : (i64) -> i64
      %bbd6_40 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bbd6_41 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bbd6_80 = "braid.lanes"(%bbd6_40, %bbd6_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bbd6_81 = "braid.lanes"(%bbd6_41, %bbd6_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bbd6_80) {reg = "zmm0.0"} : (i64) -> ()
      "braid.set"(%bbd6_81) {reg = "zmm0.1"} : (i64) -> ()
      %bbd6_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bbd6_96) {reg = "zmm0.2"} : (i64) -> ()
      "braid.set"(%bbd6_96) {reg = "zmm0.3"} : (i64) -> ()
      "braid.set"(%bbd6_96) {reg = "zmm0.4"} : (i64) -> ()
      "braid.set"(%bbd6_96) {reg = "zmm0.5"} : (i64) -> ()
      "braid.set"(%bbd6_96) {reg = "zmm0.6"} : (i64) -> ()
      "braid.set"(%bbd6_96) {reg = "zmm0.7"} : (i64) -> ()
      "braid_cf.br"()[^bbda] : () -> ()
    ^bbda:  // 0x4010da
      %bbda_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbda_10 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbda_8 = "braid.add"(%bbda_9, %bbda_10) : (i64, i64) -> i64
      %bbda_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbda_25 = "braid.add"(%bbda_8, %bbda_24) : (i64, i64) -> i64
      %bbda_0 = "braid.load"(%bbda_25) {bytes = 8 : i64} : (i64) -> i64
      %bbda_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbda_27 = "braid.add"(%bbda_8, %bbda_26) : (i64, i64) -> i64
      %bbda_1 = "braid.load"(%bbda_27) {bytes = 8 : i64} : (i64) -> i64
      %bbda_40 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bbda_41 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bbda_80 = "braid.lanes"(%bbda_40, %bbda_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bbda_81 = "braid.lanes"(%bbda_41, %bbda_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bbda_80) {reg = "zmm1.0"} : (i64) -> ()
      "braid.set"(%bbda_81) {reg = "zmm1.1"} : (i64) -> ()
      %bbda_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bbda_96) {reg = "zmm1.2"} : (i64) -> ()
      "braid.set"(%bbda_96) {reg = "zmm1.3"} : (i64) -> ()
      "braid.set"(%bbda_96) {reg = "zmm1.4"} : (i64) -> ()
      "braid.set"(%bbda_96) {reg = "zmm1.5"} : (i64) -> ()
      "braid.set"(%bbda_96) {reg = "zmm1.6"} : (i64) -> ()
      "braid.set"(%bbda_96) {reg = "zmm1.7"} : (i64) -> ()
      "braid_cf.br"()[^bbdf] : () -> ()
    ^bbdf:  // 0x4010df
      %bbdf_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbdf_10 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbdf_8 = "braid.add"(%bbdf_9, %bbdf_10) : (i64, i64) -> i64
      %bbdf_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbdf_25 = "braid.add"(%bbdf_8, %bbdf_24) : (i64, i64) -> i64
      %bbdf_0 = "braid.load"(%bbdf_25) {bytes = 8 : i64} : (i64) -> i64
      %bbdf_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbdf_27 = "braid.add"(%bbdf_8, %bbdf_26) : (i64, i64) -> i64
      %bbdf_1 = "braid.load"(%bbdf_27) {bytes = 8 : i64} : (i64) -> i64
      %bbdf_40 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bbdf_41 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bbdf_80 = "braid.lanes"(%bbdf_40, %bbdf_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bbdf_81 = "braid.lanes"(%bbdf_41, %bbdf_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bbdf_80) {reg = "zmm2.0"} : (i64) -> ()
      "braid.set"(%bbdf_81) {reg = "zmm2.1"} : (i64) -> ()
      %bbdf_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bbdf_96) {reg = "zmm2.2"} : (i64) -> ()
      "braid.set"(%bbdf_96) {reg = "zmm2.3"} : (i64) -> ()
      "braid.set"(%bbdf_96) {reg = "zmm2.4"} : (i64) -> ()
      "braid.set"(%bbdf_96) {reg = "zmm2.5"} : (i64) -> ()
      "braid.set"(%bbdf_96) {reg = "zmm2.6"} : (i64) -> ()
      "braid.set"(%bbdf_96) {reg = "zmm2.7"} : (i64) -> ()
      "braid_cf.br"()[^bbe4] : () -> ()
    ^bbe4:  // 0x4010e4
      %bbe4_9 = "braid.get"() {reg = "rsi"} : () -> i64
      %bbe4_10 = "braid.const"() {value = 48 : i64} : () -> i64
      %bbe4_8 = "braid.add"(%bbe4_9, %bbe4_10) : (i64, i64) -> i64
      %bbe4_24 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe4_25 = "braid.add"(%bbe4_8, %bbe4_24) : (i64, i64) -> i64
      %bbe4_0 = "braid.load"(%bbe4_25) {bytes = 8 : i64} : (i64) -> i64
      %bbe4_26 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbe4_27 = "braid.add"(%bbe4_8, %bbe4_26) : (i64, i64) -> i64
      %bbe4_1 = "braid.load"(%bbe4_27) {bytes = 8 : i64} : (i64) -> i64
      %bbe4_40 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bbe4_41 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bbe4_80 = "braid.lanes"(%bbe4_40, %bbe4_0) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      %bbe4_81 = "braid.lanes"(%bbe4_41, %bbe4_1) {op = "add", bits = 32 : i64} : (i64, i64) -> i64
      "braid.set"(%bbe4_80) {reg = "zmm3.0"} : (i64) -> ()
      "braid.set"(%bbe4_81) {reg = "zmm3.1"} : (i64) -> ()
      %bbe4_96 = "braid.const"() {value = 0 : i64} : () -> i64
      "braid.set"(%bbe4_96) {reg = "zmm3.2"} : (i64) -> ()
      "braid.set"(%bbe4_96) {reg = "zmm3.3"} : (i64) -> ()
      "braid.set"(%bbe4_96) {reg = "zmm3.4"} : (i64) -> ()
      "braid.set"(%bbe4_96) {reg = "zmm3.5"} : (i64) -> ()
      "braid.set"(%bbe4_96) {reg = "zmm3.6"} : (i64) -> ()
      "braid.set"(%bbe4_96) {reg = "zmm3.7"} : (i64) -> ()
      "braid_cf.br"()[^bbe9] : () -> ()
    ^bbe9:  // 0x4010e9
      %bbe9_0 = "braid.get"() {reg = "zmm0.0"} : () -> i64
      %bbe9_1 = "braid.get"() {reg = "zmm0.1"} : () -> i64
      %bbe9_40 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbe9_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbe9_57 = "braid.add"(%bbe9_40, %bbe9_56) : (i64, i64) -> i64
      "braid.store"(%bbe9_57, %bbe9_0) {bytes = 8 : i64} : (i64, i64) -> ()
      %bbe9_58 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbe9_59 = "braid.add"(%bbe9_40, %bbe9_58) : (i64, i64) -> i64
      "braid.store"(%bbe9_59, %bbe9_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbef] : () -> ()
    ^bbef:  // 0x4010ef
      %bbef_0 = "braid.get"() {reg = "zmm1.0"} : () -> i64
      %bbef_1 = "braid.get"() {reg = "zmm1.1"} : () -> i64
      %bbef_41 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbef_42 = "braid.const"() {value = 16 : i64} : () -> i64
      %bbef_40 = "braid.add"(%bbef_41, %bbef_42) : (i64, i64) -> i64
      %bbef_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbef_57 = "braid.add"(%bbef_40, %bbef_56) : (i64, i64) -> i64
      "braid.store"(%bbef_57, %bbef_0) {bytes = 8 : i64} : (i64, i64) -> ()
      %bbef_58 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbef_59 = "braid.add"(%bbef_40, %bbef_58) : (i64, i64) -> i64
      "braid.store"(%bbef_59, %bbef_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbf6] : () -> ()
    ^bbf6:  // 0x4010f6
      %bbf6_0 = "braid.get"() {reg = "zmm2.0"} : () -> i64
      %bbf6_1 = "braid.get"() {reg = "zmm2.1"} : () -> i64
      %bbf6_41 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbf6_42 = "braid.const"() {value = 32 : i64} : () -> i64
      %bbf6_40 = "braid.add"(%bbf6_41, %bbf6_42) : (i64, i64) -> i64
      %bbf6_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbf6_57 = "braid.add"(%bbf6_40, %bbf6_56) : (i64, i64) -> i64
      "braid.store"(%bbf6_57, %bbf6_0) {bytes = 8 : i64} : (i64, i64) -> ()
      %bbf6_58 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbf6_59 = "braid.add"(%bbf6_40, %bbf6_58) : (i64, i64) -> i64
      "braid.store"(%bbf6_59, %bbf6_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bbfd] : () -> ()
    ^bbfd:  // 0x4010fd
      %bbfd_0 = "braid.get"() {reg = "zmm3.0"} : () -> i64
      %bbfd_1 = "braid.get"() {reg = "zmm3.1"} : () -> i64
      %bbfd_41 = "braid.get"() {reg = "rdi"} : () -> i64
      %bbfd_42 = "braid.const"() {value = 48 : i64} : () -> i64
      %bbfd_40 = "braid.add"(%bbfd_41, %bbfd_42) : (i64, i64) -> i64
      %bbfd_56 = "braid.const"() {value = 0 : i64} : () -> i64
      %bbfd_57 = "braid.add"(%bbfd_40, %bbfd_56) : (i64, i64) -> i64
      "braid.store"(%bbfd_57, %bbfd_0) {bytes = 8 : i64} : (i64, i64) -> ()
      %bbfd_58 = "braid.const"() {value = 8 : i64} : () -> i64
      %bbfd_59 = "braid.add"(%bbfd_40, %bbfd_58) : (i64, i64) -> i64
      "braid.store"(%bbfd_59, %bbfd_1) {bytes = 8 : i64} : (i64, i64) -> ()
      "braid_cf.br"()[^bb104] : () -> ()
    ^bb104:  // 0x401104
      %bb104_0 = "braid.get"() {reg = "rsp"} : () -> i64
      %bb104_1 = "braid.load"(%bb104_0) {bytes = 8 : i64} : (i64) -> i64
      %bb104_2 = "braid.const"() {value = 8 : i64} : () -> i64
      %bb104_3 = "braid.add"(%bb104_0, %bb104_2) : (i64, i64) -> i64
      "braid.set"(%bb104_3) {reg = "rsp"} : (i64) -> ()
      "braid_cf.br_ind"(%bb104_1) : (i64) -> ()
  }) {sym_name = "chacha20_block_vec", entry = 4198400 : i64} : () -> ()
}) {arch = "x86_64"} : () -> ()
