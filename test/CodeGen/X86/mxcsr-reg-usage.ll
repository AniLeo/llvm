; RUN: llc -march=x86-64 -mattr=+mmx,+fma,+f16c -stop-after finalize-isel -o - %s | FileCheck %s
; This test ensures that the MXCSR is implicitly used by MMX FP instructions.

define x86_mmx @mxcsr_mmx(<4 x float> %a0) {
; CHECK: MMX_CVTPS2PIirr %{{[0-9]}}, implicit $mxcsr
; CHECK: MMX_CVTPI2PSirr %{{[0-9]}}, killed %{{[0-9]}}, implicit $mxcsr
; CHECK: MMX_CVTTPS2PIirr killed %{{[0-9]}}, implicit $mxcsr
; CHECK: MMX_CVTPI2PDirr killed %{{[0-9]$}}
; CHECK: MMX_CVTPD2PIirr killed %{{[0-9]}}, implicit $mxcsr
  %1 = call x86_mmx @llvm.x86.sse.cvtps2pi(<4 x float> %a0)
  %2 = call <4 x float> @llvm.x86.sse.cvtpi2ps(<4 x float> %a0, x86_mmx %1)
  %3 = call x86_mmx @llvm.x86.sse.cvttps2pi(<4 x float> %2)
  %4 = call <2 x double> @llvm.x86.sse.cvtpi2pd(x86_mmx %3)
  %5 = call x86_mmx @llvm.x86.sse.cvtpd2pi(<2 x double> %4)
  ret x86_mmx %5
}

define half @mxcsr_f16c(float %a) {
; CHECK: VCVTPS2PH{{.*}}mxcsr
; CHECK: VCVTPH2PS{{.*}}mxcsr
  %res = fptrunc float %a to half
  ret half %res
}

define <4 x float> @mxcsr_fma_ss(<4 x float> %a, <4 x float> %b) {
; CHECK: VFMADD{{.*}}mxcsr
  %res = call <4 x float> @llvm.x86.fma.vfmadd.ss(<4 x float> %b, <4 x float> %a, <4 x float>
%a)
  ret <4 x float> %res
}

define <4 x float> @mxcsr_fma_ps(<4 x float> %a, <4 x float> %b) {
; CHECK: VFMADD{{.*}}mxcsr
  %res = call <4 x float> @llvm.x86.fma.vfmadd.ps(<4 x float> %b, <4 x float> %a, <4 x float>
%a)
  ret <4 x float> %res
}

declare x86_mmx @llvm.x86.sse.cvtps2pi(<4 x float>)
declare<4 x float> @llvm.x86.sse.cvtpi2ps(<4 x float>, x86_mmx)
declare x86_mmx @llvm.x86.sse.cvttps2pi(<4 x float>)
declare <2 x double> @llvm.x86.sse.cvtpi2pd(x86_mmx)
declare x86_mmx @llvm.x86.sse.cvtpd2pi(<2 x double>)
declare <4 x float> @llvm.x86.fma.vfmadd.ss(<4 x float>, <4 x float>, <4 x float>)
declare <4 x float> @llvm.x86.fma.vfmadd.ps(<4 x float>, <4 x float>, <4 x float>)
