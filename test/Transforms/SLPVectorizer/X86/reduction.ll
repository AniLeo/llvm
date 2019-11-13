; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -slp-vectorizer -dce -S -mtriple=i386-apple-macosx10.8.0 -mcpu=corei7-avx | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128-n8:16:32-S128"
target triple = "i386-apple-macosx10.8.0"

; int foo(double *A, int n, int m) {
;   double sum = 0, v1 = 2, v0 = 3;
;   for (int i=0; i < n; ++i)
;     sum += 7*A[i*2] + 7*A[i*2+1];
;   return sum;
; }

define i32 @reduce(double* nocapture %A, i32 %n, i32 %m) {
; CHECK-LABEL: @reduce(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP13:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP13]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_015:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SUM_014:%.*]] = phi double [ [[ADD6:%.*]], [[FOR_BODY]] ], [ 0.000000e+00, [[ENTRY]] ]
; CHECK-NEXT:    [[MUL:%.*]] = shl nsw i32 [[I_015]], 1
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, double* [[A:%.*]], i32 [[MUL]]
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast double* [[ARRAYIDX]] to <2 x double>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x double>, <2 x double>* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = fmul <2 x double> [[TMP1]], <double 7.000000e+00, double 7.000000e+00>
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x double> [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x double> [[TMP2]], i32 1
; CHECK-NEXT:    [[ADD5:%.*]] = fadd double [[TMP3]], [[TMP4]]
; CHECK-NEXT:    [[ADD6]] = fadd double [[SUM_014]], [[ADD5]]
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_015]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_FOR_END_CRIT_EDGE:%.*]], label [[FOR_BODY]]
; CHECK:       for.cond.for.end_crit_edge:
; CHECK-NEXT:    [[PHITMP:%.*]] = fptosi double [[ADD6]] to i32
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ [[PHITMP]], [[FOR_COND_FOR_END_CRIT_EDGE]] ], [ 0, [[ENTRY]] ]
; CHECK-NEXT:    ret i32 [[SUM_0_LCSSA]]
;
entry:
  %cmp13 = icmp sgt i32 %n, 0
  br i1 %cmp13, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  %i.015 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %sum.014 = phi double [ %add6, %for.body ], [ 0.000000e+00, %entry ]
  %mul = shl nsw i32 %i.015, 1
  %arrayidx = getelementptr inbounds double, double* %A, i32 %mul
  %0 = load double, double* %arrayidx, align 4
  %mul1 = fmul double %0, 7.000000e+00
  %add12 = or i32 %mul, 1
  %arrayidx3 = getelementptr inbounds double, double* %A, i32 %add12
  %1 = load double, double* %arrayidx3, align 4
  %mul4 = fmul double %1, 7.000000e+00
  %add5 = fadd double %mul1, %mul4
  %add6 = fadd double %sum.014, %add5
  %inc = add nsw i32 %i.015, 1
  %exitcond = icmp eq i32 %inc, %n
  br i1 %exitcond, label %for.cond.for.end_crit_edge, label %for.body

for.cond.for.end_crit_edge:                       ; preds = %for.body
  %phitmp = fptosi double %add6 to i32
  br label %for.end

for.end:                                          ; preds = %for.cond.for.end_crit_edge, %entry
  %sum.0.lcssa = phi i32 [ %phitmp, %for.cond.for.end_crit_edge ], [ 0, %entry ]
  ret i32 %sum.0.lcssa
}

; FIXME: PR43948 - https://bugs.llvm.org/show_bug.cgi?id=43948
; The extra use of a non-vectorized element of a reduction must not be killed.

