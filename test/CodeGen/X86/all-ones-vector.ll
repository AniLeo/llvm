; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X32 --check-prefix=X32-SSE
; RUN: llc < %s -mtriple=i386-unknown -mattr=+avx  | FileCheck %s --check-prefix=X32 --check-prefix=X32-AVX
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X64 --check-prefix=X64-SSE
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx  | FileCheck %s --check-prefix=X64 --check-prefix=X64-AVX

define <16 x i8> @coo() nounwind {
; X32-SSE-LABEL: coo:
; X32-SSE:       # BB#0:
; X32-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: coo:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: coo:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: coo:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  ret <16 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
}

define <8 x i16> @soo() nounwind {
; X32-SSE-LABEL: soo:
; X32-SSE:       # BB#0:
; X32-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: soo:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: soo:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: soo:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  ret <8 x i16> <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>
}

define <4 x i32> @ioo() nounwind {
; X32-SSE-LABEL: ioo:
; X32-SSE:       # BB#0:
; X32-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: ioo:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: ioo:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: ioo:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  ret <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
}

define <2 x i64> @loo() nounwind {
; X32-SSE-LABEL: loo:
; X32-SSE:       # BB#0:
; X32-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: loo:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: loo:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: loo:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  ret <2 x i64> <i64 -1, i64 -1>
}

define <2 x double> @doo() nounwind {
; X32-SSE-LABEL: doo:
; X32-SSE:       # BB#0:
; X32-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: doo:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: doo:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: doo:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  ret <2 x double> <double 0xffffffffffffffff, double 0xffffffffffffffff>
}

define <4 x float> @foo() nounwind {
; X32-SSE-LABEL: foo:
; X32-SSE:       # BB#0:
; X32-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: foo:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: foo:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: foo:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  ret <4 x float> <float 0xffffffffe0000000, float 0xffffffffe0000000, float 0xffffffffe0000000, float 0xffffffffe0000000>
}
