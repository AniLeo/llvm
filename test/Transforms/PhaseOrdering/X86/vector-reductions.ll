; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -O2                   -S -mattr=avx < %s | FileCheck %s
; RUN: opt -passes='default<O2>' -S -mattr=avx < %s | FileCheck %s

target triple = "x86_64--"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define i32 @ext_ext_or_reduction_v4i32(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @ext_ext_or_reduction_v4i32(
; CHECK-NEXT:    [[Z:%.*]] = and <4 x i32> [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.experimental.vector.reduce.or.v4i32(<4 x i32> [[Z]])
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %z = and <4 x i32> %x, %y
  %z0 = extractelement <4 x i32> %z, i32 0
  %z1 = extractelement <4 x i32> %z, i32 1
  %z01 = or i32 %z0, %z1
  %z2 = extractelement <4 x i32> %z, i32 2
  %z012 = or i32 %z01, %z2
  %z3 = extractelement <4 x i32> %z, i32 3
  %z0123 = or i32 %z3, %z012
  ret i32 %z0123
}

define i32 @ext_ext_partial_add_reduction_v4i32(<4 x i32> %x) {
; CHECK-LABEL: @ext_ext_partial_add_reduction_v4i32(
; CHECK-NEXT:    [[SHIFT:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP1:%.*]] = add <4 x i32> [[SHIFT]], [[X]]
; CHECK-NEXT:    [[SHIFT1:%.*]] = shufflevector <4 x i32> [[X]], <4 x i32> undef, <4 x i32> <i32 2, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = add <4 x i32> [[TMP1]], [[SHIFT1]]
; CHECK-NEXT:    [[X210:%.*]] = extractelement <4 x i32> [[TMP2]], i64 0
; CHECK-NEXT:    ret i32 [[X210]]
;
  %x0 = extractelement <4 x i32> %x, i32 0
  %x1 = extractelement <4 x i32> %x, i32 1
  %x10 = add i32 %x1, %x0
  %x2 = extractelement <4 x i32> %x, i32 2
  %x210 = add i32 %x2, %x10
  ret i32 %x210
}

define i32 @ext_ext_partial_add_reduction_and_extra_add_v4i32(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @ext_ext_partial_add_reduction_and_extra_add_v4i32(
; CHECK-NEXT:    [[SHIFT:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> undef, <4 x i32> <i32 2, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP1:%.*]] = add <4 x i32> [[SHIFT]], [[Y:%.*]]
; CHECK-NEXT:    [[SHIFT1:%.*]] = shufflevector <4 x i32> [[Y]], <4 x i32> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = add <4 x i32> [[TMP1]], [[SHIFT1]]
; CHECK-NEXT:    [[SHIFT2:%.*]] = shufflevector <4 x i32> [[Y]], <4 x i32> undef, <4 x i32> <i32 2, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP3:%.*]] = add <4 x i32> [[TMP2]], [[SHIFT2]]
; CHECK-NEXT:    [[X2Y210:%.*]] = extractelement <4 x i32> [[TMP3]], i32 0
; CHECK-NEXT:    ret i32 [[X2Y210]]
;
  %y0 = extractelement <4 x i32> %y, i32 0
  %y1 = extractelement <4 x i32> %y, i32 1
  %y10 = add i32 %y1, %y0
  %y2 = extractelement <4 x i32> %y, i32 2
  %y210 = add i32 %y2, %y10
  %x2 = extractelement <4 x i32> %x, i32 2
  %x2y210 = add i32 %x2, %y210
  ret i32 %x2y210
}

; PR43953 - https://bugs.llvm.org/show_bug.cgi?id=43953
; We want to end up with a single reduction on the next 4 tests.

define i32 @TestVectorsEqual(i32* noalias %Vec0, i32* noalias %Vec1, i32 %Tolerance) {
; CHECK-LABEL: @TestVectorsEqual(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[VEC0:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32* [[VEC1:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x i32>, <4 x i32>* [[TMP2]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = sub nsw <4 x i32> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = icmp slt <4 x i32> [[TMP4]], zeroinitializer
; CHECK-NEXT:    [[TMP6:%.*]] = sub nsw <4 x i32> zeroinitializer, [[TMP4]]
; CHECK-NEXT:    [[TMP7:%.*]] = select <4 x i1> [[TMP5]], <4 x i32> [[TMP6]], <4 x i32> [[TMP4]]
; CHECK-NEXT:    [[TMP8:%.*]] = call i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32> [[TMP7]])
; CHECK-NEXT:    [[CMP5:%.*]] = icmp sle i32 [[TMP8]], [[TOLERANCE:%.*]]
; CHECK-NEXT:    [[COND6:%.*]] = zext i1 [[CMP5]] to i32
; CHECK-NEXT:    ret i32 [[COND6]]
;
entry:
  br label %for.cond

for.cond:
  %sum.0 = phi i32 [ 0, %entry ], [ %add, %for.inc ]
  %Component.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %Component.0, 4
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  br label %for.end

for.body:
  %idxprom = sext i32 %Component.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %Vec0, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %idxprom1 = sext i32 %Component.0 to i64
  %arrayidx2 = getelementptr inbounds i32, i32* %Vec1, i64 %idxprom1
  %1 = load i32, i32* %arrayidx2, align 4
  %sub = sub nsw i32 %0, %1
  %cmp3 = icmp sge i32 %sub, 0
  br i1 %cmp3, label %cond.true, label %cond.false

cond.true:
  br label %cond.end

cond.false:
  %sub4 = sub nsw i32 0, %sub
  br label %cond.end

cond.end:
  %cond = phi i32 [ %sub, %cond.true ], [ %sub4, %cond.false ]
  %add = add nsw i32 %sum.0, %cond
  br label %for.inc

for.inc:
  %inc = add nsw i32 %Component.0, 1
  br label %for.cond

for.end:
  %cmp5 = icmp sle i32 %sum.0, %Tolerance
  %2 = zext i1 %cmp5 to i64
  %cond6 = select i1 %cmp5, i32 1, i32 0
  ret i32 %cond6
}

define i32 @TestVectorsEqual_alt(i32* noalias %Vec0, i32* noalias %Vec1, i32 %Tolerance) {
; CHECK-LABEL: @TestVectorsEqual_alt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[VEC0:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32* [[VEC1:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x i32>, <4 x i32>* [[TMP2]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = sub <4 x i32> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = call i32 @llvm.experimental.vector.reduce.add.v4i32(<4 x i32> [[TMP4]])
; CHECK-NEXT:    [[CMP3:%.*]] = icmp ule i32 [[TMP5]], [[TOLERANCE:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = zext i1 [[CMP3]] to i32
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  br label %for.cond

for.cond:
  %sum.0 = phi i32 [ 0, %entry ], [ %add, %for.inc ]
  %Component.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %Component.0, 4
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  br label %for.end

for.body:
  %idxprom = sext i32 %Component.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %Vec0, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %idxprom1 = sext i32 %Component.0 to i64
  %arrayidx2 = getelementptr inbounds i32, i32* %Vec1, i64 %idxprom1
  %1 = load i32, i32* %arrayidx2, align 4
  %sub = sub i32 %0, %1
  %add = add i32 %sum.0, %sub
  br label %for.inc

for.inc:
  %inc = add nsw i32 %Component.0, 1
  br label %for.cond

for.end:
  %cmp3 = icmp ule i32 %sum.0, %Tolerance
  %2 = zext i1 %cmp3 to i64
  %cond = select i1 %cmp3, i32 1, i32 0
  ret i32 %cond
}

define i32 @TestVectorsEqualFP(float* noalias %Vec0, float* noalias %Vec1, float %Tolerance) {
; CHECK-LABEL: @TestVectorsEqualFP(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast float* [[VEC0:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast float* [[VEC1:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x float>, <4 x float>* [[TMP2]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = fsub fast <4 x float> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = call fast <4 x float> @llvm.fabs.v4f32(<4 x float> [[TMP4]])
; CHECK-NEXT:    [[TMP6:%.*]] = call fast float @llvm.experimental.vector.reduce.v2.fadd.f32.v4f32(float 0.000000e+00, <4 x float> [[TMP5]])
; CHECK-NEXT:    [[CMP4:%.*]] = fcmp fast ole float [[TMP6]], [[TOLERANCE:%.*]]
; CHECK-NEXT:    [[COND5:%.*]] = zext i1 [[CMP4]] to i32
; CHECK-NEXT:    ret i32 [[COND5]]
;
entry:
  br label %for.cond

for.cond:
  %sum.0 = phi float [ 0.000000e+00, %entry ], [ %add, %for.inc ]
  %Component.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %Component.0, 4
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  br label %for.end

for.body:
  %idxprom = sext i32 %Component.0 to i64
  %arrayidx = getelementptr inbounds float, float* %Vec0, i64 %idxprom
  %0 = load float, float* %arrayidx, align 4
  %idxprom1 = sext i32 %Component.0 to i64
  %arrayidx2 = getelementptr inbounds float, float* %Vec1, i64 %idxprom1
  %1 = load float, float* %arrayidx2, align 4
  %sub = fsub fast float %0, %1
  %cmp3 = fcmp fast oge float %sub, 0.000000e+00
  br i1 %cmp3, label %cond.true, label %cond.false

cond.true:
  br label %cond.end

cond.false:
  %fneg = fneg fast float %sub
  br label %cond.end

cond.end:
  %cond = phi fast float [ %sub, %cond.true ], [ %fneg, %cond.false ]
  %add = fadd fast float %sum.0, %cond
  br label %for.inc

for.inc:
  %inc = add nsw i32 %Component.0, 1
  br label %for.cond

for.end:
  %cmp4 = fcmp fast ole float %sum.0, %Tolerance
  %2 = zext i1 %cmp4 to i64
  %cond5 = select i1 %cmp4, i32 1, i32 0
  ret i32 %cond5
}

define i32 @TestVectorsEqualFP_alt(float* noalias %Vec0, float* noalias %Vec1, float %Tolerance) {
; CHECK-LABEL: @TestVectorsEqualFP_alt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast float* [[VEC0:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast float* [[VEC1:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x float>, <4 x float>* [[TMP2]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = fsub fast <4 x float> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = call fast float @llvm.experimental.vector.reduce.v2.fadd.f32.v4f32(float 0.000000e+00, <4 x float> [[TMP4]])
; CHECK-NEXT:    [[CMP3:%.*]] = fcmp fast ole float [[TMP5]], [[TOLERANCE:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = zext i1 [[CMP3]] to i32
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  br label %for.cond

for.cond:
  %sum.0 = phi float [ 0.000000e+00, %entry ], [ %add, %for.inc ]
  %Component.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %Component.0, 4
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  br label %for.end

for.body:
  %idxprom = sext i32 %Component.0 to i64
  %arrayidx = getelementptr inbounds float, float* %Vec0, i64 %idxprom
  %0 = load float, float* %arrayidx, align 4
  %idxprom1 = sext i32 %Component.0 to i64
  %arrayidx2 = getelementptr inbounds float, float* %Vec1, i64 %idxprom1
  %1 = load float, float* %arrayidx2, align 4
  %sub = fsub fast float %0, %1
  %add = fadd fast float %sum.0, %sub
  br label %for.inc

for.inc:
  %inc = add nsw i32 %Component.0, 1
  br label %for.cond

for.end:
  %cmp3 = fcmp fast ole float %sum.0, %Tolerance
  %2 = zext i1 %cmp3 to i64
  %cond = select i1 %cmp3, i32 1, i32 0
  ret i32 %cond
}
