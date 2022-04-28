; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux -opaque-pointers -mcpu=ivybridge -mattr=+avx2 | FileCheck %s --check-prefixes=IVB
; RUN: llc < %s -mtriple=x86_64-linux -opaque-pointers -mcpu=haswell | FileCheck %s --check-prefixes=HSW

define <2 x i64> @PR55158(ptr %0) {
; IVB-LABEL: PR55158:
; IVB:       # %bb.0:
; IVB-NEXT:    vmovdqa 64(%rdi), %xmm0
; IVB-NEXT:    vmovdqa 128(%rdi), %xmm1
; IVB-NEXT:    vpmovsxbd (%rdi), %xmm2
; IVB-NEXT:    vpcmpgtd %xmm2, %xmm1, %xmm1
; IVB-NEXT:    vphsubw %xmm0, %xmm0, %xmm0
; IVB-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero
; IVB-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; IVB-NEXT:    vpsrlvq %xmm1, %xmm2, %xmm1
; IVB-NEXT:    vpunpckhqdq {{.*#+}} xmm0 = xmm1[1],xmm0[1]
; IVB-NEXT:    retq
;
; HSW-LABEL: PR55158:
; HSW:       # %bb.0:
; HSW-NEXT:    vmovdqa 64(%rdi), %xmm0
; HSW-NEXT:    vmovdqa 128(%rdi), %xmm1
; HSW-NEXT:    vpmovsxbd (%rdi), %xmm2
; HSW-NEXT:    vpcmpgtd %xmm2, %xmm1, %xmm1
; HSW-NEXT:    vphsubw %xmm0, %xmm0, %xmm0
; HSW-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero
; HSW-NEXT:    vpandn {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm2
; HSW-NEXT:    vpsrlvq %xmm1, %xmm2, %xmm1
; HSW-NEXT:    vpunpckhqdq {{.*#+}} xmm0 = xmm1[1],xmm0[1]
; HSW-NEXT:    retq
  %2 = load <16 x i8>, ptr %0, align 16
  %3 = getelementptr inbounds i32, ptr %0, i64 16
  %4 = load <8 x i16>, ptr %3, align 16
  %5 = getelementptr inbounds i32, ptr %0, i64 32
  %6 = load <4 x i32>, ptr %5, align 16
  %7 = shufflevector <16 x i8> %2, <16 x i8> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %8 = sext <4 x i8> %7 to <4 x i32>
  %9 = icmp sgt <4 x i32> %6, %8
  %10 = sext <4 x i1> %9 to <4 x i32>
  %11 = tail call <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16> %4, <8 x i16> %4)
  %12 = bitcast <8 x i16> %11 to <2 x i64>
  %13 = shufflevector <4 x i32> %10, <4 x i32> poison, <2 x i32> <i32 0, i32 1>
  %14 = zext <2 x i32> %13 to <2 x i64>
  %15 = bitcast <8 x i16> %11 to <16 x i8>
  %16 = icmp ne <16 x i8> %15, zeroinitializer
  %17 = sext <16 x i1> %16 to <16 x i8>
  %18 = shufflevector <16 x i8> %17, <16 x i8> poison, <2 x i32> <i32 0, i32 1>
  %19 = zext <2 x i8> %18 to <2 x i64>
  %20 = insertelement <2 x i64> %19, i64 0, i64 1
  %21 = tail call <2 x i64> @llvm.x86.avx2.psrlv.q(<2 x i64> %20, <2 x i64> %14)
  %22 = shufflevector <2 x i64> %21, <2 x i64> %12, <2 x i32> <i32 1, i32 3>
  ret <2 x i64> %22
}
declare <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16>, <8 x i16>)
declare <2 x i64> @llvm.x86.avx2.psrlv.q(<2 x i64>, <2 x i64>)
