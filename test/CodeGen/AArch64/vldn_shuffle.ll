; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-eabif | FileCheck %s

define void @vld2(float* nocapture readonly %pSrc, float* noalias nocapture %pDst, i32 %numSamples) {
; CHECK-LABEL: vld2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:  .LBB0_1: // %vector.body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ld2 { v0.4s, v1.4s }, [x0], #32
; CHECK-NEXT:    fmul v2.4s, v0.4s, v0.4s
; CHECK-NEXT:    fmla v2.4s, v1.4s, v1.4s
; CHECK-NEXT:    str q2, [x1, x8]
; CHECK-NEXT:    add x8, x8, #16
; CHECK-NEXT:    cmp x8, #1, lsl #12 // =4096
; CHECK-NEXT:    b.ne .LBB0_1
; CHECK-NEXT:  // %bb.2: // %while.end
; CHECK-NEXT:    ret
entry:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = shl i64 %index, 1
  %next.gep = getelementptr float, float* %pSrc, i64 %0
  %next.gep19 = getelementptr float, float* %pDst, i64 %index
  %1 = bitcast float* %next.gep to <8 x float>*
  %wide.vec = load <8 x float>, <8 x float>* %1, align 4
  %2 = fmul fast <8 x float> %wide.vec, %wide.vec
  %3 = shufflevector <8 x float> %2, <8 x float> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %4 = fmul fast <8 x float> %wide.vec, %wide.vec
  %5 = shufflevector <8 x float> %4, <8 x float> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %6 = fadd fast <4 x float> %5, %3
  %7 = bitcast float* %next.gep19 to <4 x float>*
  store <4 x float> %6, <4 x float>* %7, align 4
  %index.next = add i64 %index, 4
  %8 = icmp eq i64 %index.next, 1024
  br i1 %8, label %while.end, label %vector.body

while.end:                                        ; preds = %vector.body
  ret void
}

define void @vld3(float* nocapture readonly %pSrc, float* noalias nocapture %pDst, i32 %numSamples) {
; CHECK-LABEL: vld3:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:  .LBB1_1: // %vector.body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ld3 { v0.4s, v1.4s, v2.4s }, [x0], #48
; CHECK-NEXT:    fmul v3.4s, v0.4s, v0.4s
; CHECK-NEXT:    fmla v3.4s, v1.4s, v1.4s
; CHECK-NEXT:    fmla v3.4s, v2.4s, v2.4s
; CHECK-NEXT:    str q3, [x1, x8]
; CHECK-NEXT:    add x8, x8, #16
; CHECK-NEXT:    cmp x8, #1, lsl #12 // =4096
; CHECK-NEXT:    b.ne .LBB1_1
; CHECK-NEXT:  // %bb.2: // %while.end
; CHECK-NEXT:    ret
entry:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = mul i64 %index, 3
  %next.gep = getelementptr float, float* %pSrc, i64 %0
  %next.gep23 = getelementptr float, float* %pDst, i64 %index
  %1 = bitcast float* %next.gep to <12 x float>*
  %wide.vec = load <12 x float>, <12 x float>* %1, align 4
  %2 = fmul fast <12 x float> %wide.vec, %wide.vec
  %3 = shufflevector <12 x float> %2, <12 x float> undef, <4 x i32> <i32 0, i32 3, i32 6, i32 9>
  %4 = fmul fast <12 x float> %wide.vec, %wide.vec
  %5 = shufflevector <12 x float> %4, <12 x float> undef, <4 x i32> <i32 1, i32 4, i32 7, i32 10>
  %6 = fadd fast <4 x float> %5, %3
  %7 = fmul fast <12 x float> %wide.vec, %wide.vec
  %8 = shufflevector <12 x float> %7, <12 x float> undef, <4 x i32> <i32 2, i32 5, i32 8, i32 11>
  %9 = fadd fast <4 x float> %6, %8
  %10 = bitcast float* %next.gep23 to <4 x float>*
  store <4 x float> %9, <4 x float>* %10, align 4
  %index.next = add i64 %index, 4
  %11 = icmp eq i64 %index.next, 1024
  br i1 %11, label %while.end, label %vector.body

while.end:                                        ; preds = %vector.body
  ret void
}

