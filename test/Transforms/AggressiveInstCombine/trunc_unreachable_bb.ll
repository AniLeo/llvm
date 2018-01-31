; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -aggressive-instcombine -S | FileCheck %s
; RUN: opt < %s -passes=aggressive-instcombine -S | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

; Aggressive Instcombine should be able ignore unreachable basic block.

define void @func_20() {
; CHECK-LABEL: @func_20(
; CHECK-NEXT:  for.body94:
; CHECK-NEXT:    unreachable
; CHECK:       for.cond641:
; CHECK-NEXT:    [[OR722:%.*]] = or i32 [[OR722]], undef
; CHECK-NEXT:    [[OR723:%.*]] = or i32 [[OR722]], 1
; CHECK-NEXT:    [[CONV724:%.*]] = trunc i32 [[OR723]] to i16
; CHECK-NEXT:    br label [[FOR_COND641:%.*]]
;
for.body94:
  unreachable

for.cond641:
  %or722 = or i32 %or722, undef
  %or723 = or i32 %or722, 1
  %conv724 = trunc i32 %or723 to i16
  br label %for.cond641
}

define void @func_21() {
; CHECK-LABEL: @func_21(
; CHECK-NEXT:  for.body94:
; CHECK-NEXT:    unreachable
; CHECK:       for.cond641:
; CHECK-NEXT:    [[OR722:%.*]] = or i32 [[A:%.*]], undef
; CHECK-NEXT:    [[A]] = or i32 [[OR722]], undef
; CHECK-NEXT:    [[OR723:%.*]] = or i32 [[OR722]], 1
; CHECK-NEXT:    [[CONV724:%.*]] = trunc i32 [[OR723]] to i16
; CHECK-NEXT:    br label [[FOR_COND641:%.*]]
;
for.body94:
  unreachable

for.cond641:
  %or722 = or i32 %a, undef
  %a = or i32 %or722, undef
  %or723 = or i32 %or722, 1
  %conv724 = trunc i32 %or723 to i16
  br label %for.cond641
}
