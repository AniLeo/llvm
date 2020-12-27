; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv7a-eabi -mattr=+neon -float-abi=hard %s -o - | FileCheck %s

define <8 x i8> @vmlai8(<8 x i8> %A, <8 x i8> %B, <8 x i8>  %C) nounwind {
; CHECK-LABEL: vmlai8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmla.i8 d0, d1, d2
; CHECK-NEXT:    bx lr
  %tmp4 = mul <8 x i8> %B, %C
  %tmp5 = add <8 x i8> %A, %tmp4
  ret <8 x i8> %tmp5
}

define <4 x i16> @vmlai16(<4 x i16> %A, <4 x i16> %B, <4 x i16> %C) nounwind {
; CHECK-LABEL: vmlai16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmla.i16 d0, d1, d2
; CHECK-NEXT:    bx lr
  %tmp4 = mul <4 x i16> %B, %C
  %tmp5 = add <4 x i16> %A, %tmp4
  ret <4 x i16> %tmp5
}

define <2 x i32> @vmlai32(<2 x i32> %A, <2 x i32> %B, <2 x i32> %C) nounwind {
; CHECK-LABEL: vmlai32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmla.i32 d0, d1, d2
; CHECK-NEXT:    bx lr
  %tmp4 = mul <2 x i32> %B, %C
  %tmp5 = add <2 x i32> %A, %tmp4
  ret <2 x i32> %tmp5
}

define <2 x float> @vmlaf32(<2 x float> %A, <2 x float> %B, <2 x float> %C) nounwind {
; CHECK-LABEL: vmlaf32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmla.f32 d0, d1, d2
; CHECK-NEXT:    bx lr
  %tmp4 = fmul <2 x float> %B, %C
  %tmp5 = fadd <2 x float> %A, %tmp4
  ret <2 x float> %tmp5
}

define <16 x i8> @vmlaQi8(<16 x i8> %A, <16 x i8> %B, <16 x i8>  %C) nounwind {
; CHECK-LABEL: vmlaQi8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmla.i8 q0, q1, q2
; CHECK-NEXT:    bx lr
  %tmp4 = mul <16 x i8> %B, %C
  %tmp5 = add <16 x i8> %A, %tmp4
  ret <16 x i8> %tmp5
}

define <8 x i16> @vmlaQi16(<8 x i16> %A, <8 x i16> %B, <8 x i16> %C) nounwind {
; CHECK-LABEL: vmlaQi16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmla.i16 q0, q1, q2
; CHECK-NEXT:    bx lr
  %tmp4 = mul <8 x i16> %B, %C
  %tmp5 = add <8 x i16> %A, %tmp4
  ret <8 x i16> %tmp5
}

define <4 x i32> @vmlaQi32(<4 x i32> %A, <4 x i32> %B, <4 x i32> %C) nounwind {
; CHECK-LABEL: vmlaQi32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmla.i32 q0, q1, q2
; CHECK-NEXT:    bx lr
  %tmp4 = mul <4 x i32> %B, %C
  %tmp5 = add <4 x i32> %A, %tmp4
  ret <4 x i32> %tmp5
}

define <4 x float> @vmlaQf32(<4 x float> %A, <4 x float> %B, <4 x float> %C) nounwind {
; CHECK-LABEL: vmlaQf32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmla.f32 q0, q1, q2
; CHECK-NEXT:    bx lr
  %tmp4 = fmul <4 x float> %B, %C
  %tmp5 = fadd <4 x float> %A, %tmp4
  ret <4 x float> %tmp5
}

define <8 x i16> @vmlals8(<8 x i16> %A, <8 x i8> %B, <8 x i8> %C) nounwind {
; CHECK-LABEL: vmlals8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmlal.s8 q0, d2, d3
; CHECK-NEXT:    bx lr
  %tmp4 = sext <8 x i8> %B to <8 x i16>
  %tmp5 = sext <8 x i8> %C to <8 x i16>
  %tmp6 = mul <8 x i16> %tmp4, %tmp5
  %tmp7 = add <8 x i16> %A, %tmp6
  ret <8 x i16> %tmp7
}

define <4 x i32> @vmlals16(<4 x i32> %A, <4 x i16> %B, <4 x i16> %C) nounwind {
; CHECK-LABEL: vmlals16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmlal.s16 q0, d2, d3
; CHECK-NEXT:    bx lr
  %tmp4 = sext <4 x i16> %B to <4 x i32>
  %tmp5 = sext <4 x i16> %C to <4 x i32>
  %tmp6 = mul <4 x i32> %tmp4, %tmp5
  %tmp7 = add <4 x i32> %A, %tmp6
  ret <4 x i32> %tmp7
}

