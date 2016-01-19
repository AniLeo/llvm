; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -mattr=+sse4.1 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -mattr=+avx | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -mattr=+avx2 | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX2

define <4 x float> @shuffle_v4f32_0z27(<4 x float> %x, <4 x float> %a) {
; SSE-LABEL: shuffle_v4f32_0z27:
; SSE:       # BB#0:
; SSE-NEXT:    insertps {{.*#+}} xmm0 = xmm0[0],zero,xmm0[2],xmm1[2]
; SSE-NEXT:    retq
;
; AVX-LABEL: shuffle_v4f32_0z27:
; AVX:       # BB#0:
; AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],zero,xmm0[2],xmm1[2]
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %x, i32 0
  %vecinit = insertelement <4 x float> undef, float %vecext, i32 0
  %vecinit1 = insertelement <4 x float> %vecinit, float 0.0, i32 1
  %vecinit3 = shufflevector <4 x float> %vecinit1, <4 x float> %x, <4 x i32> <i32 0, i32 1, i32 6, i32 undef>
  %vecinit5 = shufflevector <4 x float> %vecinit3, <4 x float> %a, <4 x i32> <i32 0, i32 1, i32 2, i32 6>
  ret <4 x float> %vecinit5
}

define <4 x float> @shuffle_v4f32_0zz4(<4 x float> %xyzw, <4 x float> %abcd) {
; SSE-LABEL: shuffle_v4f32_0zz4:
; SSE:       # BB#0:
; SSE-NEXT:    xorps %xmm2, %xmm2
; SSE-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm2[1,2,3]
; SSE-NEXT:    insertps {{.*#+}} xmm0 = xmm0[0,1,2],xmm1[0]
; SSE-NEXT:    retq
;
; AVX-LABEL: shuffle_v4f32_0zz4:
; AVX:       # BB#0:
; AVX-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm2[1,2,3]
; AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],xmm1[0]
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %xyzw, i32 0
  %vecinit = insertelement <4 x float> undef, float %vecext, i32 0
  %vecinit1 = insertelement <4 x float> %vecinit, float 0.000000e+00, i32 1
  %vecinit2 = insertelement <4 x float> %vecinit1, float 0.000000e+00, i32 2
  %vecinit4 = shufflevector <4 x float> %vecinit2, <4 x float> %abcd, <4 x i32> <i32 0, i32 1, i32 2, i32 4>
  ret <4 x float> %vecinit4
}

define <4 x float> @shuffle_v4f32_0z24(<4 x float> %xyzw, <4 x float> %abcd) {
; SSE-LABEL: shuffle_v4f32_0z24:
; SSE:       # BB#0:
; SSE-NEXT:    insertps {{.*#+}} xmm0 = xmm0[0],zero,xmm0[2],xmm1[0]
; SSE-NEXT:    retq
;
; AVX-LABEL: shuffle_v4f32_0z24:
; AVX:       # BB#0:
; AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],zero,xmm0[2],xmm1[0]
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %xyzw, i32 0
  %vecinit = insertelement <4 x float> undef, float %vecext, i32 0
  %vecinit1 = insertelement <4 x float> %vecinit, float 0.000000e+00, i32 1
  %vecinit3 = shufflevector <4 x float> %vecinit1, <4 x float> %xyzw, <4 x i32> <i32 0, i32 1, i32 6, i32 undef>
  %vecinit5 = shufflevector <4 x float> %vecinit3, <4 x float> %abcd, <4 x i32> <i32 0, i32 1, i32 2, i32 4>
  ret <4 x float> %vecinit5
}

define <4 x float> @shuffle_v4f32_0zz0(float %a) {
; SSE-LABEL: shuffle_v4f32_0zz0:
; SSE:       # BB#0:
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    blendps {{.*#+}} xmm1 = xmm0[0],xmm1[1,2,3]
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,1,1,0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: shuffle_v4f32_0zz0:
; AVX:       # BB#0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,1,1,0]
; AVX-NEXT:    retq
  %vecinit = insertelement <4 x float> undef, float %a, i32 0
  %vecinit1 = insertelement <4 x float> %vecinit, float 0.000000e+00, i32 1
  %vecinit2 = insertelement <4 x float> %vecinit1, float 0.000000e+00, i32 2
  %vecinit3 = insertelement <4 x float> %vecinit2, float %a, i32 3
  ret <4 x float> %vecinit3
}

define <4 x float> @shuffle_v4f32_0z6z(<4 x float> %A, <4 x float> %B) {
; SSE-LABEL: shuffle_v4f32_0z6z:
; SSE:       # BB#0:
; SSE-NEXT:    insertps {{.*#+}} xmm0 = xmm0[0],zero,xmm1[2],zero
; SSE-NEXT:    retq
;
; AVX-LABEL: shuffle_v4f32_0z6z:
; AVX:       # BB#0:
; AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],zero,xmm1[2],zero
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %A, i32 0
  %vecinit = insertelement <4 x float> undef, float %vecext, i32 0
  %vecinit1 = insertelement <4 x float> %vecinit, float 0.000000e+00, i32 1
  %vecext2 = extractelement <4 x float> %B, i32 2
  %vecinit3 = insertelement <4 x float> %vecinit1, float %vecext2, i32 2
  %vecinit4 = insertelement <4 x float> %vecinit3, float 0.000000e+00, i32 3
  ret <4 x float> %vecinit4
}

define float @extract_zero_insertps_z0z7(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: extract_zero_insertps_z0z7:
; SSE:       # BB#0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: extract_zero_insertps_z0z7:
; AVX:       # BB#0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %res = call <4 x float> @llvm.x86.sse41.insertps(<4 x float> %a0, <4 x float> %a1, i8 21)
  %ext = extractelement <4 x float> %res, i32 0
  ret float %ext
}

define float @extract_lane_insertps_5123(<4 x float> %a0, <4 x float> *%p1) {
; SSE-LABEL: extract_lane_insertps_5123:
; SSE:       # BB#0:
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    retq
;
; AVX-LABEL: extract_lane_insertps_5123:
; AVX:       # BB#0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    retq
  %a1 = load <4 x float>, <4 x float> *%p1
  %res = call <4 x float> @llvm.x86.sse41.insertps(<4 x float> %a0, <4 x float> %a1, i8 128)
  %ext = extractelement <4 x float> %res, i32 0
  ret float %ext
}

declare <4 x float> @llvm.x86.sse41.insertps(<4 x float>, <4 x float>, i8) nounwind readnone
