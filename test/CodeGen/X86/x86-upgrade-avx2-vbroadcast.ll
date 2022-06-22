; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-macosx10.10.0 -mattr=+avx2 | FileCheck %s

; Check that we properly upgrade the AVX2 vbroadcast intrinsic to IR.

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

define <4 x i64> @broadcast128(<2 x i64> %src) {
; CHECK-LABEL: broadcast128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; CHECK-NEXT:    retq
  %1 = alloca <2 x i64>, align 16
  store <2 x i64> %src, ptr %1, align 16
  %2 = call <4 x i64> @llvm.x86.avx2.vbroadcasti128(ptr %1)
  ret <4 x i64> %2
}

declare <4 x i64> @llvm.x86.avx2.vbroadcasti128(ptr) #1
