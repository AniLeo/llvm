; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp %s -o - | FileCheck %s

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8i16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vldrh.u16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x half> @scaled_v8f16_i16(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8f16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vldrh.u16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %i16_ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %ptrs = bitcast <8 x i16*> %i16_ptrs to <8 x half*>
  %gather = call <8 x half> @llvm.masked.gather.v8f16.v8p0f16(<8 x half*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x half> undef)
  ret <8 x half> %gather
}

define arm_aapcs_vfpcc <8 x half> @scaled_v8f16_half(half* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8f16_half:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vldrh.u16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds half, half* %base, <8 x i32> %offs.zext
  %gather = call <8 x half> @llvm.masked.gather.v8f16.v8p0f16(<8 x half*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x half> undef)
  ret <8 x half> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_sext(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8i16_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrh.s32 q0, [r1, #8]
; CHECK-NEXT:    vshl.i32 q0, q0, #1
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r2, r12, d0
; CHECK-NEXT:    vmov r3, lr, d1
; CHECK-NEXT:    vldrh.s32 q0, [r1]
; CHECK-NEXT:    vshl.i32 q0, q0, #1
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov r0, r1, d1
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    ldrh.w r12, [r12]
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    ldrh.w lr, [lr]
; CHECK-NEXT:    ldrh r4, [r4]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vmov.16 q0[3], r1
; CHECK-NEXT:    vmov.16 q0[4], r2
; CHECK-NEXT:    vmov.16 q0[5], r12
; CHECK-NEXT:    vmov.16 q0[6], r3
; CHECK-NEXT:    vmov.16 q0[7], lr
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.sext = sext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.sext
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x half> @scaled_v8f16_sext(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8f16_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q0, [r1]
; CHECK-NEXT:    vshl.i32 q0, q0, #1
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r2, r3, d0
; CHECK-NEXT:    vldr.16 s4, [r3]
; CHECK-NEXT:    vldr.16 s0, [r2]
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    vins.f16 s0, s4
; CHECK-NEXT:    vldrh.s32 q1, [r1, #8]
; CHECK-NEXT:    vldr.16 s2, [r3]
; CHECK-NEXT:    vldr.16 s1, [r2]
; CHECK-NEXT:    vshl.i32 q1, q1, #1
; CHECK-NEXT:    vadd.i32 q1, q1, r0
; CHECK-NEXT:    vins.f16 s1, s2
; CHECK-NEXT:    vmov r0, r1, d2
; CHECK-NEXT:    vldr.16 s4, [r1]
; CHECK-NEXT:    vldr.16 s2, [r0]
; CHECK-NEXT:    vmov r0, r1, d3
; CHECK-NEXT:    vins.f16 s2, s4
; CHECK-NEXT:    vldr.16 s4, [r1]
; CHECK-NEXT:    vldr.16 s3, [r0]
; CHECK-NEXT:    vins.f16 s3, s4
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.sext = sext <8 x i16> %offs to <8 x i32>
  %i16_ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.sext
  %ptrs = bitcast <8 x i16*> %i16_ptrs to <8 x half*>
  %gather = call <8 x half> @llvm.masked.gather.v8f16.v8p0f16(<8 x half*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x half> undef)
  ret <8 x half> %gather
}

define arm_aapcs_vfpcc <8 x i16> @unsigned_scaled_v8i16_i8(i16* %base, <8 x i8>* %offptr) {
; CHECK-LABEL: unsigned_scaled_v8i16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q1, [r1]
; CHECK-NEXT:    vldrh.u16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.zext = zext <8 x i8> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x half> @unsigned_scaled_v8f16_i8(i16* %base, <8 x i8>* %offptr) {
; CHECK-LABEL: unsigned_scaled_v8f16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q1, [r1]
; CHECK-NEXT:    vldrh.u16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.zext = zext <8 x i8> %offs to <8 x i32>
  %i16_ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %ptrs = bitcast <8 x i16*> %i16_ptrs to <8 x half*>
  %gather = call <8 x half> @llvm.masked.gather.v8f16.v8p0f16(<8 x half*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x half> undef)
  ret <8 x half> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_passthru0t(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8i16_i16_passthru0t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vldrh.u16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> zeroinitializer)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_passthru1t(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8i16_i16_passthru1t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vldrh.u16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_passthru1f(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8i16_i16_passthru1f:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, #65487
; CHECK-NEXT:    vmov.i16 q0, #0x1
; CHECK-NEXT:    vmsr p0, r2
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vldrht.u16 q2, [r0, q1, uxtw #1]
; CHECK-NEXT:    vpsel q0, q2, q0
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_passthru0f(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8i16_i16_passthru0f:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movw r2, #65523
; CHECK-NEXT:    vmsr p0, r2
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vldrht.u16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> <i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_passthru_icmp0(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8i16_i16_passthru_icmp0:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vpt.s16 gt, q1, zr
; CHECK-NEXT:    vldrht.u16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %mask = icmp sgt <8 x i16> %offs, zeroinitializer
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs, i32 2, <8 x i1> %mask, <8 x i16> <i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_passthru_icmp1(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8i16_i16_passthru_icmp1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q1, [r1]
; CHECK-NEXT:    vmov.i16 q0, #0x1
; CHECK-NEXT:    vpt.s16 gt, q1, zr
; CHECK-NEXT:    vldrht.u16 q2, [r0, q1, uxtw #1]
; CHECK-NEXT:    vpsel q0, q2, q0
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> %offs.zext
  %mask = icmp sgt <8 x i16> %offs, zeroinitializer
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs, i32 2, <8 x i1> %mask, <8 x i16> <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_2gep(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8i16_i16_2gep:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrh.s32 q1, [r1, #8]
; CHECK-NEXT:    vmov.i32 q0, #0x28
; CHECK-NEXT:    vshl.i32 q1, q1, #1
; CHECK-NEXT:    vadd.i32 q1, q1, r0
; CHECK-NEXT:    vadd.i32 q1, q1, q0
; CHECK-NEXT:    vmov r2, r12, d2
; CHECK-NEXT:    vmov r3, lr, d3
; CHECK-NEXT:    vldrh.s32 q1, [r1]
; CHECK-NEXT:    vshl.i32 q1, q1, #1
; CHECK-NEXT:    vadd.i32 q1, q1, r0
; CHECK-NEXT:    vadd.i32 q0, q1, q0
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov r0, r1, d1
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    ldrh.w r12, [r12]
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    ldrh.w lr, [lr]
; CHECK-NEXT:    ldrh r4, [r4]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vmov.16 q0[3], r1
; CHECK-NEXT:    vmov.16 q0[4], r2
; CHECK-NEXT:    vmov.16 q0[5], r12
; CHECK-NEXT:    vmov.16 q0[6], r3
; CHECK-NEXT:    vmov.16 q0[7], lr
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i16> %offs
  %ptrs2 = getelementptr inbounds i16, <8 x i16*> %ptrs, i16 20
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs2, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_2gep2(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8i16_i16_2gep2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adr r1, .LCPI14_0
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vldrh.u16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI14_0:
; CHECK-NEXT:    .short 20 @ 0x14
; CHECK-NEXT:    .short 23 @ 0x17
; CHECK-NEXT:    .short 26 @ 0x1a
; CHECK-NEXT:    .short 29 @ 0x1d
; CHECK-NEXT:    .short 32 @ 0x20
; CHECK-NEXT:    .short 35 @ 0x23
; CHECK-NEXT:    .short 38 @ 0x26
; CHECK-NEXT:    .short 41 @ 0x29
entry:
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i16> <i16 0, i16 3, i16 6, i16 9, i16 12, i16 15, i16 18, i16 21>
  %ptrs2 = getelementptr inbounds i16,<8 x i16*> %ptrs, i16 20
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs2, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_biggep(i16* %base) {
; CHECK-LABEL: scaled_v8i16_i16_biggep:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adr r1, .LCPI15_0
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vldrh.u16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI15_0:
; CHECK-NEXT:    .short 20 @ 0x14
; CHECK-NEXT:    .short 23 @ 0x17
; CHECK-NEXT:    .short 26 @ 0x1a
; CHECK-NEXT:    .short 29 @ 0x1d
; CHECK-NEXT:    .short 32 @ 0x20
; CHECK-NEXT:    .short 35 @ 0x23
; CHECK-NEXT:    .short 38 @ 0x26
; CHECK-NEXT:    .short 41 @ 0x29
entry:
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 18, i32 21>
  %ptrs2 = getelementptr inbounds i16,<8 x i16*> %ptrs, i32 20
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs2, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_biggep2(i16* %base) {
; CHECK-LABEL: scaled_v8i16_i16_biggep2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adr r1, .LCPI16_0
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vldrh.u16 q0, [r0, q1, uxtw #1]
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI16_0:
; CHECK-NEXT:    .short 0 @ 0x0
; CHECK-NEXT:    .short 3 @ 0x3
; CHECK-NEXT:    .short 6 @ 0x6
; CHECK-NEXT:    .short 9 @ 0x9
; CHECK-NEXT:    .short 12 @ 0xc
; CHECK-NEXT:    .short 15 @ 0xf
; CHECK-NEXT:    .short 18 @ 0x12
; CHECK-NEXT:    .short 21 @ 0x15
entry:
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 18, i32 21>
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_biggep3(i16* %base) {
; CHECK-LABEL: scaled_v8i16_i16_biggep3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    adr r1, .LCPI17_0
; CHECK-NEXT:    adr r2, .LCPI17_1
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r1, lr, d0
; CHECK-NEXT:    vmov r3, r12, d1
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov r0, r2, d1
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    ldrh.w lr, [lr]
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    ldrh.w r12, [r12]
; CHECK-NEXT:    ldrh r4, [r4]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vmov.16 q0[3], r2
; CHECK-NEXT:    vmov.16 q0[4], r1
; CHECK-NEXT:    vmov.16 q0[5], lr
; CHECK-NEXT:    vmov.16 q0[6], r3
; CHECK-NEXT:    vmov.16 q0[7], r12
; CHECK-NEXT:    pop {r4, r5, r7, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI17_0:
; CHECK-NEXT:    .long 131096 @ 0x20018
; CHECK-NEXT:    .long 131102 @ 0x2001e
; CHECK-NEXT:    .long 131108 @ 0x20024
; CHECK-NEXT:    .long 131114 @ 0x2002a
; CHECK-NEXT:  .LCPI17_1:
; CHECK-NEXT:    .long 131072 @ 0x20000
; CHECK-NEXT:    .long 131078 @ 0x20006
; CHECK-NEXT:    .long 131084 @ 0x2000c
; CHECK-NEXT:    .long 131090 @ 0x20012
entry:
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 18, i32 21>
  %ptrs2 = getelementptr inbounds i16,<8 x i16*> %ptrs, i32 65536
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs2, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_biggep4(i16* %base) {
; CHECK-LABEL: scaled_v8i16_i16_biggep4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    adr r1, .LCPI18_0
; CHECK-NEXT:    adr r2, .LCPI18_1
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r1, lr, d0
; CHECK-NEXT:    vmov r3, r12, d1
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov r0, r2, d1
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    ldrh.w lr, [lr]
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    ldrh.w r12, [r12]
; CHECK-NEXT:    ldrh r4, [r4]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vmov.16 q0[3], r2
; CHECK-NEXT:    vmov.16 q0[4], r1
; CHECK-NEXT:    vmov.16 q0[5], lr
; CHECK-NEXT:    vmov.16 q0[6], r3
; CHECK-NEXT:    vmov.16 q0[7], r12
; CHECK-NEXT:    pop {r4, r5, r7, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI18_0:
; CHECK-NEXT:    .long 24 @ 0x18
; CHECK-NEXT:    .long 131072 @ 0x20000
; CHECK-NEXT:    .long 36 @ 0x24
; CHECK-NEXT:    .long 42 @ 0x2a
; CHECK-NEXT:  .LCPI18_1:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 6 @ 0x6
; CHECK-NEXT:    .long 12 @ 0xc
; CHECK-NEXT:    .long 18 @ 0x12
entry:
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 65536, i32 18, i32 21>
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_biggep5(<8 x i16*> %base) {
; CHECK-LABEL: scaled_v8i16_i16_biggep5:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, lr}
; CHECK-NEXT:    push {r4, r5, r6, lr}
; CHECK-NEXT:    vmov.i32 q2, #0x20000
; CHECK-NEXT:    vadd.i32 q0, q0, q2
; CHECK-NEXT:    vadd.i32 q1, q1, q2
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov r1, lr, d1
; CHECK-NEXT:    vmov r2, r3, d3
; CHECK-NEXT:    vmov r0, r12, d2
; CHECK-NEXT:    ldrh r4, [r4]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrh r6, [r3]
; CHECK-NEXT:    ldrh.w r3, [lr]
; CHECK-NEXT:    vmov.16 q0[2], r1
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vmov.16 q0[3], r3
; CHECK-NEXT:    ldrh.w r12, [r12]
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    vmov.16 q0[5], r12
; CHECK-NEXT:    vmov.16 q0[6], r2
; CHECK-NEXT:    vmov.16 q0[7], r6
; CHECK-NEXT:    pop {r4, r5, r6, pc}
entry:
  %ptrs2 = getelementptr inbounds i16,<8 x i16*> %base, i32 65536
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs2, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_biggep6(i16* %base) {
; CHECK-LABEL: scaled_v8i16_i16_biggep6:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    adr r1, .LCPI20_0
; CHECK-NEXT:    adr r2, .LCPI20_1
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r1, lr, d0
; CHECK-NEXT:    vmov r3, r12, d1
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov r0, r2, d1
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    ldrh.w lr, [lr]
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    ldrh.w r12, [r12]
; CHECK-NEXT:    ldrh r4, [r4]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vmov.16 q0[3], r2
; CHECK-NEXT:    vmov.16 q0[4], r1
; CHECK-NEXT:    vmov.16 q0[5], lr
; CHECK-NEXT:    vmov.16 q0[6], r3
; CHECK-NEXT:    vmov.16 q0[7], r12
; CHECK-NEXT:    pop {r4, r5, r7, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI20_0:
; CHECK-NEXT:    .long 131074 @ 0x20002
; CHECK-NEXT:    .long 32 @ 0x20
; CHECK-NEXT:    .long 38 @ 0x26
; CHECK-NEXT:    .long 44 @ 0x2c
; CHECK-NEXT:  .LCPI20_1:
; CHECK-NEXT:    .long 2 @ 0x2
; CHECK-NEXT:    .long 8 @ 0x8
; CHECK-NEXT:    .long 14 @ 0xe
; CHECK-NEXT:    .long 20 @ 0x14
entry:
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i32> <i32 0, i32 3, i32 6, i32 9, i32 65536, i32 15, i32 18, i32 21>
  %ptrs2 = getelementptr inbounds i16,<8 x i16*> %ptrs, i32 1
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs2, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_biggep7(i16* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8i16_i16_biggep7:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    adr r1, .LCPI21_0
; CHECK-NEXT:    adr r2, .LCPI21_1
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r1, lr, d0
; CHECK-NEXT:    vmov r3, r12, d1
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov r0, r2, d1
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    ldrh.w lr, [lr]
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    ldrh.w r12, [r12]
; CHECK-NEXT:    ldrh r4, [r4]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vmov.16 q0[3], r2
; CHECK-NEXT:    vmov.16 q0[4], r1
; CHECK-NEXT:    vmov.16 q0[5], lr
; CHECK-NEXT:    vmov.16 q0[6], r3
; CHECK-NEXT:    vmov.16 q0[7], r12
; CHECK-NEXT:    pop {r4, r5, r7, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI21_0:
; CHECK-NEXT:    .long 1224 @ 0x4c8
; CHECK-NEXT:    .long 1230 @ 0x4ce
; CHECK-NEXT:    .long 1236 @ 0x4d4
; CHECK-NEXT:    .long 1242 @ 0x4da
; CHECK-NEXT:  .LCPI21_1:
; CHECK-NEXT:    .long 128 @ 0x80
; CHECK-NEXT:    .long 1206 @ 0x4b6
; CHECK-NEXT:    .long 1212 @ 0x4bc
; CHECK-NEXT:    .long 1218 @ 0x4c2
entry:
  %ptrs = getelementptr inbounds i16, i16* %base, <8 x i16> <i16 65000, i16 3, i16 6, i16 9, i16 12, i16 15, i16 18, i16 21>
  %ptrs2 = getelementptr inbounds i16,<8 x i16*> %ptrs, i16 600
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs2, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <8 x i16> @scaled_v8i16_i16_basei32(i32* %base, <8 x i16>* %offptr) {
; CHECK-LABEL: scaled_v8i16_i16_basei32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrh.u32 q0, [r1, #8]
; CHECK-NEXT:    vshl.i32 q0, q0, #2
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r2, r12, d0
; CHECK-NEXT:    vmov r3, lr, d1
; CHECK-NEXT:    vldrh.u32 q0, [r1]
; CHECK-NEXT:    vshl.i32 q0, q0, #2
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vmov r4, r5, d0
; CHECK-NEXT:    vmov r0, r1, d1
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    ldrh.w r12, [r12]
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    ldrh.w lr, [lr]
; CHECK-NEXT:    ldrh r4, [r4]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vmov.16 q0[3], r1
; CHECK-NEXT:    vmov.16 q0[4], r2
; CHECK-NEXT:    vmov.16 q0[5], r12
; CHECK-NEXT:    vmov.16 q0[6], r3
; CHECK-NEXT:    vmov.16 q0[7], lr
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x i16>, <8 x i16>* %offptr, align 2
  %offs.zext = zext <8 x i16> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i32, i32* %base, <8 x i32> %offs.zext
  %ptrs.cast = bitcast <8 x i32*> %ptrs to <8 x i16*>
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %ptrs.cast, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

declare <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*>, i32, <8 x i1>, <8 x i8>) #1
declare <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*>, i32, <8 x i1>, <8 x i16>) #1
declare <8 x half> @llvm.masked.gather.v8f16.v8p0f16(<8 x half*>, i32, <8 x i1>, <8 x half>) #1
