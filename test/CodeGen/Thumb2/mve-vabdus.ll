; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve %s -o - | FileCheck %s

define arm_aapcs_vfpcc <16 x i8> @vabd_s8(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: vabd_s8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %sextsrc1 = sext <16 x i8> %src1 to <16 x i16>
  %sextsrc2 = sext <16 x i8> %src2 to <16 x i16>
  %add1 = sub <16 x i16> %sextsrc1, %sextsrc2
  %add2 = sub <16 x i16> zeroinitializer, %add1
  %c = icmp sge <16 x i16> %add1, zeroinitializer
  %s = select <16 x i1> %c, <16 x i16> %add1, <16 x i16> %add2
  %result = trunc <16 x i16> %s to <16 x i8>
  ret <16 x i8> %result
}

define arm_aapcs_vfpcc <8 x i16> @vabd_s16(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: vabd_s16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %sextsrc1 = sext <8 x i16> %src1 to <8 x i32>
  %sextsrc2 = sext <8 x i16> %src2 to <8 x i32>
  %add1 = sub <8 x i32> %sextsrc1, %sextsrc2
  %add2 = sub <8 x i32> zeroinitializer, %add1
  %c = icmp sge <8 x i32> %add1, zeroinitializer
  %s = select <8 x i1> %c, <8 x i32> %add1, <8 x i32> %add2
  %result = trunc <8 x i32> %s to <8 x i16>
  ret <8 x i16> %result
}

define arm_aapcs_vfpcc <4 x i32> @vabd_s32(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: vabd_s32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %sextsrc1 = sext <4 x i32> %src1 to <4 x i64>
  %sextsrc2 = sext <4 x i32> %src2 to <4 x i64>
  %add1 = sub <4 x i64> %sextsrc1, %sextsrc2
  %add2 = sub <4 x i64> zeroinitializer, %add1
  %c = icmp sge <4 x i64> %add1, zeroinitializer
  %s = select <4 x i1> %c, <4 x i64> %add1, <4 x i64> %add2
  %result = trunc <4 x i64> %s to <4 x i32>
  ret <4 x i32> %result
}

define arm_aapcs_vfpcc <16 x i8> @vabd_u8(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: vabd_u8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %zextsrc1 = zext <16 x i8> %src1 to <16 x i16>
  %zextsrc2 = zext <16 x i8> %src2 to <16 x i16>
  %add1 = sub <16 x i16> %zextsrc1, %zextsrc2
  %add2 = sub <16 x i16> zeroinitializer, %add1
  %c = icmp sge <16 x i16> %add1, zeroinitializer
  %s = select <16 x i1> %c, <16 x i16> %add1, <16 x i16> %add2
  %result = trunc <16 x i16> %s to <16 x i8>
  ret <16 x i8> %result
}

define arm_aapcs_vfpcc <8 x i16> @vabd_u16(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: vabd_u16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %zextsrc1 = zext <8 x i16> %src1 to <8 x i32>
  %zextsrc2 = zext <8 x i16> %src2 to <8 x i32>
  %add1 = sub <8 x i32> %zextsrc1, %zextsrc2
  %add2 = sub <8 x i32> zeroinitializer, %add1
  %c = icmp sge <8 x i32> %add1, zeroinitializer
  %s = select <8 x i1> %c, <8 x i32> %add1, <8 x i32> %add2
  %result = trunc <8 x i32> %s to <8 x i16>
  ret <8 x i16> %result
}

define arm_aapcs_vfpcc <4 x i32> @vabd_u32(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: vabd_u32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vabd.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %zextsrc1 = zext <4 x i32> %src1 to <4 x i64>
  %zextsrc2 = zext <4 x i32> %src2 to <4 x i64>
  %add1 = sub <4 x i64> %zextsrc1, %zextsrc2
  %add2 = sub <4 x i64> zeroinitializer, %add1
  %c = icmp sge <4 x i64> %add1, zeroinitializer
  %s = select <4 x i1> %c, <4 x i64> %add1, <4 x i64> %add2
  %result = trunc <4 x i64> %s to <4 x i32>
  ret <4 x i32> %result
}

