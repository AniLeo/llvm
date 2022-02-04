; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; %cmp should not vanish
define i1 @f(i32 %i1) {
; CHECK-LABEL: @f(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I1:%.*]], 0
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 7, [[I1]]
; CHECK-NEXT:    [[CMP4:%.*]] = icmp slt i32 [[SHR]], [[I1]]
; CHECK-NEXT:    [[I2:%.*]] = select i1 [[CMP]], i1 true, i1 [[CMP4]]
; CHECK-NEXT:    ret i1 [[I2]]
;
entry:
  %cmp = icmp slt i32 %i1, 0
  %shr = ashr i32 7, %i1
  %cmp4 = icmp sgt i32 %i1, %shr
  %i2 = select i1 %cmp, i1 true, i1 %cmp4
  ret i1 %i2
}

; %cmp should not vanish
define i32 @f2(i32 signext %g, i32 zeroext %h) {
; CHECK-LABEL: @f2(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[G:%.*]], 0
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 7, [[H:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[SHR]], [[G]]
; CHECK-NEXT:    [[DOT0:%.*]] = select i1 [[CMP]], i1 true, i1 [[CMP1]]
; CHECK-NEXT:    [[LOR_EXT:%.*]] = zext i1 [[DOT0]] to i32
; CHECK-NEXT:    ret i32 [[LOR_EXT]]
;
  %cmp = icmp slt i32 %g, 0
  %shr = ashr i32 7, %h
  %cmp1 = icmp sgt i32 %g, %shr
  %.0 = select i1 %cmp, i1 true, i1 %cmp1
  %lor.ext = zext i1 %.0 to i32
  ret i32 %lor.ext
}
