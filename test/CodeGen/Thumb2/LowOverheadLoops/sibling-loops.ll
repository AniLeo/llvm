; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+lob --verify-machineinstrs %s -o - | FileCheck %s

define arm_aapcs_vfpcc void @test(i16* noalias nocapture readonly %off, i16* noalias nocapture %data, i16* noalias nocapture %dst, i32 %n) {
; CHECK-LABEL: test:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push.w {r4, r5, r6, r7, r8, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    blt .LBB0_7
; CHECK-NEXT:  @ %bb.1: @ %for.cond1.preheader.us.preheader
; CHECK-NEXT:    lsl.w r12, r3, #1
; CHECK-NEXT:    mov.w r8, #0
; CHECK-NEXT:    mov r4, r1
; CHECK-NEXT:  .LBB0_2: @ %for.cond1.preheader.us
; CHECK-NEXT:    @ =>This Loop Header: Depth=1
; CHECK-NEXT:    @ Child Loop BB0_3 Depth 2
; CHECK-NEXT:    @ Child Loop BB0_5 Depth 2
; CHECK-NEXT:    movs r5, #0
; CHECK-NEXT:    dls lr, r3
; CHECK-NEXT:  .LBB0_3: @ %for.body4.us
; CHECK-NEXT:    @ Parent Loop BB0_2 Depth=1
; CHECK-NEXT:    @ => This Inner Loop Header: Depth=2
; CHECK-NEXT:    ldrh.w r6, [r0, r5, lsl #1]
; CHECK-NEXT:    ldrh.w r7, [r1, r5, lsl #1]
; CHECK-NEXT:    add r6, r7
; CHECK-NEXT:    strh.w r6, [r4, r5, lsl #1]
; CHECK-NEXT:    adds r5, #1
; CHECK-NEXT:    le lr, .LBB0_3
; CHECK-NEXT:  @ %bb.4: @ %for.body15.us.preheader
; CHECK-NEXT:    @ in Loop: Header=BB0_2 Depth=1
; CHECK-NEXT:    movs r5, #0
; CHECK-NEXT:    dls lr, r3
; CHECK-NEXT:  .LBB0_5: @ %for.body15.us
; CHECK-NEXT:    @ Parent Loop BB0_2 Depth=1
; CHECK-NEXT:    @ => This Inner Loop Header: Depth=2
; CHECK-NEXT:    ldrh.w r7, [r0, r5, lsl #1]
; CHECK-NEXT:    ldrh.w r6, [r1, r5, lsl #1]
; CHECK-NEXT:    add r6, r7
; CHECK-NEXT:    strh.w r6, [r2, r5, lsl #1]
; CHECK-NEXT:    adds r5, #1
; CHECK-NEXT:    le lr, .LBB0_5
; CHECK-NEXT:  @ %bb.6: @ %for.cond.cleanup14.us
; CHECK-NEXT:    @ in Loop: Header=BB0_2 Depth=1
; CHECK-NEXT:    add.w r8, r8, #1
; CHECK-NEXT:    add r2, r12
; CHECK-NEXT:    add r4, r12
; CHECK-NEXT:    cmp r8, r3
; CHECK-NEXT:    bne .LBB0_2
; CHECK-NEXT:  .LBB0_7: @ %for.cond.cleanup
; CHECK-NEXT:    pop.w {r4, r5, r6, r7, r8, pc}
entry:
  %cmp252 = icmp sgt i32 %n, 0
  br i1 %cmp252, label %for.cond1.preheader.us, label %for.cond.cleanup

for.cond1.preheader.us: ; preds = %entry, %for.cond.cleanup14.us
  %i.057.us = phi i32 [ %inc29.us, %for.cond.cleanup14.us ], [ 0, %entry ]
  %mul.us = mul i32 %i.057.us, %n
  br label %for.body4.us

for.cond.cleanup14.us: ; preds = %for.body15.us
  %inc29.us = add nuw i32 %i.057.us, 1
  %exitcond94 = icmp eq i32 %inc29.us, %n
  br i1 %exitcond94, label %for.cond.cleanup, label %for.cond1.preheader.us

for.body15.us: ; preds = %for.body4.us, %for.body15.us
  %j10.055.us = phi i32 [ %inc26.us, %for.body15.us ], [ 0, %for.body4.us ]
  %arrayidx16.us = getelementptr inbounds i16, i16* %off, i32 %j10.055.us
  %0 = load i16, i16* %arrayidx16.us, align 2
  %arrayidx18.us = getelementptr inbounds i16, i16* %data, i32 %j10.055.us
  %1 = load i16, i16* %arrayidx18.us, align 2
  %add20.us = add i16 %1, %0
  %add23.us = add i32 %j10.055.us, %mul.us
  %arrayidx24.us = getelementptr inbounds i16, i16* %dst, i32 %add23.us
  store i16 %add20.us, i16* %arrayidx24.us, align 2
  %inc26.us = add nuw nsw i32 %j10.055.us, 1
  %exitcond93 = icmp eq i32 %inc26.us, %n
  br i1 %exitcond93, label %for.cond.cleanup14.us, label %for.body15.us

for.body4.us: ; preds = %for.body4.us, %for.cond1.preheader.us
  %j.053.us = phi i32 [ 0, %for.cond1.preheader.us ], [ %inc.us, %for.body4.us ]
  %arrayidx.us = getelementptr inbounds i16, i16* %off, i32 %j.053.us
  %2 = load i16, i16* %arrayidx.us, align 2
  %arrayidx5.us = getelementptr inbounds i16, i16* %data, i32 %j.053.us
  %3 = load i16, i16* %arrayidx5.us, align 2
  %add.us = add i16 %3, %2
  %add8.us = add i32 %j.053.us, %mul.us
  %arrayidx9.us = getelementptr inbounds i16, i16* %data, i32 %add8.us
  store i16 %add.us, i16* %arrayidx9.us, align 2
  %inc.us = add nuw nsw i32 %j.053.us, 1
  %exitcond = icmp eq i32 %inc.us, %n
  br i1 %exitcond, label %for.body15.us, label %for.body4.us

for.cond.cleanup: ; preds = %for.cond.cleanup14.us, %entry
  ret void
}
