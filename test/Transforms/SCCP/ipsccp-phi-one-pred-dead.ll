; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -ipsccp | FileCheck %s
target triple = "x86_64-unknown-linux-gnu"

define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label %Flow5.pre
; CHECK:       Flow6:
; CHECK-NEXT:    br i1 undef, label %end1, label %end2
; CHECK:       Flow5.pre:
; CHECK-NEXT:    br label %Flow5
; CHECK:       Flow5:
; CHECK-NEXT:    br label %Flow6
; CHECK:       end1:
; CHECK-NEXT:    unreachable
; CHECK:       end2:
; CHECK-NEXT:    unreachable
;
entry:
  br i1 true, label %Flow5.pre, label %Flow5.pre.unreachable

Flow5.pre.unreachable:
  br label %Flow5

Flow6:
  br i1 %0, label %end1, label %end2

Flow5.pre:
  br label %Flow5

Flow5:
  %0 = phi i1 [ undef, %Flow5.pre ], [ false, %Flow5.pre.unreachable ]
  br label %Flow6

end1:
  unreachable

end2:
  unreachable
}
