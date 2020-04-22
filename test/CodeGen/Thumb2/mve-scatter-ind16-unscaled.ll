; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -enable-arm-maskedgatscat %s -o - | FileCheck %s

; VLDRB.u16 Qd, [base, offs]
define arm_aapcs_vfpcc void @ext_unscaled_i8_i16(i8* %base, <8 x i16>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: ext_unscaled_i8_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vstrb.16 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.zext
  %t = trunc <8 x i16> %input to <8 x i8>
  call void @llvm.masked.scatter.v8i8(<8 x i8> %t, <8 x i8*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRB.u16 Qd, [base, offs]
define arm_aapcs_vfpcc void @trunc_unsigned_unscaled_i16_i8(i8* %base, <8 x i8>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: trunc_unsigned_unscaled_i16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q1, [r1]
; CHECK-NEXT:    vstrb.16 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.zext = zext <8 x i8> %offs to <8 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.zext
  %input.trunc = trunc <8 x i16> %input to <8 x i8>
  call void @llvm.masked.scatter.v8i8(<8 x i8> %input.trunc, <8 x i8*> %byte_ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.16 Qd, [base, offs]
define arm_aapcs_vfpcc void @unscaled_i16_i16(i8* %base, <8 x i16>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: unscaled_i16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vstrh.16 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.zext
  %ptrs = bitcast <8 x i8*> %byte_ptrs to <8 x i16*>
  call void @llvm.masked.scatter.v8i16(<8 x i16> %input, <8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.s16 Qd, [base, offs]
define arm_aapcs_vfpcc void @unscaled_v8f16_i16(i8* %base, <8 x i16>* %offptr, <8 x half> %input) {
; CHECK-LABEL: unscaled_v8f16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vstrh.16 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.zext
  %ptrs = bitcast <8 x i8*> %byte_ptrs to <8 x half*>
  call void @llvm.masked.scatter.v8f16(<8 x half> %input, <8 x half*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @unscaled_v8i16_sext(i8* %base, <8 x i16>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: unscaled_v8i16_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q2, [r1]
; CHECK-NEXT:    vldrh.s32 q1, [r1, #8]
; CHECK-NEXT:    vmov.u16 r1, q0[0]
; CHECK-NEXT:    vadd.i32 q2, q2, r0
; CHECK-NEXT:    vadd.i32 q1, q1, r0
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
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.sext = sext <8 x i16> %offs to <8 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.sext
  %ptrs = bitcast <8 x i8*> %byte_ptrs to <8 x i16*>
  call void @llvm.masked.scatter.v8i16(<8 x i16> %input, <8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @unscaled_v8f16_sext(i8* %base, <8 x i16>* %offptr, <8 x half> %input) {
; CHECK-LABEL: unscaled_v8f16_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q2, [r1]
; CHECK-NEXT:    vldrh.s32 q1, [r1, #8]
; CHECK-NEXT:    vmovx.f16 s12, s0
; CHECK-NEXT:    vadd.i32 q2, q2, r0
; CHECK-NEXT:    vadd.i32 q1, q1, r0
; CHECK-NEXT:    vmov r1, s8
; CHECK-NEXT:    vstr.16 s0, [r1]
; CHECK-NEXT:    vmov r1, s9
; CHECK-NEXT:    vstr.16 s12, [r1]
; CHECK-NEXT:    vmov r1, s10
; CHECK-NEXT:    vstr.16 s1, [r1]
; CHECK-NEXT:    vmov r1, s11
; CHECK-NEXT:    vmovx.f16 s8, s1
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vstr.16 s8, [r1]
; CHECK-NEXT:    vstr.16 s2, [r0]
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmovx.f16 s8, s2
; CHECK-NEXT:    vstr.16 s8, [r0]
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vstr.16 s3, [r0]
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vmovx.f16 s0, s3
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.sext = sext <8 x i16> %offs to <8 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.sext
  %ptrs = bitcast <8 x i8*> %byte_ptrs to <8 x half*>
  call void @llvm.masked.scatter.v8f16(<8 x half> %input, <8 x half*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @unscaled_v8i16_noext(i8* %base, <8 x i32>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: unscaled_v8i16_noext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q2, [r1]
; CHECK-NEXT:    vldrw.u32 q1, [r1, #16]
; CHECK-NEXT:    vmov.u16 r1, q0[0]
; CHECK-NEXT:    vadd.i32 q2, q2, r0
; CHECK-NEXT:    vadd.i32 q1, q1, r0
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
  %offs = load <8 x i32>, <8 x i32>* %offptr, align 4
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs
  %ptrs = bitcast <8 x i8*> %byte_ptrs to <8 x i16*>
  call void @llvm.masked.scatter.v8i16(<8 x i16> %input, <8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand
define arm_aapcs_vfpcc void @unscaled_v8f16_noext(i8* %base, <8 x i32>* %offptr, <8 x half> %input) {
; CHECK-LABEL: unscaled_v8f16_noext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q2, [r1]
; CHECK-NEXT:    vldrw.u32 q1, [r1, #16]
; CHECK-NEXT:    vmovx.f16 s12, s0
; CHECK-NEXT:    vadd.i32 q2, q2, r0
; CHECK-NEXT:    vadd.i32 q1, q1, r0
; CHECK-NEXT:    vmov r1, s8
; CHECK-NEXT:    vstr.16 s0, [r1]
; CHECK-NEXT:    vmov r1, s9
; CHECK-NEXT:    vstr.16 s12, [r1]
; CHECK-NEXT:    vmov r1, s10
; CHECK-NEXT:    vstr.16 s1, [r1]
; CHECK-NEXT:    vmov r1, s11
; CHECK-NEXT:    vmovx.f16 s8, s1
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vstr.16 s8, [r1]
; CHECK-NEXT:    vstr.16 s2, [r0]
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmovx.f16 s8, s2
; CHECK-NEXT:    vstr.16 s8, [r0]
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vstr.16 s3, [r0]
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vmovx.f16 s0, s3
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i32>, <8 x i32>* %offptr, align 4
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs
  %ptrs = bitcast <8 x i8*> %byte_ptrs to <8 x half*>
  call void @llvm.masked.scatter.v8f16(<8 x half> %input, <8 x half*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.16 Qd, [base, zext(offs)]
define arm_aapcs_vfpcc void @unsigned_unscaled_i16_i8(i8* %base, <8 x i8>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: unsigned_unscaled_i16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q1, [r1]
; CHECK-NEXT:    vstrh.16 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.zext = zext <8 x i8> %offs to <8 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.zext
  %ptrs = bitcast <8 x i8*> %byte_ptrs to <8 x i16*>
  call void @llvm.masked.scatter.v8i16(<8 x i16> %input, <8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; VLDRH.16 Qd, [base, zext(offs)]
define arm_aapcs_vfpcc void @unsigned_unscaled_f16_i8(i8* %base, <8 x i8>* %offptr, <8 x half> %input) {
; CHECK-LABEL: unsigned_unscaled_f16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q1, [r1]
; CHECK-NEXT:    vstrh.16 q0, [r0, q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.zext = zext <8 x i8> %offs to <8 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.zext
  %ptrs = bitcast <8 x i8*> %byte_ptrs to <8 x half*>
  call void @llvm.masked.scatter.v8f16(<8 x half> %input, <8 x half*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand ?
define arm_aapcs_vfpcc void @trunc_signed_unscaled_i64_i8(i8* %base, <8 x i8>* %offptr, <8 x i64> %input) {
; CHECK-LABEL: trunc_signed_unscaled_i64_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vldrb.s32 q5, [r1]
; CHECK-NEXT:    vldrb.s32 q4, [r1, #4]
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vadd.i32 q5, q5, r0
; CHECK-NEXT:    vadd.i32 q4, q4, r0
; CHECK-NEXT:    vmov r0, s20
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s21
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s22
; CHECK-NEXT:    vmov r1, s4
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s23
; CHECK-NEXT:    vmov r1, s6
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s16
; CHECK-NEXT:    vmov r1, s8
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s17
; CHECK-NEXT:    vmov r1, s10
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s18
; CHECK-NEXT:    vmov r1, s12
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vmov r0, s19
; CHECK-NEXT:    vmov r1, s14
; CHECK-NEXT:    strh r1, [r0]
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.sext = sext <8 x i8> %offs to <8 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.sext
  %ptrs = bitcast <8 x i8*> %byte_ptrs to <8 x i16*>
  %input.trunc = trunc <8 x i64> %input to <8 x i16>
  call void @llvm.masked.scatter.v8i16(<8 x i16> %input.trunc, <8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand ?
define arm_aapcs_vfpcc void @trunc_unsigned_unscaled_i64_i8(i8* %base, <8 x i8>* %offptr, <8 x i64> %input) {
; CHECK-LABEL: trunc_unsigned_unscaled_i64_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov.16 q4[0], r3
; CHECK-NEXT:    vmov r3, s2
; CHECK-NEXT:    vmov.16 q4[1], r3
; CHECK-NEXT:    vmov r3, s4
; CHECK-NEXT:    vmov.16 q4[2], r3
; CHECK-NEXT:    vmov r3, s6
; CHECK-NEXT:    vmov.16 q4[3], r3
; CHECK-NEXT:    vmov r3, s8
; CHECK-NEXT:    vmov.16 q4[4], r3
; CHECK-NEXT:    vmov r3, s10
; CHECK-NEXT:    vmov.16 q4[5], r3
; CHECK-NEXT:    vmov r3, s12
; CHECK-NEXT:    vmov r2, s14
; CHECK-NEXT:    vmov.16 q4[6], r3
; CHECK-NEXT:    vldrb.u16 q0, [r1]
; CHECK-NEXT:    vmov.16 q4[7], r2
; CHECK-NEXT:    vstrh.16 q4, [r0, q0]
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.zext = zext <8 x i8> %offs to <8 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.zext
  %ptrs = bitcast <8 x i8*> %byte_ptrs to <8 x i16*>
  %input.trunc = trunc <8 x i64> %input to <8 x i16>
  call void @llvm.masked.scatter.v8i16(<8 x i16> %input.trunc, <8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand ?
define arm_aapcs_vfpcc void @trunc_signed_unscaled_i32_i8(i8* %base, <8 x i8>* %offptr, <8 x i32> %input) {
; CHECK-LABEL: trunc_signed_unscaled_i32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q3, [r1]
; CHECK-NEXT:    vldrb.s32 q2, [r1, #4]
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vadd.i32 q3, q3, r0
; CHECK-NEXT:    vadd.i32 q2, q2, r0
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
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.sext = sext <8 x i8> %offs to <8 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.sext
  %ptrs = bitcast <8 x i8*> %byte_ptrs to <8 x i16*>
  %input.trunc = trunc <8 x i32> %input to <8 x i16>
  call void @llvm.masked.scatter.v8i16(<8 x i16> %input.trunc, <8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand ?
define arm_aapcs_vfpcc void @trunc_unsigned_unscaled_i32_i8(i8* %base, <8 x i8>* %offptr, <8 x i32> %input) {
; CHECK-LABEL: trunc_unsigned_unscaled_i32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov.16 q2[0], r3
; CHECK-NEXT:    vmov r3, s1
; CHECK-NEXT:    vmov.16 q2[1], r3
; CHECK-NEXT:    vmov r3, s2
; CHECK-NEXT:    vmov.16 q2[2], r3
; CHECK-NEXT:    vmov r3, s3
; CHECK-NEXT:    vmov.16 q2[3], r3
; CHECK-NEXT:    vmov r3, s4
; CHECK-NEXT:    vmov.16 q2[4], r3
; CHECK-NEXT:    vmov r3, s5
; CHECK-NEXT:    vmov.16 q2[5], r3
; CHECK-NEXT:    vmov r3, s6
; CHECK-NEXT:    vmov r2, s7
; CHECK-NEXT:    vmov.16 q2[6], r3
; CHECK-NEXT:    vldrb.u16 q0, [r1]
; CHECK-NEXT:    vmov.16 q2[7], r2
; CHECK-NEXT:    vstrh.16 q2, [r0, q0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.zext = zext <8 x i8> %offs to <8 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.zext
  %ptrs = bitcast <8 x i8*> %byte_ptrs to <8 x i16*>
  %input.trunc = trunc <8 x i32> %input to <8 x i16>
  call void @llvm.masked.scatter.v8i16(<8 x i16> %input.trunc, <8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

; Expand ?
define arm_aapcs_vfpcc void @trunc_signed_unscaled_i16_i8(i8* %base, <8 x i8>* %offptr, <8 x i16> %input) {
; CHECK-LABEL: trunc_signed_unscaled_i16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q2, [r1]
; CHECK-NEXT:    vldrb.s32 q1, [r1, #4]
; CHECK-NEXT:    vmov.u16 r1, q0[0]
; CHECK-NEXT:    vadd.i32 q2, q2, r0
; CHECK-NEXT:    vadd.i32 q1, q1, r0
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
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.sext = sext <8 x i8> %offs to <8 x i32>
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.sext
  %input.trunc = trunc <8 x i16> %input to <8 x i8>
  call void @llvm.masked.scatter.v8i8(<8 x i8> %input.trunc, <8 x i8*> %byte_ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

declare void @llvm.masked.scatter.v8i8(<8 x i8>, <8 x i8*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v8i16(<8 x i16>, <8 x i16*>, i32, <8 x i1>)
declare void @llvm.masked.scatter.v8f16(<8 x half>, <8 x half*>, i32, <8 x i1>)
