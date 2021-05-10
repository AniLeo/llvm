; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin -mattr=+avx2 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx2 | FileCheck %s

define <16 x i8> @permute_packss_packss_128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2, <4 x i32> %a3) {
; CHECK-LABEL: permute_packss_packss_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpackssdw %xmm3, %xmm2, %xmm1
; CHECK-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,2,3,0]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> %a0, <4 x i32> %a1)
  %2 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> %a2, <4 x i32> %a3)
  %3 = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> %1, <8 x i16> %2)
  %4 = shufflevector <16 x i8> %3, <16 x i8> poison, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1, i32 2, i32 3>
  ret <16 x i8> %4
}

define <16 x i8> @permute_packss_packus_128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2, <4 x i32> %a3) {
; CHECK-LABEL: permute_packss_packus_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpackusdw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpackusdw %xmm3, %xmm2, %xmm1
; CHECK-NEXT:    vpackuswb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,2,3,0]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> %a0, <4 x i32> %a1)
  %2 = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> %a2, <4 x i32> %a3)
  %3 = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> %1, <8 x i16> %2)
  %4 = shufflevector <16 x i8> %3, <16 x i8> poison, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1, i32 2, i32 3>
  ret <16 x i8> %4
}

declare <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16>, <8 x i16>)
declare <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32>, <4 x i32>)
declare <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16>, <8 x i16>)
declare <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32>, <4 x i32>)
