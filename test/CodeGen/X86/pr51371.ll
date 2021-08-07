; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s --mtriple=x86_64-unknown-linux-gnu -mattr=+sse4.1 | FileCheck %s

define void @pmuldq(<2 x i64>* nocapture %0, i32 %1, i64 %2) {
; CHECK-LABEL: pmuldq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testq %rdx, %rdx
; CHECK-NEXT:    je .LBB0_3
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    movd %esi, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_2: # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movdqa (%rdi), %xmm1
; CHECK-NEXT:    pmuldq %xmm0, %xmm1
; CHECK-NEXT:    movdqa %xmm1, (%rdi)
; CHECK-NEXT:    addq $16, %rdi
; CHECK-NEXT:    decq %rdx
; CHECK-NEXT:    jne .LBB0_2
; CHECK-NEXT:  .LBB0_3:
; CHECK-NEXT:    retq
  %4 = insertelement <4 x i32> undef, i32 %1, i32 0
  %5 = shufflevector <4 x i32> %4, <4 x i32> poison, <4 x i32> zeroinitializer
  %6 = bitcast <4 x i32> %5 to <2 x i64>
  %7 = shl <2 x i64> %6, <i64 32, i64 32>
  %8 = ashr exact <2 x i64> %7, <i64 32, i64 32>
  %9 = icmp eq i64 %2, 0
  br i1 %9, label %10, label %11

10:                                               ; preds = %11, %3
  ret void

11:                                               ; preds = %3, %11
  %12 = phi i64 [ %18, %11 ], [ 0, %3 ]
  %13 = getelementptr inbounds <2 x i64>, <2 x i64>* %0, i64 %12
  %14 = load <2 x i64>, <2 x i64>* %13, align 16
  %15 = shl <2 x i64> %14, <i64 32, i64 32>
  %16 = ashr exact <2 x i64> %15, <i64 32, i64 32>
  %17 = mul nsw <2 x i64> %16, %8
  store <2 x i64> %17, <2 x i64>* %13, align 16
  %18 = add nuw i64 %12, 1
  %19 = icmp eq i64 %18, %2
  br i1 %19, label %10, label %11
}

define void @pmuludq(<2 x i64>* nocapture %0, i32 %1, i64 %2) {
; CHECK-LABEL: pmuludq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testq %rdx, %rdx
; CHECK-NEXT:    je .LBB1_3
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    movd %esi, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB1_2: # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movdqa (%rdi), %xmm1
; CHECK-NEXT:    pmuludq %xmm0, %xmm1
; CHECK-NEXT:    movdqa %xmm1, (%rdi)
; CHECK-NEXT:    addq $16, %rdi
; CHECK-NEXT:    decq %rdx
; CHECK-NEXT:    jne .LBB1_2
; CHECK-NEXT:  .LBB1_3:
; CHECK-NEXT:    retq
  %4 = insertelement <4 x i32> undef, i32 %1, i32 0
  %5 = shufflevector <4 x i32> %4, <4 x i32> poison, <4 x i32> zeroinitializer
  %6 = bitcast <4 x i32> %5 to <2 x i64>
  %7 = and <2 x i64> %6, <i64 4294967295, i64 4294967295>
  %8 = icmp eq i64 %2, 0
  br i1 %8, label %9, label %10

9:                                                ; preds = %10, %3
  ret void

10:                                               ; preds = %3, %10
  %11 = phi i64 [ %16, %10 ], [ 0, %3 ]
  %12 = getelementptr inbounds <2 x i64>, <2 x i64>* %0, i64 %11
  %13 = load <2 x i64>, <2 x i64>* %12, align 16
  %14 = and <2 x i64> %13, <i64 4294967295, i64 4294967295>
  %15 = mul nuw <2 x i64> %14, %7
  store <2 x i64> %15, <2 x i64>* %12, align 16
  %16 = add nuw i64 %11, 1
  %17 = icmp eq i64 %16, %2
  br i1 %17, label %9, label %10
}