define void @vld4(float* nocapture readonly %pSrc, float* noalias nocapture %pDst, i32 %numSamples) {
; CHECK-LABEL: vld4:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:  .LBB2_1: // %vector.body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ld4 { v0.4s, v1.4s, v2.4s, v3.4s }, [x0], #64
; CHECK-NEXT:    add x9, x1, x8
; CHECK-NEXT:    add x8, x8, #32
; CHECK-NEXT:    cmp x8, #2, lsl #12 // =8192
; CHECK-NEXT:    fmul v4.4s, v0.4s, v0.4s
; CHECK-NEXT:    fmla v4.4s, v1.4s, v1.4s
; CHECK-NEXT:    fmul v5.4s, v2.4s, v2.4s
; CHECK-NEXT:    fmla v5.4s, v3.4s, v3.4s
; CHECK-NEXT:    st2 { v4.4s, v5.4s }, [x9]
; CHECK-NEXT:    b.ne .LBB2_1
; CHECK-NEXT:  // %bb.2: // %while.end
; CHECK-NEXT:    ret
entry:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = shl i64 %index, 2
  %next.gep = getelementptr float, float* %pSrc, i64 %0
  %1 = shl i64 %index, 1
  %2 = bitcast float* %next.gep to <16 x float>*
  %wide.vec = load <16 x float>, <16 x float>* %2, align 4
  %3 = fmul fast <16 x float> %wide.vec, %wide.vec
  %4 = shufflevector <16 x float> %3, <16 x float> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %5 = fmul fast <16 x float> %wide.vec, %wide.vec
  %6 = shufflevector <16 x float> %5, <16 x float> undef, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %7 = fadd fast <4 x float> %6, %4
  %8 = fmul fast <16 x float> %wide.vec, %wide.vec
  %9 = shufflevector <16 x float> %8, <16 x float> undef, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %10 = fmul fast <16 x float> %wide.vec, %wide.vec
  %11 = shufflevector <16 x float> %10, <16 x float> undef, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %12 = fadd fast <4 x float> %11, %9
  %13 = getelementptr inbounds float, float* %pDst, i64 %1
  %14 = bitcast float* %13 to <8 x float>*
  %interleaved.vec = shufflevector <4 x float> %7, <4 x float> %12, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  store <8 x float> %interleaved.vec, <8 x float>* %14, align 4
  %index.next = add i64 %index, 4
  %15 = icmp eq i64 %index.next, 1024
  br i1 %15, label %while.end, label %vector.body

while.end:                                        ; preds = %vector.body
  ret void
}

define void @twosrc(float* nocapture readonly %pSrc, float* nocapture readonly %pSrc2, float* noalias nocapture %pDst, i32 %numSamples) {
; CHECK-LABEL: twosrc:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:  .LBB3_1: // %vector.body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add x9, x0, x8
; CHECK-NEXT:    add x10, x1, x8
; CHECK-NEXT:    ld2 { v0.4s, v1.4s }, [x9]
; CHECK-NEXT:    ld2 { v2.4s, v3.4s }, [x10]
; CHECK-NEXT:    add x8, x8, #32
; CHECK-NEXT:    cmp x8, #2, lsl #12 // =8192
; CHECK-NEXT:    fmul v4.4s, v2.4s, v0.4s
; CHECK-NEXT:    fmla v4.4s, v1.4s, v3.4s
; CHECK-NEXT:    str q4, [x2], #16
; CHECK-NEXT:    b.ne .LBB3_1
; CHECK-NEXT:  // %bb.2: // %while.end
; CHECK-NEXT:    ret
entry:
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = shl i64 %index, 1
  %next.gep = getelementptr float, float* %pSrc, i64 %0
  %1 = shl i64 %index, 1
  %next.gep23 = getelementptr float, float* %pSrc2, i64 %1
  %next.gep24 = getelementptr float, float* %pDst, i64 %index
  %2 = bitcast float* %next.gep to <8 x float>*
  %wide.vec = load <8 x float>, <8 x float>* %2, align 4
  %3 = bitcast float* %next.gep23 to <8 x float>*
  %wide.vec26 = load <8 x float>, <8 x float>* %3, align 4
  %4 = fmul fast <8 x float> %wide.vec26, %wide.vec
  %5 = shufflevector <8 x float> %4, <8 x float> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %6 = fmul fast <8 x float> %wide.vec26, %wide.vec
  %7 = shufflevector <8 x float> %6, <8 x float> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %8 = fadd fast <4 x float> %7, %5
  %9 = bitcast float* %next.gep24 to <4 x float>*
  store <4 x float> %8, <4 x float>* %9, align 4
  %index.next = add i64 %index, 4
  %10 = icmp eq i64 %index.next, 1024
  br i1 %10, label %while.end, label %vector.body

while.end:                                        ; preds = %vector.body
  ret void
}
