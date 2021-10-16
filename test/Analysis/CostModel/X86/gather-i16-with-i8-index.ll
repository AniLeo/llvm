; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+sse2 --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefixes=CHECK,SSE2
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+sse42 --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefixes=CHECK,SSE42
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx  --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefixes=CHECK,AVX1
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx2,-fast-gather --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefixes=CHECK,AVX2-SLOWGATHER
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx2,+fast-gather --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefixes=CHECK,AVX2-FASTGATHER
; RUN: opt -loop-vectorize -vectorizer-maximize-bandwidth -S -mattr=+avx512bw --debug-only=loop-vectorize < %s 2>&1 | FileCheck %s --check-prefixes=CHECK,AVX512

; REQUIRES: asserts

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@A = global [1024 x i8] zeroinitializer, align 128
@B = global [1024 x i16] zeroinitializer, align 128
@C = global [1024 x i16] zeroinitializer, align 128

; CHECK: LV: Checking a loop in "test"
;
; SSE2: LV: Found an estimated cost of 1 for VF 1 For instruction:   %valB = load i16, i16* %inB, align 2
; SSE2: LV: Found an estimated cost of 24 for VF 2 For instruction:   %valB = load i16, i16* %inB, align 2
; SSE2: LV: Found an estimated cost of 48 for VF 4 For instruction:   %valB = load i16, i16* %inB, align 2
; SSE2: LV: Found an estimated cost of 96 for VF 8 For instruction:   %valB = load i16, i16* %inB, align 2
; SSE2: LV: Found an estimated cost of 192 for VF 16 For instruction:   %valB = load i16, i16* %inB, align 2
;
; SSE42: LV: Found an estimated cost of 1 for VF 1 For instruction:   %valB = load i16, i16* %inB, align 2
; SSE42: LV: Found an estimated cost of 24 for VF 2 For instruction:   %valB = load i16, i16* %inB, align 2
; SSE42: LV: Found an estimated cost of 48 for VF 4 For instruction:   %valB = load i16, i16* %inB, align 2
; SSE42: LV: Found an estimated cost of 96 for VF 8 For instruction:   %valB = load i16, i16* %inB, align 2
; SSE42: LV: Found an estimated cost of 192 for VF 16 For instruction:   %valB = load i16, i16* %inB, align 2
;
; AVX1: LV: Found an estimated cost of 1 for VF 1 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX1: LV: Found an estimated cost of 24 for VF 2 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX1: LV: Found an estimated cost of 48 for VF 4 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX1: LV: Found an estimated cost of 96 for VF 8 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX1: LV: Found an estimated cost of 194 for VF 16 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX1: LV: Found an estimated cost of 388 for VF 32 For instruction:   %valB = load i16, i16* %inB, align 2
;
; AVX2-SLOWGATHER: LV: Found an estimated cost of 1 for VF 1 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX2-SLOWGATHER: LV: Found an estimated cost of 24 for VF 2 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX2-SLOWGATHER: LV: Found an estimated cost of 48 for VF 4 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX2-SLOWGATHER: LV: Found an estimated cost of 96 for VF 8 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX2-SLOWGATHER: LV: Found an estimated cost of 194 for VF 16 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX2-SLOWGATHER: LV: Found an estimated cost of 388 for VF 32 For instruction:   %valB = load i16, i16* %inB, align 2
;
; AVX2-FASTGATHER: LV: Found an estimated cost of 1 for VF 1 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX2-FASTGATHER: LV: Found an estimated cost of 26 for VF 2 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX2-FASTGATHER: LV: Found an estimated cost of 54 for VF 4 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX2-FASTGATHER: LV: Found an estimated cost of 108 for VF 8 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX2-FASTGATHER: LV: Found an estimated cost of 218 for VF 16 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX2-FASTGATHER: LV: Found an estimated cost of 436 for VF 32 For instruction:   %valB = load i16, i16* %inB, align 2
;
; AVX512: LV: Found an estimated cost of 1 for VF 1 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX512: LV: Found an estimated cost of 26 for VF 2 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX512: LV: Found an estimated cost of 54 for VF 4 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX512: LV: Found an estimated cost of 110 for VF 8 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX512: LV: Found an estimated cost of 222 for VF 16 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX512: LV: Found an estimated cost of 444 for VF 32 For instruction:   %valB = load i16, i16* %inB, align 2
; AVX512: LV: Found an estimated cost of 888 for VF 64 For instruction:   %valB = load i16, i16* %inB, align 2
;
; CHECK-NOT: LV: Found an estimated cost of {{[0-9]+}} for VF {{[0-9]+}} For instruction:   %valB = load i16, i16* %inB, align 4
define void @test() {
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]

  %inA = getelementptr inbounds [1024 x i8], [1024 x i8]* @A, i64 0, i64 %iv
  %valA = load i8, i8* %inA
  %valA.ext = sext i8 %valA to i64

  %inB = getelementptr inbounds [1024 x i16], [1024 x i16]* @B, i64 0, i64 %valA.ext
  %valB = load i16, i16* %inB

  %out = getelementptr inbounds [1024 x i16], [1024 x i16]* @C, i64 0, i64 %iv
  store i16 %valB, i16* %out

  %iv.next = add nuw nsw i64 %iv, 1
  %cmp = icmp ult i64 %iv.next, 1024
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  ret void
}
