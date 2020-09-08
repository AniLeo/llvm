; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

declare i8 @llvm.umin.i8(i8, i8)
declare i8 @llvm.umax.i8(i8, i8)
declare i8 @llvm.smin.i8(i8, i8)
declare i8 @llvm.smax.i8(i8, i8)

define i8 @umin_known_bits(i8 %x, i8 %y) {
; CHECK-LABEL: @umin_known_bits(
; CHECK-NEXT:    ret i8 0
;
  %x2 = and i8 %x, 127
  %m = call i8 @llvm.umin.i8(i8 %x2, i8 %y)
  %r = and i8 %m, -128
  ret i8 %r
}

define i8 @umax_known_bits(i8 %x, i8 %y) {
; CHECK-LABEL: @umax_known_bits(
; CHECK-NEXT:    ret i8 -128
;
  %x2 = or i8 %x, -128
  %m = call i8 @llvm.umax.i8(i8 %x2, i8 %y)
  %r = and i8 %m, -128
  ret i8 %r
}

define i8 @smin_known_bits(i8 %x, i8 %y) {
; CHECK-LABEL: @smin_known_bits(
; CHECK-NEXT:    ret i8 -128
;
  %x2 = or i8 %x, -128
  %m = call i8 @llvm.smin.i8(i8 %x2, i8 %y)
  %r = and i8 %m, -128
  ret i8 %r
}

define i8 @smax_known_bits(i8 %x, i8 %y) {
; CHECK-LABEL: @smax_known_bits(
; CHECK-NEXT:    ret i8 0
;
  %x2 = and i8 %x, 127
  %m = call i8 @llvm.smax.i8(i8 %x2, i8 %y)
  %r = and i8 %m, -128
  ret i8 %r
}
