; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+sse2 | FileCheck %s --check-prefix=CHECK --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+sse4.1 | FileCheck %s --check-prefix=CHECK --check-prefix=SSE41

; Make sure that the conversion between v4i8 to v2i16 is not a simple bitcast.
define void @prom_bug(<4 x i8> %t, i16* %p) {
; SSE2-LABEL: prom_bug:
; SSE2:       ## BB#0:
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,1,0,3]
; SSE2-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,5,5,6,7]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    movw %ax, (%rdi)
; SSE2-NEXT:    retq
;
; SSE41-LABEL: prom_bug:
; SSE41:       ## BB#0:
; SSE41-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE41-NEXT:    pmovzxwq {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero
; SSE41-NEXT:    pextrw $0, %xmm0, (%rdi)
; SSE41-NEXT:    retq
  %r = bitcast <4 x i8> %t to <2 x i16>
  %o = extractelement <2 x i16> %r, i32 0
  store i16 %o, i16* %p
  ret void
}

