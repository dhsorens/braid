/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.JsBasic.Arm


/-- The instruction words of `js_add3`, from `0x10000`. -/
def js_add3_words : List (BitVec 32) := [
  0xf85f8050#32, 0xb8435210#32, 0x36000070#32, 0x580006b1#32, 0xd61f0220#32, 0xa9bf7bfd#32, 0x910003fd#32, 0xa9be03ff#32, 0xa9016fe1#32, 0xf8520342#32, 0xf90003fb#32, 0xeb2263ff#32, 0x54000369#32, 0xf9401fe2#32, 0x7200005f#32, 0x54000621#32, 0xf94023e3#32, 0x9360fc64#32, 0x9360fc45#32, 0x7200007f#32, 0x540005a1#32, 0x2b0400a4#32, 0x54000586#32, 0xf94027e5#32, 0x720000bf#32, 0x54000541#32, 0x9360fca2#32, 0xb020082#32, 0xd3607c40#32, 0xf85e83a3#32, 0x910003bf#32, 0xa8c17bfd#32, 0xf100107f#32, 0x5400004a#32, 0xd2800083#32, 0x91000470#32, 0x927ffa10#32, 0x8b306fff#32, 0xd65f03c0#32, 0xd2c00402#32, 0xd10043ff#32, 0xf90007ff#32, 0xf90003e2#32, 0xd2832701#32, 0xf2a02c61#32, 0xf2c00021#32, 0xd2800020#32, 0x580000fb#32, 0x58000150#32, 0xd63f0200#32, 0x17ffffdb#32, 0xd503201f#32, 0x580000ff#32, 0xd63f03e0#32, 0x9c0c11f9#32, 0x28f8#32, 0x1909ae0#32, 0x1#32, 0x1990be0#32, 0x1#32, 0xf8548350#32, 0xd61f0200#32, 0xf8550350#32, 0xd61f0200#32, 0x97fffffc#32, 0x97fffffb#32, 0x97fffffa#32, 0x97fffff9#32, 0x97fffffa#32]

/-- `js_add3`, lowered to `braid`. -/
def js_add3 : Braid.Func :=
  { name := "js_add3", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 1 2, .const 6 0xfffffffffffffff8#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 16 30], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.get 1 16, .const 6 0x35#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 16 30], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 0 16, .const 1 0x1#64, .bin 2 .and 0 1], term := .branch 2 0x1000c#64 0x10014#64 }),
    (0x1000c#64, { ops := [.const 0 0x100e0#64, .load 1 .w64 0, .set 17 1], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.get 0 17], term := .jumpInd 0 }),
    (0x10014#64, { ops := [.get 0 29, .get 1 30, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0xfffffffffffffff0#64, .bin 2 .add 3 8, .set 31 2, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x10018#64 }),
    (0x10018#64, { ops := [.get 0 31, .const 2 0x0#64, .bin 3 .add 0 2, .set 29 3], term := .jump 0x1001c#64 }),
    (0x1001c#64, { ops := [.const 0 0x0#64, .get 1 0, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0xffffffffffffffe0#64, .bin 2 .add 3 8, .set 31 2, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 0 1, .get 1 27, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x10#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 1 26, .const 6 0xffffffffffffff20#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 2 30], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 27, .get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .store .w64 1 0], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 0 31, .get 2 2, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.getf 1 2, .getf 2 1, .bin 0 .ule 1 2], term := .branch 0 0x1009c#64 0x10034#64 }),
    (0x10034#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x38#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 2 30], term := .jump 0x10038#64 }),
    (0x10038#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .const 2 0x1#64, .bin 3 .and 0 2, .const 4 0x0#64, .un 7 (.sext 32) 3, .bin 5 .slt 7 4, .bin 6 .eq 3 4, .setf 0 5, .setf 1 6, .setf 2 4, .setf 3 4], term := .jump 0x1003c#64 }),
    (0x1003c#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10100#64 0x10040#64 }),
    (0x10040#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x40#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 3 30], term := .jump 0x10044#64 }),
    (0x10044#64, { ops := [.get 0 3, .const 3 0x20#64, .bin 20 .ashr 0 3, .set 4 20], term := .jump 0x10048#64 }),
    (0x10048#64, { ops := [.get 0 2, .const 3 0x20#64, .bin 20 .ashr 0 3, .set 5 20], term := .jump 0x1004c#64 }),
    (0x1004c#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .const 2 0x1#64, .bin 3 .and 0 2, .const 4 0x0#64, .un 7 (.sext 32) 3, .bin 5 .slt 7 4, .bin 6 .eq 3 4, .setf 0 5, .setf 1 6, .setf 2 4, .setf 3 4], term := .jump 0x10050#64 }),
    (0x10050#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10104#64 0x10054#64 }),
    (0x10054#64, { ops := [.get 1 5, .un 0 (.zext 32) 1, .get 3 4, .un 2 (.zext 32) 3, .bin 17 .add 0 2, .un 12 (.zext 32) 17, .const 18 0x0#64, .un 19 (.sext 32) 12, .bin 13 .slt 19 18, .bin 14 .eq 12 18, .bin 15 .ne 12 17, .bin 20 .xor 0 12, .bin 21 .xor 2 12, .bin 22 .and 20 21, .un 23 (.sext 32) 22, .bin 16 .slt 23 18, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16, .set 4 12], term := .jump 0x10058#64 }),
    (0x10058#64, { ops := [.getf 0 3], term := .branch 0 0x10108#64 0x1005c#64 }),
    (0x1005c#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x48#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 5 30], term := .jump 0x10060#64 }),
    (0x10060#64, { ops := [.get 1 5, .un 0 (.zext 32) 1, .const 2 0x1#64, .bin 3 .and 0 2, .const 4 0x0#64, .un 7 (.sext 32) 3, .bin 5 .slt 7 4, .bin 6 .eq 3 4, .setf 0 5, .setf 1 6, .setf 2 4, .setf 3 4], term := .jump 0x10064#64 }),
    (0x10064#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x1010c#64 0x10068#64 }),
    (0x10068#64, { ops := [.get 0 5, .const 3 0x20#64, .bin 20 .ashr 0 3, .set 2 20], term := .jump 0x1006c#64 }),
    (0x1006c#64, { ops := [.get 1 4, .un 0 (.zext 32) 1, .get 3 2, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 2 12], term := .jump 0x10070#64 }),
    (0x10070#64, { ops := [.get 0 2, .const 3 0x20#64, .bin 20 .shl 0 3, .set 0 20], term := .jump 0x10074#64 }),
    (0x10074#64, { ops := [.get 1 29, .const 6 0xffffffffffffffe8#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 3 30], term := .jump 0x10078#64 }),
    (0x10078#64, { ops := [.get 0 29, .const 2 0x0#64, .bin 3 .add 0 2, .set 31 3], term := .jump 0x1007c#64 }),
    (0x1007c#64, { ops := [.get 0 31, .const 1 0xf#64, .bin 2 .and 0 1, .const 3 0x0#64, .bin 4 .eq 2 3, .guard 4, .const 5 0x10#64, .bin 6 .add 0 5, .set 31 6, .const 21 0x8#64, .bin 22 .add 0 21, .load 23 .w64 0, .load 26 .w64 22, .set 29 23, .set 30 26], term := .jump 0x10080#64 }),
    (0x10080#64, { ops := [.get 0 3, .const 2 0x4#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7], term := .jump 0x10084#64 }),
    (0x10084#64, { ops := [.getf 1 0, .getf 2 3, .bin 0 .eq 1 2], term := .branch 0 0x1008c#64 0x10088#64 }),
    (0x10088#64, { ops := [.const 0 0x4#64, .set 3 0], term := .jump 0x1008c#64 }),
    (0x1008c#64, { ops := [.get 0 3, .const 2 0x1#64, .bin 3 .add 0 2, .set 16 3], term := .jump 0x10090#64 }),
    (0x10090#64, { ops := [.get 0 16, .const 2 0xfffffffffffffffe#64, .bin 3 .and 0 2, .set 16 3], term := .jump 0x10094#64 }),
    (0x10094#64, { ops := [.get 0 31, .get 3 16, .const 4 0x3#64, .bin 2 .shl 3 4, .bin 12 .add 0 2, .set 31 12], term := .jump 0x10098#64 }),
    (0x10098#64, { ops := [.get 0 30], term := .jumpInd 0 }),
    (0x1009c#64, { ops := [.const 0 0x2000000000#64, .set 2 0], term := .jump 0x100a0#64 }),
    (0x100a0#64, { ops := [.get 0 31, .const 2 0x10#64, .bin 3 .sub 0 2, .set 31 3], term := .jump 0x100a4#64 }),
    (0x100a4#64, { ops := [.const 0 0x0#64, .get 2 31, .const 3 0xf#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .const 7 0x8#64, .bin 1 .add 2 7, .store .w64 1 0], term := .jump 0x100a8#64 }),
    (0x100a8#64, { ops := [.get 0 2, .get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .store .w64 1 0], term := .jump 0x100ac#64 }),
    (0x100ac#64, { ops := [.const 0 0x1938#64, .set 1 0], term := .jump 0x100b0#64 }),
    (0x100b0#64, { ops := [.get 0 1, .const 2 0xffffffff0000ffff#64, .bin 3 .and 0 2, .const 4 0x1630000#64, .bin 5 .or 3 4, .set 1 5], term := .jump 0x100b4#64 }),
    (0x100b4#64, { ops := [.get 0 1, .const 2 0xffff0000ffffffff#64, .bin 3 .and 0 2, .const 4 0x100000000#64, .bin 5 .or 3 4, .set 1 5], term := .jump 0x100b8#64 }),
    (0x100b8#64, { ops := [.const 0 0x1#64, .set 0 0], term := .jump 0x100bc#64 }),
    (0x100bc#64, { ops := [.const 0 0x100d8#64, .load 1 .w64 0, .set 27 1], term := .jump 0x100c0#64 }),
    (0x100c0#64, { ops := [.const 0 0x100e8#64, .load 1 .w64 0, .set 16 1], term := .jump 0x100c4#64 }),
    (0x100c4#64, { ops := [.get 0 16, .const 1 0x100c8#64, .set 30 1], term := .jumpInd 0 }),
    (0x100c8#64, { ops := [], term := .jump 0x10034#64 }),
    (0x100cc#64, { ops := [], term := .jump 0x100d0#64 }),
    (0x100d0#64, { ops := [.const 0 0x100ec#64, .load 1 .w64 0], term := .jump 0x100d4#64 }),
    (0x100d4#64, { ops := [.const 0 0x0#64, .const 1 0x100d8#64, .set 30 1], term := .jumpInd 0 }),
    (0x100d8#64, { ops := [], term := .trap "ldrSimdLit" }),
    (0x100dc#64, { ops := [], term := .trap "udf" }),
    (0x100e4#64, { ops := [], term := .trap "udf" }),
    (0x100ec#64, { ops := [], term := .trap "udf" }),
    (0x100f0#64, { ops := [.get 1 26, .const 6 0xffffffffffffff48#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 16 30], term := .jump 0x100f4#64 }),
    (0x100f4#64, { ops := [.get 0 16], term := .jumpInd 0 }),
    (0x100f8#64, { ops := [.get 1 26, .const 6 0xffffffffffffff50#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 16 30], term := .jump 0x100fc#64 }),
    (0x100fc#64, { ops := [.get 0 16], term := .jumpInd 0 }),
    (0x10100#64, { ops := [.const 0 0x10104#64, .set 30 0], term := .jump 0x100f0#64 }),
    (0x10104#64, { ops := [.const 0 0x10108#64, .set 30 0], term := .jump 0x100f0#64 }),
    (0x10108#64, { ops := [.const 0 0x1010c#64, .set 30 0], term := .jump 0x100f0#64 }),
    (0x1010c#64, { ops := [.const 0 0x10110#64, .set 30 0], term := .jump 0x100f0#64 }),
    (0x10110#64, { ops := [.const 0 0x10114#64, .set 30 0], term := .jump 0x100f8#64 })] }

/-- `js_add3` is the lowering of `js_add3_words`. -/
theorem js_add3_lowered :
    js_add3.blocks = Lowering.Arm.lowerWords 0x10000#64 js_add3_words := by
  decide

/-- The instruction words of `js_max`, from `0x10114`. -/
def js_max_words : List (BitVec 32) := [
  0xf85f8050#32, 0xb8435210#32, 0x36000070#32, 0x580005f1#32, 0xd61f0220#32, 0xa9bf7bfd#32, 0x910003fd#32, 0xa9be03ff#32, 0xa9016fe1#32, 0xf8520342#32, 0xf90003fb#32, 0xeb2263ff#32, 0x540002a9#32, 0xf94023e0#32, 0x7200001f#32, 0x54000561#32, 0xf9401fe2#32, 0x7200005f#32, 0x54000521#32, 0xeb02001f#32, 0x5400016b#32, 0xf85e83a3#32, 0x910003bf#32, 0xa8c17bfd#32, 0xf1000c7f#32, 0x5400004a#32, 0xd2800063#32, 0x91000470#32, 0x927ffa10#32, 0x8b306fff#32, 0xd65f03c0#32, 0xaa0203e0#32, 0x17fffff5#32, 0xd2c00502#32, 0xd10043ff#32, 0xf90007ff#32, 0xf90003e2#32, 0xd29b2701#32, 0xf2a09441#32, 0xf2c00021#32, 0xd2800020#32, 0x580000fb#32, 0x58000150#32, 0xd63f0200#32, 0x17ffffe1#32, 0xd503201f#32, 0x580000ff#32, 0xd63f03e0#32, 0x4f3011f9#32, 0x1be8#32, 0x4d05ae0#32, 0x1#32, 0x4d8cbe0#32, 0x1#32, 0xf8548350#32, 0xd61f0200#32, 0xf8550350#32, 0xd61f0200#32, 0x97fffffc#32, 0x97fffffb#32, 0x97fffffc#32]

/-- `js_max`, lowered to `braid`. -/
def js_max : Braid.Func :=
  { name := "js_max", entry := 0x10114#64, blocks := [
    (0x10114#64, { ops := [.get 1 2, .const 6 0xfffffffffffffff8#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 16 30], term := .jump 0x10118#64 }),
    (0x10118#64, { ops := [.get 1 16, .const 6 0x35#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 16 30], term := .jump 0x1011c#64 }),
    (0x1011c#64, { ops := [.get 0 16, .const 1 0x1#64, .bin 2 .and 0 1], term := .branch 2 0x10120#64 0x10128#64 }),
    (0x10120#64, { ops := [.const 0 0x101dc#64, .load 1 .w64 0, .set 17 1], term := .jump 0x10124#64 }),
    (0x10124#64, { ops := [.get 0 17], term := .jumpInd 0 }),
    (0x10128#64, { ops := [.get 0 29, .get 1 30, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0xfffffffffffffff0#64, .bin 2 .add 3 8, .set 31 2, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x1012c#64 }),
    (0x1012c#64, { ops := [.get 0 31, .const 2 0x0#64, .bin 3 .add 0 2, .set 29 3], term := .jump 0x10130#64 }),
    (0x10130#64, { ops := [.const 0 0x0#64, .get 1 0, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0xffffffffffffffe0#64, .bin 2 .add 3 8, .set 31 2, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x10134#64 }),
    (0x10134#64, { ops := [.get 0 1, .get 1 27, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x10#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x10138#64 }),
    (0x10138#64, { ops := [.get 1 26, .const 6 0xffffffffffffff20#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 2 30], term := .jump 0x1013c#64 }),
    (0x1013c#64, { ops := [.get 0 27, .get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .store .w64 1 0], term := .jump 0x10140#64 }),
    (0x10140#64, { ops := [.get 0 31, .get 2 2, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x10144#64 }),
    (0x10144#64, { ops := [.getf 1 2, .getf 2 1, .bin 0 .ule 1 2], term := .branch 0 0x10198#64 0x10148#64 }),
    (0x10148#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x40#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 0 30], term := .jump 0x1014c#64 }),
    (0x1014c#64, { ops := [.get 1 0, .un 0 (.zext 32) 1, .const 2 0x1#64, .bin 3 .and 0 2, .const 4 0x0#64, .un 7 (.sext 32) 3, .bin 5 .slt 7 4, .bin 6 .eq 3 4, .setf 0 5, .setf 1 6, .setf 2 4, .setf 3 4], term := .jump 0x10150#64 }),
    (0x10150#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x101fc#64 0x10154#64 }),
    (0x10154#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x38#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 2 30], term := .jump 0x10158#64 }),
    (0x10158#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .const 2 0x1#64, .bin 3 .and 0 2, .const 4 0x0#64, .un 7 (.sext 32) 3, .bin 5 .slt 7 4, .bin 6 .eq 3 4, .setf 0 5, .setf 1 6, .setf 2 4, .setf 3 4], term := .jump 0x1015c#64 }),
    (0x1015c#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10200#64 0x10160#64 }),
    (0x10160#64, { ops := [.get 0 0, .get 2 2, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x10164#64 }),
    (0x10164#64, { ops := [.getf 1 0, .getf 2 3, .bin 0 .ne 1 2], term := .branch 0 0x10190#64 0x10168#64 }),
    (0x10168#64, { ops := [.get 1 29, .const 6 0xffffffffffffffe8#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 3 30], term := .jump 0x1016c#64 }),
    (0x1016c#64, { ops := [.get 0 29, .const 2 0x0#64, .bin 3 .add 0 2, .set 31 3], term := .jump 0x10170#64 }),
    (0x10170#64, { ops := [.get 0 31, .const 1 0xf#64, .bin 2 .and 0 1, .const 3 0x0#64, .bin 4 .eq 2 3, .guard 4, .const 5 0x10#64, .bin 6 .add 0 5, .set 31 6, .const 21 0x8#64, .bin 22 .add 0 21, .load 23 .w64 0, .load 26 .w64 22, .set 29 23, .set 30 26], term := .jump 0x10174#64 }),
    (0x10174#64, { ops := [.get 0 3, .const 2 0x3#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7], term := .jump 0x10178#64 }),
    (0x10178#64, { ops := [.getf 1 0, .getf 2 3, .bin 0 .eq 1 2], term := .branch 0 0x10180#64 0x1017c#64 }),
    (0x1017c#64, { ops := [.const 0 0x3#64, .set 3 0], term := .jump 0x10180#64 }),
    (0x10180#64, { ops := [.get 0 3, .const 2 0x1#64, .bin 3 .add 0 2, .set 16 3], term := .jump 0x10184#64 }),
    (0x10184#64, { ops := [.get 0 16, .const 2 0xfffffffffffffffe#64, .bin 3 .and 0 2, .set 16 3], term := .jump 0x10188#64 }),
    (0x10188#64, { ops := [.get 0 31, .get 3 16, .const 4 0x3#64, .bin 2 .shl 3 4, .bin 12 .add 0 2, .set 31 12], term := .jump 0x1018c#64 }),
    (0x1018c#64, { ops := [.get 0 30], term := .jumpInd 0 }),
    (0x10190#64, { ops := [.const 0 0x0#64, .get 2 2, .bin 12 .or 0 2, .set 0 12], term := .jump 0x10194#64 }),
    (0x10194#64, { ops := [], term := .jump 0x10168#64 }),
    (0x10198#64, { ops := [.const 0 0x2800000000#64, .set 2 0], term := .jump 0x1019c#64 }),
    (0x1019c#64, { ops := [.get 0 31, .const 2 0x10#64, .bin 3 .sub 0 2, .set 31 3], term := .jump 0x101a0#64 }),
    (0x101a0#64, { ops := [.const 0 0x0#64, .get 2 31, .const 3 0xf#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .const 7 0x8#64, .bin 1 .add 2 7, .store .w64 1 0], term := .jump 0x101a4#64 }),
    (0x101a4#64, { ops := [.get 0 2, .get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .store .w64 1 0], term := .jump 0x101a8#64 }),
    (0x101a8#64, { ops := [.const 0 0xd938#64, .set 1 0], term := .jump 0x101ac#64 }),
    (0x101ac#64, { ops := [.get 0 1, .const 2 0xffffffff0000ffff#64, .bin 3 .and 0 2, .const 4 0x4a20000#64, .bin 5 .or 3 4, .set 1 5], term := .jump 0x101b0#64 }),
    (0x101b0#64, { ops := [.get 0 1, .const 2 0xffff0000ffffffff#64, .bin 3 .and 0 2, .const 4 0x100000000#64, .bin 5 .or 3 4, .set 1 5], term := .jump 0x101b4#64 }),
    (0x101b4#64, { ops := [.const 0 0x1#64, .set 0 0], term := .jump 0x101b8#64 }),
    (0x101b8#64, { ops := [.const 0 0x101d4#64, .load 1 .w64 0, .set 27 1], term := .jump 0x101bc#64 }),
    (0x101bc#64, { ops := [.const 0 0x101e4#64, .load 1 .w64 0, .set 16 1], term := .jump 0x101c0#64 }),
    (0x101c0#64, { ops := [.get 0 16, .const 1 0x101c4#64, .set 30 1], term := .jumpInd 0 }),
    (0x101c4#64, { ops := [], term := .jump 0x10148#64 }),
    (0x101c8#64, { ops := [], term := .jump 0x101cc#64 }),
    (0x101cc#64, { ops := [.const 0 0x101e8#64, .load 1 .w64 0], term := .jump 0x101d0#64 }),
    (0x101d0#64, { ops := [.const 0 0x0#64, .const 1 0x101d4#64, .set 30 1], term := .jumpInd 0 }),
    (0x101d8#64, { ops := [], term := .trap "udf" }),
    (0x101e0#64, { ops := [], term := .trap "udf" }),
    (0x101e8#64, { ops := [], term := .trap "udf" }),
    (0x101ec#64, { ops := [.get 1 26, .const 6 0xffffffffffffff48#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 16 30], term := .jump 0x101f0#64 }),
    (0x101f0#64, { ops := [.get 0 16], term := .jumpInd 0 }),
    (0x101f4#64, { ops := [.get 1 26, .const 6 0xffffffffffffff50#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 16 30], term := .jump 0x101f8#64 }),
    (0x101f8#64, { ops := [.get 0 16], term := .jumpInd 0 }),
    (0x101fc#64, { ops := [.const 0 0x10200#64, .set 30 0], term := .jump 0x101ec#64 }),
    (0x10200#64, { ops := [.const 0 0x10204#64, .set 30 0], term := .jump 0x101ec#64 }),
    (0x10204#64, { ops := [.const 0 0x10208#64, .set 30 0], term := .jump 0x101f4#64 })] }

/-- `js_max` is the lowering of `js_max_words`. -/
theorem js_max_lowered :
    js_max.blocks = Lowering.Arm.lowerWords 0x10114#64 js_max_words := by
  decide

end Examples.JsBasic.Arm
