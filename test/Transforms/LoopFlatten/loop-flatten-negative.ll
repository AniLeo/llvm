; RUN: opt < %s -S -loop-flatten -debug-only=loop-flatten 2>&1 | FileCheck %s
; REQUIRES: asserts

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"

; Every function in this file has a reason that it can't be transformed.

; CHECK-NOT: Checks all passed, doing the transformation

; Outer loop does not start at zero
define void @test_1(i32 %N, i32* nocapture %C, i32* nocapture readonly %A, i32 %scale) {
entry:
  %cmp25 = icmp sgt i32 %N, 0
  br i1 %cmp25, label %for.body4.lr.ph, label %for.cond.cleanup

for.body4.lr.ph:
  %i.026 = phi i32 [ %inc10, %for.cond.cleanup3 ], [ 1, %entry ]
  %mul = mul nsw i32 %i.026, %N
  br label %for.body4

for.body4:
  %j.024 = phi i32 [ 0, %for.body4.lr.ph ], [ %inc, %for.body4 ]
  %add = add nsw i32 %j.024, %mul
  %arrayidx = getelementptr inbounds i32, i32* %A, i32 %add
  %0 = load i32, i32* %arrayidx, align 4
  %mul5 = mul nsw i32 %0, %scale
  %arrayidx8 = getelementptr inbounds i32, i32* %C, i32 %add
  store i32 %mul5, i32* %arrayidx8, align 4
  %inc = add nuw nsw i32 %j.024, 1
  %exitcond = icmp eq i32 %inc, %N
  br i1 %exitcond, label %for.cond.cleanup3, label %for.body4

for.cond.cleanup3:
  %inc10 = add nuw nsw i32 %i.026, 1
  %exitcond27 = icmp eq i32 %inc10, %N
  br i1 %exitcond27, label %for.cond.cleanup, label %for.body4.lr.ph

for.cond.cleanup:
  ret void
}

; Inner loop does not start at zero
define void @test_2(i32 %N, i32* nocapture %C, i32* nocapture readonly %A, i32 %scale) {
entry:
  %cmp25 = icmp sgt i32 %N, 0
  br i1 %cmp25, label %for.body4.lr.ph, label %for.cond.cleanup

for.body4.lr.ph:
  %i.026 = phi i32 [ %inc10, %for.cond.cleanup3 ], [ 0, %entry ]
  %mul = mul nsw i32 %i.026, %N
  br label %for.body4

for.body4:
  %j.024 = phi i32 [ 1, %for.body4.lr.ph ], [ %inc, %for.body4 ]
  %add = add nsw i32 %j.024, %mul
  %arrayidx = getelementptr inbounds i32, i32* %A, i32 %add
  %0 = load i32, i32* %arrayidx, align 4
  %mul5 = mul nsw i32 %0, %scale
  %arrayidx8 = getelementptr inbounds i32, i32* %C, i32 %add
  store i32 %mul5, i32* %arrayidx8, align 4
  %inc = add nuw nsw i32 %j.024, 1
  %exitcond = icmp eq i32 %inc, %N
  br i1 %exitcond, label %for.cond.cleanup3, label %for.body4

for.cond.cleanup3:
  %inc10 = add nuw nsw i32 %i.026, 1
  %exitcond27 = icmp eq i32 %inc10, %N
  br i1 %exitcond27, label %for.cond.cleanup, label %for.body4.lr.ph

for.cond.cleanup:
  ret void
}

