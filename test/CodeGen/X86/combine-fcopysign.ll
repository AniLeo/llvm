; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX

;
; NOTE: this is generated by utils/update_llc_test_checks.py but we can't check NAN types (PR30443),
; so we need to edit it to remove the NAN constant comments
;

; copysign(x, c1) -> fabs(x) iff ispos(c1)
define <4 x float> @combine_vec_fcopysign_pos_constant0(<4 x float> %x) {
; SSE-LABEL: combine_vec_fcopysign_pos_constant0:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fcopysign_pos_constant0:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm1 = [NaN,NaN,NaN,NaN]
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %x, <4 x float> <float 2.0, float 2.0, float 2.0, float 2.0>)
  ret <4 x float> %1
}

define <4 x float> @combine_vec_fcopysign_pos_constant1(<4 x float> %x) {
; SSE-LABEL: combine_vec_fcopysign_pos_constant1:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fcopysign_pos_constant1:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm1 = [NaN,NaN,NaN,NaN]
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %x, <4 x float> <float 0.0, float 2.0, float 4.0, float 8.0>)
  ret <4 x float> %1
}

define <4 x float> @combine_vec_fcopysign_fabs_sgn(<4 x float> %x, <4 x float> %y) {
; SSE-LABEL: combine_vec_fcopysign_fabs_sgn:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fcopysign_fabs_sgn:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm1 = [NaN,NaN,NaN,NaN]
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <4 x float> @llvm.fabs.v4f32(<4 x float> %y)
  %2 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %x, <4 x float> %1)
  ret <4 x float> %2
}

; copysign(x, c1) -> fneg(fabs(x)) iff isneg(c1)
define <4 x float> @combine_vec_fcopysign_neg_constant0(<4 x float> %x) {
; SSE-LABEL: combine_vec_fcopysign_neg_constant0:
; SSE:       # %bb.0:
; SSE-NEXT:    orps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fcopysign_neg_constant0:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; AVX-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %x, <4 x float> <float -2.0, float -2.0, float -2.0, float -2.0>)
  ret <4 x float> %1
}

define <4 x float> @combine_vec_fcopysign_neg_constant1(<4 x float> %x) {
; SSE-LABEL: combine_vec_fcopysign_neg_constant1:
; SSE:       # %bb.0:
; SSE-NEXT:    orps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fcopysign_neg_constant1:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; AVX-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %x, <4 x float> <float -0.0, float -2.0, float -4.0, float -8.0>)
  ret <4 x float> %1
}

define <4 x float> @combine_vec_fcopysign_fneg_fabs_sgn(<4 x float> %x, <4 x float> %y) {
; SSE-LABEL: combine_vec_fcopysign_fneg_fabs_sgn:
; SSE:       # %bb.0:
; SSE-NEXT:    orps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fcopysign_fneg_fabs_sgn:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; AVX-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <4 x float> @llvm.fabs.v4f32(<4 x float> %y)
  %2 = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %1
  %3 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %x, <4 x float> %2)
  ret <4 x float> %3
}

; copysign(fabs(x), y) -> copysign(x, y)
define <4 x float> @combine_vec_fcopysign_fabs_mag(<4 x float> %x, <4 x float> %y) {
; SSE-LABEL: combine_vec_fcopysign_fabs_mag:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    orps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fcopysign_fabs_mag:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm2 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; AVX-NEXT:    vandps %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN]
; AVX-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <4 x float> @llvm.fabs.v4f32(<4 x float> %x)
  %2 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %1, <4 x float> %y)
  ret <4 x float> %2
}

; copysign(fneg(x), y) -> copysign(x, y)
define <4 x float> @combine_vec_fcopysign_fneg_mag(<4 x float> %x, <4 x float> %y) {
; SSE-LABEL: combine_vec_fcopysign_fneg_mag:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    orps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fcopysign_fneg_mag:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm2 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; AVX-NEXT:    vandps %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN]
; AVX-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %x
  %2 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %1, <4 x float> %y)
  ret <4 x float> %2
}

