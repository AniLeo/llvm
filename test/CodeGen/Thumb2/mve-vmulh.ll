; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK

define arm_aapcs_vfpcc <2 x i32> @vmulhs_v2i32(<2 x i32> %s0, <2 x i32> %s1) {
; CHECK-LABEL: vmulhs_v2i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmullb.s32 q2, q0, q1
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    vmov r1, s9
; CHECK-NEXT:    vmov q0[2], q0[0], r1, r0
; CHECK-NEXT:    asrs r0, r0, #31
; CHECK-NEXT:    asrs r1, r1, #31
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r0
; CHECK-NEXT:    bx lr
entry:
  %s0s = sext <2 x i32> %s0 to <2 x i64>
  %s1s = sext <2 x i32> %s1 to <2 x i64>
  %m = mul <2 x i64> %s0s, %s1s
  %s = ashr <2 x i64> %m, <i64 32, i64 32>
  %s2 = trunc <2 x i64> %s to <2 x i32>
  ret <2 x i32> %s2
}

define arm_aapcs_vfpcc <2 x i32> @vmulhu_v2i32(<2 x i32> %s0, <2 x i32> %s1) {
; CHECK-LABEL: vmulhu_v2i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmullb.u32 q2, q0, q1
; CHECK-NEXT:    vldr s1, .LCPI1_0
; CHECK-NEXT:    vmov.f32 s0, s9
; CHECK-NEXT:    vmov.f32 s2, s11
; CHECK-NEXT:    vmov.f32 s3, s1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI1_0:
; CHECK-NEXT:    .long 0x00000000 @ float 0
entry:
  %s0s = zext <2 x i32> %s0 to <2 x i64>
  %s1s = zext <2 x i32> %s1 to <2 x i64>
  %m = mul <2 x i64> %s0s, %s1s
  %s = lshr <2 x i64> %m, <i64 32, i64 32>
  %s2 = trunc <2 x i64> %s to <2 x i32>
  ret <2 x i32> %s2
}

define arm_aapcs_vfpcc <4 x i32> @vmulhs_v4i32(<4 x i32> %s0, <4 x i32> %s1) {
; CHECK-LABEL: vmulhs_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmulh.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %s0s = sext <4 x i32> %s0 to <4 x i64>
  %s1s = sext <4 x i32> %s1 to <4 x i64>
  %m = mul <4 x i64> %s0s, %s1s
  %s = ashr <4 x i64> %m, <i64 32, i64 32, i64 32, i64 32>
  %s2 = trunc <4 x i64> %s to <4 x i32>
  ret <4 x i32> %s2
}

define arm_aapcs_vfpcc <4 x i32> @vmulhu_v4i32(<4 x i32> %s0, <4 x i32> %s1) {
; CHECK-LABEL: vmulhu_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmulh.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %s0s = zext <4 x i32> %s0 to <4 x i64>
  %s1s = zext <4 x i32> %s1 to <4 x i64>
  %m = mul <4 x i64> %s0s, %s1s
  %s = lshr <4 x i64> %m, <i64 32, i64 32, i64 32, i64 32>
  %s2 = trunc <4 x i64> %s to <4 x i32>
  ret <4 x i32> %s2
}

define arm_aapcs_vfpcc <4 x i16> @vmulhs_v4i16(<4 x i16> %s0, <4 x i16> %s1) {
; CHECK-LABEL: vmulhs_v4i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmullb.s16 q0, q0, q1
; CHECK-NEXT:    vshr.s32 q0, q0, #16
; CHECK-NEXT:    bx lr
entry:
  %s0s = sext <4 x i16> %s0 to <4 x i32>
  %s1s = sext <4 x i16> %s1 to <4 x i32>
  %m = mul <4 x i32> %s0s, %s1s
  %s = ashr <4 x i32> %m, <i32 16, i32 16, i32 16, i32 16>
  %s2 = trunc <4 x i32> %s to <4 x i16>
  ret <4 x i16> %s2
}

