; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -enable-arm-maskedldst %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-STD
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -enable-arm-maskedldst -opaque-pointers %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-OPAQ

; i32

define arm_aapcs_vfpcc <2 x i32> @ptr_v2i32(<2 x i32*>* %offptr) {
; CHECK-LABEL: ptr_v2i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldrd r1, r0, [r0]
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    ldr r1, [r1]
; CHECK-NEXT:    vmov q0[2], q0[0], r1, r0
; CHECK-NEXT:    bx lr
entry:
  %offs = load <2 x i32*>, <2 x i32*>* %offptr, align 4
  %gather = call <2 x i32> @llvm.masked.gather.v2i32.v2p0i32(<2 x i32*> %offs, i32 4, <2 x i1> <i1 true, i1 true>, <2 x i32> undef)
  ret <2 x i32> %gather
}

define arm_aapcs_vfpcc <4 x i32> @ptr_v4i32(<4 x i32*>* %offptr) {
; CHECK-LABEL: ptr_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vldrw.u32 q0, [q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i32*>, <4 x i32*>* %offptr, align 4
  %gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %offs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef)
  ret <4 x i32> %gather
}

define arm_aapcs_vfpcc <8 x i32> @ptr_v8i32(<8 x i32*>* %offptr) {
; CHECK-LABEL: ptr_v8i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0, #16]
; CHECK-NEXT:    vmov r1, r2, d1
; CHECK-NEXT:    vmov r3, r12, d0
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r0, lr, d1
; CHECK-NEXT:    ldr r7, [r2]
; CHECK-NEXT:    vmov r2, r4, d0
; CHECK-NEXT:    ldr r6, [r1]
; CHECK-NEXT:    ldr r3, [r3]
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    ldr.w r1, [r12]
; CHECK-NEXT:    vmov q1[2], q1[0], r3, r6
; CHECK-NEXT:    ldr.w r5, [lr]
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r7
; CHECK-NEXT:    ldr r2, [r2]
; CHECK-NEXT:    ldr r4, [r4]
; CHECK-NEXT:    vmov q0[2], q0[0], r2, r0
; CHECK-NEXT:    vmov q0[3], q0[1], r4, r5
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %offs = load <8 x i32*>, <8 x i32*>* %offptr, align 4
  %gather = call <8 x i32> @llvm.masked.gather.v8i32.v8p0i32(<8 x i32*> %offs, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i32> undef)
  ret <8 x i32> %gather
}

define arm_aapcs_vfpcc <16 x i32> @ptr_v16i32(<16 x i32*>* %offptr) {
; CHECK-LABEL: ptr_v16i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0, #48]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vldrw.u32 q2, [r0, #32]
; CHECK-NEXT:    vmov r1, r2, d1
; CHECK-NEXT:    vmov r3, lr, d0
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r4, r5, d1
; CHECK-NEXT:    ldr r7, [r2]
; CHECK-NEXT:    vmov r2, r6, d0
; CHECK-NEXT:    ldr.w r12, [r1]
; CHECK-NEXT:    ldr r3, [r3]
; CHECK-NEXT:    ldr r4, [r4]
; CHECK-NEXT:    ldr r5, [r5]
; CHECK-NEXT:    vmov q3[2], q3[0], r3, r12
; CHECK-NEXT:    ldr.w r1, [lr]
; CHECK-NEXT:    vmov q3[3], q3[1], r1, r7
; CHECK-NEXT:    ldr r2, [r2]
; CHECK-NEXT:    ldr r6, [r6]
; CHECK-NEXT:    vmov q0[2], q0[0], r2, r4
; CHECK-NEXT:    vmov r2, r4, d3
; CHECK-NEXT:    vmov q0[3], q0[1], r6, r5
; CHECK-NEXT:    vmov r6, r5, d2
; CHECK-NEXT:    ldr r2, [r2]
; CHECK-NEXT:    ldr r6, [r6]
; CHECK-NEXT:    ldr r5, [r5]
; CHECK-NEXT:    vmov q1[2], q1[0], r6, r2
; CHECK-NEXT:    ldr r6, [r4]
; CHECK-NEXT:    vmov r0, r2, d5
; CHECK-NEXT:    vmov q1[3], q1[1], r5, r6
; CHECK-NEXT:    vmov r6, r5, d4
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    ldr r6, [r6]
; CHECK-NEXT:    ldr r2, [r2]
; CHECK-NEXT:    ldr r5, [r5]
; CHECK-NEXT:    vmov q2[2], q2[0], r6, r0
; CHECK-NEXT:    vmov q2[3], q2[1], r5, r2
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %offs = load <16 x i32*>, <16 x i32*>* %offptr, align 4
  %gather = call <16 x i32> @llvm.masked.gather.v16i32.v16p0i32(<16 x i32*> %offs, i32 4, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <16 x i32> undef)
  ret <16 x i32> %gather
}

