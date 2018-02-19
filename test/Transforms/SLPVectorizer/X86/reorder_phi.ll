; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -slp-vectorizer  -S -mtriple=x86_64-unknown -mcpu=corei7-avx | FileCheck %s

%struct.complex = type { float, float }

define  void @foo (%struct.complex* %A, %struct.complex* %B, %struct.complex* %Result) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 256, 0
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[TMP20:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = phi float [ 0.000000e+00, [[ENTRY]] ], [ [[TMP19:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = phi float [ 0.000000e+00, [[ENTRY]] ], [ [[TMP18:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [[STRUCT_COMPLEX:%.*]], %struct.complex* [[A:%.*]], i64 [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = load float, float* [[TMP4]], align 4
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [[STRUCT_COMPLEX]], %struct.complex* [[A]], i64 [[TMP1]], i32 1
; CHECK-NEXT:    [[TMP7:%.*]] = load float, float* [[TMP6]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds [[STRUCT_COMPLEX]], %struct.complex* [[B:%.*]], i64 [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = load float, float* [[TMP8]], align 4
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds [[STRUCT_COMPLEX]], %struct.complex* [[B]], i64 [[TMP1]], i32 1
; CHECK-NEXT:    [[TMP11:%.*]] = load float, float* [[TMP10]], align 4
; CHECK-NEXT:    [[TMP12:%.*]] = fmul float [[TMP5]], [[TMP9]]
; CHECK-NEXT:    [[TMP13:%.*]] = fmul float [[TMP7]], [[TMP11]]
; CHECK-NEXT:    [[TMP14:%.*]] = fsub float [[TMP12]], [[TMP13]]
; CHECK-NEXT:    [[TMP15:%.*]] = fmul float [[TMP7]], [[TMP9]]
; CHECK-NEXT:    [[TMP16:%.*]] = fmul float [[TMP5]], [[TMP11]]
; CHECK-NEXT:    [[TMP17:%.*]] = fadd float [[TMP15]], [[TMP16]]
; CHECK-NEXT:    [[TMP18]] = fadd float [[TMP3]], [[TMP14]]
; CHECK-NEXT:    [[TMP19]] = fadd float [[TMP2]], [[TMP17]]
; CHECK-NEXT:    [[TMP20]] = add nuw nsw i64 [[TMP1]], 1
; CHECK-NEXT:    [[TMP21:%.*]] = icmp eq i64 [[TMP20]], [[TMP0]]
; CHECK-NEXT:    br i1 [[TMP21]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr inbounds [[STRUCT_COMPLEX]], %struct.complex* [[RESULT:%.*]], i32 0, i32 0
; CHECK-NEXT:    store float [[TMP18]], float* [[TMP22]], align 4
; CHECK-NEXT:    [[TMP23:%.*]] = getelementptr inbounds [[STRUCT_COMPLEX]], %struct.complex* [[RESULT]], i32 0, i32 1
; CHECK-NEXT:    store float [[TMP19]], float* [[TMP23]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = add i64 256, 0
  br label %loop

loop:
  %1 = phi i64 [ 0, %entry ], [ %20, %loop ]
  %2 = phi float [ 0.000000e+00, %entry ], [ %19, %loop ]
  %3 = phi float [ 0.000000e+00, %entry ], [ %18, %loop ]
  %4 = getelementptr inbounds %"struct.complex", %"struct.complex"* %A, i64 %1, i32 0
  %5 = load float, float* %4, align 4
  %6 = getelementptr inbounds %"struct.complex", %"struct.complex"* %A, i64 %1, i32 1
  %7 = load float, float* %6, align 4
  %8 = getelementptr inbounds %"struct.complex", %"struct.complex"* %B, i64 %1, i32 0
  %9 = load float, float* %8, align 4
  %10 = getelementptr inbounds %"struct.complex", %"struct.complex"* %B, i64 %1, i32 1
  %11 = load float, float* %10, align 4
  %12 = fmul float %5, %9
  %13 = fmul float %7, %11
  %14 = fsub float %12, %13
  %15 = fmul float %7, %9
  %16 = fmul float %5, %11
  %17 = fadd float %15, %16
  %18 = fadd float %3, %14
  %19 = fadd float %2, %17
  %20 = add nuw nsw i64 %1, 1
  %21 = icmp eq i64 %20, %0
  br i1 %21, label %exit, label %loop

exit:
  %22 = getelementptr inbounds %"struct.complex", %"struct.complex"* %Result,  i32 0, i32 0
  store float %18, float* %22, align 4
  %23 = getelementptr inbounds %"struct.complex", %"struct.complex"* %Result,  i32 0, i32 1
  store float %19, float* %23, align 4
  ret void
}

