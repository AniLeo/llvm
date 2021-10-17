; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes="loop-idiom" < %s -S | FileCheck %s

define void @looper(double* noalias nocapture readonly %M, double* noalias nocapture %out) {
; CHECK-LABEL: @looper(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OUT1:%.*]] = bitcast double* [[OUT:%.*]] to i8*
; CHECK-NEXT:    [[M2:%.*]] = bitcast double* [[M:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 [[OUT1]], i8* align 8 [[M2]], i64 256, i1 false), !tbaa [[TBAA0:![0-9]+]]
; CHECK-NEXT:    br label [[FOR_BODY4:%.*]]
; CHECK:       for.body4:
; CHECK-NEXT:    [[J_020:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY4]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, double* [[M]], i64 [[J_020]]
; CHECK-NEXT:    [[A0:%.*]] = load double, double* [[ARRAYIDX]], align 8, !tbaa [[TBAA0]]
; CHECK-NEXT:    [[ARRAYIDX8:%.*]] = getelementptr inbounds double, double* [[OUT]], i64 [[J_020]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[J_020]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i64 [[J_020]], 31
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_BODY4]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body4

for.body4:                                        ; preds = %for.cond1.preheader, %for.body4
  %j.020 = phi i64 [ 0, %entry ], [ %inc, %for.body4 ]
  %arrayidx = getelementptr inbounds double, double* %M, i64 %j.020
  %a0 = load double, double* %arrayidx, align 8, !tbaa !5
  %arrayidx8 = getelementptr inbounds double, double* %out, i64 %j.020
  store double %a0, double* %arrayidx8, align 8, !tbaa !5
  %inc = add nuw nsw i64 %j.020, 1
  %cmp2 = icmp ult i64 %j.020, 31
  br i1 %cmp2, label %for.body4, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void
}


define void @looperBadMerge(double* noalias nocapture readonly %M, double* noalias nocapture %out) {
; CHECK-LABEL: @looperBadMerge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OUT1:%.*]] = bitcast double* [[OUT:%.*]] to i8*
; CHECK-NEXT:    [[M2:%.*]] = bitcast double* [[M:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 [[OUT1]], i8* align 8 [[M2]], i64 256, i1 false), !tbaa [[TBAAF:![0-9]+]]
; CHECK-NOT: tbaa
; CHECK-NEXT:    br label [[FOR_BODY4:%.*]]
; CHECK:       for.body4:
; CHECK-NEXT:    [[J_020:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY4]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, double* [[M]], i64 [[J_020]]
; CHECK-NEXT:    [[A0:%.*]] = load double, double* [[ARRAYIDX]], align 8, !tbaa [[TBAA0]]
; CHECK-NEXT:    [[ARRAYIDX8:%.*]] = getelementptr inbounds double, double* [[OUT]], i64 [[J_020]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[J_020]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i64 [[J_020]], 31
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_BODY4]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body4

for.body4:                                        ; preds = %for.cond1.preheader, %for.body4
  %j.020 = phi i64 [ 0, %entry ], [ %inc, %for.body4 ]
  %arrayidx = getelementptr inbounds double, double* %M, i64 %j.020
  %a0 = load double, double* %arrayidx, align 8, !tbaa !5
  %arrayidx8 = getelementptr inbounds double, double* %out, i64 %j.020
  store double %a0, double* %arrayidx8, align 8, !tbaa !3
  %inc = add nuw nsw i64 %j.020, 1
  %cmp2 = icmp ult i64 %j.020, 31
  br i1 %cmp2, label %for.body4, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void
}

define void @looperGoodMerge(double* noalias nocapture readonly %M, double* noalias nocapture %out) {
; CHECK-LABEL: @looperGoodMerge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OUT1:%.*]] = bitcast double* [[OUT:%.*]] to i8*
; CHECK-NEXT:    [[M2:%.*]] = bitcast double* [[M:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 [[OUT1]], i8* align 8 [[M2]], i64 256, i1 false)
; CHECK-NOT:     !tbaa
; CHECK-NEXT:    br label [[FOR_BODY4:%.*]]
; CHECK:       for.body4:
; CHECK-NEXT:    [[J_020:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY4]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, double* [[M]], i64 [[J_020]]
; CHECK-NEXT:    [[A0:%.*]] = load double, double* [[ARRAYIDX]], align 8, !tbaa [[TBAA0]]
; CHECK-NEXT:    [[ARRAYIDX8:%.*]] = getelementptr inbounds double, double* [[OUT]], i64 [[J_020]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[J_020]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i64 [[J_020]], 31
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_BODY4]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body4

for.body4:                                        ; preds = %for.cond1.preheader, %for.body4
  %j.020 = phi i64 [ 0, %entry ], [ %inc, %for.body4 ]
  %arrayidx = getelementptr inbounds double, double* %M, i64 %j.020
  %a0 = load double, double* %arrayidx, align 8, !tbaa !5
  %arrayidx8 = getelementptr inbounds double, double* %out, i64 %j.020
  store double %a0, double* %arrayidx8, align 8
  %inc = add nuw nsw i64 %j.020, 1
  %cmp2 = icmp ult i64 %j.020, 31
  br i1 %cmp2, label %for.body4, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void
}

define void @looperConstantTBAAStruct(double* nocapture noalias %out, double* nocapture noalias %in) {
; CHECK-LABEL: @looperConstantTBAAStruct(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OUT1:%.*]] = bitcast double* [[OUT:%.*]] to i8*
; CHECK-NEXT:    [[IN1:%.*]] = bitcast double* [[IN:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 [[OUT1]], i8* align 8 [[IN1]], i64 32, i1 false), !tbaa [[TBAA8:![0-9]+]]
;
entry:
  br label %for.body4

for.body4:                                        ; preds = %for.cond1.preheader, %for.body4
  %j.020 = phi i64 [ 0, %entry ], [ %inc, %for.body4 ]
  %arrayidx = getelementptr inbounds double, double* %in, i64 %j.020
  %a0 = load double, double* %arrayidx, align 8, !tbaa !10
  %arrayidx8 = getelementptr inbounds double, double* %out, i64 %j.020
  store double %a0, double* %arrayidx8, align 8, !tbaa !10
  %inc = add nuw nsw i64 %j.020, 1
  %cmp2 = icmp ult i64 %j.020, 3
  br i1 %cmp2, label %for.body4, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void
}

define void @looperVarTBAAStruct(double* nocapture noalias %out, double* nocapture noalias %in, i64 %len) {
; CHECK-LABEL: @looperVarTBAAStruct(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OUT1:%.*]] = bitcast double* [[OUT:%.*]] to i8*
; CHECK-NEXT:    [[IN1:%.*]] = bitcast double* [[IN:%.*]] to i8*
; CHECK-NEXT:    [[umax:%.*]] = call i64 @llvm.umax.i64(i64 %len, i64 1)
; CHECK-NEXT:    [[I0:%.*]] = shl nuw i64 [[umax]], 3
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 [[OUT1]], i8* align 8 [[IN1]], i64 [[I0]], i1 false)
; CHECK-NOT: !tbaa
; CHECK-NEXT:    br 
;
entry:
  br label %for.body4

