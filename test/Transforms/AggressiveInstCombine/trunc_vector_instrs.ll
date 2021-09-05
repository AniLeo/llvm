; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -aggressive-instcombine -S | FileCheck %s

define <4 x i16> @shuffle(<2 x i8> %a, <2 x i8> %b) {
; CHECK-LABEL: @shuffle(
; CHECK-NEXT:    [[ZEXTA:%.*]] = zext <2 x i8> [[A:%.*]] to <2 x i32>
; CHECK-NEXT:    [[ZEXTB:%.*]] = zext <2 x i8> [[B:%.*]] to <2 x i32>
; CHECK-NEXT:    [[SHUF:%.*]] = shufflevector <2 x i32> [[ZEXTA]], <2 x i32> [[ZEXTB]], <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc <4 x i32> [[SHUF]] to <4 x i16>
; CHECK-NEXT:    ret <4 x i16> [[TRUNC]]
;
  %zexta = zext <2 x i8> %a to <2 x i32>
  %zextb = zext <2 x i8> %b to <2 x i32>
  %shuf = shufflevector <2 x i32> %zexta, <2 x i32> %zextb, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %trunc = trunc <4 x i32> %shuf to <4 x i16>
  ret <4 x i16> %trunc
}

define <2 x i16> @unary_shuffle(<2 x i8> %a) {
; CHECK-LABEL: @unary_shuffle(
; CHECK-NEXT:    [[ZEXTA:%.*]] = zext <2 x i8> [[A:%.*]] to <2 x i32>
; CHECK-NEXT:    [[SHUF:%.*]] = shufflevector <2 x i32> [[ZEXTA]], <2 x i32> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc <2 x i32> [[SHUF]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[TRUNC]]
;
  %zexta = zext <2 x i8> %a to <2 x i32>
  %shuf = shufflevector <2 x i32> %zexta, <2 x i32> undef, <2 x i32> <i32 1, i32 0>
  %trunc = trunc <2 x i32> %shuf to <2 x i16>
  ret <2 x i16> %trunc
}

define <4 x i16> @const_shuffle() {
; CHECK-LABEL: @const_shuffle(
; CHECK-NEXT:    [[SHUF:%.*]] = shufflevector <2 x i32> <i32 1, i32 2>, <2 x i32> <i32 3, i32 7>, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc <4 x i32> [[SHUF]] to <4 x i16>
; CHECK-NEXT:    ret <4 x i16> [[TRUNC]]
;
  %shuf = shufflevector <2 x i32> <i32 1, i32 2>, <2 x i32> <i32 3, i32 7>, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %trunc = trunc <4 x i32> %shuf to <4 x i16>
  ret <4 x i16> %trunc
}


define <2 x i16> @extract_insert(<2 x i8> %a, <2 x i8> %b) {
; CHECK-LABEL: @extract_insert(
; CHECK-NEXT:    [[ZEXTA:%.*]] = zext <2 x i8> [[A:%.*]] to <2 x i16>
; CHECK-NEXT:    [[ZEXTB:%.*]] = zext <2 x i8> [[B:%.*]] to <2 x i16>
; CHECK-NEXT:    [[EXTR:%.*]] = extractelement <2 x i16> [[ZEXTA]], i32 0
; CHECK-NEXT:    [[INSR:%.*]] = insertelement <2 x i16> [[ZEXTB]], i16 [[EXTR]], i32 1
; CHECK-NEXT:    ret <2 x i16> [[INSR]]
;
  %zexta = zext <2 x i8> %a to <2 x i32>
  %zextb = zext <2 x i8> %b to <2 x i32>
  %extr = extractelement <2 x i32> %zexta, i32 0
  %insr = insertelement <2 x i32> %zextb, i32 %extr, i32 1
  %trunc = trunc <2 x i32> %insr to <2 x i16>
  ret <2 x i16> %trunc
}

define <2 x i16> @insert_poison(i8 %a) {
; CHECK-LABEL: @insert_poison(
; CHECK-NEXT:    [[ZEXTA:%.*]] = zext i8 [[A:%.*]] to i16
; CHECK-NEXT:    [[INSR:%.*]] = insertelement <2 x i16> poison, i16 [[ZEXTA]], i32 0
; CHECK-NEXT:    ret <2 x i16> [[INSR]]
;
  %zexta = zext i8 %a to i32
  %insr = insertelement <2 x i32> poison, i32 %zexta, i32 0
  %trunc = trunc <2 x i32> %insr to <2 x i16>
  ret <2 x i16> %trunc
}

; This demonstrates test not folded by 'opt -instcombine'
define <2 x i16> @extract_mul_insert(<2 x i8> %x) {
; CHECK-LABEL: @extract_mul_insert(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i16>
; CHECK-NEXT:    [[LSHR:%.*]] = lshr <2 x i16> [[ZEXT]], <i16 4, i16 5>
; CHECK-NEXT:    [[EXTR:%.*]] = extractelement <2 x i16> [[LSHR]], i32 1
; CHECK-NEXT:    [[MUL:%.*]] = mul i16 [[EXTR]], 5
; CHECK-NEXT:    [[INSR:%.*]] = insertelement <2 x i16> [[LSHR]], i16 [[MUL]], i32 1
; CHECK-NEXT:    ret <2 x i16> [[INSR]]
;
  %zext = zext <2 x i8> %x to <2 x i32>
  %lshr = lshr <2 x i32> %zext, <i32 4, i32 5>
  %extr = extractelement <2 x i32> %lshr, i32 1
  %mul = mul i32 %extr, 5
  %insr = insertelement <2 x i32> %lshr, i32 %mul, i32 1
  %trunc = trunc <2 x i32> %insr to <2 x i16>
  ret <2 x i16> %trunc
}
