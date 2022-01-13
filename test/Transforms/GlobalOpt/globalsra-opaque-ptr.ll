; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-globals
; RUN: opt -S -globalopt -opaque-pointers < %s | FileCheck %s

; Global SRA should not be performed here (or at least not naively), as
; offset 4 is accessed as both i32 and i64.

%T = type { i32, i32, i32, i32 }
@g = internal global %T zeroinitializer

;.
; CHECK: @[[G:[a-zA-Z0-9_$"\\.-]+]] = internal unnamed_addr global [[T:%.*]] zeroinitializer
;.
define void @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    store i32 1, ptr getelementptr inbounds ([[T:%.*]], ptr @g, i64 0, i32 1), align 4
; CHECK-NEXT:    store i32 2, ptr getelementptr inbounds ([[T]], ptr @g, i64 0, i32 2), align 4
; CHECK-NEXT:    ret void
;
  store i32 1, ptr getelementptr (%T, ptr @g, i64 0, i32 1)
  store i32 2, ptr getelementptr (%T, ptr @g, i64 0, i32 2)
  ret void
}

define i32 @load1() {
; CHECK-LABEL: @load1(
; CHECK-NEXT:    [[V:%.*]] = load i32, ptr getelementptr inbounds ([[T:%.*]], ptr @g, i64 0, i32 1), align 4
; CHECK-NEXT:    ret i32 [[V]]
;
  %v = load i32, ptr getelementptr (%T, ptr @g, i64 0, i32 1)
  ret i32 %v
}

define i64 @load2() {
; CHECK-LABEL: @load2(
; CHECK-NEXT:    [[V:%.*]] = load i64, ptr getelementptr inbounds ([[T:%.*]], ptr @g, i64 0, i32 2), align 4
; CHECK-NEXT:    ret i64 [[V]]
;
  %v = load i64, ptr getelementptr (%T, ptr @g, i64 0, i32 2)
  ret i64 %v
}
