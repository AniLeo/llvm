; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve -tail-predication=enabled %s -o - | \
; RUN:   FileCheck %s --check-prefix=ENABLED
;
; Forcing tail-predication should not be necessary here, so we check the same
; ENABLED label as the run above:
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve -tail-predication=force-enabled %s -o - | \
; RUN:   FileCheck %s  --check-prefix=ENABLED
;
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve -tail-predication=enabled-no-reductions %s -o - | \
; RUN:   FileCheck %s --check-prefix=NOREDUCTIONS
;
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve -tail-predication=force-enabled-no-reductions %s -o - | \
; RUN:   FileCheck %s --check-prefix=NOREDUCTIONS

define dso_local void @varying_outer_2d_reduction(i16* nocapture readonly %Input, i16* nocapture %Output, i16 signext %Size, i16 signext %N, i16 signext %Scale) local_unnamed_addr {
; ENABLED-LABEL: varying_outer_2d_reduction:
; ENABLED:       @ %bb.0: @ %entry
; ENABLED-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, lr}
; ENABLED-NEXT:    sub sp, #4
; ENABLED-NEXT:    cmp r3, #1
; ENABLED-NEXT:    str r0, [sp] @ 4-byte Spill
; ENABLED-NEXT:    blt .LBB0_8
; ENABLED-NEXT:  @ %bb.1: @ %for.body.lr.ph
; ENABLED-NEXT:    ldr r0, [sp, #36]
; ENABLED-NEXT:    add.w r12, r2, #3
; ENABLED-NEXT:    ldr.w r10, [sp] @ 4-byte Reload
; ENABLED-NEXT:    movs r6, #0
; ENABLED-NEXT:    mov r9, r12
; ENABLED-NEXT:    uxth r0, r0
; ENABLED-NEXT:    rsbs r5, r0, #0
; ENABLED-NEXT:    b .LBB0_4
; ENABLED-NEXT:  .LBB0_2: @ in Loop: Header=BB0_4 Depth=1
; ENABLED-NEXT:    movs r0, #0
; ENABLED-NEXT:  .LBB0_3: @ %for.end
; ENABLED-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; ENABLED-NEXT:    lsrs r0, r0, #16
; ENABLED-NEXT:    sub.w r9, r9, #1
; ENABLED-NEXT:    strh.w r0, [r1, r6, lsl #1]
; ENABLED-NEXT:    adds r6, #1
; ENABLED-NEXT:    add.w r10, r10, #2
; ENABLED-NEXT:    cmp r6, r3
; ENABLED-NEXT:    beq .LBB0_8
; ENABLED-NEXT:  .LBB0_4: @ %for.body
; ENABLED-NEXT:    @ =>This Loop Header: Depth=1
; ENABLED-NEXT:    @ Child Loop BB0_6 Depth 2
; ENABLED-NEXT:    cmp r2, r6
; ENABLED-NEXT:    ble .LBB0_2
; ENABLED-NEXT:  @ %bb.5: @ %vector.ph
; ENABLED-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; ENABLED-NEXT:    bic r0, r9, #3
; ENABLED-NEXT:    movs r7, #1
; ENABLED-NEXT:    subs r0, #4
; ENABLED-NEXT:    subs r4, r2, r6
; ENABLED-NEXT:    vmov.i32 q0, #0x0
; ENABLED-NEXT:    add.w r8, r7, r0, lsr #2
; ENABLED-NEXT:    mov r7, r10
; ENABLED-NEXT:    dlstp.32 lr, r4
; ENABLED-NEXT:    ldr r0, [sp] @ 4-byte Reload
; ENABLED-NEXT:  .LBB0_6: @ %vector.body
; ENABLED-NEXT:    @ Parent Loop BB0_4 Depth=1
; ENABLED-NEXT:    @ => This Inner Loop Header: Depth=2
; ENABLED-NEXT:    vldrh.s32 q1, [r0], #8
; ENABLED-NEXT:    vldrh.s32 q2, [r7], #8
; ENABLED-NEXT:    mov lr, r8
; ENABLED-NEXT:    vmul.i32 q1, q2, q1
; ENABLED-NEXT:    sub.w r8, r8, #1
; ENABLED-NEXT:    vshl.s32 q1, r5
; ENABLED-NEXT:    vadd.i32 q0, q1, q0
; ENABLED-NEXT:    letp lr, .LBB0_6
; ENABLED-NEXT:  @ %bb.7: @ %middle.block
; ENABLED-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; ENABLED-NEXT:    vaddv.u32 r0, q0
; ENABLED-NEXT:    b .LBB0_3
; ENABLED-NEXT:  .LBB0_8: @ %for.end17
; ENABLED-NEXT:    add sp, #4
; ENABLED-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, pc}
;
; NOREDUCTIONS-LABEL: varying_outer_2d_reduction:
; NOREDUCTIONS:       @ %bb.0: @ %entry
; NOREDUCTIONS-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, lr}
; NOREDUCTIONS-NEXT:    sub sp, #4
; NOREDUCTIONS-NEXT:    cmp r3, #1
; NOREDUCTIONS-NEXT:    str r0, [sp] @ 4-byte Spill
; NOREDUCTIONS-NEXT:    blt .LBB0_8
; NOREDUCTIONS-NEXT:  @ %bb.1: @ %for.body.lr.ph
; NOREDUCTIONS-NEXT:    ldr r0, [sp, #36]
; NOREDUCTIONS-NEXT:    add.w r12, r2, #3
; NOREDUCTIONS-NEXT:    ldr.w r10, [sp] @ 4-byte Reload
; NOREDUCTIONS-NEXT:    movs r6, #0
; NOREDUCTIONS-NEXT:    mov r9, r12
; NOREDUCTIONS-NEXT:    uxth r0, r0
; NOREDUCTIONS-NEXT:    rsbs r5, r0, #0
; NOREDUCTIONS-NEXT:    b .LBB0_4
; NOREDUCTIONS-NEXT:  .LBB0_2: @ in Loop: Header=BB0_4 Depth=1
; NOREDUCTIONS-NEXT:    movs r0, #0
; NOREDUCTIONS-NEXT:  .LBB0_3: @ %for.end
; NOREDUCTIONS-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; NOREDUCTIONS-NEXT:    lsrs r0, r0, #16
; NOREDUCTIONS-NEXT:    sub.w r9, r9, #1
; NOREDUCTIONS-NEXT:    strh.w r0, [r1, r6, lsl #1]
; NOREDUCTIONS-NEXT:    adds r6, #1
; NOREDUCTIONS-NEXT:    add.w r10, r10, #2
; NOREDUCTIONS-NEXT:    cmp r6, r3
; NOREDUCTIONS-NEXT:    beq .LBB0_8
; NOREDUCTIONS-NEXT:  .LBB0_4: @ %for.body
; NOREDUCTIONS-NEXT:    @ =>This Loop Header: Depth=1
; NOREDUCTIONS-NEXT:    @ Child Loop BB0_6 Depth 2
; NOREDUCTIONS-NEXT:    cmp r2, r6
; NOREDUCTIONS-NEXT:    ble .LBB0_2
; NOREDUCTIONS-NEXT:  @ %bb.5: @ %vector.ph
; NOREDUCTIONS-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; NOREDUCTIONS-NEXT:    bic r0, r9, #3
; NOREDUCTIONS-NEXT:    movs r7, #1
; NOREDUCTIONS-NEXT:    subs r0, #4
; NOREDUCTIONS-NEXT:    subs r4, r2, r6
; NOREDUCTIONS-NEXT:    vmov.i32 q0, #0x0
; NOREDUCTIONS-NEXT:    add.w r8, r7, r0, lsr #2
; NOREDUCTIONS-NEXT:    mov r7, r10
; NOREDUCTIONS-NEXT:    dlstp.32 lr, r4
; NOREDUCTIONS-NEXT:    ldr r0, [sp] @ 4-byte Reload
; NOREDUCTIONS-NEXT:  .LBB0_6: @ %vector.body
; NOREDUCTIONS-NEXT:    @ Parent Loop BB0_4 Depth=1
; NOREDUCTIONS-NEXT:    @ => This Inner Loop Header: Depth=2
; NOREDUCTIONS-NEXT:    vldrh.s32 q1, [r0], #8
; NOREDUCTIONS-NEXT:    vldrh.s32 q2, [r7], #8
; NOREDUCTIONS-NEXT:    mov lr, r8
; NOREDUCTIONS-NEXT:    vmul.i32 q1, q2, q1
; NOREDUCTIONS-NEXT:    sub.w r8, r8, #1
; NOREDUCTIONS-NEXT:    vshl.s32 q1, r5
; NOREDUCTIONS-NEXT:    vadd.i32 q0, q1, q0
; NOREDUCTIONS-NEXT:    letp lr, .LBB0_6
; NOREDUCTIONS-NEXT:  @ %bb.7: @ %middle.block
; NOREDUCTIONS-NEXT:    @ in Loop: Header=BB0_4 Depth=1
; NOREDUCTIONS-NEXT:    vaddv.u32 r0, q0
; NOREDUCTIONS-NEXT:    b .LBB0_3
; NOREDUCTIONS-NEXT:  .LBB0_8: @ %for.end17
; NOREDUCTIONS-NEXT:    add sp, #4
; NOREDUCTIONS-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, pc}
entry:
  %conv = sext i16 %N to i32
  %cmp36 = icmp sgt i16 %N, 0
  br i1 %cmp36, label %for.body.lr.ph, label %for.end17

for.body.lr.ph:                                   ; preds = %entry
  %conv2 = sext i16 %Size to i32
  %conv1032 = zext i16 %Scale to i32
  %i = add i32 %conv2, 3
  br label %for.body

for.body:                                         ; preds = %for.end, %for.body.lr.ph
  %lsr.iv51 = phi i32 [ %lsr.iv.next, %for.end ], [ %i, %for.body.lr.ph ]
  %lsr.iv46 = phi i16* [ %scevgep47, %for.end ], [ %Input, %for.body.lr.ph ]
  %i.037 = phi i32 [ 0, %for.body.lr.ph ], [ %inc16, %for.end ]
  %i1 = mul nsw i32 %i.037, -1
  %i2 = add i32 %i, %i1
  %i3 = lshr i32 %i2, 2
  %i4 = shl nuw i32 %i3, 2
  %i5 = add i32 %i4, -4
  %i6 = lshr i32 %i5, 2
  %i7 = add nuw nsw i32 %i6, 1
  %i8 = sub i32 %conv2, %i.037
  %cmp433 = icmp slt i32 %i.037, %conv2
  br i1 %cmp433, label %vector.ph, label %for.end

vector.ph:                                        ; preds = %for.body
  %trip.count.minus.1 = add i32 %i8, -1
  call void @llvm.set.loop.iterations.i32(i32 %i7)
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %lsr.iv48 = phi i16* [ %scevgep49, %vector.body ], [ %lsr.iv46, %vector.ph ]
  %lsr.iv = phi i16* [ %scevgep, %vector.body ], [ %Input, %vector.ph ]
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %i16, %vector.body ]
  %i9 = phi i32 [ %i7, %vector.ph ], [ %i17, %vector.body ]
  %lsr.iv4850 = bitcast i16* %lsr.iv48 to <4 x i16>*
  %lsr.iv45 = bitcast i16* %lsr.iv to <4 x i16>*
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %i8)
  %wide.masked.load = call <4 x i16> @llvm.masked.load.v4i16.p0v4i16(<4 x i16>* %lsr.iv45, i32 2, <4 x i1> %active.lane.mask, <4 x i16> undef)
  %i10 = sext <4 x i16> %wide.masked.load to <4 x i32>
  %wide.masked.load42 = call <4 x i16> @llvm.masked.load.v4i16.p0v4i16(<4 x i16>* %lsr.iv4850, i32 2, <4 x i1> %active.lane.mask, <4 x i16> undef)
  %i11 = sext <4 x i16> %wide.masked.load42 to <4 x i32>
  %i12 = mul nsw <4 x i32> %i11, %i10
  %i13 = insertelement <4 x i32> undef, i32 %conv1032, i32 0
  %i14 = shufflevector <4 x i32> %i13, <4 x i32> undef, <4 x i32> zeroinitializer
  %i15 = ashr <4 x i32> %i12, %i14
  %i16 = add <4 x i32> %i15, %vec.phi
  %index.next = add i32 %index, 4
  %scevgep = getelementptr i16, i16* %lsr.iv, i32 4
  %scevgep49 = getelementptr i16, i16* %lsr.iv48, i32 4
  %i17 = call i32 @llvm.loop.decrement.reg.i32(i32 %i9, i32 1)
  %i18 = icmp ne i32 %i17, 0
  br i1 %i18, label %vector.body, label %middle.block

