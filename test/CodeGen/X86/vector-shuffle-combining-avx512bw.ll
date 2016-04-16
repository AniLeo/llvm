; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512bw | FileCheck %s

declare <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

declare <8 x double> @llvm.x86.avx512.maskz.vpermt2var.pd.512(<8 x i64>, <8 x double>, <8 x double>, i8)
declare <16 x float> @llvm.x86.avx512.maskz.vpermt2var.ps.512(<16 x i32>, <16 x float>, <16 x float>, i16)

declare <8 x i64> @llvm.x86.avx512.maskz.vpermt2var.q.512(<8 x i64>, <8 x i64>, <8 x i64>, i8)
declare <16 x i32> @llvm.x86.avx512.maskz.vpermt2var.d.512(<16 x i32>, <16 x i32>, <16 x i32>, i16)
declare <32 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.512(<32 x i16>, <32 x i16>, <32 x i16>, i32)

define <8 x double> @combine_vpermt2var_8f64_identity(<8 x double> %x0, <8 x double> %x1) {
; CHECK-LABEL: combine_vpermt2var_8f64_identity:
; CHECK:       # BB#0:
; CHECK-NEXT:    retq
  %res0 = call <8 x double> @llvm.x86.avx512.maskz.vpermt2var.pd.512(<8 x i64> <i64 7, i64 6, i64 5, i64 4, i64 3, i64 2, i64 1, i64 0>, <8 x double> %x0, <8 x double> %x1, i8 -1)
  %res1 = call <8 x double> @llvm.x86.avx512.maskz.vpermt2var.pd.512(<8 x i64> <i64 7, i64 14, i64 5, i64 12, i64 3, i64 10, i64 1, i64 8>, <8 x double> %res0, <8 x double> %res0, i8 -1)
  ret <8 x double> %res1
}

define <8 x double> @combine_vpermt2var_8f64_movddup(<8 x double> %x0, <8 x double> %x1) {
; CHECK-LABEL: combine_vpermt2var_8f64_movddup:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [0,0,2,2,4,4,6,6]
; CHECK-NEXT:    vpermt2pd %zmm1, %zmm2, %zmm0
; CHECK-NEXT:    retq
  %res0 = call <8 x double> @llvm.x86.avx512.maskz.vpermt2var.pd.512(<8 x i64> <i64 0, i64 0, i64 2, i64 2, i64 4, i64 4, i64 6, i64 6>, <8 x double> %x0, <8 x double> %x1, i8 -1)
  ret <8 x double> %res0
}

define <8 x i64> @combine_vpermt2var_8i64_identity(<8 x i64> %x0, <8 x i64> %x1) {
; CHECK-LABEL: combine_vpermt2var_8i64_identity:
; CHECK:       # BB#0:
; CHECK-NEXT:    retq
  %res0 = call <8 x i64> @llvm.x86.avx512.maskz.vpermt2var.q.512(<8 x i64> <i64 7, i64 6, i64 5, i64 4, i64 3, i64 2, i64 1, i64 0>, <8 x i64> %x0, <8 x i64> %x1, i8 -1)
  %res1 = call <8 x i64> @llvm.x86.avx512.maskz.vpermt2var.q.512(<8 x i64> <i64 7, i64 14, i64 5, i64 12, i64 3, i64 10, i64 1, i64 8>, <8 x i64> %res0, <8 x i64> %res0, i8 -1)
  ret <8 x i64> %res1
}

define <16 x float> @combine_vpermt2var_16f32_identity(<16 x float> %x0, <16 x float> %x1) {
; CHECK-LABEL: combine_vpermt2var_16f32_identity:
; CHECK:       # BB#0:
; CHECK-NEXT:    retq
  %res0 = call <16 x float> @llvm.x86.avx512.maskz.vpermt2var.ps.512(<16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>, <16 x float> %x0, <16 x float> %x1, i16 -1)
  %res1 = call <16 x float> @llvm.x86.avx512.maskz.vpermt2var.ps.512(<16 x i32> <i32 15, i32 30, i32 13, i32 28, i32 11, i32 26, i32 9, i32 24, i32 7, i32 22, i32 5, i32 20, i32 3, i32 18, i32 1, i32 16>, <16 x float> %res0, <16 x float> %res0, i16 -1)
  ret <16 x float> %res1
}

