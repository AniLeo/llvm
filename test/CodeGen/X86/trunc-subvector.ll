; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefixes=AVX,AVX512,AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefixes=AVX,AVX512,AVX512BW

define <4 x i32> @test1(<8 x i32> %v) {
; SSE2-LABEL: test1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE2-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE2-NEXT:    retq
;
; AVX2-LABEL: test1:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovsxdq %xmm0, %ymm0
; AVX2-NEXT:    vpshufd {{.*#+}} ymm0 = ymm0[0,2,2,3,4,6,6,7]
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-NEXT:    # kill: def %xmm0 killed %xmm0 killed %ymm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovsxdq %ymm0, %zmm0
; AVX512-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512-NEXT:    # kill: def %xmm0 killed %xmm0 killed %ymm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %x = sext <8 x i32> %v to <8 x i64>
  %s = shufflevector <8 x i64> %x, <8 x i64> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %t = trunc <4 x i64> %s to <4 x i32>
  ret <4 x i32> %t
}

define <4 x i32> @test2(<8 x i32> %v) {
; SSE2-LABEL: test2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,0,1]
; SSE2-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE2-NEXT:    movdqa %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; AVX2-LABEL: test2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    vpmovsxdq %xmm0, %ymm0
; AVX2-NEXT:    vpshufd {{.*#+}} ymm0 = ymm0[0,2,2,3,4,6,6,7]
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-NEXT:    # kill: def %xmm0 killed %xmm0 killed %ymm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovsxdq %ymm0, %zmm0
; AVX512-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; AVX512-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512-NEXT:    # kill: def %xmm0 killed %xmm0 killed %ymm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %x = sext <8 x i32> %v to <8 x i64>
  %s = shufflevector <8 x i64> %x, <8 x i64> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %t = trunc <4 x i64> %s to <4 x i32>
  ret <4 x i32> %t
}

define <2 x i32> @test3(<8 x i32> %v) {
; SSE2-LABEL: test3:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm1, %xmm0
; SSE2-NEXT:    psrad $31, %xmm0
; SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; SSE2-NEXT:    movdqa %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; AVX2-LABEL: test3:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    vpmovsxdq %xmm0, %ymm0
; AVX2-NEXT:    # kill: def %xmm0 killed %xmm0 killed %ymm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test3:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovsxdq %ymm0, %zmm0
; AVX512-NEXT:    vextracti32x4 $2, %zmm0, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %x = sext <8 x i32> %v to <8 x i64>
  %s = shufflevector <8 x i64> %x, <8 x i64> undef, <2 x i32> <i32 4, i32 5>
  %t = trunc <2 x i64> %s to <2 x i32>
  ret <2 x i32> %t
}

define <2 x i32> @test4(<8 x i32> %v) {
; SSE2-LABEL: test4:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    psrad $31, %xmm1
; SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; SSE2-NEXT:    retq
;
; AVX2-LABEL: test4:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovsxdq %xmm0, %ymm0
; AVX2-NEXT:    # kill: def %xmm0 killed %xmm0 killed %ymm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test4:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovsxdq %ymm0, %zmm0
; AVX512-NEXT:    # kill: def %xmm0 killed %xmm0 killed %zmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %x = sext <8 x i32> %v to <8 x i64>
  %s = shufflevector <8 x i64> %x, <8 x i64> undef, <2 x i32> <i32 0, i32 1>
  %t = trunc <2 x i64> %s to <2 x i32>
  ret <2 x i32> %t
}

define <2 x i32> @test5(<8 x i32> %v) {
; SSE2-LABEL: test5:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    psrad $31, %xmm2
; SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[1],xmm2[1]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    psrad $31, %xmm2
; SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; SSE2-NEXT:    shufpd {{.*#+}} xmm0 = xmm0[1],xmm1[0]
; SSE2-NEXT:    retq
;
; AVX2-LABEL: test5:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovsxdq %xmm0, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    vpmovsxdq %xmm0, %ymm0
; AVX2-NEXT:    vpalignr {{.*#+}} ymm0 = ymm1[8,9,10,11,12,13,14,15],ymm0[0,1,2,3,4,5,6,7],ymm1[24,25,26,27,28,29,30,31],ymm0[16,17,18,19,20,21,22,23]
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[2,1,2,3]
; AVX2-NEXT:    # kill: def %xmm0 killed %xmm0 killed %ymm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test5:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovsxdq %ymm0, %zmm0
; AVX512-NEXT:    vextracti32x4 $2, %zmm0, %xmm1
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX512-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4,5,6,7]
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %x = sext <8 x i32> %v to <8 x i64>
  %s = shufflevector <8 x i64> %x, <8 x i64> undef, <2 x i32> <i32 3, i32 4>
  %t = trunc <2 x i64> %s to <2 x i32>
  ret <2 x i32> %t
}
