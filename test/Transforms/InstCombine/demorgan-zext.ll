; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; PR22723: Recognize De Morgan's Laws when obfuscated by zexts.

define i32 @demorgan_or(i1 %X, i1 %Y) {
; CHECK-LABEL: @demorgan_or(
; CHECK-NEXT:    [[OR_DEMORGAN:%.*]] = and i1 %X, %Y
; CHECK-NEXT:    [[TMP1:%.*]] = zext i1 [[OR_DEMORGAN]] to i32
; CHECK-NEXT:    [[OR:%.*]] = xor i32 [[TMP1]], 1
; CHECK-NEXT:    ret i32 [[OR]]
;
  %zextX = zext i1 %X to i32
  %zextY = zext i1 %Y to i32
  %notX  = xor i32 %zextX, 1
  %notY  = xor i32 %zextY, 1
  %or    = or i32 %notX, %notY
  ret i32 %or
}

define i32 @demorgan_and(i1 %X, i1 %Y) {
; CHECK-LABEL: @demorgan_and(
; CHECK-NEXT:    [[AND_DEMORGAN:%.*]] = or i1 %X, %Y
; CHECK-NEXT:    [[TMP1:%.*]] = zext i1 [[AND_DEMORGAN]] to i32
; CHECK-NEXT:    [[AND:%.*]] = xor i32 [[TMP1]], 1
; CHECK-NEXT:    ret i32 [[AND]]
;
  %zextX = zext i1 %X to i32
  %zextY = zext i1 %Y to i32
  %notX  = xor i32 %zextX, 1
  %notY  = xor i32 %zextY, 1
  %and   = and i32 %notX, %notY
  ret i32 %and
}