; f32

define arm_aapcs_vfpcc <2 x float> @ptr_v2f32(<2 x float*>* %offptr) {
; CHECK-LABEL: ptr_v2f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldrd r1, r0, [r0]
; CHECK-NEXT:    vldr s1, [r0]
; CHECK-NEXT:    vldr s0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <2 x float*>, <2 x float*>* %offptr, align 4
  %gather = call <2 x float> @llvm.masked.gather.v2f32.v2p0f32(<2 x float*> %offs, i32 4, <2 x i1> <i1 true, i1 true>, <2 x float> undef)
  ret <2 x float> %gather
}

define arm_aapcs_vfpcc <4 x float> @ptr_v4f32(<4 x float*>* %offptr) {
; CHECK-LABEL: ptr_v4f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vldrw.u32 q0, [q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x float*>, <4 x float*>* %offptr, align 4
  %gather = call <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*> %offs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x float> undef)
  ret <4 x float> %gather
}

define arm_aapcs_vfpcc <8 x float> @ptr_v8f32(<8 x float*>* %offptr) {
; CHECK-LABEL: ptr_v8f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r12, r2, d1
; CHECK-NEXT:    vmov lr, r1, d0
; CHECK-NEXT:    vldrw.u32 q0, [r0, #16]
; CHECK-NEXT:    vmov r0, r3, d1
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vldr s3, [r2]
; CHECK-NEXT:    vldr s2, [r12]
; CHECK-NEXT:    vldr s1, [r1]
; CHECK-NEXT:    vldr s0, [lr]
; CHECK-NEXT:    vldr s7, [r3]
; CHECK-NEXT:    vldr s6, [r0]
; CHECK-NEXT:    vldr s5, [r5]
; CHECK-NEXT:    vldr s4, [r4]
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x float*>, <8 x float*>* %offptr, align 4
  %gather = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %offs, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef)
  ret <8 x float> %gather
}

; i16

