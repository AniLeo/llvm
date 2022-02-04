; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

; This is a specialization of generic folds for min/max values targeted to the
; 'null' ptr constant.
; Related tests for non-pointer types should be included in another file.

; There are 6 basic patterns (or 3 with DeMorganized equivalent) with
;    2 (commute logic op) *
;    2 (swap compare operands) *
; variations for a total of 24 tests.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; (X == null) && (X > Y) --> false
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i1 @ugt_and_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @ugt_and_min(
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp ugt i8* %x, %y
  %cmpeq = icmp eq i8* %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ugt_and_min_commute(<2 x i8>* %x, <2 x i8>* %y)  {
; CHECK-LABEL: @ugt_and_min_commute(
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp ugt <2 x i8>* %x, %y
  %cmpeq = icmp eq <2 x i8>* %x, null
  %r = and i1 %cmpeq, %cmp
  ret i1 %r
}

define i1 @ugt_swap_and_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @ugt_swap_and_min(
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp ult i8* %y, %x
  %cmpeq = icmp eq i8* %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ugt_swap_and_min_commute(i8* %x, i8* %y)  {
; CHECK-LABEL: @ugt_swap_and_min_commute(
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp ult i8* %y, %x
  %cmpeq = icmp eq i8* %x, null
  %r = and i1 %cmpeq, %cmp
  ret i1 %r
}

; Negative test - signed compare

define i1 @sgt_and_min(i9* %x, i9* %y)  {
; CHECK-LABEL: @sgt_and_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i9* [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq i9* [[X]], null
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP]], [[CMPEQ]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp sgt i9* %x, %y
  %cmpeq = icmp eq i9* %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; (X != null) || (X <= Y) --> true
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i1 @ule_or_not_min(i427* %x, i427* %y)  {
; CHECK-LABEL: @ule_or_not_min(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp ule i427* %x, %y
  %cmpeq = icmp ne i427* %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ule_or_not_min_commute(<3 x i9>* %x, <3 x i9>* %y)  {
; CHECK-LABEL: @ule_or_not_min_commute(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp ule <3 x i9>* %x, %y
  %cmpeq = icmp ne <3 x i9>* %x, null
  %r = or i1 %cmpeq, %cmp
  ret i1 %r
}

define i1 @ule_swap_or_not_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @ule_swap_or_not_min(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp uge i8* %y, %x
  %cmpeq = icmp ne i8* %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ule_swap_or_not_min_commute(i8* %x, i8* %y)  {
; CHECK-LABEL: @ule_swap_or_not_min_commute(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp uge i8* %y, %x
  %cmpeq = icmp ne i8* %x, null
  %r = or i1 %cmpeq, %cmp
  ret i1 %r
}

; Negative test - signed compare

define i1 @sle_or_not_min(i427* %x, i427* %y)  {
; CHECK-LABEL: @sle_or_not_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i427* [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne i427* [[X]], null
; CHECK-NEXT:    [[R:%.*]] = or i1 [[CMP]], [[CMPEQ]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp sle i427* %x, %y
  %cmpeq = icmp ne i427* %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; (X == null) && (X <= Y) --> X == null
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i1 @ule_and_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @ule_and_min(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq i8* [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp ule i8* %x, %y
  %cmpeq = icmp eq i8* %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ule_and_min_commute(i8* %x, i8* %y)  {
; CHECK-LABEL: @ule_and_min_commute(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq i8* [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp ule i8* %x, %y
  %cmpeq = icmp eq i8* %x, null
  %r = and i1 %cmpeq, %cmp
  ret i1 %r
}

define i1 @ule_swap_and_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @ule_swap_and_min(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq i8* [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp uge i8* %y, %x
  %cmpeq = icmp eq i8* %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ule_swap_and_min_commute(i8* %x, i8* %y)  {
; CHECK-LABEL: @ule_swap_and_min_commute(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq i8* [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp uge i8* %y, %x
  %cmpeq = icmp eq i8* %x, null
  %r = and i1 %cmpeq, %cmp
  ret i1 %r
}

; Negative test - signed compare

define i1 @sle_and_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @sle_and_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i8* [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq i8* [[X]], null
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP]], [[CMPEQ]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp sle i8* %x, %y
  %cmpeq = icmp eq i8* %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; (X == null) || (X <= Y) --> X <= Y
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i1 @ule_or_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @ule_or_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i8* [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp ule i8* %x, %y
  %cmpeq = icmp eq i8* %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ule_or_min_commute(i8* %x, i8* %y)  {
; CHECK-LABEL: @ule_or_min_commute(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i8* [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp ule i8* %x, %y
  %cmpeq = icmp eq i8* %x, null
  %r = or i1 %cmpeq, %cmp
  ret i1 %r
}

define i1 @ule_swap_or_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @ule_swap_or_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i8* [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp uge i8* %y, %x
  %cmpeq = icmp eq i8* %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ule_swap_or_min_commute(i8* %x, i8* %y)  {
; CHECK-LABEL: @ule_swap_or_min_commute(
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i8* [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp uge i8* %y, %x
  %cmpeq = icmp eq i8* %x, null
  %r = or i1 %cmpeq, %cmp
  ret i1 %r
}

; Negative test - signed compare

define i1 @sle_or_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @sle_or_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i8* [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp eq i8* [[X]], null
; CHECK-NEXT:    [[R:%.*]] = or i1 [[CMP]], [[CMPEQ]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp sle i8* %x, %y
  %cmpeq = icmp eq i8* %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; (X != null) && (X > Y) --> X > Y
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i1 @ugt_and_not_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @ugt_and_not_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8* [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp ugt i8* %x, %y
  %cmpeq = icmp ne i8* %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ugt_and_not_min_commute(i8* %x, i8* %y)  {
; CHECK-LABEL: @ugt_and_not_min_commute(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8* [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp ugt i8* %x, %y
  %cmpeq = icmp ne i8* %x, null
  %r = and i1 %cmpeq, %cmp
  ret i1 %r
}

define i1 @ugt_swap_and_not_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @ugt_swap_and_not_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8* [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp ult i8* %y, %x
  %cmpeq = icmp ne i8* %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ugt_swap_and_not_min_commute(i8* %x, i8* %y)  {
; CHECK-LABEL: @ugt_swap_and_not_min_commute(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8* [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp ult i8* %y, %x
  %cmpeq = icmp ne i8* %x, null
  %r = and i1 %cmpeq, %cmp
  ret i1 %r
}

; Negative test - signed compare

define i1 @sgt_and_not_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @sgt_and_not_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8* [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne i8* [[X]], null
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP]], [[CMPEQ]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp sgt i8* %x, %y
  %cmpeq = icmp ne i8* %x, null
  %r = and i1 %cmp, %cmpeq
  ret i1 %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; (X != null) || (X > Y) --> X != null
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i1 @ugt_or_not_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @ugt_or_not_min(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne i8* [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp ugt i8* %x, %y
  %cmpeq = icmp ne i8* %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ugt_or_not_min_commute(i8* %x, i8* %y)  {
; CHECK-LABEL: @ugt_or_not_min_commute(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne i8* [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp ugt i8* %x, %y
  %cmpeq = icmp ne i8* %x, null
  %r = or i1 %cmpeq, %cmp
  ret i1 %r
}

define i1 @ugt_swap_or_not_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @ugt_swap_or_not_min(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne i8* [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp ult i8* %y, %x
  %cmpeq = icmp ne i8* %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}

define i1 @ugt_swap_or_not_min_commute(i823* %x, i823* %y)  {
; CHECK-LABEL: @ugt_swap_or_not_min_commute(
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne i823* [[X:%.*]], null
; CHECK-NEXT:    ret i1 [[CMPEQ]]
;
  %cmp = icmp ult i823* %y, %x
  %cmpeq = icmp ne i823* %x, null
  %r = or i1 %cmpeq, %cmp
  ret i1 %r
}

; Negative test - signed compare

define i1 @sgt_or_not_min(i8* %x, i8* %y)  {
; CHECK-LABEL: @sgt_or_not_min(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8* [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPEQ:%.*]] = icmp ne i8* [[X]], null
; CHECK-NEXT:    [[R:%.*]] = or i1 [[CMP]], [[CMPEQ]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp sgt i8* %x, %y
  %cmpeq = icmp ne i8* %x, null
  %r = or i1 %cmp, %cmpeq
  ret i1 %r
}
