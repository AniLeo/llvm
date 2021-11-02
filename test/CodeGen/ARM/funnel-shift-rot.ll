; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm-eabi -mattr=+v6t2 | FileCheck %s --check-prefixes=CHECK,SCALAR
; RUN: llc < %s -mtriple=arm-eabi -mattr=+v6t2 -mattr=+neon | FileCheck %s --check-prefixes=CHECK,NEON

declare i8 @llvm.fshl.i8(i8, i8, i8)
declare i16 @llvm.fshl.i16(i16, i16, i16)
declare i32 @llvm.fshl.i32(i32, i32, i32)
declare i64 @llvm.fshl.i64(i64, i64, i64)
declare <4 x i32> @llvm.fshl.v4i32(<4 x i32>, <4 x i32>, <4 x i32>)

declare i8 @llvm.fshr.i8(i8, i8, i8)
declare i16 @llvm.fshr.i16(i16, i16, i16)
declare i32 @llvm.fshr.i32(i32, i32, i32)
declare i64 @llvm.fshr.i64(i64, i64, i64)
declare <4 x i32> @llvm.fshr.v4i32(<4 x i32>, <4 x i32>, <4 x i32>)

; When first 2 operands match, it's a rotate.

define i8 @rotl_i8_const_shift(i8 %x) {
; CHECK-LABEL: rotl_i8_const_shift:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    uxtb r1, r0
; CHECK-NEXT:    lsl r0, r0, #3
; CHECK-NEXT:    orr r0, r0, r1, lsr #5
; CHECK-NEXT:    bx lr
  %f = call i8 @llvm.fshl.i8(i8 %x, i8 %x, i8 3)
  ret i8 %f
}

define i64 @rotl_i64_const_shift(i64 %x) {
; CHECK-LABEL: rotl_i64_const_shift:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    lsl r2, r0, #3
; CHECK-NEXT:    orr r2, r2, r1, lsr #29
; CHECK-NEXT:    lsl r1, r1, #3
; CHECK-NEXT:    orr r1, r1, r0, lsr #29
; CHECK-NEXT:    mov r0, r2
; CHECK-NEXT:    bx lr
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %x, i64 3)
  ret i64 %f
}

; When first 2 operands match, it's a rotate (by variable amount).

define i16 @rotl_i16(i16 %x, i16 %z) {
; CHECK-LABEL: rotl_i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    and r2, r1, #15
; CHECK-NEXT:    rsb r1, r1, #0
; CHECK-NEXT:    and r1, r1, #15
; CHECK-NEXT:    lsl r2, r0, r2
; CHECK-NEXT:    uxth r0, r0
; CHECK-NEXT:    orr r0, r2, r0, lsr r1
; CHECK-NEXT:    bx lr
  %f = call i16 @llvm.fshl.i16(i16 %x, i16 %x, i16 %z)
  ret i16 %f
}

define i32 @rotl_i32(i32 %x, i32 %z) {
; CHECK-LABEL: rotl_i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    rsb r1, r1, #0
; CHECK-NEXT:    ror r0, r0, r1
; CHECK-NEXT:    bx lr
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %x, i32 %z)
  ret i32 %f
}

define i64 @rotl_i64(i64 %x, i64 %z) {
; CHECK-LABEL: rotl_i64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    ands r3, r2, #32
; CHECK-NEXT:    and r12, r2, #31
; CHECK-NEXT:    mov r3, r0
; CHECK-NEXT:    mov r4, #31
; CHECK-NEXT:    movne r3, r1
; CHECK-NEXT:    movne r1, r0
; CHECK-NEXT:    bic r2, r4, r2
; CHECK-NEXT:    lsl lr, r3, r12
; CHECK-NEXT:    lsr r0, r1, #1
; CHECK-NEXT:    lsl r1, r1, r12
; CHECK-NEXT:    lsr r3, r3, #1
; CHECK-NEXT:    orr r0, lr, r0, lsr r2
; CHECK-NEXT:    orr r1, r1, r3, lsr r2
; CHECK-NEXT:    pop {r4, pc}
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %x, i64 %z)
  ret i64 %f
}

; Vector rotate.

