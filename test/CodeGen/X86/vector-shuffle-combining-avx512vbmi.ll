; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx512vbmi,+avx512vl | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512vbmi,+avx512vl | FileCheck %s --check-prefixes=CHECK,X64

declare <16 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.128(<16 x i8>, <16 x i8>, <16 x i8>, i16)
declare <16 x i8> @llvm.x86.avx512.mask.vpermt2var.qi.128(<16 x i8>, <16 x i8>, <16 x i8>, i16)
declare <16 x i8> @llvm.x86.avx512.maskz.vpermt2var.qi.128(<16 x i8>, <16 x i8>, <16 x i8>, i16)

declare <32 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.256(<32 x i8>, <32 x i8>, <32 x i8>, i32)
declare <32 x i8> @llvm.x86.avx512.mask.vpermt2var.qi.256(<32 x i8>, <32 x i8>, <32 x i8>, i32)
declare <32 x i8> @llvm.x86.avx512.maskz.vpermt2var.qi.256(<32 x i8>, <32 x i8>, <32 x i8>, i32)

declare <64 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)
declare <64 x i8> @llvm.x86.avx512.mask.vpermt2var.qi.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)
declare <64 x i8> @llvm.x86.avx512.maskz.vpermt2var.qi.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

declare <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8>, <16 x i8>)
declare <32 x i8> @llvm.x86.avx2.pshuf.b(<32 x i8>, <32 x i8>)
declare <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

