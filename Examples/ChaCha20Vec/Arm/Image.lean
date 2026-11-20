/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.ChaCha20Vec.Arm


/-- The instruction words of `chacha20_block_vec`, from `0x10000`. -/
def chacha20_block_vec_words : List (BitVec 32) := [
  0xad400820#32, 0x52800148#32, 0xad410c21#32, 0x4ea01c04#32, 0x4ea48444#32, 0x71000508#32, 0x6e241c63#32, 0x6e600863#32, 0x4ea18461#32, 0x6e221c22#32, 0x4f2c5445#32, 0x6f2c1445#32, 0x4ea484a2#32, 0x6e231c43#32, 0x4f285464#32, 0x6f281464#32, 0x4ea18481#32, 0x6e046084#32, 0x6e251c23#32, 0x6e014021#32, 0x4f275465#32, 0x6f271465#32, 0x6e0520a3#32, 0x4ea28462#32, 0x6e241c44#32, 0x6e600885#32, 0x4ea184a1#32, 0x6e231c23#32, 0x4f2c5466#32, 0x6f2c1466#32, 0x4ea284c4#32, 0x6e251c82#32, 0x4f285443#32, 0x6f281443#32, 0x4ea18461#32, 0x6e032063#32, 0x6e261c22#32, 0x6e014021#32, 0x4f275445#32, 0x6f271445#32, 0x6e0560a2#32, 0x54fffb61#32, 0x4ea08480#32, 0x3d800000#32, 0x3dc00420#32, 0x4ea28400#32, 0x3d800400#32, 0x3dc00820#32, 0x4ea18400#32, 0x3d800800#32, 0x3dc00c20#32, 0x4ea38400#32, 0x3d800c00#32, 0xd65f03c0#32]

/-- `chacha20_block_vec`, lowered to `braid`. -/
def chacha20_block_vec : Braid.Func :=
  { name := "chacha20_block_vec", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 0 1, .const 21 0x10#64, .bin 22 .add 0 21, .load 23 .w64 0, .const 25 0x8#64, .bin 26 .add 0 25, .load 24 .w64 26, .load 27 .w64 22, .const 29 0x8#64, .bin 30 .add 22 29, .load 28 .w64 30, .set 64 23, .set 65 24, .set 68 27, .set 69 28], term := .jump 0x10004#64 }),
    (0x10004#64, { ops := [.const 0 0xa#64, .set 8 0], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 1 1, .const 6 0x20#64, .bin 0 .add 1 6, .const 21 0x10#64, .bin 22 .add 0 21, .load 23 .w64 0, .const 25 0x8#64, .bin 26 .add 0 25, .load 24 .w64 26, .load 27 .w64 22, .const 29 0x8#64, .bin 30 .add 22 29, .load 28 .w64 30, .set 66 23, .set 67 24, .set 70 27, .set 71 28], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.get 0 64, .get 1 65, .get 2 64, .get 3 65, .bin 10 .or 0 2, .bin 20 .or 1 3, .set 72 10, .set 73 20], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.get 0 68, .get 1 69, .get 2 72, .get 3 73, .bin 10 (.lanes 32 .add) 0 2, .bin 20 (.lanes 32 .add) 1 3, .set 72 10, .set 73 20], term := .jump 0x10014#64 }),
    (0x10014#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .const 2 0x1#64, .bin 8 .sub 0 2, .un 3 (.zext 32) 8, .const 9 0x0#64, .un 10 (.sext 32) 3, .bin 4 .slt 10 9, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 11 .xor 0 2, .bin 12 .xor 0 3, .bin 13 .and 11 12, .un 14 (.sext 32) 13, .bin 7 .slt 14 9, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 8 3], term := .jump 0x10018#64 }),
    (0x10018#64, { ops := [.get 0 70, .get 1 71, .get 2 72, .get 3 73, .bin 10 .xor 0 2, .bin 20 .xor 1 3, .set 70 10, .set 71 20], term := .jump 0x1001c#64 }),
    (0x1001c#64, { ops := [.get 0 70, .get 1 71, .const 11 0x10#64, .bin 12 .lshr 0 11, .const 13 0xffff0000ffff#64, .bin 14 .and 12 13, .bin 15 .shl 0 11, .un 16 .not 13, .bin 17 .and 15 16, .bin 10 .or 14 17, .const 51 0x10#64, .bin 52 .lshr 1 51, .const 53 0xffff0000ffff#64, .bin 54 .and 52 53, .bin 55 .shl 1 51, .un 56 .not 53, .bin 57 .and 55 56, .bin 50 .or 54 57, .set 70 10, .set 71 50], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.get 0 70, .get 1 71, .get 2 66, .get 3 67, .bin 10 (.lanes 32 .add) 0 2, .bin 20 (.lanes 32 .add) 1 3, .set 66 10, .set 67 20], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 0 66, .get 1 67, .get 2 68, .get 3 69, .bin 10 .xor 0 2, .bin 20 .xor 1 3, .set 68 10, .set 69 20], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 68, .get 1 69, .const 11 0xc#64, .bin 12 .shl 0 11, .const 13 0xfffff000fffff000#64, .bin 10 .and 12 13, .const 21 0xc#64, .bin 22 .shl 1 21, .const 23 0xfffff000fffff000#64, .bin 20 .and 22 23, .set 74 10, .set 75 20], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 0 68, .get 1 69, .get 2 74, .get 3 75, .const 11 0x14#64, .bin 12 .lshr 0 11, .const 13 0xfff00000fff#64, .bin 14 .and 12 13, .bin 10 (.lanes 32 .add) 2 14, .const 21 0x14#64, .bin 22 .lshr 1 21, .const 23 0xfff00000fff#64, .bin 24 .and 22 23, .bin 20 (.lanes 32 .add) 3 24, .set 74 10, .set 75 20], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.get 0 74, .get 1 75, .get 2 72, .get 3 73, .bin 10 (.lanes 32 .add) 0 2, .bin 20 (.lanes 32 .add) 1 3, .set 68 10, .set 69 20], term := .jump 0x10034#64 }),
    (0x10034#64, { ops := [.get 0 68, .get 1 69, .get 2 70, .get 3 71, .bin 10 .xor 0 2, .bin 20 .xor 1 3, .set 70 10, .set 71 20], term := .jump 0x10038#64 }),
    (0x10038#64, { ops := [.get 0 70, .get 1 71, .const 11 0x8#64, .bin 12 .shl 0 11, .const 13 0xffffff00ffffff00#64, .bin 10 .and 12 13, .const 21 0x8#64, .bin 22 .shl 1 21, .const 23 0xffffff00ffffff00#64, .bin 20 .and 22 23, .set 72 10, .set 73 20], term := .jump 0x1003c#64 }),
    (0x1003c#64, { ops := [.get 0 70, .get 1 71, .get 2 72, .get 3 73, .const 11 0x18#64, .bin 12 .lshr 0 11, .const 13 0xff000000ff#64, .bin 14 .and 12 13, .bin 10 (.lanes 32 .add) 2 14, .const 21 0x18#64, .bin 22 .lshr 1 21, .const 23 0xff000000ff#64, .bin 24 .and 22 23, .bin 20 (.lanes 32 .add) 3 24, .set 72 10, .set 73 20], term := .jump 0x10040#64 }),
    (0x10040#64, { ops := [.get 0 72, .get 1 73, .get 2 66, .get 3 67, .bin 10 (.lanes 32 .add) 0 2, .bin 20 (.lanes 32 .add) 1 3, .set 66 10, .set 67 20], term := .jump 0x10044#64 }),
    (0x10044#64, { ops := [.get 0 72, .get 1 73, .get 2 72, .get 3 73, .const 11 0x20#64, .bin 12 .lshr 1 11, .const 13 0x20#64, .bin 14 .shl 2 13, .bin 10 .or 12 14, .const 21 0x20#64, .bin 22 .lshr 2 21, .const 23 0x20#64, .bin 24 .shl 3 23, .bin 20 .or 22 24, .set 72 10, .set 73 20], term := .jump 0x10048#64 }),
    (0x10048#64, { ops := [.get 0 66, .get 1 67, .get 2 74, .get 3 75, .bin 10 .xor 0 2, .bin 20 .xor 1 3, .set 70 10, .set 71 20], term := .jump 0x1004c#64 }),
    (0x1004c#64, { ops := [.get 0 66, .get 1 67, .get 2 66, .get 3 67, .set 66 1, .set 67 2], term := .jump 0x10050#64 }),
    (0x10050#64, { ops := [.get 0 70, .get 1 71, .const 11 0x7#64, .bin 12 .shl 0 11, .const 13 0xffffff80ffffff80#64, .bin 10 .and 12 13, .const 21 0x7#64, .bin 22 .shl 1 21, .const 23 0xffffff80ffffff80#64, .bin 20 .and 22 23, .set 74 10, .set 75 20], term := .jump 0x10054#64 }),
    (0x10054#64, { ops := [.get 0 70, .get 1 71, .get 2 74, .get 3 75, .const 11 0x19#64, .bin 12 .lshr 0 11, .const 13 0x7f0000007f#64, .bin 14 .and 12 13, .bin 10 (.lanes 32 .add) 2 14, .const 21 0x19#64, .bin 22 .lshr 1 21, .const 23 0x7f0000007f#64, .bin 24 .and 22 23, .bin 20 (.lanes 32 .add) 3 24, .set 74 10, .set 75 20], term := .jump 0x10058#64 }),
    (0x10058#64, { ops := [.get 0 74, .get 1 75, .get 2 74, .get 3 75, .const 11 0x20#64, .bin 12 .lshr 0 11, .const 13 0x20#64, .bin 14 .shl 1 13, .bin 10 .or 12 14, .const 21 0x20#64, .bin 22 .lshr 1 21, .const 23 0x20#64, .bin 24 .shl 2 23, .bin 20 .or 22 24, .set 70 10, .set 71 20], term := .jump 0x1005c#64 }),
    (0x1005c#64, { ops := [.get 0 70, .get 1 71, .get 2 68, .get 3 69, .bin 10 (.lanes 32 .add) 0 2, .bin 20 (.lanes 32 .add) 1 3, .set 68 10, .set 69 20], term := .jump 0x10060#64 }),
    (0x10060#64, { ops := [.get 0 68, .get 1 69, .get 2 72, .get 3 73, .bin 10 .xor 0 2, .bin 20 .xor 1 3, .set 72 10, .set 73 20], term := .jump 0x10064#64 }),
    (0x10064#64, { ops := [.get 0 72, .get 1 73, .const 11 0x10#64, .bin 12 .lshr 0 11, .const 13 0xffff0000ffff#64, .bin 14 .and 12 13, .bin 15 .shl 0 11, .un 16 .not 13, .bin 17 .and 15 16, .bin 10 .or 14 17, .const 51 0x10#64, .bin 52 .lshr 1 51, .const 53 0xffff0000ffff#64, .bin 54 .and 52 53, .bin 55 .shl 1 51, .un 56 .not 53, .bin 57 .and 55 56, .bin 50 .or 54 57, .set 74 10, .set 75 50], term := .jump 0x10068#64 }),
    (0x10068#64, { ops := [.get 0 74, .get 1 75, .get 2 66, .get 3 67, .bin 10 (.lanes 32 .add) 0 2, .bin 20 (.lanes 32 .add) 1 3, .set 66 10, .set 67 20], term := .jump 0x1006c#64 }),
    (0x1006c#64, { ops := [.get 0 66, .get 1 67, .get 2 70, .get 3 71, .bin 10 .xor 0 2, .bin 20 .xor 1 3, .set 70 10, .set 71 20], term := .jump 0x10070#64 }),
    (0x10070#64, { ops := [.get 0 70, .get 1 71, .const 11 0xc#64, .bin 12 .shl 0 11, .const 13 0xfffff000fffff000#64, .bin 10 .and 12 13, .const 21 0xc#64, .bin 22 .shl 1 21, .const 23 0xfffff000fffff000#64, .bin 20 .and 22 23, .set 76 10, .set 77 20], term := .jump 0x10074#64 }),
    (0x10074#64, { ops := [.get 0 70, .get 1 71, .get 2 76, .get 3 77, .const 11 0x14#64, .bin 12 .lshr 0 11, .const 13 0xfff00000fff#64, .bin 14 .and 12 13, .bin 10 (.lanes 32 .add) 2 14, .const 21 0x14#64, .bin 22 .lshr 1 21, .const 23 0xfff00000fff#64, .bin 24 .and 22 23, .bin 20 (.lanes 32 .add) 3 24, .set 76 10, .set 77 20], term := .jump 0x10078#64 }),
    (0x10078#64, { ops := [.get 0 76, .get 1 77, .get 2 68, .get 3 69, .bin 10 (.lanes 32 .add) 0 2, .bin 20 (.lanes 32 .add) 1 3, .set 72 10, .set 73 20], term := .jump 0x1007c#64 }),
    (0x1007c#64, { ops := [.get 0 72, .get 1 73, .get 2 74, .get 3 75, .bin 10 .xor 0 2, .bin 20 .xor 1 3, .set 68 10, .set 69 20], term := .jump 0x10080#64 }),
    (0x10080#64, { ops := [.get 0 68, .get 1 69, .const 11 0x8#64, .bin 12 .shl 0 11, .const 13 0xffffff00ffffff00#64, .bin 10 .and 12 13, .const 21 0x8#64, .bin 22 .shl 1 21, .const 23 0xffffff00ffffff00#64, .bin 20 .and 22 23, .set 70 10, .set 71 20], term := .jump 0x10084#64 }),
    (0x10084#64, { ops := [.get 0 68, .get 1 69, .get 2 70, .get 3 71, .const 11 0x18#64, .bin 12 .lshr 0 11, .const 13 0xff000000ff#64, .bin 14 .and 12 13, .bin 10 (.lanes 32 .add) 2 14, .const 21 0x18#64, .bin 22 .lshr 1 21, .const 23 0xff000000ff#64, .bin 24 .and 22 23, .bin 20 (.lanes 32 .add) 3 24, .set 70 10, .set 71 20], term := .jump 0x10088#64 }),
    (0x10088#64, { ops := [.get 0 70, .get 1 71, .get 2 66, .get 3 67, .bin 10 (.lanes 32 .add) 0 2, .bin 20 (.lanes 32 .add) 1 3, .set 66 10, .set 67 20], term := .jump 0x1008c#64 }),
    (0x1008c#64, { ops := [.get 0 70, .get 1 71, .get 2 70, .get 3 71, .const 11 0x20#64, .bin 12 .lshr 0 11, .const 13 0x20#64, .bin 14 .shl 1 13, .bin 10 .or 12 14, .const 21 0x20#64, .bin 22 .lshr 1 21, .const 23 0x20#64, .bin 24 .shl 2 23, .bin 20 .or 22 24, .set 70 10, .set 71 20], term := .jump 0x10090#64 }),
    (0x10090#64, { ops := [.get 0 66, .get 1 67, .get 2 76, .get 3 77, .bin 10 .xor 0 2, .bin 20 .xor 1 3, .set 68 10, .set 69 20], term := .jump 0x10094#64 }),
    (0x10094#64, { ops := [.get 0 66, .get 1 67, .get 2 66, .get 3 67, .set 66 1, .set 67 2], term := .jump 0x10098#64 }),
    (0x10098#64, { ops := [.get 0 68, .get 1 69, .const 11 0x7#64, .bin 12 .shl 0 11, .const 13 0xffffff80ffffff80#64, .bin 10 .and 12 13, .const 21 0x7#64, .bin 22 .shl 1 21, .const 23 0xffffff80ffffff80#64, .bin 20 .and 22 23, .set 74 10, .set 75 20], term := .jump 0x1009c#64 }),
    (0x1009c#64, { ops := [.get 0 68, .get 1 69, .get 2 74, .get 3 75, .const 11 0x19#64, .bin 12 .lshr 0 11, .const 13 0x7f0000007f#64, .bin 14 .and 12 13, .bin 10 (.lanes 32 .add) 2 14, .const 21 0x19#64, .bin 22 .lshr 1 21, .const 23 0x7f0000007f#64, .bin 24 .and 22 23, .bin 20 (.lanes 32 .add) 3 24, .set 74 10, .set 75 20], term := .jump 0x100a0#64 }),
    (0x100a0#64, { ops := [.get 0 74, .get 1 75, .get 2 74, .get 3 75, .const 11 0x20#64, .bin 12 .lshr 1 11, .const 13 0x20#64, .bin 14 .shl 2 13, .bin 10 .or 12 14, .const 21 0x20#64, .bin 22 .lshr 2 21, .const 23 0x20#64, .bin 24 .shl 3 23, .bin 20 .or 22 24, .set 68 10, .set 69 20], term := .jump 0x100a4#64 }),
    (0x100a4#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10010#64 0x100a8#64 }),
    (0x100a8#64, { ops := [.get 0 72, .get 1 73, .get 2 64, .get 3 65, .bin 10 (.lanes 32 .add) 0 2, .bin 20 (.lanes 32 .add) 1 3, .set 64 10, .set 65 20], term := .jump 0x100ac#64 }),
    (0x100ac#64, { ops := [.get 0 64, .get 1 65, .get 2 0, .store .w64 2 0, .const 30 0x8#64, .bin 31 .add 2 30, .store .w64 31 1], term := .jump 0x100b0#64 }),
    (0x100b0#64, { ops := [.get 1 1, .const 6 0x10#64, .bin 0 .add 1 6, .load 30 .w64 0, .const 32 0x8#64, .bin 33 .add 0 32, .load 31 .w64 33, .set 64 30, .set 65 31], term := .jump 0x100b4#64 }),
    (0x100b4#64, { ops := [.get 0 64, .get 1 65, .get 2 68, .get 3 69, .bin 10 (.lanes 32 .add) 0 2, .bin 20 (.lanes 32 .add) 1 3, .set 64 10, .set 65 20], term := .jump 0x100b8#64 }),
    (0x100b8#64, { ops := [.get 0 64, .get 1 65, .get 3 0, .const 8 0x10#64, .bin 2 .add 3 8, .store .w64 2 0, .const 30 0x8#64, .bin 31 .add 2 30, .store .w64 31 1], term := .jump 0x100bc#64 }),
    (0x100bc#64, { ops := [.get 1 1, .const 6 0x20#64, .bin 0 .add 1 6, .load 30 .w64 0, .const 32 0x8#64, .bin 33 .add 0 32, .load 31 .w64 33, .set 64 30, .set 65 31], term := .jump 0x100c0#64 }),
    (0x100c0#64, { ops := [.get 0 64, .get 1 65, .get 2 66, .get 3 67, .bin 10 (.lanes 32 .add) 0 2, .bin 20 (.lanes 32 .add) 1 3, .set 64 10, .set 65 20], term := .jump 0x100c4#64 }),
    (0x100c4#64, { ops := [.get 0 64, .get 1 65, .get 3 0, .const 8 0x20#64, .bin 2 .add 3 8, .store .w64 2 0, .const 30 0x8#64, .bin 31 .add 2 30, .store .w64 31 1], term := .jump 0x100c8#64 }),
    (0x100c8#64, { ops := [.get 1 1, .const 6 0x30#64, .bin 0 .add 1 6, .load 30 .w64 0, .const 32 0x8#64, .bin 33 .add 0 32, .load 31 .w64 33, .set 64 30, .set 65 31], term := .jump 0x100cc#64 }),
    (0x100cc#64, { ops := [.get 0 64, .get 1 65, .get 2 70, .get 3 71, .bin 10 (.lanes 32 .add) 0 2, .bin 20 (.lanes 32 .add) 1 3, .set 64 10, .set 65 20], term := .jump 0x100d0#64 }),
    (0x100d0#64, { ops := [.get 0 64, .get 1 65, .get 3 0, .const 8 0x30#64, .bin 2 .add 3 8, .store .w64 2 0, .const 30 0x8#64, .bin 31 .add 2 30, .store .w64 31 1], term := .jump 0x100d4#64 }),
    (0x100d4#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `chacha20_block_vec` is the lowering of `chacha20_block_vec_words`. -/
theorem chacha20_block_vec_lowered :
    chacha20_block_vec.blocks = Lowering.Arm.lowerWords 0x10000#64 chacha20_block_vec_words := by
  decide

end Examples.ChaCha20Vec.Arm
