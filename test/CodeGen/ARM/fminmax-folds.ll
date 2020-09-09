; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=armv8-eabi | FileCheck %s

declare float @llvm.minnum.f32(float, float)
declare float @llvm.maxnum.f32(float, float)
declare float @llvm.minimum.f32(float, float)
declare float @llvm.maximum.f32(float, float)

define float @test_minnum_const_nan(float %x) {
; CHECK-LABEL: test_minnum_const_nan:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    bx lr
  %r = call float @llvm.minnum.f32(float %x, float 0x7fff000000000000)
  ret float %r
}

define float @test_maxnum_const_nan(float %x) {
; CHECK-LABEL: test_maxnum_const_nan:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    bx lr
  %r = call float @llvm.maxnum.f32(float %x, float 0x7fff000000000000)
  ret float %r
}

define float @test_maximum_const_nan(float %x) {
; CHECK-LABEL: test_maximum_const_nan:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #0
; CHECK-NEXT:    movt r0, #32760
; CHECK-NEXT:    bx lr
  %r = call float @llvm.maximum.f32(float %x, float 0x7fff000000000000)
  ret float %r
}

define float @test_minimum_const_nan(float %x) {
; CHECK-LABEL: test_minimum_const_nan:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #0
; CHECK-NEXT:    movt r0, #32760
; CHECK-NEXT:    bx lr
  %r = call float @llvm.minimum.f32(float %x, float 0x7fff000000000000)
  ret float %r
}
