; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv6 < %s | FileCheck %s --check-prefixes=ARM,ARM6
; RUN: llc -mtriple=armv7 < %s | FileCheck %s --check-prefixes=ARM,ARM78
; RUN: llc -mtriple=armv8a < %s | FileCheck %s --check-prefixes=ARM,ARM78
; RUN: llc -mtriple=thumbv6 < %s | FileCheck %s --check-prefixes=THUMB,THUMB6
; RUN: llc -mtriple=thumbv7 < %s | FileCheck %s --check-prefixes=THUMB,THUMB78
; RUN: llc -mtriple=thumbv8-eabi < %s | FileCheck %s --check-prefixes=THUMB,THUMB78

; We are looking for the following pattern here:
;   (X & (C l>> Y)) ==/!= 0
; It may be optimal to hoist the constant:
;   ((X << Y) & C) ==/!= 0

;------------------------------------------------------------------------------;
; A few scalar test
;------------------------------------------------------------------------------;

; i8 scalar

define i1 @scalar_i8_signbit_eq(i8 %x, i8 %y) nounwind {
; ARM-LABEL: scalar_i8_signbit_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxtb r1, r1
; ARM-NEXT:    lsl r0, r0, r1
; ARM-NEXT:    mov r1, #1
; ARM-NEXT:    uxtb r0, r0
; ARM-NEXT:    eor r0, r1, r0, lsr #7
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i8_signbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxtb r1, r1
; THUMB6-NEXT:    lsls r0, r1
; THUMB6-NEXT:    movs r1, #128
; THUMB6-NEXT:    ands r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i8_signbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxtb r1, r1
; THUMB78-NEXT:    lsls r0, r1
; THUMB78-NEXT:    movs r1, #1
; THUMB78-NEXT:    uxtb r0, r0
; THUMB78-NEXT:    eor.w r0, r1, r0, lsr #7
; THUMB78-NEXT:    bx lr
  %t0 = lshr i8 128, %y
  %t1 = and i8 %t0, %x
  %res = icmp eq i8 %t1, 0
  ret i1 %res
}

define i1 @scalar_i8_lowestbit_eq(i8 %x, i8 %y) nounwind {
; ARM-LABEL: scalar_i8_lowestbit_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxtb r1, r1
; ARM-NEXT:    mov r2, #1
; ARM-NEXT:    bic r0, r2, r0, lsl r1
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i8_lowestbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxtb r1, r1
; THUMB6-NEXT:    lsls r0, r1
; THUMB6-NEXT:    movs r1, #1
; THUMB6-NEXT:    ands r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i8_lowestbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxtb r1, r1
; THUMB78-NEXT:    lsls r0, r1
; THUMB78-NEXT:    movs r1, #1
; THUMB78-NEXT:    bic.w r0, r1, r0
; THUMB78-NEXT:    bx lr
  %t0 = lshr i8 1, %y
  %t1 = and i8 %t0, %x
  %res = icmp eq i8 %t1, 0
  ret i1 %res
}

define i1 @scalar_i8_bitsinmiddle_eq(i8 %x, i8 %y) nounwind {
; ARM-LABEL: scalar_i8_bitsinmiddle_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxtb r1, r1
; ARM-NEXT:    mov r2, #24
; ARM-NEXT:    and r0, r2, r0, lsl r1
; ARM-NEXT:    clz r0, r0
; ARM-NEXT:    lsr r0, r0, #5
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i8_bitsinmiddle_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxtb r1, r1
; THUMB6-NEXT:    lsls r0, r1
; THUMB6-NEXT:    movs r1, #24
; THUMB6-NEXT:    ands r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i8_bitsinmiddle_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxtb r1, r1
; THUMB78-NEXT:    lsls r0, r1
; THUMB78-NEXT:    and r0, r0, #24
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = lshr i8 24, %y
  %t1 = and i8 %t0, %x
  %res = icmp eq i8 %t1, 0
  ret i1 %res
}

; i16 scalar

define i1 @scalar_i16_signbit_eq(i16 %x, i16 %y) nounwind {
; ARM-LABEL: scalar_i16_signbit_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxth r1, r1
; ARM-NEXT:    lsl r0, r0, r1
; ARM-NEXT:    mov r1, #1
; ARM-NEXT:    uxth r0, r0
; ARM-NEXT:    eor r0, r1, r0, lsr #15
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i16_signbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxth r1, r1
; THUMB6-NEXT:    lsls r0, r1
; THUMB6-NEXT:    movs r1, #1
; THUMB6-NEXT:    lsls r1, r1, #15
; THUMB6-NEXT:    ands r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i16_signbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxth r1, r1
; THUMB78-NEXT:    lsls r0, r1
; THUMB78-NEXT:    movs r1, #1
; THUMB78-NEXT:    uxth r0, r0
; THUMB78-NEXT:    eor.w r0, r1, r0, lsr #15
; THUMB78-NEXT:    bx lr
  %t0 = lshr i16 32768, %y
  %t1 = and i16 %t0, %x
  %res = icmp eq i16 %t1, 0
  ret i1 %res
}

