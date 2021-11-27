; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp %s -o - | FileCheck %s

define arm_aapcs_vfpcc zeroext i8 @uminv16i8(<16 x i8> %vec, i8 zeroext %min) {
; CHECK-LABEL: uminv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.u8 r0, q0
; CHECK-NEXT:    uxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.umin.v16i8(<16 x i8> %vec)
  %cmp = icmp ult i8 %x, %min
  %1 = select i1 %cmp, i8 %x, i8 %min
  ret i8 %1
}

define arm_aapcs_vfpcc zeroext i16 @uminv8i16(<8 x i16> %vec, i16 zeroext %min) {
; CHECK-LABEL: uminv8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.u16 r0, q0
; CHECK-NEXT:    uxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.umin.v8i16(<8 x i16> %vec)
  %cmp = icmp ult i16 %x, %min
  %1 = select i1 %cmp, i16 %x, i16 %min
  ret i16 %1
}

define arm_aapcs_vfpcc i32 @uminv4i32(<4 x i32> %vec, i32 %min) {
; CHECK-LABEL: uminv4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.u32 r0, q0
; CHECK-NEXT:    bx lr
  %x = call i32 @llvm.vector.reduce.umin.v4i32(<4 x i32> %vec)
  %cmp = icmp ult i32 %x, %min
  %1 = select i1 %cmp, i32 %x, i32 %min
  ret i32 %1
}

define arm_aapcs_vfpcc signext i8 @sminv16i8(<16 x i8> %vec, i8 signext %min) {
; CHECK-LABEL: sminv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.s8 r0, q0
; CHECK-NEXT:    sxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.smin.v16i8(<16 x i8> %vec)
  %cmp = icmp slt i8 %x, %min
  %1 = select i1 %cmp, i8 %x, i8 %min
  ret i8 %1
}

define arm_aapcs_vfpcc signext i16 @sminv8i16(<8 x i16> %vec, i16 signext %min) {
; CHECK-LABEL: sminv8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.s16 r0, q0
; CHECK-NEXT:    sxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.smin.v8i16(<8 x i16> %vec)
  %cmp = icmp slt i16 %x, %min
  %1 = select i1 %cmp, i16 %x, i16 %min
  ret i16 %1
}

define arm_aapcs_vfpcc i32 @sminv4i32(<4 x i32> %vec, i32 %min) {
; CHECK-LABEL: sminv4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.s32 r0, q0
; CHECK-NEXT:    bx lr
  %x = call i32 @llvm.vector.reduce.smin.v4i32(<4 x i32> %vec)
  %cmp = icmp slt i32 %x, %min
  %1 = select i1 %cmp, i32 %x, i32 %min
  ret i32 %1
}

define arm_aapcs_vfpcc zeroext i8 @umaxv16i8(<16 x i8> %vec, i8 zeroext %max) {
; CHECK-LABEL: umaxv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.u8 r0, q0
; CHECK-NEXT:    uxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.umax.v16i8(<16 x i8> %vec)
  %cmp = icmp ugt i8 %x, %max
  %1 = select i1 %cmp, i8 %x, i8 %max
  ret i8 %1
}

define arm_aapcs_vfpcc zeroext i16 @umaxv8i16(<8 x i16> %vec, i16 zeroext %max) {
; CHECK-LABEL: umaxv8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.u16 r0, q0
; CHECK-NEXT:    uxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.umax.v8i16(<8 x i16> %vec)
  %cmp = icmp ugt i16 %x, %max
  %1 = select i1 %cmp, i16 %x, i16 %max
  ret i16 %1
}

define arm_aapcs_vfpcc i32 @umaxv4i32(<4 x i32> %vec, i32 %max) {
; CHECK-LABEL: umaxv4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.u32 r0, q0
; CHECK-NEXT:    bx lr
  %x = call i32 @llvm.vector.reduce.umax.v4i32(<4 x i32> %vec)
  %cmp = icmp ugt i32 %x, %max
  %1 = select i1 %cmp, i32 %x, i32 %max
  ret i32 %1
}

define arm_aapcs_vfpcc signext i8 @smaxv16i8(<16 x i8> %vec, i8 signext %max) {
; CHECK-LABEL: smaxv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.s8 r0, q0
; CHECK-NEXT:    sxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.smax.v16i8(<16 x i8> %vec)
  %cmp = icmp sgt i8 %x, %max
  %1 = select i1 %cmp, i8 %x, i8 %max
  ret i8 %1
}

