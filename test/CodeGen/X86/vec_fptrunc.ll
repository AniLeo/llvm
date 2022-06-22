; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=X32-SSE
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx | FileCheck %s --check-prefix=X32-AVX
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=X64-SSE
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx | FileCheck %s --check-prefix=X64-AVX

define void @fptrunc_frommem2(ptr %in, ptr %out) {
; X32-SSE-LABEL: fptrunc_frommem2:
; X32-SSE:       # %bb.0: # %entry
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-SSE-NEXT:    cvtpd2ps (%ecx), %xmm0
; X32-SSE-NEXT:    movlpd %xmm0, (%eax)
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: fptrunc_frommem2:
; X32-AVX:       # %bb.0: # %entry
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-AVX-NEXT:    vcvtpd2psx (%ecx), %xmm0
; X32-AVX-NEXT:    vmovlpd %xmm0, (%eax)
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: fptrunc_frommem2:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    cvtpd2ps (%rdi), %xmm0
; X64-SSE-NEXT:    movlpd %xmm0, (%rsi)
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: fptrunc_frommem2:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    vcvtpd2psx (%rdi), %xmm0
; X64-AVX-NEXT:    vmovlpd %xmm0, (%rsi)
; X64-AVX-NEXT:    retq
entry:
  %0 = load <2 x double>, ptr %in
  %1 = fptrunc <2 x double> %0 to <2 x float>
  store <2 x float> %1, ptr %out, align 1
  ret void
}

define void @fptrunc_frommem4(ptr %in, ptr %out) {
; X32-SSE-LABEL: fptrunc_frommem4:
; X32-SSE:       # %bb.0: # %entry
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-SSE-NEXT:    cvtpd2ps 16(%ecx), %xmm0
; X32-SSE-NEXT:    cvtpd2ps (%ecx), %xmm1
; X32-SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; X32-SSE-NEXT:    movupd %xmm1, (%eax)
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: fptrunc_frommem4:
; X32-AVX:       # %bb.0: # %entry
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-AVX-NEXT:    vcvtpd2psy (%ecx), %xmm0
; X32-AVX-NEXT:    vmovupd %xmm0, (%eax)
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: fptrunc_frommem4:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    cvtpd2ps 16(%rdi), %xmm0
; X64-SSE-NEXT:    cvtpd2ps (%rdi), %xmm1
; X64-SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; X64-SSE-NEXT:    movupd %xmm1, (%rsi)
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: fptrunc_frommem4:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    vcvtpd2psy (%rdi), %xmm0
; X64-AVX-NEXT:    vmovupd %xmm0, (%rsi)
; X64-AVX-NEXT:    retq
entry:
  %0 = load <4 x double>, ptr %in
  %1 = fptrunc <4 x double> %0 to <4 x float>
  store <4 x float> %1, ptr %out, align 1
  ret void
}