define i1 @scalar_i16_lowestbit_eq(i16 %x, i16 %y) nounwind {
; ARM-LABEL: scalar_i16_lowestbit_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxth r1, r1
; ARM-NEXT:    mov r2, #1
; ARM-NEXT:    bic r0, r2, r0, lsl r1
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i16_lowestbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxth r1, r1
; THUMB6-NEXT:    lsls r0, r1
; THUMB6-NEXT:    movs r1, #1
; THUMB6-NEXT:    ands r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i16_lowestbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxth r1, r1
; THUMB78-NEXT:    lsls r0, r1
; THUMB78-NEXT:    movs r1, #1
; THUMB78-NEXT:    bic.w r0, r1, r0
; THUMB78-NEXT:    bx lr
  %t0 = lshr i16 1, %y
  %t1 = and i16 %t0, %x
  %res = icmp eq i16 %t1, 0
  ret i1 %res
}

define i1 @scalar_i16_bitsinmiddle_eq(i16 %x, i16 %y) nounwind {
; ARM-LABEL: scalar_i16_bitsinmiddle_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxth r1, r1
; ARM-NEXT:    mov r2, #4080
; ARM-NEXT:    and r0, r2, r0, lsl r1
; ARM-NEXT:    clz r0, r0
; ARM-NEXT:    lsr r0, r0, #5
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i16_bitsinmiddle_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxth r1, r1
; THUMB6-NEXT:    lsls r0, r1
; THUMB6-NEXT:    movs r1, #255
; THUMB6-NEXT:    lsls r1, r1, #4
; THUMB6-NEXT:    ands r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i16_bitsinmiddle_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxth r1, r1
; THUMB78-NEXT:    lsls r0, r1
; THUMB78-NEXT:    and r0, r0, #4080
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = lshr i16 4080, %y
  %t1 = and i16 %t0, %x
  %res = icmp eq i16 %t1, 0
  ret i1 %res
}

; i32 scalar

define i1 @scalar_i32_signbit_eq(i32 %x, i32 %y) nounwind {
; ARM-LABEL: scalar_i32_signbit_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    mvn r0, r0, lsl r1
; ARM-NEXT:    lsr r0, r0, #31
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i32_signbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    lsls r0, r1
; THUMB6-NEXT:    movs r1, #1
; THUMB6-NEXT:    lsls r1, r1, #31
; THUMB6-NEXT:    ands r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i32_signbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    lsls r0, r1
; THUMB78-NEXT:    mvns r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #31
; THUMB78-NEXT:    bx lr
  %t0 = lshr i32 2147483648, %y
  %t1 = and i32 %t0, %x
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}

define i1 @scalar_i32_lowestbit_eq(i32 %x, i32 %y) nounwind {
; ARM-LABEL: scalar_i32_lowestbit_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    mov r2, #1
; ARM-NEXT:    bic r0, r2, r0, lsl r1
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i32_lowestbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    lsls r0, r1
; THUMB6-NEXT:    movs r1, #1
; THUMB6-NEXT:    ands r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i32_lowestbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    lsls r0, r1
; THUMB78-NEXT:    movs r1, #1
; THUMB78-NEXT:    bic.w r0, r1, r0
; THUMB78-NEXT:    bx lr
  %t0 = lshr i32 1, %y
  %t1 = and i32 %t0, %x
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}

define i1 @scalar_i32_bitsinmiddle_eq(i32 %x, i32 %y) nounwind {
; ARM6-LABEL: scalar_i32_bitsinmiddle_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    mov r2, #65280
; ARM6-NEXT:    orr r2, r2, #16711680
; ARM6-NEXT:    and r0, r2, r0, lsl r1
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    lsr r0, r0, #5
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: scalar_i32_bitsinmiddle_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    movw r2, #65280
; ARM78-NEXT:    movt r2, #255
; ARM78-NEXT:    and r0, r2, r0, lsl r1
; ARM78-NEXT:    clz r0, r0
; ARM78-NEXT:    lsr r0, r0, #5
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i32_bitsinmiddle_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    lsls r0, r1
; THUMB6-NEXT:    ldr r1, .LCPI8_0
; THUMB6-NEXT:    ands r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
; THUMB6-NEXT:    .p2align 2
; THUMB6-NEXT:  @ %bb.1:
; THUMB6-NEXT:  .LCPI8_0:
; THUMB6-NEXT:    .long 16776960 @ 0xffff00
;
; THUMB78-LABEL: scalar_i32_bitsinmiddle_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    lsls r0, r1
; THUMB78-NEXT:    movw r1, #65280
; THUMB78-NEXT:    movt r1, #255
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = lshr i32 16776960, %y
  %t1 = and i32 %t0, %x
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}

; i64 scalar

