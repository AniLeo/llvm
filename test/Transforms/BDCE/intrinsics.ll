; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -bdce < %s | FileCheck %s

declare i8 @llvm.umax.i8(i8, i8)
declare i8 @llvm.umin.i8(i8, i8)
declare i8 @llvm.smax.i8(i8, i8)
declare i8 @llvm.smin.i8(i8, i8)

define i8 @umax(i8 %x, i8 %y, i1 %a, i1 %b) {
; CHECK-LABEL: @umax(
; CHECK-NEXT:    [[A2:%.*]] = zext i1 [[A:%.*]] to i8
; CHECK-NEXT:    [[B2:%.*]] = zext i1 [[B:%.*]] to i8
; CHECK-NEXT:    [[X2:%.*]] = or i8 [[X:%.*]], [[A2]]
; CHECK-NEXT:    [[Y2:%.*]] = or i8 [[Y:%.*]], [[B2]]
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umax.i8(i8 [[X2]], i8 [[Y2]])
; CHECK-NEXT:    [[R:%.*]] = lshr i8 [[M]], 1
; CHECK-NEXT:    ret i8 [[R]]
;
  %a2 = zext i1 %a to i8
  %b2 = zext i1 %b to i8
  %x2 = or i8 %x, %a2
  %y2 = or i8 %y, %b2
  %m = call i8 @llvm.umax.i8(i8 %x2, i8 %y2)
  %r = lshr i8 %m, 1
  ret i8 %r
}

define i8 @umin(i8 %x, i8 %y, i1 %a, i1 %b) {
; CHECK-LABEL: @umin(
; CHECK-NEXT:    [[A2:%.*]] = zext i1 [[A:%.*]] to i8
; CHECK-NEXT:    [[B2:%.*]] = zext i1 [[B:%.*]] to i8
; CHECK-NEXT:    [[X2:%.*]] = or i8 [[X:%.*]], [[A2]]
; CHECK-NEXT:    [[Y2:%.*]] = or i8 [[Y:%.*]], [[B2]]
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umin.i8(i8 [[X2]], i8 [[Y2]])
; CHECK-NEXT:    [[R:%.*]] = lshr i8 [[M]], 1
; CHECK-NEXT:    ret i8 [[R]]
;
  %a2 = zext i1 %a to i8
  %b2 = zext i1 %b to i8
  %x2 = or i8 %x, %a2
  %y2 = or i8 %y, %b2
  %m = call i8 @llvm.umin.i8(i8 %x2, i8 %y2)
  %r = lshr i8 %m, 1
  ret i8 %r
}

define i8 @smax(i8 %x, i8 %y, i1 %a, i1 %b) {
; CHECK-LABEL: @smax(
; CHECK-NEXT:    [[A2:%.*]] = zext i1 [[A:%.*]] to i8
; CHECK-NEXT:    [[B2:%.*]] = zext i1 [[B:%.*]] to i8
; CHECK-NEXT:    [[X2:%.*]] = or i8 [[X:%.*]], [[A2]]
; CHECK-NEXT:    [[Y2:%.*]] = or i8 [[Y:%.*]], [[B2]]
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smax.i8(i8 [[X2]], i8 [[Y2]])
; CHECK-NEXT:    [[R:%.*]] = lshr i8 [[M]], 1
; CHECK-NEXT:    ret i8 [[R]]
;
  %a2 = zext i1 %a to i8
  %b2 = zext i1 %b to i8
  %x2 = or i8 %x, %a2
  %y2 = or i8 %y, %b2
  %m = call i8 @llvm.smax.i8(i8 %x2, i8 %y2)
  %r = lshr i8 %m, 1
  ret i8 %r
}

define i8 @smin(i8 %x, i8 %y, i1 %a, i1 %b) {
; CHECK-LABEL: @smin(
; CHECK-NEXT:    [[A2:%.*]] = zext i1 [[A:%.*]] to i8
; CHECK-NEXT:    [[B2:%.*]] = zext i1 [[B:%.*]] to i8
; CHECK-NEXT:    [[X2:%.*]] = or i8 [[X:%.*]], [[A2]]
; CHECK-NEXT:    [[Y2:%.*]] = or i8 [[Y:%.*]], [[B2]]
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smin.i8(i8 [[X2]], i8 [[Y2]])
; CHECK-NEXT:    [[R:%.*]] = lshr i8 [[M]], 1
; CHECK-NEXT:    ret i8 [[R]]
;
  %a2 = zext i1 %a to i8
  %b2 = zext i1 %b to i8
  %x2 = or i8 %x, %a2
  %y2 = or i8 %y, %b2
  %m = call i8 @llvm.smin.i8(i8 %x2, i8 %y2)
  %r = lshr i8 %m, 1
  ret i8 %r
}
