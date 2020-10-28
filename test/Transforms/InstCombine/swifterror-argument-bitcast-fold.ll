; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S %s | FileCheck %s

; The swifterror value can only be loaded, stored or used as swifterror
; argument. Make sure we do not try to turn the function bitcast into an
; argument bitcast.
define swiftcc void @spam(i32** swifterror %arg) {
; CHECK-LABEL: @spam(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    call swiftcc void bitcast (void (i64**)* @widget to void (i32**)*)(i32** swifterror [[ARG:%.*]])
; CHECK-NEXT:    ret void
;
bb:
  call swiftcc void bitcast (void (i64**)* @widget to void (i32**)*)(i32** swifterror %arg)
  ret void
}

declare swiftcc void @widget(i64**)