define <4 x i32> @rotl_v4i32(<4 x i32> %x, <4 x i32> %z) {
; SCALAR-LABEL: rotl_v4i32:
; SCALAR:       @ %bb.0:
; SCALAR-NEXT:    ldr r12, [sp]
; SCALAR-NEXT:    rsb r12, r12, #0
; SCALAR-NEXT:    ror r0, r0, r12
; SCALAR-NEXT:    ldr r12, [sp, #4]
; SCALAR-NEXT:    rsb r12, r12, #0
; SCALAR-NEXT:    ror r1, r1, r12
; SCALAR-NEXT:    ldr r12, [sp, #8]
; SCALAR-NEXT:    rsb r12, r12, #0
; SCALAR-NEXT:    ror r2, r2, r12
; SCALAR-NEXT:    ldr r12, [sp, #12]
; SCALAR-NEXT:    rsb r12, r12, #0
; SCALAR-NEXT:    ror r3, r3, r12
; SCALAR-NEXT:    bx lr
;
; NEON-LABEL: rotl_v4i32:
; NEON:       @ %bb.0:
; NEON-NEXT:    mov r12, sp
; NEON-NEXT:    vld1.64 {d16, d17}, [r12]
; NEON-NEXT:    vmov.i32 q10, #0x1f
; NEON-NEXT:    vneg.s32 q9, q8
; NEON-NEXT:    vmov d23, r2, r3
; NEON-NEXT:    vand q9, q9, q10
; NEON-NEXT:    vand q8, q8, q10
; NEON-NEXT:    vmov d22, r0, r1
; NEON-NEXT:    vneg.s32 q9, q9
; NEON-NEXT:    vshl.u32 q8, q11, q8
; NEON-NEXT:    vshl.u32 q9, q11, q9
; NEON-NEXT:    vorr q8, q8, q9
; NEON-NEXT:    vmov r0, r1, d16
; NEON-NEXT:    vmov r2, r3, d17
; NEON-NEXT:    bx lr
  %f = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> %z)
  ret <4 x i32> %f
}

; Vector rotate by constant splat amount.

define <4 x i32> @rotl_v4i32_rotl_const_shift(<4 x i32> %x) {
; SCALAR-LABEL: rotl_v4i32_rotl_const_shift:
; SCALAR:       @ %bb.0:
; SCALAR-NEXT:    ror r0, r0, #29
; SCALAR-NEXT:    ror r1, r1, #29
; SCALAR-NEXT:    ror r2, r2, #29
; SCALAR-NEXT:    ror r3, r3, #29
; SCALAR-NEXT:    bx lr
;
; NEON-LABEL: rotl_v4i32_rotl_const_shift:
; NEON:       @ %bb.0:
; NEON-NEXT:    vmov d17, r2, r3
; NEON-NEXT:    vmov d16, r0, r1
; NEON-NEXT:    vshr.u32 q9, q8, #29
; NEON-NEXT:    vshl.i32 q8, q8, #3
; NEON-NEXT:    vorr q8, q8, q9
; NEON-NEXT:    vmov r0, r1, d16
; NEON-NEXT:    vmov r2, r3, d17
; NEON-NEXT:    bx lr
  %f = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> <i32 3, i32 3, i32 3, i32 3>)
  ret <4 x i32> %f
}

; Repeat everything for funnel shift right.

; When first 2 operands match, it's a rotate.

define i8 @rotr_i8_const_shift(i8 %x) {
; CHECK-LABEL: rotr_i8_const_shift:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    uxtb r1, r0
; CHECK-NEXT:    lsr r1, r1, #3
; CHECK-NEXT:    orr r0, r1, r0, lsl #5
; CHECK-NEXT:    bx lr
  %f = call i8 @llvm.fshr.i8(i8 %x, i8 %x, i8 3)
  ret i8 %f
}

define i32 @rotr_i32_const_shift(i32 %x) {
; CHECK-LABEL: rotr_i32_const_shift:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    ror r0, r0, #3
; CHECK-NEXT:    bx lr
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %x, i32 3)
  ret i32 %f
}

; When first 2 operands match, it's a rotate (by variable amount).

define i16 @rotr_i16(i16 %x, i16 %z) {
; CHECK-LABEL: rotr_i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    and r2, r1, #15
; CHECK-NEXT:    rsb r1, r1, #0
; CHECK-NEXT:    and r1, r1, #15
; CHECK-NEXT:    uxth r3, r0
; CHECK-NEXT:    lsr r2, r3, r2
; CHECK-NEXT:    orr r0, r2, r0, lsl r1
; CHECK-NEXT:    bx lr
  %f = call i16 @llvm.fshr.i16(i16 %x, i16 %x, i16 %z)
  ret i16 %f
}

define i32 @rotr_i32(i32 %x, i32 %z) {
; CHECK-LABEL: rotr_i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    ror r0, r0, r1
; CHECK-NEXT:    bx lr
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %x, i32 %z)
  ret i32 %f
}

