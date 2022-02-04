; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
;RUN: opt -passes=instcombine -S %s | FileCheck %s

; We shouldn't remove the select before the srem
define i32 @foo(i1 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[SEL1:%.*]] = select i1 [[A:%.*]], i32 [[B:%.*]], i32 -1
; CHECK-NEXT:    [[REM:%.*]] = srem i32 [[C:%.*]], [[SEL1]]
; CHECK-NEXT:    [[SEL2:%.*]] = select i1 [[A]], i32 [[REM]], i32 0
; CHECK-NEXT:    ret i32 [[SEL2]]
;
  %sel1 = select i1 %a, i32 %b, i32 -1
  %rem = srem i32 %c, %sel1
  %sel2 = select i1 %a, i32 %rem, i32 0
  ret i32 %sel2
}