; Outer IV used directly
define hidden void @test_3(i16 zeroext %N, i32* nocapture %C, i32* nocapture readonly %A, i32 %scale) {
entry:
  %conv = zext i16 %N to i32
  %cmp25 = icmp eq i16 %N, 0
  br i1 %cmp25, label %for.cond.cleanup, label %for.body.lr.ph.split.us

for.body.lr.ph.split.us:                          ; preds = %entry
  br label %for.body.us

for.body.us:                                      ; preds = %for.cond2.for.cond.cleanup6_crit_edge.us, %for.body.lr.ph.split.us
  %i.026.us = phi i32 [ 0, %for.body.lr.ph.split.us ], [ %inc12.us, %for.cond2.for.cond.cleanup6_crit_edge.us ]
  %arrayidx.us = getelementptr inbounds i32, i32* %A, i32 %i.026.us
  %mul9.us = mul nuw nsw i32 %i.026.us, %conv
  br label %for.body7.us

for.body7.us:                                     ; preds = %for.body.us, %for.body7.us
  %j.024.us = phi i32 [ 0, %for.body.us ], [ %inc.us, %for.body7.us ]
  %0 = load i32, i32* %arrayidx.us, align 4
  %mul.us = mul nsw i32 %0, %scale
  %add.us = add nuw nsw i32 %j.024.us, %mul9.us
  %arrayidx10.us = getelementptr inbounds i32, i32* %C, i32 %add.us
  store i32 %mul.us, i32* %arrayidx10.us, align 4
  %inc.us = add nuw nsw i32 %j.024.us, 1
  %exitcond = icmp ne i32 %inc.us, %conv
  br i1 %exitcond, label %for.body7.us, label %for.cond2.for.cond.cleanup6_crit_edge.us

for.cond2.for.cond.cleanup6_crit_edge.us:         ; preds = %for.body7.us
  %inc12.us = add nuw nsw i32 %i.026.us, 1
  %exitcond27 = icmp ne i32 %inc12.us, %conv
  br i1 %exitcond27, label %for.body.us, label %for.cond.cleanup.loopexit

for.cond.cleanup.loopexit:                        ; preds = %for.cond2.for.cond.cleanup6_crit_edge.us
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  ret void
}

; Inner IV used directly
define hidden void @test_4(i16 zeroext %N, i32* nocapture %C, i32* nocapture readonly %A, i32 %scale) {
entry:
  %conv = zext i16 %N to i32
  %cmp25 = icmp eq i16 %N, 0
  br i1 %cmp25, label %for.cond.cleanup, label %for.body.lr.ph.split.us

for.body.lr.ph.split.us:                          ; preds = %entry
  br label %for.body.us

for.body.us:                                      ; preds = %for.cond2.for.cond.cleanup6_crit_edge.us, %for.body.lr.ph.split.us
  %i.026.us = phi i32 [ 0, %for.body.lr.ph.split.us ], [ %inc12.us, %for.cond2.for.cond.cleanup6_crit_edge.us ]
  %mul9.us = mul nuw nsw i32 %i.026.us, %conv
  br label %for.body7.us

for.body7.us:                                     ; preds = %for.body.us, %for.body7.us
  %j.024.us = phi i32 [ 0, %for.body.us ], [ %inc.us, %for.body7.us ]
  %arrayidx.us = getelementptr inbounds i32, i32* %A, i32 %j.024.us
  %0 = load i32, i32* %arrayidx.us, align 4
  %mul.us = mul nsw i32 %0, %scale
  %add.us = add nuw nsw i32 %j.024.us, %mul9.us
  %arrayidx10.us = getelementptr inbounds i32, i32* %C, i32 %add.us
  store i32 %mul.us, i32* %arrayidx10.us, align 4
  %inc.us = add nuw nsw i32 %j.024.us, 1
  %exitcond = icmp ne i32 %inc.us, %conv
  br i1 %exitcond, label %for.body7.us, label %for.cond2.for.cond.cleanup6_crit_edge.us

for.cond2.for.cond.cleanup6_crit_edge.us:         ; preds = %for.body7.us
  %inc12.us = add nuw nsw i32 %i.026.us, 1
  %exitcond27 = icmp ne i32 %inc12.us, %conv
  br i1 %exitcond27, label %for.body.us, label %for.cond.cleanup.loopexit

for.cond.cleanup.loopexit:                        ; preds = %for.cond2.for.cond.cleanup6_crit_edge.us
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  ret void
}

