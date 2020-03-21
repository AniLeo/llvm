; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Result of left shifting a non-negative integer
; with nsw flag should also be non-negative
define i1 @test_shift_nonnegative(i32 %a) {
; CHECK-LABEL: @test_shift_nonnegative(
; CHECK-NEXT:    ret i1 true
;
  %b = lshr i32 %a, 2
  %shift = shl nsw i32 %b, 3
  %cmp = icmp sge i32 %shift, 0
  ret i1 %cmp
}

; Result of left shifting a negative integer with
; nsw flag should also be negative
define i1 @test_shift_negative(i32 %a, i32 %b) {
; CHECK-LABEL: @test_shift_negative(
; CHECK-NEXT:    ret i1 true
;
  %c = or i32 %a, -2147483648
  %d = and i32 %b, 7
  %shift = shl nsw i32 %c, %d
  %cmp = icmp slt i32 %shift, 0
  ret i1 %cmp
}

; If sign bit is a known zero, it cannot be a known one.
; This test should not crash opt. The shift produces poison.
define i32 @test_no_sign_bit_conflict1(i1 %b) {
; CHECK-LABEL: @test_no_sign_bit_conflict1(
; CHECK-NEXT:    ret i32 undef
;
  %sel = select i1 %b, i32 8193, i32 8192
  %mul = shl nsw i32 %sel, 18
  ret i32 %mul
}

; If sign bit is a known one, it cannot be a known zero.
; This test should not crash opt. The shift produces poison.
define i32 @test_no_sign_bit_conflict2(i1 %b) {
; CHECK-LABEL: @test_no_sign_bit_conflict2(
; CHECK-NEXT:    ret i32 undef
;
  %sel = select i1 %b, i32 -8193, i32 -8194
  %mul = shl nsw i32 %sel, 18
  ret i32 %mul
}
