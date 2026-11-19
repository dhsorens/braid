/- Written by `braid-lower`. Do not edit. -/

module

public import Lowering.Arm.Logic

@[expose] public section

namespace Examples.Mem.Arm


/-- The instruction words of `copy_bytes`, from `0x10000`. -/
def copy_bytes_words : List (BitVec 32) := [
  0xb40000a2#32, 0x38401428#32, 0xf1000442#32, 0x38001408#32, 0x54ffffa1#32, 0xd65f03c0#32]

/-- `copy_bytes`, lowered to `braid`. -/
def copy_bytes : Braid.Func :=
  { name := "copy_bytes", entry := 0x10000#64, blocks := [
    (0x10000#64, { ops := [.get 0 2], term := .branch 0 0x10004#64 0x10014#64 }),
    (0x10004#64, { ops := [.get 0 1, .const 5 0x1#64, .bin 6 .add 0 5, .set 1 6, .load 30 .w8 0, .set 8 30], term := .jump 0x10008#64 }),
    (0x10008#64, { ops := [.get 0 2, .const 2 0x1#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 2 3], term := .jump 0x1000c#64 }),
    (0x1000c#64, { ops := [.get 0 8, .get 1 0, .const 6 0x1#64, .bin 7 .add 1 6, .set 0 7, .store .w8 1 0], term := .jump 0x10010#64 }),
    (0x10010#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10004#64 0x10014#64 }),
    (0x10014#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `copy_bytes` is the lowering of `copy_bytes_words`. -/
theorem copy_bytes_lowered :
    copy_bytes.blocks = Lowering.Arm.lowerWords 0x10000#64 copy_bytes_words := by
  decide

/-- The instruction words of `equal_bytes`, from `0x10018`. -/
def equal_bytes_words : List (BitVec 32) := [
  0xb4000142#32, 0xaa0003e8#32, 0x52800020#32, 0x38401509#32, 0x3840142a#32, 0x6b0a013f#32, 0x540000c1#32, 0xf1000442#32, 0x54ffff61#32, 0xd65f03c0#32, 0x52800020#32, 0xd65f03c0#32, 0xaa1f03e0#32, 0xd65f03c0#32]

/-- `equal_bytes`, lowered to `braid`. -/
def equal_bytes : Braid.Func :=
  { name := "equal_bytes", entry := 0x10018#64, blocks := [
    (0x10018#64, { ops := [.get 0 2], term := .branch 0 0x1001c#64 0x10040#64 }),
    (0x1001c#64, { ops := [.const 0 0x0#64, .get 2 0, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10020#64 }),
    (0x10020#64, { ops := [.const 0 0x1#64, .set 0 0], term := .jump 0x10024#64 }),
    (0x10024#64, { ops := [.get 0 8, .const 5 0x1#64, .bin 6 .add 0 5, .set 8 6, .load 30 .w8 0, .set 9 30], term := .jump 0x10028#64 }),
    (0x10028#64, { ops := [.get 0 1, .const 5 0x1#64, .bin 6 .add 0 5, .set 1 6, .load 30 .w8 0, .set 10 30], term := .jump 0x1002c#64 }),
    (0x1002c#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 3 10, .un 2 (.zext 32) 3, .bin 17 .sub 0 2, .un 12 (.zext 32) 17, .const 18 0x0#64, .un 19 (.sext 32) 12, .bin 13 .slt 19 18, .bin 14 .eq 0 2, .bin 15 .ule 2 0, .bin 20 .xor 0 2, .bin 21 .xor 0 12, .bin 22 .and 20 21, .un 23 (.sext 32) 22, .bin 16 .slt 23 18, .setf 0 13, .setf 1 14, .setf 2 15, .setf 3 16], term := .jump 0x10030#64 }),
    (0x10030#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10048#64 0x10034#64 }),
    (0x10034#64, { ops := [.get 0 2, .const 2 0x1#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 2 3], term := .jump 0x10038#64 }),
    (0x10038#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10024#64 0x1003c#64 }),
    (0x1003c#64, { ops := [.get 0 30], term := .jumpInd 0 }),
    (0x10040#64, { ops := [.const 0 0x1#64, .set 0 0], term := .jump 0x10044#64 }),
    (0x10044#64, { ops := [.get 0 30], term := .jumpInd 0 }),
    (0x10048#64, { ops := [.const 0 0x0#64, .const 2 0x0#64, .bin 12 .or 0 2, .set 0 12], term := .jump 0x1004c#64 }),
    (0x1004c#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `equal_bytes` is the lowering of `equal_bytes_words`. -/
theorem equal_bytes_lowered :
    equal_bytes.blocks = Lowering.Arm.lowerWords 0x10018#64 equal_bytes_words := by
  decide

/-- The instruction words of `equal_bytes_ct`, from `0x10050`. -/
def equal_bytes_ct_words : List (BitVec 32) := [
  0xb4000162#32, 0x2a1f03e8#32, 0x38401409#32, 0xf1000442#32, 0x3840142a#32, 0x4a090149#32, 0x2a080128#32, 0x54ffff61#32, 0x7100011f#32, 0x1a9f17e0#32, 0xd65f03c0#32, 0x52800020#32, 0xd65f03c0#32]

/-- `equal_bytes_ct`, lowered to `braid`. -/
def equal_bytes_ct : Braid.Func :=
  { name := "equal_bytes_ct", entry := 0x10050#64, blocks := [
    (0x10050#64, { ops := [.get 0 2], term := .branch 0 0x10054#64 0x1007c#64 }),
    (0x10054#64, { ops := [.const 1 0x0#64, .un 0 (.zext 32) 1, .const 3 0x0#64, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 8 12], term := .jump 0x10058#64 }),
    (0x10058#64, { ops := [.get 0 0, .const 5 0x1#64, .bin 6 .add 0 5, .set 0 6, .load 30 .w8 0, .set 9 30], term := .jump 0x1005c#64 }),
    (0x1005c#64, { ops := [.get 0 2, .const 2 0x1#64, .bin 3 .sub 0 2, .const 8 0x0#64, .bin 4 .slt 3 8, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 9 .xor 0 2, .bin 10 .xor 0 3, .bin 11 .and 9 10, .bin 7 .slt 11 8, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7, .set 2 3], term := .jump 0x10060#64 }),
    (0x10060#64, { ops := [.get 0 1, .const 5 0x1#64, .bin 6 .add 0 5, .set 1 6, .load 30 .w8 0, .set 10 30], term := .jump 0x10064#64 }),
    (0x10064#64, { ops := [.get 1 10, .un 0 (.zext 32) 1, .get 3 9, .un 2 (.zext 32) 3, .bin 12 .xor 0 2, .set 9 12], term := .jump 0x10068#64 }),
    (0x10068#64, { ops := [.get 1 9, .un 0 (.zext 32) 1, .get 3 8, .un 2 (.zext 32) 3, .bin 12 .or 0 2, .set 8 12], term := .jump 0x1006c#64 }),
    (0x1006c#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2], term := .branch 0 0x10058#64 0x10070#64 }),
    (0x10070#64, { ops := [.get 1 8, .un 0 (.zext 32) 1, .const 2 0x0#64, .bin 8 .sub 0 2, .un 3 (.zext 32) 8, .const 9 0x0#64, .un 10 (.sext 32) 3, .bin 4 .slt 10 9, .bin 5 .eq 0 2, .bin 6 .ule 2 0, .bin 11 .xor 0 2, .bin 12 .xor 0 3, .bin 13 .and 11 12, .un 14 (.sext 32) 13, .bin 7 .slt 14 9, .setf 0 4, .setf 1 5, .setf 2 6, .setf 3 7], term := .jump 0x10074#64 }),
    (0x10074#64, { ops := [.getf 1 1, .const 2 0x0#64, .bin 0 .eq 1 2, .const 6 0x0#64, .un 5 (.zext 32) 6, .const 8 0x0#64, .const 9 0x1#64, .bin 10 .add 8 9, .un 7 (.zext 32) 10, .select 12 0 5 7, .set 0 12], term := .jump 0x10078#64 }),
    (0x10078#64, { ops := [.get 0 30], term := .jumpInd 0 }),
    (0x1007c#64, { ops := [.const 0 0x1#64, .set 0 0], term := .jump 0x10080#64 }),
    (0x10080#64, { ops := [.get 0 30], term := .jumpInd 0 })] }

/-- `equal_bytes_ct` is the lowering of `equal_bytes_ct_words`. -/
theorem equal_bytes_ct_lowered :
    equal_bytes_ct.blocks = Lowering.Arm.lowerWords 0x10050#64 equal_bytes_ct_words := by
  decide

end Examples.Mem.Arm
