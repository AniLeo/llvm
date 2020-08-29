; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes
; RUN: opt < %s -attributor -attributor-annotate-decl-cs  -attributor-max-iterations=2 -S | FileCheck %s
; RUN: opt < %s -attributor -attributor-annotate-decl-cs  -attributor-max-iterations=3 -S | FileCheck %s
; RUN: opt < %s -attributor -attributor-annotate-decl-cs  -attributor-max-iterations=4 -S | FileCheck %s
; RUN: opt < %s -attributor -attributor-annotate-decl-cs  -attributor-max-iterations=2147483647 -S | FileCheck %s

; CHECK-NOT: Function
; CHECK: declare i32 @foo1()
; CHECK-NOT: Function
; CHECK: declare i32 @foo2()
; CHECK-NOT: Function
; CHECK: declare i32 @foo3()
declare i32 @foo1()
declare i32 @foo2()
declare i32 @foo3()

define internal i32 @bar() {
; CHECK-LABEL: define {{[^@]+}}@bar() {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @foo1()
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @foo2()
; CHECK-NEXT:    [[TMP3:%.*]] = call i32 @foo3()
; CHECK-NEXT:    ret i32 undef
;
  %1 = call i32 @foo1()
  %2 = call i32 @foo2()
  %3 = call i32 @foo3()
  ret i32 1
}

define i32 @baz() {
; CHECK-LABEL: define {{[^@]+}}@baz() {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @bar()
; CHECK-NEXT:    ret i32 0
;
  %1 = call i32 @bar()
  ret i32 0
}

; We should never derive anything here
; CHECK-NOT: attributes
