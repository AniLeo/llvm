; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown -mattr=+avx512fp16 < %s | FileCheck %s

; Verify that we're folding the load into the math instruction.
; This pattern is generated out of the simplest intrinsics usage:
;  _mm_add_ss(a, _mm_load_ss(b));

define <8 x half> @addsh(<8 x half> %va, ptr %pb) {
; CHECK-LABEL: addsh:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vaddsh (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a = extractelement <8 x half> %va, i32 0
  %b = load half, ptr %pb
  %r = fadd half %a, %b
  %vr = insertelement <8 x half> %va, half %r, i32 0
  ret <8 x half> %vr
}

define <8 x half> @subsh(<8 x half> %va, ptr %pb) {
; CHECK-LABEL: subsh:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsubsh (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a = extractelement <8 x half> %va, i32 0
  %b = load half, ptr %pb
  %r = fsub half %a, %b
  %vr = insertelement <8 x half> %va, half %r, i32 0
  ret <8 x half> %vr
}

define <8 x half> @mulsh(<8 x half> %va, ptr %pb) {
; CHECK-LABEL: mulsh:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmulsh (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a = extractelement <8 x half> %va, i32 0
  %b = load half, ptr %pb
  %r = fmul half %a, %b
  %vr = insertelement <8 x half> %va, half %r, i32 0
  ret <8 x half> %vr
}

define <8 x half> @divsh(<8 x half> %va, ptr %pb) {
; CHECK-LABEL: divsh:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vdivsh (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a = extractelement <8 x half> %va, i32 0
  %b = load half, ptr %pb
  %r = fdiv half %a, %b
  %vr = insertelement <8 x half> %va, half %r, i32 0
  ret <8 x half> %vr
}

define <8 x half> @minsh(<8 x half> %va, ptr %pb) {
; CHECK-LABEL: minsh:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vminsh (%rdi), %xmm0, %xmm1
; CHECK-NEXT:    vmovsh %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a = extractelement <8 x half> %va, i32 0
  %b = load half, ptr %pb
  %r = call nnan half @llvm.minnum.f16(half %a, half %b) readnone
  %vr = insertelement <8 x half> %va, half %r, i32 0
  ret <8 x half> %vr
}

define <8 x half> @maxsh(<8 x half> %va, ptr %pb) {
; CHECK-LABEL: maxsh:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vminsh (%rdi), %xmm0, %xmm1
; CHECK-NEXT:    vmovsh %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a = extractelement <8 x half> %va, i32 0
  %b = load half, ptr %pb
  %r = call nnan half @llvm.minnum.f16(half %a, half %b) readnone
  %vr = insertelement <8 x half> %va, half %r, i32 0
  ret <8 x half> %vr
}

declare half @llvm.minnum.f16(half, half)
declare half @llvm.maxnum.f16(half, half)
