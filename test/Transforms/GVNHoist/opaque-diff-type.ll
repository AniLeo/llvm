; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -opaque-pointers -passes="gvn-hoist" -S %s | FileCheck %s

; Checks that gvn-hoist does not try to merge loads of the same source pointer
; when the results are different types.

define linkonce_odr void @i16i32(ptr %arg) {
; CHECK-LABEL: @i16i32(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br i1 false, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T:%.*]] = load i16, ptr [[ARG:%.*]], align 4
; CHECK-NEXT:    br label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    [[T3:%.*]] = load i32, ptr [[ARG]], align 8
; CHECK-NEXT:    ret void
;
bb:
  br i1 false, label %bb1, label %bb2

bb1:                                              ; preds = %bb
  %t = load i16, ptr %arg, align 4
  br label %bb2

bb2:                                              ; preds = %bb1, %bb
  %t3 = load i32, ptr %arg, align 8
  ret void
}

define linkonce_odr void @i32f32(ptr %arg) {
; CHECK-LABEL: @i32f32(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br i1 false, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T:%.*]] = load i32, ptr [[ARG:%.*]], align 4
; CHECK-NEXT:    br label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    [[T3:%.*]] = load float, ptr [[ARG]], align 8
; CHECK-NEXT:    ret void
;
bb:
  br i1 false, label %bb1, label %bb2

bb1:                                              ; preds = %bb
  %t = load i32, ptr %arg, align 4
  br label %bb2

bb2:                                              ; preds = %bb1, %bb
  %t3 = load float, ptr %arg, align 8
  ret void
}

define linkonce_odr void @i64ptr(ptr %arg) {
; CHECK-LABEL: @i64ptr(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br i1 false, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T:%.*]] = load i64, ptr [[ARG:%.*]], align 4
; CHECK-NEXT:    br label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    [[T3:%.*]] = load ptr, ptr [[ARG]], align 8
; CHECK-NEXT:    ret void
;
bb:
  br i1 false, label %bb1, label %bb2

bb1:                                              ; preds = %bb
  %t = load i64, ptr %arg, align 4
  br label %bb2

bb2:                                              ; preds = %bb1, %bb
  %t3 = load ptr, ptr %arg, align 8
  ret void
}

define linkonce_odr void @ptrptr_diff_aspace(ptr %arg) {
; CHECK-LABEL: @ptrptr_diff_aspace(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br i1 false, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T:%.*]] = load ptr addrspace(4), ptr [[ARG:%.*]], align 4
; CHECK-NEXT:    br label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    [[T3:%.*]] = load ptr addrspace(2), ptr [[ARG]], align 8
; CHECK-NEXT:    ret void
;
bb:
  br i1 false, label %bb1, label %bb2

bb1:                                              ; preds = %bb
  %t = load ptr addrspace(4), ptr %arg, align 4
  br label %bb2

bb2:                                              ; preds = %bb1, %bb
  %t3 = load ptr addrspace(2), ptr %arg, align 8
  ret void
}

define linkonce_odr void @ptrptr(ptr %arg) {
; CHECK-LABEL: @ptrptr(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[T3:%.*]] = load ptr, ptr [[ARG:%.*]], align 4
; CHECK-NEXT:    br i1 false, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    ret void
;
bb:
  br i1 false, label %bb1, label %bb2

bb1:                                              ; preds = %bb
  %t = load ptr, ptr %arg, align 4
  br label %bb2

bb2:                                              ; preds = %bb1, %bb
  %t3 = load ptr, ptr %arg, align 8
  ret void
}