define void @vabd_loop_s8(i8* nocapture readonly %x, i8* nocapture readonly %y, i8* noalias nocapture %z, i32 %n) {
; CHECK-LABEL: vabd_loop_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    mov.w lr, #64
; CHECK-NEXT:  .LBB6_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r1], #16
; CHECK-NEXT:    vldrb.u8 q1, [r0], #16
; CHECK-NEXT:    vabd.s8 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    le lr, .LBB6_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i8, i8* %x, i32 %index
  %1 = bitcast i8* %0 to <16 x i8>*
  %wide.load = load <16 x i8>, <16 x i8>* %1, align 1
  %2 = sext <16 x i8> %wide.load to <16 x i32>
  %3 = getelementptr inbounds i8, i8* %y, i32 %index
  %4 = bitcast i8* %3 to <16 x i8>*
  %wide.load22 = load <16 x i8>, <16 x i8>* %4, align 1
  %5 = sext <16 x i8> %wide.load22 to <16 x i32>
  %6 = sub nsw <16 x i32> %2, %5
  %7 = icmp slt <16 x i32> %6, zeroinitializer
  %8 = sub nsw <16 x i32> zeroinitializer, %6
  %9 = select <16 x i1> %7, <16 x i32> %8, <16 x i32> %6
  %10 = trunc <16 x i32> %9 to <16 x i8>
  %11 = getelementptr inbounds i8, i8* %z, i32 %index
  %12 = bitcast i8* %11 to <16 x i8>*
  store <16 x i8> %10, <16 x i8>* %12, align 1
  %index.next = add i32 %index, 16
  %13 = icmp eq i32 %index.next, 1024
  br i1 %13, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @vabd_loop_s16(i16* nocapture readonly %x, i16* nocapture readonly %y, i16* noalias nocapture %z, i32 %n) {
; CHECK-LABEL: vabd_loop_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    mov.w lr, #128
; CHECK-NEXT:  .LBB7_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r1], #16
; CHECK-NEXT:    vldrh.u16 q1, [r0], #16
; CHECK-NEXT:    vabd.s16 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    le lr, .LBB7_1
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
  %wide.load22 = load <8 x i16>, <8 x i16>* %4, align 2
  %5 = sext <8 x i16> %wide.load22 to <8 x i32>
  %6 = sub nsw <8 x i32> %2, %5
  %7 = icmp slt <8 x i32> %6, zeroinitializer
  %8 = sub nsw <8 x i32> zeroinitializer, %6
  %9 = select <8 x i1> %7, <8 x i32> %8, <8 x i32> %6
  %10 = trunc <8 x i32> %9 to <8 x i16>
  %11 = getelementptr inbounds i16, i16* %z, i32 %index
  %12 = bitcast i16* %11 to <8 x i16>*
  store <8 x i16> %10, <8 x i16>* %12, align 2
  %index.next = add i32 %index, 8
  %13 = icmp eq i32 %index.next, 1024
  br i1 %13, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @vabd_loop_s32(i32* nocapture readonly %x, i32* nocapture readonly %y, i32* noalias nocapture %z, i32 %n) {
; CHECK-LABEL: vabd_loop_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, r8, r9, lr}
; CHECK-NEXT:    push.w {r4, r5, r6, r7, r8, r9, lr}
; CHECK-NEXT:    mov.w lr, #256
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:  .LBB8_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q1, [r0], #16
; CHECK-NEXT:    vmov.f32 s8, s6
; CHECK-NEXT:    vmov r7, s4
; CHECK-NEXT:    vmov.f32 s6, s7
; CHECK-NEXT:    vmov r3, s8
; CHECK-NEXT:    vldrw.u32 q2, [r1], #16
; CHECK-NEXT:    vmov.f32 s12, s10
; CHECK-NEXT:    vmov.f32 s10, s5
; CHECK-NEXT:    vmov.f32 s14, s11
; CHECK-NEXT:    vmov r4, s12
; CHECK-NEXT:    asr.w r12, r3, #31
; CHECK-NEXT:    subs.w r8, r3, r4
; CHECK-NEXT:    sbc.w r12, r12, r4, asr #31
; CHECK-NEXT:    vmov r4, s10
; CHECK-NEXT:    vmov.f32 s10, s9
; CHECK-NEXT:    vmov r6, s10
; CHECK-NEXT:    asrs r3, r4, #31
; CHECK-NEXT:    subs r4, r4, r6
; CHECK-NEXT:    sbc.w r9, r3, r6, asr #31
; CHECK-NEXT:    vmov r6, s8
; CHECK-NEXT:    subs r5, r7, r6
; CHECK-NEXT:    vmov q2[2], q2[0], r5, r8
; CHECK-NEXT:    asr.w r5, r7, #31
; CHECK-NEXT:    sbc.w r5, r5, r6, asr #31
; CHECK-NEXT:    vmov r6, s14
; CHECK-NEXT:    vmov r7, s6
; CHECK-NEXT:    subs r3, r7, r6
; CHECK-NEXT:    vmov q2[3], q2[1], r4, r3
; CHECK-NEXT:    asr.w r3, r5, #31
; CHECK-NEXT:    mov.w r4, #0
; CHECK-NEXT:    bfi r4, r3, #0, #4
; CHECK-NEXT:    asr.w r3, r9, #31
; CHECK-NEXT:    bfi r4, r3, #4, #4
; CHECK-NEXT:    asr.w r3, r12, #31
; CHECK-NEXT:    bfi r4, r3, #8, #4
; CHECK-NEXT:    asr.w r3, r7, #31
; CHECK-NEXT:    sbc.w r3, r3, r6, asr #31
; CHECK-NEXT:    asrs r3, r3, #31
; CHECK-NEXT:    bfi r4, r3, #12, #4
; CHECK-NEXT:    vmsr p0, r4
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vsubt.i32 q2, q0, q2
; CHECK-NEXT:    vstrb.8 q2, [r2], #16
; CHECK-NEXT:    le lr, .LBB8_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, pc}
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
  %wide.load23 = load <4 x i32>, <4 x i32>* %4, align 4
  %5 = sext <4 x i32> %wide.load23 to <4 x i64>
  %6 = sub nsw <4 x i64> %2, %5
  %7 = icmp slt <4 x i64> %6, zeroinitializer
  %8 = trunc <4 x i64> %6 to <4 x i32>
  %9 = sub <4 x i32> zeroinitializer, %8
  %10 = select <4 x i1> %7, <4 x i32> %9, <4 x i32> %8
  %11 = getelementptr inbounds i32, i32* %z, i32 %index
  %12 = bitcast i32* %11 to <4 x i32>*
  store <4 x i32> %10, <4 x i32>* %12, align 4
  %index.next = add i32 %index, 4
  %13 = icmp eq i32 %index.next, 1024
  br i1 %13, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @vabd_loop_u8(i8* nocapture readonly %x, i8* nocapture readonly %y, i8* noalias nocapture %z, i32 %n) {
; CHECK-LABEL: vabd_loop_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    mov.w lr, #64
; CHECK-NEXT:  .LBB9_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r1], #16
; CHECK-NEXT:    vldrb.u8 q1, [r0], #16
; CHECK-NEXT:    vabd.u8 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    le lr, .LBB9_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i8, i8* %x, i32 %index
  %1 = bitcast i8* %0 to <16 x i8>*
  %wide.load = load <16 x i8>, <16 x i8>* %1, align 1
  %2 = zext <16 x i8> %wide.load to <16 x i32>
  %3 = getelementptr inbounds i8, i8* %y, i32 %index
  %4 = bitcast i8* %3 to <16 x i8>*
  %wide.load22 = load <16 x i8>, <16 x i8>* %4, align 1
  %5 = zext <16 x i8> %wide.load22 to <16 x i32>
  %6 = sub nsw <16 x i32> %2, %5
  %7 = icmp slt <16 x i32> %6, zeroinitializer
  %8 = sub nsw <16 x i32> zeroinitializer, %6
  %9 = select <16 x i1> %7, <16 x i32> %8, <16 x i32> %6
  %10 = trunc <16 x i32> %9 to <16 x i8>
  %11 = getelementptr inbounds i8, i8* %z, i32 %index
  %12 = bitcast i8* %11 to <16 x i8>*
  store <16 x i8> %10, <16 x i8>* %12, align 1
  %index.next = add i32 %index, 16
  %13 = icmp eq i32 %index.next, 1024
  br i1 %13, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @vabd_loop_u16(i16* nocapture readonly %x, i16* nocapture readonly %y, i16* noalias nocapture %z, i32 %n) {
; CHECK-LABEL: vabd_loop_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    mov.w lr, #128
; CHECK-NEXT:  .LBB10_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r1], #16
; CHECK-NEXT:    vldrh.u16 q1, [r0], #16
; CHECK-NEXT:    vabd.u16 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    le lr, .LBB10_1
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
  %wide.load22 = load <8 x i16>, <8 x i16>* %4, align 2
  %5 = zext <8 x i16> %wide.load22 to <8 x i32>
  %6 = sub nsw <8 x i32> %2, %5
  %7 = icmp slt <8 x i32> %6, zeroinitializer
  %8 = sub nsw <8 x i32> zeroinitializer, %6
  %9 = select <8 x i1> %7, <8 x i32> %8, <8 x i32> %6
  %10 = trunc <8 x i32> %9 to <8 x i16>
  %11 = getelementptr inbounds i16, i16* %z, i32 %index
  %12 = bitcast i16* %11 to <8 x i16>*
  store <8 x i16> %10, <8 x i16>* %12, align 2
  %index.next = add i32 %index, 8
  %13 = icmp eq i32 %index.next, 1024
  br i1 %13, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @vabd_loop_u32(i32* nocapture readonly %x, i32* nocapture readonly %y, i32* noalias nocapture %z, i32 %n) {
; CHECK-LABEL: vabd_loop_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, r8, r9, r10, lr}
; CHECK-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, lr}
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    mov.w lr, #256
; CHECK-NEXT:    vmov.i64 q0, #0xffffffff
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:  .LBB11_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q4, [r1], #16
; CHECK-NEXT:    vldrw.u32 q5, [r0], #16
; CHECK-NEXT:    vmov.f32 s8, s18
; CHECK-NEXT:    vmov.f32 s10, s19
; CHECK-NEXT:    vmov.f32 s12, s22
; CHECK-NEXT:    vand q2, q2, q0
; CHECK-NEXT:    vmov.f32 s14, s23
; CHECK-NEXT:    vand q3, q3, q0
; CHECK-NEXT:    vmov r3, r12, d4
; CHECK-NEXT:    vmov r4, r5, d6
; CHECK-NEXT:    vmov.f32 s18, s17
; CHECK-NEXT:    vmov.f32 s22, s21
; CHECK-NEXT:    vand q4, q4, q0
; CHECK-NEXT:    vand q5, q5, q0
; CHECK-NEXT:    vmov r6, r7, d11
; CHECK-NEXT:    subs.w r8, r4, r3
; CHECK-NEXT:    sbc.w r12, r5, r12
; CHECK-NEXT:    vmov r5, r3, d9
; CHECK-NEXT:    subs.w r10, r6, r5
; CHECK-NEXT:    sbc.w r9, r7, r3
; CHECK-NEXT:    vmov r6, r7, d8
; CHECK-NEXT:    vmov r4, r3, d10
; CHECK-NEXT:    subs r4, r4, r6
; CHECK-NEXT:    sbcs r3, r7
; CHECK-NEXT:    vmov q4[2], q4[0], r4, r8
; CHECK-NEXT:    vmov r4, r6, d5
; CHECK-NEXT:    vmov r7, r5, d7
; CHECK-NEXT:    asrs r3, r3, #31
; CHECK-NEXT:    subs r4, r7, r4
; CHECK-NEXT:    vmov q4[3], q4[1], r10, r4
; CHECK-NEXT:    mov.w r4, #0
; CHECK-NEXT:    bfi r4, r3, #0, #4
; CHECK-NEXT:    asr.w r3, r9, #31
; CHECK-NEXT:    bfi r4, r3, #4, #4
; CHECK-NEXT:    asr.w r3, r12, #31
; CHECK-NEXT:    bfi r4, r3, #8, #4
; CHECK-NEXT:    sbc.w r3, r5, r6
; CHECK-NEXT:    asrs r3, r3, #31
; CHECK-NEXT:    bfi r4, r3, #12, #4
; CHECK-NEXT:    vmsr p0, r4
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vsubt.i32 q4, q1, q4
; CHECK-NEXT:    vstrb.8 q4, [r2], #16
; CHECK-NEXT:    le lr, .LBB11_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, pc}
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
  %wide.load23 = load <4 x i32>, <4 x i32>* %4, align 4
  %5 = zext <4 x i32> %wide.load23 to <4 x i64>
  %6 = sub nsw <4 x i64> %2, %5
  %7 = icmp slt <4 x i64> %6, zeroinitializer
  %8 = trunc <4 x i64> %6 to <4 x i32>
  %9 = sub <4 x i32> zeroinitializer, %8
  %10 = select <4 x i1> %7, <4 x i32> %9, <4 x i32> %8
  %11 = getelementptr inbounds i32, i32* %z, i32 %index
  %12 = bitcast i32* %11 to <4 x i32>*
  store <4 x i32> %10, <4 x i32>* %12, align 4
  %index.next = add i32 %index, 4
  %13 = icmp eq i32 %index.next, 1024
  br i1 %13, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}