define arm_aapcs_vfpcc signext i16 @smaxv8i16(<8 x i16> %vec, i16 signext %max) {
; CHECK-LABEL: smaxv8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.s16 r0, q0
; CHECK-NEXT:    sxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.smax.v8i16(<8 x i16> %vec)
  %cmp = icmp sgt i16 %x, %max
  %1 = select i1 %cmp, i16 %x, i16 %max
  ret i16 %1
}

define arm_aapcs_vfpcc i32 @smaxv4i32(<4 x i32> %vec, i32 %max) {
; CHECK-LABEL: smaxv4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.s32 r0, q0
; CHECK-NEXT:    bx lr
  %x = call i32 @llvm.vector.reduce.smax.v4i32(<4 x i32> %vec)
  %cmp = icmp sgt i32 %x, %max
  %1 = select i1 %cmp, i32 %x, i32 %max
  ret i32 %1
}

define arm_aapcs_vfpcc zeroext i8 @commute_uminv16i8(<16 x i8> %vec, i8 zeroext %min) {
; CHECK-LABEL: commute_uminv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.u8 r0, q0
; CHECK-NEXT:    uxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.umin.v16i8(<16 x i8> %vec)
  %cmp = icmp ult i8 %min, %x
  %1 = select i1 %cmp, i8 %min, i8 %x
  ret i8 %1
}

define arm_aapcs_vfpcc zeroext i16 @commute_uminv8i16(<8 x i16> %vec, i16 zeroext %min) {
; CHECK-LABEL: commute_uminv8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.u16 r0, q0
; CHECK-NEXT:    uxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.umin.v8i16(<8 x i16> %vec)
  %cmp = icmp ult i16 %min, %x
  %1 = select i1 %cmp, i16 %min, i16 %x
  ret i16 %1
}

define arm_aapcs_vfpcc i32 @commute_uminv4i32(<4 x i32> %vec, i32 %min) {
; CHECK-LABEL: commute_uminv4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.u32 r0, q0
; CHECK-NEXT:    bx lr
  %x = call i32 @llvm.vector.reduce.umin.v4i32(<4 x i32> %vec)
  %cmp = icmp ult i32 %min, %x
  %1 = select i1 %cmp, i32 %min, i32 %x
  ret i32 %1
}

define arm_aapcs_vfpcc signext i8 @commute_sminv16i8(<16 x i8> %vec, i8 signext %min) {
; CHECK-LABEL: commute_sminv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.s8 r0, q0
; CHECK-NEXT:    sxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.smin.v16i8(<16 x i8> %vec)
  %cmp = icmp slt i8 %min, %x
  %1 = select i1 %cmp, i8 %min, i8 %x
  ret i8 %1
}

define arm_aapcs_vfpcc signext i16 @commute_sminv8i16(<8 x i16> %vec, i16 signext %min) {
; CHECK-LABEL: commute_sminv8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.s16 r0, q0
; CHECK-NEXT:    sxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.smin.v8i16(<8 x i16> %vec)
  %cmp = icmp slt i16 %min, %x
  %1 = select i1 %cmp, i16 %min, i16 %x
  ret i16 %1
}

define arm_aapcs_vfpcc i32 @commute_sminv4i32(<4 x i32> %vec, i32 %min) {
; CHECK-LABEL: commute_sminv4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.s32 r0, q0
; CHECK-NEXT:    bx lr
  %x = call i32 @llvm.vector.reduce.smin.v4i32(<4 x i32> %vec)
  %cmp = icmp slt i32 %min, %x
  %1 = select i1 %cmp, i32 %min, i32 %x
  ret i32 %1
}

define arm_aapcs_vfpcc zeroext i8 @commute_umaxv16i8(<16 x i8> %vec, i8 zeroext %max) {
; CHECK-LABEL: commute_umaxv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.u8 r0, q0
; CHECK-NEXT:    uxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.umax.v16i8(<16 x i8> %vec)
  %cmp = icmp ugt i8 %max, %x
  %1 = select i1 %cmp, i8 %max, i8 %x
  ret i8 %1
}