; Inner iteration count not invariant in outer loop
declare i32 @get_int() readonly
define void @test_5(i16 zeroext %N, i32* nocapture %C, i32* nocapture readonly %A, i32 %scale) {
entry:
  %conv = zext i16 %N to i32
  %cmp27 = icmp eq i16 %N, 0
  br i1 %cmp27, label %for.cond.cleanup, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  br label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.cond.cleanup5
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  ret void

for.body:                                         ; preds = %for.body.lr.ph, %for.cond.cleanup5
  %i.028 = phi i32 [ 0, %for.body.lr.ph ], [ %inc12, %for.cond.cleanup5 ]
  %call = tail call i32 @get_int()
  %cmp325 = icmp sgt i32 %call, 0
  br i1 %cmp325, label %for.body6.lr.ph, label %for.cond.cleanup5

for.body6.lr.ph:                                  ; preds = %for.body
  %mul = mul nsw i32 %call, %i.028
  br label %for.body6

for.cond.cleanup5.loopexit:                       ; preds = %for.body6
  br label %for.cond.cleanup5

for.cond.cleanup5:                                ; preds = %for.cond.cleanup5.loopexit, %for.body
  %inc12 = add nuw nsw i32 %i.028, 1
  %exitcond29 = icmp ne i32 %inc12, %conv
  br i1 %exitcond29, label %for.body, label %for.cond.cleanup.loopexit

for.body6:                                        ; preds = %for.body6.lr.ph, %for.body6
  %j.026 = phi i32 [ 0, %for.body6.lr.ph ], [ %inc, %for.body6 ]
  %add = add nsw i32 %j.026, %mul
  %arrayidx = getelementptr inbounds i32, i32* %A, i32 %add
  %0 = load i32, i32* %arrayidx, align 4
  %mul7 = mul nsw i32 %0, %scale
  %arrayidx10 = getelementptr inbounds i32, i32* %C, i32 %add
  store i32 %mul7, i32* %arrayidx10, align 4
  %inc = add nuw nsw i32 %j.026, 1
  %exitcond = icmp ne i32 %inc, %call
  br i1 %exitcond, label %for.body6, label %for.cond.cleanup5.loopexit
}

; Inner loop has an early exit
define hidden void @test_6(i16 zeroext %N, i32* nocapture %C, i32* nocapture readonly %A, i32 %scale) {
entry:
  %conv = zext i16 %N to i32
  %cmp39 = icmp eq i16 %N, 0
  br i1 %cmp39, label %for.cond.cleanup, label %for.body.us.preheader

for.body.us.preheader:                            ; preds = %entry
  br label %for.body.us

for.body.us:                                      ; preds = %for.body.us.preheader, %cleanup.us
  %i.040.us = phi i32 [ %inc19.us, %cleanup.us ], [ 0, %for.body.us.preheader ]
  %mul.us = mul nuw nsw i32 %i.040.us, %conv
  br label %for.body7.us

for.body7.us:                                     ; preds = %for.body.us, %if.end.us
  %j.038.us = phi i32 [ 0, %for.body.us ], [ %inc.us, %if.end.us ]
  %add.us = add nuw nsw i32 %j.038.us, %mul.us
  %arrayidx.us = getelementptr inbounds i32, i32* %A, i32 %add.us
  %0 = load i32, i32* %arrayidx.us, align 4
  %tobool.us = icmp eq i32 %0, 0
  br i1 %tobool.us, label %if.end.us, label %cleanup.us

cleanup.us:                                       ; preds = %if.end.us, %for.body7.us
  %inc19.us = add nuw nsw i32 %i.040.us, 1
  %exitcond = icmp eq i32 %inc19.us, %conv
  br i1 %exitcond, label %for.cond.cleanup, label %for.body.us

if.end.us:                                        ; preds = %for.body7.us
  %arrayidx17.us = getelementptr inbounds i32, i32* %C, i32 %add.us
  store i32 0, i32* %arrayidx17.us, align 4
  %inc.us = add nuw nsw i32 %j.038.us, 1
  %cmp4.us = icmp ult i32 %inc.us, %conv
  br i1 %cmp4.us, label %for.body7.us, label %cleanup.us

for.cond.cleanup:                                 ; preds = %cleanup.us, %entry
  ret void
}

