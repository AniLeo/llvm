; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -slp-vectorizer  -S -mtriple=x86_64-unknown -mcpu=corei7-avx | FileCheck %s

%struct.complex = type { float, float }

define  void @foo (%struct.complex* %A, %struct.complex* %B, %struct.complex* %Result) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 256, 0
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[TMP25:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = phi <2 x float> [ zeroinitializer, [[ENTRY]] ], [ [[TMP24:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [[STRUCT_COMPLEX:%.*]], %struct.complex* [[A:%.*]], i64 [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [[STRUCT_COMPLEX]], %struct.complex* [[A]], i64 [[TMP1]], i32 1
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast float* [[TMP3]] to <2 x float>*
; CHECK-NEXT:    [[TMP6:%.*]] = load <2 x float>, <2 x float>* [[TMP5]], align 4
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [[STRUCT_COMPLEX]], %struct.complex* [[B:%.*]], i64 [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = load float, float* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds [[STRUCT_COMPLEX]], %struct.complex* [[B]], i64 [[TMP1]], i32 1
; CHECK-NEXT:    [[TMP10:%.*]] = load float, float* [[TMP9]], align 4
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <2 x float> undef, float [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP12:%.*]] = insertelement <2 x float> [[TMP11]], float [[TMP8]], i32 1
; CHECK-NEXT:    [[TMP13:%.*]] = fmul <2 x float> [[TMP6]], [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x float> [[TMP6]], i32 1
; CHECK-NEXT:    [[TMP15:%.*]] = insertelement <2 x float> undef, float [[TMP14]], i32 0
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <2 x float> [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP17:%.*]] = insertelement <2 x float> [[TMP15]], float [[TMP16]], i32 1
; CHECK-NEXT:    [[TMP18:%.*]] = insertelement <2 x float> undef, float [[TMP10]], i32 0
; CHECK-NEXT:    [[TMP19:%.*]] = insertelement <2 x float> [[TMP18]], float [[TMP10]], i32 1
; CHECK-NEXT:    [[TMP20:%.*]] = fmul <2 x float> [[TMP17]], [[TMP19]]
; CHECK-NEXT:    [[TMP21:%.*]] = fsub <2 x float> [[TMP13]], [[TMP20]]
; CHECK-NEXT:    [[TMP22:%.*]] = fadd <2 x float> [[TMP13]], [[TMP20]]
; CHECK-NEXT:    [[TMP23:%.*]] = shufflevector <2 x float> [[TMP21]], <2 x float> [[TMP22]], <2 x i32> <i32 0, i32 3>
; CHECK-NEXT:    [[TMP24]] = fadd <2 x float> [[TMP2]], [[TMP23]]
; CHECK-NEXT:    [[TMP25]] = add nuw nsw i64 [[TMP1]], 1
; CHECK-NEXT:    [[TMP26:%.*]] = icmp eq i64 [[TMP25]], [[TMP0]]
; CHECK-NEXT:    br i1 [[TMP26]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[TMP27:%.*]] = getelementptr inbounds [[STRUCT_COMPLEX]], %struct.complex* [[RESULT:%.*]], i32 0, i32 0
; CHECK-NEXT:    [[TMP28:%.*]] = extractelement <2 x float> [[TMP24]], i32 0
; CHECK-NEXT:    store float [[TMP28]], float* [[TMP27]], align 4
; CHECK-NEXT:    [[TMP29:%.*]] = getelementptr inbounds [[STRUCT_COMPLEX]], %struct.complex* [[RESULT]], i32 0, i32 1
; CHECK-NEXT:    [[TMP30:%.*]] = extractelement <2 x float> [[TMP24]], i32 1
; CHECK-NEXT:    store float [[TMP30]], float* [[TMP29]], align 4
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

