; RUN: opt -S -simplifycfg < %s | FileCheck %s

declare void @llvm.experimental.guard(i1, ...)

define i32 @f_0(i1 %c) {
; CHECK-LABEL: @f_0(
; CHECK-NEXT: entry:
; CHECK-NEXT:  call void (i1, ...) @llvm.experimental.guard(i1 false) [ "deopt"() ]
; CHECK-NEXT:  unreachable
entry:
  call void(i1, ...) @llvm.experimental.guard(i1 false) [ "deopt"() ]
  ret i32 10
}

define i32 @f_1(i1 %c) {
; Demonstrate that we (intentionally) do not simplify a guard on undef

; CHECK-LABEL: @f_1(
; CHECK: ret i32 10
; CHECK: ret i32 20

entry:
  br i1 %c, label %true, label %false

true:
  call void(i1, ...) @llvm.experimental.guard(i1 undef) [ "deopt"() ]
  ret i32 10

false:
  ret i32 20
}

define i32 @f_2(i1 %c, i32* %buf) {
; CHECK-LABEL: @f_2(
entry:
  br i1 %c, label %guard_block, label %merge_block

guard_block:
  call void(i1, ...) @llvm.experimental.guard(i1 false) [ "deopt"() ]
  %val = load i32, i32* %buf
  br label %merge_block

merge_block:
  %to.return = phi i32 [ %val, %guard_block ], [ 50, %entry ]
  ret i32 %to.return
; CHECK: guard_block:
; CHECK-NEXT:  call void (i1, ...) @llvm.experimental.guard(i1 false) [ "deopt"() ]
; CHECK-NEXT:  unreachable

; CHECK: merge_block:
; CHECK-NEXT:  ret i32 50
}

define i32 @f_3(i1* %c, i32* %buf) {
; CHECK-LABEL: @f_3(
entry:
  %c0 = load volatile i1, i1* %c
  br i1 %c0, label %guard_block, label %merge_block

guard_block:
  call void(i1, ...) @llvm.experimental.guard(i1 false) [ "deopt"() ]
  %val = load i32, i32* %buf
  %c2 = load volatile i1, i1* %c
  br i1 %c2, label %left, label %right

merge_block:
  %c1 = load volatile i1, i1* %c
  br i1 %c1, label %left, label %right

left:
  %val.left = phi i32 [ %val, %guard_block ], [ 50, %merge_block ]
  ret i32 %val.left

right:
  %val.right = phi i32 [ %val, %guard_block ], [ 100, %merge_block ]
  ret i32 %val.right

; CHECK: guard_block:
; CHECK-NEXT:   call void (i1, ...) @llvm.experimental.guard(i1 false) [ "deopt"() ]
; CHECK-NEXT:  unreachable

; CHECK: merge_block:
; CHECK-NEXT:  %c1 = load volatile i1, i1* %c
; CHECK-NEXT:  [[VAL:%[^ ]]] = select i1 %c1, i32 50, i32 100
; CHECK-NEXT:  ret i32 [[VAL]]
}
