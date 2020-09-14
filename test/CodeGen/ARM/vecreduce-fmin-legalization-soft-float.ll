; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm-none-eabi -mattr=-neon | FileCheck %s --check-prefix=CHECK

declare half @llvm.experimental.vector.reduce.fmin.v4f16(<4 x half>)
declare float @llvm.experimental.vector.reduce.fmin.v4f32(<4 x float>)
declare double @llvm.experimental.vector.reduce.fmin.v2f64(<2 x double>)
declare fp128 @llvm.experimental.vector.reduce.fmin.v2f128(<2 x fp128>)

define half @test_v4f16(<4 x half> %a) nounwind {
; CHECK-LABEL: test_v4f16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, r5, r6, r7, r8, r9, r11, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, r8, r9, r11, lr}
; CHECK-NEXT:    mov r6, #255
; CHECK-NEXT:    mov r7, r0
; CHECK-NEXT:    orr r6, r6, #65280
; CHECK-NEXT:    mov r4, r3
; CHECK-NEXT:    and r0, r1, r6
; CHECK-NEXT:    mov r8, r2
; CHECK-NEXT:    bl __aeabi_h2f
; CHECK-NEXT:    mov r5, r0
; CHECK-NEXT:    and r0, r4, r6
; CHECK-NEXT:    bl __aeabi_h2f
; CHECK-NEXT:    mov r4, r0
; CHECK-NEXT:    mov r0, r5
; CHECK-NEXT:    mov r1, r4
; CHECK-NEXT:    bl __aeabi_fcmplt
; CHECK-NEXT:    mov r9, r0
; CHECK-NEXT:    and r0, r7, r6
; CHECK-NEXT:    bl __aeabi_h2f
; CHECK-NEXT:    mov r7, r0
; CHECK-NEXT:    and r0, r8, r6
; CHECK-NEXT:    bl __aeabi_h2f
; CHECK-NEXT:    mov r6, r0
; CHECK-NEXT:    mov r0, r7
; CHECK-NEXT:    mov r1, r6
; CHECK-NEXT:    bl __aeabi_fcmplt
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    movne r6, r7
; CHECK-NEXT:    cmp r9, #0
; CHECK-NEXT:    movne r4, r5
; CHECK-NEXT:    mov r0, r6
; CHECK-NEXT:    mov r1, r4
; CHECK-NEXT:    bl __aeabi_fcmplt
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    movne r4, r6
; CHECK-NEXT:    mov r0, r4
; CHECK-NEXT:    bl __aeabi_f2h
; CHECK-NEXT:    pop {r4, r5, r6, r7, r8, r9, r11, lr}
; CHECK-NEXT:    mov pc, lr
  %b = call fast half @llvm.experimental.vector.reduce.fmin.v4f16(<4 x half> %a)
  ret half %b
}

define float @test_v4f32(<4 x float> %a) nounwind {
; CHECK-LABEL: test_v4f32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, r5, r6, r7, r8, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, r8, lr}
; CHECK-NEXT:    mov r7, r0
; CHECK-NEXT:    mov r6, r1
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov r1, r3
; CHECK-NEXT:    mov r4, r3
; CHECK-NEXT:    mov r5, r2
; CHECK-NEXT:    bl __aeabi_fcmplt
; CHECK-NEXT:    mov r8, r0
; CHECK-NEXT:    mov r0, r7
; CHECK-NEXT:    mov r1, r5
; CHECK-NEXT:    bl __aeabi_fcmplt
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    movne r5, r7
; CHECK-NEXT:    cmp r8, #0
; CHECK-NEXT:    movne r4, r6
; CHECK-NEXT:    mov r0, r5
; CHECK-NEXT:    mov r1, r4
; CHECK-NEXT:    bl __aeabi_fcmplt
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    movne r4, r5
; CHECK-NEXT:    mov r0, r4
; CHECK-NEXT:    pop {r4, r5, r6, r7, r8, lr}
; CHECK-NEXT:    mov pc, lr
  %b = call fast float @llvm.experimental.vector.reduce.fmin.v4f32(<4 x float> %a)
  ret float %b
}

define double @test_v2f64(<2 x double> %a) nounwind {
; CHECK-LABEL: test_v2f64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, r5, r6, r7, r11, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, r11, lr}
; CHECK-NEXT:    mov r4, r3
; CHECK-NEXT:    mov r5, r2
; CHECK-NEXT:    mov r6, r1
; CHECK-NEXT:    mov r7, r0
; CHECK-NEXT:    bl __aeabi_dcmplt
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    moveq r7, r5
; CHECK-NEXT:    moveq r6, r4
; CHECK-NEXT:    mov r0, r7
; CHECK-NEXT:    mov r1, r6
; CHECK-NEXT:    pop {r4, r5, r6, r7, r11, lr}
; CHECK-NEXT:    mov pc, lr
  %b = call fast double @llvm.experimental.vector.reduce.fmin.v2f64(<2 x double> %a)
  ret double %b
}

define fp128 @test_v2f128(<2 x fp128> %a) nounwind {
; CHECK-LABEL: test_v2f128:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, r5, r6, r7, r8, r9, r10, r11, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, r8, r9, r10, r11, lr}
; CHECK-NEXT:    .pad #20
; CHECK-NEXT:    sub sp, sp, #20
; CHECK-NEXT:    ldr r8, [sp, #68]
; CHECK-NEXT:    mov r4, r3
; CHECK-NEXT:    ldr r9, [sp, #64]
; CHECK-NEXT:    mov r5, r2
; CHECK-NEXT:    ldr r10, [sp, #60]
; CHECK-NEXT:    mov r6, r1
; CHECK-NEXT:    ldr r11, [sp, #56]
; CHECK-NEXT:    mov r7, r0
; CHECK-NEXT:    str r8, [sp, #12]
; CHECK-NEXT:    str r9, [sp, #8]
; CHECK-NEXT:    str r10, [sp, #4]
; CHECK-NEXT:    str r11, [sp]
; CHECK-NEXT:    bl __lttf2
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    movpl r7, r11
; CHECK-NEXT:    movpl r6, r10
; CHECK-NEXT:    movpl r5, r9
; CHECK-NEXT:    movpl r4, r8
; CHECK-NEXT:    mov r0, r7
; CHECK-NEXT:    mov r1, r6
; CHECK-NEXT:    mov r2, r5
; CHECK-NEXT:    mov r3, r4
; CHECK-NEXT:    add sp, sp, #20
; CHECK-NEXT:    pop {r4, r5, r6, r7, r8, r9, r10, r11, lr}
; CHECK-NEXT:    mov pc, lr
  %b = call fast fp128 @llvm.experimental.vector.reduce.fmin.v2f128(<2 x fp128> %a)
  ret fp128 %b
}