define arm_aapcs_vfpcc <4 x i16> @vmulhu_v4i16(<4 x i16> %s0, <4 x i16> %s1) {
; CHECK-LABEL: vmulhu_v4i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmullb.u16 q0, q0, q1
; CHECK-NEXT:    vshr.u32 q0, q0, #16
; CHECK-NEXT:    bx lr
entry:
  %s0s = zext <4 x i16> %s0 to <4 x i32>
  %s1s = zext <4 x i16> %s1 to <4 x i32>
  %m = mul <4 x i32> %s0s, %s1s
  %s = lshr <4 x i32> %m, <i32 16, i32 16, i32 16, i32 16>
  %s2 = trunc <4 x i32> %s to <4 x i16>
  ret <4 x i16> %s2
}

define arm_aapcs_vfpcc <8 x i16> @vmulhs_v8i16(<8 x i16> %s0, <8 x i16> %s1) {
; CHECK-LABEL: vmulhs_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmulh.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %s0s = sext <8 x i16> %s0 to <8 x i32>
  %s1s = sext <8 x i16> %s1 to <8 x i32>
  %m = mul <8 x i32> %s0s, %s1s
  %s = ashr <8 x i32> %m, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %s2 = trunc <8 x i32> %s to <8 x i16>
  ret <8 x i16> %s2
}

define arm_aapcs_vfpcc <8 x i16> @vmulhu_v8i16(<8 x i16> %s0, <8 x i16> %s1) {
; CHECK-LABEL: vmulhu_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmulh.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %s0s = zext <8 x i16> %s0 to <8 x i32>
  %s1s = zext <8 x i16> %s1 to <8 x i32>
  %m = mul <8 x i32> %s0s, %s1s
  %s = lshr <8 x i32> %m, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %s2 = trunc <8 x i32> %s to <8 x i16>
  ret <8 x i16> %s2
}

define arm_aapcs_vfpcc <8 x i8> @vmulhs_v8i8(<8 x i8> %s0, <8 x i8> %s1) {
; CHECK-LABEL: vmulhs_v8i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmullb.s8 q0, q0, q1
; CHECK-NEXT:    vshr.s16 q0, q0, #8
; CHECK-NEXT:    bx lr
entry:
  %s0s = sext <8 x i8> %s0 to <8 x i16>
  %s1s = sext <8 x i8> %s1 to <8 x i16>
  %m = mul <8 x i16> %s0s, %s1s
  %s = ashr <8 x i16> %m, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %s2 = trunc <8 x i16> %s to <8 x i8>
  ret <8 x i8> %s2
}

define arm_aapcs_vfpcc <8 x i8> @vmulhu_v8i8(<8 x i8> %s0, <8 x i8> %s1) {
; CHECK-LABEL: vmulhu_v8i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmullb.u8 q0, q0, q1
; CHECK-NEXT:    vshr.u16 q0, q0, #8
; CHECK-NEXT:    bx lr
entry:
  %s0s = zext <8 x i8> %s0 to <8 x i16>
  %s1s = zext <8 x i8> %s1 to <8 x i16>
  %m = mul <8 x i16> %s0s, %s1s
  %s = lshr <8 x i16> %m, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %s2 = trunc <8 x i16> %s to <8 x i8>
  ret <8 x i8> %s2
}

define arm_aapcs_vfpcc <16 x i8> @vmulhs_v16i8(<16 x i8> %s0, <16 x i8> %s1) {
; CHECK-LABEL: vmulhs_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmulh.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %s0s = sext <16 x i8> %s0 to <16 x i16>
  %s1s = sext <16 x i8> %s1 to <16 x i16>
  %m = mul <16 x i16> %s0s, %s1s
  %s = ashr <16 x i16> %m, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %s2 = trunc <16 x i16> %s to <16 x i8>
  ret <16 x i8> %s2
}

define arm_aapcs_vfpcc <16 x i8> @vmulhu_v16i8(<16 x i8> %s0, <16 x i8> %s1) {
; CHECK-LABEL: vmulhu_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmulh.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %s0s = zext <16 x i8> %s0 to <16 x i16>
  %s1s = zext <16 x i8> %s1 to <16 x i16>
  %m = mul <16 x i16> %s0s, %s1s
  %s = lshr <16 x i16> %m, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %s2 = trunc <16 x i16> %s to <16 x i8>
  ret <16 x i8> %s2
}

