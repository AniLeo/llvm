; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse2 | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-SSE --check-prefix=CHECK-SSE2
; RUN: llc < %s -mtriple=i686-unknown -mattr=+ssse3 | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-SSE --check-prefix=CHECK-SSSE3
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-AVX

define <4 x i32> @test1(<4 x i32> %A, <4 x i32> %B) nounwind {
; CHECK-SSE-LABEL: test1:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,2,3,0]
; CHECK-SSE-NEXT:    retl
;
; CHECK-AVX-LABEL: test1:
; CHECK-AVX:       # %bb.0:
; CHECK-AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[1,2,3,0]
; CHECK-AVX-NEXT:    retl
  %C = shufflevector <4 x i32> %A, <4 x i32> undef, <4 x i32> < i32 1, i32 2, i32 3, i32 0 >
  ret <4 x i32> %C
}

define <4 x i32> @test2(<4 x i32> %A, <4 x i32> %B) nounwind {
; CHECK-SSE2-LABEL: test2:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[3,0]
; CHECK-SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,2],xmm1[2,0]
; CHECK-SSE2-NEXT:    retl
;
; CHECK-SSSE3-LABEL: test2:
; CHECK-SSSE3:       # %bb.0:
; CHECK-SSSE3-NEXT:    palignr {{.*#+}} xmm1 = xmm0[4,5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3]
; CHECK-SSSE3-NEXT:    movdqa %xmm1, %xmm0
; CHECK-SSSE3-NEXT:    retl
;
; CHECK-AVX-LABEL: test2:
; CHECK-AVX:       # %bb.0:
; CHECK-AVX-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[4,5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3]
; CHECK-AVX-NEXT:    retl
  %C = shufflevector <4 x i32> %A, <4 x i32> %B, <4 x i32> < i32 1, i32 2, i32 3, i32 4 >
  ret <4 x i32> %C
}

define <4 x i32> @test3(<4 x i32> %A, <4 x i32> %B) nounwind {
; CHECK-SSE2-LABEL: test3:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,2],xmm1[2,0]
; CHECK-SSE2-NEXT:    retl
;
; CHECK-SSSE3-LABEL: test3:
; CHECK-SSSE3:       # %bb.0:
; CHECK-SSSE3-NEXT:    palignr {{.*#+}} xmm1 = xmm0[4,5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3]
; CHECK-SSSE3-NEXT:    movdqa %xmm1, %xmm0
; CHECK-SSSE3-NEXT:    retl
;
; CHECK-AVX-LABEL: test3:
; CHECK-AVX:       # %bb.0:
; CHECK-AVX-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[4,5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3]
; CHECK-AVX-NEXT:    retl
  %C = shufflevector <4 x i32> %A, <4 x i32> %B, <4 x i32> < i32 1, i32 2, i32 undef, i32 4 >
  ret <4 x i32> %C
}

define <4 x i32> @test4(<4 x i32> %A, <4 x i32> %B) nounwind {
; CHECK-SSE2-LABEL: test4:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    shufpd {{.*#+}} xmm1 = xmm1[1],xmm0[0]
; CHECK-SSE2-NEXT:    movapd %xmm1, %xmm0
; CHECK-SSE2-NEXT:    retl
;
; CHECK-SSSE3-LABEL: test4:
; CHECK-SSSE3:       # %bb.0:
; CHECK-SSSE3-NEXT:    palignr {{.*#+}} xmm0 = xmm1[8,9,10,11,12,13,14,15],xmm0[0,1,2,3,4,5,6,7]
; CHECK-SSSE3-NEXT:    retl
;
; CHECK-AVX-LABEL: test4:
; CHECK-AVX:       # %bb.0:
; CHECK-AVX-NEXT:    vpalignr {{.*#+}} xmm0 = xmm1[8,9,10,11,12,13,14,15],xmm0[0,1,2,3,4,5,6,7]
; CHECK-AVX-NEXT:    retl
  %C = shufflevector <4 x i32> %A, <4 x i32> %B, <4 x i32> < i32 6, i32 7, i32 undef, i32 1 >
  ret <4 x i32> %C
}

define <4 x float> @test5(<4 x float> %A, <4 x float> %B) nounwind {
; CHECK-SSE-LABEL: test5:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    shufpd {{.*#+}} xmm1 = xmm1[1],xmm0[0]
; CHECK-SSE-NEXT:    movapd %xmm1, %xmm0
; CHECK-SSE-NEXT:    retl
;
; CHECK-AVX-LABEL: test5:
; CHECK-AVX:       # %bb.0:
; CHECK-AVX-NEXT:    vshufpd {{.*#+}} xmm0 = xmm1[1],xmm0[0]
; CHECK-AVX-NEXT:    retl
  %C = shufflevector <4 x float> %A, <4 x float> %B, <4 x i32> < i32 6, i32 7, i32 undef, i32 1 >
  ret <4 x float> %C
}

define <8 x i16> @test6(<8 x i16> %A, <8 x i16> %B) nounwind {
; CHECK-SSE2-LABEL: test6:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    psrldq {{.*#+}} xmm0 = xmm0[6,7,8,9,10,11,12,13,14,15],zero,zero,zero,zero,zero,zero
; CHECK-SSE2-NEXT:    pslldq {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm1[0,1,2,3,4,5]
; CHECK-SSE2-NEXT:    por %xmm1, %xmm0
; CHECK-SSE2-NEXT:    retl
;
; CHECK-SSSE3-LABEL: test6:
; CHECK-SSSE3:       # %bb.0:
; CHECK-SSSE3-NEXT:    palignr {{.*#+}} xmm1 = xmm0[6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4,5]
; CHECK-SSSE3-NEXT:    movdqa %xmm1, %xmm0
; CHECK-SSSE3-NEXT:    retl
;
; CHECK-AVX-LABEL: test6:
; CHECK-AVX:       # %bb.0:
; CHECK-AVX-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4,5]
; CHECK-AVX-NEXT:    retl
  %C = shufflevector <8 x i16> %A, <8 x i16> %B, <8 x i32> < i32 3, i32 4, i32 undef, i32 6, i32 7, i32 8, i32 9, i32 10 >
  ret <8 x i16> %C
}

define <8 x i16> @test7(<8 x i16> %A, <8 x i16> %B) nounwind {
; CHECK-SSE2-LABEL: test7:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    psrldq {{.*#+}} xmm0 = xmm0[10,11,12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; CHECK-SSE2-NEXT:    pslldq {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9]
; CHECK-SSE2-NEXT:    por %xmm1, %xmm0
; CHECK-SSE2-NEXT:    retl
;
; CHECK-SSSE3-LABEL: test7:
; CHECK-SSSE3:       # %bb.0:
; CHECK-SSSE3-NEXT:    palignr {{.*#+}} xmm1 = xmm0[10,11,12,13,14,15],xmm1[0,1,2,3,4,5,6,7,8,9]
; CHECK-SSSE3-NEXT:    movdqa %xmm1, %xmm0
; CHECK-SSSE3-NEXT:    retl
;
; CHECK-AVX-LABEL: test7:
; CHECK-AVX:       # %bb.0:
; CHECK-AVX-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[10,11,12,13,14,15],xmm1[0,1,2,3,4,5,6,7,8,9]
; CHECK-AVX-NEXT:    retl
  %C = shufflevector <8 x i16> %A, <8 x i16> %B, <8 x i32> < i32 undef, i32 6, i32 undef, i32 8, i32 9, i32 10, i32 11, i32 12 >
  ret <8 x i16> %C
}

define <16 x i8> @test8(<16 x i8> %A, <16 x i8> %B) nounwind {
; CHECK-SSE2-LABEL: test8:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    psrldq {{.*#+}} xmm0 = xmm0[5,6,7,8,9,10,11,12,13,14,15],zero,zero,zero,zero,zero
; CHECK-SSE2-NEXT:    pslldq {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm1[0,1,2,3,4]
; CHECK-SSE2-NEXT:    por %xmm1, %xmm0
; CHECK-SSE2-NEXT:    retl
;
; CHECK-SSSE3-LABEL: test8:
; CHECK-SSSE3:       # %bb.0:
; CHECK-SSSE3-NEXT:    palignr {{.*#+}} xmm1 = xmm0[5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4]
; CHECK-SSSE3-NEXT:    movdqa %xmm1, %xmm0
; CHECK-SSSE3-NEXT:    retl
;
; CHECK-AVX-LABEL: test8:
; CHECK-AVX:       # %bb.0:
; CHECK-AVX-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[5,6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4]
; CHECK-AVX-NEXT:    retl
  %C = shufflevector <16 x i8> %A, <16 x i8> %B, <16 x i32> < i32 5, i32 6, i32 7, i32 undef, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20 >
  ret <16 x i8> %C
}

; Check that we don't do unary (circular on single operand) palignr incorrectly.
; (It is possible, but before this testcase was committed, it was being done
; incorrectly.  In particular, one of the operands of the palignr node
; was an UNDEF.)
define <8 x i16> @test9(<8 x i16> %A, <8 x i16> %B) nounwind {
; CHECK-SSE2-LABEL: test9:
; CHECK-SSE2:       # %bb.0:
; CHECK-SSE2-NEXT:    movdqa %xmm1, %xmm0
; CHECK-SSE2-NEXT:    psrldq {{.*#+}} xmm1 = xmm1[2,3,4,5,6,7,8,9,10,11,12,13,14,15],zero,zero
; CHECK-SSE2-NEXT:    pslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1]
; CHECK-SSE2-NEXT:    por %xmm1, %xmm0
; CHECK-SSE2-NEXT:    retl
;
; CHECK-SSSE3-LABEL: test9:
; CHECK-SSSE3:       # %bb.0:
; CHECK-SSSE3-NEXT:    movdqa %xmm1, %xmm0
; CHECK-SSSE3-NEXT:    palignr {{.*#+}} xmm0 = xmm1[2,3,4,5,6,7,8,9,10,11,12,13,14,15],xmm0[0,1]
; CHECK-SSSE3-NEXT:    retl
;
; CHECK-AVX-LABEL: test9:
; CHECK-AVX:       # %bb.0:
; CHECK-AVX-NEXT:    vpalignr {{.*#+}} xmm0 = xmm1[2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,1]
; CHECK-AVX-NEXT:    retl
  %C = shufflevector <8 x i16> %B, <8 x i16> %A, <8 x i32> < i32 undef, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0 >
  ret <8 x i16> %C
}

