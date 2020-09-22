; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -O0 -mattr=+mve %s -o - | FileCheck %s

declare void @external_function()

define arm_aapcs_vfpcc void @spill_vector_i32(<4 x i32> %v, <4 x i32>* %p) {
; CHECK-LABEL: spill_vector_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    .pad #40
; CHECK-NEXT:    sub sp, #40
; CHECK-NEXT:    vmov q1, q0
; CHECK-NEXT:    str r0, [sp, #36] @ 4-byte Spill
; CHECK-NEXT:    vstrw.32 q0, [sp, #16] @ 16-byte Spill
; CHECK-NEXT:    vstrw.32 q1, [sp] @ 16-byte Spill
; CHECK-NEXT:    bl external_function
; CHECK-NEXT:    vldrw.u32 q0, [sp, #16] @ 16-byte Reload
; CHECK-NEXT:    ldr r0, [sp, #36] @ 4-byte Reload
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    add sp, #40
; CHECK-NEXT:    pop {r7, pc}
entry:
  call void @external_function()
  store <4 x i32> %v, <4 x i32>* %p, align 4
  ret void
}

define arm_aapcs_vfpcc void @spill_vector_i16(<8 x i16> %v, <8 x i16>* %p) {
; CHECK-LABEL: spill_vector_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    .pad #40
; CHECK-NEXT:    sub sp, #40
; CHECK-NEXT:    vmov q1, q0
; CHECK-NEXT:    str r0, [sp, #36] @ 4-byte Spill
; CHECK-NEXT:    vstrw.32 q0, [sp, #16] @ 16-byte Spill
; CHECK-NEXT:    vstrw.32 q1, [sp] @ 16-byte Spill
; CHECK-NEXT:    bl external_function
; CHECK-NEXT:    vldrw.u32 q0, [sp, #16] @ 16-byte Reload
; CHECK-NEXT:    ldr r0, [sp, #36] @ 4-byte Reload
; CHECK-NEXT:    vstrh.16 q0, [r0]
; CHECK-NEXT:    add sp, #40
; CHECK-NEXT:    pop {r7, pc}
entry:
  call void @external_function()
  store <8 x i16> %v, <8 x i16>* %p, align 2
  ret void
}

define arm_aapcs_vfpcc void @spill_vector_i8(<16 x i8> %v, <16 x i8>* %p) {
; CHECK-LABEL: spill_vector_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    .pad #40
; CHECK-NEXT:    sub sp, #40
; CHECK-NEXT:    vmov q1, q0
; CHECK-NEXT:    str r0, [sp, #36] @ 4-byte Spill
; CHECK-NEXT:    vstrw.32 q0, [sp, #16] @ 16-byte Spill
; CHECK-NEXT:    vstrw.32 q1, [sp] @ 16-byte Spill
; CHECK-NEXT:    bl external_function
; CHECK-NEXT:    vldrw.u32 q0, [sp, #16] @ 16-byte Reload
; CHECK-NEXT:    ldr r0, [sp, #36] @ 4-byte Reload
; CHECK-NEXT:    vstrb.8 q0, [r0]
; CHECK-NEXT:    add sp, #40
; CHECK-NEXT:    pop {r7, pc}
entry:
  call void @external_function()
  store <16 x i8> %v, <16 x i8>* %p, align 1
  ret void
}

define arm_aapcs_vfpcc void @spill_vector_i64(<2 x i64> %v, <2 x i64>* %p) {
; CHECK-LABEL: spill_vector_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    .pad #40
; CHECK-NEXT:    sub sp, #40
; CHECK-NEXT:    vmov q1, q0
; CHECK-NEXT:    str r0, [sp, #36] @ 4-byte Spill
; CHECK-NEXT:    vstrw.32 q0, [sp, #16] @ 16-byte Spill
; CHECK-NEXT:    vstrw.32 q1, [sp] @ 16-byte Spill
; CHECK-NEXT:    bl external_function
; CHECK-NEXT:    vldrw.u32 q0, [sp, #16] @ 16-byte Reload
; CHECK-NEXT:    ldr r0, [sp, #36] @ 4-byte Reload
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    add sp, #40
; CHECK-NEXT:    pop {r7, pc}
entry:
  call void @external_function()
  store <2 x i64> %v, <2 x i64>* %p, align 8
  ret void
}

define arm_aapcs_vfpcc void @spill_vector_f32(<4 x float> %v, <4 x float>* %p) {
; CHECK-LABEL: spill_vector_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    .pad #40
; CHECK-NEXT:    sub sp, #40
; CHECK-NEXT:    vmov q1, q0
; CHECK-NEXT:    str r0, [sp, #36] @ 4-byte Spill
; CHECK-NEXT:    vstrw.32 q0, [sp, #16] @ 16-byte Spill
; CHECK-NEXT:    vstrw.32 q1, [sp] @ 16-byte Spill
; CHECK-NEXT:    bl external_function
; CHECK-NEXT:    vldrw.u32 q0, [sp, #16] @ 16-byte Reload
; CHECK-NEXT:    ldr r0, [sp, #36] @ 4-byte Reload
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    add sp, #40
; CHECK-NEXT:    pop {r7, pc}
entry:
  call void @external_function()
  store <4 x float> %v, <4 x float>* %p, align 8
  ret void
}

define arm_aapcs_vfpcc void @spill_vector_f16(<8 x half> %v, <8 x half>* %p) {
; CHECK-LABEL: spill_vector_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    .pad #40
; CHECK-NEXT:    sub sp, #40
; CHECK-NEXT:    vmov q1, q0
; CHECK-NEXT:    str r0, [sp, #36] @ 4-byte Spill
; CHECK-NEXT:    vstrw.32 q0, [sp, #16] @ 16-byte Spill
; CHECK-NEXT:    vstrw.32 q1, [sp] @ 16-byte Spill
; CHECK-NEXT:    bl external_function
; CHECK-NEXT:    vldrw.u32 q0, [sp, #16] @ 16-byte Reload
; CHECK-NEXT:    ldr r0, [sp, #36] @ 4-byte Reload
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    add sp, #40
; CHECK-NEXT:    pop {r7, pc}
entry:
  call void @external_function()
  store <8 x half> %v, <8 x half>* %p, align 8
  ret void
}

define arm_aapcs_vfpcc void @spill_vector_f64(<2 x double> %v, <2 x double>* %p) {
; CHECK-LABEL: spill_vector_f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    .pad #24
; CHECK-NEXT:    sub sp, #24
; CHECK-NEXT:    str r0, [sp, #20] @ 4-byte Spill
; CHECK-NEXT:    vstrw.32 q0, [sp] @ 16-byte Spill
; CHECK-NEXT:    bl external_function
; CHECK-NEXT:    vldrw.u32 q0, [sp] @ 16-byte Reload
; CHECK-NEXT:    ldr r0, [sp, #20] @ 4-byte Reload
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    add sp, #24
; CHECK-NEXT:    pop {r7, pc}
entry:
  call void @external_function()
  store <2 x double> %v, <2 x double>* %p, align 8
  ret void
}
