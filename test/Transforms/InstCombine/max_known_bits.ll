; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

define i16 @foo(i16 %x)  {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[T1:%.*]] = and i16 [[X:%.*]], 255
; CHECK-NEXT:    ret i16 [[T1]]
;
  %t1 = and i16 %x, 255
  %t2 = zext i16 %t1 to i32
  %t3 = icmp ult i32 %t2, 255
  %t4 = select i1 %t3, i32 %t2, i32 255
  %t5 = trunc i32 %t4 to i16
  %t6 = and i16 %t5, 255
  ret i16 %t6
}

; This contains a min/max pair to clamp a value to 12 bits.
; By analyzing the clamp pattern, we can tell the add doesn't have signed overflow.
define i16 @min_max_clamp(i16 %x) {
; CHECK-LABEL: @min_max_clamp(
; CHECK-NEXT:    [[A:%.*]] = icmp sgt i16 [[X:%.*]], -2048
; CHECK-NEXT:    [[B:%.*]] = select i1 [[A]], i16 [[X]], i16 -2048
; CHECK-NEXT:    [[C:%.*]] = icmp slt i16 [[B]], 2047
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i16 [[B]], i16 2047
; CHECK-NEXT:    [[E:%.*]] = add nsw i16 [[D]], 1
; CHECK-NEXT:    ret i16 [[E]]
;
  %a = icmp sgt i16 %x, -2048
  %b = select i1 %a, i16 %x, i16 -2048
  %c = icmp slt i16 %b, 2047
  %d = select i1 %c, i16 %b, i16 2047
  %e = add i16 %d, 1
  ret i16 %e
}

; Same as above with min/max reversed.
define i16 @min_max_clamp_2(i16 %x) {
; CHECK-LABEL: @min_max_clamp_2(
; CHECK-NEXT:    [[A:%.*]] = icmp slt i16 [[X:%.*]], 2047
; CHECK-NEXT:    [[B:%.*]] = select i1 [[A]], i16 [[X]], i16 2047
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i16 [[B]], -2048
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i16 [[B]], i16 -2048
; CHECK-NEXT:    [[E:%.*]] = add nsw i16 [[D]], 1
; CHECK-NEXT:    ret i16 [[E]]
;
  %a = icmp slt i16 %x, 2047
  %b = select i1 %a, i16 %x, i16 2047
  %c = icmp sgt i16 %b, -2048
  %d = select i1 %c, i16 %b, i16 -2048
  %e = add i16 %d, 1
  ret i16 %e
}

; This contains a min/max pair to clamp a value to 12 bits.
; By analyzing the clamp pattern, we can tell that the second add doesn't
; overflow the original type and can be moved before the extend.
define i32 @min_max_clamp_3(i16 %x) {
; CHECK-LABEL: @min_max_clamp_3(
; CHECK-NEXT:    [[A:%.*]] = icmp sgt i16 [[X:%.*]], -2048
; CHECK-NEXT:    [[B:%.*]] = select i1 [[A]], i16 [[X]], i16 -2048
; CHECK-NEXT:    [[C:%.*]] = icmp slt i16 [[B]], 2047
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i16 [[B]], i16 2047
; CHECK-NEXT:    [[TMP1:%.*]] = sext i16 [[D]] to i32
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %a = icmp sgt i16 %x, -2048
  %b = select i1 %a, i16 %x, i16 -2048
  %c = icmp slt i16 %b, 2047
  %d = select i1 %c, i16 %b, i16 2047
  %e = add i16 %d, 1
  %f = sext i16 %e to i32
  %g = add i32 %f, -1
  ret i32 %g
}

; Same as above with min/max order reversed
define i32 @min_max_clamp_4(i16 %x) {
; CHECK-LABEL: @min_max_clamp_4(
; CHECK-NEXT:    [[A:%.*]] = icmp slt i16 [[X:%.*]], 2047
; CHECK-NEXT:    [[B:%.*]] = select i1 [[A]], i16 [[X]], i16 2047
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i16 [[B]], -2048
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i16 [[B]], i16 -2048
; CHECK-NEXT:    [[TMP1:%.*]] = sext i16 [[D]] to i32
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %a = icmp slt i16 %x, 2047
  %b = select i1 %a, i16 %x, i16 2047
  %c = icmp sgt i16 %b, -2048
  %d = select i1 %c, i16 %b, i16 -2048
  %e = add i16 %d, 1
  %f = sext i16 %e to i32
  %g = add i32 %f, -1
  ret i32 %g
}

; Intrinsic versions of the above tests.

declare i16 @llvm.smin.i16(i16, i16)
declare i16 @llvm.smax.i16(i16, i16)

define i16 @min_max_clamp_intrinsic(i16 %x) {
; CHECK-LABEL: @min_max_clamp_intrinsic(
; CHECK-NEXT:    [[A:%.*]] = call i16 @llvm.smax.i16(i16 [[X:%.*]], i16 -2048)
; CHECK-NEXT:    [[B:%.*]] = call i16 @llvm.smin.i16(i16 [[A]], i16 2047)
; CHECK-NEXT:    [[C:%.*]] = add nsw i16 [[B]], 1
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = call i16 @llvm.smax.i16(i16 %x, i16 -2048)
  %b = call i16 @llvm.smin.i16(i16 %a, i16 2047)
  %c = add i16 %b, 1
  ret i16 %c
}

define i16 @min_max_clamp_intrinsic_2(i16 %x) {
; CHECK-LABEL: @min_max_clamp_intrinsic_2(
; CHECK-NEXT:    [[A:%.*]] = call i16 @llvm.smin.i16(i16 [[X:%.*]], i16 2047)
; CHECK-NEXT:    [[B:%.*]] = call i16 @llvm.smax.i16(i16 [[A]], i16 -2048)
; CHECK-NEXT:    [[C:%.*]] = add nsw i16 [[B]], 1
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = call i16 @llvm.smin.i16(i16 %x, i16 2047)
  %b = call i16 @llvm.smax.i16(i16 %a, i16 -2048)
  %c = add i16 %b, 1
  ret i16 %c
}

define i32 @min_max_clamp_intrinsic_3(i16 %x) {
; CHECK-LABEL: @min_max_clamp_intrinsic_3(
; CHECK-NEXT:    [[A:%.*]] = call i16 @llvm.smax.i16(i16 [[X:%.*]], i16 -2048)
; CHECK-NEXT:    [[B:%.*]] = call i16 @llvm.smin.i16(i16 [[A]], i16 2047)
; CHECK-NEXT:    [[TMP1:%.*]] = sext i16 [[B]] to i32
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %a = call i16 @llvm.smax.i16(i16 %x, i16 -2048)
  %b = call i16 @llvm.smin.i16(i16 %a, i16 2047)
  %c = add i16 %b, 1
  %d = sext i16 %c to i32
  %e = add i32 %d, -1
  ret i32 %e
}

define i32 @min_max_clamp_intrinsic_4(i16 %x) {
; CHECK-LABEL: @min_max_clamp_intrinsic_4(
; CHECK-NEXT:    [[A:%.*]] = call i16 @llvm.smin.i16(i16 [[X:%.*]], i16 2047)
; CHECK-NEXT:    [[B:%.*]] = call i16 @llvm.smax.i16(i16 [[A]], i16 -2048)
; CHECK-NEXT:    [[TMP1:%.*]] = sext i16 [[B]] to i32
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %a = call i16 @llvm.smin.i16(i16 %x, i16 2047)
  %b = call i16 @llvm.smax.i16(i16 %a, i16 -2048)
  %c = add i16 %b, 1
  %d = sext i16 %c to i32
  %e = add i32 %d, -1
  ret i32 %e
}
