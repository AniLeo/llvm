; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes="loop-idiom" < %s -S | FileCheck %s


define dso_local void @double_memset(i8* nocapture %p) {
; CHECK-LABEL: @double_memset(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[P:%.*]], i8 0, i64 16, i1 false), !tbaa [[TBAA0:![0-9]+]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_07:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, %entry ]
; CHECK-NEXT:    [[INCDEC_PTR1:.+]] = getelementptr inbounds i8, i8* [[P]], i64 [[I_07]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_07]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 16
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[FOR_BODY]]
;
entry:
  br label %for.body

for.cond.cleanup:
  ret void

for.body:
  %i.07 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %ptr1 = getelementptr inbounds i8, i8* %p, i64 %i.07
  store i8 0, i8* %ptr1, align 1, !tbaa !5
  %inc = add nuw nsw i64 %i.07, 1
  %exitcond.not = icmp eq i64 %inc, 16
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}


define dso_local void @struct_memset(i8* nocapture %p) {
; CHECK-LABEL: @struct_memset(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[P:%.*]], i8 0, i64 16, i1 false), !tbaa [[TBAA8:![0-9]+]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_07:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, %entry ]
; CHECK-NEXT:    [[INCDEC_PTR1:.+]] = getelementptr inbounds i8, i8* [[P]], i64 [[I_07]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_07]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 16
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[FOR_BODY]]
;
entry:
  br label %for.body

for.cond.cleanup:
  ret void

for.body:
  %i.07 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %ptr1 = getelementptr inbounds i8, i8* %p, i64 %i.07
  store i8 0, i8* %ptr1, align 1, !tbaa !10
  %inc = add nuw nsw i64 %i.07, 1
  %exitcond.not = icmp eq i64 %inc, 16
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

define dso_local void @var_memset(i8* nocapture %p, i64 %len) {
; CHECK-LABEL: @var_memset(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[P:%.*]], i8 0, i64 %len, i1 false)
; CHECK-NOT:     !tbaa
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_07:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, %entry ]
; CHECK-NEXT:    [[INCDEC_PTR1:.+]] = getelementptr inbounds i8, i8* [[P]], i64 [[I_07]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_07]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], %len
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[FOR_BODY]]
;
entry:
  br label %for.body

for.cond.cleanup:
  ret void

for.body:
  %i.07 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %ptr1 = getelementptr inbounds i8, i8* %p, i64 %i.07
  store i8 0, i8* %ptr1, align 1, !tbaa !10
  %inc = add nuw nsw i64 %i.07, 1
  %exitcond.not = icmp eq i64 %inc, %len
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

; CHECK: [[TBAA0]] = !{[[TBAA1:.+]], [[TBAA1]], i64 0}
; CHECK: [[TBAA1]] = !{!"double", [[TBAA2:.+]], i64 0}
; CHECK: [[TBAA2]] = !{!"omnipotent char", [[TBAA3:.+]], i64 0}

; CHECK: [[TBAA8]] = !{[[TBAA5:.+]], [[TBAA6:.+]], i64 0, i64 16}
; CHECK: [[TBAA5]] = !{[[TBAA7:.+]], i64 32, !"_ZTS1A", [[TBAA6]], i64 0, i64 8, [[TBAA6]], i64 8, i64 8, [[TBAA6]], i64 16, i64 8, [[TBAA6]], i64 24, i64 8}
; CHECK: [[TBAA7]] = !{[[TBAA3]], i64 0, !"omnipotent char"}
; CHECK: [[TBAA6]] = !{[[TBAA7]], i64 8, !"double"}

!5 = !{!6, !6, i64 0}
!6 = !{!"double", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}

!15 = !{!8, i64 0, !"omnipotent char"}
!17 = !{!15, i64 8, !"double"}
!9 = !{!15, i64 32, !"_ZTS1A", !17, i64 0, i64 8, !17, i64 8, i64 8, !17, i64 16, i64 8, !17, i64 24, i64 8}
!10 = !{!9, !17, i64 0, i64 1}