; copysign(copysign(x,z), y) -> copysign(x, y)
define <4 x float> @combine_vec_fcopysign_fcopysign_mag(<4 x float> %x, <4 x float> %y, <4 x float> %z) {
; SSE-LABEL: combine_vec_fcopysign_fcopysign_mag:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    orps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fcopysign_fcopysign_mag:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm2 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; AVX-NEXT:    vandps %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN]
; AVX-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %x, <4 x float> %z)
  %2 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %1, <4 x float> %y)
  ret <4 x float> %2
}

; copysign(x, copysign(y,z)) -> copysign(x, z)
define <4 x float> @combine_vec_fcopysign_fcopysign_sgn(<4 x float> %x, <4 x float> %y, <4 x float> %z) {
; SSE-LABEL: combine_vec_fcopysign_fcopysign_sgn:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm2
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    orps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fcopysign_fcopysign_sgn:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; AVX-NEXT:    vandps %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN]
; AVX-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %y, <4 x float> %z)
  %2 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %x, <4 x float> %1)
  ret <4 x float> %2
}

; copysign(x, fp_extend(y)) -> copysign(x, y)
define <4 x double> @combine_vec_fcopysign_fpext_sgn(<4 x double> %x, <4 x float> %y) {
; SSE-LABEL: combine_vec_fcopysign_fpext_sgn:
; SSE:       # %bb.0:
; SSE-NEXT:    cvtps2pd %xmm2, %xmm3
; SSE-NEXT:    movhlps {{.*#+}} xmm2 = xmm2[1,1]
; SSE-NEXT:    cvtps2pd %xmm2, %xmm2
; SSE-NEXT:    movaps {{.*#+}} xmm4 = [NaN,NaN]
; SSE-NEXT:    andps %xmm4, %xmm0
; SSE-NEXT:    movaps %xmm4, %xmm5
; SSE-NEXT:    andnps %xmm3, %xmm5
; SSE-NEXT:    orps %xmm5, %xmm0
; SSE-NEXT:    andps %xmm4, %xmm1
; SSE-NEXT:    andnps %xmm2, %xmm4
; SSE-NEXT:    orps %xmm4, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fcopysign_fpext_sgn:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvtps2pd %xmm1, %ymm1
; AVX-NEXT:    vbroadcastsd {{.*#+}} ymm2 = [NaN,NaN,NaN,NaN]
; AVX-NEXT:    vandps %ymm2, %ymm0, %ymm0
; AVX-NEXT:    vbroadcastsd {{.*#+}} ymm2 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; AVX-NEXT:    vandps %ymm2, %ymm1, %ymm1
; AVX-NEXT:    vorps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %1 = fpext <4 x float> %y to <4 x double>
  %2 = call <4 x double> @llvm.copysign.v4f64(<4 x double> %x, <4 x double> %1)
  ret <4 x double> %2
}

; copysign(x, fp_round(y)) -> copysign(x, y)
define <4 x float> @combine_vec_fcopysign_fptrunc_sgn(<4 x float> %x, <4 x double> %y) {
; SSE-LABEL: combine_vec_fcopysign_fptrunc_sgn:
; SSE:       # %bb.0:
; SSE-NEXT:    cvtpd2ps %xmm2, %xmm2
; SSE-NEXT:    cvtpd2ps %xmm1, %xmm1
; SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; SSE-NEXT:    andpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE-NEXT:    andpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    orpd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_fcopysign_fptrunc_sgn:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvtpd2ps %ymm1, %xmm1
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN]
; AVX-NEXT:    vandpd %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm2 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; AVX-NEXT:    vandpd %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vorpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %1 = fptrunc <4 x double> %y to <4 x float>
  %2 = call <4 x float> @llvm.copysign.v4f32(<4 x float> %x, <4 x float> %1)
  ret <4 x float> %2
}

declare <4 x float> @llvm.fabs.v4f32(<4 x float> %p)
declare <4 x float> @llvm.copysign.v4f32(<4 x float> %Mag, <4 x float> %Sgn)
declare <4 x double> @llvm.copysign.v4f64(<4 x double> %Mag, <4 x double> %Sgn)
