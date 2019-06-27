; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-pc-linux  -mattr=+avx2 | FileCheck %s

define <32 x i8> @foo(<48 x i8>* %x0, <16 x i32> %x1, <16 x i32> %x2) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqu 32(%rdi), %xmm0
; CHECK-NEXT:    vmovdqu (%rdi), %ymm1
; CHECK-NEXT:    vmovdqu 16(%rdi), %xmm2
; CHECK-NEXT:    vpshufb {{.*#+}} xmm2 = xmm2[u,u,u,u,u,u,u,u,u,u,u,0,2,3,5,6]
; CHECK-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[0,1,3,4,6,7,9,10,12,13,15,u,u,u,u,u,24,25,27,28,30,31,u,u,u,u,u,u,u,u,u,u]
; CHECK-NEXT:    vmovdqa {{.*#+}} ymm3 = <255,255,255,255,255,255,255,255,255,255,255,0,0,0,0,0,255,255,255,255,255,255,u,u,u,u,u,u,u,u,u,u>
; CHECK-NEXT:    vpblendvb %ymm3, %ymm1, %ymm2, %ymm1
; CHECK-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[u,u,u,u,u,u,1,2,4,5,7,8,10,11,13,14]
; CHECK-NEXT:    vinserti128 $1, %xmm0, %ymm0, %ymm0
; CHECK-NEXT:    vpblendw {{.*#+}} ymm0 = ymm1[0,1,2],ymm0[3,4,5,6,7],ymm1[8,9,10],ymm0[11,12,13,14,15]
; CHECK-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; CHECK-NEXT:    retq
  %1 = load <48 x i8>, <48 x i8>* %x0, align 1
  %2 = shufflevector <48 x i8> %1, <48 x i8> undef, <32 x i32> <i32 0, i32 1, i32 3, i32 4, i32 6, i32 7, i32 9, i32 10, i32 12, i32 13, i32 15, i32 16, i32 18, i32 19, i32 21, i32 22, i32 24, i32 25, i32 27, i32 28, i32 30, i32 31, i32 33, i32 34, i32 36, i32 37, i32 39, i32 40, i32 42, i32 43, i32 45, i32 46>
  ret <32 x i8> %2
}