define <16 x i8> @combine_vpermt2var_16i8_identity(<16 x i8> %x0, <16 x i8> %x1) {
; CHECK-LABEL: combine_vpermt2var_16i8_identity:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = call <16 x i8> @llvm.x86.avx512.maskz.vpermt2var.qi.128(<16 x i8> <i8 15, i8 14, i8 13, i8 12, i8 11, i8 10, i8 9, i8 8, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>, <16 x i8> %x0, <16 x i8> %x1, i16 -1)
  %res1 = call <16 x i8> @llvm.x86.avx512.maskz.vpermt2var.qi.128(<16 x i8> <i8 15, i8 30, i8 13, i8 28, i8 11, i8 26, i8 9, i8 24, i8 7, i8 22, i8 5, i8 20, i8 3, i8 18, i8 1, i8 16>, <16 x i8> %res0, <16 x i8> %res0, i16 -1)
  ret <16 x i8> %res1
}
define <16 x i8> @combine_vpermt2var_16i8_identity_mask(<16 x i8> %x0, <16 x i8> %x1, i16 %m) {
; X86-LABEL: combine_vpermt2var_16i8_identity_mask:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa {{.*#+}} xmm1 = [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpermi2b %xmm0, %xmm0, %xmm1 {%k1} {z}
; X86-NEXT:    vmovdqa {{.*#+}} xmm0 = [15,30,13,28,11,26,9,24,7,22,5,20,3,18,1,16]
; X86-NEXT:    vpermi2b %xmm1, %xmm1, %xmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: combine_vpermt2var_16i8_identity_mask:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa {{.*#+}} xmm1 = [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpermi2b %xmm0, %xmm0, %xmm1 {%k1} {z}
; X64-NEXT:    vmovdqa {{.*#+}} xmm0 = [15,30,13,28,11,26,9,24,7,22,5,20,3,18,1,16]
; X64-NEXT:    vpermi2b %xmm1, %xmm1, %xmm0 {%k1} {z}
; X64-NEXT:    retq
  %res0 = call <16 x i8> @llvm.x86.avx512.maskz.vpermt2var.qi.128(<16 x i8> <i8 15, i8 14, i8 13, i8 12, i8 11, i8 10, i8 9, i8 8, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>, <16 x i8> %x0, <16 x i8> %x1, i16 %m)
  %res1 = call <16 x i8> @llvm.x86.avx512.maskz.vpermt2var.qi.128(<16 x i8> <i8 15, i8 30, i8 13, i8 28, i8 11, i8 26, i8 9, i8 24, i8 7, i8 22, i8 5, i8 20, i8 3, i8 18, i8 1, i8 16>, <16 x i8> %res0, <16 x i8> %res0, i16 %m)
  ret <16 x i8> %res1
}

define <16 x i8> @combine_vpermi2var_16i8_as_vpshufb(<16 x i8> %x0, <16 x i8> %x1) {
; CHECK-LABEL: combine_vpermi2var_16i8_as_vpshufb:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[15,0,14,1,13,2,12,3,11,4,10,5,9,6,8,7]
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = call <16 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.128(<16 x i8> %x0, <16 x i8> <i8 15, i8 14, i8 13, i8 12, i8 11, i8 10, i8 9, i8 8, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>, <16 x i8> %x1, i16 -1)
  %res1 = call <16 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.128(<16 x i8> %res0, <16 x i8> <i8 0, i8 15, i8 1, i8 14, i8 2, i8 13, i8 3, i8 12, i8 4, i8 11, i8 5, i8 10, i8 6, i8 9, i8 7, i8 8>, <16 x i8> %res0, i16 -1)
  ret <16 x i8> %res1
}
define <32 x i8> @combine_vpermi2var_32i8_as_vpermb(<32 x i8> %x0, <32 x i8> %x1) {
; CHECK-LABEL: combine_vpermi2var_32i8_as_vpermb:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vbroadcasti128 {{.*#+}} ymm1 = [0,0,1,23,2,22,3,21,4,22,5,21,6,20,7,19,0,0,1,23,2,22,3,21,4,22,5,21,6,20,7,19]
; CHECK-NEXT:    # ymm1 = mem[0,1,0,1]
; CHECK-NEXT:    vpermb %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = shufflevector <32 x i8> %x0, <32 x i8> %x1, <32 x i32> <i32 0, i32 32, i32 1, i32 33, i32 2, i32 34, i32 3, i32 35, i32 4, i32 36, i32 5, i32 37, i32 6, i32 38, i32 7, i32 39, i32 16, i32 48, i32 17, i32 49, i32 18, i32 50, i32 19, i32 51, i32 20, i32 52, i32 21, i32 53, i32 22, i32 54, i32 23, i32 55>
  %res1 = call <32 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.256(<32 x i8> %res0, <32 x i8> <i8 0, i8 32, i8 2, i8 30, i8 4, i8 28, i8 6, i8 26, i8 8, i8 28, i8 10, i8 26, i8 12, i8 24, i8 14, i8 22, i8 0, i8 32, i8 2, i8 30, i8 4, i8 28, i8 6, i8 26, i8 8, i8 28, i8 10, i8 26, i8 12, i8 24, i8 14, i8 22>, <32 x i8> %res0, i32 -1)
  ret <32 x i8> %res1
}
define <64 x i8> @combine_vpermi2var_64i8_as_vpermb(<64 x i8> %x0, <64 x i8> %x1) {
; CHECK-LABEL: combine_vpermi2var_64i8_as_vpermb:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vbroadcasti32x4 {{.*#+}} zmm1 = [0,32,1,23,2,22,3,21,4,22,5,21,6,20,7,19,0,32,1,23,2,22,3,21,4,22,5,21,6,20,7,19,0,32,1,23,2,22,3,21,4,22,5,21,6,20,7,19,0,32,1,23,2,22,3,21,4,22,5,21,6,20,7,19]
; CHECK-NEXT:    # zmm1 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
; CHECK-NEXT:    vpermb %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = shufflevector <64 x i8> %x0, <64 x i8> %x1, <64 x i32> <i32 0, i32 64, i32 1, i32 65, i32 2, i32 66, i32 3, i32 67, i32 4, i32 68, i32 5, i32 69, i32 6, i32 70, i32 7, i32 71, i32 16, i32 80, i32 17, i32 81, i32 18, i32 82, i32 19, i32 83, i32 20, i32 84, i32 21, i32 85, i32 22, i32 86, i32 23, i32 87, i32 32, i32 96, i32 33, i32 97, i32 34, i32 98, i32 35, i32 99, i32 36, i32 100, i32 37, i32 101, i32 38, i32 102, i32 39, i32 103, i32 48, i32 112, i32 49, i32 113, i32 50, i32 114, i32 51, i32 115, i32 52, i32 116, i32 53, i32 117, i32 54, i32 118, i32 55, i32 119>
  %res1 = call <64 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.512(<64 x i8> %res0, <64 x i8> <i8 0, i8 32, i8 2, i8 30, i8 4, i8 28, i8 6, i8 26, i8 8, i8 28, i8 10, i8 26, i8 12, i8 24, i8 14, i8 22, i8 0, i8 32, i8 2, i8 30, i8 4, i8 28, i8 6, i8 26, i8 8, i8 28, i8 10, i8 26, i8 12, i8 24, i8 14, i8 22, i8 0, i8 32, i8 2, i8 30, i8 4, i8 28, i8 6, i8 26, i8 8, i8 28, i8 10, i8 26, i8 12, i8 24, i8 14, i8 22, i8 0, i8 32, i8 2, i8 30, i8 4, i8 28, i8 6, i8 26, i8 8, i8 28, i8 10, i8 26, i8 12, i8 24, i8 14, i8 22>, <64 x i8> %res0, i64 -1)
  ret <64 x i8> %res1
}

define <16 x i8> @combine_vpermt2var_vpermi2var_16i8_as_vperm2(<16 x i8> %x0, <16 x i8> %x1) {
; CHECK-LABEL: combine_vpermt2var_vpermi2var_16i8_as_vperm2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa {{.*#+}} xmm2 = [0,31,2,2,4,29,6,27,8,25,10,23,12,21,14,19]
; CHECK-NEXT:    vpermt2b %xmm1, %xmm2, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = call <16 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.128(<16 x i8> %x0, <16 x i8> <i8 0, i8 31, i8 2, i8 29, i8 4, i8 27, i8 6, i8 25, i8 8, i8 23, i8 10, i8 21, i8 12, i8 19, i8 14, i8 17>, <16 x i8> %x1, i16 -1)
  %res1 = call <16 x i8> @llvm.x86.avx512.maskz.vpermt2var.qi.128(<16 x i8> <i8 0, i8 17, i8 2, i8 18, i8 4, i8 19, i8 6, i8 21, i8 8, i8 23, i8 10, i8 25, i8 12, i8 27, i8 14, i8 29>, <16 x i8> %res0, <16 x i8> %res0, i16 -1)
  ret <16 x i8> %res1
}
define <32 x i8> @combine_vpermi2var_32i8_as_vperm2(<32 x i8> %x0, <32 x i8> %x1) {
; CHECK-LABEL: combine_vpermi2var_32i8_as_vperm2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vbroadcasti128 {{.*#+}} ymm2 = [0,32,1,23,2,22,3,21,4,22,5,21,6,20,7,19,0,32,1,23,2,22,3,21,4,22,5,21,6,20,7,19]
; CHECK-NEXT:    # ymm2 = mem[0,1,0,1]
; CHECK-NEXT:    vpermt2b %ymm1, %ymm2, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = shufflevector <32 x i8> %x0, <32 x i8> %x1, <32 x i32> <i32 0, i32 32, i32 1, i32 33, i32 2, i32 34, i32 3, i32 35, i32 4, i32 36, i32 5, i32 37, i32 6, i32 38, i32 7, i32 39, i32 16, i32 48, i32 17, i32 49, i32 18, i32 50, i32 19, i32 51, i32 20, i32 52, i32 21, i32 53, i32 22, i32 54, i32 23, i32 55>
  %res1 = call <32 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.256(<32 x i8> %res0, <32 x i8> <i8 0, i8 32, i8 2, i8 30, i8 4, i8 28, i8 6, i8 26, i8 8, i8 28, i8 10, i8 26, i8 12, i8 24, i8 14, i8 22, i8 0, i8 32, i8 2, i8 30, i8 4, i8 28, i8 6, i8 26, i8 8, i8 28, i8 10, i8 26, i8 12, i8 24, i8 14, i8 22>, <32 x i8> %x1, i32 -1)
  ret <32 x i8> %res1
}
define <64 x i8> @combine_vpermi2var_64i8_as_vperm2(<64 x i8> %x0, <64 x i8> %x1) {
; CHECK-LABEL: combine_vpermi2var_64i8_as_vperm2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [0,80,1,70,2,54,3,49,4,36,5,23,6,18,7,5,0,90,1,100,2,110,3,120,4,22,5,21,6,20,7,19,0,32,1,23,2,22,3,21,4,22,5,21,6,20,7,19,0,32,1,23,2,22,3,21,4,22,5,21,6,20,7,19]
; CHECK-NEXT:    vpermt2b %zmm1, %zmm2, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = shufflevector <64 x i8> %x0, <64 x i8> %x1, <64 x i32> <i32 0, i32 64, i32 1, i32 65, i32 2, i32 66, i32 3, i32 67, i32 4, i32 68, i32 5, i32 69, i32 6, i32 70, i32 7, i32 71, i32 16, i32 80, i32 17, i32 81, i32 18, i32 82, i32 19, i32 83, i32 20, i32 84, i32 21, i32 85, i32 22, i32 86, i32 23, i32 87, i32 32, i32 96, i32 33, i32 97, i32 34, i32 98, i32 35, i32 99, i32 36, i32 100, i32 37, i32 101, i32 38, i32 102, i32 39, i32 103, i32 48, i32 112, i32 49, i32 113, i32 50, i32 114, i32 51, i32 115, i32 52, i32 116, i32 53, i32 117, i32 54, i32 118, i32 55, i32 119>
  %res1 = call <64 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.512(<64 x i8> %res0, <64 x i8> <i8 0, i8 80, i8 2, i8 70, i8 4, i8 60, i8 6, i8 50, i8 8, i8 40, i8 10, i8 30, i8 12, i8 20, i8 14, i8 10, i8 0, i8 90, i8 2, i8 100, i8 4, i8 110, i8 6, i8 120, i8 8, i8 28, i8 10, i8 26, i8 12, i8 24, i8 14, i8 22, i8 0, i8 32, i8 2, i8 30, i8 4, i8 28, i8 6, i8 26, i8 8, i8 28, i8 10, i8 26, i8 12, i8 24, i8 14, i8 22, i8 0, i8 32, i8 2, i8 30, i8 4, i8 28, i8 6, i8 26, i8 8, i8 28, i8 10, i8 26, i8 12, i8 24, i8 14, i8 22>, <64 x i8> %x1, i64 -1)
  ret <64 x i8> %res1
}

define <64 x i8> @combine_permi2q_pshufb_as_permi2d(<8 x i64> %a0, <8 x i64> %a1) {
; CHECK-LABEL: combine_permi2q_pshufb_as_permi2d:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [14,14,14,14,11,11,11,11,24,24,24,24,29,29,29,29]
; CHECK-NEXT:    vpermi2d %zmm0, %zmm1, %zmm2
; CHECK-NEXT:    vmovdqa64 %zmm2, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = shufflevector <8 x i64> %a0, <8 x i64> %a1, <8 x i32> <i32 15, i32 0, i32 13, i32 2, i32 11, i32 4, i32 9, i32 6>
  %res1 = bitcast <8 x i64> %res0 to <64 x i8>
  %res2 = call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %res1, <64 x i8> <i8 0, i8 1, i8 2, i8 3, i8 0, i8 1, i8 2, i8 3, i8 0, i8 1, i8 2, i8 3, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 4, i8 5, i8 6, i8 7, i8 4, i8 5, i8 6, i8 7, i8 4, i8 5, i8 6, i8 7, i8 8, i8 9, i8 10, i8 11, i8 8, i8 9, i8 10, i8 11, i8 8, i8 9, i8 10, i8 11, i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15, i8 12, i8 13, i8 14, i8 15, i8 12, i8 13, i8 14, i8 15, i8 12, i8 13, i8 14, i8 15>, <64 x i8> undef, i64 -1)
  ret <64 x i8> %res2
}
define <64 x i8> @combine_permi2q_pshufb_as_permi2d_mask(<8 x i64> %a0, <8 x i64> %a1, i64 %m) {
; X86-LABEL: combine_permi2q_pshufb_as_permi2d_mask:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [56,57,58,59,56,57,58,59,56,57,58,59,56,57,58,59,44,45,46,47,44,45,46,47,44,45,46,47,44,45,46,47,96,97,98,99,96,97,98,99,96,97,98,99,96,97,98,99,116,117,118,119,116,117,118,119,116,117,118,119,116,117,118,119]
; X86-NEXT:    kmovq {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpermi2b %zmm0, %zmm1, %zmm2 {%k1} {z}
; X86-NEXT:    vmovdqa64 %zmm2, %zmm0
; X86-NEXT:    retl
;
; X64-LABEL: combine_permi2q_pshufb_as_permi2d_mask:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [56,57,58,59,56,57,58,59,56,57,58,59,56,57,58,59,44,45,46,47,44,45,46,47,44,45,46,47,44,45,46,47,96,97,98,99,96,97,98,99,96,97,98,99,96,97,98,99,116,117,118,119,116,117,118,119,116,117,118,119,116,117,118,119]
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vpermi2b %zmm0, %zmm1, %zmm2 {%k1} {z}
; X64-NEXT:    vmovdqa64 %zmm2, %zmm0
; X64-NEXT:    retq
  %res0 = shufflevector <8 x i64> %a0, <8 x i64> %a1, <8 x i32> <i32 15, i32 0, i32 13, i32 2, i32 11, i32 4, i32 9, i32 6>
  %res1 = bitcast <8 x i64> %res0 to <64 x i8>
  %res2 = call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %res1, <64 x i8> <i8 0, i8 1, i8 2, i8 3, i8 0, i8 1, i8 2, i8 3, i8 0, i8 1, i8 2, i8 3, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 4, i8 5, i8 6, i8 7, i8 4, i8 5, i8 6, i8 7, i8 4, i8 5, i8 6, i8 7, i8 8, i8 9, i8 10, i8 11, i8 8, i8 9, i8 10, i8 11, i8 8, i8 9, i8 10, i8 11, i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15, i8 12, i8 13, i8 14, i8 15, i8 12, i8 13, i8 14, i8 15, i8 12, i8 13, i8 14, i8 15>, <64 x i8> zeroinitializer, i64 %m)
  ret <64 x i8> %res2
}
