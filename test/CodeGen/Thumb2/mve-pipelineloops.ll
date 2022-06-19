; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -O3 -mattr=+mve.fp,+use-mipipeliner -mcpu=cortex-m55 %s -o - -verify-machineinstrs | FileCheck %s

define void @arm_cmplx_dot_prod_q15(ptr noundef %pSrcA, ptr noundef %pSrcB, i32 noundef %numSamples, ptr nocapture noundef writeonly %realResult, ptr nocapture noundef writeonly %imagResult) {
; CHECK-LABEL: arm_cmplx_dot_prod_q15:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    ldr.w r12, [sp, #56]
; CHECK-NEXT:    cmp r2, #16
; CHECK-NEXT:    blo .LBB0_5
; CHECK-NEXT:  @ %bb.1: @ %while.body.preheader
; CHECK-NEXT:    lsrs r7, r2, #3
; CHECK-NEXT:    movs r6, #2
; CHECK-NEXT:    rsb r6, r6, r2, lsr #3
; CHECK-NEXT:    movs r5, #0
; CHECK-NEXT:    cmp r7, #2
; CHECK-NEXT:    csel r7, r6, r5, hs
; CHECK-NEXT:    add.w lr, r7, #1
; CHECK-NEXT:    vldrh.u16 q4, [r0], #32
; CHECK-NEXT:    vldrh.u16 q5, [r1], #32
; CHECK-NEXT:    mov r4, r5
; CHECK-NEXT:    movs r7, #0
; CHECK-NEXT:    vldrh.u16 q1, [r0, #-16]
; CHECK-NEXT:    mov r6, r5
; CHECK-NEXT:    sub.w lr, lr, #1
; CHECK-NEXT:    vldrh.u16 q3, [r1, #-16]
; CHECK-NEXT:    vldrh.u16 q2, [r1], #32
; CHECK-NEXT:    vldrh.u16 q0, [r0], #32
; CHECK-NEXT:    vmlsldava.s16 r4, r7, q4, q5
; CHECK-NEXT:    cmp.w lr, #0
; CHECK-NEXT:    vmlaldavax.s16 r6, r5, q4, q5
; CHECK-NEXT:    beq .LBB0_3
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  .LBB0_2: @ %while.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vmlaldavax.s16 r6, r5, q1, q3
; CHECK-NEXT:    vmlsldava.s16 r4, r7, q1, q3
; CHECK-NEXT:    vldrh.u16 q1, [r0, #-16]
; CHECK-NEXT:    vmlaldavax.s16 r6, r5, q0, q2
; CHECK-NEXT:    vmlsldava.s16 r4, r7, q0, q2
; CHECK-NEXT:    vldrh.u16 q0, [r0], #32
; CHECK-NEXT:    vldrh.u16 q3, [r1, #-16]
; CHECK-NEXT:    vldrh.u16 q2, [r1]
; CHECK-NEXT:    adds r1, #32
; CHECK-NEXT:    le lr, .LBB0_2
; CHECK-NEXT:  .LBB0_3:
; CHECK-NEXT:    mov.w lr, #14
; CHECK-NEXT:    vmlsldava.s16 r4, r7, q1, q3
; CHECK-NEXT:    vmlaldavax.s16 r6, r5, q1, q3
; CHECK-NEXT:    and.w r2, lr, r2, lsl #1
; CHECK-NEXT:    vmlaldavax.s16 r6, r5, q0, q2
; CHECK-NEXT:    vldrh.u16 q1, [r0, #-16]
; CHECK-NEXT:    vmlsldava.s16 r4, r7, q0, q2
; CHECK-NEXT:    vldrh.u16 q0, [r1, #-16]
; CHECK-NEXT:    vctp.16 r2
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vldrht.u16 q2, [r0]
; CHECK-NEXT:    vldrht.u16 q3, [r1]
; CHECK-NEXT:    vmlaldavax.s16 r6, r5, q1, q0
; CHECK-NEXT:    vmlsldava.s16 r4, r7, q1, q0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vmlsldavat.s16 r4, r7, q2, q3
; CHECK-NEXT:    cmp r2, #9
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vmlaldavaxt.s16 r6, r5, q2, q3
; CHECK-NEXT:    blo .LBB0_10
; CHECK-NEXT:  @ %bb.4: @ %do.body.1
; CHECK-NEXT:    subs r2, #8
; CHECK-NEXT:    vctp.16 r2
; CHECK-NEXT:    vpstttt
; CHECK-NEXT:    vldrht.u16 q0, [r0, #16]
; CHECK-NEXT:    vldrht.u16 q1, [r1, #16]
; CHECK-NEXT:    vmlsldavat.s16 r4, r7, q0, q1
; CHECK-NEXT:    vmlaldavaxt.s16 r6, r5, q0, q1
; CHECK-NEXT:    b .LBB0_10
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  .LBB0_5: @ %if.else
; CHECK-NEXT:    mov.w r4, #0
; CHECK-NEXT:    cbz r2, .LBB0_9
; CHECK-NEXT:  @ %bb.6: @ %while.body14.preheader
; CHECK-NEXT:    lsls r6, r2, #1
; CHECK-NEXT:    mov r5, r4
; CHECK-NEXT:    mov r7, r4
; CHECK-NEXT:    movs r2, #0
; CHECK-NEXT:    dlstp.16 lr, r6
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  .LBB0_7: @ %while.body14
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r0], #16
; CHECK-NEXT:    vldrh.u16 q1, [r1], #16
; CHECK-NEXT:    vmlsldava.s16 r2, r7, q0, q1
; CHECK-NEXT:    vmlaldavax.s16 r4, r5, q0, q1
; CHECK-NEXT:    letp lr, .LBB0_7
; CHECK-NEXT:  @ %bb.8: @ %if.end.loopexit177
; CHECK-NEXT:    mov r6, r4
; CHECK-NEXT:    mov r4, r2
; CHECK-NEXT:    b .LBB0_10
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  .LBB0_9:
; CHECK-NEXT:    mov r7, r4
; CHECK-NEXT:    movs r6, #0
; CHECK-NEXT:    mov r5, r4
; CHECK-NEXT:  .LBB0_10: @ %if.end
; CHECK-NEXT:    asrl r4, r7, #6
; CHECK-NEXT:    asrl r6, r5, #6
; CHECK-NEXT:    str r4, [r3]
; CHECK-NEXT:    str.w r6, [r12]
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %cmp = icmp ugt i32 %numSamples, 15
  br i1 %cmp, label %while.body.preheader, label %if.else

while.body.preheader:                             ; preds = %entry
  %vecSrcA.0138 = load <8 x i16>, ptr %pSrcA, align 2
  %vecSrcB.0137 = load <8 x i16>, ptr %pSrcB, align 2
  %pSrcB.addr.0136 = getelementptr inbounds i16, ptr %pSrcB, i32 8
  %pSrcA.addr.0135 = getelementptr inbounds i16, ptr %pSrcA, i32 8
  %shr = lshr i32 %numSamples, 3
  br label %while.body

while.body:                                       ; preds = %while.body.preheader, %while.body
  %vecSrcA.0150 = phi <8 x i16> [ %vecSrcA.0, %while.body ], [ %vecSrcA.0138, %while.body.preheader ]
  %vecSrcB.0149 = phi <8 x i16> [ %vecSrcB.0, %while.body ], [ %vecSrcB.0137, %while.body.preheader ]
  %pSrcB.addr.0148 = phi ptr [ %pSrcB.addr.0, %while.body ], [ %pSrcB.addr.0136, %while.body.preheader ]
  %pSrcA.addr.0147 = phi ptr [ %pSrcA.addr.0, %while.body ], [ %pSrcA.addr.0135, %while.body.preheader ]
  %vecSrcB.0.in146 = phi ptr [ %add.ptr4, %while.body ], [ %pSrcB, %while.body.preheader ]
  %vecSrcA.0.in145 = phi ptr [ %add.ptr3, %while.body ], [ %pSrcA, %while.body.preheader ]
  %accImag.0.off32144 = phi i32 [ %12, %while.body ], [ 0, %while.body.preheader ]
  %accImag.0.off0143 = phi i32 [ %13, %while.body ], [ 0, %while.body.preheader ]
  %accReal.0.off32142 = phi i32 [ %9, %while.body ], [ 0, %while.body.preheader ]
  %accReal.0.off0141 = phi i32 [ %10, %while.body ], [ 0, %while.body.preheader ]
  %blkCnt.0.in140 = phi i32 [ %blkCnt.0, %while.body ], [ %shr, %while.body.preheader ]
  %blkCnt.0 = add nsw i32 %blkCnt.0.in140, -1
  %0 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.v8i16(i32 0, i32 1, i32 0, i32 %accReal.0.off0141, i32 %accReal.0.off32142, <8 x i16> %vecSrcA.0150, <8 x i16> %vecSrcB.0149)
  %1 = extractvalue { i32, i32 } %0, 1
  %2 = extractvalue { i32, i32 } %0, 0
  %3 = load <8 x i16>, ptr %pSrcA.addr.0147, align 2
  %add.ptr3 = getelementptr inbounds i16, ptr %vecSrcA.0.in145, i32 16
  %4 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.v8i16(i32 0, i32 0, i32 1, i32 %accImag.0.off0143, i32 %accImag.0.off32144, <8 x i16> %vecSrcA.0150, <8 x i16> %vecSrcB.0149)
  %5 = extractvalue { i32, i32 } %4, 1
  %6 = extractvalue { i32, i32 } %4, 0
  %7 = load <8 x i16>, ptr %pSrcB.addr.0148, align 2
  %add.ptr4 = getelementptr inbounds i16, ptr %vecSrcB.0.in146, i32 16
  %8 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.v8i16(i32 0, i32 1, i32 0, i32 %2, i32 %1, <8 x i16> %3, <8 x i16> %7)
  %9 = extractvalue { i32, i32 } %8, 1
  %10 = extractvalue { i32, i32 } %8, 0
  %11 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.v8i16(i32 0, i32 0, i32 1, i32 %6, i32 %5, <8 x i16> %3, <8 x i16> %7)
  %12 = extractvalue { i32, i32 } %11, 1
  %13 = extractvalue { i32, i32 } %11, 0
  %pSrcA.addr.0 = getelementptr inbounds i16, ptr %vecSrcA.0.in145, i32 24
  %pSrcB.addr.0 = getelementptr inbounds i16, ptr %vecSrcB.0.in146, i32 24
  %vecSrcB.0 = load <8 x i16>, ptr %add.ptr4, align 2
  %vecSrcA.0 = load <8 x i16>, ptr %add.ptr3, align 2
  %cmp2 = icmp ugt i32 %blkCnt.0.in140, 2
  br i1 %cmp2, label %while.body, label %do.body

do.body:                                          ; preds = %while.body
  %and = shl i32 %numSamples, 1
  %mul = and i32 %and, 14
  %14 = extractvalue { i32, i32 } %11, 0
  %15 = extractvalue { i32, i32 } %11, 1
  %16 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.v8i16(i32 0, i32 0, i32 1, i32 %14, i32 %15, <8 x i16> %vecSrcA.0, <8 x i16> %vecSrcB.0)
  %17 = extractvalue { i32, i32 } %16, 0
  %18 = extractvalue { i32, i32 } %16, 1
  %19 = load <8 x i16>, ptr %pSrcA.addr.0, align 2
  %20 = load <8 x i16>, ptr %pSrcB.addr.0, align 2
  %21 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.v8i16(i32 0, i32 0, i32 1, i32 %17, i32 %18, <8 x i16> %19, <8 x i16> %20)
  %22 = extractvalue { i32, i32 } %8, 0
  %23 = extractvalue { i32, i32 } %8, 1
  %24 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.v8i16(i32 0, i32 1, i32 0, i32 %22, i32 %23, <8 x i16> %vecSrcA.0, <8 x i16> %vecSrcB.0)
  %25 = extractvalue { i32, i32 } %24, 0
  %26 = extractvalue { i32, i32 } %24, 1
  %27 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.v8i16(i32 0, i32 1, i32 0, i32 %25, i32 %26, <8 x i16> %19, <8 x i16> %20)
  %accImag.1.off32 = extractvalue { i32, i32 } %21, 1
  %accImag.1.off0 = extractvalue { i32, i32 } %21, 0
  %accReal.1.off32 = extractvalue { i32, i32 } %27, 1
  %accReal.1.off0 = extractvalue { i32, i32 } %27, 0
  %28 = tail call <8 x i1> @llvm.arm.mve.vctp16(i32 %mul)
  %add.ptr7 = getelementptr inbounds i16, ptr %vecSrcA.0.in145, i32 32
  %add.ptr8 = getelementptr inbounds i16, ptr %vecSrcB.0.in146, i32 32
  %29 = tail call <8 x i16> @llvm.masked.load.v8i16.p0(ptr nonnull %add.ptr7, i32 2, <8 x i1> %28, <8 x i16> zeroinitializer)
  %30 = tail call <8 x i16> @llvm.masked.load.v8i16.p0(ptr nonnull %add.ptr8, i32 2, <8 x i1> %28, <8 x i16> zeroinitializer)
  %31 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.predicated.v8i16.v8i1(i32 0, i32 1, i32 0, i32 %accReal.1.off0, i32 %accReal.1.off32, <8 x i16> %29, <8 x i16> %30, <8 x i1> %28)
  %32 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.predicated.v8i16.v8i1(i32 0, i32 0, i32 1, i32 %accImag.1.off0, i32 %accImag.1.off32, <8 x i16> %29, <8 x i16> %30, <8 x i1> %28)
  %cmp10 = icmp ugt i32 %mul, 8
  br i1 %cmp10, label %do.body.1, label %if.end.loopexit

do.body.1:                                        ; preds = %do.body
  %sub9 = add nsw i32 %mul, -8
  %accImag.1.off32.1 = extractvalue { i32, i32 } %32, 1
  %accImag.1.off0.1 = extractvalue { i32, i32 } %32, 0
  %accReal.1.off32.1 = extractvalue { i32, i32 } %31, 1
  %accReal.1.off0.1 = extractvalue { i32, i32 } %31, 0
  %33 = tail call <8 x i1> @llvm.arm.mve.vctp16(i32 %sub9)
  %add.ptr7.1 = getelementptr inbounds i16, ptr %vecSrcA.0.in145, i32 40
  %add.ptr8.1 = getelementptr inbounds i16, ptr %vecSrcB.0.in146, i32 40
  %34 = tail call <8 x i16> @llvm.masked.load.v8i16.p0(ptr nonnull %add.ptr7.1, i32 2, <8 x i1> %33, <8 x i16> zeroinitializer)
  %35 = tail call <8 x i16> @llvm.masked.load.v8i16.p0(ptr nonnull %add.ptr8.1, i32 2, <8 x i1> %33, <8 x i16> zeroinitializer)
  %36 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.predicated.v8i16.v8i1(i32 0, i32 1, i32 0, i32 %accReal.1.off0.1, i32 %accReal.1.off32.1, <8 x i16> %34, <8 x i16> %35, <8 x i1> %33)
  %37 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.predicated.v8i16.v8i1(i32 0, i32 0, i32 1, i32 %accImag.1.off0.1, i32 %accImag.1.off32.1, <8 x i16> %34, <8 x i16> %35, <8 x i1> %33)
  br label %if.end.loopexit

if.else:                                          ; preds = %entry
  %cmp13120.not = icmp eq i32 %numSamples, 0
  br i1 %cmp13120.not, label %if.end, label %while.body14.preheader

while.body14.preheader:                           ; preds = %if.else
  %mul11 = shl nuw nsw i32 %numSamples, 1
  br label %while.body14

while.body14:                                     ; preds = %while.body14.preheader, %while.body14
  %pSrcA.addr.2127 = phi ptr [ %add.ptr16, %while.body14 ], [ %pSrcA, %while.body14.preheader ]
  %pSrcB.addr.2126 = phi ptr [ %add.ptr17, %while.body14 ], [ %pSrcB, %while.body14.preheader ]
  %accImag.2.off32125 = phi i32 [ %45, %while.body14 ], [ 0, %while.body14.preheader ]
  %accImag.2.off0124 = phi i32 [ %46, %while.body14 ], [ 0, %while.body14.preheader ]
  %accReal.2.off32123 = phi i32 [ %42, %while.body14 ], [ 0, %while.body14.preheader ]
  %accReal.2.off0122 = phi i32 [ %43, %while.body14 ], [ 0, %while.body14.preheader ]
  %blkCnt.2121 = phi i32 [ %sub18, %while.body14 ], [ %mul11, %while.body14.preheader ]
  %38 = tail call <8 x i1> @llvm.arm.mve.vctp16(i32 %blkCnt.2121)
  %39 = tail call <8 x i16> @llvm.masked.load.v8i16.p0(ptr %pSrcA.addr.2127, i32 2, <8 x i1> %38, <8 x i16> zeroinitializer)
  %40 = tail call <8 x i16> @llvm.masked.load.v8i16.p0(ptr %pSrcB.addr.2126, i32 2, <8 x i1> %38, <8 x i16> zeroinitializer)
  %41 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.predicated.v8i16.v8i1(i32 0, i32 1, i32 0, i32 %accReal.2.off0122, i32 %accReal.2.off32123, <8 x i16> %39, <8 x i16> %40, <8 x i1> %38)
  %42 = extractvalue { i32, i32 } %41, 1
  %43 = extractvalue { i32, i32 } %41, 0
  %44 = tail call { i32, i32 } @llvm.arm.mve.vmlldava.predicated.v8i16.v8i1(i32 0, i32 0, i32 1, i32 %accImag.2.off0124, i32 %accImag.2.off32125, <8 x i16> %39, <8 x i16> %40, <8 x i1> %38)
  %45 = extractvalue { i32, i32 } %44, 1
  %46 = extractvalue { i32, i32 } %44, 0
  %add.ptr16 = getelementptr inbounds i16, ptr %pSrcA.addr.2127, i32 8
  %add.ptr17 = getelementptr inbounds i16, ptr %pSrcB.addr.2126, i32 8
  %sub18 = add nsw i32 %blkCnt.2121, -8
  %cmp13 = icmp ugt i32 %blkCnt.2121, 8
  br i1 %cmp13, label %while.body14, label %if.end.loopexit177

if.end.loopexit:                                  ; preds = %do.body.1, %do.body
  %.lcssa200 = phi { i32, i32 } [ %31, %do.body ], [ %36, %do.body.1 ]
  %.lcssa = phi { i32, i32 } [ %32, %do.body ], [ %37, %do.body.1 ]
  %47 = extractvalue { i32, i32 } %.lcssa200, 1
  %48 = extractvalue { i32, i32 } %.lcssa200, 0
  %49 = extractvalue { i32, i32 } %.lcssa, 1
  %50 = extractvalue { i32, i32 } %.lcssa, 0
  br label %if.end

if.end.loopexit177:                               ; preds = %while.body14
  %51 = extractvalue { i32, i32 } %41, 1
  %52 = extractvalue { i32, i32 } %41, 0
  %53 = extractvalue { i32, i32 } %44, 1
  %54 = extractvalue { i32, i32 } %44, 0
  br label %if.end

if.end:                                           ; preds = %if.end.loopexit177, %if.else, %if.end.loopexit
  %accReal.3.off0 = phi i32 [ %48, %if.end.loopexit ], [ 0, %if.else ], [ %52, %if.end.loopexit177 ]
  %accReal.3.off32 = phi i32 [ %47, %if.end.loopexit ], [ 0, %if.else ], [ %51, %if.end.loopexit177 ]
  %accImag.3.off0 = phi i32 [ %50, %if.end.loopexit ], [ 0, %if.else ], [ %54, %if.end.loopexit177 ]
  %accImag.3.off32 = phi i32 [ %49, %if.end.loopexit ], [ 0, %if.else ], [ %53, %if.end.loopexit177 ]
  %55 = tail call { i32, i32 } @llvm.arm.mve.asrl(i32 %accReal.3.off0, i32 %accReal.3.off32, i32 6)
  %56 = extractvalue { i32, i32 } %55, 0
  store i32 %56, ptr %realResult, align 4
  %57 = tail call { i32, i32 } @llvm.arm.mve.asrl(i32 %accImag.3.off0, i32 %accImag.3.off32, i32 6)
  %58 = extractvalue { i32, i32 } %57, 0
  store i32 %58, ptr %imagResult, align 4
  ret void
}

declare { i32, i32 } @llvm.arm.mve.vmlldava.v8i16(i32, i32, i32, i32, i32, <8 x i16>, <8 x i16>) #1
declare <8 x i1> @llvm.arm.mve.vctp16(i32) #1
declare <8 x i16> @llvm.masked.load.v8i16.p0(ptr, i32 immarg, <8 x i1>, <8 x i16>) #2
declare { i32, i32 } @llvm.arm.mve.vmlldava.predicated.v8i16.v8i1(i32, i32, i32, i32, i32, <8 x i16>, <8 x i16>, <8 x i1>) #1
declare { i32, i32 } @llvm.arm.mve.asrl(i32, i32, i32) #1