define <2 x i64> @vmlals32(<2 x i64> %A, <2 x i32> %B, <2 x i32> %C) nounwind {
; CHECK-LABEL: vmlals32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmlal.s32 q0, d2, d3
; CHECK-NEXT:    bx lr
  %tmp4 = sext <2 x i32> %B to <2 x i64>
  %tmp5 = sext <2 x i32> %C to <2 x i64>
  %tmp6 = mul <2 x i64> %tmp4, %tmp5
  %tmp7 = add <2 x i64> %A, %tmp6
  ret <2 x i64> %tmp7
}

define <8 x i16> @vmlalu8(<8 x i16> %A, <8 x i8> %B, <8 x i8> %C) nounwind {
; CHECK-LABEL: vmlalu8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmlal.u8 q0, d2, d3
; CHECK-NEXT:    bx lr
  %tmp4 = zext <8 x i8> %B to <8 x i16>
  %tmp5 = zext <8 x i8> %C to <8 x i16>
  %tmp6 = mul <8 x i16> %tmp4, %tmp5
  %tmp7 = add <8 x i16> %A, %tmp6
  ret <8 x i16> %tmp7
}

define <4 x i32> @vmlalu16(<4 x i32> %A, <4 x i16> %B, <4 x i16> %C) nounwind {
; CHECK-LABEL: vmlalu16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmlal.u16 q0, d2, d3
; CHECK-NEXT:    bx lr
  %tmp4 = zext <4 x i16> %B to <4 x i32>
  %tmp5 = zext <4 x i16> %C to <4 x i32>
  %tmp6 = mul <4 x i32> %tmp4, %tmp5
  %tmp7 = add <4 x i32> %A, %tmp6
  ret <4 x i32> %tmp7
}

define <2 x i64> @vmlalu32(<2 x i64> %A, <2 x i32> %B, <2 x i32> %C) nounwind {
; CHECK-LABEL: vmlalu32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmlal.u32 q0, d2, d3
; CHECK-NEXT:    bx lr
  %tmp4 = zext <2 x i32> %B to <2 x i64>
  %tmp5 = zext <2 x i32> %C to <2 x i64>
  %tmp6 = mul <2 x i64> %tmp4, %tmp5
  %tmp7 = add <2 x i64> %A, %tmp6
  ret <2 x i64> %tmp7
}

define <8 x i16> @vmlala8(<8 x i16> %A, <8 x i8> %B, <8 x i8> %C) nounwind {
; CHECK-LABEL: vmlala8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmovl.u8 q8, d3
; CHECK-NEXT:    vmovl.u8 q9, d2
; CHECK-NEXT:    vmla.i16 q0, q9, q8
; CHECK-NEXT:    vbic.i16 q0, #0xff00
; CHECK-NEXT:    bx lr
  %tmp4 = zext <8 x i8> %B to <8 x i16>
  %tmp5 = zext <8 x i8> %C to <8 x i16>
  %tmp6 = mul <8 x i16> %tmp4, %tmp5
  %tmp7 = add <8 x i16> %A, %tmp6
  %and = and <8 x i16> %tmp7, <i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255>
  ret <8 x i16> %and
}

define <4 x i32> @vmlala16(<4 x i32> %A, <4 x i16> %B, <4 x i16> %C) nounwind {
; CHECK-LABEL: vmlala16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmovl.u16 q8, d3
; CHECK-NEXT:    vmovl.u16 q9, d2
; CHECK-NEXT:    vmla.i32 q0, q9, q8
; CHECK-NEXT:    vmov.i32 q8, #0xffff
; CHECK-NEXT:    vand q0, q0, q8
; CHECK-NEXT:    bx lr
  %tmp4 = zext <4 x i16> %B to <4 x i32>
  %tmp5 = zext <4 x i16> %C to <4 x i32>
  %tmp6 = mul <4 x i32> %tmp4, %tmp5
  %tmp7 = add <4 x i32> %A, %tmp6
  %and = and <4 x i32> %tmp7, <i32 65535, i32 65535, i32 65535, i32 65535>
  ret <4 x i32> %and
}