define arm_aapcs_vfpcc zeroext i16 @commute_umaxv8i16(<8 x i16> %vec, i16 zeroext %max) {
; CHECK-LABEL: commute_umaxv8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.u16 r0, q0
; CHECK-NEXT:    uxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.umax.v8i16(<8 x i16> %vec)
  %cmp = icmp ugt i16 %max, %x
  %1 = select i1 %cmp, i16 %max, i16 %x
  ret i16 %1
}

define arm_aapcs_vfpcc i32 @commute_umaxv4i32(<4 x i32> %vec, i32 %max) {
; CHECK-LABEL: commute_umaxv4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.u32 r0, q0
; CHECK-NEXT:    bx lr
  %x = call i32 @llvm.vector.reduce.umax.v4i32(<4 x i32> %vec)
  %cmp = icmp ugt i32 %max, %x
  %1 = select i1 %cmp, i32 %max, i32 %x
  ret i32 %1
}

define arm_aapcs_vfpcc signext i8 @commute_smaxv16i8(<16 x i8> %vec, i8 signext %max) {
; CHECK-LABEL: commute_smaxv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.s8 r0, q0
; CHECK-NEXT:    sxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.smax.v16i8(<16 x i8> %vec)
  %cmp = icmp sgt i8 %max, %x
  %1 = select i1 %cmp, i8 %max, i8 %x
  ret i8 %1
}

define arm_aapcs_vfpcc signext i16 @commute_smaxv8i16(<8 x i16> %vec, i16 signext %max) {
; CHECK-LABEL: commute_smaxv8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.s16 r0, q0
; CHECK-NEXT:    sxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.smax.v8i16(<8 x i16> %vec)
  %cmp = icmp sgt i16 %max, %x
  %1 = select i1 %cmp, i16 %max, i16 %x
  ret i16 %1
}

define arm_aapcs_vfpcc i32 @commute_smaxv4i32(<4 x i32> %vec, i32 %max) {
; CHECK-LABEL: commute_smaxv4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.s32 r0, q0
; CHECK-NEXT:    bx lr
  %x = call i32 @llvm.vector.reduce.smax.v4i32(<4 x i32> %vec)
  %cmp = icmp sgt i32 %max, %x
  %1 = select i1 %cmp, i32 %max, i32 %x
  ret i32 %1
}

define arm_aapcs_vfpcc signext i8 @mismatch_smaxv16i8(<16 x i8> %vec, i8 signext %max) {
; CHECK-LABEL: mismatch_smaxv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    mvn r1, #127
; CHECK-NEXT:    vmaxv.s8 r1, q0
; CHECK-NEXT:    sxtb r2, r1
; CHECK-NEXT:    cmp r2, r0
; CHECK-NEXT:    csel r0, r0, r1, gt
; CHECK-NEXT:    sxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.smax.v16i8(<16 x i8> %vec)
  %cmp = icmp sgt i8 %x, %max
  %1 = select i1 %cmp, i8 %max, i8 %x
  ret i8 %1
}

define arm_aapcs_vfpcc signext i8 @mismatch2_smaxv16i8(<16 x i8> %vec, i8 signext %max) {
; CHECK-LABEL: mismatch2_smaxv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    mvn r1, #127
; CHECK-NEXT:    vmaxv.s8 r1, q0
; CHECK-NEXT:    sxtb r2, r1
; CHECK-NEXT:    cmp r0, r2
; CHECK-NEXT:    csel r0, r1, r0, gt
; CHECK-NEXT:    sxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.smax.v16i8(<16 x i8> %vec)
  %cmp = icmp sgt i8 %max, %x
  %1 = select i1 %cmp, i8 %x, i8 %max
  ret i8 %1
}

define arm_aapcs_vfpcc zeroext i8 @inverted_uminv16i8(<16 x i8> %vec, i8 zeroext %min) {
; CHECK-LABEL: inverted_uminv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.u8 r0, q0
; CHECK-NEXT:    uxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.umin.v16i8(<16 x i8> %vec)
  %cmp = icmp ugt i8 %x, %min
  %1 = select i1 %cmp, i8 %min, i8 %x
  ret i8 %1
}

define arm_aapcs_vfpcc zeroext i16 @inverted_uminv8i16(<8 x i16> %vec, i16 zeroext %min) {
; CHECK-LABEL: inverted_uminv8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.u16 r0, q0
; CHECK-NEXT:    uxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.umin.v8i16(<8 x i16> %vec)
  %cmp = icmp ugt i16 %x, %min
  %1 = select i1 %cmp, i16 %min, i16 %x
  ret i16 %1
}

