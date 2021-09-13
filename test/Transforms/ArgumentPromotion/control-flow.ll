; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt < %s -passes=argpromotion -S | FileCheck %s

; Don't promote around control flow.
define internal i32 @callee(i1 %C, i32* %P) {
; CHECK-LABEL: define {{[^@]+}}@callee
; CHECK-SAME: (i1 [[C:%.*]], i32* [[P:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       T:
; CHECK-NEXT:    ret i32 17
; CHECK:       F:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P]]
; CHECK-NEXT:    ret i32 [[X]]
;
entry:
  br i1 %C, label %T, label %F

T:
  ret i32 17

F:
  %X = load i32, i32* %P
  ret i32 %X
}

define i32 @foo() {
; CHECK-LABEL: define {{[^@]+}}@foo()
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = call i32 @callee(i1 true, i32* null)
; CHECK-NEXT:    ret i32 [[X]]
;
entry:
  %X = call i32 @callee(i1 true, i32* null)
  ret i32 %X
}