for.body4:                                        ; preds = %for.cond1.preheader, %for.body4
  %j.020 = phi i64 [ 0, %entry ], [ %inc, %for.body4 ]
  %arrayidx = getelementptr inbounds double, double* %in, i64 %j.020
  %a0 = load double, double* %arrayidx, align 8, !tbaa !10
  %arrayidx8 = getelementptr inbounds double, double* %out, i64 %j.020
  store double %a0, double* %arrayidx8, align 8, !tbaa !10
  %inc = add nuw nsw i64 %j.020, 1
  %cmp2 = icmp ult i64 %inc, %len
  br i1 %cmp2, label %for.body4, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void
}


; CHECK: [[TBAA0]] = !{[[TBAA1:.+]], [[TBAA1]], i64 0}
; CHECK: [[TBAA1]] = !{!"double", [[TBAA2:.+]], i64 0}
; CHECK: [[TBAA2]] = !{!"omnipotent char", [[TBAA3:.+]], i64 0}
; CHECK: [[TBAAF]] = !{[[TBAA2]], [[TBAA2]], i64 0}

; CHECK: [[TBAA8]] = !{[[TBAA5:.+]], [[TBAA6:.+]], i64 0, i64 32}
; CHECK: [[TBAA5]] = !{[[TBAA7:.+]], i64 32, !"_ZTS1A", [[TBAA6]], i64 0, i64 8, [[TBAA6]], i64 8, i64 8, [[TBAA6]], i64 16, i64 8, [[TBAA6]], i64 24, i64 8}
; CHECK: [[TBAA7]] = !{[[TBAA3]], i64 0, !"omnipotent char"}
; CHECK: [[TBAA6]] = !{[[TBAA7]], i64 8, !"double"}

!3 = !{!4, !4, i64 0}
!4 = !{!"float", !7, i64 0}
!5 = !{!6, !6, i64 0}
!6 = !{!"double", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}

!15 = !{!8, i64 0, !"omnipotent char"}
!17 = !{!15, i64 8, !"double"}
!9 = !{!15, i64 32, !"_ZTS1A", !17, i64 0, i64 8, !17, i64 8, i64 8, !17, i64 16, i64 8, !17, i64 24, i64 8}
!10 = !{!9, !17, i64 0, i64 8}
