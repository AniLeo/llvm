; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32  < %s | FileCheck  %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64  < %s | FileCheck  %s --check-prefixes=CHECK,RV64

%struct.S = type { [40 x i32], i32, i32, i32, [4100 x i32], i32, i32, i32 }
@s = common dso_local global %struct.S zeroinitializer, align 4
@foo = global [6 x i16] [i16 1, i16 2, i16 3, i16 4, i16 5, i16 0], align 2
@g = global [1048576 x i8] zeroinitializer, align 1
@bar = external global [0 x i8], align 1


define dso_local void @multiple_stores() local_unnamed_addr nounwind {
; CHECK-LABEL: multiple_stores:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lui a0, %hi(s)
; CHECK-NEXT:    addi a0, a0, %lo(s)
; CHECK-NEXT:    li a1, 10
; CHECK-NEXT:    sw a1, 160(a0)
; CHECK-NEXT:    li a1, 20
; CHECK-NEXT:    sw a1, 164(a0)
; CHECK-NEXT:    ret
entry:
  store i32 10, i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 1), align 4
  store i32 20, i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 2), align 4
  ret void
}

define dso_local void @control_flow_with_mem_access() local_unnamed_addr nounwind {
; CHECK-LABEL: control_flow_with_mem_access:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lui a0, %hi(s)
; CHECK-NEXT:    addi a0, a0, %lo(s)
; CHECK-NEXT:    lw a1, 164(a0)
; CHECK-NEXT:    blez a1, .LBB1_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    li a1, 10
; CHECK-NEXT:    sw a1, 160(a0)
; CHECK-NEXT:  .LBB1_2: # %if.end
; CHECK-NEXT:    ret
entry:
  %0 = load i32, i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 2), align 4
  %cmp = icmp sgt i32 %0, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 10, i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 1), align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

; This test checks that the offset is reconstructed correctly when
; "addi" of the big offset has a negative immediate.
; without peephole this generates:
; lui  a1, %hi(g)
; addi a1, a0, %lo(g)
; lui  a0, 18     ---> offset
; addi a0, a0, -160
; add  a0, a0, a1  ---> base + offset.
define i8* @big_offset_neg_addi() nounwind {
; CHECK-LABEL: big_offset_neg_addi:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, %hi(g+73568)
; CHECK-NEXT:    addi a0, a0, %lo(g+73568)
; CHECK-NEXT:    ret
  ret i8* getelementptr inbounds ([1048576 x i8], [1048576 x i8]* @g, i32 0, i32 73568)
}

; This test checks for the case where the offset is only an LUI.
; without peephole this generates:
; lui  a0, %hi(g)
; addi a0, a0, %lo(g)
; lui  a1, 128     ---> offset
; add  a0, a0, a1  ---> base + offset.
define i8* @big_offset_lui_tail() nounwind {
; CHECK-LABEL: big_offset_lui_tail:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, %hi(g+524288)
; CHECK-NEXT:    addi a0, a0, %lo(g+524288)
; CHECK-NEXT:    ret
  ret i8* getelementptr inbounds ([1048576 x i8], [1048576 x i8]* @g, i32 0, i32 524288)
}

define i8* @big_offset_neg_lui_tail() {
; CHECK-LABEL: big_offset_neg_lui_tail:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, %hi(bar-8192)
; CHECK-NEXT:    addi a0, a0, %lo(bar-8192)
; CHECK-NEXT:    ret
  ret i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bar, i32 0, i32 -8192)
}

define dso_local i32* @big_offset_one_use() local_unnamed_addr nounwind {
; CHECK-LABEL: big_offset_one_use:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lui a0, %hi(s+16572)
; CHECK-NEXT:    addi a0, a0, %lo(s+16572)
; CHECK-NEXT:    ret
entry:
  ret i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 5)
}

define dso_local i32* @small_offset_one_use() local_unnamed_addr nounwind {
; CHECK-LABEL: small_offset_one_use:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lui a0, %hi(s+160)
; CHECK-NEXT:    addi a0, a0, %lo(s+160)
; CHECK-NEXT:    ret
entry:
  ret i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 1)
}

