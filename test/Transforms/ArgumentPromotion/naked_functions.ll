; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt < %s -passes=argpromotion -S | FileCheck %s

; Don't promote paramaters of/arguments to naked functions

@g = common global i32 0, align 4

define i32 @bar() {
; CHECK-LABEL: define {{[^@]+}}@bar() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @foo(i32* @g)
; CHECK-NEXT:    ret i32 [[CALL]]
;
entry:
  %call = call i32 @foo(i32* @g)
  ret i32 %call
}

define internal i32 @foo(i32*) #0 {
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: (i32* [[TMP0:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RETVAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void asm sideeffect "ldr r0, [r0] \0Abx lr \0A", ""()
; CHECK-NEXT:    unreachable
;
entry:
  %retval = alloca i32, align 4
  call void asm sideeffect "ldr r0, [r0] \0Abx lr        \0A", ""()
  unreachable
}


attributes #0 = { naked }
