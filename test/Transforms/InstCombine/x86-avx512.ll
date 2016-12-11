; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare <4 x float> @llvm.x86.avx512.mask.add.ss.round(<4 x float>, <4 x float>, <4 x float>, i8, i32)

define <4 x float> @test_add_ss(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test_add_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x float> @llvm.x86.avx512.mask.add.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> undef, i8 -1, i32 4)
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x float> %b, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = tail call <4 x float> @llvm.x86.avx512.mask.add.ss.round(<4 x float> %a, <4 x float> %3, <4 x float> undef, i8 -1, i32 4)
  ret <4 x float> %4
}

define <4 x float> @test_add_ss_mask(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 %mask) {
; CHECK-LABEL: @test_add_ss_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x float> @llvm.x86.avx512.mask.add.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 %mask, i32 4)
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x float> %c, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = tail call <4 x float> @llvm.x86.avx512.mask.add.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> %3, i8 %mask, i32 4)
  ret <4 x float> %4
}

declare <2 x double> @llvm.x86.avx512.mask.add.sd.round(<2 x double>, <2 x double>, <2 x double>, i8, i32)

define <2 x double> @test_add_sd(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @test_add_sd(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <2 x double> @llvm.x86.avx512.mask.add.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> undef, i8 -1, i32 4)
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x double> %b, double 1.000000e+00, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx512.mask.add.sd.round(<2 x double> %a, <2 x double> %1, <2 x double> undef, i8 -1, i32 4)
  ret <2 x double> %2
}

define <2 x double> @test_add_sd_mask(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask) {
; CHECK-LABEL: @test_add_sd_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <2 x double> @llvm.x86.avx512.mask.add.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask, i32 4)
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x double> %c, double 1.000000e+00, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx512.mask.add.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> %1, i8 %mask, i32 4)
  ret <2 x double> %2
}

declare <4 x float> @llvm.x86.avx512.mask.sub.ss.round(<4 x float>, <4 x float>, <4 x float>, i8, i32)

define <4 x float> @test_sub_ss(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test_sub_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x float> @llvm.x86.avx512.mask.sub.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> undef, i8 -1, i32 4)
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x float> %b, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = tail call <4 x float> @llvm.x86.avx512.mask.sub.ss.round(<4 x float> %a, <4 x float> %3, <4 x float> undef, i8 -1, i32 4)
  ret <4 x float> %4
}

define <4 x float> @test_sub_ss_mask(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 %mask) {
; CHECK-LABEL: @test_sub_ss_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x float> @llvm.x86.avx512.mask.sub.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 %mask, i32 4)
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x float> %c, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = tail call <4 x float> @llvm.x86.avx512.mask.sub.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> %3, i8 %mask, i32 4)
  ret <4 x float> %4
}

declare <2 x double> @llvm.x86.avx512.mask.sub.sd.round(<2 x double>, <2 x double>, <2 x double>, i8, i32)

define <2 x double> @test_sub_sd(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @test_sub_sd(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <2 x double> @llvm.x86.avx512.mask.sub.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> undef, i8 -1, i32 4)
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x double> %b, double 1.000000e+00, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx512.mask.sub.sd.round(<2 x double> %a, <2 x double> %1, <2 x double> undef, i8 -1, i32 4)
  ret <2 x double> %2
}

define <2 x double> @test_sub_sd_mask(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask) {
; CHECK-LABEL: @test_sub_sd_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <2 x double> @llvm.x86.avx512.mask.sub.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask, i32 4)
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x double> %c, double 1.000000e+00, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx512.mask.sub.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> %1, i8 %mask, i32 4)
  ret <2 x double> %2
}

declare <4 x float> @llvm.x86.avx512.mask.mul.ss.round(<4 x float>, <4 x float>, <4 x float>, i8, i32)

define <4 x float> @test_mul_ss(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test_mul_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x float> @llvm.x86.avx512.mask.mul.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> undef, i8 -1, i32 4)
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x float> %b, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = tail call <4 x float> @llvm.x86.avx512.mask.mul.ss.round(<4 x float> %a, <4 x float> %3, <4 x float> undef, i8 -1, i32 4)
  ret <4 x float> %4
}

