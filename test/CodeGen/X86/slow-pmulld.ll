; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown-unknown -mcpu=silvermont | FileCheck %s --check-prefix=CHECK32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=silvermont | FileCheck %s --check-prefix=CHECK64
; RUN: llc < %s -mtriple=i386-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE4-32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE4-64

; Make sure that the slow-pmulld feature can be used without SSE4.1.
; RUN: llc < %s -mtriple=i386-unknown-unknown -mcpu=silvermont -mattr=-sse4.1

define <4 x i32> @foo(<4 x i8> %A) {
; CHECK32-LABEL: foo:
; CHECK32:       # BB#0:
; CHECK32-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0],zero,xmm0[4],zero,xmm0[8],zero,xmm0[12],zero,xmm0[u,u,u,u,u,u,u,u]
; CHECK32-NEXT:    movdqa {{.*#+}} xmm1 = <18778,18778,18778,18778,u,u,u,u>
; CHECK32-NEXT:    movdqa %xmm0, %xmm2
; CHECK32-NEXT:    pmullw %xmm1, %xmm0
; CHECK32-NEXT:    pmulhw %xmm1, %xmm2
; CHECK32-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3]
; CHECK32-NEXT:    retl
;
; CHECK64-LABEL: foo:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0],zero,xmm0[4],zero,xmm0[8],zero,xmm0[12],zero,xmm0[u,u,u,u,u,u,u,u]
; CHECK64-NEXT:    movdqa {{.*#+}} xmm1 = <18778,18778,18778,18778,u,u,u,u>
; CHECK64-NEXT:    movdqa %xmm0, %xmm2
; CHECK64-NEXT:    pmullw %xmm1, %xmm0
; CHECK64-NEXT:    pmulhw %xmm1, %xmm2
; CHECK64-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3]
; CHECK64-NEXT:    retq
;
; SSE4-32-LABEL: foo:
; SSE4-32:       # BB#0:
; SSE4-32-NEXT:    pand {{\.LCPI.*}}, %xmm0
; SSE4-32-NEXT:    pmulld {{\.LCPI.*}}, %xmm0
; SSE4-32-NEXT:    retl
;
; SSE4-64-LABEL: foo:
; SSE4-64:       # BB#0:
; SSE4-64-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE4-64-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE4-64-NEXT:    retq
  %z = zext <4 x i8> %A to <4 x i32>
  %m = mul nuw nsw <4 x i32> %z, <i32 18778, i32 18778, i32 18778, i32 18778>
  ret <4 x i32> %m
}

define <4 x i32> @foo_os(<4 x i8> %A) minsize {
; CHECK32-LABEL: foo_os:
; CHECK32:       # BB#0:
; CHECK32-NEXT:    pand {{\.LCPI.*}}, %xmm0
; CHECK32-NEXT:    pmulld {{\.LCPI.*}}, %xmm0
; CHECK32-NEXT:    retl
;
; CHECK64-LABEL: foo_os:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    pand {{.*}}(%rip), %xmm0
; CHECK64-NEXT:    pmulld {{.*}}(%rip), %xmm0
; CHECK64-NEXT:    retq
;
; SSE4-32-LABEL: foo_os:
; SSE4-32:       # BB#0:
; SSE4-32-NEXT:    pand {{\.LCPI.*}}, %xmm0
; SSE4-32-NEXT:    pmulld {{\.LCPI.*}}, %xmm0
; SSE4-32-NEXT:    retl
;
; SSE4-64-LABEL: foo_os:
; SSE4-64:       # BB#0:
; SSE4-64-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE4-64-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE4-64-NEXT:    retq
  %z = zext <4 x i8> %A to <4 x i32>
  %m = mul nuw nsw <4 x i32> %z, <i32 18778, i32 18778, i32 18778, i32 18778>
  ret <4 x i32> %m
}
