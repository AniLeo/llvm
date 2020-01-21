; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -passes=attributor -aa-pipeline='basic-aa' -attributor-disable=false -attributor-max-iterations-verify -attributor-max-iterations=3 -S < %s | FileCheck %s
; PR2498

; This test tries to convince CHECK about promoting the load from %A + 2,
; because there is a load of %A in the entry block
define internal i32 @callee(i1 %C, i32* %A) {
; CHECK-LABEL: define {{[^@]+}}@callee
; CHECK-SAME: (i1 [[C:%.*]], i32* noalias nocapture nofree nonnull readonly align 536870912 dereferenceable(4) [[A:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_0:%.*]] = load i32, i32* null, align 536870912
; CHECK-NEXT:    br label [[F:%.*]]
; CHECK:       T:
; CHECK-NEXT:    unreachable
; CHECK:       F:
; CHECK-NEXT:    [[A_2:%.*]] = getelementptr i32, i32* null, i32 2
; CHECK-NEXT:    [[R:%.*]] = load i32, i32* [[A_2]]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  ; Unconditonally load the element at %A
  %A.0 = load i32, i32* %A
  br i1 %C, label %T, label %F

T:
  ret i32 %A.0

F:
  ; Load the element at offset two from %A. This should not be promoted!
  %A.2 = getelementptr i32, i32* %A, i32 2
  %R = load i32, i32* %A.2
  ret i32 %R
}

define i32 @foo() {
; CHECK-LABEL: define {{[^@]+}}@foo()
; CHECK-NEXT:    [[X:%.*]] = call i32 @callee(i1 false, i32* noalias nofree readonly align 536870912 null)
; CHECK-NEXT:    ret i32 [[X]]
;
  %X = call i32 @callee(i1 false, i32* null)             ; <i32> [#uses=1]
  ret i32 %X
}