define <16 x float> @combine_vpermt2var_16f32_vmovshdup(<16 x float> %x0, <16 x float> %x1) {
; CHECK-LABEL: combine_vpermt2var_16f32_vmovshdup:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovdqa32 {{.*#+}} zmm2 = [1,1,3,3,5,5,7,7,9,9,11,11,13,13,15,15]
; CHECK-NEXT:    vpermt2ps %zmm1, %zmm2, %zmm0
; CHECK-NEXT:    retq
  %res0 = call <16 x float> @llvm.x86.avx512.maskz.vpermt2var.ps.512(<16 x i32> <i32 1, i32 1, i32 3, i32 3, i32 5, i32 5, i32 7, i32 7, i32 9, i32 9, i32 11, i32 11, i32 13, i32 13, i32 15, i32 15>, <16 x float> %x0, <16 x float> %x1, i16 -1)
  ret <16 x float> %res0
}

define <16 x float> @combine_vpermt2var_16f32_vmovsldup(<16 x float> %x0, <16 x float> %x1) {
; CHECK-LABEL: combine_vpermt2var_16f32_vmovsldup:
; CHECK:       # BB#0:
; CHECK-NEXT:    vmovdqa32 {{.*#+}} zmm2 = [0,0,2,2,4,4,6,6,8,8,10,10,12,12,14,14]
; CHECK-NEXT:    vpermt2ps %zmm1, %zmm2, %zmm0
; CHECK-NEXT:    retq
  %res0 = call <16 x float> @llvm.x86.avx512.maskz.vpermt2var.ps.512(<16 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6, i32 8, i32 8, i32 10, i32 10, i32 12, i32 12, i32 14, i32 14>, <16 x float> %x0, <16 x float> %x1, i16 -1)
  ret <16 x float> %res0
}

define <16 x i32> @combine_vpermt2var_16i32_identity(<16 x i32> %x0, <16 x i32> %x1) {
; CHECK-LABEL: combine_vpermt2var_16i32_identity:
; CHECK:       # BB#0:
; CHECK-NEXT:    retq
  %res0 = call <16 x i32> @llvm.x86.avx512.maskz.vpermt2var.d.512(<16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>, <16 x i32> %x0, <16 x i32> %x1, i16 -1)
  %res1 = call <16 x i32> @llvm.x86.avx512.maskz.vpermt2var.d.512(<16 x i32> <i32 15, i32 30, i32 13, i32 28, i32 11, i32 26, i32 9, i32 24, i32 7, i32 22, i32 5, i32 20, i32 3, i32 18, i32 1, i32 16>, <16 x i32> %res0, <16 x i32> %res0, i16 -1)
  ret <16 x i32> %res1
}

define <32 x i16> @combine_vpermt2var_32i16_identity(<32 x i16> %x0, <32 x i16> %x1) {
; CHECK-LABEL: combine_vpermt2var_32i16_identity:
; CHECK:       # BB#0:
; CHECK-NEXT:    retq
  %res0 = call <32 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.512(<32 x i16> <i16 31, i16 30, i16 29, i16 28, i16 27, i16 26, i16 25, i16 24, i16 23, i16 22, i16 21, i16 20, i16 19, i16 18, i16 17, i16 16, i16 15, i16 14, i16 13, i16 12, i16 11, i16 10, i16 9, i16 8, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0>, <32 x i16> %x0, <32 x i16> %x1, i32 -1)
  %res1 = call <32 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.512(<32 x i16> <i16 63, i16 30, i16 61, i16 28, i16 59, i16 26, i16 57, i16 24, i16 55, i16 22, i16 53, i16 20, i16 51, i16 18, i16 49, i16 16, i16 47, i16 46, i16 13, i16 44, i16 11, i16 42, i16 9, i16 40, i16 7, i16 38, i16 5, i16 36, i16 3, i16 34, i16 1, i16 32>, <32 x i16> %res0, <32 x i16> %res0, i32 -1)
  ret <32 x i16> %res1
}

define <64 x i8> @combine_pshufb_identity(<64 x i8> %x0) {
; CHECK-LABEL: combine_pshufb_identity:
; CHECK:       # BB#0:
; CHECK-NEXT:    retq
  %select = bitcast <8 x i64> <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1> to <64 x i8>
  %mask = bitcast <16 x i32> <i32 202182159, i32 134810123, i32 67438087, i32 66051, i32 202182159, i32 134810123, i32 67438087, i32 66051, i32 202182159, i32 134810123, i32 67438087, i32 66051, i32 202182159, i32 134810123, i32 67438087, i32 66051> to <64 x i8>
  %res0 = call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %x0, <64 x i8> %mask, <64 x i8> %select, i64 -1)
  %res1 = call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %res0, <64 x i8> %mask, <64 x i8> %select, i64 -1)
  ret <64 x i8> %res1
}
