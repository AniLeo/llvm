; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -newgvn -S | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

%rec11 = type { i16, i16, i16 }

@str = global %rec11 { i16 1, i16 2, i16 3 }

;; Test that we forward the first store to the second load
define i16 @bazinga() {
; CHECK-LABEL: @bazinga(
; CHECK-NEXT:    [[_TMP10:%.*]] = load i16, i16* getelementptr inbounds (%rec11, %rec11* @str, i64 0, i32 1)
; CHECK-NEXT:    store i16 [[_TMP10]], i16* getelementptr inbounds (%rec11, %rec11* @str, i64 0, i32 0)
; CHECK-NEXT:    [[_TMP15:%.*]] = icmp eq i16 [[_TMP10]], 3
; CHECK-NEXT:    [[_TMP16:%.*]] = select i1 [[_TMP15]], i16 1, i16 0
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    ret i16 [[_TMP16]]
;
  %_tmp9 = getelementptr %rec11, %rec11* @str, i16 0, i32 1
  %_tmp10 = load i16, i16* %_tmp9
  %_tmp12 = getelementptr %rec11, %rec11* @str, i16 0, i32 0
  store i16 %_tmp10, i16* %_tmp12
  %_tmp13 = getelementptr %rec11, %rec11* @str, i16 0, i32 0
  %_tmp14 = load i16, i16* %_tmp13
  %_tmp15 = icmp eq i16 %_tmp14, 3
  %_tmp16 = select i1 %_tmp15, i16 1, i16 0
  br label %bb1

bb1:
  ret i16 %_tmp16
}
