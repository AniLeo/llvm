; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O3 -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve %s -o - | FileCheck %s

define arm_aapcs_vfpcc <16 x i8> @shl_qq_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: shl_qq_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshl.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = shl <16 x i8> %src1, %src2
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @shl_qq_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: shl_qq_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshl.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = shl <8 x i16> %src1, %src2
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @shl_qq_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: shl_qq_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshl.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = shl <4 x i32> %src1, %src2
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @shl_qq_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: shl_qq_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    lsll r2, r1, r0
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov.32 q2[0], r2
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov.32 q2[1], r1
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    lsll r2, r1, r0
; CHECK-NEXT:    vmov.32 q2[2], r2
; CHECK-NEXT:    vmov.32 q2[3], r1
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = shl <2 x i64> %src1, %src2
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <16 x i8> @shru_qq_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: shru_qq_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vneg.s8 q1, q1
; CHECK-NEXT:    vshl.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr <16 x i8> %src1, %src2
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @shru_qq_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: shru_qq_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vneg.s16 q1, q1
; CHECK-NEXT:    vshl.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr <8 x i16> %src1, %src2
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @shru_qq_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: shru_qq_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vneg.s32 q1, q1
; CHECK-NEXT:    vshl.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr <4 x i32> %src1, %src2
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @shru_qq_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: shru_qq_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    vmov r2, s6
; CHECK-NEXT:    vmov.32 q2[0], r0
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov.32 q2[1], r1
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    vmov.32 q2[2], r0
; CHECK-NEXT:    vmov.32 q2[3], r1
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr <2 x i64> %src1, %src2
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <16 x i8> @shrs_qq_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: shrs_qq_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vneg.s8 q1, q1
; CHECK-NEXT:    vshl.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = ashr <16 x i8> %src1, %src2
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @shrs_qq_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: shrs_qq_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vneg.s16 q1, q1
; CHECK-NEXT:    vshl.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = ashr <8 x i16> %src1, %src2
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @shrs_qq_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: shrs_qq_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vneg.s32 q1, q1
; CHECK-NEXT:    vshl.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = ashr <4 x i32> %src1, %src2
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @shrs_qq_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: shrs_qq_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    asrl r2, r1, r0
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov.32 q2[0], r2
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov.32 q2[1], r1
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    asrl r2, r1, r0
; CHECK-NEXT:    vmov.32 q2[2], r2
; CHECK-NEXT:    vmov.32 q2[3], r1
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = ashr <2 x i64> %src1, %src2
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <16 x i8> @shl_qi_int8_t(<16 x i8> %src1) {
; CHECK-LABEL: shl_qi_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshl.i8 q0, q0, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = shl <16 x i8> %src1, <i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4>
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @shl_qi_int16_t(<8 x i16> %src1) {
; CHECK-LABEL: shl_qi_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshl.i16 q0, q0, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = shl <8 x i16> %src1, <i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4>
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @shl_qi_int32_t(<4 x i32> %src1) {
; CHECK-LABEL: shl_qi_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshl.i32 q0, q0, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = shl <4 x i32> %src1, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @shl_qi_int64_t(<2 x i64> %src1) {
; CHECK-LABEL: shl_qi_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    lsll r0, r1, #4
; CHECK-NEXT:    vmov.32 q1[0], r0
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    lsll r0, r1, #4
; CHECK-NEXT:    vmov.32 q1[2], r0
; CHECK-NEXT:    vmov.32 q1[3], r1
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = shl <2 x i64> %src1, <i64 4, i64 4>
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <16 x i8> @shru_qi_int8_t(<16 x i8> %src1) {
; CHECK-LABEL: shru_qi_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshr.u8 q0, q0, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr <16 x i8> %src1, <i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4>
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @shru_qi_int16_t(<8 x i16> %src1) {
; CHECK-LABEL: shru_qi_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshr.u16 q0, q0, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr <8 x i16> %src1, <i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4>
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @shru_qi_int32_t(<4 x i32> %src1) {
; CHECK-LABEL: shru_qi_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshr.u32 q0, q0, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr <4 x i32> %src1, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @shru_qi_int64_t(<2 x i64> %src1) {
; CHECK-LABEL: shru_qi_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    lsrl r0, r1, #4
; CHECK-NEXT:    vmov.32 q1[0], r0
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    lsrl r0, r1, #4
; CHECK-NEXT:    vmov.32 q1[2], r0
; CHECK-NEXT:    vmov.32 q1[3], r1
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr <2 x i64> %src1, <i64 4, i64 4>
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <16 x i8> @shrs_qi_int8_t(<16 x i8> %src1) {
; CHECK-LABEL: shrs_qi_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshr.s8 q0, q0, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = ashr <16 x i8> %src1, <i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4>
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @shrs_qi_int16_t(<8 x i16> %src1) {
; CHECK-LABEL: shrs_qi_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshr.s16 q0, q0, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = ashr <8 x i16> %src1, <i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4, i16 4>
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @shrs_qi_int32_t(<4 x i32> %src1) {
; CHECK-LABEL: shrs_qi_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshr.s32 q0, q0, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = ashr <4 x i32> %src1, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @shrs_qi_int64_t(<2 x i64> %src1) {
; CHECK-LABEL: shrs_qi_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    asrl r0, r1, #4
; CHECK-NEXT:    vmov.32 q1[0], r0
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    asrl r0, r1, #4
; CHECK-NEXT:    vmov.32 q1[2], r0
; CHECK-NEXT:    vmov.32 q1[3], r1
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = ashr <2 x i64> %src1, <i64 4, i64 4>
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <16 x i8> @shl_qr_int8_t(<16 x i8> %src1, i8 %src2) {
; CHECK-LABEL: shl_qr_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshl.u8 q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <16 x i8> undef, i8 %src2, i32 0
  %s = shufflevector <16 x i8> %i, <16 x i8> undef, <16 x i32> zeroinitializer
  %0 = shl <16 x i8> %src1, %s
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @shl_qr_int16_t(<8 x i16> %src1, i16 %src2) {
; CHECK-LABEL: shl_qr_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshl.u16 q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <8 x i16> undef, i16 %src2, i32 0
  %s = shufflevector <8 x i16> %i, <8 x i16> undef, <8 x i32> zeroinitializer
  %0 = shl <8 x i16> %src1, %s
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @shl_qr_int32_t(<4 x i32> %src1, i32 %src2) {
; CHECK-LABEL: shl_qr_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshl.u32 q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <4 x i32> undef, i32 %src2, i32 0
  %s = shufflevector <4 x i32> %i, <4 x i32> undef, <4 x i32> zeroinitializer
  %0 = shl <4 x i32> %src1, %s
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @shl_qr_int64_t(<2 x i64> %src1, i64 %src2) {
; CHECK-LABEL: shl_qr_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    lsll r2, r1, r0
; CHECK-NEXT:    vmov.32 q1[0], r2
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    lsll r2, r1, r0
; CHECK-NEXT:    vmov.32 q1[2], r2
; CHECK-NEXT:    vmov.32 q1[3], r1
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <2 x i64> undef, i64 %src2, i32 0
  %s = shufflevector <2 x i64> %i, <2 x i64> undef, <2 x i32> zeroinitializer
  %0 = shl <2 x i64> %src1, %s
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <16 x i8> @shru_qr_int8_t(<16 x i8> %src1, i8 %src2) {
; CHECK-LABEL: shru_qr_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    subs r0, #0, r0
; CHECK-NEXT:    vshl.u8 q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <16 x i8> undef, i8 %src2, i32 0
  %s = shufflevector <16 x i8> %i, <16 x i8> undef, <16 x i32> zeroinitializer
  %0 = lshr <16 x i8> %src1, %s
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @shru_qr_int16_t(<8 x i16> %src1, i16 %src2) {
; CHECK-LABEL: shru_qr_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    subs r0, #0, r0
; CHECK-NEXT:    vshl.u16 q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <8 x i16> undef, i16 %src2, i32 0
  %s = shufflevector <8 x i16> %i, <8 x i16> undef, <8 x i32> zeroinitializer
  %0 = lshr <8 x i16> %src1, %s
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @shru_qr_int32_t(<4 x i32> %src1, i32 %src2) {
; CHECK-LABEL: shru_qr_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    subs r0, #0, r0
; CHECK-NEXT:    vshl.u32 q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <4 x i32> undef, i32 %src2, i32 0
  %s = shufflevector <4 x i32> %i, <4 x i32> undef, <4 x i32> zeroinitializer
  %0 = lshr <4 x i32> %src1, %s
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @shru_qr_int64_t(<2 x i64> %src1, i64 %src2) {
; CHECK-LABEL: shru_qr_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    rsbs r0, r0, #0
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    lsll r2, r1, r0
; CHECK-NEXT:    vmov.32 q1[0], r2
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    lsll r2, r1, r0
; CHECK-NEXT:    vmov.32 q1[2], r2
; CHECK-NEXT:    vmov.32 q1[3], r1
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <2 x i64> undef, i64 %src2, i32 0
  %s = shufflevector <2 x i64> %i, <2 x i64> undef, <2 x i32> zeroinitializer
  %0 = lshr <2 x i64> %src1, %s
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <16 x i8> @shrs_qr_int8_t(<16 x i8> %src1, i8 %src2) {
; CHECK-LABEL: shrs_qr_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    subs r0, #0, r0
; CHECK-NEXT:    vshl.s8 q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <16 x i8> undef, i8 %src2, i32 0
  %s = shufflevector <16 x i8> %i, <16 x i8> undef, <16 x i32> zeroinitializer
  %0 = ashr <16 x i8> %src1, %s
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @shrs_qr_int16_t(<8 x i16> %src1, i16 %src2) {
; CHECK-LABEL: shrs_qr_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    subs r0, #0, r0
; CHECK-NEXT:    vshl.s16 q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <8 x i16> undef, i16 %src2, i32 0
  %s = shufflevector <8 x i16> %i, <8 x i16> undef, <8 x i32> zeroinitializer
  %0 = ashr <8 x i16> %src1, %s
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @shrs_qr_int32_t(<4 x i32> %src1, i32 %src2) {
; CHECK-LABEL: shrs_qr_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    subs r0, #0, r0
; CHECK-NEXT:    vshl.s32 q0, r0
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <4 x i32> undef, i32 %src2, i32 0
  %s = shufflevector <4 x i32> %i, <4 x i32> undef, <4 x i32> zeroinitializer
  %0 = ashr <4 x i32> %src1, %s
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @shrs_qr_int64_t(<2 x i64> %src1, i64 %src2) {
; CHECK-LABEL: shrs_qr_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    asrl r2, r1, r0
; CHECK-NEXT:    vmov.32 q1[0], r2
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    asrl r2, r1, r0
; CHECK-NEXT:    vmov.32 q1[2], r2
; CHECK-NEXT:    vmov.32 q1[3], r1
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <2 x i64> undef, i64 %src2, i32 0
  %s = shufflevector <2 x i64> %i, <2 x i64> undef, <2 x i32> zeroinitializer
  %0 = ashr <2 x i64> %src1, %s
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <16 x i8> @shl_qiv_int8_t(<16 x i8> %src1) {
; CHECK-LABEL: shl_qiv_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adr r0, .LCPI36_0
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vshl.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI36_0:
; CHECK-NEXT:    .byte 1 @ 0x1
; CHECK-NEXT:    .byte 2 @ 0x2
; CHECK-NEXT:    .byte 3 @ 0x3
; CHECK-NEXT:    .byte 4 @ 0x4
; CHECK-NEXT:    .byte 1 @ 0x1
; CHECK-NEXT:    .byte 2 @ 0x2
; CHECK-NEXT:    .byte 3 @ 0x3
; CHECK-NEXT:    .byte 4 @ 0x4
; CHECK-NEXT:    .byte 1 @ 0x1
; CHECK-NEXT:    .byte 2 @ 0x2
; CHECK-NEXT:    .byte 3 @ 0x3
; CHECK-NEXT:    .byte 4 @ 0x4
; CHECK-NEXT:    .byte 1 @ 0x1
; CHECK-NEXT:    .byte 2 @ 0x2
; CHECK-NEXT:    .byte 3 @ 0x3
; CHECK-NEXT:    .byte 4 @ 0x4
entry:
  %0 = shl <16 x i8> %src1, <i8 1, i8 2, i8 3, i8 4, i8 1, i8 2, i8 3, i8 4, i8 1, i8 2, i8 3, i8 4, i8 1, i8 2, i8 3, i8 4>
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @shl_qiv_int16_t(<8 x i16> %src1) {
; CHECK-LABEL: shl_qiv_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adr r0, .LCPI37_0
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vshl.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI37_0:
; CHECK-NEXT:    .short 1 @ 0x1
; CHECK-NEXT:    .short 2 @ 0x2
; CHECK-NEXT:    .short 3 @ 0x3
; CHECK-NEXT:    .short 4 @ 0x4
; CHECK-NEXT:    .short 1 @ 0x1
; CHECK-NEXT:    .short 2 @ 0x2
; CHECK-NEXT:    .short 3 @ 0x3
; CHECK-NEXT:    .short 4 @ 0x4
entry:
  %0 = shl <8 x i16> %src1, <i16 1, i16 2, i16 3, i16 4, i16 1, i16 2, i16 3, i16 4>
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @shl_qiv_int32_t(<4 x i32> %src1) {
; CHECK-LABEL: shl_qiv_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adr r0, .LCPI38_0
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vshl.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI38_0:
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .long 2 @ 0x2
; CHECK-NEXT:    .long 3 @ 0x3
; CHECK-NEXT:    .long 4 @ 0x4
entry:
  %0 = shl <4 x i32> %src1, <i32 1, i32 2, i32 3, i32 4>
  ret <4 x i32> %0
}