define arm_aapcs_vfpcc i32 @inverted_uminv4i32(<4 x i32> %vec, i32 %min) {
; CHECK-LABEL: inverted_uminv4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.u32 r0, q0
; CHECK-NEXT:    bx lr
  %x = call i32 @llvm.vector.reduce.umin.v4i32(<4 x i32> %vec)
  %cmp = icmp ugt i32 %x, %min
  %1 = select i1 %cmp, i32 %min, i32 %x
  ret i32 %1
}

define arm_aapcs_vfpcc signext i8 @inverted_sminv16i8(<16 x i8> %vec, i8 signext %min) {
; CHECK-LABEL: inverted_sminv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.s8 r0, q0
; CHECK-NEXT:    sxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.smin.v16i8(<16 x i8> %vec)
  %cmp = icmp sgt i8 %x, %min
  %1 = select i1 %cmp, i8 %min, i8 %x
  ret i8 %1
}

define arm_aapcs_vfpcc signext i16 @inverted_sminv8i16(<8 x i16> %vec, i16 signext %min) {
; CHECK-LABEL: inverted_sminv8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.s16 r0, q0
; CHECK-NEXT:    sxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.smin.v8i16(<8 x i16> %vec)
  %cmp = icmp sgt i16 %x, %min
  %1 = select i1 %cmp, i16 %min, i16 %x
  ret i16 %1
}

define arm_aapcs_vfpcc i32 @inverted_sminv4i32(<4 x i32> %vec, i32 %min) {
; CHECK-LABEL: inverted_sminv4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vminv.s32 r0, q0
; CHECK-NEXT:    bx lr
  %x = call i32 @llvm.vector.reduce.smin.v4i32(<4 x i32> %vec)
  %cmp = icmp sgt i32 %x, %min
  %1 = select i1 %cmp, i32 %min, i32 %x
  ret i32 %1
}

define arm_aapcs_vfpcc zeroext i8 @inverted_umaxv16i8(<16 x i8> %vec, i8 zeroext %max) {
; CHECK-LABEL: inverted_umaxv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.u8 r0, q0
; CHECK-NEXT:    uxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.umax.v16i8(<16 x i8> %vec)
  %cmp = icmp ult i8 %x, %max
  %1 = select i1 %cmp, i8 %max, i8 %x
  ret i8 %1
}

define arm_aapcs_vfpcc zeroext i16 @inverted_umaxv8i16(<8 x i16> %vec, i16 zeroext %max) {
; CHECK-LABEL: inverted_umaxv8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.u16 r0, q0
; CHECK-NEXT:    uxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.umax.v8i16(<8 x i16> %vec)
  %cmp = icmp ult i16 %x, %max
  %1 = select i1 %cmp, i16 %max, i16 %x
  ret i16 %1
}

define arm_aapcs_vfpcc i32 @inverted_umaxv4i32(<4 x i32> %vec, i32 %max) {
; CHECK-LABEL: inverted_umaxv4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.u32 r0, q0
; CHECK-NEXT:    bx lr
  %x = call i32 @llvm.vector.reduce.umax.v4i32(<4 x i32> %vec)
  %cmp = icmp ult i32 %x, %max
  %1 = select i1 %cmp, i32 %max, i32 %x
  ret i32 %1
}

define arm_aapcs_vfpcc signext i8 @inverted_smaxv16i8(<16 x i8> %vec, i8 signext %max) {
; CHECK-LABEL: inverted_smaxv16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.s8 r0, q0
; CHECK-NEXT:    sxtb r0, r0
; CHECK-NEXT:    bx lr
  %x = call i8 @llvm.vector.reduce.smax.v16i8(<16 x i8> %vec)
  %cmp = icmp slt i8 %x, %max
  %1 = select i1 %cmp, i8 %max, i8 %x
  ret i8 %1
}

define arm_aapcs_vfpcc signext i16 @inverted_smaxv8i16(<8 x i16> %vec, i16 signext %max) {
; CHECK-LABEL: inverted_smaxv8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.s16 r0, q0
; CHECK-NEXT:    sxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.smax.v8i16(<8 x i16> %vec)
  %cmp = icmp slt i16 %x, %max
  %1 = select i1 %cmp, i16 %max, i16 %x
  ret i16 %1
}

