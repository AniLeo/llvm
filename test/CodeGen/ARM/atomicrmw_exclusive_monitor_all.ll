; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py

; Test the instruction sequences produced by atomicrmw instructions. In
; particular, ensure there are no stores/spills inserted between the exclusive
; load and stores, which would invalidate the exclusive monitor.

; atomicrmw xchg for floating point types are not implemented yet, so the tests
; are commented.

; RUN: llc -O0 -o - %s | FileCheck %s --check-prefix=CHECK
target triple = "armv7-none-eabi"

@atomic_i8 = external global i8
@atomic_i16 = external global i16
@atomic_i32 = external global i32
@atomic_i64 = external global i64

@atomic_half = external global half
@atomic_float = external global float
@atomic_double = external global double

define i8 @test_xchg_i8() {
; CHECK-LABEL: test_xchg_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i8
; CHECK-NEXT:    movt r2, :upper16:atomic_i8
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB0_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexb r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov r1, r3
; CHECK-NEXT:    strexb r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB0_1
; CHECK-NEXT:    b .LBB0_2
; CHECK-NEXT:  .LBB0_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw xchg  i8* @atomic_i8, i8 1 monotonic
  ret i8 %0
}
define i8 @test_add_i8() {
; CHECK-LABEL: test_add_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i8
; CHECK-NEXT:    movt r2, :upper16:atomic_i8
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB1_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexb r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    add r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexb r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB1_1
; CHECK-NEXT:    b .LBB1_2
; CHECK-NEXT:  .LBB1_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw add  i8* @atomic_i8, i8 1 monotonic
  ret i8 %0
}
define i8 @test_sub_i8() {
; CHECK-LABEL: test_sub_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i8
; CHECK-NEXT:    movt r2, :upper16:atomic_i8
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB2_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexb r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    sub r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexb r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB2_1
; CHECK-NEXT:    b .LBB2_2
; CHECK-NEXT:  .LBB2_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw sub  i8* @atomic_i8, i8 1 monotonic
  ret i8 %0
}
define i8 @test_and_i8() {
; CHECK-LABEL: test_and_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i8
; CHECK-NEXT:    movt r2, :upper16:atomic_i8
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB3_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexb r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    and r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexb r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB3_1
; CHECK-NEXT:    b .LBB3_2
; CHECK-NEXT:  .LBB3_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw and  i8* @atomic_i8, i8 1 monotonic
  ret i8 %0
}
define i8 @test_nand_i8() {
; CHECK-LABEL: test_nand_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i8
; CHECK-NEXT:    movt r2, :upper16:atomic_i8
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB4_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexb r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    and r0, r0, r3
; CHECK-NEXT:    mvn r0, r0
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexb r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB4_1
; CHECK-NEXT:    b .LBB4_2
; CHECK-NEXT:  .LBB4_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw nand  i8* @atomic_i8, i8 1 monotonic
  ret i8 %0
}
define i8 @test_or_i8() {
; CHECK-LABEL: test_or_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i8
; CHECK-NEXT:    movt r2, :upper16:atomic_i8
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB5_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexb r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    orr r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexb r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB5_1
; CHECK-NEXT:    b .LBB5_2
; CHECK-NEXT:  .LBB5_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw or  i8* @atomic_i8, i8 1 monotonic
  ret i8 %0
}
define i8 @test_xor_i8() {
; CHECK-LABEL: test_xor_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i8
; CHECK-NEXT:    movt r2, :upper16:atomic_i8
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB6_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexb r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    eor r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexb r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB6_1
; CHECK-NEXT:    b .LBB6_2
; CHECK-NEXT:  .LBB6_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw xor  i8* @atomic_i8, i8 1 monotonic
  ret i8 %0
}
define i8 @test_max_i8() {
; CHECK-LABEL: test_max_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i8
; CHECK-NEXT:    movt r2, :upper16:atomic_i8
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB7_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexb r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    cmp r0, r3
; CHECK-NEXT:    movle r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexb r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB7_1
; CHECK-NEXT:    b .LBB7_2
; CHECK-NEXT:  .LBB7_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw max  i8* @atomic_i8, i8 1 monotonic
  ret i8 %0
}
define i8 @test_min_i8() {
; CHECK-LABEL: test_min_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i8
; CHECK-NEXT:    movt r2, :upper16:atomic_i8
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB8_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexb r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    cmp r0, r3
; CHECK-NEXT:    movge r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexb r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB8_1
; CHECK-NEXT:    b .LBB8_2
; CHECK-NEXT:  .LBB8_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw min  i8* @atomic_i8, i8 1 monotonic
  ret i8 %0
}
define i8 @test_umax_i8() {
; CHECK-LABEL: test_umax_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i8
; CHECK-NEXT:    movt r2, :upper16:atomic_i8
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB9_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexb r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    cmp r0, r3
; CHECK-NEXT:    movle r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexb r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB9_1
; CHECK-NEXT:    b .LBB9_2
; CHECK-NEXT:  .LBB9_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw umax  i8* @atomic_i8, i8 1 monotonic
  ret i8 %0
}
define i8 @test_umin_i8() {
; CHECK-LABEL: test_umin_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i8
; CHECK-NEXT:    movt r2, :upper16:atomic_i8
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB10_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexb r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    cmp r0, r3
; CHECK-NEXT:    movge r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexb r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB10_1
; CHECK-NEXT:    b .LBB10_2
; CHECK-NEXT:  .LBB10_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw umin  i8* @atomic_i8, i8 1 monotonic
  ret i8 %0
}


