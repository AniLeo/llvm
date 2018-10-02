; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX

;
; NOTE: this is generated by utils/update_llc_test_checks.py but we can't check NAN types (PR30443),
; so we need to edit it to remove the NAN constant comments
;

; fabs(c1) -> c2
define float @combine_fabs_constant() {
; SSE-LABEL: combine_fabs_constant:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_fabs_constant:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    retq
  %1 = call float @llvm.fabs.f32(float -2.0)
  ret float %1
}

define <4 x float> @combine_vec_fabs_constant() {
; SSE-LABEL: combine_vec_fabs_constant:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [0,0,2,2]
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fabs_constant:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [0,0,2,2]
; AVX-NEXT:    retq
  %1 = call <4 x float> @llvm.fabs.v4f32(<4 x float> <float 0.0, float -0.0, float 2.0, float -2.0>)
  ret <4 x float> %1
}

; fabs(fabs(x)) -> fabs(x)
define float @combine_fabs_fabs(float %a) {
; SSE-LABEL: combine_fabs_fabs:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_fabs_fabs:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*}}(%rip), %xmm1
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call float @llvm.fabs.f32(float %a)
  %2 = call float @llvm.fabs.f32(float %1)
  ret float %2
}

define <4 x float> @combine_vec_fabs_fabs(<4 x float> %a) {
; SSE-LABEL: combine_vec_fabs_fabs:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fabs_fabs:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*}}(%rip), %xmm1
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <4 x float> @llvm.fabs.v4f32(<4 x float> %a)
  %2 = call <4 x float> @llvm.fabs.v4f32(<4 x float> %1)
  ret <4 x float> %2
}

; fabs(fneg(x)) -> fabs(x)
define float @combine_fabs_fneg(float %a) {
; SSE-LABEL: combine_fabs_fneg:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_fabs_fneg:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*}}(%rip), %xmm1
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = fsub float -0.0, %a
  %2 = call float @llvm.fabs.f32(float %1)
  ret float %2
}

define <4 x float> @combine_vec_fabs_fneg(<4 x float> %a) {
; SSE-LABEL: combine_vec_fabs_fneg:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fabs_fneg:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*}}(%rip), %xmm1
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %a
  %2 = call <4 x float> @llvm.fabs.v4f32(<4 x float> %1)
  ret <4 x float> %2
}

; fabs(fcopysign(x, y)) -> fabs(x)
define float @combine_fabs_fcopysign(float %a, float %b) {
; SSE-LABEL: combine_fabs_fcopysign:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_fabs_fcopysign:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*}}(%rip), %xmm1
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call float @llvm.copysign.f32(float %a, float %b)
  %2 = call float @llvm.fabs.f32(float %1)
  ret float %2
}

define <4 x float> @combine_vec_fabs_fcopysign(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: combine_vec_fabs_fcopysign:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fabs_fcopysign:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*}}(%rip), %xmm1
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %a, <4 x float> %b)
  %2 = call <4 x float> @llvm.fabs.v4f32(<4 x float> %1)
  ret <4 x float> %2
}

declare float @llvm.fabs.f32(float %p)
declare float @llvm.copysign.f32(float %Mag, float %Sgn)

declare <4 x float> @llvm.fabs.v4f32(<4 x float> %p)
declare <4 x float> @llvm.copysign.v4f32(<4 x float> %Mag, <4 x float> %Sgn)
