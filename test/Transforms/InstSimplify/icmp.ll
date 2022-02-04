; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

target datalayout = "e-p:64:64:64-p1:16:16:16-p2:32:32:32-p3:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

declare void @usei8ptr(i8* %ptr)

; Ensure that we do not crash when looking at such a weird bitcast.
define i1 @bitcast_from_single_element_pointer_vector_to_pointer(<1 x i8*> %ptr1vec, i8* %ptr2) {
; CHECK-LABEL: @bitcast_from_single_element_pointer_vector_to_pointer(
; CHECK-NEXT:    [[PTR1:%.*]] = bitcast <1 x i8*> [[PTR1VEC:%.*]] to i8*
; CHECK-NEXT:    call void @usei8ptr(i8* [[PTR1]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8* [[PTR1]], [[PTR2:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %ptr1 = bitcast <1 x i8*> %ptr1vec to i8*
  call void @usei8ptr(i8* %ptr1)
  %cmp = icmp eq i8* %ptr1, %ptr2
  ret i1 %cmp
}

define i1 @poison(i32 %x) {
; CHECK-LABEL: @poison(
; CHECK-NEXT:    ret i1 poison
;
  %v = icmp eq i32 %x, poison
  ret i1 %v
}

define i1 @poison2(i32 %x) {
; CHECK-LABEL: @poison2(
; CHECK-NEXT:    ret i1 poison
;
  %v = icmp slt i32 %x, poison
  ret i1 %v
}

define i1 @mul_div_cmp_smaller(i8 %x) {
; CHECK-LABEL: @mul_div_cmp_smaller(
; CHECK-NEXT:    ret i1 true
;
  %mul = mul i8 %x, 3
  %div = udiv i8 %mul, 4
  %cmp = icmp ule i8 %div, %x
  ret i1 %cmp
}

define i1 @mul_div_cmp_equal(i8 %x) {
; CHECK-LABEL: @mul_div_cmp_equal(
; CHECK-NEXT:    ret i1 true
;
  %mul = mul i8 %x, 3
  %div = udiv i8 %mul, 3
  %cmp = icmp ule i8 %div, %x
  ret i1 %cmp
}

; Negative test: 3>2
define i1 @mul_div_cmp_greater(i8 %x) {
; CHECK-LABEL: @mul_div_cmp_greater(
; CHECK-NEXT:    [[MUL:%.*]] = mul i8 [[X:%.*]], 3
; CHECK-NEXT:    [[DIV:%.*]] = udiv i8 [[MUL]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i8 [[DIV]], [[X]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %mul = mul i8 %x, 3
  %div = udiv i8 %mul, 2
  %cmp = icmp ule i8 %div, %x
  ret i1 %cmp
}
define i1 @mul_div_cmp_ugt(i8 %x) {
; CHECK-LABEL: @mul_div_cmp_ugt(
; CHECK-NEXT:    ret i1 false
;
  %mul = mul i8 %x, 3
  %div = udiv i8 %mul, 4
  %cmp = icmp ugt i8 %div, %x
  ret i1 %cmp
}

; Negative test: Wrong predicate
define i1 @mul_div_cmp_uge(i8 %x) {
; CHECK-LABEL: @mul_div_cmp_uge(
; CHECK-NEXT:    [[MUL:%.*]] = mul i8 [[X:%.*]], 3
; CHECK-NEXT:    [[DIV:%.*]] = udiv i8 [[MUL]], 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i8 [[DIV]], [[X]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %mul = mul i8 %x, 3
  %div = udiv i8 %mul, 4
  %cmp = icmp uge i8 %div, %x
  ret i1 %cmp
}

; Negative test: Wrong predicate
define i1 @mul_div_cmp_ult(i8 %x) {
; CHECK-LABEL: @mul_div_cmp_ult(
; CHECK-NEXT:    [[MUL:%.*]] = mul i8 [[X:%.*]], 3
; CHECK-NEXT:    [[DIV:%.*]] = udiv i8 [[MUL]], 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[DIV]], [[X]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %mul = mul i8 %x, 3
  %div = udiv i8 %mul, 4
  %cmp = icmp ult i8 %div, %x
  ret i1 %cmp
}

; Negative test: Wrong icmp operand
define i1 @mul_div_cmp_wrong_operand(i8 %x, i8 %y) {
; CHECK-LABEL: @mul_div_cmp_wrong_operand(
; CHECK-NEXT:    [[MUL:%.*]] = mul i8 [[X:%.*]], 3
; CHECK-NEXT:    [[DIV:%.*]] = udiv i8 [[MUL]], 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i8 [[DIV]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %mul = mul i8 %x, 3
  %div = udiv i8 %mul, 4
  %cmp = icmp ule i8 %div, %y
  ret i1 %cmp
}

define i1 @mul_lshr_cmp_smaller(i8 %x) {
; CHECK-LABEL: @mul_lshr_cmp_smaller(
; CHECK-NEXT:    ret i1 true
;
  %mul = mul i8 %x, 3
  %div = lshr i8 %mul, 2
  %cmp = icmp ule i8 %div, %x
  ret i1 %cmp
}

define i1 @mul_lshr_cmp_equal(i8 %x) {
; CHECK-LABEL: @mul_lshr_cmp_equal(
; CHECK-NEXT:    ret i1 true
;
  %mul = mul i8 %x, 4
  %div = lshr i8 %mul, 2
  %cmp = icmp ule i8 %div, %x
  ret i1 %cmp
}

define i1 @mul_lshr_cmp_greater(i8 %x) {
; CHECK-LABEL: @mul_lshr_cmp_greater(
; CHECK-NEXT:    [[MUL:%.*]] = mul i8 [[X:%.*]], 5
; CHECK-NEXT:    [[DIV:%.*]] = lshr i8 [[MUL]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i8 [[DIV]], [[X]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %mul = mul i8 %x, 5
  %div = lshr i8 %mul, 2
  %cmp = icmp ule i8 %div, %x
  ret i1 %cmp
}

define i1 @shl_div_cmp_smaller(i8 %x) {
; CHECK-LABEL: @shl_div_cmp_smaller(
; CHECK-NEXT:    ret i1 true
;
  %mul = shl i8 %x, 2
  %div = udiv i8 %mul, 5
  %cmp = icmp ule i8 %div, %x
  ret i1 %cmp
}

define i1 @shl_div_cmp_equal(i8 %x) {
; CHECK-LABEL: @shl_div_cmp_equal(
; CHECK-NEXT:    ret i1 true
;
  %mul = shl i8 %x, 2
  %div = udiv i8 %mul, 4
  %cmp = icmp ule i8 %div, %x
  ret i1 %cmp
}

define i1 @shl_div_cmp_greater(i8 %x) {
; CHECK-LABEL: @shl_div_cmp_greater(
; CHECK-NEXT:    [[MUL:%.*]] = shl i8 [[X:%.*]], 2
; CHECK-NEXT:    [[DIV:%.*]] = udiv i8 [[MUL]], 3
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i8 [[DIV]], [[X]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %mul = shl i8 %x, 2
  %div = udiv i8 %mul, 3
  %cmp = icmp ule i8 %div, %x
  ret i1 %cmp
}

; Don't crash matching recurrences/invertible ops.

define void @PR50191(i32 %x) {
; CHECK-LABEL: @PR50191(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[P1:%.*]] = phi i32 [ [[X:%.*]], [[ENTRY:%.*]] ], [ [[SUB1:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[P2:%.*]] = phi i32 [ [[X]], [[ENTRY]] ], [ [[SUB2:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[SUB1]] = sub i32 [[P1]], [[P2]]
; CHECK-NEXT:    [[SUB2]] = sub i32 42, [[P2]]
; CHECK-NEXT:    br label [[LOOP]]
;
entry:
  br label %loop

loop:
  %p1 = phi i32 [ %x, %entry ], [ %sub1, %loop ]
  %p2 = phi i32 [ %x, %entry ], [ %sub2, %loop ]
  %cmp = icmp eq i32 %p1, %p2
  %user = zext i1 %cmp to i32
  %sub1 = sub i32 %p1, %p2
  %sub2 = sub i32 42, %p2
  br label %loop
}