define i16 @test_xchg_i16() {
; CHECK-LABEL: test_xchg_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i16
; CHECK-NEXT:    movt r2, :upper16:atomic_i16
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB11_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov r1, r3
; CHECK-NEXT:    strexh r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB11_1
; CHECK-NEXT:    b .LBB11_2
; CHECK-NEXT:  .LBB11_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw xchg  i16* @atomic_i16, i16 1 monotonic
  ret i16 %0
}
define i16 @test_add_i16() {
; CHECK-LABEL: test_add_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i16
; CHECK-NEXT:    movt r2, :upper16:atomic_i16
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB12_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    add r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexh r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB12_1
; CHECK-NEXT:    b .LBB12_2
; CHECK-NEXT:  .LBB12_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw add  i16* @atomic_i16, i16 1 monotonic
  ret i16 %0
}
define i16 @test_sub_i16() {
; CHECK-LABEL: test_sub_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i16
; CHECK-NEXT:    movt r2, :upper16:atomic_i16
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB13_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    sub r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexh r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB13_1
; CHECK-NEXT:    b .LBB13_2
; CHECK-NEXT:  .LBB13_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw sub  i16* @atomic_i16, i16 1 monotonic
  ret i16 %0
}
define i16 @test_and_i16() {
; CHECK-LABEL: test_and_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i16
; CHECK-NEXT:    movt r2, :upper16:atomic_i16
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB14_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    and r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexh r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB14_1
; CHECK-NEXT:    b .LBB14_2
; CHECK-NEXT:  .LBB14_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw and  i16* @atomic_i16, i16 1 monotonic
  ret i16 %0
}
define i16 @test_nand_i16() {
; CHECK-LABEL: test_nand_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i16
; CHECK-NEXT:    movt r2, :upper16:atomic_i16
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB15_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    and r0, r0, r3
; CHECK-NEXT:    mvn r0, r0
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexh r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB15_1
; CHECK-NEXT:    b .LBB15_2
; CHECK-NEXT:  .LBB15_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw nand  i16* @atomic_i16, i16 1 monotonic
  ret i16 %0
}
define i16 @test_or_i16() {
; CHECK-LABEL: test_or_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i16
; CHECK-NEXT:    movt r2, :upper16:atomic_i16
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB16_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    orr r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexh r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB16_1
; CHECK-NEXT:    b .LBB16_2
; CHECK-NEXT:  .LBB16_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw or  i16* @atomic_i16, i16 1 monotonic
  ret i16 %0
}
define i16 @test_xor_i16() {
; CHECK-LABEL: test_xor_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i16
; CHECK-NEXT:    movt r2, :upper16:atomic_i16
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB17_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    eor r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexh r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB17_1
; CHECK-NEXT:    b .LBB17_2
; CHECK-NEXT:  .LBB17_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw xor  i16* @atomic_i16, i16 1 monotonic
  ret i16 %0
}
define i16 @test_max_i16() {
; CHECK-LABEL: test_max_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i16
; CHECK-NEXT:    movt r2, :upper16:atomic_i16
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB18_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    cmp r0, r3
; CHECK-NEXT:    movle r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexh r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB18_1
; CHECK-NEXT:    b .LBB18_2
; CHECK-NEXT:  .LBB18_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw max  i16* @atomic_i16, i16 1 monotonic
  ret i16 %0
}
define i16 @test_min_i16() {
; CHECK-LABEL: test_min_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i16
; CHECK-NEXT:    movt r2, :upper16:atomic_i16
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB19_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    cmp r0, r3
; CHECK-NEXT:    movge r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexh r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB19_1
; CHECK-NEXT:    b .LBB19_2
; CHECK-NEXT:  .LBB19_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw min  i16* @atomic_i16, i16 1 monotonic
  ret i16 %0
}
define i16 @test_umax_i16() {
; CHECK-LABEL: test_umax_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i16
; CHECK-NEXT:    movt r2, :upper16:atomic_i16
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB20_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    cmp r0, r3
; CHECK-NEXT:    movle r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexh r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB20_1
; CHECK-NEXT:    b .LBB20_2
; CHECK-NEXT:  .LBB20_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw umax  i16* @atomic_i16, i16 1 monotonic
  ret i16 %0
}
define i16 @test_umin_i16() {
; CHECK-LABEL: test_umin_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i16
; CHECK-NEXT:    movt r2, :upper16:atomic_i16
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB21_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    cmp r0, r3
; CHECK-NEXT:    movge r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strexh r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB21_1
; CHECK-NEXT:    b .LBB21_2
; CHECK-NEXT:  .LBB21_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw umin  i16* @atomic_i16, i16 1 monotonic
  ret i16 %0
}


