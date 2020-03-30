; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S -o - | FileCheck %s

; CHECK-LABEL: @a(
define i32 @a(<4 x i64> %I) {
; CHECK-LABEL: @a(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <4 x i64> [[I:%.*]], i32 3
; CHECK-NEXT:    [[K:%.*]] = trunc i64 [[TMP0]] to i32
; CHECK-NEXT:    ret i32 [[K]]
;
entry:
  %J = trunc <4 x i64> %I to <4 x i32>
  %K = extractelement <4 x i32> %J, i32 3
  ret i32 %K
}


; CHECK-LABEL: @b(
define i32 @b(<4 x float> %I) {
; CHECK-LABEL: @b(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <4 x float> [[I:%.*]], i32 3
; CHECK-NEXT:    [[K:%.*]] = fptosi float [[TMP0]] to i32
; CHECK-NEXT:    ret i32 [[K]]
;
entry:
  %J = fptosi <4 x float> %I to <4 x i32>
  %K = extractelement <4 x i32> %J, i32 3
  ret i32 %K
}