define <2 x i64> @vmlala32(<2 x i64> %A, <2 x i32> %B, <2 x i32> %C) nounwind {
; CHECK-LABEL: vmlala32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, r5, r6, r7, r11, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, r11, lr}
; CHECK-NEXT:    vmovl.u32 q8, d3
; CHECK-NEXT:    vmovl.u32 q9, d2
; CHECK-NEXT:    vmov.32 r0, d16[0]
; CHECK-NEXT:    vmov.32 r1, d18[0]
; CHECK-NEXT:    vmov.32 r12, d16[1]
; CHECK-NEXT:    vmov.32 r3, d17[0]
; CHECK-NEXT:    vmov.32 r2, d19[0]
; CHECK-NEXT:    vmov.32 lr, d17[1]
; CHECK-NEXT:    vmov.32 r6, d19[1]
; CHECK-NEXT:    umull r7, r5, r1, r0
; CHECK-NEXT:    mla r1, r1, r12, r5
; CHECK-NEXT:    umull r5, r4, r2, r3
; CHECK-NEXT:    mla r2, r2, lr, r4
; CHECK-NEXT:    vmov.32 r4, d18[1]
; CHECK-NEXT:    vmov.i64 q9, #0xffffffff
; CHECK-NEXT:    mla r2, r6, r3, r2
; CHECK-NEXT:    vmov.32 d17[0], r5
; CHECK-NEXT:    vmov.32 d16[0], r7
; CHECK-NEXT:    vmov.32 d17[1], r2
; CHECK-NEXT:    mla r0, r4, r0, r1
; CHECK-NEXT:    vmov.32 d16[1], r0
; CHECK-NEXT:    vadd.i64 q8, q0, q8
; CHECK-NEXT:    vand q0, q8, q9
; CHECK-NEXT:    pop {r4, r5, r6, r7, r11, pc}
  %tmp4 = zext <2 x i32> %B to <2 x i64>
  %tmp5 = zext <2 x i32> %C to <2 x i64>
  %tmp6 = mul <2 x i64> %tmp4, %tmp5
  %tmp7 = add <2 x i64> %A, %tmp6
  %and = and <2 x i64> %tmp7, <i64 4294967295, i64 4294967295>
  ret <2 x i64> %and
}

