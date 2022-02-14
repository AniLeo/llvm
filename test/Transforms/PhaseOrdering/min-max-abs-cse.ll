; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -O1 | FileCheck %s
; RUN: opt -passes='default<O1>' -S < %s | FileCheck %s

; In all tests, expect instcombine to canonicalize the select patterns
; for min/max/abs to allow CSE and subsequent simplification.

; sub (smax a,b), (smax a,b) --> 0

define i8 @smax_nsw(i8 %a, i8 %b) {
; CHECK-LABEL: @smax_nsw(
; CHECK-NEXT:    ret i8 0
;
  %sub = sub nsw i8 %a, %b
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp sgt i8 %sub, 0
  %m1 = select i1 %cmp1, i8 0, i8 %sub
  %m2 = select i1 %cmp2, i8 %sub, i8 0
  %r = sub i8 %m2, %m1
  ret i8 %r
}

; or (abs a), (abs a) --> abs a

define i8 @abs_swapped(i8 %a) {
; CHECK-LABEL: @abs_swapped(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[A:%.*]], i1 false)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %neg = sub i8 0, %a
  %cmp1 = icmp sgt i8 %a, 0
  %cmp2 = icmp slt i8 %a, 0
  %m1 = select i1 %cmp1, i8 %a, i8 %neg
  %m2 = select i1 %cmp2, i8 %neg, i8 %a
  %r = or i8 %m2, %m1
  ret i8 %r
}

; xor (nabs a), (nabs a) --> 0

define i8 @nabs_swapped(i8 %a) {
; CHECK-LABEL: @nabs_swapped(
; CHECK-NEXT:    ret i8 0
;
  %neg = sub i8 0, %a
  %cmp1 = icmp slt i8 %a, 0
  %cmp2 = icmp sgt i8 %a, 0
  %m1 = select i1 %cmp1, i8 %a, i8 %neg
  %m2 = select i1 %cmp2, i8 %neg, i8 %a
  %r = xor i8 %m2, %m1
  ret i8 %r
}

; xor (abs a), (abs a) --> 0

define i8 @abs_different_constants(i8 %a) {
; CHECK-LABEL: @abs_different_constants(
; CHECK-NEXT:    ret i8 0
;
  %neg = sub i8 0, %a
  %cmp1 = icmp sgt i8 %a, -1
  %cmp2 = icmp slt i8 %a, 0
  %m1 = select i1 %cmp1, i8 %a, i8 %neg
  %m2 = select i1 %cmp2, i8 %neg, i8 %a
  %r = xor i8 %m2, %m1
  ret i8 %r
}

; or (nabs a), (nabs a) --> nabs a

define i8 @nabs_different_constants(i8 %a) {
; CHECK-LABEL: @nabs_different_constants(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[A:%.*]], i1 false)
; CHECK-NEXT:    [[M1:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[M1]]
;
  %neg = sub i8 0, %a
  %cmp1 = icmp slt i8 %a, 0
  %cmp2 = icmp sgt i8 %a, -1
  %m1 = select i1 %cmp1, i8 %a, i8 %neg
  %m2 = select i1 %cmp2, i8 %neg, i8 %a
  %r = or i8 %m2, %m1
  ret i8 %r
}
