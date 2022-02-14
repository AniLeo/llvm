; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Instcombine normally would fold the sdiv into the comparison,
; making "icmp slt i32 %h, 2", but in this case the sdiv has
; another use, so it wouldn't a big win, and it would also
; obfuscate an otherise obvious smax pattern to the point where
; other analyses wouldn't recognize it.

define i32 @foo(i32 %h) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[SD:%.*]] = sdiv i32 [[H:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.smin.i32(i32 [[SD]], i32 1)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %sd = sdiv i32 %h, 2
  %t = icmp slt i32 %sd, 1
  %r = select i1 %t, i32 %sd, i32 1
  ret i32 %r
}

define i32 @bar(i32 %h) {
; CHECK-LABEL: @bar(
; CHECK-NEXT:    [[SD:%.*]] = sdiv i32 [[H:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.smax.i32(i32 [[SD]], i32 1)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %sd = sdiv i32 %h, 2
  %t = icmp sgt i32 %sd, 1
  %r = select i1 %t, i32 %sd, i32 1
  ret i32 %r
}
