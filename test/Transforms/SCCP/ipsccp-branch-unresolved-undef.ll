; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature
; RUN: opt < %s -S -passes=ipsccp | FileCheck %s

define void @main() {
; CHECK-LABEL: define {{[^@]+}}@main() {
; CHECK-NEXT:    [[CALL:%.*]] = call i1 @patatino(i1 undef)
; CHECK-NEXT:    ret void
;
  %call = call i1 @patatino(i1 undef)
  ret void
}

define internal i1 @patatino(i1 %a) {
; CHECK-LABEL: define {{[^@]+}}@patatino
; CHECK-SAME: (i1 [[A:%.*]]) {
; CHECK-NEXT:    unreachable
;
  br i1 %a, label %ontrue, label %onfalse
ontrue:
  ret i1 false
onfalse:
  ret i1 false
}