define <4 x float> @test_mul_ss_mask(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 %mask) {
; CHECK-LABEL: @test_mul_ss_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x float> @llvm.x86.avx512.mask.mul.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 %mask, i32 4)
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x float> %c, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = tail call <4 x float> @llvm.x86.avx512.mask.mul.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> %3, i8 %mask, i32 4)
  ret <4 x float> %4
}

declare <2 x double> @llvm.x86.avx512.mask.mul.sd.round(<2 x double>, <2 x double>, <2 x double>, i8, i32)

define <2 x double> @test_mul_sd(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @test_mul_sd(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <2 x double> @llvm.x86.avx512.mask.mul.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> undef, i8 -1, i32 4)
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x double> %b, double 1.000000e+00, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx512.mask.mul.sd.round(<2 x double> %a, <2 x double> %1, <2 x double> undef, i8 -1, i32 4)
  ret <2 x double> %2
}

define <2 x double> @test_mul_sd_mask(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask) {
; CHECK-LABEL: @test_mul_sd_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <2 x double> @llvm.x86.avx512.mask.mul.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask, i32 4)
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x double> %c, double 1.000000e+00, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx512.mask.mul.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> %1, i8 %mask, i32 4)
  ret <2 x double> %2
}

declare <4 x float> @llvm.x86.avx512.mask.div.ss.round(<4 x float>, <4 x float>, <4 x float>, i8, i32)

define <4 x float> @test_div_ss(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test_div_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x float> @llvm.x86.avx512.mask.div.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> undef, i8 -1, i32 4)
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x float> %b, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = tail call <4 x float> @llvm.x86.avx512.mask.div.ss.round(<4 x float> %a, <4 x float> %3, <4 x float> undef, i8 -1, i32 4)
  ret <4 x float> %4
}

define <4 x float> @test_div_ss_mask(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 %mask) {
; CHECK-LABEL: @test_div_ss_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x float> @llvm.x86.avx512.mask.div.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 %mask, i32 4)
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x float> %c, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = tail call <4 x float> @llvm.x86.avx512.mask.div.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> %3, i8 %mask, i32 4)
  ret <4 x float> %4
}

declare <2 x double> @llvm.x86.avx512.mask.div.sd.round(<2 x double>, <2 x double>, <2 x double>, i8, i32)

define <2 x double> @test_div_sd(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @test_div_sd(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <2 x double> @llvm.x86.avx512.mask.div.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> undef, i8 -1, i32 4)
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x double> %b, double 1.000000e+00, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx512.mask.div.sd.round(<2 x double> %a, <2 x double> %1, <2 x double> undef, i8 -1, i32 4)
  ret <2 x double> %2
}

define <2 x double> @test_div_sd_mask(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask) {
; CHECK-LABEL: @test_div_sd_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <2 x double> @llvm.x86.avx512.mask.div.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask, i32 4)
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x double> %c, double 1.000000e+00, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx512.mask.div.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> %1, i8 %mask, i32 4)
  ret <2 x double> %2
}

declare <4 x float> @llvm.x86.avx512.mask.max.ss.round(<4 x float>, <4 x float>, <4 x float>, i8, i32)

define <4 x float> @test_max_ss(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test_max_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x float> @llvm.x86.avx512.mask.max.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> undef, i8 -1, i32 4)
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x float> %b, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = tail call <4 x float> @llvm.x86.avx512.mask.max.ss.round(<4 x float> %a, <4 x float> %3, <4 x float> undef, i8 -1, i32 4)
  ret <4 x float> %4
}

define <4 x float> @test_max_ss_mask(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 %mask) {
; CHECK-LABEL: @test_max_ss_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x float> @llvm.x86.avx512.mask.max.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 %mask, i32 4)
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x float> %c, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = tail call <4 x float> @llvm.x86.avx512.mask.max.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> %3, i8 %mask, i32 4)
  ret <4 x float> %4
}

declare <2 x double> @llvm.x86.avx512.mask.max.sd.round(<2 x double>, <2 x double>, <2 x double>, i8, i32)

define <2 x double> @test_max_sd(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @test_max_sd(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <2 x double> @llvm.x86.avx512.mask.max.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> undef, i8 -1, i32 4)
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x double> %b, double 1.000000e+00, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx512.mask.max.sd.round(<2 x double> %a, <2 x double> %1, <2 x double> undef, i8 -1, i32 4)
  ret <2 x double> %2
}

