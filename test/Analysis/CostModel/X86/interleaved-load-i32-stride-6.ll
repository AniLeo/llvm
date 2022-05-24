; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py UTC_ARGS: --filter "LV: Found an estimated cost of [0-9]+ for VF [0-9]+ For instruction:\s*%v0 = load i32, ptr %in0"
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+sse2 --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefix=SSE2
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx  --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefix=AVX1
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx2 --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefix=AVX2
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx512vl --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefix=AVX512
; REQUIRES: asserts

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@A = global [1024 x i32] zeroinitializer, align 128
@B = global [1024 x i8] zeroinitializer, align 128

define void @test() {
; SSE2-LABEL: 'test'
; SSE2:  LV: Found an estimated cost of 1 for VF 1 For instruction: %v0 = load i32, ptr %in0, align 4
; SSE2:  LV: Found an estimated cost of 42 for VF 2 For instruction: %v0 = load i32, ptr %in0, align 4
; SSE2:  LV: Found an estimated cost of 90 for VF 4 For instruction: %v0 = load i32, ptr %in0, align 4
; SSE2:  LV: Found an estimated cost of 180 for VF 8 For instruction: %v0 = load i32, ptr %in0, align 4
;
; AVX1-LABEL: 'test'
; AVX1:  LV: Found an estimated cost of 1 for VF 1 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX1:  LV: Found an estimated cost of 27 for VF 2 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX1:  LV: Found an estimated cost of 54 for VF 4 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX1:  LV: Found an estimated cost of 120 for VF 8 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX1:  LV: Found an estimated cost of 240 for VF 16 For instruction: %v0 = load i32, ptr %in0, align 4
;
; AVX2-LABEL: 'test'
; AVX2:  LV: Found an estimated cost of 1 for VF 1 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX2:  LV: Found an estimated cost of 8 for VF 2 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX2:  LV: Found an estimated cost of 18 for VF 4 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX2:  LV: Found an estimated cost of 37 for VF 8 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX2:  LV: Found an estimated cost of 76 for VF 16 For instruction: %v0 = load i32, ptr %in0, align 4
;
; AVX512-LABEL: 'test'
; AVX512:  LV: Found an estimated cost of 1 for VF 1 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX512:  LV: Found an estimated cost of 7 for VF 2 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX512:  LV: Found an estimated cost of 11 for VF 4 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX512:  LV: Found an estimated cost of 21 for VF 8 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX512:  LV: Found an estimated cost of 51 for VF 16 For instruction: %v0 = load i32, ptr %in0, align 4
; AVX512:  LV: Found an estimated cost of 210 for VF 32 For instruction: %v0 = load i32, ptr %in0, align 4
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

  %in0 = getelementptr inbounds [1024 x i32], ptr @A, i64 0, i64 %iv.0
  %in1 = getelementptr inbounds [1024 x i32], ptr @A, i64 0, i64 %iv.1
  %in2 = getelementptr inbounds [1024 x i32], ptr @A, i64 0, i64 %iv.2
  %in3 = getelementptr inbounds [1024 x i32], ptr @A, i64 0, i64 %iv.3
  %in4 = getelementptr inbounds [1024 x i32], ptr @A, i64 0, i64 %iv.4
  %in5 = getelementptr inbounds [1024 x i32], ptr @A, i64 0, i64 %iv.5

  %v0 = load i32, ptr %in0
  %v1 = load i32, ptr %in1
  %v2 = load i32, ptr %in2
  %v3 = load i32, ptr %in3
  %v4 = load i32, ptr %in4
  %v5 = load i32, ptr %in5

  %reduce.add.0 = add i32 %v0, %v1
  %reduce.add.1 = add i32 %reduce.add.0, %v2
  %reduce.add.2 = add i32 %reduce.add.1, %v3
  %reduce.add.3 = add i32 %reduce.add.2, %v4
  %reduce.add.4 = add i32 %reduce.add.3, %v5

  %reduce.add.4.narrow = trunc i32 %reduce.add.4 to i8

  %out = getelementptr inbounds [1024 x i8], ptr @B, i64 0, i64 %iv.0
  store i8 %reduce.add.4.narrow, i8* %out

  %iv.next = add nuw nsw i64 %iv.0, 6
  %cmp = icmp ult i64 %iv.next, 1024
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  ret void
}
