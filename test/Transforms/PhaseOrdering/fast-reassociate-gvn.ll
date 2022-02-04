; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
;
; Test cases in this file are intended to be run with both reassociate and
; gvn passes enabled.
;
; Test numbering remains continuous across:
; - InstCombine/fast-basictest.ll
; - PhaseOrdering/fast-basictest.ll
; - PhaseOrdering/fast-reassociate-gvn.ll
; - Reassociate/fast-basictest.ll
;
; RUN: opt < %s -reassociate -gvn -S | FileCheck %s --check-prefixes=CHECK,REASSOC_AND_GVN --allow-unused-prefixes
; RUN: opt < %s -O2 -S | FileCheck %s --check-prefixes=CHECK,O2 --allow-unused-prefixes

@fe = external global float
@fa = external global float
@fb = external global float
@fc = external global float
@ff = external global float

; If two sums of the same operands in different order are counted with 'fast'
; flag and then stored to global variables, we can reuse the same value twice.
; Sums:
; - test3: (a+b)+c and (a+c)+b
; - test4: c+(a+b) and (c+a)+b
; - test5: c+(b+a) and (c+a)+b
; TODO: check if 'reassoc' flag is technically enough for this optimization
; (currently the transformation is not done with 'reassoc' only).

define void @test3() {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[A:%.*]] = load float, float* @fa, align 4
; CHECK-NEXT:    [[B:%.*]] = load float, float* @fb, align 4
; CHECK-NEXT:    [[C:%.*]] = load float, float* @fc, align 4
; CHECK-NEXT:    [[T1:%.*]] = fadd fast float [[B]], [[A]]
; CHECK-NEXT:    [[T2:%.*]] = fadd fast float [[T1]], [[C]]
; CHECK-NEXT:    store float [[T2]], float* @fe, align 4
; CHECK-NEXT:    store float [[T2]], float* @ff, align 4
; CHECK-NEXT:    ret void
;
  %A = load float, float* @fa
  %B = load float, float* @fb
  %C = load float, float* @fc
  %t1 = fadd fast float %A, %B
  %t2 = fadd fast float %t1, %C
  %t3 = fadd fast float %A, %C
  %t4 = fadd fast float %t3, %B
  ; e = (a+b)+c;
  store float %t2, float* @fe
  ; f = (a+c)+b
  store float %t4, float* @ff
  ret void
}

define void @test4() {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[A:%.*]] = load float, float* @fa, align 4
; CHECK-NEXT:    [[B:%.*]] = load float, float* @fb, align 4
; CHECK-NEXT:    [[C:%.*]] = load float, float* @fc, align 4
; CHECK-NEXT:    [[T1:%.*]] = fadd fast float [[B]], [[A]]
; CHECK-NEXT:    [[T2:%.*]] = fadd fast float [[T1]], [[C]]
; CHECK-NEXT:    store float [[T2]], float* @fe, align 4
; CHECK-NEXT:    store float [[T2]], float* @ff, align 4
; CHECK-NEXT:    ret void
;
  %A = load float, float* @fa
  %B = load float, float* @fb
  %C = load float, float* @fc
  %t1 = fadd fast float %A, %B
  %t2 = fadd fast float %C, %t1
  %t3 = fadd fast float %C, %A
  %t4 = fadd fast float %t3, %B
  ; e = c+(a+b)
  store float %t2, float* @fe
  ; f = (c+a)+b
  store float %t4, float* @ff
  ret void
}

define void @test5() {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[A:%.*]] = load float, float* @fa, align 4
; CHECK-NEXT:    [[B:%.*]] = load float, float* @fb, align 4
; CHECK-NEXT:    [[C:%.*]] = load float, float* @fc, align 4
; CHECK-NEXT:    [[T1:%.*]] = fadd fast float [[B]], [[A]]
; CHECK-NEXT:    [[T2:%.*]] = fadd fast float [[T1]], [[C]]
; CHECK-NEXT:    store float [[T2]], float* @fe, align 4
; CHECK-NEXT:    store float [[T2]], float* @ff, align 4
; CHECK-NEXT:    ret void
;
  %A = load float, float* @fa
  %B = load float, float* @fb
  %C = load float, float* @fc
  %t1 = fadd fast float %B, %A
  %t2 = fadd fast float %C, %t1
  %t3 = fadd fast float %C, %A
  %t4 = fadd fast float %t3, %B
  ; e = c+(b+a)
  store float %t2, float* @fe
  ; f = (c+a)+b
  store float %t4, float* @ff
  ret void
}
