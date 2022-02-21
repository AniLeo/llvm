; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv6t2-eabi %s -o - | FileCheck %s --check-prefix=CHECK

; Checks SSAT is still generated when loop unrolling is on

define void @ssat_unroll(i16* %pSrcA, i16* %pSrcB, i16* %pDst, i32 %blockSize) {
; CHECK-LABEL: ssat_unroll:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r11, lr}
; CHECK-NEXT:    push {r11, lr}
; CHECK-NEXT:    cmp r3, #0
; CHECK-NEXT:    beq .LBB0_5
; CHECK-NEXT:  @ %bb.1: @ %while.body.preheader
; CHECK-NEXT:    sub r12, r3, #1
; CHECK-NEXT:    tst r3, #1
; CHECK-NEXT:    beq .LBB0_3
; CHECK-NEXT:  @ %bb.2: @ %while.body.prol.preheader
; CHECK-NEXT:    ldrsh lr, [r0], #2
; CHECK-NEXT:    ldrsh r3, [r1], #2
; CHECK-NEXT:    smulbb r3, r3, lr
; CHECK-NEXT:    ssat r3, #16, r3, asr #14
; CHECK-NEXT:    strh r3, [r2], #2
; CHECK-NEXT:    mov r3, r12
; CHECK-NEXT:  .LBB0_3: @ %while.body.prol.loopexit
; CHECK-NEXT:    cmp r12, #0
; CHECK-NEXT:    popeq {r11, pc}
; CHECK-NEXT:  .LBB0_4: @ %while.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrsh r12, [r0]
; CHECK-NEXT:    subs r3, r3, #2
; CHECK-NEXT:    ldrsh lr, [r1]
; CHECK-NEXT:    smulbb r12, lr, r12
; CHECK-NEXT:    ssat r12, #16, r12, asr #14
; CHECK-NEXT:    strh r12, [r2]
; CHECK-NEXT:    ldrsh r12, [r0, #2]
; CHECK-NEXT:    add r0, r0, #4
; CHECK-NEXT:    ldrsh lr, [r1, #2]
; CHECK-NEXT:    add r1, r1, #4
; CHECK-NEXT:    smulbb r12, lr, r12
; CHECK-NEXT:    ssat r12, #16, r12, asr #14
; CHECK-NEXT:    strh r12, [r2, #2]
; CHECK-NEXT:    add r2, r2, #4
; CHECK-NEXT:    bne .LBB0_4
; CHECK-NEXT:  .LBB0_5: @ %while.end
; CHECK-NEXT:    pop {r11, pc}
entry:
  %cmp.not7 = icmp eq i32 %blockSize, 0
  br i1 %cmp.not7, label %while.end, label %while.body.preheader

while.body.preheader:                             ; preds = %entry
  %0 = add i32 %blockSize, -1
  %xtraiter = and i32 %blockSize, 1
  %lcmp.mod.not = icmp eq i32 %xtraiter, 0
  br i1 %lcmp.mod.not, label %while.body.prol.loopexit, label %while.body.prol.preheader

while.body.prol.preheader:                        ; preds = %while.body.preheader
  %incdec.ptr.prol = getelementptr inbounds i16, i16* %pSrcA, i32 1
  %1 = load i16, i16* %pSrcA
  %conv.prol = sext i16 %1 to i32
  %incdec.ptr1.prol = getelementptr inbounds i16, i16* %pSrcB, i32 1
  %2 = load i16, i16* %pSrcB
  %conv2.prol = sext i16 %2 to i32
  %mul.prol = mul nsw i32 %conv2.prol, %conv.prol
  %shr.prol = ashr i32 %mul.prol, 14
  %3 = icmp sgt i32 %shr.prol, -32768
  %4 = select i1 %3, i32 %shr.prol, i32 -32768
  %5 = icmp slt i32 %4, 32767
  %spec.select.i.prol = select i1 %5, i32 %4, i32 32767
  %conv3.prol = trunc i32 %spec.select.i.prol to i16
  %incdec.ptr4.prol = getelementptr inbounds i16, i16* %pDst, i32 1
  store i16 %conv3.prol, i16* %pDst
  br label %while.body.prol.loopexit

while.body.prol.loopexit:                         ; preds = %while.body.prol.preheader, %while.body.preheader
  %blkCnt.011.unr = phi i32 [ %blockSize, %while.body.preheader ], [ %0, %while.body.prol.preheader ]
  %pSrcA.addr.010.unr = phi i16* [ %pSrcA, %while.body.preheader ], [ %incdec.ptr.prol, %while.body.prol.preheader ]
  %pDst.addr.09.unr = phi i16* [ %pDst, %while.body.preheader ], [ %incdec.ptr4.prol, %while.body.prol.preheader ]
  %pSrcB.addr.08.unr = phi i16* [ %pSrcB, %while.body.preheader ], [ %incdec.ptr1.prol, %while.body.prol.preheader ]
  %6 = icmp eq i32 %0, 0
  br i1 %6, label %while.end, label %while.body

while.body:                                       ; preds = %while.body.prol.loopexit, %while.body
  %blkCnt.011 = phi i32 [ %dec.1, %while.body ], [ %blkCnt.011.unr, %while.body.prol.loopexit ]
  %pSrcA.addr.010 = phi i16* [ %incdec.ptr.1, %while.body ], [ %pSrcA.addr.010.unr, %while.body.prol.loopexit ]
  %pDst.addr.09 = phi i16* [ %incdec.ptr4.1, %while.body ], [ %pDst.addr.09.unr, %while.body.prol.loopexit ]
  %pSrcB.addr.08 = phi i16* [ %incdec.ptr1.1, %while.body ], [ %pSrcB.addr.08.unr, %while.body.prol.loopexit ]
  %incdec.ptr = getelementptr inbounds i16, i16* %pSrcA.addr.010, i32 1
  %7 = load i16, i16* %pSrcA.addr.010
  %conv = sext i16 %7 to i32
  %incdec.ptr1 = getelementptr inbounds i16, i16* %pSrcB.addr.08, i32 1
  %8 = load i16, i16* %pSrcB.addr.08
  %conv2 = sext i16 %8 to i32
  %mul = mul nsw i32 %conv2, %conv
  %shr = ashr i32 %mul, 14
  %9 = icmp sgt i32 %shr, -32768
  %10 = select i1 %9, i32 %shr, i32 -32768
  %11 = icmp slt i32 %10, 32767
  %spec.select.i = select i1 %11, i32 %10, i32 32767
  %conv3 = trunc i32 %spec.select.i to i16
  %incdec.ptr4 = getelementptr inbounds i16, i16* %pDst.addr.09, i32 1
  store i16 %conv3, i16* %pDst.addr.09
  %incdec.ptr.1 = getelementptr inbounds i16, i16* %pSrcA.addr.010, i32 2
  %12 = load i16, i16* %incdec.ptr
  %conv.1 = sext i16 %12 to i32
  %incdec.ptr1.1 = getelementptr inbounds i16, i16* %pSrcB.addr.08, i32 2
  %13 = load i16, i16* %incdec.ptr1
  %conv2.1 = sext i16 %13 to i32
  %mul.1 = mul nsw i32 %conv2.1, %conv.1
  %shr.1 = ashr i32 %mul.1, 14
  %14 = icmp sgt i32 %shr.1, -32768
  %15 = select i1 %14, i32 %shr.1, i32 -32768
  %16 = icmp slt i32 %15, 32767
  %spec.select.i.1 = select i1 %16, i32 %15, i32 32767
  %conv3.1 = trunc i32 %spec.select.i.1 to i16
  %incdec.ptr4.1 = getelementptr inbounds i16, i16* %pDst.addr.09, i32 2
  store i16 %conv3.1, i16* %incdec.ptr4
  %dec.1 = add i32 %blkCnt.011, -2
  %cmp.not.1 = icmp eq i32 %dec.1, 0
  br i1 %cmp.not.1, label %while.end, label %while.body

while.end:                                        ; preds = %while.body, %while.body.prol.loopexit, %entry
  ret void
}

define void @ssat_unroll_minmax(i16* nocapture readonly %pSrcA, i16* nocapture readonly %pSrcB, i16* nocapture writeonly %pDst, i32 %blockSize) {
; CHECK-LABEL: ssat_unroll_minmax:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r11, lr}
; CHECK-NEXT:    push {r4, r5, r11, lr}
; CHECK-NEXT:    cmp r3, #0
; CHECK-NEXT:    beq .LBB1_6
; CHECK-NEXT:  @ %bb.1: @ %while.body.preheader
; CHECK-NEXT:    movw r12, #32768
; CHECK-NEXT:    sub lr, r3, #1
; CHECK-NEXT:    tst r3, #1
; CHECK-NEXT:    movt r12, #65535
; CHECK-NEXT:    beq .LBB1_3
; CHECK-NEXT:  @ %bb.2: @ %while.body.prol.preheader
; CHECK-NEXT:    ldrsh r3, [r0], #2
; CHECK-NEXT:    ldrsh r4, [r1], #2
; CHECK-NEXT:    smulbb r3, r4, r3
; CHECK-NEXT:    asr r4, r3, #14
; CHECK-NEXT:    cmn r4, #32768
; CHECK-NEXT:    mov r4, r12
; CHECK-NEXT:    asrgt r4, r3, #14
; CHECK-NEXT:    movw r3, #32767
; CHECK-NEXT:    cmp r4, r3
; CHECK-NEXT:    movge r4, r3
; CHECK-NEXT:    mov r3, lr
; CHECK-NEXT:    strh r4, [r2], #2
; CHECK-NEXT:  .LBB1_3: @ %while.body.prol.loopexit
; CHECK-NEXT:    cmp lr, #0
; CHECK-NEXT:    beq .LBB1_6
; CHECK-NEXT:  @ %bb.4: @ %while.body.preheader1
; CHECK-NEXT:    movw lr, #32767
; CHECK-NEXT:  .LBB1_5: @ %while.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrsh r4, [r0]
; CHECK-NEXT:    ldrsh r5, [r1]
; CHECK-NEXT:    smulbb r4, r5, r4
; CHECK-NEXT:    asr r5, r4, #14
; CHECK-NEXT:    cmn r5, #32768
; CHECK-NEXT:    mov r5, r12
; CHECK-NEXT:    asrgt r5, r4, #14
; CHECK-NEXT:    cmp r5, lr
; CHECK-NEXT:    movge r5, lr
; CHECK-NEXT:    strh r5, [r2]
; CHECK-NEXT:    ldrsh r4, [r0, #2]
; CHECK-NEXT:    add r0, r0, #4
; CHECK-NEXT:    ldrsh r5, [r1, #2]
; CHECK-NEXT:    add r1, r1, #4
; CHECK-NEXT:    smulbb r4, r5, r4
; CHECK-NEXT:    asr r5, r4, #14
; CHECK-NEXT:    cmn r5, #32768
; CHECK-NEXT:    mov r5, r12
; CHECK-NEXT:    asrgt r5, r4, #14
; CHECK-NEXT:    cmp r5, lr
; CHECK-NEXT:    movge r5, lr
; CHECK-NEXT:    subs r3, r3, #2
; CHECK-NEXT:    strh r5, [r2, #2]
; CHECK-NEXT:    add r2, r2, #4
; CHECK-NEXT:    bne .LBB1_5
; CHECK-NEXT:  .LBB1_6: @ %while.end
; CHECK-NEXT:    pop {r4, r5, r11, pc}
entry:
  %cmp.not7 = icmp eq i32 %blockSize, 0
  br i1 %cmp.not7, label %while.end, label %while.body.preheader

while.body.preheader:                             ; preds = %entry
  %0 = add i32 %blockSize, -1
  %xtraiter = and i32 %blockSize, 1
  %lcmp.mod.not = icmp eq i32 %xtraiter, 0
  br i1 %lcmp.mod.not, label %while.body.prol.loopexit, label %while.body.prol.preheader

while.body.prol.preheader:                        ; preds = %while.body.preheader
  %incdec.ptr.prol = getelementptr inbounds i16, i16* %pSrcA, i64 1
  %1 = load i16, i16* %pSrcA, align 2
  %conv.prol = sext i16 %1 to i32
  %incdec.ptr1.prol = getelementptr inbounds i16, i16* %pSrcB, i64 1
  %2 = load i16, i16* %pSrcB, align 2
  %conv2.prol = sext i16 %2 to i32
  %mul.prol = mul nsw i32 %conv2.prol, %conv.prol
  %shr.prol = ashr i32 %mul.prol, 14
  %3 = call i32 @llvm.smax.i32(i32 %shr.prol, i32 -32768)
  %4 = call i32 @llvm.smin.i32(i32 %3, i32 32767)
  %conv3.prol = trunc i32 %4 to i16
  %incdec.ptr4.prol = getelementptr inbounds i16, i16* %pDst, i64 1
  store i16 %conv3.prol, i16* %pDst, align 2
  br label %while.body.prol.loopexit

while.body.prol.loopexit:                         ; preds = %while.body.prol.preheader, %while.body.preheader
  %blkCnt.011.unr = phi i32 [ %blockSize, %while.body.preheader ], [ %0, %while.body.prol.preheader ]
  %pSrcA.addr.010.unr = phi i16* [ %pSrcA, %while.body.preheader ], [ %incdec.ptr.prol, %while.body.prol.preheader ]
  %pDst.addr.09.unr = phi i16* [ %pDst, %while.body.preheader ], [ %incdec.ptr4.prol, %while.body.prol.preheader ]
  %pSrcB.addr.08.unr = phi i16* [ %pSrcB, %while.body.preheader ], [ %incdec.ptr1.prol, %while.body.prol.preheader ]
  %5 = icmp eq i32 %0, 0
  br i1 %5, label %while.end, label %while.body

while.body:                                       ; preds = %while.body.prol.loopexit, %while.body
  %blkCnt.011 = phi i32 [ %dec.1, %while.body ], [ %blkCnt.011.unr, %while.body.prol.loopexit ]
  %pSrcA.addr.010 = phi i16* [ %incdec.ptr.1, %while.body ], [ %pSrcA.addr.010.unr, %while.body.prol.loopexit ]
  %pDst.addr.09 = phi i16* [ %incdec.ptr4.1, %while.body ], [ %pDst.addr.09.unr, %while.body.prol.loopexit ]
  %pSrcB.addr.08 = phi i16* [ %incdec.ptr1.1, %while.body ], [ %pSrcB.addr.08.unr, %while.body.prol.loopexit ]
  %incdec.ptr = getelementptr inbounds i16, i16* %pSrcA.addr.010, i64 1
  %6 = load i16, i16* %pSrcA.addr.010, align 2
  %conv = sext i16 %6 to i32
  %incdec.ptr1 = getelementptr inbounds i16, i16* %pSrcB.addr.08, i64 1
  %7 = load i16, i16* %pSrcB.addr.08, align 2
  %conv2 = sext i16 %7 to i32
  %mul = mul nsw i32 %conv2, %conv
  %shr = ashr i32 %mul, 14
  %8 = call i32 @llvm.smax.i32(i32 %shr, i32 -32768)
  %9 = call i32 @llvm.smin.i32(i32 %8, i32 32767)
  %conv3 = trunc i32 %9 to i16
  %incdec.ptr4 = getelementptr inbounds i16, i16* %pDst.addr.09, i64 1
  store i16 %conv3, i16* %pDst.addr.09, align 2
  %incdec.ptr.1 = getelementptr inbounds i16, i16* %pSrcA.addr.010, i64 2
  %10 = load i16, i16* %incdec.ptr, align 2
  %conv.1 = sext i16 %10 to i32
  %incdec.ptr1.1 = getelementptr inbounds i16, i16* %pSrcB.addr.08, i64 2
  %11 = load i16, i16* %incdec.ptr1, align 2
  %conv2.1 = sext i16 %11 to i32
  %mul.1 = mul nsw i32 %conv2.1, %conv.1
  %shr.1 = ashr i32 %mul.1, 14
  %12 = call i32 @llvm.smax.i32(i32 %shr.1, i32 -32768)
  %13 = call i32 @llvm.smin.i32(i32 %12, i32 32767)
  %conv3.1 = trunc i32 %13 to i16
  %incdec.ptr4.1 = getelementptr inbounds i16, i16* %pDst.addr.09, i64 2
  store i16 %conv3.1, i16* %incdec.ptr4, align 2
  %dec.1 = add i32 %blkCnt.011, -2
  %cmp.not.1 = icmp eq i32 %dec.1, 0
  br i1 %cmp.not.1, label %while.end, label %while.body

while.end:                                        ; preds = %while.body, %while.body.prol.loopexit, %entry
  ret void
}

declare i32 @llvm.smax.i32(i32, i32) #1
declare i32 @llvm.smin.i32(i32, i32) #1
