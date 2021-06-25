; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature
; RUN: llvm-as < %s | llvm-dis --force-opaque-pointers | FileCheck %s
; RUN: opt --force-opaque-pointers < %s -S | FileCheck %s

; CHECK: @g = external global i16
@g = external global i16

; CHECK: @ga = alias i18, ptr @g2
@g2 = global i18 0
@ga = alias i18, i18* @g2

define void @f(i32* %p) {
; CHECK-LABEL: define {{[^@]+}}@f
; CHECK-SAME: (ptr [[P:%.*]]) {
; CHECK-NEXT:    [[A:%.*]] = alloca i17, align 4
; CHECK-NEXT:    ret void
;
  %a = alloca i17
  ret void
}
