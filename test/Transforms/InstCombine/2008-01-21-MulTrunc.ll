; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128"

define i16 @test1(i16 %a) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[C:%.*]] = lshr i16 [[A:%.*]], 8
; CHECK-NEXT:    [[D:%.*]] = mul i16 [[A]], 5
; CHECK-NEXT:    [[E:%.*]] = or i16 [[C]], [[D]]
; CHECK-NEXT:    ret i16 [[E]]
;
  %b = zext i16 %a to i32    ; <i32> [#uses=2]
  %c = lshr i32 %b, 8        ; <i32> [#uses=1]
  %d = mul i32 %b, 5         ; <i32> [#uses=1]
  %e = or i32 %c, %d         ; <i32> [#uses=1]
  %f = trunc i32 %e to i16   ; <i16> [#uses=1]
  ret i16 %f
}

define <2 x i16> @test1_vec(<2 x i16> %a) {
; CHECK-LABEL: @test1_vec(
; CHECK-NEXT:    [[C:%.*]] = lshr <2 x i16> [[A:%.*]], <i16 8, i16 8>
; CHECK-NEXT:    [[D:%.*]] = mul <2 x i16> [[A]], <i16 5, i16 5>
; CHECK-NEXT:    [[E:%.*]] = or <2 x i16> [[C]], [[D]]
; CHECK-NEXT:    ret <2 x i16> [[E]]
;
  %b = zext <2 x i16> %a to <2 x i32>
  %c = lshr <2 x i32> %b, <i32 8, i32 8>
  %d = mul <2 x i32> %b, <i32 5, i32 5>
  %e = or <2 x i32> %c, %d
  %f = trunc <2 x i32> %e to <2 x i16>
  ret <2 x i16> %f
}

define <2 x i16> @test1_vec_nonuniform(<2 x i16> %a) {
; CHECK-LABEL: @test1_vec_nonuniform(
; CHECK-NEXT:    [[C:%.*]] = lshr <2 x i16> [[A:%.*]], <i16 8, i16 9>
; CHECK-NEXT:    [[D:%.*]] = mul <2 x i16> [[A]], <i16 5, i16 6>
; CHECK-NEXT:    [[E:%.*]] = or <2 x i16> [[C]], [[D]]
; CHECK-NEXT:    ret <2 x i16> [[E]]
;
  %b = zext <2 x i16> %a to <2 x i32>
  %c = lshr <2 x i32> %b, <i32 8, i32 9>
  %d = mul <2 x i32> %b, <i32 5, i32 6>
  %e = or <2 x i32> %c, %d
  %f = trunc <2 x i32> %e to <2 x i16>
  ret <2 x i16> %f
}

define <2 x i16> @test1_vec_undef(<2 x i16> %a) {
; CHECK-LABEL: @test1_vec_undef(
; CHECK-NEXT:    [[B:%.*]] = zext <2 x i16> [[A:%.*]] to <2 x i32>
; CHECK-NEXT:    [[C:%.*]] = lshr <2 x i32> [[B]], <i32 8, i32 undef>
; CHECK-NEXT:    [[D:%.*]] = mul <2 x i32> [[B]], <i32 5, i32 undef>
; CHECK-NEXT:    [[E:%.*]] = or <2 x i32> [[C]], [[D]]
; CHECK-NEXT:    [[F:%.*]] = trunc <2 x i32> [[E]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[F]]
;
  %b = zext <2 x i16> %a to <2 x i32>
  %c = lshr <2 x i32> %b, <i32 8, i32 undef>
  %d = mul <2 x i32> %b, <i32 5, i32 undef>
  %e = or <2 x i32> %c, %d
  %f = trunc <2 x i32> %e to <2 x i16>
  ret <2 x i16> %f
}
