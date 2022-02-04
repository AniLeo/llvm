; NOTE: Assertions have been autogenerated by update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

define i1 @add(i1 %x) {
; CHECK-LABEL: @add(
; CHECK:         ret i1 false
;
  %z = add i1 %x, %x
  ret i1 %z
}

define i1 @sub(i1 %x) {
; CHECK-LABEL: @sub(
; CHECK:         ret i1 %x
;
  %z = sub i1 false, %x
  ret i1 %z
}

define i1 @mul(i1 %x) {
; CHECK-LABEL: @mul(
; CHECK:         ret i1 %x
;
  %z = mul i1 %x, %x
  ret i1 %z
}

define i1 @ne(i1 %x) {
; CHECK-LABEL: @ne(
; CHECK:         ret i1 %x
;
  %z = icmp ne i1 %x, 0
  ret i1 %z
}