define arm_aapcs_vfpcc <8 x i16> @ptr_i16(<8 x i16*>* %offptr) {
; CHECK-LABEL: ptr_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, lr}
; CHECK-NEXT:    push {r4, r5, r6, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0, #16]
; CHECK-NEXT:    vmov r1, r2, d0
; CHECK-NEXT:    vmov r3, r12, d1
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov r0, lr, d1
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    ldrh r6, [r3]
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    ldrh r4, [r4]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrh.w r3, [lr]
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    ldrh.w r12, [r12]
; CHECK-NEXT:    vmov.16 q0[3], r3
; CHECK-NEXT:    vmov.16 q0[4], r1
; CHECK-NEXT:    vmov.16 q0[5], r2
; CHECK-NEXT:    vmov.16 q0[6], r6
; CHECK-NEXT:    vmov.16 q0[7], r12
; CHECK-NEXT:    pop {r4, r5, r6, pc}
entry:
  %offs = load <8 x i16*>, <8 x i16*>* %offptr, align 4
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %offs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <2 x i32> @ptr_v2i16_sext(<2 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v2i16_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldrd r1, r0, [r0]
; CHECK-NEXT:    ldrsh.w r0, [r0]
; CHECK-NEXT:    ldrsh.w r1, [r1]
; CHECK-NEXT:    vmov q0[2], q0[0], r1, r0
; CHECK-NEXT:    asrs r0, r0, #31
; CHECK-NEXT:    asrs r1, r1, #31
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r0
; CHECK-NEXT:    bx lr
entry:
  %offs = load <2 x i16*>, <2 x i16*>* %offptr, align 4
  %gather = call <2 x i16> @llvm.masked.gather.v2i16.v2p0i16(<2 x i16*> %offs, i32 2, <2 x i1> <i1 true, i1 true>, <2 x i16> undef)
  %ext = sext <2 x i16> %gather to <2 x i32>
  ret <2 x i32> %ext
}

define arm_aapcs_vfpcc <2 x i32> @ptr_v2i16_zext(<2 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v2i16_zext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldrd r1, r0, [r0]
; CHECK-NEXT:    vmov.i64 q0, #0xffff
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vand q0, q1, q0
; CHECK-NEXT:    bx lr
entry:
  %offs = load <2 x i16*>, <2 x i16*>* %offptr, align 4
  %gather = call <2 x i16> @llvm.masked.gather.v2i16.v2p0i16(<2 x i16*> %offs, i32 2, <2 x i1> <i1 true, i1 true>, <2 x i16> undef)
  %ext = zext <2 x i16> %gather to <2 x i32>
  ret <2 x i32> %ext
}

define arm_aapcs_vfpcc <4 x i32> @ptr_v4i16_sext(<4 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v4i16_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:    vldrh.s32 q0, [r1, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16*>, <4 x i16*>* %offptr, align 4
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %offs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %ext = sext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %ext
}

define arm_aapcs_vfpcc <4 x i32> @ptr_v4i16_zext(<4 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v4i16_zext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:    vldrh.u32 q0, [r1, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16*>, <4 x i16*>* %offptr, align 4
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %offs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %ext = zext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %ext
}

define arm_aapcs_vfpcc <4 x i16> @ptr_v4i16(<4 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v4i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:    vldrh.u32 q0, [r1, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16*>, <4 x i16*>* %offptr, align 4
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %offs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  ret <4 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i32> @ptr_v8i16_sext(<8 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v8i16_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    .pad #16
; CHECK-NEXT:    sub sp, #16
; CHECK-NEXT:    vldrw.u32 q0, [r0, #16]
; CHECK-NEXT:    vmov r3, r1, d1
; CHECK-NEXT:    vmov r12, r2, d0
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov lr, r0, d1
; CHECK-NEXT:    ldrh r7, [r1]
; CHECK-NEXT:    ldrh.w r1, [r12]
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    ldrh r4, [r0]
; CHECK-NEXT:    vmov r0, r5, d0
; CHECK-NEXT:    ldrh.w r6, [lr]
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r0
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    vmov.16 q0[2], r6
; CHECK-NEXT:    vmov.16 q0[3], r4
; CHECK-NEXT:    vmov.16 q0[4], r1
; CHECK-NEXT:    vmov.16 q0[5], r2
; CHECK-NEXT:    vmov.16 q0[6], r3
; CHECK-NEXT:    vmov.16 q0[7], r7
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    vldrh.s32 q0, [r0]
; CHECK-NEXT:    vldrh.s32 q1, [r0, #8]
; CHECK-NEXT:    add sp, #16
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %offs = load <8 x i16*>, <8 x i16*>* %offptr, align 4
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %offs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  %ext = sext <8 x i16> %gather to <8 x i32>
  ret <8 x i32> %ext
}

define arm_aapcs_vfpcc <8 x i32> @ptr_v8i16_zext(<8 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v8i16_zext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    .pad #16
; CHECK-NEXT:    sub sp, #16
; CHECK-NEXT:    vldrw.u32 q0, [r0, #16]
; CHECK-NEXT:    vmov r3, r1, d1
; CHECK-NEXT:    vmov r12, r2, d0
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov lr, r0, d1
; CHECK-NEXT:    ldrh r7, [r1]
; CHECK-NEXT:    ldrh.w r1, [r12]
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    ldrh r4, [r0]
; CHECK-NEXT:    vmov r0, r5, d0
; CHECK-NEXT:    ldrh.w r6, [lr]
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r0
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    vmov.16 q0[2], r6
; CHECK-NEXT:    vmov.16 q0[3], r4
; CHECK-NEXT:    vmov.16 q0[4], r1
; CHECK-NEXT:    vmov.16 q0[5], r2
; CHECK-NEXT:    vmov.16 q0[6], r3
; CHECK-NEXT:    vmov.16 q0[7], r7
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    vldrh.u32 q0, [r0]
; CHECK-NEXT:    vldrh.u32 q1, [r0, #8]
; CHECK-NEXT:    add sp, #16
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %offs = load <8 x i16*>, <8 x i16*>* %offptr, align 4
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %offs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  %ext = zext <8 x i16> %gather to <8 x i32>
  ret <8 x i32> %ext
}

; f16

define arm_aapcs_vfpcc <8 x half> @ptr_f16(<8 x half*>* %offptr) {
; CHECK-LABEL: ptr_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r1, r2, d0
; CHECK-NEXT:    vldr.16 s4, [r2]
; CHECK-NEXT:    vldr.16 s0, [r1]
; CHECK-NEXT:    vmov r1, r2, d1
; CHECK-NEXT:    vins.f16 s0, s4
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vldr.16 s1, [r1]
; CHECK-NEXT:    vldr.16 s2, [r2]
; CHECK-NEXT:    vmov r0, r1, d2
; CHECK-NEXT:    vins.f16 s1, s2
; CHECK-NEXT:    vldr.16 s4, [r1]
; CHECK-NEXT:    vldr.16 s2, [r0]
; CHECK-NEXT:    vmov r0, r1, d3
; CHECK-NEXT:    vldr.16 s3, [r0]
; CHECK-NEXT:    vins.f16 s2, s4
; CHECK-NEXT:    vldr.16 s4, [r1]
; CHECK-NEXT:    vins.f16 s3, s4
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x half*>, <8 x half*>* %offptr, align 4
  %gather = call <8 x half> @llvm.masked.gather.v8f16.v8p0f16(<8 x half*> %offs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x half> undef)
  ret <8 x half> %gather
}

define arm_aapcs_vfpcc <4 x half> @ptr_v4f16(<4 x half*>* %offptr) {
; CHECK-LABEL: ptr_v4f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vldr.16 s4, [r1]
; CHECK-NEXT:    vldr.16 s0, [r0]
; CHECK-NEXT:    vmov r0, r1, d1
; CHECK-NEXT:    vldr.16 s2, [r1]
; CHECK-NEXT:    vldr.16 s1, [r0]
; CHECK-NEXT:    vins.f16 s0, s4
; CHECK-NEXT:    vins.f16 s1, s2
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x half*>, <4 x half*>* %offptr, align 4
  %gather = call <4 x half> @llvm.masked.gather.v4f16.v4p0f16(<4 x half*> %offs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x half> undef)
  ret <4 x half> %gather
}

; i8

define arm_aapcs_vfpcc <16 x i8> @ptr_i8(<16 x i8*>* %offptr) {
; CHECK-LABEL: ptr_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0, #48]
; CHECK-NEXT:    vldrw.u32 q2, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #32]
; CHECK-NEXT:    vmov r1, r2, d0
; CHECK-NEXT:    vmov r6, r7, d4
; CHECK-NEXT:    vmov r4, r3, d1
; CHECK-NEXT:    ldrb r5, [r1]
; CHECK-NEXT:    ldrb r1, [r2]
; CHECK-NEXT:    ldrb r2, [r6]
; CHECK-NEXT:    ldrb.w r12, [r3]
; CHECK-NEXT:    vmov.8 q0[0], r2
; CHECK-NEXT:    vmov r2, r3, d3
; CHECK-NEXT:    ldrb.w lr, [r4]
; CHECK-NEXT:    ldrb r4, [r2]
; CHECK-NEXT:    ldrb r2, [r3]
; CHECK-NEXT:    ldrb r3, [r7]
; CHECK-NEXT:    vmov.8 q0[1], r3
; CHECK-NEXT:    vmov r3, r6, d5
; CHECK-NEXT:    vldrw.u32 q2, [r0, #16]
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    ldrb r6, [r6]
; CHECK-NEXT:    vmov.8 q0[2], r3
; CHECK-NEXT:    vmov r0, r3, d4
; CHECK-NEXT:    vmov.8 q0[3], r6
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    vmov.8 q0[4], r0
; CHECK-NEXT:    vmov.8 q0[5], r3
; CHECK-NEXT:    vmov r0, r3, d5
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    vmov.8 q0[6], r0
; CHECK-NEXT:    vmov.8 q0[7], r3
; CHECK-NEXT:    vmov r0, r3, d2
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    vmov.8 q0[8], r0
; CHECK-NEXT:    vmov.8 q0[9], r3
; CHECK-NEXT:    vmov.8 q0[10], r4
; CHECK-NEXT:    vmov.8 q0[11], r2
; CHECK-NEXT:    vmov.8 q0[12], r5
; CHECK-NEXT:    vmov.8 q0[13], r1
; CHECK-NEXT:    vmov.8 q0[14], lr
; CHECK-NEXT:    vmov.8 q0[15], r12
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %offs = load <16 x i8*>, <16 x i8*>* %offptr, align 4
  %gather = call <16 x i8> @llvm.masked.gather.v16i8.v16p0i8(<16 x i8*> %offs, i32 2, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <16 x i8> undef)
  ret <16 x i8> %gather
}

define arm_aapcs_vfpcc <8 x i16> @ptr_v8i8_sext16(<8 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v8i8_sext16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0, #16]
; CHECK-NEXT:    vmov r3, r1, d1
; CHECK-NEXT:    vmov r12, r2, d0
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov lr, r0, d1
; CHECK-NEXT:    ldrb r7, [r1]
; CHECK-NEXT:    ldrb.w r1, [r12]
; CHECK-NEXT:    ldrb r2, [r2]
; CHECK-NEXT:    ldrb r4, [r4]
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    ldrb.w r6, [lr]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov.16 q0[2], r6
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    vmov.16 q0[3], r0
; CHECK-NEXT:    vmov.16 q0[4], r1
; CHECK-NEXT:    vmov.16 q0[5], r2
; CHECK-NEXT:    vmov.16 q0[6], r3
; CHECK-NEXT:    vmov.16 q0[7], r7
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %offs = load <8 x i8*>, <8 x i8*>* %offptr, align 4
  %gather = call <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*> %offs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i8> undef)
  %ext = sext <8 x i8> %gather to <8 x i16>
  ret <8 x i16> %ext
}

define arm_aapcs_vfpcc <8 x i16> @ptr_v8i8_zext16(<8 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v8i8_zext16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0, #16]
; CHECK-NEXT:    vmov r3, r1, d1
; CHECK-NEXT:    vmov r12, r2, d0
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov lr, r0, d1
; CHECK-NEXT:    ldrb r7, [r1]
; CHECK-NEXT:    ldrb.w r1, [r12]
; CHECK-NEXT:    ldrb r2, [r2]
; CHECK-NEXT:    ldrb r4, [r4]
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    ldrb.w r6, [lr]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov.16 q0[2], r6
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    vmov.16 q0[3], r0
; CHECK-NEXT:    vmov.16 q0[4], r1
; CHECK-NEXT:    vmov.16 q0[5], r2
; CHECK-NEXT:    vmov.16 q0[6], r3
; CHECK-NEXT:    vmov.16 q0[7], r7
; CHECK-NEXT:    vmovlb.u8 q0, q0
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %offs = load <8 x i8*>, <8 x i8*>* %offptr, align 4
  %gather = call <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*> %offs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i8> undef)
  %ext = zext <8 x i8> %gather to <8 x i16>
  ret <8 x i16> %ext
}

define arm_aapcs_vfpcc <8 x i8> @ptr_v8i8(<8 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v8i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, lr}
; CHECK-NEXT:    push {r4, r5, r6, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0, #16]
; CHECK-NEXT:    vmov r1, r2, d0
; CHECK-NEXT:    vmov r3, r12, d1
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov r0, lr, d1
; CHECK-NEXT:    ldrb r1, [r1]
; CHECK-NEXT:    ldrb r6, [r3]
; CHECK-NEXT:    ldrb r2, [r2]
; CHECK-NEXT:    ldrb r4, [r4]
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrb.w r3, [lr]
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    ldrb.w r12, [r12]
; CHECK-NEXT:    vmov.16 q0[3], r3
; CHECK-NEXT:    vmov.16 q0[4], r1
; CHECK-NEXT:    vmov.16 q0[5], r2
; CHECK-NEXT:    vmov.16 q0[6], r6
; CHECK-NEXT:    vmov.16 q0[7], r12
; CHECK-NEXT:    pop {r4, r5, r6, pc}
entry:
  %offs = load <8 x i8*>, <8 x i8*>* %offptr, align 4
  %gather = call <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*> %offs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i8> undef)
  ret <8 x i8> %gather
}

define arm_aapcs_vfpcc <4 x i32> @ptr_v4i8_sext32(<4 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v4i8_sext32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:    vldrb.s32 q0, [r1, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8*>, <4 x i8*>* %offptr, align 4
  %gather = call <4 x i8> @llvm.masked.gather.v4i8.v4p0i8(<4 x i8*> %offs, i32 1, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i8> undef)
  %ext = sext <4 x i8> %gather to <4 x i32>
  ret <4 x i32> %ext
}

define arm_aapcs_vfpcc <4 x i32> @ptr_v4i8_zext32(<4 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v4i8_zext32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:    vldrb.u32 q0, [r1, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8*>, <4 x i8*>* %offptr, align 4
  %gather = call <4 x i8> @llvm.masked.gather.v4i8.v4p0i8(<4 x i8*> %offs, i32 1, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i8> undef)
  %ext = zext <4 x i8> %gather to <4 x i32>
  ret <4 x i32> %ext
}

define arm_aapcs_vfpcc <4 x i8> @ptr_v4i8(<4 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v4i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:    vldrb.u32 q0, [r1, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8*>, <4 x i8*>* %offptr, align 4
  %gather = call <4 x i8> @llvm.masked.gather.v4i8.v4p0i8(<4 x i8*> %offs, i32 1, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i8> undef)
  ret <4 x i8> %gather
}

define arm_aapcs_vfpcc <8 x i32> @ptr_v8i8_sext32(<8 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v8i8_sext32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0, #16]
; CHECK-NEXT:    vmov r1, r2, d1
; CHECK-NEXT:    vmov r3, r12, d0
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r0, lr, d1
; CHECK-NEXT:    ldrb r7, [r2]
; CHECK-NEXT:    vmov r2, r4, d0
; CHECK-NEXT:    ldrb r6, [r1]
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    ldrb.w r1, [r12]
; CHECK-NEXT:    vmov q1[2], q1[0], r3, r6
; CHECK-NEXT:    ldrb.w r5, [lr]
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r7
; CHECK-NEXT:    vmovlb.s8 q1, q1
; CHECK-NEXT:    vmovlb.s16 q1, q1
; CHECK-NEXT:    ldrb r2, [r2]
; CHECK-NEXT:    ldrb r4, [r4]
; CHECK-NEXT:    vmov q0[2], q0[0], r2, r0
; CHECK-NEXT:    vmov q0[3], q0[1], r4, r5
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %offs = load <8 x i8*>, <8 x i8*>* %offptr, align 4
  %gather = call <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*> %offs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i8> undef)
  %ext = sext <8 x i8> %gather to <8 x i32>
  ret <8 x i32> %ext
}

define arm_aapcs_vfpcc <8 x i32> @ptr_v8i8_zext32(<8 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v8i8_zext32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0, #16]
; CHECK-NEXT:    vmov.i32 q1, #0xff
; CHECK-NEXT:    vmov r1, r2, d1
; CHECK-NEXT:    vmov r12, r3, d0
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov r0, lr, d1
; CHECK-NEXT:    ldrb r7, [r2]
; CHECK-NEXT:    ldrb r1, [r1]
; CHECK-NEXT:    ldrb.w r2, [r12]
; CHECK-NEXT:    ldrb r4, [r4]
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov q2[2], q2[0], r2, r1
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    ldrb.w r6, [lr]
; CHECK-NEXT:    vmov q0[2], q0[0], r4, r0
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    vmov q2[3], q2[1], r3, r7
; CHECK-NEXT:    vmov q0[3], q0[1], r5, r6
; CHECK-NEXT:    vand q0, q0, q1
; CHECK-NEXT:    vand q1, q2, q1
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %offs = load <8 x i8*>, <8 x i8*>* %offptr, align 4
  %gather = call <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*> %offs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i8> undef)
  %ext = zext <8 x i8> %gather to <8 x i32>
  ret <8 x i32> %ext
}

; loops

define void @foo_ptr_p_int32_t(i32* %dest, i32** %src, i32 %n) {
; CHECK-LABEL: foo_ptr_p_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r2, r2, #15
; CHECK-NEXT:    cmp r2, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:  .LBB26_1: @ %vector.body.preheader
; CHECK-NEXT:    subs r2, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r2, lsr #2
; CHECK-NEXT:  .LBB26_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r1], #16
; CHECK-NEXT:    vptt.i32 ne, q0, zr
; CHECK-NEXT:    vldrwt.u32 q1, [q0]
; CHECK-NEXT:    vstrwt.32 q1, [r0], #16
; CHECK-NEXT:    le lr, .LBB26_2
; CHECK-NEXT:  @ %bb.3: @ %for.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %and = and i32 %n, -16
  %cmp11 = icmp sgt i32 %and, 0
  br i1 %cmp11, label %vector.body, label %for.end

vector.body:                                      ; preds = %entry, %vector.body
  %index = phi i32 [ %index.next, %vector.body ], [ 0, %entry ]
  %0 = getelementptr inbounds i32*, i32** %src, i32 %index
  %1 = bitcast i32** %0 to <4 x i32*>*
  %wide.load = load <4 x i32*>, <4 x i32*>* %1, align 4
  %2 = icmp ne <4 x i32*> %wide.load, zeroinitializer
  %wide.masked.gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %wide.load, i32 4, <4 x i1> %2, <4 x i32> undef)
  %3 = getelementptr inbounds i32, i32* %dest, i32 %index
  %4 = bitcast i32* %3 to <4 x i32>*
  call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> %wide.masked.gather, <4 x i32>* %4, i32 4, <4 x i1> %2)
  %index.next = add i32 %index, 4
  %5 = icmp eq i32 %index.next, %and
  br i1 %5, label %for.end, label %vector.body

for.end:                                          ; preds = %vector.body, %entry
  ret void
}

define void @foo_ptr_p_float(float* %dest, float** %src, i32 %n) {
; CHECK-LABEL: foo_ptr_p_float:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r2, r2, #15
; CHECK-NEXT:    cmp r2, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:  .LBB27_1: @ %vector.body.preheader
; CHECK-NEXT:    subs r2, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r2, lsr #2
; CHECK-NEXT:  .LBB27_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r1], #16
; CHECK-NEXT:    vptt.i32 ne, q0, zr
; CHECK-NEXT:    vldrwt.u32 q1, [q0]
; CHECK-NEXT:    vstrwt.32 q1, [r0], #16
; CHECK-NEXT:    le lr, .LBB27_2
; CHECK-NEXT:  @ %bb.3: @ %for.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %and = and i32 %n, -16
  %cmp11 = icmp sgt i32 %and, 0
  br i1 %cmp11, label %vector.body, label %for.end

vector.body:                                      ; preds = %entry, %vector.body
  %index = phi i32 [ %index.next, %vector.body ], [ 0, %entry ]
  %0 = getelementptr inbounds float*, float** %src, i32 %index
  %1 = bitcast float** %0 to <4 x float*>*
  %wide.load = load <4 x float*>, <4 x float*>* %1, align 4
  %2 = icmp ne <4 x float*> %wide.load, zeroinitializer
  %3 = bitcast <4 x float*> %wide.load to <4 x i32*>
  %wide.masked.gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %3, i32 4, <4 x i1> %2, <4 x i32> undef)
  %4 = getelementptr inbounds float, float* %dest, i32 %index
  %5 = bitcast float* %4 to <4 x i32>*
  call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> %wide.masked.gather, <4 x i32>* %5, i32 4, <4 x i1> %2)
  %index.next = add i32 %index, 4
  %6 = icmp eq i32 %index.next, %and
  br i1 %6, label %for.end, label %vector.body

for.end:                                          ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc <4 x i32> @qi4(<4 x i32*> %p) {
; CHECK-LABEL: qi4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r0, #16
; CHECK-NEXT:    vadd.i32 q1, q0, r0
; CHECK-NEXT:    vldrw.u32 q0, [q1]
; CHECK-NEXT:    bx lr
entry:
  %g = getelementptr inbounds i32, <4 x i32*> %p, i32 4
  %gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %g, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef)
  ret <4 x i32> %gather
}

define arm_aapcs_vfpcc <8 x i32> @sext_unsigned_unscaled_i8_i8_toi64(i8* %base, <8 x i8>* %offptr) {
; CHECK-LABEL: sext_unsigned_unscaled_i8_i8_toi64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r1]
; CHECK-NEXT:    vldrb.u16 q1, [r0, q0]
; CHECK-NEXT:    vmov.u16 r0, q1[2]
; CHECK-NEXT:    vmov.u16 r1, q1[0]
; CHECK-NEXT:    vmov q0[2], q0[0], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q1[3]
; CHECK-NEXT:    vmov.u16 r1, q1[1]
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q1[6]
; CHECK-NEXT:    vmov.u16 r1, q1[4]
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    vmov q2[2], q2[0], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q1[7]
; CHECK-NEXT:    vmov.u16 r1, q1[5]
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    vmov q2[3], q2[1], r1, r0
; CHECK-NEXT:    vmovlb.s8 q1, q2
; CHECK-NEXT:    vmovlb.s16 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.zext = zext <8 x i8> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.zext
  %gather = call <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*> %ptrs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i8> undef)
  %gather.sext = sext <8 x i8> %gather to <8 x i32>
  ret <8 x i32> %gather.sext
}

