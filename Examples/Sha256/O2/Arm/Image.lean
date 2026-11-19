/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.Sha256.O2.Arm


/-- The instruction words of `sha256_round`, from `0x10000`. -/
def sha256_round_words : List (BitVec 32) := [
  0x29422c08#32, 0x29402809#32, 0x2943340c#32, 0x1388190e#32, 0xb010051#32, 0xa080172#32, 0x2941400f#32, 0x4ac82dce#32, 0xa280181#32, 0xb0d022d#32, 0x13890931#32, 0x2a120032#32, 0x2903300b#32, 0x4ac865ce#32, 0xb1201ab#32, 0x4a0a01e2#32, 0x4ac9362c#32, 0xa0a01e1#32, 0xa09004d#32, 0xb0e016b#32, 0x29013c0a#32, 0x4ac9598c#32, 0xb10016e#32, 0x2902200e#32, 0x4a0101a8#32, 0xb0c0108#32, 0xb0b0108#32, 0x29002408#32, 0xd65f03c0#32]

/-- `sha256_round`, lowered to `braid`. -/
def sha256_round : Braid.Func :=
  { name := "sha256_round", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 1 0, .const 6 0x10#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 8 23, .set 11 26], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.get 0 0, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 9 23, .set 10 26], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 1 0, .const 6 0x18#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 12 23, .set 13 26], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.get 0 8, .get 1 8, .un 2 (.zext 32) 1, .const 3 0x6#64, .bin 4 .lshr 2 3, .const 5 0x1a#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 14 9], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 3 1, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 17 12], term := .jump 0x10014#64 }),
    (0x10014#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 3 8, .un 2 (.zext 32) 3, .bin 12 .and 0 2, .set 18 12], term := .jump 0x10018#64 }),
    (0x10018#64, { ops := [.get 1 0, .const 6 0x8#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 15 23, .set 16 26], term := .jump 0x1001c#64 }),
    (0x1001c#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 8, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0xb#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 14 12], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 3 8, .un 2 (.zext 32) 3, .un 13 .not 2, .bin 12 .and 0 13, .set 1 12], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 1 17, .un 0 (.zext 32) 1, .get 3 13, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 13 12], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 9, .get 1 9, .un 2 (.zext 32) 1, .const 3 0x2#64, .bin 4 .lshr 2 3, .const 5 0x1e#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 17 9], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 1 1, .un 0 (.zext 32) 1, .get 3 18, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 18 12], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.get 0 11, .get 1 12, .get 3 0, .const 8 0x18#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x10034#64 }),
    (0x10034#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 8, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0x19#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 14 12], term := .jump 0x10038#64 }),
    (0x10038#64, { ops := [.get 1 13, .un 0 (.zext 32) 1, .get 3 18, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 11 12], term := .jump 0x1003c#64 }),
    (0x1003c#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 3 10, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 2 12], term := .jump 0x10040#64 }),
    (0x10040#64, { ops := [.get 1 17, .un 0 (.zext 32) 1, .get 3 9, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0xd#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 12 12], term := .jump 0x10044#64 }),
    (0x10044#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 3 10, .un 2 (.zext 32) 3, .bin 12 .and 0 2, .set 1 12], term := .jump 0x10048#64 }),
    (0x10048#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 3 9, .un 2 (.zext 32) 3, .bin 12 .and 0 2, .set 13 12], term := .jump 0x1004c#64 }),
    (0x1004c#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 3 14, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 11 12], term := .jump 0x10050#64 }),
    (0x10050#64, { ops := [.get 0 10, .get 1 15, .get 3 0, .const 8 0x8#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x10054#64 }),
    (0x10054#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 3 9, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0x16#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 12 12], term := .jump 0x10058#64 }),
    (0x10058#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 3 16, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 14 12], term := .jump 0x1005c#64 }),
    (0x1005c#64, { ops := [.get 0 14, .get 1 8, .get 3 0, .const 8 0x10#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x10060#64 }),
    (0x10060#64, { ops := [.get 1 13, .un 0 (.zext 32) 1, .get 3 1, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 8 12], term := .jump 0x10064#64 }),
    (0x10064#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 12, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10068#64 }),
    (0x10068#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 11, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x1006c#64 }),
    (0x1006c#64, { ops := [.get 0 8, .get 1 9, .get 2 0, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x10070#64 }),
    (0x10070#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `sha256_round` is the lowering of `sha256_round_words`. -/
theorem sha256_round_lowered :
    sha256_round.blocks = Lowering.Arm.lowerWords 0x10000#64 sha256_round_words := by
  decide

/-- The instruction words of `sha256_schedule`, from `0x10074`. -/
def sha256_schedule_words : List (BitVec 32) := [
  0x52800608#32, 0x91010009#32, 0xb85f812a#32, 0xb85e412f#32, 0xf1000508#32, 0x29782d2d#32, 0x138a454c#32, 0x138b1d6e#32, 0x4aca4d8c#32, 0x4acb49ce#32, 0x4a4a298a#32, 0xb0d01ec#32, 0x4a4b0dcb#32, 0xb0c014a#32, 0xb0b014a#32, 0xb800452a#32, 0x54fffe41#32, 0xd65f03c0#32]

/-- `sha256_schedule`, lowered to `braid`. -/
def sha256_schedule : Braid.Func :=
  { name := "sha256_schedule", entry := 0x10074#64, blocks := [
    (0x10074#64, { ops := [.const 0 0x30#64, .set 8 0], term := .jump 0x10078#64 }),
    (0x10078#64, { ops := [.get 0 0, .const 2 0x40#64, .bin 3 .add 0 2, .set 9 3], term := .jump 0x1007c#64 }),
    (0x1007c#64, { ops := [.get 1 9, .const 6 0xfffffffffffffff8#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 10 30], term := .jump 0x10080#64 }),
    (0x10080#64, { ops := [.get 1 9, .const 6 0xffffffffffffffe4#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 15 30], term := .jump 0x10084#64 }),
    (0x10084#64, { ops := [.get 0 8, .const 2 0x1#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 8 3], term := .jump 0x10088#64 }),
    (0x10088#64, { ops := [.get 1 9, .const 6 0xffffffffffffffc0#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 13 23, .set 11 26], term := .jump 0x1008c#64 }),
    (0x1008c#64, { ops := [.get 0 10, .get 1 10, .un 2 (.zext 32) 1, .const 3 0x11#64, .bin 4 .lshr 2 3, .const 5 0xf#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 12 9], term := .jump 0x10090#64 }),
    (0x10090#64, { ops := [.get 0 11, .get 1 11, .un 2 (.zext 32) 1, .const 3 0x7#64, .bin 4 .lshr 2 3, .const 5 0x19#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 14 9], term := .jump 0x10094#64 }),
    (0x10094#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 3 10, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0x13#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 12 12], term := .jump 0x10098#64 }),
    (0x10098#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 11, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0x12#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 14 12], term := .jump 0x1009c#64 }),
    (0x1009c#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 3 10, .un 5 (.zext 32) 3, .const 6 0xa#64, .bin 2 .lshr 5 6, .bin 12 .xor 0 2, .set 10 12], term := .jump 0x100a0#64 }),
    (0x100a0#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 3 13, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 12 12], term := .jump 0x100a4#64 }),
    (0x100a4#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 11, .un 5 (.zext 32) 3, .const 6 0x3#64, .bin 2 .lshr 5 6, .bin 12 .xor 0 2, .set 11 12], term := .jump 0x100a8#64 }),
    (0x100a8#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 12, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 10 12], term := .jump 0x100ac#64 }),
    (0x100ac#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 11, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 10 12], term := .jump 0x100b0#64 }),
    (0x100b0#64, { ops := [.get 0 10, .get 1 9, .const 6 0x4#64, .bin 7 .add 1 6, .set 9 7, .store .w32 1 0], term := .jump 0x100b4#64 }),
    (0x100b4#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x1007c#64 0x100b8#64 }),
    (0x100b8#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `sha256_schedule` is the lowering of `sha256_schedule_words`. -/
theorem sha256_schedule_lowered :
    sha256_schedule.blocks = Lowering.Arm.lowerWords 0x10074#64 sha256_schedule_words := by
  decide

/-- The instruction words of `sha256_compress`, from `0x100bc`. -/
def sha256_compress_words : List (BitVec 32) := [
  0xd10503ff#32, 0xf9400029#32, 0xb940082a#32, 0x910003e8#32, 0xf840c02b#32, 0x91010108#32, 0xf90083fd#32, 0xf90003e9#32, 0xb9401429#32, 0xb9000bea#32, 0xb90017e9#32, 0xa941a42a#32, 0xf800c3eb#32, 0xa9115ff8#32, 0xa901a7ea#32, 0x2945242b#32, 0xa91257f6#32, 0xa9134ff4#32, 0x290527eb#32, 0x2946242a#32, 0x290627ea#32, 0x2947242b#32, 0x290727eb#32, 0x52800609#32, 0xb85f810a#32, 0xb85e410f#32, 0xf1000529#32, 0x29782d0d#32, 0x138a454c#32, 0x138b1d6e#32, 0x4aca4d8c#32, 0x4acb49ce#32, 0x4a4a298a#32, 0xb0d01ec#32, 0x4a4b0dcb#32, 0xb0c014a#32, 0xb0b014a#32, 0xb800450a#32, 0x54fffe41#32, 0x29402c0a#32, 0x29412009#32, 0x29423c10#32, 0x2943340e#32, 0xaa1f03ec#32, 0xd503201f#32, 0x100807a2#32, 0x910003e5#32, 0x2a0a03f3#32, 0x2a0b03e6#32, 0x2a0903e3#32, 0x2a0803e4#32, 0x2a1003e7#32, 0x2a0f03e1#32, 0x2a0e03f1#32, 0x2a0d03f2#32, 0xb86c6854#32, 0xb86c68b5#32, 0x2a0403f7#32, 0x2a0303e4#32, 0x2a0603e3#32, 0x2a1303e6#32, 0x2a1203f6#32, 0x2a1103f2#32, 0x2a0103f1#32, 0x2a0703e1#32, 0x138718e7#32, 0xb1402b3#32, 0x138608d4#32, 0xb160273#32, 0xa010235#32, 0x4ac12ce7#32, 0xa210256#32, 0xa030098#32, 0x4ac63694#32, 0x2a1502d5#32, 0x4a030096#32, 0x4ac164e7#32, 0xa0602d6#32, 0xb150273#32, 0x4ac65a94#32, 0x4a1802d5#32, 0x9100118c#32, 0xb070273#32, 0xf104019f#32, 0xb1402b4#32, 0xb170267#32, 0xb130293#32, 0x54fffc01#32, 0xb030129#32, 0xb040108#32, 0xb13014a#32, 0x29012009#32, 0xb070208#32, 0xb0101e9#32, 0xa9534ff4#32, 0xb06016b#32, 0xa95257f6#32, 0x29022408#32, 0xa9515ff8#32, 0xb1101c8#32, 0xb1201a9#32, 0xf94083fd#32, 0x29002c0a#32, 0x29032408#32, 0x910503ff#32, 0xd65f03c0#32]

/-- `sha256_compress`, lowered to `braid`. -/
def sha256_compress : Braid.Func :=
  { name := "sha256_compress", entry := 0x100bc#64, blocks := [
    (0x100bc#64, { ops := [.get 0 31, .const 2 0x140#64, .bin 3 .sub 0 2, .set 31 3], term := .jump 0x100c0#64 }),
    (0x100c0#64, { ops := [.get 0 1, .load 30 .w64 0, .set 9 30], term := .jump 0x100c4#64 }),
    (0x100c4#64, { ops := [.get 1 1, .const 6 0x8#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 10 30], term := .jump 0x100c8#64 }),
    (0x100c8#64, { ops := [.get 0 31, .const 2 0x0#64, .bin 3 .add 0 2, .set 8 3], term := .jump 0x100cc#64 }),
    (0x100cc#64, { ops := [.get 1 1, .const 6 0xc#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 11 30], term := .jump 0x100d0#64 }),
    (0x100d0#64, { ops := [.get 0 8, .const 2 0x40#64, .bin 3 .add 0 2, .set 8 3], term := .jump 0x100d4#64 }),
    (0x100d4#64, { ops := [.get 0 29, .get 2 31, .const 3 0xf#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .const 7 0x100#64, .bin 1 .add 2 7, .store .w64 1 0], term := .jump 0x100d8#64 }),
    (0x100d8#64, { ops := [.get 0 9, .get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .store .w64 1 0], term := .jump 0x100dc#64 }),
    (0x100dc#64, { ops := [.get 1 1, .const 6 0x14#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 9 30], term := .jump 0x100e0#64 }),
    (0x100e0#64, { ops := [.get 0 10, .get 2 31, .const 3 0xf#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .const 7 0x8#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x100e4#64 }),
    (0x100e4#64, { ops := [.get 0 9, .get 2 31, .const 3 0xf#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .const 7 0x14#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x100e8#64 }),
    (0x100e8#64, { ops := [.get 1 1, .const 6 0x18#64, .bin 0 .add 1 6, .const 21 0x8#64, .bin 22 .add 0 21, .load 23 .w64 0, .load 26 .w64 22, .set 10 23, .set 9 26], term := .jump 0x100ec#64 }),
    (0x100ec#64, { ops := [.get 0 11, .get 2 31, .const 3 0xf#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .const 7 0xc#64, .bin 1 .add 2 7, .store .w64 1 0], term := .jump 0x100f0#64 }),
    (0x100f0#64, { ops := [.get 0 24, .get 1 23, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x110#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x100f4#64 }),
    (0x100f4#64, { ops := [.get 0 10, .get 1 9, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x18#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x100f8#64 }),
    (0x100f8#64, { ops := [.get 1 1, .const 6 0x28#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 11 23, .set 9 26], term := .jump 0x100fc#64 }),
    (0x100fc#64, { ops := [.get 0 22, .get 1 21, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x120#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x10100#64 }),
    (0x10100#64, { ops := [.get 0 20, .get 1 19, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x130#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x10104#64 }),
    (0x10104#64, { ops := [.get 0 11, .get 1 9, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x28#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x10108#64 }),
    (0x10108#64, { ops := [.get 1 1, .const 6 0x30#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 10 23, .set 9 26], term := .jump 0x1010c#64 }),
    (0x1010c#64, { ops := [.get 0 10, .get 1 9, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x30#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x10110#64 }),
    (0x10110#64, { ops := [.get 1 1, .const 6 0x38#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 11 23, .set 9 26], term := .jump 0x10114#64 }),
    (0x10114#64, { ops := [.get 0 11, .get 1 9, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x38#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x10118#64 }),
    (0x10118#64, { ops := [.const 0 0x30#64, .set 9 0], term := .jump 0x1011c#64 }),
    (0x1011c#64, { ops := [.get 1 8, .const 6 0xfffffffffffffff8#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 10 30], term := .jump 0x10120#64 }),
    (0x10120#64, { ops := [.get 1 8, .const 6 0xffffffffffffffe4#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 15 30], term := .jump 0x10124#64 }),
    (0x10124#64, { ops := [.get 0 9, .const 2 0x1#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 9 3], term := .jump 0x10128#64 }),
    (0x10128#64, { ops := [.get 1 8, .const 6 0xffffffffffffffc0#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 13 23, .set 11 26], term := .jump 0x1012c#64 }),
    (0x1012c#64, { ops := [.get 0 10, .get 1 10, .un 2 (.zext 32) 1, .const 3 0x11#64, .bin 4 .lshr 2 3, .const 5 0xf#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 12 9], term := .jump 0x10130#64 }),
    (0x10130#64, { ops := [.get 0 11, .get 1 11, .un 2 (.zext 32) 1, .const 3 0x7#64, .bin 4 .lshr 2 3, .const 5 0x19#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 14 9], term := .jump 0x10134#64 }),
    (0x10134#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 3 10, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0x13#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 12 12], term := .jump 0x10138#64 }),
    (0x10138#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 11, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0x12#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 14 12], term := .jump 0x1013c#64 }),
    (0x1013c#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 3 10, .un 5 (.zext 32) 3, .const 6 0xa#64, .bin 2 .lshr 5 6, .bin 12 .xor 0 2, .set 10 12], term := .jump 0x10140#64 }),
    (0x10140#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 3 13, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 12 12], term := .jump 0x10144#64 }),
    (0x10144#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 11, .un 5 (.zext 32) 3, .const 6 0x3#64, .bin 2 .lshr 5 6, .bin 12 .xor 0 2, .set 11 12], term := .jump 0x10148#64 }),
    (0x10148#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 12, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 10 12], term := .jump 0x1014c#64 }),
    (0x1014c#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 11, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 10 12], term := .jump 0x10150#64 }),
    (0x10150#64, { ops := [.get 0 10, .get 1 8, .const 6 0x4#64, .bin 7 .add 1 6, .set 8 7, .store .w32 1 0], term := .jump 0x10154#64 }),
    (0x10154#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x1011c#64 0x10158#64 }),
    (0x10158#64, { ops := [.get 0 0, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 10 23, .set 11 26], term := .jump 0x1015c#64 }),
    (0x1015c#64, { ops := [.get 1 0, .const 6 0x8#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 9 23, .set 8 26], term := .jump 0x10160#64 }),
    (0x10160#64, { ops := [.get 1 0, .const 6 0x10#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 16 23, .set 15 26], term := .jump 0x10164#64 }),
    (0x10164#64, { ops := [.get 1 0, .const 6 0x18#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 14 23, .set 13 26], term := .jump 0x10168#64 }),
    (0x10168#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 12 12], term := .jump 0x1016c#64 }),
    (0x1016c#64, { ops := [], term := .jump 0x10170#64 }),
    (0x10170#64, { ops := [.const 0 0x20264#64, .set 2 0], term := .jump 0x10174#64 }),
    (0x10174#64, { ops := [.get 0 31, .const 2 0x0#64, .bin 3 .add 0 2, .set 5 3], term := .jump 0x10178#64 }),
    (0x10178#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 10, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 19 12], term := .jump 0x1017c#64 }),
    (0x1017c#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 11, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 6 12], term := .jump 0x10180#64 }),
    (0x10180#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 9, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 3 12], term := .jump 0x10184#64 }),
    (0x10184#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 8, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 4 12], term := .jump 0x10188#64 }),
    (0x10188#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 16, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 7 12], term := .jump 0x1018c#64 }),
    (0x1018c#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 15, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 1 12], term := .jump 0x10190#64 }),
    (0x10190#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 14, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 17 12], term := .jump 0x10194#64 }),
    (0x10194#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 13, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 18 12], term := .jump 0x10198#64 }),
    (0x10198#64, { ops := [.get 1 2, .get 6 12, .bin 0 .add 1 6, .load 30 .w32 0, .set 20 30], term := .jump 0x1019c#64 }),
    (0x1019c#64, { ops := [.get 1 5, .get 6 12, .bin 0 .add 1 6, .load 30 .w32 0, .set 21 30], term := .jump 0x101a0#64 }),
    (0x101a0#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 4, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 23 12], term := .jump 0x101a4#64 }),
    (0x101a4#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 3, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 4 12], term := .jump 0x101a8#64 }),
    (0x101a8#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 6, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 3 12], term := .jump 0x101ac#64 }),
    (0x101ac#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 19, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 6 12], term := .jump 0x101b0#64 }),
    (0x101b0#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 18, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 22 12], term := .jump 0x101b4#64 }),
    (0x101b4#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 17, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 18 12], term := .jump 0x101b8#64 }),
    (0x101b8#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 1, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 17 12], term := .jump 0x101bc#64 }),
    (0x101bc#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .get 3 7, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 1 12], term := .jump 0x101c0#64 }),
    (0x101c0#64, { ops := [.get 0 7, .get 1 7, .un 2 (.zext 32) 1, .const 3 0x6#64, .bin 4 .lshr 2 3, .const 5 0x1a#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 7 9], term := .jump 0x101c4#64 }),
    (0x101c4#64, { ops := [.get 1 21, .un 0 (.zext 32) 1, .get 3 20, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 19 12], term := .jump 0x101c8#64 }),
    (0x101c8#64, { ops := [.get 0 6, .get 1 6, .un 2 (.zext 32) 1, .const 3 0x2#64, .bin 4 .lshr 2 3, .const 5 0x1e#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 20 9], term := .jump 0x101cc#64 }),
    (0x101cc#64, { ops := [.get 1 19, .un 0 (.zext 32) 1, .get 3 22, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 19 12], term := .jump 0x101d0#64 }),
    (0x101d0#64, { ops := [.get 1 17, .un 0 (.zext 32) 1, .get 3 1, .un 2 (.zext 32) 3, .bin 12 .and 0 2, .set 21 12], term := .jump 0x101d4#64 }),
    (0x101d4#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .get 3 1, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0xb#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 7 12], term := .jump 0x101d8#64 }),
    (0x101d8#64, { ops := [.get 1 18, .un 0 (.zext 32) 1, .get 3 1, .un 2 (.zext 32) 3, .un 13 .not 2, .bin 12 .and 0 13, .set 22 12], term := .jump 0x101dc#64 }),
    (0x101dc#64, { ops := [.get 1 4, .un 0 (.zext 32) 1, .get 3 3, .un 2 (.zext 32) 3, .bin 12 .and 0 2, .set 24 12], term := .jump 0x101e0#64 }),
    (0x101e0#64, { ops := [.get 1 20, .un 0 (.zext 32) 1, .get 3 6, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0xd#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 20 12], term := .jump 0x101e4#64 }),
    (0x101e4#64, { ops := [.get 1 22, .un 0 (.zext 32) 1, .get 3 21, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 21 12], term := .jump 0x101e8#64 }),
    (0x101e8#64, { ops := [.get 1 4, .un 0 (.zext 32) 1, .get 3 3, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 22 12], term := .jump 0x101ec#64 }),
    (0x101ec#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .get 3 1, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0x19#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 7 12], term := .jump 0x101f0#64 }),
    (0x101f0#64, { ops := [.get 1 22, .un 0 (.zext 32) 1, .get 3 6, .un 2 (.zext 32) 3, .bin 12 .and 0 2, .set 22 12], term := .jump 0x101f4#64 }),
    (0x101f4#64, { ops := [.get 1 19, .un 0 (.zext 32) 1, .get 3 21, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 19 12], term := .jump 0x101f8#64 }),
    (0x101f8#64, { ops := [.get 1 20, .un 0 (.zext 32) 1, .get 3 6, .un 5 (.zext 32) 3, .const 6 0x100000001#64, .bin 7 .mul 5 6, .const 8 0x16#64, .bin 9 .lshr 7 8, .un 2 (.zext 32) 9, .bin 12 .xor 0 2, .set 20 12], term := .jump 0x101fc#64 }),
    (0x101fc#64, { ops := [.get 1 22, .un 0 (.zext 32) 1, .get 3 24, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 21 12], term := .jump 0x10200#64 }),
    (0x10200#64, { ops := [.get 0 12, .const 2 0x4#64, .bin 3 .add 0 2, .set 12 3], term := .jump 0x10204#64 }),
    (0x10204#64, { ops := [.get 1 19, .un 0 (.zext 32) 1, .get 3 7, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 19 12], term := .jump 0x10208#64 }),
    (0x10208#64, { ops := [.get 0 12, .const 2 0x100#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7], term := .jump 0x1020c#64 }),
    (0x1020c#64, { ops := [.get 1 21, .un 0 (.zext 32) 1, .get 3 20, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 20 12], term := .jump 0x10210#64 }),
    (0x10210#64, { ops := [.get 1 19, .un 0 (.zext 32) 1, .get 3 23, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 7 12], term := .jump 0x10214#64 }),
    (0x10214#64, { ops := [.get 1 20, .un 0 (.zext 32) 1, .get 3 19, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 19 12], term := .jump 0x10218#64 }),
    (0x10218#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10198#64 0x1021c#64 }),
    (0x1021c#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 3 3, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 9 12], term := .jump 0x10220#64 }),
    (0x10220#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 4, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10224#64 }),
    (0x10224#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 19, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 10 12], term := .jump 0x10228#64 }),
    (0x10228#64, { ops := [.get 0 9, .get 1 8, .get 3 0, .const 8 0x8#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x1022c#64 }),
    (0x1022c#64, { ops := [.get 1 16, .un 0 (.zext 32) 1, .get 3 7, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10230#64 }),
    (0x10230#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 3 1, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 9 12], term := .jump 0x10234#64 }),
    (0x10234#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x130#64, .bin 0 .add 1 6, .const 21 0x8#64, .bin 22 .add 0 21, .load 23 .w64 0, .load 26 .w64 22, .set 20 23, .set 19 26], term := .jump 0x10238#64 }),
    (0x10238#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 3 6, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 11 12], term := .jump 0x1023c#64 }),
    (0x1023c#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x120#64, .bin 0 .add 1 6, .const 21 0x8#64, .bin 22 .add 0 21, .load 23 .w64 0, .load 26 .w64 22, .set 22 23, .set 21 26], term := .jump 0x10240#64 }),
    (0x10240#64, { ops := [.get 0 8, .get 1 9, .get 3 0, .const 8 0x10#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x10244#64 }),
    (0x10244#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x110#64, .bin 0 .add 1 6, .const 21 0x8#64, .bin 22 .add 0 21, .load 23 .w64 0, .load 26 .w64 22, .set 24 23, .set 23 26], term := .jump 0x10248#64 }),
    (0x10248#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 17, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x1024c#64 }),
    (0x1024c#64, { ops := [.get 1 13, .un 0 (.zext 32) 1, .get 3 18, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 9 12], term := .jump 0x10250#64 }),
    (0x10250#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x100#64, .bin 0 .add 1 6, .load 30 .w64 0, .set 29 30], term := .jump 0x10254#64 }),
    (0x10254#64, { ops := [.get 0 10, .get 1 11, .get 2 0, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x10258#64 }),
    (0x10258#64, { ops := [.get 0 8, .get 1 9, .get 3 0, .const 8 0x18#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x1025c#64 }),
    (0x1025c#64, { ops := [.get 0 31, .const 2 0x140#64, .bin 3 .add 0 2, .set 31 3], term := .jump 0x10260#64 }),
    (0x10260#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `sha256_compress` is the lowering of `sha256_compress_words`. -/
theorem sha256_compress_lowered :
    sha256_compress.blocks = Lowering.Arm.lowerWords 0x100bc#64 sha256_compress_words := by
  decide

end Examples.Sha256.O2.Arm