define i1 @scalar_i64_signbit_eq(i64 %x, i64 %y) nounwind {
; ARM-LABEL: scalar_i64_signbit_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    rsb r3, r2, #32
; ARM-NEXT:    lsr r3, r0, r3
; ARM-NEXT:    orr r1, r3, r1, lsl r2
; ARM-NEXT:    subs r2, r2, #32
; ARM-NEXT:    lslpl r1, r0, r2
; ARM-NEXT:    mvn r0, r1
; ARM-NEXT:    lsr r0, r0, #31
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i64_signbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r7, lr}
; THUMB6-NEXT:    bl __ashldi3
; THUMB6-NEXT:    movs r0, #1
; THUMB6-NEXT:    lsls r2, r0, #31
; THUMB6-NEXT:    ands r2, r1
; THUMB6-NEXT:    rsbs r0, r2, #0
; THUMB6-NEXT:    adcs r0, r2
; THUMB6-NEXT:    pop {r7, pc}
;
; THUMB78-LABEL: scalar_i64_signbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    rsb.w r3, r2, #32
; THUMB78-NEXT:    lsls r1, r2
; THUMB78-NEXT:    subs r2, #32
; THUMB78-NEXT:    lsr.w r3, r0, r3
; THUMB78-NEXT:    orr.w r1, r1, r3
; THUMB78-NEXT:    it pl
; THUMB78-NEXT:    lslpl.w r1, r0, r2
; THUMB78-NEXT:    mvns r0, r1
; THUMB78-NEXT:    lsrs r0, r0, #31
; THUMB78-NEXT:    bx lr
  %t0 = lshr i64 9223372036854775808, %y
  %t1 = and i64 %t0, %x
  %res = icmp eq i64 %t1, 0
  ret i1 %res
}

define i1 @scalar_i64_lowestbit_eq(i64 %x, i64 %y) nounwind {
; ARM6-LABEL: scalar_i64_lowestbit_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    subs r1, r2, #32
; ARM6-NEXT:    lsl r0, r0, r2
; ARM6-NEXT:    movpl r0, #0
; ARM6-NEXT:    mov r1, #1
; ARM6-NEXT:    bic r0, r1, r0
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: scalar_i64_lowestbit_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    subs r1, r2, #32
; ARM78-NEXT:    lsl r0, r0, r2
; ARM78-NEXT:    movwpl r0, #0
; ARM78-NEXT:    mov r1, #1
; ARM78-NEXT:    bic r0, r1, r0
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i64_lowestbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r7, lr}
; THUMB6-NEXT:    bl __ashldi3
; THUMB6-NEXT:    movs r1, #1
; THUMB6-NEXT:    ands r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    pop {r7, pc}
;
; THUMB78-LABEL: scalar_i64_lowestbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    lsls r0, r2
; THUMB78-NEXT:    subs.w r1, r2, #32
; THUMB78-NEXT:    it pl
; THUMB78-NEXT:    movpl r0, #0
; THUMB78-NEXT:    movs r1, #1
; THUMB78-NEXT:    bic.w r0, r1, r0
; THUMB78-NEXT:    bx lr
  %t0 = lshr i64 1, %y
  %t1 = and i64 %t0, %x
  %res = icmp eq i64 %t1, 0
  ret i1 %res
}

define i1 @scalar_i64_bitsinmiddle_eq(i64 %x, i64 %y) nounwind {
; ARM6-LABEL: scalar_i64_bitsinmiddle_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    rsb r3, r2, #32
; ARM6-NEXT:    lsr r3, r0, r3
; ARM6-NEXT:    orr r1, r3, r1, lsl r2
; ARM6-NEXT:    subs r3, r2, #32
; ARM6-NEXT:    lslpl r1, r0, r3
; ARM6-NEXT:    lsl r0, r0, r2
; ARM6-NEXT:    movpl r0, #0
; ARM6-NEXT:    pkhbt r0, r1, r0
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    lsr r0, r0, #5
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: scalar_i64_bitsinmiddle_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    rsb r3, r2, #32
; ARM78-NEXT:    lsr r3, r0, r3
; ARM78-NEXT:    orr r1, r3, r1, lsl r2
; ARM78-NEXT:    subs r3, r2, #32
; ARM78-NEXT:    lslpl r1, r0, r3
; ARM78-NEXT:    lsl r0, r0, r2
; ARM78-NEXT:    movwpl r0, #0
; ARM78-NEXT:    pkhbt r0, r1, r0
; ARM78-NEXT:    clz r0, r0
; ARM78-NEXT:    lsr r0, r0, #5
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i64_bitsinmiddle_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r7, lr}
; THUMB6-NEXT:    bl __ashldi3
; THUMB6-NEXT:    ldr r2, .LCPI11_0
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    uxth r0, r1
; THUMB6-NEXT:    adds r1, r2, r0
; THUMB6-NEXT:    rsbs r0, r1, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    pop {r7, pc}
; THUMB6-NEXT:    .p2align 2
; THUMB6-NEXT:  @ %bb.1:
; THUMB6-NEXT:  .LCPI11_0:
; THUMB6-NEXT:    .long 4294901760 @ 0xffff0000
;
; THUMB78-LABEL: scalar_i64_bitsinmiddle_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    rsb.w r3, r2, #32
; THUMB78-NEXT:    lsls r1, r2
; THUMB78-NEXT:    lsr.w r3, r0, r3
; THUMB78-NEXT:    orrs r1, r3
; THUMB78-NEXT:    subs.w r3, r2, #32
; THUMB78-NEXT:    it pl
; THUMB78-NEXT:    lslpl.w r1, r0, r3
; THUMB78-NEXT:    lsl.w r0, r0, r2
; THUMB78-NEXT:    it pl
; THUMB78-NEXT:    movpl r0, #0
; THUMB78-NEXT:    pkhbt r0, r1, r0
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = lshr i64 281474976645120, %y
  %t1 = and i64 %t0, %x
  %res = icmp eq i64 %t1, 0
  ret i1 %res
}

