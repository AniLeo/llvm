; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

; Perform the shift first and merge the truncs as long as all zero/sign
; bits created by the shift are removed by the trunc.

declare void @use(i32)

define i8 @trunc_lshr_trunc(i64 %a) {
; CHECK-LABEL: @trunc_lshr_trunc(
; CHECK-NEXT:    [[C1:%.*]] = lshr i64 [[A:%.*]], 8
; CHECK-NEXT:    [[D:%.*]] = trunc i64 [[C1]] to i8
; CHECK-NEXT:    ret i8 [[D]]
;
  %b = trunc i64 %a to i32
  %c = lshr i32 %b, 8
  %d = trunc i32 %c to i8
  ret i8 %d
}

define <2 x i8> @trunc_lshr_trunc_uniform(<2 x i64> %a) {
; CHECK-LABEL: @trunc_lshr_trunc_uniform(
; CHECK-NEXT:    [[C1:%.*]] = lshr <2 x i64> [[A:%.*]], <i64 8, i64 8>
; CHECK-NEXT:    [[D:%.*]] = trunc <2 x i64> [[C1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[D]]
;
  %b = trunc <2 x i64> %a to <2 x i32>
  %c = lshr <2 x i32> %b, <i32 8, i32 8>
  %d = trunc <2 x i32> %c to <2 x i8>
  ret <2 x i8> %d
}

define <2 x i8> @trunc_lshr_trunc_nonuniform(<2 x i64> %a) {
; CHECK-LABEL: @trunc_lshr_trunc_nonuniform(
; CHECK-NEXT:    [[C1:%.*]] = lshr <2 x i64> [[A:%.*]], <i64 8, i64 2>
; CHECK-NEXT:    [[D:%.*]] = trunc <2 x i64> [[C1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[D]]
;
  %b = trunc <2 x i64> %a to <2 x i32>
  %c = lshr <2 x i32> %b, <i32 8, i32 2>
  %d = trunc <2 x i32> %c to <2 x i8>
  ret <2 x i8> %d
}

define <2 x i8> @trunc_lshr_trunc_uniform_undef(<2 x i64> %a) {
; CHECK-LABEL: @trunc_lshr_trunc_uniform_undef(
; CHECK-NEXT:    [[C1:%.*]] = lshr <2 x i64> [[A:%.*]], <i64 24, i64 undef>
; CHECK-NEXT:    [[D:%.*]] = trunc <2 x i64> [[C1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[D]]
;
  %b = trunc <2 x i64> %a to <2 x i32>
  %c = lshr <2 x i32> %b, <i32 24, i32 undef>
  %d = trunc <2 x i32> %c to <2 x i8>
  ret <2 x i8> %d
}

define i8 @trunc_lshr_trunc_outofrange(i64 %a) {
; CHECK-LABEL: @trunc_lshr_trunc_outofrange(
; CHECK-NEXT:    [[B:%.*]] = trunc i64 [[A:%.*]] to i32
; CHECK-NEXT:    [[C:%.*]] = lshr i32 [[B]], 25
; CHECK-NEXT:    [[D:%.*]] = trunc i32 [[C]] to i8
; CHECK-NEXT:    ret i8 [[D]]
;
  %b = trunc i64 %a to i32
  %c = lshr i32 %b, 25
  %d = trunc i32 %c to i8
  ret i8 %d
}

define <2 x i8> @trunc_lshr_trunc_nonuniform_outofrange(<2 x i64> %a) {
; CHECK-LABEL: @trunc_lshr_trunc_nonuniform_outofrange(
; CHECK-NEXT:    [[B:%.*]] = trunc <2 x i64> [[A:%.*]] to <2 x i32>
; CHECK-NEXT:    [[C:%.*]] = lshr <2 x i32> [[B]], <i32 8, i32 25>
; CHECK-NEXT:    [[D:%.*]] = trunc <2 x i32> [[C]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[D]]
;
  %b = trunc <2 x i64> %a to <2 x i32>
  %c = lshr <2 x i32> %b, <i32 8, i32 25>
  %d = trunc <2 x i32> %c to <2 x i8>
  ret <2 x i8> %d
}

define i8 @trunc_ashr_trunc(i64 %a) {
; CHECK-LABEL: @trunc_ashr_trunc(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 [[A:%.*]], 8
; CHECK-NEXT:    [[D:%.*]] = trunc i64 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[D]]
;
  %b = trunc i64 %a to i32
  %c = ashr i32 %b, 8
  %d = trunc i32 %c to i8
  ret i8 %d
}

define i8 @trunc_ashr_trunc_exact(i64 %a) {
; CHECK-LABEL: @trunc_ashr_trunc_exact(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr exact i64 [[A:%.*]], 8
; CHECK-NEXT:    [[D:%.*]] = trunc i64 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[D]]
;
  %b = trunc i64 %a to i32
  %c = ashr exact i32 %b, 8
  %d = trunc i32 %c to i8
  ret i8 %d
}

define <2 x i8> @trunc_ashr_trunc_uniform(<2 x i64> %a) {
; CHECK-LABEL: @trunc_ashr_trunc_uniform(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i64> [[A:%.*]], <i64 8, i64 8>
; CHECK-NEXT:    [[D:%.*]] = trunc <2 x i64> [[TMP1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[D]]
;
  %b = trunc <2 x i64> %a to <2 x i32>
  %c = ashr <2 x i32> %b, <i32 8, i32 8>
  %d = trunc <2 x i32> %c to <2 x i8>
  ret <2 x i8> %d
}

define <2 x i8> @trunc_ashr_trunc_nonuniform(<2 x i64> %a) {
; CHECK-LABEL: @trunc_ashr_trunc_nonuniform(
; CHECK-NEXT:    [[C1:%.*]] = ashr <2 x i64> [[A:%.*]], <i64 0, i64 23>
; CHECK-NEXT:    [[D:%.*]] = trunc <2 x i64> [[C1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[D]]
;
  %b = trunc <2 x i64> %a to <2 x i32>
  %c = ashr <2 x i32> %b, <i32 0, i32 23>
  %d = trunc <2 x i32> %c to <2 x i8>
  ret <2 x i8> %d
}

define <2 x i8> @trunc_ashr_trunc_uniform_undef(<2 x i64> %a) {
; CHECK-LABEL: @trunc_ashr_trunc_uniform_undef(
; CHECK-NEXT:    [[C1:%.*]] = ashr <2 x i64> [[A:%.*]], <i64 8, i64 undef>
; CHECK-NEXT:    [[D:%.*]] = trunc <2 x i64> [[C1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[D]]
;
  %b = trunc <2 x i64> %a to <2 x i32>
  %c = ashr <2 x i32> %b, <i32 8, i32 undef>
  %d = trunc <2 x i32> %c to <2 x i8>
  ret <2 x i8> %d
}

define i8 @trunc_ashr_trunc_outofrange(i64 %a) {
; CHECK-LABEL: @trunc_ashr_trunc_outofrange(
; CHECK-NEXT:    [[B:%.*]] = trunc i64 [[A:%.*]] to i32
; CHECK-NEXT:    [[C:%.*]] = ashr i32 [[B]], 25
; CHECK-NEXT:    [[D:%.*]] = trunc i32 [[C]] to i8
; CHECK-NEXT:    ret i8 [[D]]
;
  %b = trunc i64 %a to i32
  %c = ashr i32 %b, 25
  %d = trunc i32 %c to i8
  ret i8 %d
}

define <2 x i8> @trunc_ashr_trunc_nonuniform_outofrange(<2 x i64> %a) {
; CHECK-LABEL: @trunc_ashr_trunc_nonuniform_outofrange(
; CHECK-NEXT:    [[B:%.*]] = trunc <2 x i64> [[A:%.*]] to <2 x i32>
; CHECK-NEXT:    [[C:%.*]] = ashr <2 x i32> [[B]], <i32 8, i32 25>
; CHECK-NEXT:    [[D:%.*]] = trunc <2 x i32> [[C]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[D]]
;
  %b = trunc <2 x i64> %a to <2 x i32>
  %c = ashr <2 x i32> %b, <i32 8, i32 25>
  %d = trunc <2 x i32> %c to <2 x i8>
  ret <2 x i8> %d
}

define i8 @trunc_ashr_trunc_multiuse(i64 %a) {
; CHECK-LABEL: @trunc_ashr_trunc_multiuse(
; CHECK-NEXT:    [[B:%.*]] = trunc i64 [[A:%.*]] to i32
; CHECK-NEXT:    [[C:%.*]] = ashr i32 [[B]], 9
; CHECK-NEXT:    [[D:%.*]] = trunc i32 [[C]] to i8
; CHECK-NEXT:    call void @use(i32 [[C]])
; CHECK-NEXT:    ret i8 [[D]]
;
  %b = trunc i64 %a to i32
  %c = ashr i32 %b, 9
  %d = trunc i32 %c to i8
  call void @use(i32 %c)
  ret i8 %d
}