define i32 @horiz_max_multiple_uses([32 x i32]* %x, i32* %p) {
; CHECK-LABEL: @horiz_max_multiple_uses(
; CHECK-NEXT:    [[X0:%.*]] = getelementptr [32 x i32], [32 x i32]* [[X:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[X4:%.*]] = getelementptr [32 x i32], [32 x i32]* [[X]], i64 0, i64 4
; CHECK-NEXT:    [[X5:%.*]] = getelementptr [32 x i32], [32 x i32]* [[X]], i64 0, i64 5
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[X0]] to <4 x i32>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 4
; CHECK-NEXT:    [[T4:%.*]] = load i32, i32* [[X4]]
; CHECK-NEXT:    [[T5:%.*]] = load i32, i32* [[X5]]
; CHECK-NEXT:    [[RDX_SHUF:%.*]] = shufflevector <4 x i32> [[TMP2]], <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 undef, i32 undef>
; CHECK-NEXT:    [[RDX_MINMAX_CMP:%.*]] = icmp sgt <4 x i32> [[TMP2]], [[RDX_SHUF]]
; CHECK-NEXT:    [[RDX_MINMAX_SELECT:%.*]] = select <4 x i1> [[RDX_MINMAX_CMP]], <4 x i32> [[TMP2]], <4 x i32> [[RDX_SHUF]]
; CHECK-NEXT:    [[RDX_SHUF1:%.*]] = shufflevector <4 x i32> [[RDX_MINMAX_SELECT]], <4 x i32> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[RDX_MINMAX_CMP2:%.*]] = icmp sgt <4 x i32> [[RDX_MINMAX_SELECT]], [[RDX_SHUF1]]
; CHECK-NEXT:    [[RDX_MINMAX_SELECT3:%.*]] = select <4 x i1> [[RDX_MINMAX_CMP2]], <4 x i32> [[RDX_MINMAX_SELECT]], <4 x i32> [[RDX_SHUF1]]
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <4 x i32> [[RDX_MINMAX_SELECT3]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = icmp sgt i32 [[TMP3]], [[T4]]
; CHECK-NEXT:    [[TMP5:%.*]] = select i1 [[TMP4]], i32 [[TMP3]], i32 [[T4]]
; CHECK-NEXT:    [[C012345:%.*]] = icmp sgt i32 [[TMP5]], [[T5]]
; CHECK-NEXT:    [[T17:%.*]] = select i1 [[C012345]], i32 [[TMP5]], i32 [[T5]]
; CHECK-NEXT:    [[THREE_OR_FOUR:%.*]] = select i1 undef, i32 3, i32 4
; CHECK-NEXT:    store i32 [[THREE_OR_FOUR]], i32* [[P:%.*]], align 8
; CHECK-NEXT:    ret i32 [[T17]]
;
  %x0 = getelementptr [32 x i32], [32 x i32]* %x, i64 0, i64 0
  %x1 = getelementptr [32 x i32], [32 x i32]* %x, i64 0, i64 1
  %x2 = getelementptr [32 x i32], [32 x i32]* %x, i64 0, i64 2
  %x3 = getelementptr [32 x i32], [32 x i32]* %x, i64 0, i64 3
  %x4 = getelementptr [32 x i32], [32 x i32]* %x, i64 0, i64 4
  %x5 = getelementptr [32 x i32], [32 x i32]* %x, i64 0, i64 5

  %t0 = load i32, i32* %x0
  %t1 = load i32, i32* %x1
  %t2 = load i32, i32* %x2
  %t3 = load i32, i32* %x3
  %t4 = load i32, i32* %x4
  %t5 = load i32, i32* %x5

  %c01 = icmp sgt i32 %t0, %t1
  %s5 = select i1 %c01, i32 %t0, i32 %t1
  %c012 = icmp sgt i32 %s5, %t2
  %t8 = select i1 %c012, i32 %s5, i32 %t2
  %c0123 = icmp sgt i32 %t8, %t3
  %rdx4 = select i1 %c0123, i32 %t8, i32 %t3
  %MAX_ROOT_CMP = icmp sgt i32 %rdx4, %t4
  %MAX_ROOT_SEL = select i1 %MAX_ROOT_CMP, i32 %rdx4, i32 %t4
  %c012345 = icmp sgt i32 %MAX_ROOT_SEL, %t5
  %t17 = select i1 %c012345, i32 %MAX_ROOT_SEL, i32 %t5
  %three_or_four = select i1 %MAX_ROOT_CMP, i32 3, i32 4
  store i32 %three_or_four, i32* %p, align 8
  ret i32 %t17
}
