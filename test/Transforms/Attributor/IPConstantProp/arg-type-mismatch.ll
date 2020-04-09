; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -S -passes=attributor -aa-pipeline='basic-aa' -attributor-disable=false -attributor-max-iterations-verify -attributor-max-iterations=1 < %s | FileCheck %s

; This test is just to verify that we do not crash/assert due to mismatch in
; argument type between the caller and callee.

define dso_local i16 @foo(i16 %a) {
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: (i16 [[A:%.*]])
; CHECK-NEXT:    [[CALL:%.*]] = call i16 bitcast (i16 (i16, i16)* @bar to i16 (i16, i32)*)(i16 [[A]], i32 7)
; CHECK-NEXT:    ret i16 [[CALL]]
;
  %call = call i16 bitcast (i16 (i16, i16) * @bar to i16 (i16, i32) *)(i16 %a, i32 7)
  ret i16 %call
}

define internal i16 @bar(i16 %p1, i16 %p2) {
; CHECK-LABEL: define {{[^@]+}}@bar
; CHECK-SAME: (i16 [[P1:%.*]], i16 returned [[P2:%.*]])
; CHECK-NEXT:    ret i16 [[P2]]
;
  ret i16 %p2
}