define hidden void @test_7(i16 zeroext %N, i32* nocapture %C, i32* nocapture readonly %A, i32 %scale) {
entry:
  %conv = zext i16 %N to i32
  %cmp30 = icmp eq i16 %N, 0
  br i1 %cmp30, label %cleanup, label %for.body.us.preheader

for.body.us.preheader:                            ; preds = %entry
  br label %for.body.us

for.body.us:                                      ; preds = %for.body.us.preheader, %for.cond2.for.cond.cleanup6_crit_edge.us
  %i.031.us = phi i32 [ %inc15.us, %for.cond2.for.cond.cleanup6_crit_edge.us ], [ 0, %for.body.us.preheader ]
  %call.us = tail call i32 @get_int() #2
  %tobool.us = icmp eq i32 %call.us, 0
  br i1 %tobool.us, label %for.body7.lr.ph.us, label %cleanup

for.body7.us:                                     ; preds = %for.body7.us, %for.body7.lr.ph.us
  %j.029.us = phi i32 [ 0, %for.body7.lr.ph.us ], [ %inc.us, %for.body7.us ]
  %add.us = add nuw nsw i32 %j.029.us, %mul.us
  %arrayidx.us = getelementptr inbounds i32, i32* %A, i32 %add.us
  %0 = load i32, i32* %arrayidx.us, align 4
  %mul9.us = mul nsw i32 %0, %scale
  %arrayidx13.us = getelementptr inbounds i32, i32* %C, i32 %add.us
  store i32 %mul9.us, i32* %arrayidx13.us, align 4
  %inc.us = add nuw nsw i32 %j.029.us, 1
  %exitcond = icmp eq i32 %inc.us, %conv
  br i1 %exitcond, label %for.cond2.for.cond.cleanup6_crit_edge.us, label %for.body7.us

for.body7.lr.ph.us:                               ; preds = %for.body.us
  %mul.us = mul nuw nsw i32 %i.031.us, %conv
  br label %for.body7.us

for.cond2.for.cond.cleanup6_crit_edge.us:         ; preds = %for.body7.us
  %inc15.us = add nuw nsw i32 %i.031.us, 1
  %cmp.us = icmp ult i32 %inc15.us, %conv
  br i1 %cmp.us, label %for.body.us, label %cleanup

cleanup:                                          ; preds = %for.cond2.for.cond.cleanup6_crit_edge.us, %for.body.us, %entry
  ret void
}

; Step is not 1
define i32 @test_8(i32 %val, i16* nocapture %A) {
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.inc6
  %i.018 = phi i32 [ 0, %entry ], [ %inc7, %for.inc6 ]
  %mul = mul nuw nsw i32 %i.018, 20
  br label %for.body3

for.body3:                                        ; preds = %for.body, %for.body3
  %j.017 = phi i32 [ 0, %for.body ], [ %inc, %for.body3 ]
  %add = add nuw nsw i32 %j.017, %mul
  %arrayidx = getelementptr inbounds i16, i16* %A, i32 %add
  %0 = load i16, i16* %arrayidx, align 2
  %conv16 = zext i16 %0 to i32
  %add4 = add i32 %conv16, %val
  %conv5 = trunc i32 %add4 to i16
  store i16 %conv5, i16* %arrayidx, align 2
  %inc = add nuw nsw i32 %j.017, 1
  %exitcond = icmp ne i32 %inc, 20
  br i1 %exitcond, label %for.body3, label %for.inc6

for.inc6:                                         ; preds = %for.body3
  %inc7 = add nuw nsw i32 %i.018, 2
  %exitcond19 = icmp ne i32 %inc7, 10
  br i1 %exitcond19, label %for.body, label %for.end8

for.end8:                                         ; preds = %for.inc6
  ret i32 10
}


; Step is not 1
define i32 @test_9(i32 %val, i16* nocapture %A) {
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.inc6
  %i.018 = phi i32 [ 0, %entry ], [ %inc7, %for.inc6 ]
  %mul = mul nuw nsw i32 %i.018, 20
  br label %for.body3

for.body3:                                        ; preds = %for.body, %for.body3
  %j.017 = phi i32 [ 0, %for.body ], [ %inc, %for.body3 ]
  %add = add nuw nsw i32 %j.017, %mul
  %arrayidx = getelementptr inbounds i16, i16* %A, i32 %add
  %0 = load i16, i16* %arrayidx, align 2
  %conv16 = zext i16 %0 to i32
  %add4 = add i32 %conv16, %val
  %conv5 = trunc i32 %add4 to i16
  store i16 %conv5, i16* %arrayidx, align 2
  %inc = add nuw nsw i32 %j.017, 2
  %exitcond = icmp ne i32 %inc, 20
  br i1 %exitcond, label %for.body3, label %for.inc6

for.inc6:                                         ; preds = %for.body3
  %inc7 = add nuw nsw i32 %i.018, 1
  %exitcond19 = icmp ne i32 %inc7, 10
  br i1 %exitcond19, label %for.body, label %for.end8

for.end8:                                         ; preds = %for.inc6
  ret i32 10
}