define i32 @test_xchg_i32() {
; CHECK-LABEL: test_xchg_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i32
; CHECK-NEXT:    movt r2, :upper16:atomic_i32
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB22_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov r1, r3
; CHECK-NEXT:    strex r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB22_1
; CHECK-NEXT:    b .LBB22_2
; CHECK-NEXT:  .LBB22_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw xchg  i32* @atomic_i32, i32 1 monotonic
  ret i32 %0
}
define i32 @test_add_i32() {
; CHECK-LABEL: test_add_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i32
; CHECK-NEXT:    movt r2, :upper16:atomic_i32
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB23_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    add r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strex r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB23_1
; CHECK-NEXT:    b .LBB23_2
; CHECK-NEXT:  .LBB23_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw add  i32* @atomic_i32, i32 1 monotonic
  ret i32 %0
}
define i32 @test_sub_i32() {
; CHECK-LABEL: test_sub_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i32
; CHECK-NEXT:    movt r2, :upper16:atomic_i32
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB24_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    sub r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strex r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB24_1
; CHECK-NEXT:    b .LBB24_2
; CHECK-NEXT:  .LBB24_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw sub  i32* @atomic_i32, i32 1 monotonic
  ret i32 %0
}
define i32 @test_and_i32() {
; CHECK-LABEL: test_and_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i32
; CHECK-NEXT:    movt r2, :upper16:atomic_i32
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB25_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    and r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strex r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB25_1
; CHECK-NEXT:    b .LBB25_2
; CHECK-NEXT:  .LBB25_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw and  i32* @atomic_i32, i32 1 monotonic
  ret i32 %0
}
define i32 @test_nand_i32() {
; CHECK-LABEL: test_nand_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i32
; CHECK-NEXT:    movt r2, :upper16:atomic_i32
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB26_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    and r0, r0, r3
; CHECK-NEXT:    mvn r0, r0
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strex r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB26_1
; CHECK-NEXT:    b .LBB26_2
; CHECK-NEXT:  .LBB26_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw nand  i32* @atomic_i32, i32 1 monotonic
  ret i32 %0
}
define i32 @test_or_i32() {
; CHECK-LABEL: test_or_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i32
; CHECK-NEXT:    movt r2, :upper16:atomic_i32
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB27_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    orr r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strex r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB27_1
; CHECK-NEXT:    b .LBB27_2
; CHECK-NEXT:  .LBB27_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw or  i32* @atomic_i32, i32 1 monotonic
  ret i32 %0
}
define i32 @test_xor_i32() {
; CHECK-LABEL: test_xor_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i32
; CHECK-NEXT:    movt r2, :upper16:atomic_i32
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB28_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    eor r0, r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strex r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB28_1
; CHECK-NEXT:    b .LBB28_2
; CHECK-NEXT:  .LBB28_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw xor  i32* @atomic_i32, i32 1 monotonic
  ret i32 %0
}
define i32 @test_max_i32() {
; CHECK-LABEL: test_max_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i32
; CHECK-NEXT:    movt r2, :upper16:atomic_i32
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB29_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    cmp r0, r3
; CHECK-NEXT:    movle r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strex r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB29_1
; CHECK-NEXT:    b .LBB29_2
; CHECK-NEXT:  .LBB29_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw max  i32* @atomic_i32, i32 1 monotonic
  ret i32 %0
}
define i32 @test_min_i32() {
; CHECK-LABEL: test_min_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i32
; CHECK-NEXT:    movt r2, :upper16:atomic_i32
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB30_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    cmp r0, r3
; CHECK-NEXT:    movge r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strex r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB30_1
; CHECK-NEXT:    b .LBB30_2
; CHECK-NEXT:  .LBB30_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw min  i32* @atomic_i32, i32 1 monotonic
  ret i32 %0
}
define i32 @test_umax_i32() {
; CHECK-LABEL: test_umax_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i32
; CHECK-NEXT:    movt r2, :upper16:atomic_i32
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB31_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    cmp r0, r3
; CHECK-NEXT:    movle r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strex r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB31_1
; CHECK-NEXT:    b .LBB31_2
; CHECK-NEXT:  .LBB31_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw umax  i32* @atomic_i32, i32 1 monotonic
  ret i32 %0
}
define i32 @test_umin_i32() {
; CHECK-LABEL: test_umin_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_i32
; CHECK-NEXT:    movt r2, :upper16:atomic_i32
; CHECK-NEXT:    mov r3, #1
; CHECK-NEXT:  .LBB32_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r1, [r2]
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    cmp r0, r3
; CHECK-NEXT:    movge r0, r3
; CHECK-NEXT:    mov r1, r0
; CHECK-NEXT:    strex r1, r1, [r2]
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    bne .LBB32_1
; CHECK-NEXT:    b .LBB32_2
; CHECK-NEXT:  .LBB32_2: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw umin  i32* @atomic_i32, i32 1 monotonic
  ret i32 %0
}



