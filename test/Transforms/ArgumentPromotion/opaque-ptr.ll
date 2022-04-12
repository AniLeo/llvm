; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -S -argpromotion -opaque-pointers < %s | FileCheck %s

define internal i32 @callee_basic(ptr %p) {
; CHECK-LABEL: define {{[^@]+}}@callee_basic
; CHECK-SAME: (i32 [[P_0_VAL:%.*]], i32 [[P_4_VAL:%.*]]) {
; CHECK-NEXT:    [[Z:%.*]] = add i32 [[P_0_VAL]], [[P_4_VAL]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %x = load i32, ptr %p
  %p1 = getelementptr i8, ptr %p, i64 4
  %y = load i32, ptr %p1
  %z = add i32 %x, %y
  ret i32 %z
}

define void @caller_basic(ptr %p) {
; CHECK-LABEL: define {{[^@]+}}@caller_basic
; CHECK-SAME: (ptr [[P:%.*]]) {
; CHECK-NEXT:    [[P_VAL:%.*]] = load i32, ptr [[P]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr i8, ptr [[P]], i64 4
; CHECK-NEXT:    [[P_VAL1:%.*]] = load i32, ptr [[TMP1]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @callee_basic(i32 [[P_VAL]], i32 [[P_VAL1]])
; CHECK-NEXT:    ret void
;
  call i32 @callee_basic(ptr %p)
  ret void
}

; Same offset is loaded with two differen types: Don't promote.
define internal i32 @callee_different_types(ptr %p) {
; CHECK-LABEL: define {{[^@]+}}@callee_different_types
; CHECK-SAME: (ptr [[P:%.*]]) {
; CHECK-NEXT:    [[X:%.*]] = load i32, ptr [[P]], align 4
; CHECK-NEXT:    [[Y_F:%.*]] = load float, ptr [[P]], align 4
; CHECK-NEXT:    [[Y:%.*]] = fptoui float [[Y_F]] to i32
; CHECK-NEXT:    [[Z:%.*]] = add i32 [[X]], [[Y]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %x = load i32, ptr %p
  %y.f = load float, ptr %p
  %y = fptoui float %y.f to i32
  %z = add i32 %x, %y
  ret i32 %z
}

define void @caller_different_types(ptr %p) {
; CHECK-LABEL: define {{[^@]+}}@caller_different_types
; CHECK-SAME: (ptr [[P:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @callee_different_types(ptr [[P]])
; CHECK-NEXT:    ret void
;
  call i32 @callee_different_types(ptr %p)
  ret void
}

; The two loads overlap: Don't promote.
define internal i32 @callee_overlap(ptr %p) {
; CHECK-LABEL: define {{[^@]+}}@callee_overlap
; CHECK-SAME: (ptr [[P:%.*]]) {
; CHECK-NEXT:    [[X:%.*]] = load i32, ptr [[P]], align 4
; CHECK-NEXT:    [[P1:%.*]] = getelementptr i8, ptr [[P]], i64 2
; CHECK-NEXT:    [[Y:%.*]] = load i32, ptr [[P1]], align 4
; CHECK-NEXT:    [[Z:%.*]] = add i32 [[X]], [[Y]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %x = load i32, ptr %p
  %p1 = getelementptr i8, ptr %p, i64 2
  %y = load i32, ptr %p1
  %z = add i32 %x, %y
  ret i32 %z
}

define void @caller_overlap(ptr %p) {
; CHECK-LABEL: define {{[^@]+}}@caller_overlap
; CHECK-SAME: (ptr [[P:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @callee_overlap(ptr [[P]])
; CHECK-NEXT:    ret void
;
  call i32 @callee_overlap(ptr %p)
  ret void
}

; Don't promote calls with function type mismatch.
define void @caller_type_mismatch() {
; CHECK-LABEL: define {{[^@]+}}@caller_type_mismatch() {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @callee_type_mismatch(ptr null)
; CHECK-NEXT:    ret void
;
  call i32 @callee_type_mismatch(ptr null)
  ret void
}

define internal void @callee_type_mismatch(ptr %p) {
; CHECK-LABEL: define {{[^@]+}}@callee_type_mismatch
; CHECK-SAME: (ptr [[P:%.*]]) {
; CHECK-NEXT:    ret void
;
  ret void
}
