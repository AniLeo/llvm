; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp %s -o - -opaque-pointers | FileCheck %s

; VLDRB.u32 Qd, [base, offs]
define arm_aapcs_vfpcc void @ext_unscaled_i8_i32(i8* %base, <4 x i32>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: ext_unscaled_i8_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vstrb.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i32>, <4 x i32>* %offptr, align 4
  %ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs
  %t = trunc <4 x i32> %input to <4 x i8>
  call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> %t, <4 x i8*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.u32 Qd, [base, offs]
define arm_aapcs_vfpcc void @ext_unscaled_i16_i32(i8* %base, <4 x i32>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: ext_unscaled_i16_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vstrh.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i32>, <4 x i32>* %offptr, align 4
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i16*>
  %t = trunc <4 x i32> %input to <4 x i16>
  call void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16> %t, <4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VSTRW.32 Qd, [base, offs]
define arm_aapcs_vfpcc void @unscaled_i32_i32(i8* %base, <4 x i32>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: unscaled_i32_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i32>, <4 x i32>* %offptr, align 4
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i32*>
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %input, <4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VSTRW.32 Qd, [base, offs]
define arm_aapcs_vfpcc void @unscaled_f32_i32(i8* %base, <4 x i32>* %offptr, <4 x float> %input) {
; CHECK-LABEL: unscaled_f32_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i32>, <4 x i32>* %offptr, align 4
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x float*>
  call void @llvm.masked.scatter.v4f32.v4p0f32(<4 x float> %input, <4 x float*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VSTRW.32 Qd, [base, offs.zext]
define arm_aapcs_vfpcc void @unsigned_unscaled_b_i32_i16(i8* %base, <4 x i16>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: unsigned_unscaled_b_i32_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q1, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.zext = zext <4 x i16> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.zext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i32*>
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %input, <4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VSTRW.32 Qd, [base, offs.sext]
define arm_aapcs_vfpcc void @signed_unscaled_i32_i16(i8* %base, <4 x i16>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: signed_unscaled_i32_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.sext = sext <4 x i16> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.sext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i32*>
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %input, <4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VSTRW.32 Qd, [base, offs.zext]
define arm_aapcs_vfpcc void @a_unsigned_unscaled_f32_i16(i8* %base, <4 x i16>* %offptr, <4 x float> %input) {
; CHECK-LABEL: a_unsigned_unscaled_f32_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q1, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.zext = zext <4 x i16> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.zext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x float*>
  call void @llvm.masked.scatter.v4f32.v4p0f32(<4 x float> %input, <4 x float*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VSTRW.32 Qd, [base, offs.sext]
define arm_aapcs_vfpcc void @b_signed_unscaled_f32_i16(i8* %base, <4 x i16>* %offptr, <4 x float> %input) {
; CHECK-LABEL: b_signed_unscaled_f32_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.sext = sext <4 x i16> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.sext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x float*>
  call void @llvm.masked.scatter.v4f32.v4p0f32(<4 x float> %input, <4 x float*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.u32 Qd, [base, offs.sext]
define arm_aapcs_vfpcc void @ext_signed_unscaled_i16_i16(i8* %base, <4 x i16>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: ext_signed_unscaled_i16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    vstrh.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.sext = sext <4 x i16> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.sext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i16*>
  %t = trunc <4 x i32> %input to <4 x i16>
  call void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16> %t, <4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.u32 Qd, [base, offs.zext]
define arm_aapcs_vfpcc void @ext_unsigned_unscaled_i16_i16(i8* %base, <4 x i16>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: ext_unsigned_unscaled_i16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q1, [r1]
; CHECK-NEXT:    vstrh.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.zext = zext <4 x i16> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.zext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i16*>
  %t = trunc <4 x i32> %input to <4 x i16>
  call void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16> %t, <4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRB.u32 Qd, [base, offs.sext]
define arm_aapcs_vfpcc void @ext_signed_unscaled_i8_i16(i8* %base, <4 x i16>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: ext_signed_unscaled_i8_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    vstrb.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.sext = sext <4 x i16> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.sext
  %t = trunc <4 x i32> %input to <4 x i8>
  call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> %t, <4 x i8*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRB.s32 Qd, [base, offs.zext]
define arm_aapcs_vfpcc void @ext_unsigned_unscaled_i8_i16(i8* %base, <4 x i16>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: ext_unsigned_unscaled_i8_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q1, [r1]
; CHECK-NEXT:    vstrb.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.zext = zext <4 x i16> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.zext
  %t = trunc <4 x i32> %input to <4 x i8>
  call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> %t, <4 x i8*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VSTRW.32 Qd, [base, offs.zext]
define arm_aapcs_vfpcc void @unsigned_unscaled_b_i32_i8(i8* %base, <4 x i8>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: unsigned_unscaled_b_i32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q1, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.zext = zext <4 x i8> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.zext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i32*>
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %input, <4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VSTRW.32 Qd, [base, offs.sext]
define arm_aapcs_vfpcc void @signed_unscaled_i32_i8(i8* %base, <4 x i8>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: signed_unscaled_i32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q1, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.sext = sext <4 x i8> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.sext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i32*>
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %input, <4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VSTRW.32 Qd, [base, offs.zext]
define arm_aapcs_vfpcc void @a_unsigned_unscaled_f32_i8(i8* %base, <4 x i8>* %offptr, <4 x float> %input) {
; CHECK-LABEL: a_unsigned_unscaled_f32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q1, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.zext = zext <4 x i8> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.zext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x float*>
  call void @llvm.masked.scatter.v4f32.v4p0f32(<4 x float> %input, <4 x float*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VSTRW.32 Qd, [base, offs.sext]
define arm_aapcs_vfpcc void @b_signed_unscaled_f32_i8(i8* %base, <4 x i8>* %offptr, <4 x float> %input) {
; CHECK-LABEL: b_signed_unscaled_f32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q1, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.sext = sext <4 x i8> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.sext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x float*>
  call void @llvm.masked.scatter.v4f32.v4p0f32(<4 x float> %input, <4 x float*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.u32 Qd, [base, offs.sext]
define arm_aapcs_vfpcc void @ext_signed_unscaled_i8_i8(i8* %base, <4 x i8>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: ext_signed_unscaled_i8_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q1, [r1]
; CHECK-NEXT:    vstrb.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.sext = sext <4 x i8> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.sext
  %t = trunc <4 x i32> %input to <4 x i8>
  call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> %t, <4 x i8*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.u32 Qd, [base, offs.zext]
define arm_aapcs_vfpcc void @ext_unsigned_unscaled_i8_i8(i8* %base, <4 x i8>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: ext_unsigned_unscaled_i8_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q1, [r1]
; CHECK-NEXT:    vstrb.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.zext = zext <4 x i8> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.zext
  %t = trunc <4 x i32> %input to <4 x i8>
  call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> %t, <4 x i8*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

define arm_aapcs_vfpcc void @trunc_signed_unscaled_i64_i8(i8* %base, <4 x i8>* %offptr, <4 x i64> %input) {
; CHECK-LABEL: trunc_signed_unscaled_i64_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q2, [r1]
; CHECK-NEXT:    vmov.f32 s1, s2
; CHECK-NEXT:    vmov.f32 s2, s4
; CHECK-NEXT:    vmov.f32 s3, s6
; CHECK-NEXT:    vstrw.32 q0, [r0, q2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.sext = sext <4 x i8> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.sext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i32*>
  %input.trunc = trunc <4 x i64> %input to <4 x i32>
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %input.trunc, <4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

define arm_aapcs_vfpcc void @trunc_unsigned_unscaled_i64_i8(i8* %base, <4 x i8>* %offptr, <4 x i64> %input) {
; CHECK-LABEL: trunc_unsigned_unscaled_i64_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q2, [r1]
; CHECK-NEXT:    vmov.f32 s1, s2
; CHECK-NEXT:    vmov.f32 s2, s4
; CHECK-NEXT:    vmov.f32 s3, s6
; CHECK-NEXT:    vstrw.32 q0, [r0, q2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.zext = zext <4 x i8> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.zext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i32*>
  %input.trunc = trunc <4 x i64> %input to <4 x i32>
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %input.trunc, <4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

define arm_aapcs_vfpcc void @trunc_signed_unscaled_i32_i8(i8* %base, <4 x i8>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: trunc_signed_unscaled_i32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q1, [r1]
; CHECK-NEXT:    vstrh.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.sext = sext <4 x i8> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.sext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i16*>
  %input.trunc = trunc <4 x i32> %input to <4 x i16>
  call void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16> %input.trunc, <4 x i16*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

define arm_aapcs_vfpcc void @trunc_unsigned_unscaled_i32_i8(i8* %base, <4 x i8>* %offptr, <4 x i32> %input) {
; CHECK-LABEL: trunc_unsigned_unscaled_i32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q1, [r1]
; CHECK-NEXT:    vstrh.32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.zext = zext <4 x i8> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.zext
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i16*>
  %input.trunc = trunc <4 x i32> %input to <4 x i16>
  call void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16> %input.trunc, <4 x i16*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

define arm_aapcs_vfpcc void @trunc_signed_unscaled_i16_i8(i8* %base, <4 x i8>* %offptr, <4 x i16> %input) {
; CHECK-LABEL: trunc_signed_unscaled_i16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q1, #0xff
; CHECK-NEXT:    vldrb.s32 q2, [r1]
; CHECK-NEXT:    vand q0, q0, q1
; CHECK-NEXT:    vstrb.32 q0, [r0, q2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.sext = sext <4 x i8> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.sext
  %input.trunc = trunc <4 x i16> %input to <4 x i8>
  call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> %input.trunc, <4 x i8*> %byte_ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

define arm_aapcs_vfpcc void @trunc_unsigned_unscaled_i16_i8(i8* %base, <4 x i8>* %offptr, <4 x i16> %input) {
; CHECK-LABEL: trunc_unsigned_unscaled_i16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q1, #0xff
; CHECK-NEXT:    vldrb.u32 q2, [r1]
; CHECK-NEXT:    vand q0, q0, q1
; CHECK-NEXT:    vstrb.32 q0, [r0, q2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.zext = zext <4 x i8> %offs to <4 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs.zext
  %input.trunc = trunc <4 x i16> %input to <4 x i8>
  call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> %input.trunc, <4 x i8*> %byte_ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>)
  ret void
}

declare void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8>, <4 x i8*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v4i16.v4p0i16(<4 x i16>, <4 x i16*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v4f16.v4p0f16(<4 x half>, <4 x half*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32>, <4 x i32*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v4f32.v4p0f32(<4 x float>, <4 x float*>, i32, <4 x i1>)