define void @vmulh_s8(i8* nocapture readonly %x, i8* nocapture readonly %y, i8* noalias nocapture %z, i32 %n) {
; CHECK-LABEL: vmulh_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    mov.w lr, #64
; CHECK-NEXT:  .LBB12_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r0], #16
; CHECK-NEXT:    vldrb.u8 q1, [r1], #16
; CHECK-NEXT:    vmulh.s8 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    le lr, .LBB12_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i8, i8* %x, i32 %index
  %1 = bitcast i8* %0 to <16 x i8>*
  %wide.load = load <16 x i8>, <16 x i8>* %1, align 1
  %2 = sext <16 x i8> %wide.load to <16 x i16>
  %3 = getelementptr inbounds i8, i8* %y, i32 %index
  %4 = bitcast i8* %3 to <16 x i8>*
  %wide.load17 = load <16 x i8>, <16 x i8>* %4, align 1
  %5 = sext <16 x i8> %wide.load17 to <16 x i16>
  %6 = mul nsw <16 x i16> %5, %2
  %7 = lshr <16 x i16> %6, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %8 = trunc <16 x i16> %7 to <16 x i8>
  %9 = getelementptr inbounds i8, i8* %z, i32 %index
  %10 = bitcast i8* %9 to <16 x i8>*
  store <16 x i8> %8, <16 x i8>* %10, align 1
  %index.next = add i32 %index, 16
  %11 = icmp eq i32 %index.next, 1024
  br i1 %11, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @vmulh_s16(i16* nocapture readonly %x, i16* nocapture readonly %y, i16* noalias nocapture %z, i32 %n) {
; CHECK-LABEL: vmulh_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    mov.w lr, #128
; CHECK-NEXT:  .LBB13_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r0], #16
; CHECK-NEXT:    vldrh.u16 q1, [r1], #16
; CHECK-NEXT:    vmulh.s16 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    le lr, .LBB13_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i16, i16* %x, i32 %index
  %1 = bitcast i16* %0 to <8 x i16>*
  %wide.load = load <8 x i16>, <8 x i16>* %1, align 2
  %2 = sext <8 x i16> %wide.load to <8 x i32>
  %3 = getelementptr inbounds i16, i16* %y, i32 %index
  %4 = bitcast i16* %3 to <8 x i16>*
  %wide.load17 = load <8 x i16>, <8 x i16>* %4, align 2
  %5 = sext <8 x i16> %wide.load17 to <8 x i32>
  %6 = mul nsw <8 x i32> %5, %2
  %7 = lshr <8 x i32> %6, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %8 = trunc <8 x i32> %7 to <8 x i16>
  %9 = getelementptr inbounds i16, i16* %z, i32 %index
  %10 = bitcast i16* %9 to <8 x i16>*
  store <8 x i16> %8, <8 x i16>* %10, align 2
  %index.next = add i32 %index, 8
  %11 = icmp eq i32 %index.next, 1024
  br i1 %11, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @vmulh_s32(i32* nocapture readonly %x, i32* nocapture readonly %y, i32* noalias nocapture %z, i32 %n) {
; CHECK-LABEL: vmulh_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    mov.w lr, #256
; CHECK-NEXT:  .LBB14_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vldrw.u32 q1, [r1], #16
; CHECK-NEXT:    vmulh.s32 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    le lr, .LBB14_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32, i32* %x, i32 %index
  %1 = bitcast i32* %0 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %1, align 4
  %2 = sext <4 x i32> %wide.load to <4 x i64>
  %3 = getelementptr inbounds i32, i32* %y, i32 %index
  %4 = bitcast i32* %3 to <4 x i32>*
  %wide.load17 = load <4 x i32>, <4 x i32>* %4, align 4
  %5 = sext <4 x i32> %wide.load17 to <4 x i64>
  %6 = mul nsw <4 x i64> %5, %2
  %7 = lshr <4 x i64> %6, <i64 32, i64 32, i64 32, i64 32>
  %8 = trunc <4 x i64> %7 to <4 x i32>
  %9 = getelementptr inbounds i32, i32* %z, i32 %index
  %10 = bitcast i32* %9 to <4 x i32>*
  store <4 x i32> %8, <4 x i32>* %10, align 4
  %index.next = add i32 %index, 4
  %11 = icmp eq i32 %index.next, 1024
  br i1 %11, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @vmulh_u8(i8* nocapture readonly %x, i8* nocapture readonly %y, i8* noalias nocapture %z, i32 %n) {
; CHECK-LABEL: vmulh_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    mov.w lr, #64
; CHECK-NEXT:  .LBB15_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r0], #16
; CHECK-NEXT:    vldrb.u8 q1, [r1], #16
; CHECK-NEXT:    vmulh.u8 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    le lr, .LBB15_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i8, i8* %x, i32 %index
  %1 = bitcast i8* %0 to <16 x i8>*
  %wide.load = load <16 x i8>, <16 x i8>* %1, align 1
  %2 = zext <16 x i8> %wide.load to <16 x i16>
  %3 = getelementptr inbounds i8, i8* %y, i32 %index
  %4 = bitcast i8* %3 to <16 x i8>*
  %wide.load17 = load <16 x i8>, <16 x i8>* %4, align 1
  %5 = zext <16 x i8> %wide.load17 to <16 x i16>
  %6 = mul nuw <16 x i16> %5, %2
  %7 = lshr <16 x i16> %6, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %8 = trunc <16 x i16> %7 to <16 x i8>
  %9 = getelementptr inbounds i8, i8* %z, i32 %index
  %10 = bitcast i8* %9 to <16 x i8>*
  store <16 x i8> %8, <16 x i8>* %10, align 1
  %index.next = add i32 %index, 16
  %11 = icmp eq i32 %index.next, 1024
  br i1 %11, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @vmulh_u16(i16* nocapture readonly %x, i16* nocapture readonly %y, i16* noalias nocapture %z, i32 %n) {
; CHECK-LABEL: vmulh_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    mov.w lr, #128
; CHECK-NEXT:  .LBB16_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r0], #16
; CHECK-NEXT:    vldrh.u16 q1, [r1], #16
; CHECK-NEXT:    vmulh.u16 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    le lr, .LBB16_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i16, i16* %x, i32 %index
  %1 = bitcast i16* %0 to <8 x i16>*
  %wide.load = load <8 x i16>, <8 x i16>* %1, align 2
  %2 = zext <8 x i16> %wide.load to <8 x i32>
  %3 = getelementptr inbounds i16, i16* %y, i32 %index
  %4 = bitcast i16* %3 to <8 x i16>*
  %wide.load17 = load <8 x i16>, <8 x i16>* %4, align 2
  %5 = zext <8 x i16> %wide.load17 to <8 x i32>
  %6 = mul nuw <8 x i32> %5, %2
  %7 = lshr <8 x i32> %6, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %8 = trunc <8 x i32> %7 to <8 x i16>
  %9 = getelementptr inbounds i16, i16* %z, i32 %index
  %10 = bitcast i16* %9 to <8 x i16>*
  store <8 x i16> %8, <8 x i16>* %10, align 2
  %index.next = add i32 %index, 8
  %11 = icmp eq i32 %index.next, 1024
  br i1 %11, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @vmulh_u32(i32* nocapture readonly %x, i32* nocapture readonly %y, i32* noalias nocapture %z, i32 %n) {
; CHECK-LABEL: vmulh_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    mov.w lr, #256
; CHECK-NEXT:  .LBB17_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vldrw.u32 q1, [r1], #16
; CHECK-NEXT:    vmulh.u32 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    le lr, .LBB17_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32, i32* %x, i32 %index
  %1 = bitcast i32* %0 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %1, align 4
  %2 = zext <4 x i32> %wide.load to <4 x i64>
  %3 = getelementptr inbounds i32, i32* %y, i32 %index
  %4 = bitcast i32* %3 to <4 x i32>*
  %wide.load17 = load <4 x i32>, <4 x i32>* %4, align 4
  %5 = zext <4 x i32> %wide.load17 to <4 x i64>
  %6 = mul nuw <4 x i64> %5, %2
  %7 = lshr <4 x i64> %6, <i64 32, i64 32, i64 32, i64 32>
  %8 = trunc <4 x i64> %7 to <4 x i32>
  %9 = getelementptr inbounds i32, i32* %z, i32 %index
  %10 = bitcast i32* %9 to <4 x i32>*
  store <4 x i32> %8, <4 x i32>* %10, align 4
  %index.next = add i32 %index, 4
  %11 = icmp eq i32 %index.next, 1024
  br i1 %11, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}


define void @vmulh_s32_pred(i32* noalias nocapture %d, i32* noalias nocapture readonly %x, i32* noalias nocapture readonly %y, i32 %n) {
; CHECK-LABEL: vmulh_s32_pred:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:  .LBB18_1: @ %vector.ph
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB18_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r1], #16
; CHECK-NEXT:    vldrw.u32 q1, [r2], #16
; CHECK-NEXT:    vmulh.s32 q0, q1, q0
; CHECK-NEXT:    vstrw.32 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB18_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp10 = icmp sgt i32 %n, 0
  br i1 %cmp10, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %n)
  %0 = getelementptr inbounds i32, i32* %x, i32 %index
  %1 = bitcast i32* %0 to <4 x i32>*
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %1, i32 4, <4 x i1> %active.lane.mask, <4 x i32> poison)
  %2 = sext <4 x i32> %wide.masked.load to <4 x i64>
  %3 = getelementptr inbounds i32, i32* %y, i32 %index
  %4 = bitcast i32* %3 to <4 x i32>*
  %wide.masked.load12 = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %4, i32 4, <4 x i1> %active.lane.mask, <4 x i32> poison)
  %5 = sext <4 x i32> %wide.masked.load12 to <4 x i64>
  %6 = mul nsw <4 x i64> %5, %2
  %7 = lshr <4 x i64> %6, <i64 32, i64 32, i64 32, i64 32>
  %8 = trunc <4 x i64> %7 to <4 x i32>
  %9 = getelementptr inbounds i32, i32* %d, i32 %index
  %10 = bitcast i32* %9 to <4 x i32>*
  call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> %8, <4 x i32>* %10, i32 4, <4 x i1> %active.lane.mask)
  %index.next = add i32 %index, 4
  %11 = icmp eq i32 %index.next, %n.vec
  br i1 %11, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define void @vmulh_u32_pred(i32* noalias nocapture %d, i32* noalias nocapture readonly %x, i32* noalias nocapture readonly %y, i32 %n) {
; CHECK-LABEL: vmulh_u32_pred:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:  .LBB19_1: @ %vector.ph
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB19_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r1], #16
; CHECK-NEXT:    vldrw.u32 q1, [r2], #16
; CHECK-NEXT:    vmulh.u32 q0, q1, q0
; CHECK-NEXT:    vstrw.32 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB19_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp10 = icmp sgt i32 %n, 0
  br i1 %cmp10, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %n)
  %0 = getelementptr inbounds i32, i32* %x, i32 %index
  %1 = bitcast i32* %0 to <4 x i32>*
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %1, i32 4, <4 x i1> %active.lane.mask, <4 x i32> poison)
  %2 = zext <4 x i32> %wide.masked.load to <4 x i64>
  %3 = getelementptr inbounds i32, i32* %y, i32 %index
  %4 = bitcast i32* %3 to <4 x i32>*
  %wide.masked.load12 = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %4, i32 4, <4 x i1> %active.lane.mask, <4 x i32> poison)
  %5 = zext <4 x i32> %wide.masked.load12 to <4 x i64>
  %6 = mul nuw <4 x i64> %5, %2
  %7 = lshr <4 x i64> %6, <i64 32, i64 32, i64 32, i64 32>
  %8 = trunc <4 x i64> %7 to <4 x i32>
  %9 = getelementptr inbounds i32, i32* %d, i32 %index
  %10 = bitcast i32* %9 to <4 x i32>*
  call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> %8, <4 x i32>* %10, i32 4, <4 x i1> %active.lane.mask)
  %index.next = add i32 %index, 4
  %11 = icmp eq i32 %index.next, %n.vec
  br i1 %11, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define void @vmulh_s16_pred(i16* noalias nocapture %d, i16* noalias nocapture readonly %x, i16* noalias nocapture readonly %y, i32 %n) {
; CHECK-LABEL: vmulh_s16_pred:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:  .LBB20_1: @ %vector.ph
; CHECK-NEXT:    dlstp.16 lr, r3
; CHECK-NEXT:  .LBB20_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r1], #16
; CHECK-NEXT:    vldrh.u16 q1, [r2], #16
; CHECK-NEXT:    vmulh.s16 q0, q1, q0
; CHECK-NEXT:    vstrh.16 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB20_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp10 = icmp sgt i32 %n, 0
  br i1 %cmp10, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 7
  %n.vec = and i32 %n.rnd.up, -8
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %active.lane.mask = call <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32 %index, i32 %n)
  %0 = getelementptr inbounds i16, i16* %x, i32 %index
  %1 = bitcast i16* %0 to <8 x i16>*
  %wide.masked.load = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %1, i32 2, <8 x i1> %active.lane.mask, <8 x i16> poison)
  %2 = sext <8 x i16> %wide.masked.load to <8 x i32>
  %3 = getelementptr inbounds i16, i16* %y, i32 %index
  %4 = bitcast i16* %3 to <8 x i16>*
  %wide.masked.load12 = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %4, i32 2, <8 x i1> %active.lane.mask, <8 x i16> poison)
  %5 = sext <8 x i16> %wide.masked.load12 to <8 x i32>
  %6 = mul nsw <8 x i32> %5, %2
  %7 = lshr <8 x i32> %6, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %8 = trunc <8 x i32> %7 to <8 x i16>
  %9 = getelementptr inbounds i16, i16* %d, i32 %index
  %10 = bitcast i16* %9 to <8 x i16>*
  call void @llvm.masked.store.v8i16.p0v8i16(<8 x i16> %8, <8 x i16>* %10, i32 2, <8 x i1> %active.lane.mask)
  %index.next = add i32 %index, 8
  %11 = icmp eq i32 %index.next, %n.vec
  br i1 %11, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define void @vmulh_u16_pred(i16* noalias nocapture %d, i16* noalias nocapture readonly %x, i16* noalias nocapture readonly %y, i32 %n) {
; CHECK-LABEL: vmulh_u16_pred:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:  .LBB21_1: @ %vector.ph
; CHECK-NEXT:    dlstp.16 lr, r3
; CHECK-NEXT:  .LBB21_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r1], #16
; CHECK-NEXT:    vldrh.u16 q1, [r2], #16
; CHECK-NEXT:    vmulh.u16 q0, q1, q0
; CHECK-NEXT:    vstrh.16 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB21_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp10 = icmp sgt i32 %n, 0
  br i1 %cmp10, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 7
  %n.vec = and i32 %n.rnd.up, -8
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %active.lane.mask = call <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32 %index, i32 %n)
  %0 = getelementptr inbounds i16, i16* %x, i32 %index
  %1 = bitcast i16* %0 to <8 x i16>*
  %wide.masked.load = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %1, i32 2, <8 x i1> %active.lane.mask, <8 x i16> poison)
  %2 = zext <8 x i16> %wide.masked.load to <8 x i32>
  %3 = getelementptr inbounds i16, i16* %y, i32 %index
  %4 = bitcast i16* %3 to <8 x i16>*
  %wide.masked.load12 = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %4, i32 2, <8 x i1> %active.lane.mask, <8 x i16> poison)
  %5 = zext <8 x i16> %wide.masked.load12 to <8 x i32>
  %6 = mul nuw <8 x i32> %5, %2
  %7 = lshr <8 x i32> %6, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %8 = trunc <8 x i32> %7 to <8 x i16>
  %9 = getelementptr inbounds i16, i16* %d, i32 %index
  %10 = bitcast i16* %9 to <8 x i16>*
  call void @llvm.masked.store.v8i16.p0v8i16(<8 x i16> %8, <8 x i16>* %10, i32 2, <8 x i1> %active.lane.mask)
  %index.next = add i32 %index, 8
  %11 = icmp eq i32 %index.next, %n.vec
  br i1 %11, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define void @vmulh_s8_pred(i8* noalias nocapture %d, i8* noalias nocapture readonly %x, i8* noalias nocapture readonly %y, i32 %n) {
; CHECK-LABEL: vmulh_s8_pred:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:  .LBB22_1: @ %vector.ph
; CHECK-NEXT:    dlstp.8 lr, r3
; CHECK-NEXT:  .LBB22_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r1], #16
; CHECK-NEXT:    vldrb.u8 q1, [r2], #16
; CHECK-NEXT:    vmulh.s8 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB22_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp10 = icmp sgt i32 %n, 0
  br i1 %cmp10, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 15
  %n.vec = and i32 %n.rnd.up, -16
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %active.lane.mask = call <16 x i1> @llvm.get.active.lane.mask.v16i1.i32(i32 %index, i32 %n)
  %0 = getelementptr inbounds i8, i8* %x, i32 %index
  %1 = bitcast i8* %0 to <16 x i8>*
  %wide.masked.load = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* %1, i32 1, <16 x i1> %active.lane.mask, <16 x i8> poison)
  %2 = sext <16 x i8> %wide.masked.load to <16 x i16>
  %3 = getelementptr inbounds i8, i8* %y, i32 %index
  %4 = bitcast i8* %3 to <16 x i8>*
  %wide.masked.load12 = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* %4, i32 1, <16 x i1> %active.lane.mask, <16 x i8> poison)
  %5 = sext <16 x i8> %wide.masked.load12 to <16 x i16>
  %6 = mul nsw <16 x i16> %5, %2
  %7 = lshr <16 x i16> %6, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %8 = trunc <16 x i16> %7 to <16 x i8>
  %9 = getelementptr inbounds i8, i8* %d, i32 %index
  %10 = bitcast i8* %9 to <16 x i8>*
  call void @llvm.masked.store.v16i8.p0v16i8(<16 x i8> %8, <16 x i8>* %10, i32 1, <16 x i1> %active.lane.mask)
  %index.next = add i32 %index, 16
  %11 = icmp eq i32 %index.next, %n.vec
  br i1 %11, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define void @vmulh_u8_pred(i8* noalias nocapture %d, i8* noalias nocapture readonly %x, i8* noalias nocapture readonly %y, i32 %n) {
; CHECK-LABEL: vmulh_u8_pred:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:  .LBB23_1: @ %vector.ph
; CHECK-NEXT:    dlstp.8 lr, r3
; CHECK-NEXT:  .LBB23_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r1], #16
; CHECK-NEXT:    vldrb.u8 q1, [r2], #16
; CHECK-NEXT:    vmulh.u8 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB23_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp10 = icmp sgt i32 %n, 0
  br i1 %cmp10, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 15
  %n.vec = and i32 %n.rnd.up, -16
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %active.lane.mask = call <16 x i1> @llvm.get.active.lane.mask.v16i1.i32(i32 %index, i32 %n)
  %0 = getelementptr inbounds i8, i8* %x, i32 %index
  %1 = bitcast i8* %0 to <16 x i8>*
  %wide.masked.load = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* %1, i32 1, <16 x i1> %active.lane.mask, <16 x i8> poison)
  %2 = zext <16 x i8> %wide.masked.load to <16 x i16>
  %3 = getelementptr inbounds i8, i8* %y, i32 %index
  %4 = bitcast i8* %3 to <16 x i8>*
  %wide.masked.load12 = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* %4, i32 1, <16 x i1> %active.lane.mask, <16 x i8> poison)
  %5 = zext <16 x i8> %wide.masked.load12 to <16 x i16>
  %6 = mul nuw <16 x i16> %5, %2
  %7 = lshr <16 x i16> %6, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %8 = trunc <16 x i16> %7 to <16 x i8>
  %9 = getelementptr inbounds i8, i8* %d, i32 %index
  %10 = bitcast i8* %9 to <16 x i8>*
  call void @llvm.masked.store.v16i8.p0v16i8(<16 x i8> %8, <16 x i8>* %10, i32 1, <16 x i1> %active.lane.mask)
  %index.next = add i32 %index, 16
  %11 = icmp eq i32 %index.next, %n.vec
  br i1 %11, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32, i32)
declare <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>*, i32 immarg, <4 x i1>, <4 x i32>)
declare void @llvm.masked.store.v4i32.p0v4i32(<4 x i32>, <4 x i32>*, i32 immarg, <4 x i1>)
declare <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32, i32)
declare <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>*, i32 immarg, <8 x i1>, <8 x i16>)
declare void @llvm.masked.store.v8i16.p0v8i16(<8 x i16>, <8 x i16>*, i32 immarg, <8 x i1>)
declare <16 x i1> @llvm.get.active.lane.mask.v16i1.i32(i32, i32)
declare <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>*, i32 immarg, <16 x i1>, <16 x i8>)
declare void @llvm.masked.store.v16i8.p0v16i8(<16 x i8>, <16 x i8>*, i32 immarg, <16 x i1>)
