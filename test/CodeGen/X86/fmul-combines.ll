; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown < %s | FileCheck %s

define float @fmul2_f32(float %x) {
; CHECK-LABEL: fmul2_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addss %xmm0, %xmm0
; CHECK-NEXT:    retq
  %y = fmul float %x, 2.0
  ret float %y
}

; fmul 2.0, x -> fadd x, x for vectors.

define <4 x float> @fmul2_v4f32(<4 x float> %x) {
; CHECK-LABEL: fmul2_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addps %xmm0, %xmm0
; CHECK-NEXT:    retq
  %y = fmul <4 x float> %x, <float 2.0, float 2.0, float 2.0, float 2.0>
  ret <4 x float> %y
}

define <4 x float> @constant_fold_fmul_v4f32(<4 x float> %x) {
; CHECK-LABEL: constant_fold_fmul_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [8,8,8,8]
; CHECK-NEXT:    retq
  %y = fmul <4 x float> <float 4.0, float 4.0, float 4.0, float 4.0>, <float 2.0, float 2.0, float 2.0, float 2.0>
  ret <4 x float> %y
}

define <4 x float> @fmul0_v4f32(<4 x float> %x) #0 {
; CHECK-LABEL: fmul0_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorps %xmm0, %xmm0
; CHECK-NEXT:    retq
  %y = fmul <4 x float> %x, <float 0.0, float 0.0, float 0.0, float 0.0>
  ret <4 x float> %y
}

define <4 x float> @fmul_c2_c4_v4f32(<4 x float> %x) #0 {
; CHECK-LABEL: fmul_c2_c4_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulps {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %y = fmul <4 x float> %x, <float 2.0, float 2.0, float 2.0, float 2.0>
  %z = fmul <4 x float> %y, <float 4.0, float 4.0, float 4.0, float 4.0>
  ret <4 x float> %z
}

define <4 x float> @fmul_c3_c4_v4f32(<4 x float> %x) #0 {
; CHECK-LABEL: fmul_c3_c4_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulps {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %y = fmul <4 x float> %x, <float 3.0, float 3.0, float 3.0, float 3.0>
  %z = fmul <4 x float> %y, <float 4.0, float 4.0, float 4.0, float 4.0>
  ret <4 x float> %z
}

; CHECK: float 5
; CHECK: float 12
; CHECK: float 21
; CHECK: float 32

; We should be able to pre-multiply the two constant vectors.
define <4 x float> @fmul_v4f32_two_consts_no_splat(<4 x float> %x) #0 {
; CHECK-LABEL: fmul_v4f32_two_consts_no_splat:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulps {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %y = fmul <4 x float> %x, <float 1.0, float 2.0, float 3.0, float 4.0>
  %z = fmul <4 x float> %y, <float 5.0, float 6.0, float 7.0, float 8.0>
  ret <4 x float> %z
}

; Same as above, but reverse operands to make sure non-canonical form is also handled.
define <4 x float> @fmul_v4f32_two_consts_no_splat_non_canonical(<4 x float> %x) #0 {
; CHECK-LABEL: fmul_v4f32_two_consts_no_splat_non_canonical:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulps {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %y = fmul <4 x float> <float 1.0, float 2.0, float 3.0, float 4.0>, %x
  %z = fmul <4 x float> <float 5.0, float 6.0, float 7.0, float 8.0>, %y
  ret <4 x float> %z
}

; Node-level FMF and no function-level attributes.

