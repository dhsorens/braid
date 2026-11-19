/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Program

@[expose] public section

namespace Examples.Sha256Main.Arm


/-- The instruction words of `sha256_compress`, from `0x100bc`. -/
def sha256_compress_words : List (BitVec 32) := [
  0xd104c3ff#32, 0xaa1f03e8#32, 0x910083e9#32, 0xf90093fd#32, 0xb868682a#32, 0xb828692a#32, 0x91001108#32, 0xf101011f#32, 0x54ffff81#32, 0x910083e8#32, 0x52800609#32, 0x91010108#32, 0xb85f810a#32, 0xb85e410f#32, 0xf1000529#32, 0x29782d0d#32, 0x138a454c#32, 0x138b1d6e#32, 0x4aca4d8c#32, 0x4acb49ce#32, 0x4a4a298a#32, 0xb0d01ec#32, 0x4a4b0dcb#32, 0xb0c014a#32, 0xb0b014a#32, 0xb800450a#32, 0x54fffe41#32, 0xaa1f03e8#32, 0x910003e9#32, 0xb868680a#32, 0xb828692a#32, 0x91001108#32, 0xf100811f#32, 0x54ffff81#32, 0x294027f1#32, 0x294133ea#32, 0x29422ff2#32, 0x29433bed#32, 0xaa1f03e8#32, 0xd503201f#32, 0x1008066f#32, 0x910083f0#32, 0xb86869e1#32, 0xb8686a02#32, 0x2a0c03e4#32, 0x2a0a03ec#32, 0x2a0903ea#32, 0x2a1103e9#32, 0x2a0e03e3#32, 0x2a0d03ee#32, 0x2a0b03ed#32, 0x2a1203eb#32, 0x13921a51#32, 0xb010052#32, 0x13890921#32, 0xb030252#32, 0xa0b01a2#32, 0x4acb2e31#32, 0xa2b01c3#32, 0xa0a0185#32, 0x4ac93421#32, 0x2a020062#32, 0x4a0a0183#32, 0x4acb6631#32, 0xa090063#32, 0xb020252#32, 0x4ac95821#32, 0x4a050062#32, 0x91001108#32, 0xb110251#32, 0xf104011f#32, 0xb010041#32, 0xb040232#32, 0xb110031#32, 0x54fffc01#32, 0xaa1f03e8#32, 0x290027f1#32, 0x910003e9#32, 0x290133ea#32, 0x29022ff2#32, 0x29033bed#32, 0xb868692a#32, 0xb868680b#32, 0xb0a016a#32, 0xb828680a#32, 0x91001108#32, 0xf100811f#32, 0x54ffff41#32, 0xf94093fd#32, 0x9104c3ff#32, 0xd65f03c0#32]

/-- `sha256_compress`, lowered to `braid`. -/
def sha256_compress : Braid.Func :=
  { name := "sha256_compress", entry := 0x100bc#64, blocks := [
    (0x100bc#64, { ops := [.get 0 31, .const 2 0x130#64, .bin 3 .sub 0 2, .set 31 3], term := .jump 0x100c0#64 }),
    (0x100c0#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 8 12], term := .jump 0x100c4#64 }),
    (0x100c4#64, { ops := [.get 0 31, .const 2 0x20#64, .bin 3 .add 0 2, .set 9 3], term := .jump 0x100c8#64 }),
    (0x100c8#64, { ops := [.get 0 29, .get 2 31, .const 3 0xf#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .const 7 0x120#64, .bin 1 .add 2 7, .store .w64 1 0], term := .jump 0x100cc#64 }),
    (0x100cc#64, { ops := [.get 1 1, .get 6 8, .bin 0 .add 1 6, .load 30 .w32 0, .set 10 30], term := .jump 0x100d0#64 }),
    (0x100d0#64, { ops := [.get 0 10, .get 2 9, .get 7 8, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x100d4#64 }),
    (0x100d4#64, { ops := [.get 0 8, .const 2 0x4#64, .bin 3 .add 0 2, .set 8 3], term := .jump 0x100d8#64 }),
    (0x100d8#64, { ops := [.get 0 8, .const 2 0x40#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7], term := .jump 0x100dc#64 }),
    (0x100dc#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x100cc#64 0x100e0#64 }),
    (0x100e0#64, { ops := [.get 0 31, .const 2 0x20#64, .bin 3 .add 0 2, .set 8 3], term := .jump 0x100e4#64 }),
    (0x100e4#64, { ops := [.const 0 0x30#64, .set 9 0], term := .jump 0x100e8#64 }),
    (0x100e8#64, { ops := [.get 0 8, .const 2 0x40#64, .bin 3 .add 0 2, .set 8 3], term := .jump 0x100ec#64 }),
    (0x100ec#64, { ops := [.get 1 8, .const 6 0xfffffffffffffff8#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 10 30], term := .jump 0x100f0#64 }),
    (0x100f0#64, { ops := [.get 1 8, .const 6 0xffffffffffffffe4#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 15 30], term := .jump 0x100f4#64 }),
    (0x100f4#64, { ops := [.get 0 9, .const 2 0x1#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 9 3], term := .jump 0x100f8#64 }),
    (0x100f8#64, { ops := [.get 1 8, .const 6 0xffffffffffffffc0#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 13 23, .set 11 26], term := .jump 0x100fc#64 }),
    (0x100fc#64, { ops := [.get 0 10, .get 1 10, .un 2 (.zext 32) 1, .const 3 0x11#64, .bin 4 .lshr 2 3, .const 5 0xf#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 12 9], term := .jump 0x10100#64 }),
    (0x10100#64, { ops := [.get 0 11, .get 1 11, .un 2 (.zext 32) 1, .const 3 0x7#64, .bin 4 .lshr 2 3, .const 5 0x19#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 14 9], term := .jump 0x10104#64 }),
    (0x10104#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 3 10, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0x13#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 12 12], term := .jump 0x10108#64 }),
    (0x10108#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 11, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0x12#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 14 12], term := .jump 0x1010c#64 }),
    (0x1010c#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 3 10, .un 5 (.zext 32) 3, .const 6 0xa#64, .bin 2 .lshr 5 6, .bin 12 .xor 0 2, .set 10 12], term := .jump 0x10110#64 }),
    (0x10110#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 3 13, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 12 12], term := .jump 0x10114#64 }),
    (0x10114#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 11, .un 5 (.zext 32) 3, .const 6 0x3#64, .bin 2 .lshr 5 6, .bin 12 .xor 0 2, .set 11 12], term := .jump 0x10118#64 }),
    (0x10118#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 12, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 10 12], term := .jump 0x1011c#64 }),
    (0x1011c#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 11, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 10 12], term := .jump 0x10120#64 }),
    (0x10120#64, { ops := [.get 0 10, .get 1 8, .const 6 0x4#64, .bin 7 .add 1 6, .set 8 7, .store .w32 1 0], term := .jump 0x10124#64 }),
    (0x10124#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x100ec#64 0x10128#64 }),
    (0x10128#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 8 12], term := .jump 0x1012c#64 }),
    (0x1012c#64, { ops := [.get 0 31, .const 2 0x0#64, .bin 3 .add 0 2, .set 9 3], term := .jump 0x10130#64 }),
    (0x10130#64, { ops := [.get 1 0, .get 6 8, .bin 0 .add 1 6, .load 30 .w32 0, .set 10 30], term := .jump 0x10134#64 }),
    (0x10134#64, { ops := [.get 0 10, .get 2 9, .get 7 8, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x10138#64 }),
    (0x10138#64, { ops := [.get 0 8, .const 2 0x4#64, .bin 3 .add 0 2, .set 8 3], term := .jump 0x1013c#64 }),
    (0x1013c#64, { ops := [.get 0 8, .const 2 0x20#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7], term := .jump 0x10140#64 }),
    (0x10140#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10130#64 0x10144#64 }),
    (0x10144#64, { ops := [.get 0 31, .const 1 0xf#64, .bin 2 .and 0 1, .const 3 0x0#64, .bin 4 .eq 2 3, .guard 4, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 17 23, .set 9 26], term := .jump 0x10148#64 }),
    (0x10148#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x8#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 10 23, .set 12 26], term := .jump 0x1014c#64 }),
    (0x1014c#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x10#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 18 23, .set 11 26], term := .jump 0x10150#64 }),
    (0x10150#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x18#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 13 23, .set 14 26], term := .jump 0x10154#64 }),
    (0x10154#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10158#64 }),
    (0x10158#64, { ops := [], term := .jump 0x1015c#64 }),
    (0x1015c#64, { ops := [.const 0 0x20228#64, .set 15 0], term := .jump 0x10160#64 }),
    (0x10160#64, { ops := [.get 0 31, .const 2 0x20#64, .bin 3 .add 0 2, .set 16 3], term := .jump 0x10164#64 }),
    (0x10164#64, { ops := [.get 1 15, .get 6 8, .bin 0 .add 1 6, .load 30 .w32 0, .set 1 30], term := .jump 0x10168#64 }),
    (0x10168#64, { ops := [.get 1 16, .get 6 8, .bin 0 .add 1 6, .load 30 .w32 0, .set 2 30], term := .jump 0x1016c#64 }),
    (0x1016c#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 12, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 4 12], term := .jump 0x10170#64 }),
    (0x10170#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 10, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 12 12], term := .jump 0x10174#64 }),
    (0x10174#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 9, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 10 12], term := .jump 0x10178#64 }),
    (0x10178#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 17, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 9 12], term := .jump 0x1017c#64 }),
    (0x1017c#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 14, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 3 12], term := .jump 0x10180#64 }),
    (0x10180#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 13, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 14 12], term := .jump 0x10184#64 }),
    (0x10184#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 11, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 13 12], term := .jump 0x10188#64 }),
    (0x10188#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 18, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 11 12], term := .jump 0x1018c#64 }),
    (0x1018c#64, { ops := [.get 0 18, .get 1 18, .un 2 (.zext 32) 1, .const 3 0x6#64, .bin 4 .lshr 2 3, .const 5 0x1a#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 17 9], term := .jump 0x10190#64 }),
    (0x10190#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 3 1, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 18 12], term := .jump 0x10194#64 }),
    (0x10194#64, { ops := [.get 0 9, .get 1 9, .un 2 (.zext 32) 1, .const 3 0x2#64, .bin 4 .lshr 2 3, .const 5 0x1e#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 1 9], term := .jump 0x10198#64 }),
    (0x10198#64, { ops := [.get 1 18, .un 0 (.zext 32) 1, .get 3 3, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 18 12], term := .jump 0x1019c#64 }),
    (0x1019c#64, { ops := [.get 1 13, .un 0 (.zext 32) 1, .get 3 11, .un 2 (.zext 32) 3, .bin 12 .and 0 2, .set 2 12], term := .jump 0x101a0#64 }),
    (0x101a0#64, { ops := [.get 1 17, .un 0 (.zext 32) 1, .get 3 11, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0xb#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 17 12], term := .jump 0x101a4#64 }),
    (0x101a4#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 11, .un 2 (.zext 32) 3, .un 13 .not 2, .bin 12 .and 0 13, .set 3 12], term := .jump 0x101a8#64 }),
    (0x101a8#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 3 10, .un 2 (.zext 32) 3, .bin 12 .and 0 2, .set 5 12], term := .jump 0x101ac#64 }),
    (0x101ac#64, { ops := [.get 1 1, .un 0 (.zext 32) 1, .get 3 9, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0xd#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 1 12], term := .jump 0x101b0#64 }),
    (0x101b0#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 3 2, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 2 12], term := .jump 0x101b4#64 }),
    (0x101b4#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 3 10, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 3 12], term := .jump 0x101b8#64 }),
    (0x101b8#64, { ops := [.get 1 17, .un 0 (.zext 32) 1, .get 3 11, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0x19#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 17 12], term := .jump 0x101bc#64 }),
    (0x101bc#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 3 9, .un 2 (.zext 32) 3, .bin 12 .and 0 2, .set 3 12], term := .jump 0x101c0#64 }),
    (0x101c0#64, { ops := [.get 1 18, .un 0 (.zext 32) 1, .get 3 2, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 18 12], term := .jump 0x101c4#64 }),
    (0x101c4#64, { ops := [.get 1 1, .un 0 (.zext 32) 1, .get 3 9, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0x16#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 1 12], term := .jump 0x101c8#64 }),
    (0x101c8#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 3 5, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 2 12], term := .jump 0x101cc#64 }),
    (0x101cc#64, { ops := [.get 0 8, .const 2 0x4#64, .bin 3 .add 0 2, .set 8 3], term := .jump 0x101d0#64 }),
    (0x101d0#64, { ops := [.get 1 18, .un 0 (.zext 32) 1, .get 3 17, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 17 12], term := .jump 0x101d4#64 }),
    (0x101d4#64, { ops := [.get 0 8, .const 2 0x100#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7], term := .jump 0x101d8#64 }),
    (0x101d8#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 3 1, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 1 12], term := .jump 0x101dc#64 }),
    (0x101dc#64, { ops := [.get 1 17, .un 0 (.zext 32) 1, .get 3 4, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 18 12], term := .jump 0x101e0#64 }),
    (0x101e0#64, { ops := [.get 1 1, .un 0 (.zext 32) 1, .get 3 17, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 17 12], term := .jump 0x101e4#64 }),
    (0x101e4#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10164#64 0x101e8#64 }),
    (0x101e8#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 8 12], term := .jump 0x101ec#64 }),
    (0x101ec#64, { ops := [.get 0 17, .get 1 9, .get 2 31, .const 3 0xf#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x101f0#64 }),
    (0x101f0#64, { ops := [.get 0 31, .const 2 0x0#64, .bin 3 .add 0 2, .set 9 3], term := .jump 0x101f4#64 }),
    (0x101f4#64, { ops := [.get 0 10, .get 1 12, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x8#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x101f8#64 }),
    (0x101f8#64, { ops := [.get 0 18, .get 1 11, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x10#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x101fc#64 }),
    (0x101fc#64, { ops := [.get 0 13, .get 1 14, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x18#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x10200#64 }),
    (0x10200#64, { ops := [.get 1 9, .get 6 8, .bin 0 .add 1 6, .load 30 .w32 0, .set 10 30], term := .jump 0x10204#64 }),
    (0x10204#64, { ops := [.get 1 0, .get 6 8, .bin 0 .add 1 6, .load 30 .w32 0, .set 11 30], term := .jump 0x10208#64 }),
    (0x10208#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 3 10, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 10 12], term := .jump 0x1020c#64 }),
    (0x1020c#64, { ops := [.get 0 10, .get 2 0, .get 7 8, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x10210#64 }),
    (0x10210#64, { ops := [.get 0 8, .const 2 0x4#64, .bin 3 .add 0 2, .set 8 3], term := .jump 0x10214#64 }),
    (0x10214#64, { ops := [.get 0 8, .const 2 0x20#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7], term := .jump 0x10218#64 }),
    (0x10218#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10200#64 0x1021c#64 }),
    (0x1021c#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x120#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 29 30], term := .jump 0x10220#64 }),
    (0x10220#64, { ops := [.get 0 31, .const 2 0x130#64, .bin 3 .add 0 2, .set 31 3], term := .jump 0x10224#64 }),
    (0x10224#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `sha256_compress` is the lowering of `sha256_compress_words`. -/
theorem sha256_compress_lowered :
    sha256_compress.blocks = Lowering.Arm.lowerWordsEnv 0x100bc#64 sha256_compress_words := by
  decide

/-- The instruction words of `_start`, from `0x20328`. -/
def _start_words : List (BitVec 32) := [
  0x90000009#32, 0x91338129#32, 0x9100013f#32, 0x14000001#32]

/-- `_start`, lowered to `braid`. -/
def _start : Braid.Func :=
  { name := "_start", entry := 0x20328#64, blocks := [
    (0x20328#64, { ops := [.const 0 0x20000#64, .set 9 0], term := .jump 0x2032c#64 }),
    (0x2032c#64, { ops := [.get 0 9, .const 2 0xce0#64, .bin 3 .add 0 2, .set 9 3], term := .jump 0x20330#64 }),
    (0x20330#64, { ops := [.get 0 9, .const 2 0x0#64, .bin 3 .add 0 2, .set 31 3], term := .jump 0x20334#64 }),
    (0x20334#64, { ops := [], term := .jump 0x20338#64 })] }

/-- `_start` is the lowering of `_start_words`. -/
theorem _start_lowered :
    _start.blocks = Lowering.Arm.lowerWordsEnv 0x20328#64 _start_words := by
  decide

/-- The instruction words of `main`, from `0x20338`. -/
def main_words : List (BitVec 32) := [
  0xd10343ff#32, 0xa9087bfd#32, 0x90000008#32, 0xd29e6e4a#32, 0xa90967fa#32, 0xf2a78dca#32, 0x910203fd#32, 0xa90a5ff8#32, 0xf2dea74a#32, 0xd29b356b#32, 0xa90b57f6#32, 0xf2f4a9ea#32, 0xf2a3f06b#32, 0xa90c4ff4#32, 0xf2d9a32b#32, 0xf9426908#32, 0xf2eb7c0b#32, 0xf9400113#32, 0xd29ccce8#32, 0xf2ad4128#32, 0xf2d5d0a8#32, 0x91002269#32, 0xf2f76ce8#32, 0xa93e2ba8#32, 0xd28a4fea#32, 0x927ae528#32, 0xf2aa21ca#32, 0xb1010114#32, 0xf2cd118a#32, 0xf2f360aa#32, 0xa93f2faa#32, 0x54000660#32, 0xd37df129#32, 0x90000017#32, 0xd37df276#32, 0xf9426ef7#32, 0xaa1f03f5#32, 0xb27d0918#32, 0xb27d1539#32, 0x910083fa#32, 0x14000008#32, 0xd10083a0#32, 0x910083e1#32, 0x97ffbf36#32, 0x910102b5#32, 0xd1080339#32, 0xeb1402bf#32, 0x54000462#32, 0xaa1f03e8#32, 0xaa1503e9#32, 0xaa1903ea#32, 0x14000007#32, 0xb8287b4b#32, 0x91000508#32, 0xd100814a#32, 0xf100411f#32, 0x91001129#32, 0x54fffe00#32, 0x2a1f03eb#32, 0x928003ec#32, 0xaa0903ed#32, 0xaa0a03ee#32, 0x14000007#32, 0x386d6aef#32, 0x2a0b21eb#32, 0x9100218c#32, 0xd10021ce#32, 0x910005ad#32, 0xb4fffe0c#32, 0xeb1301bf#32, 0x54ffff23#32, 0xeb0d027f#32, 0x54000061#32, 0x5280100f#32, 0x17fffff6#32, 0xeb1801bf#32, 0x54000062#32, 0x2a1f03ef#32, 0x17fffff2#32, 0x9ace26cf#32, 0x12001def#32, 0x17ffffef#32, 0x910003e9#32, 0xaa1f03e8#32, 0xd10083aa#32, 0x91000529#32, 0xb868794b#32, 0x91000508#32, 0xf100211f#32, 0x5ac0096b#32, 0xb81ff12b#32, 0x91001129#32, 0x54ffff41#32, 0x52800020#32, 0x910003e1#32, 0x52800402#32, 0x52800808#32, 0xd4000001#32, 0xaa1f03e0#32, 0x52800ba8#32, 0xd4000001#32]

/-- `main`, lowered to `braid`. -/
def main : Braid.Func :=
  { name := "main", entry := 0x20338#64, blocks := [
    (0x20338#64, { ops := [.get 0 31, .const 2 0xd0#64, .bin 3 .sub 0 2, .set 31 3], term := .jump 0x2033c#64 }),
    (0x2033c#64, { ops := [.get 0 29, .get 1 30, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x80#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x20340#64 }),
    (0x20340#64, { ops := [.const 0 0x20000#64, .set 8 0], term := .jump 0x20344#64 }),
    (0x20344#64, { ops := [.const 0 0xf372#64, .set 10 0], term := .jump 0x20348#64 }),
    (0x20348#64, { ops := [.get 0 26, .get 1 25, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x90#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x2034c#64 }),
    (0x2034c#64, { ops := [.get 0 10, .const 2 0xffffffff0000ffff#64, .bin 3 .and 0 2, .const 4 0x3c6e0000#64, .bin 5 .or 3 4, .set 10 5], term := .jump 0x20350#64 }),
    (0x20350#64, { ops := [.get 0 31, .const 2 0x80#64, .bin 3 .add 0 2, .set 29 3], term := .jump 0x20354#64 }),
    (0x20354#64, { ops := [.get 0 24, .get 1 23, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0xa0#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x20358#64 }),
    (0x20358#64, { ops := [.get 0 10, .const 2 0xffff0000ffffffff#64, .bin 3 .and 0 2, .const 4 0xf53a00000000#64, .bin 5 .or 3 4, .set 10 5], term := .jump 0x2035c#64 }),
    (0x2035c#64, { ops := [.const 0 0xd9ab#64, .set 11 0], term := .jump 0x20360#64 }),
    (0x20360#64, { ops := [.get 0 22, .get 1 21, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0xb0#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x20364#64 }),
    (0x20364#64, { ops := [.get 0 10, .const 2 0xffffffffffff#64, .bin 3 .and 0 2, .const 4 0xa54f000000000000#64, .bin 5 .or 3 4, .set 10 5], term := .jump 0x20368#64 }),
    (0x20368#64, { ops := [.get 0 11, .const 2 0xffffffff0000ffff#64, .bin 3 .and 0 2, .const 4 0x1f830000#64, .bin 5 .or 3 4, .set 11 5], term := .jump 0x2036c#64 }),
    (0x2036c#64, { ops := [.get 0 20, .get 1 19, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0xc0#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x20370#64 }),
    (0x20370#64, { ops := [.get 0 11, .const 2 0xffff0000ffffffff#64, .bin 3 .and 0 2, .const 4 0xcd1900000000#64, .bin 5 .or 3 4, .set 11 5], term := .jump 0x20374#64 }),
    (0x20374#64, { ops := [.get 1 8, .const 6 0x4d0#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 8 30], term := .jump 0x20378#64 }),
    (0x20378#64, { ops := [.get 0 11, .const 2 0xffffffffffff#64, .bin 3 .and 0 2, .const 4 0x5be0000000000000#64, .bin 5 .or 3 4, .set 11 5], term := .jump 0x2037c#64 }),
    (0x2037c#64, { ops := [.get 0 8, .load 30 .w64 0, .set 19 30], term := .jump 0x20380#64 }),
    (0x20380#64, { ops := [.const 0 0xe667#64, .set 8 0], term := .jump 0x20384#64 }),
    (0x20384#64, { ops := [.get 0 8, .const 2 0xffffffff0000ffff#64, .bin 3 .and 0 2, .const 4 0x6a090000#64, .bin 5 .or 3 4, .set 8 5], term := .jump 0x20388#64 }),
    (0x20388#64, { ops := [.get 0 8, .const 2 0xffff0000ffffffff#64, .bin 3 .and 0 2, .const 4 0xae8500000000#64, .bin 5 .or 3 4, .set 8 5], term := .jump 0x2038c#64 }),
    (0x2038c#64, { ops := [.get 0 19, .const 2 0x8#64, .bin 3 .add 0 2, .set 9 3], term := .jump 0x20390#64 }),
    (0x20390#64, { ops := [.get 0 8, .const 2 0xffffffffffff#64, .bin 3 .and 0 2, .const 4 0xbb67000000000000#64, .bin 5 .or 3 4, .set 8 5], term := .jump 0x20394#64 }),
    (0x20394#64, { ops := [.get 0 8, .get 1 10, .get 3 29, .const 8 0xffffffffffffffe0#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x20398#64 }),
    (0x20398#64, { ops := [.const 0 0x527f#64, .set 10 0], term := .jump 0x2039c#64 }),
    (0x2039c#64, { ops := [.get 0 9, .const 2 0xffffffffffffffc0#64, .bin 3 .and 0 2, .set 8 3], term := .jump 0x203a0#64 }),
    (0x203a0#64, { ops := [.get 0 10, .const 2 0xffffffff0000ffff#64, .bin 3 .and 0 2, .const 4 0x510e0000#64, .bin 5 .or 3 4, .set 10 5], term := .jump 0x203a4#64 }),
    (0x203a4#64, { ops := [.get 0 8, .const 2 0x40#64, .bin 3 .add 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 3 8, .bin 6 .ult 3 0, .bin 9 .xor 0 3, .bin 10 .xor 2 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 20 3], term := .jump 0x203a8#64 }),
    (0x203a8#64, { ops := [.get 0 10, .const 2 0xffff0000ffffffff#64, .bin 3 .and 0 2, .const 4 0x688c00000000#64, .bin 5 .or 3 4, .set 10 5], term := .jump 0x203ac#64 }),
    (0x203ac#64, { ops := [.get 0 10, .const 2 0xffffffffffff#64, .bin 3 .and 0 2, .const 4 0x9b05000000000000#64, .bin 5 .or 3 4, .set 10 5], term := .jump 0x203b0#64 }),
    (0x203b0#64, { ops := [.get 0 10, .get 1 11, .get 3 29, .const 8 0xfffffffffffffff0#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x203b4#64 }),
    (0x203b4#64, { ops := [.getf 0 1], term := .branch 0 0x20480#64 0x203b8#64 }),
    (0x203b8#64, { ops := [.get 0 9, .const 3 0x3#64, .bin 20 .shl 0 3, .set 9 20], term := .jump 0x203bc#64 }),
    (0x203bc#64, { ops := [.const 0 0x20000#64, .set 23 0], term := .jump 0x203c0#64 }),
    (0x203c0#64, { ops := [.get 0 19, .const 3 0x3#64, .bin 20 .shl 0 3, .set 22 20], term := .jump 0x203c4#64 }),
    (0x203c4#64, { ops := [.get 1 23, .const 6 0x4d8#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 23 30], term := .jump 0x203c8#64 }),
    (0x203c8#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 21 12], term := .jump 0x203cc#64 }),
    (0x203cc#64, { ops := [.get 0 8, .const 2 0x38#64, .bin 3 .or 0 2, .set 24 3], term := .jump 0x203d0#64 }),
    (0x203d0#64, { ops := [.get 0 9, .const 2 0x1f8#64, .bin 3 .or 0 2, .set 25 3], term := .jump 0x203d4#64 }),
    (0x203d4#64, { ops := [.get 0 31, .const 2 0x20#64, .bin 3 .add 0 2, .set 26 3], term := .jump 0x203d8#64 }),
    (0x203d8#64, { ops := [], term := .jump 0x203f8#64 }),
    (0x203dc#64, { ops := [.get 0 29, .const 2 0x20#64, .bin 3 .sub 0 2, .set 0 3], term := .jump 0x203e0#64 }),
    (0x203e0#64, { ops := [.get 0 31, .const 2 0x20#64, .bin 3 .add 0 2, .set 1 3], term := .jump 0x203e4#64 }),
    (0x203e4#64, { ops := [.const 0 0x203e8#64, .set 30 0], term := .jump 0x100bc#64 }),
    (0x203e8#64, { ops := [.get 0 21, .const 2 0x40#64, .bin 3 .add 0 2, .set 21 3], term := .jump 0x203ec#64 }),
    (0x203ec#64, { ops := [.get 0 25, .const 2 0x200#64, .bin 3 .sub 0 2, .set 25 3], term := .jump 0x203f0#64 }),
    (0x203f0#64, { ops := [.get 0 21, .get 2 20, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x203f4#64 }),
    (0x203f4#64, { ops := [.getf 0 2], term := .branch 0 0x20480#64 0x203f8#64 }),
    (0x203f8#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 8 12], term := .jump 0x203fc#64 }),
    (0x203fc#64, { ops := [.const 0 0x0#64, .get 2 21, .bin 12 .or 0 2, .set 9 12], term := .jump 0x20400#64 }),
    (0x20400#64, { ops := [.const 0 0x0#64, .get 2 25, .bin 12 .or 0 2, .set 10 12], term := .jump 0x20404#64 }),
    (0x20404#64, { ops := [], term := .jump 0x20420#64 }),
    (0x20408#64, { ops := [.get 0 11, .get 2 26, .get 8 8, .const 9 0x2#64, .bin 7 .shl 8 9, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x2040c#64 }),
    (0x2040c#64, { ops := [.get 0 8, .const 2 0x1#64, .bin 3 .add 0 2, .set 8 3], term := .jump 0x20410#64 }),
    (0x20410#64, { ops := [.get 0 10, .const 2 0x20#64, .bin 3 .sub 0 2, .set 10 3], term := .jump 0x20414#64 }),
    (0x20414#64, { ops := [.get 0 8, .const 2 0x10#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7], term := .jump 0x20418#64 }),
    (0x20418#64, { ops := [.get 0 9, .const 2 0x4#64, .bin 3 .add 0 2, .set 9 3], term := .jump 0x2041c#64 }),
    (0x2041c#64, { ops := [.getf 0 1], term := .branch 0 0x203dc#64 0x20420#64 }),
    (0x20420#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .const 3 0x0#64, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 11 12], term := .jump 0x20424#64 }),
    (0x20424#64, { ops := [.const 0 0xffffffffffffffe0#64, .set 12 0], term := .jump 0x20428#64 }),
    (0x20428#64, { ops := [.const 0 0x0#64, .get 2 9, .bin 12 .or 0 2, .set 13 12], term := .jump 0x2042c#64 }),
    (0x2042c#64, { ops := [.const 0 0x0#64, .get 2 10, .bin 12 .or 0 2, .set 14 12], term := .jump 0x20430#64 }),
    (0x20430#64, { ops := [], term := .jump 0x2044c#64 }),
    (0x20434#64, { ops := [.get 1 23, .get 6 13, .bin 0 .add 1 6, .load 30 .w8 0, .set 15 30], term := .jump 0x20438#64 }),
    (0x20438#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 3 11, .const 4 0x8#64, .bin 5 .shl 3 4, .un 2 (.zext 32) 5, .bin 12 .or 0 2, .set 11 12], term := .jump 0x2043c#64 }),
    (0x2043c#64, { ops := [.get 0 12, .const 2 0x8#64, .bin 3 .add 0 2, .set 12 3], term := .jump 0x20440#64 }),
    (0x20440#64, { ops := [.get 0 14, .const 2 0x8#64, .bin 3 .sub 0 2, .set 14 3], term := .jump 0x20444#64 }),
    (0x20444#64, { ops := [.get 0 13, .const 2 0x1#64, .bin 3 .add 0 2, .set 13 3], term := .jump 0x20448#64 }),
    (0x20448#64, { ops := [.get 0 12], term := .branch 0 0x2044c#64 0x20408#64 }),
    (0x2044c#64, { ops := [.get 0 13, .get 2 19, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x20450#64 }),
    (0x20450#64, { ops := [.getf 1 2, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x20434#64 0x20454#64 }),
    (0x20454#64, { ops := [.get 0 19, .get 2 13, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x20458#64 }),
    (0x20458#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x20464#64 0x2045c#64 }),
    (0x2045c#64, { ops := [.const 0 0x80#64, .set 15 0], term := .jump 0x20460#64 }),
    (0x20460#64, { ops := [], term := .jump 0x20438#64 }),
    (0x20464#64, { ops := [.get 0 13, .get 2 24, .bin 12 .sub 0 2, .const 17 0x0#64, .bin 13 .slt 12 17, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 18 .xor 0 2, .bin 19 .xor 0 12, .bin 20 .and 18 19, .bin 16 .slt 20 17, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x20468#64 }),
    (0x20468#64, { ops := [.getf 0 2], term := .branch 0 0x20474#64 0x2046c#64 }),
    (0x2046c#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .const 3 0x0#64, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 15 12], term := .jump 0x20470#64 }),
    (0x20470#64, { ops := [], term := .jump 0x20438#64 }),
    (0x20474#64, { ops := [.get 0 22, .get 1 14, .const 2 0x3f#64, .bin 3 .and 1 2, .bin 9 .lshr 0 3, .set 15 9], term := .jump 0x20478#64 }),
    (0x20478#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .const 2 0xff#64, .bin 3 .and 0 2, .set 15 3], term := .jump 0x2047c#64 }),
    (0x2047c#64, { ops := [], term := .jump 0x20438#64 }),
    (0x20480#64, { ops := [.get 0 31, .const 2 0x0#64, .bin 3 .add 0 2, .set 9 3], term := .jump 0x20484#64 }),
    (0x20484#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 8 12], term := .jump 0x20488#64 }),
    (0x20488#64, { ops := [.get 0 29, .const 2 0x20#64, .bin 3 .sub 0 2, .set 10 3], term := .jump 0x2048c#64 }),
    (0x2048c#64, { ops := [.get 0 9, .const 2 0x1#64, .bin 3 .add 0 2, .set 9 3], term := .jump 0x20490#64 }),
    (0x20490#64, { ops := [.get 1 10, .get 7 8, .const 8 0x2#64, .bin 6 .shl 7 8, .bin 0 .add 1 6, .load 30 .w32 0, .set 11 30], term := .jump 0x20494#64 }),
    (0x20494#64, { ops := [.get 0 8, .const 2 0x1#64, .bin 3 .add 0 2, .set 8 3], term := .jump 0x20498#64 }),
    (0x20498#64, { ops := [.get 0 8, .const 2 0x8#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7], term := .jump 0x2049c#64 }),
    (0x2049c#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .un 1 .bswap 0, .const 2 0x20#64, .bin 9 .lshr 1 2, .set 11 9], term := .jump 0x204a0#64 }),
    (0x204a0#64, { ops := [.get 0 11, .get 2 9, .const 7 0xffffffffffffffff#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x204a4#64 }),
    (0x204a4#64, { ops := [.get 0 9, .const 2 0x4#64, .bin 3 .add 0 2, .set 9 3], term := .jump 0x204a8#64 }),
    (0x204a8#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x20490#64 0x204ac#64 }),
    (0x204ac#64, { ops := [.const 0 0x1#64, .set 0 0], term := .jump 0x204b0#64 }),
    (0x204b0#64, { ops := [.get 0 31, .const 2 0x0#64, .bin 3 .add 0 2, .set 1 3], term := .jump 0x204b4#64 }),
    (0x204b4#64, { ops := [.const 0 0x20#64, .set 2 0], term := .jump 0x204b8#64 }),
    (0x204b8#64, { ops := [.const 0 0x40#64, .set 8 0], term := .jump 0x204bc#64 }),
    (0x204bc#64, { ops := [.get 0 8, .const 1 0x5d#64, .bin 2 .eq 0 1, .const 3 0x40#64, .bin 4 .eq 0 3, .bin 5 .or 2 4, .guard 5, .get 6 0, .get 7 1, .get 8 2, .un 9 (.zext 32) 6, .const 10 0x1#64, .bin 11 .eq 9 10, .const 12 0x0#64, .bin 13 .ne 8 12, .const 14 0x7ffff000#64, .bin 15 .ule 8 14, .const 16 0x1000000000000#64, .bin 17 .sub 16 8, .bin 18 .ule 7 17, .bin 19 .and 11 13, .bin 20 .and 19 15, .bin 21 .and 20 18, .bin 22 .or 2 21, .guard 22, .select 23 4 8 12, .out 7 23, .select 24 4 8 6, .set 0 24], term := .exit 2 6 0x204bc#64 0x204c0#64 }),
    (0x204c0#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 0 12], term := .jump 0x204c4#64 }),
    (0x204c4#64, { ops := [.const 0 0x5d#64, .set 8 0], term := .jump 0x204c8#64 }),
    (0x204c8#64, { ops := [.get 0 8, .const 1 0x5d#64, .bin 2 .eq 0 1, .const 3 0x40#64, .bin 4 .eq 0 3, .bin 5 .or 2 4, .guard 5, .get 6 0, .get 7 1, .get 8 2, .un 9 (.zext 32) 6, .const 10 0x1#64, .bin 11 .eq 9 10, .const 12 0x0#64, .bin 13 .ne 8 12, .const 14 0x7ffff000#64, .bin 15 .ule 8 14, .const 16 0x1000000000000#64, .bin 17 .sub 16 8, .bin 18 .ule 7 17, .bin 19 .and 11 13, .bin 20 .and 19 15, .bin 21 .and 20 18, .bin 22 .or 2 21, .guard 22, .select 23 4 8 12, .out 7 23, .select 24 4 8 6, .set 0 24], term := .exit 2 6 0x204c8#64 0x204cc#64 })] }

/-- `main` is the lowering of `main_words`. -/
theorem main_lowered :
    main.blocks = Lowering.Arm.lowerWordsEnv 0x20338#64 main_words := by
  decide

/-- The bytes of the section `.rodata`. -/
def sha256_main_section_rodata : List (BitVec 8) := [
  152, 47, 138, 66, 145, 68, 55, 113, 207, 251, 192, 181, 165, 219, 181, 233, 91, 194, 86, 57, 241, 17, 241, 89, 164, 130, 63, 146, 213, 94, 28, 171, 152, 170, 7, 216, 1, 91, 131, 18, 190, 133, 49, 36, 195, 125, 12, 85, 116, 93, 190, 114, 254, 177, 222, 128, 167, 6, 220, 155, 116, 241, 155, 193, 193, 105, 155, 228, 134, 71, 190, 239, 198, 157, 193, 15, 204, 161, 12, 36, 111, 44, 233, 45, 170, 132, 116, 74, 220, 169, 176, 92, 218, 136, 249, 118, 82, 81, 62, 152, 109, 198, 49, 168, 200, 39, 3, 176, 199, 127, 89, 191, 243, 11, 224, 198, 71, 145, 167, 213, 81, 99, 202, 6, 103, 41, 41, 20, 133, 10, 183, 39, 56, 33, 27, 46, 252, 109, 44, 77, 19, 13, 56, 83, 84, 115, 10, 101, 187, 10, 106, 118, 46, 201, 194, 129, 133, 44, 114, 146, 161, 232, 191, 162, 75, 102, 26, 168, 112, 139, 75, 194, 163, 81, 108, 199, 25, 232, 146, 209, 36, 6, 153, 214, 133, 53, 14, 244, 112, 160, 106, 16, 22, 193, 164, 25, 8, 108, 55, 30, 76, 119, 72, 39, 181, 188, 176, 52, 179, 12, 28, 57, 74, 170, 216, 78, 79, 202, 156, 91, 243, 111, 46, 104, 238, 130, 143, 116, 111, 99, 165, 120, 20, 120, 200, 132, 8, 2, 199, 140, 250, 255, 190, 144, 235, 108, 80, 164, 247, 163, 249, 190, 242, 120, 113, 198]

/-- The bytes of the section `.got`. -/
def sha256_main_section_got : List (BitVec 8) := [
  224, 12, 2, 0, 0, 0, 0, 0, 232, 12, 2, 0, 0, 0, 0, 0]

/-- The bytes of the section `.msglen`. -/
def sha256_main_section_msglen : List (BitVec 8) := [
  3, 0, 0, 0, 0, 0, 0, 0]

/-- The bytes of the section `.msg`. -/
def sha256_main_section_msg : List (BitVec 8) := [
  97, 98, 99]

/-- The binary as it is loaded: its code, its sections and its entry point. -/
def sha256_main_image : Lowering.Arm.Image :=
  { entry := 0x20328#64,
    code := Lowering.Arm.wordsAt 0x100bc#64 sha256_compress_words ++
      Lowering.Arm.wordsAt 0x20328#64 _start_words ++
      Lowering.Arm.wordsAt 0x20338#64 main_words,
    data := [
      (0x20228#64, sha256_main_section_rodata),
      (0x204d0#64, sha256_main_section_got),
      (0x20ce0#64, sha256_main_section_msglen),
      (0x20ce8#64, sha256_main_section_msg)],
    zero := [(0x204e0#64, 2048)] }

/-- The blocks of the whole program. -/
def sha256_main_blocks : List (Braid.Word × Braid.Block) :=
  sha256_compress.blocks ++ _start.blocks ++ main.blocks

/-- The blocks of the program are the lowering of the code of the image. -/
theorem sha256_main_lowered :
    sha256_main_blocks = Lowering.Arm.lowerImage sha256_main_image.code := by
  simp only [sha256_main_blocks, sha256_main_image, Lowering.Arm.lowerImage_append,
    Lowering.Arm.lowerImage_wordsAt, sha256_compress_lowered, _start_lowered, main_lowered]

/-- The sections of the image do not overlap. -/
theorem sha256_main_apart : Lowering.Arm.Image.Apart sha256_main_image := by
  decide +kernel

end Examples.Sha256Main.Arm
