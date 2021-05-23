; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -simplifycfg < %s | FileCheck %s
;
; The branch in the latch do.cond is conditional by a constant and the
; conditional branch replaced by an unconditional one.
; Ensure that the llvm.loop metadata is transferred to the new branch
; (In for.cond.cleanup after further simplifications).
;
; llvm.org/PR50060
;

@n = dso_local global i32 0, align 4
@C = dso_local global i32 0, align 4

; Function Attrs: nounwind
define dso_local void @_Z6test01v() addrspace(1) #0 {
; CHECK-LABEL: @_Z6test01v(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[J:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[I:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br label [[DO_BODY:%.*]]
; CHECK:       do.body:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @C, align 4, !tbaa [[TBAA2:![0-9]+]]
; CHECK-NEXT:    [[INC:%.*]] = add nsw i32 [[TMP0]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[J]] to i8*
; CHECK-NEXT:    call addrspace(1) void @llvm.lifetime.start.p0i8(i64 4, i8* [[TMP1]]) #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    store i32 0, i32* [[J]], align 4, !tbaa [[TBAA2]]
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[J]], align 4, !tbaa [[TBAA2]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP2]], 3
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[J]] to i8*
; CHECK-NEXT:    call addrspace(1) void @llvm.lifetime.end.p0i8(i64 4, i8* [[TMP3]]) #[[ATTR2]]
; CHECK-NEXT:    br label [[DO_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       for.body:
; CHECK-NEXT:    store i32 undef, i32* [[I]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[I]] to i8*
; CHECK-NEXT:    call addrspace(1) void @llvm.lifetime.start.p0i8(i64 4, i8* [[TMP4]]) #[[ATTR2]]
; CHECK-NEXT:    store i32 0, i32* [[I]], align 4, !tbaa [[TBAA2]]
; CHECK-NEXT:    br label [[FOR_COND1:%.*]]
; CHECK:       for.cond1:
; CHECK-NEXT:    [[TMP5:%.*]] = load i32, i32* [[I]], align 4, !tbaa [[TBAA2]]
; CHECK-NEXT:    [[TMP6:%.*]] = load i32, i32* @n, align 4, !tbaa [[TBAA2]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_BODY4:%.*]], label [[FOR_COND_CLEANUP3:%.*]]
; CHECK:       for.cond.cleanup3:
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i32* [[I]] to i8*
; CHECK-NEXT:    call addrspace(1) void @llvm.lifetime.end.p0i8(i64 4, i8* [[TMP7]]) #[[ATTR2]]
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[J]], align 4, !tbaa [[TBAA2]]
; CHECK-NEXT:    [[INC7:%.*]] = add nsw i32 [[TMP8]], 1
; CHECK-NEXT:    store i32 [[INC7]], i32* [[J]], align 4, !tbaa [[TBAA2]]
; CHECK-NEXT:    br label [[FOR_COND]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       for.body4:
; CHECK-NEXT:    [[TMP9:%.*]] = load i32, i32* [[I]], align 4, !tbaa [[TBAA2]]
; CHECK-NEXT:    store volatile i32 [[TMP9]], i32* @C, align 4, !tbaa [[TBAA2]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, i32* [[I]], align 4, !tbaa [[TBAA2]]
; CHECK-NEXT:    [[INC5:%.*]] = add nsw i32 [[TMP10]], 1
; CHECK-NEXT:    store i32 [[INC5]], i32* [[I]], align 4, !tbaa [[TBAA2]]
; CHECK-NEXT:    br label [[FOR_COND1]], !llvm.loop [[LOOP11:![0-9]+]]
;
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  br label %do.body

do.body:                                          ; preds = %do.cond, %entry
  %0 = load i32, i32* @C, align 4, !tbaa !2
  %inc = add nsw i32 %0, 1
  %1 = bitcast i32* %j to i8*
  call addrspace(1) void @llvm.lifetime.start.p0i8(i64 4, i8* %1) #2
  store i32 0, i32* %j, align 4, !tbaa !2
  br label %for.cond

for.cond:                                         ; preds = %for.inc6, %do.body
  %2 = load i32, i32* %j, align 4, !tbaa !2
  %cmp = icmp slt i32 %2, 3
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  %3 = bitcast i32* %j to i8*
  call addrspace(1) void @llvm.lifetime.end.p0i8(i64 4, i8* %3) #2
  br label %for.end8

for.body:                                         ; preds = %for.cond
  store i32 undef, i32* %i, align 4
  %4 = bitcast i32* %i to i8*
  call addrspace(1) void @llvm.lifetime.start.p0i8(i64 4, i8* %4) #2
  store i32 0, i32* %i, align 4, !tbaa !2
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %5 = load i32, i32* %i, align 4, !tbaa !2
  %6 = load i32, i32* @n, align 4, !tbaa !2
  %cmp2 = icmp slt i32 %5, %6
  br i1 %cmp2, label %for.body4, label %for.cond.cleanup3

for.cond.cleanup3:                                ; preds = %for.cond1
  %7 = bitcast i32* %i to i8*
  call addrspace(1) void @llvm.lifetime.end.p0i8(i64 4, i8* %7) #2
  br label %for.end

for.body4:                                        ; preds = %for.cond1
  %8 = load i32, i32* %i, align 4, !tbaa !2
  store volatile i32 %8, i32* @C, align 4, !tbaa !2
  br label %for.inc

for.inc:                                          ; preds = %for.body4
  %9 = load i32, i32* %i, align 4, !tbaa !2
  %inc5 = add nsw i32 %9, 1
  store i32 %inc5, i32* %i, align 4, !tbaa !2
  br label %for.cond1, !llvm.loop !6

for.end:                                          ; preds = %for.cond.cleanup3
  br label %for.inc6

for.inc6:                                         ; preds = %for.end
  %10 = load i32, i32* %j, align 4, !tbaa !2
  %inc7 = add nsw i32 %10, 1
  store i32 %inc7, i32* %j, align 4, !tbaa !2
  br label %for.cond, !llvm.loop !8

for.end8:                                         ; preds = %for.cond.cleanup
  br label %do.cond

do.cond:                                          ; preds = %for.end8
  br i1 true, label %do.body, label %do.end, !llvm.loop !10

do.end:                                           ; preds = %do.cond
  ret void
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) addrspace(1) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) addrspace(1) #1

attributes #0 = { nounwind "disable-tail-calls"="false" "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math" "stack-protector-buffer-size"="8" "use-soft-float"="false" }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang)"}
!2 = !{!3, !3, i64 0, i64 4}
!3 = !{!4, i64 4, !"int"}
!4 = !{!5, i64 1, !"omnipotent char"}
!5 = !{!"Simple C++ TBAA"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7, !9}
!9 = !{!"llvm.loop.unroll.disable"}
!10 = distinct !{!10, !11}
!11 = !{!"llvm.loop.unroll.count", i32 2}
