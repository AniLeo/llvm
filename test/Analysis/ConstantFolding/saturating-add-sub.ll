; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -constprop -S | FileCheck %s

declare i8 @llvm.uadd.sat.i8(i8, i8)
declare i8 @llvm.sadd.sat.i8(i8, i8)
declare <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8>, <2 x i8>)
declare <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8>, <2 x i8>)

declare i8 @llvm.usub.sat.i8(i8, i8)
declare i8 @llvm.ssub.sat.i8(i8, i8)
declare <2 x i8> @llvm.usub.sat.v2i8(<2 x i8>, <2 x i8>)
declare <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8>, <2 x i8>)

define i8 @test_uadd_scalar_no_sat() {
; CHECK-LABEL: @test_uadd_scalar_no_sat(
; CHECK-NEXT:    ret i8 30
;
  %x = call i8 @llvm.uadd.sat.i8(i8 10, i8 20)
  ret i8 %x
}

define i8 @test_uadd_scalar_sat() {
; CHECK-LABEL: @test_uadd_scalar_sat(
; CHECK-NEXT:    ret i8 -1
;
  %x = call i8 @llvm.uadd.sat.i8(i8 250, i8 100)
  ret i8 %x
}

define i8 @test_sadd_scalar_no_sat() {
; CHECK-LABEL: @test_sadd_scalar_no_sat(
; CHECK-NEXT:    ret i8 -10
;
  %x = call i8 @llvm.sadd.sat.i8(i8 10, i8 -20)
  ret i8 %x
}

define i8 @test_sadd_scalar_sat_pos() {
; CHECK-LABEL: @test_sadd_scalar_sat_pos(
; CHECK-NEXT:    ret i8 127
;
  %x = call i8 @llvm.sadd.sat.i8(i8 120, i8 10)
  ret i8 %x
}

define i8 @test_sadd_scalar_sat_neg() {
; CHECK-LABEL: @test_sadd_scalar_sat_neg(
; CHECK-NEXT:    ret i8 -128
;
  %x = call i8 @llvm.sadd.sat.i8(i8 -120, i8 -10)
  ret i8 %x
}

define <2 x i8> @test_uadd_vector_no_sat(<2 x i8> %a) {
; CHECK-LABEL: @test_uadd_vector_no_sat(
; CHECK-NEXT:    ret <2 x i8> <i8 20, i8 30>
;
  %x = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> <i8 10, i8 15>, <2 x i8> <i8 10, i8 15>)
  ret <2 x i8> %x
}

define <2 x i8> @test_uadd_vector_sat(<2 x i8> %a) {
; CHECK-LABEL: @test_uadd_vector_sat(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %x = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> <i8 100, i8 200>, <2 x i8> <i8 250, i8 100>)
  ret <2 x i8> %x
}

define <2 x i8> @test_sadd_vector_no_sat(<2 x i8> %a) {
; CHECK-LABEL: @test_sadd_vector_no_sat(
; CHECK-NEXT:    ret <2 x i8> <i8 -10, i8 -30>
;
  %x = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> <i8 10, i8 -15>, <2 x i8> <i8 -20, i8 -15>)
  ret <2 x i8> %x
}

define <2 x i8> @test_sadd_vector_sat_pos(<2 x i8> %a) {
; CHECK-LABEL: @test_sadd_vector_sat_pos(
; CHECK-NEXT:    ret <2 x i8> <i8 127, i8 127>
;
  %x = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> <i8 100, i8 10>, <2 x i8> <i8 30, i8 120>)
  ret <2 x i8> %x
}

define <2 x i8> @test_sadd_vector_sat_neg(<2 x i8> %a) {
; CHECK-LABEL: @test_sadd_vector_sat_neg(
; CHECK-NEXT:    ret <2 x i8> <i8 -128, i8 -128>
;
  %x = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> <i8 -100, i8 -10>, <2 x i8> <i8 -30, i8 -120>)
  ret <2 x i8> %x
}

define i8 @test_usub_scalar_no_sat() {
; CHECK-LABEL: @test_usub_scalar_no_sat(
; CHECK-NEXT:    ret i8 10
;
  %x = call i8 @llvm.usub.sat.i8(i8 20, i8 10)
  ret i8 %x
}

define i8 @test_usub_scalar_sat() {
; CHECK-LABEL: @test_usub_scalar_sat(
; CHECK-NEXT:    ret i8 0
;
  %x = call i8 @llvm.usub.sat.i8(i8 200, i8 250)
  ret i8 %x
}

define i8 @test_ssub_scalar_no_sat() {
; CHECK-LABEL: @test_ssub_scalar_no_sat(
; CHECK-NEXT:    ret i8 -30
;
  %x = call i8 @llvm.ssub.sat.i8(i8 -10, i8 20)
  ret i8 %x
}

define i8 @test_ssub_scalar_sat_pos() {
; CHECK-LABEL: @test_ssub_scalar_sat_pos(
; CHECK-NEXT:    ret i8 127
;
  %x = call i8 @llvm.ssub.sat.i8(i8 120, i8 -10)
  ret i8 %x
}

define i8 @test_ssub_scalar_sat_neg() {
; CHECK-LABEL: @test_ssub_scalar_sat_neg(
; CHECK-NEXT:    ret i8 -128
;
  %x = call i8 @llvm.ssub.sat.i8(i8 -120, i8 10)
  ret i8 %x
}

define <2 x i8> @test_usub_vector_no_sat(<2 x i8> %a) {
; CHECK-LABEL: @test_usub_vector_no_sat(
; CHECK-NEXT:    ret <2 x i8> <i8 10, i8 5>
;
  %x = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> <i8 20, i8 15>, <2 x i8> <i8 10, i8 10>)
  ret <2 x i8> %x
}

define <2 x i8> @test_usub_vector_sat(<2 x i8> %a) {
; CHECK-LABEL: @test_usub_vector_sat(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %x = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> <i8 100, i8 200>, <2 x i8> <i8 150, i8 250>)
  ret <2 x i8> %x
}

define <2 x i8> @test_ssub_vector_no_sat(<2 x i8> %a) {
; CHECK-LABEL: @test_ssub_vector_no_sat(
; CHECK-NEXT:    ret <2 x i8> <i8 30, i8 0>
;
  %x = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> <i8 10, i8 -15>, <2 x i8> <i8 -20, i8 -15>)
  ret <2 x i8> %x
}

define <2 x i8> @test_ssub_vector_sat_pos(<2 x i8> %a) {
; CHECK-LABEL: @test_ssub_vector_sat_pos(
; CHECK-NEXT:    ret <2 x i8> <i8 127, i8 127>
;
  %x = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> <i8 100, i8 10>, <2 x i8> <i8 -30, i8 -120>)
  ret <2 x i8> %x
}

define <2 x i8> @test_ssub_vector_sat_neg(<2 x i8> %a) {
; CHECK-LABEL: @test_ssub_vector_sat_neg(
; CHECK-NEXT:    ret <2 x i8> <i8 -128, i8 -128>
;
  %x = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> <i8 -100, i8 -10>, <2 x i8> <i8 30, i8 120>)
  ret <2 x i8> %x
}

; Tests for undef handling

define i8 @test_uadd_scalar_both_undef() {
; CHECK-LABEL: @test_uadd_scalar_both_undef(
; CHECK-NEXT:    [[X:%.*]] = call i8 @llvm.uadd.sat.i8(i8 undef, i8 undef)
; CHECK-NEXT:    ret i8 [[X]]
;
  %x = call i8 @llvm.uadd.sat.i8(i8 undef, i8 undef)
  ret i8 %x
}

define i8 @test_sadd_scalar_both_undef() {
; CHECK-LABEL: @test_sadd_scalar_both_undef(
; CHECK-NEXT:    [[X:%.*]] = call i8 @llvm.sadd.sat.i8(i8 undef, i8 undef)
; CHECK-NEXT:    ret i8 [[X]]
;
  %x = call i8 @llvm.sadd.sat.i8(i8 undef, i8 undef)
  ret i8 %x
}

define i8 @test_usub_scalar_both_undef() {
; CHECK-LABEL: @test_usub_scalar_both_undef(
; CHECK-NEXT:    [[X:%.*]] = call i8 @llvm.usub.sat.i8(i8 undef, i8 undef)
; CHECK-NEXT:    ret i8 [[X]]
;
  %x = call i8 @llvm.usub.sat.i8(i8 undef, i8 undef)
  ret i8 %x
}

define i8 @test_ssub_scalar_both_undef() {
; CHECK-LABEL: @test_ssub_scalar_both_undef(
; CHECK-NEXT:    [[X:%.*]] = call i8 @llvm.ssub.sat.i8(i8 undef, i8 undef)
; CHECK-NEXT:    ret i8 [[X]]
;
  %x = call i8 @llvm.ssub.sat.i8(i8 undef, i8 undef)
  ret i8 %x
}

define i8 @test_uadd_scalar_op2_undef() {
; CHECK-LABEL: @test_uadd_scalar_op2_undef(
; CHECK-NEXT:    [[X:%.*]] = call i8 @llvm.uadd.sat.i8(i8 10, i8 undef)
; CHECK-NEXT:    ret i8 [[X]]
;
  %x = call i8 @llvm.uadd.sat.i8(i8 10, i8 undef)
  ret i8 %x
}

define i8 @test_sadd_scalar_op1_undef() {
; CHECK-LABEL: @test_sadd_scalar_op1_undef(
; CHECK-NEXT:    [[X:%.*]] = call i8 @llvm.sadd.sat.i8(i8 undef, i8 10)
; CHECK-NEXT:    ret i8 [[X]]
;
  %x = call i8 @llvm.sadd.sat.i8(i8 undef, i8 10)
  ret i8 %x
}

define i8 @test_usub_scalar_op2_undef() {
; CHECK-LABEL: @test_usub_scalar_op2_undef(
; CHECK-NEXT:    [[X:%.*]] = call i8 @llvm.usub.sat.i8(i8 10, i8 undef)
; CHECK-NEXT:    ret i8 [[X]]
;
  %x = call i8 @llvm.usub.sat.i8(i8 10, i8 undef)
  ret i8 %x
}

define i8 @test_usub_scalar_op1_undef() {
; CHECK-LABEL: @test_usub_scalar_op1_undef(
; CHECK-NEXT:    [[X:%.*]] = call i8 @llvm.usub.sat.i8(i8 undef, i8 10)
; CHECK-NEXT:    ret i8 [[X]]
;
  %x = call i8 @llvm.usub.sat.i8(i8 undef, i8 10)
  ret i8 %x
}

define <2 x i8> @test_uadd_vector_both_undef_splat() {
; CHECK-LABEL: @test_uadd_vector_both_undef_splat(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
  ret <2 x i8> %x
}

define <2 x i8> @test_sadd_vector_both_undef_splat() {
; CHECK-LABEL: @test_sadd_vector_both_undef_splat(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
  ret <2 x i8> %x
}

define <2 x i8> @test_usub_vector_both_undef_splat() {
; CHECK-LABEL: @test_usub_vector_both_undef_splat(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
  ret <2 x i8> %x
}

define <2 x i8> @test_ssub_vector_both_undef_splat() {
; CHECK-LABEL: @test_ssub_vector_both_undef_splat(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> undef, <2 x i8> undef)
  ret <2 x i8> %x
}

define <2 x i8> @test_uadd_vector_op2_undef_splat() {
; CHECK-LABEL: @test_uadd_vector_op2_undef_splat(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> <i8 10, i8 20>, <2 x i8> undef)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> <i8 10, i8 20>, <2 x i8> undef)
  ret <2 x i8> %x
}

define <2 x i8> @test_sadd_vector_op1_undef_splat() {
; CHECK-LABEL: @test_sadd_vector_op1_undef_splat(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> undef, <2 x i8> <i8 10, i8 20>)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> undef, <2 x i8> <i8 10, i8 20>)
  ret <2 x i8> %x
}

define <2 x i8> @test_usub_vector_op2_undef_splat() {
; CHECK-LABEL: @test_usub_vector_op2_undef_splat(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> <i8 10, i8 20>, <2 x i8> undef)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> <i8 10, i8 20>, <2 x i8> undef)
  ret <2 x i8> %x
}

define <2 x i8> @test_ssub_vector_op1_undef_splat() {
; CHECK-LABEL: @test_ssub_vector_op1_undef_splat(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> undef, <2 x i8> <i8 10, i8 20>)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> undef, <2 x i8> <i8 10, i8 20>)
  ret <2 x i8> %x
}

define <2 x i8> @test_uadd_vector_op2_undef_mix1() {
; CHECK-LABEL: @test_uadd_vector_op2_undef_mix1(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> <i8 10, i8 undef>, <2 x i8> <i8 20, i8 undef>)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> <i8 10, i8 undef>, <2 x i8> <i8 20, i8 undef>)
  ret <2 x i8> %x
}

define <2 x i8> @test_uadd_vector_op2_undef_mix2() {
; CHECK-LABEL: @test_uadd_vector_op2_undef_mix2(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> <i8 10, i8 undef>, <2 x i8> <i8 undef, i8 20>)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> <i8 10, i8 undef>, <2 x i8> <i8 undef, i8 20>)
  ret <2 x i8> %x
}

define <2 x i8> @test_sadd_vector_op1_undef_mix1() {
; CHECK-LABEL: @test_sadd_vector_op1_undef_mix1(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> <i8 undef, i8 10>, <2 x i8> <i8 undef, i8 20>)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> <i8 undef, i8 10>, <2 x i8> <i8 undef, i8 20>)
  ret <2 x i8> %x
}

define <2 x i8> @test_sadd_vector_op1_undef_mix2() {
; CHECK-LABEL: @test_sadd_vector_op1_undef_mix2(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> <i8 undef, i8 10>, <2 x i8> <i8 20, i8 undef>)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> <i8 undef, i8 10>, <2 x i8> <i8 20, i8 undef>)
  ret <2 x i8> %x
}

define <2 x i8> @test_usub_vector_op2_undef_mix1() {
; CHECK-LABEL: @test_usub_vector_op2_undef_mix1(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> <i8 10, i8 undef>, <2 x i8> <i8 20, i8 undef>)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> <i8 10, i8 undef>, <2 x i8> <i8 20, i8 undef>)
  ret <2 x i8> %x
}

define <2 x i8> @test_usub_vector_op2_undef_mix2() {
; CHECK-LABEL: @test_usub_vector_op2_undef_mix2(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> <i8 10, i8 undef>, <2 x i8> <i8 undef, i8 20>)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> <i8 10, i8 undef>, <2 x i8> <i8 undef, i8 20>)
  ret <2 x i8> %x
}

define <2 x i8> @test_ssub_vector_op1_undef_mix1() {
; CHECK-LABEL: @test_ssub_vector_op1_undef_mix1(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> <i8 undef, i8 10>, <2 x i8> <i8 undef, i8 20>)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> <i8 undef, i8 10>, <2 x i8> <i8 undef, i8 20>)
  ret <2 x i8> %x
}

define <2 x i8> @test_ssub_vector_op1_undef_mix2() {
; CHECK-LABEL: @test_ssub_vector_op1_undef_mix2(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> <i8 undef, i8 10>, <2 x i8> <i8 20, i8 undef>)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> <i8 undef, i8 10>, <2 x i8> <i8 20, i8 undef>)
  ret <2 x i8> %x
}
