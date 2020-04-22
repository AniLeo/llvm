; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -enable-arm-maskedldst -enable-arm-maskedgatscat %s -o - | FileCheck %s

; i32

; Expand
define arm_aapcs_vfpcc void @ptr_v2i32(<2 x i32> %v, <2 x i32*>* %offptr) {
; CHECK-LABEL: ptr_v2i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    ldrd r1, r0, [r0]
; CHECK-NEXT:    str r2, [r1]
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <2 x i32*>, <2 x i32*>* %offptr, align 4
  call void @llvm.masked.scatter.v2i32.v2p0i32(<2 x i32> %v, <2 x i32*> %offs, i32 4, <2 x i1> <i1 true, i1 true>)
  ret void
}

; VSTRW.32 Qd, [offs, 0]
define arm_aapcs_vfpcc void @ptr_v4i32(<4 x i32> %v, <4 x i32*>* %offptr) {
; CHECK-LABEL: ptr_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vstrw.32 q0, [q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i32*>, <4 x i32*>* %offptr, align 4
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %v, <4 x i32*> %offs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @ptr_v8i32(<8 x i32> %v, <8 x i32*>* %offptr) {
; CHECK-LABEL: ptr_v8i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    vldrw.u32 q2, [r0, #16]
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vmov r0, s12
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s13
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s14
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s15
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmov r1, s4
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s10
; CHECK-NEXT:    vmov r1, s6
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    vmov r1, s7
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i32*>, <8 x i32*>* %offptr, align 4
  call void @llvm.masked.scatter.v8i32.v8p0i32(<8 x i32> %v, <8 x i32*> %offs, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @ptr_v16i32(<16 x i32> %v, <16 x i32*>* %offptr) {
; CHECK-LABEL: ptr_v16i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9, d10, d11, d12, d13, d14, d15}
; CHECK-NEXT:    vpush {d8, d9, d10, d11, d12, d13, d14, d15}
; CHECK-NEXT:    vldrw.u32 q7, [r0]
; CHECK-NEXT:    vldrw.u32 q4, [r0, #48]
; CHECK-NEXT:    vldrw.u32 q5, [r0, #32]
; CHECK-NEXT:    vldrw.u32 q6, [r0, #16]
; CHECK-NEXT:    vmov r0, s28
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s29
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s30
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s31
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s24
; CHECK-NEXT:    vmov r1, s4
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s25
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s26
; CHECK-NEXT:    vmov r1, s6
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s27
; CHECK-NEXT:    vmov r1, s7
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s20
; CHECK-NEXT:    vmov r1, s8
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s21
; CHECK-NEXT:    vmov r1, s9
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s22
; CHECK-NEXT:    vmov r1, s10
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s23
; CHECK-NEXT:    vmov r1, s11
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s16
; CHECK-NEXT:    vmov r1, s12
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s17
; CHECK-NEXT:    vmov r1, s13
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s18
; CHECK-NEXT:    vmov r1, s14
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vmov r0, s19
; CHECK-NEXT:    vmov r1, s15
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    vpop {d8, d9, d10, d11, d12, d13, d14, d15}
; CHECK-NEXT:    bx lr
entry:
  %offs = load <16 x i32*>, <16 x i32*>* %offptr, align 4
  call void @llvm.masked.scatter.v16i32.v16p0i32(<16 x i32> %v, <16 x i32*> %offs, i32 4, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; f32

; Expand
define arm_aapcs_vfpcc void @ptr_v2f32(<2 x float> %v, <2 x float*>* %offptr) {
; CHECK-LABEL: ptr_v2f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldrd r1, r0, [r0]
; CHECK-NEXT:    vstr s0, [r1]
; CHECK-NEXT:    vstr s1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <2 x float*>, <2 x float*>* %offptr, align 4
  call void @llvm.masked.scatter.v2f32.v2p0f32(<2 x float> %v, <2 x float*> %offs, i32 4, <2 x i1> <i1 true, i1 true>)
  ret void
}

; VSTRW.32 Qd, [offs, 0]
define arm_aapcs_vfpcc void @ptr_v4f32(<4 x float> %v, <4 x float*>* %offptr) {
; CHECK-LABEL: ptr_v4f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vstrw.32 q0, [q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x float*>, <4 x float*>* %offptr, align 4
  call void @llvm.masked.scatter.v4f32.v4p0f32(<4 x float> %v, <4 x float*> %offs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @ptr_v8f32(<8 x float> %v, <8 x float*>* %offptr) {
; CHECK-LABEL: ptr_v8f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrw.u32 q2, [r0, #16]
; CHECK-NEXT:    vmov r12, s11
; CHECK-NEXT:    vmov lr, s10
; CHECK-NEXT:    vmov r3, s9
; CHECK-NEXT:    vmov r1, s8
; CHECK-NEXT:    vldrw.u32 q2, [r0]
; CHECK-NEXT:    vmov r5, s8
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    vmov r2, s10
; CHECK-NEXT:    vmov r4, s9
; CHECK-NEXT:    vstr s0, [r5]
; CHECK-NEXT:    vstr s1, [r4]
; CHECK-NEXT:    vstr s2, [r2]
; CHECK-NEXT:    vstr s3, [r0]
; CHECK-NEXT:    vstr s4, [r1]
; CHECK-NEXT:    vstr s5, [r3]
; CHECK-NEXT:    vstr s6, [lr]
; CHECK-NEXT:    vstr s7, [r12]
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x float*>, <8 x float*>* %offptr, align 4
  call void @llvm.masked.scatter.v8f32.v8p0f32(<8 x float> %v, <8 x float*> %offs, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; i16

; Expand.
define arm_aapcs_vfpcc void @ptr_i16(<8 x i16> %v, <8 x i16*>* %offptr) {
; CHECK-LABEL: ptr_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q2, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vmov.u16 r1, q0[0]
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    vmov.u16 r1, q0[1]
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s10
; CHECK-NEXT:    vmov.u16 r1, q0[2]
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    vmov.u16 r1, q0[3]
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov.u16 r1, q0[4]
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov.u16 r1, q0[5]
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov.u16 r1, q0[6]
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vmov.u16 r1, q0[7]
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16*>, <8 x i16*>* %offptr, align 4
  call void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16> %v, <8 x i16*> %offs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @ptr_v2i16_trunc(<2 x i32> %v, <2 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v2i16_trunc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    ldrd r1, r0, [r0]
; CHECK-NEXT:    strh r2, [r1]
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <2 x i16*>, <2 x i16*>* %offptr, align 4
  %ext = trunc <2 x i32> %v to <2 x i16>
  call void @llvm.masked.scatter.v2i16.v2p0i16(<2 x i16> %ext, <2 x i16*> %offs, i32 2, <2 x i1> <i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @ptr_v4i16_trunc(<4 x i32> %v, <4 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v4i16_trunc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16*>, <4 x i16*>* %offptr, align 4
  %ext = trunc <4 x i32> %v to <4 x i16>
  call void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16> %ext, <4 x i16*> %offs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @ptr_v8i16_trunc(<8 x i32> %v, <8 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v8i16_trunc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    vldrw.u32 q2, [r0, #16]
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vmov r0, s12
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s13
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s14
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s15
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmov r1, s4
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s10
; CHECK-NEXT:    vmov r1, s6
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    vmov r1, s7
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16*>, <8 x i16*>* %offptr, align 4
  %ext = trunc <8 x i32> %v to <8 x i16>
  call void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16> %ext, <8 x i16*> %offs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; f16

; Expand.
define arm_aapcs_vfpcc void @ptr_f16(<8 x half> %v, <8 x half*>* %offptr) {
; CHECK-LABEL: ptr_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q2, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vmovx.f16 s12, s0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    vstr.16 s12, [r0]
; CHECK-NEXT:    vmov r0, s10
; CHECK-NEXT:    vstr.16 s1, [r0]
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    vmovx.f16 s8, s1
; CHECK-NEXT:    vmovx.f16 s0, s3
; CHECK-NEXT:    vstr.16 s8, [r0]
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vstr.16 s2, [r0]
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmovx.f16 s8, s2
; CHECK-NEXT:    vstr.16 s8, [r0]
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vstr.16 s3, [r0]
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x half*>, <8 x half*>* %offptr, align 4
  call void @llvm.masked.scatter.v8f16.v8p0f16(<8 x half> %v, <8 x half*> %offs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; i8

; Expand.
define arm_aapcs_vfpcc void @ptr_i8(<16 x i8> %v, <16 x i8*>* %offptr) {
; CHECK-LABEL: ptr_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vldrw.u32 q4, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #48]
; CHECK-NEXT:    vldrw.u32 q2, [r0, #32]
; CHECK-NEXT:    vldrw.u32 q3, [r0, #16]
; CHECK-NEXT:    vmov r0, s16
; CHECK-NEXT:    vmov.u8 r1, q0[0]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s17
; CHECK-NEXT:    vmov.u8 r1, q0[1]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s18
; CHECK-NEXT:    vmov.u8 r1, q0[2]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s19
; CHECK-NEXT:    vmov.u8 r1, q0[3]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s12
; CHECK-NEXT:    vmov.u8 r1, q0[4]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s13
; CHECK-NEXT:    vmov.u8 r1, q0[5]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s14
; CHECK-NEXT:    vmov.u8 r1, q0[6]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s15
; CHECK-NEXT:    vmov.u8 r1, q0[7]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmov.u8 r1, q0[8]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    vmov.u8 r1, q0[9]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s10
; CHECK-NEXT:    vmov.u8 r1, q0[10]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    vmov.u8 r1, q0[11]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov.u8 r1, q0[12]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov.u8 r1, q0[13]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov.u8 r1, q0[14]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vmov.u8 r1, q0[15]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %offs = load <16 x i8*>, <16 x i8*>* %offptr, align 4
  call void @llvm.masked.scatter.v16i8.v16p0i8(<16 x i8> %v, <16 x i8*> %offs, i32 2, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @ptr_v8i8_trunc16(<8 x i16> %v, <8 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v8i8_trunc16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q2, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vmov.u16 r1, q0[0]
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    vmov.u16 r1, q0[1]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s10
; CHECK-NEXT:    vmov.u16 r1, q0[2]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    vmov.u16 r1, q0[3]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov.u16 r1, q0[4]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov.u16 r1, q0[5]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov.u16 r1, q0[6]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vmov.u16 r1, q0[7]
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8*>, <8 x i8*>* %offptr, align 4
  %ext = trunc <8 x i16> %v to <8 x i8>
  call void @llvm.masked.scatter.v8i8.v8p0i8(<8 x i8> %ext, <8 x i8*> %offs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @ptr_v4i8_trunc32(<4 x i32> %v, <4 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v4i8_trunc32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8*>, <4 x i8*>* %offptr, align 4
  %ext = trunc <4 x i32> %v to <4 x i8>
  call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> %ext, <4 x i8*> %offs, i32 1, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @ptr_v8i8_trunc32(<8 x i32> %v, <8 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v8i8_trunc32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    vldrw.u32 q2, [r0, #16]
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vmov r0, s12
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s13
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s14
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s15
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmov r1, s4
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s10
; CHECK-NEXT:    vmov r1, s6
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    vmov r1, s7
; CHECK-NEXT:    strb r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8*>, <8 x i8*>* %offptr, align 4
  %ext = trunc <8 x i32> %v to <8 x i8>
  call void @llvm.masked.scatter.v8i8.v8p0i8(<8 x i8> %ext, <8 x i8*> %offs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; loops

define void @foo_ptr_p_int32_t(i32* %dest, i32** %src, i32 %n) {
; CHECK-LABEL: foo_ptr_p_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bic r3, r2, #15
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    bxlt lr
; CHECK-NEXT:  .LBB16_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r1], #16
; CHECK-NEXT:    subs r2, #4
; CHECK-NEXT:    vptt.i32 ne, q0, zr
; CHECK-NEXT:    vldrwt.u32 q1, [r0], #16
; CHECK-NEXT:    vstrwt.32 q1, [q0]
; CHECK-NEXT:    bne .LBB16_1
; CHECK-NEXT:  @ %bb.2: @ %for.end
; CHECK-NEXT:    bx lr
entry:
  %and = and i32 %n, -16
  %cmp11 = icmp sgt i32 %and, 0
  br i1 %cmp11, label %vector.body, label %for.end

vector.body:                                      ; preds = %entry, %vector.body
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32*, i32** %src, i32 %index
  %1 = bitcast i32** %0 to <4 x i32*>*
  %wide.load = load <4 x i32*>, <4 x i32*>* %1, align 4
  %2 = icmp ne <4 x i32*> %wide.load, zeroinitializer
  %3 = getelementptr inbounds i32, i32* %dest, i32 %index
  %4 = bitcast i32* %3 to <4 x i32>*
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.v4p0i32(<4 x i32>* %4, i32 4, <4 x i1> %2, <4 x i32> undef)
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %wide.masked.load, <4 x i32*> %wide.load, i32 4, <4 x i1> %2)
  %index.next = add i32 %index, 4
  %5 = icmp eq i32 %index.next, %n
  br i1 %5, label %for.end, label %vector.body

for.end:                                          ; preds = %vector.body, %entry
  ret void
}

define void @foo_ptr_p_float(float* %dest, float** %src, i32 %n) {
; CHECK-LABEL: foo_ptr_p_float:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bic r3, r2, #15
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    bxlt lr
; CHECK-NEXT:  .LBB17_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r1], #16
; CHECK-NEXT:    subs r2, #4
; CHECK-NEXT:    vptt.i32 ne, q0, zr
; CHECK-NEXT:    vldrwt.u32 q1, [r0], #16
; CHECK-NEXT:    vstrwt.32 q1, [q0]
; CHECK-NEXT:    bne .LBB17_1
; CHECK-NEXT:  @ %bb.2: @ %for.end
; CHECK-NEXT:    bx lr
entry:
  %and = and i32 %n, -16
  %cmp11 = icmp sgt i32 %and, 0
  br i1 %cmp11, label %vector.body, label %for.end

vector.body:                                      ; preds = %entry, %vector.body
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds float*, float** %src, i32 %index
  %1 = bitcast float** %0 to <4 x float*>*
  %wide.load = load <4 x float*>, <4 x float*>* %1, align 4
  %2 = icmp ne <4 x float*> %wide.load, zeroinitializer
  %3 = getelementptr inbounds float, float* %dest, i32 %index
  %4 = bitcast float* %3 to <4 x i32>*
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.v4p0i32(<4 x i32>* %4, i32 4, <4 x i1> %2, <4 x i32> undef)
  %5 = bitcast <4 x float*> %wide.load to <4 x i32*>
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %wide.masked.load, <4 x i32*> %5, i32 4, <4 x i1> %2)
  %index.next = add i32 %index, 4
  %6 = icmp eq i32 %index.next, %n
  br i1 %6, label %for.end, label %vector.body

for.end:                                          ; preds = %vector.body, %entry
  ret void
}

; VLSTW.u32 Qd, [P, 4]
define arm_aapcs_vfpcc void @qi4(<4 x i32> %v, <4 x i32*> %p) {
; CHECK-LABEL: qi4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q2, #0x10
; CHECK-NEXT:    vadd.i32 q1, q1, q2
; CHECK-NEXT:    vstrw.32 q0, [q1]
; CHECK-NEXT:    bx lr
entry:
  %g = getelementptr inbounds i32, <4 x i32*> %p, i32 4
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %v, <4 x i32*> %g, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

declare void @llvm.masked.scatter.v2i16.v2p0i16(<2 x i16>, <2 x i16*>, i32, <2 x i1>)
declare void @llvm.masked.scatter.v2i32.v2p0i32(<2 x i32>, <2 x i32*>, i32, <2 x i1>)
declare void @llvm.masked.scatter.v2f32.v2p0f32(<2 x float>, <2 x float*>, i32, <2 x i1>)
declare void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8>, <4 x i8*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16>, <4 x i16*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v4f16.v4p0f16(<4 x half>, <4 x half*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32>, <4 x i32*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v4f32.v4p0f32(<4 x float>, <4 x float*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v8i8.v8p0i8(<8 x i8>, <8 x i8*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v8i16.v8p0i16(<8 x i16>, <8 x i16*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v8f16.v8p0f16(<8 x half>, <8 x half*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v8i32.v8p0i32(<8 x i32>, <8 x i32*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v8f32.v8p0f32(<8 x float>, <8 x float*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v16i8.v16p0i8(<16 x i8>, <16 x i8*>, i32, <16 x i1>)
declare void @llvm.masked.scatter.v16i32.v16p0i32(<16 x i32>, <16 x i32*>, i32, <16 x i1>)
declare <4 x i32> @llvm.masked.load.v4i32.v4p0i32(<4 x i32>*, i32, <4 x i1>, <4 x i32>)