define arm_aapcs_vfpcc i32 @inverted_smaxv4i32(<4 x i32> %vec, i32 %max) {
; CHECK-LABEL: inverted_smaxv4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmaxv.s32 r0, q0
; CHECK-NEXT:    bx lr
  %x = call i32 @llvm.vector.reduce.smax.v4i32(<4 x i32> %vec)
  %cmp = icmp slt i32 %x, %max
  %1 = select i1 %cmp, i32 %max, i32 %x
  ret i32 %1
}

define arm_aapcs_vfpcc signext i16 @trunc_and_sext(<8 x i16> %vec, i32 %max) #1 {
; CHECK-LABEL: trunc_and_sext:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r1, #32768
; CHECK-NEXT:    movt r1, #65535
; CHECK-NEXT:    vmaxv.s16 r1, q0
; CHECK-NEXT:    sxth r2, r1
; CHECK-NEXT:    cmp r0, r2
; CHECK-NEXT:    csel r0, r0, r1, gt
; CHECK-NEXT:    sxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.smax.v8i16(<8 x i16> %vec)
  %xs = sext i16 %x to i32
  %cmp = icmp sgt i32 %max, %xs
  %mt = trunc i32 %max to i16
  %1 = select i1 %cmp, i16 %mt, i16 %x
  ret i16 %1
}

define arm_aapcs_vfpcc signext i16 @trunc_and_zext(<8 x i16> %vec, i32 %max) #1 {
; CHECK-LABEL: trunc_and_zext:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:    vmaxv.u16 r1, q0
; CHECK-NEXT:    uxth r2, r1
; CHECK-NEXT:    cmp r0, r2
; CHECK-NEXT:    csel r0, r0, r1, gt
; CHECK-NEXT:    sxth r0, r0
; CHECK-NEXT:    bx lr
  %x = call i16 @llvm.vector.reduce.umax.v8i16(<8 x i16> %vec)
  %xs = zext i16 %x to i32
  %cmp = icmp sgt i32 %max, %xs
  %mt = trunc i32 %max to i16
  %1 = select i1 %cmp, i16 %mt, i16 %x
  ret i16 %1
}

define arm_aapcs_vfpcc i64 @uminv2i64(<2 x i64> %vec, i64 %min) {
; CHECK-LABEL: uminv2i64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    vmov r2, r12, d1
; CHECK-NEXT:    vmov r3, lr, d0
; CHECK-NEXT:    cmp r3, r2
; CHECK-NEXT:    csel r4, r3, r2, lo
; CHECK-NEXT:    cmp lr, r12
; CHECK-NEXT:    csel r2, r3, r2, lo
; CHECK-NEXT:    csel r3, lr, r12, lo
; CHECK-NEXT:    csel r2, r4, r2, eq
; CHECK-NEXT:    subs r4, r2, r0
; CHECK-NEXT:    sbcs.w r4, r3, r1
; CHECK-NEXT:    cset r4, lo
; CHECK-NEXT:    cmp r4, #0
; CHECK-NEXT:    csel r0, r2, r0, ne
; CHECK-NEXT:    csel r1, r3, r1, ne
; CHECK-NEXT:    pop {r4, pc}
  %x = call i64 @llvm.vector.reduce.umin.v2i64(<2 x i64> %vec)
  %cmp = icmp ult i64 %x, %min
  %1 = select i1 %cmp, i64 %x, i64 %min
  ret i64 %1
}

define arm_aapcs_vfpcc i64 @sminv2i64(<2 x i64> %vec, i64 %min) {
; CHECK-LABEL: sminv2i64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    vmov r2, r12, d1
; CHECK-NEXT:    vmov r3, lr, d0
; CHECK-NEXT:    cmp r3, r2
; CHECK-NEXT:    csel r4, r3, r2, lo
; CHECK-NEXT:    cmp lr, r12
; CHECK-NEXT:    csel r2, r3, r2, lt
; CHECK-NEXT:    csel r3, lr, r12, lt
; CHECK-NEXT:    csel r2, r4, r2, eq
; CHECK-NEXT:    subs r4, r2, r0
; CHECK-NEXT:    sbcs.w r4, r3, r1
; CHECK-NEXT:    cset r4, lt
; CHECK-NEXT:    cmp r4, #0
; CHECK-NEXT:    csel r0, r2, r0, ne
; CHECK-NEXT:    csel r1, r3, r1, ne
; CHECK-NEXT:    pop {r4, pc}
  %x = call i64 @llvm.vector.reduce.smin.v2i64(<2 x i64> %vec)
  %cmp = icmp slt i64 %x, %min
  %1 = select i1 %cmp, i64 %x, i64 %min
  ret i64 %1
}