middle.block:                                     ; preds = %vector.body
  %i19 = select <4 x i1> %active.lane.mask, <4 x i32> %i16, <4 x i32> %vec.phi
  %i20 = call i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32> %i19)
  br label %for.end

for.end:                                          ; preds = %middle.block, %for.body
  %Sum.0.lcssa = phi i32 [ 0, %for.body ], [ %i20, %middle.block ]
  %i21 = lshr i32 %Sum.0.lcssa, 16
  %conv13 = trunc i32 %i21 to i16
  %arrayidx14 = getelementptr inbounds i16, i16* %Output, i32 %i.037
  store i16 %conv13, i16* %arrayidx14, align 2
  %inc16 = add nuw nsw i32 %i.037, 1
  %scevgep47 = getelementptr i16, i16* %lsr.iv46, i32 1
  %lsr.iv.next = add i32 %lsr.iv51, -1
  %exitcond39 = icmp eq i32 %inc16, %conv
  br i1 %exitcond39, label %for.end17, label %for.body

for.end17:                                        ; preds = %for.end, %entry
  ret void
}

declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32, i32)
declare <4 x i16> @llvm.masked.load.v4i16.p0v4i16(<4 x i16>*, i32 immarg, <4 x i1>, <4 x i16>)
declare i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32>)
declare i32 @llvm.loop.decrement.reg.i32(i32, i32)
declare void @llvm.set.loop.iterations.i32(i32)