; Outer loop conditional phi
define i32 @e() {
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.end16
  %f.033 = phi i32 [ 0, %entry ], [ %inc18, %for.end16 ]
  %g.032 = phi i32 [ undef, %entry ], [ %g.3.lcssa, %for.end16 ]
  %.pr = add i32 10, 10
  %tobool29 = icmp eq i32 %.pr, 0
  br i1 %tobool29, label %for.end, label %for.body2.lr.ph

for.body2.lr.ph:                                  ; preds = %for.body
  br label %for.cond1.for.end_crit_edge

for.cond1.for.end_crit_edge:                      ; preds = %for.body2.lr.ph
  br label %for.end

for.end:                                          ; preds = %for.cond1.for.end_crit_edge, %for.body
  %g.1.lcssa = phi i32 [ 0, %for.cond1.for.end_crit_edge ], [ %g.032, %for.body ]
  br label %for.body5

for.body5:                                        ; preds = %for.end, %lor.end
  %i.031 = phi i32 [ 0, %for.end ], [ %inc15, %lor.end ]
  %g.230 = phi i32 [ %g.1.lcssa, %for.end ], [ %g.3, %lor.end ]
  %0 = add i32 10, 10
  %1 = add i32 10, 10
  %tobool9 = icmp eq i32 %1, 0
  br i1 %tobool9, label %lor.rhs, label %lor.end

lor.rhs:                                          ; preds = %for.body5
  %2 = add i32 10, 10
  %call11 = add i32 10, 10
  %tobool12 = icmp ne i32 %call11, 0
  br label %lor.end

lor.end:                                          ; preds = %for.body5, %lor.rhs
  %g.3 = phi i32 [ %g.230, %for.body5 ], [ %call11, %lor.rhs ]
  %3 = phi i1 [ true, %for.body5 ], [ %tobool12, %lor.rhs ]
  %lor.ext = zext i1 %3 to i32
  %inc15 = add nuw nsw i32 %i.031, 1
  %exitcond = icmp ne i32 %inc15, 9
  br i1 %exitcond, label %for.body5, label %for.end16

for.end16:                                        ; preds = %lor.end
  %g.3.lcssa = phi i32 [ %g.3, %lor.end ]
  %inc18 = add nuw nsw i32 %f.033, 1
  %exitcond34 = icmp ne i32 %inc18, 7
  br i1 %exitcond34, label %for.body, label %for.end19

for.end19:                                        ; preds = %for.end16
  ret i32 undef
}

; A 3d loop corresponding to:
;
; for (int i = 0; i < N; ++i)
;    for (int j = 0; j < N; ++j)
;      for (int k = 0; k < N; ++k)
;        f(&A[i + N * (j + N * k)]);
;
define void @d3_1(i32* %A, i32 %N) {
entry:
  %cmp35 = icmp sgt i32 %N, 0
  br i1 %cmp35, label %for.cond1.preheader.lr.ph, label %for.cond.cleanup

for.cond1.preheader.lr.ph:
  br label %for.cond1.preheader.us

for.cond1.preheader.us:
  %i.036.us = phi i32 [ 0, %for.cond1.preheader.lr.ph ], [ %inc15.us, %for.cond1.for.cond.cleanup3_crit_edge.us ]
  br i1 true, label %for.cond5.preheader.us.us.preheader, label %for.cond5.preheader.us52.preheader

for.cond5.preheader.us52.preheader:
  br label %for.cond5.preheader.us52

for.cond5.preheader.us.us.preheader:
  br label %for.cond5.preheader.us.us

for.cond5.preheader.us52:
  br i1 false, label %for.cond5.preheader.us52, label %for.cond1.for.cond.cleanup3_crit_edge.us.loopexit58

for.cond1.for.cond.cleanup3_crit_edge.us.loopexit:
  br label %for.cond1.for.cond.cleanup3_crit_edge.us

for.cond1.for.cond.cleanup3_crit_edge.us.loopexit58:
  br label %for.cond1.for.cond.cleanup3_crit_edge.us

for.cond1.for.cond.cleanup3_crit_edge.us:
  %inc15.us = add nuw nsw i32 %i.036.us, 1
  %cmp.us = icmp slt i32 %inc15.us, %N
  br i1 %cmp.us, label %for.cond1.preheader.us, label %for.cond.cleanup.loopexit

for.cond5.preheader.us.us:
  %j.033.us.us = phi i32 [ %inc12.us.us, %for.cond5.for.cond.cleanup7_crit_edge.us.us ], [ 0, %for.cond5.preheader.us.us.preheader ]
  br label %for.body8.us.us

for.cond5.for.cond.cleanup7_crit_edge.us.us:
  %inc12.us.us = add nuw nsw i32 %j.033.us.us, 1
  %cmp2.us.us = icmp slt i32 %inc12.us.us, %N
  br i1 %cmp2.us.us, label %for.cond5.preheader.us.us, label %for.cond1.for.cond.cleanup3_crit_edge.us.loopexit

for.body8.us.us:
  %k.031.us.us = phi i32 [ 0, %for.cond5.preheader.us.us ], [ %inc.us.us, %for.body8.us.us ]
  %mul.us.us = mul nsw i32 %k.031.us.us, %N
  %add.us.us = add nsw i32 %mul.us.us, %j.033.us.us
  %mul9.us.us = mul nsw i32 %add.us.us, %N
  %add10.us.us = add nsw i32 %mul9.us.us, %i.036.us
  %idxprom.us.us = sext i32 %add10.us.us to i64
  %arrayidx.us.us = getelementptr inbounds i32, i32* %A, i64 %idxprom.us.us
  tail call void @f(i32* %arrayidx.us.us) #2
  %inc.us.us = add nuw nsw i32 %k.031.us.us, 1
  %cmp6.us.us = icmp slt i32 %inc.us.us, %N
  br i1 %cmp6.us.us, label %for.body8.us.us, label %for.cond5.for.cond.cleanup7_crit_edge.us.us

for.cond.cleanup.loopexit:
  br label %for.cond.cleanup

for.cond.cleanup:
  ret void
}

