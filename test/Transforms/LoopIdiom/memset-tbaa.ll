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
; CHECK-NEXT:    [[I_07:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[P]], i64 [[I_07]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_07]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 16
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY]]
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
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[P:%.*]], i8 0, i64 16, i1 false), !tbaa [[TBAA4:![0-9]+]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_07:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[P]], i64 [[I_07]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_07]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 16
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY]]
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
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[P:%.*]], i8 0, i64 [[LEN:%.*]], i1 false)
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_07:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[P]], i64 [[I_07]]
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_07]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[LEN]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY]]
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

%struct.A = type { i32*, %struct.B }
%struct.B = type { i32* }

define dso_local void @adjacent_store_memset(%struct.A* nocapture %a, i64 %len) {
; CHECK-LABEL: @adjacent_store_memset(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A1:%.*]] = bitcast %struct.A* [[A:%.*]] to i8*
; CHECK-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[LEN:%.*]], i64 1)
; CHECK-NEXT:    [[TMP0:%.*]] = shl nuw i64 [[UMAX]], 4
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[A1]], i8 0, i64 [[TMP0]], i1 false), !tbaa [[TBAA8:![0-9]+]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[I_09:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[P:%.*]] = getelementptr inbounds [[STRUCT_A:%.*]], %struct.A* [[A]], i64 [[I_09]], i32 0
; CHECK-NEXT:    [[P2:%.*]] = getelementptr inbounds [[STRUCT_A]], %struct.A* [[A]], i64 [[I_09]], i32 1, i32 0
; CHECK-NEXT:    [[INC]] = add i64 [[I_09]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i64 [[INC]], [[LEN]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_COND_CLEANUP:%.*]]
;
entry:
  br label %for.body

for.cond.cleanup:
  ret void

for.body:
  %i.09 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %p = getelementptr inbounds %struct.A, %struct.A* %a, i64 %i.09, i32 0
  store i32* null, i32** %p, align 8, !tbaa !18
  %p2 = getelementptr inbounds %struct.A, %struct.A* %a, i64 %i.09, i32 1, i32 0
  store i32* null, i32** %p2, align 8, !tbaa !21
  %inc = add i64 %i.09, 1
  %cmp = icmp ult i64 %inc, %len
  br i1 %cmp, label %for.body, label %for.cond.cleanup
}




!5 = !{!6, !6, i64 0}
!6 = !{!"double", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}

!15 = !{!8, i64 0, !"omnipotent char"}
!17 = !{!15, i64 8, !"double"}
!9 = !{!15, i64 32, !"_ZTS1A", !17, i64 0, i64 8, !17, i64 8, i64 8, !17, i64 16, i64 8, !17, i64 24, i64 8}
!10 = !{!9, !17, i64 0, i64 1}

!18 = !{!19, !20, i64 0}
!19 = !{!"A", !20, i64 0, !22, i64 8}
!20 = !{!"any pointer", !7, i64 0}
!21 = !{!22, !20, i64 0}
!22 = !{!"B", !20, i64 0}