define arm_aapcs_vfpcc <4 x i32> @gepconstoff_i32(i32* %base) {
; CHECK-LABEL: gepconstoff_i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    adr r1, .LCPI30_0
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vldrw.u32 q0, [r0, q1, uxtw #2]
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI30_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 4 @ 0x4
; CHECK-NEXT:    .long 8 @ 0x8
; CHECK-NEXT:    .long 12 @ 0xc
  %a = getelementptr i32, i32* %base, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %g = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %a, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> poison)
  ret <4 x i32> %g
}

define arm_aapcs_vfpcc <4 x i32> @gepconstoff_i8(i8* %base) {
; CHECK-STD-LABEL: gepconstoff_i8:
; CHECK-STD:       @ %bb.0:
; CHECK-STD-NEXT:    adr r1, .LCPI31_0
; CHECK-STD-NEXT:    vldrw.u32 q0, [r1]
; CHECK-STD-NEXT:    vadd.i32 q1, q0, r0
; CHECK-STD-NEXT:    vldrw.u32 q0, [q1]
; CHECK-STD-NEXT:    bx lr
; CHECK-STD-NEXT:    .p2align 4
; CHECK-STD-NEXT:  @ %bb.1:
; CHECK-STD-NEXT:  .LCPI31_0:
; CHECK-STD-NEXT:    .long 4294967292 @ 0xfffffffc
; CHECK-STD-NEXT:    .long 12 @ 0xc
; CHECK-STD-NEXT:    .long 28 @ 0x1c
; CHECK-STD-NEXT:    .long 44 @ 0x2c
;
; CHECK-OPAQ-LABEL: gepconstoff_i8:
; CHECK-OPAQ:       @ %bb.0:
; CHECK-OPAQ-NEXT:    adr r1, .LCPI31_0
; CHECK-OPAQ-NEXT:    vldrw.u32 q1, [r1]
; CHECK-OPAQ-NEXT:    vldrw.u32 q0, [r0, q1]
; CHECK-OPAQ-NEXT:    bx lr
; CHECK-OPAQ-NEXT:    .p2align 4
; CHECK-OPAQ-NEXT:  @ %bb.1:
; CHECK-OPAQ-NEXT:  .LCPI31_0:
; CHECK-OPAQ-NEXT:    .long 4294967292 @ 0xfffffffc
; CHECK-OPAQ-NEXT:    .long 12 @ 0xc
; CHECK-OPAQ-NEXT:    .long 28 @ 0x1c
; CHECK-OPAQ-NEXT:    .long 44 @ 0x2c
  %a = getelementptr i8, i8* %base, <4 x i32> <i32 0, i32 16, i32 32, i32 48>
  %b = bitcast <4 x i8*> %a to <4 x i32*>
  %c = getelementptr inbounds i32, <4 x i32*> %b, i32 -1
  %g = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %c, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> poison)
  ret <4 x i32> %g
}

