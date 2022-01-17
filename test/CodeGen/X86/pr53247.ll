; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3 | FileCheck %s --check-prefixes=SSE
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX

define i32 @PR53247(){
; SSE-LABEL: PR53247:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    pxor %xmm0, %xmm0
; SSE-NEXT:    phaddd %xmm0, %xmm0
; SSE-NEXT:    phaddd %xmm0, %xmm0
; SSE-NEXT:    movd %xmm0, %eax
; SSE-NEXT:    retq
;
; AVX-LABEL: PR53247:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovd %xmm0, %eax
; AVX-NEXT:    retq
entry:
  %0 = call <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32> zeroinitializer, <4 x i32> zeroinitializer)
  %1 = call <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32> %0, <4 x i32> zeroinitializer)
  %vecext.i = extractelement <4 x i32> %1, i32 0
  ret i32 %vecext.i
}
declare <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32>, <4 x i32>)