define i64 @test_xchg_i64() {
; CHECK-LABEL: test_xchg_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r11, lr}
; CHECK-NEXT:    movw r0, :lower16:atomic_i64
; CHECK-NEXT:    movt r0, :upper16:atomic_i64
; CHECK-NEXT:    mov r2, #1
; CHECK-NEXT:    mov r3, #0
; CHECK-NEXT:    bl __sync_lock_test_and_set_8
; CHECK-NEXT:    pop {r11, pc}
entry:
  %0  = atomicrmw xchg  i64* @atomic_i64, i64 1 monotonic
  ret i64 %0
}
define i64 @test_add_i64() {
; CHECK-LABEL: test_add_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r11, lr}
; CHECK-NEXT:    movw r0, :lower16:atomic_i64
; CHECK-NEXT:    movt r0, :upper16:atomic_i64
; CHECK-NEXT:    mov r2, #1
; CHECK-NEXT:    mov r3, #0
; CHECK-NEXT:    bl __sync_fetch_and_add_8
; CHECK-NEXT:    pop {r11, pc}
entry:
  %0  = atomicrmw add  i64* @atomic_i64, i64 1 monotonic
  ret i64 %0
}
define i64 @test_sub_i64() {
; CHECK-LABEL: test_sub_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r11, lr}
; CHECK-NEXT:    movw r0, :lower16:atomic_i64
; CHECK-NEXT:    movt r0, :upper16:atomic_i64
; CHECK-NEXT:    mov r2, #1
; CHECK-NEXT:    mov r3, #0
; CHECK-NEXT:    bl __sync_fetch_and_sub_8
; CHECK-NEXT:    pop {r11, pc}
entry:
  %0  = atomicrmw sub  i64* @atomic_i64, i64 1 monotonic
  ret i64 %0
}
define i64 @test_and_i64() {
; CHECK-LABEL: test_and_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r11, lr}
; CHECK-NEXT:    movw r0, :lower16:atomic_i64
; CHECK-NEXT:    movt r0, :upper16:atomic_i64
; CHECK-NEXT:    mov r2, #1
; CHECK-NEXT:    mov r3, #0
; CHECK-NEXT:    bl __sync_fetch_and_and_8
; CHECK-NEXT:    pop {r11, pc}
entry:
  %0  = atomicrmw and  i64* @atomic_i64, i64 1 monotonic
  ret i64 %0
}
define i64 @test_nand_i64() {
; CHECK-LABEL: test_nand_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r11, lr}
; CHECK-NEXT:    movw r0, :lower16:atomic_i64
; CHECK-NEXT:    movt r0, :upper16:atomic_i64
; CHECK-NEXT:    mov r2, #1
; CHECK-NEXT:    mov r3, #0
; CHECK-NEXT:    bl __sync_fetch_and_nand_8
; CHECK-NEXT:    pop {r11, pc}
entry:
  %0  = atomicrmw nand  i64* @atomic_i64, i64 1 monotonic
  ret i64 %0
}
define i64 @test_or_i64() {
; CHECK-LABEL: test_or_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r11, lr}
; CHECK-NEXT:    movw r0, :lower16:atomic_i64
; CHECK-NEXT:    movt r0, :upper16:atomic_i64
; CHECK-NEXT:    mov r2, #1
; CHECK-NEXT:    mov r3, #0
; CHECK-NEXT:    bl __sync_fetch_and_or_8
; CHECK-NEXT:    pop {r11, pc}
entry:
  %0  = atomicrmw or  i64* @atomic_i64, i64 1 monotonic
  ret i64 %0
}
define i64 @test_xor_i64() {
; CHECK-LABEL: test_xor_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r11, lr}
; CHECK-NEXT:    movw r0, :lower16:atomic_i64
; CHECK-NEXT:    movt r0, :upper16:atomic_i64
; CHECK-NEXT:    mov r2, #1
; CHECK-NEXT:    mov r3, #0
; CHECK-NEXT:    bl __sync_fetch_and_xor_8
; CHECK-NEXT:    pop {r11, pc}
entry:
  %0  = atomicrmw xor  i64* @atomic_i64, i64 1 monotonic
  ret i64 %0
}