define <4 x float> @fmul_v4f32_two_consts_no_splat_reassoc(<4 x float> %x) {
; CHECK-LABEL: fmul_v4f32_two_consts_no_splat_reassoc:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulps {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %y = fmul <4 x float> %x, <float 1.0, float 2.0, float 3.0, float 4.0>
  %z = fmul reassoc <4 x float> %y, <float 5.0, float 6.0, float 7.0, float 8.0>
  ret <4 x float> %z
}

; Multiplication by 2.0 is a special case because that gets converted to fadd x, x.

define <4 x float> @fmul_v4f32_two_consts_no_splat_reassoc_2(<4 x float> %x) {
; CHECK-LABEL: fmul_v4f32_two_consts_no_splat_reassoc_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulps {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %y = fadd <4 x float> %x, %x
  %z = fmul reassoc <4 x float> %y, <float 5.0, float 6.0, float 7.0, float 8.0>
  ret <4 x float> %z
}

; CHECK: float 6
; CHECK: float 14
; CHECK: float 24
; CHECK: float 36

; More than one use of a constant multiply should not inhibit the optimization.
; Instead of a chain of 2 dependent mults, this test will have 2 independent mults.
define <4 x float> @fmul_v4f32_two_consts_no_splat_multiple_use(<4 x float> %x) #0 {
; CHECK-LABEL: fmul_v4f32_two_consts_no_splat_multiple_use:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulps {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %y = fmul <4 x float> %x, <float 1.0, float 2.0, float 3.0, float 4.0>
  %z = fmul <4 x float> %y, <float 5.0, float 6.0, float 7.0, float 8.0>
  %a = fadd <4 x float> %y, %z
  ret <4 x float> %a
}

; PR22698 - http://llvm.org/bugs/show_bug.cgi?id=22698
; Make sure that we don't infinite loop swapping constants back and forth.

; CHECK: float 24
; CHECK: float 24
; CHECK: float 24
; CHECK: float 24

define <4 x float> @PR22698_splats(<4 x float> %a) #0 {
; CHECK-LABEL: PR22698_splats:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulps {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %mul1 = fmul fast <4 x float> <float 2.0, float 2.0, float 2.0, float 2.0>, <float 3.0, float 3.0, float 3.0, float 3.0>
  %mul2 = fmul fast <4 x float> <float 4.0, float 4.0, float 4.0, float 4.0>, %mul1
  %mul3 = fmul fast <4 x float> %a, %mul2
  ret <4 x float> %mul3
}

; Same as above, but verify that non-splat vectors are handled correctly too.

; CHECK: float 45
; CHECK: float 120
; CHECK: float 231
; CHECK: float 384

define <4 x float> @PR22698_no_splats(<4 x float> %a) #0 {
; CHECK-LABEL: PR22698_no_splats:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulps {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %mul1 = fmul fast <4 x float> <float 1.0, float 2.0, float 3.0, float 4.0>, <float 5.0, float 6.0, float 7.0, float 8.0>
  %mul2 = fmul fast <4 x float> <float 9.0, float 10.0, float 11.0, float 12.0>, %mul1
  %mul3 = fmul fast <4 x float> %a, %mul2
  ret <4 x float> %mul3
}

define float @fmul_c2_c4_f32(float %x) #0 {
; CHECK-LABEL: fmul_c2_c4_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulss {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %y = fmul float %x, 2.0
  %z = fmul float %y, 4.0
  ret float %z
}

define float @fmul_c3_c4_f32(float %x) #0 {
; CHECK-LABEL: fmul_c3_c4_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulss {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %y = fmul float %x, 3.0
  %z = fmul float %y, 4.0
  ret float %z
}

define float @fmul_fneg_fneg_f32(float %x, float %y) {
; CHECK-LABEL: fmul_fneg_fneg_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulss %xmm1, %xmm0
; CHECK-NEXT:    retq
  %x.neg = fsub float -0.0, %x
  %y.neg = fsub float -0.0, %y
  %mul = fmul float %x.neg, %y.neg
  ret float %mul
}

define <4 x float> @fmul_fneg_fneg_v4f32(<4 x float> %x, <4 x float> %y) {
; CHECK-LABEL: fmul_fneg_fneg_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %x.neg = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %x
  %y.neg = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %y
  %mul = fmul <4 x float> %x.neg, %y.neg
  ret <4 x float> %mul
}

attributes #0 = { "less-precise-fpmad"="true" "no-infs-fp-math"="true" "no-nans-fp-math"="true" "unsafe-fp-math"="true" }
