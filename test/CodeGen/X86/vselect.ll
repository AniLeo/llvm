; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefixes=SSE,SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX

; Verify that we don't emit packed vector shifts instructions if the
; condition used by the vector select is a vector of constants.

define <4 x float> @test1(<4 x float> %a, <4 x float> %b) {
; SSE2-LABEL: test1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[1,3]
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2,1,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test1:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test1:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x float> @test2(<4 x float> %a, <4 x float> %b) {
; SSE2-LABEL: test2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test2:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test2:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 true, i1 false, i1 false>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x float> @test3(<4 x float> %a, <4 x float> %b) {
; SSE2-LABEL: test3:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test3:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test3:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 false, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x float> @test4(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test4:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test4:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 false, i1 false, i1 false>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x float> @test5(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test5:
; SSE:       # %bb.0:
; SSE-NEXT:    retq
;
; AVX-LABEL: test5:
; AVX:       # %bb.0:
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <8 x i16> @test6(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test6:
; SSE:       # %bb.0:
; SSE-NEXT:    retq
;
; AVX-LABEL: test6:
; AVX:       # %bb.0:
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 true, i1 false, i1 true, i1 false, i1 true, i1 false, i1 true, i1 false>, <8 x i16> %a, <8 x i16> %a
  ret <8 x i16> %1
}

define <8 x i16> @test7(<8 x i16> %a, <8 x i16> %b) {
; SSE2-LABEL: test7:
; SSE2:       # %bb.0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test7:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test7:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 false, i1 false, i1 false, i1 false>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test8(<8 x i16> %a, <8 x i16> %b) {
; SSE2-LABEL: test8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test8:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test8:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 false, i1 false, i1 false, i1 true, i1 true, i1 true, i1 true>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test9(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test9:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test9:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test10(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test10:
; SSE:       # %bb.0:
; SSE-NEXT:    retq
;
; AVX-LABEL: test10:
; AVX:       # %bb.0:
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test11(<8 x i16> %a, <8 x i16> %b) {
; SSE2-LABEL: test11:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps {{.*#+}} xmm2 = [0,65535,65535,0,0,65535,65535,0]
; SSE2-NEXT:    andps %xmm2, %xmm0
; SSE2-NEXT:    andnps %xmm1, %xmm2
; SSE2-NEXT:    orps %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test11:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0],xmm0[1,2],xmm1[3,4],xmm0[5,6],xmm1[7]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test11:
; AVX:       # %bb.0:
; AVX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0],xmm0[1,2],xmm1[3,4],xmm0[5,6],xmm1[7]
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 true, i1 true, i1 false, i1 undef, i1 true, i1 true, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test12(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test12:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test12:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 false, i1 undef, i1 false, i1 false, i1 false, i1 false, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <8 x i16> @test13(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test13:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test13:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 undef, i1 undef, i1 undef, i1 undef, i1 undef, i1 undef, i1 undef, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

; Fold (vselect (build_vector AllOnes), N1, N2) -> N1
define <4 x float> @test14(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test14:
; SSE:       # %bb.0:
; SSE-NEXT:    retq
;
; AVX-LABEL: test14:
; AVX:       # %bb.0:
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 undef, i1 true, i1 undef>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <8 x i16> @test15(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test15:
; SSE:       # %bb.0:
; SSE-NEXT:    retq
;
; AVX-LABEL: test15:
; AVX:       # %bb.0:
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 true, i1 true, i1 true, i1 undef, i1 undef, i1 true, i1 true, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

; Fold (vselect (build_vector AllZeros), N1, N2) -> N2
define <4 x float> @test16(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test16:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 undef, i1 false, i1 undef>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <8 x i16> @test17(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: test17:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test17:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = select <8 x i1> <i1 false, i1 false, i1 false, i1 undef, i1 undef, i1 false, i1 false, i1 undef>, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %1
}

define <4 x float> @test18(<4 x float> %a, <4 x float> %b) {
; SSE2-LABEL: test18:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test18:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test18:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 true, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x i32> @test19(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test19:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test19:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test19:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 false, i1 true, i1 true, i1 true>, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %1
}

define <2 x double> @test20(<2 x double> %a, <2 x double> %b) {
; SSE2-LABEL: test20:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test20:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test20:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %1 = select <2 x i1> <i1 false, i1 true>, <2 x double> %a, <2 x double> %b
  ret <2 x double> %1
}

define <2 x i64> @test21(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: test21:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test21:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test21:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %1 = select <2 x i1> <i1 false, i1 true>, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %1
}

define <4 x float> @test22(<4 x float> %a, <4 x float> %b) {
; SSE2-LABEL: test22:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm1 = xmm0[0],xmm1[1,2,3]
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test22:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test22:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 false, i1 false, i1 false>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %1
}

define <4 x i32> @test23(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test23:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm1 = xmm0[0],xmm1[1,2,3]
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test23:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test23:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; AVX-NEXT:    retq
  %1 = select <4 x i1> <i1 true, i1 false, i1 false, i1 false>, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %1
}

define <2 x double> @test24(<2 x double> %a, <2 x double> %b) {
; SSE2-LABEL: test24:
; SSE2:       # %bb.0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test24:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test24:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX-NEXT:    retq
  %1 = select <2 x i1> <i1 true, i1 false>, <2 x double> %a, <2 x double> %b
  ret <2 x double> %1
}

define <2 x i64> @test25(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: test25:
; SSE2:       # %bb.0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test25:
; SSE41:       # %bb.0:
; SSE41-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test25:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX-NEXT:    retq
  %1 = select <2 x i1> <i1 true, i1 false>, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %1
}

define <4 x float> @select_of_shuffles_0(<2 x float> %a0, <2 x float> %b0, <2 x float> %a1, <2 x float> %b1) {
; SSE-LABEL: select_of_shuffles_0:
; SSE:       # %bb.0:
; SSE-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; SSE-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm3[0]
; SSE-NEXT:    subps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: select_of_shuffles_0:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; AVX-NEXT:    vmovlhps {{.*#+}} xmm1 = xmm1[0],xmm3[0]
; AVX-NEXT:    vsubps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shufflevector <2 x float> %a0, <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %2 = shufflevector <2 x float> %a1, <2 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 0, i32 1>
  %3 = select <4 x i1> <i1 false, i1 false, i1 true, i1 true>, <4 x float> %2, <4 x float> %1
  %4 = shufflevector <2 x float> %b0, <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %5 = shufflevector <2 x float> %b1, <2 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 0, i32 1>
  %6 = select <4 x i1> <i1 false, i1 false, i1 true, i1 true>, <4 x float> %5, <4 x float> %4
  %7 = fsub <4 x float> %3, %6
  ret <4 x float> %7
}

; PR20677
define <16 x double> @select_illegal(<16 x double> %a, <16 x double> %b) {
; SSE-LABEL: select_illegal:
; SSE:       # %bb.0:
; SSE-NEXT:    movq %rdi, %rax
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm4
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm5
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm6
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm7
; SSE-NEXT:    movaps %xmm7, 112(%rdi)
; SSE-NEXT:    movaps %xmm6, 96(%rdi)
; SSE-NEXT:    movaps %xmm5, 80(%rdi)
; SSE-NEXT:    movaps %xmm4, 64(%rdi)
; SSE-NEXT:    movaps %xmm3, 48(%rdi)
; SSE-NEXT:    movaps %xmm2, 32(%rdi)
; SSE-NEXT:    movaps %xmm1, 16(%rdi)
; SSE-NEXT:    movaps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: select_illegal:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps %ymm7, %ymm3
; AVX-NEXT:    vmovaps %ymm6, %ymm2
; AVX-NEXT:    retq
  %sel = select <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false>, <16 x double> %a, <16 x double> %b
  ret <16 x double> %sel
}

; Make sure we can optimize the condition MSB when it is used by 2 selects.
; The v2i1 here will be passed as v2i64 and we will emit a sign_extend_inreg to fill the upper bits.
; We should be able to remove the sra from the sign_extend_inreg to leave only shl.
define <2 x i64> @shrunkblend_2uses(<2 x i1> %cond, <2 x i64> %a, <2 x i64> %b, <2 x i64> %c, <2 x i64> %d) {
; SSE2-LABEL: shrunkblend_2uses:
; SSE2:       # %bb.0:
; SSE2-NEXT:    psllq $63, %xmm0
; SSE2-NEXT:    psrad $31, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-NEXT:    movdqa %xmm0, %xmm5
; SSE2-NEXT:    pandn %xmm2, %xmm5
; SSE2-NEXT:    pand %xmm0, %xmm1
; SSE2-NEXT:    por %xmm1, %xmm5
; SSE2-NEXT:    pand %xmm0, %xmm3
; SSE2-NEXT:    pandn %xmm4, %xmm0
; SSE2-NEXT:    por %xmm3, %xmm0
; SSE2-NEXT:    paddq %xmm5, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: shrunkblend_2uses:
; SSE41:       # %bb.0:
; SSE41-NEXT:    psllq $63, %xmm0
; SSE41-NEXT:    blendvpd %xmm0, %xmm1, %xmm2
; SSE41-NEXT:    blendvpd %xmm0, %xmm3, %xmm4
; SSE41-NEXT:    paddq %xmm2, %xmm4
; SSE41-NEXT:    movdqa %xmm4, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: shrunkblend_2uses:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsllq $63, %xmm0, %xmm0
; AVX-NEXT:    vblendvpd %xmm0, %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vblendvpd %xmm0, %xmm3, %xmm4, %xmm0
; AVX-NEXT:    vpaddq %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %x = select <2 x i1> %cond, <2 x i64> %a, <2 x i64> %b
  %y = select <2 x i1> %cond, <2 x i64> %c, <2 x i64> %d
  %z = add <2 x i64> %x, %y
  ret <2 x i64> %z
}

; Similar to above, but condition has a use that isn't a condition of a vselect so we can't optimize.
define <2 x i64> @shrunkblend_nonvselectuse(<2 x i1> %cond, <2 x i64> %a, <2 x i64> %b, <2 x i64> %c, <2 x i64> %d) {
; SSE2-LABEL: shrunkblend_nonvselectuse:
; SSE2:       # %bb.0:
; SSE2-NEXT:    psllq $63, %xmm0
; SSE2-NEXT:    psrad $31, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE2-NEXT:    movdqa %xmm3, %xmm0
; SSE2-NEXT:    pandn %xmm2, %xmm0
; SSE2-NEXT:    pand %xmm3, %xmm1
; SSE2-NEXT:    por %xmm1, %xmm0
; SSE2-NEXT:    paddq %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: shrunkblend_nonvselectuse:
; SSE41:       # %bb.0:
; SSE41-NEXT:    psllq $63, %xmm0
; SSE41-NEXT:    blendvpd %xmm0, %xmm1, %xmm2
; SSE41-NEXT:    psrad $31, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE41-NEXT:    paddq %xmm2, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: shrunkblend_nonvselectuse:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsllq $63, %xmm0, %xmm0
; AVX-NEXT:    vblendvpd %xmm0, %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vxorpd %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vpcmpgtq %xmm0, %xmm2, %xmm0
; AVX-NEXT:    vpaddq %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %x = select <2 x i1> %cond, <2 x i64> %a, <2 x i64> %b
  %y = sext <2 x i1> %cond to <2 x i64>
  %z = add <2 x i64> %x, %y
  ret <2 x i64> %z
}

; This turns into a SHRUNKBLEND with SSE4 or later, and via
; late shuffle magic, both sides of the blend are the same
; value. If that is not simplified before isel, it can fail
; to match (crash).

define <2 x i32> @simplify_select(i32 %x, <2 x i1> %z) {
; SSE2-LABEL: simplify_select:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    pslld $31, %xmm0
; SSE2-NEXT:    psrad $31, %xmm0
; SSE2-NEXT:    movd %edi, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,0,1,1]
; SSE2-NEXT:    por %xmm1, %xmm2
; SSE2-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0,0]
; SSE2-NEXT:    shufps {{.*#+}} xmm1 = xmm1[2,0],xmm2[1,1]
; SSE2-NEXT:    pand %xmm0, %xmm2
; SSE2-NEXT:    pandn %xmm1, %xmm0
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: simplify_select:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE41-NEXT:    pslld $31, %xmm0
; SSE41-NEXT:    movd %edi, %xmm1
; SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,0,1,1]
; SSE41-NEXT:    por %xmm1, %xmm2
; SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[1,1,1,1]
; SSE41-NEXT:    pinsrd $1, %edi, %xmm1
; SSE41-NEXT:    blendvps %xmm0, %xmm2, %xmm1
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: simplify_select:
; AVX:       # %bb.0:
; AVX-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; AVX-NEXT:    vpslld $31, %xmm0, %xmm0
; AVX-NEXT:    vmovd %edi, %xmm1
; AVX-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,0,1,1]
; AVX-NEXT:    vpor %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,1,1]
; AVX-NEXT:    vpinsrd $1, %edi, %xmm2, %xmm2
; AVX-NEXT:    vblendvps %xmm0, %xmm1, %xmm2, %xmm0
; AVX-NEXT:    retq
  %a = insertelement <2 x i32> <i32 0, i32 undef>, i32 %x, i32 1
  %b = insertelement <2 x i32> <i32 undef, i32 0>, i32 %x, i32 0
  %y = or <2 x i32> %a, %b
  %p16 = extractelement <2 x i32> %y, i32 1
  %p17 = insertelement <2 x i32> undef, i32 %p16, i32 0
  %p18 = insertelement <2 x i32> %p17, i32 %x, i32 1
  %r = select <2 x i1> %z, <2 x i32> %y, <2 x i32> %p18
  ret <2 x i32> %r
}

; Test to make sure we don't try to insert a new setcc to swap the operands
; of select with all zeros LHS if the setcc has additional users.
define void @vselect_allzeros_LHS_multiple_use_setcc(<4 x i32> %x, <4 x i32> %y, <4 x i32> %z, <4 x i32>* %p1, <4 x i32>* %p2) {
; SSE-LABEL: vselect_allzeros_LHS_multiple_use_setcc:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm3 = [1,2,4,8]
; SSE-NEXT:    pand %xmm3, %xmm0
; SSE-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE-NEXT:    movdqa %xmm0, %xmm3
; SSE-NEXT:    pandn %xmm1, %xmm3
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    movdqa %xmm3, (%rdi)
; SSE-NEXT:    movdqa %xmm0, (%rsi)
; SSE-NEXT:    retq
;
; AVX-LABEL: vselect_allzeros_LHS_multiple_use_setcc:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa {{.*#+}} xmm3 = [1,2,4,8]
; AVX-NEXT:    vpand %xmm3, %xmm0, %xmm0
; AVX-NEXT:    vpcmpeqd %xmm3, %xmm0, %xmm0
; AVX-NEXT:    vpandn %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vmovdqa %xmm1, (%rdi)
; AVX-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX-NEXT:    retq
  %and = and <4 x i32> %x, <i32 1, i32 2, i32 4, i32 8>
  %cond = icmp ne <4 x i32> %and, zeroinitializer
  %sel1 = select <4 x i1> %cond, <4 x i32> zeroinitializer, <4 x i32> %y
  %sel2 = select <4 x i1> %cond, <4 x i32> %z, <4 x i32> zeroinitializer
  store <4 x i32> %sel1, <4 x i32>* %p1
  store <4 x i32> %sel2, <4 x i32>* %p2
  ret void
}

; This test case previously crashed after r363802, r363850, and r363856 due
; any_extend_vector_inreg not being handled by the X86 backend.
define i64 @vselect_any_extend_vector_inreg_crash(<8 x i8>* %x) {
; SSE-LABEL: vselect_any_extend_vector_inreg_crash:
; SSE:       # %bb.0:
; SSE-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    pcmpeqb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    movq %xmm0, %rax
; SSE-NEXT:    andl $1, %eax
; SSE-NEXT:    shlq $15, %rax
; SSE-NEXT:    retq
;
; AVX-LABEL: vselect_any_extend_vector_inreg_crash:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vpcmpeqb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vmovq %xmm0, %rax
; AVX-NEXT:    andl $1, %eax
; AVX-NEXT:    shlq $15, %rax
; AVX-NEXT:    retq
0:
  %1 = load <8 x i8>, <8 x i8>* %x
  %2 = icmp eq <8 x i8> %1, <i8 49, i8 49, i8 49, i8 49, i8 49, i8 49, i8 49, i8 49>
  %3 = select <8 x i1> %2, <8 x i64> <i64 32768, i64 16384, i64 8192, i64 4096, i64 2048, i64 1024, i64 512, i64 256>, <8 x i64> zeroinitializer
  %4 = extractelement <8 x i64> %3, i32 0
  ret i64 %4
}

