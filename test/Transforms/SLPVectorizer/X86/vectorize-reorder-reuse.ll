; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S -mtriple=x86_64-unknown-linux-gnu -mcpu=bdver2 < %s | FileCheck %s

define i32 @foo(i32* nocapture readonly %arr, i32 %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5, i32 %a6, i32 %a7, i32 %a8) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[ARR:%.*]] to <2 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x i32>, <2 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x i32> [[TMP1]], <2 x i32> poison, <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 0, i32 0>
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> poison, i32 [[A1:%.*]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <8 x i32> [[TMP2]], i32 [[A2:%.*]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <8 x i32> [[TMP3]], i32 [[A3:%.*]], i32 2
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <8 x i32> [[TMP4]], i32 [[A4:%.*]], i32 3
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <8 x i32> [[TMP5]], i32 [[A5:%.*]], i32 4
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <8 x i32> [[TMP6]], i32 [[A6:%.*]], i32 5
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <8 x i32> [[TMP7]], i32 [[A7:%.*]], i32 6
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <8 x i32> [[TMP8]], i32 [[A8:%.*]], i32 7
; CHECK-NEXT:    [[TMP10:%.*]] = add <8 x i32> [[SHUFFLE]], [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = call i32 @llvm.vector.reduce.umin.v8i32(<8 x i32> [[TMP10]])
; CHECK-NEXT:    ret i32 [[TMP11]]
;
entry:
  %arrayidx = getelementptr inbounds i32, i32* %arr, i64 1
  %0 = load i32, i32* %arrayidx, align 4
  %add = add i32 %0, %a1
  %add2 = add i32 %0, %a2
  %add4 = add i32 %0, %a3
  %add6 = add i32 %0, %a4
  %add8 = add i32 %0, %a5
  %add10 = add i32 %0, %a6
  %1 = load i32, i32* %arr, align 4
  %add12 = add i32 %1, %a7
  %add14 = add i32 %1, %a8
  %cmp = icmp ult i32 %add, %add2
  %cond = select i1 %cmp, i32 %add, i32 %add2
  %cmp15 = icmp ult i32 %cond, %add4
  %cond19 = select i1 %cmp15, i32 %cond, i32 %add4
  %cmp20 = icmp ult i32 %cond19, %add6
  %cond24 = select i1 %cmp20, i32 %cond19, i32 %add6
  %cmp25 = icmp ult i32 %cond24, %add8
  %cond29 = select i1 %cmp25, i32 %cond24, i32 %add8
  %cmp30 = icmp ult i32 %cond29, %add10
  %cond34 = select i1 %cmp30, i32 %cond29, i32 %add10
  %cmp35 = icmp ult i32 %cond34, %add12
  %cond39 = select i1 %cmp35, i32 %cond34, i32 %add12
  %cmp40 = icmp ult i32 %cond39, %add14
  %cond44 = select i1 %cmp40, i32 %cond39, i32 %add14
  ret i32 %cond44
}

define i32 @foo1(i32* nocapture readonly %arr, i32 %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5, i32 %a6, i32 %a7, i32 %a8) {
; CHECK-LABEL: @foo1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[ARR:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <4 x i32> [[TMP1]], <4 x i32> poison, <8 x i32> <i32 1, i32 2, i32 3, i32 1, i32 1, i32 0, i32 2, i32 1>
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> poison, i32 [[A1:%.*]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <8 x i32> [[TMP2]], i32 [[A2:%.*]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <8 x i32> [[TMP3]], i32 [[A3:%.*]], i32 2
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <8 x i32> [[TMP4]], i32 [[A4:%.*]], i32 3
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <8 x i32> [[TMP5]], i32 [[A5:%.*]], i32 4
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <8 x i32> [[TMP6]], i32 [[A6:%.*]], i32 5
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <8 x i32> [[TMP7]], i32 [[A7:%.*]], i32 6
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <8 x i32> [[TMP8]], i32 [[A8:%.*]], i32 7
; CHECK-NEXT:    [[TMP10:%.*]] = add <8 x i32> [[SHUFFLE]], [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = call i32 @llvm.vector.reduce.umin.v8i32(<8 x i32> [[TMP10]])
; CHECK-NEXT:    ret i32 [[TMP11]]
;
entry:
  %arrayidx = getelementptr inbounds i32, i32* %arr, i64 1
  %0 = load i32, i32* %arrayidx, align 4
  %add = add i32 %0, %a1
  %arrayidx1 = getelementptr inbounds i32, i32* %arr, i64 2
  %1 = load i32, i32* %arrayidx1, align 4
  %add2 = add i32 %1, %a2
  %arrayidx3 = getelementptr inbounds i32, i32* %arr, i64 3
  %2 = load i32, i32* %arrayidx3, align 4
  %add4 = add i32 %2, %a3
  %add6 = add i32 %0, %a4
  %add8 = add i32 %0, %a5
  %3 = load i32, i32* %arr, align 4
  %add10 = add i32 %3, %a6
  %add12 = add i32 %1, %a7
  %add14 = add i32 %0, %a8
  %cmp = icmp ult i32 %add, %add2
  %cond = select i1 %cmp, i32 %add, i32 %add2
  %cmp15 = icmp ult i32 %cond, %add4
  %cond19 = select i1 %cmp15, i32 %cond, i32 %add4
  %cmp20 = icmp ult i32 %cond19, %add6
  %cond24 = select i1 %cmp20, i32 %cond19, i32 %add6
  %cmp25 = icmp ult i32 %cond24, %add8
  %cond29 = select i1 %cmp25, i32 %cond24, i32 %add8
  %cmp30 = icmp ult i32 %cond29, %add10
  %cond34 = select i1 %cmp30, i32 %cond29, i32 %add10
  %cmp35 = icmp ult i32 %cond34, %add12
  %cond39 = select i1 %cmp35, i32 %cond34, i32 %add12
  %cmp40 = icmp ult i32 %cond39, %add14
  %cond44 = select i1 %cmp40, i32 %cond39, i32 %add14
  ret i32 %cond44
}

define i32 @foo2(i32* nocapture readonly %arr, i32 %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5, i32 %a6, i32 %a7, i32 %a8) {
; CHECK-LABEL: @foo2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[ARR:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <4 x i32> [[TMP1]], <4 x i32> poison, <8 x i32> <i32 3, i32 2, i32 3, i32 0, i32 1, i32 0, i32 2, i32 1>
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> poison, i32 [[A1:%.*]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <8 x i32> [[TMP2]], i32 [[A2:%.*]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <8 x i32> [[TMP3]], i32 [[A3:%.*]], i32 2
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <8 x i32> [[TMP4]], i32 [[A4:%.*]], i32 3
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <8 x i32> [[TMP5]], i32 [[A5:%.*]], i32 4
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <8 x i32> [[TMP6]], i32 [[A6:%.*]], i32 5
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <8 x i32> [[TMP7]], i32 [[A7:%.*]], i32 6
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <8 x i32> [[TMP8]], i32 [[A8:%.*]], i32 7
; CHECK-NEXT:    [[TMP10:%.*]] = add <8 x i32> [[SHUFFLE]], [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = call i32 @llvm.vector.reduce.umin.v8i32(<8 x i32> [[TMP10]])
; CHECK-NEXT:    ret i32 [[TMP11]]
;
entry:
  %arrayidx = getelementptr inbounds i32, i32* %arr, i64 3
  %0 = load i32, i32* %arrayidx, align 4
  %add = add i32 %0, %a1
  %arrayidx1 = getelementptr inbounds i32, i32* %arr, i64 2
  %1 = load i32, i32* %arrayidx1, align 4
  %add2 = add i32 %1, %a2
  %add4 = add i32 %0, %a3
  %2 = load i32, i32* %arr, align 4
  %add6 = add i32 %2, %a4
  %arrayidx7 = getelementptr inbounds i32, i32* %arr, i64 1
  %3 = load i32, i32* %arrayidx7, align 4
  %add8 = add i32 %3, %a5
  %add10 = add i32 %2, %a6
  %add12 = add i32 %1, %a7
  %add14 = add i32 %3, %a8
  %cmp = icmp ult i32 %add, %add2
  %cond = select i1 %cmp, i32 %add, i32 %add2
  %cmp15 = icmp ult i32 %cond, %add4
  %cond19 = select i1 %cmp15, i32 %cond, i32 %add4
  %cmp20 = icmp ult i32 %cond19, %add6
  %cond24 = select i1 %cmp20, i32 %cond19, i32 %add6
  %cmp25 = icmp ult i32 %cond24, %add8
  %cond29 = select i1 %cmp25, i32 %cond24, i32 %add8
  %cmp30 = icmp ult i32 %cond29, %add10
  %cond34 = select i1 %cmp30, i32 %cond29, i32 %add10
  %cmp35 = icmp ult i32 %cond34, %add12
  %cond39 = select i1 %cmp35, i32 %cond34, i32 %add12
  %cmp40 = icmp ult i32 %cond39, %add14
  %cond44 = select i1 %cmp40, i32 %cond39, i32 %add14
  ret i32 %cond44
}
