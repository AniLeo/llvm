; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp %s -o - | FileCheck %s
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -opaque-pointers %s -o - | FileCheck %s

define arm_aapcs_vfpcc <4 x i32> @zext_scaled_i16_i32(i16* %base, <4 x i32>* %offptr) {
; CHECK-LABEL: zext_scaled_i16_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vldrh.u32 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i32>, <4 x i32>* %offptr, align 4
  %ptrs = getelementptr inbounds i16, i16* %base, <4 x i32> %offs
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %gather.zext = zext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %gather.zext
}

define arm_aapcs_vfpcc <4 x i32> @sext_scaled_i16_i32(i16* %base, <4 x i32>* %offptr) {
; CHECK-LABEL: sext_scaled_i16_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vldrh.s32 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i32>, <4 x i32>* %offptr, align 4
  %ptrs = getelementptr inbounds i16, i16* %base, <4 x i32> %offs
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %gather.sext = sext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %gather.sext
}

define arm_aapcs_vfpcc <4 x i32> @scaled_i32_i32(i32* %base, <4 x i32>* %offptr) {
; CHECK-LABEL: scaled_i32_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vldrw.u32 q0, [r0, q1, uxtw #2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i32>, <4 x i32>* %offptr, align 4
  %ptrs = getelementptr inbounds i32, i32* %base, <4 x i32> %offs
  %gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef)
  ret <4 x i32> %gather
}

; TODO: scaled_f16_i32

define arm_aapcs_vfpcc <4 x float> @scaled_f32_i32(i32* %base, <4 x i32>* %offptr) {
; CHECK-LABEL: scaled_f32_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vldrw.u32 q0, [r0, q1, uxtw #2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i32>, <4 x i32>* %offptr, align 4
  %i32_ptrs = getelementptr inbounds i32, i32* %base, <4 x i32> %offs
  %ptrs = bitcast <4 x i32*> %i32_ptrs to <4 x float*>
  %gather = call <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x float> undef)
  ret <4 x float> %gather
}

define arm_aapcs_vfpcc <4 x i32> @unsigned_scaled_b_i32_i16(i32* %base, <4 x i16>* %offptr) {
; CHECK-LABEL: unsigned_scaled_b_i32_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q1, [r1]
; CHECK-NEXT:    vldrw.u32 q0, [r0, q1, uxtw #2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.zext = zext <4 x i16> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i32, i32* %base, <4 x i32> %offs.zext
  %gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef)
  ret <4 x i32> %gather
}

define arm_aapcs_vfpcc <4 x i32> @signed_scaled_i32_i16(i32* %base, <4 x i16>* %offptr) {
; CHECK-LABEL: signed_scaled_i32_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    vldrw.u32 q0, [r0, q1, uxtw #2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.sext = sext <4 x i16> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i32, i32* %base, <4 x i32> %offs.sext
  %gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef)
  ret <4 x i32> %gather
}

define arm_aapcs_vfpcc <4 x float> @a_unsigned_scaled_f32_i16(i32* %base, <4 x i16>* %offptr) {
; CHECK-LABEL: a_unsigned_scaled_f32_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q1, [r1]
; CHECK-NEXT:    vldrw.u32 q0, [r0, q1, uxtw #2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.zext = zext <4 x i16> %offs to <4 x i32>
  %i32_ptrs = getelementptr inbounds i32, i32* %base, <4 x i32> %offs.zext
  %ptrs = bitcast <4 x i32*> %i32_ptrs to <4 x float*>
  %gather = call <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x float> undef)
  ret <4 x float> %gather
}

define arm_aapcs_vfpcc <4 x float> @b_signed_scaled_f32_i16(i32* %base, <4 x i16>* %offptr) {
; CHECK-LABEL: b_signed_scaled_f32_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    vldrw.u32 q0, [r0, q1, uxtw #2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.sext = sext <4 x i16> %offs to <4 x i32>
  %i32_ptrs = getelementptr inbounds i32, i32* %base, <4 x i32> %offs.sext
  %ptrs = bitcast <4 x i32*> %i32_ptrs to <4 x float*>
  %gather = call <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x float> undef)
  ret <4 x float> %gather
}

