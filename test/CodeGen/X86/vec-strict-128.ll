; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 -O3 -disable-strictnode-mutation | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 -O3 -disable-strictnode-mutation | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx -O3 -disable-strictnode-mutation | FileCheck %s --check-prefixes=CHECK,AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx -O3 -disable-strictnode-mutation | FileCheck %s --check-prefixes=CHECK,AVX
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512f -mattr=+avx512vl -O3 -disable-strictnode-mutation | FileCheck %s --check-prefixes=CHECK,AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f -mattr=+avx512vl -O3 -disable-strictnode-mutation | FileCheck %s --check-prefixes=CHECK,AVX

declare <2 x double> @llvm.experimental.constrained.fadd.v2f64(<2 x double>, <2 x double>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fadd.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.fsub.v2f64(<2 x double>, <2 x double>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fsub.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.fmul.v2f64(<2 x double>, <2 x double>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fmul.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.fdiv.v2f64(<2 x double>, <2 x double>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fdiv.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.sqrt.v2f64(<2 x double>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.sqrt.v4f32(<4 x float>, metadata, metadata)
declare float @llvm.experimental.constrained.fptrunc.f32.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.fpext.f64.f32(float, metadata)

define <2 x double> @f1(<2 x double> %a, <2 x double> %b) #0 {
; SSE-LABEL: f1:
; SSE:       # %bb.0:
; SSE-NEXT:    addpd %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f1:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <2 x double> @llvm.experimental.constrained.fadd.v2f64(<2 x double> %a, <2 x double> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <2 x double> %ret
}

define <4 x float> @f2(<4 x float> %a, <4 x float> %b) #0 {
; SSE-LABEL: f2:
; SSE:       # %bb.0:
; SSE-NEXT:    addps %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f2:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <4 x float> @llvm.experimental.constrained.fadd.v4f32(<4 x float> %a, <4 x float> %b,
                                                                    metadata !"round.dynamic",
                                                                    metadata !"fpexcept.strict") #0
  ret <4 x float> %ret
}

define <2 x double> @f3(<2 x double> %a, <2 x double> %b) #0 {
; SSE-LABEL: f3:
; SSE:       # %bb.0:
; SSE-NEXT:    subpd %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f3:
; AVX:       # %bb.0:
; AVX-NEXT:    vsubpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <2 x double> @llvm.experimental.constrained.fsub.v2f64(<2 x double> %a, <2 x double> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <2 x double> %ret
}

define <4 x float> @f4(<4 x float> %a, <4 x float> %b) #0 {
; SSE-LABEL: f4:
; SSE:       # %bb.0:
; SSE-NEXT:    subps %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f4:
; AVX:       # %bb.0:
; AVX-NEXT:    vsubps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <4 x float> @llvm.experimental.constrained.fsub.v4f32(<4 x float> %a, <4 x float> %b,
                                                                    metadata !"round.dynamic",
                                                                    metadata !"fpexcept.strict") #0
  ret <4 x float> %ret
}

define <2 x double> @f5(<2 x double> %a, <2 x double> %b) #0 {
; SSE-LABEL: f5:
; SSE:       # %bb.0:
; SSE-NEXT:    mulpd %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f5:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <2 x double> @llvm.experimental.constrained.fmul.v2f64(<2 x double> %a, <2 x double> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <2 x double> %ret
}

define <4 x float> @f6(<4 x float> %a, <4 x float> %b) #0 {
; SSE-LABEL: f6:
; SSE:       # %bb.0:
; SSE-NEXT:    mulps %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f6:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <4 x float> @llvm.experimental.constrained.fmul.v4f32(<4 x float> %a, <4 x float> %b,
                                                                    metadata !"round.dynamic",
                                                                    metadata !"fpexcept.strict") #0
  ret <4 x float> %ret
}

define <2 x double> @f7(<2 x double> %a, <2 x double> %b) #0 {
; SSE-LABEL: f7:
; SSE:       # %bb.0:
; SSE-NEXT:    divpd %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f7:
; AVX:       # %bb.0:
; AVX-NEXT:    vdivpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <2 x double> @llvm.experimental.constrained.fdiv.v2f64(<2 x double> %a, <2 x double> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <2 x double> %ret
}

define <4 x float> @f8(<4 x float> %a, <4 x float> %b) #0 {
; SSE-LABEL: f8:
; SSE:       # %bb.0:
; SSE-NEXT:    divps %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f8:
; AVX:       # %bb.0:
; AVX-NEXT:    vdivps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <4 x float> @llvm.experimental.constrained.fdiv.v4f32(<4 x float> %a, <4 x float> %b,
                                                                    metadata !"round.dynamic",
                                                                    metadata !"fpexcept.strict") #0
  ret <4 x float> %ret
}

define <2 x double> @f9(<2 x double> %a) #0 {
; SSE-LABEL: f9:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtpd %xmm0, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f9:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtpd %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %sqrt = call <2 x double> @llvm.experimental.constrained.sqrt.v2f64(
                              <2 x double> %a,
                              metadata !"round.dynamic",
                              metadata !"fpexcept.strict") #0
  ret <2 x double> %sqrt
}

define <4 x float> @f10(<4 x float> %a) #0 {
; SSE-LABEL: f10:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtps %xmm0, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f10:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtps %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %sqrt = call <4 x float> @llvm.experimental.constrained.sqrt.v4f32(
                              <4 x float> %a,
                              metadata !"round.dynamic",
                              metadata !"fpexcept.strict") #0
  ret <4 x float > %sqrt
}

define <4 x float> @f11(<2 x double> %a0, <4 x float> %a1) #0 {
; SSE-LABEL: f11:
; SSE:       # %bb.0:
; SSE-NEXT:    cvtsd2ss %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f11:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvtsd2ss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ext = extractelement <2 x double> %a0, i32 0
  %cvt = call float @llvm.experimental.constrained.fptrunc.f32.f64(double %ext,
                                                                   metadata !"round.dynamic",
                                                                   metadata !"fpexcept.strict")
  %res = insertelement <4 x float> %a1, float %cvt, i32 0
  ret <4 x float> %res
}

define <2 x double> @f12(<2 x double> %a0, <4 x float> %a1) #0 {
; SSE-LABEL: f12:
; SSE:       # %bb.0:
; SSE-NEXT:    cvtss2sd %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f12:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvtss2sd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ext = extractelement <4 x float> %a1, i32 0
  %cvt = call double @llvm.experimental.constrained.fpext.f64.f32(float %ext,
                                                                  metadata !"fpexcept.strict") #0
  %res = insertelement <2 x double> %a0, double %cvt, i32 0
  ret <2 x double> %res
}

attributes #0 = { strictfp }
