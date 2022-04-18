; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

;
; (A & 2^C1) + A => A & (2^C1 - 1) iff bit C1 in A is a sign bit
;

define i32 @add_mask_sign_i32(i32 %x) {
; CHECK-LABEL: @add_mask_sign_i32(
; CHECK-NEXT:    [[A:%.*]] = ashr i32 [[X:%.*]], 31
; CHECK-NEXT:    [[M:%.*]] = and i32 [[A]], 8
; CHECK-NEXT:    [[R:%.*]] = add nsw i32 [[M]], [[A]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = ashr i32 %x, 31
  %m = and i32 %a, 8
  %r = add i32 %m, %a
  ret i32 %r
}

define i32 @add_mask_sign_commute_i32(i32 %x) {
; CHECK-LABEL: @add_mask_sign_commute_i32(
; CHECK-NEXT:    [[A:%.*]] = ashr i32 [[X:%.*]], 31
; CHECK-NEXT:    [[M:%.*]] = and i32 [[A]], 8
; CHECK-NEXT:    [[R:%.*]] = add nsw i32 [[A]], [[M]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = ashr i32 %x, 31
  %m = and i32 %a, 8
  %r = add i32 %a, %m
  ret i32 %r
}

define <2 x i32> @add_mask_sign_v2i32(<2 x i32> %x) {
; CHECK-LABEL: @add_mask_sign_v2i32(
; CHECK-NEXT:    [[A:%.*]] = ashr <2 x i32> [[X:%.*]], <i32 31, i32 31>
; CHECK-NEXT:    [[M:%.*]] = and <2 x i32> [[A]], <i32 8, i32 8>
; CHECK-NEXT:    [[R:%.*]] = add nsw <2 x i32> [[M]], [[A]]
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %a = ashr <2 x i32> %x, <i32 31, i32 31>
  %m = and <2 x i32> %a, <i32 8, i32 8>
  %r = add <2 x i32> %m, %a
  ret <2 x i32> %r
}

define <2 x i32> @add_mask_sign_v2i32_nonuniform(<2 x i32> %x) {
; CHECK-LABEL: @add_mask_sign_v2i32_nonuniform(
; CHECK-NEXT:    [[A:%.*]] = ashr <2 x i32> [[X:%.*]], <i32 30, i32 31>
; CHECK-NEXT:    [[M:%.*]] = and <2 x i32> [[A]], <i32 8, i32 16>
; CHECK-NEXT:    [[R:%.*]] = add <2 x i32> [[M]], [[A]]
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %a = ashr <2 x i32> %x, <i32 30, i32 31>
  %m = and <2 x i32> %a, <i32 8, i32 16>
  %r = add <2 x i32> %m, %a
  ret <2 x i32> %r
}

define i32 @add_mask_ashr28_i32(i32 %x) {
; CHECK-LABEL: @add_mask_ashr28_i32(
; CHECK-NEXT:    [[A:%.*]] = ashr i32 [[X:%.*]], 28
; CHECK-NEXT:    [[M:%.*]] = and i32 [[A]], 8
; CHECK-NEXT:    [[R:%.*]] = add nsw i32 [[M]], [[A]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = ashr i32 %x, 28
  %m = and i32 %a, 8
  %r = add i32 %m, %a
  ret i32 %r
}

; negative case - insufficient sign bits
define i32 @add_mask_ashr27_i32(i32 %x) {
; CHECK-LABEL: @add_mask_ashr27_i32(
; CHECK-NEXT:    [[A:%.*]] = ashr i32 [[X:%.*]], 27
; CHECK-NEXT:    [[M:%.*]] = and i32 [[A]], 8
; CHECK-NEXT:    [[R:%.*]] = add nsw i32 [[M]], [[A]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = ashr i32 %x, 27
  %m = and i32 %a, 8
  %r = add i32 %m, %a
  ret i32 %r
}