define arm_aapcs_vfpcc i64 @umaxv2i64(<2 x i64> %vec, i64 %max) {
; CHECK-LABEL: umaxv2i64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    vmov r2, r12, d1
; CHECK-NEXT:    vmov r3, lr, d0
; CHECK-NEXT:    cmp r3, r2
; CHECK-NEXT:    csel r4, r3, r2, hi
; CHECK-NEXT:    cmp lr, r12
; CHECK-NEXT:    csel r2, r3, r2, hi
; CHECK-NEXT:    csel r3, lr, r12, hi
; CHECK-NEXT:    csel r2, r4, r2, eq
; CHECK-NEXT:    subs r4, r0, r2
; CHECK-NEXT:    sbcs.w r4, r1, r3
; CHECK-NEXT:    cset r4, lo
; CHECK-NEXT:    cmp r4, #0
; CHECK-NEXT:    csel r0, r2, r0, ne
; CHECK-NEXT:    csel r1, r3, r1, ne
; CHECK-NEXT:    pop {r4, pc}
  %x = call i64 @llvm.vector.reduce.umax.v2i64(<2 x i64> %vec)
  %cmp = icmp ugt i64 %x, %max
  %1 = select i1 %cmp, i64 %x, i64 %max
  ret i64 %1
}

define arm_aapcs_vfpcc i64 @smaxv2i64(<2 x i64> %vec, i64 %max) {
; CHECK-LABEL: smaxv2i64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    vmov r2, r12, d1
; CHECK-NEXT:    vmov r3, lr, d0
; CHECK-NEXT:    cmp r3, r2
; CHECK-NEXT:    csel r4, r3, r2, hi
; CHECK-NEXT:    cmp lr, r12
; CHECK-NEXT:    csel r2, r3, r2, gt
; CHECK-NEXT:    csel r3, lr, r12, gt
; CHECK-NEXT:    csel r2, r4, r2, eq
; CHECK-NEXT:    subs r4, r0, r2
; CHECK-NEXT:    sbcs.w r4, r1, r3
; CHECK-NEXT:    cset r4, lt
; CHECK-NEXT:    cmp r4, #0
; CHECK-NEXT:    csel r0, r2, r0, ne
; CHECK-NEXT:    csel r1, r3, r1, ne
; CHECK-NEXT:    pop {r4, pc}
  %x = call i64 @llvm.vector.reduce.smax.v2i64(<2 x i64> %vec)
  %cmp = icmp sgt i64 %x, %max
  %1 = select i1 %cmp, i64 %x, i64 %max
  ret i64 %1
}

declare i8 @llvm.vector.reduce.umin.v16i8(<16 x i8>)

declare i16 @llvm.vector.reduce.umin.v8i16(<8 x i16>)

declare i32 @llvm.vector.reduce.umin.v4i32(<4 x i32>)

declare i64 @llvm.vector.reduce.umin.v2i64(<2 x i64>)

declare i8 @llvm.vector.reduce.smin.v16i8(<16 x i8>)

declare i16 @llvm.vector.reduce.smin.v8i16(<8 x i16>)

declare i32 @llvm.vector.reduce.smin.v4i32(<4 x i32>)

declare i64 @llvm.vector.reduce.smin.v2i64(<2 x i64>)

declare i8 @llvm.vector.reduce.umax.v16i8(<16 x i8>)

declare i16 @llvm.vector.reduce.umax.v8i16(<8 x i16>)

declare i32 @llvm.vector.reduce.umax.v4i32(<4 x i32>)

declare i64 @llvm.vector.reduce.umax.v2i64(<2 x i64>)

declare i8 @llvm.vector.reduce.smax.v16i8(<16 x i8>)

declare i16 @llvm.vector.reduce.smax.v8i16(<8 x i16>)

declare i32 @llvm.vector.reduce.smax.v4i32(<4 x i32>)

declare i64 @llvm.vector.reduce.smax.v2i64(<2 x i64>)