define <2 x double> @test_max_sd_mask(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask) {
; CHECK-LABEL: @test_max_sd_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <2 x double> @llvm.x86.avx512.mask.max.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask, i32 4)
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x double> %c, double 1.000000e+00, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx512.mask.max.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> %1, i8 %mask, i32 4)
  ret <2 x double> %2
}

declare <4 x float> @llvm.x86.avx512.mask.min.ss.round(<4 x float>, <4 x float>, <4 x float>, i8, i32)

define <4 x float> @test_min_ss(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test_min_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x float> @llvm.x86.avx512.mask.min.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> undef, i8 -1, i32 4)
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x float> %b, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = tail call <4 x float> @llvm.x86.avx512.mask.min.ss.round(<4 x float> %a, <4 x float> %3, <4 x float> undef, i8 -1, i32 4)
  ret <4 x float> %4
}

define <4 x float> @test_min_ss_mask(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 %mask) {
; CHECK-LABEL: @test_min_ss_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <4 x float> @llvm.x86.avx512.mask.min.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 %mask, i32 4)
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x float> %c, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = tail call <4 x float> @llvm.x86.avx512.mask.min.ss.round(<4 x float> %a, <4 x float> %b, <4 x float> %3, i8 %mask, i32 4)
  ret <4 x float> %4
}

declare <2 x double> @llvm.x86.avx512.mask.min.sd.round(<2 x double>, <2 x double>, <2 x double>, i8, i32)

define <2 x double> @test_min_sd(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @test_min_sd(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <2 x double> @llvm.x86.avx512.mask.min.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> undef, i8 -1, i32 4)
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x double> %b, double 1.000000e+00, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx512.mask.min.sd.round(<2 x double> %a, <2 x double> %1, <2 x double> undef, i8 -1, i32 4)
  ret <2 x double> %2
}

define <2 x double> @test_min_sd_mask(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask) {
; CHECK-LABEL: @test_min_sd_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <2 x double> @llvm.x86.avx512.mask.min.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask, i32 4)
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x double> %c, double 1.000000e+00, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx512.mask.min.sd.round(<2 x double> %a, <2 x double> %b, <2 x double> %1, i8 %mask, i32 4)
  ret <2 x double> %2
}

declare i8 @llvm.x86.avx512.mask.cmp.ss(<4 x float>, <4 x float>, i32, i8, i32)

define i8 @test_cmp_ss(<4 x float> %a, <4 x float> %b, i8 %mask) {
; CHECK-LABEL: @test_cmp_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i8 @llvm.x86.avx512.mask.cmp.ss(<4 x float> %a, <4 x float> %b, i32 3, i8 %mask, i32 4)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %1 = insertelement <4 x float> %a, float 1.000000e+00, i32 1
  %2 = insertelement <4 x float> %1, float 2.000000e+00, i32 2
  %3 = insertelement <4 x float> %2, float 3.000000e+00, i32 3
  %4 = insertelement <4 x float> %b, float 4.000000e+00, i32 1
  %5 = insertelement <4 x float> %4, float 5.000000e+00, i32 2
  %6 = insertelement <4 x float> %5, float 6.000000e+00, i32 3
  %7 = tail call i8 @llvm.x86.avx512.mask.cmp.ss(<4 x float> %3, <4 x float> %6, i32 3, i8 %mask, i32 4)
  ret i8 %7
}

declare i8 @llvm.x86.avx512.mask.cmp.sd(<2 x double>, <2 x double>, i32, i8, i32)

define i8 @test_cmp_sd(<2 x double> %a, <2 x double> %b, i8 %mask) {
; CHECK-LABEL: @test_cmp_sd(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i8 @llvm.x86.avx512.mask.cmp.sd(<2 x double> %a, <2 x double> %b, i32 3, i8 %mask, i32 4)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %1 = insertelement <2 x double> %a, double 1.000000e+00, i32 1
  %2 = insertelement <2 x double> %b, double 2.000000e+00, i32 1
  %3 = tail call i8 @llvm.x86.avx512.mask.cmp.sd(<2 x double> %1, <2 x double> %2, i32 3, i8 %mask, i32 4)
  ret i8 %3
}