define dso_local i32* @control_flow_no_mem(i32 %n) local_unnamed_addr nounwind {
; CHECK-LABEL: control_flow_no_mem:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lui a0, %hi(s)
; CHECK-NEXT:    addi a0, a0, %lo(s)
; CHECK-NEXT:    lw a1, 164(a0)
; CHECK-NEXT:    beqz a1, .LBB7_2
; CHECK-NEXT:  # %bb.1: # %if.end
; CHECK-NEXT:    addi a0, a0, 168
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB7_2: # %if.then
; CHECK-NEXT:    addi a0, a0, 160
; CHECK-NEXT:    ret
entry:
  %0 = load i32, i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 2), align 4
  %cmp = icmp eq i32 %0, 0
  br i1 %cmp, label %if.then, label %if.end
if.then:                                          ; preds = %entry
  ret i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 1)
if.end:                                           ; preds = %if.then, %entry
  ret i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 3)
}

define dso_local i32 @load_half() nounwind {
; RV32-LABEL: load_half:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    lui a0, %hi(foo+8)
; RV32-NEXT:    lhu a0, %lo(foo+8)(a0)
; RV32-NEXT:    li a1, 140
; RV32-NEXT:    bne a0, a1, .LBB8_2
; RV32-NEXT:  # %bb.1: # %if.end
; RV32-NEXT:    li a0, 0
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
; RV32-NEXT:  .LBB8_2: # %if.then
; RV32-NEXT:    call abort@plt
;
; RV64-LABEL: load_half:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-NEXT:    lui a0, %hi(foo+8)
; RV64-NEXT:    lhu a0, %lo(foo+8)(a0)
; RV64-NEXT:    li a1, 140
; RV64-NEXT:    bne a0, a1, .LBB8_2
; RV64-NEXT:  # %bb.1: # %if.end
; RV64-NEXT:    li a0, 0
; RV64-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
; RV64-NEXT:  .LBB8_2: # %if.then
; RV64-NEXT:    call abort@plt
entry:
  %0 = load i16, i16* getelementptr inbounds ([6 x i16], [6 x i16]* @foo, i32 0, i32 4), align 2
  %cmp = icmp eq i16 %0, 140
  br i1 %cmp, label %if.end, label %if.then

if.then:
  tail call void @abort()
  unreachable

if.end:
  ret i32 0
}

declare void @abort()

define dso_local void @one_store() local_unnamed_addr nounwind {
; CHECK-LABEL: one_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lui a0, %hi(s+160)
; CHECK-NEXT:    li a1, 10
; CHECK-NEXT:    sw a1, %lo(s+160)(a0)
; CHECK-NEXT:    ret
entry:
  store i32 10, i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 1), align 4
  ret void
}

define i8* @neg_offset() {
; CHECK-LABEL: neg_offset:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, %hi(bar-8191)
; CHECK-NEXT:    addi a0, a0, %lo(bar-8191)
; CHECK-NEXT:    ret
    ret i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bar, i32 0, i32 -8191)
}

; This uses an LUI+ADDI on RV64 that does not produce a simm32. For RV32, we'll
; truncate the offset.
define i8* @neg_offset_not_simm32() {
; RV32-LABEL: neg_offset_not_simm32:
; RV32:       # %bb.0:
; RV32-NEXT:    lui a0, %hi(bar+2147482283)
; RV32-NEXT:    addi a0, a0, %lo(bar+2147482283)
; RV32-NEXT:    ret
;
; RV64-LABEL: neg_offset_not_simm32:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a0, %hi(bar)
; RV64-NEXT:    addi a0, a0, %lo(bar)
; RV64-NEXT:    lui a1, 524288
; RV64-NEXT:    addi a1, a1, -1365
; RV64-NEXT:    add a0, a0, a1
; RV64-NEXT:    ret
    ret i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bar, i32 0, i64 -2147485013)
}
