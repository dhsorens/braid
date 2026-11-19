/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.ChaCha20.O2.Arm


/-- The instruction words of `quarter_round`, from `0x10000`. -/
def quarter_round_words : List (BitVec 32) := [
  0x29402408#32, 0x2941280b#32, 0xb080128#32, 0x4a08014a#32, 0x138a414a#32, 0xb0b014b#32, 0x4a090169#32, 0x13895129#32, 0xb080128#32, 0x4a0a010a#32, 0x138a614a#32, 0xb0b014b#32, 0x4a090169#32, 0x2901280b#32, 0x13896529#32, 0x29002408#32, 0xd65f03c0#32]

/-- `quarter_round`, lowered to `braid`. -/
def quarter_round : Braid.Func :=
  { name := "quarter_round", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 0 0, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 8 23, .set 9 26], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.get 1 0, .const 6 0x8#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 11 23, .set 10 26], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 3 8, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 8, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 10 12], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.get 0 10, .get 1 10, .un 2 (.zext 32) 1, .const 3 0x10#64, .bin 4 .lshr 2 3, .const 5 0x10#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 10 9], term := .jump 0x10014#64 }),
    (0x10014#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 11, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 11 12], term := .jump 0x10018#64 }),
    (0x10018#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 3 9, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 9 12], term := .jump 0x1001c#64 }),
    (0x1001c#64, { ops := [.get 0 9, .get 1 9, .un 2 (.zext 32) 1, .const 3 0x14#64, .bin 4 .lshr 2 3, .const 5 0xc#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 9 9], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 3 8, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 10, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 10 12], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 10, .get 1 10, .un 2 (.zext 32) 1, .const 3 0x18#64, .bin 4 .lshr 2 3, .const 5 0x8#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 10 9], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 11, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 11 12], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 3 9, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 9 12], term := .jump 0x10034#64 }),
    (0x10034#64, { ops := [.get 0 11, .get 1 10, .get 3 0, .const 8 0x8#64, .bin 2 .add 3 8, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x10038#64 }),
    (0x10038#64, { ops := [.get 0 9, .get 1 9, .un 2 (.zext 32) 1, .const 3 0x19#64, .bin 4 .lshr 2 3, .const 5 0x7#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 9 9], term := .jump 0x1003c#64 }),
    (0x1003c#64, { ops := [.get 0 8, .get 1 9, .get 2 0, .const 23 0x4#64, .bin 24 .add 2 23, .store .w32 2 0, .store .w32 24 1], term := .jump 0x10040#64 }),
    (0x10040#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `quarter_round` is the lowering of `quarter_round_words`. -/
theorem quarter_round_lowered :
    quarter_round.blocks = Lowering.Arm.lowerWords 0x10000#64 quarter_round_words := by
  decide

/-- The instruction words of `chacha20_block`, from `0x10044`. -/
def chacha20_block_words : List (BitVec 32) := [
  0xf81d0ff7#32, 0x29401827#32, 0x29414425#32, 0x29420c24#32, 0x29434022#32, 0x2944482f#32, 0x2945282b#32, 0x2946342e#32, 0x2947242c#32, 0x52800148#32, 0xa90157f6#32, 0xa9024ff4#32, 0xb0300c6#32, 0xb0400e7#32, 0xb0200a5#32, 0xb100231#32, 0x4a0601ad#32, 0x4a0701ce#32, 0x4a05018c#32, 0x4a110129#32, 0x138d41ad#32, 0x138e41ce#32, 0x138c418c#32, 0x13894129#32, 0xb0d0252#32, 0x71000508#32, 0xb0e01f3#32, 0xb0c0174#32, 0x4a03024f#32, 0xb090143#32, 0x4a04026b#32, 0x4a020282#32, 0x4a10006a#32, 0x138b5164#32, 0x138f51f5#32, 0x13825042#32, 0x138a5156#32, 0xb070087#32, 0xb0602a6#32, 0xb050045#32, 0xb1102cb#32, 0x4a0e00ea#32, 0x4a0d00cd#32, 0x4a0c00ac#32, 0x4a090169#32, 0x138a614e#32, 0x138d61b1#32, 0x138c618f#32, 0x13896137#32, 0xb1301ca#32, 0xb120229#32, 0xb1401f0#32, 0xb0302e3#32, 0x4a04014c#32, 0x4a15012d#32, 0x4a020202#32, 0x4a160064#32, 0x138d65b2#32, 0x13826442#32, 0x13846484#32, 0x138c658d#32, 0xb07024c#32, 0xb060046#32, 0xb050085#32, 0xb0d016b#32, 0x4a0c02e7#32, 0x4a0e00ce#32, 0x4a1100b1#32, 0x138740f3#32, 0x4a0f016f#32, 0x138e41ce#32, 0x13914234#32, 0x138f41ef#32, 0xb100270#32, 0xb0e0063#32, 0xb0a0295#32, 0x4a12020a#32, 0x4a020071#32, 0x4a0402b2#32, 0xb0901e2#32, 0x138a5144#32, 0x13915236#32, 0x4a0d0049#32, 0x13925252#32, 0x13895137#32, 0xb0c0087#32, 0xb0602c6#32, 0xb050245#32, 0x4a1300e9#32, 0xb0b02f1#32, 0x4a0e00ca#32, 0x4a1400ab#32, 0x13896129#32, 0x4a0f022c#32, 0x138a614e#32, 0x138b616d#32, 0x138c618c#32, 0xb10012b#32, 0xb0301ca#32, 0xb1501af#32, 0x4a040170#32, 0x4a160144#32, 0x4a1201f3#32, 0xb020192#32, 0x13846482#32, 0x4a170244#32, 0x13906603#32, 0x13936670#32, 0x13846484#32, 0x54fff3e1#32, 0xb9400028#32, 0xa9424ff4#32, 0xa94157f6#32, 0xb070108#32, 0xb9000008#32, 0xb9400428#32, 0xb060108#32, 0xb9000408#32, 0xb9400828#32, 0xb050108#32, 0xb9000808#32, 0xb9400c28#32, 0xb110108#32, 0xb9000c08#32, 0xb9401028#32, 0xb040108#32, 0xb9001008#32, 0xb9401428#32, 0xb030108#32, 0xb9001408#32, 0xb9401828#32, 0xb020108#32, 0xb9001808#32, 0xb9401c28#32, 0xb100108#32, 0xb9001c08#32, 0xb9402028#32, 0xb0f0108#32, 0xb9002008#32, 0xb9402428#32, 0xb120108#32, 0xb9002408#32, 0xb9402828#32, 0xb0b0108#32, 0xb9002808#32, 0xb9402c28#32, 0xb0a0108#32, 0xb9002c08#32, 0xb9403028#32, 0xb0e0108#32, 0xb9003008#32, 0xb9403428#32, 0xb0d0108#32, 0xb9003408#32, 0xb9403828#32, 0xb0c0108#32, 0xb9003808#32, 0xb9403c28#32, 0xb090108#32, 0xb9003c08#32, 0xf84307f7#32, 0xd65f03c0#32]

/-- Part 0 of the blocks of `chacha20_block`. -/
def chacha20_block_blocks_0 : List (Braid.Word × Braid.Block) := [
    (0x10044#64, { ops := [.get 0 23, .get 2 31, .const 3 0xf#64, .bin 4 .and 2 3, .const 5 0x0#64, .bin 6 .eq 4 5, .guard 6, .const 7 0xffffffffffffffd0#64, .bin 1 .add 2 7, .set 31 1, .store .w64 1 0], term := .jump 0x10048#64 }),
    (0x10048#64, { ops := [.get 0 1, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 7 23, .set 6 26], term := .jump 0x1004c#64 }),
    (0x1004c#64, { ops := [.get 1 1, .const 6 0x8#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 5 23, .set 17 26], term := .jump 0x10050#64 }),
    (0x10050#64, { ops := [.get 1 1, .const 6 0x10#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 4 23, .set 3 26], term := .jump 0x10054#64 }),
    (0x10054#64, { ops := [.get 1 1, .const 6 0x18#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 2 23, .set 16 26], term := .jump 0x10058#64 }),
    (0x10058#64, { ops := [.get 1 1, .const 6 0x20#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 15 23, .set 18 26], term := .jump 0x1005c#64 }),
    (0x1005c#64, { ops := [.get 1 1, .const 6 0x28#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 11 23, .set 10 26], term := .jump 0x10060#64 }),
    (0x10060#64, { ops := [.get 1 1, .const 6 0x30#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 14 23, .set 13 26], term := .jump 0x10064#64 }),
    (0x10064#64, { ops := [.get 1 1, .const 6 0x38#64, .bin 0 .add 1 6, .const 21 0x4#64, .bin 22 .add 0 21, .load 23 .w32 0, .load 26 .w32 22, .set 12 23, .set 9 26], term := .jump 0x10068#64 }),
    (0x10068#64, { ops := [.const 0 0xa#64, .set 8 0], term := .jump 0x1006c#64 }),
    (0x1006c#64, { ops := [.get 0 22, .get 1 21, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x10#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x10070#64 }),
    (0x10070#64, { ops := [.get 0 20, .get 1 19, .get 3 31, .const 4 0xf#64, .bin 5 .and 3 4, .const 6 0x0#64, .bin 7 .eq 5 6, .guard 7, .const 8 0x20#64, .bin 2 .add 3 8, .const 23 0x8#64, .bin 24 .add 2 23, .store .w64 2 0, .store .w64 24 1], term := .jump 0x10074#64 }),
    (0x10074#64, { ops := [.get 1 6, .un 0 (.zext 32) 1, .get 3 3, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 6 12], term := .jump 0x10078#64 }),
    (0x10078#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .get 3 4, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 7 12], term := .jump 0x1007c#64 }),
    (0x1007c#64, { ops := [.get 1 5, .un 0 (.zext 32) 1, .get 3 2, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 5 12], term := .jump 0x10080#64 }),
    (0x10080#64, { ops := [.get 1 17, .un 0 (.zext 32) 1, .get 3 16, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 17 12], term := .jump 0x10084#64 }),
    (0x10084#64, { ops := [.get 1 13, .un 0 (.zext 32) 1, .get 3 6, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 13 12], term := .jump 0x10088#64 }),
    (0x10088#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 7, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 14 12], term := .jump 0x1008c#64 }),
    (0x1008c#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 3 5, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 12 12], term := .jump 0x10090#64 }),
    (0x10090#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 3 17, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 9 12], term := .jump 0x10094#64 }),
    (0x10094#64, { ops := [.get 0 13, .get 1 13, .un 2 (.zext 32) 1, .const 3 0x10#64, .bin 4 .lshr 2 3, .const 5 0x10#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 13 9], term := .jump 0x10098#64 }),
    (0x10098#64, { ops := [.get 0 14, .get 1 14, .un 2 (.zext 32) 1, .const 3 0x10#64, .bin 4 .lshr 2 3, .const 5 0x10#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 14 9], term := .jump 0x1009c#64 }),
    (0x1009c#64, { ops := [.get 0 12, .get 1 12, .un 2 (.zext 32) 1, .const 3 0x10#64, .bin 4 .lshr 2 3, .const 5 0x10#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 12 9], term := .jump 0x100a0#64 }),
    (0x100a0#64, { ops := [.get 0 9, .get 1 9, .un 2 (.zext 32) 1, .const 3 0x10#64, .bin 4 .lshr 2 3, .const 5 0x10#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 9 9], term := .jump 0x100a4#64 }),
    (0x100a4#64, { ops := [.get 1 18, .un 0 (.zext 32) 1, .get 3 13, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 18 12], term := .jump 0x100a8#64 }),
    (0x100a8#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .const 2 0x1#64, .bin 8 .sub 0 2, .un 3 (.zext 32) 8, .const 9 0x0#64, .un 10 (.sext 32) 3, .bin 4 .slt 10 9, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 11 .xor 0 2, .bin 12 .xor 0 3, .bin 13 .and 11 12, .un 14 (.sext 32) 13, .bin 7 .slt 14 9, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 8 3], term := .jump 0x100ac#64 }),
    (0x100ac#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 3 14, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 19 12], term := .jump 0x100b0#64 }),
    (0x100b0#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 3 12, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 20 12], term := .jump 0x100b4#64 }),
    (0x100b4#64, { ops := [.get 1 18, .un 0 (.zext 32) 1, .get 3 3, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 15 12], term := .jump 0x100b8#64 }),
    (0x100b8#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 9, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 3 12], term := .jump 0x100bc#64 }),
    (0x100bc#64, { ops := [.get 1 19, .un 0 (.zext 32) 1, .get 3 4, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 11 12], term := .jump 0x100c0#64 }),
    (0x100c0#64, { ops := [.get 1 20, .un 0 (.zext 32) 1, .get 3 2, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 2 12], term := .jump 0x100c4#64 }),
    (0x100c4#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 3 16, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 10 12], term := .jump 0x100c8#64 }),
    (0x100c8#64, { ops := [.get 0 11, .get 1 11, .un 2 (.zext 32) 1, .const 3 0x14#64, .bin 4 .lshr 2 3, .const 5 0xc#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 4 9], term := .jump 0x100cc#64 }),
    (0x100cc#64, { ops := [.get 0 15, .get 1 15, .un 2 (.zext 32) 1, .const 3 0x14#64, .bin 4 .lshr 2 3, .const 5 0xc#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 21 9], term := .jump 0x100d0#64 }),
    (0x100d0#64, { ops := [.get 0 2, .get 1 2, .un 2 (.zext 32) 1, .const 3 0x14#64, .bin 4 .lshr 2 3, .const 5 0xc#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 2 9], term := .jump 0x100d4#64 }),
    (0x100d4#64, { ops := [.get 0 10, .get 1 10, .un 2 (.zext 32) 1, .const 3 0x14#64, .bin 4 .lshr 2 3, .const 5 0xc#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 22 9], term := .jump 0x100d8#64 }),
    (0x100d8#64, { ops := [.get 1 4, .un 0 (.zext 32) 1, .get 3 7, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 7 12], term := .jump 0x100dc#64 }),
    (0x100dc#64, { ops := [.get 1 21, .un 0 (.zext 32) 1, .get 3 6, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 6 12], term := .jump 0x100e0#64 }),
    (0x100e0#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 3 5, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 5 12], term := .jump 0x100e4#64 }),
    (0x100e4#64, { ops := [.get 1 22, .un 0 (.zext 32) 1, .get 3 17, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 11 12], term := .jump 0x100e8#64 }),
    (0x100e8#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .get 3 14, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 10 12], term := .jump 0x100ec#64 }),
    (0x100ec#64, { ops := [.get 1 6, .un 0 (.zext 32) 1, .get 3 13, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 13 12], term := .jump 0x100f0#64 }),
    (0x100f0#64, { ops := [.get 1 5, .un 0 (.zext 32) 1, .get 3 12, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 12 12], term := .jump 0x100f4#64 }),
    (0x100f4#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 3 9, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 9 12], term := .jump 0x100f8#64 }),
    (0x100f8#64, { ops := [.get 0 10, .get 1 10, .un 2 (.zext 32) 1, .const 3 0x18#64, .bin 4 .lshr 2 3, .const 5 0x8#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 14 9], term := .jump 0x100fc#64 }),
    (0x100fc#64, { ops := [.get 0 13, .get 1 13, .un 2 (.zext 32) 1, .const 3 0x18#64, .bin 4 .lshr 2 3, .const 5 0x8#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 17 9], term := .jump 0x10100#64 }),
    (0x10100#64, { ops := [.get 0 12, .get 1 12, .un 2 (.zext 32) 1, .const 3 0x18#64, .bin 4 .lshr 2 3, .const 5 0x8#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 15 9], term := .jump 0x10104#64 }),
    (0x10104#64, { ops := [.get 0 9, .get 1 9, .un 2 (.zext 32) 1, .const 3 0x18#64, .bin 4 .lshr 2 3, .const 5 0x8#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 23 9], term := .jump 0x10108#64 }),
    (0x10108#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 19, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 10 12], term := .jump 0x1010c#64 }),
    (0x1010c#64, { ops := [.get 1 17, .un 0 (.zext 32) 1, .get 3 18, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 9 12], term := .jump 0x10110#64 }),
    (0x10110#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 3 20, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 16 12], term := .jump 0x10114#64 }),
    (0x10114#64, { ops := [.get 1 23, .un 0 (.zext 32) 1, .get 3 3, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 3 12], term := .jump 0x10118#64 }),
    (0x10118#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 4, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 12 12], term := .jump 0x1011c#64 }),
    (0x1011c#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 3 21, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 13 12], term := .jump 0x10120#64 }),
    (0x10120#64, { ops := [.get 1 16, .un 0 (.zext 32) 1, .get 3 2, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 2 12], term := .jump 0x10124#64 }),
    (0x10124#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 3 22, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 4 12], term := .jump 0x10128#64 }),
    (0x10128#64, { ops := [.get 0 13, .get 1 13, .un 2 (.zext 32) 1, .const 3 0x19#64, .bin 4 .lshr 2 3, .const 5 0x7#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 18 9], term := .jump 0x1012c#64 }),
    (0x1012c#64, { ops := [.get 0 2, .get 1 2, .un 2 (.zext 32) 1, .const 3 0x19#64, .bin 4 .lshr 2 3, .const 5 0x7#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 2 9], term := .jump 0x10130#64 }),
    (0x10130#64, { ops := [.get 0 4, .get 1 4, .un 2 (.zext 32) 1, .const 3 0x19#64, .bin 4 .lshr 2 3, .const 5 0x7#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 4 9], term := .jump 0x10134#64 }),
    (0x10134#64, { ops := [.get 0 12, .get 1 12, .un 2 (.zext 32) 1, .const 3 0x19#64, .bin 4 .lshr 2 3, .const 5 0x7#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 13 9], term := .jump 0x10138#64 }),
    (0x10138#64, { ops := [.get 1 18, .un 0 (.zext 32) 1, .get 3 7, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 12 12], term := .jump 0x1013c#64 }),
    (0x1013c#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 3 6, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 6 12], term := .jump 0x10140#64 }),
    (0x10140#64, { ops := [.get 1 4, .un 0 (.zext 32) 1, .get 3 5, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 5 12], term := .jump 0x10144#64 }),
    (0x10144#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 3 13, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 11 12], term := .jump 0x10148#64 }),
    (0x10148#64, { ops := [.get 1 23, .un 0 (.zext 32) 1, .get 3 12, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 7 12], term := .jump 0x1014c#64 }),
    (0x1014c#64, { ops := [.get 1 6, .un 0 (.zext 32) 1, .get 3 14, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 14 12], term := .jump 0x10150#64 }),
    (0x10150#64, { ops := [.get 1 5, .un 0 (.zext 32) 1, .get 3 17, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 17 12], term := .jump 0x10154#64 }),
    (0x10154#64, { ops := [.get 0 7, .get 1 7, .un 2 (.zext 32) 1, .const 3 0x10#64, .bin 4 .lshr 2 3, .const 5 0x10#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 19 9], term := .jump 0x10158#64 }),
    (0x10158#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 3 15, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 15 12], term := .jump 0x1015c#64 }),
    (0x1015c#64, { ops := [.get 0 14, .get 1 14, .un 2 (.zext 32) 1, .const 3 0x10#64, .bin 4 .lshr 2 3, .const 5 0x10#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 14 9], term := .jump 0x10160#64 }),
    (0x10160#64, { ops := [.get 0 17, .get 1 17, .un 2 (.zext 32) 1, .const 3 0x10#64, .bin 4 .lshr 2 3, .const 5 0x10#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 20 9], term := .jump 0x10164#64 }),
    (0x10164#64, { ops := [.get 0 15, .get 1 15, .un 2 (.zext 32) 1, .const 3 0x10#64, .bin 4 .lshr 2 3, .const 5 0x10#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 15 9], term := .jump 0x10168#64 }),
    (0x10168#64, { ops := [.get 1 19, .un 0 (.zext 32) 1, .get 3 16, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 16 12], term := .jump 0x1016c#64 }),
    (0x1016c#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 3 14, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 3 12], term := .jump 0x10170#64 }),
    (0x10170#64, { ops := [.get 1 20, .un 0 (.zext 32) 1, .get 3 10, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 21 12], term := .jump 0x10174#64 }),
    (0x10174#64, { ops := [.get 1 16, .un 0 (.zext 32) 1, .get 3 18, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 10 12], term := .jump 0x10178#64 }),
    (0x10178#64, { ops := [.get 1 3, .un 0 (.zext 32) 1, .get 3 2, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 17 12], term := .jump 0x1017c#64 }),
    (0x1017c#64, { ops := [.get 1 21, .un 0 (.zext 32) 1, .get 3 4, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 18 12], term := .jump 0x10180#64 }),
    (0x10180#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 3 9, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 2 12], term := .jump 0x10184#64 }),
    (0x10184#64, { ops := [.get 0 10, .get 1 10, .un 2 (.zext 32) 1, .const 3 0x14#64, .bin 4 .lshr 2 3, .const 5 0xc#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 4 9], term := .jump 0x10188#64 }),
    (0x10188#64, { ops := [.get 0 17, .get 1 17, .un 2 (.zext 32) 1, .const 3 0x14#64, .bin 4 .lshr 2 3, .const 5 0xc#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 22 9], term := .jump 0x1018c#64 }),
    (0x1018c#64, { ops := [.get 1 2, .un 0 (.zext 32) 1, .get 3 13, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 9 12], term := .jump 0x10190#64 }),
    (0x10190#64, { ops := [.get 0 18, .get 1 18, .un 2 (.zext 32) 1, .const 3 0x14#64, .bin 4 .lshr 2 3, .const 5 0xc#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 18 9], term := .jump 0x10194#64 }),
    (0x10194#64, { ops := [.get 0 9, .get 1 9, .un 2 (.zext 32) 1, .const 3 0x14#64, .bin 4 .lshr 2 3, .const 5 0xc#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 23 9], term := .jump 0x10198#64 }),
    (0x10198#64, { ops := [.get 1 4, .un 0 (.zext 32) 1, .get 3 12, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 7 12], term := .jump 0x1019c#64 }),
    (0x1019c#64, { ops := [.get 1 22, .un 0 (.zext 32) 1, .get 3 6, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 6 12], term := .jump 0x101a0#64 }),
    (0x101a0#64, { ops := [.get 1 18, .un 0 (.zext 32) 1, .get 3 5, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 5 12], term := .jump 0x101a4#64 }),
    (0x101a4#64, { ops := [.get 1 7, .un 0 (.zext 32) 1, .get 3 19, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 9 12], term := .jump 0x101a8#64 }),
    (0x101a8#64, { ops := [.get 1 23, .un 0 (.zext 32) 1, .get 3 11, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 17 12], term := .jump 0x101ac#64 }),
    (0x101ac#64, { ops := [.get 1 6, .un 0 (.zext 32) 1, .get 3 14, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 10 12], term := .jump 0x101b0#64 }),
    (0x101b0#64, { ops := [.get 1 5, .un 0 (.zext 32) 1, .get 3 20, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 11 12], term := .jump 0x101b4#64 }),
    (0x101b4#64, { ops := [.get 0 9, .get 1 9, .un 2 (.zext 32) 1, .const 3 0x18#64, .bin 4 .lshr 2 3, .const 5 0x8#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 9 9], term := .jump 0x101b8#64 }),
    (0x101b8#64, { ops := [.get 1 17, .un 0 (.zext 32) 1, .get 3 15, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 12 12], term := .jump 0x101bc#64 }),
    (0x101bc#64, { ops := [.get 0 10, .get 1 10, .un 2 (.zext 32) 1, .const 3 0x18#64, .bin 4 .lshr 2 3, .const 5 0x8#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 14 9], term := .jump 0x101c0#64 }),
    (0x101c0#64, { ops := [.get 0 11, .get 1 11, .un 2 (.zext 32) 1, .const 3 0x18#64, .bin 4 .lshr 2 3, .const 5 0x8#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 13 9], term := .jump 0x101c4#64 }),
    (0x101c4#64, { ops := [.get 0 12, .get 1 12, .un 2 (.zext 32) 1, .const 3 0x18#64, .bin 4 .lshr 2 3, .const 5 0x8#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 12 9], term := .jump 0x101c8#64 }),
    (0x101c8#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 3 16, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 11 12], term := .jump 0x101cc#64 }),
    (0x101cc#64, { ops := [.get 1 14, .un 0 (.zext 32) 1, .get 3 3, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 10 12], term := .jump 0x101d0#64 }),
    (0x101d0#64, { ops := [.get 1 13, .un 0 (.zext 32) 1, .get 3 21, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 15 12], term := .jump 0x101d4#64 }),
    (0x101d4#64, { ops := [.get 1 11, .un 0 (.zext 32) 1, .get 3 4, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 16 12], term := .jump 0x101d8#64 }),
    (0x101d8#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 22, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 4 12], term := .jump 0x101dc#64 }),
    (0x101dc#64, { ops := [.get 1 15, .un 0 (.zext 32) 1, .get 3 18, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 19 12], term := .jump 0x101e0#64 }),
    (0x101e0#64, { ops := [.get 1 12, .un 0 (.zext 32) 1, .get 3 2, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 18 12], term := .jump 0x101e4#64 }),
    (0x101e4#64, { ops := [.get 0 4, .get 1 4, .un 2 (.zext 32) 1, .const 3 0x19#64, .bin 4 .lshr 2 3, .const 5 0x7#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 2 9], term := .jump 0x101e8#64 }),
    (0x101e8#64, { ops := [.get 1 18, .un 0 (.zext 32) 1, .get 3 23, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 4 12], term := .jump 0x101ec#64 }),
    (0x101ec#64, { ops := [.get 0 16, .get 1 16, .un 2 (.zext 32) 1, .const 3 0x19#64, .bin 4 .lshr 2 3, .const 5 0x7#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 3 9], term := .jump 0x101f0#64 }),
    (0x101f0#64, { ops := [.get 0 19, .get 1 19, .un 2 (.zext 32) 1, .const 3 0x19#64, .bin 4 .lshr 2 3, .const 5 0x7#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 16 9], term := .jump 0x101f4#64 }),
    (0x101f4#64, { ops := [.get 0 4, .get 1 4, .un 2 (.zext 32) 1, .const 3 0x19#64, .bin 4 .lshr 2 3, .const 5 0x7#64, .bin 6 .shl 0 5, .bin 7 .or 4 6, .un 9 (.zext 32) 7, .set 4 9], term := .jump 0x101f8#64 }),
    (0x101f8#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10074#64 0x101fc#64 }),
    (0x101fc#64, { ops := [.get 0 1, .load 30 .w32 0, .set 8 30], term := .jump 0x10200#64 }),
    (0x10200#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x20#64, .bin 0 .add 1 6, .const 21 0x8#64, .bin 22 .add 0 21, .load 23 .w64 0, .load 26 .w64 22, .set 20 23, .set 19 26], term := .jump 0x10204#64 }),
    (0x10204#64, { ops := [.get 1 31, .const 2 0xf#64, .bin 3 .and 1 2, .const 4 0x0#64, .bin 5 .eq 3 4, .guard 5, .const 6 0x10#64, .bin 0 .add 1 6, .const 21 0x8#64, .bin 22 .add 0 21, .load 23 .w64 0, .load 26 .w64 22, .set 22 23, .set 21 26], term := .jump 0x10208#64 }),
    (0x10208#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 7, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x1020c#64 }),
    (0x1020c#64, { ops := [.get 0 8, .get 1 0, .store .w32 1 0], term := .jump 0x10210#64 }),
    (0x10210#64, { ops := [.get 1 1, .const 6 0x4#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x10214#64 }),
    (0x10214#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 6, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10218#64 }),
    (0x10218#64, { ops := [.get 0 8, .get 2 0, .const 7 0x4#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x1021c#64 }),
    (0x1021c#64, { ops := [.get 1 1, .const 6 0x8#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x10220#64 }),
    (0x10220#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 5, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10224#64 }),
    (0x10224#64, { ops := [.get 0 8, .get 2 0, .const 7 0x8#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x10228#64 }),
    (0x10228#64, { ops := [.get 1 1, .const 6 0xc#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x1022c#64 }),
    (0x1022c#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 17, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10230#64 }),
    (0x10230#64, { ops := [.get 0 8, .get 2 0, .const 7 0xc#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x10234#64 }),
    (0x10234#64, { ops := [.get 1 1, .const 6 0x10#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x10238#64 }),
    (0x10238#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 4, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x1023c#64 }),
    (0x1023c#64, { ops := [.get 0 8, .get 2 0, .const 7 0x10#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x10240#64 }),
    (0x10240#64, { ops := [.get 1 1, .const 6 0x14#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x10244#64 })]

/-- Part 1 of the blocks of `chacha20_block`. -/
def chacha20_block_blocks_1 : List (Braid.Word × Braid.Block) := [
    (0x10244#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 3, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10248#64 }),
    (0x10248#64, { ops := [.get 0 8, .get 2 0, .const 7 0x14#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x1024c#64 }),
    (0x1024c#64, { ops := [.get 1 1, .const 6 0x18#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x10250#64 }),
    (0x10250#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 2, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10254#64 }),
    (0x10254#64, { ops := [.get 0 8, .get 2 0, .const 7 0x18#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x10258#64 }),
    (0x10258#64, { ops := [.get 1 1, .const 6 0x1c#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x1025c#64 }),
    (0x1025c#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 16, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10260#64 }),
    (0x10260#64, { ops := [.get 0 8, .get 2 0, .const 7 0x1c#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x10264#64 }),
    (0x10264#64, { ops := [.get 1 1, .const 6 0x20#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x10268#64 }),
    (0x10268#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 15, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x1026c#64 }),
    (0x1026c#64, { ops := [.get 0 8, .get 2 0, .const 7 0x20#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x10270#64 }),
    (0x10270#64, { ops := [.get 1 1, .const 6 0x24#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x10274#64 }),
    (0x10274#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 18, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10278#64 }),
    (0x10278#64, { ops := [.get 0 8, .get 2 0, .const 7 0x24#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x1027c#64 }),
    (0x1027c#64, { ops := [.get 1 1, .const 6 0x28#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x10280#64 }),
    (0x10280#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 11, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10284#64 }),
    (0x10284#64, { ops := [.get 0 8, .get 2 0, .const 7 0x28#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x10288#64 }),
    (0x10288#64, { ops := [.get 1 1, .const 6 0x2c#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x1028c#64 }),
    (0x1028c#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 10, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x10290#64 }),
    (0x10290#64, { ops := [.get 0 8, .get 2 0, .const 7 0x2c#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x10294#64 }),
    (0x10294#64, { ops := [.get 1 1, .const 6 0x30#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x10298#64 }),
    (0x10298#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 14, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x1029c#64 }),
    (0x1029c#64, { ops := [.get 0 8, .get 2 0, .const 7 0x30#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x102a0#64 }),
    (0x102a0#64, { ops := [.get 1 1, .const 6 0x34#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x102a4#64 }),
    (0x102a4#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 13, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x102a8#64 }),
    (0x102a8#64, { ops := [.get 0 8, .get 2 0, .const 7 0x34#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x102ac#64 }),
    (0x102ac#64, { ops := [.get 1 1, .const 6 0x38#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x102b0#64 }),
    (0x102b0#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 12, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x102b4#64 }),
    (0x102b4#64, { ops := [.get 0 8, .get 2 0, .const 7 0x38#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x102b8#64 }),
    (0x102b8#64, { ops := [.get 1 1, .const 6 0x3c#64, .bin 0 .add 1 6, .load 30 .w32 0, .set 8 30], term := .jump 0x102bc#64 }),
    (0x102bc#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .get 3 9, .un 2 (.zext 32) 3, .bin 13 .add 0 2, .un 12 (.zext 32) 13, .set 8 12], term := .jump 0x102c0#64 }),
    (0x102c0#64, { ops := [.get 0 8, .get 2 0, .const 7 0x3c#64, .bin 1 .add 2 7, .store .w32 1 0], term := .jump 0x102c4#64 }),
    (0x102c4#64, { ops := [.get 0 31, .const 1 0xf#64, .bin 2 .and 0 1, .const 3 0x0#64, .bin 4 .eq 2 3, .guard 4, .const 5 0x30#64, .bin 6 .add 0 5, .set 31 6, .load 30 .w64 0, .set 23 30], term := .jump 0x102c8#64 }),
    (0x102c8#64, { ops := [.get 0 30], term := .jumpInd 0 })]

/-- `chacha20_block`, lowered to `braid`. -/
def chacha20_block : Braid.Func :=
  { name := "chacha20_block", entry := 0x10044#64, blocks :=
    chacha20_block_blocks_0 ++
    chacha20_block_blocks_1 }

/-- `chacha20_block` is the lowering of `chacha20_block_words`. -/
theorem chacha20_block_lowered :
    chacha20_block.blocks = Lowering.Arm.lowerWords 0x10044#64 chacha20_block_words := by
  decide +kernel

end Examples.ChaCha20.O2.Arm
