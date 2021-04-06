; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -O2 -S < %s -enable-new-pm=0 | FileCheck %s
; RUN: opt -passes='default<O2>' -S < %s | FileCheck %s

define void @PR45687(i32 %0)  {
; CHECK-LABEL: @PR45687(
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[TMP0:%.*]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ult i32 [[TMP2]], 3
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP3]])
; CHECK-NEXT:    ret void
;
  %2 = add i32 %0, 1
  %3 = icmp ult i32 %2, 3
  tail call void @llvm.assume(i1 %3)
  %4 = icmp slt i32 %0, 0
  %5 = sub nsw i32 0, %0
  %6 = select i1 %4, i32 %5, i32 %0
  %7 = icmp sgt i32 %6, 1
  br i1 %7, label %8, label %9
8:
  tail call void @g()
  br label %9
9:
  ret void
}

declare void @llvm.assume(i1)

declare void @g()