;------------------------------------------------------------------------------;
; A few trivial vector tests
;------------------------------------------------------------------------------;

define <4 x i1> @vec_4xi32_splat_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; ARM6-LABEL: vec_4xi32_splat_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    push {r11, lr}
; ARM6-NEXT:    ldr r12, [sp, #8]
; ARM6-NEXT:    mov lr, #1
; ARM6-NEXT:    bic r0, lr, r0, lsl r12
; ARM6-NEXT:    ldr r12, [sp, #12]
; ARM6-NEXT:    bic r1, lr, r1, lsl r12
; ARM6-NEXT:    ldr r12, [sp, #16]
; ARM6-NEXT:    bic r2, lr, r2, lsl r12
; ARM6-NEXT:    ldr r12, [sp, #20]
; ARM6-NEXT:    bic r3, lr, r3, lsl r12
; ARM6-NEXT:    pop {r11, pc}
;
; ARM78-LABEL: vec_4xi32_splat_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    vmov d17, r2, r3
; ARM78-NEXT:    mov r12, sp
; ARM78-NEXT:    vld1.64 {d18, d19}, [r12]
; ARM78-NEXT:    vmov d16, r0, r1
; ARM78-NEXT:    vmov.i32 q10, #0x1
; ARM78-NEXT:    vshl.u32 q8, q8, q9
; ARM78-NEXT:    vtst.32 q8, q8, q10
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vmovn.i32 d16, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: vec_4xi32_splat_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, r5, r7, lr}
; THUMB6-NEXT:    ldr r4, [sp, #16]
; THUMB6-NEXT:    lsls r0, r4
; THUMB6-NEXT:    movs r4, #1
; THUMB6-NEXT:    ands r0, r4
; THUMB6-NEXT:    rsbs r5, r0, #0
; THUMB6-NEXT:    adcs r0, r5
; THUMB6-NEXT:    ldr r5, [sp, #20]
; THUMB6-NEXT:    lsls r1, r5
; THUMB6-NEXT:    ands r1, r4
; THUMB6-NEXT:    rsbs r5, r1, #0
; THUMB6-NEXT:    adcs r1, r5
; THUMB6-NEXT:    ldr r5, [sp, #24]
; THUMB6-NEXT:    lsls r2, r5
; THUMB6-NEXT:    ands r2, r4
; THUMB6-NEXT:    rsbs r5, r2, #0
; THUMB6-NEXT:    adcs r2, r5
; THUMB6-NEXT:    ldr r5, [sp, #28]
; THUMB6-NEXT:    lsls r3, r5
; THUMB6-NEXT:    ands r3, r4
; THUMB6-NEXT:    rsbs r4, r3, #0
; THUMB6-NEXT:    adcs r3, r4
; THUMB6-NEXT:    pop {r4, r5, r7, pc}
;
; THUMB78-LABEL: vec_4xi32_splat_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    vmov d17, r2, r3
; THUMB78-NEXT:    mov r12, sp
; THUMB78-NEXT:    vld1.64 {d18, d19}, [r12]
; THUMB78-NEXT:    vmov d16, r0, r1
; THUMB78-NEXT:    vmov.i32 q10, #0x1
; THUMB78-NEXT:    vshl.u32 q8, q8, q9
; THUMB78-NEXT:    vtst.32 q8, q8, q10
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vmovn.i32 d16, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    bx lr
  %t0 = lshr <4 x i32> <i32 1, i32 1, i32 1, i32 1>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %res
}

define <4 x i1> @vec_4xi32_nonsplat_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; ARM6-LABEL: vec_4xi32_nonsplat_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    ldr r12, [sp, #4]
; ARM6-NEXT:    mov r0, #1
; ARM6-NEXT:    bic r1, r0, r1, lsl r12
; ARM6-NEXT:    ldr r12, [sp, #8]
; ARM6-NEXT:    mov r0, #65280
; ARM6-NEXT:    orr r0, r0, #16711680
; ARM6-NEXT:    and r0, r0, r2, lsl r12
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    lsr r2, r0, #5
; ARM6-NEXT:    ldr r0, [sp, #12]
; ARM6-NEXT:    mvn r0, r3, lsl r0
; ARM6-NEXT:    lsr r3, r0, #31
; ARM6-NEXT:    mov r0, #1
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: vec_4xi32_nonsplat_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    mov r12, sp
; ARM78-NEXT:    vld1.64 {d16, d17}, [r12]
; ARM78-NEXT:    adr r12, .LCPI13_0
; ARM78-NEXT:    vneg.s32 q8, q8
; ARM78-NEXT:    vld1.64 {d18, d19}, [r12:128]
; ARM78-NEXT:    vshl.u32 q8, q9, q8
; ARM78-NEXT:    vmov d19, r2, r3
; ARM78-NEXT:    vmov d18, r0, r1
; ARM78-NEXT:    vtst.32 q8, q8, q9
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vmovn.i32 d16, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    bx lr
; ARM78-NEXT:    .p2align 4
; ARM78-NEXT:  @ %bb.1:
; ARM78-NEXT:  .LCPI13_0:
; ARM78-NEXT:    .long 0 @ 0x0
; ARM78-NEXT:    .long 1 @ 0x1
; ARM78-NEXT:    .long 16776960 @ 0xffff00
; ARM78-NEXT:    .long 2147483648 @ 0x80000000
;
; THUMB6-LABEL: vec_4xi32_nonsplat_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, lr}
; THUMB6-NEXT:    ldr r0, [sp, #12]
; THUMB6-NEXT:    lsls r1, r0
; THUMB6-NEXT:    movs r0, #1
; THUMB6-NEXT:    ands r1, r0
; THUMB6-NEXT:    rsbs r4, r1, #0
; THUMB6-NEXT:    adcs r1, r4
; THUMB6-NEXT:    ldr r4, [sp, #16]
; THUMB6-NEXT:    lsls r2, r4
; THUMB6-NEXT:    ldr r4, .LCPI13_0
; THUMB6-NEXT:    ands r2, r4
; THUMB6-NEXT:    rsbs r4, r2, #0
; THUMB6-NEXT:    adcs r2, r4
; THUMB6-NEXT:    ldr r4, [sp, #20]
; THUMB6-NEXT:    lsls r3, r4
; THUMB6-NEXT:    lsls r4, r0, #31
; THUMB6-NEXT:    ands r3, r4
; THUMB6-NEXT:    rsbs r4, r3, #0
; THUMB6-NEXT:    adcs r3, r4
; THUMB6-NEXT:    pop {r4, pc}
; THUMB6-NEXT:    .p2align 2
; THUMB6-NEXT:  @ %bb.1:
; THUMB6-NEXT:  .LCPI13_0:
; THUMB6-NEXT:    .long 16776960 @ 0xffff00
;
; THUMB78-LABEL: vec_4xi32_nonsplat_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    mov r12, sp
; THUMB78-NEXT:    vld1.64 {d16, d17}, [r12]
; THUMB78-NEXT:    adr.w r12, .LCPI13_0
; THUMB78-NEXT:    vneg.s32 q8, q8
; THUMB78-NEXT:    vld1.64 {d18, d19}, [r12:128]
; THUMB78-NEXT:    vshl.u32 q8, q9, q8
; THUMB78-NEXT:    vmov d19, r2, r3
; THUMB78-NEXT:    vmov d18, r0, r1
; THUMB78-NEXT:    vtst.32 q8, q8, q9
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vmovn.i32 d16, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    bx lr
; THUMB78-NEXT:    .p2align 4
; THUMB78-NEXT:  @ %bb.1:
; THUMB78-NEXT:  .LCPI13_0:
; THUMB78-NEXT:    .long 0 @ 0x0
; THUMB78-NEXT:    .long 1 @ 0x1
; THUMB78-NEXT:    .long 16776960 @ 0xffff00
; THUMB78-NEXT:    .long 2147483648 @ 0x80000000
  %t0 = lshr <4 x i32> <i32 0, i32 1, i32 16776960, i32 2147483648>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %res
}

define <4 x i1> @vec_4xi32_nonsplat_undef0_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; ARM6-LABEL: vec_4xi32_nonsplat_undef0_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    push {r11, lr}
; ARM6-NEXT:    ldr r2, [sp, #12]
; ARM6-NEXT:    mov lr, #1
; ARM6-NEXT:    ldr r12, [sp, #8]
; ARM6-NEXT:    bic r1, lr, r1, lsl r2
; ARM6-NEXT:    ldr r2, [sp, #20]
; ARM6-NEXT:    bic r0, lr, r0, lsl r12
; ARM6-NEXT:    bic r3, lr, r3, lsl r2
; ARM6-NEXT:    mov r2, #1
; ARM6-NEXT:    pop {r11, pc}
;
; ARM78-LABEL: vec_4xi32_nonsplat_undef0_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    vmov d17, r2, r3
; ARM78-NEXT:    mov r12, sp
; ARM78-NEXT:    vld1.64 {d18, d19}, [r12]
; ARM78-NEXT:    vmov d16, r0, r1
; ARM78-NEXT:    vmov.i32 q10, #0x1
; ARM78-NEXT:    vshl.u32 q8, q8, q9
; ARM78-NEXT:    vtst.32 q8, q8, q10
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vmovn.i32 d16, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: vec_4xi32_nonsplat_undef0_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, lr}
; THUMB6-NEXT:    ldr r2, [sp, #8]
; THUMB6-NEXT:    lsls r0, r2
; THUMB6-NEXT:    movs r2, #1
; THUMB6-NEXT:    ands r0, r2
; THUMB6-NEXT:    rsbs r4, r0, #0
; THUMB6-NEXT:    adcs r0, r4
; THUMB6-NEXT:    ldr r4, [sp, #12]
; THUMB6-NEXT:    lsls r1, r4
; THUMB6-NEXT:    ands r1, r2
; THUMB6-NEXT:    rsbs r4, r1, #0
; THUMB6-NEXT:    adcs r1, r4
; THUMB6-NEXT:    ldr r4, [sp, #20]
; THUMB6-NEXT:    lsls r3, r4
; THUMB6-NEXT:    ands r3, r2
; THUMB6-NEXT:    rsbs r4, r3, #0
; THUMB6-NEXT:    adcs r3, r4
; THUMB6-NEXT:    pop {r4, pc}
;
; THUMB78-LABEL: vec_4xi32_nonsplat_undef0_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    vmov d17, r2, r3
; THUMB78-NEXT:    mov r12, sp
; THUMB78-NEXT:    vld1.64 {d18, d19}, [r12]
; THUMB78-NEXT:    vmov d16, r0, r1
; THUMB78-NEXT:    vmov.i32 q10, #0x1
; THUMB78-NEXT:    vshl.u32 q8, q8, q9
; THUMB78-NEXT:    vtst.32 q8, q8, q10
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vmovn.i32 d16, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    bx lr
  %t0 = lshr <4 x i32> <i32 1, i32 1, i32 undef, i32 1>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %res
}
define <4 x i1> @vec_4xi32_nonsplat_undef1_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; ARM6-LABEL: vec_4xi32_nonsplat_undef1_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    push {r11, lr}
; ARM6-NEXT:    ldr r2, [sp, #12]
; ARM6-NEXT:    mov lr, #1
; ARM6-NEXT:    ldr r12, [sp, #8]
; ARM6-NEXT:    bic r1, lr, r1, lsl r2
; ARM6-NEXT:    ldr r2, [sp, #20]
; ARM6-NEXT:    bic r0, lr, r0, lsl r12
; ARM6-NEXT:    bic r3, lr, r3, lsl r2
; ARM6-NEXT:    pop {r11, pc}
;
; ARM78-LABEL: vec_4xi32_nonsplat_undef1_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    mov r12, sp
; ARM78-NEXT:    vld1.64 {d16, d17}, [r12]
; ARM78-NEXT:    vmov.i32 q9, #0x1
; ARM78-NEXT:    vneg.s32 q8, q8
; ARM78-NEXT:    vshl.u32 q8, q9, q8
; ARM78-NEXT:    vmov d19, r2, r3
; ARM78-NEXT:    vmov d18, r0, r1
; ARM78-NEXT:    vtst.32 q8, q8, q9
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vmovn.i32 d16, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: vec_4xi32_nonsplat_undef1_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, lr}
; THUMB6-NEXT:    ldr r2, [sp, #8]
; THUMB6-NEXT:    lsls r0, r2
; THUMB6-NEXT:    movs r2, #1
; THUMB6-NEXT:    ands r0, r2
; THUMB6-NEXT:    rsbs r4, r0, #0
; THUMB6-NEXT:    adcs r0, r4
; THUMB6-NEXT:    ldr r4, [sp, #12]
; THUMB6-NEXT:    lsls r1, r4
; THUMB6-NEXT:    ands r1, r2
; THUMB6-NEXT:    rsbs r4, r1, #0
; THUMB6-NEXT:    adcs r1, r4
; THUMB6-NEXT:    ldr r4, [sp, #20]
; THUMB6-NEXT:    lsls r3, r4
; THUMB6-NEXT:    ands r3, r2
; THUMB6-NEXT:    rsbs r2, r3, #0
; THUMB6-NEXT:    adcs r3, r2
; THUMB6-NEXT:    pop {r4, pc}
;
; THUMB78-LABEL: vec_4xi32_nonsplat_undef1_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    mov r12, sp
; THUMB78-NEXT:    vld1.64 {d16, d17}, [r12]
; THUMB78-NEXT:    vmov.i32 q9, #0x1
; THUMB78-NEXT:    vneg.s32 q8, q8
; THUMB78-NEXT:    vshl.u32 q8, q9, q8
; THUMB78-NEXT:    vmov d19, r2, r3
; THUMB78-NEXT:    vmov d18, r0, r1
; THUMB78-NEXT:    vtst.32 q8, q8, q9
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vmovn.i32 d16, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    bx lr
  %t0 = lshr <4 x i32> <i32 1, i32 1, i32 1, i32 1>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 undef, i32 0>
  ret <4 x i1> %res
}
define <4 x i1> @vec_4xi32_nonsplat_undef2_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; ARM6-LABEL: vec_4xi32_nonsplat_undef2_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    push {r11, lr}
; ARM6-NEXT:    ldr r2, [sp, #12]
; ARM6-NEXT:    mov lr, #1
; ARM6-NEXT:    ldr r12, [sp, #8]
; ARM6-NEXT:    bic r1, lr, r1, lsl r2
; ARM6-NEXT:    ldr r2, [sp, #20]
; ARM6-NEXT:    bic r0, lr, r0, lsl r12
; ARM6-NEXT:    bic r3, lr, r3, lsl r2
; ARM6-NEXT:    pop {r11, pc}
;
; ARM78-LABEL: vec_4xi32_nonsplat_undef2_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    mov r12, sp
; ARM78-NEXT:    vld1.64 {d16, d17}, [r12]
; ARM78-NEXT:    vmov.i32 q9, #0x1
; ARM78-NEXT:    vneg.s32 q8, q8
; ARM78-NEXT:    vshl.u32 q8, q9, q8
; ARM78-NEXT:    vmov d19, r2, r3
; ARM78-NEXT:    vmov d18, r0, r1
; ARM78-NEXT:    vtst.32 q8, q8, q9
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vmovn.i32 d16, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: vec_4xi32_nonsplat_undef2_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, lr}
; THUMB6-NEXT:    ldr r2, [sp, #8]
; THUMB6-NEXT:    lsls r0, r2
; THUMB6-NEXT:    movs r2, #1
; THUMB6-NEXT:    ands r0, r2
; THUMB6-NEXT:    rsbs r4, r0, #0
; THUMB6-NEXT:    adcs r0, r4
; THUMB6-NEXT:    ldr r4, [sp, #12]
; THUMB6-NEXT:    lsls r1, r4
; THUMB6-NEXT:    ands r1, r2
; THUMB6-NEXT:    rsbs r4, r1, #0
; THUMB6-NEXT:    adcs r1, r4
; THUMB6-NEXT:    ldr r4, [sp, #20]
; THUMB6-NEXT:    lsls r3, r4
; THUMB6-NEXT:    ands r3, r2
; THUMB6-NEXT:    rsbs r2, r3, #0
; THUMB6-NEXT:    adcs r3, r2
; THUMB6-NEXT:    pop {r4, pc}
;
; THUMB78-LABEL: vec_4xi32_nonsplat_undef2_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    mov r12, sp
; THUMB78-NEXT:    vld1.64 {d16, d17}, [r12]
; THUMB78-NEXT:    vmov.i32 q9, #0x1
; THUMB78-NEXT:    vneg.s32 q8, q8
; THUMB78-NEXT:    vshl.u32 q8, q9, q8
; THUMB78-NEXT:    vmov d19, r2, r3
; THUMB78-NEXT:    vmov d18, r0, r1
; THUMB78-NEXT:    vtst.32 q8, q8, q9
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vmovn.i32 d16, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    bx lr
  %t0 = lshr <4 x i32> <i32 1, i32 1, i32 undef, i32 1>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 undef, i32 0>
  ret <4 x i1> %res
}

;------------------------------------------------------------------------------;
; A special tests
;------------------------------------------------------------------------------;

define i1 @scalar_i8_signbit_ne(i8 %x, i8 %y) nounwind {
; ARM-LABEL: scalar_i8_signbit_ne:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxtb r1, r1
; ARM-NEXT:    lsl r0, r0, r1
; ARM-NEXT:    uxtb r0, r0
; ARM-NEXT:    lsr r0, r0, #7
; ARM-NEXT:    bx lr
;
; THUMB-LABEL: scalar_i8_signbit_ne:
; THUMB:       @ %bb.0:
; THUMB-NEXT:    uxtb r1, r1
; THUMB-NEXT:    lsls r0, r1
; THUMB-NEXT:    uxtb r0, r0
; THUMB-NEXT:    lsrs r0, r0, #7
; THUMB-NEXT:    bx lr
  %t0 = lshr i8 128, %y
  %t1 = and i8 %t0, %x
  %res = icmp ne i8 %t1, 0 ;  we are perfectly happy with 'ne' predicate
  ret i1 %res
}

;------------------------------------------------------------------------------;
; What if X is a constant too?
;------------------------------------------------------------------------------;

define i1 @scalar_i32_x_is_const_eq(i32 %y) nounwind {
; ARM6-LABEL: scalar_i32_x_is_const_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    ldr r1, .LCPI18_0
; ARM6-NEXT:    mov r2, #1
; ARM6-NEXT:    bic r0, r2, r1, lsr r0
; ARM6-NEXT:    bx lr
; ARM6-NEXT:    .p2align 2
; ARM6-NEXT:  @ %bb.1:
; ARM6-NEXT:  .LCPI18_0:
; ARM6-NEXT:    .long 2857740885 @ 0xaa55aa55
;
; ARM78-LABEL: scalar_i32_x_is_const_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    movw r1, #43605
; ARM78-NEXT:    mov r2, #1
; ARM78-NEXT:    movt r1, #43605
; ARM78-NEXT:    bic r0, r2, r1, lsr r0
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i32_x_is_const_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    ldr r1, .LCPI18_0
; THUMB6-NEXT:    lsrs r1, r0
; THUMB6-NEXT:    movs r2, #1
; THUMB6-NEXT:    ands r2, r1
; THUMB6-NEXT:    rsbs r0, r2, #0
; THUMB6-NEXT:    adcs r0, r2
; THUMB6-NEXT:    bx lr
; THUMB6-NEXT:    .p2align 2
; THUMB6-NEXT:  @ %bb.1:
; THUMB6-NEXT:  .LCPI18_0:
; THUMB6-NEXT:    .long 2857740885 @ 0xaa55aa55
;
; THUMB78-LABEL: scalar_i32_x_is_const_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    movw r1, #43605
; THUMB78-NEXT:    movt r1, #43605
; THUMB78-NEXT:    lsr.w r0, r1, r0
; THUMB78-NEXT:    movs r1, #1
; THUMB78-NEXT:    bic.w r0, r1, r0
; THUMB78-NEXT:    bx lr
  %t0 = lshr i32 2857740885, %y
  %t1 = and i32 %t0, 1
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}
define i1 @scalar_i32_x_is_const2_eq(i32 %y) nounwind {
; ARM-LABEL: scalar_i32_x_is_const2_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    mov r1, #1
; ARM-NEXT:    eor r0, r1, r1, lsr r0
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i32_x_is_const2_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    movs r1, #1
; THUMB6-NEXT:    lsrs r1, r0
; THUMB6-NEXT:    rsbs r0, r1, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i32_x_is_const2_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    movs r1, #1
; THUMB78-NEXT:    lsr.w r0, r1, r0
; THUMB78-NEXT:    eor r0, r0, #1
; THUMB78-NEXT:    bx lr
  %t0 = lshr i32 1, %y
  %t1 = and i32 %t0, 2857740885
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}

;------------------------------------------------------------------------------;
; A few negative tests
;------------------------------------------------------------------------------;

define i1 @negative_scalar_i8_bitsinmiddle_slt(i8 %x, i8 %y) nounwind {
; ARM6-LABEL: negative_scalar_i8_bitsinmiddle_slt:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    uxtb r1, r1
; ARM6-NEXT:    mov r2, #24
; ARM6-NEXT:    and r1, r0, r2, lsr r1
; ARM6-NEXT:    mov r0, #0
; ARM6-NEXT:    cmp r1, #0
; ARM6-NEXT:    movmi r0, #1
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: negative_scalar_i8_bitsinmiddle_slt:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    uxtb r1, r1
; ARM78-NEXT:    mov r2, #24
; ARM78-NEXT:    and r1, r0, r2, lsr r1
; ARM78-NEXT:    mov r0, #0
; ARM78-NEXT:    cmp r1, #0
; ARM78-NEXT:    movwmi r0, #1
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: negative_scalar_i8_bitsinmiddle_slt:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxtb r1, r1
; THUMB6-NEXT:    movs r2, #24
; THUMB6-NEXT:    lsrs r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    bmi .LBB20_2
; THUMB6-NEXT:  @ %bb.1:
; THUMB6-NEXT:    movs r0, #0
; THUMB6-NEXT:    bx lr
; THUMB6-NEXT:  .LBB20_2:
; THUMB6-NEXT:    movs r0, #1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: negative_scalar_i8_bitsinmiddle_slt:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxtb r1, r1
; THUMB78-NEXT:    movs r2, #24
; THUMB78-NEXT:    lsr.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    mov.w r0, #0
; THUMB78-NEXT:    it mi
; THUMB78-NEXT:    movmi r0, #1
; THUMB78-NEXT:    bx lr
  %t0 = lshr i8 24, %y
  %t1 = and i8 %t0, %x
  %res = icmp slt i8 %t1, 0
  ret i1 %res
}

define i1 @scalar_i8_signbit_eq_with_nonzero(i8 %x, i8 %y) nounwind {
; ARM-LABEL: scalar_i8_signbit_eq_with_nonzero:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxtb r1, r1
; ARM-NEXT:    mov r2, #128
; ARM-NEXT:    and r0, r0, r2, lsr r1
; ARM-NEXT:    sub r0, r0, #1
; ARM-NEXT:    clz r0, r0
; ARM-NEXT:    lsr r0, r0, #5
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i8_signbit_eq_with_nonzero:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxtb r1, r1
; THUMB6-NEXT:    movs r2, #128
; THUMB6-NEXT:    lsrs r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    subs r1, r2, #1
; THUMB6-NEXT:    rsbs r0, r1, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i8_signbit_eq_with_nonzero:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxtb r1, r1
; THUMB78-NEXT:    movs r2, #128
; THUMB78-NEXT:    lsr.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    subs r0, #1
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = lshr i8 128, %y
  %t1 = and i8 %t0, %x
  %res = icmp eq i8 %t1, 1 ; should be comparing with 0
  ret i1 %res
}
