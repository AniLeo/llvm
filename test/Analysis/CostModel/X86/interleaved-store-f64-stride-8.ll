; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py UTC_ARGS: --filter "LV: Found an estimated cost of [0-9]+ for VF [0-9]+ For instruction:\s*store double %v7, ptr %out7"
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+sse2 --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefix=SSE2
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx  --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefix=AVX1
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx2 --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefix=AVX2
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx512vl --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefix=AVX512
; REQUIRES: asserts

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@A = global [1024 x i8] zeroinitializer, align 128
@B = global [1024 x double] zeroinitializer, align 128

define void @test() {
; SSE2-LABEL: 'test'
; SSE2:  LV: Found an estimated cost of 1 for VF 1 For instruction: store double %v7, ptr %out7, align 8
; SSE2:  LV: Found an estimated cost of 24 for VF 2 For instruction: store double %v7, ptr %out7, align 8
; SSE2:  LV: Found an estimated cost of 48 for VF 4 For instruction: store double %v7, ptr %out7, align 8
;
; AVX1-LABEL: 'test'
; AVX1:  LV: Found an estimated cost of 1 for VF 1 For instruction: store double %v7, ptr %out7, align 8
; AVX1:  LV: Found an estimated cost of 24 for VF 2 For instruction: store double %v7, ptr %out7, align 8
; AVX1:  LV: Found an estimated cost of 64 for VF 4 For instruction: store double %v7, ptr %out7, align 8
; AVX1:  LV: Found an estimated cost of 128 for VF 8 For instruction: store double %v7, ptr %out7, align 8
;
; AVX2-LABEL: 'test'
; AVX2:  LV: Found an estimated cost of 1 for VF 1 For instruction: store double %v7, ptr %out7, align 8
; AVX2:  LV: Found an estimated cost of 24 for VF 2 For instruction: store double %v7, ptr %out7, align 8
; AVX2:  LV: Found an estimated cost of 64 for VF 4 For instruction: store double %v7, ptr %out7, align 8
; AVX2:  LV: Found an estimated cost of 128 for VF 8 For instruction: store double %v7, ptr %out7, align 8
;
; AVX512-LABEL: 'test'
; AVX512:  LV: Found an estimated cost of 1 for VF 1 For instruction: store double %v7, ptr %out7, align 8
; AVX512:  LV: Found an estimated cost of 23 for VF 2 For instruction: store double %v7, ptr %out7, align 8
; AVX512:  LV: Found an estimated cost of 46 for VF 4 For instruction: store double %v7, ptr %out7, align 8
; AVX512:  LV: Found an estimated cost of 80 for VF 8 For instruction: store double %v7, ptr %out7, align 8
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]

  %iv.0 = add nuw nsw i64 %iv, 0
  %iv.1 = add nuw nsw i64 %iv, 1
  %iv.2 = add nuw nsw i64 %iv, 2
  %iv.3 = add nuw nsw i64 %iv, 3
  %iv.4 = add nuw nsw i64 %iv, 4
  %iv.5 = add nuw nsw i64 %iv, 5
  %iv.6 = add nuw nsw i64 %iv, 6
  %iv.7 = add nuw nsw i64 %iv, 7

  %in = getelementptr inbounds [1024 x i8], ptr @A, i64 0, i64 %iv.0
  %v.narrow = load i8, ptr %in

  %v = uitofp i8 %v.narrow to double

  %v0 = fadd double %v, 0.0
  %v1 = fadd double %v, 1.0
  %v2 = fadd double %v, 2.0
  %v3 = fadd double %v, 3.0
  %v4 = fadd double %v, 4.0
  %v5 = fadd double %v, 5.0
  %v6 = fadd double %v, 6.0
  %v7 = fadd double %v, 7.0

  %out0 = getelementptr inbounds [1024 x double], ptr @B, i64 0, i64 %iv.0
  %out1 = getelementptr inbounds [1024 x double], ptr @B, i64 0, i64 %iv.1
  %out2 = getelementptr inbounds [1024 x double], ptr @B, i64 0, i64 %iv.2
  %out3 = getelementptr inbounds [1024 x double], ptr @B, i64 0, i64 %iv.3
  %out4 = getelementptr inbounds [1024 x double], ptr @B, i64 0, i64 %iv.4
  %out5 = getelementptr inbounds [1024 x double], ptr @B, i64 0, i64 %iv.5
  %out6 = getelementptr inbounds [1024 x double], ptr @B, i64 0, i64 %iv.6
  %out7 = getelementptr inbounds [1024 x double], ptr @B, i64 0, i64 %iv.7

  store double %v0, ptr %out0
  store double %v1, ptr %out1
  store double %v2, ptr %out2
  store double %v3, ptr %out3
  store double %v4, ptr %out4
  store double %v5, ptr %out5
  store double %v6, ptr %out6
  store double %v7, ptr %out7

  %iv.next = add nuw nsw i64 %iv.0, 8
  %cmp = icmp ult i64 %iv.next, 1024
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  ret void
}