define arm_aapcs_vfpcc <4 x i32> @gepconstoff3_i16(i16* %base) {
; CHECK-STD-LABEL: gepconstoff3_i16:
; CHECK-STD:       @ %bb.0:
; CHECK-STD-NEXT:    adr r1, .LCPI32_0
; CHECK-STD-NEXT:    vldrw.u32 q0, [r1]
; CHECK-STD-NEXT:    vadd.i32 q1, q0, r0
; CHECK-STD-NEXT:    vldrw.u32 q0, [q1]
; CHECK-STD-NEXT:    bx lr
; CHECK-STD-NEXT:    .p2align 4
; CHECK-STD-NEXT:  @ %bb.1:
; CHECK-STD-NEXT:  .LCPI32_0:
; CHECK-STD-NEXT:    .long 12 @ 0xc
; CHECK-STD-NEXT:    .long 18 @ 0x12
; CHECK-STD-NEXT:    .long 58 @ 0x3a
; CHECK-STD-NEXT:    .long 280 @ 0x118
;
; CHECK-OPAQ-LABEL: gepconstoff3_i16:
; CHECK-OPAQ:       @ %bb.0:
; CHECK-OPAQ-NEXT:    adr r1, .LCPI32_0
; CHECK-OPAQ-NEXT:    vldrw.u32 q1, [r1]
; CHECK-OPAQ-NEXT:    vldrw.u32 q0, [r0, q1]
; CHECK-OPAQ-NEXT:    bx lr
; CHECK-OPAQ-NEXT:    .p2align 4
; CHECK-OPAQ-NEXT:  @ %bb.1:
; CHECK-OPAQ-NEXT:  .LCPI32_0:
; CHECK-OPAQ-NEXT:    .long 12 @ 0xc
; CHECK-OPAQ-NEXT:    .long 18 @ 0x12
; CHECK-OPAQ-NEXT:    .long 58 @ 0x3a
; CHECK-OPAQ-NEXT:    .long 280 @ 0x118
  %a = getelementptr i16, i16* %base, <4 x i32> <i32 0, i32 16, i32 32, i32 48>
  %b = bitcast <4 x i16*> %a to <4 x i8*>
  %c = getelementptr i8, <4 x i8*> %b, <4 x i32> <i32 16, i32 -10, i32 -2, i32 188>
  %d = bitcast <4 x i8*> %c to <4 x i32*>
  %e = getelementptr inbounds i32, <4 x i32*> %d, i32 -1
  %g = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %e, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> poison)
  ret <4 x i32> %g
}

