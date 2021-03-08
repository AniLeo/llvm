; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -vector-library=MASSV -force-vector-interleave=1 \
; RUN:   -vectorizer-maximize-bandwidth -O2 -inject-tli-mappings -loop-vectorize \
; RUN:   -mtriple=powerpc64le-unknown-linux -S -mcpu=pwr9 2>&1 | FileCheck %s

define dso_local double @test(float* %Arr) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <2 x double> [ zeroinitializer, [[ENTRY]] ], [ [[TMP5:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[INDEX]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds float, float* [[ARR:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast float* [[TMP1]] to <2 x float>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x float>, <2 x float>* [[TMP2]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = fpext <2 x float> [[WIDE_LOAD]] to <2 x double>
; CHECK-NEXT:    [[TMP4:%.*]] = call fast <2 x double> @__sind2_P8(<2 x double> [[TMP3]])
; CHECK-NEXT:    [[TMP5]] = fadd fast <2 x double> [[TMP4]], [[VEC_PHI]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 2
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[INDEX_NEXT]], 128
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[DOTLCSSA:%.*]] = phi <2 x double> [ [[TMP5]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = call fast double @llvm.vector.reduce.fadd.v2f64(double -0.000000e+00, <2 x double> [[DOTLCSSA]])
; CHECK-NEXT:    ret double [[TMP7]]
;
entry:
  br label %for.cond

for.cond:
  %Sum.0 = phi double [ 0.000000e+00, %entry ], [ %add, %for.inc ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 128
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  br label %for.end

for.body:
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds float, float* %Arr, i64 %idxprom
  %0 = load float, float* %arrayidx, align 4
  %conv = fpext float %0 to double
  %1 = call fast double @llvm.sin.f64(double %conv)
  %add = fadd fast double %Sum.0, %1
  br label %for.inc

for.inc:
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:
  ret double %Sum.0
}

declare double @llvm.sin.f64(double)