; ; Test floats
; define half @test_xchg_half() {
; entry:
;   %0  = atomicrmw xchg half* @atomic_half, half 1.0 monotonic
;   ret half %0
; }
define half @test_fadd_half() {
; CHECK-LABEL: test_fadd_half:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r11, lr}
; CHECK-NEXT:    movw r1, :lower16:atomic_half
; CHECK-NEXT:    movt r1, :upper16:atomic_half
; CHECK-NEXT:    vmov.f32 s2, #1.000000e+00
; CHECK-NEXT:  .LBB40_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r0, [r1]
; CHECK-NEXT:    vmov s0, r0
; CHECK-NEXT:    vadd.f32 s0, s0, s2
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    strexh r0, r0, [r1]
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    bne .LBB40_1
; CHECK-NEXT:    b .LBB40_2
; CHECK-NEXT:  .LBB40_2: @ %entry
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bl __gnu_f2h_ieee
; CHECK-NEXT:    pop {r11, pc}
entry:
  %0  = atomicrmw fadd half* @atomic_half, half 1.0 monotonic
  ret half %0
}
define half @test_fsub_half() {
; CHECK-LABEL: test_fsub_half:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r11, lr}
; CHECK-NEXT:    movw r1, :lower16:atomic_half
; CHECK-NEXT:    movt r1, :upper16:atomic_half
; CHECK-NEXT:    vmov.f32 s2, #1.000000e+00
; CHECK-NEXT:  .LBB41_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexh r0, [r1]
; CHECK-NEXT:    vmov s0, r0
; CHECK-NEXT:    vsub.f32 s0, s0, s2
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    strexh r0, r0, [r1]
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    bne .LBB41_1
; CHECK-NEXT:    b .LBB41_2
; CHECK-NEXT:  .LBB41_2: @ %entry
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bl __gnu_f2h_ieee
; CHECK-NEXT:    pop {r11, pc}
entry:
  %0  = atomicrmw fsub half* @atomic_half, half 1.0 monotonic
  ret half %0
}
; define float @test_xchg_float() {
; entry:
;   %0  = atomicrmw xchg float* @atomic_float, float 1.0 monotonic
;   ret float %0
; }
define float @test_fadd_float() {
; CHECK-LABEL: test_fadd_float:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r1, :lower16:atomic_float
; CHECK-NEXT:    movt r1, :upper16:atomic_float
; CHECK-NEXT:    vmov.f32 s2, #1.000000e+00
; CHECK-NEXT:  .LBB42_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r0, [r1]
; CHECK-NEXT:    vmov s0, r0
; CHECK-NEXT:    vadd.f32 s0, s0, s2
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    strex r0, r0, [r1]
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    bne .LBB42_1
; CHECK-NEXT:    b .LBB42_2
; CHECK-NEXT:  .LBB42_2: @ %entry
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw fadd float* @atomic_float, float 1.0 monotonic
  ret float %0
}
define float @test_fsub_float() {
; CHECK-LABEL: test_fsub_float:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r1, :lower16:atomic_float
; CHECK-NEXT:    movt r1, :upper16:atomic_float
; CHECK-NEXT:    vmov.f32 s2, #1.000000e+00
; CHECK-NEXT:  .LBB43_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrex r0, [r1]
; CHECK-NEXT:    vmov s0, r0
; CHECK-NEXT:    vsub.f32 s0, s0, s2
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    strex r0, r0, [r1]
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    bne .LBB43_1
; CHECK-NEXT:    b .LBB43_2
; CHECK-NEXT:  .LBB43_2: @ %entry
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw fsub float* @atomic_float, float 1.0 monotonic
  ret float %0
}
; define double @test_xchg_double() {
; entry:
;   %0  = atomicrmw xchg double* @atomic_double, double 1.0 monotonic
;   ret double %0
; }
define double @test_fadd_double() {
; CHECK-LABEL: test_fadd_double:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_double
; CHECK-NEXT:    movt r2, :upper16:atomic_double
; CHECK-NEXT:    vmov.f64 d17, #1.000000e+00
; CHECK-NEXT:  .LBB44_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexd r0, r1, [r2]
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vadd.f64 d16, d16, d17
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    strexd r0, r0, r1, [r2]
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    bne .LBB44_1
; CHECK-NEXT:    b .LBB44_2
; CHECK-NEXT:  .LBB44_2: @ %entry
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw fadd double* @atomic_double, double 1.0 monotonic
  ret double %0
}
define double @test_fsub_double() {
; CHECK-LABEL: test_fsub_double:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, :lower16:atomic_double
; CHECK-NEXT:    movt r2, :upper16:atomic_double
; CHECK-NEXT:    vmov.f64 d17, #1.000000e+00
; CHECK-NEXT:  .LBB45_1: @ %entry
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrexd r0, r1, [r2]
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vsub.f64 d16, d16, d17
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    strexd r0, r0, r1, [r2]
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    bne .LBB45_1
; CHECK-NEXT:    b .LBB45_2
; CHECK-NEXT:  .LBB45_2: @ %entry
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    bx lr
entry:
  %0  = atomicrmw fsub double* @atomic_double, double 1.0 monotonic
  ret double %0
}
