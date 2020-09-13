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

define float @test_minnum_const_inf(float %x) {
; CHECK-LABEL: test_minnum_const_inf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI4_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vminnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI4_0:
; CHECK-NEXT:    .long 0x7f800000 @ float +Inf
  %r = call float @llvm.minnum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_maxnum_const_inf(float %x) {
; CHECK-LABEL: test_maxnum_const_inf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI5_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmaxnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI5_0:
; CHECK-NEXT:    .long 0x7f800000 @ float +Inf
  %r = call float @llvm.maxnum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_maximum_const_inf(float %x) {
; CHECK-LABEL: test_maximum_const_inf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI6_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmax.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI6_0:
; CHECK-NEXT:    .long 0x7f800000 @ float +Inf
  %r = call float @llvm.maximum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_minimum_const_inf(float %x) {
; CHECK-LABEL: test_minimum_const_inf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI7_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmin.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI7_0:
; CHECK-NEXT:    .long 0x7f800000 @ float +Inf
  %r = call float @llvm.minimum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_minnum_const_neg_inf(float %x) {
; CHECK-LABEL: test_minnum_const_neg_inf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI8_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vminnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI8_0:
; CHECK-NEXT:    .long 0xff800000 @ float -Inf
  %r = call float @llvm.minnum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_maxnum_const_neg_inf(float %x) {
; CHECK-LABEL: test_maxnum_const_neg_inf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI9_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmaxnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI9_0:
; CHECK-NEXT:    .long 0xff800000 @ float -Inf
  %r = call float @llvm.maxnum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_maximum_const_neg_inf(float %x) {
; CHECK-LABEL: test_maximum_const_neg_inf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI10_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmax.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI10_0:
; CHECK-NEXT:    .long 0xff800000 @ float -Inf
  %r = call float @llvm.maximum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_minimum_const_neg_inf(float %x) {
; CHECK-LABEL: test_minimum_const_neg_inf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI11_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmin.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI11_0:
; CHECK-NEXT:    .long 0xff800000 @ float -Inf
  %r = call float @llvm.minimum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_minnum_const_inf_nnan(float %x) {
; CHECK-LABEL: test_minnum_const_inf_nnan:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI12_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vminnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI12_0:
; CHECK-NEXT:    .long 0x7f800000 @ float +Inf
  %r = call nnan float @llvm.minnum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_maxnum_const_inf_nnan(float %x) {
; CHECK-LABEL: test_maxnum_const_inf_nnan:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI13_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmaxnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI13_0:
; CHECK-NEXT:    .long 0x7f800000 @ float +Inf
  %r = call nnan float @llvm.maxnum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_maximum_const_inf_nnan(float %x) {
; CHECK-LABEL: test_maximum_const_inf_nnan:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI14_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmax.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI14_0:
; CHECK-NEXT:    .long 0x7f800000 @ float +Inf
  %r = call nnan float @llvm.maximum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_minimum_const_inf_nnan(float %x) {
; CHECK-LABEL: test_minimum_const_inf_nnan:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI15_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmin.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI15_0:
; CHECK-NEXT:    .long 0x7f800000 @ float +Inf
  %r = call nnan float @llvm.minimum.f32(float %x, float 0x7ff0000000000000)
  ret float %r
}

define float @test_minnum_const_neg_inf_nnan(float %x) {
; CHECK-LABEL: test_minnum_const_neg_inf_nnan:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI16_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vminnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI16_0:
; CHECK-NEXT:    .long 0xff800000 @ float -Inf
  %r = call nnan float @llvm.minnum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_maxnum_const_neg_inf_nnan(float %x) {
; CHECK-LABEL: test_maxnum_const_neg_inf_nnan:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI17_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmaxnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI17_0:
; CHECK-NEXT:    .long 0xff800000 @ float -Inf
  %r = call nnan float @llvm.maxnum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_maximum_const_neg_inf_nnan(float %x) {
; CHECK-LABEL: test_maximum_const_neg_inf_nnan:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI18_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmax.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI18_0:
; CHECK-NEXT:    .long 0xff800000 @ float -Inf
  %r = call nnan float @llvm.maximum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_minimum_const_neg_inf_nnan(float %x) {
; CHECK-LABEL: test_minimum_const_neg_inf_nnan:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI19_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmin.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI19_0:
; CHECK-NEXT:    .long 0xff800000 @ float -Inf
  %r = call nnan float @llvm.minimum.f32(float %x, float 0xfff0000000000000)
  ret float %r
}

define float @test_minnum_const_max(float %x) {
; CHECK-LABEL: test_minnum_const_max:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI20_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vminnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI20_0:
; CHECK-NEXT:    .long 0x7f7fffff @ float 3.40282347E+38
  %r = call float @llvm.minnum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_maxnum_const_max(float %x) {
; CHECK-LABEL: test_maxnum_const_max:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI21_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmaxnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI21_0:
; CHECK-NEXT:    .long 0x7f7fffff @ float 3.40282347E+38
  %r = call float @llvm.maxnum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_maximum_const_max(float %x) {
; CHECK-LABEL: test_maximum_const_max:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI22_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmax.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI22_0:
; CHECK-NEXT:    .long 0x7f7fffff @ float 3.40282347E+38
  %r = call float @llvm.maximum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_minimum_const_max(float %x) {
; CHECK-LABEL: test_minimum_const_max:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI23_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmin.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI23_0:
; CHECK-NEXT:    .long 0x7f7fffff @ float 3.40282347E+38
  %r = call float @llvm.minimum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_minnum_const_neg_max(float %x) {
; CHECK-LABEL: test_minnum_const_neg_max:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI24_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vminnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI24_0:
; CHECK-NEXT:    .long 0xff7fffff @ float -3.40282347E+38
  %r = call float @llvm.minnum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_maxnum_const_neg_max(float %x) {
; CHECK-LABEL: test_maxnum_const_neg_max:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI25_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmaxnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI25_0:
; CHECK-NEXT:    .long 0xff7fffff @ float -3.40282347E+38
  %r = call float @llvm.maxnum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_maximum_const_neg_max(float %x) {
; CHECK-LABEL: test_maximum_const_neg_max:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI26_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmax.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI26_0:
; CHECK-NEXT:    .long 0xff7fffff @ float -3.40282347E+38
  %r = call float @llvm.maximum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_minimum_const_neg_max(float %x) {
; CHECK-LABEL: test_minimum_const_neg_max:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI27_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmin.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI27_0:
; CHECK-NEXT:    .long 0xff7fffff @ float -3.40282347E+38
  %r = call float @llvm.minimum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_minnum_const_max_ninf(float %x) {
; CHECK-LABEL: test_minnum_const_max_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI28_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vminnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI28_0:
; CHECK-NEXT:    .long 0x7f7fffff @ float 3.40282347E+38
  %r = call ninf float @llvm.minnum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_maxnum_const_max_ninf(float %x) {
; CHECK-LABEL: test_maxnum_const_max_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI29_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmaxnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI29_0:
; CHECK-NEXT:    .long 0x7f7fffff @ float 3.40282347E+38
  %r = call ninf float @llvm.maxnum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_maximum_const_max_ninf(float %x) {
; CHECK-LABEL: test_maximum_const_max_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI30_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmax.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI30_0:
; CHECK-NEXT:    .long 0x7f7fffff @ float 3.40282347E+38
  %r = call ninf float @llvm.maximum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_minimum_const_max_ninf(float %x) {
; CHECK-LABEL: test_minimum_const_max_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI31_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmin.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI31_0:
; CHECK-NEXT:    .long 0x7f7fffff @ float 3.40282347E+38
  %r = call ninf float @llvm.minimum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_minnum_const_neg_max_ninf(float %x) {
; CHECK-LABEL: test_minnum_const_neg_max_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI32_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vminnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI32_0:
; CHECK-NEXT:    .long 0xff7fffff @ float -3.40282347E+38
  %r = call ninf float @llvm.minnum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_maxnum_const_neg_max_ninf(float %x) {
; CHECK-LABEL: test_maxnum_const_neg_max_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI33_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmaxnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI33_0:
; CHECK-NEXT:    .long 0xff7fffff @ float -3.40282347E+38
  %r = call ninf float @llvm.maxnum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_maximum_const_neg_max_ninf(float %x) {
; CHECK-LABEL: test_maximum_const_neg_max_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI34_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmax.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI34_0:
; CHECK-NEXT:    .long 0xff7fffff @ float -3.40282347E+38
  %r = call ninf float @llvm.maximum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_minimum_const_neg_max_ninf(float %x) {
; CHECK-LABEL: test_minimum_const_neg_max_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI35_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmin.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI35_0:
; CHECK-NEXT:    .long 0xff7fffff @ float -3.40282347E+38
  %r = call ninf float @llvm.minimum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_minnum_const_max_nnan_ninf(float %x) {
; CHECK-LABEL: test_minnum_const_max_nnan_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI36_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vminnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI36_0:
; CHECK-NEXT:    .long 0x7f7fffff @ float 3.40282347E+38
  %r = call nnan ninf float @llvm.minnum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_maxnum_const_max_nnan_ninf(float %x) {
; CHECK-LABEL: test_maxnum_const_max_nnan_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI37_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmaxnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI37_0:
; CHECK-NEXT:    .long 0x7f7fffff @ float 3.40282347E+38
  %r = call nnan ninf float @llvm.maxnum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_maximum_const_max_nnan_ninf(float %x) {
; CHECK-LABEL: test_maximum_const_max_nnan_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI38_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmax.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI38_0:
; CHECK-NEXT:    .long 0x7f7fffff @ float 3.40282347E+38
  %r = call nnan ninf float @llvm.maximum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_minimum_const_max_nnan_ninf(float %x) {
; CHECK-LABEL: test_minimum_const_max_nnan_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI39_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmin.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI39_0:
; CHECK-NEXT:    .long 0x7f7fffff @ float 3.40282347E+38
  %r = call nnan ninf float @llvm.minimum.f32(float %x, float 0x47efffffe0000000)
  ret float %r
}

define float @test_minnum_const_neg_max_nnan_ninf(float %x) {
; CHECK-LABEL: test_minnum_const_neg_max_nnan_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI40_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vminnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI40_0:
; CHECK-NEXT:    .long 0xff7fffff @ float -3.40282347E+38
  %r = call nnan ninf float @llvm.minnum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_maxnum_const_neg_max_nnan_ninf(float %x) {
; CHECK-LABEL: test_maxnum_const_neg_max_nnan_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI41_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmaxnm.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI41_0:
; CHECK-NEXT:    .long 0xff7fffff @ float -3.40282347E+38
  %r = call nnan ninf float @llvm.maxnum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_maximum_const_neg_max_nnan_ninf(float %x) {
; CHECK-LABEL: test_maximum_const_neg_max_nnan_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI42_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmax.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI42_0:
; CHECK-NEXT:    .long 0xff7fffff @ float -3.40282347E+38
  %r = call nnan ninf float @llvm.maximum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}

define float @test_minimum_const_neg_max_nnan_ninf(float %x) {
; CHECK-LABEL: test_minimum_const_neg_max_nnan_ninf:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr s0, .LCPI43_0
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vmin.f32 d0, d1, d0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI43_0:
; CHECK-NEXT:    .long 0xff7fffff @ float -3.40282347E+38
  %r = call nnan ninf float @llvm.minimum.f32(float %x, float 0xc7efffffe0000000)
  ret float %r
}