define arm_aapcs_vfpcc <4 x i32> @zext_signed_scaled_i16_i16(i16* %base, <4 x i16>* %offptr) {
; CHECK-LABEL: zext_signed_scaled_i16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    vldrh.u32 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.sext = sext <4 x i16> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <4 x i32> %offs.sext
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %gather.zext = zext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %gather.zext
}

define arm_aapcs_vfpcc <4 x i32> @sext_signed_scaled_i16_i16(i16* %base, <4 x i16>* %offptr) {
; CHECK-LABEL: sext_signed_scaled_i16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    vldrh.s32 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.sext = sext <4 x i16> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <4 x i32> %offs.sext
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %gather.sext = sext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %gather.sext
}

define arm_aapcs_vfpcc <4 x i32> @zext_unsigned_scaled_i16_i16(i16* %base, <4 x i16>* %offptr) {
; CHECK-LABEL: zext_unsigned_scaled_i16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q1, [r1]
; CHECK-NEXT:    vldrh.u32 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.zext = zext <4 x i16> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <4 x i32> %offs.zext
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %gather.zext = zext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %gather.zext
}

define arm_aapcs_vfpcc <4 x i32> @sext_unsigned_scaled_i16_i16(i16* %base, <4 x i16>* %offptr) {
; CHECK-LABEL: sext_unsigned_scaled_i16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q1, [r1]
; CHECK-NEXT:    vldrh.s32 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16>, <4 x i16>* %offptr, align 2
  %offs.zext = zext <4 x i16> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <4 x i32> %offs.zext
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %gather.sext = sext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %gather.sext
}

define arm_aapcs_vfpcc <4 x i32> @unsigned_scaled_b_i32_i8(i32* %base, <4 x i8>* %offptr) {
; CHECK-LABEL: unsigned_scaled_b_i32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q1, [r1]
; CHECK-NEXT:    vldrw.u32 q0, [r0, q1, uxtw #2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.zext = zext <4 x i8> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i32, i32* %base, <4 x i32> %offs.zext
  %gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef)
  ret <4 x i32> %gather
}

define arm_aapcs_vfpcc <4 x i32> @signed_scaled_i32_i8(i32* %base, <4 x i8>* %offptr) {
; CHECK-LABEL: signed_scaled_i32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q1, [r1]
; CHECK-NEXT:    vldrw.u32 q0, [r0, q1, uxtw #2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.sext = sext <4 x i8> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i32, i32* %base, <4 x i32> %offs.sext
  %gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef)
  ret <4 x i32> %gather
}

define arm_aapcs_vfpcc <4 x float> @a_unsigned_scaled_f32_i8(i32* %base, <4 x i8>* %offptr) {
; CHECK-LABEL: a_unsigned_scaled_f32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q1, [r1]
; CHECK-NEXT:    vldrw.u32 q0, [r0, q1, uxtw #2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.zext = zext <4 x i8> %offs to <4 x i32>
  %i32_ptrs = getelementptr inbounds i32, i32* %base, <4 x i32> %offs.zext
  %ptrs = bitcast <4 x i32*> %i32_ptrs to <4 x float*>
  %gather = call <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x float> undef)
  ret <4 x float> %gather
}

define arm_aapcs_vfpcc <4 x float> @b_signed_scaled_f32_i8(i32* %base, <4 x i8>* %offptr) {
; CHECK-LABEL: b_signed_scaled_f32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q1, [r1]
; CHECK-NEXT:    vldrw.u32 q0, [r0, q1, uxtw #2]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.sext = sext <4 x i8> %offs to <4 x i32>
  %i32_ptrs = getelementptr inbounds i32, i32* %base, <4 x i32> %offs.sext
  %ptrs = bitcast <4 x i32*> %i32_ptrs to <4 x float*>
  %gather = call <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x float> undef)
  ret <4 x float> %gather
}