; A 3d loop corresponding to:
;
;   for (int k = 0; k < N; ++k)
;    for (int i = 0; i < N; ++i)
;      for (int j = 0; j < M; ++j)
;        f(&A[i*M+j]);
;
; This could be supported, but isn't at the moment.
;
define void @d3_2(i32* %A, i32 %N, i32 %M) {
entry:
  %cmp30 = icmp sgt i32 %N, 0
  br i1 %cmp30, label %for.cond1.preheader.lr.ph, label %for.cond.cleanup

for.cond1.preheader.lr.ph:
  %cmp625 = icmp sgt i32 %M, 0
  br label %for.cond1.preheader.us

for.cond1.preheader.us:
  %k.031.us = phi i32 [ 0, %for.cond1.preheader.lr.ph ], [ %inc13.us, %for.cond1.for.cond.cleanup3_crit_edge.us ]
  br i1 %cmp625, label %for.cond5.preheader.us.us.preheader, label %for.cond5.preheader.us43.preheader

for.cond5.preheader.us43.preheader:
  br label %for.cond1.for.cond.cleanup3_crit_edge.us.loopexit50

for.cond5.preheader.us.us.preheader:
  br label %for.cond5.preheader.us.us

for.cond1.for.cond.cleanup3_crit_edge.us.loopexit:
  br label %for.cond1.for.cond.cleanup3_crit_edge.us

for.cond1.for.cond.cleanup3_crit_edge.us.loopexit50:
  br label %for.cond1.for.cond.cleanup3_crit_edge.us

for.cond1.for.cond.cleanup3_crit_edge.us:
  %inc13.us = add nuw nsw i32 %k.031.us, 1
  %exitcond52 = icmp ne i32 %inc13.us, %N
  br i1 %exitcond52, label %for.cond1.preheader.us, label %for.cond.cleanup.loopexit

for.cond5.preheader.us.us:
  %i.028.us.us = phi i32 [ %inc10.us.us, %for.cond5.for.cond.cleanup7_crit_edge.us.us ], [ 0, %for.cond5.preheader.us.us.preheader ]
  %mul.us.us = mul nsw i32 %i.028.us.us, %M
  br label %for.body8.us.us

for.cond5.for.cond.cleanup7_crit_edge.us.us:
  %inc10.us.us = add nuw nsw i32 %i.028.us.us, 1
  %exitcond51 = icmp ne i32 %inc10.us.us, %N
  br i1 %exitcond51, label %for.cond5.preheader.us.us, label %for.cond1.for.cond.cleanup3_crit_edge.us.loopexit

for.body8.us.us:
  %j.026.us.us = phi i32 [ 0, %for.cond5.preheader.us.us ], [ %inc.us.us, %for.body8.us.us ]
  %add.us.us = add nsw i32 %j.026.us.us, %mul.us.us
  %idxprom.us.us = sext i32 %add.us.us to i64
  %arrayidx.us.us = getelementptr inbounds i32, i32* %A, i64 %idxprom.us.us
  tail call void @f(i32* %arrayidx.us.us) #2
  %inc.us.us = add nuw nsw i32 %j.026.us.us, 1
  %exitcond = icmp ne i32 %inc.us.us, %M
  br i1 %exitcond, label %for.body8.us.us, label %for.cond5.for.cond.cleanup7_crit_edge.us.us

for.cond.cleanup.loopexit:
  br label %for.cond.cleanup

for.cond.cleanup:
  ret void
}