define i64 @rotr_i64(i64 %x, i64 %z) {
; CHECK-LABEL: rotr_i64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    ands r3, r2, #32
; CHECK-NEXT:    mov r3, r1
; CHECK-NEXT:    moveq r3, r0
; CHECK-NEXT:    moveq r0, r1
; CHECK-NEXT:    mov r1, #31
; CHECK-NEXT:    lsl r12, r0, #1
; CHECK-NEXT:    bic r1, r1, r2
; CHECK-NEXT:    and r2, r2, #31
; CHECK-NEXT:    lsl r12, r12, r1
; CHECK-NEXT:    orr r12, r12, r3, lsr r2
; CHECK-NEXT:    lsl r3, r3, #1
; CHECK-NEXT:    lsl r1, r3, r1
; CHECK-NEXT:    orr r1, r1, r0, lsr r2
; CHECK-NEXT:    mov r0, r12
; CHECK-NEXT:    bx lr
  %f = call i64 @llvm.fshr.i64(i64 %x, i64 %x, i64 %z)
  ret i64 %f
}

; Vector rotate.

define <4 x i32> @rotr_v4i32(<4 x i32> %x, <4 x i32> %z) {
; SCALAR-LABEL: rotr_v4i32:
; SCALAR:       @ %bb.0:
; SCALAR-NEXT:    ldr r12, [sp]
; SCALAR-NEXT:    ror r0, r0, r12
; SCALAR-NEXT:    ldr r12, [sp, #4]
; SCALAR-NEXT:    ror r1, r1, r12
; SCALAR-NEXT:    ldr r12, [sp, #8]
; SCALAR-NEXT:    ror r2, r2, r12
; SCALAR-NEXT:    ldr r12, [sp, #12]
; SCALAR-NEXT:    ror r3, r3, r12
; SCALAR-NEXT:    bx lr
;
; NEON-LABEL: rotr_v4i32:
; NEON:       @ %bb.0:
; NEON-NEXT:    mov r12, sp
; NEON-NEXT:    vld1.64 {d16, d17}, [r12]
; NEON-NEXT:    vmov.i32 q9, #0x1f
; NEON-NEXT:    vneg.s32 q10, q8
; NEON-NEXT:    vand q8, q8, q9
; NEON-NEXT:    vmov d23, r2, r3
; NEON-NEXT:    vand q9, q10, q9
; NEON-NEXT:    vneg.s32 q8, q8
; NEON-NEXT:    vmov d22, r0, r1
; NEON-NEXT:    vshl.u32 q9, q11, q9
; NEON-NEXT:    vshl.u32 q8, q11, q8
; NEON-NEXT:    vorr q8, q8, q9
; NEON-NEXT:    vmov r0, r1, d16
; NEON-NEXT:    vmov r2, r3, d17
; NEON-NEXT:    bx lr
  %f = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> %z)
  ret <4 x i32> %f
}

; Vector rotate by constant splat amount.

define <4 x i32> @rotr_v4i32_const_shift(<4 x i32> %x) {
; SCALAR-LABEL: rotr_v4i32_const_shift:
; SCALAR:       @ %bb.0:
; SCALAR-NEXT:    ror r0, r0, #3
; SCALAR-NEXT:    ror r1, r1, #3
; SCALAR-NEXT:    ror r2, r2, #3
; SCALAR-NEXT:    ror r3, r3, #3
; SCALAR-NEXT:    bx lr
;
; NEON-LABEL: rotr_v4i32_const_shift:
; NEON:       @ %bb.0:
; NEON-NEXT:    vmov d17, r2, r3
; NEON-NEXT:    vmov d16, r0, r1
; NEON-NEXT:    vshl.i32 q9, q8, #29
; NEON-NEXT:    vshr.u32 q8, q8, #3
; NEON-NEXT:    vorr q8, q8, q9
; NEON-NEXT:    vmov r0, r1, d16
; NEON-NEXT:    vmov r2, r3, d17
; NEON-NEXT:    bx lr
  %f = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> <i32 3, i32 3, i32 3, i32 3>)
  ret <4 x i32> %f
}

define i32 @rotl_i32_shift_by_bitwidth(i32 %x) {
; CHECK-LABEL: rotl_i32_shift_by_bitwidth:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    bx lr
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %x, i32 32)
  ret i32 %f
}

define i32 @rotr_i32_shift_by_bitwidth(i32 %x) {
; CHECK-LABEL: rotr_i32_shift_by_bitwidth:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    bx lr
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %x, i32 32)
  ret i32 %f
}

define <4 x i32> @rotl_v4i32_shift_by_bitwidth(<4 x i32> %x) {
; CHECK-LABEL: rotl_v4i32_shift_by_bitwidth:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    bx lr
  %f = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> <i32 32, i32 32, i32 32, i32 32>)
  ret <4 x i32> %f
}

define <4 x i32> @rotr_v4i32_shift_by_bitwidth(<4 x i32> %x) {
; CHECK-LABEL: rotr_v4i32_shift_by_bitwidth:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    bx lr
  %f = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> <i32 32, i32 32, i32 32, i32 32>)
  ret <4 x i32> %f
}