declare <2 x i32> @llvm.masked.gather.v2i32.v2p0i32(<2 x i32*>, i32, <2 x i1>, <2 x i32>)
declare <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*>, i32, <4 x i1>, <4 x i32>)
declare <8 x i32> @llvm.masked.gather.v8i32.v8p0i32(<8 x i32*>, i32, <8 x i1>, <8 x i32>)
declare <16 x i32> @llvm.masked.gather.v16i32.v16p0i32(<16 x i32*>, i32, <16 x i1>, <16 x i32>)
declare <2 x float> @llvm.masked.gather.v2f32.v2p0f32(<2 x float*>, i32, <2 x i1>, <2 x float>)
declare <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*>, i32, <4 x i1>, <4 x float>)
declare <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*>, i32, <8 x i1>, <8 x float>)
declare <2 x i16> @llvm.masked.gather.v2i16.v2p0i16(<2 x i16*>, i32, <2 x i1>, <2 x i16>)
declare <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*>, i32, <4 x i1>, <4 x i16>)
declare <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*>, i32, <8 x i1>, <8 x i16>)
declare <16 x i16> @llvm.masked.gather.v16i16.v16p0i16(<16 x i16*>, i32, <16 x i1>, <16 x i16>)
declare <4 x half> @llvm.masked.gather.v4f16.v4p0f16(<4 x half*>, i32, <4 x i1>, <4 x half>)
declare <8 x half> @llvm.masked.gather.v8f16.v8p0f16(<8 x half*>, i32, <8 x i1>, <8 x half>)
declare <16 x half> @llvm.masked.gather.v16f16.v16p0f16(<16 x half*>, i32, <16 x i1>, <16 x half>)
declare <4 x i8> @llvm.masked.gather.v4i8.v4p0i8(<4 x i8*>, i32, <4 x i1>, <4 x i8>)
declare <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*>, i32, <8 x i1>, <8 x i8>)
declare <16 x i8> @llvm.masked.gather.v16i8.v16p0i8(<16 x i8*>, i32, <16 x i1>, <16 x i8>)
declare <32 x i8> @llvm.masked.gather.v32i8.v32p0i8(<32 x i8*>, i32, <32 x i1>, <32 x i8>)
declare void @llvm.masked.store.v4i32.p0v4i32(<4 x i32>, <4 x i32>*, i32, <4 x i1>)
