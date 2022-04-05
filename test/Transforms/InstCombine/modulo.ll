; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -passes=instcombine | FileCheck %s

define i32 @PR21929(i32 %x) {
; CHECK-LABEL: @PR21929(
; CHECK-NEXT:    [[REM_I:%.*]] = srem i32 [[X:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[REM_I]], 30
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 2
; CHECK-NEXT:    [[RET_I:%.*]] = add nsw i32 [[TMP2]], [[REM_I]]
; CHECK-NEXT:    ret i32 [[RET_I]]
;
  %rem.i = srem i32 %x, 2
  %cmp.i = icmp slt i32 %rem.i, 0
  %add.i = select i1 %cmp.i, i32 2, i32 0
  %ret.i = add nsw i32 %add.i, %rem.i
  ret i32 %ret.i
}

define <2 x i32> @PR21929_vec(<2 x i32> %x) {
; CHECK-LABEL: @PR21929_vec(
; CHECK-NEXT:    [[REM_I:%.*]] = srem <2 x i32> [[X:%.*]], <i32 2, i32 2>
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i32> [[REM_I]], <i32 30, i32 30>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i32> [[TMP1]], <i32 2, i32 2>
; CHECK-NEXT:    [[RET_I:%.*]] = add nsw <2 x i32> [[TMP2]], [[REM_I]]
; CHECK-NEXT:    ret <2 x i32> [[RET_I]]
;
  %rem.i = srem <2 x i32> %x, <i32 2, i32 2>
  %cmp.i = icmp slt <2 x i32> %rem.i, zeroinitializer
  %add.i = select <2 x i1> %cmp.i, <2 x i32> <i32 2, i32 2>, <2 x i32> zeroinitializer
  %ret.i = add nsw <2 x i32> %add.i, %rem.i
  ret <2 x i32> %ret.i
}