define arm_aapcs_vfpcc <4 x i32> @zext_signed_scaled_i16_i8(i16* %base, <4 x i8>* %offptr) {
; CHECK-LABEL: zext_signed_scaled_i16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q1, [r1]
; CHECK-NEXT:    vldrh.u32 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.sext = sext <4 x i8> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <4 x i32> %offs.sext
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %gather.zext = zext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %gather.zext
}

define arm_aapcs_vfpcc <4 x i32> @sext_signed_scaled_i16_i8(i16* %base, <4 x i8>* %offptr) {
; CHECK-LABEL: sext_signed_scaled_i16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q1, [r1]
; CHECK-NEXT:    vldrh.s32 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.sext = sext <4 x i8> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <4 x i32> %offs.sext
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %gather.sext = sext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %gather.sext
}

define arm_aapcs_vfpcc <4 x i32> @zext_unsigned_scaled_i16_i8(i16* %base, <4 x i8>* %offptr) {
; CHECK-LABEL: zext_unsigned_scaled_i16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q1, [r1]
; CHECK-NEXT:    vldrh.u32 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.zext = zext <4 x i8> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <4 x i32> %offs.zext
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %gather.zext = zext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %gather.zext
}

define arm_aapcs_vfpcc <4 x i32> @sext_unsigned_scaled_i16_i8(i16* %base, <4 x i8>* %offptr) {
; CHECK-LABEL: sext_unsigned_scaled_i16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q1, [r1]
; CHECK-NEXT:    vldrh.s32 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8>, <4 x i8>* %offptr, align 1
  %offs.zext = zext <4 x i8> %offs to <4 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <4 x i32> %offs.zext
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %ptrs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %gather.sext = sext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %gather.sext
}

define arm_aapcs_vfpcc <4 x i32> @scaled_i32_i32_2gep(i32* %base, <4 x i32>* %offptr) {
; CHECK-LABEL: scaled_i32_i32_2gep:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    movs r2, #20
; CHECK-NEXT:    vshl.i32 q0, q0, #2
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vadd.i32 q1, q0, r2
; CHECK-NEXT:    vldrw.u32 q0, [q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i32>, <4 x i32>* %offptr, align 4
  %ptrs = getelementptr inbounds i32, i32* %base, <4 x i32> %offs
  %ptrs2 = getelementptr inbounds i32, <4 x i32*> %ptrs, i32 5
  %gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %ptrs2, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef)
  ret <4 x i32> %gather
}

define arm_aapcs_vfpcc <4 x i32> @scaled_i32_i32_2gep2(i32* %base) {
; CHECK-LABEL: scaled_i32_i32_2gep2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adr r1, .LCPI21_0
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vldrw.u32 q0, [r0, q1]
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI21_0:
; CHECK-NEXT:    .long 20 @ 0x14
; CHECK-NEXT:    .long 32 @ 0x20
; CHECK-NEXT:    .long 44 @ 0x2c
; CHECK-NEXT:    .long 56 @ 0x38
entry:
  %ptrs = getelementptr inbounds i32, i32* %base, <4 x i32> <i32 0, i32 3, i32 6, i32 9>
  %ptrs2 = getelementptr inbounds i32, <4 x i32*> %ptrs, i32 5
  %gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %ptrs2, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef)
  ret <4 x i32> %gather
}

declare <4 x i8>  @llvm.masked.gather.v4i8.v4p0i8(<4 x i8*>, i32, <4 x i1>, <4 x i8>)
declare <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*>, i32, <4 x i1>, <4 x i16>)
declare <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*>, i32, <4 x i1>, <4 x i32>)
declare <4 x half> @llvm.masked.gather.v4f16.v4p0f16(<4 x half*>, i32, <4 x i1>, <4 x half>)
declare <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*>, i32, <4 x i1>, <4 x float>)