; A 3d loop corresponding to:
;
;   for (int i = 0; i < N; ++i)
;     for (int j = 0; j < M; ++j) {
;       A[i*M+j] = 0;
;       for (int k = 0; k < N; ++k)
;         g();
;     }
;
define void @d3_3(i32* nocapture %A, i32 %N, i32 %M) {
entry:
  %cmp29 = icmp sgt i32 %N, 0
  br i1 %cmp29, label %for.cond1.preheader.lr.ph, label %for.cond.cleanup

for.cond1.preheader.lr.ph:
  %cmp227 = icmp sgt i32 %M, 0
  br i1 %cmp227, label %for.cond1.preheader.us.preheader, label %for.cond1.preheader.preheader

for.cond1.preheader.preheader:
  br label %for.cond.cleanup.loopexit49

for.cond1.preheader.us.preheader:
  br label %for.cond1.preheader.us

for.cond1.preheader.us:
  %i.030.us = phi i32 [ %inc13.us, %for.cond1.for.cond.cleanup3_crit_edge.us ], [ 0, %for.cond1.preheader.us.preheader ]
  %mul.us = mul nsw i32 %i.030.us, %M
  br i1 true, label %for.body4.us.us.preheader, label %for.body4.us32.preheader

for.body4.us32.preheader:
  br label %for.cond1.for.cond.cleanup3_crit_edge.us.loopexit48

for.body4.us.us.preheader:
  br label %for.body4.us.us

for.cond1.for.cond.cleanup3_crit_edge.us.loopexit:
  br label %for.cond1.for.cond.cleanup3_crit_edge.us

for.cond1.for.cond.cleanup3_crit_edge.us.loopexit48:
  br label %for.cond1.for.cond.cleanup3_crit_edge.us

for.cond1.for.cond.cleanup3_crit_edge.us:
  %inc13.us = add nuw nsw i32 %i.030.us, 1
  %exitcond51 = icmp ne i32 %inc13.us, %N
  br i1 %exitcond51, label %for.cond1.preheader.us, label %for.cond.cleanup.loopexit

for.body4.us.us:
  %j.028.us.us = phi i32 [ %inc10.us.us, %for.cond5.for.cond.cleanup7_crit_edge.us.us ], [ 0, %for.body4.us.us.preheader ]
  %add.us.us = add nsw i32 %j.028.us.us, %mul.us
  %idxprom.us.us = sext i32 %add.us.us to i64
  %arrayidx.us.us = getelementptr inbounds i32, i32* %A, i64 %idxprom.us.us
  store i32 0, i32* %arrayidx.us.us, align 4
  br label %for.body8.us.us

for.cond5.for.cond.cleanup7_crit_edge.us.us:
  %inc10.us.us = add nuw nsw i32 %j.028.us.us, 1
  %exitcond50 = icmp ne i32 %inc10.us.us, %M
  br i1 %exitcond50, label %for.body4.us.us, label %for.cond1.for.cond.cleanup3_crit_edge.us.loopexit

for.body8.us.us:
  %k.026.us.us = phi i32 [ 0, %for.body4.us.us ], [ %inc.us.us, %for.body8.us.us ]
  tail call void bitcast (void (...)* @g to void ()*)() #2
  %inc.us.us = add nuw nsw i32 %k.026.us.us, 1
  %exitcond = icmp ne i32 %inc.us.us, %N
  br i1 %exitcond, label %for.body8.us.us, label %for.cond5.for.cond.cleanup7_crit_edge.us.us

for.cond.cleanup.loopexit:
  br label %for.cond.cleanup

for.cond.cleanup.loopexit49:
  br label %for.cond.cleanup

for.cond.cleanup:
  ret void
}

declare dso_local void @f(i32*)
declare dso_local void @g(...)
