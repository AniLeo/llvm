; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loops -basic-aa -gvn -enable-split-backedge-in-load-pre -S | FileCheck %s

define dso_local void @test1(i32* nocapture readonly %aa, i32* nocapture %bb) local_unnamed_addr {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IDX:%.*]] = getelementptr inbounds i32, i32* [[BB:%.*]], i64 1
; CHECK-NEXT:    [[IDX2:%.*]] = getelementptr inbounds i32, i32* [[AA:%.*]], i64 1
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[IDX2]], align 4
; CHECK-NEXT:    store i32 [[TMP0]], i32* [[IDX]], align 4
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i32 [ [[TMP0]], [[ENTRY:%.*]] ], [ [[DOTPRE:%.*]], [[FOR_BODY_FOR_BODY_CRIT_EDGE:%.*]] ]
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[ENTRY]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY_FOR_BODY_CRIT_EDGE]] ]
; CHECK-NEXT:    [[IDX4:%.*]] = getelementptr inbounds i32, i32* [[AA]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[IDX4]], align 4, !llvm.access.group !0
; CHECK-NEXT:    [[MUL:%.*]] = mul nsw i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    store i32 [[MUL]], i32* [[IDX4]], align 4, !llvm.access.group !0
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], 100
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY_FOR_BODY_CRIT_EDGE]], label [[FOR_END:%.*]]
; CHECK:       for.body.for.body_crit_edge:
; CHECK-NEXT:    [[DOTPRE]] = load i32, i32* [[IDX]], align 4, !llvm.access.group !0
; CHECK-NEXT:    br label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %idx = getelementptr inbounds i32, i32* %bb, i64 1
  %idx2 = getelementptr inbounds i32, i32* %aa, i64 1
  %0 = load i32, i32* %idx2, align 4
  store i32 %0, i32* %idx, align 4
  br label %for.body

for.body:
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %idx4 = getelementptr inbounds i32, i32* %aa, i64 %indvars.iv
  %1 = load i32, i32* %idx4, align 4, !llvm.access.group !0
  %2 = load i32, i32* %idx, align 4, !llvm.access.group !0
  %mul = mul nsw i32 %2, %1
  store i32 %mul, i32* %idx4, align 4, !llvm.access.group !0
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp ne i64 %indvars.iv.next, 100
  br i1 %exitcond, label %for.body, label %for.end

for.end:
  ret void
}

!0 = distinct !{}

define dso_local void @test2(i32* nocapture readonly %aa, i32* nocapture %bb) local_unnamed_addr {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IDX:%.*]] = getelementptr inbounds i32, i32* [[BB:%.*]], i64 1
; CHECK-NEXT:    [[IDX2:%.*]] = getelementptr inbounds i32, i32* [[AA:%.*]], i64 1
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[IDX2]], align 4
; CHECK-NEXT:    store i32 [[TMP0]], i32* [[IDX]], align 4
; CHECK-NEXT:    [[DOTPRE:%.*]] = load i32, i32* [[AA]], align 4
; CHECK-NEXT:    br label [[FOR_BODY2:%.*]]
; CHECK:       for.body2:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i32 [ [[TMP0]], [[FOR_BODY]] ], [ [[DOTPRE1:%.*]], [[FOR_BODY2_FOR_BODY2_CRIT_EDGE:%.*]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = phi i32 [ [[DOTPRE]], [[FOR_BODY]] ], [ [[MUL:%.*]], [[FOR_BODY2_FOR_BODY2_CRIT_EDGE]] ]
; CHECK-NEXT:    [[INDVARS2_IV:%.*]] = phi i64 [ 0, [[FOR_BODY]] ], [ 1, [[FOR_BODY2_FOR_BODY2_CRIT_EDGE]] ]
; CHECK-NEXT:    [[MUL]] = mul nsw i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    store i32 [[MUL]], i32* [[AA]], align 4, !llvm.access.group !1
; CHECK-NEXT:    br i1 true, label [[FOR_BODY2_FOR_BODY2_CRIT_EDGE]], label [[FOR_END:%.*]]
; CHECK:       for.body2.for.body2_crit_edge:
; CHECK-NEXT:    [[DOTPRE1]] = load i32, i32* [[IDX]], align 4, !llvm.access.group !1
; CHECK-NEXT:    br label [[FOR_BODY2]]
; CHECK:       for.end:
; CHECK-NEXT:    br i1 false, label [[FOR_END_FOR_BODY_CRIT_EDGE:%.*]], label [[END:%.*]]
; CHECK:       for.end.for.body_crit_edge:
; CHECK-NEXT:    br label [[FOR_BODY]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.end ]
  %idx = getelementptr inbounds i32, i32* %bb, i64 1
  %idx2 = getelementptr inbounds i32, i32* %aa, i64 1
  %0 = load i32, i32* %idx2, align 4
  store i32 %0, i32* %idx, align 4
  br label %for.body2

for.body2:
  %indvars2.iv = phi i64 [ 0, %for.body ], [ %indvars2.iv.next, %for.body2 ]
  %idx4 = getelementptr inbounds i32, i32* %aa, i64 %indvars.iv
  %1 = load i32, i32* %idx4, align 4, !llvm.access.group !1
  %2 = load i32, i32* %idx, align 4, !llvm.access.group !1
  %mul = mul nsw i32 %2, %1
  store i32 %mul, i32* %idx4, align 4, !llvm.access.group !1
  %indvars2.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond2 = icmp ne i64 %indvars2.iv.next, 100
  br i1 %exitcond2, label %for.body2, label %for.end

for.end:
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp ne i64 %indvars.iv.next, 100
  br i1 %exitcond, label %for.body, label %end

end:
  ret void
}

!1 = distinct !{}
