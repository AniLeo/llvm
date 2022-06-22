; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX2,AVX2-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX2,AVX2-FAST-ALL
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX2,AVX2-FAST-PERLANE
; PR32449

define <2 x double> @foo2(<2 x double> %v, ptr%p) nounwind {
; AVX2-LABEL: foo2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,1]
; AVX2-NEXT:    vmovapd %xmm0, (%rdi)
; AVX2-NEXT:    retq
  %res = shufflevector <2 x double> %v, <2 x double> undef, <2 x i32> <i32 1, i32 1>
  %res1 = shufflevector<2 x double> %res, <2 x double> undef, <2 x i32> <i32 1, i32 undef>
  store <2 x double> %res, ptr %p
  ret <2 x double> %res1
}

define <4 x double> @foo4(<4 x double> %v, ptr%p) nounwind {
; AVX2-LABEL: foo4:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,2,2,2]
; AVX2-NEXT:    vmovaps %ymm0, (%rdi)
; AVX2-NEXT:    retq
  %res = shufflevector <4 x double> %v, <4 x double> undef, <4 x i32> <i32 2, i32 2, i32 2, i32 2>
  %res1 = shufflevector<4 x double> %res, <4 x double> undef, <4 x i32> <i32 2, i32 0, i32 undef, i32 undef>
  store <4 x double> %res, ptr %p
  ret <4 x double> %res1
}

define <8 x float> @foo8(<8 x float> %v, ptr%p) nounwind {
; AVX2-SLOW-LABEL: foo8:
; AVX2-SLOW:       # %bb.0:
; AVX2-SLOW-NEXT:    vmovshdup {{.*#+}} ymm0 = ymm0[1,1,3,3,5,5,7,7]
; AVX2-SLOW-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,2,2,2]
; AVX2-SLOW-NEXT:    vmovaps %ymm0, (%rdi)
; AVX2-SLOW-NEXT:    retq
;
; AVX2-FAST-ALL-LABEL: foo8:
; AVX2-FAST-ALL:       # %bb.0:
; AVX2-FAST-ALL-NEXT:    vbroadcastss {{.*#+}} ymm1 = [5,5,5,5,5,5,5,5]
; AVX2-FAST-ALL-NEXT:    vpermps %ymm0, %ymm1, %ymm0
; AVX2-FAST-ALL-NEXT:    vmovaps %ymm0, (%rdi)
; AVX2-FAST-ALL-NEXT:    retq
;
; AVX2-FAST-PERLANE-LABEL: foo8:
; AVX2-FAST-PERLANE:       # %bb.0:
; AVX2-FAST-PERLANE-NEXT:    vmovshdup {{.*#+}} ymm0 = ymm0[1,1,3,3,5,5,7,7]
; AVX2-FAST-PERLANE-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,2,2,2]
; AVX2-FAST-PERLANE-NEXT:    vmovaps %ymm0, (%rdi)
; AVX2-FAST-PERLANE-NEXT:    retq
  %res = shufflevector <8 x float> %v, <8 x float> undef, <8 x i32> <i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5, i32 5>
  %res1 = shufflevector<8 x float> %res, <8 x float> undef, <8 x i32> <i32 2, i32 0, i32 undef, i32 undef, i32 5, i32 1, i32 3, i32 7>
  store <8 x float> %res, ptr %p
  ret <8 x float> %res1
}

define <4 x i32> @undef_splatmask(<4 x i32> %v) nounwind {
; AVX2-LABEL: undef_splatmask:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[2,2,3,3]
; AVX2-NEXT:    retq
  %res = shufflevector <4 x i32> %v, <4 x i32> undef, <4 x i32> <i32 2, i32 undef, i32 2, i32 undef>
  %res1 = shufflevector <4 x i32> %res, <4 x i32> undef, <4 x i32> <i32 0, i32 2, i32 undef, i32 undef>
  ret <4 x i32> %res1
}

define <4 x i32> @undef_splatmask2(<4 x i32> %v) nounwind {
; AVX2-LABEL: undef_splatmask2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[2,2,3,3]
; AVX2-NEXT:    retq
  %res = shufflevector <4 x i32> %v, <4 x i32> undef, <4 x i32> <i32 2, i32 1, i32 2, i32 undef>
  %res1 = shufflevector <4 x i32> %res, <4 x i32> undef, <4 x i32> <i32 0, i32 2, i32 undef, i32 undef>
  ret <4 x i32> %res1
}

define <4 x i32> @undef_splatmask3(<4 x i32> %v) nounwind {
; AVX2-LABEL: undef_splatmask3:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[2,2,3,3]
; AVX2-NEXT:    retq
  %res = shufflevector <4 x i32> %v, <4 x i32> undef, <4 x i32> <i32 2, i32 undef, i32 2, i32 undef>
  %res1 = shufflevector <4 x i32> %res, <4 x i32> undef, <4 x i32> <i32 0, i32 2, i32 undef, i32 3>
  ret <4 x i32> %res1
}

define <4 x i32> @undef_splatmask4(<4 x i32> %v, ptr %p) nounwind {
; AVX2-LABEL: undef_splatmask4:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermilps {{.*#+}} xmm1 = xmm0[2,2,3,3]
; AVX2-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[2,3,2,3]
; AVX2-NEXT:    vmovaps %xmm0, (%rdi)
; AVX2-NEXT:    vmovaps %xmm1, %xmm0
; AVX2-NEXT:    retq
  %res = shufflevector <4 x i32> %v, <4 x i32> undef, <4 x i32> <i32 2, i32 undef, i32 2, i32 undef>
  %res1 = shufflevector <4 x i32> %res, <4 x i32> undef, <4 x i32> <i32 0, i32 2, i32 undef, i32 undef>
  store <4 x i32> %res, ptr %p
  ret <4 x i32> %res1
}

define <4 x i32> @undef_splatmask5(<4 x i32> %v, ptr %p) nounwind {
; AVX2-LABEL: undef_splatmask5:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vbroadcastss %xmm0, %xmm0
; AVX2-NEXT:    vmovaps %xmm0, (%rdi)
; AVX2-NEXT:    retq
  %res = shufflevector <4 x i32> %v, <4 x i32> undef, <4 x i32> <i32 0, i32 undef, i32 0, i32 undef>
  %res1 = shufflevector <4 x i32> %res, <4 x i32> undef, <4 x i32> <i32 0, i32 2, i32 undef, i32 3>
  store <4 x i32> %res, ptr %p
  ret <4 x i32> %res1
}
