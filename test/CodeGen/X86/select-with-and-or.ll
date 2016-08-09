; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s

define <4 x i32> @test1(<4 x float> %a, <4 x float> %b, <4 x i32> %c) {
; CHECK-LABEL: test1:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpnleps %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vandps %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <4 x float> %a, %b
  %r = select <4 x i1> %f, <4 x i32> %c, <4 x i32> zeroinitializer
  ret <4 x i32> %r
}

define <4 x i32> @test2(<4 x float> %a, <4 x float> %b, <4 x i32> %c) {
; CHECK-LABEL: test2:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpnleps %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vorps %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <4 x float> %a, %b
  %r = select <4 x i1> %f, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> %c
  ret <4 x i32> %r
}

define <4 x i32> @test3(<4 x float> %a, <4 x float> %b, <4 x i32> %c) {
; CHECK-LABEL: test3:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpleps %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vandps %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <4 x float> %a, %b
  %r = select <4 x i1> %f, <4 x i32> zeroinitializer, <4 x i32> %c
  ret <4 x i32> %r
}

define <4 x i32> @test4(<4 x float> %a, <4 x float> %b, <4 x i32> %c) {
; CHECK-LABEL: test4:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpleps %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vorps %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <4 x float> %a, %b
  %r = select <4 x i1> %f, <4 x i32> %c, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %r
}

define <4 x i32> @test5(<4 x float> %a, <4 x float> %b, <4 x i32> %c) {
; CHECK-LABEL: test5:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpnleps %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <4 x float> %a, %b
  %r = sext <4 x i1> %f to <4 x i32>
  ret <4 x i32> %r
}

define <4 x i32> @test6(<4 x float> %a, <4 x float> %b, <4 x i32> %c) {
; CHECK-LABEL: test6:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpleps %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
;
  %not.f = fcmp oge <4 x float> %a, %b
  %r = sext <4 x i1> %not.f to <4 x i32>
  ret <4 x i32> %r
}

define <4 x i32> @test7(<4 x float> %a, <4 x float> %b, <4 x i32>* %p) {
; CHECK-LABEL: test7:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpnleps %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vandps (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <4 x float> %a, %b
  %l = load <4 x i32>, <4 x i32>* %p, align 16
  %r = select <4 x i1> %f, <4 x i32> %l, <4 x i32> zeroinitializer
  ret <4 x i32> %r
}

; FIXME: None of these should use vblendvpd.
; Repeat all with FP types.

define <2 x double> @test1f(<2 x double> %a, <2 x double> %b, <2 x double> %c) {
; CHECK-LABEL: test1f:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpnlepd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vblendvpd %xmm0, %xmm2, %xmm1, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <2 x double> %a, %b
  %r = select <2 x i1> %f, <2 x double> %c, <2 x double> zeroinitializer
  ret <2 x double> %r
}

define <2 x double> @test2f(<2 x double> %a, <2 x double> %b, <2 x double> %c) {
; CHECK-LABEL: test2f:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpnlepd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vblendvpd %xmm0, %xmm1, %xmm2, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <2 x double> %a, %b
  %r = select <2 x i1> %f, <2 x double> <double 0xffffffffffffffff, double 0xffffffffffffffff>, <2 x double> %c
  ret <2 x double> %r
}

define <2 x double> @test3f(<2 x double> %a, <2 x double> %b, <2 x double> %c) {
; CHECK-LABEL: test3f:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpnlepd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vblendvpd %xmm0, %xmm1, %xmm2, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <2 x double> %a, %b
  %r = select <2 x i1> %f, <2 x double> zeroinitializer, <2 x double> %c
  ret <2 x double> %r
}

define <2 x double> @test4f(<2 x double> %a, <2 x double> %b, <2 x double> %c) {
; CHECK-LABEL: test4f:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpnlepd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vblendvpd %xmm0, %xmm2, %xmm1, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <2 x double> %a, %b
  %r = select <2 x i1> %f, <2 x double> %c, <2 x double> <double 0xffffffffffffffff, double 0xffffffffffffffff>
  ret <2 x double> %r
}

define <2 x double> @test5f(<2 x double> %a, <2 x double> %b, <2 x double> %c) {
; CHECK-LABEL: test5f:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpnlepd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vxorpd %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vblendvpd %xmm0, %xmm1, %xmm2, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <2 x double> %a, %b
  %r = select <2 x i1> %f, <2 x double> <double 0xffffffffffffffff, double 0xffffffffffffffff>, <2 x double> zeroinitializer
  ret <2 x double> %r
}

define <2 x double> @test6f(<2 x double> %a, <2 x double> %b, <2 x double> %c) {
; CHECK-LABEL: test6f:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpnlepd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vblendvpd %xmm0, %xmm1, %xmm2, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <2 x double> %a, %b
  %r = select <2 x i1> %f, <2 x double> zeroinitializer, <2 x double> <double 0xffffffffffffffff, double 0xffffffffffffffff>
  ret <2 x double> %r
}

define <2 x double> @test7f(<2 x double> %a, <2 x double> %b, <2 x double>* %p) {
; CHECK-LABEL: test7f:
; CHECK:       # BB#0:
; CHECK-NEXT:    vcmpnlepd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vblendvpd %xmm0, (%rdi), %xmm1, %xmm0
; CHECK-NEXT:    retq
;
  %f = fcmp ult <2 x double> %a, %b
  %l = load <2 x double>, <2 x double>* %p, align 16
  %r = select <2 x i1> %f, <2 x double> %l, <2 x double> zeroinitializer
  ret <2 x double> %r
}