define void @fptrunc_frommem8(ptr %in, ptr %out) {
; X32-SSE-LABEL: fptrunc_frommem8:
; X32-SSE:       # %bb.0: # %entry
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-SSE-NEXT:    cvtpd2ps 16(%ecx), %xmm0
; X32-SSE-NEXT:    cvtpd2ps (%ecx), %xmm1
; X32-SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; X32-SSE-NEXT:    cvtpd2ps 48(%ecx), %xmm0
; X32-SSE-NEXT:    cvtpd2ps 32(%ecx), %xmm2
; X32-SSE-NEXT:    unpcklpd {{.*#+}} xmm2 = xmm2[0],xmm0[0]
; X32-SSE-NEXT:    movupd %xmm2, 16(%eax)
; X32-SSE-NEXT:    movupd %xmm1, (%eax)
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: fptrunc_frommem8:
; X32-AVX:       # %bb.0: # %entry
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-AVX-NEXT:    vcvtpd2psy (%ecx), %xmm0
; X32-AVX-NEXT:    vcvtpd2psy 32(%ecx), %xmm1
; X32-AVX-NEXT:    vmovupd %xmm1, 16(%eax)
; X32-AVX-NEXT:    vmovupd %xmm0, (%eax)
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: fptrunc_frommem8:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    cvtpd2ps 16(%rdi), %xmm0
; X64-SSE-NEXT:    cvtpd2ps (%rdi), %xmm1
; X64-SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; X64-SSE-NEXT:    cvtpd2ps 48(%rdi), %xmm0
; X64-SSE-NEXT:    cvtpd2ps 32(%rdi), %xmm2
; X64-SSE-NEXT:    unpcklpd {{.*#+}} xmm2 = xmm2[0],xmm0[0]
; X64-SSE-NEXT:    movupd %xmm2, 16(%rsi)
; X64-SSE-NEXT:    movupd %xmm1, (%rsi)
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: fptrunc_frommem8:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    vcvtpd2psy (%rdi), %xmm0
; X64-AVX-NEXT:    vcvtpd2psy 32(%rdi), %xmm1
; X64-AVX-NEXT:    vmovupd %xmm1, 16(%rsi)
; X64-AVX-NEXT:    vmovupd %xmm0, (%rsi)
; X64-AVX-NEXT:    retq
entry:
  %0 = load <8 x double>, ptr %in
  %1 = fptrunc <8 x double> %0 to <8 x float>
  store <8 x float> %1, ptr %out, align 1
  ret void
}

define <4 x float> @fptrunc_frommem2_zext(ptr %ld) {
; X32-SSE-LABEL: fptrunc_frommem2_zext:
; X32-SSE:       # %bb.0:
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-SSE-NEXT:    cvtpd2ps (%eax), %xmm0
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: fptrunc_frommem2_zext:
; X32-AVX:       # %bb.0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vcvtpd2psx (%eax), %xmm0
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: fptrunc_frommem2_zext:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvtpd2ps (%rdi), %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: fptrunc_frommem2_zext:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vcvtpd2psx (%rdi), %xmm0
; X64-AVX-NEXT:    retq
  %arg = load <2 x double>, ptr %ld, align 16
  %cvt = fptrunc <2 x double> %arg to <2 x float>
  %ret = shufflevector <2 x float> %cvt, <2 x float> zeroinitializer, <4 x i32> <i32 0, i32 1, i32 2, i32 2>
  ret <4 x float> %ret
}

define <4 x float> @fptrunc_fromreg2_zext(<2 x double> %arg) {
; X32-SSE-LABEL: fptrunc_fromreg2_zext:
; X32-SSE:       # %bb.0:
; X32-SSE-NEXT:    cvtpd2ps %xmm0, %xmm0
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: fptrunc_fromreg2_zext:
; X32-AVX:       # %bb.0:
; X32-AVX-NEXT:    vcvtpd2ps %xmm0, %xmm0
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: fptrunc_fromreg2_zext:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvtpd2ps %xmm0, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: fptrunc_fromreg2_zext:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vcvtpd2ps %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %cvt = fptrunc <2 x double> %arg to <2 x float>
  %ret = shufflevector <2 x float> %cvt, <2 x float> zeroinitializer, <4 x i32> <i32 0, i32 1, i32 2, i32 2>
  ret <4 x float> %ret
}

; FIXME: For exact truncations we should be able to fold this.
define <4 x float> @fptrunc_fromconst() {
; X32-SSE-LABEL: fptrunc_fromconst:
; X32-SSE:       # %bb.0: # %entry
; X32-SSE-NEXT:    cvtpd2ps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; X32-SSE-NEXT:    cvtpd2ps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X32-SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: fptrunc_fromconst:
; X32-AVX:       # %bb.0: # %entry
; X32-AVX-NEXT:    vcvtpd2psy {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: fptrunc_fromconst:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    cvtpd2ps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; X64-SSE-NEXT:    cvtpd2ps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: fptrunc_fromconst:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    vcvtpd2psy {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-AVX-NEXT:    retq
entry:
  %0  = insertelement <4 x double> undef, double 1.0, i32 0
  %1  = insertelement <4 x double> %0, double -2.0, i32 1
  %2  = insertelement <4 x double> %1, double +4.0, i32 2
  %3  = insertelement <4 x double> %2, double -0.0, i32 3
  %4  = fptrunc <4 x double> %3 to <4 x float>
  ret <4 x float> %4
}
