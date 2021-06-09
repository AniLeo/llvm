; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt --passes=slp-vectorizer,instcombine -slp-threshold=-1000000 -S < %s | FileCheck %s

define i32 @foo() {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i32 -162
;
entry:
  %i = xor i32 4, -9
  %i1 = xor i32 5, %i
  %i2 = xor i32 6, %i1
  %i3 = add i32 %i2, 0
  %i4 = add i32 -9, %i3
  %i5 = xor i32 8, -9
  %i6 = add i32 %i5, %i4
  %i7 = xor i32 9, %i5
  %i8 = add i32 %i7, %i6
  %i9 = xor i32 10, %i7
  %i10 = add i32 %i9, %i8
  %i11 = add i32 -9, %i10
  %i12 = xor i32 12, -9
  %i13 = add i32 %i12, %i11
  %i14 = xor i32 13, %i12
  %i15 = add i32 %i14, %i13
  %i16 = xor i32 14, %i14
  %i17 = add i32 %i16, %i15
  %i18 = add i32 -9, %i17
  %i19 = xor i32 16, -9
  %i20 = add i32 %i19, %i18
  %i21 = xor i32 17, %i19
  %i22 = add i32 %i21, %i20
  %i23 = xor i32 18, %i21
  %i24 = add i32 %i23, %i22
  %i25 = add i32 -9, %i24
  %i26 = add i32 0, %i25
  %i27 = add i32 0, %i26
  %i28 = add i32 0, %i27
  %i29 = add i32 -9, %i28
  %i30 = add i32 0, %i29
  %i31 = add i32 0, %i30
  %i32 = add i32 0, %i31
  ret i32 %i32
}