define arm_aapcs_vfpcc <4 x i32> @test_vmlal_lanes16(<4 x i32> %arg0_int32x4_t, <4 x i16> %arg1_int16x4_t, <4 x i16> %arg2_int16x4_t) nounwind readnone {
; CHECK-LABEL: test_vmlal_lanes16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmlal.s16 q0, d2, d3[1]
; CHECK-NEXT:    bx lr
entry:
  %0 = shufflevector <4 x i16> %arg2_int16x4_t, <4 x i16> undef, <4 x i32> <i32 1, i32 1, i32 1, i32 1> ; <<4 x i16>> [#uses=1]
  %1 = sext <4 x i16> %arg1_int16x4_t to <4 x i32>
  %2 = sext <4 x i16> %0 to <4 x i32>
  %3 = mul <4 x i32> %1, %2
  %4 = add <4 x i32> %arg0_int32x4_t, %3
  ret <4 x i32> %4
}

define arm_aapcs_vfpcc <2 x i64> @test_vmlal_lanes32(<2 x i64> %arg0_int64x2_t, <2 x i32> %arg1_int32x2_t, <2 x i32> %arg2_int32x2_t) nounwind readnone {
; CHECK-LABEL: test_vmlal_lanes32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmlal.s32 q0, d2, d3[1]
; CHECK-NEXT:    bx lr
entry:
  %0 = shufflevector <2 x i32> %arg2_int32x2_t, <2 x i32> undef, <2 x i32> <i32 1, i32 1> ; <<2 x i32>> [#uses=1]
  %1 = sext <2 x i32> %arg1_int32x2_t to <2 x i64>
  %2 = sext <2 x i32> %0 to <2 x i64>
  %3 = mul <2 x i64> %1, %2
  %4 = add <2 x i64> %arg0_int64x2_t, %3
  ret <2 x i64> %4
}

define arm_aapcs_vfpcc <4 x i32> @test_vmlal_laneu16(<4 x i32> %arg0_uint32x4_t, <4 x i16> %arg1_uint16x4_t, <4 x i16> %arg2_uint16x4_t) nounwind readnone {
; CHECK-LABEL: test_vmlal_laneu16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmlal.u16 q0, d2, d3[1]
; CHECK-NEXT:    bx lr
entry:
  %0 = shufflevector <4 x i16> %arg2_uint16x4_t, <4 x i16> undef, <4 x i32> <i32 1, i32 1, i32 1, i32 1> ; <<4 x i16>> [#uses=1]
  %1 = zext <4 x i16> %arg1_uint16x4_t to <4 x i32>
  %2 = zext <4 x i16> %0 to <4 x i32>
  %3 = mul <4 x i32> %1, %2
  %4 = add <4 x i32> %arg0_uint32x4_t, %3
  ret <4 x i32> %4
}

define arm_aapcs_vfpcc <2 x i64> @test_vmlal_laneu32(<2 x i64> %arg0_uint64x2_t, <2 x i32> %arg1_uint32x2_t, <2 x i32> %arg2_uint32x2_t) nounwind readnone {
; CHECK-LABEL: test_vmlal_laneu32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmlal.u32 q0, d2, d3[1]
; CHECK-NEXT:    bx lr
entry:
  %0 = shufflevector <2 x i32> %arg2_uint32x2_t, <2 x i32> undef, <2 x i32> <i32 1, i32 1> ; <<2 x i32>> [#uses=1]
  %1 = zext <2 x i32> %arg1_uint32x2_t to <2 x i64>
  %2 = zext <2 x i32> %0 to <2 x i64>
  %3 = mul <2 x i64> %1, %2
  %4 = add <2 x i64> %arg0_uint64x2_t, %3
  ret <2 x i64> %4
}

define arm_aapcs_vfpcc <4 x i32> @test_vmlal_lanea16(<4 x i32> %arg0_uint32x4_t, <4 x i16> %arg1_uint16x4_t, <4 x i16> %arg2_uint16x4_t) nounwind readnone {
; CHECK-LABEL: test_vmlal_lanea16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vdup.16 d16, d3[1]
; CHECK-NEXT:    vmovl.u16 q9, d2
; CHECK-NEXT:    vmovl.u16 q8, d16
; CHECK-NEXT:    vmla.i32 q0, q9, q8
; CHECK-NEXT:    vmov.i32 q8, #0xffff
; CHECK-NEXT:    vand q0, q0, q8
; CHECK-NEXT:    bx lr
entry:
  %0 = shufflevector <4 x i16> %arg2_uint16x4_t, <4 x i16> undef, <4 x i32> <i32 1, i32 1, i32 1, i32 1> ; <<4 x i16>> [#uses=1]
  %1 = zext <4 x i16> %arg1_uint16x4_t to <4 x i32>
  %2 = zext <4 x i16> %0 to <4 x i32>
  %3 = mul <4 x i32> %1, %2
  %4 = add <4 x i32> %arg0_uint32x4_t, %3
  %and = and <4 x i32> %4, <i32 65535, i32 65535, i32 65535, i32 65535>
  ret <4 x i32> %and
}

define arm_aapcs_vfpcc <2 x i64> @test_vmlal_lanea32(<2 x i64> %arg0_uint64x2_t, <2 x i32> %arg1_uint32x2_t, <2 x i32> %arg2_uint32x2_t) nounwind readnone {
; CHECK-LABEL: test_vmlal_lanea32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, r11, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, r11, lr}
; CHECK-NEXT:    vdup.32 d16, d3[1]
; CHECK-NEXT:    vmovl.u32 q9, d2
; CHECK-NEXT:    vmovl.u32 q8, d16
; CHECK-NEXT:    vmov.32 r0, d18[0]
; CHECK-NEXT:    vmov.32 r3, d19[0]
; CHECK-NEXT:    vmov.32 r1, d16[0]
; CHECK-NEXT:    vmov.32 r12, d16[1]
; CHECK-NEXT:    vmov.32 r2, d17[0]
; CHECK-NEXT:    vmov.32 lr, d17[1]
; CHECK-NEXT:    vmov.32 r6, d19[1]
; CHECK-NEXT:    umull r7, r5, r0, r1
; CHECK-NEXT:    mla r0, r0, r12, r5
; CHECK-NEXT:    umull r5, r4, r3, r2
; CHECK-NEXT:    mla r3, r3, lr, r4
; CHECK-NEXT:    vmov.32 r4, d18[1]
; CHECK-NEXT:    vmov.i64 q9, #0xffffffff
; CHECK-NEXT:    mla r2, r6, r2, r3
; CHECK-NEXT:    vmov.32 d17[0], r5
; CHECK-NEXT:    vmov.32 d16[0], r7
; CHECK-NEXT:    vmov.32 d17[1], r2
; CHECK-NEXT:    mla r0, r4, r1, r0
; CHECK-NEXT:    vmov.32 d16[1], r0
; CHECK-NEXT:    vadd.i64 q8, q0, q8
; CHECK-NEXT:    vand q0, q8, q9
; CHECK-NEXT:    pop {r4, r5, r6, r7, r11, pc}
entry:
  %0 = shufflevector <2 x i32> %arg2_uint32x2_t, <2 x i32> undef, <2 x i32> <i32 1, i32 1> ; <<2 x i32>> [#uses=1]
  %1 = zext <2 x i32> %arg1_uint32x2_t to <2 x i64>
  %2 = zext <2 x i32> %0 to <2 x i64>
  %3 = mul <2 x i64> %1, %2
  %4 = add <2 x i64> %arg0_uint64x2_t, %3
  %and = and <2 x i64> %4, <i64 4294967295, i64 4294967295>
  ret <2 x i64> %and
}
